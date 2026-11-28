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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 715.32, ["Fly"] = 1121, ["Ride"] = 824.1, ["Fly|Ride"] = 981.26, ["Neon"] = 6501.07, ["Neon|Ride"] = 4482.85, ["Neon|Fly|Ride"] = 3412.5, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 350.86, ["Fly"] = 557.25, ["Ride"] = 420.25, ["Fly|Ride"] = 523.59, ["Neon|Fly|Ride"] = 2361.19, ["Mega|Fly|Ride"] = 7984.45}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 5697.57, ["Ride"] = 5250, ["Fly|Ride"] = 4986.19, ["Neon"] = 25914.75, ["Neon|Fly|Ride"] = 24959.42, ["Mega|Fly|Ride"] = 72750.3}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 132.99, ["Fly"] = 203.82, ["Ride"] = 187.29, ["Fly|Ride"] = 525, ["Neon"] = 944.49, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 1191.38, ["Mega|Fly|Ride"] = 6192.27}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 477.75, ["Ride"] = 420, ["Fly|Ride"] = 459.38, ["Neon|Fly|Ride"] = 1573.67, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 9.08, ["Ride"] = 43.63, ["Fly|Ride"] = 103.69, ["Neon"] = 30.48, ["Neon|Ride"] = 77.76, ["Neon|Fly|Ride"] = 280.52, ["Mega"] = 266.86, ["Mega|Ride"] = 266.86, ["Mega|Fly|Ride"] = 409.5}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.62, ["Fly"] = 26.22, ["Ride"] = 23.12, ["Fly|Ride"] = 56.75, ["Neon"] = 23.3, ["Neon|Fly"] = 50.12, ["Neon|Ride"] = 37.35, ["Neon|Fly|Ride"] = 93.95, ["Mega"] = 252.18, ["Mega|Fly"] = 291.38, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 231.92}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 126.1, ["Fly"] = 656.25, ["Ride"] = 146.29, ["Fly|Ride"] = 155.57, ["Neon"] = 506.45, ["Neon|Ride"] = 642.97, ["Neon|Fly|Ride"] = 672.17, ["Mega|Ride"] = 1891.07, ["Mega|Fly|Ride"] = 1512.86}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 32.82, ["Fly"] = 62.35, ["Ride"] = 35.66, ["Fly|Ride"] = 86.52, ["Neon"] = 280.52, ["Neon|Ride"] = 163.79, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 2100, ["Mega|Ride"] = 2730, ["Mega|Fly|Ride"] = 735.51}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 19.38, ["Fly"] = 20.93, ["Ride"] = 30.19, ["Fly|Ride"] = 76.13, ["Neon"] = 233.25, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 168.11, ["Mega|Ride"] = 769.05, ["Mega|Fly|Ride"] = 588.34}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 49.94, ["Fly"] = 399.24, ["Ride"] = 42.11, ["Fly|Ride"] = 104.03, ["Neon|Ride"] = 247.96, ["Neon|Fly|Ride"] = 246.75, ["Mega|Ride"] = 1037.99, ["Mega|Fly|Ride"] = 962.07}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 56.44}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 326.49, ["Fly"] = 436.01, ["Ride"] = 314.99, ["Fly|Ride"] = 400.32, ["Neon|Ride"] = 985.69, ["Neon|Fly|Ride"] = 1115.63, ["Mega|Fly|Ride"] = 4009.69}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 83.25, ["Fly"] = 132.28, ["Ride"] = 104.99, ["Fly|Ride"] = 139.29, ["Neon"] = 1401.49, ["Neon|Fly|Ride"] = 561.03, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.37, ["Ride"] = 78.75, ["Fly|Ride"] = 91.42, ["Neon"] = 16.83, ["Neon|Ride"] = 67.02, ["Neon|Fly|Ride"] = 79.86, ["Mega"] = 159.7, ["Mega|Ride"] = 168.13, ["Mega|Fly|Ride"] = 349.13}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 104.99, ["Fly"] = 124.69, ["Ride"] = 110.34, ["Fly|Ride"] = 148.32, ["Neon"] = 616.7, ["Neon|Ride"] = 630.36, ["Neon|Fly|Ride"] = 488.15, ["Mega"] = 2101.18, ["Mega|Fly|Ride"] = 1967.44}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.1, ["Fly"] = 22.44, ["Ride"] = 15.73, ["Fly|Ride"] = 40.01, ["Neon"] = 18.38, ["Neon|Fly"] = 105.08, ["Neon|Ride"] = 52.55, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 787.5, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 30.19, ["Fly"] = 262.5, ["Ride"] = 42.03, ["Fly|Ride"] = 116.82, ["Neon"] = 154.88, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 208.16, ["Mega"] = 687.4, ["Mega|Ride"] = 681.19, ["Mega|Fly|Ride"] = 683.23}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 41.85}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 39.38, ["Ride"] = 99.72, ["Neon"] = 279.57, ["Mega"] = 1522.5, ["Mega|Fly|Ride"] = 3096.15}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 9.17, ["Fly"] = 42.05, ["Ride"] = 23.89, ["Fly|Ride"] = 140.79, ["Neon"] = 84.04, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 132.37, ["Mega"] = 2670.09, ["Mega|Ride"] = 520.06, ["Mega|Fly|Ride"] = 561.03}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 23.63, ["Fly"] = 49.5, ["Ride"] = 41.99, ["Fly|Ride"] = 91.01, ["Neon"] = 309.98, ["Neon|Ride"] = 224.9, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 1681.32, ["Mega|Fly|Ride"] = 798.99}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 41.91, ["Ride"] = 155.76, ["Fly|Ride"] = 124.2, ["Neon"] = 210, ["Neon|Ride"] = 420.25, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 1680.74, ["Mega|Ride"] = 1247.06, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 25.59, ["Ride"] = 44.55, ["Fly|Ride"] = 130.6, ["Neon"] = 171.08, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 309.94, ["Mega"] = 525, ["Mega|Ride"] = 898.27, ["Mega|Fly|Ride"] = 724.92}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 49.83, ["Fly"] = 69.36, ["Ride"] = 50.8, ["Neon"] = 252.16, ["Neon|Ride"] = 278.63, ["Neon|Fly|Ride"] = 307.97, ["Mega|Ride"] = 3151.77, ["Mega|Fly|Ride"] = 917.18}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 3.93, ["Fly"] = 13.11, ["Ride"] = 20.98, ["Fly|Ride"] = 32.18, ["Neon"] = 23.14, ["Neon|Fly"] = 62.68, ["Neon|Ride"] = 39.89, ["Neon|Fly|Ride"] = 59.01, ["Mega"] = 140.44, ["Mega|Fly"] = 420.25, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 208.69}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 297.94, ["Fly"] = 367.71, ["Ride"] = 322.54, ["Fly|Ride"] = 358.32, ["Neon"] = 1428.81, ["Neon|Ride"] = 1436.16, ["Neon|Fly|Ride"] = 1416.19, ["Mega"] = 10505.84, ["Mega|Fly|Ride"] = 5417.95}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 14.43, ["Ride"] = 30.55, ["Fly|Ride"] = 136.59, ["Neon"] = 238.5, ["Neon|Ride"] = 210.13, ["Neon|Fly|Ride"] = 280.52, ["Mega"] = 826.82, ["Mega|Fly|Ride"] = 696.55}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 3.94, ["Fly"] = 32.82, ["Ride"] = 15.74, ["Fly|Ride"] = 41.68, ["Neon"] = 32.82, ["Neon|Fly"] = 89.25, ["Neon|Ride"] = 38.29, ["Neon|Fly|Ride"] = 105.08, ["Mega"] = 348.8, ["Mega|Ride"] = 360.36, ["Mega|Fly|Ride"] = 389.39}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 85.32, ["Fly"] = 118.49, ["Ride"] = 105.05, ["Fly|Ride"] = 138.69, ["Neon"] = 262.5, ["Neon|Fly"] = 378.23, ["Neon|Ride"] = 276.94, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 6151.64, ["Mega|Ride"] = 3096.15, ["Mega|Fly|Ride"] = 2025.54}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 13.36, ["Ride"] = 22.95, ["Fly|Ride"] = 115.5, ["Neon"] = 150.93, ["Neon|Ride"] = 84.04, ["Neon|Fly|Ride"] = 207.38, ["Mega"] = 697.6}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 189, ["Fly"] = 262.5, ["Ride"] = 201.05, ["Fly|Ride"] = 248.46, ["Neon"] = 774.35, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 798.46, ["Mega"] = 2500.4, ["Mega|Fly|Ride"] = 2381.97}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 24.94}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.13, ["Fly"] = 31.4, ["Ride"] = 28.39, ["Fly|Ride"] = 51.19, ["Neon"] = 19.69, ["Neon|Fly"] = 77.75, ["Neon|Ride"] = 42.05, ["Neon|Fly|Ride"] = 105.08, ["Mega"] = 157.5, ["Mega|Fly"] = 224.57, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 236.24}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 468.56, ["Fly"] = 598.84, ["Ride"] = 477.75, ["Fly|Ride"] = 525, ["Neon"] = 2801.92, ["Neon|Ride"] = 3012.03, ["Neon|Fly|Ride"] = 2605.45, ["Mega|Ride"] = 52240.62, ["Mega|Fly|Ride"] = 9665.38}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 4.23, ["Fly"] = 45.29, ["Ride"] = 18.38, ["Fly|Ride"] = 49.39, ["Neon"] = 27.34, ["Neon|Fly"] = 140.79, ["Neon|Ride"] = 70.41, ["Neon|Fly|Ride"] = 175.46, ["Mega"] = 526.32, ["Mega|Ride"] = 588.34, ["Mega|Fly|Ride"] = 658.73}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 99.8, ["Ride"] = 157.5, ["Fly|Ride"] = 196.24, ["Neon"] = 687.1, ["Neon|Ride"] = 544.69, ["Neon|Fly|Ride"] = 561.03, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 2785.02}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 37.94}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 25.56, ["Ride"] = 91.88, ["Fly|Ride"] = 158.65, ["Neon"] = 140.79, ["Neon|Ride"] = 245.85, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 671.02, ["Mega|Ride"] = 619.94, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 152.94, ["Ride"] = 144.37, ["Neon"] = 700.75, ["Neon|Ride"] = 742.77, ["Neon|Fly|Ride"] = 656.25, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 112.22, ["Ride"] = 141.74, ["Fly|Ride"] = 261.6, ["Neon"] = 393.36, ["Neon|Ride"] = 387.76, ["Neon|Fly|Ride"] = 524.99, ["Mega"] = 1750.28, ["Mega|Ride"] = 1281, ["Mega|Fly|Ride"] = 1468.69}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 55.11}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 46.46, ["Fly"] = 56.44, ["Ride"] = 42, ["Fly|Ride"] = 69.34, ["Neon|Ride"] = 249.37, ["Neon|Fly|Ride"] = 314.18, ["Mega|Fly|Ride"] = 1217.78}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 5.08, ["Ride"] = 49.4, ["Fly|Ride"] = 131.25, ["Neon"] = 21, ["Neon|Ride"] = 56.75, ["Neon|Fly|Ride"] = 155.57, ["Mega"] = 155.3, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 252.16, ["Mega|Fly|Ride"] = 287.87}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 303.19, ["Fly"] = 374.91, ["Ride"] = 297.94, ["Fly|Ride"] = 321.56, ["Neon|Ride"] = 1680.95, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 4722.39}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 49.83, ["Fly"] = 89.72, ["Ride"] = 71.06, ["Fly|Ride"] = 90.56, ["Neon"] = 262.39, ["Neon|Fly"] = 299.53, ["Neon|Ride"] = 210.1, ["Neon|Fly|Ride"] = 410.81, ["Mega|Fly|Ride"] = 1299.38}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3482.72, ["Fly"] = 3782.12, ["Ride"] = 3961.13, ["Fly|Ride"] = 3412.5, ["Neon|Fly|Ride"] = 13656.55}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 23.78, ["Fly"] = 224.84, ["Ride"] = 47.25, ["Fly|Ride"] = 95.48, ["Neon"] = 309.98, ["Neon|Ride"] = 203.1, ["Neon|Fly|Ride"] = 279.47, ["Mega"] = 1891.07, ["Mega|Ride"] = 1891.07, ["Mega|Fly|Ride"] = 1310.09}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 101.01, ["Ride"] = 98.77, ["Fly|Ride"] = 94.57, ["Neon"] = 371.51, ["Neon|Ride"] = 504.24, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 6303.51, ["Mega|Fly|Ride"] = 1525.46}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 27.88, ["Fly"] = 59.01, ["Ride"] = 38.66, ["Fly|Ride"] = 105, ["Neon"] = 140.79, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 2598.75, ["Mega|Fly|Ride"] = 596.58}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 7.88}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 53.48, ["Ride"] = 77.76, ["Fly|Ride"] = 105, ["Neon"] = 441.27, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 490.64}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 41.42}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 196.29, ["Ride"] = 262.5, ["Fly|Ride"] = 341.25, ["Neon|Fly|Ride"] = 2101.18}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 551.25, ["Ride"] = 679.74, ["Fly|Ride"] = 656.25, ["Neon|Ride"] = 2521.41, ["Neon|Fly|Ride"] = 1903.13, ["Mega|Fly|Ride"] = 11812.5}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 6.22}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 25.47, ["Fly"] = 39.38, ["Ride"] = 33.66, ["Fly|Ride"] = 55.05, ["Neon"] = 183.62, ["Neon|Fly"] = 309.98, ["Neon|Ride"] = 140.79, ["Neon|Fly|Ride"] = 201.75, ["Mega|Fly|Ride"] = 1531.69}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 32.82}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 4462.5, ["Fly|Ride"] = 4526.82, ["Neon|Fly|Ride"] = 10286.21, ["Mega|Fly|Ride"] = 40473.57}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 5.24, ["Fly"] = 26.25, ["Ride"] = 19.69, ["Fly|Ride"] = 47.25, ["Neon"] = 42, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 189.12, ["Mega"] = 524.26, ["Mega|Ride"] = 367.4, ["Mega|Fly|Ride"] = 430.75}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 15.73, ["Fly"] = 78.81, ["Ride"] = 26.18, ["Fly|Ride"] = 77.8, ["Neon"] = 39.38, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 700.75, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 449.67}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 118.73, ["Ride"] = 128.63, ["Fly|Ride"] = 187.69}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 10.5, ["Ride"] = 35.96, ["Neon"] = 50.43, ["Neon|Ride"] = 171.77, ["Neon|Fly|Ride"] = 333.19, ["Mega"] = 1121, ["Mega|Ride"] = 838.38, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 2094.75, ["Fly"] = 2165.63, ["Ride"] = 2578.14, ["Fly|Ride"] = 2067.19, ["Neon|Ride"] = 5323.33, ["Neon|Fly|Ride"] = 3953.25, ["Mega|Fly|Ride"] = 10498.69}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 30466.92, ["Fly"] = 26250, ["Ride"] = 24806.25, ["Fly|Ride"] = 22968.75, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 69899.5, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 190506.43}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 16.96, ["Fly"] = 393.75, ["Ride"] = 36.9, ["Fly|Ride"] = 91.42, ["Neon"] = 107.05, ["Neon|Ride"] = 178.38, ["Neon|Fly|Ride"] = 336.2, ["Mega"] = 1121, ["Mega|Ride"] = 735.42, ["Mega|Fly|Ride"] = 948.49}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.1, ["Ride"] = 28.02, ["Fly|Ride"] = 92.93, ["Neon"] = 17.07, ["Neon|Fly"] = 58.17, ["Neon|Ride"] = 39.9, ["Neon|Fly|Ride"] = 149.16, ["Mega"] = 146.74, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 27.34}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 5.61, ["Ride"] = 36.79, ["Fly|Ride"] = 70.39, ["Neon"] = 35.7, ["Neon|Ride"] = 112.43, ["Neon|Fly|Ride"] = 463.32, ["Mega"] = 131.25, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 277.36}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 682.5, ["Ride"] = 704.82, ["Fly|Ride"] = 754.69, ["Neon|Ride"] = 2941.65, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 11206.59, ["Mega|Fly|Ride"] = 10884.05}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 909.57, ["Ride"] = 787.5, ["Fly|Ride"] = 866.25, ["Neon|Fly|Ride"] = 3713.8, ["Mega|Fly|Ride"] = 13726.93}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 18.75, ["Fly"] = 56.75, ["Ride"] = 32.82, ["Fly|Ride"] = 78.68, ["Neon"] = 140.43, ["Neon|Ride"] = 183.86, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 642.31}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 32.82}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 49.75, ["Fly"] = 115.5, ["Ride"] = 68.25, ["Fly|Ride"] = 131.25, ["Neon"] = 420.25, ["Neon|Ride"] = 398.18, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1680.95, ["Mega|Fly|Ride"] = 1598.63}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 69.83, ["Fly"] = 91.88, ["Ride"] = 89.25, ["Fly|Ride"] = 178.79, ["Neon"] = 357.2, ["Neon|Ride"] = 561.03, ["Neon|Fly|Ride"] = 15479.49, ["Mega"] = 2117.16, ["Mega|Ride"] = 1680.95, ["Mega|Fly|Ride"] = 1121}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 2.62, ["Fly"] = 20.69, ["Ride"] = 13.2, ["Fly|Ride"] = 27.07, ["Neon"] = 23.63, ["Neon|Ride"] = 63.06, ["Neon|Fly|Ride"] = 105, ["Mega"] = 511.65, ["Mega|Fly|Ride"] = 397.2}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 59.41, ["Fly"] = 93.16, ["Ride"] = 64.3, ["Fly|Ride"] = 108.23, ["Neon"] = 464.38, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 261.19, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.92, ["Ride"] = 31.84, ["Neon"] = 21, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 156.19, ["Mega"] = 155.5, ["Mega|Fly"] = 1121, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 833.26}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 12.48, ["Fly"] = 65.63, ["Ride"] = 19.14, ["Fly|Ride"] = 43.32, ["Neon"] = 147, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 621.96}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 17.28, ["Ride"] = 51.1, ["Fly|Ride"] = 113.48, ["Neon"] = 210.13, ["Neon|Ride"] = 343.64, ["Neon|Fly|Ride"] = 700.75, ["Mega"] = 420.25, ["Mega|Fly|Ride"] = 978.11}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 12.31, ["Fly"] = 90.35, ["Ride"] = 40.63, ["Fly|Ride"] = 70.41, ["Neon"] = 103.69, ["Neon|Ride"] = 91.42, ["Neon|Fly|Ride"] = 95.62, ["Mega|Ride"] = 840.48, ["Mega|Fly|Ride"] = 594.64}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6562.5, ["Ride"] = 4856.25, ["Fly|Ride"] = 3937.5, ["Neon"] = 28717.7, ["Neon|Fly|Ride"] = 25539.87}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 177.19, ["Fly"] = 212.63, ["Ride"] = 201.72, ["Fly|Ride"] = 247.96, ["Neon|Fly|Ride"] = 511.88, ["Mega|Fly|Ride"] = 2060.46}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 20.91, ["Fly"] = 88.38, ["Ride"] = 44.26, ["Fly|Ride"] = 84.07, ["Neon"] = 69.57, ["Neon|Fly"] = 104.51, ["Neon|Ride"] = 70.5, ["Neon|Fly|Ride"] = 182.81, ["Mega"] = 256.36, ["Mega|Fly"] = 420.25, ["Mega|Ride"] = 247.9, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 40.64, ["Ride"] = 19.88, ["Fly|Ride"] = 99.82, ["Neon"] = 19.69, ["Neon|Ride"] = 105.08, ["Mega"] = 140.44}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 29.29, ["Fly"] = 150.93, ["Ride"] = 58.09, ["Fly|Ride"] = 146.19, ["Neon"] = 120.75, ["Neon|Fly"] = 333.19, ["Neon|Ride"] = 138.69, ["Neon|Fly|Ride"] = 318.94, ["Mega"] = 322.54, ["Mega|Ride"] = 281.72, ["Mega|Fly|Ride"] = 496.13}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 18571.88, ["Ride"] = 11082.75, ["Fly|Ride"] = 10661.44, ["Neon|Fly|Ride"] = 23625, ["Mega|Fly|Ride"] = 91050.89}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 145, ["Ride"] = 150.93, ["Fly|Ride"] = 218.53, ["Neon"] = 840.48, ["Neon|Fly|Ride"] = 840, ["Mega"] = 4412.47, ["Mega|Fly|Ride"] = 4553.24}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 46.82, ["Fly"] = 459.38, ["Ride"] = 49.4, ["Fly|Ride"] = 62.99, ["Neon|Fly"] = 464.38, ["Neon|Ride"] = 266.44, ["Neon|Fly|Ride"] = 341.25, ["Mega|Fly|Ride"] = 2731.53}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 10.5, ["Ride"] = 25.24, ["Fly|Ride"] = 91.42, ["Neon"] = 72.19, ["Neon|Ride"] = 84.07, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 2521.41, ["Mega|Ride"] = 492.19, ["Mega|Fly|Ride"] = 532.66}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 318.29, ["Fly"] = 840.48, ["Ride"] = 311.06, ["Fly|Ride"] = 457.68, ["Neon"] = 1640.63, ["Neon|Ride"] = 1260, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 5251.87, ["Mega|Fly|Ride"] = 4616.75}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.98, ["Fly"] = 101.53, ["Ride"] = 30.4, ["Fly|Ride"] = 166.01, ["Neon"] = 31.54, ["Neon|Ride"] = 99.1, ["Neon|Fly|Ride"] = 102.69, ["Mega"] = 120.99, ["Mega|Fly"] = 278.37, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 232.2}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 107.63, ["Ride"] = 126.76, ["Fly|Ride"] = 140.78, ["Neon"] = 328.13, ["Neon|Ride"] = 327.8, ["Neon|Fly|Ride"] = 426.56, ["Mega"] = 1574.99, ["Mega|Fly|Ride"] = 1663.62}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 9.19, ["Fly"] = 17.07, ["Ride"] = 13.62, ["Fly|Ride"] = 27.55, ["Neon"] = 31.54, ["Neon|Ride"] = 102.18, ["Neon|Fly|Ride"] = 73.55, ["Mega"] = 2521.41, ["Mega|Fly|Ride"] = 472.78}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 8.92}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 63, ["Ride"] = 98.77, ["Fly|Ride"] = 525, ["Neon"] = 350.44, ["Neon|Fly"] = 1680.95, ["Neon|Ride"] = 364.56, ["Neon|Fly|Ride"] = 689.19, ["Mega|Ride"] = 1393.1, ["Mega|Fly|Ride"] = 1532.42}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 12.22, ["Ride"] = 31.54, ["Fly|Ride"] = 90.37, ["Neon"] = 81.97, ["Neon|Ride"] = 116.08, ["Neon|Fly|Ride"] = 146.05, ["Mega"] = 393.75, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 831.09}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 44.58}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 22.07, ["Fly"] = 210, ["Ride"] = 76.11, ["Fly|Ride"] = 73.56, ["Neon"] = 133.88, ["Neon|Ride"] = 140.79, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 1541.23, ["Mega|Ride"] = 962.35, ["Mega|Fly|Ride"] = 597.19}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.14, ["Ride"] = 24.19, ["Neon"] = 17.89, ["Neon|Ride"] = 137.64, ["Neon|Fly|Ride"] = 321.57, ["Mega"] = 131.75, ["Mega|Ride"] = 157.6, ["Mega|Fly|Ride"] = 399.67}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 18.36, ["Ride"] = 28.58, ["Fly|Ride"] = 89.14, ["Neon"] = 212.1, ["Neon|Ride"] = 154.88, ["Neon|Fly|Ride"] = 619.94, ["Mega|Ride"] = 451.84, ["Mega|Fly|Ride"] = 630.36}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 343.79, ["Fly"] = 437.75, ["Ride"] = 285.15, ["Fly|Ride"] = 385.88, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 8404.68, ["Mega|Fly|Ride"] = 8824.92}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 19.62, ["Ride"] = 45.29, ["Fly|Ride"] = 124.24, ["Neon"] = 244.64, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 309.94, ["Mega"] = 393.75, ["Mega|Ride"] = 639.68, ["Mega|Fly|Ride"] = 695.5}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 41.15, ["Ride"] = 66.89, ["Fly|Ride"] = 105.08, ["Neon"] = 105, ["Neon|Fly"] = 238.5, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 185.76, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1147.26}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 10.17, ["Ride"] = 39.38, ["Fly|Ride"] = 89.76, ["Neon"] = 59.73, ["Neon|Ride"] = 80.21, ["Neon|Fly|Ride"] = 273.17, ["Mega"] = 309.98, ["Mega|Ride"] = 336, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 11144.68, ["Ride"] = 11089.32, ["Fly|Ride"] = 8505, ["Neon|Fly|Ride"] = 15483.57, ["Mega|Fly|Ride"] = 39372.9}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1706.25, ["Fly"] = 2241.96, ["Ride"] = 2127.19, ["Fly|Ride"] = 1798.13, ["Neon|Fly|Ride"] = 4515, ["Mega|Fly|Ride"] = 15106.14}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 328.13, ["Ride"] = 393.99, ["Fly|Ride"] = 590.63, ["Neon"] = 1399.76, ["Neon|Ride"] = 1344.77, ["Neon|Fly|Ride"] = 1344.77, ["Mega"] = 14437.5, ["Mega|Fly|Ride"] = 6163.79}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 14.01, ["Fly"] = 22.31, ["Ride"] = 20.55, ["Fly|Ride"] = 33.64, ["Neon"] = 140.79, ["Neon|Ride"] = 108.23, ["Neon|Fly|Ride"] = 141.84, ["Mega|Fly|Ride"] = 619.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 4.66, ["Fly"] = 131.25, ["Ride"] = 45.94, ["Fly|Ride"] = 105, ["Neon"] = 20.41, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 155.57, ["Mega"] = 140.44, ["Mega|Ride"] = 218.53, ["Mega|Fly|Ride"] = 268.84}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 32.82, ["Fly"] = 39.35, ["Ride"] = 38.07, ["Fly|Ride"] = 79.68, ["Neon"] = 182.44, ["Neon|Ride"] = 155.57, ["Neon|Fly|Ride"] = 157.49, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 2.61, ["Fly"] = 16.1, ["Ride"] = 15.74, ["Fly|Ride"] = 27.99, ["Neon"] = 21, ["Neon|Fly"] = 53.42, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 80.2, ["Mega"] = 472.5, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 250.24}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 262.49, ["Fly"] = 317.62, ["Ride"] = 239.85, ["Fly|Ride"] = 294.18, ["Neon|Ride"] = 1049.54, ["Neon|Fly|Ride"] = 918.75, ["Mega|Fly|Ride"] = 4516.47}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 19.65, ["Fly"] = 56.75, ["Ride"] = 33.64, ["Fly|Ride"] = 70.33, ["Neon"] = 112.43, ["Neon|Ride"] = 142.88, ["Neon|Fly|Ride"] = 170.62, ["Mega|Ride"] = 708.11, ["Mega|Fly|Ride"] = 774.37}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 9.02, ["Fly"] = 28.39, ["Ride"] = 17.33, ["Fly|Ride"] = 32.82, ["Neon|Fly"] = 124.24, ["Neon|Ride"] = 109.13, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 420.25, ["Mega|Ride"] = 578.88, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 511.65, ["Fly"] = 656.25, ["Ride"] = 484.32, ["Fly|Ride"] = 672.39, ["Mega|Fly|Ride"] = 8845.93}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1302, ["Ride"] = 1210.09, ["Fly|Ride"] = 1161.57, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 18486.07}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 69.72, ["Fly"] = 63.06, ["Ride"] = 70.41, ["Fly|Ride"] = 98.44, ["Neon"] = 561.03, ["Neon|Ride"] = 414.75, ["Neon|Fly|Ride"] = 309.98, ["Mega|Fly|Ride"] = 1312.49}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 157.5, ["Fly"] = 203.79, ["Ride"] = 196.2, ["Fly|Ride"] = 183.75, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 651.66, ["Mega|Fly|Ride"] = 3504.38}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 17.99, ["Ride"] = 56.75, ["Neon"] = 210, ["Neon|Ride"] = 279.17, ["Neon|Fly|Ride"] = 840.48, ["Mega|Ride"] = 928.73, ["Mega|Fly|Ride"] = 1033.22}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 105.52, ["Ride"] = 577.83, ["Fly|Ride"] = 597.19, ["Neon"] = 1541.23, ["Neon|Ride"] = 1260.71, ["Neon|Fly|Ride"] = 1680.95, ["Mega|Fly|Ride"] = 4202.35}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1534.32, ["Fly"] = 2101.18, ["Ride"] = 1392.76, ["Fly|Ride"] = 1967.44, ["Neon|Fly|Ride"] = 6562.49, ["Mega|Fly|Ride"] = 31886.52}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 60.53, ["Ride"] = 91.88, ["Fly|Ride"] = 262.26, ["Neon"] = 278.07, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 1962.5, ["Mega|Ride"] = 2311.3, ["Mega|Fly|Ride"] = 2168.13}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 535.5, ["Fly"] = 669.38, ["Ride"] = 553.88, ["Fly|Ride"] = 578.49, ["Neon"] = 1331.11, ["Neon|Ride"] = 1401.49, ["Neon|Fly|Ride"] = 1111.69, ["Mega|Fly|Ride"] = 2782.5}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 36.01, ["Fly"] = 50.88, ["Ride"] = 45.99, ["Fly|Ride"] = 83.61, ["Neon"] = 203.82, ["Neon|Ride"] = 513.45, ["Neon|Fly|Ride"] = 232.08, ["Mega|Fly|Ride"] = 1450.32}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 2.1, ["Fly"] = 24.18, ["Ride"] = 15.42, ["Fly|Ride"] = 37.38, ["Neon"] = 19.69, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 73.01, ["Mega"] = 264.11, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 190.11}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 45.94, ["Ride"] = 66.94, ["Fly|Ride"] = 252, ["Neon"] = 1260.71, ["Neon|Ride"] = 771.15, ["Mega"] = 1393.1, ["Mega|Fly|Ride"] = 955.47}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 467.86, ["Fly"] = 928.73, ["Ride"] = 481.69, ["Fly|Ride"] = 505.32, ["Neon"] = 1611.61, ["Neon|Ride"] = 1996.77, ["Neon|Fly|Ride"] = 1548.75, ["Mega|Fly|Ride"] = 4814.25}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 523.69, ["Ride"] = 576.19, ["Fly|Ride"] = 700.75, ["Neon"] = 8404.68, ["Mega|Fly|Ride"] = 12607.01}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 11.81, ["Fly"] = 32.8, ["Ride"] = 19.69, ["Fly|Ride"] = 39.9, ["Neon"] = 102.72, ["Neon|Ride"] = 84.07, ["Neon|Fly|Ride"] = 91.88, ["Mega|Fly|Ride"] = 618.98}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 7.23, ["Ride"] = 18.38, ["Fly|Ride"] = 75.66, ["Neon"] = 52.6, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 420.25, ["Mega"] = 460.18, ["Mega|Ride"] = 460.18, ["Mega|Fly|Ride"] = 473.83}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.93, ["Ride"] = 23.63, ["Fly|Ride"] = 99.83, ["Neon"] = 18.38, ["Neon|Fly"] = 112.3, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 140.78, ["Mega"] = 152.85, ["Mega|Ride"] = 157.4, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 28.23, ["Fly"] = 41.32, ["Ride"] = 39.35, ["Fly|Ride"] = 63, ["Neon"] = 250.78, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 707.74}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 29.48, ["Ride"] = 91.88, ["Fly|Ride"] = 619.94, ["Neon"] = 350.44, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 695.63, ["Mega|Fly|Ride"] = 1260.57}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 12.37, ["Fly"] = 52.5, ["Ride"] = 25.24, ["Fly|Ride"] = 91.02, ["Neon"] = 59.69, ["Neon|Fly"] = 119.78, ["Neon|Ride"] = 85.76, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 656.25, ["Mega|Ride"] = 295.32, ["Mega|Fly|Ride"] = 363.21}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 31.47, ["Fly"] = 112.43, ["Ride"] = 36.72, ["Fly|Ride"] = 90.17, ["Neon"] = 210.13, ["Neon|Ride"] = 203.8, ["Neon|Fly|Ride"] = 182.2, ["Mega"] = 2100, ["Mega|Ride"] = 1207.36, ["Mega|Fly|Ride"] = 980.28}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.6, ["Fly"] = 38.06, ["Ride"] = 13.94, ["Fly|Ride"] = 41.99, ["Neon"] = 34.29, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 104.9, ["Mega"] = 248.46, ["Mega|Ride"] = 464.38, ["Mega|Fly|Ride"] = 232.2}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 7.6, ["Fly"] = 42.9, ["Ride"] = 27.46, ["Fly|Ride"] = 62.01, ["Neon"] = 20.93, ["Neon|Fly"] = 155.57, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 232.2, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 26.19, ["Fly"] = 55.11, ["Ride"] = 51.17, ["Fly|Ride"] = 78.75, ["Neon"] = 417.62, ["Neon|Ride"] = 224.57, ["Neon|Fly|Ride"] = 240.19, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1680, ["Fly"] = 2447.82, ["Ride"] = 1764, ["Fly|Ride"] = 1785, ["Neon"] = 6656.63, ["Neon|Ride"] = 5252.92, ["Neon|Fly|Ride"] = 4514.99, ["Mega|Fly|Ride"] = 14003.07}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 413.44, ["Fly"] = 561.03, ["Ride"] = 471.19, ["Fly|Ride"] = 525, ["Neon"] = 3096.15, ["Neon|Ride"] = 2381.68, ["Neon|Fly|Ride"] = 1704.94, ["Mega|Fly|Ride"] = 7686.09}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 249.38, ["Ride"] = 301.88, ["Fly|Ride"] = 393.75, ["Neon"] = 1365.78, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1155.66, ["Mega|Fly|Ride"] = 5533.44}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 38.06}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 33.69, ["Fly"] = 65.63, ["Ride"] = 39.38, ["Fly|Ride"] = 78.75, ["Neon"] = 288.75, ["Neon|Ride"] = 183.89, ["Neon|Fly|Ride"] = 418.98, ["Mega"] = 1154.61, ["Mega|Ride"] = 1470.83, ["Mega|Fly|Ride"] = 688.15}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 29416.34, ["Fly"] = 20998.69, ["Ride"] = 34781.25, ["Fly|Ride"] = 15748.69, ["Neon|Fly|Ride"] = 36748.69, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 187.51, ["Fly"] = 217.88, ["Ride"] = 202.13, ["Fly|Ride"] = 275.63, ["Neon"] = 735.32, ["Neon|Fly"] = 798.46, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 603.74, ["Mega"] = 3489, ["Mega|Ride"] = 4790.67, ["Mega|Fly|Ride"] = 2208.45}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 262.5, ["Ride"] = 249.38, ["Fly|Ride"] = 262.5, ["Neon|Fly|Ride"] = 1703.05}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 94.39, ["Ride"] = 98.44, ["Fly|Ride"] = 141.63, ["Neon"] = 496.89, ["Neon|Ride"] = 356.76, ["Neon|Fly|Ride"] = 368.91, ["Mega"] = 14008.5, ["Mega|Fly|Ride"] = 2141.1}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 12.49, ["Fly"] = 28.39, ["Ride"] = 29.27, ["Fly|Ride"] = 77.67, ["Neon"] = 98.76, ["Neon|Ride"] = 138.1, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 619.94, ["Mega|Ride"] = 436.64}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3937.39, ["Ride"] = 4188.19, ["Fly|Ride"] = 4062.19, ["Neon|Ride"] = 21712.42, ["Neon|Fly|Ride"] = 13125}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 22.32, ["Fly"] = 45.18, ["Ride"] = 30.16, ["Fly|Ride"] = 46.45, ["Neon"] = 105, ["Neon|Ride"] = 139.13, ["Neon|Fly|Ride"] = 150.94, ["Mega|Fly|Ride"] = 570.94}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 32.53, ["Fly"] = 62.7, ["Ride"] = 45.85, ["Fly|Ride"] = 70.82, ["Neon|Ride"] = 273.17, ["Neon|Fly|Ride"] = 290.25, ["Mega|Fly|Ride"] = 1703.05}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 490.88, ["Fly"] = 919.45, ["Ride"] = 472.5, ["Fly|Ride"] = 654.94, ["Neon"] = 1625.28, ["Neon|Ride"] = 1509.31, ["Neon|Fly|Ride"] = 1165.5, ["Mega"] = 3675, ["Mega|Ride"] = 6302.46, ["Mega|Fly|Ride"] = 3856.13}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 11.33, ["Fly"] = 23.13, ["Ride"] = 16.88, ["Fly|Ride"] = 36.37, ["Neon"] = 63.05, ["Neon|Fly"] = 126.09, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 110.03, ["Mega|Fly|Ride"] = 523.68}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 8.43, ["Ride"] = 42.05, ["Fly|Ride"] = 136.59, ["Neon"] = 44.03, ["Neon|Ride"] = 123.38, ["Mega"] = 418.15}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 107.88, ["Ride"] = 118.39, ["Fly|Ride"] = 165.38, ["Neon"] = 498.75, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 735, ["Mega|Fly|Ride"] = 2982.62}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 19.11, ["Fly"] = 76.95, ["Ride"] = 74.02, ["Fly|Ride"] = 128.41, ["Neon"] = 50.65, ["Neon|Ride"] = 92.96, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 252.19, ["Mega|Fly"] = 523.69, ["Mega|Ride"] = 227.97, ["Mega|Fly|Ride"] = 349.13}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3025.83, ["Ride"] = 2887.5, ["Fly|Ride"] = 2940, ["Neon"] = 9454.22, ["Neon|Ride"] = 17028.14, ["Neon|Fly|Ride"] = 7218.74, ["Mega"] = 63034.99, ["Mega|Fly|Ride"] = 37613.26}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 22.93, ["Fly"] = 210, ["Ride"] = 44.23, ["Fly|Ride"] = 98.77, ["Neon"] = 155.33, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 281.57, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 6103.13, ["Fly"] = 7875, ["Ride"] = 7804.13, ["Fly|Ride"] = 6168.75, ["Neon|Ride"] = 18079.9, ["Neon|Fly|Ride"] = 13122.38, ["Mega|Fly|Ride"] = 61633.51}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.63, ["Fly"] = 19.57, ["Ride"] = 13.13, ["Fly|Ride"] = 23.88, ["Neon"] = 19.69, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 41, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 449.29, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 17.89, ["Fly"] = 35.41, ["Ride"] = 27.5, ["Fly|Ride"] = 43.93, ["Neon"] = 191.22, ["Neon|Ride"] = 280.88, ["Neon|Fly|Ride"] = 513.19, ["Mega|Ride"] = 1335.49, ["Mega|Fly|Ride"] = 928.73}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 10.5, ["Fly"] = 70.41, ["Ride"] = 24.94, ["Fly|Ride"] = 91.88, ["Neon"] = 62.99, ["Neon|Ride"] = 153.57, ["Neon|Fly|Ride"] = 231.04, ["Mega|Ride"] = 771.15, ["Mega|Fly|Ride"] = 748.13}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 26.17, ["Fly"] = 111.38, ["Ride"] = 56.75, ["Fly|Ride"] = 155.54, ["Neon"] = 161.44, ["Neon|Ride"] = 161.8, ["Neon|Fly|Ride"] = 222.74, ["Mega"] = 735, ["Mega|Ride"] = 1680.95, ["Mega|Fly|Ride"] = 905.63}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 12.27, ["Fly"] = 15.23, ["Ride"] = 15.74, ["Fly|Ride"] = 33.64, ["Neon"] = 49.4, ["Neon|Ride"] = 96.67, ["Neon|Fly|Ride"] = 126.07, ["Mega"] = 2521.41, ["Mega|Fly|Ride"] = 619.94}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8888.24}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2688.74}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 21}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 176.78, ["Fly"] = 420.25, ["Fly|Ride"] = 350.9, ["Neon|Fly|Ride"] = 1793.36, ["Mega|Fly|Ride"] = 5603.82}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 18.38, ["Fly"] = 130.28, ["Ride"] = 41.82, ["Fly|Ride"] = 98.44, ["Neon"] = 105.55, ["Neon|Ride"] = 150.93, ["Mega"] = 542.15, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 555.19}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 13.13}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 13.95, ["Neon"] = 70.88, ["Neon|Ride"] = 182.81, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 840.48}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2546.24}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 145.59, ["Ride"] = 190.41, ["Fly|Ride"] = 10498.95, ["Neon"] = 712.81, ["Neon|Ride"] = 619.94, ["Mega|Fly|Ride"] = 1779.71}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 108.93, ["Ride"] = 100.42, ["Fly|Ride"] = 418.73, ["Neon"] = 773.85, ["Neon|Ride"] = 612.38, ["Neon|Fly|Ride"] = 656.25, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 1392.57}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 140.43, ["Fly"] = 260.56, ["Ride"] = 147, ["Fly|Ride"] = 196.88, ["Neon"] = 820.32, ["Neon|Ride"] = 671.98, ["Neon|Fly|Ride"] = 836.63, ["Mega|Fly|Ride"] = 2936.07}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1050, ["Fly"] = 2521.41, ["Ride"] = 1050, ["Fly|Ride"] = 1097.97, ["Neon|Fly|Ride"] = 4580.56, ["Mega|Fly|Ride"] = 21011.67}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 18.36, ["Fly"] = 81.97, ["Ride"] = 41, ["Fly|Ride"] = 49.4, ["Neon"] = 105, ["Neon|Ride"] = 155.57, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 928.73, ["Mega|Ride"] = 774.35, ["Mega|Fly|Ride"] = 790.06}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 577.5, ["Fly"] = 2100, ["Ride"] = 689.07, ["Fly|Ride"] = 745.5, ["Neon|Fly|Ride"] = 4024.86}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 48.57}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 9.19, ["Fly"] = 144.38, ["Ride"] = 26.72, ["Fly|Ride"] = 98.44, ["Neon"] = 52.5, ["Neon|Ride"] = 155.57, ["Neon|Fly|Ride"] = 309.94, ["Mega"] = 393.37, ["Mega|Ride"] = 387.76, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 7.2, ["Fly"] = 348.29, ["Ride"] = 23.67, ["Fly|Ride"] = 72.19, ["Neon"] = 53.6, ["Neon|Ride"] = 70.41, ["Neon|Fly|Ride"] = 202.18, ["Mega|Ride"] = 387.76, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 59.89}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 13.12, ["Ride"] = 23.78, ["Fly|Ride"] = 65.54, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 542.15, ["Mega|Fly|Ride"] = 1238.7}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 39.83, ["Fly"] = 39.38, ["Ride"] = 26.25, ["Fly|Ride"] = 76.39, ["Neon"] = 139.32, ["Neon|Fly"] = 241.48, ["Neon|Ride"] = 262.66, ["Neon|Fly|Ride"] = 274.32, ["Mega"] = 1399.39, ["Mega|Ride"] = 960.25, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 5248.95, ["Fly"] = 11206.59, ["Ride"] = 6088.14, ["Fly|Ride"] = 4921.88, ["Neon|Fly|Ride"] = 9711.19, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 10.5, ["Fly"] = 40.62, ["Ride"] = 24.05, ["Fly|Ride"] = 105, ["Neon"] = 49.39, ["Neon|Fly"] = 137, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 155.57, ["Mega"] = 278.55, ["Mega|Ride"] = 343.55, ["Mega|Fly|Ride"] = 454.65}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 22.32}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 103.69, ["Fly"] = 371.91, ["Ride"] = 131.24, ["Fly|Ride"] = 167.89, ["Neon"] = 284.21, ["Neon|Ride"] = 347.71, ["Neon|Fly|Ride"] = 475.13, ["Mega|Fly|Ride"] = 1443.75}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 55.13, ["Fly"] = 138.69, ["Ride"] = 59.07, ["Fly|Ride"] = 91.88, ["Neon"] = 210.04, ["Neon|Ride"] = 378, ["Neon|Fly|Ride"] = 430.53, ["Mega|Ride"] = 1346.66, ["Mega|Fly|Ride"] = 1050.59}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 19.69, ["Fly"] = 70.75, ["Ride"] = 31.47, ["Fly|Ride"] = 63.1, ["Neon"] = 140.79, ["Neon|Ride"] = 115.34, ["Neon|Fly|Ride"] = 171.94, ["Mega|Fly|Ride"] = 484.26}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 3.94, ["Fly"] = 32.81, ["Ride"] = 18.51, ["Fly|Ride"] = 67.35, ["Neon"] = 19.11, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 126.19, ["Mega"] = 152.25, ["Mega|Fly"] = 146.05, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 8.87, ["Ride"] = 23.23, ["Fly|Ride"] = 52.41, ["Neon"] = 51.19, ["Neon|Ride"] = 63.06, ["Neon|Fly|Ride"] = 149.63, ["Mega"] = 330.95, ["Mega|Ride"] = 419.99, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 14.23, ["Fly"] = 21.55, ["Ride"] = 20.98, ["Fly|Ride"] = 39.48, ["Neon"] = 208.69, ["Neon|Fly"] = 210.13, ["Neon|Ride"] = 105.08, ["Neon|Fly|Ride"] = 127.32, ["Mega|Fly"] = 700.75, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 177.19}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 18.12, ["Fly"] = 124.24, ["Ride"] = 98.44, ["Neon"] = 92.87, ["Neon|Ride"] = 392.93, ["Mega"] = 1356.32, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 35.74, ["Ride"] = 377.18}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 36.58, ["Ride"] = 92.54, ["Fly|Ride"] = 181.15, ["Neon"] = 166.01, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 733.71, ["Mega"] = 1183.88, ["Mega|Ride"] = 1037.99, ["Mega|Fly|Ride"] = 958.13}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 656.25, ["Fly"] = 773.01, ["Ride"] = 590.63, ["Fly|Ride"] = 649.69, ["Neon"] = 2227.25, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 1837.5, ["Mega|Fly|Ride"] = 7585.35}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 210.31, ["Ride"] = 202.01, ["Fly|Ride"] = 263.48, ["Neon"] = 1154.61, ["Neon|Fly"] = 3406.1, ["Neon|Ride"] = 1065.3, ["Neon|Fly|Ride"] = 1086.31, ["Mega"] = 8264.95, ["Mega|Ride"] = 4063.18, ["Mega|Fly|Ride"] = 4335.99}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 76.13}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.37}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 7.87, ["Fly"] = 23.09, ["Ride"] = 21.76, ["Fly|Ride"] = 44.08, ["Neon"] = 80.07, ["Neon|Ride"] = 63.06, ["Neon|Fly|Ride"] = 124.69, ["Mega|Ride"] = 309.94, ["Mega|Fly|Ride"] = 379.32}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 347.82, ["Fly"] = 600.08, ["Ride"] = 372.75, ["Fly|Ride"] = 411.76, ["Neon"] = 1176.81, ["Neon|Ride"] = 945, ["Neon|Fly|Ride"] = 905.63, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 31.5}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 90.48, ["Fly"] = 178.12, ["Ride"] = 140.79, ["Fly|Ride"] = 248.3, ["Neon"] = 459.38, ["Neon|Fly"] = 1273.32, ["Neon|Ride"] = 486.94, ["Neon|Fly|Ride"] = 519.75, ["Mega"] = 2086.47, ["Mega|Fly|Ride"] = 1770.09}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 133.72, ["Ride"] = 137.82, ["Fly|Ride"] = 130.29, ["Neon|Ride"] = 997.5, ["Neon|Fly|Ride"] = 700.07}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 5.25, ["Ride"] = 17.07, ["Fly|Ride"] = 62.83, ["Neon"] = 70.41, ["Neon|Ride"] = 42.05, ["Neon|Fly|Ride"] = 168.11, ["Mega"] = 240.19, ["Mega|Ride"] = 509.55, ["Mega|Fly|Ride"] = 546.31}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 13, ["Fly"] = 42, ["Ride"] = 26.24, ["Fly|Ride"] = 105.08, ["Neon"] = 67.71, ["Neon|Ride"] = 155.57, ["Neon|Fly|Ride"] = 196.45, ["Mega|Ride"] = 735.42, ["Mega|Fly|Ride"] = 619.94}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 10.48, ["Fly"] = 140.79, ["Ride"] = 53.6, ["Fly|Ride"] = 98.75, ["Neon"] = 164.07, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 185.76, ["Mega"] = 328.13, ["Mega|Ride"] = 353.93, ["Mega|Fly|Ride"] = 525.31}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 4.19, ["Fly"] = 336.2, ["Ride"] = 30.34, ["Fly|Ride"] = 155.5, ["Neon"] = 18.94, ["Neon|Fly"] = 69.57, ["Neon|Ride"] = 52.54, ["Neon|Fly|Ride"] = 114.43, ["Mega"] = 140.44, ["Mega|Fly"] = 189, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 248.07, ["Fly"] = 918.75, ["Ride"] = 236.25, ["Fly|Ride"] = 315, ["Neon|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 1721.08, ["Mega|Fly|Ride"] = 6303.51}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 91.88, ["Fly"] = 1049.9, ["Ride"] = 140.79, ["Fly|Ride"] = 225.32, ["Neon"] = 546.32, ["Neon|Ride"] = 479.07, ["Neon|Fly|Ride"] = 525, ["Mega"] = 1870.05, ["Mega|Ride"] = 1994.03, ["Mega|Fly|Ride"] = 1825.93}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 59.07, ["Fly"] = 155.5, ["Ride"] = 77.44, ["Fly|Ride"] = 132.39, ["Neon"] = 557.87, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 425.25, ["Mega"] = 1610.19, ["Mega|Ride"] = 1656.63, ["Mega|Fly|Ride"] = 1365}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 22.05, ["Fly"] = 52.5, ["Ride"] = 58.22, ["Fly|Ride"] = 280.52, ["Neon"] = 210.13, ["Neon|Ride"] = 589.75, ["Neon|Fly|Ride"] = 489.59, ["Mega"] = 1121, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 14.43, ["Ride"] = 32.27, ["Fly|Ride"] = 95.48, ["Neon"] = 69.35, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 210.1, ["Mega"] = 356.42, ["Mega|Fly"] = 525, ["Mega|Ride"] = 315.15, ["Mega|Fly|Ride"] = 557.26}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 2.6, ["Fly"] = 53.59, ["Ride"] = 15.74, ["Fly|Ride"] = 67.26, ["Neon"] = 14.34, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 140.78, ["Mega"] = 208.98, ["Mega|Ride"] = 168, ["Mega|Fly|Ride"] = 213.94}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 971.25, ["Fly"] = 1120.7, ["Ride"] = 913.5, ["Fly|Ride"] = 939.75, ["Neon"] = 3018.37, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2218.13, ["Mega|Fly|Ride"] = 6746.25}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 211.47, ["Fly"] = 496.89, ["Ride"] = 236.25, ["Fly|Ride"] = 328.12, ["Neon|Ride"] = 781.65, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 10505.84, ["Mega|Fly|Ride"] = 3046.71}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 93.18, ["Ride"] = 98.77, ["Fly|Ride"] = 195.57, ["Neon"] = 354.38, ["Neon|Ride"] = 319.55, ["Neon|Fly|Ride"] = 367.7, ["Mega"] = 1640.63, ["Mega|Ride"] = 1680.95, ["Mega|Fly|Ride"] = 1539.37}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 131.25, ["Fly"] = 226.95, ["Ride"] = 144.38, ["Fly|Ride"] = 200.97, ["Neon"] = 672.39, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 675.09, ["Mega"] = 10505.84, ["Mega|Fly|Ride"] = 2727.33}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 12.71, ["Fly"] = 48.35, ["Ride"] = 25.92, ["Fly|Ride"] = 68.25, ["Neon"] = 157.49, ["Neon|Ride"] = 291.37, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 532.66, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 774.35}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 216.03, ["Ride"] = 317.63, ["Neon"] = 981.26, ["Neon|Ride"] = 1342.66, ["Neon|Fly|Ride"] = 1090.69, ["Mega"] = 5244.75, ["Mega|Fly|Ride"] = 3923.94}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 98.76, ["Fly"] = 188.07, ["Ride"] = 98.77, ["Fly|Ride"] = 92.89, ["Neon|Ride"] = 464.38, ["Neon|Fly|Ride"] = 571.53, ["Mega|Fly|Ride"] = 1732.5}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1160.45, ["Ride"] = 1049.54, ["Fly|Ride"] = 1355.81, ["Neon"] = 13125, ["Neon|Ride"] = 3782.12, ["Neon|Fly|Ride"] = 4482.85, ["Mega"] = 50428, ["Mega|Fly|Ride"] = 23095.02}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 10.5, ["Fly"] = 48.2, ["Ride"] = 35.74, ["Fly|Ride"] = 93.11, ["Neon"] = 37.85, ["Neon|Fly"] = 140.79, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 155.4, ["Mega"] = 191.02, ["Mega|Ride"] = 263.71, ["Mega|Fly|Ride"] = 420.25}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 37.65, ["Ride"] = 64.11, ["Fly|Ride"] = 84.07, ["Neon"] = 148.32, ["Neon|Ride"] = 202.83, ["Neon|Fly|Ride"] = 413.34, ["Mega"] = 2916.38, ["Mega|Ride"] = 940.29, ["Mega|Fly|Ride"] = 1091.56}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 74.97, ["Fly"] = 88.27, ["Ride"] = 65.49, ["Fly|Ride"] = 78.75, ["Neon|Ride"] = 410.82, ["Neon|Fly|Ride"] = 353.07, ["Mega|Fly|Ride"] = 1401.65}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2695.63, ["Ride"] = 918.75, ["Fly|Ride"] = 842.58, ["Neon|Fly|Ride"] = 4199.99, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 323.96, ["Ride"] = 457.03, ["Fly|Ride"] = 403.44, ["Neon|Ride"] = 1680.95, ["Neon|Fly|Ride"] = 1260, ["Mega|Fly|Ride"] = 9132.84}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 98.44, ["Fly"] = 209.84, ["Ride"] = 148.58, ["Fly|Ride"] = 198.18, ["Neon"] = 525.31, ["Neon|Ride"] = 429.99, ["Neon|Fly|Ride"] = 471.19, ["Mega"] = 3957.33, ["Mega|Ride"] = 4202.35, ["Mega|Fly|Ride"] = 1681.15}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 6.07, ["Fly"] = 39.38, ["Ride"] = 16.78, ["Fly|Ride"] = 87.94, ["Neon"] = 49.4, ["Neon|Ride"] = 70.41, ["Neon|Fly|Ride"] = 155.57, ["Mega"] = 638.51, ["Mega|Ride"] = 508.59, ["Mega|Fly|Ride"] = 810.02}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 27.39, ["Fly"] = 70.41, ["Ride"] = 48.35, ["Fly|Ride"] = 80.07, ["Neon"] = 209.9, ["Neon|Fly"] = 280.52, ["Neon|Ride"] = 205.91, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 1817.52, ["Mega|Fly|Ride"] = 1022.11}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 664.75, ["Fly"] = 894.37, ["Ride"] = 809.33, ["Fly|Ride"] = 904.53, ["Neon|Fly|Ride"] = 2962.15, ["Mega|Fly|Ride"] = 12847.72}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 761.25}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4202.35, ["Ride"] = 3774.75, ["Fly|Ride"] = 3360, ["Neon|Ride"] = 30110.77, ["Neon|Fly|Ride"] = 13125, ["Mega|Fly|Ride"] = 89650.46}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 149.63, ["Fly"] = 408.19, ["Ride"] = 420.25, ["Fly|Ride"] = 380.63, ["Neon"] = 851.82, ["Neon|Ride"] = 1238.7, ["Neon|Fly|Ride"] = 851.82, ["Mega"] = 5883.28, ["Mega|Fly|Ride"] = 4622.59}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 97.88, ["Ride"] = 122.07, ["Fly|Ride"] = 336, ["Neon|Ride"] = 464.38, ["Neon|Fly|Ride"] = 459.38, ["Mega|Fly|Ride"] = 2241.96}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 13.95, ["Fly"] = 131.25, ["Ride"] = 21.63, ["Fly|Ride"] = 52.5, ["Neon"] = 96.67, ["Neon|Fly"] = 328.13, ["Neon|Ride"] = 102.68, ["Neon|Fly|Ride"] = 140.78, ["Mega"] = 689.2, ["Mega|Ride"] = 840.48, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 8.65, ["Fly"] = 39.38, ["Ride"] = 22.91, ["Fly|Ride"] = 45.93, ["Neon|Ride"] = 155.57, ["Neon|Fly|Ride"] = 280.52, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 699.7}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 17.07, ["Ride"] = 39.77, ["Fly|Ride"] = 105, ["Neon"] = 65.03, ["Neon|Ride"] = 86.82, ["Neon|Fly|Ride"] = 187.69, ["Mega"] = 1176.67, ["Mega|Ride"] = 859.69, ["Mega|Fly|Ride"] = 679.74}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.92, ["Ride"] = 27.9, ["Fly|Ride"] = 244.44, ["Neon"] = 52.45, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 155.54, ["Mega"] = 210, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 357}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 18.38, ["Ride"] = 38.07, ["Fly|Ride"] = 127.32, ["Neon"] = 126.09, ["Neon|Ride"] = 185.76, ["Neon|Fly|Ride"] = 315.19, ["Mega"] = 672.39, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 706.01}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 216.57, ["Fly"] = 294.74, ["Ride"] = 255.44, ["Fly|Ride"] = 255.94, ["Neon"] = 728.1, ["Neon|Ride"] = 681.19, ["Neon|Fly|Ride"] = 677.25, ["Mega"] = 6562.5, ["Mega|Ride"] = 4202.35, ["Mega|Fly|Ride"] = 3417.57}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.24, ["Fly"] = 15.43, ["Ride"] = 12.07, ["Fly|Ride"] = 27.34, ["Neon"] = 19.69, ["Neon|Fly"] = 92.89, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.56, ["Mega"] = 157.5, ["Mega|Ride"] = 196.47, ["Mega|Fly|Ride"] = 266.86}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 31.39, ["Fly"] = 76.53, ["Ride"] = 52.5, ["Fly|Ride"] = 99.67, ["Neon"] = 144.38, ["Neon|Fly"] = 150.94, ["Neon|Ride"] = 139.12, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 525, ["Mega|Ride"] = 468.96, ["Mega|Fly|Ride"] = 458.06}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 721.88, ["Fly"] = 787.5, ["Ride"] = 670.69, ["Fly|Ride"] = 761.25, ["Neon|Ride"] = 1821.73, ["Neon|Fly|Ride"] = 1433.25, ["Mega|Fly|Ride"] = 3927}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 26.72, ["Fly"] = 59.21, ["Ride"] = 39.37, ["Fly|Ride"] = 75.64, ["Neon"] = 262.5, ["Neon|Fly"] = 464.38, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 187.69, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 242.8, ["Fly"] = 350.9, ["Ride"] = 223.13, ["Fly|Ride"] = 301.53, ["Neon"] = 1401.49, ["Neon|Fly|Ride"] = 1030.32, ["Mega|Fly|Ride"] = 4175.04}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 110.77, ["Fly"] = 139.1, ["Ride"] = 106.32, ["Fly|Ride"] = 135.19, ["Neon"] = 590.63, ["Neon|Fly"] = 638.76, ["Neon|Ride"] = 556.08, ["Neon|Fly|Ride"] = 543.37, ["Mega"] = 2941.65, ["Mega|Fly|Ride"] = 1730.06}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 622.13, ["Ride"] = 586.69, ["Fly|Ride"] = 623.44, ["Neon|Ride"] = 2395.34, ["Neon|Fly|Ride"] = 2411.07, ["Mega|Fly|Ride"] = 7732.31}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 18.38, ["Ride"] = 44.1, ["Neon"] = 68.28, ["Neon|Fly"] = 182.81, ["Neon|Ride"] = 117.42, ["Neon|Fly|Ride"] = 246.12, ["Mega"] = 388.67, ["Mega|Ride"] = 465.43, ["Mega|Fly|Ride"] = 436.01}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3675, ["Fly"] = 3939.31, ["Ride"] = 3684.4, ["Fly|Ride"] = 2861.25, ["Neon"] = 13972.76, ["Neon|Fly|Ride"] = 5643.75, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 60.38, ["Fly"] = 98.77, ["Ride"] = 98.43, ["Fly|Ride"] = 113.38, ["Neon"] = 394.77, ["Neon|Fly"] = 417.94, ["Neon|Ride"] = 399.24, ["Neon|Fly|Ride"] = 400.32, ["Mega|Fly|Ride"] = 1680.95}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 17.07, ["Fly|Ride"] = 43.61, ["Neon"] = 15.3, ["Neon|Fly"] = 44.63, ["Neon|Ride"] = 36.11, ["Neon|Fly|Ride"] = 77.8, ["Mega"] = 199.5, ["Mega|Fly"] = 452.82, ["Mega|Ride"] = 153.4, ["Mega|Fly|Ride"] = 204.87}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 2.49, ["Ride"] = 23.62, ["Neon"] = 19.69, ["Neon|Ride"] = 56.11, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 153.57, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 35.68, ["Fly"] = 65.63, ["Ride"] = 64.32, ["Fly|Ride"] = 54.57, ["Neon|Ride"] = 266.86, ["Neon|Fly|Ride"] = 240.19, ["Mega|Fly|Ride"] = 1141.88}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 874.1, ["Ride"] = 888.57, ["Fly|Ride"] = 982.09, ["Neon"] = 6303.51, ["Neon|Ride"] = 5252.92, ["Neon|Fly|Ride"] = 3543.75, ["Mega|Fly|Ride"] = 19611.24}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 4902.03, ["Ride"] = 4973.48, ["Fly|Ride"] = 4725}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 18.59, ["Fly"] = 19.88, ["Ride"] = 20.9, ["Fly|Ride"] = 47.24, ["Neon"] = 452.12, ["Neon|Ride"] = 140.79, ["Neon|Fly|Ride"] = 102.37, ["Mega"] = 2521.41, ["Mega|Fly|Ride"] = 558.93}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 13.12, ["Fly"] = 31.49, ["Ride"] = 23.23, ["Fly|Ride"] = 70.33, ["Neon"] = 81.97, ["Neon|Fly"] = 210.13, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 136.5, ["Mega"] = 928.52, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 539.65}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 35.74, ["Fly"] = 157.45, ["Ride"] = 40.14, ["Fly|Ride"] = 77.16, ["Neon"] = 463.26, ["Neon|Ride"] = 251.9, ["Neon|Fly|Ride"] = 291.84, ["Mega|Fly|Ride"] = 1130.74}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 229.69, ["Ride"] = 222.92, ["Fly|Ride"] = 291.89, ["Neon|Ride"] = 1048.69, ["Neon|Fly|Ride"] = 1111.53, ["Mega"] = 10505.84, ["Mega|Fly|Ride"] = 3655.32}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.73, ["Ride"] = 65.63, ["Fly|Ride"] = 105, ["Neon"] = 15.72, ["Neon|Fly"] = 70.95, ["Neon|Ride"] = 104.03, ["Neon|Fly|Ride"] = 155.57, ["Mega"] = 120.22, ["Mega|Ride"] = 195.42, ["Mega|Fly|Ride"] = 294.18}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 157.5, ["Fly"] = 290.25, ["Ride"] = 189.12, ["Fly|Ride"] = 236.25, ["Neon"] = 645.07, ["Neon|Ride"] = 708.18, ["Neon|Fly|Ride"] = 733.69, ["Mega"] = 3489, ["Mega|Fly|Ride"] = 2624.99}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.63, ["Fly"] = 27.76, ["Ride"] = 13.58, ["Fly|Ride"] = 43.55, ["Neon"] = 24.94, ["Neon|Ride"] = 32.58, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 309.98, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 433.12}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 153.11, ["Fly"] = 271.07, ["Ride"] = 190.32, ["Fly|Ride"] = 196.45, ["Neon|Fly|Ride"] = 891.19, ["Mega"] = 10505.84, ["Mega|Fly|Ride"] = 3782.12}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 8.71, ["Fly"] = 420.25, ["Ride"] = 25.47, ["Fly|Ride"] = 63.06, ["Neon"] = 56.75, ["Neon|Fly"] = 294.88, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 392.93, ["Mega"] = 550.28, ["Mega|Ride"] = 588.34, ["Mega|Fly|Ride"] = 483.29}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Fly|Ride"] = 111.57, ["Neon"] = 9.56, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 35.74, ["Neon|Fly|Ride"] = 103.59, ["Mega"] = 89.25, ["Mega|Fly"] = 420.25, ["Mega|Ride"] = 100.79, ["Mega|Fly|Ride"] = 213.94}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 4.23, ["Mega"] = 23.35, ["Mega|Ride"] = 39.35, ["Mega|Fly|Ride"] = 166.01}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Ride"] = 56.75, ["Fly|Ride"] = 140.79, ["Neon"] = 9.19, ["Neon|Ride"] = 29.64, ["Neon|Fly|Ride"] = 112.43, ["Mega"] = 83.2, ["Mega|Fly"] = 154787.8, ["Mega|Ride"] = 101.93, ["Mega|Fly|Ride"] = 190.25}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 55.12, ["Fly"] = 525, ["Ride"] = 84.79, ["Fly|Ride"] = 155.5, ["Neon"] = 203.44, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 354.38, ["Mega|Ride"] = 1311.19, ["Mega|Fly|Ride"] = 1117.85}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 45.82, ["Ride"] = 18.38, ["Fly|Ride"] = 29.01, ["Neon"] = 6.29, ["Neon|Ride"] = 40.62, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 126.05, ["Mega|Ride"] = 137.71, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 6.46, ["Ride"] = 59.05, ["Neon"] = 59.07, ["Neon|Ride"] = 98.44, ["Mega"] = 420, ["Mega|Ride"] = 543.63}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 252.16, ["Mega"] = 21.04, ["Mega|Ride"] = 30.45, ["Mega|Fly|Ride"] = 155.5}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 17.03, ["Ride"] = 21.04, ["Fly|Ride"] = 35.74, ["Neon"] = 2.1, ["Neon|Fly"] = 21.04, ["Neon|Ride"] = 12.13, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 15.44, ["Mega|Ride"] = 15.96, ["Mega|Fly|Ride"] = 55.47}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.05, ["Ride"] = 14.91, ["Fly|Ride"] = 32.65, ["Neon"] = 2.15, ["Neon|Fly"] = 39.35, ["Neon|Ride"] = 12.63, ["Neon|Fly|Ride"] = 41.91, ["Mega"] = 17.43, ["Mega|Ride"] = 36.01, ["Mega|Fly|Ride"] = 84}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.05, ["Ride"] = 33.64, ["Neon"] = 2.1, ["Mega"] = 13.79, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 217.1}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 11.82, ["Fly|Ride"] = 105.08, ["Neon"] = 6.33, ["Neon|Ride"] = 92.46, ["Neon|Fly|Ride"] = 73.37, ["Mega"] = 24.72, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 83.02, ["Mega|Fly|Ride"] = 119.78}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.39, ["Neon|Fly|Ride"] = 140.63, ["Mega"] = 17.07, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 420.25}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 40.65, ["Ride"] = 19.11, ["Fly|Ride"] = 48.49, ["Neon"] = 3.52, ["Neon|Fly"] = 37.96, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 35.43, ["Mega"] = 54.05, ["Mega|Fly"] = 95.6, ["Mega|Ride"] = 70.43, ["Mega|Fly|Ride"] = 98.36}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Mega"] = 15.74, ["Mega|Ride"] = 45.85, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.33, ["Ride"] = 141.84, ["Fly|Ride"] = 525, ["Neon"] = 14.02, ["Mega"] = 118.13, ["Mega|Fly|Ride"] = 210.13}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 3.81, ["Ride"] = 56.73, ["Neon"] = 30.49}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Neon"] = 3.92, ["Neon|Ride"] = 35.44, ["Mega"] = 19.67, ["Mega|Ride"] = 155.57, ["Mega|Fly|Ride"] = 140.79}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.05, ["Fly"] = 26.25, ["Ride"] = 14.91, ["Fly|Ride"] = 38.89, ["Neon"] = 2.1, ["Neon|Fly"] = 33.63, ["Neon|Ride"] = 15.78, ["Neon|Fly|Ride"] = 37.43, ["Mega"] = 14.44, ["Mega|Fly"] = 65.63, ["Mega|Ride"] = 20.93, ["Mega|Fly|Ride"] = 39.38}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 3.94, ["Fly"] = 72.19, ["Ride"] = 218.19, ["Neon"] = 37.84, ["Mega"] = 251.11, ["Mega|Ride"] = 350.9}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 18.02, ["Fly|Ride"] = 78.73, ["Neon"] = 3.71, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 63.06, ["Mega"] = 28.87, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 88.82}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.1, ["Ride"] = 70.41, ["Neon"] = 6.29, ["Neon|Fly|Ride"] = 140.79, ["Mega"] = 40.82, ["Mega|Ride"] = 233.63, ["Mega|Fly|Ride"] = 420.25}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 656.25, ["Ride"] = 32.81, ["Fly|Ride"] = 191.22, ["Neon"] = 8.91, ["Neon|Fly"] = 91.73, ["Neon|Ride"] = 42.05, ["Neon|Fly|Ride"] = 271.07, ["Mega"] = 56.75, ["Mega|Fly|Ride"] = 280.26}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.05, ["Fly"] = 13.05, ["Ride"] = 12.65, ["Fly|Ride"] = 20.57, ["Neon"] = 2.1, ["Neon|Fly"] = 14.32, ["Neon|Ride"] = 11.82, ["Neon|Fly|Ride"] = 22.32, ["Mega"] = 17.07, ["Mega|Fly"] = 23.63, ["Mega|Ride"] = 18.57, ["Mega|Fly|Ride"] = 49.09}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 14.36, ["Fly|Ride"] = 42, ["Neon"] = 15.72, ["Neon|Ride"] = 111.46, ["Neon|Fly|Ride"] = 63.06, ["Mega"] = 78.81, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 201.72}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 4.23, ["Fly"] = 112.88, ["Neon"] = 23.23, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 278.15, ["Mega|Ride"] = 418.15, ["Mega|Fly|Ride"] = 344.6}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 14.26, ["Ride"] = 13.12, ["Fly|Ride"] = 28.39, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 13.79, ["Neon|Fly|Ride"] = 39.95, ["Mega"] = 15.89, ["Mega|Fly"] = 156.19, ["Mega|Ride"] = 41.82, ["Mega|Fly|Ride"] = 117.95}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.63, ["Ride"] = 22.32, ["Neon"] = 3.93, ["Neon|Fly"] = 77.76, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 105, ["Mega"] = 54.66, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 309.94}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 28.39, ["Fly|Ride"] = 131.25, ["Neon"] = 3.93, ["Neon|Ride"] = 81.97, ["Neon|Fly|Ride"] = 309.98, ["Mega"] = 29.29, ["Mega|Ride"] = 155.57, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 40.69, ["Neon|Ride"] = 33.66, ["Neon|Fly|Ride"] = 43.51, ["Mega"] = 15.75, ["Mega|Ride"] = 77.76, ["Mega|Fly|Ride"] = 187.78}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Ride"] = 19.95, ["Fly|Ride"] = 77.75, ["Neon"] = 9.17, ["Neon|Fly"] = 42.05, ["Neon|Ride"] = 44.5, ["Neon|Fly|Ride"] = 116.63, ["Mega"] = 90.57, ["Mega|Ride"] = 59.06, ["Mega|Fly|Ride"] = 496.89}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 18.38, ["Neon"] = 8.87, ["Neon|Ride"] = 48.29, ["Mega"] = 68.14, ["Mega|Ride"] = 120.46, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 28.39, ["Ride"] = 14.31, ["Fly|Ride"] = 36.79, ["Neon"] = 3.75, ["Neon|Fly"] = 70.41, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 59.07, ["Mega|Ride"] = 132.17, ["Mega|Fly|Ride"] = 140.79}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 6.12, ["Ride"] = 82.62, ["Neon"] = 46.71, ["Mega"] = 296.63, ["Mega|Ride"] = 700.75, ["Mega|Fly|Ride"] = 774.35}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 19.99, ["Ride"] = 14.44, ["Fly|Ride"] = 56.44, ["Neon"] = 8.52, ["Neon|Fly"] = 81.97, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 142.77, ["Mega"] = 315, ["Mega|Ride"] = 263.71, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.55, ["Fly"] = 16.83, ["Ride"] = 19.69, ["Fly|Ride"] = 33.66, ["Neon"] = 12.5, ["Neon|Fly"] = 56.17, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 106.32, ["Mega"] = 128.62, ["Mega|Ride"] = 150.94, ["Mega|Fly|Ride"] = 197.12}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 6.57, ["Fly"] = 79.47, ["Fly|Ride"] = 106.32, ["Neon"] = 29.48, ["Neon|Fly"] = 182.81}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 12.63, ["Neon|Ride"] = 140.79, ["Mega"] = 634.56, ["Mega|Ride"] = 981.26, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 28.88, ["Ride"] = 34.74, ["Fly|Ride"] = 47.86, ["Neon"] = 23.63, ["Mega"] = 362.21, ["Mega|Ride"] = 561.03, ["Mega|Fly|Ride"] = 137.64}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 3.93, ["Ride"] = 67.55, ["Fly|Ride"] = 131.25, ["Neon"] = 42.05, ["Neon|Ride"] = 155.5, ["Mega"] = 217.55, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 406.59}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.56, ["Neon|Ride"] = 120.83, ["Mega"] = 15.75, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 52.49}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 3.94, ["Fly"] = 21.2, ["Ride"] = 15.31, ["Fly|Ride"] = 51.19, ["Neon"] = 27.04, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 28.25, ["Neon|Fly|Ride"] = 66.98, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 222.8}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.05, ["Fly"] = 21.04, ["Ride"] = 15.78, ["Neon"] = 3.39, ["Neon|Ride"] = 39.48, ["Neon|Fly|Ride"] = 155.57, ["Mega"] = 19.69, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 175.46}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 119.48, ["Fly|Ride"] = 387.76, ["Neon"] = 3.51, ["Neon|Ride"] = 44.61, ["Mega"] = 36.69, ["Mega|Ride"] = 62.29, ["Mega|Fly|Ride"] = 116.82}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.52, ["Fly"] = 45.94, ["Ride"] = 24.94, ["Neon"] = 13.13, ["Neon|Ride"] = 19.95, ["Neon|Fly|Ride"] = 87.28, ["Mega"] = 280.52, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 309.98}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.67, ["Ride"] = 22.56, ["Neon"] = 48.35, ["Neon|Ride"] = 62.7, ["Neon|Fly|Ride"] = 172.6, ["Mega"] = 313.69}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 25.87, ["Mega"] = 13.13, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 43.79, ["Mega|Fly|Ride"] = 161.44}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.05, ["Ride"] = 18.94, ["Fly|Ride"] = 280155.83, ["Neon"] = 3.94, ["Neon|Fly"] = 68.83, ["Neon|Ride"] = 19.48, ["Neon|Fly|Ride"] = 66.21, ["Mega"] = 35.43, ["Mega|Fly"] = 84.07, ["Mega|Ride"] = 58.35, ["Mega|Fly|Ride"] = 95.49}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.25, ["Ride"] = 11.82, ["Fly|Ride"] = 59.9, ["Neon"] = 2.56, ["Neon|Fly"] = 102.98, ["Neon|Ride"] = 18.36, ["Neon|Fly|Ride"] = 74.82, ["Mega"] = 140.79, ["Mega|Ride"] = 61.19, ["Mega|Fly|Ride"] = 133.44}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Ride"] = 280.52, ["Neon"] = 2.9, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 70.33, ["Mega"] = 17.71, ["Mega|Fly"] = 84.07, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 32.59, ["Neon|Fly|Ride"] = 120.83, ["Mega"] = 20.91, ["Mega|Fly"] = 105, ["Mega|Ride"] = 66.07, ["Mega|Fly|Ride"] = 149.52}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 53.6, ["Ride"] = 19.69, ["Neon"] = 2.1, ["Neon|Fly"] = 45.93, ["Neon|Ride"] = 25.24, ["Neon|Fly|Ride"] = 43.32, ["Mega"] = 16.94, ["Mega|Ride"] = 37.95, ["Mega|Fly|Ride"] = 109.14}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.05, ["Neon"] = 2.1, ["Neon|Ride"] = 70.88, ["Mega"] = 14.44, ["Mega|Ride"] = 205.33}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.63, ["Neon"] = 3.42, ["Neon|Fly"] = 70.41, ["Neon|Ride"] = 77.8, ["Neon|Fly|Ride"] = 420, ["Mega"] = 21.57, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 27.45, ["Ride"] = 13.9, ["Fly|Ride"] = 52.5, ["Neon"] = 2.52, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 74.82, ["Mega"] = 38.21, ["Mega|Ride"] = 48.57, ["Mega|Fly|Ride"] = 118.11}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 12.59, ["Ride"] = 59.07, ["Neon"] = 168, ["Neon|Ride"] = 78.68, ["Mega"] = 415, ["Mega|Ride"] = 479.73, ["Mega|Fly|Ride"] = 524.26}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.56, ["Ride"] = 39.38, ["Neon"] = 94.5, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 420.25, ["Mega|Ride"] = 343.23, ["Mega|Fly|Ride"] = 630.36}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 3.51, ["Ride"] = 42.05, ["Fly|Ride"] = 344.02, ["Neon"] = 24.19, ["Neon|Ride"] = 280.52, ["Mega"] = 211.74, ["Mega|Fly|Ride"] = 523.59}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.05, ["Fly"] = 12.86, ["Ride"] = 11.43, ["Fly|Ride"] = 36.74, ["Neon"] = 2.1, ["Neon|Fly"] = 13.13, ["Neon|Ride"] = 10.49, ["Neon|Fly|Ride"] = 17.72, ["Mega"] = 17.43, ["Mega|Fly"] = 21, ["Mega|Ride"] = 17.07, ["Mega|Fly|Ride"] = 38.53}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 3.7, ["Ride"] = 55.13, ["Neon"] = 11.08, ["Neon|Fly"] = 140.79, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 68.25, ["Mega|Ride"] = 155.57, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.5, ["Neon"] = 2.1, ["Neon|Fly"] = 31.36, ["Neon|Ride"] = 31.54, ["Neon|Fly|Ride"] = 79.04, ["Mega"] = 14.44, ["Mega|Fly"] = 32.81, ["Mega|Ride"] = 33.66, ["Mega|Fly|Ride"] = 207.83}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 60.9, ["Mega"] = 17.07, ["Mega|Ride"] = 79.86, ["Mega|Fly|Ride"] = 225.23}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 78.75, ["Ride"] = 13.57, ["Fly|Ride"] = 52.5, ["Neon"] = 9.19, ["Neon|Fly"] = 77.7, ["Neon|Ride"] = 32.59, ["Neon|Fly|Ride"] = 102.98, ["Mega"] = 116.6, ["Mega|Ride"] = 230.1, ["Mega|Fly|Ride"] = 191.87}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 199.4, ["Ride"] = 280.52, ["Fly|Ride"] = 326.82, ["Neon"] = 1362.92, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1281.72, ["Mega"] = 8404.68, ["Mega|Fly|Ride"] = 3923.94}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 21.04, ["Fly|Ride"] = 52.5, ["Neon"] = 10.19, ["Neon|Ride"] = 69.28, ["Mega"] = 69.67, ["Mega|Ride"] = 155.5, ["Mega|Fly|Ride"] = 420.19}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 7.34, ["Fly"] = 103.68, ["Ride"] = 24.1, ["Fly|Ride"] = 168.11, ["Neon"] = 42.56, ["Neon|Ride"] = 156.91, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 525, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 496.89}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.05, ["Fly"] = 21.17, ["Ride"] = 15.73, ["Fly|Ride"] = 27.57, ["Neon"] = 3.29, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 16.49, ["Neon|Fly|Ride"] = 43.32, ["Mega"] = 49.17, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 123.99}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Ride"] = 24.14, ["Fly|Ride"] = 121.88, ["Neon"] = 4.41, ["Neon|Fly"] = 42.05, ["Neon|Ride"] = 103.63, ["Mega"] = 84.04, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 209.08}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 4.64, ["Fly"] = 32.82, ["Ride"] = 15.74, ["Fly|Ride"] = 39.22, ["Neon"] = 23.62, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 51.19, ["Mega"] = 160.13, ["Mega|Ride"] = 163.89, ["Mega|Fly|Ride"] = 309.98}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 2.37, ["Ride"] = 39.6, ["Fly|Ride"] = 57.75, ["Neon"] = 32.82, ["Neon|Ride"] = 137.45, ["Neon|Fly|Ride"] = 624.06, ["Mega"] = 222.74, ["Mega|Ride"] = 348.29, ["Mega|Fly|Ride"] = 507.29}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 17.04, ["Ride"] = 12.73, ["Fly|Ride"] = 26.25, ["Neon"] = 19.04, ["Neon|Fly"] = 70.32, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 59.07, ["Mega|Fly"] = 384.57, ["Mega|Ride"] = 398.71, ["Mega|Fly|Ride"] = 351.93}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 65.3, ["Fly"] = 133.52, ["Ride"] = 92.61, ["Fly|Ride"] = 155.57, ["Neon"] = 387.63, ["Neon|Fly"] = 394.42, ["Neon|Ride"] = 351.63, ["Neon|Fly|Ride"] = 420, ["Mega|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 208.69, ["Fly"] = 315.15, ["Ride"] = 228.38, ["Fly|Ride"] = 281.72, ["Neon|Ride"] = 1121, ["Neon|Fly|Ride"] = 801.14, ["Mega"] = 10505.84, ["Mega|Fly|Ride"] = 3780}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 59.06, ["Fly"] = 104.99, ["Ride"] = 64.32, ["Fly|Ride"] = 111.57, ["Neon"] = 301.88, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 321.57, ["Mega|Fly|Ride"] = 1022.44}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 6.57, ["Ride"] = 278.19, ["Neon"] = 19.63, ["Neon|Ride"] = 70.33, ["Neon|Fly|Ride"] = 182.81, ["Mega"] = 243.75, ["Mega|Ride"] = 225.67, ["Mega|Fly|Ride"] = 382.43}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 10.17, ["Ride"] = 27.78, ["Fly|Ride"] = 38.06, ["Neon"] = 47.66, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 140.79, ["Mega"] = 419.2, ["Mega|Ride"] = 336, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.05, ["Fly"] = 25.24, ["Ride"] = 19.69, ["Fly|Ride"] = 51.17, ["Neon"] = 3.93, ["Neon|Fly"] = 129.93, ["Neon|Ride"] = 19.67, ["Neon|Fly|Ride"] = 65.58, ["Mega"] = 33.5, ["Mega|Fly"] = 65.63, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 134.43}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 5.25, ["Fly"] = 65.63, ["Ride"] = 22.32, ["Fly|Ride"] = 49.51, ["Neon"] = 18.75, ["Neon|Ride"] = 81.97, ["Neon|Fly|Ride"] = 140.79, ["Mega"] = 387.76, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 12.99, ["Ride"] = 16.26, ["Fly|Ride"] = 26.25, ["Neon"] = 7.65, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 22.97, ["Neon|Fly|Ride"] = 70.41, ["Mega"] = 131.24, ["Mega|Ride"] = 140.79, ["Mega|Fly|Ride"] = 309.98}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 3.45, ["Ride"] = 26.71, ["Fly|Ride"] = 328.13, ["Neon"] = 31.54, ["Neon|Ride"] = 56.75, ["Mega"] = 179.81, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 28.38, ["Ride"] = 105, ["Neon"] = 2.1, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 14.44, ["Mega|Ride"] = 51.5, ["Mega|Fly|Ride"] = 165.37}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 55.7, ["Ride"] = 27.77, ["Fly|Ride"] = 56.44, ["Neon"] = 8.56, ["Neon|Fly"] = 70.41, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 83.02, ["Mega"] = 140.51, ["Mega|Ride"] = 105.08, ["Mega|Fly|Ride"] = 192.29}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 36.74, ["Ride"] = 26.24, ["Fly|Ride"] = 26.13, ["Neon"] = 62.31, ["Neon|Ride"] = 56.75, ["Neon|Fly|Ride"] = 98.77, ["Mega"] = 155.5, ["Mega|Fly|Ride"] = 198.07}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 120.75, ["Fly"] = 243.7, ["Ride"] = 154.88, ["Fly|Ride"] = 183.74, ["Neon"] = 525.31, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 524.99, ["Mega|Fly|Ride"] = 1732.5}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.95, ["Ride"] = 240.91, ["Fly|Ride"] = 206.07, ["Neon"] = 19.69, ["Neon|Ride"] = 124.24, ["Neon|Fly|Ride"] = 196.47, ["Mega"] = 414.74, ["Mega|Ride"] = 420.25, ["Mega|Fly|Ride"] = 347.75}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 18.58, ["Ride"] = 17.28, ["Fly|Ride"] = 39.48, ["Neon"] = 12.53, ["Neon|Ride"] = 31.36, ["Neon|Fly|Ride"] = 140.78, ["Mega"] = 140.79, ["Mega|Ride"] = 202.01, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 18.94, ["Ride"] = 49.4, ["Fly|Ride"] = 156.33, ["Neon"] = 106.2, ["Neon|Ride"] = 81.99, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 540.02, ["Mega|Ride"] = 463.33, ["Mega|Fly|Ride"] = 489.46}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 3.35}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.1, ["Ride"] = 35.7, ["Neon"] = 24.71, ["Neon|Fly|Ride"] = 603.05, ["Mega"] = 288.75, ["Mega|Ride"] = 406.54, ["Mega|Fly|Ride"] = 542.15}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 18.52, ["Fly"] = 39.38, ["Ride"] = 32.45, ["Fly|Ride"] = 51.8, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 119.43, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 2101.18, ["Mega|Fly|Ride"] = 735.42}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 25.19, ["Neon"] = 2.39, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 63.06, ["Mega"] = 26.25, ["Mega|Ride"] = 61.05, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 4.19, ["Fly"] = 17.03, ["Ride"] = 28.35, ["Neon"] = 22.44, ["Neon|Ride"] = 232.2, ["Mega"] = 238.5, ["Mega|Fly"] = 387.76, ["Mega|Ride"] = 185.76, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 13.13, ["Fly|Ride"] = 49.76, ["Neon"] = 12.46, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 70.3, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 170.62}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.05, ["Ride"] = 15.78, ["Neon"] = 2.61, ["Neon|Ride"] = 31.35, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 20.69, ["Mega|Ride"] = 63.98, ["Mega|Fly|Ride"] = 116.63}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 19.69, ["Ride"] = 65.02, ["Fly|Ride"] = 98.44, ["Neon"] = 150.64, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 210.13, ["Mega"] = 774.38, ["Mega|Ride"] = 808.5, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 2.6, ["Ride"] = 48.35, ["Fly|Ride"] = 209.99, ["Neon"] = 44.88, ["Neon|Ride"] = 78.81, ["Mega"] = 231.04, ["Mega|Ride"] = 524.99}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 11.82, ["Fly"] = 75.02, ["Ride"] = 32.65, ["Fly|Ride"] = 99.83, ["Neon"] = 52.45, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 70.86, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 418.04, ["Mega|Ride"] = 301.53, ["Mega|Fly|Ride"] = 456.1}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 69.49, ["Fly"] = 280.52, ["Ride"] = 99.75, ["Fly|Ride"] = 262.44, ["Neon"] = 420.25, ["Neon|Ride"] = 418.15, ["Neon|Fly|Ride"] = 420.25, ["Mega|Ride"] = 1793.36, ["Mega|Fly|Ride"] = 1821.73}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 11.82, ["Fly"] = 91.88, ["Ride"] = 45.98, ["Fly|Ride"] = 247.38, ["Neon"] = 72.19, ["Neon|Ride"] = 124.22, ["Neon|Fly|Ride"] = 523.95, ["Mega"] = 367.5, ["Mega|Ride"] = 322.54, ["Mega|Fly|Ride"] = 309.9}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 79.06, ["Ride"] = 78.75, ["Fly|Ride"] = 209.08, ["Neon"] = 224.44, ["Neon|Ride"] = 261.19, ["Neon|Fly|Ride"] = 267.02, ["Mega"] = 905.63, ["Mega|Ride"] = 839.99, ["Mega|Fly|Ride"] = 878.51}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 24.82, ["Fly"] = 196.88, ["Ride"] = 31.84, ["Fly|Ride"] = 76.63, ["Neon"] = 78.85, ["Neon|Fly"] = 249.38, ["Neon|Ride"] = 116.31, ["Neon|Fly|Ride"] = 209.77, ["Mega"] = 359.45, ["Mega|Ride"] = 303.81, ["Mega|Fly|Ride"] = 436.54}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 3.44, ["Fly"] = 28.39, ["Ride"] = 23.13, ["Fly|Ride"] = 65.63, ["Neon"] = 22.3, ["Neon|Ride"] = 266.86, ["Neon|Fly|Ride"] = 557.25, ["Mega"] = 315, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 15.74, ["Fly"] = 72.19, ["Ride"] = 81.93, ["Fly|Ride"] = 98.77, ["Neon"] = 69.72, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 525, ["Mega"] = 280.52, ["Mega|Ride"] = 280.52, ["Mega|Fly|Ride"] = 518.44}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 6.14, ["Ride"] = 25.91, ["Fly|Ride"] = 78.75, ["Neon"] = 58.85, ["Neon|Ride"] = 88.25, ["Mega"] = 416.59, ["Mega|Ride"] = 301.43, ["Mega|Fly|Ride"] = 374.99}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 32.8, ["Mega"] = 15.75, ["Mega|Fly"] = 140.79, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 163.91}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 2.1, ["Ride"] = 27.33, ["Fly|Ride"] = 70.41, ["Neon"] = 9.18, ["Neon|Ride"] = 83.83, ["Mega"] = 117.84, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 280.52}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Neon"] = 22.32, ["Neon|Ride"] = 118.13, ["Mega"] = 336, ["Mega|Ride"] = 392.93}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 3.68, ["Ride"] = 23.23, ["Fly|Ride"] = 116.11, ["Neon"] = 20, ["Neon|Ride"] = 84.07, ["Neon|Fly|Ride"] = 279.47, ["Mega"] = 64.62, ["Mega|Ride"] = 155.57, ["Mega|Fly|Ride"] = 263.34}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 438.38, ["Fly"] = 588.59, ["Ride"] = 497.44, ["Fly|Ride"] = 523.17, ["Neon|Ride"] = 1679.11, ["Neon|Fly|Ride"] = 1508.07, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 3.94, ["Fly"] = 56.26, ["Ride"] = 24.94, ["Fly|Ride"] = 62.7, ["Neon"] = 37.84, ["Neon|Ride"] = 83.91, ["Neon|Fly|Ride"] = 124.24, ["Mega"] = 299.53, ["Mega|Ride"] = 280.52}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 7.85, ["Fly"] = 31.49, ["Ride"] = 40.69, ["Fly|Ride"] = 84.07, ["Neon"] = 70.39, ["Neon|Fly"] = 315, ["Neon|Ride"] = 64.22, ["Neon|Fly|Ride"] = 108.94, ["Mega"] = 313.09, ["Mega|Ride"] = 322.54, ["Mega|Fly|Ride"] = 385.81}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.63, ["Fly"] = 91.88, ["Ride"] = 21, ["Fly|Ride"] = 315.19, ["Neon|Ride"] = 86.52, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 42.05, ["Ride"] = 23.61, ["Neon"] = 5.96, ["Neon|Fly"] = 70.41, ["Neon|Ride"] = 28.35, ["Neon|Fly|Ride"] = 116.8, ["Mega"] = 56.21, ["Mega|Fly"] = 220.64, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 180.76}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Ride"] = 67.1, ["Neon"] = 2.1, ["Neon|Ride"] = 19.62, ["Neon|Fly|Ride"] = 116.11, ["Mega"] = 18.52, ["Mega|Ride"] = 63.3, ["Mega|Fly|Ride"] = 185.73}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1312.5}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 7.87, ["Fly"] = 65.63, ["Ride"] = 38.48, ["Fly|Ride"] = 130.29, ["Neon"] = 115.5, ["Neon|Fly"] = 140.79, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 145.69, ["Mega"] = 360.98, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 45.36, ["Neon"] = 5.92, ["Neon|Ride"] = 70.55, ["Mega"] = 32.79, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 224.44}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.63, ["Fly"] = 42.05, ["Ride"] = 19.95, ["Fly|Ride"] = 525, ["Neon"] = 7.88, ["Neon|Ride"] = 70.09, ["Neon|Fly|Ride"] = 147.45, ["Mega"] = 46.25, ["Mega|Ride"] = 140.44, ["Mega|Fly|Ride"] = 168}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 341.25, ["Ride"] = 420.25, ["Fly|Ride"] = 446.25, ["Neon|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 1115.63, ["Mega|Fly|Ride"] = 8125.23}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 6.56, ["Fly"] = 196.88, ["Ride"] = 59.07, ["Neon"] = 52.43, ["Neon|Ride"] = 131.25, ["Mega"] = 280.52, ["Mega|Fly|Ride"] = 499.05}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Ride"] = 28.35, ["Neon"] = 4.47, ["Neon|Fly"] = 210.13, ["Neon|Ride"] = 23.63, ["Mega"] = 30.44, ["Mega|Fly"] = 189, ["Mega|Ride"] = 78.69, ["Mega|Fly|Ride"] = 192.94}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 25.47, ["Fly|Ride"] = 238.5, ["Neon"] = 2.63, ["Neon|Ride"] = 52.45, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 22.28, ["Mega|Ride"] = 124.16, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 7.83, ["Fly"] = 78.7, ["Ride"] = 37.16, ["Fly|Ride"] = 178.5, ["Neon"] = 37.83, ["Neon|Ride"] = 48.28, ["Neon|Fly|Ride"] = 276.32, ["Mega"] = 280.52, ["Mega|Ride"] = 309.98, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 5.99, ["Fly|Ride"] = 52.5, ["Neon"] = 420.25, ["Neon|Fly|Ride"] = 837.38, ["Mega"] = 490.64, ["Mega|Ride"] = 309.98, ["Mega|Fly|Ride"] = 1046.73}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 2.61, ["Neon"] = 102.82, ["Neon|Ride"] = 209.08, ["Mega"] = 280.52, ["Mega|Ride"] = 406.23, ["Mega|Fly|Ride"] = 471.73}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 5.86, ["Ride"] = 65.16, ["Fly|Ride"] = 231.93, ["Neon"] = 105.08, ["Neon|Ride"] = 124.24, ["Neon|Fly|Ride"] = 774.35, ["Mega"] = 660.19, ["Mega|Ride"] = 440.55, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 370.79, ["Ride"] = 348.8, ["Fly|Ride"] = 607.17, ["Neon"] = 1758.64, ["Neon|Ride"] = 2101.18, ["Neon|Fly|Ride"] = 1405.69, ["Mega|Ride"] = 3767.4, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 2.63, ["Ride"] = 32.53, ["Fly|Ride"] = 82.41, ["Neon"] = 43.31, ["Neon|Ride"] = 98.77, ["Neon|Fly|Ride"] = 140.62, ["Mega"] = 529.78, ["Mega|Ride"] = 498, ["Mega|Fly|Ride"] = 671.34}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.14, ["Ride"] = 91.88, ["Neon"] = 25.89, ["Mega"] = 1260.71, ["Mega|Fly|Ride"] = 420.25}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 6.57, ["Ride"] = 59.04, ["Fly|Ride"] = 157.5, ["Neon"] = 36.75, ["Neon|Ride"] = 65.63, ["Mega"] = 160.13, ["Mega|Ride"] = 191.63, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Ride"] = 31.49, ["Fly|Ride"] = 98.76, ["Neon"] = 11.82, ["Neon|Ride"] = 65.63, ["Mega"] = 37.51, ["Mega|Ride"] = 96.67, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 36.57, ["Ride"] = 45.19, ["Neon"] = 259.62, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 287.44, ["Mega"] = 839.43, ["Mega|Ride"] = 840.48, ["Mega|Fly|Ride"] = 980.87}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.05, ["Fly"] = 580.47, ["Ride"] = 24.91, ["Neon"] = 6.36, ["Neon|Fly"] = 182.81, ["Neon|Ride"] = 28.34, ["Neon|Fly|Ride"] = 105.08, ["Mega"] = 65.63, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 231.93}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 42.05, ["Ride"] = 31.34, ["Neon"] = 3.36, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 36.75, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 178.01}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Fly"] = 1519.88, ["Ride"] = 23.63, ["Fly|Ride"] = 262.5, ["Neon"] = 6.43, ["Neon|Ride"] = 155.57, ["Neon|Fly|Ride"] = 295.32, ["Mega"] = 85.3, ["Mega|Ride"] = 95.6, ["Mega|Fly|Ride"] = 192.94}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 57.74, ["Ride"] = 62.68, ["Fly|Ride"] = 105.08, ["Neon"] = 420.25, ["Neon|Ride"] = 420.25, ["Neon|Fly|Ride"] = 670.04, ["Mega|Ride"] = 868.84, ["Mega|Fly|Ride"] = 901.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 229.69, ["Ride"] = 262.5, ["Fly|Ride"] = 418.15, ["Neon"] = 1373.13, ["Neon|Ride"] = 1099.88, ["Neon|Fly|Ride"] = 1548.66, ["Mega"] = 6723.74, ["Mega|Fly|Ride"] = 4593.75}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 2.1, ["Neon"] = 26.75, ["Mega"] = 90.48, ["Mega|Ride"] = 191.33, ["Mega|Fly|Ride"] = 470.68}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 5.57, ["Ride"] = 65.58, ["Neon"] = 27.93, ["Neon|Fly|Ride"] = 1721.04, ["Mega"] = 137.71, ["Mega|Fly|Ride"] = 524.26}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.31, ["Fly"] = 155.57, ["Neon"] = 24.28, ["Neon|Ride"] = 62.7, ["Mega"] = 483.67, ["Mega|Ride"] = 337.84}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 53.23, ["Ride"] = 30.19, ["Neon"] = 3.52, ["Neon|Ride"] = 19.95, ["Neon|Fly|Ride"] = 70.41, ["Mega"] = 41.88, ["Mega|Ride"] = 96.67, ["Mega|Fly|Ride"] = 124.24}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 59.07, ["Neon"] = 4.57, ["Mega"] = 28.32, ["Mega|Ride"] = 206.07}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 18.94, ["Fly|Ride"] = 46.44, ["Neon"] = 4.23, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 40.3, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 280.52}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 18.94, ["Fly|Ride"] = 60.38, ["Neon"] = 9.29, ["Neon|Fly"] = 46.45, ["Neon|Ride"] = 39.48, ["Neon|Fly|Ride"] = 69.67, ["Mega"] = 221.74, ["Mega|Ride"] = 182.81, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 36.75, ["Ride"] = 25.59, ["Fly|Ride"] = 136.59, ["Neon"] = 114.19, ["Neon|Ride"] = 140.79, ["Mega"] = 360.94, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 77.44, ["Fly"] = 582.75, ["Ride"] = 99.74, ["Fly|Ride"] = 154.88, ["Neon"] = 424.51, ["Neon|Ride"] = 391.12, ["Neon|Fly|Ride"] = 559.29, ["Mega|Ride"] = 1540.18, ["Mega|Fly|Ride"] = 1436.34}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Fly|Ride"] = 131.25, ["Neon"] = 3.83, ["Neon|Ride"] = 63.04, ["Neon|Fly|Ride"] = 272.09, ["Mega"] = 59.3, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 24.19, ["Ride"] = 18.88, ["Fly|Ride"] = 42, ["Neon"] = 3.93, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 38.06, ["Mega|Fly"] = 157.5, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 3.56, ["Ride"] = 26.23, ["Neon"] = 66.21, ["Neon|Ride"] = 149.2, ["Neon|Fly|Ride"] = 279.47, ["Mega"] = 611, ["Mega|Ride"] = 406.59, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 282.19, ["Ride"] = 550.52, ["Fly|Ride"] = 347.81, ["Neon|Ride"] = 1470.83, ["Neon|Fly|Ride"] = 911.93, ["Mega|Fly|Ride"] = 5263.55}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 26.24, ["Fly"] = 209.9, ["Ride"] = 48.51, ["Fly|Ride"] = 95.39, ["Neon"] = 262.5, ["Neon|Ride"] = 210.13, ["Neon|Fly|Ride"] = 236.25, ["Mega|Ride"] = 729.12, ["Mega|Fly|Ride"] = 619.94}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Fly"] = 28.39, ["Ride"] = 19.36, ["Fly|Ride"] = 53.42, ["Neon"] = 13.13, ["Neon|Ride"] = 38.84, ["Mega"] = 80.07, ["Mega|Ride"] = 111.43, ["Mega|Fly|Ride"] = 218.74}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 210.13, ["Ride"] = 44.91, ["Fly|Ride"] = 142.7, ["Neon"] = 25.19, ["Neon|Ride"] = 65.63, ["Mega"] = 211.32, ["Mega|Ride"] = 434.19}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 25.53, ["Fly"] = 256.36, ["Ride"] = 30.19, ["Fly|Ride"] = 60.38, ["Mega"] = 2521.41, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 713.36}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 76.56, ["Ride"] = 140.78, ["Fly|Ride"] = 98.81, ["Neon"] = 483.29, ["Neon|Ride"] = 385.58, ["Neon|Fly|Ride"] = 420.25, ["Mega"] = 3082.43, ["Mega|Fly"] = 2099.08, ["Mega|Fly|Ride"] = 2071.77}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 210, ["Fly"] = 350.9, ["Ride"] = 222.9, ["Fly|Ride"] = 341.57, ["Neon"] = 775.69, ["Neon|Ride"] = 981.26, ["Neon|Fly|Ride"] = 656.25, ["Mega|Fly|Ride"] = 3357.68}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 16.79, ["Ride"] = 59.07, ["Fly|Ride"] = 119.78, ["Neon"] = 91.42, ["Neon|Ride"] = 66.29, ["Neon|Fly|Ride"] = 232.2, ["Mega"] = 489.59, ["Mega|Ride"] = 449.67, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 25.72, ["Ride"] = 13.13, ["Fly|Ride"] = 30.49, ["Neon"] = 9.14, ["Neon|Fly"] = 70.41, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 76.39, ["Mega"] = 61.69, ["Mega|Ride"] = 92.89, ["Mega|Fly|Ride"] = 153.4}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 3.94, ["Fly"] = 37.08, ["Ride"] = 16.05, ["Fly|Ride"] = 40.63, ["Neon"] = 23.56, ["Neon|Ride"] = 38.84, ["Neon|Fly|Ride"] = 94.4, ["Mega"] = 223.13, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 301.53}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 258.57, ["Ride"] = 326.82, ["Fly|Ride"] = 482.24, ["Neon|Ride"] = 1240.72, ["Mega|Fly|Ride"] = 6826.71}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 46.25, ["Neon"] = 4.99, ["Neon|Ride"] = 217.1, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 26.25, ["Mega|Ride"] = 155.57, ["Mega|Fly|Ride"] = 232.2}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.21, ["Fly"] = 52.5, ["Ride"] = 17.05, ["Fly|Ride"] = 59.05, ["Neon"] = 25.24, ["Neon|Ride"] = 35.7, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 268.93, ["Mega|Ride"] = 182.67, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 13.13, ["Ride"] = 42.05, ["Neon"] = 74.26, ["Neon|Ride"] = 280.52, ["Neon|Fly|Ride"] = 561.03, ["Mega"] = 496.13, ["Mega|Ride"] = 502.48, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 98.43, ["Fly"] = 279.47, ["Ride"] = 110.25, ["Fly|Ride"] = 95.7, ["Neon|Ride"] = 551.25, ["Neon|Fly|Ride"] = 490.71, ["Mega|Fly|Ride"] = 1638.93}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 18.38, ["Fly"] = 40.73, ["Ride"] = 20.93, ["Fly|Ride"] = 49.39, ["Neon"] = 85.32, ["Neon|Ride"] = 62.99, ["Neon|Fly|Ride"] = 140.79, ["Mega"] = 700.75, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 39.94, ["Fly|Ride"] = 104.03, ["Neon"] = 2.1, ["Neon|Ride"] = 70.41, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 16.37, ["Mega|Ride"] = 49.4, ["Mega|Fly|Ride"] = 420.25}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.12, ["Ride"] = 18.38, ["Neon"] = 2.1, ["Neon|Fly"] = 31.36, ["Neon|Ride"] = 28.38, ["Neon|Fly|Ride"] = 68.98, ["Mega"] = 21, ["Mega|Fly"] = 85.93, ["Mega|Ride"] = 46.45, ["Mega|Fly|Ride"] = 104.89}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 4.23, ["Fly"] = 105.08, ["Ride"] = 46.75, ["Fly|Ride"] = 165.21, ["Neon"] = 24.94, ["Neon|Fly"] = 263.54, ["Neon|Ride"] = 54.92, ["Neon|Fly|Ride"] = 162.75, ["Mega"] = 105, ["Mega|Ride"] = 160.31, ["Mega|Fly|Ride"] = 232.32}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1181.25, ["Ride"] = 1312.5, ["Fly|Ride"] = 1380.75, ["Neon"] = 4134.05, ["Neon|Fly|Ride"] = 3920.78, ["Mega"] = 18070.04, ["Mega|Fly|Ride"] = 13636.88}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 472.5, ["Ride"] = 523.68, ["Fly|Ride"] = 510.06, ["Neon"] = 1455.3, ["Neon|Ride"] = 1945.84, ["Neon|Fly|Ride"] = 1905.78, ["Mega"] = 13930.84, ["Mega|Fly|Ride"] = 6295.22}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 261.19, ["Fly"] = 561.03, ["Ride"] = 327.8, ["Fly|Ride"] = 414.75, ["Neon"] = 656.25, ["Neon|Fly"] = 840.48, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 802.46, ["Mega|Fly|Ride"] = 2428.13}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 293.13, ["Fly"] = 397.05, ["Ride"] = 326.82, ["Fly|Ride"] = 380.63, ["Neon"] = 721.88, ["Neon|Ride"] = 813.17, ["Neon|Fly|Ride"] = 853.13, ["Mega|Ride"] = 3675, ["Mega|Fly|Ride"] = 2801.92}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 28.39, ["Ride"] = 14.41, ["Fly|Ride"] = 33.94, ["Neon"] = 4.56, ["Neon|Ride"] = 43.1, ["Neon|Fly|Ride"] = 54.64, ["Mega"] = 83.68, ["Mega|Ride"] = 73.91, ["Mega|Fly|Ride"] = 140.79}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 308.44, ["Fly"] = 415, ["Ride"] = 359.39, ["Fly|Ride"] = 500.07, ["Neon"] = 1207.36, ["Neon|Ride"] = 1153.59, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 3713.82, ["Mega|Ride"] = 3412.5, ["Mega|Fly|Ride"] = 3281.25}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.1, ["Fly"] = 183.75, ["Ride"] = 17.46, ["Neon"] = 7.82, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 254.63, ["Mega"] = 84, ["Mega|Ride"] = 129.84, ["Mega|Fly|Ride"] = 119.78}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 19.93, ["Ride"] = 29.93, ["Fly|Ride"] = 49.88, ["Neon"] = 7.49, ["Neon|Ride"] = 62.7, ["Neon|Fly|Ride"] = 119.78, ["Mega|Ride"] = 133.44, ["Mega|Fly|Ride"] = 150.81}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 3.29, ["Neon|Ride"] = 28.88, ["Mega"] = 23.44, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 32.33, ["Ride"] = 67.26, ["Fly|Ride"] = 459.38, ["Neon"] = 273, ["Neon|Ride"] = 420, ["Mega"] = 2101.18, ["Mega|Ride"] = 897.75, ["Mega|Fly|Ride"] = 972.57}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 6.33, ["Fly"] = 65.61, ["Ride"] = 18.9, ["Neon"] = 32.82, ["Mega"] = 203.82, ["Mega|Ride"] = 317.29}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 45.94, ["Neon"] = 2.63, ["Neon|Fly"] = 45.2, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 140.63, ["Mega"] = 24.93, ["Mega|Fly"] = 101.01, ["Mega|Ride"] = 155.57, ["Mega|Fly|Ride"] = 371.51}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 18.38, ["Fly|Ride"] = 49.97, ["Neon"] = 6.04, ["Neon|Fly"] = 89.12, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 64.32, ["Mega|Fly"] = 197.36, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 140.79}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 2.93, ["Fly"] = 45.94, ["Ride"] = 30.49, ["Fly|Ride"] = 55.26, ["Neon"] = 25.24, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 262.4, ["Mega"] = 237.57, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 4.09, ["Ride"] = 24.66, ["Neon"] = 131.25, ["Mega"] = 464.38, ["Mega|Ride"] = 336.2, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Ride"] = 24.91, ["Fly|Ride"] = 87.94, ["Neon"] = 37.05, ["Neon|Ride"] = 80.07, ["Neon|Fly|Ride"] = 696.55, ["Mega"] = 434.19, ["Mega|Ride"] = 476.99}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 17.4, ["Fly|Ride"] = 84, ["Neon"] = 3.93, ["Neon|Ride"] = 25.24, ["Neon|Fly|Ride"] = 58.85, ["Mega"] = 40.69, ["Mega|Ride"] = 124.95, ["Mega|Fly|Ride"] = 315.19}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 127.32, ["Fly"] = 183.75, ["Ride"] = 190.32, ["Fly|Ride"] = 231, ["Neon"] = 855.09, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 895, ["Neon|Fly|Ride"] = 700.75, ["Mega"] = 8404.68, ["Mega|Fly|Ride"] = 3503.72}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 18.32, ["Ride"] = 15.75, ["Fly|Ride"] = 33.45, ["Neon"] = 3.29, ["Neon|Fly"] = 56.75, ["Neon|Ride"] = 24.26, ["Neon|Fly|Ride"] = 69.35, ["Mega"] = 42.05, ["Mega|Ride"] = 70.88, ["Mega|Fly|Ride"] = 97.13}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 8.81, ["Ride"] = 69.57, ["Fly|Ride"] = 94.5, ["Neon"] = 73.15, ["Neon|Ride"] = 147.45, ["Neon|Fly|Ride"] = 309.98, ["Mega"] = 315, ["Mega|Ride"] = 304.68, ["Mega|Fly|Ride"] = 273.17}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 22.88, ["Ride"] = 114.58, ["Neon"] = 137.12, ["Neon|Ride"] = 297.33, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 696.41, ["Mega|Ride"] = 696.97, ["Mega|Fly|Ride"] = 813.17}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 161.44, ["Fly"] = 250.69, ["Ride"] = 196.85, ["Fly|Ride"] = 232.2, ["Neon"] = 716.63, ["Neon|Ride"] = 700.75, ["Neon|Fly|Ride"] = 940.29, ["Mega|Fly|Ride"] = 3151.77}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 15.75, ["Neon"] = 111.57, ["Mega"] = 327.48, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 700.75}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 26.25, ["Ride"] = 54.66, ["Fly|Ride"] = 629.31, ["Neon"] = 171.77, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 840.48, ["Mega"] = 603.05, ["Mega|Ride"] = 629.31, ["Mega|Fly|Ride"] = 1891.07}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1010.63, ["Ride"] = 1010.63, ["Fly|Ride"] = 1081.75, ["Neon|Ride"] = 6303.51, ["Neon|Fly|Ride"] = 4062.62, ["Mega|Fly|Ride"] = 19611.24}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 8.17, ["Fly"] = 43.32, ["Ride"] = 27.33, ["Fly|Ride"] = 62.68, ["Neon"] = 37.32, ["Neon|Fly"] = 111.57, ["Neon|Ride"] = 77.8, ["Neon|Fly|Ride"] = 200.82, ["Mega"] = 174.41, ["Mega|Fly"] = 561.03, ["Mega|Ride"] = 248.46, ["Mega|Fly|Ride"] = 418.15}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 3.91, ["Fly"] = 52.5, ["Ride"] = 28.72, ["Neon"] = 36.16, ["Neon|Ride"] = 157.68, ["Neon|Fly|Ride"] = 144.74, ["Mega"] = 196.88, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 360.36}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.47, ["Ride"] = 26.25, ["Fly|Ride"] = 91.42, ["Neon"] = 8.16, ["Neon|Ride"] = 63.67, ["Neon|Fly|Ride"] = 309.98, ["Mega"] = 136.4, ["Mega|Ride"] = 170.62, ["Mega|Fly|Ride"] = 558.93}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 17.43, ["Ride"] = 33.66, ["Fly|Ride"] = 91.88, ["Neon"] = 65.63, ["Neon|Ride"] = 95.62, ["Neon|Fly|Ride"] = 171.94, ["Mega"] = 301.88, ["Mega|Ride"] = 332.07, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.21, ["Fly"] = 19.99, ["Ride"] = 14.44, ["Fly|Ride"] = 39.11, ["Neon"] = 16.06, ["Neon|Ride"] = 21.04, ["Neon|Fly|Ride"] = 54.57, ["Mega"] = 280.52, ["Mega|Ride"] = 98.67, ["Mega|Fly|Ride"] = 155.57}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Neon"] = 6.34, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 100.01, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 140.79}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 186.38, ["Ride"] = 183.75, ["Fly|Ride"] = 476.99, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 1393.1, ["Mega|Fly|Ride"] = 3272.57}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.35, ["Ride"] = 27.18, ["Neon"] = 6.57, ["Neon|Fly"] = 77.8, ["Neon|Ride"] = 38.75, ["Neon|Fly|Ride"] = 123.99, ["Mega"] = 77.79, ["Mega|Ride"] = 119.78, ["Mega|Fly|Ride"] = 224.84}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.68, ["Fly"] = 408.19, ["Neon"] = 26.75, ["Mega"] = 210, ["Mega|Ride"] = 251.88}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.59, ["Fly"] = 81.58, ["Ride"] = 23.63, ["Neon"] = 7.01, ["Neon|Fly|Ride"] = 155.57, ["Mega"] = 95.82, ["Mega|Ride"] = 211.35, ["Mega|Fly|Ride"] = 385.49}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 127.32, ["Fly"] = 262.5, ["Ride"] = 144.38, ["Fly|Ride"] = 308.76, ["Neon"] = 393.74, ["Neon|Ride"] = 414.75, ["Neon|Fly|Ride"] = 548.63, ["Mega"] = 1891.07, ["Mega|Ride"] = 1695.65, ["Mega|Fly|Ride"] = 1621.07}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 15.74, ["Ride"] = 59.22, ["Fly|Ride"] = 109.28, ["Neon"] = 120.75, ["Neon|Fly"] = 232.2, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 525, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 654.52}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 17.67, ["Ride"] = 39.38, ["Neon"] = 103.16, ["Neon|Ride"] = 140.63, ["Neon|Fly|Ride"] = 158.02, ["Mega"] = 393.75, ["Mega|Ride"] = 477.08, ["Mega|Fly|Ride"] = 432.7}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 31.34, ["Neon"] = 3.03, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 31.69, ["Mega"] = 31.44, ["Mega|Ride"] = 74.74, ["Mega|Fly|Ride"] = 210.13}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 70.88, ["Fly"] = 86.91, ["Ride"] = 84, ["Fly|Ride"] = 140.44, ["Neon"] = 379.63, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 328.13, ["Mega|Fly|Ride"] = 903}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.05, ["Ride"] = 19.93, ["Neon"] = 6.33, ["Neon|Ride"] = 36.79, ["Neon|Fly|Ride"] = 588, ["Mega"] = 60.88}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 19.69, ["Fly"] = 140.79, ["Ride"] = 29.43, ["Fly|Ride"] = 104.77, ["Neon"] = 46.44, ["Neon|Ride"] = 48.34, ["Neon|Fly|Ride"] = 119.78, ["Mega"] = 380.63, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 525.31}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 45.93, ["Ride"] = 57.75, ["Fly|Ride"] = 131.25, ["Neon"] = 225.81, ["Neon|Ride"] = 280.75, ["Neon|Fly|Ride"] = 346.19, ["Mega|Ride"] = 1126.25, ["Mega|Fly|Ride"] = 971.25}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.05, ["Fly"] = 13.13, ["Ride"] = 15.7, ["Fly|Ride"] = 47.24, ["Neon"] = 2.1, ["Neon|Fly"] = 27.72, ["Neon|Ride"] = 17.05, ["Neon|Fly|Ride"] = 28.39, ["Mega"] = 20.9, ["Mega|Fly"] = 42.05, ["Mega|Ride"] = 31.54, ["Mega|Fly|Ride"] = 55.29}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.63, ["Ride"] = 24.94, ["Fly|Ride"] = 98.65, ["Neon"] = 15.74, ["Neon|Ride"] = 56.6, ["Neon|Fly|Ride"] = 111.46, ["Mega"] = 220.5, ["Mega|Ride"] = 143.21, ["Mega|Fly|Ride"] = 420.25}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 17.42, ["Ride"] = 39.38, ["Neon"] = 131.25, ["Neon|Ride"] = 155.57, ["Neon|Fly|Ride"] = 619.94, ["Mega"] = 700.75, ["Mega|Ride"] = 516.97, ["Mega|Fly|Ride"] = 628.68}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.05, ["Ride"] = 23.09, ["Neon"] = 2.5, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 22.08, ["Mega|Ride"] = 66.21, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 6.2, ["Fly"] = 210, ["Ride"] = 27.33, ["Fly|Ride"] = 59.07, ["Neon"] = 16.79, ["Neon|Ride"] = 86.73, ["Neon|Fly|Ride"] = 182.62, ["Mega"] = 630.36, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 419.2}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 14.34, ["Fly"] = 42.05, ["Ride"] = 25.24, ["Fly|Ride"] = 46.45, ["Neon"] = 112.22, ["Neon|Ride"] = 77.73, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 582.04, ["Mega|Fly|Ride"] = 464.38}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.68, ["Ride"] = 23.14, ["Neon"] = 11.8, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 35.74, ["Mega"] = 149.63, ["Mega|Ride"] = 279.47, ["Mega|Fly|Ride"] = 251.11}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 10.63, ["Fly"] = 2101.18, ["Neon"] = 95.62, ["Neon|Ride"] = 209.67, ["Neon|Fly|Ride"] = 6191.1, ["Mega"] = 196.88, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 22.97, ["Fly|Ride"] = 126.46, ["Neon"] = 5.92, ["Neon|Ride"] = 28.38, ["Mega"] = 77.8, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 408.19, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Neon"] = 3.54, ["Neon|Ride"] = 28.39, ["Mega"] = 27.46, ["Mega|Ride"] = 125.01}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 30.11}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 52.5, ["Fly"] = 77.76, ["Ride"] = 59.11, ["Fly|Ride"] = 136.55, ["Neon"] = 155.57, ["Neon|Ride"] = 280.52, ["Neon|Fly|Ride"] = 525.31, ["Mega|Ride"] = 979.16, ["Mega|Fly|Ride"] = 771.15}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 140.59, ["Neon"] = 2.49, ["Mega"] = 18.94, ["Mega|Ride"] = 104.03, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 523.69, ["Ride"] = 590.63, ["Fly|Ride"] = 550.52, ["Neon"] = 4202.35, ["Neon|Ride"] = 2494.1, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 16809.34, ["Mega|Fly|Ride"] = 5869.62}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 4.66, ["Fly"] = 26.24, ["Ride"] = 40.69, ["Fly|Ride"] = 54.57, ["Neon"] = 28.39, ["Neon|Ride"] = 98.76, ["Neon|Fly|Ride"] = 561.03, ["Mega|Fly|Ride"] = 544.14}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.61, ["Fly"] = 91.88, ["Ride"] = 15.59, ["Fly|Ride"] = 49.39, ["Neon"] = 23.14, ["Neon|Ride"] = 35.47, ["Neon|Fly|Ride"] = 85.93, ["Mega"] = 280.52, ["Mega|Ride"] = 155.57, ["Mega|Fly|Ride"] = 251.11}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 15.75, ["Ride"] = 76.13, ["Fly|Ride"] = 155.5, ["Neon"] = 64.3, ["Neon|Ride"] = 140.79, ["Neon|Fly|Ride"] = 140.79, ["Mega"] = 1050.59, ["Mega|Ride"] = 546.32, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.47, ["Fly"] = 49.4, ["Ride"] = 19.99, ["Fly|Ride"] = 393.75, ["Neon"] = 140.59, ["Mega"] = 292.08, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 11.17, ["Ride"] = 91.88, ["Fly|Ride"] = 157.5, ["Neon"] = 50.07, ["Neon|Ride"] = 140.79, ["Neon|Fly|Ride"] = 350.44, ["Mega"] = 359.31, ["Mega|Ride"] = 427.22, ["Mega|Fly|Ride"] = 517.79}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 4.94, ["Fly"] = 105, ["Ride"] = 25.33, ["Fly|Ride"] = 131.25, ["Neon"] = 13.95, ["Neon|Ride"] = 70.39, ["Neon|Fly|Ride"] = 109.14, ["Mega"] = 170.63, ["Mega|Fly"] = 485.39, ["Mega|Ride"] = 273.17, ["Mega|Fly|Ride"] = 350.9}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 42.05, ["Ride"] = 17.07, ["Fly|Ride"] = 75.66, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 24.04, ["Neon|Fly|Ride"] = 60.1, ["Mega"] = 15.67, ["Mega|Fly"] = 77.8, ["Mega|Ride"] = 36.75, ["Mega|Fly|Ride"] = 65.63}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 4.96, ["Ride"] = 37.41, ["Fly|Ride"] = 56.75, ["Neon"] = 42.06, ["Neon|Fly"] = 387.76, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 120.83, ["Mega|Ride"] = 101.07, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 244.16, ["Ride"] = 294.4, ["Fly|Ride"] = 309.98, ["Neon"] = 1480.5, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1365, ["Mega"] = 5589.75, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 76.41, ["Ride"] = 166.68, ["Fly|Ride"] = 215.25, ["Neon"] = 420.25, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 590.63, ["Mega"] = 4202.35, ["Mega|Ride"] = 1962.5, ["Mega|Fly|Ride"] = 2269.28}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 28.39, ["Ride"] = 24.94, ["Fly|Ride"] = 37.28, ["Neon"] = 9.13, ["Neon|Ride"] = 23.23, ["Neon|Fly|Ride"] = 53.45, ["Mega"] = 46.45, ["Mega|Fly"] = 209.08, ["Mega|Ride"] = 91.42, ["Mega|Fly|Ride"] = 155.5}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 19.92, ["Ride"] = 12.49, ["Fly|Ride"] = 32.17, ["Neon"] = 5.24, ["Neon|Fly"] = 23.23, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 38.07, ["Mega"] = 79.72, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Ride"] = 18.9, ["Fly|Ride"] = 98.44, ["Neon"] = 13.13, ["Neon|Fly|Ride"] = 210.13, ["Mega"] = 131.25}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 227.07, ["Fly"] = 464.38, ["Ride"] = 255.94, ["Fly|Ride"] = 399.24, ["Neon|Ride"] = 1260, ["Neon|Fly|Ride"] = 1401.49, ["Mega|Ride"] = 2801.92, ["Mega|Fly|Ride"] = 4339.97}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.63, ["Fly"] = 21, ["Ride"] = 15.28, ["Fly|Ride"] = 31.71, ["Neon"] = 11.82, ["Neon|Fly"] = 155.57, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 43.09, ["Mega"] = 155.59, ["Mega|Ride"] = 155.57, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 2.36, ["Ride"] = 18.88, ["Fly|Ride"] = 210.13, ["Neon"] = 12.73, ["Neon|Ride"] = 74.61, ["Neon|Fly|Ride"] = 224.84, ["Mega"] = 63.74, ["Mega|Ride"] = 171.26, ["Mega|Fly|Ride"] = 348.1}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 21, ["Neon"] = 3.46, ["Neon|Ride"] = 26.52, ["Mega"] = 63.06, ["Mega|Ride"] = 68.92}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 9.98, ["Fly"] = 54.74, ["Ride"] = 19.69, ["Fly|Ride"] = 45.94, ["Neon"] = 146.05, ["Neon|Fly"] = 112.43, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 230.99, ["Mega"] = 574.25, ["Mega|Ride"] = 360.36, ["Mega|Fly|Ride"] = 761.25}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 41.1, ["Ride"] = 70.41, ["Fly|Ride"] = 203.69, ["Neon"] = 131.25, ["Neon|Fly"] = 232.2, ["Neon|Ride"] = 178.33, ["Neon|Fly|Ride"] = 293.72, ["Mega"] = 477.75, ["Mega|Fly"] = 2206.24, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 497.44}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 23.23, ["Fly"] = 49.4, ["Ride"] = 33.86, ["Fly|Ride"] = 64.32, ["Neon"] = 105, ["Neon|Ride"] = 147.1, ["Neon|Fly|Ride"] = 219.19, ["Mega|Ride"] = 783.12, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.05, ["Fly"] = 17.07, ["Ride"] = 18.87, ["Fly|Ride"] = 29.08, ["Neon"] = 2.1, ["Neon|Fly"] = 30.66, ["Neon|Ride"] = 19.84, ["Neon|Fly|Ride"] = 48.35, ["Mega"] = 17.73, ["Mega|Ride"] = 39.95, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 155.5, ["Fly"] = 236.25, ["Ride"] = 192.97, ["Fly|Ride"] = 295.32, ["Neon|Ride"] = 912.87, ["Neon|Fly|Ride"] = 1088.41, ["Mega|Fly|Ride"] = 3389.82}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 8.91, ["Fly"] = 65.63, ["Ride"] = 45.94, ["Neon"] = 112.14, ["Neon|Ride"] = 116.11, ["Mega"] = 315, ["Mega|Ride"] = 314.99, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.05, ["Ride"] = 15.74, ["Fly|Ride"] = 59.07, ["Neon"] = 15.75, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 131.15, ["Mega"] = 61.68, ["Mega|Fly"] = 111.57, ["Mega|Ride"] = 67.26, ["Mega|Fly|Ride"] = 258.46}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.05, ["Fly"] = 140.79, ["Ride"] = 28.39, ["Fly|Ride"] = 42.05, ["Neon"] = 3.93, ["Neon|Fly"] = 31.36, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 97.02, ["Mega"] = 22.32, ["Mega|Fly"] = 137.64, ["Mega|Ride"] = 45.2, ["Mega|Fly|Ride"] = 108.83}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 3.42, ["Fly"] = 21.04, ["Ride"] = 22.53, ["Fly|Ride"] = 140.79, ["Neon"] = 15.73, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 116.7, ["Mega|Ride"] = 116.75, ["Mega|Fly|Ride"] = 420.25}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 10.47, ["Fly"] = 32.26, ["Ride"] = 18.31, ["Fly|Ride"] = 46.57, ["Neon"] = 32.59, ["Neon|Ride"] = 56.68, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 309.98, ["Mega|Ride"] = 338.39, ["Mega|Fly|Ride"] = 381.94}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 6.28, ["Ride"] = 39.38, ["Neon"] = 21, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 210, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 314.14}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 15.36, ["Neon"] = 2.63, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 19.36, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 242.71}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 9.31, ["Ride"] = 28.39, ["Fly|Ride"] = 94.5, ["Neon"] = 26.25, ["Neon|Fly"] = 102.92, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 124.19, ["Mega"] = 106.36, ["Mega|Ride"] = 155.57, ["Mega|Fly|Ride"] = 274.16}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 15.75, ["Neon"] = 6.27, ["Neon|Ride"] = 91.82, ["Mega"] = 24.98, ["Mega|Ride"] = 56.67, ["Mega|Fly|Ride"] = 615.9}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.05, ["Fly"] = 40.05, ["Ride"] = 15.74, ["Fly|Ride"] = 114.59, ["Neon"] = 3.92, ["Neon|Ride"] = 27.87, ["Neon|Fly|Ride"] = 113.48, ["Mega"] = 56.44, ["Mega|Ride"] = 77.8, ["Mega|Fly|Ride"] = 195.8}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 1115.63, ["Ride"] = 1032.94, ["Fly|Ride"] = 1185.62, ["Neon|Fly|Ride"] = 4119.53, ["Mega|Fly|Ride"] = 13776.45}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 13.79, ["Ride"] = 12.58, ["Fly|Ride"] = 42.05, ["Neon"] = 17.42, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 28.39, ["Neon|Fly|Ride"] = 56.75, ["Mega|Fly|Ride"] = 149.63}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 4.98, ["Neon|Ride"] = 37.41, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 63, ["Mega|Ride"] = 83.98, ["Mega|Fly|Ride"] = 214.44}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 9.03, ["Fly"] = 23.63, ["Ride"] = 23.12, ["Fly|Ride"] = 36.66, ["Neon"] = 155.57, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 91.88, ["Mega|Ride"] = 832.13, ["Mega|Fly|Ride"] = 342.48}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.05, ["Fly"] = 40.95, ["Ride"] = 15.78, ["Fly|Ride"] = 28.39, ["Neon"] = 7.67, ["Neon|Fly"] = 74.79, ["Neon|Ride"] = 18.06, ["Neon|Fly|Ride"] = 59.84, ["Mega"] = 68.16, ["Mega|Ride"] = 100.7, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 54.68, ["Ride"] = 91.88, ["Neon"] = 205.96, ["Neon|Ride"] = 338.63, ["Mega"] = 769.13, ["Mega|Ride"] = 981.85, ["Mega|Fly|Ride"] = 982.31}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 28.39, ["Ride"] = 21.63, ["Fly|Ride"] = 62.87, ["Neon"] = 9.64, ["Neon|Ride"] = 27.77, ["Mega"] = 78.01, ["Mega|Ride"] = 103.22, ["Mega|Fly|Ride"] = 127.32}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 73.5, ["Ride"] = 20.08, ["Fly|Ride"] = 65.63, ["Neon"] = 13.1, ["Neon|Fly"] = 147.1, ["Neon|Ride"] = 35.21, ["Neon|Fly|Ride"] = 140.79, ["Mega"] = 131.23, ["Mega|Ride"] = 238.5, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 65.58, ["Neon"] = 18.59, ["Neon|Fly"] = 62.7, ["Neon|Ride"] = 15.78, ["Mega"] = 111.38}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 2593.49, ["Ride"] = 13.94, ["Fly|Ride"] = 41, ["Neon"] = 3.92, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 84.07, ["Mega"] = 36.69, ["Mega|Fly"] = 108.94, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 139.32}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 23.62, ["Fly"] = 35.66, ["Ride"] = 15.52, ["Fly|Ride"] = 37.14, ["Neon|Ride"] = 119.78, ["Neon|Fly|Ride"] = 112.43, ["Mega"] = 840.48, ["Mega|Ride"] = 356.42, ["Mega|Fly|Ride"] = 403.44}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 649.69, ["Ride"] = 678.57, ["Fly|Ride"] = 774.38, ["Neon"] = 2015.99, ["Neon|Ride"] = 1837.5, ["Neon|Fly|Ride"] = 2046.19, ["Mega"] = 7004.26, ["Mega|Ride"] = 7705, ["Mega|Fly|Ride"] = 4851.4}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.05, ["Fly"] = 54.57, ["Ride"] = 15.27, ["Fly|Ride"] = 40.97, ["Neon"] = 4.41, ["Neon|Fly"] = 28.35, ["Neon|Ride"] = 16.83, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 31.4, ["Mega|Ride"] = 56.02, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 4.55, ["Ride"] = 53.6, ["Fly|Ride"] = 116.82, ["Neon"] = 21.04, ["Neon|Ride"] = 125.99, ["Neon|Fly|Ride"] = 210.13, ["Mega"] = 157.5, ["Mega|Ride"] = 267.02, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 81.11, ["Ride"] = 78.48, ["Fly|Ride"] = 154.88, ["Neon"] = 374.03, ["Neon|Ride"] = 418.49, ["Neon|Fly|Ride"] = 503.85, ["Mega"] = 2941.75, ["Mega|Fly|Ride"] = 1813.32}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 28.82, ["Ride"] = 90.57, ["Fly|Ride"] = 196.88, ["Neon"] = 291.38, ["Neon|Ride"] = 105, ["Mega"] = 700.75, ["Mega|Ride"] = 655.57, ["Mega|Fly|Ride"] = 846.88}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 9.97, ["Ride"] = 34.12, ["Fly|Ride"] = 210.13, ["Neon"] = 81.36, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 210.13, ["Mega"] = 343.55, ["Mega|Ride"] = 399.24, ["Mega|Fly|Ride"] = 420.25}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 23.42, ["Fly"] = 112.43, ["Ride"] = 108.98, ["Neon"] = 121.87, ["Neon|Ride"] = 356.42, ["Mega"] = 309.98, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 538.79}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 14.36, ["Ride"] = 39.38, ["Neon"] = 162.36, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 525, ["Mega"] = 656.15, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 769.79}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 4.19}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 6.57, ["Fly"] = 28.39, ["Ride"] = 27.57, ["Fly|Ride"] = 59.07, ["Neon"] = 28.88, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 67.26, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 244.67, ["Mega|Ride"] = 208.69, ["Mega|Fly|Ride"] = 237.77}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.19, ["Ride"] = 96.93, ["Neon"] = 17.05, ["Mega"] = 367.5, ["Mega|Fly|Ride"] = 945.54}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 45.92, ["Fly"] = 419.13, ["Ride"] = 59.07, ["Fly|Ride"] = 101.85, ["Neon"] = 294.18, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 704.66, ["Mega|Ride"] = 628.69, ["Mega|Fly|Ride"] = 628.68}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.94, ["Fly"] = 18.38, ["Ride"] = 17.07, ["Fly|Ride"] = 32.42, ["Neon"] = 20.62, ["Neon|Fly"] = 39.77, ["Neon|Ride"] = 22.93, ["Neon|Fly|Ride"] = 50.7, ["Mega"] = 328.13, ["Mega|Ride"] = 243.74, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 6.17, ["Ride"] = 23.23, ["Fly|Ride"] = 83.94, ["Neon"] = 14.27, ["Neon|Fly"] = 2321.82, ["Neon|Ride"] = 29.6, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 105, ["Mega|Fly"] = 301.45, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 277.31}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 198.54, ["Mega"] = 42}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 32.82, ["Fly"] = 84.07, ["Ride"] = 39.69, ["Fly|Ride"] = 73.34, ["Neon"] = 112.65, ["Neon|Ride"] = 87.41, ["Neon|Fly|Ride"] = 280.88, ["Mega|Ride"] = 752.24, ["Mega|Fly|Ride"] = 681.19}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 14.44, ["Neon"] = 15.78, ["Neon|Fly"] = 145.69, ["Neon|Fly|Ride"] = 140.79, ["Mega"] = 104.03, ["Mega|Ride"] = 208.11}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 5.25, ["Ride"] = 140.63, ["Neon"] = 52.5, ["Neon|Ride"] = 155.57, ["Neon|Fly|Ride"] = 294.18, ["Mega"] = 247.96, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1084.3}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 23.61, ["Ride"] = 15.74, ["Fly|Ride"] = 61.69, ["Neon"] = 7.87, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 81.25, ["Mega|Ride"] = 114.8, ["Mega|Fly|Ride"] = 254.26}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 6.98, ["Fly"] = 52.5, ["Ride"] = 23.59, ["Neon"] = 91.88, ["Neon|Ride"] = 126.09, ["Mega"] = 309.98, ["Mega|Ride"] = 140.79, ["Mega|Fly|Ride"] = 417.38}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.62, ["Ride"] = 129.31, ["Neon"] = 16.83, ["Neon|Ride"] = 109.14, ["Neon|Fly|Ride"] = 210.13, ["Mega"] = 197.25, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 314.14}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 32.82, ["Fly"] = 118.13, ["Ride"] = 73.84, ["Fly|Ride"] = 131.25, ["Neon"] = 137.82, ["Neon|Ride"] = 238.5, ["Mega"] = 787.5, ["Mega|Ride"] = 1260.71, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 18.24, ["Ride"] = 125.13, ["Neon"] = 110.97, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 387.76, ["Mega"] = 322.18, ["Mega|Ride"] = 769.12}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 5.16, ["Ride"] = 105, ["Neon"] = 49.45, ["Mega"] = 430.71, ["Mega|Ride"] = 1549.83, ["Mega|Fly|Ride"] = 1680.95}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 13.68, ["Ride"] = 105, ["Fly|Ride"] = 393.75, ["Neon"] = 52.5, ["Neon|Ride"] = 282.19, ["Neon|Fly|Ride"] = 280.52, ["Mega"] = 519.75, ["Mega|Ride"] = 561.03, ["Mega|Fly|Ride"] = 917.18}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.92, ["Neon"] = 43.32, ["Mega"] = 840.48}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 24.91, ["Ride"] = 16.79, ["Fly|Ride"] = 52.5, ["Neon"] = 3.86, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 29.91, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 60.24, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 182.81}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 5.91, ["Ride"] = 29.54, ["Fly|Ride"] = 105.08, ["Neon"] = 31.29, ["Neon|Fly"] = 464.38, ["Neon|Ride"] = 110.15, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 108.76, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 464.38}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 28.38, ["Ride"] = 14.2, ["Fly|Ride"] = 50.64, ["Neon"] = 5.25, ["Neon|Fly"] = 32.59, ["Neon|Ride"] = 25.3, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 42.39, ["Mega|Ride"] = 92.47, ["Mega|Fly|Ride"] = 140.79}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 59.07, ["Ride"] = 23.23, ["Fly|Ride"] = 78.75, ["Neon"] = 3.94, ["Neon|Ride"] = 92.89, ["Neon|Fly|Ride"] = 260.56, ["Mega"] = 189.05, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 309.98}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 5.25, ["Ride"] = 27.57, ["Fly|Ride"] = 99.75, ["Neon|Ride"] = 133.44, ["Mega"] = 420.25, ["Mega|Fly|Ride"] = 979.16}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 5.25, ["Fly"] = 30.11, ["Ride"] = 22.31, ["Fly|Ride"] = 53.82, ["Neon"] = 16.26, ["Neon|Ride"] = 33.49, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 233.25, ["Mega|Ride"] = 173.25, ["Mega|Fly|Ride"] = 309.39}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 33.72, ["Ride"] = 15.74, ["Fly|Ride"] = 59.89, ["Neon"] = 15.78, ["Mega"] = 166.58, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 490.64}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 4.17, ["Fly"] = 918.75, ["Ride"] = 66.13, ["Neon"] = 16.99, ["Neon|Fly"] = 42, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 210.13, ["Mega"] = 147.95, ["Mega|Ride"] = 305.82, ["Mega|Fly|Ride"] = 290.07}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 10.5, ["Ride"] = 60.96, ["Fly|Ride"] = 279.47, ["Neon"] = 65.63, ["Neon|Ride"] = 115.85, ["Neon|Fly|Ride"] = 350.9, ["Mega"] = 253.32, ["Mega|Fly"] = 981.26, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 57.6, ["Fly"] = 185.76, ["Ride"] = 92.27, ["Fly|Ride"] = 91.88, ["Neon"] = 210.13, ["Neon|Ride"] = 278.24, ["Neon|Fly|Ride"] = 322.54, ["Mega"] = 2520, ["Mega|Ride"] = 997.5, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Ride"] = 19.34, ["Fly|Ride"] = 65.63, ["Neon"] = 3.82, ["Neon|Ride"] = 17.41, ["Mega"] = 17.07, ["Mega|Ride"] = 69.57, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 3.7, ["Ride"] = 131.25, ["Neon"] = 49.51, ["Mega"] = 312.38, ["Mega|Ride"] = 406.59, ["Mega|Fly|Ride"] = 840.48}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 51.19, ["Ride"] = 56.75, ["Neon"] = 159.48, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 617.75, ["Mega|Fly|Ride"] = 1243.91}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 6.48, ["Fly"] = 190.32, ["Ride"] = 32.1, ["Fly|Ride"] = 125.89, ["Neon"] = 26.59, ["Neon|Ride"] = 56.75, ["Neon|Fly|Ride"] = 140.79, ["Mega"] = 156.19, ["Mega|Ride"] = 189.1, ["Mega|Fly|Ride"] = 313.09}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Fly"] = 157.5, ["Ride"] = 55.9, ["Fly|Ride"] = 79.41, ["Neon"] = 3.94, ["Neon|Ride"] = 26.17, ["Mega"] = 19.69, ["Mega|Fly"] = 105.08, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 122.33}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.63, ["Fly"] = 24.94, ["Ride"] = 14.44, ["Fly|Ride"] = 34, ["Neon"] = 13.06, ["Neon|Fly"] = 26.72, ["Neon|Ride"] = 34.85, ["Neon|Fly|Ride"] = 75.6, ["Mega"] = 126.09, ["Mega|Ride"] = 140.79, ["Mega|Fly|Ride"] = 210.13}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 14.2, ["Ride"] = 18.52, ["Neon"] = 2.63, ["Neon|Fly"] = 92.89, ["Neon|Ride"] = 25.93, ["Neon|Fly|Ride"] = 87.28, ["Mega"] = 82.45, ["Mega|Ride"] = 69.55, ["Mega|Fly|Ride"] = 124.24}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 15.73, ["Fly|Ride"] = 91.42, ["Neon"] = 3.94, ["Neon|Fly"] = 56.75, ["Neon|Ride"] = 19.67, ["Neon|Fly|Ride"] = 52.54, ["Mega"] = 35.44, ["Mega|Fly"] = 168, ["Mega|Ride"] = 61.69, ["Mega|Fly|Ride"] = 131.14}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Mega"] = 23.14, ["Mega|Ride"] = 105.08, ["Mega|Fly|Ride"] = 255.94}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 5.1, ["Ride"] = 157.5, ["Fly|Ride"] = 357.21, ["Neon"] = 25.15, ["Neon|Fly"] = 140.79, ["Neon|Ride"] = 40.63, ["Neon|Fly|Ride"] = 630.36, ["Mega"] = 207.38, ["Mega|Ride"] = 294.18, ["Mega|Fly|Ride"] = 705.48}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 6.18, ["Ride"] = 26.25, ["Fly|Ride"] = 84.07, ["Neon"] = 74.72, ["Neon|Ride"] = 136.57, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 374.03, ["Mega|Ride"] = 336.15, ["Mega|Fly|Ride"] = 364.88}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 6.56, ["Fly"] = 15.75, ["Ride"] = 16.21, ["Fly|Ride"] = 38.59, ["Neon"] = 41.74, ["Neon|Fly"] = 105.63, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 98.84, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 52.49, ["Ride"] = 98.75, ["Fly|Ride"] = 262.49, ["Neon"] = 538.13, ["Neon|Ride"] = 525.31, ["Mega"] = 3096.15, ["Mega|Ride"] = 1996.13}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 10.33, ["Fly"] = 98.67, ["Ride"] = 39.9, ["Neon"] = 65.63, ["Neon|Fly"] = 126.09, ["Mega"] = 607.03, ["Mega|Fly"] = 645.07, ["Mega|Ride"] = 577.5, ["Mega|Fly|Ride"] = 1020.48}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 13.13, ["Fly|Ride"] = 27.34, ["Neon"] = 2.61, ["Neon|Fly"] = 42.05, ["Neon|Ride"] = 14.46, ["Neon|Fly|Ride"] = 45.68, ["Mega"] = 56.75, ["Mega|Ride"] = 105.08, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 12.63, ["Ride"] = 13.13, ["Fly|Ride"] = 22.39, ["Neon"] = 5.25, ["Neon|Fly"] = 26.17, ["Neon|Ride"] = 16.83, ["Neon|Fly|Ride"] = 41.94, ["Mega"] = 39.34, ["Mega|Ride"] = 54.51, ["Mega|Fly|Ride"] = 94.5}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 366.85, ["Ride"] = 480.83, ["Fly|Ride"] = 518.44, ["Neon|Fly|Ride"] = 1764.31}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 8.71, ["Ride"] = 137.64, ["Fly|Ride"] = 72.19, ["Neon"] = 44.63, ["Mega"] = 608.3, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 1260.71}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 28.39, ["Ride"] = 17.07, ["Fly|Ride"] = 19.69, ["Neon"] = 2.61, ["Neon|Ride"] = 13.12, ["Neon|Fly|Ride"] = 39.32, ["Mega"] = 85.56, ["Mega|Ride"] = 63.06, ["Mega|Fly|Ride"] = 91.73}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 57.75, ["Ride"] = 105, ["Fly|Ride"] = 270.93, ["Neon"] = 155.49, ["Neon|Ride"] = 292.68, ["Neon|Fly|Ride"] = 271.68, ["Mega"] = 881.53, ["Mega|Ride"] = 708.75, ["Mega|Fly|Ride"] = 987}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.05, ["Fly"] = 18.88, ["Ride"] = 13.13, ["Fly|Ride"] = 35.74, ["Neon"] = 4.72, ["Neon|Fly"] = 69.36, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 77.42, ["Mega"] = 84.07, ["Mega|Fly"] = 168.11, ["Mega|Ride"] = 92.93, ["Mega|Fly|Ride"] = 182.44}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Ride"] = 37.13, ["Fly|Ride"] = 1312.5, ["Neon"] = 2.63, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 38.41, ["Neon|Fly|Ride"] = 275.08, ["Mega"] = 13.13, ["Mega|Fly"] = 98.77, ["Mega|Ride"] = 56.43, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 49.32, ["Fly"] = 164.07, ["Ride"] = 82.29, ["Neon"] = 174.46, ["Neon|Fly"] = 452.82, ["Neon|Ride"] = 232.2, ["Neon|Fly|Ride"] = 314.9, ["Mega"] = 671.34, ["Mega|Ride"] = 700.75, ["Mega|Fly|Ride"] = 771.75}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 42.05, ["Neon"] = 6.12, ["Neon|Ride"] = 54.65, ["Mega"] = 62.67, ["Mega|Ride"] = 92.89, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 34.13, ["Fly"] = 140.79, ["Ride"] = 56.44, ["Fly|Ride"] = 208.03, ["Neon"] = 398.29, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 249.38, ["Mega|Ride"] = 1680.95, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.92, ["Ride"] = 114.79, ["Neon"] = 45.71, ["Neon|Ride"] = 66.94, ["Mega"] = 164.07, ["Mega|Ride"] = 532.66, ["Mega|Fly|Ride"] = 396.58}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 70.41, ["Ride"] = 18.94, ["Neon"] = 11.48, ["Neon|Ride"] = 171.83, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 138.02, ["Mega|Ride"] = 569.63, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 14.36, ["Ride"] = 32.82, ["Neon"] = 399.29, ["Mega"] = 2101.18, ["Mega|Ride"] = 2611.88, ["Mega|Fly|Ride"] = 1238.7}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 104.67, ["Ride"] = 32.59, ["Neon"] = 6.54, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 127.77, ["Mega"] = 34.8, ["Mega|Fly"] = 158.61, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 274.72}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 26.78, ["Ride"] = 23.08, ["Fly|Ride"] = 72.17, ["Neon"] = 6.69, ["Neon|Fly"] = 41.88, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 84.07, ["Mega"] = 196.47, ["Mega|Fly|Ride"] = 281.54}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 9.19, ["Ride"] = 19.98, ["Neon"] = 65.63, ["Neon|Ride"] = 82.25, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 840.48, ["Mega|Ride"] = 454.13, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 30.19, ["Fly"] = 98.77, ["Ride"] = 44.99, ["Fly|Ride"] = 98.76, ["Neon"] = 139, ["Neon|Ride"] = 135.12, ["Neon|Fly|Ride"] = 273.17, ["Mega"] = 501.38, ["Mega|Ride"] = 464.38, ["Mega|Fly|Ride"] = 696.55}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 42.05, ["Fly"] = 58.07, ["Ride"] = 32.81, ["Fly|Ride"] = 47.86, ["Neon"] = 83.61, ["Neon|Ride"] = 98.75, ["Neon|Fly|Ride"] = 231.94, ["Mega"] = 407.64, ["Mega|Ride"] = 361.41, ["Mega|Fly|Ride"] = 376.13}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 59.07, ["Fly"] = 196.88, ["Ride"] = 100.87, ["Fly|Ride"] = 210.13, ["Neon"] = 280.52, ["Neon|Fly"] = 482.74, ["Neon|Ride"] = 355.11, ["Neon|Fly|Ride"] = 472.5, ["Mega|Ride"] = 980.18, ["Mega|Fly|Ride"] = 1179.15}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.19, ["Ride"] = 23.61, ["Fly|Ride"] = 262.5, ["Neon"] = 17.05, ["Neon|Ride"] = 140.79, ["Neon|Fly|Ride"] = 315.14, ["Mega"] = 155.57, ["Mega|Ride"] = 155.54, ["Mega|Fly|Ride"] = 263.54}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.94, ["Ride"] = 18.25, ["Fly|Ride"] = 118.13, ["Neon"] = 27.34, ["Neon|Ride"] = 69.28, ["Neon|Fly|Ride"] = 140.79, ["Mega"] = 140.75, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 248.46}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 9.08, ["Fly"] = 65.63, ["Ride"] = 33.64, ["Fly|Ride"] = 157.5, ["Neon"] = 38.8, ["Neon|Ride"] = 84.07, ["Neon|Fly|Ride"] = 163.06, ["Mega"] = 446.25, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 445.82}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.74, ["Fly|Ride"] = 36.74, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 12.6, ["Neon|Fly|Ride"] = 41.79, ["Mega"] = 18.38, ["Mega|Fly"] = 70.41, ["Mega|Ride"] = 19.99, ["Mega|Fly|Ride"] = 117.68}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 65.63, ["Fly"] = 140.79, ["Ride"] = 75.23, ["Fly|Ride"] = 280.52, ["Neon"] = 336.2, ["Neon|Fly"] = 2381.68, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 525, ["Mega"] = 838.38, ["Mega|Ride"] = 923.48, ["Mega|Fly|Ride"] = 885.94}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Fly"] = 21.04, ["Ride"] = 20.91, ["Fly|Ride"] = 89.25, ["Neon"] = 3.29, ["Neon|Ride"] = 52.5, ["Mega"] = 84.84, ["Mega|Fly"] = 112.43, ["Mega|Ride"] = 92.76, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.38, ["Ride"] = 15.74, ["Fly|Ride"] = 63.06, ["Neon"] = 10.85, ["Neon|Ride"] = 37.84, ["Neon|Fly|Ride"] = 92.89, ["Mega|Ride"] = 420.25, ["Mega|Fly|Ride"] = 626.73}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 64.32, ["Fly"] = 168.11, ["Ride"] = 105, ["Fly|Ride"] = 232.32, ["Neon"] = 196.88, ["Neon|Ride"] = 314.44, ["Neon|Fly|Ride"] = 361.05, ["Mega"] = 931.88, ["Mega|Ride"] = 892.5, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 28.35, ["Neon"] = 3.93, ["Neon|Ride"] = 1399.95, ["Neon|Fly|Ride"] = 105.66, ["Mega"] = 28.34, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 11.46}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.05, ["Ride"] = 32.82, ["Fly|Ride"] = 209.3, ["Neon"] = 6.57, ["Neon|Ride"] = 31.35, ["Neon|Fly|Ride"] = 126.09, ["Mega"] = 36.71, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 162.65}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 105, ["Ride"] = 170.63, ["Fly|Ride"] = 224.84, ["Neon"] = 503.99, ["Neon|Ride"] = 599.82, ["Neon|Fly|Ride"] = 735, ["Mega"] = 2241.96, ["Mega|Ride"] = 2813.47, ["Mega|Fly|Ride"] = 2391.94}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.75, ["Ride"] = 41.5, ["Neon"] = 18.38, ["Neon|Ride"] = 61.69, ["Mega"] = 150.11, ["Mega|Ride"] = 296.04, ["Mega|Fly|Ride"] = 249.33}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 210.13, ["Neon"] = 3.94, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 33.59, ["Mega|Ride"] = 77.76, ["Mega|Fly|Ride"] = 260.56}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 3.66, ["Ride"] = 35.44, ["Neon"] = 18.14, ["Neon|Ride"] = 125.04, ["Neon|Fly|Ride"] = 154.88, ["Mega"] = 853.13, ["Mega|Ride"] = 630.36, ["Mega|Fly|Ride"] = 619.94}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 10.5, ["Fly"] = 74.6, ["Ride"] = 23.23, ["Fly|Ride"] = 32.82, ["Neon"] = 63, ["Neon|Fly|Ride"] = 271.07, ["Mega"] = 232.2, ["Mega|Ride"] = 616.7, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 23.73, ["Ride"] = 59.06, ["Neon"] = 128.63, ["Neon|Ride"] = 157.71, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 538.13, ["Mega|Ride"] = 587.43, ["Mega|Fly|Ride"] = 577.49}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 133.09, ["Fly"] = 229.78, ["Ride"] = 154.88, ["Fly|Ride"] = 174.57, ["Neon"] = 620.46, ["Neon|Ride"] = 548.63, ["Neon|Fly|Ride"] = 577.5, ["Mega|Fly|Ride"] = 2633.84}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 8.91, ["Fly"] = 14.49, ["Ride"] = 13.12, ["Fly|Ride"] = 28.88, ["Neon"] = 39.82, ["Neon|Ride"] = 37.27, ["Neon|Fly|Ride"] = 60.79, ["Mega|Ride"] = 420.25, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.75, ["Neon"] = 8.8, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 140.79, ["Mega|Ride"] = 132.56, ["Mega|Fly|Ride"] = 238.5}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 8.3, ["Fly"] = 232.2, ["Ride"] = 53.82, ["Fly|Ride"] = 168.11, ["Neon"] = 80.07, ["Mega"] = 840.48, ["Mega|Ride"] = 527.07, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 31.5, ["Fly"] = 77.8, ["Ride"] = 59.14, ["Fly|Ride"] = 124.69, ["Neon"] = 162.12, ["Neon|Ride"] = 199.62, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 774.35, ["Mega|Fly"] = 981.26, ["Mega|Ride"] = 742.88, ["Mega|Fly|Ride"] = 869.46}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 12.65, ["Fly"] = 65.63, ["Ride"] = 76.23, ["Neon"] = 121.9, ["Neon|Ride"] = 105.05, ["Mega"] = 387.63, ["Mega|Ride"] = 645.07, ["Mega|Fly|Ride"] = 731.73}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 194.25, ["Ride"] = 195.42, ["Fly|Ride"] = 459.38, ["Neon"] = 1084.21, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1233.4, ["Mega|Fly|Ride"] = 5668.95}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 20.96, ["Fly"] = 140.79, ["Ride"] = 36.75, ["Fly|Ride"] = 70.39, ["Neon"] = 232.15, ["Neon|Ride"] = 140.78, ["Neon|Fly|Ride"] = 210.13, ["Mega"] = 1195.69, ["Mega|Ride"] = 520.25, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 16.69, ["Ride"] = 13, ["Fly|Ride"] = 42.05, ["Neon"] = 2.37, ["Neon|Ride"] = 12.63, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 23, ["Mega|Fly"] = 35.74, ["Mega|Ride"] = 37.14, ["Mega|Fly|Ride"] = 108.74}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Ride"] = 56.44, ["Neon"] = 6.56, ["Neon|Ride"] = 39.19, ["Mega"] = 109.14, ["Mega|Ride"] = 104.9, ["Mega|Fly|Ride"] = 461.35}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.68, ["Ride"] = 62.98, ["Fly|Ride"] = 42.05, ["Neon"] = 12.06, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 1181.25, ["Mega"] = 83.99, ["Mega|Fly"] = 301.53, ["Mega|Ride"] = 280.52, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 289.94, ["Fly"] = 580.47, ["Ride"] = 377.99, ["Fly|Ride"] = 491.66, ["Neon"] = 1365.78, ["Neon|Ride"] = 1703.05, ["Neon|Fly|Ride"] = 1378.13, ["Mega|Fly|Ride"] = 5034.75}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 70.41, ["Ride"] = 16.79, ["Fly|Ride"] = 41.99, ["Neon"] = 31.16, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 74.84, ["Mega|Fly|Ride"] = 460.11}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 3.92, ["Fly"] = 18.83, ["Ride"] = 15.94, ["Fly|Ride"] = 56.75, ["Neon"] = 46.45, ["Neon|Fly"] = 109.14, ["Neon|Ride"] = 35.74, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 418.15, ["Mega|Ride"] = 700.75, ["Mega|Fly|Ride"] = 224.44}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.93, ["Fly"] = 26.25, ["Ride"] = 22.44, ["Fly|Ride"] = 104.49, ["Neon"] = 13.09, ["Neon|Fly"] = 70.41, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 104, ["Mega"] = 137.82, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 274.32}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 28.38, ["Fly"] = 42.05, ["Ride"] = 28.39, ["Fly|Ride"] = 70.41, ["Neon"] = 91.88, ["Neon|Fly|Ride"] = 147.1, ["Mega"] = 945.54, ["Mega|Ride"] = 838.38, ["Mega|Fly|Ride"] = 613.55}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 315, ["Ride"] = 62.98, ["Fly|Ride"] = 42, ["Neon"] = 9.19, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 210, ["Mega"] = 112.41, ["Mega|Fly"] = 262.5, ["Mega|Fly|Ride"] = 596.54}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 3.56, ["Fly"] = 23.13, ["Ride"] = 22.32, ["Fly|Ride"] = 52.5, ["Neon"] = 57.37, ["Mega"] = 700.75, ["Mega|Ride"] = 321.49, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Fly"] = 28.39, ["Ride"] = 26.25, ["Fly|Ride"] = 49.4, ["Neon"] = 2.63, ["Neon|Ride"] = 24.33, ["Neon|Fly|Ride"] = 210.13, ["Mega"] = 49.83, ["Mega|Ride"] = 140.86, ["Mega|Fly|Ride"] = 232.32}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 8.44, ["Neon"] = 44.14, ["Mega"] = 170.63, ["Mega|Fly|Ride"] = 630.36}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 10.4, ["Ride"] = 70.41, ["Fly|Ride"] = 140.79, ["Neon"] = 136.07, ["Mega"] = 288.89, ["Mega|Ride"] = 561.03, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 9.18, ["Fly"] = 28.39, ["Ride"] = 22.24, ["Fly|Ride"] = 55.39, ["Neon"] = 49.93, ["Neon|Ride"] = 56.52, ["Neon|Fly|Ride"] = 109.73, ["Mega"] = 385.58, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 362.02}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 189, ["Fly"] = 217.1, ["Ride"] = 208.69, ["Fly|Ride"] = 228.01, ["Neon"] = 947.64, ["Neon|Ride"] = 928.73, ["Neon|Fly|Ride"] = 843.94, ["Mega|Fly|Ride"] = 3124.45}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Fly"] = 14.42, ["Ride"] = 13.83, ["Fly|Ride"] = 65.08, ["Neon"] = 28.39, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 138.02, ["Mega"] = 220.5, ["Mega|Ride"] = 345.97, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 2.1, ["Ride"] = 22.98, ["Fly|Ride"] = 75.37, ["Neon"] = 11.46, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 236.02, ["Mega"] = 124.69, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 44.14, ["Ride"] = 77.76, ["Fly|Ride"] = 210, ["Neon"] = 99.75, ["Neon|Ride"] = 241.1, ["Neon|Fly|Ride"] = 448.88, ["Mega"] = 367.5, ["Mega|Ride"] = 377.9, ["Mega|Fly|Ride"] = 435.75}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 62.99, ["Fly"] = 126.09, ["Ride"] = 82.4, ["Fly|Ride"] = 150.56, ["Neon"] = 328.13, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 1132.69, ["Mega|Fly|Ride"] = 1179.94}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 20.79, ["Ride"] = 56.75, ["Fly|Ride"] = 209.08, ["Neon"] = 79.77, ["Neon|Ride"] = 95.37, ["Neon|Fly|Ride"] = 224.73, ["Mega"] = 272.35, ["Mega|Ride"] = 235.12, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 21.04, ["Fly|Ride"] = 39.38, ["Neon"] = 11.82, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 84.07, ["Mega"] = 69.36, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 9.43, ["Ride"] = 61.98, ["Fly|Ride"] = 420.25, ["Neon"] = 83.02, ["Neon|Ride"] = 210.1, ["Neon|Fly|Ride"] = 420.25, ["Mega"] = 196.44, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 452.66}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 72.19, ["Fly"] = 140.84, ["Ride"] = 170.21, ["Fly|Ride"] = 223.13, ["Neon"] = 167.94, ["Neon|Ride"] = 218.06, ["Neon|Fly|Ride"] = 314.98, ["Mega"] = 452.82, ["Mega|Ride"] = 439.26, ["Mega|Fly|Ride"] = 549.94}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.63, ["Neon"] = 3.94, ["Neon|Fly"] = 196.47, ["Neon|Ride"] = 79.8, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 40.69, ["Mega|Fly"] = 93.51, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 219.19}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 8.43, ["Ride"] = 69.37, ["Neon"] = 48.57, ["Neon|Ride"] = 393.75, ["Mega"] = 251.25, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 529.77}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 1047.37, ["Fly"] = 1092.61, ["Ride"] = 1023.75, ["Fly|Ride"] = 1029, ["Neon|Ride"] = 3328.33, ["Neon|Fly|Ride"] = 3277.37, ["Mega|Fly|Ride"] = 13505.26}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 23.07, ["Ride"] = 74.82, ["Neon"] = 131.25, ["Neon|Ride"] = 315.19, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 517.13, ["Mega|Ride"] = 524.95, ["Mega|Fly|Ride"] = 694.58}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.93, ["Fly"] = 46.82, ["Ride"] = 30.19, ["Fly|Ride"] = 262.5, ["Neon"] = 17.07, ["Neon|Fly"] = 89.32, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 95.6, ["Mega"] = 84.51, ["Mega|Ride"] = 96.65, ["Mega|Fly|Ride"] = 203.43}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 10.5, ["Ride"] = 131.22, ["Neon"] = 78.75, ["Neon|Fly|Ride"] = 158.65, ["Mega|Ride"] = 350.9, ["Mega|Fly|Ride"] = 774.35}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 49.4, ["Fly|Ride"] = 42.05, ["Neon"] = 2.24, ["Neon|Ride"] = 27.22, ["Neon|Fly|Ride"] = 95.39, ["Mega"] = 17, ["Mega|Ride"] = 27.56, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 85.32, ["Ride"] = 136.5, ["Fly|Ride"] = 299.24, ["Neon"] = 301.6, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 435.75, ["Mega"] = 1096.83, ["Mega|Ride"] = 1112.99, ["Mega|Fly|Ride"] = 1173.38}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 6.28, ["Fly"] = 101.07, ["Ride"] = 20.14, ["Fly|Ride"] = 812.64, ["Neon"] = 35.43, ["Neon|Ride"] = 84, ["Mega"] = 137.64, ["Mega|Ride"] = 230.1, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.24, ["Ride"] = 24.94, ["Neon"] = 11.59, ["Neon|Ride"] = 39.38, ["Mega"] = 155.57, ["Mega|Ride"] = 277.34, ["Mega|Fly|Ride"] = 386.54}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 52.5, ["Fly"] = 126, ["Ride"] = 47.5, ["Fly|Ride"] = 91.88, ["Neon"] = 199.4, ["Neon|Ride"] = 280.52, ["Neon|Fly|Ride"] = 301.49, ["Mega"] = 474.89, ["Mega|Ride"] = 490.64, ["Mega|Fly|Ride"] = 418.59}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 18.38, ["Fly"] = 183.75, ["Ride"] = 42.05, ["Fly|Ride"] = 87.08, ["Neon"] = 91.88, ["Neon|Fly"] = 179.82, ["Neon|Ride"] = 232.2, ["Neon|Fly|Ride"] = 217.1, ["Mega"] = 376.85, ["Mega|Ride"] = 418.2, ["Mega|Fly|Ride"] = 623.43}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 45.94, ["Ride"] = 280.52, ["Fly|Ride"] = 656.25, ["Neon"] = 165.38, ["Neon|Ride"] = 561.03, ["Neon|Fly|Ride"] = 908.92, ["Mega"] = 1449.82, ["Mega|Ride"] = 1393.1, ["Mega|Fly|Ride"] = 1247.06}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 8.43, ["Neon"] = 19.66, ["Neon|Ride"] = 80.46, ["Neon|Fly|Ride"] = 224.44, ["Mega"] = 103.69, ["Mega|Ride"] = 143.97, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 5.24, ["Fly"] = 52.5, ["Ride"] = 22.32, ["Fly|Ride"] = 128.87, ["Neon"] = 84.07, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 140.79, ["Mega"] = 309.9, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 578.17}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 139.43, ["Ride"] = 156.19, ["Fly|Ride"] = 245.85, ["Neon"] = 459.38, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 627.38, ["Mega"] = 2098.69, ["Mega|Ride"] = 2361.19, ["Mega|Fly|Ride"] = 2079.12}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.15, ["Fly"] = 15.74, ["Ride"] = 13.12, ["Fly|Ride"] = 43.02, ["Neon"] = 7.88, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 21.04, ["Neon|Fly|Ride"] = 61.1, ["Mega"] = 96.58, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 144.37}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 6.08, ["Fly"] = 39.94, ["Ride"] = 23.63, ["Fly|Ride"] = 44.15, ["Neon"] = 35.74, ["Neon|Ride"] = 35.43, ["Neon|Fly|Ride"] = 70.32, ["Mega"] = 220.5, ["Mega|Ride"] = 192.39, ["Mega|Fly|Ride"] = 350.9}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Ride"] = 16.83, ["Fly|Ride"] = 29.65, ["Neon"] = 2.1, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 11.81, ["Neon|Fly|Ride"] = 19.67, ["Mega"] = 19.99, ["Mega|Ride"] = 30.19, ["Mega|Fly|Ride"] = 63.32}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 31.54, ["Neon"] = 3.47, ["Neon|Ride"] = 42.05, ["Mega"] = 30.19, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 3.76, ["Fly"] = 131.75, ["Ride"] = 19.69, ["Neon"] = 10.95, ["Neon|Ride"] = 63, ["Mega"] = 105, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 42.92, ["Ride"] = 128.58, ["Neon"] = 133.77, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 630, ["Mega"] = 449.67, ["Mega|Fly|Ride"] = 520.1}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 3.34, ["Fly"] = 16.49, ["Ride"] = 14.16, ["Fly|Ride"] = 33.95, ["Neon"] = 11.58, ["Neon|Fly"] = 20.98, ["Neon|Ride"] = 22.3, ["Neon|Fly|Ride"] = 54.64, ["Mega"] = 126, ["Mega|Fly"] = 210.1, ["Mega|Ride"] = 112.43, ["Mega|Fly|Ride"] = 170.52}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 2.1, ["Fly"] = 28.02, ["Ride"] = 15.75, ["Fly|Ride"] = 48.81, ["Neon"] = 10.49, ["Neon|Fly"] = 36.01, ["Neon|Ride"] = 26.96, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 134.71, ["Mega|Fly"] = 196.47, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 140.79}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.63, ["Fly"] = 25.24, ["Ride"] = 24.93, ["Fly|Ride"] = 65.63, ["Neon"] = 11.49, ["Neon|Fly"] = 95.49, ["Neon|Ride"] = 25.76, ["Neon|Fly|Ride"] = 112.12, ["Mega"] = 103.78, ["Mega|Fly"] = 408.19, ["Mega|Ride"] = 84.34, ["Mega|Fly|Ride"] = 241.5}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 13.01, ["Fly"] = 43.32, ["Ride"] = 131.25, ["Neon"] = 42.05, ["Neon|Ride"] = 112.3, ["Neon|Fly|Ride"] = 182.81, ["Mega"] = 245.85, ["Mega|Ride"] = 280.52, ["Mega|Fly|Ride"] = 322.54}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 6.34, ["Fly"] = 160.69, ["Neon"] = 85.28, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 728.44, ["Mega"] = 228.38, ["Mega|Ride"] = 412.13, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.61, ["Fly"] = 91.88, ["Ride"] = 18.94, ["Fly|Ride"] = 63.67, ["Neon"] = 19.67, ["Neon|Fly"] = 196.65, ["Neon|Ride"] = 60.88, ["Neon|Fly|Ride"] = 101.85, ["Mega"] = 183.75, ["Mega|Ride"] = 175.35, ["Mega|Fly|Ride"] = 280.52}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 20.69, ["Ride"] = 11.43, ["Fly|Ride"] = 70.88, ["Neon"] = 11.7, ["Neon|Fly"] = 85.93, ["Neon|Ride"] = 48.35, ["Neon|Fly|Ride"] = 98.77, ["Mega"] = 420.25, ["Mega|Ride"] = 155.54, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 167.01, ["Fly"] = 393.75, ["Ride"] = 204.54, ["Fly|Ride"] = 393.75, ["Neon"] = 794.79, ["Neon|Ride"] = 951.85, ["Neon|Fly|Ride"] = 897.75, ["Mega|Fly|Ride"] = 3661.88}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 6.57, ["Ride"] = 61.74, ["Neon"] = 15.74, ["Neon|Fly|Ride"] = 232.2, ["Mega"] = 140.84, ["Mega|Ride"] = 309.98, ["Mega|Fly|Ride"] = 700.75}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 26.25, ["Fly|Ride"] = 28.88, ["Neon"] = 11.01, ["Neon|Ride"] = 58.07, ["Neon|Fly|Ride"] = 124.24, ["Mega"] = 203.44, ["Mega|Fly"] = 365.61, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 295.61}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 2.76, ["Fly|Ride"] = 155.57, ["Neon"] = 37.8, ["Neon|Fly|Ride"] = 630, ["Mega"] = 414.94, ["Mega|Ride"] = 359.89, ["Mega|Fly|Ride"] = 280.52}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.05, ["Fly"] = 26.17, ["Ride"] = 16.88, ["Fly|Ride"] = 38.19, ["Neon"] = 2.1, ["Neon|Fly"] = 18.38, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 44.5, ["Mega"] = 15.67, ["Mega|Fly|Ride"] = 47.61}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.41, ["Fly"] = 26.64, ["Ride"] = 18.57, ["Fly|Ride"] = 57.91, ["Neon"] = 18.31, ["Neon|Ride"] = 33.64, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 280.52, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 232.09}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 11.71, ["Neon|Ride"] = 280.52, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 84.48, ["Mega|Ride"] = 148.32, ["Mega|Fly|Ride"] = 450.19}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 70.86, ["Fly"] = 130.29, ["Ride"] = 87.94, ["Fly|Ride"] = 158.13, ["Neon"] = 262.5, ["Neon|Ride"] = 354.37, ["Neon|Fly|Ride"] = 408.19, ["Mega|Ride"] = 3503.72, ["Mega|Fly|Ride"] = 1653.63}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.83, ["Fly"] = 65.63, ["Ride"] = 24.76, ["Fly|Ride"] = 65.54, ["Neon"] = 23.21, ["Neon|Ride"] = 62.98, ["Neon|Fly|Ride"] = 309.98, ["Mega"] = 161.78, ["Mega|Ride"] = 210.13, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 56.75, ["Fly|Ride"] = 140.79, ["Neon"] = 9.35, ["Neon|Ride"] = 177.07, ["Neon|Fly|Ride"] = 520.64, ["Mega"] = 64.09, ["Mega|Fly"] = 409.74, ["Mega|Ride"] = 84.07, ["Mega|Fly|Ride"] = 209.08}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 52.5, ["Fly"] = 155.57, ["Ride"] = 76.63, ["Fly|Ride"] = 157.5, ["Neon"] = 163.8, ["Neon|Ride"] = 156.03, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 552.57, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 734.99}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.05, ["Ride"] = 16.83, ["Fly|Ride"] = 31.49, ["Neon"] = 2.1, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 12.63, ["Neon|Fly|Ride"] = 39.37, ["Mega"] = 14.99, ["Mega|Ride"] = 30.19, ["Mega|Fly|Ride"] = 39.53}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 2.61, ["Neon|Ride"] = 44.14, ["Neon|Fly|Ride"] = 140.79, ["Mega"] = 26.25, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 81.52, ["Mega|Fly|Ride"] = 155.96}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.63, ["Ride"] = 65.77, ["Neon"] = 9.19, ["Neon|Ride"] = 30.39, ["Neon|Fly|Ride"] = 181.22, ["Mega"] = 59.07, ["Mega|Ride"] = 127.88, ["Mega|Fly|Ride"] = 464.38}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 6.56, ["Fly"] = 56.74, ["Ride"] = 32.57, ["Fly|Ride"] = 91.87, ["Neon"] = 15.75, ["Neon|Fly"] = 81.97, ["Neon|Ride"] = 69.06, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 84.32, ["Mega|Fly"] = 185.76, ["Mega|Ride"] = 140.78, ["Mega|Fly|Ride"] = 245.06}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 11.82, ["Fly|Ride"] = 24.94, ["Neon"] = 2.1, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 26.24, ["Mega"] = 18.38, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 23.78, ["Mega|Fly|Ride"] = 123.99}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 11.38, ["Ride"] = 45.94, ["Neon"] = 59.83, ["Neon|Fly|Ride"] = 173.92, ["Mega"] = 378.23, ["Mega|Ride"] = 418.15, ["Mega|Fly|Ride"] = 363.51}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 3202.5, ["Fly"] = 3503.72, ["Ride"] = 3804.94, ["Fly|Ride"] = 3281.25, ["Neon|Fly|Ride"] = 8917.36}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 28.27, ["Ride"] = 16.79, ["Fly|Ride"] = 38.66, ["Neon"] = 6.48, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 22.09, ["Neon|Fly|Ride"] = 45.45, ["Mega"] = 59.07, ["Mega|Ride"] = 87.08, ["Mega|Fly|Ride"] = 137.64}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 3.81, ["Ride"] = 26.25, ["Neon"] = 9.18, ["Neon|Ride"] = 70.41, ["Mega"] = 81.87, ["Mega|Ride"] = 136.59, ["Mega|Fly|Ride"] = 630.36}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 11.8, ["Ride"] = 27.09, ["Fly|Ride"] = 56.13, ["Neon"] = 88.92, ["Neon|Ride"] = 132.39, ["Neon|Fly|Ride"] = 202.01, ["Mega"] = 420.25, ["Mega|Ride"] = 472.78, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 60.24, ["Ride"] = 109.14, ["Fly|Ride"] = 140.79, ["Neon"] = 125.08, ["Neon|Fly|Ride"] = 420.25, ["Mega"] = 481.69, ["Mega|Ride"] = 620.82, ["Mega|Fly|Ride"] = 546.32}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 133.76, ["Fly"] = 210.13, ["Ride"] = 157.49, ["Fly|Ride"] = 259.62, ["Neon"] = 1528.61, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 524.99, ["Mega"] = 6303.51, ["Mega|Ride"] = 3012.03, ["Mega|Fly|Ride"] = 3387.09}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 5.33, ["Ride"] = 26.25, ["Fly|Ride"] = 112.43, ["Neon"] = 52.49, ["Neon|Fly"] = 56.75, ["Neon|Ride"] = 124.24, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 98.77, ["Mega|Ride"] = 185.76, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 13.26, ["Neon|Fly"] = 94.57, ["Neon|Ride"] = 34.13, ["Mega"] = 53.6, ["Mega|Ride"] = 262.24, ["Mega|Fly|Ride"] = 361.41}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 101.99, ["Ride"] = 20.51, ["Fly|Ride"] = 78.75, ["Neon"] = 8.44, ["Neon|Ride"] = 36.68, ["Mega"] = 87.28, ["Mega|Ride"] = 112.43, ["Mega|Fly|Ride"] = 266.86}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 9.13, ["Neon"] = 322.54, ["Neon|Ride"] = 132.3, ["Mega"] = 374.07, ["Mega|Ride"] = 464.38, ["Mega|Fly|Ride"] = 617.54}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 70.41, ["Neon"] = 2.1, ["Neon|Ride"] = 42.05, ["Mega"] = 17.07, ["Mega|Ride"] = 168.11, ["Mega|Fly|Ride"] = 280.52}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 83.88, ["Fly"] = 248.28, ["Ride"] = 114.58, ["Fly|Ride"] = 168.1, ["Neon"] = 363.51, ["Neon|Fly"] = 603.05, ["Neon|Ride"] = 350.9, ["Neon|Fly|Ride"] = 455.44, ["Mega"] = 1680.95, ["Mega|Ride"] = 1286.25, ["Mega|Fly|Ride"] = 1233.4}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.21, ["Ride"] = 32.29, ["Neon"] = 2.63, ["Mega"] = 91.42, ["Mega|Ride"] = 137.82}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 37.32, ["Ride"] = 52.39, ["Fly|Ride"] = 147.1, ["Neon"] = 261.95, ["Neon|Ride"] = 140.79, ["Neon|Fly|Ride"] = 280.52, ["Mega"] = 2625, ["Mega|Ride"] = 1239, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 23.94, ["Ride"] = 19.99, ["Fly|Ride"] = 70.39, ["Neon"] = 3.92, ["Neon|Ride"] = 78.75, ["Mega"] = 39.94, ["Mega|Ride"] = 140.79, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Fly"] = 280.52, ["Neon"] = 7.88, ["Mega"] = 80.73, ["Mega|Ride"] = 140.79, ["Mega|Fly|Ride"] = 282.19}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 6.5, ["Ride"] = 54.57, ["Fly|Ride"] = 140.79, ["Neon"] = 39.38, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 105.08, ["Neon|Fly|Ride"] = 687.1, ["Mega"] = 141.16, ["Mega|Ride"] = 189.12, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 321.57, ["Fly"] = 542.15, ["Ride"] = 400.86, ["Fly|Ride"] = 410.82, ["Neon"] = 918.75, ["Neon|Ride"] = 869.84, ["Neon|Fly|Ride"] = 1065.4, ["Mega"] = 3519.48, ["Mega|Ride"] = 2361.19, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 30.02, ["Fly"] = 52.5, ["Ride"] = 59.07, ["Fly|Ride"] = 96.64, ["Neon"] = 165.38, ["Neon|Fly"] = 309.98, ["Neon|Ride"] = 186.38, ["Neon|Fly|Ride"] = 262.49, ["Mega|Ride"] = 962.07, ["Mega|Fly|Ride"] = 826.82}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 15.8, ["Fly|Ride"] = 70.87, ["Neon"] = 3.73, ["Neon|Fly"] = 136.59, ["Neon|Ride"] = 21.04, ["Neon|Fly|Ride"] = 73.85, ["Mega"] = 42, ["Mega|Ride"] = 77.67, ["Mega|Fly|Ride"] = 266.6}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 9.02, ["Fly"] = 108.2, ["Ride"] = 26.24, ["Fly|Ride"] = 98.44, ["Neon"] = 26.23, ["Neon|Fly"] = 109.14, ["Neon|Ride"] = 62.88, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 198.19, ["Mega|Fly"] = 914.03, ["Mega|Ride"] = 270.84, ["Mega|Fly|Ride"] = 322.54}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 7.76, ["Ride"] = 24.68, ["Fly|Ride"] = 98.77, ["Neon"] = 105, ["Neon|Ride"] = 73.56, ["Neon|Fly|Ride"] = 137.64, ["Mega"] = 501.52, ["Mega|Ride"] = 309.94, ["Mega|Fly|Ride"] = 464.38}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 2.35, ["Neon"] = 7.65, ["Neon|Ride"] = 65.63, ["Mega"] = 43.32, ["Mega|Ride"] = 118.13}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.39, ["Fly"] = 86.63, ["Ride"] = 15.73, ["Fly|Ride"] = 64.26, ["Neon"] = 27.57, ["Neon|Ride"] = 31.36, ["Neon|Fly|Ride"] = 280.52, ["Mega"] = 542.15, ["Mega|Ride"] = 322.54}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 78.75, ["Ride"] = 101.06, ["Fly|Ride"] = 183.74, ["Neon"] = 485.39, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 624.06, ["Mega|Ride"] = 2416.36, ["Mega|Fly|Ride"] = 2165.63}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 32.71, ["Ride"] = 52.27, ["Fly|Ride"] = 144, ["Neon"] = 139.32, ["Neon|Ride"] = 280.52, ["Mega"] = 630.36, ["Mega|Ride"] = 645.07, ["Mega|Fly|Ride"] = 708.1}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2833.26, ["Fly"] = 3361.88, ["Ride"] = 2551.5, ["Fly|Ride"] = 2493.75, ["Neon"] = 12607.01, ["Neon|Fly|Ride"] = 6445.69, ["Mega|Fly|Ride"] = 25904.82}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 22.32, ["Fly|Ride"] = 157.5, ["Neon"] = 3.94, ["Neon|Ride"] = 33.24, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 91.88, ["Mega|Ride"] = 210.09, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 9.19, ["Ride"] = 51.1, ["Fly|Ride"] = 280.52, ["Neon"] = 53.76, ["Neon|Ride"] = 109.12, ["Mega"] = 105, ["Mega|Ride"] = 198.18, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 996.19, ["Fly"] = 1401.49, ["Ride"] = 982.07, ["Fly|Ride"] = 1135.32, ["Neon"] = 4045.81, ["Neon|Ride"] = 3256.82, ["Neon|Fly|Ride"] = 3150, ["Mega|Ride"] = 15909, ["Mega|Fly|Ride"] = 10053.75}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 26.22, ["Ride"] = 77.75, ["Neon"] = 156.29, ["Mega"] = 590.05, ["Mega|Ride"] = 1084.3, ["Mega|Fly|Ride"] = 735}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.1, ["Ride"] = 65.71, ["Fly|Ride"] = 56.75, ["Neon"] = 12.33, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 210.13, ["Mega|Fly|Ride"] = 278.25}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 16.83, ["Fly|Ride"] = 52.5, ["Neon"] = 3.81, ["Neon|Fly"] = 40.94, ["Neon|Ride"] = 50.92, ["Mega"] = 15.89, ["Mega|Ride"] = 54.57, ["Mega|Fly|Ride"] = 125.04}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 73.53, ["Ride"] = 124.69, ["Fly|Ride"] = 309.98, ["Neon"] = 315, ["Neon|Ride"] = 553.67, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 2521.41}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 5.01, ["Ride"] = 27.55, ["Neon"] = 11.07, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 141.75, ["Mega|Ride"] = 208.92, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 52.48, ["Ride"] = 232.2, ["Fly|Ride"] = 464.38, ["Neon"] = 590.63, ["Mega"] = 2101.18, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 3.93, ["Fly"] = 105, ["Fly|Ride"] = 112.43, ["Neon"] = 49.38, ["Neon|Ride"] = 262.43, ["Mega"] = 196.88}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 257.25, ["Ride"] = 232.14, ["Fly|Ride"] = 327.8, ["Neon"] = 1092.61, ["Neon|Ride"] = 8404.68, ["Neon|Fly|Ride"] = 905.63, ["Mega|Fly|Ride"] = 3193.79}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 22.32, ["Fly|Ride"] = 83.02, ["Neon"] = 20.97, ["Neon|Ride"] = 45.34, ["Neon|Fly|Ride"] = 96.66, ["Mega"] = 285.48, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 350.34}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.05, ["Fly"] = 28.39, ["Ride"] = 12.46, ["Fly|Ride"] = 33.63, ["Neon"] = 5.16, ["Neon|Fly"] = 39.08, ["Neon|Ride"] = 23.55, ["Neon|Fly|Ride"] = 40.78, ["Mega"] = 34.12, ["Mega|Fly"] = 420.25, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 128.63}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 840.5, ["Fly"] = 1065.3, ["Ride"] = 901.69, ["Fly|Ride"] = 892.49, ["Neon|Ride"] = 3889.04, ["Neon|Fly|Ride"] = 3466.94, ["Mega"] = 27315.17, ["Mega|Fly|Ride"] = 28015.92}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 3.39, ["Fly"] = 980.19, ["Ride"] = 36.16, ["Neon"] = 25.47, ["Neon|Ride"] = 116.11, ["Neon|Fly|Ride"] = 62.7, ["Mega"] = 133.42, ["Mega|Ride"] = 145.57, ["Mega|Fly|Ride"] = 232.2}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 7.44, ["Fly"] = 140.79, ["Ride"] = 33.64, ["Fly|Ride"] = 70.41, ["Neon"] = 25.19, ["Neon|Ride"] = 46.41, ["Neon|Fly|Ride"] = 126.05, ["Mega"] = 138.69, ["Mega|Fly"] = 155.57, ["Mega|Ride"] = 192.94, ["Mega|Fly|Ride"] = 267.65}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 23.59, ["Fly"] = 38.21, ["Ride"] = 38.06, ["Fly|Ride"] = 61.69, ["Neon"] = 294.88, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 162.75, ["Mega"] = 2067.56, ["Mega|Fly|Ride"] = 767.82}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 13.13, ["Fly"] = 78.81, ["Ride"] = 24.94, ["Fly|Ride"] = 60.36, ["Neon"] = 54.48, ["Neon|Ride"] = 70.44, ["Neon|Fly|Ride"] = 155.5, ["Mega"] = 387.76, ["Mega|Ride"] = 735, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 26.25, ["Ride"] = 56.75, ["Fly|Ride"] = 636.57, ["Neon"] = 87.21, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 347.75, ["Mega|Ride"] = 494.82, ["Mega|Fly|Ride"] = 561.03}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.05, ["Fly"] = 42.05, ["Ride"] = 105, ["Fly|Ride"] = 155.57, ["Neon"] = 2.1, ["Neon|Ride"] = 42.05, ["Mega"] = 15.96, ["Mega|Ride"] = 89.25, ["Mega|Fly|Ride"] = 874.13}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 25.03, ["Fly"] = 49.3, ["Ride"] = 38.06, ["Fly|Ride"] = 91.86, ["Neon"] = 131.25, ["Neon|Fly"] = 310.21, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 236.24, ["Mega"] = 3361.88, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 753.44, ["Ride"] = 25.99, ["Fly|Ride"] = 112.43, ["Neon"] = 42, ["Neon|Ride"] = 155.57, ["Mega"] = 656.25, ["Mega|Fly|Ride"] = 561.03}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 35.74, ["Ride"] = 18.38, ["Fly|Ride"] = 68.25, ["Neon|Fly"] = 63.06, ["Neon|Ride"] = 64.32, ["Mega"] = 1037.99, ["Mega|Ride"] = 238.5, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.35, ["Ride"] = 61.69, ["Neon"] = 105, ["Mega"] = 136.59, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 14.44, ["Fly"] = 262.23, ["Ride"] = 31.54, ["Neon"] = 83.25, ["Neon|Ride"] = 112.41, ["Neon|Fly|Ride"] = 209.08, ["Mega"] = 524.98, ["Mega|Ride"] = 533.71, ["Mega|Fly|Ride"] = 628.68}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 6.13, ["Neon"] = 10.14, ["Neon|Ride"] = 78.75, ["Mega"] = 72.66, ["Mega|Fly|Ride"] = 309.61}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 27.15, ["Neon"] = 2.1, ["Neon|Ride"] = 65.63, ["Mega"] = 15.75, ["Mega|Ride"] = 43.63, ["Mega|Fly|Ride"] = 199.32}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Neon"] = 2.1, ["Neon|Fly"] = 393.65, ["Neon|Ride"] = 22.32, ["Mega"] = 17.04, ["Mega|Ride"] = 51.19, ["Mega|Fly|Ride"] = 96.76}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 1481.32, ["Ride"] = 19.94, ["Fly|Ride"] = 27.44, ["Neon"] = 5.25, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 84.07, ["Mega"] = 86.63, ["Mega|Ride"] = 159.68, ["Mega|Fly|Ride"] = 171.94}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 5224.08, ["Neon"] = 28.88, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 52.55, ["Mega"] = 140.78, ["Mega|Ride"] = 158.33}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 39.46, ["Ride"] = 11.81, ["Fly|Ride"] = 42, ["Neon"] = 11.48, ["Neon|Ride"] = 31.38, ["Neon|Fly|Ride"] = 80.07, ["Mega"] = 216.57, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 350.9}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 83.2, ["Ride"] = 122.33, ["Fly|Ride"] = 392.93, ["Neon"] = 183.75, ["Neon|Ride"] = 315.19, ["Neon|Fly|Ride"] = 322.54, ["Mega"] = 695.5, ["Mega|Ride"] = 761.24, ["Mega|Fly|Ride"] = 845.94}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.05, ["Fly"] = 26.25, ["Ride"] = 15.27, ["Fly|Ride"] = 27.39, ["Neon"] = 2.63, ["Neon|Fly"] = 22.66, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 38.66, ["Mega"] = 28.25, ["Mega|Ride"] = 56.6, ["Mega|Fly|Ride"] = 116.82}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 7.86, ["Fly"] = 45.44, ["Ride"] = 24.94, ["Fly|Ride"] = 56.75, ["Neon"] = 37.77, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 101.84, ["Mega"] = 523.69, ["Mega|Ride"] = 302.58, ["Mega|Fly|Ride"] = 338.98}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 6.48, ["Fly"] = 20.4, ["Ride"] = 22.08, ["Fly|Ride"] = 79.85, ["Neon"] = 50.93, ["Neon|Ride"] = 51.82, ["Neon|Fly|Ride"] = 138.69, ["Mega"] = 1023.28, ["Mega|Ride"] = 333.96, ["Mega|Fly|Ride"] = 385.14}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 2.1, ["Fly"] = 140.38, ["Neon"] = 16.15, ["Neon|Ride"] = 70.41, ["Mega"] = 150.94, ["Mega|Ride"] = 232.2}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Ride"] = 15.74, ["Fly|Ride"] = 56.75, ["Neon"] = 3.84, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 17.42, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 35.44, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 98.37}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 13.71, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 31.82, ["Neon|Fly|Ride"] = 210.13, ["Mega"] = 161.38, ["Mega|Fly"] = 735, ["Mega|Ride"] = 139.32, ["Mega|Fly|Ride"] = 334.38}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 879.38, ["Fly"] = 1263.87, ["Ride"] = 880.22, ["Fly|Ride"] = 945, ["Neon"] = 2941.65, ["Neon|Ride"] = 1968.75, ["Neon|Fly|Ride"] = 2093.97, ["Mega|Fly|Ride"] = 7398.57}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 55.97, ["Ride"] = 98.44, ["Fly|Ride"] = 126.09, ["Neon"] = 267.02, ["Neon|Ride"] = 279.57, ["Neon|Fly|Ride"] = 406.33, ["Mega"] = 3147.38, ["Mega|Ride"] = 1355.27, ["Mega|Fly|Ride"] = 1155}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly"] = 62.98, ["Ride"] = 68.39, ["Neon"] = 5.99, ["Neon|Ride"] = 74.61, ["Neon|Fly|Ride"] = 315, ["Mega"] = 48.87, ["Mega|Ride"] = 131.25}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 31.5, ["Ride"] = 52.49, ["Fly|Ride"] = 262.5, ["Neon"] = 249.12, ["Neon|Ride"] = 176.51, ["Neon|Fly|Ride"] = 300.57, ["Mega"] = 656.25, ["Mega|Ride"] = 771.15, ["Mega|Fly|Ride"] = 710.07}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 6.04, ["Ride"] = 36.46, ["Fly|Ride"] = 279.47, ["Neon"] = 42.03, ["Neon|Ride"] = 124.2, ["Mega"] = 266.86, ["Mega|Ride"] = 350.9, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 292.69, ["Fly"] = 928.73, ["Ride"] = 315, ["Fly|Ride"] = 372.63, ["Neon|Ride"] = 1226.05, ["Neon|Fly|Ride"] = 1182.57, ["Mega|Fly|Ride"] = 4094.11}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 102.38, ["Ride"] = 21, ["Fly|Ride"] = 129.93, ["Neon"] = 9.01, ["Mega"] = 182.81, ["Mega|Fly"] = 280.52}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Ride"] = 18.94, ["Neon"] = 19.03, ["Neon|Ride"] = 140.79}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 43.47, ["Ride"] = 70.88, ["Fly|Ride"] = 210.13, ["Neon"] = 151.26, ["Neon|Ride"] = 183.75, ["Mega"] = 700.75, ["Mega|Ride"] = 974.54, ["Mega|Fly|Ride"] = 738.29}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.05, ["Ride"] = 19.95, ["Fly|Ride"] = 140.79, ["Neon"] = 52.5, ["Neon|Ride"] = 155.57, ["Mega"] = 224.84, ["Mega|Ride"] = 140.78, ["Mega|Fly|Ride"] = 420.25}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 11.01, ["Fly|Ride"] = 27.98, ["Neon"] = 2.1, ["Neon|Fly"] = 31.18, ["Neon|Ride"] = 17.43, ["Neon|Fly|Ride"] = 26.25, ["Mega"] = 48.35, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 75.6}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4593.75, ["Ride"] = 3937.5, ["Fly|Ride"] = 4198.68, ["Neon"] = 25214.01, ["Neon|Fly|Ride"] = 19163.82, ["Mega|Fly|Ride"] = 78583.62}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 5.75, ["Ride"] = 56.35, ["Neon"] = 129.24, ["Neon|Ride"] = 85.32, ["Mega"] = 259.88, ["Mega|Ride"] = 232.2, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 31.54, ["Ride"] = 14.65, ["Fly|Ride"] = 47.07, ["Neon"] = 12.5, ["Neon|Fly"] = 42.05, ["Neon|Ride"] = 26.02, ["Neon|Fly|Ride"] = 84.07, ["Mega"] = 280.52, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 151.6}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 406.59, ["Fly"] = 490.64, ["Ride"] = 433.13, ["Fly|Ride"] = 472.38, ["Neon"] = 1680.95, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 5874.19}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 2.63, ["Neon"] = 10.91, ["Neon|Ride"] = 291.38, ["Neon|Fly|Ride"] = 280.52, ["Mega"] = 131.25, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.46, ["Fly"] = 51.49, ["Ride"] = 77.78, ["Neon"] = 28.88, ["Neon|Ride"] = 279.47, ["Neon|Fly|Ride"] = 14008.5, ["Mega"] = 280.52, ["Mega|Ride"] = 360.94, ["Mega|Fly|Ride"] = 2321.82}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 21.04, ["Neon"] = 3.72, ["Neon|Ride"] = 39.38, ["Mega"] = 36.07, ["Mega|Ride"] = 81.97}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 587.35, ["Ride"] = 576.94, ["Fly|Ride"] = 656.25, ["Neon"] = 3871.63, ["Neon|Fly|Ride"] = 2205, ["Mega|Fly|Ride"] = 8751.75}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.57, ["Ride"] = 65.63, ["Neon"] = 18.47, ["Neon|Ride"] = 98.77, ["Neon|Fly|Ride"] = 643.13, ["Mega"] = 108.94, ["Mega|Ride"] = 210.13, ["Mega|Fly|Ride"] = 455.98}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 7.6, ["Fly"] = 236.25, ["Ride"] = 52.48, ["Fly|Ride"] = 147.13, ["Neon"] = 26.25, ["Neon|Ride"] = 38.21, ["Neon|Fly|Ride"] = 127.21, ["Mega"] = 226.02, ["Mega|Ride"] = 235.98, ["Mega|Fly|Ride"] = 306.05}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 14.26, ["Fly|Ride"] = 33.66, ["Neon"] = 7.86, ["Neon|Fly"] = 140.79, ["Neon|Ride"] = 20.37, ["Neon|Fly|Ride"] = 85.3, ["Mega"] = 114.59, ["Mega|Fly"] = 224.84, ["Mega|Ride"] = 195.42, ["Mega|Fly|Ride"] = 209.08}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 13.42, ["Ride"] = 39.38, ["Fly|Ride"] = 116.11, ["Neon"] = 140.78, ["Neon|Ride"] = 266.86, ["Mega"] = 453.88, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 464.38}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 3.63, ["Neon|Ride"] = 28.39, ["Neon|Fly|Ride"] = 2031.6, ["Mega"] = 19.69, ["Mega|Ride"] = 95.81, ["Mega|Fly|Ride"] = 258.38}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 471.19, ["Ride"] = 492.18, ["Fly|Ride"] = 649.27, ["Neon"] = 1947.8, ["Neon|Ride"] = 2096.98, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Ride"] = 9055.05, ["Mega|Fly|Ride"] = 7607.29}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 40.64, ["Neon"] = 7.48, ["Neon|Ride"] = 91.42, ["Neon|Fly|Ride"] = 185.76, ["Mega"] = 35.44, ["Mega|Ride"] = 145.86, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 28.35, ["Neon"] = 6.04, ["Neon|Fly"] = 112.43, ["Neon|Ride"] = 41.64, ["Mega"] = 31.49, ["Mega|Ride"] = 84.07, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 3.94, ["Neon|Ride"] = 62.91, ["Mega"] = 32.45, ["Mega|Fly"] = 155.5, ["Mega|Ride"] = 105.08, ["Mega|Fly|Ride"] = 167.37}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 14.48}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 41.94, ["Ride"] = 45.94, ["Fly|Ride"] = 98.44, ["Neon"] = 131.25, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 416.05, ["Mega"] = 1082.82, ["Mega|Ride"] = 523.68, ["Mega|Fly|Ride"] = 628.68}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 17.4, ["Ride"] = 66.94, ["Fly|Ride"] = 236.25, ["Neon"] = 107.63, ["Neon|Ride"] = 111.43, ["Neon|Fly|Ride"] = 210.13, ["Mega"] = 476.99, ["Mega|Ride"] = 547.98, ["Mega|Fly|Ride"] = 488.24}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 3.94, ["Fly"] = 34.63, ["Ride"] = 12.08, ["Fly|Ride"] = 31.49, ["Neon"] = 27.4, ["Neon|Ride"] = 25.53, ["Neon|Fly|Ride"] = 55.13, ["Mega"] = 300.57, ["Mega|Ride"] = 222.69, ["Mega|Fly|Ride"] = 225.75}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 8.52, ["Ride"] = 32.82, ["Neon"] = 91.94, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 322.54, ["Mega|Fly|Ride"] = 487.49}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 32.59, ["Ride"] = 15.78, ["Fly|Ride"] = 362.25, ["Neon"] = 9.19, ["Neon|Ride"] = 83.87, ["Mega"] = 91.88, ["Mega|Ride"] = 125.04, ["Mega|Fly|Ride"] = 138.69}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 12.73, ["Fly"] = 65.63, ["Ride"] = 37.84, ["Fly|Ride"] = 62.12, ["Neon"] = 131.25, ["Neon|Ride"] = 57.25, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 944.49, ["Mega|Ride"] = 928.73, ["Mega|Fly|Ride"] = 608.42}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 22.13, ["Fly"] = 874.13, ["Neon"] = 150.94, ["Neon|Fly"] = 170.63, ["Mega"] = 420.25, ["Mega|Fly|Ride"] = 840.48}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 35.66, ["Fly"] = 115.5, ["Ride"] = 72.19, ["Fly|Ride"] = 144.38, ["Neon"] = 297.93, ["Neon|Ride"] = 182.62, ["Neon|Fly|Ride"] = 394.78, ["Mega|Ride"] = 1376.75, ["Mega|Fly|Ride"] = 983.4}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 53.6, ["Fly"] = 126.1, ["Ride"] = 98.77, ["Fly|Ride"] = 232.2, ["Neon"] = 178.76, ["Neon|Ride"] = 196.47, ["Neon|Fly|Ride"] = 364.88, ["Mega"] = 619.94, ["Mega|Ride"] = 615.26, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 12.18, ["Ride"] = 77.76, ["Fly|Ride"] = 116.11, ["Neon"] = 157.5, ["Neon|Ride"] = 124.24, ["Mega"] = 658.64, ["Mega|Ride"] = 628.69, ["Mega|Fly|Ride"] = 1258.61}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 4.98, ["Ride"] = 32.82, ["Fly|Ride"] = 83.94, ["Neon"] = 27.57, ["Neon|Fly"] = 420, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 185.76, ["Mega"] = 350.9, ["Mega|Ride"] = 345.19, ["Mega|Fly|Ride"] = 350.86}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 20.71, ["Ride"] = 15.75, ["Fly|Ride"] = 25.18, ["Neon"] = 3.94, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 13.75, ["Neon|Fly|Ride"] = 71.99, ["Mega"] = 45.85, ["Mega|Ride"] = 83.01, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1311.19}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 22.44, ["Ride"] = 64.99, ["Fly|Ride"] = 236.25, ["Neon"] = 105, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 314.1, ["Mega"] = 553.67, ["Mega|Ride"] = 518.44, ["Mega|Fly|Ride"] = 544.38}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 56.48, ["Neon"] = 3.14, ["Neon|Ride"] = 23.61, ["Neon|Fly|Ride"] = 293.77, ["Mega"] = 18.94, ["Mega|Ride"] = 81.97, ["Mega|Fly|Ride"] = 217.88}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 26.25, ["Ride"] = 65.63, ["Fly|Ride"] = 280.47, ["Neon"] = 105, ["Neon|Ride"] = 414.75, ["Mega"] = 700.75, ["Mega|Ride"] = 580.47, ["Mega|Fly|Ride"] = 692.49}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Ride"] = 35.74, ["Neon"] = 3.52, ["Mega"] = 18.9}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.73, ["Mega"] = 31.54, ["Mega|Ride"] = 126.09, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 103.69, ["Ride"] = 149.63, ["Fly|Ride"] = 183.75, ["Neon"] = 393.74, ["Neon|Ride"] = 561.03, ["Neon|Fly|Ride"] = 619.5, ["Mega|Ride"] = 6384.98, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 16.53, ["Neon"] = 7.86, ["Neon|Ride"] = 28.72, ["Neon|Fly|Ride"] = 84.07, ["Mega"] = 60.93, ["Mega|Ride"] = 98.77, ["Mega|Fly|Ride"] = 155.5}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 34.92, ["Fly|Ride"] = 86.63, ["Neon"] = 5.24, ["Neon|Ride"] = 28.35, ["Neon|Fly|Ride"] = 419.99, ["Mega"] = 31.17, ["Mega|Ride"] = 125.04}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 31.34, ["Neon"] = 3.03, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 31.69, ["Mega"] = 31.44, ["Mega|Ride"] = 74.74, ["Mega|Fly|Ride"] = 210.13}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 21, ["Neon"] = 3.46, ["Neon|Ride"] = 26.52, ["Mega"] = 63.06, ["Mega|Ride"] = 68.92}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 29.48, ["Ride"] = 91.88, ["Fly|Ride"] = 619.94, ["Neon"] = 350.44, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 695.63, ["Mega|Fly|Ride"] = 1260.57}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.62, ["Ride"] = 129.31, ["Neon"] = 16.83, ["Neon|Ride"] = 109.14, ["Neon|Fly|Ride"] = 210.13, ["Mega"] = 197.25, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 314.14}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 370.79, ["Ride"] = 348.8, ["Fly|Ride"] = 607.17, ["Neon"] = 1758.64, ["Neon|Ride"] = 2101.18, ["Neon|Fly|Ride"] = 1405.69, ["Mega|Ride"] = 3767.4, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 65.63}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 39.37}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 12.73}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 11.52}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 525.31}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 52.5}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 11.81}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 9.19}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 213.94}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 20.87}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 66.87}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 9.17}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 6.33}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 249.38}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 3.94}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 6.57}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 14.42}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 491.13}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 699.62}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 18.36}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1064.44}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 193.5}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 8.97}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 13.13}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.63}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 13.1}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 32.81}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 45.92}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 15.22}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 12.33}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 18.54}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 4.23}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 17.05}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.1}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 20.77}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 15.74}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 5.24}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1443.75}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 101.84}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 289.98}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 3.75}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.63}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 9.19}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 8.61}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 138.55}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 131.14}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 10.02}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 10.42}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 170.62}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 24.91}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 5.17}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 15.74}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 7.88}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 127.31}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 15.23}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 7.43}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.05}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 12.7}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.63}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 9.45}},
    ["rbxassetid://1265129203"] = {name = "Ice Snowboard", prices = {["default"] = 207.38}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 2.52}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 11.69}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.63}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 117.99}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 91.88}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 4.04}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 11.34}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 26.25}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 62.2}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 18.36}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.63}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22057.16}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 169.31}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 34.13}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 28.39}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 21}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 81.15}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 25.6}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 39.38}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 31.79}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 111.57}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 42.05}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 39.38}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 26.25}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 34.13}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 170.62}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 15.75}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 8.95}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.05}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 4.66}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 23.42}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 23.28}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 2.63}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.41}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 3.94}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 3.83}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 1401.49}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 10.53}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 524.37}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 41.71}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.63}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 5.24}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 262.5}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 28.87}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 66.76}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 30.91}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 24}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 59.89}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 23.61}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.94}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 6.97}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 6.98}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 3.93}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 19.29}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.82}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.36}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 10.49}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 17.99}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 152.99}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 33.17}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.61}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1049.54}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 8.39}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 12.63}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 8.43}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 9.19}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 86.03}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 11.75}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 3.93}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 16.83}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 8.39}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 11.82}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 88.57}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 19.67}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 8.03}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 3.1}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 6.98}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 7.72}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 18.47}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 3.1}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 3.93}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.23}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 3.93}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 2.98}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 3.92}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7138.72}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 13.8}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 5.25}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 3.94}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.33}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 13.77}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 3.94}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 3.93}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 7.33}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 75.34}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 4.47}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 6.28}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 7.87}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 3.45}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 2.59}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4410.53}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 3.93}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 38.84}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 2.1}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 59.1}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 3.92}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 6.57}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 131.24}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.05}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 3.92}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 2.48}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.63}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 3.94}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 3.71}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 26.25}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.29}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 2.56}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.23}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 9.32}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 5.35}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.6}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 2.61}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.63}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.61}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.24}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.59}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 131.25}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.56}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 28.35}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 3.34}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 6.23}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 99.74}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 19.11}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 859.31}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 12.55}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 3.3}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 3.94}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.05}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 4.66}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 8.92}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 3.29}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 4.39}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 6.28}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 13.11}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 12.22}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.6}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 5.28}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.3}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 15.78}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 4.19}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.63}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 17.42}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 31.36}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 12.94}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 11.54}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 393.75}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 42.95}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 2.1}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 11.81}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 10.49}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.02}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 3.94}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 72.19}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 4.7}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 15.73}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.93}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 3.92}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 5.34}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 6.06}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 69.29}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 13.02}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 3.93}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 103.47}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 4.19}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1109.07}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 185.76}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.21}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.63}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 7.88}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 45.94}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.16}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.33}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 32.58}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 2.86}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.63}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 5.25}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 63.06}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 2.26}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 73.56}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 2.67}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.05}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.5}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 8.58}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 78.68}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 3.42}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.6}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 52.66}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 15.75}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 7.88}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 59.76}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 16.69}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 42.11}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 315}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.13}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 17.83}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 98.95}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 5.25}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.63}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 8.92}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 72.07}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 28.39}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 7.23}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 10.75}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.49}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 13.97}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 2.18}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 17.04}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 38.62}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 3.92}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 23.61}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.81}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 4.9}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 37.84}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 33.1}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 26.08}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1509.19}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 5.77}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 5.25}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 23.23}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 249.04}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 20.87}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 6.57}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 7.64}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 5.24}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 3.29}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 238.45}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 71.99}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 65.63}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 7.23}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 3.84}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 63.4}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 106.32}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 52.5}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 853.13}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 78.73}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 7.22}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 945}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 556.5}},
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