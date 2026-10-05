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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 984.38, ["Ride"] = 1179.93, ["Fly|Ride"] = 1758.41, ["Neon"] = 6855.19, ["Neon|Fly|Ride"] = 5114.55, ["Mega"] = 21917.93, ["Mega|Fly|Ride"] = 21917.93}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 635.63, ["Fly"] = 754.8, ["Ride"] = 530.25, ["Fly|Ride"] = 662.5, ["Neon|Fly|Ride"] = 1837.5, ["Mega"] = 10958.97, ["Mega|Fly|Ride"] = 8563.34}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 5092.5, ["Ride"] = 5250, ["Fly|Ride"] = 4976.7, ["Neon|Fly|Ride"] = 20749.71, ["Mega|Fly|Ride"] = 77443.68}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 203.44, ["Ride"] = 245.86, ["Fly|Ride"] = 411.04, ["Neon"] = 1161.42, ["Neon|Ride"] = 984.38, ["Neon|Fly|Ride"] = 1103.82, ["Mega|Fly|Ride"] = 4963.74}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 632.63, ["Fly"] = 879.21, ["Ride"] = 656.25, ["Fly|Ride"] = 636.56, ["Neon|Fly|Ride"] = 1616.99, ["Mega|Fly|Ride"] = 5250}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 11.43, ["Ride"] = 59.07, ["Fly|Ride"] = 129.94, ["Neon"] = 96.73, ["Neon|Fly"] = 292.62, ["Neon|Ride"] = 98.33, ["Neon|Fly|Ride"] = 219.19, ["Mega"] = 357.33, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 598.5}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.12, ["Fly"] = 43.86, ["Ride"] = 24.86, ["Fly|Ride"] = 70.88, ["Neon"] = 29.6, ["Neon|Fly"] = 132.75, ["Neon|Ride"] = 57.9, ["Neon|Fly|Ride"] = 102.38, ["Mega"] = 231, ["Mega|Fly"] = 275.63, ["Mega|Ride"] = 195.56, ["Mega|Fly|Ride"] = 876.72}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 93.19, ["Fly"] = 198.97, ["Ride"] = 141.75, ["Fly|Ride"] = 236.25, ["Neon"] = 425.25, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 1753.44, ["Mega"] = 1586.82, ["Mega|Ride"] = 2492.44, ["Mega|Fly|Ride"] = 1848.79}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 33.99, ["Fly"] = 90.96, ["Ride"] = 38.37, ["Fly|Ride"] = 105, ["Neon"] = 275.63, ["Neon|Ride"] = 233.57, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 2100, ["Mega|Ride"] = 1169.35, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 25.89, ["Fly"] = 87.94, ["Ride"] = 38.07, ["Fly|Ride"] = 76.72, ["Neon"] = 149.23, ["Neon|Fly"] = 83.32, ["Neon|Ride"] = 131.9, ["Neon|Fly|Ride"] = 210.42, ["Mega"] = 657.56, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 79.26, ["Ride"] = 129.68, ["Fly|Ride"] = 197.36, ["Neon"] = 402.81, ["Neon|Ride"] = 321.57, ["Neon|Fly|Ride"] = 1520.03, ["Mega"] = 1575, ["Mega|Ride"] = 1443.75}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 69.57}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 350.7, ["Fly"] = 396.4, ["Ride"] = 300.57, ["Fly|Ride"] = 406.88, ["Neon|Fly"] = 1483.67, ["Neon|Ride"] = 1753.44, ["Neon|Fly|Ride"] = 1534.28, ["Mega|Fly|Ride"] = 5043.94}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 137.75, ["Fly"] = 164.48, ["Ride"] = 152.7, ["Fly|Ride"] = 183.75, ["Neon|Fly"] = 696.35, ["Neon|Fly|Ride"] = 577.5, ["Mega"] = 4312.63, ["Mega|Fly|Ride"] = 2467.5}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.69, ["Fly"] = 80.66, ["Ride"] = 65.62, ["Neon"] = 29.79, ["Neon|Ride"] = 132.8, ["Neon|Fly|Ride"] = 265.22, ["Mega"] = 162.22, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 336.46, ["Mega|Fly|Ride"] = 485.49}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 223.13, ["Fly"] = 310.95, ["Ride"] = 288.24, ["Fly|Ride"] = 274.31, ["Neon"] = 1022.46, ["Neon|Ride"] = 1161.42, ["Neon|Fly|Ride"] = 918.65, ["Mega|Fly|Ride"] = 2750.81}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.61, ["Fly"] = 39.48, ["Ride"] = 19.28, ["Fly|Ride"] = 42.14, ["Neon"] = 43.32, ["Neon|Fly"] = 131.52, ["Neon|Ride"] = 81.99, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 170.63, ["Mega|Ride"] = 292.62, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 163.96, ["Fly"] = 333.62, ["Ride"] = 210, ["Fly|Ride"] = 361.62, ["Neon"] = 525, ["Neon|Ride"] = 597.32, ["Neon|Fly|Ride"] = 715.32, ["Mega"] = 1820.46, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 1559.25}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 43.31}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 73.5, ["Ride"] = 157.83, ["Fly|Ride"] = 326.17, ["Neon"] = 459.38, ["Neon|Fly|Ride"] = 787.5, ["Mega|Fly|Ride"] = 1835.64}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 34, ["Fly"] = 393.74, ["Ride"] = 59.07, ["Fly|Ride"] = 118.13, ["Neon"] = 262.5, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 429.19, ["Mega"] = 2854.95, ["Mega|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 1023.59}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 36.66, ["Fly"] = 109.92, ["Ride"] = 57.28, ["Fly|Ride"] = 112.67, ["Neon"] = 170.52, ["Neon|Ride"] = 193.94, ["Neon|Fly|Ride"] = 280.64, ["Mega"] = 1737.65, ["Mega|Fly|Ride"] = 904.61}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 40.17, ["Fly"] = 254.69, ["Ride"] = 85.32, ["Fly|Ride"] = 196.88, ["Neon"] = 249.38, ["Neon|Ride"] = 409.88, ["Neon|Fly|Ride"] = 499.16, ["Mega"] = 1967.44, ["Mega|Ride"] = 1753.44, ["Mega|Fly|Ride"] = 1578.1}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 32.82, ["Ride"] = 14.7, ["Fly|Ride"] = 127.5, ["Neon"] = 210, ["Neon|Ride"] = 162.75, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 1207.92, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 51.98, ["Fly"] = 82.45, ["Ride"] = 65.63, ["Fly|Ride"] = 115.5, ["Neon"] = 258.32, ["Neon|Ride"] = 366.03, ["Neon|Fly|Ride"] = 304.5, ["Mega|Ride"] = 1159.26, ["Mega|Fly|Ride"] = 937.13}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 7.23, ["Fly"] = 36.75, ["Ride"] = 23.63, ["Fly|Ride"] = 57.75, ["Neon"] = 42, ["Neon|Fly"] = 412.12, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 100.95, ["Mega"] = 314.54, ["Mega|Fly"] = 29260.43, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 287.12}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 452.82, ["Ride"] = 485.62, ["Fly|Ride"] = 498.75, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1966.13, ["Mega"] = 10958.97, ["Mega|Fly|Ride"] = 9847.41}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 14.21, ["Ride"] = 31.49, ["Fly|Ride"] = 136.28, ["Neon"] = 219.19, ["Neon|Fly|Ride"] = 447.15, ["Mega|Ride"] = 585.22, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 4.83, ["Fly"] = 43.23, ["Ride"] = 20.99, ["Fly|Ride"] = 45.94, ["Neon"] = 64.96, ["Neon|Ride"] = 49.64, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 324.19, ["Mega|Ride"] = 315.1, ["Mega|Fly|Ride"] = 378}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 69.57, ["Fly"] = 116.89, ["Ride"] = 76.13, ["Fly|Ride"] = 131.25, ["Neon"] = 438.52, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 400.31, ["Mega"] = 6577.54, ["Mega|Ride"] = 5832.75, ["Mega|Fly|Ride"] = 1607.7}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 14.34, ["Ride"] = 34.47, ["Fly|Ride"] = 66.94, ["Neon"] = 81.99, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 270.57, ["Mega"] = 720.57, ["Mega|Ride"] = 744.58, ["Mega|Fly|Ride"] = 567.69}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 242.82, ["Fly"] = 300.68, ["Ride"] = 271.87, ["Fly|Ride"] = 335.97, ["Neon"] = 813.24, ["Neon|Ride"] = 623.44, ["Neon|Fly|Ride"] = 752.46, ["Mega"] = 6575.39, ["Mega|Ride"] = 3937.49, ["Mega|Fly|Ride"] = 2928.61}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 23.54}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 2.41, ["Fly"] = 28.28, ["Ride"] = 24.51, ["Fly|Ride"] = 59.07, ["Neon"] = 28.88, ["Neon|Fly"] = 146.87, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 131.52, ["Mega"] = 234.54, ["Mega|Fly"] = 496.52, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 1076.25, ["Ride"] = 1162.44, ["Fly|Ride"] = 1168.13, ["Neon"] = 9187.5, ["Neon|Ride"] = 5250, ["Neon|Fly|Ride"] = 6552.13, ["Mega|Ride"] = 55857.5, ["Mega|Fly|Ride"] = 24657.67}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 20.9, ["Fly"] = 103.24, ["Ride"] = 52.5, ["Fly|Ride"] = 105.99, ["Neon"] = 208.82, ["Neon|Ride"] = 166.2, ["Neon|Fly|Ride"] = 287.67, ["Mega"] = 1043.44, ["Mega|Ride"] = 1125.51, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 195.57, ["Fly"] = 373.06, ["Ride"] = 249.38, ["Fly|Ride"] = 311.85, ["Neon"] = 945, ["Neon|Ride"] = 978.8, ["Neon|Fly|Ride"] = 1030.32, ["Mega"] = 4267.44, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 4042.78}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 36.75}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 15.64, ["Fly"] = 86.8, ["Ride"] = 119.44, ["Fly|Ride"] = 147.28, ["Neon"] = 104.99, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 414.57, ["Mega"] = 592.55, ["Mega|Ride"] = 585.22, ["Mega|Fly|Ride"] = 662.67}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 133.77, ["Fly"] = 167.23, ["Ride"] = 144.08, ["Fly|Ride"] = 223.13, ["Neon"] = 484.67, ["Neon|Ride"] = 548.42, ["Neon|Fly|Ride"] = 585.22, ["Mega|Ride"] = 2318.51, ["Mega|Fly|Ride"] = 1811.24}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 118.13, ["Fly"] = 253.88, ["Ride"] = 164.07, ["Fly|Ride"] = 240.19, ["Neon"] = 427.8, ["Neon|Fly"] = 827.87, ["Neon|Ride"] = 443.63, ["Neon|Fly|Ride"] = 498.75, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1481.76}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 43.26}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 51.16, ["Fly"] = 63, ["Ride"] = 49.88, ["Fly|Ride"] = 81.38, ["Neon|Ride"] = 538.13, ["Neon|Fly|Ride"] = 372.75, ["Mega"] = 4383.61, ["Mega|Fly|Ride"] = 1509.27}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 7.77, ["Ride"] = 57.66, ["Fly|Ride"] = 207.38, ["Neon"] = 52.77, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 146.87, ["Neon|Fly|Ride"] = 242.17, ["Mega"] = 366.03, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 416.07}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 583.03, ["Ride"] = 625.16, ["Fly|Ride"] = 682.5, ["Neon|Fly"] = 3945.24, ["Neon|Ride"] = 1903.13, ["Neon|Fly|Ride"] = 2118.38, ["Mega|Ride"] = 15342.55, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 118.12, ["Fly"] = 166.64, ["Ride"] = 131.22, ["Fly|Ride"] = 203.34, ["Neon"] = 525, ["Neon|Ride"] = 431.82, ["Neon|Fly|Ride"] = 549.94, ["Mega|Fly|Ride"] = 2296.88}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3804.94, ["Ride"] = 3885, ["Fly|Ride"] = 3937.5}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 81.37, ["Fly"] = 234.54, ["Ride"] = 106.97, ["Fly|Ride"] = 201.68, ["Neon"] = 664.02, ["Neon|Ride"] = 459.38, ["Mega|Ride"] = 2191.82, ["Mega|Fly|Ride"] = 2084.25}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 84, ["Fly"] = 328.13, ["Ride"] = 81.12, ["Fly|Ride"] = 105, ["Neon"] = 575.75, ["Neon|Ride"] = 367.07, ["Neon|Fly|Ride"] = 507.42, ["Mega"] = 6429.64, ["Mega|Ride"] = 2388.75, ["Mega|Fly|Ride"] = 2542.5}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 31.54, ["Fly"] = 50.79, ["Ride"] = 41.99, ["Fly|Ride"] = 102.52, ["Neon"] = 152.24, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 2625, ["Mega|Ride"] = 937, ["Mega|Fly|Ride"] = 611.61}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 6.57}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 43.32, ["Fly"] = 52.5, ["Ride"] = 66.91, ["Fly|Ride"] = 132.82, ["Neon|Ride"] = 331.34, ["Neon|Fly|Ride"] = 446.25, ["Mega|Ride"] = 1324.1, ["Mega|Fly|Ride"] = 1384.14}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 34.01}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 185.07, ["Ride"] = 236.23, ["Fly|Ride"] = 282.19, ["Neon"] = 1172.64, ["Neon|Ride"] = 1159.04, ["Neon|Fly|Ride"] = 1312.9, ["Mega|Fly|Ride"] = 4963.74}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 689.07, ["Ride"] = 754.69, ["Fly|Ride"] = 708.74, ["Neon|Ride"] = 3067.43, ["Neon|Fly|Ride"] = 2846.31, ["Mega|Fly|Ride"] = 10028.82}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 7.77}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 33.37, ["Fly"] = 65.54, ["Ride"] = 39.79, ["Fly|Ride"] = 66.93, ["Neon"] = 210, ["Neon|Fly"] = 285.75, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 220.5, ["Mega|Ride"] = 1191.31, ["Mega|Fly|Ride"] = 766.49}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 24.29}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 6164.82, ["Fly"] = 7327.02, ["Ride"] = 6048.65, ["Fly|Ride"] = 4811.63, ["Neon|Ride"] = 18205.43, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 32156.25}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 9.19, ["Fly"] = 147.28, ["Ride"] = 27.54, ["Fly|Ride"] = 58.47, ["Neon"] = 129.93, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 157.4, ["Mega"] = 561.75, ["Mega|Ride"] = 446.24, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 15.65, ["Fly"] = 73.64, ["Ride"] = 35.44, ["Fly|Ride"] = 138.5, ["Neon"] = 95.82, ["Neon|Ride"] = 143.58, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 986.32, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 66.94, ["Fly"] = 116.51, ["Ride"] = 112.11, ["Fly|Ride"] = 105, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 490.73, ["Mega"] = 4383.61, ["Mega|Fly|Ride"] = 1820.46}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 12.98, ["Fly"] = 73.64, ["Ride"] = 32.82, ["Fly|Ride"] = 78.75, ["Neon"] = 101.07, ["Neon|Fly"] = 219.81, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 501.38, ["Mega"] = 561.11, ["Mega|Ride"] = 811.58, ["Mega|Fly|Ride"] = 800.63}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1706.25, ["Fly"] = 2426.32, ["Ride"] = 2080.02, ["Fly|Ride"] = 1756.13, ["Neon|Fly|Ride"] = 3017.44, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 24937.5, ["Fly"] = 35654.99, ["Ride"] = 33849.11, ["Fly|Ride"] = 24412.5, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 63000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 18.37, ["Fly"] = 393.75, ["Ride"] = 54.99, ["Fly|Ride"] = 120.75, ["Neon"] = 158.36, ["Neon|Ride"] = 166.29, ["Neon|Fly|Ride"] = 292.62, ["Mega"] = 1050, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1556.44}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.61, ["Fly"] = 52.5, ["Ride"] = 42, ["Fly|Ride"] = 162.22, ["Neon"] = 23.51, ["Neon|Fly"] = 231.69, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 131.25, ["Mega|Fly"] = 254.63, ["Mega|Ride"] = 247.69, ["Mega|Fly|Ride"] = 337.32}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 26}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 6.27, ["Ride"] = 37.34, ["Fly|Ride"] = 164.59, ["Neon"] = 72.75, ["Neon|Ride"] = 108.94, ["Neon|Fly|Ride"] = 277.1, ["Mega"] = 436.19, ["Mega|Ride"] = 424.13, ["Mega|Fly|Ride"] = 560.01}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 622.13, ["Fly"] = 879.21, ["Ride"] = 656.25, ["Fly|Ride"] = 728.74, ["Neon"] = 3145.42, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2296.88, ["Mega|Fly|Ride"] = 9184.64}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 787.5, ["Fly"] = 951.57, ["Ride"] = 853.13, ["Fly|Ride"] = 993.29, ["Neon|Fly|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 13898.45}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 15.23, ["Fly"] = 124.36, ["Ride"] = 36.74, ["Fly|Ride"] = 103.32, ["Neon"] = 87.94, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 510.69, ["Mega|Ride"] = 481.9, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 28.87}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 94.25, ["Fly"] = 128.34, ["Ride"] = 114.2, ["Fly|Ride"] = 144.38, ["Neon"] = 576.84, ["Neon|Ride"] = 426.57, ["Neon|Fly|Ride"] = 420, ["Mega"] = 19687.5, ["Mega|Ride"] = 2047.15, ["Mega|Fly|Ride"] = 2149.07}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 64.79, ["Fly"] = 105, ["Ride"] = 103.32, ["Fly|Ride"] = 157.5, ["Neon"] = 450.19, ["Neon|Ride"] = 529.33, ["Neon|Fly|Ride"] = 509.15, ["Mega"] = 1426.2, ["Mega|Fly|Ride"] = 2180.76}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.67, ["Fly"] = 35.81, ["Ride"] = 19.59, ["Fly|Ride"] = 59.06, ["Neon"] = 51.01, ["Neon|Fly"] = 488.69, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 116.66, ["Mega"] = 272.87, ["Mega|Fly|Ride"] = 349.44}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 196.87, ["Fly"] = 224.42, ["Ride"] = 217.59, ["Fly|Ride"] = 309.07, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 5260.32, ["Mega|Fly|Ride"] = 2821.88}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 6.59, ["Ride"] = 50.91, ["Fly|Ride"] = 129.94, ["Neon"] = 47.25, ["Neon|Ride"] = 105, ["Mega"] = 273.99, ["Mega|Fly"] = 1137.94, ["Mega|Ride"] = 278.69, ["Mega|Fly|Ride"] = 454.81}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 18.52, ["Fly"] = 65.63, ["Ride"] = 32.81, ["Fly|Ride"] = 90.95, ["Neon"] = 131.24, ["Neon|Fly"] = 331.41, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 841.66}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 28.88, ["Ride"] = 57.75, ["Fly|Ride"] = 156.19, ["Neon"] = 249.25, ["Neon|Ride"] = 219.19, ["Mega"] = 997.5, ["Mega|Ride"] = 853.13, ["Mega|Fly|Ride"] = 1011.85}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 18.12, ["Fly"] = 90.14, ["Ride"] = 41.99, ["Fly|Ride"] = 85.32, ["Neon"] = 131.25, ["Neon|Ride"] = 326.72, ["Neon|Fly|Ride"] = 350.7, ["Mega"] = 1095.91, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6813.8, ["Ride"] = 5643.75, ["Fly|Ride"] = 5767.13, ["Neon"] = 32969.9, ["Neon|Fly|Ride"] = 30539.34}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 226.59, ["Fly"] = 259.88, ["Ride"] = 234.93, ["Fly|Ride"] = 297.94, ["Neon|Fly|Ride"] = 645.08, ["Mega|Fly|Ride"] = 2231.24}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 65.49, ["Fly"] = 161.34, ["Ride"] = 120.37, ["Fly|Ride"] = 311.26, ["Neon"] = 207.38, ["Neon|Ride"] = 276.98, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 627.27, ["Mega|Ride"] = 544.69, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.48, ["Fly"] = 65.63, ["Ride"] = 35.09, ["Fly|Ride"] = 81.37, ["Neon"] = 24.94, ["Neon|Ride"] = 52.62, ["Neon|Fly|Ride"] = 195.88, ["Mega"] = 499.8, ["Mega|Ride"] = 330.75, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 63, ["Fly"] = 215.34, ["Ride"] = 125.99, ["Fly|Ride"] = 222.18, ["Neon"] = 220.5, ["Neon|Ride"] = 246.75, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 522.38, ["Mega|Fly"] = 745.23, ["Mega|Ride"] = 519.74, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 16485, ["Ride"] = 13415.07, ["Fly|Ride"] = 11679.94, ["Neon|Fly|Ride"] = 24766.88, ["Mega|Fly|Ride"] = 109443.83}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 380.62, ["Ride"] = 406.7, ["Fly|Ride"] = 504, ["Neon|Ride"] = 2170.54, ["Neon|Fly|Ride"] = 1900.31, ["Mega"] = 8749.13}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 56.44, ["Fly"] = 64.97, ["Ride"] = 59.07, ["Fly|Ride"] = 108.29, ["Neon"] = 301.88, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 389.81, ["Mega|Fly|Ride"] = 2044.96}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 8.57, ["Ride"] = 23.62, ["Fly|Ride"] = 72.12, ["Neon"] = 69.21, ["Neon|Fly"] = 281.76, ["Neon|Ride"] = 78.72, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 469.06, ["Mega|Ride"] = 744.58, ["Mega|Fly|Ride"] = 585.22}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 393.75, ["Ride"] = 420.96, ["Fly|Ride"] = 467.23, ["Neon"] = 1253.44, ["Neon|Ride"] = 1442.44, ["Neon|Fly|Ride"] = 1312.49, ["Mega|Fly|Ride"] = 4547.82}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 7.88, ["Fly"] = 103.32, ["Ride"] = 43.31, ["Fly|Ride"] = 226.41, ["Neon"] = 35.07, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 189, ["Mega"] = 119.56, ["Mega|Ride"] = 219.19, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 118.01, ["Fly"] = 172.23, ["Ride"] = 131.23, ["Fly|Ride"] = 227.07, ["Neon"] = 465.94, ["Neon|Fly"] = 525, ["Neon|Ride"] = 483.37, ["Neon|Fly|Ride"] = 550.99, ["Mega"] = 2630.16, ["Mega|Fly|Ride"] = 2430.18}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 14.19, ["Fly"] = 22.32, ["Ride"] = 19.69, ["Fly|Ride"] = 36.39, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 2630.16, ["Mega|Fly|Ride"] = 645.74}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 8.82}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 83.99, ["Fly"] = 598.23, ["Ride"] = 87.94, ["Fly|Ride"] = 175.86, ["Neon"] = 209.99, ["Neon|Fly"] = 548.42, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 416.46, ["Mega|Ride"] = 1900.31, ["Mega|Fly|Ride"] = 2047.15}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 16.45, ["Fly"] = 91.9, ["Ride"] = 43.31, ["Fly|Ride"] = 73.43, ["Neon"] = 107.62, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 552.35, ["Mega|Ride"] = 577.5, ["Mega|Fly|Ride"] = 1315.09}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 45.92}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 90.56, ["Fly"] = 147.28, ["Ride"] = 131.25, ["Fly|Ride"] = 301.37, ["Neon"] = 392.44, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 662.67, ["Mega|Ride"] = 1655.42, ["Mega|Fly|Ride"] = 1985.5}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 5.23, ["Ride"] = 35.18, ["Neon"] = 31.88, ["Neon|Ride"] = 143.58, ["Neon|Fly|Ride"] = 292.62, ["Mega"] = 140.61, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 286.79}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 12.07, ["Fly"] = 56.42, ["Ride"] = 33.53, ["Fly|Ride"] = 94.9, ["Neon"] = 157.5, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 218.1, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 586.69}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 603.74, ["Ride"] = 534.45, ["Fly|Ride"] = 577.5, ["Neon|Fly|Ride"] = 2848.25, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 38.07, ["Ride"] = 65.63, ["Fly|Ride"] = 107.55, ["Neon"] = 172.91, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 210, ["Mega"] = 776.43, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 827.72}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 50.94, ["Ride"] = 82.38, ["Fly|Ride"] = 147.4, ["Neon"] = 270.38, ["Neon|Ride"] = 237.09, ["Neon|Fly|Ride"] = 244.86, ["Mega|Ride"] = 1094.82, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 18.27, ["Ride"] = 36.74, ["Fly|Ride"] = 131.42, ["Neon"] = 97.13, ["Neon|Ride"] = 161.18, ["Neon|Fly|Ride"] = 202.13, ["Mega"] = 350.83, ["Mega|Fly"] = 525, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 585.22}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 9843.75, ["Fly"] = 10500, ["Ride"] = 8861.99, ["Fly|Ride"] = 7873.69, ["Neon|Fly|Ride"] = 14766.25, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1298.07, ["Fly"] = 1517.02, ["Ride"] = 1658.78, ["Fly|Ride"] = 1275.74, ["Neon|Fly|Ride"] = 3714.38, ["Mega|Fly|Ride"] = 15886.94}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 417.37, ["Ride"] = 459.38, ["Fly|Ride"] = 796.59, ["Neon"] = 2253.58, ["Neon|Fly|Ride"] = 3084.38, ["Mega"] = 21917.93, ["Mega|Fly|Ride"] = 9927.46}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 12.97, ["Fly"] = 29.59, ["Ride"] = 24.05, ["Fly|Ride"] = 43.3, ["Neon"] = 80.07, ["Neon|Ride"] = 87.69, ["Neon|Fly|Ride"] = 131.25, ["Mega|Fly|Ride"] = 539.44}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 3.67, ["Fly"] = 78.75, ["Ride"] = 37.27, ["Fly|Ride"] = 146.87, ["Neon"] = 24.94, ["Neon|Ride"] = 67.1, ["Mega"] = 148.95, ["Mega|Ride"] = 212.16, ["Mega|Fly|Ride"] = 348.51}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 35.07, ["Fly"] = 61.65, ["Ride"] = 57, ["Fly|Ride"] = 103.3, ["Neon"] = 331.2, ["Neon|Ride"] = 171.94, ["Neon|Fly|Ride"] = 189, ["Mega|Fly|Ride"] = 666.75}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.28, ["Fly"] = 23.1, ["Ride"] = 17.07, ["Fly|Ride"] = 39.38, ["Neon"] = 26.25, ["Neon|Fly"] = 83.02, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 331.34, ["Mega|Ride"] = 366.03, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 331.3, ["Fly"] = 371.54, ["Ride"] = 314.9, ["Fly|Ride"] = 420, ["Neon|Ride"] = 1230.89, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4820.86}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 20.99, ["Fly"] = 72.55, ["Ride"] = 45.94, ["Fly|Ride"] = 83.99, ["Neon"] = 144.38, ["Neon|Fly"] = 411.41, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 217, ["Mega"] = 876.72, ["Mega|Fly"] = 927, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 10.08, ["Fly"] = 21.93, ["Ride"] = 21, ["Fly|Ride"] = 49.87, ["Neon"] = 293.45, ["Neon|Fly"] = 123.85, ["Neon|Ride"] = 122.9, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 1575, ["Mega|Ride"] = 451.5, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 459.38, ["Fly"] = 1048.69, ["Ride"] = 485.63, ["Fly|Ride"] = 879.21, ["Mega|Fly|Ride"] = 9971.07}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1115.52, ["Fly"] = 1466.07, ["Ride"] = 1063.13, ["Fly|Ride"] = 1260, ["Neon"] = 5325.87, ["Neon|Ride"] = 4821.95, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13782.3}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 107.63, ["Fly"] = 147.28, ["Ride"] = 124.69, ["Fly|Ride"] = 128.63, ["Neon"] = 971.25, ["Neon|Fly|Ride"] = 505.31, ["Mega|Ride"] = 2627.98, ["Mega|Fly|Ride"] = 2896.35}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 184.95, ["Fly"] = 196.88, ["Ride"] = 213.94, ["Fly|Ride"] = 276.95, ["Neon|Ride"] = 613.72, ["Neon|Fly|Ride"] = 677.25, ["Mega|Ride"] = 9187.5, ["Mega|Fly|Ride"] = 2892.75}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 31.4, ["Fly"] = 126.4, ["Ride"] = 55.13, ["Fly|Ride"] = 87.69, ["Neon"] = 262.4, ["Neon|Ride"] = 133.17, ["Mega|Ride"] = 2191.82, ["Mega|Fly|Ride"] = 1110.64}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 275.86, ["Ride"] = 646, ["Fly|Ride"] = 586.88, ["Neon"] = 1220.63, ["Mega|Fly|Ride"] = 5845.51}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2314.1, ["Ride"] = 2483.25, ["Fly|Ride"] = 2099.9, ["Neon"] = 10989.98, ["Neon|Fly|Ride"] = 10958.97, ["Mega|Fly|Ride"] = 50411.23}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 50.06, ["Fly"] = 219.81, ["Ride"] = 51.19, ["Fly|Ride"] = 196.88, ["Neon"] = 288.75, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 343.3, ["Mega|Ride"] = 1023.59, ["Mega|Fly|Ride"] = 1461.95}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 590.63, ["Fly"] = 879.11, ["Ride"] = 623.59, ["Fly|Ride"] = 682.5, ["Neon"] = 1616.51, ["Neon|Ride"] = 1498.88, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 3461.92}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 43.04, ["Fly"] = 72.19, ["Ride"] = 57.75, ["Fly|Ride"] = 103.03, ["Neon"] = 439.61, ["Neon|Ride"] = 263.03, ["Neon|Fly|Ride"] = 236.25, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.76, ["Fly"] = 33.09, ["Ride"] = 19.66, ["Fly|Ride"] = 65.63, ["Neon"] = 32.37, ["Neon|Fly"] = 135.14, ["Neon|Ride"] = 48.41, ["Neon|Fly|Ride"] = 101.07, ["Mega"] = 186.38, ["Mega|Fly"] = 249.38, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 281.54}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 65.61, ["Ride"] = 65.63, ["Fly|Ride"] = 157.5, ["Neon"] = 393.65, ["Neon|Ride"] = 486.34, ["Neon|Fly|Ride"] = 730.98, ["Mega"] = 1642.76, ["Mega|Ride"] = 1753.44, ["Mega|Fly|Ride"] = 1739.19}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 1104.95, ["Ride"] = 1057.34, ["Fly|Ride"] = 1181.24, ["Neon|Ride"] = 3694.69, ["Neon|Fly|Ride"] = 3361.13, ["Mega|Fly|Ride"] = 14612.69}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 708.74, ["Ride"] = 858.03, ["Fly|Ride"] = 994.8, ["Neon|Fly|Ride"] = 4382.49, ["Mega|Fly|Ride"] = 20457.1}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 15.06, ["Fly"] = 26.2, ["Ride"] = 23.28, ["Fly|Ride"] = 45.93, ["Neon"] = 144.38, ["Neon|Ride"] = 115.97, ["Neon|Fly|Ride"] = 157.49, ["Mega|Fly|Ride"] = 777.34}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 23.36, ["Ride"] = 43.32, ["Fly|Ride"] = 111.57, ["Neon"] = 249.38, ["Neon|Ride"] = 264.71, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 1208.69, ["Mega|Ride"] = 1446.59, ["Mega|Fly|Ride"] = 1076.25}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.74, ["Fly"] = 39.38, ["Ride"] = 27.57, ["Fly|Ride"] = 101.13, ["Neon"] = 24.94, ["Neon|Fly"] = 326.27, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 175.37, ["Mega"] = 188.62, ["Mega|Fly"] = 579.52, ["Mega|Ride"] = 208.59, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 39.38, ["Fly"] = 52.5, ["Ride"] = 49.87, ["Fly|Ride"] = 116.17, ["Neon"] = 323.32, ["Neon|Ride"] = 214.12, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 786.19}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 103.03, ["Ride"] = 137.82, ["Fly|Ride"] = 367.07, ["Neon"] = 538.13, ["Neon|Ride"] = 603.75, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1874.25, ["Mega|Fly|Ride"] = 2572.5}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 15.3, ["Fly"] = 59.07, ["Ride"] = 38.07, ["Fly|Ride"] = 103.32, ["Neon"] = 99.58, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 256.46, ["Mega"] = 481.99, ["Mega|Ride"] = 406.37, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 35.59, ["Fly"] = 65.54, ["Ride"] = 43.86, ["Fly|Ride"] = 78.3, ["Neon"] = 242.82, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 218.1, ["Mega"] = 2100, ["Mega|Ride"] = 1139.75, ["Mega|Fly|Ride"] = 1312.49}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 2.62, ["Fly"] = 29.69, ["Ride"] = 21.73, ["Fly|Ride"] = 45.82, ["Neon"] = 34.13, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 116.19, ["Mega"] = 223.13, ["Mega|Ride"] = 496.39, ["Mega|Fly|Ride"] = 366.03}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 7.77, ["Fly"] = 65.63, ["Ride"] = 35.44, ["Fly|Ride"] = 86.63, ["Neon"] = 72.34, ["Neon|Fly"] = 115.54, ["Neon|Ride"] = 82.3, ["Neon|Fly|Ride"] = 218.1, ["Mega"] = 380.63, ["Mega|Ride"] = 481.31, ["Mega|Fly|Ride"] = 511.77}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 51.85, ["Fly"] = 72.19, ["Ride"] = 53.82, ["Fly|Ride"] = 102.38, ["Neon"] = 572.87, ["Neon|Ride"] = 279.34, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 1506.51, ["Mega|Fly|Ride"] = 1074.94}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1358.44, ["Fly"] = 1632.75, ["Ride"] = 1468.69, ["Fly|Ride"] = 1429.32, ["Neon|Ride"] = 4964.68, ["Neon|Fly|Ride"] = 3478.13, ["Mega|Fly|Ride"] = 13013.69}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 498.74, ["Fly"] = 616.88, ["Ride"] = 525, ["Fly|Ride"] = 572.24, ["Neon|Ride"] = 2421.95, ["Neon|Fly|Ride"] = 2332.32, ["Mega"] = 15342.55, ["Mega|Fly|Ride"] = 9863.07}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 288.75, ["Ride"] = 341.25, ["Fly|Ride"] = 447.57, ["Neon"] = 1575, ["Neon|Ride"] = 1470, ["Neon|Fly|Ride"] = 1820.46, ["Mega|Fly|Ride"] = 8037.31}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 41.87}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 38.48, ["Fly"] = 52.62, ["Ride"] = 49.8, ["Fly|Ride"] = 146.87, ["Neon"] = 299.92, ["Neon|Fly"] = 586.88, ["Neon|Ride"] = 265.37, ["Neon|Fly|Ride"] = 518.44, ["Mega|Ride"] = 1205.51, ["Mega|Fly|Ride"] = 1036.54}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 70875, ["Fly"] = 90562.5, ["Ride"] = 38133.12, ["Fly|Ride"] = 20409.38, ["Neon|Fly|Ride"] = 33468.75, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 254.62, ["Fly"] = 284.82, ["Ride"] = 280.08, ["Fly|Ride"] = 363.83, ["Neon"] = 1039.98, ["Neon|Fly"] = 853.13, ["Neon|Ride"] = 962.45, ["Neon|Fly|Ride"] = 912.19, ["Mega"] = 6575.39, ["Mega|Fly|Ride"] = 3281.33}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 147.34, ["Fly"] = 525, ["Ride"] = 165.83, ["Fly|Ride"] = 328.62}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 85.32, ["Fly"] = 219.81, ["Ride"] = 116.63, ["Fly|Ride"] = 182.44, ["Neon|Ride"] = 719.24, ["Neon|Fly|Ride"] = 627.86, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 13.13, ["Fly"] = 63.75, ["Ride"] = 33.49, ["Fly|Ride"] = 65.63, ["Neon"] = 116.57, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 157.83, ["Neon|Fly|Ride"] = 240.01, ["Mega"] = 1968.75, ["Mega|Ride"] = 730.98, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4095, ["Ride"] = 4058.25, ["Fly|Ride"] = 3975.57, ["Neon"] = 21917.93, ["Neon|Fly|Ride"] = 15750, ["Mega|Fly|Ride"] = 82752.27}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 29.29, ["Fly"] = 52.4, ["Ride"] = 35.21, ["Fly|Ride"] = 56.06, ["Neon"] = 200.82, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 190.21, ["Mega|Ride"] = 1461.95, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 35.1, ["Fly"] = 94.54, ["Ride"] = 59.36, ["Fly|Ride"] = 108.31, ["Neon"] = 310.73, ["Neon|Fly"] = 1461.95, ["Neon|Ride"] = 202.79, ["Neon|Fly|Ride"] = 348.51, ["Mega|Fly|Ride"] = 1601.25}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 434.8, ["Fly"] = 563.06, ["Ride"] = 471.69, ["Fly|Ride"] = 538.13, ["Neon"] = 1410.94, ["Neon|Ride"] = 1181.24, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 4527.15}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 14.34, ["Fly"] = 30.86, ["Ride"] = 24.93, ["Fly|Ride"] = 49.7, ["Neon"] = 131.25, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 14.18, ["Fly"] = 293.45, ["Ride"] = 35.43, ["Fly|Ride"] = 82.08, ["Neon"] = 98.44, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 217.7, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 744.58}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 108.94, ["Ride"] = 122.07, ["Fly|Ride"] = 245.44, ["Neon"] = 1010.63, ["Neon|Ride"] = 511.88, ["Neon|Fly|Ride"] = 700.29, ["Mega|Fly|Ride"] = 4139.29}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 18.37, ["Fly"] = 119.06, ["Ride"] = 147.28, ["Fly|Ride"] = 493.33, ["Neon"] = 76.44, ["Neon|Ride"] = 146.87, ["Neon|Fly|Ride"] = 237.56, ["Mega"] = 438.37, ["Mega|Fly"] = 354.38, ["Mega|Ride"] = 287.97, ["Mega|Fly|Ride"] = 1169.35}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 5604.38, ["Fly"] = 6942.27, ["Ride"] = 5118.75, ["Fly|Ride"] = 4935, ["Neon"] = 19687.5, ["Neon|Ride"] = 14921.5, ["Neon|Fly|Ride"] = 11811.19, ["Mega"] = 52164.65, ["Mega|Fly|Ride"] = 37945.69}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 36.39, ["Fly"] = 74.75, ["Ride"] = 58.97, ["Fly|Ride"] = 144.38, ["Neon"] = 233.62, ["Neon|Ride"] = 274.82, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 1242.76, ["Mega|Ride"] = 1820.97, ["Mega|Fly|Ride"] = 784.88}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 6562.5, ["Ride"] = 6496.88, ["Fly|Ride"] = 6168.65, ["Neon|Fly|Ride"] = 14962.5, ["Mega|Fly|Ride"] = 46921.88}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.1, ["Fly"] = 21.8, ["Ride"] = 19.79, ["Fly|Ride"] = 36.65, ["Neon"] = 49.76, ["Neon|Fly"] = 62.74, ["Neon|Ride"] = 47.3, ["Neon|Fly|Ride"] = 83.15, ["Mega"] = 242.82, ["Mega|Fly"] = 1461.95, ["Mega|Ride"] = 217, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 16.71, ["Fly"] = 24.45, ["Ride"] = 32.99, ["Fly|Ride"] = 59.07, ["Neon"] = 92.04, ["Neon|Fly"] = 242.9, ["Neon|Ride"] = 142.63, ["Neon|Fly|Ride"] = 166.29, ["Mega|Ride"] = 880.04, ["Mega|Fly|Ride"] = 876.72}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 4.75}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 13.65, ["Fly"] = 47.28, ["Ride"] = 33.51, ["Fly|Ride"] = 89.7, ["Neon"] = 131.25, ["Neon|Ride"] = 139.12, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 1050, ["Mega|Ride"] = 1168.26, ["Mega|Fly|Ride"] = 1324.1}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 28, ["Fly"] = 190.37, ["Ride"] = 51.85, ["Fly|Ride"] = 156.08, ["Neon"] = 244.25, ["Neon|Ride"] = 292.62, ["Neon|Fly|Ride"] = 255.94, ["Mega|Ride"] = 876.72, ["Mega|Fly|Ride"] = 1079.63}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 14.02, ["Fly"] = 27.57, ["Ride"] = 24.55, ["Fly|Ride"] = 41.66, ["Neon|Fly"] = 1092.62, ["Neon|Ride"] = 109.61, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 1149.61, ["Mega|Fly|Ride"] = 668.52}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 6628.13}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 3071.25}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 19.68}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 269.06, ["Ride"] = 381.76, ["Fly|Ride"] = 341.24, ["Neon|Fly|Ride"] = 1226.29}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 15.6, ["Fly"] = 52.5, ["Ride"] = 37.32, ["Fly|Ride"] = 103.69, ["Neon"] = 104.9, ["Neon|Ride"] = 110.25, ["Neon|Fly|Ride"] = 265.13, ["Mega|Ride"] = 2151.8, ["Mega|Fly|Ride"] = 568.8}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 13.12}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 5.8, ["Ride"] = 26.25, ["Fly|Ride"] = 87.94, ["Neon"] = 147.28, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 131.25, ["Mega|Fly|Ride"] = 496.12}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2493.06}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 250.59, ["Fly"] = 439.61, ["Ride"] = 275.09, ["Fly|Ride"] = 306.84, ["Neon"] = 1048.69, ["Neon|Ride"] = 1095.5, ["Neon|Fly|Ride"] = 1094.82, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 66.93, ["Fly"] = 219.81, ["Ride"] = 89.25, ["Fly|Ride"] = 525, ["Neon"] = 422.79, ["Neon|Ride"] = 367.49, ["Neon|Fly|Ride"] = 345.19, ["Mega|Fly|Ride"] = 2189.62}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 200.55, ["Fly"] = 266.12, ["Ride"] = 183.75, ["Fly|Ride"] = 183.75, ["Neon"] = 945, ["Neon|Ride"] = 741.57, ["Neon|Fly|Ride"] = 748.12, ["Mega|Ride"] = 3726.07, ["Mega|Fly|Ride"] = 3475.1}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2625, ["Fly"] = 3370.64, ["Ride"] = 2756.25, ["Fly|Ride"] = 2887.5, ["Neon"] = 15436.52, ["Neon|Ride"] = 10777.06, ["Neon|Fly|Ride"] = 8767.18, ["Mega|Fly|Ride"] = 31499.99}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 18.38, ["Fly"] = 157.5, ["Ride"] = 45.94, ["Fly|Ride"] = 86.46, ["Neon"] = 127.32, ["Neon|Ride"] = 158.87, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 985.22, ["Mega|Ride"] = 1205.51, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 918.75, ["Fly"] = 2231.25, ["Ride"] = 918.75, ["Fly|Ride"] = 1758.41, ["Neon|Fly|Ride"] = 5478.41}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 45.57}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 24.85, ["Fly"] = 87.94, ["Ride"] = 48.24, ["Fly|Ride"] = 245.44, ["Neon"] = 115.5, ["Neon|Ride"] = 135.62, ["Neon|Fly|Ride"] = 267.41, ["Mega"] = 469.06, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 492.19}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 10.5, ["Fly"] = 52.24, ["Ride"] = 31.13, ["Fly|Ride"] = 77.12, ["Neon"] = 72.19, ["Neon|Fly"] = 315, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 328.13, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 377.01}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 61.22}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 19.74, ["Fly"] = 65.96, ["Ride"] = 32.8, ["Fly|Ride"] = 65.63, ["Neon"] = 144.66, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 254.63, ["Mega|Ride"] = 1315.09, ["Mega|Fly|Ride"] = 992.76}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 26.98, ["Fly"] = 50.57, ["Ride"] = 32.16, ["Fly|Ride"] = 62.99, ["Neon"] = 166.64, ["Neon|Fly"] = 242.9, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 291.53, ["Mega"] = 1461.95, ["Mega|Ride"] = 1861.93, ["Mega|Fly|Ride"] = 871.5}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6734.81, ["Fly"] = 5643.75, ["Ride"] = 6613.95, ["Fly|Ride"] = 5248.95, ["Neon|Fly|Ride"] = 10484.25, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 9.84, ["Fly"] = 50.57, ["Ride"] = 34.04, ["Fly|Ride"] = 81.84, ["Neon"] = 57.18, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 237.03, ["Mega"] = 354.38, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 585.22}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 21.94}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 90.57, ["Fly"] = 387.97, ["Ride"] = 122, ["Fly|Ride"] = 207.67, ["Neon"] = 531.57, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 526.24, ["Mega"] = 2879.59, ["Mega|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 1850.63}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 54.51, ["Fly"] = 196.79, ["Ride"] = 98.65, ["Fly|Ride"] = 176.5, ["Neon"] = 347.82, ["Neon|Fly"] = 397.91, ["Neon|Ride"] = 317.63, ["Neon|Fly|Ride"] = 329.04, ["Mega"] = 1242.76, ["Mega|Ride"] = 1257.01, ["Mega|Fly|Ride"] = 1200.94}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 24.12, ["Fly"] = 83.54, ["Ride"] = 42, ["Fly|Ride"] = 64.32, ["Neon"] = 174.57, ["Neon|Fly"] = 237.4, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 190.21, ["Mega"] = 1016.21, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 5.24, ["Fly"] = 78.75, ["Ride"] = 31.5, ["Fly|Ride"] = 109.59, ["Neon"] = 36.77, ["Neon|Fly"] = 81.12, ["Neon|Ride"] = 57.84, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 262.5, ["Mega|Fly"] = 7306.35, ["Mega|Ride"] = 232.32, ["Mega|Fly|Ride"] = 354.32}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 12.05, ["Fly"] = 65.63, ["Ride"] = 32.82, ["Fly|Ride"] = 91.16, ["Neon"] = 85.74, ["Neon|Ride"] = 109.92, ["Neon|Fly|Ride"] = 232.35, ["Mega"] = 380.63, ["Mega|Fly|Ride"] = 583.03}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 22.2, ["Fly"] = 33.42, ["Ride"] = 28.03, ["Fly|Ride"] = 52.5, ["Neon"] = 186.84, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 78.66, ["Neon|Fly|Ride"] = 176.7, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 190.32}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 24.11, ["Ride"] = 101.75, ["Fly|Ride"] = 339.94, ["Neon"] = 169.32, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 469.06, ["Mega"] = 730.98, ["Mega|Ride"] = 780.3, ["Mega|Fly|Ride"] = 769.23}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 525, ["Ride"] = 1466.07, ["Fly|Ride"] = 210, ["Neon|Fly|Ride"] = 73060.09}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 56.44, ["Fly"] = 108.49, ["Ride"] = 78.75, ["Fly|Ride"] = 209.95, ["Neon"] = 216.56, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 394.83, ["Mega"] = 1182.57, ["Mega|Ride"] = 2318.07, ["Mega|Fly|Ride"] = 1613.22}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 1181.25, ["Fly"] = 1181.25, ["Ride"] = 1207.5, ["Fly|Ride"] = 1312.49, ["Neon"] = 4787.33, ["Neon|Fly"] = 4787.33, ["Neon|Ride"] = 3675, ["Neon|Fly|Ride"] = 3150, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 438.37, ["Fly"] = 829.41, ["Ride"] = 479.07, ["Fly|Ride"] = 602.44, ["Neon"] = 2884.88, ["Neon|Ride"] = 2198.01, ["Neon|Fly|Ride"] = 2033.07, ["Mega"] = 13150.76, ["Mega|Fly|Ride"] = 9973.69}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 60.37}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.62}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 10.4, ["Fly"] = 32.81, ["Ride"] = 24.82, ["Fly|Ride"] = 48.4, ["Neon"] = 83.32, ["Neon|Fly"] = 162.22, ["Neon|Ride"] = 85.75, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 437.26, ["Mega|Ride"] = 662.87, ["Mega|Fly|Ride"] = 570.94}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 234.93, ["Fly"] = 301.46, ["Ride"] = 291.38, ["Fly|Ride"] = 374.07, ["Neon"] = 851.82, ["Neon|Ride"] = 759.94, ["Neon|Fly|Ride"] = 874.13, ["Mega|Fly|Ride"] = 3601.5}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 15.48}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 117.28, ["Ride"] = 146.87, ["Fly|Ride"] = 262.5, ["Neon"] = 787.49, ["Neon|Fly"] = 610.32, ["Neon|Ride"] = 708.75, ["Neon|Fly|Ride"] = 774.38, ["Mega"] = 2809.03, ["Mega|Ride"] = 2605.98, ["Mega|Fly|Ride"] = 2388.75}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 91.88, ["Fly"] = 315.86, ["Ride"] = 131.25, ["Fly|Ride"] = 262.5, ["Neon"] = 1040.76, ["Neon|Ride"] = 1032.94, ["Neon|Fly|Ride"] = 931.88, ["Mega|Fly|Ride"] = 2187.42}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 4.81, ["Ride"] = 24.94, ["Fly|Ride"] = 219.19, ["Neon"] = 32.69, ["Neon|Ride"] = 69.62, ["Neon|Fly|Ride"] = 287.14, ["Mega"] = 168.92, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 384.67}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 15.64, ["Fly"] = 50.93, ["Ride"] = 30.18, ["Fly|Ride"] = 69.57, ["Neon"] = 110.25, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 234.54, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 16.38, ["Fly"] = 102.36, ["Ride"] = 36.75, ["Fly|Ride"] = 131.25, ["Neon"] = 63, ["Neon|Ride"] = 101.06, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 498.75, ["Mega|Ride"] = 455.91, ["Mega|Fly|Ride"] = 494.82}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 3.92, ["Fly"] = 141.05, ["Ride"] = 51.89, ["Fly|Ride"] = 187.4, ["Neon"] = 28.87, ["Neon|Ride"] = 65.01, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 196.87, ["Mega|Ride"] = 173.39, ["Mega|Fly|Ride"] = 303.32}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 275.52, ["Fly"] = 262.5, ["Ride"] = 328.13, ["Fly|Ride"] = 344.96, ["Neon|Ride"] = 1424.6, ["Neon|Fly|Ride"] = 1409.82, ["Mega|Ride"] = 5114.55, ["Mega|Fly|Ride"] = 6750.73}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 89.14, ["Fly"] = 586.88, ["Ride"] = 124.58, ["Fly|Ride"] = 231, ["Neon"] = 435.29, ["Neon|Ride"] = 483.92, ["Neon|Fly|Ride"] = 514.48, ["Mega"] = 2022.57, ["Mega|Ride"] = 2082.24, ["Mega|Fly|Ride"] = 2047.15}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 69.55, ["Ride"] = 78.44, ["Fly|Ride"] = 123.39, ["Neon"] = 262.5, ["Neon|Ride"] = 341.23, ["Neon|Fly|Ride"] = 433.98, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1374.18}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 19.74, ["Fly"] = 127.32, ["Ride"] = 53.85, ["Neon|Ride"] = 630.6, ["Neon|Fly|Ride"] = 331.34, ["Mega|Fly|Ride"] = 1023.59}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 13.12, ["Ride"] = 29.6, ["Fly|Ride"] = 101.13, ["Neon"] = 72.85, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 807.19, ["Mega|Ride"] = 531.14, ["Mega|Fly|Ride"] = 624.68}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 2.62, ["Fly"] = 52.5, ["Ride"] = 18.38, ["Fly|Ride"] = 85.32, ["Neon"] = 22.99, ["Neon|Fly"] = 54.98, ["Neon|Ride"] = 49.76, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 131.25, ["Mega|Ride"] = 148.32, ["Mega|Fly|Ride"] = 291.53}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 1034.25, ["Fly"] = 918.75, ["Ride"] = 990.94, ["Fly|Ride"] = 984.37, ["Neon"] = 4396, ["Neon|Ride"] = 8767.18, ["Neon|Fly|Ride"] = 2624.99, ["Mega|Fly|Ride"] = 8098.23}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 245.63, ["Fly"] = 355, ["Ride"] = 295.32, ["Fly|Ride"] = 343.88, ["Neon"] = 1318.82, ["Neon|Ride"] = 1270.5, ["Neon|Fly|Ride"] = 1169.35, ["Mega"] = 10958.97, ["Mega|Fly|Ride"] = 5431.28}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 101.07, ["Fly"] = 174.17, ["Ride"] = 99.75, ["Fly|Ride"] = 137.82, ["Neon"] = 426.57, ["Neon|Ride"] = 428.79, ["Neon|Fly|Ride"] = 543.59, ["Mega"] = 1575, ["Mega|Ride"] = 1783.04, ["Mega|Fly|Ride"] = 1900.31}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 232.32, ["Fly"] = 283.5, ["Ride"] = 219.19, ["Fly|Ride"] = 196.88, ["Neon"] = 1048.69, ["Neon|Ride"] = 1159.26, ["Neon|Fly|Ride"] = 876.72, ["Mega"] = 10958.97, ["Mega|Fly|Ride"] = 4138.53}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 20.47, ["Fly"] = 59.36, ["Ride"] = 31.26, ["Fly|Ride"] = 80.56, ["Neon"] = 105, ["Neon|Ride"] = 72.34, ["Neon|Fly|Ride"] = 219.19, ["Mega|Fly|Ride"] = 1095.91}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 231, ["Ride"] = 326.47, ["Fly|Ride"] = 397.91, ["Neon"] = 1082.48, ["Neon|Ride"] = 942.38, ["Neon|Fly|Ride"] = 1314, ["Mega"] = 4361.98, ["Mega|Fly|Ride"] = 4963.74}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 77.82, ["Fly"] = 126, ["Ride"] = 98.51, ["Fly|Ride"] = 131.22, ["Neon|Ride"] = 1655.88, ["Mega|Ride"] = 2338.66, ["Mega|Fly|Ride"] = 1821.75}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 2361.19, ["Ride"] = 2377.75, ["Fly|Ride"] = 2835, ["Neon|Ride"] = 11582.87, ["Neon|Fly|Ride"] = 7201.69, ["Mega"] = 52603.01, ["Mega|Fly|Ride"] = 31106.43}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 13.95, ["Fly"] = 86.59, ["Ride"] = 54.47, ["Fly|Ride"] = 116.82, ["Neon"] = 57.75, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 194.15, ["Mega"] = 296.63, ["Mega|Ride"] = 385.77, ["Mega|Fly|Ride"] = 454.6}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 46.78, ["Ride"] = 65.63, ["Fly|Ride"] = 148.32, ["Neon"] = 216.57, ["Neon|Ride"] = 229.69, ["Neon|Fly|Ride"] = 413.34, ["Mega|Ride"] = 931.87, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 98.14, ["Fly"] = 102.15, ["Ride"] = 89.25, ["Fly|Ride"] = 91.77, ["Neon|Ride"] = 506.31, ["Neon|Fly|Ride"] = 410.82, ["Mega|Fly|Ride"] = 1512.03}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2818.93, ["Fly"] = 1659.17, ["Ride"] = 1073.61, ["Fly|Ride"] = 1039.5, ["Neon|Ride"] = 5792.53, ["Neon|Fly|Ride"] = 3937.49, ["Mega"] = 41644.05, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 446.25, ["Fly"] = 876.72, ["Ride"] = 542.48, ["Fly|Ride"] = 821.63, ["Neon|Fly|Ride"] = 2629.08, ["Mega"] = 11506.91}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 70.88, ["Fly"] = 124.69, ["Ride"] = 135.19, ["Fly|Ride"] = 195.57, ["Neon"] = 453.48, ["Neon|Ride"] = 360.18, ["Neon|Fly|Ride"] = 496.39, ["Mega"] = 2630.16, ["Mega|Ride"] = 2648.18, ["Mega|Fly|Ride"] = 1761.38}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 5.25, ["Fly"] = 42.3, ["Ride"] = 26.24, ["Fly|Ride"] = 63.9, ["Neon"] = 77.18, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 187.69, ["Mega"] = 656.25, ["Mega|Ride"] = 823.93, ["Mega|Fly|Ride"] = 487.7}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 36.75, ["Fly"] = 68.25, ["Ride"] = 42, ["Fly|Ride"] = 91.88, ["Neon"] = 164.4, ["Neon|Ride"] = 285.75, ["Neon|Fly|Ride"] = 339.94, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 748.13, ["Fly"] = 1144.27, ["Ride"] = 899.07, ["Fly|Ride"] = 885.29, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2230.99, ["Mega|Fly|Ride"] = 8531.25}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 721.88}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 5381.25, ["Ride"] = 5250, ["Fly|Ride"] = 5184.38, ["Neon"] = 18375, ["Neon|Ride"] = 31409.47, ["Neon|Fly|Ride"] = 27565.13, ["Mega|Fly|Ride"] = 84750}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 242.82, ["Fly"] = 494.81, ["Ride"] = 324.22, ["Fly|Ride"] = 432.74, ["Neon"] = 1753.44, ["Neon|Fly|Ride"] = 2191.82, ["Mega"] = 6574.3, ["Mega|Fly|Ride"] = 6575.39}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 98.12, ["Ride"] = 157.4, ["Fly|Ride"] = 190.32, ["Neon"] = 2190.45, ["Neon|Ride"] = 656.45, ["Neon|Fly|Ride"] = 469.06}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 23.56, ["Fly"] = 102.37, ["Ride"] = 40.69, ["Fly|Ride"] = 107.62, ["Neon"] = 160.13, ["Neon|Ride"] = 174.09, ["Neon|Fly|Ride"] = 245.44, ["Mega|Ride"] = 662.67, ["Mega|Fly|Ride"] = 800.63}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 12.07, ["Fly"] = 32.82, ["Ride"] = 26.81, ["Fly|Ride"] = 51.24, ["Neon"] = 147.28, ["Neon|Fly"] = 292.62, ["Neon|Ride"] = 129.91, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 4407.12}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 17.55, ["Fly"] = 165.97, ["Ride"] = 42, ["Fly|Ride"] = 110.25, ["Neon"] = 98.44, ["Neon|Ride"] = 123.38, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 645.91, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 662.67}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 4.38, ["Fly"] = 37.38, ["Ride"] = 20.91, ["Fly|Ride"] = 52.5, ["Neon"] = 41.2, ["Neon|Fly"] = 361.66, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 136.69, ["Mega"] = 675, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 272.87}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 23.3, ["Ride"] = 51.18, ["Fly|Ride"] = 147, ["Neon"] = 115.5, ["Neon|Fly"] = 876.72, ["Neon|Ride"] = 188.28, ["Neon|Fly|Ride"] = 327.69, ["Mega"] = 630, ["Mega|Ride"] = 774.81, ["Mega|Fly|Ride"] = 532.88}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 632.84, ["Fly"] = 762.57, ["Ride"] = 643.13, ["Fly|Ride"] = 782.25, ["Neon|Ride"] = 2231.25, ["Neon|Fly|Ride"] = 2231.25, ["Mega"] = 9843.75, ["Mega|Fly|Ride"] = 10081.32}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.62, ["Fly"] = 19.69, ["Ride"] = 16.45, ["Fly|Ride"] = 34.91, ["Neon"] = 22.32, ["Neon|Ride"] = 38.59, ["Neon|Fly|Ride"] = 74.81, ["Mega"] = 170.63, ["Mega|Ride"] = 616.35, ["Mega|Fly|Ride"] = 208.69}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 43.31, ["Fly"] = 85.75, ["Ride"] = 78.74, ["Fly|Ride"] = 133.88, ["Neon"] = 183.75, ["Neon|Fly"] = 430.71, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 254.63, ["Mega"] = 551.24, ["Mega|Fly"] = 876.72, ["Mega|Ride"] = 633.94, ["Mega|Fly|Ride"] = 613.3}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 837.38, ["Ride"] = 813.75, ["Fly|Ride"] = 853.11, ["Neon|Fly"] = 2264.13, ["Neon|Ride"] = 1706.25, ["Neon|Fly|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 4922.78}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 39.29, ["Fly"] = 70.86, ["Ride"] = 52.5, ["Fly|Ride"] = 102.38, ["Neon"] = 249.38, ["Neon|Ride"] = 223.02, ["Neon|Fly|Ride"] = 236.15, ["Mega"] = 1241.19, ["Mega|Ride"] = 927.94, ["Mega|Fly|Ride"] = 885.92}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 315.13, ["Fly"] = 318.13, ["Ride"] = 321.57, ["Fly|Ride"] = 341.21, ["Neon|Fly|Ride"] = 1291.5}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 276.94, ["Fly"] = 580.72, ["Ride"] = 280.88, ["Fly|Ride"] = 387.09, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 5118.75, ["Mega|Fly|Ride"] = 5364.42}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 777.79, ["Ride"] = 656.25, ["Fly|Ride"] = 708.75, ["Neon|Ride"] = 3654.82, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 9448.69}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 19.47, ["Ride"] = 50.59, ["Fly|Ride"] = 107.47, ["Neon"] = 61.07, ["Neon|Fly"] = 297.9, ["Neon|Ride"] = 117.51, ["Neon|Fly|Ride"] = 166.29, ["Mega"] = 354.38, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 451.5}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3281.25, ["Fly"] = 3543.75, ["Ride"] = 3399.38, ["Fly|Ride"] = 3543.75, ["Neon|Fly|Ride"] = 8027.25, ["Mega|Fly|Ride"] = 19686.19}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 131.06, ["Fly"] = 178.49, ["Ride"] = 147, ["Fly|Ride"] = 198.54, ["Neon"] = 535.5, ["Neon|Ride"] = 542.48, ["Neon|Fly|Ride"] = 581.44, ["Mega|Fly|Ride"] = 3476.2}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 3.68, ["Fly"] = 44.8, ["Ride"] = 19.59, ["Fly|Ride"] = 43.32, ["Neon"] = 24.47, ["Neon|Fly"] = 43.24, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 234.54, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 291.27, ["Mega|Fly|Ride"] = 320.25}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.4, ["Ride"] = 21.61, ["Fly|Ride"] = 73.64, ["Neon"] = 26.25, ["Neon|Fly"] = 121.66, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 218.1, ["Mega|Ride"] = 394.49, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 52.5, ["Fly"] = 39.38, ["Ride"] = 44.66, ["Fly|Ride"] = 57.28, ["Neon"] = 298.45, ["Neon|Fly|Ride"] = 274.17, ["Mega|Fly|Ride"] = 1266.87}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 904.32, ["Fly"] = 1193.74, ["Ride"] = 987, ["Fly|Ride"] = 1105.13, ["Neon|Ride"] = 11585.05, ["Neon|Fly|Ride"] = 4964.67}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 9578.14, ["Fly|Ride"] = 10434.38}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 24.12, ["Fly"] = 30.19, ["Ride"] = 28.82, ["Fly|Ride"] = 48.46, ["Neon"] = 175.86, ["Neon|Ride"] = 144.24, ["Neon|Fly|Ride"] = 170.62, ["Mega"] = 2520, ["Mega|Ride"] = 877.52, ["Mega|Fly|Ride"] = 811.11}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 14.25, ["Fly"] = 51.52, ["Ride"] = 32.81, ["Fly|Ride"] = 62.04, ["Neon"] = 123.62, ["Neon|Fly"] = 111.57, ["Neon|Ride"] = 92.19, ["Neon|Fly|Ride"] = 146.87, ["Mega"] = 675.63, ["Mega|Ride"] = 528.94, ["Mega|Fly|Ride"] = 501.38}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 98.42, ["Ride"] = 121.03, ["Fly|Ride"] = 143.07, ["Neon|Ride"] = 647.95, ["Neon|Fly|Ride"] = 528.93, ["Mega|Fly|Ride"] = 1570.96}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 236.18, ["Fly"] = 465.07, ["Ride"] = 242.82, ["Fly|Ride"] = 321.43, ["Neon"] = 1305.88, ["Neon|Ride"] = 934.76, ["Neon|Fly|Ride"] = 1023.59, ["Mega"] = 10958.97, ["Mega|Fly|Ride"] = 4322.24}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.66, ["Ride"] = 31.38, ["Fly|Ride"] = 65.63, ["Neon"] = 33.51, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 64.31, ["Mega"] = 169.21, ["Mega|Fly"] = 244.39, ["Mega|Ride"] = 156.18, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 166.15, ["Fly"] = 257.25, ["Ride"] = 196.88, ["Fly|Ride"] = 240.19, ["Neon"] = 654.94, ["Neon|Ride"] = 715.32, ["Neon|Fly|Ride"] = 682.5, ["Mega|Fly|Ride"] = 3054.28}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.93, ["Fly"] = 26.25, ["Ride"] = 17.06, ["Fly|Ride"] = 33.52, ["Neon"] = 32.27, ["Neon|Fly"] = 131.52, ["Neon|Ride"] = 43.86, ["Neon|Fly|Ride"] = 127.72, ["Mega"] = 424.13, ["Mega|Fly"] = 292.62, ["Mega|Ride"] = 219.19, ["Mega|Fly|Ride"] = 232.97}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 297.94, ["Fly"] = 354.38, ["Ride"] = 341.23, ["Fly|Ride"] = 347.82, ["Neon|Ride"] = 1436.25, ["Neon|Fly|Ride"] = 1246.88, ["Mega"] = 10958.97, ["Mega|Fly|Ride"] = 5626.39}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 8.79, ["Fly"] = 104.99, ["Ride"] = 29.25, ["Fly|Ride"] = 52.5, ["Neon"] = 90.55, ["Neon|Fly"] = 315.31, ["Neon|Ride"] = 146.87, ["Neon|Fly|Ride"] = 194.91, ["Mega"] = 585.22, ["Mega|Ride"] = 451.53, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Fly"] = 73.64, ["Ride"] = 23.63, ["Neon"] = 8.79, ["Neon|Fly"] = 170.46, ["Neon|Ride"] = 49.56, ["Neon|Fly|Ride"] = 109.61, ["Mega"] = 94.4, ["Mega|Ride"] = 143.2, ["Mega|Fly|Ride"] = 287.44}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 4.86, ["Mega"] = 22.26, ["Mega|Ride"] = 157.83, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 38.59, ["Fly|Ride"] = 86.63, ["Neon"] = 6.08, ["Neon|Ride"] = 29.17, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 39.29, ["Mega|Fly"] = 191720.66, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 219.73}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 77.24, ["Fly"] = 175.86, ["Ride"] = 104.98, ["Fly|Ride"] = 182.44, ["Neon"] = 262.5, ["Neon|Ride"] = 309.23, ["Neon|Fly|Ride"] = 410.82, ["Mega|Ride"] = 1233.75, ["Mega|Fly|Ride"] = 1236.38}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 38.56, ["Ride"] = 16.41, ["Fly|Ride"] = 34.72, ["Neon"] = 5.25, ["Neon|Ride"] = 29.31, ["Neon|Fly|Ride"] = 70.56, ["Mega"] = 73.44, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 8.69, ["Neon"] = 82.29, ["Neon|Fly"] = 332.03, ["Neon|Ride"] = 314.89, ["Neon|Fly|Ride"] = 366.03, ["Mega"] = 420, ["Mega|Ride"] = 583.03, ["Mega|Fly|Ride"] = 579.52}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Neon"] = 2.63, ["Neon|Fly"] = 38.56, ["Neon|Ride"] = 56.43, ["Mega"] = 15.75, ["Mega|Fly|Ride"] = 256.29}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 85.56, ["Ride"] = 12.99, ["Fly|Ride"] = 196.88, ["Neon"] = 2.1, ["Neon|Fly"] = 43.86, ["Neon|Ride"] = 15.33, ["Neon|Fly|Ride"] = 41.97, ["Mega"] = 14.44, ["Mega|Fly"] = 37.3, ["Mega|Ride"] = 20.23, ["Mega|Fly|Ride"] = 58.57}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 25.15, ["Ride"] = 16.5, ["Fly|Ride"] = 37.84, ["Neon"] = 2.1, ["Neon|Fly"] = 26.17, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 51.19, ["Mega"] = 19.69, ["Mega|Fly"] = 166.35, ["Mega|Ride"] = 42.83, ["Mega|Fly|Ride"] = 92.86}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 43.94, ["Neon"] = 2.1, ["Neon|Ride"] = 65.63, ["Mega"] = 19.69, ["Mega|Ride"] = 89.25, ["Mega|Fly|Ride"] = 247.69}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 117.93, ["Ride"] = 29.6, ["Fly|Ride"] = 52.5, ["Neon"] = 5.44, ["Neon|Fly"] = 123.79, ["Neon|Ride"] = 23.92, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 39.26, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 43.32, ["Mega|Fly|Ride"] = 146.87}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.84, ["Neon|Ride"] = 89.06, ["Mega"] = 17.06, ["Mega|Ride"] = 99.75}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 5.25, ["Fly"] = 52.5, ["Ride"] = 34.79, ["Fly|Ride"] = 105, ["Neon"] = 59.75, ["Neon|Ride"] = 91.76, ["Neon|Fly|Ride"] = 199.17, ["Mega"] = 236.24, ["Mega|Ride"] = 282.09, ["Mega|Fly|Ride"] = 379.6}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 82.78, ["Neon"] = 2.1, ["Neon|Ride"] = 35.1, ["Mega"] = 28.88, ["Mega|Fly"] = 151.45, ["Mega|Ride"] = 146.87, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly|Ride"] = 52.5, ["Neon"] = 22.82, ["Mega"] = 120.64, ["Mega|Fly"] = 315, ["Mega|Ride"] = 170.63}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 26.24, ["Fly|Ride"] = 43.98, ["Neon"] = 23, ["Mega"] = 134.95, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Fly"] = 146.87, ["Ride"] = 30.85, ["Neon"] = 2.46, ["Neon|Ride"] = 27.97, ["Neon|Fly|Ride"] = 146.87, ["Mega"] = 21.27, ["Mega|Ride"] = 39.25, ["Mega|Fly|Ride"] = 104.99}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.91, ["Ride"] = 14.73, ["Fly|Ride"] = 31.87, ["Neon"] = 2.1, ["Neon|Fly"] = 14.44, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 42.2, ["Mega"] = 14.27, ["Mega|Fly"] = 32.96, ["Mega|Ride"] = 22.24, ["Mega|Fly|Ride"] = 53.82}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 54.28, ["Fly|Ride"] = 118.12, ["Neon"] = 39.83, ["Neon|Ride"] = 142.88, ["Neon|Fly|Ride"] = 730.98, ["Mega"] = 149.63, ["Mega|Ride"] = 241.5}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 42.66, ["Neon"] = 4.24, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 28.87, ["Neon|Fly|Ride"] = 82.21, ["Mega"] = 26.25, ["Mega|Ride"] = 40.59, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 6.14, ["Neon"] = 13.13, ["Neon|Ride"] = 195.11, ["Mega"] = 68.25, ["Mega|Ride"] = 144.27, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 81.36, ["Ride"] = 28.88, ["Fly|Ride"] = 55.13, ["Neon"] = 15.65, ["Neon|Ride"] = 51.52, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 129.94, ["Mega|Ride"] = 166.29, ["Mega|Fly|Ride"] = 196.87}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 13.53, ["Ride"] = 15.22, ["Fly|Ride"] = 38.48, ["Neon"] = 2.1, ["Neon|Fly"] = 20.83, ["Neon|Ride"] = 14.34, ["Neon|Fly|Ride"] = 31.5, ["Mega"] = 14.6, ["Mega|Fly"] = 28.48, ["Mega|Ride"] = 21, ["Mega|Fly|Ride"] = 52.5}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 44.12, ["Ride"] = 27.43, ["Fly|Ride"] = 52.5, ["Neon"] = 13.2, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 196.76, ["Mega"] = 129.68, ["Mega|Ride"] = 162.32, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 5.03, ["Fly"] = 118.13, ["Ride"] = 28.88, ["Fly|Ride"] = 93.19, ["Neon"] = 83.32, ["Neon|Ride"] = 73.64, ["Neon|Fly|Ride"] = 175.37, ["Mega"] = 288.75, ["Mega|Ride"] = 300.54, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 59.36, ["Ride"] = 14.4, ["Fly|Ride"] = 41.77, ["Neon"] = 2.63, ["Neon|Fly"] = 26.24, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 48.54, ["Mega"] = 24.94, ["Mega|Fly"] = 28.88, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 183.54, ["Ride"] = 21.94, ["Neon"] = 5.25, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 65.77, ["Mega|Fly"] = 166.36, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 216.53}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Fly|Ride"] = 131.25, ["Neon"] = 3.82, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 42.35, ["Mega"] = 32.8, ["Mega|Ride"] = 116.19, ["Mega|Fly|Ride"] = 194.92}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Ride"] = 15.75, ["Fly|Ride"] = 48.51, ["Neon"] = 2.1, ["Neon|Ride"] = 35.26, ["Neon|Fly|Ride"] = 131.52, ["Mega"] = 15.74, ["Mega|Fly"] = 32.82, ["Mega|Ride"] = 73.44, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 24.2, ["Ride"] = 20.83, ["Fly|Ride"] = 55.42, ["Neon"] = 7.65, ["Neon|Fly"] = 59.18, ["Neon|Ride"] = 22.4, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 105.24, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 151.92}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 3.62, ["Neon|Ride"] = 58.11, ["Mega"] = 46.92, ["Mega|Fly"] = 215.98, ["Mega|Ride"] = 140.18, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 21.69, ["Ride"] = 13.13, ["Fly|Ride"] = 40.68, ["Neon"] = 6.35, ["Neon|Fly"] = 82.21, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 59.19, ["Mega"] = 114.13, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 273.67}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 33.48, ["Neon|Fly"] = 188.88, ["Neon|Fly|Ride"] = 327.3, ["Mega"] = 105, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 657.56}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 21.49, ["Fly|Ride"] = 51.66, ["Neon"] = 7.88, ["Neon|Fly"] = 49.76, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 66.33, ["Mega"] = 78.75, ["Mega|Fly"] = 420, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 194.45}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 19.82, ["Fly|Ride"] = 72.12, ["Neon"] = 19.45, ["Neon|Fly"] = 32.78, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 63.52, ["Mega"] = 168.78, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 438.37, ["Mega|Fly|Ride"] = 224.44}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 3.84, ["Fly"] = 116.19, ["Fly|Ride"] = 147.28, ["Neon"] = 19.48, ["Mega"] = 259.88, ["Mega|Ride"] = 406.88}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 14.4, ["Ride"] = 116.67, ["Neon"] = 107.27, ["Neon|Ride"] = 146.87, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 750.75}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 3.92, ["Ride"] = 42, ["Neon"] = 57.2, ["Neon|Ride"] = 146.87, ["Mega"] = 247.15, ["Mega|Ride"] = 367.5}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 4.2, ["Ride"] = 73.64, ["Fly|Ride"] = 120.75, ["Neon"] = 52.48, ["Neon|Ride"] = 83.86, ["Neon|Fly|Ride"] = 205.42, ["Mega"] = 234.82, ["Mega|Ride"] = 334.14, ["Mega|Fly|Ride"] = 448.23}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 42.23, ["Mega"] = 19.83, ["Mega|Fly"] = 218.1, ["Mega|Ride"] = 83.15, ["Mega|Fly|Ride"] = 256.69}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 50.06}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 6.51, ["Fly"] = 23.63, ["Ride"] = 24.69, ["Fly|Ride"] = 51.09, ["Neon"] = 45.94, ["Neon|Fly"] = 189, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 121.67, ["Mega"] = 261.19, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 265.97}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 19.69, ["Neon"] = 6.62, ["Neon|Fly"] = 52.81, ["Neon|Ride"] = 24.22, ["Neon|Fly|Ride"] = 146.87, ["Mega"] = 28.87, ["Mega|Fly"] = 146.87, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 129.93}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 6.36, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 74.42, ["Mega"] = 26.25, ["Mega|Ride"] = 73.49, ["Mega|Fly|Ride"] = 174.45}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 46.59, ["Ride"] = 16.14, ["Fly|Ride"] = 46.67, ["Neon"] = 10.06, ["Neon|Ride"] = 24.1, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 164.01, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 232.12}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 2.1, ["Fly"] = 57, ["Ride"] = 32.81, ["Fly|Ride"] = 261.19, ["Neon"] = 49.2, ["Neon|Ride"] = 208.15, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 105.39, ["Mega|Ride"] = 348.95, ["Mega|Fly|Ride"] = 350.7}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 33.06, ["Neon"] = 3.63, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 162.22, ["Mega"] = 19.59, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 56.32, ["Mega|Fly|Ride"] = 350.7}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 27.9, ["Ride"] = 17.19, ["Fly|Ride"] = 144.01, ["Neon"] = 7.65, ["Neon|Fly"] = 115.05, ["Neon|Ride"] = 20.85, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 32.27, ["Mega|Fly"] = 146.87, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 123.69}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 18.33, ["Fly|Ride"] = 53.68, ["Neon"] = 5.84, ["Neon|Fly"] = 37.85, ["Neon|Ride"] = 21.86, ["Neon|Fly|Ride"] = 62.91, ["Mega"] = 94.27, ["Mega|Fly"] = 146.87, ["Mega|Ride"] = 124.14, ["Mega|Fly|Ride"] = 131.28}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.38, ["Fly"] = 91.88, ["Ride"] = 178.5, ["Fly|Ride"] = 131.25, ["Neon"] = 9.98, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 98.34, ["Mega|Ride"] = 174.13, ["Mega|Fly|Ride"] = 207.38}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.4, ["Neon|Ride"] = 109.61, ["Neon|Fly|Ride"] = 159875.3, ["Mega"] = 14.34, ["Mega|Fly"] = 103.03, ["Mega|Ride"] = 44.91, ["Mega|Fly|Ride"] = 152.06}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 20.79, ["Neon"] = 3.13, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 24.51, ["Neon|Fly|Ride"] = 67.69, ["Mega"] = 18.68, ["Mega|Fly"] = 73.44, ["Mega|Ride"] = 31.29, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 3.46, ["Neon|Fly"] = 67.16, ["Neon|Ride"] = 61.15, ["Mega"] = 36.75, ["Mega|Ride"] = 190.32}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.48, ["Neon"] = 6.18, ["Neon|Fly|Ride"] = 420, ["Mega"] = 25.6, ["Mega|Ride"] = 292.69, ["Mega|Fly|Ride"] = 166.29}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.23, ["Ride"] = 16.54, ["Fly|Ride"] = 69.44, ["Neon"] = 3.94, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 48.9, ["Mega"] = 31.5, ["Mega|Ride"] = 42, ["Mega|Fly|Ride"] = 111.56}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 7.81, ["Ride"] = 45.94, ["Fly|Ride"] = 216.54, ["Neon"] = 83.12, ["Neon|Ride"] = 78.75, ["Mega"] = 389.82, ["Mega|Ride"] = 533.71, ["Mega|Fly|Ride"] = 613.72}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Ride"] = 53.81, ["Neon"] = 26.25, ["Neon|Ride"] = 157.5, ["Mega"] = 248.2, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 33.47, ["Fly|Ride"] = 131.25, ["Neon"] = 25.73, ["Neon|Ride"] = 146.87, ["Neon|Fly|Ride"] = 116.69, ["Mega"] = 294.67, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 388.5}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 12.99, ["Fly|Ride"] = 24.78, ["Neon"] = 2.1, ["Neon|Fly"] = 15.75, ["Neon|Ride"] = 13.5, ["Neon|Fly|Ride"] = 30.17, ["Mega"] = 14.44, ["Mega|Fly"] = 29.6, ["Mega|Ride"] = 24.94, ["Mega|Fly|Ride"] = 52.5}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 3.81, ["Fly"] = 118.13, ["Ride"] = 61.56, ["Neon"] = 12.5, ["Neon|Fly"] = 73.64, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 730.98, ["Mega"] = 131.52, ["Mega|Ride"] = 118.13}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.5, ["Neon"] = 2.1, ["Neon|Fly"] = 32.36, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 86.67, ["Mega"] = 14.69, ["Mega|Fly"] = 146.87, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.84, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 129.22, ["Mega"] = 26.32, ["Mega|Fly|Ride"] = 367.49}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 147.28, ["Ride"] = 21, ["Fly|Ride"] = 47.61, ["Neon"] = 10.5, ["Neon|Fly"] = 59.06, ["Neon|Ride"] = 32.99, ["Neon|Fly|Ride"] = 100.95, ["Mega"] = 153.45, ["Mega|Ride"] = 190.7, ["Mega|Fly|Ride"] = 274.98}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 221.03, ["Ride"] = 240.19, ["Fly|Ride"] = 876.72, ["Neon|Ride"] = 693, ["Neon|Fly|Ride"] = 966.71, ["Mega"] = 8767.18, ["Mega|Fly|Ride"] = 3566.06}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 5.16, ["Neon|Ride"] = 64.32, ["Mega"] = 68.25, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 662.8}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.85, ["Fly"] = 103.68, ["Ride"] = 37.01, ["Fly|Ride"] = 65.63, ["Neon"] = 24.2, ["Neon|Ride"] = 135.18, ["Neon|Fly|Ride"] = 175.37, ["Mega"] = 392.44, ["Mega|Ride"] = 327.69, ["Mega|Fly|Ride"] = 388.16}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 19.66, ["Ride"] = 16.15, ["Fly|Ride"] = 36.75, ["Neon"] = 5.25, ["Neon|Fly"] = 34, ["Neon|Ride"] = 27, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 49.79, ["Mega|Ride"] = 103.03, ["Mega|Fly|Ride"] = 147.69}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 73.05, ["Ride"] = 19.69, ["Fly|Ride"] = 142.62, ["Neon"] = 10.97, ["Neon|Fly"] = 147.28, ["Neon|Ride"] = 72.34, ["Neon|Fly|Ride"] = 117.28, ["Mega"] = 87.57, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 2.1, ["Fly"] = 27.12, ["Ride"] = 16.96, ["Fly|Ride"] = 39.38, ["Neon"] = 32.81, ["Neon|Fly"] = 101.25, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 144.38, ["Mega|Ride"] = 974.27, ["Mega|Fly|Ride"] = 271.81}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 2.15, ["Ride"] = 35.1, ["Fly|Ride"] = 259.91, ["Neon"] = 82.11, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 193.75, ["Mega|Ride"] = 327.69, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.62, ["Fly"] = 26.25, ["Ride"] = 15.75, ["Fly|Ride"] = 35.93, ["Neon"] = 41.48, ["Neon|Fly"] = 129.09, ["Neon|Ride"] = 26.38, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 258.25, ["Mega|Ride"] = 380.28, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 65.63, ["Ride"] = 86.56, ["Fly|Ride"] = 159.49, ["Neon"] = 333.38, ["Neon|Fly"] = 450.19, ["Neon|Ride"] = 393.24, ["Neon|Fly|Ride"] = 365.98, ["Mega"] = 2047.15, ["Mega|Ride"] = 1900.31, ["Mega|Fly|Ride"] = 1468.69}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 223.13, ["Fly"] = 439.61, ["Ride"] = 249.38, ["Fly|Ride"] = 337.32, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1296.49, ["Mega"] = 13150.76, ["Mega|Fly|Ride"] = 3506.88}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 57.16, ["Fly"] = 109.92, ["Ride"] = 65.1, ["Fly|Ride"] = 122, ["Neon"] = 493.2, ["Neon|Fly"] = 372.59, ["Neon|Ride"] = 311.07, ["Neon|Fly|Ride"] = 325.87, ["Mega|Fly|Ride"] = 1220.19}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 2.63, ["Fly"] = 288.42, ["Ride"] = 25.08, ["Fly|Ride"] = 65.61, ["Neon"] = 25.6, ["Neon|Fly"] = 47.28, ["Neon|Ride"] = 76.94, ["Neon|Fly|Ride"] = 149.63, ["Mega"] = 232.35, ["Mega|Ride"] = 196.75, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 10.14, ["Fly"] = 63, ["Ride"] = 31.62, ["Fly|Ride"] = 65.63, ["Neon"] = 60.38, ["Neon|Ride"] = 103.32, ["Neon|Fly|Ride"] = 144.79, ["Mega"] = 314.98, ["Mega|Ride"] = 364.88, ["Mega|Fly|Ride"] = 379.19}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 39.19, ["Ride"] = 15.74, ["Fly|Ride"] = 51.52, ["Neon"] = 3.81, ["Neon|Fly"] = 57.44, ["Neon|Ride"] = 24.04, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 57.1, ["Mega|Fly"] = 151.46, ["Mega|Ride"] = 86.63, ["Mega|Fly|Ride"] = 556.77}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 13.96, ["Fly"] = 70.34, ["Ride"] = 34.12, ["Fly|Ride"] = 67.16, ["Neon"] = 103.32, ["Neon|Fly"] = 293.45, ["Neon|Ride"] = 117.6, ["Neon|Fly|Ride"] = 326.59, ["Mega"] = 526.04, ["Mega|Ride"] = 657.56, ["Mega|Fly|Ride"] = 542.48}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.99, ["Ride"] = 15.75, ["Fly|Ride"] = 38.07, ["Neon"] = 19.68, ["Neon|Fly"] = 52.77, ["Neon|Ride"] = 28.62, ["Neon|Fly|Ride"] = 91.84, ["Mega"] = 144.24, ["Mega|Ride"] = 275.09, ["Mega|Fly|Ride"] = 297.55}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.1, ["Fly"] = 39, ["Ride"] = 21.62, ["Fly|Ride"] = 328.13, ["Neon"] = 39.4, ["Neon|Ride"] = 117.6, ["Neon|Fly|Ride"] = 146.87, ["Mega"] = 207.37, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 337.84}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 27.68, ["Ride"] = 19.39, ["Neon"] = 2.1, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 14.44, ["Mega|Ride"] = 43.86, ["Mega|Fly|Ride"] = 78.73}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 19.13, ["Fly|Ride"] = 44.63, ["Neon"] = 11.46, ["Neon|Fly"] = 109.61, ["Neon|Ride"] = 37.27, ["Neon|Fly|Ride"] = 147, ["Mega"] = 78.72, ["Mega|Ride"] = 146.87, ["Mega|Fly|Ride"] = 217}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 63, ["Ride"] = 22.29, ["Fly|Ride"] = 83.82, ["Neon"] = 21.67, ["Neon|Ride"] = 42, ["Mega"] = 144.37, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 271.81}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 105, ["Fly"] = 439.61, ["Ride"] = 105, ["Fly|Ride"] = 200.66, ["Neon"] = 420, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 523.69, ["Mega"] = 2482.57, ["Mega|Fly|Ride"] = 1975.32}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 5.58, ["Ride"] = 240.93, ["Fly|Ride"] = 131.25, ["Neon"] = 49.49, ["Neon|Ride"] = 89.25, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 280.61, ["Mega|Ride"] = 276.34, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 44.54, ["Ride"] = 24.2, ["Fly|Ride"] = 43.04, ["Neon"] = 15.65, ["Neon|Ride"] = 62.99, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 262.5, ["Mega|Ride"] = 187.69, ["Mega|Fly|Ride"] = 328.12}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 11.82, ["Ride"] = 49.76, ["Fly|Ride"] = 170.63, ["Neon"] = 99.3, ["Neon|Ride"] = 166.23, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly"] = 876.72, ["Mega|Ride"] = 492.19, ["Mega|Fly|Ride"] = 818.66}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 6.45}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 5.16, ["Fly"] = 20.9, ["Ride"] = 72.19, ["Fly|Ride"] = 130.44, ["Neon"] = 68.25, ["Neon|Ride"] = 108.5, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 616.88, ["Mega|Ride"] = 642.21, ["Mega|Fly|Ride"] = 876.72}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 17.98, ["Fly"] = 32.82, ["Ride"] = 30.17, ["Fly|Ride"] = 55.02, ["Neon"] = 91.88, ["Neon|Fly"] = 131.9, ["Neon|Ride"] = 131.52, ["Neon|Fly|Ride"] = 150.92, ["Mega"] = 1414.82, ["Mega|Fly|Ride"] = 496.39}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 2.63, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 146.47, ["Mega"] = 32.89, ["Mega|Fly"] = 190.7, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 328.79}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 2.62, ["Fly"] = 26.23, ["Ride"] = 21.25, ["Fly|Ride"] = 65.63, ["Neon"] = 65.77, ["Mega"] = 288.62, ["Mega|Fly"] = 414.57, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 526.04}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 28.96, ["Ride"] = 17.07, ["Fly|Ride"] = 40.85, ["Neon"] = 17.06, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 30.85, ["Neon|Fly|Ride"] = 70.63, ["Mega"] = 194.31, ["Mega|Ride"] = 160.12, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 29.08, ["Neon"] = 3.68, ["Neon|Ride"] = 42, ["Mega"] = 82.21, ["Mega|Ride"] = 116.19, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 26.78, ["Fly"] = 72.18, ["Ride"] = 64.32, ["Fly|Ride"] = 136.5, ["Neon"] = 185.07, ["Neon|Ride"] = 179.81, ["Neon|Fly|Ride"] = 576.19, ["Mega"] = 985.37, ["Mega|Ride"] = 689.07, ["Mega|Fly|Ride"] = 766.74}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 2.62, ["Ride"] = 26.25, ["Fly|Ride"] = 121.87, ["Neon"] = 43.98, ["Neon|Fly|Ride"] = 183.75, ["Mega|Ride"] = 331.34}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 2.63, ["Fly"] = 33.59, ["Ride"] = 19.67, ["Fly|Ride"] = 57.52, ["Neon"] = 12.43, ["Neon|Fly"] = 87.94, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 119.51, ["Mega"] = 105, ["Mega|Fly|Ride"] = 278.58}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 63, ["Fly"] = 145.01, ["Ride"] = 129.69, ["Neon"] = 439.61, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 540.28, ["Mega"] = 4634.89, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 2481.88}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 8.86, ["Fly"] = 47.58, ["Ride"] = 22.33, ["Fly|Ride"] = 58.47, ["Neon"] = 36.75, ["Neon|Ride"] = 42.15, ["Neon|Fly|Ride"] = 114.18, ["Mega"] = 273, ["Mega|Ride"] = 279.47, ["Mega|Fly|Ride"] = 336.46}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 75.59, ["Fly"] = 143.07, ["Ride"] = 127.31, ["Fly|Ride"] = 235.2, ["Neon"] = 262.39, ["Neon|Ride"] = 264.42, ["Neon|Fly|Ride"] = 236.24, ["Mega"] = 1111.69, ["Mega|Ride"] = 1643.86, ["Mega|Fly|Ride"] = 1153.68}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 19.57, ["Ride"] = 72.05, ["Fly|Ride"] = 162.42, ["Neon"] = 82.21, ["Neon|Ride"] = 115.65, ["Neon|Fly|Ride"] = 248.2, ["Mega"] = 353.06, ["Mega|Ride"] = 340.32, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 4.55, ["Fly"] = 39.38, ["Ride"] = 26.4, ["Fly|Ride"] = 72.43, ["Neon"] = 91.87, ["Neon|Fly|Ride"] = 146.87, ["Mega"] = 662.67, ["Mega|Ride"] = 583.03, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 18.38, ["Ride"] = 52.5, ["Fly|Ride"] = 204.22, ["Neon"] = 76.12, ["Neon|Ride"] = 87.69, ["Neon|Fly|Ride"] = 438.38, ["Mega"] = 473.59, ["Mega|Ride"] = 387.85, ["Mega|Fly|Ride"] = 432.91}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 7.87, ["Ride"] = 34.12, ["Fly|Ride"] = 78.75, ["Neon"] = 43.98, ["Neon|Ride"] = 57.64, ["Neon|Fly|Ride"] = 150.84, ["Mega"] = 249.38, ["Mega|Ride"] = 346.5, ["Mega|Fly|Ride"] = 449.33}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.6, ["Neon|Fly"] = 103.32, ["Neon|Ride"] = 210, ["Mega"] = 19.69, ["Mega|Ride"] = 146.87}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 10.21, ["Ride"] = 70.16, ["Fly|Ride"] = 325.9, ["Neon"] = 45.94, ["Neon|Ride"] = 243.99, ["Mega"] = 239.54, ["Mega|Ride"] = 522.38, ["Mega|Fly|Ride"] = 1046.6}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 130.44, ["Ride"] = 29.69, ["Neon"] = 26.23, ["Neon|Fly"] = 116.94, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 252.67, ["Mega|Ride"] = 427.42, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 6.04, ["Ride"] = 38.07, ["Neon"] = 16.46, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 187.69, ["Mega|Ride"] = 292.62, ["Mega|Fly|Ride"] = 519.74}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 538.1, ["Ride"] = 557.82, ["Fly|Ride"] = 603.75, ["Neon"] = 2009.89, ["Neon|Ride"] = 1771.88, ["Neon|Fly|Ride"] = 1646.12, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 6.41, ["Fly"] = 45.47, ["Ride"] = 23.29, ["Fly|Ride"] = 65.63, ["Neon"] = 37.38, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 204.94, ["Mega|Ride"] = 381.05, ["Mega|Fly|Ride"] = 366.03}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 7.62, ["Fly"] = 66.85, ["Ride"] = 26.25, ["Fly|Ride"] = 54.1, ["Neon"] = 95.25, ["Neon|Fly"] = 315, ["Neon|Ride"] = 65.42, ["Neon|Fly|Ride"] = 105, ["Mega"] = 331.88, ["Mega|Ride"] = 402.21, ["Mega|Fly|Ride"] = 681.45}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.1, ["Fly"] = 24.93, ["Ride"] = 28.5, ["Fly|Ride"] = 50.99, ["Neon"] = 16.5, ["Neon|Ride"] = 32.3, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 198.19, ["Mega|Ride"] = 263.03}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 27.57, ["Fly|Ride"] = 90.57, ["Neon"] = 10.4, ["Neon|Ride"] = 35.06, ["Neon|Fly|Ride"] = 104.83, ["Mega"] = 73.41, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 223.38}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 29.69, ["Ride"] = 24.2, ["Fly|Ride"] = 52.5, ["Neon"] = 2.63, ["Neon|Ride"] = 32.33, ["Neon|Fly|Ride"] = 104.98, ["Mega"] = 22.05, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1378.13}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 7.16, ["Ride"] = 28.75, ["Fly|Ride"] = 118.13, ["Neon"] = 47.25, ["Neon|Ride"] = 112.87, ["Neon|Fly|Ride"] = 366.09, ["Mega"] = 341.25, ["Mega|Ride"] = 421.94, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 19.26, ["Neon"] = 6.56, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 1023.59, ["Mega"] = 52.5, ["Mega|Ride"] = 87.69, ["Mega|Fly|Ride"] = 183.1}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 11.53, ["Fly"] = 335.13, ["Ride"] = 100.26, ["Fly|Ride"] = 69.5, ["Neon"] = 68.15, ["Neon|Ride"] = 111.83, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 291.63, ["Mega|Ride"] = 394.53, ["Mega|Fly|Ride"] = 495.14}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 420, ["Ride"] = 452.82, ["Fly|Ride"] = 535.5, ["Neon"] = 1715.99, ["Neon|Ride"] = 1730.21, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 8219.24, ["Mega|Fly|Ride"] = 6357.75}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 6.4, ["Fly"] = 196.88, ["Ride"] = 42, ["Neon"] = 70.34, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 198.61, ["Mega"] = 306.87, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Ride"] = 36.75, ["Fly|Ride"] = 118.11, ["Neon"] = 2.62, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 36.39, ["Mega|Fly"] = 117.28, ["Mega|Ride"] = 72.15, ["Mega|Fly|Ride"] = 165.38}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Fly|Ride"] = 98.44, ["Neon"] = 2.1, ["Neon|Ride"] = 59.07, ["Mega"] = 28.87, ["Mega|Ride"] = 124.59, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 34.13, ["Fly"] = 114.76, ["Ride"] = 108.99, ["Neon"] = 204.26, ["Neon|Ride"] = 438.37, ["Neon|Fly|Ride"] = 590.63, ["Mega"] = 730.98, ["Mega|Ride"] = 716.73, ["Mega|Fly|Ride"] = 822.5}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 9.48, ["Neon"] = 104.43, ["Neon|Ride"] = 275.09, ["Neon|Fly|Ride"] = 876.72, ["Mega"] = 579.52, ["Mega|Ride"] = 483, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 3.61, ["Ride"] = 31.29, ["Neon"] = 101.19, ["Neon|Ride"] = 175.86, ["Mega"] = 678.93, ["Mega|Ride"] = 648.79, ["Mega|Fly|Ride"] = 1200.72}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 19.06, ["Ride"] = 56.36, ["Fly|Ride"] = 236.25, ["Neon"] = 144.38, ["Neon|Ride"] = 177.51, ["Neon|Fly|Ride"] = 241.5, ["Mega"] = 723.3, ["Mega|Ride"] = 1753.44, ["Mega|Fly|Ride"] = 730.98}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 367.5, ["Ride"] = 393.74, ["Fly|Ride"] = 747.33, ["Neon"] = 918.75, ["Neon|Ride"] = 1485.91, ["Neon|Fly|Ride"] = 1199.63, ["Mega|Fly|Ride"] = 2922.76}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 6.57, ["Ride"] = 38.48, ["Fly|Ride"] = 154.83, ["Neon"] = 85.3, ["Neon|Ride"] = 196.58, ["Neon|Fly|Ride"] = 146.87, ["Mega|Ride"] = 561.1, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 2.43, ["Ride"] = 27.72, ["Neon"] = 104.99, ["Neon|Ride"] = 39.38, ["Mega"] = 170.63, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 45.85, ["Ride"] = 426.56, ["Neon"] = 169.31, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 542.48, ["Mega"] = 459.38, ["Mega|Ride"] = 494.7, ["Mega|Fly|Ride"] = 643.02}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.49, ["Fly|Ride"] = 219.19, ["Neon"] = 7.69, ["Neon|Fly"] = 86.45, ["Neon|Ride"] = 57.74, ["Neon|Fly|Ride"] = 283.86, ["Mega"] = 76.13, ["Mega|Ride"] = 175.37, ["Mega|Fly|Ride"] = 288.48}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 45.94, ["Ride"] = 58.97, ["Fly|Ride"] = 216.38, ["Neon"] = 262.43, ["Neon|Ride"] = 350.7, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1589.06, ["Mega|Ride"] = 2901.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 108.82, ["Ride"] = 28.25, ["Neon"] = 11.71, ["Neon|Fly"] = 190.7, ["Neon|Ride"] = 43.86, ["Neon|Fly|Ride"] = 146.87, ["Mega"] = 73.05, ["Mega|Ride"] = 101.07, ["Mega|Fly|Ride"] = 205.73}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Ride"] = 54.48, ["Fly|Ride"] = 109.92, ["Neon"] = 3.03, ["Neon|Ride"] = 40.6, ["Neon|Fly|Ride"] = 105, ["Mega"] = 39.38, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 48.57, ["Mega|Fly|Ride"] = 162.75}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 65.77, ["Neon"] = 13.02, ["Neon|Ride"] = 56.67, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 93.19, ["Mega|Ride"] = 142.48, ["Mega|Fly|Ride"] = 241.5}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 65.24, ["Fly"] = 105, ["Ride"] = 78.71, ["Fly|Ride"] = 133.06, ["Neon"] = 367.5, ["Neon|Ride"] = 362.92, ["Neon|Fly|Ride"] = 496.39, ["Mega|Ride"] = 1147.41, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 6.04, ["Ride"] = 36.08, ["Neon"] = 22.61, ["Neon|Fly"] = 350.44, ["Neon|Fly|Ride"] = 146.87, ["Mega"] = 69.47, ["Mega|Fly"] = 292.62, ["Mega|Ride"] = 215.25, ["Mega|Fly|Ride"] = 348.5}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 73.64, ["Ride"] = 29.6, ["Fly|Ride"] = 131.25, ["Neon"] = 9.18, ["Neon|Ride"] = 78.75, ["Mega"] = 62.41, ["Mega|Fly"] = 210, ["Mega|Ride"] = 97.13, ["Mega|Fly|Ride"] = 241.4}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.67, ["Fly"] = 109.92, ["Ride"] = 32.82, ["Fly|Ride"] = 98.44, ["Neon"] = 32.82, ["Neon|Fly|Ride"] = 166.35, ["Mega"] = 366.03, ["Mega|Ride"] = 355.11, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 5.07, ["Fly"] = 78.75, ["Ride"] = 58.14, ["Fly|Ride"] = 114.19, ["Neon"] = 36.66, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 170.62, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 482.22}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 71.61, ["Neon"] = 6.03, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 218.1, ["Mega"] = 42.75, ["Mega|Ride"] = 141.74, ["Mega|Fly|Ride"] = 314.54}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.44, ["Fly|Ride"] = 62.86, ["Neon"] = 4.39, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 26.4, ["Neon|Fly|Ride"] = 103.49, ["Mega"] = 40.69, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.52, ["Fly"] = 20.58, ["Ride"] = 23.55, ["Fly|Ride"] = 57.74, ["Neon"] = 18.1, ["Neon|Fly"] = 104.12, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 117.28, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 292.62}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 34.92, ["Fly"] = 73.64, ["Ride"] = 29.08, ["Fly|Ride"] = 91.24, ["Neon"] = 144.38, ["Neon|Ride"] = 248.71, ["Neon|Fly|Ride"] = 284.94, ["Mega"] = 485.63, ["Mega|Fly"] = 438.37, ["Mega|Ride"] = 543.38, ["Mega|Fly|Ride"] = 662.67}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 64.97, ["Ride"] = 97.13, ["Fly|Ride"] = 146.61, ["Neon"] = 373.96, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 2177.56, ["Mega|Ride"] = 1315.09, ["Mega|Fly|Ride"] = 1743.16}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 19.52, ["Neon"] = 4.9, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 146.87, ["Mega"] = 43.86, ["Mega|Fly"] = 672, ["Mega|Ride"] = 82.21, ["Mega|Fly|Ride"] = 257.55}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 17.64, ["Ride"] = 15.44, ["Fly|Ride"] = 43.98, ["Neon"] = 3.94, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 18, ["Neon|Fly|Ride"] = 72.34, ["Mega"] = 43.32, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 3.14, ["Fly"] = 183.75, ["Ride"] = 38.03, ["Neon"] = 40.69, ["Neon|Ride"] = 160.12, ["Neon|Fly|Ride"] = 146.87, ["Mega"] = 555.64, ["Mega|Ride"] = 275.62, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 416.06, ["Ride"] = 622.09, ["Fly|Ride"] = 584.07, ["Neon"] = 4383.61, ["Neon|Fly|Ride"] = 1461.95, ["Mega|Fly|Ride"] = 6163.5}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 23.37, ["Fly"] = 109.23, ["Ride"] = 49.77, ["Fly|Ride"] = 144.37, ["Neon"] = 217.75, ["Neon|Ride"] = 219.19, ["Neon|Fly|Ride"] = 255.94, ["Mega"] = 720.57, ["Mega|Ride"] = 854.81, ["Mega|Fly|Ride"] = 918.3}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 27.46, ["Fly|Ride"] = 91.88, ["Neon"] = 10.28, ["Neon|Ride"] = 57, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 70.61, ["Mega|Ride"] = 128.54, ["Mega|Fly|Ride"] = 323.32}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 65.62, ["Fly|Ride"] = 261.98, ["Neon"] = 73.47, ["Mega|Fly|Ride"] = 438.37}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 30.55, ["Fly"] = 168.91, ["Ride"] = 62.5, ["Fly|Ride"] = 83.81, ["Neon"] = 194.25, ["Neon|Ride"] = 260.54, ["Neon|Fly|Ride"] = 286.13, ["Mega"] = 2630.16, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1002.75}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 103.69, ["Fly"] = 165.97, ["Ride"] = 144.15, ["Fly|Ride"] = 190.32, ["Neon"] = 439.61, ["Neon|Ride"] = 548.42, ["Neon|Fly|Ride"] = 446.25, ["Mega"] = 3215.38, ["Mega|Fly|Ride"] = 6575.39}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 234.44, ["Ride"] = 304.5, ["Fly|Ride"] = 337.42, ["Neon"] = 917.86, ["Neon|Ride"] = 800.63, ["Neon|Fly|Ride"] = 996.19, ["Mega|Fly|Ride"] = 2867.82}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 11.46, ["Ride"] = 57, ["Fly|Ride"] = 246.91, ["Neon"] = 81.38, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 494.26, ["Mega|Ride"] = 416.03, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.96, ["Ride"] = 17.57, ["Fly|Ride"] = 39.29, ["Neon"] = 7.28, ["Neon|Ride"] = 28.87, ["Neon|Fly|Ride"] = 83.16, ["Mega"] = 78.65, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.47, ["Fly"] = 50.57, ["Ride"] = 19.69, ["Fly|Ride"] = 62.92, ["Neon"] = 26.24, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 43.05, ["Neon|Fly|Ride"] = 106.55, ["Mega"] = 293.08, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 249.35, ["Ride"] = 370.57, ["Fly|Ride"] = 576.03, ["Neon"] = 1534.28, ["Neon|Fly|Ride"] = 1676.73, ["Mega"] = 10958.97, ["Mega|Fly|Ride"] = 6269.82}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 34.09, ["Neon"] = 14.44, ["Neon|Ride"] = 139.41, ["Neon|Fly|Ride"] = 146.87, ["Mega"] = 35.43, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 318.94}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 2.62, ["Fly"] = 24.84, ["Ride"] = 17.06, ["Fly|Ride"] = 43.14, ["Neon"] = 26.44, ["Neon|Ride"] = 39.59, ["Neon|Fly|Ride"] = 79.49, ["Mega"] = 217, ["Mega|Ride"] = 175.85, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 15.15, ["Fly"] = 6562.5, ["Ride"] = 58.47, ["Neon"] = 104.07, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 326.82, ["Mega"] = 557.82, ["Mega|Ride"] = 729.88, ["Mega|Fly|Ride"] = 633.55}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 120.65, ["Fly"] = 131.25, ["Ride"] = 162.68, ["Fly|Ride"] = 184.65, ["Neon|Ride"] = 829.41, ["Neon|Fly|Ride"] = 590.63, ["Mega|Fly|Ride"] = 1753.44}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 13.02, ["Fly"] = 39.38, ["Ride"] = 28.5, ["Fly|Ride"] = 63, ["Neon"] = 105, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 146.87, ["Mega"] = 511.8, ["Mega|Ride"] = 422.63, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 53.82, ["Neon"] = 3.94, ["Neon|Ride"] = 65.63, ["Mega"] = 25.96, ["Mega|Ride"] = 156.19, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 32.7, ["Ride"] = 18.26, ["Fly|Ride"] = 86.16, ["Neon"] = 3.19, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 28.25, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 21.94, ["Mega|Fly"] = 103.03, ["Mega|Ride"] = 42.95, ["Mega|Fly|Ride"] = 232.35}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 12.5, ["Fly"] = 103.28, ["Ride"] = 105.21, ["Fly|Ride"] = 325.34, ["Neon"] = 40.69, ["Neon|Ride"] = 101.71, ["Neon|Fly|Ride"] = 234.12, ["Mega"] = 179.82, ["Mega|Ride"] = 263.81, ["Mega|Fly|Ride"] = 343.88}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1050, ["Fly|Ride"] = 1378.13, ["Neon"] = 3937.5, ["Neon|Ride"] = 4383.61, ["Neon|Fly|Ride"] = 4017.24, ["Mega|Fly|Ride"] = 10498.95}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 419.97, ["Ride"] = 519.73, ["Fly|Ride"] = 540.53, ["Neon"] = 1680, ["Neon|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 1573.68, ["Mega"] = 15342.55, ["Mega|Fly|Ride"] = 6575.39}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 321.85, ["Fly"] = 420.31, ["Ride"] = 367.5, ["Fly|Ride"] = 426.2, ["Neon"] = 656.25, ["Neon|Ride"] = 708.75, ["Neon|Fly|Ride"] = 724.49, ["Mega|Ride"] = 3654.82, ["Mega|Fly|Ride"] = 2916.24}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 253.2, ["Fly"] = 363.78, ["Ride"] = 337.32, ["Fly|Ride"] = 392.53, ["Neon"] = 669.38, ["Neon|Ride"] = 735, ["Neon|Fly|Ride"] = 677.24, ["Mega|Fly|Ride"] = 3606.61}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 43.97, ["Ride"] = 15.75, ["Fly|Ride"] = 52.49, ["Neon"] = 5.25, ["Neon|Ride"] = 34.98, ["Neon|Fly|Ride"] = 116.67, ["Mega"] = 55.85, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 269.07, ["Fly"] = 1466.07, ["Ride"] = 374.07, ["Fly|Ride"] = 483.31, ["Neon"] = 1312.5, ["Neon|Ride"] = 1463.87, ["Neon|Fly|Ride"] = 1520.03, ["Mega"] = 22210.54, ["Mega|Ride"] = 6283.88, ["Mega|Fly|Ride"] = 4279.55}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 5.25, ["Fly"] = 183.75, ["Ride"] = 129.94, ["Neon"] = 32.71, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 234.94, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 830.72}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 23.57, ["Ride"] = 16.48, ["Fly|Ride"] = 36.3, ["Neon"] = 6.3, ["Neon|Ride"] = 54.81, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 128.63, ["Mega|Ride"] = 192.31, ["Mega|Fly|Ride"] = 168.33}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Neon"] = 3.92, ["Mega"] = 22.32, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 177.62}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 62.5, ["Ride"] = 131.25, ["Fly|Ride"] = 459.38, ["Neon"] = 236.25, ["Neon|Ride"] = 359.73, ["Mega"] = 1049.9, ["Mega|Ride"] = 733.69, ["Mega|Fly|Ride"] = 787.97}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 8290.13, ["Ride"] = 22.23, ["Fly|Ride"] = 68.25, ["Neon"] = 18.67, ["Mega"] = 350.7, ["Mega|Ride"] = 303.57, ["Mega|Fly|Ride"] = 446.24}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 43.98, ["Neon"] = 3.61, ["Neon|Ride"] = 57.73, ["Neon|Fly|Ride"] = 141.93, ["Mega"] = 23.63, ["Mega|Fly"] = 169.89, ["Mega|Ride"] = 67.03, ["Mega|Fly|Ride"] = 135.19}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 3.94, ["Fly"] = 131.03, ["Ride"] = 68.1, ["Fly|Ride"] = 91.88, ["Neon"] = 27.56, ["Neon|Ride"] = 99.21, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 213.29, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 355.71}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.51, ["Fly"] = 29.69, ["Ride"] = 18.38, ["Fly|Ride"] = 56.7, ["Neon"] = 162.22, ["Neon|Ride"] = 59.19, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 238.85, ["Mega|Ride"] = 263.03, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 7.68, ["Ride"] = 39.38, ["Fly|Ride"] = 166.64, ["Neon"] = 68.25, ["Neon|Ride"] = 175.37, ["Neon|Fly|Ride"] = 331.34, ["Mega"] = 524.99, ["Mega|Ride"] = 563.39}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 6634.19, ["Ride"] = 24.7, ["Fly|Ride"] = 196.87, ["Neon"] = 70.87, ["Neon|Ride"] = 215.41, ["Neon|Fly|Ride"] = 744.58, ["Mega"] = 420, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 72.13, ["Ride"] = 16.37, ["Fly|Ride"] = 42.95, ["Neon"] = 5.07, ["Neon|Fly"] = 81.65, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 131.52, ["Mega"] = 48.57, ["Mega|Fly|Ride"] = 248.25}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 209.99, ["Fly"] = 242.9, ["Ride"] = 196.86, ["Fly|Ride"] = 262.5, ["Neon"] = 996.8, ["Neon|Ride"] = 2739.76, ["Neon|Fly|Ride"] = 1459.75, ["Mega"] = 8767.18, ["Mega|Fly|Ride"] = 4909.64}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 25.66, ["Ride"] = 14.44, ["Fly|Ride"] = 37.66, ["Neon"] = 3.62, ["Neon|Fly"] = 37.32, ["Neon|Ride"] = 20.82, ["Neon|Fly|Ride"] = 56.97, ["Mega"] = 38.07, ["Mega|Ride"] = 47.24, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 7.85, ["Ride"] = 44.77, ["Fly|Ride"] = 235.1, ["Neon"] = 65.63, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 767.54, ["Mega"] = 436.19, ["Mega|Ride"] = 309.74, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 32.82, ["Ride"] = 78.75, ["Fly|Ride"] = 183.75, ["Neon"] = 216.56, ["Neon|Ride"] = 355.69, ["Neon|Fly|Ride"] = 414.23, ["Mega"] = 780.13, ["Mega|Ride"] = 1029.07, ["Mega|Fly|Ride"] = 944.99}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 203.44, ["Fly"] = 274.36, ["Ride"] = 240.47, ["Fly|Ride"] = 292.69, ["Neon"] = 777, ["Neon|Fly"] = 1658.78, ["Neon|Ride"] = 711.37, ["Neon|Fly|Ride"] = 727.02, ["Mega|Fly|Ride"] = 2887.5}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 19.84, ["Fly"] = 166.64, ["Ride"] = 166.35, ["Neon"] = 141.38, ["Neon|Ride"] = 139.95, ["Mega"] = 287.34, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 433.98}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 7.43, ["Ride"] = 58.46, ["Fly|Ride"] = 147.9, ["Neon"] = 183.75, ["Neon|Fly"] = 166.64, ["Neon|Ride"] = 328.62, ["Mega"] = 1753.44, ["Mega|Ride"] = 1461.95, ["Mega|Fly|Ride"] = 730.98}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 980.81, ["Ride"] = 945, ["Fly|Ride"] = 1027.69, ["Neon"] = 5118.75, ["Neon|Ride"] = 4383.75, ["Neon|Fly|Ride"] = 4028.07, ["Mega|Fly|Ride"] = 17972.71}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 4.73, ["Fly"] = 28.6, ["Ride"] = 19.67, ["Fly|Ride"] = 45.93, ["Neon"] = 43.86, ["Neon|Fly"] = 76.43, ["Neon|Ride"] = 87.69, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 248.2, ["Mega|Ride"] = 263.03, ["Mega|Fly|Ride"] = 302.3}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 5.84, ["Fly"] = 51.19, ["Ride"] = 41.14, ["Fly|Ride"] = 133.88, ["Neon"] = 36.74, ["Neon|Ride"] = 124.13, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 196.88, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 251.99, ["Mega|Fly|Ride"] = 341.23}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 87.94, ["Ride"] = 29.3, ["Fly|Ride"] = 81.35, ["Neon"] = 11.7, ["Neon|Ride"] = 35.8, ["Neon|Fly|Ride"] = 146.87, ["Mega"] = 81.38, ["Mega|Ride"] = 366.03, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 16.46, ["Ride"] = 32.81, ["Fly|Ride"] = 124.83, ["Neon"] = 69.2, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 179.34, ["Mega"] = 446.25, ["Mega|Ride"] = 427.49, ["Mega|Fly|Ride"] = 471.09}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.1, ["Fly"] = 25.73, ["Ride"] = 21, ["Fly|Ride"] = 42.78, ["Neon"] = 15.75, ["Neon|Fly"] = 58.66, ["Neon|Ride"] = 34.56, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 192.27, ["Mega|Fly"] = 280.98, ["Mega|Ride"] = 169.31, ["Mega|Fly|Ride"] = 194.24}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.49, ["Fly"] = 32.75, ["Ride"] = 32.24, ["Fly|Ride"] = 131.25, ["Neon"] = 12.38, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 49.66, ["Neon|Fly|Ride"] = 107.57, ["Mega"] = 152.15, ["Mega|Ride"] = 219.19, ["Mega|Fly|Ride"] = 275.61}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 203.42, ["Ride"] = 337.42, ["Fly|Ride"] = 439.61, ["Neon"] = 1207.81, ["Neon|Fly|Ride"] = 1183.01, ["Mega|Fly|Ride"] = 3475.28}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 21.36, ["Fly|Ride"] = 91.88, ["Neon"] = 10.5, ["Neon|Ride"] = 82.69, ["Neon|Fly|Ride"] = 212.62, ["Mega"] = 83.46, ["Mega|Ride"] = 161.44, ["Mega|Fly|Ride"] = 350.7}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 2.1, ["Ride"] = 147.28, ["Fly|Ride"] = 88.87, ["Neon"] = 18.24, ["Neon|Ride"] = 188.27, ["Mega"] = 195.57, ["Mega|Ride"] = 359.47}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.49, ["Fly"] = 94.76, ["Ride"] = 40.38, ["Neon"] = 10.39, ["Neon|Ride"] = 59.07, ["Mega"] = 103.69, ["Mega|Ride"] = 152.15, ["Mega|Fly|Ride"] = 585.22}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 62.91, ["Ride"] = 131.77, ["Fly|Ride"] = 261.19, ["Neon"] = 447.56, ["Neon|Ride"] = 512.82, ["Neon|Fly|Ride"] = 548.63, ["Mega"] = 2630.16, ["Mega|Ride"] = 1533.17, ["Mega|Fly|Ride"] = 2166.94}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 17.73, ["Fly"] = 89.87, ["Ride"] = 59.31, ["Fly|Ride"] = 285.75, ["Neon"] = 103.93, ["Neon|Ride"] = 219.19, ["Neon|Fly|Ride"] = 341.93, ["Mega"] = 682.5, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 17.99, ["Fly"] = 263.44, ["Ride"] = 47.24, ["Fly|Ride"] = 117.6, ["Neon"] = 98.04, ["Neon|Ride"] = 114.83, ["Neon|Fly|Ride"] = 210, ["Mega"] = 547.26, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 6.56, ["Neon"] = 13.96, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 223.13, ["Mega"] = 207.25}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 39.29, ["Fly"] = 132.36, ["Ride"] = 85.99, ["Fly|Ride"] = 203.85, ["Neon"] = 183.74, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 215.27, ["Neon|Fly|Ride"] = 290.07, ["Mega|Fly|Ride"] = 905.63}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 22.01, ["Fly|Ride"] = 105, ["Neon"] = 6.34, ["Neon|Fly|Ride"] = 130.44, ["Mega"] = 91.88, ["Mega|Ride"] = 292.62, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 16.87, ["Fly"] = 53.82, ["Ride"] = 25.96, ["Fly|Ride"] = 72.34, ["Neon"] = 64.56, ["Neon|Fly"] = 84, ["Neon|Ride"] = 67.01, ["Neon|Fly|Ride"] = 164.01, ["Mega"] = 364.34, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 393.44, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 49.76, ["Fly"] = 203.42, ["Ride"] = 78.74, ["Fly|Ride"] = 139.13, ["Neon"] = 275.63, ["Neon|Fly"] = 288.75, ["Neon|Ride"] = 325.5, ["Neon|Fly|Ride"] = 358.21, ["Mega|Ride"] = 1499.21, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 19.74, ["Ride"] = 16.11, ["Fly|Ride"] = 43.98, ["Neon"] = 2.1, ["Neon|Fly"] = 21, ["Neon|Ride"] = 19.63, ["Neon|Fly|Ride"] = 41.02, ["Mega"] = 27.32, ["Mega|Ride"] = 42.67, ["Mega|Fly|Ride"] = 98.7}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.52, ["Ride"] = 51.59, ["Fly|Ride"] = 78.75, ["Neon"] = 19.62, ["Neon|Ride"] = 72.18, ["Neon|Fly|Ride"] = 159.75, ["Mega"] = 175.37, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 221.03, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 15.09, ["Ride"] = 52.49, ["Fly|Ride"] = 117.6, ["Neon"] = 119.44, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 536.82, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 585.22}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 19.26, ["Neon"] = 2.1, ["Neon|Ride"] = 19.56, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 23, ["Mega|Ride"] = 57.1, ["Mega|Fly|Ride"] = 120.75}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 40.62, ["Fly"] = 209.99, ["Ride"] = 91.88, ["Fly|Ride"] = 2625, ["Neon"] = 169.32, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 424.13, ["Mega"] = 1082.76, ["Mega|Fly"] = 853.13, ["Mega|Ride"] = 705.72, ["Mega|Fly|Ride"] = 969.78}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 11.71, ["Fly"] = 43.98, ["Ride"] = 28.88, ["Fly|Ride"] = 101.07, ["Neon"] = 238.93, ["Neon|Ride"] = 136.64, ["Neon|Fly|Ride"] = 168.78, ["Mega|Ride"] = 458.07, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 2.61, ["Ride"] = 62.99, ["Neon"] = 59.04, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 89.94, ["Neon|Fly|Ride"] = 218.1, ["Mega"] = 288.75, ["Mega|Ride"] = 403.91, ["Mega|Fly|Ride"] = 511.8}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 9.19, ["Fly"] = 2191.82, ["Ride"] = 86.63, ["Fly|Ride"] = 249.61, ["Neon"] = 44.15, ["Neon|Ride"] = 95.63, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 284.94, ["Mega|Fly"] = 306.87, ["Mega|Ride"] = 246.75, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 37.38, ["Fly|Ride"] = 196.88, ["Neon"] = 6.66, ["Neon|Fly"] = 73.64, ["Neon|Ride"] = 39.38, ["Mega"] = 69.57, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 85.78, ["Mega|Fly|Ride"] = 289.32}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Fly|Ride"] = 89.25, ["Neon"] = 3.59, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 166.29, ["Mega"] = 45.94, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 20.88}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 61.17, ["Fly"] = 78.75, ["Ride"] = 58.5, ["Fly|Ride"] = 96.46, ["Neon"] = 144.63, ["Neon|Ride"] = 219.19, ["Neon|Fly|Ride"] = 312.38, ["Mega"] = 1854.36, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 888.56}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 65.63, ["Neon"] = 2.1, ["Neon|Ride"] = 27.19, ["Mega"] = 34.13, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 328.79}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 525, ["Ride"] = 525, ["Fly|Ride"] = 572.25, ["Neon"] = 1973.37, ["Mega"] = 13150.76, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 2.29, ["Fly"] = 49.38, ["Ride"] = 33.74, ["Fly|Ride"] = 58.27, ["Neon"] = 72.97, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 116.69, ["Mega"] = 430.62, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 643.31}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.1, ["Fly"] = 29.11, ["Ride"] = 19.58, ["Fly|Ride"] = 46.73, ["Neon"] = 21.57, ["Neon|Ride"] = 31.25, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 161.33, ["Mega|Fly"] = 219.19, ["Mega|Ride"] = 166.29, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 11.96, ["Fly"] = 56.06, ["Ride"] = 52.5, ["Fly|Ride"] = 87.05, ["Neon"] = 114.19, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 469.06, ["Mega|Ride"] = 388.5, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.1, ["Fly"] = 43.98, ["Ride"] = 38.57, ["Fly|Ride"] = 72.16, ["Neon"] = 47.57, ["Neon|Fly"] = 73.64, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 282.19, ["Mega|Ride"] = 291.53, ["Mega|Fly|Ride"] = 542.48}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 6.57, ["Ride"] = 32.26, ["Fly|Ride"] = 202.13, ["Neon"] = 78.66, ["Neon|Ride"] = 118.12, ["Neon|Fly|Ride"] = 144.66, ["Mega"] = 546.87, ["Mega|Ride"] = 419.9, ["Mega|Fly|Ride"] = 531.57}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 4.2, ["Ride"] = 73.44, ["Fly|Ride"] = 131.25, ["Neon"] = 34.13, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 102.38, ["Neon|Fly|Ride"] = 282.77, ["Mega"] = 207.93, ["Mega|Ride"] = 363.85, ["Mega|Fly|Ride"] = 292.62}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 49.76, ["Ride"] = 13.13, ["Fly|Ride"] = 34.13, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 17.55, ["Neon|Fly|Ride"] = 45.93, ["Mega"] = 15.61, ["Mega|Fly"] = 83.15, ["Mega|Ride"] = 32.25, ["Mega|Fly|Ride"] = 72.19}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 56.44, ["Fly|Ride"] = 109.92, ["Neon"] = 57.19, ["Neon|Fly"] = 124.36, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 151.16, ["Mega"] = 212.22, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 424.13}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 259.88, ["Ride"] = 292.69, ["Fly|Ride"] = 495.49, ["Neon"] = 1293.22, ["Neon|Ride"] = 1023.75, ["Neon|Fly|Ride"] = 1039.5, ["Mega"] = 6203.44, ["Mega|Ride"] = 9631.47, ["Mega|Fly|Ride"] = 4517.31}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 76.12, ["Ride"] = 104.99, ["Fly|Ride"] = 261.58, ["Neon"] = 393.75, ["Neon|Fly"] = 938.11, ["Neon|Ride"] = 439.61, ["Neon|Fly|Ride"] = 522.38, ["Mega"] = 1607.7, ["Mega|Ride"] = 1902.49, ["Mega|Fly|Ride"] = 1543.5}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 16.05, ["Ride"] = 22.01, ["Fly|Ride"] = 57, ["Neon"] = 7.76, ["Neon|Fly"] = 103.03, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 62.5, ["Mega"] = 146.87, ["Mega|Fly"] = 218.1, ["Mega|Ride"] = 128.13, ["Mega|Fly|Ride"] = 248.73}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 20.67, ["Ride"] = 16.37, ["Fly|Ride"] = 39.25, ["Neon"] = 8.59, ["Neon|Fly"] = 47.25, ["Neon|Ride"] = 26.23, ["Neon|Fly|Ride"] = 60.06, ["Mega"] = 80.07, ["Mega|Fly"] = 292.62, ["Mega|Ride"] = 116.67, ["Mega|Fly|Ride"] = 153.6}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Fly"] = 103.32, ["Ride"] = 22.31, ["Fly|Ride"] = 98.44, ["Neon"] = 38.45, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 444.35, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 223.13, ["Ride"] = 244.13, ["Fly|Ride"] = 328.77, ["Neon|Ride"] = 1048.69, ["Neon|Fly|Ride"] = 1063.08, ["Mega|Ride"] = 8767.18, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 16.7, ["Fly|Ride"] = 49.54, ["Neon"] = 20.57, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 30.73, ["Neon|Fly|Ride"] = 94.27, ["Mega"] = 262.5, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 292.62}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.6, ["Ride"] = 78.75, ["Fly|Ride"] = 116.43, ["Neon"] = 24.73, ["Neon|Ride"] = 111.8, ["Mega"] = 299.25, ["Mega|Ride"] = 305.16, ["Mega|Fly|Ride"] = 438.37}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.61, ["Ride"] = 131.25, ["Neon"] = 11.71, ["Neon|Ride"] = 137.82, ["Mega"] = 124.69, ["Mega|Ride"] = 336.46}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 12.94, ["Fly"] = 58.13, ["Ride"] = 26.09, ["Fly|Ride"] = 56.44, ["Neon"] = 82.68, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 420, ["Mega|Ride"] = 501.38, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 40.27, ["Ride"] = 65.63, ["Fly|Ride"] = 583.77, ["Neon"] = 116.81, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 168, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 563.39, ["Mega|Fly"] = 2301.41, ["Mega|Ride"] = 538.65, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 30.18, ["Fly"] = 103.32, ["Ride"] = 47.25, ["Fly|Ride"] = 102.92, ["Neon"] = 118.13, ["Neon|Fly"] = 286.43, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 876.72, ["Mega|Ride"] = 700.88, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 13.74, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 32.65, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 48.61, ["Mega"] = 26.32, ["Mega|Fly"] = 41, ["Mega|Ride"] = 39.73, ["Mega|Fly|Ride"] = 90.3}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 218.66, ["Ride"] = 236.25, ["Fly|Ride"] = 420.86, ["Neon"] = 3475.59, ["Neon|Ride"] = 1422.11, ["Neon|Fly|Ride"] = 1388.51, ["Mega|Fly|Ride"] = 5111.28}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 5.25, ["Fly"] = 101.19, ["Ride"] = 28.73, ["Fly|Ride"] = 111.56, ["Neon"] = 79.54, ["Neon|Ride"] = 147.28, ["Neon|Fly|Ride"] = 454.81, ["Mega"] = 413.34, ["Mega|Ride"] = 531.14, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 36.62, ["Ride"] = 19.13, ["Fly|Ride"] = 59.07, ["Neon"] = 7.77, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 29.69, ["Neon|Fly|Ride"] = 109.61, ["Mega"] = 45.94, ["Mega|Fly"] = 234.54, ["Mega|Ride"] = 116.55, ["Mega|Fly|Ride"] = 324.84}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 23.83, ["Fly|Ride"] = 87.66, ["Neon"] = 2.1, ["Neon|Fly"] = 81.99, ["Neon|Ride"] = 22.01, ["Neon|Fly|Ride"] = 111.71, ["Mega"] = 24.12, ["Mega|Fly"] = 144.21, ["Mega|Ride"] = 40.36, ["Mega|Fly|Ride"] = 169.89}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.57, ["Ride"] = 37.59, ["Fly|Ride"] = 147.28, ["Neon"] = 13.27, ["Neon|Fly"] = 744.78, ["Neon|Ride"] = 63.14, ["Mega"] = 155.54, ["Mega|Ride"] = 166.29, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 9.19, ["Fly"] = 47.24, ["Ride"] = 20.97, ["Fly|Ride"] = 69.57, ["Neon"] = 46.67, ["Neon|Fly"] = 263.03, ["Neon|Ride"] = 51.17, ["Neon|Fly|Ride"] = 146.87, ["Mega"] = 288.14, ["Mega|Ride"] = 350.7, ["Mega|Fly|Ride"] = 384.72}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 7.59, ["Ride"] = 32.82, ["Neon"] = 43.07, ["Neon|Ride"] = 151.25, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 275.63, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 301.87}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Neon"] = 2.51, ["Neon|Ride"] = 43.99, ["Neon|Fly|Ride"] = 117.28, ["Mega"] = 20.88, ["Mega|Ride"] = 66.94, ["Mega|Fly|Ride"] = 190.7}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 9.19, ["Fly"] = 83.99, ["Ride"] = 33.39, ["Fly|Ride"] = 175.86, ["Neon"] = 36.75, ["Neon|Ride"] = 96.87, ["Neon|Fly|Ride"] = 144.41, ["Mega"] = 146.87, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 366.03}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 31.49, ["Neon"] = 4.47, ["Neon|Fly"] = 117.6, ["Neon|Ride"] = 29.6, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 29.81, ["Mega|Ride"] = 144.36, ["Mega|Fly|Ride"] = 245.44}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 58.44, ["Ride"] = 19.68, ["Fly|Ride"] = 45.94, ["Neon"] = 3.94, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 146.87, ["Mega"] = 45.94, ["Mega|Ride"] = 91.77, ["Mega|Fly|Ride"] = 284.53}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 630, ["Ride"] = 708.75, ["Fly|Ride"] = 771.75, ["Neon"] = 2625, ["Neon|Ride"] = 3475.28, ["Neon|Fly|Ride"] = 3150, ["Mega|Fly|Ride"] = 9620.63}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 18.34, ["Ride"] = 15.65, ["Fly|Ride"] = 39.38, ["Neon"] = 14.91, ["Neon|Fly"] = 43.98, ["Neon|Ride"] = 26.99, ["Neon|Fly|Ride"] = 65.63, ["Mega|Fly|Ride"] = 331.34}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 57.87, ["Neon"] = 8.54, ["Neon|Fly"] = 767.15, ["Neon|Ride"] = 62.49, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 90.85, ["Mega|Fly"] = 182.84, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 4.2, ["Fly"] = 26.25, ["Ride"] = 20.89, ["Fly|Ride"] = 53.17, ["Neon"] = 39.38, ["Neon|Fly"] = 198.41, ["Neon|Ride"] = 43.86, ["Neon|Fly|Ride"] = 115.5, ["Mega"] = 485.63, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 58.96, ["Ride"] = 15.65, ["Fly|Ride"] = 43.83, ["Neon"] = 6.46, ["Neon|Fly"] = 52.48, ["Neon|Ride"] = 27.28, ["Neon|Fly|Ride"] = 73.44, ["Mega"] = 66.94, ["Mega|Ride"] = 95.51, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 45.93, ["Ride"] = 59.38, ["Neon"] = 236.25, ["Neon|Ride"] = 336.46, ["Mega"] = 1020.3, ["Mega|Ride"] = 797.83, ["Mega|Fly|Ride"] = 862.5}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 73.98, ["Neon"] = 8.4, ["Neon|Fly"] = 141.77, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 129.33, ["Mega"] = 47.25, ["Mega|Fly"] = 126.05, ["Mega|Ride"] = 111.8, ["Mega|Fly|Ride"] = 275.5}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 22.32, ["Fly|Ride"] = 90.96, ["Neon"] = 11.15, ["Neon|Ride"] = 51.19, ["Mega"] = 114.19, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 325.5}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Ride"] = 43.98, ["Fly|Ride"] = 65.84, ["Neon"] = 12.41, ["Neon|Fly|Ride"] = 109.61, ["Mega"] = 103.69, ["Mega|Ride"] = 164.4, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 2593.5, ["Ride"] = 19.68, ["Fly|Ride"] = 69.56, ["Neon"] = 4.2, ["Neon|Fly"] = 72.39, ["Neon|Ride"] = 22.24, ["Neon|Fly|Ride"] = 107.63, ["Mega"] = 40.87, ["Mega|Fly"] = 229.69, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 162.22}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 13.01, ["Fly"] = 21.4, ["Ride"] = 18.38, ["Fly|Ride"] = 51.18, ["Neon"] = 124.36, ["Neon|Fly"] = 123.31, ["Neon|Ride"] = 113.9, ["Neon|Fly|Ride"] = 144.66, ["Mega|Ride"] = 876.72, ["Mega|Fly|Ride"] = 488.95}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 706.43, ["Ride"] = 800.63, ["Fly|Ride"] = 905.63, ["Neon"] = 1585.49, ["Neon|Ride"] = 1569.61, ["Neon|Fly|Ride"] = 1837.5, ["Mega"] = 8633.84, ["Mega|Ride"] = 5698.67, ["Mega|Fly|Ride"] = 4462.5}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 23.62, ["Ride"] = 16.22, ["Fly|Ride"] = 47.54, ["Neon"] = 2.6, ["Neon|Fly"] = 37.38, ["Neon|Ride"] = 27.33, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 39.38, ["Mega|Ride"] = 78.66, ["Mega|Fly|Ride"] = 325.5}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 3.4, ["Ride"] = 36.74, ["Fly|Ride"] = 58.35, ["Neon"] = 41.79, ["Neon|Ride"] = 205.01, ["Neon|Fly|Ride"] = 250.69, ["Mega"] = 432.98, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 542.38}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 52.5, ["Fly"] = 156.19, ["Ride"] = 76.13, ["Fly|Ride"] = 110.25, ["Neon"] = 315, ["Neon|Ride"] = 313.69, ["Neon|Fly|Ride"] = 367.49, ["Mega"] = 2475.65, ["Mega|Fly|Ride"] = 1841.12}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 28.59, ["Fly"] = 146.87, ["Ride"] = 58.23, ["Fly|Ride"] = 104.43, ["Neon"] = 210.05, ["Neon|Ride"] = 129.22, ["Mega"] = 1489.14, ["Mega|Ride"] = 963.31, ["Mega|Fly|Ride"] = 789.12}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 12.69, ["Ride"] = 25.23, ["Fly|Ride"] = 105, ["Neon"] = 65.51, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 308.44, ["Mega|Ride"] = 371.44, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 21.76, ["Ride"] = 72.16, ["Fly|Ride"] = 162.68, ["Neon"] = 114.41, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 390.48, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 397.69}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 23.63, ["Ride"] = 164.8, ["Neon"] = 183.75, ["Neon|Ride"] = 194.91, ["Neon|Fly|Ride"] = 380.28, ["Mega"] = 542.48, ["Mega|Ride"] = 476.44, ["Mega|Fly|Ride"] = 629.06}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 13.02}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 4.2, ["Ride"] = 21.53, ["Fly|Ride"] = 101.14, ["Neon"] = 26.15, ["Neon|Ride"] = 67.96, ["Neon|Fly|Ride"] = 213.98, ["Mega"] = 178.5, ["Mega|Fly"] = 462.9, ["Mega|Ride"] = 182.25, ["Mega|Fly|Ride"] = 308.05}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.39, ["Neon"] = 20.99, ["Mega"] = 139.32, ["Mega|Fly|Ride"] = 385.88}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 24.85, ["Fly"] = 63, ["Ride"] = 42.18, ["Fly|Ride"] = 85.32, ["Neon"] = 198.97, ["Neon|Fly"] = 292.62, ["Neon|Ride"] = 190.15, ["Neon|Fly|Ride"] = 263.03, ["Mega"] = 1278.54, ["Mega|Ride"] = 783.53, ["Mega|Fly|Ride"] = 719.92}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 2.1, ["Fly"] = 19.45, ["Ride"] = 15.75, ["Fly|Ride"] = 36.7, ["Neon"] = 21.94, ["Neon|Fly"] = 42.94, ["Neon|Ride"] = 37.7, ["Neon|Fly|Ride"] = 78.05, ["Mega"] = 262.5, ["Mega|Fly"] = 438.37, ["Mega|Ride"] = 183.74, ["Mega|Fly|Ride"] = 209.9}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 4.83, ["Fly"] = 107.29, ["Ride"] = 26.17, ["Fly|Ride"] = 63.74, ["Neon"] = 28.87, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 295.35, ["Mega|Ride"] = 188.97, ["Mega|Fly|Ride"] = 254.63}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Mega"] = 45.94, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 30.09, ["Ride"] = 44.62, ["Fly|Ride"] = 166.64, ["Neon"] = 221.97, ["Neon|Ride"] = 302.87, ["Neon|Fly|Ride"] = 362.76, ["Mega|Ride"] = 1753.44, ["Mega|Fly|Ride"] = 798}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 36.18, ["Fly|Ride"] = 58.15, ["Neon"] = 10.8, ["Neon|Fly"] = 203.44, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 105, ["Mega"] = 78.75, ["Mega|Ride"] = 74.49, ["Mega|Fly|Ride"] = 196.86}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 6.57, ["Ride"] = 65.63, ["Fly|Ride"] = 210, ["Neon"] = 73.44, ["Neon|Ride"] = 115.82, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 406.88, ["Mega|Fly"] = 585.22, ["Mega|Ride"] = 424.13, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.93, ["Ride"] = 15.99, ["Neon"] = 14.32, ["Neon|Ride"] = 16.46, ["Neon|Fly|Ride"] = 100.36, ["Mega"] = 194.25, ["Mega|Ride"] = 156.85, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 3.7, ["Fly"] = 52.49, ["Ride"] = 21.87, ["Fly|Ride"] = 53.5, ["Neon"] = 90.57, ["Neon|Fly"] = 72.55, ["Neon|Ride"] = 67.03, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 278.37, ["Mega|Ride"] = 438.37, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 9.16, ["Ride"] = 72.19, ["Neon"] = 83.32, ["Neon|Ride"] = 131.25, ["Mega"] = 422.29, ["Mega|Ride"] = 376.95, ["Mega|Fly|Ride"] = 645.74}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 55.13, ["Ride"] = 224.21, ["Neon"] = 328.13, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 931.53, ["Mega"] = 1048.69, ["Mega|Fly|Ride"] = 1286.25}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 15.65, ["Ride"] = 78.74, ["Fly|Ride"] = 161.28, ["Neon"] = 107.63, ["Mega"] = 421.32, ["Mega|Ride"] = 418.69, ["Mega|Fly|Ride"] = 689.73}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 3.94, ["Ride"] = 115.26, ["Neon"] = 149.62, ["Neon|Fly"] = 219.19, ["Neon|Ride"] = 170.63, ["Mega|Ride"] = 459.38}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 25.91, ["Ride"] = 130.79, ["Fly|Ride"] = 367.49, ["Neon"] = 162.65, ["Neon|Fly"] = 267.41, ["Neon|Ride"] = 219.19, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 730.98, ["Mega|Fly"] = 2191.82, ["Mega|Ride"] = 656.45, ["Mega|Fly|Ride"] = 851.44}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.93, ["Neon"] = 24.75, ["Mega"] = 196.88, ["Mega|Ride"] = 258.17, ["Mega|Fly|Ride"] = 331.41}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 17.52, ["Fly|Ride"] = 63, ["Neon"] = 3.84, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 43.54, ["Neon|Fly|Ride"] = 56.99, ["Mega"] = 62.06, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 32.89, ["Fly|Ride"] = 84, ["Neon"] = 14.34, ["Neon|Ride"] = 36.69, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 91.88, ["Mega|Ride"] = 103.98, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 147.28, ["Ride"] = 25.6, ["Fly|Ride"] = 72.01, ["Neon"] = 5.16, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 101.18, ["Mega"] = 55.13, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.62, ["Fly"] = 65.62, ["Ride"] = 24.05, ["Fly|Ride"] = 82.45, ["Neon"] = 23.47, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 219.19, ["Mega"] = 328.13, ["Mega|Ride"] = 336, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 2.61, ["Fly"] = 65.24, ["Ride"] = 26.25, ["Fly|Ride"] = 439.61, ["Neon"] = 30.19, ["Neon|Fly"] = 315, ["Neon|Ride"] = 63.37, ["Mega"] = 311.26, ["Mega|Ride"] = 287.47, ["Mega|Fly|Ride"] = 1095.91}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.94, ["Fly"] = 131.24, ["Ride"] = 24.67, ["Fly|Ride"] = 64.86, ["Neon"] = 36.19, ["Neon|Fly"] = 135.69, ["Neon|Ride"] = 49.29, ["Neon|Fly|Ride"] = 114.85, ["Mega"] = 216.46, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 492.08}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.49, ["Ride"] = 21.58, ["Fly|Ride"] = 52.41, ["Neon"] = 29.38, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 153.45, ["Mega"] = 274.98, ["Mega|Ride"] = 315.67, ["Mega|Fly|Ride"] = 191.89}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 3.94, ["Fly"] = 144.31, ["Ride"] = 47.22, ["Neon"] = 14.6, ["Neon|Fly"] = 50.43, ["Neon|Ride"] = 89.25, ["Mega"] = 124.69, ["Mega|Fly"] = 216.8, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 278.25}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 17.61, ["Ride"] = 82.68, ["Fly|Ride"] = 236.25, ["Neon"] = 89.25, ["Neon|Ride"] = 186.2, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 362.76, ["Mega|Ride"] = 791.2, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 39.38, ["Fly"] = 164.07, ["Ride"] = 66.99, ["Fly|Ride"] = 179.16, ["Neon"] = 240.91, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 314.97, ["Mega"] = 1606.6, ["Mega|Ride"] = 1048.69, ["Mega|Fly|Ride"] = 997.5}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Ride"] = 23.69, ["Fly|Ride"] = 52.77, ["Neon"] = 3.64, ["Neon|Ride"] = 21.94, ["Neon|Fly|Ride"] = 146.87, ["Mega"] = 33.49, ["Mega|Ride"] = 72.34, ["Mega|Fly|Ride"] = 123.38}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 10.24, ["Ride"] = 105, ["Neon"] = 105.94, ["Mega"] = 716.73, ["Mega|Fly|Ride"] = 1151.81}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 62.78, ["Ride"] = 65.54, ["Neon"] = 249.38, ["Neon|Ride"] = 295.32, ["Neon|Fly|Ride"] = 418.99, ["Mega"] = 1806.07, ["Mega|Ride"] = 1315.09, ["Mega|Fly|Ride"] = 3287.7}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 7.33, ["Fly"] = 190.32, ["Ride"] = 19.74, ["Fly|Ride"] = 133.88, ["Neon"] = 39.35, ["Neon|Fly"] = 132.83, ["Neon|Ride"] = 104.9, ["Neon|Fly|Ride"] = 162.22, ["Mega"] = 270.17, ["Mega|Fly"] = 749.75, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 285.86}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.52, ["Ride"] = 59.19, ["Neon"] = 7.87, ["Neon|Fly|Ride"] = 210, ["Mega"] = 98.65, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 286.02}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 29.69, ["Ride"] = 19.27, ["Fly|Ride"] = 57.75, ["Neon"] = 11.71, ["Neon|Fly"] = 59.07, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 97.44, ["Mega"] = 115.5, ["Mega|Fly"] = 196.87, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 227.96}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 21.45, ["Ride"] = 14.44, ["Fly|Ride"] = 52.49, ["Neon"] = 2.1, ["Neon|Fly"] = 131.9, ["Neon|Ride"] = 23, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 28.88, ["Mega|Ride"] = 74.49, ["Mega|Fly|Ride"] = 142.79}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 20.91, ["Fly|Ride"] = 93.09, ["Neon"] = 5.25, ["Neon|Ride"] = 24.49, ["Neon|Fly|Ride"] = 97.44, ["Mega"] = 41.91, ["Mega|Fly"] = 168, ["Mega|Ride"] = 43.86, ["Mega|Fly|Ride"] = 163.96}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Neon"] = 2.6, ["Neon|Ride"] = 29.69, ["Mega"] = 24.94, ["Mega|Fly|Ride"] = 444.94}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 5.09, ["Ride"] = 40.95, ["Neon"] = 53.33, ["Neon|Ride"] = 82.6, ["Neon|Fly|Ride"] = 141.65, ["Mega"] = 292.62, ["Mega|Ride"] = 198.57, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 6.57, ["Ride"] = 30.19, ["Fly|Ride"] = 219.81, ["Neon"] = 67.89, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 140.07, ["Mega"] = 286.79, ["Mega|Ride"] = 275.62, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 4.54, ["Fly"] = 26.25, ["Ride"] = 19.52, ["Fly|Ride"] = 41.99, ["Neon"] = 52.79, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 101.05, ["Mega|Ride"] = 311.37, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 99.49, ["Ride"] = 98.44, ["Fly|Ride"] = 124.69, ["Neon"] = 393.75, ["Neon|Ride"] = 547.96, ["Mega"] = 2481.88, ["Mega|Ride"] = 1657.01, ["Mega|Fly|Ride"] = 1544.82}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 20.89, ["Fly"] = 57.75, ["Ride"] = 28.88, ["Neon"] = 83.32, ["Neon|Fly|Ride"] = 630, ["Mega"] = 464.63, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 1090.05}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 18.75, ["Fly|Ride"] = 41.66, ["Neon"] = 2.62, ["Neon|Fly"] = 43.86, ["Neon|Ride"] = 23.51, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 32.27, ["Mega|Ride"] = 93.45, ["Mega|Fly|Ride"] = 165.38}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 19.61, ["Ride"] = 16.35, ["Fly|Ride"] = 36.61, ["Neon"] = 4.28, ["Neon|Fly"] = 27.57, ["Neon|Ride"] = 21.94, ["Neon|Fly|Ride"] = 45.85, ["Mega"] = 48.97, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 468.57, ["Fly"] = 571.5, ["Ride"] = 479.07, ["Fly|Ride"] = 524.99, ["Neon"] = 2491.46, ["Neon|Fly|Ride"] = 2098.69, ["Mega|Fly|Ride"] = 9101}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 3.83, ["Ride"] = 89.87, ["Neon"] = 24.2, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 424.13, ["Mega|Ride"] = 368.24, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 15.75, ["Fly|Ride"] = 38.56, ["Neon"] = 2.1, ["Neon|Fly"] = 24.94, ["Neon|Ride"] = 18.32, ["Neon|Fly|Ride"] = 56.42, ["Mega"] = 42, ["Mega|Ride"] = 42, ["Mega|Fly|Ride"] = 113.98}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 38.75, ["Ride"] = 108.25, ["Fly|Ride"] = 212.63, ["Neon"] = 192.94, ["Neon|Ride"] = 282.19, ["Neon|Fly|Ride"] = 574.26, ["Mega"] = 796.11, ["Mega|Ride"] = 761.25, ["Mega|Fly|Ride"] = 852.86}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 44.41, ["Ride"] = 21.94, ["Fly|Ride"] = 61.38, ["Neon"] = 14.33, ["Neon|Fly"] = 101.37, ["Neon|Ride"] = 32.11, ["Neon|Fly|Ride"] = 90.54, ["Mega"] = 127.32, ["Mega|Ride"] = 127.3, ["Mega|Fly|Ride"] = 227.37}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Ride"] = 24.84, ["Fly|Ride"] = 196.88, ["Neon"] = 2.1, ["Neon|Fly"] = 101.78, ["Neon|Ride"] = 144.23, ["Neon|Fly|Ride"] = 146.87, ["Mega"] = 23.38, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 39.36, ["Fly"] = 129.94, ["Ride"] = 78.74, ["Fly|Ride"] = 215.25, ["Neon"] = 150.94, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 796.73, ["Mega|Ride"] = 653.59, ["Mega|Fly|Ride"] = 589.32}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Fly|Ride"] = 146.99, ["Neon"] = 6.56, ["Neon|Ride"] = 23.64, ["Neon|Fly|Ride"] = 350.7, ["Mega"] = 63.57, ["Mega|Ride"] = 86.63, ["Mega|Fly|Ride"] = 248.78}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 38.75, ["Ride"] = 72.41, ["Fly|Ride"] = 124.69, ["Neon"] = 283.23, ["Neon|Fly"] = 293.45, ["Neon|Ride"] = 216.38, ["Neon|Fly|Ride"] = 327.69, ["Mega"] = 1181.25, ["Mega|Ride"] = 1315.09, ["Mega|Fly|Ride"] = 1334.93}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 2.58, ["Ride"] = 37.32, ["Fly|Ride"] = 439.61, ["Neon"] = 32.12, ["Neon|Ride"] = 231, ["Neon|Fly|Ride"] = 502.63, ["Mega"] = 148.32, ["Mega|Ride"] = 164.04}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 33.59, ["Ride"] = 81.35, ["Fly|Ride"] = 58.48, ["Neon"] = 10.5, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 117.6, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 205.73}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 57.64, ["Fly"] = 191.24, ["Ride"] = 182.45, ["Fly|Ride"] = 195.57, ["Neon"] = 359.63, ["Mega|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 2047.15}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 593.43, ["Ride"] = 35.18, ["Neon"] = 6.48, ["Neon|Ride"] = 42.31, ["Neon|Fly|Ride"] = 124.95, ["Mega"] = 43.32, ["Mega|Fly"] = 219.19, ["Mega|Ride"] = 90.8, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 28.49, ["Ride"] = 25.22, ["Fly|Ride"] = 43.98, ["Neon"] = 7.88, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 86.89, ["Mega"] = 59.19, ["Mega|Fly"] = 152.67, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 223.38}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 6.57, ["Fly"] = 28.88, ["Ride"] = 19.69, ["Fly|Ride"] = 198.61, ["Neon"] = 83.99, ["Neon|Fly"] = 133.06, ["Neon|Ride"] = 82.32, ["Neon|Fly|Ride"] = 168.92, ["Mega"] = 328.13, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 409.21}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 7.27, ["Fly"] = 43.98, ["Ride"] = 19.69, ["Fly|Ride"] = 65.62, ["Neon"] = 53.24, ["Neon|Ride"] = 89.55, ["Neon|Fly|Ride"] = 111.54, ["Mega"] = 354.38, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 442.79}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 17.74, ["Fly"] = 28.88, ["Ride"] = 24.94, ["Fly|Ride"] = 51.66, ["Neon"] = 81.38, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 175.37, ["Mega"] = 409.88, ["Mega|Ride"] = 331.34, ["Mega|Fly|Ride"] = 341.67}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 72.08, ["Ride"] = 116.82, ["Fly|Ride"] = 262.49, ["Neon"] = 315, ["Neon|Ride"] = 321.57, ["Neon|Fly|Ride"] = 498.75, ["Mega"] = 1115.63, ["Mega|Ride"] = 1115.63, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 7.88, ["Ride"] = 117.5, ["Fly|Ride"] = 423.94, ["Neon"] = 62.91, ["Neon|Ride"] = 141.49, ["Neon|Fly|Ride"] = 352.93, ["Mega"] = 301.88, ["Mega|Ride"] = 462, ["Mega|Fly|Ride"] = 1172.64}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 4.61, ["Ride"] = 25.57, ["Fly|Ride"] = 78.74, ["Neon"] = 22.32, ["Neon|Ride"] = 47.25, ["Mega"] = 120.15, ["Mega|Ride"] = 219.19, ["Mega|Fly|Ride"] = 271.81}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 10.5, ["Fly"] = 135.19, ["Ride"] = 41.63, ["Fly|Ride"] = 65.63, ["Neon"] = 70.88, ["Neon|Fly"] = 105, ["Neon|Ride"] = 43.98, ["Neon|Fly|Ride"] = 175.37, ["Mega"] = 317.63, ["Mega|Ride"] = 341.13, ["Mega|Fly|Ride"] = 497.44}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.44, ["Ride"] = 14.01, ["Fly|Ride"] = 45.94, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 15.17, ["Neon|Fly|Ride"] = 43.19, ["Mega"] = 15.65, ["Mega|Fly"] = 42, ["Mega|Ride"] = 28.84, ["Mega|Fly|Ride"] = 115.49}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 54.07, ["Fly"] = 164.07, ["Ride"] = 111.57, ["Neon"] = 233.89, ["Neon|Fly"] = 2484.42, ["Neon|Ride"] = 294, ["Mega"] = 1095.91, ["Mega|Ride"] = 813.75, ["Mega|Fly|Ride"] = 892.49}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 25.3, ["Fly|Ride"] = 144.09, ["Neon"] = 3.1, ["Neon|Fly"] = 131.25, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 33.45, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 18.38, ["Fly|Ride"] = 45.93, ["Neon"] = 19.69, ["Neon|Ride"] = 26.94, ["Neon|Fly|Ride"] = 90.02, ["Mega"] = 262.5, ["Mega|Ride"] = 202.6}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 55.12, ["Ride"] = 91.88, ["Fly|Ride"] = 129.94, ["Neon"] = 236.24, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 918.75, ["Mega|Ride"] = 800.63, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 57.21, ["Neon"] = 6.17, ["Neon|Ride"] = 34.59, ["Mega"] = 54.89, ["Mega|Ride"] = 146.87, ["Mega|Fly|Ride"] = 446.22}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 6.12}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 116.58, ["Fly|Ride"] = 147.28, ["Neon"] = 6.04, ["Neon|Ride"] = 93.33, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 84, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 273.99}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 137.8, ["Ride"] = 210, ["Fly|Ride"] = 210.95, ["Neon"] = 648.41, ["Neon|Ride"] = 629.99, ["Neon|Fly|Ride"] = 678.57, ["Mega"] = 6575.39, ["Mega|Ride"] = 3310.2, ["Mega|Fly|Ride"] = 2506.41}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2.63, ["Ride"] = 142.78, ["Fly|Ride"] = 219.19, ["Neon"] = 33.5, ["Neon|Fly"] = 147.28, ["Neon|Ride"] = 103.68, ["Neon|Fly|Ride"] = 219.43, ["Mega"] = 178.5, ["Mega|Ride"] = 229.04, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 26.24, ["Neon"] = 3.52, ["Neon|Ride"] = 22.23, ["Mega"] = 45.91, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 48.57, ["Mega|Fly|Ride"] = 428.52}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 4.61, ["Ride"] = 36.74, ["Fly|Ride"] = 103.32, ["Neon"] = 60.27, ["Neon|Ride"] = 108.5, ["Neon|Fly|Ride"] = 162.22, ["Mega"] = 322.72, ["Mega|Ride"] = 579.12, ["Mega|Fly|Ride"] = 697.01}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 8.82, ["Fly"] = 60.92, ["Ride"] = 20.19, ["Fly|Ride"] = 63.75, ["Neon"] = 101.04, ["Neon|Ride"] = 131.52, ["Neon|Fly|Ride"] = 219.19, ["Mega"] = 640.5, ["Mega|Ride"] = 396.74, ["Mega|Fly|Ride"] = 492.19}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 24.9, ["Ride"] = 60.38, ["Fly|Ride"] = 205.57, ["Neon"] = 131.25, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 350.7, ["Mega"] = 552.57, ["Mega|Ride"] = 604.36, ["Mega|Fly|Ride"] = 565.79}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 154.74, ["Fly"] = 168, ["Ride"] = 190.32, ["Fly|Ride"] = 236.25, ["Neon"] = 645.75, ["Neon|Ride"] = 452.82, ["Neon|Fly|Ride"] = 649.69, ["Mega|Fly|Ride"] = 2484.42}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 4.19, ["Fly"] = 19.74, ["Ride"] = 16.95, ["Fly|Ride"] = 41.06, ["Neon"] = 49.71, ["Neon|Fly"] = 162.91, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 81.33, ["Mega|Ride"] = 265.57, ["Mega|Fly|Ride"] = 424.13}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.47, ["Fly"] = 73.64, ["Ride"] = 46.51, ["Fly|Ride"] = 131.25, ["Neon"] = 18.38, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 116.67, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 292.62}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 2.1, ["Fly"] = 43.19, ["Ride"] = 41.14, ["Fly|Ride"] = 90.57, ["Neon"] = 39.38, ["Neon|Fly"] = 73.64, ["Neon|Ride"] = 51.97, ["Neon|Fly|Ride"] = 151.25, ["Mega"] = 469.06, ["Mega|Ride"] = 407.54, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 48.86, ["Fly"] = 82.62, ["Ride"] = 70.88, ["Fly|Ride"] = 98.44, ["Neon"] = 192.05, ["Neon|Ride"] = 242.29, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 1148.52, ["Mega|Ride"] = 786.19, ["Mega|Fly|Ride"] = 964.69}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 13.02, ["Ride"] = 265.97, ["Neon"] = 166.19, ["Neon|Ride"] = 232.12, ["Mega"] = 743.33, ["Mega|Ride"] = 727.69}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 236.12, ["Ride"] = 350.44, ["Neon"] = 1312.5, ["Neon|Ride"] = 1655.42, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 3936.19}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 24.91, ["Ride"] = 27.19, ["Fly|Ride"] = 69.47, ["Neon"] = 254.99, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 347.82, ["Mega"] = 761.25, ["Mega|Ride"] = 761.25, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 41.14, ["Ride"] = 14.33, ["Fly|Ride"] = 127.14, ["Neon"] = 2.1, ["Neon|Ride"] = 16.93, ["Neon|Fly|Ride"] = 59.06, ["Mega"] = 21, ["Mega|Fly"] = 116.19, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 119.33}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Ride"] = 41.92, ["Neon"] = 19.59, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 166.29, ["Mega"] = 196.88, ["Mega|Ride"] = 166.29, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 2.1, ["Ride"] = 32.7, ["Fly|Ride"] = 59.36, ["Neon"] = 18.42, ["Neon|Ride"] = 65.96, ["Neon|Fly|Ride"] = 1181.24, ["Mega"] = 173.16, ["Mega|Fly"] = 575.01, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 341.92}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 387.09, ["Fly"] = 393.75, ["Ride"] = 419.99, ["Fly|Ride"] = 508.64, ["Neon"] = 1888.69, ["Neon|Ride"] = 2047.15, ["Neon|Fly|Ride"] = 1914.94, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 16.87, ["Fly|Ride"] = 48.55, ["Neon"] = 26.83, ["Neon|Ride"] = 37.27, ["Neon|Fly|Ride"] = 117.24, ["Mega"] = 246.65, ["Mega|Ride"] = 154.63, ["Mega|Fly|Ride"] = 233.63}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 3.61, ["Fly"] = 28, ["Ride"] = 16.7, ["Fly|Ride"] = 44.63, ["Neon"] = 50.7, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 64.86, ["Neon|Fly|Ride"] = 139.13, ["Mega"] = 374.81, ["Mega|Ride"] = 292.62, ["Mega|Fly|Ride"] = 328.02}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.41, ["Fly"] = 42, ["Ride"] = 28.6, ["Fly|Ride"] = 67.79, ["Neon"] = 18.08, ["Neon|Fly"] = 94.48, ["Neon|Ride"] = 44.62, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 94.5, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 25.47, ["Fly"] = 94.5, ["Ride"] = 34.13, ["Fly|Ride"] = 88.3, ["Neon"] = 220.5, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 327.69, ["Mega"] = 1315.09, ["Mega|Ride"] = 862.32, ["Mega|Fly|Ride"] = 786.86}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 52.5, ["Fly|Ride"] = 51.85, ["Neon"] = 12.98, ["Neon|Ride"] = 83.32, ["Neon|Fly|Ride"] = 210, ["Mega"] = 167.08, ["Mega|Ride"] = 205.23, ["Mega|Fly|Ride"] = 748.79}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 16.96, ["Fly"] = 92.92, ["Ride"] = 58.33, ["Neon"] = 131.23, ["Neon|Fly|Ride"] = 259.23, ["Mega|Ride"] = 918.75}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 33.53, ["Neon"] = 7.86, ["Neon|Ride"] = 20.84, ["Neon|Fly|Ride"] = 43.32, ["Mega"] = 74.65, ["Mega|Fly"] = 86304.75, ["Mega|Ride"] = 144.37, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 8.82, ["Neon"] = 62.25, ["Mega"] = 137.4, ["Mega|Ride"] = 320.02, ["Mega|Fly|Ride"] = 801.29}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 11.66, ["Ride"] = 73.64, ["Fly|Ride"] = 94.53, ["Neon"] = 46.06, ["Neon|Ride"] = 292.62, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 318.15, ["Mega|Ride"] = 496.49, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 4.11, ["Fly"] = 29.69, ["Ride"] = 27.57, ["Fly|Ride"] = 57.75, ["Neon"] = 56.19, ["Neon|Fly"] = 116.89, ["Neon|Ride"] = 51.52, ["Neon|Fly|Ride"] = 108.72, ["Mega"] = 546.87, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 433.12, ["Fly"] = 619.36, ["Ride"] = 446.69, ["Fly|Ride"] = 536.82, ["Neon"] = 1659.66, ["Neon|Fly"] = 2072.89, ["Neon|Ride"] = 3570, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 7555.12}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 17.83, ["Fly|Ride"] = 36.75, ["Neon"] = 15.75, ["Neon|Fly"] = 83.19, ["Neon|Ride"] = 32.29, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 271.81, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 311.49}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 10.39, ["Fly"] = 85.99, ["Ride"] = 79.61, ["Fly|Ride"] = 293.45, ["Neon"] = 87.68, ["Neon|Ride"] = 186.33, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 433.13, ["Mega|Fly"] = 730.98, ["Mega|Ride"] = 568.2, ["Mega|Fly|Ride"] = 393.74}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 13.55, ["Ride"] = 89.25, ["Fly|Ride"] = 228.51, ["Neon"] = 94.27, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 366.09, ["Mega"] = 262.5, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 458.67}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 53.74, ["Fly"] = 169.2, ["Ride"] = 97.13, ["Fly|Ride"] = 132.44, ["Neon"] = 439.19, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 2648.9, ["Mega|Fly|Ride"] = 2481.88}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 10.27, ["Ride"] = 58.47, ["Fly|Ride"] = 293.45, ["Neon"] = 44.6, ["Neon|Ride"] = 98.43, ["Neon|Fly|Ride"] = 198.19, ["Mega"] = 204.7, ["Mega|Fly"] = 366.16, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 371.32}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 19.69, ["Fly|Ride"] = 59.07, ["Neon"] = 18.34, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 124.95, ["Mega"] = 103.69, ["Mega|Ride"] = 146.24, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 6.04, ["Ride"] = 59.19, ["Neon"] = 23.63, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 176.54, ["Mega"] = 202.13, ["Mega|Fly"] = 393.44, ["Mega|Ride"] = 265.13, ["Mega|Fly|Ride"] = 251.99}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 49.62, ["Fly"] = 183.75, ["Ride"] = 81.96, ["Fly|Ride"] = 198.08, ["Neon"] = 127.32, ["Neon|Ride"] = 207.71, ["Neon|Fly|Ride"] = 271.03, ["Mega"] = 421.32, ["Mega|Ride"] = 445.31, ["Mega|Fly|Ride"] = 482}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 85.28, ["Neon"] = 8.81, ["Neon|Ride"] = 95.36, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 70.88, ["Mega|Ride"] = 131.25}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 15.75, ["Ride"] = 195.57, ["Neon"] = 173.25, ["Neon|Ride"] = 395.66, ["Mega"] = 730.98, ["Mega|Fly|Ride"] = 657.56}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 956.82, ["Fly"] = 1194.38, ["Ride"] = 1040.58, ["Fly|Ride"] = 1044.75, ["Neon"] = 4383.61, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2884.88, ["Mega"] = 10082.27, ["Mega|Fly|Ride"] = 7875}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 13.12, ["Fly"] = 144.3, ["Ride"] = 68.23, ["Fly|Ride"] = 191.56, ["Neon"] = 91.88, ["Neon|Fly"] = 716.63, ["Neon|Ride"] = 191.24, ["Neon|Fly|Ride"] = 146.87, ["Mega"] = 466.74, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 51.41, ["Ride"] = 27.65, ["Fly|Ride"] = 87.94, ["Neon"] = 9.19, ["Neon|Fly"] = 73.64, ["Neon|Ride"] = 35.05, ["Neon|Fly|Ride"] = 92.23, ["Mega"] = 80.73, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 8.87, ["Ride"] = 131.25, ["Fly|Ride"] = 147.28, ["Neon"] = 74.82, ["Neon|Ride"] = 117.28, ["Neon|Fly|Ride"] = 393.73, ["Mega"] = 288.74, ["Mega|Ride"] = 430.71, ["Mega|Fly|Ride"] = 496.49}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Fly|Ride"] = 190.7, ["Neon"] = 2.1, ["Neon|Ride"] = 27.55, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 17.8, ["Mega|Ride"] = 71.91, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 52.47, ["Fly"] = 145.06, ["Ride"] = 120.75, ["Fly|Ride"] = 275.93, ["Neon"] = 223.13, ["Neon|Fly"] = 354.38, ["Neon|Ride"] = 258.58, ["Neon|Fly|Ride"] = 307.77, ["Mega"] = 1023.75, ["Mega|Ride"] = 1027.69, ["Mega|Fly|Ride"] = 945}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 20.35, ["Ride"] = 62.91, ["Fly|Ride"] = 293.45, ["Neon"] = 169.32, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 576.19, ["Mega|Ride"] = 1021.38, ["Mega|Fly|Ride"] = 1169.35}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Fly|Ride"] = 52.5, ["Neon"] = 9.08, ["Neon|Ride"] = 44.47, ["Neon|Fly|Ride"] = 219.19, ["Mega"] = 99.31, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 374.07}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 13.02, ["Fly"] = 162.68, ["Ride"] = 38.06, ["Fly|Ride"] = 78.75, ["Neon"] = 89.39, ["Neon|Fly"] = 107.18, ["Neon|Ride"] = 101.75, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 393.75, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 830.72}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 3.93, ["Ride"] = 34.13, ["Fly|Ride"] = 64.32, ["Neon"] = 27.13, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 51.52, ["Neon|Fly|Ride"] = 158.87, ["Mega"] = 262.5, ["Mega|Ride"] = 547.96, ["Mega|Fly|Ride"] = 394.53}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 41.49, ["Ride"] = 65.63, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 669.38, ["Mega"] = 2557.85, ["Mega|Ride"] = 1863.05, ["Mega|Fly|Ride"] = 1820.46}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 3.83, ["Ride"] = 43.98, ["Fly|Ride"] = 551.72, ["Neon"] = 17.07, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 662.87, ["Mega"] = 66.89, ["Mega|Ride"] = 113.97, ["Mega|Fly|Ride"] = 256.76}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 4.9, ["Fly"] = 37.38, ["Ride"] = 22.32, ["Fly|Ride"] = 52.49, ["Neon"] = 47.97, ["Neon|Fly"] = 190.7, ["Neon|Ride"] = 70.87, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 337.32, ["Mega|Ride"] = 287.34, ["Mega|Fly|Ride"] = 354.27}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 124.68, ["Fly"] = 164.07, ["Ride"] = 174.53, ["Fly|Ride"] = 198.8, ["Neon"] = 499.96, ["Neon|Ride"] = 547.32, ["Neon|Fly|Ride"] = 590.63, ["Mega"] = 2978.25, ["Mega|Ride"] = 2874.56, ["Mega|Fly|Ride"] = 2003.64}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 29.06, ["Ride"] = 19.27, ["Fly|Ride"] = 48.37, ["Neon"] = 11.71, ["Neon|Fly"] = 57.66, ["Neon|Ride"] = 24.43, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 118.13, ["Mega|Ride"] = 161.53, ["Mega|Fly|Ride"] = 188.99}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 28.87, ["Fly"] = 267.04, ["Ride"] = 91.88, ["Fly|Ride"] = 146.87, ["Neon"] = 192.94, ["Neon|Ride"] = 227.06, ["Neon|Fly|Ride"] = 437.28, ["Mega"] = 745.99, ["Mega|Ride"] = 859.2, ["Mega|Fly|Ride"] = 710.25}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.89, ["Ride"] = 15.75, ["Fly|Ride"] = 64.3, ["Neon"] = 2.1, ["Neon|Fly"] = 30.58, ["Neon|Ride"] = 17, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 16.05, ["Mega|Ride"] = 28.88, ["Mega|Fly|Ride"] = 73.44}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Neon"] = 4.96, ["Neon|Fly|Ride"] = 135.91, ["Mega"] = 19.69, ["Mega|Fly"] = 131.24, ["Mega|Ride"] = 65.54, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.63, ["Fly"] = 37.27, ["Ride"] = 31.23, ["Fly|Ride"] = 292.62, ["Neon"] = 24.9, ["Neon|Ride"] = 59.19, ["Neon|Fly|Ride"] = 141.37, ["Mega"] = 105, ["Mega|Ride"] = 287.56, ["Mega|Fly|Ride"] = 248.07}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 39.46, ["Neon"] = 132.69, ["Neon|Ride"] = 166.35, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 531.03, ["Mega|Ride"] = 691.52, ["Mega|Fly|Ride"] = 876.72}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 19.17, ["Ride"] = 16.66, ["Fly|Ride"] = 35.43, ["Neon"] = 13, ["Neon|Fly"] = 28.67, ["Neon|Ride"] = 25.9, ["Neon|Fly|Ride"] = 58.46, ["Mega"] = 104.99, ["Mega|Fly"] = 267.23, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 165.17}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 7.66, ["Fly"] = 76.41, ["Ride"] = 65.63, ["Fly|Ride"] = 130.1, ["Neon"] = 64.32, ["Neon|Fly"] = 57.75, ["Neon|Ride"] = 65.36, ["Neon|Fly|Ride"] = 132.8, ["Mega"] = 419.37, ["Mega|Fly"] = 446.75, ["Mega|Ride"] = 299.24, ["Mega|Fly|Ride"] = 399.34}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 27.33, ["Ride"] = 18.26, ["Fly|Ride"] = 70.01, ["Neon"] = 8.79, ["Neon|Fly"] = 98.42, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 61.74, ["Mega"] = 55.44, ["Mega|Fly"] = 106.98, ["Mega|Ride"] = 70.88, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 10.13, ["Fly"] = 165.46, ["Ride"] = 24.93, ["Fly|Ride"] = 217.2, ["Neon"] = 44.37, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 876.72, ["Mega"] = 327.69, ["Mega|Ride"] = 432.9, ["Mega|Fly|Ride"] = 480.34}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 3.55, ["Ride"] = 64.97, ["Fly|Ride"] = 210, ["Neon"] = 63.18, ["Neon|Ride"] = 262.4, ["Mega"] = 305.82, ["Mega|Ride"] = 314.54, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.92, ["Fly"] = 55.68, ["Ride"] = 17.06, ["Fly|Ride"] = 52.5, ["Neon"] = 22.91, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 122.8, ["Mega"] = 248.78, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 237.79}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 25.94, ["Ride"] = 13.13, ["Fly|Ride"] = 52.77, ["Neon"] = 17.07, ["Neon|Fly"] = 64.67, ["Neon|Ride"] = 27.25, ["Neon|Fly|Ride"] = 90.57, ["Mega"] = 146.87, ["Mega|Ride"] = 118.12, ["Mega|Fly|Ride"] = 287.14}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 220.5, ["Fly"] = 393.75, ["Ride"] = 219.19, ["Fly|Ride"] = 332.03, ["Neon"] = 1308.67, ["Neon|Ride"] = 1446.59, ["Neon|Fly|Ride"] = 1174.69, ["Mega"] = 4303.13, ["Mega|Fly|Ride"] = 3799.48}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 5.25, ["Ride"] = 114.17, ["Neon"] = 34.94, ["Mega"] = 123.38, ["Mega|Ride"] = 662.8, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.62, ["Fly"] = 109.92, ["Ride"] = 26.25, ["Fly|Ride"] = 57.16, ["Neon"] = 32.72, ["Neon|Fly"] = 249.5, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 252.94, ["Mega|Ride"] = 280.66, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 5.25, ["Fly|Ride"] = 730.98, ["Neon"] = 36.75, ["Neon|Ride"] = 43.98, ["Neon|Fly|Ride"] = 603.74, ["Mega"] = 495.14, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 13.12, ["Ride"] = 14.44, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 19.69, ["Neon|Ride"] = 18.27, ["Neon|Fly|Ride"] = 43.32, ["Mega"] = 18.38, ["Mega|Fly"] = 59.07, ["Mega|Ride"] = 30.19, ["Mega|Fly|Ride"] = 78.74}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.4, ["Fly"] = 57.66, ["Ride"] = 22.87, ["Fly|Ride"] = 90.57, ["Neon"] = 22.19, ["Neon|Ride"] = 32.89, ["Neon|Fly|Ride"] = 73.44, ["Mega"] = 129.92, ["Mega|Ride"] = 156.62, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.13, ["Ride"] = 122.3, ["Neon"] = 10.5, ["Neon|Ride"] = 292.62, ["Neon|Fly|Ride"] = 485.63, ["Mega"] = 52.5, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 350.7}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 73.71, ["Fly"] = 104.99, ["Ride"] = 105.21, ["Fly|Ride"] = 166.69, ["Neon"] = 406.88, ["Neon|Ride"] = 371.44, ["Neon|Fly|Ride"] = 387.19, ["Mega"] = 2922.76, ["Mega|Ride"] = 3654.82, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.6, ["Fly"] = 103.32, ["Ride"] = 23.61, ["Fly|Ride"] = 141.74, ["Neon"] = 26.17, ["Neon|Ride"] = 69.57, ["Mega"] = 169.31, ["Mega|Ride"] = 295.91, ["Mega|Fly|Ride"] = 730.98}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Ride"] = 43.86, ["Neon"] = 5.2, ["Neon|Ride"] = 154.88, ["Neon|Fly|Ride"] = 557.34, ["Mega"] = 64.29, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 73.44, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 39.38, ["Fly"] = 131.25, ["Ride"] = 115.86, ["Fly|Ride"] = 240.7, ["Neon"] = 150.93, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 472.5, ["Mega|Ride"] = 636.57, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 73.68, ["Ride"] = 13.51, ["Fly|Ride"] = 37.38, ["Neon"] = 2.13, ["Neon|Fly"] = 22.97, ["Neon|Ride"] = 18.63, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 16.54, ["Mega|Fly"] = 49.88, ["Mega|Fly|Ride"] = 90.57}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 65.63, ["Fly|Ride"] = 98.93, ["Neon"] = 2.6, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 32.01, ["Neon|Fly|Ride"] = 162.22, ["Mega"] = 26.24, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 104.9, ["Mega|Fly|Ride"] = 162.65}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.62, ["Ride"] = 59.07, ["Fly|Ride"] = 161.44, ["Neon"] = 7.88, ["Neon|Ride"] = 101.48, ["Neon|Fly|Ride"] = 166.29, ["Mega"] = 76.01, ["Mega|Fly"] = 190.7, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 216.87}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 5.08, ["Fly"] = 99.93, ["Ride"] = 47.25, ["Fly|Ride"] = 106.94, ["Neon"] = 20.98, ["Neon|Fly"] = 81.35, ["Neon|Ride"] = 75.77, ["Neon|Fly|Ride"] = 158.41, ["Mega"] = 111.46, ["Mega|Fly"] = 336.46, ["Mega|Ride"] = 198.57, ["Mega|Fly|Ride"] = 272.9}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 19.6, ["Ride"] = 15.75, ["Fly|Ride"] = 42.23, ["Neon"] = 2.1, ["Neon|Fly"] = 22.01, ["Neon|Ride"] = 18.79, ["Neon|Fly|Ride"] = 59.19, ["Mega"] = 20.99, ["Mega|Ride"] = 72.34, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 17.99, ["Fly"] = 129.69, ["Ride"] = 85.31, ["Neon"] = 188.82, ["Neon|Ride"] = 188.52, ["Neon|Fly|Ride"] = 380.28, ["Mega"] = 582.54, ["Mega|Fly|Ride"] = 832.9}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2296.88, ["Fly"] = 3150, ["Ride"] = 2417.63, ["Fly|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 7415.63, ["Mega|Fly|Ride"] = 45479.68}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 31.45, ["Ride"] = 16.93, ["Fly|Ride"] = 40.69, ["Neon"] = 9.85, ["Neon|Fly"] = 49.87, ["Neon|Ride"] = 21.92, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 65.63, ["Mega|Fly"] = 292.62, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 162.75}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Ride"] = 65.63, ["Neon"] = 4.4, ["Neon|Ride"] = 72.19, ["Mega"] = 107.98, ["Mega|Fly"] = 441, ["Mega|Ride"] = 124.58, ["Mega|Fly|Ride"] = 506.76}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 16.7, ["Fly"] = 105, ["Ride"] = 32.71, ["Fly|Ride"] = 157.49, ["Neon"] = 82.5, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 285.57, ["Mega"] = 431.81, ["Mega|Ride"] = 555.96, ["Mega|Fly|Ride"] = 762.9}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 25.89, ["Fly"] = 147.28, ["Ride"] = 84, ["Neon"] = 187.69, ["Neon|Ride"] = 212.04, ["Mega"] = 709.07, ["Mega|Ride"] = 700.29, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 136.49, ["Fly"] = 548.42, ["Ride"] = 190.32, ["Fly|Ride"] = 274.32, ["Neon"] = 647.07, ["Neon|Ride"] = 774.38, ["Neon|Fly|Ride"] = 603.75, ["Mega"] = 6575.39, ["Mega|Fly|Ride"] = 3097.02}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 4.55, ["Ride"] = 31.5, ["Fly|Ride"] = 675.94, ["Neon"] = 20.9, ["Neon|Ride"] = 73.44, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 146.87, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 237.57}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.55, ["Ride"] = 42.3, ["Neon"] = 17.99, ["Neon|Ride"] = 115.65, ["Mega"] = 179.81, ["Mega|Fly|Ride"] = 267.09}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 102, ["Ride"] = 27.57, ["Fly|Ride"] = 64.63, ["Neon"] = 7.24, ["Neon|Fly"] = 129.69, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 146.87, ["Mega"] = 74.49, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 267.65}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 12.93, ["Ride"] = 72.19, ["Fly|Ride"] = 131.25, ["Neon"] = 130.92, ["Neon|Ride"] = 1245.01, ["Neon|Fly|Ride"] = 364.88, ["Mega"] = 585.22, ["Mega|Ride"] = 433.13, ["Mega|Fly|Ride"] = 429.85}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 43.09, ["Mega"] = 20.99, ["Mega|Ride"] = 116.67}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 98, ["Fly"] = 258.28, ["Ride"] = 97.93, ["Fly|Ride"] = 170.52, ["Neon"] = 305.82, ["Neon|Fly"] = 470.39, ["Neon|Ride"] = 410.7, ["Neon|Fly|Ride"] = 511.8, ["Mega"] = 3287.7, ["Mega|Fly|Ride"] = 1920.11}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Fly"] = 42.3, ["Ride"] = 37.38, ["Neon"] = 16.24, ["Neon|Ride"] = 147.28, ["Neon|Fly|Ride"] = 102.92, ["Mega"] = 65.37, ["Mega|Ride"] = 292.62, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 103.69, ["Fly"] = 232.6, ["Ride"] = 108.82, ["Fly|Ride"] = 168.33, ["Neon"] = 270.37, ["Neon|Ride"] = 384.66, ["Neon|Fly|Ride"] = 509.25, ["Mega"] = 2625, ["Mega|Ride"] = 1461.95, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 64.21, ["Ride"] = 18.1, ["Fly|Ride"] = 44.57, ["Neon"] = 4.38, ["Neon|Fly"] = 86.9, ["Neon|Ride"] = 73.44, ["Neon|Fly|Ride"] = 83.97, ["Mega"] = 72.19, ["Mega|Fly"] = 496.27, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 7.49, ["Neon|Ride"] = 87.94, ["Mega"] = 41.66, ["Mega|Ride"] = 168.78, ["Mega|Fly|Ride"] = 366.03}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 3.29, ["Fly"] = 73.44, ["Ride"] = 24.52, ["Fly|Ride"] = 90.57, ["Neon"] = 24.93, ["Neon|Fly"] = 109.92, ["Neon|Ride"] = 59.07, ["Mega"] = 141.75, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 585.22}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 362.25, ["Fly"] = 746.09, ["Ride"] = 393.47, ["Fly|Ride"] = 497.44, ["Neon"] = 1181.25, ["Neon|Ride"] = 982.8, ["Neon|Fly|Ride"] = 1065.75, ["Mega"] = 3375.37, ["Mega|Ride"] = 2620.1, ["Mega|Fly|Ride"] = 3474.63}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 32.82, ["Fly"] = 103.36, ["Ride"] = 57.06, ["Fly|Ride"] = 78.75, ["Neon"] = 196.88, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 216.57, ["Mega|Fly"] = 2797.86, ["Mega|Ride"] = 931.95, ["Mega|Fly|Ride"] = 1080.58}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 3.94, ["Fly"] = 72.19, ["Ride"] = 78.74, ["Fly|Ride"] = 107.65, ["Neon"] = 28.58, ["Neon|Fly"] = 101.07, ["Neon|Ride"] = 56.42, ["Neon|Fly|Ride"] = 131.06, ["Mega"] = 169.32, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 288.51}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 23, ["Fly"] = 219.19, ["Ride"] = 70.32, ["Fly|Ride"] = 140.8, ["Neon"] = 86.63, ["Neon|Fly"] = 162.68, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 206.07, ["Mega"] = 288.75, ["Mega|Fly"] = 1021.3, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 501.75}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 4.2, ["Ride"] = 19.42, ["Neon"] = 101.37, ["Neon|Ride"] = 124.13, ["Mega"] = 662.67, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 2.52, ["Neon"] = 13.13, ["Neon|Ride"] = 157.5, ["Mega"] = 108.94, ["Mega|Ride"] = 438.37, ["Mega|Fly|Ride"] = 336.46}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 73.64, ["Ride"] = 22.32, ["Fly|Ride"] = 62.99, ["Neon"] = 64.86, ["Neon|Ride"] = 146.87, ["Neon|Fly|Ride"] = 215.94, ["Mega"] = 579.7, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 104.9, ["Fly"] = 248.71, ["Ride"] = 123.38, ["Fly|Ride"] = 194.25, ["Neon"] = 575.09, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 524.99, ["Mega"] = 1900.31, ["Mega|Ride"] = 2625, ["Mega|Fly|Ride"] = 2205}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 23, ["Ride"] = 57.88, ["Fly|Ride"] = 85.32, ["Neon"] = 128.52, ["Neon|Ride"] = 189, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 551.25, ["Mega|Ride"] = 633.29}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2034.37, ["Fly"] = 1903.13, ["Ride"] = 1995, ["Fly|Ride"] = 1968.75, ["Neon"] = 11723.01, ["Neon|Ride"] = 7944.19, ["Neon|Fly|Ride"] = 6037.5, ["Mega|Fly|Ride"] = 24936.19}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.94, ["Fly"] = 131250, ["Ride"] = 47.45, ["Neon"] = 29.6, ["Neon|Ride"] = 98.34, ["Mega"] = 216.56, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 5.23, ["Ride"] = 59.18, ["Fly|Ride"] = 111.06, ["Neon"] = 21, ["Neon|Ride"] = 94.27, ["Mega"] = 140.44, ["Mega|Ride"] = 146.87, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 853.13, ["Ride"] = 892.5, ["Fly|Ride"] = 935.54, ["Neon"] = 2778.57, ["Neon|Ride"] = 2572.76, ["Neon|Fly|Ride"] = 2887.5, ["Mega|Ride"] = 14067.38, ["Mega|Fly|Ride"] = 9352.39}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 32.71, ["Ride"] = 58.46, ["Fly|Ride"] = 105, ["Neon"] = 235.02, ["Neon|Ride"] = 328.62, ["Mega"] = 866.36, ["Mega|Ride"] = 848.25, ["Mega|Fly|Ride"] = 854.44}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.1, ["Ride"] = 22.29, ["Fly|Ride"] = 128.15, ["Neon"] = 14.49, ["Neon|Fly"] = 166.35, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 157.5, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Ride"] = 147.28, ["Neon"] = 6.57, ["Neon|Ride"] = 25.23, ["Neon|Fly|Ride"] = 113.98, ["Mega"] = 29.53, ["Mega|Ride"] = 61.31, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 85.31, ["Fly"] = 439.61, ["Ride"] = 144.38, ["Fly|Ride"] = 157.5, ["Neon"] = 459.38, ["Neon|Ride"] = 614.4, ["Neon|Fly|Ride"] = 646.98, ["Mega"] = 2482.34, ["Mega|Fly|Ride"] = 2476.73}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.1, ["Ride"] = 38.48, ["Fly|Ride"] = 76.94, ["Neon"] = 12.53, ["Neon|Ride"] = 64.32, ["Mega"] = 91.87, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 249.58}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 78.75, ["Ride"] = 106.32, ["Neon"] = 621.74, ["Neon|Ride"] = 599.47, ["Neon|Fly|Ride"] = 526.04, ["Mega"] = 2191.82, ["Mega|Fly|Ride"] = 1677.83}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 5.86, ["Fly"] = 105, ["Fly|Ride"] = 131.9, ["Neon"] = 32.47, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 269.06, ["Mega"] = 360.66, ["Mega|Ride"] = 317.7}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 262.5, ["Fly"] = 425.34, ["Ride"] = 301.88, ["Fly|Ride"] = 354.38, ["Neon"] = 1148.82, ["Neon|Ride"] = 1453.98, ["Neon|Fly|Ride"] = 879.38, ["Mega|Fly|Ride"] = 3922.87}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.27, ["Fly"] = 34.09, ["Ride"] = 19.58, ["Fly|Ride"] = 63.75, ["Neon"] = 47.24, ["Neon|Ride"] = 54.8, ["Neon|Fly|Ride"] = 82.72, ["Mega"] = 178.5, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 23.64, ["Ride"] = 19.69, ["Fly|Ride"] = 48.86, ["Neon"] = 4.93, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 64.67, ["Mega"] = 38.07, ["Mega|Ride"] = 115.24, ["Mega|Fly|Ride"] = 125.22}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1466.07, ["Ride"] = 1050, ["Fly|Ride"] = 1050, ["Neon|Ride"] = 8037.31, ["Neon|Fly|Ride"] = 7306.35, ["Mega"] = 24823.31, ["Mega|Fly|Ride"] = 27470.83}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 16.7, ["Ride"] = 83.14, ["Neon"] = 91.77, ["Neon|Ride"] = 314.98, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 432.9, ["Mega|Ride"] = 484.35, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 5.24, ["Fly"] = 54.02, ["Ride"] = 43.98, ["Fly|Ride"] = 101.56, ["Neon"] = 25.86, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 118, ["Mega"] = 180.45, ["Mega|Ride"] = 257.88, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 34.96, ["Fly"] = 38.66, ["Ride"] = 38.84, ["Fly|Ride"] = 72.85, ["Neon"] = 331.24, ["Neon|Ride"] = 219.19, ["Neon|Fly|Ride"] = 190.98, ["Mega"] = 2630.16, ["Mega|Ride"] = 876.72, ["Mega|Fly|Ride"] = 799.31}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 13.12, ["Fly"] = 62.91, ["Ride"] = 30.63, ["Fly|Ride"] = 72.19, ["Neon"] = 61.46, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 367.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 585.22}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 89.25, ["Fly|Ride"] = 644.01, ["Neon"] = 449.23, ["Neon|Fly"] = 586.88, ["Neon|Ride"] = 546.87, ["Neon|Fly|Ride"] = 832.9, ["Mega"] = 3944.14, ["Mega|Fly|Ride"] = 1141.88}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Neon"] = 2.63, ["Neon|Fly"] = 55.83, ["Neon|Ride"] = 115.31, ["Neon|Fly|Ride"] = 103.03, ["Mega"] = 17.07, ["Mega|Ride"] = 144.47, ["Mega|Fly|Ride"] = 217.81}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 131.25, ["Fly"] = 247.29, ["Ride"] = 116.71, ["Fly|Ride"] = 218.54, ["Neon"] = 845.9, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 682.5, ["Mega"] = 3506.88, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.5, ["Fly"] = 748.35, ["Ride"] = 32.34, ["Fly|Ride"] = 69.44, ["Neon"] = 229.67, ["Neon|Ride"] = 83.99, ["Mega"] = 773.71, ["Mega|Ride"] = 446.75, ["Mega|Fly|Ride"] = 490.88}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 18.38, ["Fly|Ride"] = 39.35, ["Neon"] = 13.13, ["Neon|Fly"] = 83.19, ["Neon|Ride"] = 87.69, ["Neon|Fly|Ride"] = 69.98, ["Mega"] = 109.61, ["Mega|Ride"] = 280.24}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 5.23, ["Ride"] = 123.5, ["Neon"] = 15.74, ["Neon|Fly"] = 144.66, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 214.86}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 102.26, ["Ride"] = 203.44, ["Fly|Ride"] = 438.37, ["Neon"] = 632.12, ["Neon|Ride"] = 679.47, ["Neon|Fly|Ride"] = 700.43, ["Mega"] = 1968.75, ["Mega|Ride"] = 1680, ["Mega|Fly|Ride"] = 1783.69}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 4.85, ["Ride"] = 85.32, ["Neon"] = 21, ["Neon|Ride"] = 59.07, ["Mega"] = 122.17, ["Mega|Ride"] = 160.01, ["Mega|Fly|Ride"] = 331.34}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 25.23, ["Mega"] = 18.25, ["Mega|Ride"] = 219.19, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.94, ["Ride"] = 44.63, ["Fly|Ride"] = 145.29, ["Neon"] = 2.1, ["Neon|Fly"] = 86.2, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 203.85, ["Mega"] = 18.38, ["Mega|Fly"] = 59.19, ["Mega|Ride"] = 45.54, ["Mega|Fly|Ride"] = 116.82}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 36.74, ["Ride"] = 16.2, ["Fly|Ride"] = 52.49, ["Neon"] = 5.16, ["Neon|Ride"] = 24.49, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 63, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 146.87}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Fly"] = 29.69, ["Ride"] = 28.88, ["Fly|Ride"] = 91.87, ["Neon"] = 10.4, ["Mega"] = 137.82, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 22.31, ["Ride"] = 15.65, ["Fly|Ride"] = 42.84, ["Neon"] = 16.47, ["Neon|Fly"] = 87.69, ["Neon|Ride"] = 40.94, ["Neon|Fly|Ride"] = 77.66, ["Mega"] = 261.19, ["Mega|Ride"] = 103.01, ["Mega|Fly|Ride"] = 228.25}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 60.27, ["Ride"] = 91.88, ["Fly|Ride"] = 290.51, ["Neon"] = 196.88, ["Neon|Ride"] = 378, ["Neon|Fly|Ride"] = 424.13, ["Mega"] = 643.13, ["Mega|Ride"] = 772.35, ["Mega|Fly|Ride"] = 885.93}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 17.06, ["Ride"] = 16.5, ["Fly|Ride"] = 49.25, ["Neon"] = 2.62, ["Neon|Fly"] = 32.81, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 38, ["Mega"] = 17.07, ["Mega|Fly"] = 43.86, ["Mega|Ride"] = 38.12, ["Mega|Fly|Ride"] = 97.13}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 5.25, ["Fly"] = 58.97, ["Ride"] = 52.5, ["Fly|Ride"] = 65.63, ["Neon"] = 45.94, ["Neon|Fly"] = 43.84, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 135.64, ["Mega"] = 242.82, ["Mega|Fly"] = 585.22, ["Mega|Ride"] = 273.32, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 26.23, ["Fly"] = 59.07, ["Ride"] = 52.5, ["Fly|Ride"] = 119.44, ["Neon"] = 170.63, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 196.07, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1315.09, ["Mega|Ride"] = 876.72, ["Mega|Fly|Ride"] = 768.48}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 9.09, ["Fly"] = 209.98, ["Ride"] = 63.75, ["Neon"] = 101.88, ["Mega"] = 511.39, ["Mega|Ride"] = 1039.5, ["Mega|Fly|Ride"] = 870.16}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 18.63, ["Ride"] = 15.98, ["Fly|Ride"] = 42.88, ["Neon"] = 4.29, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 20.79, ["Neon|Fly|Ride"] = 55.09, ["Mega"] = 40.43, ["Mega|Ride"] = 43.86, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 12.97, ["Ride"] = 87.67, ["Neon"] = 91.87, ["Neon|Ride"] = 206.06, ["Neon|Fly|Ride"] = 394.53, ["Mega"] = 531.78, ["Mega|Fly"] = 581.94, ["Mega|Ride"] = 581.94, ["Mega|Fly|Ride"] = 687.14}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 1017.19, ["Fly"] = 1304.52, ["Ride"] = 1036.88, ["Fly|Ride"] = 1069.65, ["Neon"] = 2491.13, ["Neon|Ride"] = 2744.44, ["Neon|Fly|Ride"] = 2336.25, ["Mega|Fly|Ride"] = 6168.75}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 262.5, ["Ride"] = 249.38, ["Fly|Ride"] = 590.63, ["Neon"] = 721.88, ["Neon|Ride"] = 853.13, ["Mega"] = 3640.91, ["Mega|Ride"] = 3799.48, ["Mega|Fly|Ride"] = 3504.69}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.62, ["Ride"] = 22.32, ["Fly|Ride"] = 392.44, ["Neon"] = 10.18, ["Neon|Ride"] = 111.56, ["Neon|Fly|Ride"] = 261.94, ["Mega"] = 60.38, ["Mega|Fly|Ride"] = 1169.35}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 157.39, ["Ride"] = 236.14, ["Fly|Ride"] = 420, ["Neon"] = 639.19, ["Neon|Ride"] = 695.63, ["Neon|Fly|Ride"] = 945, ["Mega"] = 2362.5, ["Mega|Ride"] = 2309.86, ["Mega|Fly|Ride"] = 2205}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.6, ["Ride"] = 24.02, ["Fly|Ride"] = 95.36, ["Neon"] = 20.99, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 38.75, ["Neon|Fly|Ride"] = 317.82, ["Mega"] = 115.96, ["Mega|Ride"] = 234.54, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 246.75, ["Fly"] = 439.61, ["Ride"] = 324.22, ["Fly|Ride"] = 330.75, ["Neon|Ride"] = 1607.7, ["Neon|Fly|Ride"] = 1562.77, ["Mega|Fly|Ride"] = 3979.59}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 77.18, ["Ride"] = 23.63, ["Fly|Ride"] = 229.65, ["Neon"] = 24.92, ["Neon|Ride"] = 57.99, ["Mega"] = 393.75, ["Mega|Fly"] = 367.14, ["Mega|Ride"] = 585.22}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 40.69, ["Mega"] = 249.38, ["Mega|Ride"] = 247.69}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 19.69, ["Fly"] = 52.49, ["Ride"] = 58.98, ["Fly|Ride"] = 147.28, ["Neon"] = 102.38, ["Neon|Fly"] = 438.37, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 847.75, ["Mega|Ride"] = 593.92, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.76, ["Fly|Ride"] = 293.45, ["Neon"] = 17.07, ["Neon|Ride"] = 196.88, ["Mega"] = 248.2, ["Mega|Ride"] = 241.87, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 16.58, ["Ride"] = 15.64, ["Fly|Ride"] = 35.44, ["Neon"] = 3.15, ["Neon|Fly"] = 21.31, ["Neon|Ride"] = 26.22, ["Neon|Fly|Ride"] = 55.79, ["Mega"] = 31.5, ["Mega|Fly"] = 55.13, ["Mega|Ride"] = 34.54, ["Mega|Fly|Ride"] = 107.62}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 3839.07, ["Ride"] = 4580.63, ["Fly|Ride"] = 4723.69, ["Neon"] = 32876.88, ["Neon|Fly|Ride"] = 21624.23, ["Mega|Fly|Ride"] = 52500}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 8.28, ["Ride"] = 41.99, ["Neon"] = 87.94, ["Neon|Fly"] = 390.16, ["Neon|Ride"] = 101.64, ["Neon|Fly|Ride"] = 166.29, ["Mega"] = 210, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 19.29, ["Ride"] = 19.69, ["Fly|Ride"] = 47.25, ["Neon"] = 11.71, ["Neon|Fly"] = 45.93, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 81.32, ["Mega"] = 144.38, ["Mega|Ride"] = 146.87, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 492.19, ["Fly"] = 547.78, ["Ride"] = 492.19, ["Fly|Ride"] = 586.38, ["Neon"] = 2052.94, ["Neon|Ride"] = 1292.81, ["Neon|Fly|Ride"] = 1189.16, ["Mega|Fly|Ride"] = 5114.82}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 3.67, ["Ride"] = 49.66, ["Neon"] = 22.32, ["Neon|Ride"] = 291.38, ["Mega"] = 143.39, ["Mega|Ride"] = 174.26, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 6.21, ["Fly"] = 145.69, ["Ride"] = 19.69, ["Neon"] = 67.16, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 875.61, ["Mega|Ride"] = 401.62, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 73.64, ["Ride"] = 20.77, ["Fly|Ride"] = 65.63, ["Neon"] = 7.23, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 25.2, ["Neon|Fly|Ride"] = 91.75, ["Mega"] = 82.21, ["Mega|Ride"] = 70.86, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 629.99, ["Fly"] = 894.59, ["Ride"] = 656.25, ["Fly|Ride"] = 714, ["Neon|Ride"] = 2126.25, ["Neon|Fly|Ride"] = 2099.99, ["Mega|Fly|Ride"] = 8219.24}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 10.39, ["Ride"] = 72.18, ["Fly|Ride"] = 131.25, ["Neon"] = 45.93, ["Neon|Fly"] = 328.12, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 137.71, ["Mega"] = 262.5, ["Mega|Fly"] = 438.37, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 419.88}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 3.28, ["Fly"] = 59.36, ["Ride"] = 49.87, ["Neon"] = 23.63, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 175.37, ["Mega"] = 144.37, ["Mega|Fly"] = 827.94, ["Mega|Ride"] = 192.94, ["Mega|Fly|Ride"] = 276.18}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 39.26, ["Ride"] = 24.89, ["Fly|Ride"] = 65.63, ["Neon"] = 14.69, ["Neon|Fly"] = 58.47, ["Neon|Ride"] = 32.55, ["Neon|Fly|Ride"] = 86.4, ["Mega"] = 166.35, ["Mega|Fly|Ride"] = 239.78}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 18.17, ["Fly"] = 39.38, ["Ride"] = 39.81, ["Fly|Ride"] = 65.63, ["Neon"] = 117.6, ["Neon|Ride"] = 114.18, ["Neon|Fly|Ride"] = 292.62, ["Mega"] = 647.69, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 1680}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Fly|Ride"] = 293.45, ["Neon"] = 3.94, ["Neon|Ride"] = 59.19, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 31.4, ["Mega|Fly"] = 157.83, ["Mega|Ride"] = 101.35, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 590.63, ["Ride"] = 717.94, ["Fly|Ride"] = 710.07, ["Neon"] = 2589.58, ["Neon|Ride"] = 2338.66, ["Neon|Fly|Ride"] = 2415.78, ["Mega|Ride"] = 9679.28, ["Mega|Fly|Ride"] = 7874.99}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.48, ["Ride"] = 65.63, ["Fly|Ride"] = 257.25, ["Neon"] = 11.7, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 68.16, ["Mega|Ride"] = 137.73, ["Mega|Fly|Ride"] = 218.1}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 51.34, ["Fly|Ride"] = 196.88, ["Neon"] = 7.54, ["Neon|Fly"] = 293.45, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 41.91, ["Mega|Ride"] = 152.65, ["Mega|Fly|Ride"] = 240.76}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Neon"] = 3.94, ["Neon|Ride"] = 40.32, ["Neon|Fly|Ride"] = 7306.35, ["Mega"] = 81.12, ["Mega|Fly"] = 151.46, ["Mega|Ride"] = 127.21, ["Mega|Fly|Ride"] = 216.5}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.36, ["Ride"] = 26.25, ["Neon"] = 13.13, ["Mega"] = 258.64, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 23.13, ["Fly"] = 78.75, ["Ride"] = 42, ["Fly|Ride"] = 217.63, ["Neon"] = 155.93, ["Neon|Ride"] = 195.65, ["Neon|Fly|Ride"] = 393.74, ["Mega"] = 687.14, ["Mega|Ride"] = 563.42, ["Mega|Fly|Ride"] = 593.81}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 16.46, ["Ride"] = 52.41, ["Fly|Ride"] = 190.32, ["Neon"] = 87.43, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 294, ["Mega"] = 551.25, ["Mega|Ride"] = 779.63, ["Mega|Fly|Ride"] = 755.47}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 23.61, ["Ride"] = 15.35, ["Fly|Ride"] = 48.57, ["Neon"] = 39.1, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 36.62, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 299.92, ["Mega|Ride"] = 273.67, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 10.5, ["Ride"] = 29.69, ["Fly|Ride"] = 149.23, ["Neon"] = 70.88, ["Neon|Ride"] = 162.68}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 109.61, ["Neon"] = 15.22, ["Neon|Ride"] = 59.19, ["Neon|Fly|Ride"] = 127.34, ["Mega"] = 85.31, ["Mega|Fly"] = 124.1, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 258.13}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 20.89, ["Fly"] = 34.13, ["Ride"] = 31.16, ["Fly|Ride"] = 57.75, ["Neon"] = 116.93, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 167.35, ["Mega"] = 905.63, ["Mega|Fly|Ride"] = 719.25}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 35.07, ["Fly"] = 97.13, ["Neon"] = 157.5, ["Mega"] = 281.71, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 735.67}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 48.07, ["Fly"] = 85.32, ["Ride"] = 91.86, ["Fly|Ride"] = 259.88, ["Neon"] = 271.69, ["Neon|Ride"] = 345.19, ["Neon|Fly|Ride"] = 374.07, ["Mega|Ride"] = 1242.76, ["Mega|Fly|Ride"] = 1351.88}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 26.17, ["Fly"] = 147.28, ["Ride"] = 114.19, ["Fly|Ride"] = 228.38, ["Neon"] = 131.13, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 502.85, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 691.05}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 13.02, ["Ride"] = 64.32, ["Neon"] = 141.63, ["Neon|Ride"] = 223.13, ["Mega"] = 502.69, ["Mega|Ride"] = 609.35, ["Mega|Fly|Ride"] = 849.33}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 42.95, ["Fly"] = 393.75, ["Ride"] = 105, ["Fly|Ride"] = 208.94, ["Neon"] = 233.42, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 704.82, ["Mega"] = 826.88, ["Mega|Ride"] = 818.66, ["Mega|Fly|Ride"] = 876.72}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 23.93, ["Ride"] = 15.72, ["Fly|Ride"] = 35.44, ["Neon"] = 4.39, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 59.19, ["Mega"] = 40.14, ["Mega|Fly"] = 331.41, ["Mega|Ride"] = 55.91, ["Mega|Fly|Ride"] = 146.99}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1312.5}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 116.82, ["Ride"] = 275.63, ["Fly|Ride"] = 374.22, ["Neon"] = 513.24, ["Neon|Ride"] = 730.98, ["Neon|Fly|Ride"] = 953.63, ["Mega"] = 1640.63, ["Mega|Ride"] = 1751.26, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 83.91, ["Neon"] = 2.63, ["Neon|Fly"] = 103.03, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 306.87, ["Mega"] = 64.67, ["Mega|Ride"] = 141, ["Mega|Fly|Ride"] = 139.07}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 23.63, ["Ride"] = 65.62, ["Neon"] = 118.02, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 591.93, ["Mega|Ride"] = 662.67, ["Mega|Fly|Ride"] = 625.77}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 2.5, ["Neon|Fly|Ride"] = 146.87, ["Mega"] = 24.86}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Mega"] = 29.6, ["Mega|Ride"] = 146.87}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 118.12, ["Fly"] = 1833.14, ["Ride"] = 152.25, ["Fly|Ride"] = 210, ["Neon"] = 664.02, ["Neon|Ride"] = 433.13, ["Neon|Fly|Ride"] = 645.75, ["Mega|Ride"] = 6827.04, ["Mega|Fly|Ride"] = 2077.69}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 19.49, ["Fly|Ride"] = 73.64, ["Neon"] = 8.33, ["Neon|Fly"] = 43.98, ["Neon|Ride"] = 32.29, ["Neon|Fly|Ride"] = 99.73, ["Mega"] = 91.88, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 36.54, ["Ride"] = 27.46, ["Fly|Ride"] = 66.94, ["Neon"] = 5.86, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 419.9, ["Mega"] = 35.44, ["Mega|Ride"] = 129.15, ["Mega|Fly|Ride"] = 217.87}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 6.56, ["Neon"] = 13.96, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 223.13, ["Mega"] = 207.25}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.61, ["Ride"] = 131.25, ["Neon"] = 11.71, ["Neon|Ride"] = 137.82, ["Mega"] = 124.69, ["Mega|Ride"] = 336.46}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 103.03, ["Ride"] = 137.82, ["Fly|Ride"] = 367.07, ["Neon"] = 538.13, ["Neon|Ride"] = 603.75, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1874.25, ["Mega|Fly|Ride"] = 2572.5}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 9.16, ["Ride"] = 72.19, ["Neon"] = 83.32, ["Neon|Ride"] = 131.25, ["Mega"] = 422.29, ["Mega|Ride"] = 376.95, ["Mega|Fly|Ride"] = 645.74}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 367.5, ["Ride"] = 393.74, ["Fly|Ride"] = 747.33, ["Neon"] = 918.75, ["Neon|Ride"] = 1485.91, ["Neon|Fly|Ride"] = 1199.63, ["Mega|Fly|Ride"] = 2922.76}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 78.75}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 55.12}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 16.15}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 17.69}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 50.59}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 116.82}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 18.38}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 5.25}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 192.93}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 17.07}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 45.94}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 12.87}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 8.79}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 1010.62}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 7.39}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 7.19}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 6.51}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 6.57}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 42}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 564.38}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 510.5}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 5.25}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1704.94}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 63.34}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.2}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 6.57}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 17.07}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.62}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 50.94}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 22.68}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 64.32}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 19.67}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 13.02}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 19.58}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.3}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 63.94}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 7.33}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.1}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 15.75}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 18.66}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 7.07}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 4.69}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 2018.63}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 95.84}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 302.3}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 4.11}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 3.14}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 24.03}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 31.48}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 30.98}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 262.48}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 10.48}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 32.8}},
    ["rbxassetid://1265129435"] = {name = "Gold Snowboard", prices = {["default"] = 131.25}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 163.96}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 52.5}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 6.2}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.4}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 37.3}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 16.68}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.62}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 105}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 28.02}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 5.15}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 26.25}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.6}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 10.28}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 2.52}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 29.79}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 94.31}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 398.98}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 7.62}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 332.1}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.94}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 108.55}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 24.29}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 23100}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 124.69}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 54.73}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 36.75}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 30.18}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 52.41}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 31.11}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 51.18}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 129.66}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 84.14}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 36.49}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 109.66}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 39.38}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 42.84}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 47.27}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 262.4}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 8.49}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 8.99}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 5.13}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 6.48}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 31.02}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 217.58}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.5}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 5.02}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.62}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.5}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 3.73}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 20.68}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 228.27}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 826.88}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 10.5}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 616.87}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 16.58}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.41}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.3}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 231}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.63}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 44.7}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 99.71}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 24.94}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 51.89}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 69.47}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 17.75}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.94}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 11.43}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.49}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 6.56}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 10.39}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 36.74}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.52}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.6}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.38}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 17.06}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 195.25}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 45.38}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 213.05}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 14.69}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 8.99}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 8.56}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 31.4}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 72.19}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 5.25}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 9.97}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 3.94}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 6.27}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 19.59}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 18.38}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 6.46}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 2.1}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 8.28}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 10.5}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 3.94}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 3.92}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.94}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 3.77}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 8268.75}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 6.62}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 11.79}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3.93}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 5.17}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 5.21}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 6.47}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 19.66}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 5.25}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 5.08}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 4.97}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 3.78}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 14.42}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 45.29}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 6.14}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 5.63}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 3.46}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.88}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 3654.82}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 17.07}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 45.83}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 4.75}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 80.76}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 3.93}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 131.14}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.36}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.1}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.69}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 3.93}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 10.5}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 27.56}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.21}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.81}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 11.9}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 4.94}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.99}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.69}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.6}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 4.75}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.37}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 29.58}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 2.4}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 11.45}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 116.34}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.67}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 72.06}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 13.13}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 3.33}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1443.75}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 86.43}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 4.91}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 68.25}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 35.44}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.63}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.9}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 7.56}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 21}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.17}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 13.9}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 15.65}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 2.5}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 12.74}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 5.6}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 13.81}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 15.75}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 7.77}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 90.72}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 23.37}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.63}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 16.46}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 439.61}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 110.22}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 15.1}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 22.31}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 24.49}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 3.1}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 6.28}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 3.93}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 6.57}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 147.28}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 150.93}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 14.21}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1036.66}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 188.97}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 12.54}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 10.31}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 58.94}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.73}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 4.82}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 4.5}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 91.87}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 19.36}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 6.45}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.9}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 8.9}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.15}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 60.99}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 2.21}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 59.76}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 4.65}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 4.39}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 17.87}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 113.96}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 5.25}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 76.12}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 50.84}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 52.8}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 58.7}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 65.63}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.84}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 62.65}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.62}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 143.07}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 3.94}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.47}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 129.82}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 63.95}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 9.19}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 43.32}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.94}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 5.02}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 8.38}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 20.79}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 80.07}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 59.07}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2.59}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 15.6}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 48.43}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.4}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 4.5}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 28.88}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.53}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 65.63}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 95.15}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 47.97}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 25.9}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1942.49}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 19.45}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 9.89}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 22.99}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 263.67}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 21.37}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 9.09}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 35.21}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 12.49}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 14.33}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 349.93}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 57.75}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 44.52}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 2.62}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 63}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 177.18}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 90.91}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1132.02}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 196.77}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 8.96}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1727.25}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 576.19}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 2.61}},
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