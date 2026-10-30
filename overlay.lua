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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 999.85, ["Ride"] = 853.13, ["Fly|Ride"] = 1050, ["Neon"] = 9187.5, ["Neon|Ride"] = 3020.47, ["Neon|Fly|Ride"] = 3921.75, ["Mega|Fly|Ride"] = 24697.93}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 367.5, ["Fly"] = 577.08, ["Ride"] = 471.2, ["Fly|Ride"] = 584.59, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 2880.45, ["Mega"] = 10294.65}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 5972.17, ["Ride"] = 5197.5, ["Fly|Ride"] = 4459.88, ["Neon|Fly|Ride"] = 19903.67, ["Mega|Fly|Ride"] = 68605.68}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 164.58, ["Ride"] = 182.44, ["Fly|Ride"] = 252, ["Neon"] = 774.48, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 1098.45, ["Mega"] = 4117.87, ["Mega|Fly|Ride"] = 3137.81}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 590.63, ["Fly"] = 824.4, ["Ride"] = 577.5, ["Fly|Ride"] = 580.13, ["Neon|Ride"] = 1837.5, ["Neon|Fly|Ride"] = 1653.75, ["Mega|Fly|Ride"] = 6502.35}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 9.19, ["Ride"] = 27.68, ["Fly|Ride"] = 152.37, ["Neon"] = 72.19, ["Neon|Ride"] = 109.16, ["Neon|Fly|Ride"] = 274.88, ["Mega"] = 288.35, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.93, ["Fly"] = 40.6, ["Ride"] = 33.36, ["Fly|Ride"] = 57.75, ["Neon"] = 32.82, ["Neon|Fly"] = 106.84, ["Neon|Ride"] = 43.31, ["Neon|Fly|Ride"] = 108.94, ["Mega"] = 131.03, ["Mega|Ride"] = 200.82, ["Mega|Fly|Ride"] = 286.61}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 98.76, ["Ride"] = 146.24, ["Fly|Ride"] = 233.63, ["Neon"] = 546.66, ["Neon|Ride"] = 616.67, ["Neon|Fly|Ride"] = 616.58, ["Mega"] = 1441.27, ["Mega|Ride"] = 2333.81, ["Mega|Fly|Ride"] = 2646.76}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 27.81, ["Fly"] = 138.06, ["Ride"] = 46.49, ["Fly|Ride"] = 81.6, ["Neon"] = 225.47, ["Neon|Ride"] = 301.86, ["Neon|Fly|Ride"] = 278.69, ["Mega"] = 1373.32, ["Mega|Ride"] = 2730, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 23.25, ["Fly"] = 49.88, ["Ride"] = 36.75, ["Fly|Ride"] = 65.63, ["Neon"] = 137.96, ["Neon|Ride"] = 199.73, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 1337.3, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 62.36, ["Fly"] = 85.32, ["Ride"] = 80.75, ["Fly|Ride"] = 131.25, ["Neon"] = 262.5, ["Neon|Fly"] = 370.62, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 288.75}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 60.9}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 335.55, ["Fly"] = 395.01, ["Ride"] = 344.12, ["Fly|Ride"] = 388.26, ["Neon"] = 1373.32, ["Neon|Ride"] = 1262.16, ["Neon|Fly|Ride"] = 1140.27, ["Mega|Fly|Ride"] = 4845.7}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 103.95, ["Fly"] = 122.64, ["Ride"] = 123.38, ["Fly|Ride"] = 124.38, ["Neon|Ride"] = 564.38, ["Neon|Fly|Ride"] = 649.61, ["Mega|Fly|Ride"] = 2626.18}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.29, ["Fly"] = 114.37, ["Ride"] = 51.85, ["Fly|Ride"] = 205.91, ["Neon"] = 19.69, ["Neon|Fly"] = 96.41, ["Neon|Ride"] = 137.96, ["Neon|Fly|Ride"] = 137.96, ["Mega"] = 137.76, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 384.35}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 155.93, ["Fly"] = 242.12, ["Ride"] = 144.38, ["Fly|Ride"] = 209.99, ["Neon"] = 928.92, ["Neon|Ride"] = 577.5, ["Neon|Fly|Ride"] = 621.56, ["Mega|Fly|Ride"] = 2229.93}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.63, ["Fly"] = 21.38, ["Ride"] = 21, ["Fly|Ride"] = 39.37, ["Neon"] = 24.97, ["Neon|Ride"] = 90.61, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 334.69, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 97.46, ["Fly"] = 262.5, ["Ride"] = 123.38, ["Fly|Ride"] = 180.79, ["Neon"] = 343.86, ["Neon|Fly"] = 464.46, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 426.57, ["Mega"] = 1496.85, ["Mega|Ride"] = 1153.59, ["Mega|Fly|Ride"] = 1102.5}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 33.78}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 57.12, ["Ride"] = 123.38, ["Fly|Ride"] = 164.07, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 2362.5}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 15.65, ["Fly"] = 393.75, ["Ride"] = 35.44, ["Fly|Ride"] = 223.13, ["Neon"] = 65.63, ["Neon|Ride"] = 164.73, ["Neon|Fly|Ride"] = 247.09, ["Mega|Ride"] = 579.6, ["Mega|Fly|Ride"] = 549.75}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 42.3, ["Fly"] = 77.86, ["Ride"] = 55.08, ["Fly|Ride"] = 114.3, ["Neon"] = 241.34, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 288.74, ["Mega"] = 1625.59, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 34.13, ["Ride"] = 124.32, ["Fly|Ride"] = 136.5, ["Neon"] = 204.75, ["Neon|Fly"] = 385.51, ["Neon|Ride"] = 295.47, ["Neon|Fly|Ride"] = 343.86, ["Mega"] = 1069.63, ["Mega|Ride"] = 1231.25, ["Mega|Fly|Ride"] = 1006.57}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 27.17, ["Ride"] = 40.68, ["Fly|Ride"] = 131.25, ["Neon"] = 343.86, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 315, ["Mega"] = 770.05, ["Mega|Ride"] = 2056.89, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 40.67, ["Fly"] = 136.75, ["Ride"] = 59.06, ["Fly|Ride"] = 144.38, ["Neon"] = 210, ["Neon|Fly"] = 550.77, ["Neon|Ride"] = 310.04, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 859.13}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 7.47, ["Fly"] = 36.08, ["Ride"] = 20.63, ["Fly|Ride"] = 41.57, ["Neon"] = 30.94, ["Neon|Fly"] = 104.99, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 91.85, ["Mega"] = 129.94, ["Mega|Fly"] = 27486.69, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 410.97, ["Ride"] = 370.9, ["Fly|Ride"] = 441.23, ["Neon"] = 1857.82, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1680, ["Mega|Fly|Ride"] = 7272.15}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 12.79, ["Ride"] = 27.83, ["Fly|Ride"] = 107.34, ["Neon"] = 219.18, ["Neon|Fly|Ride"] = 420.04, ["Mega|Fly|Ride"] = 914.19}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 6.06, ["Fly"] = 40.69, ["Ride"] = 20.65, ["Fly|Ride"] = 39.38, ["Neon"] = 51.18, ["Neon|Fly"] = 90.61, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 123.38, ["Mega|Ride"] = 254.49, ["Mega|Fly|Ride"] = 390.96}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 78.07, ["Fly"] = 77.44, ["Ride"] = 81.72, ["Fly|Ride"] = 143.63, ["Neon|Ride"] = 385.75, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 2058.94, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 2013.42}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 15.45, ["Ride"] = 30.92, ["Fly|Ride"] = 75.22, ["Neon"] = 151.2, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 160.79, ["Mega"] = 696.69, ["Mega|Ride"] = 781.38, ["Mega|Fly|Ride"] = 483}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 182.43, ["Fly"] = 348.23, ["Ride"] = 190.32, ["Fly|Ride"] = 264.89, ["Neon"] = 812.8, ["Neon|Ride"] = 735, ["Neon|Fly|Ride"] = 988.3, ["Mega"] = 6176.8, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2869.13}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 27.56}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 4.6, ["Fly"] = 29.4, ["Ride"] = 24.94, ["Fly|Ride"] = 49.89, ["Neon"] = 27.74, ["Neon|Fly"] = 68.99, ["Neon|Ride"] = 51.49, ["Neon|Fly|Ride"] = 152.37, ["Mega"] = 234.94, ["Mega|Fly"] = 343.86, ["Mega|Ride"] = 274.37, ["Mega|Fly|Ride"] = 274.88}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 1050, ["Fly"] = 2625, ["Ride"] = 1181.25, ["Fly|Ride"] = 1263.17, ["Neon"] = 7158.38, ["Neon|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 4003.13, ["Mega|Ride"] = 52250.94, ["Mega|Fly|Ride"] = 21139.02}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 11.53, ["Fly"] = 65.63, ["Ride"] = 32.8, ["Fly|Ride"] = 65.63, ["Neon"] = 77.23, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 102.96, ["Neon|Fly|Ride"] = 218.27, ["Mega"] = 533.28, ["Mega|Ride"] = 673.29, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 157.5, ["Ride"] = 168, ["Fly|Ride"] = 278.69, ["Neon"] = 810.21, ["Neon|Ride"] = 616.77, ["Neon|Fly|Ride"] = 1018.15, ["Mega|Ride"] = 2923.7, ["Mega|Fly|Ride"] = 2741.48}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 40.69}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 18.38, ["Fly"] = 68.84, ["Ride"] = 52.28, ["Fly|Ride"] = 138.06, ["Neon"] = 82.38, ["Neon|Ride"] = 155.6, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 686.66, ["Mega|Fly|Ride"] = 728.04}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 116.82, ["Ride"] = 412.42, ["Neon"] = 727.84, ["Neon|Ride"] = 509.6, ["Neon|Fly|Ride"] = 699.02, ["Mega|Fly|Ride"] = 2443.96}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 105, ["Ride"] = 152.25, ["Fly|Ride"] = 246.75, ["Neon"] = 389.45, ["Neon|Ride"] = 364.88, ["Neon|Fly|Ride"] = 576.19, ["Mega"] = 1544.21, ["Mega|Ride"] = 1509.37, ["Mega|Fly|Ride"] = 1923.05}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 41.83}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 52.46, ["Fly"] = 59.16, ["Ride"] = 54.93, ["Fly|Ride"] = 81.35, ["Neon|Ride"] = 478.4, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 4117.87, ["Mega|Fly|Ride"] = 1548.96}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 7.23, ["Fly"] = 55.67, ["Ride"] = 73.24, ["Fly|Ride"] = 131.25, ["Neon"] = 39.22, ["Neon|Ride"] = 123.65, ["Neon|Fly|Ride"] = 329.44, ["Mega"] = 131.25, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 274.93, ["Mega|Fly|Ride"] = 409.5}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 420, ["Fly"] = 426.57, ["Ride"] = 372.71, ["Fly|Ride"] = 419.99, ["Neon|Ride"] = 1750.1, ["Neon|Fly|Ride"] = 1500.57, ["Mega|Fly|Ride"] = 6298.95}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 97.12, ["Fly"] = 138.06, ["Ride"] = 104.99, ["Fly|Ride"] = 170.63, ["Neon"] = 446.25, ["Neon|Ride"] = 533.28, ["Neon|Fly|Ride"] = 530.19, ["Mega|Ride"] = 2457.34, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3718.09, ["Ride"] = 3433.5, ["Fly|Ride"] = 3673.69, ["Neon|Fly|Ride"] = 14411.48}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 41.98, ["Fly"] = 110.25, ["Ride"] = 46.87, ["Fly|Ride"] = 96.79, ["Neon"] = 393.75, ["Neon|Ride"] = 272.9, ["Neon|Fly|Ride"] = 343.86, ["Mega|Ride"] = 1181.84, ["Mega|Fly|Ride"] = 1373.32}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 68.25, ["Ride"] = 78.75, ["Fly|Ride"] = 195.57, ["Neon"] = 579.42, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 446.25, ["Mega"] = 2745.6, ["Mega|Fly|Ride"] = 2321.93}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 31.16, ["Fly"] = 61.85, ["Ride"] = 58.77, ["Fly|Ride"] = 136.5, ["Neon"] = 217.14, ["Neon|Ride"] = 152.37, ["Neon|Fly|Ride"] = 217.41, ["Mega"] = 2625, ["Mega|Ride"] = 673.29, ["Mega|Fly|Ride"] = 586.69}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 9.31}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 45.35, ["Fly"] = 393.75, ["Ride"] = 47.25, ["Fly|Ride"] = 71.61, ["Neon"] = 328.13, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1493.63}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 42.86}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 199.94, ["Ride"] = 210, ["Fly|Ride"] = 275.42, ["Neon|Ride"] = 1373.32, ["Neon|Fly|Ride"] = 928.92, ["Mega|Fly|Ride"] = 4953.83}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 934.5, ["Ride"] = 938.44, ["Fly|Ride"] = 1140.48, ["Neon|Ride"] = 3561.21, ["Neon|Fly|Ride"] = 3018.75, ["Mega|Fly|Ride"] = 15441.97}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 7.88}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 26.25, ["Fly"] = 40.68, ["Ride"] = 39.1, ["Fly|Ride"] = 74.13, ["Neon"] = 183.26, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 190.31, ["Mega|Ride"] = 656.15, ["Mega|Fly|Ride"] = 875.51}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 11.82}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 6306.6, ["Fly|Ride"] = 4722.38, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 40252.97}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 13.13, ["Fly"] = 20.63, ["Ride"] = 21, ["Fly|Ride"] = 59.06, ["Neon"] = 98.23, ["Neon|Ride"] = 120.74, ["Neon|Fly|Ride"] = 217.14, ["Mega"] = 645.49, ["Mega|Ride"] = 608.44, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 11.82, ["Fly"] = 41.24, ["Ride"] = 30.92, ["Fly|Ride"] = 110.17, ["Neon"] = 93.7, ["Neon|Ride"] = 132.7, ["Neon|Fly|Ride"] = 231, ["Mega"] = 1033.43, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 686.41}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 94.82, ["Fly"] = 263, ["Ride"] = 55.65, ["Fly|Ride"] = 89.25, ["Neon|Fly|Ride"] = 961.53, ["Mega"] = 4117.87}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 10.5, ["Ride"] = 26.25, ["Fly|Ride"] = 107.08, ["Neon"] = 82.38, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 501.37, ["Mega"] = 1373.32, ["Mega|Ride"] = 501.42, ["Mega|Fly|Ride"] = 619.97}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1968.64, ["Fly"] = 1837.5, ["Ride"] = 1754.16, ["Fly|Ride"] = 1909.69, ["Neon|Fly|Ride"] = 3888.11, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 29400, ["Fly"] = 26250, ["Ride"] = 34341.76, ["Fly|Ride"] = 23100, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 65201.11, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183750}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 15.75, ["Fly"] = 393.74, ["Ride"] = 52.5, ["Fly|Ride"] = 89.93, ["Neon"] = 253.25, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 96.79, ["Mega"] = 962.57, ["Mega|Ride"] = 682.5, ["Mega|Fly|Ride"] = 819.16}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.62, ["Fly"] = 73.21, ["Ride"] = 45.23, ["Fly|Ride"] = 205.91, ["Neon"] = 20.61, ["Neon|Fly"] = 134.4, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 118.01, ["Mega"] = 129.24, ["Mega|Ride"] = 140.13, ["Mega|Fly|Ride"] = 338.63}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 22.3}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 10.5, ["Ride"] = 36.75, ["Fly|Ride"] = 124.66, ["Neon"] = 55.6, ["Neon|Ride"] = 125.32, ["Neon|Fly|Ride"] = 463.21, ["Mega"] = 210, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 720.34, ["Ride"] = 735, ["Fly|Ride"] = 787.03, ["Neon|Ride"] = 2902.83, ["Neon|Fly|Ride"] = 2322.27, ["Mega|Fly|Ride"] = 8510.59}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 932.86, ["Fly"] = 962.07, ["Ride"] = 904.32, ["Fly|Ride"] = 944.99, ["Neon"] = 4117.87, ["Neon|Fly|Ride"] = 2978.07, ["Mega|Fly|Ride"] = 11254.11}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 15.75, ["Fly"] = 116.21, ["Ride"] = 41.22, ["Fly|Ride"] = 65.63, ["Neon"] = 92.68, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 205.91, ["Mega"] = 1030.12, ["Mega|Ride"] = 685.13, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 27.17}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 72.19, ["Fly"] = 93.19, ["Ride"] = 76.06, ["Fly|Ride"] = 105.7, ["Neon|Ride"] = 382.98, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 2015.7, ["Mega|Fly|Ride"] = 1664.25}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 68.25, ["Ride"] = 65.07, ["Fly|Ride"] = 228.38, ["Neon"] = 356.21, ["Neon|Ride"] = 391.21, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 2074.61, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.94, ["Fly"] = 41.22, ["Ride"] = 19.69, ["Fly|Ride"] = 51.32, ["Neon"] = 32.82, ["Neon|Fly"] = 525, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 108.94, ["Mega"] = 315, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 103.68, ["Fly"] = 106.32, ["Ride"] = 116.94, ["Fly|Ride"] = 190.89, ["Neon"] = 806.09, ["Neon|Ride"] = 398.42, ["Neon|Fly|Ride"] = 347.82, ["Mega|Fly|Ride"] = 1411.26}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.93, ["Ride"] = 58.15, ["Fly|Ride"] = 109.16, ["Neon"] = 53.82, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 210, ["Mega|Fly"] = 274.88, ["Mega|Ride"] = 336.65, ["Mega|Fly|Ride"] = 496.33}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 15.75, ["Fly"] = 41.11, ["Ride"] = 31.38, ["Fly|Ride"] = 82.38, ["Neon"] = 109.16, ["Neon|Ride"] = 109.19, ["Neon|Fly|Ride"] = 176.05, ["Mega"] = 727.84, ["Mega|Fly|Ride"] = 753.59}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 23.63, ["Ride"] = 74.72, ["Fly|Ride"] = 156.19, ["Neon"] = 262.54, ["Neon|Ride"] = 686.66, ["Mega"] = 694.25, ["Mega|Ride"] = 774.48, ["Mega|Fly|Ride"] = 864.76}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 16.46, ["Fly"] = 124.8, ["Ride"] = 35.04, ["Fly|Ride"] = 72.19, ["Neon"] = 91.88, ["Neon|Ride"] = 109.16, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 714.47, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 7007.34, ["Ride"] = 6332.82, ["Fly|Ride"] = 6279.11, ["Neon"] = 30883.93, ["Neon|Fly|Ride"] = 27316.84}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 247.33, ["Fly"] = 258.58, ["Ride"] = 229.69, ["Fly|Ride"] = 249.79, ["Neon|Fly|Ride"] = 559.46, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 31.49, ["Fly"] = 131.73, ["Ride"] = 82.14, ["Fly|Ride"] = 146.36, ["Neon"] = 90.57, ["Neon|Fly"] = 204.87, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 233.63, ["Mega"] = 380.62, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 480.59}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.63, ["Fly"] = 85.98, ["Ride"] = 23.63, ["Fly|Ride"] = 96.79, ["Neon"] = 23.03, ["Neon|Ride"] = 55.6, ["Neon|Fly|Ride"] = 187.38, ["Mega"] = 262.5, ["Mega|Ride"] = 187.69}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 39.38, ["Fly"] = 5266.03, ["Ride"] = 83.81, ["Fly|Ride"] = 193.59, ["Neon"] = 179.49, ["Neon|Fly"] = 236.25, ["Neon|Ride"] = 201.71, ["Neon|Fly|Ride"] = 316.07, ["Mega"] = 414.41, ["Mega|Ride"] = 592.65, ["Mega|Fly|Ride"] = 584.73}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 13991.25, ["Ride"] = 13125, ["Fly|Ride"] = 12258.75, ["Neon|Fly|Ride"] = 27562.5}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 128.62, ["Ride"] = 164.06, ["Fly|Ride"] = 262.5, ["Neon"] = 1373.32, ["Neon|Ride"] = 853.13, ["Neon|Fly|Ride"] = 1378.13, ["Mega|Fly|Ride"] = 4254.24}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 60.38, ["Fly"] = 101.88, ["Ride"] = 59.07, ["Fly|Ride"] = 86.63, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 407.82, ["Mega|Fly|Ride"] = 2519.21}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 10.5, ["Fly"] = 28.53, ["Ride"] = 24.55, ["Fly|Ride"] = 59.77, ["Neon"] = 85.32, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 229.69, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 341.25, ["Fly"] = 824.2, ["Ride"] = 413.44, ["Fly|Ride"] = 465.06, ["Neon"] = 1639.32, ["Neon|Ride"] = 1647.16, ["Neon|Fly|Ride"] = 1509.38, ["Mega|Ride"] = 4593.75, ["Mega|Fly|Ride"] = 5011.13}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.56, ["Ride"] = 35.44, ["Fly|Ride"] = 138.06, ["Neon"] = 24.94, ["Neon|Ride"] = 123.55, ["Neon|Fly|Ride"] = 217.14, ["Mega"] = 129.94, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 210, ["Fly"] = 263.72, ["Ride"] = 228.73, ["Fly|Ride"] = 264.75, ["Neon"] = 757.08, ["Neon|Ride"] = 687.93, ["Neon|Fly|Ride"] = 928.92, ["Mega|Fly|Ride"] = 3561.21}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 9.19, ["Fly"] = 15.75, ["Ride"] = 17.07, ["Fly|Ride"] = 34.7, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 786.19, ["Mega|Fly|Ride"] = 686.44}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 13.96}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 65.61, ["Ride"] = 86.63, ["Fly|Ride"] = 279.57, ["Neon"] = 410.78, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 1132.43, ["Mega|Ride"] = 1235.37, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 13.13, ["Fly"] = 102.03, ["Ride"] = 41.22, ["Fly|Ride"] = 86.63, ["Neon"] = 96.79, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 220.5, ["Mega"] = 513.72, ["Mega|Ride"] = 547.7, ["Mega|Fly|Ride"] = 546}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 19.68}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 44.58, ["Fly"] = 131.25, ["Ride"] = 65.63, ["Fly|Ride"] = 274.88, ["Neon"] = 237.57, ["Neon|Ride"] = 258.54, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 916.23, ["Mega|Ride"] = 928.92, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 4.6, ["Ride"] = 29.23, ["Fly|Ride"] = 132.39, ["Neon"] = 22.32, ["Neon|Ride"] = 104.52, ["Neon|Fly|Ride"] = 240.91, ["Mega"] = 135.18, ["Mega|Fly|Ride"] = 356.49}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 13.13, ["Fly"] = 47.24, ["Ride"] = 31.95, ["Fly|Ride"] = 65.63, ["Neon|Ride"] = 135.91, ["Neon|Fly|Ride"] = 267.07, ["Mega|Ride"] = 546.66, ["Mega|Fly|Ride"] = 802.99}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 363.83, ["Ride"] = 384.23, ["Fly|Ride"] = 346.5, ["Neon|Fly|Ride"] = 2608.68, ["Mega|Fly|Ride"] = 8644.29}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 42, ["Fly"] = 55.65, ["Ride"] = 53.82, ["Fly|Ride"] = 103.68, ["Neon"] = 184.64, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 233.71, ["Mega"] = 712.41, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 741.57}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 45.93, ["Fly"] = 109.01, ["Ride"] = 72.19, ["Fly|Ride"] = 137.96, ["Neon"] = 411.8, ["Neon|Ride"] = 220.75, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1264.2}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 28.48, ["Fly"] = 84.23, ["Ride"] = 64.97, ["Fly|Ride"] = 144.78, ["Neon"] = 111.57, ["Neon|Ride"] = 152.37, ["Neon|Fly|Ride"] = 205.91, ["Mega"] = 393.75, ["Mega|Ride"] = 396.38, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 26249.99, ["Ride"] = 13273.32, ["Fly|Ride"] = 8090.25, ["Neon|Fly|Ride"] = 13650, ["Mega|Fly|Ride"] = 39373.95}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1509.38, ["Ride"] = 1443.65, ["Fly|Ride"] = 1522.5, ["Neon"] = 5491.18, ["Neon|Fly|Ride"] = 4199.99, ["Mega|Fly|Ride"] = 14962.5}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 525, ["Ride"] = 505.32, ["Fly|Ride"] = 620.37, ["Neon"] = 2270, ["Neon|Fly|Ride"] = 2264.83, ["Mega|Fly|Ride"] = 6431.25}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 13.13, ["Fly"] = 23.63, ["Ride"] = 19.69, ["Fly|Ride"] = 51.49, ["Neon"] = 110.17, ["Neon|Ride"] = 82.38, ["Neon|Fly|Ride"] = 137.96, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 7.76, ["Fly"] = 78.74, ["Ride"] = 30.76, ["Fly|Ride"] = 123.55, ["Neon"] = 28.09, ["Neon|Ride"] = 67.96, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 156.85, ["Mega|Ride"] = 178.89, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 48.45, ["Fly"] = 68.25, ["Ride"] = 54.46, ["Fly|Ride"] = 105, ["Neon"] = 274.88, ["Neon|Ride"] = 193.59, ["Neon|Fly|Ride"] = 169.41, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 2.62, ["Fly"] = 23.12, ["Ride"] = 17.07, ["Fly|Ride"] = 44.27, ["Neon"] = 23.71, ["Neon|Fly"] = 91.87, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 360.32, ["Mega|Ride"] = 206.07, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 315, ["Fly"] = 320.25, ["Ride"] = 223.13, ["Fly|Ride"] = 373.32, ["Neon"] = 1004.41, ["Neon|Ride"] = 1332.15, ["Neon|Fly|Ride"] = 1169.44}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 39.35, ["Fly"] = 60.09, ["Ride"] = 40.2, ["Fly|Ride"] = 76.19, ["Neon"] = 204.75, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 229.69, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 12.38, ["Fly"] = 26.56, ["Ride"] = 19.49, ["Fly|Ride"] = 43.29, ["Neon"] = 68.99, ["Neon|Fly"] = 132.39, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 1575, ["Mega|Ride"] = 875.51, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 392.44, ["Fly"] = 787.5, ["Ride"] = 435.74, ["Fly|Ride"] = 645.49, ["Neon|Ride"] = 2778.54, ["Neon|Fly|Ride"] = 2786.73, ["Mega|Fly|Ride"] = 8619.19}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1148.33, ["Fly"] = 1394.3, ["Ride"] = 1154.99, ["Fly|Ride"] = 1311.78, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13716.15}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 110.28, ["Fly"] = 128.63, ["Ride"] = 99.75, ["Fly|Ride"] = 111.63, ["Neon"] = 514.75, ["Neon|Ride"] = 585.46, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 3871.81}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 136.5, ["Fly"] = 179.32, ["Ride"] = 182.72, ["Fly|Ride"] = 247.27, ["Neon"] = 556.5, ["Neon|Ride"] = 667.1, ["Neon|Fly|Ride"] = 604.99, ["Mega|Ride"] = 8603.44, ["Mega|Fly|Ride"] = 2477.87}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 24.75, ["Ride"] = 65.62, ["Fly|Ride"] = 275.09, ["Neon"] = 232.74, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 385.08, ["Mega"] = 656.25, ["Mega|Ride"] = 1857.82, ["Mega|Fly|Ride"] = 794.46}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 128.63, ["Ride"] = 273, ["Fly|Ride"] = 411.8, ["Neon|Fly|Ride"] = 1300.48, ["Mega|Fly|Ride"] = 3293.07}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2042.65, ["Ride"] = 2483.25, ["Fly|Ride"] = 2472.58, ["Neon|Fly|Ride"] = 8235.73, ["Mega|Fly|Ride"] = 24767.9}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 61.92, ["Ride"] = 65.63, ["Fly|Ride"] = 196.87, ["Neon"] = 350.03, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 343.87, ["Mega"] = 1923.05, ["Mega|Ride"] = 2264.83, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 656.25, ["Fly"] = 797.62, ["Ride"] = 642.7, ["Fly|Ride"] = 656.24, ["Neon|Ride"] = 1539.68, ["Neon|Fly|Ride"] = 1168.13, ["Mega|Fly|Ride"] = 3107.9}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 42, ["Fly"] = 64.32, ["Ride"] = 52.5, ["Fly|Ride"] = 84.44, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 359.97, ["Neon|Fly|Ride"] = 231, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 2.5, ["Fly"] = 31.55, ["Ride"] = 20.44, ["Fly|Ride"] = 47.25, ["Neon"] = 29.87, ["Neon|Fly"] = 92.9, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 141.09, ["Mega|Fly"] = 249.26, ["Mega|Ride"] = 185.13, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 35.05, ["Ride"] = 105, ["Fly|Ride"] = 252, ["Neon"] = 259.88, ["Neon|Ride"] = 455.74, ["Neon|Fly|Ride"] = 620.06, ["Mega"] = 821.54, ["Mega|Ride"] = 1373.32, ["Mega|Fly|Ride"] = 824.2}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 656.25, ["Fly"] = 1016.68, ["Ride"] = 721.88, ["Fly|Ride"] = 771.75, ["Neon|Ride"] = 2431.43, ["Neon|Fly|Ride"] = 2131.54, ["Mega|Fly|Ride"] = 8801.63}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 577.5, ["Ride"] = 598.5, ["Fly|Ride"] = 859.69, ["Neon"] = 5147.33, ["Neon|Fly|Ride"] = 3639.17, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 15.48, ["Fly"] = 32.82, ["Ride"] = 22.32, ["Fly|Ride"] = 39.38, ["Neon"] = 205.91, ["Neon|Ride"] = 82.38, ["Neon|Fly|Ride"] = 168.84, ["Mega"] = 786.19, ["Mega|Fly|Ride"] = 712.41}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 10.5, ["Ride"] = 22.16, ["Fly|Ride"] = 64.93, ["Neon"] = 72.02, ["Neon|Fly"] = 82.38, ["Neon|Ride"] = 91.74, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 961.53, ["Mega|Ride"] = 440.63, ["Mega|Fly|Ride"] = 378.67}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 4.09, ["Ride"] = 27.83, ["Fly|Ride"] = 111.57, ["Neon"] = 21, ["Neon|Fly"] = 310.04, ["Neon|Ride"] = 53.36, ["Neon|Fly|Ride"] = 152.37, ["Mega"] = 157.68, ["Mega|Ride"] = 244.13, ["Mega|Fly|Ride"] = 302.54}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 43.78, ["Fly"] = 76.28, ["Ride"] = 55.65, ["Fly|Ride"] = 110.17, ["Neon"] = 288.26, ["Neon|Ride"] = 216.56, ["Neon|Fly|Ride"] = 231, ["Mega|Ride"] = 1050.07, ["Mega|Fly|Ride"] = 944.9}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 65.63, ["Ride"] = 103.69, ["Fly|Ride"] = 449.61, ["Neon"] = 415.63, ["Neon|Ride"] = 492.1, ["Neon|Fly|Ride"] = 411.8, ["Mega"] = 1544.21, ["Mega|Ride"] = 1544.21, ["Mega|Fly|Ride"] = 1324.44}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 14.44, ["Fly"] = 54.55, ["Ride"] = 39.16, ["Fly|Ride"] = 78.75, ["Neon"] = 72.19, ["Neon|Ride"] = 108.92, ["Neon|Fly|Ride"] = 200.75, ["Mega"] = 343.86, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 38.24, ["Fly"] = 56.01, ["Ride"] = 47.25, ["Fly|Ride"] = 78.75, ["Neon"] = 549.75, ["Neon|Ride"] = 256.62, ["Neon|Fly|Ride"] = 269.07, ["Mega"] = 2100, ["Mega|Ride"] = 961.53, ["Mega|Fly|Ride"] = 787.4}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 2.63, ["Fly"] = 23.71, ["Ride"] = 19.68, ["Fly|Ride"] = 40.67, ["Neon"] = 26.25, ["Neon|Ride"] = 34.86, ["Neon|Fly|Ride"] = 91.71, ["Mega"] = 525, ["Mega|Ride"] = 274.88, ["Mega|Fly|Ride"] = 316.07}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.19, ["Fly"] = 30.86, ["Ride"] = 30.92, ["Fly|Ride"] = 81.38, ["Neon"] = 27.57, ["Neon|Fly"] = 152.12, ["Neon|Ride"] = 73.41, ["Neon|Fly|Ride"] = 164.73, ["Mega"] = 205.91, ["Mega|Ride"] = 357.24, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 44.63, ["Fly"] = 65.62, ["Ride"] = 51.17, ["Fly|Ride"] = 88.31, ["Neon"] = 274.88, ["Neon|Ride"] = 186.51, ["Neon|Fly|Ride"] = 267.75, ["Mega|Fly|Ride"] = 926.56}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1569.02, ["Fly"] = 1548.75, ["Ride"] = 1509.38, ["Fly|Ride"] = 1522.5, ["Neon|Fly"] = 4934.82, ["Neon|Ride"] = 4639.81, ["Neon|Fly|Ride"] = 3732.75, ["Mega|Fly|Ride"] = 16470.41}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 523.69, ["Fly"] = 548.34, ["Ride"] = 482.61, ["Fly|Ride"] = 547.7, ["Neon|Ride"] = 2608.68, ["Neon|Fly|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 9603.39}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 241.5, ["Fly"] = 370.9, ["Ride"] = 275.63, ["Fly|Ride"] = 328.13, ["Neon"] = 1510.24, ["Neon|Ride"] = 1579.15, ["Neon|Fly|Ride"] = 1441.27, ["Mega|Fly|Ride"] = 6561.82}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 41.99}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 26.24, ["Ride"] = 41.85, ["Fly|Ride"] = 96.79, ["Neon"] = 329.78, ["Neon|Fly"] = 411.8, ["Neon|Ride"] = 343.86, ["Neon|Fly|Ride"] = 1968.75, ["Mega"] = 926.54, ["Mega|Ride"] = 961.53, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 41219.52, ["Fly"] = 20998.69, ["Ride"] = 34781.25, ["Fly|Ride"] = 17587.5, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 390.57, ["Fly"] = 854.44, ["Ride"] = 367.5, ["Fly|Ride"] = 549.75, ["Neon"] = 1115.63, ["Neon|Ride"] = 1207.5, ["Neon|Fly|Ride"] = 1296.75, ["Mega"] = 6039.88, ["Mega|Fly|Ride"] = 3845.62}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 171.93, ["Fly"] = 525, ["Ride"] = 136.5, ["Fly|Ride"] = 173.7, ["Mega|Fly|Ride"] = 4116.33}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 124.34, ["Fly"] = 262.5, ["Ride"] = 118.13, ["Fly|Ride"] = 179.82, ["Neon"] = 617.7, ["Neon|Ride"] = 509.73, ["Neon|Fly|Ride"] = 549.75, ["Mega|Fly|Ride"] = 2469.7}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 17.46, ["Fly"] = 94.5, ["Ride"] = 31.38, ["Fly|Ride"] = 102.54, ["Neon"] = 274.88, ["Neon|Ride"] = 137.96, ["Neon|Fly|Ride"] = 204.87, ["Mega"] = 685.64, ["Mega|Ride"] = 525}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4863.92, ["Ride"] = 4945.14, ["Fly|Ride"] = 3806.25, ["Neon|Ride"] = 17844.74, ["Neon|Fly|Ride"] = 17569.88}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 27.84, ["Fly"] = 33.71, ["Ride"] = 35.72, ["Fly|Ride"] = 53.82, ["Neon"] = 337.32, ["Neon|Ride"] = 232.23, ["Neon|Fly|Ride"] = 171.86, ["Mega"] = 1098.45, ["Mega|Fly|Ride"] = 859.69}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 39.34, ["Fly"] = 138.1, ["Ride"] = 42, ["Fly|Ride"] = 110.25, ["Neon|Ride"] = 381.94, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 1548.96, ["Mega|Fly|Ride"] = 1509.21}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 629.99, ["Fly"] = 918.75, ["Ride"] = 752.85, ["Fly|Ride"] = 826.88, ["Neon"] = 2058.94, ["Neon|Ride"] = 1640.63, ["Neon|Fly|Ride"] = 1706.25, ["Mega|Ride"] = 7454.36, ["Mega|Fly|Ride"] = 5775}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 14.44, ["Fly"] = 24.52, ["Ride"] = 23.63, ["Fly|Ride"] = 48.57, ["Neon"] = 124.68, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 151.26, ["Mega|Ride"] = 583.73, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 12.93, ["Fly"] = 88.64, ["Ride"] = 34.12, ["Fly|Ride"] = 464.46, ["Neon"] = 80.06, ["Neon|Ride"] = 143.07, ["Neon|Fly|Ride"] = 249.38, ["Mega|Ride"] = 521.95, ["Mega|Fly|Ride"] = 549.75}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 101.33, ["Ride"] = 115.5, ["Fly|Ride"] = 262.5, ["Neon"] = 534.31, ["Neon|Ride"] = 525.35, ["Neon|Fly|Ride"] = 604.31, ["Mega|Ride"] = 2745.6, ["Mega|Fly|Ride"] = 2058.94}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 20.63, ["Fly"] = 111.54, ["Ride"] = 84.55, ["Fly|Ride"] = 156.93, ["Neon"] = 85.32, ["Neon|Fly"] = 129.73, ["Neon|Ride"] = 137.96, ["Neon|Fly|Ride"] = 254.49, ["Mega"] = 273, ["Mega|Fly"] = 737.34, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3881.84, ["Fly"] = 5047.11, ["Ride"] = 3937.49, ["Fly|Ride"] = 3675, ["Neon"] = 11667.96, ["Neon|Ride"] = 11497.06, ["Neon|Fly|Ride"] = 8953.49, ["Mega"] = 61767.84, ["Mega|Fly|Ride"] = 34215.09}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 36.74, ["Ride"] = 59.07, ["Fly|Ride"] = 129.73, ["Neon"] = 139.64, ["Neon|Ride"] = 205.91, ["Neon|Fly|Ride"] = 273.86, ["Mega|Ride"] = 1028.45, ["Mega|Fly|Ride"] = 1208.15}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 5891.82, ["Fly"] = 7875, ["Ride"] = 7692.75, ["Fly|Ride"] = 5775, ["Neon|Fly|Ride"] = 16047.22, ["Mega|Fly|Ride"] = 68109.95}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.63, ["Fly"] = 20.63, ["Ride"] = 17.07, ["Fly|Ride"] = 30.9, ["Neon"] = 19.69, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 45.48, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 449.37, ["Mega|Ride"] = 192.52, ["Mega|Fly|Ride"] = 303.71}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 19.62, ["Fly"] = 28.87, ["Ride"] = 26.56, ["Fly|Ride"] = 55.65, ["Neon"] = 110.17, ["Neon|Ride"] = 163.7, ["Neon|Fly|Ride"] = 179.15, ["Mega|Fly|Ride"] = 928.92}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.67}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 16.5, ["Ride"] = 39.37, ["Fly|Ride"] = 116.03, ["Neon"] = 142.08, ["Neon|Ride"] = 124.26, ["Neon|Fly|Ride"] = 601.22, ["Mega"] = 775.85, ["Mega|Ride"] = 961.53, ["Mega|Fly|Ride"] = 748.13}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 27.84, ["Fly"] = 190.37, ["Ride"] = 40.2, ["Fly|Ride"] = 138.06, ["Neon"] = 182.44, ["Neon|Ride"] = 185.88, ["Neon|Fly|Ride"] = 310.04, ["Mega"] = 840, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 13.13, ["Fly"] = 21.53, ["Ride"] = 22.32, ["Fly|Ride"] = 41.2, ["Neon"] = 89.58, ["Neon|Ride"] = 114.29, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 786.19, ["Mega|Ride"] = 579.42, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8923.97}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2715.57}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 21.71}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 171.08, ["Fly"] = 174.57, ["Ride"] = 174.57, ["Fly|Ride"] = 183.74, ["Neon|Fly|Ride"] = 1029.48}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 18.38, ["Fly"] = 123.64, ["Ride"] = 44.16, ["Fly|Ride"] = 111.57, ["Neon"] = 82.38, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 204.87, ["Mega|Ride"] = 928.92, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 10.48}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.57, ["Ride"] = 29.22, ["Fly|Ride"] = 68.99, ["Neon"] = 49.43, ["Neon|Ride"] = 68.99, ["Mega|Fly|Ride"] = 823.28}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2966.25}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 152.16, ["Fly"] = 282.3, ["Ride"] = 196.88, ["Fly|Ride"] = 479.75, ["Neon"] = 701.37, ["Neon|Ride"] = 846.83, ["Neon|Fly|Ride"] = 755.64, ["Mega|Ride"] = 3013.25, ["Mega|Fly|Ride"] = 3019.34}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 1374.69, ["Ride"] = 196.87, ["Fly|Ride"] = 211.32, ["Neon"] = 607.35, ["Neon|Ride"] = 619.84, ["Neon|Fly|Ride"] = 1435.35, ["Mega|Ride"] = 2745.6, ["Mega|Fly|Ride"] = 2745.6}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 168, ["Fly"] = 186.38, ["Ride"] = 196.88, ["Fly|Ride"] = 236.25, ["Neon"] = 897.75, ["Neon|Fly"] = 958.46, ["Neon|Ride"] = 840, ["Neon|Fly|Ride"] = 813.75, ["Mega|Fly|Ride"] = 3138.71}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1640.52, ["Fly"] = 2472.58, ["Ride"] = 1574.99, ["Fly|Ride"] = 1677.25, ["Neon"] = 6812.37, ["Neon|Ride"] = 5866.92, ["Neon|Fly|Ride"] = 4265.63, ["Mega|Fly|Ride"] = 30883.93}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 15.59, ["Fly"] = 80.39, ["Ride"] = 39.41, ["Fly|Ride"] = 93.77, ["Neon"] = 155.47, ["Neon|Ride"] = 205.91, ["Neon|Fly|Ride"] = 322.88, ["Mega"] = 822.55, ["Mega|Ride"] = 892.56, ["Mega|Fly|Ride"] = 1081.98}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 786.19, ["Fly"] = 2100, ["Ride"] = 678.43, ["Fly|Ride"] = 886.02, ["Neon|Fly|Ride"] = 3980.95}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 36.73}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 14.43, ["Ride"] = 35.44, ["Fly|Ride"] = 681.8, ["Neon"] = 98.44, ["Neon|Ride"] = 123.53, ["Neon|Fly|Ride"] = 273.86, ["Mega"] = 459.38, ["Mega|Ride"] = 496.98, ["Mega|Fly|Ride"] = 549.94}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 7.68, ["Fly"] = 48.44, ["Ride"] = 26.48, ["Fly|Ride"] = 94.81, ["Neon"] = 52.5, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 118.46, ["Mega|Ride"] = 205.91, ["Mega|Fly|Ride"] = 620.06}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 57.06}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 23.71, ["Fly"] = 108.92, ["Ride"] = 31.28, ["Fly|Ride"] = 55.6, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 192.52, ["Mega"] = 918.75, ["Mega|Ride"] = 1238.94, ["Mega|Fly|Ride"] = 823.58}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 101.1, ["Fly"] = 39.38, ["Ride"] = 32.82, ["Fly|Ride"] = 60.75, ["Neon|Ride"] = 218.31, ["Neon|Fly|Ride"] = 303.71, ["Mega"] = 821.54, ["Mega|Ride"] = 1741.7, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6197.58, ["Fly"] = 10954.13, ["Ride"] = 4987.5, ["Fly|Ride"] = 4882.38, ["Neon|Fly|Ride"] = 10482.31, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 7.76, ["Fly"] = 46.4, ["Ride"] = 35.34, ["Fly|Ride"] = 88.06, ["Neon"] = 65.63, ["Neon|Ride"] = 77.44, ["Mega"] = 520.2, ["Mega|Ride"] = 512.08, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 27.57}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 99.75, ["Fly"] = 155.71, ["Ride"] = 138.06, ["Fly|Ride"] = 144.38, ["Neon"] = 485.63, ["Neon|Ride"] = 517.13, ["Neon|Fly|Ride"] = 511.88, ["Mega|Fly|Ride"] = 1850.37}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 64.32, ["Fly"] = 96.48, ["Ride"] = 81.38, ["Fly|Ride"] = 152.25, ["Neon"] = 339.74, ["Neon|Ride"] = 282.19, ["Neon|Fly|Ride"] = 463.32, ["Mega"] = 2322.27, ["Mega|Ride"] = 2779.56, ["Mega|Fly|Ride"] = 1440.23}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 23.71, ["Fly"] = 70.45, ["Ride"] = 31.38, ["Fly|Ride"] = 45.94, ["Neon"] = 196.88, ["Neon|Ride"] = 164.73, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 736.08, ["Mega|Fly|Ride"] = 656.23}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 3.94, ["Fly"] = 59.77, ["Ride"] = 27.57, ["Fly|Ride"] = 82.38, ["Neon"] = 27.57, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 124.68, ["Mega"] = 157.5, ["Mega|Fly"] = 6863.46, ["Mega|Ride"] = 217.67, ["Mega|Fly|Ride"] = 297.94}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 11.2, ["Fly"] = 138.1, ["Ride"] = 26.12, ["Fly|Ride"] = 96.87, ["Neon"] = 92.68, ["Neon|Ride"] = 117.37, ["Neon|Fly|Ride"] = 146.32, ["Mega"] = 485.92, ["Mega|Ride"] = 509.6, ["Mega|Fly|Ride"] = 561.75}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 26.25, ["Fly"] = 27.84, ["Ride"] = 24.64, ["Fly|Ride"] = 55.38, ["Neon"] = 131.25, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 131.25, ["Mega|Fly|Ride"] = 480.38}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 206.07}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 18.38, ["Ride"] = 96.86, ["Neon"] = 177.19, ["Mega"] = 525, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 629.43}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 206.12, ["Fly"] = 263.72, ["Ride"] = 443.63, ["Neon"] = 1098.45}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 39.38, ["Fly"] = 212, ["Ride"] = 100.65, ["Fly|Ride"] = 170.63, ["Neon"] = 249.36, ["Neon|Ride"] = 382.87, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 1304.35, ["Mega|Ride"] = 2144.63, ["Mega|Fly|Ride"] = 1223.78}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 917.44, ["Fly"] = 1152.97, ["Ride"] = 897.75, ["Fly|Ride"] = 918.75, ["Neon|Ride"] = 3157.38, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 11025}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 262.5, ["Fly"] = 464.78, ["Ride"] = 328.13, ["Fly|Ride"] = 393.73, ["Neon"] = 1181.25, ["Neon|Ride"] = 2013.42, ["Neon|Fly|Ride"] = 1921, ["Mega"] = 8132.25, ["Mega|Fly|Ride"] = 5773.69}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 55.13}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 3.29}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 14.44, ["Fly"] = 27.76, ["Ride"] = 18.19, ["Fly|Ride"] = 52.5, ["Neon"] = 78.73, ["Neon|Fly"] = 116.12, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 166.69, ["Mega"] = 437.26, ["Mega|Ride"] = 685.64, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 288.73, ["Fly"] = 762.36, ["Ride"] = 310.54, ["Fly|Ride"] = 387.21, ["Neon"] = 961.53, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 982.09, ["Mega|Ride"] = 3294.3, ["Mega|Fly|Ride"] = 2756.25}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 27.57}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 107.19, ["Fly"] = 265.88, ["Ride"] = 210, ["Fly|Ride"] = 312.15, ["Neon"] = 784.88, ["Neon|Fly"] = 1647.16, ["Neon|Ride"] = 820.32, ["Neon|Fly|Ride"] = 1029.48, ["Mega"] = 3088.41, ["Mega|Ride"] = 11711.19, ["Mega|Fly|Ride"] = 2572.5}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 135, ["Fly"] = 192.67, ["Ride"] = 131.25, ["Fly|Ride"] = 157.5, ["Neon"] = 673.29, ["Neon|Ride"] = 1005.38, ["Neon|Fly|Ride"] = 926.54}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 5.25, ["Ride"] = 27.83, ["Fly|Ride"] = 73.17, ["Neon"] = 30.19, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 264.75, ["Mega|Ride"] = 220.5, ["Mega|Fly|Ride"] = 802.99}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 15.48, ["Fly"] = 63, ["Ride"] = 29.29, ["Fly|Ride"] = 76.27, ["Neon"] = 177.19, ["Neon|Ride"] = 110.17, ["Neon|Fly|Ride"] = 258.2, ["Mega|Ride"] = 800.94, ["Mega|Fly|Ride"] = 577.31}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 18.37, ["Fly"] = 102.31, ["Ride"] = 46.28, ["Fly|Ride"] = 128.84, ["Neon"] = 137.82, ["Neon|Ride"] = 130.87, ["Neon|Fly|Ride"] = 185.33, ["Mega"] = 462.24, ["Mega|Ride"] = 478.84, ["Mega|Fly|Ride"] = 685.82}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 4.66, ["Fly"] = 78.75, ["Ride"] = 49.87, ["Fly|Ride"] = 170.41, ["Neon"] = 23.72, ["Neon|Fly"] = 232.23, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 155.27, ["Mega"] = 153.55, ["Mega|Ride"] = 182.44, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 241.5, ["Ride"] = 301.88, ["Fly|Ride"] = 262.5, ["Neon"] = 1592.59, ["Neon|Ride"] = 1456.07, ["Neon|Fly|Ride"] = 1286.38, ["Mega|Fly|Ride"] = 5213.33}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 95.82, ["Fly"] = 1050, ["Ride"] = 179.38, ["Fly|Ride"] = 362.39, ["Neon"] = 686.66, ["Neon|Ride"] = 630, ["Neon|Fly|Ride"] = 785.29, ["Mega"] = 2625, ["Mega|Ride"] = 2663.24, ["Mega|Fly|Ride"] = 2506.12}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 62.76, ["Fly"] = 167.45, ["Ride"] = 69.04, ["Fly|Ride"] = 185.33, ["Neon"] = 357.24, ["Neon|Ride"] = 406.66, ["Neon|Fly|Ride"] = 477.53, ["Mega|Fly|Ride"] = 1509.67}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 11.81, ["Ride"] = 57.75, ["Fly|Ride"] = 247.27, ["Neon|Ride"] = 589.87, ["Neon|Fly|Ride"] = 480.78, ["Mega|Ride"] = 617.7, ["Mega|Fly|Ride"] = 1646.54}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 15.6, ["Fly"] = 75.63, ["Ride"] = 40.68, ["Fly|Ride"] = 105, ["Neon"] = 77.44, ["Neon|Fly"] = 205.91, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 192.57, ["Mega"] = 346.5, ["Mega|Fly"] = 525, ["Mega|Ride"] = 295.32, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 2.63, ["Fly"] = 47.4, ["Ride"] = 18.18, ["Fly|Ride"] = 96.87, ["Neon"] = 19.38, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 130.71, ["Mega"] = 129.94, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 216.46}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 1077.09, ["Fly"] = 1082.72, ["Ride"] = 866.25, ["Fly|Ride"] = 872.82, ["Neon"] = 3042.18, ["Neon|Fly"] = 3406.78, ["Neon|Ride"] = 2852.62, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 7376.25}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 357, ["Ride"] = 393.75, ["Fly|Ride"] = 522.38, ["Neon|Ride"] = 2745.6, ["Neon|Fly|Ride"] = 1922.33, ["Mega"] = 10294.65, ["Mega|Fly|Ride"] = 8824.61}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 87.43, ["Fly"] = 138.1, ["Ride"] = 103.69, ["Fly|Ride"] = 183.26, ["Neon"] = 343.86, ["Neon|Ride"] = 288.26, ["Neon|Fly|Ride"] = 406.66, ["Mega"] = 1579.15, ["Mega|Ride"] = 2136.5, ["Mega|Fly|Ride"] = 1693.88}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 273, ["Ride"] = 299.81, ["Fly|Ride"] = 308.26, ["Neon|Fly|Ride"] = 1370.15, ["Mega"] = 10294.65, ["Mega|Fly|Ride"] = 4941.44}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 17.07, ["Fly"] = 138.1, ["Ride"] = 32.31, ["Fly|Ride"] = 71.5, ["Neon"] = 169.32, ["Neon|Ride"] = 102.96, ["Neon|Fly|Ride"] = 229.68, ["Mega|Fly|Ride"] = 774.48}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 220.88, ["Ride"] = 278.64, ["Fly|Ride"] = 547.84, ["Neon"] = 859.62, ["Neon|Ride"] = 880.21, ["Neon|Fly|Ride"] = 913.82, ["Mega"] = 4097.57, ["Mega|Ride"] = 4255.82, ["Mega|Fly|Ride"] = 3845.06}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 53.82, ["Fly"] = 76.13, ["Ride"] = 62.43, ["Fly|Ride"] = 122.14, ["Neon|Ride"] = 574.77, ["Neon|Fly|Ride"] = 549.75, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1674.75, ["Ride"] = 1671.08, ["Fly|Ride"] = 1647.16, ["Neon|Ride"] = 10838.02, ["Neon|Fly|Ride"] = 4391.71, ["Mega"] = 49414.28, ["Mega|Fly|Ride"] = 21816.51}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 18.37, ["Fly"] = 64.94, ["Ride"] = 38.07, ["Fly|Ride"] = 91.8, ["Neon"] = 61.07, ["Neon|Fly"] = 179.45, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 233.71, ["Mega"] = 290.22, ["Mega|Fly"] = 561.75, ["Mega|Ride"] = 279.57, ["Mega|Fly|Ride"] = 423.51}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 36.39, ["Fly"] = 119.1, ["Ride"] = 82.69, ["Fly|Ride"] = 157.5, ["Neon"] = 262.5, ["Neon|Ride"] = 279, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 819.47, ["Mega|Ride"] = 1007.86, ["Mega|Fly|Ride"] = 823.58}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 82.69, ["Fly"] = 91.85, ["Ride"] = 91.88, ["Fly|Ride"] = 103.91, ["Neon|Ride"] = 454, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3433.6, ["Fly"] = 1312.5, ["Ride"] = 2316.57, ["Fly|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 5573.45, ["Mega|Fly|Ride"] = 23222.64}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 480.77, ["Fly"] = 822.13, ["Ride"] = 596.51, ["Fly|Ride"] = 687.19, ["Neon"] = 2169.01, ["Neon|Fly|Ride"] = 2710.1, ["Mega|Fly|Ride"] = 13931.52}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 85.31, ["Ride"] = 152.25, ["Fly|Ride"] = 206.07, ["Neon"] = 444.29, ["Neon|Fly"] = 617.7, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 630.38, ["Mega"] = 4117.87, ["Mega|Ride"] = 2608.68, ["Mega|Fly|Ride"] = 2058.94}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 8.25, ["Fly"] = 41.24, ["Ride"] = 27.57, ["Fly|Ride"] = 52.5, ["Neon"] = 72.08, ["Neon|Fly"] = 137.96, ["Neon|Ride"] = 93.56, ["Neon|Fly|Ride"] = 196.87, ["Mega|Ride"] = 747.53, ["Mega|Fly|Ride"] = 1234.34}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 52.57, ["Ride"] = 48.43, ["Fly|Ride"] = 102.96, ["Neon"] = 204.75, ["Neon|Fly"] = 411.8, ["Neon|Ride"] = 177.19, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 1337.3, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 787.24, ["Ride"] = 820.32, ["Fly|Ride"] = 785.53, ["Neon"] = 3018.41, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2508.42, ["Mega|Fly|Ride"] = 15094.55}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 787.49}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 5250, ["Ride"] = 5576.2, ["Fly|Ride"] = 4423.13, ["Neon"] = 42000, ["Neon|Ride"] = 29505.48, ["Neon|Fly|Ride"] = 21684.65, ["Mega|Fly|Ride"] = 87815.51}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 181.13, ["Fly"] = 406.82, ["Ride"] = 247.27, ["Fly|Ride"] = 367.5, ["Neon"] = 1246.88, ["Neon|Fly|Ride"] = 2058.94, ["Mega"] = 5765.01, ["Mega|Fly|Ride"] = 5900.76}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 83.6, ["Ride"] = 97.96, ["Fly|Ride"] = 336, ["Neon"] = 411.8, ["Neon|Ride"] = 590.92, ["Neon|Fly|Ride"] = 1235.37, ["Mega|Fly|Ride"] = 2099.99}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 15.45, ["Fly"] = 96.87, ["Ride"] = 36.19, ["Fly|Ride"] = 107.63, ["Neon"] = 147, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 645.49, ["Mega|Ride"] = 617.7, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 19.42, ["Fly"] = 39.38, ["Ride"] = 26.97, ["Fly|Ride"] = 49.88, ["Neon"] = 202.67, ["Neon|Fly"] = 274.88, ["Neon|Ride"] = 274.88, ["Neon|Fly|Ride"] = 137.96, ["Mega"] = 1312.5, ["Mega|Ride"] = 1587.45, ["Mega|Fly|Ride"] = 2181.66}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 16.88, ["Fly"] = 275.15, ["Ride"] = 37.19, ["Fly|Ride"] = 131.25, ["Neon"] = 105, ["Neon|Ride"] = 155.6, ["Neon|Fly|Ride"] = 181.56, ["Mega"] = 549.94, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.94, ["Fly"] = 21, ["Ride"] = 19.69, ["Fly|Ride"] = 57.75, ["Neon"] = 22.32, ["Neon|Fly"] = 339.74, ["Neon|Ride"] = 46.47, ["Neon|Fly|Ride"] = 185.79, ["Mega"] = 210, ["Mega|Ride"] = 218.27, ["Mega|Fly|Ride"] = 357}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 26.25, ["Ride"] = 49.47, ["Fly|Ride"] = 183.75, ["Neon"] = 247.09, ["Neon|Fly"] = 823.58, ["Neon|Ride"] = 155.6, ["Neon|Fly|Ride"] = 306.8, ["Mega"] = 657.84, ["Mega|Ride"] = 1239, ["Mega|Fly|Ride"] = 944.2}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 313.63, ["Fly"] = 436.83, ["Ride"] = 361.07, ["Fly|Ride"] = 415.08, ["Neon"] = 1050, ["Neon|Fly"] = 1457.74, ["Neon|Ride"] = 1178.57, ["Neon|Fly|Ride"] = 1098.45, ["Mega"] = 7875, ["Mega|Fly"] = 4322.74, ["Mega|Ride"] = 3845.06, ["Mega|Fly|Ride"] = 4255.82}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 15.75, ["Fly|Ride"] = 45.31, ["Neon"] = 18.46, ["Neon|Ride"] = 31.67, ["Neon|Fly|Ride"] = 69.35, ["Mega"] = 823.58, ["Mega|Ride"] = 205.91, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 32.48, ["Fly"] = 88.25, ["Ride"] = 81.72, ["Fly|Ride"] = 123.44, ["Neon"] = 173.25, ["Neon|Fly"] = 387.83, ["Neon|Ride"] = 203.43, ["Neon|Fly|Ride"] = 247.86, ["Mega"] = 510.56, ["Mega|Fly"] = 823.58, ["Mega|Ride"] = 544.69, ["Mega|Fly|Ride"] = 609.51}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 764.1, ["Fly"] = 952.77, ["Ride"] = 767.81, ["Fly|Ride"] = 810.84, ["Neon|Ride"] = 1603.87, ["Neon|Fly|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 4079.25}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 32.41, ["Fly"] = 91.88, ["Ride"] = 43.66, ["Fly|Ride"] = 72.11, ["Neon|Ride"] = 173.25, ["Neon|Fly|Ride"] = 273.86, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 343.88, ["Fly"] = 341.25, ["Ride"] = 288.75, ["Fly|Ride"] = 342.06, ["Neon|Fly|Ride"] = 1232.86, ["Mega|Fly|Ride"] = 6860.89}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 145.67, ["Fly"] = 205.08, ["Ride"] = 154.21, ["Fly|Ride"] = 168.91, ["Neon"] = 627.29, ["Neon|Ride"] = 714.47, ["Neon|Fly|Ride"] = 663.03, ["Mega"] = 3872.39, ["Mega|Fly|Ride"] = 3149.99}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 649.69, ["Ride"] = 656.25, ["Fly|Ride"] = 742.65, ["Neon|Ride"] = 2594.26, ["Neon|Fly|Ride"] = 2417.2, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 19.69, ["Ride"] = 40.6, ["Fly|Ride"] = 77.81, ["Neon"] = 78.07, ["Neon|Fly"] = 278.69, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 267.07, ["Mega"] = 306.8, ["Mega|Ride"] = 310.04, ["Mega|Fly|Ride"] = 490.04}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4084.49, ["Ride"] = 3018.75, ["Fly|Ride"] = 2992.49, ["Neon"] = 13160.28, ["Neon|Fly|Ride"] = 6299.99, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 110.25, ["Fly"] = 131.25, ["Ride"] = 126, ["Fly|Ride"] = 161.44, ["Neon"] = 380.63, ["Neon|Ride"] = 518.86, ["Neon|Fly|Ride"] = 419.47, ["Mega|Fly|Ride"] = 2402.79}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.5, ["Fly"] = 20.55, ["Ride"] = 18.4, ["Fly|Ride"] = 42.88, ["Neon"] = 21, ["Neon|Fly"] = 82.38, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 137.96, ["Mega"] = 196.88, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.81, ["Ride"] = 27.83, ["Fly|Ride"] = 58.07, ["Neon"] = 19.69, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 210, ["Mega"] = 161.44, ["Mega|Ride"] = 199.48, ["Mega|Fly|Ride"] = 238.56}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 55.02, ["Fly"] = 152.5, ["Ride"] = 39.38, ["Fly|Ride"] = 55.13, ["Neon"] = 271.72, ["Neon|Ride"] = 288.26, ["Neon|Fly|Ride"] = 236.25, ["Mega|Fly|Ride"] = 1128.75}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 984.38, ["Ride"] = 1085.88, ["Fly|Ride"] = 1115.63}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6221.24, ["Ride"] = 6970.24, ["Fly|Ride"] = 6299.99}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 20.45, ["Fly"] = 36.03, ["Ride"] = 24.69, ["Fly|Ride"] = 52.61, ["Neon|Ride"] = 144.8, ["Neon|Fly|Ride"] = 170.9, ["Mega"] = 2428.13, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 15.59, ["Fly"] = 45.94, ["Ride"] = 32.93, ["Fly|Ride"] = 68.43, ["Neon"] = 94.4, ["Neon|Ride"] = 91.28, ["Neon|Fly|Ride"] = 150.93, ["Mega"] = 898.74, ["Mega|Ride"] = 611.93, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 69.74, ["Fly"] = 96.89, ["Ride"] = 58.47, ["Fly|Ride"] = 104.99, ["Neon"] = 459.37, ["Neon|Ride"] = 329.44, ["Neon|Fly|Ride"] = 301.88, ["Mega|Ride"] = 1791.28, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 236.25, ["Fly"] = 310.24, ["Ride"] = 216.57, ["Fly|Ride"] = 310.2, ["Neon|Ride"] = 977.79, ["Neon|Fly|Ride"] = 1076.96, ["Mega"] = 10294.65, ["Mega|Fly|Ride"] = 3540.34}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.94, ["Ride"] = 31.95, ["Fly|Ride"] = 86.63, ["Neon"] = 20.79, ["Neon|Fly"] = 656.24, ["Neon|Ride"] = 92.68, ["Mega"] = 158.82, ["Mega|Ride"] = 152.37, ["Mega|Fly|Ride"] = 310.04}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 198.19, ["Fly"] = 267.21, ["Ride"] = 234.68, ["Fly|Ride"] = 328.13, ["Neon"] = 924.47, ["Neon|Ride"] = 908.02, ["Neon|Fly|Ride"] = 787.5, ["Mega|Fly|Ride"] = 3872.39}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.12, ["Fly"] = 26.25, ["Ride"] = 16.8, ["Fly|Ride"] = 49.47, ["Neon"] = 19.69, ["Neon|Fly"] = 123.03, ["Neon|Ride"] = 31.37, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 256.62, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 247.11}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 203.44, ["Fly"] = 244.01, ["Ride"] = 246.29, ["Fly|Ride"] = 241.5, ["Neon|Ride"] = 1029.48, ["Neon|Fly|Ride"] = 1114.71, ["Mega"] = 10294.65, ["Mega|Ride"] = 4117.87, ["Mega|Fly|Ride"] = 4091.11}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 11.82, ["Fly"] = 70.4, ["Ride"] = 24.94, ["Fly|Ride"] = 61.83, ["Neon"] = 56.56, ["Neon|Fly"] = 294.94, ["Neon|Ride"] = 97.81, ["Neon|Fly|Ride"] = 194.91, ["Mega"] = 514.39, ["Mega|Ride"] = 576.52, ["Mega|Fly|Ride"] = 449.5}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.61, ["Ride"] = 20.99, ["Fly|Ride"] = 86.63, ["Neon"] = 7.87, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 44.26, ["Neon|Fly|Ride"] = 176.77, ["Mega"] = 78.75, ["Mega|Ride"] = 99.38, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.84, ["Neon|Ride"] = 31.92, ["Mega"] = 24.73, ["Mega|Ride"] = 136.4}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.82, ["Fly"] = 52.48, ["Ride"] = 26.25, ["Fly|Ride"] = 206.57, ["Neon"] = 5.81, ["Neon|Ride"] = 48.41, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 68.16, ["Mega|Fly"] = 154818.39, ["Mega|Ride"] = 96.89, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 66.92, ["Fly"] = 137.09, ["Ride"] = 104.39, ["Fly|Ride"] = 175.32, ["Neon"] = 365.47, ["Neon|Ride"] = 378.11, ["Neon|Fly|Ride"] = 309.74, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 33.54, ["Ride"] = 15.65, ["Fly|Ride"] = 93.37, ["Neon"] = 8.26, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 129.94, ["Mega|Ride"] = 122.75, ["Mega|Fly|Ride"] = 257.24}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 26.25, ["Ride"] = 1050, ["Neon"] = 126.65, ["Neon|Ride"] = 248.07, ["Mega"] = 443.63, ["Mega|Ride"] = 580.57, ["Mega|Fly|Ride"] = 645.49}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.1, ["Neon|Ride"] = 44.5, ["Mega"] = 15.33, ["Mega|Ride"] = 55.6, ["Mega|Fly|Ride"] = 85.32}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 69.05, ["Ride"] = 14.6, ["Fly|Ride"] = 33.44, ["Neon"] = 2.1, ["Neon|Fly"] = 14.43, ["Neon|Ride"] = 11.36, ["Neon|Fly|Ride"] = 77.17, ["Mega"] = 10.5, ["Mega|Fly"] = 39.38, ["Mega|Ride"] = 17.53, ["Mega|Fly|Ride"] = 39.38}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Ride"] = 15.46, ["Fly|Ride"] = 35.43, ["Neon"] = 2.63, ["Neon|Fly"] = 20.61, ["Neon|Ride"] = 15.79, ["Neon|Fly|Ride"] = 40.69, ["Mega"] = 28.23, ["Mega|Fly"] = 155.32, ["Mega|Ride"] = 27.87, ["Mega|Fly|Ride"] = 95.82}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 33.64, ["Neon"] = 2.63, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 82.38, ["Mega"] = 13.13, ["Mega|Ride"] = 146.32}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Ride"] = 18.38, ["Fly|Ride"] = 107.62, ["Neon"] = 3.94, ["Neon|Fly"] = 137.85, ["Neon|Ride"] = 20.99, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 26.25, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 180.08}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Fly|Ride"] = 203.85, ["Mega"] = 76.37, ["Mega|Ride"] = 96.79, ["Mega|Fly|Ride"] = 154.71}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 3.9, ["Fly"] = 65.24, ["Ride"] = 15.46, ["Fly|Ride"] = 61.79, ["Neon"] = 10.29, ["Neon|Fly"] = 59.06, ["Neon|Ride"] = 24.19, ["Neon|Fly|Ride"] = 74.46, ["Mega"] = 91.87, ["Mega|Fly"] = 186.24, ["Mega|Ride"] = 81.37, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 47.4, ["Neon"] = 2.1, ["Neon|Ride"] = 78.66, ["Neon|Fly|Ride"] = 157.37, ["Mega"] = 14.42, ["Mega|Ride"] = 39.5, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 3.92, ["Fly|Ride"] = 524.99, ["Neon"] = 15.74, ["Mega"] = 137.96, ["Mega|Fly"] = 315, ["Mega|Ride"] = 343.86}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Neon"] = 9.54, ["Neon|Ride"] = 26.75, ["Mega"] = 103.69, ["Mega|Fly|Ride"] = 537.62}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 3.93, ["Neon|Fly"] = 27.81, ["Neon|Ride"] = 26.77, ["Neon|Fly|Ride"] = 137.96, ["Mega"] = 20.16, ["Mega|Ride"] = 54.51, ["Mega|Fly|Ride"] = 131.14}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 10.5, ["Fly|Ride"] = 30.15, ["Neon"] = 2.1, ["Neon|Fly"] = 33.67, ["Neon|Ride"] = 14.81, ["Neon|Fly|Ride"] = 30.92, ["Mega"] = 14.03, ["Mega|Fly"] = 36.75, ["Mega|Ride"] = 23.63, ["Mega|Fly|Ride"] = 59.72}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 3.94, ["Fly"] = 72.19, ["Ride"] = 229.68, ["Neon"] = 31.49, ["Neon|Ride"] = 140.95}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Fly"] = 23.63, ["Ride"] = 18.38, ["Fly|Ride"] = 82.38, ["Neon"] = 2.61, ["Neon|Ride"] = 31.92, ["Neon|Fly|Ride"] = 105, ["Mega"] = 26.24, ["Mega|Fly"] = 78.75, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 126}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 3.94, ["Neon"] = 11.82, ["Neon|Fly|Ride"] = 137.96, ["Mega"] = 82.51, ["Mega|Ride"] = 137.96, ["Mega|Fly|Ride"] = 238.87}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.62, ["Fly"] = 262.49, ["Ride"] = 32.82, ["Fly|Ride"] = 187.38, ["Neon"] = 15.31, ["Neon|Fly|Ride"] = 137.96, ["Mega"] = 73.12, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 188.99}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 39.29, ["Ride"] = 15.46, ["Fly|Ride"] = 26.17, ["Neon"] = 2.1, ["Neon|Fly"] = 15.45, ["Neon|Ride"] = 12.79, ["Neon|Fly|Ride"] = 26.24, ["Mega"] = 15.48, ["Mega|Fly"] = 23.69, ["Mega|Ride"] = 22.09, ["Mega|Fly|Ride"] = 48.57}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 27.46, ["Ride"] = 19.69, ["Fly|Ride"] = 136.18, ["Neon"] = 14.33, ["Neon|Ride"] = 111.48, ["Neon|Fly|Ride"] = 100.91, ["Mega"] = 78.75, ["Mega|Ride"] = 154.16, ["Mega|Fly|Ride"] = 274.78}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 6.2, ["Fly"] = 41.22, ["Ride"] = 32.82, ["Fly|Ride"] = 58.46, ["Neon"] = 72.19, ["Neon|Ride"] = 48.09, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 205.91, ["Mega|Ride"] = 288.46, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 15.48, ["Ride"] = 12.9, ["Fly|Ride"] = 26.17, ["Neon"] = 3.92, ["Neon|Fly"] = 23.62, ["Neon|Ride"] = 15.45, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 26.78, ["Mega|Fly"] = 1312.5, ["Mega|Ride"] = 118.4, ["Mega|Fly|Ride"] = 98.43}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 3.72, ["Fly"] = 172.1, ["Ride"] = 60.38, ["Neon"] = 7.76, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 38.66, ["Mega|Fly"] = 164.73, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 262.47}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.63, ["Ride"] = 26.81, ["Fly|Ride"] = 82.38, ["Neon"] = 5.15, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 310.04, ["Mega"] = 34.84, ["Mega|Ride"] = 137.96, ["Mega|Fly|Ride"] = 155.6}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.72, ["Neon"] = 2.39, ["Neon|Fly"] = 41.03, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 96.79, ["Mega"] = 14.43, ["Mega|Ride"] = 34.13, ["Mega|Fly|Ride"] = 121.45}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 96.87, ["Ride"] = 19.69, ["Fly|Ride"] = 42, ["Neon"] = 7.87, ["Neon|Fly"] = 52.02, ["Neon|Ride"] = 19.07, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 78.33, ["Mega|Ride"] = 81.38}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 68.25, ["Neon"] = 3.85, ["Neon|Ride"] = 43.31, ["Mega"] = 39.38, ["Mega|Fly|Ride"] = 249.37}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.35, ["Fly"] = 28.77, ["Ride"] = 17.55, ["Fly|Ride"] = 47.25, ["Neon"] = 6.56, ["Neon|Fly"] = 79.98, ["Neon|Ride"] = 19.84, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 91.87, ["Mega|Ride"] = 109.16, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 8.21, ["Ride"] = 39.38, ["Neon"] = 36.21, ["Mega"] = 133.88, ["Mega|Ride"] = 205.92, ["Mega|Fly|Ride"] = 823.28}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 25.77, ["Ride"] = 16.4, ["Fly|Ride"] = 82.38, ["Neon"] = 17.07, ["Neon|Fly"] = 104.16, ["Neon|Ride"] = 26.76, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 157.5, ["Mega|Ride"] = 145.48, ["Mega|Fly|Ride"] = 333.56}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 3.83, ["Fly"] = 22.45, ["Ride"] = 19.69, ["Fly|Ride"] = 36.75, ["Neon"] = 15.65, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 223.13, ["Mega|Fly"] = 410.78, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 195.53}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 110.93, ["Fly|Ride"] = 137.7, ["Neon"] = 55.1, ["Mega"] = 152.37, ["Mega|Ride"] = 176.05}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 14.44, ["Ride"] = 131.25, ["Neon"] = 115.5, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 4.2, ["Ride"] = 64.89, ["Neon"] = 41.11, ["Neon|Ride"] = 125.71, ["Mega"] = 222.38, ["Mega|Ride"] = 273.67}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 5.25, ["Ride"] = 34.97, ["Fly|Ride"] = 152.37, ["Neon"] = 41.99, ["Neon|Ride"] = 64.49, ["Mega"] = 246.06, ["Mega|Ride"] = 280.23, ["Mega|Fly|Ride"] = 355.04}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.63, ["Neon|Ride"] = 64.98, ["Mega"] = 21, ["Mega|Ride"] = 137.96, ["Mega|Fly|Ride"] = 144.09}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 47.13}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 17.06, ["Fly"] = 20.63, ["Ride"] = 23.07, ["Fly|Ride"] = 41.51, ["Neon"] = 74.81, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 102.74, ["Mega"] = 294, ["Mega|Fly"] = 329.44, ["Mega|Ride"] = 515.57, ["Mega|Fly|Ride"] = 252.94}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.54, ["Neon"] = 2.88, ["Neon|Ride"] = 26.61, ["Mega"] = 25.03, ["Mega|Fly"] = 137.96, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.41, ["Ride"] = 23.71, ["Fly|Ride"] = 275.09, ["Neon"] = 6.57, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 404.88, ["Mega"] = 34.34, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 5.25, ["Fly"] = 45.94, ["Ride"] = 19.6, ["Fly|Ride"] = 47.37, ["Neon"] = 6.95, ["Neon|Ride"] = 26.78, ["Neon|Fly|Ride"] = 115.88, ["Mega"] = 125.23, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 161.65}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.83, ["Fly|Ride"] = 58.69, ["Neon"] = 28.87, ["Neon|Ride"] = 82.38, ["Neon|Fly|Ride"] = 192.52, ["Mega"] = 325.33, ["Mega|Ride"] = 292.38, ["Mega|Fly|Ride"] = 411.8}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 32.81, ["Neon"] = 3.66, ["Neon|Ride"] = 48.41, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 14.44, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 329.44}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 18.56, ["Ride"] = 16.05, ["Fly|Ride"] = 274524.04, ["Neon"] = 6.13, ["Neon|Fly"] = 69, ["Neon|Ride"] = 27.88, ["Neon|Fly|Ride"] = 69.35, ["Mega"] = 26.3, ["Mega|Fly"] = 143.16, ["Mega|Ride"] = 45.93, ["Mega|Fly|Ride"] = 104.89}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 27.37, ["Ride"] = 15.75, ["Fly|Ride"] = 34.13, ["Neon"] = 7.85, ["Neon|Fly"] = 68.99, ["Neon|Ride"] = 15.64, ["Neon|Fly|Ride"] = 52.48, ["Mega"] = 34.13, ["Mega|Ride"] = 51.34, ["Mega|Fly|Ride"] = 158.29}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 210, ["Ride"] = 51.18, ["Fly|Ride"] = 138.2, ["Neon"] = 3.9, ["Neon|Ride"] = 27.03, ["Neon|Fly|Ride"] = 110.17, ["Mega"] = 23.39, ["Mega|Fly"] = 102.96, ["Mega|Ride"] = 70.17, ["Mega|Fly|Ride"] = 137.96}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.72, ["Neon|Ride"] = 164.38, ["Neon|Fly|Ride"] = 122.52, ["Mega"] = 82.38, ["Mega|Fly"] = 106.45, ["Mega|Ride"] = 86.63, ["Mega|Fly|Ride"] = 199.73}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 32.43, ["Ride"] = 18.17, ["Fly|Ride"] = 77.23, ["Neon"] = 3.93, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 20.15, ["Neon|Fly|Ride"] = 76.65, ["Mega"] = 30.9, ["Mega|Fly"] = 102.96, ["Mega|Ride"] = 36.14, ["Mega|Fly|Ride"] = 118.02}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 2.37, ["Mega"] = 20.79, ["Mega|Ride"] = 124.37}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.34, ["Neon|Ride"] = 155.6, ["Neon|Fly|Ride"] = 420, ["Mega"] = 23.45, ["Mega|Ride"] = 123.15}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 16.03, ["Fly|Ride"] = 26.25, ["Neon"] = 4.02, ["Neon|Ride"] = 19.57, ["Neon|Fly|Ride"] = 136.49, ["Mega"] = 26.22, ["Mega|Ride"] = 52.6}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 18.38, ["Ride"] = 137.54, ["Neon"] = 123.55, ["Neon|Fly|Ride"] = 256.62, ["Mega"] = 546.66, ["Mega|Ride"] = 426.57, ["Mega|Fly|Ride"] = 451.5}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 5.25, ["Fly"] = 6562.5, ["Ride"] = 68.25, ["Neon"] = 36.04, ["Neon|Ride"] = 203.85, ["Mega"] = 1567.89, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 7.55, ["Fly"] = 23.63, ["Ride"] = 26.24, ["Fly|Ride"] = 410.92, ["Neon"] = 34.79, ["Mega"] = 295.25, ["Mega|Ride"] = 109.16, ["Mega|Fly|Ride"] = 365.3}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 12.55, ["Ride"] = 12.85, ["Fly|Ride"] = 23.63, ["Neon"] = 2.1, ["Neon|Fly"] = 14.58, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 14.44, ["Mega|Fly"] = 32.52, ["Mega|Ride"] = 22.29, ["Mega|Fly|Ride"] = 49.87}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 65.63, ["Neon"] = 10.31, ["Neon|Fly"] = 89.46, ["Neon|Ride"] = 31.92, ["Neon|Fly|Ride"] = 686.66, ["Mega"] = 85.31, ["Mega|Ride"] = 114.29, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.49, ["Neon"] = 2.1, ["Neon|Fly"] = 30.83, ["Neon|Ride"] = 20.69, ["Neon|Fly|Ride"] = 77.23, ["Mega"] = 15.74, ["Mega|Fly"] = 82.32, ["Mega|Fly|Ride"] = 103.68}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Ride"] = 91.8, ["Neon"] = 3.29, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 102.96, ["Mega"] = 20.22, ["Mega|Ride"] = 96.87, ["Mega|Fly|Ride"] = 152.37}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 34.08, ["Ride"] = 20.9, ["Fly|Ride"] = 45.91, ["Neon"] = 11.33, ["Neon|Ride"] = 41.2, ["Neon|Fly|Ride"] = 88.54, ["Mega"] = 183.75, ["Mega|Ride"] = 192.52, ["Mega|Fly|Ride"] = 348.35}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 205.5, ["Ride"] = 262.5, ["Fly|Ride"] = 823.58, ["Neon"] = 1050, ["Neon|Ride"] = 822.94, ["Mega"] = 8235.73, ["Mega|Fly|Ride"] = 3251.18}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 27.83, ["Neon"] = 8.52, ["Neon|Fly"] = 41.2, ["Neon|Ride"] = 68.25, ["Mega"] = 61.68, ["Mega|Ride"] = 92.9, ["Mega|Fly|Ride"] = 823.28}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 6.49, ["Fly"] = 62.39, ["Ride"] = 24.8, ["Neon"] = 20.61, ["Neon|Ride"] = 164.29, ["Neon|Fly|Ride"] = 155.47, ["Mega"] = 354.38, ["Mega|Fly|Ride"] = 398.27}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 824.4, ["Ride"] = 15.26, ["Fly|Ride"] = 30.19, ["Neon"] = 7.88, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 55.62, ["Mega"] = 49.66, ["Mega|Ride"] = 78.16, ["Mega|Fly|Ride"] = 170.9}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 19.68, ["Fly|Ride"] = 92.54, ["Neon"] = 5.25, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 95.82, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.5, ["Fly"] = 17.75, ["Ride"] = 16.45, ["Fly|Ride"] = 35.42, ["Neon"] = 22.66, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 71.1, ["Mega|Ride"] = 261.5, ["Mega|Fly|Ride"] = 411.8}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.71, ["Ride"] = 34.01, ["Fly|Ride"] = 249.58, ["Neon"] = 45.94, ["Neon|Ride"] = 128.26, ["Neon|Fly|Ride"] = 611.51, ["Mega"] = 249.38, ["Mega|Ride"] = 306.8, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.56, ["Fly"] = 19.55, ["Ride"] = 15.75, ["Fly|Ride"] = 31.19, ["Neon"] = 18.17, ["Neon|Fly"] = 68.99, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 73.5, ["Mega|Fly|Ride"] = 201.71}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 59.06, ["Fly"] = 164.9, ["Ride"] = 102.38, ["Fly|Ride"] = 150.94, ["Neon"] = 440.63, ["Neon|Fly"] = 410.82, ["Neon|Ride"] = 405.57, ["Neon|Fly|Ride"] = 398.74, ["Mega|Fly|Ride"] = 1644.57}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 196.88, ["Fly"] = 329.53, ["Ride"] = 230.85, ["Fly|Ride"] = 274.88, ["Neon"] = 928.92, ["Neon|Ride"] = 1441.27, ["Neon|Fly|Ride"] = 961.53, ["Mega"] = 10294.65, ["Mega|Fly|Ride"] = 3600.76}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 68.25, ["Fly"] = 138.1, ["Ride"] = 68.25, ["Fly|Ride"] = 133.94, ["Neon"] = 411.8, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 354.38, ["Mega|Fly|Ride"] = 1818.35}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 3.93, ["Fly"] = 26.25, ["Ride"] = 25.85, ["Fly|Ride"] = 137.96, ["Neon"] = 24.94, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 233.71, ["Mega|Ride"] = 374.06, ["Mega|Fly|Ride"] = 505.49}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 10.39, ["Fly"] = 68.93, ["Ride"] = 19.57, ["Fly|Ride"] = 89.25, ["Neon"] = 31.5, ["Neon|Ride"] = 135.91, ["Neon|Fly|Ride"] = 179.15, ["Mega"] = 329.44, ["Mega|Ride"] = 364.53, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 18.38, ["Fly|Ride"] = 40.16, ["Neon"] = 5.19, ["Neon|Fly"] = 70.85, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 87.94, ["Mega|Fly"] = 154.88, ["Mega|Ride"] = 74.13, ["Mega|Fly|Ride"] = 177.08}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 10.37, ["Fly"] = 27.84, ["Ride"] = 27.87, ["Fly|Ride"] = 300.03, ["Neon"] = 55.71, ["Neon|Ride"] = 158.82, ["Neon|Fly|Ride"] = 136.28, ["Mega"] = 915.21, ["Mega|Ride"] = 613.57, ["Mega|Fly|Ride"] = 864.94}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.1, ["Ride"] = 17.07, ["Fly|Ride"] = 55.6, ["Neon"] = 13.13, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 30.9, ["Neon|Fly|Ride"] = 103.63, ["Mega"] = 131.25, ["Mega|Ride"] = 200.79, ["Mega|Fly|Ride"] = 202.05}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.63, ["Ride"] = 23.25, ["Fly|Ride"] = 328.13, ["Neon"] = 30.9, ["Neon|Ride"] = 55.6, ["Mega"] = 207.37, ["Mega|Ride"] = 192.52, ["Mega|Fly|Ride"] = 371.98}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 34.35, ["Ride"] = 36.08, ["Neon"] = 2.1, ["Neon|Ride"] = 19.66, ["Neon|Fly|Ride"] = 47.37, ["Mega"] = 15.75, ["Mega|Ride"] = 50.46, ["Mega|Fly|Ride"] = 411.8}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 3.74, ["Fly"] = 19.59, ["Ride"] = 17.75, ["Fly|Ride"] = 39.38, ["Neon"] = 12.9, ["Neon|Fly"] = 102.96, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 68.99, ["Mega"] = 84, ["Mega|Ride"] = 107.98, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.39, ["Fly"] = 24.93, ["Ride"] = 18.5, ["Fly|Ride"] = 39.17, ["Neon"] = 24.94, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 110.17, ["Mega"] = 283.5, ["Mega|Ride"] = 205.91, ["Mega|Fly|Ride"] = 221.75}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 162.63, ["Fly"] = 232.39, ["Ride"] = 196.88, ["Fly|Ride"] = 225.75, ["Neon"] = 793.07, ["Neon|Ride"] = 749.36, ["Neon|Fly|Ride"] = 720.57, ["Mega|Fly|Ride"] = 2745.6}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.83, ["Ride"] = 30.19, ["Fly|Ride"] = 204.87, ["Neon"] = 49.38, ["Neon|Ride"] = 160.13, ["Neon|Fly|Ride"] = 376.56, ["Mega"] = 340.76, ["Mega|Ride"] = 322.81, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.63, ["Fly"] = 15.48, ["Ride"] = 17.07, ["Fly|Ride"] = 43.32, ["Neon"] = 30.17, ["Neon|Ride"] = 35.01, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 288.75, ["Mega|Ride"] = 213.94, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 17.07, ["Ride"] = 41.32, ["Fly|Ride"] = 170.63, ["Neon"] = 120.44, ["Neon|Ride"] = 148.32, ["Neon|Fly|Ride"] = 441.27, ["Mega"] = 453.14, ["Mega|Fly"] = 823.58, ["Mega|Ride"] = 469.88, ["Mega|Fly|Ride"] = 708.3}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 4.14}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 3.29, ["Ride"] = 25.57, ["Neon"] = 25.31, ["Neon|Ride"] = 274.88, ["Neon|Fly|Ride"] = 617.7, ["Mega"] = 386.06, ["Mega|Ride"] = 296.63, ["Mega|Fly|Ride"] = 821.22}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 25.58, ["Fly"] = 77.67, ["Ride"] = 28.87, ["Fly|Ride"] = 56.43, ["Neon"] = 179.15, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 162.63, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 2058.94, ["Mega|Fly|Ride"] = 1371.26}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 78.75, ["Neon"] = 3.84, ["Neon|Ride"] = 39.36, ["Neon|Fly|Ride"] = 106.24, ["Mega"] = 31.49, ["Mega|Ride"] = 68.86, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 4.19, ["Fly"] = 27.69, ["Ride"] = 26.73, ["Fly|Ride"] = 61.79, ["Neon"] = 45.34, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 232.23, ["Mega"] = 231.48, ["Mega|Fly"] = 387.83, ["Mega|Ride"] = 165.38, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 15.75, ["Fly|Ride"] = 46.11, ["Neon"] = 11.81, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 30.65, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 137.82, ["Mega|Ride"] = 138.27, ["Mega|Fly|Ride"] = 207.46}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 36.08, ["Neon"] = 3.74, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 30.9, ["Neon|Fly|Ride"] = 411.8, ["Mega"] = 30.18, ["Mega|Ride"] = 82.46, ["Mega|Fly|Ride"] = 197.68}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 28.56, ["Ride"] = 105.1, ["Neon"] = 251.21, ["Neon|Ride"] = 294.94, ["Neon|Fly|Ride"] = 581.63, ["Mega"] = 935.82, ["Mega|Ride"] = 1037.71, ["Mega|Fly|Ride"] = 833.44}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.94, ["Ride"] = 52.5, ["Fly|Ride"] = 210, ["Neon"] = 80.29, ["Mega|Ride"] = 524.99}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 8.52, ["Fly"] = 96.89, ["Ride"] = 51.52, ["Fly|Ride"] = 62.48, ["Neon"] = 62.96, ["Neon|Fly"] = 464.46, ["Neon|Ride"] = 96.79, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 575.48, ["Mega|Ride"] = 308.85, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 57.75, ["Fly"] = 433.13, ["Ride"] = 172.07, ["Fly|Ride"] = 262.44, ["Neon"] = 435.43, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 686.66, ["Mega"] = 1743.93, ["Mega|Ride"] = 2034.38, ["Mega|Fly|Ride"] = 1739.14}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 10.48, ["Fly"] = 45.94, ["Ride"] = 30.58, ["Fly|Ride"] = 63.24, ["Neon"] = 48.56, ["Neon|Ride"] = 67.59, ["Neon|Fly|Ride"] = 137.96, ["Mega"] = 209.9, ["Mega|Ride"] = 239.04, ["Mega|Fly|Ride"] = 273.76}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 70.88, ["Fly"] = 143.07, ["Ride"] = 104.19, ["Neon"] = 183.75, ["Neon|Fly"] = 498.75, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 992.66, ["Mega|Ride"] = 1017.12, ["Mega|Fly|Ride"] = 935.55}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 19.68, ["Ride"] = 55.71, ["Fly|Ride"] = 131.24, ["Neon"] = 82.69, ["Neon|Ride"] = 148.66, ["Neon|Fly|Ride"] = 263.6, ["Mega"] = 343.88, ["Mega|Fly"] = 329.44, ["Mega|Ride"] = 304.5, ["Mega|Fly|Ride"] = 400.25}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 10, ["Ride"] = 27.57, ["Fly|Ride"] = 41.56, ["Neon"] = 68.99, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 369.25, ["Mega"] = 416.96, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 18.24, ["Ride"] = 109.15, ["Fly|Ride"] = 154.76, ["Neon"] = 90.55, ["Neon|Ride"] = 129.76, ["Neon|Fly|Ride"] = 310.04, ["Mega"] = 255.2, ["Mega|Fly"] = 497.24, ["Mega|Ride"] = 303.52, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 7.23, ["Ride"] = 26.25, ["Fly|Ride"] = 136.06, ["Neon"] = 26.24, ["Neon|Ride"] = 69.56, ["Mega"] = 411.89, ["Mega|Ride"] = 299.51, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 53.55, ["Neon|Ride"] = 56.35, ["Mega"] = 17.59, ["Mega|Fly"] = 137.96, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.29, ["Ride"] = 27.26, ["Neon"] = 18.76, ["Neon|Fly"] = 123.55, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 95.71, ["Mega|Ride"] = 160.6, ["Mega|Fly|Ride"] = 261.4}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.45, ["Fly"] = 62.75, ["Neon"] = 23.63, ["Mega"] = 183.48, ["Mega|Ride"] = 137.96}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 6.19, ["Ride"] = 32.79, ["Fly|Ride"] = 114.96, ["Neon"] = 17.77, ["Neon|Ride"] = 81.35, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 199.73, ["Mega|Ride"] = 274.32, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 558.72, ["Ride"] = 576.18, ["Fly|Ride"] = 616.88, ["Neon"] = 1706.87, ["Neon|Fly"] = 1799.77, ["Neon|Ride"] = 1498.29, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 5890.5}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 7.79, ["Fly"] = 27.75, ["Ride"] = 23.25, ["Fly|Ride"] = 59.72, ["Neon"] = 26.25, ["Neon|Ride"] = 96.79, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 370.62, ["Mega|Fly|Ride"] = 482.97}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 9.09, ["Fly"] = 39.38, ["Ride"] = 26.25, ["Fly|Ride"] = 51.35, ["Neon"] = 76.12, ["Neon|Fly"] = 315, ["Neon|Ride"] = 54.58, ["Mega"] = 307.13, ["Mega|Ride"] = 303.8, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.3, ["Ride"] = 22.68, ["Fly|Ride"] = 308.85, ["Neon|Ride"] = 137.96, ["Mega"] = 253.14, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.63, ["Fly"] = 64.97, ["Ride"] = 24.35, ["Fly|Ride"] = 90.57, ["Neon"] = 9.07, ["Neon|Ride"] = 41.2, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 68.62, ["Mega|Fly"] = 170.63, ["Mega|Ride"] = 110.65, ["Mega|Fly|Ride"] = 205.91}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 69.05, ["Ride"] = 18.56, ["Neon"] = 2.1, ["Neon|Ride"] = 24.05, ["Neon|Fly|Ride"] = 73.12, ["Mega"] = 23.36, ["Mega|Ride"] = 77.44, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1107.75}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 7.62, ["Ride"] = 41.22, ["Fly|Ride"] = 69.14, ["Neon"] = 64.87, ["Neon|Ride"] = 72.18, ["Neon|Fly|Ride"] = 179.15, ["Mega"] = 398.42, ["Mega|Ride"] = 411.8, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 28.26, ["Neon"] = 5.15, ["Neon|Ride"] = 40.69, ["Mega"] = 38.75, ["Mega|Ride"] = 154.44, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 138.18, ["Ride"] = 58.49, ["Fly|Ride"] = 574.45, ["Neon"] = 10.5, ["Neon|Fly"] = 123.55, ["Neon|Ride"] = 109.78, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 152.37, ["Mega|Ride"] = 251.21, ["Mega|Fly|Ride"] = 310.04}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 459.38, ["Ride"] = 481.68, ["Fly|Ride"] = 527.12, ["Neon|Ride"] = 1311.18, ["Neon|Fly|Ride"] = 1254.88, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 6.03, ["Fly"] = 196.88, ["Fly|Ride"] = 411.8, ["Neon"] = 123.55, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 205.91, ["Mega"] = 469.45, ["Mega|Ride"] = 263.82}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 27.83, ["Fly|Ride"] = 152.37, ["Neon"] = 5.87, ["Neon|Ride"] = 35.43, ["Neon|Fly|Ride"] = 93.2, ["Mega"] = 40.68, ["Mega|Fly"] = 189, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 824.2, ["Neon"] = 3.94, ["Neon|Ride"] = 109.85, ["Neon|Fly|Ride"] = 261.5, ["Mega"] = 23.49, ["Mega|Ride"] = 113.67, ["Mega|Fly|Ride"] = 218.67}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 11.81, ["Fly"] = 107.63, ["Ride"] = 61.69, ["Fly|Ride"] = 178.5, ["Neon"] = 101.75, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 329.44, ["Mega"] = 449.37, ["Mega|Ride"] = 398.42, ["Mega|Fly|Ride"] = 595.88}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 7.88, ["Neon"] = 109.16, ["Neon|Ride"] = 123.55, ["Neon|Fly|Ride"] = 199.73, ["Mega"] = 411.8, ["Mega|Ride"] = 482.34, ["Mega|Fly|Ride"] = 1098.45}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 7.86, ["Fly|Ride"] = 137.96, ["Neon"] = 118.13, ["Neon|Ride"] = 175.35, ["Mega"] = 635.15, ["Mega|Ride"] = 959.04, ["Mega|Fly|Ride"] = 1235.37}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 12.81, ["Ride"] = 26.8, ["Neon"] = 118.13, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 205.91, ["Mega"] = 524.99, ["Mega|Ride"] = 620.06, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 313.69, ["Fly"] = 464.69, ["Ride"] = 427.56, ["Fly|Ride"] = 616.88, ["Neon"] = 1645.09, ["Neon|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 1155, ["Mega|Ride"] = 3566.09, ["Mega|Fly|Ride"] = 3845.06}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 9.33, ["Fly"] = 69.65, ["Ride"] = 23.63, ["Fly|Ride"] = 96.87, ["Neon"] = 106.01, ["Neon|Ride"] = 137.96, ["Neon|Fly|Ride"] = 158.55, ["Mega"] = 686.66, ["Mega|Ride"] = 409.74, ["Mega|Fly|Ride"] = 847.97}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.83, ["Fly|Ride"] = 78.75, ["Neon"] = 35.17, ["Neon|Ride"] = 221.82, ["Mega"] = 131.25, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 774.38}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 14.86, ["Ride"] = 43.32, ["Fly|Ride"] = 256.62, ["Neon"] = 52.49, ["Neon|Ride"] = 110.25, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 272.35, ["Mega|Fly"] = 686.66, ["Mega|Ride"] = 281.63, ["Mega|Fly|Ride"] = 342.03}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.35, ["Fly"] = 40.69, ["Ride"] = 52.5, ["Fly|Ride"] = 138.06, ["Neon"] = 6.35, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 137.96, ["Mega"] = 44.62, ["Mega|Fly"] = 105, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 38.06, ["Ride"] = 91.88, ["Fly|Ride"] = 157.5, ["Neon"] = 307.82, ["Neon|Ride"] = 357.24, ["Neon|Fly|Ride"] = 463.28, ["Mega"] = 1785.11, ["Mega|Ride"] = 1290.96, ["Mega|Fly|Ride"] = 813.74}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.62, ["Fly"] = 56.44, ["Ride"] = 28.25, ["Neon"] = 10.5, ["Neon|Fly"] = 156.97, ["Neon|Ride"] = 41.1, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 68.77, ["Mega|Ride"] = 101.07, ["Mega|Fly|Ride"] = 178.41}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 20.63, ["Ride"] = 27.83, ["Fly|Ride"] = 148.25, ["Neon"] = 3.94, ["Neon|Fly"] = 49.39, ["Neon|Ride"] = 49.53, ["Neon|Fly|Ride"] = 131.78, ["Mega"] = 40.69, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 172.65}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Fly"] = 1519.88, ["Ride"] = 27.83, ["Fly|Ride"] = 123.55, ["Neon"] = 12.97, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 78.75, ["Mega|Fly"] = 459.38, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 270.38}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 62.9, ["Ride"] = 78.74, ["Neon"] = 291.38, ["Neon|Ride"] = 509.25, ["Neon|Fly|Ride"] = 616.67, ["Mega|Ride"] = 1029.48, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 302.11, ["Ride"] = 309.74, ["Fly|Ride"] = 393.75, ["Neon"] = 1430.97, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1036.88, ["Mega"] = 6176.8, ["Mega|Fly|Ride"] = 5200.86}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 5.2, ["Fly|Ride"] = 184.25, ["Neon"] = 36.75, ["Mega"] = 103.2, ["Mega|Ride"] = 188.73, ["Mega|Fly|Ride"] = 307.82}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 3.94, ["Ride"] = 26.25, ["Neon"] = 17.43, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 137.96, ["Mega"] = 49.88, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 336.65}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.63, ["Fly"] = 30.22, ["Ride"] = 27.56, ["Fly|Ride"] = 175.03, ["Neon"] = 36.75, ["Mega|Ride"] = 341.29, ["Mega|Fly|Ride"] = 346.5}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 4.25, ["Fly"] = 58.92, ["Ride"] = 34.26, ["Neon"] = 7.77, ["Neon|Ride"] = 36.19, ["Neon|Fly|Ride"] = 137.91, ["Mega"] = 84.36, ["Mega|Fly"] = 146.21, ["Mega|Ride"] = 107.52, ["Mega|Fly|Ride"] = 236.24}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 67.93, ["Neon"] = 8.89, ["Mega"] = 36.75, ["Mega|Fly|Ride"] = 271.8}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 16.71, ["Fly|Ride"] = 41.99, ["Neon"] = 6.19, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 97.81, ["Mega"] = 44.18, ["Mega|Ride"] = 74.13, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 138.1, ["Ride"] = 20.63, ["Fly|Ride"] = 54.49, ["Neon"] = 8.97, ["Neon|Fly"] = 62.39, ["Neon|Ride"] = 31.37, ["Neon|Fly|Ride"] = 63.37, ["Mega"] = 123.55, ["Mega|Ride"] = 232.67, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 23.63, ["Ride"] = 52.42, ["Fly|Ride"] = 77.16, ["Neon"] = 179.15, ["Neon|Fly|Ride"] = 287.98, ["Mega"] = 575.48, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 78.75, ["Fly"] = 123.67, ["Ride"] = 78.75, ["Fly|Ride"] = 127.66, ["Neon"] = 411.8, ["Neon|Ride"] = 389.82, ["Neon|Fly|Ride"] = 461.96, ["Mega"] = 1470, ["Mega|Ride"] = 1509.21, ["Mega|Fly|Ride"] = 1496.85}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Fly"] = 34.88, ["Ride"] = 20.63, ["Fly|Ride"] = 131.25, ["Neon"] = 5.66, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 137.96, ["Mega"] = 38.75, ["Mega|Fly"] = 672, ["Mega|Ride"] = 65.49, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 16.5, ["Ride"] = 15.72, ["Fly|Ride"] = 36.66, ["Neon"] = 4.14, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 17.52, ["Neon|Fly|Ride"] = 55.6, ["Mega"] = 51.85, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 2.1, ["Ride"] = 73.48, ["Fly|Ride"] = 131.25, ["Neon"] = 41.2, ["Neon|Ride"] = 39.5, ["Neon|Fly|Ride"] = 273.86, ["Mega"] = 267.98, ["Mega|Ride"] = 411.8, ["Mega|Fly|Ride"] = 636.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 387.19, ["Fly"] = 393.75, ["Ride"] = 542.95, ["Fly|Ride"] = 498.75, ["Neon|Ride"] = 6562.5, ["Neon|Fly|Ride"] = 1115.63, ["Mega|Fly|Ride"] = 6811.37}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 35.05, ["Fly"] = 93.89, ["Ride"] = 52.5, ["Fly|Ride"] = 124.26, ["Neon"] = 204.38, ["Neon|Ride"] = 166.76, ["Neon|Fly|Ride"] = 305.78, ["Mega|Ride"] = 1028.45, ["Mega|Fly|Ride"] = 944.98}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 281.28, ["Neon"] = 9.17, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 169.31, ["Mega"] = 89.15, ["Mega|Ride"] = 133.62, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 205.82, ["Ride"] = 65.63, ["Fly|Ride"] = 142.7, ["Neon"] = 20.61}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 26.76, ["Fly"] = 76.26, ["Ride"] = 43.28, ["Fly|Ride"] = 82.38, ["Neon|Ride"] = 137.96, ["Neon|Fly|Ride"] = 527.63, ["Mega"] = 2470.73, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1238.94}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 106.4, ["Ride"] = 92.73, ["Fly|Ride"] = 152.5, ["Neon"] = 544.66, ["Neon|Ride"] = 469.45, ["Neon|Fly|Ride"] = 603.81, ["Mega"] = 8235.73, ["Mega|Fly|Ride"] = 1872.94}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 195.57, ["Fly"] = 308.13, ["Ride"] = 278.32, ["Fly|Ride"] = 503.95, ["Neon"] = 823.58, ["Neon|Ride"] = 741.23, ["Neon|Fly|Ride"] = 1098.45, ["Mega|Fly|Ride"] = 3413.72}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 14.44, ["Ride"] = 41.22, ["Fly|Ride"] = 150.94, ["Neon"] = 73.5, ["Neon|Ride"] = 119.17, ["Neon|Fly|Ride"] = 224.43, ["Mega"] = 383.29, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 418.24}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 27.84, ["Ride"] = 13.65, ["Fly|Ride"] = 40.63, ["Neon"] = 7.55, ["Neon|Ride"] = 21.62, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 92.68, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 165.38}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 6.19, ["Fly"] = 19.69, ["Ride"] = 19.36, ["Fly|Ride"] = 51.49, ["Neon"] = 30.42, ["Neon|Fly"] = 144.14, ["Neon|Ride"] = 39.71, ["Neon|Fly|Ride"] = 118.46, ["Mega"] = 329.44, ["Mega|Ride"] = 321.2, ["Mega|Fly|Ride"] = 410.78}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 328.13, ["Fly"] = 481.26, ["Ride"] = 326.82, ["Fly|Ride"] = 412.11, ["Neon"] = 1312.5, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1649.82, ["Mega|Fly|Ride"] = 5729.05}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 55.65, ["Neon"] = 9.19, ["Neon|Ride"] = 55.6, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 47.97, ["Mega|Ride"] = 233.71}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 5.15, ["Ride"] = 14.44, ["Fly|Ride"] = 26.25, ["Neon"] = 21.18, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 77.81, ["Mega"] = 179.15, ["Mega|Fly"] = 204.9, ["Mega|Ride"] = 185.79, ["Mega|Fly|Ride"] = 247.09}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 12.99, ["Ride"] = 117.47, ["Neon"] = 98.44, ["Neon|Fly"] = 411.8, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 387.83, ["Mega"] = 474.24, ["Mega|Ride"] = 546.66, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 127.32, ["Fly"] = 157.5, ["Ride"] = 118.9, ["Fly|Ride"] = 154.88, ["Neon|Ride"] = 696.69, ["Neon|Fly|Ride"] = 611.02, ["Mega|Fly|Ride"] = 2013.42}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 15.64, ["Fly"] = 48.44, ["Ride"] = 27.57, ["Fly|Ride"] = 59.06, ["Neon"] = 85.32, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 187.34, ["Mega"] = 632.12, ["Mega|Ride"] = 507.66, ["Mega|Fly|Ride"] = 488.38}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 49.47, ["Neon"] = 2.5, ["Neon|Ride"] = 310.04, ["Neon|Fly|Ride"] = 686.66, ["Mega"] = 20.79, ["Mega|Ride"] = 271.8, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 52.5, ["Neon"] = 2.63, ["Neon|Ride"] = 20.61, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 24.93, ["Mega|Fly"] = 87.09, ["Mega|Ride"] = 51.19, ["Mega|Fly|Ride"] = 122.52}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 10.48, ["Fly"] = 412.11, ["Ride"] = 55.13, ["Fly|Ride"] = 164.73, ["Neon"] = 38.07, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 187.69, ["Mega"] = 151.33, ["Mega|Fly"] = 274.88, ["Mega|Ride"] = 188.98, ["Mega|Fly|Ride"] = 324.16}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1446.38, ["Ride"] = 1312.5, ["Fly|Ride"] = 1291.5, ["Neon"] = 4200, ["Neon|Ride"] = 3675, ["Neon|Fly|Ride"] = 3675, ["Mega|Fly|Ride"] = 11353.13}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 420, ["Ride"] = 367.5, ["Fly|Ride"] = 518.44, ["Neon"] = 1785.11, ["Neon|Ride"] = 1640.63, ["Neon|Fly|Ride"] = 1858.85, ["Mega"] = 16471.43, ["Mega|Fly|Ride"] = 7086.19}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 330.14, ["Ride"] = 367.26, ["Fly|Ride"] = 410.82, ["Neon"] = 654.78, ["Neon|Fly"] = 1238.94, ["Neon|Ride"] = 643.1, ["Neon|Fly|Ride"] = 786.19, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 318.94, ["Fly"] = 413.22, ["Ride"] = 301.88, ["Fly|Ride"] = 420, ["Neon"] = 1070.67, ["Neon|Fly"] = 1393.37, ["Neon|Ride"] = 968.63, ["Neon|Fly|Ride"] = 1049, ["Mega|Fly|Ride"] = 4627.45}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 57.16, ["Ride"] = 18.27, ["Fly|Ride"] = 31.5, ["Neon"] = 5.79, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 82.38, ["Mega"] = 62.66, ["Mega|Ride"] = 108.86, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 357, ["Ride"] = 521.62, ["Fly|Ride"] = 577.5, ["Neon"] = 1680, ["Neon|Ride"] = 1509.38, ["Neon|Fly|Ride"] = 1968.75, ["Mega|Ride"] = 5729.05, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.6, ["Fly"] = 183.75, ["Ride"] = 112.53, ["Neon"] = 10.32, ["Neon|Ride"] = 64.87, ["Neon|Fly|Ride"] = 155.81, ["Mega"] = 74.82, ["Mega|Ride"] = 91.68, ["Mega|Fly|Ride"] = 271.69}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 26.8, ["Ride"] = 20.63, ["Fly|Ride"] = 39.38, ["Neon"] = 7.88, ["Neon|Ride"] = 52.53, ["Neon|Fly|Ride"] = 104.97, ["Mega"] = 104.9, ["Mega|Ride"] = 192.93}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 39.37, ["Mega"] = 18.38, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 33.69, ["Ride"] = 109.22, ["Fly|Ride"] = 459.38, ["Neon"] = 210, ["Neon|Ride"] = 420, ["Mega|Ride"] = 928.92}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 7746.39, ["Ride"] = 21, ["Fly|Ride"] = 60.44, ["Neon"] = 26.25, ["Neon|Ride"] = 77.81, ["Mega"] = 328.13, ["Mega|Ride"] = 303.71, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 3.94, ["Neon|Fly"] = 118.55, ["Neon|Ride"] = 35.11, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 22.2, ["Mega|Ride"] = 155.3, ["Mega|Fly|Ride"] = 114.54}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.63, ["Fly"] = 36.01, ["Ride"] = 22.68, ["Fly|Ride"] = 62.71, ["Neon"] = 7.97, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 30.9, ["Neon|Fly|Ride"] = 82.67, ["Mega"] = 78.75, ["Mega|Fly"] = 171.93, ["Mega|Ride"] = 116.58, ["Mega|Fly|Ride"] = 170.6}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 6.15, ["Fly"] = 55.67, ["Ride"] = 27.83, ["Fly|Ride"] = 70.07, ["Neon"] = 27.57, ["Neon|Fly"] = 96.79, ["Neon|Ride"] = 137.96, ["Neon|Fly|Ride"] = 246.06, ["Mega"] = 237.57, ["Mega|Ride"] = 300.51, ["Mega|Fly|Ride"] = 309.99}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 10.31, ["Ride"] = 53.82, ["Neon"] = 56.44, ["Neon|Fly|Ride"] = 263.6, ["Mega"] = 370.62, ["Mega|Ride"] = 426.15, ["Mega|Fly|Ride"] = 411.8}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 7.88, ["Fly"] = 6196.55, ["Ride"] = 26.8, ["Neon"] = 34.94, ["Neon|Ride"] = 138.18, ["Neon|Fly|Ride"] = 274.88, ["Mega"] = 439.03, ["Mega|Ride"] = 714, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 18.38, ["Fly|Ride"] = 45.94, ["Neon"] = 5.44, ["Neon|Fly"] = 27.81, ["Neon|Ride"] = 15.45, ["Mega"] = 80.49, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 184.47, ["Fly"] = 227.76, ["Ride"] = 227.7, ["Fly|Ride"] = 223.13, ["Neon|Ride"] = 2573.67, ["Neon|Fly|Ride"] = 1084.52, ["Mega"] = 8235.73, ["Mega|Fly|Ride"] = 4198.58}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 15.02, ["Ride"] = 14.44, ["Fly|Ride"] = 30.19, ["Neon"] = 6.19, ["Neon|Fly"] = 27.81, ["Neon|Ride"] = 18.27, ["Neon|Fly|Ride"] = 45.93, ["Mega"] = 31.37, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 13.9, ["Ride"] = 69.46, ["Fly|Ride"] = 183.73, ["Neon"] = 79.52, ["Neon|Ride"] = 123.27, ["Mega"] = 464.46, ["Mega|Ride"] = 398.42, ["Mega|Fly|Ride"] = 527.09}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 39.38, ["Fly"] = 210, ["Ride"] = 93.17, ["Fly|Ride"] = 167.23, ["Neon"] = 185.33, ["Neon|Ride"] = 272.88, ["Mega"] = 823.58, ["Mega|Ride"] = 851.39}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 210, ["Ride"] = 236.15, ["Fly|Ride"] = 262.5, ["Neon"] = 708.73, ["Neon|Fly"] = 1161.14, ["Neon|Ride"] = 792.7, ["Neon|Fly|Ride"] = 740.64, ["Mega|Fly|Ride"] = 3018.65}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 13.12, ["Ride"] = 37.43, ["Fly|Ride"] = 139.41, ["Neon"] = 116.34, ["Neon|Ride"] = 274.88, ["Mega"] = 287.44, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1235.37}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 119.6, ["Fly|Ride"] = 525, ["Neon"] = 131.25, ["Neon|Ride"] = 199.5, ["Neon|Fly|Ride"] = 263.55, ["Mega"] = 463.68, ["Mega|Ride"] = 549.75, ["Mega|Fly|Ride"] = 930.65}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1185.1, ["Fly"] = 1445.78, ["Ride"] = 1048.69, ["Fly|Ride"] = 1212.45, ["Neon"] = 4529.65, ["Neon|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 4404.61, ["Mega|Fly|Ride"] = 17150.66}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 6.57, ["Fly"] = 30.22, ["Ride"] = 19.55, ["Fly|Ride"] = 42, ["Neon"] = 20.56, ["Neon|Fly"] = 79.91, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 205.91, ["Mega"] = 270.77, ["Mega|Ride"] = 229.59, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 5.25, ["Fly"] = 65.63, ["Ride"] = 41.22, ["Neon"] = 30.24, ["Neon|Ride"] = 91.74, ["Mega"] = 218.28, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 238.88, ["Mega|Fly|Ride"] = 271.69}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.63, ["Fly"] = 81.42, ["Ride"] = 22.08, ["Fly|Ride"] = 69.57, ["Neon"] = 15.85, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 60.4, ["Mega"] = 90.57, ["Mega|Ride"] = 136.89, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 14.33, ["Fly"] = 55.65, ["Ride"] = 37.24, ["Fly|Ride"] = 116.12, ["Neon"] = 66.94, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 328.13, ["Mega|Ride"] = 357, ["Mega|Fly|Ride"] = 467.81}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 3.14, ["Fly"] = 21, ["Ride"] = 18.47, ["Fly|Ride"] = 28.88, ["Neon"] = 19.64, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 31.29, ["Neon|Fly|Ride"] = 88.69, ["Mega"] = 148.25, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 36.08, ["Neon"] = 9.1, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 56.25, ["Neon|Fly|Ride"] = 823.58, ["Mega"] = 105, ["Mega|Fly"] = 274.88, ["Mega|Ride"] = 185.33}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 253.25, ["Ride"] = 437.07, ["Fly|Ride"] = 549.75, ["Neon|Fly|Ride"] = 984.38}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 3.73, ["Fly"] = 25.46, ["Ride"] = 18.38, ["Fly|Ride"] = 72.19, ["Neon"] = 9.17, ["Neon|Fly"] = 41.2, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 119.84, ["Mega"] = 78.75, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 242.01}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 5.21, ["Ride"] = 27.83, ["Fly|Ride"] = 88.87, ["Neon"] = 77.42, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27, ["Mega|Ride"] = 329.44, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.29, ["Fly"] = 91.25, ["Ride"] = 26.17, ["Neon"] = 11.71, ["Neon|Ride"] = 27.81, ["Mega"] = 85.32, ["Mega|Fly"] = 137.96, ["Mega|Ride"] = 94.49, ["Mega|Fly|Ride"] = 356.9}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 308.43, ["Ride"] = 403.13, ["Fly|Ride"] = 1036.23, ["Neon"] = 852.29, ["Neon|Ride"] = 816.38, ["Neon|Fly|Ride"] = 1144.89, ["Mega"] = 4644.53, ["Mega|Ride"] = 3087.38, ["Mega|Fly|Ride"] = 2789.41}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 20.9, ["Fly"] = 57.69, ["Ride"] = 148.36, ["Fly|Ride"] = 146.21, ["Neon"] = 122.52, ["Neon|Ride"] = 179.15, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 630, ["Mega|Fly|Ride"] = 1098.45}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 18.08, ["Ride"] = 26.25, ["Fly|Ride"] = 137.96, ["Neon"] = 83.91, ["Neon|Ride"] = 123.38, ["Neon|Fly|Ride"] = 258.41, ["Mega"] = 501.36, ["Mega|Ride"] = 496.08, ["Mega|Fly|Ride"] = 451.5}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.84, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 44.18, ["Mega"] = 35.82, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 224.35}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 64.25, ["Fly"] = 87.47, ["Ride"] = 79.01, ["Fly|Ride"] = 157.49, ["Neon"] = 262.48, ["Neon|Fly"] = 303.14, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 328.1, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 18.38, ["Neon"] = 5.25, ["Neon|Ride"] = 55.6, ["Neon|Fly|Ride"] = 588, ["Mega"] = 48.88, ["Mega|Fly|Ride"] = 410.62}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 22.1, ["Fly"] = 124.34, ["Ride"] = 30.92, ["Fly|Ride"] = 71.99, ["Neon"] = 52.5, ["Neon|Ride"] = 109.16, ["Neon|Fly|Ride"] = 247.09, ["Mega"] = 274.88, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 45.94, ["Fly"] = 110.06, ["Ride"] = 79.94, ["Fly|Ride"] = 91.88, ["Neon"] = 182.6, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 377.91, ["Mega|Ride"] = 1316.7, ["Mega|Fly|Ride"] = 1134.7}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 13.85, ["Fly|Ride"] = 35.42, ["Neon"] = 2.1, ["Neon|Fly"] = 23.97, ["Neon|Ride"] = 16.49, ["Neon|Fly|Ride"] = 40.51, ["Mega"] = 18.37, ["Mega|Fly"] = 116.12, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 76.8}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.93, ["Fly"] = 32.82, ["Ride"] = 35.04, ["Fly|Ride"] = 131.25, ["Neon"] = 14, ["Neon|Ride"] = 59.72, ["Neon|Fly|Ride"] = 168, ["Mega"] = 157.5, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 15.75, ["Fly"] = 138.1, ["Ride"] = 36.75, ["Fly|Ride"] = 62.71, ["Neon"] = 140.77, ["Neon|Ride"] = 133.88, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 546.66, ["Mega|Ride"] = 551.15, ["Mega|Fly|Ride"] = 813.29}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.78, ["Neon"] = 2.6, ["Neon|Ride"] = 18.38, ["Mega"] = 20.64, ["Mega|Ride"] = 48.41, ["Mega|Fly|Ride"] = 205.83}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 14.43, ["Fly"] = 210, ["Ride"] = 55.55, ["Fly|Ride"] = 124.32, ["Neon"] = 29.87, ["Neon|Ride"] = 137.45, ["Neon|Fly|Ride"] = 185.79, ["Mega"] = 549.75, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 343.86}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 10.48, ["Fly"] = 27.83, ["Ride"] = 21, ["Fly|Ride"] = 46.86, ["Neon"] = 224.43, ["Neon|Ride"] = 118.78, ["Neon|Fly|Ride"] = 117.37, ["Mega"] = 432.39, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 434.27}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.84, ["Ride"] = 52.5, ["Neon"] = 26.25, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 68.98, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 170.63, ["Mega|Ride"] = 232.32, ["Mega|Fly|Ride"] = 371.58}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 49.48, ["Fly"] = 2061, ["Ride"] = 66.92, ["Neon"] = 47.38, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 6192.34, ["Mega"] = 295.32, ["Mega|Ride"] = 544.69, ["Mega|Fly|Ride"] = 574.77}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.58, ["Fly"] = 41.24, ["Ride"] = 20.63, ["Fly|Ride"] = 196.87, ["Neon"] = 6.45, ["Neon|Fly"] = 55.6, ["Neon|Ride"] = 26.25, ["Mega"] = 52.5, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 137.96}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 69.04, ["Neon"] = 2.62, ["Neon|Ride"] = 89.17, ["Mega"] = 30.19, ["Mega|Ride"] = 85.31, ["Mega|Fly|Ride"] = 215.3}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 37.68}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 40.68, ["Fly"] = 78.75, ["Ride"] = 70.88, ["Neon"] = 179.15, ["Neon|Ride"] = 204.53, ["Neon|Fly|Ride"] = 549.75, ["Mega"] = 1227.13, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 889.87}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Mega"] = 22.31, ["Mega|Ride"] = 164.73, ["Mega|Fly|Ride"] = 308.75}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 388.5, ["Fly"] = 562.66, ["Ride"] = 446.25, ["Fly|Ride"] = 641.82, ["Neon"] = 3018.75, ["Neon|Fly|Ride"] = 2251.08, ["Mega"] = 16471.43, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 6.55, ["Fly"] = 25.99, ["Ride"] = 39.37, ["Fly|Ride"] = 66.26, ["Neon"] = 25.1, ["Neon|Ride"] = 274.88, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 68.99, ["Mega|Fly"] = 148.25, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 549.54}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.63, ["Fly"] = 26.25, ["Ride"] = 21.24, ["Fly|Ride"] = 63, ["Neon"] = 16.21, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 162.67, ["Mega|Ride"] = 176.05, ["Mega|Fly|Ride"] = 411.9}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 14.6, ["Fly"] = 77.27, ["Ride"] = 69.71, ["Fly|Ride"] = 106.32, ["Neon"] = 64.87, ["Neon|Ride"] = 178.83, ["Mega"] = 513.72, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 571.36}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.39, ["Fly"] = 316.31, ["Ride"] = 32.48, ["Fly|Ride"] = 721.88, ["Mega"] = 255.94}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 13.95, ["Fly"] = 139.53, ["Ride"] = 105, ["Fly|Ride"] = 157.49, ["Neon"] = 52.5, ["Neon|Ride"] = 102.96, ["Neon|Fly|Ride"] = 370.62, ["Mega"] = 262.5, ["Mega|Ride"] = 400.98, ["Mega|Fly|Ride"] = 467.4}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 7.76, ["Fly"] = 104.99, ["Ride"] = 32.82, ["Fly|Ride"] = 185.33, ["Neon"] = 41.2, ["Neon|Ride"] = 100.7, ["Neon|Fly|Ride"] = 137.96, ["Mega"] = 216.56, ["Mega|Fly"] = 479.75, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 313.53}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 39.52, ["Ride"] = 15.31, ["Fly|Ride"] = 66.94, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 15.26, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 13.86, ["Mega|Fly"] = 61.79, ["Mega|Ride"] = 26.25, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 8.65, ["Fly"] = 275.15, ["Ride"] = 27.57, ["Fly|Ride"] = 48.44, ["Neon"] = 28.65, ["Neon|Ride"] = 68.99, ["Neon|Fly|Ride"] = 110.33, ["Mega"] = 194.25, ["Mega|Fly"] = 204.87, ["Mega|Ride"] = 205.91, ["Mega|Fly|Ride"] = 411.65}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 261.19, ["Fly"] = 298.86, ["Ride"] = 328.12, ["Fly|Ride"] = 421.31, ["Neon"] = 1453.62, ["Neon|Ride"] = 1404.38, ["Neon|Fly|Ride"] = 1047.38, ["Mega|Fly|Ride"] = 4211.55}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 86.63, ["Ride"] = 163.82, ["Fly|Ride"] = 294.94, ["Neon"] = 315, ["Neon|Ride"] = 380.63, ["Neon|Fly|Ride"] = 480.96, ["Mega"] = 1625.59, ["Mega|Ride"] = 1435.09, ["Mega|Fly|Ride"] = 1548.96}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 17.04, ["Ride"] = 14.44, ["Fly|Ride"] = 28.51, ["Neon"] = 15.45, ["Neon|Fly"] = 68.99, ["Neon|Ride"] = 32.96, ["Neon|Fly|Ride"] = 62.56, ["Mega"] = 137.96, ["Mega|Fly"] = 204.87, ["Mega|Ride"] = 123.55, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 22.1, ["Ride"] = 13.85, ["Fly|Ride"] = 31.5, ["Neon"] = 6.56, ["Neon|Fly"] = 39.15, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 49.87, ["Mega"] = 69.56, ["Mega|Fly"] = 344.03, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.63, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 38.07, ["Neon|Fly|Ride"] = 411.8, ["Mega"] = 137.96, ["Mega|Ride"] = 247.09, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 248.07, ["Fly"] = 420, ["Ride"] = 298.06, ["Fly|Ride"] = 375.38, ["Neon|Ride"] = 1785.11, ["Neon|Fly|Ride"] = 1301.26, ["Mega|Ride"] = 8235.73, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 3.77, ["Fly"] = 48.45, ["Ride"] = 15.65, ["Fly|Ride"] = 43.33, ["Neon"] = 21.21, ["Neon|Fly"] = 77.44, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 101, ["Mega"] = 255.94, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.83, ["Fly"] = 155.71, ["Ride"] = 98.44, ["Fly|Ride"] = 206.06, ["Neon"] = 19.57, ["Neon|Ride"] = 139.13, ["Mega"] = 247.09, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 311.85}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 5.17, ["Neon|Ride"] = 137.71, ["Mega"] = 61.79, ["Mega|Ride"] = 92.9, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 11.09, ["Fly"] = 36.08, ["Ride"] = 26.25, ["Fly|Ride"] = 57.23, ["Neon"] = 78.75, ["Neon|Ride"] = 109.15, ["Neon|Fly|Ride"] = 274.88, ["Mega"] = 728.44, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 656.15}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 54.72, ["Fly"] = 155.71, ["Ride"] = 92.58, ["Fly|Ride"] = 196.88, ["Neon"] = 131.24, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 201.75, ["Neon|Fly|Ride"] = 308.85, ["Mega"] = 446.24, ["Mega|Fly"] = 2161.89, ["Mega|Ride"] = 456.07, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 27.43, ["Fly"] = 69.05, ["Ride"] = 48.09, ["Fly|Ride"] = 100.08, ["Neon"] = 157.4, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 185.88, ["Neon|Fly|Ride"] = 197.38, ["Mega|Ride"] = 741.23, ["Mega|Fly|Ride"] = 928.92}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 19.05, ["Ride"] = 14.89, ["Fly|Ride"] = 27.57, ["Neon"] = 2.63, ["Neon|Fly"] = 23.72, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 36.75, ["Mega"] = 18.38, ["Mega|Fly"] = 412.51, ["Mega|Ride"] = 45.31, ["Mega|Fly|Ride"] = 107.08}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 233, ["Ride"] = 287.63, ["Fly|Ride"] = 309.53, ["Neon"] = 1373.32, ["Neon|Ride"] = 921.38, ["Neon|Fly|Ride"] = 1018.32, ["Mega|Fly|Ride"] = 4392.74}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 14.44, ["Fly"] = 19.69, ["Ride"] = 55.65, ["Fly|Ride"] = 130.76, ["Neon"] = 96.55, ["Neon|Ride"] = 116.12, ["Neon|Fly|Ride"] = 328.12, ["Mega"] = 411.8, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 29.14, ["Ride"] = 15.6, ["Fly|Ride"] = 39.38, ["Neon"] = 10.47, ["Neon|Fly"] = 36.75, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 109.14, ["Mega"] = 59.24, ["Mega|Fly"] = 274.88, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 109.16}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 41.24, ["Ride"] = 18.56, ["Fly|Ride"] = 43.72, ["Neon"] = 3.44, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 102.8, ["Mega"] = 24.92, ["Mega|Fly"] = 137.96, ["Mega|Ride"] = 46.27, ["Mega|Fly|Ride"] = 180.16}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 3.48, ["Ride"] = 28.88, ["Fly|Ride"] = 69.28, ["Neon"] = 9.37, ["Neon|Ride"] = 62.71, ["Neon|Fly|Ride"] = 6863.46, ["Mega"] = 104.9, ["Mega|Ride"] = 127.34, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 12.55, ["Fly"] = 38.74, ["Ride"] = 24.94, ["Fly|Ride"] = 70.5, ["Neon"] = 55.6, ["Neon|Fly"] = 261.5, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 331.27, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 386.99}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 6.81, ["Fly"] = 55.67, ["Ride"] = 39.38, ["Fly|Ride"] = 72.19, ["Neon"] = 52.5, ["Neon|Ride"] = 142.08, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 267.68, ["Mega|Ride"] = 336.65, ["Mega|Fly|Ride"] = 371.58}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 3.94, ["Neon|Ride"] = 41.66, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 18.38, ["Mega|Ride"] = 68.16, ["Mega|Fly|Ride"] = 127.32}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 9.07, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 49.43, ["Neon|Fly"] = 102.8, ["Neon|Ride"] = 64.31, ["Neon|Fly|Ride"] = 135.33, ["Mega"] = 137.07, ["Mega|Ride"] = 212.62, ["Mega|Fly|Ride"] = 298.56}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 111.99, ["Neon"] = 3.9, ["Neon|Fly"] = 96.79, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 102.3, ["Mega"] = 24.93, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 310.04}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 38.83, ["Ride"] = 22.28, ["Fly|Ride"] = 61.85, ["Neon"] = 5.16, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 87.33, ["Mega"] = 48.05, ["Mega|Ride"] = 82.69, ["Mega|Fly|Ride"] = 234.94}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 672, ["Ride"] = 754.69, ["Fly|Ride"] = 787.5, ["Neon|Ride"] = 3150, ["Neon|Fly|Ride"] = 3113.79, ["Mega|Fly|Ride"] = 12628.44}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 15.73, ["Ride"] = 14.44, ["Fly|Ride"] = 35.44, ["Neon"] = 46.47, ["Neon|Fly"] = 55.73, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 46.47, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 3.93, ["Ride"] = 36.75, ["Fly|Ride"] = 210, ["Neon"] = 12.37, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 62.9, ["Neon|Fly|Ride"] = 137.96, ["Mega"] = 62.43, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 303.69}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 12.91, ["Fly"] = 32.71, ["Ride"] = 23.39, ["Fly|Ride"] = 46.78, ["Neon"] = 47.25, ["Neon|Fly"] = 123.55, ["Neon|Ride"] = 60.8, ["Neon|Fly|Ride"] = 107.06, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 376.69}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 13.13, ["Fly|Ride"] = 31.5, ["Neon"] = 9.19, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 24.52, ["Neon|Fly|Ride"] = 45.48, ["Mega"] = 70.88, ["Mega|Ride"] = 88.13, ["Mega|Fly|Ride"] = 164.91}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 59.3, ["Ride"] = 62.99, ["Fly|Ride"] = 206.06, ["Neon"] = 255.94, ["Neon|Ride"] = 257.44, ["Mega"] = 1167.44}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 18.56, ["Neon"] = 10.5, ["Neon|Fly"] = 132.39, ["Neon|Ride"] = 27.81, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 57.74, ["Mega|Ride"] = 119.44, ["Mega|Fly|Ride"] = 356.49}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 3.46, ["Fly"] = 73.5, ["Ride"] = 20.63, ["Fly|Ride"] = 60.76, ["Neon"] = 40.69, ["Neon|Fly"] = 137.96, ["Neon|Ride"] = 42, ["Mega"] = 123.38, ["Mega|Ride"] = 225.61, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.63, ["Fly|Ride"] = 59.07, ["Neon"] = 9.18, ["Neon|Fly"] = 62.71, ["Neon|Ride"] = 78.75, ["Mega"] = 93.5, ["Mega|Fly"] = 411.8, ["Mega|Ride"] = 171.86, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 18.38, ["Fly|Ride"] = 97.81, ["Neon"] = 5.25, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 23.47, ["Neon|Fly|Ride"] = 65.01, ["Mega"] = 32.82, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 52.41, ["Mega|Fly|Ride"] = 174.75}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 12.31, ["Fly"] = 26.25, ["Ride"] = 21, ["Fly|Ride"] = 45.31, ["Neon"] = 137.82, ["Neon|Ride"] = 68.24, ["Neon|Fly|Ride"] = 96.15, ["Mega"] = 823.58, ["Mega|Ride"] = 513.72, ["Mega|Fly|Ride"] = 456.37}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 695.62, ["Ride"] = 753.38, ["Fly|Ride"] = 916.53, ["Neon"] = 2028.53, ["Neon|Ride"] = 1754.16, ["Neon|Fly|Ride"] = 1903.13, ["Mega"] = 7961.89, ["Mega|Ride"] = 7217.44, ["Mega|Fly|Ride"] = 6247.5}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 16.05, ["Ride"] = 15.49, ["Fly|Ride"] = 47.24, ["Neon"] = 3.84, ["Neon|Fly"] = 137.96, ["Neon|Ride"] = 23.69, ["Neon|Fly|Ride"] = 60.36, ["Mega"] = 49.88, ["Mega|Ride"] = 133.85, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 6.15, ["Ride"] = 27.83, ["Fly|Ride"] = 77.44, ["Neon"] = 18.96, ["Neon|Fly"] = 137.96, ["Neon|Ride"] = 106.84, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 287.05, ["Mega|Ride"] = 315}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 48.82, ["Ride"] = 74.15, ["Fly|Ride"] = 105, ["Neon"] = 295.32, ["Neon|Ride"] = 313.52, ["Neon|Fly|Ride"] = 432.39, ["Mega"] = 3150.32, ["Mega|Fly|Ride"] = 1646.13}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 31.5, ["Fly"] = 124.34, ["Ride"] = 56.44, ["Fly|Ride"] = 102.79, ["Neon"] = 105, ["Neon|Ride"] = 150.32, ["Mega"] = 1923.05, ["Mega|Ride"] = 669.38, ["Mega|Fly|Ride"] = 729.39}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 12.65, ["Ride"] = 26.25, ["Fly|Ride"] = 123.59, ["Neon"] = 77.44, ["Neon|Ride"] = 136.35, ["Neon|Fly|Ride"] = 205.91, ["Mega"] = 411.8, ["Mega|Ride"] = 394.29, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 20.4, ["Ride"] = 92.95, ["Neon"] = 107.6, ["Neon|Ride"] = 356.49, ["Neon|Fly|Ride"] = 164.73, ["Mega"] = 257.79, ["Mega|Fly"] = 503.95, ["Mega|Ride"] = 355.31, ["Mega|Fly|Ride"] = 454}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 15.75, ["Ride"] = 77.95, ["Neon"] = 185.85, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 303.71, ["Neon|Fly|Ride"] = 485.63, ["Mega"] = 525, ["Mega|Ride"] = 632.12, ["Mega|Fly|Ride"] = 555.19}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 7.88}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 5.15, ["Fly"] = 26.8, ["Ride"] = 27.83, ["Fly|Ride"] = 78.75, ["Neon"] = 34.13, ["Neon|Ride"] = 214.7, ["Neon|Fly|Ride"] = 205.91, ["Mega"] = 204.75, ["Mega|Fly"] = 465.33, ["Mega|Ride"] = 197.68, ["Mega|Fly|Ride"] = 303.71}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.93, ["Neon"] = 19.57, ["Mega"] = 137.96, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 59.28, ["Fly"] = 412.21, ["Ride"] = 73.5, ["Fly|Ride"] = 97.67, ["Neon"] = 301.88, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 906.97, ["Mega|Fly|Ride"] = 2058.94}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 5.17, ["Fly"] = 18.59, ["Ride"] = 17.06, ["Fly|Ride"] = 39.38, ["Neon"] = 23.23, ["Neon|Fly"] = 47.37, ["Neon|Ride"] = 35.12, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 164.73, ["Mega|Fly"] = 410.78, ["Mega|Ride"] = 179.16, ["Mega|Fly|Ride"] = 224.96}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 6.72, ["Fly"] = 82.46, ["Ride"] = 22.68, ["Fly|Ride"] = 63, ["Neon"] = 26.25, ["Neon|Ride"] = 54.81, ["Neon|Fly|Ride"] = 137.96, ["Mega"] = 118.13, ["Mega|Ride"] = 152.37, ["Mega|Fly|Ride"] = 298.56}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 7.76, ["Neon|Ride"] = 226.44, ["Mega"] = 42, ["Mega|Ride"] = 96.6, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 45.94, ["Fly"] = 58.7, ["Ride"] = 65.96, ["Fly|Ride"] = 120.75, ["Neon"] = 153.57, ["Neon|Ride"] = 148.04, ["Neon|Fly|Ride"] = 274.88, ["Mega"] = 1098.45, ["Mega|Ride"] = 863.73, ["Mega|Fly|Ride"] = 741.57}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 27.75, ["Neon"] = 8.27, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 84.42, ["Mega"] = 100.91, ["Mega|Ride"] = 92.01, ["Mega|Fly|Ride"] = 309.68}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 9.19, ["Ride"] = 55.65, ["Fly|Ride"] = 272, ["Neon"] = 122.52, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 389.82, ["Mega"] = 374.07, ["Mega|Ride"] = 874.13, ["Mega|Fly|Ride"] = 632.12}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 23.63, ["Ride"] = 15.74, ["Fly|Ride"] = 36.2, ["Neon"] = 30.9, ["Neon|Ride"] = 30.9, ["Neon|Fly|Ride"] = 59.89, ["Mega"] = 157.5, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 3.93, ["Fly"] = 52.49, ["Ride"] = 19.29, ["Fly|Ride"] = 59.03, ["Neon"] = 157.5, ["Neon|Ride"] = 20.61, ["Mega"] = 377.83, ["Mega|Ride"] = 389.16, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.52, ["Ride"] = 56.95, ["Fly|Ride"] = 131.25, ["Neon"] = 46.47, ["Neon|Ride"] = 155.6, ["Mega"] = 364.58, ["Mega|Ride"] = 840.67}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 36.37, ["Ride"] = 136.5, ["Fly|Ride"] = 164.73, ["Neon"] = 144.38, ["Neon|Ride"] = 192.93, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1633.77, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 20.93, ["Ride"] = 85.78, ["Neon"] = 102.96, ["Neon|Ride"] = 179.15, ["Mega"] = 411.7, ["Mega|Ride"] = 329.44, ["Mega|Fly|Ride"] = 498.1}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 8.33, ["Ride"] = 105, ["Fly|Ride"] = 41.2, ["Neon"] = 39.38, ["Neon|Ride"] = 137.96, ["Mega"] = 755.64, ["Mega|Ride"] = 974.92, ["Mega|Fly|Ride"] = 1646.54}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 15.63, ["Ride"] = 45.94, ["Fly|Ride"] = 367.46, ["Neon"] = 103.9, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 823.58, ["Mega|Ride"] = 792.74, ["Mega|Fly|Ride"] = 1084.52}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.62, ["Neon"] = 26.77, ["Neon|Ride"] = 274.88, ["Mega"] = 157.5, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 309.99}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 17.68, ["Fly|Ride"] = 38.18, ["Neon"] = 3.84, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 34.74, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 68.24, ["Mega|Ride"] = 64.87, ["Mega|Fly|Ride"] = 172.11}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 6.45, ["Ride"] = 55.49, ["Fly|Ride"] = 72.19, ["Neon"] = 19.69, ["Neon|Ride"] = 45.31, ["Neon|Fly|Ride"] = 109.94, ["Mega"] = 192.52, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 29.71, ["Ride"] = 18.26, ["Fly|Ride"] = 55.95, ["Neon"] = 6.24, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 45.84, ["Mega|Ride"] = 74.29, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.83, ["Fly"] = 39.38, ["Ride"] = 27.83, ["Fly|Ride"] = 68.99, ["Neon"] = 18.55, ["Neon|Ride"] = 96.79, ["Neon|Fly|Ride"] = 137.96, ["Mega"] = 249.38, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 464.46}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.42, ["Fly"] = 65.63, ["Ride"] = 35.04, ["Fly|Ride"] = 102.38, ["Neon"] = 27.81, ["Neon|Fly"] = 464.46, ["Neon|Ride"] = 68.99, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 302.45, ["Mega|Ride"] = 411.8, ["Mega|Fly|Ride"] = 1029.09}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.83, ["Fly"] = 131.25, ["Ride"] = 27.83, ["Fly|Ride"] = 55.6, ["Neon"] = 24.66, ["Neon|Fly"] = 111.54, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 62.71, ["Mega"] = 137.82, ["Mega|Ride"] = 254.67, ["Mega|Fly|Ride"] = 313.29}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.14, ["Ride"] = 18.38, ["Fly|Ride"] = 51.78, ["Neon"] = 22.32, ["Neon|Fly"] = 82.38, ["Neon|Ride"] = 46.47, ["Neon|Fly|Ride"] = 101.03, ["Mega"] = 168, ["Mega|Ride"] = 227.53, ["Mega|Fly|Ride"] = 411.8}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 8.9, ["Fly"] = 57.75, ["Ride"] = 39.41, ["Fly|Ride"] = 1312.5, ["Neon"] = 20.61, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 44.73, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 110.01, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 10.18, ["Fly"] = 138.06, ["Ride"] = 105, ["Fly|Ride"] = 525, ["Neon"] = 95.82, ["Neon|Ride"] = 218.27, ["Neon|Fly|Ride"] = 354.12, ["Mega"] = 446.25, ["Mega|Fly"] = 686.66, ["Mega|Ride"] = 551.25, ["Mega|Fly|Ride"] = 643.18}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 52.5, ["Ride"] = 97.13, ["Fly|Ride"] = 191.49, ["Neon"] = 274.61, ["Neon|Ride"] = 271.69, ["Neon|Fly|Ride"] = 407.69, ["Mega"] = 1238.94, ["Mega|Ride"] = 1116.94, ["Mega|Fly|Ride"] = 1204.21}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 50.96, ["Ride"] = 22.68, ["Fly|Ride"] = 49.43, ["Neon"] = 3.62, ["Neon|Ride"] = 41.2, ["Neon|Fly|Ride"] = 132.39, ["Mega"] = 40.69, ["Mega|Ride"] = 42, ["Mega|Fly|Ride"] = 131.15}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 36.08, ["Mega"] = 961.53, ["Mega|Ride"] = 822.55, ["Mega|Fly|Ride"] = 1234.91}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 53.82, ["Fly"] = 105, ["Ride"] = 59.06, ["Neon"] = 290.29, ["Neon|Ride"] = 247.09, ["Mega"] = 1680.1, ["Mega|Ride"] = 1212.72, ["Mega|Fly|Ride"] = 961.53}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 5.53, ["Fly"] = 190.32, ["Ride"] = 31.38, ["Fly|Ride"] = 126, ["Neon"] = 49.87, ["Neon|Ride"] = 65.54, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 208.6, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 326.82}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.62, ["Ride"] = 82.43, ["Fly|Ride"] = 137.68, ["Neon"] = 7, ["Neon|Ride"] = 41.2, ["Mega"] = 61.69, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 88.34, ["Mega|Fly|Ride"] = 154.88}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.71, ["Fly"] = 21, ["Ride"] = 14.44, ["Fly|Ride"] = 55.6, ["Neon"] = 12.22, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 110.17, ["Mega"] = 192.52, ["Mega|Fly"] = 343.86, ["Mega|Ride"] = 123.55, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.73, ["Ride"] = 14.06, ["Neon"] = 2.59, ["Neon|Ride"] = 27.81, ["Neon|Fly|Ride"] = 57.67, ["Mega"] = 27.03, ["Mega|Ride"] = 69.56, ["Mega|Fly|Ride"] = 203.85}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 74.27, ["Neon"] = 6.19, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 89.58, ["Mega"] = 32.82, ["Mega|Fly"] = 168, ["Mega|Ride"] = 76.71, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 155.6, ["Neon"] = 2.63, ["Neon|Ride"] = 47.37, ["Mega"] = 20.61, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 5.25, ["Ride"] = 44.31, ["Neon"] = 15.45, ["Neon|Ride"] = 83.62, ["Neon|Fly|Ride"] = 617.7, ["Mega"] = 139.13, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 250.23}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 14.32, ["Ride"] = 26.79, ["Fly|Ride"] = 189.96, ["Neon"] = 51.19, ["Neon|Ride"] = 102.96, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 409.74, ["Mega|Ride"] = 549.75, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 4.72, ["Fly"] = 20.93, ["Ride"] = 20.34, ["Fly|Ride"] = 40.71, ["Neon"] = 39.38, ["Neon|Fly"] = 65.54, ["Neon|Ride"] = 41.37, ["Neon|Fly|Ride"] = 88.64, ["Mega|Ride"] = 342.57, ["Mega|Fly|Ride"] = 236.24}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 65.63, ["Ride"] = 262.73, ["Fly|Ride"] = 262.5, ["Neon"] = 274.88, ["Neon|Ride"] = 597.19, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 18.27, ["Fly"] = 71.73, ["Ride"] = 31.5, ["Fly|Ride"] = 150.32, ["Neon"] = 65.63, ["Neon|Fly|Ride"] = 630, ["Mega"] = 620.06, ["Mega|Ride"] = 827.54, ["Mega|Fly|Ride"] = 820.98}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 16.37, ["Fly|Ride"] = 31.92, ["Neon"] = 3.92, ["Neon|Fly"] = 27.81, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 53.82, ["Mega"] = 39.13, ["Mega|Ride"] = 48.57, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 17.45, ["Ride"] = 14.44, ["Fly|Ride"] = 25.55, ["Neon"] = 5.25, ["Neon|Fly"] = 26.17, ["Neon|Ride"] = 20.22, ["Neon|Fly|Ride"] = 45.72, ["Mega"] = 44.29, ["Mega|Fly"] = 82.38, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 94.5}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 562.66, ["Ride"] = 499.73, ["Fly|Ride"] = 504, ["Neon|Fly|Ride"] = 1500.73}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 7.13, ["Ride"] = 69.04, ["Neon"] = 48.57, ["Neon|Ride"] = 62.76, ["Mega"] = 315, ["Mega|Ride"] = 396.38, ["Mega|Fly|Ride"] = 1235.37}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 48.45, ["Ride"] = 13.71, ["Fly|Ride"] = 36.03, ["Neon"] = 5.24, ["Neon|Fly"] = 68.99, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 45.93, ["Mega|Ride"] = 74.81, ["Mega|Fly|Ride"] = 103.95}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 59.74, ["Ride"] = 115.49, ["Fly|Ride"] = 328.13, ["Neon"] = 236.24, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 1132.43, ["Mega"] = 737.62, ["Mega|Ride"] = 735, ["Mega|Fly|Ride"] = 934.5}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 3.72, ["Fly"] = 21, ["Ride"] = 16.45, ["Fly|Ride"] = 31.67, ["Neon"] = 12.47, ["Neon|Fly"] = 41.37, ["Neon|Ride"] = 27.51, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 84, ["Mega|Fly"] = 179.15, ["Mega|Ride"] = 94.84, ["Mega|Fly|Ride"] = 195.21}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 69.04, ["Ride"] = 36.08, ["Fly|Ride"] = 1312.5, ["Neon"] = 3.34, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 31.99, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 19.69, ["Mega|Fly"] = 269.74, ["Mega|Ride"] = 79.29, ["Mega|Fly|Ride"] = 208.95}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 43.32, ["Fly"] = 143.13, ["Ride"] = 86.62, ["Fly|Ride"] = 124.69, ["Neon"] = 157.5, ["Neon|Ride"] = 191.26, ["Neon|Fly|Ride"] = 420.34, ["Mega"] = 721.88, ["Mega|Ride"] = 630, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 14.44, ["Fly|Ride"] = 52.5, ["Neon"] = 4.38, ["Neon|Ride"] = 39.99, ["Mega"] = 40.71, ["Mega|Ride"] = 183.65, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 39.38, ["Ride"] = 78.75, ["Fly|Ride"] = 131.25, ["Neon"] = 312.97, ["Neon|Ride"] = 248.84, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 1626.57, ["Mega|Ride"] = 1647.16, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 5.16, ["Ride"] = 55.8, ["Fly|Ride"] = 156.49, ["Neon"] = 21.56, ["Neon|Ride"] = 274.88, ["Mega"] = 144.38, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 517.78}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.63, ["Fly"] = 69.04, ["Ride"] = 26.25, ["Fly|Ride"] = 65.96, ["Neon"] = 9.31, ["Neon|Fly"] = 82.38, ["Neon|Ride"] = 110.17, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 110.17, ["Mega|Ride"] = 137.96, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 30.19, ["Ride"] = 55.64, ["Fly|Ride"] = 393.74, ["Neon"] = 144.38, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 323.27, ["Mega"] = 2056.89, ["Mega|Ride"] = 2598.75, ["Mega|Fly|Ride"] = 1126.25}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 230.31, ["Ride"] = 31.95, ["Fly|Ride"] = 908.98, ["Neon"] = 6.57, ["Neon|Ride"] = 37.23, ["Neon|Fly|Ride"] = 152.12, ["Mega"] = 47.25, ["Mega|Fly"] = 247.11, ["Mega|Ride"] = 109.14, ["Mega|Fly|Ride"] = 247.09}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 32.99, ["Ride"] = 15.46, ["Fly|Ride"] = 102.88, ["Neon"] = 15.46, ["Neon|Fly"] = 47.77, ["Neon|Ride"] = 18.55, ["Neon|Fly|Ride"] = 96.79, ["Mega"] = 205.91, ["Mega|Fly|Ride"] = 205.78}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 8.98, ["Fly"] = 45.35, ["Ride"] = 26.25, ["Fly|Ride"] = 81.35, ["Neon"] = 69.56, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 137.96, ["Mega"] = 430.5, ["Mega|Ride"] = 463.28, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 36.08, ["Fly"] = 57.11, ["Ride"] = 29.3, ["Neon"] = 108.94, ["Neon|Ride"] = 137.96, ["Neon|Fly|Ride"] = 205.91, ["Mega"] = 1057.27, ["Mega|Ride"] = 1853.06, ["Mega|Fly|Ride"] = 836.04}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 18.26, ["Fly"] = 27.84, ["Ride"] = 24.94, ["Fly|Ride"] = 74.1, ["Neon"] = 63.83, ["Neon|Ride"] = 110.17, ["Neon|Fly|Ride"] = 274.88, ["Mega"] = 549.75, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 402.93}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 52.38, ["Fly"] = 262.5, ["Ride"] = 112.88, ["Fly|Ride"] = 306.56, ["Neon"] = 299.24, ["Neon|Ride"] = 404.25, ["Neon|Fly|Ride"] = 547.7, ["Mega|Ride"] = 1300.09, ["Mega|Fly|Ride"] = 1258.69}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.6, ["Ride"] = 44.01, ["Neon"] = 32.82, ["Neon|Ride"] = 77.81, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 201.39, ["Mega|Ride"] = 299.59, ["Mega|Fly|Ride"] = 335.35}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 5.51, ["Ride"] = 26.46, ["Fly|Ride"] = 78.74, ["Neon"] = 18.37, ["Neon|Ride"] = 77.23, ["Neon|Fly|Ride"] = 122.75, ["Mega"] = 131.25, ["Mega|Ride"] = 274.88, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 12.5, ["Fly"] = 65.63, ["Ride"] = 40.2, ["Fly|Ride"] = 92.95, ["Neon"] = 61.79, ["Neon|Ride"] = 68.99, ["Mega"] = 430.5, ["Mega|Ride"] = 639.19, ["Mega|Fly|Ride"] = 479.07}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 13.95, ["Fly|Ride"] = 30.9, ["Neon"] = 2.1, ["Neon|Fly"] = 39.37, ["Neon|Ride"] = 16.96, ["Neon|Fly|Ride"] = 53.82, ["Mega"] = 15.75, ["Mega|Ride"] = 23.03, ["Mega|Fly|Ride"] = 93.82}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 44.61, ["Fly"] = 164.07, ["Ride"] = 78.75, ["Fly|Ride"] = 297.26, ["Neon"] = 262.64, ["Neon|Fly"] = 2333.81, ["Neon|Ride"] = 224.44, ["Neon|Fly|Ride"] = 488.14, ["Mega"] = 1393.37, ["Mega|Ride"] = 1342.28, ["Mega|Fly|Ride"] = 946.03}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 18.64, ["Fly|Ride"] = 107.08, ["Neon"] = 3.84, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 31.37, ["Mega|Ride"] = 64.87, ["Mega|Fly|Ride"] = 306.66}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 27.83, ["Ride"] = 15.16, ["Fly|Ride"] = 45.93, ["Neon"] = 22.32, ["Neon|Fly"] = 137.96, ["Neon|Ride"] = 31.92, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 262.5, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 77.95, ["Ride"] = 119.75, ["Fly|Ride"] = 222.6, ["Neon"] = 370.62, ["Neon|Ride"] = 385.62, ["Neon|Fly|Ride"] = 604.31, ["Mega"] = 1131.4, ["Mega|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 22.68, ["Neon"] = 5.11, ["Neon|Ride"] = 65.63, ["Mega"] = 64.32, ["Mega|Ride"] = 120.78, ["Mega|Fly|Ride"] = 216.56}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 10.27}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 292.38, ["Neon"] = 6.19, ["Neon|Ride"] = 41.81, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 47.45, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 99.75, ["Ride"] = 164.85, ["Fly|Ride"] = 295.09, ["Neon"] = 420, ["Neon|Ride"] = 681.59, ["Neon|Fly|Ride"] = 735, ["Mega"] = 3561.21, ["Mega|Ride"] = 2470.73, ["Mega|Fly|Ride"] = 2554.5}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 4.15, ["Ride"] = 36.82, ["Neon"] = 43.35, ["Neon|Ride"] = 63.83, ["Neon|Fly|Ride"] = 193.56, ["Mega"] = 159.94, ["Mega|Ride"] = 202.85, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 27.83, ["Neon"] = 4.39, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 41.2, ["Mega|Ride"] = 99.65, ["Mega|Fly|Ride"] = 124.09}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 4.76, ["Ride"] = 27.83, ["Neon"] = 51.18, ["Neon|Ride"] = 110.07, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 258.41, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 8.63, ["Fly"] = 24.2, ["Ride"] = 20.85, ["Fly|Ride"] = 54.32, ["Neon"] = 80.22, ["Neon|Ride"] = 117.49, ["Neon|Fly|Ride"] = 164.73, ["Mega"] = 411.8, ["Mega|Ride"] = 405.57, ["Mega|Fly|Ride"] = 465.33}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 18.18, ["Ride"] = 55.13, ["Fly|Ride"] = 97.91, ["Neon"] = 142.67, ["Neon|Ride"] = 196.64, ["Neon|Fly|Ride"] = 620.06, ["Mega"] = 656.25, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 771.1}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 131.24, ["Fly"] = 278.82, ["Ride"] = 187.08, ["Fly|Ride"] = 226.15, ["Neon"] = 590.46, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 611.73, ["Mega|Fly|Ride"] = 2329.69}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 23.6, ["Fly"] = 36.75, ["Ride"] = 25.65, ["Fly|Ride"] = 48.76, ["Neon"] = 133.88, ["Neon|Fly"] = 137.96, ["Neon|Ride"] = 123.14, ["Neon|Fly|Ride"] = 177.08, ["Mega|Ride"] = 714.47, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 131.23, ["Ride"] = 20.63, ["Fly|Ride"] = 90.61, ["Neon"] = 26.25, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 117.37, ["Mega"] = 127.32, ["Mega|Ride"] = 140.02, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 8.71, ["Fly"] = 232.36, ["Ride"] = 39.38, ["Fly|Ride"] = 82.43, ["Neon"] = 82.21, ["Neon|Fly|Ride"] = 191.49, ["Mega"] = 376.82, ["Mega|Ride"] = 433.13}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 41.58, ["Ride"] = 82.43, ["Fly|Ride"] = 164.85, ["Neon"] = 220.49, ["Neon|Ride"] = 214.15, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 925.5, ["Mega|Ride"] = 1165.5, ["Mega|Fly|Ride"] = 943.69}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 16.44, ["Ride"] = 105, ["Neon"] = 155.6, ["Neon|Ride"] = 238.26, ["Neon|Fly|Ride"] = 454, ["Mega"] = 660.19, ["Mega|Ride"] = 823.58, ["Mega|Fly|Ride"] = 774.48}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 315, ["Ride"] = 412.11, ["Neon|Ride"] = 1968.75, ["Neon|Fly|Ride"] = 1508.32, ["Mega"] = 4631.57, ["Mega|Fly|Ride"] = 4629.84}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 34.13, ["Ride"] = 65.07, ["Fly|Ride"] = 92.9, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 315, ["Mega"] = 1034.25, ["Mega|Ride"] = 909.57, ["Mega|Fly|Ride"] = 893.47}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 36.66, ["Ride"] = 15.21, ["Fly|Ride"] = 98.44, ["Neon"] = 2.63, ["Neon|Ride"] = 17.3, ["Neon|Fly|Ride"] = 64.28, ["Mega"] = 20.98, ["Mega|Fly"] = 102.96, ["Mega|Ride"] = 41.01, ["Mega|Fly|Ride"] = 108.94}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 3.31, ["Neon"] = 15.73, ["Neon|Ride"] = 40.85, ["Neon|Fly|Ride"] = 259.89, ["Mega"] = 164.73, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 406.66}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 5.12, ["Ride"] = 41.22, ["Fly|Ride"] = 144.16, ["Neon"] = 18.38, ["Neon|Fly"] = 87.94, ["Neon|Ride"] = 122.52, ["Neon|Fly|Ride"] = 174.57, ["Mega"] = 118.98, ["Mega|Fly"] = 142.84, ["Mega|Ride"] = 239.69, ["Mega|Fly|Ride"] = 328.12}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 341.25, ["Fly"] = 620.37, ["Ride"] = 412.55, ["Fly|Ride"] = 641.38, ["Neon"] = 1490.68, ["Neon|Ride"] = 1680.1, ["Neon|Fly|Ride"] = 1370.25, ["Mega|Ride"] = 5759.23, ["Mega|Fly|Ride"] = 5033.44}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 3.14, ["Fly"] = 37.68, ["Ride"] = 17.06, ["Fly|Ride"] = 68.25, ["Neon"] = 15.74, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 77.32, ["Mega"] = 168, ["Mega|Ride"] = 275.18, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 7.07, ["Fly"] = 22.32, ["Ride"] = 17.07, ["Fly|Ride"] = 44.63, ["Neon"] = 28.07, ["Neon|Fly"] = 156.45, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 686.66, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 5.12, ["Fly"] = 39.52, ["Ride"] = 27.55, ["Neon"] = 13.13, ["Neon|Fly"] = 152.12, ["Neon|Ride"] = 47.37, ["Neon|Fly|Ride"] = 137.96, ["Mega"] = 103.28, ["Mega|Ride"] = 137.96, ["Mega|Fly|Ride"] = 205.91}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 31.5, ["Fly"] = 137.82, ["Ride"] = 52.5, ["Fly|Ride"] = 65.63, ["Neon"] = 119.44, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 1625.59, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 31.43, ["Ride"] = 41.22, ["Fly|Ride"] = 68.53, ["Neon"] = 10.5, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 210, ["Mega"] = 164.73, ["Mega|Ride"] = 411.8}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 5.2, ["Fly"] = 787.5, ["Ride"] = 23.63, ["Fly|Ride"] = 85.31, ["Neon"] = 124.4, ["Neon|Ride"] = 155.7, ["Mega"] = 679.46, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.17, ["Neon"] = 4.14, ["Neon|Ride"] = 28.76, ["Mega"] = 45.45, ["Mega|Ride"] = 137.96, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 23.62, ["Ride"] = 134.97, ["Neon"] = 94.5, ["Neon|Ride"] = 274.61, ["Mega"] = 163.72, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 13.13, ["Ride"] = 78.31, ["Neon"] = 139.35, ["Neon|Ride"] = 101.94, ["Neon|Fly|Ride"] = 411.8, ["Mega"] = 480.78, ["Mega|Ride"] = 342.56, ["Mega|Fly|Ride"] = 533.28}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 10.48, ["Fly"] = 31.5, ["Ride"] = 24.43, ["Fly|Ride"] = 55.55, ["Neon"] = 62.71, ["Neon|Fly"] = 116.12, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 137.96, ["Mega"] = 578.58, ["Mega|Ride"] = 370.62, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 261.76, ["Fly"] = 410.27, ["Ride"] = 282.08, ["Fly|Ride"] = 389.81, ["Neon"] = 1468.03, ["Neon|Ride"] = 681.22, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 5043.36}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.62, ["Fly|Ride"] = 56.79, ["Neon"] = 9.98, ["Neon|Fly"] = 77.81, ["Neon|Ride"] = 33.69, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 220.32, ["Mega|Ride"] = 155.6, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 5.24, ["Fly"] = 27.86, ["Ride"] = 45.94, ["Fly|Ride"] = 114.19, ["Neon"] = 35.44, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 282.92, ["Mega|Ride"] = 271.87, ["Mega|Fly|Ride"] = 411.8}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 52.5, ["Ride"] = 123.64, ["Neon"] = 115.5, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 332.76, ["Mega|Ride"] = 361.16, ["Mega|Fly|Ride"] = 480.38}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 117.73, ["Fly"] = 393.75, ["Ride"] = 163.82, ["Fly|Ride"] = 283.33, ["Neon"] = 483, ["Neon|Fly"] = 1043.89, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 1168.13, ["Mega"] = 2322.27, ["Mega|Ride"] = 1794.19, ["Mega|Fly|Ride"] = 2235.19}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 34.06, ["Fly"] = 110.25, ["Ride"] = 65.96, ["Fly|Ride"] = 139.13, ["Neon"] = 80.24, ["Neon|Ride"] = 137.96, ["Neon|Fly|Ride"] = 220.32, ["Mega"] = 236.25, ["Mega|Ride"] = 252, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Ride"] = 15.77, ["Fly|Ride"] = 58.47, ["Neon"] = 9.19, ["Neon|Fly|Ride"] = 58.97, ["Mega"] = 53.55, ["Mega|Ride"] = 193.92, ["Mega|Fly|Ride"] = 192.94}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 10.96, ["Ride"] = 44.31, ["Fly|Ride"] = 81.35, ["Neon"] = 41.28, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 307.82, ["Mega"] = 210, ["Mega|Ride"] = 442.98, ["Mega|Fly|Ride"] = 329.88}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 66.93, ["Fly"] = 196.88, ["Ride"] = 135.19, ["Fly|Ride"] = 216.57, ["Neon"] = 141.74, ["Neon|Ride"] = 170.62, ["Neon|Fly|Ride"] = 315, ["Mega"] = 433.13, ["Mega|Ride"] = 419.99, ["Mega|Fly|Ride"] = 576.18}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.63, ["Neon"] = 8.26, ["Neon|Ride"] = 248.5, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 61.69, ["Mega|Fly"] = 116.82, ["Mega|Ride"] = 137.96, ["Mega|Fly|Ride"] = 153.57}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 13.13, ["Fly|Ride"] = 273.86, ["Neon"] = 84, ["Neon|Ride"] = 401.03, ["Mega"] = 483.87, ["Mega|Fly|Ride"] = 761.82}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 969.94, ["Fly"] = 1258.35, ["Ride"] = 1012.81, ["Fly|Ride"] = 1130.07, ["Neon|Ride"] = 3872.39, ["Neon|Fly|Ride"] = 2624.98, ["Mega|Fly|Ride"] = 13726.89}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 19.67, ["Fly"] = 116.21, ["Ride"] = 109.22, ["Fly|Ride"] = 194.25, ["Neon"] = 123.38, ["Neon|Fly"] = 892.5, ["Neon|Ride"] = 203.85, ["Mega"] = 961.53, ["Mega|Ride"] = 533.28, ["Mega|Fly|Ride"] = 686.66}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.25, ["Ride"] = 20.63, ["Fly|Ride"] = 80.88, ["Neon"] = 11.82, ["Neon|Ride"] = 32.96, ["Neon|Fly|Ride"] = 116.34, ["Mega"] = 78.66, ["Mega|Ride"] = 106.99, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 15.31, ["Ride"] = 131.22, ["Neon"] = 117.37, ["Neon|Fly|Ride"] = 137.96, ["Mega"] = 227.22, ["Mega|Ride"] = 318.93, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 23.71, ["Fly|Ride"] = 52.5, ["Neon"] = 2.63, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 17.06, ["Mega|Fly"] = 123.55, ["Mega|Ride"] = 44.49, ["Mega|Fly|Ride"] = 127.93}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 58.47, ["Ride"] = 118.13, ["Fly|Ride"] = 210, ["Neon"] = 246.75, ["Neon|Ride"] = 337.35, ["Neon|Fly|Ride"] = 473.57, ["Mega"] = 1277.26, ["Mega|Ride"] = 1168.13, ["Mega|Fly|Ride"] = 1219.87}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 6.17, ["Fly"] = 174.57, ["Ride"] = 18.38, ["Fly|Ride"] = 69.04, ["Neon"] = 20.9, ["Neon|Ride"] = 78.75, ["Mega"] = 463.31, ["Mega|Ride"] = 395.33, ["Mega|Fly|Ride"] = 464.63}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.66, ["Fly"] = 97.69, ["Ride"] = 24.74, ["Neon"] = 11.31, ["Neon|Ride"] = 55.6, ["Mega"] = 92.9, ["Mega|Ride"] = 157.49, ["Mega|Fly|Ride"] = 370.62}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 62.99, ["Ride"] = 78.63, ["Fly|Ride"] = 118.13, ["Neon"] = 109.14, ["Neon|Fly"] = 267.68, ["Neon|Ride"] = 164.73, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 497.53, ["Mega|Ride"] = 547.7, ["Mega|Fly|Ride"] = 681.59}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 15.26, ["Ride"] = 84, ["Fly|Ride"] = 62.99, ["Neon"] = 210, ["Neon|Ride"] = 137.96, ["Neon|Fly|Ride"] = 170.9, ["Mega"] = 341.97, ["Mega|Ride"] = 494.16, ["Mega|Fly|Ride"] = 823.58}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 59.06, ["Neon"] = 356.49, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 432.39, ["Mega"] = 1539.19, ["Mega|Ride"] = 1647.16, ["Mega|Fly|Ride"] = 1579.03}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 5.22, ["Ride"] = 42, ["Neon"] = 27.81, ["Neon|Ride"] = 84.81, ["Neon|Fly|Ride"] = 620.06, ["Mega"] = 98.44, ["Mega|Ride"] = 129.93, ["Mega|Fly|Ride"] = 248.5}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 8.73, ["Ride"] = 18.59, ["Fly|Ride"] = 52.48, ["Neon"] = 44.63, ["Neon|Ride"] = 58.24, ["Neon|Fly|Ride"] = 126.36, ["Mega"] = 399, ["Mega|Ride"] = 342.17, ["Mega|Fly|Ride"] = 321.2}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 120.75, ["Ride"] = 156.19, ["Fly|Ride"] = 246.84, ["Neon"] = 529.16, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 558.94, ["Mega"] = 3148.11, ["Mega|Ride"] = 2335.15, ["Mega|Fly|Ride"] = 1889.99}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.63, ["Fly"] = 22.91, ["Ride"] = 18.15, ["Fly|Ride"] = 105000, ["Neon"] = 11.45, ["Neon|Fly"] = 64.31, ["Neon|Ride"] = 35.01, ["Neon|Fly|Ride"] = 96.79, ["Mega"] = 139.55, ["Mega|Ride"] = 148.79, ["Mega|Fly|Ride"] = 205.91}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 7.88, ["Fly"] = 41.09, ["Ride"] = 26.24, ["Fly|Ride"] = 91.88, ["Neon"] = 65.63, ["Neon|Fly"] = 310.04, ["Neon|Ride"] = 76.19, ["Neon|Fly|Ride"] = 137.96, ["Mega"] = 366.98, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 17.61, ["Ride"] = 14.33, ["Fly|Ride"] = 41.2, ["Neon"] = 2.1, ["Neon|Fly"] = 24.09, ["Neon|Ride"] = 16.7, ["Neon|Fly|Ride"] = 41.28, ["Mega"] = 14.44, ["Mega|Fly"] = 48.78, ["Mega|Ride"] = 27.3, ["Mega|Fly|Ride"] = 82.67}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 53.59, ["Neon"] = 2.58, ["Neon|Ride"] = 39.13, ["Mega"] = 20.99, ["Mega|Fly"] = 118.12, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 110.38}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 3.82, ["Fly"] = 35.04, ["Ride"] = 19.69, ["Fly|Ride"] = 79.47, ["Neon"] = 17.07, ["Neon|Ride"] = 59.24, ["Mega"] = 155.6, ["Mega|Ride"] = 164.73, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 39.27, ["Ride"] = 77.27, ["Neon"] = 307.82, ["Neon|Ride"] = 411.8, ["Neon|Fly|Ride"] = 630, ["Mega"] = 549.75, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 667.1}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 3.92, ["Fly"] = 19.69, ["Ride"] = 15.75, ["Fly|Ride"] = 36.75, ["Neon"] = 10.5, ["Neon|Fly"] = 34.44, ["Neon|Ride"] = 26.01, ["Neon|Fly|Ride"] = 53.43, ["Mega"] = 118.13, ["Mega|Fly"] = 170.6, ["Mega|Ride"] = 115.26, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 4.87, ["Fly"] = 30.94, ["Ride"] = 23.63, ["Fly|Ride"] = 54.75, ["Neon"] = 23.44, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 33.26, ["Neon|Fly|Ride"] = 93.12, ["Mega"] = 182.43, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 171.42, ["Mega|Fly|Ride"] = 213.94}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.37, ["Fly"] = 19.69, ["Ride"] = 18.09, ["Fly|Ride"] = 49.88, ["Neon"] = 9.31, ["Neon|Fly"] = 98.43, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 62.58, ["Mega|Fly"] = 96.79, ["Mega|Ride"] = 137.96, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 10.5, ["Fly"] = 36.08, ["Ride"] = 45.93, ["Neon"] = 85.94, ["Neon|Ride"] = 92.9, ["Neon|Fly|Ride"] = 192.52, ["Mega"] = 220.23, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 271.8, ["Mega|Fly|Ride"] = 617.7}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 11.38, ["Fly"] = 171.04, ["Ride"] = 122.72, ["Fly|Ride"] = 220.63, ["Neon"] = 63, ["Neon|Ride"] = 252.03, ["Neon|Fly|Ride"] = 343.86, ["Mega"] = 387.83, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 4.05, ["Fly"] = 41.88, ["Ride"] = 20.6, ["Fly|Ride"] = 65.54, ["Neon"] = 24.22, ["Neon|Fly"] = 196.66, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 109.35, ["Mega"] = 310.04, ["Mega|Ride"] = 232.23, ["Mega|Fly|Ride"] = 370.62}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 17.55, ["Fly|Ride"] = 34.95, ["Neon"] = 10.44, ["Neon|Fly"] = 68.33, ["Neon|Ride"] = 27.81, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 131.25, ["Mega|Ride"] = 135.91, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 189, ["Fly"] = 370.69, ["Ride"] = 264.89, ["Fly|Ride"] = 275.43, ["Neon"] = 823.58, ["Neon|Ride"] = 1235.37, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 6.44, ["Ride"] = 61.76, ["Neon"] = 42.95, ["Neon|Fly|Ride"] = 411.8, ["Mega"] = 119.62, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.62, ["Fly"] = 23.63, ["Ride"] = 15.74, ["Fly|Ride"] = 76.26, ["Neon"] = 23.15, ["Neon|Fly"] = 205.91, ["Neon|Ride"] = 32.96, ["Neon|Fly|Ride"] = 201.8, ["Mega"] = 197.51, ["Mega|Ride"] = 273.86, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 6.57, ["Ride"] = 24.74, ["Neon"] = 52.5, ["Neon|Ride"] = 213.44, ["Neon|Fly|Ride"] = 617.7, ["Mega"] = 461.77, ["Mega|Ride"] = 310.04, ["Mega|Fly|Ride"] = 547.98}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 15.48, ["Ride"] = 15.46, ["Fly|Ride"] = 27.81, ["Neon"] = 2.1, ["Neon|Fly"] = 20.61, ["Neon|Ride"] = 16.43, ["Neon|Fly|Ride"] = 44.62, ["Mega"] = 18.27, ["Mega|Ride"] = 31.92, ["Mega|Fly|Ride"] = 96.46}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 6.57, ["Fly"] = 41.22, ["Ride"] = 17.06, ["Fly|Ride"] = 61.69, ["Neon"] = 9.08, ["Neon|Ride"] = 31.92, ["Neon|Fly|Ride"] = 94.76, ["Mega"] = 102.38, ["Mega|Ride"] = 138.32, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.23, ["Ride"] = 60.8, ["Neon"] = 24.73, ["Neon|Ride"] = 205.91, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 59.07, ["Mega|Ride"] = 195.61, ["Mega|Fly|Ride"] = 308.95}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 65.51, ["Fly"] = 105, ["Ride"] = 105, ["Fly|Ride"] = 138.07, ["Neon"] = 512.08, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 420, ["Mega"] = 2058.94, ["Mega|Ride"] = 3433.28, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.71, ["Fly"] = 91.88, ["Ride"] = 23.63, ["Fly|Ride"] = 65.63, ["Neon"] = 22.32, ["Neon|Ride"] = 54.58, ["Neon|Fly|Ride"] = 92.79, ["Mega"] = 209.42, ["Mega|Ride"] = 288.26, ["Mega|Fly|Ride"] = 398.27}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 20.99, ["Ride"] = 47.39, ["Fly|Ride"] = 118.13, ["Neon"] = 15.23, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 519.43, ["Mega"] = 52.49, ["Mega|Fly"] = 401.5, ["Mega|Ride"] = 122.52, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 53.65, ["Fly"] = 210, ["Ride"] = 89.25, ["Fly|Ride"] = 205.91, ["Neon"] = 124.69, ["Neon|Ride"] = 197.68, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 583.73, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 671.23}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 14.39, ["Ride"] = 13.13, ["Fly|Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 15.45, ["Neon|Ride"] = 16.49, ["Neon|Fly|Ride"] = 35.34, ["Mega"] = 19.05, ["Mega|Fly"] = 48.87, ["Mega|Ride"] = 37.08, ["Mega|Fly|Ride"] = 82.21}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 3.67, ["Neon|Ride"] = 36.04, ["Neon|Fly|Ride"] = 93, ["Mega"] = 21, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 204.75}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 6.19, ["Ride"] = 107.63, ["Neon"] = 13.12, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 181.2, ["Mega"] = 74.82, ["Mega|Fly"] = 179.15, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 196.06}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 9.45, ["Fly"] = 89.64, ["Ride"] = 46.49, ["Fly|Ride"] = 111.56, ["Neon"] = 26.25, ["Neon|Fly"] = 137.03, ["Neon|Ride"] = 72.53, ["Neon|Fly|Ride"] = 225.28, ["Mega"] = 110.23, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 147.58, ["Mega|Fly|Ride"] = 249.27}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 18.56, ["Ride"] = 13, ["Fly|Ride"] = 25.2, ["Neon"] = 2.42, ["Neon|Fly"] = 20.91, ["Neon|Ride"] = 25.99, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 22.04, ["Mega|Fly"] = 39.38, ["Mega|Ride"] = 32.81, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 16.54, ["Fly"] = 72.19, ["Ride"] = 41.22, ["Neon"] = 116.94, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 961.53, ["Mega"] = 310.04, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 685.38}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2467.5, ["Ride"] = 2831.09, ["Fly|Ride"] = 2521.32, ["Neon|Fly|Ride"] = 9581.23, ["Mega|Fly|Ride"] = 34577.1}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 18.37, ["Fly|Ride"] = 27.83, ["Neon"] = 9.19, ["Neon|Fly"] = 62.29, ["Neon|Ride"] = 26.6, ["Neon|Fly|Ride"] = 54.99, ["Mega"] = 78.75, ["Mega|Fly"] = 440.63, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Neon"] = 13.95, ["Mega"] = 126, ["Mega|Fly"] = 441, ["Mega|Ride"] = 137.96, ["Mega|Fly|Ride"] = 617.7}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 22.44, ["Fly"] = 41.24, ["Ride"] = 48.44, ["Fly|Ride"] = 157.5, ["Neon"] = 116.82, ["Neon|Ride"] = 77.81, ["Neon|Fly|Ride"] = 245.22, ["Mega"] = 393.75, ["Mega|Ride"] = 397.68, ["Mega|Fly|Ride"] = 438.56}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 29.54, ["Ride"] = 58.74, ["Neon"] = 155.07, ["Neon|Ride"] = 217.14, ["Mega"] = 540.75, ["Mega|Ride"] = 815.35, ["Mega|Fly|Ride"] = 805.85}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 157.5, ["Fly"] = 1374.35, ["Ride"] = 177.06, ["Fly|Ride"] = 232.36, ["Neon"] = 686.66, ["Neon|Ride"] = 719.61, ["Neon|Fly|Ride"] = 809.18, ["Mega"] = 6176.8, ["Mega|Ride"] = 3481.09, ["Mega|Fly|Ride"] = 3281.25}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 7.75, ["Fly"] = 27.83, ["Ride"] = 28.88, ["Fly|Ride"] = 675.94, ["Neon"] = 15.75, ["Neon|Ride"] = 128.7, ["Mega"] = 78.75, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 163.03, ["Mega|Fly|Ride"] = 349.91}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.63, ["Ride"] = 69.04, ["Neon"] = 14.77, ["Neon|Fly"] = 102.96, ["Neon|Fly|Ride"] = 514.75, ["Mega"] = 114.76, ["Mega|Ride"] = 320.15, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 3.94, ["Fly"] = 144.38, ["Ride"] = 40.68, ["Fly|Ride"] = 196.88, ["Neon"] = 9.08, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 68.99, ["Mega"] = 78.75, ["Mega|Ride"] = 112.53, ["Mega|Fly|Ride"] = 323.27}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 11.37, ["Ride"] = 98.44, ["Neon"] = 129.94, ["Neon|Ride"] = 1165.82, ["Mega"] = 505.49, ["Mega|Ride"] = 604.31, ["Mega|Fly|Ride"] = 718.32}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.18, ["Neon|Ride"] = 93.69, ["Mega"] = 16.94, ["Mega|Fly"] = 115.59, ["Mega|Ride"] = 155.6}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 83.88, ["Fly"] = 138.06, ["Ride"] = 97.13, ["Fly|Ride"] = 146.45, ["Neon"] = 411.8, ["Neon|Ride"] = 409.74, ["Neon|Fly|Ride"] = 411.8, ["Mega"] = 1365, ["Mega|Fly|Ride"] = 1724.14}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 91.81, ["Neon"] = 9.98, ["Neon|Ride"] = 137.96, ["Mega"] = 62.71, ["Mega|Ride"] = 179.15, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 40.63, ["Fly"] = 217.25, ["Ride"] = 77.14, ["Fly|Ride"] = 131.24, ["Neon"] = 236.25, ["Neon|Ride"] = 328.02, ["Neon|Fly|Ride"] = 424.07, ["Mega"] = 2625, ["Mega|Ride"] = 1853.06, ["Mega|Fly|Ride"] = 1601.25}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.6, ["Fly|Ride"] = 50.79, ["Neon"] = 6.57, ["Neon|Fly"] = 87.44, ["Neon|Ride"] = 58.47, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 43.8, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 165.14}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 9.06, ["Neon|Ride"] = 118.13, ["Mega"] = 72.19, ["Mega|Ride"] = 145.16, ["Mega|Fly|Ride"] = 605.07}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 11.82, ["Ride"] = 45.32, ["Fly|Ride"] = 205.91, ["Neon"] = 30.9, ["Neon|Ride"] = 89.58, ["Mega"] = 155.28, ["Mega|Ride"] = 344.89, ["Mega|Fly|Ride"] = 919.5}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 431.82, ["Fly"] = 550.16, ["Ride"] = 457.69, ["Fly|Ride"] = 575.94, ["Neon"] = 1291.49, ["Neon|Ride"] = 1113, ["Neon|Fly|Ride"] = 1246.53, ["Mega|Ride"] = 4725, ["Mega|Fly|Ride"] = 4410}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 32.69, ["Ride"] = 59.07, ["Fly|Ride"] = 78.75, ["Neon"] = 205.91, ["Neon|Ride"] = 192.76, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 1373.32, ["Mega|Ride"] = 1214.78, ["Mega|Fly|Ride"] = 1070.25}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 45.01, ["Ride"] = 19.69, ["Fly|Ride"] = 91.88, ["Neon"] = 7.27, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 68.99, ["Mega"] = 49.88, ["Mega|Ride"] = 68.99, ["Mega|Fly|Ride"] = 183.74}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 11.82, ["Fly"] = 360.6, ["Ride"] = 59.07, ["Fly|Ride"] = 105, ["Neon"] = 44.89, ["Neon|Fly"] = 105, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 218.27, ["Mega"] = 249.38, ["Mega|Fly"] = 955.62, ["Mega|Ride"] = 237.67, ["Mega|Fly|Ride"] = 342.47}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 6.03, ["Ride"] = 20.63, ["Fly|Ride"] = 262.54, ["Neon"] = 138.99, ["Neon|Ride"] = 68.99, ["Mega"] = 411.8, ["Mega|Ride"] = 682.26, ["Mega|Fly|Ride"] = 400.56}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.91, ["Ride"] = 27.83, ["Neon"] = 15.74, ["Mega"] = 72.19, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 3.81, ["Fly"] = 86.62, ["Ride"] = 18.37, ["Fly|Ride"] = 41.2, ["Neon"] = 24.94, ["Neon|Ride"] = 32.79, ["Neon|Fly|Ride"] = 210.08, ["Mega"] = 542.27, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 958.09}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 106.4, ["Ride"] = 131.24, ["Fly|Ride"] = 220.89, ["Neon|Ride"] = 616.88, ["Neon|Fly|Ride"] = 696.69, ["Mega|Fly|Ride"] = 2593.23}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 26.25, ["Fly"] = 95.82, ["Ride"] = 52.5, ["Fly|Ride"] = 137.96, ["Neon"] = 192.94, ["Neon|Ride"] = 192.14, ["Mega"] = 682.5, ["Mega|Ride"] = 695.52, ["Mega|Fly|Ride"] = 686.66}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2216.81, ["Fly"] = 2349.38, ["Ride"] = 2100, ["Fly|Ride"] = 2244.38, ["Neon"] = 10981.3, ["Neon|Fly|Ride"] = 7875, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.57, ["Fly"] = 65625, ["Ride"] = 107.63, ["Fly|Ride"] = 183.75, ["Neon"] = 13.13, ["Neon|Ride"] = 90.61, ["Neon|Fly|Ride"] = 192.52, ["Mega"] = 118.13, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 576.52}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 9.18, ["Ride"] = 27.83, ["Neon"] = 38.41, ["Neon|Ride"] = 96.99, ["Neon|Fly|Ride"] = 232.32, ["Mega"] = 191.56, ["Mega|Ride"] = 196.58, ["Mega|Fly|Ride"] = 521.95}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 862.79, ["Fly"] = 1189.6, ["Ride"] = 994.88, ["Fly|Ride"] = 988.32, ["Neon"] = 2598.75, ["Neon|Ride"] = 2881.48, ["Neon|Fly|Ride"] = 2480.63, ["Mega|Fly|Ride"] = 9186.19}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 35.05, ["Ride"] = 56.44, ["Fly|Ride"] = 134.88, ["Neon"] = 310.04, ["Neon|Ride"] = 294.67, ["Neon|Fly|Ride"] = 370.62, ["Mega"] = 779, ["Mega|Ride"] = 671.23, ["Mega|Fly|Ride"] = 838}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.23, ["Ride"] = 22.91, ["Fly|Ride"] = 128.09, ["Neon"] = 15.43, ["Neon|Ride"] = 41.2, ["Neon|Fly|Ride"] = 328.12, ["Mega"] = 196.88, ["Mega|Ride"] = 123.38, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.41, ["Ride"] = 138, ["Neon"] = 3.68, ["Neon|Fly"] = 41.2, ["Neon|Ride"] = 55.23, ["Neon|Fly|Ride"] = 77.81, ["Mega"] = 27.81, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 274.78}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 82.68, ["Ride"] = 127.32, ["Fly|Ride"] = 310.2, ["Neon"] = 564.17, ["Neon|Ride"] = 434.27, ["Neon|Fly|Ride"] = 420, ["Mega"] = 2745.6, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 7.88, ["Neon"] = 15.25, ["Neon|Ride"] = 61.79, ["Mega"] = 145.45, ["Mega|Ride"] = 188.41, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 68.83, ["Ride"] = 133.71, ["Neon"] = 385.88, ["Neon|Ride"] = 463.32, ["Neon|Fly|Ride"] = 494.32, ["Mega"] = 2470.73, ["Mega|Fly|Ride"] = 2475.96}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 7.77, ["Fly"] = 105, ["Fly|Ride"] = 110.25, ["Neon"] = 39.38, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 310.04, ["Mega|Ride"] = 309.02, ["Mega|Fly|Ride"] = 274.88}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 249.36, ["Ride"] = 315.59, ["Fly|Ride"] = 337.74, ["Neon"] = 1125.35, ["Neon|Ride"] = 836.06, ["Neon|Fly|Ride"] = 879.01, ["Mega|Fly|Ride"] = 4220.82}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 5.23, ["Fly"] = 87.93, ["Ride"] = 26.48, ["Fly|Ride"] = 39.37, ["Neon"] = 52.5, ["Neon|Ride"] = 64.89, ["Neon|Fly|Ride"] = 114.15, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 335.63}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 15.75, ["Fly|Ride"] = 39.38, ["Neon"] = 4.14, ["Neon|Fly"] = 30.9, ["Neon|Ride"] = 22.31, ["Neon|Fly|Ride"] = 52.46, ["Mega"] = 54.17, ["Mega|Fly"] = 95.04, ["Mega|Ride"] = 64.87, ["Mega|Fly|Ride"] = 137.96}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 892.4, ["Ride"] = 1050, ["Fly|Ride"] = 1050, ["Neon|Ride"] = 7550.11, ["Neon|Fly|Ride"] = 5216.31, ["Mega"] = 26080.45, ["Mega|Fly|Ride"] = 27442.49}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 10.39, ["Fly"] = 962.26, ["Ride"] = 210, ["Neon"] = 57.1, ["Neon|Ride"] = 311.74, ["Mega"] = 236.24, ["Mega|Ride"] = 335.63, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 9.19, ["Ride"] = 41.22, ["Fly|Ride"] = 97.13, ["Neon"] = 20.79, ["Neon|Fly"] = 93.01, ["Neon|Ride"] = 55.6, ["Neon|Fly|Ride"] = 124.22, ["Mega"] = 172.09, ["Mega|Fly"] = 204.87, ["Mega|Ride"] = 168, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 29.92, ["Fly"] = 40.68, ["Ride"] = 27.42, ["Fly|Ride"] = 70.85, ["Neon"] = 162.58, ["Neon|Ride"] = 200.17, ["Neon|Fly|Ride"] = 183.66, ["Mega"] = 2058.94, ["Mega|Fly|Ride"] = 860.9}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 13, ["Fly"] = 77.31, ["Ride"] = 31.95, ["Fly|Ride"] = 87.94, ["Neon"] = 65.63, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 76.15, ["Neon|Fly|Ride"] = 146.32, ["Mega"] = 367.5, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 461.22}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 28.88, ["Ride"] = 77.84, ["Fly|Ride"] = 137.82, ["Neon"] = 105.09, ["Neon|Ride"] = 274.88, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 484.89, ["Mega|Ride"] = 574.45, ["Mega|Fly|Ride"] = 618.15}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 65.63, ["Fly|Ride"] = 232.36, ["Neon"] = 2.63, ["Neon|Ride"] = 108.61, ["Neon|Fly|Ride"] = 310.04, ["Mega"] = 15.74, ["Mega|Fly"] = 68.25, ["Mega|Ride"] = 82.38}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 45.93, ["Fly"] = 68.25, ["Ride"] = 64.32, ["Fly|Ride"] = 130.97, ["Neon"] = 402.93, ["Neon|Fly"] = 432.39, ["Neon|Ride"] = 303.71, ["Neon|Fly|Ride"] = 385.03, ["Mega"] = 3294.3, ["Mega|Fly|Ride"] = 956.82}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 4.66, ["Fly"] = 27.84, ["Ride"] = 18.35, ["Fly|Ride"] = 73.61, ["Neon"] = 31.5, ["Neon|Ride"] = 137.96, ["Neon|Fly|Ride"] = 82.38, ["Mega"] = 773.07, ["Mega|Ride"] = 310.04, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 24.75, ["Ride"] = 20.63, ["Fly|Ride"] = 38.06, ["Neon"] = 13.39, ["Neon|Ride"] = 52.53, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 265.9, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 5.92, ["Ride"] = 172.07, ["Neon"] = 105, ["Neon|Fly|Ride"] = 184.33, ["Mega"] = 247.09, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 25.98, ["Ride"] = 80.37, ["Fly|Ride"] = 183.75, ["Neon"] = 144.14, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 303.71, ["Mega"] = 787.5, ["Mega|Ride"] = 840, ["Mega|Fly|Ride"] = 798}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 8.28, ["Ride"] = 196.88, ["Neon"] = 20.88, ["Neon|Ride"] = 77.23, ["Neon|Fly|Ride"] = 137.96, ["Mega"] = 91.76, ["Mega|Fly"] = 303.71, ["Mega|Ride"] = 110.17, ["Mega|Fly|Ride"] = 310.46}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 33.78, ["Neon"] = 2.62, ["Neon|Ride"] = 20.6, ["Mega"] = 15.74, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 206.3}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 69.05, ["Ride"] = 25.1, ["Fly|Ride"] = 81.35, ["Neon"] = 2.57, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 19.69, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 21.06, ["Ride"] = 72.19, ["Fly|Ride"] = 40.05, ["Neon"] = 7.87, ["Neon|Fly"] = 123.38, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 68.99, ["Mega"] = 96.79, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 92.9}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 27.83, ["Fly|Ride"] = 65.63, ["Neon"] = 22.32, ["Neon|Ride"] = 1312.5, ["Mega"] = 118.09, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 15.73, ["Fly|Ride"] = 47.24, ["Neon"] = 14.44, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 77.58, ["Mega|Ride"] = 274.88, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 57.65, ["Ride"] = 155.23, ["Fly|Ride"] = 360.32, ["Neon"] = 173.24, ["Neon|Ride"] = 274.88, ["Neon|Fly|Ride"] = 1029.48, ["Mega"] = 1260.09, ["Mega|Ride"] = 888.44, ["Mega|Fly|Ride"] = 1015.07}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 15.42, ["Ride"] = 14.6, ["Fly|Ride"] = 35.44, ["Neon"] = 2.62, ["Neon|Fly"] = 24.73, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 39.25, ["Mega"] = 31.1, ["Mega|Ride"] = 54.53, ["Mega|Fly|Ride"] = 124.52}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 8.73, ["Fly"] = 61.83, ["Ride"] = 39.17, ["Fly|Ride"] = 82.38, ["Neon"] = 39.21, ["Neon|Fly"] = 91.76, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 114.18, ["Mega"] = 262.5, ["Mega|Ride"] = 241.5, ["Mega|Fly|Ride"] = 257.28}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 15.64, ["Fly"] = 51.48, ["Ride"] = 31.63, ["Fly|Ride"] = 70.6, ["Neon"] = 103.79, ["Neon|Fly"] = 27.81, ["Neon|Ride"] = 102.9, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 1110.05, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 565.05}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.53, ["Fly"] = 196.88, ["Neon"] = 60.76, ["Mega"] = 288.75, ["Mega|Ride"] = 246.88, ["Mega|Fly|Ride"] = 406.5}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.2, ["Fly|Ride"] = 36.04, ["Neon"] = 5.24, ["Neon|Fly"] = 40.09, ["Neon|Ride"] = 23.69, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 41.34, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 76.12, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.82, ["Fly"] = 26.25, ["Ride"] = 27.83, ["Neon"] = 10.5, ["Neon|Fly"] = 31.37, ["Neon|Ride"] = 96.53, ["Mega"] = 136.5, ["Mega|Fly"] = 735, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 384.89}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 971.25, ["Fly"] = 984.38, ["Ride"] = 984.38, ["Fly|Ride"] = 1061.82, ["Neon"] = 2864.53, ["Neon|Ride"] = 2126.25, ["Neon|Fly|Ride"] = 2152.5, ["Mega|Fly|Ride"] = 6891.29}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 81.72, ["Ride"] = 137.82, ["Fly|Ride"] = 155.6, ["Neon"] = 400.32, ["Neon|Ride"] = 458.07, ["Neon|Fly|Ride"] = 604.31, ["Mega"] = 2786.73, ["Mega|Ride"] = 1923.05, ["Mega|Fly|Ride"] = 1640.98}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.63, ["Ride"] = 39.38, ["Neon"] = 5.25, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 205.91, ["Mega"] = 74.23, ["Mega|Fly|Ride"] = 205.83}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 52.5, ["Fly"] = 152.53, ["Ride"] = 78.75, ["Fly|Ride"] = 210, ["Neon"] = 288.26, ["Neon|Ride"] = 340.13, ["Neon|Fly|Ride"] = 398.42, ["Mega"] = 1023.75, ["Mega|Ride"] = 1194.19, ["Mega|Fly|Ride"] = 1128.75}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 4.66, ["Ride"] = 15.75, ["Neon"] = 61.79, ["Neon|Ride"] = 49.45, ["Neon|Fly|Ride"] = 273.86, ["Mega"] = 223.13, ["Mega|Ride"] = 345.91, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 262.5, ["Fly"] = 412.21, ["Ride"] = 286.41, ["Fly|Ride"] = 352.09, ["Neon|Ride"] = 1336.27, ["Neon|Fly|Ride"] = 1393.91, ["Mega|Fly|Ride"] = 4180.09}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 75.64, ["Ride"] = 26.25, ["Fly|Ride"] = 202.64, ["Neon"] = 24.67, ["Neon|Ride"] = 54.28, ["Mega"] = 137.96, ["Mega|Fly"] = 321.2, ["Mega|Ride"] = 185.79}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.63, ["Ride"] = 26.17, ["Neon"] = 35.18, ["Mega"] = 329.44}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 39.66, ["Ride"] = 96.87, ["Fly|Ride"] = 525, ["Neon"] = 549.75, ["Neon|Ride"] = 191.49, ["Neon|Fly|Ride"] = 217.14, ["Mega"] = 590.63, ["Mega|Ride"] = 717.6, ["Mega|Fly|Ride"] = 681.59}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.54, ["Neon"] = 23.47, ["Mega"] = 183.75, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 453.94}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 14.93, ["Fly|Ride"] = 32.82, ["Neon"] = 2.63, ["Neon|Fly"] = 31.29, ["Neon|Ride"] = 137.92, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 27.57, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 137.96}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4331.24, ["Ride"] = 4446.75, ["Fly|Ride"] = 4331.25, ["Neon"] = 30883.93, ["Neon|Fly|Ride"] = 21412.86, ["Mega|Fly|Ride"] = 85070.95}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 9.55, ["Fly"] = 39.38, ["Ride"] = 56.43, ["Neon"] = 52.41, ["Neon|Ride"] = 106.32, ["Mega"] = 271.8, ["Mega|Ride"] = 213.29, ["Mega|Fly|Ride"] = 278.69}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 21.15, ["Ride"] = 21, ["Fly|Ride"] = 41.58, ["Neon"] = 13.25, ["Neon|Fly"] = 68.99, ["Neon|Ride"] = 39.5, ["Neon|Fly|Ride"] = 78.39, ["Mega"] = 137.82, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 191.02}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 479.07, ["Fly"] = 775.01, ["Ride"] = 505.19, ["Fly|Ride"] = 561.53, ["Neon"] = 1372.81, ["Neon|Ride"] = 1550.39, ["Neon|Fly|Ride"] = 1483.13, ["Mega|Fly|Ride"] = 5250.28}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 8.26, ["Ride"] = 25.81, ["Neon"] = 17.07, ["Neon|Ride"] = 145.69, ["Mega"] = 105, ["Mega|Fly|Ride"] = 686.41}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.93, ["Fly"] = 138.1, ["Ride"] = 46.49, ["Neon"] = 131.25, ["Neon|Ride"] = 274.88, ["Neon|Fly|Ride"] = 274.88, ["Mega"] = 409.74, ["Mega|Ride"] = 401.63}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.45, ["Ride"] = 27.09, ["Neon"] = 4.44, ["Neon|Fly"] = 124.68, ["Neon|Ride"] = 24.76, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 44.63, ["Mega|Ride"] = 74.72}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 813.75, ["Ride"] = 708.75, ["Fly|Ride"] = 753.32, ["Neon"] = 2362.5, ["Neon|Ride"] = 2037.62, ["Neon|Fly|Ride"] = 2164.46, ["Mega|Fly|Ride"] = 9605.45}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 7.87, ["Fly"] = 61.83, ["Ride"] = 72.65, ["Neon"] = 31.25, ["Neon|Ride"] = 82.69, ["Neon|Fly|Ride"] = 179.15, ["Mega"] = 152.8, ["Mega|Ride"] = 179.15, ["Mega|Fly|Ride"] = 298.56}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 18.5, ["Fly"] = 235.34, ["Ride"] = 63.57, ["Neon"] = 76.19, ["Neon|Ride"] = 82.38, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 183.75, ["Mega|Ride"] = 201.74, ["Mega|Fly|Ride"] = 283.81}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.63, ["Fly"] = 34.11, ["Ride"] = 15.75, ["Fly|Ride"] = 47.25, ["Neon"] = 14.13, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 81.36, ["Mega"] = 287.98, ["Mega|Fly|Ride"] = 185.22}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 21, ["Ride"] = 46.49, ["Fly|Ride"] = 155.6, ["Neon"] = 117.59, ["Neon|Fly"] = 170.63, ["Mega|Fly|Ride"] = 823.58}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Neon"] = 5.24, ["Neon|Ride"] = 36.01, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 26.25, ["Mega|Fly"] = 110.17, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 481.82}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 459.38, ["Ride"] = 446.25, ["Fly|Ride"] = 697.99, ["Neon"] = 2882.52, ["Neon|Ride"] = 2710.1, ["Neon|Fly|Ride"] = 2343.78, ["Mega|Fly|Ride"] = 6863.46}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 61.66, ["Fly|Ride"] = 178.83, ["Neon"] = 10.31, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 192.52, ["Mega"] = 65.63, ["Mega|Ride"] = 158.05, ["Mega|Fly|Ride"] = 279.57}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 41.21, ["Neon"] = 5.24, ["Neon|Fly"] = 137.96, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 53.55, ["Mega|Fly"] = 110.17, ["Mega|Ride"] = 137.96, ["Mega|Fly|Ride"] = 255.23}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 24.45, ["Neon"] = 5.04, ["Neon|Ride"] = 41.31, ["Neon|Fly|Ride"] = 137.96, ["Mega"] = 41.36, ["Mega|Fly"] = 152.37, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 192.52}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 5.25, ["Ride"] = 131.25, ["Neon"] = 18.5, ["Neon|Ride"] = 39.5, ["Mega"] = 192.52}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 35.43, ["Fly"] = 98.44, ["Ride"] = 137.82, ["Fly|Ride"] = 232.18, ["Neon"] = 137.82, ["Neon|Ride"] = 179.15, ["Neon|Fly|Ride"] = 327.38, ["Mega"] = 632.71, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 684.32}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 15.54, ["Ride"] = 64.32, ["Fly|Ride"] = 116.6, ["Neon"] = 97.13, ["Neon|Ride"] = 131.13, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 411.8, ["Mega|Ride"] = 385.9, ["Mega|Fly|Ride"] = 560.79}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 16.5, ["Fly|Ride"] = 36.04, ["Neon"] = 23.24, ["Neon|Ride"] = 31.19, ["Neon|Fly|Ride"] = 77.81, ["Mega"] = 299.92, ["Mega|Ride"] = 136.54, ["Mega|Fly|Ride"] = 201.89}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 18.27, ["Ride"] = 64.32, ["Neon"] = 92.68, ["Mega"] = 262.5, ["Mega|Fly|Ride"] = 961.17}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 20.63, ["Fly|Ride"] = 44.63, ["Neon"] = 14.44, ["Neon|Ride"] = 31.19, ["Neon|Fly|Ride"] = 206.7, ["Mega"] = 85.3, ["Mega|Fly"] = 152.37, ["Mega|Ride"] = 152.25, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 15.63, ["Fly"] = 62.75, ["Ride"] = 23.37, ["Fly|Ride"] = 155.68, ["Neon"] = 232.23, ["Neon|Ride"] = 177.72, ["Neon|Fly|Ride"] = 240.91, ["Mega"] = 925.5, ["Mega|Ride"] = 928.92, ["Mega|Fly|Ride"] = 738.89}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 15.65, ["Fly"] = 874.13, ["Neon"] = 106.32, ["Neon|Ride"] = 137.96, ["Mega"] = 310.04, ["Mega|Ride"] = 274.88, ["Mega|Fly|Ride"] = 851.39}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 55.12, ["Fly"] = 85.32, ["Ride"] = 65.07, ["Fly|Ride"] = 183.75, ["Neon"] = 308.44, ["Neon|Ride"] = 272.67, ["Neon|Fly|Ride"] = 346.63, ["Mega|Ride"] = 1641.86, ["Mega|Fly|Ride"] = 1393.37}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 47.64, ["Fly"] = 138.1, ["Ride"] = 61.86, ["Fly|Ride"] = 656.25, ["Neon"] = 105, ["Neon|Ride"] = 187.38, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 576.35, ["Mega|Ride"] = 705.98, ["Mega|Fly|Ride"] = 620.82}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 16.53, ["Ride"] = 46.49, ["Neon"] = 127.32, ["Neon|Ride"] = 123.38, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 1235.37}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 15.73, ["Fly"] = 428.26, ["Ride"] = 40.46, ["Fly|Ride"] = 204.87, ["Neon"] = 86.1, ["Neon|Fly"] = 420, ["Neon|Ride"] = 120.74, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 457.47, ["Mega|Ride"] = 378.9, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.74, ["Ride"] = 14.41, ["Fly|Ride"] = 35.01, ["Neon"] = 5.25, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 20.65, ["Neon|Fly|Ride"] = 62.71, ["Mega"] = 44.61, ["Mega|Fly"] = 205.91, ["Mega|Ride"] = 57.66, ["Mega|Fly|Ride"] = 202.79}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1890}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 39.37, ["Ride"] = 103.69, ["Fly|Ride"] = 249.38, ["Neon"] = 236.25, ["Neon|Ride"] = 193.92, ["Neon|Fly|Ride"] = 303.71, ["Mega"] = 714.47, ["Mega|Ride"] = 610.67, ["Mega|Fly|Ride"] = 616.67}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.23, ["Ride"] = 55.65, ["Neon"] = 3.94, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 28.88, ["Mega|Ride"] = 80.31, ["Mega|Fly|Ride"] = 137.96}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 41.27, ["Ride"] = 52.5, ["Neon"] = 128.37, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 769.04, ["Mega|Fly|Ride"] = 782.41}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.82, ["Neon|Ride"] = 105, ["Mega"] = 15.64}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Neon|Ride"] = 47.25, ["Mega"] = 23.99, ["Mega|Ride"] = 106.81, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 119.44, ["Ride"] = 131.25, ["Fly|Ride"] = 274.88, ["Neon"] = 498.75, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 683.58, ["Mega|Ride"] = 6386.23, ["Mega|Fly|Ride"] = 2594.26}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 26.17, ["Ride"] = 17.07, ["Fly|Ride"] = 92.67, ["Neon"] = 11.63, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 81.38, ["Mega"] = 90.56, ["Mega|Ride"] = 155.57, ["Mega|Fly|Ride"] = 222.38}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Fly|Ride"] = 86.63, ["Neon"] = 3.73, ["Neon|Fly"] = 61.79, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 102.96, ["Mega"] = 35.05, ["Mega|Ride"] = 122.78, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.84, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 44.18, ["Mega"] = 35.82, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 224.35}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 5.17, ["Neon|Ride"] = 137.71, ["Mega"] = 61.79, ["Mega|Ride"] = 92.9, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 65.63, ["Ride"] = 103.69, ["Fly|Ride"] = 449.61, ["Neon"] = 415.63, ["Neon|Ride"] = 492.1, ["Neon|Fly|Ride"] = 411.8, ["Mega"] = 1544.21, ["Mega|Ride"] = 1544.21, ["Mega|Fly|Ride"] = 1324.44}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.52, ["Ride"] = 56.95, ["Fly|Ride"] = 131.25, ["Neon"] = 46.47, ["Neon|Ride"] = 155.6, ["Mega"] = 364.58, ["Mega|Ride"] = 840.67}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 313.69, ["Fly"] = 464.69, ["Ride"] = 427.56, ["Fly|Ride"] = 616.88, ["Neon"] = 1645.09, ["Neon|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 1155, ["Mega|Ride"] = 3566.09, ["Mega|Fly|Ride"] = 3845.06}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 85.13}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 45.94}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 23.37}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 32.82}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 61.69}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 51.14}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 18.38}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 11.34}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 245.43}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 15.75}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 30.18}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 5.97}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 4.38}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 206.14}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 3.94}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 3.94}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 3.73}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 5.25}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 8.81}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 393.74}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.63}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 715.26}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 11.68}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1704.84}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.63}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 34.38}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 6.56}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 20.4}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.62}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 28.88}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 39.38}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 49.88}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 20.99}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 10.5}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 14.18}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.73}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 16.71}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.62}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 14.36}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 9.19}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 3.82}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.63}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1787.09}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 44.01}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 308.34}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 2.12}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 7.88}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 6.09}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 34.8}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 193.17}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 6.14}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 7.48}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 2057.12}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 23.63}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 3.92}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.52}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 14.94}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 10.5}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.63}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 178.49}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 26.24}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 11.32}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.62}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 27.11}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.63}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 5.86}},
    ["rbxassetid://1265129203"] = {name = "Ice Snowboard", prices = {["default"] = 1953}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 3.62}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 26.17}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 105}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 222.98}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.63}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 13.8}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 22.32}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.94}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 77.33}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 16.95}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22133.27}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 786.44}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 37.96}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 134.3}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 48.56}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 309.2}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 344.25}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 28.87}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 65.63}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 65.63}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 55.07}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 32.82}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 57.75}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 47.74}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 177.37}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 343.14}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 5.24}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 7.46}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.62}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 5.25}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 24.92}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 85.31}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.27}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.63}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 5.22}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 7.88}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 263.85}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 748.13}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 7.67}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 577.5}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 23.39}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.52}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 604.24}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 45.94}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 115.48}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 49.88}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 44.34}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 63}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 14.44}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.6}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 15.75}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 4.6}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 10.5}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 34.88}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.94}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.63}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 5.24}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 16.79}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 152.25}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 84}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.63}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.63}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1048.69}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 8.27}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 5.25}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 5.88}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 16.96}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 30.19}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 5.39}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 6.46}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 72.18}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 11.82}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 68.58}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 29.08}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 11.17}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 155.88}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 9.31}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 4.55}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 5.25}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 6.45}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 138.12}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 3.92}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 2.43}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.41}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 3.71}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 6240.23}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.49}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 13.01}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3.18}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 10.23}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.85}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 3.94}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 7.03}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 3.84}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.71}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 9.09}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 95.7}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 23.72}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.43}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 5.78}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.94}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 89.8}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 6.22}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4339.98}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 5.25}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 39.38}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 4.74}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 2.41}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 39.38}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 3.67}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 4.71}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 91.88}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.13}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 6.98}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 15.48}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 6.18}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 5.15}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 22.11}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.54}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.62}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 10.29}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 2.41}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.15}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.21}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.51}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.52}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.13}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.24}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 18.69}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 6300}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.62}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 9.05}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 84.74}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.48}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 47.25}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 3.82}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 3.71}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1039.5}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 32.82}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 13.09}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 26.16}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 4.66}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 77.43}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 5.02}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 11.45}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 3.45}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 15.75}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 12.91}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 5.14}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.14}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 15.72}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.63}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.51}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 19.45}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 6.46}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 3.02}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 8.71}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 36.95}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 7.56}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.63}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.52}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 15.65}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 43.26}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 18.26}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.73}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 4.14}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 275.19}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 27.36}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.62}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 4.39}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.12}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 5.97}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.15}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 6.22}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 315}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 5.25}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 137.97}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1115.63}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 213.61}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 4.59}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.63}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 26.81}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 57.75}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.63}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 2.96}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 32.69}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 8.93}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 9.08}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.62}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 3}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.08}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 68.16}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 9.19}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 52.48}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 2.93}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 87.18}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 3.75}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 30.64}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 124.64}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 6.19}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.63}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 71.98}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 4.51}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.39}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 5.23}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 65.62}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 44.63}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 91.88}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 284.82}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.89}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 154.61}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 131.58}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.9}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 5.25}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 28.76}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 60.37}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.94}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 41.99}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 6.03}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 77.87}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 16.95}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 22.32}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 32.82}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 4.94}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 31.47}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 16.48}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 155.72}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 3.62}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 5.25}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 131.25}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.67}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 10.49}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 45.91}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.25}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 69.79}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 137.79}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1782.38}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 7.48}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 7.76}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 40.21}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.56}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 361.82}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 24.78}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 6.45}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 314.9}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 15.48}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 6.01}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 273}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 32.82}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 45.93}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 4.56}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.2}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 105}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 126}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 55.13}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1050}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 194.07}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 11.34}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2061.25}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 492.19}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 2.62}},
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