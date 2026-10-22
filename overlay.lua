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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1039.06, ["Ride"] = 1050, ["Fly|Ride"] = 1292.82, ["Neon"] = 6805.32, ["Neon|Ride"] = 6562.5, ["Neon|Fly|Ride"] = 4190.06, ["Mega|Fly|Ride"] = 17415.74}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 455.28, ["Ride"] = 497.44, ["Fly|Ride"] = 628.44, ["Neon|Fly|Ride"] = 1967.44, ["Mega|Fly|Ride"] = 6912.74}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4948.13, ["Ride"] = 5249.99, ["Fly|Ride"] = 4689.57, ["Neon|Fly|Ride"] = 20945.1, ["Mega|Fly|Ride"] = 69825.91}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 157.5, ["Ride"] = 221.91, ["Fly|Ride"] = 275.36, ["Neon"] = 978.27, ["Neon|Ride"] = 950.11, ["Neon|Fly|Ride"] = 1042.29, ["Mega|Fly|Ride"] = 3937.49}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 632.62, ["Fly"] = 837.92, ["Ride"] = 538.12, ["Fly|Ride"] = 610.32, ["Neon|Fly|Ride"] = 1745.62, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 9.76, ["Ride"] = 34.13, ["Fly|Ride"] = 159.04, ["Neon"] = 58.95, ["Neon|Ride"] = 120.74, ["Neon|Fly|Ride"] = 404.25, ["Mega"] = 324.84, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 586.56}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.05, ["Fly"] = 34.63, ["Ride"] = 23.43, ["Fly|Ride"] = 61.69, ["Neon"] = 25.95, ["Neon|Fly"] = 127.05, ["Neon|Ride"] = 53.93, ["Neon|Fly|Ride"] = 111.46, ["Mega"] = 154.88, ["Mega|Ride"] = 213.94, ["Mega|Fly|Ride"] = 278.58}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 91.88, ["Fly"] = 209.49, ["Ride"] = 152.27, ["Neon"] = 418.97, ["Neon|Ride"] = 493.5, ["Neon|Fly|Ride"] = 698.71}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 38.52, ["Fly"] = 105, ["Ride"] = 52.38, ["Fly|Ride"] = 103.4, ["Neon"] = 293.29, ["Neon|Ride"] = 237.95, ["Neon|Fly|Ride"] = 334.69, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1234.84}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 17.91, ["Fly"] = 77.73, ["Ride"] = 34.13, ["Fly|Ride"] = 66.94, ["Neon"] = 145.6, ["Neon|Ride"] = 296.07, ["Neon|Fly|Ride"] = 317, ["Mega|Fly|Ride"] = 1895.25}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 45.36, ["Fly"] = 140.37, ["Ride"] = 70.76, ["Fly|Ride"] = 174.2, ["Neon"] = 444.03, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 417.38, ["Mega|Fly|Ride"] = 1298.77}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 52.5}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 313.49, ["Fly"] = 472.28, ["Ride"] = 326.45, ["Fly|Ride"] = 384.55, ["Neon|Ride"] = 1023.75, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 4930.05}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 124.68, ["Fly"] = 187.5, ["Ride"] = 116.82, ["Fly|Ride"] = 183.3, ["Neon|Fly"] = 688.59, ["Neon|Fly|Ride"] = 656.25, ["Mega|Fly|Ride"] = 3047.88}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.63, ["Ride"] = 55.13, ["Fly|Ride"] = 131.24, ["Neon"] = 18.79, ["Neon|Fly"] = 98.48, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 131.25, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 316.33, ["Mega|Fly|Ride"] = 307.56}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 190.26, ["Fly"] = 219.18, ["Ride"] = 178.06, ["Fly|Ride"] = 229.69, ["Neon"] = 831.06, ["Neon|Fly|Ride"] = 630, ["Mega|Fly|Ride"] = 2730}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.63, ["Fly"] = 19.69, ["Ride"] = 19.51, ["Fly|Ride"] = 34.73, ["Neon"] = 35.63, ["Neon|Ride"] = 91.24, ["Neon|Fly|Ride"] = 111.18, ["Mega"] = 209.49, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 418.97}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 81.29, ["Fly"] = 223.13, ["Ride"] = 137.22, ["Fly|Ride"] = 208.36, ["Neon"] = 282.7, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 523.69, ["Mega"] = 1703.79, ["Mega|Ride"] = 1706.15, ["Mega|Fly|Ride"] = 1697.46}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 37.8}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 41.91, ["Ride"] = 102.66, ["Fly|Ride"] = 245.11, ["Neon"] = 559.32, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 1397.22}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 14.39, ["Fly"] = 393.75, ["Ride"] = 31.5, ["Fly|Ride"] = 377.08, ["Neon"] = 206.3, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 930.08}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 45.94, ["Fly"] = 157.5, ["Ride"] = 59.76, ["Fly|Ride"] = 100.27, ["Neon"] = 279.66, ["Neon|Ride"] = 296.81, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 1662.28, ["Mega|Ride"] = 1397.22, ["Mega|Fly|Ride"] = 1068.61}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 32.45, ["Ride"] = 157.5, ["Fly|Ride"] = 140.37, ["Neon"] = 209.9, ["Neon|Ride"] = 363.27, ["Neon|Fly|Ride"] = 467.25, ["Mega"] = 2047.5, ["Mega|Ride"] = 1256.88, ["Mega|Fly|Ride"] = 1279.92}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 16.69, ["Ride"] = 40.37, ["Fly|Ride"] = 140.37, ["Neon"] = 174.92, ["Neon|Ride"] = 314.99, ["Neon|Fly|Ride"] = 299.19, ["Mega"] = 888.2, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 39.29, ["Fly"] = 136.75, ["Ride"] = 65.63, ["Fly|Ride"] = 161.31, ["Neon"] = 430.47, ["Neon|Ride"] = 378.11, ["Neon|Fly|Ride"] = 322.88, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 903.42}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 3.66, ["Fly"] = 26.06, ["Ride"] = 22.23, ["Fly|Ride"] = 52.25, ["Neon"] = 36.74, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 47.16, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 177.31, ["Mega|Fly"] = 27965.14, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 256.94}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 428.75, ["Ride"] = 489.15, ["Fly|Ride"] = 486.87, ["Neon|Ride"] = 1885.53, ["Neon|Fly|Ride"] = 1964.82, ["Mega|Fly|Ride"] = 7665.81}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 12.81, ["Ride"] = 32.32, ["Fly|Ride"] = 59.36, ["Neon"] = 219.19, ["Neon|Ride"] = 140.38, ["Neon|Fly|Ride"] = 279.7, ["Mega|Ride"] = 796.03, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 4.35, ["Fly"] = 34.61, ["Ride"] = 20.03, ["Fly|Ride"] = 44.63, ["Neon"] = 77.3, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 138.97, ["Mega"] = 209.49, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 81.9, ["Fly"] = 112.59, ["Ride"] = 102.67, ["Fly|Ride"] = 129.09, ["Neon"] = 360.31, ["Neon|Fly"] = 376.72, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 489.2, ["Mega"] = 3912, ["Mega|Ride"] = 7875, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 9.09, ["Ride"] = 26.17, ["Fly|Ride"] = 75.21, ["Neon"] = 116.28, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 207.95, ["Mega"] = 698.62, ["Mega|Ride"] = 799.17, ["Mega|Fly|Ride"] = 837.92}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 205.7, ["Fly"] = 354.03, ["Ride"] = 224.16, ["Fly|Ride"] = 262.5, ["Neon"] = 656.25, ["Neon|Ride"] = 949.78, ["Mega"] = 6284.31, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 25.58}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.19, ["Fly"] = 31.86, ["Ride"] = 23.47, ["Fly|Ride"] = 59.36, ["Neon"] = 17.8, ["Neon|Fly"] = 140.38, ["Neon|Ride"] = 52.47, ["Neon|Fly|Ride"] = 127.09, ["Mega"] = 145.69, ["Mega|Fly"] = 211.54, ["Mega|Ride"] = 155.01, ["Mega|Fly|Ride"] = 282.8}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 926.88, ["Fly"] = 2625, ["Ride"] = 918.75, ["Fly|Ride"] = 1089.99, ["Neon"] = 7158.38, ["Neon|Ride"] = 6145.76, ["Neon|Fly|Ride"] = 4448.43, ["Mega|Ride"] = 53429.75, ["Mega|Fly|Ride"] = 17097.53}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 6.7, ["Fly"] = 70.19, ["Ride"] = 21.52, ["Fly|Ride"] = 91.88, ["Neon"] = 140.37, ["Neon|Ride"] = 137.81, ["Neon|Fly|Ride"] = 231.51, ["Mega"] = 787.5, ["Mega|Ride"] = 1045.31, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 170.63, ["Ride"] = 192.85, ["Fly|Ride"] = 309, ["Neon"] = 1101.78, ["Neon|Ride"] = 813.65, ["Neon|Fly|Ride"] = 934.47, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 44.35}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 15.26, ["Fly"] = 111.57, ["Ride"] = 65.63, ["Fly|Ride"] = 140.37, ["Neon"] = 104.9, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 684.53, ["Mega|Ride"] = 1105, ["Mega|Fly|Ride"] = 587.75}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 3.68}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 129.24, ["Ride"] = 136.5, ["Fly|Ride"] = 236.25, ["Neon"] = 639.19, ["Neon|Fly|Ride"] = 698.71, ["Mega|Fly|Ride"] = 2723.17}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 131.25, ["Fly"] = 182.25, ["Ride"] = 144.38, ["Fly|Ride"] = 274.31, ["Neon"] = 315, ["Neon|Fly"] = 559.38, ["Neon|Ride"] = 312.84, ["Neon|Fly|Ride"] = 590.63, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1498.62}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 30.19}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 52.5, ["Fly"] = 90.08, ["Ride"] = 53.76, ["Fly|Ride"] = 78.75, ["Neon|Ride"] = 489.15, ["Neon|Fly|Ride"] = 365.15, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 6.03, ["Fly"] = 70.19, ["Ride"] = 35.38, ["Fly|Ride"] = 202.96, ["Neon"] = 40.86, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 125.64, ["Neon|Fly|Ride"] = 559.38, ["Mega"] = 241.96, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 328.41, ["Mega|Fly|Ride"] = 598.5}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 446.15, ["Fly"] = 455.1, ["Ride"] = 451.4, ["Fly|Ride"] = 531.45, ["Neon|Ride"] = 1836.61, ["Neon|Fly|Ride"] = 1649.16, ["Mega|Fly|Ride"] = 8006.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 90.56, ["Fly"] = 155.03, ["Ride"] = 122.06, ["Fly|Ride"] = 147, ["Neon"] = 459.38, ["Neon|Ride"] = 768.89, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 2512.69, ["Mega|Fly|Ride"] = 2529.44}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3150, ["Ride"] = 4469.19, ["Fly|Ride"] = 3675}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 39.38, ["Fly"] = 112.09, ["Ride"] = 49.88, ["Fly|Ride"] = 173.87, ["Neon|Ride"] = 308.68, ["Neon|Fly|Ride"] = 553.1, ["Mega"] = 1360.57, ["Mega|Ride"] = 2094.78, ["Mega|Fly|Ride"] = 1256.88}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 63, ["Ride"] = 85.32, ["Fly|Ride"] = 111.57, ["Neon"] = 575.75, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 710.84, ["Mega|Ride"] = 2235.13, ["Mega|Fly|Ride"] = 3960.83}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 32.67, ["Fly"] = 52.41, ["Ride"] = 45, ["Fly|Ride"] = 85.32, ["Neon"] = 167.63, ["Neon|Ride"] = 140.2, ["Neon|Fly|Ride"] = 203.13, ["Mega"] = 2625, ["Mega|Ride"] = 791.96, ["Mega|Fly|Ride"] = 656.15}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 6.24}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 37.99, ["Ride"] = 93.76, ["Fly|Ride"] = 57.15, ["Neon|Ride"] = 317, ["Neon|Fly|Ride"] = 419.03, ["Mega|Fly|Ride"] = 1493.63}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 35.44}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 223.12, ["Ride"] = 236.25, ["Fly|Ride"] = 318.94, ["Neon|Ride"] = 1089.43}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 942.65, ["Ride"] = 943.69, ["Fly|Ride"] = 1108.45, ["Neon"] = 2887.5, ["Neon|Ride"] = 3073.41, ["Neon|Fly|Ride"] = 3142.55, ["Mega|Fly|Ride"] = 10820.36}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 5.25}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 25.61, ["Fly"] = 39.35, ["Ride"] = 37.67, ["Fly|Ride"] = 66.94, ["Neon"] = 209.44, ["Neon|Ride"] = 134.48, ["Neon|Fly|Ride"] = 278.65, ["Mega|Ride"] = 1132.43, ["Mega|Fly|Ride"] = 938.11}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 14.44}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5250, ["Fly|Ride"] = 4923.19, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 41478.11}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 11.7, ["Fly"] = 52.41, ["Ride"] = 18.9, ["Fly|Ride"] = 53.9, ["Neon"] = 95.82, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 219.19, ["Mega"] = 693, ["Mega|Ride"] = 1536.53, ["Mega|Fly|Ride"] = 614.25}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 14.93, ["Ride"] = 36.66, ["Neon"] = 78.75, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 727.13, ["Mega|Ride"] = 831.14, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 70.88, ["Fly"] = 276.59, ["Ride"] = 74.39, ["Fly|Ride"] = 83.81, ["Neon|Ride"] = 388.64, ["Neon|Fly|Ride"] = 476.14, ["Mega"] = 4189.55}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 9.89, ["Fly"] = 150.93, ["Ride"] = 30.39, ["Fly|Ride"] = 126, ["Neon"] = 56.57, ["Neon|Ride"] = 133.08, ["Neon|Fly|Ride"] = 501.38, ["Mega|Ride"] = 740.35, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1443.75, ["Fly"] = 2318.92, ["Ride"] = 1706.25, ["Fly|Ride"] = 1893.83, ["Neon|Ride"] = 4357.66, ["Neon|Fly|Ride"] = 3567.36, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 26250, ["Fly"] = 33516.28, ["Ride"] = 32025, ["Fly|Ride"] = 24937.5, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 72498.88, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183750}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 16.99, ["Fly"] = 393.75, ["Ride"] = 67.26, ["Fly|Ride"] = 127, ["Neon"] = 279.66, ["Neon|Ride"] = 279.7, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 1101.86, ["Mega|Ride"] = 1141.88, ["Mega|Fly|Ride"] = 833.73}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.88, ["Fly"] = 81.35, ["Ride"] = 41.29, ["Fly|Ride"] = 151.57, ["Neon"] = 20.47, ["Neon|Fly"] = 197.98, ["Neon|Ride"] = 59.8, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 128.63, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 328.02}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 15.75}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.46, ["Ride"] = 36.74, ["Fly|Ride"] = 124.68, ["Neon"] = 88.41, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 554.44, ["Mega"] = 306.18, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 626.07}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 768.8, ["Ride"] = 791.58, ["Fly|Ride"] = 903, ["Neon|Fly|Ride"] = 2566.95, ["Mega|Fly|Ride"] = 11082.53}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 918.74, ["Fly"] = 918.75, ["Ride"] = 1015.88, ["Fly|Ride"] = 1022.91, ["Neon|Ride"] = 3247.31, ["Neon|Fly|Ride"] = 3109.32, ["Mega|Fly|Ride"] = 10551.19}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 11.88, ["Fly"] = 118.69, ["Ride"] = 35.63, ["Fly|Ride"] = 65.62, ["Neon"] = 72.18, ["Neon|Ride"] = 119.9, ["Neon|Fly|Ride"] = 278.65, ["Mega"] = 1204.13, ["Mega|Ride"] = 480.38, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 22.32}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 61.36, ["Fly"] = 111.3, ["Ride"] = 77.05, ["Fly|Ride"] = 111.14, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 420, ["Mega|Ride"] = 2050.79, ["Mega|Fly|Ride"] = 1664.25}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 72.18, ["Ride"] = 85.32, ["Fly|Ride"] = 213.63, ["Neon"] = 450.19, ["Neon|Ride"] = 330.74, ["Neon|Fly|Ride"] = 553.88, ["Mega"] = 1363.05, ["Mega|Fly|Ride"] = 2271.94}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.59, ["Fly"] = 30.55, ["Ride"] = 19.98, ["Fly|Ride"] = 38.75, ["Neon"] = 41.91, ["Neon|Fly"] = 524.98, ["Neon|Ride"] = 64.96, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 321.57, ["Mega|Fly|Ride"] = 525.99}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 141.64, ["Fly"] = 161.44, ["Ride"] = 144.38, ["Fly|Ride"] = 196.87, ["Neon"] = 698.45, ["Neon|Ride"] = 518.43, ["Neon|Fly|Ride"] = 523.69, ["Mega|Fly|Ride"] = 1995}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.5, ["Ride"] = 44.63, ["Fly|Ride"] = 140.37, ["Neon"] = 40.38, ["Neon|Ride"] = 82.69, ["Neon|Fly|Ride"] = 838.03, ["Mega"] = 236.25, ["Mega|Ride"] = 474.94, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 10.35, ["Fly"] = 41.53, ["Ride"] = 26.25, ["Fly|Ride"] = 77.52, ["Neon"] = 91.88, ["Neon|Ride"] = 111.44, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 25.26, ["Ride"] = 28.29, ["Fly|Ride"] = 156.19, ["Neon"] = 267.12, ["Neon|Ride"] = 317, ["Mega"] = 918.74, ["Mega|Ride"] = 1161.57, ["Mega|Fly|Ride"] = 1114.31}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 12.86, ["Fly"] = 209.49, ["Ride"] = 35.75, ["Fly|Ride"] = 67.38, ["Neon"] = 91.88, ["Neon|Ride"] = 114.59, ["Neon|Fly|Ride"] = 208.45, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 7297.75, ["Ride"] = 6555.94, ["Fly|Ride"] = 5496.74, ["Neon"] = 34913.48, ["Neon|Ride"] = 24281.25, ["Neon|Fly|Ride"] = 24930.77}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 224.42, ["Fly"] = 271.57, ["Ride"] = 248.26, ["Fly|Ride"] = 283.47, ["Neon|Ride"] = 712.34, ["Neon|Fly|Ride"] = 577.48, ["Mega|Fly|Ride"] = 2098.68}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 39.38, ["Fly"] = 140.58, ["Ride"] = 72.19, ["Fly|Ride"] = 180.22, ["Neon"] = 112.2, ["Neon|Fly"] = 254.08, ["Neon|Ride"] = 163.87, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 450.62, ["Mega|Ride"] = 418.68, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.4, ["Fly"] = 87.83, ["Ride"] = 33.53, ["Fly|Ride"] = 52.5, ["Neon"] = 31.44, ["Neon|Fly"] = 60.77, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 190.66, ["Mega"] = 341.25, ["Mega|Ride"] = 188.99}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 45.94, ["Fly"] = 5342.54, ["Ride"] = 99.32, ["Fly|Ride"] = 221.93, ["Neon"] = 224.21, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 233.87, ["Neon|Fly|Ride"] = 381.22, ["Mega"] = 564.38, ["Mega|Ride"] = 592.65, ["Mega|Fly|Ride"] = 608.4}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 16485, ["Ride"] = 12009.38, ["Fly|Ride"] = 11942.44, ["Neon|Fly|Ride"] = 24150, ["Mega|Fly|Ride"] = 111721.23}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 264.58, ["Ride"] = 249.38, ["Fly|Ride"] = 459.38, ["Neon"] = 1547.54, ["Neon|Ride"] = 1397.4, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 5781.57}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 65.63, ["Fly"] = 91.88, ["Ride"] = 65.39, ["Fly|Ride"] = 119.44, ["Neon"] = 1050, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 415.8, ["Mega|Fly|Ride"] = 3140.06}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 9.18, ["Fly"] = 45.11, ["Ride"] = 28.29, ["Fly|Ride"] = 72.12, ["Neon"] = 70.2, ["Neon|Fly"] = 269.51, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 475.52, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 386.87, ["Fly"] = 837.92, ["Ride"] = 392.43, ["Fly|Ride"] = 489.57, ["Neon"] = 1771.88, ["Neon|Ride"] = 1606.9, ["Neon|Fly|Ride"] = 1747.26, ["Mega|Fly|Ride"] = 4856.25}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.34, ["Fly"] = 103.71, ["Ride"] = 38.07, ["Fly|Ride"] = 111.46, ["Neon"] = 27.2, ["Neon|Ride"] = 127.31, ["Neon|Fly|Ride"] = 167.6, ["Mega"] = 129.94, ["Mega|Fly"] = 278.37, ["Mega|Ride"] = 601.21, ["Mega|Fly|Ride"] = 229.69}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 91.88, ["Fly"] = 215.98, ["Ride"] = 153.24, ["Fly|Ride"] = 219.23, ["Neon"] = 685, ["Neon|Ride"] = 524.9, ["Neon|Fly|Ride"] = 557.82, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 10.4, ["Fly"] = 18.8, ["Ride"] = 17.82, ["Fly|Ride"] = 38.07, ["Neon"] = 167.6, ["Neon|Ride"] = 196.86, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 2513.74, ["Mega|Fly|Ride"] = 949.88}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 8.9}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 49.98, ["Ride"] = 57.75, ["Fly|Ride"] = 140.37, ["Neon"] = 421.32, ["Neon|Fly"] = 417.98, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 419.03, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1816.18}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 15.75, ["Fly"] = 103.71, ["Ride"] = 34.13, ["Fly|Ride"] = 93.19, ["Neon"] = 98.44, ["Neon|Ride"] = 140.38, ["Neon|Fly|Ride"] = 228.55, ["Mega"] = 1046.36, ["Mega|Fly|Ride"] = 837.92}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 24.55}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 42.95, ["Fly"] = 210, ["Ride"] = 88.2, ["Fly|Ride"] = 249.38, ["Neon"] = 294.45, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 522.73, ["Mega"] = 1571.09, ["Mega|Ride"] = 2092.13, ["Mega|Fly|Ride"] = 1583.91}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 4.92, ["Ride"] = 29.23, ["Fly|Ride"] = 136.57, ["Neon"] = 24.94, ["Neon|Ride"] = 103.3, ["Neon|Fly|Ride"] = 279.7, ["Mega"] = 124.69, ["Mega|Ride"] = 213.42}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 10.5, ["Fly"] = 52.5, ["Ride"] = 28.24, ["Fly|Ride"] = 65.63, ["Neon|Ride"] = 155.05, ["Neon|Fly|Ride"] = 209.52, ["Mega|Ride"] = 638.92, ["Mega|Fly|Ride"] = 590.28}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 438.38, ["Ride"] = 490.28, ["Fly|Ride"] = 472.5, ["Neon|Fly|Ride"] = 1942.16, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 32.62, ["Ride"] = 57.56, ["Fly|Ride"] = 309, ["Neon"] = 177.68, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 320.78, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 2730}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 41.67, ["Fly"] = 119.89, ["Ride"] = 65.63, ["Fly|Ride"] = 155.03, ["Neon"] = 279.66, ["Neon|Ride"] = 419.03, ["Neon|Fly|Ride"] = 458.1, ["Mega|Fly|Ride"] = 837.92}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 20.65, ["Fly"] = 86.63, ["Ride"] = 63.02, ["Fly|Ride"] = 128.84, ["Neon"] = 95.05, ["Neon|Ride"] = 138.9, ["Neon|Fly|Ride"] = 325.52, ["Mega"] = 437.07, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 610.32}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11156.25, ["Fly"] = 26250, ["Ride"] = 13607.02, ["Fly|Ride"] = 8398.69, ["Neon|Fly|Ride"] = 16931.25, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1397.82, ["Fly"] = 1487.07, ["Ride"] = 1443.75, ["Fly|Ride"] = 1509.38, ["Neon|Fly|Ride"] = 5499.38, ["Mega|Fly|Ride"] = 14437.5}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 656.25, ["Ride"] = 560.39, ["Fly|Ride"] = 787.5, ["Neon"] = 2542.03, ["Neon|Fly|Ride"] = 2082.05, ["Mega|Fly|Ride"] = 7123.98}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 10.62, ["Fly"] = 18.9, ["Ride"] = 21, ["Fly|Ride"] = 40.6, ["Neon"] = 101.07, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 167.63, ["Mega|Fly|Ride"] = 572.25}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 3.6, ["Fly"] = 78.74, ["Ride"] = 28.29, ["Neon"] = 19.69, ["Neon|Ride"] = 54.85, ["Mega"] = 151.68, ["Mega|Ride"] = 178.58, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 31.4, ["Fly"] = 39.38, ["Ride"] = 54.42, ["Fly|Ride"] = 96.16, ["Neon"] = 534.26, ["Neon|Ride"] = 169.32, ["Neon|Fly|Ride"] = 195.87, ["Mega|Fly|Ride"] = 583.96}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 2.1, ["Fly"] = 22.83, ["Ride"] = 17.38, ["Fly|Ride"] = 33.67, ["Neon"] = 31.48, ["Neon|Fly"] = 76.92, ["Neon|Ride"] = 44.98, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 209.49, ["Mega|Ride"] = 321.57, ["Mega|Fly|Ride"] = 859.69}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 301.76, ["Fly"] = 369.49, ["Ride"] = 324.19, ["Fly|Ride"] = 405.57, ["Neon"] = 1481.02, ["Neon|Fly|Ride"] = 1661.44, ["Mega|Fly|Ride"] = 3654}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 20.33, ["Fly"] = 56.57, ["Ride"] = 30.94, ["Fly|Ride"] = 87.92, ["Neon"] = 208.94, ["Neon|Fly"] = 140.38, ["Neon|Ride"] = 155.05, ["Neon|Fly|Ride"] = 237.8, ["Mega|Ride"] = 787.4, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 10.66, ["Fly"] = 21, ["Ride"] = 17.64, ["Fly|Ride"] = 42.74, ["Neon"] = 83.83, ["Neon|Fly"] = 135.36, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 577.86, ["Fly"] = 1048.69, ["Ride"] = 522.66, ["Fly|Ride"] = 537.71, ["Neon|Fly|Ride"] = 2095.04, ["Mega|Fly|Ride"] = 9971.07}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1275.83, ["Ride"] = 1260, ["Fly|Ride"] = 1345.32, ["Neon"] = 4888.15, ["Neon|Ride"] = 4190.06, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13782.3}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 103.61, ["Fly"] = 136.18, ["Ride"] = 103.69, ["Fly|Ride"] = 122.15, ["Neon"] = 971.25, ["Neon|Ride"] = 585.46, ["Neon|Fly|Ride"] = 590.63, ["Mega|Fly|Ride"] = 2374.43}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 144.38, ["Fly"] = 157.49, ["Ride"] = 144.38, ["Fly|Ride"] = 229.39, ["Neon"] = 849.43, ["Neon|Fly"] = 698.71, ["Neon|Ride"] = 522.38, ["Neon|Fly|Ride"] = 583.43, ["Mega|Ride"] = 8603.44, ["Mega|Fly|Ride"] = 2792.56}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 25.91, ["Fly"] = 120.47, ["Ride"] = 53.7, ["Fly|Ride"] = 121.06, ["Neon"] = 391.78, ["Neon|Ride"] = 272.98, ["Mega|Ride"] = 2094.78, ["Mega|Fly|Ride"] = 1045.31}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 183.75, ["Ride"] = 315, ["Fly|Ride"] = 559.32, ["Neon|Fly|Ride"] = 1329.68, ["Mega|Fly|Ride"] = 4002.06}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2277.02, ["Fly"] = 2254.6, ["Ride"] = 2483.25, ["Fly|Ride"] = 2371.28, ["Neon|Fly|Ride"] = 10475.12, ["Mega|Fly|Ride"] = 28495.87}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 57.63, ["Fly"] = 209.49, ["Ride"] = 82.76, ["Fly|Ride"] = 196.88, ["Neon"] = 511.88, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 343.87, ["Mega|Ride"] = 1117.57, ["Mega|Fly|Ride"] = 2513.74}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 577.48, ["Ride"] = 577.5, ["Fly|Ride"] = 715.32, ["Neon|Fly|Ride"] = 1199.62, ["Mega|Fly|Ride"] = 3359.54}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 45.05, ["Fly"] = 55.78, ["Ride"] = 45.92, ["Fly|Ride"] = 91.88, ["Neon|Ride"] = 317, ["Neon|Fly|Ride"] = 269.07, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 2.63, ["Fly"] = 39.38, ["Ride"] = 17.06, ["Fly|Ride"] = 51.35, ["Neon"] = 25.05, ["Neon|Fly"] = 110.94, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 151.05, ["Mega|Fly"] = 249.38, ["Mega|Ride"] = 182.11, ["Mega|Fly|Ride"] = 299.25}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 53.01, ["Ride"] = 91.88, ["Fly|Ride"] = 253.32, ["Neon"] = 343.11, ["Neon|Ride"] = 325.5, ["Neon|Fly|Ride"] = 698.71, ["Mega"] = 1531.29, ["Mega|Fly|Ride"] = 1429.16}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 826.87, ["Fly"] = 856.99, ["Ride"] = 833.43, ["Fly|Ride"] = 908.93, ["Neon|Ride"] = 2598.75, ["Neon|Fly|Ride"] = 2651.24, ["Mega|Fly|Ride"] = 8531.25}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 714.65, ["Ride"] = 704.82, ["Fly|Ride"] = 971.99, ["Neon|Fly|Ride"] = 4189.01, ["Mega|Fly|Ride"] = 15220.58}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 12.45, ["Fly"] = 26.25, ["Ride"] = 20.74, ["Fly|Ride"] = 38, ["Neon"] = 78.75, ["Neon|Ride"] = 125.72, ["Neon|Fly|Ride"] = 206.59, ["Mega|Fly|Ride"] = 700.95}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 8.44, ["Ride"] = 19.26, ["Fly|Ride"] = 70.19, ["Neon"] = 139.54, ["Neon|Ride"] = 102.92, ["Neon|Fly|Ride"] = 250.04, ["Mega"] = 570.94, ["Mega|Ride"] = 418.97, ["Mega|Fly|Ride"] = 556.17}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 2.63, ["Ride"] = 23.15, ["Fly|Ride"] = 102.38, ["Neon"] = 21.59, ["Neon|Fly"] = 315.21, ["Neon|Ride"] = 54.47, ["Neon|Fly|Ride"] = 170.57, ["Mega"] = 155.74, ["Mega|Fly"] = 157.5, ["Mega|Ride"] = 131.15, ["Mega|Fly|Ride"] = 339.94}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 26.57, ["Fly"] = 66.94, ["Ride"] = 49.88, ["Fly|Ride"] = 78.71, ["Neon"] = 249.38, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 231, ["Mega|Fly|Ride"] = 1009.21}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 52.4, ["Ride"] = 133.84, ["Fly|Ride"] = 633.74, ["Neon"] = 424.07, ["Neon|Ride"] = 460.16, ["Neon|Fly|Ride"] = 695.63, ["Mega|Ride"] = 1571.09, ["Mega|Fly|Ride"] = 1536.53}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 15.54, ["Fly"] = 43.3, ["Ride"] = 34, ["Fly|Ride"] = 68.24, ["Neon"] = 107.63, ["Neon|Ride"] = 118.12, ["Neon|Fly|Ride"] = 192.76, ["Mega"] = 617.43, ["Mega|Ride"] = 344.9, ["Mega|Fly|Ride"] = 393.74}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 36.65, ["Fly"] = 112.09, ["Ride"] = 44.24, ["Fly|Ride"] = 79.52, ["Neon"] = 328.9, ["Neon|Fly"] = 1397.4, ["Neon|Ride"] = 190.21, ["Neon|Fly|Ride"] = 255.94, ["Mega"] = 2100, ["Mega|Ride"] = 1044.25, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 2.13, ["Fly"] = 20.88, ["Ride"] = 15.31, ["Fly|Ride"] = 42, ["Neon"] = 29.3, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 91.73, ["Mega"] = 732.38, ["Mega|Ride"] = 368.69, ["Mega|Fly|Ride"] = 698.62}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 3.72, ["Fly"] = 46.41, ["Ride"] = 32.48, ["Fly|Ride"] = 91.14, ["Neon"] = 33.41, ["Neon|Fly"] = 115.54, ["Neon|Ride"] = 79.56, ["Neon|Fly|Ride"] = 206.59, ["Mega"] = 293.29, ["Mega|Ride"] = 311.85, ["Mega|Fly|Ride"] = 489.15}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 41.04, ["Fly"] = 65.62, ["Ride"] = 52.41, ["Fly|Ride"] = 94.5, ["Neon"] = 411.97, ["Neon|Ride"] = 289, ["Neon|Fly|Ride"] = 259.88, ["Mega|Fly|Ride"] = 1074.82}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1575, ["Fly"] = 1574.99, ["Ride"] = 1417.29, ["Fly|Ride"] = 1508.07, ["Neon|Fly|Ride"] = 3858.75, ["Mega|Fly|Ride"] = 13482.26}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 446.25, ["Fly"] = 479.81, ["Ride"] = 459.38, ["Fly|Ride"] = 473.82, ["Mega|Fly|Ride"] = 10473.84}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 282.19, ["Ride"] = 313.69, ["Fly|Ride"] = 559.32, ["Neon"] = 1273.13, ["Neon|Ride"] = 1583.74, ["Neon|Fly|Ride"] = 1676.04, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 43.32}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 27.09, ["Ride"] = 44.01, ["Fly|Ride"] = 98.43, ["Neon|Ride"] = 356.04, ["Neon|Fly|Ride"] = 419.03, ["Mega|Ride"] = 1522.9, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 71222.07, ["Fly"] = 65625, ["Ride"] = 35437.5, ["Fly|Ride"] = 16931.25, ["Neon|Fly|Ride"] = 35437.49, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 299.44, ["Fly"] = 611.63, ["Ride"] = 262.5, ["Fly|Ride"] = 366.81, ["Neon"] = 1361.78, ["Neon|Fly"] = 1424.66, ["Neon|Ride"] = 1147.13, ["Neon|Fly|Ride"] = 1036.88, ["Mega"] = 3980.07, ["Mega|Ride"] = 4188.5, ["Mega|Fly|Ride"] = 3871.88}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 210.69, ["Fly"] = 525, ["Ride"] = 209.49, ["Fly|Ride"] = 196.88, ["Neon|Fly|Ride"] = 1741.64}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 123.19, ["Fly"] = 279.66, ["Ride"] = 177.19, ["Fly|Ride"] = 226.7, ["Neon|Ride"] = 768.89, ["Neon|Fly|Ride"] = 712.34, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 11.46, ["Fly"] = 94.5, ["Ride"] = 30.18, ["Fly|Ride"] = 125.7, ["Neon|Ride"] = 155.05, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 710.04, ["Mega|Ride"] = 698.62, ["Mega|Fly|Ride"] = 733.18}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3921.75, ["Ride"] = 3937.5, ["Fly|Ride"] = 4748.87, ["Neon"] = 27231.98, ["Neon|Fly|Ride"] = 27654.31}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 27.25, ["Fly"] = 62.55, ["Ride"] = 29, ["Fly|Ride"] = 59.06, ["Neon|Ride"] = 343.88, ["Neon|Fly|Ride"] = 211.97, ["Mega|Fly|Ride"] = 802.31}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 37.8, ["Fly"] = 106.51, ["Ride"] = 55.43, ["Fly|Ride"] = 95.82, ["Neon"] = 406.41, ["Neon|Fly"] = 1397.4, ["Neon|Ride"] = 204.75, ["Neon|Fly|Ride"] = 279.7, ["Mega|Fly|Ride"] = 1372.88}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 687.75, ["Ride"] = 630, ["Fly|Ride"] = 741.12, ["Neon"] = 3957.83, ["Neon|Ride"] = 1968.75, ["Neon|Fly|Ride"] = 1942.5, ["Mega"] = 8169.6, ["Mega|Fly"] = 8169.6, ["Mega|Fly|Ride"] = 6811.88}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 19.58, ["Fly"] = 26.16, ["Ride"] = 24.66, ["Fly|Ride"] = 39.26, ["Neon"] = 118.12, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 144.38, ["Mega|Fly|Ride"] = 640.5}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 13.07, ["Ride"] = 27.56, ["Fly|Ride"] = 79.52, ["Neon"] = 91.88, ["Neon|Ride"] = 118.73, ["Neon|Fly|Ride"] = 105}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 96.8, ["Ride"] = 128.63, ["Fly|Ride"] = 137.22, ["Neon"] = 614.83, ["Neon|Ride"] = 530.25, ["Neon|Fly|Ride"] = 559.32, ["Mega|Fly|Ride"] = 2754.62}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 16.77, ["Fly"] = 140.37, ["Ride"] = 31.5, ["Fly|Ride"] = 131.25, ["Neon"] = 94.49, ["Neon|Ride"] = 125.72, ["Neon|Fly|Ride"] = 250.9, ["Mega"] = 393.75, ["Mega|Fly"] = 723.52, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 413.27}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3930.83, ["Ride"] = 3883.64, ["Fly|Ride"] = 4232.82, ["Neon"] = 13965.82, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 9841.13, ["Mega"] = 36658.41, ["Mega|Fly|Ride"] = 36094.77}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 36.75, ["Fly"] = 104.75, ["Ride"] = 65.34, ["Fly|Ride"] = 112.09, ["Neon"] = 888.57, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 574.23, ["Mega"] = 837.92, ["Mega|Ride"] = 1039.01, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 5775, ["Fly"] = 7681.52, ["Ride"] = 6857.82, ["Fly|Ride"] = 7168.87, ["Neon|Ride"] = 19553.9, ["Neon|Fly|Ride"] = 16966.69, ["Mega|Fly|Ride"] = 82145.22}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.1, ["Fly"] = 21.95, ["Ride"] = 18.78, ["Fly|Ride"] = 32.24, ["Neon"] = 24.94, ["Neon|Fly"] = 62.61, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 459.52, ["Mega|Fly|Ride"] = 346.69}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 14.27, ["Fly"] = 28.82, ["Ride"] = 26.38, ["Fly|Ride"] = 41.91, ["Neon"] = 195.88, ["Neon|Fly"] = 231.51, ["Neon|Ride"] = 559.38, ["Neon|Fly|Ride"] = 154.95, ["Mega|Fly|Ride"] = 935.82}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.49}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 11.82, ["Ride"] = 32.71, ["Fly|Ride"] = 116.02, ["Neon"] = 275.55, ["Neon|Ride"] = 157.68, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 1049.9, ["Mega|Ride"] = 878.77, ["Mega|Fly|Ride"] = 671.13}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 28.86, ["Fly"] = 190.37, ["Ride"] = 36.75, ["Fly|Ride"] = 99.75, ["Neon"] = 210, ["Neon|Ride"] = 236.25, ["Mega"] = 945, ["Mega|Ride"] = 949.88, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 11.8, ["Fly"] = 19.35, ["Ride"] = 25.15, ["Fly|Ride"] = 35.07, ["Neon|Fly"] = 112.1, ["Neon|Ride"] = 140.38, ["Neon|Fly|Ride"] = 179.55, ["Mega"] = 2513.74, ["Mega|Ride"] = 592.5, ["Mega|Fly|Ride"] = 531.04}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8483.82}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.99}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 20.96}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 214.77, ["Ride"] = 251.39, ["Fly|Ride"] = 223.12, ["Mega|Fly|Ride"] = 5668.45}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 12.74, ["Fly"] = 131.99, ["Ride"] = 39.38, ["Fly|Ride"] = 128.19, ["Neon"] = 155.03, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 265.13, ["Mega|Ride"] = 523.63, ["Mega|Fly|Ride"] = 1470}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 12.58}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.24, ["Ride"] = 31.44, ["Fly|Ride"] = 83.81, ["Neon|Ride"] = 182.28, ["Mega|Fly|Ride"] = 837.92}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 3051.63}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 163.34, ["Fly"] = 418.97, ["Ride"] = 279.66, ["Fly|Ride"] = 328.13, ["Neon"] = 1108.45, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 838.03, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 83.81, ["Ride"] = 125.7, ["Fly|Ride"] = 203.21, ["Neon"] = 559.32, ["Neon|Ride"] = 502.51, ["Neon|Fly|Ride"] = 1435.35, ["Mega|Ride"] = 2094.78, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 171.29, ["Fly"] = 349.84, ["Ride"] = 157.5, ["Fly|Ride"] = 262.5, ["Neon"] = 897.75, ["Neon|Ride"] = 787.4, ["Neon|Fly|Ride"] = 838.03, ["Mega|Fly|Ride"] = 4777.5}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1967.44, ["Fly"] = 1968.75, ["Ride"] = 2218.93, ["Fly|Ride"] = 1929.57, ["Neon|Fly|Ride"] = 6561.19, ["Mega|Fly|Ride"] = 18376.32}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 17.07, ["Fly"] = 98.47, ["Ride"] = 56.8, ["Fly|Ride"] = 99.74, ["Neon"] = 127.32, ["Neon|Ride"] = 154.62, ["Neon|Fly|Ride"] = 322.88, ["Mega"] = 941.61, ["Mega|Ride"] = 1029.42, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 879.82, ["Fly"] = 2100, ["Ride"] = 735, ["Fly|Ride"] = 918.75, ["Neon|Fly|Ride"] = 4116.49, ["Mega|Fly|Ride"] = 16622.6}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 43.32}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 17.07, ["Ride"] = 45.94, ["Fly|Ride"] = 647.98, ["Neon"] = 87.87, ["Neon|Ride"] = 140.38, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 407.27, ["Mega|Ride"] = 514.56, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 6.59, ["Fly"] = 262.5, ["Ride"] = 27.57, ["Fly|Ride"] = 96.79, ["Neon"] = 53.13, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 488.1, ["Mega|Fly|Ride"] = 484.3}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 83.81}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 18.79, ["Fly"] = 108.92, ["Ride"] = 23.7, ["Fly|Ride"] = 81.24, ["Neon"] = 94.96, ["Neon|Ride"] = 251.43, ["Neon|Fly|Ride"] = 488.18, ["Mega|Fly|Ride"] = 1956.52}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 21.62, ["Fly"] = 56.57, ["Ride"] = 45.94, ["Fly|Ride"] = 52.41, ["Neon"] = 288.75, ["Neon|Ride"] = 419.03, ["Neon|Fly|Ride"] = 310.08, ["Mega|Ride"] = 1781.01, ["Mega|Fly|Ride"] = 908.1}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6300, ["Fly"] = 11172.46, ["Ride"] = 7875, ["Fly|Ride"] = 4987.5, ["Neon|Fly|Ride"] = 11812.5, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 8.02, ["Fly"] = 65.63, ["Ride"] = 32.71, ["Fly|Ride"] = 75.45, ["Neon"] = 56.44, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 531.93, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 695.37}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 21}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 90.86, ["Fly"] = 370.78, ["Ride"] = 132.6, ["Fly|Ride"] = 211.59, ["Neon"] = 525, ["Neon|Ride"] = 378, ["Neon|Fly|Ride"] = 736.41, ["Mega"] = 2879.59, ["Mega|Fly|Ride"] = 1960.45}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 43.21, ["Fly"] = 140.91, ["Ride"] = 67.51, ["Fly|Ride"] = 155.93, ["Neon"] = 349.84, ["Neon|Ride"] = 265.13, ["Neon|Fly|Ride"] = 320.74, ["Mega"] = 2374.66, ["Mega|Ride"] = 2827.95, ["Mega|Fly|Ride"] = 2094.78}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 23.73, ["Fly"] = 70.47, ["Ride"] = 27.46, ["Fly|Ride"] = 66.05, ["Neon|Fly"] = 237.8, ["Neon|Ride"] = 142.87, ["Neon|Fly|Ride"] = 190.3, ["Mega"] = 1016.21, ["Mega|Ride"] = 871.52, ["Mega|Fly|Ride"] = 780.93}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 3.94, ["Fly"] = 65.43, ["Ride"] = 21.06, ["Fly|Ride"] = 98.44, ["Neon"] = 32.45, ["Neon|Ride"] = 48.85, ["Neon|Fly|Ride"] = 128.5, ["Mega"] = 216.57, ["Mega|Fly"] = 254.63, ["Mega|Ride"] = 159.12, ["Mega|Fly|Ride"] = 307.51}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 11.71, ["Fly"] = 32.82, ["Ride"] = 25.2, ["Fly|Ride"] = 78.75, ["Neon"] = 86.43, ["Neon|Ride"] = 125.72, ["Neon|Fly|Ride"] = 189, ["Mega"] = 722.71, ["Mega|Ride"] = 426.57, ["Mega|Fly|Ride"] = 584.07}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 18.04, ["Fly"] = 24.82, ["Ride"] = 22.67, ["Fly|Ride"] = 41.9, ["Neon"] = 363.5, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 161.44}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 187.69}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 27.57, ["Ride"] = 98.44, ["Fly|Ride"] = 279.66, ["Neon"] = 196.88, ["Neon|Ride"] = 279.7, ["Neon|Fly|Ride"] = 574.05, ["Mega"] = 1117.57, ["Mega|Fly|Ride"] = 1675.83}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 208.69, ["Ride"] = 443.63, ["Fly|Ride"] = 1583.14}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 36.54, ["Fly"] = 212.3, ["Ride"] = 90.57, ["Fly|Ride"] = 210.99, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 423.62, ["Mega"] = 908.25, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1286.2}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 918.73, ["Fly"] = 1355.33, ["Ride"] = 945, ["Fly|Ride"] = 1004.07, ["Neon|Fly"] = 4107.73, ["Neon|Ride"] = 3281.25, ["Neon|Fly|Ride"] = 3355.94, ["Mega|Fly|Ride"] = 13113.26}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 489.15, ["Fly"] = 698.62, ["Ride"] = 413.44, ["Fly|Ride"] = 570.94, ["Neon"] = 2932.69, ["Neon|Ride"] = 2085.05, ["Neon|Fly|Ride"] = 2514.04, ["Mega|Fly|Ride"] = 7940.63}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 66.22}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 3.94}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 9.87, ["Fly"] = 23, ["Ride"] = 21, ["Fly|Ride"] = 43.32, ["Neon"] = 78.74, ["Neon|Fly"] = 167.63, ["Neon|Ride"] = 83.42, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 437.26, ["Mega|Ride"] = 698.62, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 236.25, ["Fly"] = 525, ["Ride"] = 297.13, ["Fly|Ride"] = 350.44, ["Neon"] = 1099.76, ["Neon|Ride"] = 931.88, ["Neon|Fly|Ride"] = 1006.45, ["Mega|Fly|Ride"] = 3220.88}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 17.07}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 137.82, ["Ride"] = 183.23, ["Fly|Ride"] = 269.07, ["Neon"] = 585.37, ["Neon|Fly"] = 630, ["Neon|Ride"] = 510.57, ["Neon|Fly|Ride"] = 630, ["Mega"] = 10054.9, ["Mega|Ride"] = 11915.04, ["Mega|Fly|Ride"] = 3135.87}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 127.32, ["Fly"] = 105, ["Ride"] = 104.14, ["Fly|Ride"] = 209.49, ["Neon"] = 698.62, ["Neon|Fly"] = 525, ["Neon|Ride"] = 1005.38, ["Neon|Fly|Ride"] = 913.5, ["Mega|Ride"] = 3493.04, ["Mega|Fly|Ride"] = 2513.74}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 3.84, ["Ride"] = 31.44, ["Fly|Ride"] = 170.73, ["Neon"] = 22.32, ["Neon|Ride"] = 86.56, ["Neon|Fly|Ride"] = 167.51, ["Mega"] = 321.57, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 836.88}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 12.09, ["Fly"] = 63.03, ["Ride"] = 27.13, ["Fly|Ride"] = 76.28, ["Neon"] = 177.19, ["Neon|Ride"] = 176, ["Neon|Fly|Ride"] = 317.03, ["Mega|Ride"] = 815.93, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 11.34, ["Fly"] = 102.34, ["Ride"] = 47.76, ["Fly|Ride"] = 104.6, ["Neon"] = 65.63, ["Neon|Ride"] = 91.16, ["Neon|Fly|Ride"] = 256.57, ["Mega"] = 498.75, ["Mega|Ride"] = 504, ["Mega|Fly|Ride"] = 837.92}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 4.2, ["Fly"] = 131.23, ["Ride"] = 54.42, ["Fly|Ride"] = 140.37, ["Neon"] = 20.24, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 172.49, ["Mega"] = 139.02, ["Mega|Fly"] = 370.78, ["Mega|Ride"] = 176.69, ["Mega|Fly|Ride"] = 278.25}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 255.94, ["Ride"] = 275.63, ["Fly|Ride"] = 354.38, ["Neon"] = 1648.6, ["Neon|Ride"] = 1346.3, ["Neon|Fly|Ride"] = 1299.38, ["Mega|Fly|Ride"] = 5530.21}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 166.55, ["Fly"] = 322.77, ["Ride"] = 200.12, ["Fly|Ride"] = 241.48, ["Neon"] = 768.89, ["Neon|Ride"] = 719.78, ["Neon|Fly|Ride"] = 768.89, ["Mega"] = 2094.78, ["Mega|Fly|Ride"] = 2612.19}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 74.82, ["Fly"] = 167.45, ["Ride"] = 69.34, ["Fly|Ride"] = 125.7, ["Neon"] = 393.75, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 416.07, ["Mega|Fly|Ride"] = 1801.12}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 11.97, ["Ride"] = 33.53, ["Fly|Ride"] = 279.66, ["Neon"] = 56.58, ["Neon|Ride"] = 603.12, ["Neon|Fly|Ride"] = 489.2, ["Mega|Fly|Ride"] = 1956.52}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 14.44, ["Fly"] = 75.63, ["Ride"] = 33.56, ["Fly|Ride"] = 75.97, ["Neon"] = 77.42, ["Neon|Fly"] = 279.7, ["Neon|Ride"] = 119.73, ["Neon|Fly|Ride"] = 200.09, ["Mega"] = 371.44, ["Mega|Fly"] = 525, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 548.03}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 2.63, ["Fly"] = 52.46, ["Ride"] = 18.38, ["Fly|Ride"] = 44.05, ["Neon"] = 19.02, ["Neon|Fly"] = 66.25, ["Neon|Ride"] = 35.25, ["Neon|Fly|Ride"] = 118.1, ["Mega"] = 137.82, ["Mega|Ride"] = 141.91, ["Mega|Fly|Ride"] = 253.62}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 963.23, ["Fly"] = 1082.72, ["Ride"] = 912.19, ["Fly|Ride"] = 918.75, ["Neon|Fly"] = 3428.65, ["Neon|Ride"] = 3194.92, ["Neon|Fly|Ride"] = 2622.38, ["Mega|Fly|Ride"] = 10279.03}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 426.01, ["Ride"] = 393.75, ["Fly|Ride"] = 472.02, ["Neon"] = 1277.38, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1646.7, ["Mega"] = 10473.84, ["Mega|Fly|Ride"] = 6276.23}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 93.38, ["Fly"] = 140.37, ["Ride"] = 103.64, ["Fly|Ride"] = 190.32, ["Neon"] = 283.08, ["Neon|Ride"] = 313.2, ["Neon|Fly|Ride"] = 588.72, ["Mega"] = 1312.5, ["Mega|Ride"] = 1675.83, ["Mega|Fly|Ride"] = 2533.77}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 213.61, ["Fly"] = 283.5, ["Ride"] = 223.13, ["Fly|Ride"] = 279.66, ["Neon|Fly|Ride"] = 1251.03, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 17.07, ["Fly"] = 52.5, ["Ride"] = 26.24, ["Fly|Ride"] = 50.4, ["Neon"] = 169.32, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 236.25, ["Mega|Fly|Ride"] = 791.96}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 223.02, ["Ride"] = 249.38, ["Fly|Ride"] = 472.4, ["Neon"] = 837.92, ["Neon|Ride"] = 922.88, ["Neon|Fly|Ride"] = 708.75, ["Mega"] = 4134.27, ["Mega|Ride"] = 4608.51, ["Mega|Fly|Ride"] = 3818.31}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 56.44, ["Fly"] = 125.98, ["Ride"] = 75.45, ["Fly|Ride"] = 98.44, ["Neon|Ride"] = 540.2, ["Neon|Fly|Ride"] = 559.38, ["Mega|Fly|Ride"] = 1732.5}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1870.32, ["Ride"] = 1837.5, ["Fly|Ride"] = 1785, ["Neon|Ride"] = 11081.36, ["Neon|Fly|Ride"] = 7263.46, ["Mega"] = 50274.4, ["Mega|Fly|Ride"] = 22593.12}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 11.71, ["Fly"] = 117, ["Ride"] = 46.92, ["Fly|Ride"] = 96.37, ["Neon"] = 50.3, ["Neon|Fly"] = 237.57, ["Neon|Ride"] = 96.37, ["Neon|Fly|Ride"] = 225.09, ["Mega"] = 434.68, ["Mega|Ride"] = 349.79, ["Mega|Fly|Ride"] = 446.24}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 52.49, ["Ride"] = 91.14, ["Fly|Ride"] = 137, ["Neon"] = 315, ["Neon|Ride"] = 157.5, ["Mega"] = 1662.28, ["Mega|Ride"] = 2092.7, ["Mega|Fly|Ride"] = 1458.19}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 90.55, ["Fly"] = 78.7, ["Ride"] = 77.3, ["Fly|Ride"] = 97.13, ["Neon"] = 525, ["Neon|Fly|Ride"] = 380.63, ["Mega|Fly|Ride"] = 1842.38}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3018.75, ["Fly"] = 1582.97, ["Ride"] = 1073.63, ["Fly|Ride"] = 1133.15, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 459.38, ["Fly"] = 580.27, ["Ride"] = 589.7, ["Fly|Ride"] = 656.25, ["Neon|Fly|Ride"] = 4188.5}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 88.1, ["Fly"] = 221.91, ["Ride"] = 110.62, ["Fly|Ride"] = 159.04, ["Neon"] = 408.19, ["Neon|Ride"] = 418.69, ["Neon|Fly|Ride"] = 538.13, ["Mega|Ride"] = 2654.08, ["Mega|Fly|Ride"] = 2709.59}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.51, ["Ride"] = 22.32, ["Fly|Ride"] = 104.75, ["Neon"] = 69.14, ["Neon|Fly"] = 140.38, ["Neon|Ride"] = 64.31, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 656.25, ["Mega|Ride"] = 762.72}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 32.06, ["Ride"] = 49.68, ["Fly|Ride"] = 121.51, ["Neon"] = 262.5, ["Neon|Fly"] = 328.93, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 236.24, ["Mega"] = 1181.25, ["Mega|Fly|Ride"] = 1036.88}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 760.9, ["Ride"] = 840, ["Fly|Ride"] = 813.75, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2139.38, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 739.82}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4921.88, ["Ride"] = 6283.27, ["Fly|Ride"] = 5643.75, ["Neon"] = 42000, ["Neon|Ride"] = 30022.74, ["Neon|Fly|Ride"] = 23296.88, ["Mega|Fly|Ride"] = 89377.41}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 349.44, ["Fly"] = 418.97, ["Ride"] = 393.75, ["Fly|Ride"] = 413.74, ["Neon"] = 1675.83, ["Neon|Ride"] = 2095.04, ["Neon|Fly|Ride"] = 2199.79, ["Mega"] = 6283.27, ["Mega|Fly|Ride"] = 6649.05}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 91.82, ["Fly"] = 279.66, ["Ride"] = 122.06, ["Fly|Ride"] = 336, ["Neon"] = 426.46, ["Neon|Ride"] = 698.71, ["Neon|Fly|Ride"] = 624.33, ["Mega|Fly|Ride"] = 2139.76}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 11.42, ["Fly"] = 98.47, ["Ride"] = 37.98, ["Fly|Ride"] = 85.32, ["Neon"] = 111.57, ["Neon|Fly"] = 1266.77, ["Neon|Ride"] = 124.26, ["Neon|Fly|Ride"] = 262.95, ["Mega|Ride"] = 837.92, ["Mega|Fly|Ride"] = 810.69}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 7.77, ["Fly"] = 26.24, ["Ride"] = 17.82, ["Fly|Ride"] = 42.57, ["Neon"] = 209.49, ["Neon|Ride"] = 317, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2220.47}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 16.49, ["Ride"] = 28.88, ["Fly|Ride"] = 140.44, ["Neon"] = 154.88, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 230.31, ["Mega"] = 670.69, ["Mega|Ride"] = 658.88, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 4.2, ["Fly"] = 77.52, ["Ride"] = 22.32, ["Fly|Ride"] = 48.57, ["Neon"] = 35.33, ["Neon|Ride"] = 55.81, ["Neon|Fly|Ride"] = 132, ["Mega"] = 279.66, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 279.66}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 22.31, ["Fly"] = 90.57, ["Ride"] = 39.38, ["Fly|Ride"] = 139.13, ["Neon"] = 223.13, ["Neon|Fly"] = 838.03, ["Neon|Ride"] = 249.37, ["Neon|Fly|Ride"] = 408.19, ["Mega"] = 630, ["Mega|Ride"] = 1239, ["Mega|Fly|Ride"] = 672}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 400.77, ["Fly"] = 538.13, ["Ride"] = 437.06, ["Fly|Ride"] = 437.66, ["Neon"] = 1571.09, ["Neon|Ride"] = 1536.71, ["Neon|Fly|Ride"] = 1315.69, ["Mega"] = 7875, ["Mega|Fly|Ride"] = 5444.32}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.1, ["Fly"] = 19.03, ["Ride"] = 14.44, ["Fly|Ride"] = 31.42, ["Neon"] = 18.27, ["Neon|Ride"] = 23.27, ["Neon|Fly|Ride"] = 51.98, ["Mega"] = 167.6, ["Mega|Ride"] = 317.03, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 36.27, ["Fly"] = 99.19, ["Ride"] = 69.21, ["Fly|Ride"] = 140.37, ["Neon"] = 220.49, ["Neon|Fly"] = 428.45, ["Neon|Ride"] = 201.66, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 575.05, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 610.3}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 771.74, ["Ride"] = 800.41, ["Fly|Ride"] = 793.86, ["Neon|Ride"] = 1988.23, ["Neon|Fly|Ride"] = 1666.88, ["Mega|Fly|Ride"] = 3934.86}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 32.82, ["Fly"] = 70.19, ["Ride"] = 39.5, ["Fly|Ride"] = 97.57, ["Neon|Ride"] = 235.28, ["Neon|Fly|Ride"] = 210.06, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 385.43, ["Fly"] = 380.7, ["Ride"] = 290.76, ["Fly|Ride"] = 360.94, ["Neon|Ride"] = 1583.74, ["Neon|Fly|Ride"] = 1397.4}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 177.17, ["Fly"] = 407.03, ["Ride"] = 192.9, ["Fly|Ride"] = 223.13, ["Neon"] = 633.63, ["Neon|Ride"] = 708.75, ["Neon|Fly|Ride"] = 838.03, ["Mega|Fly|Ride"] = 3473.01}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 824.31, ["Ride"] = 754.68, ["Fly|Ride"] = 928.7, ["Neon|Ride"] = 4190.06, ["Neon|Fly|Ride"] = 5307.75, ["Mega|Fly|Ride"] = 7611.19}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 16.01, ["Fly"] = 83.81, ["Ride"] = 39.38, ["Fly|Ride"] = 111.56, ["Neon"] = 70.19, ["Neon|Fly"] = 284.94, ["Neon|Ride"] = 78.73, ["Neon|Fly|Ride"] = 275.45, ["Mega"] = 354.38, ["Mega|Ride"] = 302.9, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4084.48, ["Ride"] = 3936.19, ["Fly|Ride"] = 3149.9, ["Neon"] = 13965.82, ["Neon|Fly|Ride"] = 7021.88, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 129.83, ["Fly"] = 169.68, ["Ride"] = 139.13, ["Fly|Ride"] = 205.46, ["Neon"] = 550.97, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 593.25, ["Mega|Fly|Ride"] = 2387.44}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.52, ["Fly"] = 26.21, ["Ride"] = 15.61, ["Fly|Ride"] = 38.07, ["Neon"] = 19.92, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 249.3, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 357.66, ["Mega|Fly|Ride"] = 244.13}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 2.31, ["Ride"] = 24.55, ["Fly|Ride"] = 57.7, ["Neon"] = 20.47, ["Neon|Fly"] = 116.37, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 146.06, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 343.67}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 34.38, ["Ride"] = 39.26, ["Fly|Ride"] = 71.22, ["Neon|Fly|Ride"] = 301.88, ["Mega|Fly|Ride"] = 1116.1}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 1034.25, ["Ride"] = 1397.22, ["Fly|Ride"] = 1298.07}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6693.75, ["Ride"] = 7118.03, ["Fly|Ride"] = 6431.25}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 20.45, ["Fly"] = 36, ["Ride"] = 21.67, ["Fly|Ride"] = 42.89, ["Neon"] = 452.12, ["Neon|Ride"] = 142.48, ["Neon|Fly|Ride"] = 168.48, ["Mega"] = 2513.74, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 11.08, ["Ride"] = 24.95, ["Fly|Ride"] = 74.43, ["Neon"] = 89.25, ["Neon|Ride"] = 107.63, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 655.54, ["Mega|Ride"] = 791.96, ["Mega|Fly|Ride"] = 524.16}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 59.06, ["Ride"] = 85.31, ["Fly|Ride"] = 113.4, ["Neon|Ride"] = 512.89, ["Neon|Fly|Ride"] = 441.79, ["Mega|Fly|Ride"] = 1638.87}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 258.57, ["Ride"] = 256.11, ["Fly|Ride"] = 355.69, ["Neon|Ride"] = 977.79, ["Neon|Fly|Ride"] = 984.38, ["Mega|Fly|Ride"] = 4591.4}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.62, ["Ride"] = 32.78, ["Fly|Ride"] = 77.52, ["Neon"] = 21, ["Neon|Fly"] = 70.2, ["Neon|Ride"] = 93.83, ["Mega"] = 144.26, ["Mega|Ride"] = 191.02, ["Mega|Fly|Ride"] = 284.91}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 213.08, ["Ride"] = 195.57, ["Fly|Ride"] = 262.5, ["Neon"] = 768.8, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 939.92, ["Mega|Fly|Ride"] = 3680.74}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.59, ["Fly"] = 41.67, ["Ride"] = 14.42, ["Fly|Ride"] = 64.95, ["Neon"] = 19.69, ["Neon|Fly"] = 125.72, ["Neon|Ride"] = 31.92, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 223.13, ["Mega|Ride"] = 223.12, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 220.89, ["Fly"] = 279.66, ["Ride"] = 223.13, ["Fly|Ride"] = 231.55, ["Neon|Fly|Ride"] = 749.06, ["Mega"] = 10473.84, ["Mega|Ride"] = 4888.15, ["Mega|Fly|Ride"] = 4885.01}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 9.37, ["Fly"] = 85.32, ["Ride"] = 27.09, ["Fly|Ride"] = 68.25, ["Neon"] = 123.84, ["Neon|Fly"] = 301.58, ["Neon|Ride"] = 155.05, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 488.1, ["Mega|Ride"] = 628.44, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 3.74, ["Ride"] = 23.47, ["Neon"] = 10.49, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 38.06, ["Neon|Fly|Ride"] = 177.09, ["Mega"] = 64.32, ["Mega|Ride"] = 115, ["Mega|Fly|Ride"] = 254.21}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.63, ["Neon"] = 3.56, ["Mega"] = 22.47, ["Mega|Ride"] = 150.84}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 4.2, ["Fly"] = 52.49, ["Ride"] = 33.34, ["Fly|Ride"] = 108.18, ["Neon"] = 8.17, ["Neon|Ride"] = 38.48, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 70.42, ["Mega|Fly"] = 158311.14, ["Mega|Ride"] = 139.54, ["Mega|Fly|Ride"] = 206.39}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 68.1, ["Fly"] = 525, ["Ride"] = 98.44, ["Fly|Ride"] = 127.34, ["Neon"] = 222.7, ["Neon|Ride"] = 292.69, ["Neon|Fly|Ride"] = 361.23, ["Mega|Fly|Ride"] = 1172.78}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 34.3, ["Ride"] = 15.73, ["Fly|Ride"] = 111.04, ["Neon"] = 8.24, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 129.94, ["Mega|Ride"] = 165.38, ["Mega|Fly|Ride"] = 313.35}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 7.43, ["Ride"] = 162.88, ["Neon"] = 89.25, ["Neon|Ride"] = 259.88, ["Mega"] = 459.38, ["Mega|Ride"] = 698.62, ["Mega|Fly|Ride"] = 557.28}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 52.14, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 14.88, ["Mega|Ride"] = 55.5, ["Mega|Fly|Ride"] = 299.91}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 61.11, ["Ride"] = 15.57, ["Fly|Ride"] = 35.63, ["Neon"] = 2.1, ["Neon|Fly"] = 14.44, ["Neon|Ride"] = 15.03, ["Neon|Fly|Ride"] = 38.01, ["Mega"] = 15.3, ["Mega|Fly"] = 31.44, ["Mega|Ride"] = 18.75, ["Mega|Fly|Ride"] = 64.31}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 18.15, ["Ride"] = 12.71, ["Fly|Ride"] = 64.13, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 15.79, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 134.11, ["Mega|Ride"] = 59.07}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.21, ["Neon|Ride"] = 63.67, ["Mega"] = 32.07, ["Mega|Ride"] = 95.29, ["Mega|Fly|Ride"] = 418.97}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 91.84, ["Ride"] = 20.95, ["Fly|Ride"] = 107.61, ["Neon"] = 4.2, ["Neon|Fly"] = 167.97, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 19.69, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 42.87, ["Mega|Fly|Ride"] = 147.24}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.6, ["Neon|Fly|Ride"] = 419.03, ["Mega"] = 17.68, ["Mega|Fly"] = 136.18, ["Mega|Ride"] = 69.57, ["Mega|Fly|Ride"] = 209.49}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.19, ["Fly"] = 70.19, ["Ride"] = 32.76, ["Fly|Ride"] = 70.12, ["Neon"] = 16.82, ["Neon|Fly"] = 69.27, ["Neon|Ride"] = 30.75, ["Neon|Fly|Ride"] = 118.84, ["Mega"] = 110.13, ["Mega|Fly"] = 349.79, ["Mega|Ride"] = 110.87, ["Mega|Fly|Ride"] = 189.73}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 50.94, ["Neon"] = 2.1, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 258.57, ["Mega"] = 14.27, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 56.6, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly|Ride"] = 524.99, ["Neon"] = 16.21, ["Mega"] = 188.41, ["Mega|Fly"] = 315, ["Mega|Ride"] = 712.48}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 28.29, ["Neon"] = 16.7, ["Mega"] = 42, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 559.32}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Neon"] = 3.62, ["Neon|Ride"] = 27.24, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 19.14, ["Mega|Ride"] = 41.66, ["Mega|Fly|Ride"] = 131.23}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 11.78, ["Fly|Ride"] = 40.69, ["Neon"] = 2.1, ["Neon|Fly"] = 16.78, ["Neon|Ride"] = 15.72, ["Neon|Fly|Ride"] = 32.44, ["Mega"] = 14.59, ["Mega|Fly"] = 39.82, ["Mega|Ride"] = 20.01, ["Mega|Fly|Ride"] = 49.76}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 229.68, ["Fly|Ride"] = 118.11, ["Neon"] = 34.92, ["Neon|Ride"] = 140.94, ["Mega"] = 178.03, ["Mega|Ride"] = 240.19}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 25.92, ["Neon"] = 3.92, ["Neon|Ride"] = 22.22, ["Neon|Fly|Ride"] = 105, ["Mega"] = 26.23, ["Mega|Ride"] = 45.84, ["Mega|Fly|Ride"] = 184.06}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.78, ["Neon"] = 11.46, ["Neon|Fly|Ride"] = 140.37, ["Mega"] = 94.5, ["Mega|Ride"] = 167.6, ["Mega|Fly|Ride"] = 238.87}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.49, ["Fly"] = 91.88, ["Ride"] = 46.1, ["Fly|Ride"] = 190.64, ["Neon"] = 65.62, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 118.13, ["Mega|Ride"] = 143.06, ["Mega|Fly|Ride"] = 193.41}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 11.68, ["Ride"] = 11.18, ["Fly|Ride"] = 20.99, ["Neon"] = 2.1, ["Neon|Fly"] = 14.84, ["Neon|Ride"] = 13.57, ["Neon|Fly|Ride"] = 30.99, ["Mega"] = 13.8, ["Mega|Fly"] = 25.95, ["Mega|Ride"] = 23.55, ["Mega|Fly|Ride"] = 51.08}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 28.29, ["Ride"] = 27.39, ["Fly|Ride"] = 131.25, ["Neon"] = 12.96, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 196.47, ["Mega"] = 105, ["Mega|Ride"] = 157.95, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.1, ["Fly"] = 112.03, ["Ride"] = 22.7, ["Fly|Ride"] = 58.46, ["Neon"] = 55.89, ["Neon|Ride"] = 67.48, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 236.24, ["Mega|Ride"] = 288.46, ["Mega|Fly|Ride"] = 411.99}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 32.71, ["Ride"] = 13, ["Fly|Ride"] = 36.81, ["Neon"] = 2.1, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 14.65, ["Neon|Fly|Ride"] = 35.2, ["Mega"] = 21, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 103.68}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 174.92, ["Ride"] = 29.03, ["Neon"] = 6.3, ["Neon|Ride"] = 28.3, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 65.62, ["Mega|Fly"] = 167.6, ["Mega|Ride"] = 118.02, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Neon"] = 3.4, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 32.82, ["Mega|Fly"] = 140.37, ["Mega|Ride"] = 139.12, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Ride"] = 17.99, ["Neon"] = 2.1, ["Neon|Fly"] = 41.92, ["Neon|Ride"] = 34.12, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 18.87, ["Mega|Ride"] = 40.68, ["Mega|Fly|Ride"] = 180.25}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 70.19, ["Ride"] = 16.23, ["Fly|Ride"] = 42.02, ["Neon"] = 11.54, ["Neon|Fly"] = 53.09, ["Neon|Ride"] = 19.07, ["Neon|Fly|Ride"] = 57.66, ["Mega"] = 91.77, ["Mega|Ride"] = 88.01}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 56.57, ["Neon"] = 5.07, ["Neon|Ride"] = 62.06, ["Mega"] = 35.03, ["Mega|Ride"] = 104.9}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 21.68, ["Ride"] = 13.89, ["Fly|Ride"] = 72.19, ["Neon"] = 13.08, ["Neon|Fly"] = 79.97, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 84, ["Mega"] = 103.69, ["Mega|Ride"] = 42, ["Mega|Fly|Ride"] = 142.94}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 3.94, ["Ride"] = 36.26, ["Neon"] = 30.35, ["Neon|Fly"] = 35.63, ["Neon|Ride"] = 75.45, ["Neon|Fly|Ride"] = 327.3, ["Mega"] = 97.17, ["Mega|Ride"] = 168.38, ["Mega|Fly|Ride"] = 837.92}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.75, ["Fly|Ride"] = 35.44, ["Neon"] = 33.7, ["Neon|Fly"] = 56.58, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 315, ["Mega|Fly"] = 420}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 21.52, ["Ride"] = 16.96, ["Fly|Ride"] = 49.24, ["Neon"] = 14.82, ["Neon|Fly"] = 44.01, ["Neon|Ride"] = 47.29, ["Neon|Fly|Ride"] = 72.17, ["Mega|Ride"] = 157.12, ["Mega|Fly|Ride"] = 390.09}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 110.93, ["Neon"] = 27.57, ["Mega"] = 217.95, ["Mega|Ride"] = 236.24}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 7.59, ["Ride"] = 56.44, ["Neon"] = 209.09, ["Neon|Ride"] = 237.45, ["Mega|Ride"] = 697.57, ["Mega|Fly|Ride"] = 794.98}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.63, ["Ride"] = 35.63, ["Neon"] = 41.67, ["Neon|Ride"] = 125.71, ["Mega"] = 264.5, ["Mega|Ride"] = 312.74}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 5.41, ["Ride"] = 31.5, ["Fly|Ride"] = 140.37, ["Neon"] = 33.27, ["Neon|Ride"] = 82.78, ["Neon|Fly|Ride"] = 182.28, ["Mega"] = 474.94, ["Mega|Ride"] = 279.66, ["Mega|Fly|Ride"] = 301.6}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 64.98, ["Mega"] = 23.06, ["Mega|Fly"] = 125.7, ["Mega|Ride"] = 125.7, ["Mega|Fly|Ride"] = 123.61}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 38.06}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 3.94, ["Fly"] = 22.43, ["Ride"] = 19.1, ["Fly|Ride"] = 38.21, ["Neon"] = 51.61, ["Neon|Fly"] = 188.48, ["Neon|Ride"] = 41.69, ["Neon|Fly|Ride"] = 78.62, ["Mega"] = 374.32, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 295.14}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 13.02, ["Neon"] = 2.1, ["Neon|Fly"] = 32.07, ["Neon|Ride"] = 25.09, ["Neon|Fly|Ride"] = 156.73, ["Mega"] = 24.93, ["Mega|Fly"] = 140.37, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 90.96}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 48.2, ["Neon"] = 6.46, ["Neon|Ride"] = 32.9, ["Mega"] = 39.82, ["Mega|Ride"] = 71.31, ["Mega|Fly|Ride"] = 133.88}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 49.24, ["Ride"] = 18.87, ["Fly|Ride"] = 55.65, ["Neon"] = 15.65, ["Neon|Ride"] = 56.58, ["Neon|Fly|Ride"] = 118.6, ["Mega"] = 124.66, ["Mega|Ride"] = 159.12, ["Mega|Fly|Ride"] = 168.32}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.94, ["Ride"] = 36.66, ["Fly|Ride"] = 57.75, ["Neon"] = 35.05, ["Neon|Ride"] = 131.06, ["Mega"] = 418.97, ["Mega|Ride"] = 275.44}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Fly"] = 83.81, ["Ride"] = 31.82, ["Neon"] = 2.63, ["Mega"] = 18.87, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 56.31, ["Mega|Fly|Ride"] = 335.18}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 21.67, ["Ride"] = 16.05, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 110.9, ["Neon|Ride"] = 19.71, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 28.5, ["Mega|Ride"] = 45.98, ["Mega|Fly|Ride"] = 131.35}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.11, ["Ride"] = 13.16, ["Fly|Ride"] = 32.82, ["Neon"] = 3.93, ["Neon|Fly"] = 70.2, ["Neon|Ride"] = 18.15, ["Neon|Fly|Ride"] = 48.4, ["Mega"] = 47.95, ["Mega|Fly"] = 140.37, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 106.87}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 28.29, ["Ride"] = 52.37, ["Fly|Ride"] = 118.13, ["Neon"] = 3.29, ["Neon|Ride"] = 27.86, ["Neon|Fly|Ride"] = 112.1, ["Mega"] = 30.18, ["Mega|Ride"] = 79.59, ["Mega|Fly|Ride"] = 215.25}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 166.82, ["Neon|Fly|Ride"] = 152910.43, ["Mega"] = 16.93, ["Mega|Fly"] = 106.45, ["Mega|Ride"] = 110.29, ["Mega|Fly|Ride"] = 141.75}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.87, ["Ride"] = 21, ["Fly|Ride"] = 79.62, ["Neon"] = 2.96, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 20.35, ["Mega|Fly"] = 62.86, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 118.12}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Neon"] = 2.5, ["Neon|Ride"] = 36.74, ["Mega"] = 2654.08, ["Mega|Ride"] = 411.16}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.63, ["Neon"] = 2.52, ["Neon|Ride"] = 317, ["Neon|Fly|Ride"] = 420, ["Mega"] = 27.35, ["Mega|Ride"] = 159.12}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 18.8, ["Fly|Ride"] = 49.87, ["Neon"] = 10.5, ["Neon|Fly"] = 32.81, ["Neon|Ride"] = 17.01, ["Neon|Fly|Ride"] = 45.93, ["Mega"] = 124.69, ["Mega|Ride"] = 49.5, ["Mega|Fly|Ride"] = 94.49}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 28.29, ["Ride"] = 86.63, ["Neon"] = 140.38, ["Mega"] = 435.75, ["Mega|Ride"] = 666.75, ["Mega|Fly|Ride"] = 698.62}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 56.24, ["Neon"] = 41.99, ["Mega"] = 190.7}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 4.13, ["Ride"] = 30.34, ["Fly|Ride"] = 180.16, ["Neon"] = 70.19, ["Neon|Fly|Ride"] = 266.09, ["Mega"] = 397.95, ["Mega|Ride"] = 364.53, ["Mega|Fly|Ride"] = 375.27}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 12.97, ["Ride"] = 11.69, ["Fly|Ride"] = 23.9, ["Neon"] = 2.1, ["Neon|Fly"] = 14.59, ["Neon|Ride"] = 12.84, ["Neon|Fly|Ride"] = 24.56, ["Mega"] = 13.86, ["Mega|Fly"] = 22.8, ["Mega|Ride"] = 19.66, ["Mega|Fly|Ride"] = 39.38}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 65.63, ["Neon"] = 6.57, ["Neon|Fly"] = 67.06, ["Neon|Ride"] = 32.49, ["Neon|Fly|Ride"] = 698.71, ["Mega"] = 85.31, ["Mega|Ride"] = 118.02}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.01, ["Neon"] = 2.1, ["Neon|Fly"] = 31.28, ["Neon|Ride"] = 22.6, ["Neon|Fly|Ride"] = 84.16, ["Mega"] = 14.36, ["Mega|Ride"] = 69.55, ["Mega|Fly|Ride"] = 132.2}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 60.89, ["Neon|Ride"] = 127.32, ["Mega"] = 27.57, ["Mega|Fly|Ride"] = 167.6}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 41.97, ["Ride"] = 16.88, ["Fly|Ride"] = 69.57, ["Neon"] = 10.4, ["Neon|Ride"] = 32.03, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 208.95, ["Mega|Ride"] = 398.03, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 153.2, ["Fly"] = 183.75, ["Ride"] = 212.63, ["Fly|Ride"] = 261.85, ["Neon"] = 925.5, ["Mega"] = 8379.08, ["Mega|Fly|Ride"] = 3959.75}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 17.82, ["Neon"] = 8.06, ["Neon|Ride"] = 64.31, ["Mega"] = 91.88, ["Mega|Ride"] = 170.73, ["Mega|Fly|Ride"] = 624.88}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 2.1, ["Fly"] = 64.97, ["Ride"] = 26.12, ["Fly|Ride"] = 65.63, ["Neon"] = 24.94, ["Neon|Ride"] = 94.99, ["Neon|Fly|Ride"] = 167.63, ["Mega"] = 370.32, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 414.78}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 15.11, ["Ride"] = 12.37, ["Fly|Ride"] = 32.79, ["Neon"] = 5.25, ["Neon|Fly"] = 28.3, ["Neon|Ride"] = 29.34, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 49.67, ["Mega|Ride"] = 80.56, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 56.57, ["Ride"] = 19.68, ["Fly|Ride"] = 92.57, ["Neon"] = 6.36, ["Neon|Ride"] = 78.46, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 140.37, ["Mega|Ride"] = 182.25}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 2.1, ["Fly"] = 23.4, ["Ride"] = 17.82, ["Fly|Ride"] = 35.62, ["Neon"] = 47.49, ["Neon|Fly"] = 98.85, ["Neon|Ride"] = 38.06, ["Neon|Fly|Ride"] = 74.83, ["Mega|Ride"] = 279.66, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 4.66, ["Ride"] = 41.91, ["Fly|Ride"] = 252.06, ["Neon"] = 78.44, ["Neon|Ride"] = 140.72, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 418.97, ["Mega|Ride"] = 371.09, ["Mega|Fly|Ride"] = 1047.39}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 3.51, ["Fly"] = 22.32, ["Ride"] = 15.01, ["Fly|Ride"] = 35.15, ["Neon"] = 19.65, ["Neon|Fly"] = 68.15, ["Neon|Ride"] = 28.3, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 140.37, ["Mega|Fly|Ride"] = 215.25}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 58.7, ["Fly"] = 121.51, ["Ride"] = 86.98, ["Fly|Ride"] = 131.22, ["Neon"] = 384.41, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 349.89, ["Neon|Fly|Ride"] = 512.69, ["Mega|Fly|Ride"] = 1450.97}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 223.12, ["Fly"] = 335.18, ["Ride"] = 227.2, ["Fly|Ride"] = 269.49, ["Neon|Ride"] = 2618.79, ["Neon|Fly|Ride"] = 870.1, ["Mega"] = 10473.84, ["Mega|Fly|Ride"] = 4883.96}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 54.71, ["Fly"] = 140.37, ["Ride"] = 77.44, ["Fly|Ride"] = 111.57, ["Neon"] = 701.38, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 391.74, ["Mega|Fly|Ride"] = 1283.63}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 4.8, ["Fly"] = 287.89, ["Ride"] = 36.67, ["Fly|Ride"] = 138.13, ["Neon"] = 26.93, ["Neon|Ride"] = 68.23, ["Neon|Fly|Ride"] = 179.81, ["Mega"] = 309.72, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 414.1}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 6.4, ["Fly"] = 70.19, ["Ride"] = 31.5, ["Fly|Ride"] = 60.24, ["Neon"] = 81.37, ["Neon|Ride"] = 126.27, ["Neon|Fly|Ride"] = 279.7, ["Mega"] = 338.94, ["Mega|Ride"] = 383.34, ["Mega|Fly|Ride"] = 1256.88}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 17.84, ["Fly|Ride"] = 44.51, ["Neon"] = 3.51, ["Neon|Fly"] = 23.63, ["Neon|Ride"] = 20.57, ["Neon|Fly|Ride"] = 56.58, ["Mega"] = 49.88, ["Mega|Fly"] = 154.88, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 84.46}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.04, ["Fly"] = 90.2, ["Ride"] = 18.38, ["Fly|Ride"] = 62.86, ["Neon"] = 123.61, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 163.07, ["Mega"] = 413.44, ["Mega|Ride"] = 1018.5, ["Mega|Fly|Ride"] = 732.38}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.9, ["Ride"] = 15.21, ["Fly|Ride"] = 35.44, ["Neon"] = 11.82, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 29.87, ["Neon|Fly|Ride"] = 100.49, ["Mega"] = 182.25, ["Mega|Fly"] = 65.63, ["Mega|Ride"] = 215.49, ["Mega|Fly|Ride"] = 171.52}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.19, ["Ride"] = 21.18, ["Fly|Ride"] = 328.13, ["Neon"] = 19.69, ["Neon|Ride"] = 65.63, ["Mega"] = 207.38, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 480.68}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 33.53, ["Ride"] = 19.19, ["Neon"] = 2.1, ["Neon|Ride"] = 19.65, ["Neon|Fly|Ride"] = 57.73, ["Mega"] = 15.74, ["Mega|Ride"] = 41.91, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 18.38, ["Fly|Ride"] = 35.63, ["Neon"] = 15.74, ["Neon|Fly"] = 104.77, ["Neon|Ride"] = 35.63, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 108.93, ["Mega|Fly|Ride"] = 157.75}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 24.94, ["Ride"] = 19.69, ["Fly|Ride"] = 61.32, ["Neon"] = 26.25, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 559.38, ["Mega"] = 266.04, ["Mega|Ride"] = 199.02, ["Mega|Fly|Ride"] = 279.66}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 159.03, ["Fly"] = 148.18, ["Ride"] = 131.25, ["Fly|Ride"] = 279.66, ["Neon"] = 622.16, ["Neon|Ride"] = 549.28, ["Neon|Fly|Ride"] = 802.19, ["Mega"] = 4189.55, ["Mega|Ride"] = 2654.08, ["Mega|Fly|Ride"] = 2035.47}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 8.17, ["Ride"] = 32.83, ["Fly|Ride"] = 209.49, ["Neon"] = 40.69, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 376.56, ["Mega"] = 418.97, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 41.46, ["Ride"] = 15.42, ["Fly|Ride"] = 46.29, ["Neon"] = 12.99, ["Neon|Ride"] = 27.64, ["Neon|Fly|Ride"] = 120.74, ["Mega"] = 237.47, ["Mega|Ride"] = 187.69, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 19.77, ["Ride"] = 41.32, ["Fly|Ride"] = 170.63, ["Neon"] = 79.52, ["Neon|Fly|Ride"] = 561.75, ["Mega"] = 551.25, ["Mega|Fly"] = 837.92, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 3.89}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 115.5, ["Neon"] = 52.5, ["Neon|Ride"] = 91.83, ["Neon|Fly|Ride"] = 349.89, ["Mega"] = 279.66, ["Mega|Ride"] = 565.69, ["Mega|Fly|Ride"] = 915.43}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 25.05, ["Fly"] = 26.1, ["Ride"] = 30.08, ["Fly|Ride"] = 49.26, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 205.33, ["Neon|Fly|Ride"] = 168.87, ["Mega"] = 2094.78, ["Mega|Fly|Ride"] = 698.62}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 23.98, ["Neon"] = 3.33, ["Neon|Fly"] = 65.62, ["Neon|Ride"] = 31.44, ["Neon|Fly|Ride"] = 106.26, ["Mega"] = 28.28, ["Mega|Fly"] = 279.66, ["Mega|Ride"] = 62.53, ["Mega|Fly|Ride"] = 228.69}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 15.22, ["Fly"] = 28.29, ["Ride"] = 25.15, ["Fly|Ride"] = 62.86, ["Neon"] = 45.85, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 237.45, ["Mega"] = 267.81, ["Mega|Fly"] = 396.59, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 379.16}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 13.13, ["Fly|Ride"] = 46.12, ["Neon"] = 8.72, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 35.11, ["Neon|Fly|Ride"] = 64.37, ["Mega"] = 174.92, ["Mega|Ride"] = 182.13, ["Mega|Fly|Ride"] = 271.69}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 32.43, ["Fly|Ride"] = 78.57, ["Neon"] = 3.06, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 209.52, ["Mega"] = 17.75, ["Mega|Ride"] = 112.09, ["Mega|Fly|Ride"] = 182.25}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 22.23, ["Ride"] = 71.46, ["Fly|Ride"] = 142.43, ["Neon"] = 329.95, ["Neon|Ride"] = 248.09, ["Neon|Fly|Ride"] = 576.19, ["Mega"] = 799.99, ["Mega|Ride"] = 949.88, ["Mega|Fly|Ride"] = 972.13}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Fly|Ride"] = 210, ["Neon"] = 92.26, ["Neon|Ride"] = 140.38, ["Mega|Ride"] = 524.99}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 2.58, ["Fly"] = 207.9, ["Ride"] = 20.5, ["Fly|Ride"] = 61.15, ["Neon"] = 18.22, ["Neon|Fly"] = 315, ["Neon|Ride"] = 32.8, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 346.86, ["Mega|Ride"] = 267.09, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 68.83, ["Fly"] = 433.13, ["Ride"] = 167.6, ["Fly|Ride"] = 262.46, ["Neon"] = 328.13, ["Neon|Ride"] = 544.72, ["Mega|Ride"] = 2165.63, ["Mega|Fly|Ride"] = 2068.6}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 6.17, ["Fly"] = 32.7, ["Ride"] = 19.69, ["Fly|Ride"] = 55.99, ["Neon"] = 31.5, ["Neon|Ride"] = 52.94, ["Neon|Fly|Ride"] = 224.18, ["Mega"] = 249.38, ["Mega|Ride"] = 244.13, ["Mega|Fly|Ride"] = 651.7}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 67.48, ["Fly"] = 163.41, ["Ride"] = 84, ["Neon"] = 271.69, ["Neon|Ride"] = 220.88, ["Neon|Fly|Ride"] = 333.38, ["Mega"] = 1131.18, ["Mega|Ride"] = 1256.88, ["Mega|Fly|Ride"] = 1072.87}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 19.69, ["Ride"] = 53.13, ["Fly|Ride"] = 140.37, ["Neon"] = 78.57, ["Neon|Ride"] = 138.29, ["Neon|Fly|Ride"] = 235.95, ["Mega"] = 590.63, ["Mega|Ride"] = 330.47, ["Mega|Fly|Ride"] = 413.44}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 4.41, ["Fly"] = 99.96, ["Ride"] = 28.29, ["Fly|Ride"] = 62.57, ["Neon"] = 103.85, ["Neon|Ride"] = 90.55, ["Neon|Fly|Ride"] = 254.1, ["Mega"] = 416.96, ["Mega|Ride"] = 1571.09, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 13.37, ["Ride"] = 60.79, ["Fly|Ride"] = 162.54, ["Neon"] = 66.04, ["Neon|Ride"] = 119.43, ["Neon|Fly|Ride"] = 354.38, ["Mega"] = 294.71, ["Mega|Ride"] = 302.43, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 7.88, ["Ride"] = 24.8, ["Fly|Ride"] = 88.01, ["Neon"] = 31.15, ["Neon|Ride"] = 47.16, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 236.25, ["Mega|Ride"] = 362.25, ["Mega|Fly|Ride"] = 483}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 57.1, ["Mega"] = 24.94, ["Mega|Ride"] = 125.7, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 5.25, ["Ride"] = 28.42, ["Neon"] = 22.58, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 159.12, ["Mega|Ride"] = 278.61, ["Mega|Fly|Ride"] = 416.88}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 124.66, ["Neon"] = 25.74, ["Mega"] = 163.72, ["Mega|Ride"] = 418.76, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 3.84, ["Ride"] = 32.79, ["Fly|Ride"] = 118.7, ["Neon"] = 32.06, ["Neon|Ride"] = 85.32, ["Mega"] = 124.69, ["Mega|Ride"] = 279.66, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 574.01, ["Ride"] = 565.9, ["Fly|Ride"] = 774.38, ["Neon"] = 1807.79, ["Neon|Ride"] = 1784.04, ["Neon|Fly|Ride"] = 1583.74, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 5.25, ["Fly"] = 37.72, ["Ride"] = 19.2, ["Fly|Ride"] = 56.35, ["Neon"] = 40.86, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 158.85, ["Mega|Ride"] = 360.76, ["Mega|Fly|Ride"] = 502.77}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 17.82, ["Fly"] = 524.69, ["Ride"] = 31.13, ["Fly|Ride"] = 51.54, ["Neon"] = 48.57, ["Neon|Fly"] = 315, ["Neon|Ride"] = 97.35, ["Neon|Fly|Ride"] = 156.4, ["Mega"] = 331.85, ["Mega|Ride"] = 418.97, ["Mega|Fly|Ride"] = 502.77}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.1, ["Fly"] = 91.87, ["Ride"] = 26.87, ["Fly|Ride"] = 314.23, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 159.12, ["Mega|Ride"] = 279.66}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.58, ["Ride"] = 21.84, ["Fly|Ride"] = 90.57, ["Neon"] = 6.39, ["Neon|Ride"] = 29.91, ["Neon|Fly|Ride"] = 123.48, ["Mega"] = 63.47, ["Mega|Fly"] = 211.78, ["Mega|Ride"] = 101.07, ["Mega|Fly|Ride"] = 210.5}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 70.19, ["Ride"] = 19.69, ["Neon"] = 2.1, ["Neon|Ride"] = 24.05, ["Neon|Fly|Ride"] = 124.67, ["Mega"] = 23.19, ["Mega|Ride"] = 65.54, ["Mega|Fly|Ride"] = 220.5}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1109.06}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 9.19, ["Ride"] = 48.38, ["Fly|Ride"] = 52.5, ["Neon"] = 60.38, ["Neon|Ride"] = 91.75, ["Mega"] = 559.32, ["Mega|Ride"] = 569.93, ["Mega|Fly|Ride"] = 698.62}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 28.26, ["Neon"] = 5.92, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 982.1, ["Mega"] = 39.37, ["Mega|Ride"] = 141.85, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 41.41, ["Ride"] = 126.15, ["Neon"] = 19.59, ["Neon|Ride"] = 140.38, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 183.74, ["Mega|Ride"] = 372.84}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 419.98, ["Ride"] = 472.49, ["Fly|Ride"] = 542.13, ["Neon|Ride"] = 1373.68, ["Neon|Fly|Ride"] = 1719.38, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 3.24, ["Fly"] = 196.88, ["Ride"] = 56.57, ["Fly|Ride"] = 418.97, ["Neon"] = 36.06, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 189.97, ["Mega|Ride"] = 474.94, ["Mega|Fly|Ride"] = 681.55}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 88.51, ["Ride"] = 22.3, ["Fly|Ride"] = 118.13, ["Neon"] = 3.73, ["Neon|Ride"] = 35.25, ["Neon|Fly|Ride"] = 95.07, ["Mega"] = 36.37, ["Mega|Fly"] = 124.85, ["Mega|Ride"] = 70.83, ["Mega|Fly|Ride"] = 261.09}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 3.9, ["Neon|Ride"] = 28.29, ["Neon|Fly|Ride"] = 279.7, ["Mega"] = 30.09, ["Mega|Ride"] = 134.78, ["Mega|Fly|Ride"] = 374.07}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 10.06, ["Fly"] = 107.63, ["Ride"] = 80.05, ["Fly|Ride"] = 87.28, ["Neon"] = 127.56, ["Neon|Ride"] = 231.52, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 489.15, ["Mega|Ride"] = 624.25, ["Mega|Fly|Ride"] = 595.88}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 7.94, ["Ride"] = 71.31, ["Neon"] = 80.12, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 465.94, ["Mega|Ride"] = 477.75, ["Mega|Fly|Ride"] = 628.44}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 7.16, ["Ride"] = 31.39, ["Neon"] = 131.25, ["Neon|Ride"] = 179.29, ["Mega"] = 644.69, ["Mega|Fly|Ride"] = 1256.88}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 10.39, ["Ride"] = 23.15, ["Fly|Ride"] = 262.5, ["Neon"] = 167.37, ["Neon|Ride"] = 182.44, ["Neon|Fly|Ride"] = 209.52, ["Mega"] = 616.88, ["Mega|Ride"] = 1300.69, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 333.3, ["Ride"] = 391.59, ["Fly|Ride"] = 764.29, ["Neon"] = 918.75, ["Neon|Ride"] = 978.38, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4189.55}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 2.89, ["Fly"] = 78.73, ["Ride"] = 20.79, ["Fly|Ride"] = 236.25, ["Neon"] = 144.04, ["Neon|Ride"] = 159.1, ["Neon|Fly|Ride"] = 209.52, ["Mega"] = 837.92, ["Mega|Ride"] = 1019.82, ["Mega|Fly|Ride"] = 1044.25}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 6.57, ["Ride"] = 126, ["Neon"] = 53.43, ["Neon|Ride"] = 84, ["Mega"] = 224.16, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 1047.39}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 18.16, ["Fly"] = 70.19, ["Ride"] = 70.87, ["Neon"] = 79.92, ["Neon|Ride"] = 139.69, ["Neon|Fly|Ride"] = 260.78, ["Mega"] = 301.76, ["Mega|Fly"] = 698.62, ["Mega|Ride"] = 291.38, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Ride"] = 79.62, ["Fly|Ride"] = 140.37, ["Neon"] = 5.25, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 270.27, ["Mega"] = 53.82, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 34.13, ["Ride"] = 74.08, ["Neon"] = 377.08, ["Neon|Ride"] = 417.98, ["Neon|Fly|Ride"] = 489.2, ["Mega"] = 2513.74, ["Mega|Ride"] = 2773.49, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 521, ["Ride"] = 25.2, ["Neon"] = 5.59, ["Neon|Fly"] = 182.28, ["Neon|Ride"] = 77.16, ["Neon|Fly|Ride"] = 131.8, ["Mega"] = 93.73, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 41.91, ["Ride"] = 31.53, ["Neon"] = 6.57, ["Neon|Fly"] = 49.39, ["Neon|Ride"] = 47.23, ["Neon|Fly|Ride"] = 97.89, ["Mega"] = 58.67, ["Mega|Fly"] = 112.88, ["Mega|Ride"] = 75.42, ["Mega|Fly|Ride"] = 170.46}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 32.06, ["Fly|Ride"] = 127.52, ["Neon"] = 6.57, ["Neon|Ride"] = 53.73, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 111.62, ["Mega|Fly"] = 459.38, ["Mega|Ride"] = 144.27, ["Mega|Fly|Ride"] = 279.66}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 36.58, ["Fly"] = 94.95, ["Ride"] = 59.07, ["Fly|Ride"] = 169.32, ["Neon"] = 291.38, ["Neon|Ride"] = 297.36, ["Neon|Fly|Ride"] = 472.33, ["Mega|Ride"] = 1117.57, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 224.44, ["Ride"] = 292.36, ["Fly|Ride"] = 411.76, ["Neon"] = 1455.88, ["Neon|Ride"] = 1139.14, ["Neon|Fly|Ride"] = 1297.57, ["Mega"] = 4068.75, ["Mega|Fly|Ride"] = 4416.57}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 19.69, ["Ride"] = 30.95, ["Neon"] = 32.06, ["Neon|Fly"] = 350.44, ["Mega"] = 98.18, ["Mega|Ride"] = 131.25}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 140.37, ["Ride"] = 32.82, ["Neon"] = 8.33, ["Neon|Ride"] = 44.1, ["Neon|Fly|Ride"] = 139.13, ["Mega"] = 62.41, ["Mega|Fly"] = 210, ["Mega|Ride"] = 102.37, ["Mega|Fly|Ride"] = 241.5}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.1, ["Fly"] = 158.87, ["Ride"] = 27.57, ["Fly|Ride"] = 47.49, ["Neon"] = 32.81, ["Neon|Ride"] = 70.2, ["Mega"] = 135.45, ["Mega|Ride"] = 348.23}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 71.24, ["Ride"] = 39.82, ["Fly|Ride"] = 69.8, ["Neon"] = 11.24, ["Neon|Ride"] = 37.73, ["Neon|Fly|Ride"] = 155.05, ["Mega"] = 78.65, ["Mega|Ride"] = 141.32, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 7.88, ["Neon|Fly|Ride"] = 191.71, ["Mega"] = 29.34, ["Mega|Fly"] = 140.37, ["Mega|Fly|Ride"] = 346.69}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 28.29, ["Ride"] = 17.07, ["Fly|Ride"] = 49.88, ["Neon"] = 7.13, ["Neon|Fly"] = 79.56, ["Neon|Ride"] = 28.3, ["Neon|Fly|Ride"] = 419.03, ["Mega"] = 39.38, ["Mega|Ride"] = 95.72, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 140.37, ["Ride"] = 15.89, ["Fly|Ride"] = 27.23, ["Neon"] = 13.13, ["Neon|Fly"] = 64.97, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 95.01, ["Mega"] = 156.15, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 166.55}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 26.54, ["Fly"] = 52.5, ["Ride"] = 31.37, ["Fly|Ride"] = 78.73, ["Neon|Fly|Ride"] = 317, ["Mega"] = 388.5, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 559.32}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 63, ["Ride"] = 78.65, ["Fly|Ride"] = 127.05, ["Neon"] = 518.44, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 3346.14, ["Mega|Ride"] = 3254.99, ["Mega|Fly|Ride"] = 1502.82}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 17.88, ["Fly|Ride"] = 131.25, ["Neon"] = 3.89, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 128.47, ["Mega"] = 38.09, ["Mega|Fly"] = 672, ["Mega|Ride"] = 92.8, ["Mega|Fly|Ride"] = 418.97}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 13.43, ["Ride"] = 14.06, ["Fly|Ride"] = 39.37, ["Neon"] = 3.93, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 23.77, ["Neon|Fly|Ride"] = 61.68, ["Mega"] = 61.69, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 11.82, ["Ride"] = 73.5, ["Neon"] = 39.38, ["Neon|Ride"] = 124.68, ["Neon|Fly|Ride"] = 279.7, ["Mega"] = 690.24, ["Mega|Ride"] = 274.31, ["Mega|Fly|Ride"] = 634.05}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.54, ["Ride"] = 472.5, ["Fly|Ride"] = 577.5, ["Neon|Ride"] = 6562.5, ["Mega|Fly|Ride"] = 7915.93}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 25.4, ["Fly"] = 101.33, ["Ride"] = 45.66, ["Fly|Ride"] = 102.34, ["Neon"] = 278.91, ["Neon|Ride"] = 210.74, ["Neon|Fly|Ride"] = 305.81, ["Mega|Ride"] = 1256.88, ["Mega|Fly|Ride"] = 934.44}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 25.75, ["Fly|Ride"] = 281.31, ["Neon"] = 7.88, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 169.32, ["Mega"] = 83.91, ["Mega|Ride"] = 127.07, ["Mega|Fly|Ride"] = 182.25}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 65.61, ["Fly|Ride"] = 143.05, ["Neon"] = 17.82, ["Mega"] = 328.13}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 22.32, ["Fly"] = 169.3, ["Ride"] = 39.38, ["Fly|Ride"] = 91.88, ["Neon"] = 194.25, ["Neon|Ride"] = 352.22, ["Neon|Fly|Ride"] = 264.99, ["Mega"] = 2513.74, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1256.88}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 77.84, ["Ride"] = 110.04, ["Fly|Ride"] = 418.97, ["Neon"] = 434.43, ["Neon|Ride"] = 557.29, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 8379.08, ["Mega|Fly|Ride"] = 2262.36}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 183.75, ["Ride"] = 271.21, ["Fly|Ride"] = 522.66, ["Neon|Ride"] = 630, ["Neon|Fly|Ride"] = 1257.03, ["Mega|Fly|Ride"] = 4046.05}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 14.03, ["Fly"] = 53.97, ["Ride"] = 61.68, ["Fly|Ride"] = 96.17, ["Neon"] = 78.75, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 104.49, ["Mega"] = 388.49, ["Mega|Ride"] = 363.57, ["Mega|Fly|Ride"] = 503.86}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 18.21, ["Ride"] = 15.49, ["Fly|Ride"] = 41.91, ["Neon"] = 11.22, ["Neon|Ride"] = 21.98, ["Neon|Fly|Ride"] = 91.16, ["Mega"] = 93.18, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 170.35}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.1, ["Fly"] = 39.19, ["Ride"] = 16.02, ["Fly|Ride"] = 59.36, ["Neon"] = 70.19, ["Neon|Fly"] = 105, ["Neon|Ride"] = 35.47, ["Neon|Fly|Ride"] = 70.56, ["Mega|Ride"] = 279.57, ["Mega|Fly|Ride"] = 366.19}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 298.82, ["Fly"] = 489.15, ["Ride"] = 357.24, ["Fly|Ride"] = 620.06, ["Neon"] = 1575, ["Neon|Ride"] = 2150.35, ["Mega"] = 10054.9, ["Mega|Fly|Ride"] = 6269.82}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Neon"] = 6.38, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 35.44, ["Mega|Ride"] = 170.99}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 4.31, ["Ride"] = 15.72, ["Fly|Ride"] = 55.13, ["Neon"] = 25.65, ["Neon|Ride"] = 37.54, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 230.39, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 194.25, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 19.85, ["Ride"] = 47.48, ["Neon"] = 104.99, ["Neon|Fly"] = 419.03, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 70.2, ["Mega"] = 527.7, ["Mega|Ride"] = 649.69, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 102.38, ["Fly"] = 213.68, ["Ride"] = 99.43, ["Fly|Ride"] = 127.03, ["Neon|Ride"] = 524.99, ["Neon|Fly|Ride"] = 617.21, ["Mega|Fly|Ride"] = 2378.25}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 14.44, ["Fly"] = 43.29, ["Ride"] = 22.77, ["Fly|Ride"] = 55.84, ["Neon"] = 104.75, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 698.62, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 593.67}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 20.84, ["Neon"] = 3.15, ["Neon|Ride"] = 140.38, ["Mega"] = 24.42, ["Mega|Ride"] = 279.66, ["Mega|Fly|Ride"] = 279.66}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 19.69, ["Fly|Ride"] = 70.19, ["Neon"] = 2.1, ["Neon|Ride"] = 19.85, ["Neon|Fly|Ride"] = 76.81, ["Mega"] = 36.67, ["Mega|Fly"] = 97.12, ["Mega|Ride"] = 39.29, ["Mega|Fly|Ride"] = 103.94}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 9.22, ["Ride"] = 75.99, ["Fly|Ride"] = 135.48, ["Neon"] = 27.36, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 78.66, ["Neon|Fly|Ride"] = 181.9, ["Mega"] = 164.37, ["Mega|Fly"] = 279.66, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1121.39, ["Fly"] = 1637.55, ["Ride"] = 1414.88, ["Fly|Ride"] = 1309.87, ["Neon"] = 4200, ["Neon|Ride"] = 3976.88, ["Neon|Fly|Ride"] = 3856.05, ["Mega|Fly|Ride"] = 12589.5}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 425.88, ["Ride"] = 393.75, ["Fly|Ride"] = 639, ["Neon"] = 2423.08, ["Neon|Ride"] = 1640.63, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 16758.14}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 307.13, ["Ride"] = 341.24, ["Fly|Ride"] = 446.25, ["Neon"] = 656.15, ["Neon|Ride"] = 791.21, ["Neon|Fly|Ride"] = 774.38, ["Mega|Fly|Ride"] = 2916.24}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 366.59, ["Fly"] = 559.32, ["Ride"] = 434.68, ["Fly|Ride"] = 412.25, ["Neon"] = 1256.88, ["Neon|Ride"] = 1108.86, ["Neon|Fly|Ride"] = 889.17}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 64.31, ["Ride"] = 15.64, ["Fly|Ride"] = 38.71, ["Neon"] = 7.13, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 105, ["Mega"] = 68.2, ["Mega|Fly"] = 98.47, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 200.82}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 459.23, ["Fly"] = 1397.22, ["Ride"] = 502.77, ["Fly|Ride"] = 606.45, ["Neon"] = 1706.24, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1986.09, ["Mega|Ride"] = 6703.27, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 3.94, ["Fly"] = 157.5, ["Ride"] = 37.72, ["Fly|Ride"] = 112.54, ["Neon"] = 13.12, ["Neon|Ride"] = 207.34, ["Neon|Fly|Ride"] = 252, ["Mega"] = 137.36, ["Mega|Ride"] = 204.65, ["Mega|Fly|Ride"] = 219.19}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 18.12, ["Ride"] = 13.91, ["Fly|Ride"] = 39.38, ["Neon"] = 8.39, ["Neon|Ride"] = 31.28, ["Neon|Fly|Ride"] = 110.42, ["Mega"] = 104.81, ["Mega|Ride"] = 192.93, ["Mega|Fly|Ride"] = 145.6}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 2.43, ["Neon|Ride"] = 39.37, ["Mega"] = 30.03, ["Mega|Ride"] = 196.77}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 30.32, ["Fly|Ride"] = 459.38, ["Neon"] = 273, ["Neon|Ride"] = 351.29, ["Mega"] = 1050, ["Mega|Ride"] = 488.25, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 7911.22, ["Ride"] = 27.25, ["Fly|Ride"] = 68.24, ["Neon"] = 73.5, ["Mega|Ride"] = 432.2, ["Mega|Fly|Ride"] = 418.97}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 3.54, ["Neon|Ride"] = 41.15, ["Neon|Fly|Ride"] = 93.94, ["Mega"] = 24.05, ["Mega|Ride"] = 68.01, ["Mega|Fly|Ride"] = 65.63}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 34.13, ["Ride"] = 17.14, ["Fly|Ride"] = 78.65, ["Neon"] = 17.07, ["Neon|Fly"] = 113.9, ["Neon|Ride"] = 45.55, ["Neon|Fly|Ride"] = 76.34, ["Mega"] = 111.46, ["Mega|Fly"] = 474.94, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 2.1, ["Fly"] = 56.57, ["Ride"] = 19.23, ["Fly|Ride"] = 51.98, ["Neon"] = 155.05, ["Neon|Fly"] = 41.92, ["Neon|Ride"] = 140.38, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 238.83, ["Mega|Ride"] = 300.51, ["Mega|Fly|Ride"] = 1296.75}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 9.59, ["Ride"] = 59.36, ["Neon"] = 115.5, ["Mega"] = 515.31, ["Mega|Ride"] = 784.51, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 6329.46, ["Ride"] = 28.29, ["Neon"] = 37.79, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 183.73, ["Neon|Fly|Ride"] = 712.34, ["Mega"] = 301.88, ["Mega|Ride"] = 489.15, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 64.37, ["Ride"] = 18.38, ["Fly|Ride"] = 45.94, ["Neon"] = 4.03, ["Neon|Fly"] = 31.44, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 75.45, ["Mega"] = 50.29, ["Mega|Fly|Ride"] = 314.23}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 155.76, ["Ride"] = 178.5, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 900.87, ["Neon|Fly|Ride"] = 1036.87, ["Mega"] = 8379.08, ["Mega|Ride"] = 4189.55, ["Mega|Fly|Ride"] = 2756.25}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 14.32, ["Fly|Ride"] = 28.49, ["Neon"] = 2.1, ["Neon|Ride"] = 24.83, ["Neon|Fly|Ride"] = 56.35, ["Mega"] = 44.63, ["Mega|Ride"] = 52.76, ["Mega|Fly|Ride"] = 174.59}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 6.13, ["Ride"] = 56.57, ["Fly|Ride"] = 183.74, ["Neon"] = 196.09, ["Neon|Ride"] = 182.85, ["Mega"] = 312.38, ["Mega|Fly"] = 791.96, ["Mega|Fly|Ride"] = 1047.39}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 36.75, ["Fly"] = 262.5, ["Ride"] = 279.66, ["Fly|Ride"] = 170.63, ["Neon"] = 209.49, ["Neon|Ride"] = 270.21, ["Mega"] = 978.27, ["Mega|Ride"] = 837.92, ["Mega|Fly|Ride"] = 837.92}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 156.69, ["Ride"] = 213.94, ["Fly|Ride"] = 261.19, ["Neon"] = 753.63, ["Neon|Ride"] = 820.21, ["Neon|Fly|Ride"] = 982.66, ["Mega|Fly|Ride"] = 3379.92}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 17.99, ["Fly|Ride"] = 140.37, ["Neon"] = 91.87, ["Mega"] = 287.44, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 8.76, ["Fly|Ride"] = 181.39, ["Neon"] = 418.97, ["Neon|Fly"] = 159.1, ["Neon|Ride"] = 199.46, ["Mega"] = 791.96, ["Mega|Ride"] = 837.92, ["Mega|Fly|Ride"] = 978.27}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 948.32, ["Fly"] = 1050, ["Ride"] = 1049.99, ["Fly|Ride"] = 1240.32, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 4814.37, ["Mega|Fly|Ride"] = 18574.31}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 6.5, ["Fly"] = 19.68, ["Ride"] = 19.81, ["Fly|Ride"] = 92.57, ["Neon"] = 50.13, ["Neon|Fly"] = 102.9, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 209.49, ["Mega"] = 222.05, ["Mega|Fly|Ride"] = 418.97}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 6.56, ["Fly"] = 51.19, ["Ride"] = 26.25, ["Fly|Ride"] = 135.19, ["Neon"] = 34.2, ["Neon|Ride"] = 66.01, ["Mega"] = 203.21, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 254.44}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 82.76, ["Ride"] = 25.34, ["Fly|Ride"] = 93.83, ["Neon"] = 10.5, ["Neon|Ride"] = 47.16, ["Mega"] = 112.09, ["Mega|Ride"] = 240.62, ["Mega|Fly|Ride"] = 969.9}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 11.69, ["Ride"] = 28.98, ["Fly|Ride"] = 82.74, ["Neon"] = 77.41, ["Neon|Fly"] = 143.83, ["Neon|Ride"] = 79.44, ["Neon|Fly|Ride"] = 196.27, ["Mega"] = 437.07, ["Mega|Ride"] = 427.49, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 3.94, ["Fly"] = 20.45, ["Ride"] = 20.55, ["Fly|Ride"] = 51.19, ["Neon"] = 52.5, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 59.37, ["Mega|Fly"] = 251.39, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 15.93, ["Neon"] = 12.31, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 53.44, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 179.32, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 350.44}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 474.67, ["Ride"] = 292.24, ["Fly|Ride"] = 2094.78, ["Neon|Fly|Ride"] = 984.38}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 23.06, ["Fly|Ride"] = 72.19, ["Neon"] = 8.39, ["Neon|Fly"] = 83.83, ["Neon|Ride"] = 32.13, ["Neon|Fly|Ride"] = 119.86, ["Mega"] = 138.27, ["Mega|Fly"] = 418.97, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 271.28}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 2.63, ["Ride"] = 81.79, ["Fly|Ride"] = 88.87, ["Neon"] = 36.67, ["Neon|Ride"] = 251.43, ["Mega"] = 125.7, ["Mega|Ride"] = 237.47}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.1, ["Fly"] = 98.01, ["Ride"] = 21, ["Neon"] = 20.87, ["Neon|Ride"] = 52.49, ["Mega"] = 99.74, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 505.29}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 321.57, ["Neon"] = 1466.35, ["Neon|Ride"] = 1312.5, ["Mega|Ride"] = 4189.55, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 23.34, ["Ride"] = 47.48, ["Fly|Ride"] = 223.12, ["Neon"] = 149.5, ["Neon|Ride"] = 163.46, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 498.75, ["Mega|Ride"] = 886.95, ["Mega|Fly|Ride"] = 859.69}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 14.77, ["Fly"] = 83.81, ["Ride"] = 32.37, ["Fly|Ride"] = 90.57, ["Neon"] = 112.88, ["Neon|Ride"] = 124.67, ["Neon|Fly|Ride"] = 242.63, ["Mega"] = 432.16, ["Mega|Ride"] = 435.2, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 4.92, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 210, ["Mega"] = 59.07, ["Mega|Ride"] = 188.55, ["Mega|Fly|Ride"] = 249.3}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 50.89, ["Fly"] = 140.37, ["Ride"] = 75.6, ["Fly|Ride"] = 167.6, ["Neon"] = 262.48, ["Neon|Fly"] = 301.88, ["Neon|Ride"] = 264.64, ["Neon|Fly|Ride"] = 401.48, ["Mega|Fly|Ride"] = 1187.74}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.49, ["Fly|Ride"] = 35.36, ["Neon"] = 6.57, ["Neon|Ride"] = 56.58, ["Neon|Fly|Ride"] = 124.67, ["Mega"] = 58.9, ["Mega|Fly|Ride"] = 418.97}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 18.69, ["Fly"] = 126.98, ["Ride"] = 17.82, ["Fly|Ride"] = 85.46, ["Neon"] = 66.2, ["Neon|Ride"] = 125.15, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 279.66, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 418.97, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 34.17, ["Fly"] = 110.99, ["Ride"] = 81.63, ["Fly|Ride"] = 145.68, ["Neon"] = 183.75, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 419.03, ["Mega|Ride"] = 1956.52, ["Mega|Fly|Ride"] = 1169.43}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.05, ["Fly|Ride"] = 35.43, ["Neon"] = 2.1, ["Neon|Fly"] = 23.98, ["Neon|Ride"] = 16.8, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 18.47, ["Mega|Fly"] = 118.74, ["Mega|Ride"] = 31.06, ["Mega|Fly|Ride"] = 86.63}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.62, ["Ride"] = 52.5, ["Fly|Ride"] = 131.25, ["Neon"] = 16.98, ["Neon|Ride"] = 56.58, ["Neon|Fly|Ride"] = 419.03, ["Mega"] = 231.49, ["Mega|Ride"] = 277.86, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 10.81, ["Ride"] = 51.75, ["Fly|Ride"] = 140.37, ["Neon"] = 111.55, ["Neon|Ride"] = 559.38, ["Mega"] = 536.82, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 20.76, ["Neon"] = 2.1, ["Neon|Ride"] = 28.86, ["Neon|Fly|Ride"] = 95.8, ["Mega"] = 16.64, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 417.95}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 12.28, ["Fly"] = 210, ["Ride"] = 63.57, ["Fly|Ride"] = 179.82, ["Neon"] = 52.5, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 417.98, ["Mega"] = 537.8, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 471.35, ["Mega|Fly|Ride"] = 715.64}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 6.57, ["Fly"] = 41.91, ["Ride"] = 26.48, ["Fly|Ride"] = 98.44, ["Neon"] = 388.53, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 129.94, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 2.1, ["Ride"] = 18.86, ["Neon"] = 31.29, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 71.36, ["Neon|Fly|Ride"] = 130.19, ["Mega"] = 233.62, ["Mega|Ride"] = 242.82, ["Mega|Fly|Ride"] = 413.74}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 10.34, ["Fly"] = 2094.78, ["Ride"] = 83.99, ["Fly|Ride"] = 238.64, ["Neon"] = 54.06, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 6331.37, ["Mega"] = 335.18, ["Mega|Ride"] = 442.32, ["Mega|Fly|Ride"] = 941.61}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 17.75, ["Fly|Ride"] = 196.88, ["Neon"] = 6.57, ["Neon|Ride"] = 32.43, ["Mega"] = 74.81, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 155.03, ["Mega|Fly|Ride"] = 279.66}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 55.53, ["Neon"] = 3.72, ["Neon|Ride"] = 45.86, ["Mega"] = 28.88, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 243.95}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 19.28}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 36.11, ["Fly"] = 78.75, ["Ride"] = 37.8, ["Neon"] = 236.55, ["Neon|Ride"] = 277.33, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 1675.83, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.15, ["Neon|Ride"] = 28.12, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 20.96, ["Mega|Ride"] = 119.6, ["Mega|Fly|Ride"] = 300.57}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 446.25, ["Fly"] = 498.75, ["Ride"] = 559.32, ["Fly|Ride"] = 787.5, ["Neon"] = 2793.39, ["Neon|Fly|Ride"] = 2273.82, ["Mega"] = 16758.14, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 3.84, ["Fly"] = 26.24, ["Ride"] = 24.7, ["Fly|Ride"] = 66.26, ["Neon"] = 31.84, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 95.85, ["Mega|Ride"] = 144.37, ["Mega|Fly|Ride"] = 559.32}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 20.9, ["Fly|Ride"] = 69.34, ["Neon"] = 28.29, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 125.72, ["Mega"] = 150.81, ["Mega|Ride"] = 255.21, ["Mega|Fly|Ride"] = 237.01}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 15.54, ["Fly"] = 70.19, ["Ride"] = 50.3, ["Fly|Ride"] = 106.32, ["Neon"] = 102.78, ["Neon|Ride"] = 170.77, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 821.17, ["Mega|Ride"] = 587.75}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.1, ["Ride"] = 28.28, ["Fly|Ride"] = 721.88, ["Neon"] = 17.22, ["Neon|Ride"] = 118.13, ["Mega"] = 262.5}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 9.59, ["Fly"] = 139.53, ["Ride"] = 42, ["Fly|Ride"] = 173.23, ["Neon"] = 138.29, ["Neon|Ride"] = 236.24, ["Mega"] = 418.97, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 489.04}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 4.12, ["Ride"] = 140.37, ["Fly|Ride"] = 133.88, ["Neon"] = 33.01, ["Neon|Ride"] = 77.12, ["Neon|Fly|Ride"] = 247.24, ["Mega"] = 393.75, ["Mega|Fly"] = 559.32, ["Mega|Ride"] = 350.28, ["Mega|Fly|Ride"] = 373.79}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 47.48, ["Ride"] = 13.54, ["Fly|Ride"] = 69.2, ["Neon"] = 2.1, ["Neon|Fly"] = 59.72, ["Neon|Ride"] = 15.38, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 15.66, ["Mega|Ride"] = 24.94}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 4.55, ["Fly"] = 53.43, ["Ride"] = 32.7, ["Fly|Ride"] = 104.75, ["Neon"] = 38.48, ["Neon|Fly"] = 118.73, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 224.18, ["Mega"] = 196.85, ["Mega|Ride"] = 217.87}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 294.96, ["Fly"] = 415.33, ["Ride"] = 298.76, ["Neon"] = 1312.5, ["Neon|Ride"] = 1263.94, ["Neon|Fly|Ride"] = 1252.12, ["Mega|Ride"] = 9213.68, ["Mega|Fly|Ride"] = 4888.15}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 81.37, ["Ride"] = 140.37, ["Fly|Ride"] = 7680.47, ["Neon"] = 544.71, ["Neon|Ride"] = 638.99, ["Neon|Fly|Ride"] = 544.65, ["Mega"] = 2235.13, ["Mega|Ride"] = 1837.5, ["Mega|Fly|Ride"] = 2073.83}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 16.84, ["Ride"] = 15.32, ["Fly|Ride"] = 41.91, ["Neon"] = 8.39, ["Neon|Fly"] = 69.53, ["Neon|Ride"] = 32.07, ["Neon|Fly|Ride"] = 63.31, ["Mega|Fly"] = 208.45, ["Mega|Ride"] = 159.12, ["Mega|Fly|Ride"] = 258.58}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 24.94, ["Ride"] = 14.44, ["Fly|Ride"] = 32.8, ["Neon"] = 10.49, ["Neon|Fly"] = 41.77, ["Neon|Ride"] = 19.43, ["Neon|Fly|Ride"] = 43.64, ["Mega"] = 65.63, ["Mega|Fly"] = 349.84, ["Mega|Ride"] = 108.94, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 45.94, ["Mega"] = 272.33, ["Mega|Ride"] = 418.97}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 236.5, ["Fly"] = 420, ["Ride"] = 253.32, ["Fly|Ride"] = 367.5, ["Neon|Ride"] = 1064.28, ["Neon|Fly|Ride"] = 1550.33, ["Mega|Ride"] = 8379.08, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 21.54, ["Ride"] = 15.09, ["Fly|Ride"] = 33.35, ["Neon"] = 18.38, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 39.25, ["Neon|Fly|Ride"] = 98.48, ["Mega"] = 255.94, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 366.59}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 6.03, ["Ride"] = 98.44, ["Fly|Ride"] = 209.49, ["Neon"] = 56.57, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 279.7, ["Mega"] = 299.25, ["Mega|Ride"] = 300.55, ["Mega|Fly|Ride"] = 413.22}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 28.13, ["Neon"] = 5.93, ["Neon|Ride"] = 155.81, ["Mega"] = 84.96, ["Mega|Ride"] = 207.38}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 12.79, ["Fly"] = 22.23, ["Ride"] = 19.56, ["Fly|Ride"] = 101.75, ["Neon"] = 80.75, ["Neon|Ride"] = 93.09, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 614.83, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 590.62}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 39.38, ["Fly"] = 112.09, ["Ride"] = 102.81, ["Fly|Ride"] = 296.94, ["Neon"] = 159.83, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 224.18, ["Neon|Fly|Ride"] = 363.5, ["Mega"] = 430.42, ["Mega|Fly"] = 2199.52, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 528.94}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 21, ["Ride"] = 43.32, ["Fly|Ride"] = 91.88, ["Neon"] = 138.72, ["Neon|Ride"] = 224.18, ["Neon|Fly|Ride"] = 300.36, ["Mega|Ride"] = 840.16, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 20.86, ["Ride"] = 14.93, ["Fly|Ride"] = 42.33, ["Neon"] = 2.1, ["Neon|Fly"] = 17.64, ["Neon|Ride"] = 15.32, ["Neon|Fly|Ride"] = 47.16, ["Mega"] = 17.26, ["Mega|Fly"] = 418.97, ["Mega|Ride"] = 40.39, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 207.36, ["Ride"] = 259.88, ["Fly|Ride"] = 384.53, ["Neon"] = 2020.77, ["Neon|Fly|Ride"] = 1246.54, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 8.39, ["Fly"] = 101.18, ["Ride"] = 42.37, ["Fly|Ride"] = 105, ["Neon"] = 144.38, ["Neon|Ride"] = 218.46, ["Neon|Fly|Ride"] = 328.12, ["Mega"] = 479.72, ["Mega|Ride"] = 712.41, ["Mega|Fly|Ride"] = 791.96}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 34, ["Ride"] = 17.07, ["Fly|Ride"] = 45.11, ["Neon"] = 4.2, ["Neon|Fly"] = 36.42, ["Neon|Ride"] = 27.35, ["Neon|Fly|Ride"] = 111.05, ["Mega"] = 60.76, ["Mega|Fly"] = 279.66, ["Mega|Ride"] = 72.98, ["Mega|Fly|Ride"] = 211.78}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 31.44, ["Ride"] = 15.65, ["Fly|Ride"] = 43.28, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 28.3, ["Neon|Fly|Ride"] = 115.96, ["Mega"] = 25.34, ["Mega|Fly"] = 140.37, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 183.3}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 28.74, ["Fly|Ride"] = 69.29, ["Neon"] = 8.77, ["Neon|Fly"] = 712.34, ["Neon|Ride"] = 71.25, ["Mega"] = 103.68, ["Mega|Ride"] = 194.09, ["Mega|Fly|Ride"] = 379.96}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 5.9, ["Fly"] = 38.74, ["Ride"] = 24.94, ["Fly|Ride"] = 59.07, ["Neon"] = 47.15, ["Neon|Fly"] = 266.09, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 355.69, ["Mega|Ride"] = 236.23, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 5.19, ["Ride"] = 55.13, ["Fly|Ride"] = 72.19, ["Neon"] = 63, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 275.63, ["Mega|Ride"] = 317.03, ["Mega|Fly|Ride"] = 418.97}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 43.32, ["Neon"] = 3.81, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 100.37, ["Mega"] = 32.01, ["Mega|Ride"] = 71.87, ["Mega|Fly|Ride"] = 107.63}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 8.76, ["Ride"] = 25.15, ["Fly|Ride"] = 131.25, ["Neon"] = 32.55, ["Neon|Fly"] = 137.36, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 106.86, ["Mega"] = 233.94, ["Mega|Ride"] = 200.81, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 83.81, ["Neon"] = 3.4, ["Neon|Fly"] = 112.1, ["Neon|Ride"] = 45.77, ["Neon|Fly|Ride"] = 159.1, ["Mega"] = 36.67, ["Mega|Ride"] = 91.34, ["Mega|Fly|Ride"] = 140.37}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 42.74, ["Ride"] = 16.95, ["Fly|Ride"] = 39.38, ["Neon"] = 3.51, ["Neon|Ride"] = 20.88, ["Neon|Fly|Ride"] = 120.59, ["Mega"] = 52.41, ["Mega|Ride"] = 84.56, ["Mega|Fly|Ride"] = 213.68}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 754.85, ["Ride"] = 579.6, ["Fly|Ride"] = 825.59, ["Neon|Fly|Ride"] = 3476.82, ["Mega|Fly|Ride"] = 12571.04}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 19.22, ["Ride"] = 13.92, ["Fly|Ride"] = 31.28, ["Neon"] = 18.25, ["Neon|Fly"] = 140.38, ["Neon|Ride"] = 27.88, ["Neon|Fly|Ride"] = 59.07, ["Mega|Fly|Ride"] = 349.84}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 41.79, ["Fly|Ride"] = 279.66, ["Neon"] = 10.47, ["Neon|Fly"] = 733.27, ["Neon|Ride"] = 88.55, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 52.5, ["Mega|Ride"] = 133.25, ["Mega|Fly|Ride"] = 237.2}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 4.2, ["Fly"] = 47.16, ["Ride"] = 19.84, ["Fly|Ride"] = 48.64, ["Neon"] = 50.6, ["Neon|Fly"] = 189.38, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 92.26, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 372.92}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 24.95, ["Ride"] = 15.23, ["Fly|Ride"] = 53.43, ["Neon"] = 6.57, ["Neon|Fly"] = 137.13, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 68.52, ["Mega"] = 65.51, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 177.09}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 35.95, ["Ride"] = 84.17, ["Fly|Ride"] = 279.66, ["Neon"] = 220.5, ["Neon|Ride"] = 268.33, ["Mega"] = 961.42}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 24.11, ["Fly|Ride"] = 64.16, ["Neon"] = 5.97, ["Neon|Fly"] = 141.75, ["Neon|Ride"] = 30.42, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 46.71, ["Mega|Ride"] = 119.59, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 3.89, ["Fly"] = 126.98, ["Ride"] = 19.86, ["Fly|Ride"] = 58.67, ["Neon"] = 8.93, ["Neon|Ride"] = 41.89, ["Neon|Fly|Ride"] = 112.1, ["Mega"] = 114.19, ["Mega|Ride"] = 198.59, ["Mega|Fly|Ride"] = 479.51}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly|Ride"] = 59.07, ["Neon"] = 36.82, ["Mega"] = 93.5, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 376.69}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 15.78, ["Fly|Ride"] = 49.86, ["Neon"] = 3.94, ["Neon|Ride"] = 24.36, ["Neon|Fly|Ride"] = 99.42, ["Mega"] = 43.32, ["Mega|Fly"] = 229.68, ["Mega|Ride"] = 62.91}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 10.88, ["Fly"] = 18.8, ["Ride"] = 17.82, ["Fly|Ride"] = 34.11, ["Neon"] = 315.29, ["Neon|Ride"] = 70.2, ["Neon|Fly|Ride"] = 98.43, ["Mega|Ride"] = 418.97}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 708.65, ["Ride"] = 757.32, ["Fly|Ride"] = 931.88, ["Neon"] = 2058.62, ["Neon|Ride"] = 1947.77, ["Neon|Fly|Ride"] = 2163, ["Mega"] = 8379.08, ["Mega|Fly|Ride"] = 7598.92}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 18.35, ["Ride"] = 17.84, ["Fly|Ride"] = 33.79, ["Neon"] = 3.94, ["Neon|Ride"] = 16.87, ["Neon|Fly|Ride"] = 51.98, ["Mega"] = 39.38, ["Mega|Ride"] = 59.76, ["Mega|Fly|Ride"] = 136.43}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 4.31, ["Ride"] = 36.74, ["Neon"] = 39.38, ["Neon|Fly"] = 71.25, ["Neon|Ride"] = 112.51, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 392.44, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 489.15}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 45.85, ["Ride"] = 59.01, ["Fly|Ride"] = 113.28, ["Neon|Ride"] = 389.82, ["Neon|Fly|Ride"] = 498.75, ["Mega"] = 3209.18, ["Mega|Fly|Ride"] = 2786.05}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 36.66, ["Ride"] = 31.5, ["Fly|Ride"] = 96.76, ["Neon"] = 183.75, ["Neon|Ride"] = 217.9, ["Neon|Fly|Ride"] = 309.03, ["Mega"] = 978.27, ["Mega|Ride"] = 896.44, ["Mega|Fly|Ride"] = 816.38}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 9.4, ["Ride"] = 26.23, ["Fly|Ride"] = 139.71, ["Neon"] = 62.86, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 121.28, ["Mega"] = 285.87, ["Mega|Fly|Ride"] = 556.17}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 25.95, ["Ride"] = 64.95, ["Neon"] = 125.72, ["Neon|Ride"] = 364.48, ["Mega"] = 391.74, ["Mega|Fly"] = 515.31, ["Mega|Ride"] = 350.28, ["Mega|Fly|Ride"] = 559.32}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 20.9, ["Fly"] = 126.89, ["Neon"] = 420, ["Neon|Ride"] = 317.01, ["Neon|Fly|Ride"] = 525, ["Mega"] = 924, ["Mega|Fly|Ride"] = 830.82}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 15.75}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 3.84, ["Ride"] = 17.14, ["Fly|Ride"] = 85.32, ["Neon"] = 31.5, ["Neon|Ride"] = 70.06, ["Neon|Fly|Ride"] = 182.28, ["Mega"] = 190.32, ["Mega|Fly"] = 463.87, ["Mega|Ride"] = 217.87, ["Mega|Fly|Ride"] = 289.71}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.1, ["Ride"] = 46.85, ["Neon"] = 11.82, ["Neon|Fly|Ride"] = 209.52, ["Mega"] = 140.37}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 33.92, ["Fly"] = 60.38, ["Ride"] = 49.24, ["Fly|Ride"] = 99.45, ["Neon"] = 262.5, ["Neon|Ride"] = 209.52, ["Neon|Fly|Ride"] = 947.7, ["Mega|Ride"] = 706.19, ["Mega|Fly|Ride"] = 758.31}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 2.1, ["Fly"] = 17.7, ["Ride"] = 15.25, ["Fly|Ride"] = 38.22, ["Neon"] = 26.18, ["Neon|Fly"] = 70.2, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 182.79, ["Mega|Fly"] = 417.93, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 418.59}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 2.17, ["Fly"] = 148.75, ["Ride"] = 17.07, ["Fly|Ride"] = 55.7, ["Neon"] = 14.43, ["Neon|Ride"] = 60.77, ["Neon|Fly|Ride"] = 123.62, ["Mega"] = 131.25, ["Mega|Ride"] = 169.25, ["Mega|Fly|Ride"] = 246.81}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 7.48, ["Mega"] = 48.07, ["Mega|Ride"] = 195.88}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 24.94, ["Fly"] = 77.16, ["Ride"] = 52.5, ["Fly|Ride"] = 89.25, ["Neon"] = 944.79, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 308.12, ["Mega|Ride"] = 13965.82}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 39.36, ["Fly|Ride"] = 65.63, ["Neon"] = 6.03, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 28.3, ["Mega"] = 74.81, ["Mega|Ride"] = 118.12, ["Mega|Fly|Ride"] = 462.2}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 10.45, ["Ride"] = 79.52, ["Fly|Ride"] = 278.61, ["Neon"] = 75.43, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 502.77, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 626.35}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 14.95, ["Fly|Ride"] = 40.63, ["Neon"] = 18.78, ["Neon|Ride"] = 35.8, ["Neon|Fly|Ride"] = 75.87, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 19.2, ["Fly|Ride"] = 71.36, ["Neon"] = 26.25, ["Neon|Ride"] = 45.94, ["Mega|Ride"] = 405.36, ["Mega|Fly|Ride"] = 418.97}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 6.56, ["Ride"] = 33.53, ["Neon"] = 78.22, ["Neon|Ride"] = 157.55, ["Mega"] = 465.14, ["Mega|Ride"] = 943.78, ["Mega|Fly|Ride"] = 545.74}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 39.05, ["Fly"] = 76.67, ["Ride"] = 132.41, ["Neon"] = 216.57, ["Neon|Fly|Ride"] = 791.87, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 15.7, ["Ride"] = 278.03, ["Neon"] = 99.04, ["Neon|Ride"] = 262.5, ["Mega"] = 452.91, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 7.88, ["Ride"] = 144.38, ["Neon"] = 163.34, ["Neon|Fly"] = 209.52, ["Mega|Ride"] = 836.88}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 18.33, ["Ride"] = 105, ["Fly|Ride"] = 367.46, ["Neon"] = 103.35, ["Neon|Ride"] = 733.27, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 616.88, ["Mega|Fly"] = 2094.78, ["Mega|Fly|Ride"] = 1091.82}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.94, ["Neon"] = 13.08, ["Mega"] = 170.63, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 317.03}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 43.32, ["Ride"] = 16.4, ["Fly|Ride"] = 41.91, ["Neon"] = 2.72, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 41.56, ["Neon|Fly|Ride"] = 98.56, ["Mega"] = 52.5, ["Mega|Ride"] = 80.15, ["Mega|Fly|Ride"] = 201.12}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 2.1, ["Ride"] = 288.65, ["Fly|Ride"] = 65.62, ["Neon"] = 26.24, ["Neon|Ride"] = 41.55, ["Neon|Fly|Ride"] = 163.96, ["Mega"] = 100.4, ["Mega|Ride"] = 131.81, ["Mega|Fly|Ride"] = 261.85}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 20.96, ["Ride"] = 15.46, ["Fly|Ride"] = 56.35, ["Neon"] = 5.1, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 42.75, ["Mega|Fly"] = 167.6, ["Mega|Ride"] = 76.56, ["Mega|Fly|Ride"] = 187.21}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 65.62, ["Ride"] = 26.25, ["Fly|Ride"] = 118.13, ["Neon"] = 15.64, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 260.85, ["Mega"] = 250.09, ["Mega|Ride"] = 330.99, ["Mega|Fly|Ride"] = 474.94}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 19.69, ["Fly"] = 65.63, ["Ride"] = 19.69, ["Fly|Ride"] = 103.69, ["Neon"] = 26.15, ["Neon|Fly"] = 315, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 302.45, ["Mega|Ride"] = 287.47, ["Mega|Fly|Ride"] = 1256.88}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.49, ["Fly"] = 131.25, ["Ride"] = 21, ["Fly|Ride"] = 77.52, ["Neon"] = 17.82, ["Neon|Fly"] = 111.55, ["Neon|Ride"] = 28.41, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 259.76, ["Mega|Ride"] = 317.03, ["Mega|Fly|Ride"] = 392.41}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 3.94, ["Fly"] = 33.72, ["Ride"] = 19.19, ["Fly|Ride"] = 51.78, ["Neon"] = 33.53, ["Neon|Ride"] = 68.77, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 218.48, ["Mega|Ride"] = 209.49, ["Mega|Fly|Ride"] = 230.56}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 6.54, ["Fly"] = 57.66, ["Ride"] = 43.19, ["Fly|Ride"] = 87.93, ["Neon"] = 15.64, ["Neon|Fly"] = 436.86, ["Neon|Ride"] = 84.02, ["Neon|Fly|Ride"] = 128.44, ["Mega"] = 98.06, ["Mega|Fly"] = 176.5, ["Mega|Ride"] = 132.44, ["Mega|Fly|Ride"] = 303.76}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 25.15, ["Fly"] = 209.49, ["Ride"] = 105, ["Fly|Ride"] = 360.31, ["Neon"] = 104.99, ["Neon|Fly"] = 446.25, ["Neon|Ride"] = 313.69, ["Neon|Fly|Ride"] = 528.31, ["Mega"] = 518.47, ["Mega|Ride"] = 669.37, ["Mega|Fly|Ride"] = 735}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 41.47, ["Fly"] = 164.07, ["Ride"] = 90.58, ["Fly|Ride"] = 488.96, ["Neon"] = 269.07, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 486.76, ["Mega"] = 1535.48, ["Mega|Ride"] = 1061.82, ["Mega|Fly|Ride"] = 1221.94}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 50.96, ["Ride"] = 22.94, ["Fly|Ride"] = 65.63, ["Neon"] = 2.1, ["Neon|Ride"] = 23.73, ["Mega"] = 27.22, ["Mega|Ride"] = 71.04, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 63.95, ["Neon"] = 159.04, ["Mega|Fly|Ride"] = 1001.32}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 50.76, ["Fly"] = 105, ["Ride"] = 91.9, ["Neon"] = 417.93, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 836.98, ["Mega"] = 1716.68, ["Mega|Ride"] = 1397.22, ["Mega|Fly|Ride"] = 1885.3}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 3.56, ["Fly"] = 190.32, ["Ride"] = 54.48, ["Fly|Ride"] = 133.88, ["Neon"] = 36.63, ["Neon|Ride"] = 83.83, ["Neon|Fly|Ride"] = 210, ["Mega"] = 142.93, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 388.5}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 3.07, ["Ride"] = 62.08, ["Neon"] = 6.57, ["Neon|Ride"] = 59.07, ["Mega"] = 61.69, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 133.59, ["Mega|Fly|Ride"] = 343.65}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 21.61, ["Ride"] = 20.96, ["Fly|Ride"] = 37.79, ["Neon"] = 8.92, ["Neon|Ride"] = 40.38, ["Neon|Fly|Ride"] = 91.77, ["Mega"] = 209.49, ["Mega|Fly"] = 349.84, ["Mega|Ride"] = 208.45, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.75, ["Ride"] = 15.75, ["Fly|Ride"] = 41.56, ["Neon"] = 2.51, ["Neon|Fly"] = 17.77, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 28.88, ["Mega|Ride"] = 69.55}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 17.09, ["Fly|Ride"] = 52.41, ["Neon"] = 3.59, ["Neon|Ride"] = 27.44, ["Neon|Fly|Ride"] = 104.77, ["Mega"] = 53.42, ["Mega|Ride"] = 56.35, ["Mega|Fly|Ride"] = 177.11}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.49, ["Neon"] = 2.15, ["Neon|Ride"] = 145.08, ["Mega"] = 20.5, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 320.52}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 3.94, ["Ride"] = 104.98, ["Neon"] = 30.45, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 628.52, ["Mega"] = 237.47, ["Mega|Ride"] = 269.48, ["Mega|Fly|Ride"] = 317.03}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 5.6, ["Ride"] = 31.62, ["Fly|Ride"] = 98.47, ["Neon"] = 52.5, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 294.06, ["Mega|Ride"] = 418.97, ["Mega|Fly|Ride"] = 475.52}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 4.15, ["Fly"] = 41.1, ["Ride"] = 17.93, ["Fly|Ride"] = 37.96, ["Neon"] = 29.29, ["Neon|Ride"] = 34.91, ["Neon|Fly|Ride"] = 82.46, ["Mega|Ride"] = 349.84, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 48.17, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 446.15, ["Mega"] = 2374.66, ["Mega|Fly|Ride"] = 1560.57}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 26.17, ["Fly"] = 82.67, ["Ride"] = 31.4, ["Neon"] = 248.99, ["Neon|Fly|Ride"] = 630, ["Mega"] = 634.05}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 15.75, ["Fly|Ride"] = 35.44, ["Neon"] = 2.63, ["Neon|Fly"] = 41.92, ["Neon|Ride"] = 18.09, ["Neon|Fly|Ride"] = 62.87, ["Mega|Ride"] = 94, ["Mega|Fly|Ride"] = 188.98}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 15.23, ["Ride"] = 13.13, ["Fly|Ride"] = 27.56, ["Neon"] = 4.12, ["Neon|Fly"] = 28.87, ["Neon|Ride"] = 19.47, ["Neon|Fly|Ride"] = 46.1, ["Mega"] = 44.63, ["Mega|Fly"] = 91.14, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 114.35}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 559.32, ["Fly"] = 554.16, ["Ride"] = 534.18, ["Fly|Ride"] = 557.82, ["Neon|Ride"] = 1927.44, ["Neon|Fly|Ride"] = 1884.09}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 24.94, ["Ride"] = 56.05, ["Fly|Ride"] = 535.41, ["Neon"] = 44.1, ["Mega"] = 388.27, ["Mega|Ride"] = 685, ["Mega|Fly|Ride"] = 279302.52}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 14.78, ["Ride"] = 15.59, ["Fly|Ride"] = 27.2, ["Neon"] = 3.94, ["Neon|Fly"] = 23.77, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 36.82, ["Mega"] = 140.37, ["Mega|Ride"] = 72.35, ["Mega|Fly|Ride"] = 105.44}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 49.79, ["Ride"] = 140.37, ["Fly|Ride"] = 293.2, ["Neon"] = 261.19, ["Neon|Ride"] = 264.54, ["Neon|Fly|Ride"] = 461.96, ["Mega"] = 1424.81, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 878.36}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 37.72, ["Ride"] = 17.04, ["Fly|Ride"] = 48.47, ["Neon"] = 9.66, ["Neon|Fly"] = 61.51, ["Neon|Ride"] = 19.18, ["Neon|Fly|Ride"] = 70.85, ["Mega"] = 104.81, ["Mega|Fly"] = 209.49, ["Mega|Ride"] = 130.17, ["Mega|Fly|Ride"] = 206.07}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 69.57, ["Ride"] = 43.32, ["Neon"] = 2.1, ["Neon|Ride"] = 34, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 24.11, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 190.88}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 38.94, ["Fly"] = 113.72, ["Ride"] = 64.97, ["Fly|Ride"] = 194.76, ["Neon"] = 184.85, ["Neon|Ride"] = 191.05, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 830.82, ["Mega|Ride"] = 821.02, ["Mega|Fly|Ride"] = 1108.97}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 22.95, ["Fly|Ride"] = 52.5, ["Neon"] = 2.88, ["Neon|Ride"] = 39.99, ["Neon|Fly|Ride"] = 50.29, ["Mega"] = 48.2, ["Mega|Ride"] = 193.25, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 27.57, ["Ride"] = 69.44, ["Fly|Ride"] = 140.37, ["Neon"] = 231.49, ["Neon|Ride"] = 256.48, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 1654.88, ["Mega|Ride"] = 1675.83, ["Mega|Fly|Ride"] = 1508.25}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 2.1, ["Ride"] = 183.74, ["Neon"] = 19.66, ["Neon|Ride"] = 47.5, ["Neon|Fly|Ride"] = 155.05, ["Mega"] = 156.19, ["Mega|Ride"] = 603.75}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.37, ["Fly"] = 70.19, ["Ride"] = 72.76, ["Fly|Ride"] = 70.19, ["Neon"] = 7.07, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 117.6, ["Mega|Ride"] = 1108.97, ["Mega|Fly|Ride"] = 559.32}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 40.65, ["Ride"] = 65.62, ["Fly|Ride"] = 523.7, ["Mega"] = 2092.7, ["Mega|Ride"] = 2598.75}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 296.3, ["Ride"] = 20.94, ["Fly|Ride"] = 60.35, ["Neon"] = 5.92, ["Neon|Ride"] = 38.47, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 45.93, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 86.33, ["Mega|Fly|Ride"] = 183.64}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 15.22, ["Ride"] = 12.48, ["Fly|Ride"] = 101.82, ["Neon"] = 9.95, ["Neon|Fly"] = 47.77, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 8.38, ["Fly"] = 58.5, ["Ride"] = 22.32, ["Fly|Ride"] = 75.78, ["Neon"] = 81.78, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 150.8, ["Mega"] = 435.72, ["Mega|Ride"] = 412.02, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 70.06, ["Ride"] = 40.05, ["Fly|Ride"] = 71.51, ["Neon"] = 118.11, ["Neon|Fly"] = 140.38, ["Neon|Ride"] = 140.38, ["Neon|Fly|Ride"] = 3166.62, ["Mega"] = 916.15, ["Mega|Ride"] = 418.97, ["Mega|Fly|Ride"] = 483.77}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 19.69, ["Fly"] = 51.18, ["Ride"] = 26.25, ["Fly|Ride"] = 64.11, ["Neon"] = 120.48, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 152.95, ["Mega"] = 548.03, ["Mega|Ride"] = 298.86, ["Mega|Fly|Ride"] = 431.53}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 64.54, ["Ride"] = 118.13, ["Fly|Ride"] = 159.04, ["Neon"] = 282.99, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 721.88, ["Mega"] = 1397.22, ["Mega|Ride"] = 1481.02, ["Mega|Fly|Ride"] = 1310.4}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.82, ["Ride"] = 56.57, ["Neon"] = 26.25, ["Neon|Ride"] = 523.78, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 223.13, ["Mega|Fly|Ride"] = 523.63}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.19, ["Ride"] = 19.92, ["Fly|Ride"] = 78.74, ["Neon"] = 27.25, ["Neon|Ride"] = 83.83, ["Neon|Fly|Ride"] = 125.72, ["Mega"] = 262.5, ["Mega|Ride"] = 267.09, ["Mega|Fly|Ride"] = 317.03}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 7.86, ["Ride"] = 24.03, ["Fly|Ride"] = 109.83, ["Neon"] = 47.07, ["Neon|Ride"] = 138.05, ["Neon|Fly|Ride"] = 237.2, ["Mega"] = 461.91, ["Mega|Ride"] = 639.19}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.23, ["Ride"] = 12.71, ["Fly|Ride"] = 36.67, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 13.32, ["Neon|Fly|Ride"] = 37.68, ["Mega"] = 15.65, ["Mega|Ride"] = 25.97, ["Mega|Fly|Ride"] = 93.82}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 51.19, ["Ride"] = 85.32, ["Fly|Ride"] = 279.66, ["Neon"] = 416.72, ["Neon|Fly"] = 2374.73, ["Neon|Ride"] = 291.06, ["Neon|Fly|Ride"] = 488.15, ["Mega"] = 3142.16, ["Mega|Ride"] = 945}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 20.74, ["Fly|Ride"] = 35.63, ["Neon"] = 2.98, ["Neon|Ride"] = 27.44, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 140.37, ["Mega|Ride"] = 135.32, ["Mega|Fly|Ride"] = 415.8}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.29, ["Ride"] = 15.74, ["Fly|Ride"] = 56.12, ["Neon"] = 26.25, ["Neon|Ride"] = 33.7, ["Neon|Fly|Ride"] = 120.65, ["Mega"] = 257.25, ["Mega|Ride"] = 169.43, ["Mega|Fly|Ride"] = 236.15}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 74.06, ["Fly"] = 157.5, ["Ride"] = 131.25, ["Fly|Ride"] = 258.56, ["Neon"] = 359.63, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 1257.03, ["Mega"] = 1748.25, ["Mega|Ride"] = 1089.3, ["Mega|Fly|Ride"] = 1192.98}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 25.25, ["Neon"] = 4.81, ["Neon|Ride"] = 66.71, ["Mega"] = 63, ["Mega|Ride"] = 108.04, ["Mega|Fly|Ride"] = 234.94}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 13}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 32.03, ["Neon"] = 6.2, ["Neon|Ride"] = 50.28, ["Neon|Fly|Ride"] = 127.05, ["Mega"] = 40.94, ["Mega|Ride"] = 104.98, ["Mega|Fly|Ride"] = 217.88}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 105.46, ["Ride"] = 178.03, ["Fly|Ride"] = 301.45, ["Neon"] = 836.07, ["Neon|Ride"] = 696.91, ["Neon|Fly|Ride"] = 917.44, ["Mega"] = 3351.65, ["Mega|Ride"] = 2493.75, ["Mega|Fly|Ride"] = 2835}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2.63, ["Ride"] = 41.48, ["Neon"] = 19.57, ["Neon|Fly"] = 140.38, ["Neon|Ride"] = 65.63, ["Mega"] = 178.39, ["Mega|Ride"] = 202.86, ["Mega|Fly|Ride"] = 631.76}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 41.91, ["Neon"] = 3.72, ["Neon|Ride"] = 19.81, ["Mega"] = 32.82, ["Mega|Ride"] = 102.66, ["Mega|Fly|Ride"] = 139.71}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 8.39, ["Ride"] = 19.83, ["Neon"] = 65.63, ["Neon|Ride"] = 64.05, ["Neon|Fly|Ride"] = 159.1, ["Mega"] = 418.97, ["Mega|Ride"] = 418.97, ["Mega|Fly|Ride"] = 614.83}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 7.69, ["Fly"] = 26.25, ["Ride"] = 27.25, ["Fly|Ride"] = 55.76, ["Neon"] = 99, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 597.19, ["Mega|Ride"] = 555.19, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 17.64, ["Ride"] = 74.78, ["Neon"] = 145.68, ["Neon|Ride"] = 168.04, ["Neon|Fly|Ride"] = 1575, ["Mega"] = 560.44, ["Mega|Ride"] = 644.15, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 120.39, ["Fly"] = 277.89, ["Ride"] = 171.32, ["Fly|Ride"] = 228.38, ["Neon"] = 593.14, ["Neon|Ride"] = 590.3, ["Neon|Fly|Ride"] = 636.57, ["Mega|Fly|Ride"] = 2371.28}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 139.13, ["Ride"] = 78.75, ["Fly|Ride"] = 70.19, ["Neon"] = 471.15, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 261.19, ["Mega|Ride"] = 1047.39, ["Mega|Fly|Ride"] = 1047.39}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 131.23, ["Ride"] = 19.69, ["Fly|Ride"] = 131.24, ["Neon"] = 18.38, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 139.12, ["Mega|Ride"] = 140.32, ["Mega|Fly|Ride"] = 299.25}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 24.41, ["Fly"] = 98.44, ["Fly|Ride"] = 180.16, ["Neon"] = 64.95, ["Neon|Ride"] = 80.07, ["Mega"] = 259.88, ["Mega|Ride"] = 433.13, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 44.24, ["Fly"] = 112.09, ["Ride"] = 76.56, ["Fly|Ride"] = 224.16, ["Neon"] = 279.66, ["Neon|Ride"] = 275.51, ["Neon|Fly|Ride"] = 327.87, ["Mega"] = 1108.97, ["Mega|Ride"] = 1208.82, ["Mega|Fly|Ride"] = 1002.04}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 11.81, ["Ride"] = 83.15, ["Neon"] = 105, ["Neon|Ride"] = 556.64, ["Neon|Fly|Ride"] = 461.96, ["Mega"] = 683.71, ["Mega|Ride"] = 1932}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.39, ["Ride"] = 472.5, ["Neon|Ride"] = 3166.28}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 27.71, ["Ride"] = 34.13, ["Fly|Ride"] = 74.93, ["Neon"] = 224.26, ["Neon|Ride"] = 227.39, ["Neon|Fly|Ride"] = 317, ["Mega"] = 1034.25, ["Mega|Ride"] = 922.62, ["Mega|Fly|Ride"] = 1102.5}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 38.54, ["Ride"] = 12.39, ["Fly|Ride"] = 27.57, ["Neon"] = 2.54, ["Neon|Ride"] = 14.55, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 18.45, ["Mega|Fly"] = 111.04, ["Mega|Ride"] = 34.64, ["Mega|Fly|Ride"] = 90.56}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 3.14, ["Neon"] = 19.43, ["Neon|Ride"] = 64.19, ["Neon|Fly|Ride"] = 264, ["Mega"] = 145.76, ["Mega|Ride"] = 278.34, ["Mega|Fly|Ride"] = 417.93}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 2.1, ["Ride"] = 38.18, ["Fly|Ride"] = 60.52, ["Neon"] = 17.28, ["Neon|Fly|Ride"] = 973.72, ["Mega"] = 108.29, ["Mega|Fly"] = 498.61, ["Mega|Ride"] = 279.66, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 393.75, ["Ride"] = 439.69, ["Fly|Ride"] = 525, ["Neon"] = 1424.39, ["Neon|Ride"] = 1700.08, ["Neon|Fly|Ride"] = 1539.76, ["Mega|Fly|Ride"] = 5033.44}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 69.45, ["Ride"] = 17.07, ["Fly|Ride"] = 42, ["Neon"] = 32.06, ["Neon|Ride"] = 41.92, ["Neon|Fly|Ride"] = 86.34, ["Mega"] = 168, ["Mega|Ride"] = 279.66, ["Mega|Fly|Ride"] = 628.44}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 5.57, ["Fly"] = 22.32, ["Ride"] = 17.07, ["Fly|Ride"] = 32.82, ["Neon"] = 43.25, ["Neon|Fly"] = 156.45, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 698.62, ["Mega|Fly|Ride"] = 209.49}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 6.57, ["Fly"] = 45.05, ["Ride"] = 15.8, ["Fly|Ride"] = 78.75, ["Neon"] = 20.96, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 57, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 140.3, ["Mega|Ride"] = 272.33, ["Mega|Fly|Ride"] = 306.05}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 39.38, ["Fly"] = 42, ["Ride"] = 21.37, ["Fly|Ride"] = 62.36, ["Neon"] = 140.44, ["Neon|Ride"] = 173.39, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 1312.5, ["Mega|Ride"] = 836.88, ["Mega|Fly|Ride"] = 683.82}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 27.74, ["Fly|Ride"] = 50.3, ["Neon"] = 12.57, ["Neon|Ride"] = 48.2, ["Neon|Fly|Ride"] = 210, ["Mega"] = 162.09, ["Mega|Ride"] = 457.79}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 7.77, ["Fly"] = 787.5, ["Ride"] = 33.68, ["Fly|Ride"] = 91.88, ["Neon"] = 185.72, ["Neon|Ride"] = 210, ["Mega"] = 1675.83, ["Mega|Fly|Ride"] = 846.57}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Neon"] = 5.16, ["Neon|Ride"] = 35.1, ["Mega"] = 52.41, ["Mega|Ride"] = 110.9, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 4.87, ["Neon"] = 84}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 5.39, ["Ride"] = 140.37, ["Neon"] = 78.79, ["Neon|Ride"] = 474.9, ["Neon|Fly|Ride"] = 419.03, ["Mega"] = 837.92, ["Mega|Ride"] = 559.32, ["Mega|Fly|Ride"] = 509.25}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 7.66, ["Fly"] = 27.91, ["Ride"] = 20.58, ["Fly|Ride"] = 83.09, ["Neon"] = 52.4, ["Neon|Fly"] = 69.15, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 118.22, ["Mega"] = 588.65, ["Mega|Ride"] = 313.74, ["Mega|Fly|Ride"] = 344.9}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 320.09, ["Fly"] = 502.77, ["Ride"] = 375.37, ["Fly|Ride"] = 470.09, ["Neon"] = 1424.47, ["Neon|Ride"] = 1371.7, ["Neon|Fly|Ride"] = 1470, ["Mega|Fly|Ride"] = 3980.07}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.65, ["Fly|Ride"] = 26.25, ["Neon"] = 12.49, ["Neon|Fly"] = 79.56, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 209.49, ["Mega|Ride"] = 196.77}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.73, ["Fly"] = 112.09, ["Ride"] = 97.5, ["Fly|Ride"] = 140.37, ["Neon"] = 43.84, ["Neon|Ride"] = 154.82, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 374.57, ["Mega|Fly"] = 698.62, ["Mega|Ride"] = 389.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 25.93, ["Ride"] = 86.51, ["Fly|Ride"] = 140.37, ["Neon"] = 73.07, ["Neon|Ride"] = 133.84, ["Neon|Fly|Ride"] = 409.33, ["Mega"] = 422.62, ["Mega|Ride"] = 486.87, ["Mega|Fly|Ride"] = 538.12}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 159.03, ["Fly"] = 418.97, ["Ride"] = 107.9, ["Fly|Ride"] = 328.13, ["Neon"] = 1397.22, ["Neon|Ride"] = 1466.53, ["Neon|Fly|Ride"] = 838.03, ["Mega|Ride"] = 7714.88, ["Mega|Fly|Ride"] = 6982.92}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 52.5, ["Ride"] = 119.42, ["Fly|Ride"] = 127.74, ["Neon"] = 52.38, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 359.91, ["Mega"] = 208.47, ["Mega|Ride"] = 791.96, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 28.87, ["Ride"] = 19.58, ["Fly|Ride"] = 58.45, ["Neon"] = 12.47, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 69.47, ["Mega"] = 65.6, ["Mega|Ride"] = 144.87, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 6.72, ["Ride"] = 33.68, ["Neon"] = 25.51, ["Neon|Ride"] = 94.25, ["Neon|Fly|Ride"] = 172.81, ["Mega"] = 169.32, ["Mega|Ride"] = 160.13, ["Mega|Fly|Ride"] = 306.99}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 49.87, ["Fly"] = 196.88, ["Ride"] = 97.16, ["Fly|Ride"] = 198.81, ["Neon"] = 144.38, ["Neon|Ride"] = 157.37, ["Neon|Fly|Ride"] = 523.78, ["Mega"] = 511.88, ["Mega|Ride"] = 691.29, ["Mega|Fly|Ride"] = 542.07}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 17.82, ["Neon|Ride"] = 209.52, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 65.63, ["Mega|Ride"] = 160.42, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 23.5, ["Ride"] = 65.63, ["Neon"] = 112.3, ["Neon|Ride"] = 401.03, ["Mega"] = 502.77}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 917.44, ["Fly"] = 2094.78, ["Ride"] = 1036.88, ["Fly|Ride"] = 1086.64, ["Neon|Ride"] = 3603.46, ["Neon|Fly|Ride"] = 3221.35, ["Mega|Fly|Ride"] = 15361.98}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 19.5, ["Fly"] = 117.99, ["Ride"] = 64.1, ["Fly|Ride"] = 194.25, ["Neon"] = 78.75, ["Neon|Fly"] = 697.66, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 142.93, ["Mega"] = 471.45, ["Mega|Ride"] = 476.58, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.34, ["Ride"] = 21.16, ["Fly|Ride"] = 80.89, ["Neon"] = 13.15, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 121.53, ["Mega"] = 79.28, ["Mega|Ride"] = 111.45, ["Mega|Fly|Ride"] = 234.48}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 6.56, ["Ride"] = 47.25, ["Fly|Ride"] = 140.37, ["Neon"] = 212.64, ["Mega|Ride"] = 421.94, ["Mega|Fly|Ride"] = 924}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 19, ["Fly|Ride"] = 182.25, ["Neon"] = 2.1, ["Neon|Ride"] = 25.18, ["Neon|Fly|Ride"] = 91.66, ["Mega"] = 16.36, ["Mega|Fly"] = 125.7, ["Mega|Ride"] = 40.32, ["Mega|Fly|Ride"] = 151.05}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 59.68, ["Ride"] = 88.35, ["Fly|Ride"] = 236.25, ["Neon"] = 236.25, ["Neon|Ride"] = 377.12, ["Neon|Fly|Ride"] = 387.91, ["Mega"] = 1062.09, ["Mega|Ride"] = 914.76, ["Mega|Fly|Ride"] = 1062.87}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 7.12, ["Ride"] = 63, ["Fly|Ride"] = 47.49, ["Neon"] = 60.75, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 262.39, ["Mega"] = 682.5, ["Mega|Fly|Ride"] = 556.5}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.28, ["Ride"] = 27.09, ["Neon"] = 17.07, ["Neon|Ride"] = 45.94, ["Mega"] = 117.56, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 16.75, ["Fly"] = 52.5, ["Ride"] = 32.71, ["Fly|Ride"] = 118.7, ["Neon"] = 70.19, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 139.72, ["Mega"] = 1039.49, ["Mega|Ride"] = 461.91, ["Mega|Fly|Ride"] = 788.05}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 4.76, ["Ride"] = 30.22, ["Fly|Ride"] = 102.08, ["Neon"] = 45.01, ["Neon|Ride"] = 205.24, ["Neon|Fly|Ride"] = 315, ["Mega"] = 559.08, ["Mega|Ride"] = 518.22, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 30.18, ["Ride"] = 84, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 313.22, ["Mega"] = 2513.74, ["Mega|Ride"] = 1675.83, ["Mega|Fly|Ride"] = 1673.74}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 4.5, ["Ride"] = 45.87, ["Neon"] = 23.77, ["Neon|Ride"] = 102.67, ["Neon|Fly|Ride"] = 169.32, ["Mega"] = 97.02, ["Mega|Ride"] = 154.68, ["Mega|Fly|Ride"] = 226.31}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 3.84, ["Ride"] = 20.9, ["Fly|Ride"] = 78.75, ["Neon"] = 98.44, ["Neon|Ride"] = 70.2, ["Neon|Fly|Ride"] = 349.84, ["Mega"] = 301.67, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 559.32}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 137.82, ["Fly"] = 389.82, ["Ride"] = 139.55, ["Fly|Ride"] = 207.9, ["Neon"] = 791.58, ["Neon|Ride"] = 569.5, ["Neon|Fly|Ride"] = 643.12, ["Mega"] = 2327.07, ["Mega|Fly|Ride"] = 1945.13}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 28.39, ["Ride"] = 17.07, ["Fly|Ride"] = 37.7, ["Neon"] = 11.82, ["Neon|Fly"] = 57.53, ["Neon|Ride"] = 21.88, ["Neon|Fly|Ride"] = 68.84, ["Mega"] = 145.69, ["Mega|Ride"] = 237.47, ["Mega|Fly|Ride"] = 308.72}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 5.84, ["Fly"] = 201.42, ["Ride"] = 36.91, ["Fly|Ride"] = 91.88, ["Neon"] = 97.13, ["Neon|Ride"] = 79.52, ["Neon|Fly|Ride"] = 212.52, ["Mega"] = 417.93, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.37, ["Ride"] = 14.69, ["Fly|Ride"] = 52.41, ["Neon"] = 2.1, ["Neon|Fly"] = 26.17, ["Neon|Ride"] = 15.31, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 15.42, ["Mega|Ride"] = 28.38, ["Mega|Fly|Ride"] = 68.25}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 56.57, ["Fly|Ride"] = 39.38, ["Neon"] = 3.66, ["Neon|Ride"] = 41.92, ["Neon|Fly|Ride"] = 129.91, ["Mega"] = 18.38, ["Mega|Fly"] = 104.99, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 163.41}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.24, ["Fly"] = 35.63, ["Ride"] = 19.68, ["Fly|Ride"] = 102.95, ["Neon"] = 12.94, ["Neon|Ride"] = 83.83, ["Mega"] = 77.44, ["Mega|Ride"] = 266.04}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 26.25, ["Ride"] = 52.46, ["Fly|Ride"] = 131.25, ["Neon"] = 131.25, ["Neon|Ride"] = 335.23, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 423.01, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 678.72}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 16.86, ["Ride"] = 15.73, ["Fly|Ride"] = 30.19, ["Neon"] = 14.35, ["Neon|Fly"] = 26.16, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 54.6, ["Mega"] = 105, ["Mega|Fly"] = 170.62, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 152.25}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 7.76, ["Fly"] = 39.38, ["Ride"] = 24.44, ["Fly|Ride"] = 86.51, ["Neon"] = 21.31, ["Neon|Fly"] = 55.86, ["Neon|Ride"] = 36.88, ["Neon|Fly|Ride"] = 118, ["Mega"] = 219.24, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 216.32, ["Mega|Fly|Ride"] = 277.86}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 21.21, ["Ride"] = 17.36, ["Fly|Ride"] = 39.38, ["Neon"] = 11.73, ["Neon|Fly"] = 35.63, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 89.23, ["Mega"] = 77.52, ["Mega|Fly"] = 170.63, ["Mega|Ride"] = 204.75, ["Mega|Fly|Ride"] = 251.39}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 31.4, ["Fly"] = 169.32, ["Ride"] = 23.55, ["Fly|Ride"] = 217.19, ["Neon"] = 30.19, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 279.7, ["Mega"] = 261.82, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 376.02}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 6.35, ["Ride"] = 139.7, ["Neon"] = 39.37, ["Neon|Ride"] = 210, ["Mega"] = 656.25, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.94, ["Fly"] = 41.88, ["Ride"] = 15.75, ["Fly|Ride"] = 44.45, ["Neon"] = 21.94, ["Neon|Fly"] = 196.76, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 111.63, ["Mega"] = 255.94, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 418.28}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 23.12, ["Ride"] = 18.87, ["Fly|Ride"] = 71.24, ["Neon"] = 15.73, ["Neon|Fly"] = 47.5, ["Neon|Ride"] = 35.11, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 235.31, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 189, ["Fly"] = 393.75, ["Ride"] = 299.04, ["Fly|Ride"] = 392.43, ["Neon"] = 1119.12, ["Neon|Ride"] = 1389.05, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 4003.13}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 8.39, ["Ride"] = 114.19, ["Neon"] = 64.11, ["Mega"] = 122.07, ["Mega|Ride"] = 634.05, ["Mega|Fly|Ride"] = 489.15}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.1, ["Fly"] = 104.75, ["Ride"] = 21.77, ["Fly|Ride"] = 79.07, ["Neon"] = 23.15, ["Neon|Fly"] = 237.8, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 204.35, ["Mega|Ride"] = 326.8, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 6.56, ["Fly|Ride"] = 212.89, ["Neon"] = 52.5, ["Neon|Ride"] = 222.09, ["Neon|Fly|Ride"] = 628.52, ["Mega"] = 603.74, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 562.82}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 13.72, ["Fly|Ride"] = 28.16, ["Neon"] = 2.1, ["Neon|Fly"] = 28.87, ["Neon|Ride"] = 15.49, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 18.37, ["Mega|Fly"] = 75.43, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 16.96, ["Fly|Ride"] = 111.42, ["Neon"] = 7.82, ["Neon|Ride"] = 23.6, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 102.16, ["Mega|Ride"] = 140.44, ["Mega|Fly|Ride"] = 211.83}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.1, ["Ride"] = 140.37, ["Neon"] = 23.06, ["Neon|Ride"] = 279.7, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 87.88, ["Mega|Ride"] = 418.97, ["Mega|Fly|Ride"] = 328.12}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 82.74, ["Fly"] = 166.14, ["Ride"] = 103.65, ["Fly|Ride"] = 157.5, ["Neon"] = 556.49, ["Neon|Ride"] = 372.91, ["Neon|Fly|Ride"] = 559.38, ["Mega"] = 2094.78, ["Mega|Ride"] = 3493.04, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 2.43, ["Fly"] = 98.47, ["Ride"] = 28.88, ["Fly|Ride"] = 18038.66, ["Neon"] = 22.77, ["Neon|Ride"] = 59.83, ["Neon|Fly|Ride"] = 419.03, ["Mega"] = 213.68, ["Mega|Ride"] = 269.54, ["Mega|Fly|Ride"] = 564.55}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 20.99, ["Ride"] = 56.3, ["Neon"] = 23.75, ["Neon|Ride"] = 64.13, ["Neon|Fly|Ride"] = 530.6, ["Mega"] = 66.94, ["Mega|Fly"] = 314.99, ["Mega|Fly|Ride"] = 935.63}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 48.38, ["Fly"] = 210, ["Ride"] = 106.08, ["Fly|Ride"] = 180.16, ["Neon"] = 178.5, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 554.49, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 821.02}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 16.35, ["Ride"] = 12.71, ["Fly|Ride"] = 25.81, ["Neon"] = 2.1, ["Neon|Fly"] = 17.13, ["Neon|Ride"] = 17.84, ["Neon|Fly|Ride"] = 31.15, ["Mega"] = 18.18, ["Mega|Fly"] = 49.87, ["Mega|Ride"] = 35.44, ["Mega|Fly|Ride"] = 81.81}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 3.9, ["Neon|Ride"] = 70.2, ["Neon|Fly|Ride"] = 209.35, ["Mega"] = 53.43, ["Mega|Ride"] = 83.14, ["Mega|Fly|Ride"] = 175.77}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 51.61, ["Neon"] = 6.71, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 187.52, ["Mega"] = 100.33, ["Mega|Fly"] = 182.25, ["Mega|Ride"] = 116.93, ["Mega|Fly|Ride"] = 233.63}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 6.85, ["Fly"] = 55.97, ["Ride"] = 45.62, ["Fly|Ride"] = 206.06, ["Neon"] = 7.88, ["Neon|Fly"] = 91.55, ["Neon|Ride"] = 76.67, ["Neon|Fly|Ride"] = 446.15, ["Mega"] = 95.53, ["Mega|Fly"] = 224.16, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 254.51}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 12.58, ["Ride"] = 12.49, ["Fly|Ride"] = 91.34, ["Neon"] = 2.1, ["Neon|Fly"] = 24.5, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 44.01, ["Mega"] = 16.28, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 118.12}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 18.38, ["Fly"] = 131.25, ["Ride"] = 125.7, ["Neon"] = 125.72, ["Neon|Fly"] = 419.03, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 656.25, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 698.62}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2493.75, ["Ride"] = 2493.75, ["Fly|Ride"] = 2597.44, ["Neon|Ride"] = 5832.75, ["Mega|Fly|Ride"] = 36658.41}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 53, ["Ride"] = 13.01, ["Fly|Ride"] = 39.11, ["Neon"] = 8.39, ["Neon|Fly"] = 64.13, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 75.36, ["Mega|Ride"] = 98.43, ["Mega|Fly|Ride"] = 157.31}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Mega"] = 140.37, ["Mega|Fly"] = 441, ["Mega|Ride"] = 158.13, ["Mega|Fly|Ride"] = 192.31}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 23.75, ["Fly"] = 112.09, ["Ride"] = 30.35, ["Fly|Ride"] = 69.14, ["Neon"] = 69.57, ["Neon|Ride"] = 99.63, ["Neon|Fly|Ride"] = 292.37, ["Mega"] = 485.63, ["Mega|Ride"] = 398.03}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 27.03, ["Ride"] = 44.63, ["Neon"] = 77.52, ["Mega"] = 628.42, ["Mega|Ride"] = 598.07, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 150.71, ["Fly"] = 131.25, ["Ride"] = 251.39, ["Fly|Ride"] = 251.98, ["Neon"] = 1312.5, ["Neon|Ride"] = 700.41, ["Neon|Fly|Ride"] = 838.03, ["Mega"] = 6284.31, ["Mega|Fly|Ride"] = 3609.38}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 6.26, ["Ride"] = 28.88, ["Fly|Ride"] = 675.94, ["Neon"] = 15.75, ["Neon|Ride"] = 140.38, ["Mega"] = 156.19, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 309, ["Mega|Fly|Ride"] = 356.12}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Fly|Ride"] = 70.19, ["Neon"] = 18.52, ["Neon|Ride"] = 114.85, ["Mega"] = 140.44, ["Mega|Fly|Ride"] = 844.2}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Ride"] = 28.04, ["Fly|Ride"] = 131.25, ["Neon"] = 6.3, ["Neon|Ride"] = 39.38, ["Mega"] = 88.43, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 7.96, ["Ride"] = 102.66, ["Neon"] = 180.07, ["Neon|Ride"] = 177.19, ["Mega"] = 374.07, ["Mega|Ride"] = 464}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 41.91, ["Neon"] = 2.1, ["Neon|Ride"] = 28.3, ["Mega"] = 18.38, ["Mega|Ride"] = 158.85, ["Mega|Fly|Ride"] = 279.66}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 88.4, ["Fly"] = 209.49, ["Ride"] = 87.94, ["Fly|Ride"] = 314.16, ["Neon"] = 419.03, ["Neon|Ride"] = 397.05, ["Neon|Fly|Ride"] = 523.57, ["Mega|Fly|Ride"] = 2492.44}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 91.82, ["Neon"] = 10.28, ["Neon|Ride"] = 154.09, ["Neon|Fly|Ride"] = 209.52, ["Mega"] = 71.25, ["Mega|Ride"] = 278.61}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 33.1, ["Fly"] = 221.91, ["Ride"] = 73.41, ["Fly|Ride"] = 157.47, ["Neon"] = 279.66, ["Neon|Ride"] = 416.51, ["Neon|Fly|Ride"] = 532.88, ["Mega"] = 2625, ["Mega|Fly|Ride"] = 2592.19}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 32.48, ["Fly|Ride"] = 50.71, ["Neon"] = 5.13, ["Neon|Fly"] = 87.45, ["Neon|Ride"] = 38.97, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 53.43, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 177.14}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 10.49, ["Neon|Ride"] = 98.44, ["Mega"] = 72.68, ["Mega|Ride"] = 152.36, ["Mega|Fly|Ride"] = 470.82}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 6.66, ["Fly"] = 77.43, ["Ride"] = 39.38, ["Fly|Ride"] = 209.49, ["Neon"] = 67.19, ["Neon|Ride"] = 112.1, ["Mega"] = 262.5, ["Mega|Ride"] = 326.8, ["Mega|Fly|Ride"] = 559.32}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 393.75, ["Ride"] = 459.38, ["Fly|Ride"] = 522.38, ["Neon"] = 1181.24, ["Neon|Ride"] = 980.44, ["Neon|Fly|Ride"] = 1874.25, ["Mega|Ride"] = 4725, ["Mega|Fly|Ride"] = 4608.51}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 32.01, ["Fly"] = 83.81, ["Ride"] = 51.96, ["Fly|Ride"] = 99.14, ["Neon"] = 196.88, ["Neon|Ride"] = 246.88, ["Neon|Fly|Ride"] = 377.12, ["Mega|Fly|Ride"] = 1995}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 17.7, ["Fly|Ride"] = 57.75, ["Neon"] = 10.05, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 23.77, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 118.13, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 12.49, ["Fly"] = 74.81, ["Ride"] = 43.43, ["Fly|Ride"] = 177.19, ["Neon"] = 65.6, ["Neon|Fly"] = 237.45, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 182, ["Mega"] = 311.85, ["Mega|Fly"] = 977.19, ["Mega|Ride"] = 359.64, ["Mega|Fly|Ride"] = 406.87}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 4.66, ["Ride"] = 20.76, ["Fly|Ride"] = 83.81, ["Neon"] = 140.37, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 269.51, ["Mega"] = 288.75, ["Mega|Ride"] = 669.3, ["Mega|Fly|Ride"] = 412.84}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.94, ["Neon"] = 12.98, ["Mega"] = 70.87, ["Mega|Ride"] = 131.25}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 86.63, ["Ride"] = 19.69, ["Fly|Ride"] = 56.57, ["Neon"] = 39.38, ["Neon|Ride"] = 32.79, ["Neon|Fly|Ride"] = 274.46, ["Mega"] = 554.49, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 107.9, ["Ride"] = 117.81, ["Fly|Ride"] = 236.25, ["Neon"] = 1028.93, ["Neon|Ride"] = 523.67, ["Neon|Fly|Ride"] = 568.51, ["Mega"] = 2887.5, ["Mega|Fly|Ride"] = 2849.6}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 27.34, ["Ride"] = 75.43, ["Fly|Ride"] = 91.88, ["Neon"] = 142.95, ["Neon|Ride"] = 199.04, ["Neon|Fly|Ride"] = 389.73, ["Mega"] = 1047.39, ["Mega|Ride"] = 698.62, ["Mega|Fly|Ride"] = 837.92}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 1995, ["Fly"] = 2008.13, ["Ride"] = 2100, ["Fly|Ride"] = 2163, ["Neon"] = 11172.46, ["Neon|Fly|Ride"] = 6424.69, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.93, ["Fly"] = 65625, ["Ride"] = 118.7, ["Fly|Ride"] = 196.87, ["Neon"] = 15.92, ["Mega"] = 96.45, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 168.72, ["Mega|Fly|Ride"] = 559.32}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 7.66, ["Ride"] = 57.66, ["Neon"] = 33.6, ["Neon|Ride"] = 76.63, ["Mega"] = 189.98, ["Mega|Ride"] = 199.24, ["Mega|Fly|Ride"] = 1047.39}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 1047.81, ["Fly"] = 948.54, ["Ride"] = 879.38, ["Fly|Ride"] = 938.34, ["Neon"] = 4754.08, ["Neon|Ride"] = 2611.88, ["Neon|Fly|Ride"] = 2493.75, ["Mega"] = 12290, ["Mega|Fly|Ride"] = 11311.75}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 27.57, ["Ride"] = 52.49, ["Fly|Ride"] = 173.35, ["Neon"] = 182.25, ["Neon|Ride"] = 297.18, ["Neon|Fly|Ride"] = 375.17, ["Mega"] = 832.8, ["Mega|Ride"] = 804.56, ["Mega|Fly|Ride"] = 1675.83}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.57, ["Ride"] = 23.58, ["Fly|Ride"] = 128.15, ["Neon"] = 24.92, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 175.88, ["Mega|Ride"] = 268.98, ["Mega|Fly|Ride"] = 559.32}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.41, ["Ride"] = 140.37, ["Neon"] = 3.62, ["Neon|Ride"] = 56.02, ["Neon|Fly|Ride"] = 92.21, ["Mega"] = 23.63, ["Mega|Ride"] = 255.57, ["Mega|Fly|Ride"] = 279.66}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 90.96, ["Ride"] = 129.94, ["Fly|Ride"] = 209.49, ["Neon"] = 418.97, ["Neon|Ride"] = 593.61, ["Neon|Fly|Ride"] = 619.2, ["Mega"] = 8379.08, ["Mega|Fly|Ride"] = 5448.66}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 3.36, ["Fly|Ride"] = 73.21, ["Neon"] = 10.39, ["Neon|Ride"] = 35.63, ["Neon|Fly|Ride"] = 279.7, ["Mega"] = 159.5, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 263.82}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 74.94, ["Ride"] = 155.03, ["Neon"] = 393.75, ["Neon|Ride"] = 417.98, ["Neon|Fly|Ride"] = 514.35}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 3.46, ["Fly"] = 105, ["Neon"] = 26.22, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 189.98, ["Mega|Ride"] = 309.02, ["Mega|Fly|Ride"] = 395.07}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 227.51, ["Ride"] = 262.49, ["Fly|Ride"] = 348.78, ["Neon"] = 1438.92, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 879.27, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 19.65, ["Fly|Ride"] = 103.94, ["Neon"] = 17.82, ["Neon|Ride"] = 57.1, ["Neon|Fly|Ride"] = 100.49, ["Mega"] = 210, ["Mega|Ride"] = 279.66}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 14.02, ["Ride"] = 12.5, ["Fly|Ride"] = 35.38, ["Neon"] = 6.27, ["Neon|Fly"] = 31.39, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 51.22, ["Mega"] = 39.38, ["Mega|Fly"] = 150.84, ["Mega|Ride"] = 68.19, ["Mega|Fly|Ride"] = 315.84}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1190.99, ["Ride"] = 1050, ["Fly|Ride"] = 1422.75, ["Neon|Ride"] = 7682.47, ["Neon|Fly|Ride"] = 6075.58, ["Mega"] = 23746.56}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 5.84, ["Fly"] = 978.27, ["Ride"] = 72.19, ["Neon"] = 43.42, ["Neon|Ride"] = 132, ["Mega"] = 315, ["Mega|Ride"] = 381.27, ["Mega|Fly|Ride"] = 694.35}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 4.86, ["Fly"] = 50.29, ["Ride"] = 39.38, ["Fly|Ride"] = 79.59, ["Neon"] = 25.74, ["Neon|Fly"] = 157.99, ["Neon|Ride"] = 52.86, ["Neon|Fly|Ride"] = 209.52, ["Mega"] = 175.88, ["Mega|Ride"] = 253.49, ["Mega|Fly|Ride"] = 304.4}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 32.45, ["Fly"] = 36.29, ["Ride"] = 32.45, ["Fly|Ride"] = 74.78, ["Neon"] = 157.5, ["Neon|Ride"] = 196.86, ["Neon|Fly|Ride"] = 190.32, ["Mega|Ride"] = 1256.88, ["Mega|Fly|Ride"] = 850.5}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 11.46, ["Fly"] = 83.81, ["Ride"] = 26.45, ["Fly|Ride"] = 102.64, ["Neon"] = 52.41, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 94.99, ["Neon|Fly|Ride"] = 179.8, ["Mega"] = 367.5, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 28.87, ["Ride"] = 111.56, ["Fly|Ride"] = 408.5, ["Neon"] = 131.25, ["Neon|Ride"] = 376.69, ["Mega"] = 1050, ["Mega|Ride"] = 698.62, ["Mega|Fly|Ride"] = 583.83}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Fly|Ride"] = 79.52, ["Neon"] = 2.6, ["Neon|Fly"] = 56.58, ["Neon|Ride"] = 26.25, ["Mega"] = 13.08, ["Mega|Ride"] = 91.14, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 61.23, ["Fly"] = 123.48, ["Ride"] = 70.17, ["Fly|Ride"] = 143.25, ["Neon"] = 446.23, ["Neon|Ride"] = 393.74, ["Neon|Fly|Ride"] = 327.92, ["Mega"] = 3351.65, ["Mega|Ride"] = 1724.01, ["Mega|Fly|Ride"] = 1563.35}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 6.17, ["Fly"] = 99.18, ["Ride"] = 30.87, ["Fly|Ride"] = 127.32, ["Neon"] = 63, ["Mega"] = 773.06, ["Mega|Ride"] = 396.59}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 20.95, ["Ride"] = 15.89, ["Fly|Ride"] = 36.02, ["Neon"] = 16.38, ["Neon|Fly"] = 79.56, ["Neon|Ride"] = 66.01, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 275.06, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 3.92, ["Ride"] = 126, ["Neon"] = 16.03, ["Neon|Fly"] = 138.29, ["Neon|Fly|Ride"] = 208.46, ["Mega"] = 363.45, ["Mega|Fly|Ride"] = 474.94}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 61.41, ["Ride"] = 72.02, ["Fly|Ride"] = 262.5, ["Neon"] = 262.49, ["Neon|Ride"] = 282.19, ["Neon|Fly|Ride"] = 553.59, ["Mega"] = 1792.08, ["Mega|Ride"] = 1439.12, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 6.76, ["Neon"] = 28.29, ["Mega"] = 122.06, ["Mega|Ride"] = 118.37, ["Mega|Fly|Ride"] = 315.18}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 33.78, ["Neon"] = 2.1, ["Neon|Ride"] = 115.03, ["Mega"] = 15.88, ["Mega|Ride"] = 40.28, ["Mega|Fly|Ride"] = 520.47}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.94, ["Ride"] = 32.55, ["Fly|Ride"] = 39.41, ["Neon"] = 3.72, ["Neon|Ride"] = 28.29, ["Neon|Fly|Ride"] = 167.63, ["Mega"] = 16.72, ["Mega|Ride"] = 52.29, ["Mega|Fly|Ride"] = 123.48}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 31.24, ["Ride"] = 14.9, ["Fly|Ride"] = 49.43, ["Neon"] = 6.55, ["Neon|Ride"] = 26.83, ["Neon|Fly|Ride"] = 88.02, ["Mega"] = 61.68, ["Mega|Ride"] = 78.74, ["Mega|Fly|Ride"] = 182.27}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 39.37, ["Mega"] = 118.09, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 38.04, ["Ride"] = 17.82, ["Fly|Ride"] = 26.25, ["Neon"] = 6.57, ["Neon|Fly"] = 208.1, ["Neon|Ride"] = 24.68, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 205.31, ["Mega|Fly|Ride"] = 451.5}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 39.29, ["Ride"] = 107.63, ["Fly|Ride"] = 224.16, ["Neon"] = 196.87, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 1047.53, ["Mega"] = 961.8, ["Mega|Ride"] = 1006.79, ["Mega|Fly|Ride"] = 1108.97}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 15.53, ["Ride"] = 15.5, ["Fly|Ride"] = 35.44, ["Neon"] = 3.85, ["Neon|Fly"] = 32.8, ["Neon|Ride"] = 16.7, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 19.69, ["Mega|Ride"] = 22.42, ["Mega|Fly|Ride"] = 129.84}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 6.79, ["Fly"] = 81.33, ["Ride"] = 23.57, ["Fly|Ride"] = 57.2, ["Neon"] = 26.19, ["Neon|Fly"] = 82.91, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 144.22, ["Mega"] = 302.27, ["Mega|Fly"] = 285.06, ["Mega|Ride"] = 292.85, ["Mega|Fly|Ride"] = 824.57}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 11.07, ["Fly"] = 47.06, ["Ride"] = 27.57, ["Fly|Ride"] = 84.48, ["Neon"] = 125.42, ["Neon|Ride"] = 144.37, ["Neon|Fly|Ride"] = 210, ["Mega"] = 787.5, ["Mega|Ride"] = 628.44, ["Mega|Fly|Ride"] = 611.63}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 5.25, ["Fly"] = 196.88, ["Ride"] = 44.63, ["Neon"] = 45.94, ["Neon|Ride"] = 71.76, ["Mega"] = 366.19, ["Mega|Ride"] = 405.36, ["Mega|Fly|Ride"] = 418.97}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 28.29, ["Ride"] = 15.03, ["Fly|Ride"] = 42.84, ["Neon"] = 3.49, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 17.74, ["Neon|Fly|Ride"] = 66.89, ["Mega"] = 44.63, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 140.37, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 2.71, ["Fly"] = 77.52, ["Ride"] = 38.07, ["Neon"] = 21.95, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 112.1, ["Mega"] = 209.49, ["Mega|Fly"] = 735, ["Mega|Ride"] = 224.16, ["Mega|Fly|Ride"] = 391.74}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 928.91, ["Fly"] = 1345.64, ["Ride"] = 1084.91, ["Fly|Ride"] = 987.93, ["Neon"] = 2905.46, ["Neon|Ride"] = 2231.25, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 7086.19}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 98.47, ["Ride"] = 166.55, ["Fly|Ride"] = 354.38, ["Neon"] = 599.82, ["Neon|Ride"] = 569.63, ["Neon|Fly|Ride"] = 740.25, ["Mega"] = 6284.31, ["Mega|Ride"] = 2654.08, ["Mega|Fly|Ride"] = 2347.02}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly"] = 56.57, ["Neon"] = 6.03, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 209.52, ["Mega"] = 71.25, ["Mega|Fly|Ride"] = 1117.57}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 69.44, ["Ride"] = 129.92, ["Fly|Ride"] = 196.88, ["Neon"] = 392.42, ["Neon|Ride"] = 367.49, ["Neon|Fly|Ride"] = 629.99, ["Mega"] = 1836.19, ["Mega|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.1, ["Ride"] = 19.52, ["Fly|Ride"] = 91.14, ["Neon"] = 18.8, ["Neon|Fly"] = 55.81, ["Neon|Ride"] = 48.77, ["Neon|Fly|Ride"] = 279.66, ["Mega"] = 274.02, ["Mega|Ride"] = 313.15, ["Mega|Fly|Ride"] = 405.36}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 314.23, ["Fly"] = 335.18, ["Ride"] = 295.21, ["Fly|Ride"] = 328.12, ["Neon|Ride"] = 1327.2, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 4528.13}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 76.4, ["Ride"] = 40.86, ["Fly|Ride"] = 219.57, ["Neon"] = 5.25, ["Neon|Fly"] = 35.63, ["Neon|Ride"] = 54.37, ["Mega"] = 412.29, ["Mega|Fly"] = 326.8, ["Mega|Ride"] = 634.05}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 28.29, ["Mega"] = 335.18, ["Mega|Ride"] = 359.26}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 27.2, ["Ride"] = 52.45, ["Fly|Ride"] = 91.88, ["Neon"] = 155.03, ["Neon|Ride"] = 124.59, ["Mega"] = 1095.04, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.73, ["Neon"] = 24.94, ["Neon|Ride"] = 141.91, ["Mega"] = 237.47, ["Mega|Ride"] = 253.3}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 16.77, ["Ride"] = 13, ["Fly|Ride"] = 39.35, ["Neon"] = 2.1, ["Neon|Fly"] = 23.63, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 37.54, ["Mega"] = 23.62, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 80.63}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4593.75, ["Ride"] = 5130.57, ["Fly|Ride"] = 4593.75, ["Neon"] = 31421.51, ["Neon|Fly|Ride"] = 19293.75, ["Mega|Fly|Ride"] = 130922.9}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 18.78, ["Fly"] = 83.81, ["Ride"] = 41.57, ["Neon"] = 52.5, ["Neon|Ride"] = 105, ["Mega"] = 278.61, ["Mega|Ride"] = 308.74, ["Mega|Fly|Ride"] = 418.97}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.69, ["Ride"] = 18.8, ["Fly|Ride"] = 35.41, ["Neon"] = 12.84, ["Neon|Fly"] = 45.91, ["Neon|Ride"] = 34.18, ["Neon|Fly|Ride"] = 75.54, ["Mega"] = 144.38, ["Mega|Ride"] = 188.74, ["Mega|Fly|Ride"] = 239.75}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 415.61, ["Fly"] = 547.77, ["Ride"] = 534.19, ["Fly|Ride"] = 506.51, ["Neon"] = 2099.99, ["Neon|Ride"] = 1519.44, ["Neon|Fly|Ride"] = 1744.43, ["Mega|Fly|Ride"] = 6005.72}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 2.1, ["Ride"] = 32.62, ["Neon"] = 22.31, ["Neon|Ride"] = 145.69, ["Mega"] = 187.85, ["Mega|Ride"] = 209.49, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.41, ["Fly"] = 4189.55, ["Ride"] = 47.2, ["Neon"] = 27.25, ["Neon|Ride"] = 64.13, ["Neon|Fly|Ride"] = 284.94, ["Mega"] = 416.88, ["Mega|Ride"] = 401.63, ["Mega|Fly|Ride"] = 279.66}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Ride"] = 20.36, ["Neon"] = 3.7, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 23, ["Neon|Fly|Ride"] = 91.74, ["Mega"] = 37.8, ["Mega|Ride"] = 78.08, ["Mega|Fly|Ride"] = 279.66}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 837.92, ["Ride"] = 1050, ["Fly|Ride"] = 753.27, ["Neon|Ride"] = 3248.44, ["Neon|Fly|Ride"] = 2455.71}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.42, ["Ride"] = 73.36, ["Fly|Ride"] = 418.97, ["Neon"] = 36.29, ["Neon|Ride"] = 73.34, ["Neon|Fly|Ride"] = 284.94, ["Mega"] = 168.91, ["Mega|Ride"] = 229.03, ["Mega|Fly|Ride"] = 372.86}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 3.85, ["Fly"] = 236.15, ["Ride"] = 30.19, ["Neon"] = 19.69, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 219.99, ["Mega"] = 170.63, ["Mega|Fly"] = 791.96, ["Mega|Ride"] = 229.74, ["Mega|Fly|Ride"] = 265.13}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.11, ["Ride"] = 16.69, ["Neon"] = 16.22, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 31.17, ["Neon|Fly|Ride"] = 74.82, ["Mega"] = 279.66, ["Mega|Fly|Ride"] = 217.25}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 26.17, ["Ride"] = 38.07, ["Fly|Ride"] = 56.57, ["Neon"] = 117.58, ["Neon|Fly|Ride"] = 314.27, ["Mega"] = 559.32, ["Mega|Ride"] = 452.81, ["Mega|Fly|Ride"] = 837.92}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Fly|Ride"] = 83.81, ["Neon"] = 7.35, ["Neon|Ride"] = 42.84, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 53.43, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 586.02, ["Ride"] = 538.12, ["Fly|Ride"] = 698.62, ["Neon"] = 2589.57, ["Neon|Fly|Ride"] = 2367.46, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Fly"] = 104.75, ["Ride"] = 76.75, ["Neon"] = 16.78, ["Neon|Fly"] = 279.7, ["Neon|Ride"] = 85.39, ["Neon|Fly|Ride"] = 474.9, ["Mega"] = 105, ["Mega|Ride"] = 190.32, ["Mega|Fly|Ride"] = 413.74}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 21, ["Neon"] = 7.88, ["Neon|Fly"] = 237.8, ["Neon|Ride"] = 36.68, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 56.44, ["Mega|Ride"] = 140.37, ["Mega|Fly|Ride"] = 354.03}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 49.44, ["Neon"] = 4.15, ["Neon|Ride"] = 45.02, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 102.53, ["Mega|Fly"] = 155.03, ["Mega|Ride"] = 100.96, ["Mega|Fly|Ride"] = 145.68}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 34.69, ["Neon"] = 17.73, ["Mega"] = 209.49, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 56.57, ["Fly"] = 98.44, ["Ride"] = 118.02, ["Fly|Ride"] = 279.66, ["Neon"] = 129.94, ["Neon|Ride"] = 137.22, ["Neon|Fly|Ride"] = 334.68, ["Mega"] = 791.84, ["Mega|Ride"] = 740.52, ["Mega|Fly|Ride"] = 937.42}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 13.12, ["Ride"] = 48.39, ["Fly|Ride"] = 128.99, ["Neon"] = 62.91, ["Neon|Ride"] = 141.91, ["Neon|Fly|Ride"] = 277.93, ["Mega"] = 477.23, ["Mega|Fly"] = 559.32, ["Mega|Ride"] = 538.43, ["Mega|Fly|Ride"] = 572.24}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 19.94, ["Ride"] = 14.87, ["Fly|Ride"] = 32.82, ["Neon"] = 28.65, ["Neon|Ride"] = 36.68, ["Neon|Fly|Ride"] = 69.42, ["Mega"] = 301.88, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 292.36}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 6.51, ["Ride"] = 102.87, ["Neon"] = 35.63, ["Neon|Ride"] = 138.29, ["Mega"] = 474.94, ["Mega|Ride"] = 418.97}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 22.52, ["Fly|Ride"] = 111.57, ["Neon"] = 9.1, ["Neon|Ride"] = 69.15, ["Neon|Fly|Ride"] = 156.73, ["Mega"] = 105, ["Mega|Ride"] = 115.49, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 14.6, ["Ride"] = 26.25, ["Fly|Ride"] = 63.8, ["Neon"] = 418.97, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 224.18, ["Mega"] = 941.61, ["Mega|Fly|Ride"] = 825.35}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 35.73, ["Fly"] = 874.13, ["Neon"] = 275.47, ["Mega"] = 451.43, ["Mega|Ride"] = 590.63}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 51.18, ["Fly"] = 115.5, ["Ride"] = 77.97, ["Fly|Ride"] = 189.9, ["Neon"] = 258.27, ["Neon|Ride"] = 313.69, ["Neon|Fly|Ride"] = 414.77, ["Mega|Ride"] = 1678.89, ["Mega|Fly|Ride"] = 1792.08}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 32.82, ["Fly"] = 83.81, ["Ride"] = 76.73, ["Fly|Ride"] = 204.26, ["Neon"] = 144.35, ["Neon|Ride"] = 234.94, ["Neon|Fly|Ride"] = 582.75, ["Mega"] = 871.52, ["Mega|Ride"] = 2026.5, ["Mega|Fly|Ride"] = 620.82}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 15.73, ["Ride"] = 57.5, ["Fly|Ride"] = 209.49, ["Neon"] = 159.04, ["Neon|Ride"] = 284.82, ["Mega"] = 1049.99, ["Mega|Ride"] = 786.83}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 11.46, ["Fly"] = 418.97, ["Ride"] = 26.25, ["Fly|Ride"] = 170.63, ["Neon"] = 127.76, ["Neon|Fly"] = 420, ["Neon|Ride"] = 139.13, ["Neon|Fly|Ride"] = 301.58, ["Mega"] = 540.58, ["Mega|Ride"] = 525.08, ["Mega|Fly|Ride"] = 636.59}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.74, ["Ride"] = 15.26, ["Fly|Ride"] = 32.74, ["Neon"] = 3.61, ["Neon|Fly"] = 28.3, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 43.67, ["Mega"] = 35.44, ["Mega|Fly"] = 329.95, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 405.36}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 866.23}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 59.07, ["Ride"] = 98.44, ["Fly|Ride"] = 1181.25, ["Neon"] = 340.96, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 389.82, ["Mega"] = 978.27, ["Mega|Ride"] = 1424.81, ["Mega|Fly|Ride"] = 1279.69}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 79.73, ["Neon"] = 3.63, ["Neon|Ride"] = 43.18, ["Neon|Fly|Ride"] = 284.94, ["Mega"] = 28.02, ["Mega|Ride"] = 84.94}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 27.82, ["Ride"] = 65.63, ["Fly|Ride"] = 169.68, ["Neon"] = 156.19, ["Neon|Ride"] = 279.7, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 712.41, ["Mega|Ride"] = 791.96, ["Mega|Fly|Ride"] = 1256.88}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Mega"] = 23.67}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.84, ["Neon|Ride"] = 39.38, ["Mega"] = 27.33, ["Mega|Ride"] = 151.41}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 91.89, ["Fly"] = 223.13, ["Ride"] = 103.69, ["Fly|Ride"] = 293.29, ["Neon"] = 262.5, ["Neon|Ride"] = 588, ["Neon|Fly|Ride"] = 590.63, ["Mega|Ride"] = 2637.32, ["Mega|Fly|Ride"] = 2001.45}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 32.48, ["Fly|Ride"] = 94.96, ["Neon"] = 9.19, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 90.17, ["Mega|Ride"] = 109.81, ["Mega|Fly|Ride"] = 281.71}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Ride"] = 65.44, ["Fly|Ride"] = 86.63, ["Neon"] = 6.03, ["Neon|Ride"] = 41.57, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 35.44, ["Mega|Ride"] = 125.7, ["Mega|Fly|Ride"] = 698.62}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 4.92, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 210, ["Mega"] = 59.07, ["Mega|Ride"] = 188.55, ["Mega|Fly|Ride"] = 249.3}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 28.13, ["Neon"] = 5.93, ["Neon|Ride"] = 155.81, ["Mega"] = 84.96, ["Mega|Ride"] = 207.38}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 52.4, ["Ride"] = 133.84, ["Fly|Ride"] = 633.74, ["Neon"] = 424.07, ["Neon|Ride"] = 460.16, ["Neon|Fly|Ride"] = 695.63, ["Mega|Ride"] = 1571.09, ["Mega|Fly|Ride"] = 1536.53}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 6.56, ["Ride"] = 33.53, ["Neon"] = 78.22, ["Neon|Ride"] = 157.55, ["Mega"] = 465.14, ["Mega|Ride"] = 943.78, ["Mega|Fly|Ride"] = 545.74}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 333.3, ["Ride"] = 391.59, ["Fly|Ride"] = 764.29, ["Neon"] = 918.75, ["Neon|Ride"] = 978.38, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4189.55}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 85.32}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 45.94}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 32.82}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 27.25}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 122.67}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 99.1}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 11.71}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 4.87}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 262.4}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 25.9}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 31.86}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 6.55}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 32.82}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 213.68}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 10.5}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 5.25}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 2.63}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 7.88}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 11.82}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 473.82}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 787.92}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 7.4}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1039.48}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 7.49}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 31.92}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.58}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.49}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 24.45}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 34.09}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 46.67}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 18.56}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 12.7}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 17.64}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.4}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 18.36}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.1}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 17.64}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 131.73}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 10.54}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 2068.49}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 43.76}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 301.88}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 6.45}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 8.98}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 4.76}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 47.07}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 185.43}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 6.04}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 10.91}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 1181.25}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 17.06}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 4.87}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 13.94}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 5.61}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 19.69}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 209.49}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 24.26}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 8.18}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 21.95}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 40.99}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 3.94}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 24.99}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 78.66}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 222.97}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 4.2}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 5.65}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 130.83}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.9}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 72.21}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 20.79}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22602.81}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 236.25}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 39.38}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 45.94}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 45.94}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 42.73}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 32.82}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 32.82}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 81.17}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 78.75}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 32.82}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 56.49}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 125.07}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 32.82}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 7017.48}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 213.93}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 6.35}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 10.49}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 7.59}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 26.17}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 116.7}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.15}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 4.41}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 3.89}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 3.94}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 8.79}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 944.98}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 12.11}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 583.68}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 13.02}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.63}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 617.06}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 24.42}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 115.31}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 21}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 20.35}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 45.75}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 11.94}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 2.52}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 7.59}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 3.81}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 5.15}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 4.13}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 28.67}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.63}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.51}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.73}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 26.04}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 263.82}},
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
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1048.48}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 9.43}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 3.94}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 5.61}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 23.46}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 13.55}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 2.63}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 8.5}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 2.1}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 7.88}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 31.91}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 11.82}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 4.29}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 3.56}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 9.26}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 7.75}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 4.76}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 4.51}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.24}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.52}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.7}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 10.5}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 8265.32}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 4.2}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 18.63}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.15}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 6.23}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 14.05}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 11.54}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 2.59}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 7.66}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 30.19}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 6.6}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.71}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 3.64}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.34}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 6.3}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4390.52}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 8.23}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 30.87}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 3.08}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.14}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 63.62}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.81}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 9.19}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 129.84}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 13}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 6.3}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.13}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 8.39}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 7.49}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 15.65}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.55}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 4.2}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 15.65}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.32}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.32}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.24}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.52}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.49}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.24}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 28.84}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 3.94}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 7.65}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 104.9}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.54}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 62.62}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 5.28}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.67}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1042}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 26.25}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 5.23}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 11.69}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 10.5}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.17}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 5.46}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 10.86}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 13.44}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 14.15}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 4.66}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.41}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 6.77}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 10.28}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 18.83}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 2.63}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 4.45}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.2}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 18.8}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 48.67}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 6.3}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 29.4}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 85.32}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 6.65}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.19}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 44.21}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 26.41}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 4.02}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 3.78}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 6.3}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 3.03}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 1.88}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 5.8}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 74.43}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 143.66}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 4.41}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1187.82}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 3.94}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 236.73}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 209.99}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 53.81}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 3.34}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.63}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.84}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 52.41}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 16.84}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 8.87}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.24}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.85}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 5.69}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 9.19}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 59.4}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 2.2}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 62.41}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 3.94}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 20.96}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 3.94}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 20.65}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 127.26}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 71.85}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 5.8}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.61}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 52.92}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 50.09}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 70.02}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 263.45}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.6}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 56.58}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 116}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.29}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 7.96}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 23.29}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 65.63}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 10.49}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 52.5}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 2.46}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 81.25}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 14.2}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 61.11}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 31.04}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 24.05}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 42.07}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 5.85}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.37}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 18.38}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.7}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 11.82}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 48.57}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 39.04}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 69.63}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1879.02}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 9.18}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 4.87}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 172.66}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 333.16}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 17.93}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 8.29}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 10.42}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 7.42}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 9.17}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 315.42}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 52.06}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 43.56}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 8.39}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 87.97}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 165.39}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 56.7}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 984.38}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 316.84}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 7.45}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2361.19}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 551.24}},
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