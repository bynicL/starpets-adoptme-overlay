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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 812.75, ["Fly"] = 1124.4, ["Ride"] = 1026.4, ["Fly|Ride"] = 857.79, ["Neon"] = 6526.97, ["Neon|Ride"] = 4500.88, ["Neon|Fly|Ride"] = 3441.85}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 430.47, ["Fly"] = 505.76, ["Ride"] = 472.5, ["Fly|Ride"] = 541.38, ["Neon|Fly|Ride"] = 2361.19, ["Mega|Fly|Ride"] = 8295.97}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 5419.32, ["Fly"] = 5982.67, ["Ride"] = 4659.38, ["Fly|Ride"] = 4807.68, ["Neon"] = 25993.68, ["Neon|Fly|Ride"] = 29163.28, ["Mega|Fly|Ride"] = 73101.11}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 136.5, ["Ride"] = 156.19, ["Fly|Ride"] = 297.23, ["Neon"] = 972.65, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 947.23, ["Mega"] = 3518.65, ["Mega|Fly|Ride"] = 6222.13}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 523.69, ["Ride"] = 509.25, ["Fly|Ride"] = 538.13, ["Neon|Fly|Ride"] = 1719.38, ["Mega|Fly|Ride"] = 7267.29}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 9.98, ["Ride"] = 145.68, ["Fly|Ride"] = 112.76, ["Neon"] = 45.39, ["Neon|Ride"] = 99.17, ["Neon|Fly|Ride"] = 264.81, ["Mega"] = 262.5, ["Mega|Ride"] = 492.73, ["Mega|Fly|Ride"] = 409.5}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 5.25, ["Fly"] = 31.48, ["Ride"] = 21.09, ["Fly|Ride"] = 60.38, ["Neon"] = 21.09, ["Neon|Fly"] = 64.32, ["Neon|Ride"] = 40.09, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 128.72, ["Mega|Fly"] = 303.19, ["Mega|Ride"] = 179.81, ["Mega|Fly|Ride"] = 183.6}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 130.69, ["Fly"] = 110.73, ["Ride"] = 282.19, ["Fly|Ride"] = 251.37, ["Neon"] = 521.63, ["Neon|Ride"] = 563.29, ["Neon|Fly|Ride"] = 626.07, ["Mega"] = 1866.42, ["Mega|Ride"] = 1899.13, ["Mega|Fly|Ride"] = 1686.01}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 33.43, ["Fly"] = 62.39, ["Ride"] = 45.94, ["Fly|Ride"] = 89.25, ["Neon"] = 301.88, ["Neon|Ride"] = 183.43, ["Neon|Fly|Ride"] = 230.19, ["Mega"] = 2100, ["Mega|Ride"] = 690.02, ["Mega|Fly|Ride"] = 716.25}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 23.05, ["Fly"] = 42.16, ["Ride"] = 32.82, ["Fly|Ride"] = 62.95, ["Neon"] = 278.21, ["Neon|Ride"] = 103.39, ["Neon|Fly|Ride"] = 182.57, ["Mega|Ride"] = 484.29, ["Mega|Fly|Ride"] = 465.29}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 52.47, ["Ride"] = 53.75, ["Fly|Ride"] = 148.03, ["Neon|Fly"] = 210.77, ["Neon|Ride"] = 208.87, ["Neon|Fly|Ride"] = 305.53, ["Mega|Ride"] = 1052.98, ["Mega|Fly|Ride"] = 1034.25}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 61.69}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 380.63, ["Fly"] = 440.49, ["Ride"] = 354.38, ["Fly|Ride"] = 368.82, ["Neon"] = 1260.57, ["Neon|Ride"] = 1238.36, ["Neon|Fly|Ride"] = 1201.44, ["Mega|Fly|Ride"] = 3777.04}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 116.54, ["Fly"] = 134.9, ["Ride"] = 114.19, ["Fly|Ride"] = 136.5, ["Neon"] = 1405.76, ["Neon|Fly|Ride"] = 540.75, ["Mega|Fly|Ride"] = 2333.02}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.1, ["Fly"] = 32.68, ["Ride"] = 56.91, ["Fly|Ride"] = 65.63, ["Neon"] = 16.65, ["Neon|Ride"] = 67.15, ["Mega"] = 117.12, ["Mega|Ride"] = 172.66, ["Mega|Fly|Ride"] = 386.13}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 105, ["Fly"] = 124.69, ["Ride"] = 110.97, ["Fly|Ride"] = 168.62, ["Neon"] = 618.59, ["Neon|Ride"] = 630.13, ["Neon|Fly|Ride"] = 542.07, ["Mega"] = 2110.14, ["Mega|Fly|Ride"] = 1967.44}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.1, ["Fly"] = 23.63, ["Ride"] = 22.44, ["Fly|Ride"] = 58.99, ["Neon"] = 21.09, ["Neon|Fly"] = 105.39, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 91.86, ["Mega"] = 223.69, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 38.06, ["Ride"] = 56.91, ["Fly|Ride"] = 132.88, ["Neon"] = 139.12, ["Neon|Ride"] = 152.92, ["Neon|Fly|Ride"] = 209.92, ["Mega"] = 696.56, ["Mega|Ride"] = 681.07, ["Mega|Fly|Ride"] = 679.38}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 44.3}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 49.88, ["Fly"] = 70.63, ["Ride"] = 125.42, ["Neon"] = 279.57, ["Neon|Ride"] = 349.98, ["Mega"] = 2954.19, ["Mega|Fly|Ride"] = 3111.07}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 11.4, ["Fly"] = 39.88, ["Ride"] = 32.02, ["Fly|Ride"] = 141.23, ["Neon"] = 59.07, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 258.27, ["Mega"] = 2682.96, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 653.25}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 36.74, ["Fly"] = 99.75, ["Ride"] = 45.94, ["Fly|Ride"] = 78.75, ["Neon"] = 387.81, ["Neon|Ride"] = 203.23, ["Neon|Fly|Ride"] = 254.63, ["Mega"] = 1681.32, ["Mega|Fly|Ride"] = 910.53}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 62.11, ["Ride"] = 155.76, ["Fly|Ride"] = 196.88, ["Neon"] = 209.93, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 339.94, ["Mega"] = 1680.53, ["Mega|Ride"] = 1252.38, ["Mega|Fly|Ride"] = 1210.18}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 30.19, ["Ride"] = 45.94, ["Fly|Ride"] = 133.22, ["Neon"] = 171.77, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 408.19, ["Mega"] = 703.74, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 51.19, ["Fly"] = 75.89, ["Ride"] = 56.44, ["Fly|Ride"] = 99.07, ["Neon"] = 252.92, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 307.97, ["Mega|Ride"] = 2493.75, ["Mega|Fly|Ride"] = 941.13}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 4.24, ["Fly"] = 28.32, ["Ride"] = 18.31, ["Fly|Ride"] = 42.16, ["Neon"] = 27.88, ["Neon|Fly"] = 44.63, ["Neon|Ride"] = 52.69, ["Neon|Fly|Ride"] = 80.83, ["Mega"] = 126.6, ["Mega|Fly"] = 422.04, ["Mega|Ride"] = 161.39, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 292.04, ["Ride"] = 322.88, ["Fly|Ride"] = 357.82, ["Neon|Ride"] = 1476.75, ["Neon|Fly|Ride"] = 1416.19, ["Mega"] = 10550.64, ["Mega|Fly|Ride"] = 5444.08}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 32.82, ["Ride"] = 45.32, ["Fly|Ride"] = 49.54, ["Neon"] = 239.23, ["Neon|Ride"] = 210.97, ["Mega"] = 830.34, ["Mega|Fly|Ride"] = 742.77}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 4.81, ["Fly"] = 32.81, ["Ride"] = 19.69, ["Fly|Ride"] = 41.68, ["Neon"] = 41.11, ["Neon|Fly"] = 89.25, ["Neon|Ride"] = 64.93, ["Neon|Fly|Ride"] = 105.5, ["Mega"] = 352.41, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 422.04}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 95.82, ["Fly"] = 5250, ["Ride"] = 102.38, ["Fly|Ride"] = 141.23, ["Neon"] = 280.35, ["Neon|Fly"] = 421.53, ["Neon|Ride"] = 277.44, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 6181.3, ["Mega|Ride"] = 3111.07, ["Mega|Fly|Ride"] = 2038.4}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 17.05, ["Ride"] = 31.63, ["Fly|Ride"] = 115.5, ["Neon"] = 151.54, ["Neon|Ride"] = 141.36, ["Neon|Fly|Ride"] = 207.38, ["Mega"] = 700.58}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 203.44, ["Ride"] = 226.09, ["Fly|Ride"] = 292.6, ["Neon"] = 702.89, ["Neon|Ride"] = 746.6, ["Neon|Fly|Ride"] = 828.19, ["Mega"] = 6330.39, ["Mega|Fly|Ride"] = 2474.09}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 25.97}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.94, ["Fly"] = 31.39, ["Ride"] = 31.49, ["Fly|Ride"] = 62.19, ["Neon"] = 13.13, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 42.21, ["Neon|Fly|Ride"] = 105.52, ["Mega"] = 158.82, ["Mega|Fly"] = 225.8, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 279.98}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 496.31, ["Ride"] = 561.75, ["Fly|Ride"] = 577.5, ["Neon"] = 3063.37, ["Neon|Ride"] = 3057.9, ["Neon|Fly|Ride"] = 2532.16, ["Mega|Ride"] = 52492.54, ["Mega|Fly|Ride"] = 9847.97}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 10.5, ["Fly"] = 45.46, ["Ride"] = 28.84, ["Fly|Ride"] = 71.61, ["Neon"] = 48.49, ["Neon|Fly"] = 141.23, ["Neon|Ride"] = 102.1, ["Neon|Fly|Ride"] = 176.17, ["Mega"] = 526.32, ["Mega|Ride"] = 601.4, ["Mega|Fly|Ride"] = 664.54}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 111.39, ["Ride"] = 141.23, ["Fly|Ride"] = 157.5, ["Neon"] = 618.59, ["Neon|Ride"] = 514.5, ["Neon|Fly|Ride"] = 619.19, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 2798.45}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 41.22}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 31.49, ["Ride"] = 66.4, ["Fly|Ride"] = 262.5, ["Neon"] = 157.5, ["Neon|Ride"] = 246.84, ["Neon|Fly|Ride"] = 273.74, ["Mega"] = 674.25, ["Mega|Ride"] = 622.93, ["Mega|Fly|Ride"] = 633.05}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["Ride"] = 188.77, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 611.94, ["Mega|Fly|Ride"] = 2320.1}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 131.23, ["Ride"] = 129.94, ["Fly|Ride"] = 196.88, ["Neon"] = 466.23, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 464.63, ["Mega"] = 2390.79, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1468.69}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 56.44}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 59.27, ["Fly"] = 77.64, ["Ride"] = 53.82, ["Fly|Ride"] = 90.64, ["Neon|Ride"] = 281.65, ["Neon|Fly|Ride"] = 326.82, ["Mega"] = 4220.27, ["Mega|Fly|Ride"] = 1258.69}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 4.24, ["Ride"] = 36.75, ["Fly|Ride"] = 131.25, ["Neon"] = 35.85, ["Neon|Ride"] = 141.36, ["Neon|Fly|Ride"] = 225.74, ["Mega"] = 176.21, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 253.23, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 303.19, ["Fly"] = 421.53, ["Ride"] = 309.75, ["Fly|Ride"] = 353.07, ["Neon|Ride"] = 1970.39, ["Neon|Fly|Ride"] = 1220.63, ["Mega|Fly|Ride"] = 4822.33}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 67.99, ["Fly"] = 99.75, ["Ride"] = 76.13, ["Fly|Ride"] = 147, ["Neon"] = 262.5, ["Neon|Fly"] = 300.72, ["Neon|Ride"] = 280.6, ["Neon|Fly|Ride"] = 394.51, ["Mega|Fly|Ride"] = 1449.68}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3581.83, ["Fly"] = 3793.63, ["Ride"] = 3018.75, ["Fly|Ride"] = 3412.5, ["Neon|Fly|Ride"] = 13711.45}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 31.97, ["Fly"] = 56.91, ["Ride"] = 42.14, ["Fly|Ride"] = 110.25, ["Neon"] = 324.63, ["Neon|Ride"] = 278.25, ["Neon|Fly|Ride"] = 280.14, ["Mega"] = 1899.13, ["Mega|Ride"] = 1899.13, ["Mega|Fly|Ride"] = 1336.78}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 65.63, ["Ride"] = 41.96, ["Fly|Ride"] = 131.25, ["Neon"] = 372.99, ["Neon|Ride"] = 269.49, ["Neon|Fly|Ride"] = 534.8, ["Mega"] = 6330.39, ["Mega|Ride"] = 1866.42, ["Mega|Fly|Ride"] = 1531.97}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 30.19, ["Fly"] = 56.91, ["Ride"] = 39.38, ["Fly|Ride"] = 104.81, ["Neon"] = 123.44, ["Neon|Fly"] = 273, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 203.41, ["Mega"] = 2598.75, ["Mega|Fly|Ride"] = 627.38}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 11.58}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 63, ["Ride"] = 59.07, ["Fly|Ride"] = 105, ["Neon"] = 442.61, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 504.33, ["Mega|Fly|Ride"] = 1711.26}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 34.78}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 227.07, ["Ride"] = 203.44, ["Fly|Ride"] = 341.25, ["Neon|Fly|Ride"] = 2109.63}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 656.25, ["Ride"] = 616.88, ["Fly|Ride"] = 643.13, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2100, ["Mega|Fly|Ride"] = 11760}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 19.69}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 29.93, ["Fly"] = 52.48, ["Ride"] = 32.82, ["Fly|Ride"] = 77.86, ["Neon"] = 267.68, ["Neon|Fly"] = 210.77, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 179.66, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 10.5}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 4987.5, ["Fly"] = 5248.69, ["Fly|Ride"] = 4200, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 40655.81}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 8.58, ["Ride"] = 23.63, ["Fly|Ride"] = 74.84, ["Neon"] = 72.19, ["Neon|Ride"] = 107.63, ["Neon|Fly|Ride"] = 198.53, ["Mega"] = 392.49, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 13.13, ["Fly"] = 79.05, ["Ride"] = 35.85, ["Fly|Ride"] = 114.22, ["Neon"] = 141.23, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 703.74, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 86.63, ["Fly"] = 99.07, ["Ride"] = 75.55, ["Fly|Ride"] = 187.69, ["Neon|Fly|Ride"] = 576.99}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 17.07, ["Ride"] = 36.75, ["Fly|Ride"] = 139.65, ["Neon"] = 61.14, ["Neon|Ride"] = 281.65, ["Neon|Fly|Ride"] = 308.02, ["Mega"] = 1125.76, ["Mega|Ride"] = 843.02, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 2950.61, ["Fly"] = 2310, ["Ride"] = 2782, ["Fly|Ride"] = 2100, ["Neon|Fly|Ride"] = 3953.25, ["Mega|Fly|Ride"] = 11892.57}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 29365.62, ["Fly"] = 26250, ["Ride"] = 24806.25, ["Fly|Ride"] = 26249.99, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 70180.52, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 196945.42}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 22.99, ["Fly"] = 393.75, ["Ride"] = 39.35, ["Fly|Ride"] = 91.69, ["Neon"] = 236.25, ["Neon|Ride"] = 178.38, ["Neon|Fly|Ride"] = 422.04, ["Mega"] = 1470, ["Mega|Ride"] = 738.56, ["Mega|Fly|Ride"] = 948.49}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.37, ["Ride"] = 28.47, ["Fly|Ride"] = 105.16, ["Neon"] = 15.73, ["Neon|Fly"] = 129.34, ["Neon|Ride"] = 35.88, ["Neon|Fly|Ride"] = 119.44, ["Mega"] = 105, ["Mega|Ride"] = 176.73, ["Mega|Fly|Ride"] = 245.44}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 31.63}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 4.24, ["Ride"] = 40.06, ["Fly|Ride"] = 281.38, ["Neon"] = 42.41, ["Neon|Ride"] = 124.36, ["Neon|Fly|Ride"] = 463.32, ["Mega"] = 183.74, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 708.75, ["Fly"] = 839.03, ["Ride"] = 682.5, ["Fly|Ride"] = 778.32, ["Neon|Ride"] = 2784.53, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 11254.37, ["Mega|Fly|Ride"] = 10832.35}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 910.88, ["Ride"] = 931.88, ["Fly|Ride"] = 1046.07, ["Neon|Ride"] = 3086.37, ["Neon|Fly|Ride"] = 3890.39, ["Mega|Fly|Ride"] = 14068.22}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 23.55, ["Fly"] = 56.91, ["Ride"] = 39.38, ["Fly|Ride"] = 84, ["Neon"] = 186.5, ["Neon|Ride"] = 156.33, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 679.48}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 32.82}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 79.05, ["Fly"] = 109.55, ["Ride"] = 75.32, ["Fly|Ride"] = 105, ["Neon|Ride"] = 375.38, ["Neon|Fly|Ride"] = 380.63, ["Mega|Fly|Ride"] = 1539.8}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 77.79, ["Fly"] = 131.25, ["Ride"] = 118.13, ["Fly|Ride"] = 170.63, ["Neon"] = 441, ["Neon|Ride"] = 562.74, ["Neon|Fly|Ride"] = 15554.54, ["Mega"] = 2126.19, ["Mega|Ride"] = 1688.12, ["Mega|Fly|Ride"] = 1439.12}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 2.63, ["Fly"] = 45.46, ["Ride"] = 20.97, ["Fly|Ride"] = 54.38, ["Neon"] = 28.47, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 281.72, ["Mega|Fly|Ride"] = 376.69}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 82.83, ["Fly"] = 93.18, ["Ride"] = 84, ["Fly|Ride"] = 144.38, ["Neon"] = 1124.4, ["Neon|Ride"] = 362.25, ["Neon|Fly|Ride"] = 283.5, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.94, ["Ride"] = 31.49, ["Fly|Ride"] = 262.5, ["Neon"] = 17.5, ["Neon|Fly"] = 267.68, ["Neon|Ride"] = 91.59, ["Neon|Fly|Ride"] = 563.29, ["Mega"] = 98.44, ["Mega|Fly"] = 1125.76, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 833.26}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 15.53, ["Fly"] = 61.14, ["Ride"] = 31.49, ["Fly|Ride"] = 65.63, ["Neon"] = 34.98, ["Neon|Ride"] = 111.55, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 619.34}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 26.25, ["Ride"] = 291.38, ["Fly|Ride"] = 274, ["Neon"] = 133.88, ["Neon|Ride"] = 345.31, ["Neon|Fly|Ride"] = 131.25, ["Mega|Fly|Ride"] = 728.15}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 18.38, ["Fly"] = 85.72, ["Ride"] = 28.47, ["Fly|Ride"] = 80.1, ["Neon"] = 96.26, ["Neon|Ride"] = 170.33, ["Neon|Fly|Ride"] = 141.36, ["Mega"] = 633.05, ["Mega|Ride"] = 914.75, ["Mega|Fly|Ride"] = 914.75}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6991.82, ["Fly"] = 5479.68, ["Ride"] = 4790.63, ["Fly|Ride"] = 4918.03, ["Neon"] = 30912.73, ["Neon|Fly|Ride"] = 26250}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 189, ["Fly"] = 243.44, ["Ride"] = 240.19, ["Fly|Ride"] = 259.88, ["Neon|Ride"] = 563.29, ["Neon|Fly|Ride"] = 623.44, ["Mega|Fly|Ride"] = 1929.45}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 23.63, ["Fly"] = 78.75, ["Ride"] = 56.65, ["Fly|Ride"] = 109.58, ["Neon"] = 65.63, ["Neon|Fly"] = 109.58, ["Neon|Ride"] = 91.69, ["Neon|Fly|Ride"] = 169.32, ["Mega"] = 301.88, ["Mega|Fly"] = 526.5, ["Mega|Ride"] = 261.98, ["Mega|Fly|Ride"] = 332.07}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.49, ["Fly"] = 40.8, ["Ride"] = 18.98, ["Fly|Ride"] = 65.63, ["Neon"] = 15.75, ["Neon|Ride"] = 52.5, ["Mega"] = 140.44}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 39.64, ["Fly"] = 156.16, ["Ride"] = 62.95, ["Fly|Ride"] = 128.63, ["Neon"] = 103.69, ["Neon|Fly"] = 334.52, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 233.24, ["Mega"] = 419.69, ["Mega|Ride"] = 406.04, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 18571.88, ["Ride"] = 11082.75, ["Fly|Ride"] = 11492.25, ["Neon|Fly|Ride"] = 23625, ["Mega|Fly|Ride"] = 108874.18}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 131.25, ["Ride"] = 196.87, ["Fly|Ride"] = 262.5, ["Neon"] = 2107.58, ["Neon|Fly|Ride"] = 840, ["Mega"] = 4642.3, ["Mega|Fly|Ride"] = 4510.87}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 60.94, ["Fly"] = 459.38, ["Ride"] = 49.59, ["Fly|Ride"] = 92.79, ["Neon|Fly"] = 466.23, ["Neon|Ride"] = 265.83, ["Neon|Fly|Ride"] = 281.65, ["Mega|Fly|Ride"] = 1097.28}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 12.31, ["Ride"] = 24.26, ["Fly|Ride"] = 91.69, ["Neon"] = 65.14, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 134.16, ["Mega"] = 2532.16, ["Mega|Ride"] = 492.19, ["Mega|Fly|Ride"] = 982.28}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 354.38, ["Fly"] = 843.04, ["Ride"] = 400.32, ["Fly|Ride"] = 444.73, ["Neon"] = 1640.63, ["Neon|Ride"] = 1827.97, ["Neon|Fly|Ride"] = 1350.57, ["Mega"] = 5189.77, ["Mega|Fly|Ride"] = 5043.22}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 5.18, ["Ride"] = 33.73, ["Fly|Ride"] = 93.26, ["Neon"] = 18.98, ["Neon|Ride"] = 101.5, ["Neon|Fly|Ride"] = 139.12, ["Mega"] = 127.47, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 238.11}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 129.94, ["Fly"] = 157.2, ["Ride"] = 131.25, ["Fly|Ride"] = 179.82, ["Neon"] = 433.13, ["Neon|Ride"] = 360.94, ["Neon|Fly|Ride"] = 426.57, ["Mega"] = 1574.99, ["Mega|Fly|Ride"] = 1808.63}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 14, ["Fly"] = 17.42, ["Ride"] = 15.73, ["Fly|Ride"] = 40.08, ["Neon|Fly"] = 141.23, ["Neon|Ride"] = 102.08, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 2532.16, ["Mega|Fly|Ride"] = 563.41}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 7.88}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 64.32, ["Ride"] = 105.39, ["Fly|Ride"] = 525, ["Neon"] = 393.75, ["Neon|Fly"] = 1686.06, ["Neon|Ride"] = 369.21, ["Neon|Fly|Ride"] = 691.37, ["Mega|Ride"] = 1399.81, ["Mega|Fly|Ride"] = 1539.8}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 13.12, ["Ride"] = 30.19, ["Fly|Ride"] = 77.99, ["Neon"] = 84.55, ["Neon|Ride"] = 123.9, ["Neon|Fly|Ride"] = 139.99, ["Mega|Ride"] = 548.65, ["Mega|Fly|Ride"] = 928.39}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 16.42}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 28.88, ["Fly"] = 210, ["Ride"] = 76.13, ["Fly|Ride"] = 278.25, ["Neon"] = 133.88, ["Neon|Ride"] = 105.05, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 695.3, ["Mega|Ride"] = 801.86, ["Mega|Fly|Ride"] = 654.93}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 2.63, ["Ride"] = 24.26, ["Neon"] = 18.83, ["Neon|Ride"] = 138.2, ["Neon|Fly|Ride"] = 321.57, ["Mega"] = 101.01, ["Mega|Ride"] = 259.56, ["Mega|Fly|Ride"] = 400.98}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 15.73, ["Fly"] = 56.91, ["Ride"] = 30.27, ["Fly|Ride"] = 91.87, ["Neon"] = 212.88, ["Neon|Ride"] = 154.88, ["Neon|Fly|Ride"] = 135.03, ["Mega"] = 702.69, ["Mega|Ride"] = 622.93, ["Mega|Fly|Ride"] = 677.37}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 351.99, ["Fly"] = 437.75, ["Ride"] = 351.99, ["Fly|Ride"] = 323.49, ["Neon|Fly|Ride"] = 1610.7, ["Mega|Fly|Ride"] = 8862.54}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 37.74, ["Ride"] = 52.5, ["Fly|Ride"] = 141.23, ["Neon"] = 210.77, ["Neon|Ride"] = 183.73, ["Neon|Fly|Ride"] = 281.65, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 675.26}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 58.8, ["Ride"] = 77.12, ["Neon"] = 210.77, ["Neon|Ride"] = 215.2, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1336.78}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 19.67, ["Fly"] = 73.78, ["Ride"] = 52.06, ["Fly|Ride"] = 78.75, ["Neon"] = 70.63, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 315, ["Mega"] = 622.93, ["Mega|Ride"] = 336, ["Mega|Fly|Ride"] = 466.61}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 11186.9, ["Ride"] = 11089.97, ["Fly|Ride"] = 7035, ["Neon|Fly|Ride"] = 16406.25, ["Mega|Fly|Ride"] = 39372.9}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 2380.25, ["Fly"] = 2563.67, ["Ride"] = 1837.5, ["Fly|Ride"] = 1836.19, ["Neon"] = 7025.59, ["Neon|Ride"] = 5832.67, ["Neon|Fly|Ride"] = 5193.56, ["Mega|Fly|Ride"] = 17420.54}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 328.13, ["Ride"] = 412.53, ["Fly|Ride"] = 375.17, ["Neon"] = 1896.82, ["Neon|Ride"] = 1350.17, ["Neon|Fly|Ride"] = 1378.64, ["Mega"] = 16881.01, ["Mega|Fly|Ride"] = 6330.39}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 14.15, ["Fly"] = 26.25, ["Ride"] = 19.69, ["Fly|Ride"] = 44.6, ["Neon"] = 124.73, ["Neon|Ride"] = 107.61, ["Neon|Fly|Ride"] = 142.41, ["Mega|Fly|Ride"] = 505.83}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 6.29, ["Ride"] = 61.69, ["Fly|Ride"] = 153.57, ["Neon"] = 23.63, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 233.33, ["Mega"] = 118.13, ["Mega|Ride"] = 209.73, ["Mega|Fly|Ride"] = 320.76}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 39.35, ["Fly"] = 36.14, ["Ride"] = 43.1, ["Fly|Ride"] = 93.19, ["Neon|Fly"] = 139.88, ["Neon|Ride"] = 195.56, ["Neon|Fly|Ride"] = 156.18, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 2.1, ["Fly"] = 25.5, ["Ride"] = 18.38, ["Fly|Ride"] = 40.69, ["Neon"] = 28.47, ["Neon|Fly"] = 58.3, ["Neon|Ride"] = 36.72, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 156.16, ["Mega|Ride"] = 158.28, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 327.52, ["Fly"] = 317.62, ["Ride"] = 282.19, ["Fly|Ride"] = 328.13, ["Neon"] = 1162.05, ["Neon|Ride"] = 1053.77, ["Neon|Fly|Ride"] = 971.25, ["Mega|Fly|Ride"] = 3281.25}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 19.68, ["Fly"] = 56.91, ["Ride"] = 42.16, ["Fly|Ride"] = 70.29, ["Neon"] = 122.26, ["Neon|Fly"] = 466.23, ["Neon|Ride"] = 141.36, ["Neon|Fly|Ride"] = 170.63, ["Mega|Ride"] = 782.86, ["Mega|Fly|Ride"] = 703.74}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 9.19, ["Fly"] = 33.8, ["Ride"] = 24.26, ["Fly|Ride"] = 46.37, ["Neon"] = 62.95, ["Neon|Fly"] = 136.5, ["Neon|Ride"] = 109.68, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 527.55, ["Mega|Ride"] = 581.36, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 421.53, ["Fly"] = 787.5, ["Ride"] = 465.94, ["Fly|Ride"] = 451.07, ["Mega|Fly|Ride"] = 8695.11}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1050, ["Fly"] = 1243.39, ["Ride"] = 1208.11, ["Fly|Ride"] = 1178.89, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 17807.36}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 91.88, ["Fly"] = 107.5, ["Ride"] = 83.27, ["Fly|Ride"] = 105.39, ["Neon"] = 501.62, ["Neon|Ride"] = 414.75, ["Neon|Fly|Ride"] = 461.96, ["Mega|Fly|Ride"] = 1312.49}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 157.38, ["Fly"] = 247.06, ["Ride"] = 195.57, ["Fly|Ride"] = 183.75, ["Neon"] = 689.19, ["Neon|Ride"] = 710.96, ["Neon|Fly|Ride"] = 652.31, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 22.32, ["Ride"] = 56.44, ["Neon"] = 275.23, ["Neon|Ride"] = 280.6, ["Neon|Fly|Ride"] = 844.07, ["Mega|Ride"] = 933.21, ["Mega|Fly|Ride"] = 1038.2}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 141.75, ["Ride"] = 168.62, ["Fly|Ride"] = 597.19, ["Neon"] = 1545.91, ["Neon|Ride"] = 1265.78, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 3009.05}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1534.32, ["Fly"] = 2529.1, ["Ride"] = 1521.19, ["Fly|Ride"] = 1967.44, ["Neon|Fly|Ride"] = 6562.49, ["Mega|Fly|Ride"] = 32040.28}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 65.63, ["Ride"] = 69.56, ["Fly|Ride"] = 263.43, ["Neon"] = 289.8, ["Neon|Ride"] = 281.65, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 1970.87, ["Mega|Ride"] = 2321.16, ["Mega|Fly|Ride"] = 1964.07}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 577.84, ["Fly"] = 675.94, ["Ride"] = 525, ["Fly|Ride"] = 623.44, ["Neon"] = 1405.76, ["Neon|Ride"] = 1464.09, ["Neon|Fly|Ride"] = 1120.87, ["Mega|Fly|Ride"] = 2782.5}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 52.01, ["Fly"] = 59.07, ["Ride"] = 52.49, ["Fly|Ride"] = 101.17, ["Neon"] = 210.77, ["Neon|Ride"] = 513.45, ["Neon|Fly|Ride"] = 194.25, ["Mega|Fly|Ride"] = 843.04}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.4, ["Fly"] = 28.47, ["Ride"] = 19.92, ["Fly|Ride"] = 46.64, ["Neon"] = 23.33, ["Neon|Fly"] = 62.99, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 111.53, ["Mega|Ride"] = 141.4, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 37.37, ["Ride"] = 66.94, ["Fly|Ride"] = 252, ["Neon"] = 702.89, ["Neon|Ride"] = 774.24, ["Mega"] = 1399.81, ["Mega|Fly|Ride"] = 7034.12}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 518.44, ["Fly"] = 899.07, ["Ride"] = 535.5, ["Fly|Ride"] = 525, ["Neon"] = 2331.08, ["Neon|Ride"] = 2239.75, ["Neon|Fly|Ride"] = 1548.75, ["Mega|Fly|Ride"] = 5248.69}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 420, ["Ride"] = 523.68, ["Fly|Ride"] = 459.38, ["Neon"] = 8430.28, ["Neon|Ride"] = 4068.75, ["Neon|Fly|Ride"] = 2441.25, ["Mega|Fly|Ride"] = 17901.27}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 18.98, ["Fly"] = 32.82, ["Ride"] = 25.31, ["Fly|Ride"] = 46.15, ["Neon"] = 141.23, ["Neon|Ride"] = 87.5, ["Neon|Fly|Ride"] = 132.57, ["Mega|Fly|Ride"] = 622.93}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 6.34, ["Ride"] = 19.69, ["Fly|Ride"] = 75.89, ["Neon"] = 70.3, ["Neon|Ride"] = 84.4, ["Neon|Fly|Ride"] = 184.32, ["Mega"] = 462.13, ["Mega|Ride"] = 462.13, ["Mega|Fly|Ride"] = 477.75}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.93, ["Ride"] = 26.25, ["Fly|Ride"] = 91.68, ["Neon"] = 17.04, ["Neon|Fly"] = 109.66, ["Neon|Ride"] = 38.06, ["Neon|Fly|Ride"] = 189, ["Mega"] = 119.24, ["Mega|Fly"] = 224.44, ["Mega|Ride"] = 123.38, ["Mega|Fly|Ride"] = 182.57}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 32.81, ["Fly"] = 56.69, ["Ride"] = 32.81, ["Fly|Ride"] = 108.94, ["Neon"] = 251.77, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 714.82}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 31.48, ["Ride"] = 86.63, ["Fly|Ride"] = 622.4, ["Neon"] = 280.08, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1125.76, ["Mega|Fly|Ride"] = 1245.39}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 16.57, ["Fly"] = 57.11, ["Ride"] = 33.71, ["Fly|Ride"] = 62.95, ["Neon"] = 52.47, ["Neon|Ride"] = 92.93, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 656.25, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 422.04}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 30.19, ["Fly"] = 77.99, ["Ride"] = 33.15, ["Fly|Ride"] = 92.13, ["Neon"] = 349.88, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 210, ["Mega"] = 2100, ["Mega|Ride"] = 1213.17, ["Mega|Fly|Ride"] = 1098.14}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.94, ["Fly"] = 38.07, ["Ride"] = 15.83, ["Fly|Ride"] = 38.96, ["Neon"] = 34.28, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 249.65, ["Mega|Ride"] = 466.61, ["Mega|Fly|Ride"] = 315.48}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.24, ["Fly"] = 59.04, ["Ride"] = 26.92, ["Fly|Ride"] = 1838.22, ["Neon"] = 35.85, ["Neon|Fly"] = 156.2, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 128.61, ["Mega"] = 232.35, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 65.04, ["Fly"] = 60.36, ["Ride"] = 43.32, ["Fly|Ride"] = 78.75, ["Neon"] = 419.43, ["Neon|Ride"] = 232.92, ["Neon|Fly|Ride"] = 216.57, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 2362.5, ["Fly"] = 2486.94, ["Ride"] = 2033.07, ["Fly|Ride"] = 1937.25, ["Neon|Ride"] = 5274.04, ["Neon|Fly|Ride"] = 3924.37, ["Mega|Fly|Ride"] = 14003.07}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 464.03, ["Fly"] = 578.11, ["Ride"] = 414.75, ["Fly|Ride"] = 531.93, ["Neon"] = 3108.48, ["Neon|Ride"] = 3094.82, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 7875}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 299.25, ["Ride"] = 317.63, ["Fly|Ride"] = 393.75, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1687.71, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 41.08}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 26.14, ["Fly"] = 65.63, ["Ride"] = 57.37, ["Fly|Ride"] = 76.13, ["Neon"] = 288.75, ["Neon|Ride"] = 322.11, ["Neon|Fly|Ride"] = 418.98, ["Mega"] = 1159.54, ["Mega|Ride"] = 1477.11, ["Mega|Fly|Ride"] = 1231.13}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 31613.5, ["Fly"] = 20998.69, ["Ride"] = 34781.25, ["Fly|Ride"] = 14698.69, ["Neon|Fly|Ride"] = 36748.69, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 221.82, ["Fly"] = 280.14, ["Ride"] = 216.98, ["Fly|Ride"] = 301.88, ["Neon"] = 576.18, ["Neon|Fly"] = 1097.94, ["Neon|Ride"] = 693.4, ["Neon|Fly|Ride"] = 620.82, ["Mega"] = 3503.89, ["Mega|Ride"] = 2477.3, ["Mega|Fly|Ride"] = 2417.63}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 156.16, ["Ride"] = 174.95, ["Fly|Ride"] = 257.25, ["Neon|Fly|Ride"] = 1711.32, ["Mega|Fly|Ride"] = 2799.62}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 105, ["Ride"] = 103.69, ["Fly|Ride"] = 169.32, ["Neon"] = 564.13, ["Neon|Ride"] = 498.74, ["Neon|Fly|Ride"] = 562.79, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 1578.87}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 14.41, ["Fly"] = 94.5, ["Ride"] = 28.47, ["Fly|Ride"] = 77.99, ["Neon"] = 99.07, ["Neon|Ride"] = 135.19, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 622.93, ["Mega|Ride"] = 601.93, ["Mega|Fly|Ride"] = 563.41}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3215.63, ["Ride"] = 4331.25, ["Fly|Ride"] = 4279.31, ["Neon|Fly|Ride"] = 17062.5}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 24.94, ["Fly"] = 141.23, ["Ride"] = 30.19, ["Fly|Ride"] = 56.43, ["Neon"] = 131.25, ["Neon|Ride"] = 139.99, ["Neon|Fly|Ride"] = 167.99, ["Mega|Fly|Ride"] = 623.44}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 47.25, ["Fly"] = 141.23, ["Ride"] = 45.77, ["Fly|Ride"] = 90.64, ["Neon"] = 138.72, ["Neon|Ride"] = 278.49, ["Neon|Fly|Ride"] = 210.97, ["Mega"] = 982.28, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 536.81, ["Fly"] = 656.25, ["Ride"] = 551.25, ["Fly|Ride"] = 653.62, ["Neon"] = 1666.88, ["Neon|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 1428, ["Mega|Ride"] = 6330.39, ["Mega|Fly|Ride"] = 3890.3}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 15.75, ["Fly"] = 23.63, ["Ride"] = 22.32, ["Fly|Ride"] = 52.5, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 119.64, ["Mega"] = 703.74, ["Mega|Fly|Ride"] = 461.64}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 20.76, ["Ride"] = 139.13, ["Fly|Ride"] = 137.01, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 131.25}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 91.28, ["Ride"] = 124.69, ["Fly|Ride"] = 165.38, ["Neon"] = 577.48, ["Neon|Ride"] = 652.94, ["Neon|Fly|Ride"] = 551.25, ["Mega|Fly|Ride"] = 2954.19}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 22.23, ["Ride"] = 89.7, ["Fly|Ride"] = 141.23, ["Neon"] = 86.63, ["Neon|Fly"] = 124.36, ["Neon|Ride"] = 132.45, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 164.06, ["Mega|Fly"] = 523.69, ["Mega|Ride"] = 241.49, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3766.88, ["Ride"] = 3136.88, ["Fly|Ride"] = 3084.38, ["Neon"] = 12432.71, ["Neon|Ride"] = 17110.68, ["Neon|Fly|Ride"] = 6877.5, ["Mega"] = 63303.78, ["Mega|Fly|Ride"] = 28135.37}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 40.11, ["Fly"] = 210, ["Ride"] = 45.94, ["Fly|Ride"] = 112.76, ["Neon"] = 162.29, ["Neon|Ride"] = 140.76, ["Neon|Fly|Ride"] = 210.97, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7025.59, ["Fly"] = 7875, ["Ride"] = 7804.13, ["Fly|Ride"] = 5775, ["Neon|Fly|Ride"] = 13123.69, ["Mega|Fly|Ride"] = 63234.15}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.1, ["Fly"] = 19.67, ["Ride"] = 15.83, ["Fly|Ride"] = 37.28, ["Neon"] = 21.09, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 40.09, ["Neon|Fly|Ride"] = 84.04, ["Mega"] = 451.44, ["Mega|Ride"] = 211.03, ["Mega|Fly|Ride"] = 218.15}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 15.83, ["Fly"] = 35.44, ["Ride"] = 31.5, ["Fly|Ride"] = 55.78, ["Neon"] = 141.23, ["Neon|Ride"] = 280.35, ["Neon|Fly|Ride"] = 141.36, ["Mega|Ride"] = 1342.05, ["Mega|Fly|Ride"] = 927.94}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 13.83, ["Fly"] = 70.63, ["Ride"] = 26.25, ["Fly|Ride"] = 105, ["Neon"] = 63, ["Neon|Ride"] = 153.57, ["Neon|Fly|Ride"] = 141.36, ["Mega|Ride"] = 633.05, ["Mega|Fly|Ride"] = 748.13}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 42.16, ["Fly"] = 42.16, ["Ride"] = 50.54, ["Fly|Ride"] = 281.38, ["Neon"] = 167.56, ["Neon|Ride"] = 78.11, ["Neon|Fly|Ride"] = 279.25, ["Mega"] = 840, ["Mega|Ride"] = 616.88, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 15.74, ["Fly"] = 30.22, ["Ride"] = 21.08, ["Fly|Ride"] = 40.69, ["Neon"] = 54.81, ["Neon|Ride"] = 97.06, ["Neon|Fly|Ride"] = 135.19, ["Mega"] = 1126.82, ["Mega|Fly|Ride"] = 622.93}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8888.24}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2698.41}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 31.47}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 304.56, ["Fly"] = 421.53, ["Fly|Ride"] = 330.9, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1800.58}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 19.59, ["Fly"] = 132.79, ["Ride"] = 52.5, ["Fly|Ride"] = 109.58, ["Neon"] = 104.99, ["Neon|Ride"] = 262.5, ["Mega"] = 544.78, ["Mega|Ride"] = 563.41, ["Mega|Fly|Ride"] = 555.19}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 10.44}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 7.85, ["Neon"] = 99.07, ["Neon|Ride"] = 249.38}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2572.5}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 141.75, ["Ride"] = 191.13, ["Fly|Ride"] = 10498.95, ["Neon"] = 716.58, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 654.94, ["Mega|Fly|Ride"] = 1956.1}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 98.44, ["Fly"] = 141.23, ["Ride"] = 140.44, ["Fly|Ride"] = 420.19, ["Neon"] = 472.11, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 1797.85, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 1518.25}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 176.82, ["Fly"] = 281.38, ["Ride"] = 170.44, ["Fly|Ride"] = 196.88, ["Neon"] = 808.89, ["Neon|Ride"] = 671.98, ["Neon|Fly|Ride"] = 844.07, ["Mega|Fly|Ride"] = 2933.44}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1069.69, ["Fly"] = 2529.1, ["Ride"] = 1076.25, ["Fly|Ride"] = 1097.97, ["Neon|Fly|Ride"] = 4593.75, ["Mega|Fly|Ride"] = 21101.27}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 18.31, ["Ride"] = 46.37, ["Fly|Ride"] = 86.63, ["Neon"] = 115.5, ["Neon|Ride"] = 141.36, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 933.21, ["Mega|Fly|Ride"] = 793.43}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 582.75, ["Fly"] = 2100, ["Ride"] = 656.25, ["Fly|Ride"] = 656.25, ["Neon|Fly|Ride"] = 4044.28}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 51.19}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 15.65, ["Fly"] = 144.38, ["Ride"] = 40.69, ["Fly|Ride"] = 98.44, ["Neon"] = 60.09, ["Neon|Ride"] = 156.33, ["Neon|Fly|Ride"] = 492.73, ["Mega"] = 393.75, ["Mega|Ride"] = 418.69, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 7.86, ["Fly"] = 349.6, ["Ride"] = 24.94, ["Fly|Ride"] = 91.88, ["Neon"] = 35.85, ["Neon|Ride"] = 99.17, ["Neon|Fly|Ride"] = 202.18, ["Mega|Ride"] = 392.49, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 77.38}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 17.07, ["Ride"] = 39.38, ["Fly|Ride"] = 42.16, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 544.78, ["Mega"] = 817.69, ["Mega|Fly|Ride"] = 560.27}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 28.47, ["Fly"] = 39.38, ["Ride"] = 48.15, ["Fly|Ride"] = 63.25, ["Neon"] = 156.2, ["Neon|Fly"] = 242.45, ["Neon|Ride"] = 264.78, ["Neon|Fly|Ride"] = 274.32, ["Mega"] = 1405.36, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 5712, ["Fly"] = 11240.72, ["Ride"] = 6562.49, ["Fly|Ride"] = 5091.19, ["Neon|Fly|Ride"] = 9711.19, ["Mega|Fly|Ride"] = 28135.37}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 10.48, ["Ride"] = 22.32, ["Fly|Ride"] = 111.71, ["Neon"] = 65.6, ["Neon|Fly"] = 112.76, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 276.94, ["Mega"] = 533.95, ["Mega|Ride"] = 384.57, ["Mega|Fly|Ride"] = 454.65}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 23.61}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 111.56, ["Fly"] = 373.06, ["Ride"] = 112.76, ["Fly|Ride"] = 280.11, ["Neon"] = 417.38, ["Neon|Ride"] = 451.47, ["Neon|Fly|Ride"] = 479.01, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 65.63, ["Fly"] = 183.75, ["Ride"] = 111.57, ["Fly|Ride"] = 236.25, ["Neon"] = 234.44, ["Neon|Ride"] = 380.63, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 1353.16, ["Mega|Fly|Ride"] = 1221.78}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 23.28, ["Fly"] = 70.86, ["Ride"] = 30.74, ["Fly|Ride"] = 80.1, ["Neon"] = 183.37, ["Neon|Ride"] = 182.49, ["Neon|Fly|Ride"] = 160.99, ["Mega|Fly|Ride"] = 485.62}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 4.47, ["Fly"] = 49.07, ["Ride"] = 23.05, ["Fly|Ride"] = 52.49, ["Neon"] = 17.07, ["Neon|Ride"] = 41.76, ["Neon|Fly|Ride"] = 154.92, ["Mega"] = 118.13, ["Mega|Fly"] = 151.66, ["Mega|Ride"] = 177.66, ["Mega|Fly|Ride"] = 278.78}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 12.59, ["Ride"] = 28.33, ["Fly|Ride"] = 76.92, ["Neon"] = 51.85, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 142.14, ["Mega"] = 315, ["Mega|Ride"] = 419.99, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 19.36, ["Fly"] = 23.63, ["Ride"] = 28.88, ["Fly|Ride"] = 45.94, ["Neon"] = 93.17, ["Neon|Ride"] = 188.25, ["Neon|Fly|Ride"] = 105, ["Mega|Fly"] = 703.74, ["Mega|Fly|Ride"] = 585.83}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 195.57}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 16.88, ["Fly"] = 124.71, ["Ride"] = 98.44, ["Neon"] = 84.32, ["Neon|Ride"] = 394.51, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 492.73, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 896.44}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 266.49, ["Ride"] = 360.42, ["Fly|Ride"] = 362.52, ["Neon|Ride"] = 417.38}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 40.06, ["Ride"] = 87.94, ["Fly|Ride"] = 249.19, ["Neon"] = 239.23, ["Neon|Ride"] = 326.03, ["Neon|Fly|Ride"] = 525, ["Mega"] = 1111.69, ["Mega|Ride"] = 1299.38, ["Mega|Fly|Ride"] = 1102.5}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 656.25, ["Fly"] = 780.94, ["Ride"] = 687.75, ["Fly|Ride"] = 643.13, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 2086.88, ["Mega|Fly|Ride"] = 8531.25}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 233.63, ["Ride"] = 261.35, ["Fly|Ride"] = 275.63, ["Neon"] = 1158.12, ["Neon|Fly"] = 3419.68, ["Neon|Ride"] = 1556.17, ["Neon|Fly|Ride"] = 1194.05, ["Mega"] = 8300.19, ["Mega|Ride"] = 4082.77, ["Mega|Fly|Ride"] = 3935.88}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 81.36}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 9.85, ["Fly"] = 23.09, ["Ride"] = 23.63, ["Fly|Ride"] = 48.57, ["Neon"] = 80.07, ["Neon|Ride"] = 78.17, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 405.57}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 288.74, ["Fly"] = 403.24, ["Ride"] = 328.13, ["Fly|Ride"] = 409.5, ["Neon"] = 1475.31, ["Neon|Ride"] = 931.88, ["Neon|Fly|Ride"] = 955.5, ["Mega|Ride"] = 3932.23, ["Mega|Fly|Ride"] = 3890.03}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 16.79}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 90.45, ["Fly"] = 178.12, ["Ride"] = 139.11, ["Fly|Ride"] = 223.13, ["Neon"] = 525, ["Neon|Fly"] = 1405.76, ["Neon|Ride"] = 486.94, ["Neon|Fly|Ride"] = 649.69, ["Mega"] = 2525.83, ["Mega|Ride"] = 2531.11, ["Mega|Fly|Ride"] = 1771.87}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 133.28, ["Ride"] = 118.13, ["Fly|Ride"] = 131.25, ["Neon|Ride"] = 997.5, ["Neon|Fly|Ride"] = 702.47}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 4.93, ["Ride"] = 39.38, ["Fly|Ride"] = 124.73, ["Neon"] = 23.3, ["Neon|Ride"] = 46.43, ["Neon|Fly|Ride"] = 168.78, ["Mega"] = 240.19, ["Mega|Ride"] = 197.07, ["Mega|Fly|Ride"] = 413.6}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 18.87, ["Fly"] = 42, ["Ride"] = 26.91, ["Fly|Ride"] = 76.13, ["Neon"] = 98.62, ["Neon|Ride"] = 99.17, ["Neon|Fly|Ride"] = 197.31, ["Mega|Ride"] = 738.56, ["Mega|Fly|Ride"] = 622.93}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 22.31, ["Fly"] = 141.23, ["Ride"] = 45.94, ["Fly|Ride"] = 144.38, ["Neon"] = 133.85, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 277.44, ["Mega"] = 328.13, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 556.04}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 4.24, ["Fly"] = 337.23, ["Ride"] = 48.23, ["Fly|Ride"] = 105, ["Neon"] = 15.81, ["Neon|Fly"] = 69.56, ["Neon|Ride"] = 56.98, ["Neon|Fly|Ride"] = 149.63, ["Mega"] = 112.22, ["Mega|Fly"] = 183.74, ["Mega|Ride"] = 152.81, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 300.57, ["Fly"] = 351.99, ["Ride"] = 306.99, ["Fly|Ride"] = 402.96, ["Neon|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 1749.95}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 111.71, ["Fly"] = 1050, ["Ride"] = 160.78, ["Fly|Ride"] = 235.41, ["Neon"] = 485.63, ["Neon|Ride"] = 561.75, ["Neon|Fly|Ride"] = 589.32, ["Mega"] = 4356.9, ["Mega|Ride"] = 2532.16, ["Mega|Fly|Ride"] = 2429.83}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 72.19, ["Fly"] = 155.97, ["Ride"] = 78.75, ["Fly|Ride"] = 131.24, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 358.65, ["Mega"] = 1617.95, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 15.75, ["Fly"] = 52.5, ["Ride"] = 55.78, ["Fly|Ride"] = 281.38, ["Neon"] = 210.77, ["Neon|Ride"] = 592.61, ["Neon|Fly|Ride"] = 491.56, ["Mega"] = 422.04, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 24.15, ["Ride"] = 35.85, ["Fly|Ride"] = 102.38, ["Neon"] = 111.57, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 157.33, ["Mega"] = 485.34, ["Mega|Fly"] = 525, ["Mega|Ride"] = 419.93, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 2.1, ["Fly"] = 42.16, ["Ride"] = 27.42, ["Fly|Ride"] = 69.56, ["Neon"] = 15.68, ["Neon|Ride"] = 35.67, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 113.86, ["Mega|Ride"] = 167.41, ["Mega|Fly|Ride"] = 180.74}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 892.5, ["Fly"] = 1123.35, ["Ride"] = 943.69, ["Fly|Ride"] = 943.69, ["Neon"] = 3514.38, ["Neon|Fly"] = 2845.23, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2336.25, ["Mega|Fly|Ride"] = 7245}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 257.25, ["Fly"] = 498.77, ["Ride"] = 275.63, ["Fly|Ride"] = 315, ["Neon"] = 1053.8, ["Neon|Ride"] = 943.69, ["Neon|Fly|Ride"] = 1005.38, ["Mega"] = 10550.64, ["Mega|Ride"] = 5910.68, ["Mega|Fly|Ride"] = 3609.38}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 99.74, ["Ride"] = 132.15, ["Fly|Ride"] = 259.25, ["Neon"] = 383.6, ["Neon|Ride"] = 385.06, ["Neon|Fly|Ride"] = 412.05, ["Mega"] = 1640.63, ["Mega|Ride"] = 1688.12, ["Mega|Fly|Ride"] = 1449.68}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 208.68, ["Ride"] = 183.75, ["Fly|Ride"] = 251.87, ["Neon"] = 702.89, ["Neon|Ride"] = 985.21, ["Neon|Fly|Ride"] = 675.09, ["Mega"] = 10550.64, ["Mega|Fly|Ride"] = 2887.49}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 15.75, ["Fly"] = 48.49, ["Ride"] = 31.49, ["Fly|Ride"] = 65.63, ["Neon"] = 112.76, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 778.08}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 301.88, ["Ride"] = 356.67, ["Fly|Ride"] = 279.74, ["Neon"] = 1338.31, ["Neon|Ride"] = 1361.77, ["Neon|Fly|Ride"] = 1898.67, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 117, ["Fly"] = 126, ["Ride"] = 141.23, ["Fly|Ride"] = 196.87, ["Neon|Ride"] = 466.62, ["Neon|Fly|Ride"] = 419.84, ["Mega|Fly|Ride"] = 1732.5}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1246.88, ["Ride"] = 1391.01, ["Fly|Ride"] = 1443.74, ["Neon|Ride"] = 4078.96, ["Neon|Fly|Ride"] = 3732.91, ["Mega"] = 50643.03, ["Mega|Fly|Ride"] = 23328.86}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 14.41, ["Fly"] = 53.82, ["Ride"] = 26.25, ["Fly|Ride"] = 90.57, ["Neon"] = 39.37, ["Neon|Fly"] = 167.85, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 157.5, ["Mega|Ride"] = 296.75, ["Mega|Fly|Ride"] = 372.75}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 61.51, ["Ride"] = 105.39, ["Fly|Ride"] = 315, ["Neon"] = 264.51, ["Neon|Ride"] = 166.68, ["Neon|Fly|Ride"] = 413.44, ["Mega"] = 1027.7, ["Mega|Fly|Ride"] = 985.44}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 77.31, ["Fly"] = 78.75, ["Ride"] = 73.49, ["Fly|Ride"] = 80.07, ["Neon|Ride"] = 410.82, ["Neon|Fly|Ride"] = 391.12, ["Mega|Fly|Ride"] = 1468.67}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2528.05, ["Ride"] = 958.13, ["Fly|Ride"] = 926.29, ["Neon|Fly|Ride"] = 4199.99, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 323.52, ["Ride"] = 387.81, ["Fly|Ride"] = 405.99, ["Neon|Ride"] = 1687.71, ["Neon|Fly|Ride"] = 1466.19, ["Mega|Fly|Ride"] = 9176.88}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 114.19, ["Fly"] = 210.76, ["Ride"] = 140.59, ["Fly|Ride"] = 196.88, ["Neon"] = 879.38, ["Neon|Ride"] = 429.99, ["Neon|Fly|Ride"] = 525, ["Mega"] = 3962.44, ["Mega|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 1556.13}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.77, ["Fly"] = 70.63, ["Ride"] = 26.94, ["Fly|Ride"] = 87.94, ["Neon"] = 74.34, ["Neon|Ride"] = 62.25, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 641.59, ["Mega|Ride"] = 508.59, ["Mega|Fly|Ride"] = 841.95}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 31.16, ["Fly"] = 70.63, ["Ride"] = 42.16, ["Fly|Ride"] = 78.75, ["Neon"] = 249.38, ["Neon|Fly"] = 295.08, ["Neon|Ride"] = 235.03, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 1825.28, ["Mega|Fly|Ride"] = 1040.3}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 813.75, ["Fly"] = 952.18, ["Ride"] = 787.84, ["Fly|Ride"] = 816.52, ["Neon|Ride"] = 5250, ["Neon|Fly|Ride"] = 2984.34, ["Mega|Fly|Ride"] = 12659.72}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 945}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4173.75, ["Ride"] = 3368.96, ["Fly|Ride"] = 3281.25, ["Neon|Ride"] = 30231.84, ["Neon|Fly|Ride"] = 14437.5, ["Mega|Fly|Ride"] = 90032.75}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 141.23, ["Fly"] = 408.19, ["Ride"] = 168.62, ["Fly|Ride"] = 393.75, ["Neon"] = 611.21, ["Neon|Ride"] = 1244.7, ["Neon|Fly|Ride"] = 851.82, ["Mega"] = 5908.37, ["Mega|Fly|Ride"] = 5486.35}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 77.44, ["Ride"] = 109.55, ["Fly|Ride"] = 336, ["Neon|Ride"] = 493.66, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 1407.47, ["Mega|Fly|Ride"] = 1688.12}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 11.81, ["Fly"] = 131.25, ["Ride"] = 28.29, ["Fly|Ride"] = 74.84, ["Neon"] = 74.84, ["Neon|Ride"] = 84.4, ["Neon|Fly|Ride"] = 195.57, ["Mega"] = 420.98, ["Mega|Ride"] = 844.07, ["Mega|Fly|Ride"] = 472.68}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 19.85, ["Fly"] = 37.41, ["Ride"] = 22.28, ["Fly|Ride"] = 45.94, ["Neon|Fly|Ride"] = 653.63, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 702.69}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 21.09, ["Ride"] = 38.07, ["Fly|Ride"] = 90.57, ["Neon"] = 141.23, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 187.68, ["Mega|Ride"] = 859.69, ["Mega|Fly|Ride"] = 674.43}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 4.23, ["Ride"] = 28.34, ["Fly|Ride"] = 252, ["Neon"] = 49.54, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 166.68, ["Mega"] = 291.64, ["Mega|Ride"] = 337.64, ["Mega|Fly|Ride"] = 357}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 13.13, ["Ride"] = 49.25, ["Fly|Ride"] = 111.57, ["Neon"] = 143.07, ["Neon|Ride"] = 295.36, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 675.26, ["Mega|Ride"] = 560.44, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 248.07, ["Fly"] = 262.5, ["Ride"] = 255.45, ["Fly|Ride"] = 292.69, ["Neon"] = 721.83, ["Neon|Ride"] = 681.19, ["Neon|Fly|Ride"] = 715.32, ["Mega"] = 6562.5, ["Mega|Ride"] = 4220.27, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.1, ["Fly"] = 16.88, ["Ride"] = 18.98, ["Fly|Ride"] = 39.38, ["Neon"] = 20.86, ["Neon|Fly"] = 93.26, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 198.37, ["Mega|Ride"] = 738.94, ["Mega|Fly|Ride"] = 228.9}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 30.1, ["Fly"] = 115.5, ["Ride"] = 47.25, ["Fly|Ride"] = 105, ["Neon"] = 141.75, ["Neon|Fly"] = 208.69, ["Neon|Ride"] = 183.28, ["Neon|Fly|Ride"] = 229.46, ["Mega"] = 511.88, ["Mega|Ride"] = 552.36, ["Mega|Fly|Ride"] = 492.19}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 643.13, ["Fly"] = 787.5, ["Ride"] = 689.07, ["Fly|Ride"] = 703.5, ["Neon|Ride"] = 1970.39, ["Neon|Fly|Ride"] = 1572.38, ["Mega|Fly|Ride"] = 4193.44}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 24.83, ["Fly"] = 59.45, ["Ride"] = 39.38, ["Fly|Ride"] = 60.95, ["Neon"] = 209.72, ["Neon|Fly"] = 466.23, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 187.69, ["Mega"] = 1575, ["Mega|Ride"] = 985.44, ["Mega|Fly|Ride"] = 843.02}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 292, ["Fly"] = 279.69, ["Ride"] = 236.25, ["Fly|Ride"] = 229.69, ["Neon"] = 1405.76, ["Neon|Fly|Ride"] = 951.57, ["Mega|Fly|Ride"] = 4192.83}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 114.19, ["Fly"] = 139.13, ["Ride"] = 122.07, ["Fly|Ride"] = 158.82, ["Neon"] = 632.28, ["Neon|Fly"] = 640.73, ["Neon|Ride"] = 526.36, ["Neon|Fly|Ride"] = 529.61, ["Mega"] = 2954.19, ["Mega|Fly|Ride"] = 1727.99}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 656.25, ["Ride"] = 570.93, ["Fly|Ride"] = 549.94, ["Neon|Ride"] = 2404.98, ["Neon|Fly|Ride"] = 2411.07, ["Mega|Fly|Ride"] = 7807.48}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 15.75, ["Ride"] = 52.5, ["Fly|Ride"] = 94.86, ["Neon"] = 91.62, ["Neon|Fly"] = 183.37, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 472.68, ["Mega|Ride"] = 405.57, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3719.63, ["Fly"] = 2625, ["Ride"] = 3936.19, ["Fly|Ride"] = 3084.38, ["Neon"] = 14015.33, ["Neon|Fly|Ride"] = 6750.78, ["Mega|Fly|Ride"] = 24899.49}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 76.13, ["Fly"] = 93.24, ["Ride"] = 78.62, ["Fly|Ride"] = 137.01, ["Neon"] = 394.78, ["Neon|Fly"] = 419.61, ["Neon|Ride"] = 404.8, ["Neon|Fly|Ride"] = 400.32, ["Mega|Fly|Ride"] = 1761.58}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.63, ["Fly"] = 27.28, ["Ride"] = 18.98, ["Fly|Ride"] = 70.63, ["Neon"] = 15.75, ["Neon|Fly"] = 44.63, ["Neon|Ride"] = 54.59, ["Neon|Fly|Ride"] = 135.19, ["Mega"] = 101.13, ["Mega|Fly"] = 452.82, ["Mega|Ride"] = 141.4, ["Mega|Fly|Ride"] = 235.29}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.81, ["Ride"] = 32.68, ["Neon"] = 19.69, ["Neon|Ride"] = 42.21, ["Neon|Fly|Ride"] = 293.97, ["Mega"] = 147, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 55.13, ["Fly"] = 65.63, ["Ride"] = 56.91, ["Fly|Ride"] = 70.63, ["Neon|Ride"] = 703.57, ["Neon|Fly|Ride"] = 240.19, ["Mega|Fly|Ride"] = 1141.88}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 787.5, ["Ride"] = 916.13, ["Fly|Ride"] = 853.13, ["Neon|Ride"] = 5272.99, ["Neon|Fly|Ride"] = 5864.16, ["Mega"] = 16331.02, ["Mega|Fly|Ride"] = 25321.52}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 5071.71, ["Ride"] = 5620.9, ["Fly|Ride"] = 4856.25}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 16.25, ["Fly"] = 35.85, ["Ride"] = 21.19, ["Fly|Ride"] = 47.25, ["Neon|Ride"] = 141.36, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 2532.16, ["Mega|Fly|Ride"] = 619.43}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 10.5, ["Fly"] = 39.38, ["Ride"] = 39.38, ["Fly|Ride"] = 78.02, ["Neon"] = 109.13, ["Neon|Ride"] = 62.34, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 931.64, ["Mega|Ride"] = 505.4, ["Mega|Fly|Ride"] = 531.48}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 50.12, ["Fly"] = 157.49, ["Ride"] = 52.5, ["Fly|Ride"] = 81.38, ["Neon"] = 393.75, ["Neon|Ride"] = 245.44, ["Neon|Fly|Ride"] = 326.89, ["Mega|Fly|Ride"] = 868.88}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 229.69, ["Ride"] = 251.07, ["Fly|Ride"] = 287.97, ["Neon|Ride"] = 1048.69, ["Neon|Fly|Ride"] = 1157.62, ["Mega"] = 10550.64, ["Mega|Fly|Ride"] = 3655.32}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 4.24, ["Ride"] = 42.16, ["Fly|Ride"] = 105, ["Neon"] = 19.63, ["Neon|Fly"] = 70.95, ["Neon|Fly|Ride"] = 137.15, ["Mega"] = 146.49, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 294.37}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 195.07, ["Fly"] = 291.35, ["Ride"] = 196.88, ["Fly|Ride"] = 261.19, ["Neon"] = 813.56, ["Neon|Ride"] = 774.6, ["Neon|Fly|Ride"] = 733.68, ["Mega|Fly|Ride"] = 2624.99}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.1, ["Fly"] = 73.5, ["Ride"] = 16.73, ["Fly|Ride"] = 43.55, ["Neon"] = 28.14, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 466.61, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 480.38}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 210, ["Fly"] = 269.79, ["Ride"] = 239.23, ["Fly|Ride"] = 263.82, ["Neon|Fly|Ride"] = 892.5, ["Mega"] = 10550.64, ["Mega|Fly|Ride"] = 3637.51}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 11.64, ["Fly"] = 421.53, ["Ride"] = 28.47, ["Fly|Ride"] = 86.47, ["Neon"] = 124.36, ["Neon|Fly"] = 296.06, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 394.51, ["Mega"] = 451.58, ["Mega|Ride"] = 590.85, ["Mega|Fly|Ride"] = 503.5}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 4.64, ["Fly|Ride"] = 131.25, ["Neon"] = 13.99, ["Neon|Fly"] = 170.63, ["Neon|Ride"] = 50.18, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 76.13, ["Mega|Fly"] = 422.04, ["Mega|Ride"] = 100.99, ["Mega|Fly|Ride"] = 213.94}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 4.87, ["Mega"] = 21, ["Mega|Fly|Ride"] = 166.71}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Ride"] = 35.85, ["Fly|Ride"] = 219.2, ["Neon"] = 10.48, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 83.36, ["Mega|Fly"] = 155534.19, ["Mega|Ride"] = 115.99, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 66.91, ["Fly"] = 141.23, ["Ride"] = 94.5, ["Fly|Ride"] = 131.25, ["Neon"] = 262.5, ["Neon|Ride"] = 289.31, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 1231.28, ["Mega|Ride"] = 1311.19, ["Mega|Fly|Ride"] = 1167.97}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 45.85, ["Ride"] = 18.38, ["Fly|Ride"] = 51.11, ["Neon"] = 12.5, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 129.94, ["Mega|Ride"] = 165.38, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 18.77, ["Ride"] = 62.99, ["Fly|Ride"] = 141.23, ["Neon"] = 131.25, ["Neon|Ride"] = 116.82, ["Mega"] = 380.63, ["Mega|Ride"] = 561.3}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 78.07, ["Neon|Fly|Ride"] = 281.65, ["Mega"] = 15.84, ["Mega|Ride"] = 87.59, ["Mega|Fly|Ride"] = 170.47}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 18, ["Fly|Ride"] = 35.85, ["Neon"] = 2.1, ["Neon|Ride"] = 16.86, ["Neon|Fly|Ride"] = 77.17, ["Mega"] = 11.42, ["Mega|Ride"] = 23.63}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Ride"] = 104.99, ["Fly|Ride"] = 45.52, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 17.42, ["Neon|Fly|Ride"] = 46.68, ["Mega"] = 17.52, ["Mega|Ride"] = 46.44, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Mega"] = 19.69, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 31.61, ["Ride"] = 14.43, ["Fly|Ride"] = 105.39, ["Neon"] = 6.57, ["Neon|Ride"] = 92.85, ["Neon|Fly|Ride"] = 73.43, ["Mega"] = 221.65, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 161.44}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 4.65, ["Neon|Fly|Ride"] = 141.36, ["Mega"] = 12.99, ["Mega|Ride"] = 86.63, ["Mega|Fly|Ride"] = 124.83}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 46.56, ["Ride"] = 19.95, ["Fly|Ride"] = 53.53, ["Neon"] = 6.07, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 24.28, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 60.38, ["Mega|Fly"] = 109.75, ["Mega|Ride"] = 81.38, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Fly|Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Mega"] = 15.73, ["Mega|Ride"] = 47.25, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.63, ["Ride"] = 142.28, ["Fly|Ride"] = 525, ["Neon"] = 17.05, ["Mega"] = 140.44, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.56, ["Ride"] = 80.1, ["Neon"] = 21}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Neon"] = 6.45, ["Neon|Ride"] = 103.95, ["Mega"] = 55.13, ["Mega|Ride"] = 173.83, ["Mega|Fly|Ride"] = 280.88}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 30.32, ["Ride"] = 15.83, ["Neon"] = 2.05, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 16.89, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 10.48, ["Mega|Ride"] = 22.31, ["Mega|Fly|Ride"] = 66.51}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 6.57, ["Fly"] = 72.19, ["Ride"] = 42, ["Neon"] = 27.57, ["Neon|Ride"] = 39.38, ["Mega|Ride"] = 352.41}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 42, ["Fly|Ride"] = 78.73, ["Neon"] = 7.87, ["Neon|Ride"] = 42.21, ["Neon|Fly|Ride"] = 73.85, ["Mega"] = 34.12, ["Mega|Ride"] = 62.34, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.1, ["Ride"] = 70.63, ["Neon"] = 9.16, ["Neon|Fly|Ride"] = 141.4, ["Mega"] = 82.31, ["Mega|Ride"] = 132.57}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 656.25, ["Ride"] = 32.81, ["Fly|Ride"] = 191.81, ["Neon"] = 10.55, ["Neon|Fly"] = 92.09, ["Neon|Ride"] = 42.21, ["Mega"] = 209.88, ["Mega|Ride"] = 85.3, ["Mega|Fly|Ride"] = 281.72}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Ride"] = 10.5, ["Fly|Ride"] = 27.57, ["Neon"] = 2.1, ["Neon|Fly"] = 14.42, ["Neon|Ride"] = 15.84, ["Neon|Fly|Ride"] = 31.5, ["Mega"] = 13.11, ["Mega|Ride"] = 19.69, ["Mega|Fly|Ride"] = 45.94}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 19.65, ["Fly|Ride"] = 138.5, ["Neon"] = 15.74, ["Neon|Ride"] = 112.01, ["Mega"] = 122.19, ["Mega|Fly|Ride"] = 202.59}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 6.33, ["Neon"] = 92.34, ["Neon|Ride"] = 466.62, ["Neon|Fly|Ride"] = 139.99, ["Mega"] = 181.49, ["Mega|Ride"] = 422.04, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 23.19, ["Ride"] = 15.74, ["Fly|Ride"] = 27.57, ["Neon"] = 2.1, ["Neon|Fly"] = 21.32, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 50.66, ["Mega"] = 15.88, ["Mega|Fly"] = 156.19, ["Mega|Fly|Ride"] = 93.19}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Ride"] = 31.5, ["Neon"] = 7.86, ["Neon|Fly"] = 77.99, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 105, ["Mega"] = 63, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 311.48}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 28.47, ["Neon"] = 5.25, ["Neon|Fly"] = 155.97, ["Neon|Fly|Ride"] = 311.49, ["Mega"] = 32.82, ["Mega|Fly|Ride"] = 197.31}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 120.15, ["Neon"] = 2.1, ["Neon|Fly"] = 40.69, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 84, ["Mega"] = 13.11, ["Mega|Ride"] = 28.5, ["Mega|Fly|Ride"] = 187.81}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 28.47, ["Ride"] = 20.98, ["Fly|Ride"] = 77.99, ["Neon"] = 9.19, ["Neon|Fly"] = 42.16, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 141.36, ["Mega"] = 219.32, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 156.16}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Neon"] = 13.09, ["Neon|Ride"] = 60.14, ["Mega"] = 86.63, ["Mega|Ride"] = 81.38, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 28.35, ["Ride"] = 21, ["Fly|Ride"] = 35.64, ["Neon"] = 5.7, ["Neon|Fly"] = 70.63, ["Neon|Ride"] = 39.67, ["Neon|Fly|Ride"] = 72.19, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 11.42, ["Ride"] = 80.99, ["Neon"] = 72.19, ["Mega"] = 296.63, ["Mega|Fly|Ride"] = 1119.86}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 56.91, ["Neon"] = 10.5, ["Neon|Fly"] = 58.78, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 143.5, ["Mega"] = 315, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 21, ["Fly"] = 105, ["Fly|Ride"] = 210.77, ["Neon"] = 26.25, ["Neon|Fly"] = 56.91, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 103.37, ["Mega"] = 119.44, ["Mega|Fly|Ride"] = 207.64}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.21, ["Fly"] = 79.47, ["Fly|Ride"] = 104.92, ["Neon"] = 140.33}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 9.17, ["Mega"] = 590.63, ["Mega|Ride"] = 985.44, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.1, ["Ride"] = 262.5, ["Neon"] = 42, ["Neon|Ride"] = 141.36, ["Neon|Fly|Ride"] = 84.4, ["Mega"] = 363.97, ["Mega|Ride"] = 559.13, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 3.75, ["Ride"] = 69.95, ["Neon"] = 53.5, ["Neon|Ride"] = 291.38, ["Mega"] = 422.04, ["Mega|Ride"] = 271.69, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 17.03, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 141.23}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 5.04, ["Fly"] = 17.49, ["Ride"] = 22.16, ["Fly|Ride"] = 58.3, ["Neon"] = 32.54, ["Neon|Ride"] = 46.38, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 281.72, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.38, ["Fly|Ride"] = 65.63, ["Neon"] = 5.25, ["Neon|Ride"] = 141.36, ["Neon|Fly|Ride"] = 451.46, ["Mega"] = 19.67, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 196.25}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.43, ["Ride"] = 164.07, ["Fly|Ride"] = 389.3, ["Neon"] = 5.13, ["Neon|Ride"] = 45.38, ["Mega"] = 45.33, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 19.76, ["Neon"] = 14.68, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 45.94, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 309.42}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 2.63, ["Ride"] = 45.94, ["Neon"] = 45.94, ["Neon|Fly|Ride"] = 233.33, ["Mega"] = 262.5, ["Mega|Ride"] = 156.33, ["Mega|Fly|Ride"] = 295.43}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 51.06, ["Mega"] = 15.73, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 252.06}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Ride"] = 19.79, ["Fly|Ride"] = 281009.12, ["Neon"] = 10.54, ["Neon|Fly"] = 68.83, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 66.47, ["Mega"] = 20.93, ["Mega|Fly"] = 101.31, ["Mega|Ride"] = 61.69, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.25, ["Ride"] = 17.07, ["Fly|Ride"] = 105.39, ["Neon"] = 8.24, ["Neon|Fly"] = 70.63, ["Neon|Ride"] = 28.49, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 54.63, ["Mega|Fly|Ride"] = 110.5}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Ride"] = 281.38, ["Neon"] = 3.91, ["Neon|Ride"] = 39.42, ["Neon|Fly|Ride"] = 72.17, ["Mega"] = 24.09, ["Mega|Ride"] = 47.25, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.68, ["Neon|Fly|Ride"] = 121.22, ["Mega"] = 13.1, ["Mega|Fly"] = 105, ["Mega|Ride"] = 88.64, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 26.36, ["Ride"] = 22.32, ["Neon"] = 5.23, ["Neon|Fly"] = 45.93, ["Neon|Ride"] = 27.28, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 42.23, ["Mega|Ride"] = 45.85, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Mega"] = 15.84, ["Mega|Ride"] = 205.33}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 6.35, ["Neon|Ride"] = 78.17, ["Neon|Fly|Ride"] = 420, ["Mega"] = 27.44}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 17479.53, ["Ride"] = 17.5, ["Fly|Ride"] = 52.5, ["Neon"] = 3.73, ["Neon|Ride"] = 20.98, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 35.43, ["Mega|Fly"] = 52.5, ["Mega|Ride"] = 45.93, ["Mega|Fly|Ride"] = 155.97}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 12.21, ["Ride"] = 59.07, ["Neon"] = 105.39, ["Mega"] = 412.79, ["Mega|Ride"] = 492.73, ["Mega|Fly|Ride"] = 514.88}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 4.19, ["Fly"] = 42.16, ["Ride"] = 68.25, ["Neon"] = 94.5, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 422.04, ["Mega|Ride"] = 344.54}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 3.92, ["Ride"] = 42, ["Fly|Ride"] = 421.53, ["Neon"] = 15.74, ["Neon|Ride"] = 281.65, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 166.69, ["Mega|Fly|Ride"] = 338.63}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 15.46, ["Fly|Ride"] = 28.88, ["Neon"] = 2.1, ["Neon|Fly"] = 23.19, ["Neon|Ride"] = 16.89, ["Neon|Fly|Ride"] = 35.44, ["Mega"] = 15.67, ["Mega|Fly"] = 23.63, ["Mega|Ride"] = 19.67, ["Mega|Fly|Ride"] = 43.31}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 5.25, ["Ride"] = 55.13, ["Fly|Ride"] = 64.32, ["Neon"] = 14.83, ["Neon|Fly"] = 141.23, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 70.01, ["Mega|Ride"] = 156.33, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.5, ["Neon"] = 2.1, ["Neon|Fly"] = 28.47, ["Neon|Ride"] = 31.66, ["Neon|Fly|Ride"] = 79.04, ["Mega"] = 9.18, ["Mega|Fly"] = 46.68, ["Mega|Ride"] = 101.07, ["Mega|Fly|Ride"] = 326.17}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.73, ["Neon|Fly"] = 60.9, ["Mega"] = 14.39, ["Mega|Fly|Ride"] = 274.33}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Fly|Ride"] = 56.73, ["Neon"] = 10.24, ["Neon|Fly"] = 77.7, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 63.31, ["Mega"] = 179.08, ["Mega|Ride"] = 231.08, ["Mega|Fly|Ride"] = 204.69}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 257.25, ["Ride"] = 261.35, ["Fly|Ride"] = 393.75, ["Neon"] = 1541.07, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1414.33, ["Mega"] = 8440.52, ["Mega|Fly|Ride"] = 4747.8}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.24, ["Fly|Ride"] = 52.5, ["Neon"] = 8.38, ["Neon|Ride"] = 83.94, ["Mega"] = 73.87, ["Mega|Ride"] = 175.16, ["Mega|Fly|Ride"] = 422.04}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 10.55, ["Fly"] = 103.68, ["Ride"] = 24.1, ["Neon"] = 53.82, ["Neon|Ride"] = 166.49, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 117.12, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 1055.08}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 21.19, ["Ride"] = 14.42, ["Fly|Ride"] = 46.36, ["Neon"] = 3.91, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 49.88, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 124.51}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Ride"] = 24.92, ["Fly|Ride"] = 122.26, ["Neon"] = 5.25, ["Neon|Fly"] = 36.15, ["Neon|Ride"] = 42.21, ["Mega"] = 97.08, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 209.97}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 5.25, ["Fly"] = 32.82, ["Ride"] = 19.59, ["Fly|Ride"] = 32.68, ["Neon"] = 28.88, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 160.13, ["Mega|Ride"] = 279.44, ["Mega|Fly|Ride"] = 185.71}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 4.67, ["Ride"] = 39.6, ["Fly|Ride"] = 246.75, ["Neon"] = 62.83, ["Neon|Ride"] = 105.5, ["Neon|Fly|Ride"] = 626.57, ["Mega"] = 302.14, ["Mega|Fly|Ride"] = 420.15}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 17.52, ["Fly|Ride"] = 31.5, ["Neon"] = 26.66, ["Neon|Fly"] = 56.91, ["Neon|Ride"] = 30.43, ["Neon|Fly|Ride"] = 70.68, ["Mega|Fly"] = 384.57, ["Mega|Ride"] = 419.72, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 70.88, ["Fly"] = 141.75, ["Ride"] = 101.07, ["Fly|Ride"] = 131.25, ["Neon"] = 428.9, ["Neon|Fly"] = 394.42, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 420, ["Mega|Fly|Ride"] = 1455.49}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 210, ["Fly"] = 389.22, ["Ride"] = 209.99, ["Fly|Ride"] = 250.69, ["Neon|Ride"] = 1125.5, ["Neon|Fly|Ride"] = 1019.82, ["Mega"] = 10550.64, ["Mega|Fly|Ride"] = 5258.45}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 62.58, ["Fly"] = 105, ["Ride"] = 72.19, ["Fly|Ride"] = 104.33, ["Neon"] = 301.88, ["Neon|Ride"] = 273, ["Neon|Fly|Ride"] = 350.21, ["Mega|Fly|Ride"] = 1022.44}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 4.97, ["Ride"] = 28.47, ["Fly|Ride"] = 78.11, ["Neon"] = 22.32, ["Neon|Ride"] = 31.66, ["Neon|Fly|Ride"] = 172.66, ["Mega"] = 246.89, ["Mega|Ride"] = 240.32, ["Mega|Fly|Ride"] = 391.44}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 10.5, ["Ride"] = 32.54, ["Fly|Ride"] = 62.99, ["Neon"] = 124.69, ["Neon|Fly"] = 141.23, ["Neon|Ride"] = 291.38, ["Neon|Fly|Ride"] = 281.65, ["Mega"] = 484.11, ["Mega|Ride"] = 373.51, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 22.32, ["Fly|Ride"] = 66.45, ["Neon"] = 2.1, ["Neon|Fly"] = 129.93, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 36.18, ["Mega|Fly"] = 116.67, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 203.43}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 7.6, ["Fly"] = 65.63, ["Ride"] = 24.94, ["Fly|Ride"] = 103.69, ["Neon"] = 18.9, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 141.36, ["Mega"] = 466.61, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 202.99}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 28.01, ["Ride"] = 16.35, ["Fly|Ride"] = 45.1, ["Neon"] = 11.08, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 36.18, ["Neon|Fly|Ride"] = 99.18, ["Mega"] = 129.94, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 175.88}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.63, ["Ride"] = 30.19, ["Fly|Ride"] = 328.13, ["Neon"] = 21.19, ["Neon|Ride"] = 56.98, ["Mega"] = 157.5, ["Mega|Fly|Ride"] = 703.74}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 28.38, ["Neon"] = 2.63, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 13.12, ["Mega|Ride"] = 49.61, ["Mega|Fly|Ride"] = 156.33}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.23, ["Fly"] = 67.15, ["Ride"] = 31.63, ["Fly|Ride"] = 56.44, ["Neon"] = 17.07, ["Neon|Fly"] = 70.63, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 87.5, ["Mega"] = 78.75, ["Mega|Fly|Ride"] = 192.29}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 36.72, ["Ride"] = 23.62, ["Fly|Ride"] = 52.5, ["Neon"] = 62.31, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 563.29, ["Mega"] = 156.16, ["Mega|Fly|Ride"] = 271.69}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 141.75, ["Fly"] = 166.51, ["Ride"] = 154.88, ["Fly|Ride"] = 203.44, ["Neon"] = 555.36, ["Neon|Ride"] = 519.28, ["Neon|Fly|Ride"] = 542.06, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.33, ["Ride"] = 240.91, ["Fly|Ride"] = 206.07, ["Neon"] = 53.82, ["Neon|Ride"] = 124.83, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 414.75, ["Mega|Ride"] = 457.92, ["Mega|Fly|Ride"] = 366.12}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 69.78, ["Ride"] = 26.51, ["Fly|Ride"] = 112.88, ["Neon"] = 28.47, ["Neon|Ride"] = 26.3, ["Neon|Fly|Ride"] = 93.34, ["Mega"] = 236.25, ["Mega|Ride"] = 258.12, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 19.43, ["Ride"] = 62.95, ["Fly|Ride"] = 155.43, ["Neon"] = 77.84, ["Neon|Ride"] = 109.68, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 522.27, ["Mega|Ride"] = 551.25, ["Mega|Fly|Ride"] = 489.56}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 4.93}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 5.25, ["Ride"] = 210, ["Neon"] = 69.57, ["Neon|Fly|Ride"] = 623.41, ["Mega"] = 288.75, ["Mega|Ride"] = 408.33, ["Mega|Fly|Ride"] = 1266.08}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 30.32, ["Fly"] = 56.25, ["Ride"] = 40.69, ["Fly|Ride"] = 62.88, ["Neon"] = 155.97, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 119.58, ["Neon|Fly|Ride"] = 166.82, ["Mega"] = 2110.14, ["Mega|Fly|Ride"] = 1068.53}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 4.2, ["Neon|Ride"] = 34.9, ["Mega"] = 24.94, ["Mega|Ride"] = 63.93, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 2.63, ["Fly"] = 25.66, ["Ride"] = 28.47, ["Fly|Ride"] = 73.21, ["Neon"] = 47.92, ["Neon|Ride"] = 233.33, ["Mega"] = 278.56, ["Mega|Fly"] = 389.62, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 3.11, ["Ride"] = 18.38, ["Fly|Ride"] = 45, ["Neon"] = 31.49, ["Neon|Ride"] = 25.12, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 137.82, ["Mega|Ride"] = 128.62, ["Mega|Fly|Ride"] = 234.86}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Neon"] = 3.92, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 112.88, ["Mega"] = 39.75, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 139.29}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 39.38, ["Fly"] = 156.16, ["Ride"] = 48.57, ["Fly|Ride"] = 99.07, ["Neon"] = 202.55, ["Neon|Ride"] = 282.71, ["Mega"] = 788.12, ["Mega|Ride"] = 813.75, ["Mega|Fly|Ride"] = 834.75}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.82, ["Ride"] = 48.49, ["Fly|Ride"] = 209.99, ["Neon"] = 72.19, ["Neon|Ride"] = 79.12, ["Mega"] = 232.15}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 9.85, ["Fly"] = 87.5, ["Ride"] = 42.16, ["Fly|Ride"] = 184.43, ["Neon"] = 52.5, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 76.13, ["Neon|Fly|Ride"] = 149.63, ["Mega"] = 393.1, ["Mega|Ride"] = 417.38, ["Mega|Fly|Ride"] = 413.44}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 57.74, ["Fly"] = 281.38, ["Ride"] = 102.38, ["Fly|Ride"] = 351.99, ["Neon"] = 18316.2, ["Neon|Ride"] = 421.94, ["Neon|Fly|Ride"] = 421.94, ["Mega|Ride"] = 1801.01, ["Mega|Fly|Ride"] = 1829.49}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 30.19, ["Ride"] = 42, ["Fly|Ride"] = 92.97, ["Neon"] = 84.74, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 551.24, ["Mega"] = 378, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 500.59}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 77.83, ["Fly"] = 131.25, ["Ride"] = 101.07, ["Fly|Ride"] = 157.5, ["Neon"] = 252.03, ["Neon|Ride"] = 263.05, ["Neon|Fly|Ride"] = 300.57, ["Mega"] = 982.28, ["Mega|Ride"] = 983.34, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 24.86, ["Ride"] = 70.81, ["Fly|Ride"] = 156.2, ["Neon"] = 85.31, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 209.77, ["Mega"] = 294.58, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 10.69, ["Fly"] = 52.5, ["Ride"] = 27.42, ["Fly|Ride"] = 65.63, ["Neon"] = 59.85, ["Neon|Ride"] = 93.35, ["Neon|Fly|Ride"] = 98.54, ["Mega"] = 331.3, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 22.32, ["Fly"] = 111.57, ["Ride"] = 41.99, ["Fly|Ride"] = 156.2, ["Neon"] = 69.77, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 188.88, ["Mega"] = 234.94, ["Mega|Ride"] = 352.98, ["Mega|Fly|Ride"] = 570.94}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 8.9, ["Ride"] = 39.38, ["Neon"] = 43.32, ["Neon|Ride"] = 124.04, ["Neon|Fly|Ride"] = 199.29, ["Mega"] = 416.59, ["Mega|Ride"] = 300.64, ["Mega|Fly|Ride"] = 378.23}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 32.82, ["Mega"] = 16.68, ["Mega|Fly"] = 141.4, ["Mega|Ride"] = 66.94, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 2.55, ["Ride"] = 105.39, ["Fly|Ride"] = 70.63, ["Neon"] = 13.12, ["Neon|Ride"] = 83.83, ["Mega"] = 122.85, ["Mega|Ride"] = 156.4, ["Mega|Fly|Ride"] = 311.48}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 6.57, ["Ride"] = 19.69, ["Neon"] = 22.23, ["Neon|Ride"] = 126.41, ["Mega"] = 336, ["Mega|Ride"] = 394.61}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 6.57, ["Ride"] = 31.42, ["Fly|Ride"] = 116.57, ["Neon"] = 27.57, ["Neon|Ride"] = 84.4, ["Neon|Fly|Ride"] = 280.6, ["Mega"] = 123.38, ["Mega|Ride"] = 152.97, ["Mega|Fly|Ride"] = 504.67}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 484.31, ["Fly"] = 622.29, ["Ride"] = 549.94, ["Fly|Ride"] = 584.07, ["Neon"] = 1580.69, ["Neon|Ride"] = 1463.03, ["Neon|Fly|Ride"] = 1517.25, ["Mega|Fly|Ride"] = 4593.74}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 7.62, ["Fly"] = 56.26, ["Ride"] = 24.94, ["Fly|Ride"] = 72.28, ["Neon"] = 37.95, ["Neon|Ride"] = 84.4, ["Neon|Fly|Ride"] = 124.83, ["Mega"] = 300.97, ["Mega|Ride"] = 281.72, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 6.57, ["Fly"] = 31.5, ["Neon"] = 64.32, ["Neon|Fly"] = 315, ["Neon|Ride"] = 156.33, ["Mega"] = 341.85, ["Mega|Ride"] = 561.3, ["Mega|Fly|Ride"] = 358.13}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 4.08, ["Ride"] = 23.23, ["Fly|Ride"] = 316.15, ["Neon|Ride"] = 45.94, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 42.16, ["Ride"] = 26.25, ["Neon"] = 7.02, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 135.03, ["Mega"] = 65.63, ["Mega|Fly"] = 238.46, ["Mega|Ride"] = 74.8, ["Mega|Fly|Ride"] = 196.43}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Ride"] = 70.63, ["Neon"] = 2.63, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 116.67, ["Mega"] = 19.98, ["Mega|Ride"] = 78.08, ["Mega|Fly|Ride"] = 185.71}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1327.29}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 10.49, ["Fly"] = 65.63, ["Ride"] = 41.27, ["Fly|Ride"] = 130.69, ["Neon"] = 84, ["Neon|Fly"] = 141.23, ["Neon|Ride"] = 132.56, ["Neon|Fly|Ride"] = 527.42, ["Mega"] = 500.12, ["Mega|Ride"] = 281.39, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 45.36, ["Neon"] = 7.87, ["Neon|Ride"] = 74.67, ["Mega"] = 50.17, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 233.31}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 42.16, ["Ride"] = 42, ["Fly|Ride"] = 525, ["Neon"] = 7.86, ["Neon|Ride"] = 70.09, ["Neon|Fly|Ride"] = 105, ["Mega"] = 111.85, ["Mega|Ride"] = 140.44, ["Mega|Fly|Ride"] = 141.4}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 450.06, ["Fly"] = 459.38, ["Ride"] = 421.53, ["Fly|Ride"] = 505.32, ["Neon|Ride"] = 1509.38, ["Neon|Fly|Ride"] = 1424, ["Mega|Fly|Ride"] = 7932.22}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 6.48, ["Fly"] = 196.88, ["Ride"] = 59.07, ["Neon"] = 84.32, ["Neon|Ride"] = 131.25, ["Mega"] = 458.07, ["Mega|Ride"] = 499.28, ["Mega|Fly|Ride"] = 374.07}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 5.25, ["Neon|Ride"] = 31.52, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 38.62, ["Mega|Fly"] = 189, ["Mega|Ride"] = 83.98, ["Mega|Fly|Ride"] = 175.77}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 239.23, ["Neon"] = 3.36, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 20.98, ["Mega|Ride"] = 83.74, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 8.88, ["Fly"] = 78.79, ["Ride"] = 34.83, ["Fly|Ride"] = 56.91, ["Neon"] = 65.63, ["Neon|Ride"] = 207.38, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 298.24, ["Mega|Ride"] = 195.55, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 9.18, ["Ride"] = 36.15, ["Fly|Ride"] = 78.11, ["Neon"] = 65.63, ["Neon|Fly|Ride"] = 837.38, ["Mega"] = 929.53, ["Mega|Ride"] = 466.61, ["Mega|Fly|Ride"] = 1049.35}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["Fly|Ride"] = 141.23, ["Neon"] = 196.12, ["Neon|Ride"] = 209.92, ["Mega"] = 281.72, ["Mega|Ride"] = 380.97, ["Mega|Fly|Ride"] = 703.74}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 7.88, ["Ride"] = 28.47, ["Fly|Ride"] = 233.12, ["Neon|Ride"] = 124.83, ["Neon|Fly|Ride"] = 778.09, ["Mega"] = 660.19, ["Mega|Ride"] = 440.55, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 300.57, ["Ride"] = 459.38, ["Fly|Ride"] = 606.3, ["Neon"] = 1759.94, ["Neon|Ride"] = 1171.22, ["Neon|Fly|Ride"] = 1030.52, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 3.73, ["Ride"] = 44.63, ["Fly|Ride"] = 82.69, ["Neon"] = 140.58, ["Neon|Ride"] = 99.17, ["Neon|Fly|Ride"] = 197.27, ["Mega"] = 529.78, ["Mega|Ride"] = 501.17, ["Mega|Fly|Ride"] = 703.74}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 5.25, ["Ride"] = 41.68, ["Neon"] = 28.33, ["Mega"] = 1266.08, ["Mega|Fly|Ride"] = 563.41}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 11.21, ["Ride"] = 46.64, ["Fly|Ride"] = 162.75, ["Neon"] = 35.44, ["Neon|Ride"] = 76.13, ["Neon|Fly|Ride"] = 168, ["Mega"] = 161.43, ["Mega|Ride"] = 223.79, ["Mega|Fly|Ride"] = 309.27}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Ride"] = 31.49, ["Fly|Ride"] = 99.07, ["Neon"] = 9.19, ["Neon|Ride"] = 65.63, ["Mega"] = 52.5, ["Mega|Ride"] = 90.63, ["Mega|Fly|Ride"] = 218.15}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 30.07, ["Ride"] = 65.63, ["Neon"] = 210, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 466.62, ["Mega"] = 914.75, ["Mega|Ride"] = 953.79, ["Mega|Fly|Ride"] = 1151.09}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 582.66, ["Ride"] = 26.25, ["Fly|Ride"] = 65.63, ["Neon"] = 10.48, ["Neon|Fly"] = 183.37, ["Neon|Ride"] = 49.88, ["Mega"] = 65.63, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 251.98}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Ride"] = 31.38, ["Fly|Ride"] = 148.32, ["Neon"] = 5.75, ["Neon|Ride"] = 27.56, ["Mega"] = 43.32, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 265.89}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Fly"] = 1519.88, ["Ride"] = 24.94, ["Fly|Ride"] = 262.5, ["Neon"] = 11.82, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 295.32, ["Mega"] = 100.25, ["Mega|Ride"] = 160.39, ["Mega|Fly|Ride"] = 193.09}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 72.19, ["Ride"] = 94.5, ["Fly|Ride"] = 156.2, ["Neon"] = 485.63, ["Neon|Ride"] = 281.65, ["Neon|Fly|Ride"] = 787.5, ["Mega|Fly|Ride"] = 901.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 261.35, ["Ride"] = 281.38, ["Fly|Ride"] = 442.92, ["Neon"] = 1243.48, ["Neon|Ride"] = 1099.88, ["Neon|Fly|Ride"] = 1556.17, ["Mega"] = 7034.12, ["Mega|Fly|Ride"] = 5627.72}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 3.94, ["Neon"] = 23.61, ["Mega"] = 100.94, ["Mega|Ride"] = 211.7, ["Mega|Fly|Ride"] = 417.82}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 4.46, ["Neon"] = 15.83, ["Mega"] = 119.88, ["Mega|Fly|Ride"] = 451.44}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.81, ["Fly"] = 155.57, ["Neon"] = 56.91, ["Neon|Ride"] = 63, ["Mega"] = 484.98}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 53.23, ["Ride"] = 19.94, ["Neon"] = 6.56, ["Neon|Ride"] = 26.07, ["Neon|Fly|Ride"] = 182.62, ["Mega"] = 60.15, ["Mega|Ride"] = 139.99, ["Mega|Fly|Ride"] = 135.07}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 59.07, ["Neon"] = 8.33, ["Mega"] = 28.88, ["Mega|Ride"] = 206.07}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 64.03, ["Ride"] = 15.83, ["Fly|Ride"] = 46.49, ["Neon"] = 3.93, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 43.32, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 148.16}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 20.04, ["Fly|Ride"] = 60.38, ["Neon"] = 24.26, ["Neon|Fly"] = 46.64, ["Neon|Ride"] = 28.33, ["Neon|Fly|Ride"] = 86.34, ["Mega"] = 170.63, ["Mega|Ride"] = 197.31, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 27.45, ["Fly"] = 100.23, ["Ride"] = 28.32, ["Fly|Ride"] = 137.01, ["Neon"] = 113.82, ["Neon|Ride"] = 137.15, ["Mega"] = 367.5, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 52.49, ["Fly"] = 582.75, ["Ride"] = 85.32, ["Fly|Ride"] = 118.13, ["Neon"] = 462.58, ["Neon|Ride"] = 391.13, ["Neon|Fly|Ride"] = 524.61, ["Mega"] = 3111.07, ["Mega|Ride"] = 1445.45, ["Mega|Fly|Ride"] = 1527.95}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 131.25, ["Neon"] = 4.23, ["Neon|Ride"] = 70.68, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 42.23, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 156.33}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 24.26, ["Ride"] = 18.96, ["Fly|Ride"] = 46.64, ["Neon"] = 3.78, ["Neon|Ride"] = 24.86, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 38.06, ["Mega|Fly"] = 157.5, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 3.81, ["Ride"] = 37.95, ["Neon"] = 91.18, ["Neon|Ride"] = 421.94, ["Neon|Fly|Ride"] = 280.6, ["Mega"] = 611, ["Mega|Ride"] = 633.05, ["Mega|Fly|Ride"] = 471.19}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 251.73, ["Fly"] = 347.76, ["Ride"] = 551.8, ["Fly|Ride"] = 358.3, ["Neon"] = 984.24, ["Neon|Ride"] = 1476.75, ["Mega|Fly|Ride"] = 5288.93}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 28.32, ["Fly"] = 209.9, ["Ride"] = 68.57, ["Fly|Ride"] = 155.97, ["Neon"] = 278.25, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 225.74, ["Mega"] = 902.1, ["Mega|Ride"] = 816.63, ["Mega|Fly|Ride"] = 816.63}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 26.24, ["Neon"] = 10.48, ["Neon|Ride"] = 49.32, ["Mega"] = 120.17, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.63, ["Fly"] = 210.77, ["Ride"] = 84.32, ["Fly|Ride"] = 142.7, ["Neon"] = 25.31, ["Neon|Ride"] = 65.63, ["Mega"] = 211.32, ["Mega|Ride"] = 436.29}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 28.35, ["Fly"] = 257.14, ["Ride"] = 39.37, ["Fly|Ride"] = 67.61, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 2532.16, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 774.43}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 77.37, ["Ride"] = 140.59, ["Fly|Ride"] = 183.37, ["Neon"] = 345.19, ["Neon|Ride"] = 469.88, ["Neon|Fly|Ride"] = 421.94, ["Mega"] = 3095.57, ["Mega|Fly|Ride"] = 2179.04}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 210, ["Fly"] = 501.62, ["Ride"] = 280.32, ["Fly|Ride"] = 400.32, ["Neon"] = 820.32, ["Neon|Ride"] = 985.21, ["Neon|Fly|Ride"] = 918.75, ["Mega|Fly|Ride"] = 3023.83}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 15.75, ["Ride"] = 83.94, ["Fly|Ride"] = 262.5, ["Neon"] = 136.77, ["Neon|Ride"] = 138.2, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 487.61, ["Mega|Ride"] = 380.62, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 18.38, ["Fly|Ride"] = 32.82, ["Neon"] = 8.8, ["Neon|Fly"] = 70.63, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 43.32, ["Mega"] = 108.94, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 155.97}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 5.25, ["Ride"] = 21.09, ["Fly|Ride"] = 53.82, ["Neon"] = 31.48, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 225.75, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 408.81}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 367.08, ["Ride"] = 262.5, ["Fly|Ride"] = 484.76, ["Neon|Ride"] = 1657.13, ["Neon|Fly|Ride"] = 1946.14, ["Mega|Fly|Ride"] = 6999.02}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Neon"] = 11.34, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 31.5, ["Mega|Ride"] = 158.28, ["Mega|Fly|Ride"] = 279.98}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.77, ["Fly"] = 52.5, ["Ride"] = 17.07, ["Fly|Ride"] = 78.11, ["Neon"] = 25.31, ["Neon|Ride"] = 36.74, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 236.25, ["Mega|Ride"] = 281.72, ["Mega|Fly|Ride"] = 246.89}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 18.38, ["Ride"] = 42.16, ["Neon"] = 103.62, ["Neon|Ride"] = 210.97, ["Neon|Fly|Ride"] = 537.18, ["Mega"] = 536.61, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 514.5}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 98.44, ["Fly"] = 280.32, ["Ride"] = 118.13, ["Fly|Ride"] = 131.25, ["Neon|Ride"] = 421.94, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 1540.41}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 19.67, ["Fly"] = 78.08, ["Ride"] = 26.25, ["Fly|Ride"] = 59.07, ["Neon"] = 65.63, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 125.96, ["Mega"] = 703.74, ["Mega|Ride"] = 378.78, ["Mega|Fly|Ride"] = 485.73}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 42.16, ["Fly|Ride"] = 104.33, ["Neon"] = 2.1, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 20.34, ["Mega|Ride"] = 112.91, ["Mega|Fly|Ride"] = 422.04}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Fly|Ride"] = 84.32, ["Neon"] = 2.63, ["Neon|Fly"] = 31.49, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 69.18, ["Mega"] = 21, ["Mega|Fly"] = 86.34, ["Mega|Ride"] = 61.21, ["Mega|Fly|Ride"] = 111.53}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 7.25, ["Ride"] = 28.88, ["Fly|Ride"] = 157.5, ["Neon"] = 26.25, ["Neon|Fly"] = 264.58, ["Neon|Ride"] = 71.75, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 144.38, ["Mega|Ride"] = 179.38, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1433.25, ["Ride"] = 1401.75, ["Fly|Ride"] = 1437.19, ["Neon"] = 5268.93, ["Neon|Fly|Ride"] = 4127.82, ["Mega|Fly|Ride"] = 13466.25}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 538.13, ["Ride"] = 616.32, ["Fly|Ride"] = 601.73, ["Neon|Ride"] = 2371.23, ["Neon|Fly|Ride"] = 2421.86, ["Mega"] = 13998.03, ["Mega|Fly|Ride"] = 4948.13}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 279.55, ["Fly"] = 394.12, ["Ride"] = 354.38, ["Fly|Ride"] = 380.63, ["Neon"] = 735, ["Neon|Fly"] = 843.04, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 826.88, ["Mega|Fly|Ride"] = 1982.58}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 318.68, ["Fly"] = 315, ["Ride"] = 353, ["Fly|Ride"] = 405.57, ["Neon"] = 843.04, ["Neon|Ride"] = 956.01, ["Neon|Fly|Ride"] = 896.44, ["Mega|Ride"] = 3675, ["Mega|Fly|Ride"] = 3051.25}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 80.1, ["Ride"] = 19.69, ["Fly|Ride"] = 66.4, ["Neon"] = 6.29, ["Neon|Ride"] = 45.39, ["Neon|Fly|Ride"] = 124.83, ["Mega"] = 69.28, ["Mega|Ride"] = 87.59, ["Mega|Fly|Ride"] = 141.4}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 300.57, ["Fly"] = 410.2, ["Ride"] = 326.82, ["Fly|Ride"] = 392.44, ["Neon"] = 1103.78, ["Neon|Ride"] = 1105.36, ["Neon|Fly|Ride"] = 1049.99, ["Mega"] = 3995.54, ["Mega|Ride"] = 3937.5, ["Mega|Fly|Ride"] = 3281.24}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.1, ["Fly"] = 183.75, ["Ride"] = 27.57, ["Neon"] = 7.88, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 254.63, ["Mega"] = 59.07, ["Mega|Ride"] = 140.37, ["Mega|Fly|Ride"] = 272.22}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 20.93, ["Ride"] = 31.49, ["Fly|Ride"] = 49.88, ["Neon"] = 7.87, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 126, ["Mega"] = 125.56, ["Mega|Ride"] = 132.96, ["Mega|Fly|Ride"] = 202.13}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 3.82, ["Mega"] = 21.9, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 57.31, ["Ride"] = 70.3, ["Fly|Ride"] = 459.38, ["Neon"] = 273, ["Neon|Ride"] = 420, ["Mega"] = 2110.14, ["Mega|Ride"] = 933.21, ["Mega|Fly|Ride"] = 972.57}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.63, ["Fly"] = 65.61, ["Ride"] = 18.9, ["Neon"] = 28.46, ["Mega"] = 328.13, ["Mega|Ride"] = 318.65}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 53.82, ["Neon"] = 3.93, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 24.94, ["Mega|Fly"] = 109.67, ["Mega|Ride"] = 156.33, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Ride"] = 27.41, ["Fly|Ride"] = 69.57, ["Neon"] = 8.43, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 22.77, ["Neon|Fly|Ride"] = 82.67, ["Mega"] = 66.33, ["Mega|Fly"] = 198.32, ["Mega|Ride"] = 89.25, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 8.38, ["Fly"] = 46.1, ["Ride"] = 32.49, ["Fly|Ride"] = 55.26, ["Neon"] = 56.91, ["Neon|Ride"] = 253.17, ["Neon|Fly|Ride"] = 253.17, ["Mega"] = 237.56, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 13.86, ["Ride"] = 27.57, ["Mega"] = 466.61, ["Mega|Ride"] = 337.64, ["Mega|Fly|Ride"] = 522.27}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.51, ["Ride"] = 47.76, ["Fly|Ride"] = 87.94, ["Neon"] = 39.38, ["Neon|Fly|Ride"] = 699.93, ["Mega"] = 225.8, ["Mega|Ride"] = 492.73}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 17.5, ["Fly|Ride"] = 84, ["Neon"] = 3.76, ["Neon|Ride"] = 28.49, ["Neon|Fly|Ride"] = 168.78, ["Mega"] = 32.82, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 316.53}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 196.88, ["Fly"] = 219.2, ["Ride"] = 216.57, ["Fly|Ride"] = 275.63, ["Neon"] = 1163.09, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 896.6, ["Neon|Fly|Ride"] = 924.21, ["Mega"] = 8440.52, ["Mega|Fly|Ride"] = 3475.39}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 16.49, ["Fly|Ride"] = 32.82, ["Neon"] = 3.67, ["Neon|Fly"] = 105.39, ["Neon|Ride"] = 26.14, ["Neon|Fly|Ride"] = 69.8, ["Mega"] = 46.68, ["Mega|Ride"] = 73.5, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 13.12, ["Ride"] = 69.57, ["Fly|Ride"] = 105, ["Neon"] = 61.14, ["Neon|Ride"] = 148.17, ["Neon|Fly|Ride"] = 328.98, ["Mega"] = 315, ["Mega|Ride"] = 310.64, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 28.88, ["Ride"] = 118.13, ["Neon"] = 153.57, ["Neon|Ride"] = 310.31, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 699.91, ["Mega|Ride"] = 737.5, ["Mega|Fly|Ride"] = 839.85}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 168, ["Fly"] = 262.5, ["Ride"] = 223.13, ["Fly|Ride"] = 291.38, ["Neon|Ride"] = 742.88, ["Neon|Fly|Ride"] = 866.25, ["Mega|Fly|Ride"] = 3264.38}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 20.61, ["Neon"] = 65.63, ["Mega"] = 328.13, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 703.74}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 26.25, ["Ride"] = 316.15, ["Fly|Ride"] = 631.23, ["Neon"] = 131.25, ["Neon|Ride"] = 632.89, ["Neon|Fly|Ride"] = 843.86, ["Mega"] = 624.69, ["Mega|Ride"] = 632, ["Mega|Fly|Ride"] = 1055.08}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1147.82, ["Fly"] = 1441.13, ["Ride"] = 984.38, ["Fly|Ride"] = 1181.25, ["Neon|Ride"] = 6328.86, ["Neon|Fly|Ride"] = 4408.17, ["Mega|Fly|Ride"] = 16243.76}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 3.93, ["Fly"] = 43.32, ["Ride"] = 21, ["Fly|Ride"] = 62.03, ["Neon"] = 49.2, ["Neon|Fly"] = 111.57, ["Neon|Ride"] = 78.17, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 98.43, ["Mega|Fly"] = 563.41, ["Mega|Ride"] = 267.75, ["Mega|Fly|Ride"] = 382.6}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 8.97, ["Fly"] = 13909.95, ["Ride"] = 39.38, ["Neon"] = 38.07, ["Neon|Fly|Ride"] = 144.74, ["Mega"] = 212.63, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Ride"] = 32.68, ["Fly|Ride"] = 91.69, ["Neon"] = 16.99, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 311.49, ["Mega"] = 136.5, ["Mega|Ride"] = 233.99, ["Mega|Fly|Ride"] = 563.41}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 14.44, ["Fly"] = 40.69, ["Ride"] = 38.88, ["Fly|Ride"] = 91.88, ["Neon"] = 69.42, ["Neon|Ride"] = 126.59, ["Neon|Fly|Ride"] = 200.87, ["Mega"] = 301.88, ["Mega|Ride"] = 349.13, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.63, ["Fly"] = 36.9, ["Ride"] = 34.13, ["Fly|Ride"] = 65.63, ["Neon"] = 15.75, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 63.31, ["Mega"] = 350.3, ["Mega|Ride"] = 198.32, ["Mega|Fly|Ride"] = 218.93}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 7.86, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 44.14, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 111.55, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 253.23}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 1088.4, ["Ride"] = 451.03, ["Fly|Ride"] = 478.44, ["Neon"] = 771.39, ["Neon|Ride"] = 1693.13, ["Neon|Fly|Ride"] = 1399.85, ["Mega|Fly|Ride"] = 3439.52}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 3.94, ["Ride"] = 35.68, ["Neon"] = 8.97, ["Neon|Fly"] = 78.11, ["Neon|Ride"] = 44.31, ["Neon|Fly|Ride"] = 124.51, ["Mega"] = 83.34, ["Mega|Ride"] = 124.83, ["Mega|Fly|Ride"] = 211.03}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 6.34, ["Fly"] = 408.19, ["Neon"] = 77.43, ["Mega"] = 248.07, ["Mega|Ride"] = 262.12}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.93, ["Fly"] = 81.75, ["Ride"] = 34.13, ["Neon"] = 15.72, ["Neon|Ride"] = 28.49, ["Mega"] = 104.49, ["Mega|Ride"] = 177.85, ["Mega|Fly|Ride"] = 443.14}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 108.94, ["Fly"] = 262.5, ["Ride"] = 220.5, ["Fly|Ride"] = 418.04, ["Neon"] = 393.75, ["Neon|Ride"] = 577.5, ["Neon|Fly|Ride"] = 631.84, ["Mega"] = 1968.77, ["Mega|Ride"] = 1857.98, ["Mega|Fly|Ride"] = 1785}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 26.25, ["Ride"] = 84, ["Fly|Ride"] = 109.61, ["Neon"] = 163.49, ["Neon|Fly"] = 233.12, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 210.97, ["Mega"] = 529.66, ["Mega|Ride"] = 630.94, ["Mega|Fly|Ride"] = 560.2}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 11.8, ["Ride"] = 39.38, ["Neon"] = 110.96, ["Neon|Ride"] = 141.36, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 702.87, ["Mega|Ride"] = 414.75, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 31.47, ["Neon"] = 5.25, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.44, ["Mega"] = 31.5, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 77.44, ["Fly"] = 115.5, ["Ride"] = 97.13, ["Fly|Ride"] = 195.76, ["Neon"] = 432.68, ["Neon|Ride"] = 408.23, ["Neon|Fly|Ride"] = 378, ["Mega|Fly|Ride"] = 905.63}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 21.08, ["Neon"] = 8.45, ["Neon|Fly|Ride"] = 588, ["Mega"] = 61.21}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 15.73, ["Fly"] = 140.38, ["Ride"] = 45.94, ["Fly|Ride"] = 125.42, ["Neon"] = 96.91, ["Neon|Ride"] = 105.5, ["Neon|Fly|Ride"] = 120.29, ["Mega"] = 380.63, ["Mega|Ride"] = 393.74, ["Mega|Fly|Ride"] = 395.01}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 42, ["Ride"] = 98.44, ["Fly|Ride"] = 161.41, ["Neon|Ride"] = 242.62, ["Neon|Fly|Ride"] = 377.53, ["Mega|Ride"] = 1221.78, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 28.25, ["Ride"] = 15.75, ["Fly|Ride"] = 47.24, ["Neon"] = 2.55, ["Neon|Fly"] = 27.72, ["Neon|Ride"] = 15.72, ["Neon|Fly|Ride"] = 39.84, ["Mega"] = 23.23, ["Mega|Ride"] = 44.63, ["Mega|Fly|Ride"] = 103.67}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.91, ["Ride"] = 31.5, ["Fly|Ride"] = 98.65, ["Neon"] = 18.38, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 202.79, ["Mega|Ride"] = 280.88, ["Mega|Fly|Ride"] = 504.67}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 17.07, ["Ride"] = 58.28, ["Fly|Ride"] = 130.69, ["Neon"] = 177.19, ["Neon|Ride"] = 141.36, ["Neon|Fly|Ride"] = 281.65, ["Mega"] = 699.91, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 628.69}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 23.09, ["Neon"] = 2.63, ["Neon|Ride"] = 28.13, ["Neon|Fly|Ride"] = 126.62, ["Mega"] = 16.79, ["Mega|Ride"] = 126.62, ["Mega|Fly|Ride"] = 390.48}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 3.86, ["Fly"] = 210, ["Ride"] = 44.27, ["Fly|Ride"] = 98.44, ["Neon"] = 40.69, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 181.22, ["Mega"] = 408.33, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 413.6}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 31.49, ["Fly"] = 31.47, ["Ride"] = 28.88, ["Fly|Ride"] = 46.64, ["Neon"] = 112.22, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 703.74, ["Mega|Fly|Ride"] = 466.55}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 2.63, ["Ride"] = 22.94, ["Neon"] = 23.08, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 200.82, ["Mega"] = 150.94, ["Mega|Ride"] = 247.96, ["Mega|Fly|Ride"] = 287}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 18.38, ["Fly"] = 2107.58, ["Ride"] = 99.75, ["Fly|Ride"] = 132.57, ["Neon"] = 121.75, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 499.29, ["Neon|Fly|Ride"] = 6221.12, ["Mega"] = 378, ["Mega|Ride"] = 535.5, ["Mega|Fly|Ride"] = 661.5}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 24.14, ["Fly|Ride"] = 126.48, ["Neon"] = 7.02, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 70.68, ["Mega"] = 80.2, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 105.47, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 28.47, ["Neon"] = 3.01, ["Mega"] = 27.55, ["Mega|Ride"] = 132.19}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 39.38}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 43.76, ["Fly"] = 77.99, ["Ride"] = 78.75, ["Fly|Ride"] = 205.5, ["Neon"] = 1050, ["Neon|Fly|Ride"] = 1054.82, ["Mega|Ride"] = 983.34, ["Mega|Fly|Ride"] = 889.87}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 140.62, ["Neon"] = 2.1, ["Mega"] = 26.25, ["Mega|Ride"] = 77.64, ["Mega|Fly|Ride"] = 156.33}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 622.29, ["Ride"] = 590.63, ["Fly|Ride"] = 654.93, ["Neon"] = 4215.15, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 16881.01, ["Mega|Fly|Ride"] = 6752.42}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 5.25, ["Fly"] = 49.88, ["Ride"] = 40.69, ["Fly|Ride"] = 54.79, ["Neon"] = 30.19, ["Neon|Ride"] = 104.45, ["Neon|Fly|Ride"] = 563.29, ["Mega|Fly|Ride"] = 563.41}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 3.94, ["Ride"] = 20.98, ["Fly|Ride"] = 40.81, ["Neon"] = 105, ["Neon|Ride"] = 35.47, ["Neon|Fly|Ride"] = 87.56, ["Mega"] = 167.87, ["Mega|Ride"] = 156.33, ["Mega|Fly|Ride"] = 259.56}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 13.13, ["Ride"] = 76.13, ["Fly|Ride"] = 106.32, ["Neon"] = 210.67, ["Neon|Ride"] = 421.94, ["Neon|Fly|Ride"] = 141.36, ["Mega"] = 1042.42, ["Mega|Ride"] = 479.01, ["Mega|Fly|Ride"] = 1265.03}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 6.34, ["Fly"] = 49.54, ["Ride"] = 39.38, ["Fly|Ride"] = 393.75, ["Neon"] = 140.59, ["Mega"] = 293.32, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 10.5, ["Ride"] = 60.38, ["Fly|Ride"] = 157.5, ["Neon"] = 62.67, ["Neon|Fly"] = 189.7, ["Neon|Ride"] = 176.5, ["Neon|Fly|Ride"] = 350.44, ["Mega"] = 414.58, ["Mega|Ride"] = 464.24, ["Mega|Fly|Ride"] = 1055.08}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 6.25, ["Fly"] = 105, ["Ride"] = 28.47, ["Fly|Ride"] = 65.63, ["Neon"] = 30.19, ["Neon|Ride"] = 56.98, ["Neon|Fly|Ride"] = 186.66, ["Mega"] = 170.63, ["Mega|Fly"] = 487.46, ["Mega|Ride"] = 281.72, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 46.64, ["Ride"] = 18.88, ["Fly|Ride"] = 75.89, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 18.9, ["Neon|Fly|Ride"] = 60.1, ["Mega"] = 15.74, ["Mega|Fly"] = 78.17, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 65.58}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 11.67, ["Ride"] = 32.82, ["Fly|Ride"] = 56.91, ["Neon"] = 44.6, ["Neon|Fly"] = 389.3, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 622.13, ["Mega"] = 132.56, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 272.22}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 255.94, ["Ride"] = 279.57, ["Fly|Ride"] = 282.19, ["Neon"] = 1296.17, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1365, ["Mega"] = 5616.72, ["Mega|Fly|Ride"] = 4593.75}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 96.53, ["Ride"] = 145.68, ["Fly|Ride"] = 249.38, ["Neon"] = 885.2, ["Neon|Ride"] = 866.25, ["Neon|Fly|Ride"] = 945, ["Mega"] = 4220.27, ["Mega|Ride"] = 1983.54, ["Mega|Fly|Ride"] = 1736.43}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 24.94, ["Fly|Ride"] = 39.37, ["Neon"] = 12.66, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 53.45, ["Mega|Fly"] = 209.97, ["Mega|Ride"] = 91.81, ["Mega|Fly|Ride"] = 65.63}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 16.8, ["Ride"] = 15.75, ["Fly|Ride"] = 31.17, ["Neon"] = 6.56, ["Neon|Fly"] = 36.15, ["Neon|Ride"] = 22.92, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 131.78, ["Mega|Ride"] = 153.57, ["Mega|Fly|Ride"] = 156.19}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.55, ["Ride"] = 18.96, ["Fly|Ride"] = 98.44, ["Neon"] = 13.13, ["Mega"] = 141.4}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 258.62, ["Ride"] = 301.88, ["Fly|Ride"] = 236.25, ["Neon|Ride"] = 1265.78, ["Neon|Fly|Ride"] = 1575, ["Mega|Ride"] = 8440.52, ["Mega|Fly|Ride"] = 4752.02}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.52, ["Fly"] = 26.75, ["Ride"] = 15.73, ["Fly|Ride"] = 32.81, ["Neon"] = 13.71, ["Neon|Fly"] = 156.2, ["Neon|Ride"] = 33.9, ["Neon|Fly|Ride"] = 70.71, ["Mega"] = 268.01, ["Mega|Ride"] = 211.03, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.91, ["Ride"] = 39.34, ["Fly|Ride"] = 210.77, ["Neon"] = 24.26, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 225.74, ["Mega"] = 166.71, ["Mega|Ride"] = 204.75, ["Mega|Fly|Ride"] = 302.44}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 91.88, ["Neon"] = 8.45, ["Neon|Ride"] = 21, ["Mega"] = 28.5, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 15.74, ["Ride"] = 26.73, ["Fly|Ride"] = 60.78, ["Neon"] = 107.02, ["Neon|Ride"] = 88.72, ["Neon|Fly|Ride"] = 231, ["Mega"] = 577.43, ["Mega|Ride"] = 408.33, ["Mega|Fly|Ride"] = 761.25}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 49.62, ["Ride"] = 52.54, ["Fly|Ride"] = 209.97, ["Neon"] = 155.66, ["Neon|Fly"] = 311.2, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 279.57, ["Mega"] = 476.9, ["Mega|Fly"] = 590.85, ["Mega|Ride"] = 504.62, ["Mega|Fly|Ride"] = 588}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 27.42, ["Fly"] = 131.25, ["Ride"] = 41.88, ["Fly|Ride"] = 65.63, ["Neon"] = 380.63, ["Neon|Ride"] = 183.54, ["Neon|Fly|Ride"] = 218.98, ["Mega|Ride"] = 695.63, ["Mega|Fly|Ride"] = 700.58}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 20.89, ["Ride"] = 71.53, ["Fly|Ride"] = 51.45, ["Neon"] = 2.1, ["Neon|Fly"] = 70.63, ["Neon|Ride"] = 20.05, ["Neon|Fly|Ride"] = 56.74, ["Mega"] = 22.18, ["Mega|Fly"] = 41.16, ["Mega|Ride"] = 59.11, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 207.2, ["Ride"] = 262.24, ["Fly|Ride"] = 309.75, ["Neon"] = 932.44, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1051.92, ["Mega|Fly|Ride"] = 3412.5}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 12.47, ["Fly"] = 210, ["Ride"] = 45.94, ["Fly|Ride"] = 112.76, ["Neon"] = 118.13, ["Neon|Ride"] = 121.21, ["Neon|Fly|Ride"] = 210, ["Mega"] = 548.65, ["Mega|Ride"] = 451.44, ["Mega|Fly|Ride"] = 476.9}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Ride"] = 28.47, ["Fly|Ride"] = 59.07, ["Neon"] = 5.23, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 52.65, ["Mega|Fly"] = 111.57, ["Mega|Ride"] = 141.4, ["Mega|Fly|Ride"] = 276.44}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 141.23, ["Ride"] = 17.07, ["Neon"] = 2.1, ["Neon|Fly"] = 31.49, ["Neon|Ride"] = 21.3, ["Neon|Fly|Ride"] = 119.76, ["Mega"] = 18.38, ["Mega|Fly"] = 138.24, ["Mega|Ride"] = 45.39, ["Mega|Fly|Ride"] = 128.58}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 3.75, ["Ride"] = 28.88, ["Fly|Ride"] = 56.62, ["Neon"] = 13.13, ["Neon|Ride"] = 41.15, ["Neon|Fly|Ride"] = 183.54, ["Mega"] = 85.32, ["Mega|Ride"] = 116.75, ["Mega|Fly|Ride"] = 422.04}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 11.79, ["Fly"] = 32.29, ["Ride"] = 18.66, ["Fly|Ride"] = 66.45, ["Neon"] = 45.93, ["Neon|Ride"] = 69.92, ["Neon|Fly|Ride"] = 141.36, ["Mega"] = 466.61, ["Mega|Ride"] = 370.13, ["Mega|Fly|Ride"] = 345.75}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 7.79, ["Ride"] = 26.25, ["Neon"] = 101.07, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 210, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 422.04}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 52.41, ["Fly|Ride"] = 49.54, ["Neon"] = 3.93, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 26.25, ["Mega|Ride"] = 44.63, ["Mega|Fly|Ride"] = 242.65}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 15.69, ["Ride"] = 56.91, ["Fly|Ride"] = 94.86, ["Neon"] = 27.57, ["Neon|Fly"] = 102.92, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 119.69, ["Mega"] = 172.94, ["Mega|Ride"] = 263.78, ["Mega|Fly|Ride"] = 381.46}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 210, ["Neon"] = 8.45, ["Neon|Ride"] = 91.88, ["Mega"] = 31.49, ["Mega|Ride"] = 94.22, ["Mega|Fly|Ride"] = 615.9}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 40.05, ["Ride"] = 24.94, ["Fly|Ride"] = 118.13, ["Neon"] = 6.57, ["Neon|Ride"] = 44.26, ["Neon|Fly|Ride"] = 116.47, ["Mega"] = 56.44, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 195.8}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 1103.55, ["Ride"] = 1048.69, ["Fly|Ride"] = 1533.27, ["Neon|Fly|Ride"] = 4612.69, ["Mega|Fly|Ride"] = 13998.03}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 18.36, ["Ride"] = 15.64, ["Fly|Ride"] = 44.27, ["Neon"] = 17.5, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 124.68, ["Neon|Fly|Ride"] = 105.5, ["Mega"] = 188.88, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 10.5, ["Neon|Ride"] = 126.59, ["Neon|Fly|Ride"] = 140.57, ["Mega"] = 78.08, ["Mega|Ride"] = 98.43, ["Mega|Fly|Ride"] = 198.18}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 10.49, ["Fly"] = 32.82, ["Ride"] = 26.83, ["Fly|Ride"] = 51.19, ["Neon"] = 141.12, ["Neon|Ride"] = 39.35, ["Neon|Fly|Ride"] = 105, ["Mega|Ride"] = 277.93, ["Mega|Fly|Ride"] = 353.07}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 41.11, ["Ride"] = 16.83, ["Fly|Ride"] = 40.36, ["Neon"] = 6.34, ["Neon|Fly"] = 89.24, ["Neon|Ride"] = 28.35, ["Neon|Fly|Ride"] = 60.61, ["Mega"] = 72.19, ["Mega|Ride"] = 101.31, ["Mega|Fly|Ride"] = 184.29}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 52.58, ["Ride"] = 141.23, ["Fly|Ride"] = 156.2, ["Neon"] = 302.12, ["Neon|Ride"] = 337.56, ["Mega"] = 769.13, ["Mega|Ride"] = 1021.91, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 36.14, ["Ride"] = 26.17, ["Fly|Ride"] = 78.11, ["Neon"] = 4.2, ["Neon|Ride"] = 141.36, ["Neon|Fly|Ride"] = 109.68, ["Mega"] = 81.29, ["Mega|Ride"] = 75.11, ["Mega|Fly|Ride"] = 280.08}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.63, ["Fly"] = 73.5, ["Ride"] = 31.35, ["Fly|Ride"] = 65.63, ["Neon"] = 10.5, ["Neon|Fly"] = 147.54, ["Neon|Ride"] = 59.12, ["Neon|Fly|Ride"] = 141.36, ["Mega"] = 308.43, ["Mega|Ride"] = 295.43, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly|Ride"] = 65.63, ["Neon"] = 20.99, ["Neon|Fly"] = 62.95, ["Mega"] = 57.52, ["Mega|Ride"] = 156.33}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 2593.49, ["Ride"] = 20.04, ["Fly|Ride"] = 134.9, ["Neon"] = 3.82, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 41.85, ["Mega|Fly"] = 108.94, ["Mega|Ride"] = 62.63, ["Mega|Fly|Ride"] = 85.31}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 21, ["Fly"] = 39.37, ["Ride"] = 26.25, ["Fly|Ride"] = 43.32, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 844.07, ["Mega|Ride"] = 522.27, ["Mega|Fly|Ride"] = 452.66}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 774.38, ["Ride"] = 748.13, ["Fly|Ride"] = 867.57, ["Neon"] = 2016, ["Neon|Ride"] = 2166.6, ["Neon|Fly|Ride"] = 2098.69, ["Mega"] = 7034.12, ["Mega|Ride"] = 5250, ["Mega|Fly|Ride"] = 4987.5}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 66.94, ["Ride"] = 19.69, ["Fly|Ride"] = 42.16, ["Neon"] = 5.09, ["Neon|Fly"] = 28.47, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 35.01, ["Mega|Fly"] = 75.98, ["Mega|Ride"] = 73.5, ["Mega|Fly|Ride"] = 99.75}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 6.85, ["Ride"] = 73.78, ["Neon"] = 54.55, ["Neon|Ride"] = 125.55, ["Neon|Fly|Ride"] = 337.56, ["Mega"] = 269.07, ["Mega|Ride"] = 156.33, ["Mega|Fly|Ride"] = 441}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 83.51, ["Fly"] = 144.38, ["Ride"] = 96.29, ["Fly|Ride"] = 140.44, ["Neon|Ride"] = 639.22, ["Neon|Fly|Ride"] = 560.12, ["Mega"] = 2955.93, ["Mega|Fly|Ride"] = 3033.19}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 32.82, ["Ride"] = 70.32, ["Fly|Ride"] = 301.88, ["Neon"] = 280.26, ["Neon|Ride"] = 177.19, ["Mega"] = 816.63, ["Mega|Ride"] = 681.22, ["Mega|Fly|Ride"] = 658.38}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 15.65, ["Fly|Ride"] = 319.31, ["Neon"] = 113.77, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 226.32, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 493.29}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 27.01, ["Ride"] = 112.35, ["Neon"] = 121.21, ["Neon|Ride"] = 358.14, ["Mega"] = 329.2, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 546.54}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 26.17, ["Ride"] = 315, ["Neon"] = 151.19, ["Neon|Ride"] = 316.46, ["Neon|Fly|Ride"] = 525, ["Mega"] = 719.92, ["Mega|Ride"] = 737.5, ["Mega|Fly|Ride"] = 771.1}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 7.54}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 6.57, ["Ride"] = 41.97, ["Neon"] = 56.11, ["Neon|Ride"] = 70.62, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 422.04, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.26, ["Neon"] = 28.47, ["Mega"] = 871.39, ["Mega|Fly|Ride"] = 949.57}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 51.19, ["Fly"] = 420.46, ["Ride"] = 65.63, ["Fly|Ride"] = 105, ["Neon"] = 210.77, ["Neon|Ride"] = 275.42, ["Neon|Fly|Ride"] = 354.38, ["Mega"] = 702.97, ["Mega|Ride"] = 681.19, ["Mega|Fly|Ride"] = 754.68}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 6.34, ["Fly"] = 26.17, ["Ride"] = 18.74, ["Fly|Ride"] = 278.21, ["Neon"] = 27.55, ["Neon|Fly"] = 41.92, ["Neon|Ride"] = 36.04, ["Neon|Fly|Ride"] = 50.29, ["Mega"] = 311.48, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 513.45}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 6.22, ["Ride"] = 19.69, ["Fly|Ride"] = 91.88, ["Neon"] = 26.25, ["Neon|Ride"] = 58.26, ["Neon|Fly|Ride"] = 134.17, ["Mega"] = 131.24, ["Mega|Fly"] = 301.45, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Mega"] = 42.23}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 32.8, ["Fly"] = 148.32, ["Ride"] = 43.32, ["Fly|Ride"] = 72.19, ["Neon"] = 210.77, ["Neon|Ride"] = 210.97, ["Mega"] = 1089.53, ["Mega|Ride"] = 827.91, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 11.47, ["Neon|Fly"] = 145.69, ["Mega"] = 126.62, ["Mega|Ride"] = 208.11}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 7.49, ["Ride"] = 140.63, ["Neon"] = 65.63, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 295.36, ["Mega"] = 282.19, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 492.73}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 23.63, ["Ride"] = 17.36, ["Fly|Ride"] = 61.69, ["Neon"] = 27.99, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 126.59, ["Mega"] = 70.88, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 314.35}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 3.67, ["Fly"] = 52.5, ["Ride"] = 24.13, ["Fly|Ride"] = 49.88, ["Neon"] = 52.5, ["Neon|Fly"] = 112.76, ["Neon|Ride"] = 126.59, ["Mega"] = 211.03, ["Mega|Ride"] = 420.98, ["Mega|Fly|Ride"] = 211.03}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.66, ["Ride"] = 23.63, ["Fly|Ride"] = 78.11, ["Neon"] = 21, ["Neon|Ride"] = 111.57, ["Mega"] = 140.6, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 337.64}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 32.74, ["Fly"] = 118.13, ["Ride"] = 99.07, ["Fly|Ride"] = 131.25, ["Neon"] = 164.07, ["Neon|Ride"] = 261.6, ["Mega"] = 1089.53, ["Mega|Ride"] = 903.15, ["Mega|Fly|Ride"] = 870.19}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 18.27, ["Ride"] = 247.66, ["Neon"] = 209.79, ["Neon|Fly|Ride"] = 389.64, ["Mega"] = 262.5, ["Mega|Ride"] = 316.18, ["Mega|Fly|Ride"] = 422.04}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 7.53, ["Ride"] = 105, ["Neon"] = 91.62, ["Neon|Ride"] = 56.98, ["Mega"] = 233.31, ["Mega|Ride"] = 1557.3, ["Mega|Fly|Ride"] = 1688.12}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 15.75, ["Ride"] = 105, ["Fly|Ride"] = 422.03, ["Neon"] = 59.07, ["Mega"] = 766.5, ["Mega|Ride"] = 708.75, ["Mega|Fly|Ride"] = 1051.92}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 72.73, ["Neon"] = 43.74, ["Mega"] = 249.38, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 28.46, ["Ride"] = 23.19, ["Fly|Ride"] = 52.5, ["Neon"] = 6.5, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 41.15, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 42.9, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 196.02}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 11.21, ["Ride"] = 46.64, ["Neon"] = 47.12, ["Neon|Ride"] = 78.48, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 131.25, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 451.58}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 31.86, ["Ride"] = 22.32, ["Fly|Ride"] = 53.82, ["Neon"] = 6.56, ["Neon|Fly"] = 32.68, ["Neon|Ride"] = 25.3, ["Neon|Fly|Ride"] = 69.63, ["Mega"] = 44.63, ["Mega|Ride"] = 85.68, ["Mega|Fly|Ride"] = 139.99}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.13, ["Ride"] = 19.69, ["Neon"] = 13.13, ["Neon|Ride"] = 93.34, ["Neon|Fly|Ride"] = 261.6, ["Mega"] = 249.38, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 5.25, ["Ride"] = 27.57, ["Fly|Ride"] = 72.19, ["Neon"] = 328.8, ["Neon|Ride"] = 133.98, ["Mega"] = 422.04, ["Mega|Fly|Ride"] = 983.34}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.73, ["Fly"] = 30.85, ["Ride"] = 18.38, ["Neon"] = 28.47, ["Neon|Fly"] = 91.69, ["Neon|Ride"] = 35.26, ["Neon|Fly|Ride"] = 102.25, ["Mega"] = 281.72, ["Mega|Ride"] = 118.12, ["Mega|Fly|Ride"] = 194.15}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Ride"] = 23.03, ["Fly|Ride"] = 86.26, ["Neon"] = 23.23, ["Neon|Ride"] = 82.84, ["Mega"] = 166.68, ["Mega|Ride"] = 126.62, ["Mega|Fly|Ride"] = 492.73}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 3.82, ["Ride"] = 71.64, ["Fly|Ride"] = 65.63, ["Neon"] = 15.83, ["Neon|Fly"] = 68.17, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 168.78, ["Mega"] = 78.17, ["Mega|Ride"] = 141.4, ["Mega|Fly|Ride"] = 296.3}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 8.45, ["Ride"] = 70.63, ["Fly|Ride"] = 210.77, ["Neon"] = 56.44, ["Neon|Ride"] = 119.51, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 311.07, ["Mega|Fly"] = 656.25, ["Mega|Ride"] = 448.88, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 52.76, ["Fly"] = 198.11, ["Ride"] = 74.61, ["Fly|Ride"] = 291.38, ["Neon"] = 236.25, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 316.32, ["Mega"] = 2532.16, ["Mega|Ride"] = 997.5, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Ride"] = 19.92, ["Neon"] = 2.59, ["Neon|Ride"] = 37.46, ["Mega"] = 28.33, ["Mega|Ride"] = 62.99, ["Mega|Fly|Ride"] = 94.5}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 15.83, ["Ride"] = 131.25, ["Neon"] = 54.55, ["Mega"] = 312.38, ["Mega|Ride"] = 408.33, ["Mega|Fly|Ride"] = 1252.38}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 34.13, ["Ride"] = 115.5, ["Neon"] = 777.42, ["Neon|Ride"] = 1125.5, ["Mega|Ride"] = 1117.32, ["Mega|Fly|Ride"] = 1255.54}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 8.9, ["Fly"] = 190.32, ["Ride"] = 50.59, ["Fly|Ride"] = 126, ["Neon"] = 39.35, ["Neon|Ride"] = 99.52, ["Neon|Fly|Ride"] = 141.36, ["Mega"] = 157.5, ["Mega|Ride"] = 156.33, ["Mega|Fly|Ride"] = 294.37}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Fly"] = 157.5, ["Ride"] = 42, ["Fly|Ride"] = 137.82, ["Neon"] = 3.56, ["Neon|Ride"] = 26.17, ["Mega"] = 24.94, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.84, ["Fly"] = 26.25, ["Ride"] = 15.75, ["Fly|Ride"] = 78.02, ["Neon"] = 15.89, ["Neon|Fly"] = 26.83, ["Neon|Ride"] = 35.02, ["Neon|Fly|Ride"] = 98.36, ["Mega"] = 203.6, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 209.83}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 18.37, ["Ride"] = 23.19, ["Fly|Ride"] = 32.68, ["Neon"] = 2.1, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 24.94, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 21.09, ["Fly|Ride"] = 91.69, ["Neon"] = 2.63, ["Neon|Ride"] = 34.01, ["Neon|Fly|Ride"] = 83.32, ["Mega"] = 35.64, ["Mega|Fly"] = 168, ["Mega|Ride"] = 94.97, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Mega"] = 31.52, ["Mega|Ride"] = 99.2, ["Mega|Fly|Ride"] = 255.94}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 9.18, ["Ride"] = 157.5, ["Fly|Ride"] = 358.3, ["Neon"] = 27.38, ["Neon|Fly"] = 141.23, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 156.33, ["Mega"] = 213.94, ["Mega|Ride"] = 296.3, ["Mega|Fly|Ride"] = 1124.71}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 51.19, ["Ride"] = 41.67, ["Fly|Ride"] = 84.32, ["Neon"] = 74.82, ["Neon|Ride"] = 84.4, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 371.4, ["Mega|Ride"] = 407.87, ["Mega|Fly|Ride"] = 364.88}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 7.86, ["Fly"] = 24.93, ["Ride"] = 28.47, ["Fly|Ride"] = 44.63, ["Neon"] = 96.89, ["Neon|Fly"] = 106.08, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 317.63, ["Mega|Ride"] = 342.57, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 83.45, ["Ride"] = 67.45, ["Fly|Ride"] = 262.49, ["Neon"] = 421.53, ["Neon|Ride"] = 527.42, ["Mega"] = 3111.07, ["Mega|Ride"] = 2110.14, ["Mega|Fly|Ride"] = 1544.46}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 15.7, ["Ride"] = 65.63, ["Neon"] = 36.75, ["Neon|Fly"] = 126.47, ["Mega"] = 610.97, ["Mega|Fly"] = 647.82, ["Mega|Ride"] = 600.48, ["Mega|Fly|Ride"] = 563.41}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 20.99, ["Ride"] = 22.93, ["Fly|Ride"] = 54.81, ["Neon"] = 2.63, ["Neon|Fly"] = 42.16, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 56.65, ["Mega"] = 23.63, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 15.74, ["Fly|Ride"] = 32.82, ["Neon"] = 3.78, ["Neon|Fly"] = 26.24, ["Neon|Ride"] = 23.22, ["Neon|Fly|Ride"] = 49.59, ["Mega"] = 39.35, ["Mega|Ride"] = 77, ["Mega|Fly|Ride"] = 99.3}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 406.88, ["Ride"] = 411.86, ["Fly|Ride"] = 524.99, ["Neon|Ride"] = 1829.04, ["Neon|Fly|Ride"] = 1764.79}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 10.48, ["Ride"] = 140.18, ["Neon"] = 55.13, ["Neon|Ride"] = 281.65, ["Neon|Fly|Ride"] = 400.84, ["Mega"] = 491.54, ["Mega|Ride"] = 500.12, ["Mega|Fly|Ride"] = 442.13}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 26.92, ["Ride"] = 17.07, ["Fly|Ride"] = 42.16, ["Neon"] = 6.57, ["Neon|Ride"] = 21.12, ["Neon|Fly|Ride"] = 71.75, ["Mega"] = 114.34, ["Mega|Ride"] = 70.71, ["Mega|Fly|Ride"] = 143.51}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 52.5, ["Ride"] = 111.43, ["Fly|Ride"] = 315, ["Neon"] = 236.24, ["Neon|Ride"] = 277.99, ["Neon|Fly|Ride"] = 465.19, ["Mega"] = 944.3, ["Mega|Ride"] = 800.63, ["Mega|Fly|Ride"] = 936.91}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 45.32, ["Ride"] = 16.98, ["Fly|Ride"] = 42.16, ["Neon"] = 10.48, ["Neon|Fly"] = 91.69, ["Neon|Ride"] = 23.29, ["Neon|Fly|Ride"] = 100.14, ["Mega"] = 65.63, ["Mega|Ride"] = 116.49, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Ride"] = 78.11, ["Fly|Ride"] = 1312.5, ["Neon"] = 2.1, ["Neon|Ride"] = 24.81, ["Neon|Fly|Ride"] = 283.5, ["Mega"] = 16.8, ["Mega|Ride"] = 83.99, ["Mega|Fly|Ride"] = 197.31}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 59.07, ["Ride"] = 86.62, ["Neon"] = 174.4, ["Neon|Fly"] = 454.2, ["Neon|Ride"] = 281.65, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 637.88, ["Mega|Ride"] = 622.93, ["Mega|Fly|Ride"] = 778.08}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Neon"] = 8.4, ["Neon|Ride"] = 50.66, ["Mega"] = 63, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 36.07, ["Fly"] = 141.23, ["Ride"] = 67.61, ["Fly|Ride"] = 208.66, ["Neon"] = 158.08, ["Neon|Ride"] = 158.24, ["Neon|Fly|Ride"] = 279.98, ["Mega|Ride"] = 1686.01}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 6.19, ["Ride"] = 30.19, ["Neon"] = 57.75, ["Neon|Ride"] = 288.75, ["Mega"] = 170.63, ["Mega|Ride"] = 830.34, ["Mega|Fly|Ride"] = 492.73}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 70.63, ["Ride"] = 70.63, ["Neon"] = 13.13, ["Neon|Ride"] = 171.94, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 420, ["Mega|Ride"] = 569.63, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 30.86, ["Ride"] = 141.23, ["Fly|Ride"] = 393.75, ["Neon"] = 544.31, ["Mega|Ride"] = 2611.88, ["Mega|Fly|Ride"] = 1244.67}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 104.85, ["Ride"] = 106.45, ["Fly|Ride"] = 242.45, ["Neon"] = 5.96, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 138.5, ["Mega"] = 45.94, ["Mega|Fly"] = 158.61, ["Mega|Ride"] = 82.85, ["Mega|Fly|Ride"] = 283.36}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 50.59, ["Ride"] = 23.6, ["Fly|Ride"] = 72.17, ["Neon"] = 11.81, ["Neon|Fly"] = 41.88, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 105.5, ["Mega|Fly|Ride"] = 282.85}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 6.55, ["Ride"] = 49.54, ["Neon"] = 111.57, ["Neon|Ride"] = 63.21, ["Neon|Fly|Ride"] = 112.01, ["Mega"] = 844.07, ["Mega|Ride"] = 454.74, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 30.19, ["Ride"] = 62.95, ["Fly|Ride"] = 147, ["Neon"] = 197.07, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 168, ["Mega"] = 508.66, ["Mega|Ride"] = 662.82, ["Mega|Fly|Ride"] = 557.82}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 31.5, ["Fly"] = 91.88, ["Ride"] = 46.64, ["Fly|Ride"] = 76.13, ["Neon"] = 103.68, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 237.86, ["Mega"] = 409.38, ["Mega|Ride"] = 419.93, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 72.19, ["Fly"] = 196.88, ["Ride"] = 124.71, ["Fly|Ride"] = 236.49, ["Neon"] = 272.34, ["Neon|Fly"] = 442.61, ["Neon|Ride"] = 385.87, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 1260, ["Mega|Ride"] = 1261.87, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 2.84, ["Ride"] = 23.62, ["Fly|Ride"] = 262.5, ["Neon"] = 17.07, ["Neon|Ride"] = 141.36, ["Neon|Fly|Ride"] = 316.18, ["Mega"] = 147.92, ["Mega|Ride"] = 156.33, ["Mega|Fly|Ride"] = 352.41}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 6.54, ["Ride"] = 40.06, ["Fly|Ride"] = 118.13, ["Neon"] = 13.13, ["Neon|Ride"] = 67.52, ["Mega"] = 151.66, ["Mega|Ride"] = 198.52}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 10.17, ["Fly"] = 65.63, ["Ride"] = 28.54, ["Fly|Ride"] = 157.5, ["Neon"] = 120.88, ["Neon|Ride"] = 126.59, ["Mega"] = 364.88, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 452.82}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 14.44, ["Fly|Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 14.84, ["Neon|Fly|Ride"] = 41.9, ["Mega"] = 21, ["Mega|Fly"] = 78.17, ["Mega|Ride"] = 30.61, ["Mega|Fly|Ride"] = 105.52}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 65.63, ["Fly"] = 220.5, ["Ride"] = 421.53, ["Neon"] = 372.99, ["Neon|Fly"] = 2388.94, ["Neon|Ride"] = 288.74, ["Neon|Fly|Ride"] = 418.69, ["Mega"] = 1154.26, ["Mega|Fly"] = 964.35, ["Mega|Ride"] = 891.19, ["Mega|Fly|Ride"] = 894.9}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 20.99, ["Fly|Ride"] = 89.24, ["Neon"] = 6.43, ["Neon|Ride"] = 52.5, ["Mega"] = 107.63, ["Mega|Fly"] = 112.91, ["Mega|Ride"] = 116.67, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.47, ["Ride"] = 31.5, ["Fly|Ride"] = 63.25, ["Neon"] = 25.31, ["Neon|Ride"] = 34.42, ["Neon|Fly|Ride"] = 99.17, ["Mega"] = 141.4, ["Mega|Ride"] = 211.03, ["Mega|Fly|Ride"] = 341.92}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 86.63, ["Fly"] = 210.77, ["Ride"] = 137.01, ["Neon"] = 262.5, ["Neon|Ride"] = 281.65, ["Neon|Fly|Ride"] = 580.16, ["Mega"] = 933.21, ["Mega|Ride"] = 912.19, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 30.32, ["Neon"] = 11.21, ["Neon|Ride"] = 141.36, ["Neon|Fly|Ride"] = 106.17, ["Mega"] = 48.44, ["Mega|Ride"] = 109.38, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 11.78}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 35.85, ["Fly|Ride"] = 209.47, ["Neon"] = 4.08, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 40.66, ["Mega|Ride"] = 115.49, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 129.94, ["Ride"] = 281.38, ["Fly|Ride"] = 281.38, ["Neon"] = 575.38, ["Neon|Ride"] = 702.19, ["Neon|Fly|Ride"] = 735, ["Mega"] = 2180.82, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 4.23, ["Ride"] = 41.99, ["Neon"] = 18.38, ["Neon|Ride"] = 61.69, ["Mega"] = 281.72, ["Mega|Ride"] = 297.48, ["Mega|Fly|Ride"] = 356.64}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 210.77, ["Neon"] = 6.57, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 41.16, ["Mega|Ride"] = 78.08, ["Mega|Fly|Ride"] = 312.9}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 5.65, ["Ride"] = 35.44, ["Neon"] = 41.99, ["Neon|Ride"] = 141.36, ["Neon|Fly|Ride"] = 156.33, ["Mega"] = 391.44, ["Mega|Ride"] = 633.05, ["Mega|Fly|Ride"] = 281.72}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 15.75, ["Fly"] = 74.59, ["Ride"] = 23.44, ["Neon"] = 82.69, ["Neon|Ride"] = 99.17, ["Neon|Fly|Ride"] = 272.15, ["Mega"] = 187.69, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 24.74, ["Ride"] = 59.07, ["Fly|Ride"] = 73.5, ["Neon"] = 138.6, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 266.13, ["Mega"] = 527.55, ["Mega|Fly|Ride"] = 573.34}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 111.56, ["Fly"] = 223.76, ["Ride"] = 154.87, ["Fly|Ride"] = 194.35, ["Neon"] = 632.28, ["Neon|Ride"] = 548.63, ["Neon|Fly|Ride"] = 683.69, ["Mega|Fly|Ride"] = 3057.59}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 6.55, ["Fly"] = 18.38, ["Ride"] = 18.35, ["Fly|Ride"] = 39.38, ["Neon"] = 35.44, ["Neon|Ride"] = 35.95, ["Neon|Fly|Ride"] = 83.92, ["Mega"] = 422.04, ["Mega|Ride"] = 702.69, ["Mega|Fly|Ride"] = 360.94}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 3.87, ["Fly"] = 72.19, ["Ride"] = 23.62, ["Fly|Ride"] = 59.07, ["Neon"] = 18.79, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 137.66, ["Mega|Fly|Ride"] = 185.71}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 7.59, ["Fly"] = 233.08, ["Ride"] = 52.5, ["Fly|Ride"] = 65.63, ["Neon"] = 70.3, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 560.25, ["Mega|Ride"] = 466.61, ["Mega|Fly|Ride"] = 433.1}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 42.16, ["Fly"] = 80.1, ["Ride"] = 65.63, ["Fly|Ride"] = 112.76, ["Neon"] = 129.94, ["Neon|Ride"] = 160.13, ["Neon|Fly|Ride"] = 294, ["Mega"] = 577.5, ["Mega|Fly"] = 985.44, ["Mega|Ride"] = 742.88, ["Mega|Fly|Ride"] = 880.69}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 28.47, ["Fly"] = 65.63, ["Ride"] = 81.84, ["Neon"] = 131.25, ["Neon|Ride"] = 126.59, ["Mega"] = 629.99, ["Mega|Ride"] = 696.36, ["Mega|Fly|Ride"] = 733.04}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 239.23, ["Ride"] = 281.38, ["Fly|Ride"] = 459.38, ["Neon"] = 1262.45, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1266.08, ["Mega|Ride"] = 3937.5, ["Mega|Fly|Ride"] = 5695.25}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 37.31, ["Fly"] = 141.23, ["Ride"] = 39.64, ["Fly|Ride"] = 119.6, ["Neon"] = 280.26, ["Neon|Ride"] = 70.68, ["Neon|Fly|Ride"] = 216.99, ["Mega"] = 1195.69, ["Mega|Ride"] = 539.28, ["Mega|Fly|Ride"] = 632}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 28.47, ["Ride"] = 17.05, ["Fly|Ride"] = 37.95, ["Neon"] = 2.1, ["Neon|Ride"] = 15.84, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 30.19, ["Mega|Fly"] = 98.44, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 112.23}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 3.78, ["Ride"] = 56.44, ["Neon"] = 13.13, ["Neon|Ride"] = 39.31, ["Mega"] = 119.59, ["Mega|Ride"] = 264.73, ["Mega|Fly|Ride"] = 465.29}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 2.6, ["Ride"] = 62.98, ["Neon"] = 16.4, ["Neon|Ride"] = 77.7, ["Neon|Fly|Ride"] = 1181.25, ["Mega"] = 79.8, ["Mega|Fly"] = 281.72, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 393.75, ["Fly"] = 582.66, ["Ride"] = 354.37, ["Fly|Ride"] = 491.66, ["Neon"] = 1471.1, ["Neon|Ride"] = 1322.86, ["Neon|Fly|Ride"] = 1345.32, ["Mega|Fly|Ride"] = 5034.75}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.5, ["Fly"] = 70.63, ["Ride"] = 18.04, ["Fly|Ride"] = 46.37, ["Neon"] = 37.95, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 71.12, ["Mega"] = 249.38, ["Mega|Ride"] = 315.6, ["Mega|Fly|Ride"] = 466.61}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 6.57, ["Fly"] = 18.98, ["Ride"] = 17.07, ["Fly|Ride"] = 45.94, ["Neon|Ride"] = 46.68, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 419.93, ["Mega|Ride"] = 703.74, ["Mega|Fly|Ride"] = 844.07}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 4.24, ["Fly"] = 84.32, ["Ride"] = 27.42, ["Fly|Ride"] = 104.92, ["Neon"] = 17.5, ["Neon|Fly"] = 70.63, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 129.5, ["Mega"] = 140.44, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 280.88}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 47.8, ["Fly"] = 210, ["Ride"] = 28.47, ["Fly|Ride"] = 84.32, ["Neon"] = 91.88, ["Neon|Ride"] = 126.59, ["Neon|Fly|Ride"] = 147.69, ["Mega|Ride"] = 845.25, ["Mega|Fly|Ride"] = 563.41}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 315, ["Ride"] = 63, ["Neon"] = 14.44, ["Neon|Ride"] = 78.17, ["Neon|Fly|Ride"] = 210, ["Mega|Fly|Ride"] = 600.48}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 5.25, ["Fly"] = 787.5, ["Ride"] = 65.63, ["Fly|Ride"] = 91.88, ["Neon"] = 311.2, ["Neon|Ride"] = 135.53, ["Mega"] = 703.74, ["Mega|Ride"] = 322.86, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 61.14, ["Neon"] = 2.1, ["Neon|Fly|Ride"] = 210.97, ["Mega"] = 85.32, ["Mega|Ride"] = 2573.31, ["Mega|Fly|Ride"] = 232.15}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 11.75, ["Neon"] = 65.63, ["Mega"] = 196.88, ["Mega|Ride"] = 338.63, ["Mega|Fly|Ride"] = 633.05}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 5.25, ["Ride"] = 70.63, ["Fly|Ride"] = 141.23, ["Neon"] = 121.74, ["Neon|Fly|Ride"] = 210.97, ["Mega"] = 289.1, ["Mega|Ride"] = 280.18, ["Mega|Fly|Ride"] = 1055.08}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 11.82, ["Fly"] = 35.85, ["Ride"] = 24.94, ["Fly|Ride"] = 52.26, ["Neon"] = 46.64, ["Neon|Ride"] = 57.88, ["Neon|Fly|Ride"] = 108.29, ["Mega"] = 408.33, ["Mega|Ride"] = 369.49, ["Mega|Fly|Ride"] = 471.98}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 188.84, ["Fly"] = 281.38, ["Ride"] = 212.63, ["Fly|Ride"] = 233.12, ["Neon"] = 947.41, ["Neon|Ride"] = 933.23, ["Neon|Fly|Ride"] = 850.08, ["Mega|Fly|Ride"] = 4219.21}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Fly"] = 21.2, ["Ride"] = 18.38, ["Fly|Ride"] = 65.09, ["Neon"] = 56.91, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 106.98, ["Mega"] = 211.03, ["Mega|Ride"] = 323.92, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 23.63, ["Fly|Ride"] = 77.69, ["Neon"] = 21, ["Neon|Ride"] = 56.65, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 131.25, ["Mega|Ride"] = 778.08, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 40.99, ["Ride"] = 56.65, ["Fly|Ride"] = 216.57, ["Neon"] = 115.5, ["Neon|Ride"] = 229.37, ["Neon|Fly|Ride"] = 560.63, ["Mega"] = 403.97, ["Mega|Ride"] = 341.24, ["Mega|Fly|Ride"] = 439.69}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 56.44, ["Ride"] = 79.05, ["Fly|Ride"] = 183.37, ["Neon"] = 268.47, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 464.08, ["Mega"] = 1370.55, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1263.98}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 19.69, ["Ride"] = 42.16, ["Fly|Ride"] = 65.63, ["Neon"] = 84, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 281.65, ["Mega"] = 183.75, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 346.5}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 23.08, ["Fly|Ride"] = 39.38, ["Neon"] = 11.6, ["Neon|Fly|Ride"] = 120.26, ["Mega"] = 124.83, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 13.11, ["Ride"] = 61.98, ["Fly|Ride"] = 421.53, ["Neon"] = 48.69, ["Neon|Fly"] = 112.76, ["Neon|Ride"] = 139.13, ["Neon|Fly|Ride"] = 421.94, ["Mega"] = 129.94, ["Mega|Ride"] = 278.78, ["Mega|Fly|Ride"] = 806.85}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 69.3, ["Fly"] = 196.88, ["Ride"] = 131.2, ["Fly|Ride"] = 262.5, ["Neon"] = 183.75, ["Neon|Ride"] = 286.13, ["Neon|Fly|Ride"] = 315, ["Mega"] = 525, ["Mega|Ride"] = 494.82, ["Mega|Fly|Ride"] = 510.57}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 28.47, ["Neon"] = 6.55, ["Neon|Fly"] = 197.07, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 35.44, ["Mega|Fly"] = 98.44, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 219.19}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 10.55, ["Ride"] = 288.75, ["Fly|Ride"] = 400.45, ["Neon"] = 84.32, ["Neon|Ride"] = 564.38, ["Mega"] = 275.63, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 1044.74, ["Fly"] = 1243.39, ["Ride"] = 1030.32, ["Fly|Ride"] = 1036.88, ["Neon"] = 3329.96, ["Neon|Fly|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 10498.69}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 24.94, ["Ride"] = 96.96, ["Fly|Ride"] = 311.2, ["Neon"] = 156.2, ["Neon|Ride"] = 168.78, ["Mega"] = 590.63, ["Mega|Ride"] = 526.32, ["Mega|Fly|Ride"] = 697.92}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 3.92, ["Fly"] = 49.88, ["Ride"] = 28.7, ["Fly|Ride"] = 209.72, ["Neon"] = 18.38, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 108.66, ["Mega"] = 86.63, ["Mega|Ride"] = 116.67, ["Mega|Fly|Ride"] = 206.79}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 62.94, ["Ride"] = 131.22, ["Neon"] = 109.2, ["Mega|Ride"] = 352.41, ["Mega|Fly|Ride"] = 703.74}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 49.54, ["Fly|Ride"] = 421.53, ["Neon"] = 2.49, ["Neon|Ride"] = 36.23, ["Neon|Fly|Ride"] = 109.68, ["Mega"] = 17.06, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 151.28}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 105, ["Ride"] = 118.13, ["Neon"] = 336, ["Neon|Ride"] = 324.65, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 1312.5, ["Mega|Ride"] = 984.38, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 6.02, ["Fly"] = 101.07, ["Ride"] = 45.47, ["Fly|Ride"] = 815.89, ["Neon"] = 24.14, ["Neon|Ride"] = 84, ["Mega"] = 316.53, ["Mega|Ride"] = 231.08, ["Mega|Fly|Ride"] = 323.92}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 28.58, ["Neon"] = 12.27, ["Neon|Ride"] = 39.38, ["Mega"] = 170.62, ["Mega|Ride"] = 278.56, ["Mega|Fly|Ride"] = 389.62}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 56.44, ["Fly"] = 99.07, ["Ride"] = 70.63, ["Fly|Ride"] = 91.88, ["Neon"] = 197.07, ["Neon|Ride"] = 167.09, ["Neon|Fly|Ride"] = 343.88, ["Mega"] = 525.84, ["Mega|Ride"] = 400.32, ["Mega|Fly|Ride"] = 450.19}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 16.94, ["Fly"] = 183.75, ["Ride"] = 63, ["Neon"] = 78.75, ["Neon|Fly"] = 179.16, ["Neon|Ride"] = 240.19, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 393.74, ["Mega|Ride"] = 422.04, ["Mega|Fly|Ride"] = 623.44}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 72.06, ["Ride"] = 281.38, ["Neon"] = 315, ["Neon|Ride"] = 933.19, ["Neon|Fly|Ride"] = 911.54, ["Mega"] = 1470, ["Mega|Ride"] = 1399.81, ["Mega|Fly|Ride"] = 1252.38}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 7.22, ["Ride"] = 36.75, ["Fly|Ride"] = 168.62, ["Neon"] = 31.5, ["Neon|Ride"] = 95.8, ["Neon|Fly|Ride"] = 154.88, ["Mega"] = 108.68, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 253.23}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 6.55, ["Fly"] = 31.5, ["Ride"] = 28.88, ["Fly|Ride"] = 70.3, ["Neon"] = 62.91, ["Neon|Ride"] = 96.84, ["Neon|Fly|Ride"] = 277.49, ["Mega"] = 354.36, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 422.04}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 129.09, ["Ride"] = 190.32, ["Fly|Ride"] = 236.23, ["Neon"] = 485.63, ["Neon|Ride"] = 506.33, ["Neon|Fly|Ride"] = 564.38, ["Mega"] = 2362.5, ["Mega|Ride"] = 2361.19, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.63, ["Fly"] = 26.25, ["Ride"] = 19.69, ["Fly|Ride"] = 45.32, ["Neon"] = 18.88, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 181.49, ["Mega|Ride"] = 136.49, ["Mega|Fly|Ride"] = 149.63}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 7.86, ["Fly"] = 42.16, ["Ride"] = 23.63, ["Fly|Ride"] = 50.54, ["Neon"] = 18.38, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 91.77, ["Mega"] = 220.5, ["Mega|Ride"] = 192.54, ["Mega|Fly|Ride"] = 279.98}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 28.47, ["Ride"] = 18.98, ["Fly|Ride"] = 46.36, ["Neon"] = 2.1, ["Neon|Fly"] = 22.16, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 50.04, ["Mega"] = 13.11, ["Mega|Ride"] = 36.75, ["Mega|Fly|Ride"] = 64.32}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 31.63, ["Neon"] = 3.93, ["Neon|Ride"] = 42.21, ["Mega"] = 20.98, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 156.33}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 132.15, ["Ride"] = 42, ["Neon"] = 38.06, ["Neon|Ride"] = 63.67, ["Mega"] = 131.25, ["Mega|Ride"] = 208.92}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 103.69, ["Ride"] = 156.2, ["Neon"] = 281.38, ["Neon|Ride"] = 452.82, ["Neon|Fly|Ride"] = 630, ["Mega"] = 527.55, ["Mega|Fly|Ride"] = 522.6}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.63, ["Fly"] = 20.99, ["Ride"] = 17, ["Fly|Ride"] = 40.81, ["Neon"] = 15.73, ["Neon|Fly"] = 43.36, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 66.93, ["Mega"] = 126.48, ["Mega|Fly"] = 211.03, ["Mega|Ride"] = 152.25, ["Mega|Fly|Ride"] = 162.75}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 4.12, ["Fly"] = 32.82, ["Ride"] = 26.24, ["Fly|Ride"] = 77.44, ["Neon"] = 12.64, ["Neon|Fly"] = 46.64, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 136.49, ["Mega|Fly"] = 221.58, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 3.94, ["Ride"] = 24.94, ["Fly|Ride"] = 72.19, ["Neon"] = 8.39, ["Neon|Fly"] = 98.44, ["Neon|Ride"] = 35.01, ["Neon|Fly|Ride"] = 106.32, ["Mega"] = 127.23, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 241.5}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 6.57, ["Ride"] = 48.49, ["Neon"] = 26.24, ["Neon|Ride"] = 112.32, ["Neon|Fly|Ride"] = 179.66, ["Mega"] = 233.19, ["Mega|Ride"] = 299.92, ["Mega|Fly|Ride"] = 387.22}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 5.2, ["Fly"] = 160.69, ["Neon"] = 15.21, ["Neon|Ride"] = 262.5, ["Mega"] = 420, ["Mega|Ride"] = 412.13, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.94, ["Fly"] = 91.88, ["Ride"] = 27.98, ["Fly|Ride"] = 139.31, ["Neon"] = 18.31, ["Neon|Fly"] = 196.65, ["Neon|Ride"] = 62.77, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 197.31, ["Mega|Fly"] = 176.21, ["Mega|Ride"] = 175.16, ["Mega|Fly|Ride"] = 293.32}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 16.86, ["Fly|Ride"] = 49.54, ["Neon"] = 10.48, ["Neon|Fly"] = 86.26, ["Neon|Ride"] = 50.37, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 422.04, ["Mega|Ride"] = 154.05, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 183.75, ["Fly"] = 393.75, ["Ride"] = 251.11, ["Fly|Ride"] = 361.33, ["Neon"] = 892.57, ["Neon|Ride"] = 933.23, ["Neon|Fly|Ride"] = 897.75, ["Mega|Fly|Ride"] = 3661.88}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.81, ["Ride"] = 42, ["Neon"] = 26.25, ["Neon|Fly|Ride"] = 281.65, ["Mega"] = 155.29, ["Mega|Ride"] = 267.88, ["Mega|Fly|Ride"] = 985.44}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.9, ["Fly"] = 32.82, ["Ride"] = 27.42, ["Fly|Ride"] = 96.96, ["Neon"] = 31.43, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 124.83, ["Mega"] = 203.44, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 316.53}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 9.06, ["Fly|Ride"] = 156.2, ["Neon"] = 40.92, ["Neon|Fly|Ride"] = 630, ["Mega"] = 416.77, ["Mega|Ride"] = 337.64, ["Mega|Fly|Ride"] = 422.04}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.88, ["Fly|Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Fly"] = 28.76, ["Neon|Ride"] = 22.11, ["Neon|Fly|Ride"] = 50.66, ["Mega"] = 15.73, ["Mega|Fly|Ride"] = 73.5}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.63, ["Fly"] = 56.44, ["Ride"] = 26.25, ["Fly|Ride"] = 45.94, ["Neon"] = 23.33, ["Neon|Ride"] = 37.77, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 199.35, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 156.33}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 94.5, ["Ride"] = 65.63, ["Neon"] = 11.8, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 75.24, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 450.19}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 72.18, ["Fly"] = 130.69, ["Ride"] = 107.23, ["Fly|Ride"] = 155.66, ["Neon"] = 393.75, ["Neon|Ride"] = 393.74, ["Neon|Fly|Ride"] = 408.19, ["Mega|Ride"] = 3518.65, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.78, ["Fly"] = 85.32, ["Ride"] = 52.47, ["Fly|Ride"] = 65.54, ["Neon"] = 16.79, ["Neon|Ride"] = 63.31, ["Neon|Fly|Ride"] = 311.49, ["Mega"] = 283.49, ["Mega|Ride"] = 186.65}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Ride"] = 17.07, ["Fly|Ride"] = 155.97, ["Neon"] = 13.13, ["Neon|Ride"] = 177.07, ["Neon|Fly|Ride"] = 523.79, ["Mega"] = 66.94, ["Mega|Fly"] = 411.49, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 211.03}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 52.5, ["Fly"] = 156.16, ["Ride"] = 104.99, ["Fly|Ride"] = 219.19, ["Neon"] = 165.38, ["Neon|Fly"] = 295.08, ["Neon|Ride"] = 281.65, ["Neon|Fly|Ride"] = 291.37, ["Mega"] = 580.11, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 649.69}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 15.83, ["Ride"] = 15.74, ["Fly|Ride"] = 81.82, ["Neon"] = 2.1, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 16.54, ["Neon|Fly|Ride"] = 43.31, ["Mega"] = 18.38, ["Mega|Ride"] = 41.99, ["Mega|Fly|Ride"] = 86.56}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 3.24, ["Neon|Ride"] = 62.25, ["Neon|Fly|Ride"] = 141.36, ["Mega"] = 22.32, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 3.28, ["Ride"] = 69.95, ["Neon"] = 12.6, ["Neon|Ride"] = 74.82, ["Neon|Fly|Ride"] = 141.4, ["Mega"] = 84.42, ["Mega|Ride"] = 127.93, ["Mega|Fly|Ride"] = 446.78}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 6.22, ["Fly"] = 82.69, ["Ride"] = 46.64, ["Fly|Ride"] = 106.68, ["Neon"] = 21.09, ["Neon|Fly"] = 84.32, ["Neon|Ride"] = 78.73, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 125.97, ["Mega|Fly"] = 202.99, ["Mega|Ride"] = 124.62, ["Mega|Fly|Ride"] = 251.87}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.83, ["Ride"] = 15.7, ["Fly|Ride"] = 91.34, ["Neon"] = 2.1, ["Neon|Fly"] = 23.19, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 74.82, ["Mega"] = 15.74, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 32.72, ["Mega|Fly|Ride"] = 124.51}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 13.13, ["Ride"] = 45.94, ["Neon"] = 52.45, ["Neon|Fly|Ride"] = 206.76, ["Mega|Ride"] = 419.93, ["Mega|Fly|Ride"] = 391.44}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 3160.82, ["Ride"] = 3005.63, ["Fly|Ride"] = 3268.13, ["Neon|Fly|Ride"] = 10500}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 28.35, ["Ride"] = 17.04, ["Fly|Ride"] = 49.51, ["Neon"] = 9.19, ["Neon|Fly"] = 69.09, ["Neon|Ride"] = 25.33, ["Neon|Fly|Ride"] = 66.94, ["Mega"] = 65.63, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 204.62}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 3.66, ["Ride"] = 39.38, ["Neon"] = 11.8, ["Mega"] = 131.25, ["Mega|Ride"] = 422.04, ["Mega|Fly|Ride"] = 166.71}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 19.3, ["Ride"] = 30.13, ["Fly|Ride"] = 157.5, ["Neon"] = 66.67, ["Neon|Ride"] = 121.68, ["Neon|Fly|Ride"] = 281.65, ["Mega"] = 449.48, ["Mega|Ride"] = 286.78, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 50.75, ["Ride"] = 126.47, ["Fly|Ride"] = 141.23, ["Neon"] = 324.63, ["Neon|Fly|Ride"] = 421.94, ["Mega"] = 489.57, ["Mega|Ride"] = 623.44, ["Mega|Fly|Ride"] = 619.34}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 152.39, ["Fly"] = 210.77, ["Ride"] = 181.13, ["Fly|Ride"] = 187.68, ["Neon"] = 697.18, ["Neon|Ride"] = 774.38, ["Neon|Fly|Ride"] = 843.86, ["Mega"] = 6330.39, ["Mega|Ride"] = 3024.89, ["Mega|Fly|Ride"] = 3504.26}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 18.57, ["Ride"] = 26.25, ["Fly|Ride"] = 112.76, ["Neon"] = 15.83, ["Neon|Ride"] = 124.83, ["Neon|Fly|Ride"] = 105.52, ["Mega"] = 800.63, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 63.25, ["Neon"] = 16.46, ["Neon|Fly"] = 94.86, ["Neon|Ride"] = 34.13, ["Mega"] = 89.99, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 819}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.63, ["Fly"] = 101.99, ["Ride"] = 69.65, ["Fly|Ride"] = 78.75, ["Neon"] = 8.4, ["Neon|Ride"] = 39.58, ["Mega"] = 79.68, ["Mega|Ride"] = 143.51, ["Mega|Fly|Ride"] = 287.44}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 12.64, ["Neon"] = 109.58, ["Neon|Ride"] = 172.66, ["Mega"] = 262.5, ["Mega|Ride"] = 280.66, ["Mega|Fly|Ride"] = 607.04}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 69.78, ["Neon"] = 2.1, ["Neon|Ride"] = 42.21, ["Mega"] = 15.73, ["Mega|Ride"] = 133.88}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 83.89, ["Fly"] = 343.79, ["Fly|Ride"] = 168.62, ["Neon"] = 274, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 451.44, ["Mega|Ride"] = 1688.12, ["Mega|Fly|Ride"] = 1615.31}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 32.68, ["Neon"] = 6.34, ["Mega"] = 99.2, ["Mega|Ride"] = 122.07}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 45.82, ["Ride"] = 53.62, ["Neon"] = 265.91, ["Neon|Ride"] = 392.09, ["Neon|Fly|Ride"] = 310.94, ["Mega"] = 2625, ["Mega|Ride"] = 2813.87, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 23.19, ["Fly|Ride"] = 70.63, ["Neon"] = 4.97, ["Neon|Ride"] = 92.16, ["Mega"] = 49.61, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 213.94}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 15.74, ["Mega"] = 70.88, ["Mega|Ride"] = 177.66, ["Mega|Fly|Ride"] = 310.88}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 6.56, ["Ride"] = 48.45, ["Fly|Ride"] = 157.5, ["Neon"] = 45.02, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 689.85, ["Mega"] = 154.05, ["Mega|Ride"] = 287.44, ["Mega|Fly|Ride"] = 452.82}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 380.37, ["Ride"] = 444.33, ["Fly|Ride"] = 498.75, ["Neon"] = 1036.88, ["Neon|Ride"] = 1115.63, ["Neon|Fly|Ride"] = 1177.32, ["Mega"] = 3587.22, ["Mega|Ride"] = 3018.75, ["Mega|Fly|Ride"] = 2884.63}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 38.06, ["Fly"] = 70.63, ["Ride"] = 52.5, ["Fly|Ride"] = 103.69, ["Neon"] = 181.12, ["Neon|Fly"] = 311.2, ["Neon|Ride"] = 186.38, ["Neon|Fly|Ride"] = 311.48, ["Mega|Fly|Ride"] = 903}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 19.95, ["Fly|Ride"] = 91.88, ["Neon"] = 5.25, ["Neon|Fly"] = 137.01, ["Neon|Ride"] = 23.97, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 53, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 281.72}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 9.19, ["Fly"] = 111.56, ["Ride"] = 31.43, ["Fly|Ride"] = 89.12, ["Neon"] = 42, ["Neon|Fly"] = 141.23, ["Neon|Ride"] = 64.4, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 164.07, ["Mega|Fly"] = 371.69, ["Mega|Ride"] = 275.84, ["Mega|Fly|Ride"] = 284.88}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 20.98, ["Ride"] = 25.97, ["Fly|Ride"] = 105.39, ["Neon"] = 105, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 138.2, ["Mega"] = 379.84, ["Mega|Ride"] = 358.74, ["Mega|Fly|Ride"] = 485.34}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 2.41, ["Neon"] = 15.72, ["Neon|Ride"] = 65.63, ["Mega"] = 35.88, ["Mega|Ride"] = 130.41, ["Mega|Fly|Ride"] = 189.93}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 86.63, ["Ride"] = 20.11, ["Fly|Ride"] = 78.73, ["Neon"] = 46.56, ["Neon|Ride"] = 42.21, ["Neon|Fly|Ride"] = 281.65, ["Mega"] = 544.78, ["Mega|Ride"] = 323.92}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 99.75, ["Fly"] = 139.11, ["Ride"] = 125.89, ["Fly|Ride"] = 210, ["Neon"] = 653.37, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 673.37, ["Mega|Ride"] = 2426.66, ["Mega|Fly|Ride"] = 2296.88}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 25.47, ["Ride"] = 78.75, ["Fly|Ride"] = 144, ["Neon"] = 56.91, ["Neon|Ride"] = 281.65, ["Mega"] = 590.63, ["Mega|Ride"] = 711.13, ["Mega|Fly|Ride"] = 708.73}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2887.5, ["Ride"] = 3335.75, ["Fly|Ride"] = 2677.5, ["Neon"] = 12645.41, ["Neon|Ride"] = 7932.43, ["Neon|Fly|Ride"] = 5726.44, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 22.32, ["Fly|Ride"] = 170.63, ["Neon"] = 11.82, ["Neon|Ride"] = 35.88, ["Mega"] = 61.84, ["Mega|Ride"] = 159.43, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 13.11, ["Ride"] = 52.5, ["Fly|Ride"] = 281.38, ["Neon"] = 57.75, ["Neon|Ride"] = 120.75, ["Mega"] = 156.19, ["Mega|Ride"] = 261.37, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 1050, ["Fly"] = 1252.13, ["Ride"] = 984.38, ["Fly|Ride"] = 1039.49, ["Neon"] = 4058.13, ["Neon|Ride"] = 3657.03, ["Neon|Fly|Ride"] = 3018.75, ["Mega|Ride"] = 15976.83, ["Mega|Fly|Ride"] = 11665.01}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 39.38, ["Neon"] = 209.36, ["Mega|Ride"] = 1399.81, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.93, ["Ride"] = 35.44, ["Fly|Ride"] = 52.5, ["Neon"] = 15.74, ["Neon|Ride"] = 69.44, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 249.38, ["Mega|Ride"] = 349.25, ["Mega|Fly|Ride"] = 278.25}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly|Ride"] = 52.5, ["Neon"] = 3.89, ["Mega"] = 24.94, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 125.56}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 82.69, ["Ride"] = 156.19, ["Fly|Ride"] = 656.25, ["Neon"] = 702.89, ["Neon|Ride"] = 406.04, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 2532.16}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 5.25, ["Ride"] = 140.48, ["Neon"] = 17.07, ["Neon|Ride"] = 46.68, ["Mega"] = 170.63, ["Mega|Ride"] = 194.25, ["Mega|Fly|Ride"] = 263.82}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 105, ["Ride"] = 210.77, ["Neon"] = 603.75, ["Mega"] = 2110.14, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 6.57, ["Fly"] = 105, ["Neon"] = 31.46, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 315, ["Mega"] = 224.44}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 258.91, ["Ride"] = 281.38, ["Fly|Ride"] = 360.94, ["Neon|Ride"] = 965.16, ["Neon|Fly|Ride"] = 787.5, ["Mega|Fly|Ride"] = 4025.07}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 2.1, ["Fly"] = 70.29, ["Ride"] = 23.63, ["Fly|Ride"] = 42.16, ["Neon"] = 8.45, ["Neon|Ride"] = 45.89, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 306.81, ["Mega|Ride"] = 280.66, ["Mega|Fly|Ride"] = 350.44}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 20.04, ["Fly|Ride"] = 41.97, ["Neon"] = 3.94, ["Neon|Fly"] = 39.11, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 56.98, ["Mega"] = 39.38, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 128.88}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 859.69, ["Ride"] = 901.69, ["Fly|Ride"] = 951.56, ["Neon|Ride"] = 3907.89, ["Neon|Fly|Ride"] = 3586.35, ["Mega"] = 27996.03, ["Mega|Fly|Ride"] = 28135.37}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 9.08, ["Fly"] = 980.19, ["Ride"] = 40.69, ["Neon"] = 45.83, ["Mega"] = 150.94, ["Mega|Ride"] = 208.92, ["Mega|Fly|Ride"] = 412.79}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 7.55, ["Ride"] = 42.03, ["Fly|Ride"] = 52.5, ["Neon"] = 27.56, ["Neon|Fly"] = 75.89, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 133.98, ["Mega"] = 165.38, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 278.99}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 42, ["Fly"] = 46.14, ["Ride"] = 38.07, ["Fly|Ride"] = 78.75, ["Neon"] = 777.42, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 162.75, ["Mega"] = 2076.38, ["Mega|Fly|Ride"] = 849.54}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 13.13, ["Fly"] = 79.05, ["Ride"] = 27.4, ["Fly|Ride"] = 69.57, ["Neon"] = 82.78, ["Neon|Ride"] = 82.89, ["Neon|Fly|Ride"] = 186.66, ["Mega"] = 466.61, ["Mega|Ride"] = 735, ["Mega|Fly|Ride"] = 439.68}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 26.22, ["Ride"] = 28.47, ["Fly|Ride"] = 636.57, ["Neon"] = 91.87, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 437.87, ["Mega|Ride"] = 494.82, ["Mega|Fly|Ride"] = 455.81}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 105, ["Neon"] = 2.55, ["Neon|Ride"] = 90.72, ["Mega"] = 17.73, ["Mega|Ride"] = 89.25}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 46.37, ["Fly"] = 66.35, ["Ride"] = 47.25, ["Fly|Ride"] = 92.74, ["Neon"] = 578.82, ["Neon|Fly"] = 310.21, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 3376.22, ["Mega|Fly|Ride"] = 844.07}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 3.59, ["Fly"] = 133.54, ["Ride"] = 26.25, ["Fly|Ride"] = 127.32, ["Neon|Ride"] = 141.07, ["Mega"] = 773.07, ["Mega|Ride"] = 271.69}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 25.19, ["Ride"] = 18.38, ["Fly|Ride"] = 68.25, ["Neon"] = 39.38, ["Neon|Fly|Ride"] = 54.85, ["Mega"] = 1042.42, ["Mega|Ride"] = 266.49, ["Mega|Fly|Ride"] = 202.13}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 3.93, ["Neon"] = 105, ["Mega"] = 131.25, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 22.18, ["Fly"] = 262.5, ["Ride"] = 39.38, ["Fly|Ride"] = 70.63, ["Neon"] = 104.57, ["Neon|Ride"] = 116.67, ["Neon|Fly|Ride"] = 210.97, ["Mega"] = 732.22, ["Mega|Ride"] = 999.15, ["Mega|Fly|Ride"] = 759.66}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 8.91, ["Neon"] = 22.16, ["Neon|Ride"] = 39.38, ["Mega"] = 81.68, ["Mega|Fly|Ride"] = 311.48}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 27.18, ["Neon"] = 2.1, ["Neon|Ride"] = 65.63, ["Mega"] = 15.81, ["Mega|Ride"] = 51.19, ["Mega|Fly|Ride"] = 198.85}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Ride"] = 26.13, ["Neon"] = 2.1, ["Neon|Fly"] = 393.65, ["Neon|Ride"] = 33.33, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 15.75, ["Mega|Ride"] = 47.25, ["Mega|Fly|Ride"] = 110.22}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 20.98, ["Fly|Ride"] = 56.65, ["Neon"] = 6.56, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 105, ["Mega"] = 86.63, ["Mega|Ride"] = 168.83, ["Mega|Fly|Ride"] = 178.5}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 5244.89, ["Neon"] = 57.75, ["Neon|Ride"] = 1312.5, ["Mega"] = 141.4, ["Mega|Ride"] = 158.33}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 39.89, ["Ride"] = 17.07, ["Fly|Ride"] = 72.19, ["Neon"] = 22.31, ["Neon|Ride"] = 31.48, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 284.82, ["Mega|Ride"] = 268.42, ["Mega|Fly|Ride"] = 363.56}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 62.85, ["Fly|Ride"] = 394.12, ["Neon"] = 248.71, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 323.84, ["Mega"] = 700.58, ["Mega|Fly"] = 844.07, ["Mega|Ride"] = 945.27, ["Mega|Fly|Ride"] = 735.79}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 26.36, ["Ride"] = 15.74, ["Fly|Ride"] = 36.06, ["Neon"] = 2.1, ["Neon|Fly"] = 72.19, ["Neon|Ride"] = 23.29, ["Neon|Fly|Ride"] = 42.21, ["Mega"] = 30.34, ["Mega|Ride"] = 56.69, ["Mega|Fly|Ride"] = 123.3}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 15.63, ["Fly"] = 65.63, ["Ride"] = 35.43, ["Fly|Ride"] = 119.1, ["Neon"] = 41.97, ["Neon|Fly"] = 54.79, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 115.5, ["Mega"] = 524.99, ["Mega|Ride"] = 281.39, ["Mega|Fly|Ride"] = 340.61}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 11.79, ["Fly"] = 51.19, ["Ride"] = 22.35, ["Fly|Ride"] = 65.63, ["Neon"] = 100.12, ["Neon|Ride"] = 91.01, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 1027.65, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 416.77}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.29, ["Fly"] = 140.38, ["Ride"] = 46.4, ["Neon"] = 17.07, ["Neon|Ride"] = 70.68, ["Mega"] = 150.94, ["Mega|Ride"] = 239.52, ["Mega|Fly|Ride"] = 141.4}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 15.73, ["Fly|Ride"] = 70.63, ["Neon"] = 3.93, ["Neon|Fly"] = 81.38, ["Neon|Ride"] = 21.11, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 39.38, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 61.46, ["Mega|Fly|Ride"] = 152.25}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 14.3, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 210.97, ["Mega"] = 156.33, ["Mega|Fly"] = 735, ["Mega|Ride"] = 141.4, ["Mega|Fly|Ride"] = 374.56}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 971.25, ["Fly"] = 1267.71, ["Ride"] = 984.38, ["Fly|Ride"] = 1023.75, ["Neon"] = 2953.47, ["Neon|Ride"] = 2362.49, ["Neon|Fly|Ride"] = 1967.44, ["Mega|Fly|Ride"] = 7428.75}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 65.63, ["Ride"] = 102.95, ["Fly|Ride"] = 140.44, ["Neon"] = 236.25, ["Neon|Ride"] = 250.69, ["Neon|Fly|Ride"] = 295.43, ["Mega"] = 3164.16, ["Mega|Ride"] = 1266.08, ["Mega|Fly|Ride"] = 1160.25}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly"] = 63.25, ["Ride"] = 70.63, ["Neon"] = 9.24, ["Neon|Ride"] = 74.91, ["Neon|Fly|Ride"] = 315, ["Mega"] = 83.69, ["Mega|Ride"] = 393.75}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 35.43, ["Ride"] = 57.75, ["Fly|Ride"] = 262.5, ["Neon"] = 199.32, ["Neon|Ride"] = 201.75, ["Neon|Fly|Ride"] = 300.57, ["Mega"] = 844.07, ["Mega|Ride"] = 746.82, ["Mega|Fly|Ride"] = 871.49}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 5.25, ["Ride"] = 26.25, ["Neon"] = 46.81, ["Neon|Ride"] = 131.25, ["Mega"] = 376.69, ["Mega|Ride"] = 156.33, ["Mega|Fly|Ride"] = 1055.08}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 303.19, ["Fly"] = 932.26, ["Ride"] = 345.38, ["Fly|Ride"] = 282.19, ["Neon"] = 1326.72, ["Neon|Ride"] = 1273.13, ["Neon|Fly|Ride"] = 1182.57, ["Mega|Fly|Ride"] = 4462.5}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 102.38, ["Ride"] = 22.32, ["Fly|Ride"] = 129.93, ["Neon"] = 14.44, ["Mega"] = 393.75, ["Mega|Fly"] = 281.72}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 104.95, ["Neon|Ride"] = 141.36}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 62.94, ["Fly"] = 52.5, ["Ride"] = 103.69, ["Fly|Ride"] = 210.77, ["Neon"] = 170.63, ["Neon|Ride"] = 309.43, ["Mega"] = 703.74, ["Mega|Ride"] = 1207.34, ["Mega|Fly|Ride"] = 735.32}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 70.86, ["Fly|Ride"] = 141.23, ["Neon"] = 15.83, ["Neon|Ride"] = 212.33, ["Mega"] = 179.38, ["Mega|Ride"] = 225.8, ["Mega|Fly|Ride"] = 422.04}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 23.63, ["Ride"] = 15.74, ["Fly|Ride"] = 32.82, ["Neon"] = 3.49, ["Neon|Fly"] = 31.18, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 40.69, ["Mega"] = 19, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 3933.57, ["Ride"] = 3937.5, ["Fly|Ride"] = 4198.68, ["Neon"] = 25290.81, ["Neon|Fly|Ride"] = 19163.82, ["Mega|Fly|Ride"] = 78917.66}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 10.5, ["Ride"] = 50.59, ["Neon"] = 47.25, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 168.78, ["Mega"] = 261.19, ["Mega|Ride"] = 352.41, ["Mega|Fly|Ride"] = 336}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.43, ["Ride"] = 24.94, ["Fly|Ride"] = 47.2, ["Neon"] = 15.72, ["Neon|Fly"] = 46.64, ["Neon|Ride"] = 33.45, ["Neon|Fly|Ride"] = 105.02, ["Mega"] = 284.88, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 207.64}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 409.24, ["Fly"] = 840, ["Ride"] = 480.22, ["Fly|Ride"] = 532.41, ["Neon"] = 1686.06, ["Neon|Ride"] = 1356.7, ["Neon|Fly|Ride"] = 1278.38, ["Mega|Fly|Ride"] = 5537.4}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 4.25, ["Ride"] = 31.5, ["Neon"] = 17.52, ["Neon|Ride"] = 291.38, ["Mega"] = 144.38, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.78, ["Fly"] = 85.52, ["Ride"] = 78.08, ["Neon"] = 59.07, ["Neon|Ride"] = 281.65, ["Neon|Fly|Ride"] = 14064.82, ["Mega"] = 281.72, ["Mega|Ride"] = 360.94}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.69, ["Neon"] = 5.25, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 101.07, ["Mega"] = 38.98, ["Mega|Ride"] = 64.26}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 597.19, ["Ride"] = 654.31, ["Fly|Ride"] = 726.75, ["Neon|Ride"] = 2109.63, ["Neon|Fly|Ride"] = 2167.11, ["Mega|Fly|Ride"] = 8751.75}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 7.65, ["Ride"] = 65.63, ["Neon"] = 24.94, ["Neon|Fly"] = 75.89, ["Neon|Ride"] = 75.96, ["Neon|Fly|Ride"] = 643.13, ["Mega"] = 114.19, ["Mega|Ride"] = 220.38, ["Mega|Fly|Ride"] = 289.65}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 15.74, ["Fly"] = 236.25, ["Ride"] = 52.5, ["Fly|Ride"] = 168.62, ["Neon"] = 39.38, ["Neon|Ride"] = 70.61, ["Neon|Fly|Ride"] = 141.36, ["Mega"] = 251.5, ["Mega|Ride"] = 246.75, ["Mega|Fly|Ride"] = 333.38}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 22.46, ["Fly|Ride"] = 56.91, ["Neon"] = 10.48, ["Neon|Fly"] = 141.23, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 70.3, ["Mega"] = 131.25, ["Mega|Fly"] = 225.8, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 210.1}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 32.68, ["Ride"] = 62.3, ["Fly|Ride"] = 116.57, ["Neon"] = 122.26, ["Mega"] = 527.55, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 526.32}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly|Ride"] = 2041.45, ["Mega"] = 49.61, ["Mega|Ride"] = 95.67, ["Mega|Fly|Ride"] = 169.32}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 511.88, ["Ride"] = 565.69, ["Fly|Ride"] = 682.5, ["Neon"] = 2081.23, ["Neon|Ride"] = 1977.77, ["Neon|Fly|Ride"] = 1850.3, ["Mega|Ride"] = 9098.72, ["Mega|Fly|Ride"] = 7848.75}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 40.61, ["Neon"] = 10.5, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 156.33, ["Mega"] = 35.88, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 315.63}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 28.46, ["Neon"] = 4.24, ["Neon|Ride"] = 172.38, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 34.13, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 63.04, ["Mega"] = 32.82, ["Mega|Fly"] = 156.16, ["Mega|Ride"] = 105.39, ["Mega|Fly|Ride"] = 167.37}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 3.93, ["Ride"] = 68.25, ["Neon"] = 15.73, ["Mega|Ride"] = 373.3}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 53.52, ["Ride"] = 118.93, ["Fly|Ride"] = 156.19, ["Neon"] = 154.87, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 344.93, ["Mega"] = 669.38, ["Mega|Ride"] = 625.58, ["Mega|Fly|Ride"] = 654.93}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 14.36, ["Ride"] = 280.32, ["Fly|Ride"] = 262.5, ["Neon"] = 107.63, ["Neon|Ride"] = 189.09, ["Mega"] = 479.01, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 488.24}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 3.94, ["Fly"] = 34.65, ["Ride"] = 16.37, ["Fly|Ride"] = 36.15, ["Neon"] = 24.94, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 84.4, ["Mega"] = 301.88, ["Mega|Ride"] = 222.69, ["Mega|Fly|Ride"] = 233.31}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 11.67, ["Ride"] = 39.38, ["Neon"] = 141.23, ["Neon|Ride"] = 158.82, ["Mega"] = 422.04, ["Mega|Fly|Ride"] = 519.1}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 33.73, ["Ride"] = 28.29, ["Fly|Ride"] = 362.25, ["Neon"] = 13.13, ["Neon|Ride"] = 79.12, ["Mega"] = 105, ["Mega|Ride"] = 139.99, ["Mega|Fly|Ride"] = 211.03}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 32.68, ["Fly"] = 65.63, ["Ride"] = 66.4, ["Fly|Ride"] = 65.35, ["Neon"] = 250.82, ["Neon|Ride"] = 527.42, ["Neon|Fly|Ride"] = 208, ["Mega"] = 948.51, ["Mega|Ride"] = 933.21, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 62.95, ["Fly"] = 874.13, ["Neon"] = 311.2, ["Neon|Fly"] = 170.63, ["Neon|Ride"] = 328.13}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 45.94, ["Fly"] = 115.5, ["Ride"] = 72.17, ["Fly|Ride"] = 144.38, ["Neon"] = 290.07, ["Neon|Ride"] = 351.75, ["Neon|Fly|Ride"] = 367.08, ["Mega|Ride"] = 1649.44, ["Mega|Fly|Ride"] = 1650.13}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 64.1, ["Fly"] = 126.1, ["Ride"] = 102.24, ["Fly|Ride"] = 131.25, ["Neon"] = 168.53, ["Neon|Ride"] = 315.4, ["Neon|Fly|Ride"] = 315.4, ["Mega"] = 630, ["Mega|Ride"] = 674.21, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 21.08, ["Ride"] = 77.99, ["Neon"] = 421.53, ["Neon|Ride"] = 252, ["Mega"] = 1049.99, ["Mega|Ride"] = 738.56, ["Mega|Fly|Ride"] = 1265.03}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 4.73, ["Ride"] = 36.15, ["Fly|Ride"] = 107.25, ["Neon"] = 26.93, ["Neon|Fly"] = 168.62, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 224.44, ["Mega"] = 492.73, ["Mega|Ride"] = 345.18, ["Mega|Fly|Ride"] = 343.77}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 28.47, ["Ride"] = 15.83, ["Fly|Ride"] = 41.68, ["Neon"] = 5.25, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 72.34, ["Mega"] = 45.94, ["Mega|Ride"] = 48.57, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1311.19}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 26.21, ["Ride"] = 80.07, ["Fly|Ride"] = 262.5, ["Neon"] = 92.93, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 314.73, ["Mega"] = 563.41, ["Mega|Ride"] = 518.44, ["Mega|Fly|Ride"] = 437.35}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 56.48, ["Neon"] = 3.84, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 293.86, ["Mega"] = 39.38, ["Mega|Ride"] = 84.96, ["Mega|Fly|Ride"] = 141.4}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 22.31, ["Ride"] = 82.22, ["Fly|Ride"] = 281.38, ["Neon"] = 78.75, ["Neon|Ride"] = 414.74, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 703.74, ["Mega|Ride"] = 620.39, ["Mega|Fly|Ride"] = 645.71}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Mega"] = 18.9}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Neon|Ride"] = 87.5, ["Mega"] = 24.68, ["Mega|Ride"] = 126.62, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 125.29, ["Ride"] = 137.82, ["Fly|Ride"] = 343.54, ["Neon"] = 589.04, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 637.34, ["Mega|Ride"] = 6415.77, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 23.62, ["Fly|Ride"] = 88.53, ["Neon"] = 11.42, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 86.51, ["Mega"] = 107.58, ["Mega|Ride"] = 156.33, ["Mega|Fly|Ride"] = 451.44}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 34.92, ["Fly|Ride"] = 65.63, ["Neon"] = 6.06, ["Neon|Ride"] = 28.49, ["Neon|Fly|Ride"] = 419.99, ["Mega"] = 34.94, ["Mega|Ride"] = 124.95}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 31.47, ["Neon"] = 5.25, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.44, ["Mega"] = 31.5, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 91.88, ["Neon"] = 8.45, ["Neon|Ride"] = 21, ["Mega"] = 28.5, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 31.48, ["Ride"] = 86.63, ["Fly|Ride"] = 622.4, ["Neon"] = 280.08, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1125.76, ["Mega|Fly|Ride"] = 1245.39}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.66, ["Ride"] = 23.63, ["Fly|Ride"] = 78.11, ["Neon"] = 21, ["Neon|Ride"] = 111.57, ["Mega"] = 140.6, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 337.64}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 300.57, ["Ride"] = 459.38, ["Fly|Ride"] = 606.3, ["Neon"] = 1759.94, ["Neon|Ride"] = 1171.22, ["Neon|Fly|Ride"] = 1030.52, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 66.94}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 39.25}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 15.73}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 23.47}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 43.23}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 53.82}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 10.45}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 6.22}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 216.56}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 22.3}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 39.31}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 9.45}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 18.38}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 918.75}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 10.5}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 6.57}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 5.25}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 18.38}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 501.04}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 689.19}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 17.05}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1064.44}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 250.69}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 11.82}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 34.13}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.63}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 3.93}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 49.9}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 62.99}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 46.83}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 15.75}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 7.87}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 18.87}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.93}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 17.07}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.1}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 27.57}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 27.24}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 5.24}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1259.99}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 111.57}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 280.38}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 3.91}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 10.21}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 39.31}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 180.22}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 143.04}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 10.49}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 32.82}},
    ["rbxassetid://1265129435"] = {name = "Gold Snowboard", prices = {["default"] = 210}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 210.46}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 13.1}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 3.93}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 12.69}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 7.07}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 3.07}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 141.23}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 27.49}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 7.83}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 33.73}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.33}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 9.85}},
    ["rbxassetid://1265129203"] = {name = "Ice Snowboard", prices = {["default"] = 164.07}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 4.66}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 19.69}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 115.74}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 91.87}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 3.52}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 9.19}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 16.31}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 26.24}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 65.62}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 39.19}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22140.75}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 170.63}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 27.57}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 44.09}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 30.19}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 139.13}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 25.7}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 39.38}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 74.11}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 119.44}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 157.5}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 35.44}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 26.24}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 39.35}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 40.65}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 131.25}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 15.81}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 9.45}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 5.25}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 6.23}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 28.02}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 44.62}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.67}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 3.92}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 5.85}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 745.5}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 12.67}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 583.51}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 26.24}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 262.5}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 28.71}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 42}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 32.81}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 104.4}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 28.88}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 8.45}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 15.73}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 7.01}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 3.93}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 40.95}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.87}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.42}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.94}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 12.64}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 190.11}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 36.75}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 98.44}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 10.03}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 7.96}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 52.5}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 12.86}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 90.39}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 14.42}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 6.57}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 14.32}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 11.79}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 127.32}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 36.75}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 8.16}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 3.93}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 12.84}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 3.94}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 8.34}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 14.42}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 4.24}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 5.76}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 21.27}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.28}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 3.67}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.92}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 3.93}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7362.8}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 18.36}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 10.54}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 5.13}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 4.69}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 26.87}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 13.13}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 5.36}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 14.42}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 118.01}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 11.81}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 8.38}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 3.92}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 8.14}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 5.86}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 3.67}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.44}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4352.42}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 209.99}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 41.25}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 4.24}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.75}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 81.38}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.49}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 6.57}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 182.28}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.61}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 3.94}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 2.61}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.63}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 3.94}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 10.89}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 23.5}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.59}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.44}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.61}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 11.69}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 5.62}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 3.93}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 9.18}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 8.45}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.46}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.57}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 4.47}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 3.66}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 131.25}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.56}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 19.69}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 5.86}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.51}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 13.13}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 111.56}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 31.17}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 2.35}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1077.38}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 15.74}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 3.94}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 27.98}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 3.68}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 6.35}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 10.31}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 15.61}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 28.47}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 16.1}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.55}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 8.45}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 5.25}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.7}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 22.32}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.68}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.63}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 13.11}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 4.56}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 10.5}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 15.37}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.37}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 6.57}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 399}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 62.94}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 3.94}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 26.14}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 13.13}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 6.57}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 90.57}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 3.34}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 6.33}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 7.86}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 3.56}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.61}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 4.64}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 8.9}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 75.93}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 3.94}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 86.63}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 5.25}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1109.07}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 196.87}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 5.92}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 5.25}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.52}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.55}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 15.75}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 41.73}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 3.82}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 2.23}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 3.94}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 65.61}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 6.5}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.59}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.45}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 10.5}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 3.94}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 65.62}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 54.73}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.63}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 4.6}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.52}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 23.63}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 118.13}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.23}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.61}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.28}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 55.94}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 5.25}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.94}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 5.09}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 73.71}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.63}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 27.53}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 52.5}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 362.22}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 47.25}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.63}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 104.14}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.37}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 13.13}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 58.7}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 15.69}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 9.12}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 14.84}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.55}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 19.67}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 7.88}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 3.93}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 5.25}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 31.5}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 48.57}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 3.12}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 26.22}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 4.72}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 3.89}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 39.37}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 45.92}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 34.13}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1401.16}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 16.99}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 7.46}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 28.46}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 247.01}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 20.88}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 6.02}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 11.68}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 5.09}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 221.82}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 72.27}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 44.54}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 10.55}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 3.94}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 66.94}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 111.57}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 85.32}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 943.69}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 199.5}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 9.17}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1057.4}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 525}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 3}},
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