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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1039.17, ["Ride"] = 1050, ["Fly|Ride"] = 1292.82, ["Neon"] = 6621.49, ["Neon|Ride"] = 6562.5, ["Neon|Fly|Ride"] = 4235.63, ["Mega|Fly|Ride"] = 17341.52}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 459.38, ["Ride"] = 497.44, ["Fly|Ride"] = 611.22, ["Neon|Fly|Ride"] = 1967.44, ["Mega|Fly|Ride"] = 6871.35}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 5465.25, ["Ride"] = 5249.99, ["Fly|Ride"] = 4689.57, ["Neon|Fly|Ride"] = 21100.22, ["Mega|Fly|Ride"] = 69407.79}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 144.38, ["Ride"] = 226.64, ["Fly|Ride"] = 275.36, ["Neon"] = 972.53, ["Neon|Ride"] = 948.94, ["Neon|Fly|Ride"] = 1035.92, ["Mega|Fly|Ride"] = 4022.82}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 632.62, ["Fly"] = 833, ["Ride"] = 538.13, ["Fly|Ride"] = 636.2, ["Neon|Fly|Ride"] = 1745.63, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 9.87, ["Ride"] = 32.42, ["Fly|Ride"] = 129.94, ["Neon"] = 59.07, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 404.25, ["Mega"] = 347.74, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 583.04}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.13, ["Fly"] = 34.63, ["Ride"] = 24.87, ["Fly|Ride"] = 49.88, ["Neon"] = 26.04, ["Neon|Fly"] = 137.45, ["Neon|Ride"] = 55.21, ["Neon|Fly|Ride"] = 115.64, ["Mega"] = 154.88, ["Mega|Ride"] = 271.93, ["Mega|Fly|Ride"] = 288.44}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 91.88, ["Fly"] = 208.27, ["Ride"] = 153.81, ["Neon"] = 485.63, ["Neon|Ride"] = 493.5, ["Neon|Fly|Ride"] = 1665.79, ["Mega"] = 2053.09}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 40.24, ["Fly"] = 105, ["Ride"] = 44.62, ["Fly|Ride"] = 103.48, ["Neon"] = 312.38, ["Neon|Ride"] = 286.13, ["Neon|Fly|Ride"] = 282.19, ["Mega"] = 2100, ["Mega|Ride"] = 1261.5}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 16.84, ["Fly"] = 85.32, ["Ride"] = 28.58, ["Fly|Ride"] = 70.63, ["Neon"] = 278.02, ["Neon|Ride"] = 295.7, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 624.68}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 56.45, ["Fly"] = 118.72, ["Ride"] = 80.2, ["Fly|Ride"] = 177.19, ["Neon"] = 416.51, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 417.38}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 67.44}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 393.75, ["Fly"] = 399, ["Ride"] = 326.82, ["Fly|Ride"] = 380.69, ["Neon|Fly"] = 1347.95, ["Neon|Ride"] = 1048.69, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 4930.71}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 140.44, ["Fly"] = 186.81, ["Ride"] = 116.82, ["Fly|Ride"] = 170.63, ["Neon|Ride"] = 573.56, ["Neon|Fly|Ride"] = 820.37, ["Mega|Fly|Ride"] = 3034.89}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Fly|Ride"] = 131.25, ["Neon"] = 19.38, ["Neon|Fly"] = 97.89, ["Neon|Ride"] = 50.61, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 129.93, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 314.43, ["Mega|Fly|Ride"] = 307.15}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 224.6, ["Fly"] = 237.57, ["Ride"] = 179.97, ["Fly|Ride"] = 229.69, ["Neon"] = 827.7, ["Neon|Ride"] = 1349.95, ["Neon|Fly|Ride"] = 643.13, ["Mega|Fly|Ride"] = 2730}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.62, ["Fly"] = 19.69, ["Ride"] = 19.22, ["Fly|Ride"] = 32.82, ["Neon"] = 35.41, ["Neon|Ride"] = 91.64, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 208.24, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 416.47}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 81.37, ["Fly"] = 284.72, ["Ride"] = 131.25, ["Fly|Ride"] = 196.88, ["Neon"] = 282.59, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 523.69, ["Mega|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 1422.75}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 37.59}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 61.69, ["Ride"] = 102.05, ["Fly|Ride"] = 177.02, ["Neon"] = 556.04, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 1388.86}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 15.1, ["Fly"] = 393.75, ["Ride"] = 26.25, ["Fly|Ride"] = 374.87, ["Neon"] = 206.3, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 2719.23, ["Mega|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 924.52}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 40.64, ["Fly"] = 157.5, ["Ride"] = 59.76, ["Fly|Ride"] = 100.11, ["Neon"] = 682.03, ["Neon|Ride"] = 295.54, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 1655.19, ["Mega|Ride"] = 1388.86, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 39.26, ["Ride"] = 59.07, ["Fly|Ride"] = 196.88, ["Neon"] = 210, ["Neon|Ride"] = 368.58, ["Neon|Fly|Ride"] = 445.61, ["Mega"] = 2047.5, ["Mega|Ride"] = 1235.81, ["Mega|Fly|Ride"] = 1249.35}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 16.7, ["Ride"] = 40.22, ["Fly|Ride"] = 84, ["Neon"] = 173.91, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 315.69, ["Mega"] = 882.88, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 36.75, ["Fly"] = 136.75, ["Ride"] = 65.63, ["Fly|Ride"] = 135.38, ["Neon"] = 196.88, ["Neon|Ride"] = 187.41, ["Neon|Fly|Ride"] = 322.88, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 943.69}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 3.83, ["Fly"] = 26.6, ["Ride"] = 19.27, ["Fly|Ride"] = 52.25, ["Neon"] = 36.74, ["Neon|Fly"] = 101.04, ["Neon|Ride"] = 47.16, ["Neon|Fly|Ride"] = 95.44, ["Mega"] = 158.43, ["Mega|Fly"] = 27100.4, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 257.04}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 510.21, ["Ride"] = 416.51, ["Fly|Ride"] = 486.87, ["Neon|Ride"] = 2915.13, ["Neon|Fly|Ride"] = 1964.82, ["Mega|Fly|Ride"] = 8051.97}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 18.76, ["Ride"] = 32.82, ["Fly|Ride"] = 107.34, ["Neon"] = 219.19, ["Neon|Fly|Ride"] = 277.99, ["Mega|Ride"] = 791.26, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 3.93, ["Fly"] = 34.7, ["Ride"] = 19.46, ["Fly|Ride"] = 39.8, ["Neon"] = 69.78, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 208.24, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 555.97}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 91.41, ["Fly"] = 102.38, ["Ride"] = 97.53, ["Fly|Ride"] = 128.63, ["Neon"] = 371.3, ["Neon|Fly"] = 376.72, ["Neon|Ride"] = 397.72, ["Neon|Fly|Ride"] = 451.37, ["Mega"] = 3888.57, ["Mega|Ride"] = 7875, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 9.7, ["Ride"] = 31.25, ["Fly|Ride"] = 75.2, ["Neon"] = 131.25, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 208.24, ["Mega"] = 694.44, ["Mega|Ride"] = 794.39, ["Mega|Fly|Ride"] = 832.91}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 206.06, ["Fly"] = 351.96, ["Ride"] = 228.38, ["Fly|Ride"] = 301.88, ["Mega"] = 6246.69, ["Mega|Fly|Ride"] = 5053.57}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 22.31}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.69, ["Fly"] = 31.94, ["Ride"] = 20.69, ["Fly|Ride"] = 53.45, ["Neon"] = 20.45, ["Neon|Fly"] = 139.54, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 127.09, ["Mega"] = 146.42, ["Mega|Ride"] = 154.81, ["Mega|Fly|Ride"] = 280.88}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 926.88, ["Fly"] = 2625, ["Ride"] = 892.5, ["Fly|Ride"] = 1112.47, ["Neon|Ride"] = 6108.22, ["Neon|Fly|Ride"] = 4442.44, ["Mega|Ride"] = 53202.08, ["Mega|Fly|Ride"] = 17024.67}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 7.91, ["Ride"] = 22.88, ["Fly|Ride"] = 91.88, ["Neon"] = 139.54, ["Neon|Ride"] = 139.53, ["Neon|Fly|Ride"] = 230.1, ["Mega"] = 787.5, ["Mega|Ride"] = 1069.24, ["Mega|Fly|Ride"] = 814.16}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 170.63, ["Ride"] = 196.88, ["Fly|Ride"] = 301.88, ["Neon"] = 1104.37, ["Neon|Ride"] = 813.65, ["Neon|Fly|Ride"] = 977.82, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 44.01}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 15.3, ["Fly"] = 111.43, ["Ride"] = 65.52, ["Fly|Ride"] = 145.69, ["Neon"] = 104.98, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 139.53, ["Mega"] = 694.44, ["Mega|Ride"] = 1098.39, ["Mega|Fly|Ride"] = 585.23}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.48}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 128.37, ["Ride"] = 136.5, ["Fly|Ride"] = 236.25, ["Neon"] = 639.19, ["Neon|Ride"] = 773.07, ["Mega|Fly|Ride"] = 2723.17}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 114.33, ["Fly"] = 157.49, ["Ride"] = 163.94, ["Fly|Ride"] = 274.31, ["Neon"] = 360.94, ["Neon|Ride"] = 325.69, ["Neon|Fly|Ride"] = 640.5, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1498.62}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 32.71}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 59.06, ["Fly"] = 89.56, ["Ride"] = 55.55, ["Fly|Ride"] = 87.94, ["Neon|Ride"] = 416.1, ["Neon|Fly|Ride"] = 368.34, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 4.58, ["Fly"] = 69.78, ["Ride"] = 56.82, ["Fly|Ride"] = 157.5, ["Neon"] = 40.63, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 139.53, ["Neon|Fly|Ride"] = 555.97, ["Mega"] = 182.09, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 327.96, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 433.13, ["Fly"] = 455.11, ["Ride"] = 472.5, ["Fly|Ride"] = 473.8, ["Neon|Ride"] = 3748.02, ["Neon|Fly|Ride"] = 1673.53, ["Mega|Fly|Ride"] = 7357.54}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 102.78, ["Fly"] = 166.61, ["Ride"] = 122.07, ["Fly|Ride"] = 158.46, ["Neon"] = 420, ["Neon|Ride"] = 764.18, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2548.65}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3150, ["Ride"] = 3885, ["Fly|Ride"] = 3675}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 41.42, ["Fly"] = 118.13, ["Ride"] = 49.88, ["Fly|Ride"] = 172.87, ["Neon|Ride"] = 315.62, ["Neon|Fly|Ride"] = 548.68, ["Mega"] = 1352.43, ["Mega|Ride"] = 2082.24, ["Mega|Fly|Ride"] = 1347.22}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 85.32, ["Ride"] = 85.32, ["Fly|Ride"] = 139.52, ["Neon"] = 575.75, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 756.67, ["Mega|Ride"] = 2221.75, ["Mega|Fly|Ride"] = 4123.31}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 30.73, ["Fly"] = 56.15, ["Ride"] = 45.86, ["Fly|Ride"] = 79.55, ["Neon"] = 208.27, ["Neon|Ride"] = 166.6, ["Neon|Fly|Ride"] = 183.29, ["Mega"] = 2625, ["Mega|Ride"] = 666.33, ["Mega|Fly|Ride"] = 656.15}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 6.24}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 56.24, ["Ride"] = 93.42, ["Fly|Ride"] = 65.63, ["Neon|Ride"] = 315.62, ["Neon|Fly|Ride"] = 416.47, ["Mega|Fly|Ride"] = 1493.63}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 37.7}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 223.13, ["Ride"] = 236.25, ["Fly|Ride"] = 301.88, ["Neon|Ride"] = 1388.86}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 937.13, ["Ride"] = 918.65, ["Fly|Ride"] = 970.46, ["Neon|Fly|Ride"] = 3189.98, ["Mega|Fly|Ride"] = 10820.36}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 5.97}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 25.61, ["Fly"] = 39.35, ["Ride"] = 38.05, ["Fly|Ride"] = 88.7, ["Neon"] = 249.92, ["Neon|Ride"] = 166.68, ["Neon|Fly|Ride"] = 222.17, ["Mega|Ride"] = 1134.99, ["Mega|Fly|Ride"] = 1110.88}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 18.78}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5250, ["Fly|Ride"] = 4961.25, ["Neon|Fly|Ride"] = 10762.5, ["Mega|Fly|Ride"] = 41301.37}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 11.46, ["Fly"] = 52.41, ["Ride"] = 22.09, ["Fly|Ride"] = 53.99, ["Neon"] = 99.59, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 222.81, ["Mega"] = 694.44, ["Mega|Ride"] = 624.68, ["Mega|Fly|Ride"] = 632.63}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 15.08, ["Ride"] = 26.25, ["Neon"] = 91.88, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 741.57, ["Mega|Ride"] = 827.6, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 70.88, ["Fly"] = 278.02, ["Ride"] = 74.39, ["Fly|Ride"] = 59.07, ["Neon|Ride"] = 386.27, ["Neon|Fly|Ride"] = 480.96, ["Mega"] = 4164.46}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 10.19, ["Fly"] = 150.93, ["Ride"] = 36.46, ["Fly|Ride"] = 132.65, ["Neon"] = 69.78, ["Neon|Ride"] = 262.38, ["Neon|Fly|Ride"] = 501.38, ["Mega"] = 1388.86, ["Mega|Ride"] = 741.29, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1666.87, ["Fly"] = 2305.32, ["Ride"] = 1749.48, ["Fly|Ride"] = 1662.94, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 26505.94, ["Fly"] = 33319.67, ["Ride"] = 32156.25, ["Fly|Ride"] = 26236.88, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 72197.58, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 16.98, ["Fly"] = 393.75, ["Ride"] = 67.41, ["Fly|Ride"] = 165.83, ["Neon"] = 312.39, ["Neon|Ride"] = 277.99, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 1095.26, ["Mega|Ride"] = 1141.88, ["Mega|Fly|Ride"] = 1110.88}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.1, ["Fly"] = 87.68, ["Ride"] = 32.44, ["Fly|Ride"] = 158.24, ["Neon"] = 20.47, ["Neon|Fly"] = 150.19, ["Neon|Ride"] = 63.56, ["Neon|Fly|Ride"] = 181.17, ["Mega"] = 129.94, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 328.02}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 23.63}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 5.24, ["Ride"] = 31.94, ["Fly|Ride"] = 124.67, ["Neon"] = 88.7, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 547.63, ["Mega"] = 310.97, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 660.08}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 808.02, ["Ride"] = 708.75, ["Fly|Ride"] = 774.15, ["Neon"] = 2996.23, ["Neon|Fly|Ride"] = 2624.93, ["Mega|Fly|Ride"] = 11035.31}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 918.75, ["Fly"] = 975.19, ["Ride"] = 853.13, ["Fly|Ride"] = 945, ["Neon|Ride"] = 3609.56, ["Neon|Fly|Ride"] = 3109.32, ["Mega|Fly|Ride"] = 10550.64}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 12.37, ["Fly"] = 118.23, ["Ride"] = 35.41, ["Fly|Ride"] = 65.62, ["Neon"] = 72.18, ["Neon|Ride"] = 119.91, ["Neon|Fly|Ride"] = 214.49, ["Mega|Ride"] = 933.45, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 27.37}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 69.11, ["Fly"] = 128.34, ["Ride"] = 77.44, ["Fly|Ride"] = 118.13, ["Neon"] = 585.31, ["Neon|Ride"] = 402.93, ["Neon|Fly|Ride"] = 420, ["Mega"] = 19687.5, ["Mega|Fly|Ride"] = 1761.6}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 72.18, ["Ride"] = 91.88, ["Fly|Ride"] = 228.38, ["Neon"] = 450.19, ["Neon|Ride"] = 340.89, ["Neon|Fly|Ride"] = 553.88, ["Mega"] = 1354.9, ["Mega|Fly|Ride"] = 3138.97}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 2.61, ["Fly"] = 30.55, ["Ride"] = 19.99, ["Fly|Ride"] = 38.75, ["Neon"] = 23.63, ["Neon|Fly"] = 525, ["Neon|Ride"] = 64.56, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 319.64, ["Mega|Fly|Ride"] = 523.77}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 139.13, ["Fly"] = 161.44, ["Ride"] = 158.6, ["Fly|Ride"] = 196.88, ["Neon"] = 725.82, ["Neon|Ride"] = 518.44, ["Neon|Fly|Ride"] = 459.38, ["Mega|Fly|Ride"] = 1860.48}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 2.96, ["Ride"] = 34.67, ["Fly|Ride"] = 139.54, ["Neon"] = 48.95, ["Neon|Ride"] = 82.69, ["Mega"] = 248.07, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 10.36, ["Fly"] = 41.65, ["Ride"] = 30.18, ["Fly|Ride"] = 77.07, ["Neon"] = 91.88, ["Neon|Fly"] = 126.53, ["Neon|Ride"] = 131.24, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 28.13, ["Ride"] = 28.13, ["Fly|Ride"] = 156.19, ["Neon"] = 265.53, ["Neon|Ride"] = 315.62, ["Mega"] = 918.75, ["Mega|Ride"] = 1161.57, ["Mega|Fly|Ride"] = 890.16}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 14.54, ["Fly"] = 165.56, ["Ride"] = 35.75, ["Fly|Ride"] = 70.79, ["Neon"] = 91.88, ["Neon|Ride"] = 114.59, ["Neon|Fly|Ride"] = 207.19, ["Mega|Fly|Ride"] = 1101.52}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 8329.93, ["Ride"] = 6555.94, ["Fly|Ride"] = 5496.75, ["Neon"] = 34708.69, ["Neon|Ride"] = 24281.25, ["Neon|Fly|Ride"] = 26236.03}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 205.07, ["Fly"] = 271.57, ["Ride"] = 247.7, ["Fly|Ride"] = 271.58, ["Neon|Fly|Ride"] = 564.37, ["Mega|Fly|Ride"] = 2098.69}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 39.38, ["Fly"] = 140.64, ["Ride"] = 78.74, ["Fly|Ride"] = 180.11, ["Neon"] = 118.13, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 280.7, ["Mega"] = 451.43, ["Mega|Fly"] = 543.76, ["Mega|Ride"] = 418.69, ["Mega|Fly|Ride"] = 560.46}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 87.5, ["Ride"] = 28.88, ["Fly|Ride"] = 52.5, ["Neon"] = 31.16, ["Neon|Fly"] = 60.41, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 189.5, ["Mega"] = 341.25}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 45.47, ["Fly"] = 5359.09, ["Ride"] = 96.91, ["Fly|Ride"] = 170.63, ["Neon"] = 225.22, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 236.24, ["Neon|Fly|Ride"] = 381.22, ["Mega"] = 539.85, ["Mega|Ride"] = 590.89, ["Mega|Fly|Ride"] = 608.4}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 14384.99, ["Ride"] = 12009.38, ["Fly|Ride"] = 12073.69, ["Neon|Fly|Ride"] = 24150, ["Mega|Fly|Ride"] = 111052.24}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 265.77, ["Ride"] = 242.82, ["Fly|Ride"] = 357.69, ["Neon"] = 1541.88, ["Neon|Ride"] = 1388.86, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 5955.17}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 86.63, ["Fly"] = 82.91, ["Ride"] = 57.17, ["Fly|Ride"] = 110.15, ["Neon"] = 1049.99, ["Neon|Ride"] = 296.13, ["Neon|Fly|Ride"] = 416.47}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 7.87, ["Fly"] = 27.67, ["Ride"] = 28.13, ["Fly|Ride"] = 72.12, ["Neon"] = 69.78, ["Neon|Fly"] = 268.34, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 472.68}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 379.2, ["Fly"] = 833, ["Ride"] = 392.43, ["Fly|Ride"] = 492.19, ["Neon"] = 1568.76, ["Neon|Ride"] = 1680, ["Neon|Fly|Ride"] = 1620.66, ["Mega|Fly|Ride"] = 4856.25}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 4.48, ["Fly"] = 28.13, ["Ride"] = 38.07, ["Fly|Ride"] = 111.46, ["Neon"] = 28.13, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 181.17, ["Mega"] = 129.94, ["Mega|Fly"] = 277.99, ["Mega|Ride"] = 623.67, ["Mega|Fly|Ride"] = 229.69}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 102.26, ["Fly"] = 217.55, ["Ride"] = 129.84, ["Fly|Ride"] = 216.57, ["Neon"] = 680.91, ["Neon|Fly"] = 525, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 557.82, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.54, ["Fly"] = 19.05, ["Ride"] = 18.79, ["Fly|Ride"] = 29.98, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 2498.68, ["Mega|Fly|Ride"] = 945.83}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 8.99}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 52.5, ["Ride"] = 58.46, ["Fly|Ride"] = 139.54, ["Neon"] = 421.32, ["Neon|Fly"] = 415.48, ["Neon|Ride"] = 406.87, ["Neon|Fly|Ride"] = 416.47, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1805.31}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 13.11, ["Fly"] = 103.09, ["Ride"] = 31.5, ["Fly|Ride"] = 93.19, ["Neon"] = 151.36, ["Neon|Ride"] = 165.38, ["Neon|Fly|Ride"] = 261.19, ["Mega|Fly|Ride"] = 538.06}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 28.88}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 45.86, ["Fly"] = 210, ["Ride"] = 109.13, ["Fly|Ride"] = 249.38, ["Neon"] = 283.8, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 1561.68, ["Mega|Ride"] = 2092.13, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 2.1, ["Ride"] = 29.24, ["Fly|Ride"] = 136.57, ["Neon"] = 21, ["Neon|Ride"] = 102.85, ["Neon|Fly|Ride"] = 277.99, ["Mega"] = 131.25, ["Mega|Ride"] = 283.76}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 10.64, ["Fly"] = 52.5, ["Ride"] = 28.82, ["Fly|Ride"] = 65.63, ["Neon|Ride"] = 311.85, ["Neon|Fly|Ride"] = 208.24}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 446.25, ["Ride"] = 490.28, ["Fly|Ride"] = 485.62, ["Neon|Fly|Ride"] = 5553.3, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 39.18, ["Ride"] = 57.75, ["Fly|Ride"] = 177.19, ["Neon"] = 315.72, ["Neon|Ride"] = 254.69, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 2730}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 41.67, ["Ride"] = 65.63, ["Fly|Ride"] = 139.54, ["Neon|Ride"] = 416.47, ["Neon|Fly|Ride"] = 458.1, ["Mega|Ride"] = 832.91, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 15.43, ["Ride"] = 59.07, ["Fly|Ride"] = 125.26, ["Neon"] = 95.81, ["Neon|Ride"] = 155.65, ["Neon|Fly|Ride"] = 322.76, ["Mega"] = 437.07, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 624.68}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 26250, ["Ride"] = 13556.71, ["Fly|Ride"] = 8528.63, ["Neon|Fly|Ride"] = 17259.38, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1365, ["Ride"] = 1509.38, ["Fly|Ride"] = 1606.5, ["Neon|Fly|Ride"] = 3936.19, ["Mega|Fly|Ride"] = 14437.5}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 1312.49, ["Ride"] = 853.13, ["Fly|Ride"] = 538.13, ["Neon"] = 2552.44, ["Neon|Fly|Ride"] = 2082.24, ["Mega|Fly|Ride"] = 6941.1}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 11.31, ["Fly"] = 20.71, ["Ride"] = 21.31, ["Fly|Ride"] = 40.6, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 131.25, ["Mega|Fly|Ride"] = 572.25}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 3.5, ["Fly"] = 78.74, ["Ride"] = 29.75, ["Neon"] = 19.48, ["Neon|Ride"] = 55.12, ["Mega"] = 158.53, ["Mega|Ride"] = 181.17, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 32.82, ["Fly"] = 102.05, ["Ride"] = 53.18, ["Fly|Ride"] = 87.94, ["Neon"] = 532.09, ["Neon|Ride"] = 155.92, ["Neon|Fly|Ride"] = 197.85, ["Mega|Fly|Ride"] = 588}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 2.1, ["Fly"] = 23.24, ["Ride"] = 15.17, ["Fly|Ride"] = 26.25, ["Neon"] = 31.48, ["Neon|Fly"] = 76.92, ["Neon|Ride"] = 44.98, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 208.24, ["Mega|Ride"] = 239.47}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 354.38, ["Fly"] = 369.49, ["Ride"] = 324.19, ["Fly|Ride"] = 416.51, ["Neon|Ride"] = 1374.28, ["Neon|Fly|Ride"] = 1664.76, ["Mega|Fly|Ride"] = 3654}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 15.74, ["Fly"] = 59.13, ["Ride"] = 30.94, ["Fly|Ride"] = 105, ["Neon"] = 208.95, ["Neon|Ride"] = 154.1, ["Neon|Fly|Ride"] = 287.44, ["Mega|Ride"] = 787.4, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 10.56, ["Fly"] = 21, ["Ride"] = 17.88, ["Fly|Ride"] = 42.58, ["Neon"] = 139.54, ["Neon|Fly"] = 134.81, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 577.5, ["Fly"] = 1048.69, ["Ride"] = 540.75, ["Fly|Ride"] = 883.28, ["Mega|Fly|Ride"] = 9971.07}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1268.34, ["Ride"] = 1260, ["Fly|Ride"] = 1384.69, ["Neon"] = 4859.49, ["Neon|Ride"] = 4164.46, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13726.02}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 122, ["Fly"] = 135.38, ["Ride"] = 98.44, ["Fly|Ride"] = 97.89, ["Neon"] = 971.25, ["Neon|Ride"] = 585.46, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 2360.22}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 169.74, ["Fly"] = 196.87, ["Ride"] = 176.79, ["Fly|Ride"] = 229.95, ["Neon"] = 844.47, ["Neon|Fly"] = 694.53, ["Neon|Ride"] = 630, ["Neon|Fly|Ride"] = 585.64, ["Mega|Ride"] = 3054.63, ["Mega|Fly|Ride"] = 2792.56}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 27.83, ["Fly"] = 119.76, ["Ride"] = 53.72, ["Neon"] = 389.44, ["Neon|Ride"] = 272.98, ["Mega|Ride"] = 2082.24, ["Mega|Fly|Ride"] = 972.41}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 183.75, ["Ride"] = 315, ["Fly|Ride"] = 556.04, ["Neon|Fly|Ride"] = 1324.15, ["Mega|Fly|Ride"] = 3978.11}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2050, ["Fly"] = 2246.26, ["Ride"] = 2483.25, ["Fly|Ride"] = 2231.25, ["Mega|Fly|Ride"] = 28374.45}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 53.82, ["Fly"] = 208.27, ["Ride"] = 51.83, ["Fly|Ride"] = 196.88, ["Neon"] = 511.88, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 343.88, ["Mega|Ride"] = 1110.88, ["Mega|Fly|Ride"] = 2498.68}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 656.25, ["Ride"] = 618.08, ["Fly|Ride"] = 643.13, ["Neon|Ride"] = 1527.32, ["Neon|Fly|Ride"] = 1311.19, ["Mega|Fly|Ride"] = 3360}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 40.21, ["Fly"] = 68.58, ["Ride"] = 48.53, ["Fly|Ride"] = 95.26, ["Neon|Ride"] = 276.95, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1388.86}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 17.05, ["Fly|Ride"] = 51.49, ["Neon"] = 19.69, ["Neon|Fly"] = 158.46, ["Neon|Ride"] = 44.58, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 150.14, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 299.25}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 53.55, ["Ride"] = 91.88, ["Fly|Ride"] = 166.61, ["Neon"] = 420, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 694.44, ["Mega"] = 1522.13}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 845.23, ["Fly"] = 1085.44, ["Ride"] = 835.96, ["Fly|Ride"] = 918.23, ["Neon|Ride"] = 2598.75, ["Neon|Fly|Ride"] = 2651.25, ["Mega|Fly|Ride"] = 9631.13}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 709.35, ["Ride"] = 1446.38, ["Fly|Ride"] = 966.29, ["Mega|Fly|Ride"] = 15129.44}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 15.38, ["Fly"] = 26.25, ["Ride"] = 22.35, ["Fly|Ride"] = 38.22, ["Neon"] = 78.75, ["Neon|Ride"] = 124.95, ["Neon|Fly|Ride"] = 181.17, ["Mega|Fly|Ride"] = 700.95}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 9.09, ["Ride"] = 19.16, ["Fly|Ride"] = 69.78, ["Neon"] = 139.54, ["Neon|Ride"] = 97.88, ["Neon|Fly|Ride"] = 250.04, ["Mega"] = 570.94, ["Mega|Ride"] = 416.47, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.42, ["Ride"] = 23.62, ["Fly|Ride"] = 158.46, ["Neon"] = 20.9, ["Neon|Fly"] = 315.72, ["Neon|Ride"] = 55.04, ["Neon|Fly|Ride"] = 170.57, ["Mega"] = 157.35, ["Mega|Fly"] = 157.5, ["Mega|Ride"] = 277.93, ["Mega|Fly|Ride"] = 363.57}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 37.05, ["Fly"] = 74.99, ["Ride"] = 49.88, ["Fly|Ride"] = 105.78, ["Neon"] = 249.38, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 231, ["Mega|Fly|Ride"] = 1006.69}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 64.2, ["Ride"] = 135.19, ["Fly|Ride"] = 1041.25, ["Neon"] = 424.07, ["Neon|Ride"] = 555.97, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1803.22, ["Mega|Ride"] = 1561.68, ["Mega|Fly|Ride"] = 1527.32}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 15.57, ["Fly"] = 43.31, ["Ride"] = 35.44, ["Fly|Ride"] = 68.24, ["Neon"] = 98.93, ["Neon|Ride"] = 118.11, ["Neon|Fly|Ride"] = 156.19, ["Mega"] = 623.65, ["Mega|Ride"] = 352.28, ["Mega|Fly|Ride"] = 502.69}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 34.12, ["Ride"] = 39.37, ["Fly|Ride"] = 102.38, ["Neon"] = 331.13, ["Neon|Fly"] = 1389.03, ["Neon|Ride"] = 239.47, ["Neon|Fly|Ride"] = 255.94, ["Mega"] = 2100, ["Mega|Ride"] = 1038, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 2.1, ["Fly"] = 20.88, ["Ride"] = 15.64, ["Fly|Ride"] = 41.99, ["Neon"] = 29.3, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 728.8, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 3.71, ["Fly"] = 46.41, ["Ride"] = 32.48, ["Fly|Ride"] = 70.47, ["Neon"] = 34.44, ["Neon|Fly"] = 115.54, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 141.87, ["Mega"] = 298.81, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 482.06}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 278.02, ["Fly"] = 65.62, ["Ride"] = 52.5, ["Fly|Ride"] = 96.42, ["Neon"] = 410.3, ["Neon|Ride"] = 291.53, ["Neon|Fly|Ride"] = 262.49, ["Mega|Fly|Ride"] = 1074.94}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1575, ["Fly"] = 1574.99, ["Ride"] = 1378.13, ["Fly|Ride"] = 1591.87, ["Neon|Fly|Ride"] = 3675, ["Mega|Fly|Ride"] = 13937.7}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 446.25, ["Fly"] = 479.81, ["Ride"] = 459.38, ["Fly|Ride"] = 473.82, ["Mega|Fly|Ride"] = 10411.12}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 291.38, ["Ride"] = 284.82, ["Fly|Ride"] = 459.38, ["Neon"] = 1207.5, ["Neon|Ride"] = 1388.86, ["Neon|Fly|Ride"] = 1665.79, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 42}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 25.99, ["Ride"] = 45.61, ["Fly|Ride"] = 98.44, ["Neon|Fly"] = 416.51, ["Neon|Ride"] = 356.04, ["Neon|Fly|Ride"] = 416.47, ["Mega|Ride"] = 1430.5, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 31931.71, ["Fly"] = 65625, ["Ride"] = 35437.5, ["Fly|Ride"] = 17390.63, ["Neon|Fly|Ride"] = 35437.49, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 272.15, ["Fly"] = 332.69, ["Ride"] = 292.57, ["Fly|Ride"] = 354.75, ["Neon"] = 1386.94, ["Neon|Fly"] = 1104.37, ["Neon|Ride"] = 864.96, ["Neon|Fly|Ride"] = 1000.56, ["Mega"] = 3956.24, ["Mega|Ride"] = 4163.42, ["Mega|Fly|Ride"] = 3871.88}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 194.73, ["Fly"] = 525, ["Ride"] = 249.38, ["Fly|Ride"] = 196.88, ["Neon|Fly|Ride"] = 1734.41}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 139.54, ["Fly"] = 278.02, ["Ride"] = 157.5, ["Fly|Ride"] = 225.7, ["Neon|Ride"] = 612.92, ["Neon|Fly|Ride"] = 811.04, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 14.17, ["Fly"] = 94.5, ["Ride"] = 30.08, ["Fly|Ride"] = 69.78, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 707.01, ["Mega|Fly|Ride"] = 652.8}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3936.19, ["Ride"] = 3937.5, ["Fly|Ride"] = 4724.27, ["Neon"] = 27072.23, ["Neon|Fly|Ride"] = 27763.33}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 28.02, ["Fly"] = 62.49, ["Ride"] = 30.18, ["Fly|Ride"] = 45.94, ["Neon|Ride"] = 343.88, ["Neon|Fly|Ride"] = 211.97, ["Mega|Fly|Ride"] = 694.44}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 39.37, ["Fly"] = 106.51, ["Ride"] = 56.79, ["Fly|Ride"] = 71.07, ["Neon"] = 404.01, ["Neon|Fly"] = 1389.03, ["Neon|Ride"] = 204.75, ["Neon|Fly|Ride"] = 241.5, ["Mega|Fly|Ride"] = 1372.88}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 616.87, ["Ride"] = 615.26, ["Fly|Ride"] = 820.32, ["Neon"] = 2342.69, ["Neon|Ride"] = 1968.75, ["Neon|Fly|Ride"] = 1968.65, ["Mega"] = 8120.68, ["Mega|Fly"] = 8120.68, ["Mega|Fly|Ride"] = 6090}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 15.64, ["Fly"] = 26.17, ["Ride"] = 24.65, ["Fly|Ride"] = 39.37, ["Neon"] = 118.12, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 163.08, ["Mega|Fly|Ride"] = 640.5}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 13.1, ["Ride"] = 27.57, ["Fly|Ride"] = 472.98, ["Neon"] = 95.82, ["Neon|Ride"] = 118.22, ["Neon|Fly|Ride"] = 249.38}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 108.84, ["Ride"] = 128.63, ["Fly|Ride"] = 136.42, ["Neon"] = 1010.63, ["Neon|Ride"] = 832.91, ["Neon|Fly|Ride"] = 555.97, ["Mega|Fly|Ride"] = 2742.88}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 10.39, ["Fly"] = 139.54, ["Ride"] = 79.25, ["Fly|Ride"] = 131.25, ["Neon"] = 72.19, ["Neon|Ride"] = 139.53, ["Neon|Fly|Ride"] = 237.2, ["Mega"] = 393.75, ["Mega|Fly"] = 722.54, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 413.96}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3675, ["Ride"] = 3883.64, ["Fly|Ride"] = 4182.51, ["Neon"] = 13883.9, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 9841.13, ["Mega"] = 36438.91, ["Mega|Fly|Ride"] = 35940.97}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 32.82, ["Ride"] = 65.34, ["Fly|Ride"] = 154.12, ["Neon"] = 1597.28, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 683.82, ["Mega|Ride"] = 1734.41, ["Mega|Fly|Ride"] = 782.23}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 5775, ["Ride"] = 6857.82, ["Fly|Ride"] = 7168.75, ["Neon|Ride"] = 19434.44, ["Neon|Fly|Ride"] = 16655.63, ["Mega|Fly|Ride"] = 81653.33}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.97, ["Fly"] = 22.32, ["Ride"] = 14.57, ["Fly|Ride"] = 31.14, ["Neon"] = 26.13, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 195.57, ["Mega|Ride"] = 372.75, ["Mega|Fly|Ride"] = 344.61}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 19.3, ["Fly"] = 28.92, ["Ride"] = 26.38, ["Fly|Ride"] = 55.04, ["Neon"] = 194.73, ["Neon|Fly"] = 230.13, ["Neon|Ride"] = 555.97, ["Neon|Fly|Ride"] = 161.44, ["Mega|Fly|Ride"] = 935.82}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.87}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 8.38, ["Ride"] = 32.71, ["Fly|Ride"] = 116.03, ["Neon"] = 94.61, ["Neon|Ride"] = 157.68, ["Mega"] = 1050, ["Mega|Ride"] = 873.5, ["Mega|Fly|Ride"] = 1577.16}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 28.58, ["Fly"] = 190.37, ["Ride"] = 62.49, ["Fly|Ride"] = 99.73, ["Neon"] = 210, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 315.47, ["Mega"] = 945, ["Mega|Ride"] = 945.83, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 11.8, ["Fly"] = 26.25, ["Ride"] = 20.84, ["Fly|Ride"] = 35.44, ["Neon|Ride"] = 139.53, ["Neon|Fly|Ride"] = 179.55, ["Mega"] = 2498.68, ["Mega|Ride"] = 589.97, ["Mega|Fly|Ride"] = 527.86}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8434.06}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.98}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 19.45}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 278.02, ["Ride"] = 249.92, ["Fly|Ride"] = 223.13, ["Mega|Fly|Ride"] = 5634.5}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 12.6, ["Fly"] = 131.21, ["Ride"] = 35.57, ["Fly|Ride"] = 127.72, ["Neon"] = 154.12, ["Neon|Ride"] = 116.81, ["Neon|Fly|Ride"] = 265.13, ["Mega|Ride"] = 521.39, ["Mega|Fly|Ride"] = 1470}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 10.17}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.35, ["Ride"] = 30.21, ["Neon|Ride"] = 181.17, ["Mega|Fly|Ride"] = 832.91}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 3153.03}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 194.9, ["Ride"] = 215.25, ["Fly|Ride"] = 328.13, ["Neon"] = 902.77, ["Neon|Ride"] = 813.75, ["Neon|Fly|Ride"] = 1110.88, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 70.14, ["Ride"] = 105.4, ["Fly|Ride"] = 202.01, ["Neon"] = 556.04, ["Neon|Ride"] = 318.6, ["Neon|Fly|Ride"] = 1435.35, ["Mega|Ride"] = 2082.24, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 152.25, ["Fly"] = 347.8, ["Ride"] = 191.2, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 787.4, ["Neon|Fly|Ride"] = 972.41, ["Mega|Ride"] = 3226.13, ["Mega|Fly|Ride"] = 4777.5}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1967.44, ["Fly"] = 1968.75, ["Ride"] = 1837.5, ["Fly|Ride"] = 1968.75, ["Neon|Fly|Ride"] = 6663.13, ["Mega|Fly|Ride"] = 18376.32}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 13.07, ["Fly"] = 97.89, ["Ride"] = 57.75, ["Fly|Ride"] = 99.74, ["Neon"] = 127.32, ["Neon|Ride"] = 154.62, ["Neon|Fly|Ride"] = 307.15, ["Mega"] = 935.97, ["Mega|Ride"] = 1025.05, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 686.44, ["Fly"] = 2100, ["Ride"] = 735, ["Fly|Ride"] = 1149.75, ["Neon|Fly|Ride"] = 4163.42, ["Mega|Fly|Ride"] = 16551.76}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 42}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 15.64, ["Ride"] = 56.24, ["Fly|Ride"] = 828.83, ["Neon"] = 94.5, ["Neon|Ride"] = 139.53, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 407.27, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 6.39, ["Fly"] = 165.55, ["Ride"] = 27.57, ["Fly|Ride"] = 99.75, ["Neon"] = 65.54, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 203.7, ["Mega|Ride"] = 393.75}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 64.32}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 18.77, ["Fly"] = 108.92, ["Ride"] = 30.75, ["Fly|Ride"] = 81.24, ["Neon"] = 94.61, ["Neon|Ride"] = 249.87, ["Neon|Fly|Ride"] = 349.83, ["Mega|Fly|Ride"] = 1944.8}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 21, ["Fly"] = 56.15, ["Ride"] = 45.94, ["Fly|Ride"] = 52.41, ["Neon"] = 288.75, ["Neon|Ride"] = 416.47, ["Neon|Fly|Ride"] = 308.19, ["Mega|Ride"] = 1773.41, ["Mega|Fly|Ride"] = 944.3}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6300, ["Fly"] = 10237.5, ["Ride"] = 7875, ["Fly|Ride"] = 5118.75, ["Neon|Fly|Ride"] = 11812.5, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 9.19, ["Fly"] = 65.63, ["Ride"] = 33.52, ["Fly|Ride"] = 78.05, ["Neon"] = 56.44, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 221.1, ["Mega"] = 529.67, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 533.4}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 19.38}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 104.97, ["Fly"] = 368.61, ["Ride"] = 132.25, ["Neon"] = 525, ["Neon|Ride"] = 455.44, ["Neon|Fly|Ride"] = 731.91, ["Mega"] = 2879.59}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 41.91, ["Fly"] = 140.91, ["Ride"] = 68.98, ["Fly|Ride"] = 157.49, ["Neon"] = 255.94, ["Neon|Ride"] = 277.99, ["Neon|Fly|Ride"] = 320.74, ["Mega"] = 2364.55, ["Mega|Ride"] = 2811.02, ["Mega|Fly|Ride"] = 1527.32}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 24.29, ["Fly"] = 70.47, ["Ride"] = 29.85, ["Fly|Ride"] = 68.27, ["Neon|Ride"] = 142.96, ["Neon|Fly|Ride"] = 190.3, ["Mega"] = 1016.21, ["Mega|Ride"] = 867.81, ["Mega|Fly|Ride"] = 780.94}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 3.19, ["Fly"] = 65.54, ["Ride"] = 25.81, ["Fly|Ride"] = 60.41, ["Neon"] = 26.15, ["Neon|Fly"] = 69.78, ["Neon|Ride"] = 50.89, ["Neon|Fly|Ride"] = 128.5, ["Mega"] = 190, ["Mega|Fly"] = 254.63, ["Mega|Ride"] = 178.1, ["Mega|Fly|Ride"] = 269.07}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 8.03, ["Ride"] = 27.36, ["Fly|Ride"] = 90.61, ["Neon"] = 86.52, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 290.49, ["Mega"] = 525, ["Mega|Ride"] = 536.76, ["Mega|Fly|Ride"] = 584.07}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 19.59, ["Fly"] = 23.55, ["Ride"] = 24.81, ["Fly|Ride"] = 47.14, ["Neon"] = 361.33, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 144.3}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 188.1}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 24.5, ["Ride"] = 131.24, ["Fly|Ride"] = 280.37, ["Neon"] = 170.63, ["Neon|Ride"] = 277.99, ["Neon|Fly|Ride"] = 570.54, ["Mega"] = 1110.88, ["Mega|Fly|Ride"] = 1665.79}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 210, ["Ride"] = 443.63, ["Fly|Ride"] = 1577.35}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 46.99, ["Fly"] = 212.3, ["Ride"] = 105.57, ["Fly|Ride"] = 210.99, ["Neon"] = 243.66, ["Neon|Ride"] = 295.32, ["Neon|Fly|Ride"] = 423.62, ["Mega"] = 918.75, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1288.91}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 918.74, ["Fly"] = 1347.38, ["Ride"] = 1007.98, ["Fly|Ride"] = 1023.75, ["Neon|Fly"] = 4091.14, ["Neon|Ride"] = 3281.25, ["Neon|Fly|Ride"] = 3425.9, ["Mega|Fly|Ride"] = 11733.75}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 393.65, ["Fly"] = 694.53, ["Ride"] = 413.44, ["Fly|Ride"] = 570.94, ["Neon"] = 2498.99, ["Neon|Ride"] = 2082.24, ["Neon|Fly|Ride"] = 2559.38, ["Mega|Fly|Ride"] = 8328.91}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 66.89}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 7.67, ["Fly"] = 20.99, ["Ride"] = 20.97, ["Fly|Ride"] = 43.32, ["Neon"] = 78.74, ["Neon|Fly"] = 166.61, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 694.44, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 261.19, ["Fly"] = 525, ["Ride"] = 302.92, ["Fly|Ride"] = 380.63, ["Neon"] = 2364.83, ["Neon|Ride"] = 1026.47, ["Neon|Fly|Ride"] = 1090.05, ["Mega|Fly|Ride"] = 3221.21}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 15.73}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 139.01, ["Ride"] = 183.23, ["Fly|Ride"] = 285.51, ["Neon"] = 585.38, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 551.25, ["Mega"] = 2360.22, ["Mega|Ride"] = 11843.7, ["Mega|Fly|Ride"] = 3185.82}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 104.14, ["Fly"] = 105, ["Ride"] = 104.14, ["Fly|Ride"] = 208.27, ["Neon"] = 764.29, ["Neon|Fly"] = 590.63, ["Neon|Ride"] = 2290.45, ["Neon|Fly|Ride"] = 913.5, ["Mega|Ride"] = 3472.12, ["Mega|Fly|Ride"] = 2498.68}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 3.94, ["Ride"] = 27.55, ["Fly|Ride"] = 729.75, ["Neon"] = 27.57, ["Neon|Ride"] = 86.56, ["Neon|Fly|Ride"] = 204.07, ["Mega"] = 319.64, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 831.87}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 13.93, ["Fly"] = 83.31, ["Ride"] = 27.13, ["Fly|Ride"] = 76.28, ["Neon"] = 177.19, ["Neon|Ride"] = 99.73, ["Neon|Fly|Ride"] = 315.69, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 12.76, ["Fly"] = 102.35, ["Ride"] = 39.82, ["Fly|Ride"] = 104.6, ["Neon"] = 65.62, ["Neon|Ride"] = 101.06, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 498.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 832.91}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 3.92, ["Fly"] = 69.78, ["Ride"] = 54.03, ["Fly|Ride"] = 278.02, ["Neon"] = 19.04, ["Neon|Ride"] = 68.93, ["Neon|Fly|Ride"] = 172.49, ["Mega"] = 140.43, ["Mega|Fly"] = 368.58, ["Mega|Ride"] = 170.52, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 269.07, ["Ride"] = 275.63, ["Fly|Ride"] = 354.38, ["Neon"] = 1638.93, ["Neon|Ride"] = 1345.21, ["Neon|Fly|Ride"] = 1312.5}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 140.22, ["Fly"] = 556.04, ["Ride"] = 164.53, ["Fly|Ride"] = 241.5, ["Neon"] = 1087.84, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1173.27, ["Mega"] = 2082.24, ["Mega|Fly|Ride"] = 2401.88}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 69.56, ["Fly"] = 167.45, ["Ride"] = 69.33, ["Fly|Ride"] = 124.97, ["Neon"] = 393.75, ["Neon|Ride"] = 530.77, ["Neon|Fly|Ride"] = 416.07, ["Mega|Fly|Ride"] = 1801.14}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 13.13, ["Ride"] = 69.78, ["Fly|Ride"] = 278.02, ["Neon|Ride"] = 600.51, ["Neon|Fly|Ride"] = 486.21, ["Mega|Fly|Ride"] = 1944.8}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 11.82, ["Fly"] = 58.47, ["Ride"] = 33.53, ["Fly|Ride"] = 79.28, ["Neon"] = 77.44, ["Neon|Fly"] = 278.02, ["Neon|Ride"] = 122.88, ["Neon|Fly|Ride"] = 188, ["Mega"] = 371.44, ["Mega|Fly"] = 525, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 2.49, ["Fly"] = 26.25, ["Ride"] = 18.36, ["Fly|Ride"] = 44.05, ["Neon"] = 20.25, ["Neon|Fly"] = 66.25, ["Neon|Ride"] = 35.17, ["Neon|Fly|Ride"] = 118.1, ["Mega"] = 129.94, ["Mega|Ride"] = 141.91, ["Mega|Fly|Ride"] = 253.62}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 983.09, ["Fly"] = 1050, ["Ride"] = 914.82, ["Fly|Ride"] = 931.34, ["Neon|Fly"] = 3231.8, ["Neon|Ride"] = 8328.91, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 10236.21}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 341.25, ["Ride"] = 393.75, ["Fly|Ride"] = 416.51, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 2082.24, ["Mega"] = 10411.12, ["Mega|Fly|Ride"] = 5830.25}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 93.18, ["Fly"] = 139.54, ["Ride"] = 103.64, ["Fly|Ride"] = 196.88, ["Neon"] = 339.94, ["Neon|Ride"] = 378.29, ["Neon|Fly|Ride"] = 585.12, ["Mega"] = 1312.5, ["Mega|Ride"] = 1665.79, ["Mega|Fly|Ride"] = 1781.69}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 216.6, ["Fly"] = 283.5, ["Ride"] = 219.69, ["Fly|Ride"] = 308.44, ["Neon|Fly|Ride"] = 1577.16, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 17.07, ["Fly"] = 52.5, ["Ride"] = 28.88, ["Fly|Ride"] = 76.13, ["Neon"] = 169.32, ["Neon|Ride"] = 96.48, ["Neon|Fly|Ride"] = 236.25, ["Mega|Fly|Ride"] = 788.6}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 236.15, ["Ride"] = 249.38, ["Fly|Ride"] = 472.5, ["Neon"] = 1507.28, ["Neon|Ride"] = 917.24, ["Neon|Fly|Ride"] = 708.75, ["Mega"] = 4143.92, ["Mega|Ride"] = 4580.9, ["Mega|Fly|Ride"] = 3818.31}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 84.06, ["Fly"] = 125.98, ["Ride"] = 75.45, ["Fly|Ride"] = 100.1, ["Neon|Fly|Ride"] = 555.97, ["Mega|Fly|Ride"] = 1732.5}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1889.99, ["Ride"] = 1837.5, ["Fly|Ride"] = 1820.44, ["Neon|Ride"] = 11033.48, ["Neon|Fly|Ride"] = 7274.26, ["Mega"] = 49973.36, ["Mega|Fly|Ride"] = 22625.45}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 9.63, ["Fly"] = 76.25, ["Ride"] = 34.07, ["Fly|Ride"] = 71.28, ["Neon"] = 51.89, ["Neon|Fly"] = 237.57, ["Neon|Ride"] = 115.49, ["Neon|Fly|Ride"] = 218.22, ["Mega"] = 410.26, ["Mega|Ride"] = 402.93, ["Mega|Fly|Ride"] = 446.24}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 52.99, ["Ride"] = 82.27, ["Fly|Ride"] = 161.44, ["Neon"] = 315, ["Neon|Ride"] = 319.64, ["Neon|Fly|Ride"] = 555.97, ["Mega"] = 1655.19, ["Mega|Fly|Ride"] = 1597.09}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 104.89, ["Fly"] = 78.69, ["Ride"] = 77.99, ["Fly|Ride"] = 106.32, ["Neon"] = 525, ["Neon|Fly|Ride"] = 393.71, ["Mega|Fly|Ride"] = 1842.38}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3018.75, ["Fly"] = 1577.12, ["Ride"] = 1115.63, ["Fly|Ride"] = 1132.9, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 459.38, ["Fly"] = 577.9, ["Ride"] = 655.07, ["Neon|Fly|Ride"] = 4163.42}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 83.91, ["Fly"] = 315.68, ["Ride"] = 131.21, ["Fly|Ride"] = 278.02, ["Neon"] = 408.18, ["Neon|Ride"] = 465.94, ["Neon|Fly|Ride"] = 557.82, ["Mega|Ride"] = 2638.19, ["Mega|Fly|Ride"] = 2776.66}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.51, ["Ride"] = 22.32, ["Fly|Ride"] = 139.54, ["Neon"] = 69.16, ["Neon|Ride"] = 64.31, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 656.25}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 39.37, ["Ride"] = 47.92, ["Fly|Ride"] = 104.14, ["Neon"] = 208.27, ["Neon|Fly"] = 326.96, ["Neon|Ride"] = 216.34, ["Neon|Fly|Ride"] = 386.19, ["Mega"] = 1706.25, ["Mega|Fly|Ride"] = 1036.88}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 796.59, ["Ride"] = 759.94, ["Fly|Ride"] = 820.32, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2139.38, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 749.31}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4921.88, ["Ride"] = 6685.33, ["Fly|Ride"] = 5962.34, ["Neon"] = 42000, ["Neon|Ride"] = 29839.3, ["Neon|Fly|Ride"] = 23336.25, ["Mega|Fly|Ride"] = 88842.21}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 328.13, ["Fly"] = 496.12, ["Ride"] = 393.75, ["Fly|Ride"] = 411.31, ["Neon"] = 1666, ["Neon|Fly|Ride"] = 2186.35, ["Mega"] = 6245.65, ["Mega|Fly|Ride"] = 6620.72}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 91.82, ["Fly"] = 278.02, ["Ride"] = 121.96, ["Fly|Ride"] = 336, ["Neon|Ride"] = 694.44, ["Neon|Fly|Ride"] = 620.52, ["Mega|Fly|Ride"] = 2139.5}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 12.03, ["Fly"] = 97.89, ["Ride"] = 37.07, ["Fly|Ride"] = 131.25, ["Neon"] = 111.43, ["Neon|Fly"] = 1261.64, ["Neon|Ride"] = 124.37, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 970.33, ["Mega|Ride"] = 832.91, ["Mega|Fly|Ride"] = 805.84}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 13.13, ["Fly"] = 26.24, ["Ride"] = 21.39, ["Fly|Ride"] = 44.35, ["Neon|Ride"] = 315.62, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2221.75}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 16.69, ["Ride"] = 27.56, ["Fly|Ride"] = 141.9, ["Neon"] = 124.09, ["Neon|Ride"] = 149.63, ["Neon|Fly|Ride"] = 231.14, ["Mega"] = 670.69, ["Mega|Ride"] = 658.88, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.71, ["Ride"] = 19.8, ["Fly|Ride"] = 48.57, ["Neon"] = 35.43, ["Neon|Ride"] = 55.58, ["Neon|Fly|Ride"] = 137.45, ["Mega"] = 695.67, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 277.99}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 23.49, ["Fly"] = 90.57, ["Ride"] = 34.12, ["Fly|Ride"] = 139.13, ["Neon"] = 223.13, ["Neon|Fly"] = 832.91, ["Neon|Ride"] = 173.87, ["Neon|Fly|Ride"] = 408.19, ["Mega"] = 630, ["Mega|Ride"] = 1260}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 420, ["Fly"] = 577.5, ["Ride"] = 438.38, ["Fly|Ride"] = 465.36, ["Neon"] = 1561.88, ["Neon|Ride"] = 1527.32, ["Neon|Fly|Ride"] = 1147.13, ["Mega"] = 7875, ["Mega|Fly|Ride"] = 5411.72}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.1, ["Fly"] = 19.25, ["Ride"] = 15.15, ["Fly|Ride"] = 31.5, ["Neon"] = 18.17, ["Neon|Ride"] = 35.07, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 832.91, ["Mega|Ride"] = 315.69, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 39.6, ["Fly"] = 102.11, ["Ride"] = 71.97, ["Fly|Ride"] = 127.2, ["Neon"] = 227, ["Neon|Fly"] = 428.45, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 255.7, ["Mega"] = 575.16, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 561.65}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 771.75, ["Ride"] = 800.62, ["Fly|Ride"] = 824.15, ["Neon|Ride"] = 1988.23, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 3934.88}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 43.32, ["Fly"] = 69.78, ["Ride"] = 39.5, ["Fly|Ride"] = 101.34, ["Neon|Ride"] = 235.28, ["Neon|Fly|Ride"] = 210.06, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 851.75}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 390.48, ["Fly"] = 384.56, ["Ride"] = 290.76, ["Fly|Ride"] = 345.19, ["Neon|Ride"] = 1576.89, ["Neon|Fly|Ride"] = 1457.57}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 177.19, ["Fly"] = 272.82, ["Ride"] = 194.85, ["Fly|Ride"] = 223.13, ["Neon"] = 902.77, ["Neon|Ride"] = 708.75, ["Neon|Fly|Ride"] = 886.15, ["Mega|Fly|Ride"] = 4954.66}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 865.41, ["Ride"] = 754.69, ["Fly|Ride"] = 917.35, ["Neon|Ride"] = 3651.19, ["Mega|Fly|Ride"] = 7611.19}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 16.1, ["Ride"] = 39.38, ["Fly|Ride"] = 110.24, ["Neon"] = 104.14, ["Neon|Fly"] = 283.8, ["Neon|Ride"] = 107.59, ["Neon|Fly|Ride"] = 274.31, ["Mega"] = 354.38, ["Mega|Ride"] = 302.9, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4084.49, ["Ride"] = 3936.19, ["Fly|Ride"] = 3584.44, ["Neon"] = 13883.9, ["Neon|Fly|Ride"] = 7021.88, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 118.12, ["Fly"] = 166.28, ["Ride"] = 125.99, ["Fly|Ride"] = 201.11, ["Neon"] = 550.97, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 593.25, ["Mega|Fly|Ride"] = 3144.85}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 18.36, ["Ride"] = 19.6, ["Fly|Ride"] = 38.07, ["Neon"] = 19.81, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 144.55, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 359.63, ["Mega|Fly|Ride"] = 227.07}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.39, ["Ride"] = 18.76, ["Fly|Ride"] = 57.71, ["Neon"] = 20.47, ["Neon|Fly"] = 115.86, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 146.69, ["Mega|Ride"] = 199.91, ["Mega|Fly|Ride"] = 328.94}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 34.38, ["Fly"] = 83.31, ["Ride"] = 39.36, ["Fly|Ride"] = 56.34, ["Neon|Fly|Ride"] = 301.88, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 945, ["Ride"] = 1166.2, ["Fly|Ride"] = 1249.5, ["Neon"] = 2915.49}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6693.75, ["Ride"] = 7076.27, ["Fly|Ride"] = 6431.25}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 20.45, ["Fly"] = 36.01, ["Ride"] = 24.65, ["Fly|Ride"] = 36.75, ["Neon"] = 452.12, ["Neon|Ride"] = 141.87, ["Neon|Fly|Ride"] = 199.17, ["Mega"] = 2498.68, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 11.52, ["Ride"] = 24.94, ["Fly|Ride"] = 74.43, ["Neon"] = 89.25, ["Neon|Ride"] = 111.41, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 662.17, ["Mega|Ride"] = 788.6, ["Mega|Fly|Ride"] = 524.16}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 74.04, ["Fly"] = 157.5, ["Ride"] = 85.31, ["Fly|Ride"] = 123.12, ["Neon|Ride"] = 583.04, ["Neon|Fly|Ride"] = 446.25, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 1694.32}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 267.74, ["Ride"] = 261.19, ["Fly|Ride"] = 344.19, ["Neon|Ride"] = 1606.45, ["Neon|Fly|Ride"] = 1000.13, ["Mega|Fly|Ride"] = 4571.84}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.68, ["Ride"] = 32.79, ["Fly|Ride"] = 93.19, ["Neon"] = 15.43, ["Neon|Fly"] = 69.77, ["Neon|Ride"] = 94.58, ["Neon|Fly|Ride"] = 81.22, ["Mega"] = 145.48, ["Mega|Ride"] = 191.02, ["Mega|Fly|Ride"] = 283.19}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 196.88, ["Ride"] = 209.27, ["Fly|Ride"] = 288.75, ["Neon"] = 1000.13, ["Neon|Ride"] = 944.3, ["Neon|Fly|Ride"] = 939.92, ["Mega|Fly|Ride"] = 3454.42}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.1, ["Fly"] = 41.67, ["Ride"] = 14.42, ["Fly|Ride"] = 73.95, ["Neon"] = 19.69, ["Neon|Fly"] = 124.97, ["Neon|Ride"] = 26.2, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 223.13, ["Mega|Ride"] = 223.12, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 223.13, ["Fly"] = 279.96, ["Ride"] = 223.13, ["Fly|Ride"] = 223.13, ["Neon|Fly|Ride"] = 779.81, ["Mega"] = 10411.12, ["Mega|Fly|Ride"] = 4855.75}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 10.11, ["Fly"] = 73.62, ["Ride"] = 28.13, ["Fly|Ride"] = 68.25, ["Neon"] = 73.5, ["Neon|Fly"] = 300.35, ["Neon|Ride"] = 154.1, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 555.97, ["Mega|Ride"] = 624.68, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 3.85, ["Ride"] = 23.33, ["Neon"] = 10.49, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 38.06, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 65.63, ["Mega|Ride"] = 111.15, ["Mega|Fly|Ride"] = 266.54}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.63, ["Neon"] = 3.51, ["Mega"] = 22.98, ["Mega|Ride"] = 149.93}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 4.06, ["Fly"] = 52.49, ["Ride"] = 33.34, ["Fly|Ride"] = 107.26, ["Neon"] = 7.52, ["Neon|Ride"] = 34.04, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 70.42, ["Mega|Fly"] = 157636.55, ["Mega|Ride"] = 139.53, ["Mega|Fly|Ride"] = 205.16}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 70.7, ["Fly"] = 525, ["Ride"] = 116.45, ["Fly|Ride"] = 128.63, ["Neon"] = 236.81, ["Neon|Ride"] = 384.57, ["Neon|Fly|Ride"] = 364.88, ["Mega|Fly|Ride"] = 1184.73}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 34.3, ["Ride"] = 15.74, ["Fly|Ride"] = 110.39, ["Neon"] = 8.69, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 96.02, ["Mega|Ride"] = 165.38}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 9.14, ["Neon"] = 159.64, ["Neon|Ride"] = 131.25, ["Mega|Ride"] = 416.47}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 52.35, ["Neon|Fly|Ride"] = 277.99, ["Mega"] = 15.36, ["Mega|Ride"] = 55.49, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 61.13, ["Ride"] = 15.64, ["Fly|Ride"] = 42.72, ["Neon"] = 2.1, ["Neon|Fly"] = 18.38, ["Neon|Ride"] = 15.64, ["Neon|Fly|Ride"] = 37.86, ["Mega"] = 15.3, ["Mega|Fly"] = 31.25, ["Mega|Ride"] = 18.75, ["Mega|Fly|Ride"] = 64.31}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 18.15, ["Ride"] = 12.71, ["Fly|Ride"] = 64.13, ["Neon"] = 2.63, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 39.25, ["Mega"] = 139.53, ["Mega|Fly"] = 158.43, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 95.81}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.37, ["Neon|Ride"] = 63.67, ["Mega"] = 20.43, ["Mega|Ride"] = 122.88, ["Mega|Fly|Ride"] = 416.47}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.14, ["Fly"] = 91.84, ["Ride"] = 20.95, ["Fly|Ride"] = 107.62, ["Neon"] = 4.17, ["Neon|Fly"] = 168, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 79.75, ["Mega"] = 24.09, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 42.88, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.47, ["Neon|Fly|Ride"] = 416.47, ["Mega"] = 15.75, ["Mega|Fly"] = 135.36, ["Mega|Ride"] = 788.6}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 3.13, ["Fly"] = 77.44, ["Ride"] = 26.25, ["Fly|Ride"] = 70.12, ["Neon"] = 20.87, ["Neon|Fly"] = 69.28, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 131.15, ["Mega|Fly"] = 126.39, ["Mega|Ride"] = 123.37, ["Mega|Fly|Ride"] = 196.27}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 50.94, ["Neon"] = 2.1, ["Neon|Ride"] = 76.99, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 14.84, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 61.03, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.55, ["Fly|Ride"] = 525, ["Neon"] = 18.27, ["Mega"] = 190.31, ["Mega|Fly"] = 315, ["Mega|Ride"] = 277.99, ["Mega|Fly|Ride"] = 539.32}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.55, ["Neon"] = 16.7, ["Mega"] = 105, ["Mega|Ride"] = 78.75}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 32.8, ["Neon"] = 3.91, ["Neon|Ride"] = 40.21, ["Neon|Fly|Ride"] = 139.53, ["Mega"] = 19.69, ["Mega|Ride"] = 49.98, ["Mega|Fly|Ride"] = 131.24}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 11.78, ["Fly|Ride"] = 40.69, ["Neon"] = 2.1, ["Neon|Fly"] = 35.03, ["Neon|Ride"] = 15.64, ["Neon|Fly|Ride"] = 32.45, ["Mega"] = 14.59, ["Mega|Fly"] = 60.32, ["Mega|Ride"] = 20.48, ["Mega|Fly|Ride"] = 49.96}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 229.69, ["Neon"] = 37.38, ["Neon|Ride"] = 140.95, ["Mega"] = 179.82, ["Mega|Ride"] = 240.19}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 26.46, ["Neon"] = 2.1, ["Neon|Ride"] = 26.44, ["Neon|Fly|Ride"] = 105, ["Mega"] = 26.25, ["Mega|Ride"] = 45.84, ["Mega|Fly|Ride"] = 170.77}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.1, ["Neon"] = 14.18, ["Neon|Fly|Ride"] = 139.53, ["Mega"] = 94.4, ["Mega|Ride"] = 166.6, ["Mega|Fly|Ride"] = 238.87}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 34.52, ["Fly|Ride"] = 189.53, ["Neon"] = 21.88, ["Neon|Fly|Ride"] = 139.53, ["Mega"] = 124.69, ["Mega|Ride"] = 143.06, ["Mega|Fly|Ride"] = 193.41}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 1.68, ["Fly"] = 12.51, ["Ride"] = 11.02, ["Fly|Ride"] = 26.28, ["Neon"] = 2.1, ["Neon|Fly"] = 15.62, ["Neon|Ride"] = 13.99, ["Neon|Fly|Ride"] = 30.29, ["Mega"] = 13.86, ["Mega|Fly"] = 26.16, ["Mega|Ride"] = 20.99, ["Mega|Fly|Ride"] = 52.14}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.24, ["Fly"] = 28.13, ["Ride"] = 27.39, ["Fly|Ride"] = 131.25, ["Neon"] = 17.74, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 118.12, ["Mega|Ride"] = 158.43, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.1, ["Ride"] = 22.93, ["Fly|Ride"] = 59.06, ["Neon"] = 55.89, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 236.25, ["Mega|Ride"] = 291.38, ["Mega|Fly|Ride"] = 414.38}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 32.71, ["Ride"] = 13.01, ["Fly|Ride"] = 43.29, ["Neon"] = 2.1, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 14.94, ["Neon|Fly|Ride"] = 35.44, ["Mega"] = 13.13, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 103.69}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 173.91, ["Ride"] = 29.03, ["Neon"] = 7.88, ["Neon|Ride"] = 28.12, ["Neon|Fly|Ride"] = 165.56, ["Mega"] = 65.63, ["Mega|Fly"] = 166.6, ["Mega|Ride"] = 118.02, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Neon"] = 4.11, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 139.53, ["Mega"] = 39.38, ["Mega|Fly"] = 139.53, ["Mega|Ride"] = 139.53, ["Mega|Fly|Ride"] = 307.15}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 2.1, ["Neon|Fly"] = 41.67, ["Neon|Ride"] = 34.12, ["Neon|Fly|Ride"] = 3150, ["Mega"] = 16.66, ["Mega|Ride"] = 40.68, ["Mega|Fly|Ride"] = 188}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 69.78, ["Ride"] = 23.63, ["Fly|Ride"] = 42.02, ["Neon"] = 11.47, ["Neon|Fly"] = 28.12, ["Neon|Ride"] = 19.06, ["Neon|Fly|Ride"] = 57.66, ["Mega"] = 91.88, ["Mega|Ride"] = 139.53, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 56.24, ["Fly|Ride"] = 45.94, ["Neon"] = 6.36, ["Neon|Ride"] = 62.07, ["Neon|Fly|Ride"] = 694.44, ["Mega"] = 40.69, ["Mega|Ride"] = 104.81}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 22.93, ["Ride"] = 15.31, ["Fly|Ride"] = 72.19, ["Neon"] = 3.93, ["Neon|Fly"] = 79.97, ["Neon|Ride"] = 35.47, ["Neon|Fly|Ride"] = 84, ["Mega"] = 103.69, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 142.94}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 13.13, ["Ride"] = 36.27, ["Neon"] = 30.49, ["Neon|Fly"] = 188.89, ["Neon|Fly|Ride"] = 327.3, ["Mega"] = 98.44, ["Mega|Ride"] = 168.38}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 18.76, ["Fly|Ride"] = 57.48, ["Neon"] = 33.7, ["Neon|Fly"] = 56.24, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 139.53, ["Mega"] = 315, ["Mega|Fly"] = 420}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 4.17, ["Fly"] = 22.4, ["Ride"] = 21.47, ["Fly|Ride"] = 48.95, ["Neon"] = 15.75, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 47.3, ["Neon|Fly|Ride"] = 72.17, ["Mega|Ride"] = 416.47, ["Mega|Fly|Ride"] = 555.97}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 110.39, ["Neon"] = 27.57, ["Mega"] = 224.63, ["Mega|Ride"] = 236.24}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 7.77, ["Ride"] = 56.44, ["Neon"] = 262.5, ["Neon|Ride"] = 236.42, ["Mega|Ride"] = 694.44, ["Mega|Fly|Ride"] = 790.22}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.57, ["Ride"] = 27.78, ["Neon"] = 41.67, ["Neon|Ride"] = 124.95, ["Mega"] = 238.88, ["Mega|Ride"] = 367.5}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 11.12, ["Ride"] = 31.5, ["Neon"] = 158.46, ["Neon|Ride"] = 93.71, ["Mega"] = 472.92, ["Mega|Ride"] = 277.99, ["Mega|Fly|Ride"] = 246.75}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 65.01, ["Mega"] = 30.96, ["Mega|Fly"] = 62.49, ["Mega|Ride"] = 124.95, ["Mega|Fly|Ride"] = 156.19}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 40.05}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 6.26, ["Fly"] = 23.61, ["Ride"] = 20.16, ["Fly|Ride"] = 48.95, ["Neon"] = 53.18, ["Neon|Ride"] = 48.5, ["Neon|Fly|Ride"] = 78.63, ["Mega|Ride"] = 208.69, ["Mega|Fly|Ride"] = 289.45}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 13.13, ["Neon"] = 3.35, ["Neon|Fly"] = 31.94, ["Neon|Ride"] = 26.41, ["Neon|Fly|Ride"] = 156.08, ["Mega"] = 24.93, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.63, ["Ride"] = 19.68, ["Neon"] = 10.35, ["Neon|Ride"] = 33.1, ["Mega"] = 78.74, ["Mega|Ride"] = 73.68, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 51.47, ["Ride"] = 18.76, ["Fly|Ride"] = 55.65, ["Neon"] = 15.64, ["Neon|Ride"] = 28.39, ["Neon|Fly|Ride"] = 126.52, ["Mega"] = 124.95, ["Mega|Ride"] = 158.43, ["Mega|Fly|Ride"] = 170.77}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 8.34, ["Ride"] = 36.66, ["Fly|Ride"] = 57.75, ["Neon"] = 35.04, ["Neon|Ride"] = 131.06, ["Mega"] = 416.47, ["Mega|Ride"] = 277.99}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Fly"] = 83.31, ["Ride"] = 31.82, ["Neon"] = 3.94, ["Mega"] = 20.75, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 55.97, ["Mega|Fly|Ride"] = 333.17}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 21.66, ["Ride"] = 16.49, ["Fly|Ride"] = 32.82, ["Neon"] = 2.86, ["Neon|Fly"] = 111.16, ["Neon|Ride"] = 20.84, ["Neon|Fly|Ride"] = 111.14, ["Mega"] = 31.69, ["Mega|Ride"] = 47.57, ["Mega|Fly|Ride"] = 128.07}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.11, ["Ride"] = 13.16, ["Fly|Ride"] = 41.67, ["Neon"] = 3.93, ["Neon|Fly"] = 91.03, ["Neon|Ride"] = 18.15, ["Neon|Fly|Ride"] = 56.22, ["Mega"] = 56.23, ["Mega|Fly"] = 139.53, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 158.43}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 28.13, ["Ride"] = 53.11, ["Fly|Ride"] = 139.54, ["Neon"] = 7.87, ["Neon|Ride"] = 38.54, ["Neon|Fly|Ride"] = 111.41, ["Mega"] = 32.24, ["Mega|Ride"] = 99.28, ["Mega|Fly|Ride"] = 215.25}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 2.5, ["Neon|Ride"] = 166.6, ["Neon|Fly|Ride"] = 152274.96, ["Mega"] = 18.78, ["Mega|Fly"] = 106.45, ["Mega|Ride"] = 110.29, ["Mega|Fly|Ride"] = 416.47}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.88, ["Ride"] = 16.97, ["Fly|Ride"] = 79.15, ["Neon"] = 3.04, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 85.14, ["Mega"] = 19.2, ["Mega|Ride"] = 41.3, ["Mega|Fly|Ride"] = 98.46}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Neon"] = 2.1, ["Neon|Ride"] = 36.74, ["Mega"] = 22.39, ["Mega|Ride"] = 411.22}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.55, ["Neon"] = 2.1, ["Neon|Ride"] = 315.62, ["Neon|Fly|Ride"] = 420, ["Mega"] = 19.69, ["Mega|Ride"] = 158.43}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 30.21, ["Fly|Ride"] = 56.24, ["Neon"] = 3.89, ["Neon|Ride"] = 17.03, ["Neon|Fly|Ride"] = 45.93, ["Mega"] = 56.23, ["Mega|Fly"] = 39.38, ["Mega|Ride"] = 49.86, ["Mega|Fly|Ride"] = 94.49}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 10.99, ["Ride"] = 77.96, ["Neon"] = 147, ["Mega"] = 435.75, ["Mega|Ride"] = 666.75}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 3.94, ["Fly"] = 6562.5, ["Ride"] = 56.24, ["Neon"] = 42}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 4.13, ["Ride"] = 30.5, ["Fly|Ride"] = 177.02, ["Neon"] = 26.13, ["Mega"] = 397.94, ["Mega|Ride"] = 356.08, ["Mega|Fly|Ride"] = 375.27}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 12.98, ["Ride"] = 15.64, ["Fly|Ride"] = 24.9, ["Neon"] = 2.1, ["Neon|Fly"] = 15.64, ["Neon|Ride"] = 10.43, ["Neon|Fly|Ride"] = 25.7, ["Mega"] = 14.19, ["Mega|Fly"] = 22.8, ["Mega|Ride"] = 20.5, ["Mega|Fly|Ride"] = 50.97}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.55, ["Fly"] = 118.12, ["Ride"] = 65.63, ["Neon"] = 5.25, ["Neon|Fly"] = 66.65, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 694.44, ["Mega"] = 85.32, ["Mega|Ride"] = 118.02}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.2, ["Neon"] = 2.1, ["Neon|Fly"] = 31.25, ["Neon|Ride"] = 22.6, ["Neon|Fly|Ride"] = 84.16, ["Mega"] = 14.42, ["Mega|Fly"] = 123.92, ["Mega|Ride"] = 69.55, ["Mega|Fly|Ride"] = 132.23}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 127.32, ["Mega"] = 17.88, ["Mega|Fly|Ride"] = 166.6}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 41.97, ["Ride"] = 16.88, ["Fly|Ride"] = 67.41, ["Neon"] = 10.91, ["Neon|Ride"] = 32.04, ["Neon|Fly|Ride"] = 139.53, ["Mega"] = 208.95, ["Mega|Ride"] = 395.63, ["Mega|Fly|Ride"] = 416.47}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 178.26, ["Fly"] = 183.75, ["Ride"] = 196.67, ["Fly|Ride"] = 833, ["Neon|Fly|Ride"] = 924.52, ["Mega"] = 8328.91, ["Mega|Fly|Ride"] = 3942.88}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 18.76, ["Neon"] = 10.5, ["Neon|Ride"] = 64.32, ["Mega"] = 91.88, ["Mega|Ride"] = 111.15, ["Mega|Fly|Ride"] = 624.88}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.47, ["Fly"] = 103.68, ["Ride"] = 26.03, ["Fly|Ride"] = 65.63, ["Neon"] = 4.78, ["Neon|Ride"] = 94.58, ["Neon|Fly|Ride"] = 166.6, ["Mega"] = 374.07, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 412.3}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 14.89, ["Ride"] = 13.55, ["Fly|Ride"] = 32.79, ["Neon"] = 3.92, ["Neon|Fly"] = 28.13, ["Neon|Ride"] = 29.46, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 49.88, ["Mega|Ride"] = 81.38, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 69.78, ["Ride"] = 19.69, ["Fly|Ride"] = 92.57, ["Neon"] = 6.46, ["Neon|Ride"] = 78.46, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 70.35, ["Mega|Ride"] = 189.17}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 6.44, ["Fly"] = 23.49, ["Ride"] = 15.01, ["Fly|Ride"] = 36, ["Neon"] = 23.66, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 107.6, ["Mega|Ride"] = 277.99, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 4.97, ["Ride"] = 41.67, ["Fly|Ride"] = 251.99, ["Neon"] = 91.88, ["Neon|Ride"] = 140.72, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 352.95, ["Mega|Ride"] = 386.32, ["Mega|Fly|Ride"] = 1041.13}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 23.87, ["Ride"] = 13.13, ["Fly|Ride"] = 35.26, ["Neon"] = 19.85, ["Neon|Fly"] = 76.13, ["Neon|Ride"] = 28.81, ["Neon|Fly|Ride"] = 76.13, ["Mega|Ride"] = 208.24, ["Mega|Fly|Ride"] = 245.25}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 60.96, ["Fly"] = 120.8, ["Ride"] = 85.2, ["Fly|Ride"] = 140.93, ["Neon"] = 382.15, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 1577.16}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 223.12, ["Fly"] = 333.21, ["Ride"] = 249.23, ["Fly|Ride"] = 315, ["Neon|Ride"] = 2602.79, ["Neon|Fly|Ride"] = 906.46, ["Mega"] = 10411.12, ["Mega|Fly|Ride"] = 4814.12}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 55.59, ["Fly"] = 139.54, ["Ride"] = 68.25, ["Fly|Ride"] = 105, ["Neon"] = 709.47, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 354.26, ["Mega|Fly|Ride"] = 1284.03}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 3.94, ["Fly"] = 288.42, ["Ride"] = 36.46, ["Fly|Ride"] = 137.67, ["Neon"] = 23.63, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 139.53, ["Mega"] = 277.99, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 9.49, ["Fly"] = 69.78, ["Ride"] = 31.5, ["Fly|Ride"] = 70.96, ["Neon"] = 81.37, ["Neon|Ride"] = 126.27, ["Mega"] = 353.07, ["Mega|Ride"] = 387.21, ["Mega|Fly|Ride"] = 1249.35}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 12.6, ["Fly|Ride"] = 44.51, ["Neon"] = 3.94, ["Neon|Fly"] = 23.63, ["Neon|Ride"] = 20.58, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 57.37, ["Mega|Fly"] = 154.88, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 84.46}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 5.94, ["Fly"] = 89.86, ["Ride"] = 20.89, ["Fly|Ride"] = 81.38, ["Neon"] = 124.04, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 164.51, ["Mega"] = 413.44, ["Mega|Ride"] = 1018.5, ["Mega|Fly|Ride"] = 732.38}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.91, ["Ride"] = 15.21, ["Fly|Ride"] = 35.44, ["Neon"] = 11.81, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 31.44, ["Neon|Fly|Ride"] = 104.68, ["Mega"] = 181.17, ["Mega|Ride"] = 218.66, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 3.08, ["Ride"] = 27.2, ["Fly|Ride"] = 328.13, ["Neon"] = 19.69, ["Neon|Ride"] = 35.41, ["Mega"] = 207.38, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 374.81}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 33.33, ["Ride"] = 19.69, ["Neon"] = 2.1, ["Neon|Ride"] = 19.65, ["Neon|Fly|Ride"] = 57.73, ["Mega"] = 14.44, ["Mega|Ride"] = 41.66, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 18.85, ["Fly|Ride"] = 41.67, ["Neon"] = 15.75, ["Neon|Fly"] = 104.14, ["Neon|Ride"] = 35.41, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 108.94, ["Mega|Fly|Ride"] = 158.43}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 24.94, ["Ride"] = 19.69, ["Fly|Ride"] = 61.53, ["Neon"] = 47.25, ["Neon|Ride"] = 47.25, ["Mega"] = 131.17, ["Mega|Ride"] = 197.82, ["Mega|Fly|Ride"] = 472.92}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 118.12, ["Fly"] = 154.34, ["Ride"] = 157.5, ["Fly|Ride"] = 216.57, ["Neon"] = 672.66, ["Neon|Ride"] = 560.44, ["Neon|Fly|Ride"] = 621.04, ["Mega"] = 4164.46, ["Mega|Ride"] = 2638.19, ["Mega|Fly|Ride"] = 2035.69}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 10.12, ["Ride"] = 32.3, ["Fly|Ride"] = 208.27, ["Neon"] = 42, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 376.56, ["Mega"] = 339.33, ["Mega|Ride"] = 556.04, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 41.91, ["Ride"] = 17.07, ["Fly|Ride"] = 36.01, ["Neon"] = 13, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 120.74, ["Mega"] = 236.48, ["Mega|Fly|Ride"] = 315.69}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 24.55, ["Ride"] = 56.24, ["Fly|Ride"] = 170.63, ["Neon"] = 177.19, ["Neon|Fly|Ride"] = 584.81, ["Mega"] = 551.25, ["Mega|Fly"] = 832.91, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 3.85}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 126.84, ["Neon"] = 52.5, ["Neon|Ride"] = 91.83, ["Neon|Fly|Ride"] = 347.74, ["Mega"] = 320.67, ["Mega|Ride"] = 389.4, ["Mega|Fly|Ride"] = 867.81}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 26.11, ["Fly"] = 26.2, ["Ride"] = 30.19, ["Fly|Ride"] = 49.26, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 208.24, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 2082.24, ["Mega|Fly|Ride"] = 832.91}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 23.97, ["Neon"] = 3.71, ["Neon|Fly"] = 65.62, ["Neon|Ride"] = 31.25, ["Neon|Fly|Ride"] = 106.28, ["Mega"] = 31.5, ["Mega|Ride"] = 57.66, ["Mega|Fly|Ride"] = 228.69}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 6.26, ["Fly"] = 28.13, ["Ride"] = 25.01, ["Fly|Ride"] = 65.63, ["Neon"] = 45.94, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 236.42, ["Mega"] = 268.38, ["Mega|Fly"] = 394.9, ["Mega|Ride"] = 275.63}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 13.02, ["Fly|Ride"] = 28.13, ["Neon"] = 14.22, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 35.11, ["Neon|Fly|Ride"] = 64.37, ["Mega"] = 173.87, ["Mega|Ride"] = 182.23, ["Mega|Fly|Ride"] = 271.69}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 78.11, ["Neon"] = 2.63, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 208.24, ["Mega"] = 27.08, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 181.17}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 23.77, ["Ride"] = 74.44, ["Fly|Ride"] = 141.9, ["Neon"] = 331.13, ["Neon|Ride"] = 280.88, ["Neon|Fly|Ride"] = 576.19, ["Mega"] = 729.28, ["Mega|Fly|Ride"] = 965.69}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 2.44, ["Ride"] = 83.31, ["Fly|Ride"] = 210, ["Neon"] = 92.26, ["Neon|Ride"] = 139.53, ["Mega|Ride"] = 525}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 2.43, ["Fly"] = 36.46, ["Ride"] = 21.47, ["Fly|Ride"] = 52.07, ["Neon"] = 26.1, ["Neon|Fly"] = 315, ["Neon|Ride"] = 32.8, ["Neon|Fly|Ride"] = 139.53, ["Mega"] = 333.17, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 61.04, ["Fly"] = 433.13, ["Ride"] = 393.73, ["Fly|Ride"] = 262.48, ["Neon"] = 328.13, ["Neon|Ride"] = 525, ["Mega|Ride"] = 2165.63, ["Mega|Fly|Ride"] = 2056.21}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 8.57, ["Fly"] = 32.7, ["Ride"] = 23.15, ["Fly|Ride"] = 57.64, ["Neon"] = 46.06, ["Neon|Ride"] = 52.95, ["Neon|Fly|Ride"] = 277.99, ["Mega"] = 509.25, ["Mega|Ride"] = 284.82, ["Mega|Fly|Ride"] = 689.22}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 74.8, ["Fly"] = 162.45, ["Ride"] = 104.99, ["Neon"] = 270.38, ["Neon|Ride"] = 223.12, ["Mega"] = 1222.28, ["Mega|Ride"] = 901.78, ["Mega|Fly|Ride"] = 1072.87}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 14.6, ["Ride"] = 53.91, ["Fly|Ride"] = 139.54, ["Neon"] = 72.16, ["Neon|Ride"] = 139.53, ["Neon|Fly|Ride"] = 212.77, ["Mega"] = 590.63, ["Mega|Ride"] = 330.48, ["Mega|Fly|Ride"] = 413.44}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 4.72, ["Fly"] = 104.13, ["Ride"] = 28.13, ["Fly|Ride"] = 62.49, ["Neon"] = 49.7, ["Neon|Ride"] = 90.56, ["Neon|Fly|Ride"] = 375.98, ["Mega"] = 208.24, ["Mega|Ride"] = 1561.68, ["Mega|Fly|Ride"] = 694.44}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 14.28, ["Ride"] = 139.13, ["Fly|Ride"] = 162.54, ["Neon"] = 66.98, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 300.32, ["Mega|Ride"] = 306.8, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 7.88, ["Ride"] = 24.8, ["Fly|Ride"] = 87.39, ["Neon"] = 31.15, ["Neon|Ride"] = 83.21, ["Neon|Fly|Ride"] = 187.41, ["Mega"] = 236.25, ["Mega|Ride"] = 290.07, ["Mega|Fly|Ride"] = 417.38}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 57.2, ["Mega"] = 26.25, ["Mega|Ride"] = 124.95, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 8.34, ["Ride"] = 28.42, ["Neon"] = 23.78, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 105, ["Mega|Ride"] = 273.82, ["Mega|Fly|Ride"] = 414.38}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 123.93, ["Neon"] = 27.19, ["Mega"] = 189.17, ["Mega|Ride"] = 137.45, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 4.8, ["Ride"] = 32.79, ["Fly|Ride"] = 118.26, ["Neon"] = 31.25, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 123.92, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 511.87, ["Ride"] = 565.9, ["Fly|Ride"] = 711.55, ["Neon|Ride"] = 1802.07, ["Neon|Fly|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 5.25, ["Fly"] = 28.13, ["Ride"] = 23.63, ["Fly|Ride"] = 56.35, ["Neon"] = 40.63, ["Neon|Ride"] = 97.88, ["Neon|Fly|Ride"] = 341.24, ["Mega"] = 158.45, ["Mega|Ride"] = 362.97, ["Mega|Fly|Ride"] = 472.68}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 6.03, ["Fly"] = 524.69, ["Ride"] = 31.13, ["Fly|Ride"] = 51.55, ["Neon"] = 48.57, ["Neon|Fly"] = 315, ["Neon|Ride"] = 97.35, ["Neon|Fly|Ride"] = 158.43, ["Mega"] = 331.86, ["Mega|Ride"] = 443.52, ["Mega|Fly|Ride"] = 541.4}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.1, ["Fly"] = 91.87, ["Ride"] = 28.13, ["Fly|Ride"] = 312.39, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 158.43}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.61, ["Ride"] = 21.84, ["Fly|Ride"] = 90.57, ["Neon"] = 6.39, ["Neon|Ride"] = 29.91, ["Neon|Fly|Ride"] = 86.91, ["Mega"] = 68.25, ["Mega|Ride"] = 88.64, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 69.78, ["Ride"] = 17.07, ["Neon"] = 2.89, ["Neon|Ride"] = 24.05, ["Neon|Fly|Ride"] = 124.95, ["Mega"] = 18.4, ["Mega|Ride"] = 65.54, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1109.07}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 21.67, ["Ride"] = 62.49, ["Fly|Ride"] = 52.5, ["Neon"] = 65.63, ["Neon|Ride"] = 91.75, ["Mega"] = 555.97, ["Mega|Ride"] = 567.5, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 28.26, ["Neon"] = 6.01, ["Neon|Ride"] = 56.44, ["Mega"] = 39.37, ["Mega|Ride"] = 141.85, ["Mega|Fly|Ride"] = 268.38}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 385.81, ["Ride"] = 126.53, ["Neon"] = 22.23, ["Neon|Ride"] = 139.53, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 183.75, ["Mega|Ride"] = 367.5}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 419.98, ["Ride"] = 472.5, ["Fly|Ride"] = 556.5, ["Neon|Ride"] = 1430.04, ["Neon|Fly|Ride"] = 2085.54, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 3.34, ["Fly"] = 196.88, ["Ride"] = 56.24, ["Fly|Ride"] = 416.51, ["Neon"] = 36.4, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 189.17, ["Mega"] = 519.52, ["Mega|Ride"] = 472.92, ["Mega|Fly|Ride"] = 694.01}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 90.33, ["Ride"] = 22.3, ["Fly|Ride"] = 118.13, ["Neon"] = 4.49, ["Neon|Ride"] = 35.78, ["Neon|Fly|Ride"] = 146.62, ["Mega"] = 37.05, ["Mega|Fly"] = 124.95, ["Mega|Ride"] = 71.6, ["Mega|Fly|Ride"] = 5206.11}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 28.39, ["Mega"] = 32.71, ["Mega|Ride"] = 134.78, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 10.28, ["Fly"] = 107.9, ["Ride"] = 80.05, ["Fly|Ride"] = 87.28, ["Neon"] = 127.45, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 230.52, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 497.67, ["Mega|Ride"] = 620.52, ["Mega|Fly|Ride"] = 602.44}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 8.05, ["Neon"] = 80.12, ["Neon|Ride"] = 158.41, ["Neon|Fly|Ride"] = 533.22, ["Mega"] = 574.71, ["Mega|Ride"] = 477.75}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 7.3, ["Ride"] = 31.38, ["Neon"] = 131.25, ["Neon|Ride"] = 178.52, ["Mega"] = 646.71, ["Mega|Fly|Ride"] = 1249.35}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 12.51, ["Ride"] = 23.15, ["Fly|Ride"] = 262.5, ["Neon"] = 167.37, ["Neon|Ride"] = 182.44, ["Neon|Fly|Ride"] = 208.24, ["Mega"] = 616.88, ["Mega|Ride"] = 521.39, ["Mega|Fly|Ride"] = 694.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 347.08, ["Ride"] = 328.13, ["Neon"] = 1115.63, ["Neon|Ride"] = 1182.09, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4164.46}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 3.4, ["Fly"] = 78.73, ["Ride"] = 20.11, ["Fly|Ride"] = 236.25, ["Neon"] = 144.04, ["Neon|Ride"] = 207.19, ["Neon|Fly|Ride"] = 193.86, ["Mega"] = 749.61, ["Mega|Fly|Ride"] = 719.42}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.94, ["Ride"] = 126, ["Neon"] = 65.63, ["Neon|Ride"] = 221.82, ["Mega"] = 189.17, ["Mega|Ride"] = 832.91, ["Mega|Fly|Ride"] = 1041.13}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 20.22, ["Fly"] = 139.54, ["Ride"] = 70.88, ["Neon"] = 80.03, ["Neon|Ride"] = 147.98, ["Neon|Fly|Ride"] = 371.24, ["Mega"] = 301.76, ["Mega|Fly"] = 694.44, ["Mega|Ride"] = 291.38, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.62, ["Fly|Ride"] = 139.54, ["Neon"] = 6.48, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 268.62, ["Mega"] = 36.75, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 40.69, ["Ride"] = 102.05, ["Neon"] = 315, ["Neon|Ride"] = 415.42, ["Neon|Fly|Ride"] = 459.15, ["Mega"] = 2498.68, ["Mega|Ride"] = 2756.87, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 521, ["Ride"] = 26.25, ["Neon"] = 8.03, ["Neon|Fly"] = 181.19, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 119.28, ["Mega"] = 101.07, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 236.48}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 26.22, ["Ride"] = 28.54, ["Neon"] = 3.84, ["Neon|Fly"] = 49.39, ["Neon|Ride"] = 46.18, ["Neon|Fly|Ride"] = 90.6, ["Mega"] = 38.26, ["Mega|Fly"] = 112.88, ["Mega|Ride"] = 75.48, ["Mega|Fly|Ride"] = 170.46}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 37.97, ["Fly|Ride"] = 127.52, ["Neon"] = 14.44, ["Neon|Ride"] = 53.73, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 111.15, ["Mega|Ride"] = 144.27, ["Mega|Fly|Ride"] = 277.99}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 50.88, ["Fly"] = 94.59, ["Ride"] = 60.25, ["Fly|Ride"] = 169.32, ["Neon"] = 291.38, ["Neon|Ride"] = 626.07, ["Neon|Fly|Ride"] = 472.92, ["Mega|Ride"] = 1110.88, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 258.24, ["Ride"] = 309.75, ["Fly|Ride"] = 415.48, ["Neon"] = 1462.13, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1490.89, ["Mega"] = 4200, ["Mega|Fly|Ride"] = 4417.88}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 2.63, ["Neon"] = 27.27, ["Neon|Fly"] = 350.44, ["Mega"] = 98.34, ["Mega|Ride"] = 139.53}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 10.5, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 139.13, ["Mega"] = 62.41, ["Mega|Fly"] = 210, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 188.99}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.1, ["Fly"] = 158.43, ["Ride"] = 27.57, ["Fly|Ride"] = 95.82, ["Neon"] = 32.82, ["Neon|Ride"] = 69.77, ["Mega"] = 170.63, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 3.88, ["Fly"] = 70.82, ["Ride"] = 33.33, ["Fly|Ride"] = 69.8, ["Neon"] = 11.45, ["Neon|Ride"] = 61.45, ["Neon|Fly|Ride"] = 154.1, ["Mega"] = 78.66, ["Mega|Ride"] = 155.5, ["Mega|Fly|Ride"] = 255.39}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 7.88, ["Neon|Fly|Ride"] = 190.54, ["Mega"] = 40.11, ["Mega|Fly|Ride"] = 344.61}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 28.13, ["Ride"] = 18.38, ["Fly|Ride"] = 51.19, ["Neon"] = 2.3, ["Neon|Fly"] = 79.21, ["Neon|Ride"] = 28.12, ["Neon|Fly|Ride"] = 416.47, ["Mega"] = 39.38, ["Mega|Ride"] = 101.7, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 20.84, ["Fly|Ride"] = 28.13, ["Neon"] = 13.12, ["Neon|Fly"] = 64.96, ["Neon|Ride"] = 26.57, ["Neon|Fly|Ride"] = 94.59, ["Mega"] = 156.15, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 28.88, ["Fly"] = 52.5, ["Ride"] = 31.37, ["Fly|Ride"] = 78.73, ["Neon"] = 194.73, ["Neon|Ride"] = 291.53, ["Mega"] = 388.5, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 564.24}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 63, ["Ride"] = 78.65, ["Fly|Ride"] = 139.54, ["Neon"] = 840, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 3153.13, ["Mega|Ride"] = 3255, ["Mega|Fly|Ride"] = 1502.82}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 17.88, ["Fly|Ride"] = 131.25, ["Neon"] = 2.69, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 26.2, ["Neon|Fly|Ride"] = 128.47, ["Mega"] = 37.92, ["Mega|Fly"] = 672, ["Mega|Ride"] = 93.19}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 14, ["Ride"] = 14.17, ["Fly|Ride"] = 20.84, ["Neon"] = 3.72, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 18.75, ["Neon|Fly|Ride"] = 61.68, ["Mega"] = 50.86, ["Mega|Fly"] = 131.21, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 2.71, ["Ride"] = 73.5, ["Neon"] = 39.38, ["Neon|Ride"] = 141.87, ["Neon|Fly|Ride"] = 277.99, ["Mega"] = 686.11, ["Mega|Fly|Ride"] = 631.35}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.74, ["Fly"] = 518.44, ["Ride"] = 472.5, ["Fly|Ride"] = 577.5, ["Neon|Ride"] = 1891.33, ["Mega|Fly|Ride"] = 7882.2}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 17, ["Fly"] = 101.33, ["Ride"] = 47.09, ["Fly|Ride"] = 103.83, ["Neon"] = 283.8, ["Neon|Ride"] = 210.74, ["Neon|Fly|Ride"] = 305.81, ["Mega|Ride"] = 1249.35}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 21.2, ["Fly|Ride"] = 281.31, ["Neon"] = 8.17, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 168.68, ["Mega"] = 84.88, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 264.22}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 65.61, ["Fly|Ride"] = 143.05, ["Neon"] = 17.75, ["Neon|Ride"] = 72.34, ["Mega"] = 328.13}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 24.46, ["Fly"] = 170.63, ["Ride"] = 47.92, ["Fly|Ride"] = 52.5, ["Neon"] = 194.25, ["Neon|Ride"] = 353.99, ["Neon|Fly|Ride"] = 315.69, ["Mega"] = 2498.68, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1197.3}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 77.16, ["Ride"] = 111.16, ["Fly|Ride"] = 416.51, ["Neon"] = 434.43, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 8328.91, ["Mega|Fly|Ride"] = 6246.69}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 190.32, ["Ride"] = 270.56, ["Fly|Ride"] = 519.6, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1035.57, ["Mega|Fly|Ride"] = 4147.5}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 12.17, ["Fly"] = 56.24, ["Ride"] = 62.49, ["Fly|Ride"] = 96.17, ["Neon"] = 78.75, ["Neon|Ride"] = 122.07, ["Mega"] = 388.49, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 512.3}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 18.32, ["Ride"] = 13.95, ["Fly|Ride"] = 43.31, ["Neon"] = 11.69, ["Neon|Ride"] = 23.14, ["Neon|Fly|Ride"] = 90.6, ["Mega"] = 93.19, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 170.43}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.1, ["Fly"] = 39.19, ["Ride"] = 16.02, ["Fly|Ride"] = 77.07, ["Neon"] = 80.07, ["Neon|Fly"] = 145.79, ["Neon|Ride"] = 44.51, ["Neon|Fly|Ride"] = 79.21, ["Mega"] = 381.09, ["Mega|Ride"] = 277.99, ["Mega|Fly|Ride"] = 366.19}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 317.63, ["Fly"] = 486.27, ["Ride"] = 371.91, ["Fly|Ride"] = 616.43, ["Neon"] = 1575, ["Neon|Ride"] = 2150.36, ["Mega"] = 9994.68, ["Mega|Fly|Ride"] = 5811.5}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Neon"] = 6.38, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 35.44, ["Mega|Ride"] = 170.99}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.29, ["Fly"] = 694.53, ["Ride"] = 15.73, ["Fly|Ride"] = 55.13, ["Neon"] = 26.17, ["Neon|Ride"] = 37.93, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 230.1, ["Mega|Ride"] = 194.25, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 15.61, ["Ride"] = 83.15, ["Neon"] = 111.43, ["Neon|Ride"] = 236.25, ["Mega"] = 521.18, ["Mega|Ride"] = 649.69, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 102.37, ["Fly"] = 157.5, ["Ride"] = 109.51, ["Fly|Ride"] = 127.03, ["Neon|Ride"] = 555.97, ["Neon|Fly|Ride"] = 586.34, ["Mega|Fly|Ride"] = 2378.25}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 14.42, ["Fly"] = 43.29, ["Ride"] = 23, ["Fly|Ride"] = 57.75, ["Neon"] = 104.14, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 694.44, ["Mega|Ride"] = 471.19, ["Mega|Fly|Ride"] = 727.13}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 20.84, ["Neon"] = 2.1, ["Neon|Ride"] = 139.53, ["Mega"] = 24.93, ["Mega|Fly|Ride"] = 277.99}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 69.78, ["Neon"] = 2.23, ["Neon|Ride"] = 18.95, ["Neon|Fly|Ride"] = 97.02, ["Mega"] = 27.08, ["Mega|Fly"] = 87.64, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 103.94}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 10.5, ["Ride"] = 69.21, ["Fly|Ride"] = 136.85, ["Neon"] = 35.06, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 81.77, ["Neon|Fly|Ride"] = 181.91, ["Mega"] = 140.51, ["Mega|Fly"] = 277.99, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1455.57, ["Ride"] = 1429.3, ["Fly|Ride"] = 1455.57, ["Neon|Ride"] = 4200, ["Neon|Fly|Ride"] = 3976.88, ["Mega|Fly|Ride"] = 12589.5}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 446.25, ["Ride"] = 498.02, ["Fly|Ride"] = 716.56, ["Neon"] = 2444.85, ["Neon|Ride"] = 1640.63, ["Neon|Fly|Ride"] = 1968.75, ["Mega"] = 16657.8}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 324.19, ["Ride"] = 314.99, ["Fly|Ride"] = 429.18, ["Neon"] = 656.25, ["Neon|Ride"] = 803.36, ["Neon|Fly|Ride"] = 786.18, ["Mega|Fly|Ride"] = 2916.24}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 248.07, ["Ride"] = 321.57, ["Fly|Ride"] = 482.1, ["Neon"] = 1389.03, ["Neon|Ride"] = 931.82, ["Neon|Fly|Ride"] = 1049.99, ["Mega|Fly|Ride"] = 4164.46}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 64.31, ["Ride"] = 15.64, ["Fly|Ride"] = 37.3, ["Neon"] = 7.88, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 105, ["Mega"] = 69.47, ["Mega|Fly"] = 97.88, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 333.38, ["Fly"] = 1389.03, ["Ride"] = 402.97, ["Fly|Ride"] = 943.95, ["Neon"] = 1574.99, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1942.74, ["Mega|Fly|Ride"] = 4198.69}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.41, ["Fly"] = 157.5, ["Ride"] = 40.63, ["Neon"] = 17.64, ["Neon|Ride"] = 207.34, ["Neon|Fly|Ride"] = 252, ["Mega"] = 137.36, ["Mega|Ride"] = 312.3, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 18.12, ["Ride"] = 20.84, ["Fly|Ride"] = 31.98, ["Neon"] = 11.8, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 111.41, ["Mega"] = 105, ["Mega|Ride"] = 208.24, ["Mega|Fly|Ride"] = 144.73}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 3.69, ["Neon|Ride"] = 39.38, ["Mega"] = 40.21, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 30.63, ["Fly|Ride"] = 459.38, ["Neon"] = 273, ["Neon|Ride"] = 351.29, ["Mega"] = 1050, ["Mega|Ride"] = 488.25, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 7881.98, ["Ride"] = 28.4, ["Fly|Ride"] = 68.24, ["Neon"] = 73.5, ["Mega|Fly|Ride"] = 416.47}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 3.55, ["Neon|Ride"] = 41.57, ["Neon|Fly|Ride"] = 95.86, ["Mega"] = 26.15, ["Mega|Ride"] = 70.26, ["Mega|Fly|Ride"] = 160.34}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 34.13, ["Ride"] = 18.45, ["Fly|Ride"] = 78.65, ["Neon"] = 12.53, ["Neon|Fly"] = 113.9, ["Neon|Ride"] = 30.87, ["Neon|Fly|Ride"] = 77.05, ["Mega"] = 129.51, ["Mega|Fly"] = 472.92, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 19.23, ["Fly|Ride"] = 52.5, ["Neon"] = 154.12, ["Neon|Ride"] = 158.41, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 238.83, ["Mega|Ride"] = 300.53, ["Mega|Fly|Ride"] = 1321.69}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 10.01, ["Ride"] = 62.49, ["Neon"] = 115.5, ["Mega"] = 513.13, ["Mega|Ride"] = 413.44, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 6306.05, ["Ride"] = 19.69, ["Neon"] = 63, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 183.73, ["Neon|Fly|Ride"] = 709.38, ["Mega"] = 301.88, ["Mega|Ride"] = 486.21, ["Mega|Fly|Ride"] = 402.94}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 94.78, ["Ride"] = 18.38, ["Fly|Ride"] = 45.93, ["Neon"] = 5.16, ["Neon|Fly"] = 31.25, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 74.97, ["Mega"] = 39.38, ["Mega|Fly|Ride"] = 312.36}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 157.4, ["Ride"] = 164.07, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 2602.79, ["Neon|Fly|Ride"] = 1036.88, ["Mega"] = 8328.91, ["Mega|Fly|Ride"] = 3475.5}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 14.42, ["Fly|Ride"] = 28.61, ["Neon"] = 2.56, ["Neon|Fly"] = 52.07, ["Neon|Ride"] = 23.65, ["Neon|Fly|Ride"] = 56.36, ["Mega"] = 44.63, ["Mega|Ride"] = 52.76, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 6.08, ["Ride"] = 42.36, ["Fly|Ride"] = 183.75, ["Neon"] = 134.81, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 312.38, ["Mega|Fly"] = 788.6, ["Mega|Fly|Ride"] = 694.44}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 23.4, ["Fly"] = 262.5, ["Ride"] = 278.02, ["Fly|Ride"] = 170.63, ["Neon"] = 208.27, ["Neon|Ride"] = 270.21, ["Mega"] = 972.41, ["Mega|Ride"] = 832.91, ["Mega|Fly|Ride"] = 828.74}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 171.9, ["Ride"] = 213.94, ["Fly|Ride"] = 261.19, ["Neon"] = 761.25, ["Neon|Ride"] = 922.44, ["Neon|Fly|Ride"] = 905.63, ["Mega|Fly|Ride"] = 3359.69}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 21.52, ["Fly|Ride"] = 139.54, ["Neon"] = 91.87, ["Mega"] = 287.44, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 694.44}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 8.06, ["Ride"] = 210, ["Fly|Ride"] = 181.19, ["Neon"] = 416.51, ["Neon|Fly"] = 158.46, ["Neon|Ride"] = 198.61, ["Mega"] = 788.6, ["Mega|Ride"] = 832.91}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 957.9, ["Fly"] = 1050, ["Ride"] = 1049.99, ["Fly|Ride"] = 1443.75, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 4784.96, ["Mega|Fly|Ride"] = 19018}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 13.12, ["Fly"] = 19.69, ["Ride"] = 19.8, ["Fly|Ride"] = 43.32, ["Neon"] = 70.88, ["Neon|Fly"] = 107.14, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 208.24, ["Mega"] = 221.1, ["Mega|Fly|Ride"] = 389.4}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 3.8, ["Fly"] = 51.19, ["Ride"] = 26.25, ["Fly|Ride"] = 135.19, ["Neon"] = 35.21, ["Neon|Ride"] = 65.6, ["Mega"] = 201.99, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 262.17}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 82.27, ["Ride"] = 26.13, ["Fly|Ride"] = 942.38, ["Neon"] = 10.5, ["Neon|Ride"] = 47.3, ["Mega"] = 199.66, ["Mega|Ride"] = 240.62}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 12.29, ["Ride"] = 32.46, ["Fly|Ride"] = 86.63, ["Neon"] = 77.42, ["Neon|Fly"] = 143.83, ["Neon|Ride"] = 79.45, ["Neon|Fly|Ride"] = 196.27, ["Mega"] = 416.47, ["Mega|Ride"] = 431.82, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 8.34, ["Fly"] = 20.45, ["Ride"] = 22.93, ["Fly|Ride"] = 51.19, ["Neon"] = 16.76, ["Neon|Fly"] = 43.31, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 97.88, ["Mega|Fly"] = 249.87, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 16.77, ["Neon"] = 12.72, ["Neon|Fly"] = 13125, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 141.89, ["Mega|Ride"] = 199.38, ["Mega|Fly|Ride"] = 350.44}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 259.88, ["Ride"] = 231, ["Fly|Ride"] = 2082.49, ["Neon|Fly|Ride"] = 1388.86}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 22.93, ["Fly|Ride"] = 72.19, ["Neon"] = 6.18, ["Neon|Ride"] = 32.55, ["Neon|Fly|Ride"] = 157.22, ["Mega"] = 276.95, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.19, ["Ride"] = 82.02, ["Fly|Ride"] = 88.87, ["Neon"] = 139.54, ["Neon|Ride"] = 188.27, ["Mega"] = 139.53, ["Mega|Ride"] = 236.48}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.91, ["Fly"] = 97.89, ["Ride"] = 21, ["Neon"] = 20.9, ["Neon|Ride"] = 52.49, ["Mega"] = 99.75, ["Mega|Ride"] = 141.89, ["Mega|Fly|Ride"] = 506.02}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 259.77, ["Fly|Ride"] = 556.04, ["Neon|Ride"] = 1968.75, ["Mega|Ride"] = 4164.46, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 23.37, ["Ride"] = 69.78, ["Fly|Ride"] = 222.85, ["Neon"] = 181.33, ["Neon|Fly|Ride"] = 355.36, ["Mega"] = 564.38, ["Mega|Ride"] = 883.17, ["Mega|Fly|Ride"] = 859.69}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 15.02, ["Fly"] = 315.68, ["Ride"] = 32.37, ["Fly|Ride"] = 90.57, ["Neon"] = 96.67, ["Neon|Ride"] = 124.67, ["Neon|Fly|Ride"] = 262.4, ["Mega"] = 432.16, ["Mega|Ride"] = 413.44, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 4.93, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 210, ["Mega"] = 76.1, ["Mega|Ride"] = 220.73, ["Mega|Fly|Ride"] = 245.44}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 44.58, ["Fly"] = 95.82, ["Ride"] = 90.46, ["Fly|Ride"] = 153.74, ["Neon"] = 262.5, ["Neon|Fly"] = 245.85, ["Neon|Ride"] = 236.91, ["Neon|Fly|Ride"] = 292.58, ["Mega|Fly|Ride"] = 1180.64}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.67, ["Fly|Ride"] = 35.36, ["Neon"] = 5, ["Neon|Ride"] = 56.23, ["Neon|Fly|Ride"] = 123.92, ["Mega"] = 58.9, ["Mega|Fly|Ride"] = 416.47}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 19.11, ["Fly"] = 126.52, ["Ride"] = 19.78, ["Fly|Ride"] = 85.15, ["Neon"] = 66.19, ["Neon|Ride"] = 125.15, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 393.75, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 416.47, ["Mega|Fly|Ride"] = 631.35}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 35.8, ["Fly"] = 65.63, ["Ride"] = 102.05, ["Fly|Ride"] = 151.1, ["Neon"] = 183.75, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 493.5, ["Mega|Ride"] = 1944.8, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 28.13, ["Ride"] = 12.51, ["Fly|Ride"] = 35.44, ["Neon"] = 2.1, ["Neon|Fly"] = 23.97, ["Neon|Ride"] = 16.67, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 18.47, ["Mega|Fly"] = 118.25, ["Mega|Ride"] = 31.49, ["Mega|Fly|Ride"] = 87.94}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 131.21, ["Neon"] = 16.98, ["Neon|Ride"] = 56.23, ["Neon|Fly|Ride"] = 291.38, ["Mega"] = 236.35, ["Mega|Ride"] = 276.67, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 17.71, ["Ride"] = 52.61, ["Fly|Ride"] = 85.32, ["Neon"] = 110.14, ["Neon|Ride"] = 555.97, ["Mega"] = 536.82, ["Mega|Ride"] = 459.37, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 21.63, ["Neon"] = 2.1, ["Neon|Ride"] = 28.86, ["Neon|Fly|Ride"] = 95.8, ["Mega"] = 15.54, ["Mega|Ride"] = 124.95, ["Mega|Fly|Ride"] = 174.92}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 10.56, ["Fly"] = 210, ["Ride"] = 59.07, ["Fly|Ride"] = 170.78, ["Neon"] = 60.29, ["Neon|Ride"] = 172.57, ["Neon|Fly|Ride"] = 443.63, ["Mega"] = 533.06, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 471.35, ["Mega|Fly|Ride"] = 713.06}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 6.57, ["Fly"] = 41.67, ["Ride"] = 26.48, ["Fly|Ride"] = 98.44, ["Neon"] = 408.98, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 129.94, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 2.1, ["Ride"] = 18.31, ["Neon"] = 39.29, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 74.34, ["Mega"] = 196.88, ["Mega|Ride"] = 244.12, ["Mega|Fly|Ride"] = 469.88}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 17.33, ["Fly"] = 2082.49, ["Ride"] = 84, ["Neon"] = 118.02, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 6305.06, ["Mega|Ride"] = 442.32, ["Mega|Fly|Ride"] = 989.07}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 25.01, ["Fly|Ride"] = 196.88, ["Neon"] = 6.56, ["Neon|Ride"] = 32.43, ["Mega"] = 74.82, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 156.19}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 55.53, ["Neon"] = 4.8, ["Mega"] = 28.23, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 256.45}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 19.22}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 36.54, ["Fly"] = 78.75, ["Ride"] = 70.88, ["Neon"] = 237.42, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 1665.79, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 110.37, ["Mega"] = 18.38, ["Mega|Ride"] = 119.7, ["Mega|Fly|Ride"] = 300.57}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 446.25, ["Fly"] = 498.75, ["Ride"] = 631.42, ["Fly|Ride"] = 788.68, ["Neon"] = 2777, ["Mega"] = 16657.8, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 3.94, ["Fly"] = 26.24, ["Ride"] = 39.38, ["Fly|Ride"] = 66.26, ["Neon"] = 32.84, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 89.51, ["Mega|Ride"] = 144.37, ["Mega|Fly|Ride"] = 555.97}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 21.75, ["Fly|Ride"] = 69.33, ["Neon"] = 31.25, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 124.95, ["Mega"] = 164.07, ["Mega|Ride"] = 256.13, ["Mega|Fly|Ride"] = 237.18}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 15.23, ["Fly"] = 69.78, ["Ride"] = 50, ["Fly|Ride"] = 68.17, ["Neon"] = 100.73, ["Neon|Ride"] = 169.72, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 819.37, ["Mega|Ride"] = 552.85, ["Mega|Fly|Ride"] = 733.69}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.14, ["Ride"] = 38.57, ["Fly|Ride"] = 721.88, ["Neon"] = 30.21, ["Neon|Ride"] = 118.13, ["Mega"] = 262.5}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 9.09, ["Fly"] = 139.54, ["Ride"] = 42, ["Fly|Ride"] = 173.24, ["Neon"] = 101.07, ["Neon|Ride"] = 236.25, ["Mega"] = 416.47, ["Mega|Ride"] = 499.74, ["Mega|Fly|Ride"] = 805.84}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 2.61, ["Ride"] = 52.99, ["Fly|Ride"] = 133.88, ["Neon"] = 31.91, ["Neon|Ride"] = 80.12, ["Neon|Fly|Ride"] = 207.19, ["Mega"] = 555.97, ["Mega|Fly"] = 555.97, ["Mega|Ride"] = 416.47, ["Mega|Fly|Ride"] = 384.79}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 47.31, ["Ride"] = 13.54, ["Fly|Ride"] = 69.78, ["Neon"] = 2.1, ["Neon|Fly"] = 59.36, ["Neon|Ride"] = 15.48, ["Neon|Fly|Ride"] = 139.53, ["Mega"] = 15.61, ["Mega|Ride"] = 24.94}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 4.75, ["Fly"] = 53.11, ["Ride"] = 32.71, ["Fly|Ride"] = 104.14, ["Neon"] = 39.18, ["Neon|Fly"] = 118.22, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 222.81, ["Mega"] = 196.85, ["Mega|Ride"] = 217.88}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 311.95, ["Ride"] = 301.76, ["Fly|Ride"] = 421.32, ["Neon"] = 1312.5, ["Neon|Ride"] = 1263.94, ["Neon|Fly|Ride"] = 1252.12, ["Mega|Ride"] = 9174.41, ["Mega|Fly|Ride"] = 5086.99}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 85.21, ["Ride"] = 139.54, ["Fly|Ride"] = 278.02, ["Neon"] = 556.04, ["Neon|Ride"] = 650.15, ["Neon|Fly|Ride"] = 541.4, ["Mega"] = 2221.75, ["Mega|Ride"] = 1837.5, ["Mega|Fly|Ride"] = 1665.91}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 15.32, ["Fly|Ride"] = 41.67, ["Neon"] = 8.39, ["Neon|Fly"] = 69.53, ["Neon|Ride"] = 31.94, ["Neon|Fly|Ride"] = 64.05, ["Mega|Fly"] = 207.19, ["Mega|Ride"] = 158.43, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 13.13, ["Fly|Ride"] = 34.17, ["Neon"] = 10.34, ["Neon|Fly"] = 41.66, ["Neon|Ride"] = 22.91, ["Neon|Fly|Ride"] = 55.13, ["Mega"] = 65.63, ["Mega|Fly"] = 277.99, ["Mega|Ride"] = 108.94, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 45.94, ["Mega"] = 270.71}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 243.89, ["Fly"] = 420, ["Ride"] = 253.32, ["Fly|Ride"] = 367.5, ["Neon|Ride"] = 1057.77, ["Neon|Fly|Ride"] = 1540.87, ["Mega|Ride"] = 8328.91, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Ride"] = 13.13, ["Fly|Ride"] = 35.22, ["Neon"] = 17.07, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 39.25, ["Neon|Fly|Ride"] = 139.53, ["Mega"] = 255.94, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 2.52, ["Ride"] = 94.56, ["Fly|Ride"] = 208.27, ["Neon"] = 69.78, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 277.99, ["Mega"] = 299.25, ["Mega|Ride"] = 307.15}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 28.13, ["Neon"] = 5.93, ["Neon|Ride"] = 155.81, ["Mega"] = 84.88, ["Mega|Ride"] = 207.38}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 10.38, ["Fly"] = 26.25, ["Ride"] = 19.56, ["Fly|Ride"] = 101.75, ["Neon"] = 118.13, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 192.72, ["Mega"] = 611.15, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 788.6}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 43.07, ["Fly"] = 111.43, ["Ride"] = 90.21, ["Fly|Ride"] = 382.15, ["Neon"] = 171.94, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 330.11, ["Mega"] = 402.94, ["Mega|Fly"] = 2186.35, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 528.94}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 23.06, ["Ride"] = 46.72, ["Fly|Ride"] = 112.46, ["Neon"] = 141.81, ["Neon|Ride"] = 416.47, ["Neon|Fly|Ride"] = 302.98, ["Mega|Ride"] = 945.83, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 20.84, ["Ride"] = 14.95, ["Fly|Ride"] = 42.33, ["Neon"] = 2.63, ["Neon|Fly"] = 23.83, ["Neon|Ride"] = 15.31, ["Neon|Fly|Ride"] = 47.16, ["Mega"] = 17.26, ["Mega|Fly"] = 416.47, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 196.88, ["Ride"] = 278.02, ["Fly|Ride"] = 379.1, ["Neon"] = 2103.68, ["Neon|Fly|Ride"] = 1244.15, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 9.61, ["Fly"] = 101.18, ["Ride"] = 49.41, ["Fly|Ride"] = 105, ["Neon"] = 78.75, ["Neon|Ride"] = 39.58, ["Neon|Fly|Ride"] = 328.12, ["Mega|Ride"] = 709.38, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 32.29, ["Ride"] = 17.68, ["Fly|Ride"] = 44.96, ["Neon"] = 7.66, ["Neon|Ride"] = 27.35, ["Neon|Fly|Ride"] = 110.37, ["Mega"] = 59.07, ["Mega|Fly"] = 277.99, ["Mega|Ride"] = 72.97, ["Mega|Fly|Ride"] = 211.78}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 31.25, ["Ride"] = 20.84, ["Fly|Ride"] = 43.28, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 116.05, ["Mega"] = 19.8, ["Mega|Fly"] = 139.53, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 186.38}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 28.74, ["Fly|Ride"] = 72.19, ["Neon"] = 12.95, ["Neon|Fly"] = 709.47, ["Neon|Ride"] = 70.95, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 103.68, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 6.2, ["Fly"] = 38.75, ["Ride"] = 23.63, ["Fly|Ride"] = 59.07, ["Neon"] = 47.15, ["Neon|Fly"] = 298.86, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 128.94, ["Mega"] = 355.69, ["Mega|Ride"] = 320.25, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 4.51, ["Ride"] = 55.13, ["Fly|Ride"] = 72.19, ["Neon"] = 38.19, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 275.63, ["Mega|Ride"] = 315.69, ["Mega|Fly|Ride"] = 419.58}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 43.32, ["Neon"] = 3.93, ["Neon|Ride"] = 31.25, ["Mega"] = 32.69, ["Mega|Ride"] = 72.08, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 9.18, ["Ride"] = 27.09, ["Fly|Ride"] = 131.25, ["Neon"] = 24.76, ["Neon|Fly"] = 137.46, ["Neon|Ride"] = 44.99, ["Neon|Fly|Ride"] = 258.57, ["Mega"] = 234.73, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 347.74}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 78.89, ["Neon"] = 3.28, ["Neon|Ride"] = 45.77, ["Neon|Fly|Ride"] = 102.3, ["Mega"] = 41.66, ["Mega|Ride"] = 102.04, ["Mega|Fly|Ride"] = 129.11}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 42.74, ["Ride"] = 17.06, ["Fly|Ride"] = 39.38, ["Neon"] = 5.04, ["Neon|Ride"] = 20.88, ["Neon|Fly|Ride"] = 126.52, ["Mega"] = 58.75, ["Mega|Fly"] = 139.53, ["Mega|Ride"] = 87.67, ["Mega|Fly|Ride"] = 277.99}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 767.7, ["Ride"] = 651.49, ["Fly|Ride"] = 902.77, ["Neon|Fly|Ride"] = 3539.8, ["Mega|Fly|Ride"] = 12571.04}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 19.22, ["Ride"] = 13.37, ["Fly|Ride"] = 31.25, ["Neon"] = 18.25, ["Neon|Fly"] = 140.88, ["Neon|Ride"] = 28.12, ["Neon|Fly|Ride"] = 65.63, ["Mega|Fly|Ride"] = 358.15}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 47.25, ["Neon"] = 8.9, ["Neon|Fly"] = 728.88, ["Neon|Ride"] = 88.45, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 54.49, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 416.47}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 6.57, ["Fly"] = 47.31, ["Ride"] = 17.73, ["Fly|Ride"] = 53.78, ["Neon"] = 50.6, ["Neon|Fly"] = 189.15, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 97.11, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 328.12}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 14.34, ["Fly|Ride"] = 32.04, ["Neon"] = 7.53, ["Neon|Fly"] = 145.78, ["Neon|Ride"] = 26.14, ["Neon|Fly|Ride"] = 69.24, ["Mega"] = 65.29, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 177.35}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 37.97, ["Ride"] = 84.17, ["Fly|Ride"] = 278.02, ["Neon"] = 220.5, ["Neon|Ride"] = 267.17, ["Mega"] = 972.41, ["Mega|Fly|Ride"] = 1180.64}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 25.01, ["Fly|Ride"] = 64.46, ["Neon"] = 5.23, ["Neon|Fly"] = 141.75, ["Neon|Ride"] = 30.64, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 47.57, ["Mega|Ride"] = 119.59, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 124.97, ["Ride"] = 20.27, ["Fly|Ride"] = 60.41, ["Neon"] = 10.47, ["Neon|Ride"] = 41.91, ["Neon|Fly|Ride"] = 111.41, ["Mega"] = 114.19, ["Mega|Ride"] = 198.6, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Neon"] = 26.25, ["Mega"] = 93.41, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 376.69}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 15.64, ["Fly|Ride"] = 49.88, ["Neon"] = 3.61, ["Neon|Fly"] = 100.68, ["Neon|Ride"] = 24.36, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 45.93, ["Mega|Fly"] = 291.53, ["Mega|Ride"] = 62.91}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 13.72, ["Fly"] = 19.69, ["Ride"] = 19.22, ["Fly|Ride"] = 34.11, ["Neon"] = 315.72, ["Neon|Ride"] = 80.85, ["Neon|Fly|Ride"] = 98.43, ["Mega|Ride"] = 416.47}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 703.5, ["Ride"] = 853.13, ["Fly|Ride"] = 926.52, ["Neon"] = 1837.5, ["Neon|Ride"] = 1967.44, ["Neon|Fly|Ride"] = 2163, ["Mega"] = 8328.91, ["Mega|Fly|Ride"] = 7565.35}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 15.56, ["Ride"] = 15.2, ["Fly|Ride"] = 37.97, ["Neon"] = 3.34, ["Neon|Ride"] = 17.06, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 39.89, ["Mega|Ride"] = 57.66, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 6.9, ["Ride"] = 36.74, ["Neon"] = 43.3, ["Neon|Fly"] = 70.96, ["Neon|Ride"] = 112.51, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 390.43, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 530.98}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 55.13, ["Ride"] = 59.03, ["Fly|Ride"] = 113.28, ["Neon|Ride"] = 472.84, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 3193.1, ["Mega|Fly|Ride"] = 2769.38}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 28.28, ["Ride"] = 44.63, ["Fly|Ride"] = 104.89, ["Neon|Ride"] = 218.66, ["Neon|Fly|Ride"] = 694.44, ["Mega"] = 1944.8, ["Mega|Ride"] = 896.44, ["Mega|Fly|Ride"] = 1009.89}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 11.22, ["Ride"] = 26.23, ["Fly|Ride"] = 139.54, ["Neon"] = 62.49, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 115.58, ["Mega"] = 288.75, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 26.03, ["Ride"] = 56.55, ["Neon"] = 278.02, ["Neon|Ride"] = 362.92, ["Mega"] = 459.38, ["Mega|Fly"] = 513.13, ["Mega|Ride"] = 348.78, ["Mega|Fly|Ride"] = 761.25}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 23.63, ["Fly"] = 126.89, ["Neon"] = 420, ["Neon|Ride"] = 323, ["Neon|Fly|Ride"] = 525, ["Mega"] = 924, ["Mega|Fly|Ride"] = 680.91}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 16.29}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 4.55, ["Ride"] = 18.42, ["Fly|Ride"] = 85.32, ["Neon"] = 31.5, ["Neon|Ride"] = 93.71, ["Neon|Fly|Ride"] = 181.17, ["Mega"] = 139.53, ["Mega|Fly"] = 470.59, ["Mega|Ride"] = 166.6, ["Mega|Fly|Ride"] = 290.95}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.41, ["Ride"] = 46.85, ["Neon"] = 11.81, ["Mega"] = 139.53, ["Mega|Fly|Ride"] = 405.57}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 39.38, ["Fly"] = 416.51, ["Ride"] = 37.68, ["Fly|Ride"] = 101.67, ["Neon"] = 262.5, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 945.83, ["Mega|Ride"] = 1582.51, ["Mega|Fly|Ride"] = 788.82}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.05, ["Fly"] = 17.56, ["Ride"] = 15.25, ["Fly|Ride"] = 38.25, ["Neon"] = 25.33, ["Neon|Fly"] = 94.77, ["Neon|Ride"] = 31.36, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 262.5, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 418.68}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 2.5, ["Fly"] = 147.87, ["Ride"] = 21.61, ["Fly|Ride"] = 55.7, ["Neon"] = 14.34, ["Neon|Ride"] = 41.06, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 135.83, ["Mega|Ride"] = 169.25, ["Mega|Fly|Ride"] = 262.47}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 7.77, ["Mega"] = 48.56, ["Mega|Ride"] = 196.38}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 24.66, ["Fly"] = 77.17, ["Ride"] = 52.5, ["Fly|Ride"] = 89.25, ["Neon"] = 945, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 301.93, ["Mega|Ride"] = 13882.19, ["Mega|Fly|Ride"] = 814.99}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 39.37, ["Fly|Ride"] = 65.63, ["Neon"] = 6.29, ["Neon|Ride"] = 32.28, ["Mega"] = 74.81, ["Mega|Ride"] = 118.12}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 7.88, ["Ride"] = 79.24, ["Fly|Ride"] = 276.98, ["Neon"] = 74.99, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 374.07, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 622.59}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 14.58, ["Fly|Ride"] = 40.64, ["Neon"] = 18.66, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 75.87, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 315.69}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 19.2, ["Fly|Ride"] = 75.12, ["Neon"] = 31.4, ["Neon|Ride"] = 65.63, ["Mega|Ride"] = 416.47, ["Mega|Fly|Ride"] = 446.92}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.67, ["Ride"] = 33.33, ["Neon"] = 39.35, ["Neon|Ride"] = 227.07, ["Mega"] = 413.86, ["Mega|Ride"] = 945.83}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 39.37, ["Ride"] = 123.27, ["Neon"] = 216.57, ["Neon|Fly|Ride"] = 416.47, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 15.81, ["Ride"] = 278.02, ["Neon"] = 107.63, ["Neon|Ride"] = 262.5, ["Mega"] = 452.92, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 12.51, ["Ride"] = 144.38, ["Neon"] = 171.63, ["Neon|Fly"] = 208.27, ["Neon|Ride"] = 416.47, ["Mega|Ride"] = 831.87}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 19.19, ["Ride"] = 232.32, ["Fly|Ride"] = 367.46, ["Neon"] = 103.36, ["Neon|Ride"] = 728.8, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 616.88, ["Mega|Fly"] = 2082.24, ["Mega|Fly|Ride"] = 1104.26}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.93, ["Neon"] = 20.84, ["Mega"] = 170.63, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 315.69}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 128.63, ["Ride"] = 17.74, ["Fly|Ride"] = 40.61, ["Neon"] = 3.72, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 41.66, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 52.5, ["Mega|Ride"] = 80.15, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 6.26, ["Ride"] = 43.75, ["Fly|Ride"] = 65.63, ["Neon"] = 26.25, ["Neon|Ride"] = 41.66, ["Neon|Fly|Ride"] = 163.96, ["Mega"] = 105, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 260.3}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 15.46, ["Fly|Ride"] = 56.15, ["Neon"] = 5.25, ["Neon|Ride"] = 22.46, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 42, ["Mega|Fly"] = 166.6, ["Mega|Ride"] = 76.56, ["Mega|Fly|Ride"] = 222.29}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 18.38, ["Fly|Ride"] = 118.13, ["Neon"] = 15.64, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 258.21, ["Mega"] = 328.02, ["Mega|Ride"] = 333.17, ["Mega|Fly|Ride"] = 472.92}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 19.69, ["Fly"] = 65.63, ["Ride"] = 19.69, ["Neon"] = 25.62, ["Neon|Fly"] = 315, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 416.47}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 2.24, ["Fly"] = 131.25, ["Ride"] = 25.01, ["Fly|Ride"] = 77.07, ["Neon"] = 16.75, ["Neon|Fly"] = 111.41, ["Neon|Ride"] = 32.79, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 351.91, ["Mega|Fly|Ride"] = 396.38}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 3.94, ["Fly"] = 33.72, ["Ride"] = 19.38, ["Fly|Ride"] = 51.78, ["Neon"] = 36.75, ["Neon|Ride"] = 69.77, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 208.24, ["Mega|Fly|Ride"] = 254.15}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 2.1, ["Fly"] = 57.66, ["Ride"] = 43.29, ["Fly|Ride"] = 87.94, ["Neon"] = 15.64, ["Neon|Fly"] = 436.96, ["Neon|Ride"] = 61.45, ["Neon|Fly|Ride"] = 142.21, ["Mega"] = 118.02, ["Mega|Fly"] = 176.5, ["Mega|Ride"] = 132.45, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 18.66, ["Ride"] = 99.53, ["Fly|Ride"] = 262.5, ["Neon"] = 110.44, ["Neon|Ride"] = 236.35, ["Neon|Fly|Ride"] = 526.13, ["Mega"] = 519.75, ["Mega|Ride"] = 918.28, ["Mega|Fly|Ride"] = 722.54}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 51.07, ["Fly"] = 164.07, ["Ride"] = 90.47, ["Fly|Ride"] = 487.16, ["Neon"] = 221.8, ["Neon|Ride"] = 315.62, ["Neon|Fly|Ride"] = 487.11, ["Mega"] = 1526.28, ["Mega|Ride"] = 1116.94, ["Mega|Fly|Ride"] = 1210.13}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 50.97, ["Ride"] = 22.93, ["Fly|Ride"] = 65.63, ["Neon"] = 2.62, ["Neon|Ride"] = 32.82, ["Mega"] = 26.97, ["Mega|Ride"] = 79.22, ["Mega|Fly|Ride"] = 144.01}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 65.39, ["Neon"] = 158.46, ["Mega|Fly|Ride"] = 1021.35}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 54.55, ["Fly"] = 105, ["Ride"] = 78.75, ["Neon"] = 354.27, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 831.87, ["Mega"] = 1706.4, ["Mega|Fly|Ride"] = 1874.01}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 3.61, ["Fly"] = 190.32, ["Ride"] = 28.63, ["Fly|Ride"] = 133.88, ["Neon"] = 40.69, ["Neon|Ride"] = 83.3, ["Neon|Fly|Ride"] = 210, ["Mega"] = 157.5, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 312.38}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 3.13, ["Ride"] = 65.37, ["Fly|Ride"] = 141.75, ["Neon"] = 13.12, ["Neon|Ride"] = 59.07, ["Mega"] = 83.95, ["Mega|Fly"] = 361.8, ["Mega|Ride"] = 137.81, ["Mega|Fly|Ride"] = 348.76}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 29.86, ["Ride"] = 18.76, ["Fly|Ride"] = 39.38, ["Neon"] = 8.92, ["Neon|Ride"] = 41.66, ["Neon|Fly|Ride"] = 70.88, ["Mega|Ride"] = 207.19, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.75, ["Ride"] = 15.75, ["Fly|Ride"] = 41.67, ["Neon"] = 2.51, ["Neon|Fly"] = 17.77, ["Neon|Ride"] = 27.55, ["Neon|Fly|Ride"] = 56.76, ["Mega"] = 27.2, ["Mega|Ride"] = 69.56, ["Mega|Fly|Ride"] = 116.95}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 15.64, ["Fly|Ride"] = 89.93, ["Neon"] = 3.73, ["Neon|Ride"] = 27.08, ["Neon|Fly|Ride"] = 104.13, ["Mega"] = 75.69, ["Mega|Ride"] = 139.53, ["Mega|Fly|Ride"] = 177.11}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.49, ["Fly|Ride"] = 118.26, ["Neon"] = 2.49, ["Neon|Ride"] = 145.08, ["Mega"] = 25.65, ["Mega|Fly|Ride"] = 326.93}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 3.08, ["Ride"] = 157.5, ["Neon"] = 47.31, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 624.68, ["Mega"] = 315.69, ["Mega|Fly|Ride"] = 315.69}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 5.7, ["Ride"] = 34.13, ["Fly|Ride"] = 97.89, ["Neon"] = 52.85, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 183.25, ["Mega|Ride"] = 331.05, ["Mega|Fly|Ride"] = 971.25}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 4.97, ["Fly"] = 40.21, ["Ride"] = 18.38, ["Fly|Ride"] = 38.91, ["Neon"] = 37.97, ["Neon|Fly"] = 69.77, ["Neon|Ride"] = 38.17, ["Neon|Fly|Ride"] = 101.68, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 50.71, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 445.61, ["Mega"] = 2364.55, ["Mega|Fly|Ride"] = 1560.57}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 25.19, ["Fly"] = 82.67, ["Ride"] = 31.4, ["Neon"] = 249.92, ["Neon|Fly|Ride"] = 630, ["Mega"] = 631.35}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 31.25, ["Ride"] = 15.75, ["Fly|Ride"] = 35.44, ["Neon"] = 2.63, ["Neon|Fly"] = 41.66, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 69.77, ["Mega|Ride"] = 94.01, ["Mega|Fly|Ride"] = 188.98}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 12.71, ["Fly|Ride"] = 27.57, ["Neon"] = 3.52, ["Neon|Fly"] = 27.08, ["Neon|Ride"] = 14.86, ["Neon|Fly|Ride"] = 42.24, ["Mega"] = 42.92, ["Mega|Fly"] = 90.6, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 451.5, ["Fly"] = 552.12, ["Ride"] = 534.19, ["Fly|Ride"] = 557.82, ["Neon|Fly|Ride"] = 1903.12}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 7.3, ["Ride"] = 56.35, ["Neon"] = 44.35, ["Mega"] = 364.88, ["Mega|Ride"] = 680.91, ["Mega|Fly|Ride"] = 277630.05}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 14.78, ["Ride"] = 15.75, ["Fly|Ride"] = 27.82, ["Neon"] = 3.94, ["Neon|Fly"] = 23.66, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 38.31, ["Mega"] = 139.53, ["Mega|Ride"] = 74.01, ["Mega|Fly|Ride"] = 105.45}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 49.79, ["Ride"] = 139.54, ["Fly|Ride"] = 520.64, ["Neon"] = 239.69, ["Neon|Ride"] = 268.34, ["Neon|Fly|Ride"] = 459.15, ["Mega"] = 737.63, ["Mega|Ride"] = 710.72, ["Mega|Fly|Ride"] = 878.36}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 13.08, ["Ride"] = 12.6, ["Fly|Ride"] = 35.44, ["Neon"] = 12.77, ["Neon|Fly"] = 61.45, ["Neon|Ride"] = 19.59, ["Neon|Fly|Ride"] = 70.86, ["Mega"] = 110.15, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 206.07}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 69.57, ["Ride"] = 56.24, ["Neon"] = 3.14, ["Neon|Ride"] = 35.42, ["Neon|Fly|Ride"] = 74.82, ["Mega"] = 20.52, ["Mega|Ride"] = 55.56, ["Mega|Fly|Ride"] = 190.88}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 38.07, ["Fly"] = 117.27, ["Ride"] = 64.97, ["Fly|Ride"] = 194.73, ["Neon"] = 184.85, ["Neon|Ride"] = 202.13, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 830.82, ["Mega|Ride"] = 832.91, ["Mega|Fly|Ride"] = 1104.26}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 15.64, ["Ride"] = 22.93, ["Neon"] = 2.88, ["Neon|Ride"] = 39.99, ["Mega"] = 36.75, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 34.13, ["Ride"] = 69.45, ["Fly|Ride"] = 139.54, ["Neon"] = 416.51, ["Neon|Ride"] = 473.72, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 1644.98, ["Mega|Ride"] = 1665.79, ["Mega|Fly|Ride"] = 1499.22}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 2.1, ["Ride"] = 183.74, ["Neon"] = 19.68, ["Neon|Ride"] = 47.3, ["Neon|Fly|Ride"] = 486.21, ["Mega"] = 156.19, ["Mega|Ride"] = 603.74}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 3.83, ["Ride"] = 70.58, ["Fly|Ride"] = 69.78, ["Neon"] = 7.29, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 117.6, ["Mega|Ride"] = 1104.26, ["Mega|Fly|Ride"] = 555.97}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 43.02, ["Ride"] = 104.99, ["Fly|Ride"] = 520.64, ["Mega|Ride"] = 2598.75, ["Mega|Fly|Ride"] = 1660.59}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 308.47, ["Ride"] = 20.94, ["Fly|Ride"] = 60.15, ["Neon"] = 4.35, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 45.98, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 89.54, ["Mega|Fly|Ride"] = 181.92}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 14.91, ["Fly|Ride"] = 101.82, ["Neon"] = 10.89, ["Neon|Fly"] = 47.77, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 277.99}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 9.11, ["Fly"] = 58.5, ["Ride"] = 23.78, ["Fly|Ride"] = 75.78, ["Neon"] = 81.78, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 437.28, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 6.35, ["Ride"] = 20.86, ["Fly|Ride"] = 71.3, ["Neon"] = 72.17, ["Neon|Ride"] = 97.93, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 911.01, ["Mega|Ride"] = 400.98, ["Mega|Fly|Ride"] = 483.77}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 23.55, ["Fly"] = 51.19, ["Ride"] = 26.25, ["Fly|Ride"] = 63.87, ["Neon"] = 72.19, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 139.53, ["Mega"] = 555.97, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 702.28}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 57.66, ["Ride"] = 116.94, ["Fly|Ride"] = 249.38, ["Neon"] = 359.63, ["Neon|Ride"] = 486.21, ["Neon|Fly|Ride"] = 733.02, ["Mega|Ride"] = 1249.35, ["Mega|Fly|Ride"] = 1310.4}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.94, ["Ride"] = 56.05, ["Neon"] = 26.25, ["Neon|Ride"] = 416.47, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 223.13, ["Mega|Fly|Ride"] = 387.31}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.69, ["Ride"] = 26.24, ["Fly|Ride"] = 78.74, ["Neon"] = 25.17, ["Neon|Ride"] = 59.12, ["Neon|Fly|Ride"] = 124.95, ["Mega"] = 262.5, ["Mega|Ride"] = 268.62}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 7.03, ["Ride"] = 24.03, ["Fly|Ride"] = 109.83, ["Neon"] = 47.09, ["Neon|Ride"] = 208.24, ["Neon|Fly|Ride"] = 236.52, ["Mega"] = 459.15, ["Mega|Ride"] = 639.19}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.33, ["Ride"] = 12.51, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 13.98, ["Neon|Fly|Ride"] = 39.25, ["Mega"] = 15.36, ["Mega|Ride"] = 28.08, ["Mega|Fly|Ride"] = 93.82}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 41.91, ["Fly"] = 220.76, ["Ride"] = 85.32, ["Neon"] = 415.04, ["Neon|Fly"] = 2360.22, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 467.01, ["Mega"] = 1110.88, ["Mega|Ride"] = 945, ["Mega|Fly|Ride"] = 829.16}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 20.84, ["Fly|Ride"] = 35.41, ["Neon"] = 3.18, ["Neon|Ride"] = 27.44, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 139.53, ["Mega|Ride"] = 139.53, ["Mega|Fly|Ride"] = 301.87}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.13, ["Ride"] = 15.75, ["Fly|Ride"] = 58.47, ["Neon"] = 23.46, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 120.25, ["Mega"] = 257.25, ["Mega|Ride"] = 118.25, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 65.63, ["Fly"] = 157.5, ["Ride"] = 118.13, ["Fly|Ride"] = 258.56, ["Neon"] = 360.94, ["Neon|Ride"] = 681.95, ["Mega"] = 1748.25, ["Mega|Ride"] = 1758.75, ["Mega|Fly|Ride"] = 1340.71}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 19.8, ["Neon"] = 5.23, ["Neon|Ride"] = 52.4, ["Mega"] = 64.31, ["Mega|Ride"] = 108.04, ["Mega|Fly|Ride"] = 234.94}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 12.91}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 32.03, ["Fly|Ride"] = 295.73, ["Neon"] = 3.94, ["Neon|Ride"] = 50.28, ["Neon|Fly|Ride"] = 154.1, ["Mega"] = 42.95, ["Mega|Ride"] = 113.77, ["Mega|Fly|Ride"] = 217.88}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 113.17, ["Ride"] = 144.01, ["Fly|Ride"] = 283.8, ["Neon"] = 836.07, ["Neon|Ride"] = 693.89, ["Neon|Fly|Ride"] = 917.44, ["Mega"] = 3331.57, ["Mega|Fly|Ride"] = 2835}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2.6, ["Ride"] = 41.67, ["Fly|Ride"] = 55.13, ["Neon"] = 19.58, ["Neon|Fly"] = 139.54, ["Neon|Ride"] = 65.63, ["Mega"] = 209.9, ["Mega|Fly|Ride"] = 631.76}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 41.67, ["Neon"] = 3.72, ["Neon|Ride"] = 26.25, ["Mega"] = 32.81, ["Mega|Fly|Ride"] = 139.53}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 8.34, ["Ride"] = 19.52, ["Neon"] = 65.62, ["Neon|Ride"] = 63.86, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 486.21, ["Mega|Ride"] = 416.47, ["Mega|Fly|Ride"] = 670.37}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 8.44, ["Fly"] = 53.93, ["Ride"] = 21, ["Fly|Ride"] = 55.59, ["Neon"] = 99, ["Neon|Ride"] = 131.25, ["Mega"] = 603.75, ["Mega|Ride"] = 555.19, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 17.97, ["Ride"] = 68.09, ["Fly|Ride"] = 111.43, ["Neon"] = 131.24, ["Neon|Ride"] = 216.57, ["Neon|Fly|Ride"] = 1575, ["Mega"] = 631.35, ["Mega|Ride"] = 641.33, ["Mega|Fly|Ride"] = 895.37}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 127.32, ["Fly"] = 278.02, ["Ride"] = 171.32, ["Fly|Ride"] = 210, ["Neon"] = 593.14, ["Neon|Ride"] = 590.3, ["Neon|Fly|Ride"] = 643.13, ["Mega|Fly|Ride"] = 2360.22}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 139.55, ["Ride"] = 278.02, ["Fly|Ride"] = 196.75, ["Neon"] = 471.14, ["Neon|Ride"] = 832.91, ["Neon|Fly|Ride"] = 555.97}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 131.23, ["Ride"] = 19.59, ["Fly|Ride"] = 131.24, ["Neon"] = 15.75, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 139.13, ["Mega|Ride"] = 126.52, ["Mega|Fly|Ride"] = 299.25}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 2.1, ["Fly"] = 98.44, ["Ride"] = 34.96, ["Neon"] = 172.87, ["Neon|Ride"] = 80.07, ["Neon|Fly|Ride"] = 156.19, ["Mega"] = 379.31, ["Mega|Ride"] = 495.58, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 45.94, ["Fly"] = 141.88, ["Ride"] = 76.56, ["Fly|Ride"] = 222.85, ["Neon"] = 219.19, ["Neon|Ride"] = 277.99, ["Neon|Fly|Ride"] = 327.96, ["Mega"] = 1014.05, ["Mega|Ride"] = 1208.82, ["Mega|Fly|Ride"] = 1002.04}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 11.82, ["Ride"] = 83.15, ["Neon"] = 105, ["Neon|Ride"] = 555.97, ["Neon|Fly|Ride"] = 459.15, ["Mega"] = 683.71, ["Mega|Ride"] = 615.32}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.39, ["Ride"] = 472.5, ["Neon|Ride"] = 3152.6}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 25.35, ["Fly"] = 56.24, ["Ride"] = 32.8, ["Fly|Ride"] = 75.55, ["Neon"] = 416.51, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 461.23, ["Mega"] = 1034.25, ["Mega|Ride"] = 993.12, ["Mega|Fly|Ride"] = 1104.26}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 1.68, ["Fly"] = 39.2, ["Ride"] = 12.51, ["Fly|Ride"] = 120.8, ["Neon"] = 3.69, ["Neon|Ride"] = 15.59, ["Neon|Fly|Ride"] = 40.66, ["Mega"] = 19.25, ["Mega|Fly"] = 110.37, ["Mega|Ride"] = 39.42, ["Mega|Fly|Ride"] = 103.69}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Neon"] = 8.3, ["Neon|Ride"] = 66.87, ["Neon|Fly|Ride"] = 262.38, ["Mega"] = 145.77, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 416.47}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 2.1, ["Ride"] = 35.41, ["Fly|Ride"] = 60.52, ["Neon"] = 19.78, ["Neon|Ride"] = 139.53, ["Neon|Fly|Ride"] = 972.41, ["Mega"] = 108.74, ["Mega|Fly"] = 498.61, ["Mega|Ride"] = 277.99, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 406.77, ["Ride"] = 439.69, ["Fly|Ride"] = 525, ["Neon"] = 1561.88, ["Neon|Ride"] = 9187.5, ["Neon|Fly|Ride"] = 1665.79, ["Mega|Fly|Ride"] = 5034.75}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 3.05, ["Fly"] = 69.78, ["Ride"] = 16.31, ["Fly|Ride"] = 42, ["Neon"] = 31.94, ["Neon|Ride"] = 139.53, ["Neon|Fly|Ride"] = 104.13, ["Mega"] = 160.13, ["Mega|Ride"] = 277.99, ["Mega|Fly|Ride"] = 624.68}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 5.24, ["Fly"] = 22.31, ["Ride"] = 17.2, ["Fly|Ride"] = 28.88, ["Neon"] = 43.25, ["Neon|Fly"] = 156.45, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 694.44, ["Mega|Fly|Ride"] = 208.24}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 6.28, ["Fly"] = 44.79, ["Ride"] = 22.53, ["Fly|Ride"] = 78.75, ["Neon"] = 16.96, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 56.75, ["Neon|Fly|Ride"] = 107.33, ["Mega"] = 158.43, ["Mega|Ride"] = 270.71, ["Mega|Fly|Ride"] = 307.15}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 39.38, ["Fly"] = 46.12, ["Ride"] = 41.89, ["Fly|Ride"] = 65.63, ["Neon"] = 140.44, ["Neon|Ride"] = 174.66, ["Neon|Fly|Ride"] = 311.3, ["Mega"] = 1312.5, ["Mega|Ride"] = 832.91, ["Mega|Fly|Ride"] = 683.82}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 28.13, ["Fly|Ride"] = 50.3, ["Neon"] = 11.7, ["Neon|Ride"] = 108.29, ["Neon|Fly|Ride"] = 210, ["Mega"] = 163.74, ["Mega|Ride"] = 457.8}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 7.3, ["Fly"] = 787.5, ["Ride"] = 24.94, ["Neon"] = 185.73, ["Neon|Ride"] = 210, ["Mega"] = 728.8, ["Mega|Ride"] = 749.61, ["Mega|Fly|Ride"] = 846.57}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Neon"] = 6.07, ["Neon|Ride"] = 35.11, ["Mega"] = 52.41, ["Mega|Ride"] = 118.71, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 4.87, ["Neon"] = 85.32}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 6.47, ["Ride"] = 77.07, ["Neon"] = 78.8, ["Neon|Ride"] = 472.84, ["Neon|Fly|Ride"] = 416.47, ["Mega"] = 832.91, ["Mega|Ride"] = 580.52, ["Mega|Fly|Ride"] = 509.25}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 6.97, ["Fly"] = 27.63, ["Ride"] = 23.92, ["Fly|Ride"] = 45.94, ["Neon"] = 52.5, ["Neon|Fly"] = 68.73, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 585.12, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 344.9}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 336.84, ["Ride"] = 388.5, ["Fly|Ride"] = 482.99, ["Neon"] = 1659, ["Neon|Ride"] = 1326.14, ["Neon|Fly|Ride"] = 1470, ["Mega|Fly|Ride"] = 6941.1}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.65, ["Fly|Ride"] = 26.25, ["Neon"] = 28.13, ["Neon|Fly"] = 79.24, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 208.24, ["Mega|Ride"] = 196.77}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 6.86, ["Ride"] = 44.1, ["Fly|Ride"] = 94.61, ["Neon"] = 43.84, ["Neon|Ride"] = 156.19, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 382.29, ["Mega|Fly"] = 694.44, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 26.25, ["Ride"] = 86.63, ["Fly|Ride"] = 315, ["Neon"] = 112.81, ["Neon|Ride"] = 135.19, ["Neon|Fly|Ride"] = 410.2, ["Mega"] = 356.29, ["Mega|Ride"] = 4164.46, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 139.54, ["Ride"] = 210.02, ["Neon"] = 1389.03, ["Neon|Ride"] = 1457.57, ["Neon|Fly|Ride"] = 1249.35, ["Mega"] = 2249.09, ["Mega|Ride"] = 5551.88, ["Mega|Fly|Ride"] = 2290.45}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 11.46, ["Ride"] = 118.72, ["Fly|Ride"] = 127.74, ["Neon"] = 51.97, ["Neon|Ride"] = 90.8, ["Neon|Fly|Ride"] = 367.49, ["Mega"] = 208.24, ["Mega|Ride"] = 254.59, ["Mega|Fly|Ride"] = 364.41}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 19.59, ["Fly|Ride"] = 52.5, ["Neon"] = 12.48, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 65.61, ["Mega|Ride"] = 139.53, ["Mega|Fly|Ride"] = 236.48}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 5.17, ["Ride"] = 33.68, ["Neon"] = 23, ["Neon|Ride"] = 94.25, ["Neon|Fly|Ride"] = 174.57, ["Mega"] = 210, ["Mega|Ride"] = 181.17, ["Mega|Fly|Ride"] = 306.99}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 49.76, ["Fly"] = 183.75, ["Ride"] = 94.69, ["Fly|Ride"] = 198.81, ["Neon"] = 150.93, ["Neon|Ride"] = 157.37, ["Neon|Fly|Ride"] = 354.38, ["Mega"] = 590.63, ["Mega|Ride"] = 678.82, ["Mega|Fly|Ride"] = 542.07}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 10.4, ["Neon|Ride"] = 252.98, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 66.65, ["Mega|Ride"] = 166, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 19.04, ["Neon"] = 118.13, ["Neon|Ride"] = 401.03, ["Mega"] = 520.57}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 958.13, ["Fly"] = 2082.49, ["Ride"] = 1036.88, ["Fly|Ride"] = 1086.75, ["Neon"] = 3313.25, ["Neon|Ride"] = 3581.44, ["Neon|Fly|Ride"] = 3221.36, ["Mega|Fly|Ride"] = 11105.56}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 12.38, ["Fly"] = 78.28, ["Ride"] = 56.15, ["Fly|Ride"] = 194.25, ["Neon"] = 85.32, ["Neon|Fly"] = 693.48, ["Neon|Ride"] = 208.24, ["Mega"] = 471.45, ["Mega|Fly|Ride"] = 782.93}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.34, ["Ride"] = 16.47, ["Fly|Ride"] = 45.84, ["Neon"] = 10.68, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 92.02, ["Mega"] = 84, ["Mega|Ride"] = 139.53, ["Mega|Fly|Ride"] = 258.21}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 5.25, ["Ride"] = 131.25, ["Fly|Ride"] = 139.54, ["Neon"] = 141.75, ["Mega"] = 787.5, ["Mega|Ride"] = 421.94, ["Mega|Fly|Ride"] = 924}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 35.06, ["Fly|Ride"] = 181.19, ["Neon"] = 2.1, ["Neon|Ride"] = 20.84, ["Neon|Fly|Ride"] = 91.66, ["Mega"] = 15.54, ["Mega|Fly"] = 124.95, ["Mega|Ride"] = 42, ["Mega|Fly|Ride"] = 152}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 56.14, ["Ride"] = 98.51, ["Fly|Ride"] = 309.81, ["Neon"] = 260.74, ["Neon|Ride"] = 307.15, ["Neon|Fly|Ride"] = 402.93, ["Mega"] = 918.75, ["Mega|Ride"] = 924, ["Mega|Fly|Ride"] = 1062.87}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 10.22, ["Ride"] = 63, ["Fly|Ride"] = 157.83, ["Neon"] = 69.55, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 261.3, ["Mega"] = 694.44, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 553.89}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 27.09, ["Neon"] = 12.51, ["Neon|Ride"] = 65.62, ["Mega"] = 156.19, ["Mega|Ride"] = 157.49}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 18.1, ["Fly"] = 52.5, ["Ride"] = 41.08, ["Fly|Ride"] = 161.34, ["Neon"] = 139.54, ["Neon|Ride"] = 87.93, ["Neon|Fly|Ride"] = 139.53, ["Mega"] = 1039.49, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 5.04, ["Ride"] = 30.22, ["Fly|Ride"] = 68.25, ["Neon"] = 50.8, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 315, ["Mega"] = 555.96, ["Mega|Ride"] = 520.57, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 30.18, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 902.67, ["Mega"] = 2082.24, ["Mega|Ride"] = 2364.55, ["Mega|Fly|Ride"] = 1660.59}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 3.94, ["Neon"] = 20.53, ["Neon|Ride"] = 102.04, ["Neon|Fly|Ride"] = 631.35, ["Mega"] = 101.66, ["Mega|Ride"] = 394.9, ["Mega|Fly|Ride"] = 226.31}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 3.52, ["Ride"] = 20.9, ["Fly|Ride"] = 91.65, ["Neon"] = 141.9, ["Neon|Ride"] = 139.53, ["Neon|Fly|Ride"] = 137.45, ["Mega"] = 301.67, ["Mega|Ride"] = 416.47, ["Mega|Fly|Ride"] = 631.35}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 137.82, ["Fly"] = 393.75, ["Ride"] = 139.54, ["Fly|Ride"] = 207.9, ["Neon"] = 577.6, ["Neon|Ride"] = 694.44, ["Neon|Fly|Ride"] = 643.13, ["Mega|Ride"] = 2315.45, ["Mega|Fly|Ride"] = 1945.13}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 24.61, ["Ride"] = 19.8, ["Fly|Ride"] = 39.38, ["Neon"] = 12.18, ["Neon|Fly"] = 57.53, ["Neon|Ride"] = 23.25, ["Neon|Fly|Ride"] = 70.67, ["Mega|Ride"] = 236.48, ["Mega|Fly|Ride"] = 307.4}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 6.14, ["Fly"] = 193.47, ["Ride"] = 37.67, ["Fly|Ride"] = 92.86, ["Neon"] = 97.13, ["Neon|Fly"] = 315.72, ["Neon|Ride"] = 82.84, ["Neon|Fly|Ride"] = 245.73, ["Mega"] = 459.15, ["Mega|Ride"] = 461.23, ["Mega|Fly|Ride"] = 407.4}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 14.7, ["Fly|Ride"] = 52.5, ["Neon"] = 2.1, ["Neon|Fly"] = 26.56, ["Neon|Ride"] = 15.42, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 15.42, ["Mega|Ride"] = 30.18, ["Mega|Fly|Ride"] = 68.25}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Fly|Ride"] = 39.38, ["Neon"] = 3.67, ["Neon|Ride"] = 41.66, ["Neon|Fly|Ride"] = 129.11, ["Mega"] = 18.16, ["Mega|Fly"] = 104.99, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 162.43}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 35.41, ["Ride"] = 19.69, ["Fly|Ride"] = 105.06, ["Neon"] = 16.98, ["Neon|Ride"] = 60.3, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 77.44}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 30.18, ["Ride"] = 52.47, ["Fly|Ride"] = 131.25, ["Neon"] = 137.82, ["Neon|Ride"] = 665.28, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 1181.25, ["Mega|Ride"] = 576.19, ["Mega|Fly|Ride"] = 972.41}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 16.86, ["Ride"] = 13.98, ["Fly|Ride"] = 30.72, ["Neon"] = 13.96, ["Neon|Fly"] = 26.16, ["Neon|Ride"] = 24.01, ["Neon|Fly|Ride"] = 52.29, ["Mega"] = 104.9, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 122.16, ["Mega|Fly|Ride"] = 171.73}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 4.17, ["Fly"] = 40.6, ["Ride"] = 21, ["Fly|Ride"] = 87.72, ["Neon"] = 21, ["Neon|Fly"] = 55.86, ["Neon|Ride"] = 36.88, ["Neon|Fly|Ride"] = 118.01, ["Mega"] = 219.35, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 218.6, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 22.32, ["Ride"] = 18.09, ["Fly|Ride"] = 39.38, ["Neon"] = 15.64, ["Neon|Fly"] = 35.41, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 89.23, ["Mega"] = 158.43, ["Mega|Fly"] = 170.63, ["Mega|Ride"] = 89.55, ["Mega|Fly|Ride"] = 249.87}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 12.05, ["Fly"] = 169.32, ["Ride"] = 23.55, ["Fly|Ride"] = 217.19, ["Neon"] = 30.19, ["Neon|Ride"] = 74.88, ["Neon|Fly|Ride"] = 277.99, ["Mega"] = 269.67, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 624.68}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 6.39, ["Ride"] = 139.54, ["Neon"] = 39.38, ["Neon|Ride"] = 262.5, ["Mega"] = 682.5, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 13.13, ["Fly"] = 42.21, ["Ride"] = 16.96, ["Fly|Ride"] = 44.91, ["Neon"] = 15.64, ["Neon|Fly"] = 196.76, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 171.94, ["Mega"] = 255.94, ["Mega|Ride"] = 324.19, ["Mega|Fly|Ride"] = 416.47}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 24.08, ["Ride"] = 17.75, ["Fly|Ride"] = 35.48, ["Neon"] = 16.1, ["Neon|Fly"] = 47.31, ["Neon|Ride"] = 35.41, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 78.75, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 234.94}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 203.44, ["Fly"] = 393.75, ["Ride"] = 297.98, ["Fly|Ride"] = 392.44, ["Neon"] = 1207.85, ["Neon|Ride"] = 1383.04, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 4026}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 5.97, ["Neon"] = 56.24, ["Mega"] = 122.07, ["Mega|Ride"] = 555.97}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.49, ["Fly"] = 104.13, ["Ride"] = 21.53, ["Fly|Ride"] = 79.07, ["Neon"] = 23.15, ["Neon|Fly"] = 236.38, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 204.35, ["Mega|Ride"] = 324.84, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 6.45, ["Fly|Ride"] = 212.89, ["Neon"] = 52.5, ["Neon|Ride"] = 220.73, ["Neon|Fly|Ride"] = 624.68, ["Mega"] = 603.75, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 560.41}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 13.72, ["Fly|Ride"] = 30.12, ["Neon"] = 2.1, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 35.43, ["Mega"] = 18.38, ["Mega|Fly"] = 74.97, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 17.83, ["Fly|Ride"] = 111.43, ["Neon"] = 7.93, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 103.82, ["Mega|Ride"] = 140.44, ["Mega|Fly|Ride"] = 238.91}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.23, ["Ride"] = 139.54, ["Neon"] = 22.93, ["Neon|Ride"] = 277.99, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 77.44, ["Fly"] = 165.54, ["Ride"] = 112.88, ["Fly|Ride"] = 166.6, ["Neon"] = 556.49, ["Neon|Ride"] = 413.44, ["Neon|Fly|Ride"] = 555.97, ["Mega|Ride"] = 3472.12, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 4.17, ["Fly"] = 97.89, ["Ride"] = 28.88, ["Fly|Ride"] = 100.68, ["Neon"] = 22.78, ["Neon|Ride"] = 63.61, ["Neon|Fly|Ride"] = 416.47, ["Mega|Ride"] = 270.38, ["Mega|Fly|Ride"] = 561.17}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 20.99, ["Ride"] = 41.67, ["Neon"] = 6.57, ["Neon|Ride"] = 177.06, ["Neon|Fly|Ride"] = 530.85, ["Mega"] = 66.94, ["Mega|Fly"] = 314.99, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 48.87, ["Fly"] = 210, ["Ride"] = 102.6, ["Fly|Ride"] = 199.5, ["Neon"] = 144.36, ["Neon|Ride"] = 220.5, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 631.35, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 837.08}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 17.04, ["Ride"] = 12.57, ["Fly|Ride"] = 91.77, ["Neon"] = 2.1, ["Neon|Fly"] = 22.93, ["Neon|Ride"] = 14.62, ["Neon|Fly|Ride"] = 32.7, ["Mega"] = 19.05, ["Mega|Fly"] = 49.87, ["Mega|Ride"] = 35.44, ["Mega|Fly|Ride"] = 83.63}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 32.28, ["Neon|Ride"] = 43.49, ["Neon|Fly|Ride"] = 211.02, ["Mega"] = 15.59, ["Mega|Ride"] = 83.14, ["Mega|Fly|Ride"] = 175.77}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 51.31, ["Neon"] = 7.24, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 339.42, ["Mega"] = 98.44, ["Mega|Fly"] = 181.17, ["Mega|Ride"] = 116.93, ["Mega|Fly|Ride"] = 233.63}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 4.18, ["Fly"] = 55.97, ["Ride"] = 42, ["Fly|Ride"] = 145.45, ["Neon"] = 20.9, ["Neon|Fly"] = 89.56, ["Neon|Ride"] = 77.76, ["Neon|Fly|Ride"] = 459.27, ["Mega"] = 91.88, ["Mega|Fly"] = 236.35, ["Mega|Ride"] = 192.63, ["Mega|Fly|Ride"] = 254.42}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 12.51, ["Ride"] = 12.49, ["Fly|Ride"] = 36.46, ["Neon"] = 2.1, ["Neon|Fly"] = 25.01, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 67.1, ["Mega"] = 16.85, ["Mega|Ride"] = 62.05, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 23.33, ["Fly"] = 131.25, ["Ride"] = 204.75, ["Neon"] = 97.89, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Ride"] = 433.13}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2610.55, ["Fly"] = 3150, ["Ride"] = 2493.75, ["Fly|Ride"] = 2493.75, ["Mega|Fly|Ride"] = 36438.91}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 53.01, ["Ride"] = 13.02, ["Fly|Ride"] = 44.63, ["Neon"] = 8.44, ["Neon|Fly"] = 63.87, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 76.13, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 236.48}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 3.94, ["Neon"] = 4.39, ["Mega"] = 139.53, ["Mega|Fly"] = 441, ["Mega|Ride"] = 158.43, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 28.13, ["Fly"] = 111.43, ["Ride"] = 28.88, ["Fly|Ride"] = 69.78, ["Neon"] = 70.16, ["Neon|Ride"] = 103.79, ["Neon|Fly|Ride"] = 293.22, ["Mega"] = 367.5, ["Mega|Ride"] = 1041.13}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 35.35, ["Ride"] = 44.63, ["Neon"] = 187.69, ["Mega"] = 1249.4, ["Mega|Ride"] = 594.48, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 150.82, ["Fly"] = 1389.03, ["Ride"] = 210, ["Fly|Ride"] = 251.98, ["Neon"] = 1312.5, ["Neon|Ride"] = 700.41, ["Neon|Fly|Ride"] = 819.77, ["Mega"] = 6246.69, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 6.27, ["Ride"] = 31.5, ["Fly|Ride"] = 675.94, ["Neon"] = 19.59, ["Neon|Ride"] = 139.53, ["Mega"] = 156.19, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 307.15, ["Mega|Fly|Ride"] = 353.99}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 35.41, ["Fly|Ride"] = 69.78, ["Neon"] = 26.25, ["Neon|Ride"] = 114.85, ["Mega"] = 140.44, ["Mega|Fly|Ride"] = 840.61}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Ride"] = 28.77, ["Fly|Ride"] = 131.25, ["Neon"] = 9.17, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 139.53, ["Mega"] = 105, ["Mega|Ride"] = 109.37, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 9.19, ["Neon"] = 179.1, ["Neon|Ride"] = 177.19, ["Mega"] = 374.07, ["Mega|Ride"] = 461.23}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 41.67, ["Neon"] = 2.1, ["Neon|Ride"] = 28.12, ["Mega"] = 18.79, ["Mega|Ride"] = 158.45, ["Mega|Fly|Ride"] = 277.99}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 88.69, ["Fly"] = 265.53, ["Ride"] = 87.94, ["Fly|Ride"] = 158.46, ["Neon"] = 366.19, ["Neon|Ride"] = 401.06, ["Neon|Fly|Ride"] = 416.47, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 91.82, ["Neon"] = 10.28, ["Neon|Ride"] = 154.1, ["Mega"] = 70.95}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 36.69, ["Fly"] = 221.09, ["Ride"] = 78.75, ["Fly|Ride"] = 79.24, ["Neon"] = 295.32, ["Neon|Ride"] = 416.47, ["Neon|Fly|Ride"] = 532.88, ["Mega"] = 2625, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 27.09, ["Fly|Ride"] = 50.86, ["Neon"] = 5.23, ["Neon|Fly"] = 87.45, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 41.16, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 178.94}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 10.5, ["Neon|Ride"] = 98.44, ["Mega"] = 75.37, ["Mega|Ride"] = 164.43}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 4.55, ["Fly"] = 77.43, ["Ride"] = 38.57, ["Fly|Ride"] = 208.27, ["Neon"] = 27.74, ["Neon|Ride"] = 111.41, ["Mega"] = 262.5, ["Mega|Ride"] = 324.84, ["Mega|Fly|Ride"] = 555.97}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 346.73, ["Ride"] = 402.94, ["Fly|Ride"] = 518.25, ["Neon"] = 1048.68, ["Neon|Ride"] = 964.66, ["Neon|Fly|Ride"] = 1418.73, ["Mega"] = 4442.44, ["Mega|Ride"] = 4164.46, ["Mega|Fly|Ride"] = 4256.18}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 26.25, ["Fly"] = 83.31, ["Ride"] = 52.5, ["Fly|Ride"] = 99.15, ["Neon"] = 196.88, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 374.81, ["Mega|Fly|Ride"] = 1995}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 49.88, ["Ride"] = 18.15, ["Fly|Ride"] = 150.94, ["Neon"] = 10.25, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 119.55, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 266.76}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 12.62, ["Fly"] = 54.16, ["Ride"] = 43.34, ["Fly|Ride"] = 178.06, ["Neon"] = 66.27, ["Neon|Fly"] = 551.01, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 182.11, ["Mega"] = 314.9, ["Mega|Fly"] = 973.03, ["Mega|Ride"] = 357.7, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 5.39, ["Ride"] = 20.78, ["Fly|Ride"] = 83.31, ["Neon"] = 140.59, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 268.38, ["Mega"] = 312.36, ["Mega|Ride"] = 665.28, ["Mega|Fly|Ride"] = 527.86}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.94, ["Neon"] = 17.06, ["Mega"] = 72.19, ["Mega|Ride"] = 131.25}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 86.63, ["Ride"] = 20.95, ["Fly|Ride"] = 56.24, ["Neon"] = 39.38, ["Neon|Ride"] = 41.66, ["Neon|Fly|Ride"] = 272.78, ["Mega"] = 552.14, ["Mega|Ride"] = 416.47, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 98.44, ["Ride"] = 117.92, ["Fly|Ride"] = 236.25, ["Neon"] = 1025.16, ["Neon|Ride"] = 582.65, ["Neon|Fly|Ride"] = 568.51, ["Mega"] = 2887.5, ["Mega|Fly|Ride"] = 2955.68}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 20.69, ["Ride"] = 45.53, ["Fly|Ride"] = 91.88, ["Neon"] = 142.95, ["Neon|Ride"] = 208.24, ["Mega|Ride"] = 694.44, ["Mega|Fly|Ride"] = 735}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 1995, ["Fly"] = 2008.13, ["Ride"] = 2098.69, ["Fly|Ride"] = 2165.63, ["Neon"] = 11106.93, ["Neon|Fly|Ride"] = 6424.69, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.94, ["Fly"] = 65625, ["Ride"] = 32.82, ["Fly|Ride"] = 196.87, ["Neon"] = 17.75, ["Mega"] = 97.46, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 172.57}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 6.55, ["Ride"] = 47.25, ["Neon"] = 17.83, ["Neon|Ride"] = 76.63, ["Mega"] = 157.5, ["Mega|Ride"] = 204.11, ["Mega|Fly|Ride"] = 1041.13}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 1189.11, ["Fly"] = 948.54, ["Ride"] = 1002.75, ["Fly|Ride"] = 969.94, ["Neon"] = 4726.2, ["Neon|Ride"] = 2611.88, ["Neon|Fly|Ride"] = 2493.75, ["Mega"] = 12216.42, ["Mega|Fly|Ride"] = 12138.37}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 27.57, ["Ride"] = 52.49, ["Fly|Ride"] = 173.35, ["Neon"] = 176.81, ["Neon|Fly|Ride"] = 373.61, ["Mega"] = 832.91, ["Mega|Ride"] = 804.56, ["Mega|Fly|Ride"] = 890.16}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.57, ["Ride"] = 23.59, ["Fly|Ride"] = 128.15, ["Neon"] = 24.92, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 175.88, ["Mega|Ride"] = 268.98, ["Mega|Fly|Ride"] = 364.88}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 139.54, ["Neon"] = 3.84, ["Neon|Ride"] = 69.67, ["Neon|Fly|Ride"] = 91.64, ["Mega"] = 19.69, ["Mega|Ride"] = 254.04, ["Mega|Fly|Ride"] = 277.99}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 87.76, ["Ride"] = 128.63, ["Fly|Ride"] = 170.63, ["Neon"] = 416.51, ["Neon|Ride"] = 591.06, ["Neon|Fly|Ride"] = 630, ["Mega"] = 8328.91, ["Mega|Fly|Ride"] = 2082.24}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.1, ["Neon"] = 11.71, ["Neon|Ride"] = 52.01, ["Neon|Fly|Ride"] = 158.43, ["Mega"] = 158.43, ["Mega|Ride"] = 186.38, ["Mega|Fly|Ride"] = 263.82}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 75.71, ["Ride"] = 154.12, ["Neon"] = 614.25, ["Neon|Ride"] = 415.42, ["Neon|Fly|Ride"] = 511.21}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 3.83, ["Fly"] = 105, ["Neon"] = 26.22, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 171.93, ["Mega|Ride"] = 307.15, ["Mega|Fly|Ride"] = 395.07}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 232.15, ["Ride"] = 286.13, ["Fly|Ride"] = 334.59, ["Neon"] = 1498.88, ["Neon|Ride"] = 1057.97, ["Neon|Fly|Ride"] = 879.27, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 4.17, ["Fly"] = 87.94, ["Ride"] = 19.45, ["Fly|Ride"] = 105, ["Neon"] = 28.76, ["Neon|Fly"] = 158.46, ["Neon|Ride"] = 57.1, ["Neon|Fly|Ride"] = 100.59, ["Mega"] = 210, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 21.3, ["Ride"] = 13.34, ["Fly|Ride"] = 28.03, ["Neon"] = 3.5, ["Neon|Fly"] = 31.39, ["Neon|Ride"] = 20.78, ["Neon|Fly|Ride"] = 60.35, ["Mega"] = 48.28, ["Mega|Ride"] = 70.88, ["Mega|Fly|Ride"] = 236.48}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1247.42, ["Ride"] = 1050, ["Fly|Ride"] = 1422.75, ["Neon|Ride"] = 7635.53, ["Neon|Fly|Ride"] = 6038.46, ["Mega"] = 23645.37}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 8.95, ["Fly"] = 972.53, ["Ride"] = 72.19, ["Neon"] = 72.71, ["Neon|Ride"] = 131.19, ["Mega"] = 315, ["Mega|Ride"] = 378.98, ["Mega|Fly|Ride"] = 694.44}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 4.86, ["Fly"] = 50, ["Ride"] = 44.79, ["Fly|Ride"] = 79.59, ["Neon"] = 20.69, ["Neon|Fly"] = 158.46, ["Neon|Ride"] = 52.87, ["Neon|Fly|Ride"] = 173.87, ["Mega"] = 175.88, ["Mega|Ride"] = 191.05, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 34.13, ["Fly"] = 39.38, ["Ride"] = 35.44, ["Fly|Ride"] = 52.5, ["Neon|Ride"] = 196.86, ["Neon|Fly|Ride"] = 209.67, ["Mega|Fly|Ride"] = 850.5}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 11.44, ["Fly"] = 83.31, ["Ride"] = 27.46, ["Fly|Ride"] = 98.44, ["Neon"] = 69.42, ["Neon|Ride"] = 98.43, ["Neon|Fly|Ride"] = 179.8, ["Mega"] = 367.5, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 28.75, ["Ride"] = 111.16, ["Fly|Ride"] = 406.1, ["Neon"] = 170.63, ["Neon|Ride"] = 376.69, ["Mega"] = 1050, ["Mega|Ride"] = 694.44, ["Mega|Fly|Ride"] = 541.4}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Fly|Ride"] = 79.24, ["Neon"] = 2.62, ["Neon|Ride"] = 111.14, ["Mega"] = 18.38, ["Mega|Ride"] = 83.45}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 72.19, ["Fly"] = 123.48, ["Ride"] = 95.12, ["Fly|Ride"] = 105.54, ["Neon"] = 446.24, ["Neon|Ride"] = 393.74, ["Neon|Fly|Ride"] = 447.57, ["Mega"] = 3331.57, ["Mega|Fly|Ride"] = 1563.58}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 3.4, ["Fly"] = 107.62, ["Ride"] = 30.75, ["Fly|Ride"] = 70.88, ["Neon"] = 63, ["Neon|Ride"] = 110.37, ["Mega|Ride"] = 394.9}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 20.95, ["Ride"] = 15.89, ["Fly|Ride"] = 42, ["Neon"] = 17.26, ["Neon|Fly"] = 83.3, ["Neon|Ride"] = 56.23, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 273.82, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 3.92, ["Ride"] = 126, ["Neon"] = 16.03, ["Neon|Fly"] = 137.46, ["Neon|Fly|Ride"] = 206.92, ["Mega"] = 361.28, ["Mega|Fly|Ride"] = 472.92}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 63, ["Ride"] = 111.43, ["Fly|Ride"] = 262.5, ["Neon"] = 262.5, ["Neon|Ride"] = 282.19, ["Neon|Fly|Ride"] = 555.97, ["Mega|Ride"] = 1353.47, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 13.13, ["Neon"] = 16.69, ["Mega"] = 122.07, ["Mega|Ride"] = 117.66, ["Mega|Fly|Ride"] = 315.69}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 33.78, ["Neon"] = 2.1, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 16.54, ["Mega|Ride"] = 40.28, ["Mega|Fly|Ride"] = 520.57}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.94, ["Ride"] = 35.41, ["Fly|Ride"] = 58.3, ["Neon"] = 3.82, ["Neon|Ride"] = 28.59, ["Neon|Fly|Ride"] = 166.6, ["Mega"] = 16.53, ["Mega|Ride"] = 55.97, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 31.25, ["Ride"] = 19.69, ["Fly|Ride"] = 52.5, ["Neon"] = 6.56, ["Neon|Ride"] = 28.58, ["Neon|Fly|Ride"] = 87.47, ["Mega"] = 61.68, ["Mega|Ride"] = 78.74, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.55, ["Ride"] = 28.88, ["Fly|Ride"] = 111.43, ["Neon"] = 39.38, ["Mega"] = 118.1, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 15.08, ["Fly|Ride"] = 32.04, ["Neon"] = 6.57, ["Neon|Fly"] = 208.27, ["Neon|Ride"] = 24.92, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 144.38, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 51.19, ["Ride"] = 91.62, ["Fly|Ride"] = 264.49, ["Neon"] = 196.87, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 1041.13, ["Mega"] = 961.8, ["Mega|Ride"] = 1021.35, ["Mega|Fly|Ride"] = 1097.35}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 15.54, ["Ride"] = 15.36, ["Fly|Ride"] = 35.44, ["Neon"] = 4.09, ["Neon|Fly"] = 32.81, ["Neon|Ride"] = 17.06, ["Neon|Fly|Ride"] = 39.3, ["Mega"] = 19.69, ["Mega|Ride"] = 23.72, ["Mega|Fly|Ride"] = 99.65}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 7.32, ["Fly"] = 129.93, ["Ride"] = 69.78, ["Fly|Ride"] = 57.2, ["Neon"] = 26.2, ["Neon|Fly"] = 87.28, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 302.27, ["Mega|Ride"] = 192.57, ["Mega|Fly|Ride"] = 832.91}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 13.23, ["Fly"] = 47.06, ["Ride"] = 27.57, ["Fly|Ride"] = 107.63, ["Neon"] = 124.69, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 182.44, ["Mega"] = 787.5, ["Mega|Ride"] = 722.54, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 13.13, ["Fly"] = 196.88, ["Ride"] = 44.63, ["Neon"] = 52.31, ["Mega"] = 366.19, ["Mega|Ride"] = 1048.69, ["Mega|Fly|Ride"] = 416.47}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 13.56, ["Fly|Ride"] = 44.54, ["Neon"] = 3.51, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 17.48, ["Neon|Fly|Ride"] = 57.87, ["Mega"] = 72.19, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 145.26, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.21, ["Fly"] = 77.07, ["Ride"] = 38.07, ["Neon"] = 22.23, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 206.05, ["Mega"] = 208.24, ["Mega|Fly"] = 735, ["Mega|Ride"] = 222.81, ["Mega|Fly|Ride"] = 389.4}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 958.13, ["Fly"] = 1371.4, ["Ride"] = 1023.75, ["Fly|Ride"] = 1103.82, ["Neon|Ride"] = 2231.25, ["Neon|Fly|Ride"] = 2342.71, ["Mega|Fly|Ride"] = 7086.19}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 111.43, ["Ride"] = 165.57, ["Fly|Ride"] = 414.42, ["Neon"] = 556.04, ["Neon|Ride"] = 628.69, ["Neon|Fly|Ride"] = 820.31, ["Mega"] = 6246.69, ["Mega|Ride"] = 2638.19, ["Mega|Fly|Ride"] = 2347.02}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly"] = 56.24, ["Neon"] = 5.82, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 208.24, ["Mega"] = 139.53}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 70.14, ["Ride"] = 120.75, ["Fly|Ride"] = 229.69, ["Neon"] = 392.42, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 630, ["Mega"] = 1836.19, ["Mega|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 1711.05}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.1, ["Ride"] = 20.84, ["Fly|Ride"] = 90.61, ["Neon"] = 16.21, ["Neon|Fly"] = 55.58, ["Neon|Ride"] = 49.45, ["Neon|Fly|Ride"] = 277.99, ["Mega"] = 277.99, ["Mega|Ride"] = 316.32, ["Mega|Fly|Ride"] = 402.93}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 223.12, ["Fly"] = 945.81, ["Ride"] = 271.68, ["Fly|Ride"] = 369.36, ["Neon|Ride"] = 1415.92, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 4528.13}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 76.4, ["Ride"] = 59.07, ["Fly|Ride"] = 218.76, ["Neon"] = 31.5, ["Neon|Fly"] = 35.41, ["Neon|Ride"] = 54.37, ["Mega"] = 412.3, ["Mega|Fly"] = 324.84, ["Mega|Ride"] = 631.35}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 28.6, ["Mega"] = 333.17, ["Mega|Ride"] = 357.12}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 30.18, ["Ride"] = 52.45, ["Fly|Ride"] = 131.25, ["Neon"] = 151.36, ["Neon|Ride"] = 124.59, ["Mega"] = 638.44, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.75, ["Neon"] = 24.94, ["Neon|Ride"] = 141.91, ["Mega"] = 236.48, ["Mega|Ride"] = 253.3}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 15.92, ["Ride"] = 14.44, ["Fly|Ride"] = 39.36, ["Neon"] = 2.1, ["Neon|Fly"] = 31.94, ["Neon|Ride"] = 15.49, ["Neon|Fly|Ride"] = 37.49, ["Mega"] = 23.66, ["Mega|Ride"] = 175.98, ["Mega|Fly|Ride"] = 80.63}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4593.75, ["Ride"] = 5130.57, ["Fly|Ride"] = 4845.75, ["Neon"] = 31237.19, ["Neon|Fly|Ride"] = 19293.75, ["Mega|Fly|Ride"] = 130138.93}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 18.76, ["Fly"] = 83.31, ["Ride"] = 56.43, ["Neon"] = 52.5, ["Neon|Ride"] = 105, ["Mega"] = 208.24, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 416.47}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.69, ["Ride"] = 15.69, ["Fly|Ride"] = 35, ["Neon"] = 13.13, ["Neon|Fly"] = 45.91, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 64.22, ["Mega"] = 124.69, ["Mega|Ride"] = 189.17, ["Mega|Fly|Ride"] = 235.3}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 432.93, ["Fly"] = 547.77, ["Ride"] = 485.63, ["Fly|Ride"] = 560.44, ["Neon"] = 2100, ["Neon|Fly|Ride"] = 1388.86, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 3.97, ["Ride"] = 32.62, ["Neon"] = 35.32, ["Mega"] = 187.95, ["Mega|Ride"] = 208.24, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.34, ["Fly"] = 4164.97, ["Ride"] = 65.63, ["Neon"] = 23.55, ["Neon|Ride"] = 63.86, ["Mega"] = 414.38, ["Mega|Ride"] = 401.63, ["Mega|Fly|Ride"] = 277.99}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Ride"] = 20.36, ["Neon"] = 3.82, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 23.29, ["Neon|Fly|Ride"] = 91.74, ["Mega"] = 37.97, ["Mega|Ride"] = 78.09, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 1064.02, ["Ride"] = 765.19, ["Fly|Ride"] = 786.19, ["Neon|Ride"] = 3281.25, ["Neon|Fly|Ride"] = 2939.99}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 4.24, ["Ride"] = 59.91, ["Fly|Ride"] = 416.51, ["Neon"] = 32.71, ["Neon|Ride"] = 72.9, ["Neon|Fly|Ride"] = 291.53, ["Mega"] = 163.96, ["Mega|Ride"] = 229.69, ["Mega|Fly|Ride"] = 379.53}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 4.96, ["Fly"] = 236.25, ["Ride"] = 43.84, ["Neon"] = 24.85, ["Neon|Ride"] = 51.1, ["Neon|Fly|Ride"] = 218.66, ["Mega"] = 205.04, ["Mega|Fly"] = 788.6, ["Mega|Ride"] = 277.99, ["Mega|Fly|Ride"] = 353.52}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 16.69, ["Fly|Ride"] = 45.94, ["Neon"] = 17.74, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 31.17, ["Neon|Fly|Ride"] = 76.13, ["Mega"] = 277.99, ["Mega|Fly|Ride"] = 219.14}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 19.59, ["Ride"] = 38.07, ["Fly|Ride"] = 52.7, ["Neon"] = 117.58, ["Neon|Fly|Ride"] = 312.36, ["Mega"] = 555.97, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 972.41}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 1.68, ["Ride"] = 42.88, ["Fly|Ride"] = 83.31, ["Neon"] = 6.46, ["Neon|Ride"] = 45.22, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 101.07, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 616.88, ["Ride"] = 538.12, ["Fly|Ride"] = 694.53, ["Neon"] = 2589.57, ["Neon|Ride"] = 2360.22, ["Neon|Fly|Ride"] = 2391.38, ["Mega|Ride"] = 9221.71, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 79.95, ["Neon"] = 16.8, ["Neon|Ride"] = 85.39, ["Neon|Fly|Ride"] = 472.92, ["Mega"] = 212.4, ["Mega|Ride"] = 174.39}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 27.56, ["Neon"] = 6.18, ["Neon|Fly"] = 236.38, ["Neon|Ride"] = 36.45, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 47.92, ["Mega|Fly|Ride"] = 353.99}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 40.82, ["Neon"] = 3.29, ["Neon|Ride"] = 45.02, ["Neon|Fly|Ride"] = 416.47, ["Mega"] = 45.94, ["Mega|Fly"] = 154.1, ["Mega|Ride"] = 103.22, ["Mega|Fly|Ride"] = 145.68}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Neon"] = 17.75, ["Mega"] = 208.24, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 28.88, ["Fly"] = 98.44, ["Ride"] = 45.77, ["Fly|Ride"] = 278.02, ["Neon"] = 122.06, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 334.69, ["Mega"] = 826.65, ["Mega|Ride"] = 967.32, ["Mega|Fly|Ride"] = 931.82}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 12.92, ["Ride"] = 48.39, ["Fly|Ride"] = 128.99, ["Neon"] = 65.62, ["Neon|Ride"] = 141.87, ["Neon|Fly|Ride"] = 277.99, ["Mega"] = 491.27, ["Mega|Ride"] = 541.4, ["Mega|Fly|Ride"] = 693.39}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 28.13, ["Ride"] = 14.74, ["Fly|Ride"] = 32.82, ["Neon"] = 28.65, ["Neon|Fly"] = 56.23, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 87.18, ["Mega"] = 394.59, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 9.19, ["Ride"] = 102.88, ["Fly|Ride"] = 120.8, ["Neon"] = 70.82, ["Neon|Ride"] = 193.66, ["Mega"] = 472.92, ["Mega|Ride"] = 416.47}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 111.57, ["Neon"] = 10.49, ["Neon|Ride"] = 40.34, ["Neon|Fly|Ride"] = 156.08, ["Mega"] = 105, ["Mega|Ride"] = 115.49, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 15.42, ["Ride"] = 30.18, ["Fly|Ride"] = 62.5, ["Neon"] = 416.51, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 222.81, ["Mega"] = 935.97, ["Mega|Fly|Ride"] = 820.41}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 35.74, ["Fly"] = 874.13, ["Neon"] = 210.34, ["Mega"] = 328.13, ["Mega|Ride"] = 590.63}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 56.6, ["Fly"] = 153.58, ["Ride"] = 79.55, ["Fly|Ride"] = 160.13, ["Neon"] = 277.4, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 418.97, ["Mega|Ride"] = 1671.74, ["Mega|Fly|Ride"] = 1784.48}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 38.07, ["Fly"] = 83.31, ["Ride"] = 76.73, ["Fly|Ride"] = 208.27, ["Neon"] = 143.28, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 525, ["Mega"] = 867.81, ["Mega|Ride"] = 652.5, ["Mega|Fly|Ride"] = 570.94}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 18.38, ["Ride"] = 57.5, ["Fly|Ride"] = 208.27, ["Neon"] = 139.54, ["Neon|Ride"] = 284.82, ["Mega"] = 1049.99, ["Mega|Ride"] = 788.6}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 12.5, ["Fly"] = 416.51, ["Ride"] = 32.19, ["Fly|Ride"] = 192.95, ["Neon"] = 114.72, ["Neon|Fly"] = 420, ["Neon|Ride"] = 139.78, ["Neon|Fly|Ride"] = 141.89, ["Mega"] = 464.37, ["Mega|Ride"] = 530.39, ["Mega|Fly|Ride"] = 636.68}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.74, ["Ride"] = 15.09, ["Fly|Ride"] = 32.73, ["Neon"] = 2.86, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 28.9, ["Neon|Fly|Ride"] = 43.67, ["Mega"] = 35.44, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 402.93}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 866.23}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 41.49, ["Ride"] = 98.44, ["Fly|Ride"] = 369.66, ["Neon"] = 344.4, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 652.32, ["Mega"] = 972.41, ["Mega|Ride"] = 1418.73, ["Mega|Fly|Ride"] = 1283.79}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 79.73, ["Neon"] = 3.94, ["Neon|Ride"] = 43.19, ["Neon|Fly|Ride"] = 291.53, ["Mega"] = 27.99, ["Mega|Ride"] = 84.94}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 25.09, ["Ride"] = 51.45, ["Fly|Ride"] = 168.7, ["Neon"] = 135.69, ["Neon|Ride"] = 136.4, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 514.55, ["Mega|Ride"] = 788.6, ["Mega|Fly|Ride"] = 1249.35}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.9, ["Neon|Ride"] = 20.84, ["Mega"] = 23.68}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.84, ["Neon|Ride"] = 39.38, ["Mega"] = 21, ["Mega|Ride"] = 151.41}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 102.53, ["Fly"] = 223.13, ["Ride"] = 120.78, ["Neon"] = 515.43, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 656.25, ["Mega|Ride"] = 2621.53, ["Mega|Fly|Ride"] = 2098.69}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.2, ["Fly"] = 90.57, ["Ride"] = 27.09, ["Fly|Ride"] = 96.15, ["Neon"] = 9.19, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 90.17, ["Mega|Ride"] = 111.41, ["Mega|Fly|Ride"] = 281.71}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Fly|Ride"] = 52.5, ["Neon"] = 5.93, ["Neon|Ride"] = 36.45, ["Neon|Fly|Ride"] = 419.99, ["Mega"] = 35.44, ["Mega|Ride"] = 124.95, ["Mega|Fly|Ride"] = 694.44}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 4.93, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 210, ["Mega"] = 76.1, ["Mega|Ride"] = 220.73, ["Mega|Fly|Ride"] = 245.44}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 28.13, ["Neon"] = 5.93, ["Neon|Ride"] = 155.81, ["Mega"] = 84.88, ["Mega|Ride"] = 207.38}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 64.2, ["Ride"] = 135.19, ["Fly|Ride"] = 1041.25, ["Neon"] = 424.07, ["Neon|Ride"] = 555.97, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1803.22, ["Mega|Ride"] = 1561.68, ["Mega|Fly|Ride"] = 1527.32}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.67, ["Ride"] = 33.33, ["Neon"] = 39.35, ["Neon|Ride"] = 227.07, ["Mega"] = 413.86, ["Mega|Ride"] = 945.83}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.04}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 347.08, ["Ride"] = 328.13, ["Neon"] = 1115.63, ["Neon|Ride"] = 1182.09, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4164.46}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.04}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 84}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 45.94}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 32.71}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 17.75}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 129.12}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 104.34}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 13.27}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 4.03}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 262.4}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 26.25}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 32.36}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 6.86}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 19.69}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 212.43}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 11.47}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 5.33}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 3.84}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 9.72}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 12.5}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 552.57}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 785.02}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 7.4}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1243.27}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 7.89}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.55}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 31.94}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.3}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 24.44}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 34.1}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 47.25}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 18.68}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 9.54}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 17.64}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.68}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 18.27}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.1}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 17.75}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 140.07}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.57}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 2068.5}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 30.36}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 307.92}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 6.65}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 8.54}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 5.62}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 49.64}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 193.17}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 6.21}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 11.21}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.55}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 1181.25}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 22.76}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 4.75}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 15.54}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 6.55}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 12.95}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 218.68}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 28.88}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 7.35}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.63}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 21.94}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 7.43}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 6.89}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 26.04}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 78.75}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 222.98}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.63}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 4.76}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 131.1}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.91}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 108.94}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 20.89}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22462.5}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 315.51}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 158.43}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 78.75}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 47.31}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 44.63}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 48.23}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 98.93}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 78.74}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 90.61}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 56.51}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 144.38}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 55.11}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 6976.32}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 233.37}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 6.92}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 6.14}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 2.16}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 31.77}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 137.22}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.15}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 4.55}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 3.94}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 7.52}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 944.99}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 15.65}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 583.68}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 13.85}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.61}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.62}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 614.78}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 24.31}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 170.78}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 18.61}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 20.46}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 47.16}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 12.57}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.46}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 7.98}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.5}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 5.15}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 4.13}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 28.77}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.88}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.85}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.63}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 26.16}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 728.44}},
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
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1048.59}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 10.12}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 5.43}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 6.4}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 24.55}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 14.39}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 2.71}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.55}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 8.6}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 2.1}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 8.76}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 30.79}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 13.39}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 4.57}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 4.03}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 9.34}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 6.57}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 1.68}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 4.87}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 5.5}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.4}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.7}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.55}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 6.41}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 8052.96}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.61}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 20.31}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.15}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 9}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 6.44}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 18.1}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 9.19}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 7.88}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.04}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 30.19}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 7.14}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.81}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 4.86}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.55}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 6.26}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4164.97}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 16.16}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 30.98}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.55}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 6.37}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.55}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 2.86}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 66.97}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 65.54}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 4.48}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 122.8}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 14.06}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.49}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 2.48}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 7.54}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 17.33}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.61}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.65}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.15}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 15.73}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.7}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 2.96}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.37}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.41}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.49}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.49}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 32.82}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 3.92}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 8.48}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 275.62}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.53}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 65.69}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 5.92}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 3.29}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1042.1}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 38.54}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.63}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 2.66}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 16.02}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.63}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 11.81}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.44}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 6.12}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 6.02}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 10.86}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 14.2}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 14.49}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 1.68}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 3.94}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 5.16}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.49}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 7.67}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 10.37}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 21.41}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.44}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 5.98}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 3.52}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 18.9}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 51.76}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 3.75}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 32.44}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 85.32}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 6.24}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.61}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 50.3}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 28.67}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 4.59}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 4.19}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 3.68}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 1.79}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 5.97}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 137.45}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 143.66}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 5.16}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1272.07}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 4.29}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 235.34}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 20.44}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 53.7}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 3.73}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 3.68}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.46}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 67.34}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 17.54}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 8.59}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.85}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 5.44}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 61.85}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 2.2}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 62.48}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 3.85}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 28.88}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.27}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 3.97}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 179.1}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 74.74}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 6.07}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 4.11}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 10.43}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 57.66}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 52.41}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 66.94}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 182.72}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 54.32}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 194.73}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.4}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.48}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 8.28}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 26.36}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 65.96}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 10.4}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 61.66}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.61}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 81.37}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 15.06}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 61.43}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 34.55}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 1.68}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 24.82}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 44.63}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.37}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 26.25}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.92}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 12.24}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 64.99}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 1.68}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 37.58}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 81.78}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1868}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 9.19}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 5.71}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 172.87}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 333.21}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 17.93}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 16.76}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 11.33}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 8.97}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 11.68}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 318.77}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 52.17}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 49.26}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 4.27}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 87.48}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 165.39}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 62.84}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1116.94}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 315.68}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 6.57}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2360.5}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 551.24}},
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