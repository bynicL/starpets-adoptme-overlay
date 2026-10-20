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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1049.9, ["Ride"] = 1137.97, ["Fly|Ride"] = 1292.82, ["Neon"] = 6775.74, ["Neon|Ride"] = 6562.5, ["Neon|Fly|Ride"] = 4265.73, ["Mega|Fly|Ride"] = 17740.4}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 414.4, ["Ride"] = 498.24, ["Fly|Ride"] = 551.15, ["Neon|Fly|Ride"] = 1967.44, ["Mega"] = 12094.62, ["Mega|Fly|Ride"] = 7038.44}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 5465.32, ["Ride"] = 5094.06, ["Fly|Ride"] = 4958.63, ["Neon|Fly|Ride"] = 21770.1, ["Mega|Fly|Ride"] = 71095.64}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 160.12, ["Ride"] = 212.25, ["Fly|Ride"] = 275.63, ["Neon"] = 996.13, ["Neon|Ride"] = 979, ["Neon|Fly|Ride"] = 984.38, ["Mega|Fly|Ride"] = 4263}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 570.94, ["Fly"] = 853.21, ["Ride"] = 555.85, ["Fly|Ride"] = 682.5, ["Neon|Fly|Ride"] = 1745.63, ["Mega|Fly|Ride"] = 6825}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 10.9, ["Ride"] = 57.68, ["Fly|Ride"] = 129.94, ["Neon"] = 71.47, ["Neon|Ride"] = 58.09, ["Neon|Fly|Ride"] = 404.25, ["Mega"] = 316.32, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 597.21}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.89, ["Fly"] = 40.06, ["Ride"] = 24.41, ["Fly|Ride"] = 60.45, ["Neon"] = 26.06, ["Neon|Fly"] = 103.68, ["Neon|Ride"] = 55.43, ["Neon|Fly|Ride"] = 113.71, ["Mega"] = 166.37, ["Mega|Ride"] = 220.5, ["Mega|Fly|Ride"] = 257.19}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 98.44, ["Fly"] = 213.31, ["Ride"] = 152.27, ["Fly|Ride"] = 238.91, ["Neon"] = 567.39, ["Neon|Ride"] = 540.69, ["Neon|Fly|Ride"] = 690, ["Mega"] = 1586.82, ["Mega|Fly|Ride"] = 2784.46}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 36.66, ["Fly"] = 62.58, ["Ride"] = 38.97, ["Fly|Ride"] = 92.81, ["Neon"] = 275.63, ["Neon|Fly"] = 323.08, ["Neon|Ride"] = 242.82, ["Neon|Fly|Ride"] = 314.48, ["Mega"] = 1422.64, ["Mega|Ride"] = 1290.52, ["Mega|Fly|Ride"] = 946.32}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 19.25, ["Fly"] = 84.28, ["Ride"] = 34.13, ["Fly|Ride"] = 62.9, ["Neon"] = 148.25, ["Neon|Ride"] = 169.58, ["Neon|Fly|Ride"] = 233.63, ["Mega|Fly|Ride"] = 1109.1}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 54.06, ["Fly"] = 114.13, ["Ride"] = 70.16, ["Fly|Ride"] = 142.93, ["Neon"] = 445.28, ["Neon|Ride"] = 248.75, ["Neon|Fly|Ride"] = 428.16, ["Mega|Ride"] = 1137.9, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 59.06}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 319.92, ["Fly"] = 399, ["Ride"] = 308.44, ["Fly|Ride"] = 376.52, ["Neon|Ride"] = 1048.69, ["Neon|Fly|Ride"] = 1127.44, ["Mega|Fly|Ride"] = 5069.81}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 104.26, ["Fly"] = 136.42, ["Ride"] = 122.53, ["Fly|Ride"] = 167.16, ["Neon|Ride"] = 573.56, ["Neon|Fly|Ride"] = 634.54, ["Mega|Fly|Ride"] = 3063.38}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3, ["Ride"] = 55.04, ["Fly|Ride"] = 131.24, ["Neon"] = 19.28, ["Neon|Ride"] = 130.46, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 129.93, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 322.07, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 183.54, ["Fly"] = 286.33, ["Ride"] = 170.63, ["Fly|Ride"] = 221.82, ["Neon"] = 846.99, ["Neon|Ride"] = 881.95, ["Neon|Fly|Ride"] = 893.82, ["Mega|Fly|Ride"] = 2730}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3, ["Fly"] = 22.63, ["Ride"] = 19.22, ["Fly|Ride"] = 36.33, ["Neon"] = 36.18, ["Neon|Fly"] = 127.99, ["Neon|Ride"] = 93.85, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 181.5, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 383.94}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 86.62, ["Fly"] = 284.72, ["Ride"] = 140.04, ["Fly|Ride"] = 170.63, ["Neon"] = 333.82, ["Neon|Ride"] = 374.07, ["Neon|Fly|Ride"] = 420, ["Mega"] = 1703.79, ["Mega|Ride"] = 1422.64, ["Mega|Fly|Ride"] = 1422.75}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 37.54}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 61.58, ["Ride"] = 65.63, ["Fly|Ride"] = 213.31, ["Neon"] = 356.22, ["Neon|Fly|Ride"] = 569.49}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 17.98, ["Fly"] = 55.47, ["Ride"] = 32.47, ["Fly|Ride"] = 383.96, ["Neon"] = 239.02, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 656.25, ["Mega|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 639.87}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 41.36, ["Fly"] = 71.47, ["Ride"] = 54.41, ["Fly|Ride"] = 100.49, ["Neon"] = 711.37, ["Neon|Ride"] = 290.28, ["Neon|Fly|Ride"] = 303.19, ["Mega"] = 1693.27, ["Mega|Ride"] = 1422.64, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 27.28, ["Fly"] = 78.75, ["Ride"] = 111.57, ["Fly|Ride"] = 196.88, ["Neon"] = 210, ["Neon|Fly"] = 401.72, ["Neon|Ride"] = 371.23, ["Neon|Fly|Ride"] = 467.25, ["Mega"] = 1967.44, ["Mega|Fly|Ride"] = 1242.13}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 16.25, ["Ride"] = 35.18, ["Fly|Ride"] = 84, ["Neon"] = 213.31, ["Neon|Ride"] = 212.24, ["Neon|Fly|Ride"] = 260.23, ["Mega"] = 957.67, ["Mega|Ride"] = 1137.9, ["Mega|Fly|Ride"] = 1137.9}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 31.28, ["Fly"] = 136.75, ["Ride"] = 57.66, ["Fly|Ride"] = 142.93, ["Neon"] = 284.78, ["Neon|Ride"] = 220.83, ["Neon|Fly|Ride"] = 262.49, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 958.13}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 4.27, ["Fly"] = 28.35, ["Ride"] = 19.45, ["Fly|Ride"] = 50.43, ["Neon"] = 29.38, ["Neon|Fly"] = 101.05, ["Neon|Ride"] = 54.42, ["Neon|Fly|Ride"] = 82.73, ["Mega"] = 196.88, ["Mega|Fly"] = 312.79, ["Mega|Ride"] = 182.33, ["Mega|Fly|Ride"] = 264.49}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 452.61, ["Ride"] = 453.92, ["Fly|Ride"] = 518.37, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1964.82, ["Mega|Fly|Ride"] = 8674.35}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 13.72, ["Ride"] = 32.45, ["Fly|Ride"] = 110.64, ["Neon"] = 214.82, ["Mega|Ride"] = 810.5, ["Mega|Fly|Ride"] = 923.54}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 4.39, ["Fly"] = 35.44, ["Ride"] = 21.33, ["Fly|Ride"] = 45.75, ["Neon"] = 65.63, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 115.66, ["Mega"] = 426.59, ["Mega|Ride"] = 388.5, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 91.76, ["Fly"] = 102.18, ["Ride"] = 100.37, ["Fly|Ride"] = 131.25, ["Neon"] = 371.24, ["Neon|Fly"] = 374.33, ["Neon|Ride"] = 416.98, ["Neon|Fly|Ride"] = 399, ["Mega"] = 4181.48, ["Mega|Ride"] = 5832.75, ["Mega|Fly|Ride"] = 1678.58}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 9.92, ["Ride"] = 32.82, ["Fly|Ride"] = 108.8, ["Neon"] = 131.25, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 221.82, ["Mega"] = 710.01, ["Mega|Ride"] = 806.73}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 190.32, ["Fly"] = 360.5, ["Ride"] = 242.01, ["Fly|Ride"] = 301.88, ["Neon"] = 672.79, ["Neon|Ride"] = 825.57, ["Neon|Fly|Ride"] = 917.14, ["Mega"] = 6398.59, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 23.56}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.51, ["Fly"] = 32.67, ["Ride"] = 24.54, ["Fly|Ride"] = 54.54, ["Neon"] = 18.38, ["Neon|Fly"] = 142.93, ["Neon|Ride"] = 52.48, ["Neon|Fly|Ride"] = 142.92, ["Mega"] = 132.58, ["Mega|Fly"] = 483.68, ["Mega|Ride"] = 182.44, ["Mega|Fly|Ride"] = 284.75}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 892.48, ["Fly"] = 2625, ["Ride"] = 891.18, ["Fly|Ride"] = 1124.13, ["Neon"] = 17423.3, ["Neon|Ride"] = 6256.76, ["Neon|Fly|Ride"] = 4282.32, ["Mega|Ride"] = 54425.76, ["Mega|Fly|Ride"] = 17062.88}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 11.46, ["Fly"] = 52.5, ["Ride"] = 30.35, ["Fly|Ride"] = 91.49, ["Neon"] = 91.88, ["Neon|Ride"] = 99.21, ["Neon|Fly|Ride"] = 235.7, ["Mega"] = 782.77, ["Mega|Ride"] = 1095.24, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 185.8, ["Ride"] = 249.73, ["Fly|Ride"] = 275.63, ["Neon"] = 830.82, ["Neon|Ride"] = 733.57, ["Neon|Fly|Ride"] = 967.58, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 4033.57}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 45.61}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 16.2, ["Fly"] = 114.13, ["Ride"] = 65.63, ["Fly|Ride"] = 142.93, ["Neon"] = 104.9, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 142.92, ["Mega"] = 711.33, ["Mega|Ride"] = 1125.1, ["Mega|Fly|Ride"] = 598.7}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 110.91, ["Ride"] = 166.69, ["Fly|Ride"] = 262.5, ["Neon"] = 639.19, ["Neon|Ride"] = 526.98, ["Mega|Fly|Ride"] = 2723.17}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 118.16, ["Fly"] = 157.49, ["Ride"] = 162.75, ["Fly|Ride"] = 274.32, ["Neon"] = 360.94, ["Neon|Fly"] = 569.52, ["Neon|Ride"] = 421.85, ["Neon|Fly|Ride"] = 472.49, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1560.56}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 33.87}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 51.45, ["Fly"] = 66.72, ["Ride"] = 53.9, ["Fly|Ride"] = 72.61, ["Neon|Ride"] = 456.44, ["Neon|Fly|Ride"] = 421.25, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 4.68, ["Fly"] = 98.44, ["Ride"] = 35.32, ["Fly|Ride"] = 157.49, ["Neon"] = 36.27, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 66.94, ["Neon|Fly|Ride"] = 569.49, ["Mega"] = 223.13, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 298.97, ["Mega|Fly|Ride"] = 649.69}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 485.52, ["Fly"] = 479.07, ["Ride"] = 477.65, ["Fly|Ride"] = 525, ["Neon|Ride"] = 3839.16, ["Neon|Fly|Ride"] = 1740.38, ["Mega|Ride"] = 14930.02, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 111.56, ["Fly"] = 158.52, ["Ride"] = 116.82, ["Fly|Ride"] = 188.19, ["Neon"] = 420, ["Neon|Ride"] = 535.5, ["Neon|Fly|Ride"] = 569.49, ["Mega|Fly|Ride"] = 2535.99}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3675, ["Ride"] = 3885, ["Fly|Ride"] = 3674.99, ["Neon|Fly|Ride"] = 14928.96}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 44.09, ["Fly"] = 121.59, ["Ride"] = 56.59, ["Fly|Ride"] = 128.52, ["Neon|Ride"] = 322.88, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 1598.6, ["Mega|Ride"] = 1820.41, ["Mega|Fly|Ride"] = 1422.64}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 63, ["Ride"] = 68.08, ["Fly|Ride"] = 143.58, ["Neon"] = 646.13, ["Neon|Ride"] = 427.88, ["Neon|Fly|Ride"] = 431.82, ["Mega|Ride"] = 2275.77, ["Mega|Fly|Ride"] = 2277.53}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 31.5, ["Fly"] = 55.13, ["Ride"] = 38.75, ["Fly|Ride"] = 89.25, ["Neon"] = 140.79, ["Neon|Ride"] = 137.38, ["Neon|Fly|Ride"] = 187.65, ["Mega"] = 2625, ["Mega|Ride"] = 697.46, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 6.04}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 40.25, ["Ride"] = 62.37, ["Fly|Ride"] = 71.6, ["Neon|Ride"] = 322.94, ["Neon|Fly|Ride"] = 426.59, ["Mega|Ride"] = 1290.52, ["Mega|Fly|Ride"] = 1493.63}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 41.91}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 197.03, ["Ride"] = 236.25, ["Fly|Ride"] = 301.88, ["Neon|Ride"] = 1422.64, ["Neon|Fly|Ride"] = 1104.84, ["Mega|Fly|Ride"] = 4598.46}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["Ride"] = 984.38, ["Fly|Ride"] = 783.55, ["Neon"] = 2887.5, ["Neon|Ride"] = 3199.3, ["Neon|Fly|Ride"] = 3495.77, ["Mega|Fly|Ride"] = 10820.36}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 7.23}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 27.28, ["Fly"] = 59.05, ["Ride"] = 32.43, ["Fly|Ride"] = 66.94, ["Neon"] = 246.75, ["Neon|Ride"] = 96.76, ["Neon|Fly|Ride"] = 213.92, ["Mega"] = 2132.88, ["Mega|Ride"] = 1161.09, ["Mega|Fly|Ride"] = 762.74}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 19}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 4856.25, ["Ride"] = 5650.32, ["Fly|Ride"] = 4856.25, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 43540.62}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 11.68, ["Fly"] = 55.12, ["Ride"] = 23, ["Fly|Ride"] = 58.77, ["Neon"] = 99.59, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 711.33, ["Mega|Ride"] = 490.88, ["Mega|Fly|Ride"] = 735}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 15.33, ["Fly"] = 139.89, ["Ride"] = 36.66, ["Neon"] = 97.07, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1076.43, ["Mega|Ride"] = 770.2, ["Mega|Fly|Ride"] = 711.33}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 70.87, ["Fly"] = 284.78, ["Ride"] = 58.7, ["Fly|Ride"] = 85.32, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 498.75, ["Mega"] = 4265.73}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 11.55, ["Fly"] = 71.47, ["Ride"] = 25.81, ["Fly|Ride"] = 78.75, ["Neon"] = 108.94, ["Neon|Ride"] = 129.43, ["Neon|Fly|Ride"] = 501.38, ["Mega"] = 1422.64, ["Mega|Ride"] = 749.36, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1706.24, ["Fly"] = 2361.26, ["Ride"] = 1785, ["Fly|Ride"] = 1754.16, ["Neon|Fly|Ride"] = 3580.5, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 27562.5, ["Fly"] = 34128.13, ["Ride"] = 34256.25, ["Fly|Ride"] = 27562.5, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 73858.17, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 16.62, ["Fly"] = 393.75, ["Ride"] = 45.94, ["Fly|Ride"] = 173.85, ["Neon"] = 319.96, ["Neon|Ride"] = 213.3, ["Neon|Fly|Ride"] = 282.19, ["Mega"] = 954.47, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1393.32}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.58, ["Fly"] = 97.07, ["Ride"] = 32.47, ["Fly|Ride"] = 158.9, ["Neon"] = 21.35, ["Neon|Fly"] = 110.25, ["Neon|Ride"] = 66.52, ["Neon|Fly|Ride"] = 142.92, ["Mega"] = 137.82, ["Mega|Ride"] = 234.92, ["Mega|Fly|Ride"] = 248.07}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 25.62}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 8.95, ["Ride"] = 36.74, ["Fly|Ride"] = 124.68, ["Neon"] = 58.46, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 560.96, ["Mega"] = 426.59, ["Mega|Ride"] = 412.02, ["Mega|Fly|Ride"] = 656.24}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 714, ["Ride"] = 710.07, ["Fly|Ride"] = 779.62, ["Neon"] = 2489.24, ["Neon|Ride"] = 2559.45, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 11289.12}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 790.33, ["Fly"] = 975.19, ["Ride"] = 853.4, ["Fly|Ride"] = 918.75, ["Neon"] = 4124.19, ["Neon|Ride"] = 3697.33, ["Neon|Fly|Ride"] = 2493.75, ["Mega|Fly|Ride"] = 11660.35}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 12.27, ["Fly"] = 121.02, ["Ride"] = 30.18, ["Fly|Ride"] = 71.47, ["Neon"] = 78.74, ["Neon|Ride"] = 100.91, ["Neon|Fly|Ride"] = 214.06, ["Mega"] = 1204.13, ["Mega|Ride"] = 480.38, ["Mega|Fly|Ride"] = 548.63}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 24.4}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 69.21, ["Fly"] = 128.33, ["Ride"] = 77.77, ["Fly|Ride"] = 114.58, ["Neon"] = 420, ["Neon|Ride"] = 426.59, ["Neon|Fly|Ride"] = 420, ["Mega"] = 19687.5, ["Mega|Ride"] = 2088.08, ["Mega|Fly|Ride"] = 1664.25}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 72.19, ["Ride"] = 138.48, ["Fly|Ride"] = 127.32, ["Neon"] = 450.19, ["Neon|Fly"] = 403.98, ["Neon|Ride"] = 401.35, ["Neon|Fly|Ride"] = 553.77, ["Mega"] = 1387.84, ["Mega|Ride"] = 1919.58, ["Mega|Fly|Ride"] = 1935.14}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 4.76, ["Fly"] = 35.43, ["Ride"] = 15.94, ["Fly|Ride"] = 42.15, ["Neon"] = 45.94, ["Neon|Fly"] = 525, ["Neon|Ride"] = 66.13, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 283.26, ["Mega|Fly|Ride"] = 540.75}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 124.68, ["Fly"] = 143.96, ["Ride"] = 128.6, ["Fly|Ride"] = 185.26, ["Neon"] = 725.81, ["Neon|Ride"] = 576.19, ["Neon|Fly|Ride"] = 538.13, ["Mega|Fly|Ride"] = 2180.61}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.65, ["Ride"] = 40.56, ["Fly|Ride"] = 140.44, ["Neon"] = 40.69, ["Neon|Ride"] = 87.57, ["Mega"] = 248.01, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 12.98, ["Fly"] = 41.65, ["Ride"] = 32.7, ["Fly|Ride"] = 78.72, ["Neon"] = 126.29, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 162.08, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 30.54, ["Ride"] = 60.27, ["Fly|Ride"] = 156.19, ["Neon"] = 183.75, ["Neon|Ride"] = 282.19, ["Mega"] = 918.74, ["Mega|Ride"] = 1161.57, ["Mega|Fly|Ride"] = 1114.31}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 11.74, ["Fly"] = 193.12, ["Ride"] = 35.77, ["Fly|Ride"] = 68.76, ["Neon"] = 91.88, ["Neon|Ride"] = 115.77, ["Neon|Fly|Ride"] = 142.92, ["Mega"] = 918.75, ["Mega|Fly|Ride"] = 1055.78}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 8532.05, ["Ride"] = 6555.94, ["Fly|Ride"] = 5575.5, ["Neon"] = 35550.85, ["Neon|Ride"] = 24281.25, ["Neon|Fly|Ride"] = 28281.71}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 220.1, ["Fly"] = 277.99, ["Ride"] = 242.81, ["Fly|Ride"] = 252, ["Neon|Fly|Ride"] = 510.57, ["Mega|Fly|Ride"] = 1892.63}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 45.29, ["Fly"] = 144.3, ["Ride"] = 91.77, ["Fly|Ride"] = 150.94, ["Neon"] = 131.25, ["Neon|Fly"] = 306.1, ["Neon|Ride"] = 166.69, ["Neon|Fly|Ride"] = 262.4, ["Mega"] = 437.07, ["Mega|Fly"] = 583.35, ["Mega|Ride"] = 419.9, ["Mega|Fly|Ride"] = 551.15}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.5, ["Fly"] = 89.56, ["Ride"] = 28.81, ["Fly|Ride"] = 50.14, ["Neon"] = 21.45, ["Neon|Fly"] = 61.87, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 194.11, ["Mega"] = 144.38, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 60.35, ["Fly"] = 5484.71, ["Ride"] = 99.56, ["Fly|Ride"] = 225.53, ["Neon"] = 242.82, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 258.58, ["Neon|Fly|Ride"] = 387.16, ["Mega"] = 539.85, ["Mega|Ride"] = 695.63, ["Mega|Fly|Ride"] = 628.74}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 14384.99, ["Ride"] = 13387.5, ["Fly|Ride"] = 11238.4, ["Neon|Fly|Ride"] = 27562.5, ["Mega|Fly|Ride"] = 113752.8}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 261.19, ["Ride"] = 301.88, ["Fly|Ride"] = 339.17, ["Neon"] = 1279.82, ["Neon|Ride"] = 1422.64, ["Neon|Fly|Ride"] = 1614.59, ["Mega|Fly|Ride"] = 6171.44}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 74.72, ["Fly"] = 82.91, ["Ride"] = 58.59, ["Fly|Ride"] = 129.93, ["Neon"] = 405.28, ["Neon|Ride"] = 296.13, ["Neon|Fly|Ride"] = 426.59}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 9.08, ["Fly"] = 45.99, ["Ride"] = 19.69, ["Fly|Ride"] = 72.12, ["Neon"] = 67.46, ["Neon|Fly"] = 274.68, ["Neon|Ride"] = 71.76, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 360.94, ["Mega|Fly|Ride"] = 569.49}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 386.88, ["Fly"] = 527.94, ["Ride"] = 393.73, ["Fly|Ride"] = 525, ["Neon"] = 1553.06, ["Neon|Ride"] = 1376.76, ["Neon|Fly|Ride"] = 1706.31, ["Mega|Fly|Ride"] = 4981.36}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 4.45, ["Fly"] = 104.11, ["Ride"] = 36.27, ["Fly|Ride"] = 118.13, ["Neon"] = 32.67, ["Neon|Ride"] = 99.2, ["Neon|Fly|Ride"] = 195.18, ["Mega"] = 126, ["Mega|Fly"] = 263.92, ["Mega|Ride"] = 589.52, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 104.08, ["Fly"] = 198.39, ["Ride"] = 118.44, ["Fly|Ride"] = 203.23, ["Neon"] = 443.62, ["Neon|Fly"] = 525, ["Neon|Ride"] = 446.25, ["Neon|Fly|Ride"] = 551.25, ["Mega|Fly|Ride"] = 2486.93}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.09, ["Fly"] = 19.18, ["Ride"] = 15.44, ["Fly|Ride"] = 31.05, ["Neon"] = 162.16, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 2559.45, ["Mega|Fly|Ride"] = 967.58}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 7.86}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 73.41, ["Ride"] = 85.32, ["Fly|Ride"] = 426.62, ["Neon"] = 421.32, ["Neon|Fly"] = 425.55, ["Neon|Ride"] = 408.19, ["Neon|Fly|Ride"] = 511.9, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1849.2}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 12.73, ["Fly"] = 78.37, ["Ride"] = 32.96, ["Fly|Ride"] = 98.44, ["Neon"] = 60.38, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 228.56, ["Mega|Fly|Ride"] = 569.49}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 26.25}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 46.44, ["Fly"] = 210, ["Ride"] = 112.04, ["Fly|Ride"] = 85.33, ["Neon"] = 289.04, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 1599.66, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.49, ["Ride"] = 29.23, ["Fly|Ride"] = 137.95, ["Neon"] = 21, ["Neon|Ride"] = 108.87, ["Neon|Fly|Ride"] = 284.75, ["Mega"] = 131.25, ["Mega|Ride"] = 213.42, ["Mega|Fly|Ride"] = 284.75}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 9.93, ["Fly"] = 56.42, ["Ride"] = 25.93, ["Fly|Ride"] = 81.09, ["Neon"] = 162.16, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 212.24, ["Mega|Ride"] = 650.54, ["Mega|Fly|Ride"] = 796.38}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 451.22, ["Fly"] = 569.52, ["Ride"] = 500.26, ["Fly|Ride"] = 525, ["Neon|Fly|Ride"] = 2132.88, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 35.04, ["Fly"] = 100.27, ["Ride"] = 57.59, ["Fly|Ride"] = 131.24, ["Neon"] = 178.18, ["Neon|Ride"] = 259.88, ["Neon|Fly|Ride"] = 326.21, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 1613.43}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 45.64, ["Fly"] = 119.89, ["Ride"] = 52.5, ["Fly|Ride"] = 100.12, ["Neon"] = 373.3, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 458.1, ["Mega|Fly|Ride"] = 942.74}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 18.17, ["Ride"] = 66.8, ["Fly|Ride"] = 92.8, ["Neon"] = 97.12, ["Neon|Fly"] = 106.66, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 183.74, ["Mega"] = 433.02, ["Mega|Fly"] = 525, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 645.87}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 26250, ["Ride"] = 8862, ["Fly|Ride"] = 8012.82, ["Neon|Fly|Ride"] = 17062.5, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1380.47, ["Fly"] = 1486.83, ["Ride"] = 1509.36, ["Fly|Ride"] = 1378.13, ["Neon|Fly|Ride"] = 3896.82, ["Mega|Fly|Ride"] = 15001.88}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 596.26, ["Ride"] = 630.99, ["Fly|Ride"] = 538.13, ["Neon"] = 3626.13, ["Neon|Ride"] = 2161.66, ["Neon|Fly|Ride"] = 2417.61, ["Mega|Fly|Ride"] = 8547.28}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 11.68, ["Fly"] = 20.73, ["Ride"] = 21.73, ["Fly|Ride"] = 42, ["Neon"] = 68.98, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 129.94, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 569.49}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 3.39, ["Fly"] = 78.74, ["Ride"] = 24.94, ["Fly|Ride"] = 182.39, ["Neon"] = 21.29, ["Neon|Ride"] = 55.13, ["Mega"] = 159.47, ["Mega|Ride"] = 198.19, ["Mega|Fly|Ride"] = 259.87}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 34.13, ["Fly"] = 61.69, ["Ride"] = 38.25, ["Fly|Ride"] = 84.46, ["Neon"] = 191.99, ["Neon|Ride"] = 169.32, ["Neon|Fly|Ride"] = 198.2, ["Mega|Fly|Ride"] = 587.9}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.93, ["Fly"] = 16.01, ["Ride"] = 17.01, ["Fly|Ride"] = 36.08, ["Neon"] = 31.5, ["Neon|Fly"] = 76.92, ["Neon|Ride"] = 47.01, ["Neon|Fly|Ride"] = 84.96, ["Mega"] = 261.19, ["Mega|Ride"] = 437.3, ["Mega|Fly|Ride"] = 427.88}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 334.59, ["Fly"] = 369.49, ["Ride"] = 321.56, ["Fly|Ride"] = 362.15, ["Neon"] = 1564.58, ["Neon|Fly|Ride"] = 1692.44, ["Mega|Fly|Ride"] = 3654}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 16.02, ["Fly"] = 60.52, ["Ride"] = 30.94, ["Fly|Ride"] = 96.81, ["Neon"] = 208.95, ["Neon|Fly"] = 314.62, ["Neon|Ride"] = 131.15, ["Neon|Fly|Ride"] = 257.25, ["Mega"] = 810.5, ["Mega|Ride"] = 787.4, ["Mega|Fly|Ride"] = 721.77}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 9.09, ["Fly"] = 20.99, ["Ride"] = 24.54, ["Fly|Ride"] = 32.68, ["Neon"] = 142.93, ["Neon|Fly"] = 137.95, ["Neon|Ride"] = 130.45, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 425.25}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 577.86, ["Fly"] = 1048.69, ["Ride"] = 532.21, ["Fly|Ride"] = 546.07, ["Neon|Fly|Ride"] = 2417.61, ["Mega|Fly|Ride"] = 12498.56}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1263.94, ["Ride"] = 1115.62, ["Fly|Ride"] = 1384.59, ["Neon"] = 4977.38, ["Neon|Ride"] = 4692.31, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13385.12}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 68.25, ["Fly"] = 138.67, ["Ride"] = 114.63, ["Fly|Ride"] = 108.61, ["Neon"] = 971.25, ["Neon|Ride"] = 585.46, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 2557.31}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 183.45, ["Fly"] = 203.43, ["Ride"] = 189.15, ["Fly|Ride"] = 202.13, ["Neon"] = 864.95, ["Neon|Ride"] = 643.13, ["Neon|Fly|Ride"] = 565.63, ["Mega|Ride"] = 9187.5, ["Mega|Fly|Ride"] = 2820.78}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 44.82, ["Fly"] = 122.67, ["Ride"] = 53.81, ["Fly|Ride"] = 123.43, ["Neon"] = 233.88, ["Neon|Ride"] = 272.98, ["Mega|Ride"] = 2132.88, ["Mega|Fly|Ride"] = 1066.45}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 210, ["Ride"] = 127.99, ["Fly|Ride"] = 412.76, ["Neon|Fly"] = 967.98, ["Neon|Fly|Ride"] = 1354.61, ["Mega|Fly|Ride"] = 4692.31}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2098.06, ["Ride"] = 2275.93, ["Fly|Ride"] = 2231.25, ["Neon|Fly|Ride"] = 10664.3, ["Mega|Fly|Ride"] = 29833.78}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 53.79, ["Fly"] = 213.31, ["Ride"] = 51.84, ["Fly|Ride"] = 196.88, ["Neon"] = 327.44, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 343.87, ["Mega|Ride"] = 1137.9, ["Mega|Fly|Ride"] = 1451.37}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 656.15, ["Ride"] = 656.04, ["Fly|Ride"] = 653.63, ["Neon|Fly|Ride"] = 1345.32, ["Mega|Fly|Ride"] = 3412.5}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 38.98, ["Fly"] = 47.67, ["Ride"] = 45.01, ["Fly|Ride"] = 77.95, ["Neon"] = 426.62, ["Neon|Ride"] = 270.88, ["Neon|Fly|Ride"] = 236.62, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 2.63, ["Fly"] = 43.2, ["Ride"] = 17.75, ["Fly|Ride"] = 41.62, ["Neon"] = 26.16, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 36.66, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 166.22, ["Mega|Fly"] = 249.38, ["Mega|Ride"] = 184.98, ["Mega|Fly|Ride"] = 306.66}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 40.2, ["Ride"] = 128.31, ["Fly|Ride"] = 207.99, ["Neon"] = 351.96, ["Neon|Ride"] = 384.97, ["Neon|Fly|Ride"] = 711.33, ["Mega"] = 1559.13, ["Mega|Fly|Ride"] = 1695.2}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 836.79, ["Fly"] = 910.93, ["Ride"] = 846.57, ["Fly|Ride"] = 834.75, ["Neon|Ride"] = 2830.04, ["Neon|Fly|Ride"] = 2690.63, ["Mega|Fly|Ride"] = 11346.82}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 721.87, ["Ride"] = 1055.09, ["Fly|Ride"] = 852.15, ["Neon|Fly|Ride"] = 4256.14, ["Mega|Fly|Ride"] = 15497.36}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 11.82, ["Fly"] = 26.25, ["Ride"] = 24.04, ["Fly|Ride"] = 38.7, ["Neon"] = 105, ["Neon|Ride"] = 106.65, ["Neon|Fly|Ride"] = 144.38, ["Mega|Fly|Ride"] = 846.64}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 7.76, ["Ride"] = 27.19, ["Fly|Ride"] = 114.13, ["Neon"] = 141.44, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 250.04, ["Mega"] = 662.82, ["Mega|Ride"] = 426.59, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.29, ["Ride"] = 21.74, ["Fly|Ride"] = 102.38, ["Neon"] = 18.38, ["Neon|Fly"] = 323.08, ["Neon|Ride"] = 56.16, ["Neon|Fly|Ride"] = 162.08, ["Mega"] = 166.11, ["Mega|Fly"] = 549.11, ["Mega|Ride"] = 283.65, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 32.24, ["Fly"] = 57.26, ["Ride"] = 39, ["Fly|Ride"] = 85.42, ["Neon"] = 240.47, ["Neon|Ride"] = 216.57, ["Neon|Fly|Ride"] = 233.04, ["Mega|Fly|Ride"] = 818.92}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 41.9, ["Ride"] = 105, ["Fly|Ride"] = 456.48, ["Neon"] = 428.35, ["Neon|Ride"] = 489.13, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2062.49, ["Mega|Ride"] = 1599.66, ["Mega|Fly|Ride"] = 1564.47}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 11.38, ["Fly"] = 43.3, ["Ride"] = 35.44, ["Fly|Ride"] = 88.24, ["Neon"] = 101.33, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 149.43, ["Mega"] = 638.8, ["Mega|Ride"] = 375.39, ["Mega|Fly|Ride"] = 459.37}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 33.31, ["Fly"] = 59.04, ["Ride"] = 39.37, ["Fly|Ride"] = 76.13, ["Neon"] = 242.82, ["Neon|Fly"] = 1422.73, ["Neon|Ride"] = 196.27, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 2100, ["Mega|Ride"] = 1066.45, ["Mega|Fly|Ride"] = 853.12}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 6.41, ["Fly"] = 38.06, ["Ride"] = 16.01, ["Fly|Ride"] = 41.99, ["Neon"] = 29.54, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 91.74, ["Mega"] = 736.32, ["Mega|Ride"] = 356.2, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.81, ["Fly"] = 46.89, ["Ride"] = 33.01, ["Fly|Ride"] = 63.58, ["Neon"] = 51.74, ["Neon|Fly"] = 114.19, ["Neon|Ride"] = 73.5, ["Neon|Fly|Ride"] = 145.15, ["Mega"] = 314.62, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 665.22}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 48.66, ["Fly"] = 65.63, ["Ride"] = 53.8, ["Fly|Ride"] = 94.79, ["Neon"] = 419.87, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1074.91}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1575, ["Fly"] = 1575, ["Ride"] = 1422.75, ["Fly|Ride"] = 1483.13, ["Neon|Fly|Ride"] = 3863.98, ["Mega|Fly|Ride"] = 18373.69}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 461.98, ["Fly"] = 505.08, ["Ride"] = 446.25, ["Fly|Ride"] = 511.77, ["Neon|Fly|Ride"] = 2362.5}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 295.45, ["Ride"] = 288.75, ["Fly|Ride"] = 433.13, ["Neon"] = 1207.5, ["Neon|Ride"] = 1564.47, ["Neon|Fly|Ride"] = 1707.78, ["Mega|Fly|Ride"] = 7644}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 45.72}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 27.57, ["Fly"] = 131.25, ["Ride"] = 47.16, ["Fly|Ride"] = 97.12, ["Neon|Fly"] = 426.62, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 354.38, ["Mega|Ride"] = 1563.39, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 34128.13, ["Fly"] = 65625, ["Ride"] = 35437.5, ["Fly|Ride"] = 17979.94, ["Neon|Fly|Ride"] = 35437.49, ["Mega"] = 213285.8, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 255.12, ["Fly"] = 341.3, ["Ride"] = 282.54, ["Fly|Ride"] = 367.53, ["Neon"] = 1050, ["Neon|Fly"] = 1130.11, ["Neon|Ride"] = 882.54, ["Neon|Fly|Ride"] = 984.38, ["Mega"] = 4265.73, ["Mega|Ride"] = 4264.67, ["Mega|Fly|Ride"] = 3253.37}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 210.58, ["Fly"] = 525, ["Ride"] = 213.31, ["Fly|Ride"] = 203.44, ["Neon|Fly|Ride"] = 1774.29}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 168.53, ["Fly"] = 284.78, ["Ride"] = 157.49, ["Fly|Ride"] = 252.83, ["Neon"] = 639.92, ["Neon|Ride"] = 821.18, ["Neon|Fly|Ride"] = 638.05, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 14.11, ["Fly"] = 94.5, ["Ride"] = 30.19, ["Fly|Ride"] = 126, ["Neon|Ride"] = 89.46, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 723.28, ["Mega|Ride"] = 711.33, ["Mega|Fly|Ride"] = 775.31}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3937.5, ["Ride"] = 3937.5, ["Fly|Ride"] = 5113.9, ["Neon"] = 27729.11, ["Neon|Fly|Ride"] = 28438.48}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 23.54, ["Fly"] = 64, ["Ride"] = 28.88, ["Fly|Ride"] = 48.09, ["Neon|Ride"] = 343.88, ["Neon|Fly|Ride"] = 242.09, ["Mega|Fly|Ride"] = 731.58}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 44.77, ["Fly"] = 106.51, ["Ride"] = 55.63, ["Fly|Ride"] = 89.99, ["Neon"] = 413.82, ["Neon|Fly"] = 1422.73, ["Neon|Ride"] = 204.75, ["Neon|Fly|Ride"] = 248.07, ["Mega|Fly|Ride"] = 1372.88}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 630, ["Ride"] = 728.44, ["Fly|Ride"] = 853.21, ["Neon|Ride"] = 2844.18, ["Neon|Fly|Ride"] = 1926.75, ["Mega|Fly|Ride"] = 8531.44}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 9.85, ["Fly"] = 26.16, ["Ride"] = 24.76, ["Fly|Ride"] = 39.17, ["Neon"] = 118.12, ["Neon|Fly"] = 161.05, ["Neon|Ride"] = 127.17, ["Neon|Fly|Ride"] = 153.57, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 8.89, ["Ride"] = 27.57, ["Fly|Ride"] = 80, ["Neon"] = 95.82, ["Neon|Ride"] = 120.96, ["Neon|Fly|Ride"] = 209.09, ["Mega|Ride"] = 831.84}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 101.99, ["Ride"] = 128.63, ["Fly|Ride"] = 156.19, ["Neon"] = 1010.63, ["Neon|Ride"] = 782.77, ["Neon|Fly|Ride"] = 839.29, ["Mega|Fly|Ride"] = 2739.19}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 17.74, ["Fly"] = 42.88, ["Ride"] = 62.91, ["Fly|Ride"] = 131.24, ["Neon"] = 60.94, ["Neon|Fly"] = 96.81, ["Neon|Ride"] = 96.56, ["Neon|Fly|Ride"] = 234.78, ["Mega"] = 303.59, ["Mega|Fly"] = 740.12, ["Mega|Ride"] = 275.47, ["Mega|Fly|Ride"] = 413.44}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3930.83, ["Fly"] = 5969.92, ["Ride"] = 3883.66, ["Fly|Ride"] = 4134.38, ["Neon"] = 19687.5, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 9842.44, ["Mega"] = 37325.03, ["Mega|Fly|Ride"] = 36767.62}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 30.86, ["Fly"] = 48.42, ["Ride"] = 65.63, ["Fly|Ride"] = 129.48, ["Neon"] = 399.26, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 574.23, ["Mega"] = 782.77, ["Mega|Ride"] = 1057.91, ["Mega|Fly|Ride"] = 782.23}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7271.25, ["Fly"] = 8816.8, ["Ride"] = 6857.82, ["Fly|Ride"] = 6956.25, ["Neon|Fly|Ride"] = 17850, ["Mega|Fly|Ride"] = 66117.61}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.02, ["Fly"] = 23.24, ["Ride"] = 14.89, ["Fly|Ride"] = 32.45, ["Neon"] = 24.61, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 222.55, ["Mega|Ride"] = 372.75, ["Mega|Fly|Ride"] = 358.34}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 24.94, ["Fly"] = 38.19, ["Ride"] = 29.05, ["Fly|Ride"] = 51.9, ["Neon"] = 185.59, ["Neon|Fly"] = 235.71, ["Neon|Ride"] = 106.65, ["Neon|Fly|Ride"] = 159.73, ["Mega|Ride"] = 978.48, ["Mega|Fly|Ride"] = 935.82}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.68}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 10.76, ["Ride"] = 33.91, ["Fly|Ride"] = 116.02, ["Neon"] = 96.81, ["Neon|Ride"] = 139.13, ["Neon|Fly|Ride"] = 322.07, ["Mega"] = 1050, ["Mega|Ride"] = 894.75, ["Mega|Fly|Ride"] = 1248.6}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 28.81, ["Fly"] = 113.07, ["Ride"] = 70.7, ["Fly|Ride"] = 99.75, ["Neon"] = 157.85, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 323.15, ["Mega"] = 945, ["Mega|Ride"] = 853.16, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 12.62, ["Fly"] = 20.99, ["Ride"] = 21.19, ["Fly|Ride"] = 34.37, ["Neon|Ride"] = 114.12, ["Neon|Fly|Ride"] = 168, ["Mega"] = 2559.45, ["Mega|Ride"] = 603.54, ["Mega|Fly|Ride"] = 531.57}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8675.96}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.98}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 20.9}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 232.89, ["Ride"] = 356.22, ["Fly|Ride"] = 259.88, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 13.82, ["Fly"] = 135.47, ["Ride"] = 35.57, ["Fly|Ride"] = 128.27, ["Neon"] = 140.7, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 265.13, ["Mega"] = 525, ["Mega|Ride"] = 533.38, ["Mega|Fly|Ride"] = 996.07}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 12.26}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 10.07, ["Ride"] = 30.95, ["Fly|Ride"] = 85.33, ["Neon|Ride"] = 213.3}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 3549.96}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 177.27, ["Fly"] = 426.62, ["Ride"] = 211.31, ["Fly|Ride"] = 497, ["Neon"] = 924.68, ["Neon|Ride"] = 918.75, ["Mega|Ride"] = 4123.9, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 76.01, ["Ride"] = 106.66, ["Fly|Ride"] = 213.31, ["Neon"] = 782.83, ["Neon|Ride"] = 547.78, ["Neon|Fly|Ride"] = 1435.35, ["Mega|Ride"] = 2132.88, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 150.84, ["Fly"] = 314.99, ["Ride"] = 210.16, ["Fly|Ride"] = 196.88, ["Neon"] = 1065.45, ["Neon|Ride"] = 787.4, ["Neon|Fly|Ride"] = 840, ["Mega|Fly|Ride"] = 4777.5}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2388.74, ["Fly"] = 2362.5, ["Ride"] = 1968.75, ["Fly|Ride"] = 2231.25, ["Neon"] = 14980.13, ["Neon|Ride"] = 8871.63, ["Neon|Fly|Ride"] = 7109.9, ["Mega|Fly|Ride"] = 20868.75}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 15.65, ["Fly"] = 105.6, ["Ride"] = 32.71, ["Fly|Ride"] = 99.75, ["Neon"] = 127.32, ["Neon|Ride"] = 154.62, ["Neon|Fly|Ride"] = 199.44, ["Mega"] = 958.74, ["Mega|Ride"] = 1048.62, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 686.44, ["Fly"] = 2100, ["Ride"] = 721.88, ["Fly|Ride"] = 721.88, ["Neon|Ride"] = 3270.75, ["Neon|Fly|Ride"] = 4193.22, ["Mega|Fly|Ride"] = 16932.47}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 40.61}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 14.42, ["Ride"] = 51.86, ["Fly|Ride"] = 471.93, ["Neon"] = 81.29, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 106.5, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 431.19, ["Mega|Ride"] = 484.17, ["Mega|Fly|Ride"] = 506.33}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 6.43, ["Fly"] = 28.81, ["Ride"] = 27.56, ["Fly|Ride"] = 105.6, ["Neon"] = 39.38, ["Neon|Ride"] = 62.93, ["Neon|Fly|Ride"] = 205.76, ["Mega|Ride"] = 393.75}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 52.48}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 16.2, ["Fly"] = 108.92, ["Ride"] = 31.47, ["Fly|Ride"] = 83.21, ["Neon"] = 96.81, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 254.63, ["Mega|Fly|Ride"] = 2259.29}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 26.25, ["Fly"] = 78.93, ["Ride"] = 39.29, ["Fly|Ride"] = 52.41, ["Neon|Ride"] = 512.82, ["Neon|Fly|Ride"] = 323.15, ["Mega|Ride"] = 1814.21, ["Mega|Fly|Ride"] = 989.63}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6037.49, ["Fly"] = 10237.5, ["Ride"] = 7875, ["Fly|Ride"] = 5105.62, ["Neon|Fly|Ride"] = 12468.75, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 8.38, ["Fly"] = 65.63, ["Ride"] = 34.12, ["Fly|Ride"] = 81.37, ["Neon"] = 45.02, ["Neon|Fly"] = 142.93, ["Neon|Ride"] = 81.04, ["Neon|Fly|Ride"] = 206.91, ["Mega"] = 541.85, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 483.16}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 26.92}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 105, ["Fly"] = 377.56, ["Ride"] = 132.59, ["Fly|Ride"] = 183.75, ["Neon"] = 525, ["Neon|Ride"] = 455.44, ["Neon|Fly|Ride"] = 714.8, ["Mega|Fly|Ride"] = 2062.49}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 32.7, ["Fly"] = 145.21, ["Ride"] = 85.89, ["Fly|Ride"] = 163.68, ["Neon"] = 257.24, ["Neon|Ride"] = 272.37, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2418.93, ["Mega|Ride"] = 2879.38, ["Mega|Fly|Ride"] = 1200.94}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 18.46, ["Fly"] = 70.47, ["Ride"] = 30.17, ["Fly|Ride"] = 64.96, ["Neon"] = 116.82, ["Neon|Ride"] = 142.96, ["Neon|Fly|Ride"] = 196.67, ["Mega|Ride"] = 825.43, ["Mega|Fly|Ride"] = 776.99}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 3.77, ["Fly"] = 65.54, ["Ride"] = 22.65, ["Fly|Ride"] = 101.75, ["Neon"] = 32.36, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 51.96, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 180.52, ["Mega|Fly"] = 7015.19, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 285.05}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 10.5, ["Ride"] = 27.99, ["Fly|Ride"] = 94.5, ["Neon"] = 86.87, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 198.19, ["Mega|Ride"] = 645.87, ["Mega|Fly|Ride"] = 767.85}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 16.64, ["Fly"] = 26.17, ["Ride"] = 22.91, ["Fly|Ride"] = 41.56, ["Neon"] = 370.1, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 144.37}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 195.56}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 21.27, ["Ride"] = 131.21, ["Fly|Ride"] = 284.78, ["Neon"] = 170.63, ["Neon|Ride"] = 262.5, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 254, ["Ride"] = 443.63, ["Fly|Ride"] = 1614.09, ["Neon|Fly|Ride"] = 28438.48}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 47.16, ["Fly"] = 212.42, ["Ride"] = 86.62, ["Fly|Ride"] = 216.85, ["Neon"] = 284.29, ["Neon|Ride"] = 295.32, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 1035.57, ["Mega|Ride"] = 971.25, ["Mega|Fly|Ride"] = 1101.71}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 918.65, ["Fly"] = 1351.27, ["Ride"] = 1007.98, ["Fly|Ride"] = 1036.88, ["Neon|Ride"] = 4193.22, ["Neon|Fly|Ride"] = 3589.89, ["Mega|Fly|Ride"] = 11746.87}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 388.49, ["Fly"] = 711.37, ["Ride"] = 413.21, ["Fly|Ride"] = 564.38, ["Neon"] = 2139.38, ["Neon|Ride"] = 2418.93, ["Neon|Fly|Ride"] = 2033.07, ["Mega"] = 12797.16, ["Mega|Fly|Ride"] = 8990.63}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 71.54}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 3.94}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 6.57, ["Fly"] = 20.75, ["Ride"] = 24.03, ["Fly|Ride"] = 47.64, ["Neon"] = 78.75, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 82.43, ["Neon|Fly|Ride"] = 166.69, ["Mega"] = 437.26, ["Mega|Ride"] = 711.33, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 262.5, ["Fly"] = 392.03, ["Ride"] = 274.32, ["Fly|Ride"] = 346.5, ["Neon"] = 1128.39, ["Neon|Ride"] = 1069.69, ["Neon|Fly|Ride"] = 1062.55, ["Mega|Fly|Ride"] = 3363.53}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 16.04}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 118.13, ["Ride"] = 169.32, ["Fly|Ride"] = 259.87, ["Neon"] = 633.71, ["Neon|Ride"] = 639.87, ["Neon|Fly|Ride"] = 728.44, ["Mega"] = 10664.3, ["Mega|Ride"] = 3113.98, ["Mega|Fly|Ride"] = 3408.33}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 112.88, ["Ride"] = 128.76, ["Fly|Ride"] = 213.31, ["Neon"] = 853.21, ["Neon|Fly"] = 590.63, ["Neon|Ride"] = 2346.16, ["Neon|Fly|Ride"] = 913.5, ["Mega|Fly|Ride"] = 2559.45}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 3.82, ["Ride"] = 26.25, ["Fly|Ride"] = 173.85, ["Neon"] = 26.18, ["Neon|Ride"] = 87.09, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 264.75, ["Mega|Ride"] = 284.75, ["Mega|Fly|Ride"] = 852.09}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 13.27, ["Fly"] = 64, ["Ride"] = 27.13, ["Fly|Ride"] = 77.05, ["Neon"] = 230.37, ["Neon|Ride"] = 113.71, ["Neon|Fly|Ride"] = 322.94, ["Mega|Ride"] = 830.76, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 12.5, ["Fly"] = 102.35, ["Ride"] = 33.75, ["Fly|Ride"] = 104.7, ["Neon"] = 78.75, ["Neon|Ride"] = 101.06, ["Neon|Fly|Ride"] = 256.57, ["Mega"] = 498.75, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 3.6, ["Fly"] = 98.07, ["Ride"] = 38.27, ["Fly|Ride"] = 152.71, ["Neon"] = 22.32, ["Neon|Ride"] = 69.78, ["Neon|Fly|Ride"] = 154.88, ["Mega"] = 131.25, ["Mega|Ride"] = 181.92, ["Mega|Fly|Ride"] = 284.75}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 249.38, ["Ride"] = 290.04, ["Fly|Ride"] = 359.52, ["Neon"] = 1591.24, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 5630.77}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 113.74, ["Fly"] = 569.52, ["Ride"] = 136.5, ["Fly|Ride"] = 241.5, ["Neon"] = 488.25, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 628.69, ["Mega|Fly|Ride"] = 2555.18}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 45.87, ["Fly"] = 167.45, ["Ride"] = 72.19, ["Fly|Ride"] = 127.99, ["Neon"] = 380.63, ["Neon|Ride"] = 460.7, ["Neon|Fly|Ride"] = 416.07, ["Mega|Fly|Ride"] = 1801.13}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 14.65, ["Fly"] = 126, ["Ride"] = 58.24, ["Fly|Ride"] = 284.78, ["Neon|Ride"] = 614.42, ["Neon|Fly|Ride"] = 498.04, ["Mega|Fly|Ride"] = 1992.11}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 13.36, ["Fly"] = 42.67, ["Ride"] = 26.06, ["Fly|Ride"] = 75.73, ["Neon"] = 94.4, ["Neon|Ride"] = 111.56, ["Neon|Fly|Ride"] = 192.31, ["Mega"] = 371.44, ["Mega|Fly"] = 525, ["Mega|Ride"] = 483.79, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 2.1, ["Fly"] = 43.32, ["Ride"] = 19.28, ["Fly|Ride"] = 46.1, ["Neon"] = 17.22, ["Neon|Fly"] = 67.6, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 128.62, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 246.23}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 1037.26, ["Fly"] = 1060.4, ["Ride"] = 883.32, ["Fly|Ride"] = 900.15, ["Neon"] = 3270.99, ["Neon|Fly"] = 3306.69, ["Neon|Ride"] = 5250, ["Neon|Fly|Ride"] = 2624.99, ["Mega|Fly|Ride"] = 10876.53}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 341.25, ["Ride"] = 356.99, ["Fly|Ride"] = 393.75, ["Neon"] = 1277.38, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1678.58, ["Mega"] = 10664.3, ["Mega|Fly|Ride"] = 5970.96}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 62.37, ["Fly"] = 170.65, ["Ride"] = 103.64, ["Fly|Ride"] = 196.88, ["Neon"] = 327.44, ["Neon|Ride"] = 323.05, ["Neon|Fly|Ride"] = 544.28, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 1692.44}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 209.9, ["Fly"] = 283.5, ["Ride"] = 190.75, ["Fly|Ride"] = 262.4, ["Neon|Fly|Ride"] = 1094.62, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 18.33, ["Fly"] = 52.5, ["Ride"] = 22.82, ["Fly|Ride"] = 70.03, ["Neon"] = 157.5, ["Neon|Ride"] = 103.94, ["Neon|Fly|Ride"] = 236.25, ["Mega|Ride"] = 569.49, ["Mega|Fly|Ride"] = 806.73}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 236.25, ["Ride"] = 228.37, ["Fly|Ride"] = 616.77, ["Neon"] = 718.16, ["Neon|Ride"] = 942.27, ["Neon|Fly|Ride"] = 971.25, ["Mega"] = 4173.75, ["Mega|Ride"] = 4692.31, ["Mega|Fly|Ride"] = 4307.31}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 59.07, ["Fly"] = 125.98, ["Ride"] = 76.99, ["Fly|Ride"] = 106.46, ["Neon|Ride"] = 569.49, ["Neon|Fly|Ride"] = 569.49, ["Mega|Fly|Ride"] = 1732.5}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1967.44, ["Ride"] = 2100, ["Fly|Ride"] = 2021.14, ["Neon|Ride"] = 11289.12, ["Neon|Fly|Ride"] = 7612.5, ["Mega"] = 51188.61, ["Mega|Fly|Ride"] = 24884.07}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 11.23, ["Fly"] = 77.15, ["Ride"] = 37.97, ["Fly|Ride"] = 51.45, ["Neon"] = 59.07, ["Neon|Fly"] = 142.93, ["Neon|Ride"] = 95.37, ["Neon|Fly|Ride"] = 193.52, ["Mega"] = 494.82, ["Mega|Fly"] = 561.43, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 53.05, ["Ride"] = 72.18, ["Fly|Ride"] = 105, ["Neon"] = 223.13, ["Neon|Ride"] = 356.2, ["Neon|Fly|Ride"] = 759.31, ["Mega"] = 1693.27, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 75.74, ["Fly"] = 82.85, ["Ride"] = 69.76, ["Fly|Ride"] = 78.74, ["Neon"] = 525, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1879.8}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2135.97, ["Fly"] = 1614.09, ["Ride"] = 1069.68, ["Fly|Ride"] = 1168.13, ["Neon|Ride"] = 5160.78, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 482.13, ["Fly"] = 525, ["Ride"] = 746.58, ["Fly|Ride"] = 616.88, ["Neon|Fly|Ride"] = 3225.66}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 68.06, ["Fly"] = 323.08, ["Ride"] = 86.13, ["Fly|Ride"] = 196.88, ["Neon"] = 446.8, ["Neon|Ride"] = 393.74, ["Neon|Fly|Ride"] = 459.38, ["Mega|Ride"] = 2702.35, ["Mega|Fly|Ride"] = 2844.18}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 8.48, ["Ride"] = 21.25, ["Fly|Ride"] = 61.53, ["Neon"] = 73.59, ["Neon|Fly"] = 142.93, ["Neon|Ride"] = 69.83, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 603.75, ["Mega|Ride"] = 772.11}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 41.18, ["Fly"] = 68.25, ["Ride"] = 54.57, ["Fly|Ride"] = 106.66, ["Neon"] = 213.31, ["Neon|Fly"] = 334.9, ["Neon|Ride"] = 221.34, ["Neon|Fly|Ride"] = 236.24, ["Mega"] = 1706.25, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 741.57, ["Fly"] = 1113.17, ["Ride"] = 759.94, ["Fly|Ride"] = 832.11, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2184.27, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 706.12}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 5236.88, ["Ride"] = 4364.07, ["Fly|Ride"] = 5972.44, ["Neon"] = 42000, ["Neon|Ride"] = 30564.94, ["Neon|Fly|Ride"] = 17584.88, ["Mega|Fly|Ride"] = 91002.66}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 274.16, ["Fly"] = 399.96, ["Ride"] = 393.75, ["Neon"] = 1706.42, ["Neon|Fly|Ride"] = 2231.25, ["Mega"] = 6397.53, ["Mega|Fly|Ride"] = 6773}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 70.76, ["Fly"] = 284.78, ["Ride"] = 121.96, ["Fly|Ride"] = 336, ["Neon|Ride"] = 569.49, ["Neon|Fly|Ride"] = 639.87, ["Mega|Fly|Ride"] = 2166.31}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 15.54, ["Fly"] = 42.09, ["Ride"] = 29.33, ["Fly|Ride"] = 64.75, ["Neon"] = 152.24, ["Neon|Fly"] = 1291.03, ["Neon|Ride"] = 125.9, ["Neon|Fly|Ride"] = 181.43, ["Mega"] = 993.92, ["Mega|Ride"] = 853.16, ["Mega|Fly|Ride"] = 711.33}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 9.86, ["Fly"] = 34.15, ["Ride"] = 19.29, ["Fly|Ride"] = 45.28, ["Neon"] = 213.31, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2132.88}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 14.12, ["Ride"] = 27.56, ["Fly|Ride"] = 121.21, ["Neon"] = 106.6, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 233.63, ["Mega"] = 645.75, ["Mega|Ride"] = 658.88, ["Mega|Fly|Ride"] = 626.07}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.61, ["Fly"] = 78.93, ["Ride"] = 22.09, ["Fly|Ride"] = 48.47, ["Neon"] = 35.44, ["Neon|Ride"] = 56.11, ["Neon|Fly|Ride"] = 104.03, ["Mega"] = 322.07, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 284.75}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 23.5, ["Fly"] = 90.57, ["Ride"] = 39.37, ["Fly|Ride"] = 139.13, ["Neon"] = 157.5, ["Neon|Fly"] = 853.16, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 426.59, ["Mega"] = 613.75, ["Mega|Ride"] = 1260}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 456.65, ["Fly"] = 465.94, ["Ride"] = 452.24, ["Fly|Ride"] = 521.51, ["Neon"] = 1599.76, ["Neon|Ride"] = 1529.28, ["Neon|Fly|Ride"] = 1371.57, ["Mega"] = 7875, ["Mega|Fly|Ride"] = 5544.38}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.47, ["Fly"] = 19.56, ["Ride"] = 15.54, ["Fly|Ride"] = 28.81, ["Neon"] = 19.46, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 70.35, ["Mega"] = 853.16, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 42, ["Fly"] = 83.24, ["Ride"] = 69.21, ["Fly|Ride"] = 128.64, ["Neon"] = 183.73, ["Neon|Fly"] = 356.22, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 255.94, ["Mega"] = 519.02, ["Mega|Ride"] = 622.55, ["Mega|Fly|Ride"] = 577.4}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 787.5, ["Ride"] = 748.12, ["Fly|Ride"] = 756.39, ["Neon|Ride"] = 1988.23, ["Neon|Fly|Ride"] = 1704.91, ["Mega|Fly|Ride"] = 3936.18}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 28.87, ["Fly"] = 57.36, ["Ride"] = 43.59, ["Fly|Ride"] = 76.5, ["Neon|Ride"] = 188.89, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 851.75}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 392.44, ["Fly"] = 388.45, ["Ride"] = 290.76, ["Fly|Ride"] = 391.13, ["Neon|Ride"] = 1849.2, ["Neon|Fly|Ride"] = 1279.73}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 181.91, ["Fly"] = 176.69, ["Ride"] = 196.87, ["Fly|Ride"] = 203.25, ["Neon"] = 996.13, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 853.16, ["Mega|Fly|Ride"] = 3541.63}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 834.74, ["Ride"] = 754.69, ["Fly|Ride"] = 786.19, ["Neon|Fly|Ride"] = 3040.61, ["Mega|Fly|Ride"] = 7611.19}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 19.31, ["Fly"] = 85.33, ["Ride"] = 41.61, ["Fly|Ride"] = 100.42, ["Neon"] = 106.66, ["Neon|Fly"] = 290.4, ["Neon|Ride"] = 108.8, ["Neon|Fly|Ride"] = 185.58, ["Mega"] = 354.38, ["Mega|Ride"] = 371.93, ["Mega|Fly|Ride"] = 460.7}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4084.49, ["Fly"] = 3302.99, ["Ride"] = 3936.19, ["Fly|Ride"] = 3353.43, ["Neon"] = 14220.77, ["Neon|Fly|Ride"] = 7350, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 116.95, ["Fly"] = 169.7, ["Ride"] = 138.56, ["Fly|Ride"] = 162.16, ["Neon"] = 433.13, ["Neon|Fly"] = 582.75, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 577.5, ["Mega|Fly|Ride"] = 2346.16}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.25, ["Fly"] = 27.75, ["Ride"] = 21, ["Fly|Ride"] = 35.44, ["Neon"] = 19.82, ["Neon|Fly"] = 65.62, ["Neon|Ride"] = 35.35, ["Neon|Fly|Ride"] = 85.22, ["Mega"] = 153.58, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 370.08, ["Mega|Fly|Ride"] = 227.07}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.5, ["Ride"] = 24.56, ["Fly|Ride"] = 57.71, ["Neon"] = 20.58, ["Neon|Fly"] = 118.54, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 162.08, ["Mega"] = 153.79, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 360.94}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 34.76, ["Fly"] = 85.33, ["Ride"] = 42.87, ["Fly|Ride"] = 56.34, ["Neon|Fly|Ride"] = 301.88, ["Mega|Fly|Ride"] = 1070.9}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 974.52, ["Ride"] = 1174.69, ["Fly|Ride"] = 1181.25}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6453.8, ["Ride"] = 7395.15, ["Fly|Ride"] = 6431.25}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 20.08, ["Fly"] = 36.27, ["Ride"] = 24.94, ["Fly|Ride"] = 41.89, ["Neon"] = 452.13, ["Neon|Ride"] = 284.75, ["Neon|Fly|Ride"] = 165.55, ["Mega"] = 2520, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 11.46, ["Fly"] = 57.61, ["Ride"] = 27.46, ["Fly|Ride"] = 75.8, ["Neon"] = 89.25, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 107.63, ["Neon|Fly|Ride"] = 183.44, ["Mega"] = 270.88, ["Mega|Ride"] = 554.55, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 74.82, ["Fly"] = 157.49, ["Ride"] = 78.74, ["Fly|Ride"] = 123.12, ["Neon"] = 426.62, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 465.84, ["Mega|Fly|Ride"] = 1889.72}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 267.74, ["Ride"] = 212.94, ["Fly|Ride"] = 271.9, ["Neon|Ride"] = 996.07, ["Neon|Fly|Ride"] = 981.12, ["Mega|Fly|Ride"] = 4517.36}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.36, ["Ride"] = 32.78, ["Fly|Ride"] = 93.09, ["Neon"] = 19.84, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 49.53, ["Neon|Fly|Ride"] = 81.04, ["Mega"] = 151.5, ["Mega|Fly"] = 226.4, ["Mega|Ride"] = 191.22, ["Mega|Fly|Ride"] = 290.09}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 192.83, ["Ride"] = 234.88, ["Fly|Ride"] = 288.73, ["Neon"] = 1050, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1613.43, ["Mega"] = 3269.69, ["Mega|Fly|Ride"] = 3541.63}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.5, ["Fly"] = 42.67, ["Ride"] = 14.86, ["Fly|Ride"] = 56.88, ["Neon"] = 19.69, ["Neon|Fly"] = 127.99, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 104.5, ["Mega"] = 223.13, ["Mega|Ride"] = 223.12, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 208.57, ["Fly"] = 284.78, ["Ride"] = 216.57, ["Fly|Ride"] = 233.89, ["Neon|Ride"] = 1209.48, ["Neon|Fly|Ride"] = 966.91, ["Mega"] = 10664.3, ["Mega|Ride"] = 4835.2, ["Mega|Fly|Ride"] = 4977.04}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 10.33, ["Fly"] = 75.12, ["Ride"] = 24.54, ["Fly|Ride"] = 68.25, ["Neon"] = 73.5, ["Neon|Fly"] = 307.34, ["Neon|Ride"] = 157.84, ["Neon|Fly|Ride"] = 115.66, ["Mega"] = 498.04, ["Mega|Ride"] = 540.69, ["Mega|Fly|Ride"] = 498.04}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 3.73, ["Ride"] = 21.35, ["Fly|Ride"] = 72.19, ["Neon"] = 7.7, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 195.56, ["Mega"] = 70.88, ["Mega|Ride"] = 105.4, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.63, ["Mega"] = 17.8, ["Mega|Ride"] = 142.73, ["Mega|Fly|Ride"] = 319.95}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.15, ["Fly"] = 52.49, ["Ride"] = 31.25, ["Fly|Ride"] = 109.87, ["Neon"] = 6.01, ["Neon|Ride"] = 43.43, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 73.5, ["Mega|Fly"] = 161262.29, ["Mega|Ride"] = 92.6, ["Mega|Fly|Ride"] = 202.13}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 114.14, ["Fly"] = 149.97, ["Ride"] = 112.25, ["Fly|Ride"] = 196.23, ["Neon"] = 278.36, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 368.8, ["Mega|Fly|Ride"] = 1231.53}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 35.1, ["Ride"] = 15.73, ["Fly|Ride"] = 113.07, ["Neon"] = 9.16, ["Neon|Ride"] = 28.81, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 96.76, ["Mega|Ride"] = 165.38, ["Mega|Fly|Ride"] = 261.44}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 6.85, ["Neon"] = 78.61, ["Neon|Ride"] = 213.3, ["Neon|Fly|Ride"] = 223.11, ["Mega"] = 393.74, ["Mega|Ride"] = 552.88}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Ride"] = 28.81, ["Neon"] = 2.51, ["Neon|Ride"] = 52.36, ["Neon|Fly|Ride"] = 274.54, ["Mega"] = 17.99, ["Mega|Fly"] = 142.92, ["Mega|Ride"] = 49.38, ["Mega|Fly|Ride"] = 322.02}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 1.79, ["Fly"] = 63.66, ["Ride"] = 15.74, ["Fly|Ride"] = 36.27, ["Neon"] = 2.1, ["Neon|Fly"] = 26.22, ["Neon|Ride"] = 15.54, ["Neon|Fly|Ride"] = 38.72, ["Mega"] = 15.28, ["Mega|Fly"] = 42.67, ["Mega|Ride"] = 16.99, ["Mega|Fly|Ride"] = 64.32}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 18.15, ["Ride"] = 15.15, ["Fly|Ride"] = 64.14, ["Neon"] = 2.1, ["Neon|Fly"] = 38.1, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 39.16, ["Mega"] = 140.94, ["Mega|Fly"] = 162.08, ["Mega|Ride"] = 30.56, ["Mega|Fly|Ride"] = 87.94}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.61, ["Neon|Ride"] = 66.89, ["Mega"] = 20.26, ["Mega|Ride"] = 152.41}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 91.85, ["Ride"] = 31.45, ["Fly|Ride"] = 107.61, ["Neon"] = 6.36, ["Neon|Fly"] = 167.99, ["Neon|Ride"] = 20.66, ["Neon|Fly|Ride"] = 80.56, ["Mega"] = 24.71, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 42.88, ["Mega|Fly|Ride"] = 95.42}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.84, ["Neon|Ride"] = 82.09, ["Neon|Fly|Ride"] = 426.59, ["Mega"] = 14.99, ["Mega|Fly"] = 138.66, ["Mega|Ride"] = 806.73, ["Mega|Fly|Ride"] = 213.3}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 3.18, ["Fly"] = 71.47, ["Ride"] = 32.79, ["Fly|Ride"] = 47.78, ["Neon"] = 16.7, ["Neon|Fly"] = 69.28, ["Neon|Ride"] = 45.92, ["Neon|Fly|Ride"] = 120.96, ["Mega"] = 115.49, ["Mega|Fly"] = 284.75, ["Mega|Ride"] = 152.25, ["Mega|Fly|Ride"] = 157.4}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 27.75, ["Neon"] = 2.1, ["Neon|Ride"] = 77.87, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 14.59, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 62.37, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.63, ["Ride"] = 143.99, ["Fly|Ride"] = 525, ["Neon"] = 18.12, ["Mega"] = 162.74, ["Mega|Fly"] = 315, ["Mega|Ride"] = 284.75, ["Mega|Fly|Ride"] = 552.43}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 27.79, ["Neon"] = 16.92, ["Mega"] = 104.99, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 569.49}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.51, ["Ride"] = 32.8, ["Neon"] = 3.93, ["Neon|Ride"] = 27.34, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 19.26, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 131.23}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 14, ["Fly|Ride"] = 40.69, ["Neon"] = 2.1, ["Neon|Fly"] = 35.32, ["Neon|Ride"] = 15.6, ["Neon|Fly|Ride"] = 32.75, ["Mega"] = 13.97, ["Mega|Fly"] = 28.92, ["Mega|Ride"] = 18.46, ["Mega|Fly|Ride"] = 50.68}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 229.68, ["Fly|Ride"] = 118.11, ["Neon"] = 37.41, ["Neon|Ride"] = 45.94, ["Mega"] = 170.64, ["Mega|Ride"] = 240.19}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 27.01, ["Neon"] = 3.62, ["Neon|Ride"] = 28.76, ["Neon|Fly|Ride"] = 105, ["Mega"] = 37.51, ["Mega|Ride"] = 45.85, ["Mega|Fly|Ride"] = 174.91}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 3.02, ["Neon"] = 15.23, ["Neon|Fly|Ride"] = 142.92, ["Mega"] = 85.67, ["Mega|Ride"] = 162.11, ["Mega|Fly|Ride"] = 239.96}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.51, ["Fly"] = 65.63, ["Ride"] = 46.95, ["Fly|Ride"] = 194.12, ["Neon"] = 23.16, ["Neon|Ride"] = 50.13, ["Neon|Fly|Ride"] = 142.92, ["Mega"] = 124.69, ["Mega|Ride"] = 143.06, ["Mega|Fly|Ride"] = 193.41}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 19.34, ["Ride"] = 11.24, ["Fly|Ride"] = 26.99, ["Neon"] = 2.1, ["Neon|Fly"] = 15.62, ["Neon|Ride"] = 11.46, ["Neon|Fly|Ride"] = 27.72, ["Mega"] = 14.76, ["Mega|Fly"] = 27.46, ["Mega|Ride"] = 21.78, ["Mega|Fly|Ride"] = 41.97}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 28.81, ["Ride"] = 27.39, ["Fly|Ride"] = 131.25, ["Neon"] = 9.74, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 129.54, ["Mega|Ride"] = 160.78, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 3.61, ["Fly"] = 112.52, ["Ride"] = 23.52, ["Fly|Ride"] = 59.06, ["Neon"] = 44.52, ["Neon|Ride"] = 67.48, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 255.94, ["Mega|Ride"] = 341.28, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 16.01, ["Ride"] = 13.01, ["Fly|Ride"] = 42.95, ["Neon"] = 2.36, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 14.27, ["Neon|Fly|Ride"] = 41.08, ["Mega"] = 24.21, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 99.75}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 178.12, ["Ride"] = 29.93, ["Neon"] = 5.01, ["Neon|Ride"] = 28.81, ["Neon|Fly|Ride"] = 167.25, ["Mega"] = 63.93, ["Mega|Fly"] = 170.64, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.5, ["Ride"] = 35.44, ["Neon"] = 4.83, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 142.92, ["Mega"] = 28.38, ["Mega|Fly"] = 142.92, ["Mega|Ride"] = 72.1, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 36.27, ["Ride"] = 18.18, ["Neon"] = 2.1, ["Neon|Fly"] = 42.67, ["Neon|Ride"] = 33.07, ["Neon|Fly|Ride"] = 284.75, ["Mega"] = 15.87, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 178.11}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 71.47, ["Ride"] = 16.01, ["Fly|Ride"] = 46.45, ["Neon"] = 7.65, ["Neon|Fly"] = 28.81, ["Neon|Ride"] = 21.05, ["Neon|Fly|Ride"] = 57.66, ["Mega"] = 143.16, ["Mega|Ride"] = 91.73, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 55.47, ["Neon"] = 7.45, ["Neon|Ride"] = 61.93, ["Mega"] = 33.5, ["Mega|Ride"] = 95.95, ["Mega|Fly|Ride"] = 249.37}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 23.07, ["Ride"] = 15.3, ["Fly|Ride"] = 72.19, ["Neon"] = 5.2, ["Neon|Fly"] = 79.97, ["Neon|Ride"] = 21.37, ["Neon|Fly|Ride"] = 57.54, ["Mega"] = 103.69, ["Mega|Ride"] = 90.54, ["Mega|Fly|Ride"] = 142.94}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 6.46, ["Ride"] = 36.27, ["Fly|Ride"] = 50.05, ["Neon"] = 42, ["Neon|Fly"] = 249.58, ["Neon|Fly|Ride"] = 327.3, ["Mega"] = 98.44, ["Mega|Ride"] = 168.38}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 18.3, ["Fly|Ride"] = 57.48, ["Neon"] = 33.7, ["Neon|Fly"] = 48.42, ["Neon|Ride"] = 30.57, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 315, ["Mega|Fly"] = 420, ["Mega|Ride"] = 179.02, ["Mega|Fly|Ride"] = 253.82}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 19.02, ["Ride"] = 26.25, ["Fly|Ride"] = 52.48, ["Neon"] = 14.91, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 72.17, ["Mega"] = 221.83, ["Mega|Fly"] = 138.99, ["Mega|Ride"] = 164.51, ["Mega|Fly|Ride"] = 177.17}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 8.4, ["Fly"] = 111.56, ["Neon"] = 26.25, ["Neon|Ride"] = 105.25, ["Mega"] = 154.33, ["Mega|Ride"] = 236.24}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 13.95, ["Ride"] = 56.44, ["Neon"] = 262.4, ["Neon|Ride"] = 241.9, ["Neon|Fly|Ride"] = 126, ["Mega"] = 569.49, ["Mega|Ride"] = 714.26, ["Mega|Fly|Ride"] = 809.43}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 6.28, ["Ride"] = 28.81, ["Neon"] = 42.67, ["Neon|Ride"] = 126, ["Mega"] = 236.25, ["Mega|Ride"] = 365.53}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 4.72, ["Ride"] = 28.81, ["Fly|Ride"] = 120.75, ["Neon"] = 52.16, ["Neon|Ride"] = 79.75, ["Mega"] = 483.79, ["Mega|Ride"] = 421.25, ["Mega|Fly|Ride"] = 364.23}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.02, ["Neon|Ride"] = 64.99, ["Mega"] = 21.41, ["Mega|Fly"] = 64, ["Mega|Ride"] = 67.19, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 42.47}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 4.86, ["Fly"] = 23.61, ["Ride"] = 21.5, ["Fly|Ride"] = 41.57, ["Neon"] = 48.42, ["Neon|Fly"] = 188.48, ["Neon|Ride"] = 47.75, ["Neon|Fly|Ride"] = 78.62, ["Mega"] = 271.44, ["Mega|Ride"] = 208.69, ["Mega|Fly|Ride"] = 297.28}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 15.75, ["Fly|Ride"] = 52.5, ["Neon"] = 4.19, ["Neon|Fly"] = 32.68, ["Neon|Ride"] = 26.41, ["Neon|Fly|Ride"] = 159.67, ["Mega"] = 24.94, ["Mega|Fly"] = 142.92, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Neon"] = 5.04, ["Neon|Ride"] = 34.11, ["Neon|Fly|Ride"] = 96.59, ["Mega"] = 39.25, ["Mega|Ride"] = 242.09, ["Mega|Fly|Ride"] = 133.88}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 50.14, ["Ride"] = 19.21, ["Fly|Ride"] = 42.83, ["Neon"] = 4.86, ["Neon|Ride"] = 20.28, ["Neon|Fly|Ride"] = 127.65, ["Mega"] = 130.12, ["Mega|Ride"] = 118, ["Mega|Fly|Ride"] = 188.07}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.81, ["Ride"] = 41.91, ["Fly|Ride"] = 57.75, ["Neon"] = 35.05, ["Neon|Ride"] = 131.06, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 128.63, ["Mega|Ride"] = 284.75, ["Mega|Fly|Ride"] = 318.88}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 32.15, ["Neon"] = 3.59, ["Mega"] = 19.44, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 60.38, ["Mega|Fly|Ride"] = 341.28}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 21.9, ["Ride"] = 16.75, ["Fly|Ride"] = 32.71, ["Neon"] = 3.67, ["Neon|Fly"] = 111.47, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 28.87, ["Mega|Fly"] = 143.16, ["Mega|Ride"] = 39.09, ["Mega|Fly|Ride"] = 162.08}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.81, ["Ride"] = 18.19, ["Fly|Ride"] = 42.14, ["Neon"] = 4.98, ["Neon|Fly"] = 53.34, ["Neon|Ride"] = 18.15, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 57.61, ["Mega|Fly"] = 142.92, ["Mega|Ride"] = 40.95, ["Mega|Fly|Ride"] = 99.75}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 28.81, ["Ride"] = 54, ["Fly|Ride"] = 142.93, ["Neon"] = 6.86, ["Neon|Ride"] = 28.3, ["Neon|Fly|Ride"] = 104.9, ["Mega"] = 44.37, ["Mega|Ride"] = 80.84, ["Mega|Fly|Ride"] = 228.22}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.08, ["Neon|Ride"] = 170.64, ["Neon|Fly|Ride"] = 155777.37, ["Mega"] = 19.69, ["Mega|Fly"] = 96.76, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 136.48}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.89, ["Ride"] = 16.98, ["Fly|Ride"] = 81.06, ["Neon"] = 3.68, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 24.59, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 20.27, ["Mega|Fly"] = 64, ["Mega|Ride"] = 40.42, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Mega"] = 19.68, ["Mega|Ride"] = 425.52}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 4.24, ["Neon|Ride"] = 322.94, ["Neon|Fly|Ride"] = 420, ["Mega"] = 25.35, ["Mega|Ride"] = 154.34}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 13.02, ["Fly|Ride"] = 49.87, ["Neon"] = 5.25, ["Neon|Fly"] = 32.81, ["Neon|Ride"] = 24.54, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 36.75, ["Mega|Ride"] = 49.87, ["Mega|Fly|Ride"] = 107.58}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 9.31, ["Ride"] = 86.63, ["Fly|Ride"] = 213.31, ["Neon"] = 98.44, ["Mega"] = 551.25, ["Mega|Ride"] = 459.38}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 3.87, ["Fly"] = 6562.5, ["Ride"] = 56.44, ["Neon"] = 45.47}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 3.56, ["Ride"] = 30.18, ["Fly|Ride"] = 178.76, ["Neon"] = 25.99, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 426.59, ["Mega"] = 284.75, ["Mega|Ride"] = 412.72, ["Mega|Fly|Ride"] = 375.26}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 13.12, ["Ride"] = 10.56, ["Fly|Ride"] = 25.61, ["Neon"] = 2.1, ["Neon|Fly"] = 15.63, ["Neon|Ride"] = 11.97, ["Neon|Fly|Ride"] = 27.19, ["Mega"] = 14.3, ["Mega|Fly"] = 23, ["Mega|Ride"] = 20.98, ["Mega|Fly|Ride"] = 47.25}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 60.38, ["Fly|Ride"] = 162.16, ["Neon"] = 6.33, ["Neon|Fly"] = 67.79, ["Neon|Ride"] = 33.07, ["Neon|Fly|Ride"] = 711.33, ["Mega"] = 72.19, ["Mega|Ride"] = 117.93}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.4, ["Neon"] = 2.1, ["Neon|Fly"] = 32.01, ["Neon|Ride"] = 23.06, ["Neon|Fly|Ride"] = 84.16, ["Mega"] = 14.44, ["Mega|Fly"] = 89.25, ["Mega|Fly|Ride"] = 134.38}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.71, ["Neon|Fly"] = 60.89, ["Neon|Ride"] = 127.32, ["Mega"] = 20.28, ["Mega|Fly|Ride"] = 170.64}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 41.99, ["Ride"] = 17.8, ["Fly|Ride"] = 52.04, ["Neon"] = 11.44, ["Neon|Ride"] = 32.38, ["Neon|Fly|Ride"] = 66.26, ["Mega"] = 183.75, ["Mega|Ride"] = 199.44, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 153.2, ["Fly"] = 183.75, ["Ride"] = 211.21, ["Fly|Ride"] = 262.5, ["Neon"] = 932.14, ["Neon|Fly|Ride"] = 964.06, ["Mega"] = 8531.44, ["Mega|Ride"] = 3270.75, ["Mega|Fly|Ride"] = 3839.16}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 24.22, ["Neon"] = 8.05, ["Neon|Ride"] = 64.31, ["Mega"] = 91.88, ["Mega|Ride"] = 172.78, ["Mega|Fly|Ride"] = 634.54}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.63, ["Fly"] = 64.97, ["Ride"] = 26.24, ["Fly|Ride"] = 60.14, ["Neon"] = 31.29, ["Neon|Ride"] = 96.76, ["Neon|Fly|Ride"] = 142.92, ["Mega"] = 381.82, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 426.59}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 15.54, ["Ride"] = 14.95, ["Fly|Ride"] = 32.79, ["Neon"] = 4.78, ["Neon|Fly"] = 28.81, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 42.78, ["Mega"] = 49.68, ["Mega|Ride"] = 81.38, ["Mega|Fly|Ride"] = 109.86}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 71.47, ["Ride"] = 18.13, ["Fly|Ride"] = 92.58, ["Neon"] = 6.97, ["Neon|Fly"] = 569.52, ["Neon|Ride"] = 43.22, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 70.35, ["Mega|Ride"] = 193.52}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.7, ["Fly"] = 24.48, ["Ride"] = 15.16, ["Fly|Ride"] = 45.87, ["Neon"] = 23.63, ["Neon|Fly"] = 100.27, ["Neon|Ride"] = 43.31, ["Neon|Fly|Ride"] = 77.95, ["Mega|Ride"] = 280.49, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.94, ["Ride"] = 42.67, ["Fly|Ride"] = 258.12, ["Neon"] = 44.26, ["Neon|Ride"] = 71.02, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 424.46, ["Mega|Ride"] = 268.97, ["Mega|Fly|Ride"] = 1066.45}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.63, ["Fly"] = 16.94, ["Ride"] = 15.54, ["Fly|Ride"] = 33.01, ["Neon"] = 23.31, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 28.82, ["Neon|Fly|Ride"] = 70.6, ["Mega"] = 131.25, ["Mega|Ride"] = 306.09, ["Mega|Fly|Ride"] = 223.12}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 70.88, ["Ride"] = 89.25, ["Fly|Ride"] = 142.94, ["Neon"] = 328.13, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 349.13, ["Neon|Fly|Ride"] = 422.33, ["Mega|Fly|Ride"] = 1291.14}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 209.98, ["Fly"] = 426.62, ["Ride"] = 241.74, ["Fly|Ride"] = 260.06, ["Neon|Ride"] = 2666.08, ["Neon|Fly|Ride"] = 925.1, ["Mega"] = 10664.3, ["Mega|Fly|Ride"] = 4931.18}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 56.18, ["Fly"] = 123.73, ["Ride"] = 73.8, ["Fly|Ride"] = 114.29, ["Neon"] = 262.5, ["Neon|Ride"] = 290.34, ["Neon|Fly|Ride"] = 354.26, ["Mega|Fly|Ride"] = 2465.74}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 7.88, ["Fly"] = 287.89, ["Ride"] = 32.82, ["Fly|Ride"] = 81.09, ["Neon"] = 32.8, ["Neon|Fly"] = 85.33, ["Neon|Ride"] = 122.13, ["Neon|Fly|Ride"] = 181.12, ["Mega"] = 262.49, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 416.72}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 10.06, ["Fly"] = 71.47, ["Ride"] = 18.38, ["Fly|Ride"] = 64.7, ["Neon"] = 92.8, ["Neon|Ride"] = 126.27, ["Neon|Fly|Ride"] = 199.44, ["Mega"] = 353.07, ["Mega|Ride"] = 397.68, ["Mega|Fly|Ride"] = 711.33}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 30.84, ["Ride"] = 17.91, ["Fly|Ride"] = 44.51, ["Neon"] = 4.19, ["Neon|Fly"] = 32.01, ["Neon|Ride"] = 20.58, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 50.13, ["Mega|Fly"] = 154.88, ["Mega|Ride"] = 111.46, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.01, ["Fly"] = 72.12, ["Ride"] = 22.09, ["Fly|Ride"] = 81.38, ["Neon"] = 152.15, ["Neon|Fly"] = 356.22, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 184.52, ["Mega"] = 1837.5, ["Mega|Ride"] = 549.11, ["Mega|Fly|Ride"] = 732.38}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.89, ["Ride"] = 15.21, ["Fly|Ride"] = 32.82, ["Neon"] = 13.12, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 31.45, ["Neon|Fly|Ride"] = 104.69, ["Mega"] = 131.25, ["Mega|Ride"] = 280.19, ["Mega|Fly|Ride"] = 178.37}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 3.56, ["Ride"] = 27.56, ["Fly|Ride"] = 328.13, ["Neon"] = 22.29, ["Neon|Ride"] = 35.76, ["Mega"] = 207.37, ["Mega|Ride"] = 284.75, ["Mega|Fly|Ride"] = 310.55}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 34.15, ["Ride"] = 19.35, ["Neon"] = 2.1, ["Neon|Ride"] = 19.66, ["Neon|Fly|Ride"] = 57.73, ["Mega"] = 14.6, ["Mega|Ride"] = 42.67, ["Mega|Fly|Ride"] = 78.73}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.39, ["Ride"] = 18.16, ["Fly|Ride"] = 42.67, ["Neon"] = 15.22, ["Neon|Fly"] = 106.66, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 108.94, ["Mega|Fly|Ride"] = 159.92}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 3.94, ["Fly"] = 25.45, ["Ride"] = 18.52, ["Fly|Ride"] = 61.73, ["Neon"] = 21.42, ["Neon|Ride"] = 47.25, ["Mega"] = 131.17, ["Mega|Ride"] = 206.91, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 122.07, ["Fly"] = 167.03, ["Ride"] = 140.83, ["Fly|Ride"] = 210.67, ["Neon"] = 484, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 590.63, ["Mega"] = 4265.73, ["Mega|Ride"] = 2772.73, ["Mega|Fly|Ride"] = 2035.69}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 8.1, ["Ride"] = 32.83, ["Fly|Ride"] = 129.48, ["Neon"] = 49.07, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 284.75, ["Mega"] = 262.5, ["Mega|Ride"] = 413.45, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 41.91, ["Ride"] = 15.75, ["Fly|Ride"] = 41.61, ["Neon"] = 19.69, ["Neon|Ride"] = 28.81, ["Neon|Fly|Ride"] = 120.74, ["Mega"] = 235.86, ["Mega|Ride"] = 267.3, ["Mega|Fly|Ride"] = 284.75}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 19.69, ["Ride"] = 45.87, ["Fly|Ride"] = 170.63, ["Neon"] = 118.01, ["Neon|Ride"] = 192.21, ["Neon|Fly|Ride"] = 680.05, ["Mega"] = 667.45, ["Mega|Fly"] = 853.16, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 629.22}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 8.84}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.52, ["Ride"] = 28.61, ["Fly|Ride"] = 119.8, ["Neon"] = 28.81, ["Neon|Ride"] = 104.53, ["Neon|Fly|Ride"] = 356.2, ["Mega"] = 285.91, ["Mega|Ride"] = 583.35, ["Mega|Fly|Ride"] = 887.76}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 26.13, ["Fly"] = 37.7, ["Ride"] = 31.39, ["Fly|Ride"] = 41.85, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 162.64, ["Neon|Fly|Ride"] = 182.97, ["Mega"] = 1376.78, ["Mega|Fly|Ride"] = 541.75}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 18.68, ["Fly|Ride"] = 65.63, ["Neon"] = 4.26, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 106.31, ["Mega"] = 28.74, ["Mega|Fly"] = 188.99, ["Mega|Ride"] = 57.66, ["Mega|Fly|Ride"] = 228.79}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 3.65, ["Fly"] = 28.41, ["Ride"] = 24.54, ["Fly|Ride"] = 64, ["Neon"] = 55.01, ["Neon|Ride"] = 64, ["Mega"] = 281.48, ["Mega|Fly"] = 403.98, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 396.73}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 16.01, ["Fly|Ride"] = 47.58, ["Neon"] = 17.61, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 35.42, ["Neon|Fly|Ride"] = 77.43, ["Mega"] = 138.89, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 26.16, ["Fly|Ride"] = 213.31, ["Neon"] = 3.38, ["Neon|Fly"] = 37.34, ["Neon|Ride"] = 32, ["Neon|Fly|Ride"] = 213.3, ["Mega"] = 31.4, ["Mega|Ride"] = 55.04, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 23.82, ["Ride"] = 74.82, ["Fly|Ride"] = 145.21, ["Neon"] = 262.5, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 576.19, ["Mega"] = 850.61, ["Mega|Ride"] = 945.91, ["Mega|Fly|Ride"] = 1136.84}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.89, ["Ride"] = 28.81, ["Fly|Ride"] = 210, ["Neon"] = 92.65, ["Mega|Ride"] = 342.67}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 12.03, ["Fly"] = 29.54, ["Ride"] = 21.94, ["Fly|Ride"] = 61.15, ["Neon"] = 21, ["Neon|Fly"] = 84, ["Neon|Ride"] = 47.66, ["Neon|Fly|Ride"] = 138.66, ["Mega"] = 372.44, ["Mega|Ride"] = 309.64, ["Mega|Fly|Ride"] = 421.32}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 64.74, ["Fly"] = 433.13, ["Ride"] = 393.73, ["Fly|Ride"] = 262.47, ["Neon"] = 354.38, ["Neon|Ride"] = 554.55, ["Mega"] = 4517.36, ["Mega|Ride"] = 2165.63, ["Mega|Fly|Ride"] = 1836.19}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 7.64, ["Fly"] = 45.94, ["Ride"] = 26.93, ["Fly|Ride"] = 57.65, ["Neon"] = 57.61, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 53.33, ["Neon|Fly|Ride"] = 114.18, ["Mega"] = 224.44, ["Mega|Ride"] = 425.52, ["Mega|Fly|Ride"] = 711.33}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 69.56, ["Fly"] = 170.65, ["Ride"] = 87.94, ["Fly|Ride"] = 150.94, ["Neon"] = 266.44, ["Neon|Ride"] = 232.49, ["Mega"] = 1137.9, ["Mega|Ride"] = 901.78, ["Mega|Fly|Ride"] = 1085.17}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 14.81, ["Fly"] = 157.85, ["Ride"] = 43.64, ["Fly|Ride"] = 106.66, ["Neon"] = 79.45, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 237.83, ["Mega"] = 354.38, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 413.44}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 8.3, ["Fly"] = 41.36, ["Ride"] = 28.81, ["Fly|Ride"] = 64, ["Neon"] = 83.96, ["Neon|Ride"] = 144.16, ["Neon|Fly|Ride"] = 384.62, ["Mega"] = 213.3, ["Mega|Ride"] = 1599.66, ["Mega|Fly|Ride"] = 532.17}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 14.44, ["Ride"] = 45.66, ["Fly|Ride"] = 162.16, ["Neon"] = 59.94, ["Neon|Ride"] = 99.03, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 356.2, ["Mega|Ride"] = 280.87, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 5.25, ["Ride"] = 24.93, ["Fly|Ride"] = 89.6, ["Neon"] = 38.07, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 141.16, ["Mega"] = 238.9, ["Mega|Ride"] = 265.21, ["Mega|Fly|Ride"] = 417.38}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Fly|Ride"] = 96.01, ["Neon"] = 2.1, ["Neon|Ride"] = 57.62, ["Mega"] = 19.15, ["Mega|Ride"] = 135.45, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.51, ["Ride"] = 28.44, ["Neon"] = 24.03, ["Neon|Fly"] = 127.99, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 157.5, ["Mega|Ride"] = 270.88, ["Mega|Fly|Ride"] = 424.46}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 126.93, ["Neon"] = 28.65, ["Neon|Fly"] = 116.94, ["Mega"] = 174.03, ["Mega|Ride"] = 140.78, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 6.04, ["Ride"] = 32.79, ["Fly|Ride"] = 121.02, ["Neon"] = 30.95, ["Neon|Ride"] = 82.95, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 123.38, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 489.13, ["Ride"] = 570.94, ["Fly|Ride"] = 640.4, ["Neon"] = 1849.33, ["Neon|Ride"] = 1763.89, ["Neon|Fly|Ride"] = 1778.81, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 4.36, ["Fly"] = 28.81, ["Ride"] = 20.43, ["Fly|Ride"] = 56.35, ["Neon"] = 41.61, ["Neon|Ride"] = 62.91, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 137.82, ["Mega|Ride"] = 366.62, ["Mega|Fly|Ride"] = 511.9}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 5.57, ["Fly"] = 524.79, ["Ride"] = 31.13, ["Fly|Ride"] = 51.54, ["Neon"] = 39.36, ["Neon|Fly"] = 315, ["Neon|Ride"] = 98.34, ["Neon|Fly|Ride"] = 162.08, ["Mega"] = 331.86, ["Mega|Ride"] = 462.84, ["Mega|Fly|Ride"] = 681.35}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.1, ["Fly"] = 91.87, ["Ride"] = 27.2, ["Fly|Ride"] = 52.5, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 131.25}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.59, ["Ride"] = 22.77, ["Fly|Ride"] = 52.5, ["Neon"] = 5.93, ["Neon|Ride"] = 30.03, ["Neon|Fly|Ride"] = 88.69, ["Mega"] = 61.32, ["Mega|Fly"] = 213.3, ["Mega|Ride"] = 87.65, ["Mega|Fly|Ride"] = 203.72}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 71.47, ["Ride"] = 16.95, ["Neon"] = 2.1, ["Neon|Ride"] = 24.34, ["Neon|Fly|Ride"] = 126.92, ["Mega"] = 18.38, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 221.55}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1108.96}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 4.45, ["Ride"] = 36.74, ["Fly|Ride"] = 332.76, ["Neon"] = 52.39, ["Neon|Ride"] = 91.75, ["Neon|Fly|Ride"] = 322.94, ["Mega"] = 424.46, ["Mega|Ride"] = 580.55, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 26.65, ["Neon"] = 5.92, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 982.1, ["Mega"] = 39.38, ["Mega|Ride"] = 104.53, ["Mega|Fly|Ride"] = 251.34}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 4.76, ["Fly"] = 27.17, ["Ride"] = 63.95, ["Neon"] = 27.57, ["Neon|Ride"] = 71.47, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 196.87, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 1066.45}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 420, ["Ride"] = 489.57, ["Fly|Ride"] = 498.75, ["Neon|Ride"] = 2313.96, ["Neon|Fly|Ride"] = 2133.51, ["Mega"] = 8870.21, ["Mega|Fly|Ride"] = 6298.69}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 4.45, ["Fly"] = 196.88, ["Ride"] = 57.61, ["Fly|Ride"] = 426.62, ["Neon"] = 36.4, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 193.52, ["Mega"] = 532.17, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 742.62}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Ride"] = 23.57, ["Fly|Ride"] = 118.13, ["Neon"] = 2.1, ["Neon|Ride"] = 36.66, ["Neon|Fly|Ride"] = 115.19, ["Mega"] = 37.86, ["Mega|Fly"] = 127.99, ["Mega|Ride"] = 71.4, ["Mega|Fly|Ride"] = 173.97}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 2.52, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 284.75, ["Mega"] = 30.93, ["Mega|Ride"] = 136.15, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 15.75, ["Fly"] = 107.63, ["Ride"] = 111.46, ["Fly|Ride"] = 157.45, ["Neon"] = 149.63, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 622.91, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 544.69}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 8.31, ["Ride"] = 71.31, ["Neon"] = 80.22, ["Neon|Ride"] = 162.08, ["Neon|Fly|Ride"] = 545.49, ["Mega"] = 590.82, ["Mega|Ride"] = 479.73, ["Mega|Fly|Ride"] = 597.21}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 7.61, ["Ride"] = 31.4, ["Neon"] = 96.94, ["Neon|Ride"] = 180.9, ["Mega"] = 661.59, ["Mega|Ride"] = 782.77, ["Mega|Fly|Ride"] = 1279.73}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 12.46, ["Ride"] = 23.39, ["Fly|Ride"] = 262.5, ["Neon"] = 131.24, ["Neon|Ride"] = 182.44, ["Neon|Fly|Ride"] = 213.3, ["Mega"] = 616.77, ["Mega|Ride"] = 1300.04, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 354.38, ["Ride"] = 324.84, ["Fly|Ride"] = 779.22, ["Neon"] = 1151.9, ["Neon|Ride"] = 1422.64, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4087.99}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 5.2, ["Fly"] = 78.74, ["Ride"] = 26.25, ["Fly|Ride"] = 64.3, ["Neon"] = 178.12, ["Neon|Ride"] = 192.31, ["Neon|Fly|Ride"] = 197.8, ["Mega"] = 767.85, ["Mega|Fly|Ride"] = 877.68}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.66, ["Ride"] = 42.68, ["Fly|Ride"] = 127.32, ["Neon"] = 64.32, ["Neon|Ride"] = 221.82, ["Mega"] = 367.5, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1066.45}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 16.4, ["Fly"] = 142.93, ["Ride"] = 71.47, ["Fly|Ride"] = 193.6, ["Neon"] = 81.25, ["Neon|Ride"] = 157.22, ["Neon|Fly|Ride"] = 260.78, ["Mega"] = 288.75, ["Mega|Fly"] = 711.33, ["Mega|Ride"] = 325.5, ["Mega|Fly|Ride"] = 393.49}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.49, ["Ride"] = 42.67, ["Fly|Ride"] = 142.93, ["Neon"] = 6.48, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 213.3, ["Mega"] = 46.43, ["Mega|Ride"] = 127.99, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 48.75, ["Ride"] = 79.86, ["Neon"] = 383.96, ["Neon|Ride"] = 425.52, ["Neon|Fly|Ride"] = 470.31, ["Mega"] = 1693.27, ["Mega|Ride"] = 2132.88, ["Mega|Fly|Ride"] = 1200.64}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 521, ["Ride"] = 25.73, ["Fly|Ride"] = 60.81, ["Neon"] = 6.57, ["Neon|Fly"] = 185.59, ["Neon|Ride"] = 78.93, ["Neon|Fly|Ride"] = 131.61, ["Mega"] = 96.76, ["Mega|Ride"] = 101.51, ["Mega|Fly|Ride"] = 216.92}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 27.84, ["Neon"] = 3.71, ["Neon|Fly"] = 49.38, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 114.12, ["Mega"] = 41.61, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 76, ["Mega|Fly|Ride"] = 170.36}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 37.97, ["Fly|Ride"] = 127.52, ["Neon"] = 9.91, ["Neon|Ride"] = 61.87, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 92.67, ["Mega|Fly"] = 459.38, ["Mega|Ride"] = 125.14, ["Mega|Fly|Ride"] = 314.62}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 44.63, ["Fly"] = 96.81, ["Ride"] = 60.37, ["Fly|Ride"] = 169.32, ["Neon"] = 271.01, ["Neon|Ride"] = 310.92, ["Neon|Fly|Ride"] = 478.06, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 256.5, ["Ride"] = 262.5, ["Fly|Ride"] = 425.55, ["Neon"] = 1462.13, ["Neon|Ride"] = 1177.51, ["Neon|Fly|Ride"] = 1329.83, ["Mega"] = 9675.7, ["Mega|Fly|Ride"] = 5261.83}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 4.66, ["Neon"] = 30.09, ["Neon|Fly"] = 350.44, ["Neon|Fly|Ride"] = 159.98, ["Mega"] = 104.9, ["Mega|Fly"] = 223.97, ["Mega|Ride"] = 319.95, ["Mega|Fly|Ride"] = 403.98}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 25.6, ["Neon"] = 6.33, ["Neon|Ride"] = 35.06, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 52.5, ["Mega|Fly"] = 164.07, ["Mega|Ride"] = 90.37, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.4, ["Fly"] = 31.47, ["Ride"] = 27.57, ["Fly|Ride"] = 81.09, ["Neon"] = 32.81, ["Mega"] = 140.53, ["Mega|Ride"] = 351.74, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.61, ["Fly"] = 90.04, ["Ride"] = 29.54, ["Fly|Ride"] = 81.09, ["Neon"] = 11.46, ["Neon|Ride"] = 46.35, ["Neon|Fly|Ride"] = 157.84, ["Mega"] = 124.41, ["Mega|Ride"] = 166.53, ["Mega|Fly|Ride"] = 241.9}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 59.06, ["Neon"] = 8.54, ["Neon|Fly|Ride"] = 142.92, ["Mega"] = 36.75, ["Mega|Fly|Ride"] = 284.75}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 28.81, ["Ride"] = 17.91, ["Fly|Ride"] = 52.49, ["Neon"] = 3.84, ["Neon|Fly"] = 81.04, ["Neon|Ride"] = 21.78, ["Neon|Fly|Ride"] = 58.07, ["Mega"] = 39.79, ["Mega|Ride"] = 95.72, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.63, ["Fly"] = 26.25, ["Ride"] = 21.35, ["Fly|Ride"] = 41.31, ["Neon"] = 15.16, ["Neon|Fly"] = 64.97, ["Neon|Ride"] = 38.66, ["Neon|Fly|Ride"] = 96.76, ["Mega"] = 105, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 169.58}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 23.63, ["Fly"] = 52.5, ["Ride"] = 32.48, ["Fly|Ride"] = 78.66, ["Neon"] = 136.4, ["Neon|Ride"] = 613.22, ["Neon|Fly|Ride"] = 322.94, ["Mega"] = 393.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 527.68}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 91.88, ["Ride"] = 84, ["Fly|Ride"] = 137.73, ["Neon"] = 410.81, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 3225.66, ["Mega|Ride"] = 3254.99, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 17.88, ["Fly|Ride"] = 144.38, ["Neon"] = 3.3, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 26.2, ["Neon|Fly|Ride"] = 128.47, ["Mega"] = 45.85, ["Mega|Fly"] = 672, ["Mega|Ride"] = 92.8, ["Mega|Fly|Ride"] = 246.75}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 14.34, ["Ride"] = 14.86, ["Fly|Ride"] = 36.27, ["Neon"] = 3.86, ["Neon|Fly"] = 28.41, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 61.68, ["Mega"] = 40.63, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 66.94, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 6.11, ["Ride"] = 73.5, ["Fly|Ride"] = 131.25, ["Neon"] = 48.57, ["Neon|Ride"] = 124.68, ["Neon|Fly|Ride"] = 284.75, ["Mega"] = 527.62, ["Mega|Ride"] = 274.32, ["Mega|Fly|Ride"] = 645.87}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.74, ["Fly"] = 518.44, ["Ride"] = 472.5, ["Fly|Ride"] = 577.5, ["Neon|Ride"] = 1935.14, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 8063.49}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 18.38, ["Fly"] = 100.27, ["Ride"] = 40.1, ["Fly|Ride"] = 107.49, ["Neon"] = 210.55, ["Neon|Ride"] = 225.73, ["Neon|Fly|Ride"] = 474.12, ["Mega|Ride"] = 880.69, ["Mega|Fly|Ride"] = 1129.65}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 25.83, ["Fly|Ride"] = 281.33, ["Neon"] = 8.76, ["Neon|Ride"] = 45.39, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 97.13, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 271.98}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 65.61, ["Fly|Ride"] = 143.05, ["Neon"] = 17.09}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 40.69, ["Fly"] = 169.3, ["Ride"] = 54.47, ["Fly|Ride"] = 104.81, ["Neon"] = 194.25, ["Neon|Ride"] = 142.92, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 2559.45, ["Mega|Ride"] = 1155, ["Mega|Fly|Ride"] = 1279.73}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 77.96, ["Fly"] = 91.77, ["Ride"] = 112.28, ["Fly|Ride"] = 191.99, ["Neon"] = 430.1, ["Neon|Ride"] = 483.79, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 8531.44, ["Mega|Fly|Ride"] = 2329.09}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 199.37, ["Ride"] = 249.61, ["Fly|Ride"] = 532.21, ["Neon"] = 1050, ["Neon|Ride"] = 800.63, ["Neon|Fly|Ride"] = 934.59, ["Mega|Fly|Ride"] = 4147.5}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 7.45, ["Ride"] = 61.59, ["Fly|Ride"] = 96.17, ["Neon"] = 85.2, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 356.2, ["Mega"] = 389.79, ["Mega|Ride"] = 404.79, ["Mega|Fly|Ride"] = 1049.41}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 19.47, ["Ride"] = 15.54, ["Fly|Ride"] = 42.67, ["Neon"] = 9.7, ["Neon|Ride"] = 23.15, ["Neon|Fly|Ride"] = 92.79, ["Mega"] = 84.28, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 170.42}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 3.97, ["Fly"] = 39.3, ["Ride"] = 15.75, ["Fly|Ride"] = 42.67, ["Neon"] = 31.08, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 36.52, ["Neon|Fly|Ride"] = 76.98, ["Mega"] = 349.81, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 366.19}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 317.97, ["Fly"] = 498.07, ["Ride"] = 432.5, ["Fly|Ride"] = 425.55, ["Neon"] = 1575, ["Neon|Ride"] = 2029.3, ["Mega"] = 10237.74, ["Mega|Fly|Ride"] = 6505.24}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 34.13, ["Mega|Ride"] = 170.99, ["Mega|Fly|Ride"] = 450.13}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.41, ["Ride"] = 15.74, ["Fly|Ride"] = 57.61, ["Neon"] = 32.82, ["Neon|Ride"] = 37.16, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 235.7, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 196.32, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 11.82, ["Ride"] = 83.99, ["Neon"] = 81.46, ["Neon|Fly"] = 426.59, ["Neon|Ride"] = 236.25, ["Mega"] = 548.63, ["Mega|Ride"] = 609, ["Mega|Fly|Ride"] = 600.18}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 95.24, ["Fly"] = 157.5, ["Ride"] = 96.81, ["Fly|Ride"] = 127.03, ["Neon|Ride"] = 524.99, ["Neon|Fly|Ride"] = 568.32, ["Mega|Fly|Ride"] = 2379.57}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 15.75, ["Fly"] = 24.57, ["Ride"] = 23.5, ["Fly|Ride"] = 48.88, ["Neon"] = 130.5, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 711.33, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 518.44}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 21.35, ["Neon"] = 2.5, ["Neon|Ride"] = 39.38, ["Mega"] = 24.94, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 19.21, ["Fly|Ride"] = 71.47, ["Neon"] = 3.03, ["Neon|Ride"] = 22.35, ["Neon|Fly|Ride"] = 79.38, ["Mega"] = 23.3, ["Mega|Fly"] = 87.64, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 109.98}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 9.55, ["Ride"] = 72.19, ["Fly|Ride"] = 149.6, ["Neon"] = 30.66, ["Neon|Ride"] = 86.4, ["Neon|Fly|Ride"] = 203.43, ["Mega"] = 170.63, ["Mega|Ride"] = 204.75, ["Mega|Fly|Ride"] = 284.75}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1168.12, ["Ride"] = 1443.74, ["Fly|Ride"] = 1435.87, ["Neon"] = 4200, ["Neon|Ride"] = 4372.38, ["Neon|Fly|Ride"] = 4265.73, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 446.25, ["Ride"] = 479.07, ["Fly|Ride"] = 796.69, ["Neon"] = 2504.17, ["Neon|Ride"] = 1706.31, ["Neon|Fly|Ride"] = 2275.77, ["Mega"] = 17062.88, ["Mega|Fly|Ride"] = 7181.35}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 292.26, ["Fly"] = 397.86, ["Ride"] = 290.32, ["Fly|Ride"] = 406.88, ["Neon"] = 787.29, ["Neon|Fly"] = 853.21, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 853.02, ["Mega|Fly|Ride"] = 2916.24}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 269.07, ["Fly"] = 334.68, ["Ride"] = 318.43, ["Fly|Ride"] = 412.67, ["Neon"] = 777, ["Neon|Ride"] = 761.24, ["Neon|Fly|Ride"] = 996.07, ["Mega|Fly|Ride"] = 4264.67}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 64.31, ["Ride"] = 15.91, ["Fly|Ride"] = 38.07, ["Neon"] = 3.94, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 104.9, ["Mega"] = 69.43, ["Mega|Fly"] = 114.12, ["Mega|Ride"] = 82.68, ["Mega|Fly|Ride"] = 141.49}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 315.94, ["Fly"] = 1422.73, ["Ride"] = 420, ["Fly|Ride"] = 498.75, ["Neon"] = 1706.25, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 2418.93, ["Mega"] = 21613.33, ["Mega|Ride"] = 5118.88, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.4, ["Fly"] = 157.5, ["Ride"] = 112.53, ["Fly|Ride"] = 91.87, ["Neon"] = 21, ["Neon|Ride"] = 213.3, ["Neon|Fly|Ride"] = 252, ["Mega"] = 137.81, ["Mega|Ride"] = 235.5, ["Mega|Fly|Ride"] = 352.99}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 18.12, ["Ride"] = 14.97, ["Fly|Ride"] = 34.15, ["Neon"] = 12.12, ["Neon|Ride"] = 33.07, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 104.81, ["Mega|Ride"] = 192.93, ["Mega|Fly|Ride"] = 153.58}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 56.6, ["Neon"] = 3.7, ["Neon|Ride"] = 39.38, ["Mega"] = 29.63, ["Mega|Ride"] = 196.77}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 80.07, ["Fly|Ride"] = 459.38, ["Neon"] = 244.28, ["Neon|Ride"] = 420, ["Mega"] = 1050, ["Mega|Ride"] = 488.25, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.63, ["Fly"] = 57.61, ["Ride"] = 26.25, ["Fly|Ride"] = 68.25, ["Neon"] = 73.5, ["Neon|Ride"] = 61.13, ["Mega|Ride"] = 412.72, ["Mega|Fly|Ride"] = 426.59}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Fly|Ride"] = 142.93, ["Neon"] = 3.39, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 101.88, ["Mega"] = 26.17, ["Mega|Ride"] = 68.01, ["Mega|Fly|Ride"] = 164.25}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 3.71, ["Fly"] = 36.27, ["Ride"] = 19.65, ["Fly|Ride"] = 78.65, ["Neon"] = 13.13, ["Neon|Fly"] = 113.9, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 77.05, ["Mega"] = 129.94, ["Mega|Fly"] = 483.79, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 4.23, ["Fly"] = 91.77, ["Ride"] = 22.32, ["Fly|Ride"] = 52.5, ["Neon"] = 35.77, ["Neon|Fly"] = 145.21, ["Neon|Ride"] = 142.92, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 238.82, ["Mega|Ride"] = 251.07, ["Mega|Fly|Ride"] = 1321.69}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 11.95, ["Ride"] = 62.94, ["Neon"] = 78.93, ["Neon|Ride"] = 381.8, ["Neon|Fly|Ride"] = 274.56, ["Mega"] = 518.19, ["Mega|Ride"] = 798.77}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 3.62, ["Fly"] = 6453.89, ["Ride"] = 19.69, ["Neon"] = 39.38, ["Neon|Fly"] = 47.25, ["Neon|Ride"] = 212.24, ["Neon|Fly|Ride"] = 725.69, ["Mega"] = 308.44, ["Mega|Ride"] = 498.04, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 64.37, ["Ride"] = 18.38, ["Fly|Ride"] = 38.4, ["Neon"] = 3.84, ["Neon|Fly"] = 32.01, ["Neon|Ride"] = 27.72, ["Neon|Fly|Ride"] = 85.33, ["Mega"] = 40.83, ["Mega|Ride"] = 182.64, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 157.5, ["Fly"] = 260.24, ["Ride"] = 164.07, ["Fly|Ride"] = 229.69, ["Neon|Ride"] = 921.4, ["Neon|Fly|Ride"] = 838.68, ["Mega"] = 8531.44, ["Mega|Fly|Ride"] = 3519.24}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 19.03, ["Ride"] = 14.94, ["Fly|Ride"] = 41.79, ["Neon"] = 2.66, ["Neon|Fly"] = 24.54, ["Neon|Ride"] = 24.75, ["Neon|Fly|Ride"] = 56.35, ["Mega"] = 44.63, ["Mega|Ride"] = 52.76, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 7.05, ["Ride"] = 42.37, ["Fly|Ride"] = 183.75, ["Neon"] = 71.31, ["Neon|Ride"] = 128.55, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 313.69, ["Mega|Fly"] = 806.73, ["Mega|Fly|Ride"] = 379.32}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 22.32, ["Ride"] = 106.66, ["Fly|Ride"] = 170.63, ["Neon"] = 137.81, ["Neon|Ride"] = 272.94, ["Mega"] = 996.07, ["Mega|Ride"] = 499.38, ["Mega|Fly|Ride"] = 967.26}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 177.91, ["Ride"] = 214.13, ["Fly|Ride"] = 569.52, ["Neon"] = 761.25, ["Neon|Ride"] = 682.5, ["Neon|Fly|Ride"] = 1137.9, ["Mega|Fly|Ride"] = 3398.73}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 21.74, ["Ride"] = 158.3, ["Fly|Ride"] = 142.93, ["Neon"] = 91.88, ["Mega"] = 287.44, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 711.33}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 126, ["Ride"] = 57.75, ["Fly|Ride"] = 185.59, ["Neon"] = 105, ["Neon|Fly"] = 162.16, ["Neon|Ride"] = 199, ["Neon|Fly|Ride"] = 226.19, ["Mega"] = 771.89, ["Mega|Ride"] = 853.16, ["Mega|Fly|Ride"] = 996.07}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 958.11, ["Fly"] = 1050, ["Ride"] = 1023.75, ["Fly|Ride"] = 1179.93, ["Neon|Ride"] = 4521.67, ["Neon|Fly|Ride"] = 4785.08, ["Mega|Fly|Ride"] = 20262.16}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 5.55, ["Fly"] = 19.69, ["Ride"] = 19.81, ["Fly|Ride"] = 52.5, ["Neon"] = 19.21, ["Neon|Fly"] = 46.48, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 84.27, ["Mega"] = 229.81, ["Mega|Ride"] = 199.44, ["Mega|Fly|Ride"] = 327.42}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 3.98, ["Fly"] = 78.75, ["Ride"] = 35.32, ["Fly|Ride"] = 135.19, ["Neon"] = 36.18, ["Neon|Ride"] = 108.87, ["Mega"] = 251.69, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 297.53, ["Mega|Fly|Ride"] = 996.07}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 84.27, ["Ride"] = 29.64, ["Fly|Ride"] = 69.45, ["Neon"] = 10.97, ["Neon|Ride"] = 45.4, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 105, ["Mega|Ride"] = 243.06, ["Mega|Fly|Ride"] = 370.08}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 10.4, ["Ride"] = 32.47, ["Fly|Ride"] = 78.75, ["Neon"] = 77.35, ["Neon|Fly"] = 143.83, ["Neon|Ride"] = 78.61, ["Neon|Fly|Ride"] = 196.27, ["Mega"] = 459.64, ["Mega|Ride"] = 347.82, ["Mega|Fly|Ride"] = 438.38}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 3.94, ["Fly"] = 20.47, ["Ride"] = 13.13, ["Fly|Ride"] = 51.19, ["Neon"] = 16.89, ["Neon|Fly"] = 42.73, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 100.41, ["Mega|Fly"] = 255.96, ["Mega|Ride"] = 91.77, ["Mega|Fly|Ride"] = 264.49}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 17.09, ["Neon"] = 10.36, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 48.65, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 148.97, ["Mega|Ride"] = 199.38, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 175.86, ["Ride"] = 269.64, ["Fly|Ride"] = 356.22, ["Neon|Fly|Ride"] = 1182.56, ["Mega|Fly|Ride"] = 3821.04}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 6.41, ["Fly"] = 32.8, ["Ride"] = 21.35, ["Fly|Ride"] = 108.94, ["Neon"] = 4.73, ["Neon|Ride"] = 32.51, ["Neon|Fly|Ride"] = 127.42, ["Mega"] = 100.26, ["Mega|Fly"] = 426.59, ["Mega|Ride"] = 119.61, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 2.63, ["Ride"] = 82.01, ["Fly|Ride"] = 88.86, ["Neon"] = 27.2, ["Neon|Ride"] = 188.27, ["Mega"] = 142.92, ["Mega|Ride"] = 318.94}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.17, ["Fly"] = 98.86, ["Ride"] = 28.73, ["Neon"] = 27.53, ["Neon|Ride"] = 52.5, ["Mega"] = 84.95, ["Mega|Ride"] = 174.57}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 261.19, ["Fly|Ride"] = 308.44, ["Neon|Ride"] = 1593.25, ["Neon|Fly|Ride"] = 1066.45, ["Mega|Ride"] = 4265.73, ["Mega|Fly|Ride"] = 3199.3}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 19.57, ["Fly"] = 121.02, ["Ride"] = 36.27, ["Fly|Ride"] = 228.25, ["Neon"] = 149.5, ["Neon|Ride"] = 284.75, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 569.49, ["Mega|Ride"] = 597.21, ["Mega|Fly|Ride"] = 879.38}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 17.55, ["Fly"] = 142.93, ["Ride"] = 32.38, ["Fly|Ride"] = 94.5, ["Neon"] = 118.12, ["Neon|Ride"] = 133.17, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 426.97, ["Mega|Ride"] = 421.23, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.68, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 210, ["Mega"] = 76.13, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 47.08, ["Fly"] = 67.02, ["Ride"] = 74.92, ["Fly|Ride"] = 150.93, ["Neon"] = 315, ["Neon|Fly"] = 272.44, ["Neon|Ride"] = 307.98, ["Neon|Fly|Ride"] = 275.15, ["Mega|Fly|Ride"] = 1209.34}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.45, ["Fly|Ride"] = 40.72, ["Neon"] = 5, ["Neon|Ride"] = 57.61, ["Neon|Fly|Ride"] = 126.92, ["Mega"] = 58.91}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 23.48, ["Fly"] = 129.48, ["Ride"] = 23.36, ["Fly|Ride"] = 87.13, ["Neon"] = 66.89, ["Neon|Ride"] = 118.11, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 393.75, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 425.52, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 43.32, ["Fly"] = 131.25, ["Ride"] = 93.62, ["Fly|Ride"] = 199.45, ["Neon"] = 244.02, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 315, ["Mega|Ride"] = 1992.11, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 16.99, ["Ride"] = 15.75, ["Fly|Ride"] = 35.44, ["Neon"] = 2.1, ["Neon|Fly"] = 24.54, ["Neon|Ride"] = 17.09, ["Neon|Fly|Ride"] = 38.16, ["Mega"] = 16.59, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 32.78, ["Mega|Fly|Ride"] = 92.67}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.9, ["Ride"] = 52.49, ["Fly|Ride"] = 131.15, ["Neon"] = 17.9, ["Neon|Ride"] = 57.61, ["Neon|Fly|Ride"] = 291.38, ["Mega"] = 131.25, ["Mega|Ride"] = 284.24, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 12.47, ["Ride"] = 43.22, ["Fly|Ride"] = 85.32, ["Neon"] = 111.45, ["Mega"] = 536.71, ["Mega|Ride"] = 450.21, ["Mega|Fly|Ride"] = 675.56}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 22.2, ["Neon"] = 2.62, ["Neon|Ride"] = 28.86, ["Neon|Fly|Ride"] = 139.72, ["Mega"] = 19.21, ["Mega|Ride"] = 85.33, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 12.37, ["Fly"] = 195.33, ["Ride"] = 47.67, ["Fly|Ride"] = 174.92, ["Neon"] = 61.85, ["Neon|Ride"] = 142.92, ["Neon|Fly|Ride"] = 443.63, ["Mega"] = 459.38, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 444.66}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 6.57, ["Fly"] = 42.67, ["Ride"] = 21.56, ["Fly|Ride"] = 98.44, ["Neon"] = 408.98, ["Neon|Ride"] = 112.4, ["Neon|Fly|Ride"] = 129.94, ["Mega|Fly|Ride"] = 645.87}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.35, ["Ride"] = 37.05, ["Neon"] = 23.57, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 65.61, ["Neon|Fly|Ride"] = 130.19, ["Mega"] = 233.63, ["Mega|Ride"] = 248.48, ["Mega|Fly|Ride"] = 469.88}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 6.13, ["Fly"] = 2035.86, ["Ride"] = 72.18, ["Fly|Ride"] = 196.88, ["Neon"] = 45.76, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 6450.08, ["Mega|Ride"] = 284.75, ["Mega|Fly|Ride"] = 996.07}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.63, ["Fly"] = 42.67, ["Ride"] = 19.48, ["Fly|Ride"] = 196.88, ["Neon"] = 7.07, ["Neon|Ride"] = 32.43, ["Mega"] = 69.56, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 149.31, ["Mega|Fly|Ride"] = 281.55}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 55.53, ["Neon"] = 2.1, ["Mega"] = 21, ["Mega|Ride"] = 126.06, ["Mega|Fly|Ride"] = 229.23}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 14.44}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 37.7, ["Fly"] = 100.27, ["Ride"] = 52.49, ["Neon"] = 243.17, ["Neon|Ride"] = 285.84, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 1849.2, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 888.57}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.51, ["Neon|Ride"] = 28.81, ["Mega"] = 18, ["Mega|Ride"] = 119.7, ["Mega|Fly|Ride"] = 305.82}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 458.07, ["Fly"] = 498.75, ["Ride"] = 484.2, ["Fly|Ride"] = 641.82, ["Neon"] = 2128.76, ["Neon|Ride"] = 1992.11, ["Neon|Fly|Ride"] = 2374.96, ["Mega"] = 17062.88, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 6.22, ["Fly"] = 26.25, ["Ride"] = 25.73, ["Fly|Ride"] = 66.26, ["Neon"] = 34.65, ["Neon|Fly"] = 183.75, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 92.26, ["Mega|Ride"] = 144.37, ["Mega|Fly|Ride"] = 284.75}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.23, ["Fly"] = 52.49, ["Ride"] = 22.19, ["Fly|Ride"] = 80.46, ["Neon"] = 19.25, ["Neon|Ride"] = 41.13, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 142.92, ["Mega|Fly"] = 213.3, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 13.34, ["Fly"] = 71.47, ["Ride"] = 51.2, ["Fly|Ride"] = 69.57, ["Neon"] = 102.8, ["Neon|Ride"] = 173.84, ["Mega"] = 853.16, ["Mega|Ride"] = 561.75, ["Mega|Fly|Ride"] = 570.51}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.26, ["Fly"] = 57.61, ["Ride"] = 28.42, ["Fly|Ride"] = 721.88, ["Neon"] = 17.22, ["Neon|Ride"] = 105, ["Mega"] = 275.63, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 4.26, ["Ride"] = 142.93, ["Fly|Ride"] = 157.49, ["Neon"] = 64.6, ["Neon|Ride"] = 105, ["Mega|Ride"] = 570.05, ["Mega|Fly|Ride"] = 599.68}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 5.44, ["Ride"] = 53.53, ["Fly|Ride"] = 133.88, ["Neon"] = 33, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 212.24, ["Mega"] = 262.5, ["Mega|Fly"] = 569.49, ["Mega|Ride"] = 257.28, ["Mega|Fly|Ride"] = 447.92}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 41.15, ["Ride"] = 13.55, ["Fly|Ride"] = 70.75, ["Neon"] = 2.1, ["Neon|Fly"] = 42.67, ["Neon|Ride"] = 15.49, ["Neon|Fly|Ride"] = 76.56, ["Mega"] = 14.85, ["Mega|Fly"] = 32.67, ["Mega|Ride"] = 28.18, ["Mega|Fly|Ride"] = 142.92}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 5.25, ["Fly"] = 54.41, ["Ride"] = 32.68, ["Fly|Ride"] = 106.32, ["Neon"] = 28.25, ["Neon|Fly"] = 120.96, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 228.22, ["Mega"] = 196.87, ["Mega|Ride"] = 208.69, ["Mega|Fly|Ride"] = 426.59}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 312.17, ["Ride"] = 308.42, ["Fly|Ride"] = 420, ["Neon"] = 1312.5, ["Neon|Ride"] = 1283.63, ["Neon|Fly|Ride"] = 1252.12, ["Mega|Ride"] = 9385.44, ["Mega|Fly|Ride"] = 4677.37}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 85.55, ["Ride"] = 114.09, ["Fly|Ride"] = 284.82, ["Neon"] = 616.88, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 585.27, ["Mega"] = 2275.77, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1704.94}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 16.85, ["Ride"] = 15.32, ["Fly|Ride"] = 48.42, ["Neon"] = 8.44, ["Neon|Fly"] = 43.22, ["Neon|Ride"] = 34.15, ["Neon|Fly|Ride"] = 64.05, ["Mega|Fly"] = 212.24, ["Mega|Ride"] = 83.2, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 19.15, ["Ride"] = 14.3, ["Fly|Ride"] = 35.6, ["Neon"] = 6.29, ["Neon|Fly"] = 52.69, ["Neon|Ride"] = 25.54, ["Neon|Fly|Ride"] = 49.88, ["Mega"] = 65.54, ["Mega|Fly"] = 284.75, ["Mega|Ride"] = 109.86, ["Mega|Fly|Ride"] = 161.24}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 3.66, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 62.91, ["Mega"] = 277.29, ["Mega|Ride"] = 426.59}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 246.47, ["Fly"] = 420, ["Ride"] = 249.38, ["Fly|Ride"] = 288.75, ["Neon|Ride"] = 2132.88, ["Neon|Fly|Ride"] = 1578.33, ["Mega|Ride"] = 8531.44, ["Mega|Fly|Ride"] = 3806.25}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 4.29, ["Fly"] = 22.44, ["Ride"] = 15.75, ["Fly|Ride"] = 39.45, ["Neon"] = 14.44, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 39.25, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 255.94, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 426.59}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 4.29, ["Ride"] = 34.13, ["Fly|Ride"] = 213.31, ["Neon"] = 35.1, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 253.32, ["Mega|Ride"] = 288.65}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 82.68, ["Neon"] = 6.26, ["Neon|Ride"] = 155.92, ["Mega"] = 68.27, ["Mega|Ride"] = 213.3}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 12.39, ["Fly"] = 31.19, ["Ride"] = 21, ["Fly|Ride"] = 78.93, ["Neon"] = 80.98, ["Neon|Ride"] = 99.56, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 510.57, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 587.9}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 32.71, ["Fly"] = 121.02, ["Ride"] = 78.74, ["Fly|Ride"] = 196.87, ["Neon"] = 137.43, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 211.17, ["Neon|Fly|Ride"] = 279.37, ["Mega"] = 437.14, ["Mega|Fly"] = 2239.51, ["Mega|Ride"] = 462.51, ["Mega|Fly|Ride"] = 572.41}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 26.25, ["Fly"] = 63, ["Ride"] = 50.14, ["Fly|Ride"] = 100.27, ["Neon"] = 142.7, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 142.92, ["Neon|Fly|Ride"] = 285.89, ["Mega"] = 711.33, ["Mega|Ride"] = 700.87, ["Mega|Fly|Ride"] = 740.12}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 20.86, ["Ride"] = 14.95, ["Fly|Ride"] = 42.33, ["Neon"] = 2.1, ["Neon|Fly"] = 27.47, ["Neon|Ride"] = 18.14, ["Neon|Fly|Ride"] = 47.15, ["Mega"] = 18.23, ["Mega|Fly"] = 426.59, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 207.31, ["Ride"] = 221.78, ["Fly|Ride"] = 295.32, ["Neon"] = 2061.81, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 6.46, ["Fly"] = 101.19, ["Ride"] = 49.41, ["Fly|Ride"] = 105, ["Neon"] = 127.99, ["Neon|Ride"] = 209.04, ["Neon|Fly|Ride"] = 127.99, ["Mega|Ride"] = 725.69, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 32.29, ["Ride"] = 18.25, ["Fly|Ride"] = 42.09, ["Neon"] = 6.23, ["Neon|Ride"] = 27.35, ["Neon|Fly|Ride"] = 113.06, ["Mega"] = 62.93, ["Mega|Fly"] = 284.75, ["Mega|Ride"] = 85.33, ["Mega|Fly|Ride"] = 85.33}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 32.01, ["Ride"] = 21.37, ["Fly|Ride"] = 44.18, ["Neon"] = 2.63, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.54, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 25.6, ["Mega|Fly"] = 142.92, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 142.92}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 28.74, ["Fly|Ride"] = 72.19, ["Neon"] = 9.59, ["Neon|Fly"] = 725.99, ["Neon|Ride"] = 28.81, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 103.68, ["Mega|Ride"] = 136.4, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 6.57, ["Fly"] = 38.66, ["Ride"] = 19.59, ["Fly|Ride"] = 61.74, ["Neon"] = 49.74, ["Neon|Fly"] = 306.1, ["Neon|Ride"] = 45.02, ["Neon|Fly|Ride"] = 112.21, ["Mega"] = 355.69, ["Mega|Ride"] = 236.24, ["Mega|Fly|Ride"] = 404.25}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 12.12, ["Ride"] = 183.63, ["Neon"] = 53.47, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 275.63, ["Mega|Ride"] = 424.46, ["Mega|Fly|Ride"] = 412.72}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 43.96, ["Neon"] = 3.51, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 100.36, ["Mega"] = 52.5, ["Mega|Ride"] = 77.26, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 5.7, ["Ride"] = 26.54, ["Fly|Ride"] = 131.25, ["Neon"] = 24.55, ["Neon|Fly"] = 102.8, ["Neon|Ride"] = 45, ["Neon|Fly|Ride"] = 269.07, ["Mega"] = 251.88, ["Mega|Ride"] = 191.87, ["Mega|Fly|Ride"] = 274.56}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 81.06, ["Neon"] = 6.57, ["Neon|Fly"] = 114.12, ["Neon|Ride"] = 45.78, ["Neon|Fly|Ride"] = 102.3, ["Mega"] = 24.92, ["Mega|Ride"] = 91.34, ["Mega|Fly|Ride"] = 138.66}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 43.63, ["Ride"] = 17.63, ["Fly|Ride"] = 55.91, ["Neon"] = 5.16, ["Neon|Ride"] = 20.68, ["Neon|Fly|Ride"] = 123.72, ["Mega"] = 52.03, ["Mega|Ride"] = 123.26, ["Mega|Fly|Ride"] = 284.75}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 767.47, ["Ride"] = 748.13, ["Fly|Ride"] = 892.24, ["Neon|Fly|Ride"] = 3609.37, ["Mega|Fly|Ride"] = 12571.04}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 19.21, ["Ride"] = 14.39, ["Fly|Ride"] = 36.11, ["Neon"] = 13.11, ["Neon|Fly"] = 140.88, ["Neon|Ride"] = 35.79, ["Neon|Fly|Ride"] = 113.71, ["Mega|Fly|Ride"] = 426.59}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 45.93, ["Fly|Ride"] = 284.78, ["Neon"] = 8.04, ["Neon|Fly"] = 746.58, ["Neon|Ride"] = 88.56, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 55.12, ["Mega|Fly"] = 213.3, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 242.09}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 7.44, ["Fly"] = 28.81, ["Ride"] = 20.82, ["Fly|Ride"] = 47.25, ["Neon"] = 41.15, ["Neon|Fly"] = 193.27, ["Neon|Ride"] = 49.26, ["Neon|Fly|Ride"] = 97.12, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 296.13}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.37, ["Fly|Ride"] = 33.04, ["Neon"] = 5.25, ["Neon|Fly"] = 64.32, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 63, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 85.22, ["Mega|Fly|Ride"] = 142.92}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 32.81, ["Ride"] = 83.06, ["Fly|Ride"] = 284.78, ["Neon"] = 196.88, ["Neon|Ride"] = 203.76, ["Mega"] = 1422.64}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 19.58, ["Fly|Ride"] = 64.26, ["Neon"] = 3.94, ["Neon|Fly"] = 137.95, ["Neon|Ride"] = 29.77, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 44.63, ["Mega|Ride"] = 131.36, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 32.68, ["Ride"] = 23, ["Fly|Ride"] = 61.87, ["Neon"] = 13.13, ["Neon|Ride"] = 41.88, ["Neon|Fly|Ride"] = 114.12, ["Mega"] = 95.82, ["Mega|Ride"] = 198.59, ["Mega|Fly|Ride"] = 351.74}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.37, ["Fly|Ride"] = 59.07, ["Neon"] = 26.25, ["Mega"] = 95.55, ["Mega|Ride"] = 159.98, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 17.06, ["Fly|Ride"] = 49.87, ["Neon"] = 3.9, ["Neon|Ride"] = 24.54, ["Neon|Fly|Ride"] = 103.84, ["Mega"] = 40.79, ["Mega|Fly"] = 229.68, ["Mega|Ride"] = 64.87}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 9.28, ["Fly"] = 19.99, ["Ride"] = 17.77, ["Fly|Ride"] = 32.82, ["Neon"] = 105, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 103.24, ["Mega|Ride"] = 463.91, ["Mega|Fly|Ride"] = 467.13}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 714.66, ["Ride"] = 682.5, ["Fly|Ride"] = 840, ["Neon"] = 1800.93, ["Neon|Ride"] = 1967.44, ["Neon|Fly|Ride"] = 2163, ["Mega"] = 4654.5, ["Mega|Fly|Ride"] = 6289.21}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 18.37, ["Ride"] = 15.49, ["Fly|Ride"] = 34.12, ["Neon"] = 4.23, ["Neon|Ride"] = 19.19, ["Neon|Fly|Ride"] = 51.45, ["Mega"] = 44.62, ["Mega|Ride"] = 57.73, ["Mega|Fly|Ride"] = 143.06}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 5.62, ["Ride"] = 32.81, ["Fly|Ride"] = 202.02, ["Neon"] = 47.16, ["Neon|Fly"] = 72.61, ["Neon|Ride"] = 106.78, ["Neon|Fly|Ride"] = 210, ["Mega"] = 366.18, ["Mega|Ride"] = 351.2, ["Mega|Fly|Ride"] = 537.24}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 49.88, ["Fly"] = 104.9, ["Ride"] = 62.77, ["Fly|Ride"] = 111.57, ["Neon"] = 424.48, ["Neon|Ride"] = 421.42, ["Neon|Fly|Ride"] = 65.33, ["Mega"] = 2439.83, ["Mega|Fly|Ride"] = 1564.47}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 28.87, ["Ride"] = 43.74, ["Fly|Ride"] = 104.89, ["Neon"] = 187.69, ["Neon|Ride"] = 223.97, ["Neon|Fly|Ride"] = 213.3, ["Mega"] = 983.89, ["Mega|Ride"] = 896.44, ["Mega|Fly|Ride"] = 1053.65}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 7.5, ["Fly"] = 84.72, ["Ride"] = 18.17, ["Fly|Ride"] = 140.91, ["Neon"] = 56.6, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 123.72, ["Mega"] = 305.82, ["Mega|Fly|Ride"] = 460.69}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 26.76, ["Ride"] = 57.61, ["Neon"] = 103.68, ["Neon|Ride"] = 70.75, ["Mega"] = 236.25, ["Mega|Fly"] = 524.92, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 14.44, ["Ride"] = 28.81, ["Fly|Ride"] = 152.17, ["Neon"] = 284.78, ["Neon|Ride"] = 322.94, ["Neon|Fly|Ride"] = 525, ["Mega"] = 924, ["Mega|Ride"] = 639.87, ["Mega|Fly|Ride"] = 563.21}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 4.7}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 3.03, ["Ride"] = 23.47, ["Fly|Ride"] = 59.05, ["Neon"] = 33.78, ["Neon|Ride"] = 81.04, ["Neon|Fly|Ride"] = 493.49, ["Mega"] = 196.27, ["Mega|Fly"] = 482.04, ["Mega|Ride"] = 232.51, ["Mega|Fly|Ride"] = 287.81}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.76, ["Ride"] = 28.93, ["Neon"] = 11.81, ["Neon|Fly|Ride"] = 213.3, ["Mega"] = 140.44, ["Mega|Fly|Ride"] = 416.07}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 40.69, ["Fly"] = 62.99, ["Ride"] = 54.41, ["Fly|Ride"] = 89.34, ["Neon"] = 203.34, ["Neon|Ride"] = 216.57, ["Neon|Fly|Ride"] = 639.87, ["Mega|Ride"] = 1706.31, ["Mega|Fly|Ride"] = 835.03}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 4.33, ["Fly"] = 17.9, ["Ride"] = 15.26, ["Fly|Ride"] = 33.83, ["Neon"] = 26.16, ["Neon|Fly"] = 57.61, ["Neon|Ride"] = 31.95, ["Neon|Fly|Ride"] = 73.39, ["Mega"] = 198.18, ["Mega|Fly"] = 425.52, ["Mega|Ride"] = 180.49, ["Mega|Fly|Ride"] = 277.1}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 4.66, ["Fly"] = 37.34, ["Ride"] = 27.43, ["Fly|Ride"] = 70.16, ["Neon"] = 19.21, ["Neon|Ride"] = 41.91, ["Neon|Fly|Ride"] = 85.31, ["Mega"] = 135.85, ["Mega|Ride"] = 169.31, ["Mega|Fly|Ride"] = 236.23}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 6.17, ["Mega"] = 39.29, ["Mega|Ride"] = 196.59, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 24.94, ["Fly"] = 77.96, ["Ride"] = 52.48, ["Fly|Ride"] = 89.25, ["Neon"] = 183.75, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 294.35, ["Mega|Ride"] = 845.43, ["Mega|Fly|Ride"] = 1053.65}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 20.57, ["Fly|Ride"] = 65.63, ["Neon"] = 3.83, ["Neon|Ride"] = 28.81, ["Mega"] = 76.04, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 462.41}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 15.65, ["Ride"] = 81.09, ["Fly|Ride"] = 283.7, ["Neon"] = 101.33, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 392.44, ["Mega|Fly|Ride"] = 613.22}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 14.95, ["Fly|Ride"] = 40.65, ["Neon"] = 91.47, ["Neon|Ride"] = 38.72, ["Neon|Fly|Ride"] = 76.64, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 322.94}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 3, ["Fly"] = 52.49, ["Ride"] = 19.3, ["Fly|Ride"] = 75.12, ["Neon"] = 36.75, ["Neon|Ride"] = 426.59, ["Mega"] = 291.38, ["Mega|Ride"] = 425.52, ["Mega|Fly|Ride"] = 426.59}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 2.62, ["Ride"] = 67.2, ["Neon"] = 39.37, ["Neon|Ride"] = 81.04, ["Mega"] = 498.04, ["Mega|Ride"] = 956.1}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 37.97, ["Ride"] = 131.25, ["Neon"] = 307.13, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 426.59, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 18.8, ["Ride"] = 284.78, ["Neon"] = 105.6, ["Neon|Ride"] = 183.75, ["Mega"] = 424.36, ["Mega|Ride"] = 564.83, ["Mega|Fly|Ride"] = 569.49}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 4.29, ["Ride"] = 125.98, ["Neon"] = 174.58, ["Neon|Fly"] = 213.31, ["Neon|Ride"] = 426.59, ["Mega"] = 142.92, ["Mega|Ride"] = 852.09}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 21.68, ["Ride"] = 232.32, ["Fly|Ride"] = 367.46, ["Neon"] = 103.36, ["Neon|Ride"] = 746.51, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 586.44, ["Mega|Fly"] = 2132.88, ["Mega|Fly|Ride"] = 1129.65}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.94, ["Neon"] = 18.11, ["Neon|Ride"] = 32.67, ["Mega"] = 210, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 322.94}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 27.75, ["Ride"] = 18.38, ["Fly|Ride"] = 40.61, ["Neon"] = 4.18, ["Neon|Fly"] = 43.01, ["Neon|Ride"] = 41.9, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 66.67, ["Mega|Ride"] = 86.67, ["Mega|Fly|Ride"] = 321.57}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 2.52, ["Ride"] = 42.67, ["Fly|Ride"] = 65.63, ["Neon"] = 12.76, ["Neon|Ride"] = 70.02, ["Neon|Fly|Ride"] = 111.46, ["Mega"] = 87.94, ["Mega|Ride"] = 160.93, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 142.93, ["Ride"] = 19.47, ["Fly|Ride"] = 57.63, ["Neon"] = 4.93, ["Neon|Ride"] = 26.15, ["Neon|Fly|Ride"] = 105, ["Mega"] = 41.91, ["Mega|Fly"] = 170.64, ["Mega|Ride"] = 77.6, ["Mega|Fly|Ride"] = 192.95}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.3, ["Fly"] = 65.62, ["Ride"] = 23.27, ["Fly|Ride"] = 118.13, ["Neon"] = 15.73, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 328.02, ["Mega|Ride"] = 337.01, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.46, ["Fly"] = 65.63, ["Ride"] = 21.3, ["Neon"] = 26.63, ["Neon|Fly"] = 315, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 302.45, ["Mega|Ride"] = 287.47}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 2.16, ["Fly"] = 131.25, ["Ride"] = 16.02, ["Fly|Ride"] = 61.69, ["Neon"] = 28.77, ["Neon|Fly"] = 112.73, ["Neon|Ride"] = 37.34, ["Neon|Fly|Ride"] = 102.92, ["Mega"] = 249.38, ["Mega|Ride"] = 307.22, ["Mega|Fly|Ride"] = 396.38}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 34.77, ["Ride"] = 21.35, ["Fly|Ride"] = 51.89, ["Neon"] = 19.08, ["Neon|Ride"] = 70.26, ["Neon|Fly|Ride"] = 106.65, ["Mega"] = 252.82, ["Mega|Ride"] = 213.3, ["Mega|Fly|Ride"] = 186.18}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 3.22, ["Fly"] = 57.66, ["Ride"] = 43.29, ["Fly|Ride"] = 87.93, ["Neon"] = 19.69, ["Neon|Fly"] = 436.96, ["Neon|Ride"] = 45.47, ["Neon|Fly|Ride"] = 128.44, ["Mega"] = 117.91, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 132.56, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 15.54, ["Fly"] = 205.66, ["Ride"] = 99.54, ["Fly|Ride"] = 183.75, ["Neon"] = 118.13, ["Neon|Ride"] = 234.98, ["Neon|Fly|Ride"] = 420, ["Mega"] = 525, ["Mega|Ride"] = 669.38, ["Mega|Fly|Ride"] = 652.3}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 49.88, ["Fly"] = 164.07, ["Ride"] = 93.62, ["Fly|Ride"] = 181.13, ["Neon"] = 221.8, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 492.19, ["Mega"] = 1563.39, ["Mega|Ride"] = 1061.82, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 50.97, ["Ride"] = 18.36, ["Fly|Ride"] = 65.56, ["Neon"] = 3.82, ["Neon|Ride"] = 24.24, ["Mega"] = 27.64, ["Mega|Ride"] = 71.14, ["Mega|Fly|Ride"] = 143.92}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 65.63, ["Ride"] = 52.5, ["Neon"] = 284.78, ["Mega|Ride"] = 533.23, ["Mega|Fly|Ride"] = 1064.32}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 57.93, ["Fly"] = 105, ["Ride"] = 78.75, ["Fly|Ride"] = 183.75, ["Neon"] = 299.15, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 852.09, ["Mega"] = 1747.89, ["Mega|Ride"] = 1194.42}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 5.25, ["Fly"] = 190.32, ["Ride"] = 40.55, ["Fly|Ride"] = 133.88, ["Neon"] = 36.65, ["Neon|Ride"] = 83.2, ["Neon|Fly|Ride"] = 210, ["Mega"] = 192.93, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 312.38}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 3.27, ["Ride"] = 65.37, ["Fly|Ride"] = 142.93, ["Neon"] = 9.81, ["Neon|Ride"] = 65.63, ["Mega"] = 85.2, ["Mega|Fly"] = 310.84, ["Mega|Ride"] = 146.86, ["Mega|Fly|Ride"] = 364.88}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 39.25, ["Ride"] = 16.93, ["Fly|Ride"] = 51.57, ["Neon"] = 8.97, ["Neon|Ride"] = 37.02, ["Neon|Fly|Ride"] = 70.87, ["Mega"] = 236.15, ["Mega|Ride"] = 212.24, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.75, ["Ride"] = 14.18, ["Fly|Ride"] = 42.67, ["Neon"] = 2.62, ["Neon|Fly"] = 18.53, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 28.88, ["Mega|Ride"] = 69.55, ["Mega|Fly|Ride"] = 150.73}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 19.04, ["Fly|Ride"] = 92.03, ["Neon"] = 3.65, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 38.85, ["Mega|Ride"] = 125.86, ["Mega|Fly|Ride"] = 182.44}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.49, ["Fly|Ride"] = 121.02, ["Neon"] = 2.1, ["Neon|Ride"] = 145.08, ["Mega"] = 25.48, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 5.69, ["Ride"] = 104.98, ["Neon"] = 30.54, ["Neon|Ride"] = 162.08, ["Neon|Fly|Ride"] = 639.87, ["Mega"] = 322.94, ["Mega|Ride"] = 269.48, ["Mega|Fly|Ride"] = 322.94}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 6.23, ["Ride"] = 31.62, ["Fly|Ride"] = 100.27, ["Neon"] = 52.86, ["Neon|Ride"] = 100.26, ["Neon|Fly|Ride"] = 142.92, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 5.86, ["Fly"] = 41.1, ["Ride"] = 16.48, ["Fly|Ride"] = 39.27, ["Neon"] = 31.05, ["Neon|Ride"] = 38.57, ["Neon|Fly|Ride"] = 59.07, ["Mega|Ride"] = 271.95, ["Mega|Fly|Ride"] = 352.69}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 56.35, ["Ride"] = 73.5, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 597.19, ["Mega"] = 2418.93, ["Mega|Fly|Ride"] = 1472.63}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 24.92, ["Fly"] = 82.68, ["Ride"] = 32.82, ["Fly|Ride"] = 142.93, ["Neon"] = 284.78, ["Neon|Fly|Ride"] = 630, ["Mega"] = 635.92}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 26.63, ["Ride"] = 15.75, ["Fly|Ride"] = 38.06, ["Neon"] = 2.59, ["Neon|Fly"] = 36.27, ["Neon|Ride"] = 20.28, ["Neon|Fly|Ride"] = 59.73, ["Mega"] = 32.71, ["Mega|Ride"] = 89.74, ["Mega|Fly|Ride"] = 188.98}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 16.49, ["Ride"] = 14.28, ["Fly|Ride"] = 31.14, ["Neon"] = 3.81, ["Neon|Fly"] = 24.34, ["Neon|Ride"] = 19.02, ["Neon|Fly|Ride"] = 44.08, ["Mega"] = 43.35, ["Mega|Fly"] = 92.79, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 91.87}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 451.5, ["Ride"] = 446.24, ["Fly|Ride"] = 559.13, ["Neon|Fly|Ride"] = 1903.12}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 6.17, ["Ride"] = 36.32, ["Fly|Ride"] = 535.43, ["Neon"] = 45.94, ["Neon|Ride"] = 80.31, ["Mega"] = 403.49, ["Mega|Ride"] = 400.32, ["Mega|Fly|Ride"] = 284381.44}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 14.94, ["Ride"] = 17.81, ["Fly|Ride"] = 29.75, ["Neon"] = 3.29, ["Neon|Fly"] = 18.38, ["Neon|Ride"] = 17.09, ["Neon|Fly|Ride"] = 39.51, ["Mega"] = 142.92, ["Mega|Ride"] = 74.99, ["Mega|Fly|Ride"] = 106.65}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 55.47, ["Ride"] = 92.93, ["Fly|Ride"] = 298.64, ["Neon"] = 262.4, ["Neon|Ride"] = 308.13, ["Neon|Fly|Ride"] = 443.63, ["Mega"] = 721.88, ["Mega|Ride"] = 761.23, ["Mega|Fly|Ride"] = 930.36}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 19.48, ["Ride"] = 16.32, ["Fly|Ride"] = 51.19, ["Neon"] = 9.98, ["Neon|Fly"] = 62.94, ["Neon|Ride"] = 24.33, ["Neon|Fly|Ride"] = 63.86, ["Mega"] = 111.37, ["Mega|Ride"] = 124.91, ["Mega|Fly|Ride"] = 215.2}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 42.67, ["Neon"] = 3.94, ["Neon|Ride"] = 35.43, ["Neon|Fly|Ride"] = 74.81, ["Mega"] = 17.16, ["Mega|Ride"] = 59.67, ["Mega|Fly|Ride"] = 190.88}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 43.32, ["Fly"] = 107.89, ["Ride"] = 72.37, ["Fly|Ride"] = 213.94, ["Neon"] = 157.11, ["Neon|Ride"] = 191.27, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 830.82, ["Mega|Ride"] = 959.8, ["Mega|Fly|Ride"] = 811.13}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 19.67, ["Fly|Ride"] = 52.5, ["Neon"] = 4.6, ["Neon|Ride"] = 39.99, ["Neon|Fly|Ride"] = 78.93, ["Mega"] = 36.75, ["Mega|Ride"] = 195.33, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 34.13, ["Ride"] = 66.94, ["Fly|Ride"] = 159.73, ["Neon"] = 341.3, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 288.46, ["Mega"] = 1684.98, ["Mega|Ride"] = 1706.31, ["Mega|Fly|Ride"] = 1535.67}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.48, ["Ride"] = 183.74, ["Neon"] = 21.94, ["Neon|Ride"] = 28.81, ["Neon|Fly|Ride"] = 157.84, ["Mega"] = 157.5, ["Mega|Ride"] = 200.82}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 71.47, ["Ride"] = 72.02, ["Fly|Ride"] = 68.27, ["Neon"] = 8.54, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 429.19, ["Mega"] = 96.5, ["Mega|Ride"] = 170.64, ["Mega|Fly|Ride"] = 569.49}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 41.83, ["Fly"] = 142.93, ["Ride"] = 50.93, ["Fly|Ride"] = 533.27, ["Mega|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 1830.01}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 24.76, ["Fly|Ride"] = 899.9, ["Neon"] = 4.19, ["Neon|Fly"] = 85.33, ["Neon|Ride"] = 39.89, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 45.19, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 85.33, ["Mega|Fly|Ride"] = 199.5}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 16.01, ["Ride"] = 18.41, ["Fly|Ride"] = 102.85, ["Neon"] = 10.9, ["Neon|Fly"] = 47.77, ["Neon|Ride"] = 32.63, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 96.76, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 9.11, ["Fly"] = 58.49, ["Ride"] = 31.5, ["Fly|Ride"] = 75.79, ["Neon"] = 81.78, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 142.92, ["Mega"] = 452.19, ["Mega|Ride"] = 398.86, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 7.22, ["Fly"] = 57.11, ["Ride"] = 29.04, ["Fly|Ride"] = 71.54, ["Neon"] = 65.62, ["Neon|Ride"] = 74.75, ["Neon|Fly|Ride"] = 159.45, ["Mega"] = 933.14, ["Mega|Ride"] = 450.12, ["Mega|Fly|Ride"] = 511.76}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 23.78, ["Fly"] = 51.18, ["Ride"] = 25.73, ["Fly|Ride"] = 52.5, ["Neon"] = 73.54, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 140.78, ["Mega"] = 569.49, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 393.53}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 63.84, ["Fly"] = 139.36, ["Ride"] = 114.6, ["Fly|Ride"] = 249.38, ["Neon"] = 304.5, ["Neon|Ride"] = 423.94, ["Neon|Fly|Ride"] = 647.34, ["Mega|Ride"] = 1705.24, ["Mega|Fly|Ride"] = 1309.87}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.82, ["Ride"] = 28.88, ["Neon"] = 24.05, ["Neon|Ride"] = 121.59, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 234.3, ["Mega|Ride"] = 462, ["Mega|Fly|Ride"] = 370.08}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.78, ["Ride"] = 26.67, ["Fly|Ride"] = 78.74, ["Neon"] = 15.56, ["Neon|Ride"] = 41.96, ["Neon|Fly|Ride"] = 213.3, ["Mega"] = 143.42, ["Mega|Ride"] = 170.64, ["Mega|Fly|Ride"] = 246.62}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 10.22, ["Fly"] = 287.55, ["Ride"] = 35.35, ["Fly|Ride"] = 113.21, ["Neon"] = 52.04, ["Neon|Ride"] = 141.42, ["Neon|Fly|Ride"] = 241.9, ["Mega"] = 452.36, ["Mega|Ride"] = 498.04, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 14.6, ["Ride"] = 14.42, ["Fly|Ride"] = 36.71, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 13.98, ["Neon|Fly|Ride"] = 39.25, ["Mega"] = 15.26, ["Mega|Ride"] = 32.67, ["Mega|Fly|Ride"] = 94.79}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 42.26, ["Fly"] = 226.11, ["Ride"] = 112.55, ["Fly|Ride"] = 284.78, ["Neon"] = 262.5, ["Neon|Fly"] = 2417.78, ["Neon|Ride"] = 277.71, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 3199.3, ["Mega|Ride"] = 1001.37, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 21.59, ["Fly|Ride"] = 36.27, ["Neon"] = 3.59, ["Neon|Ride"] = 28.01, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 269.82, ["Mega|Ride"] = 140.58, ["Mega|Fly|Ride"] = 301.87}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.81, ["Ride"] = 16.68, ["Fly|Ride"] = 59.06, ["Neon"] = 42.67, ["Neon|Ride"] = 29.1, ["Neon|Fly|Ride"] = 89.13, ["Mega"] = 257.25, ["Mega|Ride"] = 192.93, ["Mega|Fly|Ride"] = 282.89}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 39.38, ["Fly"] = 157.5, ["Ride"] = 102.9, ["Fly|Ride"] = 258.57, ["Neon"] = 278.25, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 426.59, ["Mega"] = 1745.63, ["Mega|Ride"] = 1422.64, ["Mega|Fly|Ride"] = 1715.44}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 23.52, ["Neon"] = 5.75, ["Neon|Ride"] = 52.41, ["Mega"] = 64.32, ["Mega|Ride"] = 108.02, ["Mega|Fly|Ride"] = 287.44}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 9.08}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Fly|Ride"] = 302.9, ["Neon"] = 4.55, ["Neon|Ride"] = 51.35, ["Neon|Fly|Ride"] = 157.84, ["Mega"] = 46.29, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 217.47}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 114.34, ["Ride"] = 124.69, ["Fly|Ride"] = 236.25, ["Neon"] = 836.07, ["Neon|Ride"] = 709.97, ["Neon|Fly|Ride"] = 917.44, ["Mega"] = 3412.59, ["Mega|Ride"] = 2493.75, ["Mega|Fly|Ride"] = 2835}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 4.19, ["Ride"] = 36.37, ["Neon"] = 19.19, ["Neon|Fly"] = 142.93, ["Neon|Ride"] = 64.32, ["Mega"] = 178.39, ["Mega|Ride"] = 211.31, ["Mega|Fly|Ride"] = 645.87}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 36.27, ["Neon"] = 3.72, ["Neon|Ride"] = 20.44, ["Mega"] = 31.2, ["Mega|Ride"] = 104.53, ["Mega|Fly|Ride"] = 142.92}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 4.02, ["Ride"] = 19.83, ["Fly|Ride"] = 131.25, ["Neon"] = 51.35, ["Neon|Ride"] = 65.33, ["Neon|Fly|Ride"] = 162.08, ["Mega"] = 390.33, ["Mega|Ride"] = 426.59, ["Mega|Fly|Ride"] = 625.64}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 10.18, ["Fly"] = 67.34, ["Ride"] = 21.36, ["Fly|Ride"] = 56.58, ["Neon"] = 99, ["Neon|Ride"] = 156.19, ["Neon|Fly|Ride"] = 307.79, ["Mega"] = 626.07, ["Mega|Ride"] = 574.88, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 22.59, ["Ride"] = 71.31, ["Fly|Ride"] = 128.27, ["Neon"] = 172.09, ["Neon|Ride"] = 177.17, ["Neon|Fly|Ride"] = 199.44, ["Mega"] = 560.44, ["Mega|Ride"] = 711.33, ["Mega|Fly|Ride"] = 584.07}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 127.31, ["Fly"] = 157.85, ["Ride"] = 163.46, ["Fly|Ride"] = 183.75, ["Neon"] = 565.13, ["Neon|Ride"] = 590.4, ["Neon|Fly|Ride"] = 628.69, ["Mega|Fly|Ride"] = 2420.14}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 127.99, ["Ride"] = 399.96, ["Fly|Ride"] = 196.88, ["Neon"] = 284.78, ["Neon|Ride"] = 1279.73, ["Neon|Fly|Ride"] = 1279.73, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 131.15, ["Ride"] = 21, ["Fly|Ride"] = 131.23, ["Neon"] = 15.74, ["Neon|Ride"] = 32.78, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 138.66, ["Mega|Ride"] = 140.32, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 6.28, ["Fly"] = 98.43, ["Ride"] = 26.16, ["Fly|Ride"] = 183.45, ["Neon"] = 114.6, ["Neon|Ride"] = 80.07, ["Neon|Fly|Ride"] = 198.37, ["Mega"] = 379.32, ["Mega|Ride"] = 433.13, ["Mega|Fly|Ride"] = 557.82}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 48.6, ["Fly"] = 159.73, ["Ride"] = 83.9, ["Neon"] = 284.78, ["Neon|Ride"] = 280.49, ["Neon|Fly|Ride"] = 456.44, ["Mega"] = 959.8, ["Mega|Ride"] = 984.52, ["Mega|Fly|Ride"] = 1002.04}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 17.61, ["Ride"] = 83.99, ["Neon"] = 155.74, ["Neon|Ride"] = 183.91, ["Neon|Fly|Ride"] = 470.31, ["Mega"] = 705.98, ["Mega|Ride"] = 493.03}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.39, ["Ride"] = 615.57, ["Neon|Ride"] = 3225.66, ["Neon|Fly|Ride"] = 1376.82}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 28.88, ["Fly"] = 57.61, ["Ride"] = 32.55, ["Fly|Ride"] = 75.71, ["Neon"] = 196.88, ["Neon|Ride"] = 229.69, ["Neon|Fly|Ride"] = 322.94, ["Mega"] = 761.25, ["Mega|Ride"] = 734.9, ["Mega|Fly|Ride"] = 918.87}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 38.66, ["Ride"] = 13.67, ["Fly|Ride"] = 31.5, ["Neon"] = 2.61, ["Neon|Ride"] = 17.2, ["Neon|Fly|Ride"] = 47.84, ["Mega"] = 20.47, ["Mega|Fly"] = 104.53, ["Mega|Ride"] = 35.11, ["Mega|Fly|Ride"] = 103.69}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 3.8, ["Neon"] = 10.23, ["Neon|Ride"] = 57.61, ["Neon|Fly|Ride"] = 142.92, ["Mega|Ride"] = 120.96}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 4.13, ["Ride"] = 38.57, ["Fly|Ride"] = 144.21, ["Neon"] = 20.54, ["Neon|Ride"] = 83.06, ["Neon|Fly|Ride"] = 981.05, ["Mega"] = 115.4, ["Mega|Fly"] = 498.61, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 393.75, ["Fly"] = 498.6, ["Ride"] = 354.37, ["Fly|Ride"] = 519.75, ["Neon"] = 1424.39, ["Neon|Ride"] = 1774.29, ["Neon|Fly|Ride"] = 1610.32, ["Mega|Fly|Ride"] = 5502.79}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 3.82, ["Fly"] = 20.62, ["Ride"] = 17.07, ["Fly|Ride"] = 28.71, ["Neon"] = 24.54, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 87.44, ["Mega"] = 170.63, ["Mega|Ride"] = 213.94, ["Mega|Fly|Ride"] = 563.07}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 5.71, ["Fly"] = 19.99, ["Ride"] = 17.75, ["Fly|Ride"] = 39.38, ["Neon"] = 24.54, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 59.73, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 271.95, ["Mega|Fly|Ride"] = 286.38}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 2.1, ["Fly"] = 32.45, ["Ride"] = 28.88, ["Fly|Ride"] = 78.75, ["Neon"] = 16.7, ["Neon|Fly"] = 94.49, ["Neon|Ride"] = 55.65, ["Neon|Fly|Ride"] = 79.86, ["Mega"] = 123.38, ["Mega|Ride"] = 191.98, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 28.85, ["Fly"] = 44.66, ["Ride"] = 42.67, ["Fly|Ride"] = 65.63, ["Neon"] = 162.16, ["Neon|Ride"] = 176.59, ["Neon|Fly|Ride"] = 318.88, ["Mega"] = 1312.5, ["Mega|Ride"] = 852.09, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 34, ["Fly|Ride"] = 49.18, ["Neon"] = 11.7, ["Neon|Ride"] = 37.51, ["Neon|Fly|Ride"] = 210, ["Mega"] = 163.74, ["Mega|Ride"] = 457.79, ["Mega|Fly|Ride"] = 919.42}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 7.66, ["Fly"] = 65.6, ["Ride"] = 25.99, ["Fly|Ride"] = 91.88, ["Neon"] = 168.79, ["Neon|Fly"] = 162.08, ["Neon|Ride"] = 112.88, ["Mega"] = 746.51, ["Mega|Ride"] = 767.85, ["Mega|Fly|Ride"] = 846.57}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.77, ["Neon"] = 5.93, ["Neon|Ride"] = 35.21, ["Mega"] = 53.83, ["Mega|Ride"] = 120.51, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 7.88, ["Fly"] = 71.47, ["Neon"] = 50.57}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 9.09, ["Ride"] = 78.93, ["Neon"] = 81.46, ["Neon|Ride"] = 483.79, ["Neon|Fly|Ride"] = 426.59, ["Mega"] = 314.62, ["Mega|Ride"] = 550.29, ["Mega|Fly|Ride"] = 509.25}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 5.96, ["Fly"] = 28.68, ["Ride"] = 22.32, ["Fly|Ride"] = 52.4, ["Neon"] = 48.42, ["Neon|Fly"] = 114.22, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 599.36, ["Mega|Ride"] = 314.93, ["Mega|Fly|Ride"] = 339.06}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 343.88, ["Fly"] = 549.33, ["Ride"] = 389.19, ["Fly|Ride"] = 415.96, ["Neon"] = 1659, ["Neon|Ride"] = 1493.94, ["Neon|Fly|Ride"] = 1428.8, ["Mega|Fly|Ride"] = 5250}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.65, ["Fly|Ride"] = 36.27, ["Neon"] = 13.01, ["Neon|Fly"] = 81.09, ["Neon|Ride"] = 34.08, ["Neon|Fly|Ride"] = 131.92, ["Mega"] = 206.91, ["Mega|Ride"] = 196.77}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 2.39, ["Ride"] = 100.27, ["Fly|Ride"] = 91.73, ["Neon"] = 52.5, ["Neon|Ride"] = 157.84, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 356.2, ["Mega|Fly"] = 711.33, ["Mega|Ride"] = 411.64}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 21.84, ["Ride"] = 83.16, ["Fly|Ride"] = 315, ["Neon"] = 73.5, ["Neon|Ride"] = 181.92, ["Neon|Fly|Ride"] = 351.98, ["Mega"] = 366.09, ["Mega|Ride"] = 369.81, ["Mega|Fly|Ride"] = 580.55}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 61.69, ["Fly"] = 130.12, ["Fly|Ride"] = 165.93, ["Neon|Ride"] = 405.26, ["Neon|Fly|Ride"] = 1172.03, ["Mega"] = 2492.09, ["Mega|Ride"] = 1836.19}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 9.98, ["Fly"] = 106.66, ["Ride"] = 51.89, ["Fly|Ride"] = 137.57, ["Neon"] = 46.95, ["Neon|Ride"] = 87.08, ["Neon|Fly|Ride"] = 367.49, ["Mega"] = 226.1, ["Mega|Ride"] = 316.02, ["Mega|Fly|Ride"] = 426.8}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 28.87, ["Ride"] = 19.59, ["Fly|Ride"] = 58.46, ["Neon"] = 12.47, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 71.47, ["Mega"] = 65.6, ["Mega|Ride"] = 147.56, ["Mega|Fly|Ride"] = 261.18}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 8.73, ["Ride"] = 35.25, ["Fly|Ride"] = 64.32, ["Neon"] = 25.17, ["Neon|Ride"] = 94.17, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 176.77, ["Mega|Ride"] = 178.11}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 53.12, ["Fly"] = 183.75, ["Ride"] = 95.7, ["Fly|Ride"] = 216.57, ["Neon"] = 134.88, ["Neon|Ride"] = 157.4, ["Neon|Fly|Ride"] = 338.63, ["Mega"] = 430.15, ["Mega|Ride"] = 453.18, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 3.99, ["Ride"] = 131.24, ["Fly|Ride"] = 142.93, ["Neon"] = 6.38, ["Neon|Ride"] = 213.3, ["Neon|Fly|Ride"] = 199.31, ["Mega"] = 81.38, ["Mega|Ride"] = 185.58}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 15.81, ["Ride"] = 131.25, ["Neon"] = 123.38, ["Neon|Ride"] = 401.03, ["Neon|Fly|Ride"] = 853.16, ["Mega"] = 584.79, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 1023.75, ["Fly"] = 971.25, ["Ride"] = 1061.7, ["Fly|Ride"] = 1115.63, ["Neon"] = 3393.63, ["Neon|Ride"] = 3526.69, ["Neon|Fly|Ride"] = 3281.22, ["Mega|Fly|Ride"] = 11772.91}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 14.44, ["Fly"] = 94.15, ["Ride"] = 58.5, ["Fly|Ride"] = 191.63, ["Neon"] = 196.88, ["Neon|Fly"] = 700.88, ["Neon|Ride"] = 277.29, ["Mega"] = 337.89, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.34, ["Ride"] = 21.15, ["Fly|Ride"] = 80.92, ["Neon"] = 10.68, ["Neon|Fly"] = 57.61, ["Neon|Ride"] = 33.43, ["Neon|Fly|Ride"] = 93.85, ["Mega"] = 81.38, ["Mega|Ride"] = 98.22, ["Mega|Fly|Ride"] = 190.91}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 6.57, ["Ride"] = 47.79, ["Fly|Ride"] = 142.93, ["Neon"] = 100.27, ["Mega"] = 787.5, ["Mega|Ride"] = 485.24, ["Mega|Fly|Ride"] = 481.38}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 35.06, ["Fly|Ride"] = 182.97, ["Neon"] = 2.61, ["Neon|Ride"] = 25.6, ["Neon|Fly|Ride"] = 80.06, ["Mega"] = 16.95, ["Mega|Fly"] = 127.99, ["Mega|Ride"] = 49.79, ["Mega|Fly|Ride"] = 213.3}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 54.1, ["Ride"] = 118.72, ["Fly|Ride"] = 196.88, ["Neon"] = 260.98, ["Neon|Ride"] = 314.62, ["Mega"] = 1106.35, ["Mega|Ride"] = 958.13, ["Mega|Fly|Ride"] = 958.13}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 7.23, ["Ride"] = 52.5, ["Fly|Ride"] = 238.87, ["Neon"] = 65.63, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 540.69, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 604.75}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 27.36, ["Neon"] = 8.42, ["Neon|Ride"] = 65.63, ["Mega"] = 88.92, ["Mega|Ride"] = 157.49, ["Mega|Fly|Ride"] = 426.59}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 19.16, ["Fly"] = 67.2, ["Ride"] = 40.77, ["Fly|Ride"] = 121.02, ["Neon"] = 78.11, ["Neon|Ride"] = 93.19, ["Neon|Fly|Ride"] = 155.92, ["Mega"] = 1039.49, ["Mega|Ride"] = 365.77, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 3.83, ["Fly"] = 31.57, ["Ride"] = 36.63, ["Fly|Ride"] = 96.01, ["Neon"] = 78.81, ["Neon|Ride"] = 71.47, ["Neon|Fly|Ride"] = 120.09, ["Mega"] = 390.33, ["Mega|Ride"] = 527.89, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 30.66, ["Ride"] = 208.68, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 731.73, ["Mega"] = 2103.24, ["Mega|Ride"] = 1706.31, ["Mega|Fly|Ride"] = 1692.44}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 4.19, ["Ride"] = 51.2, ["Fly|Ride"] = 199.45, ["Neon"] = 15.64, ["Neon|Ride"] = 96, ["Neon|Fly|Ride"] = 161.21, ["Mega"] = 101.07, ["Mega|Ride"] = 130.71, ["Mega|Fly|Ride"] = 227.05}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 3.94, ["Ride"] = 15.44, ["Fly|Ride"] = 84.27, ["Neon"] = 48.42, ["Neon|Ride"] = 58.84, ["Neon|Fly|Ride"] = 356.2, ["Mega"] = 295.32, ["Mega|Ride"] = 407.39, ["Mega|Fly|Ride"] = 612.15}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 111.25, ["Fly"] = 183.45, ["Ride"] = 180.55, ["Fly|Ride"] = 246.88, ["Neon"] = 523.99, ["Neon|Ride"] = 580.79, ["Neon|Fly|Ride"] = 780.65, ["Mega"] = 2327.07, ["Mega|Ride"] = 2417.61, ["Mega|Fly|Ride"] = 1945.13}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 19.21, ["Ride"] = 15.65, ["Fly|Ride"] = 42.67, ["Neon"] = 12.96, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 83.09, ["Mega"] = 142.92, ["Mega|Ride"] = 238.8, ["Mega|Fly|Ride"] = 580.55}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 6.57, ["Fly"] = 197.4, ["Ride"] = 39.26, ["Fly|Ride"] = 96.71, ["Neon"] = 94.39, ["Neon|Ride"] = 84.7, ["Neon|Fly|Ride"] = 213.3, ["Mega"] = 452.82, ["Mega|Ride"] = 484.17, ["Mega|Fly|Ride"] = 415.68}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.37, ["Ride"] = 14.6, ["Fly|Ride"] = 52.41, ["Neon"] = 2.1, ["Neon|Fly"] = 26.57, ["Neon|Ride"] = 14.7, ["Neon|Fly|Ride"] = 39.29, ["Mega"] = 14.93, ["Mega|Fly"] = 50.81, ["Mega|Ride"] = 29.86, ["Mega|Fly|Ride"] = 72.19}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 57.61, ["Fly|Ride"] = 39.38, ["Neon"] = 3.86, ["Neon|Ride"] = 42.67, ["Neon|Fly|Ride"] = 132.25, ["Mega"] = 18.17, ["Mega|Fly"] = 104.99, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 138.8}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 36.27, ["Ride"] = 26.87, ["Fly|Ride"] = 122.26, ["Neon"] = 16.99, ["Neon|Ride"] = 53.33, ["Neon|Fly|Ride"] = 210.47, ["Mega"] = 77.44, ["Mega|Ride"] = 270.88, ["Mega|Fly|Ride"] = 246.1}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 31.18, ["Ride"] = 52.47, ["Fly|Ride"] = 131.25, ["Neon"] = 168, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 427.28, ["Mega|Ride"] = 576.19, ["Mega|Fly|Ride"] = 947}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 19.38, ["Ride"] = 14.89, ["Fly|Ride"] = 35.42, ["Neon"] = 9.54, ["Neon|Fly"] = 29.65, ["Neon|Ride"] = 26.99, ["Neon|Fly|Ride"] = 54.51, ["Mega"] = 105, ["Mega|Fly"] = 170.62, ["Mega|Ride"] = 121.59, ["Mega|Fly|Ride"] = 155.93}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 6.46, ["Fly"] = 45.03, ["Ride"] = 24.64, ["Fly|Ride"] = 81.81, ["Neon"] = 17.28, ["Neon|Fly"] = 55.76, ["Neon|Ride"] = 40.16, ["Neon|Fly|Ride"] = 114.12, ["Mega"] = 219.34, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 211.87, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 21.21, ["Ride"] = 18.09, ["Fly|Ride"] = 70.41, ["Neon"] = 8.15, ["Neon|Fly"] = 36.27, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 71.47, ["Mega"] = 162.08, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 84.67, ["Mega|Fly|Ride"] = 127.32}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 7.02, ["Fly"] = 161.05, ["Ride"] = 23.82, ["Fly|Ride"] = 217.19, ["Neon"] = 26.23, ["Neon|Ride"] = 100.5, ["Neon|Fly|Ride"] = 284.75, ["Mega"] = 261.83, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 382.86, ["Mega|Fly|Ride"] = 426.59}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 7.19, ["Ride"] = 141.17, ["Neon"] = 74.76, ["Neon|Ride"] = 262.4, ["Mega"] = 682.5, ["Mega|Fly|Ride"] = 996.07}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 42.67, ["Ride"] = 18.53, ["Fly|Ride"] = 44.92, ["Neon"] = 26.17, ["Neon|Fly"] = 196.76, ["Neon|Ride"] = 41.61, ["Neon|Fly|Ride"] = 113.71, ["Mega"] = 255.94, ["Mega|Ride"] = 379.66, ["Mega|Fly|Ride"] = 421.25}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 24.85, ["Ride"] = 13.6, ["Fly|Ride"] = 36.32, ["Neon"] = 16.48, ["Neon|Fly"] = 48.42, ["Neon|Ride"] = 36.27, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 187.69, ["Mega|Ride"] = 283.03, ["Mega|Fly|Ride"] = 185.58}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 224.97, ["Fly"] = 393.75, ["Ride"] = 281.95, ["Fly|Ride"] = 380.63, ["Neon"] = 1249.96, ["Neon|Ride"] = 1451.37, ["Neon|Fly|Ride"] = 1174.69, ["Mega|Fly|Ride"] = 4074.83}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 4.92, ["Ride"] = 110.62, ["Neon"] = 35.44, ["Neon|Ride"] = 142.92, ["Neon|Fly|Ride"] = 426.59, ["Mega"] = 85.33, ["Mega|Ride"] = 420.6}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.18, ["Fly"] = 106.67, ["Ride"] = 21.78, ["Fly|Ride"] = 57.61, ["Neon"] = 22.65, ["Neon|Fly"] = 242.11, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 204.65, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 234.94}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 6.57, ["Fly|Ride"] = 212.89, ["Neon"] = 36.75, ["Neon|Ride"] = 226.1, ["Neon|Fly|Ride"] = 639.87, ["Mega"] = 596.53, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 416.72}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 16.06, ["Ride"] = 14.16, ["Fly|Ride"] = 29.79, ["Neon"] = 2.62, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 15.83, ["Neon|Fly|Ride"] = 38.19, ["Mega"] = 19.21, ["Mega|Fly"] = 76.79, ["Mega|Ride"] = 38.4, ["Mega|Fly|Ride"] = 98.43}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 3.86, ["Fly"] = 24.93, ["Ride"] = 16.93, ["Fly|Ride"] = 41.24, ["Neon"] = 8.65, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 97.76, ["Mega"] = 108.76, ["Mega|Ride"] = 110.23, ["Mega|Fly|Ride"] = 213.94}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.43, ["Ride"] = 42.67, ["Neon"] = 13.12, ["Neon|Ride"] = 284.75, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 63, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 67.65, ["Ride"] = 82.28, ["Fly|Ride"] = 175.26, ["Neon"] = 556.5, ["Neon|Ride"] = 379.78, ["Neon|Fly|Ride"] = 633.48, ["Mega|Ride"] = 3556.55, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 6.2, ["Fly"] = 100.27, ["Ride"] = 28.88, ["Fly|Ride"] = 100.68, ["Neon"] = 23.13, ["Neon|Ride"] = 63.62, ["Mega"] = 157.49, ["Mega|Ride"] = 229.5, ["Mega|Fly|Ride"] = 574.82}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 49.07, ["Ride"] = 33.77, ["Neon"] = 9.07, ["Neon|Ride"] = 81.04, ["Neon|Fly|Ride"] = 543.05, ["Mega"] = 66.94, ["Mega|Fly"] = 315, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 41.1, ["Fly"] = 210, ["Ride"] = 85.3, ["Fly|Ride"] = 183.75, ["Neon"] = 131.25, ["Neon|Ride"] = 199.44, ["Neon|Fly|Ride"] = 284.75, ["Mega"] = 590.63, ["Mega|Ride"] = 654.94, ["Mega|Fly|Ride"] = 595.87}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 17.04, ["Ride"] = 14.3, ["Fly|Ride"] = 28.48, ["Neon"] = 2.1, ["Neon|Fly"] = 17.13, ["Neon|Ride"] = 15.58, ["Neon|Fly|Ride"] = 42.67, ["Mega"] = 19.06, ["Mega|Fly"] = 49.86, ["Mega|Ride"] = 34.12, ["Mega|Fly|Ride"] = 86.26}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 2.39, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 285.31, ["Mega"] = 24.9, ["Mega|Ride"] = 88.01, ["Mega|Fly|Ride"] = 175.87}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.52, ["Ride"] = 41.91, ["Neon"] = 7.2, ["Neon|Fly"] = 59.05, ["Neon|Ride"] = 99.04, ["Neon|Fly|Ride"] = 134.76, ["Mega"] = 90.72, ["Mega|Fly"] = 185.58, ["Mega|Ride"] = 135.15, ["Mega|Fly|Ride"] = 356.2}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 7.61, ["Fly"] = 77.18, ["Ride"] = 42.67, ["Fly|Ride"] = 142.93, ["Neon"] = 26.75, ["Neon|Fly"] = 91.55, ["Neon|Ride"] = 78.66, ["Neon|Fly|Ride"] = 180.43, ["Mega"] = 111.57, ["Mega|Fly"] = 264.49, ["Mega|Ride"] = 320.92, ["Mega|Fly|Ride"] = 255.84}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 21.29, ["Ride"] = 13.98, ["Fly|Ride"] = 25.6, ["Neon"] = 2.1, ["Neon|Fly"] = 24.5, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 44.01, ["Mega"] = 17.69, ["Mega|Ride"] = 52.49, ["Mega|Fly|Ride"] = 118.12}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 14.39, ["Fly"] = 131.25, ["Ride"] = 71.47, ["Neon"] = 92.8, ["Neon|Fly"] = 426.62, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 540.69, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 628.93}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2610.57, ["Fly"] = 3150, ["Ride"] = 2493.75, ["Fly|Ride"] = 2611.88, ["Neon|Fly|Ride"] = 9954.06, ["Mega|Fly|Ride"] = 42656.11}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 16.59, ["Ride"] = 15.57, ["Fly|Ride"] = 36.75, ["Neon"] = 5.25, ["Neon|Fly"] = 56.88, ["Neon|Ride"] = 24.54, ["Neon|Fly|Ride"] = 57.88, ["Mega"] = 82.41, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 113.74, ["Mega|Fly|Ride"] = 142.92}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Neon"] = 6.19, ["Mega"] = 142.92, ["Mega|Fly"] = 441, ["Mega|Ride"] = 160.13, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 14.74, ["Fly"] = 114.13, ["Ride"] = 28.25, ["Fly|Ride"] = 105, ["Neon"] = 70.88, ["Neon|Ride"] = 110.01, ["Neon|Fly|Ride"] = 212.63, ["Mega"] = 485.63, ["Mega|Ride"] = 426.59}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 28.94, ["Ride"] = 51.26, ["Neon"] = 161.44, ["Mega"] = 645.65, ["Mega|Ride"] = 608.95, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 131.25, ["Fly"] = 1403.03, ["Ride"] = 172.11, ["Fly|Ride"] = 251.99, ["Neon"] = 1312.5, ["Neon|Fly"] = 678.57, ["Neon|Ride"] = 707.48, ["Neon|Fly|Ride"] = 715.32, ["Mega"] = 6398.59, ["Mega|Fly|Ride"] = 3509.63}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 5.39, ["Ride"] = 31.49, ["Fly|Ride"] = 675.94, ["Neon"] = 26.17, ["Neon|Ride"] = 142.92, ["Neon|Fly|Ride"] = 162.08, ["Mega"] = 426.59, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 314.62, ["Mega|Fly|Ride"] = 362.6}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 36.27, ["Fly|Ride"] = 71.47, ["Neon"] = 26.23, ["Neon|Ride"] = 114.85, ["Neon|Fly|Ride"] = 284.75, ["Mega"] = 131.25, ["Mega|Ride"] = 333.38, ["Mega|Fly|Ride"] = 859.94}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 100.04, ["Ride"] = 26.17, ["Fly|Ride"] = 131.25, ["Neon"] = 5.25, ["Neon|Fly"] = 125.87, ["Neon|Ride"] = 39.62, ["Neon|Fly|Ride"] = 142.92, ["Mega"] = 84.46, ["Mega|Ride"] = 99.1, ["Mega|Fly|Ride"] = 426.59}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 12.92, ["Ride"] = 50.34, ["Neon"] = 183.45, ["Neon|Ride"] = 1212.63, ["Neon|Fly|Ride"] = 502.3, ["Mega"] = 374.07, ["Mega|Ride"] = 472.44, ["Mega|Fly|Ride"] = 597.85}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 42.67, ["Neon"] = 2.1, ["Neon|Ride"] = 47.78, ["Mega"] = 21, ["Mega|Fly"] = 120.96, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 135.19}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 85.33, ["Fly"] = 104.9, ["Ride"] = 103.64, ["Fly|Ride"] = 157.85, ["Neon"] = 366.19, ["Neon|Ride"] = 409.43, ["Neon|Fly|Ride"] = 327.55, ["Mega|Fly|Ride"] = 1871.05}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 91.82, ["Neon"] = 10.5, ["Neon|Ride"] = 71.47, ["Neon|Fly|Ride"] = 213.3, ["Mega"] = 72.58, ["Mega|Ride"] = 283.68}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 45.85, ["Fly"] = 102.4, ["Ride"] = 74.7, ["Fly|Ride"] = 177.19, ["Neon"] = 339.94, ["Neon|Ride"] = 270.03, ["Neon|Fly|Ride"] = 321.57, ["Mega"] = 2559.45, ["Mega|Fly|Ride"] = 2840.98}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 62.94, ["Ride"] = 21.35, ["Fly|Ride"] = 51.32, ["Neon"] = 3.94, ["Neon|Fly"] = 87.44, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 41.87, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 203.24}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 3.03, ["Neon"] = 9.19, ["Neon|Ride"] = 98.44, ["Mega"] = 90.76, ["Mega|Ride"] = 152.36, ["Mega|Fly|Ride"] = 485.25}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 5.16, ["Fly"] = 77.44, ["Ride"] = 32.8, ["Neon"] = 34.12, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 185.58, ["Mega"] = 262.5, ["Mega|Ride"] = 288.74, ["Mega|Fly|Ride"] = 569.49}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 371.34, ["Ride"] = 378.12, ["Fly|Ride"] = 538.94, ["Neon"] = 1050, ["Neon|Ride"] = 964.66, ["Neon|Fly|Ride"] = 1144.5, ["Mega|Ride"] = 4265.73, ["Mega|Fly|Ride"] = 4289.25}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 23.68, ["Fly"] = 85.33, ["Ride"] = 50.06, ["Fly|Ride"] = 102.25, ["Neon"] = 196.88, ["Neon|Ride"] = 171.28, ["Neon|Fly|Ride"] = 404.19, ["Mega"] = 1420.5, ["Mega|Fly|Ride"] = 1995}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 49.88, ["Ride"] = 18.15, ["Fly|Ride"] = 85.33, ["Neon"] = 11.12, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 98.34, ["Mega"] = 72.19, ["Mega|Ride"] = 162.08, ["Mega|Fly|Ride"] = 270.88}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 13.13, ["Fly"] = 74.81, ["Ride"] = 44.63, ["Fly|Ride"] = 170.63, ["Neon"] = 65.44, ["Neon|Fly"] = 137.82, ["Neon|Ride"] = 112.07, ["Neon|Fly|Ride"] = 182.6, ["Mega"] = 326.82, ["Mega|Fly"] = 995.4, ["Mega|Ride"] = 345.84, ["Mega|Fly|Ride"] = 452.75}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 7.32, ["Ride"] = 24.94, ["Fly|Ride"] = 196.88, ["Neon"] = 143.99, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 274.56, ["Mega"] = 314.62, ["Mega|Ride"] = 284.75, ["Mega|Fly|Ride"] = 566.29}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 2.1, ["Neon"] = 19.58, ["Neon|Fly"] = 71.47, ["Mega"] = 79.26, ["Mega|Ride"] = 140.78, ["Mega|Fly|Ride"] = 261.29}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 20.96, ["Fly|Ride"] = 60.52, ["Neon"] = 42.94, ["Neon|Ride"] = 45.47, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 129.84, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 96.69, ["Ride"] = 129.94, ["Fly|Ride"] = 228.25, ["Neon"] = 393.75, ["Neon|Ride"] = 523.67, ["Neon|Fly|Ride"] = 568.5, ["Mega"] = 2887.5, ["Mega|Fly|Ride"] = 3171.58}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 21, ["Ride"] = 46.78, ["Fly|Ride"] = 91.88, ["Neon"] = 143.16, ["Neon|Ride"] = 221.83, ["Neon|Fly|Ride"] = 284.47, ["Mega"] = 426.59, ["Mega|Fly|Ride"] = 703.86}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 1995, ["Fly"] = 2030.44, ["Ride"] = 2060.63, ["Fly|Ride"] = 2094.75, ["Neon"] = 11376.41, ["Neon|Fly|Ride"] = 6424.69, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.81, ["Fly"] = 65625, ["Ride"] = 24.54, ["Fly|Ride"] = 196.87, ["Neon"] = 18.4, ["Mega"] = 109.83, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 171.86, ["Mega|Fly|Ride"] = 468.07}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 7.65, ["Ride"] = 53.34, ["Fly|Ride"] = 114.19, ["Neon"] = 36.6, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 80.09, ["Mega"] = 157.5, ["Mega|Ride"] = 318.72, ["Mega|Fly|Ride"] = 1422.64}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 865.98, ["Fly"] = 1096.66, ["Ride"] = 892.5, ["Fly|Ride"] = 984.38, ["Neon"] = 2778.57, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2485.86, ["Mega"] = 12513.48, ["Mega|Fly|Ride"] = 11624.09}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 23.63, ["Ride"] = 52.49, ["Fly|Ride"] = 173.35, ["Neon"] = 143.17, ["Neon|Ride"] = 213.3, ["Neon|Fly|Ride"] = 382.2, ["Mega"] = 840, ["Mega|Ride"] = 692.49, ["Mega|Fly|Ride"] = 877.68}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.49, ["Ride"] = 23.63, ["Fly|Ride"] = 128.15, ["Neon"] = 12.1, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 157.5, ["Mega|Ride"] = 270.88, ["Mega|Fly|Ride"] = 262.48}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.41, ["Ride"] = 142.93, ["Neon"] = 2.94, ["Neon|Ride"] = 48.82, ["Neon|Fly|Ride"] = 93.85, ["Mega"] = 19.69, ["Mega|Ride"] = 78.91}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 89.65, ["Ride"] = 114.13, ["Fly|Ride"] = 170.63, ["Neon"] = 426.62, ["Neon|Ride"] = 604.75, ["Neon|Fly|Ride"] = 630, ["Mega"] = 2418.93, ["Mega|Fly|Ride"] = 2132.88}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 3.81, ["Fly|Ride"] = 73.7, ["Neon"] = 12.77, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 52.02, ["Neon|Fly|Ride"] = 162.08, ["Mega"] = 118.57, ["Mega|Ride"] = 122.03, ["Mega|Fly|Ride"] = 263.82}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 76.53, ["Ride"] = 102.38, ["Fly|Ride"] = 91.88, ["Neon"] = 459.37, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 523.63, ["Mega|Ride"] = 1422.64, ["Mega|Fly|Ride"] = 1810.81}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 4.97, ["Fly"] = 105, ["Fly|Ride"] = 127.99, ["Neon"] = 26.24, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 193.52, ["Mega|Ride"] = 284.75, ["Mega|Fly|Ride"] = 407.39}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 262.49, ["Fly"] = 354.38, ["Ride"] = 285.87, ["Fly|Ride"] = 334.69, ["Neon"] = 1137.32, ["Neon|Ride"] = 1064.63, ["Neon|Fly|Ride"] = 859.69, ["Mega|Fly|Ride"] = 4337.18}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 2.1, ["Fly"] = 87.94, ["Ride"] = 19.66, ["Fly|Ride"] = 48.44, ["Neon"] = 33.45, ["Neon|Ride"] = 57.72, ["Neon|Fly|Ride"] = 100.93, ["Mega"] = 401.56, ["Mega|Ride"] = 318.93}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 19.37, ["Ride"] = 16.45, ["Fly|Ride"] = 41.89, ["Neon"] = 3.59, ["Neon|Fly"] = 31.4, ["Neon|Ride"] = 20.58, ["Neon|Fly|Ride"] = 46.09, ["Mega"] = 40.68, ["Mega|Ride"] = 64.97, ["Mega|Fly|Ride"] = 124.42}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1247.97, ["Ride"] = 1050, ["Fly|Ride"] = 1254.19, ["Neon|Ride"] = 7821.2, ["Neon|Fly|Ride"] = 6611.89, ["Mega"] = 23705.46, ["Mega|Fly|Ride"] = 28487.82}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 6.03, ["Fly"] = 994.12, ["Ride"] = 72.19, ["Neon"] = 65.01, ["Neon|Ride"] = 134.38, ["Mega"] = 279.54, ["Mega|Ride"] = 767.85, ["Mega|Fly|Ride"] = 564.08}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 3.62, ["Fly"] = 51.2, ["Ride"] = 40.72, ["Fly|Ride"] = 90.76, ["Neon"] = 19.38, ["Neon|Fly"] = 242.01, ["Neon|Ride"] = 52.65, ["Neon|Fly|Ride"] = 170.64, ["Mega"] = 175.88, ["Mega|Ride"] = 203.27, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 27.46, ["Fly"] = 47.38, ["Ride"] = 32.71, ["Fly|Ride"] = 44.41, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 197.64, ["Mega|Ride"] = 1129.65, ["Mega|Fly|Ride"] = 799.32}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 12.5, ["Fly"] = 85.33, ["Ride"] = 24.86, ["Fly|Ride"] = 85.32, ["Neon"] = 69.45, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 179.45, ["Mega"] = 367.4, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 429.26}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 38.98, ["Ride"] = 96.81, ["Fly|Ride"] = 415.96, ["Neon"] = 185.13, ["Neon|Ride"] = 378, ["Neon|Fly|Ride"] = 533.23, ["Mega"] = 1050, ["Mega|Ride"] = 711.33, ["Mega|Fly|Ride"] = 695.77}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Fly|Ride"] = 193.6, ["Neon"] = 2.1, ["Neon|Fly"] = 57.61, ["Neon|Ride"] = 112.2, ["Neon|Fly|Ride"] = 105.07, ["Mega"] = 18.27, ["Mega|Ride"] = 83.45, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 70.62, ["Fly"] = 126, ["Ride"] = 86, ["Fly|Ride"] = 153.37, ["Neon"] = 578.82, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 469.88, ["Mega"] = 3412.59, ["Mega|Ride"] = 1755.35, ["Mega|Fly|Ride"] = 1629.85}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 3.9, ["Fly"] = 107.62, ["Ride"] = 23.37, ["Fly|Ride"] = 70.88, ["Neon"] = 85.8, ["Neon|Ride"] = 113.06, ["Mega"] = 773.06, ["Mega|Ride"] = 403.98}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 28.81, ["Ride"] = 16, ["Fly|Ride"] = 37.77, ["Neon"] = 17.45, ["Neon|Fly"] = 81.09, ["Neon|Ride"] = 67.19, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 275.07, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.1, ["Ride"] = 126, ["Neon"] = 16.01, ["Neon|Fly"] = 140.79, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 202.64, ["Mega"] = 381.8, ["Mega|Fly|Ride"] = 483.79}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 65.63, ["Ride"] = 74.67, ["Fly|Ride"] = 262.5, ["Neon"] = 294, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 725.19, ["Mega|Ride"] = 1465.29, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 7.9, ["Fly|Ride"] = 426.62, ["Neon"] = 16.68, ["Neon|Ride"] = 79.99, ["Mega"] = 126.88, ["Mega|Ride"] = 106.65, ["Mega|Fly|Ride"] = 322.94}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 34.15, ["Neon"] = 2.1, ["Neon|Ride"] = 52.5, ["Mega"] = 13.02, ["Mega|Ride"] = 190.39, ["Mega|Fly|Ride"] = 533.23}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.94, ["Ride"] = 35.28, ["Fly|Ride"] = 63.24, ["Neon"] = 2.1, ["Neon|Ride"] = 28.17, ["Neon|Fly|Ride"] = 71.47, ["Mega"] = 11.71, ["Mega|Ride"] = 56.39, ["Mega|Fly|Ride"] = 142.95}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 15.86, ["Fly|Ride"] = 49.43, ["Neon"] = 7.28, ["Neon|Ride"] = 28.58, ["Neon|Fly|Ride"] = 85.88, ["Mega"] = 61.69, ["Mega|Ride"] = 78.74, ["Mega|Fly|Ride"] = 183.74}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 112.53, ["Neon"] = 24.93, ["Mega"] = 118.09, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 38.05, ["Ride"] = 15.63, ["Fly|Ride"] = 34.13, ["Neon"] = 15.65, ["Neon|Fly"] = 213.31, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 150.94, ["Mega|Fly|Ride"] = 426.59}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 56.6, ["Ride"] = 91.62, ["Fly|Ride"] = 270.92, ["Neon"] = 210, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 1066.45, ["Mega"] = 694.32, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1122.93}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 15.82, ["Ride"] = 14.39, ["Fly|Ride"] = 36.42, ["Neon"] = 2.1, ["Neon|Fly"] = 25.6, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 57.66, ["Mega"] = 19.08, ["Mega|Ride"] = 25.74, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 6.57, ["Fly"] = 52.68, ["Ride"] = 23.5, ["Fly|Ride"] = 63.95, ["Neon"] = 26.25, ["Neon|Fly"] = 87.28, ["Neon|Ride"] = 61.06, ["Neon|Fly|Ride"] = 124.92, ["Mega"] = 381.57, ["Mega|Ride"] = 224.85, ["Mega|Fly|Ride"] = 314.52}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 13.44, ["Fly"] = 34.13, ["Ride"] = 30.19, ["Fly|Ride"] = 84.93, ["Neon"] = 127.99, ["Neon|Ride"] = 137.45, ["Neon|Fly|Ride"] = 182.44, ["Mega"] = 787.5, ["Mega|Ride"] = 767.85, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.53, ["Fly"] = 196.88, ["Neon"] = 52.5, ["Neon|Ride"] = 71.76, ["Mega"] = 366.19, ["Mega|Ride"] = 448.28, ["Mega|Fly|Ride"] = 426.59}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.07, ["Fly|Ride"] = 45.99, ["Neon"] = 4.6, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 20.89, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 40.51, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 2.96, ["Fly"] = 77.83, ["Ride"] = 37.97, ["Neon"] = 24.15, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 205.69, ["Mega"] = 118.13, ["Mega|Fly"] = 735, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 322.94}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 917.43, ["Fly"] = 1403.56, ["Ride"] = 984.37, ["Fly|Ride"] = 1023.74, ["Neon"] = 2986.23, ["Neon|Ride"] = 2744.43, ["Neon|Fly|Ride"] = 2362.49, ["Mega|Fly|Ride"] = 7087.5}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 111.13, ["Ride"] = 142.93, ["Fly|Ride"] = 517.88, ["Neon"] = 639.92, ["Neon|Ride"] = 628.69, ["Neon|Fly|Ride"] = 820.31, ["Mega"] = 3198.23, ["Mega|Ride"] = 2844.18, ["Mega|Fly|Ride"] = 2388.75}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly"] = 57.61, ["Ride"] = 39.38, ["Neon"] = 6.14, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 207.97, ["Mega"] = 118.39, ["Mega|Fly|Ride"] = 1137.9}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 68.16, ["Ride"] = 117.41, ["Fly|Ride"] = 196.88, ["Neon"] = 392.43, ["Neon|Fly"] = 446.25, ["Neon|Ride"] = 406.86, ["Neon|Fly|Ride"] = 636.57, ["Mega"] = 1964.41, ["Mega|Ride"] = 1796.82, ["Mega|Fly|Ride"] = 1640.86}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 3.56, ["Ride"] = 21.35, ["Fly|Ride"] = 92.8, ["Neon"] = 17.33, ["Neon|Fly"] = 56.86, ["Neon|Ride"] = 50.47, ["Neon|Fly|Ride"] = 284.75, ["Mega"] = 284.75, ["Mega|Ride"] = 352.72, ["Mega|Fly|Ride"] = 412.72}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 228.96, ["Fly"] = 334.9, ["Ride"] = 271.09, ["Fly|Ride"] = 328.13, ["Neon|Ride"] = 1365.04, ["Neon|Fly|Ride"] = 1296.64, ["Mega|Fly|Ride"] = 4692.31}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 77.18, ["Ride"] = 41.61, ["Fly|Ride"] = 219.68, ["Neon"] = 31.48, ["Neon|Fly"] = 36.27, ["Neon|Ride"] = 54.37, ["Mega"] = 393.75, ["Mega|Fly"] = 332.74, ["Mega|Ride"] = 645.87}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Fly"] = 28.81, ["Neon"] = 42.33, ["Mega"] = 341.28, ["Mega|Ride"] = 365.79}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 23.55, ["Fly|Ride"] = 131.25, ["Neon"] = 110.49, ["Neon|Ride"] = 124.69, ["Mega"] = 653.13, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.73, ["Neon"] = 25.25, ["Neon|Ride"] = 196.87, ["Mega"] = 241.9, ["Mega|Ride"] = 253.31, ["Mega|Fly|Ride"] = 426.59}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 14.44, ["Fly|Ride"] = 21.35, ["Neon"] = 2.63, ["Neon|Fly"] = 28.41, ["Neon|Ride"] = 21.35, ["Neon|Fly|Ride"] = 34.99, ["Mega"] = 24.21, ["Mega|Ride"] = 43.55, ["Mega|Fly|Ride"] = 100.41}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 5972.44, ["Ride"] = 5124, ["Fly|Ride"] = 4971.75, ["Neon"] = 31995.12, ["Neon|Fly|Ride"] = 19293.75, ["Mega|Fly|Ride"] = 133303.64}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 8.15, ["Fly"] = 85.33, ["Ride"] = 41.57, ["Neon"] = 53.43, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 109.86, ["Mega"] = 192.94, ["Mega|Ride"] = 215.25, ["Mega|Fly|Ride"] = 426.59}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.7, ["Ride"] = 16.7, ["Fly|Ride"] = 35.42, ["Neon"] = 14.16, ["Neon|Fly"] = 45.91, ["Neon|Ride"] = 34.18, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 131.25, ["Mega|Ride"] = 176.06, ["Mega|Fly|Ride"] = 242.18}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 446.24, ["Fly"] = 547.77, ["Ride"] = 519.69, ["Fly|Ride"] = 522.38, ["Neon"] = 1612.22, ["Neon|Ride"] = 1292.82, ["Neon|Fly|Ride"] = 1481.12, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 5.64, ["Ride"] = 32.95, ["Neon"] = 19.38, ["Mega"] = 140.95, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.46, ["Fly"] = 4266.04, ["Ride"] = 36.74, ["Neon"] = 23.63, ["Neon|Fly"] = 118.39, ["Neon|Ride"] = 65.33, ["Mega"] = 1159.23, ["Mega|Ride"] = 401.63, ["Mega|Fly|Ride"] = 419.35}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 20.36, ["Neon"] = 3.9, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 27.88, ["Neon|Fly|Ride"] = 91.74, ["Mega"] = 39.37, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 284.75}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 656.23, ["Ride"] = 656.25, ["Fly|Ride"] = 686.94, ["Neon|Ride"] = 2836.72, ["Neon|Fly|Ride"] = 2480.62, ["Mega|Fly|Ride"] = 9242.76}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 4.72, ["Fly"] = 300.08, ["Ride"] = 53.51, ["Fly|Ride"] = 426.62, ["Neon"] = 30.31, ["Neon|Ride"] = 65.35, ["Neon|Fly|Ride"] = 290.28, ["Mega"] = 183.64, ["Mega|Ride"] = 229.67, ["Mega|Fly|Ride"] = 356.41}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 2.1, ["Fly"] = 236.15, ["Ride"] = 26.25, ["Neon"] = 23.7, ["Neon|Ride"] = 52.41, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 353.96, ["Mega|Fly"] = 806.73, ["Mega|Ride"] = 214.18, ["Mega|Fly|Ride"] = 412.72}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.12, ["Ride"] = 16.7, ["Fly|Ride"] = 59.03, ["Neon"] = 16.09, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 31.48, ["Neon|Fly|Ride"] = 81.37, ["Mega"] = 284.75, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 227.12}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 14.23, ["Ride"] = 34.12, ["Fly|Ride"] = 50.16, ["Neon"] = 117.58, ["Neon|Ride"] = 71.47, ["Neon|Fly|Ride"] = 319.95, ["Mega"] = 852.09, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 1422.64}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 42.88, ["Fly|Ride"] = 85.33, ["Neon"] = 3.41, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 38.07, ["Mega|Ride"] = 103.95, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 499.11, ["Ride"] = 538.13, ["Fly|Ride"] = 807.06, ["Neon"] = 2589.57, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Ride"] = 9433.81, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Fly"] = 106.66, ["Ride"] = 79.97, ["Neon"] = 17.07, ["Neon|Ride"] = 89.59, ["Neon|Fly|Ride"] = 483.79, ["Mega"] = 239.49, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 270.8}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 33.39, ["Neon"] = 5.24, ["Neon|Fly"] = 106.66, ["Neon|Ride"] = 42.67, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 89.52, ["Mega|Fly|Ride"] = 362.6}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 49.44, ["Neon"] = 3.85, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 142.92, ["Mega"] = 41.34, ["Mega|Fly"] = 157.84, ["Mega|Ride"] = 104.2, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 28.54, ["Neon"] = 37.93, ["Mega"] = 213.3, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 25.24, ["Fly"] = 64.32, ["Ride"] = 50.3, ["Fly|Ride"] = 101.35, ["Neon"] = 124.69, ["Neon|Fly"] = 142.93, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 281.48, ["Mega"] = 668.67, ["Mega|Ride"] = 519.74, ["Mega|Fly|Ride"] = 556.49}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 15.22, ["Ride"] = 48.39, ["Fly|Ride"] = 129.01, ["Neon"] = 82.1, ["Neon|Ride"] = 142.92, ["Neon|Fly|Ride"] = 284.75, ["Mega"] = 381.94, ["Mega|Ride"] = 554.55, ["Mega|Fly|Ride"] = 560.81}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 4.11, ["Fly"] = 32.96, ["Ride"] = 18.44, ["Fly|Ride"] = 33.49, ["Neon"] = 28.65, ["Neon|Ride"] = 36.73, ["Neon|Fly|Ride"] = 88.53, ["Mega"] = 404.19, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 253.82}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 11.8, ["Ride"] = 52.5, ["Fly|Ride"] = 123.73, ["Neon"] = 42.67, ["Neon|Ride"] = 140.78, ["Mega|Ride"] = 410.82}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 129.94, ["Ride"] = 26.16, ["Fly|Ride"] = 87.05, ["Neon"] = 10.5, ["Neon|Ride"] = 41.58, ["Neon|Fly|Ride"] = 114.12, ["Mega"] = 73.43, ["Mega|Ride"] = 115.49, ["Mega|Fly|Ride"] = 241.9}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 18.38, ["Fly"] = 27.75, ["Ride"] = 26.24, ["Fly|Ride"] = 63, ["Neon"] = 10665.04, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 192.05, ["Mega"] = 787.5, ["Mega|Fly|Ride"] = 829.5}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 32.13, ["Fly"] = 874.13, ["Neon"] = 133.77, ["Neon|Ride"] = 131.25, ["Mega"] = 328.12, ["Mega|Ride"] = 590.63}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 48.55, ["Fly"] = 115.75, ["Ride"] = 85.19, ["Fly|Ride"] = 170.65, ["Neon"] = 315, ["Neon|Ride"] = 347.82, ["Neon|Fly|Ride"] = 423.21, ["Mega|Ride"] = 1710.19, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 33.13, ["Fly"] = 85.33, ["Ride"] = 76.74, ["Fly|Ride"] = 207.99, ["Neon"] = 144.36, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 405.26, ["Mega"] = 584.06, ["Mega|Ride"] = 639.01, ["Mega|Fly|Ride"] = 628.21}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 18.1, ["Ride"] = 64.32, ["Neon"] = 114.27, ["Neon|Ride"] = 428.3, ["Mega"] = 1049.99, ["Mega|Ride"] = 711.33}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 15.39, ["Fly"] = 426.62, ["Ride"] = 47.81, ["Fly|Ride"] = 284.78, ["Neon"] = 132.2, ["Neon|Fly"] = 420, ["Neon|Ride"] = 142.92, ["Neon|Fly|Ride"] = 274.56, ["Mega"] = 464.37, ["Mega|Ride"] = 558.79, ["Mega|Fly|Ride"] = 640.4}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.95, ["Ride"] = 15.44, ["Fly|Ride"] = 32.74, ["Neon"] = 3.92, ["Neon|Fly"] = 28.31, ["Neon|Ride"] = 29.03, ["Neon|Fly|Ride"] = 48.4, ["Mega"] = 41.14, ["Mega|Fly"] = 335.93, ["Mega|Ride"] = 57.7, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1011.43}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 42.56, ["Ride"] = 96.14, ["Fly|Ride"] = 315, ["Neon"] = 339.95, ["Neon|Ride"] = 365.54, ["Neon|Fly|Ride"] = 554.55, ["Mega"] = 1173.09, ["Mega|Ride"] = 1512.21, ["Mega|Fly|Ride"] = 1312.49}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 79.74, ["Neon"] = 3.82, ["Neon|Ride"] = 43.19, ["Neon|Fly|Ride"] = 298.05, ["Mega"] = 20.9, ["Mega|Ride"] = 84.94, ["Mega|Fly|Ride"] = 198.37}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 25.57, ["Ride"] = 114.13, ["Fly|Ride"] = 162.16, ["Neon"] = 130.13, ["Neon|Ride"] = 133.95, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 524.99, ["Mega|Ride"] = 806.73, ["Mega|Fly|Ride"] = 686.82}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.36, ["Mega"] = 23.36}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 2.77, ["Neon|Ride"] = 39.38, ["Mega"] = 21.86, ["Mega|Ride"] = 152.41}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 103.3, ["Fly"] = 223.13, ["Ride"] = 141.37, ["Fly|Ride"] = 323.08, ["Neon"] = 612.19, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 656.25, ["Mega|Ride"] = 6652.06, ["Mega|Fly|Ride"] = 2001.45}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 21.31, ["Fly|Ride"] = 96.73, ["Neon"] = 6.28, ["Neon|Ride"] = 25.12, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 90.17, ["Mega|Ride"] = 115.63, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 71.47, ["Fly|Ride"] = 50.42, ["Neon"] = 5.61, ["Neon|Ride"] = 25.6, ["Neon|Fly|Ride"] = 142.92, ["Mega"] = 35.43, ["Mega|Ride"] = 127.99, ["Mega|Fly|Ride"] = 283.03}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.68, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 210, ["Mega"] = 76.13, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 82.68, ["Neon"] = 6.26, ["Neon|Ride"] = 155.92, ["Mega"] = 68.27, ["Mega|Ride"] = 213.3}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 41.9, ["Ride"] = 105, ["Fly|Ride"] = 456.48, ["Neon"] = 428.35, ["Neon|Ride"] = 489.13, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2062.49, ["Mega|Ride"] = 1599.66, ["Mega|Fly|Ride"] = 1564.47}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 2.62, ["Ride"] = 67.2, ["Neon"] = 39.37, ["Neon|Ride"] = 81.04, ["Mega"] = 498.04, ["Mega|Ride"] = 956.1}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 1.79}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 354.38, ["Ride"] = 324.84, ["Fly|Ride"] = 779.22, ["Neon"] = 1151.9, ["Neon|Ride"] = 1422.64, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4087.99}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 1.79}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 87.94}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 49.85}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 15.22}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 15.73}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 129.12}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 39.38}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 14}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 7.88}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 262.48}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 26.17}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 1.79}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 23.59}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 7.62}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 3.47}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 577.49}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 5.24}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 5.35}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 7.6}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 9.48}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 12.45}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 564.26}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.63}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 589.89}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 12.99}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1084.78}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 3.31}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 59.45}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 8.9}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.63}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 33}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.37}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 15.11}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 34.11}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 46.69}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 18.59}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 11.17}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 18.04}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 5.92}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 14.23}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.15}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 3.74}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 18.96}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 140.07}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 3.61}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 2133.27}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 29.66}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 307.92}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 7.74}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 6.33}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 9.17}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 6.45}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 49.65}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 197.13}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 6.45}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 6.38}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 1181.25}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 30.35}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 3.87}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 30.09}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 13.38}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 111.57}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 36.66}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 8.02}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 3.83}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 21}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 10.5}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 3.89}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 51.77}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 89.06}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 223.13}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 6.35}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 318.05}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.93}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 65.19}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 20.98}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 1.79}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22988.75}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 323.21}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 78.75}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 46.66}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 88.89}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 32.44}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 21.18}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 35.17}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 81.81}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 81.29}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 92.81}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 56.81}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 158.47}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 54.57}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 45.94}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 7.66}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 6.13}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 7.6}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 32.43}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 118.13}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.16}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 5.2}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 2.19}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 13.13}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 270.13}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 997.5}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 15.6}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 583.68}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 15.48}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.63}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.63}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 231}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 1.79}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 24.94}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 115.5}},
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
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.94}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 4.45}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 28.77}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.19}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 1.79}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.41}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 8.7}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 50.3}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 284.36}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 39.38}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 4.86}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 323.07}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 10.9}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 6.46}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 6.2}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 27.46}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 15.94}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 6.62}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 8.6}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 6.81}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 12.71}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 35.43}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 18.31}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 4.65}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 4.97}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.63}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 6.56}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 6.02}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 1.79}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 5.71}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 6.45}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 3.71}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.62}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.82}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 1.79}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7626.74}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.62}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 22.13}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3.94}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 8.49}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 6.02}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.16}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 23}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 8.97}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 2.76}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.47}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 5.04}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 1.79}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 1.79}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 32.71}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 11.82}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.84}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 5.25}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.82}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 4.86}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4266.52}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 8.45}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 1.79}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 26.17}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 6.42}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 1.79}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.29}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 66.05}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.62}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 2.78}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 99.69}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 1.79}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 1.79}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 1.79}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 14.89}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.66}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 3.44}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 2.1}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 7.9}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 17.06}},
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
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.73}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.67}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.37}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.25}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.41}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 3.82}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 28.86}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 9.58}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 118.13}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.67}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 62.1}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 3.67}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 5.25}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1164.09}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 32.1}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 3.93}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 3.92}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 1.79}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 20.79}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 27.19}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 14.44}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 6.57}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 11.45}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 6.13}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 15.65}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 13.13}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.63}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 3.94}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 6.42}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.89}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 11.82}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 10.4}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 21.63}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.9}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 7.77}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 3.19}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 19.69}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 52.41}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.63}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 3.86}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.52}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 4.79}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 34.55}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 85.32}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 7.1}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 5.03}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 3.82}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 70.24}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 6.48}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 33.95}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.51}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 4.71}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 4.72}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 3.92}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 1.73}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 6.41}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 74.43}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.33}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 152.04}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 7.66}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1493.29}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 4.43}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 183.75}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 3.97}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 7.66}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 51.98}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 6.28}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 5.18}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.46}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 67.57}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 19.69}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 9.35}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.5}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 6.57}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 79.09}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 3.83}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 85.35}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 3.54}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.13}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 26.17}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 144.36}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 3.84}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 6.33}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 78.42}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.3}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 5.04}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 1.79}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 57.75}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 53.45}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 53.6}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 181.92}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.67}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 56.57}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 122.42}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.94}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 3.49}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 9.19}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 31.32}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 68.25}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.94}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 61.68}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.84}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 4.85}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 85.32}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 21}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 63.53}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 33.94}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 6.15}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.15}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 28.88}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 45.29}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 6.08}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.52}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 20.68}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.93}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 13.13}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 65.01}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 1.79}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 33.39}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 83.88}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 2081.1}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 11.67}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 8.6}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 20.37}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 711.45}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 18.33}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 8.76}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 11.55}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 15.63}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 2.88}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 292.85}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 52.4}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 53.55}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 2.52}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 77.31}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 163.66}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 75.93}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 918.75}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 105}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 6.04}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2361.19}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 746.66}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 2.52}},
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