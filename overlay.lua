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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 813.75, ["Fly"] = 1120.85, ["Ride"] = 1023.16, ["Fly|Ride"] = 721.03, ["Neon"] = 6499.73, ["Neon|Ride"] = 4482.31, ["Neon|Fly|Ride"] = 3422.41}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 350.87, ["Ride"] = 455.91, ["Fly|Ride"] = 523.59, ["Neon|Fly|Ride"] = 2361.19, ["Mega|Fly|Ride"] = 7982.5}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["Ride"] = 4528.13, ["Fly|Ride"] = 4986.19, ["Neon"] = 25911.58, ["Neon|Fly|Ride"] = 25534.62, ["Mega|Fly|Ride"] = 72726.47}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 132.99, ["Ride"] = 187.29, ["Fly|Ride"] = 525, ["Neon"] = 944.37, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 1191.23, ["Mega|Fly|Ride"] = 6190.25}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 477.75, ["Ride"] = 440.29, ["Fly|Ride"] = 466.77, ["Neon|Fly|Ride"] = 1573.67, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 9.08, ["Ride"] = 43.63, ["Fly|Ride"] = 103.69, ["Neon"] = 21.36, ["Neon|Ride"] = 77.75, ["Neon|Fly|Ride"] = 280.49, ["Mega"] = 266.8, ["Mega|Ride"] = 294.11, ["Mega|Fly|Ride"] = 409.5}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 2.61, ["Fly"] = 26.22, ["Ride"] = 23.13, ["Fly|Ride"] = 56.81, ["Neon"] = 23.63, ["Neon|Fly"] = 72.19, ["Neon|Ride"] = 37.36, ["Neon|Fly|Ride"] = 94.03, ["Mega"] = 210.08, ["Mega|Fly"] = 303.19, ["Mega|Ride"] = 143.82, ["Mega|Fly|Ride"] = 231.92}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 96.24, ["Fly"] = 656.25, ["Ride"] = 273.72, ["Neon"] = 506.45, ["Neon|Ride"] = 642.9, ["Neon|Fly|Ride"] = 1680.74, ["Mega|Ride"] = 1890.6, ["Mega|Fly|Ride"] = 1512.49}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 25.83, ["Fly"] = 62.36, ["Ride"] = 35.68, ["Fly|Ride"] = 53.82, ["Neon"] = 210.76, ["Neon|Ride"] = 163.79, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 2100, ["Mega|Ride"] = 2730, ["Mega|Fly|Ride"] = 735.25}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 19.95, ["Fly"] = 20.93, ["Ride"] = 30.17, ["Fly|Ride"] = 74.6, ["Neon"] = 233.21, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 168.09, ["Mega|Ride"] = 768.85, ["Mega|Fly|Ride"] = 601.21}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 32.96, ["Ride"] = 42.11, ["Fly|Ride"] = 104.01, ["Neon|Ride"] = 205.9, ["Neon|Fly|Ride"] = 204.75, ["Mega|Ride"] = 1037.73, ["Mega|Fly|Ride"] = 962.07}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 56.39}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 280.49, ["Ride"] = 262.23, ["Fly|Ride"] = 366.18, ["Neon"] = 1260.57, ["Neon|Ride"] = 985.69, ["Neon|Fly|Ride"] = 981.14, ["Mega|Fly|Ride"] = 4009.69}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 107.05, ["Fly"] = 132.33, ["Ride"] = 104.99, ["Fly|Ride"] = 144.37, ["Neon"] = 1401.32, ["Neon|Fly|Ride"] = 560.96, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.1, ["Ride"] = 78.75, ["Fly|Ride"] = 140.78, ["Neon"] = 15.1, ["Neon|Ride"] = 67.02, ["Neon|Fly|Ride"] = 79.85, ["Mega"] = 162.82, ["Mega|Ride"] = 168.07, ["Mega|Fly|Ride"] = 349.13}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 111.56, ["Fly"] = 124.69, ["Ride"] = 137.82, ["Fly|Ride"] = 147.89, ["Neon"] = 616.63, ["Neon|Ride"] = 630.29, ["Neon|Fly|Ride"] = 488.15, ["Mega"] = 2100.68, ["Mega|Fly|Ride"] = 1967.44}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.1, ["Fly"] = 22.44, ["Ride"] = 15.73, ["Fly|Ride"] = 41.25, ["Neon"] = 15.75, ["Neon|Fly"] = 105.06, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 787.5, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 30.19, ["Fly"] = 262.5, ["Ride"] = 37.16, ["Fly|Ride"] = 118.13, ["Neon"] = 147.08, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 208.16, ["Mega"] = 687.4, ["Mega|Ride"] = 681.19, ["Mega|Fly|Ride"] = 683.23}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 41.88}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 39.38, ["Ride"] = 99.72, ["Fly|Ride"] = 150.94, ["Neon"] = 279.57, ["Mega"] = 1522.5, ["Mega|Fly|Ride"] = 3095.13}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 9.19, ["Fly"] = 42.03, ["Ride"] = 23.89, ["Fly|Ride"] = 140.78, ["Neon"] = 84.04, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 132.32, ["Mega"] = 2669.21, ["Mega|Ride"] = 519.92, ["Mega|Fly|Ride"] = 649.91}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 19.69, ["Fly"] = 49.5, ["Ride"] = 42, ["Fly|Ride"] = 91.02, ["Neon"] = 352.96, ["Neon|Ride"] = 178.5, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 1681.32, ["Mega|Fly|Ride"] = 798.99}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 41.91, ["Ride"] = 155.76, ["Fly|Ride"] = 124.17, ["Neon"] = 209.99, ["Neon|Ride"] = 420.19, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1680.74, ["Mega|Ride"] = 1246.75, ["Mega|Fly|Ride"] = 1205.61}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 25.6, ["Ride"] = 44.55, ["Fly|Ride"] = 130.59, ["Neon"] = 171.08, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 309.9, ["Mega"] = 525, ["Mega|Ride"] = 898.16, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 37.36, ["Fly"] = 69.35, ["Ride"] = 50.8, ["Neon"] = 252.12, ["Neon|Ride"] = 278.58, ["Neon|Fly|Ride"] = 307.97, ["Mega|Ride"] = 3150.99, ["Mega|Fly|Ride"] = 936.91}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 3.92, ["Fly"] = 15.52, ["Ride"] = 21.02, ["Fly|Ride"] = 32.18, ["Neon"] = 25.38, ["Neon|Fly"] = 62.69, ["Neon|Ride"] = 39.94, ["Neon|Fly|Ride"] = 58.2, ["Mega"] = 118.13, ["Mega|Fly"] = 420.15, ["Mega|Ride"] = 164.64, ["Mega|Fly|Ride"] = 202.02}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 297.93, ["Fly"] = 367.67, ["Ride"] = 322.51, ["Fly|Ride"] = 358.32, ["Neon"] = 1428.63, ["Neon|Ride"] = 1436, ["Neon|Fly|Ride"] = 1416.19, ["Mega"] = 10503.28, ["Mega|Fly|Ride"] = 5416.18}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 9.18, ["Ride"] = 30.55, ["Fly|Ride"] = 136.58, ["Neon"] = 238.47, ["Neon|Ride"] = 210.1, ["Neon|Fly|Ride"] = 280.49, ["Mega"] = 826.63, ["Mega|Fly|Ride"] = 696.32}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 3.02, ["Fly"] = 32.8, ["Ride"] = 15.75, ["Fly|Ride"] = 37.94, ["Neon"] = 32.8, ["Neon|Fly"] = 89.25, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 348.72, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 391.36}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 83.03, ["Fly"] = 118.49, ["Ride"] = 102.38, ["Fly|Ride"] = 155.49, ["Neon"] = 262.5, ["Neon|Fly"] = 378.17, ["Neon|Ride"] = 276.94, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 6149.62, ["Mega|Ride"] = 3095.13, ["Mega|Fly|Ride"] = 2008.23}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 13.36, ["Ride"] = 22.97, ["Fly|Ride"] = 115.5, ["Neon"] = 150.9, ["Neon|Ride"] = 84.04, ["Neon|Fly|Ride"] = 207.38, ["Mega"] = 697.44}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 179.54, ["Ride"] = 201.07, ["Fly|Ride"] = 278.51, ["Neon"] = 700.67, ["Neon|Ride"] = 770.69, ["Neon|Fly|Ride"] = 798.36, ["Mega"] = 6301.98, ["Mega|Fly|Ride"] = 2381.97}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 24.86}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.13, ["Fly"] = 31.4, ["Ride"] = 21.02, ["Fly|Ride"] = 51.19, ["Neon"] = 16.9, ["Neon|Fly"] = 77.75, ["Neon|Ride"] = 42.03, ["Neon|Fly|Ride"] = 105.05, ["Mega"] = 157.5, ["Mega|Fly"] = 224.57, ["Mega|Ride"] = 190.32, ["Mega|Fly|Ride"] = 236.24}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 468.56, ["Fly"] = 598.78, ["Ride"] = 482.04, ["Fly|Ride"] = 525, ["Neon"] = 2801.58, ["Neon|Ride"] = 3011.67, ["Neon|Fly|Ride"] = 2730, ["Mega|Ride"] = 52223.52, ["Mega|Fly|Ride"] = 9663.03}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 8.08, ["Fly"] = 45.28, ["Ride"] = 26.25, ["Fly|Ride"] = 49.39, ["Neon"] = 27.33, ["Neon|Fly"] = 140.78, ["Neon|Ride"] = 70.39, ["Neon|Fly|Ride"] = 175.43, ["Mega"] = 526.32, ["Mega|Ride"] = 588.19, ["Mega|Fly|Ride"] = 658.56}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 126.07, ["Ride"] = 157.5, ["Fly|Ride"] = 196.24, ["Neon"] = 687.02, ["Neon|Ride"] = 544.69, ["Neon|Fly|Ride"] = 560.89, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 2784.11}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 38.66}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 19.69, ["Ride"] = 91.88, ["Fly|Ride"] = 262.5, ["Neon"] = 140.78, ["Neon|Ride"] = 245.82, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 670.8, ["Mega|Ride"] = 619.74, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 152.97, ["Ride"] = 208.69, ["Neon"] = 513.19, ["Neon|Ride"] = 742.68, ["Neon|Fly|Ride"] = 656.25, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 112.22, ["Ride"] = 131.24, ["Fly|Ride"] = 231.99, ["Neon"] = 435, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 560.95, ["Mega"] = 1749.86, ["Mega|Ride"] = 1354.94, ["Mega|Fly|Ride"] = 1468.69}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 55.12}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 44.13, ["Fly"] = 56.44, ["Ride"] = 42.03, ["Fly|Ride"] = 69.39, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 314.18, ["Mega|Fly|Ride"] = 1217.78}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 5.08, ["Ride"] = 49.39, ["Fly|Ride"] = 131.25, ["Neon"] = 16.14, ["Neon|Ride"] = 56.74, ["Neon|Fly|Ride"] = 155.55, ["Mega"] = 155.3, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 252.1, ["Mega|Fly|Ride"] = 287.81}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 303.19, ["Fly"] = 375.83, ["Ride"] = 297.94, ["Fly|Ride"] = 321.56, ["Neon|Ride"] = 1680.74, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 4717.04}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 51.14, ["Fly"] = 89.72, ["Ride"] = 56.74, ["Fly|Ride"] = 112.09, ["Neon"] = 262.39, ["Neon|Fly"] = 299.46, ["Neon|Ride"] = 210.1, ["Neon|Fly|Ride"] = 410.82, ["Mega|Fly|Ride"] = 1330.79}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3570.52, ["Fly"] = 3781.65, ["Ride"] = 3961.13, ["Fly|Ride"] = 3412.5, ["Neon|Fly|Ride"] = 13654.88}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 32.55, ["Fly"] = 224.81, ["Ride"] = 53.41, ["Fly|Ride"] = 88.6, ["Neon"] = 309.91, ["Neon|Ride"] = 250.72, ["Neon|Fly|Ride"] = 279.4, ["Mega"] = 1890.6, ["Mega|Ride"] = 1890.6, ["Mega|Fly|Ride"] = 1309.77}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 100.99, ["Ride"] = 174.39, ["Fly|Ride"] = 167.55, ["Neon"] = 371.42, ["Neon|Ride"] = 504.24, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 6301.98, ["Mega|Fly|Ride"] = 1525.1}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 30.19, ["Fly"] = 59.01, ["Ride"] = 36.75, ["Fly|Ride"] = 93.19, ["Neon"] = 138.68, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 155.52, ["Mega"] = 2598.75, ["Mega|Fly|Ride"] = 596.44}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 8.4}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 53.5, ["Ride"] = 77.75, ["Fly|Ride"] = 105, ["Neon"] = 441.2, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 490.52}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 39.34}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 196.49, ["Ride"] = 262.5, ["Fly|Ride"] = 341.25, ["Neon|Fly|Ride"] = 1680.54}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 551.24, ["Ride"] = 682.5, ["Fly|Ride"] = 656.25, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 1903.13, ["Mega|Fly|Ride"] = 11812.5}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 6.23}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 26.22, ["Fly"] = 39.38, ["Ride"] = 33.66, ["Fly|Ride"] = 55.06, ["Neon"] = 182.44, ["Neon|Fly"] = 309.91, ["Neon|Ride"] = 156.19, ["Neon|Fly|Ride"] = 201.75, ["Mega|Fly|Ride"] = 1531.52}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 11.69}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 4199.99, ["Fly|Ride"] = 4526.82, ["Neon|Fly|Ride"] = 10286.22, ["Mega|Fly|Ride"] = 40473.33}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 5.25, ["Fly"] = 26.25, ["Ride"] = 19.69, ["Fly|Ride"] = 39.48, ["Neon"] = 66.13, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 525.17, ["Mega|Ride"] = 367.4, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 15.73, ["Fly"] = 78.8, ["Ride"] = 39.9, ["Fly|Ride"] = 77.81, ["Neon"] = 39.38, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 700.59, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 467.41}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 262.5, ["Ride"] = 128.63, ["Fly|Ride"] = 187.69}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 9.19, ["Ride"] = 35.97, ["Fly|Ride"] = 139.65, ["Neon"] = 49.39, ["Neon|Ride"] = 177.07, ["Neon|Fly|Ride"] = 333.13, ["Mega"] = 1120.71, ["Mega|Ride"] = 838.38, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 2094.74, ["Fly"] = 2165.63, ["Ride"] = 2647.16, ["Fly|Ride"] = 2089.5, ["Neon|Ride"] = 5322.66, ["Neon|Fly|Ride"] = 3953.25, ["Mega|Fly|Ride"] = 10498.69}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 30463.2, ["Fly"] = 26250, ["Ride"] = 24806.25, ["Fly|Ride"] = 22968.75, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 69890.99, ["Mega"] = 210000}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 17.16, ["Fly"] = 393.75, ["Ride"] = 36.91, ["Fly|Ride"] = 91.41, ["Neon"] = 107.05, ["Neon|Ride"] = 178.38, ["Neon|Fly|Ride"] = 336.12, ["Mega"] = 1120.71, ["Mega|Ride"] = 735.25, ["Mega|Fly|Ride"] = 948.49}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.37, ["Ride"] = 26.93, ["Fly|Ride"] = 92.93, ["Neon"] = 15.75, ["Neon|Fly"] = 58.2, ["Neon|Ride"] = 42.05, ["Neon|Fly|Ride"] = 94.55, ["Mega"] = 157.5, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 245.44}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 26.25}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 5.25, ["Ride"] = 36.78, ["Fly|Ride"] = 98.75, ["Neon"] = 40.15, ["Neon|Ride"] = 124.36, ["Neon|Fly|Ride"] = 463.32, ["Mega"] = 170.62, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 277.36}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 682.5, ["Ride"] = 525, ["Fly|Ride"] = 761.25, ["Neon"] = 2949.19, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 11203.86, ["Mega|Fly|Ride"] = 10881.41}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 909.57, ["Ride"] = 721.88, ["Fly|Ride"] = 866.25, ["Neon|Fly|Ride"] = 3713.69, ["Mega|Fly|Ride"] = 13723.59}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 11.44, ["Fly"] = 56.74, ["Ride"] = 32.82, ["Fly|Ride"] = 78.75, ["Neon"] = 140.43, ["Neon|Ride"] = 183.84, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 642.31}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 31.5}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 49.83, ["Fly"] = 115.5, ["Ride"] = 70.4, ["Fly|Ride"] = 155.81, ["Neon"] = 420.19, ["Neon|Ride"] = 398.13, ["Neon|Fly|Ride"] = 367.15, ["Mega|Ride"] = 1680.54, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 69.75, ["Fly"] = 91.88, ["Ride"] = 89.25, ["Fly|Ride"] = 178.76, ["Neon"] = 450.19, ["Neon|Ride"] = 560.96, ["Neon|Fly|Ride"] = 15476.31, ["Mega"] = 2116.66, ["Mega|Ride"] = 1680.54, ["Mega|Fly|Ride"] = 1256.2}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 2.61, ["Fly"] = 23.12, ["Ride"] = 13.18, ["Fly|Ride"] = 33.43, ["Neon"] = 23.63, ["Neon|Ride"] = 63.04, ["Neon|Fly|Ride"] = 105, ["Mega"] = 560.89, ["Mega|Fly|Ride"] = 397.69}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 57.23, ["Fly"] = 93.16, ["Ride"] = 64.31, ["Fly|Ride"] = 98.58, ["Neon"] = 464.28, ["Neon|Ride"] = 325.5, ["Neon|Fly|Ride"] = 261.19, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.92, ["Fly"] = 35.44, ["Ride"] = 32.66, ["Neon"] = 21, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 560.96, ["Mega"] = 159.67, ["Mega|Fly"] = 1120.71, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 833.26}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 12.52, ["Fly"] = 59.89, ["Ride"] = 26.21, ["Fly|Ride"] = 105.05, ["Neon"] = 147, ["Neon|Ride"] = 75.43, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 621.81}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 32.58, ["Ride"] = 51.09, ["Fly|Ride"] = 126.07, ["Neon"] = 210.1, ["Neon|Ride"] = 343.56, ["Neon|Fly|Ride"] = 275.23, ["Mega"] = 420.15, ["Mega|Fly|Ride"] = 977.87}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 12.32, ["Fly"] = 90.36, ["Ride"] = 40.63, ["Fly|Ride"] = 72.19, ["Neon"] = 103.69, ["Neon|Ride"] = 106.8, ["Neon|Fly|Ride"] = 105.06, ["Mega|Ride"] = 840.28, ["Mega|Fly|Ride"] = 607.1}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6562.5, ["Ride"] = 4593.75, ["Fly|Ride"] = 3937.5, ["Neon"] = 28714.21, ["Neon|Fly|Ride"] = 25534.62}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 183.75, ["Fly"] = 216.56, ["Ride"] = 204.75, ["Fly|Ride"] = 248.79, ["Neon|Fly|Ride"] = 511.88, ["Mega|Fly|Ride"] = 2060.46}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 18.85, ["Fly"] = 88.38, ["Ride"] = 39.93, ["Fly|Ride"] = 78.75, ["Neon"] = 64.44, ["Neon|Fly"] = 104.62, ["Neon|Ride"] = 81.03, ["Neon|Fly|Ride"] = 195.4, ["Mega"] = 288.75, ["Mega|Fly"] = 420.15, ["Mega|Ride"] = 247.9, ["Mega|Fly|Ride"] = 269.07}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 40.64, ["Ride"] = 19.88, ["Fly|Ride"] = 99.81, ["Neon"] = 19.69, ["Neon|Ride"] = 105.05, ["Mega"] = 140.44}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 30.19, ["Fly"] = 150.9, ["Ride"] = 44.09, ["Fly|Ride"] = 146.19, ["Neon"] = 120.75, ["Neon|Fly"] = 333.13, ["Neon|Ride"] = 138.68, ["Neon|Fly|Ride"] = 199.59, ["Mega"] = 328.11, ["Mega|Ride"] = 281.72, ["Mega|Fly|Ride"] = 496.13}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 18571.88, ["Ride"] = 11082.75, ["Fly|Ride"] = 10661.44, ["Neon|Fly|Ride"] = 23625, ["Mega|Fly|Ride"] = 91028.7}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 131.25, ["Ride"] = 150.94, ["Fly|Ride"] = 210.1, ["Neon"] = 2100.93, ["Neon|Fly|Ride"] = 840, ["Mega"] = 4411.39, ["Mega|Fly|Ride"] = 4552.13}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 46.82, ["Fly"] = 459.38, ["Ride"] = 36.75, ["Fly|Ride"] = 63.67, ["Neon|Fly"] = 464.28, ["Neon|Ride"] = 266.44, ["Neon|Fly|Ride"] = 341.25}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 10.5, ["Ride"] = 25.23, ["Fly|Ride"] = 91.41, ["Neon"] = 72.19, ["Neon|Ride"] = 84.09, ["Neon|Fly|Ride"] = 112.22, ["Mega"] = 2520.8, ["Mega|Ride"] = 492.19, ["Mega|Fly|Ride"] = 532.53}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 339.92, ["Fly"] = 840.48, ["Ride"] = 312.25, ["Fly|Ride"] = 457.67, ["Neon"] = 1457, ["Neon|Ride"] = 1260, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 5250.6, ["Mega|Fly|Ride"] = 4616.19}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 7.61, ["Fly"] = 101.53, ["Ride"] = 32.1, ["Fly|Ride"] = 165.99, ["Neon"] = 35.99, ["Neon|Ride"] = 99.1, ["Neon|Fly|Ride"] = 126.77, ["Mega"] = 120.99, ["Mega|Fly"] = 278.37, ["Mega|Ride"] = 175.92, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 110.25, ["Ride"] = 126.76, ["Fly|Ride"] = 171.78, ["Neon"] = 262.63, ["Neon|Ride"] = 327.8, ["Neon|Fly|Ride"] = 426.56, ["Mega"] = 1574.99, ["Mega|Fly|Ride"] = 1663.23}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 9.19, ["Fly"] = 17.07, ["Ride"] = 13.37, ["Fly|Ride"] = 27.57, ["Neon"] = 31.53, ["Neon|Ride"] = 102.15, ["Neon|Fly|Ride"] = 73.56, ["Mega"] = 2520.8, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 7.64}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 54.6, ["Fly"] = 77.79, ["Ride"] = 98.76, ["Fly|Ride"] = 525, ["Neon"] = 280.48, ["Neon|Fly"] = 1680.74, ["Neon|Ride"] = 364.52, ["Neon|Fly|Ride"] = 689.11, ["Mega|Ride"] = 1392.64, ["Mega|Fly|Ride"] = 1531.9}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 12.23, ["Ride"] = 30.19, ["Fly|Ride"] = 90.57, ["Neon"] = 85.89, ["Neon|Ride"] = 116.08, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 393.75, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 835.8}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 57.1}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 22.07, ["Fly"] = 210, ["Ride"] = 76.13, ["Fly|Ride"] = 73.55, ["Neon"] = 133.88, ["Neon|Ride"] = 107.17, ["Neon|Fly|Ride"] = 210.1, ["Mega"] = 1540.84, ["Mega|Ride"] = 962.11, ["Mega|Fly|Ride"] = 597.19}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 2.63, ["Ride"] = 24.18, ["Neon"] = 17.89, ["Neon|Ride"] = 137.63, ["Neon|Fly|Ride"] = 321.57, ["Mega"] = 131.72, ["Mega|Ride"] = 157.57, ["Mega|Fly|Ride"] = 399.67}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 18.38, ["Ride"] = 28.59, ["Fly|Ride"] = 89.14, ["Neon"] = 212.1, ["Neon|Ride"] = 154.88, ["Neon|Fly|Ride"] = 619.81, ["Mega|Ride"] = 557.8, ["Mega|Fly|Ride"] = 676.43}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 343.79, ["Fly"] = 437.75, ["Ride"] = 322.88, ["Fly|Ride"] = 385.88, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 9103.2, ["Mega|Fly|Ride"] = 8822.77}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 19.63, ["Ride"] = 46.41, ["Fly|Ride"] = 124.2, ["Neon"] = 244.64, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 393.75, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 695.34}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 55, ["Ride"] = 82.69, ["Fly|Ride"] = 105.06, ["Neon"] = 105, ["Neon|Fly"] = 280.49, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 185.72, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1260.41}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 13.11, ["Ride"] = 42, ["Fly|Ride"] = 89.75, ["Neon"] = 57.25, ["Neon|Ride"] = 86.78, ["Neon|Fly|Ride"] = 279.16, ["Mega"] = 455.44, ["Mega|Ride"] = 336, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 11142.38, ["Ride"] = 11089.32, ["Fly|Ride"] = 7014, ["Neon|Fly|Ride"] = 15483.57, ["Mega|Fly|Ride"] = 36411.71}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1771.88, ["Fly"] = 2297.36, ["Ride"] = 2137.59, ["Fly|Ride"] = 1837.5, ["Neon|Fly|Ride"] = 4515, ["Mega|Fly|Ride"] = 17913.34}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 328.13, ["Ride"] = 410.89, ["Fly|Ride"] = 590.63, ["Neon"] = 1400.26, ["Neon|Ride"] = 1344.59, ["Neon|Fly|Ride"] = 1344.44, ["Mega"] = 14437.5, ["Mega|Fly|Ride"] = 6162.28}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 14.67, ["Fly"] = 22.32, ["Ride"] = 15.74, ["Fly|Ride"] = 35.41, ["Neon"] = 124.2, ["Neon|Ride"] = 107.17, ["Neon|Fly|Ride"] = 120.81, ["Mega|Fly|Ride"] = 619.74}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 4.66, ["Fly"] = 131.25, ["Ride"] = 105, ["Fly|Ride"] = 105, ["Neon"] = 16.9, ["Neon|Ride"] = 26.25, ["Mega"] = 153.56, ["Mega|Ride"] = 238.44, ["Mega|Fly|Ride"] = 268.84}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 29.91, ["Fly"] = 39.35, ["Ride"] = 38.07, ["Fly|Ride"] = 79.68, ["Neon"] = 182.43, ["Neon|Ride"] = 157.49, ["Neon|Fly|Ride"] = 94.57, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 2.61, ["Fly"] = 16.12, ["Ride"] = 14, ["Fly|Ride"] = 28.84, ["Neon"] = 21.02, ["Neon|Fly"] = 58.06, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 93.97, ["Mega"] = 472.5, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 250.25}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 254.62, ["Fly"] = 317.61, ["Ride"] = 254.62, ["Fly|Ride"] = 364.52, ["Neon"] = 1091.04, ["Neon|Ride"] = 1049.43, ["Neon|Fly|Ride"] = 950.25, ["Mega|Fly|Ride"] = 4515.37}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 19.66, ["Fly"] = 56.74, ["Ride"] = 26.25, ["Fly|Ride"] = 56.44, ["Neon"] = 121.87, ["Neon|Fly"] = 464.28, ["Neon|Ride"] = 140.78, ["Neon|Fly|Ride"] = 170.63, ["Mega|Ride"] = 779.36, ["Mega|Fly|Ride"] = 774.38}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 8.01, ["Fly"] = 28.38, ["Ride"] = 18.25, ["Fly|Ride"] = 46.07, ["Neon|Fly"] = 124.2, ["Neon|Ride"] = 109.12, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 420.15, ["Mega|Ride"] = 578.74, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 511.6, ["Fly"] = 656.25, ["Ride"] = 484.32, ["Fly|Ride"] = 672.31, ["Mega|Fly|Ride"] = 8893.14}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1258.69, ["Ride"] = 1209.94, ["Fly|Ride"] = 1305.94, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 19342.44}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 95.61, ["Fly"] = 136.5, ["Ride"] = 74.6, ["Fly|Ride"] = 98.44, ["Neon"] = 560.96, ["Neon|Ride"] = 414.75, ["Neon|Fly|Ride"] = 418.69, ["Mega|Fly|Ride"] = 1312.49}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 170.62, ["Fly"] = 232.09, ["Ride"] = 162.75, ["Fly|Ride"] = 149.63, ["Neon"] = 1084.08, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 645.88, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 17.99, ["Ride"] = 63.04, ["Fly|Ride"] = 232.15, ["Neon"] = 263.48, ["Neon|Ride"] = 252.12, ["Neon|Fly|Ride"] = 840.28, ["Mega|Ride"] = 928.44, ["Mega|Fly|Ride"] = 1032.88}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 105.52, ["Ride"] = 141.1, ["Fly|Ride"] = 597.19, ["Neon"] = 1541.04, ["Neon|Ride"] = 1260.57, ["Neon|Fly|Ride"] = 1680.74, ["Mega|Fly|Ride"] = 4201.33}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1534.32, ["Fly"] = 2100.93, ["Ride"] = 1392.76, ["Fly|Ride"] = 1967.44, ["Neon|Fly|Ride"] = 6562.49, ["Mega|Fly|Ride"] = 31876.07}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 62.4, ["Ride"] = 91.88, ["Fly|Ride"] = 262.26, ["Neon"] = 278.07, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 1962.02, ["Mega|Ride"] = 2310.73, ["Mega|Fly|Ride"] = 2167.87}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 535.5, ["Fly"] = 635.91, ["Ride"] = 564.38, ["Fly|Ride"] = 594.85, ["Neon|Ride"] = 1395.02, ["Neon|Fly|Ride"] = 1111.68, ["Mega|Fly|Ride"] = 2782.5}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 36, ["Fly"] = 50.87, ["Ride"] = 46.02, ["Fly|Ride"] = 86.99, ["Neon"] = 203.8, ["Neon|Ride"] = 513.45, ["Neon|Fly|Ride"] = 232.08, ["Mega|Fly|Ride"] = 1450.32}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 2.1, ["Fly"] = 23.42, ["Ride"] = 18.34, ["Fly|Ride"] = 37.41, ["Neon"] = 18.92, ["Neon|Fly"] = 39.32, ["Neon|Ride"] = 28.38, ["Neon|Fly|Ride"] = 66.94, ["Mega"] = 155.52, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 43.63, ["Ride"] = 66.94, ["Fly|Ride"] = 252, ["Neon"] = 700.67, ["Neon|Ride"] = 771.05, ["Mega"] = 1392.64, ["Mega|Fly|Ride"] = 955.47}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 467.86, ["Fly"] = 928.54, ["Ride"] = 498.65, ["Fly|Ride"] = 525, ["Neon|Ride"] = 1996.36, ["Neon|Fly|Ride"] = 1548.75, ["Mega|Fly|Ride"] = 5118.75}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 523.69, ["Ride"] = 576.19, ["Fly|Ride"] = 734.28, ["Neon"] = 8403.66, ["Neon|Fly|Ride"] = 3082.05, ["Mega|Fly|Ride"] = 12603.94}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 11.82, ["Fly"] = 32.71, ["Ride"] = 18.92, ["Fly|Ride"] = 39.94, ["Neon"] = 126.78, ["Neon|Ride"] = 87.07, ["Neon|Fly|Ride"] = 91.88, ["Mega|Fly|Ride"] = 618.98}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 7.54, ["Ride"] = 18.38, ["Fly|Ride"] = 75.65, ["Neon"] = 52.61, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 420.15, ["Mega"] = 460.05, ["Mega|Ride"] = 460.05, ["Mega|Fly|Ride"] = 473.71}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.39, ["Ride"] = 22.32, ["Fly|Ride"] = 111.56, ["Neon"] = 15.77, ["Neon|Fly"] = 112.33, ["Neon|Ride"] = 31.35, ["Neon|Fly|Ride"] = 133.66, ["Mega"] = 119.01, ["Mega|Fly"] = 224.44, ["Mega|Ride"] = 157.4, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 24.28, ["Fly"] = 31.17, ["Ride"] = 32.82, ["Fly|Ride"] = 86.63, ["Neon"] = 250.72, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 187.03, ["Mega|Fly|Ride"] = 707.74}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 30.43, ["Ride"] = 72.19, ["Fly|Ride"] = 619.81, ["Neon"] = 350.44, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 695.63, ["Mega|Fly|Ride"] = 1248.12}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 12.37, ["Fly"] = 47.36, ["Ride"] = 30.56, ["Fly|Ride"] = 91.02, ["Neon"] = 59.69, ["Neon|Fly"] = 119.77, ["Neon|Ride"] = 85.76, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 656.25, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 371.44}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 31.48, ["Fly"] = 77.75, ["Ride"] = 36.72, ["Fly|Ride"] = 90.26, ["Neon"] = 248.39, ["Neon|Ride"] = 252.74, ["Neon|Fly|Ride"] = 210, ["Mega"] = 2100, ["Mega|Ride"] = 1205.7, ["Mega|Fly|Ride"] = 1104.96}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.6, ["Fly"] = 38.07, ["Ride"] = 13.94, ["Fly|Ride"] = 42, ["Neon"] = 34.29, ["Neon|Ride"] = 35.4, ["Neon|Fly|Ride"] = 104.9, ["Mega"] = 1680.54, ["Mega|Ride"] = 464.22, ["Mega|Fly|Ride"] = 309.88}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 7.62, ["Fly"] = 54.99, ["Ride"] = 27.48, ["Fly|Ride"] = 35.35, ["Neon"] = 20.94, ["Neon|Fly"] = 155.55, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 416.07, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 26.24, ["Fly"] = 53.81, ["Ride"] = 48.62, ["Fly|Ride"] = 78.75, ["Neon"] = 417.64, ["Neon|Ride"] = 224.62, ["Neon|Fly|Ride"] = 240.19, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1756.9, ["Fly"] = 2447.82, ["Ride"] = 1509.38, ["Fly|Ride"] = 1946.44, ["Neon"] = 6655.25, ["Neon|Ride"] = 5252.28, ["Neon|Fly|Ride"] = 4515, ["Mega|Fly|Ride"] = 14003.07}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 418.69, ["Fly"] = 578.26, ["Ride"] = 471.19, ["Fly|Ride"] = 525, ["Neon"] = 3095.51, ["Neon|Ride"] = 2381.39, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 7699.96}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 250.69, ["Ride"] = 280.88, ["Fly|Ride"] = 393.75, ["Neon"] = 1365.6, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1155.37, ["Mega|Fly|Ride"] = 5574.1}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 38.06}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 22.31, ["Fly"] = 65.63, ["Ride"] = 39.38, ["Fly|Ride"] = 78.75, ["Neon"] = 288.75, ["Neon|Ride"] = 227.01, ["Neon|Fly|Ride"] = 418.98, ["Mega"] = 1154.32, ["Mega|Ride"] = 1470.48, ["Mega|Fly|Ride"] = 783.56}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 29412.75, ["Fly"] = 20998.69, ["Ride"] = 34781.25, ["Fly|Ride"] = 14697.38, ["Neon|Fly|Ride"] = 36748.69, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 178.14, ["Fly"] = 217.88, ["Ride"] = 202.13, ["Fly|Ride"] = 265.55, ["Neon"] = 525, ["Neon|Fly"] = 798.36, ["Neon|Ride"] = 524.99, ["Neon|Fly|Ride"] = 693.84, ["Mega"] = 3488.15, ["Mega|Ride"] = 4789.51, ["Mega|Fly|Ride"] = 2207.9}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 262.5, ["Ride"] = 249.38, ["Fly|Ride"] = 262.5, ["Neon|Fly|Ride"] = 1702.5}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 94.39, ["Ride"] = 98.51, ["Fly|Ride"] = 141.63, ["Neon"] = 561.78, ["Neon|Ride"] = 356.77, ["Neon|Fly|Ride"] = 368.92, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 2140.58}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 12.5, ["Fly"] = 28.38, ["Ride"] = 29.27, ["Fly|Ride"] = 77.67, ["Neon"] = 98.76, ["Neon|Ride"] = 138.08, ["Neon|Fly|Ride"] = 291.38, ["Mega"] = 619.74, ["Mega|Ride"] = 539.01}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3937.39, ["Ride"] = 4188.19, ["Fly|Ride"] = 4062.19, ["Neon|Ride"] = 21709.77, ["Neon|Fly|Ride"] = 13125}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 22.3, ["Fly"] = 31.16, ["Ride"] = 30.18, ["Fly|Ride"] = 45.98, ["Neon"] = 105, ["Neon|Ride"] = 139.13, ["Neon|Fly|Ride"] = 150.93, ["Mega|Fly|Ride"] = 570.94}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 39.12, ["Fly"] = 62.69, ["Ride"] = 45.85, ["Fly|Ride"] = 80.58, ["Neon|Ride"] = 277.34, ["Neon|Fly|Ride"] = 290.15, ["Mega|Fly|Ride"] = 1702.5}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 490.88, ["Fly"] = 919.26, ["Ride"] = 523.69, ["Fly|Ride"] = 639.19, ["Neon"] = 1624.94, ["Neon|Ride"] = 1509.13, ["Neon|Fly|Ride"] = 1253.44, ["Mega"] = 3675, ["Mega|Ride"] = 6300.93, ["Mega|Fly|Ride"] = 3858.65}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 11.34, ["Fly"] = 23.12, ["Ride"] = 16.9, ["Fly|Ride"] = 38.06, ["Neon"] = 140.78, ["Neon|Fly"] = 126.07, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 110.03, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 12.78, ["Ride"] = 42.03, ["Fly|Ride"] = 136.58, ["Neon"] = 54.34, ["Neon|Ride"] = 111.57, ["Mega"] = 418.04}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 107.89, ["Ride"] = 118.39, ["Fly|Ride"] = 165.38, ["Neon"] = 498.75, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 735, ["Mega|Fly|Ride"] = 2981.9}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 19.11, ["Fly"] = 24.47, ["Ride"] = 74.02, ["Fly|Ride"] = 128.41, ["Neon"] = 65.24, ["Neon|Ride"] = 114.75, ["Neon|Fly|Ride"] = 157.4, ["Mega"] = 186.66, ["Mega|Fly"] = 523.69, ["Mega|Ride"] = 227.98, ["Mega|Fly|Ride"] = 349.13}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 2687.94, ["Ride"] = 2887.5, ["Fly|Ride"] = 2940, ["Neon"] = 9453.06, ["Neon|Ride"] = 17024.62, ["Neon|Fly|Ride"] = 7218.74, ["Mega"] = 63019.63, ["Mega|Fly|Ride"] = 37600.94}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 22.95, ["Fly"] = 210, ["Ride"] = 44.23, ["Fly|Ride"] = 98.76, ["Neon"] = 155.37, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 294.82, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 6103.13, ["Fly"] = 7875, ["Ride"] = 7804.13, ["Fly|Ride"] = 6234.38, ["Neon|Ride"] = 18076.19, ["Neon|Fly|Ride"] = 13122.38, ["Mega|Fly|Ride"] = 61618.49}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.61, ["Fly"] = 19.58, ["Ride"] = 13.13, ["Fly|Ride"] = 23.88, ["Neon"] = 22.32, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 40.98, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 449.14, ["Mega|Ride"] = 210.08, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 17.57, ["Fly"] = 35.41, ["Ride"] = 27.55, ["Fly|Ride"] = 54.23, ["Neon|Ride"] = 280.88, ["Neon|Fly|Ride"] = 513.19, ["Mega|Ride"] = 1335.49, ["Mega|Fly|Ride"] = 928.44}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 9.55, ["Fly"] = 70.4, ["Ride"] = 24.94, ["Fly|Ride"] = 91.88, ["Neon"] = 62.99, ["Neon|Ride"] = 153.57, ["Neon|Fly|Ride"] = 230.95, ["Mega|Ride"] = 770.95, ["Mega|Fly|Ride"] = 748.13}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 26.21, ["Fly"] = 111.37, ["Ride"] = 56.68, ["Fly|Ride"] = 155.55, ["Neon"] = 161.44, ["Neon|Ride"] = 161.79, ["Neon|Fly|Ride"] = 222.7, ["Mega"] = 735, ["Mega|Ride"] = 1680.54, ["Mega|Fly|Ride"] = 840.28}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 13.13, ["Fly"] = 20.88, ["Ride"] = 15.74, ["Fly|Ride"] = 38.06, ["Neon"] = 54.64, ["Neon|Ride"] = 96.66, ["Neon|Fly|Ride"] = 126.06, ["Mega"] = 2520.8, ["Mega|Fly|Ride"] = 619.74}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8888.24}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2688.74}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 17.83}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 176.78, ["Fly"] = 420.19, ["Ride"] = 229.69, ["Fly|Ride"] = 350.87, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1793.14, ["Mega|Fly|Ride"] = 5602.46}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 18.53, ["Fly"] = 130.28, ["Ride"] = 44.14, ["Fly|Ride"] = 98.44, ["Neon"] = 105.56, ["Neon|Ride"] = 150.9, ["Mega"] = 541.98, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 472.66}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 10.44}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 15.77, ["Neon"] = 70.88, ["Neon|Ride"] = 182.79, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 840.28}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2546.24}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 118.13, ["Ride"] = 190.36, ["Fly|Ride"] = 10498.95, ["Neon"] = 712.66, ["Neon|Ride"] = 840.38, ["Mega|Fly|Ride"] = 1821.28}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 108.94, ["Ride"] = 99.3, ["Fly|Ride"] = 418.73, ["Neon"] = 773.85, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 656.25, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 1392.64}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 140.43, ["Fly"] = 260.53, ["Ride"] = 147, ["Fly|Ride"] = 196.88, ["Neon"] = 817.27, ["Neon|Ride"] = 840.38, ["Neon|Fly|Ride"] = 836.63, ["Mega|Fly|Ride"] = 2936.07}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 936.44, ["Fly"] = 2521.12, ["Ride"] = 1050, ["Fly|Ride"] = 1097.97, ["Neon|Fly|Ride"] = 4592.44, ["Mega|Fly|Ride"] = 21006.55}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 15.11, ["Fly"] = 81.95, ["Ride"] = 40.98, ["Fly|Ride"] = 49.39, ["Neon"] = 105, ["Neon|Ride"] = 155.55, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 928.44, ["Mega|Ride"] = 774.09, ["Mega|Fly|Ride"] = 789.86}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 582.75, ["Fly"] = 2100, ["Ride"] = 551.25, ["Fly|Ride"] = 745.5, ["Neon|Fly|Ride"] = 4023.54}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 48.43}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 13, ["Fly"] = 144.38, ["Ride"] = 28.38, ["Fly|Ride"] = 98.44, ["Neon"] = 52.5, ["Neon|Ride"] = 155.55, ["Neon|Fly|Ride"] = 309.9, ["Mega"] = 393.37, ["Mega|Ride"] = 418.69, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 7.22, ["Fly"] = 348.22, ["Ride"] = 23.67, ["Fly|Ride"] = 72.19, ["Neon"] = 56.44, ["Neon|Ride"] = 84.05, ["Neon|Fly|Ride"] = 202.18, ["Mega|Ride"] = 387.63, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 59.89}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 13.13, ["Ride"] = 28.38, ["Fly|Ride"] = 65.54, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 541.98, ["Mega|Fly|Ride"] = 1238.29}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 26.13, ["Fly"] = 39.38, ["Ride"] = 26.25, ["Fly|Ride"] = 76.39, ["Neon"] = 139.3, ["Neon|Fly"] = 241.44, ["Neon|Ride"] = 278.25, ["Neon|Fly|Ride"] = 274.32, ["Mega"] = 1399.06, ["Mega|Ride"] = 960.02, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 5248.95, ["Fly"] = 11205.23, ["Ride"] = 6087.38, ["Fly|Ride"] = 4987.5, ["Neon|Fly|Ride"] = 9711.19, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 10.98, ["Fly"] = 40.63, ["Ride"] = 22.32, ["Fly|Ride"] = 111.26, ["Neon"] = 65.58, ["Neon|Fly"] = 136.98, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 155.55, ["Mega"] = 278.55, ["Mega|Ride"] = 378.14, ["Mega|Fly|Ride"] = 454.65}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 19.69}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 102.96, ["Fly"] = 371.87, ["Ride"] = 125.74, ["Fly|Ride"] = 167.89, ["Neon"] = 350.84, ["Neon|Ride"] = 347.71, ["Neon|Fly|Ride"] = 476.86, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 55.13, ["Fly"] = 138.68, ["Ride"] = 73.48, ["Fly|Ride"] = 89.14, ["Neon"] = 209.83, ["Neon|Ride"] = 378, ["Neon|Fly|Ride"] = 430.5, ["Mega|Ride"] = 1346.23, ["Mega|Fly|Ride"] = 1050.34}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 19.69, ["Fly"] = 70.8, ["Ride"] = 31.49, ["Fly|Ride"] = 63.1, ["Neon"] = 140.78, ["Neon|Ride"] = 115.33, ["Neon|Fly|Ride"] = 146.01, ["Mega|Fly|Ride"] = 418.67}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 3.93, ["Fly"] = 43.53, ["Ride"] = 18.51, ["Fly|Ride"] = 50.24, ["Neon"] = 15.75, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 126.19, ["Mega"] = 118.12, ["Mega|Ride"] = 127.31, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 8.87, ["Ride"] = 27.57, ["Fly|Ride"] = 52.45, ["Neon"] = 51.14, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 149.63, ["Mega"] = 364.48, ["Mega|Ride"] = 419.99, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 15.16, ["Fly"] = 20.37, ["Ride"] = 21, ["Fly|Ride"] = 42.03, ["Neon"] = 208.69, ["Neon|Fly"] = 210.1, ["Neon|Ride"] = 138.68, ["Neon|Fly|Ride"] = 124.2, ["Mega|Fly"] = 700.59, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 181.13}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 18.12, ["Fly"] = 124.2, ["Ride"] = 98.44, ["Neon"] = 92.74, ["Neon|Ride"] = 140.78, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 1355.99, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 129.84, ["Ride"] = 377.12, ["Fly|Ride"] = 309.91}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 32.82, ["Ride"] = 92.76, ["Fly|Ride"] = 210, ["Neon"] = 179.82, ["Neon|Ride"] = 324.98, ["Neon|Fly|Ride"] = 733.56, ["Mega"] = 1076.25, ["Mega|Ride"] = 1209.99, ["Mega|Fly|Ride"] = 958.13}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 623.44, ["Fly"] = 773.01, ["Ride"] = 686.58, ["Fly|Ride"] = 616.88, ["Neon"] = 2241.68, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 1837.5, ["Mega|Fly|Ride"] = 7582.86}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 238.47, ["Ride"] = 291.38, ["Fly|Ride"] = 288.75, ["Neon"] = 1154.47, ["Neon|Fly"] = 3405.4, ["Neon|Ride"] = 1065.18, ["Neon|Fly|Ride"] = 1116.65, ["Mega"] = 8262.93, ["Mega|Ride"] = 4061.85, ["Mega|Fly|Ride"] = 4334.56}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 69.77}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 8.08, ["Fly"] = 23.09, ["Ride"] = 21.78, ["Fly|Ride"] = 46.44, ["Neon"] = 80.07, ["Neon|Fly"] = 230.99, ["Neon|Ride"] = 63.04, ["Neon|Fly|Ride"] = 124.69, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 379.32}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 313.69, ["Fly"] = 600.08, ["Ride"] = 327.8, ["Fly|Ride"] = 426.57, ["Neon"] = 1259.52, ["Neon|Ride"] = 916.13, ["Neon|Fly|Ride"] = 905.63, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 24.18}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 97.89, ["Fly"] = 178.12, ["Ride"] = 162.93, ["Fly|Ride"] = 182.44, ["Neon"] = 459.38, ["Neon|Fly"] = 1401.32, ["Neon|Ride"] = 486.94, ["Neon|Fly|Ride"] = 519.75, ["Mega"] = 2490.34, ["Mega|Fly|Ride"] = 1770.09}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 140.78, ["Ride"] = 137.82, ["Fly|Ride"] = 105, ["Neon|Ride"] = 997.5, ["Neon|Fly|Ride"] = 700.07}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 5.25, ["Ride"] = 28.38, ["Fly|Ride"] = 62.83, ["Neon"] = 27.87, ["Neon|Ride"] = 42.03, ["Neon|Fly|Ride"] = 168.09, ["Mega"] = 240.19, ["Mega|Ride"] = 280.56, ["Mega|Fly|Ride"] = 546.31}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 13.69, ["Fly"] = 42, ["Ride"] = 24.91, ["Fly|Ride"] = 112.42, ["Neon"] = 83.58, ["Neon|Ride"] = 155.55, ["Neon|Fly|Ride"] = 196.42, ["Mega|Ride"] = 735.25, ["Mega|Fly|Ride"] = 619.74}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 13.11, ["Fly"] = 140.78, ["Ride"] = 52.5, ["Fly|Ride"] = 98.76, ["Neon"] = 164.07, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 185.7, ["Mega"] = 328.13, ["Mega|Ride"] = 353.95, ["Mega|Fly|Ride"] = 525.17}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 3.94, ["Fly"] = 336.16, ["Ride"] = 30.34, ["Fly|Ride"] = 104.7, ["Neon"] = 18.53, ["Neon|Fly"] = 69.57, ["Neon|Ride"] = 52.54, ["Neon|Fly|Ride"] = 119.11, ["Mega"] = 140.76, ["Mega|Fly"] = 183.74, ["Mega|Ride"] = 141.12, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 248.07, ["Fly"] = 918.75, ["Ride"] = 261.19, ["Fly|Ride"] = 315, ["Neon|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 1721.08, ["Mega|Fly|Ride"] = 6301.98}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 98.44, ["Fly"] = 1049.9, ["Ride"] = 161.69, ["Fly|Ride"] = 225.32, ["Neon"] = 628.69, ["Neon|Ride"] = 479.07, ["Neon|Fly|Ride"] = 525, ["Mega"] = 2100.68, ["Mega|Ride"] = 1993.53, ["Mega|Fly|Ride"] = 1954.67}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 56.1, ["Fly"] = 155.49, ["Ride"] = 77.75, ["Fly|Ride"] = 132.38, ["Neon"] = 557.81, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 425.25, ["Mega"] = 1609.65, ["Mega|Ride"] = 1656.09, ["Mega|Fly|Ride"] = 1365}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 17.91, ["Fly"] = 52.5, ["Ride"] = 58.22, ["Fly|Ride"] = 280.49, ["Neon"] = 210.1, ["Neon|Ride"] = 589.63, ["Neon|Fly|Ride"] = 489.53, ["Mega"] = 420.15, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 14.44, ["Ride"] = 32.29, ["Fly|Ride"] = 95.48, ["Neon"] = 69.35, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 210.08, ["Mega"] = 476.86, ["Mega|Fly"] = 525, ["Mega|Ride"] = 315.12, ["Mega|Fly|Ride"] = 557.26}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 2.5, ["Fly"] = 53.59, ["Ride"] = 16.14, ["Fly|Ride"] = 67.25, ["Neon"] = 14.01, ["Neon|Ride"] = 27.49, ["Neon|Fly|Ride"] = 140.78, ["Mega"] = 129.94, ["Mega|Ride"] = 168, ["Mega|Fly|Ride"] = 207.53}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 986.02, ["Fly"] = 1120.85, ["Ride"] = 913.5, ["Fly|Ride"] = 943.69, ["Neon"] = 3017.75, ["Neon|Fly"] = 2836.24, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2231.24, ["Mega|Fly|Ride"] = 6746.25}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 236.25, ["Fly"] = 496.77, ["Ride"] = 131.25, ["Fly|Ride"] = 328.13, ["Neon|Ride"] = 840.38, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 10503.28, ["Mega|Fly|Ride"] = 3179.35}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 86.15, ["Ride"] = 98.81, ["Fly|Ride"] = 193.3, ["Neon"] = 354.38, ["Neon|Ride"] = 319.55, ["Neon|Fly|Ride"] = 406.54, ["Mega"] = 1640.63, ["Mega|Ride"] = 1680.54, ["Mega|Fly|Ride"] = 1365.44}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 157.49, ["Fly"] = 226.91, ["Ride"] = 150.51, ["Fly|Ride"] = 248.11, ["Neon"] = 672.31, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 675.09, ["Mega"] = 10503.28, ["Mega|Fly|Ride"] = 2646.83}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 12.71, ["Fly"] = 48.34, ["Ride"] = 26.73, ["Fly|Ride"] = 68.25, ["Neon"] = 157.49, ["Neon|Ride"] = 291.37, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 532.53, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 774.09}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 227.4, ["Ride"] = 356.34, ["Neon"] = 981.14, ["Neon|Ride"] = 1341.48, ["Neon|Fly|Ride"] = 1090.69, ["Mega"] = 5244.75, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 98.76, ["Fly"] = 188.04, ["Ride"] = 98.76, ["Fly|Ride"] = 100.98, ["Neon|Ride"] = 464.28, ["Neon|Fly|Ride"] = 420.19, ["Mega|Fly|Ride"] = 1732.5}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1160.45, ["Ride"] = 1308.88, ["Fly|Ride"] = 984.38, ["Neon"] = 13125, ["Neon|Ride"] = 3923.47, ["Neon|Fly|Ride"] = 4482.31, ["Mega"] = 50415.7, ["Mega|Fly|Ride"] = 23087.45}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 14, ["Fly"] = 48.2, ["Ride"] = 35.73, ["Fly|Ride"] = 93.11, ["Neon"] = 37.91, ["Neon|Fly"] = 127.09, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 155.4, ["Mega"] = 156.85, ["Mega|Ride"] = 274.58, ["Mega|Fly|Ride"] = 351.62}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 35.7, ["Ride"] = 64.11, ["Fly|Ride"] = 126, ["Neon"] = 183.1, ["Neon|Ride"] = 202.83, ["Neon|Fly|Ride"] = 413.34, ["Mega"] = 2916.38, ["Mega|Ride"] = 940.06, ["Mega|Fly|Ride"] = 1091.3}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 74.97, ["Fly"] = 88.26, ["Ride"] = 65.54, ["Fly|Ride"] = 85.68, ["Neon|Ride"] = 410.82, ["Neon|Fly|Ride"] = 352.72, ["Mega|Fly|Ride"] = 1401.65}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 826.88, ["Ride"] = 918.75, ["Fly|Ride"] = 918.75, ["Neon|Fly|Ride"] = 4199.99, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 280.49, ["Ride"] = 456.96, ["Fly|Ride"] = 403.36, ["Neon|Ride"] = 1680.74, ["Neon|Fly|Ride"] = 1260.41, ["Mega|Fly|Ride"] = 9129.85}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 105, ["Fly"] = 209.84, ["Ride"] = 157.49, ["Fly|Ride"] = 198.19, ["Neon"] = 697.51, ["Neon|Ride"] = 429.99, ["Neon|Fly|Ride"] = 471.19, ["Mega"] = 3957.59, ["Mega|Ride"] = 4201.33, ["Mega|Fly|Ride"] = 1681.15}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 6.02, ["Fly"] = 39.38, ["Ride"] = 16.78, ["Fly|Ride"] = 87.94, ["Neon"] = 32.11, ["Neon|Ride"] = 70.41, ["Neon|Fly|Ride"] = 155.55, ["Mega"] = 638.31, ["Mega|Ride"] = 508.59, ["Mega|Fly|Ride"] = 809.82}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 27.4, ["Fly"] = 70.4, ["Ride"] = 48.34, ["Fly|Ride"] = 80.07, ["Neon"] = 209.9, ["Neon|Fly"] = 280.49, ["Neon|Ride"] = 230.05, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 1817.08, ["Mega|Fly|Ride"] = 981.85}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 813.75, ["Fly"] = 894.37, ["Ride"] = 910.88, ["Fly|Ride"] = 784.87, ["Neon|Ride"] = 5250, ["Neon|Fly|Ride"] = 2941.14, ["Mega|Fly|Ride"] = 12843.51}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 761.25}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4593.75, ["Ride"] = 3936.19, ["Fly|Ride"] = 3360, ["Neon|Ride"] = 30107.11, ["Neon|Fly|Ride"] = 13125, ["Mega|Fly|Ride"] = 89628.61}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 149.62, ["Fly"] = 408.19, ["Ride"] = 420.19, ["Fly|Ride"] = 378.17, ["Neon"] = 851.82, ["Neon|Ride"] = 1238.45, ["Neon|Fly|Ride"] = 851.82, ["Mega"] = 5881.85, ["Mega|Fly|Ride"] = 4901.89}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 90.57, ["Ride"] = 115.96, ["Fly|Ride"] = 336, ["Neon|Ride"] = 464.28, ["Neon|Fly|Ride"] = 459.38, ["Mega|Fly|Ride"] = 2241.42}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 14.44, ["Fly"] = 131.25, ["Ride"] = 21.63, ["Fly|Ride"] = 73.42, ["Neon"] = 274.32, ["Neon|Fly"] = 328.13, ["Neon|Ride"] = 126.76, ["Neon|Fly|Ride"] = 140.78, ["Mega"] = 689.04, ["Mega|Ride"] = 840.28, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 11.8, ["Fly"] = 39.38, ["Ride"] = 22.91, ["Fly|Ride"] = 45.94, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 280.45, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 699.54}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 15.21, ["Ride"] = 39.79, ["Fly|Ride"] = 105, ["Neon"] = 65.02, ["Neon|Ride"] = 86.82, ["Neon|Fly|Ride"] = 187.69, ["Mega"] = 1176.38, ["Mega|Ride"] = 859.69, ["Mega|Fly|Ride"] = 679.58}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.92, ["Ride"] = 27.91, ["Fly|Ride"] = 244.44, ["Neon"] = 52.5, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 155.5, ["Mega"] = 210, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 357}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 18.35, ["Ride"] = 39.35, ["Fly|Ride"] = 127.32, ["Neon"] = 126, ["Neon|Ride"] = 185.72, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 672.23, ["Mega|Ride"] = 472.5}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 229.69, ["Fly"] = 294.74, ["Ride"] = 252.1, ["Fly|Ride"] = 254.63, ["Neon"] = 728.1, ["Neon|Ride"] = 681.19, ["Neon|Fly|Ride"] = 677.25, ["Mega"] = 6562.5, ["Mega|Ride"] = 4201.33, ["Mega|Fly|Ride"] = 3431.44}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.24, ["Fly"] = 15.43, ["Ride"] = 12.07, ["Fly|Ride"] = 27.35, ["Neon"] = 19.97, ["Neon|Fly"] = 92.87, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 65.61, ["Mega"] = 157.5, ["Mega|Ride"] = 217.03, ["Mega|Fly|Ride"] = 267.75}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 31.4, ["Fly"] = 76.53, ["Ride"] = 57.63, ["Fly|Ride"] = 112.4, ["Neon"] = 144.38, ["Neon|Fly"] = 150.94, ["Neon|Ride"] = 139.13, ["Neon|Fly|Ride"] = 206.07, ["Mega"] = 525, ["Mega|Ride"] = 493.64, ["Mega|Fly|Ride"] = 458.06}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 721.88, ["Fly"] = 787.5, ["Ride"] = 654.93, ["Fly|Ride"] = 772.72, ["Neon|Ride"] = 1962.27, ["Neon|Fly|Ride"] = 1433.24, ["Mega|Fly|Ride"] = 3933.57}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 27.57, ["Fly"] = 38.06, ["Ride"] = 37.41, ["Fly|Ride"] = 76.13, ["Neon"] = 301.88, ["Neon|Fly"] = 464.28, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 187.69, ["Mega"] = 1575, ["Mega|Ride"] = 981.02, ["Mega|Fly|Ride"] = 710.72}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 242.8, ["Fly"] = 350.87, ["Ride"] = 223.13, ["Fly|Ride"] = 303.63, ["Neon"] = 1401.32, ["Neon|Fly|Ride"] = 787.5, ["Mega|Fly|Ride"] = 4174.01}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 108.47, ["Fly"] = 139.12, ["Ride"] = 106.32, ["Fly|Ride"] = 149.49, ["Neon"] = 630.29, ["Neon|Fly"] = 638.69, ["Neon|Ride"] = 555.98, ["Neon|Fly|Ride"] = 543.37, ["Mega"] = 2940.94, ["Mega|Fly|Ride"] = 1730.06}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 629.37, ["Ride"] = 586.69, ["Fly|Ride"] = 623.44, ["Neon"] = 2367.73, ["Neon|Ride"] = 2395.05, ["Neon|Fly|Ride"] = 2411.07, ["Mega|Fly|Ride"] = 7730.42}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 17.46, ["Ride"] = 44.1, ["Fly|Ride"] = 84.05, ["Neon"] = 86.58, ["Neon|Fly"] = 182.79, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 246.05, ["Mega"] = 525, ["Mega|Ride"] = 478.96, ["Mega|Fly|Ride"] = 449.55}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3675, ["Fly"] = 3939.31, ["Ride"] = 3936.19, ["Fly|Ride"] = 2861.25, ["Neon"] = 13971.06, ["Neon|Fly|Ride"] = 5643.75, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 60.38, ["Fly"] = 164.07, ["Ride"] = 77.75, ["Fly|Ride"] = 139.98, ["Neon"] = 394.77, ["Neon|Fly"] = 417.85, ["Neon|Ride"] = 441.08, ["Neon|Fly|Ride"] = 400.32, ["Mega|Fly|Ride"] = 1680.54}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 13.13, ["Fly|Ride"] = 45.94, ["Neon"] = 15.3, ["Neon|Fly"] = 44.63, ["Neon|Ride"] = 36.72, ["Neon|Fly|Ride"] = 77.77, ["Mega"] = 114.74, ["Mega|Fly"] = 452.82, ["Mega|Ride"] = 137.68, ["Mega|Fly|Ride"] = 217.03}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 2.49, ["Ride"] = 23.62, ["Neon"] = 19.69, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 347.01, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 32.82, ["Fly"] = 65.63, ["Ride"] = 45.49, ["Fly|Ride"] = 59.83, ["Neon|Ride"] = 266.83, ["Neon|Fly|Ride"] = 240.19, ["Mega|Fly|Ride"] = 1141.88}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 844.89, ["Ride"] = 895.13, ["Fly|Ride"] = 957.17, ["Neon"] = 6302.75, ["Neon|Ride"] = 5252.28, ["Neon|Fly|Ride"] = 5390.28, ["Mega|Fly|Ride"] = 19606.47}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 4901.44, ["Ride"] = 5603.15, ["Fly|Ride"] = 4725}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 16.56, ["Fly"] = 26.88, ["Ride"] = 22.35, ["Fly|Ride"] = 35.44, ["Neon"] = 452.12, ["Neon|Ride"] = 140.78, ["Neon|Fly|Ride"] = 102.38, ["Mega"] = 2520.8, ["Mega|Fly|Ride"] = 612.76}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 13.13, ["Fly"] = 31.49, ["Ride"] = 26.25, ["Fly|Ride"] = 77.79, ["Neon"] = 83, ["Neon|Fly"] = 210.1, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 136.5, ["Mega"] = 928.14, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 513.44}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 42.03, ["Fly"] = 157.45, ["Ride"] = 43.63, ["Fly|Ride"] = 77.16, ["Neon"] = 463.26, ["Neon|Ride"] = 251.9, ["Neon|Fly|Ride"] = 291.84, ["Mega|Fly|Ride"] = 1120.85}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 229.69, ["Ride"] = 222.92, ["Fly|Ride"] = 291.89, ["Neon|Ride"] = 1048.69, ["Neon|Fly|Ride"] = 1134.51, ["Mega"] = 10503.28, ["Mega|Fly|Ride"] = 3655.32}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.72, ["Ride"] = 40.98, ["Fly|Ride"] = 105, ["Neon"] = 14.44, ["Neon|Fly"] = 70.95, ["Neon|Ride"] = 104.01, ["Neon|Fly|Ride"] = 155.55, ["Mega"] = 120.22, ["Mega|Ride"] = 189.39, ["Mega|Fly|Ride"] = 294.11}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 169.32, ["Fly"] = 290.18, ["Ride"] = 131.25, ["Fly|Ride"] = 236.25, ["Neon"] = 672.31, ["Neon|Ride"] = 708.02, ["Neon|Fly|Ride"] = 619.74, ["Mega"] = 3488.15, ["Mega|Fly|Ride"] = 2624.99}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.63, ["Fly"] = 27.76, ["Ride"] = 13.58, ["Fly|Ride"] = 38.22, ["Neon"] = 15.1, ["Neon|Ride"] = 36.31, ["Neon|Fly|Ride"] = 88.1, ["Mega"] = 309.88, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 433.12}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 209.79, ["Fly"] = 271.03, ["Ride"] = 190.32, ["Fly|Ride"] = 196.88, ["Neon|Fly|Ride"] = 891.19, ["Mega"] = 10503.28, ["Mega|Fly|Ride"] = 2887.5}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 8.71, ["Fly"] = 420.19, ["Ride"] = 25.47, ["Fly|Ride"] = 63.04, ["Neon"] = 56.74, ["Neon|Fly"] = 294.82, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 392.83, ["Mega"] = 550.1, ["Mega|Ride"] = 588.19, ["Mega|Fly|Ride"] = 503.12}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Fly|Ride"] = 111.57, ["Neon"] = 9.59, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 35.73, ["Neon|Fly|Ride"] = 93.23, ["Mega"] = 76.13, ["Mega|Fly"] = 420.15, ["Mega|Ride"] = 100.88, ["Mega|Fly|Ride"] = 213.94}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 4.73, ["Mega"] = 24.07, ["Mega|Ride"] = 39.35, ["Mega|Fly|Ride"] = 165.97}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Ride"] = 56.74, ["Fly|Ride"] = 140.78, ["Neon"] = 6.03, ["Neon|Ride"] = 29.65, ["Neon|Fly|Ride"] = 112.42, ["Mega"] = 61.99, ["Mega|Fly"] = 154727.32, ["Mega|Ride"] = 101.93, ["Mega|Fly|Ride"] = 190.25}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 44.46, ["Fly"] = 131.25, ["Ride"] = 78.75, ["Fly|Ride"] = 141.83, ["Neon"] = 249.38, ["Neon|Ride"] = 223.12, ["Neon|Fly|Ride"] = 366.19, ["Mega|Ride"] = 1311.19, ["Mega|Fly|Ride"] = 1117.56}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.05, ["Fly"] = 45.82, ["Ride"] = 18.38, ["Fly|Ride"] = 29.01, ["Neon"] = 6.25, ["Neon|Ride"] = 40.63, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 126.07, ["Mega|Ride"] = 137.71, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 11.81, ["Ride"] = 59.06, ["Neon"] = 65.63, ["Neon|Ride"] = 98.44, ["Mega"] = 420, ["Mega|Ride"] = 543.63}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.37, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 252.1, ["Mega"] = 11.47, ["Mega|Ride"] = 30.85, ["Mega|Fly|Ride"] = 155.52}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.05, ["Fly"] = 17.03, ["Ride"] = 21, ["Fly|Ride"] = 35.73, ["Neon"] = 2.1, ["Neon|Fly"] = 21.02, ["Neon|Ride"] = 13.2, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 14.43, ["Mega|Ride"] = 10.5, ["Mega|Fly|Ride"] = 55.47}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.05, ["Ride"] = 14.94, ["Fly|Ride"] = 32.66, ["Neon"] = 2.63, ["Neon|Fly"] = 39.35, ["Neon|Ride"] = 14.96, ["Neon|Fly|Ride"] = 28.38, ["Mega"] = 15.68, ["Mega|Ride"] = 28.2, ["Mega|Fly|Ride"] = 89.12}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.05, ["Ride"] = 33.63, ["Neon"] = 2.1, ["Mega"] = 13.42, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 217.03}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 11.82, ["Fly|Ride"] = 105.06, ["Neon"] = 6.57, ["Neon|Ride"] = 92.46, ["Neon|Fly|Ride"] = 73.37, ["Mega"] = 30.51, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 82.99, ["Mega|Fly|Ride"] = 119.76}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.41, ["Neon|Fly|Ride"] = 140.63, ["Mega"] = 16.56, ["Mega|Ride"] = 56.02, ["Mega|Fly|Ride"] = 420.15}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 40.65, ["Ride"] = 19.11, ["Fly|Ride"] = 48.49, ["Neon"] = 3.28, ["Neon|Fly"] = 37.96, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 35.43, ["Mega"] = 58.57, ["Mega|Fly"] = 95.6, ["Mega|Ride"] = 70.6, ["Mega|Fly|Ride"] = 98.36}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 41.53, ["Mega"] = 15.27, ["Mega|Ride"] = 45.85, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.31, ["Ride"] = 141.83, ["Fly|Ride"] = 525, ["Neon"] = 14.04, ["Mega"] = 118.13, ["Mega|Fly|Ride"] = 210.08}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 3.63, ["Ride"] = 53.87, ["Neon"] = 29.43}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 35.64, ["Mega"] = 19.67, ["Mega|Ride"] = 155.52, ["Mega|Fly|Ride"] = 140.69}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.05, ["Fly"] = 26.25, ["Ride"] = 14.94, ["Fly|Ride"] = 38.88, ["Neon"] = 2.1, ["Neon|Fly"] = 33.63, ["Neon|Ride"] = 15.78, ["Neon|Fly|Ride"] = 37.43, ["Mega"] = 14.44, ["Mega|Fly"] = 65.63, ["Mega|Ride"] = 20.94, ["Mega|Fly|Ride"] = 34.78}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.05}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 4.22, ["Fly"] = 72.19, ["Ride"] = 218.19, ["Fly|Ride"] = 118.72, ["Neon"] = 37.83, ["Mega"] = 251.05, ["Mega|Ride"] = 350.82}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 18.02, ["Fly|Ride"] = 78.73, ["Neon"] = 3.82, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 63.04, ["Mega"] = 28.34, ["Mega|Fly"] = 155.52, ["Mega|Ride"] = 50.93, ["Mega|Fly|Ride"] = 93.51}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.1, ["Ride"] = 70.4, ["Neon"] = 7.65, ["Neon|Fly|Ride"] = 140.76, ["Mega"] = 40.82, ["Mega|Ride"] = 132.57, ["Mega|Fly|Ride"] = 420.15}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 656.25, ["Ride"] = 32.81, ["Fly|Ride"] = 191.19, ["Neon"] = 8.91, ["Neon|Fly"] = 91.71, ["Neon|Ride"] = 42.03, ["Neon|Fly|Ride"] = 271.03, ["Mega"] = 56.74, ["Mega|Fly|Ride"] = 280.26}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.05, ["Fly"] = 12.39, ["Ride"] = 12.68, ["Fly|Ride"] = 20.57, ["Neon"] = 2.1, ["Neon|Fly"] = 14.32, ["Neon|Ride"] = 11.82, ["Neon|Fly|Ride"] = 22.95, ["Mega"] = 13.13, ["Mega|Fly"] = 23.63, ["Mega|Ride"] = 18.79, ["Mega|Fly|Ride"] = 32.82}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 19.65, ["Fly|Ride"] = 42, ["Neon"] = 15.73, ["Neon|Ride"] = 106.04, ["Neon|Fly|Ride"] = 63.04, ["Mega"] = 78.79, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 200.63}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.1, ["Fly"] = 110.1, ["Fly|Ride"] = 98.76, ["Neon"] = 36.27, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 139.3, ["Mega"] = 269.05, ["Mega|Ride"] = 418.04, ["Mega|Fly|Ride"] = 347.67}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.05, ["Fly"] = 14.26, ["Ride"] = 13.13, ["Fly|Ride"] = 28.38, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 13.79, ["Neon|Fly|Ride"] = 39.93, ["Mega"] = 14.32, ["Mega|Fly"] = 156.19, ["Mega|Ride"] = 140.6, ["Mega|Fly|Ride"] = 117.95}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Neon"] = 3.45, ["Neon|Fly"] = 77.75, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 105, ["Mega"] = 54.68, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 309.87}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 28.38, ["Fly|Ride"] = 131.25, ["Neon"] = 3.93, ["Neon|Ride"] = 81.95, ["Neon|Fly|Ride"] = 309.91, ["Mega"] = 30.55, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 40.69, ["Neon|Ride"] = 33.64, ["Neon|Fly|Ride"] = 53.7, ["Mega"] = 14.43, ["Mega|Ride"] = 77.74, ["Mega|Fly|Ride"] = 187.78}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.05, ["Ride"] = 20.89, ["Fly|Ride"] = 77.75, ["Neon"] = 5.25, ["Neon|Fly"] = 42.03, ["Neon|Ride"] = 44.61, ["Neon|Fly|Ride"] = 84, ["Mega"] = 90.57, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 496.72}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 18.38, ["Neon"] = 4.17, ["Neon|Ride"] = 48.29, ["Mega"] = 68.14, ["Mega|Ride"] = 120.43, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 28.38, ["Ride"] = 14.7, ["Fly|Ride"] = 36.75, ["Neon"] = 3.75, ["Neon|Fly"] = 70.4, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 67.25, ["Mega|Ride"] = 132.17, ["Mega|Fly|Ride"] = 149.63}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.05, ["Ride"] = 82.62, ["Neon"] = 42.04, ["Mega"] = 296.63, ["Mega|Ride"] = 700.59, ["Mega|Fly|Ride"] = 774.09}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 19.97, ["Ride"] = 14.44, ["Fly|Ride"] = 56.44, ["Neon"] = 8.61, ["Neon|Fly"] = 81.95, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 142.76, ["Mega"] = 315, ["Mega|Ride"] = 263.64, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.48, ["Fly"] = 91.88, ["Ride"] = 19.69, ["Fly|Ride"] = 35.44, ["Neon"] = 11.38, ["Neon|Fly"] = 56.17, ["Neon|Ride"] = 23.23, ["Neon|Fly|Ride"] = 106.32, ["Mega"] = 128.62, ["Mega|Ride"] = 150.94, ["Mega|Fly|Ride"] = 196.51}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 79.47, ["Fly|Ride"] = 106.14, ["Neon"] = 31.98}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 157.5, ["Neon|Ride"] = 140.78, ["Mega"] = 459.38, ["Mega|Ride"] = 981.02, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 4.2, ["Ride"] = 34.74, ["Fly|Ride"] = 59.07, ["Neon"] = 21.56, ["Mega"] = 362.11, ["Mega|Ride"] = 560.89}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 3.83, ["Ride"] = 67.56, ["Fly|Ride"] = 131.25, ["Neon"] = 31.44, ["Neon|Ride"] = 291.38, ["Mega"] = 195.81, ["Mega|Ride"] = 268.42, ["Mega|Fly|Ride"] = 406.49}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.82, ["Neon|Ride"] = 120.82, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 13.63, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 52.5}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 3.47, ["Fly"] = 21.2, ["Ride"] = 15.21, ["Fly|Ride"] = 51.19, ["Neon"] = 32.47, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 25.45, ["Neon|Fly|Ride"] = 82.69, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 222.8}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.05, ["Fly"] = 21.02, ["Ride"] = 18.69, ["Fly|Ride"] = 70.62, ["Neon"] = 3.41, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 155.55, ["Mega"] = 19.69, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 168.07}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 157.5, ["Fly|Ride"] = 387.68, ["Neon"] = 3.54, ["Neon|Ride"] = 44.61, ["Mega"] = 43.46, ["Mega|Ride"] = 62.29, ["Mega|Fly|Ride"] = 116.82}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.61, ["Fly"] = 45.94, ["Ride"] = 19.69, ["Neon"] = 13.13, ["Neon|Ride"] = 19.95, ["Neon|Fly|Ride"] = 87.28, ["Mega"] = 141.99, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.78, ["Ride"] = 22.56, ["Neon"] = 42.03, ["Neon|Ride"] = 62.69, ["Neon|Fly|Ride"] = 172.6, ["Mega"] = 314.35}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 31.91, ["Mega"] = 15.74, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 43.79, ["Mega|Fly|Ride"] = 161.44}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.05}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.05, ["Ride"] = 40.69, ["Fly|Ride"] = 280121.69, ["Neon"] = 2.59, ["Neon|Fly"] = 68.83, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 66.94, ["Mega"] = 35.44, ["Mega|Fly"] = 84.04, ["Mega|Ride"] = 58.33, ["Mega|Fly|Ride"] = 113.76}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.25, ["Ride"] = 17.07, ["Fly|Ride"] = 42, ["Neon"] = 3.4, ["Neon|Fly"] = 102.96, ["Neon|Ride"] = 18.36, ["Neon|Fly|Ride"] = 74.82, ["Mega"] = 140.76, ["Mega|Ride"] = 75.52, ["Mega|Fly|Ride"] = 133.41}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Ride"] = 280.49, ["Neon"] = 3.56, ["Neon|Ride"] = 19.59, ["Neon|Fly|Ride"] = 72.12, ["Mega"] = 17.71, ["Mega|Fly"] = 84.04, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.63, ["Neon|Ride"] = 32.58, ["Neon|Fly|Ride"] = 120.81, ["Mega"] = 23.63, ["Mega|Fly"] = 105, ["Mega|Ride"] = 66.07, ["Mega|Fly|Ride"] = 165.97}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 53.59, ["Ride"] = 19.59, ["Neon"] = 2.63, ["Neon|Fly"] = 45.93, ["Neon|Ride"] = 17.36, ["Neon|Fly|Ride"] = 43.32, ["Mega"] = 16.96, ["Mega|Ride"] = 37.95, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.05, ["Ride"] = 39.38, ["Fly|Ride"] = 32.58, ["Neon"] = 2.1, ["Neon|Ride"] = 70.88, ["Mega"] = 14.44, ["Mega|Ride"] = 205.33}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.63, ["Neon"] = 3.54, ["Neon|Fly"] = 70.4, ["Neon|Ride"] = 77.79, ["Neon|Fly|Ride"] = 420, ["Mega"] = 21.57, ["Mega|Ride"] = 356.08}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.05, ["Fly"] = 27.45, ["Ride"] = 13.9, ["Fly|Ride"] = 52.5, ["Neon"] = 3.3, ["Neon|Ride"] = 15.49, ["Neon|Fly|Ride"] = 74.82, ["Mega"] = 41.74, ["Mega|Ride"] = 48.57, ["Mega|Fly|Ride"] = 107.13}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 12.59, ["Ride"] = 59.07, ["Neon"] = 101.07, ["Neon|Ride"] = 78.75, ["Mega"] = 415.42, ["Mega|Ride"] = 479.73, ["Mega|Fly|Ride"] = 524.12}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Ride"] = 49.49, ["Neon"] = 94.5, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 420.15, ["Mega|Ride"] = 343.23, ["Mega|Fly|Ride"] = 630.21}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 3.52, ["Ride"] = 42.03, ["Fly|Ride"] = 344.02, ["Neon"] = 42.03, ["Neon|Ride"] = 84.05, ["Mega"] = 211.74, ["Mega|Fly|Ride"] = 523.59}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.05, ["Fly"] = 12.86, ["Ride"] = 11.43, ["Fly|Ride"] = 35.73, ["Neon"] = 2.1, ["Neon|Fly"] = 13.13, ["Neon|Ride"] = 10.48, ["Neon|Fly|Ride"] = 15.94, ["Mega"] = 15.74, ["Mega|Fly"] = 22.32, ["Mega|Ride"] = 15.42, ["Mega|Fly|Ride"] = 38.53}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 3.71, ["Ride"] = 55.13, ["Fly|Ride"] = 64.32, ["Neon"] = 11.1, ["Neon|Fly"] = 140.78, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 68.25, ["Mega|Ride"] = 41.06, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.05, ["Fly"] = 13.13, ["Ride"] = 31.5, ["Neon"] = 2.1, ["Neon|Fly"] = 31.36, ["Neon|Ride"] = 31.53, ["Neon|Fly|Ride"] = 79.04, ["Mega"] = 9.19, ["Mega|Fly"] = 32.81, ["Mega|Ride"] = 33.66, ["Mega|Fly|Ride"] = 207.83}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 60.9, ["Mega"] = 13.11, ["Mega|Ride"] = 79.84, ["Mega|Fly|Ride"] = 225.16}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 21.02, ["Ride"] = 13.57, ["Fly|Ride"] = 32.82, ["Neon"] = 9.19, ["Neon|Fly"] = 77.7, ["Neon|Ride"] = 36.78, ["Neon|Fly|Ride"] = 102.95, ["Mega"] = 116.63, ["Mega|Ride"] = 230.04, ["Mega|Fly|Ride"] = 192.05}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 199.4, ["Ride"] = 252.12, ["Fly|Ride"] = 326.82, ["Neon"] = 1362.64, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 958.13, ["Mega"] = 8402.63, ["Mega|Fly|Ride"] = 4005.96}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Fly|Ride"] = 52.5, ["Neon"] = 10.19, ["Neon|Ride"] = 69.29, ["Mega"] = 69.65, ["Mega|Fly|Ride"] = 420.15}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 7.39, ["Fly"] = 103.68, ["Ride"] = 24.1, ["Fly|Ride"] = 168.09, ["Neon"] = 42.56, ["Neon|Ride"] = 156.91, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 525, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.05, ["Fly"] = 21.17, ["Ride"] = 15.74, ["Fly|Ride"] = 61.85, ["Neon"] = 3.94, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 14.84, ["Neon|Fly|Ride"] = 43.32, ["Mega"] = 49.2, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 123.96}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Ride"] = 24.15, ["Fly|Ride"] = 121.87, ["Neon"] = 5.46, ["Neon|Fly"] = 42.03, ["Neon|Ride"] = 103.63, ["Mega"] = 84.04, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 209.03}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 4.5, ["Fly"] = 32.64, ["Ride"] = 17.43, ["Fly|Ride"] = 42.82, ["Neon"] = 28.55, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 51.19, ["Mega"] = 160.13, ["Mega|Ride"] = 277.34, ["Mega|Fly|Ride"] = 309.88}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.93, ["Ride"] = 39.6, ["Fly|Ride"] = 57.75, ["Neon"] = 41.34, ["Neon|Ride"] = 137.45, ["Neon|Fly|Ride"] = 623.99, ["Mega"] = 222.69, ["Mega|Ride"] = 348.16, ["Mega|Fly|Ride"] = 507.29}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 17.04, ["Ride"] = 12.73, ["Fly|Ride"] = 26.25, ["Neon"] = 19.19, ["Neon|Fly"] = 70.32, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 59.01, ["Mega|Fly"] = 384.18, ["Mega|Ride"] = 398.72, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 65.3, ["Ride"] = 92.61, ["Fly|Ride"] = 162.49, ["Neon"] = 387.63, ["Neon|Fly"] = 394.42, ["Neon|Ride"] = 351.63, ["Neon|Fly|Ride"] = 420, ["Mega|Fly|Ride"] = 1311.19}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 216.57, ["Fly"] = 315.15, ["Ride"] = 168, ["Fly|Ride"] = 281.72, ["Neon|Ride"] = 1120.85, ["Neon|Fly|Ride"] = 803.94, ["Mega"] = 10503.28, ["Mega|Fly|Ride"] = 3780}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 61.69, ["Fly"] = 104.99, ["Ride"] = 64.32, ["Fly|Ride"] = 111.57, ["Neon"] = 301.88, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 324.19, ["Mega|Fly|Ride"] = 1022.44}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 5.91, ["Ride"] = 278.2, ["Fly|Ride"] = 56.74, ["Neon"] = 16.3, ["Neon|Ride"] = 27.55, ["Neon|Fly|Ride"] = 171.78, ["Mega"] = 243.7, ["Mega|Ride"] = 225.67, ["Mega|Fly|Ride"] = 387.85}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 10.18, ["Ride"] = 27.78, ["Fly|Ride"] = 43.32, ["Neon"] = 47.66, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 266.83, ["Mega"] = 420.15, ["Mega|Ride"] = 336, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.05, ["Fly"] = 25.23, ["Ride"] = 19.69, ["Fly|Ride"] = 51.18, ["Neon"] = 2.1, ["Neon|Fly"] = 129.93, ["Neon|Ride"] = 19.67, ["Neon|Fly|Ride"] = 65.58, ["Mega"] = 33.5, ["Mega|Fly"] = 78.75, ["Mega|Ride"] = 124.19, ["Mega|Fly|Ride"] = 165.94}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 5.76, ["Fly"] = 65.63, ["Ride"] = 24.94, ["Fly|Ride"] = 49.51, ["Neon"] = 18.75, ["Neon|Ride"] = 81.95, ["Neon|Fly|Ride"] = 140.78, ["Mega"] = 387.63, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 17.8, ["Ride"] = 11.81, ["Fly|Ride"] = 43.63, ["Neon"] = 9.44, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 22.97, ["Neon|Fly|Ride"] = 84.04, ["Mega"] = 131.24, ["Mega|Ride"] = 140.76, ["Mega|Fly|Ride"] = 309.88}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 3.45, ["Ride"] = 26.73, ["Fly|Ride"] = 328.13, ["Neon"] = 11.69, ["Neon|Ride"] = 56.75, ["Mega"] = 179.81, ["Mega|Fly|Ride"] = 700.59}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.05, ["Fly"] = 28.38, ["Ride"] = 105, ["Neon"] = 2.1, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 15.74, ["Mega|Ride"] = 51.49, ["Mega|Fly|Ride"] = 165.38}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 55.69, ["Ride"] = 28.38, ["Fly|Ride"] = 56.44, ["Neon"] = 8.58, ["Neon|Fly"] = 70.4, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 81.95, ["Mega"] = 140.51, ["Mega|Ride"] = 112.41, ["Mega|Fly|Ride"] = 192.29}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 36.74, ["Ride"] = 19.97, ["Fly|Ride"] = 32.26, ["Neon"] = 62.31, ["Neon|Ride"] = 56.74, ["Neon|Fly|Ride"] = 98.76, ["Mega"] = 155.47, ["Mega|Fly|Ride"] = 244.53}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 120.75, ["Fly"] = 243.7, ["Ride"] = 150.24, ["Fly|Ride"] = 183.74, ["Neon"] = 525.25, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 1732.5}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.96, ["Ride"] = 240.91, ["Fly|Ride"] = 206.07, ["Neon"] = 19.69, ["Neon|Ride"] = 124.2, ["Neon|Fly|Ride"] = 196.45, ["Mega"] = 414.74, ["Mega|Ride"] = 406.49, ["Mega|Fly|Ride"] = 347.67}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 21.02, ["Ride"] = 17.28, ["Fly|Ride"] = 63, ["Neon"] = 19.05, ["Neon|Ride"] = 136.55, ["Neon|Fly|Ride"] = 140.78, ["Mega"] = 140.76, ["Mega|Ride"] = 255.94, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 24.94, ["Ride"] = 49.39, ["Fly|Ride"] = 124.45, ["Neon"] = 106.2, ["Neon|Ride"] = 98.76, ["Neon|Fly|Ride"] = 294.54, ["Mega"] = 532.53, ["Mega|Ride"] = 463.2, ["Mega|Fly|Ride"] = 489.46}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 3.36}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 3.02, ["Ride"] = 35.7, ["Neon"] = 24.71, ["Neon|Fly|Ride"] = 602.98, ["Mega"] = 288.75, ["Mega|Ride"] = 406.49, ["Mega|Fly|Ride"] = 1260.41}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 19.77, ["Fly"] = 48.34, ["Ride"] = 32.45, ["Fly|Ride"] = 51.8, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 119.43, ["Neon|Fly|Ride"] = 231.67, ["Mega"] = 2100.68, ["Mega|Fly|Ride"] = 956.87}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 25.19, ["Neon"] = 2.1, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 63.04, ["Mega"] = 22.84, ["Mega|Ride"] = 61.05, ["Mega|Fly|Ride"] = 177.37}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 6.57, ["Fly"] = 17.03, ["Ride"] = 28.38, ["Neon"] = 24.92, ["Neon|Ride"] = 232.15, ["Mega"] = 247.91, ["Mega|Fly"] = 387.63, ["Mega|Ride"] = 185.7, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 13.13, ["Fly|Ride"] = 61.43, ["Neon"] = 12.46, ["Neon|Ride"] = 38.06, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 70.3, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 170.62}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.05, ["Ride"] = 15.77, ["Neon"] = 2.49, ["Neon|Ride"] = 39.46, ["Neon|Fly|Ride"] = 70.4, ["Mega"] = 25.53, ["Mega|Ride"] = 64.09, ["Mega|Fly|Ride"] = 116.61}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 26.94, ["Fly"] = 155.55, ["Ride"] = 38.3, ["Fly|Ride"] = 131.25, ["Neon"] = 156.53, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 210.08, ["Mega"] = 774.38, ["Mega|Ride"] = 808.5, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.29, ["Ride"] = 48.34, ["Fly|Ride"] = 209.99, ["Neon"] = 44.88, ["Neon|Ride"] = 78.8, ["Mega"] = 230.95, ["Mega|Ride"] = 524.99}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 11.84, ["Fly"] = 75.02, ["Ride"] = 31.66, ["Fly|Ride"] = 99.83, ["Neon"] = 50.92, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 70.86, ["Neon|Fly|Ride"] = 134.74, ["Mega"] = 288.75, ["Mega|Ride"] = 301.46, ["Mega|Fly|Ride"] = 456.1}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 69.4, ["Fly"] = 280.49, ["Ride"] = 102.38, ["Fly|Ride"] = 262.44, ["Neon"] = 420.19, ["Neon|Ride"] = 419.14, ["Neon|Fly|Ride"] = 420.15, ["Mega|Ride"] = 1792.93, ["Mega|Fly|Ride"] = 1821.28}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 22.98, ["Ride"] = 45.44, ["Fly|Ride"] = 247.37, ["Neon"] = 78.75, ["Neon|Ride"] = 116.6, ["Neon|Fly|Ride"] = 551.25, ["Mega"] = 367.5, ["Mega|Ride"] = 322.46, ["Mega|Fly|Ride"] = 309.88}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 65.63, ["Fly"] = 131.25, ["Ride"] = 65.63, ["Fly|Ride"] = 155.55, ["Neon"] = 224.44, ["Neon|Ride"] = 263.05, ["Neon|Fly|Ride"] = 267.02, ["Mega"] = 905.63, ["Mega|Ride"] = 930.29, ["Mega|Fly|Ride"] = 893.08}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 24.86, ["Ride"] = 31.84, ["Fly|Ride"] = 140.78, ["Neon"] = 84.66, ["Neon|Fly"] = 249.38, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 209.77, ["Mega"] = 359.45, ["Mega|Ride"] = 303.81, ["Mega|Fly|Ride"] = 436.54}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 3.46, ["Fly"] = 28.38, ["Ride"] = 23.13, ["Fly|Ride"] = 65.63, ["Neon"] = 22.31, ["Neon|Ride"] = 266.83, ["Neon|Fly|Ride"] = 557.13, ["Mega"] = 315, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 19.36, ["Fly"] = 72.19, ["Ride"] = 125.01, ["Fly|Ride"] = 98.76, ["Neon"] = 93.55, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 525, ["Mega"] = 519.75, ["Mega|Ride"] = 271, ["Mega|Fly|Ride"] = 518.44}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 5.31, ["Ride"] = 25.92, ["Fly|Ride"] = 78.75, ["Neon"] = 32.82, ["Neon|Ride"] = 65.63, ["Mega"] = 416.59, ["Mega|Ride"] = 301.43, ["Mega|Fly|Ride"] = 374.99}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.05, ["Neon"] = 2.1, ["Neon|Ride"] = 32.8, ["Mega"] = 15.74, ["Mega|Fly"] = 140.76, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 163.91}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 2.1, ["Ride"] = 28.38, ["Fly|Ride"] = 70.4, ["Neon"] = 9.18, ["Neon|Ride"] = 83.83, ["Mega"] = 117.87, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 280.45}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.63, ["Neon"] = 16.94, ["Neon|Ride"] = 118.13, ["Mega"] = 336, ["Mega|Ride"] = 392.83}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 3.68, ["Ride"] = 31.35, ["Fly|Ride"] = 116.08, ["Neon"] = 20.01, ["Neon|Ride"] = 84.05, ["Neon|Fly|Ride"] = 279.44, ["Mega"] = 79.79, ["Mega|Ride"] = 155.52, ["Mega|Fly|Ride"] = 263.34}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 438.35, ["Fly"] = 603.57, ["Ride"] = 497.44, ["Fly|Ride"] = 471.09, ["Neon|Ride"] = 1679.11, ["Neon|Fly|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 4074}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 3.94, ["Fly"] = 56.26, ["Ride"] = 24.94, ["Fly|Ride"] = 62.69, ["Neon"] = 37.84, ["Neon|Ride"] = 83.91, ["Neon|Fly|Ride"] = 124.19, ["Mega"] = 299.43, ["Mega|Ride"] = 280.45}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 7.86, ["Fly"] = 31.49, ["Fly|Ride"] = 84.05, ["Neon"] = 84.05, ["Neon|Fly"] = 315, ["Neon|Ride"] = 64.16, ["Neon|Fly|Ride"] = 108.94, ["Mega"] = 322.46, ["Mega|Ride"] = 322.46, ["Mega|Fly|Ride"] = 464.22}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.63, ["Fly"] = 91.88, ["Ride"] = 21, ["Fly|Ride"] = 315.15, ["Neon|Ride"] = 86.52, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 42.03, ["Ride"] = 19.67, ["Neon"] = 6.3, ["Neon|Fly"] = 70.4, ["Neon|Ride"] = 28.35, ["Neon|Fly|Ride"] = 116.8, ["Mega"] = 56.21, ["Mega|Fly"] = 237.39, ["Mega|Ride"] = 64.31, ["Mega|Fly|Ride"] = 180.76}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Ride"] = 67.1, ["Neon"] = 2.63, ["Neon|Ride"] = 25.66, ["Neon|Fly|Ride"] = 116.06, ["Mega"] = 17.95, ["Mega|Ride"] = 65.24, ["Mega|Fly|Ride"] = 185.73}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1312.5}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 8.43, ["Fly"] = 65.63, ["Ride"] = 38.07, ["Fly|Ride"] = 130.28, ["Neon"] = 115.5, ["Neon|Fly"] = 140.78, ["Neon|Ride"] = 80.42, ["Neon|Fly|Ride"] = 145.69, ["Mega"] = 445.66, ["Mega|Ride"] = 280.45, ["Mega|Fly|Ride"] = 571.39}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 45.36, ["Neon"] = 5.93, ["Neon|Ride"] = 70.55, ["Mega"] = 32.8, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 224.44}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.63, ["Fly"] = 42.03, ["Ride"] = 19.94, ["Fly|Ride"] = 525, ["Neon"] = 7.88, ["Neon|Ride"] = 70.09, ["Neon|Fly|Ride"] = 105, ["Mega"] = 73.79, ["Mega|Ride"] = 140.44, ["Mega|Fly|Ride"] = 168}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 367.5, ["Ride"] = 413.44, ["Fly|Ride"] = 446.25, ["Neon|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 1246.88, ["Mega|Fly|Ride"] = 8123.25}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 6.56, ["Fly"] = 196.88, ["Ride"] = 59.07, ["Neon"] = 52.42, ["Neon|Ride"] = 131.25, ["Mega"] = 280.45, ["Mega|Ride"] = 395.07, ["Mega|Fly|Ride"] = 498.92}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Ride"] = 28.35, ["Neon"] = 3.94, ["Neon|Fly"] = 210.1, ["Neon|Ride"] = 24.94, ["Mega"] = 30.44, ["Mega|Fly"] = 189, ["Mega|Ride"] = 78.73, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 25.47, ["Fly|Ride"] = 238.47, ["Neon"] = 3.63, ["Neon|Ride"] = 52.45, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 22.29, ["Mega|Ride"] = 124.16, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 7.86, ["Fly"] = 78.7, ["Ride"] = 37.15, ["Fly|Ride"] = 178.5, ["Neon"] = 41.97, ["Neon|Ride"] = 48.28, ["Neon|Fly|Ride"] = 276.28, ["Mega"] = 279.02, ["Mega|Ride"] = 309.88, ["Mega|Fly|Ride"] = 464.22}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 8.27, ["Fly|Ride"] = 52.5, ["Neon"] = 504.24, ["Neon|Fly|Ride"] = 837.38, ["Mega"] = 490.52, ["Mega|Ride"] = 464.22, ["Mega|Fly|Ride"] = 1046.73}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 3.18, ["Neon"] = 126.93, ["Neon|Ride"] = 209.05, ["Mega"] = 280.45, ["Mega|Ride"] = 406.23, ["Mega|Fly|Ride"] = 471.61}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 5.86, ["Ride"] = 65.15, ["Fly|Ride"] = 231.91, ["Neon"] = 105.06, ["Neon|Ride"] = 124.2, ["Neon|Fly|Ride"] = 774.17, ["Mega"] = 660.19, ["Mega|Ride"] = 440.55, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 370.79, ["Ride"] = 457.41, ["Fly|Ride"] = 607.17, ["Neon"] = 1758.42, ["Neon|Ride"] = 2100.93, ["Neon|Fly|Ride"] = 1405.69, ["Mega|Ride"] = 3766.49, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 3.73, ["Fly"] = 24.94, ["Ride"] = 30.93, ["Fly|Ride"] = 82.41, ["Neon"] = 23.93, ["Neon|Ride"] = 98.76, ["Neon|Fly|Ride"] = 140.62, ["Mega"] = 529.78, ["Mega|Ride"] = 497.87, ["Mega|Fly|Ride"] = 693.24}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 2.45, ["Ride"] = 41.68, ["Neon"] = 25.91, ["Mega"] = 1260.41, ["Mega|Fly|Ride"] = 560.89}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 10.5, ["Ride"] = 59.06, ["Fly|Ride"] = 157.5, ["Neon"] = 29.82, ["Neon|Ride"] = 65.63, ["Mega"] = 159.97, ["Mega|Ride"] = 191.63, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Ride"] = 31.49, ["Fly|Ride"] = 98.76, ["Neon"] = 11.82, ["Neon|Ride"] = 65.63, ["Mega"] = 35.2, ["Mega|Ride"] = 96.65, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 28.69, ["Ride"] = 45.94, ["Neon"] = 263.48, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 287.44, ["Mega"] = 840.28, ["Mega|Ride"] = 840.28, ["Mega|Fly|Ride"] = 980.87}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.05, ["Fly"] = 580.35, ["Ride"] = 24.91, ["Neon"] = 5.25, ["Neon|Fly"] = 182.79, ["Neon|Ride"] = 33.59, ["Neon|Fly|Ride"] = 105.06, ["Mega"] = 59.07, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 236.13}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.05, ["Fly"] = 77.75, ["Ride"] = 31.35, ["Neon"] = 3.36, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 37.37, ["Mega|Ride"] = 60.38, ["Mega|Fly|Ride"] = 178.01}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Fly"] = 1519.88, ["Ride"] = 23.63, ["Fly|Ride"] = 262.5, ["Neon"] = 6.45, ["Neon|Ride"] = 158.06, ["Neon|Fly|Ride"] = 295.32, ["Mega"] = 85.31, ["Mega|Ride"] = 95.6, ["Mega|Fly|Ride"] = 192.94}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 57.75, ["Fly"] = 114.92, ["Ride"] = 62.68, ["Fly|Ride"] = 105.06, ["Neon"] = 420.19, ["Neon|Ride"] = 420.19, ["Neon|Fly|Ride"] = 670.04, ["Mega|Ride"] = 898.04, ["Mega|Fly|Ride"] = 901.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 229.69, ["Ride"] = 262.5, ["Fly|Ride"] = 418.09, ["Neon|Ride"] = 1099.88, ["Neon|Fly|Ride"] = 1548.33, ["Mega"] = 6722.12, ["Mega|Fly|Ride"] = 4593.75}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 2.37, ["Neon"] = 26.75, ["Mega"] = 91.48, ["Mega|Fly"] = 139.29, ["Mega|Ride"] = 202.13, ["Mega|Fly|Ride"] = 392.83}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 5.58, ["Neon"] = 46.4, ["Neon|Fly|Ride"] = 1721.46, ["Mega"] = 137.71, ["Mega|Fly|Ride"] = 524.12}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.3, ["Fly"] = 155.57, ["Neon"] = 29.95, ["Neon|Ride"] = 62.69, ["Mega"] = 483.67, ["Mega|Ride"] = 337.84}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.05, ["Fly"] = 53.23, ["Ride"] = 30.19, ["Neon"] = 3.52, ["Neon|Ride"] = 19.95, ["Neon|Fly|Ride"] = 47.33, ["Mega"] = 41.94, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 105.79}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 59.07, ["Neon"] = 4.59, ["Neon|Ride"] = 21.02, ["Mega"] = 28.33, ["Mega|Ride"] = 206.07}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 18.92, ["Fly|Ride"] = 59.07, ["Neon"] = 3.14, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 37.83, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 280.45}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 18.92, ["Fly|Ride"] = 60.38, ["Neon"] = 11.48, ["Neon|Fly"] = 46.44, ["Neon|Ride"] = 39.46, ["Neon|Fly|Ride"] = 69.65, ["Mega"] = 221.67, ["Mega|Ride"] = 182.78, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 36.75, ["Ride"] = 24.83, ["Fly|Ride"] = 136.58, ["Neon"] = 114.19, ["Neon|Ride"] = 140.78, ["Mega"] = 367.49, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 82.2, ["Ride"] = 99.75, ["Fly|Ride"] = 154.88, ["Neon"] = 297.92, ["Neon|Ride"] = 391.12, ["Neon|Fly|Ride"] = 555.86, ["Mega|Ride"] = 1539.79, ["Mega|Fly|Ride"] = 1435.82}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Fly|Ride"] = 131.25, ["Neon"] = 3.84, ["Neon|Ride"] = 63.04, ["Neon|Fly|Ride"] = 272.14, ["Mega"] = 59.28, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.05, ["Fly"] = 31.32, ["Ride"] = 18.88, ["Fly|Ride"] = 42, ["Neon"] = 3.62, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 38.07, ["Mega|Fly"] = 157.5, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 3.59, ["Ride"] = 26.25, ["Neon"] = 69.57, ["Neon|Ride"] = 149.19, ["Neon|Fly|Ride"] = 279.44, ["Mega"] = 611, ["Mega|Ride"] = 406.49, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 282.19, ["Ride"] = 550.44, ["Fly|Ride"] = 347.82, ["Neon|Ride"] = 1470.65, ["Neon|Fly|Ride"] = 911.8, ["Mega|Fly|Ride"] = 5261.83}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 26.25, ["Fly"] = 209.9, ["Ride"] = 48.51, ["Fly|Ride"] = 95.39, ["Neon"] = 262.5, ["Neon|Ride"] = 210.1, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 728.95, ["Mega|Fly|Ride"] = 736.32}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Fly"] = 28.38, ["Ride"] = 19.97, ["Fly|Ride"] = 53.41, ["Neon"] = 7.88, ["Neon|Ride"] = 40.89, ["Mega"] = 81.03, ["Mega|Ride"] = 111.46, ["Mega|Fly|Ride"] = 218.74}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.05, ["Fly"] = 210.1, ["Ride"] = 61.57, ["Fly|Ride"] = 142.7, ["Neon"] = 25.19, ["Mega"] = 211.32, ["Mega|Ride"] = 434.04}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 25.54, ["Fly"] = 256.33, ["Ride"] = 39.38, ["Fly|Ride"] = 73.12, ["Mega"] = 2520.8, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 783.56}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 76.56, ["Ride"] = 140.78, ["Fly|Ride"] = 98.81, ["Neon"] = 483.23, ["Neon|Ride"] = 385.53, ["Neon|Fly|Ride"] = 420.15, ["Mega"] = 3081.67, ["Mega|Fly"] = 2098.58, ["Mega|Fly|Ride"] = 2123.78}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 210, ["Fly"] = 350.87, ["Ride"] = 262.24, ["Fly|Ride"] = 341.7, ["Neon"] = 775.69, ["Neon|Ride"] = 981.14, ["Neon|Fly|Ride"] = 656.25, ["Mega|Fly|Ride"] = 3356.85}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 16.19, ["Ride"] = 59.07, ["Fly|Ride"] = 119.77, ["Neon"] = 107.23, ["Neon|Ride"] = 91.8, ["Neon|Fly|Ride"] = 232.15, ["Mega"] = 464.22, ["Mega|Ride"] = 361.57, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.05, ["Fly"] = 25.72, ["Ride"] = 13.13, ["Fly|Ride"] = 31.17, ["Neon"] = 9.16, ["Neon|Fly"] = 70.4, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 43.32, ["Mega"] = 61.69, ["Mega|Ride"] = 92.86, ["Mega|Fly|Ride"] = 153.36}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 4.44, ["Fly"] = 37.08, ["Ride"] = 16.05, ["Fly|Ride"] = 46.44, ["Neon"] = 23.56, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 98.76, ["Mega"] = 216.57, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 280.45}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 273.67, ["Ride"] = 328.13, ["Fly|Ride"] = 482.18, ["Neon|Ride"] = 1240.72, ["Neon|Fly|Ride"] = 1470.65, ["Mega|Fly|Ride"] = 6825.04}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 46.24, ["Neon"] = 5.1, ["Neon|Ride"] = 232.15, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 28.25, ["Mega|Ride"] = 155.52, ["Mega|Fly|Ride"] = 294.78}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 2.57, ["Fly"] = 52.5, ["Ride"] = 17.07, ["Fly|Ride"] = 59.05, ["Neon"] = 27.04, ["Neon|Ride"] = 35.7, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 268.93, ["Mega|Ride"] = 182.67, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 14.8, ["Ride"] = 42.03, ["Neon"] = 74.26, ["Neon|Ride"] = 280.49, ["Neon|Fly|Ride"] = 560.96, ["Mega"] = 497.87, ["Mega|Ride"] = 388.5, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 104.99, ["Fly"] = 279.44, ["Ride"] = 112.22, ["Fly|Ride"] = 118.13, ["Neon|Ride"] = 551.25, ["Neon|Fly|Ride"] = 490.71, ["Mega|Fly|Ride"] = 1638.53}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 14.44, ["Fly"] = 40.74, ["Ride"] = 20.93, ["Fly|Ride"] = 49.39, ["Neon"] = 85.32, ["Neon|Ride"] = 66.94, ["Neon|Fly|Ride"] = 143.26, ["Mega"] = 700.59, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.05, ["Fly"] = 52.5, ["Ride"] = 39.94, ["Fly|Ride"] = 104.01, ["Neon"] = 2.1, ["Neon|Ride"] = 70.4, ["Neon|Fly|Ride"] = 140.78, ["Mega"] = 20.19, ["Mega|Ride"] = 49.39, ["Mega|Fly|Ride"] = 420.15}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.12, ["Ride"] = 11.82, ["Fly|Ride"] = 84.05, ["Neon"] = 2.1, ["Neon|Fly"] = 31.36, ["Neon|Ride"] = 28.38, ["Neon|Fly|Ride"] = 69.04, ["Mega"] = 21.3, ["Mega|Fly"] = 85.89, ["Mega|Ride"] = 46.4, ["Mega|Fly|Ride"] = 106.02}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 4.12, ["Fly"] = 105.06, ["Ride"] = 45.82, ["Fly|Ride"] = 165.21, ["Neon"] = 15.74, ["Neon|Fly"] = 263.48, ["Neon|Ride"] = 54.92, ["Neon|Fly|Ride"] = 169.32, ["Mega"] = 116.82, ["Mega|Ride"] = 160.31, ["Mega|Fly|Ride"] = 232.32}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1181.25, ["Ride"] = 1350.13, ["Fly|Ride"] = 1388.63, ["Neon"] = 6722.92, ["Neon|Fly|Ride"] = 4053, ["Mega"] = 18065.63, ["Mega|Fly|Ride"] = 13636.88}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 448.88, ["Ride"] = 524.98, ["Fly|Ride"] = 511.27, ["Neon"] = 1309.77, ["Neon|Ride"] = 1993.89, ["Neon|Fly|Ride"] = 1931.79, ["Mega"] = 13926.28, ["Mega|Fly|Ride"] = 6090}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 260.54, ["Fly"] = 560.96, ["Ride"] = 298.97, ["Fly|Ride"] = 409, ["Neon"] = 590.63, ["Neon|Fly"] = 840.38, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 805.55, ["Mega|Fly|Ride"] = 2428.13}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 258.56, ["Ride"] = 326.82, ["Fly|Ride"] = 366.68, ["Neon"] = 721.87, ["Neon|Ride"] = 797.31, ["Neon|Fly|Ride"] = 853.13, ["Mega|Ride"] = 3675, ["Mega|Fly|Ride"] = 3010.25}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 28.38, ["Ride"] = 14.41, ["Fly|Ride"] = 35.73, ["Neon"] = 4.6, ["Neon|Ride"] = 43.1, ["Neon|Fly|Ride"] = 54.64, ["Mega"] = 51.11, ["Mega|Ride"] = 73.91, ["Mega|Fly|Ride"] = 140.76}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 274.32, ["Ride"] = 333.38, ["Fly|Ride"] = 487.36, ["Neon"] = 1207.12, ["Neon|Ride"] = 1116.87, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 3712.93, ["Mega|Ride"] = 3412.5, ["Mega|Fly|Ride"] = 3281.25}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.05, ["Fly"] = 183.75, ["Ride"] = 17.46, ["Neon"] = 7.43, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 254.63, ["Mega"] = 84, ["Mega|Ride"] = 129.84, ["Mega|Fly|Ride"] = 138.66}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.05, ["Fly"] = 19.94, ["Ride"] = 29.93, ["Fly|Ride"] = 49.88, ["Neon"] = 7.54, ["Neon|Ride"] = 62.69, ["Neon|Fly|Ride"] = 119.76, ["Mega|Ride"] = 133.41, ["Mega|Fly|Ride"] = 150.81}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 3.28, ["Neon|Ride"] = 28.88, ["Mega"] = 23.44, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 33.33, ["Ride"] = 67.25, ["Fly|Ride"] = 459.38, ["Neon"] = 273, ["Neon|Ride"] = 420, ["Mega"] = 2100.68, ["Mega|Ride"] = 897.75, ["Mega|Fly|Ride"] = 972.57}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 4.66, ["Fly"] = 65.61, ["Ride"] = 18.9, ["Neon"] = 32.82, ["Mega"] = 203.78, ["Mega|Ride"] = 317.22}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 45.94, ["Neon"] = 2.16, ["Neon|Fly"] = 45.19, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 140.63, ["Mega"] = 24.93, ["Mega|Ride"] = 155.52, ["Mega|Fly|Ride"] = 387.63}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 17.84, ["Ride"] = 18.38, ["Fly|Ride"] = 49.97, ["Neon"] = 6.55, ["Neon|Fly"] = 89.12, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 51.44, ["Mega|Fly"] = 197.3, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 2.97, ["Fly"] = 45.94, ["Ride"] = 30.49, ["Fly|Ride"] = 55.26, ["Neon"] = 27.33, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 262.4, ["Mega"] = 237.57, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 10.45, ["Ride"] = 24.66, ["Neon"] = 131.25, ["Mega"] = 464.22, ["Mega|Ride"] = 336.12, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Ride"] = 24.91, ["Fly|Ride"] = 87.94, ["Neon"] = 37.05, ["Neon|Ride"] = 80.07, ["Neon|Fly|Ride"] = 696.41, ["Mega"] = 238.44, ["Mega|Ride"] = 476.86}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 17.41, ["Fly|Ride"] = 56.74, ["Neon"] = 3.73, ["Neon|Ride"] = 25.23, ["Mega"] = 39.38, ["Mega|Ride"] = 124.95, ["Mega|Fly|Ride"] = 315.12}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 127.32, ["Fly"] = 196.88, ["Ride"] = 190.32, ["Fly|Ride"] = 242.82, ["Neon"] = 855.09, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 895, ["Neon|Fly|Ride"] = 771.05, ["Mega"] = 8402.63, ["Mega|Fly|Ride"] = 3502.86}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 18.32, ["Ride"] = 15.75, ["Fly|Ride"] = 32.81, ["Neon"] = 3.47, ["Neon|Fly"] = 56.74, ["Neon|Ride"] = 24.28, ["Neon|Fly|Ride"] = 69.34, ["Mega"] = 31.35, ["Mega|Ride"] = 70.86, ["Mega|Fly|Ride"] = 97.13}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 7.24, ["Ride"] = 69.57, ["Fly|Ride"] = 94.5, ["Neon"] = 56.74, ["Neon|Ride"] = 147.42, ["Neon|Fly|Ride"] = 309.91, ["Mega"] = 315, ["Mega|Ride"] = 304.61, ["Mega|Fly|Ride"] = 273.1}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 22.91, ["Ride"] = 114.58, ["Neon"] = 137.16, ["Neon|Ride"] = 308.76, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 696.32, ["Mega|Ride"] = 696.97, ["Mega|Fly|Ride"] = 812.97}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 161.44, ["Fly"] = 250.69, ["Ride"] = 196.85, ["Fly|Ride"] = 262.5, ["Neon"] = 716.63, ["Neon|Ride"] = 700.67, ["Neon|Fly|Ride"] = 940.06, ["Mega|Fly|Ride"] = 3150.99}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 15.75, ["Neon"] = 111.57, ["Mega"] = 327.48, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 700.59}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 23.56, ["Ride"] = 54.66, ["Fly|Ride"] = 629.24, ["Neon"] = 140.78, ["Neon|Ride"] = 630.29, ["Neon|Fly|Ride"] = 840.38, ["Mega"] = 602.9, ["Mega|Ride"] = 629.16, ["Mega|Fly|Ride"] = 1890.6}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1018.5, ["Fly"] = 1401.32, ["Ride"] = 1022.44, ["Fly|Ride"] = 1107.95, ["Neon|Ride"] = 6302.75, ["Neon|Fly|Ride"] = 4197.63, ["Mega|Fly|Ride"] = 19606.47}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 8.19, ["Fly"] = 43.32, ["Ride"] = 27.33, ["Fly|Ride"] = 62.68, ["Neon"] = 37.34, ["Neon|Fly"] = 111.57, ["Neon|Ride"] = 77.79, ["Neon|Fly|Ride"] = 155.52, ["Mega"] = 191.18, ["Mega|Fly"] = 560.89, ["Mega|Ride"] = 248.37, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 4.38, ["Fly"] = 52.5, ["Ride"] = 39.38, ["Neon"] = 38.07, ["Neon|Ride"] = 157.68, ["Neon|Fly|Ride"] = 144.74, ["Mega"] = 196.88, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 359.23}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 91.41, ["Neon"] = 8.16, ["Neon|Ride"] = 63.67, ["Neon|Fly|Ride"] = 309.91, ["Mega"] = 136.4, ["Mega|Ride"] = 190.32, ["Mega|Fly|Ride"] = 558.79}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 11.82, ["Ride"] = 33.66, ["Fly|Ride"] = 91.88, ["Neon"] = 65.87, ["Neon|Ride"] = 95.62, ["Neon|Fly|Ride"] = 155.47, ["Mega"] = 328.02, ["Mega|Ride"] = 332.07, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.05, ["Fly"] = 19.97, ["Ride"] = 13.57, ["Fly|Ride"] = 35.21, ["Neon"] = 16.16, ["Neon|Ride"] = 45.28, ["Neon|Fly|Ride"] = 54.55, ["Mega"] = 280.45, ["Mega|Ride"] = 120.11, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.05, ["Ride"] = 22.32, ["Neon"] = 6.34, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 60.94, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 94.98, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 140.76}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 186.38, ["Ride"] = 183.75, ["Fly|Ride"] = 476.93, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 1392.81, ["Mega|Fly|Ride"] = 3271.78}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.51, ["Ride"] = 27.2, ["Neon"] = 5.38, ["Neon|Fly"] = 77.79, ["Neon|Ride"] = 38.83, ["Neon|Fly|Ride"] = 123.96, ["Mega"] = 82.05, ["Mega|Ride"] = 119.76, ["Mega|Fly|Ride"] = 232.32}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.68, ["Fly"] = 408.19, ["Neon"] = 26.75, ["Mega"] = 210, ["Mega|Ride"] = 252.1}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.94, ["Fly"] = 81.61, ["Ride"] = 23.63, ["Neon"] = 7.02, ["Neon|Fly|Ride"] = 155.55, ["Mega"] = 97.11, ["Mega|Ride"] = 211.35, ["Mega|Fly|Ride"] = 385.49}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 128.6, ["Fly"] = 262.5, ["Ride"] = 144.38, ["Fly|Ride"] = 308.76, ["Neon"] = 393.75, ["Neon|Ride"] = 414.75, ["Neon|Fly|Ride"] = 558.31, ["Mega"] = 1890.6, ["Mega|Ride"] = 1680.54, ["Mega|Fly|Ride"] = 1655.34}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 26.25, ["Ride"] = 68.57, ["Fly|Ride"] = 109.27, ["Neon"] = 120.75, ["Neon|Fly"] = 232.15, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 525, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 654.36}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 17.69, ["Ride"] = 39.25, ["Neon"] = 103.26, ["Neon|Ride"] = 140.63, ["Neon|Fly|Ride"] = 167.94, ["Mega"] = 671.51, ["Mega|Ride"] = 526.89, ["Mega|Fly|Ride"] = 432.7}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.05, ["Ride"] = 31.34, ["Neon"] = 3.13, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 34.38, ["Mega"] = 31.44, ["Mega|Ride"] = 74.74}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 70.81, ["Fly"] = 91.88, ["Ride"] = 83.46, ["Fly|Ride"] = 140.51, ["Neon"] = 379.1, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 236.7, ["Neon|Fly|Ride"] = 315, ["Mega|Fly|Ride"] = 904.32}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.05, ["Ride"] = 19.94, ["Neon"] = 6.43, ["Neon|Ride"] = 36.78, ["Neon|Fly|Ride"] = 588, ["Mega"] = 60.88}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 15.67, ["Fly"] = 140.78, ["Ride"] = 29.43, ["Fly|Ride"] = 104.77, ["Neon"] = 47.25, ["Neon|Ride"] = 48.34, ["Neon|Fly|Ride"] = 119.76, ["Mega"] = 380.63, ["Mega|Ride"] = 393.74, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 45.94, ["Ride"] = 67.28, ["Fly|Ride"] = 131.25, ["Neon"] = 226.09, ["Neon|Ride"] = 280.69, ["Neon|Fly|Ride"] = 346.19, ["Mega|Ride"] = 1216.3, ["Mega|Fly|Ride"] = 971.25}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.05, ["Fly"] = 13.13, ["Ride"] = 15.73, ["Fly|Ride"] = 47.25, ["Neon"] = 2.1, ["Neon|Fly"] = 27.72, ["Neon|Ride"] = 17.05, ["Neon|Fly|Ride"] = 38.06, ["Mega"] = 20.9, ["Mega|Fly"] = 46.24, ["Mega|Ride"] = 31.53, ["Mega|Fly|Ride"] = 61.43}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.26, ["Ride"] = 28.35, ["Fly|Ride"] = 98.65, ["Neon"] = 13.99, ["Neon|Ride"] = 56.6, ["Neon|Fly|Ride"] = 111.46, ["Mega"] = 206.7, ["Mega|Ride"] = 176.8, ["Mega|Fly|Ride"] = 420.15}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 11.82, ["Ride"] = 39.56, ["Neon"] = 131.25, ["Neon|Ride"] = 155.54, ["Neon|Fly|Ride"] = 619.81, ["Mega"] = 700.59, ["Mega|Ride"] = 517.16, ["Mega|Fly|Ride"] = 628.68}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.05, ["Ride"] = 23.09, ["Neon"] = 2.5, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 22.05, ["Mega|Ride"] = 66.21, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 2.41, ["Fly"] = 210, ["Ride"] = 27.33, ["Fly|Ride"] = 98.44, ["Neon"] = 46.25, ["Neon|Ride"] = 86.73, ["Neon|Fly|Ride"] = 182.62, ["Mega"] = 630.21, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 419.1}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 12.57, ["Fly"] = 42.03, ["Ride"] = 26.97, ["Fly|Ride"] = 46.44, ["Neon"] = 112.22, ["Neon|Ride"] = 77.69, ["Neon|Fly|Ride"] = 328.13, ["Mega|Fly|Ride"] = 602.9}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.29, ["Ride"] = 23.18, ["Neon"] = 15.47, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 39.35, ["Mega"] = 149.62, ["Mega|Ride"] = 279.4, ["Mega|Fly|Ride"] = 276.25}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 13.1, ["Fly"] = 2100.93, ["Neon"] = 118.13, ["Neon|Ride"] = 209.68, ["Neon|Fly|Ride"] = 6189.07, ["Mega"] = 236.24, ["Mega|Ride"] = 519.92, ["Mega|Fly|Ride"] = 626.7}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 22.97, ["Fly|Ride"] = 126.46, ["Neon"] = 6.23, ["Neon|Ride"] = 39.38, ["Mega"] = 81.58, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 408.19, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Neon"] = 3.54, ["Neon|Ride"] = 28.38, ["Mega"] = 26.23, ["Mega|Ride"] = 125.01}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 30.43}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 30.75, ["Fly"] = 77.75, ["Ride"] = 59.11, ["Fly|Ride"] = 136.61, ["Neon"] = 224.81, ["Neon|Ride"] = 280.49, ["Neon|Fly|Ride"] = 525.25, ["Mega|Ride"] = 978.92, ["Mega|Fly|Ride"] = 794.06}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 140.6, ["Neon"] = 2.49, ["Mega"] = 18.36, ["Mega|Ride"] = 104, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 586.69, ["Ride"] = 590.63, ["Fly|Ride"] = 607.17, ["Neon"] = 4201.83, ["Neon|Ride"] = 2493.8, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 16805.24, ["Mega|Fly|Ride"] = 5881.85}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 4.6, ["Fly"] = 26.24, ["Ride"] = 40.69, ["Fly|Ride"] = 54.56, ["Neon"] = 30.19, ["Neon|Ride"] = 98.76, ["Neon|Fly|Ride"] = 560.96, ["Mega|Fly|Ride"] = 544.27}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.63, ["Fly"] = 91.88, ["Ride"] = 15.59, ["Fly|Ride"] = 46.44, ["Neon"] = 39.38, ["Neon|Ride"] = 35.47, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 140.86, ["Mega|Ride"] = 155.52, ["Mega|Fly|Ride"] = 251.05}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 8.95, ["Ride"] = 76.13, ["Fly|Ride"] = 155.49, ["Neon"] = 79.36, ["Neon|Ride"] = 140.78, ["Neon|Fly|Ride"] = 140.78, ["Mega"] = 1050.34, ["Mega|Fly|Ride"] = 727.67}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.49, ["Fly"] = 49.39, ["Ride"] = 31.5, ["Fly|Ride"] = 393.75, ["Neon"] = 140.59, ["Mega"] = 292.01, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 11.8, ["Ride"] = 60.38, ["Fly|Ride"] = 157.5, ["Neon"] = 35.73, ["Neon|Fly"] = 189.09, ["Neon|Ride"] = 140.78, ["Neon|Fly|Ride"] = 350.44, ["Mega"] = 397.19, ["Mega|Ride"] = 427.09, ["Mega|Fly|Ride"] = 517.79}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 4.99, ["Fly"] = 105, ["Ride"] = 25.35, ["Fly|Ride"] = 131.25, ["Neon"] = 14.13, ["Neon|Ride"] = 70.39, ["Neon|Fly|Ride"] = 185.72, ["Mega"] = 170.63, ["Mega|Fly"] = 485.27, ["Mega|Ride"] = 273.1, ["Mega|Fly|Ride"] = 350.82}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.05, ["Fly"] = 42.03, ["Ride"] = 17.07, ["Fly|Ride"] = 75.65, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 24.05, ["Neon|Fly|Ride"] = 60.1, ["Mega"] = 15.67, ["Mega|Fly"] = 77.77, ["Mega|Ride"] = 36.74, ["Mega|Fly|Ride"] = 65.63}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 4.97, ["Ride"] = 37.41, ["Fly|Ride"] = 56.74, ["Neon"] = 42.06, ["Neon|Fly"] = 387.68, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 123.96, ["Mega|Ride"] = 100.96, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 257.25, ["Ride"] = 285.53, ["Fly|Ride"] = 293.3, ["Neon"] = 1480.5, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1365, ["Mega"] = 5587.94, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 76.13, ["Ride"] = 145.64, ["Fly|Ride"] = 215.25, ["Neon"] = 420.19, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 590.63, ["Mega"] = 4201.33, ["Mega|Ride"] = 1995.63, ["Mega|Fly|Ride"] = 1675.9}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.05, ["Fly"] = 28.38, ["Ride"] = 24.94, ["Fly|Ride"] = 37.31, ["Neon"] = 12.42, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 23.23, ["Neon|Fly|Ride"] = 53.45, ["Mega"] = 62.68, ["Mega|Fly"] = 209.03, ["Mega|Ride"] = 91.4, ["Mega|Fly|Ride"] = 155.47}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 18.69, ["Ride"] = 12.53, ["Fly|Ride"] = 32.82, ["Neon"] = 5.24, ["Neon|Fly"] = 28.35, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 37.79, ["Mega"] = 79.64, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Ride"] = 18.93, ["Fly|Ride"] = 98.44, ["Neon"] = 13.13, ["Neon|Fly|Ride"] = 210.1, ["Mega"] = 131.25}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 217.88, ["Fly"] = 464.28, ["Ride"] = 255.94, ["Fly|Ride"] = 399.18, ["Neon"] = 918.75, ["Neon|Ride"] = 1260, ["Neon|Fly|Ride"] = 1401.16, ["Mega|Ride"] = 2801.24, ["Mega|Fly|Ride"] = 4338.92}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.49, ["Fly"] = 21, ["Ride"] = 15.28, ["Fly|Ride"] = 31.75, ["Neon"] = 15.69, ["Neon|Fly"] = 155.55, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 46.44, ["Mega"] = 155.59, ["Mega|Ride"] = 155.52, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 2.21, ["Ride"] = 18.88, ["Fly|Ride"] = 210.1, ["Neon"] = 12.74, ["Neon|Ride"] = 74.6, ["Neon|Fly|Ride"] = 224.81, ["Mega"] = 78.68, ["Mega|Ride"] = 203.43, ["Mega|Fly|Ride"] = 348.1}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 21.02, ["Neon"] = 3.84, ["Neon|Ride"] = 30.12, ["Mega"] = 63.04, ["Mega|Ride"] = 85.05}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 10.01, ["Fly"] = 54.74, ["Ride"] = 19.69, ["Fly|Ride"] = 45.94, ["Neon"] = 70.41, ["Neon|Fly"] = 112.42, ["Neon|Ride"] = 91.8, ["Neon|Fly|Ride"] = 230.99, ["Mega"] = 574.48, ["Mega|Ride"] = 360.28, ["Mega|Fly|Ride"] = 761.25}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 43.63, ["Ride"] = 65.24, ["Fly|Ride"] = 203.69, ["Neon"] = 143.07, ["Neon|Fly"] = 309.91, ["Neon|Ride"] = 178.33, ["Neon|Fly|Ride"] = 295.19, ["Mega"] = 473.2, ["Mega|Fly"] = 2205.7, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 497.44}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 19.66, ["Fly"] = 56.74, ["Ride"] = 31.63, ["Fly|Ride"] = 57.89, ["Neon"] = 105, ["Neon|Ride"] = 167.03, ["Neon|Fly|Ride"] = 219.19, ["Mega|Ride"] = 783.12, ["Mega|Fly|Ride"] = 686.94}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.05, ["Fly"] = 17.07, ["Ride"] = 18.9, ["Fly|Ride"] = 29.08, ["Neon"] = 2.1, ["Neon|Fly"] = 30.19, ["Neon|Ride"] = 19.85, ["Neon|Fly|Ride"] = 48.35, ["Mega"] = 17.72, ["Mega|Ride"] = 35.99, ["Mega|Fly|Ride"] = 107.33}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 184.69, ["Fly"] = 236.25, ["Ride"] = 192.61, ["Fly|Ride"] = 295.32, ["Neon|Ride"] = 912.87, ["Neon|Fly|Ride"] = 1092.49, ["Mega|Fly|Ride"] = 3403.08}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 5.4, ["Fly"] = 65.63, ["Ride"] = 45.94, ["Fly|Ride"] = 112.42, ["Neon"] = 112.17, ["Neon|Ride"] = 116.08, ["Mega"] = 315, ["Mega|Ride"] = 432.75, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.05, ["Ride"] = 15.74, ["Fly|Ride"] = 59.07, ["Neon"] = 3.94, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 61.68, ["Mega|Fly"] = 111.57, ["Mega|Ride"] = 67.24, ["Mega|Fly|Ride"] = 258.39}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.05, ["Fly"] = 140.78, ["Ride"] = 28.38, ["Fly|Ride"] = 42.03, ["Neon"] = 3.93, ["Neon|Fly"] = 31.36, ["Neon|Ride"] = 17.21, ["Neon|Fly|Ride"] = 97.02, ["Mega"] = 21, ["Mega|Fly"] = 137.61, ["Mega|Ride"] = 45.19, ["Mega|Fly|Ride"] = 108.83}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.05, ["Fly"] = 21.02, ["Ride"] = 22.53, ["Fly|Ride"] = 140.78, ["Neon"] = 15.73, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 116.7, ["Mega|Ride"] = 128.62, ["Mega|Fly|Ride"] = 420.15}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 10.47, ["Fly"] = 32.27, ["Ride"] = 23.49, ["Fly|Ride"] = 46.52, ["Neon"] = 42.26, ["Neon|Ride"] = 56.69, ["Neon|Fly|Ride"] = 140.76, ["Mega"] = 378.14, ["Mega|Ride"] = 338.39, ["Mega|Fly|Ride"] = 381.94}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 8.93, ["Ride"] = 39.38, ["Neon"] = 21, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 210, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 356.08}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 21.02, ["Neon"] = 2.63, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 19.36, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 235.52}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 15.75, ["Ride"] = 28.38, ["Fly|Ride"] = 94.5, ["Neon"] = 26.25, ["Neon|Fly"] = 102.92, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 119.68, ["Mega"] = 106.36, ["Mega|Ride"] = 168.07, ["Mega|Fly|Ride"] = 387.63}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.05, ["Ride"] = 15.75, ["Neon"] = 6.28, ["Neon|Ride"] = 91.83, ["Mega"] = 22.47, ["Mega|Ride"] = 56.68, ["Mega|Fly|Ride"] = 615.9}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.05, ["Fly"] = 40.05, ["Ride"] = 15.74, ["Fly|Ride"] = 114.59, ["Neon"] = 4.15, ["Neon|Ride"] = 27.87, ["Neon|Fly|Ride"] = 113.47, ["Mega"] = 56.43, ["Mega|Ride"] = 88.1, ["Mega|Fly|Ride"] = 195.8}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 1115.63, ["Ride"] = 853.13, ["Fly|Ride"] = 1392.81, ["Neon|Fly|Ride"] = 4484.48, ["Mega|Fly|Ride"] = 13771.93}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 18.9, ["Ride"] = 12.58, ["Fly|Ride"] = 42.03, ["Neon"] = 17.42, ["Neon|Fly"] = 28.87, ["Neon|Ride"] = 28.38, ["Neon|Fly|Ride"] = 56.74, ["Mega|Fly|Ride"] = 149.63}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 59.07, ["Neon"] = 4.22, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 140.76, ["Mega"] = 63, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 214.45}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 8.77, ["Fly"] = 23.63, ["Ride"] = 19.69, ["Fly|Ride"] = 33.07, ["Neon"] = 140.78, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 104.94, ["Mega|Ride"] = 832.13, ["Mega|Fly|Ride"] = 342.48}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.05, ["Fly"] = 40.98, ["Ride"] = 16.82, ["Fly|Ride"] = 32.58, ["Neon"] = 5.93, ["Neon|Fly"] = 74.79, ["Neon|Ride"] = 18.04, ["Neon|Fly|Ride"] = 59.84, ["Mega"] = 68.16, ["Mega|Ride"] = 337.73, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 51.77, ["Ride"] = 91.88, ["Neon"] = 254.28, ["Neon|Ride"] = 338.63, ["Mega"] = 769.13, ["Mega|Ride"] = 981.85}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 28.38, ["Ride"] = 21.63, ["Fly|Ride"] = 62.87, ["Neon"] = 4.22, ["Neon|Ride"] = 27.78, ["Mega"] = 78.02, ["Mega|Ride"] = 103.22, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 73.5, ["Ride"] = 20.08, ["Fly|Ride"] = 65.63, ["Neon"] = 9.87, ["Neon|Fly"] = 147.08, ["Neon|Ride"] = 35.21, ["Neon|Fly|Ride"] = 140.76, ["Mega"] = 131.23, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 65.63, ["Neon"] = 17.07, ["Neon|Fly"] = 62.69, ["Mega"] = 111.36}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 13.94, ["Fly|Ride"] = 40.98, ["Neon"] = 3.92, ["Neon|Ride"] = 19.81, ["Neon|Fly|Ride"] = 84.04, ["Mega"] = 36.63, ["Mega|Fly"] = 108.94, ["Mega|Ride"] = 56.02, ["Mega|Fly|Ride"] = 139.3}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 23.63, ["Fly"] = 35.67, ["Ride"] = 15.52, ["Fly|Ride"] = 37.14, ["Neon|Ride"] = 119.77, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 840.28, ["Mega|Ride"] = 519.92, ["Mega|Fly|Ride"] = 449.69}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 656.14, ["Ride"] = 679.88, ["Fly|Ride"] = 774.38, ["Neon"] = 2015.99, ["Neon|Ride"] = 1837.5, ["Neon|Fly|Ride"] = 2079, ["Mega"] = 7002.54, ["Mega|Ride"] = 7703.11, ["Mega|Fly|Ride"] = 4851.4}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.05, ["Fly"] = 56.74, ["Ride"] = 16.53, ["Fly|Ride"] = 40.93, ["Neon"] = 4.41, ["Neon|Fly"] = 28.35, ["Neon|Ride"] = 21.02, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 31.29, ["Mega|Ride"] = 56.02, ["Mega|Fly|Ride"] = 135.48}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 4.65, ["Ride"] = 53.59, ["Fly|Ride"] = 116.82, ["Neon"] = 21, ["Neon|Ride"] = 125.99, ["Neon|Fly|Ride"] = 210.1, ["Mega"] = 157.5, ["Mega|Ride"] = 266.94, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 65.63, ["Ride"] = 78.52, ["Fly|Ride"] = 207.96, ["Neon"] = 373.97, ["Neon|Ride"] = 418.49, ["Neon|Fly|Ride"] = 511.87, ["Mega"] = 2940.78, ["Mega|Fly|Ride"] = 1830.73}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 28.85, ["Ride"] = 90.57, ["Fly|Ride"] = 196.88, ["Neon"] = 189.09, ["Neon|Ride"] = 105, ["Mega"] = 700.59, ["Mega|Ride"] = 655.41, ["Mega|Fly|Ride"] = 846.67}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 10, ["Ride"] = 36.74, ["Fly|Ride"] = 210.1, ["Neon"] = 99.53, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 237.39, ["Mega"] = 420.15, ["Mega|Ride"] = 420.2, ["Mega|Fly|Ride"] = 474.76}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 23.42, ["Fly"] = 112.42, ["Ride"] = 108.98, ["Neon"] = 121.87, ["Neon|Ride"] = 356.34, ["Mega"] = 309.88, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 538.79}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 14.37, ["Ride"] = 39.38, ["Neon"] = 164.83, ["Neon|Ride"] = 315.15, ["Neon|Fly|Ride"] = 525, ["Mega"] = 656.15, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 769.79}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 4.9}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 3.15, ["Fly"] = 28.38, ["Ride"] = 28.88, ["Fly|Ride"] = 59.07, ["Neon"] = 31.08, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 70.39, ["Neon|Fly|Ride"] = 140.78, ["Mega"] = 244.6, ["Mega|Ride"] = 210.08, ["Mega|Fly|Ride"] = 237.77}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.18, ["Ride"] = 96.93, ["Neon"] = 15.74, ["Mega"] = 367.5, ["Mega|Fly|Ride"] = 945.31}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 62.99, ["Fly"] = 419.14, ["Ride"] = 59.07, ["Fly|Ride"] = 105, ["Neon"] = 294.14, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 704.66, ["Mega|Ride"] = 628.69, ["Mega|Fly|Ride"] = 628.69}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 2.3, ["Fly"] = 18.38, ["Ride"] = 14.55, ["Fly|Ride"] = 34.13, ["Neon"] = 28.38, ["Neon|Fly"] = 41.88, ["Neon|Ride"] = 28.33, ["Neon|Fly|Ride"] = 50.7, ["Mega"] = 328.13, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 249.66}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 6.17, ["Ride"] = 26.25, ["Fly|Ride"] = 83.94, ["Neon"] = 13.39, ["Neon|Fly"] = 2321.34, ["Neon|Ride"] = 36.63, ["Neon|Fly|Ride"] = 99.58, ["Mega"] = 120.68, ["Mega|Fly"] = 301.45, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 257.65}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 3.29, ["Neon|Ride"] = 198.49, ["Mega"] = 42.06}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 32.82, ["Fly"] = 84.05, ["Ride"] = 39.69, ["Fly|Ride"] = 73.34, ["Neon"] = 139.08, ["Neon|Ride"] = 107.91, ["Neon|Fly|Ride"] = 280.88, ["Mega"] = 1083.95, ["Mega|Ride"] = 752.06, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.05, ["Ride"] = 14.44, ["Neon"] = 11.47, ["Neon|Fly"] = 145.69, ["Neon|Fly|Ride"] = 140.76, ["Mega"] = 105, ["Mega|Ride"] = 208.11}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 5.59, ["Ride"] = 140.63, ["Neon"] = 52.48, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 280.49, ["Mega"] = 262.5, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1083.95}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 23.61, ["Ride"] = 15.74, ["Fly|Ride"] = 61.69, ["Neon"] = 12.59, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 81.25, ["Mega|Ride"] = 92.45, ["Mega|Fly|Ride"] = 279.4}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 6.56, ["Fly"] = 52.5, ["Ride"] = 23.61, ["Neon"] = 91.88, ["Neon|Ride"] = 126.07, ["Mega"] = 309.88, ["Mega|Ride"] = 140.76, ["Mega|Fly|Ride"] = 417.38}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.62, ["Ride"] = 129.31, ["Neon"] = 23.63, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 210.08, ["Mega"] = 197.25, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 314.07}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 26.97, ["Fly"] = 118.13, ["Ride"] = 73.84, ["Neon"] = 163.34, ["Neon|Ride"] = 364.52, ["Mega"] = 918.75, ["Mega|Ride"] = 1260.41, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 18.25, ["Ride"] = 139.3, ["Neon"] = 110.98, ["Neon|Fly|Ride"] = 387.68, ["Mega"] = 322.19, ["Mega|Ride"] = 769.12}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 7.86, ["Ride"] = 105, ["Neon"] = 49.46, ["Mega"] = 430.57, ["Mega|Ride"] = 1549.32, ["Mega|Fly|Ride"] = 1680.54}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 13.69, ["Ride"] = 105, ["Fly|Ride"] = 393.75, ["Neon"] = 52.5, ["Neon|Fly|Ride"] = 280.49, ["Mega"] = 519.75, ["Mega|Ride"] = 560.89, ["Mega|Fly|Ride"] = 916.95}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.92, ["Neon"] = 43.32, ["Mega"] = 840.28, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 24.92, ["Ride"] = 20.37, ["Fly|Ride"] = 52.5, ["Neon"] = 3.87, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 35.73, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 31.14, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 182.78}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 6.36, ["Ride"] = 32.82, ["Fly|Ride"] = 105.06, ["Neon"] = 31.29, ["Neon|Fly"] = 464.28, ["Neon|Ride"] = 110.15, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 114.6, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 464.22}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 28.38, ["Ride"] = 14.21, ["Fly|Ride"] = 32.27, ["Neon"] = 5.29, ["Neon|Fly"] = 32.58, ["Neon|Ride"] = 25.3, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 42.37, ["Mega|Ride"] = 92.45, ["Mega|Fly|Ride"] = 196.35}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 59.07, ["Ride"] = 23.23, ["Fly|Ride"] = 78.75, ["Neon"] = 15.74, ["Neon|Ride"] = 92.87, ["Neon|Fly|Ride"] = 260.49, ["Mega"] = 189.05, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 464.22}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 6.29, ["Ride"] = 27.57, ["Fly|Ride"] = 99.75, ["Neon|Ride"] = 133.43, ["Mega"] = 420.15, ["Mega|Fly|Ride"] = 978.92}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 2.46, ["Fly"] = 30.16, ["Ride"] = 22.32, ["Fly|Ride"] = 53.82, ["Neon"] = 16.28, ["Neon|Ride"] = 33.49, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 238.28, ["Mega|Ride"] = 173.25, ["Mega|Fly|Ride"] = 294.78}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 33.72, ["Ride"] = 15.74, ["Fly|Ride"] = 59.89, ["Neon"] = 20.94, ["Neon|Ride"] = 82.42, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 166.58, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 490.52}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 4.19, ["Fly"] = 918.75, ["Ride"] = 66.15, ["Neon"] = 7.86, ["Neon|Fly"] = 42, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 458.48, ["Mega"] = 147.94, ["Mega|Ride"] = 305.82, ["Mega|Fly|Ride"] = 290.07}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 11.57, ["Ride"] = 60.94, ["Fly|Ride"] = 279.44, ["Neon"] = 73.5, ["Neon|Ride"] = 115.86, ["Neon|Fly|Ride"] = 350.82, ["Mega"] = 255.94, ["Mega|Fly"] = 981.02, ["Mega|Ride"] = 367.15, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 54.87, ["Fly"] = 185.72, ["Ride"] = 92.27, ["Fly|Ride"] = 91.88, ["Neon"] = 210.1, ["Neon|Ride"] = 278.24, ["Neon|Fly|Ride"] = 371.42, ["Mega"] = 2520.8, ["Mega|Ride"] = 997.5, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Ride"] = 19.92, ["Fly|Ride"] = 65.63, ["Neon"] = 3.4, ["Neon|Ride"] = 17.41, ["Mega"] = 20.41, ["Mega|Ride"] = 69.57, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 4.59, ["Ride"] = 131.25, ["Neon"] = 49.51, ["Mega"] = 312.38, ["Mega|Ride"] = 406.49, ["Mega|Fly|Ride"] = 840.28}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 51.66, ["Ride"] = 56.74, ["Neon"] = 212.63, ["Neon|Ride"] = 337.77, ["Neon|Fly|Ride"] = 1050.48, ["Mega|Fly|Ride"] = 1243.6}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 6.55, ["Fly"] = 190.32, ["Ride"] = 19.83, ["Fly|Ride"] = 125.89, ["Neon"] = 27.44, ["Neon|Ride"] = 56.74, ["Neon|Fly|Ride"] = 140.78, ["Mega"] = 156.19, ["Mega|Ride"] = 178.74, ["Mega|Fly|Ride"] = 313.02}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Fly"] = 157.5, ["Ride"] = 55.9, ["Fly|Ride"] = 79.41, ["Neon"] = 2.61, ["Neon|Ride"] = 26.17, ["Mega"] = 15.73, ["Mega|Fly"] = 105.05, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 122.33}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.63, ["Fly"] = 24.94, ["Ride"] = 14, ["Fly|Ride"] = 34.05, ["Neon"] = 13.07, ["Neon|Fly"] = 26.71, ["Neon|Ride"] = 34.85, ["Neon|Fly|Ride"] = 75.63, ["Mega"] = 133.41, ["Mega|Ride"] = 155.52, ["Mega|Fly|Ride"] = 189.53}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.05, ["Fly"] = 15.74, ["Ride"] = 18.54, ["Neon"] = 2.63, ["Neon|Ride"] = 25.93, ["Neon|Fly|Ride"] = 87.28, ["Mega"] = 82.41, ["Mega|Ride"] = 69.55, ["Mega|Fly|Ride"] = 124.19}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 15.77, ["Fly|Ride"] = 91.41, ["Neon"] = 3.94, ["Neon|Fly"] = 56.74, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 52.54, ["Mega"] = 31.49, ["Mega|Fly"] = 168, ["Mega|Ride"] = 61.69, ["Mega|Fly|Ride"] = 98.75}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Mega"] = 16.28, ["Mega|Ride"] = 105.05, ["Mega|Fly|Ride"] = 255.94}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 5.16, ["Ride"] = 157.5, ["Fly|Ride"] = 357.17, ["Neon"] = 24.65, ["Neon|Fly"] = 140.78, ["Neon|Ride"] = 40.63, ["Neon|Fly|Ride"] = 77.79, ["Mega"] = 207.38, ["Mega|Ride"] = 294.11, ["Mega|Fly|Ride"] = 705.48}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 7.45, ["Ride"] = 26.25, ["Fly|Ride"] = 84.05, ["Neon"] = 74.82, ["Neon|Ride"] = 136.6, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 369.73, ["Mega|Ride"] = 336.15, ["Mega|Fly|Ride"] = 364.88}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 6.57, ["Fly"] = 18.38, ["Ride"] = 16.21, ["Fly|Ride"] = 37.43, ["Neon"] = 26.25, ["Neon|Fly"] = 105.63, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 98.84, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 52.5, ["Ride"] = 98.76, ["Fly|Ride"] = 262.49, ["Neon"] = 538.13, ["Neon|Ride"] = 525.25, ["Mega"] = 3095.13, ["Mega|Ride"] = 1995.63}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 10.47, ["Ride"] = 39.9, ["Neon"] = 140.6, ["Neon|Fly"] = 126.07, ["Mega"] = 607.03, ["Mega|Fly"] = 644.91, ["Mega|Ride"] = 577.5, ["Mega|Fly|Ride"] = 1020.48}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.05, ["Fly"] = 20.9, ["Ride"] = 14.44, ["Fly|Ride"] = 26.25, ["Neon"] = 2.49, ["Neon|Fly"] = 42.03, ["Neon|Ride"] = 14.9, ["Neon|Fly|Ride"] = 45.68, ["Mega"] = 28.25, ["Mega|Ride"] = 105.05, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.05, ["Fly"] = 15.43, ["Ride"] = 13.13, ["Fly|Ride"] = 23.09, ["Neon"] = 2.63, ["Neon|Fly"] = 26.24, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 41.97, ["Mega"] = 39.34, ["Mega|Ride"] = 54.51, ["Mega|Fly|Ride"] = 98.6}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 367.38, ["Ride"] = 480.83, ["Fly|Ride"] = 524.99, ["Neon|Fly|Ride"] = 1996.32}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 7.03, ["Ride"] = 42, ["Fly|Ride"] = 72.19, ["Neon"] = 44.63, ["Neon|Ride"] = 280.49, ["Mega"] = 674.33, ["Mega|Fly|Ride"] = 1260.41}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.05, ["Fly"] = 28.38, ["Ride"] = 17.07, ["Fly|Ride"] = 26.25, ["Neon"] = 2.63, ["Neon|Ride"] = 13.12, ["Neon|Fly|Ride"] = 39.32, ["Mega"] = 75.99, ["Mega|Ride"] = 63.04, ["Mega|Fly|Ride"] = 92.82}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 59.76, ["Ride"] = 110.67, ["Fly|Ride"] = 270.93, ["Neon"] = 155.48, ["Neon|Ride"] = 292.62, ["Neon|Fly|Ride"] = 658.65, ["Mega"] = 881.53, ["Mega|Ride"] = 708.75, ["Mega|Fly|Ride"] = 987}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 18.92, ["Ride"] = 13.13, ["Fly|Ride"] = 39.8, ["Neon"] = 4.59, ["Neon|Fly"] = 69.35, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 87.26, ["Mega|Fly"] = 168.09, ["Mega|Ride"] = 97.76, ["Mega|Fly|Ride"] = 182.44}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Ride"] = 37.13, ["Fly|Ride"] = 1312.5, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 38.41, ["Neon|Fly|Ride"] = 279.36, ["Mega"] = 15.18, ["Mega|Fly"] = 98.75, ["Mega|Ride"] = 56.39, ["Mega|Fly|Ride"] = 157.49}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 46.87, ["Fly"] = 164.07, ["Ride"] = 82.29, ["Neon"] = 174.5, ["Neon|Fly"] = 452.76, ["Neon|Ride"] = 232.15, ["Neon|Fly|Ride"] = 314.9, ["Mega"] = 658.56, ["Mega|Ride"] = 756.26, ["Mega|Fly|Ride"] = 733.78}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 42.03, ["Neon"] = 6.13, ["Neon|Ride"] = 54.59, ["Mega"] = 62.67, ["Mega|Ride"] = 92.86, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 30.08, ["Fly"] = 140.78, ["Ride"] = 56.44, ["Fly|Ride"] = 208, ["Neon"] = 398.29, ["Neon|Ride"] = 402.77, ["Neon|Fly|Ride"] = 249.38, ["Mega|Ride"] = 1680.54, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.03, ["Ride"] = 114.8, ["Neon"] = 45.75, ["Neon|Ride"] = 66.94, ["Mega"] = 164.07, ["Mega|Ride"] = 532.53, ["Mega|Fly|Ride"] = 396.58}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 70.4, ["Ride"] = 18.92, ["Neon"] = 11.49, ["Neon|Ride"] = 171.84, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 138.02, ["Mega|Ride"] = 569.63, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 14.36, ["Ride"] = 32.82, ["Neon"] = 399.29, ["Mega"] = 2100.68, ["Mega|Ride"] = 2611.88, ["Mega|Fly|Ride"] = 1238.29}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 104.71, ["Ride"] = 37.83, ["Neon"] = 5.1, ["Neon|Ride"] = 29.9, ["Neon|Fly|Ride"] = 127.77, ["Mega"] = 34.8, ["Mega|Fly"] = 158.61, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 270.25}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.05, ["Fly"] = 26.78, ["Ride"] = 23.08, ["Fly|Ride"] = 72.17, ["Neon"] = 6.7, ["Neon|Fly"] = 41.88, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 84.05, ["Mega"] = 196.42, ["Mega|Ride"] = 70.39, ["Mega|Fly|Ride"] = 281.54}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 5.9, ["Ride"] = 19.98, ["Neon"] = 65.63, ["Neon|Ride"] = 82.25, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 840.28, ["Mega|Ride"] = 442.73, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 26.25, ["Fly"] = 98.76, ["Ride"] = 44.63, ["Fly|Ride"] = 99.83, ["Neon"] = 134.82, ["Neon|Ride"] = 158.94, ["Neon|Fly|Ride"] = 277.71, ["Mega"] = 502.63, ["Mega|Ride"] = 619.74, ["Mega|Fly|Ride"] = 696.32}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 23.62, ["Fly"] = 58.06, ["Ride"] = 32.82, ["Fly|Ride"] = 59.07, ["Neon"] = 86.19, ["Neon|Ride"] = 98.76, ["Neon|Fly|Ride"] = 231.94, ["Mega"] = 407.54, ["Mega|Ride"] = 399.14, ["Mega|Fly|Ride"] = 414.75}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 64.32, ["Fly"] = 196.88, ["Ride"] = 100.85, ["Fly|Ride"] = 210.1, ["Neon"] = 284.82, ["Neon|Fly"] = 482.74, ["Neon|Ride"] = 371.44, ["Neon|Fly|Ride"] = 476.93, ["Mega"] = 1260, ["Mega|Ride"] = 1302, ["Mega|Fly|Ride"] = 1216.17}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.29, ["Ride"] = 23.62, ["Fly|Ride"] = 262.5, ["Neon"] = 17.07, ["Neon|Ride"] = 140.78, ["Neon|Fly|Ride"] = 315.14, ["Mega"] = 138.66, ["Mega|Ride"] = 155.49, ["Mega|Fly|Ride"] = 345.85}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.94, ["Ride"] = 24.99, ["Fly|Ride"] = 118.13, ["Neon"] = 30.09, ["Neon|Ride"] = 69.28, ["Neon|Fly|Ride"] = 140.76, ["Mega"] = 140.8, ["Mega|Ride"] = 114.19}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 9.08, ["Fly"] = 65.63, ["Ride"] = 37.83, ["Fly|Ride"] = 157.5, ["Neon"] = 38.8, ["Neon|Ride"] = 126.05, ["Mega"] = 446.25, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 445.82}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.05, ["Fly"] = 15.75, ["Ride"] = 15.74, ["Fly|Ride"] = 36.74, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 16.09, ["Neon|Fly|Ride"] = 61.67, ["Mega"] = 17.42, ["Mega|Fly"] = 77.77, ["Mega|Ride"] = 19.99, ["Mega|Fly|Ride"] = 98.75}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 62.39, ["Fly"] = 140.78, ["Ride"] = 112.42, ["Fly|Ride"] = 280.49, ["Neon"] = 336.16, ["Neon|Fly"] = 2381.39, ["Neon|Ride"] = 294, ["Mega"] = 833.97, ["Mega|Ride"] = 925.35, ["Mega|Fly|Ride"] = 885.94}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Fly"] = 21.02, ["Ride"] = 15.77, ["Fly|Ride"] = 89.25, ["Neon"] = 6.5, ["Neon|Ride"] = 52.5, ["Mega"] = 84.84, ["Mega|Fly"] = 112.41, ["Mega|Ride"] = 92.76, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.38, ["Ride"] = 15.74, ["Fly|Ride"] = 63.04, ["Neon"] = 13.37, ["Neon|Ride"] = 37.83, ["Neon|Fly|Ride"] = 98.76, ["Mega|Ride"] = 420.15, ["Mega|Fly|Ride"] = 626.73}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 62.4, ["Fly"] = 210.1, ["Ride"] = 111.57, ["Fly|Ride"] = 232.32, ["Neon"] = 262.5, ["Neon|Ride"] = 314.45, ["Neon|Fly|Ride"] = 361.05, ["Mega"] = 931.88, ["Mega|Ride"] = 892.5, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 28.38, ["Neon"] = 4.72, ["Neon|Ride"] = 1399.95, ["Neon|Fly|Ride"] = 105.65, ["Mega"] = 33.12, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 11.73}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.05, ["Ride"] = 28.38, ["Fly|Ride"] = 209.32, ["Neon"] = 6.32, ["Neon|Ride"] = 31.35, ["Neon|Fly|Ride"] = 126.06, ["Mega"] = 36.71, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 162.65}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 112.65, ["Ride"] = 170.63, ["Fly|Ride"] = 249.38, ["Neon"] = 504, ["Neon|Ride"] = 599.82, ["Neon|Fly|Ride"] = 735, ["Mega"] = 2241.42, ["Mega|Ride"] = 2812.8, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.75, ["Ride"] = 25.23, ["Neon"] = 118.13, ["Neon|Ride"] = 61.69, ["Mega"] = 185.3, ["Mega|Ride"] = 295.95, ["Mega|Fly|Ride"] = 232.12}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 210.1, ["Neon"] = 5.25, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 33.63, ["Mega|Ride"] = 77.74, ["Mega|Fly|Ride"] = 260.49}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 3.68, ["Ride"] = 35.44, ["Neon"] = 21.41, ["Neon|Ride"] = 125.02, ["Neon|Fly|Ride"] = 154.88, ["Mega"] = 853.13, ["Mega|Ride"] = 630.21, ["Mega|Fly|Ride"] = 619.74}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 10.5, ["Fly"] = 74.6, ["Ride"] = 24.68, ["Fly|Ride"] = 32.82, ["Neon"] = 63, ["Neon|Fly|Ride"] = 271.03, ["Mega"] = 453.48, ["Mega|Ride"] = 616.55, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 23.78, ["Ride"] = 59.06, ["Neon"] = 128.63, ["Neon|Ride"] = 157.74, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 538.13, ["Mega|Ride"] = 587.43, ["Mega|Fly|Ride"] = 577.49}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 129.89, ["Fly"] = 229.78, ["Ride"] = 154.87, ["Fly|Ride"] = 183.75, ["Neon"] = 620.46, ["Neon|Ride"] = 548.63, ["Neon|Fly|Ride"] = 577.5, ["Mega|Fly|Ride"] = 2661.54}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 6.22, ["Fly"] = 14.99, ["Ride"] = 13.13, ["Fly|Ride"] = 26.24, ["Neon"] = 39.82, ["Neon|Ride"] = 37.28, ["Neon|Fly|Ride"] = 60.88, ["Mega|Ride"] = 420.15, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 23.59, ["Neon"] = 10.85, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 140.76, ["Mega|Ride"] = 132.56, ["Mega|Fly|Ride"] = 238.24}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 8.58, ["Fly"] = 36.66, ["Ride"] = 53.76, ["Fly|Ride"] = 168.09, ["Neon"] = 76.06, ["Neon|Ride"] = 91.87, ["Mega"] = 1266.71, ["Mega|Fly|Ride"] = 683.79}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 31.97, ["Ride"] = 59.15, ["Fly|Ride"] = 124.69, ["Neon"] = 167.13, ["Neon|Ride"] = 190.36, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 630, ["Mega|Fly"] = 981.02, ["Mega|Ride"] = 742.88, ["Mega|Fly|Ride"] = 869.25}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 12.69, ["Fly"] = 65.63, ["Ride"] = 76.23, ["Neon"] = 131.25, ["Neon|Ride"] = 105.05, ["Mega"] = 551.24, ["Mega|Ride"] = 644.91, ["Mega|Fly|Ride"] = 731.73}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 195.41, ["Ride"] = 367.5, ["Fly|Ride"] = 459.38, ["Neon"] = 1193.33, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1233.25, ["Mega|Ride"] = 3937.5, ["Mega|Fly|Ride"] = 5667.58}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 20.93, ["Fly"] = 140.78, ["Ride"] = 36.75, ["Fly|Ride"] = 70.4, ["Neon"] = 232.15, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 210.1, ["Mega"] = 1195.69, ["Mega|Ride"] = 520.25, ["Mega|Fly|Ride"] = 616.2}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.05, ["Fly"] = 16.69, ["Ride"] = 14, ["Fly|Ride"] = 42, ["Neon"] = 2.63, ["Neon|Ride"] = 17.05, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 23, ["Mega|Ride"] = 37.14, ["Mega|Fly|Ride"] = 108.74}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Ride"] = 56.44, ["Neon"] = 6.56, ["Neon|Ride"] = 39.25, ["Mega"] = 78.84, ["Mega|Ride"] = 104.9, ["Mega|Fly|Ride"] = 461.35}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.08, ["Ride"] = 62.98, ["Fly|Ride"] = 40.8, ["Neon"] = 11.87, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 1181.25, ["Mega"] = 83.99, ["Mega|Fly"] = 301.46, ["Mega|Ride"] = 280.45, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 316.32, ["Fly"] = 393.75, ["Ride"] = 377.99, ["Fly|Ride"] = 397.76, ["Neon"] = 1365.6, ["Neon|Ride"] = 1702.71, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 5034.75}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.05, ["Fly"] = 70.4, ["Ride"] = 12.78, ["Fly|Ride"] = 42.03, ["Neon"] = 31.14, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 52.5, ["Mega|Fly|Ride"] = 460.05}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 3.92, ["Fly"] = 18.84, ["Ride"] = 16.06, ["Fly|Ride"] = 56.74, ["Neon"] = 46.44, ["Neon|Fly"] = 109.12, ["Neon|Ride"] = 42.03, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 418.04, ["Mega|Ride"] = 700.59, ["Mega|Fly|Ride"] = 224.44}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 2.3, ["Fly"] = 26.25, ["Ride"] = 22.44, ["Fly|Ride"] = 104.47, ["Neon"] = 10.49, ["Neon|Fly"] = 70.4, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 104.01, ["Mega"] = 137.82, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 274.32}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 30.19, ["Fly"] = 42.03, ["Ride"] = 40.2, ["Fly|Ride"] = 70.4, ["Neon"] = 91.88, ["Neon|Fly|Ride"] = 147.08, ["Mega"] = 945.31, ["Mega|Ride"] = 838.17, ["Mega|Fly|Ride"] = 613.4}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 315, ["Ride"] = 62.98, ["Fly|Ride"] = 42, ["Neon"] = 14.15, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 210, ["Mega"] = 106.79, ["Mega|Fly"] = 262.5, ["Mega|Fly|Ride"] = 596.54}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 2.63, ["Fly"] = 23.12, ["Ride"] = 26.25, ["Fly|Ride"] = 52.5, ["Neon"] = 309.91, ["Neon|Ride"] = 132.69, ["Mega"] = 700.59, ["Mega|Ride"] = 321.41, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Fly"] = 28.38, ["Ride"] = 26.25, ["Fly|Ride"] = 56.74, ["Neon"] = 2.61, ["Neon|Ride"] = 30.01, ["Neon|Fly|Ride"] = 210.1, ["Mega"] = 49.88, ["Mega|Ride"] = 140.86, ["Mega|Fly|Ride"] = 232.32}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 8.7, ["Neon"] = 43.61, ["Mega"] = 170.63, ["Mega|Fly|Ride"] = 630.21}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 10.42, ["Ride"] = 70.4, ["Fly|Ride"] = 140.78, ["Neon"] = 136.1, ["Mega"] = 288.86, ["Mega|Ride"] = 560.89, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 9.19, ["Fly"] = 28.38, ["Ride"] = 22.94, ["Fly|Ride"] = 59.84, ["Neon"] = 53.4, ["Neon|Ride"] = 56.55, ["Neon|Fly|Ride"] = 109.73, ["Mega"] = 398.09, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 363.05}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 189, ["Fly"] = 280.49, ["Ride"] = 183.57, ["Fly|Ride"] = 228.01, ["Neon"] = 947.52, ["Neon|Ride"] = 928.54, ["Neon|Fly|Ride"] = 843.94, ["Mega|Fly|Ride"] = 3123.69}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Fly"] = 14.43, ["Ride"] = 14.44, ["Fly|Ride"] = 65.08, ["Neon"] = 28.38, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 138.02, ["Mega"] = 220.5, ["Mega|Ride"] = 345.85, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 22.98, ["Fly|Ride"] = 71.57, ["Neon"] = 15.47, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 124.69, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 24.94, ["Ride"] = 77.75, ["Fly|Ride"] = 210, ["Neon"] = 99.75, ["Neon|Ride"] = 241.11, ["Neon|Fly|Ride"] = 449.18, ["Mega"] = 367.5, ["Mega|Ride"] = 378, ["Mega|Fly|Ride"] = 435.75}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 64.05, ["Fly"] = 126.07, ["Ride"] = 98.33, ["Fly|Ride"] = 150.75, ["Neon"] = 328.13, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 1603.86, ["Mega|Fly|Ride"] = 1220.63}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 20.9, ["Ride"] = 45.93, ["Fly|Ride"] = 209.05, ["Neon"] = 71.8, ["Neon|Ride"] = 95.38, ["Neon|Fly|Ride"] = 236.56, ["Mega"] = 272.35, ["Mega|Ride"] = 235.13, ["Mega|Fly|Ride"] = 328.12}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 21.02, ["Fly|Ride"] = 39.38, ["Neon"] = 11.82, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 84.05, ["Mega"] = 69.34, ["Mega|Fly|Ride"] = 251.99}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 11.44, ["Ride"] = 64.46, ["Fly|Ride"] = 420.19, ["Neon"] = 141.15, ["Neon|Ride"] = 84.09, ["Neon|Fly|Ride"] = 420.19, ["Mega"] = 196.44, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 476.53}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 65.63, ["Fly"] = 140.76, ["Ride"] = 137.96, ["Fly|Ride"] = 262.49, ["Neon"] = 195.38, ["Neon|Ride"] = 229.17, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 452.82, ["Mega|Ride"] = 441.89, ["Mega|Fly|Ride"] = 549.94}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Fly"] = 196.45, ["Neon|Ride"] = 79.8, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 34.92, ["Mega|Fly"] = 93.51, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 219.19}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 10.5, ["Ride"] = 69.37, ["Neon"] = 56.74, ["Neon|Ride"] = 393.75, ["Mega"] = 251.19, ["Mega|Ride"] = 452.7, ["Mega|Fly|Ride"] = 529.65}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 884.63, ["Fly"] = 1218.55, ["Ride"] = 892.5, ["Fly|Ride"] = 1029, ["Neon|Ride"] = 3327.63, ["Neon|Fly|Ride"] = 3276.97, ["Mega|Fly|Ride"] = 13501.98}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 23.07, ["Ride"] = 72.56, ["Neon"] = 170.63, ["Neon|Ride"] = 315.15, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 519.92, ["Mega|Ride"] = 524.95, ["Mega|Fly|Ride"] = 694.36}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 3.83, ["Fly"] = 46.82, ["Ride"] = 28.38, ["Fly|Ride"] = 262.5, ["Neon"] = 17.07, ["Neon|Fly"] = 89.31, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 35.99, ["Mega"] = 84.51, ["Mega|Ride"] = 96.65, ["Mega|Fly|Ride"] = 203.43}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 10.5, ["Ride"] = 131.22, ["Neon"] = 78.75, ["Mega|Ride"] = 350.82, ["Mega|Fly|Ride"] = 774.09}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 49.39, ["Fly|Ride"] = 42.03, ["Neon"] = 2.1, ["Neon|Ride"] = 27.26, ["Neon|Fly|Ride"] = 95.39, ["Mega"] = 17.05, ["Mega|Ride"] = 27.56, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 93.18, ["Ride"] = 143.07, ["Neon"] = 314.69, ["Neon|Ride"] = 351.04, ["Neon|Fly|Ride"] = 435.75, ["Mega"] = 1252.13, ["Mega|Ride"] = 1112.99, ["Mega|Fly|Ride"] = 1174.69}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 6.28, ["Fly"] = 101.07, ["Ride"] = 20.76, ["Fly|Ride"] = 812.47, ["Neon"] = 35.43, ["Neon|Ride"] = 84, ["Mega"] = 137.61, ["Mega|Ride"] = 230.04, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.05, ["Ride"] = 26.56, ["Neon"] = 11.59, ["Neon|Ride"] = 39.38, ["Mega"] = 155.47, ["Mega|Ride"] = 277.3, ["Mega|Fly|Ride"] = 386.54}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 47.61, ["Fly"] = 126, ["Ride"] = 63.04, ["Fly|Ride"] = 77.79, ["Neon"] = 199.4, ["Neon|Ride"] = 271.61, ["Neon|Fly|Ride"] = 301.49, ["Mega"] = 483.16, ["Mega|Ride"] = 490.59, ["Mega|Fly|Ride"] = 418.59}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 14.13, ["Fly"] = 183.75, ["Ride"] = 209.05, ["Fly|Ride"] = 131.25, ["Neon"] = 91.88, ["Neon|Fly"] = 179.82, ["Neon|Ride"] = 232.15, ["Neon|Fly|Ride"] = 201.97, ["Mega"] = 372.69, ["Mega|Ride"] = 418.2, ["Mega|Fly|Ride"] = 623.44}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 47.22, ["Ride"] = 44.63, ["Fly|Ride"] = 656.25, ["Neon"] = 166.32, ["Neon|Ride"] = 560.96, ["Neon|Fly|Ride"] = 908.92, ["Mega"] = 1449.47, ["Mega|Ride"] = 1392.64, ["Mega|Fly|Ride"] = 1246.75}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 4.68, ["Neon"] = 19.66, ["Neon|Ride"] = 80.63, ["Neon|Fly|Ride"] = 224.44, ["Mega"] = 103.49, ["Mega|Ride"] = 143.97, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 8.09, ["Fly"] = 52.5, ["Ride"] = 22.31, ["Fly|Ride"] = 84.05, ["Neon"] = 140.78, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 280.49, ["Mega"] = 354.35, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 578.17}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 137.02, ["Ride"] = 156.19, ["Fly|Ride"] = 250.03, ["Neon"] = 459.38, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2362.5, ["Mega|Ride"] = 2361.19, ["Mega|Fly|Ride"] = 2079.67}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.24, ["Fly"] = 20.9, ["Ride"] = 13.13, ["Fly|Ride"] = 40.85, ["Neon"] = 9.96, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 18.23, ["Neon|Fly|Ride"] = 61.1, ["Mega"] = 96.58, ["Mega|Ride"] = 160.01, ["Mega|Fly|Ride"] = 144.37}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 4.68, ["Fly"] = 39.94, ["Ride"] = 20.1, ["Fly|Ride"] = 32.43, ["Neon"] = 35.73, ["Neon|Ride"] = 35.43, ["Neon|Fly|Ride"] = 70.32, ["Mega"] = 220.5, ["Mega|Ride"] = 192.39, ["Mega|Fly|Ride"] = 382.34}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.05, ["Ride"] = 18.98, ["Fly|Ride"] = 38.72, ["Neon"] = 2.1, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 11.8, ["Neon|Fly|Ride"] = 36.75, ["Mega"] = 17.07, ["Mega|Ride"] = 24.18, ["Mega|Fly|Ride"] = 63.32}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 31.53, ["Neon"] = 3.49, ["Neon|Ride"] = 42.03, ["Mega"] = 30.19, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 126}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 3.76, ["Fly"] = 131.74, ["Ride"] = 19.69, ["Neon"] = 10.95, ["Neon|Ride"] = 63, ["Mega"] = 105, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 41.63, ["Ride"] = 128.58, ["Neon"] = 133.77, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 630, ["Mega"] = 470.56, ["Mega|Fly|Ride"] = 519.93}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 3.33, ["Fly"] = 16.52, ["Ride"] = 14.16, ["Fly|Ride"] = 35.75, ["Neon"] = 14.44, ["Neon|Fly"] = 28.4, ["Neon|Ride"] = 19.67, ["Neon|Fly|Ride"] = 54.63, ["Mega"] = 207.98, ["Mega|Fly"] = 210.08, ["Mega|Ride"] = 155.52, ["Mega|Fly|Ride"] = 170.52}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 2.1, ["Fly"] = 28.02, ["Ride"] = 15.77, ["Fly|Ride"] = 48.54, ["Neon"] = 5.71, ["Neon|Fly"] = 35.99, ["Neon|Ride"] = 26.96, ["Neon|Fly|Ride"] = 77.69, ["Mega"] = 134.81, ["Mega|Fly"] = 196.42, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 25.23, ["Ride"] = 24.94, ["Fly|Ride"] = 65.63, ["Neon"] = 14.44, ["Neon|Fly"] = 95.49, ["Neon|Ride"] = 26.88, ["Neon|Fly|Ride"] = 112.12, ["Mega"] = 81.94, ["Mega|Fly"] = 408.19, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 241.5}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 13.01, ["Fly"] = 43.32, ["Ride"] = 131.25, ["Neon"] = 91.88, ["Neon|Ride"] = 112.3, ["Neon|Fly|Ride"] = 171.78, ["Mega"] = 203.78, ["Mega|Ride"] = 280.45, ["Mega|Fly|Ride"] = 334.02}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 4.02, ["Fly"] = 160.69, ["Neon"] = 15.21, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 728.44, ["Mega"] = 252.1, ["Mega|Ride"] = 412.13, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.12, ["Fly"] = 91.88, ["Ride"] = 18.9, ["Fly|Ride"] = 63.67, ["Neon"] = 19.69, ["Neon|Fly"] = 196.65, ["Neon|Ride"] = 60.88, ["Neon|Fly|Ride"] = 101.85, ["Mega"] = 183.75, ["Mega|Ride"] = 175.34, ["Mega|Fly|Ride"] = 280.45}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.05, ["Fly"] = 18.38, ["Ride"] = 13.65, ["Fly|Ride"] = 52.5, ["Neon"] = 11.71, ["Neon|Fly"] = 85.89, ["Neon|Ride"] = 48.34, ["Neon|Fly|Ride"] = 103.82, ["Mega"] = 420.15, ["Mega|Ride"] = 155.52, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 163.25, ["Fly"] = 393.75, ["Ride"] = 231, ["Fly|Ride"] = 393.75, ["Neon"] = 863.28, ["Neon|Ride"] = 952.77, ["Neon|Fly|Ride"] = 892.5, ["Mega|Fly|Ride"] = 3661.88}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 4.02, ["Ride"] = 61.74, ["Neon"] = 15.74, ["Neon|Fly|Ride"] = 280.45, ["Mega"] = 140.84, ["Mega|Ride"] = 267.88, ["Mega|Fly|Ride"] = 700.59}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 26.25, ["Fly|Ride"] = 91.69, ["Neon"] = 13.57, ["Neon|Ride"] = 28.38, ["Neon|Fly|Ride"] = 124.19, ["Mega"] = 203.44, ["Mega|Fly"] = 365.53, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 295.61}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 2.49, ["Fly|Ride"] = 155.55, ["Neon"] = 37.8, ["Neon|Fly|Ride"] = 630, ["Mega"] = 65.63, ["Mega|Ride"] = 359.78, ["Mega|Fly|Ride"] = 420.15}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.05, ["Fly"] = 26.17, ["Ride"] = 16.89, ["Fly|Ride"] = 38.19, ["Neon"] = 2.1, ["Neon|Fly"] = 22.32, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 44.5, ["Mega"] = 15.67, ["Mega|Fly|Ride"] = 42.87}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.41, ["Fly"] = 36.52, ["Ride"] = 22.62, ["Fly|Ride"] = 84, ["Neon"] = 17.21, ["Neon|Ride"] = 24.1, ["Neon|Fly|Ride"] = 78.72, ["Mega"] = 280.45, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 232.09}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.1, ["Ride"] = 62.34, ["Neon"] = 11.82, ["Neon|Ride"] = 280.49, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 81.95, ["Mega|Ride"] = 148.32, ["Mega|Fly|Ride"] = 450.19}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 70.85, ["Fly"] = 130.28, ["Ride"] = 87.94, ["Fly|Ride"] = 155.37, ["Neon"] = 262.5, ["Neon|Ride"] = 354.37, ["Neon|Fly|Ride"] = 408.19, ["Mega|Ride"] = 3502.86, ["Mega|Fly|Ride"] = 1679.49}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.84, ["Fly"] = 65.63, ["Ride"] = 24.78, ["Fly|Ride"] = 140.78, ["Neon"] = 23.21, ["Neon|Ride"] = 62.98, ["Neon|Fly|Ride"] = 309.88, ["Mega"] = 161.78, ["Mega|Ride"] = 210.08, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 56.74, ["Fly|Ride"] = 140.78, ["Neon"] = 9.34, ["Neon|Ride"] = 177.07, ["Neon|Fly|Ride"] = 520.46, ["Mega"] = 64.09, ["Mega|Fly"] = 409.64, ["Mega|Ride"] = 84.04, ["Mega|Fly|Ride"] = 209.03}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 49.35, ["Fly"] = 155.55, ["Ride"] = 78.56, ["Fly|Ride"] = 295.32, ["Neon"] = 136.5, ["Neon|Ride"] = 156.03, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 553.86, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 735}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.05, ["Ride"] = 16.79, ["Fly|Ride"] = 31.49, ["Neon"] = 2.1, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 11.16, ["Neon|Fly|Ride"] = 43.19, ["Mega"] = 14.99, ["Mega|Ride"] = 33.31, ["Mega|Fly|Ride"] = 42.16}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.05, ["Neon"] = 3.35, ["Neon|Ride"] = 44.12, ["Mega"] = 23.55, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 81.58, ["Mega|Fly|Ride"] = 157.35}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 65.77, ["Neon"] = 7.98, ["Neon|Ride"] = 30.39, ["Neon|Fly|Ride"] = 181.22, ["Mega"] = 55.53, ["Mega|Ride"] = 127.88, ["Mega|Fly|Ride"] = 464.22}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 6.57, ["Fly"] = 56.74, ["Ride"] = 27.53, ["Fly|Ride"] = 91.87, ["Neon"] = 12.74, ["Neon|Fly"] = 81.95, ["Neon|Ride"] = 69.17, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 73.63, ["Mega|Fly"] = 185.7, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 245.06}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.77, ["Ride"] = 11.82, ["Fly|Ride"] = 52.5, ["Neon"] = 2.1, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 25.47, ["Mega"] = 18.92, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 29.33, ["Mega|Fly|Ride"] = 123.96}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 11.39, ["Ride"] = 45.94, ["Neon"] = 59.83, ["Neon|Fly|Ride"] = 173.92, ["Mega"] = 378.14, ["Mega|Ride"] = 418.04, ["Mega|Fly|Ride"] = 363.43}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 3216.94, ["Ride"] = 3804.94, ["Fly|Ride"] = 3346.88, ["Neon|Fly|Ride"] = 10369.78}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.05, ["Fly"] = 28.28, ["Ride"] = 12.47, ["Fly|Ride"] = 38.66, ["Neon"] = 6.57, ["Neon|Fly"] = 56.37, ["Neon|Ride"] = 16.79, ["Neon|Fly|Ride"] = 45.47, ["Mega"] = 60.69, ["Mega|Ride"] = 87.08, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 3.81, ["Ride"] = 26.25, ["Neon"] = 9.19, ["Neon|Ride"] = 70.4, ["Mega"] = 101.05, ["Mega|Ride"] = 378.29}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 11.8, ["Ride"] = 27.09, ["Fly|Ride"] = 56.17, ["Neon"] = 87.92, ["Neon|Ride"] = 150.82, ["Neon|Fly|Ride"] = 210.1, ["Mega"] = 420.15, ["Mega|Ride"] = 472.66, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 32.38, ["Ride"] = 116.62, ["Fly|Ride"] = 140.78, ["Neon"] = 125.1, ["Neon|Fly|Ride"] = 420.19, ["Mega"] = 481.69, ["Mega|Ride"] = 620.76, ["Mega|Fly|Ride"] = 546.18}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 120.74, ["Fly"] = 210.1, ["Ride"] = 168.09, ["Fly|Ride"] = 259.62, ["Neon"] = 943.32, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 801.94, ["Mega"] = 6301.98, ["Mega|Ride"] = 3011.3, ["Mega|Fly|Ride"] = 3411.48}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 3.94, ["Ride"] = 26.25, ["Fly|Ride"] = 112.42, ["Neon"] = 52.49, ["Neon|Fly"] = 56.74, ["Neon|Ride"] = 124.2, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 98.75, ["Mega|Ride"] = 185.7, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 13.26, ["Neon|Fly"] = 94.56, ["Neon|Ride"] = 34.13, ["Mega"] = 48.12, ["Mega|Ride"] = 262.24, ["Mega|Fly|Ride"] = 361.33}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 101.99, ["Ride"] = 20.72, ["Fly|Ride"] = 78.75, ["Neon"] = 8.44, ["Neon|Ride"] = 36.68, ["Mega"] = 87.28, ["Mega|Ride"] = 98.75, ["Mega|Fly|Ride"] = 252.1}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 9.14, ["Neon"] = 322.51, ["Neon|Ride"] = 132.3, ["Mega"] = 376.69, ["Mega|Ride"] = 464.22, ["Mega|Fly|Ride"] = 617.54}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.05, ["Ride"] = 69.78, ["Neon"] = 2.1, ["Neon|Ride"] = 42.03, ["Mega"] = 14.44, ["Mega|Ride"] = 168.07, ["Mega|Fly|Ride"] = 280.45}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 83.88, ["Fly"] = 248.28, ["Ride"] = 114.58, ["Fly|Ride"] = 168.06, ["Neon"] = 363.46, ["Neon|Fly"] = 602.98, ["Neon|Ride"] = 315.15, ["Neon|Fly|Ride"] = 455.44, ["Mega"] = 1680.54, ["Mega|Ride"] = 1286.25, ["Mega|Fly|Ride"] = 1239.4}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.21, ["Ride"] = 32.29, ["Neon"] = 3.56, ["Mega"] = 91.4, ["Mega|Ride"] = 137.82}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 37.43, ["Ride"] = 52.39, ["Fly|Ride"] = 155.49, ["Neon"] = 262.24, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 318.93, ["Mega"] = 2625, ["Mega|Ride"] = 1239, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.05, ["Fly"] = 32.82, ["Ride"] = 19.97, ["Fly|Ride"] = 70.4, ["Neon"] = 3.93, ["Neon|Ride"] = 78.75, ["Mega"] = 39.94, ["Mega|Ride"] = 140.76, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.63, ["Fly"] = 280.49, ["Neon"] = 8.28, ["Mega"] = 69.57, ["Mega|Ride"] = 157.31, ["Mega|Fly|Ride"] = 282.19}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 6.19, ["Ride"] = 54.57, ["Fly|Ride"] = 140.78, ["Neon"] = 36.75, ["Neon|Ride"] = 66.2, ["Neon|Fly|Ride"] = 686.94, ["Mega"] = 141.12, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 326.75, ["Fly"] = 542.05, ["Ride"] = 400.81, ["Fly|Ride"] = 410.82, ["Neon"] = 825.96, ["Neon|Ride"] = 916.53, ["Neon|Fly|Ride"] = 1065.4, ["Mega"] = 3545.92, ["Mega|Ride"] = 2361.19, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 30.07, ["Fly"] = 65.63, ["Ride"] = 62.68, ["Fly|Ride"] = 96.64, ["Neon"] = 140.78, ["Neon|Fly"] = 309.91, ["Neon|Ride"] = 186.38, ["Neon|Fly|Ride"] = 298.35, ["Mega|Ride"] = 962.07, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.05, ["Fly"] = 39.38, ["Ride"] = 15.81, ["Fly|Ride"] = 70.88, ["Neon"] = 3.72, ["Neon|Fly"] = 136.58, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 73.85, ["Mega"] = 42, ["Mega|Ride"] = 77.67, ["Mega|Fly|Ride"] = 266.6}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 8.39, ["Fly"] = 108.21, ["Ride"] = 23.97, ["Fly|Ride"] = 98.44, ["Neon"] = 26.24, ["Neon|Fly"] = 109.12, ["Neon|Ride"] = 64.09, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 198, ["Mega|Fly"] = 935.86, ["Mega|Ride"] = 270.84, ["Mega|Fly|Ride"] = 371.6}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 7.38, ["Ride"] = 24.68, ["Fly|Ride"] = 98.76, ["Neon"] = 105, ["Neon|Ride"] = 73.56, ["Neon|Fly|Ride"] = 137.63, ["Mega"] = 501.36, ["Mega|Ride"] = 309.87, ["Mega|Fly|Ride"] = 496.72}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 2.33, ["Neon"] = 9.43, ["Neon|Ride"] = 65.63, ["Mega"] = 43.32, ["Mega|Ride"] = 118.13}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.26, ["Fly"] = 86.63, ["Ride"] = 16.99, ["Fly|Ride"] = 65.54, ["Neon"] = 13.12, ["Neon|Ride"] = 42.03, ["Neon|Fly|Ride"] = 280.49, ["Mega"] = 541.98, ["Mega|Ride"] = 322.46}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 84, ["Ride"] = 101.28, ["Fly|Ride"] = 183.74, ["Neon"] = 485.39, ["Neon|Ride"] = 628.68, ["Neon|Fly|Ride"] = 623.99, ["Mega|Ride"] = 2415.77, ["Mega|Fly|Ride"] = 2165.63}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 27.55, ["Ride"] = 52.27, ["Fly|Ride"] = 144, ["Neon"] = 139.3, ["Neon|Ride"] = 272.08, ["Mega"] = 696.32, ["Mega|Ride"] = 707.94, ["Mega|Fly|Ride"] = 708.1}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2833.26, ["Fly"] = 3361.47, ["Ride"] = 2551.5, ["Fly|Ride"] = 2526.57, ["Neon"] = 12605.48, ["Neon|Fly|Ride"] = 6445.69, ["Mega|Fly|Ride"] = 25905.28}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 22.32, ["Fly|Ride"] = 157.5, ["Neon"] = 5.9, ["Neon|Ride"] = 34.99, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 91.88, ["Mega|Ride"] = 210.08, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 9.68, ["Ride"] = 62.58, ["Fly|Ride"] = 280.49, ["Neon"] = 31.42, ["Neon|Ride"] = 116.02, ["Mega"] = 105, ["Mega|Ride"] = 198.84, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 996.09, ["Fly"] = 1230.32, ["Ride"] = 970.29, ["Fly|Ride"] = 1141.88, ["Neon"] = 4045.32, ["Neon|Ride"] = 3488.58, ["Neon|Fly|Ride"] = 3150, ["Mega|Ride"] = 15905.11, ["Mega|Fly|Ride"] = 10053.75}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 21, ["Ride"] = 84.05, ["Fly|Ride"] = 126.07, ["Neon"] = 156.29, ["Mega"] = 590.05, ["Mega|Ride"] = 1083.95, ["Mega|Fly|Ride"] = 735}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.28, ["Ride"] = 89.93, ["Fly|Ride"] = 56.74, ["Neon"] = 12.38, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 210.1, ["Mega|Fly|Ride"] = 278.25}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Fly|Ride"] = 52.5, ["Neon"] = 3.82, ["Neon|Fly"] = 40.94, ["Mega"] = 15.89, ["Mega|Ride"] = 54.56, ["Mega|Fly|Ride"] = 125.01}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 78.73, ["Ride"] = 124.69, ["Fly|Ride"] = 656.25, ["Neon"] = 315, ["Neon|Ride"] = 553.6, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 2520.8}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 5.11, ["Ride"] = 35.26, ["Neon"] = 11.19, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 168.09, ["Mega"] = 149.63, ["Mega|Ride"] = 208.9, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 52.5, ["Ride"] = 232.16, ["Neon"] = 590.63, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 2100.68, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 3.93, ["Fly"] = 105, ["Fly|Ride"] = 112.42, ["Neon"] = 52.54, ["Neon|Ride"] = 262.44, ["Mega"] = 196.88}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 257.25, ["Ride"] = 246.74, ["Fly|Ride"] = 327.8, ["Neon"] = 977.99, ["Neon|Ride"] = 1191.23, ["Neon|Fly|Ride"] = 724.66, ["Mega|Fly|Ride"] = 3514.42}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 22.32, ["Fly|Ride"] = 83, ["Neon"] = 20.97, ["Neon|Ride"] = 45.34, ["Neon|Fly|Ride"] = 96.66, ["Mega"] = 285.48, ["Mega|Ride"] = 305.66, ["Mega|Fly|Ride"] = 350.34}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.05, ["Fly"] = 28.38, ["Ride"] = 12.44, ["Fly|Ride"] = 33.63, ["Neon"] = 3.14, ["Neon|Fly"] = 39.09, ["Neon|Ride"] = 22.97, ["Neon|Fly|Ride"] = 47.92, ["Mega"] = 32.29, ["Mega|Fly"] = 420.15, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 122.19}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 840.5, ["Fly"] = 1065.18, ["Ride"] = 901.69, ["Fly|Ride"] = 892.49, ["Neon|Ride"] = 3888.25, ["Neon|Fly|Ride"] = 3466.52, ["Mega"] = 27308.52, ["Mega|Fly|Ride"] = 28009.08}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 3.41, ["Fly"] = 980.19, ["Ride"] = 36.16, ["Neon"] = 25.47, ["Neon|Ride"] = 116.08, ["Mega"] = 140.43, ["Mega|Ride"] = 179.69, ["Mega|Fly|Ride"] = 371.83}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 6.13, ["Fly"] = 140.78, ["Ride"] = 40.51, ["Fly|Ride"] = 420.19, ["Neon"] = 26.94, ["Neon|Ride"] = 46.44, ["Neon|Fly|Ride"] = 126.07, ["Mega"] = 104.78, ["Mega|Ride"] = 196.85, ["Mega|Fly|Ride"] = 267.75}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 23.63, ["Fly"] = 26.25, ["Ride"] = 38.07, ["Fly|Ride"] = 63.57, ["Neon"] = 294.82, ["Neon|Ride"] = 189.14, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 2067.06, ["Mega|Fly|Ride"] = 767.82}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 15.63, ["Fly"] = 78.8, ["Ride"] = 26.7, ["Fly|Ride"] = 60.36, ["Neon"] = 54.48, ["Neon|Ride"] = 70.44, ["Neon|Fly|Ride"] = 155.49, ["Mega"] = 434.04, ["Mega|Ride"] = 735, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 26.25, ["Ride"] = 56.74, ["Fly|Ride"] = 636.57, ["Neon"] = 87.21, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 406.49, ["Mega|Ride"] = 494.82, ["Mega|Fly|Ride"] = 560.89}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.05, ["Fly"] = 42.03, ["Ride"] = 105, ["Fly|Ride"] = 155.55, ["Neon"] = 2.1, ["Neon|Ride"] = 42.03, ["Mega"] = 16.46, ["Mega|Ride"] = 89.25, ["Mega|Fly|Ride"] = 874.13}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 25.03, ["Fly"] = 56.68, ["Ride"] = 38.36, ["Fly|Ride"] = 91.88, ["Neon"] = 578.82, ["Neon|Fly"] = 310.21, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 212.62, ["Mega"] = 3361.07, ["Mega|Fly|Ride"] = 602.43}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.49, ["Fly"] = 753.29, ["Ride"] = 19.56, ["Fly|Ride"] = 67.37, ["Neon"] = 42, ["Neon|Ride"] = 155.55, ["Mega"] = 656.25}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 35.73, ["Ride"] = 18.38, ["Fly|Ride"] = 68.25, ["Neon"] = 15.74, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 39.48, ["Mega"] = 1037.73, ["Mega|Ride"] = 238.44, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.35, ["Ride"] = 61.69, ["Neon"] = 105, ["Mega"] = 262.5, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 15.89, ["Fly"] = 262.24, ["Ride"] = 31.35, ["Fly|Ride"] = 196.88, ["Neon"] = 74.95, ["Neon|Ride"] = 112.41, ["Neon|Fly|Ride"] = 209.05, ["Mega"] = 630.29, ["Mega|Ride"] = 616.55, ["Mega|Fly|Ride"] = 700.59}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 6.14, ["Neon"] = 10.17, ["Neon|Ride"] = 78.75, ["Mega"] = 72.68, ["Mega|Fly|Ride"] = 309.54}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 27.15, ["Neon"] = 2.1, ["Neon|Ride"] = 65.63, ["Mega"] = 15.75, ["Mega|Ride"] = 43.63, ["Mega|Fly|Ride"] = 199.5}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Neon"] = 2.1, ["Neon|Ride"] = 22.32, ["Mega"] = 18.38, ["Mega|Ride"] = 52.41, ["Mega|Fly|Ride"] = 96.76}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.05, ["Fly"] = 1481.02, ["Ride"] = 19.94, ["Fly|Ride"] = 37.09, ["Neon"] = 5.92, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 84.05, ["Mega"] = 86.63, ["Mega|Ride"] = 159.68, ["Mega|Fly|Ride"] = 171.94}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 5223, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 52.54, ["Mega"] = 140.76, ["Mega|Ride"] = 158.33}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 39.48, ["Ride"] = 11.8, ["Fly|Ride"] = 42, ["Neon"] = 14.18, ["Neon|Ride"] = 36.74, ["Neon|Fly|Ride"] = 80.07, ["Mega"] = 216.57, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 350.86}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 69.57, ["Ride"] = 168.09, ["Fly|Ride"] = 392.88, ["Neon"] = 183.75, ["Neon|Ride"] = 315.15, ["Neon|Fly|Ride"] = 322.51, ["Mega"] = 686.94, ["Mega|Ride"] = 761.25, ["Mega|Fly|Ride"] = 845.73}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.05, ["Fly"] = 26.25, ["Ride"] = 15.32, ["Fly|Ride"] = 27.4, ["Neon"] = 2.63, ["Neon|Fly"] = 22.66, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 38.66, ["Mega"] = 28.25, ["Mega|Ride"] = 56.74, ["Mega|Fly|Ride"] = 116.21}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 4.12, ["Fly"] = 62.3, ["Ride"] = 25.47, ["Fly|Ride"] = 1260.51, ["Neon"] = 63.04, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 101.84, ["Mega"] = 524.99, ["Mega|Ride"] = 302.51, ["Mega|Fly|Ride"] = 302.54}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 10.48, ["Fly"] = 21.41, ["Ride"] = 27.55, ["Fly|Ride"] = 79.85, ["Neon"] = 50.93, ["Neon|Ride"] = 67.98, ["Neon|Fly|Ride"] = 138.66, ["Mega"] = 1023.04, ["Mega|Ride"] = 412.27, ["Mega|Fly|Ride"] = 385.14}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 2.1, ["Fly"] = 140.38, ["Neon"] = 16.16, ["Neon|Ride"] = 70.4, ["Mega"] = 150.94, ["Mega|Ride"] = 232.14}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.05, ["Ride"] = 15.74, ["Fly|Ride"] = 56.74, ["Neon"] = 2.63, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 18.9, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 35.25, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 121.42}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 13.71, ["Neon|Ride"] = 31.82, ["Neon|Fly|Ride"] = 210.08, ["Mega"] = 161.33, ["Mega|Fly"] = 735, ["Mega|Ride"] = 139.29, ["Mega|Fly|Ride"] = 334.41}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 885.07, ["Fly"] = 1263.72, ["Ride"] = 971.25, ["Fly|Ride"] = 974.31, ["Neon"] = 2941.14, ["Neon|Ride"] = 1968.75, ["Neon|Fly|Ride"] = 2096.59, ["Mega|Fly|Ride"] = 7398.57}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 55.99, ["Ride"] = 98.44, ["Fly|Ride"] = 126.07, ["Neon"] = 266.97, ["Neon|Ride"] = 280.49, ["Neon|Fly|Ride"] = 427.55, ["Mega"] = 3147.27, ["Mega|Ride"] = 1260.41, ["Mega|Fly|Ride"] = 1155}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.05, ["Fly"] = 62.99, ["Ride"] = 68.39, ["Neon"] = 6.02, ["Neon|Ride"] = 74.6, ["Neon|Fly|Ride"] = 315, ["Mega"] = 48.88, ["Mega|Ride"] = 131.25}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 33.59, ["Ride"] = 52.5, ["Fly|Ride"] = 140.78, ["Neon"] = 249.12, ["Neon|Ride"] = 137.91, ["Neon|Fly|Ride"] = 300.57, ["Mega"] = 840.28, ["Mega|Ride"] = 694.32, ["Mega|Fly|Ride"] = 710.07}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 6.28, ["Ride"] = 23.23, ["Fly|Ride"] = 279.44, ["Neon"] = 42.03, ["Neon|Ride"] = 131.25, ["Mega"] = 273.1, ["Mega|Ride"] = 350.82, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 292.69, ["Fly"] = 928.54, ["Ride"] = 315, ["Fly|Ride"] = 407.59, ["Neon"] = 1181.25, ["Neon|Ride"] = 1261.49, ["Neon|Fly|Ride"] = 1182.57, ["Mega|Fly|Ride"] = 4093.11}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.05, ["Fly"] = 102.38, ["Ride"] = 21, ["Fly|Ride"] = 129.93, ["Neon"] = 11.1, ["Mega"] = 182.78, ["Mega|Fly"] = 280.45}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.05, ["Ride"] = 18.92, ["Neon"] = 19.02, ["Neon|Ride"] = 140.78}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 30.48, ["Ride"] = 48.57, ["Fly|Ride"] = 210.1, ["Neon"] = 151.26, ["Neon|Ride"] = 165.8, ["Mega"] = 700.59, ["Mega|Ride"] = 974.54, ["Mega|Fly|Ride"] = 738.29}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.05, ["Ride"] = 19.97, ["Fly|Ride"] = 140.78, ["Neon"] = 65.63, ["Neon|Ride"] = 155.55, ["Mega"] = 176.48, ["Mega|Ride"] = 140.76, ["Mega|Fly|Ride"] = 420.15}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.05, ["Fly"] = 21, ["Ride"] = 11.01, ["Fly|Ride"] = 27.98, ["Neon"] = 3.13, ["Neon|Fly"] = 31.18, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 43.32, ["Mega"] = 48.33, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 75.6}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 5356.32, ["Ride"] = 3937.5, ["Fly|Ride"] = 4198.68, ["Neon"] = 25210.94, ["Neon|Fly|Ride"] = 19163.82, ["Mega|Fly|Ride"] = 78564.48}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 6.15, ["Ride"] = 56.35, ["Neon"] = 129.23, ["Mega"] = 262.49, ["Mega|Ride"] = 309.87, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 31.53, ["Ride"] = 15.74, ["Fly|Ride"] = 47.06, ["Neon"] = 13.69, ["Neon|Fly"] = 42.03, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 84.04, ["Mega"] = 280.45, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 151.6}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 414.75, ["Fly"] = 840, ["Ride"] = 420, ["Fly|Ride"] = 472.33, ["Neon"] = 1680.74, ["Neon|Ride"] = 1270.94, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 5783.11}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 4.93, ["Neon"] = 13.47, ["Neon|Ride"] = 291.38, ["Neon|Fly|Ride"] = 280.49, ["Mega"] = 131.25, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.63, ["Fly"] = 51.49, ["Ride"] = 77.79, ["Neon"] = 42.42, ["Neon|Ride"] = 279.44, ["Neon|Fly|Ride"] = 14006.78, ["Mega"] = 280.45, ["Mega|Ride"] = 360.94, ["Mega|Fly|Ride"] = 2321.05}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 14.44, ["Neon"] = 3.73, ["Neon|Ride"] = 45.28, ["Mega"] = 36.15, ["Mega|Ride"] = 65.63}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 525, ["Ride"] = 576.94, ["Fly|Ride"] = 656.25, ["Neon"] = 3870.83, ["Neon|Fly|Ride"] = 2100.93, ["Mega|Fly|Ride"] = 8751.75}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.57, ["Ride"] = 65.63, ["Neon"] = 18.47, ["Neon|Fly"] = 49.39, ["Neon|Ride"] = 85.99, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 108.94, ["Mega|Ride"] = 210.08, ["Mega|Fly|Ride"] = 463.2}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 7.62, ["Fly"] = 236.25, ["Ride"] = 52.5, ["Fly|Ride"] = 140.78, ["Neon"] = 32.58, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 127.21, ["Mega"] = 226.25, ["Mega|Ride"] = 224.63, ["Mega|Fly|Ride"] = 306.03}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 14.31, ["Fly|Ride"] = 33.66, ["Neon"] = 7.86, ["Neon|Fly"] = 140.78, ["Neon|Ride"] = 20.37, ["Neon|Fly|Ride"] = 85.31, ["Mega"] = 114.59, ["Mega|Fly"] = 224.79, ["Mega|Ride"] = 195.37, ["Mega|Fly|Ride"] = 210.08}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 18.38, ["Ride"] = 39.38, ["Fly|Ride"] = 116.08, ["Neon"] = 187.03, ["Neon|Ride"] = 252.12, ["Mega"] = 516.77, ["Mega|Ride"] = 420.15, ["Mega|Fly|Ride"] = 526.32}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Neon"] = 3.73, ["Neon|Ride"] = 28.38, ["Neon|Fly|Ride"] = 2031.18, ["Mega"] = 15.26, ["Mega|Ride"] = 95.5, ["Mega|Fly|Ride"] = 258.39}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 471.19, ["Ride"] = 492.18, ["Fly|Ride"] = 682.5, ["Neon"] = 1947.57, ["Neon|Ride"] = 2100.93, ["Neon|Fly|Ride"] = 2362.49, ["Mega|Ride"] = 9052.1, ["Mega|Fly|Ride"] = 7605.44}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 49.41, ["Neon"] = 7.48, ["Neon|Ride"] = 91.41, ["Mega"] = 35.44, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 28.38, ["Neon"] = 3.99, ["Neon|Ride"] = 41.64, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 31.95, ["Mega|Ride"] = 84.04, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 3.94, ["Neon|Ride"] = 62.91, ["Mega"] = 32.44, ["Mega|Fly"] = 155.47, ["Mega|Ride"] = 105.05, ["Mega|Fly|Ride"] = 167.37}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 14.48}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 23.84, ["Ride"] = 45.94, ["Fly|Ride"] = 140.78, ["Neon"] = 76.8, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 415.99, ["Mega"] = 1089.38, ["Mega|Ride"] = 523.68, ["Mega|Fly|Ride"] = 558.22}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 8.92, ["Ride"] = 66.94, ["Fly|Ride"] = 230.67, ["Neon"] = 107.63, ["Neon|Ride"] = 111.45, ["Neon|Fly|Ride"] = 210.1, ["Mega"] = 551.25, ["Mega|Ride"] = 547.98, ["Mega|Fly|Ride"] = 488.24}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.05, ["Fly"] = 34.63, ["Ride"] = 12.08, ["Fly|Ride"] = 31.49, ["Neon"] = 27.54, ["Neon|Ride"] = 23.21, ["Neon|Fly|Ride"] = 55.13, ["Mega"] = 300.57, ["Mega|Ride"] = 222.69, ["Mega|Fly|Ride"] = 225.75}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 8.52, ["Ride"] = 32.82, ["Neon"] = 113.49, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 322.46, ["Mega|Fly|Ride"] = 487.37}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 32.58, ["Ride"] = 28.29, ["Fly|Ride"] = 362.25, ["Neon"] = 11.82, ["Neon|Ride"] = 83.87, ["Mega"] = 91.88, ["Mega|Ride"] = 125.01, ["Mega|Fly|Ride"] = 138.66}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 15.74, ["Ride"] = 17.04, ["Fly|Ride"] = 62.11, ["Neon"] = 131.25, ["Neon|Ride"] = 70.68, ["Neon|Fly|Ride"] = 207.38, ["Mega"] = 944.26, ["Mega|Ride"] = 928.44, ["Mega|Fly|Ride"] = 608.42}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 21.51, ["Fly"] = 874.13, ["Neon"] = 150.94, ["Neon|Fly"] = 170.63}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 36.8, ["Fly"] = 115.5, ["Ride"] = 72.12, ["Fly|Ride"] = 144.38, ["Neon"] = 297.93, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 386.7, ["Mega|Ride"] = 1378.13, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 65.63, ["Fly"] = 126.1, ["Ride"] = 98.76, ["Fly|Ride"] = 294.14, ["Neon"] = 178.76, ["Neon|Ride"] = 215.25, ["Neon|Fly|Ride"] = 364.88, ["Mega"] = 619.74, ["Mega|Ride"] = 615.25, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 12.21, ["Ride"] = 77.75, ["Fly|Ride"] = 116.08, ["Neon"] = 157.5, ["Neon|Ride"] = 124.2, ["Mega"] = 658.56, ["Mega|Ride"] = 641.76, ["Mega|Fly|Ride"] = 1258.31}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 3.77, ["Ride"] = 15.74, ["Fly|Ride"] = 83.94, ["Neon"] = 56.44, ["Neon|Fly"] = 420, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 185.72, ["Mega"] = 350.82, ["Mega|Ride"] = 345.19, ["Mega|Fly|Ride"] = 373.94}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.05, ["Fly"] = 26.54, ["Ride"] = 15.75, ["Fly|Ride"] = 25.18, ["Neon"] = 3.26, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 13.73, ["Neon|Fly|Ride"] = 71.97, ["Mega"] = 45.85, ["Mega|Ride"] = 83.01, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1311.19}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 14.05, ["Ride"] = 46.44, ["Fly|Ride"] = 236.25, ["Neon"] = 105, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 314.1, ["Mega"] = 553.54, ["Mega|Ride"] = 518.44, ["Mega|Fly|Ride"] = 978.92}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 56.48, ["Neon"] = 2.98, ["Neon|Ride"] = 23.61, ["Neon|Fly|Ride"] = 293.76, ["Mega"] = 25.23, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 217.88}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 26.23, ["Ride"] = 65.63, ["Fly|Ride"] = 280.47, ["Neon"] = 111.57, ["Neon|Ride"] = 414.74, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 700.59, ["Mega|Ride"] = 580.28, ["Mega|Fly|Ride"] = 692.27}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Ride"] = 35.73, ["Neon"] = 3.56, ["Mega"] = 18.9}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Mega"] = 22.23, ["Mega|Ride"] = 126.06, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 104.25, ["Ride"] = 150.82, ["Fly|Ride"] = 183.75, ["Neon"] = 393.74, ["Neon|Ride"] = 529.45, ["Neon|Fly|Ride"] = 618.9, ["Mega|Ride"] = 6382.89, ["Mega|Fly|Ride"] = 1968.74}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 16.54, ["Neon"] = 7.87, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 155.47, ["Mega"] = 60.94, ["Mega|Ride"] = 98.75, ["Mega|Fly|Ride"] = 155.47}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 34.92, ["Fly|Ride"] = 86.63, ["Neon"] = 5.25, ["Neon|Ride"] = 28.35, ["Neon|Fly|Ride"] = 419.99, ["Mega"] = 31.17, ["Mega|Ride"] = 125.01}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.05, ["Ride"] = 31.34, ["Neon"] = 3.13, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 34.38, ["Mega"] = 31.44, ["Mega|Ride"] = 74.74}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 21.02, ["Neon"] = 3.84, ["Neon|Ride"] = 30.12, ["Mega"] = 63.04, ["Mega|Ride"] = 85.05}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 30.43, ["Ride"] = 72.19, ["Fly|Ride"] = 619.81, ["Neon"] = 350.44, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 695.63, ["Mega|Fly|Ride"] = 1248.12}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.62, ["Ride"] = 129.31, ["Neon"] = 23.63, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 210.08, ["Mega"] = 197.25, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 314.07}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 370.79, ["Ride"] = 457.41, ["Fly|Ride"] = 607.17, ["Neon"] = 1758.42, ["Neon|Ride"] = 2100.93, ["Neon|Fly|Ride"] = 1405.69, ["Mega|Ride"] = 3766.49, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 65.63}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 38.85}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 12.73}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 11.52}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 525.25}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 52.5}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 6.83}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 2.55}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 213.94}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 20.88}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.05}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 66.87}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 9.17}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 9.08}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 249.38}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.05}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 3.94}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 6.57}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 3.81}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 8.38}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 491.14}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.05}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.05}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 690.11}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 18.38}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1064.44}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 203.73}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 8.97}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 13.13}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.63}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.34}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 18.17}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 52.85}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 43.62}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 15.26}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 10.5}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 18.64}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 2.49}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 17.05}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.1}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 20.77}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 15.74}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 3.15}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.05}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.05}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1443.75}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.05}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 101.84}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.05}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 209.99}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 3.73}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 9.16}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 8.77}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 138.55}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 135.07}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 10.02}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 10.44}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.05}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 170.63}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 24.94}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 5.17}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 16.28}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 8.01}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 127.32}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 15.26}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 7.44}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.05}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 12.31}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 9.45}},
    ["rbxassetid://1265129203"] = {name = "Ice Snowboard", prices = {["default"] = 207.38}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 2.1}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 11.69}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 117.99}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 91.87}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 4.04}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 11.39}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.94}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 62.15}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 17.75}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22052.62}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 169.13}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 32.64}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 26.24}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 21}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 111.18}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 25.6}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 39.38}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 31.82}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 111.57}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 62.46}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 39.38}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 26.25}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 32.82}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 31.82}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.05}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 170.62}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 15.77}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 7.44}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.05}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 6.45}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 23.5}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 23.3}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 2.49}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.62}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 2.63}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 3.49}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.05}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.05}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 1401.32}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 9.19}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 524.37}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 47.24}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 5.25}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 262.5}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 15.46}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 59.73}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 30.93}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 24.02}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 43.99}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 23.6}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 2.2}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.05}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 9.53}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 6.98}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 2.14}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 19.29}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.1}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.05}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.36}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 4.2}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 18}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 153.01}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.05}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.05}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 33.17}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1049.43}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 8.4}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 9.08}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 52.49}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 9.75}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 86.03}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 11.78}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.61}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 5.01}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 5.1}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 10.16}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 78.68}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 14.81}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.05}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 7.23}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 4.5}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.96}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 7.8}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 18.5}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.05}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.05}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 3.1}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 3.94}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.24}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.03}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 3.92}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7300.68}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 13.83}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 6.45}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 3.93}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.33}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 13.79}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.05}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 3.59}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 3.94}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 2.19}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 10}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.05}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 75.37}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 4.54}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 6.29}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 2.16}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 7.87}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 3.45}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 2.43}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4410.54}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 3.96}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.05}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 34.12}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 2.1}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 54.51}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 2.61}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 131.24}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.05}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 3.92}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.63}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 3.61}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.05}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 2.26}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 22.31}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.31}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.05}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.05}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 2.57}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.21}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.05}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 9.34}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.05}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.05}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 5.35}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.6}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 2.61}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.63}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.61}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 3.91}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.05}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.05}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.61}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.51}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.24}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.56}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 28.35}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 3.41}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.05}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 6.23}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 99.75}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 19.71}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 859.31}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.05}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 12.55}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 3.3}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 3.94}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.05}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 3.93}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 11.58}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.05}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 4.41}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.05}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 8.97}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 14.04}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 44.14}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 12.22}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.05}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.61}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 5.3}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.14}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 31.5}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.93}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.05}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 32.82}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 6.13}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 12.95}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.05}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.05}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 8.33}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 147.98}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.05}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 41.85}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 2.1}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 12.21}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 10.49}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.76}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.05}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 3.93}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 91.02}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.15}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 4.75}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 15.73}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.93}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 3.92}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 5.1}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.05}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 6.07}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 69.3}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 3.83}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.05}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 103.4}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 4.19}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1109.07}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 140.78}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.24}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 3.15}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.05}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.63}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 5.04}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 43.55}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.16}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.35}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.05}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 5.25}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 32.6}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 3.91}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.05}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.61}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 7.03}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 54.69}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 2.26}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 78.75}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.05}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 2.67}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.05}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.5}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 10.84}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 84.58}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.88}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.6}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 52.45}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 6.57}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.47}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.05}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 5.76}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 59.7}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.05}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.05}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 16.7}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 57.62}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 325.5}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.13}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 17.82}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.05}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 98.85}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 5.25}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.63}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 8.69}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 54.99}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 11.12}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 7.34}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 10.84}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.49}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 14.06}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 2.19}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 17.07}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 38.63}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 3.7}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 15.7}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.81}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 3.94}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 35.81}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.05}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 33.11}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 26.09}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1508.88}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 5.8}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 5.86}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 23.23}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 248.74}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 20.88}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 6.57}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 7.69}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 6.09}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 3.29}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 238.25}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 71.87}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 58.68}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 5.12}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.05}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.52}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 63.36}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 90.57}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 41.85}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 892.5}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 78.75}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 7.27}},
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