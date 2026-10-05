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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1050, ["Ride"] = 1179.93, ["Fly|Ride"] = 1612.24, ["Neon"] = 6855.19, ["Neon|Fly|Ride"] = 5114.76, ["Mega"] = 21979.94, ["Mega|Fly|Ride"] = 21979.94}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 636.34, ["Fly"] = 754.8, ["Ride"] = 530.24, ["Fly|Ride"] = 731.95, ["Neon|Fly|Ride"] = 2100, ["Mega"] = 10989.98, ["Mega|Fly|Ride"] = 8617.25}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 6562.5, ["Ride"] = 4950.75, ["Fly|Ride"] = 4976.79, ["Neon|Fly|Ride"] = 21394.2, ["Mega|Fly|Ride"] = 77662.81}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 205.62, ["Ride"] = 258.71, ["Fly|Ride"] = 411.04, ["Neon"] = 1161.42, ["Neon|Ride"] = 984.38, ["Neon|Fly|Ride"] = 1103.82, ["Mega|Fly|Ride"] = 4973.84}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 485.63, ["Fly"] = 879.21, ["Ride"] = 590.63, ["Fly|Ride"] = 656.25, ["Neon|Fly|Ride"] = 1616.99, ["Mega|Fly|Ride"] = 5250}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 12.72, ["Ride"] = 58.97, ["Fly|Ride"] = 129.94, ["Neon"] = 87.94, ["Neon|Fly"] = 293.45, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 219.81, ["Mega"] = 357.33, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 611.06}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.94, ["Fly"] = 54.96, ["Ride"] = 24.2, ["Fly|Ride"] = 72.1, ["Neon"] = 35.12, ["Neon|Fly"] = 138.5, ["Neon|Ride"] = 57.51, ["Neon|Fly|Ride"] = 132.89, ["Mega"] = 231, ["Mega|Fly"] = 275.63, ["Mega|Ride"] = 195.66, ["Mega|Fly|Ride"] = 395.66}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 99.74, ["Fly"] = 199.02, ["Ride"] = 141.75, ["Fly|Ride"] = 236.25, ["Neon"] = 425.25, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 1758.41, ["Mega"] = 1586.82, ["Mega|Ride"] = 2492.44, ["Mega|Fly|Ride"] = 1857.32}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 39.37, ["Fly"] = 97.76, ["Ride"] = 52.49, ["Fly|Ride"] = 106.17, ["Neon"] = 275.63, ["Neon|Ride"] = 236.45, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 1837.5, ["Mega|Ride"] = 1172.64, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 26.17, ["Fly"] = 59.36, ["Ride"] = 31.4, ["Fly|Ride"] = 72.19, ["Neon"] = 149.23, ["Neon|Fly"] = 83.32, ["Neon|Ride"] = 131.9, ["Neon|Fly|Ride"] = 199.68, ["Mega"] = 659.42, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 80.07, ["Ride"] = 144.38, ["Fly|Ride"] = 197.36, ["Neon"] = 402.81, ["Neon|Ride"] = 321.57, ["Neon|Fly|Ride"] = 548.42, ["Mega"] = 1575, ["Mega|Ride"] = 1443.75}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 68.25}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 348.64, ["Fly"] = 498.96, ["Ride"] = 321.57, ["Fly|Ride"] = 413.44, ["Neon|Fly"] = 1483.67, ["Neon|Ride"] = 1758.41, ["Neon|Fly|Ride"] = 1538.6, ["Mega|Fly|Ride"] = 5043.94}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 137.75, ["Fly"] = 147.28, ["Ride"] = 131.15, ["Fly|Ride"] = 175.88, ["Neon|Fly"] = 696.35, ["Neon|Fly|Ride"] = 577.5, ["Mega"] = 4312.63, ["Mega|Fly|Ride"] = 2467.5}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 4.41, ["Fly"] = 81.48, ["Ride"] = 65.62, ["Neon"] = 41.77, ["Neon|Ride"] = 133.06, ["Neon|Fly|Ride"] = 261.58, ["Mega"] = 147.28, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 337.42, ["Mega|Fly|Ride"] = 486.87}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 237.62, ["Fly"] = 310.95, ["Ride"] = 239.45, ["Fly|Ride"] = 273, ["Neon|Ride"] = 1161.42, ["Neon|Fly|Ride"] = 945, ["Mega|Fly|Ride"] = 2750.9}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.62, ["Fly"] = 39.59, ["Ride"] = 19.17, ["Fly|Ride"] = 42.14, ["Neon"] = 38.48, ["Neon|Fly"] = 131.9, ["Neon|Ride"] = 81.99, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 170.63, ["Mega|Ride"] = 293.45, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 200.82, ["Fly"] = 333.62, ["Ride"] = 217.88, ["Fly|Ride"] = 324.22, ["Neon"] = 525, ["Neon|Ride"] = 595.6, ["Neon|Fly|Ride"] = 721.88, ["Mega"] = 1824.18, ["Mega|Ride"] = 1574.9, ["Mega|Fly|Ride"] = 1559.25}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 43.31}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 65.63, ["Ride"] = 173.25, ["Fly|Ride"] = 326.17, ["Neon"] = 459.38, ["Neon|Fly|Ride"] = 787.5, ["Mega|Fly|Ride"] = 1846.32}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 36.75, ["Fly"] = 393.75, ["Ride"] = 59.07, ["Fly|Ride"] = 190.21, ["Neon"] = 262.5, ["Neon|Ride"] = 300.57, ["Neon|Fly|Ride"] = 429.19, ["Mega"] = 2860.65, ["Mega|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 1026.48}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 40.64, ["Fly"] = 75.12, ["Ride"] = 64.39, ["Fly|Ride"] = 112.67, ["Neon"] = 170.52, ["Neon|Ride"] = 194.04, ["Neon|Fly|Ride"] = 280.64, ["Mega"] = 1741.27, ["Mega|Fly|Ride"] = 850.08}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 40.69, ["Fly"] = 257.28, ["Ride"] = 73.64, ["Fly|Ride"] = 196.88, ["Neon"] = 252.11, ["Neon|Ride"] = 411.04, ["Neon|Fly|Ride"] = 499.16, ["Mega"] = 1967.44, ["Mega|Fly|Ride"] = 1589.17}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 32.82, ["Ride"] = 63, ["Fly|Ride"] = 127.5, ["Neon"] = 210, ["Neon|Ride"] = 162.75, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 1207.92, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 43.22, ["Fly"] = 82.45, ["Ride"] = 71.97, ["Fly|Ride"] = 115.5, ["Neon"] = 258.32, ["Neon|Ride"] = 273.42, ["Neon|Fly|Ride"] = 320.75, ["Mega|Ride"] = 1161.42, ["Mega|Fly|Ride"] = 937.13}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 7.66, ["Fly"] = 32.82, ["Ride"] = 20.99, ["Fly|Ride"] = 48.87, ["Neon"] = 40.69, ["Neon|Fly"] = 412.13, ["Neon|Ride"] = 59.36, ["Neon|Fly|Ride"] = 105, ["Mega"] = 156.53, ["Mega|Fly"] = 310.09, ["Mega|Ride"] = 188.2, ["Mega|Fly|Ride"] = 287.23}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 525, ["Ride"] = 485.63, ["Fly|Ride"] = 524.99, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1966.13, ["Mega"] = 10989.98, ["Mega|Fly|Ride"] = 9865.59}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 14.42, ["Ride"] = 31.5, ["Fly|Ride"] = 136.28, ["Neon"] = 219.19, ["Neon|Fly|Ride"] = 448.41, ["Mega|Ride"] = 689.08, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 4.92, ["Fly"] = 43.23, ["Ride"] = 20.98, ["Fly|Ride"] = 48.57, ["Neon"] = 65.63, ["Neon|Ride"] = 76.12, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 324.19, ["Mega|Ride"] = 315.98, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 83.98, ["Fly"] = 116.93, ["Ride"] = 91.88, ["Fly|Ride"] = 131.25, ["Neon"] = 367.07, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 404.65, ["Mega"] = 6590.66, ["Mega|Ride"] = 5832.75, ["Mega|Fly|Ride"] = 1648.52}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 14.34, ["Ride"] = 34.47, ["Fly|Ride"] = 66.94, ["Neon"] = 81.99, ["Neon|Ride"] = 115.08, ["Neon|Fly|Ride"] = 270.57, ["Mega"] = 720.57, ["Mega|Ride"] = 746.09, ["Mega|Fly|Ride"] = 557.21}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 242.82, ["Fly"] = 300.68, ["Ride"] = 236.27, ["Fly|Ride"] = 340.55, ["Neon"] = 813.24, ["Neon|Ride"] = 623.44, ["Neon|Fly|Ride"] = 752.46, ["Mega"] = 6593.99, ["Mega|Ride"] = 3937.49, ["Mega|Fly|Ride"] = 2934.59}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 23.93}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.66, ["Fly"] = 28.28, ["Ride"] = 24.51, ["Fly|Ride"] = 72.85, ["Neon"] = 24.64, ["Neon|Fly"] = 147.28, ["Neon|Ride"] = 46.23, ["Neon|Fly|Ride"] = 131.9, ["Mega"] = 287.44, ["Mega|Fly"] = 497.52, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 1076.25, ["Fly"] = 2625, ["Ride"] = 1172.96, ["Fly|Ride"] = 1181.25, ["Neon"] = 9187.5, ["Neon|Ride"] = 6447.84, ["Neon|Fly|Ride"] = 6565.47, ["Mega|Ride"] = 55968.83, ["Mega|Fly|Ride"] = 24727.43}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 21, ["Fly"] = 115.11, ["Ride"] = 52.5, ["Fly|Ride"] = 105.99, ["Neon"] = 208.82, ["Neon|Ride"] = 270.37, ["Neon|Fly|Ride"] = 287.67, ["Mega"] = 1043.44, ["Mega|Ride"] = 1128.68, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 210, ["Fly"] = 373.14, ["Ride"] = 262.5, ["Fly|Ride"] = 311.85, ["Neon"] = 1067.42, ["Neon|Ride"] = 978.8, ["Neon|Fly|Ride"] = 1030.32, ["Mega"] = 4286.1, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 3956.4}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 37.17}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 15.54, ["Fly"] = 86.8, ["Ride"] = 119.44, ["Fly|Ride"] = 147.28, ["Neon"] = 104.99, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 415.33, ["Mega"] = 592.55, ["Mega|Ride"] = 586.88, ["Mega|Fly|Ride"] = 664.02}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 134.27, ["Fly"] = 168.92, ["Ride"] = 145.53, ["Fly|Ride"] = 217.62, ["Neon"] = 494.57, ["Neon|Ride"] = 548.42, ["Neon|Fly|Ride"] = 586.88, ["Mega|Ride"] = 2322.8, ["Mega|Fly|Ride"] = 1811.24}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 103.69, ["Fly"] = 250.08, ["Ride"] = 160.78, ["Fly|Ride"] = 246.21, ["Neon"] = 427.8, ["Neon|Fly"] = 829.6, ["Neon|Ride"] = 443.63, ["Neon|Fly|Ride"] = 498.75, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1481.76}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 43.32}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 52.89, ["Fly"] = 63, ["Ride"] = 55.12, ["Fly|Ride"] = 78.75, ["Neon|Ride"] = 538.13, ["Neon|Fly|Ride"] = 373.02, ["Mega"] = 4396, ["Mega|Fly|Ride"] = 1509.38}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 8.74, ["Fly"] = 138.5, ["Ride"] = 57.66, ["Fly|Ride"] = 207.38, ["Neon"] = 52.77, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 142.88, ["Neon|Fly|Ride"] = 242.17, ["Mega"] = 218.72, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 416.07}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 603.75, ["Ride"] = 620.92, ["Fly|Ride"] = 695.63, ["Neon|Fly"] = 3956.4, ["Neon|Ride"] = 1903.13, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Ride"] = 15385.96, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 127.32, ["Fly"] = 166.68, ["Ride"] = 131.23, ["Fly|Ride"] = 203.34, ["Neon"] = 525, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 549.94, ["Mega|Fly|Ride"] = 2296.88}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 4477.52, ["Ride"] = 3885, ["Fly|Ride"] = 3937.5}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 83.08, ["Fly"] = 235.2, ["Ride"] = 112.88, ["Fly|Ride"] = 201.68, ["Neon"] = 664.02, ["Neon|Ride"] = 514.5, ["Mega|Ride"] = 2052.94, ["Mega|Fly|Ride"] = 2021.25}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 86.09, ["Fly"] = 328.13, ["Ride"] = 81.21, ["Fly|Ride"] = 109.45, ["Neon"] = 575.75, ["Neon|Ride"] = 439.61, ["Neon|Fly|Ride"] = 509.95, ["Mega"] = 6447.84, ["Mega|Ride"] = 2388.75, ["Mega|Fly|Ride"] = 2558.49}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 31.54, ["Fly"] = 63.89, ["Ride"] = 43.96, ["Fly|Ride"] = 100.42, ["Neon"] = 147.28, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 198.19, ["Mega"] = 2625, ["Mega|Ride"] = 939.66, ["Mega|Fly|Ride"] = 611.62}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 6.57}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 49.88, ["Fly"] = 52.5, ["Ride"] = 66.91, ["Fly|Ride"] = 133.06, ["Neon|Ride"] = 332.03, ["Neon|Fly|Ride"] = 446.25, ["Mega|Ride"] = 1326.78, ["Mega|Fly|Ride"] = 1391.34}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 35.32}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 185.07, ["Ride"] = 236.23, ["Fly|Ride"] = 282.19, ["Neon"] = 1172.64, ["Neon|Ride"] = 1161.42, ["Neon|Fly|Ride"] = 1316.62, ["Mega|Fly|Ride"] = 4973.84}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 689.07, ["Ride"] = 754.69, ["Fly|Ride"] = 733.06, ["Neon|Ride"] = 3077.2, ["Neon|Fly|Ride"] = 2846.31, ["Mega|Fly|Ride"] = 10028.82}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 7.88}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 33.39, ["Fly"] = 65.54, ["Ride"] = 39.79, ["Fly|Ride"] = 65.63, ["Neon"] = 210, ["Neon|Fly"] = 285.75, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 222.18, ["Mega|Ride"] = 1174.61, ["Mega|Fly|Ride"] = 766.49}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 24.86}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5931.64, ["Fly"] = 7327.02, ["Ride"] = 6148.9, ["Fly|Ride"] = 4812.94, ["Neon|Ride"] = 18239.05, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 32156.25}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 12.78, ["Fly"] = 37.84, ["Ride"] = 27.54, ["Fly|Ride"] = 58.47, ["Neon"] = 129.93, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 157.4, ["Mega"] = 561.75, ["Mega|Ride"] = 446.24, ["Mega|Fly|Ride"] = 589.32}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 15.73, ["Fly"] = 73.64, ["Ride"] = 32.8, ["Fly|Ride"] = 138.5, ["Neon"] = 145.69, ["Neon|Ride"] = 143.75, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1099.02, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 98.44, ["Fly"] = 116.51, ["Ride"] = 112.12, ["Fly|Ride"] = 105, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 490.73, ["Mega"] = 4396, ["Mega|Fly|Ride"] = 1824.18}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 13.6, ["Fly"] = 73.64, ["Ride"] = 34.09, ["Fly|Ride"] = 78.75, ["Neon"] = 98.44, ["Neon|Fly"] = 219.81, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 501.38, ["Mega"] = 562.7, ["Mega|Ride"] = 785.8, ["Mega|Fly|Ride"] = 800.63}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1706.25, ["Fly"] = 2433.19, ["Ride"] = 2039.77, ["Fly|Ride"] = 1509.38, ["Neon|Fly|Ride"] = 3017.44, ["Mega|Fly|Ride"] = 11025}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 24937.5, ["Fly"] = 35755.86, ["Ride"] = 29850.05, ["Fly|Ride"] = 24412.5, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 63000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 15.54, ["Fly"] = 393.75, ["Ride"] = 54.99, ["Fly|Ride"] = 120.75, ["Neon"] = 158.45, ["Neon|Ride"] = 248.71, ["Neon|Fly|Ride"] = 364.88, ["Mega"] = 1050, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1559.32}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.94, ["Fly"] = 91.76, ["Ride"] = 45.83, ["Fly|Ride"] = 170.37, ["Neon"] = 26.16, ["Neon|Fly"] = 231.69, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 209.88, ["Mega|Fly"] = 254.63, ["Mega|Ride"] = 421.64, ["Mega|Fly|Ride"] = 364.87}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 26.03}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.39, ["Ride"] = 43.98, ["Fly|Ride"] = 167.45, ["Neon"] = 72.75, ["Neon|Ride"] = 108.94, ["Neon|Fly|Ride"] = 279.9, ["Mega"] = 437.42, ["Mega|Ride"] = 417.63, ["Mega|Fly|Ride"] = 549.52}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 622.13, ["Fly"] = 879.21, ["Ride"] = 586.88, ["Fly|Ride"] = 728.57, ["Neon"] = 3151.68, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 9201.6}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 787.5, ["Fly"] = 1076.15, ["Ride"] = 853.13, ["Fly|Ride"] = 990.68, ["Neon|Fly|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 13926.73}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 15.63, ["Fly"] = 124.36, ["Ride"] = 34.09, ["Fly|Ride"] = 78.75, ["Neon"] = 87.94, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 512.14, ["Mega|Ride"] = 481.9, ["Mega|Fly|Ride"] = 580.72}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 29.93}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 103.32, ["Fly"] = 128.34, ["Ride"] = 91.85, ["Fly|Ride"] = 144.38, ["Neon"] = 586.88, ["Neon|Ride"] = 426.57, ["Neon|Fly|Ride"] = 420, ["Mega"] = 19687.5, ["Mega|Ride"] = 2052.94, ["Mega|Fly|Ride"] = 2155.15}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 91.88, ["Fly"] = 105, ["Ride"] = 103.32, ["Fly|Ride"] = 157.5, ["Neon"] = 450.19, ["Neon|Ride"] = 530.82, ["Neon|Fly|Ride"] = 509.15, ["Mega"] = 1430.23, ["Mega|Fly|Ride"] = 2180.76}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.72, ["Fly"] = 26.25, ["Ride"] = 19.68, ["Fly|Ride"] = 59.07, ["Neon"] = 49.76, ["Neon|Fly"] = 488.69, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 116.89, ["Mega"] = 272.87, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 203.43, ["Fly"] = 224.44, ["Ride"] = 219.59, ["Fly|Ride"] = 315, ["Neon|Ride"] = 654.94, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 5275.2, ["Mega|Fly|Ride"] = 2821.88}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 7.37, ["Ride"] = 50.91, ["Fly|Ride"] = 137.82, ["Neon"] = 47.16, ["Neon|Ride"] = 105, ["Mega"] = 274.77, ["Mega|Fly"] = 1137.94, ["Mega|Ride"] = 278.69, ["Mega|Fly|Ride"] = 471.19}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 19.51, ["Fly"] = 65.63, ["Ride"] = 32.82, ["Fly|Ride"] = 90.96, ["Neon"] = 131.25, ["Neon|Fly"] = 332.1, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 213.94, ["Mega|Fly|Ride"] = 846.24}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 28.3, ["Ride"] = 57.75, ["Fly|Ride"] = 156.19, ["Neon"] = 257.25, ["Neon|Ride"] = 279.98, ["Mega"] = 997.5, ["Mega|Ride"] = 853.13, ["Mega|Fly|Ride"] = 1011.85}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 18.38, ["Fly"] = 90.14, ["Ride"] = 41.99, ["Fly|Ride"] = 85.32, ["Neon"] = 131.25, ["Neon|Ride"] = 326.72, ["Neon|Fly|Ride"] = 351.69, ["Mega"] = 1099.02, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6813.8, ["Ride"] = 5814.38, ["Fly|Ride"] = 5767.13, ["Neon"] = 32969.9, ["Neon|Fly|Ride"] = 30771.91}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 226.49, ["Fly"] = 266.44, ["Ride"] = 236.15, ["Fly|Ride"] = 293.45, ["Neon|Fly|Ride"] = 630, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 78.93, ["Fly"] = 314.89, ["Ride"] = 154.44, ["Fly|Ride"] = 328.13, ["Neon"] = 223.12, ["Neon|Ride"] = 324.22, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 627.27, ["Mega|Ride"] = 556.5, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.52, ["Fly"] = 65.63, ["Ride"] = 18.66, ["Fly|Ride"] = 81.37, ["Neon"] = 31.5, ["Neon|Ride"] = 35.28, ["Neon|Fly|Ride"] = 195.88, ["Mega"] = 499.8, ["Mega|Ride"] = 330.75, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 65.6, ["Fly"] = 215.34, ["Ride"] = 131.25, ["Fly|Ride"] = 224.44, ["Neon"] = 220.5, ["Neon|Ride"] = 246.75, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 521.83, ["Mega|Fly"] = 747.33, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 16485, ["Ride"] = 13415.07, ["Fly|Ride"] = 11679.94, ["Neon|Fly|Ride"] = 24766.88, ["Mega|Fly|Ride"] = 109753.5}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 380.62, ["Ride"] = 410.82, ["Fly|Ride"] = 504, ["Neon|Ride"] = 2170.54, ["Neon|Fly|Ride"] = 1817.75, ["Mega"] = 8749.13}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 59.06, ["Fly"] = 64.97, ["Ride"] = 59.06, ["Fly|Ride"] = 113.14, ["Neon"] = 439.61, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 389.82, ["Mega|Fly|Ride"] = 2050.74}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 8.68, ["Ride"] = 24.9, ["Fly|Ride"] = 72.13, ["Neon"] = 69.21, ["Neon|Fly"] = 282.35, ["Neon|Ride"] = 78.72, ["Neon|Fly|Ride"] = 145.09, ["Mega"] = 470.39, ["Mega|Ride"] = 746.09, ["Mega|Fly|Ride"] = 879.21}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 387.17, ["Ride"] = 421.02, ["Fly|Ride"] = 467.23, ["Neon"] = 1253.44, ["Neon|Ride"] = 1442.44, ["Neon|Fly|Ride"] = 1312.49, ["Mega|Fly|Ride"] = 4547.82}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 9.19, ["Fly"] = 103.32, ["Ride"] = 42, ["Fly|Ride"] = 226.41, ["Neon"] = 39.38, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 188.9, ["Mega"] = 157.49, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 351.69}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 118.12, ["Fly"] = 172.23, ["Ride"] = 156.35, ["Fly|Ride"] = 238.93, ["Neon"] = 465.94, ["Neon|Fly"] = 525, ["Neon|Ride"] = 488.25, ["Neon|Fly|Ride"] = 550.99, ["Mega"] = 2637.62, ["Mega|Fly|Ride"] = 2430.18}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 14.25, ["Fly"] = 22.23, ["Ride"] = 19.68, ["Fly|Ride"] = 35.35, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 2637.62, ["Mega|Fly|Ride"] = 645.75}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 8.54}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 72.02, ["Fly"] = 598.23, ["Ride"] = 87.94, ["Fly|Ride"] = 175.86, ["Neon"] = 244.78, ["Neon|Fly"] = 548.42, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 425.34, ["Mega|Ride"] = 1905.67, ["Mega|Fly|Ride"] = 2052.94}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 16.96, ["Fly"] = 78.75, ["Ride"] = 43.32, ["Fly|Ride"] = 89.65, ["Neon"] = 107.63, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 141.74, ["Neon|Fly|Ride"] = 194.91, ["Mega"] = 553.91, ["Mega|Ride"] = 577.5, ["Mega|Fly|Ride"] = 568.79}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 45.94}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 90.56, ["Fly"] = 147.28, ["Ride"] = 131.25, ["Fly|Ride"] = 439.61, ["Neon"] = 392.44, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 664.02, ["Mega|Ride"] = 1658.78, ["Mega|Fly|Ride"] = 1989.56}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.83, ["Ride"] = 35.18, ["Neon"] = 20.69, ["Neon|Ride"] = 143.98, ["Neon|Fly|Ride"] = 293.45, ["Mega"] = 144.38, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 286.79}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 13.12, ["Fly"] = 56.42, ["Ride"] = 26.4, ["Fly|Ride"] = 95.11, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 218.72, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 586.69}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 603.74, ["Ride"] = 534.45, ["Fly|Ride"] = 498.75, ["Neon|Fly|Ride"] = 2856.3, ["Mega|Fly|Ride"] = 7087.5}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 43.32, ["Ride"] = 56.44, ["Fly|Ride"] = 107.57, ["Neon"] = 172.91, ["Neon|Ride"] = 149.23, ["Neon|Fly|Ride"] = 210, ["Mega"] = 776.43, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 829.4}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 50.96, ["Ride"] = 82.38, ["Fly|Ride"] = 149, ["Neon"] = 315.86, ["Neon|Ride"] = 237.09, ["Neon|Fly|Ride"] = 244.86, ["Mega|Ride"] = 1097.93, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 20.56, ["Ride"] = 65.63, ["Fly|Ride"] = 110.24, ["Neon"] = 99, ["Neon|Ride"] = 161.18, ["Neon|Fly|Ride"] = 202.13, ["Mega"] = 350.83, ["Mega|Ride"] = 580.46, ["Mega|Fly|Ride"] = 586.88}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11025, ["Fly"] = 10500, ["Ride"] = 8861.99, ["Fly|Ride"] = 7875, ["Neon|Fly|Ride"] = 14424.38, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1351.88, ["Fly"] = 1517.02, ["Ride"] = 1659.17, ["Fly|Ride"] = 1311.19, ["Neon|Fly|Ride"] = 3726.07, ["Mega|Fly|Ride"] = 15916.26}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 417.37, ["Ride"] = 459.38, ["Fly|Ride"] = 807.35, ["Neon"] = 2253.58, ["Neon|Fly|Ride"] = 3084.38, ["Mega"] = 21979.94, ["Mega|Fly|Ride"] = 9947.67}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 12.62, ["Fly"] = 32.99, ["Ride"] = 24.56, ["Fly|Ride"] = 43.31, ["Neon"] = 91.35, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 131.25, ["Mega|Fly|Ride"] = 539.44}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 4.11, ["Fly"] = 78.74, ["Ride"] = 37.38, ["Fly|Ride"] = 202.23, ["Neon"] = 35.18, ["Neon|Ride"] = 76.07, ["Mega"] = 164.07, ["Mega|Ride"] = 214.31, ["Mega|Fly|Ride"] = 349.5}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 36.73, ["Fly"] = 60.38, ["Ride"] = 48.56, ["Fly|Ride"] = 98.44, ["Neon"] = 550.66, ["Neon|Ride"] = 171.94, ["Neon|Fly|Ride"] = 205.65, ["Mega"] = 870.43, ["Mega|Fly|Ride"] = 666.75}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.4, ["Fly"] = 23.12, ["Ride"] = 20.07, ["Fly|Ride"] = 38.43, ["Neon"] = 23.63, ["Neon|Fly"] = 83.02, ["Neon|Ride"] = 43.94, ["Neon|Fly|Ride"] = 90.57, ["Mega"] = 323.32, ["Mega|Ride"] = 367.07, ["Mega|Fly|Ride"] = 260.39}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 352.06, ["Fly"] = 367.5, ["Ride"] = 315, ["Fly|Ride"] = 416.53, ["Neon|Ride"] = 1230.89, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4834.5}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 20.1, ["Fly"] = 72.55, ["Ride"] = 40.68, ["Fly|Ride"] = 84, ["Neon"] = 144.38, ["Neon|Fly"] = 411.41, ["Neon|Ride"] = 175.86, ["Neon|Fly|Ride"] = 209.88, ["Mega"] = 879.21, ["Mega|Fly"] = 928.88, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 715.32}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 11.46, ["Fly"] = 22.01, ["Ride"] = 27.39, ["Fly|Ride"] = 49.88, ["Neon"] = 293.45, ["Neon|Fly"] = 124.2, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 129.65, ["Mega"] = 1575, ["Mega|Ride"] = 451.5, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 445.69, ["Fly"] = 1048.69, ["Ride"] = 485.63, ["Fly|Ride"] = 879.21, ["Mega|Fly|Ride"] = 9971.07}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1115.52, ["Fly"] = 1466.07, ["Ride"] = 1060.5, ["Fly|Ride"] = 1260, ["Neon"] = 5336.96, ["Neon|Ride"] = 4982.86, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13782.3}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 122.39, ["Fly"] = 147.28, ["Ride"] = 143.05, ["Fly|Ride"] = 147.28, ["Neon"] = 971.25, ["Neon|Fly|Ride"] = 505.31, ["Mega|Ride"] = 2635.42, ["Mega|Fly|Ride"] = 2929.94}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 131.25, ["Fly"] = 196.88, ["Ride"] = 200.03, ["Fly|Ride"] = 258.57, ["Neon|Ride"] = 652.82, ["Neon|Fly|Ride"] = 677.25, ["Mega|Ride"] = 9187.5, ["Mega|Fly|Ride"] = 2892.75}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 31.5, ["Fly"] = 126.4, ["Ride"] = 56, ["Fly|Ride"] = 100.03, ["Neon"] = 262.4, ["Neon|Ride"] = 243, ["Mega|Ride"] = 2198.01, ["Mega|Fly|Ride"] = 1112.91}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 275.86, ["Ride"] = 646.14, ["Fly|Ride"] = 586.88, ["Neon"] = 1220.63, ["Mega|Fly|Ride"] = 5862.06}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2008.13, ["Ride"] = 2475.11, ["Fly|Ride"] = 2099.9, ["Neon"] = 10989.98, ["Neon|Fly|Ride"] = 10989.98, ["Mega|Fly|Ride"] = 50553.86}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 50.57, ["Fly"] = 219.81, ["Ride"] = 52.5, ["Fly|Ride"] = 196.88, ["Neon"] = 288.75, ["Neon|Ride"] = 169.26, ["Neon|Fly|Ride"] = 343.3, ["Mega|Ride"] = 1216.6, ["Mega|Fly|Ride"] = 1172.64}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 603.74, ["Fly"] = 864.06, ["Ride"] = 623.58, ["Fly|Ride"] = 656.25, ["Neon"] = 1616.51, ["Neon|Ride"] = 1498.88, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 3471.71}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 52.5, ["Fly"] = 72.19, ["Ride"] = 57.87, ["Fly|Ride"] = 98.6, ["Neon"] = 439.61, ["Neon|Ride"] = 263.78, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 4.3, ["Fly"] = 33.43, ["Ride"] = 19.68, ["Fly|Ride"] = 65.96, ["Neon"] = 30.19, ["Neon|Fly"] = 136.5, ["Neon|Ride"] = 43.98, ["Neon|Fly|Ride"] = 103.45, ["Mega"] = 186.27, ["Mega|Fly"] = 249.38, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 249.36}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 65.61, ["Ride"] = 65.63, ["Fly|Ride"] = 157.5, ["Neon"] = 397.38, ["Neon|Ride"] = 486.34, ["Neon|Fly|Ride"] = 733.06, ["Mega"] = 1647.41, ["Mega|Ride"] = 1758.41, ["Mega|Fly|Ride"] = 1744.13}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 1023.75, ["Ride"] = 1057.35, ["Fly|Ride"] = 1181.25, ["Neon|Ride"] = 3694.69, ["Neon|Fly|Ride"] = 3495.19, ["Mega|Fly|Ride"] = 14654.04}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 708.74, ["Ride"] = 864.93, ["Fly|Ride"] = 994.8, ["Neon|Fly|Ride"] = 4396, ["Mega|Fly|Ride"] = 20515}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 15.17, ["Fly"] = 26.2, ["Ride"] = 24.13, ["Fly|Ride"] = 45.94, ["Neon"] = 144.38, ["Neon|Ride"] = 115.97, ["Neon|Fly|Ride"] = 157.49, ["Mega|Fly|Ride"] = 777.34}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 24.76, ["Ride"] = 46.3, ["Fly|Ride"] = 131.9, ["Neon"] = 275.63, ["Neon|Ride"] = 268.17, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 1211.15, ["Mega|Ride"] = 1458.38, ["Mega|Fly|Ride"] = 1076.25}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.83, ["Fly"] = 45.94, ["Ride"] = 33.28, ["Fly|Ride"] = 73.64, ["Neon"] = 26.24, ["Neon|Fly"] = 326.27, ["Neon|Ride"] = 64.29, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 188.62, ["Mega|Fly"] = 580.72, ["Mega|Ride"] = 205.7, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 43.32, ["Fly"] = 60.25, ["Ride"] = 62.57, ["Fly|Ride"] = 125.31, ["Neon"] = 324.22, ["Neon|Ride"] = 220.5, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 786.19}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 104.97, ["Ride"] = 170.63, ["Fly|Ride"] = 367.07, ["Neon"] = 545.74, ["Neon|Ride"] = 603.75, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1874.25, ["Mega|Fly|Ride"] = 2572.5}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 15.57, ["Fly"] = 59.07, ["Ride"] = 39.17, ["Fly|Ride"] = 84.5, ["Neon"] = 131.15, ["Neon|Ride"] = 97.86, ["Neon|Fly|Ride"] = 158.42, ["Mega"] = 439.61, ["Mega|Ride"] = 406.67, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 34.13, ["Fly"] = 65.54, ["Ride"] = 45.14, ["Fly|Ride"] = 78.4, ["Neon"] = 242.82, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 219.81, ["Mega"] = 2100, ["Mega|Ride"] = 1142.97, ["Mega|Fly|Ride"] = 1443.75}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.13, ["Fly"] = 56.03, ["Ride"] = 22.01, ["Fly|Ride"] = 42, ["Neon"] = 35.23, ["Neon|Ride"] = 39.67, ["Neon|Fly|Ride"] = 98.02, ["Mega"] = 223.13, ["Mega|Ride"] = 497.4, ["Mega|Fly|Ride"] = 332.03}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 9.09, ["Fly"] = 65.63, ["Ride"] = 35.44, ["Fly|Ride"] = 108.2, ["Neon"] = 91.23, ["Neon|Fly"] = 115.54, ["Neon|Ride"] = 82.3, ["Neon|Fly|Ride"] = 218.72, ["Mega"] = 380.63, ["Mega|Ride"] = 481.31, ["Mega|Fly|Ride"] = 511.77}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 52.39, ["Fly"] = 72.19, ["Ride"] = 54.03, ["Fly|Ride"] = 99.49, ["Neon"] = 572.87, ["Neon|Ride"] = 211.08, ["Neon|Fly|Ride"] = 223.13, ["Mega|Fly|Ride"] = 1074.94}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1722.02, ["Fly"] = 1807.32, ["Ride"] = 1475.25, ["Fly|Ride"] = 1470, ["Neon|Ride"] = 5305.85, ["Neon|Fly|Ride"] = 3478.13, ["Mega|Fly|Ride"] = 13013.69}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 498.74, ["Fly"] = 693.48, ["Ride"] = 498.75, ["Fly|Ride"] = 572.24, ["Neon|Ride"] = 2429.89, ["Neon|Fly|Ride"] = 2332.32, ["Mega"] = 15385.96, ["Mega|Fly|Ride"] = 9890.98}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 301.87, ["Fly"] = 491.29, ["Ride"] = 341.25, ["Fly|Ride"] = 451.5, ["Neon"] = 1312.5, ["Neon|Ride"] = 1612.24, ["Neon|Fly|Ride"] = 1824.18, ["Mega|Fly|Ride"] = 8060.06}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 44.51}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 31.5, ["Ride"] = 49.79, ["Fly|Ride"] = 175.86, ["Neon"] = 299.92, ["Neon|Fly"] = 586.88, ["Neon|Ride"] = 301.87, ["Neon|Fly|Ride"] = 518.44, ["Mega|Ride"] = 1758.41, ["Mega|Fly|Ride"] = 1036.54}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 70875, ["Fly"] = 90562.5, ["Ride"] = 38133.12, ["Fly|Ride"] = 21000, ["Neon|Fly|Ride"] = 33468.75, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 261.06, ["Fly"] = 328.13, ["Ride"] = 293.45, ["Fly|Ride"] = 367.5, ["Neon"] = 1039.98, ["Neon|Ride"] = 962.45, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 6593.99, ["Mega|Fly|Ride"] = 3281.33}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 158.81, ["Fly"] = 525, ["Ride"] = 165.83, ["Fly|Ride"] = 262.5}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 91.88, ["Fly"] = 219.81, ["Ride"] = 113.12, ["Fly|Ride"] = 170.63, ["Neon|Ride"] = 719.24, ["Neon|Fly|Ride"] = 627.86, ["Mega|Fly|Ride"] = 2887.5}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 14.44, ["Fly"] = 63.75, ["Ride"] = 33.49, ["Fly|Ride"] = 65.63, ["Neon"] = 166.64, ["Neon|Fly"] = 105, ["Neon|Ride"] = 158.28, ["Neon|Fly|Ride"] = 240.7, ["Mega"] = 1968.75, ["Mega|Ride"] = 733.06, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4095, ["Ride"] = 4058.25, ["Fly|Ride"] = 3976.88, ["Neon"] = 21979.94, ["Neon|Fly|Ride"] = 15750, ["Mega|Fly|Ride"] = 82917.2}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 30.17, ["Fly"] = 52.41, ["Ride"] = 34.86, ["Fly|Ride"] = 63.96, ["Neon"] = 201.44, ["Neon|Ride"] = 167.19, ["Neon|Fly|Ride"] = 190.2, ["Mega|Ride"] = 1466.07, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 36.74, ["Fly"] = 94.54, ["Ride"] = 43.32, ["Fly|Ride"] = 116.82, ["Neon"] = 310.73, ["Neon|Fly"] = 1466.07, ["Neon|Ride"] = 202.79, ["Neon|Fly|Ride"] = 349.5, ["Mega|Fly|Ride"] = 1601.25}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 439.29, ["Fly"] = 563.07, ["Ride"] = 470.53, ["Fly|Ride"] = 523.69, ["Neon"] = 1410.94, ["Neon|Ride"] = 1181.24, ["Neon|Fly|Ride"] = 1181.24, ["Mega|Fly|Ride"] = 4539.97}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 15.41, ["Fly"] = 30.86, ["Ride"] = 24.94, ["Fly|Ride"] = 49.88, ["Neon"] = 131.25, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 14.34, ["Fly"] = 293.45, ["Ride"] = 35.43, ["Fly|Ride"] = 82.08, ["Neon"] = 98.44, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 217.7, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 746.09}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 108.94, ["Ride"] = 111.57, ["Fly|Ride"] = 245.44, ["Neon"] = 1010.63, ["Neon|Ride"] = 511.88, ["Neon|Fly|Ride"] = 702.28, ["Mega|Fly|Ride"] = 4146.94}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 19.69, ["Fly"] = 549.52, ["Ride"] = 51.43, ["Fly|Ride"] = 192.31, ["Neon"] = 59.07, ["Neon|Ride"] = 175.86, ["Neon|Fly|Ride"] = 237.57, ["Mega"] = 425.34, ["Mega|Fly"] = 354.38, ["Mega|Ride"] = 288.1, ["Mega|Fly|Ride"] = 477.28}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 5610.94, ["Fly"] = 7462.53, ["Ride"] = 4856.25, ["Fly|Ride"] = 5250, ["Neon"] = 19687.5, ["Neon|Ride"] = 14921.5, ["Neon|Fly|Ride"] = 11811.19, ["Mega"] = 52312.24, ["Mega|Fly|Ride"] = 37945.69}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 39.01, ["Fly"] = 74.75, ["Ride"] = 61.51, ["Fly|Ride"] = 183.54, ["Neon"] = 233.62, ["Neon|Ride"] = 232.54, ["Neon|Fly|Ride"] = 332.03, ["Mega"] = 1246.28, ["Mega|Ride"] = 1824.6, ["Mega|Fly|Ride"] = 784.88}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 6562.5, ["Ride"] = 6857.82, ["Fly|Ride"] = 6209.86, ["Neon|Fly|Ride"] = 14962.5, ["Mega|Fly|Ride"] = 46921.88}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.47, ["Fly"] = 21.8, ["Ride"] = 18.37, ["Fly|Ride"] = 35.26, ["Neon"] = 39.38, ["Neon|Fly"] = 62.74, ["Neon|Ride"] = 48.37, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 242.82, ["Mega|Fly"] = 1466.07, ["Mega|Ride"] = 219.81, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 16.89, ["Fly"] = 28.49, ["Ride"] = 32.99, ["Fly|Ride"] = 58.45, ["Neon"] = 92.04, ["Neon|Fly"] = 242.9, ["Neon|Ride"] = 142.63, ["Neon|Fly|Ride"] = 142.93, ["Mega|Ride"] = 880.04, ["Mega|Fly|Ride"] = 879.21}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 4.82}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 14.43, ["Fly"] = 39.37, ["Ride"] = 33.75, ["Fly|Ride"] = 94.5, ["Neon"] = 131.25, ["Neon|Ride"] = 139.13, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 1049.9, ["Mega|Ride"] = 1171.55, ["Mega|Fly|Ride"] = 1326.78}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 28, ["Fly"] = 190.37, ["Ride"] = 53.82, ["Fly|Ride"] = 156.08, ["Neon"] = 244.34, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 994.8, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 11.42, ["Fly"] = 27.57, ["Ride"] = 19.69, ["Fly|Ride"] = 43.32, ["Neon"] = 94, ["Neon|Fly"] = 1095.72, ["Neon|Ride"] = 109.92, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 1152.86, ["Mega|Fly|Ride"] = 672.6}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 6628.13}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 3071.25}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 24.42}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 229.69, ["Ride"] = 381.76, ["Fly|Ride"] = 341.24, ["Neon|Fly|Ride"] = 1228.56}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 15.74, ["Fly"] = 52.5, ["Ride"] = 37.97, ["Fly|Ride"] = 103.69, ["Neon"] = 104.9, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 265.13, ["Mega|Ride"] = 2156.18, ["Mega|Fly|Ride"] = 570.4}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 13.13}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 5.94, ["Ride"] = 26.24, ["Fly|Ride"] = 87.94, ["Neon"] = 147.28, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 131.25, ["Mega|Fly|Ride"] = 496.12}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2545.31}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 255.94, ["Fly"] = 439.61, ["Ride"] = 664.18, ["Fly|Ride"] = 746.09, ["Neon"] = 1048.69, ["Neon|Ride"] = 1095.5, ["Neon|Fly|Ride"] = 1097.93, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 69.98, ["Fly"] = 219.81, ["Ride"] = 104.43, ["Fly|Ride"] = 525, ["Neon"] = 422.79, ["Neon|Ride"] = 367.49, ["Neon|Fly|Ride"] = 345.19, ["Mega|Fly|Ride"] = 2195.82}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 165.11, ["Fly"] = 266.18, ["Ride"] = 183.75, ["Fly|Ride"] = 214.18, ["Neon"] = 945, ["Neon|Ride"] = 741.57, ["Neon|Fly|Ride"] = 748.12, ["Mega|Ride"] = 3736.61, ["Mega|Fly|Ride"] = 3359.9}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2754.94, ["Fly"] = 3370.64, ["Ride"] = 2756.25, ["Fly|Ride"] = 2883.56, ["Neon"] = 15436.52, ["Neon|Ride"] = 8352.39, ["Neon|Fly|Ride"] = 8791.99, ["Mega|Fly|Ride"] = 31499.99}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 20.79, ["Fly"] = 108.82, ["Ride"] = 39.38, ["Fly|Ride"] = 86.46, ["Neon"] = 127.32, ["Neon|Ride"] = 166.64, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 988.01, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 918.75, ["Fly"] = 2231.25, ["Ride"] = 983.61, ["Fly|Ride"] = 1758.41, ["Neon|Fly|Ride"] = 5493.9}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 54.87}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 21.32, ["Fly"] = 87.94, ["Ride"] = 48.57, ["Fly|Ride"] = 245.44, ["Neon"] = 115.5, ["Neon|Ride"] = 136.28, ["Neon|Fly|Ride"] = 268.17, ["Mega"] = 387.71, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 495.15}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 11.17, ["Fly"] = 52.26, ["Ride"] = 31.13, ["Fly|Ride"] = 77.12, ["Neon"] = 72.19, ["Neon|Fly"] = 315, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 465.07, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 378.07}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 61.04}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 22.32, ["Fly"] = 65.96, ["Ride"] = 36.66, ["Fly|Ride"] = 65.63, ["Neon"] = 147.28, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 254.63, ["Mega|Ride"] = 1318.82, ["Mega|Fly|Ride"] = 878.12}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 26.99, ["Fly"] = 50.57, ["Ride"] = 32.16, ["Fly|Ride"] = 63, ["Neon"] = 166.64, ["Neon|Fly"] = 242.9, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 292.35, ["Mega"] = 1466.07, ["Mega|Ride"] = 1865.64, ["Mega|Fly|Ride"] = 871.5}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6734.81, ["Fly"] = 5775, ["Ride"] = 5112.19, ["Fly|Ride"] = 5118.75, ["Neon|Fly|Ride"] = 10500, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 10.18, ["Fly"] = 50.57, ["Ride"] = 32.82, ["Fly|Ride"] = 81.84, ["Neon"] = 57.18, ["Neon|Ride"] = 95.7, ["Neon|Fly|Ride"] = 237.51, ["Mega"] = 354.38, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 586.88}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 24.93}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 91.88, ["Fly"] = 389.06, ["Ride"] = 122, ["Fly|Ride"] = 207.67, ["Neon"] = 531.57, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 526.24, ["Mega"] = 2879.59, ["Mega|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 1850.63}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 55.88, ["Fly"] = 73.64, ["Ride"] = 99.65, ["Fly|Ride"] = 178.28, ["Neon"] = 347.82, ["Neon|Fly"] = 397.91, ["Neon|Ride"] = 317.63, ["Neon|Fly|Ride"] = 557.21, ["Mega"] = 1246.28, ["Mega|Ride"] = 1260.57, ["Mega|Fly|Ride"] = 1200.94}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 24.44, ["Fly"] = 83.54, ["Ride"] = 27.56, ["Fly|Ride"] = 64.22, ["Neon"] = 174.57, ["Neon|Fly"] = 237.4, ["Neon|Ride"] = 154.98, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 1016.21, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6.35, ["Fly"] = 78.75, ["Ride"] = 28.88, ["Fly|Ride"] = 131.9, ["Neon"] = 37.68, ["Neon|Ride"] = 59.05, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 307.13, ["Mega|Fly"] = 7222.85, ["Mega|Ride"] = 232.32, ["Mega|Fly|Ride"] = 354.35}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 17.07, ["Fly"] = 63.67, ["Ride"] = 32.82, ["Fly|Ride"] = 94.54, ["Neon"] = 85.74, ["Neon|Ride"] = 109.92, ["Neon|Fly|Ride"] = 233.01, ["Mega"] = 380.63, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 22.32, ["Fly"] = 33.42, ["Ride"] = 28.04, ["Fly|Ride"] = 58.11, ["Neon"] = 186.84, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 177.18, ["Mega|Fly|Ride"] = 511.87}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 187.59}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 25.3, ["Ride"] = 171.94, ["Fly|Ride"] = 339.94, ["Neon"] = 169.32, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 470.39, ["Mega"] = 866.25, ["Mega|Fly|Ride"] = 769.23}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 525, ["Ride"] = 1466.07, ["Neon|Fly|Ride"] = 73266.81}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 65.51, ["Ride"] = 89.25, ["Fly|Ride"] = 117.6, ["Neon"] = 216.57, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 394.83, ["Mega"] = 1182.57, ["Mega|Ride"] = 2322.8, ["Mega|Fly|Ride"] = 1488.47}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 1312.5, ["Fly"] = 1181.25, ["Ride"] = 1232.44, ["Fly|Ride"] = 1260, ["Neon"] = 4787.33, ["Neon|Fly"] = 4787.33, ["Neon|Ride"] = 3675, ["Neon|Fly|Ride"] = 3281.25, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 467.77, ["Fly"] = 829.6, ["Ride"] = 479.07, ["Fly|Ride"] = 604.11, ["Neon"] = 2884.88, ["Neon|Ride"] = 2198.01, ["Neon|Fly|Ride"] = 2033.07, ["Mega"] = 12600, ["Mega|Fly|Ride"] = 9973.69}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 59.07}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 11.45, ["Fly"] = 32.81, ["Ride"] = 24.94, ["Fly|Ride"] = 53.83, ["Neon"] = 83.32, ["Neon|Fly"] = 162.68, ["Neon|Ride"] = 85.75, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 437.26, ["Mega|Ride"] = 664.18, ["Mega|Fly|Ride"] = 570.94}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 234.93, ["Fly"] = 301.46, ["Ride"] = 295.32, ["Fly|Ride"] = 376.69, ["Neon"] = 851.82, ["Neon|Ride"] = 759.94, ["Neon|Fly|Ride"] = 874.13, ["Mega|Fly|Ride"] = 3601.5}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 15.64}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 115.45, ["Ride"] = 168.9, ["Fly|Ride"] = 292.8, ["Neon"] = 696.35, ["Neon|Fly"] = 610.32, ["Neon|Ride"] = 720.57, ["Neon|Fly|Ride"] = 746.82, ["Mega"] = 2809.03, ["Mega|Ride"] = 2611.28, ["Mega|Fly|Ride"] = 2388.75}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 125.89, ["Fly"] = 148.38, ["Ride"] = 131.15, ["Fly|Ride"] = 262.5, ["Neon"] = 1040.76, ["Neon|Ride"] = 1032.94, ["Neon|Fly|Ride"] = 931.88, ["Mega|Fly|Ride"] = 2193.61}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 6.13, ["Ride"] = 22.01, ["Fly|Ride"] = 729.75, ["Neon"] = 32.72, ["Neon|Ride"] = 69.62, ["Neon|Fly|Ride"] = 287.95, ["Mega"] = 168.92, ["Mega|Ride"] = 230.9, ["Mega|Fly|Ride"] = 385.75}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 16.04, ["Fly"] = 50.93, ["Ride"] = 30.19, ["Fly|Ride"] = 69.57, ["Neon"] = 110.25, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 236.25, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 16.94, ["Fly"] = 102.36, ["Ride"] = 36.75, ["Fly|Ride"] = 131.25, ["Neon"] = 85.31, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 293.45, ["Mega"] = 498.75, ["Mega|Ride"] = 457.2, ["Mega|Fly|Ride"] = 492.19}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 4.9, ["Fly"] = 141.05, ["Ride"] = 55.12, ["Fly|Ride"] = 157.5, ["Neon"] = 32.81, ["Neon|Ride"] = 65.3, ["Neon|Fly|Ride"] = 161.44, ["Mega"] = 174.55, ["Mega|Ride"] = 173.25, ["Mega|Fly|Ride"] = 393.24}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 293.2, ["Ride"] = 324.19, ["Fly|Ride"] = 367.49, ["Neon"] = 1450.68, ["Neon|Ride"] = 1427.5, ["Neon|Fly|Ride"] = 1409.82, ["Mega|Ride"] = 5129.03, ["Mega|Fly|Ride"] = 6785.22}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 91.76, ["Fly"] = 586.88, ["Ride"] = 124.69, ["Fly|Ride"] = 235.83, ["Neon"] = 435.29, ["Neon|Ride"] = 645.12, ["Neon|Fly|Ride"] = 514.4, ["Mega"] = 2022.57, ["Mega|Ride"] = 2088.11, ["Mega|Fly|Ride"] = 2086.88}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 69.57, ["Fly"] = 167.45, ["Ride"] = 78.45, ["Fly|Ride"] = 124.64, ["Neon"] = 262.5, ["Neon|Ride"] = 341.23, ["Neon|Fly|Ride"] = 263.78, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1374.18}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 23.54, ["Fly"] = 127.32, ["Ride"] = 54.96, ["Neon|Ride"] = 631.84, ["Neon|Fly|Ride"] = 332.03, ["Mega|Fly|Ride"] = 1026.48}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 14.83, ["Ride"] = 32.78, ["Fly|Ride"] = 70.74, ["Neon"] = 87.94, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 807.19, ["Mega|Ride"] = 532.22, ["Mega|Fly|Ride"] = 626.45}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.93, ["Fly"] = 52.5, ["Ride"] = 25.3, ["Fly|Ride"] = 68.25, ["Neon"] = 26.25, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 293.45, ["Mega|Ride"] = 163.19, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 853.02, ["Fly"] = 918.75, ["Ride"] = 997.5, ["Fly|Ride"] = 964.67, ["Neon"] = 4396, ["Neon|Ride"] = 8791.99, ["Neon|Fly|Ride"] = 2428.13, ["Mega|Fly|Ride"] = 8098.23}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 245.63, ["Fly"] = 355, ["Ride"] = 295.32, ["Fly|Ride"] = 328.31, ["Neon"] = 1318.82, ["Neon|Ride"] = 1270.5, ["Neon|Fly|Ride"] = 1207.81, ["Mega"] = 10989.98, ["Mega|Fly|Ride"] = 5446.65}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 101, ["Fly"] = 128.87, ["Ride"] = 124.64, ["Fly|Ride"] = 167.07, ["Neon"] = 426.57, ["Neon|Ride"] = 428.79, ["Neon|Fly|Ride"] = 545.12, ["Mega"] = 1575, ["Mega|Ride"] = 1788.09, ["Mega|Fly|Ride"] = 1907.48}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 209.9, ["Fly"] = 283.56, ["Ride"] = 208.69, ["Fly|Ride"] = 240.28, ["Neon"] = 1048.69, ["Neon|Ride"] = 1161.42, ["Neon|Fly|Ride"] = 1095.94, ["Mega"] = 10989.98, ["Mega|Fly|Ride"] = 4146.94}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 20.48, ["Fly"] = 52.5, ["Ride"] = 31.26, ["Fly|Ride"] = 80.56, ["Neon"] = 105, ["Neon|Ride"] = 145.09, ["Neon|Fly|Ride"] = 229.23, ["Mega|Fly|Ride"] = 1099.02}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 210, ["Ride"] = 327.12, ["Fly|Ride"] = 397.91, ["Neon"] = 1082.48, ["Neon|Ride"] = 942.38, ["Neon|Fly|Ride"] = 1317.72, ["Mega"] = 4283.9, ["Mega|Fly|Ride"] = 4973.84}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 97.89, ["Ride"] = 98.51, ["Fly|Ride"] = 131.22, ["Neon|Ride"] = 1659.17, ["Neon|Fly|Ride"] = 498.75, ["Mega|Ride"] = 2345.27, ["Mega|Fly|Ride"] = 1821.75}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 2361.19, ["Ride"] = 2377.75, ["Fly|Ride"] = 2887.5, ["Neon|Ride"] = 11606.44, ["Neon|Fly|Ride"] = 7201.69, ["Mega"] = 52751.85, ["Mega|Fly|Ride"] = 31169.75}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 14.22, ["Fly"] = 118.13, ["Ride"] = 52.5, ["Fly|Ride"] = 105, ["Neon"] = 59.07, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 194.15, ["Mega"] = 296.63, ["Mega|Ride"] = 394.56, ["Mega|Fly|Ride"] = 461.68}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 47.25, ["Ride"] = 65.63, ["Fly|Ride"] = 148.32, ["Neon"] = 216.57, ["Neon|Ride"] = 242.82, ["Neon|Fly|Ride"] = 431.82, ["Mega|Ride"] = 931.87, ["Mega|Fly|Ride"] = 1497.57}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 98.14, ["Fly"] = 102.15, ["Ride"] = 85.22, ["Fly|Ride"] = 91.88, ["Neon|Ride"] = 507.75, ["Neon|Fly|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1512.03}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2818.93, ["Fly"] = 1659.17, ["Ride"] = 1073.61, ["Fly|Ride"] = 997.5, ["Neon|Ride"] = 5803.23, ["Neon|Fly|Ride"] = 3937.49, ["Mega"] = 43959.87, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 459.38, ["Fly"] = 877.02, ["Ride"] = 548.42, ["Fly|Ride"] = 821.63, ["Neon|Fly|Ride"] = 2636.51, ["Mega"] = 11539.48}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 70.7, ["Fly"] = 147.28, ["Ride"] = 126, ["Fly|Ride"] = 196.73, ["Neon"] = 477.43, ["Neon|Ride"] = 349.46, ["Neon|Fly|Ride"] = 497.4, ["Mega"] = 5862.06, ["Mega|Ride"] = 2653.55, ["Mega|Fly|Ride"] = 1761.38}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.38, ["Fly"] = 42.31, ["Ride"] = 25.96, ["Fly|Ride"] = 83.16, ["Neon"] = 77.97, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 187.69, ["Mega"] = 656.25, ["Mega|Ride"] = 823.93}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 45.05, ["Fly"] = 62.66, ["Ride"] = 38.68, ["Fly|Ride"] = 91.88, ["Neon"] = 212.97, ["Neon|Ride"] = 285.75, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 731.11, ["Fly"] = 1144.27, ["Ride"] = 787.5, ["Fly|Ride"] = 820.98, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2230.99, ["Mega|Fly|Ride"] = 8531.25}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 727.79}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 5381.25, ["Ride"] = 5250, ["Fly|Ride"] = 5184.38, ["Neon"] = 19687.5, ["Neon|Ride"] = 31498.35, ["Neon|Fly|Ride"] = 27565.13, ["Mega|Fly|Ride"] = 84989.81}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 257.25, ["Fly"] = 494.81, ["Ride"] = 324.22, ["Fly|Ride"] = 432.74, ["Neon"] = 1758.41, ["Neon|Fly|Ride"] = 2198.01, ["Mega"] = 6592.9, ["Mega|Fly|Ride"] = 6593.99}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 108.66, ["Ride"] = 157.4, ["Fly|Ride"] = 190.32, ["Neon"] = 2198.01, ["Neon|Ride"] = 658.31, ["Neon|Fly|Ride"] = 470.39}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 35.44, ["Fly"] = 102.37, ["Ride"] = 39.19, ["Fly|Ride"] = 107.66, ["Neon"] = 169.26, ["Neon|Ride"] = 174.09, ["Neon|Fly|Ride"] = 245.44, ["Mega|Ride"] = 829.41, ["Mega|Fly|Ride"] = 800.63}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 13.99, ["Fly"] = 32.82, ["Ride"] = 26.81, ["Fly|Ride"] = 51.24, ["Neon"] = 147.28, ["Neon|Fly"] = 293.45, ["Neon|Ride"] = 131.9, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 1312.5, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 2931.04}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 16.63, ["Fly"] = 165.97, ["Ride"] = 38.04, ["Fly|Ride"] = 110.25, ["Neon"] = 111.57, ["Neon|Ride"] = 123.38, ["Neon|Fly|Ride"] = 183.74, ["Mega"] = 645.91, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 664.02}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 4.91, ["Fly"] = 37.38, ["Ride"] = 20.91, ["Fly|Ride"] = 57.46, ["Neon"] = 36.39, ["Neon|Fly"] = 362.69, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 139.58, ["Mega"] = 675, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 23.63, ["Ride"] = 51.18, ["Fly|Ride"] = 147, ["Neon"] = 115.5, ["Neon|Fly"] = 879.21, ["Neon|Ride"] = 188.28, ["Neon|Fly|Ride"] = 328.62, ["Mega"] = 630, ["Mega|Ride"] = 777.02, ["Mega|Fly|Ride"] = 532.88}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 630, ["Fly"] = 762.57, ["Ride"] = 577.5, ["Fly|Ride"] = 787.5, ["Neon"] = 2214.5, ["Neon|Ride"] = 2231.25, ["Neon|Fly|Ride"] = 2231.25, ["Mega"] = 8531.25, ["Mega|Fly|Ride"] = 10988.87}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.94, ["Fly"] = 19.69, ["Ride"] = 14.43, ["Fly|Ride"] = 36.75, ["Neon"] = 22.32, ["Neon|Ride"] = 38.59, ["Neon|Fly|Ride"] = 74.81, ["Mega"] = 170.63, ["Mega|Ride"] = 616.35, ["Mega|Fly|Ride"] = 208.69}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 44.54, ["Fly"] = 78.75, ["Ride"] = 83.73, ["Fly|Ride"] = 167.07, ["Neon"] = 203.44, ["Neon|Fly"] = 430.71, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 258.57, ["Mega"] = 523.69, ["Mega|Fly"] = 879.21, ["Mega|Ride"] = 633.94, ["Mega|Fly|Ride"] = 577.23}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 839.99, ["Ride"] = 824.24, ["Fly|Ride"] = 826.87, ["Neon|Ride"] = 2784.87, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 5162.84}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 41.99, ["Fly"] = 70.86, ["Ride"] = 47.24, ["Fly|Ride"] = 78.75, ["Neon"] = 249.38, ["Neon|Ride"] = 223.02, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 1243.47, ["Mega|Fly|Ride"] = 885.92}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 315.13, ["Fly"] = 318.13, ["Ride"] = 321.57, ["Fly|Ride"] = 341.21, ["Neon|Fly|Ride"] = 1291.5}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 249.37, ["Fly"] = 580.85, ["Ride"] = 280.88, ["Fly|Ride"] = 406.88, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 5118.75, ["Mega|Fly|Ride"] = 5391.69}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 777.79, ["Ride"] = 737.63, ["Fly|Ride"] = 721.87, ["Neon|Ride"] = 3810.24, ["Neon|Fly|Ride"] = 2493.74, ["Mega|Fly|Ride"] = 9842.44}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 19.69, ["Fly"] = 87.94, ["Ride"] = 50.59, ["Fly|Ride"] = 107.47, ["Neon"] = 61.69, ["Neon|Fly"] = 298.45, ["Neon|Ride"] = 113.16, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 354.38, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 431.5}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3622.49, ["Fly"] = 3543.75, ["Ride"] = 3399.38, ["Fly|Ride"] = 3412.5, ["Neon|Fly|Ride"] = 8027.25, ["Mega|Fly|Ride"] = 19686.19}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 127.32, ["Fly"] = 178.49, ["Ride"] = 149.63, ["Fly|Ride"] = 197.95, ["Neon"] = 535.5, ["Neon|Ride"] = 544.02, ["Neon|Fly|Ride"] = 584.07, ["Mega|Fly|Ride"] = 3488.24}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.57, ["Fly"] = 44.8, ["Ride"] = 19.81, ["Fly|Ride"] = 56.43, ["Neon"] = 24.94, ["Neon|Fly"] = 43.24, ["Neon|Ride"] = 41.77, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 235.2, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 291.27, ["Mega|Fly|Ride"] = 320.25}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.64, ["Ride"] = 25.35, ["Fly|Ride"] = 73.64, ["Neon"] = 26.25, ["Neon|Fly"] = 121.87, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 218.72, ["Mega|Ride"] = 409.11, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 49.88, ["Fly"] = 39.38, ["Ride"] = 53.49, ["Fly|Ride"] = 57.28, ["Neon"] = 298.45, ["Neon|Ride"] = 417.63, ["Neon|Fly|Ride"] = 274.17, ["Mega|Fly|Ride"] = 1272.66}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 846.57, ["Fly"] = 1193.74, ["Ride"] = 987, ["Fly|Ride"] = 1105.13, ["Neon|Ride"] = 11606.44, ["Neon|Fly|Ride"] = 4543.26}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6954.94, ["Ride"] = 13267.11, ["Fly|Ride"] = 10440.49}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 26.24, ["Fly"] = 41.77, ["Ride"] = 28.85, ["Fly|Ride"] = 45.6, ["Neon"] = 175.86, ["Neon|Ride"] = 144.24, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 2520, ["Mega|Ride"] = 879.14, ["Mega|Fly|Ride"] = 811.12}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 14.41, ["Fly"] = 50.57, ["Ride"] = 32.82, ["Fly|Ride"] = 67.16, ["Neon"] = 102.27, ["Neon|Fly"] = 111.57, ["Neon|Ride"] = 92.19, ["Neon|Fly|Ride"] = 169.32, ["Mega"] = 675.63, ["Mega|Ride"] = 528.94, ["Mega|Fly|Ride"] = 501.38}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 98.33, ["Ride"] = 121.87, ["Fly|Ride"] = 143.07, ["Neon|Ride"] = 628.63, ["Neon|Fly|Ride"] = 528.94, ["Mega|Fly|Ride"] = 1573.59}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 236.18, ["Fly"] = 465.19, ["Ride"] = 249.26, ["Fly|Ride"] = 326.76, ["Neon"] = 1305.88, ["Neon|Ride"] = 934.76, ["Neon|Fly|Ride"] = 1039.4, ["Mega"] = 10989.98, ["Mega|Ride"] = 4221.31, ["Mega|Fly|Ride"] = 3127.69}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 4.65, ["Ride"] = 31.38, ["Fly|Ride"] = 65.63, ["Neon"] = 33.51, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 64.31, ["Mega"] = 170.52, ["Mega|Fly"] = 245.1, ["Mega|Ride"] = 157.77, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 195.57, ["Fly"] = 258.32, ["Ride"] = 220.43, ["Fly|Ride"] = 287.44, ["Neon"] = 654.94, ["Neon|Ride"] = 715.32, ["Neon|Fly|Ride"] = 708.75, ["Mega|Fly|Ride"] = 3077.2}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 4.59, ["Fly"] = 32.82, ["Ride"] = 17.06, ["Fly|Ride"] = 49.65, ["Neon"] = 34.55, ["Neon|Fly"] = 131.9, ["Neon|Ride"] = 35.54, ["Neon|Fly|Ride"] = 122, ["Mega"] = 425.34, ["Mega|Fly"] = 293.45, ["Mega|Ride"] = 219.19, ["Mega|Fly|Ride"] = 232.97}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 288.74, ["Fly"] = 354.38, ["Ride"] = 341.24, ["Fly|Ride"] = 347.82, ["Neon|Ride"] = 1436.25, ["Neon|Fly|Ride"] = 1246.88, ["Mega"] = 10989.98, ["Mega|Fly|Ride"] = 5637.85}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 12.01, ["Fly"] = 104.99, ["Ride"] = 31.5, ["Fly|Ride"] = 52.5, ["Neon"] = 90.55, ["Neon|Fly"] = 315.93, ["Neon|Ride"] = 147.28, ["Neon|Fly|Ride"] = 194.91, ["Mega"] = 586.88, ["Mega|Ride"] = 452.8, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Fly"] = 73.64, ["Ride"] = 25.38, ["Neon"] = 11.67, ["Neon|Fly"] = 170.46, ["Neon|Ride"] = 49.6, ["Neon|Fly|Ride"] = 129.91, ["Mega"] = 101.52, ["Mega|Ride"] = 143.2, ["Mega|Fly|Ride"] = 287.44}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Mega"] = 22.26, ["Mega|Ride"] = 158.28, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 329.72, ["Fly|Ride"] = 86.62, ["Neon"] = 6.19, ["Neon|Ride"] = 50.97, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 60.75, ["Mega|Fly"] = 191720.66, ["Mega|Ride"] = 139.58, ["Mega|Fly|Ride"] = 219.73}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 78.47, ["Fly"] = 286.13, ["Ride"] = 115.9, ["Fly|Ride"] = 183.75, ["Neon"] = 288.75, ["Neon|Ride"] = 309.23, ["Neon|Fly|Ride"] = 407.54, ["Mega|Ride"] = 1233.75, ["Mega|Fly|Ride"] = 1236.38}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 38.58, ["Ride"] = 16.41, ["Fly|Ride"] = 35.18, ["Neon"] = 5.81, ["Neon|Ride"] = 33.59, ["Neon|Fly|Ride"] = 70.56, ["Mega"] = 78.74, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 8.81, ["Neon"] = 82.29, ["Neon|Fly"] = 332.03, ["Neon|Ride"] = 314.9, ["Mega"] = 420, ["Mega|Ride"] = 586.88, ["Mega|Fly|Ride"] = 580.72}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Ride"] = 22.01, ["Neon"] = 2.1, ["Neon|Fly"] = 38.56, ["Neon|Ride"] = 59.07, ["Mega"] = 16.5, ["Mega|Fly"] = 43.98, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 256.29}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 86.43, ["Ride"] = 12.99, ["Fly|Ride"] = 196.88, ["Neon"] = 2.1, ["Neon|Fly"] = 43.98, ["Neon|Ride"] = 13.19, ["Neon|Fly|Ride"] = 41.99, ["Mega"] = 15.75, ["Mega|Fly"] = 37.68, ["Mega|Ride"] = 19, ["Mega|Fly|Ride"] = 59.17}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 25.15, ["Ride"] = 16.5, ["Fly|Ride"] = 37.84, ["Neon"] = 2.1, ["Neon|Fly"] = 26.18, ["Neon|Ride"] = 20.91, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 18.38, ["Mega|Fly"] = 166.64, ["Mega|Ride"] = 42.83, ["Mega|Fly|Ride"] = 92.96}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 3.29, ["Neon|Ride"] = 65.63, ["Mega"] = 20.74, ["Mega|Ride"] = 89.25, ["Mega|Fly|Ride"] = 248.39}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 117.94, ["Ride"] = 29.69, ["Fly|Ride"] = 52.5, ["Neon"] = 5.55, ["Neon|Fly"] = 287.96, ["Neon|Ride"] = 24.19, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 39.16, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 43.32, ["Mega|Fly|Ride"] = 95.92}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 82.98, ["Mega"] = 17.97, ["Mega|Ride"] = 99.75}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 15.65, ["Fly"] = 53.13, ["Ride"] = 37.38, ["Fly|Ride"] = 105, ["Neon"] = 59.07, ["Neon|Ride"] = 73.64, ["Neon|Fly|Ride"] = 262.62, ["Mega"] = 245.44, ["Mega|Ride"] = 287.44, ["Mega|Fly|Ride"] = 379.7}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 35.18, ["Mega"] = 28.6, ["Mega|Fly"] = 151.72, ["Mega|Ride"] = 147.28, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 52.5, ["Neon"] = 22.82, ["Mega"] = 120.64, ["Mega|Fly"] = 315, ["Mega|Ride"] = 170.63}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.57, ["Ride"] = 29.69, ["Fly|Ride"] = 43.98, ["Neon"] = 23.28, ["Mega"] = 134.95, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Fly"] = 147.28, ["Ride"] = 30.85, ["Neon"] = 2.46, ["Neon|Ride"] = 27.97, ["Neon|Fly|Ride"] = 147.28, ["Mega"] = 21.27, ["Mega|Ride"] = 39.25, ["Mega|Fly|Ride"] = 104.99}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.91, ["Ride"] = 14.47, ["Fly|Ride"] = 56.06, ["Neon"] = 2.1, ["Neon|Fly"] = 35.32, ["Neon|Ride"] = 12.91, ["Neon|Fly|Ride"] = 39.82, ["Mega"] = 14.31, ["Mega|Fly"] = 28.49, ["Mega|Ride"] = 22.3, ["Mega|Fly|Ride"] = 53.82}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 54.28, ["Fly|Ride"] = 118.12, ["Neon"] = 39.83, ["Neon|Ride"] = 142.88, ["Neon|Fly|Ride"] = 733.06, ["Mega"] = 144.38, ["Mega|Ride"] = 241.5}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 43.1, ["Neon"] = 3.72, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 28.87, ["Neon|Fly|Ride"] = 82.45, ["Mega"] = 30.24, ["Mega|Ride"] = 40.51, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.1, ["Neon"] = 10.48, ["Neon|Ride"] = 195.11, ["Mega"] = 109.05, ["Mega|Ride"] = 144.27, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 82.19, ["Ride"] = 34.53, ["Neon"] = 15.65, ["Neon|Ride"] = 51.66, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 129.94, ["Mega|Ride"] = 166.64, ["Mega|Fly|Ride"] = 196.87}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 12.11, ["Ride"] = 15.22, ["Fly|Ride"] = 38.48, ["Neon"] = 2.1, ["Neon|Fly"] = 20.91, ["Neon|Ride"] = 15.62, ["Neon|Fly|Ride"] = 42, ["Mega"] = 18.35, ["Mega|Fly"] = 28.79, ["Mega|Ride"] = 22.14, ["Mega|Fly|Ride"] = 53.36}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 44.12, ["Ride"] = 26.99, ["Fly|Ride"] = 52.5, ["Neon"] = 14.33, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 196.76, ["Mega"] = 129.68, ["Mega|Ride"] = 162.32, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 5.24, ["Fly"] = 118.13, ["Ride"] = 145.08, ["Fly|Ride"] = 93.19, ["Neon"] = 54.54, ["Neon|Ride"] = 73.64, ["Neon|Fly|Ride"] = 175.86, ["Mega"] = 288.75, ["Mega|Ride"] = 300.54, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 59.36, ["Ride"] = 14.41, ["Fly|Ride"] = 41.43, ["Neon"] = 2.1, ["Neon|Fly"] = 26.24, ["Neon|Ride"] = 13.65, ["Neon|Fly|Ride"] = 49.03, ["Mega"] = 22.01, ["Mega|Fly"] = 34.94, ["Mega|Ride"] = 39.24, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 183.54, ["Ride"] = 101.13, ["Neon"] = 5.73, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 56.77, ["Mega|Fly"] = 166.68, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 216.53}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 131.25, ["Neon"] = 4.55, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 42.35, ["Mega"] = 32.47, ["Mega|Ride"] = 116.51, ["Mega|Fly|Ride"] = 194.92}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 20.91, ["Fly|Ride"] = 48.51, ["Neon"] = 2.1, ["Neon|Ride"] = 35.25, ["Neon|Fly|Ride"] = 131.9, ["Mega"] = 16.5, ["Mega|Fly"] = 32.82, ["Mega|Ride"] = 26.24, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 24.2, ["Ride"] = 19.34, ["Fly|Ride"] = 55.42, ["Neon"] = 2.63, ["Neon|Fly"] = 58.35, ["Neon|Ride"] = 22.4, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 105.24, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 151.92}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 7.38, ["Neon|Ride"] = 57.75, ["Mega"] = 46.92, ["Mega|Fly"] = 216.38, ["Mega|Ride"] = 144.15, ["Mega|Fly|Ride"] = 208.69}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 21.69, ["Ride"] = 16.5, ["Fly|Ride"] = 40.69, ["Neon"] = 6.56, ["Neon|Fly"] = 82.45, ["Neon|Ride"] = 22.2, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 114.13, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 273.67}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 38.66, ["Neon|Fly"] = 188.88, ["Neon|Fly|Ride"] = 327.3, ["Mega"] = 105, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 659.42}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 26.02, ["Ride"] = 21.5, ["Fly|Ride"] = 51.66, ["Neon"] = 8.38, ["Neon|Fly"] = 49.76, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 66.33, ["Mega"] = 106.32, ["Mega|Fly"] = 420, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 196.43}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.6, ["Fly"] = 21, ["Ride"] = 18.41, ["Fly|Ride"] = 72.12, ["Neon"] = 19.44, ["Neon|Fly"] = 27.57, ["Neon|Ride"] = 29.69, ["Neon|Fly|Ride"] = 63.73, ["Mega"] = 165.97, ["Mega|Fly"] = 434.53, ["Mega|Ride"] = 439.61, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 3.84, ["Fly"] = 116.51, ["Fly|Ride"] = 147.28, ["Neon"] = 101.83, ["Mega"] = 259.88, ["Mega|Ride"] = 406.88}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 14.4, ["Ride"] = 124.4, ["Neon"] = 107.27, ["Neon|Ride"] = 147.28, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 750.75}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 3.94, ["Neon"] = 57.2, ["Neon|Ride"] = 147.28, ["Mega"] = 247.15, ["Mega|Ride"] = 367.5}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 5, ["Ride"] = 70.34, ["Fly|Ride"] = 120.75, ["Neon"] = 52.48, ["Neon|Ride"] = 83.95, ["Neon|Fly|Ride"] = 146.14, ["Mega"] = 234.82, ["Mega|Ride"] = 438.52, ["Mega|Fly|Ride"] = 449.54}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 42.23, ["Mega"] = 18.38, ["Mega|Fly"] = 218.72, ["Mega|Ride"] = 83.32, ["Mega|Fly|Ride"] = 256.69}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 49.88}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 6.55, ["Fly"] = 24.05, ["Ride"] = 24.7, ["Fly|Ride"] = 52.41, ["Neon"] = 45.94, ["Neon|Fly"] = 189, ["Neon|Ride"] = 62.66, ["Neon|Fly|Ride"] = 92.79, ["Mega"] = 261.19, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 265.97}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 71.06, ["Ride"] = 21, ["Neon"] = 6.62, ["Neon|Fly"] = 52.81, ["Neon|Ride"] = 24.23, ["Neon|Fly|Ride"] = 164.16, ["Mega"] = 20.79, ["Mega|Ride"] = 101.46, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.73, ["Neon|Ride"] = 32.97, ["Neon|Fly|Ride"] = 74.46, ["Mega"] = 38.56, ["Mega|Ride"] = 45.85, ["Mega|Fly|Ride"] = 174.45}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 47.07, ["Ride"] = 16.14, ["Fly|Ride"] = 47.14, ["Neon"] = 10.06, ["Neon|Ride"] = 24.1, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 164.01, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 232.54}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.29, ["Ride"] = 32.81, ["Fly|Ride"] = 261.19, ["Neon"] = 49.7, ["Neon|Ride"] = 208.15, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 105, ["Mega|Ride"] = 348.95, ["Mega|Fly|Ride"] = 293.45}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 162.68, ["Mega"] = 20.78, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 56.32, ["Mega|Fly|Ride"] = 351.69}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 28, ["Ride"] = 21.86, ["Fly|Ride"] = 92.33, ["Neon"] = 2.43, ["Neon|Fly"] = 115.05, ["Neon|Ride"] = 20.87, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 40.11, ["Mega|Fly"] = 147.28, ["Mega|Ride"] = 54.38, ["Mega|Fly|Ride"] = 124.05}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 20.58, ["Ride"] = 18.33, ["Fly|Ride"] = 53.69, ["Neon"] = 4.87, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 21.86, ["Neon|Fly|Ride"] = 62.91, ["Mega"] = 117.6, ["Mega|Fly"] = 147.28, ["Mega|Ride"] = 124.4, ["Mega|Fly|Ride"] = 132.62}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.51, ["Fly"] = 91.88, ["Ride"] = 178.5, ["Fly|Ride"] = 131.25, ["Neon"] = 24.94, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 105, ["Mega|Ride"] = 174.14, ["Mega|Fly|Ride"] = 207.38}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.49, ["Neon|Ride"] = 107.58, ["Neon|Fly|Ride"] = 160193.98, ["Mega"] = 18.51, ["Mega|Fly"] = 105.52, ["Mega|Ride"] = 44.91, ["Mega|Fly|Ride"] = 152.25}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 20.79, ["Neon"] = 2.1, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 24.76, ["Neon|Fly|Ride"] = 67.69, ["Mega"] = 24.78, ["Mega|Fly"] = 72.07, ["Mega|Ride"] = 42.75, ["Mega|Fly|Ride"] = 112.88}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 16.5, ["Neon"] = 2.51, ["Neon|Fly"] = 67.16, ["Mega"] = 36.75, ["Mega|Ride"] = 190.32}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.48, ["Neon"] = 6.18, ["Neon|Fly|Ride"] = 420, ["Mega"] = 27.57, ["Mega|Ride"] = 292.69, ["Mega|Fly|Ride"] = 166.64}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.23, ["Ride"] = 16.54, ["Fly|Ride"] = 69.44, ["Neon"] = 3.67, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 21.94, ["Neon|Fly|Ride"] = 35.44, ["Mega"] = 32.05, ["Mega|Ride"] = 44.63, ["Mega|Fly|Ride"] = 111.56}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 5.14, ["Ride"] = 78.75, ["Neon"] = 87.94, ["Neon|Ride"] = 78.75, ["Mega"] = 389.82, ["Mega|Ride"] = 475.13, ["Mega|Fly|Ride"] = 615.45}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Ride"] = 53.81, ["Neon"] = 26.25, ["Neon|Ride"] = 157.5, ["Mega"] = 248.71, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.16, ["Ride"] = 33.47, ["Fly|Ride"] = 131.25, ["Neon"] = 25.74, ["Neon|Ride"] = 147.28, ["Neon|Fly|Ride"] = 116.89, ["Mega"] = 312.11, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 12.73, ["Fly|Ride"] = 26.22, ["Neon"] = 2.1, ["Neon|Fly"] = 14.21, ["Neon|Ride"] = 12.9, ["Neon|Fly|Ride"] = 30.17, ["Mega"] = 16.15, ["Mega|Fly"] = 101.88, ["Mega|Ride"] = 27.57, ["Mega|Fly|Ride"] = 107.67}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Ride"] = 61.56, ["Neon"] = 9.98, ["Neon|Fly"] = 73.64, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 733.06, ["Mega"] = 131.9, ["Mega|Ride"] = 118.13}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.5, ["Neon"] = 2.1, ["Neon|Fly"] = 32.36, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 86.67, ["Mega"] = 15.75, ["Mega|Fly"] = 147.28, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 5.15, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 129.22, ["Mega"] = 31.25, ["Mega|Fly|Ride"] = 367.49}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 147.28, ["Ride"] = 26.24, ["Fly|Ride"] = 48.09, ["Neon"] = 13.13, ["Neon|Fly"] = 59.05, ["Neon|Ride"] = 32.99, ["Neon|Fly|Ride"] = 75.29, ["Mega"] = 208.85, ["Mega|Ride"] = 191.24, ["Mega|Fly|Ride"] = 275.6}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 221.03, ["Ride"] = 240.19, ["Fly|Ride"] = 879.11, ["Neon|Ride"] = 693, ["Neon|Fly|Ride"] = 945.05, ["Mega"] = 8791.99, ["Mega|Fly|Ride"] = 3576.16}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Neon|Ride"] = 64.32, ["Mega"] = 68.25, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 664.18}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.92, ["Fly"] = 103.69, ["Ride"] = 37.38, ["Fly|Ride"] = 65.63, ["Neon"] = 24.2, ["Neon|Ride"] = 135.18, ["Neon|Fly|Ride"] = 175.86, ["Mega"] = 393.75, ["Mega|Ride"] = 328.62, ["Mega|Fly|Ride"] = 388.16}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 19.66, ["Ride"] = 14.43, ["Fly|Ride"] = 36.75, ["Neon"] = 5.81, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 26.91, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 46.72, ["Mega|Ride"] = 103.32, ["Mega|Fly|Ride"] = 147.99}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 73.05, ["Ride"] = 19.69, ["Fly|Ride"] = 142.62, ["Neon"] = 11.01, ["Neon|Fly"] = 147.28, ["Neon|Ride"] = 72.34, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 87.94, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 2.1, ["Fly"] = 27.4, ["Ride"] = 16.96, ["Fly|Ride"] = 39.38, ["Neon"] = 32.82, ["Neon|Fly"] = 101.25, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 144.38, ["Mega|Ride"] = 977.02, ["Mega|Fly|Ride"] = 285.75}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 2.43, ["Ride"] = 19.69, ["Fly|Ride"] = 259.91, ["Neon"] = 79.61, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 193.75, ["Mega|Ride"] = 329.72, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 3.01, ["Fly"] = 27.45, ["Ride"] = 16.46, ["Fly|Ride"] = 36.66, ["Neon"] = 41.9, ["Neon|Fly"] = 129.1, ["Neon|Ride"] = 36.6, ["Neon|Fly|Ride"] = 78.56, ["Mega"] = 258.25, ["Mega|Ride"] = 381.36, ["Mega|Fly|Ride"] = 282.52}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 85.32, ["Ride"] = 86.57, ["Fly|Ride"] = 159.51, ["Neon"] = 346.28, ["Neon|Fly"] = 450.19, ["Neon|Ride"] = 390.65, ["Neon|Fly|Ride"] = 371.94, ["Mega"] = 2052.94, ["Mega|Ride"] = 1905.67, ["Mega|Fly|Ride"] = 1468.69}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 225.75, ["Fly"] = 439.61, ["Ride"] = 220.5, ["Fly|Ride"] = 337.32, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1296.49, ["Mega"] = 13187.97, ["Mega|Fly|Ride"] = 3590.44}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 57.75, ["Fly"] = 109.92, ["Ride"] = 68.65, ["Fly|Ride"] = 105, ["Neon"] = 493.2, ["Neon|Fly"] = 372.59, ["Neon|Ride"] = 311.07, ["Neon|Fly|Ride"] = 317.63, ["Mega"] = 1466.07, ["Mega|Fly|Ride"] = 1220.63}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 3.59, ["Fly"] = 288.42, ["Ride"] = 25.08, ["Fly|Ride"] = 65.61, ["Neon"] = 25.89, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 149.63, ["Mega"] = 238.88, ["Mega|Ride"] = 196.75, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 12.98, ["Fly"] = 63, ["Ride"] = 31.62, ["Fly|Ride"] = 65.63, ["Neon"] = 65.63, ["Neon|Ride"] = 103.32, ["Neon|Fly|Ride"] = 144.79, ["Mega"] = 314.9, ["Mega|Ride"] = 364.88, ["Mega|Fly|Ride"] = 379.19}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 39.29, ["Ride"] = 17.61, ["Fly|Ride"] = 54.73, ["Neon"] = 3.83, ["Neon|Fly"] = 57.44, ["Neon|Ride"] = 24.05, ["Neon|Fly|Ride"] = 51.7, ["Mega"] = 56.11, ["Mega|Fly"] = 151.76, ["Mega|Ride"] = 86.63, ["Mega|Fly|Ride"] = 565.79}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 15.75, ["Fly"] = 70.34, ["Ride"] = 34.12, ["Fly|Ride"] = 67.16, ["Neon"] = 78.74, ["Neon|Fly"] = 293.45, ["Neon|Ride"] = 117.6, ["Neon|Fly|Ride"] = 327.16, ["Mega"] = 557.21, ["Mega|Ride"] = 659.42, ["Mega|Fly|Ride"] = 544.02}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.99, ["Ride"] = 19.57, ["Fly|Ride"] = 45.84, ["Neon"] = 18.37, ["Neon|Fly"] = 52.77, ["Neon|Ride"] = 24, ["Neon|Fly|Ride"] = 92.04, ["Mega"] = 144.24, ["Mega|Ride"] = 183.65, ["Mega|Fly|Ride"] = 297.55}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.56, ["Ride"] = 21.62, ["Fly|Ride"] = 328.13, ["Neon"] = 39.41, ["Neon|Ride"] = 117.6, ["Neon|Fly|Ride"] = 147.28, ["Mega"] = 207.37, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 337.84}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 27.68, ["Ride"] = 19.39, ["Neon"] = 2.1, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 14.7, ["Mega|Fly"] = 38.07, ["Mega|Ride"] = 42.3, ["Mega|Fly|Ride"] = 72.19}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.29, ["Ride"] = 19.14, ["Fly|Ride"] = 44.63, ["Neon"] = 11.82, ["Neon|Fly"] = 109.92, ["Neon|Ride"] = 37.32, ["Neon|Fly|Ride"] = 147, ["Mega"] = 78.72, ["Mega|Ride"] = 152.25, ["Mega|Fly|Ride"] = 217.62}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 64.32, ["Ride"] = 22.29, ["Fly|Ride"] = 83.82, ["Neon"] = 21.67, ["Neon|Ride"] = 42, ["Mega"] = 144.37, ["Mega|Ride"] = 166.64, ["Mega|Fly|Ride"] = 272.56}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 108.94, ["Fly"] = 168.27, ["Ride"] = 161.16, ["Fly|Ride"] = 196.88, ["Neon"] = 430.39, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 511.88, ["Mega"] = 2487.53, ["Mega|Fly|Ride"] = 1975.32}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 5.62, ["Ride"] = 240.93, ["Fly|Ride"] = 131.25, ["Neon"] = 49.49, ["Neon|Ride"] = 89.25, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 280.61, ["Mega|Ride"] = 276.34, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 44.35, ["Ride"] = 20.99, ["Fly|Ride"] = 43.04, ["Neon"] = 22.13, ["Neon|Ride"] = 62.99, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 276.96, ["Mega|Ride"] = 187.8, ["Mega|Fly|Ride"] = 328.12}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 20.79, ["Ride"] = 39.38, ["Fly|Ride"] = 170.63, ["Neon"] = 99.73, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly"] = 879.21, ["Mega|Ride"] = 496.13, ["Mega|Fly|Ride"] = 1099.02}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 6.45}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 15.74, ["Fly"] = 21, ["Ride"] = 72.19, ["Fly|Ride"] = 130.79, ["Neon"] = 71.54, ["Neon|Ride"] = 108.84, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 624.75, ["Mega|Ride"] = 644.03, ["Mega|Fly|Ride"] = 879.21}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 19.67, ["Fly"] = 32.82, ["Ride"] = 30.17, ["Fly|Ride"] = 56.16, ["Neon"] = 413.25, ["Neon|Fly"] = 131.9, ["Neon|Ride"] = 91.25, ["Neon|Fly|Ride"] = 150.92, ["Mega"] = 1418.82, ["Mega|Fly|Ride"] = 545.73}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 35.43, ["Neon"] = 4.89, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 144.24, ["Mega"] = 26.24, ["Mega|Fly"] = 191.24, ["Mega|Ride"] = 83.35}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 3.84, ["Fly"] = 26.23, ["Ride"] = 21.25, ["Fly|Ride"] = 65.63, ["Neon"] = 65.96, ["Mega"] = 288.62, ["Mega|Fly"] = 415.33, ["Mega|Ride"] = 275.63}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 28.96, ["Ride"] = 19.49, ["Fly|Ride"] = 41.46, ["Neon"] = 17.98, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 30.85, ["Neon|Fly|Ride"] = 70.63, ["Mega"] = 223.9, ["Mega|Ride"] = 160.12, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 3.72, ["Neon|Ride"] = 42, ["Mega"] = 129.69, ["Mega|Ride"] = 117.6, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 27.3, ["Fly"] = 72.19, ["Ride"] = 64.32, ["Fly|Ride"] = 140.6, ["Neon"] = 185.07, ["Neon|Ride"] = 270.29, ["Neon|Fly|Ride"] = 576.19, ["Mega"] = 985.37, ["Mega|Ride"] = 682.16, ["Mega|Fly|Ride"] = 766.74}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.29, ["Ride"] = 48.57, ["Fly|Ride"] = 121.87, ["Neon"] = 43.98, ["Neon|Ride"] = 193.44, ["Neon|Fly|Ride"] = 183.75, ["Mega|Ride"] = 332.03}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 2.1, ["Fly"] = 23.78, ["Ride"] = 22.03, ["Fly|Ride"] = 57.52, ["Neon"] = 12.56, ["Neon|Fly"] = 87.94, ["Neon|Ride"] = 38.56, ["Neon|Fly|Ride"] = 119.51, ["Mega"] = 167.99, ["Mega|Fly|Ride"] = 278.58}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 81.35, ["Fly"] = 145.01, ["Ride"] = 129.69, ["Neon"] = 439.61, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 540.28, ["Mega"] = 4644.33, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 2486.93}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 9.09, ["Fly"] = 47.58, ["Ride"] = 22.96, ["Fly|Ride"] = 58.47, ["Neon"] = 39.44, ["Neon|Ride"] = 48.85, ["Neon|Fly|Ride"] = 114.18, ["Mega"] = 262.4, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 380.26}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 77.96, ["Fly"] = 143.07, ["Ride"] = 124.67, ["Fly|Ride"] = 215.02, ["Neon"] = 262.4, ["Neon|Ride"] = 267.1, ["Neon|Fly|Ride"] = 391.81, ["Mega"] = 1837.5, ["Mega|Ride"] = 1648.52, ["Mega|Fly|Ride"] = 1228.5}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 20.21, ["Ride"] = 61.69, ["Fly|Ride"] = 164.07, ["Neon"] = 97.13, ["Neon|Ride"] = 115.76, ["Neon|Fly|Ride"] = 249.5, ["Mega"] = 353.06, ["Mega|Ride"] = 340.32, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 4.77, ["Fly"] = 39.38, ["Ride"] = 26.4, ["Fly|Ride"] = 72.43, ["Neon"] = 91.88, ["Neon|Fly|Ride"] = 141.91, ["Mega"] = 664.02, ["Mega|Ride"] = 584.68, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 19.55, ["Ride"] = 65.63, ["Fly|Ride"] = 204.23, ["Neon"] = 77.32, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 282.19, ["Mega"] = 473.59, ["Mega|Ride"] = 387.19, ["Mega|Fly|Ride"] = 432.91}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 8.63, ["Ride"] = 34.12, ["Fly|Ride"] = 81.05, ["Neon"] = 43.98, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 249.38, ["Mega|Ride"] = 346.5, ["Mega|Fly|Ride"] = 447.3}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 59.36, ["Neon|Ride"] = 131.25, ["Mega"] = 20.76, ["Mega|Ride"] = 147.28}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 13.11, ["Ride"] = 143.06, ["Fly|Ride"] = 325.9, ["Neon"] = 52.48, ["Neon|Ride"] = 243.99, ["Mega"] = 223.88, ["Mega|Ride"] = 307.73, ["Mega|Fly|Ride"] = 1049.55}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 130.79, ["Ride"] = 29.69, ["Neon"] = 26.23, ["Neon|Fly"] = 116.94, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 253.98, ["Mega|Ride"] = 428.63, ["Mega|Fly|Ride"] = 1161.42}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 6.2, ["Ride"] = 32.81, ["Neon"] = 16.46, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 187.69, ["Mega|Ride"] = 293.45, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 538.13, ["Ride"] = 584.07, ["Fly|Ride"] = 590.63, ["Neon|Ride"] = 1771.88, ["Neon|Fly|Ride"] = 1643.51, ["Mega|Fly|Ride"] = 4830}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 6.48, ["Fly"] = 45.47, ["Ride"] = 23.29, ["Fly|Ride"] = 65.63, ["Neon"] = 37.38, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 205.52, ["Mega|Ride"] = 381.76, ["Mega|Fly|Ride"] = 367.07}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 7.77, ["Fly"] = 66.85, ["Ride"] = 20.37, ["Fly|Ride"] = 54.66, ["Neon"] = 95.25, ["Neon|Fly"] = 315, ["Neon|Ride"] = 65.43, ["Neon|Fly|Ride"] = 105, ["Mega"] = 331.88, ["Mega|Ride"] = 258.51, ["Mega|Fly|Ride"] = 456.09}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.1, ["Fly"] = 24.93, ["Ride"] = 28.6, ["Fly|Ride"] = 50.99, ["Neon"] = 16.5, ["Neon|Ride"] = 32.3, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 198.19, ["Mega|Ride"] = 263.78, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 58.08, ["Ride"] = 27.57, ["Fly|Ride"] = 90.57, ["Neon"] = 12.24, ["Neon|Ride"] = 35.43, ["Neon|Fly|Ride"] = 104.81, ["Mega"] = 73.49, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 29.69, ["Ride"] = 24.61, ["Fly|Ride"] = 52.5, ["Neon"] = 3.73, ["Neon|Ride"] = 32.33, ["Neon|Fly|Ride"] = 104.98, ["Mega"] = 21, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 126}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1376.82}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 10.28, ["Ride"] = 28.75, ["Fly|Ride"] = 118.13, ["Neon"] = 47.25, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 366.83, ["Mega"] = 370.59, ["Mega|Ride"] = 422.79, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 19.26, ["Neon"] = 8.81, ["Neon|Ride"] = 55.31, ["Neon|Fly|Ride"] = 1026.48, ["Mega"] = 73.64, ["Mega|Ride"] = 87.94, ["Mega|Fly|Ride"] = 183.74}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 16.14, ["Fly"] = 335.14, ["Ride"] = 99.25, ["Fly|Ride"] = 147.28, ["Neon"] = 68.16, ["Neon|Ride"] = 111.93, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 315, ["Mega|Ride"] = 395.66, ["Mega|Fly|Ride"] = 496.16}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 420, ["Fly"] = 539.67, ["Ride"] = 459.37, ["Fly|Ride"] = 535.5, ["Neon"] = 1715.99, ["Neon|Ride"] = 1733.4, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 8242.49, ["Mega|Fly|Ride"] = 6357.75}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 6.48, ["Fly"] = 196.88, ["Neon"] = 70.34, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 198.97, ["Mega"] = 359.39, ["Mega|Ride"] = 362.77, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Ride"] = 32.81, ["Fly|Ride"] = 118.11, ["Neon"] = 3.76, ["Neon|Ride"] = 31.41, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 36.75, ["Mega|Fly"] = 117.6, ["Mega|Ride"] = 72.89, ["Mega|Fly|Ride"] = 5494.99}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Fly|Ride"] = 99.75, ["Neon"] = 3.82, ["Neon|Ride"] = 147.28, ["Mega"] = 30.19, ["Mega|Ride"] = 129.05, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 35.47, ["Fly"] = 115.64, ["Ride"] = 109.01, ["Neon"] = 393.75, ["Neon|Ride"] = 438.52, ["Neon|Fly|Ride"] = 590.63, ["Mega"] = 703.38, ["Mega|Ride"] = 718.76, ["Mega|Fly|Ride"] = 822.5}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 9.48, ["Neon"] = 104.43, ["Neon|Ride"] = 275.86, ["Neon|Fly|Ride"] = 879.21, ["Mega"] = 580.72, ["Mega|Ride"] = 483, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 3.65, ["Ride"] = 31.29, ["Neon"] = 101.19, ["Neon|Ride"] = 175.86, ["Mega"] = 680.18, ["Mega|Ride"] = 650.63, ["Mega|Fly|Ride"] = 1212.86}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 19.48, ["Ride"] = 56.36, ["Fly|Ride"] = 236.25, ["Neon"] = 131.25, ["Neon|Ride"] = 177.51, ["Neon|Fly|Ride"] = 241.5, ["Mega"] = 725.36, ["Mega|Ride"] = 1758.41, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 367.5, ["Ride"] = 393.74, ["Fly|Ride"] = 747.33, ["Neon"] = 918.75, ["Neon|Ride"] = 1502.36, ["Neon|Fly|Ride"] = 1287, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 13.12, ["Ride"] = 60.27, ["Fly|Ride"] = 159.63, ["Neon"] = 85.3, ["Neon|Ride"] = 197.85, ["Neon|Fly|Ride"] = 147.28, ["Mega|Ride"] = 547.98, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 2.35, ["Ride"] = 27.72, ["Neon"] = 104.99, ["Neon|Ride"] = 105, ["Mega"] = 170.63, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 58.48, ["Ride"] = 105, ["Neon"] = 183.75, ["Neon|Ride"] = 186.38, ["Neon|Fly|Ride"] = 532.86, ["Mega"] = 415.33, ["Mega|Ride"] = 511.5, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.58, ["Fly|Ride"] = 219.81, ["Neon"] = 7.88, ["Neon|Fly"] = 86.45, ["Neon|Ride"] = 57.74, ["Neon|Fly|Ride"] = 284.65, ["Mega"] = 43.7, ["Mega|Ride"] = 169.26, ["Mega|Fly|Ride"] = 288.48}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 47.07, ["Ride"] = 58.97, ["Fly|Ride"] = 216.38, ["Neon"] = 262.47, ["Neon|Ride"] = 359.63, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1593.56, ["Mega|Ride"] = 1152.41, ["Mega|Fly|Ride"] = 1420.74}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.15, ["Fly"] = 108.82, ["Ride"] = 24.2, ["Neon"] = 13.5, ["Neon|Fly"] = 191.24, ["Neon|Ride"] = 70.26, ["Neon|Fly|Ride"] = 144.24, ["Mega"] = 68.25, ["Mega|Ride"] = 101.07, ["Mega|Fly|Ride"] = 143.98}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Ride"] = 54.48, ["Fly|Ride"] = 109.92, ["Neon"] = 3.19, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 144.79, ["Mega"] = 39.38, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 293.45}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 133.06, ["Neon"] = 14.18, ["Neon|Ride"] = 56.67, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 95.43, ["Mega|Ride"] = 145.09, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 68.15, ["Fly"] = 105, ["Ride"] = 78.71, ["Fly|Ride"] = 133.06, ["Neon"] = 367.5, ["Neon|Ride"] = 362.92, ["Neon|Fly|Ride"] = 497.4, ["Mega|Ride"] = 1150.66, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 5.24, ["Ride"] = 36.08, ["Neon"] = 21.68, ["Neon|Fly"] = 350.44, ["Mega"] = 72.19, ["Mega|Fly"] = 293.45, ["Mega|Ride"] = 215.25, ["Mega|Fly|Ride"] = 348.53}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 73.64, ["Ride"] = 26.56, ["Fly|Ride"] = 72.45, ["Neon"] = 9.18, ["Neon|Ride"] = 78.75, ["Mega"] = 62.41, ["Mega|Fly"] = 210, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 196.77}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.93, ["Fly"] = 109.92, ["Ride"] = 32.82, ["Fly|Ride"] = 103.69, ["Neon"] = 36.75, ["Neon|Fly|Ride"] = 166.64, ["Mega"] = 332.1, ["Mega|Ride"] = 355.11, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 7.76, ["Fly"] = 56.44, ["Ride"] = 47.25, ["Fly|Ride"] = 114.19, ["Neon"] = 37.27, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 104.99, ["Mega"] = 182.44, ["Mega|Ride"] = 235.62, ["Mega|Fly|Ride"] = 527.54}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 71.61, ["Neon"] = 6.04, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 218.72, ["Mega"] = 32.48, ["Mega|Ride"] = 141.74, ["Mega|Fly|Ride"] = 166.64}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.45, ["Fly|Ride"] = 62.86, ["Neon"] = 3.94, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 25.75, ["Neon|Fly|Ride"] = 103.49, ["Mega"] = 41.99, ["Mega|Ride"] = 106.96, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 20.79, ["Ride"] = 23.55, ["Fly|Ride"] = 57.74, ["Neon"] = 18.11, ["Neon|Fly"] = 104.43, ["Neon|Ride"] = 41.43, ["Neon|Fly|Ride"] = 117.6, ["Mega|Ride"] = 166.69, ["Mega|Fly|Ride"] = 282.72}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 26.12, ["Fly"] = 73.64, ["Ride"] = 29.08, ["Fly|Ride"] = 91.24, ["Neon"] = 144.37, ["Neon|Ride"] = 248.71, ["Neon|Fly|Ride"] = 285.75, ["Mega"] = 485.63, ["Mega|Ride"] = 538.13, ["Mega|Fly|Ride"] = 664.02}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 65.63, ["Ride"] = 97.13, ["Fly|Ride"] = 131.15, ["Neon"] = 373.96, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 380.26, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 2198.01, ["Mega|Ride"] = 1905.67, ["Mega|Fly|Ride"] = 1743.16}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 19.53, ["Neon"] = 5.25, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 147.28, ["Mega"] = 42.3, ["Mega|Fly"] = 672, ["Mega|Ride"] = 82.45, ["Mega|Fly|Ride"] = 259.38}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 17.64, ["Ride"] = 14.42, ["Fly|Ride"] = 43.98, ["Neon"] = 4.41, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 18.19, ["Neon|Fly|Ride"] = 82.45, ["Mega"] = 45.94, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 10.27, ["Fly"] = 183.75, ["Ride"] = 38.03, ["Neon"] = 40.68, ["Neon|Ride"] = 160.12, ["Neon|Fly|Ride"] = 147.28, ["Mega"] = 557.21, ["Mega|Ride"] = 275.62, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.75, ["Ride"] = 622.09, ["Fly|Ride"] = 659.42, ["Neon"] = 4396, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 6163.5}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 24.47, ["Fly"] = 61.69, ["Ride"] = 43.98, ["Fly|Ride"] = 124.76, ["Neon"] = 217.75, ["Neon|Ride"] = 219.81, ["Neon|Fly|Ride"] = 255.94, ["Mega"] = 720.57, ["Mega|Ride"] = 857.24, ["Mega|Fly|Ride"] = 920.17}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 23.55, ["Fly|Ride"] = 118.13, ["Neon"] = 10.5, ["Neon|Ride"] = 57.16, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 68.16, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 324.22}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 105, ["Ride"] = 65.62, ["Fly|Ride"] = 261.98, ["Neon"] = 73.47, ["Mega|Fly|Ride"] = 439.61}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 30.86, ["Fly"] = 168.91, ["Ride"] = 115.06, ["Fly|Ride"] = 83.81, ["Neon"] = 194.25, ["Neon|Ride"] = 261.85, ["Neon|Fly|Ride"] = 286.13, ["Mega"] = 2637.62, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1002.75}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 103.95, ["Fly"] = 165.97, ["Ride"] = 144.15, ["Fly|Ride"] = 190.32, ["Neon"] = 439.61, ["Neon|Ride"] = 548.42, ["Neon|Fly|Ride"] = 446.25, ["Mega"] = 3224.47, ["Mega|Fly|Ride"] = 6593.99}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 225.74, ["Ride"] = 272.56, ["Fly|Ride"] = 337.42, ["Neon"] = 938.74, ["Neon|Ride"] = 800.63, ["Neon|Fly|Ride"] = 1023.75, ["Mega|Fly|Ride"] = 2867.82}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 11.81, ["Ride"] = 76.94, ["Fly|Ride"] = 246.91, ["Neon"] = 118.13, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 871.76, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.97, ["Ride"] = 17.61, ["Fly|Ride"] = 39.19, ["Neon"] = 7.28, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 84, ["Mega"] = 104.43, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.6, ["Fly"] = 50.57, ["Ride"] = 19.65, ["Fly|Ride"] = 62.92, ["Neon"] = 26.24, ["Neon|Fly"] = 139.58, ["Neon|Ride"] = 43.05, ["Neon|Fly|Ride"] = 147.28, ["Mega"] = 293.08, ["Mega|Ride"] = 240.19, ["Mega|Fly|Ride"] = 347.82}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 249.36, ["Fly"] = 324.22, ["Ride"] = 370.65, ["Fly|Ride"] = 576.03, ["Neon"] = 1569.1, ["Neon|Fly|Ride"] = 1681.47, ["Mega"] = 10989.98, ["Mega|Fly|Ride"] = 6269.82}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 16.5, ["Neon"] = 18.38, ["Neon|Ride"] = 139.41, ["Neon|Fly|Ride"] = 147.28, ["Mega"] = 35.43, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 318.94}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 5.15, ["Fly"] = 103.32, ["Ride"] = 17.06, ["Fly|Ride"] = 43.14, ["Neon"] = 26.44, ["Neon|Ride"] = 39.59, ["Neon|Fly|Ride"] = 80.3, ["Mega"] = 115.5, ["Mega|Ride"] = 220.31, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 14.88, ["Fly"] = 6562.5, ["Ride"] = 58.47, ["Fly|Ride"] = 147.28, ["Neon"] = 105.13, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 104.98, ["Neon|Fly|Ride"] = 328.12, ["Mega"] = 557.82, ["Mega|Ride"] = 733.06, ["Mega|Fly|Ride"] = 633.55}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 122.07, ["Fly"] = 37.98, ["Ride"] = 162.68, ["Fly|Ride"] = 184.65, ["Neon|Ride"] = 829.41, ["Neon|Fly|Ride"] = 590.63, ["Mega|Fly|Ride"] = 1758.41}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 19.69, ["Fly"] = 39.29, ["Ride"] = 28.86, ["Fly|Ride"] = 52.5, ["Neon"] = 105, ["Neon|Ride"] = 109.92, ["Neon|Fly|Ride"] = 138.5, ["Mega"] = 513.24, ["Mega|Ride"] = 422.63, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 62.44, ["Neon"] = 3.83, ["Neon|Ride"] = 72.19, ["Mega"] = 23.62, ["Mega|Ride"] = 172.29, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 32.7, ["Ride"] = 18.37, ["Fly|Ride"] = 86.16, ["Neon"] = 3.83, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 27.91, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 26.25, ["Mega|Fly"] = 103.32, ["Mega|Ride"] = 43.31, ["Mega|Fly|Ride"] = 166.64}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 39.15, ["Fly"] = 103.28, ["Ride"] = 112.38, ["Fly|Ride"] = 325.34, ["Neon"] = 42, ["Neon|Ride"] = 101.72, ["Neon|Fly|Ride"] = 237.04, ["Mega"] = 175.85, ["Mega|Ride"] = 263.81, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1050, ["Ride"] = 1312.5, ["Fly|Ride"] = 1391.25, ["Neon"] = 3937.5, ["Neon|Fly|Ride"] = 4017.24, ["Mega|Fly|Ride"] = 10498.95}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 419.98, ["Ride"] = 531.39, ["Fly|Ride"] = 540.53, ["Neon"] = 1680, ["Neon|Ride"] = 1443.74, ["Neon|Fly|Ride"] = 1573.68, ["Mega"] = 15385.96, ["Mega|Fly|Ride"] = 6593.99}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 301.88, ["Fly"] = 420.4, ["Ride"] = 357.33, ["Fly|Ride"] = 426.03, ["Neon"] = 759.94, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 724.49, ["Mega|Ride"] = 3665.17, ["Mega|Fly|Ride"] = 2916.24}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 253.2, ["Fly"] = 280.87, ["Ride"] = 295.31, ["Fly|Ride"] = 360.94, ["Neon"] = 748.13, ["Neon|Ride"] = 735, ["Neon|Fly|Ride"] = 700.77, ["Mega|Fly|Ride"] = 3616.82}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 43.05, ["Ride"] = 20.9, ["Fly|Ride"] = 52.49, ["Neon"] = 7.49, ["Neon|Ride"] = 34.89, ["Neon|Fly|Ride"] = 116.89, ["Mega"] = 55.85, ["Mega|Ride"] = 85.53, ["Mega|Fly|Ride"] = 184.05}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 288.75, ["Fly"] = 1466.07, ["Ride"] = 359.63, ["Fly|Ride"] = 489.07, ["Neon"] = 1312.5, ["Neon|Ride"] = 1463.87, ["Neon|Fly|Ride"] = 1533.11, ["Mega"] = 22273.37, ["Mega|Ride"] = 6301.66, ["Mega|Fly|Ride"] = 4279.55}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 15.75, ["Fly"] = 183.74, ["Ride"] = 149.91, ["Neon"] = 56.44, ["Neon|Ride"] = 147.28, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 236.24, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 833.05}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 23.57, ["Ride"] = 16.49, ["Fly|Ride"] = 36.67, ["Neon"] = 7.17, ["Neon|Ride"] = 54.96, ["Neon|Fly|Ride"] = 105, ["Mega"] = 128.63, ["Mega|Ride"] = 192.31, ["Mega|Fly|Ride"] = 168.33}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Mega"] = 21.34, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 177.62}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 78.06, ["Ride"] = 131.25, ["Fly|Ride"] = 459.38, ["Neon"] = 236.25, ["Neon|Ride"] = 359.73, ["Mega"] = 1049.9, ["Mega|Ride"] = 733.69, ["Mega|Fly|Ride"] = 790.19}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 8292.11, ["Ride"] = 22.01, ["Fly|Ride"] = 68.25, ["Neon"] = 31.83, ["Mega"] = 351.69, ["Mega|Ride"] = 303.57, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 3.74, ["Neon|Ride"] = 57.73, ["Neon|Fly|Ride"] = 141.93, ["Mega"] = 23.63, ["Mega|Ride"] = 67.16, ["Mega|Fly|Ride"] = 135.82}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 6.46, ["Fly"] = 131.03, ["Ride"] = 73.41, ["Fly|Ride"] = 91.46, ["Neon"] = 37.28, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 213.3, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 353.17}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.67, ["Fly"] = 29.69, ["Ride"] = 22.31, ["Fly|Ride"] = 56.7, ["Neon"] = 162.68, ["Neon|Ride"] = 59.36, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 238.85, ["Mega|Ride"] = 271, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 7.93, ["Ride"] = 42.88, ["Fly|Ride"] = 166.64, ["Neon"] = 68.25, ["Neon|Ride"] = 393.46, ["Neon|Fly|Ride"] = 332.03, ["Mega"] = 524.99, ["Mega|Ride"] = 564.54}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 6634.19, ["Ride"] = 24.61, ["Fly|Ride"] = 196.87, ["Neon"] = 70.87, ["Neon|Ride"] = 215.41, ["Neon|Fly|Ride"] = 746.09, ["Mega"] = 420, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 72.13, ["Ride"] = 16.37, ["Fly|Ride"] = 43.56, ["Neon"] = 5.25, ["Neon|Fly"] = 81.65, ["Neon|Ride"] = 28.67, ["Neon|Fly|Ride"] = 131.9, ["Mega"] = 59.07, ["Mega|Fly|Ride"] = 248.71}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 209.99, ["Fly"] = 199.5, ["Ride"] = 196.86, ["Fly|Ride"] = 262.5, ["Neon"] = 996.8, ["Neon|Ride"] = 2747.51, ["Neon|Fly|Ride"] = 1466.07, ["Mega"] = 8791.99, ["Mega|Fly|Ride"] = 4923.53}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 25.88, ["Ride"] = 18.94, ["Fly|Ride"] = 37.67, ["Neon"] = 3.7, ["Neon|Fly"] = 37.32, ["Neon|Ride"] = 20.82, ["Neon|Fly|Ride"] = 56.98, ["Mega"] = 38.07, ["Mega|Ride"] = 47.25, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 7.88, ["Ride"] = 44.77, ["Fly|Ride"] = 231.14, ["Neon"] = 98.27, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 775.3, ["Mega"] = 437.42, ["Mega|Ride"] = 309.74, ["Mega|Fly|Ride"] = 375.62}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 28.88, ["Ride"] = 78.75, ["Fly|Ride"] = 183.75, ["Neon"] = 216.56, ["Neon|Ride"] = 355.69, ["Neon|Fly|Ride"] = 466.83, ["Mega"] = 780.13, ["Mega|Ride"] = 1031.98, ["Mega|Fly|Ride"] = 944.99}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 203.44, ["Fly"] = 274.36, ["Ride"] = 240.47, ["Fly|Ride"] = 373.06, ["Neon"] = 620.82, ["Neon|Fly"] = 1658.78, ["Neon|Ride"] = 711.37, ["Neon|Fly|Ride"] = 728.34, ["Mega|Fly|Ride"] = 2887.5}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 14.97, ["Fly"] = 166.64, ["Ride"] = 166.68, ["Neon"] = 144.25, ["Neon|Ride"] = 139.95, ["Mega"] = 287.34, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 435.22}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 8.12, ["Ride"] = 58.45, ["Fly|Ride"] = 147.9, ["Neon"] = 103.32, ["Neon|Fly"] = 166.64, ["Neon|Ride"] = 328.62, ["Mega"] = 1758.41, ["Mega|Ride"] = 1466.07, ["Mega|Fly|Ride"] = 838.69}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 990.72, ["Ride"] = 945, ["Fly|Ride"] = 1027.69, ["Neon"] = 5118.75, ["Neon|Ride"] = 4383.75, ["Neon|Fly|Ride"] = 4068.75, ["Mega|Fly|Ride"] = 18023.55}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 5.16, ["Fly"] = 28.6, ["Ride"] = 19.67, ["Fly|Ride"] = 45.93, ["Neon"] = 50.65, ["Neon|Fly"] = 76.43, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 248.71, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 6.11, ["Fly"] = 51.19, ["Ride"] = 41.14, ["Fly|Ride"] = 133.88, ["Neon"] = 36.75, ["Neon|Ride"] = 87.94, ["Mega"] = 196.88, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 251.99, ["Mega|Fly|Ride"] = 341.23}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 87.94, ["Ride"] = 29.36, ["Fly|Ride"] = 81.35, ["Neon"] = 12.11, ["Neon|Ride"] = 35.81, ["Neon|Fly|Ride"] = 147.28, ["Mega"] = 82.4, ["Mega|Ride"] = 367.07, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 17.74, ["Ride"] = 32.81, ["Fly|Ride"] = 131.25, ["Neon"] = 69.21, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 170.36, ["Mega"] = 446.25, ["Mega|Ride"] = 427.49, ["Mega|Fly|Ride"] = 471.34}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.33, ["Fly"] = 25.99, ["Ride"] = 21, ["Fly|Ride"] = 49.54, ["Neon"] = 18.5, ["Neon|Fly"] = 58.66, ["Neon|Ride"] = 34.57, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 192.27, ["Mega|Ride"] = 169.31, ["Mega|Fly|Ride"] = 194.24}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 3.3, ["Fly"] = 32.75, ["Ride"] = 32.13, ["Fly|Ride"] = 131.25, ["Neon"] = 13.01, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 50.16, ["Neon|Fly|Ride"] = 107.55, ["Mega"] = 152.15, ["Mega|Ride"] = 219.81, ["Mega|Fly|Ride"] = 275.61}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 244.55, ["Ride"] = 337.42, ["Fly|Ride"] = 439.61, ["Neon"] = 1207.81, ["Neon|Fly|Ride"] = 1183.01, ["Mega|Fly|Ride"] = 3481.7}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 27.56, ["Neon"] = 12.74, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 293.45, ["Mega"] = 84.84, ["Mega|Ride"] = 161.44, ["Mega|Fly|Ride"] = 351.69}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 2.72, ["Ride"] = 19.69, ["Fly|Ride"] = 88.87, ["Neon"] = 18.24, ["Neon|Ride"] = 188.27, ["Mega"] = 195.57, ["Mega|Ride"] = 360.48}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.71, ["Fly"] = 94.76, ["Ride"] = 40.79, ["Fly|Ride"] = 70.14, ["Neon"] = 10.47, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 107.71, ["Mega"] = 107.63, ["Mega|Ride"] = 152.25, ["Mega|Fly|Ride"] = 586.88}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 81.8, ["Ride"] = 104.14, ["Fly|Ride"] = 260.4, ["Neon"] = 447.56, ["Neon|Ride"] = 545.12, ["Neon|Fly|Ride"] = 548.63, ["Mega"] = 2637.62, ["Mega|Ride"] = 1537.51, ["Mega|Fly|Ride"] = 2198.01}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 21.94, ["Fly"] = 90.79, ["Ride"] = 59.36, ["Fly|Ride"] = 285.75, ["Neon"] = 103.94, ["Neon|Ride"] = 439.61, ["Neon|Fly|Ride"] = 341.93, ["Mega"] = 682.5, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 689.69}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 18.57, ["Fly"] = 263.44, ["Ride"] = 47.25, ["Fly|Ride"] = 62.99, ["Neon"] = 87.94, ["Neon|Ride"] = 114.84, ["Neon|Fly|Ride"] = 175.86, ["Mega"] = 414.36, ["Mega|Ride"] = 458.64, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 6.56, ["Neon"] = 25.3, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 245.44, ["Mega"] = 157.5}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 86.36, ["Fly"] = 132.36, ["Ride"] = 86.24, ["Fly|Ride"] = 171.94, ["Neon"] = 183.74, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 215.27, ["Neon|Fly|Ride"] = 262.48, ["Mega|Fly|Ride"] = 1056.57}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 22.01, ["Fly|Ride"] = 105, ["Neon"] = 6.35, ["Neon|Fly|Ride"] = 130.79, ["Mega"] = 91.88, ["Mega|Ride"] = 293.45, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 17.06, ["Fly"] = 53.82, ["Ride"] = 25.96, ["Fly|Ride"] = 87.94, ["Neon"] = 64.55, ["Neon|Fly"] = 84, ["Neon|Ride"] = 81.81, ["Neon|Fly|Ride"] = 164.01, ["Mega"] = 364.34, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 394.56, ["Mega|Fly|Ride"] = 574.88}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 56.07, ["Fly"] = 203.42, ["Ride"] = 78.75, ["Fly|Ride"] = 270.38, ["Neon"] = 286.13, ["Neon|Fly"] = 288.75, ["Neon|Ride"] = 282.19, ["Neon|Fly|Ride"] = 358.32, ["Mega|Ride"] = 1503.45, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 19.85, ["Ride"] = 16.14, ["Fly|Ride"] = 43.98, ["Neon"] = 2.59, ["Neon|Fly"] = 21, ["Neon|Ride"] = 19.64, ["Neon|Fly|Ride"] = 37.38, ["Mega"] = 27.37, ["Mega|Ride"] = 42.67, ["Mega|Fly|Ride"] = 106.32}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.1, ["Ride"] = 51.59, ["Fly|Ride"] = 127.35, ["Neon"] = 19.63, ["Neon|Ride"] = 72.18, ["Neon|Fly|Ride"] = 159.75, ["Mega"] = 175.86, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 221.03, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 15.22, ["Fly"] = 78.75, ["Ride"] = 52.5, ["Fly|Ride"] = 117.6, ["Neon"] = 119.44, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 536.82, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 19.26, ["Neon"] = 2.1, ["Neon|Fly|Ride"] = 101.07, ["Mega"] = 24.2, ["Mega|Ride"] = 59.36, ["Mega|Fly|Ride"] = 120.75}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 45.94, ["Fly"] = 209.99, ["Ride"] = 91.88, ["Fly|Ride"] = 2624.99, ["Neon"] = 170.39, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 425.34, ["Mega"] = 1097.93, ["Mega|Fly"] = 918.75, ["Mega|Ride"] = 705.72, ["Mega|Fly|Ride"] = 978.44}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 12, ["Fly"] = 43.98, ["Ride"] = 28.88, ["Fly|Ride"] = 101.07, ["Neon"] = 239.6, ["Neon|Ride"] = 136.64, ["Neon|Fly|Ride"] = 169.26, ["Mega"] = 505.56, ["Mega|Ride"] = 458.07, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.63, ["Ride"] = 65.87, ["Neon"] = 59.05, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 89.94, ["Neon|Fly|Ride"] = 218.72, ["Mega"] = 288.75, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 513.24}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 9.85, ["Fly"] = 2198.01, ["Ride"] = 65.63, ["Fly|Ride"] = 249.61, ["Neon"] = 42, ["Neon|Ride"] = 95.63, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 287.44, ["Mega|Fly"] = 307.73, ["Mega|Ride"] = 280.88, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 37.38, ["Fly|Ride"] = 196.88, ["Neon"] = 7.29, ["Neon|Fly"] = 210, ["Neon|Ride"] = 39.38, ["Mega"] = 69.57, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 290.15}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 37.38, ["Fly|Ride"] = 90.57, ["Neon"] = 3.61, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 166.64, ["Mega"] = 39.38, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 248.64}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 23.5}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 51.66, ["Fly"] = 78.75, ["Ride"] = 58.5, ["Fly|Ride"] = 103.23, ["Neon"] = 144.63, ["Neon|Ride"] = 219.81, ["Neon|Fly|Ride"] = 312.38, ["Mega"] = 1854.36, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 888.56}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 65.63, ["Neon"] = 2.1, ["Neon|Ride"] = 27.19, ["Mega"] = 24.2, ["Mega|Ride"] = 166.64, ["Mega|Fly|Ride"] = 329.72}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 471.45, ["Ride"] = 525, ["Fly|Ride"] = 572.25, ["Neon"] = 1973.37, ["Mega"] = 13187.97, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 2.5, ["Fly"] = 49.38, ["Ride"] = 33.74, ["Fly|Ride"] = 58.27, ["Neon"] = 72.99, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 73.22, ["Mega"] = 431.5, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 645.12}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.1, ["Fly"] = 29.12, ["Ride"] = 19.58, ["Fly|Ride"] = 45.94, ["Neon"] = 22.01, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 103.32, ["Mega"] = 164.07, ["Mega|Fly"] = 219.81, ["Mega|Ride"] = 166.64, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 13.8, ["Fly"] = 56.06, ["Ride"] = 52.5, ["Fly|Ride"] = 87.05, ["Neon"] = 114.45, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 470.39, ["Mega|Ride"] = 388.5, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.1, ["Fly"] = 43.98, ["Ride"] = 38.57, ["Fly|Ride"] = 733.06, ["Neon"] = 47.87, ["Neon|Fly"] = 73.64, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 288.8, ["Mega|Ride"] = 292.35, ["Mega|Fly|Ride"] = 544.02}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 7.76, ["Ride"] = 29.69, ["Fly|Ride"] = 202.13, ["Neon"] = 78.75, ["Neon|Ride"] = 118.12, ["Neon|Fly|Ride"] = 147.28, ["Mega"] = 548.42, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 538.12}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 4.9, ["Ride"] = 56.06, ["Fly|Ride"] = 144.63, ["Neon"] = 34.13, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 102.38, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 212.18, ["Mega|Ride"] = 366.83, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 49.77, ["Ride"] = 13.13, ["Fly|Ride"] = 34.13, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 45.93, ["Mega"] = 15.61, ["Mega|Fly"] = 83.32, ["Mega|Ride"] = 32.31, ["Mega|Fly|Ride"] = 72.19}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 8.57, ["Fly"] = 42, ["Ride"] = 56.44, ["Fly|Ride"] = 109.92, ["Neon"] = 102.69, ["Neon|Fly"] = 124.36, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 151.16, ["Mega"] = 196.69, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 316.98}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 262.5, ["Ride"] = 315, ["Fly|Ride"] = 497.4, ["Neon"] = 1293.22, ["Neon|Ride"] = 1043.44, ["Neon|Fly|Ride"] = 1039.5, ["Mega"] = 6216.07, ["Mega|Ride"] = 9649.24, ["Mega|Fly|Ride"] = 4530.09}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 76.12, ["Ride"] = 104.99, ["Fly|Ride"] = 261.58, ["Neon"] = 393.75, ["Neon|Fly"] = 940.76, ["Neon|Ride"] = 479.07, ["Neon|Fly|Ride"] = 522.38, ["Mega"] = 2345.27, ["Mega|Ride"] = 1869, ["Mega|Fly|Ride"] = 1543.5}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 16.05, ["Ride"] = 16.22, ["Fly|Ride"] = 57.16, ["Neon"] = 7.76, ["Neon|Fly"] = 103.32, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 62.5, ["Mega"] = 147.28, ["Mega|Fly"] = 218.72, ["Mega|Ride"] = 128.13, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 22.01, ["Ride"] = 16.38, ["Fly|Ride"] = 39.38, ["Neon"] = 9.09, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 84, ["Mega|Fly"] = 293.45, ["Mega|Ride"] = 95.81, ["Mega|Fly|Ride"] = 153.6}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.24, ["Fly"] = 103.32, ["Ride"] = 22.31, ["Fly|Ride"] = 98.44, ["Neon"] = 41.77, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 326.71, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 216.5, ["Ride"] = 253.32, ["Fly|Ride"] = 328.77, ["Neon|Ride"] = 1048.69, ["Neon|Fly|Ride"] = 1063.08, ["Mega|Ride"] = 8791.99, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.34, ["Fly"] = 27.57, ["Ride"] = 16.67, ["Fly|Ride"] = 53.4, ["Neon"] = 21, ["Neon|Ride"] = 36.74, ["Neon|Fly|Ride"] = 94.4, ["Mega"] = 286.12, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 293.45}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.63, ["Ride"] = 78.75, ["Fly|Ride"] = 117.6, ["Neon"] = 31.4, ["Neon|Ride"] = 112.12, ["Mega"] = 299.25, ["Mega|Ride"] = 305.16, ["Mega|Fly|Ride"] = 439.61}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.62, ["Ride"] = 131.25, ["Neon"] = 19.68, ["Neon|Ride"] = 137.82, ["Mega"] = 133.88, ["Mega|Ride"] = 337.42}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 12.89, ["Fly"] = 58.13, ["Ride"] = 26.39, ["Fly|Ride"] = 65.63, ["Neon"] = 82.68, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 420, ["Mega|Ride"] = 501.38, ["Mega|Fly|Ride"] = 535.5}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 41.48, ["Ride"] = 82.05, ["Fly|Ride"] = 583.77, ["Neon"] = 116.82, ["Neon|Fly"] = 288.75, ["Neon|Ride"] = 168.91, ["Neon|Fly|Ride"] = 333.38, ["Mega"] = 564.54, ["Mega|Fly"] = 2307.9, ["Mega|Ride"] = 459.37, ["Mega|Fly|Ride"] = 519}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 43.32, ["Fly"] = 103.32, ["Ride"] = 51.18, ["Fly|Ride"] = 103.95, ["Neon"] = 144.27, ["Neon|Fly"] = 286.43, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 879.21, ["Mega|Ride"] = 700.88, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 16.68, ["Ride"] = 13.74, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 32.65, ["Neon|Ride"] = 17.05, ["Neon|Fly|Ride"] = 45.92, ["Mega"] = 20.69, ["Mega|Fly"] = 43.32, ["Mega|Ride"] = 39.82, ["Mega|Fly|Ride"] = 90.57}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 218.66, ["Ride"] = 279.57, ["Fly|Ride"] = 420.86, ["Neon"] = 3482.53, ["Neon|Ride"] = 1422.11, ["Neon|Fly|Ride"] = 1423.05, ["Mega|Fly|Ride"] = 5070.78}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 10.17, ["Fly"] = 101.19, ["Ride"] = 28.73, ["Fly|Ride"] = 111.57, ["Neon"] = 79.66, ["Neon|Ride"] = 147.28, ["Neon|Fly|Ride"] = 456.09, ["Mega"] = 380.52, ["Mega|Ride"] = 497.4, ["Mega|Fly|Ride"] = 441.18}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 36.62, ["Ride"] = 19.14, ["Fly|Ride"] = 59.07, ["Neon"] = 8.39, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 29.69, ["Neon|Fly|Ride"] = 109.92, ["Mega"] = 45.94, ["Mega|Fly"] = 235.2, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 324.84}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 26.25, ["Fly|Ride"] = 86.12, ["Neon"] = 2.41, ["Neon|Fly"] = 82, ["Neon|Ride"] = 22.01, ["Neon|Fly|Ride"] = 111.93, ["Mega"] = 28.17, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 40.36, ["Mega|Fly|Ride"] = 170.37}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.59, ["Ride"] = 37.69, ["Fly|Ride"] = 91.87, ["Neon"] = 10.49, ["Neon|Fly"] = 746.27, ["Neon|Ride"] = 63.14, ["Mega"] = 152.92, ["Mega|Ride"] = 195.21, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 10.36, ["Fly"] = 47.24, ["Ride"] = 21.19, ["Fly|Ride"] = 69.57, ["Neon"] = 47.16, ["Neon|Fly"] = 263.78, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 105, ["Mega"] = 288.14, ["Mega|Ride"] = 351.69, ["Mega|Fly|Ride"] = 384.74}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 5.75, ["Ride"] = 32.82, ["Neon"] = 43.07, ["Neon|Ride"] = 151.67, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 275.63, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 301.87}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Neon"] = 2.58, ["Neon|Ride"] = 59.36, ["Neon|Fly|Ride"] = 117.6, ["Mega"] = 20.88, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 212.63}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 9.75, ["Fly"] = 83.99, ["Ride"] = 28.87, ["Fly|Ride"] = 175.86, ["Neon"] = 41.77, ["Neon|Ride"] = 96.87, ["Neon|Fly|Ride"] = 144.41, ["Mega"] = 229.69, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 367.07}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 31.49, ["Neon"] = 5.07, ["Neon|Fly"] = 117.6, ["Neon|Ride"] = 39.32, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 30.17, ["Mega|Ride"] = 144.36, ["Mega|Fly|Ride"] = 245.44}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 58.44, ["Ride"] = 19.68, ["Fly|Ride"] = 43.32, ["Neon"] = 5.23, ["Neon|Ride"] = 28.86, ["Neon|Fly|Ride"] = 147.28, ["Mega"] = 55.62, ["Mega|Ride"] = 90.46, ["Mega|Fly|Ride"] = 284.53}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 630, ["Ride"] = 708.75, ["Fly|Ride"] = 771.75, ["Neon"] = 2625, ["Neon|Ride"] = 3481.7, ["Neon|Fly|Ride"] = 3399.63, ["Mega|Fly|Ride"] = 9620.63}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 18.34, ["Ride"] = 15.61, ["Fly|Ride"] = 64.99, ["Neon"] = 33.59, ["Neon|Fly"] = 43.98, ["Neon|Ride"] = 26.99, ["Neon|Fly|Ride"] = 65.63, ["Mega|Fly|Ride"] = 332.03}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.15, ["Ride"] = 59.06, ["Neon"] = 8.81, ["Neon|Fly"] = 769.31, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 91.88, ["Mega|Fly"] = 182.84, ["Mega|Ride"] = 147.28, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 6.2, ["Fly"] = 26.25, ["Ride"] = 23.28, ["Fly|Ride"] = 53.26, ["Neon"] = 43.97, ["Neon|Fly"] = 198.97, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 114.35, ["Mega"] = 485.63, ["Mega|Ride"] = 290.07, ["Mega|Fly|Ride"] = 376.68}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 58.96, ["Ride"] = 16.5, ["Fly|Ride"] = 43.98, ["Neon"] = 8.98, ["Neon|Fly"] = 153.87, ["Neon|Ride"] = 27.27, ["Neon|Fly|Ride"] = 57.74, ["Mega"] = 67.65, ["Mega|Ride"] = 95.51, ["Mega|Fly|Ride"] = 181.34}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 49.22, ["Ride"] = 78.75, ["Neon"] = 236.25, ["Neon|Ride"] = 337.42, ["Mega"] = 1023.19, ["Mega|Ride"] = 802.29, ["Mega|Fly|Ride"] = 864.93}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 28.87, ["Fly|Ride"] = 73.98, ["Neon"] = 7.55, ["Neon|Fly"] = 141.77, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 129.69, ["Mega"] = 43.22, ["Mega|Ride"] = 131.72, ["Mega|Fly|Ride"] = 276.07}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 22.32, ["Fly|Ride"] = 91.97, ["Neon"] = 11.34, ["Neon|Ride"] = 50.16, ["Mega"] = 114.19, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 325.5}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Ride"] = 43.98, ["Fly|Ride"] = 65.84, ["Neon"] = 12.53, ["Mega"] = 103.69, ["Mega|Ride"] = 164.87, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 19.69, ["Fly|Ride"] = 69.45, ["Neon"] = 4.68, ["Neon|Fly"] = 72.39, ["Neon|Ride"] = 22.24, ["Neon|Fly|Ride"] = 107.84, ["Mega"] = 40.05, ["Mega|Fly"] = 229.69, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 13.77, ["Fly"] = 21.31, ["Ride"] = 21, ["Fly|Ride"] = 43.95, ["Neon"] = 124.36, ["Neon|Fly"] = 123.31, ["Neon|Ride"] = 109.92, ["Neon|Fly|Ride"] = 143.98, ["Mega|Fly|Ride"] = 488.95}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 725.46, ["Ride"] = 801.62, ["Fly|Ride"] = 899.07, ["Neon"] = 1585.49, ["Neon|Ride"] = 1569.65, ["Neon|Fly|Ride"] = 1837.5, ["Mega"] = 8633.84, ["Mega|Ride"] = 5862.06, ["Mega|Fly|Ride"] = 4463.82}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 23.63, ["Ride"] = 16.35, ["Fly|Ride"] = 47.55, ["Neon"] = 3.78, ["Neon|Fly"] = 37.38, ["Neon|Ride"] = 28.49, ["Neon|Fly|Ride"] = 67.57, ["Mega"] = 39.38, ["Mega|Ride"] = 91.25, ["Mega|Fly|Ride"] = 121.61}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 3.66, ["Ride"] = 36.74, ["Fly|Ride"] = 248.71, ["Neon"] = 41.9, ["Neon|Ride"] = 205.01, ["Neon|Fly|Ride"] = 581.44, ["Mega"] = 432.98, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 570.94}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 53.82, ["Fly"] = 156.19, ["Ride"] = 78.84, ["Fly|Ride"] = 110.83, ["Neon"] = 315, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 367.49, ["Mega"] = 2475.65, ["Mega|Fly|Ride"] = 1846.32}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 29.29, ["Fly"] = 145.16, ["Ride"] = 58.25, ["Fly|Ride"] = 104.43, ["Neon"] = 152.8, ["Neon|Ride"] = 129.22, ["Mega"] = 1492.17, ["Mega|Ride"] = 968.23, ["Mega|Fly|Ride"] = 789.12}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 14.24, ["Ride"] = 29.69, ["Fly|Ride"] = 105, ["Neon"] = 65.63, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 308.74, ["Mega|Ride"] = 371.44, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 21.77, ["Ride"] = 72.16, ["Fly|Ride"] = 162.68, ["Neon"] = 82.69, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 309, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 397.69}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 24.05, ["Ride"] = 164.8, ["Neon"] = 183.75, ["Neon|Ride"] = 194.91, ["Neon|Fly|Ride"] = 381.36, ["Mega"] = 580.72, ["Mega|Ride"] = 476.44, ["Mega|Fly|Ride"] = 731.95}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 13.13}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 7.12, ["Ride"] = 21.54, ["Fly|Ride"] = 101.16, ["Neon"] = 26.16, ["Neon|Ride"] = 68.16, ["Neon|Fly|Ride"] = 213.98, ["Mega"] = 155.93, ["Mega|Fly"] = 462.9, ["Mega|Ride"] = 175.88, ["Mega|Fly|Ride"] = 311.17}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.63, ["Neon"] = 20.99, ["Mega"] = 139.32, ["Mega|Fly|Ride"] = 385.88}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 31.38, ["Fly"] = 63, ["Ride"] = 52.77, ["Fly|Ride"] = 85.32, ["Neon"] = 198.97, ["Neon|Fly"] = 219.81, ["Neon|Ride"] = 190.15, ["Neon|Fly|Ride"] = 351.69, ["Mega"] = 1281.09, ["Mega|Ride"] = 783.53, ["Mega|Fly|Ride"] = 719.99}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.21, ["Fly"] = 20.07, ["Ride"] = 16.94, ["Fly|Ride"] = 36.72, ["Neon"] = 23.35, ["Neon|Fly"] = 42.94, ["Neon|Ride"] = 28.74, ["Neon|Fly|Ride"] = 78.54, ["Mega"] = 191.63, ["Mega|Fly"] = 439.61, ["Mega|Ride"] = 183.74, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 5.07, ["Fly"] = 107.29, ["Ride"] = 29.29, ["Fly|Ride"] = 63.84, ["Neon"] = 28.88, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 175.86, ["Mega|Ride"] = 188.98, ["Mega|Fly|Ride"] = 234.94}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 8.81, ["Mega"] = 45.94, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 30.09, ["Ride"] = 44.54, ["Fly|Ride"] = 166.64, ["Neon"] = 279.16, ["Neon|Ride"] = 235.82, ["Neon|Fly|Ride"] = 363.78, ["Mega|Ride"] = 1758.41, ["Mega|Fly|Ride"] = 798}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 36.56, ["Fly|Ride"] = 58.15, ["Neon"] = 10.81, ["Neon|Fly"] = 203.44, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 105, ["Mega"] = 78.75, ["Mega|Ride"] = 74.62, ["Mega|Fly|Ride"] = 196.86}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 8.99, ["Ride"] = 65.63, ["Fly|Ride"] = 210, ["Neon"] = 73.5, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 406.88, ["Mega|Fly"] = 586.88, ["Mega|Ride"] = 425.15, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.93, ["Ride"] = 16.16, ["Neon"] = 14.42, ["Neon|Ride"] = 28.87, ["Neon|Fly|Ride"] = 100.36, ["Mega"] = 194.25, ["Mega|Ride"] = 157.88, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 3.82, ["Fly"] = 52.49, ["Ride"] = 21.87, ["Fly|Ride"] = 54.05, ["Neon"] = 90.57, ["Neon|Fly"] = 72.55, ["Neon|Ride"] = 145.09, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 279.16, ["Mega|Ride"] = 395.66, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 10.49, ["Neon"] = 91.24, ["Mega"] = 422.29, ["Mega|Ride"] = 380.77, ["Mega|Fly|Ride"] = 645.74}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 73.5, ["Ride"] = 203.43, ["Fly|Ride"] = 403.35, ["Neon"] = 275.63, ["Neon|Ride"] = 411.04, ["Neon|Fly|Ride"] = 1466.07, ["Mega"] = 1048.69, ["Mega|Ride"] = 1301.23, ["Mega|Fly|Ride"] = 1286.25}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 15.75, ["Ride"] = 78.75, ["Fly|Ride"] = 161.28, ["Neon"] = 107.63, ["Mega"] = 421.32, ["Mega|Ride"] = 418.69, ["Mega|Fly|Ride"] = 696.29}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 4.75, ["Ride"] = 115.26, ["Neon"] = 149.62, ["Neon|Fly"] = 219.81, ["Neon|Ride"] = 170.63, ["Mega|Ride"] = 459.38}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 26.25, ["Ride"] = 130.79, ["Fly|Ride"] = 367.49, ["Neon"] = 162.65, ["Neon|Fly"] = 268.17, ["Neon|Ride"] = 219.81, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 806.68, ["Mega|Fly"] = 2198.01, ["Mega|Ride"] = 658.31, ["Mega|Fly|Ride"] = 851.44}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.45, ["Neon"] = 24.75, ["Mega"] = 196.88, ["Mega|Ride"] = 258.65, ["Mega|Fly|Ride"] = 332.03}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 15.98, ["Fly|Ride"] = 63, ["Neon"] = 4.81, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 43.54, ["Neon|Fly|Ride"] = 57.66, ["Mega"] = 67.16, ["Mega|Ride"] = 147.28, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 2.56, ["Fly"] = 45.94, ["Ride"] = 32.36, ["Fly|Ride"] = 84, ["Neon"] = 15.65, ["Neon|Ride"] = 36.68, ["Neon|Fly|Ride"] = 164.05, ["Mega"] = 98.44, ["Mega|Ride"] = 103.98, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 147.28, ["Ride"] = 21, ["Fly|Ride"] = 72, ["Neon"] = 6.56, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 101.18, ["Mega"] = 56.44, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 23.79, ["Fly|Ride"] = 82.45, ["Neon"] = 23.82, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 219.81, ["Mega"] = 127.21, ["Mega|Ride"] = 336, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.24, ["Fly"] = 65.35, ["Ride"] = 32.82, ["Fly|Ride"] = 439.61, ["Neon"] = 29.85, ["Neon|Fly"] = 315, ["Neon|Ride"] = 58.15, ["Mega"] = 312.14, ["Mega|Ride"] = 287.47, ["Mega|Fly|Ride"] = 1099.02}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 5.03, ["Fly"] = 131.24, ["Ride"] = 24.41, ["Fly|Ride"] = 62.89, ["Neon"] = 52.16, ["Neon|Fly"] = 138.5, ["Neon|Ride"] = 49.3, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 216.46, ["Mega|Fly"] = 275.86, ["Mega|Ride"] = 439.61, ["Mega|Fly|Ride"] = 498.96}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.49, ["Ride"] = 21.8, ["Fly|Ride"] = 52.41, ["Neon"] = 36.38, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 153.87, ["Mega"] = 274.98, ["Mega|Ride"] = 315.67, ["Mega|Fly|Ride"] = 191.89}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 4.79, ["Fly"] = 144.31, ["Ride"] = 47.23, ["Neon"] = 13.02, ["Neon|Fly"] = 437.06, ["Neon|Ride"] = 72.31, ["Neon|Fly|Ride"] = 140.47, ["Mega"] = 85.65, ["Mega|Fly"] = 216.81, ["Mega|Ride"] = 156.7, ["Mega|Fly|Ride"] = 278.25}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 13.2, ["Ride"] = 95.18, ["Fly|Ride"] = 192.95, ["Neon"] = 95.82, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 603.75, ["Mega|Ride"] = 791.3, ["Mega|Fly|Ride"] = 577.49}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 48.55, ["Fly"] = 164.07, ["Ride"] = 82.45, ["Fly|Ride"] = 129.94, ["Neon"] = 240.91, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 314.97, ["Mega"] = 1611.15, ["Mega|Ride"] = 1048.69, ["Mega|Fly|Ride"] = 997.5}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Ride"] = 23.69, ["Fly|Ride"] = 52.77, ["Neon"] = 3.68, ["Neon|Ride"] = 22.01, ["Neon|Fly|Ride"] = 147.28, ["Mega"] = 36.28, ["Mega|Ride"] = 73.64, ["Mega|Fly|Ride"] = 145.69}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 10.4, ["Ride"] = 105, ["Neon"] = 105.94, ["Mega"] = 718.76, ["Mega|Fly|Ride"] = 1155.06}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 62.79, ["Ride"] = 65.54, ["Fly|Ride"] = 174.76, ["Neon"] = 249.38, ["Neon|Ride"] = 295.32, ["Neon|Fly|Ride"] = 418.99, ["Mega|Ride"] = 1318.82, ["Mega|Fly|Ride"] = 3297}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 8.21, ["Fly"] = 190.32, ["Ride"] = 56.06, ["Fly|Ride"] = 133.88, ["Neon"] = 39.35, ["Neon|Fly"] = 133.1, ["Neon|Ride"] = 104.9, ["Neon|Fly|Ride"] = 162.68, ["Mega"] = 270.17, ["Mega|Fly"] = 751.25, ["Mega|Ride"] = 239.5, ["Mega|Fly|Ride"] = 285.86}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 5.31, ["Ride"] = 26.25, ["Neon"] = 13.13, ["Neon|Ride"] = 78.4, ["Neon|Fly|Ride"] = 210, ["Mega"] = 103.32, ["Mega|Fly"] = 282.17, ["Mega|Ride"] = 424.35, ["Mega|Fly|Ride"] = 285.99}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 29.69, ["Ride"] = 19.26, ["Fly|Ride"] = 59.07, ["Neon"] = 16.5, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 97.44, ["Mega"] = 115.5, ["Mega|Fly"] = 196.87, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 216.38}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 21.45, ["Ride"] = 15.31, ["Fly|Ride"] = 52.49, ["Neon"] = 2.55, ["Neon|Fly"] = 131.9, ["Neon|Ride"] = 23, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 22.01, ["Mega|Ride"] = 74.62, ["Mega|Fly|Ride"] = 142.79}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 18.84, ["Fly|Ride"] = 93.09, ["Neon"] = 4.41, ["Neon|Ride"] = 24.49, ["Neon|Fly|Ride"] = 97.44, ["Mega"] = 41.35, ["Mega|Fly"] = 168, ["Mega|Ride"] = 87.06, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Neon"] = 3.56, ["Neon|Ride"] = 29.69, ["Mega"] = 22.32, ["Mega|Fly|Ride"] = 444.94}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 5.97, ["Ride"] = 40.94, ["Neon"] = 53.33, ["Neon|Ride"] = 82.6, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 293.45, ["Mega|Ride"] = 198.97, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 7.09, ["Ride"] = 30.19, ["Fly|Ride"] = 219.81, ["Neon"] = 67.89, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 140.07, ["Mega"] = 287.44, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 464.63}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 5.16, ["Fly"] = 23.63, ["Ride"] = 19.64, ["Fly|Ride"] = 42, ["Neon"] = 52.89, ["Neon|Ride"] = 42.4, ["Neon|Fly|Ride"] = 100.94, ["Mega|Ride"] = 314.52, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 72.16, ["Ride"] = 98.44, ["Fly|Ride"] = 124.69, ["Neon"] = 393.75, ["Neon|Ride"] = 549.52, ["Mega"] = 2486.93, ["Mega|Ride"] = 1663.9, ["Mega|Fly|Ride"] = 1544.82}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 21.53, ["Fly"] = 57.75, ["Ride"] = 28.88, ["Neon"] = 83.32, ["Neon|Fly|Ride"] = 630, ["Mega"] = 464.63, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 1050.67}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 17.61, ["Fly|Ride"] = 41.99, ["Neon"] = 2.62, ["Neon|Fly"] = 43.98, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 32.34, ["Mega|Ride"] = 93.45, ["Mega|Fly|Ride"] = 262.48}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 19.51, ["Ride"] = 15.32, ["Fly|Ride"] = 39.19, ["Neon"] = 6.21, ["Neon|Fly"] = 19.69, ["Neon|Ride"] = 22.01, ["Neon|Fly|Ride"] = 50.22, ["Mega"] = 48.85, ["Mega|Ride"] = 45.85, ["Mega|Fly|Ride"] = 115.64}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 505.32, ["Fly"] = 584.58, ["Ride"] = 491.9, ["Fly|Ride"] = 525, ["Neon"] = 2491.46, ["Neon|Fly|Ride"] = 2098.69, ["Mega|Fly|Ride"] = 9119.53}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 5.25, ["Ride"] = 90.14, ["Fly|Ride"] = 71.31, ["Neon"] = 48.57, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 425.34, ["Mega|Ride"] = 369.28, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 17.17, ["Fly|Ride"] = 34.13, ["Neon"] = 3.62, ["Neon|Fly"] = 24.94, ["Neon|Ride"] = 18.32, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 42, ["Mega|Ride"] = 70.34, ["Mega|Fly|Ride"] = 117.6}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 39.38, ["Ride"] = 122.72, ["Fly|Ride"] = 721.88, ["Neon"] = 193.27, ["Neon|Ride"] = 282.19, ["Neon|Fly|Ride"] = 575.89, ["Mega"] = 796.11, ["Mega|Ride"] = 761.25, ["Mega|Fly|Ride"] = 852.86}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 44.41, ["Ride"] = 31.88, ["Fly|Ride"] = 56.26, ["Neon"] = 16.5, ["Neon|Fly"] = 101.36, ["Neon|Ride"] = 32.12, ["Neon|Fly|Ride"] = 90.45, ["Mega"] = 114.19, ["Mega|Ride"] = 127.3, ["Mega|Fly|Ride"] = 227.39}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Ride"] = 44.39, ["Fly|Ride"] = 196.88, ["Neon"] = 2.63, ["Neon|Ride"] = 144.23, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 23.63, ["Mega|Ride"] = 52.48, ["Mega|Fly|Ride"] = 439.61}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 43.17, ["Fly"] = 129.94, ["Ride"] = 78.75, ["Fly|Ride"] = 215.25, ["Neon"] = 147.28, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 798.99, ["Mega|Ride"] = 653.59, ["Mega|Fly|Ride"] = 589.32}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Fly|Ride"] = 146.99, ["Neon"] = 7.86, ["Neon|Ride"] = 23.64, ["Neon|Fly|Ride"] = 351.69, ["Mega"] = 59.36, ["Mega|Ride"] = 86.63, ["Mega|Fly|Ride"] = 249.5}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 39.53, ["Ride"] = 72.41, ["Fly|Ride"] = 129.94, ["Neon"] = 283.23, ["Neon|Fly"] = 293.45, ["Neon|Ride"] = 216.38, ["Neon|Fly|Ride"] = 324.22, ["Mega"] = 1181.25, ["Mega|Ride"] = 1318.82, ["Mega|Fly|Ride"] = 1334.93}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 2.63, ["Ride"] = 37.32, ["Fly|Ride"] = 439.61, ["Neon"] = 32.75, ["Neon|Ride"] = 231, ["Neon|Fly|Ride"] = 502.63, ["Mega"] = 148.32, ["Mega|Ride"] = 83.35}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.62, ["Fly"] = 33.6, ["Ride"] = 81.35, ["Fly|Ride"] = 59.36, ["Neon"] = 8.64, ["Neon|Ride"] = 43.35, ["Neon|Fly|Ride"] = 109.92, ["Mega"] = 117.6, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 57.66, ["Fly"] = 191.24, ["Ride"] = 182.45, ["Fly|Ride"] = 195.57, ["Neon"] = 359.63, ["Mega|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 2052.94}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 593.43, ["Ride"] = 34.65, ["Neon"] = 7.16, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 45.82, ["Mega|Fly"] = 219.81, ["Mega|Ride"] = 110.76, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 28.6, ["Ride"] = 20.98, ["Fly|Ride"] = 43.98, ["Neon"] = 7.88, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 86.89, ["Mega"] = 59.36, ["Mega|Fly"] = 153, ["Mega|Ride"] = 107.71, ["Mega|Fly|Ride"] = 223.84}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 7.56, ["Fly"] = 30.19, ["Ride"] = 39.35, ["Fly|Ride"] = 198.97, ["Neon"] = 83.99, ["Neon|Fly"] = 133.06, ["Neon|Ride"] = 83.16, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 328.13, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 409.21}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 7.49, ["Fly"] = 38.06, ["Ride"] = 29.25, ["Fly|Ride"] = 65.62, ["Neon"] = 53.13, ["Neon|Ride"] = 89.55, ["Neon|Fly|Ride"] = 111.54, ["Mega"] = 354.38, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 442.68}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 18.15, ["Fly"] = 28.88, ["Ride"] = 24.94, ["Fly|Ride"] = 42, ["Neon"] = 81.38, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 175.86, ["Mega"] = 777.07, ["Mega|Ride"] = 331.34, ["Mega|Fly|Ride"] = 341.67}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 72.1, ["Ride"] = 115.49, ["Fly|Ride"] = 262.49, ["Neon"] = 315, ["Neon|Ride"] = 324.84, ["Neon|Fly|Ride"] = 498.75, ["Mega"] = 2100, ["Mega|Ride"] = 1990.02, ["Mega|Fly|Ride"] = 2156.67}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 9.19, ["Ride"] = 117.5, ["Fly|Ride"] = 423.94, ["Neon"] = 64.84, ["Neon|Ride"] = 142.93, ["Neon|Fly|Ride"] = 358.29, ["Mega"] = 309.25, ["Mega|Ride"] = 462, ["Mega|Fly|Ride"] = 1172.64}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 4.85, ["Ride"] = 25.57, ["Fly|Ride"] = 78.75, ["Neon"] = 22.01, ["Neon|Ride"] = 47.25, ["Mega"] = 120.24, ["Mega|Ride"] = 248.39, ["Mega|Fly|Ride"] = 272.56}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 10.89, ["Fly"] = 135.19, ["Ride"] = 41.63, ["Fly|Ride"] = 65.63, ["Neon"] = 72.12, ["Neon|Fly"] = 105, ["Neon|Ride"] = 42.88, ["Neon|Fly|Ride"] = 175.86, ["Mega"] = 317.63, ["Mega|Ride"] = 341.13, ["Mega|Fly|Ride"] = 497.44}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.6, ["Ride"] = 14.01, ["Fly|Ride"] = 45.94, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 15.44, ["Neon|Fly|Ride"] = 43.19, ["Mega"] = 15.09, ["Mega|Fly"] = 41.99, ["Mega|Ride"] = 28.84, ["Mega|Fly|Ride"] = 115.49}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 49.87, ["Fly"] = 164.07, ["Ride"] = 117.6, ["Neon"] = 233.89, ["Neon|Fly"] = 2491.46, ["Neon|Ride"] = 294, ["Mega"] = 1099.02, ["Mega|Ride"] = 813.75, ["Mega|Fly|Ride"] = 892.49}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 25.3, ["Fly|Ride"] = 144.09, ["Neon"] = 3.03, ["Neon|Fly"] = 131.25, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 33.02, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 18.44, ["Fly|Ride"] = 45.93, ["Neon"] = 22.75, ["Neon|Ride"] = 27.21, ["Neon|Fly|Ride"] = 90.03, ["Mega"] = 279.16, ["Mega|Ride"] = 201.36}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 56.34, ["Ride"] = 91.88, ["Fly|Ride"] = 131.25, ["Neon"] = 236.25, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 918.75, ["Mega|Ride"] = 800.63, ["Mega|Fly|Ride"] = 983.21}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 144.38, ["Neon"] = 6.57, ["Neon|Ride"] = 34.59, ["Neon|Fly|Ride"] = 147.28, ["Mega"] = 55.44, ["Mega|Ride"] = 147.28, ["Mega|Fly|Ride"] = 446.22}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 6.2}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 116.89, ["Fly|Ride"] = 141.01, ["Neon"] = 5.25, ["Neon|Ride"] = 94.54, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 145.69, ["Mega|Ride"] = 103.32, ["Mega|Fly|Ride"] = 195.81}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 124.94, ["Ride"] = 210, ["Fly|Ride"] = 210.95, ["Neon"] = 659.42, ["Neon|Ride"] = 629.99, ["Neon|Fly|Ride"] = 678.57, ["Mega"] = 6593.99, ["Mega|Ride"] = 3316.32, ["Mega|Fly|Ride"] = 2506.41}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.77, ["Ride"] = 142.78, ["Fly|Ride"] = 219.81, ["Neon"] = 32.94, ["Neon|Fly"] = 147.28, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 219.43, ["Mega"] = 170.41, ["Mega|Ride"] = 241.5, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 24.92, ["Neon"] = 3.57, ["Neon|Ride"] = 22.23, ["Mega"] = 45.91, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 48.57, ["Mega|Fly|Ride"] = 307.02}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 5.1, ["Ride"] = 36.74, ["Fly|Ride"] = 103.32, ["Neon"] = 60.27, ["Neon|Ride"] = 108.82, ["Neon|Fly|Ride"] = 162.68, ["Mega"] = 323.32, ["Mega|Ride"] = 579.12, ["Mega|Fly|Ride"] = 337.42}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 9.78, ["Fly"] = 60.92, ["Ride"] = 20.19, ["Fly|Ride"] = 63.75, ["Neon"] = 101.04, ["Neon|Ride"] = 145.09, ["Neon|Fly|Ride"] = 219.81, ["Mega"] = 640.5, ["Mega|Ride"] = 439.61, ["Mega|Fly|Ride"] = 492.19}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 23.63, ["Ride"] = 60.38, ["Fly|Ride"] = 205.57, ["Neon"] = 147.28, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 351.69, ["Mega"] = 552.57, ["Mega|Ride"] = 551.25, ["Mega|Fly|Ride"] = 565.79}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 158.82, ["Fly"] = 168, ["Ride"] = 164.07, ["Fly|Ride"] = 241.4, ["Neon"] = 645.75, ["Neon|Ride"] = 530.59, ["Neon|Fly|Ride"] = 656.25, ["Mega|Fly|Ride"] = 2565.09}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 5.44, ["Fly"] = 19.69, ["Ride"] = 17.07, ["Fly|Ride"] = 54.96, ["Neon"] = 49.71, ["Neon|Fly"] = 162.91, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 81.35, ["Mega|Ride"] = 266.12, ["Mega|Fly|Ride"] = 425.34}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.6, ["Fly"] = 73.64, ["Ride"] = 46.51, ["Fly|Ride"] = 131.25, ["Neon"] = 19.09, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 116.89, ["Mega"] = 157.5, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 4.61, ["Fly"] = 42.95, ["Ride"] = 41.14, ["Fly|Ride"] = 60.38, ["Neon"] = 39.38, ["Neon|Fly"] = 73.64, ["Neon|Ride"] = 51.97, ["Neon|Fly|Ride"] = 162.68, ["Mega"] = 470.39, ["Mega|Ride"] = 407.54, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 51.1, ["Fly"] = 111.96, ["Ride"] = 70.88, ["Fly|Ride"] = 116.82, ["Neon"] = 194.6, ["Neon|Ride"] = 242.29, ["Neon|Fly|Ride"] = 315, ["Mega"] = 1153.95, ["Mega|Ride"] = 786.19, ["Mega|Fly|Ride"] = 964.69}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 16.98, ["Ride"] = 164.07, ["Neon"] = 196.87, ["Neon|Ride"] = 262.67, ["Mega"] = 744.84, ["Mega|Ride"] = 729.75}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 223.13, ["Ride"] = 350.44, ["Neon"] = 1312.5, ["Neon|Ride"] = 1658.78, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4198.69}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 27.57, ["Ride"] = 27.42, ["Fly|Ride"] = 69.46, ["Neon"] = 254.99, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 347.82, ["Mega"] = 761.25, ["Mega|Ride"] = 761.25, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 41.56, ["Ride"] = 14.43, ["Fly|Ride"] = 127.5, ["Neon"] = 2.2, ["Neon|Ride"] = 16.94, ["Neon|Fly|Ride"] = 53.39, ["Mega"] = 20.64, ["Mega|Fly"] = 116.51, ["Mega|Ride"] = 109.92, ["Mega|Fly|Ride"] = 107.63}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Ride"] = 42.35, ["Neon"] = 19.59, ["Neon|Ride"] = 22.01, ["Neon|Fly|Ride"] = 166.64, ["Mega"] = 196.88, ["Mega|Ride"] = 166.64, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 2.1, ["Ride"] = 32.7, ["Fly|Ride"] = 59.36, ["Neon"] = 18.44, ["Neon|Ride"] = 65.96, ["Neon|Fly|Ride"] = 1181.24, ["Mega"] = 173.66, ["Mega|Fly"] = 575.01, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 327.48}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 384.57, ["Fly"] = 393.75, ["Ride"] = 419.99, ["Fly|Ride"] = 508.64, ["Neon"] = 1888.69, ["Neon|Ride"] = 2052.94, ["Neon|Fly|Ride"] = 1914.94, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 17.04, ["Fly|Ride"] = 48.55, ["Neon"] = 26.83, ["Neon|Ride"] = 37.38, ["Neon|Fly|Ride"] = 118.42, ["Mega"] = 247.31, ["Mega|Ride"] = 154.63, ["Mega|Fly|Ride"] = 233.63}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 3.63, ["Fly"] = 28, ["Ride"] = 16.7, ["Fly|Ride"] = 44.63, ["Neon"] = 50.8, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 64.86, ["Neon|Fly|Ride"] = 139.13, ["Mega"] = 375.87, ["Mega|Ride"] = 293.45, ["Mega|Fly|Ride"] = 328.02}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.56, ["Fly"] = 42, ["Ride"] = 24.94, ["Fly|Ride"] = 68.49, ["Neon"] = 18.38, ["Neon|Fly"] = 94.48, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 94.5, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 40.69, ["Fly"] = 74.65, ["Ride"] = 34.13, ["Fly|Ride"] = 88.3, ["Neon"] = 220.5, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 1318.82, ["Mega|Ride"] = 862.32, ["Mega|Fly|Ride"] = 789.1}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 52.5, ["Fly|Ride"] = 51.85, ["Neon"] = 13.54, ["Neon|Ride"] = 83.32, ["Neon|Fly|Ride"] = 210, ["Mega"] = 167.08, ["Mega|Ride"] = 205.23, ["Mega|Fly|Ride"] = 748.79}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 55.13, ["Fly"] = 105, ["Ride"] = 70.34, ["Neon"] = 131.24, ["Neon|Fly|Ride"] = 259.23, ["Mega|Ride"] = 918.75}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 44.3, ["Neon"] = 7.88, ["Neon|Ride"] = 144.27, ["Neon|Fly|Ride"] = 84, ["Mega"] = 84, ["Mega|Fly"] = 86304.75, ["Mega|Ride"] = 144.24, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 9, ["Neon"] = 62.25, ["Mega"] = 137.4, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 814.42}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 11.67, ["Ride"] = 73.64, ["Fly|Ride"] = 87.94, ["Neon"] = 46.53, ["Neon|Ride"] = 293.45, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 318.15, ["Mega|Ride"] = 497.4, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 6.83, ["Fly"] = 29.69, ["Ride"] = 34.09, ["Fly|Ride"] = 48.2, ["Neon"] = 56.19, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 56.98, ["Neon|Fly|Ride"] = 105.3, ["Mega"] = 548.42, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 476.44, ["Fly"] = 690.31, ["Ride"] = 446.7, ["Fly|Ride"] = 538.13, ["Neon"] = 1659.66, ["Neon|Fly"] = 2072.89, ["Neon|Ride"] = 3570, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 7576.5}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 18.02, ["Fly|Ride"] = 36.75, ["Neon"] = 14.81, ["Neon|Fly"] = 83.35, ["Neon|Ride"] = 32.29, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 272.56, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 312.13}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 18.38, ["Fly"] = 85.99, ["Ride"] = 73.64, ["Fly|Ride"] = 293.45, ["Neon"] = 108.94, ["Neon|Ride"] = 181.56, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 433.13, ["Mega|Fly"] = 733.06, ["Mega|Ride"] = 568.2, ["Mega|Fly|Ride"] = 393.74}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 24.94, ["Ride"] = 98.43, ["Fly|Ride"] = 200.17, ["Neon"] = 95.82, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 366.83, ["Mega"] = 262.5, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 458.67}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 60.29, ["Fly"] = 169.2, ["Ride"] = 84, ["Fly|Ride"] = 144.38, ["Neon"] = 465.07, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 2542.7, ["Mega|Fly|Ride"] = 2696.95}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 11.45, ["Ride"] = 58.46, ["Neon"] = 44.5, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 198.19, ["Mega"] = 209.9, ["Mega|Fly"] = 366.16, ["Mega|Ride"] = 238.88, ["Mega|Fly|Ride"] = 429.43}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 19.69, ["Fly|Ride"] = 59.07, ["Neon"] = 18.34, ["Neon|Ride"] = 43.29, ["Neon|Fly|Ride"] = 125.31, ["Mega"] = 103.69, ["Mega|Ride"] = 146.24, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 6.57, ["Ride"] = 72.35, ["Neon"] = 32.82, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 147, ["Mega|Fly"] = 395.66, ["Mega|Ride"] = 191.24, ["Mega|Fly|Ride"] = 251.99}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 55.75, ["Fly"] = 183.75, ["Ride"] = 81.97, ["Fly|Ride"] = 147.28, ["Neon"] = 133.25, ["Neon|Ride"] = 190.31, ["Neon|Fly|Ride"] = 273.78, ["Mega"] = 421.21, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 85.28, ["Neon"] = 8.81, ["Neon|Ride"] = 95.63, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 72.19, ["Mega|Fly"] = 175.86, ["Mega|Ride"] = 123.38}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 20.91, ["Ride"] = 209.99, ["Neon"] = 228.38, ["Neon|Ride"] = 395.66, ["Mega"] = 767.11, ["Mega|Fly|Ride"] = 659.42}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 956.82, ["Fly"] = 1194.38, ["Ride"] = 1040.58, ["Fly|Ride"] = 1044.75, ["Neon"] = 4396, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2887.49, ["Mega"] = 10110.78, ["Mega|Fly|Ride"] = 7875}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 14.05, ["Ride"] = 52.5, ["Fly|Ride"] = 196.27, ["Neon"] = 149.78, ["Neon|Fly"] = 716.63, ["Neon|Ride"] = 191.24, ["Mega"] = 466.74, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.63, ["Fly"] = 51.94, ["Ride"] = 20.91, ["Fly|Ride"] = 87.94, ["Neon"] = 9.79, ["Neon|Fly"] = 73.64, ["Neon|Ride"] = 34.59, ["Neon|Fly|Ride"] = 94.94, ["Mega"] = 81.24, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 332.03}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 8.97, ["Ride"] = 131.25, ["Fly|Ride"] = 147.28, ["Neon"] = 74.82, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 393.73, ["Mega"] = 288.74, ["Mega|Ride"] = 430.71, ["Mega|Fly|Ride"] = 497.4}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Fly|Ride"] = 191.24, ["Neon"] = 2.1, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 18.38, ["Mega|Ride"] = 72.16, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 52.5, ["Fly"] = 147.28, ["Ride"] = 90.95, ["Fly|Ride"] = 275.93, ["Neon"] = 196.88, ["Neon|Fly"] = 354.38, ["Neon|Ride"] = 261.19, ["Neon|Fly|Ride"] = 308.39, ["Mega"] = 993.24, ["Mega|Ride"] = 820.32, ["Mega|Fly|Ride"] = 945}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 21.6, ["Ride"] = 94.5, ["Fly|Ride"] = 293.45, ["Neon"] = 169.32, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 426.57, ["Mega"] = 464.17, ["Mega|Ride"] = 1024.28, ["Mega|Fly|Ride"] = 1172.64}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 9.17, ["Neon|Ride"] = 44.47, ["Neon|Fly|Ride"] = 219.81, ["Mega"] = 99.52, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 16.96, ["Fly"] = 162.68, ["Ride"] = 38.06, ["Fly|Ride"] = 98.62, ["Neon"] = 110.87, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 101.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 393.75, ["Mega|Ride"] = 544.69, ["Mega|Fly|Ride"] = 859.69}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 5.16, ["Ride"] = 34.13, ["Fly|Ride"] = 72.19, ["Neon"] = 27.13, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 58.51, ["Neon|Fly|Ride"] = 159.18, ["Mega"] = 262.4, ["Mega|Ride"] = 549.52, ["Mega|Fly|Ride"] = 408.84}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 41.49, ["Ride"] = 65.63, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 669.38, ["Mega"] = 2565.09, ["Mega|Ride"] = 2486.93, ["Mega|Fly|Ride"] = 1824.18}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 3.94, ["Fly|Ride"] = 551.72, ["Neon"] = 13.5, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 664.18, ["Mega"] = 85.32, ["Mega|Ride"] = 114.09, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 9.87, ["Fly"] = 37.38, ["Ride"] = 22.32, ["Fly|Ride"] = 52.5, ["Neon"] = 49.23, ["Neon|Fly"] = 191.24, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 337.22, ["Mega|Ride"] = 287.34, ["Mega|Fly|Ride"] = 354.27}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 127.32, ["Fly"] = 211.46, ["Ride"] = 150.93, ["Fly|Ride"] = 198.19, ["Neon"] = 499.96, ["Neon|Ride"] = 586.88, ["Neon|Fly|Ride"] = 590.63, ["Mega"] = 2984.31, ["Mega|Ride"] = 2784.87, ["Mega|Fly|Ride"] = 2003.64}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.63, ["Fly"] = 29.07, ["Ride"] = 19.07, ["Fly|Ride"] = 41.16, ["Neon"] = 27.57, ["Neon|Fly"] = 57.66, ["Neon|Ride"] = 24.68, ["Neon|Fly|Ride"] = 93.65, ["Mega"] = 111.57, ["Mega|Ride"] = 161.53, ["Mega|Fly|Ride"] = 204.43}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 35.44, ["Fly"] = 267.04, ["Ride"] = 77.44, ["Fly|Ride"] = 879.21, ["Neon"] = 166.64, ["Neon|Ride"] = 227.07, ["Neon|Fly|Ride"] = 340.7, ["Mega"] = 738.25, ["Mega|Ride"] = 864.93, ["Mega|Fly|Ride"] = 711.67}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.89, ["Ride"] = 15.75, ["Fly|Ride"] = 64.3, ["Neon"] = 2.1, ["Neon|Fly"] = 30.9, ["Neon|Ride"] = 17.01, ["Neon|Fly|Ride"] = 47.23, ["Mega"] = 16.05, ["Mega|Ride"] = 31.31, ["Mega|Fly|Ride"] = 76.13}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Neon"] = 5.06, ["Neon|Fly|Ride"] = 136.28, ["Mega"] = 19.69, ["Mega|Fly"] = 131.24, ["Mega|Ride"] = 65.54, ["Mega|Fly|Ride"] = 159.42}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 37.38, ["Ride"] = 31.88, ["Fly|Ride"] = 173.37, ["Neon"] = 24.81, ["Neon|Ride"] = 59.36, ["Neon|Fly|Ride"] = 142.79, ["Mega"] = 105, ["Mega|Ride"] = 287.56, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 40.5, ["Neon"] = 164.59, ["Neon|Ride"] = 166.64, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 531.03, ["Mega|Ride"] = 733.06}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 19.26, ["Ride"] = 16.99, ["Fly|Ride"] = 35.44, ["Neon"] = 13.71, ["Neon|Fly"] = 28.77, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.71, ["Mega"] = 104.99, ["Mega|Fly"] = 267.23, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 165.17}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 10.24, ["Fly"] = 76.44, ["Ride"] = 38.07, ["Fly|Ride"] = 130.1, ["Neon"] = 66.94, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 66.12, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 419.37, ["Mega|Fly"] = 447.66, ["Mega|Ride"] = 299.24, ["Mega|Fly|Ride"] = 403.38}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 26.17, ["Ride"] = 18.26, ["Fly|Ride"] = 70.72, ["Neon"] = 8.9, ["Neon|Fly"] = 98.42, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 61.74, ["Mega"] = 55.44, ["Mega|Fly"] = 106.98, ["Mega|Ride"] = 63.67, ["Mega|Fly|Ride"] = 144.24}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 11.45, ["Fly"] = 165.97, ["Ride"] = 24.93, ["Fly|Ride"] = 217.2, ["Neon"] = 44.44, ["Neon|Ride"] = 65.63, ["Mega"] = 425.34, ["Mega|Ride"] = 457.2, ["Mega|Fly|Ride"] = 481.23}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 4.11, ["Ride"] = 189.91, ["Fly|Ride"] = 209.99, ["Neon"] = 63.83, ["Neon|Ride"] = 262.4, ["Mega"] = 305.82, ["Mega|Ride"] = 315.45, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 5.25, ["Fly"] = 55.68, ["Ride"] = 18.19, ["Fly|Ride"] = 52.5, ["Neon"] = 32.86, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 41.08, ["Neon|Fly|Ride"] = 122.8, ["Mega"] = 258.15, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 237.79, ["Mega|Fly|Ride"] = 324.22}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 25.94, ["Ride"] = 19.02, ["Fly|Ride"] = 39.38, ["Neon"] = 18.2, ["Neon|Fly"] = 64.86, ["Neon|Ride"] = 27.54, ["Neon|Fly|Ride"] = 90.57, ["Mega"] = 147.28, ["Mega|Ride"] = 118.12, ["Mega|Fly|Ride"] = 287.95}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 196.88, ["Fly"] = 393.75, ["Ride"] = 263.78, ["Fly|Ride"] = 332.03, ["Neon"] = 1317.72, ["Neon|Ride"] = 1450.68, ["Neon|Fly|Ride"] = 1174.69, ["Mega"] = 4311.08, ["Mega|Fly|Ride"] = 3810.24}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 6.07, ["Ride"] = 114.17, ["Neon"] = 52.5, ["Mega"] = 123.38, ["Mega|Ride"] = 332.03}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.1, ["Fly"] = 109.92, ["Ride"] = 23.02, ["Fly|Ride"] = 57.16, ["Neon"] = 32.72, ["Neon|Fly"] = 249.5, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 252.94, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 200.82}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 6.39, ["Fly|Ride"] = 733.06, ["Neon"] = 38.07, ["Neon|Ride"] = 43.98, ["Neon|Fly|Ride"] = 603.74, ["Mega"] = 496.16, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 439.61}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 14.44, ["Fly|Ride"] = 32.43, ["Neon"] = 2.1, ["Neon|Fly"] = 29.69, ["Neon|Ride"] = 18.2, ["Neon|Fly|Ride"] = 38.07, ["Mega"] = 17.74, ["Mega|Fly"] = 52.5, ["Mega|Ride"] = 36.63, ["Mega|Fly|Ride"] = 78.74}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 3.07, ["Fly"] = 58.25, ["Ride"] = 21.74, ["Fly|Ride"] = 90.57, ["Neon"] = 22.31, ["Neon|Ride"] = 33.59, ["Neon|Fly|Ride"] = 107.62, ["Mega"] = 131.15, ["Mega|Ride"] = 158.21, ["Mega|Fly|Ride"] = 257.71}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.1, ["Ride"] = 122.3, ["Neon"] = 10.5, ["Neon|Ride"] = 293.45, ["Neon|Fly|Ride"] = 485.63, ["Mega"] = 53.82, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 351.69}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 74.82, ["Fly"] = 104.99, ["Ride"] = 97.12, ["Fly|Ride"] = 187.94, ["Neon"] = 420, ["Neon|Ride"] = 368.18, ["Neon|Fly|Ride"] = 387.19, ["Mega"] = 2931.04, ["Mega|Ride"] = 3665.17, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.75, ["Fly"] = 103.32, ["Ride"] = 23.62, ["Fly|Ride"] = 141.74, ["Neon"] = 19.63, ["Neon|Ride"] = 69.57, ["Mega"] = 169.31, ["Mega|Ride"] = 388.06, ["Mega|Fly|Ride"] = 733.06}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Ride"] = 43.98, ["Neon"] = 5.2, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 558.46, ["Mega"] = 64.94, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 73.64, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 51.19, ["Fly"] = 162.1, ["Ride"] = 118.13, ["Fly|Ride"] = 179.22, ["Neon"] = 150.84, ["Neon|Ride"] = 167.15, ["Neon|Fly|Ride"] = 272.87, ["Mega"] = 472.5, ["Mega|Ride"] = 636.57, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Ride"] = 14.32, ["Fly|Ride"] = 37.38, ["Neon"] = 2.16, ["Neon|Fly"] = 23.21, ["Neon|Ride"] = 19.25, ["Neon|Fly|Ride"] = 58.12, ["Mega"] = 17.17, ["Mega|Fly"] = 50.6, ["Mega|Ride"] = 29.69, ["Mega|Fly|Ride"] = 91.41}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 65.63, ["Fly|Ride"] = 98.93, ["Neon"] = 3.24, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 32.45, ["Neon|Fly|Ride"] = 101.39, ["Mega"] = 26.25, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 104.9, ["Mega|Fly|Ride"] = 162.65}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.63, ["Ride"] = 104.99, ["Fly|Ride"] = 161.44, ["Neon"] = 8.92, ["Neon|Ride"] = 51.66, ["Neon|Fly|Ride"] = 293.45, ["Mega"] = 76.12, ["Mega|Fly"] = 191.24, ["Mega|Ride"] = 111.57, ["Mega|Fly|Ride"] = 216.87}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 6.57, ["Ride"] = 77.44, ["Fly|Ride"] = 111.57, ["Neon"] = 21, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 87.93, ["Neon|Fly|Ride"] = 158.49, ["Mega"] = 112.86, ["Mega|Fly"] = 199.63, ["Mega|Ride"] = 145.85, ["Mega|Fly|Ride"] = 258.46}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 19.8, ["Ride"] = 15.75, ["Fly|Ride"] = 46.17, ["Neon"] = 2.1, ["Neon|Fly"] = 22.01, ["Neon|Ride"] = 20.46, ["Neon|Fly|Ride"] = 59.36, ["Mega"] = 20.99, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 20.78, ["Fly"] = 129.69, ["Ride"] = 65.63, ["Neon"] = 188.82, ["Neon|Ride"] = 189.06, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 582.54, ["Mega|Fly|Ride"] = 835.25}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2296.88, ["Fly"] = 3150, ["Ride"] = 2417.63, ["Fly|Ride"] = 2331, ["Neon|Fly|Ride"] = 7415.63, ["Mega|Fly|Ride"] = 45608.37}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 31.45, ["Ride"] = 16.93, ["Fly|Ride"] = 45.94, ["Neon"] = 7.88, ["Neon|Fly"] = 49.87, ["Neon|Ride"] = 26.4, ["Neon|Fly|Ride"] = 62.08, ["Mega"] = 65.52, ["Mega|Fly"] = 293.45, ["Mega|Ride"] = 93.19, ["Mega|Fly|Ride"] = 157.49}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Neon"] = 4.41, ["Neon|Ride"] = 72.19, ["Mega"] = 135.19, ["Mega|Fly"] = 441, ["Mega|Ride"] = 124.58, ["Mega|Fly|Ride"] = 506.76}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 13.32, ["Fly"] = 105, ["Ride"] = 32.82, ["Fly|Ride"] = 157.49, ["Neon"] = 82.5, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 288.46, ["Mega"] = 431.81, ["Mega|Ride"] = 564.54, ["Mega|Fly|Ride"] = 762.9}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 26.59, ["Fly"] = 147.28, ["Ride"] = 70.49, ["Neon"] = 144.15, ["Neon|Ride"] = 236.25, ["Mega"] = 710.99, ["Mega|Ride"] = 702.28, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 142.95, ["Fly"] = 548.42, ["Ride"] = 177.18, ["Fly|Ride"] = 274.53, ["Neon"] = 647.07, ["Neon|Ride"] = 774.38, ["Neon|Fly|Ride"] = 616.88, ["Mega"] = 6593.99, ["Mega|Fly|Ride"] = 3105.8}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 5.95, ["Ride"] = 31.5, ["Fly|Ride"] = 675.94, ["Neon"] = 26.23, ["Neon|Ride"] = 32.99, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 147.28, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 237.57}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 42.31, ["Neon"] = 21.62, ["Neon|Ride"] = 115.65, ["Mega"] = 179.81, ["Mega|Fly|Ride"] = 267.09}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.25, ["Fly"] = 102, ["Ride"] = 29.12, ["Fly|Ride"] = 64.63, ["Neon"] = 7.25, ["Neon|Fly"] = 129.69, ["Neon|Ride"] = 44.44, ["Neon|Fly|Ride"] = 147.28, ["Mega"] = 81.9, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 267.73}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 15.75, ["Ride"] = 72.19, ["Fly|Ride"] = 131.25, ["Neon"] = 130.92, ["Neon|Ride"] = 1247.5, ["Neon|Fly|Ride"] = 364.88, ["Mega"] = 586.88, ["Mega|Ride"] = 433.13, ["Mega|Fly|Ride"] = 429.85}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 43.98, ["Mega"] = 21, ["Mega|Ride"] = 586.88, ["Mega|Fly|Ride"] = 152.97}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 99.01, ["Fly"] = 258.28, ["Ride"] = 98.93, ["Fly|Ride"] = 170.52, ["Neon"] = 328.13, ["Neon|Fly"] = 460.67, ["Neon|Ride"] = 411.5, ["Neon|Fly|Ride"] = 513.24, ["Mega"] = 3297, ["Mega|Fly|Ride"] = 1923.65}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Fly"] = 42.3, ["Ride"] = 91.87, ["Neon"] = 16.26, ["Neon|Ride"] = 147.28, ["Neon|Fly|Ride"] = 102.92, ["Mega"] = 66.03, ["Mega|Ride"] = 293.45, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 109.92, ["Fly"] = 232.6, ["Ride"] = 85.32, ["Fly|Ride"] = 168.33, ["Neon"] = 270.37, ["Neon|Ride"] = 229.69, ["Neon|Fly|Ride"] = 509.25, ["Mega"] = 2625, ["Mega|Ride"] = 1466.07, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 64.86, ["Ride"] = 18.29, ["Fly|Ride"] = 44.57, ["Neon"] = 4.41, ["Neon|Fly"] = 87.08, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 83.97, ["Mega"] = 76.94, ["Mega|Fly"] = 497.52, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 8.07, ["Neon|Ride"] = 87.94, ["Mega"] = 40.41, ["Mega|Ride"] = 161.49, ["Mega|Fly|Ride"] = 411.04}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 3.67, ["Fly"] = 73.64, ["Ride"] = 24.52, ["Fly|Ride"] = 90.57, ["Neon"] = 24.94, ["Neon|Fly"] = 109.92, ["Neon|Ride"] = 72.48, ["Mega"] = 140.44, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 586.88}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 362.25, ["Fly"] = 746.27, ["Ride"] = 393.47, ["Fly|Ride"] = 494.57, ["Neon"] = 1181.25, ["Neon|Ride"] = 924, ["Neon|Fly|Ride"] = 1065.75, ["Mega"] = 3384.92, ["Mega|Ride"] = 2620.1, ["Mega|Fly|Ride"] = 3542.44}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 34.55, ["Fly"] = 65.63, ["Ride"] = 81.35, ["Fly|Ride"] = 91.85, ["Neon"] = 161.42, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 216.57, ["Mega|Fly"] = 2803.43, ["Mega|Ride"] = 933.85, ["Mega|Fly|Ride"] = 1083.64}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.63, ["Fly"] = 72.19, ["Ride"] = 104.99, ["Fly|Ride"] = 111.57, ["Neon"] = 28.58, ["Neon|Fly"] = 101.07, ["Neon|Ride"] = 57, ["Neon|Fly|Ride"] = 131.06, ["Mega"] = 169.32, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 288.51}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 24.44, ["Fly"] = 230.75, ["Ride"] = 70.34, ["Fly|Ride"] = 144.38, ["Neon"] = 86.63, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 259.87, ["Mega"] = 301.88, ["Mega|Fly"] = 1023.38, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 484.32}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 6.57, ["Ride"] = 20.78, ["Neon"] = 166.64, ["Neon|Ride"] = 124.4, ["Mega"] = 664.02, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 2.1, ["Neon"] = 14.43, ["Neon|Ride"] = 157.49, ["Mega"] = 117.6, ["Mega|Ride"] = 435.31, ["Mega|Fly|Ride"] = 337.42}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 73.64, ["Ride"] = 19.56, ["Fly|Ride"] = 62.99, ["Neon"] = 64.86, ["Neon|Ride"] = 147.28, ["Neon|Fly|Ride"] = 216.38, ["Mega"] = 580.85, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 108.74, ["Fly"] = 248.71, ["Ride"] = 124.69, ["Fly|Ride"] = 194.88, ["Neon"] = 575.09, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 524.99, ["Mega"] = 2637.62, ["Mega|Ride"] = 2625, ["Mega|Fly|Ride"] = 2178.75}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 19.66, ["Ride"] = 52.5, ["Fly|Ride"] = 85.32, ["Neon"] = 128.52, ["Neon|Ride"] = 189, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 551.25, ["Mega|Ride"] = 633.29}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2034.37, ["Fly"] = 2486.93, ["Ride"] = 1995, ["Fly|Ride"] = 1995, ["Neon"] = 11723.01, ["Neon|Ride"] = 7960.03, ["Neon|Fly|Ride"] = 5578.13, ["Mega|Fly|Ride"] = 25200}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 4.11, ["Fly"] = 26.25, ["Ride"] = 47.45, ["Fly|Ride"] = 196.87, ["Neon"] = 32.81, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 98.34, ["Mega"] = 216.57, ["Mega|Ride"] = 191.63, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 4.97, ["Ride"] = 59.36, ["Fly|Ride"] = 111.06, ["Neon"] = 24.94, ["Neon|Ride"] = 55.13, ["Mega"] = 139.13, ["Mega|Ride"] = 157.94, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 885.94, ["Fly"] = 1110, ["Ride"] = 900.38, ["Fly|Ride"] = 935.55, ["Neon"] = 2778.57, ["Neon|Ride"] = 2572.76, ["Neon|Fly|Ride"] = 2887.5, ["Mega|Ride"] = 14093.36, ["Mega|Fly|Ride"] = 10258.05}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 42.73, ["Ride"] = 58.46, ["Fly|Ride"] = 105, ["Neon"] = 238.88, ["Neon|Ride"] = 328.62, ["Mega"] = 718.1, ["Mega|Ride"] = 850.63, ["Mega|Fly|Ride"] = 854.44}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.1, ["Ride"] = 22.3, ["Fly|Ride"] = 128.15, ["Neon"] = 14.6, ["Neon|Fly"] = 166.64, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 166.64, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Ride"] = 147.28, ["Neon"] = 6.57, ["Neon|Ride"] = 50.85, ["Neon|Fly|Ride"] = 114.31, ["Mega"] = 29.54, ["Mega|Ride"] = 61.31, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 98.42, ["Fly"] = 439.61, ["Ride"] = 144.37, ["Fly|Ride"] = 157.5, ["Neon"] = 459.38, ["Neon|Ride"] = 615.54, ["Neon|Fly|Ride"] = 646.98, ["Mega"] = 2487.53, ["Mega|Fly|Ride"] = 2483.75}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.1, ["Ride"] = 38.48, ["Fly|Ride"] = 76.94, ["Neon"] = 12.55, ["Neon|Ride"] = 64.32, ["Mega"] = 87.94, ["Mega|Ride"] = 103.32, ["Mega|Fly|Ride"] = 249.58}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 84.71, ["Ride"] = 106.32, ["Neon"] = 621.74, ["Neon|Ride"] = 601.16, ["Neon|Fly|Ride"] = 527.54, ["Mega"] = 2198.01, ["Mega|Fly|Ride"] = 1682.58}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 5.92, ["Fly"] = 105, ["Fly|Ride"] = 131.9, ["Neon"] = 29.69, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 315, ["Mega"] = 360.76, ["Mega|Ride"] = 317.7}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 282.19, ["Fly"] = 425.34, ["Ride"] = 295.84, ["Fly|Ride"] = 367.48, ["Neon"] = 1148.82, ["Neon|Ride"] = 1453.98, ["Neon|Fly|Ride"] = 870.58, ["Mega|Fly|Ride"] = 3939.91}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 2.2, ["Fly"] = 34.09, ["Ride"] = 19.68, ["Fly|Ride"] = 63.75, ["Neon"] = 41.77, ["Neon|Ride"] = 54.96, ["Neon|Fly|Ride"] = 82.72, ["Mega"] = 178.5, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 19.69, ["Fly|Ride"] = 48.85, ["Neon"] = 3.84, ["Neon|Fly"] = 37.38, ["Neon|Ride"] = 26.4, ["Neon|Fly|Ride"] = 49.76, ["Mega"] = 45.94, ["Mega|Ride"] = 115.24, ["Mega|Fly|Ride"] = 125.42}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1466.07, ["Ride"] = 1050, ["Fly|Ride"] = 1157.63, ["Neon|Ride"] = 8060.06, ["Neon|Fly|Ride"] = 7327.02, ["Mega"] = 24869.16, ["Mega|Fly|Ride"] = 27548.55}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 16.74, ["Ride"] = 94.49, ["Neon"] = 118.02, ["Neon|Ride"] = 314.98, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 373.14, ["Mega|Ride"] = 498.6, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 6.16, ["Fly"] = 54.02, ["Ride"] = 34.54, ["Fly|Ride"] = 78.75, ["Neon"] = 26.24, ["Neon|Ride"] = 63.99, ["Neon|Fly|Ride"] = 118.01, ["Mega"] = 180.45, ["Mega|Ride"] = 257.99, ["Mega|Fly|Ride"] = 255.93}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 37, ["Fly"] = 39.05, ["Ride"] = 39.38, ["Fly|Ride"] = 72.99, ["Neon|Ride"] = 219.19, ["Neon|Fly|Ride"] = 191.01, ["Mega"] = 2637.62, ["Mega|Ride"] = 879.21, ["Mega|Fly|Ride"] = 799.32}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 13.67, ["Fly"] = 62.91, ["Ride"] = 31.4, ["Fly|Ride"] = 72.19, ["Neon"] = 61.46, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 195.64, ["Mega"] = 367.5, ["Mega|Ride"] = 351.69, ["Mega|Fly|Ride"] = 635.24}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 95.82, ["Fly|Ride"] = 644.01, ["Neon"] = 449.23, ["Neon|Fly"] = 586.88, ["Neon|Ride"] = 548.42, ["Neon|Fly|Ride"] = 835.25, ["Mega"] = 3955.31, ["Mega|Fly|Ride"] = 1141.88}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Neon"] = 2.1, ["Neon|Fly"] = 56.4, ["Neon|Ride"] = 116.88, ["Neon|Fly|Ride"] = 103.32, ["Mega"] = 17.47, ["Mega|Ride"] = 144.47, ["Mega|Fly|Ride"] = 217.81}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 144.37, ["Fly"] = 247.29, ["Ride"] = 146.94, ["Fly|Ride"] = 255.94, ["Neon"] = 845.9, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 3516.8, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.51, ["Fly"] = 748.35, ["Ride"] = 21, ["Fly|Ride"] = 70.14, ["Neon"] = 229.67, ["Neon|Ride"] = 83.99, ["Mega"] = 773.71, ["Mega|Ride"] = 440.35, ["Mega|Fly|Ride"] = 490.88}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 18.38, ["Fly|Ride"] = 39.36, ["Neon"] = 13.13, ["Neon|Fly"] = 83.35, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 70.69, ["Mega"] = 109.92, ["Mega|Ride"] = 280.24}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 5.92, ["Ride"] = 124.74, ["Neon"] = 15.75, ["Neon|Fly"] = 145.09, ["Neon|Ride"] = 147.28, ["Neon|Fly|Ride"] = 214.86}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 120.37, ["Ride"] = 222.2, ["Fly|Ride"] = 658.31, ["Neon"] = 632.12, ["Neon|Ride"] = 681.39, ["Neon|Fly|Ride"] = 707.51, ["Mega"] = 1968.75, ["Mega|Ride"] = 1847.58, ["Mega|Fly|Ride"] = 1785}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 4.95, ["Ride"] = 85.32, ["Neon"] = 20.99, ["Neon|Ride"] = 59.07, ["Mega"] = 122.17, ["Mega|Ride"] = 160.48, ["Mega|Fly|Ride"] = 332.03}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 25.3, ["Mega"] = 18.36, ["Mega|Ride"] = 215.15, ["Mega|Fly|Ride"] = 196.64}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.94, ["Ride"] = 26.21, ["Fly|Ride"] = 147.28, ["Neon"] = 2.1, ["Neon|Fly"] = 86.2, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 18.92, ["Mega|Fly"] = 59.36, ["Mega|Ride"] = 47.15, ["Mega|Fly|Ride"] = 120.75}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 36.74, ["Ride"] = 21.62, ["Fly|Ride"] = 52.49, ["Neon"] = 10.66, ["Neon|Ride"] = 24.49, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 63, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 156.19}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Fly"] = 29.69, ["Ride"] = 19.68, ["Fly|Ride"] = 91.88, ["Neon"] = 10.5, ["Mega"] = 137.82, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 22.32, ["Ride"] = 15.65, ["Fly|Ride"] = 42.8, ["Neon"] = 16.47, ["Neon|Fly"] = 87.94, ["Neon|Ride"] = 40.94, ["Neon|Fly|Ride"] = 77.67, ["Mega"] = 324.19, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 228.25}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 61.07, ["Ride"] = 91.88, ["Fly|Ride"] = 293.45, ["Neon"] = 229.66, ["Neon|Ride"] = 366.83, ["Neon|Fly|Ride"] = 586.88, ["Mega"] = 786.19, ["Mega|Ride"] = 772.35, ["Mega|Fly|Ride"] = 885.93}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 16.5, ["Fly|Ride"] = 49.26, ["Neon"] = 2.63, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 18, ["Neon|Fly|Ride"] = 43.54, ["Mega"] = 17.07, ["Mega|Fly"] = 43.98, ["Mega|Ride"] = 38.12, ["Mega|Fly|Ride"] = 96.93}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 8.61, ["Fly"] = 58.49, ["Ride"] = 52.5, ["Fly|Ride"] = 72.4, ["Neon"] = 45.94, ["Neon|Fly"] = 43.98, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 242.82, ["Mega|Fly"] = 586.88, ["Mega|Ride"] = 273.32, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 43.54, ["Fly"] = 144.31, ["Ride"] = 43.98, ["Fly|Ride"] = 116.89, ["Neon"] = 207.35, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 166.68, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1318.82, ["Mega|Ride"] = 879.21, ["Mega|Fly|Ride"] = 776.54}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 9.18, ["Fly"] = 209.98, ["Ride"] = 31.5, ["Neon"] = 102.92, ["Mega"] = 511.39, ["Mega|Ride"] = 1039.5, ["Mega|Fly|Ride"] = 872.62}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 18.63, ["Ride"] = 15.99, ["Fly|Ride"] = 42.88, ["Neon"] = 4.88, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 23.39, ["Neon|Fly|Ride"] = 55.09, ["Mega"] = 40.69, ["Mega|Ride"] = 58.75, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 13.12, ["Ride"] = 93.36, ["Neon"] = 91.87, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 395.66, ["Mega"] = 531.78, ["Mega|Fly"] = 583.58, ["Mega|Ride"] = 583.58, ["Mega|Fly|Ride"] = 804.48}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 1050, ["Fly"] = 1304.52, ["Ride"] = 1036.86, ["Fly|Ride"] = 1049.98, ["Neon"] = 2491.13, ["Neon|Ride"] = 2744.44, ["Neon|Fly|Ride"] = 2336.25, ["Mega|Fly|Ride"] = 6168.75}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 228.65, ["Ride"] = 313.69, ["Fly|Ride"] = 590.63, ["Neon"] = 721.88, ["Neon|Ride"] = 892.5, ["Mega"] = 3648.31, ["Mega|Ride"] = 3810.24, ["Mega|Fly|Ride"] = 3502.52}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.6, ["Ride"] = 22.32, ["Fly|Ride"] = 392.44, ["Neon"] = 10.49, ["Neon|Ride"] = 111.56, ["Neon|Fly|Ride"] = 257.24, ["Mega"] = 61.14, ["Mega|Fly|Ride"] = 1172.64}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 164.07, ["Ride"] = 251.89, ["Fly|Ride"] = 437.07, ["Neon"] = 639.19, ["Neon|Ride"] = 695.63, ["Neon|Fly|Ride"] = 945, ["Mega"] = 2465.94, ["Mega|Ride"] = 2383.58, ["Mega|Fly|Ride"] = 2182.95}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 7.88, ["Ride"] = 24.02, ["Fly|Ride"] = 95.63, ["Neon"] = 17.06, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 38.75, ["Neon|Fly|Ride"] = 318.73, ["Mega"] = 115.96, ["Mega|Ride"] = 235.2, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 255.94, ["Fly"] = 439.61, ["Ride"] = 274.38, ["Fly|Ride"] = 334.43, ["Neon"] = 1575, ["Neon|Ride"] = 1612.24, ["Neon|Fly|Ride"] = 1568.28, ["Mega|Fly|Ride"] = 3979.59}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 77.18, ["Ride"] = 23.63, ["Fly|Ride"] = 118.13, ["Neon"] = 66.94, ["Neon|Ride"] = 58.08, ["Mega"] = 393.75, ["Mega|Fly"] = 368.18, ["Mega|Ride"] = 586.88}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 40.69, ["Mega"] = 249.38, ["Mega|Ride"] = 248.39}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 29.69, ["Fly"] = 52.5, ["Ride"] = 58.98, ["Fly|Ride"] = 147.28, ["Neon"] = 122.72, ["Neon|Fly"] = 439.61, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 219.95, ["Mega"] = 847.75, ["Mega|Ride"] = 593.92, ["Mega|Fly|Ride"] = 813.27}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.76, ["Fly|Ride"] = 293.45, ["Neon"] = 17.07, ["Neon|Ride"] = 196.88, ["Mega"] = 248.71, ["Mega|Ride"] = 241.87, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 16.7, ["Ride"] = 15.65, ["Fly|Ride"] = 39.37, ["Neon"] = 3.29, ["Neon|Fly"] = 21.31, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 40.69, ["Mega"] = 31.5, ["Mega|Fly"] = 55.13, ["Mega|Ride"] = 34.54, ["Mega|Fly|Ride"] = 107.63}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 3839.07, ["Ride"] = 4580.63, ["Fly|Ride"] = 4723.69, ["Neon"] = 32969.9, ["Neon|Fly|Ride"] = 21957.96, ["Mega|Fly|Ride"] = 52500}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 9.91, ["Ride"] = 42.37, ["Neon"] = 87.94, ["Neon|Fly"] = 391.27, ["Neon|Ride"] = 101.64, ["Neon|Fly|Ride"] = 166.64, ["Mega"] = 210, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 438.52}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 28.3, ["Ride"] = 22.41, ["Fly|Ride"] = 50.61, ["Neon"] = 14.93, ["Neon|Fly"] = 45.93, ["Neon|Ride"] = 32.45, ["Neon|Fly|Ride"] = 81.32, ["Mega"] = 144.38, ["Mega|Ride"] = 133.06, ["Mega|Fly|Ride"] = 220.89}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 425.25, ["Fly"] = 547.78, ["Ride"] = 498.75, ["Fly|Ride"] = 538.13, ["Neon"] = 2052.94, ["Neon|Ride"] = 1292.81, ["Neon|Fly|Ride"] = 1201.56, ["Mega|Fly|Ride"] = 5114.82}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 2.1, ["Ride"] = 49.77, ["Neon"] = 22.32, ["Neon|Ride"] = 291.38, ["Mega"] = 143.69, ["Mega|Ride"] = 174.76, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 6.37, ["Fly"] = 145.69, ["Ride"] = 19.69, ["Neon"] = 66.09, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 875.61, ["Mega|Ride"] = 401.62, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 73.64, ["Ride"] = 20.78, ["Fly|Ride"] = 65.63, ["Neon"] = 7.55, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 25.47, ["Neon|Fly|Ride"] = 91.75, ["Mega"] = 61.38, ["Mega|Ride"] = 70.86, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 603.75, ["Fly"] = 894.59, ["Ride"] = 656.24, ["Fly|Ride"] = 714, ["Neon|Ride"] = 2126.25, ["Neon|Fly|Ride"] = 2099.99, ["Mega|Fly|Ride"] = 8242.49}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 15.75, ["Ride"] = 78.74, ["Fly|Ride"] = 210, ["Neon"] = 51.57, ["Neon|Fly"] = 328.12, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 269.06, ["Mega|Fly"] = 439.61, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 419.88}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 3.93, ["Fly"] = 59.36, ["Ride"] = 49.88, ["Neon"] = 24.25, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 150.84, ["Mega|Fly"] = 829.6, ["Mega|Ride"] = 192.94, ["Mega|Fly|Ride"] = 293.45}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.41, ["Fly"] = 39.26, ["Ride"] = 24.89, ["Fly|Ride"] = 64.3, ["Neon"] = 14.81, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 86.41, ["Mega"] = 166.64, ["Mega|Ride"] = 124.47, ["Mega|Fly|Ride"] = 239.78}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 20.78, ["Fly"] = 39.38, ["Ride"] = 39.81, ["Fly|Ride"] = 65.63, ["Neon"] = 113.16, ["Neon|Ride"] = 114.18, ["Mega"] = 615.54, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 1680}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Fly"] = 59.36, ["Ride"] = 24.94, ["Fly|Ride"] = 293.45, ["Neon"] = 4.41, ["Neon|Ride"] = 147.28, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 31.92, ["Mega|Fly"] = 158.28, ["Mega|Ride"] = 101.35, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 590.63, ["Ride"] = 733.06, ["Fly|Ride"] = 649.43, ["Neon"] = 2589.58, ["Neon|Ride"] = 2343.08, ["Neon|Fly|Ride"] = 2415.78, ["Mega|Ride"] = 9698.99, ["Mega|Fly|Ride"] = 7874.99}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.63, ["Ride"] = 73.49, ["Fly|Ride"] = 259.86, ["Neon"] = 13.61, ["Neon|Ride"] = 104.81, ["Neon|Fly|Ride"] = 245.44, ["Mega"] = 73.05, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 51.86, ["Fly|Ride"] = 196.88, ["Neon"] = 6.57, ["Neon|Fly"] = 293.45, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 44.63, ["Mega|Fly|Ride"] = 439.61}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Neon"] = 3.94, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 7327.02, ["Mega"] = 30.53, ["Mega|Fly"] = 151.76, ["Mega|Ride"] = 116.19, ["Mega|Fly|Ride"] = 216.5}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.6, ["Ride"] = 26.25, ["Neon"] = 15.54, ["Mega"] = 259.38, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 23.15, ["Fly"] = 98.44, ["Ride"] = 43.98, ["Fly|Ride"] = 217.63, ["Neon"] = 155.93, ["Neon|Ride"] = 197.64, ["Neon|Fly|Ride"] = 393.74, ["Mega"] = 689.08, ["Mega|Ride"] = 565.23, ["Mega|Fly|Ride"] = 599.82}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 19.47, ["Ride"] = 52.41, ["Fly|Ride"] = 124.69, ["Neon"] = 87.44, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 294, ["Mega"] = 551.25, ["Mega|Ride"] = 779.63, ["Mega|Fly|Ride"] = 755.47}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.51, ["Fly"] = 23.61, ["Ride"] = 17.3, ["Fly|Ride"] = 48.57, ["Neon"] = 38.75, ["Neon|Ride"] = 37.38, ["Neon|Fly|Ride"] = 105, ["Mega"] = 293.35, ["Mega|Ride"] = 273.67, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 11.79, ["Ride"] = 29.69, ["Fly|Ride"] = 149.23, ["Neon"] = 72.18, ["Neon|Ride"] = 162.68}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 111.56, ["Neon"] = 15.27, ["Neon|Ride"] = 59.36, ["Neon|Fly|Ride"] = 127.34, ["Mega"] = 85.31, ["Mega|Fly"] = 124.36, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 258.65}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 20.89, ["Fly"] = 34.13, ["Ride"] = 31.18, ["Fly|Ride"] = 55.11, ["Neon"] = 116.93, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 167.35, ["Mega"] = 988.01, ["Mega|Fly|Ride"] = 719.25}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 35.43, ["Fly"] = 97.13, ["Neon"] = 157.5, ["Mega"] = 281.71, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 584.73}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 48.57, ["Fly"] = 116.93, ["Ride"] = 91.87, ["Fly|Ride"] = 259.88, ["Neon"] = 271.69, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 374.07, ["Mega|Fly|Ride"] = 1351.88}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 33.68, ["Fly"] = 147.28, ["Ride"] = 72.19, ["Fly|Ride"] = 228.38, ["Neon"] = 131.15, ["Neon|Ride"] = 192.85, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 502.85, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 710.07}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 24.46, ["Ride"] = 51.48, ["Neon"] = 141.63, ["Neon|Ride"] = 223.13, ["Mega"] = 502.69, ["Mega|Ride"] = 445.08, ["Mega|Fly|Ride"] = 856.14}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 51.98, ["Fly"] = 393.75, ["Ride"] = 105, ["Fly|Ride"] = 208.94, ["Neon"] = 233.63, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 704.82, ["Mega"] = 826.88, ["Mega|Ride"] = 852.71, ["Mega|Fly|Ride"] = 879.21}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 24.19, ["Ride"] = 15.72, ["Fly|Ride"] = 30.53, ["Neon"] = 4.6, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 59.36, ["Mega"] = 40.14, ["Mega|Fly"] = 332.03, ["Mega|Ride"] = 56.06, ["Mega|Fly|Ride"] = 146.99}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1312.5}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 118.12, ["Ride"] = 282.19, ["Fly|Ride"] = 378, ["Neon"] = 513.24, ["Neon|Ride"] = 544.69, ["Neon|Fly|Ride"] = 953.63, ["Mega"] = 1640.63, ["Mega|Ride"] = 1756.22, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 83.91, ["Neon"] = 2.59, ["Neon|Fly"] = 103.32, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 300.57, ["Mega"] = 65.68, ["Mega|Ride"] = 141, ["Mega|Fly|Ride"] = 139.07}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 30.44, ["Ride"] = 65.62, ["Neon"] = 83.32, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 591.93, ["Mega|Ride"] = 664.02, ["Mega|Fly|Ride"] = 628.65}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Fly|Ride"] = 147.28, ["Mega"] = 18.38}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 4.44, ["Mega"] = 34.09, ["Mega|Ride"] = 147.28}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 115.11, ["Fly"] = 1833.14, ["Ride"] = 152.25, ["Fly|Ride"] = 210, ["Neon"] = 664.02, ["Neon|Ride"] = 433.13, ["Neon|Fly|Ride"] = 586.88, ["Mega|Ride"] = 6840.65, ["Mega|Fly|Ride"] = 2077.69}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 19.69, ["Fly|Ride"] = 64.86, ["Neon"] = 8.33, ["Neon|Fly"] = 43.98, ["Neon|Ride"] = 32.3, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 91.88, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 36.92, ["Ride"] = 27.57, ["Fly|Ride"] = 66.94, ["Neon"] = 5.8, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 419.9, ["Mega"] = 36.39, ["Mega|Ride"] = 129.15, ["Mega|Fly|Ride"] = 217.87}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 6.56, ["Neon"] = 25.3, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 245.44, ["Mega"] = 157.5}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.62, ["Ride"] = 131.25, ["Neon"] = 19.68, ["Neon|Ride"] = 137.82, ["Mega"] = 133.88, ["Mega|Ride"] = 337.42}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 104.97, ["Ride"] = 170.63, ["Fly|Ride"] = 367.07, ["Neon"] = 545.74, ["Neon|Ride"] = 603.75, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1874.25, ["Mega|Fly|Ride"] = 2572.5}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 10.49, ["Neon"] = 91.24, ["Mega"] = 422.29, ["Mega|Ride"] = 380.77, ["Mega|Fly|Ride"] = 645.74}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 367.5, ["Ride"] = 393.74, ["Fly|Ride"] = 747.33, ["Neon"] = 918.75, ["Neon|Ride"] = 1502.36, ["Neon|Fly|Ride"] = 1287, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 83.35}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 57.75}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 32.43}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 14.41}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 51}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 116.82}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 38.66}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 8.75}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 192.94}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 14.2}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 27.26}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 12.73}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 12.88}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 1010.62}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 7.56}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 8.65}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 7.77}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 7.07}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 42.67}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 564.38}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 511.39}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 11.71}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1704.94}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 63.45}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.21}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 7.14}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 17.07}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 29.69}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 22.68}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 65.46}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 19.69}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 13.43}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 19.59}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.1}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 64.2}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 7.24}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.1}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 15.75}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 13.11}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 7.35}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 4.7}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 2018.63}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.45}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 97.02}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 259.25}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 4.16}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 3.61}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 16.32}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 31.49}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 31.4}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 262.49}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 9}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 32.8}},
    ["rbxassetid://1265129435"] = {name = "Gold Snowboard", prices = {["default"] = 157.5}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 163.96}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 144.97}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 6.55}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.41}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 32.82}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 20.62}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 105}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 27.46}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 11.06}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.63}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 29.59}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.63}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 10.27}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 4.6}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 42.95}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 94.4}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 398.99}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 7.67}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 18.67}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 27.56}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 108.74}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 24.75}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 23100}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 124.69}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 39.38}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 37.28}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 30.17}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 58.97}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 31.2}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 51.19}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 91.53}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 84.24}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 36.49}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 110.78}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 39.38}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 42.75}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 47.27}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 262.4}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 8.91}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 9.09}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 5.15}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 4.91}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 27.54}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 219.79}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 5.24}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.63}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 3.15}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 4.75}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 21}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 228.27}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 830.82}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 7.44}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 616.88}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 13.02}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.41}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.3}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 231}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.63}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 44.4}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 99.71}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 24.86}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 52.41}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 69.57}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 17.78}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 5.25}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 11.46}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.52}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 6.56}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 10.49}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 36.74}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 6.09}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.34}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.83}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 17.43}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 195.36}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 45.38}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.63}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 216.36}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 14.69}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 28.65}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 8.66}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 28.88}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 75.79}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 6.34}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 9.97}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 4.61}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 6.35}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 19.69}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 86.63}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 6.57}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 2.1}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 8.28}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 7.24}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 3.92}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 3.94}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.36}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 4.65}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 3.82}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 8267.44}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 12.84}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 4.33}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 5.91}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 5.21}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 6.48}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 22.32}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 6.19}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 5.1}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 4.99}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 3.85}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 14.43}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 45.29}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 6.14}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 6.12}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 3.56}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.88}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 3937.5}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 17.07}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 50.09}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.16}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 4.97}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 81.9}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.37}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 5.25}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 131.15}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.36}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 8.81}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.61}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 7.55}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 11.81}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 28.88}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.24}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.92}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 12.03}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 4.96}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 3.13}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.69}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.63}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 4.9}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 3.82}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 29.58}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 2.52}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 11.46}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 125.09}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.68}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 72.16}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 53.7}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.96}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1459.5}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 104.81}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 4.96}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 75.5}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 35.13}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.9}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.98}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 7.49}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 22.3}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.3}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 14}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 15.4}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 2.5}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 14.65}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 5.6}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 14.19}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 3.71}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 16.41}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 7.77}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 91.59}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 23.62}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 37.68}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 393.75}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 110.22}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 15.1}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 22.32}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 24.05}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 3.42}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 6.57}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 3.93}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 7.39}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 147.28}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 150.84}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 14.56}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1036.85}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 188.79}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 12.79}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 10.31}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 59.07}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.9}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 4.83}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 4.96}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 91.87}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 10.04}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 6.45}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 3.92}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 3.13}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.3}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 10.01}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.18}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 57.16}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 2.52}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 76.56}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 4.97}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 3.94}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 19.48}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 114.19}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.63}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 8.81}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 76.13}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 8.25}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 50.74}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 58.95}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 94.4}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 4.76}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 62.66}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 6.45}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 143.06}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 3.94}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.5}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 35.36}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 64.26}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 10.5}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 43.32}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 4.24}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 5.03}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 8.38}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 20.69}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 65.63}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2.91}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 15.65}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 53.45}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 3.61}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 4.6}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 28.24}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.63}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 123.38}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 89.15}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 47.97}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 26.16}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1942.49}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 19.46}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 9.92}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 23}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 263.67}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 23.6}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 10.28}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 35.21}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 15.64}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 20.6}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 351.75}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 57.75}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 47.16}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.22}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 65.54}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 177.19}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 90.92}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1132.02}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 196.77}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 9.08}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1727.25}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 576.19}},
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