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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 822.94, ["Ride"] = 1027.16, ["Fly|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 4200, ["Mega|Fly|Ride"] = 19994.69}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 459.38, ["Ride"] = 564.37, ["Fly|Ride"] = 613.19, ["Neon|Fly|Ride"] = 2407.58, ["Mega"] = 10253.69}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4948.13, ["Ride"] = 4811.63, ["Fly|Ride"] = 4593.75, ["Neon|Fly|Ride"] = 21191.29, ["Mega|Fly|Ride"] = 68358.22}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 165.38, ["Ride"] = 183.75, ["Fly|Ride"] = 339.42, ["Neon"] = 820.32, ["Neon|Ride"] = 942.33, ["Neon|Fly|Ride"] = 1189.44, ["Mega"] = 4101.49, ["Mega|Fly|Ride"] = 3825.94}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 623.44, ["Fly"] = 820.32, ["Ride"] = 611.63, ["Fly|Ride"] = 656.25, ["Neon|Fly|Ride"] = 1519.88}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 7.66, ["Ride"] = 27.68, ["Fly|Ride"] = 155.67, ["Neon"] = 56.44, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 404.25, ["Mega"] = 328.13, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 582.75}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.44, ["Fly"] = 41.98, ["Ride"] = 26.25, ["Fly|Ride"] = 69.13, ["Neon"] = 23.66, ["Neon|Ride"] = 50.23, ["Neon|Fly|Ride"] = 109.74, ["Mega|Ride"] = 213.94, ["Mega|Fly|Ride"] = 276.24}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 96.57, ["Ride"] = 150.73, ["Fly|Ride"] = 240.19, ["Neon"] = 547.56, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 676.75, ["Mega|Fly|Ride"] = 2677.25}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 38.49, ["Fly"] = 97.67, ["Ride"] = 51.29, ["Fly|Ride"] = 77.84, ["Neon"] = 252, ["Neon|Ride"] = 302.5, ["Neon|Fly|Ride"] = 319.6, ["Mega"] = 2100, ["Mega|Ride"] = 1394.01, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 28.93, ["Fly"] = 59.07, ["Ride"] = 40.69, ["Fly|Ride"] = 66.94, ["Neon|Ride"] = 365.05, ["Neon|Fly|Ride"] = 282.19, ["Mega|Fly|Ride"] = 749.57}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 55.38, ["Fly"] = 108.71, ["Ride"] = 82.05, ["Fly|Ride"] = 177.19, ["Neon"] = 402.8, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 306.69, ["Mega|Fly|Ride"] = 1128.75}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 65.77}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 313.49, ["Fly"] = 339.94, ["Ride"] = 283.5, ["Fly|Ride"] = 349.53, ["Neon"] = 1332.99, ["Neon|Fly|Ride"] = 1122.19, ["Mega|Fly|Ride"] = 4843.86}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 140.44, ["Fly"] = 170.23, ["Ride"] = 114.35, ["Fly|Ride"] = 131.25, ["Neon|Fly|Ride"] = 650.1, ["Mega|Fly|Ride"] = 2981.99}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.37, ["Ride"] = 53.44, ["Fly|Ride"] = 131.24, ["Neon"] = 20.52, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 189, ["Mega"] = 124.69, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 272.76, ["Mega|Fly|Ride"] = 384.53}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 189.95, ["Fly"] = 219.18, ["Ride"] = 205.09, ["Fly|Ride"] = 230.51, ["Neon|Fly|Ride"] = 724.96, ["Mega"] = 3554.96, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.67, ["Fly"] = 27.81, ["Ride"] = 17.91, ["Fly|Ride"] = 41.03, ["Neon"] = 30.18, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 129.93, ["Mega|Ride"] = 326.82}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 88.64, ["Fly"] = 466.38, ["Ride"] = 136.5, ["Fly|Ride"] = 157.5, ["Neon"] = 342.49, ["Neon|Ride"] = 446.25, ["Neon|Fly|Ride"] = 485.63, ["Mega"] = 1763.65, ["Mega|Ride"] = 1364.77, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 45.25}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 61.68, ["Ride"] = 90.93, ["Fly|Ride"] = 210, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 1367.85, ["Mega|Fly|Ride"] = 2557.29}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 19.01, ["Fly"] = 41.03, ["Ride"] = 31.5, ["Fly|Ride"] = 109.74, ["Neon"] = 137.41, ["Neon|Ride"] = 278.82, ["Neon|Fly|Ride"] = 273.78, ["Mega|Ride"] = 955.66, ["Mega|Fly|Ride"] = 1640.61}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 50.53, ["Fly"] = 124.31, ["Ride"] = 60.38, ["Fly|Ride"] = 130.24, ["Neon"] = 244.13, ["Neon|Ride"] = 240.18, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 1626.34, ["Mega|Ride"] = 1367.85, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 39.26, ["Fly"] = 67.69, ["Ride"] = 189, ["Fly|Ride"] = 136.5, ["Neon"] = 208.69, ["Neon|Ride"] = 293.58, ["Neon|Fly|Ride"] = 363.56, ["Mega"] = 1158.68, ["Mega|Ride"] = 1299.16, ["Mega|Fly|Ride"] = 1244.81}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 20.55, ["Ride"] = 41.03, ["Fly|Ride"] = 84, ["Neon"] = 179.46, ["Neon|Ride"] = 410.17, ["Neon|Fly|Ride"] = 292.76, ["Mega"] = 818.26, ["Mega|Ride"] = 2050.76}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 39.16, ["Fly"] = 116.19, ["Ride"] = 57.75, ["Fly|Ride"] = 123.05, ["Neon"] = 420, ["Neon|Ride"] = 371.75, ["Neon|Fly|Ride"] = 322.88, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 903.42}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 3.92, ["Fly"] = 29.93, ["Ride"] = 19.68, ["Fly|Ride"] = 66.17, ["Neon"] = 43.78, ["Neon|Ride"] = 89.22, ["Neon|Fly|Ride"] = 100.48, ["Mega"] = 156.19, ["Mega|Fly"] = 302.5, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 329.65}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 417.56, ["Ride"] = 410.17, ["Fly|Ride"] = 480.11, ["Neon|Ride"] = 2973.58, ["Neon|Fly|Ride"] = 1964.82, ["Mega|Fly|Ride"] = 6822.82}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 12.77, ["Ride"] = 32.32, ["Fly|Ride"] = 105.18, ["Neon"] = 200.2, ["Neon|Ride"] = 137.41, ["Neon|Fly|Ride"] = 137.41, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 6.57, ["Fly"] = 34.54, ["Ride"] = 20.78, ["Fly|Ride"] = 38.98, ["Neon"] = 73.5, ["Neon|Ride"] = 69.71, ["Neon|Fly|Ride"] = 119.44, ["Mega|Ride"] = 287.12, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 75.5, ["Fly"] = 100.11, ["Ride"] = 97.54, ["Fly|Ride"] = 113.48, ["Neon"] = 410.17, ["Neon|Ride"] = 385.75, ["Neon|Fly|Ride"] = 426.14, ["Mega"] = 3281.2, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 1595.49}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 13.12, ["Ride"] = 24.62, ["Fly|Ride"] = 118.13, ["Neon"] = 96.41, ["Neon|Ride"] = 151.77, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 479.16, ["Mega|Ride"] = 781.35, ["Mega|Fly|Ride"] = 574.23}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 183.75, ["Fly"] = 342.49, ["Ride"] = 280.87, ["Fly|Ride"] = 315.38, ["Neon|Ride"] = 735, ["Neon|Fly|Ride"] = 963.86, ["Mega"] = 6152.22, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2939.75}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 65.42}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.2, ["Fly"] = 31.97, ["Ride"] = 22.58, ["Fly|Ride"] = 55.21, ["Neon"] = 27.69, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 105, ["Mega|Fly"] = 508.46, ["Mega|Ride"] = 182.44, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 918.74, ["Fly"] = 2625, ["Ride"] = 979, ["Fly|Ride"] = 1102.05, ["Neon"] = 7158.38, ["Neon|Fly|Ride"] = 4068.75, ["Mega|Ride"] = 52274.71, ["Mega|Fly|Ride"] = 15093.75}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 11.82, ["Fly"] = 68.72, ["Ride"] = 28.09, ["Fly|Ride"] = 105.73, ["Neon"] = 137.41, ["Neon|Ride"] = 118.09, ["Neon|Fly|Ride"] = 137.41, ["Mega"] = 787.5, ["Mega|Fly|Ride"] = 820.31}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 184.51, ["Ride"] = 191.02, ["Fly|Ride"] = 273.78, ["Neon"] = 1025.38, ["Neon|Ride"] = 891.01, ["Neon|Fly|Ride"] = 801.94, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 47.25}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 27.69, ["Fly"] = 273431.81, ["Ride"] = 52.31, ["Fly|Ride"] = 137.41, ["Neon"] = 104.36, ["Neon|Fly|Ride"] = 195.86, ["Mega"] = 684.53, ["Mega|Fly|Ride"] = 761.25}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 139.13, ["Ride"] = 131.25, ["Fly|Ride"] = 263.7, ["Neon|Ride"] = 547.56, ["Neon|Fly|Ride"] = 683.93, ["Mega|Fly|Ride"] = 2355.94}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 162.02, ["Ride"] = 198.19, ["Fly|Ride"] = 273.78, ["Neon"] = 388, ["Neon|Ride"] = 533.21, ["Neon|Fly|Ride"] = 590.63, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1948.22}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 40.26}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 62.63, ["Fly"] = 61.35, ["Ride"] = 53.44, ["Fly|Ride"] = 85.71, ["Neon|Ride"] = 371.75, ["Neon|Fly|Ride"] = 365.14, ["Mega"] = 4101.49, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 8.86, ["Ride"] = 26.17, ["Fly|Ride"] = 131.25, ["Neon"] = 51.28, ["Neon|Ride"] = 151.77, ["Neon|Fly|Ride"] = 230.73, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 273.78}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 525, ["Fly"] = 550.62, ["Ride"] = 465.51, ["Fly|Ride"] = 511.87, ["Neon|Fly|Ride"] = 1572.94, ["Mega|Fly|Ride"] = 7376.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 87.94, ["Fly"] = 162.02, ["Ride"] = 115.49, ["Fly|Ride"] = 194.13, ["Neon"] = 459.38, ["Neon|Ride"] = 770.44, ["Neon|Fly|Ride"] = 616.88, ["Mega|Ride"] = 2459.87, ["Mega|Fly|Ride"] = 2317.34}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 6972.51, ["Ride"] = 3596.25, ["Fly|Ride"] = 3675, ["Neon|Fly|Ride"] = 14354.15}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 47.99, ["Fly"] = 112.1, ["Ride"] = 49.88, ["Fly|Ride"] = 128.43, ["Neon|Ride"] = 774.85, ["Neon|Fly|Ride"] = 403.11, ["Mega"] = 1299.16, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 155.67, ["Ride"] = 78.75, ["Fly|Ride"] = 136.99, ["Neon"] = 410.17, ["Neon|Ride"] = 683.93, ["Neon|Fly|Ride"] = 525, ["Mega"] = 2734.67, ["Mega|Ride"] = 2598.29, ["Mega|Fly|Ride"] = 2973.41}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 32.81, ["Fly"] = 65.63, ["Ride"] = 53.48, ["Fly|Ride"] = 100.72, ["Neon"] = 262.5, ["Neon|Ride"] = 202.14, ["Neon|Fly|Ride"] = 209.98, ["Mega"] = 2625, ["Mega|Ride"] = 724.96, ["Mega|Fly|Ride"] = 655.46}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 9.14}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 47.23, ["Fly"] = 61.53, ["Ride"] = 61.53, ["Fly|Ride"] = 64.95, ["Neon|Fly|Ride"] = 547.56}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 45.54}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 223.13, ["Ride"] = 223.13, ["Fly|Ride"] = 313.78, ["Neon|Ride"] = 1367.85, ["Neon|Fly|Ride"] = 1367.85}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 1435.53, ["Ride"] = 957.71, ["Fly|Ride"] = 1239.48, ["Neon"] = 2887.5, ["Neon|Fly|Ride"] = 3018.75, ["Mega|Fly|Ride"] = 13672.26}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 9.18}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 20.88, ["Fly"] = 52.5, ["Ride"] = 45.94, ["Fly|Ride"] = 64.11, ["Neon"] = 160.78, ["Neon|Ride"] = 166.68, ["Neon|Fly|Ride"] = 223.13, ["Mega|Fly|Ride"] = 971.25}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 15.62}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 6152.22, ["Ride"] = 6455.73, ["Fly|Ride"] = 4608.19, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 37173.12}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 12.75, ["Fly"] = 52.41, ["Ride"] = 23.39, ["Fly|Ride"] = 63.7, ["Neon"] = 102.55, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 203.54, ["Mega"] = 787.5, ["Mega|Ride"] = 508.59, ["Mega|Fly|Ride"] = 588.58}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 14.43, ["Fly"] = 190.74, ["Ride"] = 32.83, ["Fly|Ride"] = 273.78, ["Neon"] = 68.72, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 721.88, ["Mega|Ride"] = 519.75}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 116.91, ["Fly"] = 276.59, ["Ride"] = 91.88, ["Fly|Ride"] = 140.21, ["Neon|Fly|Ride"] = 480.96, ["Mega"] = 4101.49}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 12.56, ["Fly"] = 150.93, ["Ride"] = 30.41, ["Fly|Ride"] = 78.75, ["Neon"] = 77.18, ["Neon|Ride"] = 137.41, ["Neon|Fly|Ride"] = 137.41, ["Mega|Ride"] = 731.08, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1903.02, ["Fly"] = 2219.87, ["Ride"] = 1785, ["Fly|Ride"] = 1876.87, ["Neon|Fly|Ride"] = 3530.63, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 26250, ["Ride"] = 52500, ["Fly|Ride"] = 26117.44, ["Neon|Fly|Ride"] = 77444.38, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183750}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 16.95, ["Fly"] = 393.74, ["Ride"] = 55.13, ["Fly|Ride"] = 124.69, ["Neon"] = 266.61, ["Neon|Ride"] = 273.78, ["Neon|Fly|Ride"] = 273.78, ["Mega"] = 957.71, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 816.21}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.1, ["Fly"] = 65.63, ["Ride"] = 41.03, ["Fly|Ride"] = 158.9, ["Neon"] = 18.47, ["Neon|Ride"] = 65.03, ["Neon|Fly|Ride"] = 120.02, ["Mega|Ride"] = 253.32, ["Mega|Fly|Ride"] = 331.54}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 20.52}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.77, ["Ride"] = 32, ["Fly|Ride"] = 131.25, ["Neon"] = 61.53, ["Neon|Ride"] = 161.48, ["Neon|Fly|Ride"] = 273.78, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 546.48}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 708.75, ["Ride"] = 735, ["Fly|Ride"] = 918.75, ["Neon"] = 2323.27, ["Neon|Fly|Ride"] = 2563.43, ["Mega|Fly|Ride"] = 8662.5}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 905.61, ["Fly"] = 975.19, ["Ride"] = 918.65, ["Fly|Ride"] = 1040.82, ["Neon|Fly|Ride"] = 3109.31}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 23.25, ["Fly"] = 116.19, ["Ride"] = 34.89, ["Fly|Ride"] = 85.32, ["Neon"] = 137.41, ["Neon|Ride"] = 273.78, ["Neon|Fly|Ride"] = 205.09, ["Mega"] = 1204.13, ["Mega|Ride"] = 685.13, ["Mega|Fly|Ride"] = 594.72}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 32.82}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 78.54, ["Fly"] = 96.41, ["Ride"] = 75.51, ["Fly|Ride"] = 104.9, ["Neon"] = 460.41, ["Neon|Ride"] = 403.59, ["Neon|Fly|Ride"] = 410.17, ["Mega|Fly|Ride"] = 1664.25}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 65.77, ["Ride"] = 78.75, ["Fly|Ride"] = 228.38, ["Neon"] = 450.19, ["Neon|Ride"] = 287.28, ["Neon|Fly|Ride"] = 547.56, ["Mega"] = 1334.41, ["Mega|Fly|Ride"] = 1758.75}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.61, ["Fly"] = 44.16, ["Ride"] = 17.21, ["Fly|Ride"] = 58.1, ["Neon"] = 55.38, ["Neon|Ride"] = 102.38, ["Neon|Fly|Ride"] = 130.24, ["Mega|Ride"] = 295.32, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 115.76, ["Fly"] = 158.81, ["Ride"] = 137.41, ["Fly|Ride"] = 210, ["Neon"] = 464.67, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 1569.75}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 4.11, ["Ride"] = 39.38, ["Fly|Ride"] = 262.5, ["Neon"] = 33.77, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 477.84, ["Mega"] = 248.07, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 539.37}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 12.04, ["Fly"] = 41.22, ["Ride"] = 32.69, ["Fly|Ride"] = 52.5, ["Neon"] = 85.32, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 302.5, ["Mega"] = 762.88, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 32.71, ["Ride"] = 55.38, ["Fly|Ride"] = 156.19, ["Neon"] = 278.81, ["Neon|Fly|Ride"] = 410.17, ["Mega|Ride"] = 774.84, ["Mega|Fly|Ride"] = 1014.85}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 11.71, ["Fly"] = 169.81, ["Ride"] = 35.79, ["Fly|Ride"] = 70.88, ["Neon"] = 91.88, ["Neon|Ride"] = 113.44, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 885.93, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6956.25, ["Ride"] = 7141.32, ["Fly|Ride"] = 5494.13, ["Neon"] = 30761.05, ["Neon|Fly|Ride"] = 27192.78, ["Mega|Fly|Ride"] = 92932.79}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 233.63, ["Fly"] = 267.75, ["Ride"] = 256.2, ["Fly|Ride"] = 278.25, ["Neon|Fly|Ride"] = 640.97, ["Mega|Fly|Ride"] = 2063.25}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 41.99, ["Fly"] = 315, ["Ride"] = 85.3, ["Fly|Ride"] = 162.86, ["Neon"] = 121.95, ["Neon|Ride"] = 166.98, ["Neon|Fly|Ride"] = 265.13, ["Mega"] = 393.74, ["Mega|Fly"] = 573.2, ["Mega|Ride"] = 433.89, ["Mega|Fly|Ride"] = 500.06}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 85.97, ["Ride"] = 23.25, ["Fly|Ride"] = 105.73, ["Neon"] = 24.98, ["Neon|Ride"] = 149.87, ["Neon|Fly|Ride"] = 186.63, ["Mega"] = 330.75, ["Mega|Ride"] = 187.69}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 57.74, ["Fly"] = 5265.65, ["Ride"] = 85.22, ["Fly|Ride"] = 342.49, ["Neon"] = 211.87, ["Neon|Ride"] = 233.87, ["Neon|Fly|Ride"] = 311.56, ["Mega|Fly|Ride"] = 622.96}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 15585.61, ["Ride"] = 11943.75, ["Fly|Ride"] = 11811.19, ["Neon|Fly|Ride"] = 22312.5}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 205.09, ["Ride"] = 295.54, ["Fly|Ride"] = 343.08, ["Neon"] = 1503.21, ["Neon|Fly|Ride"] = 1538.07, ["Mega"] = 5469.33, ["Mega|Fly|Ride"] = 5824.11}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 59.75, ["Fly"] = 74.82, ["Ride"] = 77.35, ["Fly|Ride"] = 101.58, ["Neon|Ride"] = 410.17, ["Neon|Fly|Ride"] = 275.63, ["Mega|Fly|Ride"] = 2734.67}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 7.85, ["Fly"] = 44.16, ["Ride"] = 23.28, ["Fly|Ride"] = 72.1, ["Neon"] = 140.44, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 149.63, ["Mega"] = 295.32, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 387.09, ["Ride"] = 464.67, ["Fly|Ride"] = 484.31, ["Neon"] = 1735.55, ["Neon|Ride"] = 1913.36, ["Neon|Fly|Ride"] = 1719.38, ["Mega|Fly|Ride"] = 5011.13}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 5.25, ["Fly"] = 27.69, ["Ride"] = 37.68, ["Fly|Ride"] = 84.96, ["Neon"] = 26.25, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 178.43, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 155.3, ["Fly"] = 211.43, ["Ride"] = 131.25, ["Fly|Ride"] = 205.09, ["Neon"] = 449.13, ["Neon|Ride"] = 683.93, ["Neon|Fly|Ride"] = 540.39, ["Mega|Fly|Ride"] = 2627.05}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.25, ["Fly"] = 18.08, ["Ride"] = 17.85, ["Fly|Ride"] = 41.03, ["Neon|Ride"] = 116.19, ["Neon|Fly|Ride"] = 137.41, ["Mega"] = 874.13, ["Mega|Fly|Ride"] = 957.71}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 10.27}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 74.82, ["Fly"] = 137.41, ["Ride"] = 86.63, ["Fly|Ride"] = 196.88, ["Neon"] = 421.32, ["Neon|Fly|Ride"] = 446.25, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1778}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 15.7, ["Fly"] = 101.53, ["Ride"] = 51.28, ["Fly|Ride"] = 89.25, ["Neon"] = 123.05, ["Neon|Ride"] = 168, ["Neon|Fly|Ride"] = 245.44, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 22.98}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 47.16, ["Fly"] = 210, ["Ride"] = 91.88, ["Fly|Ride"] = 249.38, ["Neon"] = 137.41, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 410.17, ["Mega"] = 1538.07, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 4.79, ["Ride"] = 29.23, ["Neon"] = 27.69, ["Neon|Fly|Ride"] = 273.78, ["Mega|Fly|Ride"] = 196.87}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 14.23, ["Fly"] = 47.25, ["Ride"] = 30.19, ["Fly|Ride"] = 96.41, ["Neon|Ride"] = 137.41, ["Neon|Fly|Ride"] = 211.01, ["Mega|Fly|Ride"] = 590.28}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 507.57, ["Ride"] = 452.61, ["Fly|Ride"] = 541.66, ["Neon|Fly|Ride"] = 2727.5, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 39.86, ["Ride"] = 55.11, ["Fly|Ride"] = 82.05, ["Neon"] = 234.67, ["Neon|Fly|Ride"] = 314.81, ["Mega"] = 1007.18, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 1365}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 58.45, ["Fly"] = 117.49, ["Ride"] = 96.41, ["Fly|Ride"] = 131.15, ["Neon"] = 273.78, ["Neon|Ride"] = 434.48, ["Neon|Fly|Ride"] = 437.07, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 52.45, ["Fly"] = 96.64, ["Ride"] = 70.88, ["Fly|Ride"] = 137.41, ["Neon"] = 96.41, ["Neon|Ride"] = 205.09, ["Neon|Fly|Ride"] = 319.93, ["Mega|Fly|Ride"] = 644.43}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 8400, ["Ride"] = 13320.36, ["Fly|Ride"] = 8268.75, ["Neon|Fly|Ride"] = 16300.6}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1509.38, ["Ride"] = 1391.24, ["Fly|Ride"] = 1606.5, ["Neon|Fly|Ride"] = 4960.15, ["Mega|Fly|Ride"] = 17771.7}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 459.38, ["Ride"] = 738.27, ["Fly|Ride"] = 656.25, ["Neon"] = 4338.65, ["Neon|Fly|Ride"] = 2062.55, ["Mega|Fly|Ride"] = 6822.82}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 12.08, ["Fly"] = 20.9, ["Ride"] = 21.6, ["Fly|Ride"] = 52.37, ["Neon"] = 110.25, ["Neon|Ride"] = 137.41, ["Neon|Fly|Ride"] = 96.41, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 3.94, ["Fly"] = 78.74, ["Ride"] = 26.25, ["Fly|Ride"] = 88.19, ["Neon"] = 27.57, ["Neon|Ride"] = 137.41, ["Neon|Fly|Ride"] = 205.09, ["Mega|Fly|Ride"] = 257.27}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 46.83, ["Fly"] = 72.31, ["Ride"] = 54.12, ["Fly|Ride"] = 101.12, ["Neon"] = 522.77, ["Neon|Ride"] = 195.57, ["Neon|Fly|Ride"] = 189.84, ["Mega|Fly|Ride"] = 551.15}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.82, ["Fly"] = 26.67, ["Ride"] = 15.64, ["Fly|Ride"] = 39.26, ["Neon"] = 27.69, ["Neon|Ride"] = 55.38, ["Neon|Fly|Ride"] = 91.88, ["Mega|Ride"] = 205.09}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 393.75, ["Fly"] = 369.49, ["Ride"] = 341.2, ["Fly|Ride"] = 410.82, ["Neon|Fly|Ride"] = 1311.19, ["Mega|Fly|Ride"] = 4649.03}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 23.61, ["Fly"] = 60.59, ["Ride"] = 33.5, ["Fly|Ride"] = 88.19, ["Neon"] = 91.88, ["Neon|Ride"] = 217.4, ["Neon|Fly|Ride"] = 191.76, ["Mega"] = 598.83, ["Mega|Ride"] = 525}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 10.49, ["Fly"] = 18.38, ["Ride"] = 19.69, ["Fly|Ride"] = 43.09, ["Neon"] = 137.41, ["Neon|Ride"] = 80.56, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 446.25, ["Fly"] = 787.5, ["Ride"] = 446.25, ["Fly|Ride"] = 683.93, ["Neon|Fly|Ride"] = 2788, ["Mega|Fly|Ride"] = 8619.21}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1317.75, ["Ride"] = 1154.9, ["Fly|Ride"] = 1312.5, ["Neon"] = 4785.4, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13782.3}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 115.88, ["Fly"] = 136.19, ["Ride"] = 103.69, ["Fly|Ride"] = 133.88, ["Neon"] = 971.25, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 3562.82}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 159.92, ["Fly"] = 198.94, ["Ride"] = 169.32, ["Fly|Ride"] = 242.82, ["Neon"] = 577.5, ["Neon|Ride"] = 793.07, ["Neon|Fly|Ride"] = 762.46, ["Mega|Ride"] = 8603.44, ["Mega|Fly|Ride"] = 2673.57}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 27.26, ["Ride"] = 53.82, ["Fly|Ride"] = 118.58, ["Neon"] = 262.65, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 410.17, ["Mega|Ride"] = 2050.76, ["Mega|Fly|Ride"] = 876.7}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 215.75, ["Ride"] = 273.78, ["Fly|Ride"] = 547.56, ["Neon|Fly|Ride"] = 1301.08, ["Mega|Fly|Ride"] = 3691.33}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2188.15, ["Ride"] = 2483.25, ["Fly|Ride"] = 2188.15, ["Neon|Fly|Ride"] = 10253.69, ["Mega|Fly|Ride"] = 27879.85}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 78.75, ["Ride"] = 83.53, ["Fly|Ride"] = 196.88, ["Neon"] = 511.88, ["Neon|Fly|Ride"] = 343.87, ["Mega|Ride"] = 2255.82, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 656.25, ["Ride"] = 643.12, ["Fly|Ride"] = 691.69, ["Neon|Ride"] = 1626.36, ["Neon|Fly|Ride"] = 1305.93, ["Mega|Fly|Ride"] = 3358.64}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 44.7, ["Fly"] = 59.07, ["Ride"] = 61.04, ["Fly|Ride"] = 97.13, ["Neon|Fly|Ride"] = 303.19, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 2.58, ["Fly"] = 46.02, ["Ride"] = 20.93, ["Fly|Ride"] = 55.04, ["Neon"] = 19.31, ["Neon|Ride"] = 45.13, ["Neon|Fly|Ride"] = 107.62, ["Mega|Fly"] = 248.99, ["Mega|Ride"] = 180.93, ["Mega|Fly|Ride"] = 307.13}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 51.93, ["Ride"] = 123.05, ["Fly|Ride"] = 253.32, ["Neon"] = 338.39, ["Neon|Fly|Ride"] = 683.93, ["Mega"] = 1499.11, ["Mega|Fly|Ride"] = 1429.16}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 866.25, ["Fly"] = 1016.44, ["Ride"] = 834.75, ["Fly|Ride"] = 905.63, ["Neon|Ride"] = 2886.19, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 9631.13}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 656.25, ["Ride"] = 779.29, ["Fly|Ride"] = 882.84, ["Neon|Fly|Ride"] = 4047.14, ["Mega|Fly|Ride"] = 14765.31}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 12.18, ["Fly"] = 26.25, ["Ride"] = 25.73, ["Fly|Ride"] = 39.38, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 196.77, ["Mega"] = 786.19, ["Mega|Fly|Ride"] = 681.29}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 8.22, ["Ride"] = 30.78, ["Fly|Ride"] = 59.07, ["Neon"] = 89.77, ["Neon|Ride"] = 123.05, ["Neon|Fly|Ride"] = 178.43, ["Mega"] = 374.07, ["Mega|Ride"] = 410.17}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 4.09, ["Ride"] = 24.93, ["Fly|Ride"] = 111.56, ["Neon"] = 21.19, ["Neon|Ride"] = 54.46, ["Neon|Fly|Ride"] = 243.96, ["Mega|Fly"] = 527.41, ["Mega|Ride"] = 244.02, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 47.19, ["Fly"] = 53.82, ["Ride"] = 81.03, ["Fly|Ride"] = 111.57, ["Neon"] = 229.69, ["Neon|Ride"] = 211.23, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 952.91}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 65.54, ["Ride"] = 133.84, ["Fly|Ride"] = 620.32, ["Neon"] = 419.83, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1504.22, ["Mega|Ride"] = 1538.07, ["Mega|Fly|Ride"] = 1495.01}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 15.58, ["Fly"] = 59.06, ["Ride"] = 34.8, ["Fly|Ride"] = 99.92, ["Neon"] = 82.7, ["Neon|Ride"] = 117.85, ["Neon|Fly|Ride"] = 205.09, ["Mega"] = 408.11, ["Mega|Ride"] = 352.96, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 27.75, ["Fly"] = 56.01, ["Ride"] = 45.73, ["Fly|Ride"] = 88.78, ["Neon"] = 547.56, ["Neon|Ride"] = 205.09, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 2100, ["Mega|Ride"] = 957.71, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.64, ["Fly"] = 27.69, ["Ride"] = 17.07, ["Fly|Ride"] = 55.13, ["Neon"] = 24.03, ["Neon|Ride"] = 60.38, ["Neon|Fly|Ride"] = 91.72, ["Mega"] = 525, ["Mega|Ride"] = 464.68, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 4.87, ["Fly"] = 40.63, ["Ride"] = 31.38, ["Fly|Ride"] = 1312.5, ["Neon"] = 25.99, ["Neon|Ride"] = 78.66, ["Neon|Fly|Ride"] = 151.77, ["Mega"] = 246.09, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 58.44, ["Fly"] = 65.62, ["Ride"] = 62.23, ["Fly|Ride"] = 94.5, ["Neon"] = 403.1, ["Neon|Ride"] = 289, ["Neon|Fly|Ride"] = 272.54, ["Mega|Fly|Ride"] = 1070.46}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1443.75, ["Fly"] = 1903.13, ["Ride"] = 1650.33, ["Fly|Ride"] = 1574.99, ["Neon|Fly|Ride"] = 3804.94, ["Mega|Fly|Ride"] = 13480.61}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 393.75, ["Fly"] = 479.64, ["Ride"] = 393.65, ["Fly|Ride"] = 598.91, ["Neon|Fly|Ride"] = 3008.44, ["Mega|Fly|Ride"] = 9570.8}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 241.95, ["Ride"] = 325.26, ["Fly|Ride"] = 392.44, ["Neon"] = 1500.12, ["Neon|Ride"] = 1550.85, ["Neon|Fly|Ride"] = 1586.25}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 48.2}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 29.59, ["Ride"] = 47.14, ["Fly|Ride"] = 98.43, ["Neon|Ride"] = 205.09, ["Neon|Fly|Ride"] = 464.68, ["Mega|Ride"] = 1367.85}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 71092.88, ["Fly"] = 65625, ["Ride"] = 34848.72, ["Fly|Ride"] = 17979.94, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 315, ["Fly"] = 354.8, ["Ride"] = 485.63, ["Fly|Ride"] = 438.87, ["Neon"] = 1365.8, ["Neon|Ride"] = 984.96, ["Neon|Fly|Ride"] = 1127.93, ["Mega"] = 6152.22, ["Mega|Fly|Ride"] = 3850.97}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 167.9, ["Fly"] = 525, ["Ride"] = 137.67, ["Fly|Ride"] = 203.44, ["Mega|Fly|Ride"] = 4101.49}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 137.41, ["Fly"] = 262.5, ["Ride"] = 124.69, ["Fly|Ride"] = 200.82, ["Neon|Ride"] = 547.56, ["Neon|Fly|Ride"] = 410.17, ["Mega|Fly|Ride"] = 2460.89}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 11.45, ["Fly"] = 94.5, ["Ride"] = 33.67, ["Fly|Ride"] = 108.94, ["Neon"] = 393.75, ["Neon|Ride"] = 151.77, ["Neon|Fly|Ride"] = 272.76, ["Mega"] = 694.68, ["Mega|Fly|Ride"] = 629.58}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 5019.19, ["Ride"] = 5019.19, ["Fly|Ride"] = 5047.77, ["Neon"] = 20507.37, ["Neon|Fly|Ride"] = 27343.5, ["Mega|Fly|Ride"] = 61955.98}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 25.87, ["Fly"] = 39.36, ["Ride"] = 29.01, ["Fly|Ride"] = 58.73, ["Neon"] = 337.32, ["Neon|Fly|Ride"] = 263.71, ["Mega|Fly|Ride"] = 819.29}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 43.32, ["Ride"] = 56.26, ["Fly|Ride"] = 91.87, ["Neon"] = 403.96, ["Neon|Ride"] = 232.78, ["Neon|Fly|Ride"] = 389.66, ["Mega|Fly|Ride"] = 1372.88}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 682.5, ["Fly"] = 918.75, ["Ride"] = 708.75, ["Fly|Ride"] = 888.57, ["Neon|Fly|Ride"] = 2441.25, ["Mega"] = 7443.16, ["Mega|Fly"] = 7443.16, ["Mega|Fly|Ride"] = 7443.16}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 12.78, ["Fly"] = 26.14, ["Ride"] = 25.73, ["Fly|Ride"] = 47.77, ["Neon"] = 131.25, ["Neon|Ride"] = 232.32, ["Neon|Fly|Ride"] = 137.41, ["Mega|Fly|Ride"] = 852.68}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 15.4, ["Ride"] = 31.31, ["Fly|Ride"] = 77.84, ["Neon"] = 79.99, ["Neon|Ride"] = 189.37, ["Neon|Fly|Ride"] = 178.43, ["Mega"] = 406.06}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 94.49, ["Ride"] = 115.88, ["Fly|Ride"] = 137.41, ["Neon"] = 615.23, ["Neon|Ride"] = 980.27, ["Neon|Fly|Ride"] = 594.72, ["Mega|Fly|Ride"] = 2596.25}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 10.27, ["Fly"] = 137.41, ["Ride"] = 55.38, ["Fly|Ride"] = 166.13, ["Neon"] = 101.07, ["Neon|Ride"] = 118.26, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 254.63, ["Mega|Fly"] = 737.67, ["Mega|Ride"] = 276.28, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 4243.32, ["Ride"] = 3883.64, ["Fly|Ride"] = 4000.5, ["Neon|Fly|Ride"] = 9581.25, ["Mega"] = 61521.07, ["Mega|Fly|Ride"] = 35314.47}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 34.79, ["Ride"] = 78.75, ["Fly|Ride"] = 190.52, ["Neon"] = 393.32, ["Neon|Ride"] = 250.49, ["Neon|Fly|Ride"] = 410.17, ["Mega|Fly|Ride"] = 1812.2}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 6693.75, ["Ride"] = 6857.82, ["Fly|Ride"] = 6339.37, ["Neon|Fly|Ride"] = 17061.19, ["Mega|Fly|Ride"] = 76902.6}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.28, ["Fly"] = 16.27, ["Ride"] = 16.94, ["Fly|Ride"] = 42, ["Neon"] = 24.62, ["Neon|Ride"] = 91.27, ["Neon|Fly|Ride"] = 84.18, ["Mega"] = 449.57, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 13.97, ["Fly"] = 26.17, ["Ride"] = 26.25, ["Fly|Ride"] = 31.5, ["Neon"] = 135.36, ["Neon|Fly|Ride"] = 167.99, ["Mega|Ride"] = 1247.55, ["Mega|Fly|Ride"] = 708.54}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.94}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 19.5, ["Ride"] = 33.24, ["Fly|Ride"] = 116.01, ["Neon"] = 271.23, ["Neon|Ride"] = 137.41, ["Neon|Fly|Ride"] = 191.76, ["Mega"] = 1049.9, ["Mega|Ride"] = 957.71, ["Mega|Fly|Ride"] = 771.83}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 28.88, ["Fly"] = 190.37, ["Ride"] = 43.09, ["Fly|Ride"] = 99.73, ["Neon"] = 200.99, ["Neon|Ride"] = 314.81, ["Neon|Fly|Ride"] = 310.19, ["Mega"] = 945, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 10.62, ["Fly"] = 19.69, ["Ride"] = 19.69, ["Fly|Ride"] = 37.88, ["Neon|Ride"] = 113.82, ["Neon|Fly|Ride"] = 175.18, ["Mega"] = 654.94, ["Mega|Ride"] = 579.68, ["Mega|Fly|Ride"] = 507.41}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8304.45}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.96}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 27.9}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 177.09, ["Ride"] = 196.88, ["Fly|Ride"] = 183.75, ["Neon|Fly|Ride"] = 1025.38, ["Mega|Fly|Ride"] = 5537}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 13.13, ["Fly"] = 129.21, ["Ride"] = 40.07, ["Fly|Ride"] = 105, ["Neon"] = 139.41, ["Neon|Ride"] = 190.74, ["Neon|Fly|Ride"] = 265.13, ["Mega|Ride"] = 929.34, ["Mega|Fly|Ride"] = 955.66}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 15.4}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 4.87, ["Ride"] = 29.22, ["Fly|Ride"] = 79.99, ["Neon"] = 102.9, ["Neon|Ride"] = 178.43, ["Neon|Fly|Ride"] = 140.24, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 3051.63}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 188.28, ["Fly"] = 410.17, ["Ride"] = 204.06, ["Fly|Ride"] = 301.88, ["Neon"] = 701.37, ["Mega|Fly|Ride"] = 3419.61}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 68.72, ["Ride"] = 144.38, ["Fly|Ride"] = 166.85, ["Neon"] = 683.93, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1435.35, ["Mega|Fly|Ride"] = 2188.15}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 170.63, ["Fly"] = 265.49, ["Ride"] = 207.38, ["Fly|Ride"] = 255.59, ["Neon"] = 897.75, ["Neon|Fly|Ride"] = 849.79, ["Mega|Fly|Ride"] = 4027.49}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1967.44, ["Fly"] = 2460.89, ["Ride"] = 1968.75, ["Fly|Ride"] = 1968.75, ["Neon"] = 8131.37, ["Neon|Fly|Ride"] = 6028.32, ["Mega|Fly|Ride"] = 24472.47}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 17.05, ["Fly"] = 96.41, ["Ride"] = 56.8, ["Fly|Ride"] = 69.02, ["Neon"] = 170.23, ["Neon|Fly|Ride"] = 260.46, ["Mega"] = 921.83, ["Mega|Ride"] = 852.68, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 875.88, ["Fly"] = 2100, ["Ride"] = 889.01, ["Fly|Ride"] = 922.84, ["Neon|Fly|Ride"] = 4027.49}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 52.44}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 15.75, ["Ride"] = 39.38, ["Fly|Ride"] = 680.86, ["Neon"] = 105, ["Neon|Ride"] = 117.93, ["Neon|Fly|Ride"] = 302.5, ["Mega"] = 480.27, ["Mega|Ride"] = 464.68, ["Mega|Fly|Ride"] = 700.88}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 6.57, ["Fly"] = 162.24, ["Ride"] = 27.56, ["Fly|Ride"] = 94.83, ["Neon"] = 62.74, ["Neon|Ride"] = 81.34, ["Neon|Fly|Ride"] = 273.78, ["Mega"] = 918.75, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 72.19}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 14.56, ["Ride"] = 22.32, ["Fly|Ride"] = 79.99, ["Neon"] = 191.76, ["Neon|Fly|Ride"] = 170.63, ["Mega|Fly|Ride"] = 1506.86}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 21.49, ["Fly"] = 51.28, ["Ride"] = 41.03, ["Fly|Ride"] = 70.88, ["Neon"] = 232.78, ["Neon|Ride"] = 294.3, ["Neon|Fly|Ride"] = 302.5, ["Mega"] = 876.7, ["Mega|Ride"] = 1742.5, ["Mega|Fly|Ride"] = 957.71}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6300, ["Fly"] = 10937.61, ["Ride"] = 5250, ["Fly|Ride"] = 5158.13, ["Neon|Fly|Ride"] = 11550, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 10.5, ["Fly"] = 57.29, ["Ride"] = 32.82, ["Fly|Ride"] = 105, ["Neon"] = 60.8, ["Neon|Ride"] = 62.75, ["Neon|Fly|Ride"] = 191.76, ["Mega"] = 520.44, ["Mega|Ride"] = 383.25, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 22.31}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 94.64, ["Fly"] = 363, ["Ride"] = 135.19, ["Fly|Ride"] = 210, ["Neon"] = 525, ["Neon|Ride"] = 378, ["Neon|Fly|Ride"] = 733.02, ["Mega"] = 2879.59, ["Mega|Fly|Ride"] = 1926.64}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 52.5, ["Fly"] = 124.31, ["Ride"] = 93.48, ["Fly|Ride"] = 273.78, ["Neon"] = 262.5, ["Neon|Ride"] = 437.07, ["Neon|Fly|Ride"] = 396.83, ["Mega"] = 2323.34, ["Mega|Ride"] = 2768.51, ["Mega|Fly|Ride"] = 1537.04}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 19.32, ["Fly"] = 70.47, ["Ride"] = 31.4, ["Fly|Ride"] = 65.63, ["Neon"] = 128.77, ["Neon|Ride"] = 205.09, ["Neon|Fly|Ride"] = 174.91, ["Mega"] = 1016.21, ["Mega|Ride"] = 835.7, ["Mega|Fly|Ride"] = 656.24}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 3.9, ["Fly"] = 65.63, ["Ride"] = 22.32, ["Fly|Ride"] = 65, ["Neon"] = 33.11, ["Neon|Ride"] = 71.85, ["Neon|Fly|Ride"] = 178.43, ["Mega"] = 171.2, ["Mega|Fly"] = 254.63, ["Mega|Ride"] = 219.58, ["Mega|Fly|Ride"] = 307.51}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 13.67, ["Ride"] = 31.38, ["Fly|Ride"] = 65.63, ["Neon"] = 115.88, ["Neon|Ride"] = 137.41, ["Neon|Fly|Ride"] = 219.44, ["Mega"] = 720.25, ["Mega|Ride"] = 422.63, ["Mega|Fly|Ride"] = 627.54}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 18.37, ["Fly"] = 22.58, ["Ride"] = 22.58, ["Fly|Ride"] = 52.5, ["Neon"] = 205.09, ["Neon|Ride"] = 346.5, ["Neon|Fly|Ride"] = 131.25, ["Mega|Fly|Ride"] = 707.52}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 227.07}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 29.4, ["Ride"] = 291.38, ["Fly|Ride"] = 274.31, ["Neon"] = 147.54, ["Neon|Ride"] = 820.32, ["Mega"] = 820.32, ["Mega|Fly|Ride"] = 786.19}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 219.44, ["Ride"] = 443.63, ["Fly|Ride"] = 1549.62, ["Neon"] = 1094.09}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 46.3, ["Fly"] = 212.02, ["Ride"] = 122.04, ["Fly|Ride"] = 235.85, ["Neon"] = 259.87, ["Neon|Ride"] = 295.32, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 1020.26, ["Mega|Fly|Ride"] = 1207.89}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 984.38, ["Fly"] = 1334.47, ["Ride"] = 986.12, ["Fly|Ride"] = 1029, ["Neon|Ride"] = 3281.25, ["Neon|Fly|Ride"] = 2625}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 380.63, ["Fly"] = 683.93, ["Ride"] = 433.13, ["Fly|Ride"] = 486.94, ["Neon"] = 2871.05, ["Neon|Ride"] = 7382.66, ["Neon|Fly|Ride"] = 1915.4, ["Mega|Fly|Ride"] = 7217.44}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 102.54}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 14.44, ["Fly"] = 55.38, ["Ride"] = 25.73, ["Fly|Ride"] = 50.16, ["Neon"] = 78.73, ["Neon|Ride"] = 94.35, ["Neon|Fly|Ride"] = 157.4, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 315, ["Fly"] = 410.17, ["Ride"] = 328.13, ["Fly|Ride"] = 436.83, ["Neon"] = 1085.88, ["Neon|Ride"] = 984.37, ["Neon|Fly|Ride"] = 1114.59, ["Mega|Fly|Ride"] = 2756.25}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 19.49}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 135.01, ["Ride"] = 183.23, ["Fly|Ride"] = 295.32, ["Neon"] = 874.13, ["Neon|Fly|Ride"] = 1739.07, ["Mega"] = 3008.44, ["Mega|Ride"] = 11664.6, ["Mega|Fly|Ride"] = 2998.2}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 127.32, ["Fly"] = 138.44, ["Ride"] = 125.89, ["Fly|Ride"] = 205.09, ["Neon"] = 683.93, ["Neon|Ride"] = 2255.82, ["Neon|Fly|Ride"] = 913.5, ["Mega|Fly|Ride"] = 2407.58}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 5.23, ["Ride"] = 26.09, ["Fly|Ride"] = 167.15, ["Neon"] = 36.74, ["Neon|Fly|Ride"] = 226.63, ["Mega"] = 264.75, ["Mega|Ride"] = 509.99, ["Mega|Fly|Ride"] = 818.26}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 17.77, ["Fly"] = 63.03, ["Ride"] = 26.64, ["Fly|Ride"] = 71.78, ["Neon"] = 177.19, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 310.19, ["Mega|Fly|Ride"] = 615.23}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 18.38, ["Fly"] = 131.25, ["Ride"] = 64.32, ["Fly|Ride"] = 116.91, ["Neon"] = 105, ["Neon|Ride"] = 204.46, ["Neon|Fly|Ride"] = 255.94, ["Mega"] = 498.65, ["Mega|Ride"] = 504, ["Mega|Fly|Ride"] = 488.1}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 3.94, ["Fly"] = 131.23, ["Ride"] = 52.41, ["Fly|Ride"] = 170.63, ["Neon"] = 26.25, ["Neon|Ride"] = 61.68, ["Neon|Fly|Ride"] = 157.5, ["Mega|Fly"] = 260.46, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 261.18, ["Fly"] = 273.78, ["Ride"] = 342.49, ["Fly|Ride"] = 377.47, ["Neon"] = 1609.84, ["Neon|Ride"] = 3485.03, ["Neon|Fly|Ride"] = 1424.07, ["Mega|Fly|Ride"] = 5195.55}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 154.88, ["Fly"] = 292.74, ["Ride"] = 237.62, ["Fly|Ride"] = 263.82, ["Neon"] = 1665.78, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 704.41, ["Mega|Ride"] = 3281.25, ["Mega|Fly|Ride"] = 3895.39}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 134.92, ["Ride"] = 107.63, ["Fly|Ride"] = 185.88, ["Neon|Ride"] = 575.05, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 1801.11}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 11.82, ["Ride"] = 58.24, ["Fly|Ride"] = 273.78, ["Neon|Fly|Ride"] = 478.87, ["Mega|Fly|Ride"] = 1845.67}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 15.65, ["Fly"] = 57.29, ["Ride"] = 69.75, ["Fly|Ride"] = 100.5, ["Neon"] = 77.39, ["Neon|Ride"] = 103.32, ["Neon|Fly|Ride"] = 157.92, ["Mega|Fly"] = 525, ["Mega|Ride"] = 341.25}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.13, ["Fly"] = 52.45, ["Ride"] = 22.89, ["Fly|Ride"] = 82.05, ["Neon"] = 19.59, ["Neon|Ride"] = 35.25, ["Neon|Fly|Ride"] = 132.18, ["Mega"] = 117.5, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 321.46}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 787.5, ["Fly"] = 1077.68, ["Ride"] = 982.67, ["Fly|Ride"] = 918.75, ["Neon|Fly|Ride"] = 2428.13, ["Mega|Fly|Ride"] = 9707.17}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 369.14, ["Ride"] = 597.19, ["Fly|Ride"] = 724.87, ["Neon|Fly|Ride"] = 1504.22, ["Mega"] = 10252.68}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 78.75, ["Fly"] = 137.41, ["Ride"] = 128.86, ["Fly|Ride"] = 205.09, ["Neon"] = 339.94, ["Neon|Ride"] = 304.5, ["Neon|Fly|Ride"] = 460.41, ["Mega|Fly|Ride"] = 1906.16}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 335.31, ["Fly|Ride"] = 314.81, ["Neon|Fly|Ride"] = 2050.76, ["Mega"] = 10253.69, ["Mega|Fly|Ride"] = 5469.33}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 20.56, ["Fly"] = 72.82, ["Ride"] = 31.38, ["Fly|Ride"] = 71.49, ["Neon"] = 169.32, ["Neon|Ride"] = 226.63, ["Neon|Fly|Ride"] = 236.25, ["Mega|Fly|Ride"] = 773.68}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 236.25, ["Ride"] = 262.5, ["Fly|Ride"] = 472.5, ["Neon"] = 758.33, ["Neon|Fly|Ride"] = 1010.63, ["Mega"] = 4081.27, ["Mega|Ride"] = 4238.89, ["Mega|Fly|Ride"] = 3818.31}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 82.49, ["Fly"] = 125.98, ["Ride"] = 72.02, ["Fly|Ride"] = 132.44, ["Neon|Ride"] = 449.58, ["Neon|Fly|Ride"] = 273.78, ["Mega|Fly|Ride"] = 1435.53}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1870.32, ["Ride"] = 2188.15, ["Fly|Ride"] = 1947.9, ["Neon|Ride"] = 10843.03, ["Neon|Fly|Ride"] = 6357.29, ["Mega"] = 49217.67, ["Mega|Fly|Ride"] = 23242.03}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 11.8, ["Fly"] = 82.22, ["Ride"] = 39.38, ["Fly|Ride"] = 115.76, ["Neon"] = 64.32, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 227.85, ["Mega|Fly"] = 561.75, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 446.24}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 46.77, ["Fly"] = 119.1, ["Ride"] = 81.02, ["Fly|Ride"] = 102.38, ["Neon"] = 272.76, ["Neon|Ride"] = 786.48, ["Neon|Fly|Ride"] = 304.5, ["Mega"] = 1022.31}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 78.75, ["Fly"] = 91.85, ["Ride"] = 85.29, ["Fly|Ride"] = 97.01, ["Neon"] = 525, ["Neon|Fly|Ride"] = 465.53, ["Mega|Fly|Ride"] = 1823.95}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3416.55, ["Ride"] = 1050, ["Fly|Ride"] = 1043.44}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 428.44, ["Fly"] = 818.26, ["Ride"] = 670.61, ["Fly|Ride"] = 656.25, ["Neon|Fly|Ride"] = 2788}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 82.82, ["Fly"] = 202.13, ["Ride"] = 137.82, ["Fly|Ride"] = 196.88, ["Neon"] = 446.8, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 618.02, ["Mega"] = 4101.49, ["Mega|Ride"] = 4101.49, ["Mega|Fly|Ride"] = 2709.26}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 6.2, ["Ride"] = 26.25, ["Fly|Ride"] = 78.75, ["Neon"] = 87.94, ["Neon|Ride"] = 273431.81, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 762.72, ["Mega|Fly|Ride"] = 1367.85}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 41.03, ["Fly"] = 54.53, ["Ride"] = 48.57, ["Fly|Ride"] = 104.67, ["Neon"] = 196.88, ["Neon|Fly|Ride"] = 288.75, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 754.69, ["Ride"] = 874.13, ["Fly|Ride"] = 892.5, ["Neon"] = 3008.44, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2139.37, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 682.31}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4921.88, ["Ride"] = 4987.5, ["Fly|Ride"] = 4984.88, ["Neon"] = 42000, ["Neon|Fly|Ride"] = 23925.95, ["Mega|Fly|Ride"] = 87498.77}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 335.31, ["Fly"] = 410.93, ["Ride"] = 393.75, ["Neon"] = 1640.61, ["Neon|Fly|Ride"] = 2050.76, ["Mega"] = 6151.2, ["Mega|Fly|Ride"] = 6152.22}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 39.38, ["Fly"] = 273.78, ["Ride"] = 96.41, ["Fly|Ride"] = 336, ["Neon"] = 420, ["Neon|Ride"] = 647.03, ["Neon|Fly|Ride"] = 547.56, ["Mega|Fly|Ride"] = 2119.51}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 19.78, ["Fly"] = 58.47, ["Ride"] = 37.69, ["Fly|Ride"] = 100.5, ["Neon"] = 113.3, ["Neon|Ride"] = 124.26, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 655.23, ["Mega|Ride"] = 820.32, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 11.34, ["Fly"] = 26.17, ["Ride"] = 21, ["Fly|Ride"] = 44.35, ["Neon"] = 205.09, ["Neon|Ride"] = 315.32, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2173.8}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 19.69, ["Fly"] = 273.78, ["Ride"] = 40.06, ["Fly|Ride"] = 140.44, ["Neon"] = 115.5, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 211.23, ["Mega"] = 645.75, ["Mega|Ride"] = 615.23, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 6.57, ["Fly"] = 55.38, ["Ride"] = 21.93, ["Fly|Ride"] = 48.57, ["Neon"] = 31.38, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 123.3, ["Mega"] = 273.78, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 357}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 29.4, ["Fly"] = 90.57, ["Ride"] = 39.38, ["Fly|Ride"] = 183.57, ["Neon"] = 178.43, ["Neon|Ride"] = 249.37, ["Neon|Fly|Ride"] = 364.02, ["Mega|Ride"] = 670.61, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 387.19, ["Fly"] = 507.57, ["Ride"] = 405.57, ["Fly|Ride"] = 473.44, ["Neon"] = 1558.58, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 7875, ["Mega|Fly|Ride"] = 5057.13}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.31, ["Fly"] = 15.75, ["Ride"] = 15.04, ["Fly|Ride"] = 34.69, ["Neon"] = 18.38, ["Neon|Ride"] = 34.89, ["Neon|Fly|Ride"] = 86.44, ["Mega"] = 820.32, ["Mega|Ride"] = 616.35, ["Mega|Fly|Ride"] = 243.77}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 52.5, ["Fly"] = 138.44, ["Ride"] = 83.44, ["Fly|Ride"] = 182.44, ["Neon"] = 231, ["Neon|Ride"] = 202.42, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 649.69, ["Mega|Ride"] = 582.64, ["Mega|Fly|Ride"] = 575.88}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 794.07, ["Fly"] = 999.01, ["Ride"] = 877.06, ["Fly|Ride"] = 818.99, ["Neon|Fly|Ride"] = 1561.88, ["Mega|Fly|Ride"] = 3806.25}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 34.01, ["Fly"] = 91.88, ["Ride"] = 47.69, ["Fly|Ride"] = 75.89, ["Neon"] = 137.41, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 257.25, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 767.82}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 262.5, ["Fly"] = 339.71, ["Ride"] = 314.01, ["Fly|Ride"] = 288.74, ["Neon|Ride"] = 1778, ["Neon|Fly|Ride"] = 1312.49}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 158.17, ["Fly"] = 241.63, ["Ride"] = 157.5, ["Fly|Ride"] = 236.25, ["Neon|Ride"] = 960.72, ["Neon|Fly|Ride"] = 772.16, ["Mega|Fly|Ride"] = 3473.01}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 720.3, ["Ride"] = 682.5, ["Fly|Ride"] = 787.5, ["Neon|Ride"] = 3277.1, ["Neon|Fly|Ride"] = 2980.76, ["Mega|Fly|Ride"] = 7611.19}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 23.37, ["Ride"] = 43.22, ["Fly|Ride"] = 110.25, ["Neon"] = 78.08, ["Neon|Ride"] = 106.65, ["Neon|Fly|Ride"] = 269.52, ["Mega"] = 354.38, ["Mega|Ride"] = 362.6, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3465, ["Fly"] = 3543.75, ["Ride"] = 3924.38, ["Fly|Ride"] = 3377.06, ["Neon"] = 13672.26, ["Neon|Fly|Ride"] = 6825, ["Mega|Fly|Ride"] = 24832.07}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 116.82, ["Fly"] = 166.28, ["Ride"] = 129.94, ["Fly|Ride"] = 161.34, ["Neon"] = 550.97, ["Neon|Ride"] = 588.58, ["Neon|Fly|Ride"] = 577.5, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.63, ["Fly"] = 27.32, ["Ride"] = 19.69, ["Fly|Ride"] = 44.1, ["Neon"] = 23.63, ["Neon|Ride"] = 30.78, ["Neon|Fly|Ride"] = 105, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.85, ["Ride"] = 22.6, ["Fly|Ride"] = 58.1, ["Neon"] = 20.99, ["Neon|Fly|Ride"] = 266.44, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 325.5}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 56.26, ["Ride"] = 35.26, ["Fly|Ride"] = 61.53, ["Neon|Fly|Ride"] = 410.17, ["Mega|Fly|Ride"] = 1143.19}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 998.6, ["Ride"] = 1367.85, ["Fly|Ride"] = 1260, ["Neon|Fly|Ride"] = 4235.81}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6562.5, ["Ride"] = 7109.91, ["Fly|Ride"] = 7315}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 17.07, ["Fly"] = 35.35, ["Ride"] = 27.57, ["Fly|Ride"] = 47.07, ["Neon"] = 452.13, ["Neon|Fly|Ride"] = 185.88, ["Mega"] = 2493.75, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 16.44, ["Fly"] = 55.38, ["Ride"] = 28.65, ["Fly|Ride"] = 65.62, ["Neon"] = 92.95, ["Neon|Ride"] = 92.95, ["Neon|Fly|Ride"] = 178.5, ["Mega"] = 655.54, ["Mega|Ride"] = 663.44, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 69.99, ["Fly"] = 157.49, ["Ride"] = 70.62, ["Fly|Ride"] = 118.13, ["Neon"] = 459.38, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 440.49, ["Mega|Fly|Ride"] = 1372.98}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 257.25, ["Ride"] = 264.79, ["Fly|Ride"] = 373.25, ["Neon|Fly|Ride"] = 1082.68, ["Mega"] = 10253.69, ["Mega|Fly|Ride"] = 4334.25}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 6.17, ["Ride"] = 32.69, ["Fly|Ride"] = 86.52, ["Neon"] = 22.58, ["Neon|Ride"] = 55.38, ["Mega|Ride"] = 186.63, ["Mega|Fly|Ride"] = 302.5}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 183.74, ["Fly"] = 240.98, ["Ride"] = 236.25, ["Fly|Ride"] = 282.19, ["Neon"] = 725.89, ["Neon|Ride"] = 952.59, ["Neon|Fly|Ride"] = 843.94, ["Mega|Fly|Ride"] = 5315.63}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.39, ["Fly"] = 57.44, ["Ride"] = 17.06, ["Fly|Ride"] = 39.35, ["Neon"] = 22.32, ["Neon|Ride"] = 51.12, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 369.14, ["Mega|Ride"] = 223.12, ["Mega|Fly|Ride"] = 303.71}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 231, ["Fly"] = 268.82, ["Ride"] = 249.38, ["Fly|Ride"] = 262.5, ["Neon|Fly|Ride"] = 1115.63, ["Mega"] = 10253.69, ["Mega|Ride"] = 4101.49}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 13.71, ["Fly"] = 79.48, ["Ride"] = 27.09, ["Fly|Ride"] = 68.25, ["Neon"] = 72.76, ["Neon|Ride"] = 151.77, ["Neon|Fly|Ride"] = 155.68, ["Mega|Ride"] = 615.23, ["Mega|Fly|Ride"] = 449.5}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Fly"] = 68.72, ["Ride"] = 19.81, ["Fly|Ride"] = 59.07, ["Neon"] = 7.33, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 176.88, ["Mega"] = 67.38, ["Mega|Fly|Ride"] = 195.46}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.86, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 23.84, ["Fly|Ride"] = 116.82, ["Neon"] = 5.16, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 109.94, ["Mega"] = 71.5, ["Mega|Fly"] = 154888.75, ["Mega|Ride"] = 93.84, ["Mega|Fly|Ride"] = 164.08}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 66.94, ["Fly"] = 139.41, ["Ride"] = 120.16, ["Fly|Ride"] = 175.44, ["Neon"] = 347.17, ["Neon|Ride"] = 384.57, ["Neon|Fly|Ride"] = 373.13, ["Mega|Ride"] = 1332.99, ["Mega|Fly|Ride"] = 1128.75}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 33.72, ["Ride"] = 15.73, ["Fly|Ride"] = 108.92, ["Neon"] = 5.25, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 109.22, ["Mega|Fly|Ride"] = 257.24}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 11.46, ["Ride"] = 101.07, ["Neon"] = 51.79}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.67, ["Neon|Ride"] = 51.51, ["Mega|Ride"] = 48, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.05, ["Fly"] = 39.84, ["Ride"] = 15.1, ["Fly|Ride"] = 33.45, ["Neon"] = 2.1, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 31.85, ["Mega|Fly"] = 31.38, ["Mega|Ride"] = 19.27, ["Mega|Fly|Ride"] = 50.65}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 27.69, ["Ride"] = 12.49, ["Fly|Ride"] = 26.25, ["Neon"] = 3.76, ["Neon|Ride"] = 16.42, ["Neon|Fly|Ride"] = 45.13, ["Mega|Ride"] = 921.06, ["Mega|Fly|Ride"] = 92.79}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Mega|Ride"] = 121.85}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 91.84, ["Ride"] = 19.69, ["Fly|Ride"] = 107.63, ["Neon"] = 5.16, ["Neon|Ride"] = 36.43, ["Neon|Fly|Ride"] = 78.75, ["Mega|Fly"] = 91.88, ["Mega|Fly|Ride"] = 116.91}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Fly|Ride"] = 205.09, ["Mega|Fly|Ride"] = 205.09}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 4.11, ["Fly"] = 68.72, ["Ride"] = 17.31, ["Fly|Ride"] = 70.03, ["Neon"] = 13, ["Neon|Ride"] = 45.92, ["Neon|Fly|Ride"] = 78.56, ["Mega"] = 114.26, ["Mega|Fly"] = 273.78, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 183.63}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 50.94, ["Neon"] = 2.1, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 157.39, ["Mega|Ride"] = 38.36}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly|Ride"] = 524.99, ["Neon"] = 16.21, ["Mega|Fly"] = 314.99}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 3.94, ["Ride"] = 27.57, ["Neon"] = 15.18, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 537.62}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Neon"] = 3.29, ["Neon|Ride"] = 26.72, ["Neon|Fly|Ride"] = 137.41, ["Mega|Ride"] = 49.23}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.4, ["Fly|Ride"] = 30.14, ["Neon"] = 2.1, ["Neon|Ride"] = 12.24, ["Neon|Fly|Ride"] = 31.05, ["Mega|Fly"] = 38.98, ["Mega|Ride"] = 18.47, ["Mega|Fly|Ride"] = 45.85}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 3.72, ["Fly"] = 72.19, ["Ride"] = 229.68, ["Fly|Ride"] = 104.98, ["Neon"] = 36.75, ["Neon|Ride"] = 140.94, ["Mega|Ride"] = 240.19}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 19.59, ["Neon"] = 3.94, ["Neon|Ride"] = 52.31, ["Neon|Fly|Ride"] = 105, ["Mega"] = 24.86, ["Mega|Fly"] = 78.75, ["Mega|Ride"] = 54.02, ["Mega|Fly|Ride"] = 114.19}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.25, ["Neon"] = 10.02, ["Neon|Fly|Ride"] = 137.41, ["Mega|Fly|Ride"] = 238.87}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 262.49, ["Ride"] = 34.54, ["Fly|Ride"] = 43.32, ["Neon"] = 21.2, ["Neon|Fly|Ride"] = 105, ["Mega"] = 210, ["Mega|Ride"] = 140.19}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 11.46, ["Ride"] = 11.46, ["Fly|Ride"] = 26.28, ["Neon"] = 2.1, ["Neon|Ride"] = 12.17, ["Neon|Fly|Ride"] = 26.25, ["Mega|Fly"] = 28.18, ["Mega|Ride"] = 22.23, ["Mega|Fly|Ride"] = 45.94}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 20.52, ["Fly|Ride"] = 137.41, ["Neon"] = 12.46, ["Neon|Fly|Ride"] = 123.05, ["Mega"] = 91.77, ["Mega|Ride"] = 157.95, ["Mega|Fly|Ride"] = 314.9}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.1, ["Fly"] = 112.03, ["Ride"] = 19.09, ["Fly|Ride"] = 59.06, ["Neon"] = 77.24, ["Neon|Ride"] = 67.48, ["Neon|Fly|Ride"] = 262.48, ["Mega|Ride"] = 288.46, ["Mega|Fly|Ride"] = 399.67}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 15.4, ["Ride"] = 13, ["Fly|Ride"] = 32.71, ["Neon"] = 2.1, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 34.48, ["Mega|Ride"] = 35.44, ["Mega|Fly|Ride"] = 98.15}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.37, ["Fly"] = 171.26, ["Ride"] = 30.23, ["Neon"] = 4.5, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly"] = 164.08, ["Mega|Ride"] = 116.82, ["Mega|Fly|Ride"] = 262.48}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 35.33, ["Fly|Ride"] = 65.63, ["Neon"] = 5.25, ["Neon|Ride"] = 152.79, ["Neon|Fly|Ride"] = 137.41, ["Mega"] = 33.5, ["Mega|Fly"] = 137.41, ["Mega|Ride"] = 133.31, ["Mega|Fly|Ride"] = 302.5}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 32.66, ["Ride"] = 17.27, ["Neon"] = 2.39, ["Neon|Fly|Ride"] = 100.96, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 96.41, ["Ride"] = 22.58, ["Fly|Ride"] = 41.91, ["Neon"] = 4.85, ["Neon|Ride"] = 20.88, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 65.01, ["Mega|Ride"] = 62.74, ["Mega|Fly|Ride"] = 205.09}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 68.25, ["Neon"] = 5.23, ["Neon|Ride"] = 148.32, ["Mega"] = 35.83}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 12.31, ["Fly|Ride"] = 47.25, ["Neon"] = 7.77, ["Neon|Ride"] = 28.14, ["Neon|Fly|Ride"] = 84, ["Mega"] = 91.88, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 365.05}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.86, ["Fly"] = 41.16, ["Ride"] = 34.81, ["Neon"] = 38.99, ["Mega"] = 98.18, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 3.94, ["Ride"] = 18.38, ["Fly|Ride"] = 137.41, ["Neon"] = 18.38, ["Neon|Ride"] = 67.69, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 202.14, ["Mega|Fly"] = 420, ["Mega|Ride"] = 124.69}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 22.58, ["Ride"] = 12.27, ["Fly|Ride"] = 40.69, ["Neon"] = 18.69, ["Neon|Ride"] = 40.41, ["Neon|Fly|Ride"] = 65.4, ["Mega"] = 278.55, ["Mega|Ride"] = 410.82, ["Mega|Fly|Ride"] = 241.5}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 110.93, ["Fly|Ride"] = 137.41, ["Neon"] = 23.35, ["Mega"] = 215.92, ["Mega|Ride"] = 236.24}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 12.56, ["Ride"] = 56.44, ["Neon"] = 139.55, ["Neon|Ride"] = 232.35, ["Mega"] = 547.56, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 3.84, ["Ride"] = 32.71, ["Fly|Ride"] = 104.71, ["Neon"] = 39.2, ["Neon|Ride"] = 125.71, ["Neon|Fly|Ride"] = 273.78, ["Mega|Ride"] = 306.48}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 3.45, ["Ride"] = 29.98, ["Fly|Ride"] = 120.75, ["Neon"] = 41.34, ["Neon|Fly|Ride"] = 181.55, ["Mega"] = 287.12, ["Mega|Ride"] = 280.97, ["Mega|Fly|Ride"] = 358.98}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Mega"] = 16.04, ["Mega|Fly"] = 123.05, ["Mega|Ride"] = 123.05, ["Mega|Fly|Ride"] = 121.02}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 48.37}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 7.22, ["Fly"] = 23.29, ["Ride"] = 18.1, ["Fly|Ride"] = 54.6, ["Neon"] = 45.85, ["Neon|Ride"] = 40.46, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 374.32, ["Mega|Ride"] = 348.59, ["Mega|Fly|Ride"] = 812.84}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 92.3, ["Ride"] = 19.56, ["Neon"] = 2.52, ["Mega"] = 31.24, ["Mega|Fly"] = 137.41, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 32.83, ["Neon"] = 5.25, ["Neon|Ride"] = 41.03, ["Neon|Fly|Ride"] = 98, ["Mega|Fly|Ride"] = 133.88}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 51.47, ["Ride"] = 15.69, ["Fly|Ride"] = 55.13, ["Neon"] = 3.94, ["Neon|Ride"] = 55.38, ["Neon|Fly|Ride"] = 124.31, ["Mega"] = 123.05, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 161.65}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 4.9, ["Ride"] = 49.23, ["Fly|Ride"] = 62.74, ["Neon"] = 35.05, ["Neon|Ride"] = 55.38, ["Neon|Fly|Ride"] = 216.57, ["Mega|Ride"] = 275.45, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Fly"] = 19.5, ["Ride"] = 32.81, ["Neon"] = 2.61, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 56.74}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 21.66, ["Ride"] = 15.94, ["Fly|Ride"] = 273431.81, ["Neon"] = 6.56, ["Neon|Ride"] = 41.03, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 24.62, ["Mega|Fly"] = 143.16, ["Mega|Fly|Ride"] = 124.58}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 27.75, ["Ride"] = 16.42, ["Fly|Ride"] = 68.72, ["Neon"] = 9.31, ["Neon|Ride"] = 17.31, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 47.95, ["Mega|Fly|Ride"] = 155.68}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 27.69, ["Ride"] = 32.16, ["Fly|Ride"] = 147.54, ["Neon"] = 3.94, ["Neon|Ride"] = 26.48, ["Neon|Fly|Ride"] = 110.88, ["Mega"] = 27.46, ["Mega|Fly|Ride"] = 151.77}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Neon"] = 3.73, ["Neon|Fly|Ride"] = 131.25, ["Mega|Fly"] = 106.45, ["Mega|Ride"] = 104.37}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 35.44, ["Ride"] = 20.52, ["Fly|Ride"] = 45.94, ["Neon"] = 3.8, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 83.66, ["Mega"] = 19.47, ["Mega|Fly"] = 45.94, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 127.05}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 48.21, ["Neon"] = 2.63}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.37, ["Neon"] = 4.98, ["Neon|Ride"] = 310.19, ["Neon|Fly|Ride"] = 420, ["Mega"] = 23.57, ["Mega|Ride"] = 155.68, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 14.44, ["Fly|Ride"] = 41.03, ["Neon"] = 12.79, ["Neon|Ride"] = 17.05, ["Neon|Fly|Ride"] = 136.49, ["Mega"] = 91.88, ["Mega|Fly|Ride"] = 82.57}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 8.3, ["Ride"] = 139.53, ["Neon"] = 137.41, ["Mega|Ride"] = 545.51}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 56.24, ["Neon"] = 40.69, ["Mega"] = 1640.61, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 30.19, ["Fly|Ride"] = 410.91, ["Neon"] = 38.98, ["Neon|Fly|Ride"] = 260.46, ["Mega"] = 295.08, ["Mega|Ride"] = 350.69, ["Mega|Fly|Ride"] = 401.97}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 12.43, ["Ride"] = 15.4, ["Fly|Ride"] = 22.73, ["Neon"] = 2.1, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 31.5, ["Mega|Fly"] = 104.99, ["Mega|Ride"] = 20.31, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.63, ["Fly"] = 118.12, ["Ride"] = 57.44, ["Fly|Ride"] = 109.74, ["Neon"] = 7.23, ["Neon|Ride"] = 31.8, ["Neon|Fly|Ride"] = 683.93, ["Mega"] = 45.94, ["Mega|Ride"] = 118.02}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 21.47, ["Neon|Fly|Ride"] = 68.83, ["Mega"] = 14.21, ["Mega|Fly"] = 88.36, ["Mega|Ride"] = 71.6, ["Mega|Fly|Ride"] = 118.89}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Mega"] = 16.42, ["Mega|Fly|Ride"] = 162.02}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 38.52, ["Ride"] = 20.9, ["Fly|Ride"] = 56.44, ["Neon"] = 9.98, ["Neon|Ride"] = 55.38, ["Neon|Fly|Ride"] = 90.97, ["Mega"] = 208.85, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 137.41, ["Ride"] = 194, ["Fly|Ride"] = 177.19, ["Neon|Fly|Ride"] = 1094.09, ["Mega"] = 8202.95, ["Mega|Fly|Ride"] = 3550.87}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 19.5, ["Neon"] = 6.57, ["Neon|Ride"] = 82.05, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 7.76, ["Fly"] = 64.32, ["Ride"] = 25.57, ["Fly|Ride"] = 59.07, ["Neon"] = 31.8, ["Neon|Ride"] = 92.95, ["Neon|Fly|Ride"] = 137.41, ["Mega"] = 360.94, ["Mega|Fly|Ride"] = 406.06}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 15.01, ["Ride"] = 11.82, ["Fly|Ride"] = 32.13, ["Neon"] = 6.18, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 39.38, ["Mega|Ride"] = 80.56}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 19.68, ["Fly|Ride"] = 92.57, ["Neon"] = 6.14, ["Neon|Ride"] = 273.78, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 69.57, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 2.91, ["Fly"] = 18.29, ["Ride"] = 15.75, ["Fly|Ride"] = 36, ["Neon"] = 28.62, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 74.82, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.6, ["Ride"] = 55.38, ["Fly|Ride"] = 249.58, ["Neon"] = 55.29, ["Neon|Ride"] = 137.41, ["Neon|Fly|Ride"] = 609.09}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 15.66, ["Ride"] = 15.53, ["Fly|Ride"] = 29.75, ["Neon"] = 17.75, ["Neon|Ride"] = 28.29, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 157.5, ["Mega|Ride"] = 232.78, ["Mega|Fly|Ride"] = 273.78}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 70.23, ["Fly"] = 178.5, ["Ride"] = 92.54, ["Fly|Ride"] = 168, ["Neon"] = 356.64, ["Neon|Ride"] = 464.63, ["Neon|Fly|Ride"] = 381.94}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 223.13, ["Fly"] = 328.14, ["Ride"] = 248.79, ["Fly|Ride"] = 314.81, ["Neon|Fly|Ride"] = 1232.65, ["Mega"] = 10253.69, ["Mega|Fly|Ride"] = 4645.96}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 52.5, ["Fly"] = 137.68, ["Ride"] = 75.89, ["Fly|Ride"] = 111.56, ["Neon"] = 701.38, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 410.17, ["Mega|Fly|Ride"] = 1148.89}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 6.33, ["Fly"] = 26.25, ["Ride"] = 30.78, ["Fly|Ride"] = 137.41, ["Neon"] = 26.2, ["Neon|Ride"] = 123.15, ["Neon|Fly|Ride"] = 179.81, ["Mega"] = 262.5, ["Mega|Ride"] = 376.69}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 11.37, ["Fly"] = 68.72, ["Ride"] = 28.84, ["Fly|Ride"] = 90.24, ["Neon"] = 52.41, ["Neon|Ride"] = 137.41, ["Mega"] = 353.07, ["Mega|Ride"] = 383.34, ["Mega|Fly|Ride"] = 1135.1}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 14.11, ["Ride"] = 17.82, ["Fly|Ride"] = 34.93, ["Neon"] = 4.17, ["Neon|Ride"] = 20.78, ["Neon|Fly|Ride"] = 58.83, ["Mega|Fly"] = 52.5, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 175.35}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 5.49, ["Fly"] = 72.12, ["Ride"] = 20.89, ["Fly|Ride"] = 312.16, ["Neon"] = 99.83, ["Neon|Ride"] = 96.41, ["Neon|Fly|Ride"] = 136.29, ["Mega"] = 413.44, ["Mega|Ride"] = 616.88, ["Mega|Fly|Ride"] = 604.07}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 19.5, ["Ride"] = 16.42, ["Fly|Ride"] = 36.11, ["Neon"] = 19.68, ["Neon|Ride"] = 28.65, ["Neon|Fly|Ride"] = 113.82, ["Mega|Ride"] = 206.96, ["Mega|Fly|Ride"] = 171.52}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 4.53, ["Ride"] = 20.46, ["Fly|Ride"] = 328.13, ["Neon"] = 19.68, ["Neon|Ride"] = 61.53, ["Mega"] = 207.37}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 15.4, ["Ride"] = 19.34, ["Neon"] = 2.1, ["Neon|Ride"] = 19.65, ["Neon|Fly|Ride"] = 53.33, ["Mega"] = 15, ["Mega|Ride"] = 27.69, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.63, ["Fly"] = 18.71, ["Ride"] = 18.06, ["Fly|Ride"] = 31.38, ["Neon"] = 14.33, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 147, ["Mega"] = 84, ["Mega|Ride"] = 101.88, ["Mega|Fly|Ride"] = 209.34}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 3.89, ["Fly"] = 24.94, ["Ride"] = 18.51, ["Fly|Ride"] = 60.8, ["Neon"] = 34.89, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 547.56, ["Mega"] = 260.46, ["Mega|Ride"] = 191.76}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 196.88, ["Fly"] = 273.78, ["Ride"] = 169.51, ["Fly|Ride"] = 213.7, ["Neon"] = 820.32, ["Neon|Ride"] = 774.85, ["Neon|Fly|Ride"] = 793.65, ["Mega"] = 4101.49, ["Mega|Fly|Ride"] = 2734.67}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.88, ["Ride"] = 31.8, ["Fly|Ride"] = 124.31, ["Neon"] = 53.82, ["Neon|Ride"] = 160.13, ["Neon|Fly|Ride"] = 376.56, ["Mega"] = 405.04, ["Mega|Ride"] = 296.63}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 17.64, ["Ride"] = 14.09, ["Fly|Ride"] = 45.31, ["Neon"] = 22.97, ["Neon|Ride"] = 54.62, ["Neon|Fly|Ride"] = 104.61, ["Mega"] = 308.44, ["Mega|Ride"] = 244.83, ["Mega|Fly|Ride"] = 273.78}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 18.26, ["Ride"] = 41.32, ["Fly|Ride"] = 170.63, ["Neon"] = 162.65, ["Neon|Ride"] = 295.24, ["Neon|Fly|Ride"] = 464.03, ["Mega|Fly"] = 820.32, ["Mega|Ride"] = 522.38, ["Mega|Fly|Ride"] = 1025.38}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 5.09}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 6.57, ["Fly"] = 15.75, ["Ride"] = 28.24, ["Neon"] = 23.63, ["Neon|Ride"] = 273.78, ["Neon|Fly|Ride"] = 342.49, ["Mega"] = 342.49, ["Mega|Ride"] = 347.82, ["Mega|Fly|Ride"] = 889.01}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 32.32, ["Fly"] = 34.89, ["Ride"] = 28.98, ["Fly|Ride"] = 55.13, ["Neon|Ride"] = 259.88, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 2050.76, ["Mega|Fly|Ride"] = 1915.4}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 17.18, ["Fly|Ride"] = 102.55, ["Neon"] = 2.52, ["Neon|Ride"] = 69.93, ["Neon|Fly|Ride"] = 106.25, ["Mega|Fly"] = 273.78, ["Mega|Ride"] = 77.55, ["Mega|Fly|Ride"] = 227.21}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 3.87, ["Fly"] = 28.09, ["Ride"] = 15.4, ["Fly|Ride"] = 61.53, ["Neon"] = 45.66, ["Mega"] = 233.21, ["Mega|Fly"] = 388.01, ["Mega|Ride"] = 203.44}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 14.89, ["Fly|Ride"] = 40.69, ["Neon"] = 13.39, ["Neon|Ride"] = 48.21, ["Neon|Fly|Ride"] = 78.75, ["Mega|Fly|Ride"] = 209.79}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 35.9, ["Fly|Ride"] = 78.75, ["Neon"] = 6.3, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 410.17, ["Mega"] = 26.79, ["Mega|Fly|Ride"] = 184.57}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 32.81, ["Ride"] = 78.66, ["Fly|Ride"] = 139.41, ["Neon"] = 313.07, ["Neon|Fly|Ride"] = 801.56, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 8.22, ["Ride"] = 51.19, ["Fly|Ride"] = 210, ["Neon"] = 85.95, ["Mega|Ride"] = 524.99}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 4.59, ["Fly"] = 210, ["Ride"] = 21.15, ["Fly|Ride"] = 69.11, ["Neon"] = 22.3, ["Neon|Ride"] = 41.03, ["Neon|Fly|Ride"] = 107.63, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 86.52, ["Fly"] = 433.12, ["Ride"] = 385.86, ["Fly|Ride"] = 262.46, ["Neon"] = 328.13, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1836.18}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 6.56, ["Fly"] = 26.17, ["Ride"] = 28.87, ["Fly|Ride"] = 64.61, ["Neon"] = 55.38, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 139.86}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 72.1, ["Fly"] = 186.38, ["Ride"] = 113.14, ["Neon"] = 261.19, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 396.83, ["Mega|Fly|Ride"] = 953.84}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 19.72, ["Ride"] = 47.25, ["Fly|Ride"] = 172.27, ["Neon"] = 87.1, ["Neon|Ride"] = 137.41, ["Neon|Fly|Ride"] = 196.86, ["Mega|Ride"] = 313.69, ["Mega|Fly|Ride"] = 456.1}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 5.58, ["Ride"] = 27.55, ["Fly|Ride"] = 68.72, ["Neon"] = 70.37, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 248.61, ["Mega"] = 416.96, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 14.16, ["Ride"] = 45.66, ["Fly|Ride"] = 273.78, ["Neon"] = 65.63, ["Neon|Ride"] = 178.43, ["Neon|Fly|Ride"] = 305.58, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 19.59, ["Ride"] = 26.25, ["Fly|Ride"] = 55.73, ["Neon"] = 47.87, ["Neon|Ride"] = 547.56, ["Neon|Fly|Ride"] = 150.94, ["Mega|Ride"] = 273.78, ["Mega|Fly|Ride"] = 310.19}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 91.6, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 2.1, ["Ride"] = 28.25, ["Neon"] = 18.11, ["Neon|Fly|Ride"] = 202.78, ["Mega|Ride"] = 246.09, ["Mega|Fly|Ride"] = 467}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Neon"] = 25.83, ["Mega"] = 196.88, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 3.01, ["Ride"] = 32.79, ["Fly|Ride"] = 116.19, ["Neon"] = 27.04, ["Mega|Fly|Ride"] = 348.5}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 541.14, ["Ride"] = 607.69, ["Fly|Ride"] = 700.88, ["Neon"] = 1778, ["Neon|Ride"] = 1784.04, ["Neon|Fly|Ride"] = 1778}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 7.69, ["Fly"] = 27.69, ["Ride"] = 19.2, ["Fly|Ride"] = 62.74, ["Neon"] = 35.9, ["Neon|Ride"] = 102.55, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 155.68, ["Mega|Ride"] = 355.72, ["Mega|Fly|Ride"] = 464.68}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 19.69, ["Fly"] = 524.69, ["Ride"] = 25.01, ["Fly|Ride"] = 51.35, ["Neon"] = 76.12, ["Neon|Ride"] = 125.13, ["Neon|Fly|Ride"] = 156.4, ["Mega"] = 330.75, ["Mega|Ride"] = 273.78, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 3.94, ["Fly"] = 91.88, ["Ride"] = 19.41, ["Fly|Ride"] = 131.25, ["Neon|Ride"] = 196.88, ["Mega"] = 263.71, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.58, ["Ride"] = 20.69, ["Fly|Ride"] = 88.75, ["Neon"] = 7.56, ["Neon|Ride"] = 37.7, ["Neon|Fly|Ride"] = 94.98, ["Mega|Fly"] = 211.78, ["Mega|Ride"] = 112.87, ["Mega|Fly|Ride"] = 250.2}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 68.72, ["Ride"] = 19.69, ["Neon"] = 3.73, ["Neon|Ride"] = 23.58, ["Neon|Fly|Ride"] = 91.88, ["Mega|Ride"] = 65.35, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1109.05}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 10.5, ["Ride"] = 36.75, ["Fly|Ride"] = 323.65, ["Neon"] = 83.66, ["Neon|Fly|Ride"] = 273.78, ["Mega|Ride"] = 544.48, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 24.6, ["Neon"] = 5.25, ["Neon|Ride"] = 73.84, ["Neon|Fly|Ride"] = 982.1, ["Mega|Ride"] = 164.08, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 27.17, ["Ride"] = 58.97, ["Fly|Ride"] = 99.75, ["Neon"] = 15.4, ["Neon|Ride"] = 55.38, ["Mega"] = 183.73, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 464.63, ["Ride"] = 523.69, ["Fly|Ride"] = 607.03, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 4.87, ["Fly"] = 196.88, ["Ride"] = 59.07, ["Fly|Ride"] = 410.17, ["Neon"] = 68.72, ["Neon|Fly|Ride"] = 185.88, ["Mega"] = 478.87, ["Mega|Ride"] = 441.45}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 83.64, ["Fly|Ride"] = 162.02, ["Neon"] = 4.64, ["Neon|Ride"] = 27.69, ["Neon|Fly|Ride"] = 144.06, ["Mega|Ride"] = 76.04, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 273.78, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 287.12}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 14.43, ["Fly"] = 107.63, ["Ride"] = 68.84, ["Fly|Ride"] = 97.43, ["Neon"] = 120.7, ["Neon|Ride"] = 109.95, ["Neon|Fly|Ride"] = 185.88, ["Mega"] = 425.55, ["Mega|Ride"] = 544.48, ["Mega|Fly|Ride"] = 595.88}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 5.43, ["Neon"] = 80.22, ["Neon|Fly|Ride"] = 820.32, ["Mega"] = 533.21, ["Mega|Ride"] = 479.73}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 6.18, ["Ride"] = 31.38, ["Fly|Ride"] = 131.25, ["Neon"] = 310.16, ["Mega"] = 644.69, ["Mega|Ride"] = 1053.07, ["Mega|Fly|Ride"] = 683.93}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 19.69, ["Ride"] = 23.15, ["Fly|Ride"] = 262.5, ["Neon"] = 656.25, ["Neon|Ride"] = 182.43, ["Neon|Fly|Ride"] = 198.94, ["Mega"] = 610.32, ["Mega|Ride"] = 646.42, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 354.38, ["Ride"] = 409.6, ["Fly|Ride"] = 748.11, ["Neon"] = 1025.38, ["Neon|Ride"] = 1085.02, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 3965.11}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 5.13, ["Fly"] = 19.69, ["Ride"] = 19.9, ["Fly|Ride"] = 236.25, ["Neon"] = 119.67, ["Neon|Fly|Ride"] = 193.23, ["Mega|Fly|Ride"] = 843.9}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 2.1, ["Fly|Ride"] = 127.32, ["Neon"] = 39.26, ["Neon|Ride"] = 273.78, ["Mega"] = 217.4, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 787.49}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 20.32, ["Ride"] = 70.88, ["Fly|Ride"] = 256.74, ["Neon"] = 85.32, ["Neon|Ride"] = 155.68, ["Neon|Fly|Ride"] = 261.19, ["Mega|Fly"] = 683.93, ["Mega|Ride"] = 273, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 137.41, ["Neon"] = 6.57, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 205.09, ["Mega"] = 47.77, ["Mega|Ride"] = 102.54, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 31.5, ["Ride"] = 73.5, ["Neon"] = 313.78, ["Neon|Ride"] = 358.89, ["Mega"] = 1504.22, ["Mega|Ride"] = 1361.71, ["Mega|Fly|Ride"] = 1089.38}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 580.83, ["Ride"] = 25.18, ["Fly|Ride"] = 60.36, ["Neon"] = 9.19, ["Neon|Ride"] = 77.16, ["Neon|Fly|Ride"] = 118.12, ["Mega|Ride"] = 108.11, ["Mega|Fly|Ride"] = 208.69}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 36.03, ["Ride"] = 27.97, ["Fly|Ride"] = 154.37, ["Neon"] = 5.03, ["Neon|Ride"] = 43.78, ["Neon|Fly|Ride"] = 90.57, ["Mega|Fly"] = 112.88, ["Mega|Fly|Ride"] = 170.36}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 31.38, ["Fly|Ride"] = 125.09, ["Neon"] = 15.4, ["Neon|Fly|Ride"] = 177.19, ["Mega|Fly"] = 459.38, ["Mega|Ride"] = 111.03, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 101.52, ["Fly"] = 92.95, ["Ride"] = 65.63, ["Fly|Ride"] = 194, ["Neon"] = 291.38, ["Neon|Ride"] = 626.07, ["Neon|Fly|Ride"] = 412.56, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 255.75, ["Ride"] = 271.55, ["Fly|Ride"] = 411.76, ["Neon"] = 1425.29, ["Neon|Ride"] = 1174.69, ["Neon|Fly|Ride"] = 1277.84, ["Mega"] = 6152.22, ["Mega|Fly|Ride"] = 4045.13}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 7.66, ["Neon"] = 40.08, ["Mega|Ride"] = 212.2}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 68.72, ["Ride"] = 27.57, ["Neon"] = 7.77, ["Neon|Ride"] = 43.89, ["Neon|Fly|Ride"] = 191.76, ["Mega"] = 58.7, ["Mega|Fly"] = 210, ["Mega|Fly|Ride"] = 343.52}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 5.98, ["Fly"] = 155.57, ["Ride"] = 27.56, ["Neon"] = 32.81, ["Mega|Ride"] = 348.23, ["Mega|Fly|Ride"] = 388.01}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.62, ["Fly"] = 67.91, ["Ride"] = 63.58, ["Neon"] = 10.5, ["Neon|Ride"] = 41.03, ["Neon|Fly|Ride"] = 139.55, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 90.24, ["Neon"] = 7.8, ["Mega"] = 39.29, ["Mega|Fly|Ride"] = 270.71}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.52, ["Ride"] = 16.71, ["Fly|Ride"] = 49.88, ["Neon"] = 3.81, ["Neon|Ride"] = 255.94, ["Neon|Fly|Ride"] = 410.17, ["Mega|Ride"] = 99.92, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 137.41, ["Ride"] = 17.27, ["Fly|Ride"] = 59.77, ["Neon"] = 16.65, ["Neon|Ride"] = 27.69, ["Neon|Fly|Ride"] = 93.28, ["Mega"] = 113.82, ["Mega|Ride"] = 231.75, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 138.43, ["Ride"] = 115.5, ["Fly|Ride"] = 77.16, ["Neon"] = 137.69, ["Mega"] = 1127.93, ["Mega|Ride"] = 525}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 77.18, ["Ride"] = 102.55, ["Fly|Ride"] = 119.87, ["Neon"] = 439.69, ["Neon|Fly|Ride"] = 456.71, ["Mega"] = 1470, ["Mega|Ride"] = 3254.99, ["Mega|Fly|Ride"] = 1470}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 17.87, ["Fly|Ride"] = 131.25, ["Neon"] = 3.78, ["Neon|Ride"] = 34.89, ["Neon|Fly|Ride"] = 128.47, ["Mega|Fly"] = 82.05, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 11.3, ["Ride"] = 15.75, ["Fly|Ride"] = 39.37, ["Neon"] = 3.84, ["Neon|Ride"] = 36.66, ["Neon|Fly|Ride"] = 51.19, ["Mega"] = 61.43, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 6.35, ["Fly"] = 41.03, ["Ride"] = 73.48, ["Neon"] = 51.12, ["Neon|Fly|Ride"] = 273.78, ["Mega"] = 527.63, ["Mega|Ride"] = 478.87, ["Mega|Fly|Ride"] = 636.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 232.32, ["Fly"] = 518.44, ["Ride"] = 472.5, ["Fly|Ride"] = 492.19, ["Neon"] = 4101.49, ["Mega|Fly|Ride"] = 7177.59}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 23.33, ["Fly"] = 101.33, ["Ride"] = 41.1, ["Fly|Ride"] = 84.72, ["Neon"] = 205.09, ["Neon|Ride"] = 220.5, ["Neon|Fly|Ride"] = 291.38, ["Mega|Ride"] = 1131.47, ["Mega|Fly|Ride"] = 958.74}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 34.89, ["Fly|Ride"] = 281.29, ["Neon"] = 9.54, ["Neon|Ride"] = 47.39, ["Neon|Fly|Ride"] = 169.31, ["Mega"] = 98.44, ["Mega|Ride"] = 126.99, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 205.09, ["Ride"] = 26.25, ["Fly|Ride"] = 142.7, ["Neon"] = 16.42}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 34.89, ["Fly"] = 162.6, ["Ride"] = 43.5, ["Fly|Ride"] = 102.55, ["Neon|Ride"] = 464.68, ["Neon|Fly|Ride"] = 264.99, ["Mega"] = 2460.89, ["Mega|Ride"] = 1050}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 75.93, ["Ride"] = 101.88, ["Fly|Ride"] = 179.46, ["Neon"] = 434.43, ["Neon|Fly|Ride"] = 547.56, ["Mega"] = 8202.95, ["Mega|Fly|Ride"] = 2044.6}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 196.86, ["Fly"] = 278.81, ["Ride"] = 196.87, ["Fly|Ride"] = 701.36, ["Neon"] = 1050, ["Neon|Fly|Ride"] = 929.34, ["Mega|Fly|Ride"] = 4725}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 27.2, ["Fly"] = 51.19, ["Ride"] = 43.8, ["Fly|Ride"] = 150.94, ["Neon"] = 82.69, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 170.63, ["Mega|Fly|Ride"] = 334.46}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 18.38, ["Fly|Ride"] = 41.9, ["Neon"] = 15.4, ["Neon|Ride"] = 36.43, ["Neon|Fly|Ride"] = 91.11, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 131.15}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 6.16, ["Fly"] = 38.53, ["Ride"] = 16.01, ["Fly|Ride"] = 42.37, ["Neon"] = 31.5, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 92.99, ["Mega"] = 358.89, ["Mega|Fly|Ride"] = 383.5}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 334.68, ["Fly"] = 478.87, ["Ride"] = 301.88, ["Fly|Ride"] = 588.58, ["Neon|Fly|Ride"] = 1710.33, ["Mega"] = 9843.54}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Neon"] = 2050.76, ["Neon|Fly|Ride"] = 122.04, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.93, ["Ride"] = 15.74, ["Fly|Ride"] = 40.92, ["Neon"] = 26.25, ["Neon|Ride"] = 31.81, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 204.06, ["Mega|Fly"] = 204.06, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 244.06}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 15.52, ["Ride"] = 137.07, ["Neon"] = 271.84, ["Neon|Fly|Ride"] = 295.08, ["Mega|Ride"] = 594.72, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 119.44, ["Fly"] = 157.5, ["Ride"] = 109.71, ["Fly|Ride"] = 127.32, ["Neon"] = 634.72, ["Neon|Fly|Ride"] = 656.25}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 26.67, ["Fly"] = 43.29, ["Ride"] = 27.69, ["Fly|Ride"] = 63.38, ["Neon"] = 96.41, ["Neon|Ride"] = 109.74, ["Neon|Fly|Ride"] = 151.77, ["Mega"] = 682.91, ["Mega|Ride"] = 507.66, ["Mega|Fly|Ride"] = 531.76}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Neon"] = 2.1, ["Neon|Fly|Ride"] = 683.93, ["Mega"] = 20.48, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 13.74, ["Fly|Ride"] = 72.19, ["Neon"] = 2.1, ["Neon|Ride"] = 30.61, ["Neon|Fly|Ride"] = 72.76, ["Mega|Fly"] = 83.25, ["Mega|Ride"] = 48.09, ["Mega|Fly|Ride"] = 123.05}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 11.13, ["Fly"] = 410.17, ["Ride"] = 89.22, ["Fly|Ride"] = 96.41, ["Neon"] = 37.42, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 185.88, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 353.49}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1455.15, ["Fly"] = 1603.05, ["Ride"] = 1271.82, ["Fly|Ride"] = 1365, ["Neon"] = 4200, ["Neon|Ride"] = 4200, ["Neon|Fly|Ride"] = 3609.38}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 446.24, ["Ride"] = 555.08, ["Fly|Ride"] = 625.65, ["Neon"] = 2407.58, ["Neon|Fly|Ride"] = 2050.76, ["Mega"] = 16405.9, ["Mega|Fly|Ride"] = 8202.95}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 346.5, ["Ride"] = 383.24, ["Fly|Ride"] = 488.63, ["Neon"] = 975.78, ["Neon|Ride"] = 922.84, ["Neon|Fly|Ride"] = 786.19, ["Mega|Fly|Ride"] = 2362.4}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 294, ["Fly"] = 410.86, ["Ride"] = 410.82, ["Fly|Ride"] = 454.16, ["Neon"] = 925.32, ["Neon|Fly|Ride"] = 1139.6, ["Mega|Fly|Ride"] = 4778.23}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 64.31, ["Ride"] = 14.39, ["Fly|Ride"] = 33.68, ["Neon"] = 7.66, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 137.41, ["Mega|Ride"] = 137.78}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 353.76, ["Fly"] = 1367.85, ["Ride"] = 672.6, ["Fly|Ride"] = 549.94, ["Neon"] = 1367.85, ["Neon|Ride"] = 1845.67, ["Neon|Fly|Ride"] = 1381.19, ["Mega|Ride"] = 6562.38, ["Mega|Fly|Ride"] = 4796.49}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.45, ["Fly"] = 183.75, ["Ride"] = 88.24, ["Neon"] = 15.54, ["Neon|Ride"] = 48.29, ["Neon|Fly|Ride"] = 205.43, ["Mega|Ride"] = 183.35, ["Mega|Fly|Ride"] = 369.14}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 24.7, ["Ride"] = 17.36, ["Fly|Ride"] = 31.01, ["Neon"] = 7.87, ["Neon|Ride"] = 69.75, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 104.81, ["Mega|Ride"] = 192.93}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 3.93}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 37.19, ["Fly|Ride"] = 459.38, ["Neon"] = 244.13, ["Neon|Ride"] = 351.29, ["Mega"] = 656.25, ["Mega|Ride"] = 929.34}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 7744.56, ["Ride"] = 23.22, ["Fly|Ride"] = 45.94, ["Neon"] = 41.03, ["Mega"] = 328.13, ["Mega|Ride"] = 422.86, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.12, ["Neon"] = 3.18, ["Neon|Fly|Ride"] = 116.91, ["Mega"] = 20.52, ["Mega|Ride"] = 90.2}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.63, ["Fly"] = 36.01, ["Ride"] = 20.52, ["Fly|Ride"] = 67.4, ["Neon"] = 9.19, ["Neon|Ride"] = 40.57, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 110.97, ["Mega|Fly"] = 171.26, ["Mega|Fly|Ride"] = 184.71}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.93, ["Fly"] = 55.38, ["Ride"] = 15.4, ["Fly|Ride"] = 51.97, ["Neon"] = 30.78, ["Neon|Ride"] = 155.68, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 237.57, ["Mega|Fly|Ride"] = 326.08}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 12.85, ["Ride"] = 27.69, ["Neon"] = 62.74, ["Mega"] = 504.17, ["Mega|Ride"] = 768.02, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 6196.12, ["Ride"] = 41.03, ["Neon"] = 37.79, ["Neon|Fly|Ride"] = 273.78, ["Mega"] = 441.35}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 98.44, ["Ride"] = 18.38, ["Fly|Ride"] = 45.94, ["Neon"] = 6.17, ["Neon|Ride"] = 23.94, ["Neon|Fly|Ride"] = 59.49, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 152.4, ["Ride"] = 178.5, ["Fly|Ride"] = 209.99, ["Neon"] = 1686.78, ["Neon|Ride"] = 2563.43, ["Neon|Fly|Ride"] = 1007.18, ["Mega"] = 8202.95, ["Mega|Fly|Ride"] = 4101.49}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 15.87, ["Ride"] = 14.94, ["Fly|Ride"] = 41.03, ["Neon"] = 4.18, ["Neon|Ride"] = 17.63, ["Neon|Fly|Ride"] = 53.8, ["Mega|Fly|Ride"] = 121.79}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 11.63, ["Fly"] = 137.41, ["Ride"] = 55.38, ["Fly|Ride"] = 183.75, ["Neon"] = 205.09, ["Mega|Ride"] = 464.68, ["Mega|Fly|Ride"] = 515.79}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 26.25, ["Ride"] = 205.09, ["Fly|Ride"] = 170.63, ["Neon"] = 147.87, ["Neon|Ride"] = 410.17, ["Mega"] = 786.19, ["Mega|Ride"] = 906.1, ["Mega|Fly|Ride"] = 944.99}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 171.76, ["Ride"] = 253.21, ["Fly|Ride"] = 309.5, ["Neon"] = 708.74, ["Neon|Fly|Ride"] = 912.99, ["Mega|Fly|Ride"] = 3405.01}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 15.75, ["Fly"] = 168.88, ["Fly|Ride"] = 139.41, ["Neon"] = 155.67, ["Mega"] = 287.44, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1230.45}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 8.69, ["Ride"] = 137.41, ["Fly|Ride"] = 615.23, ["Neon"] = 89.22, ["Mega"] = 771.75, ["Mega|Ride"] = 615.23, ["Mega|Fly|Ride"] = 2050.76}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1050, ["Fly"] = 1438.6, ["Ride"] = 1043.44, ["Fly|Ride"] = 1154.99, ["Neon"] = 4649.03, ["Neon|Fly|Ride"] = 4614.17, ["Mega|Fly|Ride"] = 17876.29}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 7.87, ["Fly"] = 19.58, ["Ride"] = 19.5, ["Fly|Ride"] = 43.32, ["Neon"] = 26.25, ["Neon|Fly|Ride"] = 82.05, ["Mega"] = 232.35, ["Mega|Fly|Ride"] = 345.19}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 5.16, ["Ride"] = 35.44, ["Fly|Ride"] = 135.19, ["Neon"] = 96.41, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 242.05, ["Mega|Fly|Ride"] = 594.72}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 81.02, ["Ride"] = 27.3, ["Fly|Ride"] = 69.57, ["Neon"] = 46.49, ["Neon|Ride"] = 30.3, ["Neon|Fly|Ride"] = 205.09, ["Mega|Ride"] = 189.57}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 15.61, ["Fly"] = 34.88, ["Ride"] = 37.23, ["Fly|Ride"] = 80.27, ["Neon"] = 69.57, ["Neon|Ride"] = 77.04, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 456.74}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.48, ["Fly"] = 20.52, ["Ride"] = 17.74, ["Fly|Ride"] = 40.74, ["Neon"] = 25.57, ["Neon|Ride"] = 64.61, ["Neon|Fly|Ride"] = 93.18, ["Mega"] = 130.24, ["Mega|Fly|Ride"] = 254.3}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 15.4, ["Neon"] = 13.13, ["Neon|Ride"] = 56.25, ["Neon|Fly|Ride"] = 205.09, ["Mega"] = 131.15, ["Mega|Ride"] = 170.63}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 205.09, ["Fly"] = 260.46, ["Ride"] = 229.69, ["Fly|Ride"] = 342.49, ["Neon|Fly|Ride"] = 984.38}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.7, ["Ride"] = 27.69, ["Fly|Ride"] = 72.19, ["Neon"] = 19.64, ["Neon|Ride"] = 27.09, ["Neon|Fly|Ride"] = 119.83, ["Mega"] = 81.38, ["Mega|Fly"] = 410.17, ["Mega|Fly|Ride"] = 258.4}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 2.1, ["Ride"] = 81.79, ["Fly|Ride"] = 88.86, ["Neon"] = 52.5, ["Mega|Ride"] = 244.06, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.89, ["Fly"] = 96.95, ["Ride"] = 26.25, ["Neon"] = 12.75, ["Mega|Fly"] = 137.41, ["Mega|Fly|Ride"] = 410.01}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 393.75, ["Ride"] = 820.32, ["Fly|Ride"] = 696.99, ["Neon"] = 1085.02, ["Neon|Ride"] = 1230.45, ["Mega"] = 4646.65, ["Mega|Ride"] = 4921.77, ["Mega|Fly|Ride"] = 2875.69}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 22.84, ["Fly"] = 116.19, ["Ride"] = 147.67, ["Fly|Ride"] = 187.65, ["Neon"] = 149.5, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 735, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 26.17, ["Fly"] = 74.36, ["Ride"] = 36.66, ["Fly|Ride"] = 98.44, ["Neon"] = 97.67, ["Neon|Ride"] = 203.04, ["Neon|Fly|Ride"] = 262.49, ["Mega|Ride"] = 421.23, ["Mega|Fly|Ride"] = 670.61}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 82.05, ["Neon"] = 3.67, ["Neon|Ride"] = 210, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 235.85}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 76.12, ["Fly"] = 82.35, ["Ride"] = 111.57, ["Fly|Ride"] = 170.63, ["Neon"] = 203.44, ["Neon|Fly|Ride"] = 360.51, ["Mega|Fly|Ride"] = 1011.71}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.03, ["Fly|Ride"] = 52.5, ["Neon"] = 6.46, ["Neon|Fly|Ride"] = 122.04, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 16.93, ["Fly"] = 102.55, ["Ride"] = 28.09, ["Fly|Ride"] = 84, ["Neon"] = 101.08, ["Neon|Ride"] = 161.97, ["Neon|Fly|Ride"] = 137.41, ["Mega"] = 389.82, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 409.14, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 44.27, ["Fly"] = 82.05, ["Ride"] = 79.95, ["Fly|Ride"] = 159.81, ["Neon"] = 262.5, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 356.65, ["Mega"] = 1230.45, ["Mega|Ride"] = 3419.61, ["Mega|Fly|Ride"] = 1169.44}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 13.02, ["Ride"] = 13.84, ["Fly|Ride"] = 30.55, ["Neon"] = 2.1, ["Neon|Ride"] = 18.47, ["Neon|Fly|Ride"] = 30.19, ["Mega|Fly"] = 116.19, ["Mega|Fly|Ride"] = 82.6}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.22, ["Fly"] = 32.82, ["Ride"] = 39.29, ["Fly|Ride"] = 131.25, ["Neon"] = 17.07, ["Neon|Ride"] = 61.53, ["Neon|Fly|Ride"] = 410.17, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 15.12, ["Ride"] = 44.29, ["Fly|Ride"] = 200.99, ["Neon"] = 123.05, ["Mega"] = 1025.38, ["Mega|Ride"] = 559.81}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.67, ["Neon"] = 2.1, ["Neon|Fly|Ride"] = 95.8, ["Mega"] = 20.24, ["Mega|Ride"] = 79.23}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 11.92, ["Fly"] = 182.01, ["Ride"] = 58.7, ["Fly|Ride"] = 164.07, ["Neon"] = 65.51, ["Neon|Ride"] = 218.42, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 503.48, ["Mega|Fly"] = 787.5, ["Mega|Fly|Ride"] = 609.09}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 10.84, ["Fly"] = 101.61, ["Ride"] = 15.4, ["Fly|Ride"] = 98.43, ["Neon"] = 430.5, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 171.94, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 547.56}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.9, ["Ride"] = 18.85, ["Neon"] = 26.17, ["Mega|Fly|Ride"] = 469.88}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 55.07, ["Fly"] = 2050.76, ["Neon"] = 143.99, ["Neon|Ride"] = 388.5, ["Neon|Fly|Ride"] = 6195.15, ["Mega|Ride"] = 577.5, ["Mega|Fly|Ride"] = 473.75}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 145.68, ["Fly|Ride"] = 196.88, ["Neon"] = 12.48, ["Neon|Ride"] = 137.41, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 151.77}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 55.53, ["Neon"] = 3.89, ["Neon|Ride"] = 101.53, ["Mega|Ride"] = 137.41, ["Mega|Fly|Ride"] = 273.78}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 78.75}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 45.93, ["Fly"] = 78.75, ["Ride"] = 39.38, ["Neon|Fly|Ride"] = 313.68, ["Mega"] = 1230.45, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly|Ride"] = 123.05, ["Mega|Ride"] = 273.78, ["Mega|Fly|Ride"] = 307.62}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 417.38, ["Ride"] = 577.5, ["Fly|Ride"] = 641.82, ["Neon"] = 2046.65, ["Neon|Fly|Ride"] = 1443.75, ["Mega"] = 16405.9, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 2.1, ["Fly"] = 26.17, ["Ride"] = 23.45, ["Fly|Ride"] = 66.26, ["Neon"] = 27.69, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 87.71, ["Mega|Fly"] = 153.82, ["Mega|Ride"] = 144.37, ["Mega|Fly|Ride"] = 547.56}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.1, ["Fly"] = 95.55, ["Ride"] = 19.69, ["Fly|Ride"] = 69.21, ["Neon"] = 18.41, ["Neon|Ride"] = 35.91, ["Neon|Fly|Ride"] = 99.65, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 244.3}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 18.38, ["Fly"] = 76.92, ["Ride"] = 64.61, ["Fly|Ride"] = 471.06, ["Neon"] = 126, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 820.32, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 4.19, ["Fly"] = 410.17, ["Ride"] = 38.07, ["Fly|Ride"] = 721.88, ["Neon"] = 30.38, ["Mega"] = 258.57}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 6.56, ["Fly"] = 139.53, ["Ride"] = 137.41, ["Fly|Ride"] = 157.5, ["Neon"] = 102.55, ["Neon|Ride"] = 278.82, ["Neon|Fly|Ride"] = 359.28, ["Mega|Ride"] = 388.01, ["Mega|Fly|Ride"] = 683.93}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 7.29, ["Fly"] = 105, ["Ride"] = 32.82, ["Fly|Ride"] = 133.88, ["Neon"] = 32.9, ["Neon|Ride"] = 158.25, ["Neon|Fly|Ride"] = 204.75, ["Mega|Fly"] = 547.56, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 351.71}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 46.49, ["Ride"] = 12.03, ["Fly|Ride"] = 68.72, ["Neon"] = 2.1, ["Neon|Ride"] = 13.89, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 14.86, ["Mega|Fly"] = 32.21, ["Mega|Fly|Ride"] = 110.96}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 3.94, ["Fly"] = 109.74, ["Ride"] = 27.69, ["Fly|Ride"] = 102.55, ["Neon"] = 40.32, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 102.55, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 714.67}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 262.5, ["Fly"] = 342.49, ["Ride"] = 350.44, ["Fly|Ride"] = 421.32, ["Neon"] = 1239.48, ["Neon|Fly|Ride"] = 1252.12, ["Mega"] = 4374.57, ["Mega|Fly|Ride"] = 4511.64}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 106.32, ["Ride"] = 113.82, ["Fly|Ride"] = 295.07, ["Neon"] = 315, ["Neon|Ride"] = 514.5, ["Neon|Fly|Ride"] = 543.55, ["Mega"] = 2188.15, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1514.63}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 17.06, ["Ride"] = 14.34, ["Fly|Ride"] = 40.85, ["Neon"] = 7.88, ["Neon|Ride"] = 18.6, ["Neon|Fly|Ride"] = 63.31, ["Mega|Fly"] = 204.06, ["Mega|Ride"] = 76.92, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 18.04, ["Ride"] = 15.4, ["Fly|Ride"] = 32.82, ["Neon"] = 6.46, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 62.27, ["Mega"] = 75.91, ["Mega|Fly"] = 344.03, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.3, ["Ride"] = 20.99, ["Fly|Ride"] = 98.44, ["Neon"] = 39.38, ["Mega"] = 205.09, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 236.23, ["Fly"] = 420, ["Ride"] = 249.38, ["Fly|Ride"] = 375.38, ["Neon"] = 1332.99, ["Neon|Fly|Ride"] = 1983.08, ["Mega|Ride"] = 8202.95, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 14.44, ["Ride"] = 13.65, ["Fly|Ride"] = 35.57, ["Neon"] = 18.47, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 82.05, ["Mega"] = 255.93, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 5.84, ["Fly"] = 310.16, ["Ride"] = 83.42, ["Fly|Ride"] = 205.09, ["Neon"] = 54.17, ["Neon|Fly|Ride"] = 273.78, ["Mega"] = 253.32, ["Mega|Ride"] = 287.44, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 28.13, ["Neon"] = 5.19}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 11.1, ["Fly"] = 24.62, ["Ride"] = 20.52, ["Fly|Ride"] = 74.8, ["Neon"] = 79.71, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 137.41, ["Mega"] = 575.19, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 41.03, ["Ride"] = 107.63, ["Fly|Ride"] = 209.99, ["Neon"] = 178.43, ["Neon|Ride"] = 262.49, ["Neon|Fly|Ride"] = 514.76, ["Mega"] = 683.93, ["Mega|Fly"] = 2153.28, ["Mega|Ride"] = 691.69, ["Mega|Fly|Ride"] = 834.67}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 23.36, ["Ride"] = 40.13, ["Fly|Ride"] = 113.82, ["Neon"] = 155.88, ["Neon|Ride"] = 205.09, ["Neon|Fly|Ride"] = 203.44, ["Mega|Ride"] = 929.34, ["Mega|Fly|Ride"] = 745.46}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 20.25, ["Ride"] = 14.6, ["Fly|Ride"] = 34.89, ["Neon"] = 2.52, ["Neon|Ride"] = 18.12, ["Neon|Fly|Ride"] = 45.66, ["Mega"] = 21.14, ["Mega|Fly"] = 28.88, ["Mega|Ride"] = 39.8, ["Mega|Fly|Ride"] = 94.5}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 244.13, ["Ride"] = 270.12, ["Fly|Ride"] = 318.84, ["Neon"] = 721.88, ["Neon|Fly|Ride"] = 1084.85, ["Mega|Fly|Ride"] = 4238.89}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 11.49, ["Fly"] = 101.18, ["Ride"] = 42.37, ["Fly|Ride"] = 105, ["Neon"] = 127.86, ["Neon|Ride"] = 185.88, ["Neon|Fly|Ride"] = 328.13}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 34, ["Ride"] = 15.61, ["Fly|Ride"] = 44.16, ["Neon"] = 5.91, ["Neon|Fly|Ride"] = 108.71, ["Mega|Fly"] = 273.78, ["Mega|Ride"] = 62.74}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 30.78, ["Ride"] = 19.5, ["Fly|Ride"] = 39.5, ["Neon"] = 2.1, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 129.31, ["Mega"] = 28.87, ["Mega|Fly"] = 137.41, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 154.85}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 28.73, ["Fly|Ride"] = 69.29, ["Neon"] = 7.66, ["Neon|Fly|Ride"] = 99.75, ["Mega|Ride"] = 194.09, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 5.97, ["Fly"] = 38.07, ["Ride"] = 28.18, ["Fly|Ride"] = 64.14, ["Neon"] = 56.95, ["Neon|Ride"] = 56.47, ["Neon|Fly|Ride"] = 105, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 373.9}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 9.18, ["Ride"] = 13.13, ["Neon"] = 59.27, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 275.63, ["Mega|Ride"] = 414.75, ["Mega|Fly|Ride"] = 463.49}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 43.3, ["Fly|Ride"] = 273.78, ["Neon"] = 2.1, ["Neon|Ride"] = 41.67, ["Neon|Fly|Ride"] = 100.64, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 6.48, ["Fly"] = 96.41, ["Ride"] = 24.75, ["Fly|Ride"] = 131.25, ["Neon"] = 31.8, ["Neon|Ride"] = 72.62, ["Neon|Fly|Ride"] = 154.63, ["Mega"] = 199.37, ["Mega|Fly|Ride"] = 269.7}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Fly"] = 68.72, ["Ride"] = 191.79, ["Neon"] = 3.94, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 102.3, ["Mega"] = 24.44, ["Mega|Ride"] = 91.35}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 39.63, ["Ride"] = 15.4, ["Fly|Ride"] = 68.62, ["Neon"] = 5.02, ["Neon|Ride"] = 25.62, ["Neon|Fly|Ride"] = 107.63}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 721.86, ["Ride"] = 689.07, ["Fly|Ride"] = 825.57, ["Neon|Ride"] = 3150, ["Neon|Fly|Ride"] = 3248.38, ["Mega|Fly|Ride"] = 17773.74}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 12.75, ["Ride"] = 13.68, ["Fly|Ride"] = 27.68, ["Neon"] = 11.46, ["Neon|Ride"] = 40, ["Neon|Fly|Ride"] = 45.94}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 70.45, ["Fly|Ride"] = 210, ["Neon"] = 8.91, ["Neon|Ride"] = 88.54, ["Neon|Fly|Ride"] = 236.25, ["Mega|Fly|Ride"] = 328.14}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 8.98, ["Fly"] = 30.22, ["Ride"] = 20.87, ["Fly|Ride"] = 52.5, ["Neon"] = 96.41, ["Neon|Ride"] = 102.55, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 683.93, ["Mega|Ride"] = 309.75, ["Mega|Fly|Ride"] = 342.49}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 17.58, ["Ride"] = 14.98, ["Fly|Ride"] = 35.42, ["Neon"] = 6.51, ["Neon|Ride"] = 26.23, ["Neon|Fly|Ride"] = 63.47, ["Mega"] = 65.01, ["Mega|Ride"] = 83.73, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 36.75, ["Ride"] = 47.2, ["Fly|Ride"] = 273.78, ["Neon"] = 116.82, ["Neon|Ride"] = 257.44, ["Mega"] = 918.74, ["Mega|Fly|Ride"] = 1162.79}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 18.8, ["Fly|Ride"] = 63.95, ["Neon"] = 9.31, ["Neon|Ride"] = 31.2, ["Neon|Fly|Ride"] = 104.52, ["Mega"] = 117.11, ["Mega|Ride"] = 114.84, ["Mega|Fly|Ride"] = 279.57}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 73.62, ["Ride"] = 19.36, ["Fly|Ride"] = 65.63, ["Neon"] = 15.32, ["Neon|Ride"] = 41.89, ["Neon|Fly|Ride"] = 111.57, ["Mega|Ride"] = 198.58, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 59.07, ["Neon"] = 15.37, ["Mega"] = 91.8, ["Mega|Ride"] = 171.94, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 15.73, ["Fly|Ride"] = 49.83, ["Neon"] = 3.71, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 97.95, ["Mega|Fly"] = 287.12, ["Mega|Ride"] = 50.61, ["Mega|Fly|Ride"] = 184.57}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 15.63, ["Fly"] = 18.03, ["Ride"] = 20.52, ["Fly|Ride"] = 34.1, ["Neon"] = 309.74, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 98.43, ["Mega"] = 820.32, ["Mega|Ride"] = 464.68}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 846.56, ["Ride"] = 917.44, ["Fly|Ride"] = 1271.47, ["Neon"] = 2106.12, ["Neon|Fly|Ride"] = 2095.42, ["Mega"] = 4654.5, ["Mega|Fly|Ride"] = 7109.91}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 16.72, ["Ride"] = 14.89, ["Fly|Ride"] = 32.75, ["Neon"] = 3.86, ["Neon|Ride"] = 22.58, ["Neon|Fly|Ride"] = 68.19, ["Mega|Ride"] = 68.72, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 5.25, ["Ride"] = 137.41, ["Fly|Ride"] = 116.19, ["Neon"] = 39.32, ["Neon|Ride"] = 212.48, ["Neon|Fly|Ride"] = 273.78, ["Mega"] = 383.5, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 64.32, ["Ride"] = 85.32, ["Fly|Ride"] = 113.28, ["Neon"] = 459.38, ["Neon|Fly|Ride"] = 278.81, ["Mega"] = 3150.32, ["Mega|Fly|Ride"] = 2050.76}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 27.45, ["Ride"] = 45.95, ["Fly|Ride"] = 102.8, ["Neon"] = 205.09, ["Neon|Ride"] = 248.07, ["Mega"] = 926.94, ["Mega|Ride"] = 669.38, ["Mega|Fly|Ride"] = 816.38}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 9.19, ["Ride"] = 26.23, ["Fly|Ride"] = 139.71, ["Neon"] = 28.09, ["Neon|Ride"] = 115.77, ["Neon|Fly|Ride"] = 121.47, ["Mega|Fly|Ride"] = 541.41}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 22.32, ["Ride"] = 63.51, ["Neon"] = 105, ["Neon|Ride"] = 360.76, ["Mega|Fly"] = 504.17, ["Mega|Ride"] = 342.49, ["Mega|Fly|Ride"] = 508.6}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 15.28, ["Fly"] = 126.89, ["Neon"] = 274.36, ["Neon|Fly|Ride"] = 525, ["Mega"] = 924, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 557.81}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 6.91}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 11.8, ["Fly"] = 131248.69, ["Ride"] = 16.22, ["Fly|Ride"] = 78.75, ["Neon"] = 32.82, ["Neon|Fly|Ride"] = 168.18, ["Mega|Fly"] = 463.87, ["Mega|Fly|Ride"] = 547.56}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.1, ["Neon"] = 11.81, ["Mega"] = 867.78}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 56.44, ["Fly"] = 410.17, ["Ride"] = 104.9, ["Fly|Ride"] = 111.6, ["Neon"] = 250.2, ["Neon|Ride"] = 342.71, ["Neon|Fly|Ride"] = 282.19, ["Mega|Ride"] = 820.32, ["Mega|Fly|Ride"] = 788.82}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.77, ["Fly"] = 15.21, ["Ride"] = 17.07, ["Fly|Ride"] = 45.65, ["Neon"] = 27.35, ["Neon|Ride"] = 35.51, ["Neon|Fly|Ride"] = 72.05, ["Mega|Fly"] = 409.14, ["Mega|Ride"] = 195.46, ["Mega|Fly|Ride"] = 203.34}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 4.93, ["Fly"] = 145.62, ["Ride"] = 34.89, ["Fly|Ride"] = 196.88, ["Neon"] = 23.45, ["Neon|Ride"] = 55.38, ["Neon|Fly|Ride"] = 128.63, ["Mega|Ride"] = 168, ["Mega|Fly|Ride"] = 259.85}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 4.99, ["Mega"] = 48.56, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 35.43, ["Fly"] = 65.63, ["Ride"] = 48.21, ["Fly|Ride"] = 92.95, ["Neon"] = 196.88, ["Neon|Ride"] = 231.75, ["Neon|Fly|Ride"] = 302.5, ["Mega"] = 1094.09, ["Mega|Ride"] = 820.32, ["Mega|Fly|Ride"] = 777}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 37.41, ["Fly|Ride"] = 65.54, ["Neon"] = 3.9, ["Neon|Ride"] = 66.27, ["Mega"] = 74.72, ["Mega|Ride"] = 118.11, ["Mega|Fly|Ride"] = 462.2}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 9.19, ["Ride"] = 61.07, ["Fly|Ride"] = 272.76, ["Neon"] = 145.69, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 616.88, ["Mega|Fly|Ride"] = 670.61}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.88, ["Ride"] = 15.65, ["Fly|Ride"] = 40.63, ["Neon"] = 12.5, ["Neon|Ride"] = 27.54, ["Neon|Fly|Ride"] = 65.61, ["Mega"] = 183.75, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 18.13, ["Fly|Ride"] = 77.06, ["Neon"] = 35.44, ["Neon|Ride"] = 410.17, ["Mega"] = 383.5, ["Mega|Ride"] = 396.83, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.5, ["Ride"] = 62.74, ["Neon"] = 38.95, ["Mega"] = 383.5}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 38.57, ["Ride"] = 132.23, ["Neon"] = 269.07, ["Neon|Fly|Ride"] = 642.92, ["Mega"] = 1486.8}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 17.42, ["Ride"] = 109.74, ["Neon"] = 99.02, ["Neon|Ride"] = 410.17, ["Mega"] = 408.11, ["Mega|Ride"] = 355.83, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 8.03, ["Ride"] = 105, ["Neon"] = 162.73, ["Mega"] = 273.78, ["Mega|Ride"] = 1550.82}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 21, ["Ride"] = 105, ["Fly|Ride"] = 367.46, ["Neon"] = 130.2, ["Neon|Fly|Ride"] = 328.13, ["Mega|Fly|Ride"] = 1091.82}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.1, ["Neon"] = 20.52, ["Mega"] = 118.13, ["Mega|Fly|Ride"] = 310.19}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 128.41, ["Ride"] = 17.91, ["Fly|Ride"] = 60.61, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 82.69, ["Mega|Ride"] = 85.98, ["Mega|Fly|Ride"] = 198.94}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 8.35, ["Fly"] = 50.19, ["Ride"] = 288.64, ["Fly|Ride"] = 77.9, ["Neon"] = 26.25, ["Neon|Ride"] = 41.55, ["Neon|Fly|Ride"] = 163.96, ["Mega|Ride"] = 155.68, ["Mega|Fly|Ride"] = 388.01}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 16.71, ["Fly|Ride"] = 55.95, ["Neon"] = 5.25, ["Neon|Ride"] = 22.79, ["Neon|Fly|Ride"] = 66.99, ["Mega"] = 45.93, ["Mega|Fly|Ride"] = 280.1}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.84, ["Fly"] = 45.94, ["Ride"] = 26.67, ["Fly|Ride"] = 118.13, ["Neon"] = 32.82, ["Neon|Ride"] = 105.63, ["Neon|Fly|Ride"] = 254.3, ["Mega"] = 250.37, ["Mega|Ride"] = 307.13, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 4.24, ["Fly"] = 65.63, ["Ride"] = 22.32, ["Fly|Ride"] = 103.69, ["Neon"] = 27.69, ["Neon|Ride"] = 155.68, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 464.68, ["Mega|Ride"] = 273.78, ["Mega|Fly|Ride"] = 1230.45}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.84, ["Fly"] = 26.17, ["Ride"] = 22.46, ["Fly|Ride"] = 45.68, ["Neon"] = 26.24, ["Neon|Ride"] = 39.51, ["Neon|Fly|Ride"] = 118.01, ["Mega"] = 209.41, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 385.23}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.49, ["Ride"] = 18.58, ["Fly|Ride"] = 45.8, ["Neon"] = 15.75, ["Neon|Ride"] = 55.8, ["Neon|Fly|Ride"] = 183.57, ["Mega"] = 210, ["Mega|Ride"] = 137.41, ["Mega|Fly|Ride"] = 246.09}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 2.1, ["Fly"] = 57.66, ["Ride"] = 31.38, ["Neon"] = 15.31, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 142.21, ["Mega"] = 95.82, ["Mega|Fly"] = 176.5, ["Mega|Fly|Ride"] = 261.66}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 18.47, ["Fly"] = 205.09, ["Ride"] = 98.43, ["Fly|Ride"] = 291.38, ["Neon"] = 124.69, ["Neon|Ride"] = 354.8, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly"] = 752.63, ["Mega|Ride"] = 522.38, ["Mega|Fly|Ride"] = 732.17}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 61.53, ["Ride"] = 104.56, ["Fly|Ride"] = 245.44, ["Neon"] = 269.06, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 1312.5, ["Mega|Ride"] = 1116.94, ["Mega|Fly|Ride"] = 1212.8}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 50.96, ["Ride"] = 19.51, ["Fly|Ride"] = 54.45, ["Neon"] = 2.1, ["Neon|Ride"] = 96.41, ["Mega|Ride"] = 69.82, ["Mega|Fly|Ride"] = 165.38}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 27.69}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 60.38, ["Ride"] = 97.13, ["Neon"] = 246.09, ["Neon|Ride"] = 341.25, ["Mega|Ride"] = 1217.13, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 6.57, ["Fly"] = 190.32, ["Ride"] = 33.5, ["Fly|Ride"] = 126, ["Neon"] = 40.69, ["Neon|Fly|Ride"] = 236.25, ["Mega|Ride"] = 242.82, ["Mega|Fly|Ride"] = 383.92}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 3.83, ["Ride"] = 123.05, ["Fly|Ride"] = 139.76, ["Neon"] = 8.22, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 94.4, ["Mega|Fly|Ride"] = 325.4}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 23.63, ["Ride"] = 15.56, ["Fly|Ride"] = 47.25, ["Neon"] = 13.13, ["Neon|Ride"] = 28.41, ["Neon|Fly|Ride"] = 105.63, ["Mega"] = 151.77, ["Mega|Fly"] = 342.49, ["Mega|Ride"] = 310.19, ["Mega|Fly|Ride"] = 219.19}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.74, ["Ride"] = 15.4, ["Fly|Ride"] = 40.74, ["Neon"] = 2.63, ["Neon|Ride"] = 23.25, ["Neon|Fly|Ride"] = 40.69, ["Mega|Ride"] = 69.56}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 15.75, ["Fly|Ride"] = 83.87, ["Neon"] = 5.25, ["Neon|Ride"] = 56.6, ["Neon|Fly|Ride"] = 98.44, ["Mega|Fly"] = 168, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 75.89, ["Neon"] = 2.1, ["Mega"] = 19.5, ["Mega|Fly|Ride"] = 310.7}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 6.95, ["Ride"] = 104.98, ["Neon"] = 65.54, ["Neon|Ride"] = 155.81, ["Neon|Fly|Ride"] = 615.23, ["Mega"] = 213.94, ["Mega|Fly|Ride"] = 191.02}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 15.46, ["Ride"] = 30.18, ["Fly|Ride"] = 202.98, ["Neon"] = 49.88, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 137.41, ["Mega|Ride"] = 310.19, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 5.23, ["Fly"] = 22.8, ["Ride"] = 23.61, ["Fly|Ride"] = 41.09, ["Neon"] = 39.29, ["Neon|Ride"] = 38.16, ["Neon|Fly|Ride"] = 91.88, ["Mega|Ride"] = 547.56, ["Mega|Fly|Ride"] = 332.5}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 61.57, ["Ride"] = 45.93, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 4646.69, ["Mega|Fly|Ride"] = 1743.14}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 24.43, ["Fly"] = 82.67, ["Ride"] = 65.63, ["Neon"] = 282.19, ["Neon|Fly|Ride"] = 630, ["Mega"] = 950.92, ["Mega|Ride"] = 827.54, ["Mega|Fly|Ride"] = 889.01}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 24.94, ["Ride"] = 16.37, ["Fly|Ride"] = 38, ["Neon"] = 2.35, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 41.66, ["Mega|Ride"] = 127.32, ["Mega|Fly|Ride"] = 188.97}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 14.6, ["Ride"] = 15.25, ["Fly|Ride"] = 38.98, ["Neon"] = 3.68, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 45.94, ["Mega|Fly"] = 82.05, ["Mega|Ride"] = 56.32, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 541.15, ["Ride"] = 534.18, ["Fly|Ride"] = 549.94, ["Neon|Fly|Ride"] = 1884.09}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 9.21, ["Ride"] = 65.63, ["Neon"] = 40.69, ["Neon|Ride"] = 137.41, ["Neon|Fly|Ride"] = 159.92, ["Mega"] = 364.88, ["Mega|Ride"] = 388.01, ["Mega|Fly|Ride"] = 996.19}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Ride"] = 15.27, ["Fly|Ride"] = 34.13, ["Neon"] = 3.94, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 140.76, ["Mega|Ride"] = 74.99, ["Mega|Fly|Ride"] = 105.44}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 51.28, ["Ride"] = 93.19, ["Fly|Ride"] = 342.49, ["Neon"] = 260.98, ["Neon|Ride"] = 410.17, ["Neon|Fly|Ride"] = 449.13}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 36.98, ["Ride"] = 16.68, ["Fly|Ride"] = 41.03, ["Neon"] = 8.7, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 66.85, ["Mega|Ride"] = 129.83, ["Mega|Fly|Ride"] = 236.03}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 69.57, ["Ride"] = 42.84, ["Neon"] = 2.1, ["Neon|Fly|Ride"] = 98.44, ["Mega|Ride"] = 64.54}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 53.45, ["Fly"] = 195.09, ["Ride"] = 75.89, ["Fly|Ride"] = 164.07, ["Neon"] = 169.32, ["Neon|Ride"] = 191.26, ["Neon|Fly|Ride"] = 328.14, ["Mega"] = 787.5, ["Mega|Ride"] = 630, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 17.54, ["Fly|Ride"] = 52.5, ["Neon"] = 10.27, ["Neon|Ride"] = 96.41, ["Neon|Fly|Ride"] = 63, ["Mega"] = 41.03, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 47.25, ["Ride"] = 69.43, ["Fly|Ride"] = 137.41, ["Neon"] = 233.19, ["Neon|Ride"] = 347.62, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 1620.1, ["Mega|Ride"] = 1640.61, ["Mega|Fly|Ride"] = 1228.49}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 2.1, ["Ride"] = 156.33, ["Fly|Ride"] = 155.88, ["Neon"] = 16.59, ["Neon|Fly|Ride"] = 478.87, ["Mega"] = 104.99, ["Mega|Ride"] = 603.75, ["Mega|Fly|Ride"] = 584.73}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 3.94, ["Fly"] = 68.72, ["Ride"] = 26.25, ["Fly|Ride"] = 65.64, ["Neon"] = 10.19, ["Neon|Ride"] = 153.82, ["Neon|Fly|Ride"] = 406.88, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 34.13, ["Ride"] = 145.69, ["Fly|Ride"] = 213.63, ["Neon"] = 138.44, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 2598.75, ["Mega|Fly|Ride"] = 1367.85}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 32.82, ["Fly|Ride"] = 908.98, ["Neon"] = 6.21, ["Neon|Ride"] = 137.41, ["Neon|Fly|Ride"] = 152.19, ["Mega"] = 59.49, ["Mega|Fly"] = 262.5, ["Mega|Fly|Ride"] = 181.92}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 14.21, ["Ride"] = 17.45, ["Fly|Ride"] = 141.5, ["Neon"] = 10.49, ["Neon|Ride"] = 23.61, ["Neon|Fly|Ride"] = 116.19, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 9.98, ["Fly"] = 51.28, ["Ride"] = 32.24, ["Fly|Ride"] = 77.84, ["Neon"] = 77.84, ["Neon|Ride"] = 155.68, ["Neon|Fly|Ride"] = 137.41, ["Mega"] = 430.5, ["Mega|Ride"] = 403.11, ["Mega|Fly|Ride"] = 393.72}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 8.22, ["Ride"] = 137.41, ["Fly|Ride"] = 85.97, ["Neon"] = 98.44, ["Neon|Ride"] = 289.27, ["Neon|Fly|Ride"] = 205.09, ["Mega"] = 897.22, ["Mega|Fly|Ride"] = 2050.76}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 22.71, ["Fly"] = 48.21, ["Ride"] = 28.25, ["Fly|Ride"] = 68.72, ["Neon"] = 82.05, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 123.05, ["Mega"] = 548.03, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 422.46}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 65.63, ["Fly"] = 135.19, ["Ride"] = 164.07, ["Fly|Ride"] = 223.13, ["Neon"] = 262.49, ["Neon|Ride"] = 465.53, ["Neon|Fly|Ride"] = 539.44, ["Mega|Fly|Ride"] = 1141.88}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.94, ["Fly"] = 137.41, ["Ride"] = 50.74, ["Fly|Ride"] = 307.62, ["Neon"] = 23.63, ["Neon|Fly|Ride"] = 305.82, ["Mega|Ride"] = 342.49, ["Mega|Fly|Ride"] = 367.11}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 5.24, ["Ride"] = 26.57, ["Fly|Ride"] = 137.41, ["Neon"] = 21.17, ["Neon|Ride"] = 76.92, ["Neon|Fly|Ride"] = 137.45, ["Mega|Fly|Ride"] = 246.62}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 13.11, ["Fly"] = 287.55, ["Ride"] = 30.78, ["Fly|Ride"] = 160.13, ["Neon"] = 64.32, ["Neon|Ride"] = 262.49, ["Mega"] = 426.57, ["Mega|Fly|Ride"] = 547.56}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.4, ["Fly|Ride"] = 25.89, ["Neon"] = 2.1, ["Neon|Ride"] = 12.98, ["Neon|Fly|Ride"] = 37.68, ["Mega"] = 14.36, ["Mega|Fly"] = 65.64}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 44.62, ["Ride"] = 137.41, ["Fly|Ride"] = 273.78, ["Neon"] = 362.55, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 488.1, ["Mega"] = 1258.14, ["Mega|Ride"] = 945, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 21.41, ["Fly|Ride"] = 112.22, ["Neon"] = 3.51, ["Neon|Ride"] = 27.44, ["Neon|Fly|Ride"] = 129.93, ["Mega|Ride"] = 76.13, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 27.8, ["Ride"] = 15.72, ["Fly|Ride"] = 45.94, ["Neon"] = 11.71, ["Neon|Ride"] = 32.83, ["Neon|Fly|Ride"] = 96.41, ["Mega"] = 260.46, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 111.59, ["Ride"] = 131.08, ["Fly|Ride"] = 273.78, ["Neon"] = 367.5, ["Neon|Ride"] = 540.75, ["Neon|Fly|Ride"] = 511.88, ["Mega|Fly|Ride"] = 1048.95}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 23.67, ["Neon"] = 12.31, ["Neon|Ride"] = 59.49, ["Neon|Fly|Ride"] = 96.41, ["Mega|Fly|Ride"] = 234.94}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 2.23}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 27.64, ["Fly|Ride"] = 46.49, ["Neon"] = 5.16, ["Neon|Ride"] = 50.04, ["Neon|Fly|Ride"] = 116.25, ["Mega|Ride"] = 111.54, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 145.67, ["Ride"] = 182.54, ["Fly|Ride"] = 262.5, ["Neon"] = 576.22, ["Neon|Ride"] = 671.64, ["Neon|Fly|Ride"] = 787.5, ["Mega|Fly|Ride"] = 2042.5}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.94, ["Ride"] = 38.98, ["Neon"] = 19.56, ["Neon|Ride"] = 55.79, ["Neon|Fly|Ride"] = 219.43, ["Mega"] = 183.44, ["Mega|Ride"] = 202.85}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 81.81, ["Neon"] = 3.45, ["Neon|Ride"] = 25.2, ["Neon|Fly|Ride"] = 65.63, ["Mega|Ride"] = 100.5}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 5.7, ["Ride"] = 27.69, ["Neon"] = 47.01, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 410.17, ["Mega|Fly|Ride"] = 614.76}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 13.12, ["Fly"] = 25.47, ["Ride"] = 20.97, ["Fly|Ride"] = 54.66, ["Neon"] = 92.14, ["Neon|Ride"] = 138.44, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 597.19, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 21.87, ["Ride"] = 60.29, ["Fly|Ride"] = 109.74, ["Neon"] = 170.63, ["Neon|Ride"] = 246.09, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 704.17}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 151.77, ["Fly"] = 210.98, ["Ride"] = 160.01, ["Fly|Ride"] = 257.08, ["Neon"] = 591.45, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 636.69, ["Mega|Fly|Ride"] = 2623.69}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 30.17, ["Fly"] = 130.76, ["Ride"] = 45.85, ["Fly|Ride"] = 68.16, ["Neon"] = 341.21, ["Neon|Ride"] = 144.27, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 903.36, ["Mega|Ride"] = 876.7, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 131.23, ["Ride"] = 19.27, ["Fly|Ride"] = 65.63, ["Neon"] = 11.27, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 258.4}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 24.07, ["Fly"] = 232.35, ["Ride"] = 32.45, ["Fly|Ride"] = 123.05, ["Neon"] = 131.25, ["Neon|Ride"] = 114.14, ["Neon|Fly|Ride"] = 262.49, ["Mega|Ride"] = 431.82, ["Mega|Fly|Ride"] = 393.74}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 51.06, ["Fly"] = 139.41, ["Ride"] = 81.38, ["Fly|Ride"] = 133.58, ["Neon"] = 320.25, ["Neon|Ride"] = 245.44, ["Neon|Fly|Ride"] = 408.11, ["Mega|Ride"] = 1094.09, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 19.85, ["Ride"] = 128.64, ["Neon"] = 137.41, ["Neon|Ride"] = 550.77, ["Neon|Fly|Ride"] = 452.21, ["Mega"] = 683.82, ["Mega|Ride"] = 813.18, ["Mega|Fly|Ride"] = 917.73}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.39, ["Ride"] = 362.88, ["Neon|Ride"] = 3098.19, ["Neon|Fly|Ride"] = 2050.76}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 27.04, ["Ride"] = 35.9, ["Fly|Ride"] = 74.92, ["Neon"] = 224.26, ["Neon|Ride"] = 307.62, ["Neon|Fly|Ride"] = 291.38, ["Mega"] = 1034.25, ["Mega|Ride"] = 922.62, ["Mega|Fly|Ride"] = 955.13}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 37.37, ["Ride"] = 15.4, ["Fly|Ride"] = 28.88, ["Neon"] = 2.1, ["Neon|Ride"] = 14.11, ["Neon|Fly|Ride"] = 68.72, ["Mega|Fly"] = 102.74, ["Mega|Ride"] = 48.21, ["Mega|Fly|Ride"] = 112.87}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 6.46, ["Neon"] = 18.27, ["Neon|Ride"] = 524.98, ["Neon|Fly|Ride"] = 259.9, ["Mega"] = 143.83, ["Mega|Ride"] = 278.25, ["Mega|Fly|Ride"] = 273.78}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 2.1, ["Ride"] = 29.75, ["Fly|Ride"] = 144.19, ["Neon"] = 16.7, ["Neon|Ride"] = 683.93, ["Neon|Fly|Ride"] = 957.71, ["Mega|Fly"] = 498.61, ["Mega|Ride"] = 262.97, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 417.42, ["Ride"] = 458.07, ["Fly|Ride"] = 616.88, ["Neon"] = 1393.96, ["Neon|Ride"] = 1435.53, ["Neon|Fly|Ride"] = 1431.88, ["Mega|Fly|Ride"] = 4862.82}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 5.02, ["Fly"] = 63.73, ["Ride"] = 15.65, ["Fly|Ride"] = 52.71, ["Neon"] = 38.49, ["Neon|Ride"] = 66.4, ["Neon|Fly|Ride"] = 86.52, ["Mega"] = 168, ["Mega|Ride"] = 272.76, ["Mega|Fly|Ride"] = 376.32}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 11.64, ["Fly"] = 21.29, ["Ride"] = 16.36, ["Fly|Ride"] = 32.16, ["Neon"] = 26.71, ["Neon|Ride"] = 410.17, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 683.93, ["Mega|Fly|Ride"] = 286.38}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.24, ["Fly"] = 32.71, ["Ride"] = 27.69, ["Neon"] = 12.5, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 155.68, ["Mega|Ride"] = 266.61, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 30.19, ["Fly"] = 34.93, ["Ride"] = 40.2, ["Fly|Ride"] = 98, ["Neon"] = 140.44, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 819.29}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 27.69, ["Fly|Ride"] = 50.3, ["Neon"] = 6.35, ["Neon|Fly|Ride"] = 210, ["Mega"] = 162.09, ["Mega|Fly|Ride"] = 985.04}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 5.29, ["Fly"] = 64.26, ["Ride"] = 25.47, ["Fly|Ride"] = 85.63, ["Neon"] = 141.72, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 155.68, ["Mega|Fly|Ride"] = 547.56}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.17, ["Neon"] = 3.93, ["Neon|Ride"] = 27.69, ["Mega|Ride"] = 92.95, ["Mega|Fly|Ride"] = 232.78}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 55.69, ["Ride"] = 137.41, ["Neon"] = 109.74, ["Mega"] = 547.56}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 35.9, ["Neon"] = 76.79, ["Mega"] = 302.5, ["Mega|Ride"] = 464.57}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 7.47, ["Fly"] = 28.69, ["Ride"] = 20.32, ["Fly|Ride"] = 68.83, ["Neon"] = 51.12, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 119.44, ["Mega"] = 576.28, ["Mega|Ride"] = 313.69, ["Mega|Fly|Ride"] = 416.07}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 305.71, ["Fly"] = 438.87, ["Ride"] = 328.13, ["Fly|Ride"] = 367.5, ["Neon"] = 1239.48, ["Neon|Ride"] = 1371.7, ["Neon|Fly|Ride"] = 1394.52, ["Mega|Fly|Ride"] = 5195.55}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Fly"] = 31.8, ["Ride"] = 15.32, ["Fly|Ride"] = 39.38, ["Neon"] = 11.71, ["Neon|Ride"] = 41.03, ["Neon|Fly|Ride"] = 130.6, ["Mega"] = 219.44, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 5.24, ["Fly"] = 109.74, ["Ride"] = 45.92, ["Fly|Ride"] = 77.84, ["Neon"] = 41.03, ["Neon|Ride"] = 154.82, ["Neon|Fly|Ride"] = 406.88}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 16.42, ["Ride"] = 118.5, ["Fly|Ride"] = 183.75, ["Neon"] = 144.27, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 658.3, ["Mega"] = 328.13, ["Mega|Ride"] = 374.51, ["Mega|Fly|Ride"] = 547.56}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 128.41, ["Fly|Ride"] = 443.58, ["Neon"] = 903.36, ["Neon|Fly|Ride"] = 1435.53, ["Mega"] = 3098.17, ["Mega|Ride"] = 7744.8, ["Mega|Fly|Ride"] = 3541.63}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 25.02, ["Fly"] = 91.88, ["Ride"] = 124.31, ["Fly|Ride"] = 142.63, ["Neon"] = 68.72, ["Neon|Fly|Ride"] = 213.29, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 360.94}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 16.95, ["Fly|Ride"] = 57.66, ["Neon"] = 13.02, ["Neon|Fly|Ride"] = 69.47, ["Mega"] = 65.58, ["Mega|Ride"] = 151.77, ["Mega|Fly|Ride"] = 155.68}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 6.49, ["Ride"] = 41.03, ["Neon"] = 26.25, ["Neon|Ride"] = 547.56, ["Neon|Fly|Ride"] = 174.57, ["Mega"] = 169.32, ["Mega|Fly|Ride"] = 306.99}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 62.34, ["Fly"] = 196.88, ["Ride"] = 137.41, ["Fly|Ride"] = 202.63, ["Neon"] = 168.08, ["Neon|Ride"] = 182.49, ["Neon|Fly|Ride"] = 304.5, ["Mega"] = 482.96, ["Mega|Ride"] = 683.93, ["Mega|Fly|Ride"] = 619.4}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Fly|Ride"] = 123.05, ["Neon"] = 6.46, ["Neon|Ride"] = 205.09, ["Neon|Fly|Ride"] = 190.31, ["Mega|Ride"] = 163.31, ["Mega|Fly|Ride"] = 156.19}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 19.68, ["Neon"] = 105, ["Mega"] = 683.93, ["Mega|Fly|Ride"] = 811.09}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 1023.75, ["Fly"] = 2050.76, ["Ride"] = 1150.21, ["Fly|Ride"] = 1076.25, ["Neon"] = 3554.96, ["Neon|Ride"] = 3874.19, ["Neon|Fly|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 11621.53}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 23.63, ["Fly"] = 76.61, ["Ride"] = 166.85, ["Fly|Ride"] = 191.63, ["Neon"] = 112.88, ["Mega|Fly|Ride"] = 649.69}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.26, ["Ride"] = 25.98, ["Fly|Ride"] = 80.89, ["Neon"] = 10.02, ["Neon|Ride"] = 32.83, ["Neon|Fly|Ride"] = 91.47, ["Mega"] = 75.89, ["Mega|Ride"] = 109.74, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 9.96, ["Ride"] = 47.25, ["Fly|Ride"] = 137.41, ["Neon"] = 202.28, ["Neon|Fly|Ride"] = 393.73, ["Mega"] = 410.17, ["Mega|Ride"] = 421.71}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 18.6, ["Fly|Ride"] = 59.49, ["Neon"] = 3.68, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 91.87, ["Mega|Fly"] = 123.05, ["Mega|Ride"] = 48.21, ["Mega|Fly|Ride"] = 155.22}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 95.75, ["Ride"] = 117.93, ["Fly|Ride"] = 236.24, ["Neon"] = 820.32, ["Neon|Ride"] = 410.93, ["Mega|Ride"] = 1042.13, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 8.51, ["Ride"] = 44.1, ["Fly|Ride"] = 124.69, ["Neon"] = 62.11, ["Neon|Fly|Ride"] = 256.75, ["Mega"] = 669.38, ["Mega|Ride"] = 544.48, ["Mega|Fly|Ride"] = 553.88}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 26.67, ["Neon"] = 11.76, ["Neon|Ride"] = 46.49, ["Mega|Ride"] = 157.49, ["Mega|Fly|Ride"] = 547.56}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 28.19, ["Fly"] = 151.77, ["Ride"] = 109.74, ["Fly|Ride"] = 111.74, ["Neon"] = 227.64, ["Neon|Fly|Ride"] = 342.49, ["Mega"] = 684.36, ["Mega|Fly|Ride"] = 1068.75}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 6.57, ["Ride"] = 35.9, ["Fly|Ride"] = 98.32, ["Neon"] = 50.11, ["Neon|Fly|Ride"] = 315, ["Mega|Ride"] = 512.7, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 63, ["Ride"] = 84, ["Neon"] = 388, ["Neon|Fly|Ride"] = 210, ["Mega"] = 1860.03, ["Mega|Ride"] = 2323.34, ["Mega|Fly|Ride"] = 1579.08}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 5.16, ["Ride"] = 59.49, ["Fly|Ride"] = 78.75, ["Neon"] = 30.22, ["Neon|Ride"] = 86.2, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 226.94, ["Mega|Fly|Ride"] = 288.15}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 6.45, ["Ride"] = 20.45, ["Fly|Ride"] = 78.75, ["Neon"] = 82.05, ["Neon|Ride"] = 137.41, ["Neon|Fly|Ride"] = 124.31, ["Mega|Fly|Ride"] = 545.35}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 124.69, ["Ride"] = 177.18, ["Fly|Ride"] = 376.32, ["Neon"] = 568.99, ["Neon|Ride"] = 629.58, ["Neon|Fly|Ride"] = 636.57, ["Mega|Ride"] = 2335.15, ["Mega|Fly|Ride"] = 1903.13}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 29.75, ["Ride"] = 15.65, ["Fly|Ride"] = 37.8, ["Neon"] = 13.15, ["Neon|Ride"] = 30.64, ["Neon|Fly|Ride"] = 68.25, ["Mega"] = 124.69, ["Mega|Ride"] = 232.35, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 5.73, ["Fly"] = 99.75, ["Ride"] = 27.05, ["Fly|Ride"] = 62.74, ["Neon"] = 74.69, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 137.41, ["Mega|Ride"] = 427.75, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 16.34, ["Ride"] = 14.37, ["Fly|Ride"] = 43.31, ["Neon"] = 2.1, ["Neon|Ride"] = 14.85, ["Neon|Fly|Ride"] = 39.29, ["Mega|Fly"] = 48.81, ["Mega|Ride"] = 33.74, ["Mega|Fly|Ride"] = 106.45}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 55.38, ["Fly|Ride"] = 39.38, ["Neon"] = 2.63, ["Mega|Fly"] = 104.99, ["Mega|Fly|Ride"] = 125.99}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 34.89, ["Ride"] = 18.38, ["Fly|Ride"] = 85.8, ["Neon"] = 26.25, ["Neon|Ride"] = 101.06, ["Mega|Ride"] = 116.17, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 58.97, ["Ride"] = 52.47, ["Fly|Ride"] = 131.25, ["Neon"] = 114.09, ["Neon|Ride"] = 437.07, ["Neon|Fly|Ride"] = 433.13, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 664.44}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 14.31, ["Ride"] = 14.81, ["Fly|Ride"] = 36.92, ["Neon"] = 13.08, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 68.87, ["Mega|Fly"] = 170.61, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 3.82, ["Fly"] = 39.38, ["Ride"] = 19.68, ["Fly|Ride"] = 66.89, ["Neon"] = 28.25, ["Neon|Ride"] = 31.18, ["Neon|Fly|Ride"] = 105, ["Mega|Fly"] = 410.17, ["Mega|Ride"] = 192.66, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.26, ["Fly"] = 21.84, ["Ride"] = 15.99, ["Fly|Ride"] = 82.05, ["Neon"] = 7.25, ["Neon|Ride"] = 20.06, ["Neon|Fly|Ride"] = 89.22, ["Mega|Fly"] = 220.5, ["Mega|Fly|Ride"] = 129.93}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 8.39, ["Fly"] = 169.32, ["Ride"] = 23.34, ["Neon"] = 27.53, ["Neon|Fly|Ride"] = 273.78, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 321.57}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 6.56, ["Fly"] = 127.46, ["Ride"] = 135.35, ["Fly|Ride"] = 157.5, ["Neon"] = 65.62, ["Neon|Ride"] = 123.05, ["Mega"] = 478.87, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.68, ["Fly"] = 41.88, ["Ride"] = 27.69, ["Fly|Ride"] = 44.35, ["Neon"] = 22.26, ["Neon|Ride"] = 55.38, ["Neon|Fly|Ride"] = 109.4, ["Mega"] = 328.14, ["Mega|Ride"] = 297.94, ["Mega|Fly|Ride"] = 418.28}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 21.27, ["Ride"] = 15.42, ["Fly|Ride"] = 34.95, ["Neon"] = 13.85, ["Neon|Ride"] = 41.03, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 209.9, ["Mega|Ride"] = 232.35}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 183.75, ["Fly"] = 393.75, ["Ride"] = 306.68, ["Fly|Ride"] = 445.03, ["Neon"] = 1095.43, ["Neon|Fly|Ride"] = 1094.09, ["Mega|Fly|Ride"] = 3740.63}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 4.27, ["Ride"] = 63.67, ["Neon"] = 42.95, ["Neon|Fly|Ride"] = 410.17, ["Mega"] = 118.13, ["Mega|Ride"] = 420.6, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.1, ["Fly"] = 102.55, ["Ride"] = 21.84, ["Fly|Ride"] = 48.58, ["Neon"] = 20.48, ["Neon|Ride"] = 41.03, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 203.23, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 273.78}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 3.92, ["Ride"] = 41.03, ["Neon"] = 60.9, ["Neon|Fly|Ride"] = 603.74, ["Mega"] = 603.74, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 549.29}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 11.44, ["Fly|Ride"] = 26.03, ["Neon"] = 2.1, ["Neon|Ride"] = 16.84, ["Neon|Fly|Ride"] = 27.76, ["Mega|Fly"] = 68.72, ["Mega|Ride"] = 41.03, ["Mega|Fly|Ride"] = 96.46}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 22.04, ["Ride"] = 18.94, ["Fly|Ride"] = 61.45, ["Neon"] = 12.63, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 96.76, ["Mega|Fly|Ride"] = 208.69}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.1, ["Ride"] = 144.38, ["Neon"] = 39.38, ["Neon|Ride"] = 273.78, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 342.49, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 75.51, ["Fly"] = 162.65, ["Ride"] = 113.82, ["Fly|Ride"] = 173.25, ["Neon"] = 556.49, ["Neon|Ride"] = 1367.85, ["Neon|Fly|Ride"] = 446.25, ["Mega"] = 2050.76, ["Mega|Ride"] = 3419.61, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 6.56, ["Fly"] = 81.29, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 22.18, ["Neon|Fly|Ride"] = 137.41, ["Mega|Ride"] = 356.12, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 20.99, ["Ride"] = 49.09, ["Neon"] = 5.16, ["Neon|Fly|Ride"] = 530.14, ["Mega|Fly"] = 313.69, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 342.49}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 52.5, ["Fly"] = 210, ["Ride"] = 94.39, ["Fly|Ride"] = 209.11, ["Neon"] = 115.76, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 273.78, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 14.44, ["Ride"] = 14.13, ["Fly|Ride"] = 35.44, ["Neon"] = 2.1, ["Neon|Ride"] = 18.47, ["Neon|Fly|Ride"] = 38.98, ["Mega|Fly"] = 49.88, ["Mega|Ride"] = 35.44, ["Mega|Fly|Ride"] = 87.27}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 65.54, ["Neon|Fly|Ride"] = 209.34, ["Mega|Ride"] = 87.27, ["Mega|Fly|Ride"] = 384.53}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 48.44, ["Neon"] = 8.69, ["Neon|Fly|Ride"] = 180.48, ["Mega|Fly"] = 178.43, ["Mega|Ride"] = 116.94, ["Mega|Fly|Ride"] = 219.51}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 3.94, ["Fly"] = 77.17, ["Ride"] = 30.76, ["Fly|Ride"] = 205.09, ["Neon"] = 19.68, ["Neon|Ride"] = 106.38, ["Neon|Fly|Ride"] = 217.4, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 137.65, ["Mega|Fly|Ride"] = 254.42}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 11.31, ["Ride"] = 15.4, ["Fly|Ride"] = 35.9, ["Neon"] = 2.1, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 39.29, ["Mega"] = 18.04, ["Mega|Ride"] = 49.23, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 17.42, ["Fly"] = 131.25, ["Ride"] = 125.09, ["Neon"] = 109.12, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 957.71, ["Mega"] = 513.64, ["Mega|Ride"] = 438.38}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2610.55, ["Ride"] = 2781.41, ["Fly|Ride"] = 2625, ["Neon|Fly|Ride"] = 9688.21, ["Mega|Fly|Ride"] = 35820.22}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 137.88, ["Ride"] = 15.44, ["Fly|Ride"] = 40, ["Neon"] = 7.97, ["Neon|Ride"] = 24.62, ["Neon|Fly|Ride"] = 68.72, ["Mega"] = 96.41, ["Mega|Fly"] = 457.32, ["Mega|Ride"] = 155.68, ["Mega|Fly|Ride"] = 177.02}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Neon"] = 13.95, ["Mega"] = 140.37, ["Mega|Fly"] = 441, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 20.7, ["Fly"] = 109.74, ["Ride"] = 31.17, ["Fly|Ride"] = 105, ["Neon"] = 130.24, ["Neon|Ride"] = 310.7, ["Neon|Fly|Ride"] = 220.5, ["Mega|Fly|Ride"] = 383.94}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 35.44, ["Ride"] = 41.14, ["Neon"] = 187.69, ["Mega"] = 1252.02, ["Mega|Ride"] = 683.93, ["Mega|Fly|Ride"] = 773.15}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 153.45, ["Fly"] = 1367.85, ["Ride"] = 197.87, ["Fly|Ride"] = 302.5, ["Neon"] = 1312.5, ["Neon|Ride"] = 700.41, ["Neon|Fly|Ride"] = 971.04, ["Mega"] = 6152.22, ["Mega|Fly|Ride"] = 3478.13}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 8.22, ["Ride"] = 28.88, ["Fly|Ride"] = 675.94, ["Neon"] = 20.13, ["Neon|Ride"] = 146.32, ["Mega"] = 156.19, ["Mega|Fly|Ride"] = 582.75}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Neon"] = 18.37, ["Neon|Ride"] = 273.78, ["Mega"] = 130.86, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 101.99, ["Ride"] = 34.73, ["Fly|Ride"] = 131.25, ["Neon"] = 10.5, ["Neon|Ride"] = 137.41, ["Mega"] = 84.9, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 105, ["Ride"] = 100.5, ["Neon"] = 145.69, ["Mega|Ride"] = 615.23, ["Mega|Fly|Ride"] = 786.48}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 82.05, ["Mega"] = 18.47, ["Mega|Fly"] = 116.27, ["Mega|Ride"] = 82.05, ["Mega|Fly|Ride"] = 273.78}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 96.41, ["Fly"] = 205.09, ["Ride"] = 113.86, ["Fly|Ride"] = 178.43, ["Neon"] = 262.5, ["Neon|Ride"] = 451.5, ["Neon|Fly|Ride"] = 512.32, ["Mega"] = 2086.88, ["Mega|Fly|Ride"] = 1732.89}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 91.82, ["Neon"] = 10.4, ["Neon|Fly|Ride"] = 205.09, ["Mega"] = 127.32, ["Mega|Ride"] = 272.76, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 47.23, ["Fly"] = 205.09, ["Ride"] = 90.01, ["Fly|Ride"] = 157.39, ["Neon"] = 289.4, ["Neon|Ride"] = 328.02, ["Mega"] = 1435.53}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 21.18, ["Fly|Ride"] = 53.03, ["Neon"] = 3.94, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 83.99}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Ride"] = 45.28, ["Neon"] = 19.69, ["Mega|Fly|Ride"] = 615.23}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 12.5, ["Fly"] = 77.43, ["Neon"] = 67.2, ["Neon|Ride"] = 339.94, ["Mega"] = 232.79, ["Mega|Ride"] = 369.14, ["Mega|Fly|Ride"] = 620.33}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 406.01, ["Ride"] = 453.86, ["Fly|Ride"] = 588.58, ["Neon"] = 1181.25, ["Neon|Ride"] = 1722.62, ["Neon|Fly|Ride"] = 1378.12, ["Mega|Ride"] = 4725, ["Mega|Fly|Ride"] = 4198.69}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 41.03, ["Ride"] = 66.23, ["Fly|Ride"] = 82.05, ["Neon"] = 278.67, ["Neon|Fly|Ride"] = 355.83}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.62, ["Fly"] = 52.5, ["Ride"] = 16.94, ["Fly|Ride"] = 91.88, ["Neon"] = 7.79, ["Neon|Ride"] = 21.87, ["Neon|Fly|Ride"] = 101.49, ["Mega"] = 65.63, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 12.47, ["Fly"] = 219.19, ["Ride"] = 49.87, ["Fly|Ride"] = 124.31, ["Neon"] = 65.56, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 182.39, ["Mega|Fly"] = 956.06, ["Mega|Fly|Ride"] = 379.21}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 6.45, ["Ride"] = 20.69, ["Fly|Ride"] = 82.05, ["Neon"] = 140.59, ["Neon|Ride"] = 116.91, ["Neon|Fly|Ride"] = 263.71, ["Mega"] = 1094.09, ["Mega|Ride"] = 514.5, ["Mega|Fly|Ride"] = 412.84}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.94, ["Neon"] = 14.4, ["Mega"] = 72.17, ["Mega|Ride"] = 91.88}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 3.84, ["Fly"] = 39.38, ["Ride"] = 22.19, ["Fly|Ride"] = 55.38, ["Neon"] = 25.47, ["Neon|Ride"] = 31.9, ["Neon|Fly|Ride"] = 274.41, ["Mega"] = 137.41, ["Mega|Ride"] = 410.17, ["Mega|Fly|Ride"] = 1640.61}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 103.94, ["Fly"] = 342.49, ["Ride"] = 147, ["Fly|Ride"] = 235.62, ["Neon"] = 696.99, ["Neon|Ride"] = 616.88, ["Neon|Fly|Ride"] = 816.21, ["Mega|Fly|Ride"] = 2596.25}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 28.45, ["Ride"] = 69.83, ["Fly|Ride"] = 137.41, ["Neon"] = 178.43, ["Neon|Ride"] = 205.09, ["Neon|Fly|Ride"] = 273.78, ["Mega"] = 889.01, ["Mega|Ride"] = 799.8, ["Mega|Fly|Ride"] = 697.27}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2218.12, ["Fly"] = 2349.38, ["Ride"] = 2324.52, ["Fly|Ride"] = 2165.62, ["Neon"] = 10937.61, ["Neon|Fly|Ride"] = 6424.59, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.62, ["Fly"] = 65625, ["Ride"] = 77.54, ["Neon"] = 12.15, ["Neon|Fly|Ride"] = 103.69, ["Mega|Fly"] = 786.19, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 9.02, ["Ride"] = 78.26, ["Neon"] = 36.53, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 551.5, ["Mega|Ride"] = 547.56, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 1036.88, ["Fly"] = 1159.32, ["Ride"] = 968.88, ["Fly|Ride"] = 918.75, ["Neon"] = 2778.57, ["Neon|Ride"] = 2611.87, ["Neon|Fly|Ride"] = 2782.49, ["Mega"] = 11073.99, ["Mega|Fly|Ride"] = 11156.25}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 28.86, ["Fly"] = 82.05, ["Ride"] = 57.51, ["Fly|Ride"] = 173.35, ["Neon"] = 157.5, ["Mega"] = 839.9, ["Mega|Ride"] = 804.56, ["Mega|Fly|Ride"] = 1367.85}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.94, ["Ride"] = 23, ["Fly|Ride"] = 137.41, ["Neon"] = 9.49, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 247.42, ["Mega|Fly|Ride"] = 547.56}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 111.09, ["Ride"] = 137.41, ["Neon"] = 3.94, ["Mega"] = 19.5, ["Mega|Ride"] = 105.63, ["Mega|Fly|Ride"] = 246.09}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 84.93, ["Ride"] = 127.34, ["Fly|Ride"] = 170.63, ["Neon"] = 459.38, ["Neon|Fly|Ride"] = 551.25, ["Mega"] = 4100.46, ["Mega|Fly|Ride"] = 4101.49}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.1, ["Neon"] = 14.44, ["Neon|Ride"] = 137.41, ["Mega|Fly|Ride"] = 263.71}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 73.5, ["Ride"] = 102.38, ["Neon"] = 385.88, ["Neon|Ride"] = 713.67, ["Neon|Fly|Ride"] = 494.32}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 6.57, ["Fly"] = 105, ["Fly|Ride"] = 109.74, ["Neon"] = 26.2, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 153.4, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 262.39, ["Ride"] = 330.75, ["Fly|Ride"] = 369.11, ["Neon"] = 1438.92, ["Neon|Ride"] = 1053.65, ["Neon|Fly|Ride"] = 879.02, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 2.73, ["Fly"] = 87.94, ["Ride"] = 19.3, ["Fly|Ride"] = 103.76, ["Neon"] = 40.85, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 114.18, ["Mega"] = 342.49, ["Mega|Ride"] = 272.76, ["Mega|Fly|Ride"] = 386.42}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 15.74, ["Fly|Ride"] = 32.81, ["Neon"] = 3.94, ["Neon|Ride"] = 20.52, ["Neon|Fly|Ride"] = 60.47, ["Mega"] = 78.75, ["Mega|Fly"] = 129.33, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 918.65, ["Ride"] = 1050, ["Fly|Ride"] = 1194.38, ["Neon|Fly|Ride"] = 5469.33, ["Mega"] = 25976.69}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 8.55, ["Fly"] = 957.71, ["Ride"] = 72.19, ["Fly|Ride"] = 205.09, ["Neon"] = 42.77, ["Mega|Ride"] = 383.5, ["Mega|Fly|Ride"] = 551.55}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 5.25, ["Fly"] = 46.1, ["Ride"] = 42.69, ["Fly|Ride"] = 127.32, ["Neon"] = 26.25, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 130.79, ["Mega|Fly"] = 226.63, ["Mega|Ride"] = 198.09, ["Mega|Fly|Ride"] = 223.01}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 28.91, ["Fly"] = 32.71, ["Ride"] = 47.24, ["Fly|Ride"] = 65.54, ["Neon|Ride"] = 224.44, ["Neon|Fly|Ride"] = 203.33, ["Mega"] = 2050.76, ["Mega|Ride"] = 1230.45, ["Mega|Fly|Ride"] = 761.25}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 13.38, ["Fly"] = 82.05, ["Ride"] = 26.25, ["Fly|Ride"] = 91.87, ["Neon"] = 72.86, ["Neon|Ride"] = 88.3, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 355.83, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 377.9}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 30.85, ["Ride"] = 82.05, ["Fly|Ride"] = 636.57, ["Neon"] = 118.64, ["Mega"] = 572.17, ["Mega|Ride"] = 572.17, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Fly|Ride"] = 273.78, ["Neon"] = 2.36, ["Neon|Ride"] = 111.02, ["Neon|Fly|Ride"] = 310.19, ["Mega"] = 17.01, ["Mega|Ride"] = 89.1}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 52.49, ["Fly"] = 114.19, ["Ride"] = 92.19, ["Fly|Ride"] = 155.67, ["Neon"] = 393.75, ["Neon|Ride"] = 356.65, ["Neon|Fly|Ride"] = 439.92, ["Mega"] = 3281.2, ["Mega|Ride"] = 1687.76, ["Mega|Fly|Ride"] = 1234.3}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 103.31, ["Ride"] = 23.15, ["Fly|Ride"] = 109.74, ["Neon"] = 51.19, ["Mega"] = 773.07, ["Mega|Ride"] = 382.67, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 20.79, ["Ride"] = 20.52, ["Fly|Ride"] = 38.07, ["Neon"] = 15.64, ["Neon|Fly|Ride"] = 122.84, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 3.83, ["Ride"] = 126, ["Neon"] = 20.14, ["Neon|Fly|Ride"] = 183.57, ["Mega"] = 287.12, ["Mega|Fly|Ride"] = 488.1}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 55.13, ["Ride"] = 96.41, ["Fly|Ride"] = 262.5, ["Neon"] = 262.48, ["Neon|Ride"] = 339.42, ["Neon|Fly|Ride"] = 369.14, ["Mega"] = 1459.12, ["Mega|Ride"] = 1076.25, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 14.44, ["Neon"] = 28.88, ["Mega"] = 104.81}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 2.45, ["Neon|Ride"] = 52.5, ["Mega"] = 15.64, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 393.65}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.94, ["Ride"] = 31.65, ["Fly|Ride"] = 38.61, ["Neon"] = 2.62, ["Neon|Ride"] = 42.53, ["Neon|Fly|Ride"] = 118.12, ["Mega|Ride"] = 44.91, ["Mega|Fly|Ride"] = 139.96}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 24.57, ["Ride"] = 14.9, ["Fly|Ride"] = 52.46, ["Neon"] = 6.49, ["Neon|Ride"] = 26.81, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 123.05, ["Mega|Ride"] = 54.44, ["Mega|Fly|Ride"] = 139.55}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 22.32, ["Mega"] = 118.09, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 14.99, ["Fly|Ride"] = 47.25, ["Neon"] = 14.34, ["Neon|Ride"] = 36.43, ["Neon|Fly|Ride"] = 55.38, ["Mega"] = 231.67, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 66.92, ["Ride"] = 101.73, ["Fly|Ride"] = 219.44, ["Neon"] = 196.76, ["Neon|Fly|Ride"] = 1025.38, ["Mega"] = 961.8, ["Mega|Fly"] = 998.72, ["Mega|Ride"] = 971.25, ["Mega|Fly|Ride"] = 1089.99}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 25.65, ["Ride"] = 13.59, ["Fly|Ride"] = 35.23, ["Neon"] = 3.89, ["Neon|Ride"] = 20.56, ["Neon|Fly|Ride"] = 59.07, ["Mega|Ride"] = 31.8, ["Mega|Fly|Ride"] = 129.74}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 52.41, ["Fly"] = 79.19, ["Ride"] = 22.36, ["Fly|Ride"] = 75.96, ["Neon"] = 42, ["Neon|Ride"] = 75.89, ["Neon|Fly|Ride"] = 104.89, ["Mega"] = 362.09, ["Mega|Fly"] = 321.78, ["Mega|Ride"] = 267.65, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 11.33, ["Fly"] = 59.49, ["Ride"] = 31.8, ["Fly|Ride"] = 95.5, ["Neon"] = 110.48, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 210, ["Mega"] = 787.5, ["Mega|Ride"] = 492.09, ["Mega|Fly|Ride"] = 743.48}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.84, ["Fly"] = 196.88, ["Neon"] = 73.41, ["Mega"] = 287.12, ["Mega|Ride"] = 383.49, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.74, ["Fly|Ride"] = 34.89, ["Neon"] = 4.08, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 52.95, ["Mega"] = 39.38, ["Mega|Fly|Ride"] = 114.82}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 5.19, ["Fly"] = 52.5, ["Ride"] = 38.07, ["Neon"] = 18.23, ["Neon|Ride"] = 137.41, ["Mega"] = 137.41, ["Mega|Fly"] = 735, ["Mega|Ride"] = 155.81, ["Mega|Fly|Ride"] = 383.5}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 1078.88, ["Ride"] = 1018.39, ["Fly|Ride"] = 1049.99, ["Neon|Ride"] = 2191.88, ["Neon|Fly|Ride"] = 2361.19, ["Mega|Fly|Ride"] = 6929.7}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 101.67, ["Ride"] = 141.75, ["Fly|Ride"] = 131.25, ["Neon"] = 525, ["Neon|Ride"] = 683.93, ["Neon|Fly|Ride"] = 655.23, ["Mega"] = 2871.05, ["Mega|Ride"] = 2460.89, ["Mega|Fly|Ride"] = 2047.5}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly"] = 55.38, ["Ride"] = 39.38, ["Neon"] = 5.92, ["Neon|Ride"] = 52.41, ["Neon|Fly|Ride"] = 205.09, ["Mega|Fly|Ride"] = 205.09}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 65.62, ["Ride"] = 130.9, ["Fly|Ride"] = 217.24, ["Neon"] = 367.5, ["Neon|Ride"] = 387.19, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 1312.5, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 1496.94}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 6.19, ["Ride"] = 47.16, ["Fly|Ride"] = 89.22, ["Neon"] = 21.51, ["Neon|Ride"] = 68.72, ["Neon|Fly|Ride"] = 273.78, ["Mega"] = 274.02, ["Mega|Ride"] = 175.37, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 297.07, ["Fly"] = 410.17, ["Ride"] = 328.13, ["Fly|Ride"] = 378, ["Neon|Ride"] = 1217.13, ["Neon|Fly|Ride"] = 1739.04, ["Mega|Fly|Ride"] = 4481.9}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 76.4, ["Ride"] = 35.44, ["Fly|Ride"] = 206.76, ["Neon"] = 31.38, ["Mega"] = 354.8, ["Mega|Fly"] = 319.93}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 16.42, ["Mega"] = 328.14}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 28.48, ["Ride"] = 91.87, ["Fly|Ride"] = 153.82, ["Neon"] = 151.77, ["Mega"] = 670.61, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 957.71}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.66, ["Fly|Ride"] = 273.78, ["Neon"] = 20.52, ["Mega"] = 240.19, ["Mega|Fly|Ride"] = 454.22}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 13.36, ["Ride"] = 13.95, ["Fly|Ride"] = 34.79, ["Neon"] = 2.63, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 34.49, ["Mega"] = 19.69, ["Mega|Fly|Ride"] = 76.13}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4593.75, ["Ride"] = 4450.69, ["Fly|Ride"] = 4490.07, ["Neon"] = 30761.05, ["Neon|Fly|Ride"] = 19293.74, ["Mega|Fly|Ride"] = 128171.01}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 11.95, ["Ride"] = 55.44, ["Neon"] = 52.41, ["Mega|Ride"] = 278.88, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.69, ["Ride"] = 20.52, ["Fly|Ride"] = 41.75, ["Neon"] = 16.52, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 68.72, ["Mega"] = 140.44, ["Mega|Ride"] = 166.99, ["Mega|Fly|Ride"] = 239.75}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 495.47, ["Fly"] = 547.77, ["Ride"] = 465.94, ["Fly|Ride"] = 578.46, ["Neon"] = 1640.61, ["Neon|Ride"] = 1640.52, ["Neon|Fly|Ride"] = 1509.82}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 4.54, ["Ride"] = 32.62, ["Neon"] = 18.69, ["Neon|Ride"] = 145.69, ["Mega"] = 140.51, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 6.66, ["Fly"] = 65.63, ["Ride"] = 7127.74, ["Neon"] = 28.64, ["Neon|Fly|Ride"] = 273.78, ["Mega"] = 875.61, ["Mega|Ride"] = 401.63}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.48, ["Ride"] = 17.06, ["Neon"] = 3.69, ["Neon|Ride"] = 26.67, ["Neon|Fly|Ride"] = 91.75, ["Mega"] = 49.7, ["Mega|Fly|Ride"] = 257.24}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 790.48, ["Fly"] = 2050.76, ["Ride"] = 772.35, ["Fly|Ride"] = 844.92, ["Neon"] = 2362.5, ["Neon|Fly|Ride"] = 2362.4}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 7.79, ["Fly"] = 288.09, ["Ride"] = 78.75, ["Neon"] = 31.84, ["Neon|Ride"] = 101.53, ["Neon|Fly|Ride"] = 217.4, ["Mega"] = 157.5, ["Mega|Ride"] = 216.03, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 6.24, ["Fly"] = 236.15, ["Ride"] = 55.38, ["Fly|Ride"] = 137.41, ["Neon"] = 25.07, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 188.68, ["Mega|Ride"] = 220.5, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.1, ["Ride"] = 14.59, ["Neon"] = 14.34, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 272.76, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 208.85}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 13.13, ["Ride"] = 69.83, ["Fly|Ride"] = 155.67, ["Neon"] = 117.59, ["Neon|Fly|Ride"] = 307.62, ["Mega"] = 547.56, ["Mega|Ride"] = 765.96, ["Mega|Fly|Ride"] = 738.27}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Fly|Ride"] = 410.17, ["Neon"] = 5.16, ["Neon|Ride"] = 42.84, ["Neon|Fly|Ride"] = 186.38, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 478.8, ["Ride"] = 538.12, ["Fly|Ride"] = 787.5, ["Neon"] = 2589.57, ["Neon|Fly|Ride"] = 2492.69, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Fly"] = 102.55, ["Ride"] = 72.18, ["Fly|Ride"] = 131.25, ["Neon"] = 14.44, ["Neon|Ride"] = 91.07, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 205.09, ["Mega|Fly|Ride"] = 400.32}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 52.39, ["Neon"] = 3.84, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 64.97, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 273.78}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 45.57, ["Neon"] = 8.22, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 137.41, ["Mega"] = 55.38, ["Mega|Fly"] = 151.77, ["Mega|Ride"] = 69.23, ["Mega|Fly|Ride"] = 145.69}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 27.48, ["Neon"] = 26.67, ["Mega"] = 205.09}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 39.38, ["Fly"] = 98.44, ["Ride"] = 113.45, ["Fly|Ride"] = 295.07, ["Neon"] = 121.95, ["Neon|Ride"] = 134.33, ["Neon|Fly|Ride"] = 272.76, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 19.14, ["Ride"] = 58, ["Fly|Ride"] = 128.99, ["Neon"] = 93.09, ["Neon|Ride"] = 410.17, ["Neon|Fly|Ride"] = 257.15, ["Mega|Fly"] = 547.56, ["Mega|Fly|Ride"] = 560.8}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 19.46, ["Ride"] = 15.52, ["Fly|Ride"] = 31.5, ["Neon"] = 28.88, ["Neon|Ride"] = 35.48, ["Neon|Fly|Ride"] = 76.92, ["Mega"] = 299.92, ["Mega|Ride"] = 426.57, ["Mega|Fly|Ride"] = 263.71}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 9, ["Ride"] = 64.32, ["Fly|Ride"] = 118.96, ["Neon"] = 118.13, ["Mega|Ride"] = 287.12}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 26.17, ["Fly|Ride"] = 111.56, ["Neon"] = 10.29, ["Neon|Ride"] = 68.72, ["Mega|Ride"] = 155.68, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 21, ["Ride"] = 30.17, ["Fly|Ride"] = 131.25, ["Neon"] = 273.78, ["Neon|Fly|Ride"] = 184.57, ["Mega"] = 921.83}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["Fly"] = 874.13, ["Neon"] = 144.38, ["Mega"] = 232.78, ["Mega|Fly|Ride"] = 957.71}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 49.88, ["Fly"] = 115.38, ["Ride"] = 76.26, ["Fly|Ride"] = 185.57, ["Neon"] = 294.96, ["Neon|Ride"] = 313.69, ["Neon|Fly|Ride"] = 273.78, ["Mega|Fly|Ride"] = 1043.44}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 41.99, ["Fly"] = 92.3, ["Ride"] = 45.94, ["Neon"] = 139.55, ["Neon|Ride"] = 155.68, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 620.82}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 14.41, ["Ride"] = 56.44, ["Fly|Ride"] = 137.41, ["Neon"] = 144.38, ["Neon|Ride"] = 274.26, ["Mega"] = 590.63, ["Mega|Ride"] = 752.63, ["Mega|Fly|Ride"] = 1230.45}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 19.69, ["Fly"] = 428.28, ["Ride"] = 47.25, ["Fly|Ride"] = 192.94, ["Neon"] = 102.55, ["Neon|Ride"] = 205.09, ["Neon|Fly|Ride"] = 252.13, ["Mega|Ride"] = 513.38, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.74, ["Ride"] = 11.82, ["Fly|Ride"] = 26.5, ["Neon"] = 5.25, ["Neon|Ride"] = 27.36, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 44.63, ["Mega|Fly"] = 155.68, ["Mega|Ride"] = 76.92}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1253.91}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 52.5, ["Fly"] = 232.35, ["Ride"] = 126.93, ["Fly|Ride"] = 288.75, ["Neon"] = 294, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 538.13, ["Mega"] = 752.63, ["Mega|Ride"] = 1074.6, ["Mega|Fly|Ride"] = 987.96}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 79.71, ["Neon"] = 3.94, ["Neon|Ride"] = 43.18, ["Neon|Fly|Ride"] = 287.62, ["Mega|Ride"] = 84.92, ["Mega|Fly|Ride"] = 164.08}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 27.69, ["Ride"] = 75.89, ["Fly|Ride"] = 166.13, ["Neon"] = 124.69, ["Neon|Ride"] = 143.07, ["Neon|Fly|Ride"] = 544.69, ["Mega|Ride"] = 588.69, ["Mega|Fly|Ride"] = 1229.44}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Mega"] = 26.24}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Mega|Ride"] = 90.62, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 104.89, ["Fly"] = 240.98, ["Ride"] = 154.88, ["Fly|Ride"] = 246.09, ["Neon"] = 582.75, ["Neon|Ride"] = 774.85, ["Neon|Fly|Ride"] = 724.96, ["Mega|Ride"] = 2529.6, ["Mega|Fly|Ride"] = 1824.38}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 34.22, ["Fly|Ride"] = 92.95, ["Neon"] = 3.46, ["Neon|Ride"] = 96.41, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 90.57, ["Mega|Ride"] = 109.81, ["Mega|Fly|Ride"] = 205.09}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 34.99, ["Fly|Ride"] = 86.63, ["Neon"] = 5.81, ["Neon|Fly|Ride"] = 122.04, ["Mega|Ride"] = 123.27, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 82.05, ["Neon"] = 3.67, ["Neon|Ride"] = 210, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 235.85}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 28.13, ["Neon"] = 5.19}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 65.54, ["Ride"] = 133.84, ["Fly|Ride"] = 620.32, ["Neon"] = 419.83, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1504.22, ["Mega|Ride"] = 1538.07, ["Mega|Fly|Ride"] = 1495.01}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.5, ["Ride"] = 62.74, ["Neon"] = 38.95, ["Mega"] = 383.5}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 354.38, ["Ride"] = 409.6, ["Fly|Ride"] = 748.11, ["Neon"] = 1025.38, ["Neon|Ride"] = 1085.02, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 3965.11}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 94.45}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 51.19}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 32.81}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 18.78}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 122.66}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 64.29}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 14.57}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 102.26}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 196.87}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 137.4}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 33.17}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 6.57}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 5.1}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 205.44}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 2.77}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 8.22}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 3.29}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 6.14}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 12.28}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 564.38}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 820.2}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 10.17}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1038.97}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.63}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 50.02}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 7.09}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.63}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 15.75}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 3.94}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 37.57}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 32.82}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 46.69}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 22.57}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 10.4}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 17.31}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.9}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 14.44}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.31}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 155.66}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 8.82}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 7.37}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 6.57}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1890.91}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 48.2}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 307.92}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 2.12}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.63}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 8.23}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 10.27}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 45.6}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 213.94}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 5.32}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 10.4}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 1367.68}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 26.25}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 4.68}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 28.18}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 34.55}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 215.71}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 29.89}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 14.43}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 3.94}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 97.22}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 7.59}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 10.5}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 23.84}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 98.44}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 196.88}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 3.36}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 8.28}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 43.12}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 31.49}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 102.54}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 17.4}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22124.54}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 164.06}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 62.88}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 134.42}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 36.66}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 38.98}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 29.8}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 65.63}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 76.12}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 87.3}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 59.06}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 43.32}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 93.51}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 39.36}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 131.25}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 410.11}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 4.54}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 6.87}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 28.69}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 93.59}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 2.1}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 123.04}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 12.31}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 355.78}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 656.25}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 12.31}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 584.07}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 16.64}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.58}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.57}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 604}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 137.4}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 115.19}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 14.64}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 32.26}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 49.87}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 15.62}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 27.57}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 13.13}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 3.81}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 15.54}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 2.14}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 23.78}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.62}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.89}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 9.12}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 17.07}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 190.19}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 59.07}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.63}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 3.4}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1048.58}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 5.34}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 15.75}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 155.66}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 20.98}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 15.75}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 6.45}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 7.45}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 69.57}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 5.37}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 27.72}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 128.94}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 11.17}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 2.8}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.63}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 9.17}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 10.27}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 2.78}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 2.13}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.5}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 13.12}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7519.13}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.61}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 13.13}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 6.05}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 6.67}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 13.12}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 6.22}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 6.57}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 5.25}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 109.71}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 6.47}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.55}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 3.35}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.37}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.34}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 105}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 6.17}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4338.27}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 6.33}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 155.66}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 6.35}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.94}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 45.94}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 5.2}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 4.54}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 92.64}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.05}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.43}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 7.7}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 7.88}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 23.63}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.89}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.55}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 3.29}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 10.33}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.68}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 5.86}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 18.38}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.37}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 4.66}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 23.61}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 3.62}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 10.26}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 78.66}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.51}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 49.12}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 30.78}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1041.39}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 39.37}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.62}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 4.99}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.05}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 6.17}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 23.46}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.63}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.24}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 15.4}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 6.65}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 137.4}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 15.75}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 14.7}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.17}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 18.38}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 4.54}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 49.23}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 5.19}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 2.5}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 3.62}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 11.46}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.63}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 11.71}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 37.44}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.63}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 8.53}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 21.61}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 52.5}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 8.28}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 52.5}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 32.82}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.62}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.12}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 28.07}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 3}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 10.07}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 38.98}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 175.67}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 2.6}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1011.35}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 3.5}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 246.07}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 31.5}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 70.88}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 72.56}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.15}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 7.33}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 32.71}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 11.71}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 7.88}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 3.92}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 8.87}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 10.5}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 59.36}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 3.7}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 62.06}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.63}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 40}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 131.24}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 8.22}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 74.08}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.45}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.2}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 78.75}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 49.88}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 102.54}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 237.57}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 76.95}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 8.22}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 178.41}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.93}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 3.56}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 27.98}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 48.57}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.83}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 42.95}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 6.3}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 7.46}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 39.38}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.57}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 13.48}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 38.07}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 15.75}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 4.11}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.63}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 17.01}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 683.85}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 3.88}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 26.24}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 6.55}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 5.86}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 37.02}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 45}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 22.23}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1706.25}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 9.11}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 6.3}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 61.55}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 262.5}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 17.94}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 7.88}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 10.5}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 7.01}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 6.57}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 262.5}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 48.19}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 52.5}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 7.34}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 50.67}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 124.69}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 77.4}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 951.57}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 211.21}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 7.43}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2361.19}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 551.23}},
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