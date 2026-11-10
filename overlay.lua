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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1043.97, ["Ride"] = 938.44, ["Fly|Ride"] = 1547.6, ["Neon"] = 6694.42, ["Neon|Fly|Ride"] = 3921.75, ["Mega|Fly|Ride"] = 25143.57}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 379.84, ["Fly"] = 544.79, ["Ride"] = 396.38, ["Fly|Ride"] = 471.19, ["Neon|Ride"] = 2215.38, ["Neon|Fly|Ride"] = 2072.44, ["Mega|Fly|Ride"] = 8258.04}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4725, ["Ride"] = 4935, ["Fly|Ride"] = 4324.69, ["Neon"] = 26022.09, ["Neon|Fly|Ride"] = 21676.58, ["Mega|Fly|Ride"] = 66813.26}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 110.76, ["Ride"] = 159.31, ["Fly|Ride"] = 253.29, ["Neon"] = 837.63, ["Neon|Ride"] = 821.63, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 3797.78, ["Mega|Fly|Ride"] = 2978.43}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 624.62, ["Fly"] = 661.54, ["Ride"] = 526.57, ["Fly|Ride"] = 538.13, ["Neon|Ride"] = 1704.94, ["Neon|Fly|Ride"] = 1527.75, ["Mega|Fly|Ride"] = 6300}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 9.17, ["Ride"] = 32.3, ["Fly|Ride"] = 141.38, ["Neon"] = 56.97, ["Neon|Fly"] = 112.9, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 281.69, ["Mega"] = 275.13, ["Mega|Ride"] = 471.72, ["Mega|Fly|Ride"] = 416.72}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 6.56, ["Fly"] = 28.87, ["Ride"] = 25.96, ["Fly|Ride"] = 61.67, ["Neon"] = 22.32, ["Neon|Fly"] = 107.47, ["Neon|Ride"] = 54.87, ["Neon|Fly|Ride"] = 94.76, ["Mega"] = 182.74, ["Mega|Fly"] = 277.34, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 239.08}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 124.5, ["Fly"] = 656.25, ["Ride"] = 160.77, ["Fly|Ride"] = 178.5, ["Neon"] = 488.25, ["Neon|Ride"] = 527.48, ["Neon|Fly|Ride"] = 632.98, ["Mega"] = 1912.58, ["Mega|Fly|Ride"] = 2040.26}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 31.49, ["Fly"] = 142.45, ["Ride"] = 56.43, ["Fly|Ride"] = 112.4, ["Neon"] = 223.13, ["Neon|Ride"] = 224.44, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 2100, ["Mega|Ride"] = 2730, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 20.06, ["Fly"] = 26.25, ["Ride"] = 28.13, ["Fly|Ride"] = 64.58, ["Neon"] = 139.27, ["Neon|Ride"] = 146.65, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 758.51, ["Mega|Fly|Ride"] = 797.32}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 39.38, ["Fly"] = 287, ["Ride"] = 73.76, ["Fly|Ride"] = 127.32, ["Neon"] = 278.52, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 322.76, ["Mega|Ride"] = 1407.3, ["Mega|Fly|Ride"] = 1434.45}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 87.94}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 375.27, ["Fly"] = 387.19, ["Ride"] = 392.43, ["Fly|Ride"] = 525, ["Neon|Ride"] = 1687.91, ["Neon|Fly|Ride"] = 1368.38, ["Mega|Fly|Ride"] = 8439.5}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 118.13, ["Fly"] = 131.25, ["Ride"] = 105, ["Fly|Ride"] = 156.35, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 643.13, ["Mega|Fly|Ride"] = 2613.19}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.1, ["Fly"] = 117.12, ["Ride"] = 24.04, ["Fly|Ride"] = 211.01, ["Neon"] = 24.88, ["Neon|Ride"] = 59.07, ["Mega"] = 118.13, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 383.25}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 141.37, ["Fly"] = 187.81, ["Ride"] = 118.12, ["Fly|Ride"] = 183.19, ["Neon"] = 703.65, ["Neon|Ride"] = 632.98, ["Neon|Fly|Ride"] = 584.07, ["Mega|Fly|Ride"] = 1903}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.5, ["Fly"] = 25.34, ["Ride"] = 19.48, ["Fly|Ride"] = 40.11, ["Neon"] = 24.28, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 196.88, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 305.82}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 65.55, ["Fly"] = 262.5, ["Ride"] = 98.43, ["Fly|Ride"] = 239.48, ["Neon"] = 216.57, ["Neon|Ride"] = 229.68, ["Neon|Fly|Ride"] = 408.19, ["Mega"] = 1404.14, ["Mega|Ride"] = 915.5, ["Mega|Fly|Ride"] = 863.63}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 40.58}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 84, ["Ride"] = 350.44, ["Fly|Ride"] = 246.1, ["Neon"] = 830.82, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 1582.42}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 12.92, ["Fly"] = 393.75, ["Ride"] = 26.17, ["Fly|Ride"] = 99.18, ["Neon"] = 132.95, ["Neon|Ride"] = 337.11, ["Neon|Fly|Ride"] = 183.58, ["Mega"] = 2749.34, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 1687.91}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 34.36, ["Fly"] = 99.2, ["Ride"] = 43.31, ["Fly|Ride"] = 97.49, ["Neon"] = 204.67, ["Neon|Fly"] = 314.39, ["Neon|Ride"] = 179.37, ["Neon|Fly|Ride"] = 262.29, ["Mega"] = 1681.32, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 42.23, ["Fly"] = 105, ["Ride"] = 155.76, ["Fly|Ride"] = 139.27, ["Neon"] = 236.25, ["Neon|Fly"] = 396.9, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 315.45, ["Mega"] = 1243.78, ["Mega|Ride"] = 1261.72, ["Mega|Fly|Ride"] = 1265.94}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 40.27, ["Fly"] = 64.6, ["Ride"] = 56.98, ["Fly|Ride"] = 65.63, ["Neon"] = 181.47, ["Neon|Ride"] = 211.01, ["Neon|Fly|Ride"] = 261.64, ["Mega"] = 1207.92, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 65.63, ["Fly"] = 587.65, ["Ride"] = 70.88, ["Fly|Ride"] = 118.13, ["Neon"] = 280.01, ["Neon|Ride"] = 309.68, ["Neon|Fly|Ride"] = 217.88, ["Mega|Ride"] = 1116.48, ["Mega|Fly|Ride"] = 824.97}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 5.93, ["Fly"] = 21, ["Ride"] = 17.05, ["Fly|Ride"] = 39.31, ["Neon"] = 31.49, ["Neon|Fly"] = 59.07, ["Neon|Ride"] = 36.74, ["Neon|Fly|Ride"] = 101.22, ["Mega"] = 131.25, ["Mega|Fly"] = 210, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 238.92}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 341.25, ["Ride"] = 337.59, ["Fly|Ride"] = 362.25, ["Neon"] = 1475.25, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1618.29, ["Mega"] = 10549.35, ["Mega|Fly|Ride"] = 6611.29}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 15.74, ["Ride"] = 28.85, ["Fly|Ride"] = 136.49, ["Neon"] = 236.25, ["Neon|Ride"] = 160.21, ["Mega"] = 830.25, ["Mega|Ride"] = 717.23, ["Mega|Fly|Ride"] = 830.25}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 3.71, ["Fly"] = 38.66, ["Ride"] = 20.89, ["Fly|Ride"] = 43.3, ["Neon"] = 44.63, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 107, ["Mega|Ride"] = 619.5, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 93.3, ["Fly"] = 127.98, ["Ride"] = 104.47, ["Fly|Ride"] = 157.5, ["Neon"] = 422, ["Neon|Ride"] = 480.38, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 1829.27, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 1906.28}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 12.68, ["Ride"] = 26.25, ["Fly|Ride"] = 115.5, ["Neon"] = 97.07, ["Neon|Ride"] = 112.9, ["Neon|Fly|Ride"] = 158.82, ["Mega"] = 422}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 183.74, ["Fly"] = 356.64, ["Ride"] = 223.79, ["Fly|Ride"] = 269.07, ["Neon"] = 780.67, ["Neon|Ride"] = 822.86, ["Neon|Fly|Ride"] = 773.07, ["Mega"] = 6329.63, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2859.15}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 30.18}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.29, ["Fly"] = 35.88, ["Ride"] = 15.84, ["Fly|Ride"] = 52.5, ["Neon"] = 18.59, ["Neon|Fly"] = 70.46, ["Neon|Ride"] = 43.05, ["Neon|Fly|Ride"] = 149.81, ["Mega"] = 131.23, ["Mega|Fly"] = 285.27, ["Mega|Ride"] = 111.57, ["Mega|Fly|Ride"] = 352.35}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 1048.69, ["Fly"] = 4593.75, ["Ride"] = 984.38, ["Fly|Ride"] = 1196.31, ["Neon"] = 5898.26, ["Neon|Ride"] = 5381.25, ["Neon|Fly|Ride"] = 4593.75, ["Mega"] = 25318.44, ["Mega|Ride"] = 53790.98, ["Mega|Fly|Ride"] = 16035.03}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 6.57, ["Fly"] = 28.49, ["Ride"] = 23.34, ["Fly|Ride"] = 87.94, ["Neon"] = 107.37, ["Neon|Ride"] = 139.27, ["Neon|Fly|Ride"] = 141.62, ["Mega"] = 262.5, ["Mega|Ride"] = 620.31, ["Mega|Fly|Ride"] = 661.45}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 87.62, ["Ride"] = 141.39, ["Fly|Ride"] = 196.88, ["Neon"] = 656.25, ["Neon|Ride"] = 682.5, ["Neon|Fly|Ride"] = 721.88, ["Mega|Ride"] = 2636.29, ["Mega|Fly|Ride"] = 2671.11}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 41.16}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 28.2, ["Fly"] = 45.94, ["Ride"] = 55.13, ["Fly|Ride"] = 141.35, ["Neon"] = 91.41, ["Neon|Fly"] = 168.8, ["Neon|Ride"] = 206.07, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 682.5, ["Mega|Ride"] = 723.19, ["Mega|Fly|Ride"] = 749.51}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 3.29}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 124.69, ["Ride"] = 207.38, ["Fly|Ride"] = 261.82, ["Neon"] = 525, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 630, ["Mega|Fly|Ride"] = 2362.5}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 129.93, ["Ride"] = 175.45, ["Fly|Ride"] = 245.44, ["Neon"] = 328.13, ["Neon|Ride"] = 366.18, ["Neon|Fly|Ride"] = 485.28, ["Mega"] = 1575, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 45.94}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 56.44, ["Fly"] = 65.63, ["Ride"] = 59.07, ["Fly|Ride"] = 57.39, ["Neon"] = 358.7, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 304.5, ["Mega"] = 4218.71, ["Mega|Fly|Ride"] = 1319.42}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 5.25, ["Ride"] = 26.25, ["Fly|Ride"] = 85.32, ["Neon"] = 31.85, ["Neon|Ride"] = 126.6, ["Neon|Fly|Ride"] = 235.27, ["Mega"] = 168.8, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 204.75, ["Mega|Fly|Ride"] = 352.35}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 380.61, ["Fly"] = 420, ["Ride"] = 392.88, ["Fly|Ride"] = 426.12, ["Neon|Fly"] = 985.32, ["Neon|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 1249.57, ["Mega|Fly|Ride"] = 5345.37}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 64.97, ["Fly"] = 99.75, ["Ride"] = 94.5, ["Fly|Ride"] = 132.57, ["Neon"] = 367.14, ["Neon|Ride"] = 379.79, ["Neon|Fly|Ride"] = 369.02, ["Mega"] = 2813.52, ["Mega|Ride"] = 1885.19, ["Mega|Fly|Ride"] = 1927.38}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 4219.21, ["Ride"] = 3433.5, ["Fly|Ride"] = 3017.44, ["Neon|Fly|Ride"] = 14768.04}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 37.09, ["Fly"] = 112.91, ["Ride"] = 56.43, ["Fly|Ride"] = 95.82, ["Neon"] = 281.69, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 379.79, ["Mega"] = 1268.04, ["Mega|Ride"] = 1264.88, ["Mega|Fly|Ride"] = 2251.25}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 50.67, ["Ride"] = 90.75, ["Fly|Ride"] = 160.22, ["Neon"] = 656.25, ["Neon|Ride"] = 791.81, ["Neon|Fly|Ride"] = 563.36, ["Mega"] = 6329.63, ["Mega|Fly|Ride"] = 1822.95}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 48.57, ["Fly"] = 69.47, ["Ride"] = 61.53, ["Fly|Ride"] = 126.9, ["Neon"] = 237.96, ["Neon|Ride"] = 112.4, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 2598.75, ["Mega|Fly|Ride"] = 703.5}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 9.09}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 54.73, ["Ride"] = 56.37, ["Fly|Ride"] = 116.52, ["Neon"] = 328.13, ["Neon|Ride"] = 352.35, ["Neon|Fly|Ride"] = 420.93, ["Mega|Ride"] = 1407.3, ["Mega|Fly|Ride"] = 1275.46}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 35.43}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 232.62, ["Fly"] = 311.26, ["Ride"] = 250.69, ["Fly|Ride"] = 337.59, ["Neon|Ride"] = 3481.3, ["Neon|Fly|Ride"] = 1594.6}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 918.75, ["Ride"] = 943.69, ["Fly|Ride"] = 853.13, ["Neon|Ride"] = 3375.81, ["Neon|Fly|Ride"] = 3655.32, ["Mega|Fly|Ride"] = 11812.5}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 3.93}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 25.81, ["Fly"] = 52.43, ["Ride"] = 45.92, ["Fly|Ride"] = 62.99, ["Neon"] = 162.75, ["Neon|Fly"] = 211.01, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 211.01, ["Mega|Fly|Ride"] = 765.19}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 11.82}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5250, ["Fly"] = 5852.45, ["Ride"] = 6329.63, ["Fly|Ride"] = 4442.82, ["Neon|Fly|Ride"] = 10498.69, ["Mega|Fly|Ride"] = 31500}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 12.17, ["Fly"] = 74.62, ["Ride"] = 26.25, ["Fly|Ride"] = 69.55, ["Neon"] = 83.35, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 195.57, ["Mega"] = 483, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 570.42}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 14.02, ["Fly"] = 191.66, ["Ride"] = 32.82, ["Fly|Ride"] = 91.88, ["Neon"] = 91.88, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 231, ["Mega"] = 1054.95, ["Mega|Ride"] = 530.64, ["Mega|Fly|Ride"] = 946.3}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 141.4, ["Fly"] = 139.21, ["Ride"] = 90.75, ["Fly|Ride"] = 161.43, ["Neon"] = 1407.3, ["Neon|Fly|Ride"] = 420, ["Mega"] = 4219.76}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 11.68, ["Ride"] = 32.72, ["Fly|Ride"] = 139.65, ["Neon"] = 78.75, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 462.53, ["Mega"] = 555.97, ["Mega|Ride"] = 417.03, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 2126.25, ["Fly"] = 3095.57, ["Ride"] = 2510.76, ["Fly|Ride"] = 1968.75, ["Neon|Fly|Ride"] = 4634.47, ["Mega|Fly|Ride"] = 15079.32}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 34168.32, ["Fly"] = 28697.72, ["Ride"] = 35071.5, ["Fly|Ride"] = 22914.94, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 64611.75, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 196921.52}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 16.75, ["Fly"] = 393.75, ["Ride"] = 39.38, ["Fly|Ride"] = 91.8, ["Neon"] = 282.19, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 281.69, ["Mega"] = 843.96, ["Mega|Ride"] = 1102.5, ["Mega|Fly|Ride"] = 1397.82}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.08, ["Ride"] = 41.88, ["Fly|Ride"] = 141.38, ["Neon"] = 14.44, ["Neon|Fly"] = 134.39, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 129.94, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 18.38}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.87, ["Ride"] = 42, ["Fly|Ride"] = 111.57, ["Neon"] = 61.69, ["Neon|Ride"] = 105.25, ["Neon|Fly|Ride"] = 463.32, ["Mega"] = 393.75, ["Mega|Ride"] = 478.15, ["Mega|Fly|Ride"] = 548.58}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 779.7, ["Ride"] = 734.32, ["Fly|Ride"] = 700.88, ["Neon"] = 3029.23, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2560.35, ["Mega|Fly|Ride"] = 11101.13}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 979.12, ["Fly"] = 900.38, ["Ride"] = 906.46, ["Fly|Ride"] = 984.38, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 3071.25}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 19.67, ["Fly"] = 119.61, ["Ride"] = 53.81, ["Fly|Ride"] = 109.72, ["Neon"] = 160.21, ["Neon|Ride"] = 160.06, ["Neon|Fly|Ride"] = 220.5, ["Mega"] = 982.7, ["Mega|Ride"] = 682.5, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 19.69}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 59.04, ["Fly"] = 132.77, ["Ride"] = 76.53, ["Fly|Ride"] = 118.13, ["Neon|Ride"] = 422, ["Neon|Fly|Ride"] = 410.82, ["Mega|Ride"] = 1686.85, ["Mega|Fly|Ride"] = 1598.63}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 63.31, ["Ride"] = 84, ["Fly|Ride"] = 195.39, ["Neon"] = 394.56, ["Neon|Fly"] = 394.56, ["Neon|Ride"] = 638.38, ["Neon|Fly|Ride"] = 506.39, ["Mega"] = 1623.57, ["Mega|Fly|Ride"] = 1666.82}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.56, ["Fly"] = 32.78, ["Ride"] = 18.27, ["Fly|Ride"] = 43.26, ["Neon"] = 28.88, ["Neon|Fly"] = 319.2, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 132.95, ["Mega"] = 236.25, ["Mega|Fly"] = 337.59, ["Mega|Ride"] = 400.88, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 78.73, ["Fly"] = 91.77, ["Ride"] = 85.32, ["Fly|Ride"] = 138.95, ["Neon"] = 814.42, ["Neon|Ride"] = 284.82, ["Neon|Fly|Ride"] = 308.34, ["Mega|Fly|Ride"] = 1009.42}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.89, ["Ride"] = 26.25, ["Fly|Ride"] = 262.5, ["Neon"] = 25.47, ["Neon|Ride"] = 137.82, ["Mega"] = 160.12, ["Mega|Fly"] = 985.32, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 387.19}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 15.01, ["Fly"] = 59.11, ["Ride"] = 31.5, ["Fly|Ride"] = 105.21, ["Neon"] = 65.63, ["Neon|Fly"] = 105.51, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 141.38, ["Mega"] = 745.86, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 30.19, ["Ride"] = 69.64, ["Fly|Ride"] = 156.19, ["Neon"] = 215.22, ["Neon|Ride"] = 184.63, ["Mega|Ride"] = 1161.57, ["Mega|Fly|Ride"] = 703.65}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 15.83, ["Fly"] = 77.33, ["Ride"] = 26.24, ["Fly|Ride"] = 82.67, ["Neon"] = 103.69, ["Neon|Fly"] = 563.36, ["Neon|Ride"] = 99.18, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 1054.95, ["Mega|Ride"] = 929.41, ["Mega|Fly|Ride"] = 944.18}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6994.18, ["Ride"] = 6864.38, ["Fly|Ride"] = 5250, ["Neon"] = 34921.69, ["Neon|Fly|Ride"] = 24262.46}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 245.58, ["Fly"] = 295.43, ["Ride"] = 249.38, ["Fly|Ride"] = 281.18, ["Neon"] = 661.45, ["Neon|Ride"] = 654.07, ["Neon|Fly|Ride"] = 551.95, ["Mega|Fly|Ride"] = 2098.69}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 26.25, ["Fly"] = 119.61, ["Ride"] = 56.85, ["Fly|Ride"] = 99.17, ["Neon"] = 78.52, ["Neon|Fly"] = 160.21, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 195.57, ["Mega"] = 310.59, ["Mega|Fly"] = 376.69, ["Mega|Ride"] = 303.18, ["Mega|Fly|Ride"] = 401.42}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.51, ["Fly"] = 42.23, ["Ride"] = 18.38, ["Fly|Ride"] = 90.75, ["Neon"] = 21.12, ["Neon|Ride"] = 56.98, ["Neon|Fly|Ride"] = 95.64, ["Mega"] = 157.5}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 37.99, ["Fly"] = 99.2, ["Ride"] = 72.18, ["Fly|Ride"] = 150.94, ["Neon"] = 105, ["Neon|Fly"] = 295.4, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 271.69, ["Mega"] = 418.69, ["Mega|Ride"] = 449.06, ["Mega|Fly|Ride"] = 560.44}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 12810, ["Ride"] = 12468.75, ["Fly|Ride"] = 11156.24, ["Neon|Fly|Ride"] = 22968.75, ["Mega|Fly|Ride"] = 91428.04}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 141.75, ["Ride"] = 201.06, ["Fly|Ride"] = 239.48, ["Neon"] = 765.1, ["Neon|Ride"] = 1125.63, ["Neon|Fly|Ride"] = 1164.66, ["Mega|Fly|Ride"] = 7172.15}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 47.13, ["Fly"] = 459.38, ["Ride"] = 60.1, ["Fly|Ride"] = 71.67, ["Neon|Fly"] = 478.2, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 309.41, ["Mega|Fly|Ride"] = 2038.15}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 11.4, ["Fly"] = 45.46, ["Ride"] = 24.26, ["Fly|Ride"] = 65.54, ["Neon"] = 65.63, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 2531.86, ["Mega|Fly|Ride"] = 546.53}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 367.5, ["Fly"] = 844.07, ["Ride"] = 420, ["Fly|Ride"] = 517.99, ["Neon"] = 1519.11, ["Neon|Ride"] = 1311.19, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Ride"] = 4724.98, ["Mega|Fly|Ride"] = 4935}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.28, ["Fly"] = 39.38, ["Ride"] = 33.76, ["Neon"] = 19.69, ["Neon|Ride"] = 70.7, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 127.18, ["Mega|Ride"] = 199.39, ["Mega|Fly|Ride"] = 265.86}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 199.4, ["Fly"] = 393.75, ["Ride"] = 215.25, ["Fly|Ride"] = 294.34, ["Neon"] = 771.74, ["Neon|Ride"] = 774.35, ["Neon|Fly|Ride"] = 729.75, ["Mega|Ride"] = 3347.01, ["Mega|Fly|Ride"] = 2623.69}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 7.87, ["Fly"] = 22.31, ["Ride"] = 18.96, ["Fly|Ride"] = 27.57, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 101.58, ["Mega"] = 2531.86, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 7.88}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 57.75, ["Ride"] = 78.92, ["Fly|Ride"] = 525, ["Neon"] = 237.38, ["Neon|Fly"] = 1687.91, ["Neon|Ride"] = 422, ["Neon|Fly|Ride"] = 797.32, ["Mega"] = 1396.75, ["Mega|Ride"] = 1434.45, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 13.12, ["Fly"] = 62.21, ["Ride"] = 34.13, ["Fly|Ride"] = 72.19, ["Neon"] = 87.61, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 194.15, ["Mega"] = 480.12, ["Mega|Ride"] = 500.06, ["Mega|Fly|Ride"] = 576.01}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 15.75}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 28.29, ["Fly"] = 111.57, ["Ride"] = 72.19, ["Fly|Ride"] = 223.58, ["Neon"] = 168.8, ["Neon|Ride"] = 223.67, ["Neon|Fly|Ride"] = 273.25, ["Mega"] = 631.92, ["Mega|Ride"] = 774.35, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.87, ["Ride"] = 42.21, ["Fly|Ride"] = 131.25, ["Neon"] = 28.75, ["Neon|Ride"] = 107.61, ["Neon|Fly|Ride"] = 126.6, ["Mega"] = 117.16, ["Mega|Fly|Ride"] = 639.85}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 11.8, ["Fly"] = 70.71, ["Ride"] = 30.18, ["Fly|Ride"] = 74.82, ["Neon|Ride"] = 137.16, ["Neon|Fly|Ride"] = 225.78, ["Mega"] = 702.6, ["Mega|Ride"] = 447.3, ["Mega|Fly|Ride"] = 759.94}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 347.82, ["Fly"] = 506.45, ["Ride"] = 315, ["Fly|Ride"] = 409.5, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 7736.91}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 47.85, ["Ride"] = 56.96, ["Fly|Ride"] = 103.67, ["Neon"] = 182.44, ["Neon|Ride"] = 208.89, ["Neon|Fly|Ride"] = 160.19, ["Mega"] = 730.03, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 760.27}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 45.63, ["Fly"] = 83.91, ["Ride"] = 60.38, ["Fly|Ride"] = 131.25, ["Neon"] = 160.1, ["Neon|Ride"] = 209.94, ["Neon|Fly|Ride"] = 630, ["Mega"] = 1275.46, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1154.11}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 28.49, ["Fly"] = 61.2, ["Ride"] = 74.79, ["Fly|Ride"] = 131.25, ["Neon"] = 94.5, ["Neon|Ride"] = 156.15, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 392.44, ["Mega|Ride"] = 405.57, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 9843.75, ["Ride"] = 13709.39, ["Fly|Ride"] = 7854, ["Neon|Fly|Ride"] = 14424.38, ["Mega|Fly|Ride"] = 39372.9}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1620.94, ["Fly"] = 2034.38, ["Ride"] = 1706.25, ["Fly|Ride"] = 1706.25, ["Neon"] = 6216.25, ["Neon|Fly|Ride"] = 4200, ["Mega|Fly|Ride"] = 23625}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 391.13, ["Ride"] = 464.16, ["Fly|Ride"] = 446.25, ["Neon"] = 2109.89, ["Neon|Fly|Ride"] = 1941.09, ["Mega"] = 11953.56, ["Mega|Fly|Ride"] = 6581.75}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 15.62, ["Fly"] = 30.61, ["Ride"] = 18.36, ["Fly|Ride"] = 41.82, ["Neon"] = 126.6, ["Neon|Ride"] = 49.61, ["Neon|Fly|Ride"] = 105, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 4.87, ["Fly"] = 39.38, ["Ride"] = 168.8, ["Fly|Ride"] = 111.56, ["Neon"] = 27.44, ["Neon|Ride"] = 70.61, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 141.38, ["Mega|Ride"] = 200.82, ["Mega|Fly|Ride"] = 319.17}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 28.25, ["Fly"] = 53.55, ["Ride"] = 53.6, ["Fly|Ride"] = 78.73, ["Neon"] = 187.8, ["Neon|Ride"] = 138.44, ["Neon|Fly|Ride"] = 177.02, ["Mega|Fly|Ride"] = 559.13}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 2.59, ["Fly"] = 27.2, ["Ride"] = 17.07, ["Fly|Ride"] = 34.12, ["Neon"] = 30.61, ["Neon|Fly"] = 63.68, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 360.94, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 295.8, ["Fly"] = 320.24, ["Ride"] = 308.44, ["Fly|Ride"] = 341.25, ["Neon|Ride"] = 1793.16, ["Neon|Fly|Ride"] = 1645.71, ["Mega|Fly|Ride"] = 7384.56}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 24.94, ["Fly"] = 48.19, ["Ride"] = 40.69, ["Fly|Ride"] = 70.7, ["Neon"] = 143.48, ["Neon|Fly"] = 168.8, ["Neon|Ride"] = 141.37, ["Neon|Fly|Ride"] = 219.43, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 11.82, ["Fly"] = 25.31, ["Ride"] = 23.6, ["Fly|Ride"] = 34.12, ["Neon"] = 56.98, ["Neon|Fly"] = 136.31, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 115.77, ["Mega"] = 527.48, ["Mega|Ride"] = 581.28, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 392.44, ["Fly"] = 787.5, ["Ride"] = 446.25, ["Fly|Ride"] = 476.85, ["Neon|Ride"] = 2742.85, ["Mega|Fly|Ride"] = 8619.19}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1123.49, ["Fly"] = 1435.12, ["Ride"] = 1173.24, ["Fly|Ride"] = 1089.38, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 17300.95}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 95.69, ["Fly"] = 109.75, ["Ride"] = 92.86, ["Fly|Ride"] = 91.88, ["Neon"] = 971.25, ["Neon|Ride"] = 416.06, ["Neon|Fly|Ride"] = 422.63, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 153.57, ["Fly"] = 228.43, ["Ride"] = 183.58, ["Fly|Ride"] = 224.44, ["Neon"] = 656.25, ["Neon|Fly"] = 675.18, ["Neon|Ride"] = 703.65, ["Neon|Fly|Ride"] = 525, ["Mega"] = 5627.03, ["Mega|Ride"] = 8596.88, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 24.93, ["Fly"] = 131.25, ["Ride"] = 41.99, ["Fly|Ride"] = 281.69, ["Neon"] = 196.88, ["Neon|Fly"] = 422, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 366.08, ["Mega|Ride"] = 1829.27, ["Mega|Fly|Ride"] = 894.59}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 112.91, ["Ride"] = 210.74, ["Fly|Ride"] = 597.19, ["Neon|Fly|Ride"] = 1410.54, ["Mega|Fly|Ride"] = 2991.99}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2052.74, ["Ride"] = 2483.25, ["Fly|Ride"] = 2529.75, ["Neon|Fly|Ride"] = 7171.46, ["Mega|Fly|Ride"] = 48527.01}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 62.26, ["Ride"] = 49.75, ["Fly|Ride"] = 156.15, ["Neon"] = 290.12, ["Neon|Fly"] = 295.4, ["Neon|Fly|Ride"] = 414.75, ["Mega"] = 2103.56, ["Mega|Ride"] = 2320.87, ["Mega|Fly|Ride"] = 1912.58}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 551.25, ["Fly"] = 675.94, ["Ride"] = 601.13, ["Fly|Ride"] = 640.5, ["Neon|Ride"] = 1266.57, ["Neon|Fly|Ride"] = 1244.24, ["Mega|Fly|Ride"] = 2951.71}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 48.57, ["Fly"] = 52.49, ["Ride"] = 45.93, ["Fly|Ride"] = 78.75, ["Neon"] = 196.88, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 233.63, ["Mega|Fly|Ride"] = 1179.3}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.89, ["Fly"] = 37.72, ["Ride"] = 20.87, ["Fly|Ride"] = 39.37, ["Neon"] = 26.25, ["Neon|Fly"] = 54.87, ["Neon|Ride"] = 49.87, ["Neon|Fly|Ride"] = 80.1, ["Mega"] = 128.63, ["Mega|Fly"] = 251.08, ["Mega|Ride"] = 168.8, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 44.86, ["Ride"] = 52.5, ["Fly|Ride"] = 131.25, ["Neon"] = 139.27, ["Neon|Ride"] = 267.96, ["Neon|Fly|Ride"] = 534.87, ["Mega|Ride"] = 1407.3, ["Mega|Fly|Ride"] = 956.3}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 517.13, ["Fly"] = 899.07, ["Ride"] = 535.5, ["Fly|Ride"] = 581.44, ["Neon"] = 2109.89, ["Neon|Ride"] = 1771.88, ["Neon|Fly|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 5709.38}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 498.75, ["Ride"] = 525, ["Fly|Ride"] = 689.94, ["Neon"] = 5274.68, ["Neon|Ride"] = 4068.75, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 12750.87}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 18.38, ["Fly"] = 40.08, ["Ride"] = 23.39, ["Fly|Ride"] = 43.31, ["Neon"] = 211.01, ["Neon|Ride"] = 101.3, ["Neon|Fly|Ride"] = 117.99, ["Mega|Fly|Ride"] = 638.33}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 7.25, ["Ride"] = 22.32, ["Fly|Ride"] = 53.17, ["Neon"] = 45.93, ["Neon|Ride"] = 69.65, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 1685.8, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.82, ["Ride"] = 38.27, ["Fly|Ride"] = 110.24, ["Neon"] = 19.62, ["Neon|Fly"] = 314.9, ["Neon|Ride"] = 57.74, ["Mega"] = 203.44, ["Mega|Fly"] = 447.57, ["Mega|Ride"] = 197.29, ["Mega|Fly|Ride"] = 316.5}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 50.67, ["Fly"] = 64.24, ["Ride"] = 44.62, ["Fly|Ride"] = 78.73, ["Neon"] = 239.11, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 220.5, ["Mega|Fly|Ride"] = 901.59}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 31.49, ["Ride"] = 111.57, ["Fly|Ride"] = 1054.95, ["Neon"] = 267.96, ["Neon|Ride"] = 407.69, ["Neon|Fly|Ride"] = 319.17, ["Mega"] = 1547.6, ["Mega|Ride"] = 1547.6, ["Mega|Fly|Ride"] = 1275.46}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 15.75, ["Fly"] = 65.63, ["Ride"] = 31.44, ["Fly|Ride"] = 72.19, ["Neon"] = 110.92, ["Neon|Ride"] = 108.87, ["Neon|Fly|Ride"] = 170.63, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 643.52}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 30.19, ["Fly"] = 65.05, ["Ride"] = 45.94, ["Fly|Ride"] = 87.93, ["Neon"] = 408.28, ["Neon|Ride"] = 195.86, ["Neon|Fly|Ride"] = 210, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1195.38}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.56, ["Fly"] = 31.5, ["Ride"] = 15.84, ["Fly|Ride"] = 39.37, ["Neon"] = 28.6, ["Neon|Ride"] = 37.72, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 262.5, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 404.06}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 3.92, ["Fly"] = 44.33, ["Ride"] = 25.61, ["Fly|Ride"] = 68.09, ["Neon"] = 26.14, ["Neon|Fly"] = 160.21, ["Neon|Ride"] = 41.89, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 251.08, ["Mega|Fly"] = 478.95, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 422}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 52.49, ["Fly"] = 60.37, ["Ride"] = 64.31, ["Fly|Ride"] = 57.74, ["Neon"] = 581.28, ["Neon|Ride"] = 255.85, ["Neon|Fly|Ride"] = 223.13, ["Mega|Fly|Ride"] = 918.65}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1903.13, ["Fly"] = 1575, ["Ride"] = 1575, ["Fly|Ride"] = 1770.57, ["Neon|Ride"] = 5273.63, ["Neon|Fly|Ride"] = 3916.5, ["Mega|Fly|Ride"] = 13362.87}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 446.25, ["Fly"] = 703.74, ["Ride"] = 446.25, ["Fly|Ride"] = 590.63, ["Neon"] = 3188.22, ["Neon|Ride"] = 2251.25, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 9690.64}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 255.94, ["Fly"] = 421.32, ["Ride"] = 272.99, ["Fly|Ride"] = 392.44, ["Neon"] = 1202.53, ["Neon|Ride"] = 1179.94, ["Neon|Fly|Ride"] = 1404.14, ["Mega"] = 7384.56, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 44.63}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 28.49, ["Fly"] = 65.63, ["Ride"] = 74.7, ["Fly|Ride"] = 112.88, ["Neon"] = 206.07, ["Neon|Ride"] = 352.35, ["Neon|Fly|Ride"] = 251.08, ["Mega|Ride"] = 944.18, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 33762.02, ["Fly"] = 23625, ["Ride"] = 34781.25, ["Fly|Ride"] = 16232.6, ["Neon|Fly|Ride"] = 37977.68, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 393.75, ["Fly"] = 420, ["Ride"] = 380.63, ["Fly|Ride"] = 472.5, ["Neon"] = 1263.83, ["Neon|Fly"] = 1115.63, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1076.25, ["Mega"] = 6329.63, ["Mega|Ride"] = 6694.01, ["Mega|Fly|Ride"] = 3850.88}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 127.98, ["Fly"] = 141.4, ["Ride"] = 136.49, ["Fly|Ride"] = 143.49, ["Neon|Ride"] = 843.96, ["Neon|Fly|Ride"] = 1054.95, ["Mega|Fly|Ride"] = 4219.76}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 103.69, ["Fly"] = 257.25, ["Ride"] = 122.07, ["Fly|Ride"] = 205.73, ["Neon"] = 714.89, ["Neon|Ride"] = 843.96, ["Neon|Fly|Ride"] = 797.32, ["Mega"] = 14066.52, ["Mega|Fly|Ride"] = 5274.68}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 17.05, ["Fly"] = 66.48, ["Ride"] = 33.76, ["Fly|Ride"] = 98.44, ["Neon"] = 266.44, ["Neon|Ride"] = 135.19, ["Neon|Fly|Ride"] = 264.31, ["Mega"] = 703.65, ["Mega|Fly|Ride"] = 703.65}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 5260.24, ["Ride"] = 5164.79, ["Fly|Ride"] = 4060.88, ["Neon|Ride"] = 16878.98, ["Neon|Fly|Ride"] = 17582.61, ["Mega|Fly|Ride"] = 70329.35}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 27.67, ["Fly"] = 35.43, ["Ride"] = 32.81, ["Fly|Ride"] = 49.87, ["Neon"] = 333.94, ["Neon|Ride"] = 209.94, ["Neon|Fly|Ride"] = 204.24, ["Mega|Fly|Ride"] = 703.5}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 35.44, ["Fly"] = 141.37, ["Ride"] = 43.99, ["Fly|Ride"] = 60.38, ["Neon|Fly"] = 1407.3, ["Neon|Ride"] = 141.38, ["Neon|Fly|Ride"] = 219.48, ["Mega"] = 1594.62, ["Mega|Fly|Ride"] = 1080.27}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 557.82, ["Fly"] = 603.75, ["Ride"] = 616.88, ["Fly|Ride"] = 653.63, ["Neon"] = 1706.25, ["Neon|Ride"] = 1679.05, ["Neon|Fly|Ride"] = 1460.82, ["Mega|Fly|Ride"] = 5249.99}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 15.74, ["Fly"] = 28.28, ["Ride"] = 28.88, ["Fly|Ride"] = 52.41, ["Neon"] = 98.44, ["Neon|Fly"] = 160.21, ["Neon|Ride"] = 107.61, ["Neon|Fly|Ride"] = 126.9, ["Mega"] = 774.35, ["Mega|Ride"] = 632.98, ["Mega|Fly|Ride"] = 523.68}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 16.01, ["Ride"] = 77.97, ["Fly|Ride"] = 91.88, ["Neon"] = 91.88, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 408.28, ["Mega|Ride"] = 573.79}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 91.77, ["Ride"] = 126.6, ["Fly|Ride"] = 245.44, ["Neon"] = 675.18, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 703.65, ["Mega|Fly|Ride"] = 2812.47}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 22.31, ["Fly"] = 131.25, ["Ride"] = 72.1, ["Fly|Ride"] = 152.87, ["Neon"] = 86.83, ["Neon|Fly"] = 239.11, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 309.61, ["Mega"] = 292.68, ["Mega|Fly"] = 807.19, ["Mega|Ride"] = 318.61, ["Mega|Fly|Ride"] = 493.01}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3412.5, ["Fly"] = 5168.78, ["Ride"] = 3582.11, ["Fly|Ride"] = 3346.88, ["Neon|Ride"] = 10997.96, ["Neon|Fly|Ride"] = 8531.25, ["Mega"] = 63296.09, ["Mega|Fly|Ride"] = 33056.4}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 42.23, ["Fly"] = 115.5, ["Ride"] = 56.98, ["Fly|Ride"] = 220.4, ["Neon"] = 191.29, ["Neon|Ride"] = 281.69, ["Neon|Fly|Ride"] = 418.39, ["Mega|Ride"] = 915.69, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7218.75, ["Ride"] = 7595.55, ["Fly|Ride"] = 6037.5, ["Neon|Fly|Ride"] = 17477.12, ["Mega|Fly|Ride"] = 63296.09}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.61, ["Fly"] = 19.84, ["Ride"] = 19.55, ["Fly|Ride"] = 26.25, ["Neon"] = 18.38, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 85.94, ["Mega"] = 323.89, ["Mega|Fly|Ride"] = 258.56}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 20.07, ["Fly"] = 26.25, ["Ride"] = 28.44, ["Fly|Ride"] = 48.47, ["Neon"] = 211.01, ["Neon|Ride"] = 559.37, ["Neon|Fly|Ride"] = 99.18, ["Mega|Ride"] = 1247.55, ["Mega|Fly|Ride"] = 927.94}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.2}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 11.81, ["Ride"] = 39.38, ["Fly|Ride"] = 122.85, ["Neon"] = 141.38, ["Neon|Ride"] = 138.21, ["Neon|Fly|Ride"] = 238.43, ["Mega"] = 1050, ["Mega|Ride"] = 983.21, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 26.25, ["Fly"] = 262.5, ["Ride"] = 34.13, ["Fly|Ride"] = 141.38, ["Neon"] = 182.43, ["Neon|Ride"] = 209.94, ["Neon|Fly|Ride"] = 280.63, ["Mega"] = 840, ["Mega|Ride"] = 956.3, ["Mega|Fly|Ride"] = 931.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 11.82, ["Fly"] = 26.13, ["Ride"] = 20.98, ["Fly|Ride"] = 26.24, ["Neon"] = 141.38, ["Neon|Ride"] = 141.38, ["Neon|Fly|Ride"] = 163.53, ["Mega"] = 2529.75, ["Mega|Ride"] = 596.5, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8398.31}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2716.11}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 20.34}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 160.54, ["Fly"] = 174.57, ["Ride"] = 177.24, ["Fly|Ride"] = 183.58, ["Mega|Fly|Ride"] = 5578.73}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 15.84, ["Fly"] = 132.96, ["Ride"] = 39.38, ["Fly|Ride"] = 196.88, ["Neon"] = 112.9, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 263.75, ["Mega"] = 914.64, ["Mega|Ride"] = 908.49, ["Mega|Fly|Ride"] = 720.54}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 11.03}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 7.88, ["Ride"] = 26.25, ["Neon|Ride"] = 84.41, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2572.5}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 186.35, ["Ride"] = 172.17, ["Fly|Ride"] = 414.87, ["Neon"] = 567, ["Neon|Ride"] = 918.75, ["Mega|Ride"] = 3503.45, ["Mega|Fly|Ride"] = 3484.47}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 127.32, ["Ride"] = 174.57, ["Fly|Ride"] = 319.23, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 774.35, ["Mega|Ride"] = 2778.57, ["Mega|Fly|Ride"] = 2387.44}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 177.18, ["Fly"] = 211.03, ["Ride"] = 157.49, ["Fly|Ride"] = 210, ["Neon"] = 799.32, ["Neon|Ride"] = 840, ["Neon|Fly|Ride"] = 842.03, ["Mega"] = 4641.73, ["Mega|Fly|Ride"] = 3493.88}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1506.75, ["Fly"] = 2532.16, ["Ride"] = 1089.37, ["Fly|Ride"] = 1289.74, ["Neon"] = 5345.37, ["Neon|Ride"] = 4816.88, ["Neon|Fly|Ride"] = 4462.5, ["Mega|Fly|Ride"] = 28131.96}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 17.56, ["Fly"] = 82.1, ["Ride"] = 32.82, ["Fly|Ride"] = 86.63, ["Neon"] = 127.29, ["Neon|Ride"] = 84.41, ["Neon|Fly|Ride"] = 319.17, ["Mega"] = 842.9, ["Mega|Fly|Ride"] = 956.85}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 643.13, ["Fly"] = 2100, ["Ride"] = 759.84, ["Fly|Ride"] = 829.65, ["Neon|Fly|Ride"] = 2953.83}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 66.94}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 14.97, ["Ride"] = 43.32, ["Fly|Ride"] = 98.44, ["Neon"] = 91.8, ["Neon|Ride"] = 141.38, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 393.62, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 875.01}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 6.56, ["Fly"] = 131.25, ["Ride"] = 28.49, ["Fly|Ride"] = 94.5, ["Neon"] = 56.98, ["Neon|Ride"] = 83.61, ["Neon|Fly|Ride"] = 223.5, ["Mega"] = 918.75, ["Mega|Ride"] = 485.63, ["Mega|Fly|Ride"] = 605.55}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 80.05}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 21, ["Fly"] = 108.92, ["Ride"] = 28.46, ["Fly|Ride"] = 70.7, ["Neon"] = 196.88, ["Neon|Ride"] = 158.25, ["Neon|Fly|Ride"] = 606.06, ["Mega"] = 817.6, ["Mega|Fly|Ride"] = 1445.75}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 26.25, ["Fly"] = 56.22, ["Ride"] = 32.81, ["Fly|Ride"] = 61.69, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 235.27, ["Neon|Fly|Ride"] = 274.32, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 5757.94, ["Fly"] = 11253, ["Ride"] = 5495.44, ["Fly|Ride"] = 4830, ["Neon|Ride"] = 17582.61, ["Neon|Fly|Ride"] = 10078.69, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 9.08, ["Fly"] = 34.13, ["Ride"] = 26.25, ["Fly|Ride"] = 90.75, ["Neon"] = 65.62, ["Neon|Ride"] = 99.18, ["Neon|Fly|Ride"] = 352.33, ["Mega"] = 534.87, ["Mega|Ride"] = 436.79, ["Mega|Fly|Ride"] = 417.38}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 20.98}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 115.5, ["Fly"] = 373.51, ["Ride"] = 175.13, ["Fly|Ride"] = 233.16, ["Neon"] = 418.69, ["Neon|Ride"] = 481.69, ["Neon|Fly|Ride"] = 677.78, ["Mega|Ride"] = 4219.76, ["Mega|Fly|Ride"] = 2083.52}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 69.62, ["Ride"] = 90.57, ["Fly|Ride"] = 153.57, ["Neon"] = 327.6, ["Neon|Ride"] = 421.99, ["Neon|Fly|Ride"] = 511.88, ["Mega|Ride"] = 2847.28}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 19.69, ["Fly"] = 72.17, ["Ride"] = 28.3, ["Fly|Ride"] = 47.24, ["Neon"] = 196.88, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 120.6, ["Mega|Ride"] = 877.41, ["Mega|Fly|Ride"] = 656.22}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6.57, ["Fly"] = 49.76, ["Ride"] = 28.5, ["Fly|Ride"] = 78.75, ["Neon"] = 23.5, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 50.46, ["Neon|Fly|Ride"] = 165.37, ["Mega"] = 131.12, ["Mega|Fly"] = 175.13, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 263.82}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 12.31, ["Fly"] = 69.47, ["Ride"] = 31.48, ["Fly|Ride"] = 52.5, ["Neon"] = 91.74, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 166.05, ["Mega"] = 375.58, ["Mega|Ride"] = 410.82, ["Mega|Fly|Ride"] = 544.69}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 18.27, ["Fly"] = 30.61, ["Ride"] = 24.93, ["Fly|Ride"] = 49.88, ["Neon"] = 208.71, ["Neon|Ride"] = 138.96, ["Neon|Fly|Ride"] = 133.88, ["Mega|Fly|Ride"] = 689.07}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 196.86}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 16.9, ["Ride"] = 105, ["Fly|Ride"] = 127.95, ["Neon"] = 189.67, ["Neon|Ride"] = 422, ["Mega"] = 1054.95, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1685.8}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 118.13, ["Ride"] = 140.44, ["Fly|Ride"] = 262.5, ["Neon"] = 563.36, ["Neon|Ride"] = 820.32}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 39.37, ["Fly"] = 212.01, ["Ride"] = 103.43, ["Fly|Ride"] = 143.49, ["Neon"] = 292.69, ["Neon|Ride"] = 337.59, ["Neon|Fly|Ride"] = 420, ["Mega"] = 1154.11, ["Mega|Ride"] = 1167.84, ["Mega|Fly|Ride"] = 1097.25}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 773.07, ["Fly"] = 787.5, ["Ride"] = 727.13, ["Fly|Ride"] = 769.72, ["Neon|Fly"] = 2869.05, ["Neon|Ride"] = 3281.25, ["Neon|Fly|Ride"] = 2624.99, ["Mega|Ride"] = 8439.5, ["Mega|Fly|Ride"] = 9450}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 312.13, ["Ride"] = 325.34, ["Fly|Ride"] = 353.95, ["Neon"] = 1181.25, ["Neon|Ride"] = 1666.45, ["Neon|Fly|Ride"] = 1575, ["Mega"] = 8299.19, ["Mega|Fly|Ride"] = 8203.13}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 72.19}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.57}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 10.5, ["Fly"] = 31.5, ["Ride"] = 24.92, ["Fly|Ride"] = 39.38, ["Neon"] = 72.19, ["Neon|Fly"] = 230.99, ["Neon|Ride"] = 97.5, ["Neon|Fly|Ride"] = 126.6, ["Mega"] = 590.78, ["Mega|Ride"] = 563.36, ["Mega|Fly|Ride"] = 451.53}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 315, ["Fly"] = 985.44, ["Ride"] = 328.13, ["Fly|Ride"] = 431.82, ["Neon"] = 976.89, ["Neon|Ride"] = 866.24, ["Neon|Fly|Ride"] = 918.75, ["Mega|Fly|Ride"] = 3304.07}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 13.13}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 118.13, ["Fly"] = 590.63, ["Ride"] = 177.19, ["Fly|Ride"] = 300.57, ["Neon"] = 635.99, ["Neon|Fly"] = 1687.91, ["Neon|Ride"] = 643.13, ["Neon|Fly|Ride"] = 708.75, ["Mega"] = 1927.38, ["Mega|Ride"] = 2011.77, ["Mega|Fly|Ride"] = 1777.29}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 131.25, ["Ride"] = 170.63, ["Fly|Ride"] = 287.44, ["Neon|Ride"] = 990.6}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 4.6, ["Ride"] = 28.49, ["Fly|Ride"] = 211.01, ["Neon"] = 45.38, ["Neon|Ride"] = 73.5, ["Neon|Fly|Ride"] = 176.93, ["Mega"] = 262.5, ["Mega|Ride"] = 311.28, ["Mega|Fly|Ride"] = 394.56}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 17.94, ["Fly"] = 63, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 98.98, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 252.15, ["Mega|Ride"] = 554.92, ["Mega|Fly|Ride"] = 573.9}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 20.98, ["Fly"] = 131.25, ["Ride"] = 61.82, ["Fly|Ride"] = 141.39, ["Neon"] = 99.75, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 418.79, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 1017.19}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 6.35, ["Fly"] = 84.42, ["Ride"] = 32.26, ["Fly|Ride"] = 111.17, ["Neon"] = 26.17, ["Neon|Fly"] = 70.7, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 178.17, ["Mega"] = 137.81, ["Mega|Ride"] = 175.88, ["Mega|Fly|Ride"] = 299.25}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 273, ["Fly"] = 918.75, ["Ride"] = 301.88, ["Fly|Ride"] = 368.3, ["Neon"] = 1547.6, ["Neon|Ride"] = 1214.07, ["Neon|Fly|Ride"] = 1424.07, ["Mega|Fly|Ride"] = 5105.9}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 111.57, ["Fly"] = 1050, ["Ride"] = 157.5, ["Fly|Ride"] = 253.23, ["Neon"] = 456.74, ["Neon|Ride"] = 459.37, ["Neon|Fly|Ride"] = 534.87, ["Mega"] = 1793.4, ["Mega|Ride"] = 1759.65, ["Mega|Fly|Ride"] = 1675.24}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 82.69, ["Fly"] = 167.45, ["Ride"] = 101.43, ["Fly|Ride"] = 128.63, ["Neon"] = 328.13, ["Neon|Ride"] = 400.88, ["Neon|Fly|Ride"] = 418.69, ["Mega|Fly|Ride"] = 1813.88}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 19.69, ["Ride"] = 58.24, ["Fly|Ride"] = 281.69, ["Neon|Ride"] = 607.29, ["Neon|Fly|Ride"] = 489.5, ["Mega|Fly|Ride"] = 1260}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 17.95, ["Fly"] = 75.62, ["Ride"] = 40.69, ["Fly|Ride"] = 102.38, ["Neon"] = 91.88, ["Neon|Ride"] = 113.95, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 450.18, ["Mega|Fly"] = 525, ["Mega|Ride"] = 492.66, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.41, ["Fly"] = 19.67, ["Ride"] = 20.98, ["Fly|Ride"] = 47.83, ["Neon"] = 18.69, ["Neon|Ride"] = 48.54, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 111.54, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 278.24}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 1019.82, ["Fly"] = 1265.03, ["Ride"] = 945, ["Fly|Ride"] = 917.44, ["Neon"] = 3007.12, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2493.73, ["Mega|Fly|Ride"] = 9371.25}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 392.44, ["Ride"] = 430.82, ["Fly|Ride"] = 472.5, ["Neon"] = 1699.51, ["Neon|Ride"] = 1680, ["Neon|Fly|Ride"] = 1706.25, ["Mega"] = 10549.35, ["Mega|Fly|Ride"] = 5846.46}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 99.2, ["Ride"] = 106.09, ["Fly|Ride"] = 161.44, ["Neon"] = 282.19, ["Neon|Ride"] = 305.82, ["Neon|Fly|Ride"] = 345.37, ["Mega|Ride"] = 1422.07, ["Mega|Fly|Ride"] = 1434.72}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 262.5, ["Fly"] = 337.64, ["Ride"] = 299.25, ["Fly|Ride"] = 317.16, ["Neon|Ride"] = 1294.42, ["Neon|Fly|Ride"] = 1315.52, ["Mega"] = 10549.35, ["Mega|Fly|Ride"] = 4199.99}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 15.75, ["Fly"] = 141.4, ["Ride"] = 35.79, ["Fly|Ride"] = 78.75, ["Neon"] = 157.49, ["Neon|Ride"] = 132.57, ["Neon|Fly|Ride"] = 166.69, ["Mega"] = 1407.3, ["Mega|Ride"] = 797.32, ["Mega|Fly|Ride"] = 618.87}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 216.12, ["Ride"] = 210, ["Fly|Ride"] = 315.25, ["Neon"] = 1584.98, ["Neon|Ride"] = 1686.85, ["Neon|Fly|Ride"] = 2425.31, ["Mega"] = 4198.94, ["Mega|Fly|Ride"] = 4398.92}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 80.14, ["Fly"] = 126, ["Ride"] = 62.99, ["Fly|Ride"] = 106.42, ["Neon"] = 522.2, ["Neon|Ride"] = 504.28, ["Neon|Fly|Ride"] = 563.36, ["Mega|Fly|Ride"] = 1397.82}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1312.5, ["Ride"] = 1336.85, ["Fly|Ride"] = 1575, ["Neon"] = 5345.37, ["Neon|Fly|Ride"] = 7308.61, ["Mega"] = 50636.88, ["Mega|Fly|Ride"] = 24474.5}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 9.18, ["Fly"] = 81.81, ["Ride"] = 30.18, ["Fly|Ride"] = 82.69, ["Neon"] = 59.07, ["Neon|Fly"] = 168.8, ["Neon|Ride"] = 82.69, ["Neon|Fly|Ride"] = 143.46, ["Mega"] = 253.32, ["Mega|Ride"] = 261.19, ["Mega|Fly|Ride"] = 422.04}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 49.87, ["Fly"] = 78.75, ["Ride"] = 84, ["Fly|Ride"] = 161.44, ["Neon"] = 315, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 547.53, ["Mega|Ride"] = 1143.56, ["Mega|Fly|Ride"] = 1458.19}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 71.46, ["Fly"] = 91.88, ["Ride"] = 72.34, ["Fly|Ride"] = 86.62, ["Neon|Ride"] = 410.82, ["Neon|Fly|Ride"] = 367.5, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2110.14, ["Ride"] = 1023.75, ["Fly|Ride"] = 1076.25, ["Neon|Fly|Ride"] = 4199.99, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 525, ["Fly"] = 841.95, ["Ride"] = 358.7, ["Fly|Ride"] = 703.65, ["Neon|Fly|Ride"] = 2109.89, ["Mega|Fly|Ride"] = 14344.28}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 95.47, ["Fly"] = 139.29, ["Ride"] = 131.24, ["Fly|Ride"] = 281.69, ["Neon"] = 590.78, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 499.02, ["Mega"] = 4219.76, ["Mega|Ride"] = 2673.22, ["Mega|Fly|Ride"] = 2072.76}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 6.24, ["Fly"] = 39.38, ["Ride"] = 21.06, ["Fly|Ride"] = 43.32, ["Neon"] = 87.84, ["Neon|Ride"] = 132.57, ["Neon|Fly|Ride"] = 179.36, ["Mega"] = 656.25, ["Mega|Ride"] = 740.06, ["Mega|Fly|Ride"] = 1025.4}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 41.96, ["Fly"] = 52.5, ["Ride"] = 47.12, ["Fly|Ride"] = 94.4, ["Neon"] = 143.48, ["Neon|Fly"] = 420.93, ["Neon|Ride"] = 223.62, ["Neon|Fly|Ride"] = 281.03, ["Mega"] = 1829.27, ["Mega|Ride"] = 1084.2, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 748.13, ["Ride"] = 874.13, ["Fly|Ride"] = 859.51, ["Neon"] = 2813.52, ["Neon|Ride"] = 2828.44, ["Neon|Fly|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 20631.83}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 879.55}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4895.5, ["Ride"] = 4608.19, ["Fly|Ride"] = 3911.25, ["Neon|Ride"] = 30235.5, ["Neon|Fly|Ride"] = 21520.69, ["Mega|Fly|Ride"] = 90021.82}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 144.38, ["Fly"] = 281.72, ["Ride"] = 223.58, ["Neon"] = 1687.91, ["Neon|Ride"] = 1054.95, ["Neon|Fly|Ride"] = 1407.3, ["Mega"] = 5907.65, ["Mega|Fly|Ride"] = 5627.03}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 83.58, ["Fly"] = 281.72, ["Ride"] = 77.44, ["Fly|Ride"] = 336, ["Neon"] = 985.32, ["Neon|Ride"] = 504.28, ["Neon|Fly|Ride"] = 985.32, ["Mega|Fly|Ride"] = 2838.13}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 9.09, ["Fly"] = 56.85, ["Ride"] = 26.13, ["Fly|Ride"] = 105, ["Neon"] = 102.38, ["Neon|Ride"] = 99.18, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 702.6, ["Mega|Ride"] = 632.98, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 18.72, ["Fly"] = 28.71, ["Ride"] = 28.61, ["Fly|Ride"] = 40.67, ["Neon|Ride"] = 141.38, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 843.96}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 19.22, ["Fly"] = 131.25, ["Ride"] = 39.38, ["Fly|Ride"] = 65.63, ["Neon"] = 126, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 226.41, ["Mega|Ride"] = 561.24, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.92, ["Fly"] = 56.99, ["Ride"] = 22.32, ["Fly|Ride"] = 38.07, ["Neon"] = 36.93, ["Neon|Ride"] = 40.43, ["Neon|Fly|Ride"] = 126.86, ["Mega"] = 695.67, ["Mega|Ride"] = 223.67, ["Mega|Fly|Ride"] = 316.5}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 31.68, ["Ride"] = 67.53, ["Fly|Ride"] = 183.75, ["Neon"] = 164.58, ["Neon|Fly"] = 843.96, ["Neon|Ride"] = 160.21, ["Neon|Fly|Ride"] = 248.98, ["Mega"] = 696.28, ["Mega|Ride"] = 703.65}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 297.55, ["Fly"] = 355.68, ["Ride"] = 287.18, ["Fly|Ride"] = 341.25, ["Neon"] = 1434.54, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 906.47, ["Mega"] = 6562.5, ["Mega|Fly|Ride"] = 3507.18}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.51, ["Fly"] = 22.97, ["Ride"] = 8.45, ["Fly|Ride"] = 36.75, ["Neon"] = 23.93, ["Neon|Ride"] = 28.24, ["Neon|Fly|Ride"] = 66.94, ["Mega"] = 157.5, ["Mega|Ride"] = 141.38, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 35.43, ["Fly"] = 101.7, ["Ride"] = 78.73, ["Fly|Ride"] = 114.09, ["Neon"] = 141.39, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 190.09, ["Neon|Fly|Ride"] = 255.21, ["Mega"] = 564.27, ["Mega|Fly"] = 843.96, ["Mega|Ride"] = 547.31, ["Mega|Fly|Ride"] = 570.94}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 667.07, ["Fly"] = 956.74, ["Ride"] = 721.88, ["Fly|Ride"] = 761.25, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1526.47, ["Mega|Fly|Ride"] = 4528.13}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 32.52, ["Fly"] = 91.88, ["Ride"] = 44.1, ["Fly|Ride"] = 73.5, ["Neon|Fly"] = 478.2, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 232.57, ["Mega"] = 1575, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 602.43}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 229.69, ["Fly"] = 342.44, ["Ride"] = 241.5, ["Fly|Ride"] = 279.49, ["Neon"] = 1244.83, ["Neon|Ride"] = 949.46, ["Neon|Fly|Ride"] = 945, ["Mega|Fly|Ride"] = 5274.68}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 141.4, ["Fly"] = 202.59, ["Ride"] = 137.44, ["Fly|Ride"] = 174.56, ["Neon"] = 632.98, ["Neon|Fly"] = 641.42, ["Neon|Ride"] = 526.43, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 2318.76}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 590.63, ["Ride"] = 608.67, ["Fly|Ride"] = 669.38, ["Neon|Fly|Ride"] = 2080.35, ["Mega|Fly|Ride"] = 7217.44}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 19, ["Ride"] = 47.18, ["Fly|Ride"] = 156.15, ["Neon"] = 61.21, ["Neon|Fly"] = 286.93, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 277.34, ["Mega"] = 352.65, ["Mega|Ride"] = 422, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3882.64, ["Fly"] = 3903.75, ["Ride"] = 3936.19, ["Fly|Ride"] = 3135.57, ["Neon|Fly|Ride"] = 6562.5, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 82.67, ["Fly"] = 131.25, ["Ride"] = 99.2, ["Fly|Ride"] = 157.5, ["Neon"] = 478.2, ["Neon|Ride"] = 420.93, ["Neon|Fly|Ride"] = 438.88, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.61, ["Fly"] = 33.76, ["Ride"] = 18.36, ["Fly|Ride"] = 84, ["Neon"] = 15.74, ["Neon|Fly"] = 45.05, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 112.9, ["Mega"] = 137.82, ["Mega|Fly"] = 253.2, ["Mega|Ride"] = 233.89, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 2.63, ["Ride"] = 28.28, ["Fly|Ride"] = 63, ["Neon"] = 24.28, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 161.43, ["Mega|Ride"] = 199.47, ["Mega|Fly|Ride"] = 278.2}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 53.81, ["Fly"] = 82.85, ["Ride"] = 41.99, ["Fly|Ride"] = 59.06, ["Neon|Ride"] = 211.01, ["Neon|Fly|Ride"] = 291.68, ["Mega|Fly|Ride"] = 1392.54}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 984.38, ["Ride"] = 1171, ["Fly|Ride"] = 1295.44, ["Neon"] = 5643.91, ["Neon|Fly|Ride"] = 5260.98, ["Mega|Fly|Ride"] = 22506}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 5184.37, ["Ride"] = 5977.76, ["Fly|Ride"] = 4068.75}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 19.9, ["Fly"] = 26.25, ["Ride"] = 24.94, ["Fly|Ride"] = 44.93, ["Neon"] = 104.46, ["Neon|Ride"] = 117.11, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 2428.13, ["Mega|Fly|Ride"] = 505.21}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 14.34, ["Fly"] = 47.75, ["Ride"] = 32.03, ["Fly|Ride"] = 65.63, ["Neon"] = 94.5, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 86.76, ["Neon|Fly|Ride"] = 175.61, ["Mega"] = 933.52, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 52.5, ["Fly"] = 157.49, ["Ride"] = 49.79, ["Fly|Ride"] = 72.19, ["Neon"] = 271.24, ["Neon|Ride"] = 312.29, ["Neon|Fly|Ride"] = 275.39, ["Mega"] = 1050, ["Mega|Ride"] = 1187.88, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 232.31, ["Fly"] = 319.33, ["Ride"] = 223.13, ["Fly|Ride"] = 258.98, ["Neon"] = 843.96, ["Neon|Ride"] = 976.5, ["Neon|Fly|Ride"] = 945, ["Mega"] = 10549.35, ["Mega|Fly|Ride"] = 3501.35}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.77, ["Ride"] = 26.25, ["Fly|Ride"] = 86.63, ["Neon"] = 27.23, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 84.41, ["Mega"] = 154.88, ["Mega|Ride"] = 253.2, ["Mega|Fly|Ride"] = 372.98}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 186.86, ["Fly"] = 253.23, ["Ride"] = 223.13, ["Fly|Ride"] = 275.63, ["Neon"] = 797.37, ["Neon|Ride"] = 827.09, ["Neon|Fly|Ride"] = 828.19, ["Mega|Fly|Ride"] = 3940.2}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.14, ["Fly"] = 24.12, ["Ride"] = 18.36, ["Fly|Ride"] = 39.38, ["Neon"] = 19.69, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 29.58, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 422, ["Mega|Ride"] = 196.67, ["Mega|Fly|Ride"] = 281.55}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 196.88, ["Fly"] = 268.82, ["Ride"] = 253.2, ["Fly|Ride"] = 261.19, ["Neon|Ride"] = 1314.99, ["Neon|Fly|Ride"] = 896.53, ["Mega"] = 10549.35, ["Mega|Ride"] = 6329.63, ["Mega|Fly|Ride"] = 7769.83}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 15.64, ["Fly"] = 26.25, ["Ride"] = 21.12, ["Fly|Ride"] = 63.31, ["Neon"] = 84.41, ["Neon|Fly"] = 303.66, ["Neon|Ride"] = 138.21, ["Neon|Fly|Ride"] = 326.05, ["Mega"] = 522.41, ["Mega|Ride"] = 563.36, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 12.68, ["Neon|Fly"] = 66, ["Neon|Ride"] = 63.31, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 76.37, ["Mega|Ride"] = 108.05, ["Mega|Fly|Ride"] = 235.52}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.52, ["Neon|Ride"] = 28.49, ["Mega"] = 22.91, ["Mega|Ride"] = 155.7}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.83, ["Ride"] = 261.19, ["Fly|Ride"] = 141.38, ["Neon"] = 7.07, ["Neon|Ride"] = 62.19, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 97.47, ["Mega|Fly"] = 159381.47, ["Mega|Ride"] = 101.12, ["Mega|Fly|Ride"] = 184.65}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 65.63, ["Fly"] = 139.26, ["Ride"] = 111.56, ["Fly|Ride"] = 185.74, ["Neon"] = 295.4, ["Neon|Fly"] = 263.17, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 347.82, ["Mega|Fly|Ride"] = 1086.75}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 40.69, ["Ride"] = 15.84, ["Fly|Ride"] = 43.32, ["Neon"] = 3.94, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 95.1, ["Mega|Ride"] = 98.34, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 9.09, ["Ride"] = 52.5, ["Fly|Ride"] = 196.23, ["Neon"] = 74.82, ["Neon|Ride"] = 127.94, ["Mega"] = 485.63, ["Mega|Ride"] = 523.69}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Ride"] = 30.61, ["Neon"] = 2.63, ["Neon|Ride"] = 28.48, ["Neon|Fly|Ride"] = 278.25, ["Mega"] = 15.83, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 131.15}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 15.69, ["Ride"] = 17.95, ["Fly|Ride"] = 34.55, ["Neon"] = 2.1, ["Neon|Fly"] = 35.88, ["Neon|Ride"] = 15.7, ["Neon|Fly|Ride"] = 29.96, ["Mega"] = 15.84, ["Mega|Fly"] = 30.19, ["Mega|Ride"] = 17.75, ["Mega|Fly|Ride"] = 52.49}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 15.62, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 15.44, ["Neon|Ride"] = 17.64, ["Neon|Fly|Ride"] = 46.17, ["Mega"] = 28.03, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 78.73}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 21.39, ["Fly|Ride"] = 125.73, ["Neon"] = 2.1, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 39.38, ["Mega"] = 23.23, ["Mega|Ride"] = 146.95, ["Mega|Fly|Ride"] = 305.94}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 118.11, ["Ride"] = 19.69, ["Fly|Ride"] = 105.31, ["Neon"] = 3.62, ["Neon|Fly"] = 135.05, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 86, ["Mega"] = 56.98, ["Mega|Fly"] = 85.32, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 166.69}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 6.04, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 21, ["Mega|Ride"] = 82.34}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 48.57, ["Ride"] = 32.82, ["Fly|Ride"] = 47.25, ["Neon"] = 6.35, ["Neon|Fly"] = 49.26, ["Neon|Ride"] = 23.92, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 52.39, ["Mega|Fly"] = 198.45, ["Mega|Ride"] = 83.58, ["Mega|Fly|Ride"] = 110.45}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 43.25, ["Neon"] = 2.1, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 313.84, ["Mega"] = 16.69, ["Mega|Ride"] = 44.54, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly|Ride"] = 525, ["Neon"] = 47.67, ["Mega"] = 208.89, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 344.97}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Neon"] = 6.35, ["Mega"] = 105, ["Mega|Fly|Ride"] = 378.74}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.49, ["Neon"] = 4.03, ["Neon|Ride"] = 37.71, ["Neon|Fly|Ride"] = 84.41, ["Mega"] = 22.32, ["Mega|Ride"] = 59.76, ["Mega|Fly|Ride"] = 131.06}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 18.84, ["Fly|Ride"] = 28.6, ["Neon"] = 2.1, ["Neon|Fly"] = 42.21, ["Neon|Ride"] = 17.49, ["Neon|Fly|Ride"] = 41.88, ["Mega"] = 15.75, ["Mega|Fly"] = 53.82, ["Mega|Ride"] = 21, ["Mega|Fly|Ride"] = 60.38}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.84, ["Fly"] = 72.19, ["Ride"] = 210, ["Fly|Ride"] = 104.98, ["Neon"] = 32.82, ["Neon|Ride"] = 39.83, ["Mega"] = 253.2, ["Mega|Fly"] = 281.69, ["Mega|Ride"] = 274.55}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Fly"] = 28.5, ["Ride"] = 42, ["Fly|Ride"] = 78.73, ["Neon"] = 5.25, ["Neon|Ride"] = 28.49, ["Neon|Fly|Ride"] = 158.06, ["Mega"] = 34.13, ["Mega|Ride"] = 51.18, ["Mega|Fly|Ride"] = 142.49}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 5.25, ["Neon"] = 13.13, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 141.38, ["Mega"] = 82.3, ["Mega|Ride"] = 132.57, ["Mega|Fly|Ride"] = 220.5}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 32.81, ["Fly|Ride"] = 192.02, ["Neon"] = 116.96, ["Neon|Ride"] = 70.7, ["Neon|Fly|Ride"] = 141.38, ["Mega"] = 92.86, ["Mega|Ride"] = 85.3, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 12.48, ["Ride"] = 12.73, ["Fly|Ride"] = 28.49, ["Neon"] = 2.1, ["Neon|Fly"] = 12.99, ["Neon|Ride"] = 15.81, ["Neon|Fly|Ride"] = 34.23, ["Mega"] = 17.05, ["Mega|Fly"] = 40.09, ["Mega|Ride"] = 23.91, ["Mega|Fly|Ride"] = 51.98}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 23.94, ["Ride"] = 18.69, ["Fly|Ride"] = 72.19, ["Neon"] = 4.13, ["Neon|Ride"] = 114.78, ["Neon|Fly|Ride"] = 70.7, ["Mega"] = 78.75, ["Mega|Fly|Ride"] = 196.77}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 6.23, ["Fly"] = 41.91, ["Fly|Ride"] = 141.38, ["Neon"] = 90.75, ["Neon|Ride"] = 112.9, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 279.2, ["Mega|Ride"] = 278.07, ["Mega|Fly|Ride"] = 387.85}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 14.17, ["Ride"] = 17.85, ["Fly|Ride"] = 26.17, ["Neon"] = 3.93, ["Neon|Fly"] = 20.24, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 30.19, ["Mega"] = 70.7, ["Mega|Fly"] = 156.19, ["Mega|Fly|Ride"] = 98.21}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 176.21, ["Neon"] = 10.57, ["Neon|Fly"] = 77.53, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 84.41, ["Mega|Fly"] = 168.8, ["Mega|Ride"] = 105}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 5.25, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 28.49, ["Neon|Fly|Ride"] = 143.2, ["Mega"] = 28.49, ["Mega|Ride"] = 156.15, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 46.44, ["Neon"] = 2.1, ["Neon|Fly"] = 42.21, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 15.74, ["Mega|Ride"] = 70.7, ["Mega|Fly|Ride"] = 124.74}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 99.18, ["Ride"] = 15.73, ["Fly|Ride"] = 41.99, ["Neon"] = 6.33, ["Neon|Fly"] = 45.1, ["Neon|Ride"] = 27.44, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 60.29, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 269.03}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 38.75, ["Neon"] = 7.66, ["Neon|Ride"] = 51.74, ["Mega"] = 131.15, ["Mega|Ride"] = 167.36, ["Mega|Fly|Ride"] = 316.5}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.05, ["Fly"] = 32.48, ["Ride"] = 15.69, ["Fly|Ride"] = 140.38, ["Neon"] = 8.39, ["Neon|Fly"] = 108.81, ["Neon|Ride"] = 25.09, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 65.63, ["Mega|Ride"] = 90.46, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 5.25, ["Ride"] = 82.6, ["Neon"] = 30.79, ["Mega"] = 281.69, ["Mega|Fly|Ride"] = 844.06}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 16.7, ["Fly|Ride"] = 5498.99, ["Neon"] = 11.71, ["Neon|Fly"] = 141.38, ["Neon|Ride"] = 31.39, ["Neon|Fly|Ride"] = 141.27, ["Mega"] = 255.94, ["Mega|Ride"] = 132.95, ["Mega|Fly|Ride"] = 281.69}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 20.6, ["Ride"] = 29.61, ["Fly|Ride"] = 141.38, ["Neon"] = 35.44, ["Neon|Fly"] = 40.09, ["Neon|Ride"] = 41.93, ["Neon|Fly|Ride"] = 111.04, ["Mega"] = 135.03, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 209.98}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 79.47, ["Fly|Ride"] = 106.14, ["Neon"] = 23, ["Neon|Ride"] = 160.21, ["Mega"] = 200.16, ["Mega|Ride"] = 405.56}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 7.87, ["Ride"] = 78.08, ["Neon"] = 141.38, ["Neon|Ride"] = 105.51, ["Mega"] = 656.25, ["Mega|Ride"] = 881.94, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 3.83, ["Ride"] = 56.49, ["Neon"] = 87.26, ["Neon|Ride"] = 39.38, ["Mega"] = 223.54, ["Mega|Ride"] = 367.5}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 8.39, ["Ride"] = 39.29, ["Neon"] = 69.57, ["Neon|Ride"] = 71.75, ["Mega"] = 478.15, ["Mega|Ride"] = 255.29, ["Mega|Fly|Ride"] = 390.48}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.12, ["Neon|Ride"] = 92.53, ["Mega"] = 21, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 148.31}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 48.19}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 3.82, ["Fly"] = 26.87, ["Ride"] = 20.79, ["Fly|Ride"] = 41.99, ["Neon"] = 32.3, ["Neon|Ride"] = 62.99, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 262.5, ["Mega|Ride"] = 281.69, ["Mega|Fly|Ride"] = 246.87}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.36, ["Neon"] = 3.4, ["Neon|Ride"] = 28.25, ["Mega"] = 18.37, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 140.17, ["Neon"] = 5.16, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 159.33, ["Mega"] = 44.62, ["Mega|Ride"] = 87.84, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 45.92, ["Ride"] = 16.69, ["Fly|Ride"] = 78.08, ["Neon"] = 18.4, ["Neon|Ride"] = 28.49, ["Neon|Fly|Ride"] = 97.6, ["Mega"] = 148.73, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 281.69}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.5, ["Neon"] = 40.69, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 156.06, ["Mega"] = 328.13, ["Mega|Ride"] = 276.41, ["Mega|Fly|Ride"] = 422}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 2.5, ["Neon|Ride"] = 49.61, ["Neon|Fly|Ride"] = 80.1, ["Mega"] = 23.63, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 141.38, ["Mega|Fly|Ride"] = 141.38}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 17.07, ["Fly|Ride"] = 281316.31, ["Neon"] = 3.93, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 69.56, ["Mega"] = 30.19, ["Mega|Fly"] = 203.23, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 141.38}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 15.43, ["Ride"] = 18.38, ["Fly|Ride"] = 34.04, ["Neon"] = 3.94, ["Neon|Fly"] = 70.7, ["Neon|Ride"] = 23.37, ["Neon|Fly|Ride"] = 64.56, ["Mega"] = 65.63, ["Mega|Ride"] = 48.56, ["Mega|Fly|Ride"] = 158.29}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 31.03, ["Fly|Ride"] = 78.92, ["Neon"] = 3.59, ["Neon|Ride"] = 36.74, ["Neon|Fly|Ride"] = 84.41, ["Mega"] = 21.6, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 112.87}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 5.13, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 141.38, ["Mega"] = 18.25, ["Mega|Fly"] = 146.55, ["Mega|Ride"] = 77.44, ["Mega|Fly|Ride"] = 168.92}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 26.17, ["Ride"] = 52.5, ["Fly|Ride"] = 77.44, ["Neon"] = 4.24, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 27.44, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 114.19}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 3.03, ["Mega"] = 15.48, ["Mega|Ride"] = 141.39, ["Mega|Fly|Ride"] = 250.04}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 160.21, ["Neon|Fly|Ride"] = 420, ["Mega"] = 23.62, ["Mega|Fly"] = 119.55, ["Mega|Ride"] = 112.9, ["Mega|Fly|Ride"] = 333.38}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 28.5, ["Ride"] = 15.74, ["Fly|Ride"] = 39.38, ["Neon"] = 3.93, ["Neon|Fly"] = 72.01, ["Neon|Ride"] = 20.89, ["Neon|Fly|Ride"] = 104.98, ["Mega"] = 56.19, ["Mega|Fly"] = 51.19, ["Mega|Ride"] = 62.26, ["Mega|Fly|Ride"] = 143.46}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 10.5, ["Ride"] = 78.75, ["Neon"] = 91.88, ["Neon|Ride"] = 239.11, ["Mega"] = 389.64, ["Mega|Ride"] = 478.15, ["Mega|Fly|Ride"] = 944.18}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 6.57, ["Fly"] = 6562.49, ["Ride"] = 39, ["Neon"] = 117.13, ["Mega"] = 208.89, ["Mega|Ride"] = 348.48, ["Mega|Fly|Ride"] = 422}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 28.41, ["Fly|Ride"] = 422, ["Neon"] = 28.54, ["Mega"] = 119.55, ["Mega|Ride"] = 203.23, ["Mega|Fly|Ride"] = 296.87}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 16.93, ["Ride"] = 11.82, ["Fly|Ride"] = 35.88, ["Neon"] = 2.1, ["Neon|Fly"] = 17.22, ["Neon|Ride"] = 14, ["Neon|Fly|Ride"] = 26.25, ["Mega"] = 14.33, ["Mega|Fly"] = 27.56, ["Mega|Ride"] = 24.27, ["Mega|Fly|Ride"] = 45.93}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Fly|Ride"] = 70.7, ["Neon"] = 8.45, ["Neon|Fly"] = 84.29, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 703.65, ["Mega"] = 66.48, ["Mega|Ride"] = 141.38}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 31.66, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 79.05, ["Mega"] = 18.24, ["Mega|Fly"] = 78.07, ["Mega|Ride"] = 51.35, ["Mega|Fly|Ride"] = 103.56}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.67, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 52.5, ["Mega"] = 17.33, ["Mega|Ride"] = 101.3, ["Mega|Fly|Ride"] = 209.94}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 24.94, ["Ride"] = 16.14, ["Fly|Ride"] = 56.98, ["Neon"] = 17.07, ["Neon|Fly"] = 65.6, ["Neon|Ride"] = 31.65, ["Neon|Fly|Ride"] = 84.4, ["Mega"] = 143.22, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 288.27}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 192.04, ["Ride"] = 181.13, ["Fly|Ride"] = 262.5, ["Neon"] = 703.65, ["Neon|Ride"] = 1116.55, ["Neon|Fly|Ride"] = 1109.81, ["Mega"] = 8439.5, ["Mega|Fly|Ride"] = 3281.25}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Fly|Ride"] = 37.08, ["Neon"] = 3.93, ["Neon|Fly"] = 56.98, ["Neon|Ride"] = 68.25, ["Mega"] = 65.42, ["Mega|Ride"] = 197.29, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.93, ["Fly"] = 103.68, ["Ride"] = 24.28, ["Fly|Ride"] = 196.88, ["Neon"] = 33.77, ["Neon|Ride"] = 168.8, ["Neon|Fly|Ride"] = 159.31, ["Mega"] = 412.49, ["Mega|Ride"] = 564.37, ["Mega|Fly|Ride"] = 631.52}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 15.28, ["Fly|Ride"] = 36.66, ["Neon"] = 5.25, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 27.24, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 65.63, ["Mega|Fly"] = 95.64, ["Mega|Ride"] = 59.7, ["Mega|Fly|Ride"] = 122.39}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 27.44, ["Fly|Ride"] = 120.89, ["Neon"] = 8.39, ["Neon|Fly"] = 84.41, ["Neon|Ride"] = 82.3, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 124.5, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 209.94}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.54, ["Fly"] = 32.71, ["Ride"] = 18.38, ["Fly|Ride"] = 34.13, ["Neon"] = 30.19, ["Neon|Ride"] = 45.92, ["Neon|Fly|Ride"] = 91.88, ["Mega|Ride"] = 280.63, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 2.1, ["Fly"] = 28.48, ["Ride"] = 39.38, ["Fly|Ride"] = 247.07, ["Neon"] = 40.09, ["Neon|Ride"] = 137.45, ["Neon|Fly|Ride"] = 626.64, ["Mega"] = 327.48, ["Mega|Ride"] = 324.94, ["Mega|Fly|Ride"] = 398.35}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 14.44, ["Ride"] = 18.38, ["Fly|Ride"] = 42.21, ["Neon"] = 26.19, ["Neon|Fly"] = 83.35, ["Neon|Ride"] = 49.61, ["Neon|Fly|Ride"] = 64.39, ["Mega"] = 196.88, ["Mega|Fly"] = 384.01, ["Mega|Ride"] = 237.88, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 62.26, ["Fly"] = 91.88, ["Ride"] = 106.32, ["Fly|Ride"] = 171.97, ["Neon"] = 478.2, ["Neon|Fly"] = 405.57, ["Neon|Ride"] = 378, ["Neon|Fly|Ride"] = 419.88, ["Mega|Fly|Ride"] = 1573.69}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 196.88, ["Fly"] = 322.17, ["Ride"] = 223.13, ["Fly|Ride"] = 280.63, ["Neon"] = 913.33, ["Neon|Ride"] = 1594.72, ["Neon|Fly|Ride"] = 1594.62, ["Mega"] = 10549.35, ["Mega|Fly|Ride"] = 6565.94}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 71.77, ["Fly"] = 200.08, ["Ride"] = 65.63, ["Fly|Ride"] = 124.5, ["Neon"] = 379.25, ["Neon|Ride"] = 277.56, ["Neon|Fly|Ride"] = 375.27, ["Mega|Fly|Ride"] = 1377.46}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 2.23, ["Ride"] = 53.82, ["Fly|Ride"] = 141.38, ["Neon"] = 23, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 112.38, ["Mega"] = 156.15, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 319.17}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 9.19, ["Fly"] = 68.14, ["Ride"] = 35.44, ["Fly|Ride"] = 66.94, ["Neon"] = 125.72, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 141.38, ["Neon|Fly|Ride"] = 211.01, ["Mega"] = 351.75, ["Mega|Ride"] = 451.5, ["Mega|Fly|Ride"] = 470.51}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 18.09, ["Ride"] = 20.83, ["Fly|Ride"] = 52.77, ["Neon"] = 6.22, ["Neon|Fly"] = 129.94, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 86.51, ["Mega"] = 96.03, ["Mega|Fly"] = 212.79, ["Mega|Ride"] = 111.84, ["Mega|Fly|Ride"] = 194.13}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 5.25, ["Fly"] = 68.49, ["Ride"] = 26.25, ["Fly|Ride"] = 135.19, ["Neon"] = 40.61, ["Neon|Ride"] = 158.06, ["Neon|Fly|Ride"] = 134.93, ["Mega"] = 796.49, ["Mega|Ride"] = 485, ["Mega|Fly|Ride"] = 563.36}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 30.19, ["Ride"] = 16.77, ["Fly|Ride"] = 45.94, ["Neon"] = 9.08, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 36.93, ["Neon|Fly|Ride"] = 99.49, ["Mega"] = 131.25, ["Mega|Ride"] = 176.93, ["Mega|Fly|Ride"] = 175.88}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 3.93, ["Ride"] = 24.94, ["Fly|Ride"] = 328.13, ["Neon"] = 40.67, ["Neon|Ride"] = 77.99, ["Neon|Fly|Ride"] = 239.08, ["Mega"] = 207.37, ["Mega|Ride"] = 239.08, ["Mega|Fly|Ride"] = 457.47}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 33.78, ["Neon"] = 2.1, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 47.38, ["Mega"] = 17.07, ["Mega|Ride"] = 40.09, ["Mega|Fly|Ride"] = 225.78}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 20.34, ["Ride"] = 20.9, ["Fly|Ride"] = 48.54, ["Neon"] = 13.13, ["Neon|Fly"] = 105.51, ["Neon|Ride"] = 42.21, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 108.94, ["Mega|Ride"] = 96.49, ["Mega|Fly|Ride"] = 189.67}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 24.92, ["Ride"] = 18.06, ["Fly|Ride"] = 39.29, ["Neon"] = 19, ["Neon|Fly"] = 141.38, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 283.5, ["Mega|Ride"] = 208, ["Mega|Fly|Ride"] = 235.27}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 163.95, ["Fly"] = 200.82, ["Ride"] = 209.36, ["Fly|Ride"] = 271.64, ["Neon"] = 620.31, ["Neon|Ride"] = 564.38, ["Neon|Fly|Ride"] = 619.26, ["Mega|Ride"] = 3478.13, ["Mega|Fly|Ride"] = 2180.06}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 6.56, ["Ride"] = 41.88, ["Fly|Ride"] = 205.73, ["Neon"] = 45.94, ["Neon|Ride"] = 160.13, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 307.47, ["Mega|Ride"] = 358.7, ["Mega|Fly|Ride"] = 325.5}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Ride"] = 15.84, ["Fly|Ride"] = 70.21, ["Neon"] = 28.23, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 137.82, ["Mega|Ride"] = 261.79, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 25.31, ["Ride"] = 54.87, ["Fly|Ride"] = 178.5, ["Neon"] = 106.32, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 294.54, ["Mega"] = 419.88, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 2.1}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.1, ["Ride"] = 27.03, ["Neon"] = 32.71, ["Neon|Ride"] = 149.99, ["Neon|Fly|Ride"] = 183.58, ["Mega"] = 283.5, ["Mega|Ride"] = 313.69, ["Mega|Fly|Ride"] = 545.31}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 24.83, ["Fly"] = 35.88, ["Ride"] = 21.11, ["Fly|Ride"] = 49.88, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 176.18, ["Neon|Fly|Ride"] = 196.06, ["Mega"] = 2109.89, ["Mega|Ride"] = 702.89, ["Mega|Fly|Ride"] = 647.75}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 34.13, ["Fly|Ride"] = 78.75, ["Neon"] = 3.93, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 26.17, ["Mega|Ride"] = 82.3, ["Mega|Fly|Ride"] = 140.18}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 3.72, ["Fly"] = 26.25, ["Ride"] = 28.49, ["Fly|Ride"] = 62.26, ["Neon"] = 41.15, ["Neon|Ride"] = 112.9, ["Mega"] = 188.85, ["Mega|Fly"] = 399.27, ["Mega|Ride"] = 147, ["Mega|Fly|Ride"] = 248.98}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 45.39, ["Ride"] = 16.44, ["Fly|Ride"] = 56.98, ["Neon"] = 14.97, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 31.47, ["Neon|Fly|Ride"] = 72.1, ["Mega"] = 136.43, ["Mega|Ride"] = 140.33, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Neon"] = 3.83, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 31.66, ["Neon|Fly|Ride"] = 422, ["Mega"] = 31.5, ["Mega|Ride"] = 71.75, ["Mega|Fly|Ride"] = 104.46}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 31.49, ["Fly"] = 126.62, ["Ride"] = 52.5, ["Neon"] = 232.32, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 318.01, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 846.61, ["Mega|Ride"] = 774.38, ["Mega|Fly|Ride"] = 824.76}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.93, ["Ride"] = 39.38, ["Fly|Ride"] = 210, ["Neon"] = 69.57, ["Neon|Fly|Ride"] = 211.01, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 11.82, ["Fly"] = 56.99, ["Ride"] = 61.69, ["Fly|Ride"] = 52.5, ["Neon"] = 75.97, ["Neon|Fly"] = 211.01, ["Neon|Ride"] = 92.86, ["Neon|Fly|Ride"] = 420, ["Mega"] = 347.81, ["Mega|Ride"] = 473.68, ["Mega|Fly|Ride"] = 630.87}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 45.85, ["Fly"] = 433.13, ["Ride"] = 103.69, ["Fly|Ride"] = 262.44, ["Neon"] = 281.69, ["Neon|Ride"] = 316.5, ["Neon|Fly|Ride"] = 337.59, ["Mega|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 15.83, ["Fly"] = 39.38, ["Ride"] = 35.88, ["Fly|Ride"] = 62.99, ["Neon"] = 64.97, ["Neon|Ride"] = 83.35, ["Neon|Fly|Ride"] = 211.01, ["Mega"] = 422, ["Mega|Ride"] = 527.48, ["Mega|Fly|Ride"] = 430.34}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 78.75, ["Fly"] = 145.69, ["Ride"] = 119.44, ["Fly|Ride"] = 168.42, ["Neon"] = 203.43, ["Neon|Ride"] = 248.07, ["Neon|Fly|Ride"] = 361.26, ["Mega"] = 985.32, ["Mega|Ride"] = 956.3, ["Mega|Fly|Ride"] = 972.42}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 26.14, ["Ride"] = 82.69, ["Fly|Ride"] = 173.25, ["Neon"] = 83.35, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 294.34, ["Mega"] = 367.14, ["Mega|Ride"] = 281.69, ["Mega|Fly|Ride"] = 437.81}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 3.72, ["Fly"] = 69.5, ["Ride"] = 18.38, ["Fly|Ride"] = 302.78, ["Neon"] = 80.76, ["Neon|Ride"] = 84.92, ["Neon|Fly|Ride"] = 126.6, ["Mega"] = 105, ["Mega|Ride"] = 1054.95, ["Mega|Fly|Ride"] = 406.44}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 15.65, ["Ride"] = 80.07, ["Fly|Ride"] = 141.38, ["Neon"] = 89.25, ["Neon|Ride"] = 126.61, ["Neon|Fly|Ride"] = 141.38, ["Mega"] = 333.31, ["Mega|Fly"] = 420.93, ["Mega|Ride"] = 348.44, ["Mega|Fly|Ride"] = 532.23}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 9.6, ["Ride"] = 34.13, ["Fly|Ride"] = 139.26, ["Neon"] = 64.32, ["Neon|Ride"] = 94.46, ["Mega"] = 322.83, ["Mega|Ride"] = 422, ["Mega|Fly|Ride"] = 476.16}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Fly"] = 42.21, ["Neon|Ride"] = 55.95, ["Mega"] = 18.38, ["Mega|Fly"] = 141.38, ["Mega|Ride"] = 70.7, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 437.81, ["Neon"] = 14.16, ["Neon|Fly"] = 126.6, ["Neon|Ride"] = 83.83, ["Mega"] = 105.42, ["Mega|Ride"] = 233.16, ["Mega|Fly|Ride"] = 454.25}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Neon"] = 22.32, ["Neon|Ride"] = 104.46, ["Mega"] = 173.02, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 9.19, ["Ride"] = 31.44, ["Fly|Ride"] = 118.37, ["Neon"] = 17.77, ["Neon|Ride"] = 82.95, ["Neon|Fly|Ride"] = 274.3, ["Mega"] = 123.38, ["Mega|Ride"] = 152.97, ["Mega|Fly|Ride"] = 160.19}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 459.36, ["Ride"] = 525.11, ["Fly|Ride"] = 550.99, ["Neon|Ride"] = 1378.13, ["Neon|Fly|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 5840.63}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 6.57, ["Fly"] = 28.49, ["Ride"] = 21, ["Fly|Ride"] = 42.21, ["Neon"] = 52.5, ["Neon|Ride"] = 77.6, ["Neon|Fly|Ride"] = 210, ["Mega"] = 281.69, ["Mega|Ride"] = 278.25}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 11.71, ["Fly"] = 39.38, ["Ride"] = 27.44, ["Fly|Ride"] = 84.41, ["Neon"] = 70.7, ["Neon|Fly"] = 315, ["Neon|Ride"] = 59.06, ["Mega"] = 215.25, ["Mega|Ride"] = 246.75, ["Mega|Fly|Ride"] = 291.17}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 3.93, ["Fly"] = 28.5, ["Ride"] = 22.98, ["Fly|Ride"] = 316.5, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 223.13, ["Mega|Ride"] = 638.33, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 27.06, ["Fly|Ride"] = 941.48, ["Neon"] = 8.45, ["Neon|Ride"] = 42.21, ["Neon|Fly|Ride"] = 126.6, ["Mega"] = 59.07, ["Mega|Ride"] = 80.1, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 70.71, ["Ride"] = 70.61, ["Neon"] = 3.87, ["Neon|Ride"] = 31.13, ["Mega"] = 20.05, ["Mega|Ride"] = 76.13}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1554.72}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 6.45, ["Ride"] = 27.36, ["Neon"] = 72.19, ["Neon|Fly"] = 141.38, ["Neon|Ride"] = 67.53, ["Mega"] = 647.75, ["Mega|Ride"] = 548.58, ["Mega|Fly|Ride"] = 522.2}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 29.7, ["Neon"] = 5.25, ["Neon|Ride"] = 40.68, ["Mega"] = 179.36, ["Mega|Ride"] = 140.27, ["Mega|Fly|Ride"] = 229.04}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.61, ["Fly"] = 98.33, ["Ride"] = 24.28, ["Fly|Ride"] = 574.38, ["Neon"] = 13.05, ["Neon|Ride"] = 63.31, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 183.73, ["Mega|Ride"] = 156.15, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 393.75, ["Ride"] = 418.69, ["Fly|Ride"] = 458.07, ["Neon|Ride"] = 1458.19, ["Neon|Fly|Ride"] = 1470.6, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 4.87, ["Fly"] = 196.88, ["Ride"] = 72.19, ["Neon"] = 86.63, ["Neon|Ride"] = 131.25, ["Mega"] = 382.53, ["Mega|Ride"] = 278.52, ["Mega|Fly|Ride"] = 395.69}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Ride"] = 32.45, ["Neon"] = 4.87, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 113.95, ["Mega"] = 48.87, ["Mega|Fly"] = 189, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 240.54}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 843.96, ["Neon"] = 3.91, ["Neon|Ride"] = 98.28, ["Neon|Fly|Ride"] = 267.96, ["Mega"] = 22.31, ["Mega|Ride"] = 141.38, ["Mega|Fly|Ride"] = 194.13}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 11.03, ["Fly"] = 56.27, ["Ride"] = 32.82, ["Fly|Ride"] = 156.15, ["Neon"] = 91.88, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 281.69, ["Mega|Ride"] = 338.3, ["Mega|Fly|Ride"] = 372.75}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 15.73, ["Ride"] = 109.72, ["Fly|Ride"] = 105.51, ["Neon"] = 104.46, ["Neon|Ride"] = 112.12, ["Neon|Fly|Ride"] = 838.69, ["Mega"] = 563.36, ["Mega|Ride"] = 561.24, ["Mega|Fly|Ride"] = 1086.11}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 6.02, ["Ride"] = 26.25, ["Fly|Ride"] = 99.18, ["Neon"] = 141.37, ["Neon|Ride"] = 200.82, ["Mega"] = 626.07, ["Mega|Ride"] = 422, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 13.13, ["Ride"] = 37.08, ["Fly|Ride"] = 262.5, ["Neon"] = 160.21, ["Neon|Ride"] = 156.13, ["Neon|Fly|Ride"] = 511.87, ["Mega"] = 525, ["Mega|Ride"] = 420.93, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 375.61, ["Ride"] = 396.46, ["Fly|Ride"] = 616.88, ["Neon"] = 1407.3, ["Neon|Ride"] = 797.37, ["Neon|Fly|Ride"] = 1053.89, ["Mega|Ride"] = 3797.78, ["Mega|Fly|Ride"] = 3502.99}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 3.72, ["Fly"] = 28.3, ["Ride"] = 28.49, ["Fly|Ride"] = 84.79, ["Neon"] = 98.44, ["Neon|Ride"] = 138.44, ["Neon|Fly|Ride"] = 137.64, ["Mega"] = 525, ["Mega|Ride"] = 538.59, ["Mega|Fly|Ride"] = 728.98}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 13.06, ["Ride"] = 118.11, ["Neon|Fly|Ride"] = 160.19, ["Mega"] = 1265.94, ["Mega|Fly|Ride"] = 1687.91}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 18.38, ["Ride"] = 60.37, ["Fly|Ride"] = 163.53, ["Neon"] = 45.94, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 210, ["Mega"] = 217.88, ["Mega|Ride"] = 219.03, ["Mega|Fly|Ride"] = 329.44}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.51, ["Ride"] = 42, ["Fly|Ride"] = 117.11, ["Neon"] = 14.43, ["Neon|Ride"] = 45.14, ["Mega"] = 44.6, ["Mega|Ride"] = 78.74, ["Mega|Fly|Ride"] = 239.08}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 55.13, ["Ride"] = 80.12, ["Neon"] = 323.89, ["Neon|Ride"] = 295.4, ["Neon|Fly|Ride"] = 474.74, ["Mega"] = 2531.86, ["Mega|Ride"] = 1355.54, ["Mega|Fly|Ride"] = 1259.62}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.63, ["Fly"] = 597.98, ["Ride"] = 31.4, ["Neon"] = 10.28, ["Neon|Fly"] = 156.96, ["Neon|Ride"] = 40.6, ["Neon|Fly|Ride"] = 157.05, ["Mega"] = 78.07, ["Mega|Ride"] = 97.75, ["Mega|Fly|Ride"] = 221.82}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 41.74, ["Ride"] = 28.49, ["Fly|Ride"] = 99.18, ["Neon"] = 6.3, ["Neon|Fly"] = 422, ["Neon|Ride"] = 46.34, ["Neon|Fly|Ride"] = 91.81, ["Mega"] = 42.84, ["Mega|Ride"] = 105.26, ["Mega|Fly|Ride"] = 206.73}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 3.93, ["Ride"] = 38.06, ["Fly|Ride"] = 111.51, ["Neon"] = 35.69, ["Neon|Ride"] = 66.48, ["Neon|Fly|Ride"] = 703.65, ["Mega"] = 160.19, ["Mega|Fly"] = 632.98, ["Mega|Ride"] = 239.48, ["Mega|Fly|Ride"] = 494.82}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 70.2, ["Fly"] = 99.2, ["Ride"] = 110.25, ["Fly|Ride"] = 319.23, ["Neon"] = 485.63, ["Neon|Ride"] = 509.25, ["Mega|Ride"] = 1125.63, ["Mega|Fly|Ride"] = 1355.82}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 262.5, ["Ride"] = 292.29, ["Fly|Ride"] = 341.25, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 916.13, ["Mega"] = 12659.24, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 5.16, ["Ride"] = 33.63, ["Neon"] = 40.01, ["Neon|Ride"] = 138.21, ["Mega"] = 98.44, ["Mega|Fly"] = 253.2, ["Mega|Ride"] = 185.07, ["Mega|Fly|Ride"] = 411.44}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 5.25, ["Ride"] = 36.93, ["Neon"] = 24.04, ["Neon|Fly|Ride"] = 211.01, ["Mega"] = 91.82, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.93, ["Fly"] = 155.57, ["Ride"] = 27.57, ["Neon"] = 32.82, ["Mega"] = 517.79, ["Mega|Ride"] = 337.84}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 28.46, ["Ride"] = 20.98, ["Fly|Ride"] = 78.08, ["Neon"] = 6.18, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 90.09, ["Mega"] = 51.05, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 251.08}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 36.8, ["Fly|Ride"] = 210.68, ["Neon"] = 7.87, ["Neon|Ride"] = 52.5, ["Mega"] = 30.09, ["Mega|Fly"] = 141.38, ["Mega|Ride"] = 205.73}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 18.38, ["Fly|Ride"] = 41.93, ["Neon"] = 3.98, ["Neon|Fly"] = 47.84, ["Neon|Ride"] = 28.49, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 39.38, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 128.62}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 21.12, ["Fly|Ride"] = 63.31, ["Neon"] = 8.97, ["Neon|Fly"] = 74.13, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 91.8, ["Mega"] = 170.63, ["Mega|Ride"] = 201.51, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 32.96, ["Ride"] = 52.49, ["Fly|Ride"] = 83.65, ["Neon"] = 197.29, ["Neon|Ride"] = 160.21, ["Mega"] = 393.75, ["Mega|Fly"] = 498.75, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 69.57, ["Fly"] = 582.75, ["Ride"] = 102.38, ["Fly|Ride"] = 422, ["Neon"] = 363.57, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 702.6, ["Mega|Ride"] = 2248.09, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 23.23, ["Fly|Ride"] = 131.25, ["Neon"] = 5.25, ["Neon|Fly"] = 78.75, ["Mega"] = 53.44, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 87.94}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 16.77, ["Ride"] = 19, ["Fly|Ride"] = 30.15, ["Neon"] = 3.94, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 68.16, ["Mega"] = 44.23, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 3.56, ["Ride"] = 23.93, ["Fly|Ride"] = 141.38, ["Neon"] = 35.88, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 105, ["Mega"] = 627.38, ["Mega|Ride"] = 352.35, ["Mega|Fly|Ride"] = 472.38}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 363.82, ["Fly"] = 393.75, ["Ride"] = 465.25, ["Fly|Ride"] = 337.59, ["Neon|Ride"] = 1476.92, ["Mega"] = 7969.45, ["Mega|Fly|Ride"] = 5274.68}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 28.23, ["Fly"] = 141.4, ["Ride"] = 65.09, ["Fly|Ride"] = 128.71, ["Neon"] = 195.57, ["Neon|Ride"] = 223.57, ["Neon|Fly|Ride"] = 217.88, ["Mega"] = 1082.38, ["Mega|Ride"] = 1160.44, ["Mega|Fly|Ride"] = 971.27}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Fly|Ride"] = 78.07, ["Neon"] = 10.4, ["Neon|Ride"] = 99.18, ["Neon|Fly|Ride"] = 141.38, ["Mega"] = 82.69, ["Mega|Ride"] = 116.84, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 211.03, ["Ride"] = 28.87, ["Fly|Ride"] = 142.7, ["Neon"] = 22.23, ["Neon|Ride"] = 168.8, ["Mega"] = 197.29}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 29.89, ["Fly"] = 78.07, ["Ride"] = 43.32, ["Fly|Ride"] = 77.44, ["Neon|Fly"] = 125.55, ["Neon|Ride"] = 119.57, ["Neon|Fly|Ride"] = 209.94, ["Mega"] = 2531.86, ["Mega|Ride"] = 949.46, ["Mega|Fly|Ride"] = 1275.46}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 105.45, ["Ride"] = 98.74, ["Fly|Ride"] = 144.38, ["Neon"] = 414.86, ["Neon|Ride"] = 469.88, ["Neon|Fly|Ride"] = 479.07, ["Mega"] = 3095.19, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 239.78, ["Fly"] = 281.06, ["Ride"] = 246.75, ["Fly|Ride"] = 379.79, ["Neon"] = 985.32, ["Neon|Ride"] = 872.82, ["Neon|Fly|Ride"] = 930.57, ["Mega|Fly|Ride"] = 2813.52}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 14.44, ["Ride"] = 7384.56, ["Fly|Ride"] = 219.98, ["Neon"] = 91.8, ["Neon|Ride"] = 133.06, ["Neon|Fly|Ride"] = 323.89, ["Mega"] = 386.01, ["Mega|Ride"] = 405.8, ["Mega|Fly|Ride"] = 533.18}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.5, ["Ride"] = 14.37, ["Fly|Ride"] = 40.05, ["Neon"] = 7.87, ["Neon|Ride"] = 31.66, ["Neon|Fly|Ride"] = 84.41, ["Mega"] = 90.57, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.1, ["Fly"] = 33.64, ["Ride"] = 25.87, ["Fly|Ride"] = 70.7, ["Neon"] = 37.89, ["Neon|Fly"] = 21.08, ["Neon|Ride"] = 56.98, ["Neon|Fly|Ride"] = 112.56, ["Mega"] = 250.79, ["Mega|Ride"] = 232.32, ["Mega|Fly|Ride"] = 359.12}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 255.94, ["Ride"] = 315, ["Fly|Ride"] = 406.88, ["Neon"] = 2057.14, ["Neon|Ride"] = 1687.91, ["Neon|Fly|Ride"] = 1829.27, ["Mega|Fly|Ride"] = 4779.92}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 46.44, ["Neon"] = 8.39, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 41.97, ["Mega|Ride"] = 156.15, ["Mega|Fly|Ride"] = 280.63}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.83, ["Ride"] = 20.05, ["Fly|Ride"] = 66.63, ["Neon"] = 30.87, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 167.11, ["Mega|Fly"] = 204.9, ["Mega|Ride"] = 234.22, ["Mega|Fly|Ride"] = 314.89}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 21.11, ["Ride"] = 112.4, ["Neon"] = 104.9, ["Neon|Fly"] = 422, ["Neon|Ride"] = 152.25, ["Neon|Fly|Ride"] = 478.15, ["Mega"] = 466.48, ["Mega|Ride"] = 496.55, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 124.69, ["Fly"] = 280.66, ["Ride"] = 139.86, ["Fly|Ride"] = 197.29, ["Neon|Ride"] = 727.13, ["Neon|Fly|Ride"] = 542.32, ["Mega|Fly|Ride"] = 2940.12}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 23.68, ["Fly"] = 45.05, ["Ride"] = 32.82, ["Fly|Ride"] = 49.48, ["Neon"] = 76.13, ["Neon|Ride"] = 98.41, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 443.09, ["Mega|Ride"] = 423.17, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.89, ["Neon|Ride"] = 204.44, ["Neon|Fly|Ride"] = 703.65, ["Mega"] = 20.98, ["Mega|Ride"] = 70.7, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 17.95, ["Fly|Ride"] = 52.5, ["Neon"] = 2.59, ["Neon|Fly"] = 160.21, ["Neon|Ride"] = 27.2, ["Neon|Fly|Ride"] = 69.18, ["Mega"] = 47.82, ["Mega|Fly"] = 141.96, ["Mega|Ride"] = 62.18, ["Mega|Fly|Ride"] = 103.36}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 11.71, ["Fly"] = 91.88, ["Ride"] = 52.5, ["Fly|Ride"] = 154.04, ["Neon"] = 30.19, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 153.57, ["Mega"] = 149.41, ["Mega|Fly"] = 281.69, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 279.72}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1407, ["Ride"] = 1311.19, ["Fly|Ride"] = 1299.38, ["Neon|Ride"] = 7033.26, ["Neon|Fly|Ride"] = 4331.25, ["Mega"] = 18144.9, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 408.18, ["Ride"] = 446.25, ["Fly|Ride"] = 618.19, ["Neon"] = 1903.11, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 2232.95, ["Mega"] = 14344.28, ["Mega|Fly|Ride"] = 7084.87}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 281.72, ["Fly"] = 371.44, ["Ride"] = 328.13, ["Fly|Ride"] = 420, ["Neon"] = 734.99, ["Neon|Fly"] = 1275.54, ["Neon|Ride"] = 623.44, ["Neon|Fly|Ride"] = 761.25, ["Mega|Fly|Ride"] = 2799.82}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 328.13, ["Ride"] = 383.31, ["Fly|Ride"] = 501.38, ["Neon"] = 1023.75, ["Neon|Fly"] = 3188.22, ["Neon|Ride"] = 1125.63, ["Neon|Fly|Ride"] = 1022.44, ["Mega|Ride"] = 3675, ["Mega|Fly|Ride"] = 3940.2}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Ride"] = 17.04, ["Fly|Ride"] = 44.63, ["Neon"] = 6.3, ["Neon|Ride"] = 15.84, ["Neon|Fly|Ride"] = 79.13, ["Mega"] = 80.1, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 141.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 393.75, ["Fly"] = 797.7, ["Ride"] = 459.38, ["Fly|Ride"] = 551.25, ["Neon"] = 1181.25, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 6329.63, ["Mega|Fly|Ride"] = 4914}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.1, ["Fly"] = 183.75, ["Ride"] = 25.33, ["Neon"] = 7.87, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 112.22, ["Mega"] = 57.39, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 207.8}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 21.12, ["Ride"] = 21.12, ["Fly|Ride"] = 39.38, ["Neon"] = 14.37, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 105.51, ["Mega"] = 91.77, ["Mega|Ride"] = 192.93, ["Mega|Fly|Ride"] = 314.74}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 3.82, ["Neon|Fly"] = 80.12, ["Neon|Ride"] = 39.37, ["Mega"] = 32.45, ["Mega|Fly"] = 84.41, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 39.29, ["Ride"] = 65.63, ["Fly|Ride"] = 459.38, ["Neon"] = 244.13, ["Neon|Ride"] = 349.44, ["Neon|Fly|Ride"] = 315.45, ["Mega"] = 1687.91, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.63, ["Fly"] = 65.62, ["Ride"] = 19.69, ["Fly|Ride"] = 60.43, ["Neon"] = 34.69, ["Mega"] = 328.13, ["Mega|Ride"] = 233.63}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.12, ["Neon"] = 3.94, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 36.57, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 35.41, ["Mega|Fly"] = 703.65, ["Mega|Ride"] = 91.24, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 32.44, ["Ride"] = 23.99, ["Fly|Ride"] = 56.98, ["Neon"] = 8.31, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 70.24, ["Mega"] = 57.75, ["Mega|Fly"] = 175.14, ["Mega|Ride"] = 82.69, ["Mega|Fly|Ride"] = 153.12}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 6.93, ["Fly"] = 47.85, ["Ride"] = 42.14, ["Fly|Ride"] = 51.45, ["Neon"] = 105.51, ["Neon|Fly"] = 143.48, ["Neon|Ride"] = 70.7, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 237.57, ["Mega|Ride"] = 300.57, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 11.38, ["Ride"] = 40.67, ["Neon"] = 59.09, ["Neon|Ride"] = 70.7, ["Mega"] = 399.27, ["Mega|Ride"] = 337.59, ["Mega|Fly|Ride"] = 344.98}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.63, ["Ride"] = 27.44, ["Fly|Ride"] = 70.7, ["Neon"] = 141.38, ["Neon|Ride"] = 80.01, ["Neon|Fly|Ride"] = 281.69, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 19.85, ["Ride"] = 19.69, ["Fly|Ride"] = 56.21, ["Neon"] = 3.94, ["Neon|Fly"] = 31.66, ["Neon|Ride"] = 26.25, ["Mega"] = 43.32, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 316.5}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 170.63, ["Fly"] = 366.12, ["Ride"] = 258.57, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 1146.72, ["Neon|Fly|Ride"] = 1102.5, ["Mega"] = 10549.35, ["Mega|Fly|Ride"] = 4501.43}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 34.09, ["Ride"] = 16.89, ["Fly|Ride"] = 41.86, ["Neon"] = 3.35, ["Neon|Fly"] = 21.12, ["Neon|Ride"] = 25.14, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 46.44, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 79.25}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 13.13, ["Ride"] = 26.25, ["Fly|Ride"] = 179.36, ["Neon"] = 57.74, ["Neon|Ride"] = 68.25, ["Mega"] = 379.32, ["Mega|Ride"] = 434.65, ["Mega|Fly|Ride"] = 632.98}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 38.41, ["Fly"] = 131.25, ["Ride"] = 88.49, ["Fly|Ride"] = 170.63, ["Neon"] = 253.2, ["Neon|Ride"] = 295.43, ["Mega"] = 839.74, ["Mega|Ride"] = 808.54, ["Mega|Fly|Ride"] = 936.8}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 183.75, ["Ride"] = 224.44, ["Fly|Ride"] = 309.58, ["Neon"] = 797.37, ["Neon|Ride"] = 651, ["Neon|Fly|Ride"] = 656.25, ["Mega|Ride"] = 3375.81, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 17.07, ["Fly"] = 168.88, ["Neon"] = 82.69, ["Neon|Ride"] = 281.69, ["Mega"] = 285.48, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 703.65}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 32.81, ["Ride"] = 422, ["Fly|Ride"] = 158.81, ["Neon"] = 290.97, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 843.96, ["Mega|Fly|Ride"] = 935.82}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1287.19, ["Fly"] = 1441.13, ["Ride"] = 1155, ["Fly|Ride"] = 1076.25, ["Neon"] = 4079.45, ["Neon|Ride"] = 5063.69, ["Neon|Fly|Ride"] = 4975.14, ["Mega|Fly|Ride"] = 17161.7}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 5.16, ["Fly"] = 25.34, ["Ride"] = 22.05, ["Fly|Ride"] = 53.82, ["Neon"] = 64.58, ["Neon|Fly"] = 75.06, ["Neon|Ride"] = 78.08, ["Neon|Fly|Ride"] = 200.82, ["Mega"] = 252.15, ["Mega|Ride"] = 248.64, ["Mega|Fly|Ride"] = 388.5}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 7.88, ["Fly"] = 13769.7, ["Ride"] = 35.43, ["Neon"] = 28.49, ["Neon|Ride"] = 140.39, ["Mega"] = 212.63, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 422}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 5.24, ["Ride"] = 31.56, ["Fly|Ride"] = 91.33, ["Neon"] = 36.74, ["Mega"] = 245.44, ["Mega|Ride"] = 418.69, ["Mega|Fly|Ride"] = 630.87}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 18.36, ["Fly"] = 703.74, ["Ride"] = 39.38, ["Fly|Ride"] = 141.39, ["Neon"] = 87.94, ["Neon|Ride"] = 98.98, ["Neon|Fly|Ride"] = 211.32, ["Mega"] = 527.48, ["Mega|Ride"] = 416.96, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.1, ["Fly"] = 28.5, ["Ride"] = 24.28, ["Fly|Ride"] = 66.96, ["Neon"] = 21.8, ["Neon|Ride"] = 45.38, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 129.94, ["Mega|Ride"] = 273.26, ["Mega|Fly|Ride"] = 350.25}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Fly"] = 416.77, ["Neon"] = 141.38, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 56.9, ["Neon|Fly|Ride"] = 141.38, ["Mega"] = 233.36, ["Mega|Ride"] = 131.14}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 255.33, ["Ride"] = 334.69, ["Fly|Ride"] = 337.59, ["Neon|Ride"] = 1476.92, ["Neon|Fly|Ride"] = 1265.94, ["Mega|Ride"] = 4641.73, ["Mega|Fly|Ride"] = 4894.92}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 70.71, ["Ride"] = 28.28, ["Fly|Ride"] = 59.07, ["Neon"] = 9.08, ["Neon|Fly"] = 84.41, ["Neon|Ride"] = 45.85, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 112.88, ["Mega|Ride"] = 90.45, ["Mega|Fly|Ride"] = 478.15}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 6.56, ["Ride"] = 412.49, ["Neon|Ride"] = 313.85, ["Mega"] = 278.52, ["Mega|Ride"] = 281.69}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.93, ["Fly"] = 58.41, ["Ride"] = 40.11, ["Neon"] = 21.54, ["Neon|Fly"] = 70.7, ["Neon|Ride"] = 126.6, ["Neon|Fly|Ride"] = 280.93, ["Mega"] = 141.38, ["Mega|Fly"] = 422, ["Mega|Ride"] = 125.99, ["Mega|Fly|Ride"] = 275.52}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 183.74, ["Fly"] = 337.64, ["Ride"] = 262.5, ["Fly|Ride"] = 664.13, ["Neon"] = 936.8, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 947.35, ["Mega|Ride"] = 2813.52, ["Mega|Fly|Ride"] = 2165.62}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 27.56, ["Fly"] = 61.88, ["Ride"] = 41.16, ["Fly|Ride"] = 112.9, ["Neon"] = 181.33, ["Neon|Ride"] = 162.48, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 540.14, ["Mega|Ride"] = 632.98, ["Mega|Fly|Ride"] = 715.32}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 20.98, ["Ride"] = 38.96, ["Fly|Ride"] = 1265.94, ["Neon"] = 85.32, ["Neon|Ride"] = 133.88, ["Neon|Fly|Ride"] = 257.25, ["Mega"] = 459.38, ["Mega|Ride"] = 525.29, ["Mega|Fly|Ride"] = 830.25}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.15, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.35, ["Mega"] = 30.83, ["Mega|Ride"] = 223.65, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 77.44, ["Fly"] = 132.96, ["Ride"] = 118.13, ["Fly|Ride"] = 183.73, ["Neon"] = 382.56, ["Neon|Fly"] = 471.77, ["Neon|Fly|Ride"] = 380.62, ["Mega|Fly|Ride"] = 1182.9}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 18.83, ["Neon"] = 6.57, ["Neon|Ride"] = 56.98, ["Neon|Fly|Ride"] = 588, ["Mega"] = 32.08, ["Mega|Ride"] = 211.01}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 26.24, ["Fly"] = 127.98, ["Ride"] = 31.4, ["Fly|Ride"] = 89.67, ["Neon"] = 86.51, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 141.38, ["Mega"] = 389.82, ["Mega|Ride"] = 408.19, ["Mega|Fly|Ride"] = 394.25}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 38.06, ["Fly"] = 79.92, ["Ride"] = 90.57, ["Fly|Ride"] = 179.82, ["Neon"] = 281.69, ["Neon|Ride"] = 278.67, ["Neon|Fly|Ride"] = 318.73, ["Mega|Ride"] = 1189.98, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 15.7, ["Ride"] = 16.78, ["Fly|Ride"] = 32.48, ["Neon"] = 2.1, ["Neon|Fly"] = 27.72, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 42.99, ["Mega"] = 23.63, ["Mega|Fly"] = 55.13, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 66.94}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.68, ["Ride"] = 28.71, ["Fly|Ride"] = 1346.59, ["Neon"] = 23.07, ["Neon|Ride"] = 95.53, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 177.19, ["Mega|Ride"] = 211.01, ["Mega|Fly|Ride"] = 535.54}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 19.67, ["Fly"] = 141.4, ["Ride"] = 56.44, ["Neon"] = 131.25, ["Neon|Ride"] = 349.13, ["Neon|Fly|Ride"] = 605.55, ["Mega"] = 586.69, ["Mega|Ride"] = 542.25, ["Mega|Fly|Ride"] = 651}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.76, ["Neon"] = 2.63, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 137.16, ["Mega"] = 20.04, ["Mega|Ride"] = 65.54}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 3.5, ["Fly"] = 210, ["Ride"] = 28.25, ["Fly|Ride"] = 111.57, ["Neon"] = 73.5, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 223.67, ["Mega"] = 301.88, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 265.4, ["Mega|Fly|Ride"] = 422}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 23.63, ["Fly"] = 41.88, ["Ride"] = 26.17, ["Fly|Ride"] = 46.6, ["Neon"] = 129.68, ["Neon|Ride"] = 64.56, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 563.36, ["Mega|Fly|Ride"] = 1115.77}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 2.1, ["Ride"] = 59.79, ["Fly|Ride"] = 76.01, ["Neon"] = 25.7, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.44, ["Mega"] = 183.58, ["Mega|Ride"] = 190.12, ["Mega|Fly|Ride"] = 229.69}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 15.73, ["Fly"] = 2110.14, ["Ride"] = 85.56, ["Fly|Ride"] = 102.83, ["Neon"] = 160.21, ["Neon|Ride"] = 388.5, ["Neon|Fly|Ride"] = 6374.85, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1149.11}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 125.58, ["Fly|Ride"] = 196.88, ["Neon"] = 6.57, ["Neon|Fly"] = 50.66, ["Neon|Ride"] = 70.7, ["Mega"] = 74.82, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 122.39}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 28.49, ["Neon"] = 3.93, ["Mega"] = 21.11, ["Mega|Ride"] = 154.04, ["Mega|Fly|Ride"] = 434.44}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 32.82}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 48.55, ["Fly"] = 102.38, ["Ride"] = 78.75, ["Fly|Ride"] = 117.11, ["Neon"] = 1050, ["Neon|Ride"] = 281.69, ["Neon|Fly|Ride"] = 1054.95, ["Mega"] = 985.32, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 780.93}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 84, ["Fly|Ride"] = 141.38, ["Neon"] = 3.29, ["Mega"] = 23.23, ["Mega|Fly"] = 137.82, ["Mega|Ride"] = 105.51, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 506.63, ["Ride"] = 472.49, ["Fly|Ride"] = 393.75, ["Neon"] = 2625, ["Neon|Fly|Ride"] = 2391.55, ["Mega"] = 16878.98, ["Mega|Fly|Ride"] = 14066.52}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 2.61, ["Fly"] = 25.71, ["Ride"] = 19.69, ["Fly|Ride"] = 79.13, ["Neon"] = 19, ["Neon|Ride"] = 278.52, ["Mega"] = 74.91, ["Mega|Ride"] = 141.38, ["Mega|Fly|Ride"] = 563.36}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.1, ["Fly"] = 160.27, ["Ride"] = 18.38, ["Fly|Ride"] = 55.13, ["Neon"] = 15.75, ["Neon|Ride"] = 35.6, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 279.57, ["Mega|Ride"] = 140.54, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 12.6, ["Ride"] = 76.13, ["Fly|Ride"] = 106.31, ["Neon"] = 91.88, ["Neon|Ride"] = 181.13, ["Mega"] = 504.28, ["Mega|Ride"] = 382.53, ["Mega|Fly|Ride"] = 522.2}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.93, ["Fly"] = 39.38, ["Ride"] = 31.5, ["Fly|Ride"] = 141.38, ["Mega"] = 255.94}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 13.12, ["Ride"] = 56.98, ["Fly|Ride"] = 157.45, ["Neon"] = 77.44, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 95.64, ["Mega"] = 465.25, ["Mega|Ride"] = 464.19, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 6.45, ["Fly"] = 105, ["Ride"] = 48.54, ["Fly|Ride"] = 189.9, ["Neon"] = 49.83, ["Neon|Ride"] = 137.16, ["Neon|Fly|Ride"] = 141.38, ["Mega"] = 168, ["Mega|Fly"] = 489.5, ["Mega|Ride"] = 393.75}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 24.94, ["Ride"] = 15.75, ["Fly|Ride"] = 32.71, ["Neon"] = 2.1, ["Neon|Ride"] = 21.11, ["Neon|Fly|Ride"] = 74.46, ["Mega"] = 19.41, ["Mega|Fly"] = 60.78, ["Mega|Ride"] = 27.44, ["Mega|Fly|Ride"] = 145.04}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 10.5, ["Ride"] = 27.57, ["Fly|Ride"] = 160.21, ["Neon"] = 27.46, ["Neon|Fly"] = 119.57, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 316.5, ["Mega"] = 170.63, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 281.69}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 293.24, ["Ride"] = 315.45, ["Fly|Ride"] = 380.63, ["Neon"] = 1480.5, ["Neon|Ride"] = 1105.58, ["Neon|Fly|Ride"] = 1125.63, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 80.14, ["Fly"] = 156.16, ["Ride"] = 149.63, ["Fly|Ride"] = 239.13, ["Neon|Ride"] = 502.88, ["Neon|Fly|Ride"] = 623.44, ["Mega"] = 4219.76, ["Mega|Ride"] = 1730.1, ["Mega|Fly|Ride"] = 1603.88}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 23.23, ["Ride"] = 18.94, ["Fly|Ride"] = 21.12, ["Neon"] = 19.69, ["Neon|Fly"] = 28.49, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 62.67, ["Mega"] = 99.18, ["Mega|Fly"] = 209.94, ["Mega|Ride"] = 91.8, ["Mega|Fly|Ride"] = 153.08}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 18.27, ["Ride"] = 15.54, ["Fly|Ride"] = 26.25, ["Neon"] = 6.56, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 72.17, ["Mega"] = 84, ["Mega|Fly"] = 352.35, ["Mega|Ride"] = 108.67, ["Mega|Fly|Ride"] = 159.31}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.97, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 38.07, ["Neon|Fly|Ride"] = 422, ["Mega"] = 141.38, ["Mega|Ride"] = 209.94, ["Mega|Fly|Ride"] = 268.82}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 223.13, ["Ride"] = 249.38, ["Fly|Ride"] = 278.52, ["Neon|Ride"] = 944.99, ["Neon|Fly|Ride"] = 1434.45, ["Mega|Ride"] = 8439.5, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 18.14, ["Fly|Ride"] = 26.25, ["Neon"] = 28.88, ["Neon|Fly"] = 160.21, ["Neon|Ride"] = 56.98, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 352.35, ["Mega|Ride"] = 257.42, ["Mega|Fly|Ride"] = 262.48}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 5.23, ["Fly"] = 160.27, ["Ride"] = 42.21, ["Fly|Ride"] = 211.01, ["Neon"] = 34.13, ["Neon|Ride"] = 74.84, ["Mega"] = 196.88, ["Mega|Ride"] = 236.24, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.94, ["Neon|Ride"] = 30.09, ["Mega"] = 39, ["Mega|Ride"] = 95.7, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 11.82, ["Fly"] = 563.41, ["Ride"] = 19.69, ["Fly|Ride"] = 70.88, ["Neon"] = 141.38, ["Neon|Ride"] = 103.61, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 728.34, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 415.96}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 52.48, ["Fly"] = 114.19, ["Ride"] = 99.23, ["Fly|Ride"] = 196.07, ["Neon"] = 141.38, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 194.48, ["Neon|Fly|Ride"] = 312.38, ["Mega"] = 459.38, ["Mega|Fly"] = 2215.38, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 622.12}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 21.11, ["Fly"] = 47.85, ["Ride"] = 53.81, ["Fly|Ride"] = 84.97, ["Neon"] = 111.84, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 181.47, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 797.32, ["Mega|Fly|Ride"] = 797.32}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 16.95, ["Ride"] = 15.72, ["Fly|Ride"] = 32.45, ["Neon"] = 2.63, ["Neon|Fly"] = 23.55, ["Neon|Ride"] = 21.12, ["Neon|Fly|Ride"] = 62.26, ["Mega"] = 24.28, ["Mega|Fly"] = 36.75, ["Mega|Ride"] = 45.38, ["Mega|Fly|Ride"] = 114.35}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 204.74, ["Fly"] = 278.24, ["Ride"] = 253.2, ["Fly|Ride"] = 357.15, ["Neon"] = 1257.48, ["Neon|Ride"] = 958.13, ["Neon|Fly|Ride"] = 1265.94, ["Mega|Fly|Ride"] = 4199.99}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 12.85, ["Fly"] = 140.39, ["Ride"] = 42.21, ["Neon"] = 105, ["Neon|Ride"] = 225.78, ["Neon|Fly|Ride"] = 321.56, ["Mega|Fly|Ride"] = 589.32}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 16.37, ["Ride"] = 18.38, ["Fly|Ride"] = 39.3, ["Neon"] = 6.35, ["Neon|Fly"] = 27.57, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 111.84, ["Mega"] = 49.24, ["Mega|Fly"] = 180.41, ["Mega|Ride"] = 141.38, ["Mega|Fly|Ride"] = 141.38}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.05, ["Fly"] = 28.5, ["Ride"] = 17.07, ["Fly|Ride"] = 53.82, ["Neon"] = 2.88, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 27.08, ["Mega|Fly"] = 141.38, ["Mega|Ride"] = 62.26, ["Mega|Fly|Ride"] = 137.71}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 15.84, ["Fly|Ride"] = 91.8, ["Neon"] = 9.01, ["Neon|Fly|Ride"] = 7033.26, ["Mega"] = 93.03, ["Mega|Fly|Ride"] = 386.12}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 13.01, ["Fly"] = 53.44, ["Ride"] = 23.89, ["Fly|Ride"] = 50.76, ["Neon"] = 56.6, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 123.37, ["Mega"] = 357.42, ["Mega|Fly"] = 797.32, ["Mega|Ride"] = 315.15, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 10.5, ["Fly|Ride"] = 72.19, ["Neon"] = 39.38, ["Neon|Ride"] = 42.84, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 236.25, ["Mega|Ride"] = 322.83, ["Mega|Fly|Ride"] = 343.93}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 44.63, ["Neon"] = 3.93, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 84, ["Mega"] = 31.48, ["Mega|Ride"] = 141.38}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 11.61, ["Ride"] = 36.93, ["Fly|Ride"] = 84.41, ["Neon"] = 21, ["Neon|Fly"] = 102.92, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 157.5, ["Mega|Fly"] = 267.96, ["Mega|Ride"] = 219.43, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 126.6, ["Fly|Ride"] = 99.18, ["Neon"] = 4.47, ["Neon|Fly"] = 84.41, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 160.19, ["Mega"] = 47.25, ["Mega|Ride"] = 91.34, ["Mega|Fly|Ride"] = 319.17}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 24.61, ["Ride"] = 17.05, ["Fly|Ride"] = 83.91, ["Neon"] = 7.87, ["Neon|Ride"] = 31.11, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 65.63, ["Mega|Ride"] = 71.29, ["Mega|Fly|Ride"] = 179.41}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 665.44, ["Ride"] = 756, ["Fly|Ride"] = 695.62, ["Neon"] = 4201.82, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 3357.48, ["Mega|Fly|Ride"] = 12462.19}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 15.84, ["Ride"] = 19.46, ["Fly|Ride"] = 49.61, ["Neon"] = 27.24, ["Neon|Fly"] = 50.66, ["Neon|Ride"] = 28.48, ["Neon|Fly|Ride"] = 99.12, ["Mega"] = 188.85, ["Mega|Fly|Ride"] = 197.29}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 3.94, ["Ride"] = 69.57, ["Fly|Ride"] = 105.51, ["Neon"] = 10.5, ["Neon|Fly"] = 843.96, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 51.19, ["Mega|Fly"] = 141.38, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 155.81}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 6.46, ["Fly"] = 32.82, ["Ride"] = 31.27, ["Fly|Ride"] = 47.6, ["Neon"] = 53.42, ["Neon|Fly"] = 112.74, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 311.21, ["Mega|Ride"] = 307, ["Mega|Fly|Ride"] = 335.99}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 16.85, ["Fly|Ride"] = 32.82, ["Neon"] = 6.41, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 24.68, ["Neon|Fly|Ride"] = 56.58, ["Mega"] = 70.7, ["Mega|Fly"] = 349.84, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 52.41, ["Ride"] = 164.58, ["Fly|Ride"] = 209.94, ["Neon"] = 119.57, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 800.71, ["Mega|Ride"] = 830.25, ["Mega|Fly|Ride"] = 773.41}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 27.2, ["Fly|Ride"] = 88.52, ["Neon"] = 7.7, ["Neon|Fly"] = 136.31, ["Neon|Ride"] = 36.64, ["Neon|Fly|Ride"] = 206.07, ["Mega"] = 63.67, ["Mega|Ride"] = 139.27, ["Mega|Fly|Ride"] = 351.75}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 3.42, ["Fly"] = 73.5, ["Ride"] = 23.29, ["Fly|Ride"] = 61.21, ["Neon"] = 11.82, ["Neon|Fly"] = 143.48, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 451.53, ["Mega"] = 91.88, ["Mega|Ride"] = 269.03, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 65.76, ["Neon"] = 15.75, ["Neon|Fly"] = 64.58, ["Mega"] = 115.97, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 2593.49, ["Ride"] = 20.96, ["Fly|Ride"] = 28.88, ["Neon"] = 4.19, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 29.89, ["Neon|Fly|Ride"] = 94.4, ["Mega"] = 50.67, ["Mega|Fly"] = 164.58, ["Mega|Ride"] = 77.43, ["Mega|Fly|Ride"] = 172.15}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 15.43, ["Fly"] = 21.11, ["Ride"] = 22.32, ["Fly|Ride"] = 43.32, ["Neon"] = 137.82, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 108.67, ["Mega"] = 843.96, ["Mega|Ride"] = 388.23, ["Mega|Fly|Ride"] = 403.72}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 721.88, ["Ride"] = 735, ["Fly|Ride"] = 838.69, ["Neon"] = 1938.56, ["Neon|Ride"] = 2462.23, ["Neon|Fly|Ride"] = 1998.94, ["Mega"] = 8300.56, ["Mega|Ride"] = 7455.24, ["Mega|Fly|Ride"] = 5893.13}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 18.88, ["Ride"] = 20.04, ["Fly|Ride"] = 43.31, ["Neon"] = 3.92, ["Neon|Fly"] = 139.19, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 60.38, ["Mega"] = 55.13, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 126.6}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 11.97, ["Ride"] = 38.67, ["Fly|Ride"] = 92.18, ["Neon"] = 46.65, ["Neon|Fly"] = 104.46, ["Neon|Ride"] = 105.51, ["Neon|Fly|Ride"] = 248.11, ["Mega"] = 328.13, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 534.87}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 58.01, ["Ride"] = 85.32, ["Fly|Ride"] = 139.27, ["Neon"] = 377.68, ["Neon|Ride"] = 319.2, ["Neon|Fly|Ride"] = 448.88, ["Mega"] = 1547.6, ["Mega|Ride"] = 1547.6, ["Mega|Fly|Ride"] = 1581.37}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 43.32, ["Ride"] = 56.21, ["Fly|Ride"] = 319.2, ["Neon"] = 197.29, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 281.69, ["Mega"] = 1955.87, ["Mega|Ride"] = 843.96, ["Mega|Fly|Ride"] = 1027.52}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 14.34, ["Ride"] = 24.94, ["Fly|Ride"] = 141.38, ["Neon"] = 83.91, ["Neon|Ride"] = 160.21, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 319.17, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 416.72}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 28.3, ["Ride"] = 94.96, ["Neon"] = 72.19, ["Neon|Fly"] = 319.2, ["Neon|Ride"] = 367.02, ["Mega"] = 456.1, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 526.98}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 19, ["Fly"] = 63, ["Ride"] = 76.13, ["Neon"] = 131.25, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 525, ["Mega"] = 924, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 1053.89}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 19.69}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 5.57, ["Fly"] = 131248.69, ["Ride"] = 31.42, ["Fly|Ride"] = 78.75, ["Neon"] = 35.88, ["Neon|Ride"] = 99.19, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 189, ["Mega|Fly"] = 239.08, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 323.89}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.1, ["Ride"] = 47.84, ["Neon"] = 31.49, ["Mega"] = 348.92, ["Mega|Fly|Ride"] = 949.46}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 67.57, ["Fly"] = 393.75, ["Ride"] = 94.5, ["Fly|Ride"] = 111.57, ["Neon"] = 399.3, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 492.66, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 1038.22}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.63, ["Fly"] = 27.57, ["Ride"] = 16.9, ["Fly|Ride"] = 26.25, ["Neon"] = 18.9, ["Neon|Fly"] = 42.21, ["Neon|Ride"] = 23.61, ["Neon|Fly|Ride"] = 77.15, ["Mega"] = 262.5, ["Mega|Fly"] = 420.93, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 408.28}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 9.22, ["Fly"] = 84.42, ["Ride"] = 31.49, ["Fly|Ride"] = 45.94, ["Neon"] = 26.99, ["Neon|Ride"] = 55.47, ["Neon|Fly|Ride"] = 141.38, ["Mega"] = 150.25, ["Mega|Ride"] = 186.27, ["Mega|Fly|Ride"] = 252.45}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 6.48, ["Neon|Ride"] = 90.75, ["Mega"] = 50.66, ["Mega|Ride"] = 140.38, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 32.82, ["Fly"] = 65.63, ["Ride"] = 48.57, ["Fly|Ride"] = 78.74, ["Neon"] = 221.82, ["Neon|Ride"] = 211.01, ["Neon|Fly|Ride"] = 281.69, ["Mega"] = 1125.63, ["Mega|Ride"] = 838.03, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 23.78, ["Fly|Ride"] = 84.41, ["Neon"] = 9.19, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 70.7, ["Mega"] = 96.02, ["Mega|Fly|Ride"] = 309.68}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 9.19, ["Ride"] = 53.82, ["Neon"] = 73.86, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 350.25, ["Mega"] = 288.75, ["Mega|Ride"] = 492.66, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 18.87, ["Ride"] = 16.94, ["Fly|Ride"] = 28.88, ["Neon"] = 46.55, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 78.07, ["Mega"] = 208, ["Mega|Ride"] = 234.29, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 7.56, ["Fly"] = 52.5, ["Ride"] = 24.28, ["Fly|Ride"] = 52.5, ["Neon"] = 157.5, ["Neon|Ride"] = 177.19, ["Mega"] = 276.41, ["Mega|Ride"] = 246.87, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.68, ["Ride"] = 36.53, ["Neon"] = 28.49, ["Neon|Ride"] = 91.8, ["Mega"] = 127.92, ["Mega|Ride"] = 830.17}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 37.95, ["Ride"] = 105, ["Neon"] = 239.11, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 868.1, ["Mega|Ride"] = 1407.3, ["Mega|Fly|Ride"] = 1640.63}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 15.65, ["Ride"] = 141.38, ["Neon"] = 210, ["Neon|Fly|Ride"] = 253.2, ["Mega"] = 389.82, ["Mega|Ride"] = 563.36, ["Mega|Fly|Ride"] = 498.1}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 9.19, ["Ride"] = 63.61, ["Fly|Ride"] = 281.69, ["Neon"] = 98.04, ["Mega"] = 590.78, ["Mega|Ride"] = 555.97, ["Mega|Fly|Ride"] = 1687.91}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 26.25, ["Ride"] = 70, ["Fly|Ride"] = 422, ["Neon"] = 94.5, ["Neon|Ride"] = 632.98, ["Neon|Fly|Ride"] = 455.75, ["Mega"] = 681.5, ["Mega|Ride"] = 1110.81, ["Mega|Fly|Ride"] = 1042.79}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.15, ["Neon"] = 40.69, ["Neon|Ride"] = 281.69, ["Mega"] = 308.42, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 319.17}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 17.71, ["Fly|Ride"] = 41.91, ["Neon"] = 6.18, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 25.33, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 60.38, ["Mega|Ride"] = 89.25, ["Mega|Fly|Ride"] = 184.63}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 10.5, ["Ride"] = 44.62, ["Fly|Ride"] = 393.75, ["Neon"] = 32.82, ["Neon|Fly"] = 70.7, ["Neon|Ride"] = 116.06, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 208, ["Mega|Ride"] = 238.88, ["Mega|Fly|Ride"] = 397.69}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 20.74, ["Ride"] = 17.85, ["Fly|Ride"] = 55.13, ["Neon"] = 7.88, ["Neon|Ride"] = 25.33, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 44.51, ["Mega|Ride"] = 71.97, ["Mega|Fly|Ride"] = 154.03}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Fly|Ride"] = 99.18, ["Neon"] = 39.38, ["Neon|Ride"] = 92.86, ["Neon|Fly|Ride"] = 112.9, ["Mega"] = 223.67, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 478.15}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.83, ["Ride"] = 32.72, ["Fly|Ride"] = 99.75, ["Neon"] = 44.31, ["Neon|Fly"] = 478.2, ["Neon|Ride"] = 98.59, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 416.8, ["Mega|Fly|Ride"] = 956.3}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.93, ["Fly"] = 131.25, ["Ride"] = 15.84, ["Fly|Ride"] = 61.21, ["Neon"] = 40.66, ["Neon|Fly"] = 104.77, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 106.52, ["Mega"] = 224.44, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 394.42}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 4.24, ["Fly"] = 34.07, ["Ride"] = 16.7, ["Fly|Ride"] = 63.31, ["Neon"] = 21.32, ["Neon|Fly"] = 84.41, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 105.51, ["Mega"] = 167.99, ["Mega|Ride"] = 282.74, ["Mega|Fly|Ride"] = 350.25}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 7.87, ["Fly"] = 301.88, ["Ride"] = 47.25, ["Fly|Ride"] = 108.94, ["Neon"] = 25.45, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 131.25, ["Mega"] = 118.13, ["Mega|Ride"] = 152.09, ["Mega|Fly|Ride"] = 311.21}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 12.68, ["Fly"] = 105, ["Ride"] = 98.44, ["Fly|Ride"] = 191.3, ["Neon"] = 85.22, ["Neon|Ride"] = 182.27, ["Neon|Fly|Ride"] = 578.82, ["Mega"] = 385.88, ["Mega|Fly"] = 669.38, ["Mega|Ride"] = 440.9, ["Mega|Fly|Ride"] = 570.73}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 47.85, ["Fly"] = 239.21, ["Ride"] = 97.13, ["Fly|Ride"] = 187.69, ["Neon"] = 307.44, ["Neon|Ride"] = 269.07, ["Neon|Fly|Ride"] = 462.61, ["Mega"] = 1050, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1029}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 51.01, ["Ride"] = 25.18, ["Fly|Ride"] = 65.54, ["Neon"] = 3.15, ["Neon|Ride"] = 37.95, ["Mega"] = 24.94, ["Mega|Ride"] = 71.14, ["Mega|Fly|Ride"] = 131.15}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 16.96, ["Neon"] = 281.59, ["Neon|Ride"] = 199.31, ["Mega"] = 859.04, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 1265.94}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 32.82, ["Fly"] = 105, ["Ride"] = 116.82, ["Neon"] = 223.57, ["Neon|Ride"] = 303.66, ["Neon|Fly|Ride"] = 514.83, ["Mega"] = 1721.68, ["Mega|Ride"] = 1105.58, ["Mega|Fly|Ride"] = 812.44}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 30.18, ["Fly"] = 190.32, ["Ride"] = 44.62, ["Fly|Ride"] = 126, ["Neon"] = 40.58, ["Neon|Ride"] = 52.48, ["Mega"] = 281.69, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 465.29}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Fly"] = 157.5, ["Ride"] = 26.25, ["Fly|Ride"] = 136.61, ["Neon"] = 3.93, ["Neon|Fly"] = 40.2, ["Neon|Ride"] = 35.4, ["Mega"] = 22.32, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 60.38, ["Mega|Fly|Ride"] = 126}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 20.9, ["Fly|Ride"] = 26.17, ["Neon"] = 15.81, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 105, ["Mega"] = 296.46, ["Mega|Fly"] = 352.35, ["Mega|Ride"] = 233.16, ["Mega|Fly|Ride"] = 220.5}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 19, ["Ride"] = 18.38, ["Fly|Ride"] = 35.44, ["Neon"] = 2.63, ["Neon|Fly"] = 21, ["Neon|Ride"] = 20.05, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 34.13, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Fly"] = 42.23, ["Ride"] = 26.25, ["Fly|Ride"] = 65.7, ["Neon"] = 3.92, ["Neon|Ride"] = 36.93, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 38.27, ["Mega|Fly"] = 168, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 211.01}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.48, ["Fly|Ride"] = 160.21, ["Neon"] = 2.63, ["Neon|Ride"] = 126.27, ["Mega"] = 27.44, ["Mega|Ride"] = 105.5, ["Mega|Fly|Ride"] = 265.86}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 3.93, ["Ride"] = 31.4, ["Fly|Ride"] = 262.5, ["Neon"] = 64.57, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 208.89, ["Mega"] = 213.94, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 10.5, ["Ride"] = 30.19, ["Fly|Ride"] = 84.41, ["Neon"] = 124.69, ["Neon|Ride"] = 97.12, ["Neon|Fly|Ride"] = 237.88, ["Mega"] = 360.94, ["Mega|Ride"] = 304.5, ["Mega|Fly|Ride"] = 640.73}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 5.25, ["Fly"] = 33.78, ["Ride"] = 20.97, ["Fly|Ride"] = 31.49, ["Neon"] = 46.44, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 86.41, ["Mega|Ride"] = 334.69, ["Mega|Fly|Ride"] = 325.5}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 86.63, ["Ride"] = 144.37, ["Fly|Ride"] = 262.5, ["Neon"] = 538.13, ["Neon|Ride"] = 597.19, ["Mega"] = 3188.03, ["Mega|Fly|Ride"] = 1632}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 25.87, ["Fly"] = 72.44, ["Ride"] = 65.63, ["Fly|Ride"] = 72.19, ["Neon"] = 84.41, ["Mega"] = 633.29, ["Mega|Ride"] = 281.69, ["Mega|Fly|Ride"] = 1280.36}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 17.93, ["Ride"] = 17.88, ["Fly|Ride"] = 37.63, ["Neon"] = 3.93, ["Neon|Fly"] = 28.49, ["Neon|Ride"] = 24.28, ["Neon|Fly|Ride"] = 64.56, ["Mega"] = 36.11, ["Mega|Ride"] = 112.9, ["Mega|Fly|Ride"] = 108.94}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 15.84, ["Ride"] = 18.98, ["Fly|Ride"] = 28.49, ["Neon"] = 4.15, ["Neon|Fly"] = 23.5, ["Neon|Ride"] = 20.04, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 67.34, ["Mega|Ride"] = 61.21, ["Mega|Fly|Ride"] = 104.62}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 393.74, ["Ride"] = 434.44, ["Fly|Ride"] = 446.24, ["Neon|Ride"] = 1873.26, ["Neon|Fly|Ride"] = 1509.38}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 15.84, ["Ride"] = 140.41, ["Fly|Ride"] = 241.78, ["Neon"] = 95.53, ["Mega"] = 408.28, ["Mega|Fly|Ride"] = 1265.94}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 28.5, ["Ride"] = 18.38, ["Fly|Ride"] = 39.38, ["Neon"] = 3.93, ["Neon|Fly"] = 70.7, ["Neon|Ride"] = 20.74, ["Neon|Fly|Ride"] = 39.3, ["Mega"] = 54.87, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 120.95}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 84.96, ["Ride"] = 98.44, ["Fly|Ride"] = 511.88, ["Neon"] = 261.19, ["Neon|Ride"] = 304.45, ["Neon|Fly|Ride"] = 422.09, ["Mega"] = 737.63, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 934.5}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 31.67, ["Ride"] = 17.05, ["Fly|Ride"] = 39.38, ["Neon"] = 14.44, ["Neon|Fly"] = 47.76, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 83.36, ["Mega"] = 77.84, ["Mega|Fly"] = 160.19, ["Mega|Ride"] = 105.86, ["Mega|Fly|Ride"] = 183.09}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 70.71, ["Ride"] = 19, ["Fly|Ride"] = 1312.5, ["Neon"] = 3.61, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 19.48, ["Mega|Fly"] = 141.38, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 182.44}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 68.25, ["Fly"] = 141.3, ["Ride"] = 99.75, ["Fly|Ride"] = 243.89, ["Neon"] = 209.22, ["Neon|Ride"] = 267.96, ["Neon|Fly|Ride"] = 382.53, ["Mega"] = 790.97, ["Mega|Ride"] = 629.94, ["Mega|Fly|Ride"] = 816.54}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Neon"] = 4.66, ["Neon|Ride"] = 54.87, ["Neon|Fly|Ride"] = 126.6, ["Mega"] = 98.54, ["Mega|Ride"] = 121.64, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 32.82, ["Ride"] = 56.6, ["Neon"] = 147, ["Neon|Ride"] = 158.25, ["Neon|Fly|Ride"] = 316.5, ["Mega|Ride"] = 1687.91, ["Mega|Fly|Ride"] = 1054.95}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 4.61, ["Ride"] = 45.02, ["Fly|Ride"] = 211.01, ["Neon"] = 23.63, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 422, ["Mega"] = 175.88, ["Mega|Ride"] = 603.75, ["Mega|Fly|Ride"] = 460.04}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 3.94, ["Fly"] = 70.71, ["Ride"] = 18.84, ["Neon"] = 11.82, ["Neon|Fly"] = 78.54, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 79.13, ["Mega|Ride"] = 728.43, ["Mega|Fly|Ride"] = 563.36}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 31.21, ["Fly"] = 70.71, ["Ride"] = 54.51, ["Fly|Ride"] = 104.81, ["Neon"] = 146.44, ["Neon|Ride"] = 131.25, ["Mega|Ride"] = 1125.63, ["Mega|Fly|Ride"] = 1122.47}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 144.82, ["Ride"] = 53.82, ["Fly|Ride"] = 908.98, ["Neon"] = 5.17, ["Neon|Ride"] = 37.08, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 47.25, ["Mega|Fly"] = 158.61, ["Mega|Ride"] = 93.08, ["Mega|Fly|Ride"] = 229.43}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 56.99, ["Ride"] = 28.49, ["Fly|Ride"] = 102.85, ["Neon"] = 6.3, ["Neon|Fly"] = 41.88, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 105.51, ["Mega"] = 167.75, ["Mega|Ride"] = 180.41, ["Mega|Fly|Ride"] = 289.07}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 6.57, ["Fly"] = 35.6, ["Ride"] = 40.67, ["Fly|Ride"] = 191.29, ["Neon"] = 81.25, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 160.19, ["Mega"] = 262.5, ["Mega|Ride"] = 344.19, ["Mega|Fly|Ride"] = 378}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 34.31, ["Ride"] = 66.62, ["Fly|Ride"] = 160.22, ["Neon"] = 241.38, ["Neon|Ride"] = 239.48, ["Neon|Fly|Ride"] = 632.98, ["Mega"] = 815.06, ["Mega|Ride"] = 1049.68, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 31.67, ["Fly"] = 30.19, ["Ride"] = 35.43, ["Fly|Ride"] = 77.44, ["Neon"] = 105.21, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 141.38, ["Mega"] = 620.57, ["Mega|Ride"] = 388.23, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 59.06, ["Ride"] = 105, ["Fly|Ride"] = 196.82, ["Neon"] = 341.25, ["Neon|Ride"] = 337.59, ["Neon|Fly|Ride"] = 669.38, ["Mega"] = 1453.72, ["Mega|Ride"] = 1302, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.13, ["Ride"] = 35.44, ["Neon"] = 18.26, ["Neon|Ride"] = 54.87, ["Neon|Fly|Ride"] = 305.8, ["Mega"] = 196.21, ["Mega|Ride"] = 225.78, ["Mega|Fly|Ride"] = 327.48}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 6.19, ["Ride"] = 24.76, ["Fly|Ride"] = 78.75, ["Neon"] = 23.23, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 141.38, ["Mega"] = 203.44, ["Mega|Ride"] = 182.48, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 13.13, ["Fly"] = 28.33, ["Ride"] = 44.01, ["Fly|Ride"] = 98.95, ["Neon"] = 56.21, ["Neon|Ride"] = 131.25, ["Mega"] = 319.17, ["Mega|Ride"] = 346.03, ["Mega|Fly|Ride"] = 452.82}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 11.81, ["Fly|Ride"] = 31.4, ["Neon"] = 2.1, ["Neon|Fly"] = 17.05, ["Neon|Ride"] = 11.81, ["Neon|Fly|Ride"] = 45.85, ["Mega"] = 17.05, ["Mega|Fly"] = 70.7, ["Mega|Ride"] = 22.32, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 63, ["Fly"] = 91.88, ["Ride"] = 91.88, ["Fly|Ride"] = 303.01, ["Neon"] = 239.48, ["Neon|Fly"] = 2391.55, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 985.32, ["Mega|Ride"] = 807.19, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 94.96, ["Fly|Ride"] = 109.72, ["Neon"] = 3.7, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 43.04, ["Mega|Ride"] = 50.75, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.25, ["Ride"] = 19.69, ["Fly|Ride"] = 61.2, ["Neon"] = 21.06, ["Neon|Fly"] = 141.38, ["Neon|Ride"] = 32.44, ["Neon|Fly|Ride"] = 55, ["Mega"] = 118.13, ["Mega|Ride"] = 414.24, ["Mega|Fly|Ride"] = 281.69}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 78.75, ["Ride"] = 116.82, ["Fly|Ride"] = 262.5, ["Neon"] = 311.21, ["Neon|Ride"] = 296.5, ["Neon|Fly|Ride"] = 379.79, ["Mega"] = 1010.63, ["Mega|Ride"] = 1048.69, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 72.19, ["Neon"] = 7.88, ["Neon|Ride"] = 42.95, ["Mega"] = 65.63, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 281.69}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 6.81}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 33.77, ["Fly|Ride"] = 321.9, ["Neon"] = 5.25, ["Neon|Ride"] = 63.31, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 45.47, ["Mega|Ride"] = 112.79, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 151.5, ["Ride"] = 185.22, ["Fly|Ride"] = 236.25, ["Neon"] = 538.13, ["Neon|Ride"] = 696.28, ["Neon|Fly|Ride"] = 708.75, ["Mega"] = 3666.17, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.46, ["Ride"] = 25.5, ["Neon"] = 15.84, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 119.22, ["Mega"] = 145.84, ["Mega|Ride"] = 211.01, ["Mega|Fly|Ride"] = 467.35}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Neon"] = 4.6, ["Neon|Ride"] = 20.19, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 45.42, ["Mega|Ride"] = 128.21, ["Mega|Fly|Ride"] = 141.38}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 3.93, ["Ride"] = 30.69, ["Neon"] = 51.1, ["Neon|Ride"] = 141.38, ["Neon|Fly|Ride"] = 168.8, ["Mega|Ride"] = 632.98, ["Mega|Fly|Ride"] = 638.33}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 10.31, ["Fly"] = 28.88, ["Ride"] = 26.6, ["Fly|Ride"] = 157.5, ["Neon"] = 79.75, ["Neon|Ride"] = 90.75, ["Neon|Fly|Ride"] = 281.69, ["Mega"] = 587.35, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 42.2, ["Ride"] = 122.39, ["Fly|Ride"] = 211.01, ["Neon"] = 187.69, ["Neon|Ride"] = 316.5, ["Neon|Fly|Ride"] = 478.94, ["Mega"] = 669.41, ["Mega|Ride"] = 616.88, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 150.67, ["Fly"] = 189.9, ["Ride"] = 199.5, ["Fly|Ride"] = 221.82, ["Neon"] = 527.2, ["Neon|Fly"] = 631.92, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 522.2, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 6.57, ["Fly"] = 22.2, ["Ride"] = 19.66, ["Fly|Ride"] = 39.38, ["Neon"] = 91.88, ["Neon|Ride"] = 82.11, ["Neon|Fly|Ride"] = 91.88, ["Mega|Ride"] = 563.36, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 131.23, ["Ride"] = 24.94, ["Fly|Ride"] = 91.88, ["Neon"] = 28.49, ["Neon|Ride"] = 35.7, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 137.82, ["Mega|Fly|Ride"] = 286.9}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 5.24, ["Fly"] = 236.25, ["Ride"] = 68.92, ["Neon"] = 141.38, ["Neon|Ride"] = 65.63, ["Mega"] = 1272.27, ["Mega|Ride"] = 420.93, ["Mega|Fly|Ride"] = 632.98}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 44.18, ["Fly"] = 39.38, ["Ride"] = 65.63, ["Fly|Ride"] = 105.51, ["Neon"] = 191.29, ["Neon|Ride"] = 211, ["Neon|Fly|Ride"] = 390.34, ["Mega"] = 886.16, ["Mega|Ride"] = 931.88, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 15.64, ["Ride"] = 81.86, ["Neon"] = 80.12, ["Neon|Ride"] = 126.6, ["Mega"] = 703.65, ["Mega|Ride"] = 745.86, ["Mega|Fly|Ride"] = 1125.49}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 309.75, ["Ride"] = 400.88, ["Neon"] = 774.35, ["Neon|Ride"] = 1054.95, ["Neon|Fly|Ride"] = 1083.44, ["Mega|Fly|Ride"] = 4641.73}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 32.82, ["Ride"] = 52.77, ["Fly|Ride"] = 168.41, ["Neon"] = 271.39, ["Neon|Ride"] = 281.67, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 984.38, ["Mega|Ride"] = 843.96, ["Mega|Fly|Ride"] = 889.84}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 16.14, ["Ride"] = 15.16, ["Fly|Ride"] = 67.67, ["Neon"] = 2.5, ["Neon|Fly"] = 19.15, ["Neon|Ride"] = 18.8, ["Neon|Fly|Ride"] = 55, ["Mega"] = 22.31, ["Mega|Fly"] = 107.62, ["Mega|Ride"] = 52.49, ["Mega|Fly|Ride"] = 118.55}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 3.83, ["Ride"] = 211.01, ["Neon"] = 21, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 126.6, ["Mega"] = 158.25, ["Mega|Fly"] = 124.69, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 373.42}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 2.63, ["Ride"] = 33.77, ["Fly|Ride"] = 144.16, ["Neon"] = 17.75, ["Neon|Ride"] = 139.12, ["Neon|Fly|Ride"] = 223.67, ["Mega"] = 120.62, ["Mega|Fly"] = 548.58, ["Mega|Ride"] = 281.69, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 371.77, ["Fly"] = 638.65, ["Ride"] = 393.75, ["Fly|Ride"] = 431.82, ["Neon"] = 2109.89, ["Neon|Ride"] = 1625.8, ["Neon|Fly|Ride"] = 1623.57, ["Mega|Fly|Ride"] = 5033.44}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 46.15, ["Ride"] = 16.86, ["Fly|Ride"] = 42.21, ["Neon"] = 24.94, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 78.35, ["Mega"] = 168, ["Mega|Ride"] = 270.08, ["Mega|Fly|Ride"] = 422}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 4.87, ["Fly"] = 31.58, ["Ride"] = 17.07, ["Fly|Ride"] = 39.38, ["Neon"] = 27.44, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 70.7, ["Neon|Fly|Ride"] = 94.96, ["Mega|Ride"] = 703.65, ["Mega|Fly|Ride"] = 278.52}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.94, ["Fly"] = 84.42, ["Ride"] = 26.25, ["Fly|Ride"] = 65.63, ["Neon"] = 19, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 104.99, ["Mega"] = 111.57, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 39.38, ["Fly"] = 210, ["Ride"] = 70.7, ["Fly|Ride"] = 61.69, ["Neon"] = 118.27, ["Neon|Ride"] = 183.58, ["Neon|Fly|Ride"] = 210, ["Mega"] = 949.46, ["Mega|Ride"] = 842.9, ["Mega|Fly|Ride"] = 584.46}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 31.39, ["Ride"] = 30.7, ["Fly|Ride"] = 62.26, ["Neon"] = 15.72, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 210, ["Mega"] = 157.24, ["Mega|Ride"] = 189.9, ["Mega|Fly|Ride"] = 952.23}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 10.37, ["Fly"] = 104.15, ["Ride"] = 27.91, ["Fly|Ride"] = 69.21, ["Neon"] = 81.15, ["Neon|Ride"] = 141.38, ["Mega|Ride"] = 610.82, ["Mega|Fly|Ride"] = 727.92}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 40.92, ["Neon"] = 3.93, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 28.74, ["Mega"] = 36.75, ["Mega|Ride"] = 128.62, ["Mega|Fly|Ride"] = 476.96}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 12.39, ["Ride"] = 56.44, ["Neon"] = 59.07, ["Mega"] = 357.96, ["Mega|Fly|Ride"] = 843.96}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 23.23, ["Ride"] = 56.98, ["Neon"] = 85.58, ["Neon|Fly|Ride"] = 177.24, ["Mega"] = 328.13, ["Mega|Ride"] = 557.02, ["Mega|Fly|Ride"] = 465.25}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 6.57, ["Fly"] = 26.25, ["Ride"] = 23.63, ["Fly|Ride"] = 53.45, ["Neon"] = 51.19, ["Neon|Fly"] = 65.54, ["Neon|Ride"] = 63.32, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 590.78, ["Mega|Ride"] = 375.38, ["Mega|Fly|Ride"] = 358.23}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 189, ["Fly"] = 211.03, ["Ride"] = 209.89, ["Fly|Ride"] = 267.75, ["Neon"] = 862.95, ["Neon|Ride"] = 869.28, ["Neon|Fly|Ride"] = 910.25, ["Mega|Fly|Ride"] = 4204.98}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Fly"] = 27.44, ["Ride"] = 17.07, ["Fly|Ride"] = 48.54, ["Neon"] = 12.74, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 141.38, ["Mega"] = 220.5, ["Mega|Ride"] = 164.58, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.29, ["Fly"] = 42.23, ["Ride"] = 17.07, ["Fly|Ride"] = 103.82, ["Neon"] = 15.54, ["Neon|Ride"] = 27.51, ["Neon|Fly|Ride"] = 160.19, ["Mega"] = 252, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 43.32, ["Ride"] = 236.24, ["Fly|Ride"] = 160.21, ["Neon"] = 152.81, ["Neon|Ride"] = 253.2, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 465.86, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 564.25}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 72.19, ["Fly"] = 168.83, ["Ride"] = 157.5, ["Fly|Ride"] = 261.18, ["Neon"] = 525, ["Neon|Ride"] = 451.53, ["Neon|Fly|Ride"] = 703.65, ["Mega"] = 1898.9, ["Mega|Ride"] = 1791.57, ["Mega|Fly|Ride"] = 1648.5}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 26.14, ["Ride"] = 90.57, ["Fly|Ride"] = 246.28, ["Neon"] = 91.77, ["Neon|Ride"] = 160.64, ["Neon|Fly|Ride"] = 281.69, ["Mega"] = 261.19, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 448.88}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.22, ["Fly|Ride"] = 46.5, ["Neon"] = 10.4, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 65.42, ["Mega|Ride"] = 189.9, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 39.38, ["Ride"] = 61.69, ["Neon"] = 70.68, ["Neon|Ride"] = 105, ["Mega"] = 239.08, ["Mega|Ride"] = 391.79, ["Mega|Fly|Ride"] = 417.77}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 85.32, ["Ride"] = 137.82, ["Fly|Ride"] = 216.57, ["Neon"] = 194.25, ["Neon|Ride"] = 334.74, ["Neon|Fly|Ride"] = 505.33, ["Mega"] = 569.62, ["Mega|Ride"] = 670.69, ["Mega|Fly|Ride"] = 669.36}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 87.94, ["Fly|Ride"] = 56.44, ["Neon"] = 7.87, ["Neon|Ride"] = 104.74, ["Neon|Fly|Ride"] = 141.88, ["Mega"] = 72.19, ["Mega|Fly"] = 162.48, ["Mega|Ride"] = 108.35, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 15.23, ["Ride"] = 239.13, ["Neon"] = 72.19, ["Neon|Ride"] = 638.38, ["Mega"] = 363.42, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 977.81, ["Fly"] = 1336.78, ["Ride"] = 952.88, ["Fly|Ride"] = 1069.69, ["Neon"] = 2362.5, ["Neon|Ride"] = 3518.22, ["Neon|Fly|Ride"] = 3281.25, ["Mega|Fly|Ride"] = 12534.38}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 31.38, ["Ride"] = 111.56, ["Fly|Ride"] = 201.51, ["Neon"] = 181.76, ["Neon|Fly"] = 892.5, ["Neon|Ride"] = 527.48, ["Mega"] = 656.25, ["Mega|Ride"] = 538.13, ["Mega|Fly|Ride"] = 742.88}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.18, ["Ride"] = 26.25, ["Fly|Ride"] = 105, ["Neon"] = 15.84, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 36.74, ["Neon|Fly|Ride"] = 103.95, ["Mega"] = 75.33, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 160.19}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 23.23, ["Ride"] = 131.22, ["Neon"] = 106.32, ["Mega"] = 311.21, ["Mega|Ride"] = 554.98, ["Mega|Fly|Ride"] = 478.95}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Fly|Ride"] = 422, ["Neon"] = 2.1, ["Neon|Ride"] = 27.36, ["Neon|Fly|Ride"] = 105.46, ["Mega"] = 14.36, ["Mega|Fly"] = 31.1, ["Mega|Ride"] = 44.63, ["Mega|Fly|Ride"] = 548.58}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 65.63, ["Ride"] = 140.44, ["Fly|Ride"] = 183.75, ["Neon"] = 341.58, ["Neon|Ride"] = 385.22, ["Mega"] = 1210.64, ["Mega|Ride"] = 1116.48, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 3.83, ["Fly"] = 174.57, ["Ride"] = 37.7, ["Fly|Ride"] = 87.14, ["Neon"] = 35.7, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 281.69, ["Mega|Ride"] = 295.4, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.94, ["Ride"] = 26.25, ["Neon"] = 12.99, ["Neon|Ride"] = 78.75, ["Mega"] = 141.38, ["Mega|Ride"] = 239.48, ["Mega|Fly|Ride"] = 373.47}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 52.49, ["Ride"] = 90.57, ["Fly|Ride"] = 167.63, ["Neon"] = 196.88, ["Neon|Fly"] = 280.63, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 632.98, ["Mega"] = 563.36, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 1054.95}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 18.27, ["Ride"] = 52.5, ["Fly|Ride"] = 196.88, ["Neon"] = 131.25, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 315, ["Mega"] = 490.88, ["Mega|Ride"] = 582.33, ["Mega|Fly|Ride"] = 666.73}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 49.88, ["Neon"] = 779.63, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 1083.49, ["Mega"] = 1238.51, ["Mega|Ride"] = 1829.27, ["Mega|Fly|Ride"] = 1994.22}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 5.25, ["Neon"] = 24.09, ["Neon|Ride"] = 105.51, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 98.44, ["Mega|Ride"] = 153.41, ["Mega|Fly|Ride"] = 356.24}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 11.82, ["Fly"] = 32.15, ["Ride"] = 27.57, ["Fly|Ride"] = 56.98, ["Neon"] = 63.31, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 133.98, ["Mega"] = 399, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 413.44}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 131.14, ["Ride"] = 180.27, ["Fly|Ride"] = 234.04, ["Neon"] = 575.56, ["Neon|Ride"] = 598, ["Neon|Fly|Ride"] = 703.65, ["Mega|Ride"] = 2251.25, ["Mega|Fly|Ride"] = 1903.13}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 14.34, ["Ride"] = 13.13, ["Fly|Ride"] = 56.96, ["Neon"] = 10.5, ["Neon|Fly"] = 64.31, ["Neon|Ride"] = 21.12, ["Neon|Fly|Ride"] = 59.99, ["Mega"] = 145.68, ["Mega|Ride"] = 155.14, ["Mega|Fly|Ride"] = 573.79}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 2.63, ["Fly"] = 87.94, ["Ride"] = 22.32, ["Fly|Ride"] = 78.49, ["Neon"] = 18.38, ["Neon|Fly"] = 281.17, ["Neon|Ride"] = 51.18, ["Neon|Fly|Ride"] = 126.6, ["Mega"] = 202.57, ["Mega|Ride"] = 202.57, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Ride"] = 15.84, ["Fly|Ride"] = 36.66, ["Neon"] = 2.1, ["Neon|Fly"] = 16.69, ["Neon|Ride"] = 21.11, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 16.9, ["Mega|Ride"] = 42.21, ["Mega|Fly|Ride"] = 85.32}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 42.21, ["Neon"] = 3.93, ["Neon|Ride"] = 40.09, ["Mega"] = 20.05, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 139.27}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 27.44, ["Fly|Ride"] = 45.94, ["Neon"] = 22.74, ["Neon|Ride"] = 23.63, ["Mega"] = 111.84, ["Mega|Ride"] = 152.3}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 44.44, ["Ride"] = 84, ["Neon"] = 522.38, ["Neon|Ride"] = 422, ["Neon|Fly|Ride"] = 630, ["Mega"] = 779.63, ["Mega|Fly|Ride"] = 648.8}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 17.94, ["Ride"] = 15.84, ["Fly|Ride"] = 26.24, ["Neon"] = 12.53, ["Neon|Fly"] = 28.49, ["Neon|Ride"] = 25.02, ["Neon|Fly|Ride"] = 57.73, ["Mega"] = 91.59, ["Mega|Fly"] = 164.04, ["Mega|Ride"] = 118.12, ["Mega|Fly|Ride"] = 261.64}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 3.18, ["Fly"] = 26.92, ["Ride"] = 22.32, ["Fly|Ride"] = 68.22, ["Neon"] = 15.75, ["Neon|Fly"] = 36.75, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 82.85, ["Mega"] = 147, ["Mega|Fly"] = 308.05, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 189.58}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 18.21, ["Fly|Ride"] = 99.18, ["Neon"] = 9.19, ["Neon|Fly"] = 47.84, ["Neon|Ride"] = 23.93, ["Neon|Fly|Ride"] = 105.51, ["Mega"] = 103.39, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 15.84, ["Fly"] = 280.66, ["Ride"] = 24.86, ["Neon"] = 47.84, ["Neon|Ride"] = 59.04, ["Neon|Fly|Ride"] = 268.82, ["Mega"] = 250.04, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 344.98, ["Mega|Fly|Ride"] = 378.74}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 8.17, ["Fly"] = 160.5, ["Ride"] = 66, ["Neon"] = 103.85, ["Neon|Ride"] = 65.63, ["Mega"] = 328.13, ["Mega|Fly|Ride"] = 1054.95}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 6.57, ["Fly"] = 35.44, ["Ride"] = 20.78, ["Fly|Ride"] = 52.5, ["Neon"] = 28.09, ["Neon|Fly"] = 196.65, ["Neon|Ride"] = 60.38, ["Neon|Fly|Ride"] = 109.4, ["Mega"] = 239.08, ["Mega|Ride"] = 281.27}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 20.65, ["Ride"] = 13.13, ["Fly|Ride"] = 39.38, ["Neon"] = 13.13, ["Neon|Fly"] = 36.93, ["Neon|Ride"] = 32.3, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 422, ["Mega|Ride"] = 237.88, ["Mega|Fly|Ride"] = 208.89}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 170.63, ["Fly"] = 393.75, ["Ride"] = 236.25, ["Fly|Ride"] = 366.08, ["Neon"] = 978.99, ["Neon|Ride"] = 1043.44, ["Neon|Fly|Ride"] = 1179.94, ["Mega|Ride"] = 3518.22, ["Mega|Fly|Ride"] = 3507.18}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.71, ["Ride"] = 38.72, ["Neon"] = 35.88, ["Neon|Fly|Ride"] = 281.69, ["Mega"] = 123.38, ["Mega|Ride"] = 280.62}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.1, ["Ride"] = 30.61, ["Fly|Ride"] = 118.13, ["Neon|Fly"] = 211.01, ["Neon|Ride"] = 36.6, ["Neon|Fly|Ride"] = 139.65, ["Mega"] = 196.88, ["Mega|Ride"] = 278.52, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 3.65, ["Ride"] = 24.94, ["Neon"] = 47.25, ["Neon|Ride"] = 213.44, ["Neon|Fly|Ride"] = 632.98, ["Mega"] = 476.96, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 428.54}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 9.19, ["Ride"] = 16.89, ["Fly|Ride"] = 26.17, ["Neon"] = 2.1, ["Neon|Fly"] = 21.11, ["Neon|Ride"] = 17.75, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 22.32, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 60.14, ["Mega|Fly|Ride"] = 84.41}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 56.37, ["Ride"] = 26.25, ["Fly|Ride"] = 56.44, ["Neon"] = 15.84, ["Neon|Ride"] = 27.91, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 126.7, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 4.8, ["Ride"] = 56.98, ["Fly|Ride"] = 77.43, ["Neon"] = 10.5, ["Neon|Ride"] = 70.7, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 55.11, ["Mega|Ride"] = 160.19, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 65.63, ["Fly"] = 133.98, ["Ride"] = 90.87, ["Fly|Ride"] = 151.32, ["Neon"] = 492.66, ["Neon|Ride"] = 422, ["Neon|Fly|Ride"] = 352.33, ["Mega|Ride"] = 3518.22, ["Mega|Fly|Ride"] = 1687.91}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 2.99, ["Fly"] = 85.32, ["Ride"] = 33.77, ["Fly|Ride"] = 65.63, ["Neon"] = 26.25, ["Neon|Ride"] = 56.21, ["Neon|Fly|Ride"] = 137.48, ["Mega"] = 209.41, ["Mega|Ride"] = 259.86}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 31.67, ["Ride"] = 52.5, ["Fly|Ride"] = 118.13, ["Neon"] = 10.56, ["Neon|Ride"] = 126.6, ["Neon|Fly|Ride"] = 168.8, ["Mega"] = 52.5, ["Mega|Fly"] = 313.69, ["Mega|Ride"] = 103.4, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 52.5, ["Fly"] = 210, ["Ride"] = 90.57, ["Fly|Ride"] = 295.32, ["Neon"] = 211, ["Neon|Ride"] = 187.03, ["Neon|Fly|Ride"] = 303.19, ["Mega"] = 675.18, ["Mega|Ride"] = 580.13, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 16.93, ["Ride"] = 14.37, ["Fly|Ride"] = 30.19, ["Neon"] = 2.63, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 41.99, ["Mega"] = 28.7, ["Mega|Fly"] = 43.24, ["Mega|Ride"] = 37.99, ["Mega|Fly|Ride"] = 81.38}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 60.29, ["Neon|Fly|Ride"] = 71.09, ["Mega"] = 26.24, ["Mega|Ride"] = 77.44, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 107.63, ["Fly|Ride"] = 137.82, ["Neon"] = 9.19, ["Neon|Fly|Ride"] = 189.9, ["Mega"] = 73.5, ["Mega|Ride"] = 399.27, ["Mega|Fly|Ride"] = 280.73}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 6.57, ["Fly"] = 141.4, ["Ride"] = 69.54, ["Fly|Ride"] = 131.25, ["Neon"] = 29.5, ["Neon|Fly"] = 135.19, ["Neon|Ride"] = 107.91, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 120.28, ["Mega|Fly"] = 211.01, ["Mega|Ride"] = 180.6, ["Mega|Fly|Ride"] = 311.35}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.63, ["Ride"] = 14.44, ["Fly|Ride"] = 40.66, ["Neon"] = 2.63, ["Neon|Fly"] = 28.71, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 84.41, ["Mega"] = 21.5, ["Mega|Ride"] = 44.33, ["Mega|Fly|Ride"] = 129.76}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 14.37, ["Ride"] = 43.98, ["Fly|Ride"] = 235.27, ["Neon"] = 70.88, ["Neon|Ride"] = 166.69, ["Neon|Fly|Ride"] = 208.04, ["Mega"] = 420.93, ["Mega|Ride"] = 526.43, ["Mega|Fly|Ride"] = 631.92}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2821.88, ["Fly"] = 3150, ["Ride"] = 2779.88, ["Fly|Ride"] = 2752.32, ["Neon|Ride"] = 9846.78, ["Neon|Fly|Ride"] = 9318.75, ["Mega|Fly|Ride"] = 43779.81}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 40.11, ["Ride"] = 17.07, ["Fly|Ride"] = 62.26, ["Neon"] = 6.35, ["Neon|Fly"] = 62.29, ["Neon|Ride"] = 29.89, ["Neon|Fly|Ride"] = 66.94, ["Mega"] = 74.82, ["Mega|Fly"] = 141.38, ["Mega|Ride"] = 102.5, ["Mega|Fly|Ride"] = 160.02}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Neon"] = 19.69, ["Mega"] = 126, ["Mega|Fly"] = 179.82, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 632.98}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 15.73, ["Ride"] = 35.44, ["Fly|Ride"] = 147.71, ["Neon"] = 85.97, ["Neon|Ride"] = 279.57, ["Neon|Fly|Ride"] = 216.09, ["Mega"] = 551.74, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 52.76, ["Ride"] = 98.44, ["Neon"] = 187.69, ["Neon|Ride"] = 279.74, ["Neon|Fly|Ride"] = 422, ["Mega"] = 540.75, ["Mega|Ride"] = 739.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 173.25, ["Fly"] = 268.01, ["Ride"] = 189, ["Fly|Ride"] = 262.44, ["Neon"] = 1312.5, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 703.65, ["Neon|Fly|Ride"] = 758.61, ["Mega"] = 6329.63, ["Mega|Ride"] = 3555, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 9.87, ["Fly"] = 28.5, ["Ride"] = 52.5, ["Fly|Ride"] = 675.94, ["Neon"] = 16.7, ["Neon|Fly"] = 70.7, ["Neon|Ride"] = 104.9, ["Neon|Fly|Ride"] = 141.38, ["Mega"] = 151.82, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 286.9}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 63.31, ["Neon"] = 15.74, ["Neon|Fly"] = 99.18, ["Mega"] = 136.5, ["Mega|Ride"] = 261.03, ["Mega|Fly|Ride"] = 838.43}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 101.97, ["Ride"] = 26.17, ["Fly|Ride"] = 131.25, ["Neon"] = 13.13, ["Neon|Ride"] = 90.57, ["Mega"] = 107.63, ["Mega|Ride"] = 120.68, ["Mega|Fly|Ride"] = 280.63}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 19.19, ["Ride"] = 98.44, ["Fly|Ride"] = 656.25, ["Neon|Ride"] = 141.38, ["Neon|Fly|Ride"] = 295.4, ["Mega"] = 374.06, ["Mega|Ride"] = 501.27, ["Mega|Fly|Ride"] = 643.79}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 70.7, ["Neon"] = 2.1, ["Neon|Ride"] = 38.28, ["Mega"] = 21, ["Mega|Ride"] = 64.56, ["Mega|Fly|Ride"] = 352.35}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 82.67, ["Ride"] = 91.88, ["Fly|Ride"] = 160.1, ["Neon"] = 352.35, ["Neon|Ride"] = 409.5, ["Neon|Fly|Ride"] = 501.11, ["Mega"] = 1365, ["Mega|Fly|Ride"] = 1660.47}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 6.41, ["Neon|Ride"] = 112.9, ["Mega"] = 47.82, ["Mega|Ride"] = 141.75}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 52.49, ["Fly"] = 99.2, ["Ride"] = 73.5, ["Fly|Ride"] = 183.58, ["Neon"] = 295.32, ["Neon|Fly"] = 352.35, ["Neon|Ride"] = 208.89, ["Neon|Fly|Ride"] = 563.35, ["Mega"] = 2625, ["Mega|Ride"] = 1706.98, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 33.78, ["Ride"] = 24.28, ["Fly|Ride"] = 49.88, ["Neon"] = 2.63, ["Neon|Fly"] = 121.33, ["Neon|Ride"] = 42.21, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 42.28, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 107.46}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 12.39, ["Neon|Ride"] = 112.9, ["Mega"] = 79.95, ["Mega|Fly|Ride"] = 422}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 14.37, ["Fly|Ride"] = 141.38, ["Neon"] = 75.97, ["Neon|Ride"] = 141.38, ["Neon|Fly|Ride"] = 703.65, ["Mega"] = 226.28, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 413.44, ["Ride"] = 433.12, ["Fly|Ride"] = 536.82, ["Neon"] = 1232.44, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1429.32, ["Mega|Ride"] = 4144.3, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 35.44, ["Fly"] = 56.99, ["Ride"] = 51.19, ["Fly|Ride"] = 64.32, ["Neon"] = 239.11, ["Neon|Fly"] = 319.2, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 1053.89, ["Mega|Fly|Ride"] = 843.96}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 26.84, ["Ride"] = 17.07, ["Fly|Ride"] = 91.88, ["Neon"] = 4.47, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 47.78, ["Neon|Fly|Ride"] = 97.02, ["Mega"] = 55.13, ["Mega|Ride"] = 67.52, ["Mega|Fly|Ride"] = 394.56}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 11.69, ["Fly"] = 72.1, ["Ride"] = 42.21, ["Fly|Ride"] = 119.44, ["Neon"] = 45.85, ["Neon|Fly"] = 281.69, ["Neon|Ride"] = 77.47, ["Neon|Fly|Ride"] = 181.31, ["Mega"] = 229.69, ["Mega|Fly"] = 394.56, ["Mega|Ride"] = 250.13, ["Mega|Fly|Ride"] = 397.8}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 15.84, ["Ride"] = 27.57, ["Fly|Ride"] = 105.51, ["Neon"] = 110.25, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 119.55, ["Mega|Ride"] = 389.69, ["Mega|Fly|Ride"] = 422}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 4.2, ["Neon"] = 15.49, ["Neon|Ride"] = 52.5, ["Mega"] = 49.88, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 86.63, ["Ride"] = 19.66, ["Fly|Ride"] = 52.62, ["Neon"] = 26.25, ["Neon|Ride"] = 46.44, ["Neon|Fly|Ride"] = 215.22, ["Mega"] = 558.25, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 478.15}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 104.98, ["Fly"] = 131.25, ["Ride"] = 150.1, ["Fly|Ride"] = 167.64, ["Neon|Ride"] = 534.87, ["Neon|Fly|Ride"] = 843.96, ["Mega"] = 2673.22, ["Mega|Ride"] = 2813.52, ["Mega|Fly|Ride"] = 3092.03}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 23.24, ["Fly"] = 95.82, ["Ride"] = 84.41, ["Fly|Ride"] = 159.31, ["Neon"] = 192.94, ["Neon|Ride"] = 204.67, ["Mega"] = 842.9, ["Mega|Ride"] = 689.07, ["Mega|Fly|Ride"] = 703.65}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2429.12, ["Fly"] = 2349.36, ["Ride"] = 2310, ["Fly|Ride"] = 2296.88, ["Neon"] = 12659.24, ["Neon|Fly|Ride"] = 7743.75, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 41.89, ["Fly|Ride"] = 170.63, ["Neon"] = 10.39, ["Neon|Ride"] = 95.66, ["Neon|Fly|Ride"] = 168.8, ["Mega"] = 125.97, ["Mega|Ride"] = 141.2, ["Mega|Fly|Ride"] = 276.94}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 10.49, ["Ride"] = 87.57, ["Fly|Ride"] = 156.15, ["Neon"] = 57.06, ["Neon|Ride"] = 111.84, ["Neon|Fly|Ride"] = 253.32, ["Mega"] = 255.94, ["Mega|Ride"] = 703.65, ["Mega|Fly|Ride"] = 703.65}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 971.25, ["Fly"] = 1407.47, ["Ride"] = 941.93, ["Fly|Ride"] = 997.49, ["Neon"] = 2445.65, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2390.06, ["Mega|Fly|Ride"] = 9186.19}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 47.85, ["Ride"] = 67.5, ["Fly|Ride"] = 210, ["Neon"] = 196.88, ["Neon|Ride"] = 289.42, ["Mega"] = 840, ["Mega|Ride"] = 720.93, ["Mega|Fly|Ride"] = 842.9}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Neon"] = 14, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 135.05, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 111.19, ["Ride"] = 23.23, ["Neon"] = 3.92, ["Neon|Ride"] = 56.6, ["Mega"] = 27.83, ["Mega|Ride"] = 70.7, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 144.38, ["Ride"] = 125.99, ["Neon"] = 459.38, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 1970.63, ["Mega|Fly|Ride"] = 2673.22}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 3.93, ["Neon"] = 15.74, ["Neon|Ride"] = 141.38, ["Mega|Fly|Ride"] = 366.99}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 76, ["Ride"] = 97.63, ["Fly|Ride"] = 219.43, ["Neon"] = 614.25, ["Neon|Ride"] = 525, ["Mega"] = 1829.27, ["Mega|Fly|Ride"] = 1682.64}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 4.64, ["Fly"] = 105, ["Fly|Ride"] = 112.9, ["Neon"] = 33.15, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 143.46, ["Mega|Fly|Ride"] = 281.69}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 259.82, ["Fly"] = 422.04, ["Ride"] = 291.26, ["Fly|Ride"] = 341.25, ["Neon"] = 985.32, ["Neon|Ride"] = 1040.19, ["Neon|Fly|Ride"] = 812.44, ["Mega|Fly|Ride"] = 4072.06}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.7, ["Fly"] = 87.62, ["Ride"] = 26.25, ["Fly|Ride"] = 54.39, ["Neon"] = 28.49, ["Neon|Ride"] = 59.11, ["Neon|Fly|Ride"] = 104.95, ["Mega"] = 229.57, ["Mega|Ride"] = 286.9}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 18.15, ["Ride"] = 16.51, ["Fly|Ride"] = 26.17, ["Neon"] = 3.84, ["Neon|Fly"] = 21.11, ["Neon|Ride"] = 15.84, ["Neon|Fly|Ride"] = 59.09, ["Mega"] = 60.9, ["Mega|Fly"] = 103.4, ["Mega|Ride"] = 141.38, ["Mega|Fly|Ride"] = 151.82}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 836.66, ["Fly"] = 1195.94, ["Ride"] = 903, ["Fly|Ride"] = 1049.68, ["Neon|Ride"] = 5020.82, ["Neon|Fly|Ride"] = 4747.22, ["Mega"] = 28688.54, ["Mega|Fly|Ride"] = 28131.96}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 7.76, ["Fly"] = 985.44, ["Ride"] = 56.98, ["Neon"] = 28.49, ["Neon|Fly"] = 70.7, ["Neon|Ride"] = 70.2, ["Mega"] = 179.54, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 372.1}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 7.74, ["Fly"] = 32.82, ["Ride"] = 31.49, ["Fly|Ride"] = 112.4, ["Neon"] = 32.24, ["Neon|Fly"] = 77.68, ["Neon|Ride"] = 83.83, ["Neon|Fly|Ride"] = 78.75, ["Mega|Ride"] = 240.19, ["Mega|Fly|Ride"] = 281.69}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 32.82, ["Fly"] = 35.44, ["Ride"] = 45.94, ["Fly|Ride"] = 64.58, ["Neon|Ride"] = 211.3, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 2109.89, ["Mega|Fly|Ride"] = 787.48}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 13.13, ["Fly"] = 79.15, ["Ride"] = 31.17, ["Fly|Ride"] = 86.63, ["Neon"] = 65.63, ["Neon|Ride"] = 131.15, ["Neon|Fly|Ride"] = 141.39, ["Mega"] = 288.75, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 443.63}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 23.12, ["Ride"] = 210, ["Fly|Ride"] = 340.75, ["Neon"] = 86.63, ["Neon|Ride"] = 183.1, ["Mega"] = 486.18, ["Mega|Ride"] = 519.04, ["Mega|Fly|Ride"] = 611.87}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.59, ["Fly|Ride"] = 238.6, ["Neon"] = 2.1, ["Neon|Ride"] = 28.13, ["Mega"] = 20.03, ["Mega|Fly"] = 86.08, ["Mega|Ride"] = 141.38}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 32.82, ["Fly"] = 74.79, ["Ride"] = 47.2, ["Fly|Ride"] = 72.19, ["Neon"] = 300.98, ["Neon|Fly"] = 307, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 3375.81, ["Mega|Fly|Ride"] = 1153.06}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 90.91, ["Ride"] = 21, ["Fly|Ride"] = 70.87, ["Neon"] = 42.35, ["Neon|Ride"] = 141.38, ["Mega"] = 773.07, ["Mega|Ride"] = 272.2, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 26.16, ["Ride"] = 20.36, ["Fly|Ride"] = 36.75, ["Neon"] = 19, ["Neon|Ride"] = 49.61, ["Neon|Fly|Ride"] = 131.24, ["Mega|Ride"] = 281.69, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 3.93, ["Ride"] = 103.69, ["Neon"] = 105, ["Neon|Ride"] = 843.96, ["Neon|Fly|Ride"] = 141.38, ["Mega"] = 295.4, ["Mega|Fly|Ride"] = 478.15}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 26.14, ["Fly"] = 262.36, ["Ride"] = 91.88, ["Fly|Ride"] = 144.38, ["Neon"] = 118.13, ["Neon|Fly"] = 311.21, ["Neon|Ride"] = 196.23, ["Neon|Fly|Ride"] = 211.01, ["Mega"] = 829.2, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 4.87, ["Ride"] = 19.69, ["Neon"] = 24.86, ["Neon|Ride"] = 73.86, ["Neon|Fly|Ride"] = 128.71, ["Mega"] = 104.89, ["Mega|Ride"] = 70.88, ["Mega|Fly|Ride"] = 319.17}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 27.44, ["Neon"] = 2.63, ["Neon|Ride"] = 28.49, ["Mega"] = 19.69, ["Mega|Ride"] = 52.37, ["Mega|Fly|Ride"] = 204.75}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Ride"] = 20.98, ["Neon"] = 3.84, ["Neon|Fly"] = 393.59, ["Neon|Ride"] = 21.11, ["Mega"] = 19.69, ["Mega|Fly"] = 73.86, ["Mega|Ride"] = 122.39, ["Mega|Fly|Ride"] = 106.32}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 25.89, ["Ride"] = 24.05, ["Fly|Ride"] = 26.2, ["Neon"] = 3.93, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 15.84, ["Neon|Fly|Ride"] = 75.97, ["Mega"] = 83.89, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 5369.02, ["Neon"] = 14.37, ["Neon|Ride"] = 1312.5, ["Mega"] = 105, ["Mega|Ride"] = 148.79, ["Mega|Fly|Ride"] = 183.58}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 26.23, ["Ride"] = 15.75, ["Fly|Ride"] = 40.6, ["Neon"] = 16.89, ["Neon|Fly"] = 52.77, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 77.17, ["Mega"] = 286.9, ["Mega|Ride"] = 276.29, ["Mega|Fly|Ride"] = 367.49}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 76, ["Ride"] = 131.25, ["Fly|Ride"] = 394.56, ["Neon"] = 241.5, ["Neon|Ride"] = 298.91, ["Neon|Fly|Ride"] = 1054.95, ["Mega"] = 1094.86, ["Mega|Ride"] = 845.4}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 26.19, ["Ride"] = 18.38, ["Fly|Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 28.49, ["Neon|Ride"] = 23.23, ["Neon|Fly|Ride"] = 91.76, ["Mega"] = 64.32, ["Mega|Ride"] = 65.42, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 10.48, ["Fly"] = 62.91, ["Ride"] = 56.39, ["Fly|Ride"] = 99.18, ["Neon"] = 70.55, ["Neon|Fly"] = 84.32, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 115.4, ["Mega"] = 843.96, ["Mega|Ride"] = 264.57, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 11.71, ["Fly"] = 36.74, ["Ride"] = 27.57, ["Fly|Ride"] = 70.71, ["Neon"] = 72.16, ["Neon|Fly"] = 140.41, ["Neon|Ride"] = 82.69, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 1054.95, ["Mega|Ride"] = 419.88, ["Mega|Fly|Ride"] = 317.63}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 2.1, ["Fly"] = 140.38, ["Ride"] = 47.84, ["Fly|Ride"] = 160.22, ["Neon"] = 15.65, ["Neon|Ride"] = 70.7, ["Mega"] = 279.57, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 378.74}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 18, ["Fly|Ride"] = 26.17, ["Neon"] = 3.83, ["Neon|Fly"] = 41.16, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 42.21, ["Mega|Fly"] = 105, ["Mega|Ride"] = 61.69, ["Mega|Fly|Ride"] = 105.34}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.78, ["Fly"] = 78.07, ["Ride"] = 28.48, ["Fly|Ride"] = 141.38, ["Neon"] = 15.84, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 69.65, ["Neon|Fly|Ride"] = 158.25, ["Mega"] = 126, ["Mega|Fly"] = 735, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 280.63}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 905.63, ["Fly"] = 1307.23, ["Ride"] = 968.63, ["Fly|Ride"] = 1023.75, ["Neon"] = 2625, ["Neon|Fly"] = 2740.74, ["Neon|Ride"] = 2742.85, ["Neon|Fly|Ride"] = 2204.97, ["Mega|Fly|Ride"] = 7609.88}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 80.05, ["Ride"] = 94.5, ["Neon"] = 259.52, ["Neon|Ride"] = 321.96, ["Neon|Fly|Ride"] = 462.07, ["Mega"] = 2812.69, ["Mega|Ride"] = 1468.48, ["Mega|Fly|Ride"] = 1322.35}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Ride"] = 68.39, ["Neon"] = 12.5, ["Neon|Ride"] = 70.7, ["Neon|Fly|Ride"] = 197.29, ["Mega"] = 69.21}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 32.82, ["Ride"] = 64.97, ["Fly|Ride"] = 160.21, ["Neon"] = 183.2, ["Neon|Ride"] = 190.66, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1023.75, ["Mega|Ride"] = 1515.94, ["Mega|Fly|Ride"] = 786.19}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 6.02, ["Ride"] = 118.39, ["Fly|Ride"] = 156.19, ["Neon"] = 39.8, ["Neon|Ride"] = 281.69, ["Neon|Fly|Ride"] = 280.63, ["Mega"] = 478.95, ["Mega|Fly|Ride"] = 1054.95}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 258.61, ["Fly"] = 422.04, ["Ride"] = 288.75, ["Fly|Ride"] = 314.42, ["Neon|Ride"] = 1112.97, ["Neon|Fly|Ride"] = 1279.69, ["Mega|Fly|Ride"] = 4218.71}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 102.37, ["Ride"] = 22.32, ["Fly|Ride"] = 129.93, ["Neon"] = 15.74, ["Neon|Ride"] = 53.9, ["Mega"] = 401.21, ["Mega|Fly"] = 281.69}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 104.9, ["Mega"] = 198.34}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 82.69, ["Ride"] = 141.38, ["Fly|Ride"] = 279.7, ["Neon"] = 262.5, ["Neon|Ride"] = 327.05, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 590.63, ["Mega|Ride"] = 551.25, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 48.44, ["Neon"] = 13.55, ["Neon|Ride"] = 45.93, ["Mega"] = 225.78, ["Mega|Ride"] = 295.4, ["Mega|Fly|Ride"] = 281.69}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 16.89, ["Ride"] = 15.06, ["Fly|Ride"] = 32.48, ["Neon"] = 3.63, ["Neon|Fly"] = 32.3, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 24.78, ["Mega|Fly"] = 70.7, ["Mega|Ride"] = 41.16, ["Mega|Fly|Ride"] = 94.49}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4200, ["Ride"] = 4331.25, ["Fly|Ride"] = 4332.56, ["Neon"] = 26303.75, ["Neon|Fly|Ride"] = 22506, ["Mega|Fly|Ride"] = 63296.09}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 11.6, ["Ride"] = 48.54, ["Neon"] = 95.71, ["Mega"] = 418.69, ["Mega|Ride"] = 375.58, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 23.45, ["Ride"] = 22.32, ["Fly|Ride"] = 60.37, ["Neon"] = 12.86, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 229.53, ["Mega|Ride"] = 166, ["Mega|Fly|Ride"] = 263.75}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 403.05, ["Fly"] = 519.1, ["Ride"] = 479.07, ["Fly|Ride"] = 472.5, ["Neon"] = 1312.5, ["Neon|Ride"] = 1259.62, ["Neon|Fly|Ride"] = 1169.44, ["Mega|Fly|Ride"] = 5063.69}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 3.4, ["Ride"] = 28.49, ["Neon"] = 17.07, ["Neon|Ride"] = 145.68, ["Mega"] = 124.59, ["Mega|Fly|Ride"] = 343.08}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.81, ["Fly"] = 4106.07, ["Ride"] = 367.5, ["Neon"] = 127.94, ["Neon|Ride"] = 281.69, ["Neon|Fly|Ride"] = 14066.52, ["Mega"] = 225.78, ["Mega|Ride"] = 401.63}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.33, ["Ride"] = 17.64, ["Fly|Ride"] = 82.55, ["Neon"] = 7.87, ["Neon|Fly"] = 124.67, ["Neon|Ride"] = 36.93, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 62.99, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 637.88, ["Ride"] = 590.63, ["Fly|Ride"] = 645.6, ["Neon"] = 2100, ["Neon|Fly|Ride"] = 1967.34, ["Mega|Fly|Ride"] = 9143.14}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.22, ["Ride"] = 59.07, ["Neon"] = 23.37, ["Neon|Ride"] = 99.18, ["Neon|Fly|Ride"] = 139.12, ["Mega"] = 156.19, ["Mega|Ride"] = 199.63, ["Mega|Fly|Ride"] = 322.04}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 3.93, ["Fly"] = 235.94, ["Ride"] = 84.41, ["Fly|Ride"] = 150.94, ["Neon"] = 58.97, ["Neon|Ride"] = 143.07, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 245.37, ["Mega|Ride"] = 242.88, ["Mega|Fly|Ride"] = 430.43}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 41.28, ["Ride"] = 19.59, ["Fly|Ride"] = 50.28, ["Neon"] = 15.73, ["Neon|Fly"] = 73.86, ["Neon|Ride"] = 28.49, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 289.07, ["Mega|Fly"] = 281.69, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 208.69}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["Ride"] = 48.57, ["Neon"] = 91.88, ["Neon|Fly"] = 170.63, ["Neon|Fly|Ride"] = 319.17, ["Mega"] = 522.2, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 526.43}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 39.37, ["Neon"] = 4.07, ["Neon|Ride"] = 54.54, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 33.76, ["Mega|Ride"] = 87.56, ["Mega|Fly|Ride"] = 220.89}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 393.75, ["Ride"] = 449.16, ["Fly|Ride"] = 548.58, ["Neon"] = 1837.5, ["Neon|Ride"] = 2426.36, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Ride"] = 9323.78, ["Mega|Fly|Ride"] = 7848.75}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 53.76, ["Fly|Ride"] = 333.38, ["Neon"] = 12.22, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 151.93, ["Mega"] = 55.78, ["Mega|Ride"] = 238.43, ["Mega|Fly|Ride"] = 342.05}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 52.48, ["Neon"] = 5.01, ["Neon|Fly"] = 70.7, ["Neon|Ride"] = 209.85, ["Neon|Fly|Ride"] = 111.46, ["Mega"] = 45.38, ["Mega|Fly"] = 92.86, ["Mega|Ride"] = 84.41, ["Mega|Fly|Ride"] = 211.01}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 60.37, ["Neon"] = 6.35, ["Neon|Ride"] = 45.91, ["Neon|Fly|Ride"] = 141.38, ["Mega"] = 48.54, ["Mega|Fly"] = 156.15, ["Mega|Ride"] = 88.62}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 25.33, ["Neon|Ride"] = 70.7, ["Mega"] = 231.04, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 70.82, ["Ride"] = 116.82, ["Fly|Ride"] = 232.32, ["Neon"] = 248.07, ["Neon|Ride"] = 112.9, ["Neon|Fly|Ride"] = 1594.62, ["Mega"] = 949.46, ["Mega|Ride"] = 943.68, ["Mega|Fly|Ride"] = 837.63}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 56.44, ["Fly"] = 69.47, ["Ride"] = 65.51, ["Fly|Ride"] = 112.11, ["Neon"] = 111.57, ["Neon|Ride"] = 208.89, ["Mega"] = 463.21, ["Mega|Ride"] = 440.06, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 40.11, ["Ride"] = 18.38, ["Fly|Ride"] = 49.86, ["Neon"] = 30.38, ["Neon|Fly"] = 70.7, ["Neon|Ride"] = 35.02, ["Neon|Fly|Ride"] = 75.03, ["Mega"] = 394.42, ["Mega|Ride"] = 183.58, ["Mega|Fly|Ride"] = 253.2}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 8.34, ["Ride"] = 64.32, ["Fly|Ride"] = 79.13, ["Neon"] = 141.38, ["Neon|Ride"] = 159.31, ["Mega"] = 333.38, ["Mega|Ride"] = 797.32, ["Mega|Fly|Ride"] = 983.21}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 3.61, ["Fly"] = 262.5, ["Ride"] = 28.49, ["Fly|Ride"] = 84.41, ["Neon"] = 28.49, ["Neon|Ride"] = 56.98, ["Mega"] = 168, ["Mega|Ride"] = 371.35, ["Mega|Fly|Ride"] = 502.16}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 23.61, ["Ride"] = 30.17, ["Fly|Ride"] = 56.23, ["Neon"] = 228.74, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 322.88, ["Mega"] = 948.41, ["Mega|Ride"] = 956.3, ["Mega|Fly|Ride"] = 728.98}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 47.85, ["Fly"] = 874.13, ["Ride"] = 84.41, ["Neon|Ride"] = 478.2, ["Mega|Ride"] = 590.63}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 41.83, ["Fly"] = 115.5, ["Ride"] = 81.38, ["Fly|Ride"] = 139.12, ["Neon"] = 236.25, ["Neon|Fly"] = 348.04, ["Neon|Ride"] = 276.92, ["Neon|Fly|Ride"] = 358.7, ["Mega"] = 1160.44, ["Mega|Ride"] = 1147.56, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 55.13, ["Fly"] = 92.79, ["Ride"] = 81.38, ["Neon"] = 156.03, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 408.19, ["Mega"] = 513.6, ["Mega|Ride"] = 635.94, ["Mega|Fly|Ride"] = 580.75}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 26.14, ["Ride"] = 56.98, ["Neon"] = 125.98, ["Mega"] = 422, ["Mega|Ride"] = 774.35, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 3.94, ["Fly"] = 30.08, ["Ride"] = 30.6, ["Fly|Ride"] = 78.75, ["Neon"] = 45.94, ["Neon|Fly"] = 168.8, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 116.28, ["Mega"] = 349.49, ["Mega|Ride"] = 366.08, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 21.11, ["Ride"] = 16.96, ["Fly|Ride"] = 41.78, ["Neon"] = 4.99, ["Neon|Fly"] = 24.89, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 62.99, ["Mega"] = 59.05, ["Mega|Fly"] = 211.01, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1458.18}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 27.79, ["Ride"] = 69.36, ["Fly|Ride"] = 131.25, ["Neon"] = 139.13, ["Neon|Ride"] = 157.97, ["Neon|Fly|Ride"] = 299.61, ["Mega"] = 420.93, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 522.38}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 56.44, ["Neon"] = 3.42, ["Neon|Ride"] = 41.92, ["Neon|Fly|Ride"] = 295.4, ["Mega"] = 35.88, ["Mega|Ride"] = 92.86}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 24.43, ["Fly"] = 112.43, ["Ride"] = 47.22, ["Neon"] = 208.31, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 708.75, ["Mega|Ride"] = 946.3, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 6.46, ["Neon|Ride"] = 105, ["Mega"] = 41.16}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 4.8, ["Mega"] = 26.25, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 126.62, ["Ride"] = 196.88, ["Fly|Ride"] = 184.12, ["Neon"] = 426.57, ["Neon|Fly"] = 628.82, ["Neon|Ride"] = 518.44, ["Neon|Fly|Ride"] = 522.43, ["Mega|Ride"] = 6574.47, ["Mega|Fly|Ride"] = 1867.69}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 26.11, ["Ride"] = 21.12, ["Fly|Ride"] = 71.46, ["Neon"] = 16.89, ["Neon|Fly"] = 63.31, ["Neon|Ride"] = 35.43, ["Neon|Fly|Ride"] = 68.25, ["Mega"] = 91.88, ["Mega|Ride"] = 141.38, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Ride"] = 131.24, ["Fly|Ride"] = 86.63, ["Neon"] = 6.57, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 47.25, ["Mega|Ride"] = 105.51, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.15, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.35, ["Mega"] = 30.83, ["Mega|Ride"] = 223.65, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.94, ["Neon|Ride"] = 30.09, ["Mega"] = 39, ["Mega|Ride"] = 95.7, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 31.49, ["Ride"] = 111.57, ["Fly|Ride"] = 1054.95, ["Neon"] = 267.96, ["Neon|Ride"] = 407.69, ["Neon|Fly|Ride"] = 319.17, ["Mega"] = 1547.6, ["Mega|Ride"] = 1547.6, ["Mega|Fly|Ride"] = 1275.46}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.68, ["Ride"] = 36.53, ["Neon"] = 28.49, ["Neon|Ride"] = 91.8, ["Mega"] = 127.92, ["Mega|Ride"] = 830.17}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 375.61, ["Ride"] = 396.46, ["Fly|Ride"] = 616.88, ["Neon"] = 1407.3, ["Neon|Ride"] = 797.37, ["Neon|Fly|Ride"] = 1053.89, ["Mega|Ride"] = 3797.78, ["Mega|Fly|Ride"] = 3502.99}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 77.44}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 40.69}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 19.9}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 19.65}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 31.47}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 41.99}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 7.07}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 4.87}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 210}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 22.41}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.05}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 53.81}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 9.09}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 9.18}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 257.44}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 6.69}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 4.97}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 6.06}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 5.24}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 23.73}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 413.44}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 652.61}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 9.19}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1441.13}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 70.71}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 6.34}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 13.13}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 20.04}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 86.57}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 43.32}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 13.11}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 14.83}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 18.36}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 2.63}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 19.38}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 3.56}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 45.91}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 21}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.55}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1640.63}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 64.22}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 308.23}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 10.5}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 10.56}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 163.95}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 9.93}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 11.68}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 1001.32}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 16.83}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 5.24}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 14.43}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 6.09}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 144.37}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 18.26}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 10.39}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.05}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 22.74}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 11.28}},
    ["rbxassetid://1265129203"] = {name = "Ice Snowboard", prices = {["default"] = 262.5}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 2.1}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 32.44}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 114.19}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 143.52}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 6.57}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 23.6}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 39.37}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 72.19}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 64.92}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22722.54}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 177.17}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 30.84}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 78.73}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 26.25}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 65.61}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 59.06}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 45.94}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 196.88}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 117.93}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 30.32}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 55.37}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 41.88}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 44.87}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 367.49}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 354.36}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 3.93}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 8.32}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 7.22}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 15.73}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 37.38}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.24}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 2.1}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 5.92}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 984.38}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 5.92}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 632}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 23.62}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 40.69}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 65.63}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 27.15}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 37.58}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 223.69}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 15.74}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 2.63}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 15.04}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.91}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 4.87}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 34.13}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.93}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.93}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 2.1}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 17.84}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 164.07}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.05}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.05}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 65.63}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1012.88}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 15.75}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 5.24}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 7.49}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 11.81}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 85.32}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 10.49}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 7.86}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 8.07}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 13.49}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 104.81}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 25.87}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 7.87}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 2.28}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.63}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 6.56}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 14.41}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 6.29}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 5.23}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 5670}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 32.82}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3.39}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 7.86}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.59}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 20.46}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 7.24}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.93}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 15.58}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 118.13}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 32.28}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 3.92}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 5.8}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 3.93}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.63}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4466.78}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 4.64}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 45.92}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 2.1}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 81.36}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 3.93}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 278.25}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.05}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.23}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.6}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 3.94}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 9.53}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 13.13}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.5}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.67}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.49}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 13.13}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 6.56}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.37}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 6.43}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.59}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.2}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 6.25}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.63}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 36.94}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 152.22}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.55}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 8.44}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 76.95}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.33}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 89.75}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 2.63}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 19.3}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 984.38}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 18.36}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 5.25}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.05}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 5.25}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 27.55}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 7.62}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 11.82}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 11.82}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 15.74}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 15.74}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.66}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 6.35}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 17.85}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 8.93}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 47.85}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.91}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 3.92}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 141.4}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 11.82}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 63.4}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.63}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 11.5}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 4.78}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 3.45}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 49.88}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 25.54}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.92}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 104.98}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 12.9}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 7.09}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.05}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 5.25}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 11.43}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 86.62}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 112.77}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 5.25}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1198.93}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.61}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 154.77}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 5.16}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 10.5}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 32.81}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 5.13}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.6}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 124.68}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 11.43}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 2.52}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 5.15}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 39.37}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 2.52}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 57.74}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.61}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 3.93}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 27.66}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 94.49}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.61}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 59.07}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 4.86}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.76}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 68.23}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 65.62}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 111.57}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 353.07}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 91.25}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 252.15}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.93}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 15.61}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 39.29}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.93}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 36.75}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.15}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 7.69}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 7.88}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 43.32}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 13.13}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 7.3}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 7.56}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 23.61}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 45.93}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 5.12}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 3.61}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 32.31}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 7.72}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 52.49}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 32.81}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 26.24}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1637.48}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 4.61}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 3.93}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 65.62}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 271.67}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 10.5}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 6.57}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 7.87}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 9.02}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 157.49}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 45.94}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 41.99}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 11.37}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 73.54}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 105}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 78.75}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1647.99}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 167.21}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 4.87}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1312.5}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 360.94}},
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