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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1049.9, ["Ride"] = 1154.99, ["Fly|Ride"] = 1292.82, ["Neon"] = 6770.28, ["Neon|Ride"] = 6562.5, ["Neon|Fly|Ride"] = 4268.97, ["Mega|Fly|Ride"] = 17724.75}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 414.4, ["Ride"] = 498.25, ["Fly|Ride"] = 551.15, ["Neon|Fly|Ride"] = 1967.44, ["Mega"] = 12083.96, ["Mega|Fly|Ride"] = 7040.23}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 5465.32, ["Ride"] = 5197.49, ["Fly|Ride"] = 4958.63, ["Neon|Fly|Ride"] = 21770.63, ["Mega|Fly|Ride"] = 71113.67}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 160.12, ["Ride"] = 212.33, ["Fly|Ride"] = 275.63, ["Neon"] = 996.48, ["Neon|Ride"] = 979.74, ["Neon|Fly|Ride"] = 984.38, ["Mega|Fly|Ride"] = 4263}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 570.94, ["Fly"] = 853.51, ["Ride"] = 584.66, ["Fly|Ride"] = 682.5, ["Neon|Fly|Ride"] = 1745.63, ["Mega|Fly|Ride"] = 6825}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 8.66, ["Ride"] = 57.68, ["Fly|Ride"] = 129.94, ["Neon"] = 71.52, ["Neon|Ride"] = 58.09, ["Neon|Fly|Ride"] = 404.25, ["Mega"] = 316.32, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 597.37}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.53, ["Fly"] = 41.3, ["Ride"] = 24.66, ["Fly|Ride"] = 60.45, ["Neon"] = 26.06, ["Neon|Fly"] = 103.68, ["Neon|Ride"] = 56, ["Neon|Fly|Ride"] = 113.6, ["Mega"] = 168.16, ["Mega|Ride"] = 220.5, ["Mega|Fly|Ride"] = 257.19}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 98.44, ["Fly"] = 213.39, ["Ride"] = 152.27, ["Fly|Ride"] = 238.91, ["Neon"] = 567.79, ["Neon|Ride"] = 541.1, ["Neon|Fly|Ride"] = 690.52, ["Mega"] = 1586.82, ["Mega|Fly|Ride"] = 2785.17}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 36.29, ["Fly"] = 62.48, ["Ride"] = 38.97, ["Fly|Ride"] = 93.76, ["Neon"] = 275.63, ["Neon|Fly"] = 322.81, ["Neon|Ride"] = 242.82, ["Neon|Fly|Ride"] = 324.6, ["Mega"] = 1422.99, ["Mega|Ride"] = 1289.37, ["Mega|Fly|Ride"] = 946.32}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 19.25, ["Fly"] = 84.28, ["Ride"] = 34.13, ["Fly|Ride"] = 62.9, ["Neon"] = 32.66, ["Neon|Ride"] = 169.72, ["Neon|Fly|Ride"] = 199.5, ["Mega|Fly|Ride"] = 1109.39}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 54.89, ["Fly"] = 206.07, ["Ride"] = 70.16, ["Fly|Ride"] = 189.51, ["Neon"] = 444.91, ["Neon|Ride"] = 248.75, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1138.18, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 57.16}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 319.92, ["Fly"] = 399, ["Ride"] = 308.44, ["Fly|Ride"] = 376.52, ["Neon|Ride"] = 1048.69, ["Neon|Fly|Ride"] = 1127.44, ["Mega|Fly|Ride"] = 5114.84}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 104.26, ["Fly"] = 170.71, ["Ride"] = 123.75, ["Fly|Ride"] = 174.98, ["Neon|Fly"] = 701.22, ["Neon|Fly|Ride"] = 446.25, ["Mega|Fly|Ride"] = 3101.97}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.47, ["Ride"] = 55.04, ["Fly|Ride"] = 131.25, ["Neon"] = 16.75, ["Neon|Ride"] = 60.2, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 131.25, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 322.16, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 183.54, ["Fly"] = 286.33, ["Ride"] = 178.26, ["Fly|Ride"] = 212.23, ["Neon"] = 846.29, ["Neon|Ride"] = 882.62, ["Neon|Fly|Ride"] = 893.02, ["Mega|Fly|Ride"] = 2730}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.62, ["Fly"] = 22.63, ["Ride"] = 19.36, ["Fly|Ride"] = 36.33, ["Neon"] = 28.86, ["Neon|Fly"] = 128.09, ["Neon|Ride"] = 93.93, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 180.58, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 89.79, ["Fly"] = 284.72, ["Ride"] = 140.04, ["Fly|Ride"] = 170.71, ["Neon"] = 333.82, ["Neon|Ride"] = 380.63, ["Neon|Fly|Ride"] = 420, ["Mega"] = 1703.79, ["Mega|Ride"] = 1458.2, ["Mega|Fly|Ride"] = 1422.75}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 37.68}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 61.58, ["Ride"] = 91.88, ["Fly|Ride"] = 213.39, ["Neon"] = 393.75, ["Neon|Fly|Ride"] = 569.92}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 17.09, ["Fly"] = 55.5, ["Ride"] = 32.47, ["Fly|Ride"] = 384.09, ["Neon"] = 239.02, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 656.25, ["Mega|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 710.45}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 43.23, ["Fly"] = 71.49, ["Ride"] = 54.43, ["Fly|Ride"] = 100.49, ["Neon"] = 711.86, ["Neon|Ride"] = 290.17, ["Neon|Fly|Ride"] = 303.19, ["Mega"] = 1691.76, ["Mega|Ride"] = 1422.99, ["Mega|Fly|Ride"] = 916.14}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 28.58, ["Fly"] = 78.75, ["Ride"] = 111.57, ["Fly|Ride"] = 266.74, ["Neon"] = 210, ["Neon|Fly"] = 401.4, ["Neon|Ride"] = 371.23, ["Neon|Fly|Ride"] = 467.25, ["Mega"] = 2047.5, ["Mega|Ride"] = 1706.74, ["Mega|Fly|Ride"] = 1354.73}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 16.25, ["Ride"] = 35.18, ["Fly|Ride"] = 84, ["Neon"] = 213.46, ["Neon|Ride"] = 212.4, ["Neon|Fly|Ride"] = 213.35, ["Mega"] = 957.91, ["Mega|Ride"] = 1138.18, ["Mega|Fly|Ride"] = 1138.18}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 31.28, ["Fly"] = 136.75, ["Ride"] = 57.66, ["Fly|Ride"] = 153.54, ["Neon"] = 284.96, ["Neon|Ride"] = 220.83, ["Neon|Fly|Ride"] = 262.49, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 958.13}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 4.17, ["Fly"] = 28.35, ["Ride"] = 19.85, ["Fly|Ride"] = 52.5, ["Neon"] = 30.09, ["Neon|Fly"] = 101.05, ["Neon|Ride"] = 54.45, ["Neon|Fly|Ride"] = 82.73, ["Mega"] = 196.88, ["Mega|Fly"] = 312.79, ["Mega|Ride"] = 182.33, ["Mega|Fly|Ride"] = 264.49}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 452.61, ["Ride"] = 459.27, ["Fly|Ride"] = 518.37, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1964.82, ["Mega|Fly|Ride"] = 8676.55}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 13.86, ["Ride"] = 32.65, ["Fly|Ride"] = 114.17, ["Neon"] = 214.82, ["Mega|Ride"] = 810.71, ["Mega|Fly|Ride"] = 923.78}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 4.66, ["Fly"] = 36.17, ["Ride"] = 21.33, ["Fly|Ride"] = 40.42, ["Neon"] = 65.63, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 426.69, ["Mega|Ride"] = 388.5, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 91.76, ["Fly"] = 102.18, ["Ride"] = 100.37, ["Fly|Ride"] = 135.05, ["Neon"] = 371.24, ["Neon|Fly"] = 374.61, ["Neon|Ride"] = 417.31, ["Neon|Fly|Ride"] = 399, ["Mega"] = 4409.75, ["Mega|Ride"] = 5832.75, ["Mega|Fly|Ride"] = 1692.87}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 10.13, ["Ride"] = 32.82, ["Fly|Ride"] = 118.13, ["Neon"] = 131.25, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 221.82, ["Mega"] = 710.01, ["Mega|Ride"] = 806.02}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 203.99, ["Fly"] = 301.88, ["Ride"] = 246.39, ["Fly|Ride"] = 301.88, ["Neon"] = 672.79, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 924.84, ["Mega"] = 6400.21, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 23.55}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.07, ["Fly"] = 32.65, ["Ride"] = 24.55, ["Fly|Ride"] = 54.54, ["Neon"] = 18.38, ["Neon|Fly"] = 137.84, ["Neon|Ride"] = 52.48, ["Neon|Fly|Ride"] = 143.03, ["Mega"] = 136.6, ["Mega|Fly"] = 483.68, ["Mega|Ride"] = 182.44, ["Mega|Fly|Ride"] = 284.9}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 820.31, ["Fly"] = 2625, ["Ride"] = 891.18, ["Fly|Ride"] = 942.03, ["Neon"] = 17409.26, ["Neon|Ride"] = 6261.51, ["Neon|Fly|Ride"] = 4282.32, ["Mega|Ride"] = 54377.78, ["Mega|Fly|Ride"] = 17067.2}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 12.08, ["Fly"] = 52.49, ["Ride"] = 30.35, ["Fly|Ride"] = 91.49, ["Neon"] = 91.88, ["Neon|Ride"] = 99.21, ["Neon|Fly|Ride"] = 235.87, ["Mega"] = 782.98, ["Mega|Ride"] = 1095.51, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 190.21, ["Fly"] = 362.65, ["Ride"] = 249.73, ["Fly|Ride"] = 275.63, ["Neon"] = 830.82, ["Neon|Ride"] = 733.67, ["Neon|Fly|Ride"] = 967.19, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 4030.02}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 45.61}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 16.7, ["Fly"] = 114.17, ["Ride"] = 65.63, ["Fly|Ride"] = 142.97, ["Neon"] = 104.9, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 711.51, ["Mega|Ride"] = 1125.38, ["Mega|Fly|Ride"] = 598.17}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 110.92, ["Ride"] = 166.69, ["Fly|Ride"] = 262.5, ["Neon"] = 533.64, ["Neon|Ride"] = 526.98, ["Neon|Fly|Ride"] = 569.92, ["Mega|Fly|Ride"] = 2723.17}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 117.56, ["Fly"] = 157.49, ["Ride"] = 162.75, ["Fly|Ride"] = 274.32, ["Neon"] = 360.94, ["Neon|Fly"] = 569.92, ["Neon|Ride"] = 430.42, ["Neon|Fly|Ride"] = 472.49, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1560.56}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 32.13}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 52.5, ["Fly"] = 45.02, ["Ride"] = 55.56, ["Fly|Ride"] = 73.38, ["Neon|Ride"] = 456.8, ["Neon|Fly|Ride"] = 421.57, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 4.68, ["Fly"] = 98.44, ["Ride"] = 35.32, ["Fly|Ride"] = 157.49, ["Neon"] = 42, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 67.56, ["Neon|Fly|Ride"] = 240.15, ["Mega"] = 367.5, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 298.97, ["Mega|Fly|Ride"] = 649.69}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 485.52, ["Fly"] = 479.07, ["Ride"] = 477.65, ["Fly|Ride"] = 524.99, ["Neon|Ride"] = 2055.27, ["Neon|Fly|Ride"] = 1742.98, ["Mega|Ride"] = 14933.8, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 110.65, ["Fly"] = 213.39, ["Ride"] = 111.57, ["Fly|Ride"] = 188.26, ["Neon"] = 420, ["Neon|Ride"] = 554.97, ["Neon|Fly|Ride"] = 569.64, ["Mega|Fly|Ride"] = 2536.63}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3675, ["Ride"] = 3885, ["Fly|Ride"] = 3674.99, ["Neon|Fly|Ride"] = 14940.3}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 40.58, ["Fly"] = 121.64, ["Ride"] = 56.59, ["Fly|Ride"] = 128.63, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 1599, ["Mega|Ride"] = 1820.87, ["Mega|Fly|Ride"] = 1422.99}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 63, ["Ride"] = 68.08, ["Fly|Ride"] = 83.45, ["Neon"] = 645.61, ["Neon|Ride"] = 427.88, ["Neon|Fly|Ride"] = 431.82, ["Mega|Ride"] = 2276.35, ["Mega|Fly|Ride"] = 2323.78}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 31.96, ["Fly"] = 56.35, ["Ride"] = 38.66, ["Fly|Ride"] = 90.72, ["Neon"] = 139.21, ["Neon|Ride"] = 137.38, ["Neon|Fly|Ride"] = 187.65, ["Mega"] = 2625, ["Mega|Ride"] = 697.65, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 6.22}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 40.25, ["Ride"] = 62.87, ["Fly|Ride"] = 71.6, ["Neon|Ride"] = 322.81, ["Neon|Fly|Ride"] = 426.69, ["Mega|Ride"] = 1289.37, ["Mega|Fly|Ride"] = 1493.63}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 41.91}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 197.03, ["Ride"] = 236.25, ["Fly|Ride"] = 301.88, ["Neon|Ride"] = 1423.71, ["Neon|Fly|Ride"] = 1105.69, ["Mega|Fly|Ride"] = 4599.61}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["Ride"] = 999.94, ["Fly|Ride"] = 783.55, ["Neon"] = 2887.5, ["Neon|Ride"] = 3201.73, ["Neon|Fly|Ride"] = 3498.43, ["Mega|Fly|Ride"] = 10956.52}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 7.23}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 27.57, ["Fly"] = 34.13, ["Ride"] = 32.43, ["Fly|Ride"] = 73.41, ["Neon"] = 246.75, ["Neon|Ride"] = 166.68, ["Neon|Fly|Ride"] = 213.92, ["Mega"] = 2133.41, ["Mega|Ride"] = 1160.08, ["Mega|Fly|Ride"] = 762.74}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 18.27}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 4987.5, ["Ride"] = 5650.32, ["Fly|Ride"] = 4856.25, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 43502.23}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 11.46, ["Fly"] = 55.12, ["Ride"] = 19.89, ["Fly|Ride"] = 58.77, ["Neon"] = 99.59, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 711.51, ["Mega|Ride"] = 490.88, ["Mega|Fly|Ride"] = 771.75}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 15.54, ["Fly"] = 139.89, ["Ride"] = 36.66, ["Neon"] = 97.13, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1075.48, ["Mega|Ride"] = 770.2, ["Mega|Fly|Ride"] = 711.51}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 70.87, ["Fly"] = 284.87, ["Ride"] = 58.7, ["Fly|Ride"] = 90.43, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 498.75, ["Mega"] = 4266.81}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 11.46, ["Fly"] = 71.49, ["Ride"] = 25.81, ["Fly|Ride"] = 78.75, ["Neon"] = 57.64, ["Neon|Ride"] = 129.39, ["Neon|Fly|Ride"] = 501.38, ["Mega"] = 1422.99, ["Mega|Ride"] = 749.36, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1706.24, ["Fly"] = 2362.06, ["Ride"] = 1833.41, ["Fly|Ride"] = 1800.75, ["Neon|Fly|Ride"] = 3580.5, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 27562.5, ["Fly"] = 34139.8, ["Ride"] = 36748.95, ["Fly|Ride"] = 26906.25, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 73828.53, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 16.62, ["Fly"] = 393.75, ["Ride"] = 45.94, ["Fly|Ride"] = 170.71, ["Neon"] = 320.19, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 954.71, ["Mega|Ride"] = 1147.13, ["Mega|Fly|Ride"] = 1392.08}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.58, ["Fly"] = 43.31, ["Ride"] = 32.45, ["Fly|Ride"] = 158.9, ["Neon"] = 21.36, ["Neon|Fly"] = 153.56, ["Neon|Ride"] = 66.52, ["Neon|Fly|Ride"] = 142.95, ["Mega"] = 142.95, ["Mega|Ride"] = 234.92, ["Mega|Fly|Ride"] = 236.15}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 19.46}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 6.81, ["Ride"] = 36.75, ["Fly|Ride"] = 124.68, ["Neon"] = 58.46, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 401.49, ["Mega"] = 326.22, ["Mega|Ride"] = 412.02, ["Mega|Fly|Ride"] = 656.24}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 710.75, ["Ride"] = 713.29, ["Fly|Ride"] = 745.5, ["Neon"] = 2490.95, ["Neon|Ride"] = 2561.4, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 11279.17}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 790.33, ["Fly"] = 975.19, ["Ride"] = 853.4, ["Fly|Ride"] = 918.75, ["Neon"] = 4127.03, ["Neon|Ride"] = 3415.18, ["Neon|Fly|Ride"] = 2493.75, ["Mega|Fly|Ride"] = 11648.38}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 12.27, ["Fly"] = 120.89, ["Ride"] = 30.08, ["Fly|Ride"] = 71.49, ["Neon"] = 78.74, ["Neon|Ride"] = 100.91, ["Neon|Fly|Ride"] = 214.06, ["Mega"] = 1204.13, ["Mega|Ride"] = 481.68, ["Mega|Fly|Ride"] = 548.63}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 24.4}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 65.54, ["Fly"] = 128.34, ["Ride"] = 78.56, ["Fly|Ride"] = 114.58, ["Neon"] = 420, ["Neon|Ride"] = 426.91, ["Neon|Fly|Ride"] = 420, ["Mega"] = 19687.5, ["Mega|Ride"] = 2088.61, ["Mega|Fly|Ride"] = 1664.25}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 72.19, ["Ride"] = 138.47, ["Fly|Ride"] = 127.32, ["Neon"] = 420, ["Neon|Fly"] = 403.81, ["Neon|Ride"] = 409.5, ["Neon|Fly|Ride"] = 553.77, ["Mega"] = 1388.2, ["Mega|Ride"] = 1920.08, ["Mega|Fly|Ride"] = 1933.44}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 4.86, ["Fly"] = 35.44, ["Ride"] = 15.94, ["Fly|Ride"] = 42.24, ["Neon"] = 42.71, ["Neon|Fly"] = 525, ["Neon|Ride"] = 68.32, ["Neon|Fly|Ride"] = 99.05, ["Mega"] = 322.65, ["Mega|Fly|Ride"] = 540.84}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 116.94, ["Fly"] = 147.11, ["Ride"] = 132.56, ["Fly|Ride"] = 189.05, ["Neon"] = 725.81, ["Neon|Ride"] = 576.18, ["Neon|Fly|Ride"] = 538.13, ["Mega|Fly|Ride"] = 2181.18}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.74, ["Ride"] = 40.56, ["Fly|Ride"] = 140.44, ["Neon"] = 42, ["Neon|Ride"] = 87.57, ["Mega"] = 248.01, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 11.82, ["Fly"] = 41.65, ["Ride"] = 32.7, ["Fly|Ride"] = 78.66, ["Neon"] = 126.29, ["Neon|Ride"] = 121.68, ["Neon|Fly|Ride"] = 172.91, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 30.85, ["Ride"] = 60.29, ["Fly|Ride"] = 156.19, ["Neon"] = 183.75, ["Neon|Ride"] = 282.19, ["Mega"] = 918.74, ["Mega|Ride"] = 1161.57, ["Mega|Fly|Ride"] = 1114.31}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 14.53, ["Fly"] = 193.12, ["Ride"] = 35.77, ["Fly|Ride"] = 69.46, ["Neon"] = 91.88, ["Neon|Ride"] = 115.77, ["Neon|Fly|Ride"] = 143.03, ["Mega"] = 918.75, ["Mega|Fly|Ride"] = 1056.05}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 7113.19, ["Ride"] = 6555.94, ["Fly|Ride"] = 5575.5, ["Neon"] = 35575.36, ["Neon|Ride"] = 24281.25, ["Neon|Fly|Ride"] = 28303.2}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 224.59, ["Fly"] = 299.8, ["Ride"] = 247.96, ["Fly|Ride"] = 255.94, ["Neon|Fly|Ride"] = 511.67, ["Mega|Fly|Ride"] = 1893.04}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 45.29, ["Fly"] = 145.29, ["Ride"] = 91.25, ["Fly|Ride"] = 150.94, ["Neon"] = 131.25, ["Neon|Fly"] = 306.32, ["Neon|Ride"] = 151.62, ["Neon|Fly|Ride"] = 262.4, ["Mega"] = 437.07, ["Mega|Fly"] = 583.5, ["Mega|Ride"] = 419.89, ["Mega|Fly|Ride"] = 551.14}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.5, ["Fly"] = 89.46, ["Ride"] = 28.82, ["Fly|Ride"] = 50.15, ["Neon"] = 21.45, ["Neon|Fly"] = 61.92, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 194.24, ["Mega"] = 144.38, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 60.36, ["Fly"] = 5479.52, ["Ride"] = 99.56, ["Fly|Ride"] = 225.95, ["Neon"] = 196.88, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 236.24, ["Neon|Fly|Ride"] = 387.16, ["Mega"] = 539.85, ["Mega|Ride"] = 695.63, ["Mega|Fly|Ride"] = 647.73}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 14384.99, ["Ride"] = 13415.07, ["Fly|Ride"] = 11238.4, ["Neon|Fly|Ride"] = 27562.5, ["Mega|Fly|Ride"] = 113781.65}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 262.49, ["Ride"] = 315, ["Fly|Ride"] = 337.32, ["Neon"] = 1280.71, ["Neon|Ride"] = 1423.71, ["Neon|Fly|Ride"] = 1615.82, ["Mega|Fly|Ride"] = 6386.35}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 74.82, ["Fly"] = 82.91, ["Ride"] = 59.19, ["Fly|Ride"] = 129.93, ["Neon"] = 405.56, ["Neon|Ride"] = 296.13, ["Neon|Fly|Ride"] = 426.69}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 8.97, ["Ride"] = 23.77, ["Fly|Ride"] = 72.12, ["Neon"] = 67.46, ["Neon|Fly"] = 274.45, ["Neon|Ride"] = 71.76, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 360.94, ["Mega|Fly|Ride"] = 569.64}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 341.25, ["Fly"] = 528.11, ["Ride"] = 393.74, ["Fly|Ride"] = 531.57, ["Neon"] = 1568.76, ["Neon|Ride"] = 1376.76, ["Neon|Fly|Ride"] = 1707.6, ["Mega|Fly|Ride"] = 5103}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 4.75, ["Fly"] = 104.12, ["Ride"] = 41.06, ["Fly|Ride"] = 118.13, ["Neon"] = 32.66, ["Neon|Ride"] = 99.2, ["Neon|Fly|Ride"] = 195.33, ["Mega"] = 129.94, ["Mega|Fly"] = 263.92, ["Mega|Ride"] = 601.5, ["Mega|Fly|Ride"] = 247.96}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 104.08, ["Fly"] = 198.45, ["Ride"] = 118.44, ["Fly|Ride"] = 203.23, ["Neon"] = 443.62, ["Neon|Fly"] = 525, ["Neon|Ride"] = 516.04, ["Neon|Fly|Ride"] = 551.25, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.09, ["Fly"] = 19.18, ["Ride"] = 15.44, ["Fly|Ride"] = 31.05, ["Neon"] = 162.02, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 2560.09, ["Mega|Fly|Ride"] = 966.73}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 7.85}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 65.63, ["Ride"] = 85.32, ["Fly|Ride"] = 426.77, ["Neon"] = 380.84, ["Neon|Fly"] = 425.84, ["Neon|Ride"] = 408.18, ["Neon|Fly|Ride"] = 3201.73, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1849.67}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 11.79, ["Fly"] = 78.46, ["Ride"] = 32.96, ["Fly|Ride"] = 88.83, ["Neon"] = 65.63, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 569.64}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 28.74}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 43.32, ["Fly"] = 210, ["Ride"] = 112.04, ["Fly|Ride"] = 85.37, ["Neon"] = 289.24, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 1600.07, ["Mega|Fly|Ride"] = 1591.53}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.49, ["Ride"] = 29.23, ["Fly|Ride"] = 137.82, ["Neon"] = 20.79, ["Neon|Ride"] = 108.82, ["Neon|Fly|Ride"] = 284.96, ["Mega"] = 131.25, ["Mega|Ride"] = 213.42, ["Mega|Fly|Ride"] = 284.83}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 7.27, ["Fly"] = 56.42, ["Ride"] = 25.93, ["Fly|Ride"] = 81.01, ["Neon"] = 162.02, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 212.4, ["Mega|Ride"] = 650.71, ["Mega|Fly|Ride"] = 796.38}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 460.43, ["Fly"] = 569.72, ["Ride"] = 505.21, ["Fly|Ride"] = 525, ["Neon|Fly|Ride"] = 2134.5, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 35.32, ["Fly"] = 100.3, ["Ride"] = 57.59, ["Fly|Ride"] = 131.24, ["Neon"] = 175.83, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 326.21, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 1612.01}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 46.57, ["Fly"] = 119.89, ["Ride"] = 52.5, ["Fly|Ride"] = 100.23, ["Neon"] = 317.98, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 458.1, ["Mega|Fly|Ride"] = 942.98}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 13.12, ["Ride"] = 66.8, ["Fly|Ride"] = 114.17, ["Neon"] = 97.01, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 183.74, ["Mega"] = 425.63, ["Mega|Fly"] = 525, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 645.29}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 26250, ["Ride"] = 8862, ["Fly|Ride"] = 8071.88, ["Neon|Fly|Ride"] = 17705.63, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1394.43, ["Fly"] = 1486.83, ["Ride"] = 1509.36, ["Fly|Ride"] = 1378.13, ["Neon|Ride"] = 4838.88, ["Neon|Fly|Ride"] = 3896.82, ["Mega|Fly|Ride"] = 15001.88}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 596.43, ["Ride"] = 630.99, ["Fly|Ride"] = 538.13, ["Neon"] = 2589.27, ["Neon|Ride"] = 2163.31, ["Neon|Fly|Ride"] = 3201.73, ["Mega|Fly|Ride"] = 8539.74}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 11.78, ["Fly"] = 21.16, ["Ride"] = 21.94, ["Fly|Ride"] = 46.96, ["Neon"] = 68.93, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 129.94, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 569.64}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 2.24, ["Fly"] = 78.74, ["Ride"] = 26.17, ["Fly|Ride"] = 182.45, ["Neon"] = 21.29, ["Neon|Ride"] = 56, ["Mega"] = 159.47, ["Mega|Ride"] = 198.19, ["Mega|Fly|Ride"] = 259.87}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 33.66, ["Fly"] = 75.16, ["Ride"] = 38.64, ["Fly|Ride"] = 87.87, ["Neon"] = 544.05, ["Neon|Ride"] = 169.32, ["Neon|Fly|Ride"] = 217.63, ["Mega|Fly|Ride"] = 587.9}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 2.97, ["Fly"] = 20.28, ["Ride"] = 17.55, ["Fly|Ride"] = 36.45, ["Neon"] = 31.5, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 47.55, ["Neon|Fly|Ride"] = 84.96, ["Mega"] = 261.19, ["Mega|Ride"] = 455.34, ["Mega|Fly|Ride"] = 427.88}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 334.59, ["Fly"] = 369.49, ["Ride"] = 321.56, ["Fly|Ride"] = 362.15, ["Neon"] = 1565.65, ["Neon|Fly|Ride"] = 1707.6, ["Mega|Fly|Ride"] = 3654}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 18.15, ["Fly"] = 59.07, ["Ride"] = 30.94, ["Fly|Ride"] = 96.72, ["Neon"] = 208.95, ["Neon|Fly"] = 314.86, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 257.25, ["Mega"] = 810.71, ["Mega|Ride"] = 787.4, ["Mega|Fly|Ride"] = 721.77}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 6.02, ["Fly"] = 20.99, ["Ride"] = 25.62, ["Fly|Ride"] = 32.65, ["Neon"] = 143.03, ["Neon|Fly"] = 137.84, ["Neon|Ride"] = 130.45, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 425.25}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 577.86, ["Fly"] = 1048.69, ["Ride"] = 533.45, ["Fly|Ride"] = 546.25, ["Neon|Fly|Ride"] = 2419.45, ["Mega|Fly|Ride"] = 12501.72}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1263.94, ["Ride"] = 1115.61, ["Fly|Ride"] = 1384.59, ["Neon"] = 4980.83, ["Neon|Ride"] = 4695.87, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13373.33}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 123.23, ["Fly"] = 138.7, ["Ride"] = 113.73, ["Fly|Ride"] = 108.61, ["Neon"] = 971.25, ["Neon|Ride"] = 585.46, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 2557.96}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 192.08, ["Fly"] = 203.44, ["Ride"] = 189.15, ["Fly|Ride"] = 202.01, ["Neon"] = 865.54, ["Neon|Ride"] = 643.13, ["Neon|Fly|Ride"] = 565.63, ["Mega|Ride"] = 9187.5, ["Mega|Fly|Ride"] = 2820.78}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 71.49, ["Fly"] = 122.71, ["Ride"] = 53.81, ["Fly|Ride"] = 123.32, ["Neon"] = 233.88, ["Neon|Ride"] = 272.99, ["Mega|Ride"] = 1422.99, ["Mega|Fly|Ride"] = 1066.71}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 210, ["Ride"] = 128.04, ["Fly|Ride"] = 412.89, ["Neon"] = 1220.63, ["Neon|Fly"] = 967.19, ["Neon|Fly|Ride"] = 1354.06, ["Mega|Fly|Ride"] = 5120.17}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2096.09, ["Fly"] = 2296.74, ["Ride"] = 2276.72, ["Fly|Ride"] = 2231.25, ["Neon|Fly|Ride"] = 10672.4, ["Mega|Fly|Ride"] = 29807.49}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 53.79, ["Fly"] = 213.39, ["Ride"] = 51.84, ["Fly|Ride"] = 196.88, ["Neon"] = 288.75, ["Neon|Ride"] = 320.19, ["Neon|Fly|Ride"] = 343.87, ["Mega|Ride"] = 1138.18, ["Mega|Fly|Ride"] = 1450.09}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 656.15, ["Ride"] = 656.04, ["Fly|Ride"] = 654.68, ["Neon|Fly|Ride"] = 1220.63, ["Mega|Fly|Ride"] = 3412.5}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 39.29, ["Fly"] = 49.14, ["Ride"] = 45.01, ["Fly|Ride"] = 77.6, ["Neon"] = 426.91, ["Neon|Ride"] = 271.09, ["Neon|Fly|Ride"] = 236.62, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.61, ["Fly"] = 43.2, ["Ride"] = 18.12, ["Fly|Ride"] = 41.62, ["Neon"] = 26.16, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 35.05, ["Neon|Fly|Ride"] = 100.95, ["Mega"] = 169.32, ["Mega|Ride"] = 184.98, ["Mega|Fly|Ride"] = 313.27}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 40.2, ["Ride"] = 128.33, ["Fly|Ride"] = 208.05, ["Neon"] = 352.21, ["Neon|Ride"] = 384.97, ["Neon|Fly|Ride"] = 711.86, ["Mega"] = 1559.53, ["Mega|Fly|Ride"] = 1695.2}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 836.79, ["Fly"] = 910.93, ["Ride"] = 852.41, ["Fly|Ride"] = 798, ["Neon|Ride"] = 2830.04, ["Neon|Fly|Ride"] = 2690.63, ["Mega|Fly|Ride"] = 11418.75}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 721.88, ["Ride"] = 1054.1, ["Fly|Ride"] = 853.51, ["Neon|Fly|Ride"] = 4259.37, ["Mega|Fly|Ride"] = 15501.29}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 14.34, ["Fly"] = 26.25, ["Ride"] = 24.04, ["Fly|Ride"] = 38.7, ["Neon"] = 111.57, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 144.38, ["Mega|Fly|Ride"] = 845.88}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 8.33, ["Ride"] = 27.2, ["Fly|Ride"] = 114.17, ["Neon"] = 141.44, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 250.04, ["Mega"] = 662.82, ["Mega|Ride"] = 744.57, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.29, ["Ride"] = 21.74, ["Fly|Ride"] = 102.38, ["Neon"] = 19.69, ["Neon|Fly"] = 322.81, ["Neon|Ride"] = 56.16, ["Neon|Fly|Ride"] = 176.52, ["Mega"] = 129.84, ["Mega|Fly"] = 548.63, ["Mega|Ride"] = 284.83, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 28.67, ["Fly"] = 51.19, ["Ride"] = 39.11, ["Fly|Ride"] = 86.29, ["Neon"] = 242.28, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 233.03, ["Mega|Fly|Ride"] = 818.9}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 39.69, ["Ride"] = 111.57, ["Fly|Ride"] = 456.64, ["Neon"] = 428.35, ["Neon|Ride"] = 499.11, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2063.01, ["Mega|Ride"] = 1600.07, ["Mega|Fly|Ride"] = 1564.87}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 11.5, ["Fly"] = 43.3, ["Ride"] = 35.44, ["Fly|Ride"] = 89.13, ["Neon"] = 101.4, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 149.43, ["Mega"] = 638.97, ["Mega|Ride"] = 375.48, ["Mega|Fly|Ride"] = 459.37}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 33.31, ["Fly"] = 59.04, ["Ride"] = 41.15, ["Fly|Ride"] = 66.83, ["Neon"] = 242.71, ["Neon|Fly"] = 1423.71, ["Neon|Ride"] = 196.27, ["Neon|Fly|Ride"] = 215.25, ["Mega"] = 2100, ["Mega|Ride"] = 1066.71, ["Mega|Fly|Ride"] = 853.12}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 2.57, ["Fly"] = 38.07, ["Ride"] = 18.01, ["Fly|Ride"] = 41.91, ["Neon"] = 29.54, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 91.74, ["Mega"] = 736.32, ["Mega|Ride"] = 356.29, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.72, ["Fly"] = 46.89, ["Ride"] = 33.01, ["Fly|Ride"] = 65.63, ["Neon"] = 51.83, ["Neon|Fly"] = 114.19, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 249.75, ["Mega"] = 318.96, ["Mega|Ride"] = 339.29, ["Mega|Fly|Ride"] = 479.06}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 50.68, ["Fly"] = 65.63, ["Ride"] = 53.8, ["Fly|Ride"] = 94.79, ["Neon"] = 419.53, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 259.88, ["Mega|Fly|Ride"] = 1074.91}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1575, ["Fly"] = 1575, ["Ride"] = 1422.81, ["Fly|Ride"] = 1476.57, ["Neon|Fly|Ride"] = 3863.97, ["Mega|Fly|Ride"] = 18373.69}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 461.98, ["Fly"] = 505.08, ["Ride"] = 446.25, ["Fly|Ride"] = 511.77, ["Neon|Fly|Ride"] = 2817.53}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 272.86, ["Ride"] = 328.13, ["Fly|Ride"] = 433.13, ["Neon"] = 1207.5, ["Neon|Ride"] = 1565.65, ["Neon|Fly|Ride"] = 1693.72, ["Mega|Fly|Ride"] = 7644}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 39.16}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 25.2, ["Fly"] = 131.25, ["Ride"] = 47.16, ["Fly|Ride"] = 97.12, ["Neon"] = 327.66, ["Neon|Fly"] = 426.91, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 354.38, ["Mega|Ride"] = 1563.79, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 34141.5, ["Fly"] = 65625, ["Ride"] = 35437.5, ["Fly|Ride"] = 17979.94, ["Neon|Fly|Ride"] = 35437.49, ["Mega"] = 213339.9, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 255.12, ["Fly"] = 356.35, ["Ride"] = 282.54, ["Fly|Ride"] = 346.94, ["Neon"] = 1050, ["Neon|Fly"] = 1129.21, ["Neon|Ride"] = 891.45, ["Neon|Fly|Ride"] = 1036.87, ["Mega"] = 4266.81, ["Mega|Ride"] = 4265.75, ["Mega|Fly|Ride"] = 3299.71}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 210.58, ["Fly"] = 525, ["Ride"] = 213.39, ["Fly|Ride"] = 203.44, ["Neon|Fly|Ride"] = 1773.58}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 123.19, ["Fly"] = 982.8, ["Ride"] = 157.49, ["Fly|Ride"] = 252.83, ["Neon|Ride"] = 837.85, ["Neon|Fly|Ride"] = 656.7, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 14.22, ["Fly"] = 94.5, ["Ride"] = 30.19, ["Fly|Ride"] = 126, ["Neon|Ride"] = 84.65, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 722.64, ["Mega|Ride"] = 711.51, ["Mega|Fly|Ride"] = 775.5}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3675, ["Ride"] = 3688.13, ["Fly|Ride"] = 5115.66, ["Neon"] = 27748.24, ["Neon|Fly|Ride"] = 17210.15}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 23.78, ["Fly"] = 64.04, ["Ride"] = 26.06, ["Fly|Ride"] = 48.09, ["Neon|Ride"] = 343.88, ["Neon|Fly|Ride"] = 322.65, ["Mega|Fly|Ride"] = 731.77}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 43.87, ["Fly"] = 106.51, ["Ride"] = 55.63, ["Fly|Ride"] = 89.99, ["Neon"] = 414.11, ["Neon|Fly"] = 1423.71, ["Neon|Ride"] = 204.75, ["Neon|Fly|Ride"] = 248.07, ["Mega|Fly|Ride"] = 1372.88}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 602.44, ["Ride"] = 743.31, ["Fly|Ride"] = 896.23, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 2134.5, ["Mega|Fly|Ride"] = 8370.42}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 9.85, ["Fly"] = 26.16, ["Ride"] = 27.2, ["Fly|Ride"] = 39.17, ["Neon"] = 118.12, ["Neon|Fly"] = 161.18, ["Neon|Ride"] = 128.16, ["Neon|Fly|Ride"] = 166.34, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 9.17, ["Ride"] = 27.57, ["Fly|Ride"] = 80, ["Neon"] = 95.82, ["Neon|Ride"] = 120.91, ["Neon|Fly|Ride"] = 209.09, ["Mega|Ride"] = 832.04}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 101.99, ["Ride"] = 128.63, ["Fly|Ride"] = 156.19, ["Neon"] = 1010.63, ["Neon|Ride"] = 783.38, ["Neon|Fly|Ride"] = 839.93, ["Mega|Fly|Ride"] = 2739.19}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 15.73, ["Fly"] = 42.88, ["Ride"] = 62.91, ["Fly|Ride"] = 131.24, ["Neon"] = 60.94, ["Neon|Fly"] = 96.73, ["Neon|Ride"] = 96.56, ["Neon|Fly|Ride"] = 234.78, ["Mega"] = 332.07, ["Mega|Fly"] = 730.28, ["Mega|Ride"] = 278.25, ["Mega|Fly|Ride"] = 425.81}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3930.83, ["Fly"] = 6285.8, ["Ride"] = 3883.66, ["Fly|Ride"] = 4134.38, ["Neon"] = 19687.5, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 9842.44, ["Mega"] = 37334.5, ["Mega|Fly|Ride"] = 36735.21}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 30.86, ["Fly"] = 142.97, ["Ride"] = 77.49, ["Fly|Ride"] = 129.35, ["Neon"] = 399.16, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 574.23, ["Mega"] = 782.98, ["Mega|Ride"] = 1772.73, ["Mega|Fly|Ride"] = 782.23}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7271.25, ["Fly"] = 8819.82, ["Ride"] = 6857.82, ["Fly|Ride"] = 7008.65, ["Neon|Fly|Ride"] = 17696.44, ["Mega|Fly|Ride"] = 66059.33}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.02, ["Fly"] = 23.24, ["Ride"] = 15.31, ["Fly|Ride"] = 32.82, ["Neon"] = 24.61, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 222.36, ["Mega|Ride"] = 372.75, ["Mega|Fly|Ride"] = 358.43}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 13.99, ["Fly"] = 38.19, ["Ride"] = 32.47, ["Fly|Ride"] = 48.37, ["Neon"] = 185.71, ["Neon|Fly"] = 235.87, ["Neon|Ride"] = 106.74, ["Neon|Fly|Ride"] = 159.73, ["Mega|Ride"] = 978.48, ["Mega|Fly|Ride"] = 935.82}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.68}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 10.77, ["Ride"] = 33.91, ["Fly|Ride"] = 116.02, ["Neon"] = 113.66, ["Neon|Ride"] = 139.13, ["Neon|Fly|Ride"] = 322.32, ["Mega"] = 1049.9, ["Mega|Ride"] = 894.97, ["Mega|Fly|Ride"] = 1248.6}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 28.88, ["Fly"] = 190.37, ["Ride"] = 70.7, ["Fly|Ride"] = 99.73, ["Neon"] = 157.97, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 323.23, ["Mega"] = 945, ["Mega|Ride"] = 853.37, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 12.62, ["Fly"] = 21.21, ["Ride"] = 20.9, ["Fly|Ride"] = 34.86, ["Neon|Ride"] = 114.21, ["Neon|Fly|Ride"] = 178.5, ["Mega"] = 2560.09, ["Mega|Ride"] = 603, ["Mega|Fly|Ride"] = 531.57}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8678.36}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.99}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 20.9}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 233, ["Ride"] = 356.35, ["Fly|Ride"] = 259.88, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 13.82, ["Fly"] = 135.51, ["Ride"] = 35.57, ["Fly|Ride"] = 128.15, ["Neon"] = 186.79, ["Neon|Ride"] = 116.81, ["Neon|Fly|Ride"] = 265.13, ["Mega"] = 525, ["Mega|Ride"] = 531.57, ["Mega|Fly|Ride"] = 996.32}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 10.84}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 10.07, ["Ride"] = 30.96, ["Fly|Ride"] = 85.37, ["Neon|Ride"] = 249.38}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 3547.07}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 177.27, ["Fly"] = 426.77, ["Ride"] = 211.31, ["Fly|Ride"] = 497.17, ["Neon"] = 925.32, ["Neon|Ride"] = 918.75, ["Mega|Ride"] = 4124.94, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 76.01, ["Ride"] = 106.71, ["Fly|Ride"] = 213.39, ["Neon"] = 783.38, ["Neon|Ride"] = 547.78, ["Neon|Fly|Ride"] = 1435.35, ["Mega|Ride"] = 2133.41, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 152.64, ["Fly"] = 314.99, ["Ride"] = 211.19, ["Fly|Ride"] = 208.74, ["Neon"] = 1066.19, ["Neon|Ride"] = 787.4, ["Neon|Fly|Ride"] = 840, ["Mega|Fly|Ride"] = 4777.5}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2388.74, ["Fly"] = 2362.5, ["Ride"] = 2014.03, ["Fly|Ride"] = 2270.63, ["Neon"] = 14990.46, ["Neon|Ride"] = 8878.38, ["Neon|Fly|Ride"] = 7115.3, ["Mega|Fly|Ride"] = 20868.75}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 15.65, ["Fly"] = 105.63, ["Ride"] = 32.71, ["Fly|Ride"] = 99.75, ["Neon"] = 127.32, ["Neon|Ride"] = 154.62, ["Neon|Fly|Ride"] = 199.48, ["Mega"] = 958.98, ["Mega|Ride"] = 1047.69, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 615.96, ["Fly"] = 2100, ["Ride"] = 721.88, ["Fly|Ride"] = 774.38, ["Neon|Ride"] = 3273.24, ["Neon|Fly|Ride"] = 4189.52, ["Mega|Fly|Ride"] = 16917.54}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 40.61}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 13.13, ["Ride"] = 51.86, ["Fly|Ride"] = 471.93, ["Neon"] = 81.29, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 106.5, ["Neon|Fly|Ride"] = 256.15, ["Mega"] = 431.19, ["Mega|Ride"] = 484.31, ["Mega|Fly|Ride"] = 506.33}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 6.42, ["Fly"] = 28.82, ["Ride"] = 27.56, ["Fly|Ride"] = 105.63, ["Neon"] = 39.38, ["Neon|Ride"] = 62.98, ["Neon|Fly|Ride"] = 205.76, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 398.95}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 52.48}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 16.2, ["Fly"] = 108.92, ["Ride"] = 31.44, ["Fly|Ride"] = 83.23, ["Neon"] = 96.73, ["Neon|Ride"] = 170.78, ["Neon|Fly|Ride"] = 254.63, ["Mega|Ride"] = 853.37, ["Mega|Fly|Ride"] = 2257.29}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 26.25, ["Fly"] = 52.5, ["Ride"] = 39.29, ["Fly|Ride"] = 52.41, ["Neon|Ride"] = 512.61, ["Neon|Fly|Ride"] = 323.39, ["Mega|Ride"] = 1812.61, ["Mega|Fly|Ride"] = 989.63}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6037.49, ["Fly"] = 10237.5, ["Ride"] = 6614.6, ["Fly|Ride"] = 5105.62, ["Neon|Fly|Ride"] = 12468.75, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 8.4, ["Fly"] = 65.63, ["Ride"] = 34.12, ["Fly|Ride"] = 81.37, ["Neon"] = 45.02, ["Neon|Fly"] = 143.03, ["Neon|Ride"] = 81.02, ["Neon|Fly|Ride"] = 226.09, ["Mega"] = 541.38, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 483.16}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 23.24}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 87.29, ["Fly"] = 377.69, ["Ride"] = 132.59, ["Fly|Ride"] = 183.75, ["Neon"] = 525, ["Neon|Ride"] = 455.44, ["Neon|Fly|Ride"] = 714.52, ["Mega|Fly|Ride"] = 2142.38}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 32.37, ["Fly"] = 140.91, ["Ride"] = 85.79, ["Fly|Ride"] = 163.68, ["Neon"] = 257.25, ["Neon|Ride"] = 272.37, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2416.81, ["Mega|Ride"] = 2880.1, ["Mega|Fly|Ride"] = 1200.94}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 18.47, ["Fly"] = 70.47, ["Ride"] = 27.2, ["Fly|Ride"] = 65.62, ["Neon"] = 116.82, ["Neon|Ride"] = 142.96, ["Neon|Fly|Ride"] = 196.67, ["Mega|Ride"] = 825.64, ["Mega|Fly|Ride"] = 777}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 3.89, ["Fly"] = 65.54, ["Ride"] = 22.65, ["Fly|Ride"] = 87.49, ["Neon"] = 31.5, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 52.41, ["Neon|Fly|Ride"] = 112.88, ["Mega"] = 180.65, ["Mega|Fly"] = 7015.19, ["Mega|Ride"] = 181.55, ["Mega|Fly|Ride"] = 285.05}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 11.22, ["Ride"] = 27.99, ["Fly|Ride"] = 94.5, ["Neon"] = 87.85, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 198.19, ["Mega|Ride"] = 645.29, ["Mega|Fly|Ride"] = 776.57}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 16.65, ["Fly"] = 26.17, ["Ride"] = 22.91, ["Fly|Ride"] = 41.56, ["Neon"] = 370.35, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 144.37}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 195.57}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 19.32, ["Ride"] = 131.21, ["Fly|Ride"] = 284.87, ["Neon"] = 170.63, ["Neon|Ride"] = 262.5, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 250.22, ["Ride"] = 443.63, ["Fly|Ride"] = 3839.68, ["Neon|Fly|Ride"] = 28460.09}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 44.61, ["Fly"] = 212.42, ["Ride"] = 78.17, ["Fly|Ride"] = 235.8, ["Neon"] = 284.29, ["Neon|Ride"] = 295.32, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 1035.57, ["Mega|Ride"] = 971.25, ["Mega|Fly|Ride"] = 1101.71}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 918.65, ["Fly"] = 1351.73, ["Ride"] = 1007.98, ["Fly|Ride"] = 1036.88, ["Neon|Fly"] = 4183.07, ["Neon|Ride"] = 4191.53, ["Neon|Fly|Ride"] = 3589.89, ["Mega|Fly|Ride"] = 11746.87}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 388.49, ["Fly"] = 711.61, ["Ride"] = 413.21, ["Fly|Ride"] = 564.38, ["Neon"] = 2139.38, ["Neon|Ride"] = 2417.97, ["Neon|Fly|Ride"] = 2554.98, ["Mega"] = 12800.41, ["Mega|Fly|Ride"] = 8990.63}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 65.54}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 3.94}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 8.56, ["Fly"] = 20.75, ["Ride"] = 23.79, ["Fly|Ride"] = 45.71, ["Neon"] = 78.75, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 82.43, ["Neon|Fly|Ride"] = 143.05, ["Mega"] = 437.26, ["Mega|Ride"] = 711.51, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 248.27, ["Fly"] = 392.03, ["Ride"] = 275.47, ["Fly|Ride"] = 350.43, ["Neon"] = 1129.15, ["Neon|Ride"] = 1069.69, ["Neon|Fly|Ride"] = 1063.37, ["Mega|Fly|Ride"] = 3391.05}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 14.6}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 115.4, ["Ride"] = 169.32, ["Fly|Ride"] = 259.88, ["Neon"] = 656.25, ["Neon|Ride"] = 639.32, ["Neon|Fly|Ride"] = 728.34, ["Mega|Ride"] = 3129.72, ["Mega|Fly|Ride"] = 3515.86}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 127.32, ["Ride"] = 128.76, ["Fly|Ride"] = 213.39, ["Neon"] = 853.81, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 2347.94, ["Neon|Fly|Ride"] = 913.5, ["Mega|Fly|Ride"] = 2560.09}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 3.5, ["Ride"] = 26.25, ["Fly|Ride"] = 173.92, ["Neon"] = 26.18, ["Neon|Ride"] = 87.06, ["Neon|Fly|Ride"] = 170.78, ["Mega"] = 264.75, ["Mega|Ride"] = 284.83, ["Mega|Fly|Ride"] = 852.31}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 13.27, ["Fly"] = 64.03, ["Ride"] = 27.13, ["Fly|Ride"] = 77.05, ["Neon"] = 177.19, ["Neon|Ride"] = 113.66, ["Neon|Fly|Ride"] = 322.65, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 12.57, ["Fly"] = 102.35, ["Ride"] = 33.75, ["Fly|Ride"] = 104.7, ["Neon"] = 78.75, ["Neon|Ride"] = 101.06, ["Neon|Fly|Ride"] = 256.57, ["Mega"] = 498.75, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 3.82, ["Fly"] = 98.07, ["Ride"] = 38.66, ["Fly|Ride"] = 154.98, ["Neon"] = 22.32, ["Neon|Ride"] = 69.78, ["Neon|Fly|Ride"] = 154.88, ["Mega"] = 136.48, ["Mega|Ride"] = 181.83, ["Mega|Fly|Ride"] = 288.7}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 249.38, ["Ride"] = 290.05, ["Fly|Ride"] = 359.52, ["Neon"] = 1592.34, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 5632.18}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 123.78, ["Fly"] = 328.81, ["Ride"] = 136.5, ["Fly|Ride"] = 241.49, ["Neon"] = 488.25, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 628.69, ["Mega|Fly|Ride"] = 2844.91}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 45.87, ["Fly"] = 167.45, ["Ride"] = 72.19, ["Fly|Ride"] = 128.04, ["Neon"] = 380.63, ["Neon|Ride"] = 461.06, ["Neon|Fly|Ride"] = 416.07, ["Mega|Fly|Ride"] = 1801.13}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 14.97, ["Fly"] = 78.75, ["Ride"] = 58.24, ["Fly|Ride"] = 284.87, ["Neon"] = 115.5, ["Neon|Ride"] = 614.18, ["Neon|Fly|Ride"] = 498.42, ["Mega|Fly|Ride"] = 1992.61}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 14.15, ["Fly"] = 42.7, ["Ride"] = 26.06, ["Fly|Ride"] = 75.77, ["Neon"] = 94.4, ["Neon|Ride"] = 109.01, ["Neon|Fly|Ride"] = 192.24, ["Mega"] = 371.44, ["Mega|Fly"] = 525, ["Mega|Ride"] = 483.37, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 2.35, ["Fly"] = 43.32, ["Ride"] = 19.69, ["Fly|Ride"] = 47.36, ["Neon"] = 18.38, ["Neon|Fly"] = 67.6, ["Neon|Ride"] = 49.98, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 128.62, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 246.23}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 1037.26, ["Fly"] = 1060.4, ["Ride"] = 883.32, ["Fly|Ride"] = 890.84, ["Neon"] = 3559.26, ["Neon|Fly"] = 3305.36, ["Neon|Ride"] = 5250, ["Neon|Fly|Ride"] = 2624.99, ["Mega|Fly|Ride"] = 10879.29}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 371.16, ["Ride"] = 393.75, ["Fly|Ride"] = 522.22, ["Neon"] = 1277.38, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1679.85, ["Mega"] = 10667.01, ["Mega|Fly|Ride"] = 5972.46}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 63.67, ["Fly"] = 170.71, ["Ride"] = 103.64, ["Fly|Ride"] = 196.88, ["Neon"] = 327.66, ["Neon|Ride"] = 326.31, ["Neon|Fly|Ride"] = 512.29, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 1692.87}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 209.9, ["Fly"] = 283.5, ["Ride"] = 194.64, ["Fly|Ride"] = 262.4, ["Neon|Fly|Ride"] = 1094.62, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 18.52, ["Fly"] = 52.5, ["Ride"] = 23.29, ["Fly|Ride"] = 71.47, ["Neon"] = 157.5, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 236.25, ["Mega|Ride"] = 569.64, ["Mega|Fly|Ride"] = 806.02}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 236.25, ["Ride"] = 255.68, ["Fly|Ride"] = 616.77, ["Neon"] = 732.75, ["Neon|Ride"] = 942.27, ["Neon|Fly|Ride"] = 971.25, ["Mega"] = 4173.65, ["Mega|Ride"] = 4693.49, ["Mega|Fly|Ride"] = 4308.42}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 61.37, ["Fly"] = 125.98, ["Ride"] = 77.6, ["Fly|Ride"] = 106.46, ["Neon|Ride"] = 569.92, ["Neon|Fly|Ride"] = 569.92, ["Mega|Fly|Ride"] = 1732.5}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1967.44, ["Ride"] = 2100, ["Fly|Ride"] = 2021.14, ["Neon|Ride"] = 11284.6, ["Neon|Fly|Ride"] = 7612.5, ["Mega"] = 51201.59, ["Mega|Fly|Ride"] = 24890.38}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 11, ["Fly"] = 77.05, ["Ride"] = 39.16, ["Fly|Ride"] = 51.45, ["Neon"] = 64.32, ["Neon|Fly"] = 143.03, ["Neon|Ride"] = 95.37, ["Neon|Fly|Ride"] = 203.86, ["Mega"] = 494.82, ["Mega|Fly"] = 561.43, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 459.37}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 53.05, ["Ride"] = 72.18, ["Fly|Ride"] = 105, ["Neon"] = 223.13, ["Neon|Ride"] = 371.17, ["Neon|Fly|Ride"] = 645.29, ["Mega"] = 1691.76, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 78.65, ["Fly"] = 82.85, ["Ride"] = 69.76, ["Fly|Ride"] = 78.74, ["Neon"] = 525, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1879.8}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2133.86, ["Fly"] = 1612.55, ["Ride"] = 1069.68, ["Fly|Ride"] = 1168.13, ["Neon|Ride"] = 5158.72, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 482.26, ["Fly"] = 525, ["Ride"] = 669.68, ["Fly|Ride"] = 616.88, ["Neon|Fly|Ride"] = 3222.8}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 68.03, ["Fly"] = 322.76, ["Ride"] = 87.88, ["Fly|Ride"] = 196.88, ["Neon"] = 445.6, ["Neon|Ride"] = 393.73, ["Neon|Fly|Ride"] = 459.38, ["Mega|Ride"] = 2703.03, ["Mega|Fly|Ride"] = 3557.46}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 8.48, ["Ride"] = 21.27, ["Fly|Ride"] = 61.53, ["Neon"] = 69.16, ["Neon|Fly"] = 143.03, ["Neon|Ride"] = 70.54, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 603.75, ["Mega|Ride"] = 772.3}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 41.18, ["Fly"] = 68.25, ["Ride"] = 54.57, ["Fly|Ride"] = 106.71, ["Neon"] = 213.46, ["Neon|Fly"] = 341.53, ["Neon|Ride"] = 221.26, ["Neon|Fly|Ride"] = 236.24, ["Mega"] = 1706.25, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 748.13, ["Fly"] = 1112.11, ["Ride"] = 759.94, ["Fly|Ride"] = 832.1, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2184.27, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 706.13}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 5236.88, ["Ride"] = 4364.07, ["Fly|Ride"] = 5974.47, ["Neon"] = 42000, ["Neon|Ride"] = 30588.15, ["Neon|Fly|Ride"] = 17584.88, ["Mega|Fly|Ride"] = 91025.74}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 274.16, ["Fly"] = 400.09, ["Neon"] = 1707.6, ["Neon|Fly|Ride"] = 2231.25, ["Mega"] = 6400.21, ["Mega|Fly|Ride"] = 6767.02}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 70.76, ["Fly"] = 284.87, ["Ride"] = 121.96, ["Fly|Ride"] = 336, ["Neon"] = 640.36, ["Neon|Ride"] = 569.92, ["Neon|Fly|Ride"] = 640.36, ["Mega|Fly|Ride"] = 2166.31}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 15.54, ["Fly"] = 42.09, ["Ride"] = 29.93, ["Fly|Ride"] = 88.86, ["Neon"] = 152.24, ["Neon|Fly"] = 1289.99, ["Neon|Ride"] = 125.9, ["Neon|Fly|Ride"] = 181.36, ["Mega"] = 994.18, ["Mega|Ride"] = 853.37, ["Mega|Fly|Ride"] = 818.18}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 9.86, ["Fly"] = 34.16, ["Ride"] = 19.69, ["Fly|Ride"] = 46.22, ["Neon"] = 213.39, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2133.41}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 19.69, ["Ride"] = 27.28, ["Fly|Ride"] = 121.21, ["Neon"] = 106.6, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 233.63, ["Mega"] = 645.75, ["Mega|Ride"] = 658.88, ["Mega|Fly|Ride"] = 626.07}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.69, ["Fly"] = 78.96, ["Ride"] = 22.23, ["Fly|Ride"] = 48.47, ["Neon"] = 35.44, ["Neon|Ride"] = 56.11, ["Neon|Fly|Ride"] = 113.66, ["Mega"] = 322.16, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 284.83}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 23.54, ["Fly"] = 90.57, ["Ride"] = 39.37, ["Fly|Ride"] = 139.13, ["Neon"] = 157.5, ["Neon|Fly"] = 853.81, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 426.91, ["Mega"] = 610.14, ["Mega|Ride"] = 1260}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 456.65, ["Fly"] = 465.94, ["Ride"] = 452.5, ["Fly|Ride"] = 523.27, ["Neon"] = 1598.73, ["Neon|Ride"] = 1530.43, ["Neon|Fly|Ride"] = 1378.13, ["Mega"] = 7875, ["Mega|Fly|Ride"] = 12083.96}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.48, ["Fly"] = 19.56, ["Ride"] = 16.69, ["Fly|Ride"] = 24.2, ["Neon"] = 19.35, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 70.35, ["Mega"] = 853.37, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 35.6, ["Fly"] = 84.09, ["Ride"] = 70.49, ["Fly|Ride"] = 129.94, ["Neon"] = 183.71, ["Neon|Fly"] = 333.15, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 491.55, ["Mega|Ride"] = 622.55, ["Mega|Fly|Ride"] = 577.4}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 787.5, ["Fly"] = 1051.67, ["Ride"] = 703.6, ["Fly|Ride"] = 756.3, ["Neon|Ride"] = 1988.23, ["Neon|Fly|Ride"] = 1704.91, ["Mega|Fly|Ride"] = 3936.19}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 31.49, ["Fly"] = 57.36, ["Ride"] = 43.59, ["Fly|Ride"] = 78.06, ["Neon|Ride"] = 188.89, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 851.8}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 351.82, ["Fly"] = 388.45, ["Ride"] = 290.76, ["Fly|Ride"] = 401.35, ["Neon|Ride"] = 1850.61, ["Neon|Fly|Ride"] = 1280.71}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 181.91, ["Fly"] = 176.69, ["Ride"] = 196.87, ["Fly|Ride"] = 207.41, ["Neon"] = 640.36, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 853.37, ["Mega"] = 4326, ["Mega|Fly|Ride"] = 3542.53}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 834.74, ["Ride"] = 754.69, ["Fly|Ride"] = 786.19, ["Neon|Fly|Ride"] = 3039.39, ["Mega|Fly|Ride"] = 7611.19}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 19.13, ["Fly"] = 85.37, ["Ride"] = 21.41, ["Fly|Ride"] = 110.25, ["Neon"] = 106.74, ["Neon|Fly"] = 290.17, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 185.62, ["Mega"] = 354.38, ["Mega|Ride"] = 371.93, ["Mega|Fly|Ride"] = 462.96}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4084.49, ["Fly"] = 3302.99, ["Ride"] = 3936.19, ["Fly|Ride"] = 3349.5, ["Neon"] = 14230.58, ["Neon|Fly|Ride"] = 7350, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 117.06, ["Fly"] = 171.42, ["Ride"] = 138.56, ["Fly|Ride"] = 162, ["Neon"] = 433.13, ["Neon|Fly"] = 711.38, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 577.5, ["Mega|Fly|Ride"] = 2346.75}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.19, ["Fly"] = 27.76, ["Ride"] = 20.28, ["Fly|Ride"] = 38.14, ["Neon"] = 19.81, ["Neon|Fly"] = 65.62, ["Neon|Ride"] = 35.35, ["Neon|Fly|Ride"] = 85.22, ["Mega"] = 212.28, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 370.16, ["Mega|Fly|Ride"] = 227.07}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.61, ["Ride"] = 24.56, ["Fly|Ride"] = 57.71, ["Neon"] = 20.58, ["Neon|Fly"] = 118.49, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 161.94, ["Mega"] = 158.45, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 361.59}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 34.76, ["Fly"] = 85.37, ["Ride"] = 42.87, ["Fly|Ride"] = 56.34, ["Neon|Fly|Ride"] = 301.88, ["Mega|Fly|Ride"] = 1066.71}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 974.31, ["Ride"] = 1173.57, ["Fly|Ride"] = 1181.25}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6448.57, ["Ride"] = 7397.69, ["Fly|Ride"] = 6431.25}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 20.08, ["Fly"] = 36.29, ["Ride"] = 25.78, ["Fly|Ride"] = 41.89, ["Neon"] = 452.13, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 167.23, ["Mega"] = 2520, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 9.69, ["Fly"] = 57.63, ["Ride"] = 28.59, ["Fly|Ride"] = 75.8, ["Neon"] = 89.25, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 107.63, ["Neon|Fly|Ride"] = 185.71, ["Mega"] = 931.25, ["Mega|Ride"] = 554.7, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 68.06, ["Fly"] = 157.5, ["Ride"] = 78.74, ["Fly|Ride"] = 123.22, ["Neon"] = 426.91, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 402.7, ["Mega|Fly|Ride"] = 1890.2}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 267.75, ["Ride"] = 212.96, ["Fly|Ride"] = 271.9, ["Neon|Ride"] = 996.81, ["Neon|Fly|Ride"] = 984.38, ["Mega|Fly|Ride"] = 4513.37}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.36, ["Ride"] = 32.78, ["Fly|Ride"] = 93.09, ["Neon"] = 19.84, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 49.53, ["Neon|Fly|Ride"] = 81.02, ["Mega"] = 151.5, ["Mega|Fly"] = 228.68, ["Mega|Ride"] = 191.22, ["Mega|Fly|Ride"] = 1420.86}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 192.84, ["Ride"] = 209.27, ["Fly|Ride"] = 288.73, ["Neon"] = 1169.44, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1612.79, ["Mega"] = 3270.51, ["Mega|Fly|Ride"] = 3542.53}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.49, ["Fly"] = 42.7, ["Ride"] = 14.86, ["Fly|Ride"] = 56.83, ["Neon"] = 22.91, ["Neon|Fly"] = 128.09, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 104.5, ["Mega"] = 225.75, ["Mega|Ride"] = 223.12, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 208.57, ["Fly"] = 284.87, ["Ride"] = 216.57, ["Fly|Ride"] = 236.24, ["Neon|Ride"] = 1209, ["Neon|Fly|Ride"] = 986.55, ["Mega"] = 10667.01, ["Mega|Ride"] = 4978.31, ["Mega|Fly|Ride"] = 4978.31}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 9.68, ["Fly"] = 75.89, ["Ride"] = 28.27, ["Fly|Ride"] = 68.25, ["Neon"] = 73.5, ["Neon|Fly"] = 307.1, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 115.66, ["Mega"] = 498.17, ["Mega|Ride"] = 540.84, ["Mega|Fly|Ride"] = 498.17}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 3.91, ["Ride"] = 21.36, ["Fly|Ride"] = 72.1, ["Neon"] = 7.6, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 195.56, ["Mega"] = 70.88, ["Mega|Ride"] = 105.39, ["Mega|Fly|Ride"] = 217.88}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.73, ["Mega"] = 15.93, ["Mega|Ride"] = 142.61, ["Mega|Fly|Ride"] = 320.02}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 31.25, ["Fly|Ride"] = 109.91, ["Neon"] = 5.92, ["Neon|Ride"] = 27.76, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 73.49, ["Mega|Fly"] = 161120.13, ["Mega|Ride"] = 92.6, ["Mega|Fly|Ride"] = 202.13}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 114.18, ["Fly"] = 149.97, ["Ride"] = 112.25, ["Fly|Ride"] = 196.26, ["Neon"] = 278.36, ["Neon|Fly"] = 405.56, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 368.8, ["Mega|Fly|Ride"] = 1226.28}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 35.07, ["Ride"] = 15.73, ["Fly|Ride"] = 113.1, ["Neon"] = 9.16, ["Neon|Ride"] = 28.84, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 96.68, ["Mega|Ride"] = 165.38, ["Mega|Fly|Ride"] = 261.44}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 6.57, ["Neon"] = 78.61, ["Neon|Ride"] = 213.46, ["Neon|Fly|Ride"] = 223.11, ["Mega"] = 393.74, ["Mega|Ride"] = 552.56}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 1.79, ["Ride"] = 28.82, ["Neon"] = 2.5, ["Neon|Ride"] = 52.36, ["Neon|Fly|Ride"] = 277.32, ["Mega"] = 16.75, ["Mega|Fly"] = 142.95, ["Mega|Ride"] = 49.38, ["Mega|Fly|Ride"] = 322.02}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 1.79, ["Fly"] = 64.31, ["Ride"] = 15.74, ["Fly|Ride"] = 36.29, ["Neon"] = 2.1, ["Neon|Fly"] = 26.22, ["Neon|Ride"] = 15.54, ["Neon|Fly|Ride"] = 28.88, ["Mega"] = 11.96, ["Mega|Fly"] = 42.69, ["Mega|Ride"] = 19.25, ["Mega|Fly|Ride"] = 64.32}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 18.15, ["Ride"] = 15.15, ["Fly|Ride"] = 64.79, ["Neon"] = 2.1, ["Neon|Fly"] = 38.1, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 39.16, ["Mega"] = 28.87, ["Mega|Fly"] = 161.94, ["Mega|Ride"] = 30.56, ["Mega|Fly|Ride"] = 87.93}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.61, ["Neon|Ride"] = 68.25, ["Mega"] = 20.83, ["Mega|Ride"] = 100.28}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 91.85, ["Ride"] = 31.44, ["Fly|Ride"] = 107.61, ["Neon"] = 6.46, ["Neon|Fly"] = 167.99, ["Neon|Ride"] = 20.66, ["Neon|Fly|Ride"] = 81.38, ["Mega"] = 24.71, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 42.88, ["Mega|Fly|Ride"] = 95.42}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 82.09, ["Neon|Fly|Ride"] = 426.91, ["Mega"] = 14.35, ["Mega|Fly"] = 138.69, ["Mega|Ride"] = 806.02, ["Mega|Fly|Ride"] = 213.35}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 71.49, ["Ride"] = 32.79, ["Fly|Ride"] = 47.78, ["Neon"] = 16.7, ["Neon|Fly"] = 69.28, ["Neon|Ride"] = 45.92, ["Neon|Fly|Ride"] = 120.91, ["Mega"] = 114.33, ["Mega|Fly"] = 284.83, ["Mega|Ride"] = 123.38, ["Mega|Fly|Ride"] = 196.76}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 27.76, ["Neon"] = 2.34, ["Neon|Ride"] = 77.87, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 14.58, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 179.23}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Ride"] = 144.04, ["Fly|Ride"] = 525, ["Neon"] = 18.12, ["Mega"] = 162.74, ["Mega|Fly"] = 315, ["Mega|Ride"] = 284.83, ["Mega|Fly|Ride"] = 552.56}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 27.79, ["Neon"] = 16.92, ["Mega"] = 104.99, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 569.64}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.62, ["Ride"] = 32.8, ["Neon"] = 3.93, ["Neon|Ride"] = 27.34, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 19.47, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 131.23}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 14.11, ["Fly|Ride"] = 40.69, ["Neon"] = 2.1, ["Neon|Fly"] = 35.32, ["Neon|Ride"] = 15.6, ["Neon|Fly|Ride"] = 32.86, ["Mega"] = 13.86, ["Mega|Fly"] = 28.92, ["Mega|Ride"] = 18.65, ["Mega|Fly|Ride"] = 50.68}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 229.68, ["Fly|Ride"] = 118.11, ["Neon"] = 37.41, ["Neon|Ride"] = 45.94, ["Mega"] = 170.69, ["Mega|Ride"] = 240.19}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 27.01, ["Neon"] = 3.62, ["Neon|Ride"] = 28.76, ["Neon|Fly|Ride"] = 105, ["Mega"] = 38.69, ["Mega|Ride"] = 45.85, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.92, ["Neon"] = 15.33, ["Neon|Fly|Ride"] = 142.95, ["Mega"] = 85.67, ["Mega|Ride"] = 162.16, ["Mega|Fly|Ride"] = 240.02}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.51, ["Fly"] = 65.63, ["Ride"] = 46.96, ["Fly|Ride"] = 194.19, ["Neon"] = 23.16, ["Neon|Ride"] = 50.18, ["Neon|Fly|Ride"] = 143.03, ["Mega"] = 124.69, ["Mega|Ride"] = 143.06, ["Mega|Fly|Ride"] = 193.41}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 19.34, ["Ride"] = 11.24, ["Fly|Ride"] = 26.99, ["Neon"] = 2.1, ["Neon|Fly"] = 15.62, ["Neon|Ride"] = 11.46, ["Neon|Fly|Ride"] = 27.53, ["Mega"] = 14.76, ["Mega|Fly"] = 27.46, ["Mega|Ride"] = 21.92, ["Mega|Fly|Ride"] = 49.87}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 28.82, ["Ride"] = 27.39, ["Fly|Ride"] = 131.25, ["Neon"] = 9.84, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 129.54, ["Mega|Ride"] = 160.78, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 3.61, ["Fly"] = 112.52, ["Ride"] = 23.52, ["Fly|Ride"] = 59.06, ["Neon"] = 44.52, ["Neon|Ride"] = 67.48, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 259.88, ["Mega|Ride"] = 341.36, ["Mega|Fly|Ride"] = 311.73}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 16.02, ["Ride"] = 13.01, ["Fly|Ride"] = 42.95, ["Neon"] = 2.36, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 14.27, ["Neon|Fly|Ride"] = 50.99, ["Mega"] = 24.19, ["Mega|Ride"] = 31.48, ["Mega|Fly|Ride"] = 99.75}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 178.19, ["Ride"] = 30.24, ["Neon"] = 5.01, ["Neon|Ride"] = 28.84, ["Neon|Fly|Ride"] = 167.25, ["Mega"] = 63.93, ["Mega|Fly"] = 170.69, ["Mega|Ride"] = 98.44}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.5, ["Ride"] = 35.44, ["Neon"] = 5.14, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 143.03, ["Mega"] = 28.25, ["Mega|Fly"] = 142.95, ["Mega|Ride"] = 72.1, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Ride"] = 18.15, ["Neon"] = 2.1, ["Neon|Fly"] = 42.71, ["Neon|Ride"] = 33.09, ["Neon|Fly|Ride"] = 284.96, ["Mega"] = 15.86, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 178.15}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 71.49, ["Ride"] = 17.09, ["Fly|Ride"] = 46.45, ["Neon"] = 7.54, ["Neon|Fly"] = 28.84, ["Neon|Ride"] = 21.05, ["Neon|Fly|Ride"] = 57.66, ["Mega"] = 143.16, ["Mega|Ride"] = 91.75, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 55.47, ["Neon"] = 6.18, ["Neon|Ride"] = 61.93, ["Mega"] = 33.5, ["Mega|Ride"] = 97.02, ["Mega|Fly|Ride"] = 249.37}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 23.07, ["Ride"] = 15.31, ["Fly|Ride"] = 46.96, ["Neon"] = 5.2, ["Neon|Fly"] = 79.97, ["Neon|Ride"] = 21.36, ["Neon|Fly|Ride"] = 57.54, ["Mega"] = 103.69, ["Mega|Ride"] = 90.54, ["Mega|Fly|Ride"] = 142.95}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 6.57, ["Ride"] = 36.29, ["Fly|Ride"] = 50.05, ["Neon"] = 42, ["Neon|Fly"] = 249.75, ["Neon|Fly|Ride"] = 327.3, ["Mega"] = 98.44, ["Mega|Ride"] = 168.38}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 18.31, ["Fly|Ride"] = 57.48, ["Neon"] = 11.58, ["Neon|Fly"] = 48.37, ["Neon|Ride"] = 30.57, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 284.83, ["Mega|Fly"] = 420, ["Mega|Ride"] = 178.85, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 19.93, ["Ride"] = 26.25, ["Fly|Ride"] = 52.48, ["Neon"] = 16.03, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 72.16, ["Mega"] = 221.89, ["Mega|Fly"] = 138.99, ["Mega|Ride"] = 426.69, ["Mega|Fly|Ride"] = 177.17}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 6.56, ["Fly"] = 111.56, ["Neon"] = 26.25, ["Neon|Ride"] = 105.19, ["Mega"] = 157.47, ["Mega|Ride"] = 236.24}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 49.88, ["Ride"] = 56.44, ["Neon"] = 262.4, ["Neon|Fly|Ride"] = 126, ["Mega"] = 569.64, ["Mega|Ride"] = 714.26, ["Mega|Fly|Ride"] = 809.64}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 6.38, ["Ride"] = 34.16, ["Neon"] = 42.68, ["Neon|Ride"] = 126, ["Mega"] = 237.2, ["Mega|Ride"] = 365.53}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 4.7, ["Ride"] = 28.41, ["Fly|Ride"] = 120.75, ["Neon"] = 52.16, ["Neon|Ride"] = 79.75, ["Mega"] = 483.37, ["Mega|Ride"] = 421.37, ["Mega|Fly|Ride"] = 364.22}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.11, ["Neon|Ride"] = 64.99, ["Mega"] = 21.41, ["Mega|Fly"] = 64.02, ["Mega|Ride"] = 67.22, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 42.47}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 5.25, ["Fly"] = 23.61, ["Ride"] = 21.49, ["Fly|Ride"] = 41.57, ["Neon"] = 49.46, ["Neon|Fly"] = 188.48, ["Neon|Ride"] = 47.75, ["Neon|Fly|Ride"] = 78.62, ["Mega"] = 271.44, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 297.28}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 15.75, ["Fly|Ride"] = 52.5, ["Neon"] = 5.92, ["Neon|Ride"] = 26.41, ["Neon|Fly|Ride"] = 159.6, ["Mega"] = 24.93, ["Mega|Fly"] = 142.95, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Neon"] = 5.14, ["Neon|Ride"] = 34.2, ["Neon|Fly|Ride"] = 98.2, ["Mega"] = 39.25, ["Mega|Ride"] = 242.17, ["Mega|Fly|Ride"] = 133.88}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 50.15, ["Ride"] = 19.22, ["Fly|Ride"] = 42.83, ["Neon"] = 6.56, ["Neon|Ride"] = 19.22, ["Neon|Fly|Ride"] = 127.65, ["Mega"] = 141.75, ["Mega|Ride"] = 118, ["Mega|Fly|Ride"] = 188.07}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.75, ["Ride"] = 41.91, ["Fly|Ride"] = 57.75, ["Neon"] = 35.41, ["Neon|Ride"] = 191.03, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 128.63, ["Mega|Ride"] = 284.83, ["Mega|Fly|Ride"] = 318.96}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 32.47, ["Neon"] = 3.59, ["Mega"] = 16.02, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 60.38, ["Mega|Fly|Ride"] = 341.36}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 21.9, ["Ride"] = 16.75, ["Fly|Ride"] = 32.71, ["Neon"] = 3.46, ["Neon|Fly"] = 111.47, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 28.86, ["Mega|Fly"] = 143.16, ["Mega|Ride"] = 39.09, ["Mega|Fly|Ride"] = 161.94}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.82, ["Ride"] = 18.19, ["Fly|Ride"] = 42.14, ["Neon"] = 4.98, ["Neon|Fly"] = 53.38, ["Neon|Ride"] = 18.15, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 57.62, ["Mega|Fly"] = 142.95, ["Mega|Ride"] = 40.95, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 28.82, ["Ride"] = 54, ["Fly|Ride"] = 142.97, ["Neon"] = 7.13, ["Neon|Ride"] = 28.3, ["Neon|Fly|Ride"] = 104.9, ["Mega"] = 44.5, ["Mega|Ride"] = 80.84, ["Mega|Fly|Ride"] = 228.29}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.08, ["Neon|Ride"] = 32.03, ["Neon|Fly|Ride"] = 155640.06, ["Mega"] = 19.59, ["Mega|Fly"] = 96.68, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 136.4}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.89, ["Ride"] = 16.98, ["Fly|Ride"] = 81.1, ["Neon"] = 3.8, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 24.59, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 20.15, ["Mega|Fly"] = 64.02, ["Mega|Ride"] = 40.42, ["Mega|Fly|Ride"] = 96.68}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 18.38, ["Neon"] = 2.1, ["Neon|Ride"] = 40.57, ["Mega"] = 19.68, ["Mega|Ride"] = 420.13}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 4.38, ["Neon|Ride"] = 322.81, ["Neon|Fly|Ride"] = 420, ["Mega"] = 25.34, ["Mega|Ride"] = 155.91, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 14.01, ["Fly|Ride"] = 49.87, ["Neon"] = 5.25, ["Neon|Fly"] = 32.81, ["Neon|Ride"] = 17.04, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 36.75, ["Mega|Ride"] = 49.87, ["Mega|Fly|Ride"] = 107.58}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 11.72, ["Ride"] = 86.63, ["Fly|Ride"] = 213.39, ["Neon"] = 98.44, ["Mega"] = 551.25, ["Mega|Ride"] = 459.38}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 3.87, ["Fly"] = 6562.5, ["Ride"] = 56.44, ["Neon"] = 45.47}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 3.94, ["Ride"] = 30.5, ["Fly|Ride"] = 178.76, ["Neon"] = 25.99, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 426.91, ["Mega"] = 284.83, ["Mega|Ride"] = 412.83, ["Mega|Fly|Ride"] = 375.26}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 1.79, ["Fly"] = 13.12, ["Ride"] = 11.4, ["Fly|Ride"] = 25.61, ["Neon"] = 2.1, ["Neon|Fly"] = 15.63, ["Neon|Ride"] = 12.74, ["Neon|Fly|Ride"] = 27.19, ["Mega"] = 14.1, ["Mega|Fly"] = 24.94, ["Mega|Ride"] = 20.98, ["Mega|Fly|Ride"] = 48.37}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 60.38, ["Neon"] = 6.33, ["Neon|Fly"] = 67.79, ["Neon|Ride"] = 33.09, ["Neon|Fly|Ride"] = 711.86, ["Mega"] = 72.19, ["Mega|Ride"] = 117.93}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.4, ["Neon"] = 2.1, ["Neon|Fly"] = 32.03, ["Neon|Ride"] = 23.06, ["Neon|Fly|Ride"] = 84.15, ["Mega"] = 14.44, ["Mega|Fly"] = 89.25, ["Mega|Fly|Ride"] = 134.42}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.71, ["Neon|Fly"] = 60.89, ["Neon|Ride"] = 127.32, ["Mega"] = 18.37, ["Mega|Fly|Ride"] = 170.69}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 41.99, ["Ride"] = 17.71, ["Fly|Ride"] = 51.99, ["Neon"] = 4.86, ["Neon|Ride"] = 34.18, ["Neon|Fly|Ride"] = 64.93, ["Mega"] = 183.75, ["Mega|Ride"] = 199.48, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 151.69, ["Fly"] = 183.75, ["Ride"] = 211.25, ["Fly|Ride"] = 262.5, ["Neon"] = 935.93, ["Neon|Fly|Ride"] = 964.8, ["Mega"] = 8533.61, ["Mega|Ride"] = 3271.58, ["Mega|Fly|Ride"] = 3840.14}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 24.2, ["Neon"] = 8.05, ["Neon|Ride"] = 64.31, ["Mega"] = 91.87, ["Mega|Ride"] = 172.81, ["Mega|Fly|Ride"] = 634.71}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.52, ["Fly"] = 64.97, ["Ride"] = 26.24, ["Fly|Ride"] = 60.14, ["Neon"] = 31.29, ["Neon|Ride"] = 168.56, ["Neon|Fly|Ride"] = 143.03, ["Mega"] = 381.82, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 426.69}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 14.96, ["Fly|Ride"] = 32.8, ["Neon"] = 4.34, ["Neon|Fly"] = 33.09, ["Neon|Ride"] = 24.2, ["Neon|Fly|Ride"] = 42.78, ["Mega"] = 49.68, ["Mega|Ride"] = 82.6, ["Mega|Fly|Ride"] = 142.95}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 71.49, ["Ride"] = 18.13, ["Fly|Ride"] = 92.58, ["Neon"] = 6.97, ["Neon|Fly"] = 569.92, ["Neon|Ride"] = 45.02, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 70.35, ["Mega|Ride"] = 193.35}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.7, ["Fly"] = 24.65, ["Ride"] = 15.3, ["Fly|Ride"] = 45.89, ["Neon"] = 23.63, ["Neon|Fly"] = 100.34, ["Neon|Ride"] = 43.31, ["Neon|Fly|Ride"] = 77.95, ["Mega|Ride"] = 284.83, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.67, ["Ride"] = 42.7, ["Fly|Ride"] = 256.06, ["Neon"] = 44.26, ["Neon|Ride"] = 71.02, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 288.75, ["Mega|Ride"] = 274.44, ["Mega|Fly|Ride"] = 1066.71}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 16.94, ["Ride"] = 15.61, ["Fly|Ride"] = 33.01, ["Neon"] = 23.56, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 28.84, ["Neon|Fly|Ride"] = 70.6, ["Mega"] = 131.25, ["Mega|Ride"] = 306.16, ["Mega|Fly|Ride"] = 223.12}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 118.02, ["Fly"] = 91.89, ["Ride"] = 90.5, ["Fly|Ride"] = 142.93, ["Neon"] = 328.13, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 349.13, ["Neon|Fly|Ride"] = 426.57, ["Mega|Fly|Ride"] = 1291.14}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 209.9, ["Fly"] = 426.77, ["Ride"] = 241.74, ["Fly|Ride"] = 260.06, ["Neon|Ride"] = 2668.12, ["Neon|Fly|Ride"] = 925.1, ["Mega"] = 10667.01, ["Mega|Fly|Ride"] = 4932.43}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 56.28, ["Fly"] = 123.78, ["Ride"] = 73.8, ["Fly|Ride"] = 116.84, ["Neon"] = 262.5, ["Neon|Ride"] = 290.34, ["Neon|Fly|Ride"] = 345.89, ["Mega|Fly|Ride"] = 2465.74}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 8.81, ["Fly"] = 287.89, ["Ride"] = 36.35, ["Fly|Ride"] = 81.01, ["Neon"] = 32.8, ["Neon|Fly"] = 85.39, ["Neon|Ride"] = 122.13, ["Neon|Fly|Ride"] = 181.12, ["Mega"] = 262.49, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 416.72}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 10.07, ["Fly"] = 71.49, ["Ride"] = 18.8, ["Fly|Ride"] = 64.7, ["Neon"] = 92.87, ["Neon|Ride"] = 126.27, ["Neon|Fly|Ride"] = 199.48, ["Mega"] = 353.07, ["Mega|Ride"] = 397.68, ["Mega|Fly|Ride"] = 448.03}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.16, ["Ride"] = 18.1, ["Fly|Ride"] = 44.51, ["Neon"] = 5.24, ["Neon|Fly"] = 32.03, ["Neon|Ride"] = 20.79, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 114.59, ["Mega|Fly"] = 154.88, ["Mega|Ride"] = 111.46, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 5.71, ["Fly"] = 72.12, ["Ride"] = 22.09, ["Fly|Ride"] = 81.38, ["Neon"] = 152.15, ["Neon|Fly"] = 356.48, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 184.52, ["Mega"] = 1837.5, ["Mega|Ride"] = 548.63, ["Mega|Fly|Ride"] = 732.38}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.89, ["Ride"] = 15.21, ["Fly|Ride"] = 32.82, ["Neon"] = 13.12, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 31.45, ["Neon|Fly|Ride"] = 104.55, ["Mega"] = 144.38, ["Mega|Ride"] = 280.19, ["Mega|Fly|Ride"] = 178.37}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 3.68, ["Ride"] = 27.56, ["Fly|Ride"] = 328.13, ["Neon"] = 22.29, ["Neon|Ride"] = 35.76, ["Mega"] = 207.37, ["Mega|Ride"] = 284.83, ["Mega|Fly|Ride"] = 310.55}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 34.16, ["Ride"] = 19.35, ["Neon"] = 2.1, ["Neon|Ride"] = 19.66, ["Neon|Fly|Ride"] = 57.73, ["Mega"] = 14.59, ["Mega|Ride"] = 42.69, ["Mega|Fly|Ride"] = 78.73}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.62, ["Fly"] = 19.39, ["Ride"] = 18.16, ["Fly|Ride"] = 42.7, ["Neon"] = 15.21, ["Neon|Fly"] = 106.74, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 78.75, ["Mega|Fly|Ride"] = 159.92}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 25.71, ["Ride"] = 17.07, ["Fly|Ride"] = 61.73, ["Neon"] = 21.06, ["Neon|Ride"] = 47.25, ["Mega"] = 131.17, ["Mega|Ride"] = 206.95, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 107.62, ["Fly"] = 170.44, ["Ride"] = 140.84, ["Fly|Ride"] = 211.14, ["Neon"] = 1050, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 590.63, ["Mega"] = 4266.81, ["Mega|Fly|Ride"] = 2035.79}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.34, ["Ride"] = 32.83, ["Fly|Ride"] = 129.35, ["Neon"] = 44.65, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 376.56, ["Mega"] = 262.5, ["Mega|Ride"] = 413.45, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 42.15, ["Ride"] = 15.75, ["Fly|Ride"] = 41.62, ["Neon"] = 13.13, ["Neon|Ride"] = 28.84, ["Neon|Fly|Ride"] = 120.74, ["Mega"] = 235.66, ["Mega|Ride"] = 267.07, ["Mega|Fly|Ride"] = 284.83}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 20.98, ["Ride"] = 57.63, ["Fly|Ride"] = 170.63, ["Neon"] = 118.01, ["Neon|Ride"] = 192.21, ["Neon|Fly|Ride"] = 693.87, ["Mega"] = 711.51, ["Mega|Fly"] = 853.37, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 629.37}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 8.93}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.12, ["Ride"] = 28.61, ["Fly|Ride"] = 121.02, ["Neon"] = 36.3, ["Neon|Ride"] = 104.61, ["Mega"] = 285.91, ["Mega|Ride"] = 583.5, ["Mega|Fly|Ride"] = 886.98}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 26.17, ["Fly"] = 37.7, ["Ride"] = 22.46, ["Fly|Ride"] = 41.85, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 162.64, ["Neon|Fly|Ride"] = 183.1, ["Mega"] = 1377.13, ["Mega|Fly|Ride"] = 541.75}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 18.67, ["Fly|Ride"] = 65.63, ["Neon"] = 4.28, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 106.31, ["Mega"] = 28.73, ["Mega|Fly"] = 188.99, ["Mega|Ride"] = 57.66, ["Mega|Fly|Ride"] = 228.79}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 3.65, ["Fly"] = 28.41, ["Ride"] = 24.55, ["Fly|Ride"] = 64.03, ["Neon"] = 55.04, ["Neon|Ride"] = 64.05, ["Mega"] = 281.48, ["Mega|Fly"] = 403.61, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 396.83}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 16.02, ["Fly|Ride"] = 47.58, ["Neon"] = 17.21, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 35.42, ["Neon|Fly|Ride"] = 77.43, ["Mega"] = 138.89, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 262.42}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 26.16, ["Fly|Ride"] = 213.39, ["Neon"] = 3.28, ["Neon|Fly"] = 37.37, ["Neon|Ride"] = 32, ["Neon|Fly|Ride"] = 213.46, ["Mega"] = 31.4, ["Mega|Ride"] = 55.04, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 23.35, ["Ride"] = 74.82, ["Fly|Ride"] = 145.06, ["Neon"] = 280.26, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 576.19, ["Mega"] = 850.61, ["Mega|Fly|Ride"] = 1172.32}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.26, ["Ride"] = 28.82, ["Fly|Ride"] = 210, ["Neon"] = 92.65, ["Mega|Ride"] = 342.67}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 15.11, ["Fly"] = 29.54, ["Ride"] = 21.94, ["Fly|Ride"] = 61.15, ["Neon"] = 21, ["Neon|Fly"] = 84, ["Neon|Ride"] = 47.66, ["Neon|Fly|Ride"] = 118.46, ["Mega"] = 372.44, ["Mega|Ride"] = 288.02, ["Mega|Fly|Ride"] = 421.32}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 64.74, ["Fly"] = 433.13, ["Ride"] = 393.73, ["Fly|Ride"] = 262.47, ["Neon"] = 354.38, ["Neon|Ride"] = 554.97, ["Mega"] = 4513.37, ["Mega|Ride"] = 2165.63, ["Mega|Fly|Ride"] = 1836.19}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 6.29, ["Fly"] = 45.94, ["Ride"] = 22.91, ["Fly|Ride"] = 57.54, ["Neon"] = 57.64, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 53.38, ["Neon|Fly|Ride"] = 114.18, ["Mega"] = 241.58, ["Mega|Ride"] = 426.69, ["Mega|Fly|Ride"] = 711.51}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 69.56, ["Fly"] = 170.71, ["Ride"] = 88.5, ["Fly|Ride"] = 150.94, ["Neon"] = 266.44, ["Neon|Ride"] = 232.47, ["Mega"] = 1138.18, ["Mega|Ride"] = 901.78, ["Mega|Fly|Ride"] = 1085.17}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 16.01, ["Ride"] = 43.64, ["Fly|Ride"] = 105.18, ["Neon"] = 79.71, ["Neon|Ride"] = 100.78, ["Neon|Fly|Ride"] = 170.62, ["Mega"] = 354.38, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 413.44}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 8.43, ["Fly"] = 41.36, ["Ride"] = 28.82, ["Fly|Ride"] = 64.03, ["Neon"] = 83.96, ["Neon|Ride"] = 144.16, ["Neon|Fly|Ride"] = 384.28, ["Mega"] = 213.35, ["Mega|Ride"] = 1600.07, ["Mega|Fly|Ride"] = 532.3}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 8.81, ["Ride"] = 44.63, ["Fly|Ride"] = 162, ["Neon"] = 59.94, ["Neon|Ride"] = 213.46, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 356.29, ["Mega|Ride"] = 280.87, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 5.38, ["Ride"] = 24.93, ["Fly|Ride"] = 89.63, ["Neon"] = 56.33, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 141.16, ["Mega"] = 238.9, ["Mega|Ride"] = 265.21, ["Mega|Fly|Ride"] = 417.38}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Fly|Ride"] = 100.3, ["Neon"] = 2.34, ["Neon|Ride"] = 57.64, ["Mega"] = 19.15, ["Mega|Ride"] = 135.49, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 2.1, ["Ride"] = 28.42, ["Neon"] = 24.02, ["Neon|Fly"] = 128.09, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 157.5, ["Mega|Ride"] = 270.96, ["Mega|Fly|Ride"] = 424.56}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 126.98, ["Neon"] = 28.65, ["Neon|Fly"] = 116.94, ["Neon|Ride"] = 315, ["Mega"] = 174.03, ["Mega|Ride"] = 139.89, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 3.94, ["Ride"] = 32.79, ["Fly|Ride"] = 120.89, ["Neon"] = 30.97, ["Neon|Ride"] = 80.06, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 124.69, ["Mega|Ride"] = 284.83, ["Mega|Fly|Ride"] = 4266.81}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 499.11, ["Fly"] = 523.69, ["Ride"] = 576.19, ["Fly|Ride"] = 640.4, ["Neon"] = 1850.61, ["Neon|Ride"] = 2134.5, ["Neon|Fly|Ride"] = 1829.73, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 4.46, ["Fly"] = 28.82, ["Ride"] = 20.43, ["Fly|Ride"] = 56.35, ["Neon"] = 41.64, ["Neon|Ride"] = 62.91, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 137.82, ["Mega|Ride"] = 366.62, ["Mega|Fly|Ride"] = 512.03}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 6.5, ["Fly"] = 524.79, ["Ride"] = 31.13, ["Fly|Ride"] = 51.54, ["Neon"] = 39.36, ["Neon|Fly"] = 315, ["Neon|Ride"] = 98.34, ["Neon|Fly|Ride"] = 170.78, ["Mega"] = 483.37, ["Mega|Ride"] = 484.31, ["Mega|Fly|Ride"] = 681.35}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.1, ["Fly"] = 91.87, ["Ride"] = 27.2, ["Fly|Ride"] = 52.5, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 131.25}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.59, ["Ride"] = 23, ["Fly|Ride"] = 72.57, ["Neon"] = 6.04, ["Neon|Ride"] = 30.33, ["Neon|Fly|Ride"] = 89.39, ["Mega"] = 64.24, ["Mega|Fly"] = 213.35, ["Mega|Ride"] = 87.65, ["Mega|Fly|Ride"] = 210.21}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 71.49, ["Ride"] = 16.95, ["Neon"] = 2.1, ["Neon|Ride"] = 24.34, ["Neon|Fly|Ride"] = 127.01, ["Mega"] = 19.58, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 221.55}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1108.96}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 4.29, ["Ride"] = 36.74, ["Fly|Ride"] = 105, ["Neon"] = 52.5, ["Neon|Ride"] = 91.75, ["Neon|Fly|Ride"] = 322.81, ["Mega"] = 424.56, ["Mega|Ride"] = 580.05, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 26.65, ["Neon"] = 6.13, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 982.1, ["Mega"] = 39.38, ["Mega|Ride"] = 104.55, ["Mega|Fly|Ride"] = 251.34}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 4.98, ["Fly"] = 27.17, ["Ride"] = 63.95, ["Neon"] = 28.67, ["Neon|Ride"] = 71.52, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 196.86, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 1066.71}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 418.69, ["Ride"] = 525, ["Fly|Ride"] = 498.75, ["Neon|Ride"] = 2360.96, ["Neon|Fly|Ride"] = 2131.62, ["Mega"] = 8862.38, ["Mega|Fly|Ride"] = 6298.69}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 4.45, ["Fly"] = 196.88, ["Ride"] = 57.63, ["Fly|Ride"] = 426.77, ["Neon"] = 29.86, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 193.45, ["Mega"] = 532.3, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 741.97}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Ride"] = 23.57, ["Fly|Ride"] = 118.13, ["Neon"] = 3.68, ["Neon|Ride"] = 36.66, ["Neon|Fly|Ride"] = 123.8, ["Mega"] = 37.86, ["Mega|Fly"] = 128.02, ["Mega|Ride"] = 71.87, ["Mega|Fly|Ride"] = 173.97}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 4.07, ["Neon|Ride"] = 129.92, ["Neon|Fly|Ride"] = 284.96, ["Mega"] = 31.24, ["Mega|Ride"] = 136.15, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 16.59, ["Fly"] = 107.63, ["Ride"] = 111.46, ["Fly|Ride"] = 157.45, ["Neon"] = 152.67, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 622.91, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 544.69}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 8.22, ["Ride"] = 71.31, ["Neon"] = 80.33, ["Neon|Ride"] = 162.02, ["Neon|Fly|Ride"] = 507.76, ["Mega"] = 590.98, ["Mega|Ride"] = 479.73, ["Mega|Fly|Ride"] = 569.64}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 7.49, ["Ride"] = 31.4, ["Neon"] = 96.94, ["Neon|Ride"] = 182.57, ["Mega"] = 661.01, ["Mega|Ride"] = 782.98, ["Mega|Fly|Ride"] = 1280.06}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 12.46, ["Ride"] = 23.63, ["Fly|Ride"] = 262.5, ["Neon"] = 131.24, ["Neon|Ride"] = 182.44, ["Neon|Fly|Ride"] = 213.35, ["Mega"] = 616.77, ["Mega|Ride"] = 1300.04, ["Mega|Fly|Ride"] = 509.25}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 361.75, ["Ride"] = 371.38, ["Fly|Ride"] = 778.49, ["Neon"] = 1209, ["Neon|Ride"] = 1423.71, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4084.39}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 5.2, ["Fly"] = 78.74, ["Ride"] = 26.25, ["Fly|Ride"] = 64.3, ["Neon"] = 178.25, ["Neon|Ride"] = 192.24, ["Neon|Fly|Ride"] = 199.9, ["Mega|Ride"] = 768.48, ["Mega|Fly|Ride"] = 877.91}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 2.1, ["Ride"] = 42.68, ["Fly|Ride"] = 127.32, ["Neon"] = 64.32, ["Neon|Ride"] = 221.82, ["Mega"] = 367.5, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1066.71}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 16.4, ["Ride"] = 78.75, ["Fly|Ride"] = 232.11, ["Neon"] = 81.29, ["Neon|Ride"] = 157.22, ["Neon|Fly|Ride"] = 260.78, ["Mega"] = 295.56, ["Mega|Ride"] = 325.5, ["Mega|Fly|Ride"] = 393.65}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.49, ["Ride"] = 42.7, ["Fly|Ride"] = 142.97, ["Neon"] = 6.47, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 213.46, ["Mega"] = 42.31, ["Mega|Ride"] = 128.02, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 32.82, ["Ride"] = 79.85, ["Neon"] = 384.22, ["Neon|Ride"] = 425.84, ["Neon|Fly|Ride"] = 470.67, ["Mega"] = 1691.76, ["Mega|Ride"] = 2133.41, ["Mega|Fly|Ride"] = 1200.64}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 521, ["Ride"] = 26.24, ["Fly|Ride"] = 60.83, ["Neon"] = 6.65, ["Neon|Fly"] = 185.71, ["Neon|Ride"] = 79, ["Neon|Fly|Ride"] = 131.61, ["Mega"] = 72.18, ["Mega|Ride"] = 101.43, ["Mega|Fly|Ride"] = 221.94}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 27.82, ["Neon"] = 3.71, ["Neon|Fly"] = 49.38, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 114.21, ["Mega"] = 57.75, ["Mega|Fly"] = 112.88, ["Mega|Ride"] = 76.13, ["Mega|Fly|Ride"] = 170.26}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 37.97, ["Fly|Ride"] = 127.52, ["Neon"] = 12.83, ["Neon|Ride"] = 61.92, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 93.64, ["Mega|Fly"] = 459.38, ["Mega|Ride"] = 128.99, ["Mega|Fly|Ride"] = 314.7}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 44.41, ["Fly"] = 85.37, ["Ride"] = 60.37, ["Fly|Ride"] = 169.32, ["Neon"] = 271.01, ["Neon|Ride"] = 314.07, ["Neon|Fly|Ride"] = 478.06, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 256.5, ["Ride"] = 277.98, ["Fly|Ride"] = 425.71, ["Neon"] = 1462.13, ["Neon|Ride"] = 1177.51, ["Neon|Fly|Ride"] = 1329.83, ["Mega"] = 9667.17, ["Mega|Fly|Ride"] = 5301.24}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 2.99, ["Neon"] = 30.09, ["Neon|Fly"] = 350.44, ["Neon|Fly|Ride"] = 160.1, ["Mega"] = 104.9, ["Mega|Fly"] = 224.02, ["Mega|Ride"] = 320.02}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 25.62, ["Neon"] = 6.33, ["Neon|Ride"] = 35.06, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 46.27, ["Mega|Fly"] = 164.07, ["Mega|Ride"] = 90.46, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.29, ["Fly"] = 162, ["Ride"] = 27.57, ["Fly|Ride"] = 81.01, ["Neon"] = 32.81, ["Mega"] = 140.53, ["Mega|Ride"] = 351.74, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.61, ["Fly"] = 90.04, ["Ride"] = 29.54, ["Fly|Ride"] = 81.01, ["Neon"] = 11.46, ["Neon|Ride"] = 46.35, ["Neon|Fly|Ride"] = 157.97, ["Mega"] = 124.41, ["Mega|Ride"] = 221.16, ["Mega|Fly|Ride"] = 241.69}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 59.06, ["Neon"] = 8.54, ["Neon|Fly|Ride"] = 143.03, ["Mega"] = 40.15, ["Mega|Ride"] = 142.95, ["Mega|Fly|Ride"] = 281.63}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 28.82, ["Ride"] = 17.91, ["Fly|Ride"] = 52.49, ["Neon"] = 4.08, ["Neon|Fly"] = 81.02, ["Neon|Ride"] = 24.2, ["Neon|Fly|Ride"] = 58.02, ["Mega"] = 39.79, ["Mega|Ride"] = 95.72, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.63, ["Fly"] = 26.25, ["Ride"] = 17.79, ["Fly|Ride"] = 41.31, ["Neon"] = 15.16, ["Neon|Fly"] = 64.97, ["Neon|Ride"] = 38.66, ["Neon|Fly|Ride"] = 96.68, ["Mega"] = 105, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 169.61}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 18.8, ["Fly"] = 52.5, ["Ride"] = 36.9, ["Fly|Ride"] = 78.66, ["Neon"] = 136.4, ["Neon|Ride"] = 613.68, ["Neon|Fly|Ride"] = 322.81, ["Mega"] = 393.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 527.68}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 70.88, ["Ride"] = 84.2, ["Fly|Ride"] = 137.73, ["Neon"] = 410.81, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 3222.8, ["Mega|Ride"] = 3254.99, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 1.79, ["Ride"] = 17.88, ["Fly|Ride"] = 144.38, ["Neon"] = 3.2, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 26.2, ["Neon|Fly|Ride"] = 128.47, ["Mega"] = 45.85, ["Mega|Fly"] = 672, ["Mega|Ride"] = 92.8, ["Mega|Fly|Ride"] = 246.75}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 14.23, ["Ride"] = 14.86, ["Fly|Ride"] = 36.29, ["Neon"] = 3.94, ["Neon|Fly"] = 28.41, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 61.68, ["Mega"] = 40.53, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 66.94, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 6.04, ["Fly"] = 42.7, ["Ride"] = 48.76, ["Fly|Ride"] = 131.25, ["Neon"] = 48.37, ["Neon|Ride"] = 124.68, ["Neon|Fly|Ride"] = 284.96, ["Mega"] = 527.62, ["Mega|Ride"] = 274.32, ["Mega|Fly|Ride"] = 645.29}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.75, ["Fly"] = 518.44, ["Ride"] = 472.5, ["Fly|Ride"] = 577.5, ["Neon|Ride"] = 1934.38, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 8056.39}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 19.09, ["Fly"] = 100.3, ["Ride"] = 40.1, ["Fly|Ride"] = 107.49, ["Neon"] = 210.34, ["Neon|Ride"] = 225.73, ["Neon|Fly|Ride"] = 473.93, ["Mega|Ride"] = 880.69, ["Mega|Fly|Ride"] = 1128.66}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 25.83, ["Fly|Ride"] = 281.33, ["Neon"] = 8.76, ["Neon|Ride"] = 45.39, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 97.84, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 271.98}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 65.61, ["Fly|Ride"] = 143.05, ["Neon"] = 17.1}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 32.22, ["Fly"] = 169.3, ["Ride"] = 71.8, ["Fly|Ride"] = 104.81, ["Neon"] = 194.25, ["Neon|Ride"] = 274.45, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 2560.09, ["Mega|Ride"] = 2034.38, ["Mega|Fly|Ride"] = 1280.06}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 77.96, ["Fly"] = 104.9, ["Ride"] = 112.28, ["Fly|Ride"] = 192.05, ["Neon"] = 430.1, ["Neon|Ride"] = 483.6, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 8533.61, ["Mega|Fly|Ride"] = 2331.82}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 218.3, ["Ride"] = 252.14, ["Fly|Ride"] = 470.5, ["Neon"] = 1050, ["Neon|Ride"] = 800.63, ["Neon|Fly|Ride"] = 934.59, ["Mega|Fly|Ride"] = 4147.5}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 8.65, ["Ride"] = 34.13, ["Fly|Ride"] = 96.17, ["Neon"] = 85.12, ["Neon|Ride"] = 124.68, ["Neon|Fly|Ride"] = 356.29, ["Mega"] = 389.79, ["Mega|Ride"] = 404.79, ["Mega|Fly|Ride"] = 537.74}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 19.47, ["Ride"] = 15.54, ["Fly|Ride"] = 42.95, ["Neon"] = 10.68, ["Neon|Ride"] = 23.15, ["Neon|Fly|Ride"] = 92.87, ["Mega"] = 57.62, ["Mega|Ride"] = 104.98, ["Mega|Fly|Ride"] = 170.31}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 15.38, ["Fly"] = 39.3, ["Ride"] = 15.75, ["Fly|Ride"] = 53.36, ["Neon"] = 31.08, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 36.52, ["Neon|Fly|Ride"] = 77.77, ["Mega"] = 349.9, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 366.19}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 317.97, ["Fly"] = 498.25, ["Ride"] = 441.3, ["Fly|Ride"] = 470.5, ["Neon"] = 1968.75, ["Neon|Ride"] = 2029.3, ["Mega"] = 10240.33, ["Mega|Fly|Ride"] = 6505.82}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Neon"] = 8.45, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 29.64, ["Mega|Ride"] = 170.99, ["Mega|Fly|Ride"] = 450.13}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.41, ["Ride"] = 15.74, ["Fly|Ride"] = 57.63, ["Neon"] = 38.17, ["Neon|Ride"] = 37.54, ["Neon|Fly|Ride"] = 84, ["Mega"] = 235.76, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 196.32, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 7.77, ["Ride"] = 83.99, ["Neon"] = 77.3, ["Neon|Fly"] = 426.91, ["Neon|Ride"] = 236.25, ["Mega"] = 548.63, ["Mega|Ride"] = 609, ["Mega|Fly|Ride"] = 600.18}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 95.24, ["Fly"] = 157.5, ["Ride"] = 70.88, ["Fly|Ride"] = 127.03, ["Neon|Ride"] = 273.25, ["Neon|Fly|Ride"] = 568.32, ["Mega|Fly|Ride"] = 2379.57}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 16.25, ["Fly"] = 24.33, ["Ride"] = 23.5, ["Fly|Ride"] = 48.88, ["Neon"] = 130.5, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 711.51, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 518.44}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 21.36, ["Neon"] = 2.1, ["Neon|Ride"] = 39.38, ["Mega"] = 24.94, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 19.69, ["Fly|Ride"] = 71.49, ["Neon"] = 3.03, ["Neon|Ride"] = 22.35, ["Neon|Fly|Ride"] = 79.38, ["Mega"] = 22.91, ["Mega|Fly"] = 87.64, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 109.98}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 6.39, ["Ride"] = 76.56, ["Fly|Ride"] = 135.06, ["Neon"] = 30.66, ["Neon|Ride"] = 86.29, ["Neon|Fly|Ride"] = 203.43, ["Mega"] = 170.63, ["Mega|Ride"] = 196.86, ["Mega|Fly|Ride"] = 296.01}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1168.12, ["Fly"] = 1668.16, ["Ride"] = 1443.74, ["Fly|Ride"] = 1435.87, ["Neon"] = 4200, ["Neon|Ride"] = 4375.7, ["Neon|Fly|Ride"] = 4125.97, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 446.25, ["Ride"] = 479.07, ["Fly|Ride"] = 766.02, ["Neon"] = 2505.03, ["Neon|Ride"] = 2277.5, ["Neon|Fly|Ride"] = 2277.5, ["Mega"] = 17067.2, ["Mega|Fly|Ride"] = 7183.17}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 286.77, ["Fly"] = 422.49, ["Ride"] = 299.24, ["Fly|Ride"] = 413.43, ["Neon"] = 787.29, ["Neon|Fly"] = 853.81, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 853.02, ["Mega|Fly|Ride"] = 2916.24}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 271.52, ["Fly"] = 334.68, ["Ride"] = 302.3, ["Fly|Ride"] = 393.75, ["Neon"] = 777, ["Neon|Ride"] = 761.24, ["Neon|Fly|Ride"] = 996.32, ["Mega|Fly|Ride"] = 4265.75}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 64.31, ["Ride"] = 15.91, ["Fly|Ride"] = 39.12, ["Neon"] = 3.84, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 104.9, ["Mega"] = 69.43, ["Mega|Fly"] = 114.15, ["Mega|Ride"] = 82.68, ["Mega|Fly|Ride"] = 142.93}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 315.94, ["Fly"] = 1423.22, ["Ride"] = 369.43, ["Fly|Ride"] = 498.75, ["Neon"] = 1706.25, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 2417.97, ["Mega"] = 21618.81, ["Mega|Ride"] = 5120.17, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.83, ["Fly"] = 157.5, ["Ride"] = 112.52, ["Fly|Ride"] = 91.87, ["Neon"] = 21.41, ["Neon|Ride"] = 213.46, ["Neon|Fly|Ride"] = 252, ["Mega"] = 137.81, ["Mega|Ride"] = 235.5, ["Mega|Fly|Ride"] = 353.1}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 18.12, ["Ride"] = 14.97, ["Fly|Ride"] = 39.38, ["Neon"] = 12.11, ["Neon|Ride"] = 28.84, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 104.9, ["Mega|Ride"] = 192.93, ["Mega|Fly|Ride"] = 153.62}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 56.6, ["Neon"] = 3.81, ["Neon|Ride"] = 39.38, ["Mega"] = 29.59, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 80.07, ["Fly|Ride"] = 459.38, ["Neon"] = 244.28, ["Neon|Ride"] = 420, ["Mega"] = 1050, ["Mega|Ride"] = 488.25, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 8038.15, ["Ride"] = 26.25, ["Fly|Ride"] = 68.25, ["Neon"] = 26.07, ["Neon|Ride"] = 61.13, ["Mega|Ride"] = 412.83, ["Mega|Fly|Ride"] = 426.69}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.05, ["Ride"] = 55.13, ["Fly|Ride"] = 142.97, ["Neon"] = 3.34, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 103.94, ["Mega"] = 26.17, ["Mega|Ride"] = 68.01, ["Mega|Fly|Ride"] = 165.8}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 3.93, ["Fly"] = 41.02, ["Ride"] = 19.85, ["Fly|Ride"] = 78.65, ["Neon"] = 13.32, ["Neon|Fly"] = 113.9, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 77.12, ["Mega"] = 131.15, ["Mega|Fly"] = 483.37, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 4.12, ["Fly"] = 57.63, ["Ride"] = 22.32, ["Fly|Ride"] = 52.5, ["Neon"] = 35.77, ["Neon|Fly"] = 145.09, ["Neon|Ride"] = 143.03, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 238.82, ["Mega|Ride"] = 251.07, ["Mega|Fly|Ride"] = 1321.69}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 12.15, ["Ride"] = 52.5, ["Neon"] = 79, ["Neon|Ride"] = 382.09, ["Neon|Fly|Ride"] = 274.32, ["Mega"] = 284.83, ["Mega|Ride"] = 412.83}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 3.66, ["Fly"] = 6447.77, ["Ride"] = 19.69, ["Neon"] = 39.38, ["Neon|Fly"] = 47.25, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 725.41, ["Mega"] = 308.44, ["Mega|Ride"] = 421.61, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 64.37, ["Ride"] = 18.38, ["Fly|Ride"] = 38.42, ["Neon"] = 3.84, ["Neon|Fly"] = 32.03, ["Neon|Ride"] = 27.83, ["Neon|Fly|Ride"] = 85.39, ["Mega"] = 40.83, ["Mega|Ride"] = 182.48, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 163.48, ["Fly"] = 260.33, ["Ride"] = 164.07, ["Fly|Ride"] = 229.69, ["Neon|Ride"] = 993.61, ["Neon|Fly|Ride"] = 838.68, ["Mega"] = 8533.61, ["Mega|Fly|Ride"] = 3520.13}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 19.03, ["Ride"] = 14.94, ["Fly|Ride"] = 41.79, ["Neon"] = 3.08, ["Neon|Fly"] = 24.55, ["Neon|Ride"] = 24.75, ["Neon|Fly|Ride"] = 56.35, ["Mega"] = 44.63, ["Mega|Ride"] = 52.76, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 7.05, ["Ride"] = 42.37, ["Fly|Ride"] = 196.77, ["Neon"] = 59.85, ["Neon|Ride"] = 128.55, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 313.69, ["Mega|Fly"] = 806.02, ["Mega|Fly|Ride"] = 379.32}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 21.95, ["Ride"] = 106.71, ["Fly|Ride"] = 170.63, ["Neon"] = 137.89, ["Neon|Ride"] = 272.94, ["Mega"] = 996.32, ["Mega|Ride"] = 509.54, ["Mega|Fly|Ride"] = 972.84}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 181.54, ["Ride"] = 220.73, ["Fly|Ride"] = 711.61, ["Neon"] = 772.55, ["Neon|Ride"] = 682.5, ["Neon|Fly|Ride"] = 974.98, ["Mega|Fly|Ride"] = 3399.58}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 21.84, ["Ride"] = 158.3, ["Fly|Ride"] = 142.97, ["Neon"] = 91.88, ["Mega"] = 287.44, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 588.51}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 8.15, ["Ride"] = 57.75, ["Fly|Ride"] = 185.66, ["Neon"] = 105, ["Neon|Fly"] = 162.02, ["Neon|Ride"] = 199, ["Neon|Fly|Ride"] = 226.09, ["Mega"] = 771.89, ["Mega|Ride"] = 853.37, ["Mega|Fly|Ride"] = 996.32}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 958.11, ["Fly"] = 1050, ["Ride"] = 1050, ["Fly|Ride"] = 1179.93, ["Neon|Ride"] = 4525.12, ["Neon|Fly|Ride"] = 4823.94, ["Mega|Fly|Ride"] = 20267.3}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 5.14, ["Fly"] = 20.99, ["Ride"] = 19.81, ["Fly|Ride"] = 52.5, ["Neon"] = 16.02, ["Neon|Fly"] = 47.43, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 213.35, ["Mega"] = 229.62, ["Mega|Ride"] = 199.48, ["Mega|Fly|Ride"] = 426.69}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 4.09, ["Fly"] = 78.75, ["Ride"] = 35.32, ["Fly|Ride"] = 135.19, ["Neon"] = 36.3, ["Neon|Ride"] = 108.82, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 251.76, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 297.28, ["Mega|Fly|Ride"] = 996.32}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 84.29, ["Ride"] = 29.64, ["Fly|Ride"] = 69.45, ["Neon"] = 15.65, ["Neon|Ride"] = 45.4, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 105, ["Mega|Ride"] = 243.06, ["Mega|Fly|Ride"] = 569.64}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 11.08, ["Ride"] = 32.47, ["Fly|Ride"] = 84.79, ["Neon"] = 78.64, ["Neon|Fly"] = 143.03, ["Neon|Ride"] = 74.67, ["Neon|Fly|Ride"] = 196.27, ["Mega"] = 483.37, ["Mega|Ride"] = 347.82, ["Mega|Fly|Ride"] = 438.38}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 3.93, ["Fly"] = 20.47, ["Ride"] = 15.87, ["Fly|Ride"] = 48.54, ["Neon"] = 16.89, ["Neon|Fly"] = 42.73, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 100.33, ["Mega|Fly"] = 256.03, ["Mega|Ride"] = 91.77, ["Mega|Fly|Ride"] = 258.16}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 17.09, ["Neon"] = 10.36, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 52.17, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 148.97, ["Mega|Ride"] = 199.38, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 175.86, ["Ride"] = 269.64, ["Fly|Ride"] = 356.35, ["Neon|Fly|Ride"] = 1182.56}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.8, ["Ride"] = 24.55, ["Fly|Ride"] = 108.94, ["Neon"] = 5.44, ["Neon|Ride"] = 32.51, ["Neon|Fly|Ride"] = 127.42, ["Mega"] = 79.03, ["Mega|Fly"] = 426.69, ["Mega|Ride"] = 119.61, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 2.1, ["Ride"] = 82.01, ["Fly|Ride"] = 88.86, ["Neon"] = 27.2, ["Neon|Ride"] = 188.27, ["Mega|Ride"] = 318.94}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.5, ["Fly"] = 98.86, ["Ride"] = 28.76, ["Neon"] = 27.53, ["Neon|Ride"] = 52.5, ["Mega"] = 84.94, ["Mega|Ride"] = 174.57, ["Mega|Fly|Ride"] = 512.44}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 90.07, ["Fly|Ride"] = 308.44, ["Neon"] = 636.08, ["Neon|Ride"] = 1594.46, ["Neon|Fly|Ride"] = 678.78, ["Mega|Ride"] = 4266.81, ["Mega|Fly|Ride"] = 3200.11}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 19.46, ["Fly"] = 120.89, ["Ride"] = 48.37, ["Fly|Ride"] = 228.33, ["Neon"] = 149.5, ["Neon|Ride"] = 163.46, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 590.63, ["Mega|Ride"] = 597.37, ["Mega|Fly|Ride"] = 879.38}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 17.35, ["Fly"] = 322.76, ["Ride"] = 32.38, ["Fly|Ride"] = 94.21, ["Neon"] = 118.12, ["Neon|Ride"] = 124.68, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 426.97, ["Mega|Ride"] = 434.44, ["Mega|Fly|Ride"] = 540.84}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 15.75, ["Neon"] = 3.68, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 210, ["Mega"] = 76.13, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 253.88}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 42.7, ["Fly"] = 63.66, ["Ride"] = 74.82, ["Fly|Ride"] = 150.94, ["Neon"] = 315, ["Neon|Fly"] = 272.44, ["Neon|Ride"] = 307.98, ["Neon|Fly|Ride"] = 277.93, ["Mega|Fly|Ride"] = 1209.65}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.45, ["Fly|Ride"] = 41.14, ["Neon"] = 3.84, ["Neon|Ride"] = 57.64, ["Neon|Fly|Ride"] = 127.01, ["Mega"] = 58.91}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 15.16, ["Fly"] = 129.35, ["Ride"] = 23.36, ["Fly|Ride"] = 87.05, ["Neon"] = 66.89, ["Neon|Ride"] = 118.11, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 393.75, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 425.63, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 43.24, ["Fly"] = 131.25, ["Ride"] = 140.84, ["Fly|Ride"] = 199.53, ["Neon"] = 244.01, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 321.59, ["Mega|Ride"] = 1992.61, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 17.09, ["Ride"] = 15.86, ["Fly|Ride"] = 35.44, ["Neon"] = 2.1, ["Neon|Fly"] = 24.55, ["Neon|Ride"] = 17.1, ["Neon|Fly|Ride"] = 38.16, ["Mega"] = 16.59, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 32.78, ["Mega|Fly|Ride"] = 95.55}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.91, ["Ride"] = 52.49, ["Fly|Ride"] = 131.15, ["Neon"] = 18.09, ["Neon|Ride"] = 57.64, ["Neon|Fly|Ride"] = 291.38, ["Mega"] = 131.25, ["Mega|Ride"] = 278.92, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 11.61, ["Ride"] = 43.22, ["Fly|Ride"] = 85.32, ["Neon"] = 111.45, ["Mega"] = 536.71, ["Mega|Ride"] = 450.21, ["Mega|Fly|Ride"] = 675.56}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 22.2, ["Neon"] = 2.1, ["Neon|Ride"] = 28.86, ["Neon|Fly|Ride"] = 139.82, ["Mega"] = 19.63, ["Mega|Ride"] = 85.36, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 13.01, ["Fly"] = 195.33, ["Ride"] = 47.67, ["Fly|Ride"] = 174.98, ["Neon"] = 61.85, ["Neon|Ride"] = 170.78, ["Neon|Fly|Ride"] = 443.63, ["Mega"] = 459.38, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 453.74}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 6.07, ["Fly"] = 42.7, ["Ride"] = 21.56, ["Fly|Ride"] = 98.44, ["Neon"] = 408.98, ["Neon|Ride"] = 113.54, ["Neon|Fly|Ride"] = 129.94, ["Mega|Fly|Ride"] = 645.29}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.36, ["Ride"] = 37.8, ["Neon"] = 23.57, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 65.61, ["Neon|Fly|Ride"] = 130.19, ["Mega"] = 233.63, ["Mega|Ride"] = 248.48, ["Mega|Fly|Ride"] = 403.61}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 5.24, ["Fly"] = 2056.43, ["Ride"] = 72.18, ["Fly|Ride"] = 196.88, ["Neon"] = 45.76, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 6444.39, ["Mega|Ride"] = 288.82, ["Mega|Fly|Ride"] = 1013.38}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 42.7, ["Ride"] = 19.48, ["Fly|Ride"] = 196.88, ["Neon"] = 7.07, ["Neon|Ride"] = 32.43, ["Mega"] = 69.55, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 149.36, ["Mega|Fly|Ride"] = 281.63}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 55.53, ["Neon"] = 3.67, ["Mega"] = 21.39, ["Mega|Ride"] = 126.06, ["Mega|Fly|Ride"] = 231.55}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 14.99}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 37.95, ["Fly"] = 100.3, ["Ride"] = 52.49, ["Neon"] = 243.34, ["Neon|Ride"] = 284.96, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 1849.67, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.51, ["Neon|Ride"] = 28.84, ["Mega"] = 18, ["Mega|Ride"] = 119.81, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 458.07, ["Fly"] = 498.75, ["Ride"] = 484.37, ["Fly|Ride"] = 641.82, ["Neon"] = 2130.22, ["Neon|Fly|Ride"] = 2376.75, ["Mega"] = 17067.2, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 5.9, ["Fly"] = 26.25, ["Ride"] = 25.73, ["Fly|Ride"] = 66.26, ["Neon"] = 34.65, ["Neon|Fly"] = 183.75, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 93.19, ["Mega|Ride"] = 144.37, ["Mega|Fly|Ride"] = 284.83}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.19, ["Fly"] = 52.49, ["Ride"] = 22.19, ["Fly|Ride"] = 81.27, ["Neon"] = 19.25, ["Neon|Ride"] = 42.71, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 142.95, ["Mega|Fly"] = 213.35, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 14.3, ["Fly"] = 71.49, ["Ride"] = 51.22, ["Fly|Ride"] = 69.57, ["Neon"] = 102.8, ["Neon|Ride"] = 154.76, ["Mega"] = 853.37, ["Mega|Ride"] = 561.75, ["Mega|Fly|Ride"] = 570.51}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.16, ["Fly"] = 57.63, ["Ride"] = 28.42, ["Fly|Ride"] = 721.88, ["Neon"] = 17.22, ["Neon|Ride"] = 105, ["Mega"] = 275.63, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 4.2, ["Ride"] = 142.97, ["Fly|Ride"] = 157.49, ["Neon"] = 64.6, ["Neon|Ride"] = 112.88, ["Mega"] = 497.43, ["Mega|Ride"] = 570.05, ["Mega|Fly|Ride"] = 599.68}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 5.44, ["Ride"] = 53.53, ["Fly|Ride"] = 133.88, ["Neon"] = 33, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 212.28, ["Mega"] = 262.5, ["Mega|Fly"] = 569.64, ["Mega|Ride"] = 257.28, ["Mega|Fly|Ride"] = 451.23}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 41.11, ["Ride"] = 13.55, ["Fly|Ride"] = 71.49, ["Neon"] = 2.1, ["Neon|Fly"] = 42.71, ["Neon|Ride"] = 15.49, ["Neon|Fly|Ride"] = 75.51, ["Mega"] = 14.6, ["Mega|Fly"] = 32.65, ["Mega|Ride"] = 28.84, ["Mega|Fly|Ride"] = 143.03}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 5.25, ["Fly"] = 54.44, ["Ride"] = 32.65, ["Fly|Ride"] = 106.32, ["Neon"] = 28.25, ["Neon|Fly"] = 120.91, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 228.41, ["Mega"] = 196.87, ["Mega|Ride"] = 208.69, ["Mega|Fly|Ride"] = 360.29}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 312.17, ["Ride"] = 308.42, ["Fly|Ride"] = 442.8, ["Neon"] = 1312.5, ["Neon|Ride"] = 1283.63, ["Neon|Fly|Ride"] = 1252.12, ["Mega|Ride"] = 9377.17, ["Mega|Fly|Ride"] = 4678.56}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 85.55, ["Ride"] = 114.09, ["Fly|Ride"] = 284.82, ["Neon"] = 577.5, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 585.27, ["Mega"] = 2276.35, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1704.94}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 16.85, ["Ride"] = 15.32, ["Fly|Ride"] = 48.37, ["Neon"] = 8.43, ["Neon|Fly"] = 45.02, ["Neon|Ride"] = 34.17, ["Neon|Fly|Ride"] = 64.05, ["Mega|Fly"] = 212.28, ["Mega|Ride"] = 83.22, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 19.15, ["Ride"] = 14.05, ["Fly|Ride"] = 35.6, ["Neon"] = 6.29, ["Neon|Fly"] = 52.69, ["Neon|Ride"] = 25.54, ["Neon|Fly|Ride"] = 50.22, ["Mega"] = 65.54, ["Mega|Fly"] = 356.29, ["Mega|Ride"] = 116.82, ["Mega|Fly|Ride"] = 161.24}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 3.55, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 65.63, ["Mega"] = 277.36, ["Mega|Ride"] = 426.69}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 248.97, ["Fly"] = 420, ["Ride"] = 249.38, ["Fly|Ride"] = 263.6, ["Neon"] = 1155, ["Neon|Ride"] = 2134.5, ["Neon|Fly|Ride"] = 1578.73, ["Mega|Ride"] = 8533.61, ["Mega|Fly|Ride"] = 3099.91}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 4.5, ["Fly"] = 22.67, ["Ride"] = 16.32, ["Fly|Ride"] = 39.45, ["Neon"] = 14.44, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 39.25, ["Neon|Fly|Ride"] = 57.64, ["Mega"] = 255.94, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 429.9}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 2.63, ["Ride"] = 34.13, ["Fly|Ride"] = 213.39, ["Neon"] = 51.24, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 253.32, ["Mega|Ride"] = 288.65, ["Mega|Fly|Ride"] = 456.57}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 82.68, ["Neon"] = 6.17, ["Neon|Ride"] = 155.92, ["Mega"] = 71.48, ["Mega|Ride"] = 213.35}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 12.29, ["Fly"] = 31.5, ["Ride"] = 21.4, ["Fly|Ride"] = 78.96, ["Neon"] = 80.98, ["Neon|Ride"] = 99.56, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 510.57, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 587.9}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 32.24, ["Fly"] = 120.89, ["Ride"] = 78.74, ["Fly|Ride"] = 196.87, ["Neon"] = 137.43, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 161.44, ["Neon|Fly|Ride"] = 279.37, ["Mega"] = 451.98, ["Mega|Fly"] = 2240.07, ["Mega|Ride"] = 475.13, ["Mega|Fly|Ride"] = 572.81}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 26.16, ["Fly"] = 63, ["Ride"] = 61.69, ["Fly|Ride"] = 100.3, ["Neon"] = 213.46, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 143.03, ["Neon|Fly|Ride"] = 223.13, ["Mega|Ride"] = 700.87, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 20.86, ["Ride"] = 14.94, ["Fly|Ride"] = 42.32, ["Neon"] = 2.1, ["Neon|Fly"] = 27.47, ["Neon|Ride"] = 18.14, ["Neon|Fly|Ride"] = 47.15, ["Mega"] = 18.23, ["Mega|Fly"] = 426.69, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 184.72, ["Ride"] = 226.31, ["Fly|Ride"] = 295.32, ["Neon"] = 2103.68, ["Neon|Fly|Ride"] = 1280.71, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 7.19, ["Fly"] = 101.19, ["Ride"] = 49.39, ["Fly|Ride"] = 105, ["Neon"] = 128.09, ["Neon|Ride"] = 209.2, ["Neon|Fly|Ride"] = 128.09, ["Mega|Ride"] = 725.05, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 32.29, ["Ride"] = 18.36, ["Fly|Ride"] = 42.09, ["Neon"] = 6.23, ["Neon|Ride"] = 27.35, ["Neon|Fly|Ride"] = 113.14, ["Mega"] = 62.95, ["Mega|Fly"] = 284.83, ["Mega|Ride"] = 85.36, ["Mega|Fly|Ride"] = 157.89}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 32.02, ["Ride"] = 20.69, ["Fly|Ride"] = 44.18, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.55, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 20.89, ["Mega|Fly"] = 142.95, ["Mega|Ride"] = 62.95, ["Mega|Fly|Ride"] = 142.95}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 28.74, ["Fly|Ride"] = 72.19, ["Neon"] = 9.59, ["Neon|Fly"] = 725.41, ["Neon|Ride"] = 57.66, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 103.68, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 6.35, ["Fly"] = 38.66, ["Ride"] = 19.59, ["Fly|Ride"] = 62.37, ["Neon"] = 49.74, ["Neon|Fly"] = 306.32, ["Neon|Ride"] = 45.48, ["Neon|Fly|Ride"] = 112.21, ["Mega"] = 355.69, ["Mega|Ride"] = 236.24, ["Mega|Fly|Ride"] = 400.87}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 12.88, ["Ride"] = 183.63, ["Neon"] = 53.47, ["Neon|Fly|Ride"] = 314.99, ["Mega"] = 318.94, ["Mega|Ride"] = 426.69, ["Mega|Fly|Ride"] = 412.83}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 43.96, ["Neon"] = 3.62, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 100.36, ["Mega"] = 47.08, ["Mega|Ride"] = 77.35, ["Mega|Fly|Ride"] = 131.24}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 5.6, ["Ride"] = 26.54, ["Fly|Ride"] = 131.25, ["Neon"] = 24.86, ["Neon|Fly"] = 102.8, ["Neon|Ride"] = 45, ["Neon|Fly|Ride"] = 272.86, ["Mega"] = 253.88, ["Mega|Ride"] = 191.87, ["Mega|Fly|Ride"] = 274.32}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 81.1, ["Neon"] = 6.33, ["Neon|Fly"] = 114.21, ["Neon|Ride"] = 45.78, ["Neon|Fly|Ride"] = 102.31, ["Mega"] = 24.92, ["Mega|Ride"] = 91.34, ["Mega|Fly|Ride"] = 138.69}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 43.63, ["Ride"] = 17.42, ["Fly|Ride"] = 55.91, ["Neon"] = 6.13, ["Neon|Ride"] = 20.89, ["Neon|Fly|Ride"] = 123.81, ["Mega"] = 52.03, ["Mega|Ride"] = 123.26, ["Mega|Fly|Ride"] = 284.83}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 767.46, ["Ride"] = 748.13, ["Fly|Ride"] = 892.24, ["Neon|Fly|Ride"] = 3609.37}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 19.22, ["Ride"] = 14.68, ["Fly|Ride"] = 36.12, ["Neon"] = 13.11, ["Neon|Fly"] = 140.88, ["Neon|Ride"] = 35.79, ["Neon|Fly|Ride"] = 113.66, ["Mega|Fly|Ride"] = 426.69}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 45.93, ["Fly|Ride"] = 210, ["Neon"] = 7.93, ["Neon|Fly"] = 747.08, ["Neon|Ride"] = 88.56, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 55.11, ["Mega|Fly"] = 213.35, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 7.44, ["Fly"] = 36.23, ["Ride"] = 22.31, ["Fly|Ride"] = 47.25, ["Neon"] = 41.12, ["Neon|Fly"] = 193.27, ["Neon|Ride"] = 50.18, ["Neon|Fly|Ride"] = 97.12, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 296.13}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.62, ["Fly|Ride"] = 33.04, ["Neon"] = 4.86, ["Neon|Fly"] = 64.32, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 63, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 85.22, ["Mega|Fly|Ride"] = 142.93}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 32.81, ["Fly"] = 105, ["Ride"] = 83.06, ["Fly|Ride"] = 284.87, ["Neon"] = 196.88, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 1422.99}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 19.57, ["Fly|Ride"] = 64.26, ["Neon"] = 3.94, ["Neon|Fly"] = 137.84, ["Neon|Ride"] = 29.88, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 47.25, ["Mega|Ride"] = 131.36, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 32.65, ["Ride"] = 22.99, ["Fly|Ride"] = 61.89, ["Neon"] = 9.07, ["Neon|Ride"] = 41.88, ["Neon|Fly|Ride"] = 114.21, ["Mega"] = 95.82, ["Mega|Ride"] = 198.59, ["Mega|Fly|Ride"] = 351.74}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.37, ["Fly|Ride"] = 59.07, ["Neon"] = 26.25, ["Mega"] = 95.47, ["Mega|Ride"] = 160.01, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 17.06, ["Fly|Ride"] = 49.87, ["Neon"] = 3.84, ["Neon|Fly"] = 20.29, ["Neon|Ride"] = 24.55, ["Neon|Fly|Ride"] = 103.84, ["Mega"] = 41.1, ["Mega|Fly"] = 229.68, ["Mega|Ride"] = 64.87, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 9.17, ["Fly"] = 19.99, ["Ride"] = 18.15, ["Fly|Ride"] = 32.65, ["Neon"] = 105, ["Neon|Ride"] = 80.85, ["Neon|Fly|Ride"] = 103.24, ["Mega|Ride"] = 467.22, ["Mega|Fly|Ride"] = 467.13}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 714.66, ["Ride"] = 718.55, ["Fly|Ride"] = 855.75, ["Neon"] = 1800.93, ["Neon|Ride"] = 1967.44, ["Neon|Fly|Ride"] = 2163, ["Mega"] = 4654.5, ["Mega|Fly|Ride"] = 6445.6}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 18.37, ["Ride"] = 15.65, ["Fly|Ride"] = 34.01, ["Neon"] = 4.38, ["Neon|Ride"] = 19.36, ["Neon|Fly|Ride"] = 36.3, ["Mega"] = 44.63, ["Mega|Ride"] = 57.73, ["Mega|Fly|Ride"] = 143.06}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 4.54, ["Ride"] = 32.81, ["Fly|Ride"] = 201.92, ["Neon"] = 47.15, ["Neon|Fly"] = 72.56, ["Neon|Ride"] = 106.78, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 366.17, ["Mega|Ride"] = 351.2, ["Mega|Fly|Ride"] = 537.24}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 49.88, ["Fly"] = 104.9, ["Ride"] = 63.41, ["Fly|Ride"] = 111.57, ["Neon"] = 424.77, ["Neon|Ride"] = 421.42, ["Neon|Fly|Ride"] = 389.11, ["Mega"] = 2439.83, ["Mega|Fly|Ride"] = 1564.87}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 28.87, ["Ride"] = 53.36, ["Fly|Ride"] = 104.89, ["Neon"] = 187.69, ["Neon|Ride"] = 224.14, ["Neon|Fly|Ride"] = 213.46, ["Mega"] = 983.89, ["Mega|Ride"] = 896.44, ["Mega|Fly|Ride"] = 1064.58}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 8.38, ["Fly"] = 84.63, ["Ride"] = 26.23, ["Fly|Ride"] = 140.91, ["Neon"] = 56.6, ["Neon|Ride"] = 67.72, ["Neon|Fly|Ride"] = 123.81, ["Mega"] = 305.82, ["Mega|Fly|Ride"] = 528.04}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 26.76, ["Ride"] = 57.63, ["Neon"] = 103.68, ["Neon|Ride"] = 71.52, ["Neon|Fly|Ride"] = 144.77, ["Mega"] = 236.25, ["Mega|Fly"] = 524.46, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 784.23}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 16.12, ["Ride"] = 36.29, ["Fly|Ride"] = 153.71, ["Neon"] = 124.69, ["Neon|Ride"] = 322.81, ["Neon|Fly|Ride"] = 525, ["Mega"] = 924, ["Mega|Ride"] = 640.03, ["Mega|Fly|Ride"] = 563.21}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 4.45}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 3.03, ["Ride"] = 23.71, ["Fly|Ride"] = 59.05, ["Neon"] = 33.78, ["Neon|Ride"] = 81.02, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 196.27, ["Mega|Fly"] = 482.16, ["Mega|Ride"] = 233.63, ["Mega|Fly|Ride"] = 287.81}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.93, ["Ride"] = 28.93, ["Neon"] = 11.81, ["Neon|Fly|Ride"] = 213.35, ["Mega"] = 140.44, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 37.21, ["Fly"] = 62.99, ["Ride"] = 52.22, ["Fly|Ride"] = 90.24, ["Neon"] = 203.34, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 640.36, ["Mega|Ride"] = 1706.74, ["Mega|Fly|Ride"] = 853.37}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 2.18, ["Fly"] = 16.02, ["Ride"] = 15.01, ["Fly|Ride"] = 33.83, ["Neon"] = 21.36, ["Neon|Fly"] = 57.64, ["Neon|Ride"] = 31.95, ["Neon|Fly|Ride"] = 73.39, ["Mega"] = 198.18, ["Mega|Fly"] = 425.63, ["Mega|Ride"] = 184.16, ["Mega|Fly|Ride"] = 277.1}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 4.45, ["Fly"] = 37.35, ["Ride"] = 27.43, ["Fly|Ride"] = 70.16, ["Neon"] = 19.22, ["Neon|Ride"] = 41.91, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 136.04, ["Mega|Ride"] = 169.31, ["Mega|Fly|Ride"] = 236.15}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 6.07, ["Mega"] = 39.29, ["Mega|Ride"] = 196.59, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 24.94, ["Fly"] = 77.96, ["Ride"] = 52.49, ["Fly|Ride"] = 91.77, ["Neon"] = 183.75, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 294.58, ["Mega|Ride"] = 849.52, ["Mega|Fly|Ride"] = 1063.52}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 20.57, ["Fly|Ride"] = 65.63, ["Neon"] = 3.72, ["Neon|Ride"] = 28.84, ["Mega"] = 76.13, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 462.41}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 10.4, ["Ride"] = 81.01, ["Fly|Ride"] = 283.81, ["Neon"] = 87.77, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 392.44, ["Mega|Fly|Ride"] = 711.51}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 14.95, ["Fly|Ride"] = 24.55, ["Neon"] = 91.47, ["Neon|Ride"] = 38.7, ["Neon|Fly|Ride"] = 76.64, ["Mega|Ride"] = 208.04, ["Mega|Fly|Ride"] = 322.65}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 19.3, ["Fly|Ride"] = 75.12, ["Neon"] = 36.75, ["Neon|Ride"] = 30.18, ["Mega"] = 291.38, ["Mega|Ride"] = 425.63, ["Mega|Fly|Ride"] = 412.79}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 2.29, ["Ride"] = 67.24, ["Neon"] = 39.37, ["Neon|Ride"] = 227.06, ["Mega"] = 413.86, ["Mega|Ride"] = 956.1}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 39.19, ["Ride"] = 100.3, ["Neon"] = 279.8, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 426.91, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 19.02, ["Ride"] = 284.87, ["Neon"] = 105.68, ["Neon|Ride"] = 183.75, ["Mega"] = 424.36, ["Mega|Ride"] = 426.69, ["Mega|Fly|Ride"] = 597.37}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 4.28, ["Ride"] = 125.98, ["Neon"] = 174.58, ["Neon|Fly"] = 213.46, ["Neon|Ride"] = 426.91, ["Mega"] = 284.83, ["Mega|Ride"] = 852.31}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 21.84, ["Ride"] = 232.32, ["Fly|Ride"] = 367.46, ["Neon"] = 103.36, ["Neon|Ride"] = 747.08, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 592.37, ["Mega|Fly"] = 2133.41, ["Mega|Fly|Ride"] = 1128.66}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.5, ["Neon"] = 13.12, ["Neon|Ride"] = 32.66, ["Mega"] = 210, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 322.65}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 27.76, ["Ride"] = 18.37, ["Fly|Ride"] = 40.61, ["Neon"] = 4.18, ["Neon|Fly"] = 43.01, ["Neon|Ride"] = 41.9, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 66.68, ["Mega|Ride"] = 86.6, ["Mega|Fly|Ride"] = 321.57}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 2.1, ["Ride"] = 42.7, ["Fly|Ride"] = 65.63, ["Neon"] = 12.66, ["Neon|Ride"] = 70.02, ["Neon|Fly|Ride"] = 120.65, ["Mega"] = 87.94, ["Mega|Ride"] = 160.93, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 142.97, ["Ride"] = 19.47, ["Fly|Ride"] = 57.63, ["Neon"] = 5.03, ["Neon|Ride"] = 26.15, ["Neon|Fly|Ride"] = 105, ["Mega"] = 41.91, ["Mega|Fly"] = 170.69, ["Mega|Ride"] = 77.87, ["Mega|Fly|Ride"] = 192.95}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.3, ["Fly"] = 65.62, ["Ride"] = 23.51, ["Fly|Ride"] = 118.13, ["Neon"] = 15.73, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 328.02, ["Mega|Ride"] = 337.1, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.46, ["Fly"] = 65.63, ["Ride"] = 21.3, ["Neon"] = 26.61, ["Neon|Fly"] = 315, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 143.03, ["Mega"] = 302.45, ["Mega|Ride"] = 287.47}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 2.45, ["Fly"] = 131.25, ["Ride"] = 16.02, ["Fly|Ride"] = 78, ["Neon"] = 28.84, ["Neon|Fly"] = 112.73, ["Neon|Ride"] = 37.37, ["Neon|Fly|Ride"] = 102.92, ["Mega"] = 358.43, ["Mega|Ride"] = 318.96, ["Mega|Fly|Ride"] = 396.38}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.13, ["Ride"] = 21.36, ["Fly|Ride"] = 51.89, ["Neon"] = 19.18, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 106.74, ["Mega"] = 252.82, ["Mega|Ride"] = 213.35, ["Mega|Fly|Ride"] = 186.18}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 3.26, ["Fly"] = 57.66, ["Ride"] = 43.29, ["Fly|Ride"] = 87.93, ["Neon"] = 18.64, ["Neon|Fly"] = 436.96, ["Neon|Ride"] = 45.47, ["Neon|Fly|Ride"] = 128.44, ["Mega"] = 117.91, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 132.56, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 15.54, ["Fly"] = 207.74, ["Ride"] = 99.56, ["Fly|Ride"] = 196.77, ["Neon"] = 118.13, ["Neon|Ride"] = 234.21, ["Neon|Fly|Ride"] = 420, ["Mega"] = 540.28, ["Mega|Ride"] = 546, ["Mega|Fly|Ride"] = 672.98}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 49.88, ["Fly"] = 164.07, ["Ride"] = 93.65, ["Fly|Ride"] = 181.13, ["Neon"] = 221.81, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 492.19, ["Mega"] = 1563.79, ["Mega|Ride"] = 1061.82, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 50.97, ["Ride"] = 18.36, ["Fly|Ride"] = 65.56, ["Neon"] = 2.1, ["Neon|Ride"] = 24.24, ["Mega"] = 27.61, ["Mega|Ride"] = 47.16, ["Mega|Fly|Ride"] = 143.92}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 6.07, ["Ride"] = 52.5, ["Neon"] = 284.96, ["Mega|Ride"] = 533.36, ["Mega|Fly|Ride"] = 1063.52}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 57.66, ["Fly"] = 105, ["Ride"] = 78.75, ["Fly|Ride"] = 183.75, ["Neon"] = 290.22, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 852.73, ["Mega"] = 1748.34, ["Mega|Ride"] = 1194.73}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 5.25, ["Fly"] = 190.32, ["Ride"] = 28.63, ["Fly|Ride"] = 133.88, ["Neon"] = 34.13, ["Neon|Ride"] = 83.26, ["Neon|Fly|Ride"] = 210, ["Mega"] = 192.93, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 312.38}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 3.03, ["Ride"] = 65.37, ["Fly|Ride"] = 142.97, ["Neon"] = 9.81, ["Neon|Ride"] = 67.39, ["Mega"] = 84.96, ["Mega|Fly"] = 310.84, ["Mega|Ride"] = 146.86, ["Mega|Fly|Ride"] = 364.88}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 39.25, ["Ride"] = 16.93, ["Fly|Ride"] = 52.67, ["Neon"] = 10.02, ["Neon|Ride"] = 37.02, ["Neon|Fly|Ride"] = 70.87, ["Mega"] = 236.14, ["Mega|Ride"] = 212.28, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.75, ["Ride"] = 14.18, ["Fly|Ride"] = 42.7, ["Neon"] = 2.62, ["Neon|Fly"] = 19.29, ["Neon|Ride"] = 27, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 28.88, ["Mega|Ride"] = 69.55, ["Mega|Fly|Ride"] = 150.73}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 19.04, ["Fly|Ride"] = 92.03, ["Neon"] = 3.3, ["Neon|Ride"] = 28.84, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 38.84, ["Mega|Ride"] = 61.16, ["Mega|Fly|Ride"] = 182.44}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.49, ["Fly|Ride"] = 120.89, ["Neon"] = 2.1, ["Neon|Ride"] = 145.08, ["Mega"] = 25.74, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 5.69, ["Ride"] = 104.98, ["Neon"] = 30.54, ["Neon|Ride"] = 162.02, ["Neon|Fly|Ride"] = 640.36, ["Mega"] = 425.63, ["Mega|Ride"] = 269.48, ["Mega|Fly|Ride"] = 322.65}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 5.04, ["Ride"] = 31.62, ["Fly|Ride"] = 198.26, ["Neon"] = 52.86, ["Neon|Ride"] = 100.34, ["Neon|Fly|Ride"] = 143.03, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 4.72, ["Fly"] = 41.1, ["Ride"] = 16.99, ["Fly|Ride"] = 39.16, ["Neon"] = 31.05, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 81.53, ["Mega|Ride"] = 405.37, ["Mega|Fly|Ride"] = 352.69}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 56.35, ["Ride"] = 73.5, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 597.19, ["Mega"] = 2416.81, ["Mega|Fly|Ride"] = 1472.63}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 24.92, ["Fly"] = 82.68, ["Ride"] = 32.82, ["Fly|Ride"] = 142.97, ["Neon"] = 284.87, ["Neon|Fly|Ride"] = 630, ["Mega"] = 635.92, ["Mega|Ride"] = 689.73, ["Mega|Fly|Ride"] = 694.98}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 26.61, ["Ride"] = 15.75, ["Fly|Ride"] = 38.06, ["Neon"] = 2.59, ["Neon|Fly"] = 36.3, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 59.78, ["Mega"] = 32.71, ["Mega|Ride"] = 89.74, ["Mega|Fly|Ride"] = 188.98}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 16.49, ["Ride"] = 14.28, ["Fly|Ride"] = 31.14, ["Neon"] = 3.77, ["Neon|Fly"] = 24.34, ["Neon|Ride"] = 19.02, ["Neon|Fly|Ride"] = 44.54, ["Mega"] = 43.31, ["Mega|Fly"] = 92.81, ["Mega|Ride"] = 57.05, ["Mega|Fly|Ride"] = 90.85}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 525, ["Fly"] = 616.51, ["Ride"] = 446.24, ["Fly|Ride"] = 559.13, ["Neon|Fly|Ride"] = 1903.12}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 3.71, ["Ride"] = 36.28, ["Fly|Ride"] = 535.43, ["Neon"] = 46.27, ["Neon|Ride"] = 80.31, ["Mega"] = 403.49, ["Mega|Ride"] = 400.32, ["Mega|Fly|Ride"] = 284453.56}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 14.94, ["Ride"] = 17.81, ["Fly|Ride"] = 30.91, ["Neon"] = 4.31, ["Neon|Fly"] = 18.38, ["Neon|Ride"] = 17.1, ["Neon|Fly|Ride"] = 40.32, ["Mega"] = 142.95, ["Mega|Ride"] = 74.99, ["Mega|Fly|Ride"] = 112.73}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 55.04, ["Ride"] = 93.09, ["Fly|Ride"] = 298.73, ["Neon"] = 262.4, ["Neon|Ride"] = 308.22, ["Neon|Fly|Ride"] = 443.63, ["Mega"] = 721.88, ["Mega|Ride"] = 761.25, ["Mega|Fly|Ride"] = 882.79}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 19.48, ["Ride"] = 16.66, ["Fly|Ride"] = 51.19, ["Neon"] = 8.91, ["Neon|Fly"] = 62.98, ["Neon|Ride"] = 24.49, ["Neon|Fly|Ride"] = 63.84, ["Mega"] = 111.37, ["Mega|Ride"] = 124.85, ["Mega|Fly|Ride"] = 215.2}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 21, ["Neon"] = 3.41, ["Neon|Ride"] = 35.43, ["Neon|Fly|Ride"] = 74.81, ["Mega"] = 18.35, ["Mega|Ride"] = 60.27, ["Mega|Fly|Ride"] = 190.88}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 40.69, ["Fly"] = 107.89, ["Ride"] = 73.11, ["Fly|Ride"] = 213.84, ["Neon"] = 157.11, ["Neon|Ride"] = 191.27, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 996.32, ["Mega|Ride"] = 960.04, ["Mega|Fly|Ride"] = 792.75}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 19.67, ["Fly|Ride"] = 52.5, ["Neon"] = 4.09, ["Neon|Ride"] = 39.99, ["Neon|Fly|Ride"] = 79, ["Mega"] = 36.75, ["Mega|Ride"] = 195.2, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 25.6, ["Ride"] = 66.94, ["Fly|Ride"] = 159.58, ["Neon"] = 341.53, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 288.46, ["Mega"] = 1685.4, ["Mega|Ride"] = 1706.74, ["Mega|Fly|Ride"] = 1536.06}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.09, ["Ride"] = 183.74, ["Neon"] = 21.94, ["Neon|Ride"] = 28.84, ["Neon|Fly|Ride"] = 157.97, ["Mega"] = 157.5, ["Mega|Ride"] = 200.82}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 71.49, ["Ride"] = 72.76, ["Fly|Ride"] = 68.3, ["Neon"] = 8.54, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 429.19, ["Mega"] = 95.45, ["Mega|Ride"] = 170.69, ["Mega|Fly|Ride"] = 569.64}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 41.83, ["Fly"] = 142.97, ["Ride"] = 50.92, ["Fly|Ride"] = 533.45, ["Mega|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 1834.73}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 24.76, ["Fly|Ride"] = 908.99, ["Neon"] = 4.19, ["Neon|Fly"] = 85.39, ["Neon|Ride"] = 39.89, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 45.19, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 105.25, ["Mega|Fly|Ride"] = 153.62}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 18.85, ["Ride"] = 19.69, ["Fly|Ride"] = 102.85, ["Neon"] = 10.9, ["Neon|Fly"] = 47.77, ["Neon|Ride"] = 32.63, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 96.68, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 5.93, ["Fly"] = 58.49, ["Ride"] = 31.5, ["Fly|Ride"] = 75.79, ["Neon"] = 81.78, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 143.03, ["Mega"] = 452.29, ["Mega|Ride"] = 398.95, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 6.36, ["Fly"] = 57.11, ["Ride"] = 29.04, ["Fly|Ride"] = 71.54, ["Neon"] = 65.62, ["Neon|Ride"] = 74.75, ["Neon|Fly|Ride"] = 159.45, ["Mega"] = 933.38, ["Mega|Ride"] = 450.12, ["Mega|Fly|Ride"] = 511.76}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 23.78, ["Fly"] = 51.18, ["Ride"] = 25.73, ["Fly|Ride"] = 52.5, ["Neon"] = 48.37, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 140.89, ["Mega"] = 569.64, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 393.63}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 59.06, ["Fly"] = 139.36, ["Ride"] = 113.45, ["Fly|Ride"] = 249.38, ["Neon"] = 315, ["Neon|Ride"] = 423.94, ["Neon|Fly|Ride"] = 647.83, ["Mega|Ride"] = 1488.06, ["Mega|Fly|Ride"] = 1309.87}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.92, ["Ride"] = 28.88, ["Neon"] = 24.05, ["Neon|Ride"] = 121.68, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 234.94, ["Mega|Ride"] = 462, ["Mega|Fly|Ride"] = 370.16}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.78, ["Ride"] = 26.67, ["Fly|Ride"] = 78.74, ["Neon"] = 15.71, ["Neon|Ride"] = 41.96, ["Neon|Fly|Ride"] = 213.35, ["Mega"] = 143.42, ["Mega|Ride"] = 183.74, ["Mega|Fly|Ride"] = 246.62}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 7.12, ["Fly"] = 287.55, ["Ride"] = 28.45, ["Fly|Ride"] = 114.35, ["Neon"] = 84, ["Neon|Ride"] = 141.42, ["Neon|Fly|Ride"] = 241.81, ["Mega"] = 451.96, ["Mega|Ride"] = 498.17, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 14.6, ["Ride"] = 14.42, ["Fly|Ride"] = 36.71, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 14.13, ["Neon|Fly|Ride"] = 39.25, ["Mega"] = 15.36, ["Mega|Ride"] = 48.2, ["Mega|Fly|Ride"] = 94.79}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 42.26, ["Fly"] = 226.19, ["Ride"] = 112.55, ["Fly|Ride"] = 284.87, ["Neon"] = 262.4, ["Neon|Fly"] = 2419.45, ["Neon|Ride"] = 277.71, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 3200.11, ["Mega|Ride"] = 1001.37, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 21.59, ["Fly|Ride"] = 36.29, ["Neon"] = 3.59, ["Neon|Ride"] = 28.29, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 269.89, ["Mega|Ride"] = 140.58, ["Mega|Fly|Ride"] = 301.87}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.82, ["Ride"] = 16.67, ["Fly|Ride"] = 59.06, ["Neon"] = 15.75, ["Neon|Ride"] = 29.1, ["Neon|Fly|Ride"] = 89.13, ["Mega"] = 257.25, ["Mega|Ride"] = 192.93, ["Mega|Fly|Ride"] = 280.73}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 49.26, ["Fly"] = 157.5, ["Ride"] = 104.9, ["Fly|Ride"] = 258.57, ["Neon"] = 278.25, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 569.92, ["Mega"] = 940.74, ["Mega|Ride"] = 1491.26, ["Mega|Fly|Ride"] = 1715.44}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 23.52, ["Neon"] = 6.46, ["Neon|Fly"] = 27.57, ["Neon|Ride"] = 52.41, ["Mega"] = 64.32, ["Mega|Ride"] = 108.02, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 9.18}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Fly|Ride"] = 497.17, ["Neon"] = 4.55, ["Neon|Ride"] = 51.87, ["Neon|Fly|Ride"] = 157.89, ["Mega"] = 46.29, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 217.14}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 114.34, ["Ride"] = 124.69, ["Fly|Ride"] = 348.88, ["Neon"] = 836.07, ["Neon|Ride"] = 709.68, ["Neon|Fly|Ride"] = 917.44, ["Mega"] = 3413.46, ["Mega|Ride"] = 2493.75, ["Mega|Fly|Ride"] = 2835}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 4.29, ["Ride"] = 36.37, ["Fly|Ride"] = 213.39, ["Neon"] = 19.19, ["Neon|Fly"] = 143.03, ["Neon|Ride"] = 64.32, ["Mega"] = 178.39, ["Mega|Ride"] = 211.31, ["Mega|Fly|Ride"] = 645.29}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 36.29, ["Neon"] = 3.72, ["Neon|Ride"] = 20.44, ["Mega"] = 31.2, ["Mega|Ride"] = 104.55, ["Mega|Fly|Ride"] = 71.48}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 4.93, ["Ride"] = 19.83, ["Fly|Ride"] = 131.25, ["Neon"] = 51.35, ["Neon|Ride"] = 65.3, ["Neon|Fly|Ride"] = 162.02, ["Mega"] = 390.43, ["Mega|Ride"] = 426.69, ["Mega|Fly|Ride"] = 625.64}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 10.28, ["Fly"] = 68.72, ["Ride"] = 21.36, ["Fly|Ride"] = 56.58, ["Neon"] = 99, ["Neon|Ride"] = 156.19, ["Neon|Fly|Ride"] = 307.79, ["Mega"] = 626.07, ["Mega|Ride"] = 574.88, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 22.4, ["Ride"] = 71.51, ["Fly|Ride"] = 128.15, ["Neon"] = 172.09, ["Neon|Ride"] = 177.17, ["Neon|Fly|Ride"] = 483.37, ["Mega"] = 560.44, ["Mega|Ride"] = 654.97, ["Mega|Fly|Ride"] = 584.07}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 116.81, ["Fly"] = 196.88, ["Ride"] = 163.46, ["Fly|Ride"] = 207.9, ["Neon"] = 565.13, ["Neon|Ride"] = 590.4, ["Neon|Fly|Ride"] = 654.94, ["Mega|Fly|Ride"] = 2537.64}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 262.5, ["Fly"] = 419.47, ["Ride"] = 498.75, ["Fly|Ride"] = 918.75, ["Neon|Ride"] = 1280.71, ["Neon|Fly|Ride"] = 1280.06, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 131.15, ["Ride"] = 21, ["Fly|Ride"] = 131.23, ["Neon"] = 15.74, ["Neon|Ride"] = 32.78, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 138.69, ["Mega|Ride"] = 140.32, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 6.39, ["Fly"] = 98.43, ["Ride"] = 26.16, ["Fly|Ride"] = 170.71, ["Neon"] = 49.09, ["Neon|Ride"] = 80.07, ["Neon|Fly|Ride"] = 198.3, ["Mega"] = 379.32, ["Mega|Ride"] = 433.13, ["Mega|Fly|Ride"] = 569.64}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 47.99, ["Fly"] = 159.58, ["Ride"] = 76.13, ["Fly|Ride"] = 166.69, ["Neon"] = 223.12, ["Neon|Ride"] = 333.69, ["Neon|Fly|Ride"] = 456.57, ["Mega"] = 960.04, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 17.61, ["Ride"] = 83.99, ["Neon"] = 91.88, ["Neon|Ride"] = 185.77, ["Neon|Fly|Ride"] = 470.67, ["Mega"] = 704.84, ["Mega|Ride"] = 503.06}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.39, ["Ride"] = 615.57, ["Neon|Ride"] = 3224.34, ["Neon|Fly|Ride"] = 1376.82}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 28.65, ["Fly"] = 57.63, ["Ride"] = 32.7, ["Fly|Ride"] = 75.71, ["Neon"] = 196.88, ["Neon|Ride"] = 229.69, ["Neon|Fly|Ride"] = 322.65, ["Mega"] = 761.25, ["Mega|Ride"] = 734.9, ["Mega|Fly|Ride"] = 1065.65}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 38.66, ["Ride"] = 13.67, ["Fly|Ride"] = 31.5, ["Neon"] = 2.1, ["Neon|Ride"] = 17.32, ["Neon|Fly|Ride"] = 48.83, ["Mega"] = 20.47, ["Mega|Fly"] = 104.55, ["Mega|Ride"] = 35, ["Mega|Fly|Ride"] = 105.98}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.13, ["Neon"] = 10.23, ["Neon|Ride"] = 57.64, ["Neon|Fly|Ride"] = 143.03, ["Mega|Ride"] = 120.86}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 16.02, ["Ride"] = 23.62, ["Fly|Ride"] = 144.21, ["Neon"] = 20.45, ["Neon|Ride"] = 83.06, ["Neon|Fly|Ride"] = 981.05, ["Mega"] = 115.31, ["Mega|Fly"] = 498.61, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 393.75, ["Fly"] = 498.6, ["Ride"] = 354.37, ["Fly|Ride"] = 525, ["Neon"] = 1424.39, ["Neon|Ride"] = 1773.58, ["Neon|Fly|Ride"] = 1615.82, ["Mega|Fly|Ride"] = 5504.18}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 3.92, ["Fly"] = 20.62, ["Ride"] = 17.07, ["Fly|Ride"] = 49.86, ["Neon"] = 24.55, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 87.44, ["Mega"] = 170.63, ["Mega|Ride"] = 213.93, ["Mega|Fly|Ride"] = 563.07}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 5.8, ["Fly"] = 19.99, ["Ride"] = 17.75, ["Fly|Ride"] = 44.63, ["Neon"] = 24.55, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 59.78, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 272.03, ["Mega|Fly|Ride"] = 286.38}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 2.1, ["Fly"] = 32.45, ["Ride"] = 28.88, ["Fly|Ride"] = 78.75, ["Neon"] = 16.7, ["Neon|Fly"] = 94.49, ["Neon|Ride"] = 55.62, ["Neon|Fly|Ride"] = 80.67, ["Mega"] = 123.27, ["Mega|Ride"] = 256.03, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 28.85, ["Fly"] = 44.66, ["Ride"] = 42.7, ["Fly|Ride"] = 65.63, ["Neon"] = 162.02, ["Neon|Ride"] = 176.52, ["Neon|Fly|Ride"] = 319.12, ["Mega"] = 1312.5, ["Mega|Ride"] = 852.31, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 34, ["Fly|Ride"] = 49.68, ["Neon"] = 11.46, ["Neon|Ride"] = 37.37, ["Neon|Fly|Ride"] = 210, ["Mega"] = 163.74, ["Mega|Ride"] = 457.79, ["Mega|Fly|Ride"] = 919.42}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 7.62, ["Fly"] = 65.6, ["Ride"] = 28.25, ["Fly|Ride"] = 91.88, ["Neon"] = 168.79, ["Neon|Ride"] = 112.88, ["Mega|Ride"] = 768.04, ["Mega|Fly|Ride"] = 846.57}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.76, ["Neon"] = 5.82, ["Neon|Ride"] = 35.32, ["Mega"] = 53.83, ["Mega|Ride"] = 120.56, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 5.8, ["Fly"] = 71.49, ["Neon"] = 50.57}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 10.5, ["Ride"] = 78.96, ["Neon"] = 82.29, ["Neon|Ride"] = 483.6, ["Mega"] = 314.7, ["Mega|Ride"] = 550.44, ["Mega|Fly|Ride"] = 509.25}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 5.96, ["Fly"] = 28.97, ["Ride"] = 24.2, ["Fly|Ride"] = 52.31, ["Neon"] = 48.37, ["Neon|Fly"] = 114.22, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 599.5, ["Mega|Ride"] = 314.93, ["Mega|Fly|Ride"] = 350.03}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 343.74, ["Fly"] = 548.81, ["Ride"] = 389.11, ["Fly|Ride"] = 415.96, ["Neon"] = 1659, ["Neon|Ride"] = 1493.94, ["Neon|Fly|Ride"] = 1428.8, ["Mega|Fly|Ride"] = 5250}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.62, ["Fly|Ride"] = 36.29, ["Neon"] = 13.01, ["Neon|Fly"] = 81.02, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 131.92, ["Mega"] = 206.95, ["Mega|Ride"] = 196.77}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 2.59, ["Ride"] = 100.3, ["Fly|Ride"] = 91.76, ["Neon"] = 60.25, ["Neon|Ride"] = 157.97, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 340.19, ["Mega|Fly"] = 711.51, ["Mega|Ride"] = 411.64}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 21.84, ["Ride"] = 84, ["Fly|Ride"] = 315, ["Neon"] = 75.55, ["Neon|Ride"] = 181.92, ["Neon|Fly|Ride"] = 351.83, ["Mega"] = 365.98, ["Mega|Ride"] = 369.81, ["Mega|Fly|Ride"] = 580.05}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 136.01, ["Fly"] = 130.12, ["Ride"] = 131.25, ["Fly|Ride"] = 167.61, ["Neon"] = 887.4, ["Neon|Ride"] = 853.81, ["Neon|Fly|Ride"] = 1172.32, ["Mega"] = 2492.09, ["Mega|Ride"] = 1836.19}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 9.03, ["Fly"] = 106.71, ["Ride"] = 52.41, ["Fly|Ride"] = 137.57, ["Neon"] = 42.44, ["Neon|Ride"] = 87.08, ["Neon|Fly|Ride"] = 363.82, ["Mega"] = 282.19, ["Mega|Ride"] = 255.93, ["Mega|Fly|Ride"] = 426.8}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 28.87, ["Ride"] = 19.59, ["Fly|Ride"] = 58.46, ["Neon"] = 12.47, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 71.52, ["Mega"] = 65.6, ["Mega|Ride"] = 147.45, ["Mega|Fly|Ride"] = 261.18}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 8.73, ["Ride"] = 4.29, ["Fly|Ride"] = 64.32, ["Neon"] = 25.17, ["Neon|Ride"] = 94.17, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 176.77, ["Mega|Ride"] = 187.53}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 49.26, ["Fly"] = 183.75, ["Ride"] = 96.68, ["Fly|Ride"] = 216.57, ["Neon"] = 134.88, ["Neon|Ride"] = 157.4, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 437.64, ["Mega|Ride"] = 452.36, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 131.24, ["Neon"] = 4.86, ["Neon|Ride"] = 213.46, ["Neon|Fly|Ride"] = 199.31, ["Mega"] = 64.02, ["Mega|Ride"] = 185.77}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 15.99, ["Ride"] = 72.19, ["Neon"] = 123.38, ["Neon|Ride"] = 401.03, ["Neon|Fly|Ride"] = 853.81, ["Mega"] = 1061.38, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 1023.75, ["Fly"] = 971.25, ["Ride"] = 1061.7, ["Fly|Ride"] = 1115.63, ["Neon"] = 3395.97, ["Neon|Ride"] = 3529.38, ["Neon|Fly|Ride"] = 3281.22, ["Mega|Fly|Ride"] = 11762.54}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 14.44, ["Fly"] = 94.15, ["Ride"] = 59.7, ["Fly|Ride"] = 191.63, ["Neon"] = 117.75, ["Neon|Fly"] = 700.88, ["Neon|Ride"] = 277.49, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 337.89, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.34, ["Ride"] = 21.25, ["Fly|Ride"] = 80.92, ["Neon"] = 10.69, ["Neon|Fly"] = 57.64, ["Neon|Ride"] = 33.43, ["Neon|Fly|Ride"] = 105.68, ["Mega"] = 83.61, ["Mega|Ride"] = 98.22, ["Mega|Fly|Ride"] = 191.04}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 6.98, ["Ride"] = 47.79, ["Fly|Ride"] = 142.97, ["Neon"] = 100.34, ["Mega"] = 787.49, ["Mega|Ride"] = 541.76, ["Mega|Fly|Ride"] = 480.96}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 35.06, ["Fly|Ride"] = 182.97, ["Neon"] = 2.1, ["Neon|Ride"] = 25.64, ["Neon|Fly|Ride"] = 80.06, ["Mega"] = 16.7, ["Mega|Fly"] = 128.02, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 793.19}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 50.95, ["Ride"] = 118.72, ["Fly|Ride"] = 196.88, ["Neon"] = 260.98, ["Neon|Ride"] = 296.01, ["Neon|Fly|Ride"] = 285.27, ["Mega"] = 1106.35, ["Mega|Ride"] = 955.96, ["Mega|Fly|Ride"] = 958.13}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 7.33, ["Ride"] = 52.5, ["Fly|Ride"] = 238.87, ["Neon"] = 71.31, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 569.64, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 27.36, ["Neon"] = 8.42, ["Neon|Ride"] = 65.63, ["Mega"] = 88.92, ["Mega|Ride"] = 157.49, ["Mega|Fly|Ride"] = 426.69}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 14.88, ["Fly"] = 67.24, ["Ride"] = 41.19, ["Fly|Ride"] = 120.89, ["Neon"] = 78.11, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 155.92, ["Mega"] = 1039.49, ["Mega|Ride"] = 376.86, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 3.94, ["Fly"] = 31.89, ["Ride"] = 37.01, ["Fly|Ride"] = 96.03, ["Neon"] = 78.81, ["Neon|Ride"] = 114.45, ["Neon|Fly|Ride"] = 120.09, ["Mega"] = 569.64, ["Mega|Ride"] = 528.04, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 30.66, ["Ride"] = 208.68, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 731.73, ["Mega"] = 2103.24, ["Mega|Ride"] = 1706.74, ["Mega|Fly|Ride"] = 1692.87}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 4.66, ["Ride"] = 51.22, ["Fly|Ride"] = 199.53, ["Neon"] = 15.54, ["Neon|Ride"] = 96.07, ["Neon|Fly|Ride"] = 161.21, ["Mega"] = 137.81, ["Mega|Ride"] = 130.71, ["Mega|Fly|Ride"] = 227.05}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 3.92, ["Ride"] = 15.33, ["Fly|Ride"] = 84.29, ["Neon"] = 48.37, ["Neon|Ride"] = 59.43, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 295.32, ["Mega|Ride"] = 421.37, ["Mega|Fly|Ride"] = 612.3}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 111.37, ["Fly"] = 393.75, ["Ride"] = 180.46, ["Fly|Ride"] = 246.88, ["Neon"] = 523.99, ["Neon|Ride"] = 522.38, ["Neon|Fly|Ride"] = 783.38, ["Mega"] = 2327.07, ["Mega|Ride"] = 2418.22, ["Mega|Fly|Ride"] = 1945.13}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 21.36, ["Ride"] = 15.65, ["Fly|Ride"] = 42.7, ["Neon"] = 12.96, ["Neon|Fly"] = 57.53, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 83.09, ["Mega"] = 142.95, ["Mega|Ride"] = 238.8, ["Mega|Fly|Ride"] = 412.83}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 7.27, ["Fly"] = 197.4, ["Ride"] = 39.26, ["Fly|Ride"] = 96.71, ["Neon"] = 64.96, ["Neon|Ride"] = 85.56, ["Neon|Fly|Ride"] = 213.35, ["Mega"] = 452.82, ["Mega|Ride"] = 484.64, ["Mega|Fly|Ride"] = 419.88}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.37, ["Ride"] = 14.7, ["Fly|Ride"] = 52.41, ["Neon"] = 2.22, ["Neon|Fly"] = 26.57, ["Neon|Ride"] = 15.61, ["Neon|Fly|Ride"] = 39.26, ["Mega"] = 14.93, ["Mega|Fly"] = 50.77, ["Mega|Ride"] = 31.11, ["Mega|Fly|Ride"] = 72.18}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 57.63, ["Fly|Ride"] = 39.38, ["Neon"] = 3.93, ["Neon|Ride"] = 42.71, ["Neon|Fly|Ride"] = 132.35, ["Mega"] = 18.17, ["Mega|Fly"] = 104.99, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 138.8}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 36.29, ["Ride"] = 27.15, ["Fly|Ride"] = 124.74, ["Neon"] = 16.99, ["Neon|Ride"] = 53.38, ["Neon|Fly|Ride"] = 210.38, ["Mega"] = 73.99, ["Mega|Ride"] = 270.96, ["Mega|Fly|Ride"] = 246.1}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 31.18, ["Ride"] = 52.47, ["Fly|Ride"] = 131.25, ["Neon"] = 168, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 427.28, ["Mega|Ride"] = 576.19, ["Mega|Fly|Ride"] = 947.24}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.41, ["Fly"] = 19.36, ["Ride"] = 14.89, ["Fly|Ride"] = 34.48, ["Neon"] = 9.54, ["Neon|Fly"] = 29.65, ["Neon|Ride"] = 26.78, ["Neon|Fly|Ride"] = 54.51, ["Mega"] = 105, ["Mega|Fly"] = 170.62, ["Mega|Ride"] = 121.62, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 5.7, ["Fly"] = 24.19, ["Ride"] = 24.64, ["Fly|Ride"] = 82.64, ["Neon"] = 17.18, ["Neon|Fly"] = 55.76, ["Neon|Ride"] = 40.53, ["Neon|Fly|Ride"] = 114.21, ["Mega"] = 219.34, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 211.77, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 21.21, ["Ride"] = 18.09, ["Fly|Ride"] = 70.43, ["Neon"] = 8.15, ["Neon|Fly"] = 36.3, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 89.24, ["Mega"] = 161.94, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 84.6, ["Mega|Fly|Ride"] = 127.32}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 6.81, ["Fly"] = 161.12, ["Ride"] = 23.82, ["Fly|Ride"] = 217.19, ["Neon"] = 26.23, ["Neon|Ride"] = 100.5, ["Neon|Fly|Ride"] = 284.83, ["Mega"] = 261.83, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 382.96, ["Mega|Fly|Ride"] = 426.69}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 11.46, ["Ride"] = 141.17, ["Neon"] = 74.76, ["Neon|Ride"] = 262.4, ["Mega"] = 682.5, ["Mega|Fly|Ride"] = 996.32}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 2.3, ["Fly"] = 32.82, ["Ride"] = 18.38, ["Fly|Ride"] = 44.92, ["Neon"] = 26.17, ["Neon|Fly"] = 196.76, ["Neon|Ride"] = 48.87, ["Neon|Fly|Ride"] = 113.66, ["Mega"] = 262.4, ["Mega|Fly|Ride"] = 421.37}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 24.85, ["Ride"] = 13.6, ["Fly|Ride"] = 72.57, ["Neon"] = 16.49, ["Neon|Fly"] = 70.51, ["Neon|Ride"] = 36.3, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 187.69, ["Mega|Ride"] = 282.78, ["Mega|Fly|Ride"] = 290.03}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 224.95, ["Fly"] = 393.75, ["Ride"] = 271, ["Fly|Ride"] = 380.63, ["Neon"] = 1067.26, ["Neon|Ride"] = 1414.51, ["Neon|Fly|Ride"] = 1174.69, ["Mega|Fly|Ride"] = 4117.47}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.66, ["Ride"] = 110.62, ["Neon"] = 35.44, ["Neon|Ride"] = 143.03, ["Mega"] = 122.07, ["Mega|Ride"] = 420.6}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.17, ["Fly"] = 106.71, ["Ride"] = 21.78, ["Fly|Ride"] = 78.96, ["Neon"] = 22.65, ["Neon|Fly"] = 242.28, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 209.89, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 234.94}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 7.76, ["Fly|Ride"] = 212.89, ["Neon"] = 36.75, ["Neon|Ride"] = 226.27, ["Neon|Fly|Ride"] = 640.36, ["Mega"] = 596.53, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 414.1}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 16.06, ["Ride"] = 14.16, ["Fly|Ride"] = 29.98, ["Neon"] = 2.62, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 15.83, ["Neon|Fly|Ride"] = 39.26, ["Mega"] = 20.03, ["Mega|Fly"] = 80.01, ["Mega|Ride"] = 38.42, ["Mega|Fly|Ride"] = 98.43}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 4.75, ["Fly"] = 24.93, ["Ride"] = 16.08, ["Fly|Ride"] = 78.96, ["Neon"] = 8.65, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 97.76, ["Mega"] = 108.76, ["Mega|Ride"] = 110.23, ["Mega|Fly|Ride"] = 213.94}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.42, ["Ride"] = 42.7, ["Neon"] = 10.68, ["Neon|Ride"] = 143.03, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 73.5, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 67.65, ["Ride"] = 82.28, ["Fly|Ride"] = 175.26, ["Neon"] = 556.49, ["Neon|Ride"] = 379.63, ["Neon|Fly|Ride"] = 640.36, ["Mega|Ride"] = 3557.46, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 6.2, ["Fly"] = 100.3, ["Ride"] = 28.88, ["Fly|Ride"] = 100.68, ["Neon"] = 23.13, ["Neon|Ride"] = 64.28, ["Mega"] = 157.49, ["Mega|Ride"] = 229.5, ["Mega|Fly|Ride"] = 574.96}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 49.09, ["Ride"] = 19.74, ["Neon"] = 5.25, ["Neon|Ride"] = 81.02, ["Neon|Fly|Ride"] = 542.84, ["Mega"] = 66.94, ["Mega|Fly"] = 315, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 47.15, ["Fly"] = 210, ["Ride"] = 85.3, ["Fly|Ride"] = 183.75, ["Neon"] = 131.24, ["Neon|Ride"] = 199.59, ["Neon|Fly|Ride"] = 396.38, ["Mega"] = 590.63, ["Mega|Ride"] = 654.94, ["Mega|Fly|Ride"] = 595.88}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 17.04, ["Ride"] = 14.3, ["Fly|Ride"] = 28.48, ["Neon"] = 2.1, ["Neon|Fly"] = 17.13, ["Neon|Ride"] = 14.63, ["Neon|Fly|Ride"] = 26.25, ["Mega"] = 19.06, ["Mega|Fly"] = 49.86, ["Mega|Ride"] = 34.12, ["Mega|Fly|Ride"] = 86.01}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 2.3, ["Neon|Ride"] = 71.52, ["Neon|Fly|Ride"] = 285.31, ["Mega"] = 24.81, ["Mega|Ride"] = 88.01, ["Mega|Fly|Ride"] = 175.87}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 3.92, ["Ride"] = 41.91, ["Neon"] = 7.4, ["Neon|Fly"] = 59.05, ["Neon|Ride"] = 99.04, ["Neon|Fly|Ride"] = 136.13, ["Mega"] = 142.95, ["Mega|Fly"] = 185.62, ["Mega|Ride"] = 135.15, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 6.18, ["Fly"] = 78.75, ["Ride"] = 47.56, ["Fly|Ride"] = 148.71, ["Neon"] = 19.36, ["Neon|Fly"] = 91.55, ["Neon|Ride"] = 78.66, ["Neon|Fly|Ride"] = 180.43, ["Mega"] = 111.57, ["Mega|Fly"] = 266.68, ["Mega|Ride"] = 320.92, ["Mega|Fly|Ride"] = 255.84}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 21.17, ["Ride"] = 13.97, ["Fly|Ride"] = 25.6, ["Neon"] = 2.1, ["Neon|Fly"] = 24.5, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 44.01, ["Mega"] = 17.69, ["Mega|Ride"] = 52.49, ["Mega|Fly|Ride"] = 118.12}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 11.78, ["Fly"] = 131.25, ["Ride"] = 128.04, ["Neon"] = 128.64, ["Neon|Fly"] = 426.91, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 540.84, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 645.29}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2231.25, ["Fly"] = 3150, ["Ride"] = 2493.75, ["Fly|Ride"] = 2622.38, ["Mega|Fly|Ride"] = 42666.92}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 16.59, ["Ride"] = 15.57, ["Fly|Ride"] = 36.75, ["Neon"] = 4.75, ["Neon|Fly"] = 56.83, ["Neon|Ride"] = 18.15, ["Neon|Fly|Ride"] = 57.2, ["Mega"] = 82.6, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 113.74, ["Mega|Fly|Ride"] = 173.07}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Neon"] = 6.25, ["Mega"] = 142.95, ["Mega|Fly"] = 441, ["Mega|Ride"] = 160.02, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 14.49, ["Fly"] = 114.17, ["Ride"] = 28.25, ["Fly|Ride"] = 105, ["Neon"] = 71.46, ["Neon|Ride"] = 110.01, ["Neon|Fly|Ride"] = 212.63, ["Mega"] = 485.63, ["Mega|Ride"] = 452.29}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 29.95, ["Ride"] = 51.26, ["Neon"] = 161.44, ["Mega"] = 645.65, ["Mega|Ride"] = 610.17, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 134.61, ["Fly"] = 1403.03, ["Ride"] = 175.63, ["Fly|Ride"] = 251.99, ["Neon"] = 1312.5, ["Neon|Fly"] = 678.57, ["Neon|Ride"] = 707.48, ["Neon|Fly|Ride"] = 715.32, ["Mega"] = 6400.21, ["Mega|Fly|Ride"] = 3510.52}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 5.48, ["Ride"] = 31.49, ["Fly|Ride"] = 675.94, ["Neon"] = 26.17, ["Neon|Ride"] = 143.03, ["Neon|Fly|Ride"] = 162.02, ["Mega"] = 426.69, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 314.7, ["Mega|Fly|Ride"] = 362.7}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 36.29, ["Fly|Ride"] = 71.49, ["Neon"] = 26.23, ["Neon|Ride"] = 114.85, ["Neon|Fly|Ride"] = 284.96, ["Mega"] = 131.25, ["Mega|Ride"] = 333.27, ["Mega|Fly|Ride"] = 859.18}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 100.04, ["Ride"] = 26.17, ["Fly|Ride"] = 131.25, ["Neon"] = 11.22, ["Neon|Fly"] = 125.95, ["Neon|Ride"] = 40.03, ["Mega"] = 89.67, ["Mega|Ride"] = 100.87, ["Mega|Fly|Ride"] = 426.69}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 13.02, ["Ride"] = 50.34, ["Neon"] = 183.59, ["Neon|Ride"] = 177.74, ["Neon|Fly|Ride"] = 502.68, ["Mega"] = 374.07, ["Mega|Ride"] = 472.57, ["Mega|Fly|Ride"] = 597.85}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 42.7, ["Neon"] = 2.1, ["Neon|Ride"] = 47.78, ["Mega"] = 21.08, ["Mega|Fly"] = 120.86, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 135.19}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 89.15, ["Fly"] = 104.9, ["Ride"] = 103.64, ["Fly|Ride"] = 157.91, ["Neon"] = 366.19, ["Neon|Ride"] = 409.43, ["Neon|Fly|Ride"] = 330.87, ["Mega"] = 1081.65, ["Mega|Fly|Ride"] = 1869.4}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 91.82, ["Neon"] = 10.4, ["Neon|Ride"] = 71.52, ["Neon|Fly|Ride"] = 213.35, ["Mega"] = 72.52, ["Mega|Ride"] = 282.85}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 47.21, ["Fly"] = 102.43, ["Ride"] = 74.7, ["Fly|Ride"] = 137.82, ["Neon"] = 401.29, ["Neon|Ride"] = 270.03, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 2560.09, ["Mega|Fly|Ride"] = 2841.7}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 62.95, ["Ride"] = 21.35, ["Fly|Ride"] = 51.32, ["Neon"] = 3.84, ["Neon|Fly"] = 87.44, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 42, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 205.3}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 3.03, ["Neon"] = 11.82, ["Neon|Ride"] = 98.44, ["Mega"] = 90.76, ["Mega|Ride"] = 152.36, ["Mega|Fly|Ride"] = 485.25}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 3.47, ["Fly"] = 77.43, ["Ride"] = 38.98, ["Neon"] = 34.12, ["Neon|Ride"] = 120.75, ["Mega"] = 314.99, ["Mega|Ride"] = 288.74, ["Mega|Fly|Ride"] = 569.64}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 337.05, ["Ride"] = 378.12, ["Fly|Ride"] = 538.94, ["Neon"] = 1050, ["Neon|Ride"] = 964.66, ["Neon|Fly|Ride"] = 1050, ["Mega|Ride"] = 3412.5, ["Mega|Fly|Ride"] = 3916.6}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 23.68, ["Fly"] = 85.37, ["Ride"] = 50.06, ["Fly|Ride"] = 103.28, ["Neon"] = 187.02, ["Neon|Ride"] = 171.28, ["Neon|Fly|Ride"] = 287.96, ["Mega"] = 1420.86, ["Mega|Fly|Ride"] = 1995}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 49.88, ["Ride"] = 18.15, ["Fly|Ride"] = 85.37, ["Neon"] = 11.12, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 72.1, ["Mega|Ride"] = 168.38, ["Mega|Fly|Ride"] = 270.96}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 17.75, ["Fly"] = 74.81, ["Ride"] = 48.57, ["Fly|Ride"] = 170.63, ["Neon"] = 65.44, ["Neon|Fly"] = 105, ["Neon|Ride"] = 114.35, ["Neon|Fly|Ride"] = 182.83, ["Mega"] = 341.36, ["Mega|Fly"] = 994.52, ["Mega|Ride"] = 345.86, ["Mega|Fly|Ride"] = 452.87}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 4.19, ["Ride"] = 30.96, ["Fly|Ride"] = 196.88, ["Neon"] = 144.09, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 274.45, ["Mega"] = 314.7, ["Mega|Ride"] = 284.83, ["Mega|Fly|Ride"] = 566.44}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 2.1, ["Neon"] = 19.58, ["Neon|Fly"] = 71.47, ["Mega"] = 80.07, ["Mega|Ride"] = 140.82, ["Mega|Fly|Ride"] = 261.36}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 20.96, ["Fly|Ride"] = 60.45, ["Neon"] = 42.94, ["Neon|Ride"] = 45.01, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 129.84, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 77.02, ["Ride"] = 131.25, ["Fly|Ride"] = 228.33, ["Neon"] = 775.39, ["Neon|Ride"] = 523.67, ["Neon|Fly|Ride"] = 568.5, ["Mega"] = 2887.5, ["Mega|Fly|Ride"] = 3200.11}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 21.29, ["Ride"] = 47.16, ["Fly|Ride"] = 118.13, ["Neon"] = 143.03, ["Neon|Ride"] = 282.19, ["Neon|Fly|Ride"] = 284.47, ["Mega"] = 540.84, ["Mega|Fly|Ride"] = 704.04}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2231.25, ["Fly"] = 2030.44, ["Ride"] = 2060.63, ["Fly|Ride"] = 2094.75, ["Neon"] = 11384.26, ["Neon|Fly|Ride"] = 6424.69, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.85, ["Fly"] = 65625, ["Ride"] = 57.08, ["Fly|Ride"] = 196.87, ["Neon"] = 18.58, ["Neon|Fly|Ride"] = 640.03, ["Mega"] = 100.28, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 171.39, ["Mega|Fly|Ride"] = 467.66}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 4.08, ["Ride"] = 53.36, ["Fly|Ride"] = 111.07, ["Neon"] = 36.88, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 232.38, ["Mega"] = 157.5, ["Mega|Ride"] = 318.72, ["Mega|Fly|Ride"] = 853.37}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 865.98, ["Fly"] = 1096.66, ["Ride"] = 897.65, ["Fly|Ride"] = 986.79, ["Neon"] = 2778.57, ["Neon|Ride"] = 2624.99, ["Neon|Fly|Ride"] = 2485.87, ["Mega"] = 12516.67, ["Mega|Fly|Ride"] = 11520.37}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 23.84, ["Ride"] = 49.88, ["Fly|Ride"] = 173.35, ["Neon"] = 143.03, ["Neon|Ride"] = 213.46, ["Neon|Fly|Ride"] = 382.05, ["Mega"] = 839.9, ["Mega|Ride"] = 692.68, ["Mega|Fly|Ride"] = 878.97}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.62, ["Ride"] = 23.63, ["Fly|Ride"] = 128.15, ["Neon"] = 12.1, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 157.5, ["Mega|Ride"] = 271.1, ["Mega|Fly|Ride"] = 262.48}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.41, ["Ride"] = 142.97, ["Neon"] = 2.94, ["Neon|Ride"] = 48.92, ["Neon|Fly|Ride"] = 93.93, ["Mega"] = 19.69, ["Mega|Ride"] = 78.95}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 89.65, ["Ride"] = 114.17, ["Fly|Ride"] = 170.63, ["Neon"] = 459.38, ["Neon|Ride"] = 604.51, ["Neon|Fly|Ride"] = 630, ["Mega"] = 2416.81, ["Mega|Fly|Ride"] = 2133.41}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 3.81, ["Fly|Ride"] = 73.7, ["Neon"] = 12.77, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 28.84, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 118.41, ["Mega|Ride"] = 122.03, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 76.53, ["Ride"] = 102.38, ["Fly|Ride"] = 91.88, ["Neon"] = 459.37, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 524.03, ["Mega|Fly|Ride"] = 1811.28}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 4.97, ["Fly"] = 105, ["Neon"] = 26.23, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 229.46, ["Mega|Ride"] = 213.35, ["Mega|Fly|Ride"] = 418.17}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 262.49, ["Fly"] = 354.38, ["Ride"] = 291.84, ["Fly|Ride"] = 346.5, ["Neon"] = 1137.32, ["Neon|Ride"] = 1064.63, ["Neon|Fly|Ride"] = 859.69, ["Mega|Fly|Ride"] = 4550.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 2.1, ["Fly"] = 87.94, ["Ride"] = 19.67, ["Fly|Ride"] = 48.2, ["Neon"] = 20.79, ["Neon|Ride"] = 57.63, ["Neon|Fly|Ride"] = 100.93, ["Mega"] = 280.22, ["Mega|Ride"] = 318.93}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 19.37, ["Ride"] = 16.45, ["Fly|Ride"] = 41.48, ["Neon"] = 3.44, ["Neon|Fly"] = 31.4, ["Neon|Ride"] = 20.6, ["Neon|Fly|Ride"] = 46.08, ["Mega"] = 40.68, ["Mega|Ride"] = 67.93, ["Mega|Fly|Ride"] = 124.42}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1248.31, ["Ride"] = 1050, ["Fly|Ride"] = 1254.19, ["Neon|Ride"] = 7827.15, ["Neon|Fly|Ride"] = 6688.4, ["Mega"] = 23684.55, ["Mega|Fly|Ride"] = 28487.82}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 6.86, ["Fly"] = 994.12, ["Ride"] = 72.19, ["Neon"] = 65.01, ["Neon|Ride"] = 134.49, ["Mega"] = 279.54, ["Mega|Ride"] = 768.04, ["Mega|Fly|Ride"] = 564.17}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 3.62, ["Fly"] = 51.22, ["Ride"] = 41.11, ["Fly|Ride"] = 91.68, ["Neon"] = 19.28, ["Neon|Fly"] = 285.21, ["Neon|Ride"] = 52.65, ["Neon|Fly|Ride"] = 170.78, ["Mega"] = 175.88, ["Mega|Ride"] = 203.27, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 27.93, ["Fly"] = 48.37, ["Ride"] = 32.45, ["Fly|Ride"] = 74.08, ["Neon|Ride"] = 209.78, ["Neon|Fly|Ride"] = 201.66, ["Mega|Ride"] = 1128.66, ["Mega|Fly|Ride"] = 721.38}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 12.46, ["Fly"] = 85.37, ["Ride"] = 24.86, ["Fly|Ride"] = 85.32, ["Neon"] = 69.45, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 93.16, ["Neon|Fly|Ride"] = 179.45, ["Mega"] = 367.4, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 429.26}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 43.05, ["Ride"] = 103.69, ["Fly|Ride"] = 416.09, ["Neon"] = 188.9, ["Neon|Ride"] = 378, ["Neon|Fly|Ride"] = 533.64, ["Mega"] = 1050, ["Mega|Ride"] = 711.51, ["Mega|Fly|Ride"] = 695.77}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 1.79, ["Ride"] = 116.61, ["Fly|Ride"] = 246.62, ["Neon"] = 2.1, ["Neon|Fly"] = 57.64, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 105.16, ["Mega"] = 18.27, ["Mega|Ride"] = 83.54, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 62.5, ["Fly"] = 128.04, ["Ride"] = 85.89, ["Fly|Ride"] = 153.37, ["Neon"] = 446.24, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 471.44, ["Mega"] = 3413.46, ["Mega|Fly|Ride"] = 1635.55}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 6.42, ["Fly"] = 107.62, ["Ride"] = 23.37, ["Fly|Ride"] = 70.88, ["Neon"] = 85.8, ["Neon|Ride"] = 113.14, ["Neon|Fly|Ride"] = 170.78, ["Mega"] = 773.06, ["Mega|Ride"] = 433.79}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 28.82, ["Ride"] = 16, ["Fly|Ride"] = 37.77, ["Neon"] = 17.45, ["Neon|Fly"] = 81.02, ["Neon|Ride"] = 67.26, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 275.07, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.1, ["Ride"] = 126, ["Neon"] = 16.03, ["Neon|Fly"] = 140.89, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 381.89, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 483.37}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 45.71, ["Ride"] = 74.69, ["Fly|Ride"] = 262.5, ["Neon"] = 294, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 727.13, ["Mega|Ride"] = 1465.66, ["Mega|Fly|Ride"] = 1330.31}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 2.88, ["Fly|Ride"] = 426.77, ["Neon"] = 16.68, ["Neon|Ride"] = 80.06, ["Mega"] = 126.87, ["Mega|Ride"] = 138.69, ["Mega|Fly|Ride"] = 322.65}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 34.16, ["Neon"] = 2.47, ["Neon|Ride"] = 52.5, ["Mega"] = 16.49, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 533.36}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.94, ["Ride"] = 35.28, ["Fly|Ride"] = 63.24, ["Neon"] = 2.1, ["Neon|Ride"] = 28.17, ["Neon|Fly|Ride"] = 71.52, ["Mega"] = 16.15, ["Mega|Ride"] = 56.39, ["Mega|Fly|Ride"] = 142.95}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 16.03, ["Fly|Ride"] = 49.43, ["Neon"] = 7.27, ["Neon|Ride"] = 28.58, ["Neon|Fly|Ride"] = 85.81, ["Mega"] = 61.69, ["Mega|Ride"] = 78.74, ["Mega|Fly|Ride"] = 183.74}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 112.53, ["Neon"] = 24.93, ["Mega"] = 118.09, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 38.05, ["Ride"] = 15.65, ["Fly|Ride"] = 34.13, ["Neon"] = 15.93, ["Neon|Fly"] = 213.46, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 150.94, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 56.6, ["Ride"] = 91.7, ["Fly|Ride"] = 271, ["Neon"] = 210, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 1067.26, ["Mega"] = 961.8, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1122.93}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 12.83, ["Ride"] = 14.39, ["Fly|Ride"] = 36.42, ["Neon"] = 3.94, ["Neon|Fly"] = 28.46, ["Neon|Ride"] = 16.89, ["Neon|Fly|Ride"] = 57.54, ["Mega"] = 19.27, ["Mega|Ride"] = 25.83, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 9, ["Fly"] = 52.68, ["Ride"] = 23.5, ["Fly|Ride"] = 66.85, ["Neon"] = 26.25, ["Neon|Fly"] = 87.28, ["Neon|Ride"] = 61.68, ["Neon|Fly|Ride"] = 124.92, ["Mega"] = 381.57, ["Mega|Fly"] = 285.06, ["Mega|Ride"] = 224.85, ["Mega|Fly|Ride"] = 314.52}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 14.3, ["Fly"] = 72.07, ["Ride"] = 32.64, ["Fly|Ride"] = 85.22, ["Neon"] = 128.05, ["Neon|Ride"] = 137.45, ["Neon|Fly|Ride"] = 182.44, ["Mega"] = 787.5, ["Mega|Ride"] = 768.04, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 2.79, ["Fly"] = 196.88, ["Neon"] = 65.44, ["Neon|Ride"] = 71.52, ["Mega"] = 366.19, ["Mega|Ride"] = 448.28, ["Mega|Fly|Ride"] = 426.69}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.07, ["Fly|Ride"] = 45.95, ["Neon"] = 4.98, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 20.89, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 40.51, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 113.03}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 2.2, ["Fly"] = 72.19, ["Ride"] = 37.97, ["Neon"] = 24.05, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 205.69, ["Mega"] = 131.25, ["Mega|Fly"] = 735, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 322.65}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 871.56, ["Fly"] = 1402.23, ["Ride"] = 984.37, ["Fly|Ride"] = 1039.5, ["Neon"] = 3131.29, ["Neon|Ride"] = 2744.43, ["Neon|Fly|Ride"] = 2362.49, ["Mega|Fly|Ride"] = 7087.5}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 111.13, ["Ride"] = 142.97, ["Fly|Ride"] = 636.4, ["Neon"] = 640.36, ["Neon|Ride"] = 628.69, ["Neon|Fly|Ride"] = 820.32, ["Mega"] = 3199.05, ["Mega|Ride"] = 2844.91, ["Mega|Fly|Ride"] = 2388.75}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly"] = 57.63, ["Ride"] = 39.38, ["Neon"] = 6.02, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 208.13, ["Mega"] = 118.41, ["Mega|Fly|Ride"] = 1138.18}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 71.27, ["Ride"] = 117.41, ["Fly|Ride"] = 157.39, ["Neon"] = 392.38, ["Neon|Fly"] = 446.25, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 636.57, ["Mega"] = 1964.41, ["Mega|Ride"] = 1796.82, ["Mega|Fly|Ride"] = 1640.86}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 3.9, ["Ride"] = 21.36, ["Fly|Ride"] = 92.84, ["Neon"] = 18.5, ["Neon|Fly"] = 42.71, ["Neon|Ride"] = 50.98, ["Neon|Fly|Ride"] = 284.83, ["Mega"] = 284.83, ["Mega|Ride"] = 352.72, ["Mega|Fly|Ride"] = 412.83}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 228.96, ["Fly"] = 335.01, ["Ride"] = 262.5, ["Fly|Ride"] = 328.12, ["Neon|Ride"] = 1366.08, ["Neon|Fly|Ride"] = 1296.64, ["Mega|Fly|Ride"] = 4693.49}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 77.18, ["Ride"] = 41.62, ["Fly|Ride"] = 219.68, ["Neon"] = 31.48, ["Neon|Fly"] = 36.3, ["Neon|Ride"] = 54.37, ["Mega"] = 393.75, ["Mega|Fly"] = 332.82, ["Mega|Ride"] = 645.29}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Fly"] = 28.82, ["Neon"] = 42.33, ["Mega"] = 249.38, ["Mega|Ride"] = 365.9}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 24.05, ["Fly|Ride"] = 152.15, ["Neon"] = 111.2, ["Neon|Ride"] = 124.69, ["Mega"] = 463.76, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.73, ["Neon"] = 25.25, ["Neon|Ride"] = 196.87, ["Mega"] = 241.69, ["Mega|Ride"] = 253.31, ["Mega|Fly|Ride"] = 426.69}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 14.44, ["Fly|Ride"] = 39.36, ["Neon"] = 2.6, ["Neon|Fly"] = 28.41, ["Neon|Ride"] = 21.62, ["Neon|Fly|Ride"] = 34.99, ["Mega"] = 24.19, ["Mega|Ride"] = 180.29, ["Mega|Fly|Ride"] = 100.32}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 5974.47, ["Ride"] = 5124, ["Fly|Ride"] = 5234.25, ["Neon"] = 32006.06, ["Neon|Fly|Ride"] = 19293.75, ["Mega|Fly|Ride"] = 133337.45}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 7.96, ["Fly"] = 85.37, ["Ride"] = 41.57, ["Neon"] = 53.43, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 109.94, ["Mega"] = 192.94, ["Mega|Ride"] = 215.25, ["Mega|Fly|Ride"] = 426.69}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.69, ["Ride"] = 16.7, ["Fly|Ride"] = 35.42, ["Neon"] = 14.26, ["Neon|Fly"] = 37.49, ["Neon|Ride"] = 34.18, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 131.25, ["Mega|Ride"] = 176.06, ["Mega|Fly|Ride"] = 242.18}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 446.24, ["Fly"] = 547.77, ["Ride"] = 496.02, ["Fly|Ride"] = 531.57, ["Neon"] = 1612.22, ["Neon|Ride"] = 1292.82, ["Neon|Fly|Ride"] = 1471.01, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 5.55, ["Ride"] = 33.29, ["Neon"] = 19.36, ["Mega"] = 140.95, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.56, ["Fly"] = 4267.49, ["Ride"] = 36.74, ["Neon"] = 23.55, ["Neon|Fly"] = 118.48, ["Neon|Ride"] = 45.95, ["Mega"] = 1159.52, ["Mega|Ride"] = 401.63, ["Mega|Fly|Ride"] = 419.35}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 20.36, ["Neon"] = 3.9, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 28.17, ["Neon|Fly|Ride"] = 91.74, ["Mega"] = 39.37, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 284.83}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 656.23, ["Ride"] = 659.7, ["Fly|Ride"] = 686.94, ["Neon|Ride"] = 2838.87, ["Neon|Fly|Ride"] = 2480.62, ["Mega|Fly|Ride"] = 9245.1}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 4.99, ["Fly"] = 299.8, ["Ride"] = 54.6, ["Fly|Ride"] = 426.77, ["Neon"] = 30.95, ["Neon|Ride"] = 65.35, ["Neon|Fly|Ride"] = 290.17, ["Mega"] = 183.64, ["Mega|Ride"] = 229.67, ["Mega|Fly|Ride"] = 356.41}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 4.94, ["Fly"] = 236.15, ["Ride"] = 30.87, ["Neon"] = 23.7, ["Neon|Ride"] = 52.41, ["Neon|Fly|Ride"] = 144.36, ["Mega"] = 353.96, ["Mega|Fly"] = 806.02, ["Mega|Ride"] = 214.18, ["Mega|Fly|Ride"] = 412.83}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.12, ["Ride"] = 16.7, ["Fly|Ride"] = 59.03, ["Neon"] = 11.68, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 31.48, ["Neon|Fly|Ride"] = 81.37, ["Mega"] = 284.83, ["Mega|Ride"] = 183.49, ["Mega|Fly|Ride"] = 234.38}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 14.13, ["Ride"] = 34.12, ["Fly|Ride"] = 50.16, ["Neon"] = 117.58, ["Neon|Fly|Ride"] = 320.19, ["Mega"] = 852.31, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 1422.99}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 15.75, ["Fly|Ride"] = 85.37, ["Neon"] = 3.41, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 39.12, ["Mega|Ride"] = 103.83, ["Mega|Fly|Ride"] = 221.89}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 504.16, ["Ride"] = 538.12, ["Fly|Ride"] = 806.28, ["Neon"] = 2589.57, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Ride"] = 9425.49, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Fly"] = 106.71, ["Ride"] = 79.97, ["Neon"] = 15.94, ["Neon|Ride"] = 93.07, ["Neon|Fly|Ride"] = 483.6, ["Mega"] = 239.28, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 270.8}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 33.39, ["Neon"] = 5.15, ["Neon|Fly"] = 106.74, ["Neon|Ride"] = 42.71, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 89.43, ["Mega|Fly|Ride"] = 362.7}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 49.44, ["Neon"] = 3.83, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 142.95, ["Mega"] = 41.34, ["Mega|Fly"] = 157.89, ["Mega|Ride"] = 104.3, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 28.54, ["Neon"] = 37.93, ["Mega"] = 213.35, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 18.8, ["Fly"] = 64.32, ["Ride"] = 50.3, ["Fly|Ride"] = 101.35, ["Neon"] = 122.06, ["Neon|Fly"] = 143.03, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 281.48, ["Mega"] = 668.83, ["Mega|Ride"] = 519.74, ["Mega|Fly|Ride"] = 556.49}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 15.16, ["Ride"] = 48.37, ["Fly|Ride"] = 129.01, ["Neon"] = 82.1, ["Neon|Ride"] = 143.03, ["Neon|Fly|Ride"] = 279.08, ["Mega"] = 381.94, ["Mega|Ride"] = 554.7, ["Mega|Fly|Ride"] = 560.81}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 4.2, ["Fly"] = 32.96, ["Ride"] = 14.03, ["Fly|Ride"] = 33.5, ["Neon"] = 28.65, ["Neon|Ride"] = 36.73, ["Neon|Fly|Ride"] = 88.55, ["Mega"] = 255.29, ["Mega|Ride"] = 284.83, ["Mega|Fly|Ride"] = 253.88}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 11.8, ["Ride"] = 52.5, ["Neon"] = 42.71, ["Neon|Ride"] = 140.89, ["Mega|Ride"] = 410.82}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 24.2, ["Fly|Ride"] = 87.05, ["Neon"] = 10.31, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 114.21, ["Mega"] = 73.43, ["Mega|Ride"] = 115.49, ["Mega|Fly|Ride"] = 241.69}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 18.48, ["Fly"] = 27.76, ["Ride"] = 19.95, ["Fly|Ride"] = 63, ["Neon"] = 10672.4, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 192.05, ["Mega"] = 787.5, ["Mega|Fly|Ride"] = 829.5}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 32.13, ["Fly"] = 874.13, ["Neon"] = 133.77, ["Neon|Ride"] = 131.25, ["Mega"] = 328.12, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 495.48}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 45.94, ["Fly"] = 115.75, ["Ride"] = 85.19, ["Fly|Ride"] = 142.97, ["Neon"] = 345.38, ["Neon|Ride"] = 347.82, ["Neon|Fly|Ride"] = 423.21, ["Mega|Ride"] = 1708.68, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 33.13, ["Fly"] = 85.37, ["Ride"] = 76.74, ["Fly|Ride"] = 208.05, ["Neon"] = 144.37, ["Neon|Ride"] = 206.47, ["Neon|Fly|Ride"] = 315, ["Mega|Ride"] = 634.39, ["Mega|Fly|Ride"] = 628.21}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 19.36, ["Ride"] = 64.32, ["Neon"] = 114.27, ["Neon|Ride"] = 428.3, ["Mega"] = 1049.99, ["Mega|Ride"] = 711.51, ["Mega|Fly|Ride"] = 807.19}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 16.33, ["Fly"] = 426.77, ["Ride"] = 47.81, ["Fly|Ride"] = 213.39, ["Neon"] = 132.2, ["Neon|Fly"] = 420, ["Neon|Ride"] = 143.05, ["Neon|Fly|Ride"] = 315, ["Mega"] = 407.44, ["Mega|Ride"] = 561.88, ["Mega|Fly|Ride"] = 638.89}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.91, ["Ride"] = 15.74, ["Fly|Ride"] = 32.74, ["Neon"] = 3.93, ["Neon|Fly"] = 28.31, ["Neon|Ride"] = 29.12, ["Neon|Fly|Ride"] = 48.4, ["Mega"] = 41.14, ["Mega|Fly"] = 336.03, ["Mega|Ride"] = 57.7, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 866.23}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 42.56, ["Ride"] = 97.12, ["Fly|Ride"] = 315, ["Neon"] = 346.86, ["Neon|Ride"] = 365.54, ["Neon|Fly|Ride"] = 554.97, ["Mega"] = 1128.66, ["Mega|Ride"] = 1512.59, ["Mega|Fly|Ride"] = 1312.49}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 79.74, ["Neon"] = 2.66, ["Neon|Ride"] = 43.19, ["Neon|Fly|Ride"] = 298.05, ["Mega"] = 26.87, ["Mega|Ride"] = 84.94, ["Mega|Fly|Ride"] = 198.19}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 25.47, ["Ride"] = 114.17, ["Fly|Ride"] = 162, ["Neon"] = 130.22, ["Neon|Ride"] = 133.95, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 524.99, ["Mega|Ride"] = 806.02, ["Mega|Fly|Ride"] = 686.82}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.61, ["Mega"] = 23.6}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 2.82, ["Neon|Ride"] = 39.38, ["Mega"] = 21.35, ["Mega|Ride"] = 152.28}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 103.25, ["Fly"] = 223.13, ["Ride"] = 141.66, ["Fly|Ride"] = 354.13, ["Neon"] = 612.61, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 656.25, ["Mega|Ride"] = 6646.19, ["Mega|Fly|Ride"] = 2001.45}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.56, ["Ride"] = 21.31, ["Fly|Ride"] = 96.72, ["Neon"] = 4.27, ["Neon|Ride"] = 25.12, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 90.17, ["Mega|Ride"] = 115.63, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 71.49, ["Fly|Ride"] = 50.93, ["Neon"] = 6.04, ["Neon|Ride"] = 25.64, ["Neon|Fly|Ride"] = 142.95, ["Mega"] = 35.43, ["Mega|Ride"] = 128.5, ["Mega|Fly|Ride"] = 282.78}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 15.75, ["Neon"] = 3.68, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 210, ["Mega"] = 76.13, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 253.88}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 82.68, ["Neon"] = 6.17, ["Neon|Ride"] = 155.92, ["Mega"] = 71.48, ["Mega|Ride"] = 213.35}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 39.69, ["Ride"] = 111.57, ["Fly|Ride"] = 456.64, ["Neon"] = 428.35, ["Neon|Ride"] = 499.11, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2063.01, ["Mega|Ride"] = 1600.07, ["Mega|Fly|Ride"] = 1564.87}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 2.29, ["Ride"] = 67.24, ["Neon"] = 39.37, ["Neon|Ride"] = 227.06, ["Mega"] = 413.86, ["Mega|Ride"] = 956.1}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 1.79}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 361.75, ["Ride"] = 371.38, ["Fly|Ride"] = 778.49, ["Neon"] = 1209, ["Neon|Ride"] = 1423.71, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4084.39}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 1.79}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 85.32}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 49.79}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 15.11}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 15.73}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 129.12}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 104.34}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 14.26}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 7.33}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 262.48}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 26.17}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 1.79}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 23.49}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 7.8}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 3.51}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 577.49}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 5.24}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 5.35}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 7.6}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 9.57}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 12.31}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 564.26}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.63}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 589.89}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 13.13}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1084.78}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 3.93}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 59.45}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 8.9}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.63}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 33.33}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.37}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 15.11}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 34.11}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 46.69}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 18.68}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 11.46}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 18.15}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 5.92}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 14.34}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.15}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 3.74}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 18.96}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 140.07}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 3.61}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 2559.38}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 29.96}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 307.92}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 7.74}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 6.57}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 9.17}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 6.55}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 49.74}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 197.13}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 6.56}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 6.45}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 1181.25}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 30.38}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 3.98}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 31.08}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 14}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 111.57}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 36.98}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 7.35}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 3.93}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 19.36}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 8.97}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 2.1}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 33.74}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 89.06}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 223.13}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 7.02}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 318.05}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.93}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 65.19}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 20.98}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 1.79}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 23028.12}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 144.38}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 78.75}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 46.66}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 88.89}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 32.44}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 21.18}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 19.69}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 81.81}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 81.29}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 92.85}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 56.81}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 160.08}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 54.57}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 35.44}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 8.66}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 6.14}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 4.93}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 32.43}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 118.33}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.16}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 4.51}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 2.2}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 13.51}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 270.13}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 997.5}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 1.79}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 15.6}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 583.68}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 15.38}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.63}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.63}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 231}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 1.79}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 24.9}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 115.4}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 19.2}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 22.37}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 50.21}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 14.22}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 2.1}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 8.71}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.57}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 4.45}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 28.77}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.06}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.84}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 8.99}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 50.18}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 177.34}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 38.98}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 4.85}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 322.81}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 12.5}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 8.28}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 6.2}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 24.94}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 20.5}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 6.62}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 8.6}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 8.24}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 14.02}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 35.33}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 19.21}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 4.65}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 6.18}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 6.56}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 6.02}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 1.79}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 5.8}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 6.55}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 3.19}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.62}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.82}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 1.79}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 2.12}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 1.79}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7781.61}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.62}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 22.36}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.98}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 8.7}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 6.02}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.15}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 23.24}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 8.87}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 2.76}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.57}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 5.04}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 1.79}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 1.79}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 32.71}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 7.88}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.84}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 5.43}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.82}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4267.7}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 8.45}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 1.79}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 26.17}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 6.42}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 1.79}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.29}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 66.87}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 3.71}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 100.82}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 1.79}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 1.79}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 15.05}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.66}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 3.44}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 2.1}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 7.9}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 9.42}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.66}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 1.79}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 8.98}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.72}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.56}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 1.79}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.71}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.41}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 1.79}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 5.5}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 28.87}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 9.58}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 72.19}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.67}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 62.1}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 2.61}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 5.25}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1164.36}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 32}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 3.94}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 4.81}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 1.79}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 20.79}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 27.19}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.05}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 14.95}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 7.21}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 11.34}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 6.33}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 15.74}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 13.53}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.63}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 3.94}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 7.04}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.89}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 12.62}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 10.4}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 21.63}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.56}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 8.28}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 3.4}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 20.25}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 52.41}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.63}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 3.86}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.52}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 4.79}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 34.16}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 86.01}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 7.1}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 4.93}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 3.83}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 70.17}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 33.95}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 4.55}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 4.92}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 5.14}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 3.15}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 1.73}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.24}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 6.41}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 75.29}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 3.08}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.63}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 144.04}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 8.53}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1423.29}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 4.43}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 183.75}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 4.07}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 7.66}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 50.57}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 6.39}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 5.49}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.35}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 69.25}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 19.69}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 9.35}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 7.86}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.63}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 7.08}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 79.91}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 3.82}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 62.58}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.12}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 27.55}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 144.36}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 4.28}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 6.97}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 74.49}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 8.78}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 5.6}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 1.79}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 58}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 53.45}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 53.6}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 172.86}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.55}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 56.57}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 122.42}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.63}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 3.66}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 9.24}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 31.32}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 61.6}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.94}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 61.68}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 5.08}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 5.86}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 86.84}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 21.39}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 64.47}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 33.94}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 9.08}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 78.75}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 45.05}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 6.08}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.43}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 20.68}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.93}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 13.39}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 65.02}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 1.79}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 33.74}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 83.88}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 2079.41}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 11.78}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 8.71}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 20.37}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 341.25}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 17.19}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 8.74}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 11.68}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 8.81}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 4.24}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 292.69}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 52.4}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 53.64}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 2.88}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 77.31}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 165.42}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 75.93}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 918.75}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 104.9}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 8.43}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2361.19}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 551.23}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 3.28}},
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