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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1049.9, ["Ride"] = 1154.99, ["Fly|Ride"] = 1292.82, ["Neon"] = 6774.32, ["Neon|Ride"] = 6562.5, ["Neon|Fly|Ride"] = 5841.92, ["Mega|Fly|Ride"] = 17745.72}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 459.38, ["Ride"] = 498.25, ["Fly|Ride"] = 551.25, ["Neon|Fly|Ride"] = 1967.44, ["Mega"] = 12098.73, ["Mega|Fly|Ride"] = 7052.2}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 5465.32, ["Ride"] = 5249.99, ["Fly|Ride"] = 4959.81, ["Neon|Fly|Ride"] = 21813.89, ["Mega|Fly|Ride"] = 71234.66}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 160.12, ["Ride"] = 212.52, ["Fly|Ride"] = 267, ["Neon"] = 997.8, ["Neon|Ride"] = 980.97, ["Neon|Fly|Ride"] = 984.38, ["Mega|Fly|Ride"] = 4263}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 600.99, ["Fly"] = 854.69, ["Ride"] = 586.84, ["Fly|Ride"] = 689.07, ["Neon|Fly|Ride"] = 1745.63, ["Mega|Fly|Ride"] = 6825}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 9.87, ["Ride"] = 57.68, ["Fly|Ride"] = 129.94, ["Neon"] = 71.59, ["Neon|Ride"] = 58.09, ["Neon|Fly|Ride"] = 404.25, ["Mega"] = 316.32, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 598.39}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.81, ["Fly"] = 41.4, ["Ride"] = 24.86, ["Fly|Ride"] = 61.69, ["Neon"] = 26.06, ["Neon|Fly"] = 103.68, ["Neon|Ride"] = 56.1, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 169.97, ["Mega|Ride"] = 220.5, ["Mega|Fly|Ride"] = 259.8}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 105, ["Fly"] = 213.61, ["Ride"] = 152.27, ["Fly|Ride"] = 238.81, ["Neon"] = 568.36, ["Neon|Ride"] = 641.16, ["Neon|Fly|Ride"] = 691.39, ["Mega"] = 1586.82, ["Mega|Fly|Ride"] = 2789.91}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 36.66, ["Fly"] = 62.58, ["Ride"] = 39.37, ["Fly|Ride"] = 93.86, ["Neon"] = 275.63, ["Neon|Ride"] = 242.82, ["Neon|Fly|Ride"] = 324.6, ["Mega"] = 1425.5, ["Mega|Ride"] = 1290.9, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 23.63, ["Fly"] = 84.28, ["Ride"] = 34.13, ["Fly|Ride"] = 62.91, ["Neon|Ride"] = 169.92, ["Neon|Fly|Ride"] = 199.5, ["Mega|Fly|Ride"] = 1111.27}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 54.98, ["Fly"] = 206.07, ["Ride"] = 70.16, ["Fly|Ride"] = 190.39, ["Neon"] = 445.19, ["Neon|Ride"] = 261.84, ["Neon|Fly|Ride"] = 341.96, ["Mega|Ride"] = 1140.12, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 60.38}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 319.92, ["Fly"] = 399, ["Ride"] = 326.8, ["Fly|Ride"] = 376.71, ["Neon|Ride"] = 1048.69, ["Neon|Fly|Ride"] = 1127.44, ["Mega|Fly|Ride"] = 5123.54}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 103.21, ["Fly"] = 136.42, ["Ride"] = 123.76, ["Fly|Ride"] = 196.88, ["Neon|Fly"] = 701.82, ["Neon|Ride"] = 573.56, ["Neon|Fly|Ride"] = 762.23, ["Mega|Fly|Ride"] = 3063.38}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.49, ["Ride"] = 55.04, ["Fly|Ride"] = 131.25, ["Neon"] = 19.59, ["Neon|Ride"] = 60.2, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 131.25, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 322.7, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 183.54, ["Fly"] = 286.33, ["Ride"] = 178.27, ["Fly|Ride"] = 212.22, ["Neon"] = 846.81, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 653.52, ["Mega|Fly|Ride"] = 2730}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.09, ["Fly"] = 23.09, ["Ride"] = 20.79, ["Fly|Ride"] = 36.35, ["Neon"] = 28.86, ["Neon|Fly"] = 128.21, ["Neon|Ride"] = 93.97, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 90.42, ["Fly"] = 284.72, ["Ride"] = 123.33, ["Fly|Ride"] = 170.85, ["Neon"] = 333.82, ["Neon|Ride"] = 380.63, ["Neon|Fly|Ride"] = 420, ["Mega"] = 1703.79, ["Mega|Ride"] = 1460.67, ["Mega|Fly|Ride"] = 1422.75}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 38.07}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 61.68, ["Ride"] = 91.88, ["Fly|Ride"] = 213.61, ["Neon"] = 393.75, ["Neon|Fly|Ride"] = 570.64}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 18.09, ["Fly"] = 55.57, ["Ride"] = 32.47, ["Fly|Ride"] = 315.16, ["Neon"] = 239.02, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2625, ["Mega|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 711.65}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 31.49, ["Fly"] = 143.17, ["Ride"] = 54.43, ["Fly|Ride"] = 102.16, ["Neon"] = 712.57, ["Neon|Ride"] = 237.57, ["Neon|Fly|Ride"] = 234.68, ["Mega"] = 1693.84, ["Mega|Ride"] = 1425.41, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 28.58, ["Fly"] = 78.75, ["Ride"] = 111.56, ["Fly|Ride"] = 267.09, ["Neon"] = 143.17, ["Neon|Fly"] = 401.64, ["Neon|Ride"] = 374.99, ["Neon|Fly|Ride"] = 467.25, ["Mega"] = 2047.5, ["Mega|Ride"] = 1709.64, ["Mega|Fly|Ride"] = 1357.04}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 16.25, ["Ride"] = 35.18, ["Fly|Ride"] = 83.91, ["Neon"] = 214.1, ["Neon|Ride"] = 212.66, ["Neon|Fly|Ride"] = 260.74, ["Mega"] = 959.6, ["Mega|Ride"] = 1239.5, ["Mega|Fly|Ride"] = 1140.12}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 29.3, ["Fly"] = 136.75, ["Ride"] = 57.73, ["Fly|Ride"] = 145.04, ["Neon"] = 325.49, ["Neon|Ride"] = 220.84, ["Neon|Fly|Ride"] = 262.49, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 958.13}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 4.39, ["Fly"] = 28.46, ["Ride"] = 20.34, ["Fly|Ride"] = 49.88, ["Neon"] = 32.81, ["Neon|Fly"] = 101.06, ["Neon|Ride"] = 54.49, ["Neon|Fly|Ride"] = 81.92, ["Mega"] = 176.93, ["Mega|Fly"] = 273.7, ["Mega|Ride"] = 182.33, ["Mega|Fly|Ride"] = 267.17}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 452.71, ["Ride"] = 466.59, ["Fly|Ride"] = 512.11, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1964.82, ["Mega|Fly|Ride"] = 8957.37}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 14.7, ["Ride"] = 32.67, ["Fly|Ride"] = 111.78, ["Neon"] = 217, ["Mega|Ride"] = 812.09, ["Mega|Fly|Ride"] = 925.35}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 4.76, ["Fly"] = 36.18, ["Ride"] = 21.36, ["Fly|Ride"] = 37.58, ["Neon"] = 83.26, ["Neon|Ride"] = 70.17, ["Neon|Fly|Ride"] = 118.23, ["Mega"] = 427.44, ["Mega|Ride"] = 379.34, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 84.96, ["Fly"] = 102.38, ["Ride"] = 100.37, ["Fly|Ride"] = 135.71, ["Neon"] = 371.24, ["Neon|Fly"] = 375.09, ["Neon|Ride"] = 417.59, ["Neon|Fly|Ride"] = 399, ["Mega"] = 4417.5, ["Mega|Ride"] = 5832.75, ["Mega|Fly|Ride"] = 1698.95}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 10.9, ["Ride"] = 32.23, ["Fly|Ride"] = 118.13, ["Neon"] = 131.25, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 221.82, ["Mega"] = 710.01, ["Mega|Ride"] = 806.97, ["Mega|Fly|Ride"] = 646.06}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 203.99, ["Fly"] = 288.75, ["Ride"] = 259.35, ["Fly|Ride"] = 339.74, ["Neon"] = 656.08, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 926.46, ["Mega"] = 6411.46, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 32.82}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.5, ["Fly"] = 32.67, ["Ride"] = 24.59, ["Fly|Ride"] = 54.54, ["Neon"] = 20.67, ["Neon|Fly"] = 137.95, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 143.2, ["Mega"] = 131.25, ["Mega|Fly"] = 483.68, ["Mega|Ride"] = 182.44, ["Mega|Fly|Ride"] = 284.24}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 820.31, ["Fly"] = 2625, ["Ride"] = 891.18, ["Fly|Ride"] = 942.06, ["Neon"] = 17419.68, ["Neon|Ride"] = 6269.33, ["Neon|Fly|Ride"] = 4282.32, ["Mega|Ride"] = 54442.12, ["Mega|Fly|Ride"] = 17096.24}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 13.02, ["Fly"] = 52.5, ["Ride"] = 32.42, ["Fly|Ride"] = 91.49, ["Neon"] = 91.88, ["Neon|Ride"] = 99.21, ["Neon|Fly|Ride"] = 213.72, ["Mega"] = 787.5, ["Mega|Ride"] = 1097.38, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 201.52, ["Fly"] = 362.8, ["Ride"] = 249.73, ["Fly|Ride"] = 275.63, ["Neon"] = 830.82, ["Neon|Ride"] = 748.57, ["Neon|Fly|Ride"] = 967.92, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 4034.78}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 45.83}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 17.07, ["Fly"] = 114.33, ["Ride"] = 65.63, ["Fly|Ride"] = 143.12, ["Neon"] = 104.9, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 712.77, ["Mega|Ride"] = 1129.62, ["Mega|Fly|Ride"] = 598.88}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 110.92, ["Ride"] = 166.69, ["Fly|Ride"] = 262.5, ["Neon"] = 534.17, ["Neon|Ride"] = 526.98, ["Neon|Fly|Ride"] = 570.64, ["Mega|Fly|Ride"] = 2723.17}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 118.26, ["Fly"] = 157.49, ["Ride"] = 85.45, ["Fly|Ride"] = 285.26, ["Neon"] = 360.94, ["Neon|Fly"] = 570.49, ["Neon|Ride"] = 434.78, ["Neon|Fly|Ride"] = 472.49, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1560.56}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 33.94}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 52.5, ["Fly"] = 68.09, ["Ride"] = 55.01, ["Fly|Ride"] = 84.5, ["Neon|Ride"] = 381.17, ["Neon|Fly|Ride"] = 422.1, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 4.79, ["Fly"] = 98.44, ["Ride"] = 35.42, ["Fly|Ride"] = 157.49, ["Neon"] = 42, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 67.56, ["Neon|Fly|Ride"] = 240.44, ["Mega"] = 131.25, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 298.97, ["Mega|Fly|Ride"] = 649.69}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 485.52, ["Fly"] = 479.07, ["Ride"] = 477.75, ["Fly|Ride"] = 473.82, ["Neon|Ride"] = 1923.45, ["Neon|Fly|Ride"] = 1742.98, ["Mega|Ride"] = 14959.22, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 110.55, ["Fly"] = 213.61, ["Ride"] = 116.82, ["Fly|Ride"] = 191.15, ["Neon"] = 420, ["Neon|Ride"] = 555.68, ["Neon|Fly|Ride"] = 570.64, ["Mega|Ride"] = 2563.39, ["Mega|Fly|Ride"] = 2548.65}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3675, ["Ride"] = 3885, ["Fly|Ride"] = 3674.99, ["Neon|Fly|Ride"] = 14958.99}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 43.56, ["Fly"] = 121.76, ["Ride"] = 57.17, ["Fly|Ride"] = 128.52, ["Neon|Ride"] = 322.88, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 1601.81, ["Mega|Ride"] = 1823.97, ["Mega|Fly|Ride"] = 1443.75}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 51.97, ["Ride"] = 68.06, ["Fly|Ride"] = 83.45, ["Neon"] = 646, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 431.82, ["Mega|Ride"] = 2280.23, ["Mega|Fly|Ride"] = 2350.74}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 27.12, ["Fly"] = 58.61, ["Ride"] = 39.27, ["Fly|Ride"] = 91.76, ["Neon"] = 139.21, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 187.65, ["Mega"] = 2625, ["Mega|Ride"] = 698.82, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 6.33}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 40.46, ["Ride"] = 62.37, ["Fly|Ride"] = 71.6, ["Neon|Ride"] = 323.09, ["Neon|Fly|Ride"] = 427.44, ["Mega|Ride"] = 1290.9, ["Mega|Fly|Ride"] = 1493.63}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 41.87}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 197.03, ["Ride"] = 236.25, ["Fly|Ride"] = 301.88, ["Neon|Ride"] = 1126.3, ["Neon|Fly|Ride"] = 1107.06, ["Mega|Fly|Ride"] = 4607.46}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["Ride"] = 1000.11, ["Fly|Ride"] = 783.56, ["Neon"] = 2887.5, ["Neon|Ride"] = 3205.74, ["Neon|Fly|Ride"] = 3510.48, ["Mega|Fly|Ride"] = 10820.36}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 7.52}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 28.58, ["Fly"] = 42.73, ["Ride"] = 32.78, ["Fly|Ride"] = 73.5, ["Neon"] = 246.75, ["Neon|Ride"] = 166.69, ["Neon|Fly|Ride"] = 216.08, ["Mega"] = 2137.16, ["Mega|Ride"] = 1164.36, ["Mega|Fly|Ride"] = 762.74}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 16.53}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 4987.5, ["Ride"] = 5650.32, ["Fly|Ride"] = 4828.69, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 43553.69}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 8.12, ["Fly"] = 55.12, ["Ride"] = 20.09, ["Fly|Ride"] = 59.49, ["Neon"] = 97.17, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 712.77, ["Mega|Ride"] = 481.69, ["Mega|Fly|Ride"] = 771.75}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 15.65, ["Fly"] = 139.89, ["Ride"] = 36.66, ["Neon"] = 97.22, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1076.8, ["Mega|Ride"] = 770.2, ["Mega|Fly|Ride"] = 712.71}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 70.87, ["Fly"] = 285.27, ["Ride"] = 58.95, ["Fly|Ride"] = 90.43, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 498.75, ["Mega"] = 4274.31}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 11.78, ["Fly"] = 71.56, ["Ride"] = 25.91, ["Fly|Ride"] = 132.65, ["Neon"] = 57.7, ["Neon|Ride"] = 129.49, ["Neon|Fly|Ride"] = 501.38, ["Mega"] = 1425.5, ["Mega|Ride"] = 749.36, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1765.31, ["Fly"] = 2365.33, ["Ride"] = 1833.41, ["Fly|Ride"] = 1819.02, ["Neon|Fly|Ride"] = 3580.5, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 27562.5, ["Fly"] = 34187.13, ["Ride"] = 52500, ["Fly|Ride"] = 26906.25, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 73883.31, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 16.62, ["Fly"] = 393.75, ["Ride"] = 45.94, ["Fly|Ride"] = 170.94, ["Neon"] = 320.51, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 956.39, ["Mega|Ride"] = 1147.13, ["Mega|Fly|Ride"] = 1393.73}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.56, ["Fly"] = 43.31, ["Ride"] = 32.71, ["Fly|Ride"] = 158.9, ["Neon"] = 17.72, ["Neon|Fly"] = 153.65, ["Neon|Ride"] = 66.53, ["Neon|Fly|Ride"] = 193.59, ["Mega"] = 143.07, ["Mega|Ride"] = 234.92, ["Mega|Fly|Ride"] = 247.96}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 20.99}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 6.92, ["Ride"] = 36.75, ["Fly|Ride"] = 124.68, ["Neon"] = 58.45, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 401.49, ["Mega"] = 229.69, ["Mega|Ride"] = 412.13, ["Mega|Fly|Ride"] = 656.24}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 714, ["Ride"] = 709.8, ["Fly|Ride"] = 745.5, ["Neon"] = 2493.43, ["Neon|Ride"] = 2564.6, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 11292.51}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 790.33, ["Fly"] = 975.19, ["Ride"] = 870.85, ["Fly|Ride"] = 787.5, ["Neon"] = 4131.14, ["Neon|Ride"] = 3704.76, ["Neon|Fly|Ride"] = 2493.75, ["Mega|Fly|Ride"] = 11668.19}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 12.39, ["Fly"] = 120.99, ["Ride"] = 30.19, ["Fly|Ride"] = 71.57, ["Neon"] = 78.74, ["Neon|Ride"] = 100.92, ["Neon|Fly|Ride"] = 214.15, ["Mega"] = 1204.13, ["Mega|Ride"] = 481.68, ["Mega|Fly|Ride"] = 548.63}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 24.57}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 76.97, ["Fly"] = 128.34, ["Ride"] = 78.65, ["Fly|Ride"] = 114.58, ["Neon"] = 420, ["Neon|Ride"] = 427.44, ["Neon|Fly|Ride"] = 420, ["Mega"] = 19687.5, ["Mega|Ride"] = 2092.17, ["Mega|Fly|Ride"] = 1664.25}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 72.19, ["Ride"] = 138.48, ["Fly|Ride"] = 127.32, ["Neon"] = 420, ["Neon|Fly"] = 404.16, ["Neon|Ride"] = 417.83, ["Neon|Fly|Ride"] = 553.77, ["Mega"] = 1390.64, ["Mega|Ride"] = 1923.34, ["Mega|Fly|Ride"] = 1934.52}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 6.35, ["Fly"] = 35.43, ["Ride"] = 22.53, ["Fly|Ride"] = 42.25, ["Neon"] = 42.74, ["Neon|Fly"] = 524.98, ["Neon|Ride"] = 68.4, ["Neon|Fly|Ride"] = 100.06, ["Mega"] = 286.13, ["Mega|Ride"] = 315.23, ["Mega|Fly|Ride"] = 712.71}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 126.6, ["Fly"] = 147.12, ["Ride"] = 126.58, ["Fly|Ride"] = 189.05, ["Neon"] = 725.81, ["Neon|Ride"] = 576.18, ["Neon|Fly|Ride"] = 553.04, ["Mega|Fly|Ride"] = 2204.98}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.73, ["Fly"] = 101.51, ["Ride"] = 44.25, ["Fly|Ride"] = 140.44, ["Neon"] = 41.91, ["Neon|Ride"] = 74.96, ["Mega"] = 248.07, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 13.13, ["Fly"] = 41.65, ["Ride"] = 32.67, ["Fly|Ride"] = 78.72, ["Neon"] = 126.29, ["Neon|Ride"] = 74.82, ["Neon|Fly|Ride"] = 173.13, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 30.96, ["Ride"] = 60.27, ["Fly|Ride"] = 156.19, ["Neon"] = 170.94, ["Neon|Ride"] = 282.19, ["Mega"] = 918.74, ["Mega|Ride"] = 1161.57, ["Mega|Fly|Ride"] = 1114.31}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 14.54, ["Fly"] = 203.3, ["Ride"] = 35.77, ["Fly|Ride"] = 70.87, ["Neon"] = 91.88, ["Neon|Ride"] = 115.77, ["Neon|Fly|Ride"] = 143.2, ["Mega|Fly|Ride"] = 1057.84}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6980.6, ["Ride"] = 6555.94, ["Fly|Ride"] = 5582.07, ["Neon"] = 35610.74, ["Neon|Ride"] = 24281.25, ["Neon|Fly|Ride"] = 28338.62}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 224.59, ["Fly"] = 271.27, ["Ride"] = 247.68, ["Fly|Ride"] = 262.4, ["Neon|Fly|Ride"] = 511.88, ["Mega|Fly|Ride"] = 2137.04}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 36.51, ["Fly"] = 146.62, ["Ride"] = 92.16, ["Fly|Ride"] = 197.61, ["Neon"] = 139.04, ["Neon|Fly"] = 306.62, ["Neon|Ride"] = 167.87, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 393.75, ["Mega|Ride"] = 419.9, ["Mega|Fly|Ride"] = 562.7}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.6, ["Fly"] = 89.51, ["Ride"] = 28.85, ["Fly|Ride"] = 50.21, ["Neon"] = 21.45, ["Neon|Fly"] = 61.99, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 194.51, ["Mega"] = 144.38, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 60.71, ["Fly"] = 5408.04, ["Ride"] = 99.89, ["Fly|Ride"] = 225.53, ["Neon"] = 196.86, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 236.24, ["Neon|Fly|Ride"] = 387.16, ["Mega"] = 539.85, ["Mega|Ride"] = 695.63, ["Mega|Fly|Ride"] = 628.74}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 14384.99, ["Ride"] = 13415.07, ["Fly|Ride"] = 11238.4, ["Neon|Fly|Ride"] = 24281.25, ["Mega|Fly|Ride"] = 113975.24}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 262.5, ["Ride"] = 315, ["Fly|Ride"] = 337.32, ["Neon"] = 1281.98, ["Neon|Ride"] = 1425.5, ["Neon|Fly|Ride"] = 1617.84, ["Mega|Fly|Ride"] = 6397.21}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 57.7, ["Fly"] = 87.28, ["Ride"] = 58.59, ["Fly|Ride"] = 129.93, ["Neon"] = 405.97, ["Neon|Ride"] = 311.72, ["Neon|Fly|Ride"] = 525}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 9.19, ["Ride"] = 23.77, ["Fly|Ride"] = 45.85, ["Neon"] = 67.46, ["Neon|Fly"] = 274.7, ["Neon|Ride"] = 71.76, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 360.94, ["Mega|Fly|Ride"] = 570.61}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 341.25, ["Fly"] = 528.64, ["Ride"] = 393.74, ["Fly|Ride"] = 531.57, ["Neon"] = 1553.06, ["Neon|Ride"] = 1376.76, ["Neon|Fly|Ride"] = 1923.45, ["Mega|Fly|Ride"] = 5103}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 4.86, ["Fly"] = 104.12, ["Ride"] = 41.58, ["Fly|Ride"] = 138.79, ["Neon"] = 33.01, ["Neon|Ride"] = 99.2, ["Neon|Fly|Ride"] = 195.57, ["Mega"] = 129.92, ["Mega|Fly"] = 263.92, ["Mega|Ride"] = 607.58, ["Mega|Fly|Ride"] = 248.07}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 104.08, ["Fly"] = 198.65, ["Ride"] = 126.98, ["Fly|Ride"] = 203.13, ["Neon"] = 443.63, ["Neon|Fly"] = 525, ["Neon|Ride"] = 516.13, ["Neon|Fly|Ride"] = 452.82, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.09, ["Fly"] = 19.18, ["Ride"] = 15.6, ["Fly|Ride"] = 31.69, ["Neon"] = 162.11, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 103.68, ["Mega"] = 2564.6, ["Mega|Fly|Ride"] = 645.75}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 6.57}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 65.63, ["Ride"] = 85.32, ["Fly|Ride"] = 427.33, ["Neon"] = 381.07, ["Neon|Fly"] = 426.38, ["Neon|Ride"] = 408.19, ["Neon|Fly|Ride"] = 3205.74, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1852.82}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 11.82, ["Fly"] = 78.46, ["Ride"] = 33.08, ["Fly|Ride"] = 98.44, ["Neon"] = 98.44, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 560.44, ["Mega|Fly|Ride"] = 570.61}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 25.27}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 47.4, ["Fly"] = 143.12, ["Ride"] = 112.04, ["Fly|Ride"] = 249.38, ["Neon"] = 289.52, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 1602.88, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.97, ["Ride"] = 29.23, ["Fly|Ride"] = 137.92, ["Neon"] = 20.9, ["Neon|Ride"] = 108.91, ["Neon|Fly|Ride"] = 285.33, ["Mega"] = 129.94, ["Mega|Ride"] = 213.42, ["Mega|Fly|Ride"] = 285.31}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 11.01, ["Fly"] = 56.44, ["Ride"] = 27.41, ["Fly|Ride"] = 81.04, ["Neon"] = 162.11, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 212.66, ["Mega|Ride"] = 651.8, ["Mega|Fly|Ride"] = 796.38}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 460.43, ["Ride"] = 500.26, ["Fly|Ride"] = 525, ["Neon|Fly|Ride"] = 2137.16, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 35.4, ["Fly"] = 100.44, ["Ride"] = 57.59, ["Fly|Ride"] = 131.24, ["Neon"] = 175.83, ["Neon|Ride"] = 259.88, ["Neon|Fly|Ride"] = 371.45, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 1613.92}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 46.7, ["Fly"] = 119.89, ["Ride"] = 53.81, ["Fly|Ride"] = 100.44, ["Neon"] = 318.17, ["Neon|Ride"] = 223.02, ["Neon|Fly|Ride"] = 458.1, ["Mega|Fly|Ride"] = 944.57}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 19.37, ["Ride"] = 66.12, ["Fly|Ride"] = 120.8, ["Neon"] = 97.01, ["Neon|Ride"] = 177.14, ["Neon|Fly|Ride"] = 255.41, ["Mega"] = 433.02, ["Mega|Fly"] = 525, ["Mega|Ride"] = 425.25, ["Mega|Fly|Ride"] = 646.06}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 26250, ["Ride"] = 8862, ["Fly|Ride"] = 8083.69, ["Neon|Fly|Ride"] = 17705.63, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1394.43, ["Fly"] = 1486.83, ["Ride"] = 1509.37, ["Fly|Ride"] = 1404.38, ["Neon|Ride"] = 4844.94, ["Neon|Fly|Ride"] = 3896.82, ["Mega|Fly|Ride"] = 15093.75}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 598.33, ["Ride"] = 630.99, ["Fly|Ride"] = 538.13, ["Neon"] = 2591.19, ["Neon|Ride"] = 2166.01, ["Neon|Fly|Ride"] = 3213.13, ["Mega|Fly|Ride"] = 8549.85}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 11.79, ["Fly"] = 21.16, ["Ride"] = 21.73, ["Fly|Ride"] = 47.01, ["Neon"] = 65.34, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 129.94, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 570.61}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 3.57, ["Fly"] = 78.74, ["Ride"] = 29.65, ["Fly|Ride"] = 182.69, ["Neon"] = 21.61, ["Neon|Ride"] = 42.68, ["Mega"] = 159.47, ["Mega|Ride"] = 198.19, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 34.12, ["Fly"] = 75.28, ["Ride"] = 41.13, ["Fly|Ride"] = 89.77, ["Neon"] = 544.38, ["Neon|Ride"] = 169.32, ["Neon|Fly|Ride"] = 212.58, ["Mega|Fly|Ride"] = 587.9}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.02, ["Fly"] = 25.66, ["Ride"] = 17.55, ["Fly|Ride"] = 36.56, ["Neon"] = 31.5, ["Neon|Ride"] = 45.99, ["Neon|Fly|Ride"] = 85.31, ["Mega"] = 261.19, ["Mega|Ride"] = 464.63, ["Mega|Fly|Ride"] = 427.88}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 323.3, ["Fly"] = 369.49, ["Ride"] = 321.56, ["Fly|Ride"] = 362.23, ["Neon"] = 1567.21, ["Neon|Fly|Ride"] = 1771.27, ["Mega|Fly|Ride"] = 3654}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 19.25, ["Fly"] = 59.07, ["Ride"] = 30.94, ["Fly|Ride"] = 96.79, ["Neon"] = 208.95, ["Neon|Fly"] = 315.24, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 257.25, ["Mega"] = 812.14, ["Mega|Ride"] = 787.4, ["Mega|Fly|Ride"] = 721.77}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 6.39, ["Fly"] = 20.99, ["Ride"] = 25.65, ["Fly|Ride"] = 42.9, ["Neon"] = 143.17, ["Neon|Fly"] = 137.95, ["Neon|Ride"] = 130.45, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 425.25}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 577.86, ["Fly"] = 1048.69, ["Ride"] = 533.98, ["Fly|Ride"] = 546.98, ["Mega|Fly|Ride"] = 12523.01}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1263.94, ["Ride"] = 1115.62, ["Fly|Ride"] = 1384.69, ["Neon"] = 4985.77, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13389.14}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 123.23, ["Fly"] = 138.9, ["Ride"] = 120.94, ["Fly|Ride"] = 108.69, ["Neon"] = 971.25, ["Neon|Ride"] = 585.46, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 2562.31}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 200, ["Fly"] = 212.13, ["Ride"] = 189.15, ["Fly|Ride"] = 202.13, ["Neon"] = 866.4, ["Neon|Ride"] = 643.13, ["Neon|Fly|Ride"] = 595.41, ["Mega|Ride"] = 9187.5, ["Mega|Fly|Ride"] = 2820.78}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 28.87, ["Fly"] = 122.88, ["Ride"] = 53.81, ["Fly|Ride"] = 123.64, ["Neon"] = 233.88, ["Neon|Ride"] = 272.98, ["Mega|Ride"] = 1425.41, ["Mega|Fly|Ride"] = 1068.53}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 238.88, ["Ride"] = 427.19, ["Fly|Ride"] = 413.31, ["Neon"] = 1220.63, ["Neon|Fly"] = 967.77, ["Neon|Fly|Ride"] = 1355.08, ["Mega|Fly|Ride"] = 5128.89}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2097.61, ["Fly"] = 2297.7, ["Ride"] = 2141.9, ["Fly|Ride"] = 2231.25, ["Neon|Fly|Ride"] = 10685.76, ["Mega|Fly|Ride"] = 29842.76}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 53.8, ["Fly"] = 213.61, ["Ride"] = 51.84, ["Fly|Ride"] = 196.88, ["Neon"] = 288.75, ["Neon|Ride"] = 320.59, ["Neon|Fly|Ride"] = 269.3, ["Mega|Ride"] = 1140.12, ["Mega|Fly|Ride"] = 1451.8}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 656.24, ["Ride"] = 677.14, ["Fly|Ride"] = 656.25, ["Neon|Fly|Ride"] = 1220.62, ["Mega|Fly|Ride"] = 3412.5}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 38.75, ["Fly"] = 48.65, ["Ride"] = 45.01, ["Fly|Ride"] = 78.75, ["Neon"] = 427.33, ["Neon|Ride"] = 271.43, ["Neon|Fly|Ride"] = 233.23, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.82, ["Fly"] = 43.3, ["Ride"] = 18.51, ["Fly|Ride"] = 41.91, ["Neon"] = 26.16, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 36.91, ["Neon|Fly|Ride"] = 101.06, ["Mega"] = 170.63, ["Mega|Ride"] = 184.98, ["Mega|Fly|Ride"] = 319.65}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 52.05, ["Ride"] = 128.33, ["Fly|Ride"] = 208.34, ["Neon"] = 352.55, ["Neon|Ride"] = 405.23, ["Neon|Fly|Ride"] = 712.77, ["Mega"] = 1562.27, ["Mega|Fly|Ride"] = 1695.2}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 836.79, ["Fly"] = 910.93, ["Ride"] = 854.44, ["Fly|Ride"] = 820.32, ["Neon|Ride"] = 2830.04, ["Neon|Fly|Ride"] = 2775.94, ["Mega|Fly|Ride"] = 11418.75}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 721.87, ["Ride"] = 698.44, ["Fly|Ride"] = 854.37, ["Neon|Fly|Ride"] = 4264.7, ["Mega|Fly|Ride"] = 15527.67}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 11.02, ["Fly"] = 26.25, ["Ride"] = 24.04, ["Fly|Ride"] = 38.74, ["Neon"] = 111.57, ["Neon|Ride"] = 106.87, ["Neon|Fly|Ride"] = 157.82, ["Mega|Fly|Ride"] = 846.89}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 8.54, ["Ride"] = 27.5, ["Fly|Ride"] = 85.32, ["Neon"] = 141.43, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 250.04, ["Mega"] = 662.82, ["Mega|Ride"] = 427.42, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.45, ["Ride"] = 22.09, ["Fly|Ride"] = 102.38, ["Neon"] = 20.87, ["Neon|Fly"] = 323.75, ["Neon|Ride"] = 56.16, ["Neon|Fly|Ride"] = 182.7, ["Mega"] = 129.94, ["Mega|Fly"] = 549.3, ["Mega|Ride"] = 285.9, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 28.88, ["Fly"] = 42.45, ["Ride"] = 39.29, ["Fly|Ride"] = 82.07, ["Neon"] = 240.47, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 233.04, ["Mega|Fly|Ride"] = 818.92}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 41.9, ["Ride"] = 106.81, ["Fly|Ride"] = 457.26, ["Neon"] = 428.35, ["Neon|Ride"] = 499.11, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2066.64, ["Mega|Ride"] = 1602.79, ["Mega|Fly|Ride"] = 1567.53}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 11.4, ["Fly"] = 43.3, ["Ride"] = 35.43, ["Fly|Ride"] = 88.24, ["Neon"] = 72.1, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 149.43, ["Mega|Ride"] = 386.68, ["Mega|Fly|Ride"] = 459.37}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 33.32, ["Fly"] = 62.34, ["Ride"] = 41.14, ["Fly|Ride"] = 66.94, ["Neon"] = 242.71, ["Neon|Fly"] = 1425.5, ["Neon|Ride"] = 196.67, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 2100, ["Mega|Ride"] = 1068.53, ["Mega|Fly|Ride"] = 853.12}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 2.55, ["Fly"] = 38.06, ["Ride"] = 18.01, ["Fly|Ride"] = 41.99, ["Neon"] = 35.1, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 91.74, ["Mega"] = 736.32, ["Mega|Ride"] = 483.94, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 6.29, ["Fly"] = 49.37, ["Ride"] = 33.1, ["Fly|Ride"] = 61.68, ["Neon"] = 51.84, ["Neon|Fly"] = 115.54, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 250.06, ["Mega"] = 319.51, ["Mega|Ride"] = 339.29, ["Mega|Fly|Ride"] = 479.07}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 50.68, ["Fly"] = 65.63, ["Ride"] = 53.81, ["Fly|Ride"] = 94.79, ["Neon"] = 419.78, ["Neon|Fly"] = 211.3, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 259.88, ["Mega|Fly|Ride"] = 1074.91}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1575, ["Fly"] = 1575, ["Ride"] = 1437.18, ["Fly|Ride"] = 1496.23, ["Neon|Fly|Ride"] = 3863.98, ["Mega|Fly|Ride"] = 18373.69}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 461.98, ["Fly"] = 531.66, ["Ride"] = 446.25, ["Fly|Ride"] = 511.77, ["Neon|Fly|Ride"] = 2821.06}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 272.85, ["Ride"] = 328.13, ["Fly|Ride"] = 433.13, ["Neon"] = 1181.25, ["Neon|Ride"] = 1567.61, ["Neon|Fly|Ride"] = 1688.36, ["Mega|Fly|Ride"] = 7644}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 45.44}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 25.47, ["Fly"] = 131.25, ["Ride"] = 47.16, ["Fly|Ride"] = 97.12, ["Neon"] = 325.5, ["Neon|Fly"] = 427.44, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 350.44, ["Mega|Ride"] = 1566.47, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 34187.13, ["Fly"] = 65625, ["Ride"] = 35437.5, ["Fly|Ride"] = 17979.94, ["Neon|Fly|Ride"] = 35437.49, ["Mega"] = 213714.95, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 320.25, ["Fly"] = 356.7, ["Ride"] = 283.56, ["Fly|Ride"] = 369.52, ["Neon"] = 1050, ["Neon|Fly"] = 1130.16, ["Neon|Ride"] = 882.54, ["Neon|Fly|Ride"] = 1036.87, ["Mega"] = 4274.31, ["Mega|Ride"] = 4273, ["Mega|Fly|Ride"] = 3286.66}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 210.69, ["Fly"] = 525, ["Ride"] = 213.61, ["Fly|Ride"] = 257.23, ["Neon|Fly|Ride"] = 1774.9}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 196.87, ["Fly"] = 982.8, ["Ride"] = 157.5, ["Fly|Ride"] = 252.83, ["Neon|Ride"] = 408.41, ["Neon|Fly|Ride"] = 660.39, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 14.44, ["Fly"] = 94.5, ["Ride"] = 28.85, ["Fly|Ride"] = 126, ["Neon|Ride"] = 89.46, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 723.52, ["Mega|Ride"] = 712.71, ["Mega|Fly|Ride"] = 801.41}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3675, ["Ride"] = 3688.13, ["Fly|Ride"] = 5122.51, ["Neon"] = 27775.83, ["Neon|Fly|Ride"] = 28495.69}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 23.86, ["Fly"] = 64.1, ["Ride"] = 27.43, ["Fly|Ride"] = 56.39, ["Neon"] = 225.02, ["Neon|Ride"] = 232.32, ["Neon|Fly|Ride"] = 323.05, ["Mega|Fly|Ride"] = 733.02}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 43.87, ["Fly"] = 106.51, ["Ride"] = 56.21, ["Fly|Ride"] = 95.6, ["Neon"] = 414.52, ["Neon|Fly"] = 1425.5, ["Neon|Ride"] = 204.75, ["Neon|Fly|Ride"] = 248.07, ["Mega|Fly|Ride"] = 1372.88}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 597.09, ["Ride"] = 834.44, ["Fly|Ride"] = 854.65, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 1903.12, ["Mega|Fly|Ride"] = 9118.71}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 9.19, ["Fly"] = 26.16, ["Ride"] = 27.26, ["Fly|Ride"] = 39.38, ["Neon"] = 118.12, ["Neon|Fly"] = 161.37, ["Neon|Ride"] = 127.17, ["Neon|Fly|Ride"] = 157.5, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 9.19, ["Ride"] = 27.57, ["Fly|Ride"] = 80, ["Neon"] = 83.34, ["Neon|Ride"] = 121.02, ["Neon|Fly|Ride"] = 206.98, ["Mega|Ride"] = 833.46}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 103.85, ["Ride"] = 128.63, ["Fly|Ride"] = 156.19, ["Neon"] = 1010.63, ["Neon|Ride"] = 783.88, ["Neon|Fly|Ride"] = 853.81, ["Mega|Fly|Ride"] = 2739.19}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 15.47, ["Fly"] = 151.59, ["Ride"] = 62.91, ["Fly|Ride"] = 131.25, ["Neon"] = 60.9, ["Neon|Ride"] = 101.66, ["Neon|Fly|Ride"] = 241.68, ["Mega"] = 332.07, ["Mega|Fly"] = 730.28, ["Mega|Ride"] = 278.25, ["Mega|Fly|Ride"] = 425.92}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3930.83, ["Fly"] = 6290.36, ["Ride"] = 3883.66, ["Fly|Ride"] = 4134.38, ["Neon"] = 19687.5, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 9842.44, ["Mega"] = 42741.93, ["Mega|Fly|Ride"] = 36756.91}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 30.77, ["Fly"] = 143.17, ["Ride"] = 78.66, ["Fly|Ride"] = 129.45, ["Neon"] = 399.26, ["Neon|Ride"] = 245.63, ["Neon|Fly|Ride"] = 574.23, ["Mega"] = 784.35, ["Mega|Ride"] = 1774.83, ["Mega|Fly|Ride"] = 782.23}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7271.25, ["Fly"] = 8828.59, ["Ride"] = 6857.82, ["Fly|Ride"] = 7140, ["Neon|Fly|Ride"] = 17696.44, ["Mega|Fly|Ride"] = 66137.49}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.57, ["Fly"] = 23.34, ["Ride"] = 15.48, ["Fly|Ride"] = 35.6, ["Neon"] = 24.61, ["Neon|Fly"] = 59.85, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 222.64, ["Mega|Ride"] = 372.75, ["Mega|Fly|Ride"] = 359.03}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 13.9, ["Fly"] = 38.19, ["Ride"] = 32.47, ["Fly|Ride"] = 55.64, ["Neon"] = 185.91, ["Neon|Fly"] = 236.11, ["Neon|Ride"] = 106.87, ["Neon|Fly|Ride"] = 161.44, ["Mega|Ride"] = 978.48, ["Mega|Fly|Ride"] = 935.82}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.75}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 10.96, ["Ride"] = 34.13, ["Fly|Ride"] = 116.03, ["Neon"] = 91.88, ["Neon|Ride"] = 139.13, ["Neon|Fly|Ride"] = 322.72, ["Mega"] = 1049.9, ["Mega|Ride"] = 896.49, ["Mega|Fly|Ride"] = 1261.22}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 29.92, ["Fly"] = 190.37, ["Ride"] = 70.7, ["Fly|Ride"] = 99.73, ["Neon"] = 155.82, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 323.79, ["Mega"] = 945, ["Mega|Ride"] = 854.82, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 12.62, ["Fly"] = 21.21, ["Ride"] = 21.19, ["Fly|Ride"] = 35.81, ["Neon|Ride"] = 114.35, ["Neon|Fly|Ride"] = 178.5, ["Mega"] = 2564.6, ["Mega|Ride"] = 603.72, ["Mega|Fly|Ride"] = 531.57}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8690.52}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.98}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 23.33}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 233.22, ["Ride"] = 356.7, ["Fly|Ride"] = 259.88, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 14.12, ["Fly"] = 135.64, ["Ride"] = 37.45, ["Fly|Ride"] = 128.24, ["Neon"] = 186.97, ["Neon|Ride"] = 116.81, ["Neon|Fly|Ride"] = 265.13, ["Mega"] = 525, ["Mega|Ride"] = 531.57, ["Mega|Fly|Ride"] = 1470}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 10.95}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 10.08, ["Ride"] = 30.98, ["Fly|Ride"] = 85.47, ["Neon|Ride"] = 249.38}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 3952.68}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 151.73, ["Fly"] = 427.19, ["Ride"] = 211.31, ["Fly|Ride"] = 497.84, ["Neon"] = 926.23, ["Neon|Ride"] = 918.75, ["Mega|Ride"] = 4131.96, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 83.35, ["Ride"] = 106.81, ["Fly|Ride"] = 213.68, ["Neon"] = 784.14, ["Neon|Ride"] = 547.78, ["Neon|Fly|Ride"] = 624.31, ["Mega|Ride"] = 2137.04, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 152.65, ["Fly"] = 315, ["Ride"] = 179.82, ["Fly|Ride"] = 208.86, ["Neon"] = 1067.25, ["Neon|Ride"] = 787.4, ["Neon|Fly|Ride"] = 840, ["Mega|Fly|Ride"] = 4777.5}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2388.74, ["Fly"] = 2362.5, ["Ride"] = 2034.38, ["Fly|Ride"] = 2270.63, ["Neon"] = 15005.37, ["Neon|Ride"] = 8889.49, ["Neon|Fly|Ride"] = 7124.2, ["Mega|Fly|Ride"] = 20868.75}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 15.75, ["Fly"] = 105.78, ["Ride"] = 56.8, ["Fly|Ride"] = 99.75, ["Neon"] = 127.32, ["Neon|Ride"] = 154.62, ["Neon|Fly|Ride"] = 199.84, ["Mega"] = 960.66, ["Mega|Ride"] = 1048.93, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 841.93, ["Fly"] = 2100, ["Ride"] = 721.88, ["Fly|Ride"] = 774.38, ["Neon|Ride"] = 3277.34, ["Neon|Fly|Ride"] = 4194.65, ["Mega|Fly|Ride"] = 16937.55}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 41.79}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 14.32, ["Ride"] = 51.86, ["Fly|Ride"] = 471.93, ["Neon"] = 81.29, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 106.5, ["Neon|Fly|Ride"] = 256.47, ["Mega"] = 436.7, ["Mega|Ride"] = 485.13, ["Mega|Fly|Ride"] = 512.91}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 6.43, ["Fly"] = 262.5, ["Ride"] = 27.45, ["Fly|Ride"] = 105.77, ["Neon"] = 39.38, ["Neon|Ride"] = 63.07, ["Neon|Fly|Ride"] = 205.76, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 399.65}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 52.48}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 17.07, ["Fly"] = 108.92, ["Ride"] = 31.45, ["Fly|Ride"] = 83.31, ["Neon"] = 96.79, ["Neon|Ride"] = 170.99, ["Neon|Fly|Ride"] = 254.63, ["Mega|Ride"] = 854.82, ["Mega|Fly|Ride"] = 2259.96}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 34.13, ["Fly"] = 52.5, ["Ride"] = 39.38, ["Fly|Ride"] = 41.91, ["Neon|Ride"] = 513, ["Neon|Fly|Ride"] = 323.79, ["Mega|Ride"] = 1814.75, ["Mega|Fly|Ride"] = 959.54}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6037.49, ["Fly"] = 10237.5, ["Ride"] = 6621.19, ["Fly|Ride"] = 5105.63, ["Neon|Fly|Ride"] = 12468.75, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 8.49, ["Fly"] = 65.63, ["Ride"] = 34.12, ["Fly|Ride"] = 81.37, ["Neon"] = 45.02, ["Neon|Fly"] = 143.17, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 226.26, ["Mega"] = 542.05, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 533.29}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 26.25}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 91.89, ["Fly"] = 378.07, ["Ride"] = 132.6, ["Fly|Ride"] = 183.75, ["Neon"] = 525, ["Neon|Ride"] = 455.44, ["Neon|Fly|Ride"] = 715.05, ["Mega|Fly|Ride"] = 2142.38}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 32.7, ["Fly"] = 140.91, ["Ride"] = 92.03, ["Fly|Ride"] = 187.41, ["Neon"] = 257.25, ["Neon|Ride"] = 212.08, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2419.75, ["Mega|Ride"] = 2885.01, ["Mega|Fly|Ride"] = 1200.94}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 20.19, ["Fly"] = 70.47, ["Ride"] = 28.67, ["Fly|Ride"] = 76.13, ["Neon"] = 116.82, ["Neon|Ride"] = 142.96, ["Neon|Fly|Ride"] = 196.76, ["Mega|Ride"] = 827.05, ["Mega|Fly|Ride"] = 780.94}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 5.17, ["Fly"] = 65.63, ["Ride"] = 22.75, ["Fly|Ride"] = 87.62, ["Neon"] = 32.36, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 52.48, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 216.46, ["Mega|Fly"] = 7015.28, ["Mega|Ride"] = 180.09, ["Mega|Fly|Ride"] = 268.66}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 11.33, ["Ride"] = 27.99, ["Fly|Ride"] = 94.02, ["Neon"] = 87.85, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 207.32, ["Mega|Ride"] = 646.06, ["Mega|Fly|Ride"] = 584.07}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 28.86, ["Fly"] = 26.24, ["Ride"] = 23.14, ["Fly|Ride"] = 41.14, ["Neon"] = 370.71, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 144.37}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 196.88}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 21.38, ["Ride"] = 131.21, ["Fly|Ride"] = 285.26, ["Neon"] = 170.63, ["Neon|Ride"] = 262.5, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 250.22, ["Ride"] = 443.63, ["Fly|Ride"] = 3844.83, ["Neon|Fly|Ride"] = 28495.69}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 44.28, ["Fly"] = 212.52, ["Ride"] = 82.28, ["Fly|Ride"] = 236.02, ["Neon"] = 285.26, ["Neon|Ride"] = 295.32, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 1035.57, ["Mega|Ride"] = 971.25, ["Mega|Fly|Ride"] = 1105.22}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 909.46, ["Fly"] = 1382.46, ["Ride"] = 1007.98, ["Fly|Ride"] = 1049.97, ["Neon|Fly"] = 4185.58, ["Neon|Ride"] = 4195.12, ["Neon|Fly|Ride"] = 3589.89, ["Mega|Fly|Ride"] = 11746.88}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 388.49, ["Fly"] = 712.32, ["Ride"] = 413.42, ["Fly|Ride"] = 564.38, ["Neon"] = 2139.38, ["Neon|Ride"] = 2420.03, ["Neon|Fly|Ride"] = 2584.89, ["Mega"] = 12822.91, ["Mega|Fly|Ride"] = 8990.63}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 71.54}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 8.56, ["Fly"] = 21.84, ["Ride"] = 24.05, ["Fly|Ride"] = 50.68, ["Neon"] = 78.75, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 82.43, ["Neon|Fly|Ride"] = 143.05, ["Mega"] = 437.26, ["Mega|Ride"] = 712.71, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 250.78, ["Fly"] = 525, ["Ride"] = 272.99, ["Fly|Ride"] = 350.43, ["Neon"] = 1130.28, ["Neon|Ride"] = 1079.34, ["Neon|Fly|Ride"] = 1063.37, ["Mega|Fly|Ride"] = 3396.83}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 12.88}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 115.4, ["Ride"] = 170.63, ["Fly|Ride"] = 259.88, ["Neon"] = 590.63, ["Neon|Ride"] = 712.77, ["Neon|Fly|Ride"] = 728.34, ["Mega"] = 3135.21, ["Mega|Ride"] = 12155.42, ["Mega|Fly|Ride"] = 2707.64}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 111.56, ["Fly"] = 170.88, ["Ride"] = 128.76, ["Fly|Ride"] = 213.68, ["Neon"] = 854.65, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 2350.88, ["Neon|Fly|Ride"] = 913.5, ["Mega|Fly|Ride"] = 2564.45}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 4.55, ["Ride"] = 26.25, ["Fly|Ride"] = 174.15, ["Neon"] = 28.88, ["Neon|Ride"] = 87.13, ["Neon|Fly|Ride"] = 211.42, ["Mega"] = 264.75, ["Mega|Ride"] = 309.89, ["Mega|Fly|Ride"] = 853.76}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 13.27, ["Fly"] = 64.12, ["Ride"] = 27.13, ["Fly|Ride"] = 77.84, ["Neon"] = 177.19, ["Neon|Ride"] = 149.62, ["Neon|Fly|Ride"] = 323.05, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 12.7, ["Fly"] = 102.35, ["Ride"] = 34.26, ["Fly|Ride"] = 104.79, ["Neon"] = 78.75, ["Neon|Ride"] = 101.06, ["Neon|Fly|Ride"] = 256.57, ["Mega"] = 498.75, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 3.94, ["Fly"] = 98.07, ["Ride"] = 44.84, ["Fly|Ride"] = 156.1, ["Neon"] = 22.34, ["Neon|Ride"] = 69.78, ["Neon|Fly|Ride"] = 154.88, ["Mega"] = 131.23, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 288.7}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 249.38, ["Ride"] = 290.05, ["Fly|Ride"] = 359.63, ["Neon"] = 1593.93, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 5641.78}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 108.94, ["Fly"] = 329.05, ["Ride"] = 123.34, ["Fly|Ride"] = 241.49, ["Neon"] = 525, ["Neon|Fly"] = 618.72, ["Neon|Ride"] = 549.84, ["Neon|Fly|Ride"] = 628.69, ["Mega"] = 2778.32, ["Mega|Fly|Ride"] = 2849.75}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 45.95, ["Fly"] = 167.45, ["Ride"] = 72.19, ["Fly|Ride"] = 128.15, ["Neon"] = 380.63, ["Neon|Ride"] = 461.64, ["Neon|Fly|Ride"] = 408.19, ["Mega|Fly|Ride"] = 1801.13}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 14.97, ["Fly"] = 78.75, ["Ride"] = 28.85, ["Fly|Ride"] = 285.26, ["Neon"] = 115.5, ["Neon|Ride"] = 614.7, ["Neon|Fly|Ride"] = 499.05, ["Mega|Fly|Ride"] = 1995.99}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 14.16, ["Fly"] = 42.75, ["Ride"] = 28.84, ["Fly|Ride"] = 75.84, ["Neon"] = 94.5, ["Neon|Ride"] = 109.01, ["Neon|Fly|Ride"] = 192.39, ["Mega"] = 371.44, ["Mega|Fly"] = 525, ["Mega|Ride"] = 483.94, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.4, ["Fly"] = 43.32, ["Ride"] = 19.69, ["Fly|Ride"] = 47.84, ["Neon"] = 19.74, ["Neon|Fly"] = 68.3, ["Neon|Ride"] = 50.19, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 128.63, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 256.07}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 1025.51, ["Fly"] = 1060.4, ["Ride"] = 883.32, ["Fly|Ride"] = 900.16, ["Neon"] = 3562.8, ["Neon|Ride"] = 2992.02, ["Neon|Fly|Ride"] = 2624.99, ["Mega|Fly|Ride"] = 10898.86}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 320.25, ["Fly"] = 413.31, ["Ride"] = 393.75, ["Fly|Ride"] = 405.97, ["Neon"] = 1277.38, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1681.95, ["Mega"] = 10685.76, ["Mega|Fly|Ride"] = 5982.63}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 64.97, ["Fly"] = 170.96, ["Ride"] = 116.82, ["Fly|Ride"] = 143.17, ["Neon"] = 327.87, ["Neon|Ride"] = 326.31, ["Neon|Fly|Ride"] = 512.93, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 1695.75}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 209.99, ["Fly"] = 283.5, ["Ride"] = 194.64, ["Fly|Ride"] = 266.82, ["Neon|Fly|Ride"] = 1094.63, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 18.52, ["Fly"] = 52.5, ["Ride"] = 23.15, ["Fly|Ride"] = 71.47, ["Neon"] = 169.32, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 236.25, ["Mega|Ride"] = 563.19, ["Mega|Fly|Ride"] = 806.97}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 236.25, ["Ride"] = 255.68, ["Fly|Ride"] = 616.88, ["Neon"] = 747.64, ["Neon|Ride"] = 942.27, ["Neon|Fly|Ride"] = 971.25, ["Mega"] = 4173.65, ["Mega|Ride"] = 4701.48, ["Mega|Fly|Ride"] = 4274.07}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 61.48, ["Fly"] = 125.98, ["Ride"] = 76.99, ["Fly|Ride"] = 106.46, ["Neon|Ride"] = 609.86, ["Neon|Fly|Ride"] = 570.64, ["Mega|Fly|Ride"] = 1551.51}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1968.74, ["Ride"] = 2100, ["Fly|Ride"] = 2021.14, ["Neon|Ride"] = 11292.98, ["Neon|Fly|Ride"] = 7612.5, ["Mega"] = 51291.6, ["Mega|Fly|Ride"] = 24932.73}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 12.35, ["Fly"] = 77.24, ["Ride"] = 39.37, ["Fly|Ride"] = 51.45, ["Neon"] = 64.97, ["Neon|Fly"] = 237.57, ["Neon|Ride"] = 100.4, ["Neon|Fly|Ride"] = 204.04, ["Mega"] = 489.86, ["Mega|Fly"] = 561.52, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 53.25, ["Ride"] = 72.18, ["Fly|Ride"] = 105, ["Neon"] = 223.13, ["Neon|Ride"] = 371.48, ["Neon|Fly|Ride"] = 570.64, ["Mega"] = 1693.84, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 78.65, ["Fly"] = 87.25, ["Ride"] = 73.43, ["Fly|Ride"] = 78.75, ["Neon"] = 525, ["Neon|Fly|Ride"] = 393.74, ["Mega|Fly|Ride"] = 1879.8}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2135.97, ["Fly"] = 1613.74, ["Ride"] = 1069.68, ["Fly|Ride"] = 1168.13, ["Neon|Ride"] = 5163.13, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 482.91, ["Fly"] = 525, ["Ride"] = 669.97, ["Fly|Ride"] = 616.88, ["Neon|Fly|Ride"] = 3226.75, ["Mega"] = 12098.73}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 68.84, ["Fly"] = 323.01, ["Ride"] = 93.56, ["Fly|Ride"] = 196.88, ["Neon"] = 445.6, ["Neon|Ride"] = 393.74, ["Neon|Fly|Ride"] = 557.82, ["Mega|Ride"] = 2707.64, ["Mega|Fly|Ride"] = 1710.71}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 8.58, ["Ride"] = 21.36, ["Fly|Ride"] = 61.64, ["Neon"] = 68.97, ["Neon|Fly"] = 143.17, ["Neon|Ride"] = 69.83, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 603.75, ["Mega|Ride"] = 773.62}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 41.19, ["Fly"] = 68.25, ["Ride"] = 54.57, ["Fly|Ride"] = 106.85, ["Neon"] = 213.68, ["Neon|Fly"] = 341.87, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 236.24, ["Mega"] = 1115.63, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 748.13, ["Fly"] = 1112.93, ["Ride"] = 759.94, ["Fly|Ride"] = 832.11, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2184.27, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 706.13}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 5236.88, ["Ride"] = 5610.94, ["Fly|Ride"] = 5982.5, ["Neon"] = 42000, ["Neon|Ride"] = 30626.44, ["Neon|Fly|Ride"] = 17584.88, ["Mega|Fly|Ride"] = 91180.62}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 268.69, ["Fly"] = 400.49, ["Neon"] = 1709.3, ["Neon|Fly|Ride"] = 2231.25, ["Mega"] = 6410.4, ["Mega|Fly|Ride"] = 6775.02}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 70.87, ["Fly"] = 285.27, ["Ride"] = 121.96, ["Fly|Ride"] = 336, ["Neon"] = 641, ["Neon|Ride"] = 670.02, ["Neon|Fly|Ride"] = 637.88, ["Mega|Fly|Ride"] = 2166.31}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 15.74, ["Fly"] = 42.09, ["Ride"] = 29.93, ["Fly|Ride"] = 90.75, ["Neon"] = 152.24, ["Neon|Fly"] = 1291.1, ["Neon|Ride"] = 125.99, ["Neon|Fly|Ride"] = 181.5, ["Mega"] = 995.93, ["Mega|Ride"] = 854.82, ["Mega|Fly|Ride"] = 824.92}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 9.97, ["Fly"] = 34.2, ["Ride"] = 19.69, ["Fly|Ride"] = 46.22, ["Neon"] = 213.68, ["Neon|Ride"] = 323.09, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2137.04}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 14, ["Ride"] = 27.28, ["Fly|Ride"] = 120.99, ["Neon"] = 154.88, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 233.63, ["Mega"] = 645.75, ["Mega|Ride"] = 658.88, ["Mega|Fly|Ride"] = 570.61}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.7, ["Fly"] = 79.08, ["Ride"] = 22.09, ["Fly|Ride"] = 48.57, ["Neon"] = 35.43, ["Neon|Ride"] = 56.11, ["Neon|Fly|Ride"] = 113.7, ["Mega"] = 322.72, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 323.04}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 26.04, ["Fly"] = 90.57, ["Ride"] = 39.37, ["Fly|Ride"] = 139.13, ["Neon"] = 157.5, ["Neon|Fly"] = 854.87, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 451.5, ["Mega"] = 614.49, ["Mega|Ride"] = 1260}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 456.65, ["Fly"] = 465.94, ["Ride"] = 456.19, ["Fly|Ride"] = 523.68, ["Neon"] = 1600.33, ["Neon|Ride"] = 1532.35, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 7875, ["Mega|Fly|Ride"] = 5834.11}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.62, ["Fly"] = 19.56, ["Ride"] = 16.69, ["Fly|Ride"] = 28.64, ["Neon"] = 19.35, ["Neon|Ride"] = 35.07, ["Neon|Fly|Ride"] = 70.41, ["Mega"] = 230.83, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 35.6, ["Fly"] = 90.34, ["Ride"] = 71.77, ["Fly|Ride"] = 130.09, ["Neon"] = 183.71, ["Neon|Fly"] = 333.15, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 275.62, ["Mega"] = 465.94, ["Mega|Ride"] = 551.25, ["Mega|Fly|Ride"] = 483.94}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 787.5, ["Fly"] = 1052.44, ["Ride"] = 748.12, ["Fly|Ride"] = 771.75, ["Neon|Ride"] = 1988.23, ["Neon|Fly|Ride"] = 1704.93, ["Mega|Fly|Ride"] = 3936.19}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 32.67, ["Fly"] = 60.38, ["Ride"] = 45.89, ["Fly|Ride"] = 81.03, ["Neon|Ride"] = 188.88, ["Neon|Fly|Ride"] = 223.12, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 851.8}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 262.49, ["Fly"] = 388.45, ["Ride"] = 290.96, ["Fly|Ride"] = 401.35, ["Neon|Ride"] = 1852.92, ["Neon|Fly|Ride"] = 1282.31}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 181.91, ["Fly"] = 176.69, ["Ride"] = 196.88, ["Fly|Ride"] = 218.34, ["Neon"] = 641, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 854.87, ["Mega"] = 4326, ["Mega|Fly|Ride"] = 3546.79}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 834.74, ["Ride"] = 754.69, ["Fly|Ride"] = 786.19, ["Neon|Fly|Ride"] = 3041.64, ["Mega|Fly|Ride"] = 7611.19}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 19.71, ["Fly"] = 85.49, ["Ride"] = 41.77, ["Fly|Ride"] = 100.44, ["Neon"] = 106.85, ["Neon|Fly"] = 290.41, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 185.95, ["Mega"] = 354.38, ["Mega|Ride"] = 391.51, ["Mega|Fly|Ride"] = 483.31}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4084.49, ["Fly"] = 3302.99, ["Ride"] = 3543.75, ["Fly|Ride"] = 3359.98, ["Neon"] = 14244.74, ["Neon|Fly|Ride"] = 7350, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 123.34, ["Fly"] = 171.42, ["Ride"] = 139.98, ["Fly|Ride"] = 207.89, ["Neon"] = 433.13, ["Neon|Fly"] = 512.93, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 577.5, ["Mega|Fly|Ride"] = 2350.74}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.29, ["Fly"] = 27.8, ["Ride"] = 20.31, ["Fly|Ride"] = 38.14, ["Neon"] = 20.25, ["Neon|Fly"] = 65.62, ["Neon|Ride"] = 35.35, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 168.86, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 370.78, ["Mega|Fly|Ride"] = 227.07}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.84, ["Ride"] = 24.56, ["Fly|Ride"] = 57.71, ["Neon"] = 20.58, ["Neon|Fly"] = 118.6, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 162.15, ["Mega"] = 159.21, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 35.13, ["Fly"] = 85.49, ["Ride"] = 42.87, ["Fly|Ride"] = 56.34, ["Neon|Fly|Ride"] = 301.88, ["Mega|Fly|Ride"] = 1001.27}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 974.52, ["Ride"] = 1424.63, ["Fly|Ride"] = 1298.07}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6693.75, ["Fly|Ride"] = 6431.25}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 18.16, ["Fly"] = 36.35, ["Ride"] = 26.17, ["Fly|Ride"] = 41.91, ["Neon"] = 452.13, ["Neon|Ride"] = 285.33, ["Neon|Fly|Ride"] = 167.23, ["Mega"] = 2520, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 11.88, ["Fly"] = 49.88, ["Ride"] = 28.69, ["Fly|Ride"] = 75.89, ["Neon"] = 89.25, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 932.88, ["Mega|Ride"] = 567.4, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 75.43, ["Fly"] = 157.5, ["Ride"] = 78.74, ["Fly|Ride"] = 124.58, ["Neon"] = 427.33, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 402.7, ["Mega|Fly|Ride"] = 1896.63}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 221.45, ["Ride"] = 212.96, ["Fly|Ride"] = 271.9, ["Neon|Ride"] = 1648.83, ["Neon|Fly|Ride"] = 1000.13, ["Mega"] = 4839.5, ["Mega|Fly|Ride"] = 4518.7}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.66, ["Ride"] = 32.78, ["Fly|Ride"] = 93.09, ["Neon"] = 19.95, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 49.53, ["Neon|Fly|Ride"] = 81.09, ["Mega"] = 151.6, ["Mega|Fly"] = 228.68, ["Mega|Ride"] = 191.31, ["Mega|Fly|Ride"] = 1423.28}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 170.35, ["Ride"] = 209.27, ["Fly|Ride"] = 288.73, ["Neon"] = 1181.25, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1613.99, ["Mega"] = 3276.27, ["Mega|Fly|Ride"] = 3548.55}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.28, ["Fly"] = 42.75, ["Ride"] = 15.32, ["Fly|Ride"] = 159.79, ["Neon"] = 23, ["Neon|Fly"] = 128.21, ["Neon|Ride"] = 28.81, ["Neon|Fly|Ride"] = 108.82, ["Mega"] = 225.75, ["Mega|Ride"] = 223.12, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 208.57, ["Fly"] = 285.27, ["Ride"] = 220.5, ["Fly|Ride"] = 236.24, ["Neon|Ride"] = 1210.02, ["Neon|Fly|Ride"] = 998.07, ["Mega"] = 10685.76, ["Mega|Fly|Ride"] = 4986.77}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 9.69, ["Fly"] = 75.12, ["Ride"] = 28.27, ["Fly|Ride"] = 68.25, ["Neon"] = 73.5, ["Neon|Fly"] = 307.29, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 115.66, ["Mega"] = 499.05, ["Mega|Ride"] = 541.75, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 3.77, ["Ride"] = 21.37, ["Fly|Ride"] = 72.1, ["Neon"] = 8.4, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 195.56, ["Mega"] = 70.17, ["Mega|Ride"] = 106.47, ["Mega|Fly|Ride"] = 248.07}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.74, ["Mega"] = 15.94, ["Mega|Ride"] = 142.77, ["Mega|Fly|Ride"] = 320.57}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 31.16, ["Fly|Ride"] = 110.04, ["Neon"] = 5.92, ["Neon|Ride"] = 27.8, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 75.49, ["Mega|Fly"] = 161317.2, ["Mega|Ride"] = 91.96, ["Mega|Fly|Ride"] = 202.13}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 69.47, ["Fly"] = 149.97, ["Ride"] = 112.54, ["Fly|Ride"] = 196.27, ["Neon"] = 293.02, ["Neon|Fly"] = 406.08, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 328.12, ["Mega|Ride"] = 1389.08, ["Mega|Fly|Ride"] = 1281.57}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 35.09, ["Ride"] = 15.73, ["Fly|Ride"] = 113.26, ["Neon"] = 9.16, ["Neon|Ride"] = 28.87, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 96.8, ["Mega|Ride"] = 165.38, ["Mega|Fly|Ride"] = 261.44}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 7.23, ["Neon"] = 78.61, ["Neon|Ride"] = 213.72, ["Neon|Fly|Ride"] = 223.11, ["Mega"] = 393.74, ["Mega|Ride"] = 554.76}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 1.79, ["Ride"] = 28.85, ["Neon"] = 2.63, ["Neon|Ride"] = 52.36, ["Neon|Fly|Ride"] = 277.32, ["Mega"] = 18.89, ["Mega|Fly"] = 143.2, ["Mega|Ride"] = 49.38, ["Mega|Fly|Ride"] = 320.57}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 1.79, ["Fly"] = 64.96, ["Ride"] = 15.74, ["Fly|Ride"] = 36.35, ["Neon"] = 2.1, ["Neon|Fly"] = 26.22, ["Neon|Ride"] = 14.17, ["Neon|Fly|Ride"] = 28.88, ["Mega"] = 15.44, ["Mega|Fly"] = 42.75, ["Mega|Ride"] = 19.37, ["Mega|Fly|Ride"] = 64.32}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 19.57, ["Ride"] = 15.16, ["Fly|Ride"] = 64.79, ["Neon"] = 2.1, ["Neon|Fly"] = 38.1, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 39.27, ["Mega"] = 28.88, ["Mega|Ride"] = 30.87, ["Mega|Fly|Ride"] = 87.93}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.61, ["Neon|Ride"] = 67.57, ["Mega"] = 20.91, ["Mega|Ride"] = 99.75}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 91.85, ["Ride"] = 31.45, ["Fly|Ride"] = 107.61, ["Neon"] = 3.94, ["Neon|Fly"] = 168, ["Neon|Ride"] = 20.66, ["Neon|Fly|Ride"] = 81.38, ["Mega"] = 24.61, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 40.72, ["Mega|Fly|Ride"] = 95.42}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 82.09, ["Neon|Fly|Ride"] = 427.44, ["Mega"] = 14.6, ["Mega|Fly"] = 138.93, ["Mega|Ride"] = 806.97, ["Mega|Fly|Ride"] = 213.71}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 71.59, ["Ride"] = 32.79, ["Fly|Ride"] = 47.78, ["Neon"] = 17.05, ["Neon|Fly"] = 69.28, ["Neon|Ride"] = 45.92, ["Neon|Fly|Ride"] = 121, ["Mega"] = 115.5, ["Mega|Fly"] = 285.33, ["Mega|Ride"] = 123.38, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 27.78, ["Neon"] = 2.35, ["Neon|Ride"] = 77.87, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 14.59, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 66.18, ["Mega|Fly|Ride"] = 181.67}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Ride"] = 144.52, ["Fly|Ride"] = 525, ["Neon"] = 18.12, ["Mega"] = 162.74, ["Mega|Fly"] = 315, ["Mega|Ride"] = 285.31, ["Mega|Fly|Ride"] = 553.5}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Neon"] = 16.92, ["Mega"] = 104.99, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 570.61}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.63, ["Ride"] = 32.8, ["Neon"] = 5.25, ["Neon|Ride"] = 27.34, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 19.49, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 131.23}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 14.21, ["Fly|Ride"] = 40.69, ["Neon"] = 2.1, ["Neon|Fly"] = 35.32, ["Neon|Ride"] = 15.6, ["Neon|Fly|Ride"] = 33.16, ["Mega"] = 14.22, ["Mega|Fly"] = 28.92, ["Mega|Ride"] = 18.65, ["Mega|Fly|Ride"] = 50.68}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 229.68, ["Fly|Ride"] = 118.11, ["Neon"] = 37.41, ["Neon|Ride"] = 45.94, ["Mega"] = 170.99, ["Mega|Ride"] = 240.19}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 27.57, ["Neon"] = 3.72, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 28.76, ["Neon|Fly|Ride"] = 105, ["Mega"] = 42.75, ["Mega|Ride"] = 45.85, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 3.05, ["Neon"] = 15.33, ["Mega"] = 85.67, ["Mega|Ride"] = 162.43, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.52, ["Fly"] = 65.63, ["Ride"] = 47.1, ["Fly|Ride"] = 194.44, ["Neon"] = 23.16, ["Neon|Ride"] = 50.24, ["Neon|Fly|Ride"] = 143.2, ["Mega"] = 124.69, ["Mega|Ride"] = 143.06, ["Mega|Fly|Ride"] = 193.58}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 19.34, ["Ride"] = 11.46, ["Fly|Ride"] = 27.26, ["Neon"] = 2.1, ["Neon|Fly"] = 15.62, ["Neon|Ride"] = 11.68, ["Neon|Fly|Ride"] = 28.14, ["Mega"] = 14.86, ["Mega|Fly"] = 27.46, ["Mega|Ride"] = 21.93, ["Mega|Fly|Ride"] = 42.4}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 28.46, ["Ride"] = 27.39, ["Fly|Ride"] = 131.25, ["Neon"] = 9.84, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 129.54, ["Mega|Ride"] = 160.78, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 3.61, ["Fly"] = 112.52, ["Ride"] = 140.35, ["Fly|Ride"] = 59.06, ["Neon"] = 44.52, ["Neon|Ride"] = 67.48, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 259.88, ["Mega|Ride"] = 338.77, ["Mega|Fly|Ride"] = 311.73}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 32.51, ["Ride"] = 13.71, ["Fly|Ride"] = 43.19, ["Neon"] = 2.36, ["Neon|Fly"] = 17.11, ["Neon|Ride"] = 14.23, ["Neon|Fly|Ride"] = 50.99, ["Mega"] = 24.21, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 99.75}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 178.43, ["Ride"] = 45.94, ["Neon"] = 5.38, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 167.25, ["Mega"] = 63.93, ["Mega|Fly"] = 170.99, ["Mega|Ride"] = 98.34}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.5, ["Ride"] = 35.44, ["Neon"] = 5.1, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 143.2, ["Mega"] = 28.67, ["Mega|Fly"] = 143.2, ["Mega|Ride"] = 72.1, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 36.35, ["Ride"] = 18.18, ["Neon"] = 2.1, ["Neon|Fly"] = 42.74, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 285.33, ["Mega"] = 15.87, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 178.45}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 71.59, ["Ride"] = 17.11, ["Fly|Ride"] = 46.45, ["Neon"] = 7.54, ["Neon|Fly"] = 28.87, ["Neon|Ride"] = 21.38, ["Neon|Fly|Ride"] = 56.99, ["Mega"] = 143.16, ["Mega|Ride"] = 91.91, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 56.03, ["Neon"] = 6.18, ["Neon|Ride"] = 61.98, ["Mega"] = 33.5, ["Mega|Ride"] = 96.93, ["Mega|Fly|Ride"] = 249.37}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 23.31, ["Ride"] = 15.31, ["Fly|Ride"] = 47.01, ["Neon"] = 4.57, ["Neon|Fly"] = 79.97, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 57.54, ["Mega"] = 103.69, ["Mega|Ride"] = 90.54, ["Mega|Fly|Ride"] = 143.19}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 6.57, ["Ride"] = 36.33, ["Fly|Ride"] = 50.05, ["Neon"] = 42, ["Neon|Fly"] = 250.06, ["Neon|Fly|Ride"] = 327.3, ["Mega"] = 98.44, ["Mega|Ride"] = 168.38}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 18.31, ["Fly|Ride"] = 57.48, ["Neon"] = 11.46, ["Neon|Fly"] = 48.42, ["Neon|Ride"] = 30.56, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 285.33, ["Mega|Fly"] = 420, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 19.93, ["Ride"] = 24.05, ["Fly|Ride"] = 52.48, ["Neon"] = 16.03, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 21.05, ["Neon|Fly|Ride"] = 72.17, ["Mega"] = 222.5, ["Mega|Fly"] = 138.99, ["Mega|Ride"] = 427.42, ["Mega|Fly|Ride"] = 177.17}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 111.56, ["Fly|Ride"] = 96.79, ["Neon"] = 26.25, ["Neon|Ride"] = 105.29, ["Mega"] = 159.07, ["Mega|Ride"] = 236.24}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 50.64, ["Ride"] = 56.44, ["Neon"] = 262.4, ["Neon|Fly|Ride"] = 126, ["Mega"] = 570.64, ["Mega|Ride"] = 714.26, ["Mega|Fly|Ride"] = 811.01}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 6.38, ["Ride"] = 34.19, ["Neon"] = 42.68, ["Neon|Ride"] = 126, ["Mega"] = 237.46, ["Mega|Ride"] = 365.53}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 4.75, ["Ride"] = 28.41, ["Fly|Ride"] = 120.75, ["Neon"] = 52.79, ["Neon|Ride"] = 79.86, ["Mega"] = 483.96, ["Mega|Ride"] = 425.28, ["Mega|Fly|Ride"] = 364.22}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.12, ["Neon|Ride"] = 65, ["Mega"] = 19.29, ["Mega|Fly"] = 64.13, ["Mega|Ride"] = 67.33, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 44.83}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 3.9, ["Fly"] = 23.61, ["Ride"] = 21.51, ["Fly|Ride"] = 41.57, ["Neon"] = 49.35, ["Neon|Fly"] = 188.48, ["Neon|Ride"] = 47.76, ["Neon|Fly|Ride"] = 78.62, ["Mega"] = 271.44, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 15.75, ["Fly|Ride"] = 52.5, ["Neon"] = 6.23, ["Neon|Ride"] = 27.8, ["Neon|Fly|Ride"] = 159.71, ["Mega"] = 24.94, ["Mega|Fly"] = 143.2, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Neon"] = 5.14, ["Neon|Ride"] = 34.55, ["Neon|Fly|Ride"] = 98.33, ["Mega"] = 39.25, ["Mega|Ride"] = 242.61, ["Mega|Fly|Ride"] = 133.88}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 50.21, ["Ride"] = 19.23, ["Fly|Ride"] = 42.83, ["Neon"] = 6.56, ["Neon|Ride"] = 19.24, ["Neon|Fly|Ride"] = 127.65, ["Mega"] = 130.38, ["Mega|Ride"] = 118, ["Mega|Fly|Ride"] = 190.21}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.95, ["Ride"] = 41.91, ["Fly|Ride"] = 57.75, ["Neon"] = 35.41, ["Neon|Ride"] = 131.06, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 128.63, ["Mega|Ride"] = 285.31, ["Mega|Fly|Ride"] = 319.5}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 1.79, ["Ride"] = 32.47, ["Neon"] = 3.59, ["Mega"] = 19.64, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 59.61, ["Mega|Fly|Ride"] = 341.94}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 22.23, ["Ride"] = 16.75, ["Fly|Ride"] = 58.97, ["Neon"] = 3.46, ["Neon|Fly"] = 111.47, ["Neon|Ride"] = 21.38, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 28.87, ["Mega|Fly"] = 143.16, ["Mega|Ride"] = 39.09, ["Mega|Fly|Ride"] = 103.95}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.86, ["Ride"] = 18.38, ["Fly|Ride"] = 42.14, ["Neon"] = 4.98, ["Neon|Fly"] = 53.44, ["Neon|Ride"] = 18.15, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 47.95, ["Mega|Fly"] = 143.2, ["Mega|Ride"] = 40.95, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 28.85, ["Ride"] = 54, ["Fly|Ride"] = 143.42, ["Neon"] = 7.55, ["Neon|Ride"] = 28.3, ["Neon|Fly|Ride"] = 111.97, ["Mega"] = 44.62, ["Mega|Ride"] = 80.84, ["Mega|Fly|Ride"] = 228.67}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.08, ["Neon|Ride"] = 32.07, ["Neon|Fly|Ride"] = 155830.42, ["Mega"] = 19.27, ["Mega|Fly"] = 96.8, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 136.4}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.89, ["Ride"] = 16.98, ["Fly|Ride"] = 81.31, ["Neon"] = 3.8, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 24.6, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 20.58, ["Mega|Fly"] = 64.13, ["Mega|Ride"] = 40.53, ["Mega|Fly|Ride"] = 103.25}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 18.38, ["Neon"] = 2.6, ["Neon|Ride"] = 40.62, ["Mega"] = 19.68, ["Mega|Ride"] = 186.27, ["Mega|Fly|Ride"] = 271.42}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 4.39, ["Neon|Ride"] = 323.05, ["Neon|Fly|Ride"] = 420, ["Mega"] = 25.35, ["Mega|Ride"] = 155.91}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 14.33, ["Fly|Ride"] = 49.87, ["Neon"] = 5.25, ["Neon|Fly"] = 32.81, ["Neon|Ride"] = 17.04, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 36.75, ["Mega|Fly"] = 45.24, ["Mega|Ride"] = 51.31, ["Mega|Fly|Ride"] = 107.58}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 8.6, ["Ride"] = 59.06, ["Fly|Ride"] = 213.68, ["Neon"] = 73.49, ["Mega"] = 570.64, ["Mega|Ride"] = 459.38}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.45, ["Fly"] = 6562.5, ["Ride"] = 56.44, ["Neon"] = 45.93}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 3.76, ["Ride"] = 30.5, ["Fly|Ride"] = 178.76, ["Neon"] = 26.25, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 427.44, ["Mega"] = 285.33, ["Mega|Ride"] = 413.53, ["Mega|Fly|Ride"] = 375.26}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 1.79, ["Fly"] = 13.12, ["Ride"] = 11.7, ["Fly|Ride"] = 25.61, ["Neon"] = 2.1, ["Neon|Fly"] = 15.63, ["Neon|Ride"] = 12.84, ["Neon|Fly|Ride"] = 27.5, ["Mega"] = 15.36, ["Mega|Fly"] = 24.94, ["Mega|Ride"] = 20.98, ["Mega|Fly|Ride"] = 50.61}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 60.38, ["Neon"] = 6.49, ["Neon|Fly"] = 67.79, ["Neon|Ride"] = 33.14, ["Neon|Fly|Ride"] = 712.77, ["Mega"] = 72.19, ["Mega|Ride"] = 117.93}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.4, ["Neon"] = 2.1, ["Neon|Fly"] = 31.56, ["Neon|Ride"] = 23.3, ["Neon|Fly|Ride"] = 84.16, ["Mega"] = 14.44, ["Mega|Fly"] = 90.57, ["Mega|Ride"] = 71.9, ["Mega|Fly|Ride"] = 135.95}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.83, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 127.32, ["Mega"] = 21, ["Mega|Fly|Ride"] = 170.98}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 41.99, ["Ride"] = 17.81, ["Fly|Ride"] = 61.69, ["Neon"] = 11.55, ["Neon|Ride"] = 32.38, ["Neon|Fly|Ride"] = 65.59, ["Mega"] = 183.75, ["Mega|Ride"] = 199.83, ["Mega|Fly|Ride"] = 291.38}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 153.22, ["Fly"] = 183.75, ["Ride"] = 211.46, ["Fly|Ride"] = 262.5, ["Neon"] = 935.93, ["Neon|Fly|Ride"] = 961.73, ["Mega"] = 8548.61, ["Mega|Ride"] = 3277.15, ["Mega|Fly|Ride"] = 3846.67}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 24.2, ["Neon"] = 8.05, ["Neon|Ride"] = 64.31, ["Mega"] = 89.98, ["Mega|Ride"] = 173.12, ["Mega|Fly|Ride"] = 635.78}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.83, ["Fly"] = 64.97, ["Ride"] = 26.25, ["Fly|Ride"] = 60.84, ["Neon"] = 31.61, ["Neon|Ride"] = 168.56, ["Neon|Fly|Ride"] = 143.2, ["Mega"] = 381.82, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 427.42}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 27.66, ["Ride"] = 14.84, ["Fly|Ride"] = 32.8, ["Neon"] = 4.5, ["Neon|Fly"] = 33.14, ["Neon|Ride"] = 29.76, ["Neon|Fly|Ride"] = 45.04, ["Mega"] = 49.68, ["Mega|Ride"] = 82.6, ["Mega|Fly|Ride"] = 143.19}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 71.59, ["Ride"] = 18.13, ["Fly|Ride"] = 92.58, ["Neon"] = 6.57, ["Neon|Fly"] = 570.49, ["Neon|Ride"] = 52.29, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 70.35, ["Mega|Ride"] = 193.58}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.75, ["Fly"] = 24.48, ["Ride"] = 15.31, ["Fly|Ride"] = 45.93, ["Neon"] = 23.63, ["Neon|Fly"] = 98.85, ["Neon|Ride"] = 43.31, ["Neon|Fly|Ride"] = 77.96, ["Mega|Ride"] = 285.31, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.22, ["Ride"] = 42.73, ["Fly|Ride"] = 256.41, ["Neon"] = 44.26, ["Neon|Ride"] = 143.49, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 262.48, ["Mega|Ride"] = 277.23, ["Mega|Fly|Ride"] = 1068.53}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 16.94, ["Ride"] = 15.64, ["Fly|Ride"] = 34.86, ["Neon"] = 23.66, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 36.2, ["Neon|Fly|Ride"] = 76.97, ["Mega"] = 131.25, ["Mega|Ride"] = 306.68, ["Mega|Fly|Ride"] = 223.12}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 46.78, ["Ride"] = 90.61, ["Fly|Ride"] = 142.94, ["Neon"] = 328.13, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 349.13, ["Neon|Fly|Ride"] = 426.57, ["Mega|Fly|Ride"] = 1359.09}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 209.98, ["Fly"] = 427.19, ["Ride"] = 241.75, ["Fly|Ride"] = 260.06, ["Neon|Ride"] = 2671.45, ["Neon|Fly|Ride"] = 925.1, ["Mega"] = 10685.76, ["Mega|Fly|Ride"] = 4940.82}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 56.32, ["Fly"] = 123.95, ["Ride"] = 66.72, ["Fly|Ride"] = 118.02, ["Neon"] = 262.5, ["Neon|Ride"] = 290.34, ["Neon|Fly|Ride"] = 347.82, ["Mega|Fly|Ride"] = 1816.48}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 9.1, ["Fly"] = 287.89, ["Ride"] = 36.33, ["Fly|Ride"] = 81.06, ["Neon"] = 24.93, ["Neon|Fly"] = 85.5, ["Neon|Ride"] = 122.13, ["Neon|Fly|Ride"] = 181.12, ["Mega"] = 262.49, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 416.72}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 10.39, ["Fly"] = 71.56, ["Ride"] = 19.29, ["Fly|Ride"] = 65.36, ["Neon"] = 92.96, ["Neon|Ride"] = 126.27, ["Neon|Fly|Ride"] = 199.84, ["Mega"] = 354.38, ["Mega|Ride"] = 397.68, ["Mega|Fly|Ride"] = 448.79}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.16, ["Ride"] = 18.22, ["Fly|Ride"] = 44.51, ["Neon"] = 5.25, ["Neon|Fly"] = 32.07, ["Neon|Ride"] = 20.79, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 114.58, ["Mega|Fly"] = 154.88, ["Mega|Ride"] = 111.57, ["Mega|Fly|Ride"] = 125.13}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.02, ["Fly"] = 72.12, ["Ride"] = 22.55, ["Fly|Ride"] = 81.38, ["Neon"] = 152.45, ["Neon|Fly"] = 356.83, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 184.52, ["Mega"] = 1837.5, ["Mega|Ride"] = 549.28, ["Mega|Fly|Ride"] = 732.38}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.9, ["Ride"] = 15.47, ["Fly|Ride"] = 32.82, ["Neon"] = 13.12, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 31.47, ["Neon|Fly|Ride"] = 104.73, ["Mega"] = 144.38, ["Mega|Ride"] = 283.02, ["Mega|Fly|Ride"] = 178.37}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 4.68, ["Ride"] = 27.56, ["Fly|Ride"] = 328.13, ["Neon"] = 21.38, ["Neon|Ride"] = 35.76, ["Mega"] = 207.37, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 310.55}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 34.2, ["Ride"] = 19.35, ["Neon"] = 2.1, ["Neon|Ride"] = 19.66, ["Neon|Fly|Ride"] = 57.73, ["Mega"] = 14.58, ["Mega|Ride"] = 42.75, ["Mega|Fly|Ride"] = 78.73}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.63, ["Fly"] = 19.59, ["Ride"] = 18.27, ["Fly|Ride"] = 42.74, ["Neon"] = 15.21, ["Neon|Fly"] = 106.85, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 147, ["Mega"] = 78.75, ["Mega|Fly|Ride"] = 159.92}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 25.71, ["Ride"] = 17.07, ["Fly|Ride"] = 61.73, ["Neon"] = 21.07, ["Neon|Ride"] = 47.25, ["Mega"] = 131.17, ["Mega|Ride"] = 207.32, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 100.99, ["Fly"] = 170.44, ["Ride"] = 141.05, ["Fly|Ride"] = 225.75, ["Neon"] = 712.57, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 590.63, ["Mega"] = 4274.31, ["Mega|Ride"] = 2778.16, ["Mega|Fly|Ride"] = 2142.94}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.35, ["Ride"] = 32.83, ["Fly|Ride"] = 129.45, ["Neon"] = 45.17, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 376.56, ["Mega"] = 262.5, ["Mega|Ride"] = 413.45, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 42.73, ["Ride"] = 15.75, ["Fly|Ride"] = 41.68, ["Neon"] = 12.84, ["Neon|Ride"] = 28.87, ["Neon|Fly|Ride"] = 120.74, ["Mega"] = 241.99, ["Mega|Ride"] = 267.39, ["Mega|Fly|Ride"] = 285.79}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 20.98, ["Ride"] = 57.68, ["Fly|Ride"] = 170.63, ["Neon"] = 118.01, ["Neon|Ride"] = 207.32, ["Neon|Fly|Ride"] = 700.88, ["Mega"] = 712.77, ["Mega|Fly"] = 854.87, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 630.44}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 8.93}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 3.46, ["Ride"] = 28.71, ["Fly|Ride"] = 125.25, ["Neon"] = 36.35, ["Neon|Ride"] = 104.73, ["Mega"] = 285.92, ["Mega|Ride"] = 510.77, ["Mega|Fly|Ride"] = 888.03}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 28.77, ["Fly"] = 39.78, ["Ride"] = 24.22, ["Fly|Ride"] = 41.91, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 162.64, ["Neon|Fly|Ride"] = 183.1, ["Mega"] = 1379.55, ["Mega|Fly|Ride"] = 541.75}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 18.68, ["Fly|Ride"] = 65.63, ["Neon"] = 3.67, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 106.31, ["Mega"] = 28.73, ["Mega|Fly"] = 188.99, ["Mega|Ride"] = 57.66, ["Mega|Fly|Ride"] = 228.79}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 3.94, ["Fly"] = 28.41, ["Ride"] = 24.59, ["Fly|Ride"] = 64.12, ["Neon"] = 55.04, ["Neon|Ride"] = 64.13, ["Mega"] = 281.48, ["Mega|Fly"] = 404.11, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 399.65}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 16.04, ["Fly|Ride"] = 28.81, ["Neon"] = 17.62, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 35.43, ["Neon|Fly|Ride"] = 77.43, ["Mega"] = 138.89, ["Mega|Ride"] = 183.65, ["Mega|Fly|Ride"] = 262.87}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 26.16, ["Fly|Ride"] = 213.68, ["Neon"] = 3.46, ["Neon|Fly"] = 37.42, ["Neon|Ride"] = 32.33, ["Neon|Fly|Ride"] = 213.72, ["Mega"] = 31.4, ["Mega|Ride"] = 55.04, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 23.94, ["Ride"] = 74.82, ["Fly|Ride"] = 144.38, ["Neon"] = 280.54, ["Neon|Ride"] = 280.88, ["Neon|Fly|Ride"] = 576.19, ["Mega"] = 850.61, ["Mega|Ride"] = 998.01, ["Mega|Fly|Ride"] = 1174.31}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.89, ["Ride"] = 28.85, ["Fly|Ride"] = 210, ["Neon"] = 92.54, ["Mega"] = 143.2, ["Mega|Ride"] = 342.67}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 15.64, ["Fly"] = 34.13, ["Ride"] = 21.95, ["Fly|Ride"] = 41.91, ["Neon"] = 21.1, ["Neon|Fly"] = 84, ["Neon|Ride"] = 36.35, ["Neon|Fly|Ride"] = 118.58, ["Mega"] = 372.44, ["Mega|Ride"] = 288.51, ["Mega|Fly|Ride"] = 421.32}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 65.63, ["Fly"] = 433.12, ["Ride"] = 393.73, ["Fly|Ride"] = 262.47, ["Neon"] = 354.38, ["Neon|Ride"] = 555.68, ["Mega"] = 4518.89, ["Mega|Ride"] = 2165.63, ["Mega|Fly|Ride"] = 1836.19}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 8.56, ["Fly"] = 44.84, ["Ride"] = 27.57, ["Fly|Ride"] = 57.65, ["Neon"] = 57.71, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 53.57, ["Neon|Fly|Ride"] = 114.18, ["Mega"] = 241.87, ["Mega|Ride"] = 288.51, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 70.16, ["Fly"] = 170.88, ["Ride"] = 88.6, ["Fly|Ride"] = 150.94, ["Neon"] = 266.44, ["Neon|Ride"] = 232.49, ["Mega"] = 1140.18, ["Mega|Ride"] = 901.78, ["Mega|Fly|Ride"] = 1092.91}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 17.99, ["Ride"] = 43.64, ["Fly|Ride"] = 106.81, ["Neon"] = 79.62, ["Neon|Ride"] = 103.95, ["Neon|Fly|Ride"] = 170.62, ["Mega"] = 354.38, ["Mega|Ride"] = 355.49, ["Mega|Fly|Ride"] = 413.44}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 8.72, ["Fly"] = 41.36, ["Ride"] = 28.84, ["Fly|Ride"] = 64.1, ["Neon"] = 84.81, ["Neon|Ride"] = 144.16, ["Neon|Fly|Ride"] = 384.76, ["Mega"] = 213.72, ["Mega|Ride"] = 1602.79, ["Mega|Fly|Ride"] = 533.21}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 14.05, ["Fly"] = 70.52, ["Ride"] = 44.63, ["Fly|Ride"] = 162.54, ["Neon"] = 59.94, ["Neon|Ride"] = 99.03, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 356.78, ["Mega|Ride"] = 280.87, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 5.49, ["Ride"] = 24.93, ["Fly|Ride"] = 89.75, ["Neon"] = 42.73, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 141.16, ["Mega"] = 238.9, ["Mega|Ride"] = 265.21, ["Mega|Fly|Ride"] = 403.92}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Fly|Ride"] = 100.41, ["Neon"] = 2.35, ["Neon|Ride"] = 57.68, ["Mega"] = 19.15, ["Mega|Ride"] = 135.72, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 2.1, ["Ride"] = 21.37, ["Neon"] = 24.04, ["Neon|Fly"] = 128.21, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 157.5, ["Mega|Ride"] = 271.42, ["Mega|Fly|Ride"] = 425.28}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 127.1, ["Neon"] = 28.74, ["Neon|Fly"] = 116.94, ["Neon|Ride"] = 315, ["Mega"] = 174.03, ["Mega|Ride"] = 141.3, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 3.94, ["Ride"] = 32.79, ["Fly|Ride"] = 120.99, ["Neon"] = 30.99, ["Neon|Ride"] = 80.16, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 124.69, ["Mega|Ride"] = 285.31, ["Mega|Fly|Ride"] = 4274.07}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 499.11, ["Fly"] = 523.69, ["Ride"] = 594.63, ["Fly|Ride"] = 640.49, ["Neon"] = 1852.45, ["Neon|Ride"] = 2137.16, ["Neon|Fly|Ride"] = 1824.78, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 4.77, ["Fly"] = 28.86, ["Ride"] = 20.43, ["Fly|Ride"] = 56.35, ["Neon"] = 41.68, ["Neon|Ride"] = 62.91, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 137.82, ["Mega|Ride"] = 366.62, ["Mega|Fly|Ride"] = 512.91}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 7.07, ["Fly"] = 524.9, ["Ride"] = 29.04, ["Fly|Ride"] = 51.54, ["Neon"] = 39.36, ["Neon|Fly"] = 315, ["Neon|Ride"] = 98.34, ["Neon|Fly|Ride"] = 170.99, ["Mega"] = 331.86, ["Mega|Ride"] = 485.13, ["Mega|Fly|Ride"] = 681.35}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.1, ["Fly"] = 91.87, ["Ride"] = 27.2, ["Fly|Ride"] = 52.5, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 131.25}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.59, ["Ride"] = 23.08, ["Fly|Ride"] = 72.66, ["Neon"] = 6.97, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 89.49, ["Mega"] = 64.67, ["Mega|Fly"] = 285.33, ["Mega|Ride"] = 88.64, ["Mega|Fly|Ride"] = 210.5}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 71.59, ["Ride"] = 16.95, ["Neon"] = 2.1, ["Neon|Ride"] = 24.34, ["Neon|Fly|Ride"] = 127.17, ["Mega"] = 20.26, ["Mega|Ride"] = 65.54, ["Mega|Fly|Ride"] = 221.55}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1108.96}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 4.71, ["Ride"] = 36.73, ["Fly|Ride"] = 105, ["Neon"] = 52.5, ["Neon|Ride"] = 91.75, ["Neon|Fly|Ride"] = 323.05, ["Mega"] = 425.31, ["Mega|Ride"] = 580.73, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 26.93, ["Neon"] = 6.13, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 982.1, ["Mega"] = 32.82, ["Mega|Ride"] = 106.86, ["Mega|Fly|Ride"] = 251.34}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 5.15, ["Fly"] = 27.17, ["Ride"] = 63.95, ["Neon"] = 28.77, ["Neon|Ride"] = 71.61, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 196.87, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 1068.53}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 418.69, ["Ride"] = 525, ["Fly|Ride"] = 498.75, ["Neon|Ride"] = 2384.82, ["Neon|Fly|Ride"] = 1709.73, ["Mega"] = 8873.23, ["Mega|Fly|Ride"] = 6298.69}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 4.6, ["Fly"] = 196.88, ["Ride"] = 57.68, ["Fly|Ride"] = 427.33, ["Neon"] = 29.86, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 193.59, ["Mega"] = 533.23, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 742.85}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Ride"] = 23.78, ["Fly|Ride"] = 118.13, ["Neon"] = 3.77, ["Neon|Ride"] = 36.66, ["Neon|Fly|Ride"] = 123.99, ["Mega"] = 37.97, ["Mega|Fly"] = 128.45, ["Mega|Ride"] = 71.97, ["Mega|Fly|Ride"] = 208.11}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 4.1, ["Neon|Ride"] = 129.92, ["Neon|Fly|Ride"] = 285.33, ["Mega"] = 31.35, ["Mega|Ride"] = 136.15, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 17.19, ["Fly"] = 107.63, ["Ride"] = 111.57, ["Fly|Ride"] = 157.45, ["Neon"] = 149.63, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 622.91, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 544.69}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 8.31, ["Ride"] = 71.31, ["Neon"] = 80.33, ["Neon|Ride"] = 169.42, ["Neon|Fly|Ride"] = 508.66, ["Mega"] = 592.02, ["Mega|Ride"] = 479.73, ["Mega|Fly|Ride"] = 570.61}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 4.19, ["Ride"] = 31.4, ["Neon"] = 96.94, ["Neon|Ride"] = 182.73, ["Mega"] = 661.82, ["Mega|Ride"] = 1097.38, ["Mega|Fly|Ride"] = 1282.23}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 8.56, ["Ride"] = 23.63, ["Fly|Ride"] = 262.5, ["Neon"] = 131.24, ["Neon|Ride"] = 182.44, ["Neon|Fly|Ride"] = 213.72, ["Mega"] = 616.77, ["Mega|Ride"] = 1300.04, ["Mega|Fly|Ride"] = 509.25}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 361.85, ["Ride"] = 384.38, ["Fly|Ride"] = 779.06, ["Neon"] = 1365, ["Neon|Ride"] = 1068.59, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 3055.52}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 5.71, ["Fly"] = 78.75, ["Ride"] = 26.25, ["Fly|Ride"] = 64.3, ["Neon"] = 188.3, ["Neon|Ride"] = 192.42, ["Neon|Fly|Ride"] = 197.9, ["Mega|Ride"] = 768.48, ["Mega|Fly|Ride"] = 879.41}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.64, ["Ride"] = 42.68, ["Fly|Ride"] = 127.32, ["Neon"] = 64.97, ["Neon|Ride"] = 221.82, ["Mega"] = 367.5, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1068.53}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 18.8, ["Ride"] = 78.75, ["Fly|Ride"] = 236.25, ["Neon"] = 81.37, ["Neon|Ride"] = 158.83, ["Neon|Fly|Ride"] = 260.78, ["Mega"] = 298.64, ["Mega|Ride"] = 325.5, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.62, ["Ride"] = 42.73, ["Fly|Ride"] = 143.12, ["Neon"] = 6.48, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 213.72, ["Mega"] = 46.92, ["Mega|Ride"] = 128.29, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 36.92, ["Ride"] = 79.86, ["Neon"] = 384.6, ["Neon|Ride"] = 426.38, ["Neon|Fly|Ride"] = 512.93, ["Mega"] = 1693.84, ["Mega|Ride"] = 2137.04, ["Mega|Fly|Ride"] = 1206.14}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 521, ["Ride"] = 25.99, ["Fly|Ride"] = 60.89, ["Neon"] = 7.33, ["Neon|Fly"] = 185.91, ["Neon|Ride"] = 64.03, ["Neon|Fly|Ride"] = 135.72, ["Mega"] = 72.19, ["Mega|Ride"] = 94.4, ["Mega|Fly|Ride"] = 280.88}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 27.83, ["Neon"] = 3.74, ["Neon|Fly"] = 49.39, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 111.15, ["Mega"] = 57.69, ["Mega|Fly"] = 112.88, ["Mega|Ride"] = 76.6, ["Mega|Fly|Ride"] = 170.35}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 37.97, ["Fly|Ride"] = 127.52, ["Neon"] = 9.91, ["Neon|Ride"] = 61.99, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 91.91, ["Mega|Fly"] = 459.38, ["Mega|Ride"] = 128.25, ["Mega|Fly|Ride"] = 315.23}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 45.08, ["Ride"] = 61.67, ["Fly|Ride"] = 169.32, ["Neon"] = 271.01, ["Neon|Ride"] = 317.25, ["Neon|Fly|Ride"] = 483.96, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 203.44, ["Ride"] = 278.16, ["Fly|Ride"] = 426.27, ["Neon"] = 1462.13, ["Neon|Ride"] = 1177.51, ["Neon|Fly|Ride"] = 1329.83, ["Mega"] = 9678.99, ["Mega|Fly|Ride"] = 5307.51}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 4.31, ["Neon"] = 26.17, ["Neon|Fly"] = 350.44, ["Neon|Ride"] = 106.87, ["Mega"] = 105.14, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 197.57}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 25.65, ["Neon"] = 6.56, ["Neon|Ride"] = 35.17, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 52.41, ["Mega|Fly"] = 164.07, ["Mega|Ride"] = 90.37, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.7, ["Fly"] = 162.07, ["Ride"] = 27.57, ["Fly|Ride"] = 81.06, ["Neon"] = 32.81, ["Mega"] = 141.95, ["Mega|Ride"] = 351.74, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.61, ["Fly"] = 90.96, ["Ride"] = 29.95, ["Fly|Ride"] = 81.06, ["Neon"] = 12.29, ["Neon|Ride"] = 46.46, ["Neon|Fly|Ride"] = 158.17, ["Mega"] = 124.41, ["Mega|Ride"] = 221.9, ["Mega|Fly|Ride"] = 256.46}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 59.06, ["Neon"] = 8.54, ["Neon|Fly|Ride"] = 143.2, ["Mega"] = 52.5, ["Mega|Ride"] = 143.19, ["Mega|Fly|Ride"] = 284.24}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 28.86, ["Ride"] = 17.92, ["Fly|Ride"] = 52.49, ["Neon"] = 4.19, ["Neon|Fly"] = 81.09, ["Neon|Ride"] = 24.22, ["Neon|Fly|Ride"] = 58.09, ["Mega"] = 85.92, ["Mega|Ride"] = 95.72, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.63, ["Fly"] = 26.25, ["Ride"] = 24.94, ["Fly|Ride"] = 41.32, ["Neon"] = 15.17, ["Neon|Fly"] = 64.97, ["Neon|Ride"] = 38.66, ["Neon|Fly|Ride"] = 96.8, ["Mega"] = 105, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 170.22}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 18.96, ["Ride"] = 37.01, ["Fly|Ride"] = 78.74, ["Neon"] = 136.5, ["Neon|Ride"] = 614.44, ["Neon|Fly|Ride"] = 323.78, ["Mega"] = 393.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 527.68}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 70.88, ["Ride"] = 84.2, ["Fly|Ride"] = 137.73, ["Neon"] = 410.81, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 3226.75, ["Mega|Ride"] = 3254.99, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 17.88, ["Fly|Ride"] = 144.38, ["Neon"] = 3.45, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 26.2, ["Neon|Fly|Ride"] = 128.47, ["Mega"] = 45.85, ["Mega|Fly"] = 672, ["Mega|Ride"] = 92.8, ["Mega|Fly|Ride"] = 246.75}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 14.23, ["Ride"] = 15.02, ["Fly|Ride"] = 26.25, ["Neon"] = 3.86, ["Neon|Fly"] = 28.41, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 61.68, ["Mega"] = 40.52, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 66.94, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 6.17, ["Fly"] = 42.75, ["Ride"] = 48.76, ["Fly|Ride"] = 131.25, ["Neon"] = 48.37, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 285.33, ["Mega"] = 527.62, ["Mega|Ride"] = 274.32, ["Mega|Fly|Ride"] = 646.06}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.65, ["Fly"] = 518.44, ["Ride"] = 472.5, ["Fly|Ride"] = 577.5, ["Neon|Ride"] = 1936.03, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 8065.92}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 21.6, ["Fly"] = 100.44, ["Ride"] = 40.71, ["Fly|Ride"] = 107.5, ["Neon"] = 241.5, ["Neon|Ride"] = 225.73, ["Neon|Fly|Ride"] = 474.29, ["Mega|Ride"] = 880.69, ["Mega|Fly|Ride"] = 1935.73}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 25.85, ["Fly|Ride"] = 281.33, ["Neon"] = 8.89, ["Neon|Ride"] = 45.39, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 99.65, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 271.98}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 65.61, ["Fly|Ride"] = 143.05, ["Neon"] = 17.11}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 72.27, ["Fly"] = 169.3, ["Ride"] = 37.59, ["Fly|Ride"] = 104.81, ["Neon"] = 129.94, ["Neon|Ride"] = 274.65, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 2564.6, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1282.23}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 81.1, ["Fly"] = 104.9, ["Ride"] = 113.43, ["Fly|Ride"] = 192.24, ["Neon"] = 430.1, ["Neon|Ride"] = 484.02, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 8548.61, ["Mega|Fly|Ride"] = 2350.74}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 218.34, ["Ride"] = 284.81, ["Fly|Ride"] = 352, ["Neon"] = 1050, ["Neon|Ride"] = 800.63, ["Neon|Fly|Ride"] = 983.78, ["Mega|Fly|Ride"] = 4147.5}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 10.5, ["Ride"] = 34.13, ["Fly|Ride"] = 96.17, ["Neon"] = 85.21, ["Neon|Ride"] = 124.68, ["Neon|Fly|Ride"] = 356.92, ["Mega"] = 389.79, ["Mega|Ride"] = 404.79, ["Mega|Fly|Ride"] = 1060.01}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 19.47, ["Ride"] = 15.74, ["Fly|Ride"] = 42.95, ["Neon"] = 6.48, ["Neon|Ride"] = 23.15, ["Neon|Fly|Ride"] = 92.98, ["Mega"] = 84.28, ["Mega|Ride"] = 104.98, ["Mega|Fly|Ride"] = 170.31}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 3.94, ["Fly"] = 39.2, ["Ride"] = 18.37, ["Fly|Ride"] = 53.43, ["Neon"] = 24.75, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 36.9, ["Neon|Fly|Ride"] = 78.56, ["Mega"] = 350.52, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 366.05}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 317.97, ["Fly"] = 498.93, ["Ride"] = 450.27, ["Fly|Ride"] = 498.91, ["Neon"] = 1968.75, ["Mega"] = 10258.34, ["Mega|Fly|Ride"] = 6516.88}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Neon"] = 8.54, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 28.7, ["Mega|Ride"] = 170.99, ["Mega|Fly|Ride"] = 450.13}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.52, ["Ride"] = 15.74, ["Fly|Ride"] = 57.7, ["Neon"] = 38.66, ["Neon|Ride"] = 37.93, ["Neon|Fly|Ride"] = 84, ["Mega"] = 236.17, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 196.32, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 9.08, ["Ride"] = 84.84, ["Neon"] = 81.46, ["Neon|Fly"] = 427.44, ["Neon|Ride"] = 236.25, ["Mega"] = 548.63, ["Mega|Ride"] = 609, ["Mega|Fly|Ride"] = 600.18}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 104.9, ["Fly"] = 157.5, ["Ride"] = 103.69, ["Fly|Ride"] = 127.03, ["Neon|Ride"] = 273.48, ["Neon|Fly|Ride"] = 568.32, ["Mega|Fly|Ride"] = 2379.57}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 16.51, ["Fly"] = 24.33, ["Ride"] = 26.42, ["Fly|Ride"] = 48.88, ["Neon"] = 130.5, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 807, ["Mega"] = 712.77, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 485.34}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 39.37, ["Neon"] = 2.1, ["Neon|Ride"] = 39.38, ["Mega"] = 24.94, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 19.23, ["Fly|Ride"] = 71.59, ["Neon"] = 3.28, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 80.3, ["Mega"] = 23.55, ["Mega|Fly"] = 92.26, ["Mega|Ride"] = 57.71, ["Mega|Fly|Ride"] = 109.98}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 10.18, ["Ride"] = 77.38, ["Fly|Ride"] = 135.06, ["Neon"] = 31.4, ["Neon|Ride"] = 86.41, ["Neon|Fly|Ride"] = 203.43, ["Mega"] = 172.73, ["Mega|Ride"] = 196.86, ["Mega|Fly|Ride"] = 299}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1168.12, ["Fly"] = 1669.38, ["Ride"] = 1443.74, ["Fly|Ride"] = 1435.88, ["Neon"] = 4200, ["Neon|Ride"] = 5250, ["Neon|Fly|Ride"] = 4131.12, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 446.25, ["Ride"] = 479.07, ["Fly|Ride"] = 773.47, ["Neon"] = 2508.38, ["Neon|Ride"] = 2280.35, ["Neon|Fly|Ride"] = 2280.35, ["Mega"] = 17097.21, ["Mega|Fly|Ride"] = 7195.39}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 301.88, ["Fly"] = 422.91, ["Ride"] = 315.09, ["Fly|Ride"] = 392.77, ["Neon"] = 787.4, ["Neon|Ride"] = 721.77, ["Neon|Fly|Ride"] = 787.4, ["Mega|Fly|Ride"] = 2916.24}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 227.39, ["Fly"] = 334.69, ["Ride"] = 321.4, ["Fly|Ride"] = 393.75, ["Neon"] = 777, ["Neon|Ride"] = 761.24, ["Neon|Fly|Ride"] = 923.14, ["Mega|Fly|Ride"] = 4273}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 64.31, ["Ride"] = 16.02, ["Fly|Ride"] = 39.12, ["Neon"] = 5.13, ["Neon|Ride"] = 30.45, ["Neon|Fly|Ride"] = 105, ["Mega"] = 69.43, ["Mega|Fly"] = 114.35, ["Mega|Ride"] = 82.69, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 315.95, ["Fly"] = 1425.19, ["Ride"] = 369.23, ["Fly|Ride"] = 498.75, ["Neon"] = 1706.25, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1425.5, ["Mega"] = 21656.82, ["Mega|Ride"] = 5128.89, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.67, ["Fly"] = 157.5, ["Ride"] = 112.52, ["Fly|Ride"] = 91.87, ["Neon"] = 21.62, ["Neon|Ride"] = 213.72, ["Neon|Fly|Ride"] = 252, ["Mega"] = 131.1, ["Mega|Ride"] = 235.5, ["Mega|Fly|Ride"] = 507.55}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 18.12, ["Ride"] = 15.12, ["Fly|Ride"] = 39.38, ["Neon"] = 12.11, ["Neon|Ride"] = 28.87, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 104.81, ["Mega|Ride"] = 192.93, ["Mega|Fly|Ride"] = 153.88}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 3.82, ["Neon|Ride"] = 39.38, ["Mega"] = 29.59, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 236.16}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 28.76, ["Ride"] = 56.86, ["Fly|Ride"] = 459.38, ["Neon"] = 273, ["Neon|Ride"] = 420, ["Mega"] = 1050, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 8038.15, ["Ride"] = 26.25, ["Fly|Ride"] = 68.25, ["Neon"] = 26.07, ["Neon|Ride"] = 61.13, ["Mega|Ride"] = 413.53, ["Mega|Fly|Ride"] = 427.42}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.05, ["Ride"] = 47.25, ["Neon"] = 3.39, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 104.99, ["Mega"] = 22.44, ["Mega|Ride"] = 68.01, ["Mega|Fly|Ride"] = 165.8}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 4.9, ["Fly"] = 41.02, ["Ride"] = 21.17, ["Fly|Ride"] = 78.65, ["Neon"] = 13.83, ["Neon|Fly"] = 113.9, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 77.52, ["Mega"] = 131.15, ["Mega|Ride"] = 119.76, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.84, ["Fly"] = 57.7, ["Ride"] = 22.32, ["Fly|Ride"] = 52.5, ["Neon"] = 30.19, ["Neon|Fly"] = 145.18, ["Neon|Ride"] = 143.2, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 238.82, ["Mega|Ride"] = 251.07, ["Mega|Fly|Ride"] = 1321.69}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 12.48, ["Ride"] = 63.03, ["Neon"] = 79.07, ["Neon|Ride"] = 382.57, ["Neon|Fly|Ride"] = 284.34, ["Mega"] = 285.33, ["Mega|Ride"] = 413.53}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 3.75, ["Fly"] = 6450.46, ["Ride"] = 19.69, ["Neon"] = 39.38, ["Neon|Fly"] = 47.25, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 725.93, ["Mega"] = 308.44, ["Mega|Ride"] = 422.08, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 64.58, ["Ride"] = 18.38, ["Fly|Ride"] = 38.47, ["Neon"] = 3.85, ["Neon|Fly"] = 32.07, ["Neon|Ride"] = 27.83, ["Neon|Fly|Ride"] = 85.5, ["Mega"] = 41.36, ["Mega|Ride"] = 182.7, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 163.58, ["Fly"] = 260.58, ["Ride"] = 164.07, ["Fly|Ride"] = 229.69, ["Neon"] = 956.15, ["Neon|Ride"] = 923.26, ["Neon|Fly|Ride"] = 838.69, ["Mega"] = 8548.61, ["Mega|Fly|Ride"] = 3548.55}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 19.03, ["Ride"] = 15.1, ["Fly|Ride"] = 41.9, ["Neon"] = 3.73, ["Neon|Fly"] = 24.59, ["Neon|Ride"] = 24.74, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 38.07, ["Mega|Ride"] = 52.76, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 7.05, ["Ride"] = 28.85, ["Fly|Ride"] = 196.87, ["Neon"] = 59.85, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 313.69, ["Mega|Fly"] = 807, ["Mega|Ride"] = 334.69, ["Mega|Fly|Ride"] = 379.32}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 24.86, ["Ride"] = 81.25, ["Fly|Ride"] = 170.63, ["Neon"] = 145.16, ["Neon|Ride"] = 272.94, ["Mega"] = 998.07, ["Mega|Ride"] = 514.69, ["Mega|Fly|Ride"] = 974.5}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 181.8, ["Ride"] = 220.83, ["Fly|Ride"] = 321.5, ["Neon"] = 780.36, ["Neon|Ride"] = 682.5, ["Neon|Fly|Ride"] = 992.58, ["Mega|Fly|Ride"] = 3355.14}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 4.29, ["Ride"] = 158.3, ["Fly|Ride"] = 143.17, ["Neon"] = 41.68, ["Mega"] = 287.44, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 589.2}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 4.29, ["Ride"] = 57.75, ["Fly|Ride"] = 185.91, ["Neon"] = 105, ["Neon|Fly"] = 162.11, ["Neon|Ride"] = 199, ["Neon|Fly|Ride"] = 158.17, ["Mega"] = 771.89, ["Mega|Ride"] = 854.82, ["Mega|Fly|Ride"] = 998.01}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 958.11, ["Fly"] = 1050, ["Ride"] = 1029.11, ["Fly|Ride"] = 1179.93, ["Neon|Ride"] = 4530.77, ["Neon|Fly|Ride"] = 4836.39, ["Mega|Fly|Ride"] = 20301.8}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 5.24, ["Fly"] = 20.99, ["Ride"] = 20.1, ["Fly|Ride"] = 52.5, ["Neon"] = 16.05, ["Neon|Fly"] = 48.41, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 213.72, ["Mega"] = 229.89, ["Mega|Ride"] = 199.83, ["Mega|Fly|Ride"] = 410.33}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 2.1, ["Fly"] = 78.75, ["Ride"] = 35.32, ["Fly|Ride"] = 135.19, ["Neon"] = 36.35, ["Neon|Ride"] = 108.91, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 252.19, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 297.64, ["Mega|Fly|Ride"] = 998.01}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 84.41, ["Ride"] = 29.67, ["Fly|Ride"] = 69.57, ["Neon"] = 9.19, ["Neon|Ride"] = 45.61, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 105, ["Mega|Ride"] = 243.06, ["Mega|Fly|Ride"] = 570.61}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 12.86, ["Fly"] = 57.84, ["Ride"] = 32.47, ["Fly|Ride"] = 85.65, ["Neon"] = 78.65, ["Neon|Fly"] = 143.36, ["Neon|Ride"] = 78.61, ["Neon|Fly|Ride"] = 196.54, ["Mega"] = 483.96, ["Mega|Ride"] = 344.33, ["Mega|Fly|Ride"] = 438.38}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.1, ["Fly"] = 20.47, ["Ride"] = 16.04, ["Fly|Ride"] = 48.54, ["Neon"] = 16.89, ["Neon|Fly"] = 42.73, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 100.44, ["Mega|Fly"] = 256.47, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 17.11, ["Neon"] = 10.36, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 52.17, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 148.98, ["Mega|Ride"] = 199.38, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 178.99, ["Ride"] = 283.84, ["Fly|Ride"] = 384.6, ["Neon|Fly|Ride"] = 1182.56}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 4.23, ["Fly"] = 32.8, ["Ride"] = 24.59, ["Fly|Ride"] = 108.94, ["Neon"] = 6.01, ["Neon|Ride"] = 32.61, ["Neon|Fly|Ride"] = 127.42, ["Mega"] = 65.65, ["Mega|Fly"] = 427.44, ["Mega|Ride"] = 120.83, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 2.1, ["Ride"] = 82.01, ["Fly|Ride"] = 88.86, ["Neon"] = 27.45, ["Neon|Ride"] = 188.27, ["Mega"] = 175.88, ["Mega|Ride"] = 318.94}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.63, ["Fly"] = 98.86, ["Ride"] = 42.74, ["Neon"] = 27.9, ["Neon|Ride"] = 51.98, ["Mega"] = 84.96, ["Mega|Ride"] = 174.57, ["Mega|Fly|Ride"] = 512.44}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 120.47, ["Ride"] = 322.89, ["Fly|Ride"] = 308.44, ["Neon"] = 636.72, ["Neon|Ride"] = 1596.47, ["Neon|Fly|Ride"] = 679.63, ["Mega|Ride"] = 4274.07, ["Mega|Fly|Ride"] = 3205.56}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 20.45, ["Fly"] = 120.99, ["Ride"] = 48.38, ["Fly|Ride"] = 228.64, ["Neon"] = 149.5, ["Neon|Ride"] = 163.46, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 590.63, ["Mega|Ride"] = 598.39, ["Mega|Fly|Ride"] = 879.38}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 17.92, ["Fly"] = 322.89, ["Ride"] = 32.82, ["Fly|Ride"] = 94.21, ["Neon"] = 118.13, ["Neon|Ride"] = 124.68, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 432.16, ["Mega|Ride"] = 435.2, ["Mega|Fly|Ride"] = 528.93}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 15.75, ["Neon"] = 3.8, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 210, ["Mega"] = 76.13, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 254.33}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 64.75, ["Fly"] = 70.54, ["Ride"] = 74.91, ["Fly|Ride"] = 157.4, ["Neon"] = 315, ["Neon|Fly"] = 286.78, ["Neon|Ride"] = 324.19, ["Neon|Fly|Ride"] = 277.93, ["Mega|Fly|Ride"] = 1011.71}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.66, ["Fly|Ride"] = 41.68, ["Neon"] = 3.84, ["Neon|Ride"] = 57.71, ["Neon|Fly|Ride"] = 127.17, ["Mega"] = 58.91}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 15.16, ["Fly"] = 129.45, ["Ride"] = 24.85, ["Fly|Ride"] = 87.12, ["Neon"] = 67.56, ["Neon|Ride"] = 118.12, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 393.75, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 426.36, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 43.89, ["Fly"] = 131.25, ["Ride"] = 94.89, ["Fly|Ride"] = 150.22, ["Neon"] = 244.01, ["Neon|Ride"] = 262.4, ["Neon|Fly|Ride"] = 321.59, ["Mega|Ride"] = 1995.99, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 17.11, ["Ride"] = 16.03, ["Fly|Ride"] = 35.44, ["Neon"] = 2.1, ["Neon|Fly"] = 24.59, ["Neon|Ride"] = 17.1, ["Neon|Fly|Ride"] = 38.16, ["Mega"] = 16.59, ["Mega|Fly"] = 121, ["Mega|Ride"] = 36.35, ["Mega|Fly|Ride"] = 95.71}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.02, ["Ride"] = 52.49, ["Fly|Ride"] = 131.15, ["Neon"] = 18.3, ["Neon|Ride"] = 64.13, ["Neon|Fly|Ride"] = 291.38, ["Mega"] = 131.25, ["Mega|Ride"] = 278.92, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 12.48, ["Ride"] = 43.21, ["Fly|Ride"] = 85.32, ["Neon"] = 111.56, ["Neon|Fly|Ride"] = 273, ["Mega"] = 425.39, ["Mega|Ride"] = 450.21, ["Mega|Fly|Ride"] = 675.56}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 22.2, ["Neon"] = 2.1, ["Neon|Ride"] = 28.86, ["Neon|Fly|Ride"] = 139.99, ["Mega"] = 19.64, ["Mega|Ride"] = 85.61, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 18.6, ["Fly"] = 197.3, ["Ride"] = 68.92, ["Fly|Ride"] = 177.3, ["Neon"] = 63.55, ["Neon|Ride"] = 170.99, ["Neon|Fly|Ride"] = 443.63, ["Mega"] = 459.38, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 488.24, ["Mega|Fly|Ride"] = 453.74}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 9.09, ["Fly"] = 42.79, ["Ride"] = 21.56, ["Fly|Ride"] = 98.44, ["Neon"] = 408.98, ["Neon|Ride"] = 113.54, ["Neon|Fly|Ride"] = 129.94, ["Mega|Fly|Ride"] = 646.06}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.36, ["Ride"] = 38.18, ["Neon"] = 23.81, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 57.68, ["Neon|Fly|Ride"] = 130.19, ["Mega"] = 233.63, ["Mega|Ride"] = 247.65, ["Mega|Fly|Ride"] = 468.22}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 6.13, ["Fly"] = 2056.43, ["Ride"] = 72.18, ["Fly|Ride"] = 196.88, ["Neon"] = 32.69, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 6452.27, ["Mega|Ride"] = 285.31, ["Mega|Fly|Ride"] = 1015.1}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 42.75, ["Ride"] = 19.48, ["Fly|Ride"] = 196.88, ["Neon"] = 3.94, ["Neon|Ride"] = 32.43, ["Mega"] = 69.56, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 200.9, ["Mega|Fly|Ride"] = 282.11}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 55.53, ["Neon"] = 3.68, ["Neon|Ride"] = 47.77, ["Mega"] = 21.4, ["Mega|Ride"] = 127.34, ["Mega|Fly|Ride"] = 231.55}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 16.7}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 38.87, ["Fly"] = 100.41, ["Ride"] = 52.49, ["Neon"] = 243.58, ["Neon|Ride"] = 285.33, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 1854.57, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.2, ["Neon|Ride"] = 28.87, ["Mega"] = 18.19, ["Mega|Ride"] = 119.7, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 485.05, ["Fly"] = 498.75, ["Ride"] = 498.74, ["Fly|Ride"] = 802.99, ["Neon"] = 2132.34, ["Neon|Ride"] = 1996.12, ["Neon|Fly|Ride"] = 2379.72, ["Mega"] = 17097.21, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 6.22, ["Fly"] = 26.25, ["Ride"] = 26.25, ["Fly|Ride"] = 66.26, ["Neon"] = 9.81, ["Neon|Fly"] = 183.75, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 93.19, ["Mega|Ride"] = 144.37, ["Mega|Fly|Ride"] = 285.31}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.43, ["Fly"] = 52.49, ["Ride"] = 22.3, ["Fly|Ride"] = 81.27, ["Neon"] = 19.45, ["Neon|Ride"] = 42.75, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 118.13, ["Mega|Fly"] = 213.72, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 15.33, ["Fly"] = 71.59, ["Ride"] = 51.28, ["Fly|Ride"] = 69.57, ["Neon"] = 102.8, ["Neon|Ride"] = 154.9, ["Mega"] = 854.87, ["Mega|Ride"] = 561.75, ["Mega|Fly|Ride"] = 570.61}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.38, ["Fly"] = 57.68, ["Ride"] = 28.42, ["Fly|Ride"] = 721.88, ["Neon"] = 17.12, ["Neon|Ride"] = 105, ["Mega"] = 275.63, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 4.57, ["Ride"] = 143.12, ["Fly|Ride"] = 157.49, ["Neon"] = 64.59, ["Neon|Ride"] = 112.88, ["Mega"] = 381.89, ["Mega|Ride"] = 570.05, ["Mega|Fly|Ride"] = 599.68}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 5.94, ["Ride"] = 54.48, ["Fly|Ride"] = 133.88, ["Neon"] = 33.01, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 212.66, ["Mega"] = 262.5, ["Mega|Fly"] = 570.64, ["Mega|Ride"] = 259.88, ["Mega|Fly|Ride"] = 452}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 41.13, ["Ride"] = 13.55, ["Fly|Ride"] = 71.56, ["Neon"] = 2.1, ["Neon|Fly"] = 60.93, ["Neon|Ride"] = 15.49, ["Neon|Fly|Ride"] = 75.51, ["Mega"] = 14.86, ["Mega|Fly"] = 32.73, ["Mega|Ride"] = 28.84, ["Mega|Fly|Ride"] = 143.19}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 6.45, ["Fly"] = 54.48, ["Ride"] = 32.67, ["Fly|Ride"] = 106.32, ["Neon"] = 28.41, ["Neon|Fly"] = 121.02, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 228.68, ["Mega"] = 209.45, ["Mega|Ride"] = 208.59, ["Mega|Fly|Ride"] = 360.29}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 312.26, ["Ride"] = 308.42, ["Fly|Ride"] = 446.25, ["Neon"] = 1312.5, ["Neon|Ride"] = 1283.63, ["Neon|Fly|Ride"] = 1252.12, ["Mega|Ride"] = 9388.25, ["Mega|Fly|Ride"] = 4686.52}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 85.56, ["Ride"] = 114.09, ["Fly|Ride"] = 284.82, ["Neon"] = 577.5, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 585.27, ["Mega"] = 2280.35, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1704.94}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 16.86, ["Ride"] = 15.43, ["Fly|Ride"] = 48.38, ["Neon"] = 8.43, ["Neon|Fly"] = 69.35, ["Neon|Ride"] = 34.2, ["Neon|Fly|Ride"] = 64.05, ["Mega|Fly"] = 212.66, ["Mega|Ride"] = 83.36, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 19.15, ["Ride"] = 14.2, ["Fly|Ride"] = 35.62, ["Neon"] = 6.29, ["Neon|Fly"] = 52.69, ["Neon|Ride"] = 25.71, ["Neon|Fly|Ride"] = 50.22, ["Mega"] = 65.54, ["Mega|Fly"] = 356.92, ["Mega|Ride"] = 116.82, ["Mega|Fly|Ride"] = 161.34}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 3.66, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 65.63, ["Mega"] = 277.85, ["Mega|Ride"] = 427.42}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 249.43, ["Fly"] = 420, ["Ride"] = 249.38, ["Fly|Ride"] = 263.59, ["Neon"] = 1181.25, ["Neon|Ride"] = 1079.27, ["Neon|Fly|Ride"] = 1581.5, ["Mega|Ride"] = 8548.13, ["Mega|Fly|Ride"] = 3263.07}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 22.67, ["Ride"] = 16.09, ["Fly|Ride"] = 39.85, ["Neon"] = 15.66, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 39.25, ["Neon|Fly|Ride"] = 57.71, ["Mega"] = 255.94, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 430.63}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.94, ["Ride"] = 34.13, ["Fly|Ride"] = 213.61, ["Neon"] = 35.42, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 253.32, ["Mega|Ride"] = 288.54, ["Mega|Fly|Ride"] = 457.34}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 1.79, ["Ride"] = 82.68, ["Neon"] = 6.26, ["Neon|Ride"] = 156.09, ["Mega"] = 78.56, ["Mega|Ride"] = 213.71}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 12.88, ["Fly"] = 31.5, ["Ride"] = 21.4, ["Fly|Ride"] = 79.07, ["Neon"] = 81.06, ["Neon|Ride"] = 99.56, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 510.57, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 587.99}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 32.82, ["Fly"] = 120.99, ["Ride"] = 78.74, ["Fly|Ride"] = 196.88, ["Neon"] = 137.71, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 229.91, ["Neon|Fly|Ride"] = 279.37, ["Mega"] = 400.31, ["Mega|Fly"] = 2244.02, ["Mega|Ride"] = 475.13, ["Mega|Fly|Ride"] = 576.64}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 23.26, ["Fly"] = 63, ["Ride"] = 64.1, ["Fly|Ride"] = 141.01, ["Neon"] = 214.1, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 170.99, ["Neon|Fly|Ride"] = 223.13, ["Mega|Ride"] = 700.87, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 20.86, ["Ride"] = 14.95, ["Fly|Ride"] = 42.37, ["Neon"] = 2.1, ["Neon|Fly"] = 27.76, ["Neon|Ride"] = 18.17, ["Neon|Fly|Ride"] = 47.15, ["Mega"] = 18.34, ["Mega|Fly"] = 427.44, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 175.48, ["Ride"] = 228.6, ["Fly|Ride"] = 323.01, ["Neon"] = 2146.4, ["Neon|Fly|Ride"] = 1282.31, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 8.11, ["Fly"] = 101.19, ["Ride"] = 49.4, ["Fly|Ride"] = 105, ["Neon"] = 106.35, ["Neon|Ride"] = 209.45, ["Neon|Fly|Ride"] = 143.2, ["Mega|Ride"] = 725.91, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 33.99, ["Ride"] = 18.36, ["Fly|Ride"] = 42.09, ["Neon"] = 6.34, ["Neon|Ride"] = 27.35, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 57.71, ["Mega|Fly"] = 285.33, ["Mega|Ride"] = 85.5, ["Mega|Fly|Ride"] = 158.16}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 32.06, ["Ride"] = 20.9, ["Fly|Ride"] = 71.59, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 28.87, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 18.37, ["Mega|Fly"] = 143.2, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 139.99}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Fly|Ride"] = 72.19, ["Neon"] = 9.8, ["Neon|Fly"] = 725.84, ["Neon|Ride"] = 53.8, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 103.69, ["Mega|Ride"] = 170.31, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 8.75, ["Fly"] = 38.66, ["Ride"] = 23.5, ["Fly|Ride"] = 63.03, ["Neon"] = 55.13, ["Neon|Fly"] = 306.7, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 112.21, ["Mega"] = 355.59, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 404.25}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 13, ["Ride"] = 183.63, ["Neon"] = 53.47, ["Neon|Fly|Ride"] = 314.99, ["Mega"] = 318.94, ["Mega|Ride"] = 427.42, ["Mega|Fly|Ride"] = 413.53}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Neon"] = 3.84, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 100.36, ["Mega"] = 47.11, ["Mega|Ride"] = 77.26, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 6.6, ["Ride"] = 26.81, ["Fly|Ride"] = 131.25, ["Neon"] = 24.93, ["Neon|Fly"] = 102.8, ["Neon|Ride"] = 45, ["Neon|Fly|Ride"] = 272.87, ["Mega"] = 254.34, ["Mega|Ride"] = 201.97, ["Mega|Fly|Ride"] = 296.56}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 81.18, ["Neon"] = 6.46, ["Neon|Fly"] = 114.35, ["Neon|Ride"] = 23, ["Neon|Fly|Ride"] = 102.31, ["Mega"] = 24.92, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 138.92}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 44.07, ["Ride"] = 17.54, ["Fly|Ride"] = 55.91, ["Neon"] = 6.23, ["Neon|Ride"] = 20.89, ["Neon|Fly|Ride"] = 123.96, ["Mega"] = 52.13, ["Mega|Ride"] = 123.41, ["Mega|Fly|Ride"] = 285.9}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 767.7, ["Ride"] = 748.13, ["Fly|Ride"] = 891.07, ["Neon|Fly|Ride"] = 3609.37, ["Mega|Fly|Ride"] = 12571.04}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 19.23, ["Ride"] = 14.69, ["Fly|Ride"] = 36.23, ["Neon"] = 13.11, ["Neon|Fly"] = 140.88, ["Neon|Ride"] = 35.79, ["Neon|Fly|Ride"] = 113.74, ["Mega|Fly|Ride"] = 427.42}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 45.93, ["Fly|Ride"] = 210, ["Neon"] = 7.88, ["Neon|Fly"] = 747.83, ["Neon|Ride"] = 88.56, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 55.12, ["Mega|Fly"] = 213.72, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 7.34, ["Fly"] = 36.35, ["Ride"] = 22.31, ["Fly|Ride"] = 48.64, ["Neon"] = 65.63, ["Neon|Fly"] = 193.62, ["Neon|Ride"] = 55.18, ["Neon|Fly|Ride"] = 97.12, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 311.72}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.46, ["Fly|Ride"] = 33.36, ["Neon"] = 6.39, ["Neon|Fly"] = 64.32, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 65.61, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 189.72}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 37.59, ["Fly"] = 105, ["Ride"] = 83.16, ["Fly|Ride"] = 285.26, ["Neon"] = 196.88, ["Neon|Ride"] = 212.16, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 1425.5}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 19.68, ["Fly|Ride"] = 64.36, ["Neon"] = 3.94, ["Neon|Fly"] = 137.92, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 47.25, ["Mega|Ride"] = 119.79, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 32.67, ["Ride"] = 22.99, ["Fly|Ride"] = 61.95, ["Neon"] = 9.07, ["Neon|Ride"] = 41.88, ["Neon|Fly|Ride"] = 114.35, ["Mega"] = 85.5, ["Mega|Ride"] = 198.59, ["Mega|Fly|Ride"] = 351.74}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.37, ["Fly|Ride"] = 59.07, ["Neon"] = 26.25, ["Mega"] = 96.8, ["Mega|Ride"] = 160.3, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 17.06, ["Fly|Ride"] = 49.87, ["Neon"] = 3.52, ["Neon|Fly"] = 20.31, ["Neon|Ride"] = 24.6, ["Neon|Fly|Ride"] = 103.84, ["Mega"] = 41.28, ["Mega|Fly"] = 229.68, ["Mega|Ride"] = 65.54, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 9.59, ["Fly"] = 21.05, ["Ride"] = 19.42, ["Fly|Ride"] = 36.51, ["Neon"] = 105, ["Neon|Ride"] = 80.85, ["Neon|Fly|Ride"] = 104.29, ["Mega|Ride"] = 468.02, ["Mega|Fly|Ride"] = 466.92}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 715.26, ["Fly"] = 904.91, ["Ride"] = 725.82, ["Fly|Ride"] = 855.75, ["Neon"] = 1819.13, ["Neon|Ride"] = 1967.44, ["Neon|Fly|Ride"] = 2163, ["Mega"] = 4654.13, ["Mega|Fly|Ride"] = 6700.03}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 18.37, ["Ride"] = 16.03, ["Fly|Ride"] = 34.12, ["Neon"] = 4.67, ["Neon|Ride"] = 22.91, ["Neon|Fly|Ride"] = 51.98, ["Mega"] = 44.63, ["Mega|Ride"] = 57.74, ["Mega|Fly|Ride"] = 143.06}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 4.76, ["Ride"] = 32.81, ["Fly|Ride"] = 201.92, ["Neon"] = 47.15, ["Neon|Fly"] = 72.61, ["Neon|Ride"] = 112.41, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 366.18, ["Mega|Ride"] = 351.2, ["Mega|Fly|Ride"] = 537.24}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 49.87, ["Fly"] = 104.9, ["Ride"] = 66.87, ["Fly|Ride"] = 111.57, ["Neon|Ride"] = 421.42, ["Neon|Fly|Ride"] = 389.6, ["Mega"] = 2439.83, ["Mega|Fly|Ride"] = 1567.53}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 28.88, ["Ride"] = 53.36, ["Fly|Ride"] = 104.89, ["Neon"] = 187.69, ["Neon|Ride"] = 224.41, ["Neon|Fly|Ride"] = 315.24, ["Mega"] = 983.89, ["Mega|Ride"] = 896.44, ["Mega|Fly|Ride"] = 1066.38}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 9.08, ["Fly"] = 84.69, ["Ride"] = 26.17, ["Fly|Ride"] = 140.91, ["Neon"] = 56.6, ["Neon|Ride"] = 121.02, ["Neon|Fly|Ride"] = 124.16, ["Mega"] = 305.82, ["Mega|Fly|Ride"] = 528.93}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 26.85, ["Ride"] = 57.68, ["Neon"] = 103.69, ["Neon|Ride"] = 71.61, ["Neon|Fly|Ride"] = 144.77, ["Mega"] = 236.25, ["Mega|Fly"] = 525.1, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 784.23}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 14.63, ["Ride"] = 42.73, ["Fly|Ride"] = 153.71, ["Neon"] = 124.69, ["Neon|Ride"] = 323.09, ["Neon|Fly|Ride"] = 525, ["Mega"] = 924, ["Mega|Ride"] = 641.12, ["Mega|Fly|Ride"] = 745.83}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 5.15}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 2.15, ["Ride"] = 24.71, ["Fly|Ride"] = 59.05, ["Neon"] = 36.75, ["Neon|Ride"] = 81.09, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 196.27, ["Mega|Fly"] = 483, ["Mega|Ride"] = 232.95, ["Mega|Fly|Ride"] = 287.81}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.9, ["Ride"] = 28.93, ["Neon"] = 11.81, ["Neon|Fly|Ride"] = 213.72, ["Mega"] = 140.44, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 37.7, ["Fly"] = 62.99, ["Ride"] = 112.3, ["Fly|Ride"] = 91.16, ["Neon"] = 199.5, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 967.92, ["Mega|Ride"] = 1709.64, ["Mega|Fly|Ride"] = 747.97}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.82, ["Fly"] = 16.07, ["Ride"] = 14.9, ["Fly|Ride"] = 34.17, ["Neon"] = 21.38, ["Neon|Fly"] = 57.7, ["Neon|Ride"] = 31.62, ["Neon|Fly|Ride"] = 73.39, ["Mega"] = 198.19, ["Mega|Fly"] = 426.38, ["Mega|Ride"] = 186.03, ["Mega|Fly|Ride"] = 276.75}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 4.93, ["Fly"] = 37.4, ["Ride"] = 27.53, ["Fly|Ride"] = 56.26, ["Neon"] = 19.58, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 118.11, ["Mega"] = 136.04, ["Mega|Ride"] = 169.31, ["Mega|Fly|Ride"] = 236.23}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 6.18, ["Mega"] = 38.58, ["Mega|Ride"] = 196.59, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 25.46, ["Fly"] = 77.96, ["Ride"] = 52.49, ["Fly|Ride"] = 91.88, ["Neon"] = 183.75, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 315.24, ["Mega|Ride"] = 850.53}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 21.37, ["Fly|Ride"] = 65.63, ["Neon"] = 3.83, ["Neon|Ride"] = 28.87, ["Mega"] = 93.11, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 462.41}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 15.65, ["Ride"] = 81.04, ["Fly|Ride"] = 284.08, ["Neon"] = 87.77, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 392.44, ["Mega|Fly|Ride"] = 712.71}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 15.06, ["Fly|Ride"] = 40.65, ["Neon"] = 92.39, ["Neon|Ride"] = 28.87, ["Neon|Fly|Ride"] = 76.64, ["Mega|Ride"] = 208.04, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 3.82, ["Fly"] = 52.49, ["Ride"] = 19.3, ["Fly|Ride"] = 75.12, ["Neon"] = 40.69, ["Neon|Ride"] = 30.18, ["Mega"] = 291.38, ["Mega|Ride"] = 426.36, ["Mega|Fly|Ride"] = 412.79}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 2.39, ["Ride"] = 67.29, ["Neon"] = 39.37, ["Neon|Ride"] = 227.06, ["Mega"] = 413.86, ["Mega|Ride"] = 956.1}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 33.23, ["Ride"] = 263.81, ["Neon"] = 279.8, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 427.44, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 21.29, ["Ride"] = 285.15, ["Neon"] = 105.77, ["Neon|Ride"] = 183.75, ["Mega"] = 424.36, ["Mega|Ride"] = 565, ["Mega|Fly|Ride"] = 598.39}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 4.45, ["Ride"] = 53.42, ["Neon"] = 174.58, ["Neon|Fly"] = 213.68, ["Neon|Ride"] = 427.44, ["Mega|Ride"] = 853.76}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 22, ["Ride"] = 232.32, ["Fly|Ride"] = 367.46, ["Neon"] = 103.34, ["Neon|Ride"] = 748.02, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 592.38, ["Mega|Fly"] = 2137.16, ["Mega|Fly|Ride"] = 1129.98}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.62, ["Neon"] = 12.46, ["Neon|Ride"] = 32.68, ["Mega"] = 210, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 323.04}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 27.8, ["Ride"] = 18.38, ["Fly|Ride"] = 40.61, ["Neon"] = 4.39, ["Neon|Fly"] = 43.01, ["Neon|Ride"] = 41.9, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 66.68, ["Mega|Ride"] = 87.78, ["Mega|Fly|Ride"] = 321.57}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 9.7, ["Ride"] = 42.73, ["Fly|Ride"] = 65.63, ["Neon"] = 12.9, ["Neon|Ride"] = 70.73, ["Neon|Fly|Ride"] = 121.21, ["Mega"] = 87.94, ["Mega|Ride"] = 160.93, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 143.12, ["Ride"] = 19.48, ["Fly|Ride"] = 57.67, ["Neon"] = 4.93, ["Neon|Ride"] = 26.15, ["Neon|Fly|Ride"] = 105, ["Mega"] = 42, ["Mega|Fly"] = 170.99, ["Mega|Ride"] = 77.97, ["Mega|Fly|Ride"] = 194.91}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.52, ["Fly"] = 65.62, ["Ride"] = 23.51, ["Fly|Ride"] = 118.13, ["Neon"] = 15.73, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 328.02, ["Mega|Ride"] = 337.66, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.56, ["Fly"] = 65.63, ["Ride"] = 21.37, ["Neon"] = 28.68, ["Neon|Fly"] = 315, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 143.2, ["Mega"] = 302.45, ["Mega|Ride"] = 287.47}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.08, ["Fly"] = 131.25, ["Ride"] = 22.22, ["Fly|Ride"] = 78.8, ["Neon"] = 28.86, ["Neon|Fly"] = 114.35, ["Neon|Ride"] = 40.62, ["Neon|Fly|Ride"] = 102.38, ["Mega"] = 359.06, ["Mega|Ride"] = 319.5, ["Mega|Fly|Ride"] = 396.38}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.13, ["Ride"] = 21.37, ["Fly|Ride"] = 51.89, ["Neon"] = 19.37, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 106.87, ["Mega"] = 252.82, ["Mega|Ride"] = 213.71, ["Mega|Fly|Ride"] = 186.18}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 3.35, ["Fly"] = 57.66, ["Ride"] = 43.29, ["Fly|Ride"] = 87.94, ["Neon"] = 20.88, ["Neon|Fly"] = 436.96, ["Neon|Ride"] = 45.47, ["Neon|Fly|Ride"] = 128.44, ["Mega"] = 118.01, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 132.56, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 16.8, ["Fly"] = 207.74, ["Ride"] = 99.75, ["Fly|Ride"] = 196.88, ["Neon"] = 127.15, ["Neon|Ride"] = 231, ["Neon|Fly|Ride"] = 420, ["Mega"] = 540.28, ["Mega|Ride"] = 535.14, ["Mega|Fly|Ride"] = 674.34}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 52.5, ["Fly"] = 164.07, ["Ride"] = 96.39, ["Fly|Ride"] = 181.13, ["Neon"] = 221.82, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 492.19, ["Mega"] = 1566.55, ["Mega|Ride"] = 1061.82, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 50.97, ["Ride"] = 18.36, ["Fly|Ride"] = 65.34, ["Neon"] = 2.1, ["Neon|Ride"] = 24.6, ["Mega"] = 30.35, ["Mega|Ride"] = 47.16, ["Mega|Fly|Ride"] = 143.92}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 6.07, ["Ride"] = 52.5, ["Neon"] = 285.26, ["Mega|Ride"] = 534.27, ["Mega|Fly|Ride"] = 1065.32}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 62.28, ["Fly"] = 105, ["Ride"] = 78.75, ["Fly|Ride"] = 183.75, ["Neon"] = 194.91, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 853.81, ["Mega"] = 1751.4, ["Mega|Ride"] = 1196.75, ["Mega|Fly|Ride"] = 1339.94}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 5.65, ["Fly"] = 190.32, ["Ride"] = 28.63, ["Fly|Ride"] = 133.88, ["Neon"] = 36.66, ["Neon|Ride"] = 83.36, ["Neon|Fly|Ride"] = 210, ["Mega"] = 192.93, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 312.38}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 3.26, ["Ride"] = 68.81, ["Fly|Ride"] = 177.19, ["Neon"] = 9.81, ["Neon|Ride"] = 76.68, ["Mega"] = 85.31, ["Mega|Fly"] = 310.84, ["Mega|Ride"] = 148.36, ["Mega|Fly|Ride"] = 364.88}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 39.65, ["Ride"] = 17.07, ["Fly|Ride"] = 50.23, ["Neon"] = 11.15, ["Neon|Ride"] = 37.02, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 236.15, ["Mega|Ride"] = 100.46, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.75, ["Ride"] = 14.19, ["Fly|Ride"] = 42.73, ["Neon"] = 2.1, ["Neon|Fly"] = 23.88, ["Neon|Ride"] = 27, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 28.87, ["Mega|Ride"] = 69.55, ["Mega|Fly|Ride"] = 150.73}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 1.79, ["Ride"] = 19.23, ["Fly|Ride"] = 92.13, ["Neon"] = 3.45, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 38.84, ["Mega|Ride"] = 126.1, ["Mega|Fly|Ride"] = 182.44}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 120.99, ["Neon"] = 2.1, ["Neon|Ride"] = 145.08, ["Mega"] = 25.35, ["Mega|Fly|Ride"] = 328.02}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 5.99, ["Ride"] = 104.98, ["Neon"] = 30.55, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 641.16, ["Mega"] = 426.38, ["Mega|Ride"] = 269.48, ["Mega|Fly|Ride"] = 323.04}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 5.03, ["Ride"] = 31.62, ["Fly|Ride"] = 198.4, ["Neon"] = 52.97, ["Neon|Ride"] = 100.46, ["Neon|Fly|Ride"] = 143.2, ["Mega|Ride"] = 262.4, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 5.81, ["Fly"] = 41.15, ["Ride"] = 17.56, ["Fly|Ride"] = 39.29, ["Neon"] = 32.8, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 82.46, ["Mega|Ride"] = 406.06, ["Mega|Fly|Ride"] = 352.69}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 53.07, ["Ride"] = 76.13, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 597.19, ["Mega"] = 2419.75, ["Mega|Fly|Ride"] = 1472.63}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 16.59, ["Fly"] = 82.68, ["Ride"] = 32.82, ["Fly|Ride"] = 143.17, ["Neon"] = 285.14, ["Neon|Fly|Ride"] = 630, ["Mega"] = 635.92, ["Mega|Ride"] = 689.73, ["Mega|Fly|Ride"] = 694.98}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 26.62, ["Ride"] = 15.75, ["Fly|Ride"] = 38.07, ["Neon"] = 2.62, ["Neon|Fly"] = 36.35, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 59.85, ["Mega"] = 32.82, ["Mega|Ride"] = 90.65, ["Mega|Fly|Ride"] = 188.98}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 16.59, ["Ride"] = 14.32, ["Fly|Ride"] = 35.35, ["Neon"] = 3.85, ["Neon|Fly"] = 24.34, ["Neon|Ride"] = 19.09, ["Neon|Fly|Ride"] = 49.87, ["Mega"] = 43.36, ["Mega|Fly"] = 92.98, ["Mega|Ride"] = 57.16, ["Mega|Fly|Ride"] = 91.87}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 525, ["Fly"] = 616.76, ["Ride"] = 446.24, ["Fly|Ride"] = 465.71, ["Neon|Fly|Ride"] = 1903.12}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 3.85, ["Ride"] = 36.29, ["Fly|Ride"] = 535.43, ["Neon"] = 48.41, ["Neon|Ride"] = 106.81, ["Mega"] = 403.49, ["Mega|Ride"] = 400.32, ["Mega|Fly|Ride"] = 284937.53}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 15.09, ["Ride"] = 18, ["Fly|Ride"] = 30.91, ["Neon"] = 4.93, ["Neon|Fly"] = 18.38, ["Neon|Ride"] = 17.11, ["Neon|Fly|Ride"] = 40.73, ["Mega"] = 143.2, ["Mega|Ride"] = 74.99, ["Mega|Fly|Ride"] = 112.73}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 56.02, ["Ride"] = 92.76, ["Fly|Ride"] = 295.34, ["Neon"] = 262.4, ["Neon|Ride"] = 308.23, ["Neon|Fly|Ride"] = 443.63, ["Mega"] = 721.88, ["Mega|Ride"] = 761.23, ["Mega|Fly|Ride"] = 930.36}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 19.48, ["Ride"] = 16.67, ["Fly|Ride"] = 34.13, ["Neon"] = 10.2, ["Neon|Fly"] = 63.07, ["Neon|Ride"] = 24.84, ["Neon|Fly|Ride"] = 67.24, ["Mega"] = 111.46, ["Mega|Ride"] = 131.6, ["Mega|Fly|Ride"] = 215.2}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 21, ["Neon"] = 3.76, ["Neon|Ride"] = 35.43, ["Neon|Fly|Ride"] = 74.81, ["Mega"] = 17.34, ["Mega|Ride"] = 60.27, ["Mega|Fly|Ride"] = 190.88}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 21.94, ["Fly"] = 113.7, ["Ride"] = 76.13, ["Fly|Ride"] = 213.84, ["Neon"] = 165.38, ["Neon|Ride"] = 191.28, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 998.07, ["Mega|Ride"] = 1120.88, ["Mega|Fly|Ride"] = 792.75}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 19.67, ["Fly|Ride"] = 52.5, ["Neon"] = 4.39, ["Neon|Ride"] = 39.99, ["Neon|Fly|Ride"] = 79.09, ["Mega"] = 36.75, ["Mega|Ride"] = 197.3, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 27.18, ["Ride"] = 66.94, ["Fly|Ride"] = 159.7, ["Neon"] = 341.87, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 288.46, ["Mega"] = 1688.36, ["Mega|Ride"] = 1709.64, ["Mega|Fly|Ride"] = 1538.67}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.57, ["Ride"] = 183.74, ["Neon"] = 21.84, ["Neon|Ride"] = 20.29, ["Neon|Fly|Ride"] = 158.17, ["Mega"] = 157.5, ["Mega|Ride"] = 603.75}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 71.56, ["Ride"] = 72.02, ["Fly|Ride"] = 70.49, ["Neon"] = 8.54, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 429.19, ["Mega"] = 95.45, ["Mega|Ride"] = 170.98, ["Mega|Fly|Ride"] = 570.61}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 44.61, ["Fly"] = 143.17, ["Ride"] = 50.93, ["Fly|Ride"] = 213.61, ["Mega|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 1993.86}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 27.41, ["Fly|Ride"] = 908.99, ["Neon"] = 4.6, ["Neon|Fly"] = 85.47, ["Neon|Ride"] = 40.31, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 47.19, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 105.34, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 19.94, ["Ride"] = 19.09, ["Fly|Ride"] = 102.85, ["Neon"] = 9.94, ["Neon|Fly"] = 47.77, ["Neon|Ride"] = 32.63, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 96.8, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 6.22, ["Fly"] = 58.5, ["Ride"] = 31.5, ["Fly|Ride"] = 75.79, ["Neon"] = 81.78, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 143.2, ["Mega"] = 453.09, ["Mega|Ride"] = 399.65, ["Mega|Fly|Ride"] = 405.57}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 7.23, ["Ride"] = 29.04, ["Fly|Ride"] = 70.26, ["Neon"] = 63.66, ["Neon|Ride"] = 75.51, ["Neon|Fly|Ride"] = 5342.89, ["Mega"] = 935.01, ["Mega|Ride"] = 450.22, ["Mega|Fly|Ride"] = 517.36}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 24.09, ["Fly"] = 51.18, ["Ride"] = 25.99, ["Fly|Ride"] = 52.5, ["Neon"] = 74.28, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 141.07, ["Mega"] = 570.64, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 401.96}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 62.37, ["Ride"] = 114.6, ["Fly|Ride"] = 252, ["Neon"] = 309.65, ["Neon|Ride"] = 423.94, ["Neon|Fly|Ride"] = 648.64, ["Mega"] = 1425.5, ["Mega|Ride"] = 1490.6, ["Mega|Fly|Ride"] = 1309.87}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 4.5, ["Ride"] = 28.88, ["Neon"] = 24.06, ["Neon|Ride"] = 121.72, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 219.45, ["Mega|Ride"] = 387.16, ["Mega|Fly|Ride"] = 387.16}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 4.47, ["Ride"] = 26.77, ["Fly|Ride"] = 78.74, ["Neon"] = 15.71, ["Neon|Ride"] = 44.79, ["Neon|Fly|Ride"] = 213.72, ["Mega"] = 143.2, ["Mega|Ride"] = 183.74, ["Mega|Fly|Ride"] = 341.94}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 7.82, ["Fly"] = 287.55, ["Ride"] = 28.44, ["Fly|Ride"] = 115.5, ["Neon"] = 75.36, ["Neon|Ride"] = 141.42, ["Mega"] = 452.51, ["Mega|Ride"] = 499.01, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 14.41, ["Fly|Ride"] = 37.09, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 14.27, ["Neon|Fly|Ride"] = 39.25, ["Mega"] = 15.25, ["Mega|Ride"] = 48.39, ["Mega|Fly|Ride"] = 94.79}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 45.05, ["Fly"] = 226.42, ["Ride"] = 112.56, ["Fly|Ride"] = 285.26, ["Neon"] = 262.4, ["Neon|Fly"] = 2422.47, ["Neon|Ride"] = 277.71, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 3205.74, ["Mega|Ride"] = 1001.37, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 21.59, ["Fly|Ride"] = 36.33, ["Neon"] = 3.59, ["Neon|Ride"] = 28.29, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 34.1, ["Mega|Ride"] = 142.01, ["Mega|Fly|Ride"] = 301.87}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.85, ["Ride"] = 16.68, ["Fly|Ride"] = 59.06, ["Neon"] = 15.75, ["Neon|Ride"] = 29.11, ["Neon|Fly|Ride"] = 89.13, ["Mega"] = 257.25, ["Mega|Ride"] = 192.93, ["Mega|Fly|Ride"] = 280.73}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 52.41, ["Fly"] = 71.59, ["Ride"] = 102.9, ["Fly|Ride"] = 258.57, ["Neon"] = 286.74, ["Neon|Ride"] = 341.96, ["Neon|Fly|Ride"] = 483.96, ["Mega"] = 940.74, ["Mega|Ride"] = 1237.36, ["Mega|Fly|Ride"] = 1715.44}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 23.54, ["Neon"] = 7.07, ["Neon|Fly"] = 27.57, ["Neon|Ride"] = 52.41, ["Neon|Fly|Ride"] = 143.2, ["Mega"] = 59.75, ["Mega|Ride"] = 108.03, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 5.23}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Fly|Ride"] = 497.6, ["Neon"] = 5.15, ["Neon|Ride"] = 51.87, ["Neon|Fly|Ride"] = 103.95, ["Mega"] = 46.76, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 229.51}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 114.35, ["Ride"] = 145.26, ["Fly|Ride"] = 349.35, ["Neon"] = 836.07, ["Neon|Ride"] = 710.29, ["Neon|Fly|Ride"] = 917.44, ["Mega"] = 3419.46, ["Mega|Ride"] = 2493.75, ["Mega|Fly|Ride"] = 2835}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 4.97, ["Ride"] = 36.37, ["Fly|Ride"] = 213.68, ["Neon"] = 19.39, ["Neon|Fly"] = 143.2, ["Neon|Ride"] = 64.32, ["Mega"] = 178.39, ["Mega|Ride"] = 211.31, ["Mega|Fly|Ride"] = 646.06}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 36.33, ["Neon"] = 3.72, ["Neon|Ride"] = 20.65, ["Mega"] = 31.29, ["Mega|Ride"] = 104.73, ["Mega|Fly|Ride"] = 143.2}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 5.04, ["Ride"] = 20.88, ["Fly|Ride"] = 131.25, ["Neon"] = 52.07, ["Neon|Ride"] = 65.36, ["Neon|Fly|Ride"] = 162.15, ["Mega"] = 391.12, ["Mega|Ride"] = 427.42, ["Mega|Fly|Ride"] = 625.64}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 10.39, ["Fly"] = 70.12, ["Ride"] = 21.36, ["Fly|Ride"] = 56.58, ["Neon"] = 99, ["Neon|Ride"] = 156.19, ["Neon|Fly|Ride"] = 307.79, ["Mega"] = 626.07, ["Mega|Ride"] = 574.88, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 20.37, ["Ride"] = 71.56, ["Fly|Ride"] = 128.24, ["Neon"] = 172.09, ["Neon|Ride"] = 177.18, ["Neon|Fly|Ride"] = 483.96, ["Mega"] = 560.44, ["Mega|Ride"] = 656.08, ["Mega|Fly|Ride"] = 584.07}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 116.82, ["Fly"] = 196.88, ["Ride"] = 172.07, ["Fly|Ride"] = 207.9, ["Neon"] = 565.13, ["Neon|Ride"] = 590.4, ["Neon|Fly|Ride"] = 654.94, ["Mega|Fly|Ride"] = 2420.14}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 5454.64, ["Ride"] = 656.23, ["Fly|Ride"] = 1175.14, ["Neon|Ride"] = 2137.16, ["Neon|Fly|Ride"] = 2910.91, ["Mega|Fly|Ride"] = 3281.25}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 131.15, ["Ride"] = 21, ["Fly|Ride"] = 131.23, ["Neon"] = 15.74, ["Neon|Ride"] = 32.78, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 139.22, ["Mega|Ride"] = 140.32, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 6.57, ["Fly"] = 50.23, ["Ride"] = 26.16, ["Fly|Ride"] = 91.87, ["Neon"] = 49.16, ["Neon|Ride"] = 80.07, ["Neon|Fly|Ride"] = 162.15, ["Mega"] = 379.32, ["Mega|Ride"] = 433.13, ["Mega|Fly|Ride"] = 570.61}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 49.03, ["Fly"] = 159.69, ["Ride"] = 76.13, ["Fly|Ride"] = 166.69, ["Neon"] = 223.12, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 457.36, ["Mega|Fly|Ride"] = 1002.04}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 17.98, ["Ride"] = 84.84, ["Neon"] = 91.88, ["Neon|Ride"] = 185.77, ["Neon|Fly|Ride"] = 471.27, ["Mega"] = 711.1, ["Mega|Ride"] = 508.14}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.39, ["Ride"] = 615.57, ["Neon|Ride"] = 3226.75, ["Neon|Fly|Ride"] = 1376.82}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 32.45, ["Fly"] = 57.7, ["Ride"] = 36.74, ["Fly|Ride"] = 79.8, ["Neon"] = 196.88, ["Neon|Ride"] = 229.69, ["Neon|Fly|Ride"] = 347.82, ["Mega"] = 761.25, ["Mega|Ride"] = 734.9, ["Mega|Fly|Ride"] = 1067.47}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 38.66, ["Ride"] = 13.68, ["Fly|Ride"] = 31.5, ["Neon"] = 2.1, ["Neon|Ride"] = 18.11, ["Neon|Fly|Ride"] = 49.32, ["Mega"] = 20.68, ["Mega|Fly"] = 104.73, ["Mega|Ride"] = 35.4, ["Mega|Fly|Ride"] = 105.97}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 3.94, ["Neon"] = 9.19, ["Neon|Ride"] = 57.71, ["Neon|Fly|Ride"] = 143.2, ["Mega|Ride"] = 121.05}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 5.25, ["Ride"] = 23.63, ["Fly|Ride"] = 144.21, ["Neon"] = 20.97, ["Neon|Ride"] = 83.06, ["Neon|Fly|Ride"] = 998.07, ["Mega"] = 115.31, ["Mega|Fly"] = 498.61, ["Mega|Ride"] = 114.35, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 393.75, ["Fly"] = 498.6, ["Ride"] = 354.37, ["Fly|Ride"] = 519.75, ["Neon"] = 1424.39, ["Neon|Ride"] = 1775.09, ["Neon|Fly|Ride"] = 1620.35, ["Mega|Fly|Ride"] = 5513.55}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 20.62, ["Ride"] = 17.07, ["Fly|Ride"] = 49.87, ["Neon"] = 24.59, ["Neon|Ride"] = 71.67, ["Neon|Fly|Ride"] = 87.44, ["Mega"] = 170.52, ["Mega|Ride"] = 213.93, ["Mega|Fly|Ride"] = 563.07}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 6.18, ["Fly"] = 19.99, ["Ride"] = 18.19, ["Fly|Ride"] = 32.82, ["Neon"] = 20.31, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 59.85, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 272.48, ["Mega|Fly|Ride"] = 286.38}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 2.1, ["Fly"] = 32.45, ["Ride"] = 28.87, ["Fly|Ride"] = 78.75, ["Neon"] = 16.89, ["Neon|Fly"] = 94.49, ["Neon|Ride"] = 37.44, ["Neon|Fly|Ride"] = 80.67, ["Mega"] = 123.43, ["Mega|Ride"] = 256.46, ["Mega|Fly|Ride"] = 196.87}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 28.86, ["Fly"] = 44.77, ["Ride"] = 19.69, ["Fly|Ride"] = 65.63, ["Neon"] = 162.11, ["Neon|Ride"] = 179.09, ["Neon|Fly|Ride"] = 319.51, ["Mega"] = 1312.5, ["Mega|Ride"] = 853.76, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 34, ["Fly|Ride"] = 49.68, ["Neon"] = 11.46, ["Neon|Ride"] = 37.42, ["Neon|Fly|Ride"] = 210, ["Mega"] = 163.74, ["Mega|Ride"] = 457.79, ["Mega|Fly|Ride"] = 919.42}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 7.66, ["Fly"] = 65.6, ["Ride"] = 28.27, ["Fly|Ride"] = 91.88, ["Neon"] = 168.79, ["Neon|Ride"] = 112.88, ["Mega|Ride"] = 769.34, ["Mega|Fly|Ride"] = 846.57}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.76, ["Neon"] = 5.99, ["Neon|Ride"] = 35.32, ["Mega"] = 53.83, ["Mega|Ride"] = 120.71, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 9.08, ["Neon"] = 50.67, ["Mega|Fly|Ride"] = 697.6}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 8.56, ["Ride"] = 32.67, ["Neon"] = 82.29, ["Neon|Ride"] = 484.02, ["Mega"] = 315.24, ["Mega|Ride"] = 552.59, ["Mega|Fly|Ride"] = 509.25}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 6.38, ["Fly"] = 28.97, ["Ride"] = 24.91, ["Fly|Ride"] = 52.4, ["Neon"] = 48.41, ["Neon|Fly"] = 114.22, ["Neon|Ride"] = 45.85, ["Neon|Fly|Ride"] = 104.89, ["Mega"] = 600.56, ["Mega|Ride"] = 314.93, ["Mega|Fly|Ride"] = 351.05}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 343.74, ["Fly"] = 549.04, ["Ride"] = 392.21, ["Fly|Ride"] = 416.06, ["Neon"] = 1642.41, ["Neon|Ride"] = 1572.58, ["Neon|Fly|Ride"] = 1140.18, ["Mega|Fly|Ride"] = 5250}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.63, ["Fly|Ride"] = 36.33, ["Neon"] = 13.02, ["Neon|Fly"] = 81.09, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 131.92, ["Mega"] = 207.32, ["Mega|Ride"] = 196.77}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.63, ["Ride"] = 100.41, ["Fly|Ride"] = 91.89, ["Neon"] = 60.25, ["Neon|Ride"] = 123.35, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 340.03, ["Mega|Fly"] = 712.77, ["Mega|Ride"] = 411.64}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 22.46, ["Ride"] = 99.74, ["Fly|Ride"] = 315, ["Neon"] = 76.13, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 351.98, ["Mega"] = 365.77, ["Mega|Ride"] = 396.42}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 109.71, ["Fly"] = 130.12, ["Ride"] = 105, ["Fly|Ride"] = 196.88, ["Neon"] = 887.94, ["Neon|Ride"] = 854.87, ["Neon|Fly|Ride"] = 1451.86, ["Mega"] = 2492.09, ["Mega|Ride"] = 1836.19}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 10.07, ["Fly"] = 106.81, ["Ride"] = 52.7, ["Fly|Ride"] = 137.57, ["Neon"] = 42.87, ["Neon|Ride"] = 87.08, ["Neon|Fly|Ride"] = 363.82, ["Mega"] = 282.07, ["Mega|Ride"] = 255.94, ["Mega|Fly|Ride"] = 570.61}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 28.87, ["Ride"] = 19.59, ["Fly|Ride"] = 58.46, ["Neon"] = 12.47, ["Neon|Ride"] = 33.5, ["Neon|Fly|Ride"] = 71.67, ["Mega"] = 65.6, ["Mega|Ride"] = 147.61, ["Mega|Fly|Ride"] = 261.18}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 3.45, ["Ride"] = 40.44, ["Fly|Ride"] = 64.32, ["Neon"] = 25.17, ["Neon|Ride"] = 94.25, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 175, ["Mega|Ride"] = 190.21}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 49.49, ["Fly"] = 183.75, ["Ride"] = 97.67, ["Fly|Ride"] = 216.57, ["Neon"] = 137.64, ["Neon|Ride"] = 157.49, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 433.36, ["Mega|Ride"] = 455.93, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 6.37, ["Neon|Ride"] = 213.72, ["Neon|Fly|Ride"] = 199.5, ["Mega"] = 72.19, ["Mega|Ride"] = 185.87, ["Mega|Fly|Ride"] = 427.42}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 17.07, ["Ride"] = 72.19, ["Neon"] = 123.38, ["Neon|Ride"] = 401.03, ["Neon|Fly|Ride"] = 854.87, ["Mega"] = 570.64, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 1023.75, ["Fly"] = 971.25, ["Ride"] = 1061.7, ["Fly|Ride"] = 1115.63, ["Neon"] = 3399.35, ["Neon|Ride"] = 3662.02, ["Neon|Fly|Ride"] = 3281.22, ["Mega|Fly|Ride"] = 11614.33}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 14.73, ["Fly"] = 100.3, ["Ride"] = 59.8, ["Fly|Ride"] = 191.63, ["Neon"] = 117.96, ["Neon|Fly"] = 700.88, ["Neon|Ride"] = 277.85, ["Mega"] = 337.89, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.34, ["Ride"] = 21.19, ["Fly|Ride"] = 80.92, ["Neon"] = 12.8, ["Neon|Fly"] = 57.7, ["Neon|Ride"] = 33.43, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 83.71, ["Mega|Ride"] = 98.33, ["Mega|Fly|Ride"] = 191.09}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 7.66, ["Ride"] = 47.79, ["Fly|Ride"] = 143.17, ["Neon"] = 100.44, ["Mega"] = 299.21, ["Mega|Ride"] = 541.76, ["Mega|Fly|Ride"] = 481.52}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 35.07, ["Fly|Ride"] = 182.97, ["Neon"] = 2.61, ["Neon|Ride"] = 26.21, ["Neon|Fly|Ride"] = 80.06, ["Mega"] = 17.06, ["Mega|Fly"] = 128.24, ["Mega|Ride"] = 48.56, ["Mega|Fly|Ride"] = 213.71}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 46.79, ["Ride"] = 118.72, ["Fly|Ride"] = 236.25, ["Neon"] = 260.8, ["Neon|Ride"] = 296.01, ["Neon|Fly|Ride"] = 285.28, ["Mega"] = 1105.13, ["Mega|Ride"] = 958.13, ["Mega|Fly|Ride"] = 957.92}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 7.65, ["Ride"] = 61.69, ["Fly|Ride"] = 238.87, ["Neon"] = 79.14, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 570.64, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.87, ["Ride"] = 27.36, ["Neon"] = 8.42, ["Neon|Ride"] = 65.63, ["Mega"] = 88.92, ["Mega|Ride"] = 157.49, ["Mega|Fly|Ride"] = 478.71}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 15.38, ["Fly"] = 67.32, ["Ride"] = 42.26, ["Fly|Ride"] = 120.94, ["Neon"] = 77.81, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 155.92, ["Mega"] = 1039.49, ["Mega|Ride"] = 376.92, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 5.71, ["Fly"] = 31.89, ["Ride"] = 37.4, ["Fly|Ride"] = 96.16, ["Neon"] = 87.48, ["Neon|Ride"] = 114.45, ["Neon|Fly|Ride"] = 188.09, ["Mega"] = 570.64, ["Mega|Ride"] = 528.93, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 35.24, ["Ride"] = 208.68, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 731.73, ["Mega"] = 2103.24, ["Mega|Ride"] = 1709.64, ["Mega|Fly|Ride"] = 1709.64}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 5.04, ["Ride"] = 51.28, ["Fly|Ride"] = 200.22, ["Neon"] = 16.05, ["Neon|Ride"] = 96.18, ["Neon|Fly|Ride"] = 170.99, ["Mega"] = 141.75, ["Mega|Ride"] = 132.92, ["Mega|Fly|Ride"] = 227.05}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 4.64, ["Ride"] = 15.44, ["Fly|Ride"] = 84.41, ["Neon"] = 32.07, ["Neon|Ride"] = 58.84, ["Neon|Fly|Ride"] = 135.47, ["Mega"] = 295.32, ["Mega|Ride"] = 418.88, ["Mega|Fly|Ride"] = 613.35}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 111.57, ["Fly"] = 393.75, ["Ride"] = 185.83, ["Fly|Ride"] = 246.88, ["Neon"] = 584.38, ["Neon|Ride"] = 443.68, ["Neon|Fly|Ride"] = 853.13, ["Mega"] = 2327.07, ["Mega|Ride"] = 2422.34, ["Mega|Fly|Ride"] = 1945.13}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 21.36, ["Ride"] = 15.57, ["Fly|Ride"] = 44.14, ["Neon"] = 12.97, ["Neon|Fly"] = 57.53, ["Neon|Ride"] = 28.87, ["Neon|Fly|Ride"] = 83.09, ["Mega"] = 143.2, ["Mega|Ride"] = 238.8, ["Mega|Fly|Ride"] = 413.53}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 7.72, ["Fly"] = 197.4, ["Ride"] = 39.37, ["Fly|Ride"] = 98.68, ["Neon"] = 64.96, ["Neon|Ride"] = 88.23, ["Neon|Fly|Ride"] = 252.19, ["Mega"] = 452.82, ["Mega|Ride"] = 484.64, ["Mega|Fly|Ride"] = 419.88}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.37, ["Ride"] = 14.81, ["Fly|Ride"] = 52.41, ["Neon"] = 2.23, ["Neon|Fly"] = 26.57, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 39.29, ["Mega"] = 14.93, ["Mega|Fly"] = 50.84, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 72.19}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 57.68, ["Fly|Ride"] = 39.38, ["Neon"] = 3.93, ["Neon|Ride"] = 42.75, ["Neon|Fly|Ride"] = 132.53, ["Mega"] = 18.37, ["Mega|Fly"] = 104.99, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 138.8}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 36.33, ["Ride"] = 27.16, ["Fly|Ride"] = 127.3, ["Neon"] = 17.11, ["Neon|Ride"] = 53.44, ["Neon|Fly|Ride"] = 222.28, ["Mega"] = 74.92, ["Mega|Ride"] = 271.42, ["Mega|Fly|Ride"] = 246.1}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 31.82, ["Ride"] = 52.48, ["Fly|Ride"] = 131.25, ["Neon"] = 168, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 427.28, ["Mega|Ride"] = 576.19, ["Mega|Fly|Ride"] = 948.85}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.62, ["Fly"] = 19.4, ["Ride"] = 15.16, ["Fly|Ride"] = 35.43, ["Neon"] = 9.54, ["Neon|Fly"] = 31.49, ["Neon|Ride"] = 27.2, ["Neon|Fly|Ride"] = 54.62, ["Mega"] = 105, ["Mega|Fly"] = 170.62, ["Mega|Ride"] = 121.83, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 2.1, ["Fly"] = 24.19, ["Ride"] = 24.64, ["Fly|Ride"] = 82.65, ["Neon"] = 28.76, ["Neon|Fly"] = 55.65, ["Neon|Ride"] = 40.57, ["Neon|Fly|Ride"] = 114.35, ["Mega"] = 219.35, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 236.24}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 21.36, ["Ride"] = 18.09, ["Fly|Ride"] = 70.5, ["Neon"] = 8.24, ["Neon|Fly"] = 36.35, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 89.24, ["Mega"] = 162.15, ["Mega|Fly"] = 220.4, ["Mega|Ride"] = 84.67, ["Mega|Fly|Ride"] = 127.32}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 7.2, ["Fly"] = 161.33, ["Ride"] = 23.83, ["Fly|Ride"] = 217.19, ["Neon"] = 25.97, ["Neon|Ride"] = 105.79, ["Neon|Fly|Ride"] = 285.33, ["Mega"] = 261.83, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 320.57, ["Mega|Fly|Ride"] = 430.71}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 14.03, ["Ride"] = 141.17, ["Neon"] = 50.23, ["Neon|Ride"] = 262.5, ["Mega"] = 682.5, ["Mega|Fly|Ride"] = 998.01}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 18.53, ["Fly|Ride"] = 45.39, ["Neon"] = 26.17, ["Neon|Fly"] = 196.76, ["Neon|Ride"] = 49.38, ["Neon|Fly|Ride"] = 154.21, ["Mega"] = 262.49, ["Mega|Ride"] = 457.34, ["Mega|Fly|Ride"] = 427.19}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 24.85, ["Ride"] = 17.07, ["Fly|Ride"] = 72.66, ["Neon"] = 16.59, ["Neon|Fly"] = 70.51, ["Neon|Ride"] = 21.38, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 187.02, ["Mega|Ride"] = 283.12, ["Mega|Fly|Ride"] = 290.38}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 224.97, ["Fly"] = 393.75, ["Ride"] = 271.27, ["Fly|Ride"] = 380.63, ["Neon"] = 1068.32, ["Neon|Ride"] = 1415.73, ["Neon|Fly|Ride"] = 1174.69, ["Mega|Fly|Ride"] = 4124.48}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.62, ["Ride"] = 112.88, ["Neon"] = 35.44, ["Neon|Ride"] = 143.2, ["Neon|Fly|Ride"] = 427.44, ["Mega"] = 122.07, ["Mega|Ride"] = 570.61}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.88, ["Fly"] = 107, ["Ride"] = 22, ["Fly|Ride"] = 79.07, ["Neon"] = 22.88, ["Neon|Fly"] = 242.52, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 209.89, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 7.88, ["Fly|Ride"] = 212.89, ["Neon"] = 36.75, ["Neon|Ride"] = 226.55, ["Neon|Fly|Ride"] = 641.16, ["Mega"] = 596.53, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 414.1}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 16.06, ["Ride"] = 14.31, ["Fly|Ride"] = 30.09, ["Neon"] = 2.63, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 15.83, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 20.03, ["Mega|Fly"] = 80.16, ["Mega|Ride"] = 38.48, ["Mega|Fly|Ride"] = 98.43}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 3.9, ["Fly"] = 24.86, ["Ride"] = 16.93, ["Fly|Ride"] = 79.04, ["Neon"] = 8.74, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 98.76, ["Mega"] = 111.09, ["Mega|Ride"] = 110.24, ["Mega|Fly|Ride"] = 213.94}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.46, ["Ride"] = 42.73, ["Neon"] = 13.13, ["Neon|Ride"] = 143.2, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 74.9, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 67.65, ["Ride"] = 82.3, ["Fly|Ride"] = 175.26, ["Neon"] = 556.49, ["Neon|Ride"] = 379.92, ["Neon|Fly|Ride"] = 641.16, ["Mega|Ride"] = 3563.52, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 6.14, ["Fly"] = 100.41, ["Ride"] = 28.88, ["Fly|Ride"] = 100.68, ["Neon"] = 7.28, ["Neon|Ride"] = 64.28, ["Mega"] = 157.49, ["Mega|Ride"] = 229.5, ["Mega|Fly|Ride"] = 575.95}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 49.16, ["Ride"] = 19.74, ["Neon"] = 5.25, ["Neon|Ride"] = 81.09, ["Neon|Fly|Ride"] = 544.48, ["Mega"] = 32.82, ["Mega|Fly"] = 315, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 48.78, ["Fly"] = 210, ["Ride"] = 85.3, ["Fly|Ride"] = 183.75, ["Neon"] = 131.25, ["Neon|Ride"] = 192.36, ["Neon|Fly|Ride"] = 396.38, ["Mega"] = 590.63, ["Mega|Ride"] = 654.94, ["Mega|Fly|Ride"] = 595.88}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 17.04, ["Ride"] = 14.3, ["Fly|Ride"] = 28.58, ["Neon"] = 2.1, ["Neon|Fly"] = 17.13, ["Neon|Ride"] = 14.94, ["Neon|Fly|Ride"] = 25.89, ["Mega"] = 19.26, ["Mega|Fly"] = 49.86, ["Mega|Ride"] = 34.12, ["Mega|Fly|Ride"] = 88.79}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 3.15, ["Neon|Ride"] = 71.61, ["Neon|Fly|Ride"] = 285.31, ["Mega"] = 25.45, ["Mega|Ride"] = 88.26, ["Mega|Fly|Ride"] = 175.88}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 3.94, ["Ride"] = 21.37, ["Neon"] = 7.76, ["Neon|Fly"] = 59.05, ["Neon|Ride"] = 100.05, ["Neon|Fly|Ride"] = 136.13, ["Mega"] = 143.2, ["Mega|Fly"] = 185.95, ["Mega|Ride"] = 113.3, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 5.25, ["Fly"] = 78.75, ["Ride"] = 47.98, ["Fly|Ride"] = 126.76, ["Neon"] = 20.67, ["Neon|Fly"] = 91.55, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 180.43, ["Mega"] = 111.8, ["Mega|Fly"] = 271.43, ["Mega|Ride"] = 320.92, ["Mega|Fly|Ride"] = 255.94}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 21.17, ["Ride"] = 13.98, ["Fly|Ride"] = 44.88, ["Neon"] = 2.1, ["Neon|Fly"] = 24.5, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 44.24, ["Mega"] = 18.29, ["Mega|Ride"] = 52.49, ["Mega|Fly|Ride"] = 118.12}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 12.74, ["Fly"] = 131.25, ["Ride"] = 128.16, ["Neon"] = 128.64, ["Neon|Fly"] = 427.44, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 570.64, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 646.06}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2610.57, ["Fly"] = 3150, ["Ride"] = 2493.75, ["Fly|Ride"] = 2622.38, ["Mega|Fly|Ride"] = 42739.52}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 16.59, ["Ride"] = 15.58, ["Fly|Ride"] = 36.75, ["Neon"] = 8.49, ["Neon|Fly"] = 57.84, ["Neon|Ride"] = 24.6, ["Neon|Fly|Ride"] = 57.29, ["Mega"] = 84, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 106.86, ["Mega|Fly|Ride"] = 173.07}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.65, ["Neon"] = 7.13, ["Mega"] = 143.2, ["Mega|Fly"] = 441, ["Mega|Ride"] = 160.02, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 16, ["Fly"] = 114.29, ["Ride"] = 31.05, ["Fly|Ride"] = 105, ["Neon"] = 72.18, ["Neon|Ride"] = 111.13, ["Neon|Fly|Ride"] = 212.63, ["Mega"] = 485.63, ["Mega|Ride"] = 360.81, ["Mega|Fly|Ride"] = 483.94}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 30.77, ["Ride"] = 51.77, ["Neon"] = 161.44, ["Mega"] = 748.57, ["Mega|Ride"] = 613.35, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 141.81, ["Fly"] = 1403.03, ["Ride"] = 175.63, ["Fly|Ride"] = 251.99, ["Neon"] = 1312.5, ["Neon|Fly"] = 678.57, ["Neon|Ride"] = 707.48, ["Neon|Fly|Ride"] = 715.32, ["Mega"] = 6411.46, ["Mega|Fly|Ride"] = 3516.49}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 5.71, ["Ride"] = 31.49, ["Fly|Ride"] = 675.94, ["Neon"] = 26.17, ["Neon|Ride"] = 143.2, ["Neon|Fly|Ride"] = 162.15, ["Mega"] = 427.44, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 315.23, ["Mega|Fly|Ride"] = 363.32}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.63, ["Ride"] = 36.32, ["Fly|Ride"] = 71.59, ["Neon"] = 26.24, ["Neon|Ride"] = 114.85, ["Neon|Fly|Ride"] = 285.33, ["Mega"] = 131.25, ["Mega|Ride"] = 333.27, ["Mega|Fly|Ride"] = 860.2}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 100.04, ["Ride"] = 19.69, ["Fly|Ride"] = 131.25, ["Neon"] = 7.66, ["Neon|Fly"] = 126.07, ["Neon|Ride"] = 40.03, ["Mega"] = 84.46, ["Mega|Ride"] = 100.42, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 15.27, ["Ride"] = 59.07, ["Neon"] = 97.13, ["Neon|Ride"] = 177.74, ["Neon|Fly|Ride"] = 503.32, ["Mega"] = 374.07, ["Mega|Ride"] = 473.37, ["Mega|Fly|Ride"] = 597.85}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 42.73, ["Neon"] = 2.1, ["Neon|Ride"] = 47.78, ["Mega"] = 21.06, ["Mega|Fly"] = 121, ["Mega|Ride"] = 79.97, ["Mega|Fly|Ride"] = 135.19}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 89.24, ["Fly"] = 104.9, ["Ride"] = 103.76, ["Fly|Ride"] = 158.12, ["Neon"] = 346.5, ["Neon|Fly"] = 413.56, ["Neon|Ride"] = 409.43, ["Neon|Fly|Ride"] = 330.88, ["Mega|Fly|Ride"] = 1871.61}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 91.82, ["Neon"] = 10.4, ["Neon|Ride"] = 71.61, ["Neon|Fly|Ride"] = 213.72, ["Mega"] = 72.6, ["Mega|Ride"] = 282.85}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 50.23, ["Fly"] = 102.58, ["Ride"] = 74.7, ["Fly|Ride"] = 177.19, ["Neon"] = 401.69, ["Neon|Ride"] = 270.03, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 2564.6, ["Mega|Fly|Ride"] = 2849.75}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 63.03, ["Ride"] = 21.35, ["Fly|Ride"] = 51.32, ["Neon"] = 3.94, ["Neon|Fly"] = 87.45, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 41.54, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 205.4}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 3.03, ["Neon"] = 8.55, ["Neon|Ride"] = 98.44, ["Mega"] = 91.68, ["Mega|Ride"] = 152.36, ["Mega|Fly|Ride"] = 490.16}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 3.59, ["Fly"] = 77.43, ["Ride"] = 33.12, ["Neon"] = 34.13, ["Neon|Ride"] = 120.75, ["Mega"] = 314.99, ["Mega|Ride"] = 288.74, ["Mega|Fly|Ride"] = 570.61}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 360.93, ["Ride"] = 374.33, ["Fly|Ride"] = 536.4, ["Neon"] = 1050, ["Neon|Ride"] = 964.66, ["Neon|Fly|Ride"] = 1050, ["Mega|Ride"] = 3412.5, ["Mega|Fly|Ride"] = 3664.86}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 27.83, ["Fly"] = 85.49, ["Ride"] = 45.94, ["Fly|Ride"] = 107.57, ["Neon"] = 187.02, ["Neon|Ride"] = 171.28, ["Neon|Fly|Ride"] = 283.18, ["Mega"] = 1423.36, ["Mega|Fly|Ride"] = 1995}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 18.15, ["Fly|Ride"] = 85.61, ["Neon"] = 11.34, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 98.34, ["Mega"] = 72.1, ["Mega|Ride"] = 168.38, ["Mega|Fly|Ride"] = 271.42}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 18.38, ["Fly"] = 74.81, ["Ride"] = 47.97, ["Fly|Ride"] = 170.63, ["Neon"] = 68.72, ["Neon|Fly"] = 137.82, ["Neon|Ride"] = 123.53, ["Neon|Fly|Ride"] = 183.05, ["Mega"] = 341.96, ["Mega|Fly"] = 995.74, ["Mega|Ride"] = 347.82, ["Mega|Fly|Ride"] = 712.71}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 4.87, ["Ride"] = 30.98, ["Fly|Ride"] = 196.88, ["Neon"] = 65.34, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 274.65, ["Mega"] = 320.59, ["Mega|Ride"] = 326.97, ["Mega|Fly|Ride"] = 567.4}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 2.63, ["Neon"] = 19.59, ["Neon|Fly"] = 71.47, ["Mega"] = 80.17, ["Mega|Ride"] = 141.06, ["Mega|Fly|Ride"] = 260.73}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 15.85, ["Fly|Ride"] = 60.51, ["Neon"] = 42.94, ["Neon|Ride"] = 45.47, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 129.94, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 102.26, ["Ride"] = 131.25, ["Fly|Ride"] = 228.64, ["Neon"] = 775.39, ["Neon|Ride"] = 523.67, ["Neon|Fly|Ride"] = 568.5, ["Mega"] = 2887.5, ["Mega|Fly|Ride"] = 3205.56}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 20.78, ["Ride"] = 46.78, ["Fly|Ride"] = 91.88, ["Neon"] = 143.16, ["Neon|Ride"] = 282.19, ["Neon|Fly|Ride"] = 388.98, ["Mega"] = 541.78, ["Mega|Fly|Ride"] = 735}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2231.25, ["Fly"] = 2030.44, ["Ride"] = 2060.63, ["Fly|Ride"] = 2100, ["Neon"] = 11395.57, ["Neon|Fly|Ride"] = 6424.69, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.85, ["Fly"] = 65625, ["Ride"] = 57.66, ["Fly|Ride"] = 196.87, ["Neon"] = 18.58, ["Neon|Fly|Ride"] = 641.16, ["Mega"] = 110.06, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 171.94, ["Mega|Fly|Ride"] = 468.22}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 7.67, ["Ride"] = 50.21, ["Fly|Ride"] = 111.07, ["Neon"] = 36.99, ["Neon|Ride"] = 76.63, ["Neon|Fly|Ride"] = 232.38, ["Mega"] = 157.49, ["Mega|Ride"] = 186.4, ["Mega|Fly|Ride"] = 854.82}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 865.98, ["Fly"] = 1096.66, ["Ride"] = 897.75, ["Fly|Ride"] = 986.9, ["Neon"] = 2778.57, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2485.87, ["Mega"] = 12538.66, ["Mega|Fly|Ride"] = 12461.21}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 24.34, ["Ride"] = 49.88, ["Fly|Ride"] = 173.35, ["Neon"] = 143.17, ["Neon|Ride"] = 425.92, ["Neon|Fly|Ride"] = 382.34, ["Mega"] = 839.9, ["Mega|Ride"] = 804.56, ["Mega|Fly|Ride"] = 747.97}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.62, ["Ride"] = 23.63, ["Fly|Ride"] = 128.15, ["Neon"] = 12.11, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 157.5, ["Mega|Ride"] = 271.41, ["Mega|Fly|Ride"] = 262.48}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.41, ["Ride"] = 143.12, ["Neon"] = 3.03, ["Neon|Ride"] = 48.92, ["Neon|Fly|Ride"] = 94.05, ["Mega"] = 19.69, ["Mega|Ride"] = 79.09}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 91.87, ["Ride"] = 114.29, ["Fly|Ride"] = 170.63, ["Neon"] = 459.38, ["Neon|Ride"] = 605.01, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 2419.75, ["Mega|Fly|Ride"] = 2123.16}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 4.78, ["Ride"] = 37.5, ["Fly|Ride"] = 73.8, ["Neon"] = 13.01, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 52.04, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 118.62, ["Mega|Ride"] = 122.04, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 77.35, ["Ride"] = 126, ["Fly|Ride"] = 91.88, ["Neon"] = 459.37, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 524.68, ["Mega|Fly|Ride"] = 1814.35}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 5.13, ["Fly"] = 105, ["Fly|Ride"] = 128.21, ["Neon"] = 26.23, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 241.99, ["Mega|Ride"] = 285.31, ["Mega|Fly|Ride"] = 418.88}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 262.49, ["Fly"] = 354.38, ["Ride"] = 291.84, ["Fly|Ride"] = 328.13, ["Neon"] = 1137.32, ["Neon|Ride"] = 1064.63, ["Neon|Fly|Ride"] = 859.69, ["Mega|Fly|Ride"] = 5485.35}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 2.1, ["Fly"] = 87.94, ["Ride"] = 19.68, ["Fly|Ride"] = 48.44, ["Neon"] = 20.79, ["Neon|Ride"] = 57.63, ["Neon|Fly|Ride"] = 100.93, ["Mega"] = 280.22, ["Mega|Ride"] = 318.93}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 19.37, ["Ride"] = 16.79, ["Fly|Ride"] = 42.44, ["Neon"] = 3.59, ["Neon|Fly"] = 31.49, ["Neon|Ride"] = 21.4, ["Neon|Fly|Ride"] = 46.08, ["Mega"] = 40.68, ["Mega|Ride"] = 67.93, ["Mega|Fly|Ride"] = 124.52}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1250.06, ["Ride"] = 1050, ["Fly|Ride"] = 1254.19, ["Neon|Ride"] = 7836.94, ["Neon|Fly|Ride"] = 6696.77, ["Mega"] = 23713.52, ["Mega|Fly|Ride"] = 28487.82}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 7.16, ["Fly"] = 994.12, ["Ride"] = 72.19, ["Neon"] = 65.01, ["Neon|Ride"] = 314.98, ["Mega"] = 274.07, ["Mega|Ride"] = 528.93, ["Mega|Fly|Ride"] = 564.17}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 4.34, ["Fly"] = 51.28, ["Ride"] = 44.66, ["Fly|Ride"] = 91.77, ["Neon"] = 19.48, ["Neon|Ride"] = 52.68, ["Neon|Fly|Ride"] = 170.99, ["Mega"] = 175.88, ["Mega|Ride"] = 202.1, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 28.34, ["Fly"] = 48.57, ["Ride"] = 32.82, ["Fly|Ride"] = 74.94, ["Neon|Ride"] = 209.78, ["Neon|Fly|Ride"] = 197.64, ["Mega|Ride"] = 1129.98, ["Mega|Fly|Ride"] = 759.34}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 13.54, ["Fly"] = 85.49, ["Ride"] = 26.17, ["Fly|Ride"] = 85.32, ["Neon"] = 69.56, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 93.17, ["Neon|Fly|Ride"] = 179.69, ["Mega"] = 367.4, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 429.26}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 43.16, ["Ride"] = 103.69, ["Fly|Ride"] = 416.51, ["Neon"] = 185.13, ["Neon|Ride"] = 378, ["Neon|Fly|Ride"] = 534.31, ["Mega"] = 1050, ["Mega|Ride"] = 712.71, ["Mega|Fly|Ride"] = 695.77}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 1.79, ["Ride"] = 116.61, ["Fly|Ride"] = 274.62, ["Neon"] = 2.1, ["Neon|Fly"] = 57.71, ["Neon|Ride"] = 26.25, ["Mega"] = 18.27, ["Mega|Ride"] = 83.54, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 65.9, ["Fly"] = 128.16, ["Ride"] = 87, ["Fly|Ride"] = 163.1, ["Neon"] = 446.24, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 3419.46, ["Mega|Fly|Ride"] = 1646.48}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 3.94, ["Fly"] = 107.62, ["Ride"] = 23.39, ["Fly|Ride"] = 70.88, ["Neon"] = 85.8, ["Neon|Ride"] = 113.29, ["Neon|Fly|Ride"] = 170.99, ["Mega"] = 773.06, ["Mega|Ride"] = 433.79}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 28.86, ["Ride"] = 16, ["Fly|Ride"] = 38.16, ["Neon"] = 17.46, ["Neon|Fly"] = 81.06, ["Neon|Ride"] = 67.34, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 275.07, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.1, ["Ride"] = 126, ["Neon"] = 16.03, ["Neon|Fly"] = 141.07, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 382.57, ["Mega|Fly|Ride"] = 483.94}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 49.01, ["Ride"] = 114.57, ["Fly|Ride"] = 262.5, ["Neon"] = 326.82, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 727.13, ["Mega|Ride"] = 1468.15, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 2.75, ["Fly|Ride"] = 427.33, ["Neon"] = 16.69, ["Neon|Ride"] = 118.13, ["Mega"] = 126.88, ["Mega|Ride"] = 138.92, ["Mega|Fly|Ride"] = 323.78}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 34.19, ["Neon"] = 2.1, ["Neon|Ride"] = 52.5, ["Mega"] = 16.96, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 535.4}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.94, ["Ride"] = 35.28, ["Fly|Ride"] = 63.24, ["Neon"] = 2.63, ["Neon|Ride"] = 28.17, ["Neon|Fly|Ride"] = 71.61, ["Mega"] = 16.56, ["Mega|Ride"] = 56.87, ["Mega|Fly|Ride"] = 143.72}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 16.04, ["Fly|Ride"] = 49.26, ["Neon"] = 8.55, ["Neon|Ride"] = 30.09, ["Neon|Fly|Ride"] = 85.92, ["Mega"] = 61.69, ["Mega|Ride"] = 78.74, ["Mega|Fly|Ride"] = 183.74}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 112.53, ["Neon"] = 24.93, ["Mega"] = 118.09, ["Mega|Ride"] = 106.31, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 38.05, ["Ride"] = 15.93, ["Fly|Ride"] = 42.74, ["Neon"] = 15.93, ["Neon|Fly"] = 214.1, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 150.94, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 57.18, ["Ride"] = 96.64, ["Fly|Ride"] = 271.36, ["Neon"] = 210, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 1068.59, ["Mega"] = 961.8, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1122.93}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 12.84, ["Ride"] = 14.7, ["Fly|Ride"] = 36.42, ["Neon"] = 3.94, ["Neon|Fly"] = 28.46, ["Neon|Ride"] = 16.89, ["Neon|Fly|Ride"] = 57.66, ["Mega"] = 19.28, ["Mega|Ride"] = 27.5, ["Mega|Fly|Ride"] = 121}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 6.36, ["Fly"] = 52.68, ["Ride"] = 23.8, ["Fly|Ride"] = 68.16, ["Neon"] = 26.25, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 126.19, ["Mega"] = 401.66, ["Mega|Fly"] = 285.06, ["Mega|Ride"] = 236.9, ["Mega|Fly|Ride"] = 312.86}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 15, ["Fly"] = 71.34, ["Ride"] = 28.85, ["Fly|Ride"] = 98.94, ["Neon"] = 128.21, ["Neon|Ride"] = 137.62, ["Neon|Fly|Ride"] = 182.44, ["Mega"] = 787.5, ["Mega|Ride"] = 782.17, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.03, ["Fly"] = 196.88, ["Neon"] = 65.44, ["Neon|Ride"] = 71.61, ["Mega"] = 366.19, ["Mega|Ride"] = 448.28, ["Mega|Fly|Ride"] = 427.42}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.08, ["Fly|Ride"] = 45.98, ["Neon"] = 5.25, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 20.89, ["Neon|Fly|Ride"] = 61.07, ["Mega"] = 44.89, ["Mega|Ride"] = 59.82, ["Mega|Fly|Ride"] = 113.75}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 2.97, ["Fly"] = 72.19, ["Ride"] = 37.97, ["Neon"] = 24.51, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 205.69, ["Mega"] = 131.24, ["Mega|Fly"] = 735, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 425.28}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 917.44, ["Fly"] = 1403.25, ["Ride"] = 938.44, ["Fly|Ride"] = 1008.3, ["Neon"] = 3134.41, ["Neon|Ride"] = 2744.43, ["Neon|Fly|Ride"] = 2362.49, ["Mega|Fly|Ride"] = 7087.5}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 111.14, ["Ride"] = 143.12, ["Fly|Ride"] = 636.4, ["Neon"] = 641, ["Neon|Ride"] = 628.69, ["Neon|Fly|Ride"] = 854.87, ["Mega"] = 3204.67, ["Mega|Ride"] = 2849.75, ["Mega|Fly|Ride"] = 2388.75}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.24, ["Fly"] = 57.7, ["Ride"] = 39.38, ["Neon"] = 6.02, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 208.39, ["Mega"] = 96.95, ["Mega|Fly|Ride"] = 1140.12}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 59.07, ["Ride"] = 118.59, ["Fly|Ride"] = 157.39, ["Neon"] = 392.38, ["Neon|Fly"] = 446.25, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 636.57, ["Mega"] = 1964.42, ["Mega|Ride"] = 1796.82, ["Mega|Fly|Ride"] = 1665.2}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 3.94, ["Ride"] = 21.37, ["Fly|Ride"] = 92.96, ["Neon"] = 19.28, ["Neon|Fly"] = 42.75, ["Neon|Ride"] = 51.51, ["Neon|Fly|Ride"] = 285.33, ["Mega"] = 285.33, ["Mega|Ride"] = 356.29, ["Mega|Fly|Ride"] = 413.53}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 228.96, ["Fly"] = 335.48, ["Ride"] = 271.1, ["Fly|Ride"] = 328.12, ["Neon|Ride"] = 1367.8, ["Neon|Fly|Ride"] = 1296.64, ["Mega|Fly|Ride"] = 4701.48}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 77.18, ["Ride"] = 41.67, ["Fly|Ride"] = 221.9, ["Neon"] = 31.48, ["Neon|Fly"] = 36.35, ["Neon|Ride"] = 54.37, ["Mega"] = 393.75, ["Mega|Fly"] = 333.41, ["Mega|Ride"] = 646.06}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Fly"] = 28.86, ["Neon"] = 42.76, ["Mega"] = 249.38, ["Mega|Ride"] = 366.52}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 30.99, ["Fly|Ride"] = 152.25, ["Neon"] = 110.49, ["Neon|Ride"] = 124.69, ["Mega"] = 463.76, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.74, ["Neon"] = 25.25, ["Neon|Ride"] = 196.87, ["Mega"] = 241.99, ["Mega|Ride"] = 253.31, ["Mega|Fly|Ride"] = 427.42}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 14.44, ["Fly|Ride"] = 28.86, ["Neon"] = 2.61, ["Neon|Fly"] = 24.6, ["Neon|Ride"] = 22.09, ["Neon|Fly|Ride"] = 34.99, ["Mega"] = 24.21, ["Mega|Ride"] = 181.01, ["Mega|Fly|Ride"] = 100.43}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 5263.02, ["Ride"] = 5130.57, ["Fly|Ride"] = 5250, ["Neon"] = 32049.03, ["Neon|Fly|Ride"] = 19293.75, ["Mega|Fly|Ride"] = 161310.75}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 8.16, ["Fly"] = 85.49, ["Ride"] = 56.43, ["Neon"] = 53.43, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 110.08, ["Mega"] = 210, ["Mega|Ride"] = 215.04, ["Mega|Fly|Ride"] = 427.42}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.69, ["Ride"] = 16.7, ["Fly|Ride"] = 35.79, ["Neon"] = 14.41, ["Neon|Fly"] = 37.51, ["Neon|Ride"] = 34.2, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 131.25, ["Mega|Ride"] = 176.06, ["Mega|Fly|Ride"] = 242.18}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 446.25, ["Fly"] = 547.77, ["Ride"] = 485.63, ["Fly|Ride"] = 531.57, ["Neon"] = 1612.22, ["Neon|Ride"] = 1292.82, ["Neon|Fly|Ride"] = 1472.87, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 5.64, ["Ride"] = 33.29, ["Neon"] = 19.37, ["Mega"] = 187.95, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.61, ["Fly"] = 4273.4, ["Ride"] = 36.74, ["Neon"] = 23.55, ["Neon|Fly"] = 118.62, ["Neon|Ride"] = 45.99, ["Mega"] = 1161.56, ["Mega|Ride"] = 401.63, ["Mega|Fly|Ride"] = 419.35}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Ride"] = 20.35, ["Neon"] = 3.81, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 17.1, ["Neon|Fly|Ride"] = 91.74, ["Mega"] = 39.38, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 285.31}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 656.23, ["Ride"] = 659.7, ["Fly|Ride"] = 761.25, ["Neon|Ride"] = 2842.43, ["Neon|Fly|Ride"] = 2940, ["Mega|Fly|Ride"] = 9260.84}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.34, ["Fly"] = 299.93, ["Ride"] = 55.16, ["Fly|Ride"] = 427.33, ["Neon"] = 31.37, ["Neon|Ride"] = 65.44, ["Neon|Fly|Ride"] = 285.33, ["Mega"] = 183.65, ["Mega|Ride"] = 229.67, ["Mega|Fly|Ride"] = 399.65}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 5.25, ["Fly"] = 236.15, ["Ride"] = 31.19, ["Fly|Ride"] = 87.46, ["Neon"] = 23.7, ["Neon|Ride"] = 52.41, ["Neon|Fly|Ride"] = 144.36, ["Mega"] = 354.17, ["Mega|Fly"] = 807, ["Mega|Ride"] = 214.18, ["Mega|Fly|Ride"] = 413.53}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.12, ["Ride"] = 16.92, ["Fly|Ride"] = 51.69, ["Neon"] = 11.68, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 81.37, ["Mega"] = 285.33, ["Mega|Ride"] = 150.94, ["Mega|Fly|Ride"] = 231.72}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 18.19, ["Ride"] = 34.12, ["Fly|Ride"] = 52.81, ["Neon"] = 117.58, ["Neon|Fly|Ride"] = 320.59, ["Mega"] = 853.81, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 1425.41}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 15.75, ["Fly|Ride"] = 85.45, ["Neon"] = 3.52, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 77.86, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 504.16, ["Ride"] = 538.12, ["Fly|Ride"] = 669.84, ["Neon"] = 2589.57, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Ride"] = 9436.65, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Fly"] = 106.85, ["Ride"] = 80.07, ["Neon"] = 13.21, ["Neon|Ride"] = 93.08, ["Neon|Fly|Ride"] = 483.96, ["Mega"] = 162.15, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 33.49, ["Neon"] = 4.87, ["Neon|Fly"] = 106.85, ["Neon|Ride"] = 42.75, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 89.55, ["Mega|Fly|Ride"] = 363.32}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 42.73, ["Neon"] = 3.83, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 143.2, ["Mega"] = 41.69, ["Mega|Fly"] = 158.17, ["Mega|Ride"] = 105.56, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 28.54, ["Neon"] = 37.93, ["Mega"] = 213.72, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 19.05, ["Fly"] = 64.32, ["Ride"] = 51.1, ["Fly|Ride"] = 101.35, ["Neon"] = 122.06, ["Neon|Fly"] = 143.2, ["Neon|Ride"] = 139.13, ["Neon|Fly|Ride"] = 285.33, ["Mega"] = 635.82, ["Mega|Ride"] = 519.74, ["Mega|Fly|Ride"] = 556.49}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 15.69, ["Ride"] = 48.38, ["Fly|Ride"] = 89.75, ["Neon"] = 83.05, ["Neon|Ride"] = 143.2, ["Neon|Fly|Ride"] = 285.9, ["Mega"] = 381.94, ["Mega|Ride"] = 555.64, ["Mega|Fly|Ride"] = 560.81}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 32.96, ["Ride"] = 14.04, ["Fly|Ride"] = 28.86, ["Neon"] = 21.95, ["Neon|Ride"] = 36.73, ["Neon|Fly|Ride"] = 88.71, ["Mega"] = 236.17, ["Mega|Ride"] = 285.31, ["Mega|Fly|Ride"] = 254.33}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 7.51, ["Ride"] = 56.04, ["Neon"] = 72.19, ["Neon|Ride"] = 141.07, ["Mega|Ride"] = 410.82}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 19.19, ["Fly|Ride"] = 87.05, ["Neon"] = 10.5, ["Neon|Fly"] = 28.87, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 114.35, ["Mega"] = 80.2, ["Mega|Ride"] = 115.49, ["Mega|Fly|Ride"] = 241.98}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 18.5, ["Ride"] = 19.95, ["Fly|Ride"] = 63, ["Neon"] = 10683.02, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 192.05, ["Mega"] = 787.5, ["Mega|Fly|Ride"] = 829.5}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 32.34, ["Fly"] = 874.13, ["Neon"] = 133.88, ["Mega"] = 328.12, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 470.54}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 47.09, ["Fly"] = 115.75, ["Ride"] = 85.19, ["Fly|Ride"] = 129.76, ["Neon"] = 363.57, ["Neon|Ride"] = 356.92, ["Neon|Fly|Ride"] = 423.21, ["Mega|Ride"] = 1710.71, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 33.13, ["Fly"] = 85.44, ["Ride"] = 76.74, ["Fly|Ride"] = 208.27, ["Neon"] = 120.99, ["Neon|Ride"] = 143.2, ["Neon|Fly|Ride"] = 315, ["Mega"] = 511.88, ["Mega|Ride"] = 683.87, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 19.65, ["Ride"] = 64.32, ["Neon"] = 114.27, ["Neon|Ride"] = 428.3, ["Mega"] = 1049.99, ["Mega|Ride"] = 712.71, ["Mega|Fly|Ride"] = 807.19}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 16.65, ["Fly"] = 427.35, ["Ride"] = 48.4, ["Fly|Ride"] = 188.18, ["Neon"] = 132.29, ["Neon|Fly"] = 420, ["Neon|Ride"] = 143.06, ["Neon|Fly|Ride"] = 315, ["Mega"] = 411.55, ["Mega|Ride"] = 556.9, ["Mega|Fly|Ride"] = 641.49}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.91, ["Ride"] = 15.44, ["Fly|Ride"] = 32.74, ["Neon"] = 3.68, ["Neon|Fly"] = 28.61, ["Neon|Ride"] = 29.03, ["Neon|Fly|Ride"] = 50.95, ["Mega"] = 41.36, ["Mega|Fly"] = 336.61, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 866.23}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 42.66, ["Ride"] = 97.12, ["Fly|Ride"] = 315, ["Neon"] = 339.95, ["Neon|Ride"] = 365.54, ["Neon|Fly|Ride"] = 555.68, ["Mega"] = 1130.04, ["Mega|Ride"] = 1515.17, ["Mega|Fly|Ride"] = 1312.49}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 79.74, ["Neon"] = 2.67, ["Neon|Ride"] = 43.19, ["Neon|Fly|Ride"] = 298.05, ["Mega"] = 26.87, ["Mega|Ride"] = 84.94}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 30.18, ["Ride"] = 114.29, ["Fly|Ride"] = 162.11, ["Neon"] = 94.34, ["Neon|Ride"] = 133.95, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 524.99, ["Mega|Ride"] = 806.97, ["Mega|Fly|Ride"] = 686.82}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.83, ["Mega"] = 23.84}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.12, ["Neon|Ride"] = 39.38, ["Mega"] = 23.52, ["Mega|Ride"] = 152.45}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 84.6, ["Fly"] = 223.13, ["Ride"] = 143.07, ["Fly|Ride"] = 354.13, ["Neon"] = 613.22, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 656.25, ["Mega|Ride"] = 6654.04, ["Mega|Fly|Ride"] = 2001.46}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 27.78, ["Fly|Ride"] = 96.75, ["Neon"] = 4.29, ["Neon|Ride"] = 25.12, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 90.17, ["Mega|Ride"] = 115.63, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 71.56, ["Fly|Ride"] = 50.93, ["Neon"] = 4.73, ["Neon|Ride"] = 25.66, ["Neon|Fly|Ride"] = 143.2, ["Mega"] = 35.44, ["Mega|Ride"] = 128.5, ["Mega|Fly|Ride"] = 283.12}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 15.75, ["Neon"] = 3.8, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 210, ["Mega"] = 76.13, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 254.33}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 1.79, ["Ride"] = 82.68, ["Neon"] = 6.26, ["Neon|Ride"] = 156.09, ["Mega"] = 78.56, ["Mega|Ride"] = 213.71}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 41.9, ["Ride"] = 106.81, ["Fly|Ride"] = 457.26, ["Neon"] = 428.35, ["Neon|Ride"] = 499.11, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2066.64, ["Mega|Ride"] = 1602.79, ["Mega|Fly|Ride"] = 1567.53}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 2.39, ["Ride"] = 67.29, ["Neon"] = 39.37, ["Neon|Ride"] = 227.06, ["Mega"] = 413.86, ["Mega|Ride"] = 956.1}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 1.79}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 361.85, ["Ride"] = 384.38, ["Fly|Ride"] = 779.06, ["Neon"] = 1365, ["Neon|Ride"] = 1068.59, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 3055.52}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 1.79}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 88.19}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 50.58}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 15.22}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 15.74}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 143.09}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 43.32}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 14.42}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 3.57}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 262.49}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 26.17}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 1.79}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 24.94}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 7.7}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 5.97}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 577.49}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 5.24}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 5.63}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 7.88}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 10.18}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 12.45}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 564.37}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 570.55}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 14.3}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1141.88}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 3.94}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 59.45}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 8.99}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.63}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 33.34}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.37}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 24.54}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 45.55}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 46.69}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 18.68}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 16.05}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 18.15}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 6.17}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 14.34}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.37}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 3.74}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 24.9}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 147.46}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 3.71}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 4.81}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 2656.5}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 31.97}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 307.92}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 8.13}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 4.86}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 9.27}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 7.09}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 55.13}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 197.13}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 7.53}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 6.56}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 1181.25}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 31.24}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 5.44}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 42.76}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 16.51}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 111.57}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 48.47}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 8.3}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 3.94}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 21.52}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 8.97}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 2.1}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 51.89}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.63}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 91.87}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 228.38}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 7.93}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 318.46}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.93}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 72.22}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 20.99}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 1.79}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 23045.72}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 144.38}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 78.75}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 48.26}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 88.89}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 32.45}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 21.18}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 32.82}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 82.19}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 81.29}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 92.96}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 56.82}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 168.51}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 45.94}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 36.21}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 8.97}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 6.46}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 3.94}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 33.69}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 118.33}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 3.08}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 7.82}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 2.6}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 13.82}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 270.13}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 997.5}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 9.28}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 583.68}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 15.49}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.63}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.63}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 231}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 1.79}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 26.4}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 115.5}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 20.99}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 23.41}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 50.21}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 12.71}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 2.1}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 8.71}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.57}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 4.67}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 30.09}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.42}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 1.79}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.51}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 9.09}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 21.38}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 177.35}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 38.98}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 4.86}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 323.05}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 12.87}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 8.81}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 6.76}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 29.77}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 20.69}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 6.63}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 8.6}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 11.24}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 14.76}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 38.96}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 20.9}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 4.75}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 6.7}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.63}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 6.56}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 6.02}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 1.79}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 5.86}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 6.76}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 3.82}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.24}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.92}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 1.79}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 2.45}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 1.79}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7939.61}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.62}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 23.88}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.98}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 7.88}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 6.23}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.16}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 24.69}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 1.79}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 10.4}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 3.35}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.72}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 5.06}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 1.79}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 1.79}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 34.01}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 12.24}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.84}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 6.13}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.83}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 1.79}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 4.86}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4476.55}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 8.45}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 1.79}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 26.28}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 6.42}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 1.79}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.41}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 70.5}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 4.47}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 100.7}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 1.79}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.52}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 1.79}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 1.79}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 15.16}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.69}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 3.39}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 2.3}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 8.01}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 16.7}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.24}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.14}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.67}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 1.79}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 9.08}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 1.79}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 7.16}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.51}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.94}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 1.79}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.81}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.28}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 1.79}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 6.34}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 28.87}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 10.1}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 78.75}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.67}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 65.39}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 4.34}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 4.71}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1164.36}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 32.01}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.63}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 5.13}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 1.79}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 21.95}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 27.45}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.05}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 14.97}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 7.28}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 12.89}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 6.45}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 15.65}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 15.63}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.63}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.63}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 7.12}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.89}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 15.33}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 10.4}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.63}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 22.68}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.9}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 8.49}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 3.4}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 20.26}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 55.23}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.63}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 3.86}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.63}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 4.81}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 36.66}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 90.55}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 7.58}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 5.09}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 3.84}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 71.6}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 34.14}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.45}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.52}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 4.55}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 5.02}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 3.93}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 1.79}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 2.17}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 75.5}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 4.65}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 152.06}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 8.54}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1050}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 4.43}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 183.75}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 4.38}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.63}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 7.66}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 51.1}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 6.39}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 5.86}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.35}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 68.25}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 19.69}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 9.96}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 3.72}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.91}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.63}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 7.98}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 88.55}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 3.41}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 62.79}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.63}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.35}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 27.96}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 127.88}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 4.29}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 3.44}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 78.42}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 8.79}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 6.45}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 1.79}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 48.48}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 54.35}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 71.39}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 157.4}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.67}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 56.58}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 123.1}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.73}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 3.68}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 9.35}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 33.02}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 61.6}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.94}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 61.68}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 5.08}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 6.45}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 91.88}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 12.66}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 65.01}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 33.94}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 10.31}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 78.75}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 52.41}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 6.19}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.72}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 20.68}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.93}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 15.71}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 65.28}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 1.79}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 37.4}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 84.73}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 2081}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 11.67}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 9}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 24.52}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 341.25}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 18.72}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 8.74}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 13.02}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 15.65}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 6.01}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 293.11}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 52.49}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 54.38}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 3.72}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 82.34}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 183.21}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 76.13}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 918.75}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 105}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 9.51}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2361.19}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 551.23}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 3.94}},
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