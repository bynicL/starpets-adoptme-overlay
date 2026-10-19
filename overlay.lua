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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1050, ["Ride"] = 1139.42, ["Fly|Ride"] = 1292.82, ["Neon"] = 6783.36, ["Neon|Ride"] = 6562.5, ["Neon|Fly|Ride"] = 12603.94, ["Mega|Fly|Ride"] = 17743.32}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 459.38, ["Ride"] = 498.25, ["Fly|Ride"] = 551.25, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 12096.62, ["Mega|Fly|Ride"] = 7049.34}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 5520.53, ["Ride"] = 5250, ["Fly|Ride"] = 4959.82, ["Neon|Fly|Ride"] = 21918.42, ["Mega|Fly|Ride"] = 71205.6}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 161.44, ["Ride"] = 228.82, ["Fly|Ride"] = 267.31, ["Neon"] = 998.64, ["Neon|Ride"] = 927.01, ["Neon|Fly|Ride"] = 984.38, ["Mega|Fly|Ride"] = 4272.33}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 632.63, ["Fly"] = 854.31, ["Ride"] = 590.19, ["Fly|Ride"] = 735, ["Neon|Fly|Ride"] = 1719.19, ["Mega|Fly|Ride"] = 7903.94}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 10.4, ["Ride"] = 57.68, ["Fly|Ride"] = 129.94, ["Neon"] = 71.65, ["Neon|Ride"] = 59.28, ["Neon|Fly|Ride"] = 404.25, ["Mega"] = 356.75, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 2.63, ["Fly"] = 42.68, ["Ride"] = 29.27, ["Fly|Ride"] = 65.54, ["Neon"] = 27.43, ["Neon|Fly"] = 103.68, ["Neon|Ride"] = 57.24, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 171.29, ["Mega|Ride"] = 224.07, ["Mega|Fly|Ride"] = 254.62}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 105, ["Fly"] = 213.6, ["Ride"] = 153.98, ["Fly|Ride"] = 238.81, ["Neon"] = 568.83, ["Neon|Ride"] = 641.53, ["Neon|Fly|Ride"] = 691.79, ["Mega"] = 1586.82, ["Mega|Fly|Ride"] = 2788.76}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 44.36, ["Fly"] = 65.36, ["Ride"] = 43.32, ["Fly|Ride"] = 91.04, ["Neon"] = 275.63, ["Neon|Ride"] = 242.82, ["Neon|Fly|Ride"] = 334.67, ["Mega"] = 1424.83, ["Mega|Ride"] = 1189.85, ["Mega|Fly|Ride"] = 1139.66}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 26.2, ["Fly"] = 84.28, ["Ride"] = 37.56, ["Fly|Ride"] = 75.74, ["Neon|Ride"] = 162.33, ["Neon|Fly|Ride"] = 185.07, ["Mega|Ride"] = 449.03, ["Mega|Fly|Ride"] = 1110.81}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 57.64, ["Fly"] = 206.07, ["Ride"] = 70.87, ["Fly|Ride"] = 153.98, ["Neon"] = 445.78, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 365.84, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 65.01}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 323.15, ["Fly"] = 470.93, ["Ride"] = 326.8, ["Fly|Ride"] = 380.51, ["Neon|Ride"] = 1426.32, ["Neon|Fly|Ride"] = 1128.75, ["Mega|Fly|Ride"] = 5121.45}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 106.39, ["Fly"] = 170.87, ["Ride"] = 125.19, ["Fly|Ride"] = 169.58, ["Neon|Ride"] = 573.56, ["Neon|Fly|Ride"] = 763.13, ["Mega|Fly|Ride"] = 3063.38}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3, ["Ride"] = 55.54, ["Fly|Ride"] = 131.25, ["Neon"] = 20.1, ["Neon|Ride"] = 130.46, ["Mega"] = 131.25, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 327.6, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 183.43, ["Fly"] = 286.33, ["Ride"] = 180.09, ["Fly|Ride"] = 216.57, ["Neon"] = 884.24, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 787.5, ["Mega|Fly|Ride"] = 2730}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.63, ["Fly"] = 23.5, ["Ride"] = 20.79, ["Fly|Ride"] = 38.51, ["Neon"] = 28.86, ["Neon|Fly"] = 128.31, ["Neon|Ride"] = 93.98, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 170.63, ["Mega|Fly"] = 393.75, ["Mega|Fly|Ride"] = 384.53}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 86.63, ["Fly"] = 284.72, ["Ride"] = 144.38, ["Fly|Ride"] = 171.09, ["Neon"] = 333.82, ["Neon|Ride"] = 380.63, ["Neon|Fly|Ride"] = 420, ["Mega"] = 1708.93, ["Mega|Ride"] = 1460.08, ["Mega|Fly|Ride"] = 1422.75}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 38.1}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 61.69, ["Ride"] = 120.75, ["Fly|Ride"] = 213.86, ["Neon"] = 435.18, ["Neon|Fly|Ride"] = 570.96}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 19.41, ["Fly"] = 55.54, ["Ride"] = 39.16, ["Fly|Ride"] = 315.44, ["Neon"] = 262.5, ["Neon|Ride"] = 143.07, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2625, ["Mega|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 711.36}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 36.03, ["Fly"] = 143.11, ["Ride"] = 61.68, ["Fly|Ride"] = 103.69, ["Neon"] = 713.18, ["Neon|Ride"] = 237.57, ["Neon|Fly|Ride"] = 237.06, ["Mega"] = 1693.54, ["Mega|Ride"] = 1424.83, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 45.94, ["Fly"] = 78.75, ["Ride"] = 111.56, ["Fly|Ride"] = 267.31, ["Neon"] = 143.29, ["Neon|Fly"] = 402.17, ["Neon|Ride"] = 213.86, ["Neon|Fly|Ride"] = 467.25, ["Mega"] = 2047.5, ["Mega|Ride"] = 1708.93, ["Mega|Fly|Ride"] = 1356.48}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 24.59, ["Ride"] = 35.18, ["Fly|Ride"] = 84, ["Neon"] = 213.86, ["Neon|Ride"] = 212.79, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 1065.95, ["Mega|Ride"] = 1238.99, ["Mega|Fly|Ride"] = 1139.66}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 30.19, ["Fly"] = 136.75, ["Ride"] = 57.74, ["Fly|Ride"] = 145.37, ["Neon"] = 325.5, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 262.49, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 964.69}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 5.24, ["Fly"] = 38.07, ["Ride"] = 20.58, ["Fly|Ride"] = 57.74, ["Neon"] = 32.81, ["Neon|Fly"] = 101.07, ["Neon|Ride"] = 57.83, ["Neon|Fly|Ride"] = 83.58, ["Mega"] = 183.75, ["Mega|Fly"] = 273.7, ["Mega|Ride"] = 182.43, ["Mega|Fly|Ride"] = 277.57}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 532.45, ["Ride"] = 459.38, ["Fly|Ride"] = 525, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1964.82, ["Mega|Fly|Ride"] = 8953.72}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 15.61, ["Ride"] = 32.68, ["Fly|Ride"] = 111.78, ["Neon"] = 219.18, ["Mega|Ride"] = 811.75, ["Mega|Fly|Ride"] = 924.97}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 5.35, ["Fly"] = 57.68, ["Ride"] = 22.25, ["Fly|Ride"] = 41.98, ["Neon"] = 74.82, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 119.44, ["Mega"] = 427.25, ["Mega|Ride"] = 367.76, ["Mega|Fly|Ride"] = 512.91}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 84.96, ["Fly"] = 102.38, ["Ride"] = 100.38, ["Fly|Ride"] = 135.71, ["Neon"] = 371.88, ["Neon|Fly"] = 375.3, ["Neon|Ride"] = 427.69, ["Neon|Fly|Ride"] = 399, ["Mega"] = 4699.56, ["Mega|Ride"] = 5832.75, ["Mega|Fly|Ride"] = 1698.26}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 11.11, ["Ride"] = 19.69, ["Fly|Ride"] = 118.13, ["Neon"] = 131.25, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 218.05, ["Mega"] = 712.42, ["Mega|Ride"] = 806.86, ["Mega|Fly|Ride"] = 694.36}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 208.04, ["Fly"] = 288.75, ["Ride"] = 225.08, ["Fly|Ride"] = 301.88, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 927.01, ["Mega"] = 6408.49, ["Mega|Fly|Ride"] = 3065.3}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 36.32}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.66, ["Fly"] = 35.43, ["Ride"] = 24.59, ["Fly|Ride"] = 63.21, ["Neon"] = 20.68, ["Neon|Fly"] = 138.1, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 143.29, ["Mega"] = 131.25, ["Mega|Fly"] = 483.68, ["Mega|Ride"] = 182.44, ["Mega|Fly|Ride"] = 284.12}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 840, ["Fly"] = 2625, ["Ride"] = 891.19, ["Fly|Ride"] = 933.51, ["Neon"] = 9187.5, ["Neon|Ride"] = 6272.96, ["Neon|Fly|Ride"] = 4282.32, ["Mega|Ride"] = 54434.78, ["Mega|Fly|Ride"] = 17089.27}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 13.12, ["Fly"] = 52.5, ["Ride"] = 32.81, ["Fly|Ride"] = 91.49, ["Neon"] = 100.52, ["Neon|Ride"] = 99.21, ["Neon|Fly|Ride"] = 213.86, ["Mega"] = 787.5, ["Mega|Ride"] = 1096.93, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 209.9, ["Fly"] = 363.03, ["Ride"] = 244.02, ["Fly|Ride"] = 300.57, ["Neon"] = 1853.99, ["Neon|Ride"] = 756.29, ["Neon|Fly|Ride"] = 969.06, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 4034.23}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 45.93}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 17.66, ["Fly"] = 114.28, ["Ride"] = 65.63, ["Fly|Ride"] = 143.29, ["Neon"] = 104.9, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 643.13, ["Mega|Ride"] = 1126.83, ["Mega|Fly|Ride"] = 598.8}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 110.92, ["Ride"] = 166.69, ["Fly|Ride"] = 262.5, ["Neon"] = 639.19, ["Neon|Ride"] = 526.98, ["Mega|Fly|Ride"] = 2723.17}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 122.03, ["Fly"] = 157.49, ["Ride"] = 143.29, ["Fly|Ride"] = 274.32, ["Neon"] = 360.93, ["Neon|Fly"] = 570.96, ["Neon|Ride"] = 485.42, ["Neon|Fly|Ride"] = 472.49, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1560.57}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 38.07}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 55.56, ["Fly"] = 68.78, ["Ride"] = 62.89, ["Fly|Ride"] = 73.5, ["Neon|Ride"] = 357.13, ["Neon|Fly|Ride"] = 422.35, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 6.57, ["Fly"] = 98.44, ["Ride"] = 56.82, ["Fly|Ride"] = 157.49, ["Neon"] = 42, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 67.56, ["Neon|Fly|Ride"] = 240.58, ["Mega"] = 131.25, ["Mega|Fly"] = 362.92, ["Mega|Ride"] = 298.97, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 525, ["Fly"] = 479.07, ["Ride"] = 477.74, ["Fly|Ride"] = 525, ["Neon|Ride"] = 2059.24, ["Neon|Fly|Ride"] = 1742.99, ["Mega|Ride"] = 14953.11, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 94.5, ["Fly"] = 158.06, ["Ride"] = 116.82, ["Fly|Ride"] = 171.09, ["Neon"] = 420, ["Neon|Ride"] = 554.93, ["Neon|Fly|Ride"] = 680.03, ["Mega|Fly|Ride"] = 2542.03}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3675, ["Ride"] = 4267.16, ["Fly|Ride"] = 3674.99, ["Neon|Fly|Ride"] = 14967.61}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 47.25, ["Fly"] = 121.75, ["Ride"] = 65.36, ["Fly|Ride"] = 131.14, ["Neon|Ride"] = 322.88, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 1920.41, ["Mega|Ride"] = 1823.22, ["Mega|Fly|Ride"] = 1443.75}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 52.49, ["Ride"] = 68.06, ["Fly|Ride"] = 83.45, ["Neon"] = 646.86, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 431.82, ["Mega|Ride"] = 2279.3, ["Mega|Fly|Ride"] = 2349.79}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 27.56, ["Fly"] = 59.07, ["Ride"] = 57.68, ["Fly|Ride"] = 93.74, ["Neon"] = 191.4, ["Neon|Ride"] = 132.57, ["Neon|Fly|Ride"] = 213.3, ["Mega"] = 997.6, ["Mega|Ride"] = 702.81, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 6.42}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 40.58, ["Ride"] = 62.94, ["Fly|Ride"] = 71.6, ["Neon|Ride"] = 323.44, ["Neon|Fly|Ride"] = 427.69, ["Mega|Ride"] = 1290.72, ["Mega|Fly|Ride"] = 1493.63}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 49.14}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 197.03, ["Ride"] = 236.25, ["Fly|Ride"] = 318.94, ["Neon|Ride"] = 1426.32, ["Neon|Fly|Ride"] = 1107.7, ["Mega|Fly|Ride"] = 4605.57}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["Ride"] = 754.69, ["Fly|Ride"] = 1059.92, ["Neon|Fly|Ride"] = 3514.45, ["Mega|Fly|Ride"] = 10820.36}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 7.61}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 28.88, ["Fly"] = 53.41, ["Ride"] = 39.37, ["Fly|Ride"] = 78.74, ["Neon"] = 246.75, ["Neon|Ride"] = 166.69, ["Neon|Fly|Ride"] = 216.08, ["Mega"] = 2136.18, ["Mega|Ride"] = 1161.28, ["Mega|Fly|Ride"] = 762.74}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 18.24}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5118.75, ["Ride"] = 5650.32, ["Fly|Ride"] = 4986.19, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 42723.15}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 11.82, ["Fly"] = 75.83, ["Ride"] = 20.4, ["Fly|Ride"] = 62.94, ["Neon"] = 52.5, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 186.05, ["Mega"] = 561.75, ["Mega|Ride"] = 481.69, ["Mega|Fly|Ride"] = 776.5}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 15.71, ["Fly"] = 139.89, ["Ride"] = 36.66, ["Neon"] = 97.31, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1076.61, ["Mega|Ride"] = 770.2, ["Mega|Fly|Ride"] = 712.42}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 68.74, ["Fly"] = 285.13, ["Ride"] = 58.95, ["Fly|Ride"] = 98.44, ["Neon|Ride"] = 396.68, ["Neon|Fly|Ride"] = 498.75, ["Mega"] = 4272.33}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 12.16, ["Fly"] = 71.56, ["Ride"] = 25.91, ["Fly|Ride"] = 139.63, ["Neon"] = 108.94, ["Neon|Ride"] = 129.63, ["Neon|Fly|Ride"] = 143.29, ["Mega"] = 1424.83, ["Mega|Ride"] = 758.47, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1765.32, ["Fly"] = 2364.25, ["Ride"] = 1851.94, ["Fly|Ride"] = 1837.5, ["Neon|Fly|Ride"] = 3596.25, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 27562.5, ["Fly"] = 34171.34, ["Ride"] = 52500, ["Fly|Ride"] = 26906.25, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 73971.2, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 16.97, ["Fly"] = 393.75, ["Ride"] = 39.38, ["Fly|Ride"] = 171.09, ["Neon"] = 320.77, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 960.21, ["Mega|Ride"] = 1147.13, ["Mega|Fly|Ride"] = 1393.55}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.72, ["Ride"] = 43.21, ["Fly|Ride"] = 163.24, ["Neon"] = 17.73, ["Neon|Fly"] = 153.86, ["Neon|Ride"] = 66.94, ["Neon|Fly|Ride"] = 193.6, ["Mega"] = 143.07, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 248.07}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 23.29}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.59, ["Ride"] = 36.75, ["Fly|Ride"] = 124.68, ["Neon"] = 58.46, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 400.96, ["Mega"] = 229.69, ["Mega|Ride"] = 412.13, ["Mega|Fly|Ride"] = 656.24}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 773.25, ["Ride"] = 656.25, ["Fly|Ride"] = 779.51, ["Neon"] = 2495.5, ["Neon|Ride"] = 2566.07, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 9542.23}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 814.78, ["Fly"] = 975.19, ["Ride"] = 853.36, ["Fly|Ride"] = 918.75, ["Neon"] = 4134.58, ["Neon|Ride"] = 3706.9, ["Neon|Fly|Ride"] = 2493.75, ["Mega|Fly|Ride"] = 11678.38}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 12.69, ["Fly"] = 121.03, ["Ride"] = 30, ["Fly|Ride"] = 75.93, ["Neon"] = 85.32, ["Neon|Ride"] = 106.47, ["Neon|Fly|Ride"] = 242.28, ["Mega"] = 1220.57, ["Mega|Ride"] = 481.69, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 24.6}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 77.07, ["Fly"] = 128.34, ["Ride"] = 79.75, ["Fly|Ride"] = 118.13, ["Neon"] = 420, ["Neon|Ride"] = 427.69, ["Neon|Fly|Ride"] = 420, ["Mega"] = 19687.5, ["Mega|Ride"] = 2091.31, ["Mega|Fly|Ride"] = 1664.25}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 77.97, ["Ride"] = 138.48, ["Fly|Ride"] = 127.32, ["Neon"] = 420, ["Neon|Ride"] = 527.2, ["Neon|Fly|Ride"] = 553.77, ["Mega"] = 1389.99, ["Mega|Fly|Ride"] = 1934.27}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.67, ["Fly"] = 35.44, ["Ride"] = 22.99, ["Fly|Ride"] = 42.77, ["Neon"] = 42.78, ["Neon|Fly"] = 524.99, ["Neon|Ride"] = 68.44, ["Neon|Fly|Ride"] = 100.06, ["Mega"] = 286.13, ["Mega|Fly|Ride"] = 712.42}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 128, ["Fly"] = 154.66, ["Ride"] = 156.19, ["Fly|Ride"] = 221.69, ["Neon"] = 725.82, ["Neon|Ride"] = 576.18, ["Neon|Fly|Ride"] = 578.82, ["Mega|Fly|Ride"] = 2204.08}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 5.25, ["Fly"] = 101.47, ["Ride"] = 51.19, ["Fly|Ride"] = 140.44, ["Neon"] = 30.97, ["Neon|Ride"] = 97.13, ["Mega"] = 234.94, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 442.73}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 14.99, ["Fly"] = 63, ["Ride"] = 32.68, ["Fly|Ride"] = 79.75, ["Neon"] = 126.29, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 173.22, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 36.75, ["Ride"] = 60.29, ["Fly|Ride"] = 156.19, ["Neon"] = 196.88, ["Neon|Ride"] = 282.19, ["Mega"] = 918.75, ["Mega|Ride"] = 1161.57, ["Mega|Fly|Ride"] = 1129.85}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 14.88, ["Fly"] = 213.6, ["Ride"] = 26.25, ["Fly|Ride"] = 70.87, ["Neon"] = 91.88, ["Neon|Ride"] = 116.94, ["Neon|Fly|Ride"] = 143.29, ["Mega|Fly|Ride"] = 1034.25}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 7119.39, ["Ride"] = 6555.94, ["Fly|Ride"] = 5584.69, ["Neon"] = 35640.41, ["Neon|Ride"] = 24281.25, ["Neon|Fly|Ride"] = 24377.56}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 242.71, ["Fly"] = 234.78, ["Ride"] = 247.68, ["Fly|Ride"] = 295.21, ["Neon|Ride"] = 751.03, ["Neon|Fly|Ride"] = 577.5, ["Mega|Fly|Ride"] = 2416.92}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 45.93, ["Fly"] = 149.06, ["Ride"] = 91.85, ["Fly|Ride"] = 201.65, ["Neon"] = 141.74, ["Neon|Fly"] = 306.87, ["Neon|Ride"] = 167.9, ["Neon|Fly|Ride"] = 265.12, ["Mega"] = 393.75, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 563.06}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.61, ["Fly"] = 89.56, ["Ride"] = 28.85, ["Fly|Ride"] = 50.27, ["Neon"] = 21.45, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 194.61, ["Mega"] = 144.38, ["Mega|Ride"] = 291.38, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 60.29, ["Fly"] = 5485.24, ["Ride"] = 100.23, ["Fly|Ride"] = 227.81, ["Neon"] = 196.86, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 236.24, ["Neon|Fly|Ride"] = 387.16, ["Mega"] = 539.85, ["Mega|Ride"] = 695.63, ["Mega|Fly|Ride"] = 628.74}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 14384.99, ["Ride"] = 13415.07, ["Fly|Ride"] = 11351.92, ["Neon|Fly|Ride"] = 27562.5, ["Mega|Fly|Ride"] = 113928.73}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 265.13, ["Ride"] = 315, ["Fly|Ride"] = 342.16, ["Neon"] = 1283.04, ["Neon|Ride"] = 1426.32, ["Neon|Fly|Ride"] = 1618.77, ["Mega|Fly|Ride"] = 6394.6}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 55.13, ["Fly"] = 91.88, ["Ride"] = 59.17, ["Fly|Ride"] = 129.94, ["Neon"] = 406.31, ["Neon|Ride"] = 413.8, ["Neon|Fly|Ride"] = 484.55}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 13.33, ["Ride"] = 23.88, ["Fly|Ride"] = 45.85, ["Neon"] = 89.82, ["Neon|Fly"] = 274.98, ["Neon|Ride"] = 71.76, ["Neon|Fly|Ride"] = 110.24, ["Mega"] = 525}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 380.63, ["Fly"] = 854.31, ["Ride"] = 393.74, ["Fly|Ride"] = 528.33, ["Neon"] = 1537.52, ["Neon|Ride"] = 1376.76, ["Neon|Fly|Ride"] = 2138.39, ["Mega|Fly|Ride"] = 4981.36}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 7.35, ["Fly"] = 104.12, ["Ride"] = 26.23, ["Fly|Ride"] = 138.8, ["Neon"] = 34.13, ["Neon|Ride"] = 127.21, ["Neon|Fly|Ride"] = 195.67, ["Mega"] = 129.93, ["Mega|Fly"] = 263.92, ["Mega|Ride"] = 619.92, ["Mega|Fly|Ride"] = 352.48}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 104.09, ["Fly"] = 207.18, ["Ride"] = 158.82, ["Fly|Ride"] = 211.91, ["Neon"] = 570.96, ["Neon|Fly"] = 525, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 518.44, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.68, ["Fly"] = 19.18, ["Ride"] = 19.4, ["Fly|Ride"] = 32.37, ["Neon"] = 162.33, ["Neon|Ride"] = 196.86, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 2563.4, ["Mega|Fly|Ride"] = 645.75}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 8.32}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 74.82, ["Ride"] = 85.32, ["Fly|Ride"] = 427.69, ["Neon"] = 381.57, ["Neon|Fly"] = 426.62, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 484.55, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1852.06}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 12.98, ["Fly"] = 105.74, ["Ride"] = 34.13, ["Fly|Ride"] = 96.92, ["Neon"] = 104.99, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 185.74, ["Mega|Ride"] = 560.44, ["Mega|Fly|Ride"] = 2847.51}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 24.94}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 52.5, ["Fly"] = 210, ["Ride"] = 115.5, ["Fly|Ride"] = 249.38, ["Neon"] = 289.76, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 1602.14, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.97, ["Ride"] = 29.23, ["Fly|Ride"] = 138.1, ["Neon"] = 21, ["Neon|Ride"] = 113.88, ["Neon|Fly|Ride"] = 285.49, ["Mega"] = 129.94, ["Mega|Ride"] = 213.42, ["Mega|Fly|Ride"] = 285.2}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 11.66, ["Fly"] = 56.44, ["Ride"] = 28.85, ["Fly|Ride"] = 53.48, ["Neon"] = 162.33, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 212.79, ["Mega|Ride"] = 651.54, ["Mega|Fly|Ride"] = 806.86}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 484.32, ["Ride"] = 505.32, ["Fly|Ride"] = 541.66, ["Neon|Fly|Ride"] = 3137.03, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 38.05, ["Fly"] = 100.38, ["Ride"] = 57.59, ["Fly|Ride"] = 131.24, ["Neon"] = 178.58, ["Neon|Ride"] = 182.61, ["Neon|Fly|Ride"] = 326.21, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 1613.7}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 61.08, ["Fly"] = 119.89, ["Ride"] = 70.87, ["Fly|Ride"] = 118.13, ["Neon"] = 318.6, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 458.1, ["Mega|Fly|Ride"] = 944.21}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 20.31, ["Fly"] = 81.1, ["Ride"] = 68.85, ["Fly|Ride"] = 121.91, ["Neon"] = 97.01, ["Neon|Ride"] = 177.14, ["Neon|Fly|Ride"] = 183.74, ["Mega"] = 433.02, ["Mega|Fly"] = 525, ["Mega|Ride"] = 425.25, ["Mega|Fly|Ride"] = 645.98}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 26250, ["Ride"] = 8862, ["Fly|Ride"] = 8098.13, ["Neon|Fly|Ride"] = 17718.75, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1422.74, ["Fly"] = 1486.83, ["Ride"] = 1509.38, ["Fly|Ride"] = 1404.38, ["Neon|Ride"] = 4847.73, ["Neon|Fly|Ride"] = 3896.83, ["Mega|Fly|Ride"] = 15093.75}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 570.25, ["Ride"] = 630.99, ["Fly|Ride"] = 538.13, ["Neon"] = 2423.88, ["Neon|Ride"] = 2851.54, ["Neon|Fly|Ride"] = 3207.59, ["Mega|Fly|Ride"] = 8548.68}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 11.81, ["Fly"] = 21.37, ["Ride"] = 26.03, ["Fly|Ride"] = 49.88, ["Neon"] = 65.43, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 129.94, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 549.21}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 5.01, ["Fly"] = 78.74, ["Ride"] = 31.55, ["Fly|Ride"] = 182.85, ["Neon"] = 23.63, ["Neon|Ride"] = 56, ["Mega"] = 167.9, ["Mega|Ride"] = 198.19, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 35.44, ["Fly"] = 85.44, ["Ride"] = 44.27, ["Fly|Ride"] = 97.9, ["Neon"] = 545.11, ["Neon|Ride"] = 228.82, ["Neon|Fly|Ride"] = 212.58, ["Mega|Fly|Ride"] = 590.88}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.05, ["Fly"] = 26.25, ["Ride"] = 18.17, ["Fly|Ride"] = 37.22, ["Neon"] = 32.82, ["Neon|Ride"] = 46.04, ["Neon|Fly|Ride"] = 86.38, ["Mega"] = 261.19, ["Mega|Ride"] = 595.46, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 304.5, ["Fly"] = 369.49, ["Ride"] = 321.57, ["Fly|Ride"] = 335.99, ["Neon|Ride"] = 1228.27, ["Neon|Fly|Ride"] = 1773.38, ["Mega|Fly|Ride"] = 3654}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 19.46, ["Fly"] = 59.07, ["Ride"] = 30.94, ["Fly|Ride"] = 105.88, ["Neon"] = 208.95, ["Neon|Fly"] = 315.44, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 257.25, ["Mega"] = 669.71, ["Mega|Ride"] = 787.4, ["Mega|Fly|Ride"] = 721.77}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 6.57, ["Fly"] = 22.31, ["Ride"] = 25.68, ["Fly|Ride"] = 42.9, ["Neon"] = 143.29, ["Neon|Fly"] = 138.1, ["Neon|Ride"] = 70.83, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 425.25}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 577.86, ["Fly"] = 1048.69, ["Ride"] = 533.94, ["Fly|Ride"] = 547.44, ["Neon|Fly|Ride"] = 2851.54, ["Mega|Fly|Ride"] = 12517.89}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1263.94, ["Ride"] = 1115.63, ["Fly|Ride"] = 1400.34, ["Neon"] = 4989.93, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13387.34}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 123.23, ["Fly"] = 139.9, ["Ride"] = 127.09, ["Fly|Ride"] = 120.05, ["Neon"] = 971.25, ["Neon|Ride"] = 585.46, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 2561.26}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 170.75, ["Fly"] = 212.13, ["Ride"] = 189, ["Fly|Ride"] = 202.13, ["Neon"] = 867.13, ["Neon|Ride"] = 643.13, ["Neon|Fly|Ride"] = 595.42, ["Mega|Ride"] = 9187.5, ["Mega|Fly|Ride"] = 2877.42}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 71.56, ["Fly"] = 122.82, ["Ride"] = 53.81, ["Fly|Ride"] = 123.57, ["Neon"] = 233.88, ["Neon|Ride"] = 272.98, ["Mega|Ride"] = 1424.83, ["Mega|Fly|Ride"] = 1068.1}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 236.25, ["Ride"] = 315, ["Fly|Ride"] = 413.8, ["Neon"] = 1220.63, ["Neon|Fly"] = 969.06, ["Neon|Fly|Ride"] = 1356.69, ["Mega|Fly|Ride"] = 5554.02}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2098.27, ["Ride"] = 2238.9, ["Fly|Ride"] = 1837.5, ["Mega|Fly|Ride"] = 29838.74}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 53.82, ["Fly"] = 213.6, ["Ride"] = 52.47, ["Fly|Ride"] = 196.88, ["Neon"] = 288.75, ["Neon|Ride"] = 320.77, ["Neon|Fly|Ride"] = 343.88, ["Mega|Ride"] = 1139.66, ["Mega|Fly|Ride"] = 1154.99}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 656.24, ["Ride"] = 699.57, ["Fly|Ride"] = 735, ["Neon|Fly|Ride"] = 1345.22, ["Mega|Fly|Ride"] = 3412.5}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 39.38, ["Fly"] = 70.87, ["Ride"] = 45.94, ["Fly|Ride"] = 86.63, ["Neon"] = 427.69, ["Neon|Ride"] = 271.59, ["Neon|Fly|Ride"] = 234.94, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.83, ["Fly"] = 43.32, ["Ride"] = 21.09, ["Fly|Ride"] = 53.82, ["Neon"] = 26.24, ["Neon|Fly"] = 139.13, ["Neon|Ride"] = 37.01, ["Neon|Fly|Ride"] = 101.06, ["Mega"] = 144.36, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 327.92}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 53.66, ["Ride"] = 128.34, ["Fly|Ride"] = 253.32, ["Neon"] = 352.86, ["Neon|Ride"] = 498.26, ["Neon|Fly|Ride"] = 713.18, ["Mega"] = 1561.54, ["Mega|Fly|Ride"] = 1695.2}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 845.24, ["Fly"] = 920.14, ["Ride"] = 862.04, ["Fly|Ride"] = 877.32, ["Neon|Ride"] = 2887.5, ["Neon|Fly|Ride"] = 2820.04, ["Mega|Fly|Ride"] = 11418.75}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 708.75, ["Ride"] = 1140.84, ["Fly|Ride"] = 840, ["Neon|Fly|Ride"] = 4267.16, ["Mega|Fly|Ride"] = 15521.34}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 15.75, ["Fly"] = 26.25, ["Ride"] = 24.28, ["Fly|Ride"] = 44.61, ["Neon"] = 111.57, ["Neon|Ride"] = 106.94, ["Neon|Fly|Ride"] = 162.33, ["Mega|Fly|Ride"] = 846.78}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 9.3, ["Ride"] = 27.53, ["Fly|Ride"] = 85.32, ["Neon"] = 141.44, ["Neon|Ride"] = 86.63, ["Neon|Fly|Ride"] = 250.04, ["Mega"] = 702.19, ["Mega|Ride"] = 426.19, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.49, ["Ride"] = 22.32, ["Fly|Ride"] = 143.29, ["Neon"] = 21.1, ["Neon|Fly"] = 323.44, ["Neon|Ride"] = 56.74, ["Neon|Fly|Ride"] = 186.56, ["Mega"] = 131.07, ["Mega|Fly"] = 549.21, ["Mega|Ride"] = 280.88, ["Mega|Fly|Ride"] = 285.2}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 32.81, ["Fly"] = 42.88, ["Ride"] = 40.26, ["Fly|Ride"] = 107.63, ["Neon"] = 237.2, ["Neon|Ride"] = 285.49, ["Neon|Fly|Ride"] = 233.05, ["Mega|Fly|Ride"] = 818.92}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 64.22, ["Ride"] = 106.8, ["Fly|Ride"] = 457.63, ["Neon"] = 437.07, ["Neon|Ride"] = 570.96, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2065.68, ["Mega|Ride"] = 1602.14, ["Mega|Fly|Ride"] = 1566.89}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 11.63, ["Fly"] = 43.32, ["Ride"] = 28.92, ["Fly|Ride"] = 78.45, ["Neon"] = 72.1, ["Neon|Fly"] = 128.13, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 149.43, ["Mega|Ride"] = 386.69, ["Mega|Fly|Ride"] = 459.37}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 46.01, ["Fly"] = 65.63, ["Ride"] = 41.98, ["Fly|Ride"] = 76.57, ["Neon"] = 336.8, ["Neon|Fly"] = 1426.32, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 2100, ["Mega|Ride"] = 1195.86, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.84, ["Fly"] = 38.07, ["Ride"] = 18.01, ["Fly|Ride"] = 39.38, ["Neon"] = 32.09, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 91.74, ["Mega"] = 747.67, ["Mega|Ride"] = 356.75, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 6.42, ["Fly"] = 49.37, ["Ride"] = 33.44, ["Fly|Ride"] = 65.63, ["Neon"] = 52.37, ["Neon|Fly"] = 115.54, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 250.2, ["Mega"] = 319.37, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 437.94}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 52.5, ["Fly"] = 65.63, ["Ride"] = 54.03, ["Fly|Ride"] = 94.5, ["Neon"] = 578.44, ["Neon|Fly"] = 211.3, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 262.49, ["Mega|Fly|Ride"] = 1074.92}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1640.63, ["Fly"] = 1903.13, ["Ride"] = 1408.4, ["Fly|Ride"] = 1496.25, ["Neon|Fly|Ride"] = 3460.52}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 461.99, ["Ride"] = 446.25, ["Fly|Ride"] = 511.88, ["Neon|Fly|Ride"] = 2846.2}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 272.86, ["Ride"] = 347.19, ["Fly|Ride"] = 459.38, ["Neon"] = 1181.25, ["Neon|Ride"] = 1568.52, ["Neon|Fly|Ride"] = 1692.55, ["Mega|Fly|Ride"] = 7644}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 45.44}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 24.93, ["Ride"] = 51.17, ["Fly|Ride"] = 97.12, ["Neon"] = 325.5, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 350.44, ["Mega|Ride"] = 1565.83, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 34171.34, ["Fly"] = 65625, ["Ride"] = 35437.5, ["Fly|Ride"] = 17979.94, ["Neon|Fly|Ride"] = 35437.5, ["Mega"] = 213615.69, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 292.61, ["Fly"] = 356.68, ["Ride"] = 249.38, ["Fly|Ride"] = 380.63, ["Neon"] = 1016.3, ["Neon|Fly"] = 1131.38, ["Neon|Ride"] = 891.45, ["Neon|Fly|Ride"] = 1036.88, ["Mega"] = 4272.33, ["Mega|Ride"] = 4271.27, ["Mega|Fly|Ride"] = 3286.66}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 210.69, ["Fly"] = 525, ["Ride"] = 212.79, ["Fly|Ride"] = 257.23, ["Neon|Fly|Ride"] = 1777.01}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 196.88, ["Fly"] = 285.13, ["Ride"] = 157.5, ["Fly|Ride"] = 252.83, ["Neon|Ride"] = 412.54, ["Neon|Fly|Ride"] = 660.77, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 15.59, ["Fly"] = 94.5, ["Ride"] = 28.88, ["Fly|Ride"] = 126, ["Neon|Ride"] = 89.65, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 723.4, ["Mega|Ride"] = 712.42, ["Mega|Fly|Ride"] = 826.71}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4265.63, ["Ride"] = 3937.5, ["Fly|Ride"] = 5189.87, ["Neon"] = 27798.96, ["Neon|Fly|Ride"] = 17250.33}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 28.88, ["Fly"] = 64.1, ["Ride"] = 27.42, ["Fly|Ride"] = 49.09, ["Neon"] = 225.31, ["Neon|Ride"] = 232.32, ["Neon|Fly|Ride"] = 171.09, ["Mega|Ride"] = 1424.83, ["Mega|Fly|Ride"] = 733.79}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 49, ["Ride"] = 56.79, ["Fly|Ride"] = 96.56, ["Neon"] = 314.26, ["Neon|Fly"] = 1426.32, ["Neon|Ride"] = 204.75, ["Neon|Fly|Ride"] = 262.47, ["Mega|Fly|Ride"] = 1372.88}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 576.65, ["Fly"] = 656.25, ["Ride"] = 834.96, ["Fly|Ride"] = 917.44, ["Neon"] = 2543.77, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 1903.13, ["Mega|Fly|Ride"] = 9187.5}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 10.49, ["Fly"] = 26.25, ["Ride"] = 27.36, ["Fly|Ride"] = 47.55, ["Neon"] = 118.12, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 128.42, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 712.42, ["Mega|Fly|Ride"] = 854.47}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 11.93, ["Ride"] = 27.57, ["Fly|Ride"] = 80, ["Neon"] = 95.82, ["Neon|Ride"] = 121.14, ["Neon|Fly|Ride"] = 206.98, ["Mega|Ride"] = 833.12}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 107.09, ["Ride"] = 128.63, ["Fly|Ride"] = 156.19, ["Neon"] = 1010.63, ["Neon|Ride"] = 855.37, ["Neon|Fly|Ride"] = 855.37, ["Mega|Fly|Ride"] = 2739.19}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 18.09, ["Fly"] = 151.59, ["Ride"] = 68.16, ["Fly|Ride"] = 131.25, ["Neon"] = 71.65, ["Neon|Fly"] = 104.79, ["Neon|Ride"] = 110.21, ["Neon|Fly|Ride"] = 210, ["Mega"] = 315, ["Mega|Fly"] = 741.26, ["Mega|Ride"] = 278.25, ["Mega|Fly|Ride"] = 285.2}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3930.83, ["Fly"] = 6292.35, ["Ride"] = 4035.94, ["Fly|Ride"] = 4134.38, ["Neon"] = 19687.5, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 9842.44, ["Mega"] = 42722.08, ["Mega|Fly|Ride"] = 36773.72}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 31.5, ["Fly"] = 143.11, ["Ride"] = 78.75, ["Fly|Ride"] = 157.5, ["Neon"] = 399.9, ["Neon|Ride"] = 258.57, ["Neon|Fly|Ride"] = 574.23, ["Mega"] = 783.99, ["Mega|Ride"] = 1774.59, ["Mega|Fly|Ride"] = 782.23}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7612.5, ["Fly"] = 8827.95, ["Ride"] = 6857.82, ["Fly|Ride"] = 7168.87, ["Neon|Fly|Ride"] = 17692.5, ["Mega|Fly|Ride"] = 61237.22}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.02, ["Fly"] = 23.44, ["Ride"] = 18.99, ["Fly|Ride"] = 36.01, ["Neon"] = 24.61, ["Neon|Fly"] = 59.89, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 222.58, ["Mega|Ride"] = 372.75, ["Mega|Fly|Ride"] = 358.89}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 14.28, ["Fly"] = 38.74, ["Ride"] = 28.85, ["Fly|Ride"] = 55.74, ["Neon"] = 186.05, ["Neon|Fly"] = 236.31, ["Neon|Ride"] = 106.94, ["Neon|Fly|Ride"] = 161.44, ["Mega|Ride"] = 978.48, ["Mega|Fly|Ride"] = 935.82}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 4.2}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 11.59, ["Ride"] = 37.4, ["Fly|Ride"] = 116.02, ["Neon"] = 285.49, ["Neon|Ride"] = 98.49, ["Neon|Fly|Ride"] = 322.91, ["Mega"] = 1050, ["Mega|Ride"] = 640.86, ["Mega|Fly|Ride"] = 1290.72}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 29.52, ["Fly"] = 190.37, ["Ride"] = 70.7, ["Fly|Ride"] = 99.73, ["Neon"] = 155.82, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 318.94, ["Mega"] = 945, ["Mega|Ride"] = 854.47, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 12.84, ["Fly"] = 21.54, ["Ride"] = 21.37, ["Fly|Ride"] = 36.66, ["Neon|Ride"] = 143.29, ["Neon|Fly|Ride"] = 179.55, ["Mega"] = 2563.4, ["Mega|Ride"] = 603.64, ["Mega|Fly|Ride"] = 531.57}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8685.94}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.98}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 32.8}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 233.31, ["Ride"] = 392.41, ["Fly|Ride"] = 259.88, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 17.07, ["Fly"] = 128.93, ["Ride"] = 37.45, ["Fly|Ride"] = 128.42, ["Neon"] = 187.13, ["Neon|Ride"] = 116.81, ["Neon|Fly|Ride"] = 265.13, ["Mega"] = 525, ["Mega|Ride"] = 531.57, ["Mega|Fly|Ride"] = 1470}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 10.97}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 8.56, ["Ride"] = 30.98, ["Fly|Ride"] = 85.55, ["Neon|Ride"] = 249.38}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2766.95}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 194.91, ["Fly"] = 427.17, ["Ride"] = 213.86, ["Fly|Ride"] = 285.49, ["Neon"] = 927.01, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1568.52, ["Mega|Ride"] = 4130.27, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 85.66, ["Ride"] = 123.88, ["Fly|Ride"] = 213.86, ["Neon"] = 784.8, ["Neon|Ride"] = 564.55, ["Neon|Fly|Ride"] = 625.05, ["Mega|Ride"] = 2136.18, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 157.49, ["Fly"] = 315, ["Ride"] = 179.82, ["Fly|Ride"] = 213.45, ["Neon"] = 944.99, ["Neon|Ride"] = 787.4, ["Neon|Fly|Ride"] = 840, ["Mega|Fly|Ride"] = 4777.5}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2388.74, ["Fly"] = 3275.12, ["Ride"] = 2014.03, ["Fly|Ride"] = 2270.63, ["Neon"] = 15017.87, ["Neon|Ride"] = 8894.61, ["Neon|Fly|Ride"] = 7874.99, ["Mega|Fly|Ride"] = 20868.75}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 18.38, ["Fly"] = 105.74, ["Ride"] = 56.8, ["Fly|Ride"] = 99.75, ["Neon"] = 127.32, ["Neon|Ride"] = 154.62, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 960.21, ["Mega|Ride"] = 1088.72, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 805.19, ["Fly"] = 2100, ["Ride"] = 721.88, ["Fly|Ride"] = 774.38, ["Neon|Ride"] = 3849.09, ["Neon|Fly|Ride"] = 4199.64, ["Mega|Fly|Ride"] = 16935.27}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 48.07}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 14.33, ["Ride"] = 51.97, ["Fly|Ride"] = 471.93, ["Neon"] = 81.29, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 128.31, ["Neon|Fly|Ride"] = 242.71, ["Mega"] = 441.72, ["Mega|Ride"] = 484.92, ["Mega|Fly|Ride"] = 512.69}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 7.88, ["Fly"] = 262.5, ["Ride"] = 27.56, ["Fly|Ride"] = 105.88, ["Neon"] = 39.38, ["Neon|Fly"] = 315, ["Neon|Ride"] = 63.1, ["Neon|Fly|Ride"] = 209.94, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 399.48}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 52.5}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 19.29, ["Ride"] = 31.47, ["Fly|Ride"] = 83.42, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 254.63, ["Mega|Ride"] = 854.47, ["Mega|Fly|Ride"] = 2259.67}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 34.13, ["Fly"] = 52.5, ["Ride"] = 49.03, ["Fly|Ride"] = 52.41, ["Neon|Ride"] = 513.61, ["Neon|Fly|Ride"] = 340.02, ["Mega|Ride"] = 1814.51, ["Mega|Fly|Ride"] = 959.15}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6037.49, ["Fly"] = 10237.5, ["Ride"] = 6628.99, ["Fly|Ride"] = 4907.44, ["Neon|Fly|Ride"] = 12468.75, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 8.39, ["Fly"] = 65.63, ["Ride"] = 34.12, ["Fly|Ride"] = 81.37, ["Neon"] = 45.94, ["Neon|Fly"] = 143.29, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 226.53, ["Mega"] = 541.95, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 533.29}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 26.25}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 96.81, ["Fly"] = 378.05, ["Ride"] = 132.6, ["Fly|Ride"] = 160.09, ["Neon"] = 525, ["Neon|Ride"] = 455.44, ["Neon|Fly|Ride"] = 869.74, ["Mega|Fly|Ride"] = 2142.58}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 44.18, ["Fly"] = 140.91, ["Ride"] = 95.51, ["Fly|Ride"] = 190.32, ["Neon"] = 291.38, ["Neon|Ride"] = 285.04, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 967.75, ["Mega|Ride"] = 2883.82, ["Mega|Fly|Ride"] = 1200.94}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 21.59, ["Fly"] = 70.47, ["Ride"] = 30.19, ["Fly|Ride"] = 65, ["Neon"] = 116.82, ["Neon|Fly"] = 230.95, ["Neon|Ride"] = 143.07, ["Neon|Fly|Ride"] = 196.77, ["Mega|Ride"] = 826.71, ["Mega|Fly|Ride"] = 780.93}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6.02, ["Fly"] = 71.56, ["Ride"] = 22.84, ["Fly|Ride"] = 62.03, ["Neon"] = 32.78, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 52.48, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 216.57, ["Mega|Fly"] = 7120.89, ["Mega|Ride"] = 188.22, ["Mega|Fly|Ride"] = 268.96}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 12.73, ["Ride"] = 28.27, ["Fly|Ride"] = 94.5, ["Neon"] = 91.48, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 210, ["Mega|Fly|Ride"] = 591.73}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 17.71, ["Fly"] = 26.25, ["Ride"] = 23.63, ["Fly|Ride"] = 45.66, ["Neon"] = 371.02, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 150.94, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 223.13}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 24.59, ["Ride"] = 131.21, ["Fly|Ride"] = 285.49, ["Neon"] = 171.09, ["Neon|Ride"] = 231, ["Mega"] = 1203.75, ["Mega|Fly|Ride"] = 1040.32}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 250.22, ["Ride"] = 598.5, ["Fly|Ride"] = 3848.03, ["Neon|Fly|Ride"] = 28512.11}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 44.63, ["Fly"] = 212.52, ["Ride"] = 105.09, ["Fly|Ride"] = 174.72, ["Neon"] = 300.57, ["Neon|Ride"] = 295.32, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 1345.79, ["Mega|Ride"] = 971.25, ["Mega|Fly|Ride"] = 1105.22}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 945.46, ["Fly"] = 1381.83, ["Ride"] = 1007.99, ["Fly|Ride"] = 1049.99, ["Neon|Ride"] = 4199.64, ["Neon|Fly|Ride"] = 3662.79, ["Mega|Fly|Ride"] = 11681.25}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 388.5, ["Fly"] = 712.28, ["Ride"] = 413.44, ["Fly|Ride"] = 570.96, ["Neon"] = 2139.38, ["Neon|Ride"] = 2422.64, ["Neon|Fly|Ride"] = 2423.88, ["Mega"] = 7548.13, ["Mega|Ride"] = 7548.13, ["Mega|Fly|Ride"] = 7548.13}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 62.28}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 3.68}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 9.98, ["Fly"] = 23.27, ["Ride"] = 24.06, ["Fly|Ride"] = 50.68, ["Neon"] = 78.75, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 82.43, ["Neon|Fly|Ride"] = 166.69, ["Mega|Ride"] = 712.42, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 250.78, ["Fly"] = 392.03, ["Ride"] = 275.46, ["Fly|Ride"] = 354.53, ["Neon"] = 1131.22, ["Neon|Ride"] = 1080.51, ["Neon|Fly|Ride"] = 1062.12, ["Mega|Fly|Ride"] = 3396.5}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 13.31}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 113.97, ["Ride"] = 170.87, ["Fly|Ride"] = 252, ["Neon"] = 590.63, ["Neon|Ride"] = 746.41, ["Neon|Fly|Ride"] = 728.44, ["Mega"] = 3275.82, ["Mega|Ride"] = 12150.48, ["Mega|Fly|Ride"] = 2362.5}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 128.63, ["Fly"] = 213.6, ["Ride"] = 128.77, ["Fly|Ride"] = 213.86, ["Neon"] = 1140.84, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 1004.07, ["Neon|Fly|Ride"] = 913.5, ["Mega|Fly|Ride"] = 2563.4}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 5.13, ["Ride"] = 26.25, ["Fly|Ride"] = 174.28, ["Neon"] = 30.19, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 211.72, ["Mega"] = 264.75, ["Mega|Ride"] = 309.75, ["Mega|Fly|Ride"] = 853.41}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 15.59, ["Fly"] = 64.1, ["Ride"] = 27.14, ["Fly|Ride"] = 78.63, ["Neon"] = 177.19, ["Neon|Ride"] = 149.7, ["Neon|Fly|Ride"] = 242.28, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 13.05, ["Fly"] = 102.36, ["Ride"] = 34.73, ["Fly|Ride"] = 131.25, ["Neon"] = 78.75, ["Neon|Ride"] = 101.06, ["Neon|Fly|Ride"] = 256.57, ["Mega"] = 498.75, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 7.87, ["Fly"] = 98.07, ["Ride"] = 53.81, ["Fly|Ride"] = 170.63, ["Neon"] = 19.67, ["Neon|Ride"] = 69.67, ["Neon|Fly|Ride"] = 154.88, ["Mega"] = 136.49, ["Mega|Ride"] = 217.9, ["Mega|Fly|Ride"] = 288.7}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 249.38, ["Ride"] = 290.05, ["Fly|Ride"] = 360.94, ["Neon"] = 1682.92, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 6266.43}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 111.17, ["Fly"] = 329.15, ["Ride"] = 160.78, ["Fly|Ride"] = 238.98, ["Neon"] = 525, ["Neon|Ride"] = 459.36, ["Neon|Fly|Ride"] = 624.79, ["Mega|Fly|Ride"] = 5697.15}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 60.12, ["Fly"] = 167.45, ["Ride"] = 72.19, ["Fly|Ride"] = 128.31, ["Neon"] = 380.63, ["Neon|Ride"] = 461.9, ["Neon|Fly|Ride"] = 408.19, ["Mega|Fly|Ride"] = 1801.14}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 16.7, ["Fly"] = 78.75, ["Ride"] = 28.88, ["Fly|Ride"] = 285.49, ["Neon"] = 115.5, ["Neon|Ride"] = 615.37, ["Neon|Fly|Ride"] = 499.32, ["Mega|Fly|Ride"] = 2079.56}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 14.42, ["Fly"] = 24.22, ["Ride"] = 28.85, ["Fly|Ride"] = 85.55, ["Neon"] = 77.43, ["Neon|Ride"] = 109.07, ["Neon|Fly|Ride"] = 151.85, ["Mega"] = 371.44, ["Mega|Fly"] = 525, ["Mega|Ride"] = 483.88, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.11, ["Fly"] = 52.47, ["Ride"] = 19.29, ["Fly|Ride"] = 50.27, ["Neon"] = 20.45, ["Neon|Fly"] = 84.14, ["Neon|Ride"] = 51.34, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 128.63, ["Mega|Ride"] = 166.69, ["Mega|Fly|Ride"] = 256.07}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 1055.11, ["Fly"] = 1082.18, ["Ride"] = 892.5, ["Fly|Ride"] = 918.65, ["Neon"] = 3565.77, ["Neon|Ride"] = 5250, ["Neon|Fly|Ride"] = 2624.99, ["Mega|Fly|Ride"] = 10964.9}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 405.8, ["Fly"] = 413.27, ["Ride"] = 393.65, ["Fly|Ride"] = 393.75, ["Neon"] = 1277.38, ["Neon|Ride"] = 2566.07, ["Neon|Fly|Ride"] = 1682.92, ["Mega|Fly|Ride"] = 5980.19}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 81.5, ["Fly"] = 170.87, ["Ride"] = 103.64, ["Fly|Ride"] = 196.88, ["Neon"] = 328.26, ["Neon|Ride"] = 326.32, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 1708.93}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 210, ["Fly"] = 283.5, ["Ride"] = 223.13, ["Fly|Ride"] = 270.14, ["Neon|Fly|Ride"] = 1094.62, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 19.68, ["Fly"] = 85.44, ["Ride"] = 26.25, ["Fly|Ride"] = 72.19, ["Neon"] = 169.32, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 236.25, ["Mega|Ride"] = 570.38, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 236.25, ["Ride"] = 255.68, ["Fly|Ride"] = 616.88, ["Neon"] = 755.2, ["Neon|Ride"] = 942.27, ["Neon|Fly|Ride"] = 971.25, ["Mega"] = 4173.75, ["Mega|Ride"] = 4699.56, ["Mega|Fly|Ride"] = 4313.98}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 61.49, ["Fly"] = 125.98, ["Ride"] = 77.78, ["Fly|Ride"] = 106.46, ["Neon|Ride"] = 610.52, ["Neon|Fly|Ride"] = 570.96, ["Mega|Fly|Ride"] = 1732.5}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1968.75, ["Ride"] = 2165.63, ["Fly|Ride"] = 2021.14, ["Neon|Ride"] = 11306.4, ["Neon|Fly|Ride"] = 7722.75, ["Mega"] = 51267.78, ["Mega|Fly|Ride"] = 24922.55}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 13.41, ["Fly"] = 77.26, ["Ride"] = 38.19, ["Fly|Ride"] = 51.98, ["Neon"] = 66.94, ["Neon|Fly"] = 237.38, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 209.36, ["Mega"] = 356.75, ["Mega|Fly"] = 561.52, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 53.8, ["Ride"] = 72.19, ["Fly|Ride"] = 105, ["Neon"] = 223.13, ["Neon|Ride"] = 371.88, ["Neon|Fly|Ride"] = 570.96, ["Mega|Ride"] = 1424.83, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 78.66, ["Fly"] = 91.85, ["Ride"] = 78.1, ["Fly|Ride"] = 78.75, ["Neon"] = 525, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1879.8}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2135.73, ["Fly"] = 1614.24, ["Ride"] = 1069.68, ["Fly|Ride"] = 1168.13, ["Neon|Ride"] = 5168.69, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 565.11, ["Fly"] = 525, ["Ride"] = 671.08, ["Fly|Ride"] = 616.88, ["Neon|Fly|Ride"] = 3230.58}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 72.77, ["Fly"] = 323.1, ["Ride"] = 99.65, ["Fly|Ride"] = 196.88, ["Neon"] = 445.6, ["Neon|Ride"] = 393.74, ["Neon|Fly|Ride"] = 459.38, ["Mega|Ride"] = 2581.43, ["Mega|Fly|Ride"] = 3562.07}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 8.86, ["Ride"] = 21.68, ["Fly|Ride"] = 61.64, ["Neon"] = 69.05, ["Neon|Fly"] = 143.29, ["Neon|Ride"] = 70.55, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 603.75, ["Mega|Ride"] = 773.31}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 42.73, ["Fly"] = 68.25, ["Ride"] = 55.13, ["Fly|Ride"] = 106.94, ["Neon"] = 284.82, ["Neon|Fly"] = 342.16, ["Neon|Ride"] = 221.68, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 1115.63, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 768.11, ["Fly"] = 1113.28, ["Ride"] = 761.25, ["Fly|Ride"] = 832.09, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2228.63, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 707.44}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 5236.88, ["Ride"] = 6173.52, ["Fly|Ride"] = 5987.48, ["Neon"] = 42000, ["Neon|Ride"] = 30644.09, ["Neon|Fly|Ride"] = 17584.88, ["Mega|Fly|Ride"] = 79037.82}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 274.16, ["Fly"] = 400.46, ["Neon"] = 1710.73, ["Neon|Fly|Ride"] = 2231.25, ["Mega"] = 6408.49, ["Mega|Fly|Ride"] = 6774.12}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 70.87, ["Fly"] = 285.13, ["Ride"] = 121.96, ["Fly|Ride"] = 336, ["Neon"] = 641.53, ["Neon|Ride"] = 584.87, ["Neon|Fly|Ride"] = 641.53, ["Mega|Fly|Ride"] = 2194.91}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 17.07, ["Fly"] = 42.09, ["Ride"] = 35.43, ["Fly|Ride"] = 90.86, ["Neon"] = 152.24, ["Neon|Fly"] = 1292.48, ["Neon|Ride"] = 125.99, ["Neon|Fly|Ride"] = 181.72, ["Mega"] = 995.46, ["Mega|Ride"] = 854.47, ["Mega|Fly|Ride"] = 824.58}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 13.13, ["Fly"] = 34.18, ["Ride"] = 23.63, ["Fly|Ride"] = 46.68, ["Neon"] = 213.86, ["Neon|Ride"] = 323.44, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2136.18}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 14.43, ["Fly"] = 285.13, ["Ride"] = 27.28, ["Fly|Ride"] = 111.21, ["Neon"] = 154.88, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 237.38, ["Mega"] = 645.75, ["Mega|Ride"] = 658.88, ["Mega|Fly|Ride"] = 626.07}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.63, ["Fly"] = 79.04, ["Ride"] = 22.32, ["Fly|Ride"] = 48.57, ["Neon"] = 35.44, ["Neon|Ride"] = 56.11, ["Neon|Fly|Ride"] = 121.53, ["Mega"] = 320.44, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 323}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 26.07, ["Fly"] = 90.57, ["Ride"] = 39.37, ["Fly|Ride"] = 139.13, ["Neon"] = 157.5, ["Neon|Fly"] = 855.37, ["Neon|Ride"] = 193.82, ["Neon|Fly|Ride"] = 451.5, ["Mega"] = 610.33, ["Mega|Ride"] = 1253.44}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 463.18, ["Fly"] = 465.94, ["Ride"] = 457.72, ["Fly|Ride"] = 523.69, ["Neon"] = 1601.66, ["Neon|Ride"] = 1426.32, ["Neon|Fly|Ride"] = 1378.13, ["Mega"] = 7875, ["Mega|Fly|Ride"] = 5831.73}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.63, ["Fly"] = 19.56, ["Ride"] = 13.34, ["Fly|Ride"] = 28.88, ["Neon"] = 19.46, ["Neon|Ride"] = 35.07, ["Neon|Fly|Ride"] = 70.51, ["Mega"] = 230.71, ["Mega|Ride"] = 226.45, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 36.19, ["Fly"] = 95.42, ["Ride"] = 72.61, ["Fly|Ride"] = 140.44, ["Neon"] = 183.72, ["Neon|Fly"] = 333.15, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 276.04, ["Mega"] = 498.75, ["Mega|Ride"] = 551.25, ["Mega|Fly|Ride"] = 589.32}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 794.07, ["Ride"] = 826.77, ["Fly|Ride"] = 826.88, ["Neon|Ride"] = 1988.23, ["Neon|Fly|Ride"] = 1744.32, ["Mega|Fly|Ride"] = 3543.75}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 42.73, ["Fly"] = 60.38, ["Ride"] = 65.58, ["Fly|Ride"] = 90.56, ["Neon|Ride"] = 188.9, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 851.8}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 262.5, ["Fly"] = 428.38, ["Ride"] = 290.79, ["Fly|Ride"] = 378, ["Neon|Ride"] = 1853.99, ["Neon|Fly|Ride"] = 1283.04}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 181.91, ["Fly"] = 178.47, ["Ride"] = 196.88, ["Fly|Ride"] = 233.82, ["Neon"] = 998.64, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 4326, ["Mega|Fly|Ride"] = 3547.1}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 834.74, ["Ride"] = 754.69, ["Fly|Ride"] = 812.34, ["Neon|Fly|Ride"] = 3045.26, ["Mega|Fly|Ride"] = 7611.19}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 20.13, ["Fly"] = 85.44, ["Ride"] = 40.92, ["Fly|Ride"] = 100.52, ["Neon"] = 100.56, ["Neon|Fly"] = 290.73, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 186.05, ["Mega"] = 354.38, ["Mega|Ride"] = 426.19, ["Mega|Fly|Ride"] = 480.24}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4084.49, ["Fly"] = 3336.36, ["Ride"] = 3543.75, ["Fly|Ride"] = 3359.99, ["Neon"] = 14256.6, ["Neon|Fly|Ride"] = 7350, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 106.32, ["Fly"] = 171.42, ["Ride"] = 140.98, ["Fly|Ride"] = 196.88, ["Neon"] = 433.13, ["Neon|Fly"] = 570.96, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 577.5, ["Mega|Fly|Ride"] = 2421.35}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.47, ["Fly"] = 27.78, ["Ride"] = 19.23, ["Fly|Ride"] = 38.57, ["Neon"] = 21.39, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 35.35, ["Neon|Fly|Ride"] = 113.34, ["Mega"] = 153.07, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 370.64, ["Mega|Fly|Ride"] = 228.59}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.88, ["Ride"] = 24.56, ["Fly|Ride"] = 57.71, ["Neon"] = 20.9, ["Neon|Fly"] = 118.72, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 162.33, ["Mega"] = 159.21, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 383.45}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 36.32, ["Fly"] = 85.44, ["Ride"] = 42.88, ["Fly|Ride"] = 56.34, ["Neon|Fly|Ride"] = 301.88, ["Mega|Fly|Ride"] = 997.6}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 945, ["Ride"] = 1050, ["Fly|Ride"] = 1115.52}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6693.75, ["Fly|Ride"] = 6431.25}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 20.69, ["Fly"] = 26.25, ["Ride"] = 26.03, ["Fly|Ride"] = 55.13, ["Neon"] = 452.13, ["Neon|Ride"] = 158.25, ["Neon|Fly|Ride"] = 162.33, ["Mega"] = 2520, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 13.12, ["Ride"] = 28.85, ["Fly|Ride"] = 78.74, ["Neon"] = 85.55, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 932.46, ["Mega|Ride"] = 570.38, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 90.57, ["Fly"] = 157.5, ["Ride"] = 85.18, ["Fly|Ride"] = 124.69, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 402.7, ["Mega|Fly|Ride"] = 2050.73}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 219.23, ["Ride"] = 242.82, ["Fly|Ride"] = 280.76, ["Neon|Ride"] = 1053.41, ["Neon|Fly|Ride"] = 984.38, ["Mega|Fly|Ride"] = 4518.1}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.94, ["Ride"] = 32.79, ["Fly|Ride"] = 93.09, ["Neon"] = 20.27, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 49.53, ["Mega"] = 152.12, ["Mega|Fly"] = 228.68, ["Mega|Ride"] = 242.46, ["Mega|Fly|Ride"] = 1422.7}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 170.35, ["Ride"] = 225.39, ["Fly|Ride"] = 288.74, ["Neon"] = 1278.77, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 969.06, ["Mega"] = 3274.74, ["Mega|Fly|Ride"] = 3547.1}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.34, ["Fly"] = 42.73, ["Ride"] = 16.95, ["Fly|Ride"] = 53.82, ["Neon"] = 23.48, ["Neon|Fly"] = 128.31, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 104.5, ["Mega"] = 225.75, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 223.13, ["Fly"] = 318.26, ["Ride"] = 221.82, ["Fly|Ride"] = 236.25, ["Neon|Ride"] = 1211.33, ["Neon|Fly|Ride"] = 998.64, ["Mega"] = 10680.79, ["Mega|Fly|Ride"] = 5484.62}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 11.69, ["Fly"] = 77.44, ["Ride"] = 27.57, ["Fly|Ride"] = 68.25, ["Neon"] = 100.52, ["Neon|Fly"] = 307.7, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 478.52, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 3.82, ["Ride"] = 23.88, ["Fly|Ride"] = 72.19, ["Neon"] = 10.5, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 195.57, ["Mega"] = 73.5, ["Mega|Ride"] = 106.47, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.5, ["Neon"] = 3.84, ["Mega"] = 15.44, ["Mega|Ride"] = 142.76, ["Mega|Fly|Ride"] = 320.44}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.12, ["Fly"] = 52.49, ["Ride"] = 31.25, ["Fly|Ride"] = 110.15, ["Neon"] = 6.01, ["Neon|Ride"] = 27.82, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 75.49, ["Mega|Fly"] = 161289.01, ["Mega|Ride"] = 91.96, ["Mega|Fly|Ride"] = 200.1}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 69.57, ["Fly"] = 525, ["Ride"] = 192.23, ["Fly|Ride"] = 204.75, ["Neon"] = 308.44, ["Neon|Fly"] = 406.31, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 368.81, ["Mega|Ride"] = 1388.51, ["Mega|Fly|Ride"] = 1281.57}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 34.13, ["Ride"] = 15.74, ["Fly|Ride"] = 113.34, ["Neon"] = 9.16, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 96.79, ["Mega|Ride"] = 165.38, ["Mega|Fly|Ride"] = 261.45}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 7.75, ["Neon"] = 78.61, ["Neon|Ride"] = 213.86, ["Neon|Fly|Ride"] = 223.11, ["Mega"] = 393.75, ["Mega|Ride"] = 553.28}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Ride"] = 28.85, ["Neon"] = 2.1, ["Neon|Ride"] = 52.36, ["Neon|Fly|Ride"] = 277.32, ["Mega"] = 21.38, ["Mega|Fly"] = 143.13, ["Mega|Ride"] = 49.38, ["Mega|Fly|Ride"] = 170.9}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 1.79, ["Fly"] = 64.96, ["Ride"] = 15.75, ["Fly|Ride"] = 24.92, ["Neon"] = 2.1, ["Neon|Fly"] = 26.24, ["Neon|Ride"] = 14.17, ["Neon|Fly|Ride"] = 28.88, ["Mega"] = 16.01, ["Mega|Fly"] = 42.74, ["Mega|Ride"] = 19.69, ["Mega|Fly|Ride"] = 65.34}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 19.57, ["Ride"] = 15, ["Fly|Ride"] = 64.79, ["Neon"] = 2.63, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 39.27, ["Mega"] = 28.88, ["Mega|Fly"] = 162.1, ["Mega|Ride"] = 33.13, ["Mega|Fly|Ride"] = 84.44}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 67.57, ["Mega"] = 20.92, ["Mega|Ride"] = 100.42}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 91.85, ["Ride"] = 31.47, ["Fly|Ride"] = 107.63, ["Neon"] = 3.94, ["Neon|Fly"] = 168, ["Neon|Ride"] = 20.66, ["Neon|Fly|Ride"] = 81.38, ["Mega"] = 26.16, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 42.88, ["Mega|Fly|Ride"] = 95.42}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 82.09, ["Neon|Fly|Ride"] = 402.31, ["Mega"] = 15.54, ["Mega|Fly"] = 138.86, ["Mega|Ride"] = 806.86}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 71.56, ["Ride"] = 32.8, ["Fly|Ride"] = 47.78, ["Neon"] = 15.64, ["Neon|Fly"] = 69.28, ["Neon|Ride"] = 45.92, ["Neon|Fly|Ride"] = 131.15, ["Mega"] = 105, ["Mega|Fly"] = 273.56, ["Mega|Ride"] = 123.43, ["Mega|Fly|Ride"] = 207.9}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 27.82, ["Neon"] = 2.37, ["Neon|Ride"] = 77.97, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 14.6, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 66.85, ["Mega|Fly|Ride"] = 181.59}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.52, ["Ride"] = 144.36, ["Fly|Ride"] = 524.99, ["Neon"] = 18.12, ["Mega"] = 162.75, ["Mega|Fly"] = 315, ["Mega|Ride"] = 285.2, ["Mega|Fly|Ride"] = 553.28}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Neon"] = 16.94, ["Mega"] = 104.99, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 570.38}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.63, ["Ride"] = 32.8, ["Neon"] = 3.93, ["Neon|Ride"] = 27.34, ["Neon|Fly|Ride"] = 143.29, ["Mega"] = 19.69, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 131.24}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 14.31, ["Fly|Ride"] = 40.69, ["Neon"] = 2.1, ["Neon|Fly"] = 35.32, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 33.16, ["Mega"] = 13.13, ["Mega|Fly"] = 28.92, ["Mega|Ride"] = 18.65, ["Mega|Fly|Ride"] = 56.25}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 229.68, ["Fly|Ride"] = 118.11, ["Neon"] = 39.38, ["Neon|Ride"] = 140.95, ["Mega"] = 170.9, ["Mega|Ride"] = 240.19}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 27.85, ["Neon"] = 3.94, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 28.87, ["Neon|Fly|Ride"] = 105, ["Mega"] = 31.46, ["Mega|Ride"] = 45.85, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 3.5, ["Neon"] = 15.54, ["Mega"] = 85.67, ["Mega|Ride"] = 162.36, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.52, ["Fly"] = 65.63, ["Ride"] = 47.07, ["Fly|Ride"] = 59.07, ["Neon"] = 23.55, ["Neon|Ride"] = 50.27, ["Neon|Fly|Ride"] = 143.29, ["Mega"] = 124.69, ["Mega|Ride"] = 143.06, ["Mega|Fly|Ride"] = 193.56}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 1.79, ["Fly"] = 20.31, ["Ride"] = 11.79, ["Fly|Ride"] = 27.36, ["Neon"] = 2.1, ["Neon|Fly"] = 15.62, ["Neon|Ride"] = 11.71, ["Neon|Fly|Ride"] = 28.25, ["Mega"] = 14.44, ["Mega|Fly"] = 27.57, ["Mega|Ride"] = 21.94, ["Mega|Fly|Ride"] = 47.87}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 28.46, ["Ride"] = 27.39, ["Fly|Ride"] = 131.25, ["Neon"] = 9.74, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 129.65, ["Mega|Ride"] = 162.1, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.1, ["Fly"] = 112.52, ["Ride"] = 140.02, ["Fly|Ride"] = 59.06, ["Neon"] = 41.91, ["Neon|Ride"] = 67.48, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 261.19, ["Mega|Ride"] = 338.72, ["Mega|Fly|Ride"] = 311.73}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 32.61, ["Ride"] = 13.71, ["Fly|Ride"] = 36.75, ["Neon"] = 2.37, ["Neon|Fly"] = 17.12, ["Neon|Ride"] = 14.23, ["Neon|Fly|Ride"] = 50.99, ["Mega"] = 24.21, ["Mega|Ride"] = 31.49, ["Mega|Fly|Ride"] = 82.69}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 178.35, ["Ride"] = 31.5, ["Neon"] = 5.51, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 167.25, ["Mega"] = 63.95, ["Mega|Fly"] = 170.9, ["Mega|Ride"] = 98.34, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Neon"] = 5.23, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 143.29, ["Mega"] = 39.38, ["Mega|Fly"] = 143.13, ["Mega|Ride"] = 72.1, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 36.32, ["Ride"] = 18.18, ["Neon"] = 2.1, ["Neon|Fly"] = 42.78, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 285.49, ["Mega"] = 15.14, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 178.38}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 71.56, ["Ride"] = 14.32, ["Fly|Ride"] = 46.45, ["Neon"] = 4.69, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 21.39, ["Neon|Fly|Ride"] = 56.99, ["Mega"] = 143.48, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 19.59, ["Neon"] = 4.08, ["Neon|Ride"] = 63.1, ["Mega"] = 33.5, ["Mega|Ride"] = 96.93, ["Mega|Fly|Ride"] = 249.37}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 23.5, ["Ride"] = 13.13, ["Fly|Ride"] = 47.07, ["Neon"] = 5.2, ["Neon|Fly"] = 79.98, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 64.97, ["Mega"] = 103.69, ["Mega|Ride"] = 90.54, ["Mega|Fly|Ride"] = 118.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.1, ["Ride"] = 36.37, ["Fly|Ride"] = 50.05, ["Neon"] = 42.41, ["Neon|Fly"] = 250.2, ["Neon|Fly|Ride"] = 327.3, ["Mega"] = 98.44, ["Mega|Ride"] = 168.38}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 14.42, ["Fly|Ride"] = 57.75, ["Neon"] = 11.64, ["Neon|Fly"] = 48.46, ["Neon|Ride"] = 30.56, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 315, ["Mega|Fly"] = 420, ["Mega|Ride"] = 122.72, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 143.2, ["Ride"] = 26.25, ["Fly|Ride"] = 52.48, ["Neon"] = 16.06, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 21.05, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 222.17, ["Mega|Fly"] = 138.99, ["Mega|Ride"] = 427.25, ["Mega|Fly|Ride"] = 174.57}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 113.22, ["Fly|Ride"] = 96.92, ["Neon"] = 26.25, ["Neon|Ride"] = 105.4, ["Mega"] = 162.31, ["Mega|Ride"] = 236.24}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 23.56, ["Ride"] = 56.44, ["Neon"] = 262.4, ["Mega"] = 570.38, ["Mega|Ride"] = 712.42, ["Mega|Fly|Ride"] = 810.69}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 6.06, ["Ride"] = 34.23, ["Neon"] = 42.68, ["Neon|Ride"] = 106.55, ["Mega"] = 237.57, ["Mega|Ride"] = 365.53}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 4.91, ["Ride"] = 31.39, ["Fly|Ride"] = 120.75, ["Neon"] = 53.31, ["Neon|Ride"] = 79.96, ["Mega"] = 483.88, ["Mega|Ride"] = 426.19, ["Mega|Fly|Ride"] = 364.22}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 65, ["Mega"] = 23, ["Mega|Ride"] = 67.3, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 46.23}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 2.52, ["Fly"] = 23.61, ["Ride"] = 28.11, ["Fly|Ride"] = 43.31, ["Neon"] = 49.46, ["Neon|Fly"] = 188.48, ["Neon|Ride"] = 47.76, ["Neon|Fly|Ride"] = 78.62, ["Mega"] = 271.44, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 427.25}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 1.98, ["Fly"] = 65.63, ["Ride"] = 15.75, ["Fly|Ride"] = 52.5, ["Neon"] = 6.43, ["Neon|Fly"] = 52.8, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 159.91, ["Mega"] = 28.88, ["Mega|Fly"] = 143.13, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Neon"] = 5.16, ["Neon|Ride"] = 35.11, ["Mega"] = 39.26, ["Mega|Ride"] = 242.46, ["Mega|Fly|Ride"] = 135.66}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 51.47, ["Ride"] = 19.26, ["Fly|Ride"] = 42.83, ["Neon"] = 6.57, ["Neon|Ride"] = 21.39, ["Neon|Fly|Ride"] = 129.63, ["Mega"] = 130.32, ["Mega|Ride"] = 118, ["Mega|Fly|Ride"] = 190.13}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.89, ["Ride"] = 41.91, ["Fly|Ride"] = 57.75, ["Neon"] = 28.88, ["Neon|Ride"] = 49.26, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 128.63, ["Mega|Ride"] = 285.2, ["Mega|Fly|Ride"] = 320.44}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 32.47, ["Neon"] = 3.8, ["Mega"] = 19.85, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 61.78, ["Mega|Fly|Ride"] = 341.8}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 22.23, ["Ride"] = 16.86, ["Fly|Ride"] = 58.97, ["Neon"] = 3.47, ["Neon|Fly"] = 111.47, ["Neon|Ride"] = 21.39, ["Neon|Fly|Ride"] = 96.92, ["Mega"] = 28.87, ["Mega|Fly"] = 143.16, ["Mega|Ride"] = 39.29, ["Mega|Fly|Ride"] = 103.69}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.85, ["Ride"] = 18.38, ["Fly|Ride"] = 42.14, ["Neon"] = 4.99, ["Neon|Fly"] = 71.65, ["Neon|Ride"] = 18.15, ["Neon|Fly|Ride"] = 61.04, ["Mega"] = 47.95, ["Mega|Fly"] = 143.13, ["Mega|Ride"] = 41.99, ["Mega|Fly|Ride"] = 110.02}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 28.85, ["Ride"] = 54.54, ["Fly|Ride"] = 115.5, ["Neon"] = 7.88, ["Neon|Ride"] = 28.41, ["Neon|Fly|Ride"] = 114.42, ["Mega"] = 45.46, ["Mega|Ride"] = 80.85, ["Mega|Fly|Ride"] = 228.59}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.11, ["Neon|Ride"] = 32.09, ["Neon|Fly|Ride"] = 156015.8, ["Mega"] = 24.94, ["Mega|Fly"] = 96.79, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 136.48}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.89, ["Ride"] = 16.98, ["Fly|Ride"] = 81.27, ["Neon"] = 3.82, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 24.61, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 19.69, ["Mega|Fly"] = 64.11, ["Mega|Ride"] = 40.53, ["Mega|Fly|Ride"] = 103.25}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 18.38, ["Neon"] = 3.81, ["Neon|Ride"] = 40.64, ["Mega"] = 19.69, ["Mega|Ride"] = 420.23, ["Mega|Fly|Ride"] = 271.31}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 4.5, ["Neon|Ride"] = 323.44, ["Neon|Fly|Ride"] = 420, ["Mega"] = 25.35, ["Mega|Ride"] = 155.91}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 14.43, ["Fly|Ride"] = 49.87, ["Neon"] = 5.25, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 17.05, ["Neon|Fly|Ride"] = 48.39, ["Mega"] = 114.3, ["Mega|Fly"] = 45.24, ["Mega|Ride"] = 99.04, ["Mega|Fly|Ride"] = 106.47}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 9.19, ["Ride"] = 59.06, ["Fly|Ride"] = 213.86, ["Neon"] = 73.5, ["Mega"] = 570.38, ["Mega|Ride"] = 467.25}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.42, ["Fly"] = 6562.5, ["Ride"] = 56.44, ["Neon"] = 45.93, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 3.87, ["Ride"] = 30.5, ["Fly|Ride"] = 178.76, ["Neon"] = 26.24, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 427.69, ["Mega"] = 397.95, ["Mega|Ride"] = 413.36, ["Mega|Fly|Ride"] = 375.26}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 1.79, ["Fly"] = 14.95, ["Ride"] = 11.82, ["Fly|Ride"] = 25.72, ["Neon"] = 2.1, ["Neon|Fly"] = 15.63, ["Neon|Ride"] = 12.85, ["Neon|Fly|Ride"] = 27.93, ["Mega"] = 15.63, ["Mega|Fly"] = 26.25, ["Mega|Ride"] = 21.53, ["Mega|Fly|Ride"] = 40.28}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 60.38, ["Neon"] = 6.57, ["Neon|Fly"] = 67.79, ["Neon|Ride"] = 33.15, ["Neon|Fly|Ride"] = 713.18, ["Mega"] = 71.76, ["Mega|Ride"] = 117.93}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.49, ["Neon"] = 2.1, ["Neon|Fly"] = 32.09, ["Neon|Ride"] = 23.55, ["Neon|Fly|Ride"] = 84.16, ["Mega"] = 14.44, ["Mega|Fly"] = 90.57, ["Mega|Ride"] = 71.9, ["Mega|Fly|Ride"] = 135.66}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.27, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 127.32, ["Mega"] = 24.09, ["Mega|Fly|Ride"] = 170.9}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 41.99, ["Ride"] = 17.83, ["Fly|Ride"] = 57.75, ["Neon"] = 19.66, ["Neon|Ride"] = 36.37, ["Neon|Fly|Ride"] = 69.01, ["Mega"] = 183.75, ["Mega|Ride"] = 199.75, ["Mega|Fly|Ride"] = 291.38}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 153.22, ["Fly"] = 183.75, ["Ride"] = 168.25, ["Fly|Ride"] = 411.87, ["Neon|Fly|Ride"] = 969.77, ["Mega"] = 8544.64, ["Mega|Ride"] = 3275.82, ["Mega|Fly|Ride"] = 4034.23}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 24.22, ["Neon"] = 8.05, ["Neon|Ride"] = 64.32, ["Mega"] = 89.98, ["Mega|Ride"] = 178.38, ["Mega|Fly|Ride"] = 635.52}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.94, ["Fly"] = 65.63, ["Ride"] = 26.24, ["Fly|Ride"] = 61.46, ["Neon"] = 31.62, ["Neon|Ride"] = 171.09, ["Neon|Fly|Ride"] = 143.29, ["Mega"] = 381.82, ["Mega|Ride"] = 532.98, ["Mega|Fly|Ride"] = 645.98}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 27.67, ["Ride"] = 15.26, ["Fly|Ride"] = 32.8, ["Neon"] = 4.78, ["Neon|Fly"] = 33.15, ["Neon|Ride"] = 29.77, ["Neon|Fly|Ride"] = 47.41, ["Mega"] = 49.76, ["Mega|Ride"] = 82.6, ["Mega|Fly|Ride"] = 143.13}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 71.56, ["Ride"] = 19.69, ["Fly|Ride"] = 92.58, ["Neon"] = 8.22, ["Neon|Fly"] = 570.96, ["Neon|Ride"] = 52.29, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 74.78, ["Mega|Ride"] = 213.63, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.15, ["Fly"] = 24.74, ["Ride"] = 15.64, ["Fly|Ride"] = 37.9, ["Neon"] = 28.23, ["Neon|Fly"] = 100.52, ["Neon|Ride"] = 43.31, ["Neon|Fly|Ride"] = 77.95, ["Mega|Ride"] = 285.2, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 6.34, ["Ride"] = 42.73, ["Fly|Ride"] = 258.77, ["Neon"] = 43.81, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 288.75, ["Mega|Ride"] = 282.86, ["Mega|Fly|Ride"] = 1068.1}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 16.94, ["Ride"] = 15.65, ["Fly|Ride"] = 19.69, ["Neon"] = 23.77, ["Neon|Fly"] = 68.25, ["Neon|Ride"] = 36.21, ["Neon|Fly|Ride"] = 70.7, ["Mega"] = 157.5, ["Mega|Ride"] = 306.56, ["Mega|Fly|Ride"] = 223.12}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 61.69, ["Fly"] = 85.44, ["Ride"] = 98.53, ["Fly|Ride"] = 143.06, ["Neon"] = 341.23, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 349.13, ["Neon|Fly|Ride"] = 447.57, ["Mega|Fly|Ride"] = 1430.63}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 210, ["Fly"] = 427.17, ["Ride"] = 249.23, ["Fly|Ride"] = 295.32, ["Neon|Ride"] = 1140.84, ["Neon|Fly|Ride"] = 953.71, ["Mega"] = 10680.79, ["Mega|Fly|Ride"] = 4938.81}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 70.46, ["Fly"] = 123.88, ["Ride"] = 67.48, ["Fly|Ride"] = 118.12, ["Neon"] = 262.5, ["Neon|Ride"] = 290.34, ["Neon|Fly|Ride"] = 354.26, ["Mega|Fly|Ride"] = 1823.22}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 5.25, ["Fly"] = 287.89, ["Ride"] = 36.32, ["Fly|Ride"] = 81.18, ["Neon"] = 24.93, ["Neon|Fly"] = 85.55, ["Neon|Ride"] = 64.16, ["Neon|Fly|Ride"] = 178.5, ["Mega"] = 262.49, ["Mega|Ride"] = 356.75, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 10.49, ["Ride"] = 34.19, ["Fly|Ride"] = 67.38, ["Neon"] = 108.94, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 199.96, ["Mega"] = 354.38, ["Mega|Ride"] = 397.68, ["Mega|Fly|Ride"] = 726.31}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.16, ["Ride"] = 18.17, ["Fly|Ride"] = 48.55, ["Neon"] = 5.24, ["Neon|Fly"] = 32.09, ["Neon|Ride"] = 20.58, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 53.42, ["Mega|Fly"] = 154.88, ["Mega|Ride"] = 111.46, ["Mega|Fly|Ride"] = 128.19}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 10.54, ["Fly"] = 72.12, ["Ride"] = 22.78, ["Fly|Ride"] = 81.38, ["Neon"] = 152.63, ["Neon|Fly"] = 357.13, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 186.05, ["Mega"] = 1837.5, ["Mega|Ride"] = 1018.5, ["Mega|Fly|Ride"] = 732.38}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.91, ["Ride"] = 15.64, ["Fly|Ride"] = 32.82, ["Neon"] = 13.13, ["Neon|Fly"] = 81.18, ["Neon|Ride"] = 31.52, ["Neon|Fly|Ride"] = 104.79, ["Mega"] = 144.38, ["Mega|Ride"] = 285.2, ["Mega|Fly|Ride"] = 183.94}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 8.56, ["Ride"] = 27.56, ["Fly|Ride"] = 328.13, ["Neon"] = 21.39, ["Neon|Ride"] = 35.76, ["Mega"] = 207.37, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 310.55}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 34.18, ["Ride"] = 19.35, ["Neon"] = 2.1, ["Neon|Ride"] = 19.66, ["Neon|Fly|Ride"] = 57.73, ["Mega"] = 14.74, ["Mega|Ride"] = 42.74, ["Mega|Fly|Ride"] = 78.73}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.63, ["Fly"] = 27.28, ["Ride"] = 18.27, ["Fly|Ride"] = 42.78, ["Neon"] = 15.22, ["Neon|Fly"] = 106.94, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 147, ["Mega"] = 78.75, ["Mega|Fly|Ride"] = 159.92}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 25.71, ["Ride"] = 18.52, ["Fly|Ride"] = 61.74, ["Neon"] = 21.07, ["Neon|Ride"] = 30.19, ["Mega"] = 131.17, ["Mega|Ride"] = 207.23, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 107.51, ["Fly"] = 179.29, ["Ride"] = 144.38, ["Fly|Ride"] = 199.5, ["Neon"] = 713.18, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 590.63, ["Mega"] = 4272.33, ["Mega|Ride"] = 2777.01, ["Mega|Fly|Ride"] = 2255.93}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 17.1, ["Ride"] = 32.83, ["Fly|Ride"] = 129.63, ["Neon"] = 47.07, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 376.56, ["Mega"] = 328.13, ["Mega|Ride"] = 413.45, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 42.73, ["Ride"] = 17.06, ["Fly|Ride"] = 42.78, ["Neon"] = 12.84, ["Neon|Ride"] = 34.04, ["Neon|Fly|Ride"] = 120.75, ["Mega"] = 241.95, ["Mega|Fly|Ride"] = 285.2}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 23, ["Ride"] = 57.75, ["Fly|Ride"] = 170.63, ["Neon"] = 118.01, ["Neon|Ride"] = 300.46, ["Neon|Fly|Ride"] = 712.09, ["Mega"] = 683.59, ["Mega|Fly"] = 854.47, ["Mega|Ride"] = 577.5, ["Mega|Fly|Ride"] = 635.52}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 3.94}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 3.65, ["Ride"] = 28.82, ["Fly|Ride"] = 126, ["Neon"] = 52.47, ["Neon|Ride"] = 162.33, ["Mega"] = 285.92, ["Mega|Ride"] = 510.56, ["Mega|Fly|Ride"] = 887.91}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 28.89, ["Fly"] = 42, ["Ride"] = 31.39, ["Fly|Ride"] = 49.24, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 162.64, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 1378.91, ["Mega|Fly|Ride"] = 541.75}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 18.68, ["Fly|Ride"] = 65.63, ["Neon"] = 3.39, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 106.31, ["Mega"] = 30.99, ["Mega|Fly"] = 188.99, ["Mega|Ride"] = 67.88, ["Mega|Fly|Ride"] = 228.79}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 4.05, ["Fly"] = 28.41, ["Ride"] = 19.81, ["Neon"] = 55.12, ["Neon|Ride"] = 64.16, ["Mega"] = 285.2, ["Mega|Fly"] = 404.03, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 425.11}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 17.07, ["Fly|Ride"] = 28.81, ["Neon"] = 17.74, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 35.45, ["Neon|Fly|Ride"] = 77.43, ["Mega"] = 138.89, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 280.88}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 28.64, ["Fly|Ride"] = 213.86, ["Neon"] = 3.52, ["Neon|Fly"] = 37.44, ["Neon|Ride"] = 32.34, ["Mega"] = 31.5, ["Mega|Ride"] = 64.07, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 24.96, ["Ride"] = 74.82, ["Fly|Ride"] = 145.37, ["Neon"] = 226.68, ["Neon|Ride"] = 280.88, ["Neon|Fly|Ride"] = 576.19, ["Mega"] = 850.61, ["Mega|Fly|Ride"] = 1174.9}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.89, ["Ride"] = 28.85, ["Fly|Ride"] = 210, ["Neon"] = 92.54, ["Mega"] = 143.13, ["Mega|Ride"] = 342.67}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 15.64, ["Fly"] = 28.8, ["Ride"] = 21.94, ["Fly|Ride"] = 52.39, ["Neon"] = 21.1, ["Neon|Fly"] = 315, ["Neon|Ride"] = 36.37, ["Neon|Fly|Ride"] = 113.88, ["Mega"] = 383.97, ["Mega|Ride"] = 288.4, ["Mega|Fly|Ride"] = 421.32}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 65.63, ["Fly"] = 433.13, ["Ride"] = 393.74, ["Fly|Ride"] = 262.47, ["Neon"] = 354.38, ["Neon|Ride"] = 570.96, ["Mega"] = 4518.1, ["Mega|Ride"] = 2165.63, ["Mega|Fly|Ride"] = 2349.79}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 10.39, ["Fly"] = 44.84, ["Ride"] = 23.62, ["Fly|Ride"] = 57.66, ["Neon"] = 46.94, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 114.18, ["Mega"] = 241.95, ["Mega|Ride"] = 288.4, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 70.88, ["Fly"] = 179.1, ["Ride"] = 104.99, ["Fly|Ride"] = 150.94, ["Neon"] = 266.44, ["Neon|Ride"] = 234.84, ["Neon|Fly|Ride"] = 450.62, ["Mega"] = 1281.71, ["Mega|Ride"] = 901.78, ["Mega|Fly|Ride"] = 968.62}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 20.9, ["Ride"] = 61.3, ["Fly|Ride"] = 106.94, ["Neon"] = 91.02, ["Neon|Ride"] = 103.95, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 314.99, ["Mega|Ride"] = 358.33, ["Mega|Fly|Ride"] = 413.44}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 9.18, ["Fly"] = 41.36, ["Ride"] = 28.84, ["Fly|Ride"] = 64.16, ["Neon"] = 84.81, ["Neon|Ride"] = 144.16, ["Neon|Fly|Ride"] = 385.22, ["Mega"] = 213.63, ["Mega|Ride"] = 1602.14, ["Mega|Fly|Ride"] = 532.98}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 14.44, ["Fly"] = 70.49, ["Ride"] = 45.65, ["Fly|Ride"] = 162.33, ["Neon"] = 113.88, ["Neon|Ride"] = 99.03, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 236.91, ["Mega|Ride"] = 272.44, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 5.95, ["Ride"] = 27.36, ["Fly|Ride"] = 89.82, ["Neon"] = 41.2, ["Neon|Ride"] = 60.51, ["Neon|Fly|Ride"] = 141.16, ["Mega"] = 241.95, ["Mega|Ride"] = 265.21, ["Mega|Fly|Ride"] = 417.38}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Ride"] = 68, ["Fly|Ride"] = 100.52, ["Neon"] = 2.37, ["Neon|Ride"] = 57.75, ["Mega"] = 19.69, ["Mega|Ride"] = 135.66, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.5, ["Ride"] = 28.44, ["Neon"] = 24.05, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 205.88, ["Mega|Ride"] = 271.31, ["Mega|Fly|Ride"] = 425.11}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 127.09, ["Neon"] = 28.74, ["Neon|Fly"] = 116.94, ["Neon|Ride"] = 315, ["Mega"] = 184.42, ["Mega|Ride"] = 141, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 6.01, ["Ride"] = 32.79, ["Fly|Ride"] = 121.14, ["Neon"] = 32.09, ["Neon|Ride"] = 80.2, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 124.69, ["Mega|Ride"] = 285.2, ["Mega|Fly|Ride"] = 519.74}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 524.99, ["Fly"] = 523.69, ["Ride"] = 577.5, ["Fly|Ride"] = 593.92, ["Neon"] = 1853.99, ["Neon|Ride"] = 1858.26, ["Neon|Fly|Ride"] = 1860.72, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 4.83, ["Fly"] = 28.85, ["Ride"] = 20.44, ["Fly|Ride"] = 56.35, ["Neon"] = 41.72, ["Neon|Ride"] = 63.1, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 144.38, ["Mega|Ride"] = 371.38, ["Mega|Fly|Ride"] = 512.69}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 7.88, ["Fly"] = 524.9, ["Ride"] = 30.98, ["Fly|Ride"] = 51.54, ["Neon"] = 39.38, ["Neon|Fly"] = 315, ["Neon|Ride"] = 98.34, ["Neon|Fly|Ride"] = 171.09, ["Mega"] = 331.86, ["Mega|Ride"] = 455.02, ["Mega|Fly|Ride"] = 681.35}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.1, ["Fly"] = 36.32, ["Ride"] = 27.41, ["Fly|Ride"] = 50.79, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 131.25}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.59, ["Ride"] = 23.63, ["Fly|Ride"] = 72.73, ["Neon"] = 7.72, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 89.65, ["Mega"] = 64.78, ["Mega|Fly"] = 285.2, ["Mega|Ride"] = 88.65, ["Mega|Fly|Ride"] = 213}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 71.56, ["Ride"] = 16.95, ["Neon"] = 3.04, ["Neon|Ride"] = 24.34, ["Neon|Fly|Ride"] = 128.31, ["Mega"] = 21.38, ["Mega|Ride"] = 65.54, ["Mega|Fly|Ride"] = 221.55}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1108.96}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 5.13, ["Ride"] = 36.74, ["Fly|Ride"] = 105, ["Neon"] = 52.39, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 323.44, ["Mega"] = 425.11, ["Mega|Ride"] = 849.14, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 26.93, ["Neon"] = 6.23, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 982.1, ["Mega"] = 32.82, ["Mega|Ride"] = 106.82, ["Mega|Fly|Ride"] = 251.35}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.63, ["Fly"] = 27.17, ["Ride"] = 64.04, ["Neon"] = 29.4, ["Neon|Ride"] = 71.65, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 223.13, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 1068.1}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 418.69, ["Ride"] = 426.57, ["Fly|Ride"] = 518.86, ["Neon|Ride"] = 2384.82, ["Neon|Fly|Ride"] = 1808.01, ["Mega"] = 8871.66, ["Mega|Fly|Ride"] = 6298.69}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 4.85, ["Fly"] = 196.88, ["Ride"] = 57.68, ["Fly|Ride"] = 427.69, ["Neon"] = 42.37, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 204.23, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 742.74}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 90.33, ["Ride"] = 23.79, ["Fly|Ride"] = 118.13, ["Neon"] = 2.63, ["Neon|Ride"] = 36.9, ["Neon|Fly|Ride"] = 127.82, ["Mega"] = 38.07, ["Mega|Fly"] = 128.19, ["Mega|Ride"] = 71.97, ["Mega|Fly|Ride"] = 232.85}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 4.11, ["Neon|Ride"] = 129.92, ["Neon|Fly|Ride"] = 285.49, ["Mega"] = 32.45, ["Mega|Ride"] = 134.77, ["Mega|Fly|Ride"] = 391.65}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 17.75, ["Fly"] = 107.88, ["Ride"] = 106.8, ["Neon"] = 71.65, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 483.88, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 544.69}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 8.39, ["Ride"] = 71.31, ["Neon"] = 80.43, ["Neon|Ride"] = 169.6, ["Neon|Fly|Ride"] = 508.95, ["Mega"] = 593.87, ["Mega|Ride"] = 479.73, ["Mega|Fly|Ride"] = 570.38}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 4.64, ["Ride"] = 31.5, ["Neon"] = 96.94, ["Neon|Ride"] = 182.93, ["Mega"] = 661.69, ["Mega|Ride"] = 783.99, ["Mega|Fly|Ride"] = 1281.71}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 12.92, ["Ride"] = 23.86, ["Fly|Ride"] = 262.5, ["Neon"] = 131.24, ["Neon|Ride"] = 182.44, ["Neon|Fly|Ride"] = 213.86, ["Mega"] = 616.77, ["Mega|Ride"] = 1300.05, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 380.63, ["Ride"] = 384.38, ["Fly|Ride"] = 780.1, ["Neon"] = 1365, ["Neon|Ride"] = 1069.2, ["Neon|Fly|Ride"] = 1076.25, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 6.23, ["Fly"] = 78.74, ["Ride"] = 26.25, ["Fly|Ride"] = 64.3, ["Neon"] = 190.32, ["Neon|Ride"] = 193.82, ["Neon|Fly|Ride"] = 192.89, ["Mega|Ride"] = 761.25, ["Mega|Fly|Ride"] = 879.04}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.65, ["Ride"] = 42.68, ["Fly|Ride"] = 127.32, ["Neon"] = 65.63, ["Neon|Ride"] = 221.82, ["Mega"] = 367.5, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 19.49, ["Ride"] = 78.75, ["Fly|Ride"] = 236.25, ["Neon"] = 81.38, ["Neon|Ride"] = 165.63, ["Neon|Fly|Ride"] = 288.65, ["Mega"] = 301.67, ["Mega|Ride"] = 325.5, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.37, ["Ride"] = 42.73, ["Fly|Ride"] = 143.29, ["Neon"] = 7.27, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 213.86, ["Mega"] = 38.06, ["Mega|Ride"] = 128.29, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 41.45, ["Ride"] = 83.3, ["Neon"] = 427.69, ["Neon|Ride"] = 426.62, ["Neon|Fly|Ride"] = 513.22, ["Mega"] = 1971.68, ["Mega|Ride"] = 2136.18, ["Mega|Fly|Ride"] = 1244.63}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 521, ["Ride"] = 26.25, ["Fly|Ride"] = 60.97, ["Neon"] = 7.76, ["Neon|Fly"] = 186.05, ["Neon|Ride"] = 65.43, ["Neon|Fly|Ride"] = 145.91, ["Mega"] = 100.42, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 284.12}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 27.84, ["Neon"] = 3.81, ["Neon|Fly"] = 49.38, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 111.21, ["Mega"] = 44.88, ["Mega|Fly"] = 112.88, ["Mega|Ride"] = 100.42, ["Mega|Fly|Ride"] = 170.43}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 37.97, ["Fly|Ride"] = 127.52, ["Neon"] = 11.79, ["Neon|Ride"] = 62.03, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 113.72, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 315.1}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 45.55, ["Fly"] = 85.44, ["Ride"] = 61.68, ["Fly|Ride"] = 169.32, ["Neon"] = 236.25, ["Neon|Ride"] = 320.46, ["Neon|Fly|Ride"] = 484.55, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 285.13, ["Ride"] = 315.04, ["Fly|Ride"] = 433.13, ["Neon"] = 1462.13, ["Neon|Ride"] = 1179.84, ["Neon|Fly|Ride"] = 1332.47, ["Mega"] = 9677.3, ["Mega|Fly|Ride"] = 4537.07}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 4.85, ["Neon"] = 28.28, ["Neon|Fly"] = 350.44, ["Neon|Ride"] = 106.94, ["Mega"] = 104.9, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 199.75}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.63, ["Ride"] = 25.68, ["Neon"] = 8.34, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 48.78, ["Mega|Fly"] = 164.07, ["Mega|Ride"] = 90.46, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.94, ["Fly"] = 105, ["Ride"] = 28.1, ["Fly|Ride"] = 81.18, ["Neon"] = 32.81, ["Mega"] = 143.13, ["Mega|Ride"] = 351.74, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.61, ["Fly"] = 91.88, ["Ride"] = 30.5, ["Fly|Ride"] = 374.42, ["Neon"] = 12.88, ["Neon|Ride"] = 47.07, ["Neon|Fly|Ride"] = 164.68, ["Mega"] = 124.49, ["Mega|Ride"] = 221.38, ["Mega|Fly|Ride"] = 242.46}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 59.06, ["Neon"] = 8.53, ["Neon|Fly|Ride"] = 143.29, ["Mega"] = 39.29, ["Mega|Ride"] = 143.13, ["Mega|Fly|Ride"] = 284.12}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 28.85, ["Ride"] = 18.18, ["Fly|Ride"] = 52.49, ["Neon"] = 2.1, ["Neon|Fly"] = 81.18, ["Neon|Ride"] = 24.25, ["Neon|Fly|Ride"] = 58.16, ["Mega"] = 60.38, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 249.36}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 17.8, ["Fly|Ride"] = 56.44, ["Neon"] = 15.16, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 38.66, ["Neon|Fly|Ride"] = 96.92, ["Mega"] = 156.15, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 169.84}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 35.79, ["Fly"] = 52.5, ["Ride"] = 38.66, ["Fly|Ride"] = 78.74, ["Neon|Fly|Ride"] = 323.44, ["Mega"] = 393.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 527.68}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 70.88, ["Ride"] = 84.31, ["Fly|Ride"] = 139.13, ["Neon"] = 561.75, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 446.25, ["Mega"] = 3226.18, ["Mega|Ride"] = 3255, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 17.88, ["Fly|Ride"] = 144.38, ["Neon"] = 3.7, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 26.2, ["Neon|Fly|Ride"] = 126.19, ["Mega"] = 45.94, ["Mega|Fly"] = 672, ["Mega|Ride"] = 92.8, ["Mega|Fly|Ride"] = 246.11}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 17.31, ["Ride"] = 15.02, ["Fly|Ride"] = 26.25, ["Neon"] = 4.94, ["Neon|Fly"] = 28.41, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 61.68, ["Mega"] = 45.94, ["Mega|Fly"] = 131.21, ["Mega|Ride"] = 68.13, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 6.28, ["Fly"] = 42.73, ["Ride"] = 48.76, ["Fly|Ride"] = 131.25, ["Neon"] = 48.37, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 285.49, ["Mega"] = 527.62, ["Mega|Ride"] = 274.32, ["Mega|Fly|Ride"] = 645.98}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.75, ["Fly"] = 518.44, ["Ride"] = 555.31, ["Fly|Ride"] = 577.5, ["Neon|Ride"] = 2100.44, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 8064.83}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 26.09, ["Fly"] = 100.38, ["Ride"] = 40.7, ["Fly|Ride"] = 107.5, ["Neon"] = 241.5, ["Neon|Ride"] = 225.75, ["Neon|Fly|Ride"] = 474.85, ["Mega|Ride"] = 880.69, ["Mega|Fly|Ride"] = 1935.48}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 25.86, ["Fly|Ride"] = 295.58, ["Neon"] = 9.17, ["Neon|Ride"] = 46.04, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 102.38, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 271.31}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 65.62, ["Fly|Ride"] = 143.05, ["Neon"] = 17.12}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 75.34, ["Fly"] = 169.3, ["Ride"] = 38.07, ["Fly|Ride"] = 104.81, ["Neon"] = 194.25, ["Neon|Ride"] = 274.98, ["Neon|Fly|Ride"] = 285.49, ["Mega"] = 2563.4, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1281.71}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 81.93, ["Fly"] = 104.9, ["Ride"] = 113.43, ["Fly|Ride"] = 192.47, ["Neon"] = 430.1, ["Neon|Ride"] = 484.55, ["Neon|Fly|Ride"] = 499.32, ["Mega"] = 8544.64, ["Mega|Fly|Ride"] = 2670.22}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 249.38, ["Ride"] = 286.94, ["Fly|Ride"] = 341.88, ["Neon"] = 1035.68, ["Neon|Ride"] = 800.63, ["Neon|Fly|Ride"] = 1035.46, ["Mega|Fly|Ride"] = 4147.5}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 11.71, ["Ride"] = 61.6, ["Fly|Ride"] = 96.25, ["Neon"] = 99.75, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 357.13, ["Mega"] = 389.8, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 1068.1}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 19.58, ["Ride"] = 15.75, ["Fly|Ride"] = 43.2, ["Neon"] = 6.57, ["Neon|Ride"] = 23.14, ["Neon|Fly|Ride"] = 93.03, ["Mega"] = 84.28, ["Mega|Ride"] = 104.98, ["Mega|Fly|Ride"] = 170.42}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.1, ["Fly"] = 39.3, ["Ride"] = 18.27, ["Fly|Ride"] = 53.48, ["Neon"] = 31.07, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 37.67, ["Neon|Fly|Ride"] = 81.89, ["Mega"] = 354.62, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 377.13}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 321.2, ["Fly"] = 498.7, ["Ride"] = 454.82, ["Fly|Ride"] = 641.53, ["Neon"] = 1968.75, ["Neon|Ride"] = 2029.3, ["Neon|Fly|Ride"] = 1997.26, ["Mega"] = 10253.57, ["Mega|Fly|Ride"] = 4858.65}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Neon"] = 8.65, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 34.1, ["Mega|Ride"] = 170.99, ["Mega|Fly|Ride"] = 450.13}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.63, ["Ride"] = 15.75, ["Fly|Ride"] = 57.75, ["Neon"] = 38.78, ["Neon|Ride"] = 37.93, ["Neon|Fly|Ride"] = 84, ["Mega"] = 237.13, ["Mega|Ride"] = 199.75, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 13.13, ["Ride"] = 102.37, ["Neon"] = 90.37, ["Neon|Fly"] = 427.69, ["Neon|Ride"] = 143.29, ["Mega"] = 459.38, ["Mega|Ride"] = 609, ["Mega|Fly|Ride"] = 600.18}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 105, ["Fly"] = 217.86, ["Ride"] = 109.52, ["Fly|Ride"] = 127.03, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 568.32, ["Mega|Fly|Ride"] = 2379.57}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 16.93, ["Fly"] = 24.34, ["Ride"] = 27.92, ["Fly|Ride"] = 52.5, ["Neon"] = 130.5, ["Neon|Ride"] = 89.25, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 712.42, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 506.03}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 21.37, ["Neon"] = 3.68, ["Neon|Ride"] = 39.38, ["Mega"] = 26.16, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 19.26, ["Fly|Ride"] = 71.65, ["Neon"] = 3.29, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 18.95, ["Neon|Fly|Ride"] = 81.3, ["Mega"] = 26.82, ["Mega|Fly"] = 97.12, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 109.98}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 13.01, ["Ride"] = 77.59, ["Fly|Ride"] = 136.42, ["Neon"] = 32.43, ["Neon|Ride"] = 87.35, ["Neon|Fly|Ride"] = 203.43, ["Mega"] = 177.18, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 276.65}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1669.91, ["Ride"] = 1443.75, ["Fly|Ride"] = 1435.88, ["Neon|Ride"] = 7128.31, ["Neon|Fly|Ride"] = 4377.29, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 446.25, ["Ride"] = 488.54, ["Fly|Ride"] = 595.88, ["Neon"] = 2510.47, ["Neon|Ride"] = 2138.39, ["Neon|Fly|Ride"] = 2566.07, ["Mega"] = 17089.27, ["Mega|Fly|Ride"] = 7192.46}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 315, ["Fly"] = 422.89, ["Ride"] = 360.93, ["Fly|Ride"] = 451.5, ["Neon"] = 787.5, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 859.1, ["Mega|Fly|Ride"] = 2916.24}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 311.07, ["Fly"] = 334.69, ["Ride"] = 354.38, ["Fly|Ride"] = 525, ["Neon"] = 721.88, ["Neon|Ride"] = 761.25, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 4271.27}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 64.31, ["Ride"] = 16.02, ["Fly|Ride"] = 39.01, ["Neon"] = 5.23, ["Neon|Ride"] = 30.45, ["Neon|Fly|Ride"] = 105, ["Mega"] = 69.43, ["Mega|Fly"] = 114.3, ["Mega|Ride"] = 82.69, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 341.73, ["Fly"] = 1424.53, ["Ride"] = 420, ["Fly|Ride"] = 498.75, ["Neon"] = 1706.25, ["Neon|Ride"] = 1362.17, ["Neon|Fly|Ride"] = 1426.32, ["Mega"] = 21646.76, ["Mega|Ride"] = 5126.79, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 3.8, ["Fly"] = 157.5, ["Ride"] = 112.53, ["Fly|Ride"] = 91.87, ["Neon"] = 22.17, ["Neon|Ride"] = 213.86, ["Neon|Fly|Ride"] = 252.45, ["Mega"] = 137.91, ["Mega|Ride"] = 237.36, ["Mega|Fly|Ride"] = 508.41}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 18.12, ["Ride"] = 14.44, ["Fly|Ride"] = 31.98, ["Neon"] = 12.13, ["Neon|Ride"] = 38.51, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 105, ["Mega|Ride"] = 192.94, ["Mega|Fly|Ride"] = 160.23}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.18, ["Neon"] = 2.37, ["Neon|Ride"] = 39.38, ["Mega"] = 29.59, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 236.07}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 28.87, ["Ride"] = 56.95, ["Fly|Ride"] = 459.38, ["Neon"] = 273, ["Neon|Ride"] = 420, ["Mega"] = 1050, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.63, ["Fly"] = 8067.52, ["Ride"] = 26.25, ["Fly|Ride"] = 68.25, ["Neon"] = 26.07, ["Neon|Ride"] = 61.13, ["Mega|Ride"] = 413.36, ["Mega|Fly|Ride"] = 427.25}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.05, ["Ride"] = 55.13, ["Neon"] = 3.45, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 107.14, ["Mega"] = 21, ["Mega|Ride"] = 68.01, ["Mega|Fly|Ride"] = 165.8}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 41.02, ["Ride"] = 22.32, ["Fly|Ride"] = 65.54, ["Neon"] = 14.09, ["Neon|Fly"] = 113.9, ["Neon|Ride"] = 24.25, ["Neon|Fly|Ride"] = 79.92, ["Mega"] = 131.15, ["Mega|Ride"] = 122.2, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.94, ["Fly"] = 57.68, ["Ride"] = 22.32, ["Fly|Ride"] = 52.5, ["Neon"] = 30.19, ["Neon|Fly"] = 145.37, ["Neon|Ride"] = 143.29, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 238.82, ["Mega|Ride"] = 300.53, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 12.49, ["Ride"] = 52.5, ["Neon"] = 92.9, ["Neon|Ride"] = 382.78, ["Neon|Fly|Ride"] = 284.68, ["Mega"] = 518.19, ["Mega|Ride"] = 413.36}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 3.81, ["Fly"] = 6141.83, ["Ride"] = 19.69, ["Neon"] = 39.38, ["Neon|Fly"] = 47.25, ["Neon|Ride"] = 212.79, ["Neon|Fly|Ride"] = 726.8, ["Mega"] = 308.44, ["Mega|Ride"] = 421.91, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 64.68, ["Ride"] = 18.38, ["Fly|Ride"] = 45.93, ["Neon"] = 3.93, ["Neon|Fly"] = 32.09, ["Neon|Ride"] = 27.93, ["Mega"] = 44.63, ["Mega|Ride"] = 182.68, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 163.59, ["Fly"] = 260.57, ["Ride"] = 164.07, ["Fly|Ride"] = 229.69, ["Neon"] = 883.16, ["Neon|Ride"] = 923.79, ["Neon|Fly|Ride"] = 838.68, ["Mega"] = 8544.64, ["Mega|Fly|Ride"] = 3547.1}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 19.03, ["Ride"] = 15.11, ["Fly|Ride"] = 42.41, ["Neon"] = 3.82, ["Neon|Fly"] = 42.78, ["Neon|Ride"] = 24.75, ["Neon|Fly|Ride"] = 56.36, ["Mega"] = 38.07, ["Mega|Ride"] = 52.77, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 7.07, ["Ride"] = 28.88, ["Fly|Ride"] = 196.88, ["Neon"] = 55.38, ["Neon|Ride"] = 85.55, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 313.69, ["Mega|Fly"] = 806.86, ["Mega|Ride"] = 327.18, ["Mega|Fly|Ride"] = 379.32}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 24.94, ["Ride"] = 81.25, ["Fly|Ride"] = 170.63, ["Neon"] = 199.96, ["Neon|Ride"] = 278, ["Mega"] = 997.6, ["Mega|Ride"] = 525.16, ["Mega|Fly|Ride"] = 944.99}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 183.64, ["Ride"] = 225.05, ["Fly|Ride"] = 384.92, ["Neon"] = 780.36, ["Neon|Ride"] = 682.5, ["Neon|Fly|Ride"] = 998.64, ["Mega|Fly|Ride"] = 3353.78}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 23.39, ["Ride"] = 158.3, ["Fly|Ride"] = 143.29, ["Neon"] = 41.72, ["Mega"] = 287.44, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 589.13}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 8.65, ["Ride"] = 57.75, ["Fly|Ride"] = 182.44, ["Neon"] = 105, ["Neon|Fly"] = 162.33, ["Neon|Ride"] = 199, ["Neon|Fly|Ride"] = 226.53, ["Mega"] = 771.89, ["Mega|Ride"] = 854.47, ["Mega|Fly|Ride"] = 997.6}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 958.12, ["Fly"] = 1050, ["Ride"] = 1050, ["Fly|Ride"] = 1214.07, ["Neon|Ride"] = 4533.39, ["Neon|Fly|Ride"] = 4844.53, ["Mega|Fly|Ride"] = 20293.51}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 5.25, ["Fly"] = 21, ["Ride"] = 19.82, ["Fly|Ride"] = 52.5, ["Neon"] = 50.64, ["Neon|Fly"] = 48.9, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 213.86, ["Mega"] = 229.86, ["Mega|Ride"] = 212.57, ["Mega|Fly|Ride"] = 333.38}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 4.99, ["Fly"] = 78.75, ["Ride"] = 35.44, ["Fly|Ride"] = 135.19, ["Neon"] = 37.7, ["Neon|Ride"] = 121.14, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 252.09, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 290.33, ["Mega|Fly|Ride"] = 997.6}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 84.38, ["Ride"] = 23.76, ["Fly|Ride"] = 69.57, ["Neon"] = 15.74, ["Neon|Ride"] = 45.82, ["Mega"] = 108.89, ["Mega|Ride"] = 243.06, ["Mega|Fly|Ride"] = 712.42}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 14.15, ["Fly"] = 57.84, ["Ride"] = 32.82, ["Fly|Ride"] = 86.63, ["Neon"] = 83.9, ["Neon|Ride"] = 79.45, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 492.19, ["Mega|Ride"] = 347.82, ["Mega|Fly|Ride"] = 438.38}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 3.94, ["Fly"] = 20.47, ["Ride"] = 22.32, ["Fly|Ride"] = 50.27, ["Neon"] = 16.36, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 101.82, ["Mega|Fly"] = 256.35, ["Mega|Ride"] = 104.9, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 10.47, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 52.17, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 148.98, ["Mega|Ride"] = 199.38, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 234.77, ["Ride"] = 297.95, ["Fly|Ride"] = 384.92, ["Neon|Fly|Ride"] = 1182.57}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 4.23, ["Fly"] = 32.8, ["Ride"] = 24.64, ["Fly|Ride"] = 108.94, ["Neon"] = 7.88, ["Neon|Ride"] = 32.61, ["Neon|Fly|Ride"] = 153.86, ["Mega"] = 76.56, ["Mega|Fly"] = 427.25, ["Mega|Ride"] = 122.06, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.22, ["Ride"] = 82.02, ["Fly|Ride"] = 88.86, ["Neon"] = 27.46, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27, ["Mega|Ride"] = 323, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.83, ["Fly"] = 98.86, ["Ride"] = 42.78, ["Neon"] = 28.4, ["Neon|Ride"] = 52.5, ["Mega"] = 84.96, ["Mega|Ride"] = 174.57, ["Mega|Fly|Ride"] = 458.75}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 118.13, ["Ride"] = 323.1, ["Fly|Ride"] = 308.44, ["Neon"] = 493.86, ["Neon|Ride"] = 646.86, ["Neon|Fly|Ride"] = 576.6, ["Mega"] = 2750.79, ["Mega|Ride"] = 4272.33, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 62.99, ["Fly"] = 121.03, ["Ride"] = 51.34, ["Fly|Ride"] = 228.82, ["Neon"] = 149.63, ["Neon|Ride"] = 285.49, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 590.63, ["Mega|Ride"] = 931.45, ["Mega|Fly|Ride"] = 885.94}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 19.37, ["Fly"] = 323.1, ["Ride"] = 32.82, ["Fly|Ride"] = 94.21, ["Neon"] = 93.19, ["Neon|Ride"] = 142.42, ["Neon|Fly|Ride"] = 242.71, ["Mega"] = 432.16, ["Mega|Ride"] = 435.75, ["Mega|Fly|Ride"] = 439.67}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.22, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 207.9, ["Mega"] = 76.13, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 256.35}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 65.42, ["Fly"] = 99.75, ["Ride"] = 75.06, ["Fly|Ride"] = 155.92, ["Neon"] = 315, ["Neon|Fly"] = 301.88, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 292.57, ["Mega|Fly|Ride"] = 1011.71}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.66, ["Fly|Ride"] = 52.5, ["Neon"] = 5.25, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 127.24, ["Mega"] = 58.91}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 18.45, ["Fly"] = 129.49, ["Ride"] = 26.17, ["Fly|Ride"] = 87.23, ["Neon"] = 68.25, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 320.44, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 384.53, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 44.92, ["Fly"] = 203.34, ["Ride"] = 94.9, ["Neon"] = 213.86, ["Neon|Ride"] = 262.4, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 1995.18, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 28.85, ["Ride"] = 15.07, ["Fly|Ride"] = 35.44, ["Neon"] = 2.63, ["Neon|Fly"] = 24.61, ["Neon|Ride"] = 18.18, ["Neon|Fly|Ride"] = 39.37, ["Mega"] = 16.95, ["Mega|Fly"] = 120.98, ["Mega|Ride"] = 26.25, ["Mega|Fly|Ride"] = 112.28}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.03, ["Ride"] = 52.49, ["Fly|Ride"] = 131.15, ["Neon"] = 18.5, ["Neon|Ride"] = 64.16, ["Neon|Fly|Ride"] = 291.38, ["Mega"] = 131.25, ["Mega|Ride"] = 284.29, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 13.13, ["Ride"] = 43.21, ["Fly|Ride"] = 85.32, ["Neon"] = 110.13, ["Neon|Fly|Ride"] = 273, ["Mega"] = 400.44, ["Mega|Ride"] = 450.21, ["Mega|Fly|Ride"] = 675.56}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 22.31, ["Neon"] = 2.1, ["Neon|Ride"] = 28.86, ["Neon|Fly|Ride"] = 140.07, ["Mega"] = 19.66, ["Mega|Ride"] = 128.19, ["Mega|Fly|Ride"] = 194.4}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 19.24, ["Fly"] = 197.3, ["Ride"] = 68.92, ["Fly|Ride"] = 175.37, ["Neon"] = 64.97, ["Neon|Ride"] = 171.09, ["Neon|Fly|Ride"] = 443.63, ["Mega"] = 606.04, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 488.43, ["Mega|Fly|Ride"] = 458.33}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 13.02, ["Fly"] = 42.73, ["Ride"] = 21.57, ["Fly|Ride"] = 98.44, ["Neon"] = 357.86, ["Neon|Ride"] = 113.54, ["Neon|Fly|Ride"] = 129.94, ["Mega|Ride"] = 210.29, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.6, ["Ride"] = 38.98, ["Neon"] = 24.09, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 130.19, ["Mega"] = 258.3, ["Mega|Ride"] = 250.58, ["Mega|Fly|Ride"] = 468.16}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 6.22, ["Fly"] = 2056.43, ["Ride"] = 72.19, ["Fly|Ride"] = 196.88, ["Neon"] = 32.81, ["Neon|Ride"] = 367.4, ["Neon|Fly|Ride"] = 6459.94, ["Mega"] = 285.2, ["Mega|Ride"] = 285.2, ["Mega|Fly|Ride"] = 367.49}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 42.73, ["Ride"] = 19.48, ["Fly|Ride"] = 196.88, ["Neon"] = 10.73, ["Neon|Ride"] = 32.43, ["Mega"] = 69.56, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 200.82, ["Mega|Fly|Ride"] = 281.98}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 55.53, ["Neon"] = 3.78, ["Mega"] = 21.5, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 22.23}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 39.27, ["Fly"] = 100.38, ["Ride"] = 66.26, ["Neon"] = 245.93, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 1852.06, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.57, ["Neon|Ride"] = 28.88, ["Mega"] = 18.38, ["Mega|Ride"] = 285.2, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 420, ["Fly"] = 498.75, ["Ride"] = 484.82, ["Fly|Ride"] = 804.33, ["Neon"] = 2851.54, ["Neon|Ride"] = 1997.26, ["Neon|Fly|Ride"] = 2709.35, ["Mega"] = 17089.27, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 6.22, ["Fly"] = 26.25, ["Ride"] = 26.24, ["Fly|Ride"] = 67.37, ["Neon"] = 34.85, ["Neon|Fly"] = 183.75, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 93.19, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 285.2}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.63, ["Fly"] = 52.49, ["Ride"] = 23.63, ["Fly|Ride"] = 81.27, ["Neon"] = 17.07, ["Neon|Ride"] = 42.78, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 118.13, ["Mega|Fly"] = 213.63, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 27.78, ["Fly"] = 71.56, ["Ride"] = 30.19, ["Fly|Ride"] = 68.17, ["Neon"] = 102.94, ["Neon|Ride"] = 155.07, ["Mega"] = 854.47, ["Mega|Ride"] = 561.75, ["Mega|Fly|Ride"] = 806.86}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.19, ["Fly"] = 57.68, ["Ride"] = 28.42, ["Fly|Ride"] = 721.88, ["Neon"] = 17.12, ["Neon|Ride"] = 105, ["Mega"] = 275.63, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 6.51, ["Ride"] = 143.29, ["Fly|Ride"] = 68.44, ["Neon"] = 64.6, ["Neon|Ride"] = 114.42, ["Neon|Fly|Ride"] = 526.94, ["Mega"] = 381.71, ["Mega|Ride"] = 570.38, ["Mega|Fly|Ride"] = 1068.1}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 6.26, ["Ride"] = 54.48, ["Fly|Ride"] = 133.88, ["Neon"] = 33.68, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 254.48, ["Mega"] = 262.5, ["Mega|Ride"] = 321.57, ["Mega|Fly|Ride"] = 452.88}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 1.79, ["Fly"] = 41.16, ["Ride"] = 13.79, ["Fly|Ride"] = 71.65, ["Neon"] = 2.1, ["Neon|Fly"] = 60.97, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 75.51, ["Mega"] = 14.86, ["Mega|Fly"] = 32.67, ["Mega|Ride"] = 28.84, ["Mega|Fly|Ride"] = 143.13}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 4.18, ["Fly"] = 54.48, ["Ride"] = 39.38, ["Fly|Ride"] = 106.32, ["Neon"] = 27.82, ["Neon|Fly"] = 121.14, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 228.82, ["Mega"] = 196.87, ["Mega|Ride"] = 208.59, ["Mega|Fly|Ride"] = 360.29}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 326.7, ["Ride"] = 308.44, ["Fly|Ride"] = 371.88, ["Neon"] = 1312.5, ["Neon|Ride"] = 1283.63, ["Neon|Fly|Ride"] = 1252.12, ["Mega|Ride"] = 9386.99, ["Mega|Fly|Ride"] = 5254.96}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 81.1, ["Ride"] = 114.09, ["Fly|Ride"] = 284.82, ["Neon"] = 577.5, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 585.38, ["Mega"] = 2279.3, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1707.87}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 15.54, ["Fly|Ride"] = 33.57, ["Neon"] = 8.57, ["Neon|Fly"] = 69.35, ["Neon|Ride"] = 34.23, ["Neon|Fly|Ride"] = 78.82, ["Mega|Fly"] = 212.57, ["Mega|Ride"] = 83.32, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 15.04, ["Fly|Ride"] = 34.74, ["Neon"] = 6.32, ["Neon|Fly"] = 53.48, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 55.53, ["Mega"] = 65.54, ["Mega|Fly"] = 356.75, ["Mega|Ride"] = 116.82, ["Mega|Fly|Ride"] = 161.44}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 3.7, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 65.63, ["Mega"] = 277.71, ["Mega|Ride"] = 427.25, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 249.43, ["Fly"] = 420, ["Ride"] = 249.38, ["Fly|Ride"] = 266.26, ["Neon"] = 1181.25, ["Neon|Ride"] = 1079.9, ["Neon|Fly|Ride"] = 1584.55, ["Mega|Ride"] = 8544.64, ["Mega|Fly|Ride"] = 3806.25}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 4.67, ["Fly"] = 23.62, ["Ride"] = 19.69, ["Fly|Ride"] = 40.16, ["Neon"] = 18.66, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 36.37, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 255.93, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 534.06}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 6.56, ["Fly"] = 323.1, ["Ride"] = 34.13, ["Fly|Ride"] = 213.86, ["Neon"] = 35.79, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 253.32, ["Mega|Ride"] = 288.54, ["Mega|Fly|Ride"] = 457.15}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 82.69, ["Neon"] = 6.26, ["Neon|Ride"] = 156.19, ["Mega"] = 71.58, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 13.12, ["Fly"] = 47.78, ["Ride"] = 22.31, ["Fly|Ride"] = 103.25, ["Neon"] = 96.92, ["Neon|Ride"] = 99.56, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 510.57, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 590.52}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 44.61, ["Fly"] = 121.03, ["Ride"] = 78.74, ["Fly|Ride"] = 196.88, ["Neon"] = 137.7, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 192.92, ["Neon|Fly|Ride"] = 279.37, ["Mega"] = 400.31, ["Mega|Fly"] = 2242.97, ["Mega|Ride"] = 473.82, ["Mega|Fly|Ride"] = 576.38}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 22.99, ["Fly"] = 63, ["Ride"] = 55.74, ["Fly|Ride"] = 141.01, ["Neon"] = 210.36, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 210.37, ["Neon|Fly|Ride"] = 311.15, ["Mega"] = 854.47, ["Mega|Ride"] = 700.88, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 15.75, ["Fly|Ride"] = 42.41, ["Neon"] = 2.62, ["Neon|Fly"] = 27.76, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 47.15, ["Mega"] = 19.42, ["Mega|Fly"] = 427.25, ["Mega|Ride"] = 30.91, ["Mega|Fly|Ride"] = 94.23}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 184.73, ["Ride"] = 275.59, ["Fly|Ride"] = 307.65, ["Neon"] = 2168.09, ["Neon|Fly|Ride"] = 1283.04, ["Mega|Fly|Ride"] = 4287.06}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 8.93, ["Fly"] = 101.18, ["Ride"] = 49.4, ["Fly|Ride"] = 105, ["Neon"] = 106.35, ["Neon|Ride"] = 209.57, ["Neon|Fly|Ride"] = 328.12, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 34.1, ["Ride"] = 18.36, ["Fly|Ride"] = 42.09, ["Neon"] = 7.88, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 57.69, ["Mega|Fly"] = 285.2, ["Mega|Ride"] = 85.46, ["Mega|Fly|Ride"] = 158.09}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 32.06, ["Ride"] = 16.14, ["Fly|Ride"] = 43.72, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 28.88, ["Mega|Fly"] = 143.13, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 139.94}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Fly|Ride"] = 72.19, ["Neon"] = 10.5, ["Neon|Fly"] = 726.8, ["Neon|Ride"] = 53.8, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 103.69, ["Mega|Ride"] = 213.63, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 10.2, ["Fly"] = 38.75, ["Ride"] = 23.16, ["Fly|Ride"] = 65.43, ["Neon"] = 55.13, ["Neon|Fly"] = 306.87, ["Neon|Ride"] = 49.76, ["Neon|Fly|Ride"] = 153.98, ["Mega"] = 355.59, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 406.6}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 4.87, ["Ride"] = 183.63, ["Neon"] = 55.13, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 351.75, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 413.36}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Neon"] = 3.62, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 100.36, ["Mega"] = 47.12, ["Mega|Ride"] = 77.6}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 7.21, ["Ride"] = 28.88, ["Fly|Ride"] = 131.25, ["Neon"] = 24.94, ["Neon|Fly"] = 102.92, ["Neon|Ride"] = 45, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 254.21, ["Mega|Ride"] = 201.98, ["Mega|Fly|Ride"] = 296.56}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 79.43, ["Neon"] = 6.57, ["Neon|Fly"] = 114.42, ["Neon|Ride"] = 45.78, ["Neon|Fly|Ride"] = 102.31, ["Mega"] = 23.8, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 143.13}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 44.52, ["Ride"] = 17.11, ["Fly|Ride"] = 62.03, ["Neon"] = 6.44, ["Neon|Ride"] = 20.89, ["Neon|Fly|Ride"] = 124.04, ["Mega"] = 54.08, ["Mega|Ride"] = 123.4, ["Mega|Fly|Ride"] = 285.2}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 767.71, ["Ride"] = 748.13, ["Fly|Ride"] = 890.04, ["Neon|Ride"] = 3806.34, ["Neon|Fly|Ride"] = 3609.37, ["Mega|Fly|Ride"] = 12571.04}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 19.23, ["Ride"] = 15.33, ["Fly|Ride"] = 36.23, ["Neon"] = 13.12, ["Neon|Fly"] = 140.89, ["Neon|Ride"] = 35.79, ["Neon|Fly|Ride"] = 113.88, ["Mega|Fly|Ride"] = 427.25}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 45.94, ["Fly|Ride"] = 210, ["Neon"] = 9.06, ["Neon|Fly"] = 748.46, ["Neon|Ride"] = 88.56, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 55.12, ["Mega|Fly"] = 213.63, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 8.94, ["Fly"] = 147, ["Ride"] = 23.86, ["Fly|Ride"] = 48.64, ["Neon"] = 65.63, ["Neon|Fly"] = 193.27, ["Neon|Ride"] = 57.49, ["Neon|Fly|Ride"] = 107.62, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 326.82}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 14.62, ["Fly|Ride"] = 33.27, ["Neon"] = 11.82, ["Neon|Fly"] = 64.32, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 73.41, ["Mega"] = 65.63, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 85.22, ["Mega|Fly|Ride"] = 192.27}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 32.68, ["Fly"] = 105, ["Ride"] = 83.16, ["Fly|Ride"] = 285.49, ["Neon"] = 213.86, ["Neon|Ride"] = 214.31, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 1424.83}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 19.68, ["Fly|Ride"] = 64.36, ["Neon"] = 6.3, ["Neon|Fly"] = 138.1, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 52.5, ["Mega|Ride"] = 120.92, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 32.68, ["Ride"] = 22.99, ["Fly|Ride"] = 62.03, ["Neon"] = 11.18, ["Neon|Ride"] = 41.88, ["Neon|Fly|Ride"] = 114.42, ["Mega"] = 95.82, ["Mega|Ride"] = 198.59, ["Mega|Fly|Ride"] = 351.74}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.37, ["Fly|Ride"] = 78.75, ["Neon"] = 26.25, ["Mega"] = 96.79, ["Mega|Ride"] = 160.23, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 16.06, ["Fly|Ride"] = 49.87, ["Neon"] = 3.78, ["Neon|Fly"] = 20.33, ["Neon|Ride"] = 24.61, ["Neon|Fly|Ride"] = 105.34, ["Mega"] = 42, ["Mega|Fly"] = 229.68, ["Mega|Ride"] = 69.56, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 12.36, ["Fly"] = 21.05, ["Ride"] = 20.77, ["Fly|Ride"] = 36.75, ["Neon"] = 105, ["Neon|Ride"] = 80.85, ["Neon|Fly|Ride"] = 105.35, ["Mega|Ride"] = 467.83, ["Mega|Fly|Ride"] = 492.34}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 727.63, ["Ride"] = 748.13, ["Fly|Ride"] = 942.32, ["Neon"] = 1837.5, ["Neon|Ride"] = 2001.62, ["Neon|Fly|Ride"] = 2163, ["Mega"] = 4654.5, ["Mega|Fly|Ride"] = 5968.49}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 1.79, ["Fly"] = 18.38, ["Ride"] = 16.06, ["Fly|Ride"] = 34.2, ["Neon"] = 2.1, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 47.14, ["Mega"] = 44.63, ["Mega|Ride"] = 57.74, ["Mega|Fly|Ride"] = 143.06}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 5.24, ["Ride"] = 32.81, ["Fly|Ride"] = 202.02, ["Neon"] = 47.24, ["Neon|Ride"] = 112.41, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 366.18, ["Mega|Ride"] = 351.2, ["Mega|Fly|Ride"] = 537.24}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 49.76, ["Fly"] = 100.38, ["Ride"] = 70.38, ["Fly|Ride"] = 111.57, ["Neon|Ride"] = 427.69, ["Neon|Fly|Ride"] = 390.06, ["Mega|Fly|Ride"] = 2332.32}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 30.19, ["Ride"] = 57.3, ["Fly|Ride"] = 104.89, ["Neon"] = 157.5, ["Neon|Ride"] = 224.55, ["Neon|Fly|Ride"] = 213.86, ["Mega"] = 983.89, ["Mega|Ride"] = 896.44, ["Mega|Fly|Ride"] = 1068.1}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 10.73, ["Fly"] = 84.72, ["Ride"] = 26.17, ["Fly|Ride"] = 140.91, ["Neon"] = 56.6, ["Neon|Ride"] = 121.14, ["Neon|Fly|Ride"] = 128.31, ["Mega"] = 305.82, ["Mega|Fly|Ride"] = 547.77}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 27.13, ["Ride"] = 57.68, ["Neon"] = 103.69, ["Neon|Ride"] = 328.46, ["Neon|Fly|Ride"] = 144.77, ["Mega"] = 236.25, ["Mega|Fly"] = 525, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 784.23}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 14.64, ["Ride"] = 50.21, ["Fly|Ride"] = 153.71, ["Neon"] = 124.69, ["Neon|Ride"] = 171.09, ["Neon|Fly|Ride"] = 525, ["Mega"] = 924, ["Mega|Ride"] = 640.86, ["Mega|Fly|Ride"] = 563.21}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 5.25}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 2.63, ["Ride"] = 24.71, ["Fly|Ride"] = 59.05, ["Neon"] = 36.75, ["Neon|Ride"] = 81.18, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 196.27, ["Mega|Fly"] = 482.79, ["Mega|Ride"] = 233.92, ["Mega|Fly|Ride"] = 306.52}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.52, ["Ride"] = 28.93, ["Neon"] = 11.81, ["Neon|Fly|Ride"] = 213.86, ["Mega"] = 140.44, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 35.44, ["Fly"] = 62.99, ["Ride"] = 57.66, ["Fly|Ride"] = 96.92, ["Neon"] = 199.5, ["Neon|Ride"] = 216.57, ["Neon|Fly|Ride"] = 427.69, ["Mega|Ride"] = 1708.93, ["Mega|Fly|Ride"] = 1424.83}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 4.54, ["Fly"] = 16.04, ["Ride"] = 15.53, ["Fly|Ride"] = 36.37, ["Neon"] = 25.92, ["Neon|Fly"] = 70.59, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 73.41, ["Mega"] = 198.19, ["Mega|Fly"] = 426.19, ["Mega|Ride"] = 189.81, ["Mega|Fly|Ride"] = 289.12}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 5.03, ["Fly"] = 37.4, ["Ride"] = 27.55, ["Fly|Ride"] = 56.26, ["Neon"] = 19.68, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 118.11, ["Mega"] = 136.21, ["Mega|Ride"] = 169.31, ["Mega|Fly|Ride"] = 236.23}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 6.3, ["Mega"] = 39.29, ["Mega|Ride"] = 196.59, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 25.82, ["Fly"] = 77.96, ["Ride"] = 52.5, ["Fly|Ride"] = 91.88, ["Neon"] = 218.13, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 301.88, ["Mega|Ride"] = 850.4, ["Mega|Fly|Ride"] = 702.62}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 20.78, ["Fly|Ride"] = 65.63, ["Neon"] = 3.94, ["Neon|Ride"] = 28.88, ["Mega"] = 92.94, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 468.16}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 14.44, ["Ride"] = 81.18, ["Fly|Ride"] = 284.43, ["Neon"] = 101.58, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 421.91, ["Mega|Fly|Ride"] = 712.42}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 15.06, ["Fly|Ride"] = 40.64, ["Neon"] = 18.21, ["Neon|Ride"] = 38.78, ["Neon|Fly|Ride"] = 76.65, ["Mega|Ride"] = 208.04, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 4.29, ["Fly"] = 52.49, ["Ride"] = 20.89, ["Fly|Ride"] = 65.17, ["Neon"] = 40.69, ["Neon|Ride"] = 427.69, ["Mega"] = 291.38, ["Mega|Ride"] = 427.25, ["Mega|Fly|Ride"] = 412.79}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.2, ["Ride"] = 60.97, ["Neon"] = 39.38, ["Neon|Ride"] = 227.06, ["Mega"] = 413.86, ["Mega|Ride"] = 967.75}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 41.36, ["Ride"] = 263.82, ["Neon"] = 459.38, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 471.53, ["Mega|Fly|Ride"] = 1935.94}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 62.88, ["Ride"] = 285.13, ["Neon"] = 107.62, ["Neon|Ride"] = 183.75, ["Mega"] = 421.31, ["Mega|Ride"] = 564.93, ["Mega|Fly|Ride"] = 598.15}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 4.54, ["Ride"] = 125.98, ["Neon"] = 183.91, ["Neon|Fly"] = 213.86, ["Neon|Ride"] = 427.69, ["Mega|Ride"] = 853.41}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 22.31, ["Ride"] = 232.32, ["Fly|Ride"] = 367.46, ["Neon"] = 103.34, ["Neon|Ride"] = 748.46, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 592.38, ["Mega|Fly"] = 2136.18, ["Mega|Fly|Ride"] = 1129.85}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.63, ["Neon"] = 13.12, ["Neon|Ride"] = 32.72, ["Mega"] = 242.46, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 323}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 27.78, ["Ride"] = 19.26, ["Fly|Ride"] = 42.78, ["Neon"] = 4.73, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 42.78, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 66.69, ["Mega|Ride"] = 120.98, ["Mega|Fly|Ride"] = 321.57}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 3.93, ["Ride"] = 42.73, ["Fly|Ride"] = 65.63, ["Neon"] = 39.38, ["Neon|Ride"] = 70.73, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 87.93, ["Mega|Ride"] = 162.1, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 19.48, ["Fly|Ride"] = 57.75, ["Neon"] = 7.47, ["Neon|Ride"] = 26.16, ["Neon|Fly|Ride"] = 105, ["Mega"] = 42.86, ["Mega|Fly"] = 170.9, ["Mega|Ride"] = 77.97, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.82, ["Fly"] = 65.62, ["Ride"] = 26.25, ["Fly|Ride"] = 118.13, ["Neon"] = 15.73, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 328.02, ["Mega|Ride"] = 337.53, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 2.63, ["Fly"] = 65.63, ["Ride"] = 26.63, ["Neon"] = 28.39, ["Neon|Fly"] = 315, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 427.25}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.28, ["Fly"] = 131.25, ["Ride"] = 21, ["Fly|Ride"] = 71.54, ["Neon"] = 17.07, ["Neon|Fly"] = 112.73, ["Neon|Ride"] = 40.64, ["Neon|Fly|Ride"] = 102.38, ["Mega"] = 358.89, ["Mega|Ride"] = 300.01, ["Mega|Fly|Ride"] = 396.38}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.48, ["Ride"] = 21.39, ["Fly|Ride"] = 51.89, ["Neon"] = 19.69, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 106.94, ["Mega"] = 252.82, ["Mega|Ride"] = 213.63, ["Mega|Fly|Ride"] = 186.18}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 3.36, ["Fly"] = 57.66, ["Ride"] = 42.84, ["Fly|Ride"] = 131.25, ["Neon"] = 15.33, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 45.47, ["Neon|Fly|Ride"] = 171.09, ["Mega"] = 118.13, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 160.23, ["Mega|Fly|Ride"] = 209.25}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 20.01, ["Fly"] = 207.74, ["Ride"] = 101.75, ["Fly|Ride"] = 209.9, ["Neon"] = 135.8, ["Neon|Ride"] = 216.84, ["Neon|Fly|Ride"] = 420, ["Mega"] = 630, ["Mega|Ride"] = 545.9, ["Mega|Fly|Ride"] = 673.71}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 59.07, ["Fly"] = 164.07, ["Ride"] = 103.03, ["Fly|Ride"] = 181.13, ["Neon"] = 221.82, ["Neon|Ride"] = 306.87, ["Neon|Fly|Ride"] = 496.65, ["Mega"] = 1566.89, ["Mega|Ride"] = 1061.82, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 50.97, ["Ride"] = 18.36, ["Fly|Ride"] = 65.43, ["Neon"] = 2.63, ["Neon|Ride"] = 24.49, ["Mega"] = 30.36, ["Mega|Ride"] = 47.45, ["Mega|Fly|Ride"] = 143.92}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 65.62, ["Ride"] = 52.5, ["Neon"] = 285.49, ["Mega"] = 686.56, ["Mega|Ride"] = 534.06, ["Mega|Fly|Ride"] = 1064.89}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 64.21, ["Ride"] = 78.75, ["Fly|Ride"] = 183.75, ["Neon"] = 194.91, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 854.31, ["Mega"] = 1750.6, ["Mega|Ride"] = 1613.89, ["Mega|Fly|Ride"] = 1339.38}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 6.56, ["Fly"] = 190.32, ["Ride"] = 28.63, ["Fly|Ride"] = 133.88, ["Neon"] = 36.75, ["Neon|Ride"] = 85.55, ["Neon|Fly|Ride"] = 210, ["Mega"] = 192.94, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 427.25}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 3.26, ["Ride"] = 68.81, ["Fly|Ride"] = 179.29, ["Neon"] = 10.21, ["Neon|Fly|Ride"] = 140.07, ["Mega"] = 100.68, ["Mega|Ride"] = 158.09, ["Mega|Fly|Ride"] = 364.88}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 40.05, ["Ride"] = 17.07, ["Fly|Ride"] = 37.8, ["Neon"] = 11.58, ["Neon|Ride"] = 37.02, ["Neon|Fly|Ride"] = 81.38, ["Mega"] = 236.15, ["Mega|Ride"] = 212.57, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.75, ["Ride"] = 14.75, ["Fly|Ride"] = 42.78, ["Neon"] = 2.1, ["Neon|Fly"] = 23.88, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 28.87, ["Mega|Ride"] = 69.56, ["Mega|Fly|Ride"] = 150.73}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 19.26, ["Fly|Ride"] = 52.5, ["Neon"] = 2.1, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 39.25, ["Mega|Ride"] = 114.3, ["Mega|Fly|Ride"] = 188.84}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 2.62, ["Neon|Ride"] = 145.08, ["Mega"] = 25.35, ["Mega|Fly|Ride"] = 328.02}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 6.26, ["Ride"] = 157.5, ["Neon"] = 31.5, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 641.53, ["Mega"] = 426.19, ["Mega|Ride"] = 269.48, ["Mega|Fly|Ride"] = 323}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 6.36, ["Ride"] = 31.62, ["Fly|Ride"] = 198.66, ["Neon"] = 52.97, ["Neon|Ride"] = 100.52, ["Neon|Fly|Ride"] = 143.29, ["Mega"] = 286.78, ["Mega|Ride"] = 262.4, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 5.99, ["Fly"] = 41.16, ["Ride"] = 18.18, ["Fly|Ride"] = 39.29, ["Neon"] = 32.81, ["Neon|Ride"] = 38.17, ["Neon|Fly|Ride"] = 95.24, ["Mega|Ride"] = 222.86, ["Mega|Fly|Ride"] = 318.17}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 56.44, ["Ride"] = 76.13, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 597.19, ["Mega"] = 2419.33, ["Mega|Fly|Ride"] = 1472.63}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 16.76, ["Fly"] = 82.68, ["Ride"] = 32.82, ["Fly|Ride"] = 143.29, ["Neon"] = 118.13, ["Neon|Fly|Ride"] = 630, ["Mega"] = 635.92, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 694.98}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 26.63, ["Ride"] = 15.75, ["Fly|Ride"] = 38.07, ["Neon"] = 2.51, ["Neon|Fly"] = 42.78, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 59.89, ["Mega"] = 32.82, ["Mega|Ride"] = 90.65, ["Mega|Fly|Ride"] = 188.98}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 16.59, ["Ride"] = 14.75, ["Fly|Ride"] = 35.35, ["Neon"] = 3.94, ["Neon|Fly"] = 24.34, ["Neon|Ride"] = 21.32, ["Neon|Fly|Ride"] = 50.26, ["Mega"] = 44.63, ["Mega|Fly"] = 100.42, ["Mega|Ride"] = 57.16, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 393.74, ["Ride"] = 446.25, ["Fly|Ride"] = 569.63, ["Neon|Fly|Ride"] = 1997.26}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 6.55, ["Ride"] = 65.62, ["Neon"] = 48.46, ["Neon|Ride"] = 112.88, ["Mega"] = 403.49, ["Mega|Ride"] = 400.32, ["Mega|Fly|Ride"] = 284821.28}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 15.41, ["Ride"] = 18.01, ["Fly|Ride"] = 31.4, ["Neon"] = 5.14, ["Neon|Fly"] = 18.38, ["Neon|Ride"] = 17.12, ["Neon|Fly|Ride"] = 45.12, ["Mega"] = 143.13, ["Mega|Ride"] = 74.99, ["Mega|Fly|Ride"] = 112.73}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 50.3, ["Ride"] = 92.76, ["Fly|Ride"] = 299.38, ["Neon"] = 227.07, ["Neon|Ride"] = 308.23, ["Neon|Fly|Ride"] = 443.63, ["Mega"] = 721.88, ["Mega|Ride"] = 761.23, ["Mega|Fly|Ride"] = 930.36}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 19.48, ["Ride"] = 18.17, ["Fly|Ride"] = 34.13, ["Neon"] = 11.43, ["Neon|Fly"] = 76.12, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 111.46, ["Mega|Ride"] = 131.61, ["Mega|Fly|Ride"] = 215.22}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 71.56, ["Ride"] = 21, ["Neon"] = 3.83, ["Neon|Ride"] = 35.43, ["Neon|Fly|Ride"] = 74.81, ["Mega"] = 18.35, ["Mega|Ride"] = 67.94, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 40.6, ["Fly"] = 128.28, ["Ride"] = 70.88, ["Fly|Ride"] = 211.42, ["Neon"] = 174.57, ["Neon|Ride"] = 157.4, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 983.89, ["Mega|Ride"] = 1120.43, ["Mega|Fly|Ride"] = 792.75}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 19.69, ["Neon"] = 4.71, ["Neon|Ride"] = 39.99, ["Neon|Fly|Ride"] = 79.13, ["Mega"] = 36.75, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 27.57, ["Ride"] = 66.94, ["Fly|Ride"] = 159.91, ["Neon"] = 427.69, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 1774.59, ["Mega|Ride"] = 1708.93, ["Mega|Fly|Ride"] = 1538.06}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.56, ["Ride"] = 183.74, ["Neon"] = 22.15, ["Neon|Ride"] = 20.29, ["Neon|Fly|Ride"] = 158.25, ["Mega"] = 170.63, ["Mega|Ride"] = 603.75}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 71.56, ["Ride"] = 69.17, ["Fly|Ride"] = 70.49, ["Neon"] = 8.64, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 429.19, ["Mega"] = 91.25, ["Mega|Ride"] = 170.9, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 39.38, ["Fly"] = 143.11, ["Ride"] = 50.93, ["Fly|Ride"] = 213.86, ["Mega|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 1993.05}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 27.41, ["Fly|Ride"] = 908.99, ["Neon"] = 6.32, ["Neon|Ride"] = 40.64, ["Neon|Fly|Ride"] = 164.68, ["Mega"] = 48.81, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 105.34, ["Mega|Fly|Ride"] = 226.96}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 19.95, ["Ride"] = 19.49, ["Fly|Ride"] = 98.44, ["Neon"] = 10.05, ["Neon|Fly"] = 48.46, ["Neon|Ride"] = 32.63, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 96.79, ["Mega|Fly|Ride"] = 219.19}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 6.57, ["Fly"] = 58.5, ["Ride"] = 31.08, ["Fly|Ride"] = 75.87, ["Neon"] = 81.8, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 156.12, ["Mega"] = 328.12, ["Mega|Ride"] = 414.44, ["Mega|Fly|Ride"] = 405.57}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 7.82, ["Ride"] = 24.94, ["Fly|Ride"] = 101.58, ["Neon"] = 65.63, ["Neon|Ride"] = 76.12, ["Neon|Fly|Ride"] = 143.29, ["Mega"] = 934.58, ["Mega|Ride"] = 455.02, ["Mega|Fly|Ride"] = 517.36}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 24.34, ["Fly"] = 51.18, ["Ride"] = 25.99, ["Fly|Ride"] = 52.5, ["Neon"] = 74.28, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 141.16, ["Mega"] = 570.38, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 413.27}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 65.52, ["Ride"] = 118.13, ["Fly|Ride"] = 221.21, ["Neon"] = 318.31, ["Neon|Ride"] = 395.61, ["Neon|Fly|Ride"] = 751.03, ["Mega|Ride"] = 1467.56, ["Mega|Fly|Ride"] = 1309.87}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 4.85, ["Ride"] = 28.88, ["Neon"] = 24.07, ["Neon|Ride"] = 121.72, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 230.13, ["Mega|Ride"] = 462, ["Mega|Fly|Ride"] = 413.36}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 4.47, ["Ride"] = 26.88, ["Fly|Ride"] = 78.74, ["Neon"] = 16.06, ["Neon|Ride"] = 46.77, ["Neon|Fly|Ride"] = 213.86, ["Mega"] = 262.4, ["Mega|Ride"] = 183.74, ["Mega|Fly|Ride"] = 246.62}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 10.26, ["Fly"] = 287.55, ["Ride"] = 28.45, ["Fly|Ride"] = 162.33, ["Neon"] = 76.13, ["Neon|Ride"] = 141.42, ["Mega"] = 452.43, ["Mega|Ride"] = 498.81, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 14.42, ["Fly|Ride"] = 32.16, ["Neon"] = 2.24, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 14.43, ["Neon|Fly|Ride"] = 39.26, ["Mega"] = 15.11, ["Mega|Ride"] = 48.41, ["Mega|Fly|Ride"] = 94.79}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 49.88, ["Ride"] = 112.56, ["Fly|Ride"] = 285.49, ["Neon"] = 262.5, ["Neon|Fly"] = 2423.88, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 1129.85, ["Mega|Ride"] = 1001.37, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 21.59, ["Fly|Ride"] = 36.37, ["Neon"] = 3.59, ["Neon|Ride"] = 28.29, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 31.49, ["Mega|Ride"] = 143.13, ["Mega|Fly|Ride"] = 301.87}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.85, ["Ride"] = 16.68, ["Fly|Ride"] = 59.06, ["Neon"] = 15.75, ["Neon|Ride"] = 29.11, ["Neon|Fly|Ride"] = 87.35, ["Mega"] = 257.25, ["Mega|Ride"] = 192.93, ["Mega|Fly|Ride"] = 280.73}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 54.74, ["Fly"] = 71.59, ["Ride"] = 104.99, ["Fly|Ride"] = 258.57, ["Neon"] = 480.38, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 484.55, ["Mega"] = 1745.63, ["Mega|Ride"] = 1765.32, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 25.26, ["Neon"] = 7.55, ["Neon|Ride"] = 52.5, ["Mega"] = 63.95, ["Mega|Ride"] = 108.03, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 5.24}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 27.78, ["Fly|Ride"] = 498.26, ["Neon"] = 6.57, ["Neon|Ride"] = 51.89, ["Neon|Fly|Ride"] = 103.95, ["Mega"] = 47.21, ["Mega|Ride"] = 115.77, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 131.1, ["Ride"] = 105, ["Fly|Ride"] = 349.64, ["Neon"] = 836.07, ["Neon|Ride"] = 711.05, ["Neon|Fly|Ride"] = 917.44, ["Mega"] = 3417.86, ["Mega|Ride"] = 2506.88, ["Mega|Fly|Ride"] = 2835}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.03, ["Ride"] = 36.47, ["Fly|Ride"] = 213.86, ["Neon"] = 19.59, ["Neon|Fly"] = 143.29, ["Neon|Ride"] = 64.32, ["Mega"] = 178.4, ["Mega|Ride"] = 211.31, ["Mega|Fly|Ride"] = 645.98}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 36.32, ["Neon"] = 3.83, ["Neon|Ride"] = 20.86, ["Mega"] = 31.2, ["Mega|Ride"] = 104.69, ["Mega|Fly|Ride"] = 143.13}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 5.25, ["Ride"] = 21.1, ["Fly|Ride"] = 131.25, ["Neon"] = 52.61, ["Neon|Ride"] = 65.43, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 413.36, ["Mega|Ride"] = 427.25, ["Mega|Fly|Ride"] = 625.64}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 10.5, ["Fly"] = 70.84, ["Ride"] = 21.36, ["Fly|Ride"] = 56.58, ["Neon"] = 100.01, ["Neon|Ride"] = 157.31, ["Neon|Fly|Ride"] = 307.79, ["Mega"] = 626.07, ["Mega|Ride"] = 581.44, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 23.55, ["Ride"] = 59.07, ["Fly|Ride"] = 128.42, ["Neon"] = 172.28, ["Neon|Ride"] = 161.44, ["Neon|Fly|Ride"] = 484.55, ["Mega"] = 560.44, ["Mega|Ride"] = 655.81, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 131.24, ["Fly"] = 196.88, ["Ride"] = 190.21, ["Fly|Ride"] = 210, ["Neon"] = 565.13, ["Neon|Ride"] = 590.62, ["Neon|Fly|Ride"] = 687.75, ["Mega|Fly|Ride"] = 2420.14}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 7.52, ["Fly"] = 18.38, ["Ride"] = 20.74, ["Fly|Ride"] = 42.71, ["Neon"] = 39.38, ["Neon|Fly"] = 155.74, ["Neon|Ride"] = 39.36, ["Neon|Fly|Ride"] = 86.63, ["Mega|Fly|Ride"] = 336}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 131.23, ["Ride"] = 21, ["Fly|Ride"] = 131.24, ["Neon"] = 15.75, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 138.86, ["Mega|Ride"] = 140.33, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 7.87, ["Fly"] = 50.21, ["Ride"] = 27.56, ["Fly|Ride"] = 91.87, ["Neon"] = 114.42, ["Neon|Ride"] = 101.58, ["Neon|Fly|Ride"] = 171.09, ["Mega"] = 379.32, ["Mega|Ride"] = 483.88, ["Mega|Fly|Ride"] = 570.38}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 55.44, ["Fly"] = 159.75, ["Ride"] = 52.5, ["Fly|Ride"] = 166.69, ["Neon"] = 223.13, ["Neon|Ride"] = 334.35, ["Neon|Fly|Ride"] = 457.63, ["Mega"] = 1566.89, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1002.04}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 18.36, ["Ride"] = 85.44, ["Neon"] = 158.25, ["Neon|Ride"] = 185.77, ["Neon|Fly|Ride"] = 471.53, ["Mega"] = 699.36, ["Mega|Ride"] = 518.46}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.39, ["Ride"] = 615.57, ["Neon|Ride"] = 3230.58, ["Neon|Fly|Ride"] = 1710.73}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 24.26, ["Fly"] = 57.68, ["Ride"] = 36.75, ["Fly|Ride"] = 96.92, ["Neon"] = 249.38, ["Neon|Ride"] = 143.29, ["Neon|Fly|Ride"] = 323.44, ["Mega"] = 761.25, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 38.75, ["Ride"] = 14.44, ["Fly|Ride"] = 31.5, ["Neon"] = 2.62, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 50.33, ["Mega"] = 20.9, ["Mega|Fly"] = 110.02, ["Mega|Ride"] = 35.85, ["Mega|Fly|Ride"] = 105.98}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.63, ["Neon"] = 9.19, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 143.29, ["Mega|Ride"] = 164.17}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.76, ["Ride"] = 23.63, ["Neon"] = 19.45, ["Neon|Ride"] = 84.49, ["Neon|Fly|Ride"] = 981.05, ["Mega"] = 115.31, ["Mega|Fly"] = 498.61, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 393.75, ["Fly"] = 498.6, ["Ride"] = 354.38, ["Fly|Ride"] = 448.94, ["Neon"] = 1426.32, ["Neon|Ride"] = 1734.62, ["Neon|Fly|Ride"] = 1618.77, ["Mega|Fly|Ride"] = 5511.31}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 20.83, ["Ride"] = 15.39, ["Fly|Ride"] = 49.87, ["Neon"] = 19.68, ["Neon|Ride"] = 48.46, ["Neon|Fly|Ride"] = 87.44, ["Mega"] = 170.52, ["Mega|Ride"] = 213.93, ["Mega|Fly|Ride"] = 563.07}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 6.39, ["Fly"] = 19.99, ["Ride"] = 18.19, ["Fly|Ride"] = 44.63, ["Neon"] = 20.33, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 72.69, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 272.37, ["Mega|Fly|Ride"] = 286.38}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.42, ["Fly"] = 32.45, ["Ride"] = 28.88, ["Fly|Ride"] = 121.14, ["Neon"] = 16.89, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 37.44, ["Neon|Fly|Ride"] = 107.33, ["Mega"] = 123.4, ["Mega|Ride"] = 256.35, ["Mega|Fly|Ride"] = 196.87}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 28.88, ["Fly"] = 44.77, ["Ride"] = 42.73, ["Fly|Ride"] = 65.63, ["Neon"] = 193.82, ["Neon|Ride"] = 179.29, ["Neon|Fly|Ride"] = 319.71, ["Mega"] = 1312.5, ["Mega|Ride"] = 854.47, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 34, ["Fly|Ride"] = 49.68, ["Neon"] = 11.82, ["Neon|Ride"] = 79.13, ["Neon|Fly|Ride"] = 210, ["Mega"] = 163.74, ["Mega|Ride"] = 457.8, ["Mega|Fly|Ride"] = 919.42}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 8.57, ["Fly"] = 65.6, ["Ride"] = 28.12, ["Neon"] = 168.9, ["Neon|Ride"] = 113.88, ["Mega|Ride"] = 769.04, ["Mega|Fly|Ride"] = 846.57}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.76, ["Neon"] = 6.17, ["Neon|Ride"] = 35.32, ["Mega"] = 54.37, ["Mega|Ride"] = 121.77, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 9.08, ["Ride"] = 140.44, ["Neon"] = 50.66, ["Mega|Fly|Ride"] = 697.6}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 6.56, ["Ride"] = 32.68, ["Neon"] = 82.29, ["Neon|Ride"] = 484.55, ["Mega"] = 315.1, ["Mega|Ride"] = 551.15, ["Mega|Fly|Ride"] = 509.25}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 9.19, ["Fly"] = 30.19, ["Ride"] = 24.94, ["Fly|Ride"] = 52.41, ["Neon"] = 52.5, ["Neon|Fly"] = 121.14, ["Neon|Ride"] = 54.74, ["Neon|Fly|Ride"] = 105, ["Mega"] = 600.27, ["Mega|Ride"] = 314.93, ["Mega|Fly|Ride"] = 339.43}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 354.38, ["Fly"] = 522.76, ["Ride"] = 394.93, ["Fly|Ride"] = 416.07, ["Neon"] = 1642.41, ["Neon|Ride"] = 1640.16, ["Neon|Fly|Ride"] = 1426.32, ["Mega|Fly|Ride"] = 5250}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.64, ["Fly|Ride"] = 36.37, ["Neon"] = 13.13, ["Neon|Fly"] = 81.18, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 131.92, ["Mega"] = 207.23, ["Mega|Ride"] = 196.77}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.87, ["Ride"] = 40.69, ["Fly|Ride"] = 65.63, ["Neon"] = 71.31, ["Neon|Ride"] = 123.35, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 340.03, ["Mega|Fly"] = 712.42, ["Mega|Ride"] = 511.63, ["Mega|Fly|Ride"] = 502.03}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 35.24, ["Ride"] = 118.13, ["Fly|Ride"] = 315, ["Neon"] = 76.13, ["Neon|Ride"] = 208.51, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 422.62, ["Mega|Ride"] = 427.25}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 67.92, ["Fly"] = 95.58, ["Ride"] = 89.82, ["Fly|Ride"] = 196.88, ["Neon"] = 889.11, ["Neon|Ride"] = 425.25, ["Neon|Fly|Ride"] = 1453.58, ["Mega"] = 2492.09, ["Mega|Fly|Ride"] = 2421.35}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 11.52, ["Fly"] = 106.8, ["Ride"] = 53.82, ["Fly|Ride"] = 141.61, ["Neon"] = 43.32, ["Neon|Ride"] = 79.13, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 194.19, ["Mega|Ride"] = 236.31, ["Mega|Fly|Ride"] = 604.85}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 28.87, ["Ride"] = 19.59, ["Fly|Ride"] = 58.47, ["Neon"] = 12.48, ["Neon|Ride"] = 33.5, ["Neon|Fly|Ride"] = 71.65, ["Mega"] = 65.6, ["Mega|Ride"] = 147.59, ["Mega|Fly|Ride"] = 261.18}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 4.73, ["Ride"] = 40.85, ["Fly|Ride"] = 64.32, ["Neon"] = 25.44, ["Neon|Ride"] = 94.25, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 175, ["Mega|Ride"] = 190.13, ["Mega|Fly|Ride"] = 350.81}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 53.24, ["Fly"] = 183.75, ["Ride"] = 99.75, ["Fly|Ride"] = 214.39, ["Neon"] = 139.04, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 338.63, ["Mega"] = 427.25, ["Mega|Ride"] = 455.25, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 10.56, ["Neon|Fly"] = 65.43, ["Neon|Ride"] = 213.86, ["Neon|Fly|Ride"] = 199.31, ["Mega"] = 48.57, ["Mega|Ride"] = 194.4, ["Mega|Fly|Ride"] = 427.25}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 19.23, ["Neon"] = 123.38, ["Neon|Ride"] = 499.32, ["Neon|Fly|Ride"] = 855.37, ["Mega"] = 556.06, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 918.75, ["Fly"] = 1194.38, ["Ride"] = 1061.82, ["Fly|Ride"] = 1049.88, ["Neon"] = 3402.17, ["Neon|Ride"] = 3664.14, ["Neon|Fly|Ride"] = 3550.8, ["Mega|Fly|Ride"] = 11612.76}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 13.13, ["Ride"] = 63.1, ["Fly|Ride"] = 193.82, ["Neon"] = 117.97, ["Neon|Fly"] = 712.09, ["Neon|Ride"] = 144.36, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 326.48, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.37, ["Ride"] = 28.85, ["Fly|Ride"] = 80.92, ["Neon"] = 10.49, ["Neon|Fly"] = 57.75, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 93.19, ["Mega|Ride"] = 126.05, ["Mega|Fly|Ride"] = 191.09}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 7.88, ["Ride"] = 47.79, ["Fly|Ride"] = 143.29, ["Neon"] = 100.52, ["Mega"] = 787.5, ["Mega|Ride"] = 541.86, ["Mega|Fly|Ride"] = 483.88}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 34.72, ["Fly|Ride"] = 182.97, ["Neon"] = 3.68, ["Neon|Ride"] = 26.23, ["Neon|Fly|Ride"] = 80.06, ["Mega"] = 17.07, ["Mega|Fly"] = 128.19, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 213.63}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 54.21, ["Ride"] = 210.78, ["Fly|Ride"] = 236.25, ["Neon"] = 260.91, ["Neon|Ride"] = 298.03, ["Neon|Fly|Ride"] = 410.59, ["Mega"] = 1106.35, ["Mega|Ride"] = 974.96, ["Mega|Fly|Ride"] = 957.92}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 7.74, ["Ride"] = 61.69, ["Fly|Ride"] = 238.87, ["Neon"] = 81.2, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 567.16, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 639.79}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.94, ["Ride"] = 27.37, ["Neon"] = 15.75, ["Neon|Ride"] = 65.63, ["Mega"] = 89.02, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 471.05}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 19.48, ["Fly"] = 67.29, ["Ride"] = 48.47, ["Fly|Ride"] = 121.14, ["Neon"] = 81.27, ["Neon|Ride"] = 95.82, ["Neon|Fly|Ride"] = 155.92, ["Mega"] = 1039.49, ["Mega|Ride"] = 376.92, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 6.57, ["Fly"] = 33.12, ["Ride"] = 34.13, ["Fly|Ride"] = 96.25, ["Neon"] = 89.82, ["Neon|Ride"] = 71.65, ["Neon|Fly|Ride"] = 120.09, ["Mega"] = 570.38, ["Mega|Ride"] = 528.71, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 40.69, ["Ride"] = 208.68, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 731.73, ["Mega"] = 2103.24, ["Mega|Ride"] = 1708.93, ["Mega|Fly|Ride"] = 2136.18}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 8.43, ["Ride"] = 51.34, ["Neon"] = 20.89, ["Neon|Ride"] = 96.25, ["Neon|Fly|Ride"] = 161.21, ["Mega"] = 143.13, ["Mega|Ride"] = 170.9, ["Mega|Fly|Ride"] = 227.05}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 6.56, ["Ride"] = 19.4, ["Fly|Ride"] = 84.4, ["Neon"] = 48.46, ["Neon|Ride"] = 38.98, ["Neon|Fly|Ride"] = 135.63, ["Mega"] = 295.32, ["Mega|Ride"] = 413.36, ["Mega|Fly|Ride"] = 613.09}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 119.44, ["Fly"] = 393.75, ["Ride"] = 158.21, ["Fly|Ride"] = 251.9, ["Neon"] = 593.41, ["Neon|Ride"] = 598.76, ["Neon|Fly|Ride"] = 713.18, ["Mega|Ride"] = 2421.35, ["Mega|Fly|Ride"] = 1946.44}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 21.37, ["Ride"] = 17.72, ["Fly|Ride"] = 45.99, ["Neon"] = 12.96, ["Neon|Fly"] = 57.32, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 143.13, ["Mega|Ride"] = 199.75, ["Mega|Fly|Ride"] = 341.8}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 12.77, ["Fly"] = 200.81, ["Ride"] = 39.38, ["Fly|Ride"] = 100.52, ["Neon"] = 65.63, ["Neon|Ride"] = 85.56, ["Neon|Fly|Ride"] = 213.86, ["Mega"] = 452.82, ["Mega|Ride"] = 490.27, ["Mega|Fly|Ride"] = 419.89}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.37, ["Ride"] = 14.9, ["Fly|Ride"] = 52.4, ["Neon"] = 2.24, ["Neon|Fly"] = 26.67, ["Neon|Ride"] = 15.06, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 14.93, ["Mega|Fly"] = 50.82, ["Mega|Ride"] = 33.75, ["Mega|Fly|Ride"] = 79.94}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 57.75, ["Fly|Ride"] = 39.38, ["Neon"] = 2.61, ["Neon|Ride"] = 42.78, ["Neon|Fly|Ride"] = 132.59, ["Mega"] = 19.69, ["Mega|Fly"] = 104.99, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 138.8}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 36.32, ["Ride"] = 27.16, ["Fly|Ride"] = 128.59, ["Neon"] = 19.26, ["Neon|Ride"] = 55.55, ["Neon|Fly|Ride"] = 222.41, ["Mega"] = 74.92, ["Mega|Fly|Ride"] = 246.1}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 32.15, ["Ride"] = 52.49, ["Fly|Ride"] = 131.25, ["Neon"] = 168, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 492.31, ["Mega|Ride"] = 725.25, ["Mega|Fly|Ride"] = 949.54}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 3.92, ["Fly"] = 19.69, ["Ride"] = 17.22, ["Fly|Ride"] = 36.66, ["Neon"] = 9.54, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 32.45, ["Neon|Fly|Ride"] = 60.38, ["Mega"] = 105, ["Mega|Fly"] = 170.62, ["Mega|Ride"] = 143.13, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 3.94, ["Fly"] = 24.22, ["Ride"] = 28.41, ["Fly|Ride"] = 82.65, ["Neon"] = 17.33, ["Neon|Fly"] = 55.76, ["Neon|Ride"] = 47.96, ["Neon|Fly|Ride"] = 114.42, ["Mega"] = 230.99, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 21.36, ["Ride"] = 18.09, ["Fly|Ride"] = 70.59, ["Neon"] = 8.24, ["Neon|Fly"] = 36.37, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 89.24, ["Mega"] = 162.1, ["Mega|Fly"] = 220.4, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 127.32}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 8.81, ["Fly"] = 161.26, ["Ride"] = 23.83, ["Fly|Ride"] = 217.19, ["Neon"] = 26.24, ["Neon|Ride"] = 111.21, ["Neon|Fly|Ride"] = 285.49, ["Mega"] = 327.92, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 320.44, ["Mega|Fly|Ride"] = 421.91}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 15.1, ["Ride"] = 71.56, ["Neon"] = 74.76, ["Neon|Ride"] = 262.39, ["Mega"] = 682.5, ["Mega|Fly|Ride"] = 997.6}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 22.83, ["Ride"] = 19.26, ["Fly|Ride"] = 48.51, ["Neon"] = 25.99, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 141.27, ["Mega"] = 262.49, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 427.25}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 24.85, ["Ride"] = 14.44, ["Fly|Ride"] = 52.56, ["Neon"] = 16.61, ["Neon|Fly"] = 70.51, ["Neon|Ride"] = 21.39, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 186.93, ["Mega|Fly|Ride"] = 290.33}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 231.87, ["Fly"] = 393.75, ["Ride"] = 273, ["Fly|Ride"] = 393.75, ["Neon"] = 1069.2, ["Neon|Ride"] = 1417.25, ["Neon|Fly|Ride"] = 1041.41, ["Mega|Fly|Ride"] = 4130.27}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.66, ["Ride"] = 111.75, ["Neon"] = 35.44, ["Neon|Ride"] = 143.29, ["Neon|Fly|Ride"] = 427.69, ["Mega"] = 122.07, ["Mega|Ride"] = 420.6, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.13, ["Fly"] = 106.8, ["Ride"] = 22.24, ["Fly|Ride"] = 83.24, ["Neon"] = 23.15, ["Neon|Fly"] = 242.71, ["Neon|Ride"] = 59.79, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 209.9, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 234.94}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 4.83, ["Fly|Ride"] = 212.89, ["Neon"] = 36.66, ["Neon|Ride"] = 226.68, ["Neon|Fly|Ride"] = 641.53, ["Mega"] = 596.53, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 414.1}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 16.06, ["Ride"] = 14.45, ["Fly|Ride"] = 30.3, ["Neon"] = 2.63, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 16.06, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 20.03, ["Mega|Fly"] = 85.46, ["Mega|Ride"] = 38.47, ["Mega|Fly|Ride"] = 98.43}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 3.43, ["Fly"] = 24.86, ["Ride"] = 17.83, ["Fly|Ride"] = 79.13, ["Neon"] = 10.2, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 98.76, ["Mega"] = 111.75, ["Mega|Ride"] = 110.24, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.49, ["Ride"] = 143.29, ["Neon"] = 13.13, ["Neon|Ride"] = 143.29, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 74.78, ["Mega|Ride"] = 125.99, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 67.61, ["Ride"] = 84, ["Fly|Ride"] = 229.04, ["Neon"] = 556.5, ["Neon|Ride"] = 413.44, ["Neon|Fly|Ride"] = 646.86, ["Mega|Ride"] = 3562.07, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 2.1, ["Fly"] = 100.38, ["Ride"] = 28.88, ["Fly|Ride"] = 100.68, ["Neon"] = 25.08, ["Neon|Ride"] = 64.28, ["Mega"] = 157.49, ["Mega|Ride"] = 229.5, ["Mega|Fly|Ride"] = 575.71}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 49.14, ["Ride"] = 19.74, ["Neon"] = 9.08, ["Neon|Ride"] = 81.18, ["Neon|Fly|Ride"] = 543.89, ["Mega"] = 32.82, ["Mega|Fly"] = 315, ["Mega|Fly|Ride"] = 315.1}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 52.41, ["Fly"] = 210, ["Ride"] = 110, ["Fly|Ride"] = 183.75, ["Neon"] = 143.74, ["Neon|Ride"] = 192.47, ["Neon|Fly|Ride"] = 227.39, ["Mega"] = 564.38, ["Mega|Ride"] = 698.54, ["Mega|Fly|Ride"] = 595.87}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 17.03, ["Ride"] = 14.3, ["Fly|Ride"] = 28.58, ["Neon"] = 2.63, ["Neon|Fly"] = 21.81, ["Neon|Ride"] = 14.95, ["Neon|Fly|Ride"] = 40.69, ["Mega"] = 19.46, ["Mega|Fly"] = 49.87, ["Mega|Ride"] = 34.13, ["Mega|Fly|Ride"] = 88.99}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Fly|Ride"] = 106.94, ["Neon"] = 3.55, ["Neon|Ride"] = 113.88, ["Neon|Fly|Ride"] = 285.31, ["Mega"] = 27.57, ["Mega|Ride"] = 88.26, ["Mega|Fly|Ride"] = 176.05}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 42.09, ["Neon"] = 2.63, ["Neon|Fly"] = 59.07, ["Neon|Ride"] = 108.94, ["Neon|Fly|Ride"] = 136.13, ["Mega"] = 106.32, ["Mega|Fly"] = 185.85, ["Mega|Ride"] = 113.3, ["Mega|Fly|Ride"] = 356.75}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 8.13, ["Fly"] = 79.04, ["Ride"] = 48.57, ["Fly|Ride"] = 149, ["Neon"] = 21.39, ["Neon|Fly"] = 91.55, ["Neon|Ride"] = 111.21, ["Neon|Fly|Ride"] = 459.37, ["Mega"] = 111.91, ["Mega|Fly"] = 271.31, ["Mega|Ride"] = 324.62, ["Mega|Fly|Ride"] = 258.54}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 11.75, ["Ride"] = 13.98, ["Fly|Ride"] = 25.6, ["Neon"] = 2.3, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 44.01, ["Mega"] = 18.89, ["Mega|Ride"] = 52.49, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 15.74, ["Fly"] = 131.25, ["Ride"] = 90.56, ["Neon"] = 128.64, ["Neon|Fly"] = 427.69, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 570.38, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 645.98}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2610.57, ["Fly"] = 3150, ["Ride"] = 2493.75, ["Fly|Ride"] = 2622.38, ["Mega|Fly|Ride"] = 42722.08}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 16.76, ["Ride"] = 15.75, ["Fly|Ride"] = 41.72, ["Neon"] = 2.63, ["Neon|Fly"] = 46.04, ["Neon|Ride"] = 23.25, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 97.2, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 113.72, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.62, ["Neon"] = 7.66, ["Mega"] = 107.01, ["Mega|Fly"] = 441, ["Mega|Ride"] = 162.1, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 18.26, ["Fly"] = 28.97, ["Ride"] = 23.61, ["Fly|Ride"] = 105, ["Neon"] = 72.19, ["Neon|Ride"] = 114.57, ["Neon|Fly|Ride"] = 212.63, ["Mega"] = 426.57, ["Mega|Ride"] = 372.15, ["Mega|Fly|Ride"] = 483.88}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 31.85, ["Ride"] = 32.82, ["Neon"] = 187.69, ["Mega"] = 735.45, ["Mega|Ride"] = 622.99, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 150.72, ["Fly"] = 1403.03, ["Ride"] = 193.45, ["Fly|Ride"] = 306.5, ["Neon"] = 1312.5, ["Neon|Fly"] = 678.57, ["Neon|Ride"] = 714.65, ["Neon|Fly|Ride"] = 715.32, ["Mega"] = 6408.49, ["Mega|Fly|Ride"] = 3515.07}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 5.8, ["Ride"] = 31.49, ["Fly|Ride"] = 675.94, ["Neon"] = 26.25, ["Neon|Ride"] = 80.99, ["Neon|Fly|Ride"] = 75.11, ["Mega"] = 427.25, ["Mega|Fly"] = 13125, ["Mega|Fly|Ride"] = 363.17}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.63, ["Ride"] = 36.32, ["Fly|Ride"] = 71.65, ["Neon"] = 26.25, ["Neon|Ride"] = 114.85, ["Mega"] = 177.19, ["Mega|Ride"] = 333.38, ["Mega|Fly|Ride"] = 267.09}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 100.04, ["Ride"] = 19.69, ["Fly|Ride"] = 131.25, ["Neon"] = 7.76, ["Neon|Fly"] = 126.18, ["Neon|Ride"] = 40.04, ["Mega"] = 104.99, ["Mega|Ride"] = 100.42, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 15.75, ["Ride"] = 103.06, ["Neon"] = 186.05, ["Neon|Ride"] = 1214.96, ["Neon|Fly|Ride"] = 503.61, ["Mega"] = 380.63, ["Mega|Ride"] = 473.17, ["Mega|Fly|Ride"] = 597.85}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.49, ["Neon|Ride"] = 48.46, ["Mega"] = 17.11, ["Mega|Fly"] = 120.98, ["Mega|Ride"] = 79.97, ["Mega|Fly|Ride"] = 285.2}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 91.88, ["Fly"] = 105, ["Ride"] = 103.76, ["Fly|Ride"] = 158.25, ["Neon"] = 346.5, ["Neon|Ride"] = 416.99, ["Neon|Fly|Ride"] = 330.87, ["Mega|Fly|Ride"] = 1871.36}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 91.82, ["Neon"] = 10.5, ["Neon|Ride"] = 71.65, ["Neon|Fly|Ride"] = 213.86, ["Mega"] = 76.92, ["Mega|Ride"] = 285.2, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 64.96, ["Fly"] = 102.53, ["Ride"] = 74.82, ["Fly|Ride"] = 177.19, ["Neon"] = 405.57, ["Neon|Ride"] = 272.76, ["Neon|Fly|Ride"] = 433.12, ["Mega"] = 2563.4, ["Mega|Fly|Ride"] = 2848.59}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 24.22, ["Ride"] = 21.39, ["Fly|Ride"] = 51.35, ["Neon"] = 4.83, ["Neon|Fly"] = 120.83, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 42, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 213.63}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 20, ["Neon|Ride"] = 98.44, ["Mega"] = 92.61, ["Mega|Ride"] = 152.46, ["Mega|Fly|Ride"] = 502.02}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 5.25, ["Fly"] = 77.43, ["Ride"] = 33.12, ["Neon"] = 34.13, ["Neon|Ride"] = 120.75, ["Mega"] = 314.99, ["Mega|Ride"] = 288.74, ["Mega|Fly|Ride"] = 570.38}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 371.43, ["Ride"] = 389.82, ["Fly|Ride"] = 712.09, ["Neon"] = 1050, ["Neon|Ride"] = 964.67, ["Neon|Fly|Ride"] = 1144.5, ["Mega|Ride"] = 3412.5, ["Mega|Fly|Ride"] = 3664.86}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 33.68, ["Fly"] = 85.44, ["Ride"] = 50.27, ["Fly|Ride"] = 105.8, ["Neon"] = 196.88, ["Neon|Ride"] = 171.29, ["Neon|Fly|Ride"] = 427.69, ["Mega"] = 1422.7, ["Mega|Fly|Ride"] = 1995}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.69, ["Fly|Ride"] = 85.55, ["Neon"] = 11.68, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 95.46, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 119.55, ["Mega|Ride"] = 185.85, ["Mega|Fly|Ride"] = 285.2}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 18.99, ["Fly"] = 39.38, ["Ride"] = 38.58, ["Fly|Ride"] = 170.63, ["Neon"] = 68.81, ["Neon|Fly"] = 137.82, ["Neon|Ride"] = 124.78, ["Neon|Fly|Ride"] = 183.15, ["Mega"] = 341.8, ["Mega|Fly"] = 995.57, ["Mega|Ride"] = 347.82, ["Mega|Fly|Ride"] = 640.86}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 5.24, ["Ride"] = 32.72, ["Fly|Ride"] = 196.88, ["Neon"] = 65.43, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 274.98, ["Mega"] = 320.44, ["Mega|Ride"] = 326.85, ["Mega|Fly|Ride"] = 567.16}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 2.1, ["Neon"] = 19.69, ["Mega"] = 91.76, ["Mega|Ride"] = 143.13, ["Mega|Fly|Ride"] = 260.63}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 15.85, ["Fly|Ride"] = 65.63, ["Neon"] = 42.94, ["Neon|Ride"] = 45.47, ["Mega"] = 564.93, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 102.27, ["Ride"] = 129.94, ["Fly|Ride"] = 242.82, ["Neon"] = 775.39, ["Neon|Ride"] = 523.68, ["Neon|Fly|Ride"] = 568.5, ["Mega"] = 2887.5, ["Mega|Fly|Ride"] = 3204.26}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 22.09, ["Ride"] = 37.43, ["Fly|Ride"] = 124.69, ["Neon"] = 210, ["Neon|Ride"] = 282.19, ["Neon|Fly|Ride"] = 284.47, ["Mega"] = 1139.66, ["Mega|Fly|Ride"] = 997.6}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2231.25, ["Fly"] = 2030.44, ["Ride"] = 2060.63, ["Fly|Ride"] = 2152.5, ["Neon"] = 11405.07, ["Neon|Fly|Ride"] = 6429.94, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 57.66, ["Fly|Ride"] = 196.87, ["Neon"] = 18.71, ["Neon|Fly|Ride"] = 641.53, ["Mega"] = 110.82, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 171.94, ["Mega|Fly|Ride"] = 505.64}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 7.88, ["Ride"] = 50.27, ["Fly|Ride"] = 114.19, ["Neon"] = 42.41, ["Neon|Ride"] = 76.63, ["Neon|Fly|Ride"] = 232.38, ["Mega"] = 181.59, ["Mega|Ride"] = 181.78, ["Mega|Fly|Ride"] = 854.47}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 865.98, ["Fly"] = 1107.73, ["Ride"] = 900.38, ["Fly|Ride"] = 987, ["Neon"] = 2778.57, ["Neon|Ride"] = 2582.57, ["Neon|Fly|Ride"] = 2485.87, ["Mega|Fly|Ride"] = 11642.07}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 26.25, ["Ride"] = 49.88, ["Fly|Ride"] = 226.53, ["Neon"] = 183.3, ["Neon|Ride"] = 427.69, ["Neon|Fly|Ride"] = 382.78, ["Mega"] = 840, ["Mega|Ride"] = 804.56, ["Mega|Fly|Ride"] = 668.07}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.62, ["Ride"] = 23.63, ["Fly|Ride"] = 128.15, ["Neon"] = 10.89, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 157.5, ["Mega|Ride"] = 318.3, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 143.11, ["Neon"] = 2.63, ["Neon|Ride"] = 48.93, ["Neon|Fly|Ride"] = 99.33, ["Mega"] = 23.28, ["Mega|Ride"] = 143.42, ["Mega|Fly|Ride"] = 285.2}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 91.88, ["Ride"] = 129.94, ["Fly|Ride"] = 213.86, ["Neon"] = 459.38, ["Neon|Ride"] = 605.67, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 2419.33, ["Mega|Fly|Ride"] = 2122.29}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 4.78, ["Ride"] = 37.56, ["Fly|Ride"] = 73.8, ["Neon"] = 13.11, ["Neon|Ride"] = 52.11, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 118.57, ["Mega|Ride"] = 122.04, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 77.44, ["Ride"] = 126, ["Fly|Ride"] = 91.88, ["Neon"] = 459.37, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 524.98, ["Mega|Fly|Ride"] = 1813.62}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 5.13, ["Fly"] = 105, ["Fly|Ride"] = 128.31, ["Neon"] = 26.24, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 241.95, ["Mega|Ride"] = 285.2, ["Mega|Fly|Ride"] = 427.25}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 262.49, ["Fly"] = 354.38, ["Ride"] = 307.13, ["Fly|Ride"] = 340.19, ["Neon"] = 1137.32, ["Neon|Ride"] = 1064.63, ["Neon|Fly|Ride"] = 879.03, ["Mega|Fly|Ride"] = 5697.15}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 24.75, ["Fly|Ride"] = 48.45, ["Neon"] = 33.15, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 101.03, ["Mega"] = 280.22, ["Mega|Ride"] = 318.93}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 19.38, ["Ride"] = 16.9, ["Fly|Ride"] = 42.78, ["Neon"] = 6.22, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 11.82, ["Neon|Fly|Ride"] = 46.12, ["Mega"] = 40.68, ["Mega|Ride"] = 68.97, ["Mega|Fly|Ride"] = 124.73}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1275.03, ["Ride"] = 1050, ["Fly|Ride"] = 1254.19, ["Neon|Ride"] = 7841.46, ["Neon|Fly|Ride"] = 6700.63, ["Mega"] = 23709.38, ["Mega|Fly|Ride"] = 28487.82}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 7.55, ["Fly"] = 997.39, ["Ride"] = 77.58, ["Neon"] = 79.42, ["Neon|Ride"] = 314.98, ["Mega"] = 241.95, ["Mega|Ride"] = 528.71, ["Mega|Fly|Ride"] = 564.27}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 7.39, ["Fly"] = 51.27, ["Ride"] = 54.48, ["Fly|Ride"] = 91.77, ["Neon"] = 19.69, ["Neon|Fly"] = 285.21, ["Neon|Ride"] = 52.78, ["Neon|Fly|Ride"] = 171.09, ["Mega"] = 175.88, ["Mega|Ride"] = 195.84, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 31.4, ["Fly"] = 48.57, ["Ride"] = 39.38, ["Fly|Ride"] = 77.35, ["Neon|Ride"] = 209.79, ["Neon|Fly|Ride"] = 209.9, ["Mega|Ride"] = 1129.85, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 13.86, ["Fly"] = 85.44, ["Ride"] = 27.56, ["Fly|Ride"] = 77.44, ["Neon"] = 69.57, ["Neon|Ride"] = 93.18, ["Neon|Fly|Ride"] = 179.69, ["Mega"] = 367.4, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 372.75}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 44.54, ["Ride"] = 103.69, ["Fly|Ride"] = 416.99, ["Neon"] = 188.9, ["Neon|Ride"] = 378, ["Neon|Fly|Ride"] = 534.6, ["Mega"] = 1050, ["Mega|Ride"] = 669.71, ["Mega|Fly|Ride"] = 704.94}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Fly|Ride"] = 274.98, ["Neon"] = 3.1, ["Neon|Fly"] = 57.75, ["Neon|Ride"] = 26.25, ["Mega"] = 18.38, ["Mega|Ride"] = 87.94}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 75.51, ["Fly"] = 128.16, ["Ride"] = 103.69, ["Fly|Ride"] = 175.61, ["Neon"] = 565.7, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 3417.86, ["Mega|Fly|Ride"] = 1650.49}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 6.42, ["Fly"] = 107.62, ["Ride"] = 23.63, ["Fly|Ride"] = 71.65, ["Neon"] = 85.55, ["Neon|Ride"] = 95.95, ["Neon|Fly|Ride"] = 171.09, ["Mega"] = 773.06, ["Mega|Ride"] = 435.49, ["Mega|Fly|Ride"] = 490.88}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 28.85, ["Ride"] = 16, ["Fly|Ride"] = 39.36, ["Neon"] = 18.38, ["Neon|Fly"] = 81.18, ["Neon|Ride"] = 67.37, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 275.07, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.1, ["Ride"] = 126, ["Neon"] = 16.03, ["Neon|Fly"] = 141.16, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 203.16, ["Mega"] = 399.48, ["Mega|Fly|Ride"] = 483.88}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 58.97, ["Ride"] = 128.31, ["Fly|Ride"] = 262.5, ["Neon"] = 326.82, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 705.69, ["Mega|Ride"] = 1467.56, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 2.57, ["Fly|Ride"] = 427.69, ["Neon"] = 16.69, ["Neon|Ride"] = 131.25, ["Mega"] = 126.88, ["Mega|Ride"] = 138.86, ["Mega|Fly|Ride"] = 323}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 34.23, ["Neon"] = 2.49, ["Neon|Ride"] = 52.5, ["Mega"] = 21, ["Mega|Ride"] = 192.32, ["Mega|Fly|Ride"] = 534.06}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.94, ["Ride"] = 35.39, ["Fly|Ride"] = 64.16, ["Neon"] = 3.08, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 71.65, ["Mega"] = 16.75, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 143.69}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 16.04, ["Fly|Ride"] = 49.25, ["Neon"] = 8.56, ["Neon|Ride"] = 30.09, ["Neon|Fly|Ride"] = 86.02, ["Mega"] = 61.69, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 112.53, ["Neon"] = 24.93, ["Mega"] = 118.09, ["Mega|Ride"] = 106.31, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 38.06, ["Ride"] = 18.17, ["Fly|Ride"] = 36.75, ["Neon"] = 15.94, ["Neon|Fly"] = 213.86, ["Neon|Ride"] = 18.18, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 150.94, ["Mega|Fly|Ride"] = 241.49}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 57.75, ["Ride"] = 101.73, ["Fly|Ride"] = 271.59, ["Neon"] = 210.29, ["Neon|Ride"] = 324.07, ["Neon|Fly|Ride"] = 1069.2, ["Mega"] = 961.8, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1122.93}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 12.84, ["Ride"] = 15.44, ["Fly|Ride"] = 36.43, ["Neon"] = 2.51, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 16.89, ["Neon|Fly|Ride"] = 32.91, ["Mega"] = 19.68, ["Mega|Ride"] = 30.72, ["Mega|Fly|Ride"] = 127.11}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 5.23, ["Fly"] = 53.41, ["Ride"] = 23.33, ["Fly|Ride"] = 68.16, ["Neon"] = 32.81, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 128.31, ["Mega"] = 401.66, ["Mega|Ride"] = 236.8, ["Mega|Fly|Ride"] = 315.07}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 15.52, ["Fly"] = 71.56, ["Ride"] = 36.75, ["Fly|Ride"] = 100.52, ["Neon"] = 131.15, ["Neon|Ride"] = 137.71, ["Neon|Fly|Ride"] = 182.44, ["Mega"] = 787.5, ["Mega|Ride"] = 781.86, ["Mega|Fly|Ride"] = 650.02}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.33, ["Fly"] = 196.88, ["Neon"] = 65.54, ["Neon|Ride"] = 71.65, ["Mega"] = 370.64, ["Mega|Ride"] = 448.28, ["Mega|Fly|Ride"] = 427.25}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.07, ["Fly|Ride"] = 50.27, ["Neon"] = 2.1, ["Neon|Fly"] = 81.38, ["Neon|Ride"] = 21.4, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 48.41, ["Mega|Ride"] = 59.83, ["Mega|Fly|Ride"] = 113.75}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.6, ["Fly"] = 72.19, ["Ride"] = 37.97, ["Neon"] = 24.76, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 205.7, ["Mega"] = 131.24, ["Mega|Fly"] = 735, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 427.25}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 977.82, ["Fly"] = 1403.7, ["Ride"] = 1050, ["Fly|Ride"] = 1107.69, ["Neon|Ride"] = 2744.44, ["Neon|Fly|Ride"] = 2450.33, ["Mega|Fly|Ride"] = 7197.75}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 157.5, ["Ride"] = 199.96, ["Fly|Ride"] = 688.04, ["Neon"] = 641.53, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 855.37, ["Mega"] = 3203.18, ["Mega|Ride"] = 2848.59, ["Mega|Fly|Ride"] = 2742.31}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.24, ["Fly"] = 57.68, ["Ride"] = 39.38, ["Neon"] = 6.23, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 208.51, ["Mega"] = 96.79, ["Mega|Fly|Ride"] = 1139.66}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 78.75, ["Ride"] = 121.02, ["Fly|Ride"] = 157.31, ["Neon"] = 392.41, ["Neon|Fly"] = 446.25, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 635.12, ["Mega"] = 1964.42, ["Mega|Ride"] = 1796.82, ["Mega|Fly|Ride"] = 1665.82}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.1, ["Ride"] = 21.37, ["Fly|Ride"] = 93.03, ["Neon"] = 19.69, ["Neon|Fly"] = 42.78, ["Neon|Ride"] = 52.67, ["Neon|Fly|Ride"] = 285.49, ["Mega"] = 285.2, ["Mega|Ride"] = 483.88, ["Mega|Fly|Ride"] = 413.36}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 236, ["Fly"] = 427.17, ["Ride"] = 273.84, ["Fly|Ride"] = 328.12, ["Neon|Ride"] = 1377.13, ["Neon|Fly|Ride"] = 1296.64, ["Mega|Fly|Ride"] = 4785}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 77.18, ["Ride"] = 41.66, ["Fly|Ride"] = 224.11, ["Neon"] = 31.5, ["Neon|Fly"] = 36.37, ["Neon|Ride"] = 54.37, ["Mega"] = 393.74, ["Mega|Fly"] = 333.25, ["Mega|Ride"] = 645.98}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 42.77, ["Mega"] = 131.25, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 50.21, ["Fly|Ride"] = 153.86, ["Neon"] = 111.61, ["Neon|Ride"] = 124.69, ["Mega"] = 463.76, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.75, ["Neon"] = 31.39, ["Neon|Ride"] = 196.87, ["Mega"] = 241.95, ["Mega|Ride"] = 253.32, ["Mega|Fly|Ride"] = 427.25}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 13.83, ["Fly|Ride"] = 28.88, ["Neon"] = 2.62, ["Neon|Fly"] = 28.85, ["Neon|Ride"] = 22.09, ["Neon|Fly|Ride"] = 34.99, ["Mega"] = 42.74, ["Mega|Ride"] = 180.52, ["Mega|Fly|Ride"] = 100.42}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 5263.13, ["Ride"] = 5130.57, ["Fly|Ride"] = 4588.5, ["Neon"] = 32075.73, ["Neon|Fly|Ride"] = 19293.75, ["Mega|Fly|Ride"] = 161289.01}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 52.29, ["Fly"] = 85.44, ["Ride"] = 56.43, ["Neon"] = 53.43, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 162.33, ["Mega"] = 210, ["Mega|Ride"] = 215.15, ["Mega|Fly|Ride"] = 427.25}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.69, ["Ride"] = 16.91, ["Fly|Ride"] = 41.57, ["Neon"] = 14.44, ["Neon|Fly"] = 45.91, ["Neon|Ride"] = 34.23, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 131.25, ["Mega|Ride"] = 176.06, ["Mega|Fly|Ride"] = 191.21}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 456.8, ["Fly"] = 547.77, ["Ride"] = 534.19, ["Fly|Ride"] = 548.63, ["Neon"] = 2100, ["Neon|Ride"] = 1292.82, ["Neon|Fly|Ride"] = 1274.44, ["Mega|Fly|Ride"] = 6180.99}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 3.83, ["Ride"] = 33.29, ["Neon"] = 19.4, ["Neon|Ride"] = 305.82, ["Mega"] = 140.95, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.85, ["Fly"] = 4271.44, ["Ride"] = 36.74, ["Neon"] = 23.63, ["Neon|Fly"] = 118.7, ["Neon|Ride"] = 46.04, ["Neon|Fly|Ride"] = 315.44, ["Mega"] = 1161.02, ["Mega|Ride"] = 401.63, ["Mega|Fly|Ride"] = 419.35}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Ride"] = 17.63, ["Neon"] = 3.91, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 28.18, ["Neon|Fly|Ride"] = 91.74, ["Mega"] = 39.38, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 275.62}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 708.75, ["Ride"] = 666.37, ["Fly|Ride"] = 775.53, ["Neon|Ride"] = 2126.27, ["Neon|Fly|Ride"] = 2480.62, ["Mega|Fly|Ride"] = 9257.06}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.56, ["Fly"] = 300.11, ["Ride"] = 55.18, ["Fly|Ride"] = 427.69, ["Neon"] = 32.04, ["Neon|Ride"] = 65.54, ["Neon|Fly|Ride"] = 285.49, ["Mega"] = 177.17, ["Mega|Ride"] = 232.32, ["Mega|Fly|Ride"] = 399.48}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 6.57, ["Fly"] = 236.25, ["Ride"] = 33.79, ["Fly|Ride"] = 85.55, ["Neon"] = 27.56, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 144.37, ["Mega"] = 228.59, ["Mega|Fly"] = 806.86, ["Mega|Ride"] = 214.18, ["Mega|Fly|Ride"] = 413.36}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.12, ["Ride"] = 16.95, ["Fly|Ride"] = 51.73, ["Neon"] = 11.46, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 81.37, ["Mega"] = 183.02, ["Mega|Ride"] = 150.94, ["Mega|Fly|Ride"] = 231.72}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 19.69, ["Ride"] = 34.12, ["Fly|Ride"] = 71.65, ["Neon"] = 153.98, ["Neon|Fly|Ride"] = 320.77, ["Mega"] = 853.41, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 1424.83}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 42.88, ["Fly|Ride"] = 85.55, ["Neon"] = 4.87, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 57.69, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 504.16, ["Ride"] = 538.13, ["Fly|Ride"] = 674.67, ["Neon"] = 2589.57, ["Neon|Ride"] = 2604.56, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Ride"] = 9435.38, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Fly"] = 106.8, ["Ride"] = 80.07, ["Neon"] = 13.5, ["Neon|Ride"] = 92.9, ["Mega"] = 89.74, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 33.65, ["Neon"] = 5.23, ["Neon|Fly"] = 106.94, ["Neon|Ride"] = 42.78, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 89.54, ["Mega|Fly|Ride"] = 283.49}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 40.82, ["Neon"] = 3.93, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 143.29, ["Mega"] = 45.94, ["Mega|Fly"] = 158.09, ["Mega|Ride"] = 106.73, ["Mega|Fly|Ride"] = 145.68}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 28.65, ["Neon"] = 13.01, ["Mega"] = 213.63, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 19.69, ["Fly"] = 64.32, ["Ride"] = 52.5, ["Fly|Ride"] = 101.35, ["Neon"] = 122.06, ["Neon|Ride"] = 139.13, ["Neon|Fly|Ride"] = 281.48, ["Mega"] = 604.85, ["Mega|Ride"] = 514.54, ["Mega|Fly|Ride"] = 556.5}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 18.37, ["Ride"] = 68.25, ["Fly|Ride"] = 89.82, ["Neon"] = 84, ["Neon|Ride"] = 145.37, ["Neon|Fly|Ride"] = 285.49, ["Mega"] = 381.94, ["Mega|Ride"] = 441.13, ["Mega|Fly|Ride"] = 560.81}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 3.94, ["Fly"] = 32.96, ["Ride"] = 17.93, ["Fly|Ride"] = 34.13, ["Neon"] = 18, ["Neon|Fly"] = 57.75, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 88.76, ["Mega"] = 236.07, ["Mega|Ride"] = 285.2, ["Mega|Fly|Ride"] = 255.29}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 7.63, ["Ride"] = 105.29, ["Neon"] = 28.93, ["Neon|Ride"] = 195.57, ["Mega|Ride"] = 410.82}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 24.22, ["Fly|Ride"] = 87.05, ["Neon"] = 10.5, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 59.89, ["Neon|Fly|Ride"] = 114.42, ["Mega"] = 81.27, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 241.95}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 23.63, ["Fly"] = 113.75, ["Ride"] = 24.22, ["Fly|Ride"] = 63, ["Neon"] = 10691.91, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 192.29, ["Mega"] = 787.5, ["Mega|Fly|Ride"] = 829.5}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 32.44, ["Fly"] = 874.13, ["Neon"] = 133.88, ["Mega"] = 328.12, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 470.54}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 48.55, ["Fly"] = 153.58, ["Ride"] = 85.2, ["Fly|Ride"] = 124.69, ["Neon"] = 363.57, ["Neon|Ride"] = 347.82, ["Neon|Fly|Ride"] = 143.29, ["Mega|Ride"] = 1710.49, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 35.58, ["Fly"] = 85.44, ["Ride"] = 108.92, ["Fly|Ride"] = 212.79, ["Neon"] = 144.37, ["Neon|Ride"] = 209.57, ["Neon|Fly|Ride"] = 315, ["Mega"] = 598.15, ["Mega|Ride"] = 704.94, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 20.49, ["Ride"] = 64.32, ["Neon"] = 114.27, ["Mega"] = 1049.99, ["Mega|Ride"] = 712.42, ["Mega|Fly|Ride"] = 807.19}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 19.04, ["Fly"] = 427.17, ["Ride"] = 50.4, ["Fly|Ride"] = 208.51, ["Neon"] = 132.29, ["Neon|Fly"] = 420, ["Neon|Ride"] = 189, ["Neon|Fly|Ride"] = 315, ["Mega"] = 419.91, ["Mega|Ride"] = 559.84, ["Mega|Fly|Ride"] = 640.69}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.91, ["Ride"] = 15.75, ["Fly|Ride"] = 32.74, ["Neon"] = 5.24, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 29.13, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 356.75, ["Mega|Fly"] = 336.46, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 866.23}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 44.12, ["Ride"] = 97.12, ["Fly|Ride"] = 260.39, ["Neon"] = 346.87, ["Neon|Ride"] = 371.02, ["Neon|Fly|Ride"] = 555.99, ["Mega"] = 1129.85, ["Mega|Ride"] = 1514.56, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 79.74, ["Neon"] = 3.88, ["Neon|Ride"] = 43.19, ["Neon|Fly|Ride"] = 299.38, ["Mega"] = 31.4, ["Mega|Ride"] = 84.94}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 30.19, ["Ride"] = 114.28, ["Fly|Ride"] = 162.33, ["Neon"] = 130.46, ["Neon|Ride"] = 133.95, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 525, ["Mega|Ride"] = 806.86, ["Mega|Fly|Ride"] = 686.82}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Mega"] = 26.24}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.23, ["Mega"] = 40.61, ["Mega|Ride"] = 153.05}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 103.58, ["Fly"] = 223.13, ["Ride"] = 143.07, ["Fly|Ride"] = 354.13, ["Neon"] = 562.07, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 656.25, ["Mega|Ride"] = 6653.15, ["Mega|Fly|Ride"] = 2001.46}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 27.69, ["Fly|Ride"] = 133.88, ["Neon"] = 6.45, ["Neon|Ride"] = 25.12, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 90.17, ["Mega|Ride"] = 116.82, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Fly|Ride"] = 50.93, ["Neon"] = 4.87, ["Neon|Ride"] = 25.68, ["Neon|Fly|Ride"] = 143.29, ["Mega"] = 35.44, ["Mega|Ride"] = 128.19, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.22, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 207.9, ["Mega"] = 76.13, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 256.35}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 82.69, ["Neon"] = 6.26, ["Neon|Ride"] = 156.19, ["Mega"] = 71.58, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 64.22, ["Ride"] = 106.8, ["Fly|Ride"] = 457.63, ["Neon"] = 437.07, ["Neon|Ride"] = 570.96, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2065.68, ["Mega|Ride"] = 1602.14, ["Mega|Fly|Ride"] = 1566.89}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.2, ["Ride"] = 60.97, ["Neon"] = 39.38, ["Neon|Ride"] = 227.06, ["Mega"] = 413.86, ["Mega|Ride"] = 967.75}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 1.79}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 1.79}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 380.63, ["Ride"] = 384.38, ["Fly|Ride"] = 780.1, ["Neon"] = 1365, ["Neon|Ride"] = 1069.2, ["Neon|Fly|Ride"] = 1076.25, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 1.79}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 84}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 50.57}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 15.22}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 15.74}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 143.09}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 43.32}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 14.99}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 7.58}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 262.5}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 26.25}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 1.79}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 24.69}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 7.88}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 6.26}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 577.49}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 5.24}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 6.44}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 7.77}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 42.73}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 12.45}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 564.38}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 1.79}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.63}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 1.79}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 589.89}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 15.98}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1246.88}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 3.94}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 9.19}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.63}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 33.34}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.37}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 24.54}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 34.11}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 39.38}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 16.92}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 11.82}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 18.26}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 5.25}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 18.26}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.48}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 3.78}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 24.88}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 147.38}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 3.76}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 5.01}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 1.79}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 2672.25}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 1.79}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 31.64}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 307.93}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 8.15}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.63}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 9.39}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 7.88}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 213.94}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 7.63}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 6.57}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.63}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 1181.25}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 32.37}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 6.57}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 1.84}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 59.07}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 18.09}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 111.57}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 85.32}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 8.8}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 22.23}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 8.97}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 6.42}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 52.5}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.63}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 91.88}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 228.38}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 8.16}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 323.1}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.93}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 75.28}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 21}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 1.79}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 23049.32}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 323.57}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 78.75}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 162.17}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 89.56}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 26.25}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 21.18}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 39.38}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 82.19}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 81.3}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 92.92}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 56.83}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 170.22}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 45.94}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 44.63}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 12.51}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 6.46}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 23.5}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 42.07}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 118.34}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 3.61}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 9.09}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 1.79}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 2.63}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 13.83}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 270.13}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 1.79}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 997.5}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 6.09}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 583.68}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 10.87}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.63}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.63}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 231}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 1.79}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 26.99}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 115.5}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 21}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 24.91}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 51.76}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 14.22}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.94}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 13.13}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.94}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 4.77}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 30.19}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.75}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 1.79}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.63}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.94}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 52.41}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 276.94}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 52.5}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 1.79}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 1.79}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 4.86}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 323.1}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 12.89}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 9.39}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 7.23}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 37.97}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 21}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.63}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 8.7}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 12.5}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 15.23}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 21.59}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 21.94}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 4.8}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 7.11}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 6.56}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 7.87}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 1.79}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 1.79}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 6.25}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 6.85}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 3.71}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.68}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 4.03}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 1.79}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 2.82}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 8019.81}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.62}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 23.88}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.97}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 8.59}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 6.44}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.26}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 26.25}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 1.79}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 22.32}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 3.66}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.72}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 1.79}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 5.06}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 1.79}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 1.79}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 34.13}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 1.79}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 12.99}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.84}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 6.57}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.82}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 1.79}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 4.86}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 1.79}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4477.25}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 8.56}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 1.79}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 27.2}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 6.42}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 1.79}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.45}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 70.61}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 5.03}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 100.82}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 1.79}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 1.79}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 15.26}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.69}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 3.59}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 2.63}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 8}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 16.94}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.14}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.67}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 1.79}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 9.19}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 1.79}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 7.64}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.62}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.89}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 1.79}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.81}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.41}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 6.44}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 28.88}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 10.1}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 256.53}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.67}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 67.59}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 4.66}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 1.79}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1165.5}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 1.79}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 52.8}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.63}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 5.23}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 1.79}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 23.44}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 27.45}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.05}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 6.65}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 7.27}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 14.1}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 15.74}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 15.63}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.63}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 7.23}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.92}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 13.02}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 4.35}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 1.79}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 22.68}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 2.63}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 3.94}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 3.61}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 20.31}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 56.33}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.63}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 3.9}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 6.57}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 37.95}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 90.56}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 8.07}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 5.24}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 3.94}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 81.25}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 34.13}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 4.71}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 5.13}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 5.14}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 1.79}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 1.79}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 6.48}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 75.51}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 3.94}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.63}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 152.06}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 8.54}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1449.68}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 4.43}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 203.98}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 4.44}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 10.69}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 58.38}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 6.42}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 5.97}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.57}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.62}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 52.5}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 19.69}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 10.6}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 3.83}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.67}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.63}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 8.49}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 105}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 3.83}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 62.91}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.43}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 28.22}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 137.82}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 6.55}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 3.44}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 1.79}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 80.85}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 6.77}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 1.79}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 48.48}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 59.16}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 53.59}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 187.69}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.68}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 57.39}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 3.08}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 146.73}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.73}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 9.35}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 17.97}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 57.75}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.94}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 61.68}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.82}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 7.07}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 92.99}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 18.44}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 65.52}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 33.94}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 11.71}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 55.44}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 53.68}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 13.11}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.94}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 20.89}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 2.6}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 15.73}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 68.09}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 1.79}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 3.84}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 1.79}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 35.6}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 143.11}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1994.99}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 11.79}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 9.21}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 24.94}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 341.25}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 26.17}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 8.86}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 1.79}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 33.18}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 16.04}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 6.33}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 293.22}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 52.49}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 42.84}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 4.43}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 82.34}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 183.3}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 76.79}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 918.75}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 152.8}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 8.48}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2361.19}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 551.23}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 3.93}},
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