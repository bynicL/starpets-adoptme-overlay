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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 945.68, ["Ride"] = 985.71, ["Fly|Ride"] = 1095.59, ["Neon"] = 9187.5, ["Neon|Fly|Ride"] = 3921.75, ["Mega|Fly|Ride"] = 24642.63}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 494.81, ["Fly"] = 551.25, ["Ride"] = 458.06, ["Fly|Ride"] = 545.23, ["Neon|Fly|Ride"] = 2464.27, ["Mega"] = 10267.77}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 5381.25, ["Ride"] = 5066.25, ["Fly|Ride"] = 4374.56, ["Neon|Fly|Ride"] = 19851.69, ["Mega|Fly|Ride"] = 68452.09}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 131.25, ["Ride"] = 162.75, ["Fly|Ride"] = 308.04, ["Neon"] = 771.96, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 1095.59, ["Mega"] = 4107.11, ["Mega|Fly|Ride"] = 2887.5}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 584.72, ["Fly"] = 821.44, ["Ride"] = 551.25, ["Fly|Ride"] = 580.13, ["Neon|Ride"] = 1785, ["Neon|Fly|Ride"] = 1614.85, ["Mega|Fly|Ride"] = 6300}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 8.24, ["Ride"] = 27.57, ["Fly|Ride"] = 151.97, ["Neon"] = 72.19, ["Neon|Ride"] = 77.56, ["Neon|Fly|Ride"] = 274.16, ["Mega"] = 285.27, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.12, ["Fly"] = 41.09, ["Ride"] = 31.5, ["Fly|Ride"] = 57.75, ["Neon"] = 32.82, ["Neon|Fly"] = 80.07, ["Neon|Ride"] = 54.27, ["Neon|Fly|Ride"] = 112.03, ["Mega"] = 130.54, ["Mega|Fly"] = 270.8, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 280.88}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 130.41, ["Ride"] = 184.83, ["Fly|Ride"] = 231.04, ["Neon"] = 656.25, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 462.91, ["Mega"] = 1416.96, ["Mega|Fly|Ride"] = 2628.55}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 30.48, ["Fly"] = 55.46, ["Ride"] = 51.16, ["Fly|Ride"] = 92.59, ["Neon"] = 249.38, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 309, ["Mega"] = 1369.74, ["Mega|Ride"] = 2730, ["Mega|Fly|Ride"] = 1277.07}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 19.69, ["Fly"] = 48.87, ["Ride"] = 36.75, ["Fly|Ride"] = 65.63, ["Neon"] = 192.03, ["Neon|Ride"] = 82.16, ["Neon|Fly|Ride"] = 271.08, ["Mega|Ride"] = 1333.8, ["Mega|Fly|Ride"] = 684.88}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 68.25, ["Fly"] = 206.07, ["Ride"] = 72.19, ["Fly|Ride"] = 137.61, ["Neon"] = 439.81, ["Neon|Fly"] = 408.68, ["Neon|Ride"] = 274.16, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1575.09}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 55.57}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 302.91, ["Fly"] = 395, ["Ride"] = 349.12, ["Fly|Ride"] = 387.45, ["Neon"] = 1420.07, ["Neon|Ride"] = 1257.92, ["Neon|Fly|Ride"] = 1087.64, ["Mega|Fly|Ride"] = 4778.63}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 105, ["Fly"] = 122.22, ["Ride"] = 120.75, ["Fly|Ride"] = 178.22, ["Neon|Ride"] = 564.38, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2622.27}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.62, ["Fly"] = 113.98, ["Ride"] = 51.85, ["Fly|Ride"] = 205.37, ["Neon"] = 26.25, ["Neon|Fly"] = 96.41, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 137.61, ["Mega"] = 144.38, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 370.33}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 122.85, ["Fly"] = 144.38, ["Ride"] = 153.57, ["Fly|Ride"] = 215.14, ["Neon"] = 925.88, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 485.63, ["Mega|Fly|Ride"] = 1967.44}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.27, ["Fly"] = 26.63, ["Ride"] = 20.99, ["Fly|Ride"] = 46.92, ["Neon"] = 27.57, ["Neon|Ride"] = 90.37, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 315, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 77.97, ["Fly"] = 262.5, ["Ride"] = 132.98, ["Fly|Ride"] = 280.06, ["Neon"] = 343.01, ["Neon|Fly"] = 462.91, ["Neon|Ride"] = 288.74, ["Neon|Fly|Ride"] = 420, ["Mega"] = 1492.95, ["Mega|Ride"] = 787.4, ["Mega|Fly|Ride"] = 1102.5}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 41.99}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 45.21, ["Ride"] = 96.54, ["Fly|Ride"] = 255.29, ["Neon"] = 577.5, ["Neon|Ride"] = 684.88, ["Neon|Fly|Ride"] = 2362.5}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 16.91, ["Fly"] = 34.49, ["Ride"] = 39.36, ["Fly|Ride"] = 223.13, ["Neon"] = 203.32, ["Neon|Ride"] = 96.54, ["Neon|Fly|Ride"] = 246.44, ["Mega|Ride"] = 572.96, ["Mega|Fly|Ride"] = 548.31}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 42.7, ["Fly"] = 123.84, ["Ride"] = 55.1, ["Fly|Ride"] = 109.67, ["Neon"] = 205.37, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 236.91, ["Mega"] = 1620.12, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 52.5, ["Fly"] = 274.16, ["Ride"] = 123.84, ["Fly|Ride"] = 136.5, ["Neon"] = 204.75, ["Neon|Ride"] = 270.05, ["Neon|Fly|Ride"] = 305.99, ["Mega"] = 1066.84, ["Mega|Ride"] = 1228.03, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 39.38, ["Ride"] = 40.06, ["Fly|Ride"] = 131.25, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 315, ["Mega"] = 768.04, ["Mega|Ride"] = 2051.52, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 46.31, ["Fly"] = 136.75, ["Ride"] = 65.63, ["Fly|Ride"] = 145.83, ["Neon"] = 210, ["Neon|Fly"] = 549.33, ["Neon|Ride"] = 293.95, ["Neon|Fly|Ride"] = 367.38, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 943.69}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 5.92, ["Fly"] = 30.1, ["Ride"] = 22.23, ["Fly|Ride"] = 41.09, ["Neon"] = 26.25, ["Neon|Fly"] = 104.99, ["Neon|Ride"] = 39.36, ["Neon|Fly|Ride"] = 90.95, ["Mega"] = 145.77, ["Mega|Fly"] = 22427.05, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 298.6}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 393.75, ["Ride"] = 394.2, ["Fly|Ride"] = 442.32, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1680, ["Mega|Fly|Ride"] = 7253.16}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 15.65, ["Ride"] = 32.45, ["Fly|Ride"] = 107.34, ["Neon"] = 219.19, ["Neon|Fly|Ride"] = 418.94}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 5.72, ["Fly"] = 39.87, ["Ride"] = 27.57, ["Fly|Ride"] = 53.6, ["Neon"] = 51.07, ["Neon|Fly"] = 90.37, ["Neon|Ride"] = 80.1, ["Neon|Fly|Ride"] = 123.38, ["Mega|Ride"] = 619.5, ["Mega|Fly|Ride"] = 408.68}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 78.25, ["Fly"] = 108.94, ["Ride"] = 102.73, ["Fly|Ride"] = 123.31, ["Neon|Fly"] = 452.82, ["Neon|Ride"] = 385.75, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 2049.47, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 1990.83}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 13.12, ["Ride"] = 27.84, ["Fly|Ride"] = 75.22, ["Neon"] = 151.2, ["Neon|Ride"] = 174.57, ["Neon|Fly|Ride"] = 161.44, ["Mega"] = 694.35, ["Mega|Ride"] = 779.35, ["Mega|Fly|Ride"] = 483}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 219.75, ["Fly"] = 347.07, ["Ride"] = 239.44, ["Fly|Ride"] = 258.51, ["Neon"] = 694.42, ["Neon|Ride"] = 616.07, ["Neon|Fly|Ride"] = 877.91, ["Mega"] = 6160.67, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2864.72}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 68.25}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.73, ["Fly"] = 35.59, ["Ride"] = 22.6, ["Fly|Ride"] = 64.32, ["Neon"] = 22.32, ["Neon|Fly"] = 4879.62, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 143.76, ["Mega"] = 157.5, ["Mega|Fly"] = 342.97, ["Mega|Ride"] = 246.44, ["Mega|Fly|Ride"] = 284.82}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 1543.5, ["Fly"] = 2625, ["Ride"] = 2053.57, ["Fly|Ride"] = 2869.89, ["Neon"] = 7158.38, ["Neon|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 7290.94, ["Mega|Ride"] = 52074.85, ["Mega|Fly|Ride"] = 25874.77}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 10.48, ["Fly"] = 67.78, ["Ride"] = 32.8, ["Fly|Ride"] = 131.25, ["Neon"] = 102.69, ["Neon|Ride"] = 111.56, ["Neon|Fly|Ride"] = 217.7, ["Mega"] = 508.27, ["Mega|Ride"] = 657.16, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 115.5, ["Ride"] = 170.63, ["Fly|Ride"] = 249.38, ["Neon"] = 890.23, ["Neon|Ride"] = 752.2, ["Neon|Fly|Ride"] = 794.74, ["Mega|Ride"] = 2916.06, ["Mega|Fly|Ride"] = 2601.87}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 43.23}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 19.69, ["Fly"] = 68.84, ["Ride"] = 52.28, ["Fly|Ride"] = 137.61, ["Neon"] = 81.34, ["Neon|Ride"] = 155.09, ["Neon|Fly|Ride"] = 287.01, ["Mega"] = 670.9, ["Mega|Fly|Ride"] = 725.6}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 110.97, ["Ride"] = 407.58, ["Fly|Ride"] = 196.88, ["Neon"] = 584.07, ["Neon|Ride"] = 684.88, ["Neon|Fly|Ride"] = 697.19, ["Mega|Fly|Ride"] = 2053.57}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 141.75, ["Ride"] = 150.94, ["Fly|Ride"] = 189, ["Neon"] = 431.26, ["Neon|Ride"] = 364.88, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 1509.37, ["Mega|Fly|Ride"] = 1778.39}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 52.5}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 51.18, ["Fly"] = 59.16, ["Ride"] = 54.36, ["Fly|Ride"] = 77.09, ["Neon"] = 616.07, ["Neon|Ride"] = 393.47, ["Neon|Fly|Ride"] = 292.48, ["Mega"] = 4107.11, ["Mega|Fly|Ride"] = 1509.38}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 9.18, ["Ride"] = 39.36, ["Fly|Ride"] = 131.25, ["Neon"] = 39.03, ["Neon|Ride"] = 123.65, ["Neon|Fly|Ride"] = 231.04, ["Mega"] = 166.07, ["Mega|Ride"] = 271.08, ["Mega|Fly|Ride"] = 409.5}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 380.63, ["Fly"] = 426.57, ["Ride"] = 456.57, ["Fly|Ride"] = 497.2, ["Neon|Ride"] = 1697.66, ["Neon|Fly|Ride"] = 1449.37, ["Mega|Fly|Ride"] = 6273.75}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 103.69, ["Fly"] = 131.25, ["Ride"] = 85.32, ["Fly|Ride"] = 155.03, ["Neon"] = 446.25, ["Neon|Ride"] = 486.7, ["Neon|Fly|Ride"] = 520.58, ["Mega|Ride"] = 2450.94, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3696, ["Ride"] = 3433.5, ["Fly|Ride"] = 3674.99, ["Neon|Fly|Ride"] = 14373.84}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 40.85, ["Fly"] = 108.86, ["Ride"] = 55.13, ["Fly|Ride"] = 91.88, ["Neon"] = 393.75, ["Neon|Ride"] = 274.16, ["Neon|Fly|Ride"] = 302.91, ["Mega|Ride"] = 1178.76, ["Mega|Fly|Ride"] = 1367.68}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 61.76, ["Ride"] = 68.8, ["Fly|Ride"] = 137.61, ["Neon"] = 577.54, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 684.88, ["Mega"] = 2327.72, ["Mega|Fly|Ride"] = 1661.34}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 36.11, ["Fly"] = 77.97, ["Ride"] = 60.37, ["Fly|Ride"] = 118.31, ["Neon"] = 160.63, ["Neon|Ride"] = 137.61, ["Neon|Fly|Ride"] = 189.62, ["Mega"] = 2625, ["Mega|Ride"] = 819.32, ["Mega|Fly|Ride"] = 586.69}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 7.88}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 45.94, ["Ride"] = 47.25, ["Fly|Ride"] = 72.19, ["Neon"] = 328.13, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 542.15, ["Mega|Fly|Ride"] = 1836.52}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 46.33}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 197.16, ["Ride"] = 205.37, ["Fly|Ride"] = 246.44, ["Neon|Ride"] = 1388.68, ["Neon|Fly|Ride"] = 2224.22, ["Mega|Fly|Ride"] = 4937.86}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 918.75, ["Ride"] = 938.44, ["Fly|Ride"] = 1045.8, ["Neon|Ride"] = 3285.71, ["Neon|Fly|Ride"] = 3559.85}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 9.18}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 28.41, ["Fly"] = 62.62, ["Ride"] = 38.57, ["Fly|Ride"] = 68.81, ["Neon"] = 178.5, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 219.89, ["Mega|Fly|Ride"] = 849.41}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 12.78}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 6283.89, ["Fly|Ride"] = 4588.5, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 36553.23}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 13.13, ["Fly"] = 62.51, ["Ride"] = 27.74, ["Fly|Ride"] = 60.38, ["Neon"] = 97.02, ["Neon|Ride"] = 102.69, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 633.02, ["Mega|Ride"] = 1506.29, ["Mega|Fly|Ride"] = 597.19}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 8.9, ["Fly"] = 41.09, ["Ride"] = 35.44, ["Fly|Ride"] = 109.88, ["Neon"] = 111.57, ["Neon|Ride"] = 132.57, ["Neon|Fly|Ride"] = 244.38, ["Mega"] = 1029.94, ["Mega|Ride"] = 501.09, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 94.5, ["Fly"] = 65.63, ["Ride"] = 91.86, ["Fly|Ride"] = 89.25, ["Neon"] = 1369.74, ["Neon|Fly|Ride"] = 925.79, ["Mega"] = 4107.11}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 11.81, ["Ride"] = 27.57, ["Fly|Ride"] = 106.8, ["Neon"] = 93.19, ["Neon|Ride"] = 63.68, ["Neon|Fly|Ride"] = 501.37, ["Mega"] = 262.5, ["Mega|Ride"] = 466.17, ["Mega|Fly|Ride"] = 617.97}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1968.65, ["Fly"] = 1837.5, ["Ride"] = 2191.7, ["Fly|Ride"] = 2047.5, ["Neon|Fly|Ride"] = 3953.25, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 29400, ["Fly"] = 26250, ["Ride"] = 52500, ["Fly|Ride"] = 24215.63, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 67767.23, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183750}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 18.37, ["Fly"] = 157.5, ["Ride"] = 49.77, ["Fly|Ride"] = 89.93, ["Neon"] = 134.93, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 274.16, ["Mega"] = 821.44, ["Mega|Ride"] = 682.5, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.62, ["Fly"] = 48.27, ["Ride"] = 43.32, ["Fly|Ride"] = 131.25, ["Neon"] = 16.89, ["Neon|Fly"] = 96.54, ["Neon|Ride"] = 55.46, ["Neon|Fly|Ride"] = 147.94, ["Mega"] = 151.97, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 309}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 38.97}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 6.49, ["Ride"] = 36.75, ["Fly|Ride"] = 111.57, ["Neon"] = 41.09, ["Neon|Ride"] = 96.54, ["Neon|Fly|Ride"] = 463.21, ["Mega"] = 342.97, ["Mega|Ride"] = 305.82, ["Mega|Fly|Ride"] = 545.35}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 739.29, ["Ride"] = 675.94, ["Fly|Ride"] = 778.24, ["Neon|Ride"] = 2893.06, ["Neon|Fly|Ride"] = 2580.62, ["Mega|Fly|Ride"] = 10801.49}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 997.5, ["Fly"] = 962.07, ["Ride"] = 857.46, ["Fly|Ride"] = 892.5, ["Neon"] = 3491.04, ["Neon|Ride"] = 3349.01, ["Neon|Fly|Ride"] = 3109.31, ["Mega|Fly|Ride"] = 11189.81}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 23.23, ["Fly"] = 115.74, ["Ride"] = 45.14, ["Fly|Ride"] = 98.44, ["Neon"] = 101.07, ["Neon|Ride"] = 137.61, ["Neon|Fly|Ride"] = 201.27, ["Mega"] = 1026.81, ["Mega|Ride"] = 685.13, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 39.38}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 61.72, ["Fly"] = 111.57, ["Ride"] = 76.01, ["Fly|Ride"] = 137.04, ["Neon|Ride"] = 384.03, ["Neon|Fly|Ride"] = 341.25, ["Mega|Ride"] = 2010.45, ["Mega|Fly|Ride"] = 1915.97}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 61.6, ["Ride"] = 64.31, ["Fly|Ride"] = 228.38, ["Neon"] = 328.58, ["Neon|Fly"] = 527.79, ["Neon|Ride"] = 390.18, ["Neon|Fly|Ride"] = 491.57, ["Mega"] = 1725, ["Mega|Fly|Ride"] = 1715.18}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.9, ["Fly"] = 47.24, ["Ride"] = 20, ["Fly|Ride"] = 68.81, ["Neon"] = 39.38, ["Neon|Fly"] = 525, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 205.37, ["Mega"] = 236.25, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 97.46, ["Fly"] = 126, ["Ride"] = 124.09, ["Fly|Ride"] = 152.25, ["Neon"] = 803.98, ["Neon|Ride"] = 410.73, ["Neon|Fly|Ride"] = 353.07, ["Mega|Fly|Ride"] = 1388.18}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 6.17, ["Ride"] = 26.25, ["Fly|Ride"] = 135.55, ["Neon"] = 53.45, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 203.44, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 14.73, ["Fly"] = 40.28, ["Ride"] = 34.13, ["Fly|Ride"] = 78.75, ["Neon"] = 102.69, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 171.28, ["Mega"] = 725.94, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 26.24, ["Ride"] = 62.51, ["Fly|Ride"] = 156.19, ["Neon"] = 245.44, ["Neon|Ride"] = 324.48, ["Mega"] = 694.25, ["Mega|Ride"] = 808.1, ["Mega|Fly|Ride"] = 862.51}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 18.5, ["Fly"] = 137.61, ["Ride"] = 34.93, ["Fly|Ride"] = 145.69, ["Neon"] = 91.88, ["Neon|Fly"] = 548.31, ["Neon|Ride"] = 141.71, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 819.38, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6674.06, ["Fly"] = 6845.53, ["Ride"] = 6571.38, ["Fly|Ride"] = 5040, ["Neon"] = 30803.29, ["Neon|Fly|Ride"] = 27106.9}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 236.24, ["Fly"] = 262.7, ["Ride"] = 223.13, ["Fly|Ride"] = 284.39, ["Neon"] = 771.96, ["Neon|Fly|Ride"] = 584.71, ["Mega|Ride"] = 5476.85, ["Mega|Fly|Ride"] = 2094.41}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 38.43, ["Fly"] = 131.73, ["Ride"] = 80.01, ["Fly|Ride"] = 135.93, ["Neon"] = 108.54, ["Neon|Fly"] = 164.3, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 377.94, ["Mega|Fly"] = 548.31, ["Mega|Ride"] = 367.49, ["Mega|Fly|Ride"] = 458.07}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.91, ["Ride"] = 20.55, ["Fly|Ride"] = 96.54, ["Neon"] = 22.09, ["Neon|Ride"] = 55.46, ["Neon|Fly|Ride"] = 186.89, ["Mega"] = 499.8, ["Mega|Ride"] = 187.69}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 37.68, ["Fly"] = 5245.65, ["Ride"] = 97.61, ["Fly|Ride"] = 131.25, ["Neon"] = 151.97, ["Neon|Fly"] = 326.53, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 274.16, ["Mega"] = 422.67, ["Mega|Ride"] = 548.31, ["Mega|Fly|Ride"] = 584.73}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 13833.75, ["Ride"] = 12468.75, ["Fly|Ride"] = 11967.38, ["Neon|Fly|Ride"] = 26693.58}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 179.81, ["Fly"] = 274.16, ["Ride"] = 217.88, ["Fly|Ride"] = 196.88, ["Neon"] = 1406.7, ["Neon|Ride"] = 1506.29, ["Neon|Fly|Ride"] = 1369.74, ["Mega|Fly|Ride"] = 4634.87}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 81.02, ["Fly"] = 125, ["Ride"] = 64.31, ["Fly|Ride"] = 123.38, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 381.94, ["Mega|Fly|Ride"] = 2312.31}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 8.15, ["Fly"] = 28.53, ["Ride"] = 27.74, ["Fly|Ride"] = 59.56, ["Neon"] = 76.13, ["Neon|Ride"] = 68.83, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 2464.27, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 367.5, ["Fly"] = 486.04, ["Ride"] = 380.63, ["Fly|Ride"] = 462.9, ["Neon"] = 1639.32, ["Neon|Ride"] = 1622.32, ["Neon|Fly|Ride"] = 1509.38, ["Mega|Ride"] = 4593.75, ["Mega|Fly|Ride"] = 4933.69}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 5.8, ["Ride"] = 36.75, ["Neon"] = 30.18, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 216.42, ["Mega"] = 129.93, ["Mega|Ride"] = 196.82, ["Mega|Fly|Ride"] = 314.22}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 213.59, ["Ride"] = 232.05, ["Fly|Ride"] = 1050, ["Neon"] = 1025.77, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1048.69, ["Mega|Fly|Ride"] = 5476.85}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 13.01, ["Fly"] = 15.73, ["Ride"] = 17.07, ["Fly|Ride"] = 35.44, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 2464.27, ["Mega|Fly|Ride"] = 725.6}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 12.75}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 52.5, ["Ride"] = 86.63, ["Fly|Ride"] = 525, ["Neon"] = 315.24, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 3080.34, ["Mega"] = 1129.47, ["Mega|Ride"] = 1232.14, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 13.11, ["Fly"] = 101.67, ["Ride"] = 46.31, ["Fly|Ride"] = 86.52, ["Neon"] = 75.99, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 508.27, ["Mega|Ride"] = 614.02, ["Mega|Fly|Ride"] = 546}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 19.69}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 27.75, ["Fly"] = 111.57, ["Ride"] = 90.98, ["Fly|Ride"] = 308.99, ["Neon"] = 237.57, ["Neon|Ride"] = 258.54, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 821.44, ["Mega|Ride"] = 918.98, ["Mega|Fly|Ride"] = 819.38}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.93, ["Fly|Ride"] = 131.94, ["Neon"] = 21.65, ["Neon|Ride"] = 104.16, ["Neon|Fly|Ride"] = 137.61, ["Mega"] = 129.94, ["Mega|Fly|Ride"] = 462.67}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 17.07, ["Fly"] = 44.63, ["Ride"] = 30.81, ["Fly|Ride"] = 77.44, ["Neon|Ride"] = 132.57, ["Neon|Fly|Ride"] = 217.7, ["Mega|Ride"] = 462.91, ["Mega|Fly|Ride"] = 800.89}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 447.85, ["Ride"] = 384.23, ["Fly|Ride"] = 409.5, ["Neon|Fly|Ride"] = 2601.87, ["Mega|Fly|Ride"] = 8624.93}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 39.38, ["Fly"] = 102.69, ["Ride"] = 45.94, ["Fly|Ride"] = 103.67, ["Neon"] = 223.13, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 233.09, ["Mega"] = 710.54, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 548.51}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 45.93, ["Fly"] = 92.59, ["Ride"] = 72.17, ["Fly|Ride"] = 150.45, ["Neon"] = 452.82, ["Neon|Ride"] = 226.93, ["Neon|Fly|Ride"] = 236.25, ["Mega|Fly|Ride"] = 1260.9}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 28.48, ["Fly"] = 78.75, ["Ride"] = 66.27, ["Fly|Ride"] = 157.5, ["Neon"] = 126, ["Neon|Ride"] = 168.4, ["Neon|Fly|Ride"] = 307.01, ["Mega"] = 328.13, ["Mega|Ride"] = 396.38, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 8491.88, ["Ride"] = 9995.9, ["Fly|Ride"] = 7872.38, ["Neon|Fly|Ride"] = 15054.38, ["Mega|Fly|Ride"] = 39373.69}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1509.38, ["Fly"] = 1851.54, ["Ride"] = 1509.38, ["Fly|Ride"] = 1536.94, ["Neon|Fly|Ride"] = 3990, ["Mega"] = 21905.25, ["Mega|Fly|Ride"] = 15093.75}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 479.07, ["Ride"] = 505.32, ["Fly|Ride"] = 508.27, ["Neon"] = 3780, ["Neon|Fly|Ride"] = 2191.16, ["Mega|Fly|Ride"] = 6664.82}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 12.89, ["Fly"] = 20.55, ["Ride"] = 26.63, ["Fly|Ride"] = 45.99, ["Neon"] = 108.78, ["Neon|Ride"] = 108.86, ["Neon|Fly|Ride"] = 164.3, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 6.33, ["Fly"] = 78.74, ["Ride"] = 164.3, ["Neon"] = 31.26, ["Neon|Ride"] = 67.78, ["Neon|Fly|Ride"] = 147, ["Mega"] = 166.47, ["Mega|Ride"] = 180.7, ["Mega|Fly|Ride"] = 271.69}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 41.09, ["Fly"] = 55.46, ["Ride"] = 45.93, ["Fly|Ride"] = 102.6, ["Neon"] = 271.08, ["Neon|Ride"] = 153.83, ["Neon|Fly|Ride"] = 170.63, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.86, ["Fly"] = 27.74, ["Ride"] = 20.55, ["Fly|Ride"] = 44.63, ["Neon"] = 25.76, ["Neon|Fly"] = 91.87, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 262.5, ["Mega|Ride"] = 205.37, ["Mega|Fly|Ride"] = 340.91}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 280.09, ["Fly"] = 320.25, ["Ride"] = 333.24, ["Fly|Ride"] = 372.26, ["Neon"] = 1234.9, ["Neon|Ride"] = 1149.75, ["Neon|Fly|Ride"] = 1210.13}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 19.68, ["Fly"] = 60.09, ["Ride"] = 40.68, ["Fly|Ride"] = 76.13, ["Neon"] = 139.65, ["Neon|Fly"] = 410.73, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 186.89, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 13.13, ["Fly"] = 26.63, ["Ride"] = 21.17, ["Fly|Ride"] = 43.14, ["Neon"] = 82.16, ["Neon|Fly"] = 131.94, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 545.05, ["Ride"] = 342.97, ["Fly|Ride"] = 643.8, ["Neon|Ride"] = 1642.87, ["Neon|Fly|Ride"] = 2314.45, ["Mega|Fly|Ride"] = 8619.19}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1115.63, ["Fly"] = 1388.66, ["Ride"] = 1205.45, ["Fly|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 154296.58}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 92.77, ["Fly"] = 123.22, ["Ride"] = 93.19, ["Fly|Ride"] = 109.91, ["Neon"] = 513.4, ["Neon|Ride"] = 1712.68, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 2327.72, ["Mega|Fly|Ride"] = 3859.33}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 171.49, ["Fly"] = 212.13, ["Ride"] = 191.1, ["Fly|Ride"] = 240.19, ["Neon"] = 439.69, ["Neon|Ride"] = 684.88, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 8596.88, ["Mega|Fly|Ride"] = 2469.52}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 25.92, ["Ride"] = 42, ["Fly|Ride"] = 274.16, ["Neon"] = 232.74, ["Neon|Fly"] = 410.73, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 385.06, ["Mega"] = 656.25, ["Mega|Ride"] = 1851.56, ["Mega|Fly|Ride"] = 739.29}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 128.63, ["Ride"] = 205.37, ["Fly|Ride"] = 410.73, ["Neon|Fly|Ride"] = 1296.1, ["Mega|Fly|Ride"] = 4012.1}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1796.6, ["Ride"] = 2469.49, ["Fly|Ride"] = 2053.57, ["Neon|Fly|Ride"] = 8214.22, ["Mega|Fly|Ride"] = 24688.12}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 45.48, ["Ride"] = 65.63, ["Fly|Ride"] = 196.87, ["Neon"] = 511.88, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 343.87, ["Mega|Ride"] = 2258.93, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 617.47, ["Fly"] = 794.74, ["Ride"] = 609, ["Fly|Ride"] = 630, ["Neon|Ride"] = 1506.29, ["Neon|Fly|Ride"] = 1148.44, ["Mega|Fly|Ride"] = 3106.35}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 45.14, ["Fly"] = 62.09, ["Ride"] = 52.5, ["Fly|Ride"] = 112.22, ["Neon"] = 328.58, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 233.09, ["Mega|Fly|Ride"] = 1164.38}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 2.63, ["Fly"] = 34.93, ["Ride"] = 24.94, ["Fly|Ride"] = 55.57, ["Neon"] = 27.56, ["Neon|Fly"] = 80.56, ["Neon|Ride"] = 41.88, ["Neon|Fly|Ride"] = 87.28, ["Mega"] = 513.4, ["Mega|Fly"] = 338.85, ["Mega|Ride"] = 205.37, ["Mega|Fly|Ride"] = 248.91}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 52.03, ["Ride"] = 105, ["Fly|Ride"] = 252, ["Neon"] = 262.5, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 616.07, ["Mega|Ride"] = 1369.74, ["Mega|Fly|Ride"] = 824.2}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 669.37, ["Fly"] = 1568.02, ["Ride"] = 716.62, ["Fly|Ride"] = 721.88, ["Neon|Ride"] = 2416.29, ["Neon|Fly|Ride"] = 2034.37, ["Mega|Fly|Ride"] = 7187.44}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 577.49, ["Ride"] = 630, ["Fly|Ride"] = 866.25, ["Neon"] = 5133.89, ["Neon|Fly|Ride"] = 3244.62, ["Mega|Fly|Ride"] = 12321.32}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 14.43, ["Fly"] = 25.71, ["Ride"] = 23.63, ["Fly|Ride"] = 58.54, ["Neon"] = 205.37, ["Neon|Ride"] = 100.65, ["Neon|Fly|Ride"] = 130.73, ["Mega|Fly|Ride"] = 684.88}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 10.38, ["Ride"] = 23.62, ["Fly|Ride"] = 62.43, ["Neon"] = 72.19, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 136.5, ["Mega"] = 959.03, ["Mega|Ride"] = 439.76, ["Mega|Fly|Ride"] = 378.67}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 5.2, ["Ride"] = 31.26, ["Fly|Ride"] = 111.45, ["Neon"] = 21.84, ["Neon|Fly"] = 309, ["Neon|Ride"] = 51.76, ["Neon|Fly|Ride"] = 155.09, ["Mega"] = 160.34, ["Mega|Ride"] = 238.62, ["Mega|Fly|Ride"] = 302.54}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 39.05, ["Fly"] = 61.62, ["Ride"] = 56.43, ["Fly|Ride"] = 94.48, ["Neon"] = 287.52, ["Neon|Ride"] = 226.93, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 945}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 52.5, ["Ride"] = 102.69, ["Fly|Ride"] = 449.61, ["Neon"] = 410.73, ["Neon|Ride"] = 486.7, ["Neon|Fly|Ride"] = 695.63, ["Mega|Fly|Ride"] = 1363.58}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 12.38, ["Fly"] = 48.57, ["Ride"] = 36.61, ["Fly|Ride"] = 92.59, ["Neon"] = 82.16, ["Neon|Ride"] = 102.38, ["Neon|Fly|Ride"] = 155.09, ["Mega"] = 340.28, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 30.09, ["Fly"] = 86.03, ["Ride"] = 43.89, ["Fly|Ride"] = 108.8, ["Neon"] = 548.31, ["Neon|Ride"] = 220.73, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 787.4}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.88, ["Fly"] = 27.74, ["Ride"] = 19.69, ["Fly|Ride"] = 40.69, ["Neon"] = 34.29, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 96.54, ["Mega"] = 525, ["Mega|Ride"] = 274.16, ["Mega|Fly|Ride"] = 340.91}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.11, ["Fly"] = 32.48, ["Ride"] = 27.57, ["Fly|Ride"] = 72.19, ["Neon"] = 24.69, ["Neon|Fly"] = 82.16, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 410.73, ["Mega|Fly"] = 466.17, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 513.4}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 42.44, ["Fly"] = 65.61, ["Ride"] = 43.32, ["Fly|Ride"] = 84.42, ["Neon"] = 401.61, ["Neon|Ride"] = 273.13, ["Neon|Fly|Ride"] = 273, ["Mega|Fly|Ride"] = 919.09}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1816.49, ["Fly"] = 1944.72, ["Ride"] = 1593.38, ["Fly|Ride"] = 1745.63, ["Neon|Fly"] = 4918.19, ["Neon|Ride"] = 4627.69, ["Neon|Fly|Ride"] = 3734.07, ["Mega|Fly|Ride"] = 27773.26}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 523.69, ["Fly"] = 547.46, ["Ride"] = 465.9, ["Fly|Ride"] = 567.42, ["Neon"] = 3086.64, ["Neon|Ride"] = 2464.27, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 9564.43}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 254.35, ["Fly"] = 348.1, ["Ride"] = 303.42, ["Fly|Ride"] = 476.44, ["Neon"] = 1505.26, ["Neon|Ride"] = 1410.81, ["Neon|Fly|Ride"] = 1535.65, ["Mega|Fly|Ride"] = 6431.25}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 44.63}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 24.49, ["Ride"] = 47.24, ["Fly|Ride"] = 96.54, ["Neon"] = 345.19, ["Neon|Fly"] = 410.73, ["Neon|Ride"] = 512.37, ["Neon|Fly|Ride"] = 1968.75, ["Mega"] = 904.61, ["Mega|Ride"] = 821.44, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 41071.05, ["Fly"] = 20998.69, ["Ride"] = 34781.25, ["Fly|Ride"] = 14437.49, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 396.38, ["Fly"] = 851.72, ["Ride"] = 354.38, ["Fly|Ride"] = 502.69, ["Neon|Ride"] = 1851.56, ["Neon|Fly|Ride"] = 1535.63, ["Mega"] = 6160.67, ["Mega|Fly|Ride"] = 3845.62}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 155.08, ["Fly"] = 525, ["Ride"] = 136.49, ["Fly|Ride"] = 155.38, ["Mega|Fly|Ride"] = 4107.11}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 124.59, ["Fly"] = 262.49, ["Ride"] = 104.99, ["Fly|Ride"] = 213.88, ["Neon"] = 512.37, ["Neon|Ride"] = 509.73, ["Neon|Fly|Ride"] = 549.94, ["Mega|Fly|Ride"] = 2463.25}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 19.69, ["Fly"] = 94.5, ["Ride"] = 33.65, ["Fly|Ride"] = 98.48, ["Neon"] = 274.16, ["Neon|Ride"] = 135.19, ["Neon|Fly|Ride"] = 204.35, ["Mega"] = 683.85, ["Mega|Ride"] = 540.1}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4823.8, ["Ride"] = 4871.04, ["Fly|Ride"] = 3937.49, ["Neon|Fly|Ride"] = 17524}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 30.19, ["Fly"] = 137.61, ["Ride"] = 39.37, ["Fly|Ride"] = 65.63, ["Neon"] = 333.94, ["Neon|Ride"] = 231.47, ["Neon|Fly|Ride"] = 184.93, ["Mega|Fly|Ride"] = 855.2}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 47.24, ["Fly"] = 137.61, ["Ride"] = 45.94, ["Fly|Ride"] = 109.15, ["Neon"] = 393.75, ["Neon|Fly"] = 1369.74, ["Neon|Ride"] = 274.16, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1543.75, ["Mega|Fly|Ride"] = 1299.92}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 623.44, ["Fly"] = 855.2, ["Ride"] = 630, ["Fly|Ride"] = 787.5, ["Neon"] = 1808.63, ["Neon|Ride"] = 1863.75, ["Neon|Fly|Ride"] = 1875.57, ["Mega|Ride"] = 6024.11, ["Mega|Fly|Ride"] = 3885}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 17.07, ["Fly"] = 27.75, ["Ride"] = 23.62, ["Fly|Ride"] = 50.93, ["Neon"] = 124.69, ["Neon|Fly"] = 155.09, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 586.72, ["Mega|Ride"] = 582.2, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 14.41, ["Fly"] = 82.16, ["Ride"] = 27.74, ["Neon"] = 77.7, ["Neon|Ride"] = 137.61, ["Neon|Fly|Ride"] = 249.38, ["Mega|Ride"] = 520.58, ["Mega|Fly|Ride"] = 548.31}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 98.76, ["Ride"] = 131.25, ["Fly|Ride"] = 196.88, ["Neon"] = 527.71, ["Neon|Ride"] = 525.35, ["Neon|Fly|Ride"] = 694.35, ["Mega"] = 1985.81, ["Mega|Fly|Ride"] = 2176.78}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 19.69, ["Fly"] = 68.8, ["Ride"] = 102.69, ["Fly|Ride"] = 147, ["Neon"] = 78.75, ["Neon|Fly"] = 191, ["Neon|Ride"] = 130.76, ["Neon|Fly|Ride"] = 242.28, ["Mega"] = 304.5, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3675, ["Fly"] = 5030.19, ["Ride"] = 3675, ["Fly|Ride"] = 3674.99, ["Neon"] = 12321.32, ["Neon|Ride"] = 11467.04, ["Neon|Fly|Ride"] = 8726.41, ["Mega"] = 43011.66, ["Mega|Fly|Ride"] = 33021.24}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 45.94, ["Ride"] = 63, ["Fly|Ride"] = 135.95, ["Neon"] = 479.52, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 305.99, ["Mega|Ride"] = 1026.8, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 5891.82, ["Fly"] = 7875, ["Ride"] = 6571.38, ["Fly|Ride"] = 6103.13, ["Neon|Fly|Ride"] = 16428.43, ["Mega|Fly|Ride"] = 64344.98}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.8, ["Fly"] = 18.54, ["Ride"] = 17.07, ["Fly|Ride"] = 38.75, ["Neon"] = 24.94, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 45.48, ["Neon|Fly|Ride"] = 86.62, ["Mega"] = 447.86, ["Mega|Ride"] = 199.21, ["Mega|Fly|Ride"] = 273.13}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 26.25, ["Fly"] = 27.42, ["Ride"] = 30.19, ["Fly|Ride"] = 55.49, ["Neon"] = 109.88, ["Neon|Ride"] = 163.28, ["Neon|Fly|Ride"] = 178.67, ["Mega|Ride"] = 1365.68, ["Mega|Fly|Ride"] = 814.7}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.68}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 14.17, ["Ride"] = 37.05, ["Fly|Ride"] = 116.02, ["Neon"] = 192.03, ["Neon|Ride"] = 151.97, ["Neon|Fly|Ride"] = 192.94, ["Mega|Ride"] = 956.96, ["Mega|Fly|Ride"] = 748.13}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 26.35, ["Fly"] = 262.5, ["Ride"] = 56.12, ["Fly|Ride"] = 137.61, ["Neon"] = 182.43, ["Neon|Ride"] = 178.67, ["Neon|Fly|Ride"] = 252.39, ["Mega"] = 840, ["Mega|Fly|Ride"] = 1076.25}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 16.75, ["Fly"] = 22.32, ["Ride"] = 23.13, ["Fly|Ride"] = 38.74, ["Neon|Ride"] = 106.8, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 2464.27, ["Mega|Ride"] = 577.47, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8762.53}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2715.56}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 24.94}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 177.15, ["Fly"] = 174.57, ["Ride"] = 174.57, ["Fly|Ride"] = 183.74, ["Neon|Fly|Ride"] = 1080.85}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 30.81, ["Fly"] = 109.88, ["Ride"] = 60.59, ["Fly|Ride"] = 138.89, ["Neon"] = 119.21, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 178.67, ["Mega|Ride"] = 925.79, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 7.87}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 7.33, ["Fly|Ride"] = 59.56, ["Neon"] = 49.3, ["Neon|Ride"] = 68.81, ["Neon|Fly|Ride"] = 123.22, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2685.34}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 155.08, ["Fly"] = 281.35, ["Ride"] = 175.88, ["Fly|Ride"] = 10498.95, ["Neon"] = 712.61, ["Neon|Ride"] = 684.88, ["Mega|Ride"] = 2874.98, ["Mega|Fly|Ride"] = 3240.23}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 616.07, ["Ride"] = 236.25, ["Fly|Ride"] = 211.32, ["Neon"] = 682.5, ["Neon|Ride"] = 685.13, ["Neon|Fly|Ride"] = 1095.59, ["Mega"] = 2625, ["Mega|Ride"] = 3285.71, ["Mega|Fly|Ride"] = 3086.32}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 157.5, ["Fly"] = 149.63, ["Ride"] = 196.88, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 840, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 4517.84, ["Mega|Fly|Ride"] = 3571.14}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1561.88, ["Fly"] = 2464.27, ["Ride"] = 1476.33, ["Fly|Ride"] = 1569.91, ["Neon|Ride"] = 5474.79, ["Neon|Fly|Ride"] = 3675, ["Mega|Fly|Ride"] = 30859.56}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 20.55, ["Fly"] = 80.1, ["Ride"] = 49.88, ["Fly|Ride"] = 93.45, ["Neon"] = 135.55, ["Neon|Ride"] = 164.3, ["Neon|Fly|Ride"] = 241.31, ["Mega"] = 925.79, ["Mega|Ride"] = 890.23, ["Mega|Fly|Ride"] = 1086.35}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 656.25, ["Fly"] = 2100, ["Ride"] = 726.02, ["Fly|Ride"] = 959.03, ["Neon|Fly|Ride"] = 4012.1}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 42.32}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 18.38, ["Ride"] = 31.26, ["Fly|Ride"] = 681.8, ["Neon"] = 98.44, ["Neon|Ride"] = 123.22, ["Neon|Fly|Ride"] = 273.13, ["Mega"] = 393.75, ["Mega|Ride"] = 457.95, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 7.67, ["Fly"] = 48.27, ["Ride"] = 27.74, ["Fly|Ride"] = 94.79, ["Neon"] = 27.74, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 918.75, ["Mega|Ride"] = 344, ["Mega|Fly|Ride"] = 617.97}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 51.02}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 19.69, ["Fly"] = 108.92, ["Ride"] = 31.27, ["Fly|Ride"] = 55.13, ["Neon"] = 196.88, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 192.03, ["Mega"] = 787.5, ["Mega|Ride"] = 1234.76, ["Mega|Fly|Ride"] = 684.88}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 68.81, ["Fly"] = 75.99, ["Ride"] = 32.82, ["Fly|Ride"] = 60.75, ["Neon|Ride"] = 221.81, ["Neon|Fly|Ride"] = 274.16, ["Mega"] = 933.89, ["Mega|Ride"] = 1735.84, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6300, ["Fly"] = 10954, ["Ride"] = 4987.5, ["Fly|Ride"] = 4331.25, ["Neon|Fly|Ride"] = 10500, ["Mega|Fly|Ride"] = 28749.74}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 6.56, ["Fly"] = 40.69, ["Ride"] = 35.44, ["Fly|Ride"] = 78.75, ["Neon"] = 64.97, ["Neon|Ride"] = 77.81, ["Mega"] = 518.45, ["Mega|Ride"] = 533.94, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 34.93}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 90.92, ["Fly"] = 363.49, ["Ride"] = 130.35, ["Fly|Ride"] = 188.99, ["Neon"] = 485.63, ["Neon|Ride"] = 517.13, ["Neon|Fly|Ride"] = 684.88, ["Mega|Fly|Ride"] = 1850.37}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 62.99, ["Fly"] = 96.48, ["Ride"] = 105.77, ["Fly|Ride"] = 205.37, ["Neon"] = 233.09, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 463.89, ["Mega"] = 2314.45, ["Mega|Ride"] = 2772.31, ["Mega|Fly|Ride"] = 1355.36}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 21.74, ["Fly"] = 46.31, ["Ride"] = 30.18, ["Fly|Ride"] = 65.63, ["Neon"] = 131.44, ["Neon|Ride"] = 182.86, ["Neon|Fly|Ride"] = 170.63, ["Mega|Ride"] = 679.3, ["Mega|Fly|Ride"] = 656.23}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 5.13, ["Fly"] = 56.62, ["Ride"] = 30.81, ["Fly|Ride"] = 82.69, ["Neon"] = 28.88, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 53.26, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 157.5, ["Mega|Fly"] = 231.47, ["Mega|Ride"] = 208.31, ["Mega|Fly|Ride"] = 280.88}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 14.43, ["Ride"] = 31.36, ["Fly|Ride"] = 98.59, ["Neon"] = 93.45, ["Neon|Ride"] = 122.19, ["Neon|Fly|Ride"] = 135.19, ["Mega"] = 479.52, ["Mega|Ride"] = 410.82, ["Mega|Fly|Ride"] = 546.26}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 19.69, ["Fly"] = 31.5, ["Ride"] = 27.56, ["Fly|Ride"] = 59.56, ["Neon"] = 203.32, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 149.92, ["Mega|Fly|Ride"] = 600.12}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 188.99}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 28.75, ["Ride"] = 96.86, ["Neon"] = 177.19, ["Neon|Fly|Ride"] = 300.89, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 782.25}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 188.95, ["Fly"] = 216.42, ["Ride"] = 443.63, ["Fly|Ride"] = 328.58, ["Neon"] = 1095.59}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 39.69, ["Fly"] = 212.01, ["Ride"] = 100.69, ["Fly|Ride"] = 233.09, ["Neon"] = 295.32, ["Neon|Ride"] = 385.88, ["Neon|Fly|Ride"] = 420, ["Mega"] = 1183.88, ["Mega|Ride"] = 2137.4, ["Mega|Fly|Ride"] = 1204.84}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 787.5, ["Fly"] = 1118.25, ["Ride"] = 897.75, ["Fly|Ride"] = 915.29, ["Neon|Ride"] = 2553.99, ["Neon|Fly|Ride"] = 2361.19, ["Mega|Fly|Ride"] = 10368.75}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 262.5, ["Fly"] = 462.9, ["Ride"] = 262.5, ["Fly|Ride"] = 367.5, ["Neon"] = 1181.25, ["Neon|Ride"] = 2006.63, ["Neon|Fly|Ride"] = 1642.87, ["Mega"] = 8503.37, ["Mega|Fly|Ride"] = 5773.68}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 74.08}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 11.84, ["Fly"] = 27.57, ["Ride"] = 27.57, ["Fly|Ride"] = 52.5, ["Neon"] = 77.95, ["Neon|Fly"] = 230.99, ["Neon|Ride"] = 97.56, ["Neon|Fly|Ride"] = 154.88, ["Mega"] = 437.26, ["Mega|Ride"] = 683.85, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 262.5, ["Fly"] = 762.36, ["Ride"] = 301.75, ["Fly|Ride"] = 387.19, ["Neon"] = 1086.75, ["Neon|Ride"] = 871.45, ["Neon|Fly|Ride"] = 934.42, ["Mega|Ride"] = 3580.45, ["Mega|Fly|Ride"] = 2690.63}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 21}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 153.57, ["Fly"] = 186.38, ["Ride"] = 203.42, ["Fly|Ride"] = 258.55, ["Neon"] = 548.31, ["Neon|Fly"] = 1642.87, ["Neon|Ride"] = 770.09, ["Neon|Fly|Ride"] = 821.44, ["Mega"] = 2533.13, ["Mega|Ride"] = 11680.61, ["Mega|Fly|Ride"] = 2782.5}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 118.13, ["Fly"] = 192.03, ["Ride"] = 137.82, ["Fly|Ride"] = 157.5, ["Neon"] = 671.52, ["Neon|Ride"] = 1005.38}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 4.41, ["Ride"] = 27.74, ["Fly|Ride"] = 167.39, ["Neon"] = 39.36, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 262.1, ["Mega|Ride"] = 356.31, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 15.05, ["Fly"] = 63, ["Ride"] = 29.28, ["Fly|Ride"] = 76.13, ["Neon"] = 211.53, ["Neon|Ride"] = 109.88, ["Neon|Fly|Ride"] = 255.05, ["Mega|Ride"] = 549.94, ["Mega|Fly|Ride"] = 577.31}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 19.69, ["Fly"] = 102.31, ["Ride"] = 45.94, ["Fly|Ride"] = 128.82, ["Neon"] = 137.61, ["Neon|Ride"] = 151.97, ["Neon|Fly|Ride"] = 254.66, ["Mega"] = 461.03, ["Mega|Ride"] = 459.95, ["Mega|Fly|Ride"] = 685.82}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 4.09, ["Fly"] = 123.22, ["Ride"] = 52.5, ["Fly|Ride"] = 156.35, ["Neon"] = 22.97, ["Neon|Fly"] = 231.49, ["Neon|Ride"] = 66.92, ["Neon|Fly|Ride"] = 155.27, ["Mega"] = 153.56, ["Mega|Ride"] = 175.79, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 268.44, ["Fly"] = 283.5, ["Ride"] = 288.74, ["Fly|Ride"] = 355.67, ["Neon"] = 1506.29, ["Neon|Ride"] = 1336.13, ["Neon|Fly|Ride"] = 1404.38, ["Mega|Fly|Ride"] = 5092.82}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 139.13, ["Fly"] = 1050, ["Ride"] = 177.19, ["Fly|Ride"] = 384.03, ["Neon"] = 677.25, ["Neon|Ride"] = 708.75, ["Neon|Fly|Ride"] = 838.69, ["Mega|Ride"] = 3970.56, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 72.19, ["Fly"] = 167.45, ["Ride"] = 89.48, ["Fly|Ride"] = 108.8, ["Neon"] = 471.31, ["Neon|Ride"] = 426.57, ["Neon|Fly|Ride"] = 452.82, ["Mega|Fly|Ride"] = 1509.67}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 13.13, ["Ride"] = 57.75, ["Fly|Ride"] = 246.44, ["Neon|Ride"] = 587.88, ["Neon|Fly|Ride"] = 479.52, ["Mega|Ride"] = 616.07, ["Mega|Fly|Ride"] = 1640.81}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 15.74, ["Fly"] = 75.63, ["Ride"] = 45.1, ["Fly|Ride"] = 102.38, ["Neon"] = 94.5, ["Neon|Fly"] = 205.37, ["Neon|Ride"] = 84.2, ["Neon|Fly|Ride"] = 192.57, ["Mega"] = 309, ["Mega|Fly"] = 525, ["Mega|Ride"] = 340.91, ["Mega|Fly|Ride"] = 432.81}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.68, ["Fly"] = 52.45, ["Ride"] = 22.6, ["Fly|Ride"] = 98.44, ["Neon"] = 21.99, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 38.98, ["Neon|Fly|Ride"] = 109.88, ["Mega"] = 129.94, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 220.4}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 918.75, ["Fly"] = 1082.72, ["Ride"] = 918.74, ["Fly|Ride"] = 979.13, ["Neon|Fly"] = 3395.3, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2623.69, ["Mega|Fly|Ride"] = 10029.63}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 389.03, ["Ride"] = 379.32, ["Fly|Ride"] = 481.26, ["Neon|Ride"] = 1918.04, ["Neon|Fly|Ride"] = 1922.33, ["Mega"] = 10267.77, ["Mega|Fly|Ride"] = 7392.8}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 92.59, ["Fly"] = 131.25, ["Ride"] = 96.54, ["Fly|Ride"] = 182.78, ["Neon"] = 314.22, ["Neon|Ride"] = 305.82, ["Neon|Fly|Ride"] = 405.6, ["Mega"] = 1573.83, ["Mega|Ride"] = 1484.74, ["Mega|Fly|Ride"] = 1531.97}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 290.48, ["Fly"] = 462.9, ["Ride"] = 296.87, ["Fly|Ride"] = 282.19, ["Neon"] = 1388.82, ["Neon|Ride"] = 1388.68, ["Neon|Fly|Ride"] = 1129.47, ["Mega"] = 10267.77, ["Mega|Fly|Ride"] = 5246.83}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 19.69, ["Fly"] = 137.61, ["Ride"] = 30.81, ["Fly|Ride"] = 63.68, ["Neon"] = 169.32, ["Neon|Ride"] = 128.46, ["Neon|Fly|Ride"] = 229.68, ["Mega|Ride"] = 694.35, ["Mega|Fly|Ride"] = 616.07}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 196.88, ["Ride"] = 266.15, ["Fly|Ride"] = 548.31, ["Neon"] = 1419.05, ["Neon|Ride"] = 942.38, ["Neon|Fly|Ride"] = 2360.57, ["Mega"] = 4086.87, ["Mega|Ride"] = 4244.71, ["Mega|Fly|Ride"] = 3799.08}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 60.37, ["Fly"] = 76.13, ["Ride"] = 55.46, ["Fly|Ride"] = 101.88, ["Neon|Ride"] = 492.86, ["Neon|Fly|Ride"] = 445.64, ["Mega|Fly|Ride"] = 1214.07}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1640.63, ["Fly"] = 1641.84, ["Ride"] = 1443.75, ["Fly|Ride"] = 1509.38, ["Neon|Ride"] = 10801.49, ["Neon|Fly|Ride"] = 4517.84, ["Mega"] = 49285.26, ["Mega|Fly|Ride"] = 21767.66}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 15.59, ["Fly"] = 62.37, ["Ride"] = 45.2, ["Fly|Ride"] = 90.87, ["Neon"] = 62.77, ["Neon|Fly"] = 172.57, ["Neon|Ride"] = 94.48, ["Neon|Fly|Ride"] = 155.09, ["Mega"] = 307.18, ["Mega|Fly"] = 374.07, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 396.22}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 42, ["Fly"] = 119.1, ["Ride"] = 82.16, ["Fly|Ride"] = 161.44, ["Neon"] = 274.16, ["Neon|Ride"] = 278.27, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 817.34, ["Mega|Ride"] = 1005.23, ["Mega|Fly|Ride"] = 904.61}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 65.63, ["Fly"] = 82.16, ["Ride"] = 61.69, ["Fly|Ride"] = 102.38, ["Neon|Ride"] = 410.73, ["Neon|Fly|Ride"] = 342.97, ["Mega|Fly|Ride"] = 1492.95}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3421.23, ["Fly"] = 1181.25, ["Ride"] = 1540.18, ["Fly|Ride"] = 1168.13, ["Neon|Fly|Ride"] = 4200, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 480.77, ["Fly"] = 819.38, ["Ride"] = 410.73, ["Fly|Ride"] = 616.07, ["Neon|Fly|Ride"] = 2700.96, ["Mega|Fly|Ride"] = 13886.63}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 129.4, ["Fly"] = 308.99, ["Ride"] = 124.69, ["Fly|Ride"] = 206.07, ["Neon"] = 444.29, ["Neon|Fly"] = 548.31, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 591.6, ["Mega"] = 4107.11, ["Mega|Ride"] = 2601.87, ["Mega|Fly|Ride"] = 2389.32}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.39, ["Ride"] = 27.57, ["Fly|Ride"] = 69.45, ["Neon"] = 67.14, ["Neon|Ride"] = 93.55, ["Neon|Fly|Ride"] = 176.61, ["Mega|Ride"] = 747.53, ["Mega|Fly|Ride"] = 1150.01}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 39.61, ["Ride"] = 48.43, ["Fly|Ride"] = 122.73, ["Neon"] = 178.67, ["Neon|Fly"] = 409.7, ["Neon|Ride"] = 250.56, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 1333.8, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 754.62, ["Ride"] = 820.32, ["Fly|Ride"] = 853.13, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2508.42, ["Mega|Fly|Ride"] = 154296.58}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 787.5}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 5613.4, ["Ride"] = 5554.61, ["Fly|Ride"] = 4485.21, ["Neon"] = 42000, ["Neon|Ride"] = 29428.44, ["Neon|Fly|Ride"] = 21618.79, ["Mega|Fly|Ride"] = 87618.91}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 157.5, ["Fly"] = 402.74, ["Ride"] = 192.03, ["Fly|Ride"] = 367.5, ["Neon"] = 1246.88, ["Neon|Fly|Ride"] = 1642.87, ["Mega"] = 5749.95, ["Mega|Fly|Ride"] = 5120.55}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 78.75, ["Fly"] = 274.16, ["Ride"] = 78.75, ["Fly|Ride"] = 336, ["Neon"] = 397.38, ["Neon|Ride"] = 492.86, ["Neon|Fly|Ride"] = 959.03, ["Mega|Fly|Ride"] = 2099.99}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 14.95, ["Fly"] = 96.54, ["Ride"] = 34.13, ["Fly|Ride"] = 50.93, ["Neon"] = 147, ["Neon|Ride"] = 86.26, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 548.31, ["Mega|Fly|Ride"] = 628.69}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 15.42, ["Fly"] = 39.38, ["Ride"] = 27.76, ["Fly|Ride"] = 51.19, ["Neon"] = 194.64, ["Neon|Fly"] = 274.16, ["Neon|Ride"] = 68.81, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2176.78}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 15.09, ["Fly"] = 274.16, ["Ride"] = 35.44, ["Fly|Ride"] = 91.88, ["Neon"] = 100.65, ["Neon|Ride"] = 154.88, ["Neon|Fly|Ride"] = 181.56, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.99, ["Fly"] = 55.46, ["Ride"] = 22.31, ["Fly|Ride"] = 55.46, ["Neon"] = 22.32, ["Neon|Fly"] = 338.85, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 185.17, ["Mega"] = 164.3, ["Mega|Ride"] = 205.37, ["Mega|Fly|Ride"] = 308.04}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 24.93, ["Ride"] = 49.3, ["Fly|Ride"] = 183.75, ["Neon"] = 269.03, ["Neon|Fly"] = 821.44, ["Neon|Ride"] = 155.09, ["Neon|Fly|Ride"] = 307.4, ["Mega"] = 684.88, ["Mega|Ride"] = 1237.69, ["Mega|Fly|Ride"] = 799.23}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 262.5, ["Fly"] = 437.43, ["Ride"] = 341.25, ["Fly|Ride"] = 397.3, ["Neon|Ride"] = 1136.65, ["Neon|Fly|Ride"] = 951.57, ["Mega"] = 7875, ["Mega|Fly"] = 4311.45, ["Mega|Ride"] = 3696.4, ["Mega|Fly|Ride"] = 3281.25}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.94, ["Fly"] = 26.25, ["Ride"] = 15.11, ["Fly|Ride"] = 38.07, ["Neon"] = 26.63, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 69.3, ["Mega"] = 274.16, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 238.2}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 40.69, ["Fly"] = 85.62, ["Ride"] = 83.88, ["Fly|Ride"] = 131.25, ["Neon"] = 164.07, ["Neon|Fly"] = 386.56, ["Neon|Ride"] = 199.19, ["Neon|Fly|Ride"] = 256.47, ["Mega"] = 498.75, ["Mega|Fly"] = 821.44, ["Mega|Ride"] = 564.36, ["Mega|Fly|Ride"] = 587.25}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 756.45, ["Fly"] = 1000.1, ["Ride"] = 771.38, ["Fly|Ride"] = 803.18, ["Neon|Ride"] = 1458.19, ["Neon|Fly|Ride"] = 1458.19, ["Mega|Fly|Ride"] = 3820.17}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 32.82, ["Fly"] = 91.88, ["Ride"] = 48.47, ["Fly|Ride"] = 99.75, ["Neon"] = 178.76, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 1575, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 748.13}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 293.94, ["Fly"] = 393.46, ["Ride"] = 308.44, ["Fly|Ride"] = 353.07, ["Neon|Fly|Ride"] = 1232.85, ["Mega|Fly|Ride"] = 6845.53}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 183.74, ["Fly"] = 155.4, ["Ride"] = 131.25, ["Fly|Ride"] = 195.57, ["Neon|Ride"] = 693.09, ["Neon|Fly|Ride"] = 590.63, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 578.21, ["Ride"] = 603.75, ["Fly|Ride"] = 735, ["Neon|Ride"] = 2519.72, ["Neon|Fly|Ride"] = 2327.72, ["Mega|Fly|Ride"] = 8008.86}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 19.63, ["Ride"] = 40.69, ["Fly|Ride"] = 92.55, ["Neon"] = 109.88, ["Neon|Fly"] = 277.75, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 268.49, ["Mega"] = 305.99, ["Mega|Ride"] = 354.12, ["Mega|Fly|Ride"] = 462.91}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3970.56, ["Ride"] = 3340.32, ["Fly|Ride"] = 3281.25, ["Neon|Fly|Ride"] = 6562.5, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 105, ["Fly"] = 78.75, ["Ride"] = 116.82, ["Fly|Ride"] = 162.25, ["Neon"] = 380.63, ["Neon|Ride"] = 508.27, ["Neon|Fly|Ride"] = 419.45, ["Mega|Fly|Ride"] = 2258.93}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.63, ["Fly"] = 26.25, ["Ride"] = 18.4, ["Fly|Ride"] = 64.32, ["Neon"] = 23.62, ["Neon|Fly"] = 82.16, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 135.19, ["Mega"] = 194.24, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 270.14, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.22, ["Ride"] = 27.57, ["Fly|Ride"] = 64.82, ["Neon"] = 24.66, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 161.44, ["Mega|Ride"] = 199.48, ["Mega|Fly|Ride"] = 238.56}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 34.93, ["Fly"] = 151.97, ["Ride"] = 37.41, ["Fly|Ride"] = 59.07, ["Neon"] = 270.83, ["Neon|Ride"] = 287.52, ["Neon|Fly|Ride"] = 274.16, ["Mega|Fly|Ride"] = 1095.59}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 1061.82, ["Ride"] = 1115.63, ["Fly|Ride"] = 1113}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6036.19, ["Ride"] = 6943.26, ["Fly|Ride"] = 6299.99}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 18.78, ["Fly"] = 31.26, ["Ride"] = 26.25, ["Fly|Ride"] = 60.38, ["Neon"] = 205.37, ["Neon|Ride"] = 144.8, ["Neon|Fly|Ride"] = 137.61, ["Mega"] = 2428.13, ["Mega|Fly|Ride"] = 656.24}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 15.57, ["Fly"] = 73.95, ["Ride"] = 34.93, ["Fly|Ride"] = 89.24, ["Neon"] = 94.4, ["Neon|Ride"] = 90.37, ["Neon|Fly|Ride"] = 186.69, ["Mega"] = 642.48, ["Mega|Ride"] = 410.73, ["Mega|Fly|Ride"] = 500}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 72, ["Fly"] = 88.31, ["Ride"] = 68.25, ["Fly|Ride"] = 108.94, ["Neon"] = 410.73, ["Neon|Ride"] = 370.33, ["Neon|Fly|Ride"] = 259.88, ["Mega"] = 1642.87, ["Mega|Ride"] = 1784.55, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 201.37, ["Fly"] = 308.99, ["Ride"] = 210, ["Fly|Ride"] = 298.9, ["Neon|Ride"] = 1314.29, ["Neon|Fly|Ride"] = 945, ["Mega"] = 10267.77, ["Mega|Fly|Ride"] = 3593.73}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 5.15, ["Ride"] = 22.32, ["Fly|Ride"] = 86.63, ["Neon"] = 27.74, ["Neon|Fly"] = 656.24, ["Neon|Ride"] = 92.42, ["Mega"] = 136.49, ["Mega|Ride"] = 163.96, ["Mega|Fly|Ride"] = 410.73}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 193.93, ["Fly"] = 232.07, ["Ride"] = 232.32, ["Fly|Ride"] = 288.75, ["Neon"] = 840, ["Neon|Ride"] = 944.65, ["Neon|Fly|Ride"] = 787.5, ["Mega|Ride"] = 4627.73, ["Mega|Fly|Ride"] = 3835.02}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.62, ["Fly"] = 33.57, ["Ride"] = 14.44, ["Fly|Ride"] = 48.27, ["Neon"] = 19.68, ["Neon|Fly"] = 123.03, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 196.88, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 225.75, ["Fly"] = 264.92, ["Ride"] = 247.66, ["Fly|Ride"] = 256.71, ["Neon|Ride"] = 1080.85, ["Neon|Fly|Ride"] = 1115.63, ["Mega"] = 10267.77, ["Mega|Fly|Ride"] = 4080.42}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 15.42, ["Fly"] = 70.4, ["Ride"] = 28.91, ["Fly|Ride"] = 61.62, ["Neon"] = 81.38, ["Neon|Fly"] = 293.97, ["Neon|Ride"] = 96.54, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 512.67, ["Mega|Ride"] = 575.01, ["Mega|Fly|Ride"] = 449.5}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Ride"] = 20.25, ["Fly|Ride"] = 86.63, ["Neon"] = 41.09, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 36.65, ["Neon|Fly|Ride"] = 175, ["Mega"] = 108.78, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 191.22}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.63, ["Neon"] = 6.18, ["Neon|Ride"] = 31.85, ["Mega"] = 34.93, ["Mega|Ride"] = 136.39}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.55, ["Fly"] = 52.48, ["Ride"] = 32.9, ["Fly|Ride"] = 206.57, ["Neon"] = 7.12, ["Neon|Ride"] = 38.98, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 66.91, ["Mega|Fly"] = 154296.58, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 159.85}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 62.91, ["Fly"] = 136.57, ["Ride"] = 114.19, ["Fly|Ride"] = 164.07, ["Neon"] = 311.11, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 401.86, ["Mega|Fly|Ride"] = 983.39}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 33.54, ["Ride"] = 17.07, ["Fly|Ride"] = 88.7, ["Neon"] = 13.13, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 105, ["Mega"] = 129.94, ["Mega|Ride"] = 122.54, ["Mega|Fly|Ride"] = 257.24}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 11.71, ["Ride"] = 115.74, ["Neon"] = 74.81, ["Neon|Ride"] = 111.57, ["Mega"] = 602.74, ["Mega|Ride"] = 579.95}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.18, ["Neon|Ride"] = 43.42, ["Neon|Fly|Ride"] = 278.25, ["Mega"] = 25.48, ["Mega|Ride"] = 51.38, ["Mega|Fly|Ride"] = 131.24}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 68.81, ["Ride"] = 15.42, ["Fly|Ride"] = 33.44, ["Neon"] = 2.1, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 14.1, ["Neon|Fly|Ride"] = 39.04, ["Mega"] = 13.06, ["Mega|Fly"] = 30.19, ["Mega|Ride"] = 30.1, ["Mega|Fly|Ride"] = 74.51}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Ride"] = 15.3, ["Fly|Ride"] = 30.81, ["Neon"] = 3.94, ["Neon|Fly"] = 20.55, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 53.25, ["Mega"] = 19.45, ["Mega|Fly"] = 155.32, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 96.54}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 33.63, ["Fly|Ride"] = 123.22, ["Neon"] = 2.49, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 81.02, ["Mega"] = 15.75, ["Mega|Ride"] = 145.83, ["Mega|Fly|Ride"] = 548.31}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 18.38, ["Fly|Ride"] = 107.62, ["Neon"] = 3.92, ["Neon|Fly"] = 137.85, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 23.37, ["Mega|Fly"] = 85.32, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 120.75}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.25, ["Neon|Fly|Ride"] = 203.32, ["Mega"] = 24.93, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 410.83}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.98, ["Fly"] = 65.24, ["Ride"] = 17.07, ["Fly|Ride"] = 96.53, ["Neon"] = 11.82, ["Neon|Fly"] = 59.06, ["Neon|Ride"] = 23.91, ["Neon|Fly|Ride"] = 65.54, ["Mega"] = 64.58, ["Mega|Fly"] = 277.24, ["Mega|Ride"] = 78.74, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 47.24, ["Neon"] = 2.1, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 157.37, ["Mega"] = 15.33, ["Mega|Fly"] = 98.44, ["Mega|Ride"] = 47.24, ["Mega|Fly|Ride"] = 85.32}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly|Ride"] = 524.99, ["Neon"] = 15.74, ["Mega"] = 274.16, ["Mega|Fly"] = 315, ["Mega|Ride"] = 342.97}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 3.69, ["Ride"] = 41.09, ["Neon"] = 6.19, ["Neon|Ride"] = 19.69, ["Mega"] = 103.69, ["Mega|Fly|Ride"] = 537.62}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 3.94, ["Neon|Fly"] = 27.74, ["Neon|Ride"] = 26.71, ["Neon|Fly|Ride"] = 137.61, ["Mega"] = 32.82, ["Mega|Ride"] = 172.44, ["Mega|Fly|Ride"] = 131.14}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 17.37, ["Fly|Ride"] = 30.09, ["Neon"] = 2.1, ["Neon|Fly"] = 35.44, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 28.68, ["Mega"] = 15.41, ["Mega|Fly"] = 36.75, ["Mega|Ride"] = 24.94, ["Mega|Fly|Ride"] = 101.07}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.63, ["Fly"] = 72.19, ["Ride"] = 229.68, ["Fly|Ride"] = 104.98, ["Neon"] = 28.88, ["Neon|Ride"] = 140.95, ["Mega"] = 274.16}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 18.32, ["Neon"] = 5.25, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 105, ["Mega"] = 23.62, ["Mega|Fly"] = 55.46, ["Mega|Ride"] = 60.59, ["Mega|Fly|Ride"] = 137.61}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 4.72, ["Neon"] = 20.85, ["Neon|Fly|Ride"] = 137.61, ["Mega"] = 81.38, ["Mega|Ride"] = 116.94, ["Mega|Fly|Ride"] = 238.87}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.61, ["Fly"] = 656.24, ["Ride"] = 32.82, ["Fly|Ride"] = 186.89, ["Neon"] = 15.31, ["Neon|Fly|Ride"] = 137.61, ["Mega"] = 223.13, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 188.99}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 17.31, ["Ride"] = 14.21, ["Fly|Ride"] = 26.16, ["Neon"] = 2.1, ["Neon|Fly"] = 15.75, ["Neon|Ride"] = 14.64, ["Neon|Fly|Ride"] = 36.94, ["Mega"] = 14.44, ["Mega|Fly"] = 30.81, ["Mega|Ride"] = 24.94, ["Mega|Fly|Ride"] = 51.95}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.63, ["Fly"] = 26.25, ["Ride"] = 19.66, ["Fly|Ride"] = 96.54, ["Neon"] = 17.26, ["Neon|Ride"] = 111.12, ["Neon|Fly|Ride"] = 84, ["Mega"] = 78.75, ["Mega|Ride"] = 154.16, ["Mega|Fly|Ride"] = 246.44}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.42, ["Fly"] = 40.69, ["Ride"] = 32.82, ["Fly|Ride"] = 58.46, ["Neon"] = 72.19, ["Neon|Ride"] = 48.09, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 236.25, ["Mega|Ride"] = 281.35, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 15.42, ["Ride"] = 15.75, ["Fly|Ride"] = 26.17, ["Neon"] = 3.93, ["Neon|Fly"] = 22.43, ["Neon|Ride"] = 15.41, ["Neon|Fly|Ride"] = 36.99, ["Mega"] = 14.43, ["Mega|Fly"] = 155.09, ["Mega|Ride"] = 118.09, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.63, ["Fly"] = 171.49, ["Ride"] = 60.37, ["Neon"] = 8.23, ["Neon|Fly"] = 75.99, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 36.67, ["Mega|Fly"] = 164.3, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 262.47}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.63, ["Ride"] = 26.71, ["Fly|Ride"] = 82.16, ["Neon"] = 4.93, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 32.86, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 16.72, ["Neon"] = 2.1, ["Neon|Fly"] = 41.09, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 96.54, ["Mega"] = 19.69, ["Mega|Ride"] = 34.13, ["Mega|Fly|Ride"] = 108.94}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 68.81, ["Ride"] = 18.37, ["Fly|Ride"] = 42.02, ["Neon"] = 6.97, ["Neon|Fly"] = 47.24, ["Neon|Ride"] = 19.07, ["Neon|Fly|Ride"] = 72.77, ["Mega"] = 77.56, ["Mega|Ride"] = 77.44, ["Mega|Fly|Ride"] = 287.52}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.63, ["Ride"] = 105, ["Neon"] = 5.25, ["Neon|Ride"] = 43.3, ["Mega"] = 40.69, ["Mega|Ride"] = 137.61}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 28.75, ["Ride"] = 17.56, ["Fly|Ride"] = 43.31, ["Neon"] = 5.25, ["Neon|Fly"] = 79.98, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 91.87, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 123.38}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.51, ["Ride"] = 27.64, ["Neon"] = 36.15, ["Mega"] = 133.88, ["Mega|Ride"] = 205.92, ["Mega|Fly|Ride"] = 821.44}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 35.96, ["Ride"] = 16.7, ["Fly|Ride"] = 61.62, ["Neon"] = 17.75, ["Neon|Fly"] = 137.61, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 170.63, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 315.24}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.15, ["Fly"] = 22.6, ["Ride"] = 19.53, ["Fly|Ride"] = 262.5, ["Neon"] = 18.11, ["Neon|Fly"] = 38.96, ["Neon|Ride"] = 39.35, ["Neon|Fly|Ride"] = 76.13, ["Mega"] = 223.13, ["Mega|Fly"] = 409.7, ["Mega|Ride"] = 123.84, ["Mega|Fly|Ride"] = 189.7}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 110.93, ["Ride"] = 53.25, ["Neon"] = 37.41, ["Mega"] = 123.3, ["Mega|Ride"] = 236.24}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 13.13, ["Ride"] = 131.24, ["Neon"] = 120.1, ["Neon|Ride"] = 32.82, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 3.82, ["Ride"] = 262.49, ["Neon"] = 41.11, ["Neon|Ride"] = 105, ["Mega"] = 219.75, ["Mega|Ride"] = 273.67, ["Mega|Fly|Ride"] = 722.54}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 7.76, ["Ride"] = 45.66, ["Neon"] = 84.2, ["Neon|Ride"] = 55.46, ["Mega"] = 248.07, ["Mega|Ride"] = 255.94, ["Mega|Fly|Ride"] = 353.72}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.81, ["Neon|Ride"] = 64.99, ["Mega"] = 20.74, ["Mega|Ride"] = 137.61, ["Mega|Fly|Ride"] = 147.87}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 42.87}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 6.02, ["Fly"] = 21.95, ["Ride"] = 22.32, ["Fly|Ride"] = 44.16, ["Neon"] = 59.47, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 102.69, ["Mega"] = 273, ["Mega|Fly"] = 328.58, ["Mega|Ride"] = 277.75, ["Mega|Fly|Ride"] = 281.43}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.37, ["Neon"] = 2.61, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 31.26, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.41, ["Ride"] = 27.74, ["Neon"] = 4.51, ["Neon|Ride"] = 27.75, ["Neon|Fly|Ride"] = 102.69, ["Mega"] = 55.49, ["Mega|Ride"] = 57.66, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 3.19, ["Fly"] = 45.94, ["Ride"] = 19.52, ["Fly|Ride"] = 55.13, ["Neon"] = 6.89, ["Neon|Ride"] = 26.71, ["Neon|Fly|Ride"] = 113.55, ["Mega"] = 125.23, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.83, ["Ride"] = 27.74, ["Fly|Ride"] = 47.24, ["Neon"] = 66.93, ["Neon|Ride"] = 231.47, ["Neon|Fly|Ride"] = 191.63, ["Mega"] = 291.62, ["Mega|Ride"] = 269.96, ["Mega|Fly|Ride"] = 401.58}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 32.81, ["Neon"] = 3.23, ["Neon|Ride"] = 48.27, ["Neon|Fly|Ride"] = 54.41, ["Mega"] = 18.26, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 20.99, ["Ride"] = 15.65, ["Fly|Ride"] = 273807.27, ["Neon"] = 4.6, ["Neon|Fly"] = 68.81, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 96.54, ["Mega"] = 33.65, ["Mega|Fly"] = 143.16, ["Mega|Ride"] = 47.93, ["Mega|Fly|Ride"] = 115.86}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 27.37, ["Ride"] = 15.75, ["Fly|Ride"] = 34.13, ["Neon"] = 6.36, ["Neon|Fly"] = 68.81, ["Neon|Ride"] = 14.85, ["Neon|Fly|Ride"] = 77.02, ["Mega"] = 47.94, ["Mega|Ride"] = 51.34, ["Mega|Fly|Ride"] = 158.29}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 210, ["Ride"] = 36.74, ["Fly|Ride"] = 118.13, ["Neon"] = 3.84, ["Neon|Ride"] = 27.03, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 24.92, ["Mega|Fly"] = 102.69, ["Mega|Ride"] = 66.26, ["Mega|Fly|Ride"] = 123.22}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.29, ["Neon|Ride"] = 164.37, ["Neon|Fly|Ride"] = 149048.61, ["Mega"] = 68.82, ["Mega|Fly"] = 98.59, ["Mega|Ride"] = 86.63, ["Mega|Fly|Ride"] = 199.21}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 32.43, ["Ride"] = 17.64, ["Fly|Ride"] = 49.3, ["Neon"] = 3.93, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 23, ["Neon|Fly|Ride"] = 76.39, ["Mega"] = 24.4, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 109.88}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 45.94, ["Neon"] = 2.61, ["Mega"] = 15.75, ["Mega|Ride"] = 123.8, ["Mega|Fly|Ride"] = 386.54}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.39, ["Neon"] = 4.65, ["Neon|Ride"] = 155.09, ["Mega"] = 28.55, ["Mega|Fly"] = 115.74, ["Mega|Ride"] = 122.19}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 16.05, ["Fly|Ride"] = 49.87, ["Neon"] = 4.6, ["Neon|Ride"] = 20.35, ["Neon|Fly|Ride"] = 136.49, ["Mega"] = 26.25, ["Mega|Ride"] = 51.33, ["Mega|Fly|Ride"] = 104.16}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 12.77, ["Fly"] = 55.46, ["Ride"] = 137.54, ["Neon"] = 512.37, ["Mega"] = 536.17, ["Mega|Ride"] = 397.38, ["Mega|Fly|Ride"] = 671.51}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.63, ["Fly"] = 6562.5, ["Ride"] = 36.75, ["Neon"] = 37.4, ["Neon|Ride"] = 203.32, ["Mega"] = 1563.79, ["Mega|Ride"] = 341.92, ["Mega|Fly|Ride"] = 410.73}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 3.68, ["Ride"] = 26.24, ["Fly|Ride"] = 410.73, ["Neon"] = 33.72, ["Mega"] = 274.16, ["Mega|Ride"] = 247.66, ["Mega|Fly|Ride"] = 349.65}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 18.54, ["Ride"] = 12.81, ["Neon"] = 2.1, ["Neon|Fly"] = 14.58, ["Neon|Ride"] = 14.43, ["Neon|Fly|Ride"] = 27.57, ["Mega"] = 14.97, ["Mega|Fly"] = 31.85, ["Mega|Ride"] = 26.25, ["Mega|Fly|Ride"] = 49.81}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 3.93, ["Fly"] = 118.12, ["Ride"] = 48.28, ["Fly|Ride"] = 109.88, ["Neon"] = 17.37, ["Neon|Fly"] = 89.46, ["Neon|Ride"] = 31.85, ["Neon|Fly|Ride"] = 684.88, ["Mega"] = 290.07, ["Mega|Ride"] = 98.59}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.4, ["Neon"] = 2.1, ["Neon|Fly"] = 30.81, ["Neon|Ride"] = 20.69, ["Neon|Fly|Ride"] = 77.02, ["Mega"] = 15.64, ["Mega|Fly"] = 80.68, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 100.29}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Ride"] = 91.43, ["Neon"] = 3.29, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 96.54, ["Neon|Fly|Ride"] = 122.19, ["Mega"] = 56.44, ["Mega|Ride"] = 76.13, ["Mega|Fly|Ride"] = 150.93}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 34.07, ["Ride"] = 18.5, ["Fly|Ride"] = 45.94, ["Neon"] = 11.69, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 88.34, ["Mega"] = 183.75, ["Mega|Ride"] = 190.13, ["Mega|Fly|Ride"] = 247.66}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 173.88, ["Ride"] = 236.25, ["Fly|Ride"] = 183.75, ["Neon"] = 1050, ["Neon|Ride"] = 822.94, ["Mega"] = 8214.22, ["Mega|Fly|Ride"] = 3283.65}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 9.18, ["Neon|Ride"] = 68.25, ["Mega"] = 64.03, ["Mega|Ride"] = 92.59, ["Mega|Fly|Ride"] = 771.88}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 4.13, ["Fly"] = 103.68, ["Ride"] = 35.96, ["Neon"] = 59.07, ["Neon|Ride"] = 92.59, ["Mega"] = 155.09, ["Mega|Fly|Ride"] = 409.7}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 805.26, ["Ride"] = 14.93, ["Fly|Ride"] = 32.79, ["Neon"] = 6.18, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 29.56, ["Neon|Fly|Ride"] = 61.95, ["Mega"] = 49.67, ["Mega|Ride"] = 74.37, ["Mega|Fly|Ride"] = 151.97}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 19.68, ["Fly|Ride"] = 52.5, ["Neon"] = 8.33, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 122.19, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.07, ["Fly"] = 24.92, ["Ride"] = 15.75, ["Fly|Ride"] = 34.97, ["Neon"] = 23.63, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 91.88, ["Mega|Ride"] = 205.37, ["Mega|Fly|Ride"] = 309}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.63, ["Fly"] = 41.09, ["Ride"] = 23.63, ["Fly|Ride"] = 55.46, ["Neon"] = 45.23, ["Neon|Ride"] = 128.26, ["Neon|Fly|Ride"] = 609.92, ["Mega"] = 185.17, ["Mega|Ride"] = 410.73, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.49, ["Fly"] = 20.55, ["Ride"] = 14.89, ["Fly|Ride"] = 36.75, ["Neon"] = 17.07, ["Neon|Fly"] = 68.16, ["Neon|Ride"] = 53.41, ["Neon|Fly|Ride"] = 73.5, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 75.99, ["Fly"] = 136.23, ["Ride"] = 94.49, ["Fly|Ride"] = 150.93, ["Neon"] = 390.18, ["Neon|Fly"] = 410.82, ["Neon|Ride"] = 387.19, ["Neon|Fly|Ride"] = 288.75, ["Mega|Fly|Ride"] = 1468.69}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 205.7, ["Fly"] = 328.58, ["Ride"] = 231.25, ["Fly|Ride"] = 293.95, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1080.85, ["Mega"] = 10267.77, ["Mega|Fly|Ride"] = 3957.2}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 72.19, ["Fly"] = 137.61, ["Ride"] = 77.44, ["Fly|Ride"] = 120.74, ["Neon"] = 402.51, ["Neon|Ride"] = 277.68, ["Neon|Fly|Ride"] = 412.13, ["Mega|Fly|Ride"] = 1325.02}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 4.87, ["Fly"] = 26.25, ["Ride"] = 23.63, ["Fly|Ride"] = 137.61, ["Neon"] = 32.8, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 123.84, ["Mega"] = 315, ["Mega|Ride"] = 376.04, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 14.44, ["Fly"] = 68.81, ["Ride"] = 30.82, ["Fly|Ride"] = 81.14, ["Neon"] = 77.04, ["Neon|Ride"] = 97.09, ["Neon|Fly|Ride"] = 171.49, ["Mega"] = 351.75, ["Mega|Ride"] = 364.53, ["Mega|Fly|Ride"] = 443.62}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 18.19, ["Fly|Ride"] = 35.88, ["Neon"] = 6.04, ["Neon|Fly"] = 67.3, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 68.86, ["Mega"] = 80.13, ["Mega|Fly"] = 154.88, ["Mega|Ride"] = 92.59, ["Mega|Fly|Ride"] = 174.57}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.5, ["Fly"] = 68.81, ["Ride"] = 27.74, ["Fly|Ride"] = 308.99, ["Neon"] = 53.41, ["Neon|Ride"] = 155.09, ["Neon|Fly|Ride"] = 134.93, ["Mega"] = 882.02, ["Mega|Ride"] = 583.22, ["Mega|Fly|Ride"] = 548.31}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.62, ["Fly"] = 30.1, ["Ride"] = 15.31, ["Fly|Ride"] = 43.99, ["Neon"] = 14.44, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 23.16, ["Neon|Fly|Ride"] = 103.63, ["Mega"] = 131.25, ["Mega|Ride"] = 155.09, ["Mega|Fly|Ride"] = 182.44}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 4.12, ["Ride"] = 20.46, ["Fly|Ride"] = 328.13, ["Neon"] = 29.81, ["Neon|Ride"] = 55.48, ["Neon|Fly|Ride"] = 155.09, ["Mega"] = 207.37, ["Mega|Ride"] = 213.59, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 34.35, ["Ride"] = 35.96, ["Neon"] = 2.1, ["Neon|Ride"] = 19.66, ["Neon|Fly|Ride"] = 47.24, ["Mega"] = 15.75, ["Mega|Ride"] = 50.33, ["Mega|Fly|Ride"] = 208299.34}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.46, ["Fly"] = 45.94, ["Ride"] = 17.43, ["Fly|Ride"] = 39.38, ["Neon"] = 14.44, ["Neon|Fly"] = 102.69, ["Neon|Ride"] = 34.93, ["Neon|Fly|Ride"] = 97.99, ["Mega"] = 84, ["Mega|Ride"] = 105.82, ["Mega|Fly|Ride"] = 170.62}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.38, ["Fly"] = 24.93, ["Ride"] = 17.07, ["Fly|Ride"] = 45.94, ["Neon"] = 22.32, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 109.88, ["Mega"] = 283.5, ["Mega|Ride"] = 201.37, ["Mega|Fly|Ride"] = 205.37}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 167.78, ["Fly"] = 273.13, ["Ride"] = 249.98, ["Fly|Ride"] = 219.75, ["Neon"] = 700.88, ["Neon|Ride"] = 647.33, ["Neon|Fly|Ride"] = 773.55, ["Mega|Ride"] = 3478.13, ["Mega|Fly|Ride"] = 3645.08}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 6.04, ["Ride"] = 30.81, ["Fly|Ride"] = 206.07, ["Neon"] = 77.44, ["Neon|Ride"] = 160.13, ["Neon|Fly|Ride"] = 376.56, ["Mega"] = 342.97, ["Mega|Ride"] = 369.65, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 15.42, ["Ride"] = 16.21, ["Fly|Ride"] = 43.26, ["Neon"] = 40.52, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 183.75, ["Mega|Ride"] = 221.82, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 17.71, ["Ride"] = 41.09, ["Fly|Ride"] = 170.63, ["Neon"] = 118.04, ["Neon|Ride"] = 148.31, ["Neon|Fly|Ride"] = 501.11, ["Mega"] = 453.14, ["Mega|Ride"] = 469.88, ["Mega|Fly|Ride"] = 705.91}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 5.13}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 3.29, ["Ride"] = 25.48, ["Neon"] = 27.74, ["Neon|Ride"] = 153.87, ["Neon|Fly|Ride"] = 616.07, ["Mega"] = 367.5, ["Mega|Ride"] = 404.25, ["Mega|Fly|Ride"] = 683.85}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 26.7, ["Fly"] = 77.66, ["Ride"] = 26.23, ["Fly|Ride"] = 53.25, ["Neon"] = 178.67, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 159.38, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 2053.57, ["Mega|Fly|Ride"] = 832.73}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 78.75, ["Neon"] = 3.94, ["Neon|Ride"] = 49.3, ["Neon|Fly|Ride"] = 105, ["Mega"] = 35.43, ["Mega|Fly"] = 410.73, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 131.23}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 10.18, ["Fly"] = 27.6, ["Ride"] = 26.63, ["Fly|Ride"] = 61.62, ["Neon"] = 32.81, ["Neon|Ride"] = 231.47, ["Mega"] = 229.04, ["Mega|Fly"] = 386.53, ["Mega|Ride"] = 147, ["Mega|Fly|Ride"] = 381.97}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 17.26, ["Fly|Ride"] = 43.35, ["Neon"] = 15.28, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 29.85, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 133.71, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 209.9}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 3.56, ["Neon|Ride"] = 30.81, ["Neon|Fly|Ride"] = 410.73, ["Mega"] = 26.25, ["Mega|Ride"] = 81.02, ["Mega|Fly|Ride"] = 137.61}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 29.55, ["Fly"] = 39.38, ["Ride"] = 131.25, ["Neon"] = 219.75, ["Neon|Fly"] = 194.25, ["Neon|Ride"] = 274.32, ["Neon|Fly|Ride"] = 581.63, ["Mega"] = 902.45, ["Mega|Ride"] = 1037.06, ["Mega|Fly|Ride"] = 1021.99}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.57, ["Ride"] = 50.93, ["Neon"] = 80.07, ["Neon|Ride"] = 137.61, ["Neon|Fly|Ride"] = 205.37, ["Mega"] = 274.16, ["Mega|Ride"] = 274.16}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 5.11, ["Fly"] = 87.49, ["Ride"] = 39.03, ["Fly|Ride"] = 69.56, ["Neon"] = 44.62, ["Neon|Fly"] = 315, ["Neon|Ride"] = 102.69, ["Neon|Fly|Ride"] = 155.09, ["Mega"] = 573.96, ["Mega|Ride"] = 320.25, ["Mega|Fly|Ride"] = 410.73}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 68.81, ["Fly"] = 433.13, ["Ride"] = 105, ["Fly|Ride"] = 262.44, ["Neon"] = 406.63, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 684.88, ["Mega"] = 1601.78, ["Mega|Ride"] = 2034.38, ["Mega|Fly|Ride"] = 1308.13}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 11.06, ["Fly"] = 39.38, ["Ride"] = 28.87, ["Fly|Ride"] = 60.59, ["Neon"] = 68.81, ["Neon|Ride"] = 66.94, ["Neon|Fly|Ride"] = 136.5, ["Mega"] = 261.87, ["Mega|Ride"] = 240.72, ["Mega|Fly|Ride"] = 505.19}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 80.56, ["Fly"] = 151.97, ["Ride"] = 112.48, ["Neon"] = 203.44, ["Neon|Fly"] = 498.75, ["Neon|Ride"] = 225.75, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 979.14, ["Mega|Ride"] = 1000.1, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 19.52, ["Fly"] = 123.22, ["Ride"] = 60.19, ["Fly|Ride"] = 171.28, ["Neon"] = 62.25, ["Neon|Ride"] = 137.61, ["Neon|Fly|Ride"] = 266.98, ["Mega"] = 384.21, ["Mega|Ride"] = 274.23, ["Mega|Fly|Ride"] = 416.05}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 8.89, ["Fly"] = 233.65, ["Ride"] = 27.74, ["Fly|Ride"] = 41.09, ["Neon"] = 82.69, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 368.01, ["Mega"] = 623.76, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 18.54, ["Ride"] = 105, ["Fly|Ride"] = 151.68, ["Neon"] = 90.57, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 255.2, ["Mega|Fly"] = 495.95, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 7.33, ["Ride"] = 39.36, ["Fly|Ride"] = 135.61, ["Neon"] = 43.26, ["Neon|Ride"] = 100.65, ["Neon|Fly|Ride"] = 137.61, ["Mega"] = 385.06, ["Mega|Ride"] = 306.39, ["Mega|Fly|Ride"] = 343.82}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Fly"] = 53.41, ["Neon|Ride"] = 56.44, ["Mega"] = 13.13, ["Mega|Fly"] = 137.61, ["Mega|Ride"] = 68.81, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.74, ["Ride"] = 27.26, ["Fly|Ride"] = 426.13, ["Neon"] = 18.75, ["Neon|Fly"] = 123.22, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 95.82, ["Mega|Ride"] = 492.86, ["Mega|Fly|Ride"] = 462.91}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.55, ["Fly"] = 46.31, ["Neon"] = 23.61, ["Neon|Ride"] = 205.37, ["Mega"] = 182.86, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 4.07, ["Ride"] = 32.78, ["Fly|Ride"] = 114.58, ["Neon"] = 15.75, ["Neon|Ride"] = 82.16, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 123.37, ["Mega|Ride"] = 208.31, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 543.37, ["Ride"] = 548.31, ["Fly|Ride"] = 590.63, ["Neon"] = 1702.41, ["Neon|Ride"] = 1439.24, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 5878.95}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 7.52, ["Fly"] = 27.74, ["Ride"] = 23.16, ["Fly|Ride"] = 59.56, ["Neon"] = 35.89, ["Neon|Ride"] = 68.81, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 369.65, ["Mega|Fly|Ride"] = 492.86}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 6.15, ["Fly"] = 39.38, ["Ride"] = 26.25, ["Fly|Ride"] = 60.38, ["Neon"] = 76.12, ["Neon|Ride"] = 53.96, ["Mega"] = 273.13, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 328.12}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 4.5, ["Ride"] = 17.07, ["Fly|Ride"] = 308.04, ["Neon"] = 12.75, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 149.92, ["Mega"] = 260.39, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 64.97, ["Ride"] = 24.94, ["Fly|Ride"] = 90.57, ["Neon"] = 7.61, ["Neon|Ride"] = 31, ["Neon|Fly|Ride"] = 91.61, ["Mega"] = 68.25, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 245.09}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 68.81, ["Ride"] = 17.07, ["Neon"] = 3.94, ["Neon|Ride"] = 24.05, ["Neon|Fly|Ride"] = 72.92, ["Mega"] = 22.31, ["Mega|Ride"] = 77.43, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1106.44}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 6.49, ["Ride"] = 41.09, ["Fly|Ride"] = 68.81, ["Neon"] = 68.81, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 178.67, ["Mega|Ride"] = 548.31, ["Mega|Fly|Ride"] = 845.06}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 28.26, ["Neon"] = 5.19, ["Neon|Ride"] = 40.69, ["Mega"] = 39.15, ["Mega|Ride"] = 151.97, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 3.9, ["Fly"] = 96.54, ["Ride"] = 58.49, ["Fly|Ride"] = 39.38, ["Neon"] = 7.83, ["Neon|Fly"] = 123.22, ["Neon|Ride"] = 68.85, ["Neon|Fly|Ride"] = 684.88, ["Mega"] = 151.97, ["Mega|Ride"] = 221.82, ["Mega|Fly|Ride"] = 309}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 446.25, ["Ride"] = 490.81, ["Fly|Ride"] = 467.7, ["Neon|Ride"] = 1570.98, ["Neon|Fly|Ride"] = 1205.4, ["Mega|Fly|Ride"] = 7528.34}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 5.25, ["Fly"] = 196.88, ["Ride"] = 96.54, ["Neon"] = 137.82, ["Neon|Ride"] = 73.5, ["Neon|Fly|Ride"] = 186.63, ["Mega"] = 457.95, ["Mega|Ride"] = 410.73}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.52, ["Ride"] = 29.29, ["Fly|Ride"] = 141.71, ["Neon"] = 4.92, ["Neon|Ride"] = 38.05, ["Neon|Fly|Ride"] = 124.14, ["Mega"] = 40.67, ["Mega|Fly"] = 189, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 205.37}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 821.44, ["Neon"] = 3.94, ["Neon|Ride"] = 109.85, ["Neon|Fly|Ride"] = 260.81, ["Mega"] = 23.92, ["Mega|Ride"] = 113.67, ["Mega|Fly|Ride"] = 217.7}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 11.69, ["Fly"] = 107.62, ["Ride"] = 36.99, ["Fly|Ride"] = 178.5, ["Neon"] = 61.52, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 328.58, ["Mega"] = 577.47, ["Mega|Fly|Ride"] = 513.4}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 6.57, ["Neon"] = 108.81, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 393.75, ["Mega|Ride"] = 479.72, ["Mega|Fly|Ride"] = 1063.79}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 5.24, ["Ride"] = 39.38, ["Fly|Ride"] = 137.61, ["Neon"] = 27.74, ["Neon|Ride"] = 155.09, ["Mega"] = 633.02, ["Mega|Ride"] = 958, ["Mega|Fly|Ride"] = 1232.14}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 18.38, ["Ride"] = 34.93, ["Neon"] = 162.25, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 184.83, ["Mega"] = 459.38, ["Mega|Ride"] = 613.6, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 301.88, ["Ride"] = 423.05, ["Fly|Ride"] = 616.88, ["Neon"] = 1640.81, ["Neon|Ride"] = 1641.84, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Ride"] = 4106.09, ["Mega|Fly|Ride"] = 3696.4}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 6.57, ["Fly"] = 69.65, ["Ride"] = 23.63, ["Fly|Ride"] = 51.35, ["Neon"] = 98.44, ["Neon|Ride"] = 137.61, ["Neon|Fly|Ride"] = 158.15, ["Mega|Ride"] = 544.04, ["Mega|Fly|Ride"] = 846.08}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.82, ["Ride"] = 125.98, ["Fly|Ride"] = 78.75, ["Neon"] = 18.38, ["Neon|Ride"] = 221.82, ["Mega"] = 131.25, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 771.88}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 17.68, ["Ride"] = 68.25, ["Fly|Ride"] = 253.68, ["Neon"] = 44.63, ["Neon|Ride"] = 114.83, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 262.5, ["Mega|Fly"] = 548.31, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 324.11}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Fly"] = 40.52, ["Ride"] = 52.5, ["Fly|Ride"] = 123.22, ["Neon"] = 7.25, ["Neon|Ride"] = 157.48, ["Neon|Fly|Ride"] = 137.61, ["Mega"] = 42.39, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 138.89}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 51.35, ["Ride"] = 91.88, ["Fly|Ride"] = 157.5, ["Neon"] = 231.49, ["Neon|Ride"] = 294.7, ["Neon|Fly|Ride"] = 462.06, ["Mega"] = 1780.45, ["Mega|Ride"] = 1232.14, ["Mega|Fly|Ride"] = 1316.34}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.63, ["Fly"] = 56.44, ["Ride"] = 31.85, ["Neon"] = 10.49, ["Neon|Fly"] = 156.97, ["Neon|Ride"] = 39.03, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 85.64, ["Mega|Ride"] = 100.8, ["Mega|Fly|Ride"] = 205.37}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.63, ["Fly"] = 31.26, ["Ride"] = 27.57, ["Fly|Ride"] = 148.25, ["Neon"] = 6.18, ["Neon|Fly"] = 68.3, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 131.44, ["Mega"] = 77.56, ["Mega|Ride"] = 96.54, ["Mega|Fly|Ride"] = 179.25}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.63, ["Fly"] = 1519.88, ["Ride"] = 27.57, ["Fly|Ride"] = 262.5, ["Neon"] = 18.38, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 116.82, ["Mega|Fly"] = 459.38, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 270.38}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 123.22, ["Ride"] = 105.37, ["Neon"] = 437.07, ["Neon|Ride"] = 309, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 262.5, ["Fly"] = 171.28, ["Ride"] = 309.74, ["Fly|Ride"] = 415.9, ["Neon"] = 1427.24, ["Neon|Ride"] = 1095.59, ["Neon|Fly|Ride"] = 1036.88, ["Mega"] = 6160.67, ["Mega|Fly|Ride"] = 4937.86}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 6.95, ["Ride"] = 30.1, ["Neon"] = 60.38, ["Neon|Ride"] = 152.02, ["Mega"] = 91.88, ["Mega|Ride"] = 183.02, ["Mega|Fly|Ride"] = 416.61}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 3.94, ["Ride"] = 32.82, ["Neon"] = 19.69, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 137.61, ["Mega"] = 58.61, ["Mega|Fly"] = 157.5, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.55, ["Fly"] = 30.1, ["Ride"] = 20.56, ["Fly|Ride"] = 174.57, ["Neon"] = 36.75, ["Mega"] = 345.85, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 346.5}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 3.56, ["Fly"] = 58.92, ["Ride"] = 20.55, ["Fly|Ride"] = 65.63, ["Neon"] = 9.09, ["Neon|Ride"] = 34.74, ["Neon|Fly|Ride"] = 137.91, ["Mega"] = 84.36, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 236.23}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 27.76, ["Neon"] = 8.65, ["Mega"] = 32.82, ["Mega|Fly|Ride"] = 271.08}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 15.75, ["Fly|Ride"] = 41.99, ["Neon"] = 5.25, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 97.56, ["Mega"] = 43.31, ["Mega|Ride"] = 73.95, ["Mega|Fly|Ride"] = 137.61}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 90.37, ["Ride"] = 20.46, ["Fly|Ride"] = 53.4, ["Neon"] = 8.87, ["Neon|Fly"] = 85.65, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 63.38, ["Mega"] = 156.15, ["Mega|Ride"] = 231.04, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 25.47, ["Fly"] = 35.88, ["Ride"] = 42, ["Fly|Ride"] = 82.56, ["Neon"] = 171.49, ["Neon|Ride"] = 233.09, ["Neon|Fly|Ride"] = 205.37, ["Mega"] = 459.38, ["Mega|Fly"] = 525, ["Mega|Ride"] = 409.5, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 65.89, ["Fly"] = 582.75, ["Ride"] = 82.06, ["Fly|Ride"] = 137.61, ["Neon"] = 354.38, ["Neon|Ride"] = 389.82, ["Mega"] = 1575.09, ["Mega|Ride"] = 1642.87, ["Mega|Fly|Ride"] = 1410.73}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Fly"] = 34.8, ["Ride"] = 23.24, ["Fly|Ride"] = 131.25, ["Neon"] = 3.94, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.57, ["Mega"] = 37.7, ["Mega|Fly"] = 672, ["Mega|Ride"] = 61.66, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 16.45, ["Ride"] = 15.73, ["Fly|Ride"] = 35.43, ["Neon"] = 4.2, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 20.55, ["Neon|Fly|Ride"] = 61.68, ["Mega"] = 49.86, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 5.24, ["Ride"] = 73.48, ["Fly|Ride"] = 131.25, ["Neon"] = 246.44, ["Neon|Ride"] = 46.47, ["Neon|Fly|Ride"] = 273.13, ["Mega"] = 260.95, ["Mega|Ride"] = 410.73, ["Mega|Fly|Ride"] = 636.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 354.38, ["Fly"] = 393.75, ["Ride"] = 541.12, ["Fly|Ride"] = 498.75, ["Neon|Ride"] = 1780.45, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 6571.38}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 30.17, ["Fly"] = 90.17, ["Ride"] = 61.62, ["Fly|Ride"] = 102.69, ["Neon"] = 252.6, ["Neon|Ride"] = 205.37, ["Neon|Fly|Ride"] = 260.81, ["Mega|Ride"] = 1232.14}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 35.88, ["Fly|Ride"] = 105, ["Neon"] = 14.43, ["Neon|Ride"] = 155.09, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 102.69, ["Mega|Ride"] = 102.71, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 4.12, ["Fly"] = 205.37, ["Ride"] = 65.63, ["Fly|Ride"] = 195.11, ["Neon"] = 27.74}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 25.99, ["Fly"] = 45.94, ["Ride"] = 57.75, ["Fly|Ride"] = 68.83, ["Neon"] = 118.13, ["Neon|Ride"] = 279.11, ["Neon|Fly|Ride"] = 527.63, ["Mega"] = 2464.27, ["Mega|Fly|Ride"] = 1234.76}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 106.4, ["Ride"] = 99.75, ["Fly|Ride"] = 188.65, ["Neon"] = 498.75, ["Neon|Ride"] = 469.88, ["Neon|Fly|Ride"] = 478.49, ["Mega"] = 8214.22, ["Mega|Fly|Ride"] = 1868.75}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 233.36, ["Ride"] = 262.5, ["Fly|Ride"] = 369.65, ["Neon"] = 820.41, ["Neon|Ride"] = 1095.59, ["Neon|Fly|Ride"] = 1026.8, ["Mega|Fly|Ride"] = 3217.94}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 13.1, ["Ride"] = 49.77, ["Fly|Ride"] = 150.94, ["Neon"] = 73.5, ["Neon|Ride"] = 158.15, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 370.69, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 18.38, ["Fly|Ride"] = 28.88, ["Neon"] = 8.29, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 91.23, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.27, ["Fly"] = 19.69, ["Ride"] = 21.57, ["Neon"] = 40.85, ["Neon|Fly"] = 143.76, ["Neon|Ride"] = 269.03, ["Neon|Fly|Ride"] = 102.69, ["Mega"] = 314.22, ["Mega|Ride"] = 274.24, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 288.75, ["Fly"] = 479.52, ["Ride"] = 326.82, ["Fly|Ride"] = 410.73, ["Neon"] = 984.38, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1575, ["Mega|Ride"] = 5337.2, ["Mega|Fly|Ride"] = 5702.73}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 60.59, ["Neon"] = 13.13, ["Neon|Ride"] = 55.46, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 45.94, ["Mega|Ride"] = 178.7, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.18, ["Fly"] = 20.85, ["Ride"] = 18.54, ["Fly|Ride"] = 41.09, ["Neon"] = 49.87, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 105.77, ["Mega"] = 176.61, ["Mega|Fly"] = 204.9, ["Mega|Ride"] = 185.17, ["Mega|Fly|Ride"] = 309.51}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 14.43, ["Ride"] = 114.19, ["Neon"] = 103.69, ["Neon|Fly"] = 410.73, ["Neon|Ride"] = 142.14, ["Neon|Fly|Ride"] = 387.19, ["Mega"] = 463.07, ["Mega|Ride"] = 520.58, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 155.08, ["Fly"] = 137.61, ["Ride"] = 131.25, ["Fly|Ride"] = 164.3, ["Neon|Ride"] = 684.88, ["Neon|Fly|Ride"] = 656.25, ["Mega|Fly|Ride"] = 2010.75}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 23.08, ["Fly"] = 47.24, ["Ride"] = 26.35, ["Fly|Ride"] = 61.68, ["Neon"] = 72.19, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 163.28, ["Mega"] = 616.07, ["Mega|Ride"] = 507.66, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 41.2, ["Neon"] = 3.78, ["Neon|Ride"] = 138.67, ["Neon|Fly|Ride"] = 684.88, ["Mega"] = 20.57, ["Mega|Ride"] = 273.13, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 15.6, ["Fly|Ride"] = 52.5, ["Neon"] = 2.99, ["Neon|Fly"] = 155.1, ["Neon|Ride"] = 20.46, ["Neon|Fly|Ride"] = 69.51, ["Mega"] = 27.57, ["Mega|Fly"] = 97.12, ["Mega|Ride"] = 51.19, ["Mega|Fly|Ride"] = 109.88}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 11.55, ["Fly"] = 410.73, ["Ride"] = 68.23, ["Fly|Ride"] = 172.51, ["Neon"] = 36.75, ["Neon|Fly"] = 222.23, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 174.57, ["Mega"] = 151.33, ["Mega|Fly"] = 274.16, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 294.63}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1446.38, ["Ride"] = 1312.5, ["Fly|Ride"] = 1488.38, ["Neon"] = 4200, ["Neon|Fly|Ride"] = 4823.8, ["Mega|Fly|Ride"] = 10762.5}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 419.99, ["Ride"] = 479.07, ["Fly|Ride"] = 505.03, ["Neon"] = 1903.11, ["Neon|Ride"] = 1179.94, ["Neon|Fly|Ride"] = 1813.53, ["Mega"] = 16428.43, ["Mega|Fly|Ride"] = 7084.88}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 330.27, ["Ride"] = 360.29, ["Fly|Ride"] = 419.99, ["Neon"] = 656.25, ["Neon|Fly"] = 1234.9, ["Neon|Ride"] = 617.76, ["Neon|Fly|Ride"] = 761.25, ["Mega|Fly|Ride"] = 3067.21}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 324.85, ["Fly"] = 413.12, ["Ride"] = 369.65, ["Fly|Ride"] = 452.82, ["Neon"] = 1205.45, ["Neon|Fly"] = 1369.74, ["Neon|Ride"] = 968.63, ["Neon|Fly|Ride"] = 971.25, ["Mega|Fly|Ride"] = 4615.37}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 23.39, ["Ride"] = 17.37, ["Fly|Ride"] = 39.38, ["Neon"] = 7.87, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 82.16, ["Mega"] = 63.78, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 410.82, ["Ride"] = 524.99, ["Fly|Ride"] = 787.5, ["Neon"] = 1680, ["Neon|Ride"] = 1509.37, ["Neon|Fly|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 8100.54}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.59, ["Fly"] = 183.75, ["Ride"] = 112.53, ["Neon"] = 9.65, ["Neon|Ride"] = 64.71, ["Neon|Fly|Ride"] = 155.09, ["Mega"] = 65.63, ["Mega|Ride"] = 78.66, ["Mega|Fly|Ride"] = 271.08}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 24.66, ["Ride"] = 20.54, ["Fly|Ride"] = 39.38, ["Neon"] = 16.45, ["Neon|Ride"] = 48.27, ["Neon|Fly|Ride"] = 100.84, ["Mega"] = 105, ["Mega|Ride"] = 192.93}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.63, ["Neon"] = 4.57, ["Neon|Ride"] = 39.37, ["Mega"] = 23.63, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 246.43}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 45.48, ["Ride"] = 65.63, ["Fly|Ride"] = 459.38, ["Neon"] = 210, ["Neon|Ride"] = 342.97, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 8038.15, ["Ride"] = 21, ["Fly|Ride"] = 60.44, ["Neon"] = 26.25, ["Neon|Ride"] = 77.56, ["Mega"] = 328.13, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 3.93, ["Neon|Fly"] = 118.09, ["Neon|Ride"] = 29.19, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 39.37, ["Mega|Fly"] = 684.88, ["Mega|Ride"] = 155.29, ["Mega|Fly|Ride"] = 110.25}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 35.9, ["Ride"] = 20.55, ["Fly|Ride"] = 61.23, ["Neon"] = 12.5, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 30.37, ["Neon|Fly|Ride"] = 82.43, ["Mega"] = 52.5, ["Mega|Fly"] = 171.49, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 183.74}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 8.24, ["Fly"] = 55.46, ["Ride"] = 22.6, ["Fly|Ride"] = 51.45, ["Neon"] = 151.97, ["Neon|Fly"] = 73.95, ["Neon|Ride"] = 137.61, ["Neon|Fly|Ride"] = 245.41, ["Mega"] = 237.57, ["Mega|Ride"] = 300.51, ["Mega|Fly|Ride"] = 309}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 14.33, ["Ride"] = 51.19, ["Neon"] = 56.44, ["Neon|Ride"] = 274.16, ["Neon|Fly|Ride"] = 262.7, ["Mega"] = 309, ["Mega|Ride"] = 439.48, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 3.92, ["Fly"] = 6172.56, ["Ride"] = 26.71, ["Neon"] = 24.44, ["Neon|Ride"] = 137.61, ["Neon|Fly|Ride"] = 274.16, ["Mega"] = 439.03, ["Mega|Ride"] = 479.52, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 18.16, ["Fly|Ride"] = 84, ["Neon"] = 5.25, ["Neon|Fly"] = 27.74, ["Neon|Ride"] = 19.69, ["Mega"] = 41.99, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 231.47}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 208.69, ["Ride"] = 224.68, ["Fly|Ride"] = 308.44, ["Neon|Ride"] = 2566.95, ["Neon|Fly|Ride"] = 1136.65, ["Mega"] = 8214.22, ["Mega|Fly|Ride"] = 4198.58}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 15.75, ["Fly|Ride"] = 35.44, ["Neon"] = 3.94, ["Neon|Fly"] = 51.35, ["Neon|Ride"] = 21.55, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 27.74, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 10.4, ["Ride"] = 55.46, ["Fly|Ride"] = 183.73, ["Neon"] = 102.38, ["Neon|Ride"] = 100.66, ["Mega"] = 459.25, ["Mega|Fly|Ride"] = 464.35}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 22.6, ["Fly"] = 210, ["Ride"] = 192.03, ["Fly|Ride"] = 167.23, ["Neon"] = 196.88, ["Neon|Ride"] = 309, ["Mega"] = 821.44, ["Mega|Ride"] = 849.16, ["Mega|Fly|Ride"] = 911.79}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 178.19, ["Ride"] = 223.57, ["Fly|Ride"] = 328.13, ["Neon"] = 820.41, ["Neon|Fly"] = 1157.23, ["Neon|Ride"] = 786.53, ["Neon|Fly|Ride"] = 740.25, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 20.25, ["Ride"] = 37.43, ["Fly|Ride"] = 138.89, ["Neon"] = 123.38, ["Mega"] = 286.79, ["Mega|Ride"] = 397.38, ["Mega|Fly|Ride"] = 1232.14}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 101.35, ["Ride"] = 48.57, ["Fly|Ride"] = 616.07, ["Neon"] = 1437.51, ["Neon|Ride"] = 192.94, ["Mega"] = 1642.87, ["Mega|Ride"] = 1642.87, ["Mega|Fly|Ride"] = 928.23}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1050, ["Fly"] = 1440.58, ["Ride"] = 1140.57, ["Fly|Ride"] = 1162.88, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 5091.77, ["Mega|Fly|Ride"] = 16974.67}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 15.31, ["Fly"] = 21, ["Ride"] = 19.56, ["Fly|Ride"] = 42, ["Neon"] = 44.17, ["Neon|Fly"] = 72.95, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 96.54, ["Mega|Ride"] = 219.75, ["Mega|Fly|Ride"] = 308.04}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 4.47, ["Fly"] = 65.63, ["Ride"] = 38.07, ["Neon"] = 30.24, ["Neon|Ride"] = 155.09, ["Neon|Fly|Ride"] = 548.31, ["Mega"] = 341.39, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 217.7, ["Mega|Fly|Ride"] = 579.11}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.63, ["Fly"] = 81.13, ["Ride"] = 22.32, ["Fly|Ride"] = 69.57, ["Neon"] = 12.77, ["Neon|Ride"] = 39.36, ["Mega"] = 90.55, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 548.31}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 17.07, ["Fly"] = 684.88, ["Ride"] = 41.09, ["Fly|Ride"] = 103, ["Neon"] = 76.12, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 328.13, ["Mega|Ride"] = 393.31, ["Mega|Fly|Ride"] = 540.44}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 3.68, ["Fly"] = 20.99, ["Ride"] = 20.48, ["Fly|Ride"] = 41.09, ["Neon"] = 137.61, ["Neon|Ride"] = 30.81, ["Neon|Fly|Ride"] = 62.35, ["Mega"] = 147.87, ["Mega|Ride"] = 273.26, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.52, ["Fly"] = 410.73, ["Ride"] = 35.96, ["Neon"] = 10.4, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 68.23, ["Neon|Fly|Ride"] = 821.44, ["Mega"] = 103.76, ["Mega|Fly"] = 164.3, ["Mega|Ride"] = 191.02, ["Mega|Fly|Ride"] = 318.32}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 349.13, ["Ride"] = 437.07, ["Fly|Ride"] = 586.72, ["Neon|Ride"] = 1312.29, ["Neon|Fly|Ride"] = 1335.45}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 3.94, ["Fly"] = 26.25, ["Ride"] = 18.38, ["Fly|Ride"] = 64.71, ["Neon"] = 9.21, ["Neon|Fly"] = 82.16, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 119.84, ["Mega"] = 77.56, ["Mega|Ride"] = 110.24, ["Mega|Fly|Ride"] = 233.09}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 5.14, ["Ride"] = 81.77, ["Neon"] = 137.61, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27, ["Mega|Ride"] = 328.55}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.46, ["Fly"] = 89.42, ["Ride"] = 55.46, ["Neon"] = 10.77, ["Neon|Ride"] = 55.48, ["Neon|Fly|Ride"] = 273.95, ["Mega"] = 84.94, ["Mega|Ride"] = 246.44, ["Mega|Fly|Ride"] = 328.58}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 262.5, ["Ride"] = 308.99, ["Fly|Ride"] = 1036.23, ["Neon"] = 821.44, ["Neon|Ride"] = 821.44, ["Neon|Fly|Ride"] = 1050, ["Mega|Ride"] = 3055.07, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 23.61, ["Fly"] = 54.8, ["Ride"] = 40.68, ["Fly|Ride"] = 105, ["Neon"] = 122.26, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 771.88, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 767.01}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 22.32, ["Ride"] = 76.13, ["Fly|Ride"] = 117.07, ["Neon"] = 124.69, ["Neon|Ride"] = 123.38, ["Neon|Fly|Ride"] = 257.25, ["Mega"] = 501.22, ["Mega|Ride"] = 429.19, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 6.45, ["Neon|Ride"] = 44.18, ["Mega"] = 27.43, ["Mega|Ride"] = 183.74}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 57.75, ["Fly"] = 83.61, ["Ride"] = 119.44, ["Fly|Ride"] = 179.82, ["Neon"] = 262.47, ["Neon|Fly"] = 303.14, ["Neon|Ride"] = 253.72, ["Neon|Fly|Ride"] = 366.85, ["Mega|Fly|Ride"] = 1113.7}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 18.83, ["Neon"] = 5.25, ["Neon|Ride"] = 55.46, ["Neon|Fly|Ride"] = 588, ["Mega"] = 45.08, ["Mega|Fly|Ride"] = 409.7}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 21, ["Fly"] = 137.61, ["Ride"] = 23.63, ["Fly|Ride"] = 68.39, ["Neon"] = 45.94, ["Neon|Ride"] = 108.8, ["Neon|Fly|Ride"] = 246.44, ["Mega"] = 382.05, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 405.6, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 39.36, ["Fly"] = 110.06, ["Ride"] = 79.95, ["Fly|Ride"] = 102.1, ["Neon"] = 274.16, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 355.69, ["Mega|Ride"] = 1313.26, ["Mega|Fly|Ride"] = 1089.97}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 30.1, ["Ride"] = 15.42, ["Fly|Ride"] = 33.64, ["Neon"] = 2.62, ["Neon|Fly"] = 27.74, ["Neon|Ride"] = 17.05, ["Neon|Fly|Ride"] = 59.04, ["Mega"] = 18.38, ["Mega|Fly"] = 115.74, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 89.48}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 9.28, ["Ride"] = 33.57, ["Fly|Ride"] = 1333.8, ["Neon"] = 23.63, ["Neon|Ride"] = 58.54, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 472.5, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 31.32, ["Fly"] = 137.61, ["Ride"] = 39.38, ["Neon"] = 111.44, ["Neon|Ride"] = 192.03, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 545.23, ["Mega|Ride"] = 517.51, ["Mega|Fly|Ride"] = 684.88}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.78, ["Neon"] = 2.63, ["Neon|Ride"] = 18.37, ["Neon|Fly|Ride"] = 95.8, ["Mega"] = 30.81, ["Mega|Ride"] = 77.56, ["Mega|Fly|Ride"] = 205.37}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 7.77, ["Ride"] = 52.38, ["Fly|Ride"] = 120.74, ["Neon"] = 80.07, ["Neon|Ride"] = 68.81, ["Neon|Fly|Ride"] = 185.17, ["Mega"] = 548.31, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 309, ["Mega|Fly|Ride"] = 432.73}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 20.85, ["Fly"] = 27.75, ["Ride"] = 27.66, ["Fly|Ride"] = 45.94, ["Neon"] = 212.7, ["Neon|Ride"] = 118.06, ["Mega"] = 431.26, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 7.85, ["Ride"] = 17.37, ["Fly|Ride"] = 76.02, ["Neon"] = 32.02, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 118.02, ["Mega"] = 170.63, ["Mega|Ride"] = 226.61, ["Mega|Fly|Ride"] = 309}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 20.99, ["Fly"] = 2053.57, ["Ride"] = 42, ["Fly|Ride"] = 155.08, ["Neon"] = 486.7, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 6171.45, ["Mega"] = 410.73, ["Mega|Ride"] = 507.94, ["Mega|Fly|Ride"] = 546.67}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 41.09, ["Ride"] = 137.61, ["Fly|Ride"] = 196.87, ["Neon"] = 9, ["Neon|Fly"] = 55.46, ["Neon|Ride"] = 68.81, ["Mega"] = 65.63, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 123.84}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 55.53, ["Neon"] = 5.25, ["Neon|Ride"] = 89.17, ["Mega"] = 29.87, ["Mega|Ride"] = 76.12, ["Mega|Fly|Ride"] = 209.37}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 47.25}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 39.38, ["Fly"] = 102.38, ["Ride"] = 68.81, ["Fly|Ride"] = 205.37, ["Neon"] = 131.25, ["Neon|Ride"] = 204.53, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1223.93, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 835.82}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.91, ["Mega"] = 41.09, ["Mega|Ride"] = 164.3, ["Mega|Fly|Ride"] = 219.75}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 380.63, ["Ride"] = 446.25, ["Fly|Ride"] = 641.82, ["Neon"] = 2625, ["Mega"] = 16428.43}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 6, ["Fly"] = 25.99, ["Ride"] = 39.37, ["Fly|Ride"] = 66.26, ["Neon"] = 13.13, ["Neon|Ride"] = 273.13, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 68.81, ["Mega|Fly"] = 141.71, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 205.37}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.61, ["Fly"] = 155.08, ["Ride"] = 21.67, ["Fly|Ride"] = 63, ["Neon"] = 17.07, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 346.5, ["Mega|Ride"] = 159.11, ["Mega|Fly|Ride"] = 330.75}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 15.08, ["Fly"] = 77.02, ["Ride"] = 72.19, ["Fly|Ride"] = 513.4, ["Neon"] = 69.45, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 792.68, ["Mega|Ride"] = 397.38}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.94, ["Fly"] = 131.25, ["Ride"] = 32.16, ["Mega"] = 255.94}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 13.13, ["Ride"] = 92.59, ["Fly|Ride"] = 157.49, ["Neon"] = 52.5, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 359, ["Mega|Ride"] = 400.98, ["Mega|Fly|Ride"] = 649.04}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 6.44, ["Fly"] = 104.99, ["Ride"] = 32.82, ["Fly|Ride"] = 184.83, ["Neon"] = 55.46, ["Neon|Ride"] = 100.65, ["Neon|Fly|Ride"] = 137.61, ["Mega"] = 216.47, ["Mega|Fly"] = 478.49, ["Mega|Ride"] = 246.44, ["Mega|Fly|Ride"] = 282.19}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 14.44, ["Fly|Ride"] = 66.93, ["Neon"] = 2.63, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 15.15, ["Neon|Fly|Ride"] = 76.97, ["Mega"] = 14.79, ["Mega|Fly"] = 61.62, ["Mega|Ride"] = 35.39, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 8.54, ["Fly"] = 274.16, ["Ride"] = 27.57, ["Fly|Ride"] = 155.08, ["Neon"] = 23.16, ["Neon|Fly"] = 115.74, ["Neon|Ride"] = 68.81, ["Neon|Fly|Ride"] = 109.95, ["Mega"] = 144.38, ["Mega|Ride"] = 164.3, ["Mega|Fly|Ride"] = 410.73}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 275.62, ["Fly"] = 416.61, ["Ride"] = 315, ["Fly|Ride"] = 393.75, ["Neon"] = 1449.82, ["Neon|Ride"] = 1404.38, ["Neon|Fly|Ride"] = 1046.06, ["Mega|Fly|Ride"] = 4201.58}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 96.54, ["Ride"] = 137.27, ["Fly|Ride"] = 196.88, ["Neon"] = 342.97, ["Neon|Ride"] = 521.61, ["Neon|Fly|Ride"] = 684.88, ["Mega"] = 4107.11, ["Mega|Ride"] = 1506.29, ["Mega|Fly|Ride"] = 1701}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 16.98, ["Ride"] = 15.42, ["Fly|Ride"] = 39.38, ["Neon"] = 7.88, ["Neon|Fly"] = 68.81, ["Neon|Ride"] = 32.88, ["Neon|Fly|Ride"] = 62.56, ["Mega"] = 59.56, ["Mega|Fly"] = 204.35, ["Mega|Ride"] = 123.22, ["Mega|Fly|Ride"] = 164.3}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 20.79, ["Ride"] = 15.75, ["Fly|Ride"] = 39.03, ["Neon"] = 10.5, ["Neon|Fly"] = 39.14, ["Neon|Ride"] = 22.17, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 70.88, ["Mega|Fly"] = 105, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 3.94, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 38.07, ["Neon|Fly|Ride"] = 410.73, ["Mega"] = 137.61, ["Mega|Ride"] = 137.61, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 248.07, ["Fly"] = 420, ["Ride"] = 292.46, ["Fly|Ride"] = 367.5, ["Neon|Ride"] = 1162.32, ["Neon|Fly|Ride"] = 1333.8, ["Mega|Ride"] = 8214.22, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 3.84, ["Fly"] = 48.28, ["Ride"] = 17.06, ["Fly|Ride"] = 41, ["Neon"] = 17.37, ["Neon|Fly"] = 77.44, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 82.18, ["Mega"] = 224.44, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 4.13, ["Fly"] = 155.08, ["Ride"] = 68.81, ["Fly|Ride"] = 205.37, ["Neon"] = 36.99, ["Neon|Ride"] = 139.13, ["Mega"] = 246.44, ["Mega|Ride"] = 259.88, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 4.97, ["Neon|Ride"] = 131.24, ["Mega"] = 55.13, ["Mega|Ride"] = 96.56, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 15.95, ["Fly"] = 35.96, ["Ride"] = 24.42, ["Fly|Ride"] = 57.23, ["Neon"] = 78.66, ["Neon|Ride"] = 96.54, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 728.44, ["Mega|Ride"] = 501.38, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 52.73, ["Ride"] = 114.19, ["Fly|Ride"] = 209.99, ["Neon"] = 154.88, ["Neon|Fly"] = 549.7, ["Neon|Ride"] = 178.5, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 420, ["Mega|Fly"] = 2156.24, ["Mega|Ride"] = 427.88, ["Mega|Fly|Ride"] = 603.07}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 22.61, ["Fly"] = 55.46, ["Ride"] = 46.39, ["Fly|Ride"] = 95.99, ["Neon"] = 157.39, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 137.61, ["Neon|Fly|Ride"] = 189.58, ["Mega|Ride"] = 700.88, ["Mega|Fly|Ride"] = 808.1}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 19.05, ["Ride"] = 14.89, ["Fly|Ride"] = 31.26, ["Neon"] = 2.63, ["Neon|Fly"] = 30.1, ["Neon|Ride"] = 15.42, ["Neon|Fly|Ride"] = 60.59, ["Mega"] = 24.66, ["Mega|Fly"] = 412.51, ["Mega|Ride"] = 42.95, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 228.04, ["Ride"] = 262.5, ["Fly|Ride"] = 302.96, ["Neon"] = 3240.57, ["Neon|Ride"] = 890.33, ["Neon|Fly|Ride"] = 1259.87, ["Mega|Fly|Ride"] = 4365.87}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 10.49, ["Fly"] = 82.16, ["Ride"] = 58, ["Fly|Ride"] = 105, ["Neon"] = 127.86, ["Neon|Ride"] = 199.05, ["Neon|Fly|Ride"] = 328.12, ["Mega"] = 410.73, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.63, ["Fly"] = 19.53, ["Ride"] = 17.07, ["Fly|Ride"] = 39.38, ["Neon"] = 10.48, ["Neon|Ride"] = 25.66, ["Neon|Fly|Ride"] = 108.86, ["Mega"] = 59.04, ["Mega|Fly"] = 274.16, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 147.87}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.04, ["Fly"] = 138.2, ["Ride"] = 18.31, ["Fly|Ride"] = 55.46, ["Neon"] = 3.94, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 22, ["Neon|Fly|Ride"] = 102.54, ["Mega"] = 27.57, ["Mega|Fly"] = 137.61, ["Mega|Ride"] = 48.57, ["Mega|Fly|Ride"] = 155.09}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 3.39, ["Ride"] = 28.88, ["Fly|Ride"] = 69.27, ["Neon"] = 10.63, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 155.09, ["Mega"] = 121.28, ["Mega|Ride"] = 123.22, ["Mega|Fly|Ride"] = 369.65}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 11.49, ["Fly"] = 38.73, ["Ride"] = 23.83, ["Fly|Ride"] = 68.25, ["Neon"] = 43.09, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 350.39, ["Mega|Ride"] = 273.53, ["Mega|Fly|Ride"] = 353.96}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 5.24, ["Fly"] = 55.46, ["Ride"] = 39.38, ["Fly|Ride"] = 72.19, ["Neon"] = 49.3, ["Neon|Ride"] = 141.71, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 340.91, ["Mega|Ride"] = 358.76, ["Mega|Fly|Ride"] = 370.33}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Neon"] = 3.5, ["Neon|Ride"] = 30.13, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 23.06, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 127.32}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 12.75, ["Ride"] = 24.94, ["Fly|Ride"] = 88.31, ["Neon"] = 40.06, ["Neon|Fly"] = 102.92, ["Neon|Ride"] = 64.31, ["Neon|Fly|Ride"] = 135.33, ["Mega"] = 157.5, ["Mega|Ride"] = 212.62, ["Mega|Fly|Ride"] = 298.8}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 111.99, ["Neon"] = 3.94, ["Neon|Fly"] = 96.54, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 102.3, ["Mega"] = 24.93, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 309}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 38.83, ["Ride"] = 20.55, ["Fly|Ride"] = 68.83, ["Neon"] = 6.19, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 87.32, ["Mega"] = 47.16, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 204}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 682.5, ["Ride"] = 704.82, ["Fly|Ride"] = 786.19, ["Neon"] = 4089.67, ["Neon|Ride"] = 3150, ["Neon|Fly|Ride"] = 3192.25, ["Mega|Fly|Ride"] = 12566.26}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 14.99, ["Fly|Ride"] = 34.13, ["Neon"] = 49.3, ["Neon|Fly"] = 32.88, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 46.31, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 6.18, ["Ride"] = 31.26, ["Fly|Ride"] = 162.02, ["Neon"] = 11.61, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 137.61, ["Mega"] = 59.07, ["Mega|Fly"] = 315, ["Mega|Ride"] = 121.43, ["Mega|Fly|Ride"] = 250.68}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 8.08, ["Fly"] = 31.26, ["Ride"] = 21.31, ["Fly|Ride"] = 45.2, ["Neon"] = 47.25, ["Neon|Fly"] = 123.22, ["Neon|Ride"] = 48.28, ["Neon|Fly|Ride"] = 96.54, ["Mega"] = 326.53, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 15.42, ["Fly|Ride"] = 33.6, ["Neon"] = 8.28, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 61.62, ["Mega"] = 108.8, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 254.66}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 44.62, ["Ride"] = 72.19, ["Fly|Ride"] = 205.37, ["Neon"] = 255.94, ["Neon|Ride"] = 257.44, ["Mega"] = 896.44, ["Mega|Ride"] = 1369.74}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 19.32, ["Neon"] = 7.87, ["Neon|Ride"] = 31.85, ["Neon|Fly|Ride"] = 104.52, ["Mega"] = 66.94, ["Mega|Ride"] = 113.88, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 3.84, ["Fly"] = 73.5, ["Ride"] = 22.32, ["Fly|Ride"] = 57.51, ["Neon"] = 19.69, ["Neon|Fly"] = 137.61, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 590.63, ["Mega"] = 118.13, ["Mega|Ride"] = 219.75, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.6, ["Fly"] = 26.25, ["Neon"] = 5.25, ["Neon|Fly"] = 62.51, ["Mega"] = 93.5, ["Mega|Fly"] = 410.73, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 18.38, ["Fly|Ride"] = 88.31, ["Neon"] = 5.19, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 23.46, ["Neon|Fly|Ride"] = 90.2, ["Mega"] = 52.38, ["Mega|Fly"] = 211.53, ["Mega|Ride"] = 68.09, ["Mega|Fly|Ride"] = 192.03}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 36.42, ["Fly"] = 26.25, ["Ride"] = 29.78, ["Fly|Ride"] = 38.92, ["Neon"] = 137.65, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 94.23, ["Mega"] = 821.44, ["Mega|Fly|Ride"] = 456.37}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 787.5, ["Ride"] = 836.07, ["Fly|Ride"] = 918.75, ["Neon"] = 1771.88, ["Neon|Ride"] = 1967.44, ["Neon|Fly|Ride"] = 1837.5, ["Mega"] = 7803.51, ["Mega|Ride"] = 7612.5, ["Mega|Fly|Ride"] = 7350}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 20.55, ["Ride"] = 15.6, ["Fly|Ride"] = 41.1, ["Neon"] = 3.93, ["Neon|Fly"] = 137.61, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 60.37, ["Mega"] = 55.46, ["Mega|Ride"] = 86.63, ["Mega|Fly|Ride"] = 135.19}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 4.99, ["Ride"] = 27.74, ["Fly|Ride"] = 52.5, ["Neon"] = 48.28, ["Neon|Fly"] = 137.61, ["Neon|Ride"] = 112.51, ["Neon|Fly|Ride"] = 260.81, ["Mega"] = 287.05, ["Mega|Ride"] = 351.21}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 59.56, ["Ride"] = 65.61, ["Fly|Ride"] = 104.99, ["Neon"] = 229.69, ["Neon|Ride"] = 379.65, ["Neon|Fly|Ride"] = 431.26, ["Mega"] = 3149.13, ["Mega|Fly|Ride"] = 1612.86}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 31.5, ["Fly"] = 137.61, ["Ride"] = 72.19, ["Fly|Ride"] = 102.79, ["Neon"] = 105, ["Neon|Ride"] = 192.03, ["Mega"] = 1918.04, ["Mega|Ride"] = 616.07, ["Mega|Fly|Ride"] = 729.23}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 35.44, ["Ride"] = 25.73, ["Fly|Ride"] = 123.59, ["Neon"] = 123.38, ["Neon|Ride"] = 133.63, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 354.9, ["Mega|Ride"] = 369.65, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 27.6, ["Ride"] = 92.59, ["Neon"] = 77.56, ["Neon|Ride"] = 355.28, ["Mega"] = 269.47, ["Mega|Fly"] = 502.24, ["Mega|Ride"] = 315.24, ["Mega|Fly|Ride"] = 452.82}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 16.42, ["Neon"] = 177.19, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 485.63, ["Mega"] = 525, ["Mega|Ride"] = 684.88, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 7.67}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 5.92, ["Fly"] = 24.66, ["Ride"] = 31.85, ["Fly|Ride"] = 78.75, ["Neon"] = 34.06, ["Neon|Ride"] = 39.03, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 204.75, ["Mega|Fly"] = 454.63, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.99, ["Neon"] = 14.59, ["Mega"] = 864.46}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 110.25, ["Fly"] = 410.68, ["Ride"] = 74.08, ["Fly|Ride"] = 108.8, ["Neon"] = 262.5, ["Neon|Ride"] = 137.61, ["Neon|Fly|Ride"] = 324.85, ["Mega|Ride"] = 992.92, ["Mega|Fly|Ride"] = 1300.94}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.45, ["Fly"] = 24.66, ["Ride"] = 17.41, ["Fly|Ride"] = 39.38, ["Neon"] = 22.91, ["Neon|Fly"] = 76.39, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 66.1, ["Mega"] = 208.31, ["Mega|Fly"] = 409.7, ["Mega|Ride"] = 177.91, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 5.95, ["Ride"] = 31.26, ["Fly|Ride"] = 75.99, ["Neon"] = 17.41, ["Neon|Ride"] = 46.24, ["Neon|Fly|Ride"] = 135.79, ["Mega"] = 127.34, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 309}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 4.66, ["Neon|Ride"] = 45.94, ["Mega"] = 47.52, ["Mega|Ride"] = 96.6, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 43.32, ["Fly"] = 65.63, ["Ride"] = 64.32, ["Fly|Ride"] = 120.74, ["Neon"] = 137.61, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 274.16, ["Mega"] = 1095.59, ["Mega|Ride"] = 821.44, ["Mega|Fly|Ride"] = 816.66}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 26.35, ["Neon"] = 5.25, ["Neon|Ride"] = 66, ["Mega"] = 95.82, ["Mega|Ride"] = 92.01, ["Mega|Fly|Ride"] = 309.68}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 10.4, ["Ride"] = 73.5, ["Fly|Ride"] = 271.08, ["Neon"] = 96.54, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 382.05, ["Mega"] = 410.73, ["Mega|Fly|Ride"] = 684.88}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 23.62, ["Ride"] = 15.64, ["Fly|Ride"] = 59.47, ["Neon"] = 17.37, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 85.23, ["Mega"] = 157.5, ["Mega|Ride"] = 261.85, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 3.52, ["Fly"] = 52.49, ["Ride"] = 20.68, ["Fly|Ride"] = 56.06, ["Neon"] = 157.5, ["Neon|Ride"] = 410.73, ["Mega"] = 155.09, ["Mega|Ride"] = 381.97, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.57, ["Ride"] = 62.51, ["Fly|Ride"] = 131.25, ["Neon"] = 42.56, ["Neon|Ride"] = 153.25, ["Mega"] = 364.58, ["Mega|Ride"] = 275.63}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 32.82, ["Ride"] = 136.5, ["Fly|Ride"] = 178.67, ["Neon"] = 205.37, ["Neon|Ride"] = 262.7, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 1025.77, ["Mega|Ride"] = 1629.51, ["Mega|Fly|Ride"] = 1232.14}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 16.56, ["Ride"] = 85.71, ["Neon"] = 131.25, ["Neon|Ride"] = 178.67, ["Neon|Fly|Ride"] = 143.76, ["Mega"] = 411.7, ["Mega|Ride"] = 328.58, ["Mega|Fly|Ride"] = 498.1}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 7.24, ["Fly"] = 65.63, ["Ride"] = 34.93, ["Fly|Ride"] = 274.16, ["Neon"] = 48.45, ["Neon|Ride"] = 105, ["Mega"] = 410.73, ["Mega|Ride"] = 410.73, ["Mega|Fly|Ride"] = 1642.87}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 13.13, ["Ride"] = 45.94, ["Fly|Ride"] = 519.6, ["Neon"] = 103.9, ["Neon|Ride"] = 273.13, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 718.76, ["Mega|Fly|Ride"] = 1080.85}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.94, ["Neon"] = 105, ["Neon|Ride"] = 274.16, ["Mega"] = 155.09, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 309}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 17.62, ["Fly|Ride"] = 32.82, ["Neon"] = 6.55, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 34.04, ["Neon|Fly|Ride"] = 76.13, ["Mega"] = 49.29, ["Mega|Ride"] = 85.23, ["Mega|Fly|Ride"] = 159.72}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 3.83, ["Ride"] = 55.46, ["Fly|Ride"] = 72.19, ["Neon"] = 27.03, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 109.94, ["Mega"] = 191.63, ["Mega|Ride"] = 302.91, ["Mega|Fly|Ride"] = 340.91}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 29.71, ["Ride"] = 18.37, ["Fly|Ride"] = 55.95, ["Neon"] = 6.57, ["Neon|Fly"] = 31.26, ["Neon|Ride"] = 25.99, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 46.7, ["Mega|Ride"] = 73.57, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.48, ["Ride"] = 27.74, ["Fly|Ride"] = 118.13, ["Neon"] = 18.38, ["Neon|Ride"] = 96.54, ["Neon|Fly|Ride"] = 254.66, ["Mega"] = 249.38, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 462.91}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.51, ["Ride"] = 32.96, ["Fly|Ride"] = 101.07, ["Neon"] = 29.29, ["Neon|Fly"] = 315, ["Neon|Ride"] = 69.61, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 302.45, ["Mega|Ride"] = 410.73, ["Mega|Fly|Ride"] = 1026.8}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 5.14, ["Fly"] = 131.25, ["Ride"] = 25.98, ["Fly|Ride"] = 60.59, ["Neon"] = 26.25, ["Neon|Fly"] = 111.53, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 262.7, ["Mega|Ride"] = 257.24, ["Mega|Fly|Ride"] = 227.22}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 34.77, ["Ride"] = 22, ["Fly|Ride"] = 51.68, ["Neon"] = 17.07, ["Neon|Fly"] = 82.16, ["Neon|Ride"] = 41.09, ["Neon|Fly|Ride"] = 100.69, ["Mega"] = 168, ["Mega|Ride"] = 226.93}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 4.68, ["Fly"] = 57.75, ["Ride"] = 43.32, ["Fly|Ride"] = 179.82, ["Neon"] = 19.08, ["Neon|Fly"] = 78.66, ["Neon|Ride"] = 44.52, ["Neon|Fly|Ride"] = 185.17, ["Mega"] = 110.25, ["Mega|Fly"] = 103.69, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 410.73}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 23.63, ["Fly"] = 137.61, ["Ride"] = 104.99, ["Fly|Ride"] = 192.03, ["Neon"] = 91.88, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 463.32, ["Mega"] = 410.63, ["Mega|Fly"] = 667.42, ["Mega|Ride"] = 485.37, ["Mega|Fly|Ride"] = 623.44}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 59.06, ["Ride"] = 97.13, ["Fly|Ride"] = 191, ["Neon"] = 246.88, ["Neon|Ride"] = 263.82, ["Neon|Fly|Ride"] = 386.53, ["Mega"] = 1050, ["Mega|Ride"] = 1063.13, ["Mega|Fly|Ride"] = 1254.38}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 19.56, ["Fly|Ride"] = 39.03, ["Neon"] = 2.62, ["Neon|Ride"] = 41.09, ["Neon|Fly|Ride"] = 104.16, ["Mega"] = 27.57, ["Mega|Ride"] = 68.81, ["Mega|Fly|Ride"] = 130.99}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 33.07, ["Neon|Ride"] = 192.03, ["Mega"] = 908.92, ["Mega|Fly|Ride"] = 1232.14}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 51.06, ["Fly"] = 105, ["Ride"] = 111.12, ["Neon"] = 303.98, ["Neon|Ride"] = 246.44, ["Mega"] = 1673.66, ["Mega|Ride"] = 1209.56, ["Mega|Fly|Ride"] = 997.5}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 8.22, ["Fly"] = 190.32, ["Ride"] = 31.5, ["Fly|Ride"] = 91.88, ["Neon"] = 32.82, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 236.25, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 326.82}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 3.73, ["Ride"] = 109.88, ["Fly|Ride"] = 137.45, ["Neon"] = 6.07, ["Neon|Ride"] = 31.85, ["Mega"] = 54.46, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 76.97, ["Mega|Fly|Ride"] = 124.59}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.49, ["Fly"] = 39.03, ["Ride"] = 19.69, ["Fly|Ride"] = 46.4, ["Neon"] = 14.73, ["Neon|Ride"] = 34.05, ["Neon|Fly|Ride"] = 92.59, ["Mega"] = 192.03, ["Mega|Fly"] = 342.97, ["Mega|Ride"] = 309, ["Mega|Fly|Ride"] = 231.96}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.75, ["Ride"] = 15.75, ["Fly|Ride"] = 43.14, ["Neon"] = 2.63, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 24.94, ["Mega|Ride"] = 69.56}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 74.26, ["Neon"] = 6.57, ["Neon|Ride"] = 24.91, ["Neon|Fly|Ride"] = 105.77, ["Mega"] = 53.25, ["Mega|Fly"] = 168, ["Mega|Ride"] = 76.71, ["Mega|Fly|Ride"] = 154.88}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.49, ["Fly|Ride"] = 155.08, ["Neon"] = 2.1, ["Neon|Ride"] = 47.24, ["Mega"] = 20.55, ["Mega|Fly|Ride"] = 273.13}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 5.24, ["Ride"] = 44.17, ["Neon"] = 36.99, ["Neon|Ride"] = 46.31, ["Neon|Fly|Ride"] = 616.07, ["Mega"] = 137.61, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 245.24}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 6.18, ["Ride"] = 31.85, ["Fly|Ride"] = 189.96, ["Neon"] = 61.62, ["Neon|Ride"] = 92.42, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 410.73, ["Mega|Ride"] = 304.5, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 5.25, ["Fly"] = 24.76, ["Ride"] = 19.68, ["Fly|Ride"] = 59.56, ["Neon"] = 46.31, ["Neon|Fly"] = 65.54, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 99.56, ["Mega|Ride"] = 342.57, ["Mega|Fly|Ride"] = 360.39}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 66.93, ["Ride"] = 103.69, ["Fly|Ride"] = 262.5, ["Neon"] = 219.75, ["Neon|Ride"] = 597.19, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 15.65, ["Fly"] = 71.73, ["Ride"] = 32.82, ["Fly|Ride"] = 123.22, ["Neon"] = 131.25, ["Neon|Fly|Ride"] = 630, ["Mega"] = 617.97, ["Mega|Ride"] = 827.54, ["Mega|Fly|Ride"] = 820.98}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 19.52, ["Ride"] = 16.27, ["Fly|Ride"] = 41.09, ["Neon"] = 3.82, ["Neon|Fly"] = 41.09, ["Neon|Ride"] = 20.55, ["Neon|Fly|Ride"] = 51.18, ["Mega"] = 39.03, ["Mega|Ride"] = 48.57, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 35.96, ["Ride"] = 14.82, ["Fly|Ride"] = 31.49, ["Neon"] = 5.09, ["Neon|Fly"] = 26.24, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 46.13, ["Mega"] = 44.62, ["Mega|Fly"] = 82.16, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 107.96}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 446.24, ["Ride"] = 464.63, ["Fly|Ride"] = 492.76, ["Neon|Fly|Ride"] = 1521.19}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 15.75, ["Ride"] = 68.81, ["Neon"] = 129.94, ["Neon|Ride"] = 109.87, ["Mega"] = 643.13, ["Mega|Fly|Ride"] = 1232.14}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 18.5, ["Ride"] = 15.42, ["Fly|Ride"] = 31.85, ["Neon"] = 8.24, ["Neon|Fly"] = 68.81, ["Neon|Ride"] = 20.55, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 46.31, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 102.38}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 77.02, ["Fly|Ride"] = 341.25, ["Neon"] = 236.24, ["Neon|Ride"] = 294.7, ["Neon|Fly|Ride"] = 537.02, ["Mega"] = 737.62, ["Mega|Ride"] = 682.5, ["Mega|Fly|Ride"] = 934.5}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 3.56, ["Fly"] = 18.54, ["Ride"] = 19.35, ["Fly|Ride"] = 41.11, ["Neon"] = 13.13, ["Neon|Fly"] = 41.48, ["Neon|Ride"] = 31.26, ["Neon|Fly|Ride"] = 62.33, ["Mega"] = 83.91, ["Mega|Fly"] = 137.61, ["Mega|Ride"] = 115.29, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 68.81, ["Ride"] = 34.12, ["Fly|Ride"] = 1312.5, ["Neon"] = 3.67, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 27.75, ["Neon|Fly|Ride"] = 94.48, ["Mega"] = 16.57, ["Mega|Fly"] = 260.81, ["Mega|Ride"] = 65.23, ["Mega|Fly|Ride"] = 208.68}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 39.25, ["Fly"] = 186.89, ["Ride"] = 55.47, ["Fly|Ride"] = 124.69, ["Neon"] = 178.67, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 721.88, ["Mega|Ride"] = 630, ["Mega|Fly|Ride"] = 774.38}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 19.68, ["Fly|Ride"] = 52.5, ["Neon"] = 5.25, ["Neon|Ride"] = 26.24, ["Mega"] = 40.59, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 43.73, ["Ride"] = 55.46, ["Fly|Ride"] = 131.25, ["Neon"] = 341.43, ["Neon|Ride"] = 298.8, ["Neon|Fly|Ride"] = 358.32, ["Mega"] = 1622.32, ["Mega|Ride"] = 1640.81, ["Mega|Fly|Ride"] = 1147.96}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 2.88, ["Ride"] = 53.01, ["Fly|Ride"] = 156.09, ["Neon"] = 21.26, ["Neon|Ride"] = 274.16, ["Mega"] = 144.38, ["Mega|Ride"] = 205.37, ["Mega|Fly|Ride"] = 462.91}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 3.82, ["Fly"] = 68.81, ["Ride"] = 19.69, ["Fly|Ride"] = 65.73, ["Neon"] = 10.28, ["Neon|Fly"] = 77.02, ["Neon|Ride"] = 51.35, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 106.8, ["Mega|Ride"] = 137.61, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 34.1, ["Ride"] = 77.55, ["Fly|Ride"] = 393.74, ["Neon"] = 175.93, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2051.52, ["Mega|Ride"] = 2598.75, ["Mega|Fly|Ride"] = 1086.35}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.63, ["Fly"] = 210.35, ["Ride"] = 33.57, ["Fly|Ride"] = 59.07, ["Neon"] = 6.57, ["Neon|Ride"] = 34.94, ["Neon|Fly|Ride"] = 168, ["Mega"] = 44.63, ["Mega|Fly"] = 242.19, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 154.88}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 32.88, ["Ride"] = 19.69, ["Fly|Ride"] = 102.88, ["Neon"] = 9.18, ["Neon|Fly"] = 41.09, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 123.84, ["Mega|Fly|Ride"] = 205.78}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 8.93, ["Fly"] = 45.2, ["Ride"] = 30.81, ["Fly|Ride"] = 81.13, ["Neon"] = 69.21, ["Neon|Ride"] = 137.61, ["Neon|Fly|Ride"] = 137.61, ["Mega"] = 430.5, ["Mega|Ride"] = 410.73, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 65.63, ["Ride"] = 100.69, ["Neon"] = 105, ["Neon|Fly|Ride"] = 959.03, ["Mega|Ride"] = 1848.2, ["Mega|Fly|Ride"] = 712.61}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 26.69, ["Fly"] = 51.18, ["Ride"] = 19.69, ["Fly|Ride"] = 73.95, ["Neon"] = 72.19, ["Neon|Ride"] = 110.25, ["Neon|Fly|Ride"] = 155.09, ["Mega"] = 537.12, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 423.55}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 52.5, ["Fly"] = 289.31, ["Ride"] = 131.25, ["Fly|Ride"] = 305.52, ["Neon"] = 299.24, ["Neon|Ride"] = 283.5, ["Neon|Fly|Ride"] = 393.74, ["Mega|Ride"] = 1300.94, ["Mega|Fly|Ride"] = 1388.68}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 5.2, ["Ride"] = 39.38, ["Neon"] = 31.5, ["Neon|Ride"] = 77.56, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 201.41, ["Mega|Ride"] = 313.62, ["Mega|Fly|Ride"] = 334.74}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 6.57, ["Ride"] = 26.46, ["Fly|Ride"] = 78.74, ["Neon"] = 21, ["Neon|Ride"] = 77.02, ["Mega"] = 154.11, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 309}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 17.37, ["Fly"] = 52.49, ["Ride"] = 46.31, ["Fly|Ride"] = 92.59, ["Neon"] = 91.88, ["Neon|Ride"] = 164.3, ["Mega"] = 430.5, ["Mega|Ride"] = 639.19, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 14.51, ["Fly|Ride"] = 31.85, ["Neon"] = 2.57, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 51.35, ["Mega"] = 15.08, ["Mega|Fly"] = 77.56, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 93.16}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 76.65, ["Fly"] = 164.07, ["Ride"] = 131.25, ["Neon"] = 205.73, ["Neon|Fly"] = 2327.72, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1388.68, ["Mega|Ride"] = 1367.68, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 18.64, ["Fly|Ride"] = 106.8, ["Neon"] = 3.94, ["Neon|Ride"] = 41.09, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 26.17, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 306.66}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 27.74, ["Ride"] = 15.75, ["Fly|Ride"] = 43.31, ["Neon"] = 11.81, ["Neon|Fly"] = 137.61, ["Neon|Ride"] = 31.85, ["Neon|Fly|Ride"] = 82.16, ["Mega"] = 315, ["Mega|Ride"] = 202.71, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 75.93, ["Ride"] = 155.08, ["Fly|Ride"] = 260.81, ["Neon"] = 374.07, ["Neon|Ride"] = 381.75, ["Neon|Fly|Ride"] = 616.07, ["Mega"] = 1178.63, ["Mega|Ride"] = 1270.64, ["Mega|Fly|Ride"] = 1194.38}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.63, ["Ride"] = 22.6, ["Neon"] = 7.6, ["Neon|Ride"] = 65.63, ["Mega"] = 73.5, ["Mega|Fly"] = 134.25, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 232.97}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 4.97}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 36.75, ["Fly|Ride"] = 291.62, ["Neon"] = 6.57, ["Neon|Ride"] = 55.46, ["Neon|Fly|Ride"] = 137.61, ["Mega"] = 45.2, ["Mega|Fly"] = 115.74, ["Mega|Ride"] = 123.22, ["Mega|Fly|Ride"] = 222}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 119.61, ["Ride"] = 192.03, ["Fly|Ride"] = 274.16, ["Neon"] = 538.13, ["Neon|Ride"] = 679.3, ["Neon|Fly|Ride"] = 735, ["Mega"] = 3549.2, ["Mega|Ride"] = 2191.16, ["Mega|Fly|Ride"] = 2293.83}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.91, ["Ride"] = 36.82, ["Neon"] = 68.8, ["Neon|Ride"] = 55.46, ["Neon|Fly|Ride"] = 193.06, ["Mega"] = 173.25, ["Mega|Ride"] = 202.85, ["Mega|Fly|Ride"] = 393.74}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.63, ["Fly"] = 26.25, ["Ride"] = 27.74, ["Neon"] = 3.89, ["Neon|Ride"] = 20.55, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 27.75, ["Mega|Ride"] = 99.65, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 6.04, ["Ride"] = 26.71, ["Neon"] = 51.19, ["Neon|Ride"] = 109.88, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 548.65, ["Mega|Fly|Ride"] = 274.16}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 12.34, ["Fly"] = 72.92, ["Ride"] = 26.7, ["Fly|Ride"] = 54.32, ["Neon"] = 77.04, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 137.61, ["Mega"] = 397.38, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 410.73}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 34.13, ["Ride"] = 52.38, ["Neon"] = 142.67, ["Neon|Fly"] = 231.47, ["Neon|Ride"] = 182.44, ["Neon|Fly|Ride"] = 617.97, ["Mega"] = 656.25, ["Mega|Ride"] = 872.57, ["Mega|Fly|Ride"] = 739.48}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 130.79, ["Fly"] = 247.57, ["Ride"] = 170.62, ["Fly|Ride"] = 213.94, ["Neon"] = 671.27, ["Neon|Fly"] = 753.67, ["Neon|Ride"] = 498.74, ["Neon|Fly|Ride"] = 640.4, ["Mega|Fly|Ride"] = 2198.44}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 28.88, ["Fly"] = 34.12, ["Ride"] = 34.46, ["Fly|Ride"] = 65.51, ["Neon"] = 476.84, ["Neon|Fly"] = 137.63, ["Neon|Ride"] = 126.46, ["Neon|Fly|Ride"] = 200.54, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 6.23, ["Fly"] = 131.23, ["Ride"] = 30.81, ["Fly|Ride"] = 90.37, ["Neon"] = 16.55, ["Neon|Fly"] = 69.02, ["Neon|Ride"] = 86.81, ["Neon|Fly|Ride"] = 117.07, ["Mega"] = 99.75, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 5.1, ["Fly"] = 131.25, ["Ride"] = 137.61, ["Neon"] = 85.32, ["Mega"] = 380.63, ["Mega|Ride"] = 479.52}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 39.38, ["Ride"] = 88.35, ["Fly|Ride"] = 129.4, ["Neon"] = 220.48, ["Neon|Ride"] = 245.44, ["Neon|Fly|Ride"] = 209.9, ["Mega"] = 1077.39, ["Mega|Ride"] = 1023.75, ["Mega|Fly|Ride"] = 1081.9}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 16.89, ["Ride"] = 85.23, ["Neon"] = 155.1, ["Neon|Ride"] = 155.09, ["Neon|Fly|Ride"] = 302.91, ["Mega"] = 660.19, ["Mega|Ride"] = 616.07, ["Mega|Fly|Ride"] = 684.88}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 262.5, ["Ride"] = 405.6, ["Neon"] = 1458.26, ["Neon|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 4517.84}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 34.12, ["Ride"] = 61.62, ["Fly|Ride"] = 77.55, ["Neon|Ride"] = 293.95, ["Neon|Fly|Ride"] = 315, ["Mega"] = 1034.25, ["Mega|Ride"] = 900.46, ["Mega|Fly|Ride"] = 1217.9}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.42, ["Fly|Ride"] = 78.74, ["Neon"] = 2.36, ["Neon|Ride"] = 15.42, ["Neon|Fly|Ride"] = 64.26, ["Mega"] = 19.83, ["Mega|Fly"] = 102.69, ["Mega|Ride"] = 40.14, ["Mega|Fly|Ride"] = 109.5}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 6.54, ["Neon"] = 15.42, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 257.74, ["Mega"] = 196.88, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 405.6}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 2.62, ["Ride"] = 41.09, ["Fly|Ride"] = 144.16, ["Neon"] = 11.59, ["Neon|Fly"] = 87.94, ["Neon|Ride"] = 137.61, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 112.14, ["Mega|Fly"] = 533.94, ["Mega|Ride"] = 188.95, ["Mega|Fly|Ride"] = 274.16}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 334.69, ["Fly"] = 617.96, ["Ride"] = 413.43, ["Fly|Ride"] = 564.38, ["Neon"] = 1387.72, ["Neon|Ride"] = 1675.72, ["Neon|Fly|Ride"] = 1371.57, ["Mega|Ride"] = 6027.18, ["Mega|Fly|Ride"] = 5033.44}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.63, ["Fly"] = 54.74, ["Ride"] = 15.75, ["Fly|Ride"] = 48.29, ["Neon"] = 24.94, ["Neon|Ride"] = 32.88, ["Neon|Fly|Ride"] = 80.1, ["Mega"] = 131.25, ["Mega|Ride"] = 274.17, ["Mega|Fly|Ride"] = 568.85}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 5.07, ["Fly"] = 22.31, ["Ride"] = 18.38, ["Fly|Ride"] = 39.38, ["Neon"] = 28.07, ["Neon|Fly"] = 156.45, ["Neon|Fly|Ride"] = 139.13, ["Mega|Ride"] = 684.88, ["Mega|Fly|Ride"] = 286.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.88, ["Ride"] = 27.55, ["Fly|Ride"] = 82.16, ["Neon"] = 12.75, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 47.24, ["Neon|Fly|Ride"] = 129.4, ["Mega"] = 137.61, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 233.09}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 55.46, ["Fly"] = 137.61, ["Ride"] = 52.5, ["Fly|Ride"] = 62.34, ["Neon"] = 139.12, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 862.32, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 31.43, ["Ride"] = 40.68, ["Fly|Ride"] = 69.84, ["Neon"] = 15.42, ["Neon|Ride"] = 114.19, ["Mega"] = 158.86, ["Mega|Ride"] = 410.73, ["Mega|Fly|Ride"] = 755.35}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 6.4, ["Fly"] = 787.5, ["Ride"] = 31.85, ["Fly|Ride"] = 85.31, ["Neon"] = 123.38, ["Neon|Ride"] = 155.09, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.17, ["Fly|Ride"] = 41.18, ["Neon"] = 3.19, ["Neon|Ride"] = 28.75, ["Mega"] = 39.38, ["Mega|Ride"] = 129.29, ["Mega|Fly|Ride"] = 291.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 13.13, ["Ride"] = 134.52, ["Neon"] = 82.16, ["Neon|Ride"] = 204.35, ["Mega"] = 155.93, ["Mega|Ride"] = 287.52}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 10.5, ["Ride"] = 78.07, ["Neon"] = 104.9, ["Neon|Ride"] = 96.54, ["Neon|Fly|Ride"] = 410.73, ["Mega"] = 328.58, ["Mega|Ride"] = 341.39, ["Mega|Fly|Ride"] = 492.86}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 17.4, ["Fly"] = 616.07, ["Ride"] = 31.75, ["Fly|Ride"] = 59.41, ["Neon"] = 45.93, ["Neon|Fly"] = 115.74, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 577.06, ["Mega|Ride"] = 411.89, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 230.82, ["Fly"] = 369.65, ["Ride"] = 254.47, ["Fly|Ride"] = 367.5, ["Neon"] = 1388.82, ["Neon|Ride"] = 925.32, ["Neon|Fly|Ride"] = 957.04, ["Mega|Fly|Ride"] = 4641}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.6, ["Fly|Ride"] = 56.79, ["Neon"] = 9.56, ["Neon|Fly"] = 77.56, ["Neon|Ride"] = 33.57, ["Neon|Fly|Ride"] = 145.04, ["Mega"] = 219.75, ["Mega|Ride"] = 155.09, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.41, ["Ride"] = 45.94, ["Fly|Ride"] = 110.34, ["Neon"] = 35.44, ["Neon|Ride"] = 35.96, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 282.92, ["Mega|Ride"] = 271.87, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 46.16, ["Ride"] = 104.16, ["Neon"] = 112.88, ["Neon|Ride"] = 184.83, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 371.55, ["Mega|Ride"] = 363.57, ["Mega|Fly|Ride"] = 684.88}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 133.87, ["Fly"] = 393.75, ["Ride"] = 164.39, ["Fly|Ride"] = 293.95, ["Neon"] = 584.07, ["Neon|Ride"] = 616.07, ["Neon|Fly|Ride"] = 773.66, ["Mega"] = 2314.45, ["Mega|Ride"] = 1794.19, ["Mega|Fly|Ride"] = 2235.19}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 35.44, ["Fly"] = 109.88, ["Ride"] = 73.67, ["Fly|Ride"] = 106.8, ["Neon"] = 83.16, ["Neon|Ride"] = 136.57, ["Neon|Fly|Ride"] = 245.41, ["Mega"] = 308.04, ["Mega|Ride"] = 328.58, ["Mega|Fly|Ride"] = 452.82}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Ride"] = 14.97, ["Fly|Ride"] = 58.47, ["Neon"] = 5.25, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 50.93, ["Mega|Ride"] = 193.27, ["Mega|Fly|Ride"] = 192.94}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 16.23, ["Ride"] = 48.57, ["Neon"] = 32.82, ["Neon|Ride"] = 101.07, ["Mega"] = 210, ["Mega|Ride"] = 442.97}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 59.07, ["Fly"] = 190.32, ["Ride"] = 115.5, ["Fly|Ride"] = 216.57, ["Neon"] = 124.69, ["Neon|Ride"] = 237.2, ["Neon|Fly|Ride"] = 303.09, ["Mega"] = 450.21, ["Mega|Ride"] = 446.24, ["Mega|Fly|Ride"] = 544.69}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 3.15, ["Fly|Ride"] = 55.46, ["Neon"] = 9.28, ["Neon|Ride"] = 204.35, ["Neon|Fly|Ride"] = 105, ["Mega"] = 63, ["Mega|Ride"] = 129.4, ["Mega|Fly|Ride"] = 143.07}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 18.5, ["Ride"] = 361.44, ["Neon"] = 118.13, ["Neon|Ride"] = 617.97, ["Mega"] = 328.13, ["Mega|Fly|Ride"] = 753.67}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 944.98, ["Fly"] = 1212.77, ["Ride"] = 1001.32, ["Fly|Ride"] = 1097.2, ["Neon|Ride"] = 3491.04, ["Neon|Fly|Ride"] = 2743.12, ["Mega|Fly|Ride"] = 12732.03}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 37.11, ["Fly"] = 115.74, ["Ride"] = 108.86, ["Fly|Ride"] = 187.69, ["Neon"] = 158.15, ["Neon|Fly"] = 892.5, ["Neon|Ride"] = 567, ["Neon|Fly|Ride"] = 309, ["Mega"] = 959.03, ["Mega|Ride"] = 546.26, ["Mega|Fly|Ride"] = 701.97}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 4.65, ["Fly"] = 49.25, ["Ride"] = 22.97, ["Fly|Ride"] = 80.89, ["Neon"] = 17.07, ["Neon|Ride"] = 38.85, ["Neon|Fly|Ride"] = 137.61, ["Mega"] = 89.25, ["Mega|Ride"] = 86.26, ["Mega|Fly|Ride"] = 219.89}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 26.7, ["Ride"] = 131.22, ["Fly|Ride"] = 137.61, ["Neon"] = 108.81, ["Neon|Fly|Ride"] = 137.61, ["Mega|Ride"] = 288.74, ["Mega|Fly|Ride"] = 479.52}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Fly|Ride"] = 52.5, ["Neon"] = 2.61, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 16.59, ["Mega|Fly"] = 123.22, ["Mega|Ride"] = 45.85, ["Mega|Fly|Ride"] = 127.58}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 68.25, ["Fly"] = 65.63, ["Ride"] = 118.09, ["Fly|Ride"] = 255.93, ["Neon"] = 259.88, ["Neon|Fly"] = 347.22, ["Neon|Ride"] = 341.61, ["Neon|Fly|Ride"] = 511.5, ["Mega"] = 1369.74, ["Mega|Ride"] = 1106.32, ["Mega|Fly|Ride"] = 1102.5}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 5.25, ["Fly"] = 174.57, ["Ride"] = 26.25, ["Fly|Ride"] = 68.81, ["Neon"] = 45.94, ["Neon|Ride"] = 78.75, ["Mega"] = 308.04, ["Mega|Ride"] = 367.6, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.57, ["Ride"] = 20.55, ["Neon"] = 11.31, ["Neon|Ride"] = 55.49, ["Mega"] = 97.13, ["Mega|Ride"] = 157.49, ["Mega|Fly|Ride"] = 356.31}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 32.81, ["Fly"] = 72.92, ["Ride"] = 100.69, ["Fly|Ride"] = 196.75, ["Neon"] = 105, ["Neon|Fly"] = 274.16, ["Neon|Ride"] = 155.09, ["Neon|Fly|Ride"] = 330.64, ["Mega"] = 495.3, ["Mega|Ride"] = 617.97, ["Mega|Fly|Ride"] = 679.3}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 53.81, ["Ride"] = 89.25, ["Fly|Ride"] = 190.32, ["Neon"] = 525, ["Neon|Ride"] = 143.76, ["Mega"] = 427.23, ["Mega|Ride"] = 504.14, ["Mega|Fly|Ride"] = 821.44}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 59.06, ["Ride"] = 78.75, ["Neon"] = 309.02, ["Neon|Ride"] = 551.25, ["Neon|Fly|Ride"] = 431.26, ["Mega"] = 1492.95, ["Mega|Ride"] = 1642.87, ["Mega|Fly|Ride"] = 1579.03}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 6.44, ["Neon"] = 20.78, ["Neon|Ride"] = 84.2, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 108.94, ["Mega|Ride"] = 241.5, ["Mega|Fly|Ride"] = 266.57}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 9.19, ["Ride"] = 19.68, ["Fly|Ride"] = 78.74, ["Neon"] = 61.62, ["Neon|Ride"] = 91.44, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 399, ["Mega|Ride"] = 375.82, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 124.69, ["Ride"] = 137.65, ["Fly|Ride"] = 303.94, ["Neon"] = 507.94, ["Neon|Ride"] = 572.25, ["Neon|Fly|Ride"] = 509.4, ["Mega"] = 3139.89, ["Mega|Ride"] = 2333.63, ["Mega|Fly|Ride"] = 1889.99}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 21.84, ["Ride"] = 18.27, ["Fly|Ride"] = 105000, ["Neon"] = 11.24, ["Neon|Fly"] = 64.31, ["Neon|Ride"] = 31.26, ["Neon|Fly|Ride"] = 78.73, ["Mega"] = 124.59, ["Mega|Ride"] = 162.16, ["Mega|Fly|Ride"] = 192.22}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 6.57, ["Fly"] = 37.05, ["Ride"] = 31.99, ["Fly|Ride"] = 78.75, ["Neon"] = 41.09, ["Neon|Fly"] = 309, ["Neon|Ride"] = 55.69, ["Neon|Fly|Ride"] = 175.6, ["Mega"] = 342.97, ["Mega|Ride"] = 315.24, ["Mega|Fly|Ride"] = 326.55}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Ride"] = 14.44, ["Fly|Ride"] = 40.85, ["Neon"] = 2.6, ["Neon|Fly"] = 24.9, ["Neon|Ride"] = 15.42, ["Neon|Fly|Ride"] = 41.09, ["Mega"] = 14.54, ["Mega|Ride"] = 27.57, ["Mega|Fly|Ride"] = 119.12}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 53.41, ["Neon"] = 3.93, ["Neon|Ride"] = 39.03, ["Mega"] = 23.2, ["Mega|Fly"] = 118.12, ["Mega|Ride"] = 51.98, ["Mega|Fly|Ride"] = 158.15}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.62, ["Fly"] = 128.77, ["Ride"] = 19.69, ["Fly|Ride"] = 45.94, ["Neon"] = 41.09, ["Neon|Ride"] = 58.42, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 98.44, ["Mega|Fly|Ride"] = 232.98}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 59.06, ["Ride"] = 196.88, ["Neon"] = 326.82, ["Neon|Ride"] = 410.73, ["Neon|Fly|Ride"] = 630, ["Mega"] = 414.21, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 665.37}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.63, ["Fly"] = 19.69, ["Ride"] = 16.2, ["Fly|Ride"] = 45.2, ["Neon"] = 14.44, ["Neon|Fly"] = 31.26, ["Neon|Ride"] = 30.81, ["Neon|Fly|Ride"] = 69.04, ["Mega"] = 114.19, ["Mega|Fly"] = 170.6, ["Mega|Ride"] = 155.09, ["Mega|Fly|Ride"] = 170.39}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 3.69, ["Fly"] = 32.45, ["Ride"] = 23.63, ["Fly|Ride"] = 66.9, ["Neon"] = 19.48, ["Neon|Fly"] = 60.58, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 169.31, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 165.64, ["Mega|Fly|Ride"] = 215.24}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 3.15, ["Fly"] = 19.69, ["Ride"] = 17.37, ["Fly|Ride"] = 39.38, ["Neon"] = 9.07, ["Neon|Fly"] = 98.43, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 40.6, ["Mega|Fly"] = 97.13, ["Mega|Ride"] = 118.12, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 11.02, ["Fly"] = 169.32, ["Ride"] = 45.93, ["Fly|Ride"] = 52.5, ["Neon"] = 51.35, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 164.3, ["Mega"] = 220.23, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 260.81, ["Mega|Fly|Ride"] = 630.46}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 5.25, ["Fly"] = 170.46, ["Ride"] = 68.81, ["Fly|Ride"] = 220.34, ["Neon"] = 91.68, ["Neon|Ride"] = 252.03, ["Neon|Fly|Ride"] = 342.97, ["Mega"] = 386.53, ["Mega|Fly|Ride"] = 684.88}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.8, ["Fly"] = 123.25, ["Ride"] = 18, ["Fly|Ride"] = 63.66, ["Neon"] = 27.57, ["Neon|Fly"] = 196.66, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 105, ["Mega"] = 309, ["Mega|Ride"] = 219.75, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.62, ["Fly"] = 20.9, ["Ride"] = 16.44, ["Fly|Ride"] = 27.76, ["Neon"] = 10.39, ["Neon|Fly"] = 67.64, ["Neon|Ride"] = 27.74, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 78.75, ["Mega|Ride"] = 89.34, ["Mega|Fly|Ride"] = 203.41}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 189, ["Fly"] = 393.75, ["Ride"] = 288.75, ["Fly|Ride"] = 196.87, ["Neon"] = 944.65, ["Neon|Ride"] = 1232.14, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 2618.44}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 5.92, ["Ride"] = 61.76, ["Neon"] = 42.94, ["Mega"] = 118.13, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.82, ["Fly"] = 26.25, ["Ride"] = 20.68, ["Fly|Ride"] = 75.99, ["Neon"] = 22.32, ["Neon|Fly"] = 205.37, ["Neon|Ride"] = 82.16, ["Neon|Fly|Ride"] = 201.79, ["Mega"] = 197.51, ["Mega|Ride"] = 273.13, ["Mega|Fly|Ride"] = 221.82}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 18.57, ["Ride"] = 24.66, ["Neon"] = 52.5, ["Neon|Ride"] = 213.44, ["Neon|Fly|Ride"] = 616.07, ["Mega"] = 461.77, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 547.98}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 16.06, ["Ride"] = 14.44, ["Fly|Ride"] = 30.81, ["Neon"] = 2.37, ["Neon|Fly"] = 20.55, ["Neon|Ride"] = 15.42, ["Neon|Fly|Ride"] = 42.37, ["Mega"] = 17.64, ["Mega|Fly"] = 162.75, ["Mega|Ride"] = 24.66, ["Mega|Fly|Ride"] = 95.82}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.18, ["Fly"] = 41.09, ["Ride"] = 15.75, ["Fly|Ride"] = 58.97, ["Neon"] = 8.86, ["Neon|Ride"] = 27.75, ["Neon|Fly|Ride"] = 94.7, ["Mega"] = 103.81, ["Mega|Ride"] = 123.69, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.63, ["Ride"] = 55.46, ["Fly|Ride"] = 97.56, ["Neon"] = 26.25, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 59.05, ["Mega|Ride"] = 205.37, ["Mega|Fly|Ride"] = 308.95}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 74.82, ["Fly"] = 105, ["Ride"] = 105, ["Fly|Ride"] = 155.08, ["Neon"] = 510.4, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 545.23, ["Mega"] = 2053.57, ["Mega|Ride"] = 3424.31, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.84, ["Fly"] = 85.32, ["Ride"] = 32.87, ["Fly|Ride"] = 65.62, ["Neon"] = 21.86, ["Neon|Ride"] = 54.41, ["Neon|Fly|Ride"] = 109.88, ["Mega"] = 211.54, ["Mega|Ride"] = 320.37, ["Mega|Fly|Ride"] = 410.73}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 30.81, ["Ride"] = 46.44, ["Fly|Ride"] = 118.13, ["Neon"] = 8.12, ["Neon|Ride"] = 177.06, ["Neon|Fly|Ride"] = 519.53, ["Mega"] = 41.09, ["Mega|Fly"] = 313.69, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 45.94, ["Fly"] = 210, ["Ride"] = 89.25, ["Fly|Ride"] = 205.37, ["Neon"] = 118.13, ["Neon|Ride"] = 170.62, ["Neon|Fly|Ride"] = 293.95, ["Mega"] = 459.38, ["Mega|Ride"] = 532.91, ["Mega|Fly|Ride"] = 717.73}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 15.42, ["Fly|Ride"] = 35.96, ["Neon"] = 2.63, ["Neon|Fly"] = 22, ["Neon|Ride"] = 17.37, ["Neon|Fly|Ride"] = 40.69, ["Mega"] = 18.37, ["Mega|Fly"] = 48.87, ["Mega|Ride"] = 34.95, ["Mega|Fly|Ride"] = 82.21}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 3.92, ["Neon|Ride"] = 46.41, ["Neon|Fly|Ride"] = 89.83, ["Mega"] = 89.25, ["Mega|Ride"] = 81.19, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 3.94, ["Fly"] = 72.19, ["Ride"] = 52.5, ["Fly|Ride"] = 137.82, ["Neon"] = 13.13, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 180.72, ["Mega"] = 74.06, ["Mega|Fly"] = 178.67, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 548.31}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 5.02, ["Fly"] = 69.45, ["Ride"] = 53.25, ["Fly|Ride"] = 131.25, ["Neon"] = 28.88, ["Neon|Fly"] = 136.5, ["Neon|Ride"] = 70.27, ["Neon|Fly|Ride"] = 231.47, ["Mega"] = 102.38, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 266.18, ["Mega|Fly|Ride"] = 249.37}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 19.52, ["Ride"] = 13.89, ["Fly|Ride"] = 35.96, ["Neon"] = 2.63, ["Neon|Fly"] = 21, ["Neon|Ride"] = 24.66, ["Neon|Fly|Ride"] = 57.51, ["Mega"] = 21.56, ["Mega|Fly"] = 39.38, ["Mega|Ride"] = 32.69, ["Mega|Fly|Ride"] = 151.61}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 15.75, ["Fly"] = 72.19, ["Ride"] = 117.07, ["Fly|Ride"] = 100.69, ["Neon"] = 78.75, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 205.37, ["Mega"] = 495.3, ["Mega|Ride"] = 409.7, ["Mega|Fly|Ride"] = 683.85}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2626.32, ["Fly"] = 3150, ["Ride"] = 2756.25, ["Fly|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 35869.4}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 52.38, ["Ride"] = 20.55, ["Fly|Ride"] = 45.14, ["Neon"] = 12.34, ["Neon|Fly"] = 55.46, ["Neon|Ride"] = 27.74, ["Neon|Fly|Ride"] = 49.77, ["Mega"] = 72.19, ["Mega|Fly"] = 149.92, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 169.32}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 3.82, ["Neon"] = 13.91, ["Mega"] = 137.61, ["Mega|Fly"] = 441, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 616.07}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 18.39, ["Ride"] = 30.19, ["Fly|Ride"] = 69.57, ["Neon"] = 100.65, ["Neon|Ride"] = 89.34, ["Neon|Fly|Ride"] = 100.69, ["Mega"] = 393.75, ["Mega|Ride"] = 392.02, ["Mega|Fly|Ride"] = 462}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 33.75, ["Ride"] = 98.44, ["Neon"] = 138.9, ["Neon|Ride"] = 216.42, ["Mega"] = 540.75, ["Mega|Ride"] = 798.84, ["Mega|Fly|Ride"] = 803.13}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 167.13, ["Fly"] = 1369.74, ["Ride"] = 208.68, ["Fly|Ride"] = 236.25, ["Neon"] = 1312.5, ["Neon|Ride"] = 717.73, ["Neon|Fly|Ride"] = 718.76, ["Mega"] = 6160.67, ["Mega|Ride"] = 3469.36, ["Mega|Fly|Ride"] = 3014.55}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 7.09, ["Fly"] = 27.74, ["Ride"] = 28.88, ["Fly|Ride"] = 675.94, ["Neon"] = 13.13, ["Neon|Ride"] = 128.7, ["Mega"] = 123.22, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 155.09, ["Mega|Fly|Ride"] = 349.12}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 3.94, ["Ride"] = 52.5, ["Neon"] = 15.42, ["Neon|Fly"] = 96.54, ["Neon|Fly|Ride"] = 513.4, ["Mega"] = 114.76, ["Mega|Ride"] = 320.25, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 3.15, ["Fly"] = 101.98, ["Ride"] = 43.99, ["Fly|Ride"] = 196.87, ["Neon"] = 9.19, ["Neon|Ride"] = 41.09, ["Mega"] = 68.83, ["Mega|Ride"] = 109.88, ["Mega|Fly|Ride"] = 307.01}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 13.13, ["Ride"] = 39.38, ["Neon"] = 131.24, ["Neon|Ride"] = 1165.82, ["Mega|Ride"] = 602.74, ["Mega|Fly|Ride"] = 410.73}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 89.67, ["Mega"] = 17.05, ["Mega|Ride"] = 123.22, ["Mega|Fly|Ride"] = 410.73}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 83.87, ["Fly"] = 137.61, ["Ride"] = 78.74, ["Fly|Ride"] = 137.61, ["Neon"] = 410.73, ["Neon|Fly"] = 309.02, ["Neon|Ride"] = 394.29, ["Neon|Fly|Ride"] = 510.35, ["Mega"] = 1365, ["Mega|Fly|Ride"] = 1724.14}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.63, ["Ride"] = 32.82, ["Neon"] = 9.89, ["Neon|Ride"] = 137.61, ["Mega"] = 61.69, ["Mega|Ride"] = 151.97, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 39.37, ["Fly"] = 216.42, ["Ride"] = 74.81, ["Fly|Ride"] = 131.25, ["Neon"] = 262.5, ["Neon|Ride"] = 328.02, ["Neon|Fly|Ride"] = 396.73, ["Mega"] = 2625, ["Mega|Ride"] = 1848.2, ["Mega|Fly|Ride"] = 1443.75}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.52, ["Fly|Ride"] = 50.28, ["Neon"] = 6.17, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 58.47, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 43.1, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 164.99}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.63, ["Neon"] = 15.39, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 360.94, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 15.43, ["Fly|Ride"] = 204.44, ["Neon"] = 41.1, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 205.37, ["Mega"] = 231.47, ["Mega|Ride"] = 307.13, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 355.69, ["Fly"] = 548.31, ["Ride"] = 417.38, ["Fly|Ride"] = 498.75, ["Neon"] = 1181.24, ["Neon|Ride"] = 1427.24, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Ride"] = 3674.99, ["Mega|Fly|Ride"] = 3799.69}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 34.58, ["Ride"] = 51.15, ["Fly|Ride"] = 126, ["Neon"] = 205.37, ["Neon|Ride"] = 219.75, ["Neon|Fly|Ride"] = 275.63, ["Mega|Ride"] = 1211.61, ["Mega|Fly|Ride"] = 1003.32}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 42.75, ["Ride"] = 19.52, ["Fly|Ride"] = 91.88, ["Neon"] = 10.4, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 52.38, ["Neon|Fly|Ride"] = 68.81, ["Mega"] = 49.88, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 183.74}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 17.37, ["Fly"] = 359.39, ["Ride"] = 46.31, ["Fly|Ride"] = 131.94, ["Neon"] = 36.74, ["Neon|Fly"] = 105, ["Neon|Ride"] = 108.8, ["Neon|Fly|Ride"] = 174.12, ["Mega"] = 238.88, ["Mega|Fly"] = 381.97, ["Mega|Ride"] = 244.13, ["Mega|Fly|Ride"] = 341.16}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 7.39, ["Ride"] = 23.12, ["Fly|Ride"] = 261.84, ["Neon"] = 138.63, ["Neon|Ride"] = 31.85, ["Neon|Fly|Ride"] = 309, ["Mega"] = 1095.59, ["Mega|Ride"] = 682.26, ["Mega|Fly|Ride"] = 384.76}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.15, ["Neon"] = 16.96, ["Mega"] = 53.41, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.62, ["Fly"] = 39.38, ["Ride"] = 18.18, ["Fly|Ride"] = 47.24, ["Neon"] = 13.13, ["Neon|Ride"] = 32.79, ["Neon|Fly|Ride"] = 209.48, ["Mega"] = 57.75, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 955.94}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 106.38, ["Ride"] = 127.32, ["Fly|Ride"] = 192.03, ["Neon|Ride"] = 708.64, ["Neon|Fly|Ride"] = 853.13, ["Mega|Fly|Ride"] = 3347.31}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 27.03, ["Fly"] = 95.82, ["Ride"] = 94.49, ["Fly|Ride"] = 137.61, ["Neon"] = 192.94, ["Neon|Ride"] = 192.14, ["Mega"] = 656.25, ["Mega|Ride"] = 667.42, ["Mega|Fly|Ride"] = 763.77}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2216.81, ["Fly"] = 2349.38, ["Ride"] = 2228.63, ["Fly|Ride"] = 2387.44, ["Neon"] = 10952.64, ["Neon|Fly|Ride"] = 7666.32, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.71, ["Fly"] = 65625, ["Ride"] = 110.25, ["Fly|Ride"] = 170.63, ["Neon"] = 13.02, ["Neon|Ride"] = 135.54, ["Neon|Fly|Ride"] = 192.03, ["Mega"] = 118.13, ["Mega|Ride"] = 163.96, ["Mega|Fly|Ride"] = 573.99}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 11.82, ["Ride"] = 45.94, ["Neon"] = 104.37, ["Neon|Ride"] = 119.21, ["Neon|Fly|Ride"] = 232.32, ["Mega"] = 302.91, ["Mega|Ride"] = 240.19, ["Mega|Fly|Ride"] = 509.92}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 862.79, ["Fly"] = 1424.16, ["Ride"] = 913.48, ["Fly|Ride"] = 971.25, ["Neon"] = 2598.75, ["Neon|Ride"] = 2968.8, ["Neon|Fly|Ride"] = 2480.62, ["Mega|Fly|Ride"] = 11444.47}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 40.06, ["Ride"] = 56.44, ["Fly|Ride"] = 134.52, ["Neon"] = 157.5, ["Neon|Ride"] = 291.72, ["Neon|Fly|Ride"] = 369.65, ["Mega"] = 1095.59, ["Mega|Ride"] = 771.88, ["Mega|Fly|Ride"] = 808.1}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.94, ["Ride"] = 22.91, ["Fly|Ride"] = 128.09, ["Neon"] = 17.37, ["Neon|Ride"] = 41.09, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 196.88, ["Mega|Ride"] = 123.22, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 137.61, ["Neon"] = 3.94, ["Neon|Fly|Ride"] = 77.56, ["Mega"] = 82.16, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 274.16}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 80.56, ["Ride"] = 127.32, ["Fly|Ride"] = 308.99, ["Neon"] = 459.38, ["Neon|Fly|Ride"] = 420, ["Mega"] = 2738.43, ["Mega|Fly|Ride"] = 2296.88}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 3.71, ["Fly|Ride"] = 72.19, ["Neon"] = 27.57, ["Neon|Ride"] = 61.62, ["Mega"] = 137.82, ["Mega|Ride"] = 199.21, ["Mega|Fly|Ride"] = 263.71}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 78.63, ["Ride"] = 133.71, ["Neon"] = 385.88, ["Neon|Ride"] = 463.32, ["Neon|Fly|Ride"] = 494.32, ["Mega"] = 1950.89, ["Mega|Fly|Ride"] = 2039.18}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 7.66, ["Fly"] = 105, ["Fly|Ride"] = 109.88, ["Neon"] = 39.36, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 203.43, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 233.62, ["Ride"] = 272.4, ["Fly|Ride"] = 322.26, ["Neon"] = 1080.99, ["Neon|Ride"] = 836.06, ["Neon|Fly|Ride"] = 878.07, ["Mega|Fly|Ride"] = 4229.3}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 8.23, ["Fly"] = 87.93, ["Ride"] = 26.36, ["Fly|Ride"] = 52.38, ["Neon"] = 31.26, ["Neon|Ride"] = 64.89, ["Neon|Fly|Ride"] = 114.15, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 20.85, ["Ride"] = 15.25, ["Fly|Ride"] = 37.41, ["Neon"] = 5.1, ["Neon|Fly"] = 25.48, ["Neon|Ride"] = 23.16, ["Neon|Fly|Ride"] = 53.38, ["Mega"] = 52.5, ["Mega|Fly"] = 112.18, ["Mega|Ride"] = 60.38, ["Mega|Fly|Ride"] = 154.88}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 892.4, ["Ride"] = 985.71, ["Fly|Ride"] = 1027.3, ["Neon|Ride"] = 7530.39, ["Neon|Fly|Ride"] = 4723.18, ["Mega"] = 26012.36, ["Mega|Fly|Ride"] = 27381.05}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 10.49, ["Fly"] = 959.03, ["Ride"] = 210, ["Neon"] = 66.94, ["Neon|Ride"] = 129.29, ["Mega"] = 233.19, ["Mega|Ride"] = 286.49, ["Mega|Fly|Ride"] = 326.17}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 7.46, ["Ride"] = 32.82, ["Fly|Ride"] = 127.32, ["Neon"] = 30.19, ["Neon|Fly"] = 77.68, ["Neon|Ride"] = 66.81, ["Neon|Fly|Ride"] = 136.49, ["Mega"] = 175.13, ["Mega|Ride"] = 165.13, ["Mega|Fly|Ride"] = 296.63}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 34.93, ["Fly"] = 40.55, ["Ride"] = 44.16, ["Fly|Ride"] = 90.37, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 183.66, ["Mega"] = 2053.57, ["Mega|Ride"] = 761.25, ["Mega|Fly|Ride"] = 771.88}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 14.87, ["Fly"] = 77.02, ["Ride"] = 31.32, ["Fly|Ride"] = 87.94, ["Neon"] = 48.28, ["Neon|Ride"] = 96.54, ["Neon|Fly|Ride"] = 145.69, ["Mega"] = 274.16, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 435.38}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 26.25, ["Ride"] = 209.99, ["Fly|Ride"] = 118.13, ["Neon"] = 96.35, ["Neon|Ride"] = 273, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 483.62, ["Mega|Ride"] = 572.96, ["Mega|Fly|Ride"] = 618.15}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Fly|Ride"] = 231.46, ["Neon"] = 2.63, ["Neon|Fly"] = 55.6, ["Neon|Ride"] = 72.1, ["Neon|Fly|Ride"] = 68.81, ["Mega"] = 17.07, ["Mega|Fly"] = 57.75, ["Mega|Ride"] = 64.13}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 49.31, ["Fly"] = 89.25, ["Ride"] = 68.25, ["Fly|Ride"] = 115.74, ["Neon"] = 339.87, ["Neon|Fly"] = 322.91, ["Neon|Ride"] = 266.98, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 3285.71, ["Mega|Ride"] = 1095.9, ["Mega|Fly|Ride"] = 956.71}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 4.66, ["Fly"] = 27.74, ["Ride"] = 18.54, ["Fly|Ride"] = 69.92, ["Neon"] = 26.25, ["Neon|Ride"] = 39.38, ["Mega"] = 773.07, ["Mega|Ride"] = 309.7, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 24.66, ["Ride"] = 20.55, ["Fly|Ride"] = 38.04, ["Neon"] = 12.71, ["Neon|Ride"] = 27.76, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 265.9, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 5.12, ["Ride"] = 171.49, ["Neon"] = 105, ["Neon|Ride"] = 821.44, ["Neon|Fly|Ride"] = 183.81, ["Mega"] = 246.44, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 39.36, ["Fly"] = 262.5, ["Ride"] = 86.81, ["Fly|Ride"] = 183.75, ["Neon"] = 195.57, ["Neon|Ride"] = 231.47, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 809.12, ["Mega|Ride"] = 844.59, ["Mega|Fly|Ride"] = 756}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 8.71, ["Ride"] = 684.88, ["Neon"] = 21.77, ["Neon|Ride"] = 77.02, ["Neon|Fly|Ride"] = 137.61, ["Mega"] = 86.57, ["Mega|Fly"] = 302.91, ["Mega|Fly|Ride"] = 309}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 33.78, ["Neon"] = 2.63, ["Neon|Ride"] = 20.6, ["Mega"] = 15.74, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 205.37}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 68.81, ["Ride"] = 25.08, ["Fly|Ride"] = 82.16, ["Neon"] = 2.57, ["Neon|Ride"] = 31.75, ["Mega"] = 16.63, ["Mega|Ride"] = 40.09, ["Mega|Fly|Ride"] = 105.29}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 20, ["Ride"] = 72.19, ["Fly|Ride"] = 59.07, ["Neon"] = 7.86, ["Neon|Fly"] = 123.22, ["Neon|Ride"] = 55.46, ["Neon|Fly|Ride"] = 55.46, ["Mega"] = 96.54, ["Mega|Ride"] = 137.61, ["Mega|Fly|Ride"] = 139.13}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.5, ["Ride"] = 27.74, ["Fly|Ride"] = 109.88, ["Neon"] = 16.45, ["Neon|Ride"] = 1312.5, ["Mega"] = 118.09, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 38.05, ["Ride"] = 15.12, ["Fly|Ride"] = 35.44, ["Neon"] = 14.42, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 77.58, ["Mega"] = 307.79, ["Mega|Ride"] = 272.35, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 78.75, ["Ride"] = 108.8, ["Fly|Ride"] = 359.39, ["Neon"] = 164.06, ["Neon|Ride"] = 231.27, ["Neon|Fly|Ride"] = 1026.8, ["Mega"] = 883.04, ["Mega|Ride"] = 883.31, ["Mega|Fly|Ride"] = 924.62}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 25.68, ["Ride"] = 16.45, ["Fly|Ride"] = 41.09, ["Neon"] = 2.62, ["Neon|Fly"] = 24.65, ["Neon|Ride"] = 20.55, ["Neon|Fly|Ride"] = 45.99, ["Mega"] = 39.38, ["Mega|Ride"] = 68.81, ["Mega|Fly|Ride"] = 100.61}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 7.71, ["Fly"] = 60.4, ["Ride"] = 40.06, ["Fly|Ride"] = 74.82, ["Neon"] = 55.46, ["Neon|Fly"] = 76.13, ["Neon|Ride"] = 74.82, ["Neon|Fly|Ride"] = 114.18, ["Mega"] = 262.5, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 299.24}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 15.73, ["Fly"] = 55.19, ["Ride"] = 28.46, ["Fly|Ride"] = 72.19, ["Neon"] = 109.25, ["Neon|Ride"] = 102.37, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 1160.28, ["Mega|Ride"] = 520.58, ["Mega|Fly|Ride"] = 544.58}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 2.96, ["Fly"] = 196.88, ["Neon"] = 60.59, ["Mega"] = 131.25, ["Mega|Ride"] = 246.88, ["Mega|Fly|Ride"] = 405.6}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 14.73, ["Fly|Ride"] = 39.03, ["Neon"] = 5.24, ["Neon|Fly"] = 40.06, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 45.84, ["Mega"] = 49.3, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 61.69, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 2.63, ["Fly"] = 68.81, ["Ride"] = 27.74, ["Neon"] = 11.82, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 96.53, ["Mega"] = 127.32, ["Mega|Fly"] = 735, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 373.76}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 971.23, ["Fly"] = 1230.09, ["Ride"] = 1049.99, ["Fly|Ride"] = 1053.94, ["Neon|Ride"] = 2191.85, ["Neon|Fly|Ride"] = 2415, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 72.73, ["Ride"] = 118.13, ["Fly|Ride"] = 201.37, ["Neon"] = 322.43, ["Neon|Ride"] = 458.07, ["Neon|Fly|Ride"] = 589.39, ["Mega"] = 2777.35, ["Mega|Ride"] = 1918.04, ["Mega|Fly|Ride"] = 1548.75}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.62, ["Ride"] = 68.61, ["Neon"] = 5.23, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 205.37, ["Mega"] = 72.1, ["Mega|Ride"] = 102.69, ["Mega|Fly|Ride"] = 178.67}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 56.33, ["Fly"] = 142.73, ["Ride"] = 102.69, ["Fly|Ride"] = 170.62, ["Neon"] = 236.25, ["Neon|Ride"] = 313.85, ["Neon|Fly|Ride"] = 355.28, ["Mega"] = 1023.75, ["Mega|Ride"] = 1130.05, ["Mega|Fly|Ride"] = 1102.5}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.94, ["Ride"] = 20.13, ["Fly|Ride"] = 65.63, ["Neon"] = 62.66, ["Neon|Ride"] = 49.45, ["Neon|Fly|Ride"] = 273.13, ["Mega"] = 183.75, ["Mega|Ride"] = 345.01, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 251.99, ["Fly"] = 410.73, ["Ride"] = 308.1, ["Fly|Ride"] = 314.22, ["Neon|Ride"] = 1308.13, ["Neon|Fly|Ride"] = 1386.16, ["Mega|Fly|Ride"] = 4312.47}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 75.64, ["Ride"] = 26.25, ["Fly|Ride"] = 202.13, ["Neon"] = 27.74, ["Neon|Ride"] = 54.37, ["Mega"] = 406.63, ["Mega|Fly"] = 320.37}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Ride"] = 19.59, ["Neon"] = 32.82, ["Neon|Ride"] = 82.16, ["Mega"] = 328.58, ["Mega|Ride"] = 326.53}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 60.63, ["Fly"] = 155.08, ["Ride"] = 96.55, ["Fly|Ride"] = 525, ["Neon"] = 495.36, ["Neon|Ride"] = 386.53, ["Mega"] = 542, ["Mega|Ride"] = 715.18, ["Mega|Fly|Ride"] = 965.99}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.63, ["Ride"] = 49.54, ["Neon"] = 20.48, ["Mega"] = 78.75, ["Mega|Ride"] = 250.74, ["Mega|Fly|Ride"] = 452.48}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 14.43, ["Fly|Ride"] = 32.48, ["Neon"] = 3.65, ["Neon|Fly"] = 31.29, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 27.57, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 101.85}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4331.24, ["Ride"] = 4446.75, ["Fly|Ride"] = 4068.75, ["Neon"] = 30803.29, ["Neon|Fly|Ride"] = 21631.11, ["Mega|Fly|Ride"] = 84880.49}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 15.26, ["Fly"] = 39.38, ["Ride"] = 56.43, ["Neon"] = 82.16, ["Neon|Ride"] = 106.32, ["Mega"] = 274.16, ["Mega|Ride"] = 213.29, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.6, ["Fly"] = 20.09, ["Ride"] = 19.69, ["Fly|Ride"] = 55.46, ["Neon"] = 16.94, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 70.62, ["Mega"] = 137.82, ["Mega|Ride"] = 155.28, ["Mega|Fly|Ride"] = 181.23}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 459.38, ["Fly"] = 840, ["Ride"] = 500.06, ["Fly|Ride"] = 567.99, ["Neon"] = 1372.81, ["Neon|Ride"] = 1546.33, ["Neon|Fly|Ride"] = 1366.59, ["Mega|Fly|Ride"] = 5078.07}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 11.71, ["Ride"] = 24.99, ["Neon"] = 17.06, ["Neon|Ride"] = 145.69, ["Mega"] = 129.94, ["Mega|Fly|Ride"] = 684.88}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 7.96, ["Fly"] = 137.61, ["Ride"] = 46.31, ["Neon"] = 131.25, ["Neon|Ride"] = 274.16, ["Neon|Fly|Ride"] = 274.16, ["Mega"] = 408.68, ["Mega|Ride"] = 355.28, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.52, ["Fly"] = 52.36, ["Ride"] = 27.64, ["Fly|Ride"] = 82.16, ["Neon"] = 3.9, ["Neon|Fly"] = 124.68, ["Neon|Ride"] = 27.74, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 35.96, ["Mega|Ride"] = 74.34, ["Mega|Fly|Ride"] = 255.28}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 734.99, ["Fly"] = 767.01, ["Ride"] = 651, ["Fly|Ride"] = 685.74, ["Neon"] = 2362.5, ["Neon|Ride"] = 1957.32, ["Neon|Fly|Ride"] = 1910.27}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 7.22, ["Ride"] = 78.74, ["Neon"] = 29.89, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 648.38, ["Mega"] = 144.2, ["Mega|Ride"] = 171.99, ["Mega|Fly|Ride"] = 294.67}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 6.56, ["Fly"] = 236.15, ["Ride"] = 32.82, ["Neon"] = 39.09, ["Neon|Fly"] = 164.3, ["Neon|Ride"] = 75.91, ["Neon|Fly|Ride"] = 105, ["Mega"] = 188.99, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 291.38}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.11, ["Ride"] = 19.84, ["Fly|Ride"] = 47.25, ["Neon"] = 13, ["Neon|Fly"] = 96.54, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 65.63, ["Mega|Fly|Ride"] = 208.85}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 16.96, ["Ride"] = 46.31, ["Neon"] = 118.13, ["Neon|Fly"] = 170.63, ["Neon|Ride"] = 135.55, ["Mega"] = 462.91, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.63, ["Neon"] = 5.14, ["Neon|Fly"] = 137.61, ["Neon|Ride"] = 39.13, ["Neon|Fly|Ride"] = 183.81, ["Mega"] = 34.54, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 302.91}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 511.87, ["Ride"] = 532.37, ["Fly|Ride"] = 616.07, ["Neon"] = 2589.57, ["Neon|Ride"] = 2601.87, ["Neon|Fly|Ride"] = 2464.27, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 72.18, ["Fly|Ride"] = 324.48, ["Neon"] = 11.76, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 192.03, ["Mega"] = 73.95, ["Mega|Ride"] = 147.61, ["Mega|Fly|Ride"] = 279.57}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 41.21, ["Neon"] = 4.6, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 51.19, ["Mega|Fly"] = 100.65, ["Mega|Ride"] = 137.61, ["Mega|Fly|Ride"] = 258.77}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 24.45, ["Neon"] = 5.25, ["Neon|Ride"] = 41.3, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 45.94, ["Mega|Fly"] = 151.97, ["Mega|Ride"] = 78.74, ["Mega|Fly|Ride"] = 192.03}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 3.77, ["Ride"] = 131.25, ["Neon"] = 18.48, ["Neon|Ride"] = 41.09, ["Mega"] = 224.88}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 38.07, ["Ride"] = 137.61, ["Fly|Ride"] = 180.72, ["Neon"] = 336, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 215.25, ["Mega"] = 608.81, ["Mega|Ride"] = 630.46, ["Mega|Fly|Ride"] = 649.02}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 15.16, ["Ride"] = 68.13, ["Fly|Ride"] = 116.6, ["Neon"] = 100.12, ["Neon|Ride"] = 128.42, ["Mega"] = 463.63, ["Mega|Ride"] = 385.88, ["Mega|Fly|Ride"] = 560.78}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.9, ["Fly"] = 24.66, ["Ride"] = 16.43, ["Fly|Ride"] = 53.41, ["Neon"] = 27.74, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 299.92, ["Mega|Ride"] = 137.61, ["Mega|Fly|Ride"] = 193.91}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 15.3, ["Ride"] = 64.32, ["Fly|Ride"] = 102.69, ["Neon"] = 89.25, ["Neon|Ride"] = 68.81, ["Mega"] = 183.75, ["Mega|Ride"] = 215.63, ["Mega|Fly|Ride"] = 959.03}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 24.93, ["Fly|Ride"] = 61.62, ["Neon"] = 13.13, ["Neon|Ride"] = 33.57, ["Neon|Fly|Ride"] = 205.99, ["Mega"] = 83.98, ["Mega|Fly"] = 147.87, ["Mega|Ride"] = 151.97, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 17.06, ["Fly"] = 62.51, ["Ride"] = 30.17, ["Fly|Ride"] = 155.08, ["Neon"] = 228.74, ["Neon|Ride"] = 147.93, ["Neon|Fly|Ride"] = 238.23, ["Mega"] = 972.08, ["Mega|Ride"] = 925.79, ["Mega|Fly|Ride"] = 607.86}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 34.12, ["Fly"] = 874.13, ["Neon"] = 106.32, ["Mega"] = 410.73}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 62.51, ["Fly"] = 82.16, ["Ride"] = 71.54, ["Fly|Ride"] = 163.66, ["Neon"] = 249.38, ["Neon|Fly"] = 431.26, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 349.13, ["Mega|Ride"] = 1437.41, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 45.48, ["Fly"] = 88.05, ["Ride"] = 107.63, ["Fly|Ride"] = 219.89, ["Neon"] = 129.94, ["Neon|Ride"] = 408.19, ["Neon|Fly|Ride"] = 231.47, ["Mega"] = 537.83, ["Mega|Ride"] = 572.25, ["Mega|Fly|Ride"] = 620.82}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 35.49, ["Ride"] = 77.02, ["Fly|Ride"] = 137.61, ["Neon"] = 137.61, ["Neon|Ride"] = 144.38, ["Mega"] = 821.44, ["Mega|Fly|Ride"] = 750.59}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 9.19, ["Fly"] = 410.73, ["Ride"] = 45.85, ["Fly|Ride"] = 150.45, ["Neon"] = 86.15, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 457.47, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 484.67}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.74, ["Ride"] = 15.42, ["Fly|Ride"] = 32.23, ["Neon"] = 5.2, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 41.99, ["Mega|Fly"] = 205.37, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 202.79}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1848.2}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 39.26, ["Ride"] = 118.13, ["Fly|Ride"] = 171.49, ["Neon"] = 246.44, ["Neon|Ride"] = 231.47, ["Neon|Fly|Ride"] = 274.16, ["Mega"] = 683.85, ["Mega|Ride"] = 602.74, ["Mega|Fly|Ride"] = 724.16}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 55.46, ["Neon"] = 5.25, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 287.52, ["Mega"] = 25.76, ["Mega|Ride"] = 61.62, ["Mega|Fly|Ride"] = 151.97}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 32.02, ["Ride"] = 74.08, ["Neon"] = 124.69, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 525, ["Mega"] = 711.38, ["Mega|Ride"] = 702.33, ["Mega|Fly|Ride"] = 841.31}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 105, ["Mega"] = 40.74}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 46.31, ["Mega"] = 24.24, ["Mega|Ride"] = 106.81, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 105, ["Ride"] = 141.15, ["Fly|Ride"] = 392.44, ["Neon"] = 498.75, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 671.52, ["Mega|Ride"] = 2253.12, ["Mega|Fly|Ride"] = 2098.68}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 17.07, ["Fly|Ride"] = 92.67, ["Neon"] = 12.75, ["Neon|Ride"] = 26.71, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 90.56, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 205.43}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Fly|Ride"] = 86.63, ["Neon"] = 3.93, ["Neon|Fly"] = 61.62, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 102.69, ["Mega"] = 32.03, ["Mega|Ride"] = 122.19, ["Mega|Fly|Ride"] = 220.5}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 6.45, ["Neon|Ride"] = 44.18, ["Mega"] = 27.43, ["Mega|Ride"] = 183.74}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 4.97, ["Neon|Ride"] = 131.24, ["Mega"] = 55.13, ["Mega|Ride"] = 96.56, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 52.5, ["Ride"] = 102.69, ["Fly|Ride"] = 449.61, ["Neon"] = 410.73, ["Neon|Ride"] = 486.7, ["Neon|Fly|Ride"] = 695.63, ["Mega|Fly|Ride"] = 1363.58}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.57, ["Ride"] = 62.51, ["Fly|Ride"] = 131.25, ["Neon"] = 42.56, ["Neon|Ride"] = 153.25, ["Mega"] = 364.58, ["Mega|Ride"] = 275.63}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 301.88, ["Ride"] = 423.05, ["Fly|Ride"] = 616.88, ["Neon"] = 1640.81, ["Neon|Ride"] = 1641.84, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Ride"] = 4106.09, ["Mega|Fly|Ride"] = 3696.4}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 78.75}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 43.32}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 8.24}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 4.13}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.63}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 8.24}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 3.49}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.63}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 5730.24}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.5}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 44.89}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.36}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 8.05}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.44}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 6.18}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 27.74}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 7.87}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 3.71}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.29}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.52}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 15.42}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 95.7}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.49}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 5.24}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.94}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 11.02}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 3.74}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 5.77}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 5.25}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4044.48}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 5.24}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.63}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 43.32}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 4.27}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.63}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 52.48}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 81.38}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 3.56}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 5.13}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 91.87}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.05}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.14}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.77}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 7.64}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 2.62}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 5.25}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 40.52}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.63}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.54}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.52}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.63}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 14.1}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 11.31}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 6.56}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 4.13}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 3.94}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 6.18}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 6.57}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 17.75}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 1575}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 4.13}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 12.98}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 86.63}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.49}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 39.37}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 3.81}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 3.82}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 984.37}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 31.38}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 4.73}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 9.65}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 22.32}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 5.04}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 66.2}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 3.35}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 10.49}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 10.49}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.52}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 13.12}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 19.69}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.63}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 4.75}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.14}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 11.3}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 16.44}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.51}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 12.72}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.81}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 7.23}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.63}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 15.42}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 59.56}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 7.85}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 3.13}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.43}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 14.44}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 39.9}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 18.15}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.8}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 3.93}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 80.05}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 3.94}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 24.69}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 6.18}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.62}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.63}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 3.61}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.12}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 7.8}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 4.2}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 91.88}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 4.13}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 131.14}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 5.25}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1050}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 212.63}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.24}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.37}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.58}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 22.31}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 60.27}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 13.13}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 7.88}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 39.38}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 5.25}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 6.45}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.62}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.5}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.63}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 14.96}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 56.44}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 27.74}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 59.77}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 4.13}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 8.24}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 3.29}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 6.97}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 28.86}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 109.73}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.63}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.63}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 65.44}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 3.67}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.19}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.52}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 6.16}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 90.57}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 71.89}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 684.88}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.93}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 126.88}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 131.15}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.9}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.63}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 27.08}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 36.74}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.94}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 41.91}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.82}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 73.47}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 15.6}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 28.88}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 23.63}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 5.25}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 19.56}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.52}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 11.82}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 71.74}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 41.03}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 73.5}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1782.38}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 35.43}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 431.26}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 36.66}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 49.88}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 125.64}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 102.69}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1155}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 191.63}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 8.27}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2100}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 418.69}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 3.82}},
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