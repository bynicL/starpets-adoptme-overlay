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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1264.15, ["Ride"] = 1179.93, ["Fly|Ride"] = 1579.46, ["Neon"] = 6854.4, ["Neon|Fly|Ride"] = 5010.72, ["Mega"] = 21532.9, ["Mega|Fly|Ride"] = 21532.9}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 623.54, ["Fly"] = 742.98, ["Ride"] = 530.24, ["Fly|Ride"] = 525, ["Neon|Fly|Ride"] = 2100, ["Mega"] = 10762.58, ["Mega|Fly|Ride"] = 8448.06}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 6562.5, ["Ride"] = 4950.75, ["Fly|Ride"] = 4977, ["Neon|Fly|Ride"] = 17226.33, ["Mega|Fly|Ride"] = 76220.2}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 207.69, ["Ride"] = 247.16, ["Fly|Ride"] = 400.53, ["Neon"] = 1143.23, ["Neon|Ride"] = 984.38, ["Neon|Fly|Ride"] = 1103.82, ["Mega|Fly|Ride"] = 4895.43}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 632.63, ["Fly"] = 861.13, ["Ride"] = 590.63, ["Fly|Ride"] = 590.63, ["Neon|Fly|Ride"] = 1617, ["Mega|Fly|Ride"] = 5250}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 12.74, ["Ride"] = 58.97, ["Fly|Ride"] = 129.94, ["Neon"] = 97.93, ["Neon|Fly"] = 287.48, ["Neon|Ride"] = 99.32, ["Neon|Fly|Ride"] = 215.34, ["Mega"] = 357.33, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 598.63}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.68, ["Fly"] = 38.47, ["Ride"] = 28.66, ["Fly|Ride"] = 69.01, ["Neon"] = 35.13, ["Neon|Fly"] = 135.68, ["Neon|Ride"] = 53.52, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 189.82, ["Mega|Ride"] = 195.66, ["Mega|Fly|Ride"] = 408.06}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 99.74, ["Fly"] = 195.85, ["Ride"] = 141.75, ["Fly|Ride"] = 262.5, ["Neon"] = 425.25, ["Neon|Ride"] = 492.19, ["Mega"] = 1586.82, ["Mega|Fly|Ride"] = 1819.54}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 41.15, ["Fly"] = 97.76, ["Ride"] = 45.03, ["Fly|Ride"] = 106.17, ["Neon"] = 275.63, ["Neon|Ride"] = 238.85, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 1837.5, ["Mega|Ride"] = 1148.8, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 26.16, ["Fly"] = 47.74, ["Ride"] = 31.49, ["Fly|Ride"] = 69.57, ["Neon"] = 262.5, ["Neon|Ride"] = 214.27, ["Neon|Fly|Ride"] = 199.68, ["Mega"] = 646, ["Mega|Fly|Ride"] = 636.69}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 126, ["Ride"] = 144.29, ["Fly|Ride"] = 315, ["Neon"] = 402.81, ["Neon|Ride"] = 447.95, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1575, ["Mega|Ride"] = 1509.38}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 68.25}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 354.3, ["Fly"] = 488.82, ["Ride"] = 338.63, ["Fly|Ride"] = 401.63, ["Neon|Ride"] = 1632.64, ["Neon|Fly|Ride"] = 1508.59, ["Mega|Fly|Ride"] = 5043.94}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 137.75, ["Fly"] = 177.12, ["Ride"] = 131.15, ["Fly|Ride"] = 191.99, ["Neon|Fly"] = 685.37, ["Neon|Fly|Ride"] = 577.5, ["Mega"] = 4312.63, ["Mega|Fly|Ride"] = 2467.5}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.51, ["Fly"] = 81.48, ["Ride"] = 65.62, ["Neon"] = 51.98, ["Neon|Ride"] = 130.96, ["Neon|Fly|Ride"] = 256.26, ["Mega"] = 144.29, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 330.56, ["Mega|Fly|Ride"] = 476.97}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 237.62, ["Fly"] = 288.75, ["Ride"] = 223.13, ["Fly|Ride"] = 271.68, ["Neon|Ride"] = 1143.1, ["Neon|Fly|Ride"] = 945, ["Mega|Fly|Ride"] = 2750.9}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.78, ["Fly"] = 23.62, ["Ride"] = 19.17, ["Fly|Ride"] = 42.14, ["Neon"] = 43.09, ["Neon|Fly"] = 129.21, ["Neon|Ride"] = 81.99, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 170.63, ["Mega|Ride"] = 287.48, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 179.49, ["Fly"] = 333.62, ["Ride"] = 219.19, ["Fly|Ride"] = 326.81, ["Neon"] = 525, ["Neon|Ride"] = 595.6, ["Neon|Fly|Ride"] = 722.08, ["Mega"] = 1795.42, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 1559.25}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 44.98}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 72.19, ["Ride"] = 175.88, ["Fly|Ride"] = 326.17, ["Neon"] = 459.38, ["Neon|Fly|Ride"] = 523.69, ["Mega|Fly|Ride"] = 1862.61}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 41.67, ["Fly"] = 393.74, ["Ride"] = 81.38, ["Fly|Ride"] = 190.21, ["Neon"] = 262.5, ["Neon|Ride"] = 300.57, ["Neon|Fly|Ride"] = 429.19, ["Mega"] = 2814.67, ["Mega|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 1005.6}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 40.65, ["Fly"] = 75.12, ["Ride"] = 64.73, ["Fly|Ride"] = 110.15, ["Neon"] = 172.29, ["Neon|Ride"] = 194.15, ["Neon|Fly|Ride"] = 280.64, ["Mega"] = 1713.6, ["Mega|Fly|Ride"] = 875.55}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 62.46, ["Fly"] = 262.5, ["Ride"] = 72.16, ["Fly|Ride"] = 196.88, ["Neon"] = 252.11, ["Neon|Ride"] = 402.68, ["Neon|Fly|Ride"] = 499.16, ["Mega"] = 1967.44, ["Mega|Fly|Ride"] = 1557.92}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 32.3, ["Ride"] = 45.48, ["Fly|Ride"] = 124.9, ["Neon"] = 129.84, ["Neon|Ride"] = 162.75, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 1207.92, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 44.63, ["Fly"] = 80.77, ["Ride"] = 72.08, ["Fly|Ride"] = 115.5, ["Neon"] = 258.32, ["Neon|Ride"] = 265.21, ["Neon|Fly|Ride"] = 320.75, ["Mega|Ride"] = 1143.23, ["Mega|Fly|Ride"] = 933.47}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 7.75, ["Fly"] = 35.99, ["Ride"] = 22.3, ["Fly|Ride"] = 48.87, ["Neon"] = 40.69, ["Neon|Fly"] = 412.13, ["Neon|Ride"] = 60.37, ["Neon|Fly|Ride"] = 104.99, ["Mega"] = 309.02, ["Mega|Fly"] = 310.09, ["Mega|Ride"] = 188.2, ["Mega|Fly|Ride"] = 287.6}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 525, ["Ride"] = 485.63, ["Fly|Ride"] = 524.99, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1966.13, ["Mega"] = 10763.87, ["Mega|Fly|Ride"] = 9711.24}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 14.43, ["Ride"] = 31.5, ["Fly|Ride"] = 133.52, ["Neon"] = 219.19, ["Neon|Ride"] = 144.29, ["Neon|Fly|Ride"] = 439.28, ["Mega|Ride"] = 676.36, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 6.08, ["Fly"] = 34.12, ["Ride"] = 21, ["Fly|Ride"] = 42.52, ["Neon"] = 65.63, ["Neon|Ride"] = 76.12, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 324.19, ["Mega|Ride"] = 372.53, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 88.72, ["Fly"] = 90.56, ["Ride"] = 91.88, ["Fly|Ride"] = 131.25, ["Neon"] = 429.6, ["Neon|Ride"] = 402.68, ["Neon|Fly|Ride"] = 404.65, ["Mega"] = 6485.1, ["Mega|Ride"] = 5832.75, ["Mega|Fly|Ride"] = 1651.59}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 12.7, ["Ride"] = 34.47, ["Fly|Ride"] = 66.94, ["Neon"] = 82, ["Neon|Ride"] = 115.08, ["Neon|Fly|Ride"] = 270.67, ["Mega"] = 720.57, ["Mega|Ride"] = 734.32, ["Mega|Fly|Ride"] = 560.34}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 242.82, ["Fly"] = 300.68, ["Ride"] = 236.27, ["Fly|Ride"] = 340.55, ["Neon"] = 800.41, ["Neon|Ride"] = 623.44, ["Neon|Fly|Ride"] = 752.46, ["Mega"] = 6457.55, ["Mega|Ride"] = 3937.49, ["Mega|Fly|Ride"] = 2888.31}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 25.89}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.68, ["Fly"] = 28.28, ["Ride"] = 21.55, ["Fly|Ride"] = 72.85, ["Neon"] = 28.21, ["Neon|Fly"] = 144.24, ["Neon|Ride"] = 45.29, ["Neon|Fly|Ride"] = 128.43, ["Mega"] = 287.48, ["Mega|Fly"] = 489.51, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 288.63}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 1036.88, ["Fly"] = 2625, ["Ride"] = 1174.59, ["Fly|Ride"] = 1312.5, ["Neon"] = 9187.5, ["Neon|Ride"] = 6316.68, ["Neon|Fly|Ride"] = 5746.97, ["Mega|Ride"] = 55072.43, ["Mega|Fly|Ride"] = 24224.51}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 26.08, ["Ride"] = 45.94, ["Fly|Ride"] = 105.99, ["Neon"] = 204.58, ["Neon|Ride"] = 115.22, ["Neon|Fly|Ride"] = 389.82, ["Mega"] = 1043.44, ["Mega|Ride"] = 1105.74, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 234.72, ["Fly"] = 367.18, ["Ride"] = 257.25, ["Fly|Ride"] = 311.84, ["Neon"] = 1067.42, ["Neon|Ride"] = 978.8, ["Neon|Fly|Ride"] = 1030.32, ["Mega"] = 4198.93, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 3875.94}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 37.17}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 15.74, ["Fly"] = 86.8, ["Ride"] = 50.7, ["Fly|Ride"] = 144.29, ["Neon"] = 104.99, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 408.83, ["Mega"] = 592.55, ["Mega|Ride"] = 574.95, ["Mega|Fly|Ride"] = 718.13}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 134.27, ["Fly"] = 170.63, ["Ride"] = 145.53, ["Fly|Ride"] = 213.21, ["Neon"] = 502.81, ["Neon|Ride"] = 537.26, ["Neon|Fly|Ride"] = 488.31, ["Mega|Ride"] = 2286.44, ["Mega|Fly|Ride"] = 1811.24}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 124.59, ["Fly"] = 248.72, ["Ride"] = 144.56, ["Fly|Ride"] = 246.21, ["Neon"] = 427.8, ["Neon|Fly"] = 816.42, ["Neon|Ride"] = 458.57, ["Neon|Fly|Ride"] = 511.88, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1523.9}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 43.6}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 51.18, ["Fly"] = 63, ["Ride"] = 57.74, ["Fly|Ride"] = 87.94, ["Neon|Ride"] = 538.13, ["Neon|Fly|Ride"] = 373.02, ["Mega"] = 4306.59, ["Mega|Fly|Ride"] = 1572.38}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 7.69, ["Fly"] = 135.63, ["Ride"] = 57.66, ["Fly|Ride"] = 206.73, ["Neon"] = 51.44, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 139.98, ["Neon|Fly|Ride"] = 242.17, ["Mega"] = 262.5, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 653.46}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 603.75, ["Ride"] = 627.21, ["Fly|Ride"] = 696.94, ["Neon|Fly"] = 3875.94, ["Neon|Ride"] = 1903.13, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Ride"] = 15073.04, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 105, ["Fly"] = 131.15, ["Ride"] = 122.07, ["Fly|Ride"] = 203.34, ["Neon"] = 525, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 551.25, ["Mega|Fly|Ride"] = 2229.71}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 4405.9, ["Ride"] = 3961.13, ["Fly|Ride"] = 3937.5}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 83.18, ["Fly"] = 230.36, ["Ride"] = 91.86, ["Fly|Ride"] = 201.68, ["Neon"] = 653.57, ["Neon|Ride"] = 514.5, ["Mega|Ride"] = 2011.19, ["Mega|Fly|Ride"] = 2021.25}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 86.09, ["Fly"] = 328.13, ["Ride"] = 81.21, ["Fly|Ride"] = 105, ["Neon"] = 575.75, ["Neon|Ride"] = 430.67, ["Neon|Fly|Ride"] = 502.81, ["Mega"] = 6315.18, ["Mega|Ride"] = 2388.75, ["Mega|Fly|Ride"] = 2506.44}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 31.57, ["Fly"] = 65.63, ["Ride"] = 43.95, ["Fly|Ride"] = 103.58, ["Neon"] = 144.39, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 196.77, ["Mega"] = 2625, ["Mega|Ride"] = 920.55, ["Mega|Fly|Ride"] = 611.62}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 5.09}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 56.59, ["Fly"] = 52.5, ["Ride"] = 66.91, ["Fly|Ride"] = 144.29, ["Neon|Ride"] = 326.8, ["Neon|Fly|Ride"] = 446.25, ["Mega|Ride"] = 1305.87, ["Mega|Fly|Ride"] = 1359.99}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 35.32}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 185.07, ["Ride"] = 236.25, ["Fly|Ride"] = 282.19, ["Neon"] = 1148.8, ["Neon|Ride"] = 1148.8, ["Neon|Fly|Ride"] = 1289.85, ["Mega|Fly|Ride"] = 4895.43}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 689.07, ["Ride"] = 718.13, ["Fly|Ride"] = 786.18, ["Neon|Ride"] = 3016.43, ["Neon|Fly|Ride"] = 2857.42, ["Mega|Fly|Ride"] = 10028.82}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 9.09}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 33.94, ["Fly"] = 63.66, ["Ride"] = 40.55, ["Fly|Ride"] = 80.07, ["Neon"] = 210, ["Neon|Fly"] = 279.95, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 222.18, ["Mega|Ride"] = 1174.61, ["Mega|Fly|Ride"] = 766.49}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 24.94}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5931.64, ["Fly"] = 7178, ["Ride"] = 6023.84, ["Fly|Ride"] = 4812.94, ["Neon|Ride"] = 17953.64, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 32156.25}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 12.79, ["Fly"] = 144.29, ["Ride"] = 27.55, ["Fly|Ride"] = 58.47, ["Neon"] = 129.93, ["Neon|Ride"] = 102.9, ["Neon|Fly|Ride"] = 155.82, ["Mega"] = 561.75, ["Mega|Ride"] = 446.24, ["Mega|Fly|Ride"] = 677.56}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 15.74, ["Fly"] = 72.16, ["Ride"] = 32.8, ["Fly|Ride"] = 135.68, ["Neon"] = 119.44, ["Neon|Ride"] = 143.75, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1048.43, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 98.44, ["Ride"] = 113.06, ["Fly|Ride"] = 105, ["Neon|Ride"] = 501.74, ["Neon|Fly|Ride"] = 490.73, ["Mega"] = 4305.04, ["Mega|Fly|Ride"] = 1795.42}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 13.6, ["Fly"] = 72.16, ["Ride"] = 38.77, ["Fly|Ride"] = 78.75, ["Neon"] = 98.44, ["Neon|Fly"] = 215.34, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 501.38, ["Mega"] = 551.25, ["Mega|Ride"] = 769.81, ["Mega|Fly|Ride"] = 800.63}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1706.25, ["Fly"] = 2165.63, ["Ride"] = 2007.14, ["Fly|Ride"] = 1530.26, ["Neon|Fly|Ride"] = 3017.44, ["Mega|Fly|Ride"] = 11025}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 24937.5, ["Fly"] = 35016.03, ["Ride"] = 31005.18, ["Fly|Ride"] = 24806.25, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 63000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 18.38, ["Fly"] = 89.25, ["Ride"] = 55, ["Fly|Ride"] = 120.75, ["Neon"] = 157.25, ["Neon|Ride"] = 291.38, ["Neon|Fly|Ride"] = 357.47, ["Mega"] = 1050, ["Mega|Ride"] = 1305.86, ["Mega|Fly|Ride"] = 1563.3}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.62, ["Fly"] = 91.77, ["Ride"] = 44.51, ["Fly|Ride"] = 199.5, ["Neon"] = 26.92, ["Neon|Fly"] = 230.33, ["Neon|Ride"] = 72.18, ["Neon|Fly|Ride"] = 191.66, ["Mega"] = 144.63, ["Mega|Fly"] = 384.3, ["Mega|Ride"] = 414.87, ["Mega|Fly|Ride"] = 367.07}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 26.03}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.66, ["Ride"] = 43.07, ["Fly|Ride"] = 164.01, ["Neon"] = 58.08, ["Neon|Ride"] = 108.94, ["Neon|Fly|Ride"] = 279.9, ["Mega"] = 428.52, ["Mega|Ride"] = 409.24, ["Mega|Fly|Ride"] = 560.01}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 622.13, ["Fly"] = 861.33, ["Ride"] = 656.25, ["Fly|Ride"] = 681.18, ["Neon"] = 3101.03, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2296.88, ["Mega|Fly|Ride"] = 9057.62}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 787.5, ["Fly"] = 951.57, ["Ride"] = 820.32, ["Fly|Ride"] = 901.69, ["Neon"] = 3590.62, ["Neon|Fly|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 13708.8}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 15.64, ["Fly"] = 122.42, ["Ride"] = 36.74, ["Fly|Ride"] = 85.32, ["Neon"] = 87.94, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 162.75, ["Mega"] = 501.74, ["Mega|Ride"] = 481.9, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 29.94}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 131.25, ["Fly"] = 128.34, ["Ride"] = 82.01, ["Fly|Ride"] = 144.37, ["Neon"] = 574.95, ["Neon|Ride"] = 426.57, ["Neon|Fly|Ride"] = 420, ["Mega"] = 19687.5, ["Mega|Ride"] = 2011.19, ["Mega|Fly|Ride"] = 2111.31}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 91.77, ["Fly"] = 105, ["Ride"] = 101.22, ["Fly|Ride"] = 157.5, ["Neon"] = 450.19, ["Neon|Ride"] = 484.23, ["Neon|Fly|Ride"] = 509.15, ["Mega"] = 1400.64, ["Mega|Fly|Ride"] = 2180.76}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.9, ["Fly"] = 26.25, ["Ride"] = 19.69, ["Fly|Ride"] = 48.57, ["Neon"] = 49.76, ["Neon|Fly"] = 488.69, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 115.06, ["Mega"] = 272.87, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 203.99, ["Fly"] = 224.44, ["Ride"] = 216.9, ["Fly|Ride"] = 288.75, ["Neon|Ride"] = 654.94, ["Neon|Fly|Ride"] = 746.82, ["Mega"] = 5167.91, ["Mega|Fly|Ride"] = 2821.88}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 8.23, ["Ride"] = 51.89, ["Fly|Ride"] = 141.75, ["Neon"] = 45.7, ["Neon|Ride"] = 157.5, ["Mega"] = 269.18, ["Mega|Fly"] = 1137.94, ["Mega|Ride"] = 278.69, ["Mega|Fly|Ride"] = 668.5}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 19.51, ["Fly"] = 65.63, ["Ride"] = 32.82, ["Fly|Ride"] = 90.45, ["Neon"] = 131.25, ["Neon|Fly"] = 326.82, ["Neon|Ride"] = 145.28, ["Neon|Fly|Ride"] = 213.94, ["Mega|Fly|Ride"] = 826.97}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 28.3, ["Ride"] = 57.75, ["Fly|Ride"] = 156.19, ["Neon"] = 256.26, ["Neon|Ride"] = 279.95, ["Mega"] = 997.5, ["Mega|Ride"] = 853.13, ["Mega|Fly|Ride"] = 1011.85}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 16.48, ["Fly"] = 88.3, ["Ride"] = 41.99, ["Fly|Ride"] = 85.07, ["Neon"] = 131.25, ["Neon|Ride"] = 326.72, ["Neon|Fly|Ride"] = 359.62, ["Mega"] = 1076.4, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6875.47, ["Ride"] = 5814.38, ["Fly|Ride"] = 5840.63, ["Neon"] = 32299.34, ["Neon|Fly|Ride"] = 30146.06}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 226.7, ["Fly"] = 286.13, ["Ride"] = 240.19, ["Fly|Ride"] = 288.65, ["Neon|Fly|Ride"] = 622.13, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 86.81, ["Fly"] = 314.9, ["Ride"] = 120.65, ["Fly|Ride"] = 262.5, ["Neon"] = 196.88, ["Neon|Ride"] = 313.59, ["Neon|Fly|Ride"] = 427.85, ["Mega"] = 590.52, ["Mega|Ride"] = 556.5, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.51, ["Fly"] = 65.63, ["Ride"] = 27.57, ["Fly|Ride"] = 81.37, ["Neon"] = 28.21, ["Neon|Ride"] = 35.28, ["Neon|Fly|Ride"] = 195.88, ["Mega"] = 499.8, ["Mega|Ride"] = 330.47, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 62.08, ["Fly"] = 215.34, ["Ride"] = 116.38, ["Fly|Ride"] = 224.44, ["Neon"] = 220.5, ["Neon|Ride"] = 244.29, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 537.31, ["Mega|Fly"] = 732.13, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 16485, ["Ride"] = 13415.07, ["Fly|Ride"] = 11681.25, ["Neon|Fly|Ride"] = 24766.88, ["Mega|Fly|Ride"] = 107521.28}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 380.62, ["Ride"] = 410.82, ["Fly|Ride"] = 504, ["Neon|Ride"] = 2126.39, ["Neon|Fly|Ride"] = 1780.78, ["Mega"] = 8749.13}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 59.06, ["Fly"] = 64.97, ["Ride"] = 59.07, ["Fly|Ride"] = 113.14, ["Neon"] = 430.57, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 389.82, ["Mega|Fly|Ride"] = 2009.03}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 8.68, ["Ride"] = 23.94, ["Fly|Ride"] = 72.13, ["Neon"] = 69.21, ["Neon|Fly"] = 277.87, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 141.06, ["Mega"] = 460.82, ["Mega|Ride"] = 734.32, ["Mega|Fly|Ride"] = 1076.4}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 387.17, ["Ride"] = 421.02, ["Fly|Ride"] = 467.78, ["Neon"] = 1253.44, ["Neon|Ride"] = 1419.89, ["Neon|Fly|Ride"] = 1299.37, ["Mega|Fly|Ride"] = 4547.82}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 7.96, ["Fly"] = 43.18, ["Ride"] = 36.74, ["Fly|Ride"] = 221.81, ["Neon"] = 45.14, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 188.9, ["Mega"] = 169.32, ["Mega|Ride"] = 227.07, ["Mega|Fly|Ride"] = 357.33}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 105, ["Fly"] = 172.23, ["Ride"] = 134.92, ["Fly|Ride"] = 217.75, ["Neon"] = 465.94, ["Neon|Fly"] = 525, ["Neon|Ride"] = 488.25, ["Neon|Fly|Ride"] = 550.99, ["Mega"] = 2583.96, ["Mega|Fly|Ride"] = 2430.18}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 9.19, ["Fly"] = 22.23, ["Ride"] = 17.43, ["Fly|Ride"] = 35.35, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 86.61, ["Mega"] = 2583.35, ["Mega|Fly|Ride"] = 645.75}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 8.57}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 72.13, ["Fly"] = 598.23, ["Ride"] = 87.94, ["Fly|Ride"] = 172.29, ["Neon"] = 244.78, ["Neon|Fly"] = 537.26, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 430.67, ["Mega|Ride"] = 1866.92, ["Mega|Fly|Ride"] = 2018.43}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 16.17, ["Fly"] = 91.9, ["Ride"] = 39.38, ["Fly|Ride"] = 80.07, ["Neon"] = 122.39, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 141.74, ["Neon|Fly|Ride"] = 192.95, ["Mega"] = 542.64, ["Mega|Ride"] = 577.5, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 51.98}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 87.83, ["Fly"] = 144.29, ["Ride"] = 128.08, ["Fly|Ride"] = 430.67, ["Neon"] = 392.44, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 456.75, ["Mega|Ride"] = 1632.64, ["Mega|Fly|Ride"] = 1958.19}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.94, ["Ride"] = 29.09, ["Neon"] = 21.6, ["Neon|Ride"] = 141.06, ["Neon|Fly|Ride"] = 287.48, ["Mega"] = 287.03, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 286.79}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 14.44, ["Fly"] = 56.42, ["Ride"] = 33.39, ["Fly|Ride"] = 95.11, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 214.27, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 586.69}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 603.74, ["Ride"] = 534.45, ["Fly|Ride"] = 498.75, ["Neon|Fly|Ride"] = 2798.21, ["Mega|Fly|Ride"] = 7087.5}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 43.32, ["Ride"] = 65.63, ["Fly|Ride"] = 107.57, ["Neon"] = 195.57, ["Neon|Ride"] = 146.88, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 776.43, ["Mega|Ride"] = 675.07, ["Mega|Fly|Ride"] = 718.1}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 51.07, ["Fly"] = 101.22, ["Ride"] = 82.38, ["Fly|Ride"] = 115.06, ["Neon"] = 574.95, ["Neon|Ride"] = 237.09, ["Neon|Fly|Ride"] = 244.64, ["Mega|Ride"] = 1075.59, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 18.38, ["Ride"] = 65.63, ["Fly|Ride"] = 110.24, ["Neon"] = 85.09, ["Neon|Ride"] = 161.18, ["Neon|Fly|Ride"] = 202.13, ["Mega"] = 288.75, ["Mega|Ride"] = 580.46, ["Mega|Fly|Ride"] = 574.95}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11025, ["Fly"] = 10500, ["Ride"] = 8862, ["Fly|Ride"] = 7873.69, ["Neon|Fly|Ride"] = 14766.25, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1351.88, ["Fly"] = 1517.02, ["Ride"] = 1666.47, ["Fly|Ride"] = 1410.92, ["Neon|Fly|Ride"] = 3724.88, ["Mega|Fly|Ride"] = 15667.2}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 585.03, ["Ride"] = 459.38, ["Fly|Ride"] = 796.35, ["Neon"] = 2253.58, ["Neon|Fly|Ride"] = 3084.38, ["Mega"] = 21527.73, ["Mega|Fly|Ride"] = 9790.86}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 12.89, ["Fly"] = 32.31, ["Ride"] = 24.13, ["Fly|Ride"] = 43.31, ["Neon"] = 91.35, ["Neon|Ride"] = 86.17, ["Neon|Fly|Ride"] = 131.25, ["Mega|Fly|Ride"] = 539.44}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 4.81, ["Fly"] = 78.74, ["Ride"] = 37.4, ["Fly|Ride"] = 198.13, ["Neon"] = 24.94, ["Neon|Ride"] = 73.78, ["Mega"] = 249.38, ["Mega|Ride"] = 218.98, ["Mega|Fly|Ride"] = 342.4}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 36.94, ["Fly"] = 83.91, ["Ride"] = 53.23, ["Fly|Ride"] = 91.88, ["Neon"] = 550.66, ["Neon|Fly"] = 144.29, ["Neon|Ride"] = 171.94, ["Neon|Fly|Ride"] = 205.83, ["Mega"] = 930.15, ["Mega|Fly|Ride"] = 1065.49}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.56, ["Fly"] = 33.39, ["Ride"] = 16.91, ["Fly|Ride"] = 38.06, ["Neon"] = 42.68, ["Neon|Fly"] = 83.86, ["Neon|Ride"] = 44.46, ["Neon|Fly|Ride"] = 90.95, ["Mega"] = 326.8, ["Mega|Ride"] = 359.62, ["Mega|Fly|Ride"] = 260.39}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 306.79, ["Fly"] = 367.5, ["Ride"] = 315, ["Fly|Ride"] = 413.44, ["Neon|Ride"] = 1205.86, ["Neon|Fly|Ride"] = 1353.19, ["Mega|Fly|Ride"] = 4746.34}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 31.26, ["Fly"] = 90.04, ["Ride"] = 40.68, ["Fly|Ride"] = 84, ["Neon"] = 144.38, ["Neon|Fly"] = 411.41, ["Neon|Ride"] = 171.21, ["Neon|Fly|Ride"] = 209.88, ["Mega"] = 861.33, ["Mega|Fly"] = 914.23, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 11.81, ["Fly"] = 24.06, ["Ride"] = 23.63, ["Fly|Ride"] = 46.52, ["Neon"] = 287.48, ["Neon|Fly"] = 121.69, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 129.65, ["Mega"] = 1575, ["Mega|Ride"] = 451.5, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 445.69, ["Fly"] = 1048.69, ["Ride"] = 485.63, ["Fly|Ride"] = 861.33, ["Mega|Fly|Ride"] = 9971.07}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1099.88, ["Fly"] = 1436.26, ["Ride"] = 1060.5, ["Fly|Ride"] = 1283.63, ["Neon"] = 5252.2, ["Neon|Ride"] = 4881.52, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13782.3}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 122.39, ["Fly"] = 144.29, ["Ride"] = 140.77, ["Fly|Ride"] = 144.38, ["Neon"] = 971.25, ["Neon|Ride"] = 979.1, ["Neon|Fly|Ride"] = 505.31, ["Mega|Ride"] = 2581.82, ["Mega|Fly|Ride"] = 2870.36}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 175.31, ["Fly"] = 196.88, ["Ride"] = 200.09, ["Fly|Ride"] = 260.76, ["Neon|Ride"] = 640.62, ["Neon|Fly|Ride"] = 677.25, ["Mega|Ride"] = 9187.5, ["Mega|Fly|Ride"] = 2892.75}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 31.91, ["Fly"] = 123.83, ["Ride"] = 54.93, ["Fly|Ride"] = 101.13, ["Neon"] = 262.4, ["Neon|Ride"] = 243, ["Mega|Ride"] = 2152.53, ["Mega|Fly|Ride"] = 1095.36}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 270.24, ["Ride"] = 646.14, ["Fly|Ride"] = 574.95, ["Neon"] = 1220.63, ["Mega|Fly|Ride"] = 5742.83}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2008.13, ["Ride"] = 2439.77, ["Fly|Ride"] = 2099.9, ["Neon"] = 10762.58, ["Neon|Fly|Ride"] = 10766.45, ["Mega|Fly|Ride"] = 49525.66}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 57.56, ["Fly"] = 215.34, ["Ride"] = 52.5, ["Fly|Ride"] = 196.88, ["Neon"] = 288.75, ["Neon|Ride"] = 165.82, ["Neon|Fly|Ride"] = 343.3, ["Mega|Ride"] = 1191.86, ["Mega|Fly|Ride"] = 1150.99}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 648.36, ["Fly"] = 861.33, ["Ride"] = 623.69, ["Fly|Ride"] = 643.13, ["Neon"] = 1591.03, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 3398.73}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 52.18, ["Fly"] = 72.19, ["Ride"] = 57.86, ["Fly|Ride"] = 107.87, ["Neon"] = 430.67, ["Neon|Ride"] = 244.78, ["Neon|Fly|Ride"] = 181.92, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 5.16, ["Fly"] = 34.12, ["Ride"] = 23.18, ["Fly|Ride"] = 53.45, ["Neon"] = 30.16, ["Neon|Fly"] = 136.76, ["Neon|Ride"] = 44.37, ["Neon|Fly|Ride"] = 103.57, ["Mega"] = 201.17, ["Mega|Fly"] = 254.05, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 274.31}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 65.61, ["Ride"] = 65.63, ["Fly|Ride"] = 157.5, ["Neon"] = 397.48, ["Neon|Ride"] = 486.34, ["Neon|Fly|Ride"] = 718.13, ["Mega"] = 1613.91, ["Mega|Ride"] = 1722.03, ["Mega|Fly|Ride"] = 1708.03}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 1138.55, ["Ride"] = 1060.5, ["Fly|Ride"] = 1073.63, ["Neon|Ride"] = 3694.69, ["Neon|Fly|Ride"] = 3443.12, ["Mega|Fly|Ride"] = 14355.99}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 708.74, ["Ride"] = 816.33, ["Fly|Ride"] = 979.1, ["Neon|Fly|Ride"] = 4306.59, ["Mega|Fly|Ride"] = 20097.74}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 15.32, ["Fly"] = 32.95, ["Ride"] = 23.9, ["Fly|Ride"] = 45.94, ["Neon"] = 144.38, ["Neon|Ride"] = 117.14, ["Neon|Fly|Ride"] = 117.24, ["Mega|Fly|Ride"] = 777.34}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 25.13, ["Ride"] = 81.8, ["Fly|Ride"] = 129.21, ["Neon"] = 275.63, ["Neon|Ride"] = 281.47, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1632.64, ["Mega|Ride"] = 1428.72, ["Mega|Fly|Ride"] = 1076.25}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.5, ["Fly"] = 48.96, ["Ride"] = 33.28, ["Fly|Ride"] = 98.98, ["Neon"] = 22.03, ["Neon|Fly"] = 326.27, ["Neon|Ride"] = 64.29, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 188.62, ["Mega|Fly"] = 571.62, ["Mega|Ride"] = 205.8, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 42.7, ["Fly"] = 60.36, ["Ride"] = 52.33, ["Fly|Ride"] = 116.75, ["Neon"] = 317.55, ["Neon|Ride"] = 220.5, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 786.19}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 104.98, ["Ride"] = 287.37, ["Fly|Ride"] = 359.62, ["Neon"] = 545.74, ["Neon|Ride"] = 603.75, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1874.25, ["Mega|Fly|Ride"] = 2572.5}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 15.73, ["Fly"] = 59.07, ["Ride"] = 43.21, ["Fly|Ride"] = 84.5, ["Neon"] = 131.25, ["Neon|Ride"] = 97.86, ["Neon|Fly|Ride"] = 251.95, ["Mega"] = 430.67, ["Mega|Ride"] = 406.67, ["Mega|Fly|Ride"] = 532.95}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 35.6, ["Fly"] = 65.54, ["Ride"] = 44.63, ["Fly|Ride"] = 78.49, ["Neon"] = 242.82, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 235.59, ["Mega"] = 2100, ["Mega|Ride"] = 1119.72, ["Mega|Fly|Ride"] = 2286.18}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.56, ["Fly"] = 56.6, ["Ride"] = 22.23, ["Fly|Ride"] = 45.82, ["Neon"] = 35.34, ["Neon|Ride"] = 39.67, ["Neon|Fly|Ride"] = 114.14, ["Mega"] = 223.13, ["Mega|Ride"] = 489.56, ["Mega|Fly|Ride"] = 366.19}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 8.97, ["Fly"] = 65.63, ["Ride"] = 35.44, ["Fly|Ride"] = 106.5, ["Neon"] = 101.46, ["Neon|Fly"] = 115.54, ["Neon|Ride"] = 82.3, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 380.63, ["Mega|Ride"] = 481.32, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 47.29, ["Fly"] = 72.19, ["Ride"] = 54.03, ["Fly|Ride"] = 85.32, ["Neon"] = 572.87, ["Neon|Ride"] = 206.87, ["Neon|Fly|Ride"] = 330.56, ["Mega|Fly|Ride"] = 1074.94}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1722.02, ["Fly"] = 1903.13, ["Ride"] = 1476.57, ["Fly|Ride"] = 1410.94, ["Neon|Fly|Ride"] = 3478.13, ["Mega|Fly|Ride"] = 13013.69}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 498.74, ["Fly"] = 679.38, ["Ride"] = 525, ["Fly|Ride"] = 572.24, ["Neon|Ride"] = 2380.47, ["Neon|Fly|Ride"] = 2332.32, ["Mega|Fly|Ride"] = 9724.7}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 288.74, ["Fly"] = 483.45, ["Ride"] = 315, ["Fly|Ride"] = 446.25, ["Neon"] = 1312.5, ["Neon|Ride"] = 1579.46, ["Neon|Fly|Ride"] = 1640.63}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 45.9}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 31.5, ["Ride"] = 49.79, ["Fly|Ride"] = 172.29, ["Neon"] = 299.92, ["Neon|Ride"] = 317.63, ["Neon|Fly|Ride"] = 518.44, ["Mega|Ride"] = 1722.24, ["Mega|Fly|Ride"] = 1036.54}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 70875, ["Fly"] = 25618.23, ["Ride"] = 37536.4, ["Fly|Ride"] = 21525, ["Neon|Fly|Ride"] = 33468.75, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 266.37, ["Fly"] = 328.01, ["Ride"] = 305.01, ["Fly|Ride"] = 373.86, ["Neon"] = 1039.98, ["Neon|Ride"] = 1032.93, ["Neon|Fly|Ride"] = 931.88, ["Mega"] = 6458.33, ["Mega|Fly|Ride"] = 3281.33}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 158.81, ["Fly"] = 525, ["Ride"] = 165.83, ["Fly|Ride"] = 321.93}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 98.44, ["Fly"] = 215.34, ["Ride"] = 113.12, ["Fly|Ride"] = 182.44, ["Neon|Ride"] = 719.24, ["Neon|Fly|Ride"] = 587.46, ["Mega|Fly|Ride"] = 2887.5}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 17.85, ["Fly"] = 62.46, ["Ride"] = 35.44, ["Fly|Ride"] = 65.63, ["Neon"] = 164.01, ["Neon|Fly"] = 105, ["Neon|Ride"] = 155.07, ["Neon|Fly|Ride"] = 235.81, ["Mega"] = 1968.75, ["Mega|Ride"] = 717.96, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4095, ["Ride"] = 4058.25, ["Fly|Ride"] = 3976.88, ["Neon"] = 21527.73, ["Neon|Fly|Ride"] = 15750, ["Mega|Fly|Ride"] = 81584.52}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 30.49, ["Fly"] = 52.41, ["Ride"] = 31.27, ["Fly|Ride"] = 64.84, ["Neon"] = 201.44, ["Neon|Ride"] = 167.19, ["Neon|Fly|Ride"] = 184.43, ["Mega|Ride"] = 1436.26, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 36.73, ["Fly"] = 92.61, ["Ride"] = 35.44, ["Fly|Ride"] = 91.54, ["Neon"] = 308.9, ["Neon|Fly"] = 1436.26, ["Neon|Ride"] = 202.79, ["Neon|Fly|Ride"] = 342.4, ["Mega|Fly|Ride"] = 1601.25}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 443, ["Fly"] = 563.07, ["Ride"] = 470.76, ["Fly|Ride"] = 545.3, ["Neon"] = 1410.94, ["Neon|Ride"] = 1141.87, ["Neon|Fly|Ride"] = 1186.5, ["Mega|Fly|Ride"] = 4589.28}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 16.42, ["Fly"] = 30.86, ["Ride"] = 24.6, ["Fly|Ride"] = 52.89, ["Neon"] = 131.25, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 144.38, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 836.34}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 14.34, ["Fly"] = 287.48, ["Ride"] = 35.43, ["Fly|Ride"] = 80.79, ["Neon"] = 122.75, ["Neon|Ride"] = 131.15, ["Neon|Fly|Ride"] = 217.7, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 734.32}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 85.31, ["Ride"] = 96.45, ["Fly|Ride"] = 245.44, ["Neon"] = 1010.63, ["Neon|Ride"] = 511.88, ["Neon|Fly|Ride"] = 688, ["Mega|Fly|Ride"] = 4082.06}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 15.28, ["Fly"] = 538.05, ["Ride"] = 76.71, ["Fly|Ride"] = 139.76, ["Neon"] = 78.07, ["Neon|Ride"] = 172.29, ["Neon|Fly|Ride"] = 326.8, ["Mega"] = 308.36, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 288.1, ["Mega|Fly|Ride"] = 474.81}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 5643.75, ["Ride"] = 4856.25, ["Fly|Ride"] = 4856.25, ["Neon"] = 19687.5, ["Neon|Ride"] = 14686.28, ["Neon|Fly|Ride"] = 11025, ["Mega"] = 51248.29, ["Mega|Fly|Ride"] = 37945.69}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 39.12, ["Fly"] = 144.29, ["Ride"] = 61.69, ["Fly|Ride"] = 179.82, ["Neon"] = 233.62, ["Neon|Ride"] = 270.5, ["Neon|Fly|Ride"] = 359.62, ["Mega"] = 1220.92, ["Mega|Ride"] = 1795.27, ["Mega|Fly|Ride"] = 784.88}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 6562.49, ["Ride"] = 6857.82, ["Fly|Ride"] = 6209.97, ["Neon|Fly|Ride"] = 15225, ["Mega|Fly|Ride"] = 46921.88}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.48, ["Fly"] = 21, ["Ride"] = 18.27, ["Fly|Ride"] = 36.65, ["Neon"] = 39.38, ["Neon|Fly"] = 62.74, ["Neon|Ride"] = 49.55, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 240.11, ["Mega|Fly"] = 1436.26, ["Mega|Ride"] = 213.22, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 18.38, ["Fly"] = 28.49, ["Ride"] = 32.31, ["Fly|Ride"] = 59.07, ["Neon"] = 91.94, ["Neon|Fly"] = 237.96, ["Neon|Ride"] = 141.06, ["Neon|Fly|Ride"] = 142.93, ["Mega|Ride"] = 880.04, ["Mega|Fly|Ride"] = 861.33}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 4.33}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 12.36, ["Fly"] = 39.37, ["Ride"] = 33.75, ["Fly|Ride"] = 115.49, ["Neon"] = 131.25, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 1049.9, ["Mega|Ride"] = 1147.44, ["Mega|Fly|Ride"] = 1305.87}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 28, ["Fly"] = 190.37, ["Ride"] = 43.09, ["Fly|Ride"] = 152.91, ["Neon"] = 244.44, ["Neon|Ride"] = 201.36, ["Neon|Fly|Ride"] = 313.34, ["Mega|Ride"] = 979.09, ["Mega|Fly|Ride"] = 922.31}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 14.84, ["Fly"] = 29.07, ["Ride"] = 20.51, ["Fly|Ride"] = 43.32, ["Neon|Fly"] = 1073.04, ["Neon|Ride"] = 107.68, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 1129.01, ["Mega|Fly|Ride"] = 661.08}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 6628.13}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 3071.25}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 25.17}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 236.25, ["Ride"] = 375.74, ["Fly|Ride"] = 341.24, ["Neon|Fly|Ride"] = 1209.33}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 14.44, ["Fly"] = 52.5, ["Ride"] = 37.95, ["Fly|Ride"] = 103.69, ["Neon"] = 144.29, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 265.13, ["Mega|Fly|Ride"] = 558.79}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 11.82}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.04, ["Ride"] = 26.24, ["Fly|Ride"] = 86.17, ["Neon"] = 144.29, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 131.25, ["Mega|Fly|Ride"] = 496.12}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2545.31}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 254.35, ["Fly"] = 430.67, ["Ride"] = 195.83, ["Fly|Ride"] = 734.32, ["Neon"] = 1048.69, ["Neon|Ride"] = 1078.25, ["Neon|Fly|Ride"] = 1075.59, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 65.1, ["Fly"] = 215.34, ["Ride"] = 102.3, ["Fly|Ride"] = 525, ["Neon"] = 416.13, ["Neon|Ride"] = 367.49, ["Neon|Fly|Ride"] = 489.56, ["Mega|Fly|Ride"] = 2151.15}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 171.92, ["Fly"] = 261.92, ["Ride"] = 164.03, ["Fly|Ride"] = 214.18, ["Neon"] = 945, ["Neon|Ride"] = 741.57, ["Neon|Fly|Ride"] = 748.12, ["Mega|Ride"] = 3660.61, ["Mega|Fly|Ride"] = 3408.34}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2762.75, ["Ride"] = 2756.25, ["Fly|Ride"] = 2883.56, ["Neon"] = 15122.56, ["Neon|Ride"] = 8188.41, ["Neon|Fly|Ride"] = 8613.17, ["Mega|Fly|Ride"] = 31499.99}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 21, ["Fly"] = 106.61, ["Ride"] = 45.94, ["Fly|Ride"] = 86.46, ["Neon"] = 127.32, ["Neon|Ride"] = 286.4, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 967.92, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 918.75, ["Fly"] = 2231.25, ["Ride"] = 707.44, ["Fly|Ride"] = 1722.65, ["Neon|Fly|Ride"] = 5382.18}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 58.1}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 21.33, ["Fly"] = 97.99, ["Ride"] = 48.57, ["Fly|Ride"] = 245.44, ["Neon"] = 115.5, ["Neon|Ride"] = 133.52, ["Neon|Fly|Ride"] = 262.71, ["Mega"] = 390.68, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 493.77}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 9.17, ["Fly"] = 51.41, ["Ride"] = 31.13, ["Fly|Ride"] = 75.9, ["Neon"] = 72.19, ["Neon|Fly"] = 315, ["Neon|Ride"] = 66.09, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 457.79, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 370.38}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 61.14}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 22.32, ["Fly"] = 64.61, ["Ride"] = 36.62, ["Fly|Ride"] = 65.63, ["Neon"] = 139.91, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 254.63, ["Mega|Ride"] = 1291.99, ["Mega|Fly|Ride"] = 860.26}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 27.45, ["Fly"] = 50.61, ["Ride"] = 32.06, ["Fly|Ride"] = 63, ["Neon"] = 164.01, ["Neon|Fly"] = 287.48, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 286.4, ["Mega"] = 1435.92, ["Mega|Ride"] = 1835.76, ["Mega|Fly|Ride"] = 871.5}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6734.81, ["Fly"] = 5775, ["Ride"] = 6613.95, ["Fly|Ride"] = 5105.63, ["Neon|Fly|Ride"] = 10484.25, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 10.5, ["Fly"] = 49.55, ["Ride"] = 32.82, ["Fly|Ride"] = 81.84, ["Neon"] = 57.18, ["Neon|Ride"] = 95.7, ["Neon|Fly|Ride"] = 233.77, ["Mega"] = 354.38, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 24.65}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 103.42, ["Fly"] = 381.06, ["Ride"] = 129.15, ["Fly|Ride"] = 262.5, ["Neon"] = 531.57, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 526.24, ["Mega"] = 2879.59, ["Mega|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 1826.01}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 59.05, ["Fly"] = 200.8, ["Ride"] = 100.03, ["Fly|Ride"] = 178.28, ["Neon"] = 353.15, ["Neon|Fly"] = 391.65, ["Neon|Ride"] = 316.32, ["Neon|Fly|Ride"] = 329.04, ["Mega"] = 1220.92, ["Mega|Ride"] = 1235.68, ["Mega|Fly|Ride"] = 1200.94}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 26.32, ["Fly"] = 81.84, ["Ride"] = 32.71, ["Fly|Ride"] = 57.75, ["Neon"] = 141.75, ["Neon|Fly"] = 232.57, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 192.94, ["Mega"] = 1016.21, ["Mega|Fly|Ride"] = 979.02}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 4.33, ["Fly"] = 78.75, ["Ride"] = 28.55, ["Fly|Ride"] = 129.21, ["Neon"] = 37.69, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 174.57, ["Mega"] = 325.5, ["Mega|Fly"] = 7178, ["Mega|Ride"] = 298.54, ["Mega|Fly|Ride"] = 354.37}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 16.46, ["Fly"] = 63.67, ["Ride"] = 33.78, ["Fly|Ride"] = 93.69, ["Neon"] = 85.05, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 228.26, ["Mega"] = 380.63, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 24.46, ["Fly"] = 32.42, ["Ride"] = 28.04, ["Fly|Ride"] = 55.7, ["Neon"] = 183.05, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 177.19, ["Mega|Fly|Ride"] = 577.46}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 191.65}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 36.54, ["Ride"] = 286.4, ["Fly|Ride"] = 288.51, ["Neon"] = 169.32, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 460.82, ["Mega"] = 866.25, ["Mega|Fly|Ride"] = 791.31}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 525, ["Ride"] = 1436.26, ["Neon|Fly|Ride"] = 71776.68}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 66.2, ["Ride"] = 89.64, ["Fly|Ride"] = 215.34, ["Neon"] = 216.57, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 1182.57, ["Mega|Ride"] = 2286.01, ["Mega|Fly|Ride"] = 1488.47}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 1312.5, ["Fly"] = 1246.67, ["Ride"] = 1233.75, ["Fly|Ride"] = 1304.91, ["Neon"] = 4711.87, ["Neon|Fly"] = 4711.87, ["Neon|Ride"] = 3675, ["Neon|Fly|Ride"] = 3150, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 420, ["Fly"] = 816.33, ["Ride"] = 483, ["Fly|Ride"] = 615.6, ["Neon"] = 4306.59, ["Neon|Ride"] = 7751.86, ["Neon|Fly|Ride"] = 2033.07, ["Mega"] = 12600, ["Mega|Fly|Ride"] = 9973.69}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 61.69}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 3.33}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 11.58, ["Fly"] = 31.82, ["Ride"] = 24.94, ["Fly|Ride"] = 53.83, ["Neon"] = 82.01, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 85.07, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 437.26, ["Mega|Ride"] = 653.52, ["Mega|Fly|Ride"] = 570.94}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 225.65, ["Fly"] = 459.38, ["Ride"] = 295.32, ["Fly|Ride"] = 386.27, ["Neon"] = 851.82, ["Neon|Ride"] = 759.94, ["Neon|Fly|Ride"] = 874.13, ["Mega|Fly|Ride"] = 3582.01}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 18.04}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 114.09, ["Ride"] = 168.91, ["Fly|Ride"] = 298.19, ["Neon"] = 685.28, ["Neon|Fly"] = 610.32, ["Neon|Ride"] = 720.57, ["Neon|Fly|Ride"] = 691.69, ["Mega"] = 2799.29, ["Mega|Ride"] = 2570.11, ["Mega|Fly|Ride"] = 2395.32}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 125.89, ["Fly"] = 310.92, ["Ride"] = 131.15, ["Fly|Ride"] = 273.38, ["Neon"] = 1019.6, ["Neon|Ride"] = 1032.94, ["Neon|Fly|Ride"] = 931.88, ["Mega|Fly|Ride"] = 2149}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 3.82, ["Ride"] = 28.17, ["Fly|Ride"] = 729.75, ["Neon"] = 32.72, ["Neon|Ride"] = 69.62, ["Neon|Fly|Ride"] = 282.11, ["Mega"] = 168.92, ["Mega|Ride"] = 230.9, ["Mega|Fly|Ride"] = 377.92}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 16.26, ["Fly"] = 50.93, ["Ride"] = 28.92, ["Fly|Ride"] = 69.57, ["Neon"] = 110.25, ["Neon|Ride"] = 110.44, ["Neon|Fly|Ride"] = 236.25, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 16.95, ["Fly"] = 102.36, ["Ride"] = 36.75, ["Fly|Ride"] = 131.25, ["Neon"] = 85.31, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 287.44, ["Mega"] = 498.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 492.19}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 4.45, ["Fly"] = 141.05, ["Ride"] = 48.47, ["Fly|Ride"] = 168, ["Neon"] = 43.36, ["Neon|Ride"] = 65.4, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 196.88, ["Mega|Ride"] = 187.81, ["Mega|Fly|Ride"] = 297.24}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 293.5, ["Ride"] = 324.18, ["Fly|Ride"] = 367.49, ["Neon|Ride"] = 1405, ["Neon|Fly|Ride"] = 1409.82, ["Mega|Fly|Ride"] = 6647.21}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 91.87, ["Fly"] = 574.95, ["Ride"] = 129.93, ["Fly|Ride"] = 233.47, ["Neon"] = 435.29, ["Neon|Ride"] = 632, ["Neon|Fly|Ride"] = 514.48, ["Mega"] = 2022.57, ["Mega|Ride"] = 2045.64, ["Mega|Fly|Ride"] = 2086.88}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 69.57, ["Fly"] = 167.45, ["Ride"] = 78.45, ["Fly|Ride"] = 124.64, ["Neon"] = 262.5, ["Neon|Ride"] = 341.23, ["Neon|Fly|Ride"] = 359.62, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1374.18}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 23.54, ["Fly"] = 127.32, ["Ride"] = 53.85, ["Neon|Ride"] = 621.73, ["Neon|Fly|Ride"] = 326.8, ["Mega|Fly|Ride"] = 1005.6}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 14.95, ["Ride"] = 32.82, ["Fly|Ride"] = 70.74, ["Neon"] = 144.24, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 209.99, ["Mega"] = 807.19, ["Mega|Ride"] = 523.82, ["Mega|Fly|Ride"] = 614.09}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 2.17, ["Fly"] = 52.5, ["Ride"] = 25.85, ["Fly|Ride"] = 68.25, ["Neon"] = 31.5, ["Neon|Ride"] = 41.91, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 273.49, ["Mega|Ride"] = 346.5, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 853.13, ["Fly"] = 918.75, ["Ride"] = 997.5, ["Fly|Ride"] = 853.13, ["Neon"] = 4306.59, ["Neon|Ride"] = 8613.17, ["Neon|Fly|Ride"] = 2428.13, ["Mega|Fly|Ride"] = 8098.23}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 245.63, ["Fly"] = 363.92, ["Ride"] = 295.32, ["Fly|Ride"] = 326.81, ["Neon|Ride"] = 1721.56, ["Neon|Fly|Ride"] = 1220.92, ["Mega"] = 10763.87, ["Mega|Fly|Ride"] = 5335.87}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 99.47, ["Fly"] = 128.87, ["Ride"] = 118.02, ["Fly|Ride"] = 144.38, ["Neon"] = 426.57, ["Neon|Ride"] = 428.79, ["Neon|Fly|Ride"] = 534.02, ["Mega"] = 1575, ["Mega|Ride"] = 1751.73, ["Mega|Fly|Ride"] = 1877.14}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 210, ["Fly"] = 254.1, ["Ride"] = 208.36, ["Fly|Ride"] = 240.19, ["Neon|Ride"] = 1143.23, ["Neon|Fly|Ride"] = 1074.77, ["Mega"] = 10763.87, ["Mega|Fly|Ride"] = 4081.58}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 20.48, ["Fly"] = 52.5, ["Ride"] = 31.26, ["Fly|Ride"] = 80.56, ["Neon"] = 170.63, ["Neon|Ride"] = 142.22, ["Neon|Fly|Ride"] = 231.55}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 210, ["Ride"] = 328.38, ["Fly|Ride"] = 391.65, ["Neon"] = 1584.98, ["Neon|Ride"] = 942.38, ["Neon|Fly|Ride"] = 1165.5, ["Mega"] = 4283.82, ["Mega|Fly|Ride"] = 4895.43}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 97.89, ["Ride"] = 98.51, ["Fly|Ride"] = 131.23, ["Neon|Ride"] = 1632.51, ["Neon|Fly|Ride"] = 498.75, ["Mega|Ride"] = 2297.03, ["Mega|Fly|Ride"] = 1821.75}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 2361.19, ["Ride"] = 2377.75, ["Fly|Ride"] = 2493.75, ["Neon|Ride"] = 11423.48, ["Neon|Fly|Ride"] = 7751.86, ["Mega"] = 51666.55, ["Mega|Fly|Ride"] = 30678.41}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 12.77, ["Fly"] = 60.38, ["Ride"] = 43.13, ["Fly|Ride"] = 91.88, ["Neon"] = 64.96, ["Neon|Fly"] = 173.03, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 194.24, ["Mega"] = 296.63, ["Mega|Ride"] = 386.53, ["Mega|Fly|Ride"] = 374.33}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 45.02, ["Ride"] = 89.24, ["Fly|Ride"] = 148.32, ["Neon"] = 275.52, ["Neon|Ride"] = 224.35, ["Neon|Fly|Ride"] = 431.82, ["Mega|Ride"] = 931.87, ["Mega|Fly|Ride"] = 1497.57}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 98.14, ["Fly"] = 102.16, ["Ride"] = 85.32, ["Fly|Ride"] = 109.95, ["Neon|Ride"] = 497.43, ["Neon|Fly|Ride"] = 402.81, ["Mega|Fly|Ride"] = 1512.03}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2774.82, ["Fly"] = 1632.51, ["Ride"] = 1073.62, ["Fly|Ride"] = 1039.5, ["Neon|Ride"] = 5712.41, ["Neon|Fly|Ride"] = 3937.49, ["Mega"] = 43065.79, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 459.38, ["Fly"] = 859.18, ["Ride"] = 558.87, ["Fly|Ride"] = 818.26, ["Neon|Fly|Ride"] = 2582.9, ["Mega"] = 11304.78}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 73.5, ["Fly"] = 155.07, ["Ride"] = 128.63, ["Fly|Ride"] = 144.42, ["Neon"] = 474.65, ["Neon|Ride"] = 352.99, ["Neon|Fly|Ride"] = 489.56, ["Mega"] = 5740.76, ["Mega|Ride"] = 2611.72, ["Mega|Fly|Ride"] = 1761.38}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 8.87, ["Fly"] = 41.64, ["Ride"] = 25.96, ["Fly|Ride"] = 83.16, ["Neon"] = 85.76, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 148.2, ["Mega"] = 656.25, ["Mega|Ride"] = 823.93}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 45.05, ["Fly"] = 61.39, ["Ride"] = 39.08, ["Fly|Ride"] = 91.88, ["Neon"] = 215.34, ["Neon|Ride"] = 279.95, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 731.11, ["Fly"] = 1125.87, ["Ride"] = 721.87, ["Fly|Ride"] = 820.98, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2230.99, ["Mega|Fly|Ride"] = 8531.25}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 727.79}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 5906.25, ["Ride"] = 5355, ["Fly|Ride"] = 5381.25, ["Neon"] = 42000, ["Neon|Ride"] = 30857.73, ["Neon|Fly|Ride"] = 27565.13, ["Mega|Fly|Ride"] = 93309.56}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 257.25, ["Fly"] = 494.81, ["Ride"] = 317.63, ["Neon"] = 1722.65, ["Neon|Fly|Ride"] = 2152.79, ["Mega"] = 6458.81, ["Mega|Fly|Ride"] = 6457.55}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 78.75, ["Ride"] = 144.37, ["Fly|Ride"] = 190.32, ["Neon"] = 2153.31, ["Neon|Ride"] = 644.93, ["Neon|Fly|Ride"] = 460.82, ["Mega|Fly|Ride"] = 1958.19}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 27.57, ["Fly"] = 102.37, ["Ride"] = 41.49, ["Fly|Ride"] = 97.13, ["Neon"] = 165.82, ["Neon|Ride"] = 171.36, ["Neon|Fly|Ride"] = 245.44, ["Mega|Ride"] = 816.33, ["Mega|Fly|Ride"] = 790.27}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 14.69, ["Fly"] = 32.82, ["Ride"] = 26.81, ["Fly|Ride"] = 52.5, ["Neon"] = 144.29, ["Neon|Fly"] = 287.48, ["Neon|Ride"] = 326.82, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 1312.5, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 2871.42}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 16.94, ["Fly"] = 162.59, ["Ride"] = 37.94, ["Fly|Ride"] = 106.98, ["Neon"] = 111.57, ["Neon|Ride"] = 123.38, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 645.91, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 653.57}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 6.29, ["Fly"] = 36.62, ["Ride"] = 23.63, ["Fly|Ride"] = 58.15, ["Neon"] = 36.39, ["Neon|Fly"] = 355.3, ["Neon|Ride"] = 58.15, ["Neon|Fly|Ride"] = 136.69, ["Mega"] = 675, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 279.3}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 24.86, ["Ride"] = 51.18, ["Fly|Ride"] = 147, ["Neon"] = 115.5, ["Neon|Fly"] = 861.33, ["Neon|Ride"] = 188.28, ["Neon|Fly|Ride"] = 321.93, ["Mega"] = 630, ["Mega|Ride"] = 761.02, ["Mega|Fly|Ride"] = 532.88}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 630, ["Fly"] = 762.57, ["Ride"] = 656.25, ["Fly|Ride"] = 787.5, ["Neon|Ride"] = 2231.25, ["Neon|Fly|Ride"] = 2231.25, ["Mega"] = 9187.5, ["Mega|Fly|Ride"] = 10765.38}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.27, ["Fly"] = 19.69, ["Ride"] = 16.47, ["Fly|Ride"] = 36.75, ["Neon"] = 22.32, ["Neon|Ride"] = 38.59, ["Neon|Fly|Ride"] = 72.12, ["Mega"] = 170.63, ["Mega|Ride"] = 616.35, ["Mega|Fly|Ride"] = 208.69}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 45.71, ["Fly"] = 103.47, ["Ride"] = 83.91, ["Fly|Ride"] = 136.4, ["Neon"] = 199.5, ["Neon|Fly"] = 430.71, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 258.46, ["Mega"] = 564.37, ["Mega|Fly"] = 861.33, ["Mega|Ride"] = 649.58, ["Mega|Fly|Ride"] = 577.12}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 839.99, ["Ride"] = 824.25, ["Fly|Ride"] = 817.2, ["Neon|Ride"] = 2727.58, ["Neon|Fly|Ride"] = 1679.99, ["Mega|Fly|Ride"] = 5098.07}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 42, ["Fly"] = 70.86, ["Ride"] = 52.4, ["Fly|Ride"] = 91.77, ["Neon"] = 249.38, ["Neon|Ride"] = 223.02, ["Neon|Fly|Ride"] = 252, ["Mega"] = 1224.02, ["Mega|Fly|Ride"] = 885.92}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 315.13, ["Fly"] = 318.13, ["Ride"] = 287.76, ["Fly|Ride"] = 341.21, ["Neon|Fly|Ride"] = 1286.25}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 276.69, ["Fly"] = 571.55, ["Ride"] = 328.12, ["Fly|Ride"] = 406.87, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 938.43, ["Mega"] = 5118.75, ["Mega|Fly|Ride"] = 5307.88}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 777.69, ["Ride"] = 737.63, ["Fly|Ride"] = 708.75, ["Neon|Ride"] = 3593.22, ["Neon|Fly|Ride"] = 2493.74, ["Mega|Fly|Ride"] = 9842.44}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 20.45, ["Fly"] = 86.17, ["Ride"] = 50.59, ["Fly|Ride"] = 107.47, ["Neon"] = 80.56, ["Neon|Fly"] = 293.77, ["Neon|Ride"] = 111.37, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 354.38, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 451.5}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3622.49, ["Fly"] = 3543.75, ["Ride"] = 3399.38, ["Fly|Ride"] = 3412.5, ["Neon|Fly|Ride"] = 8027.25, ["Mega|Fly|Ride"] = 19686.19}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 126.04, ["Fly"] = 178.49, ["Ride"] = 170.62, ["Fly|Ride"] = 206.73, ["Neon"] = 550.97, ["Neon|Ride"] = 532.75, ["Neon|Fly|Ride"] = 584.72, ["Mega|Fly|Ride"] = 3425.81}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.28, ["Fly"] = 20.99, ["Ride"] = 20.37, ["Fly|Ride"] = 56.43, ["Neon"] = 21.59, ["Neon|Fly"] = 43.24, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 171.94, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 291.27, ["Mega|Fly|Ride"] = 320.25}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.8, ["Ride"] = 22.32, ["Fly|Ride"] = 72.16, ["Neon"] = 27.56, ["Neon|Fly"] = 119.97, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 214.27, ["Mega|Ride"] = 410.12, ["Mega|Fly|Ride"] = 484.68}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 52.5, ["Fly"] = 39.38, ["Ride"] = 56.36, ["Fly|Ride"] = 57.28, ["Neon"] = 293.74, ["Neon|Ride"] = 409.14, ["Neon|Fly|Ride"] = 274.17, ["Mega|Fly|Ride"] = 1247.86}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 846.57, ["Fly"] = 1175.05, ["Ride"] = 951.57, ["Fly|Ride"] = 1181.25, ["Neon|Ride"] = 11424.82, ["Neon|Fly|Ride"] = 4450.87}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 7436.63, ["Ride"] = 13053.95, ["Fly|Ride"] = 14534.71}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 21, ["Fly"] = 26.17, ["Ride"] = 28.87, ["Fly|Ride"] = 45.59, ["Neon"] = 172.29, ["Neon|Ride"] = 141.09, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 2520, ["Mega|Ride"] = 865.39, ["Mega|Fly|Ride"] = 811.12}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 14.68, ["Ride"] = 32.37, ["Fly|Ride"] = 78.75, ["Neon"] = 102.27, ["Neon|Fly"] = 111.57, ["Neon|Ride"] = 92.3, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 675.63, ["Mega|Ride"] = 528.94, ["Mega|Fly|Ride"] = 501.38}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 135.19, ["Ride"] = 122.33, ["Fly|Ride"] = 172.03, ["Neon|Ride"] = 628.63, ["Neon|Fly|Ride"] = 528.94, ["Mega|Fly|Ride"] = 1573.69}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 236.18, ["Fly"] = 457.79, ["Ride"] = 249.38, ["Fly|Ride"] = 328.13, ["Neon"] = 1306.02, ["Neon|Ride"] = 934.76, ["Neon|Fly|Ride"] = 1039.5, ["Mega"] = 10766.45, ["Mega|Ride"] = 4153.46, ["Mega|Fly|Ride"] = 3127.69}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 5.18, ["Ride"] = 31.38, ["Fly|Ride"] = 65.63, ["Neon"] = 35.07, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 64.31, ["Mega"] = 170.63, ["Mega|Fly"] = 240.11, ["Mega|Ride"] = 159.36, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 194.04, ["Fly"] = 258.32, ["Ride"] = 220.43, ["Fly|Ride"] = 301.87, ["Neon"] = 721.88, ["Neon|Ride"] = 715.32, ["Neon|Fly|Ride"] = 708.75, ["Mega|Fly|Ride"] = 3213.12}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 4.12, ["Fly"] = 32.82, ["Ride"] = 13.13, ["Fly|Ride"] = 49.65, ["Neon"] = 24.28, ["Neon|Fly"] = 129.21, ["Neon|Ride"] = 33.37, ["Neon|Fly|Ride"] = 119.53, ["Mega"] = 416.69, ["Mega|Fly"] = 287.48, ["Mega|Ride"] = 219.19, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 297.94, ["Fly"] = 354.38, ["Ride"] = 341.25, ["Fly|Ride"] = 347.82, ["Neon|Ride"] = 1436.25, ["Neon|Fly|Ride"] = 1246.88, ["Mega"] = 10763.87, ["Mega|Fly|Ride"] = 5548.98}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 12.01, ["Fly"] = 104.99, ["Ride"] = 29.25, ["Fly|Ride"] = 66.11, ["Neon"] = 90.55, ["Neon|Fly"] = 310.86, ["Neon|Ride"] = 144.29, ["Neon|Fly|Ride"] = 194.91, ["Mega"] = 574.81, ["Mega|Ride"] = 443.6, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Fly"] = 72.16, ["Ride"] = 25.65, ["Neon"] = 11.68, ["Neon|Fly"] = 170.46, ["Neon|Ride"] = 49.86, ["Neon|Fly|Ride"] = 144.29, ["Mega"] = 101.62, ["Mega|Ride"] = 574.81, ["Mega|Fly|Ride"] = 287.44}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 5.8, ["Mega"] = 23.17, ["Mega|Ride"] = 155.07, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 322.89, ["Fly|Ride"] = 86.62, ["Neon"] = 6.7, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 60.74, ["Mega|Fly"] = 191720.66, ["Mega|Ride"] = 142.01, ["Mega|Fly|Ride"] = 225.3}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 73.5, ["Fly"] = 286.13, ["Ride"] = 115.9, ["Fly|Ride"] = 186.25, ["Neon"] = 288.75, ["Neon|Ride"] = 309.23, ["Neon|Fly|Ride"] = 328.12, ["Mega|Ride"] = 1233.75, ["Mega|Fly|Ride"] = 1311.18}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 37.95, ["Ride"] = 16.41, ["Fly|Ride"] = 42.45, ["Neon"] = 5.91, ["Neon|Ride"] = 33.06, ["Neon|Fly|Ride"] = 70.68, ["Mega"] = 107.68, ["Mega|Ride"] = 165.38, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 11.46, ["Neon"] = 112.02, ["Neon|Fly"] = 361.05, ["Neon|Ride"] = 315, ["Mega"] = 420, ["Mega|Ride"] = 571.55, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Neon"] = 2.1, ["Neon|Ride"] = 59.07, ["Mega"] = 24.94, ["Mega|Fly"] = 50.1, ["Mega|Fly|Ride"] = 256.29}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 86.43, ["Ride"] = 12.99, ["Fly|Ride"] = 196.88, ["Neon"] = 2.1, ["Neon|Fly"] = 43.09, ["Neon|Ride"] = 15.32, ["Neon|Fly|Ride"] = 41.99, ["Mega"] = 13.12, ["Mega|Fly"] = 37.68, ["Mega|Ride"] = 18.99, ["Mega|Fly|Ride"] = 59.17}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 25.15, ["Ride"] = 16.16, ["Fly|Ride"] = 59.07, ["Neon"] = 2.1, ["Neon|Fly"] = 27.28, ["Neon|Ride"] = 16.88, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 18.38, ["Mega|Fly"] = 164.04, ["Mega|Ride"] = 42.83, ["Mega|Fly|Ride"] = 93.07}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 65.63, ["Mega"] = 20.31, ["Mega|Ride"] = 89.25, ["Mega|Fly|Ride"] = 243.33}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 117.94, ["Ride"] = 29.09, ["Fly|Ride"] = 52.5, ["Neon"] = 5.96, ["Neon|Fly"] = 287.48, ["Neon|Ride"] = 24.44, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 39.16, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 43.32, ["Mega|Fly|Ride"] = 95.92}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Fly"] = 21, ["Neon|Ride"] = 83.82, ["Mega"] = 17.98, ["Mega|Ride"] = 99.75}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 12.9, ["Fly"] = 53.13, ["Ride"] = 27.56, ["Fly|Ride"] = 105, ["Neon"] = 61.05, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 315, ["Mega"] = 247.7, ["Mega|Ride"] = 360.91, ["Mega|Fly|Ride"] = 379.7}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 82.78, ["Neon"] = 2.1, ["Neon|Ride"] = 34.46, ["Mega"] = 26.24, ["Mega|Fly"] = 149.35, ["Mega|Ride"] = 49.86, ["Mega|Fly|Ride"] = 157.4}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly|Ride"] = 52.5, ["Neon"] = 22.82, ["Mega"] = 120.64, ["Mega|Fly"] = 315, ["Mega|Ride"] = 183.75}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.6, ["Ride"] = 26.24, ["Fly|Ride"] = 43.09, ["Neon"] = 23.28, ["Mega"] = 134.96, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Fly"] = 144.24, ["Ride"] = 32.82, ["Neon"] = 2.47, ["Neon|Ride"] = 27.97, ["Neon|Fly|Ride"] = 144.29, ["Mega"] = 22.32, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 104.99}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.6, ["Ride"] = 12.88, ["Fly|Ride"] = 40.69, ["Neon"] = 2.1, ["Neon|Fly"] = 35.32, ["Neon|Ride"] = 9.19, ["Neon|Fly|Ride"] = 34.12, ["Mega"] = 16.51, ["Mega|Fly"] = 28.79, ["Mega|Ride"] = 19.9, ["Mega|Fly|Ride"] = 56.43}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 54.28, ["Fly|Ride"] = 118.12, ["Neon"] = 41.94, ["Neon|Ride"] = 103.95, ["Neon|Fly|Ride"] = 717.96, ["Mega"] = 144.38, ["Mega|Ride"] = 241.5}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 43.1, ["Neon"] = 4.43, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 28.87, ["Neon|Fly|Ride"] = 80.77, ["Mega"] = 30.19, ["Mega|Ride"] = 41.91, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 6.13, ["Neon"] = 18.09, ["Neon|Ride"] = 195.11, ["Mega"] = 111.57, ["Mega|Ride"] = 144.27, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 83.03, ["Ride"] = 34.53, ["Fly|Ride"] = 65.63, ["Neon"] = 15.75, ["Neon|Ride"] = 104.85, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 131.25, ["Mega|Ride"] = 164.01, ["Mega|Fly|Ride"] = 196.87}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 12.11, ["Ride"] = 10.5, ["Fly|Ride"] = 37.7, ["Neon"] = 2.1, ["Neon|Fly"] = 19.39, ["Neon|Ride"] = 15.62, ["Neon|Fly|Ride"] = 31.5, ["Mega"] = 15.73, ["Mega|Fly"] = 28.79, ["Mega|Ride"] = 18.26, ["Mega|Fly|Ride"] = 107.68}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 44.12, ["Ride"] = 27.09, ["Fly|Ride"] = 131.25, ["Neon"] = 14.34, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 129.68, ["Mega|Ride"] = 162.32, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 5.81, ["Fly"] = 118.13, ["Ride"] = 144.27, ["Fly|Ride"] = 93.19, ["Neon"] = 58.76, ["Neon|Ride"] = 72.16, ["Neon|Fly|Ride"] = 172.29, ["Mega"] = 288.75, ["Mega|Ride"] = 300.54, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 144.29, ["Ride"] = 14.41, ["Fly|Ride"] = 41.02, ["Neon"] = 2.1, ["Neon|Fly"] = 26.24, ["Neon|Ride"] = 13.65, ["Neon|Fly|Ride"] = 49.03, ["Mega"] = 28.01, ["Mega|Fly"] = 35.3, ["Mega|Ride"] = 39.24, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 3.93, ["Fly"] = 179.82, ["Ride"] = 99.07, ["Neon"] = 10.28, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 58.24, ["Mega|Fly"] = 164, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 216.53}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.37, ["Ride"] = 28.88, ["Fly|Ride"] = 131.25, ["Neon"] = 4.85, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 42.35, ["Mega"] = 32.47, ["Mega|Ride"] = 114.14, ["Mega|Fly|Ride"] = 194.92}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 27.2, ["Fly|Ride"] = 48.53, ["Neon"] = 2.1, ["Neon|Ride"] = 35.26, ["Neon|Fly|Ride"] = 129.21, ["Mega"] = 14.31, ["Mega|Fly"] = 32.82, ["Mega|Ride"] = 26.24, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 23.7, ["Ride"] = 19.32, ["Fly|Ride"] = 55.42, ["Neon"] = 7.68, ["Neon|Fly"] = 58.15, ["Neon|Ride"] = 22.04, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 105.24, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 151.92}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 7.85, ["Neon|Ride"] = 57.75, ["Mega"] = 46.92, ["Mega|Fly"] = 228.9, ["Mega|Ride"] = 144.23, ["Mega|Fly|Ride"] = 208.69}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 28.6, ["Ride"] = 19.39, ["Fly|Ride"] = 40.69, ["Neon"] = 6.57, ["Neon|Fly"] = 80.77, ["Neon|Ride"] = 22.2, ["Neon|Fly|Ride"] = 84, ["Mega"] = 114.14, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 273.49}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 13.13, ["Neon|Fly"] = 188.88, ["Neon|Fly|Ride"] = 323.01, ["Mega"] = 105, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 645.85}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 26.02, ["Ride"] = 21.51, ["Fly|Ride"] = 50.61, ["Neon"] = 8.58, ["Neon|Fly"] = 48.98, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 61.95, ["Mega"] = 215.34, ["Mega|Fly"] = 420, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 198.41}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 20.6, ["Ride"] = 18.26, ["Fly|Ride"] = 72.12, ["Neon"] = 19.44, ["Neon|Fly"] = 32.78, ["Neon|Ride"] = 26.78, ["Neon|Fly|Ride"] = 65.54, ["Mega"] = 167.92, ["Mega|Fly"] = 430.67, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 6.28, ["Fly"] = 114.12, ["Fly|Ride"] = 144.29, ["Neon"] = 101.22, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 259.88, ["Mega|Ride"] = 406.88}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 8.99, ["Ride"] = 122.4, ["Neon"] = 106.61, ["Neon|Ride"] = 144.29, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 750.75}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.1, ["Neon|Ride"] = 144.29, ["Mega"] = 242.23, ["Mega|Ride"] = 208.95}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 5, ["Ride"] = 51.1, ["Fly|Ride"] = 120.75, ["Neon"] = 52.49, ["Neon|Ride"] = 83.96, ["Neon|Fly|Ride"] = 146.14, ["Mega"] = 235.57, ["Mega|Ride"] = 334.14, ["Mega|Fly|Ride"] = 449.54}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.92, ["Neon|Ride"] = 42.23, ["Mega"] = 18.38, ["Mega|Fly"] = 214.27, ["Mega|Ride"] = 82.01, ["Mega|Fly|Ride"] = 256.26}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 50.14}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 6.16, ["Fly"] = 24.05, ["Ride"] = 24.71, ["Fly|Ride"] = 52.41, ["Neon"] = 45.94, ["Neon|Fly"] = 187.36, ["Neon|Ride"] = 42.1, ["Neon|Fly|Ride"] = 96.15, ["Mega"] = 261.19, ["Mega|Ride"] = 208.69, ["Mega|Fly|Ride"] = 265.97}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 71.05, ["Ride"] = 21, ["Neon"] = 2.1, ["Neon|Fly"] = 52.81, ["Neon|Ride"] = 24.23, ["Neon|Fly|Ride"] = 144.24, ["Mega"] = 19.69, ["Mega|Ride"] = 101.46, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 26.24, ["Neon"] = 7.59, ["Neon|Ride"] = 32.97, ["Neon|Fly|Ride"] = 74.43, ["Mega"] = 46.32, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 174.45}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 50.6, ["Ride"] = 16.14, ["Fly|Ride"] = 47.62, ["Neon"] = 10.49, ["Neon|Ride"] = 24.1, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 164.01, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 228.9}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.6, ["Ride"] = 32.82, ["Fly|Ride"] = 261.19, ["Neon"] = 50.3, ["Neon|Ride"] = 208.15, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 105, ["Mega|Ride"] = 348.95, ["Mega|Fly|Ride"] = 287.48}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 2.5, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 159.37, ["Mega"] = 20.99, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 56.32, ["Mega|Fly|Ride"] = 344.54}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 28.01, ["Ride"] = 21.86, ["Fly|Ride"] = 90.45, ["Neon"] = 3.7, ["Neon|Fly"] = 115.05, ["Neon|Ride"] = 20.87, ["Neon|Fly|Ride"] = 84, ["Mega"] = 30.17, ["Mega|Fly"] = 159.37, ["Mega|Ride"] = 54.39, ["Mega|Fly|Ride"] = 104.9}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 18.34, ["Fly|Ride"] = 53.79, ["Neon"] = 4.96, ["Neon|Fly"] = 37.85, ["Neon|Ride"] = 23.61, ["Neon|Fly|Ride"] = 62.98, ["Mega"] = 172.29, ["Mega|Fly"] = 144.24, ["Mega|Ride"] = 70.87, ["Mega|Fly|Ride"] = 133.96}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 3.93, ["Fly"] = 91.88, ["Ride"] = 40.55, ["Fly|Ride"] = 131.25, ["Neon"] = 26.23, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 131.25, ["Mega|Ride"] = 174.14, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.5, ["Neon|Ride"] = 107.68, ["Neon|Fly|Ride"] = 157628.28, ["Mega"] = 19.67, ["Mega|Fly"] = 103.37, ["Mega|Ride"] = 44.93, ["Mega|Fly|Ride"] = 156.19}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 21, ["Neon"] = 2.1, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 25.02, ["Neon|Fly|Ride"] = 67.69, ["Mega"] = 22.62, ["Mega|Fly"] = 72.07, ["Mega|Ride"] = 44.4, ["Mega|Fly|Ride"] = 144.24}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 38.58, ["Neon"] = 2.63, ["Neon|Fly"] = 73.45, ["Mega"] = 21.27, ["Mega|Ride"] = 190.32}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.52, ["Neon"] = 6.43, ["Neon|Fly|Ride"] = 420, ["Mega"] = 27.57, ["Mega|Fly|Ride"] = 164.01}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.23, ["Ride"] = 16.71, ["Fly|Ride"] = 69.44, ["Neon"] = 3.67, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 21.94, ["Neon|Fly|Ride"] = 48.9, ["Mega"] = 32.05, ["Mega|Ride"] = 43.28, ["Mega|Fly|Ride"] = 111.56}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 5.19, ["Ride"] = 78.75, ["Fly|Ride"] = 216.09, ["Neon"] = 89.76, ["Neon|Ride"] = 105, ["Mega"] = 389.82, ["Mega|Ride"] = 475.13, ["Mega|Fly|Ride"] = 602.94}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 53.82, ["Neon"] = 26.25, ["Neon|Ride"] = 82.01, ["Mega"] = 244.78, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 33.06, ["Fly|Ride"] = 131.25, ["Neon"] = 25.76, ["Neon|Ride"] = 144.29, ["Neon|Fly|Ride"] = 115.07, ["Mega"] = 312.12, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 10.5, ["Fly|Ride"] = 22.32, ["Neon"] = 2.1, ["Neon|Fly"] = 14.21, ["Neon|Ride"] = 13.01, ["Neon|Fly|Ride"] = 28.84, ["Mega"] = 14.8, ["Mega|Fly"] = 102.92, ["Mega|Ride"] = 27.55, ["Mega|Fly|Ride"] = 49.88}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Ride"] = 60.32, ["Neon"] = 10.19, ["Neon|Fly"] = 72.16, ["Neon|Ride"] = 31.82, ["Neon|Fly|Ride"] = 718.13, ["Mega"] = 129.21, ["Mega|Ride"] = 118.13}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.49, ["Neon"] = 2.1, ["Neon|Fly"] = 32.36, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 86.67, ["Mega"] = 15.75, ["Mega|Fly"] = 144.29, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 5.24, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 129.22, ["Mega"] = 31.23, ["Mega|Fly|Ride"] = 367.49}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 144.29, ["Ride"] = 26.24, ["Fly|Ride"] = 48.09, ["Neon"] = 7.41, ["Neon|Fly"] = 59.06, ["Neon|Ride"] = 34.44, ["Neon|Fly|Ride"] = 58.3, ["Mega"] = 208.85, ["Mega|Ride"] = 187.36, ["Mega|Fly|Ride"] = 275.6}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 221.12, ["Ride"] = 252, ["Fly|Ride"] = 860.9, ["Neon|Ride"] = 790.27, ["Neon|Fly|Ride"] = 930.15, ["Mega"] = 8611.11, ["Mega|Fly|Ride"] = 3503.41}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Neon|Fly"] = 58.16, ["Neon|Ride"] = 64.32, ["Mega"] = 68.25, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 653.63}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 2.52, ["Fly"] = 103.69, ["Ride"] = 39.79, ["Fly|Ride"] = 65.63, ["Neon"] = 25.85, ["Neon|Ride"] = 135.18, ["Neon|Fly|Ride"] = 172.29, ["Mega"] = 393.75, ["Mega|Ride"] = 321.93, ["Mega|Fly|Ride"] = 387.6}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 19.66, ["Ride"] = 14.44, ["Fly|Ride"] = 32.31, ["Neon"] = 6.27, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 26.9, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 46.72, ["Mega|Ride"] = 102.3, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 72.16, ["Ride"] = 19.69, ["Fly|Ride"] = 142.62, ["Neon"] = 8.6, ["Neon|Fly"] = 144.29, ["Neon|Ride"] = 72.34, ["Neon|Fly|Ride"] = 115.22, ["Mega"] = 97.99, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 2.1, ["Fly"] = 27.4, ["Ride"] = 17.06, ["Fly|Ride"] = 39.38, ["Neon"] = 41.91, ["Neon|Fly"] = 101.22, ["Neon|Ride"] = 33.01, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 144.38, ["Mega|Ride"] = 956.81, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.39, ["Ride"] = 19.69, ["Fly|Ride"] = 259.91, ["Neon"] = 85.52, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 193.75, ["Mega|Ride"] = 359.62, ["Mega|Fly|Ride"] = 347.82}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 3.04, ["Fly"] = 26.65, ["Ride"] = 14.42, ["Fly|Ride"] = 36.66, ["Neon"] = 42.33, ["Neon|Fly"] = 129.21, ["Neon|Ride"] = 36.6, ["Neon|Fly|Ride"] = 78.54, ["Mega|Ride"] = 373.61, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 70.74, ["Ride"] = 86.57, ["Fly|Ride"] = 159.51, ["Neon"] = 346.28, ["Neon|Fly"] = 450.19, ["Neon|Ride"] = 449.17, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 2011.19, ["Mega|Ride"] = 1866.92, ["Mega|Fly|Ride"] = 1884.15}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 225.75, ["Fly"] = 430.67, ["Ride"] = 220.5, ["Fly|Ride"] = 337.32, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1263.99, ["Mega"] = 12916.65, ["Mega|Fly|Ride"] = 3524.17}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 63.72, ["Fly"] = 144.24, ["Ride"] = 68.09, ["Fly|Ride"] = 118.01, ["Neon"] = 729.5, ["Neon|Fly"] = 365.01, ["Neon|Ride"] = 311.07, ["Neon|Fly|Ride"] = 317.62, ["Mega"] = 1436.26, ["Mega|Fly|Ride"] = 1229.32}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 4.67, ["Fly"] = 288.42, ["Ride"] = 25.1, ["Fly|Ride"] = 65.61, ["Neon"] = 25.91, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 149.63, ["Mega"] = 238.67, ["Mega|Ride"] = 196.75, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 16.21, ["Fly"] = 63, ["Ride"] = 32.81, ["Fly|Ride"] = 78.75, ["Neon"] = 65.63, ["Neon|Ride"] = 141.82, ["Neon|Fly|Ride"] = 144.79, ["Mega"] = 314.9, ["Mega|Ride"] = 364.88, ["Mega|Fly|Ride"] = 379.19}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 39.29, ["Ride"] = 17.26, ["Fly|Ride"] = 53.86, ["Neon"] = 3.84, ["Neon|Fly"] = 57.44, ["Neon|Ride"] = 25.85, ["Neon|Fly|Ride"] = 51.7, ["Mega"] = 56.21, ["Mega|Fly"] = 154.88, ["Mega|Ride"] = 86.63, ["Mega|Fly|Ride"] = 556.77}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 16.95, ["Fly"] = 68.93, ["Ride"] = 34.12, ["Fly|Ride"] = 81.29, ["Neon"] = 78.75, ["Neon|Fly"] = 287.48, ["Neon|Ride"] = 144.29, ["Neon|Fly|Ride"] = 321.93, ["Mega"] = 574.95, ["Mega|Ride"] = 646, ["Mega|Fly|Ride"] = 532.95}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.99, ["Ride"] = 15.75, ["Fly|Ride"] = 46.31, ["Neon"] = 29.09, ["Neon|Fly"] = 51.69, ["Neon|Ride"] = 24, ["Neon|Fly|Ride"] = 97.93, ["Mega"] = 144.24, ["Mega|Ride"] = 183.74, ["Mega|Fly|Ride"] = 297.55}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 3.41, ["Ride"] = 21.62, ["Fly|Ride"] = 328.13, ["Neon"] = 39.53, ["Neon|Ride"] = 115.22, ["Mega"] = 207.37, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 337.84}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 27.68, ["Ride"] = 19.39, ["Fly|Ride"] = 72.13, ["Neon"] = 2.1, ["Neon|Ride"] = 17.25, ["Neon|Fly|Ride"] = 58.24, ["Mega"] = 15.43, ["Mega|Ride"] = 41.64, ["Mega|Fly|Ride"] = 72.19}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.29, ["Ride"] = 19.04, ["Fly|Ride"] = 44.63, ["Neon"] = 12.16, ["Neon|Fly"] = 107.66, ["Neon|Ride"] = 36.62, ["Neon|Fly|Ride"] = 147, ["Mega"] = 78.72, ["Mega|Ride"] = 152.25, ["Mega|Fly|Ride"] = 213.21}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 64.98, ["Ride"] = 22.29, ["Fly|Ride"] = 81.3, ["Neon"] = 22.93, ["Neon|Ride"] = 42, ["Mega"] = 144.37, ["Mega|Ride"] = 164.01, ["Mega|Fly|Ride"] = 267.02}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 108.81, ["Fly"] = 149.63, ["Ride"] = 161.16, ["Fly|Ride"] = 190.19, ["Neon"] = 430.39, ["Neon|Ride"] = 472.49, ["Neon|Fly|Ride"] = 503.99, ["Mega"] = 2447.55, ["Mega|Fly|Ride"] = 1975.32}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 5.75, ["Ride"] = 240.02, ["Fly|Ride"] = 131.25, ["Neon"] = 103.69, ["Neon|Ride"] = 89.25, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 279.88, ["Mega|Ride"] = 244.77, ["Mega|Fly|Ride"] = 391.1}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 44.44, ["Ride"] = 20.99, ["Fly|Ride"] = 43.04, ["Neon"] = 23.29, ["Neon|Ride"] = 62.91, ["Neon|Fly|Ride"] = 86.17, ["Mega"] = 271.34, ["Mega|Ride"] = 187.8, ["Mega|Fly|Ride"] = 328.12}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 21.32, ["Ride"] = 39.38, ["Fly|Ride"] = 170.63, ["Neon"] = 99.74, ["Neon|Ride"] = 194.25, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly"] = 861.13, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 1076.66}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 6.57}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 9.17, ["Fly"] = 21, ["Ride"] = 72.19, ["Fly|Ride"] = 128.14, ["Neon"] = 99.75, ["Neon|Ride"] = 115.18, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 624.75, ["Mega|Ride"] = 630.93, ["Mega|Fly|Ride"] = 501.93}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 19.66, ["Fly"] = 33.38, ["Ride"] = 30.18, ["Fly|Ride"] = 49.88, ["Neon"] = 404.83, ["Neon|Fly"] = 129.21, ["Neon|Ride"] = 129.17, ["Neon|Fly|Ride"] = 150.92, ["Mega"] = 1389.96, ["Mega|Fly|Ride"] = 537.18}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 35.43, ["Neon"] = 2.63, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 144.45, ["Mega"] = 29.38, ["Mega|Fly"] = 187.36, ["Mega|Ride"] = 83.35}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 3.99, ["Fly"] = 26.24, ["Ride"] = 21.25, ["Fly|Ride"] = 65.63, ["Neon"] = 64.61, ["Mega"] = 286.4, ["Mega|Fly"] = 408.83, ["Mega|Ride"] = 275.63}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 28.96, ["Ride"] = 19.3, ["Fly|Ride"] = 41.02, ["Neon"] = 18, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 30.85, ["Neon|Fly|Ride"] = 70.63, ["Mega"] = 194.31, ["Mega|Ride"] = 160.13, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Neon"] = 3.77, ["Neon|Ride"] = 41.64, ["Mega"] = 131.25, ["Mega|Ride"] = 101.22, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 27.2, ["Fly"] = 78.75, ["Ride"] = 64.22, ["Fly|Ride"] = 139.98, ["Neon"] = 273.54, ["Neon|Ride"] = 262.74, ["Neon|Fly|Ride"] = 576.19, ["Mega"] = 985.37, ["Mega|Ride"] = 682.16, ["Mega|Fly|Ride"] = 766.74}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.3, ["Ride"] = 48.57, ["Fly|Ride"] = 119.97, ["Neon"] = 95.82, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 183.75, ["Mega|Ride"] = 359.62}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 2.1, ["Fly"] = 23.78, ["Ride"] = 22.03, ["Fly|Ride"] = 57.52, ["Neon"] = 12.7, ["Neon|Fly"] = 86.17, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 119.51, ["Mega"] = 167.99, ["Mega|Ride"] = 146.88, ["Mega|Fly|Ride"] = 326.82}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 64.32, ["Fly"] = 145.01, ["Ride"] = 127.07, ["Neon"] = 347.04, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 540.28, ["Mega"] = 4571.12, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 2447.72}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 6.18, ["Fly"] = 47.58, ["Ride"] = 20.5, ["Fly|Ride"] = 58.47, ["Neon"] = 36.29, ["Neon|Ride"] = 48.95, ["Neon|Fly|Ride"] = 114.18, ["Mega"] = 271.34, ["Mega|Fly"] = 367.15, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 396.22}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 81.37, ["Fly"] = 131.24, ["Ride"] = 124.68, ["Fly|Ride"] = 215.02, ["Neon"] = 262.4, ["Neon|Ride"] = 267.1, ["Neon|Fly|Ride"] = 391.65, ["Mega"] = 1968.75, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 20.5, ["Ride"] = 62.19, ["Fly|Ride"] = 164.07, ["Neon"] = 97.13, ["Neon|Ride"] = 112.47, ["Neon|Fly|Ride"] = 261.92, ["Mega"] = 353.06, ["Mega|Ride"] = 328.12, ["Mega|Fly|Ride"] = 452.17}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 5.91, ["Fly"] = 39.38, ["Ride"] = 25.85, ["Fly|Ride"] = 39.38, ["Neon"] = 91.88, ["Neon|Fly|Ride"] = 141.91, ["Mega"] = 653.57, ["Mega|Ride"] = 572.58, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 19.57, ["Fly"] = 78.75, ["Ride"] = 65.63, ["Fly|Ride"] = 206.3, ["Neon"] = 77.41, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 282.19, ["Mega"] = 473.59, ["Mega|Ride"] = 387.19, ["Mega|Fly|Ride"] = 432.91}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 8.64, ["Ride"] = 34.12, ["Fly|Ride"] = 80.01, ["Neon"] = 47.74, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 249.38, ["Mega|Ride"] = 342.69, ["Mega|Fly|Ride"] = 438.21}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 131.25, ["Mega"] = 19.94, ["Mega|Ride"] = 144.29}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 11.85, ["Ride"] = 143.06, ["Fly|Ride"] = 325.9, ["Neon"] = 18.38, ["Neon|Ride"] = 238.86, ["Mega"] = 223.88, ["Mega|Ride"] = 359.62, ["Mega|Fly|Ride"] = 1028.21}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 128.1, ["Ride"] = 29.09, ["Neon"] = 26.25, ["Neon|Fly"] = 116.94, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 253.98, ["Mega|Ride"] = 419.91, ["Mega|Fly|Ride"] = 1143.1}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 2.48, ["Ride"] = 32.81, ["Neon"] = 16.46, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 187.69, ["Mega|Ride"] = 287.48, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 523.69, ["Ride"] = 563.03, ["Fly|Ride"] = 654.72, ["Neon|Ride"] = 1771.88, ["Neon|Fly|Ride"] = 1664.25, ["Mega|Fly|Ride"] = 4830}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 5.24, ["Fly"] = 45.47, ["Ride"] = 23.29, ["Fly|Ride"] = 65.63, ["Neon"] = 38.93, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 341.46, ["Mega"] = 201.36, ["Mega|Ride"] = 375.78, ["Mega|Fly|Ride"] = 359.62}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 7.79, ["Fly"] = 66.85, ["Ride"] = 20.37, ["Fly|Ride"] = 54.66, ["Neon"] = 97.95, ["Neon|Fly"] = 315, ["Neon|Ride"] = 66.09, ["Neon|Fly|Ride"] = 105, ["Mega"] = 331.88, ["Mega|Ride"] = 258.51, ["Mega|Fly|Ride"] = 446.82}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.12, ["Fly"] = 24.93, ["Ride"] = 28.01, ["Fly|Ride"] = 51.1, ["Neon|Ride"] = 32.3, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 198.19, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 58.08, ["Ride"] = 26.25, ["Fly|Ride"] = 90.57, ["Neon"] = 12.36, ["Neon|Ride"] = 35.43, ["Neon|Fly|Ride"] = 104.81, ["Mega"] = 144.14, ["Mega|Fly"] = 115.05, ["Mega|Ride"] = 102.36, ["Mega|Fly|Ride"] = 236.29}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 26.23, ["Ride"] = 24.61, ["Neon"] = 3.51, ["Neon|Ride"] = 32.33, ["Neon|Fly|Ride"] = 104.98, ["Mega"] = 20.78, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1376.82}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 7.7, ["Ride"] = 28.76, ["Fly|Ride"] = 118.13, ["Neon"] = 74.06, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 361.05, ["Mega"] = 370.59, ["Mega|Ride"] = 416.13, ["Mega|Fly|Ride"] = 482.35}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 19.46, ["Neon"] = 10.91, ["Neon|Ride"] = 55.31, ["Neon|Fly|Ride"] = 1005.6, ["Mega"] = 72.16, ["Mega|Ride"] = 86.17, ["Mega|Fly|Ride"] = 183.74}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 10.7, ["Fly"] = 335.14, ["Ride"] = 99.25, ["Fly|Ride"] = 144.29, ["Neon"] = 68.25, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 236.15, ["Mega"] = 315, ["Mega|Ride"] = 387.6, ["Mega|Fly|Ride"] = 483.44}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 387.19, ["Fly"] = 531.24, ["Ride"] = 459.37, ["Fly|Ride"] = 525, ["Neon"] = 1688.94, ["Neon|Ride"] = 1706.27, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 8071.94, ["Mega|Fly|Ride"] = 6357.75}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 2.1, ["Fly"] = 196.88, ["Ride"] = 43.23, ["Neon"] = 16.16, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 195.85, ["Mega"] = 352.08, ["Mega|Ride"] = 362.77, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Ride"] = 26.24, ["Fly|Ride"] = 118.11, ["Neon"] = 3.67, ["Neon|Ride"] = 31.42, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 37.84, ["Mega|Fly"] = 115.22, ["Mega|Ride"] = 83.22, ["Mega|Fly|Ride"] = 158.12}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Fly|Ride"] = 100.42, ["Neon"] = 3.72, ["Mega"] = 30.19, ["Mega|Ride"] = 129.17, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 30.15, ["Fly"] = 115.22, ["Ride"] = 109.01, ["Neon"] = 164, ["Neon|Ride"] = 429.6, ["Neon|Fly|Ride"] = 590.63, ["Mega"] = 689.07, ["Mega|Ride"] = 704.13, ["Mega|Fly|Ride"] = 822.5}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 9.58, ["Neon|Ride"] = 270.24, ["Neon|Fly|Ride"] = 861.33, ["Mega"] = 1291.99, ["Mega|Ride"] = 484.98, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 3.52, ["Ride"] = 31.4, ["Neon"] = 101.19, ["Neon|Ride"] = 172.29, ["Mega"] = 669.56, ["Mega|Ride"] = 637.39, ["Mega|Fly|Ride"] = 1212.86}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 23.55, ["Ride"] = 56.36, ["Fly|Ride"] = 236.25, ["Neon"] = 131.25, ["Neon|Ride"] = 177.51, ["Neon|Fly|Ride"] = 241.5, ["Mega"] = 1680, ["Mega|Ride"] = 1722.24, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 367.5, ["Ride"] = 393.74, ["Fly|Ride"] = 714.91, ["Neon"] = 918.75, ["Neon|Ride"] = 1472.87, ["Neon|Fly|Ride"] = 1266.71, ["Mega|Fly|Ride"] = 3302.09}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 12.11, ["Ride"] = 60.27, ["Fly|Ride"] = 159.63, ["Neon"] = 84.45, ["Neon|Ride"] = 193.81, ["Neon|Fly|Ride"] = 287.48, ["Mega|Ride"] = 547.98, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 2.48, ["Ride"] = 27.72, ["Fly|Ride"] = 127.32, ["Neon"] = 36.75, ["Neon|Ride"] = 105, ["Mega"] = 170.13, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 44.56, ["Ride"] = 420, ["Neon"] = 196.77, ["Neon|Ride"] = 313.69, ["Neon|Fly|Ride"] = 532.95, ["Mega"] = 483, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.57, ["Fly|Ride"] = 215.34, ["Neon"] = 7.88, ["Neon|Fly"] = 86.45, ["Neon|Ride"] = 57.74, ["Neon|Fly|Ride"] = 278.87, ["Mega"] = 63, ["Mega|Fly"] = 244.78, ["Mega|Ride"] = 165.82, ["Mega|Fly|Ride"] = 288.48}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 48.26, ["Ride"] = 59.07, ["Fly|Ride"] = 212.98, ["Neon"] = 262.47, ["Neon|Ride"] = 359.62, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1561.16, ["Mega|Ride"] = 1152.41, ["Mega|Fly|Ride"] = 1420.74}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.51, ["Fly"] = 106.61, ["Ride"] = 28.73, ["Neon"] = 13.01, ["Neon|Fly"] = 187.36, ["Neon|Ride"] = 70.26, ["Neon|Fly|Ride"] = 144.29, ["Mega"] = 100.95, ["Mega|Ride"] = 101.22, ["Mega|Fly|Ride"] = 141.06}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Ride"] = 54.48, ["Fly|Ride"] = 107.68, ["Neon"] = 3.61, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 105, ["Mega"] = 57.74, ["Mega|Fly"] = 118.02, ["Mega|Ride"] = 71.31, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 130.99, ["Neon"] = 15.74, ["Neon|Ride"] = 56.67, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 95.82, ["Mega|Ride"] = 287.37, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 68.15, ["Fly"] = 105, ["Ride"] = 78.71, ["Fly|Ride"] = 130.96, ["Neon"] = 367.5, ["Neon|Ride"] = 362.92, ["Neon|Fly|Ride"] = 489.56, ["Mega|Ride"] = 1127.26, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 3.92, ["Ride"] = 36.08, ["Neon"] = 13.54, ["Neon|Fly"] = 350.44, ["Mega"] = 74.8, ["Mega|Fly"] = 287.48, ["Mega|Ride"] = 215.24, ["Mega|Fly|Ride"] = 348.53}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 72.16, ["Ride"] = 26.66, ["Fly|Ride"] = 72.45, ["Neon"] = 9.19, ["Neon|Ride"] = 82.69, ["Mega"] = 49.87, ["Mega|Fly"] = 210, ["Mega|Ride"] = 97.13, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.45, ["Fly"] = 107.68, ["Ride"] = 32.82, ["Fly|Ride"] = 98.44, ["Neon"] = 32.82, ["Neon|Fly|Ride"] = 164.04, ["Mega"] = 326.78, ["Mega|Ride"] = 355.11, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 7.4, ["Fly"] = 56.44, ["Ride"] = 60.31, ["Fly|Ride"] = 114.19, ["Neon"] = 30.43, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 104.99, ["Mega"] = 170.63, ["Mega|Ride"] = 244.29, ["Mega|Fly|Ride"] = 516.8}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 71.61, ["Neon"] = 6.27, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 214.27, ["Mega"] = 36.11, ["Mega|Ride"] = 141.74, ["Mega|Fly|Ride"] = 293.74}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.45, ["Fly|Ride"] = 62.87, ["Neon"] = 6.45, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 25.75, ["Neon|Fly|Ride"] = 103.49, ["Mega"] = 45.94, ["Mega|Ride"] = 99.07, ["Mega|Fly|Ride"] = 167.99}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 20.79, ["Ride"] = 23.56, ["Fly|Ride"] = 57.74, ["Neon"] = 14.17, ["Neon|Fly"] = 102.27, ["Neon|Ride"] = 41.64, ["Neon|Fly|Ride"] = 115.22, ["Mega|Ride"] = 142.93, ["Mega|Fly|Ride"] = 279.88}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 28.88, ["Fly"] = 72.16, ["Ride"] = 29.08, ["Fly|Ride"] = 89.38, ["Neon"] = 144.37, ["Neon|Ride"] = 287.48, ["Neon|Fly|Ride"] = 279.95, ["Mega"] = 485.63, ["Mega|Ride"] = 538.13, ["Mega|Fly|Ride"] = 653.44}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 65.63, ["Ride"] = 97.28, ["Fly|Ride"] = 131.25, ["Neon"] = 373.96, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 370.65, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 2153.31, ["Mega|Ride"] = 1955.21, ["Mega|Fly|Ride"] = 1743.16}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 19.53, ["Neon"] = 4.02, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 144.29, ["Mega"] = 43.09, ["Mega|Fly"] = 672, ["Mega|Ride"] = 80.77, ["Mega|Fly|Ride"] = 267.02}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 17.75, ["Ride"] = 14.34, ["Fly|Ride"] = 43.09, ["Neon"] = 5.13, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 53.85, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 10.5, ["Fly"] = 183.75, ["Ride"] = 38.03, ["Neon"] = 40.68, ["Neon|Ride"] = 160.12, ["Neon|Fly|Ride"] = 144.29, ["Mega"] = 551.25, ["Mega|Ride"] = 275.62, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.75, ["Ride"] = 622.09, ["Fly|Ride"] = 584.07, ["Neon"] = 4306.59, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 6163.5}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 29.38, ["Fly"] = 61.69, ["Ride"] = 48.97, ["Fly|Ride"] = 124.76, ["Neon"] = 246.74, ["Neon|Ride"] = 220.31, ["Neon|Fly|Ride"] = 255.94, ["Mega"] = 720.57, ["Mega|Ride"] = 839.81, ["Mega|Fly|Ride"] = 904.4}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 23.3, ["Fly|Ride"] = 298.68, ["Neon"] = 14.44, ["Neon|Ride"] = 56, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 69.21, ["Mega|Ride"] = 129.84, ["Mega|Fly|Ride"] = 317.63}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 105, ["Ride"] = 65.62, ["Fly|Ride"] = 261.98, ["Mega|Fly|Ride"] = 430.67}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 31.19, ["Fly"] = 168.91, ["Ride"] = 115.17, ["Fly|Ride"] = 83.9, ["Neon"] = 194.25, ["Neon|Ride"] = 261.85, ["Neon|Fly|Ride"] = 286.13, ["Mega"] = 2583.35, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1002.75}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 103.95, ["Fly"] = 162.59, ["Ride"] = 144.15, ["Fly|Ride"] = 190.32, ["Neon"] = 508.79, ["Neon|Ride"] = 537.26, ["Neon|Fly|Ride"] = 446.25, ["Mega"] = 3158.89, ["Mega|Fly|Ride"] = 1975.55}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 225.74, ["Ride"] = 285.21, ["Fly|Ride"] = 367.5, ["Neon"] = 954.63, ["Neon|Ride"] = 800.63, ["Neon|Fly|Ride"] = 1035.57, ["Mega|Fly|Ride"] = 2867.82}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 12.16, ["Ride"] = 63.41, ["Fly|Ride"] = 144.29, ["Neon"] = 118.13, ["Neon|Ride"] = 99.74, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 324.84, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.97, ["Ride"] = 11.84, ["Fly|Ride"] = 39.38, ["Neon"] = 7.27, ["Neon|Ride"] = 28.87, ["Neon|Fly|Ride"] = 84, ["Mega"] = 78.65, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.1, ["Fly"] = 49.55, ["Ride"] = 19.64, ["Fly|Ride"] = 62.91, ["Neon"] = 34.73, ["Neon|Fly"] = 136.75, ["Neon|Ride"] = 43.05, ["Neon|Fly|Ride"] = 106.55, ["Mega"] = 293.08, ["Mega|Ride"] = 240.19, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 249.37, ["Ride"] = 364.72, ["Fly|Ride"] = 576.03, ["Neon"] = 1569.1, ["Neon|Fly|Ride"] = 1647.28, ["Mega"] = 10766.45, ["Mega|Fly|Ride"] = 6269.82}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 33.39, ["Neon"] = 15.65, ["Neon|Ride"] = 140.83, ["Neon|Fly|Ride"] = 144.29, ["Mega"] = 35.43, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 318.94}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 4.03, ["Fly"] = 101.19, ["Ride"] = 17.07, ["Fly|Ride"] = 52.5, ["Neon"] = 26.55, ["Neon|Ride"] = 38.77, ["Neon|Fly|Ride"] = 80.3, ["Mega"] = 115.5, ["Mega|Ride"] = 171.21, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 15.44, ["Fly"] = 6562.5, ["Ride"] = 59.07, ["Fly|Ride"] = 144.29, ["Neon"] = 105.13, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 104.98, ["Neon|Fly|Ride"] = 328.12, ["Mega"] = 561.33, ["Mega|Ride"] = 717.96, ["Mega|Fly|Ride"] = 590.78}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 123.27, ["Fly"] = 157.5, ["Ride"] = 164.01, ["Fly|Ride"] = 170.63, ["Neon|Ride"] = 816.33, ["Neon|Fly|Ride"] = 590.63, ["Mega|Fly|Ride"] = 2152.08}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 19.68, ["Fly"] = 39.29, ["Ride"] = 28.87, ["Fly|Ride"] = 52.5, ["Neon"] = 105, ["Neon|Ride"] = 107.68, ["Neon|Fly|Ride"] = 138.5, ["Mega"] = 502.81, ["Mega|Ride"] = 422.63, ["Mega|Fly|Ride"] = 574.95}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 62.45, ["Neon"] = 3.91, ["Mega"] = 21, ["Mega|Ride"] = 172.29, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 32.7, ["Ride"] = 18.38, ["Fly|Ride"] = 86.17, ["Neon"] = 3.94, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 28.01, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 28.04, ["Mega|Fly"] = 101.22, ["Mega|Ride"] = 43.32, ["Mega|Fly|Ride"] = 159.37}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 19.43, ["Fly"] = 103.28, ["Ride"] = 106.54, ["Fly|Ride"] = 318.7, ["Neon"] = 36.74, ["Neon|Ride"] = 92.7, ["Neon|Fly|Ride"] = 394.11, ["Mega"] = 180.37, ["Mega|Ride"] = 263.81, ["Mega|Fly|Ride"] = 347.7}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1050, ["Ride"] = 1312.5, ["Fly|Ride"] = 1391.25, ["Neon"] = 3937.5, ["Neon|Ride"] = 3150, ["Neon|Fly|Ride"] = 4017.24, ["Mega|Fly|Ride"] = 10498.95}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 419.99, ["Ride"] = 568.32, ["Fly|Ride"] = 540.53, ["Neon"] = 1680, ["Neon|Ride"] = 1443.74, ["Neon|Fly|Ride"] = 1573.68, ["Mega"] = 15069.42, ["Mega|Fly|Ride"] = 6604.16}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 316.71, ["Fly"] = 413.67, ["Ride"] = 365, ["Fly|Ride"] = 417.1, ["Neon"] = 839.81, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 724.5, ["Mega|Ride"] = 3590.62, ["Mega|Fly|Ride"] = 2916.24}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 253.38, ["Fly"] = 280.87, ["Ride"] = 291.33, ["Fly|Ride"] = 371.62, ["Neon"] = 748.13, ["Neon|Ride"] = 748.13, ["Neon|Fly|Ride"] = 700.88, ["Mega|Fly|Ride"] = 3543.25}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.65, ["Fly|Ride"] = 52.49, ["Neon"] = 9.16, ["Neon|Ride"] = 23.61, ["Neon|Fly|Ride"] = 115.06, ["Mega"] = 56.02, ["Mega|Ride"] = 81.38, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 291.38, ["Fly"] = 1436.26, ["Ride"] = 354.37, ["Fly|Ride"] = 479.12, ["Neon"] = 1292.3, ["Neon|Ride"] = 1006.45, ["Neon|Fly|Ride"] = 1542.94, ["Mega"] = 21815.13, ["Mega|Ride"] = 6173.5, ["Mega|Fly|Ride"] = 4279.55}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 12.96, ["Fly"] = 183.74, ["Ride"] = 149.67, ["Neon"] = 100.05, ["Neon|Ride"] = 144.29, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 236.24, ["Mega|Fly|Ride"] = 818.26}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 23.57, ["Ride"] = 16.49, ["Fly|Ride"] = 37.05, ["Neon"] = 7.27, ["Neon|Ride"] = 53.85, ["Neon|Fly|Ride"] = 105, ["Mega"] = 128.63, ["Mega|Ride"] = 192.31, ["Mega|Fly|Ride"] = 168.33}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Mega"] = 21.94, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 177.62}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 78.26, ["Ride"] = 131.25, ["Fly|Ride"] = 459.38, ["Neon"] = 236.25, ["Neon|Ride"] = 359.62, ["Mega"] = 1049.9, ["Mega|Ride"] = 733.69, ["Mega|Fly|Ride"] = 788.12}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 8160.43, ["Ride"] = 22.32, ["Fly|Ride"] = 68.25, ["Neon"] = 33.06, ["Mega"] = 344.54, ["Mega|Ride"] = 303.57, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Fly"] = 72.16, ["Ride"] = 32.82, ["Neon"] = 3.75, ["Neon|Fly"] = 45.23, ["Neon|Ride"] = 57.66, ["Neon|Fly|Ride"] = 141.93, ["Mega"] = 23.63, ["Mega|Ride"] = 61.3, ["Mega|Fly|Ride"] = 135.82}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 7.56, ["Fly"] = 131.03, ["Ride"] = 72.02, ["Fly|Ride"] = 91.46, ["Neon"] = 38.37, ["Neon|Ride"] = 106.5, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 213.41, ["Mega|Ride"] = 196.86, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.68, ["Fly"] = 32.43, ["Ride"] = 22.31, ["Fly|Ride"] = 56.7, ["Neon"] = 159.31, ["Neon|Ride"] = 58.15, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 238.85, ["Mega|Ride"] = 271, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 9.1, ["Ride"] = 42, ["Fly|Ride"] = 164.01, ["Neon"] = 80.77, ["Neon|Ride"] = 385.35, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 555.64}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 6527.56, ["Ride"] = 24.61, ["Fly|Ride"] = 196.88, ["Neon"] = 183.59, ["Neon|Ride"] = 214.1, ["Neon|Fly|Ride"] = 734.32, ["Mega"] = 420, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 555.57}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 72.23, ["Ride"] = 16.37, ["Fly|Ride"] = 43.66, ["Neon"] = 5.16, ["Neon|Fly"] = 81.65, ["Neon|Ride"] = 28.77, ["Neon|Fly|Ride"] = 129.21, ["Mega"] = 66.08, ["Mega|Fly|Ride"] = 244.83}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 210, ["Fly"] = 199.5, ["Ride"] = 196.88, ["Fly|Ride"] = 280.88, ["Neon"] = 976.53, ["Neon|Ride"] = 2690.67, ["Neon|Fly|Ride"] = 1437.12, ["Mega"] = 8611.11, ["Mega|Fly|Ride"] = 4166.39}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 25.83, ["Ride"] = 14.44, ["Fly|Ride"] = 37.67, ["Neon"] = 3.81, ["Neon|Fly"] = 36.74, ["Neon|Ride"] = 20.81, ["Neon|Fly|Ride"] = 56.98, ["Mega"] = 38.07, ["Mega|Ride"] = 47.25, ["Mega|Fly|Ride"] = 194.24}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 8.43, ["Ride"] = 44.77, ["Fly|Ride"] = 230.42, ["Neon"] = 98.27, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 775.3, ["Mega"] = 509.25, ["Mega|Ride"] = 309.74, ["Mega|Fly|Ride"] = 375.62}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 25.72, ["Ride"] = 85.32, ["Fly|Ride"] = 183.75, ["Neon"] = 243.25, ["Neon|Ride"] = 355.69, ["Neon|Fly|Ride"] = 466.83, ["Mega"] = 780.13, ["Mega|Ride"] = 1010.99, ["Mega|Fly|Ride"] = 944.99}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 201.79, ["Fly"] = 274.36, ["Ride"] = 240.47, ["Fly|Ride"] = 286.83, ["Neon|Fly"] = 1632.83, ["Neon|Ride"] = 711.37, ["Neon|Fly|Ride"] = 728.44, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 14.97, ["Fly"] = 164.04, ["Ride"] = 164.04, ["Fly|Ride"] = 144.29, ["Neon"] = 144.29, ["Neon|Ride"] = 141.37, ["Mega"] = 287.34, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 426.37}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 8.7, ["Ride"] = 58.15, ["Fly|Ride"] = 147.9, ["Neon"] = 181.15, ["Neon|Fly"] = 164.04, ["Neon|Ride"] = 321.93, ["Mega"] = 1722.65, ["Mega|Ride"] = 1436.26, ["Mega|Fly|Ride"] = 861.33}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 990.83, ["Ride"] = 951.83, ["Fly|Ride"] = 1027.69, ["Neon|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 4155.86, ["Mega|Fly|Ride"] = 17764.65}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 5.96, ["Fly"] = 28.01, ["Ride"] = 19.68, ["Fly|Ride"] = 45.93, ["Neon"] = 50.65, ["Neon|Fly"] = 76.44, ["Neon|Ride"] = 83.57, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 244.83, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 6.24, ["Fly"] = 51.19, ["Ride"] = 41.14, ["Fly|Ride"] = 133.88, ["Neon"] = 64.32, ["Neon|Ride"] = 86.17, ["Mega"] = 196.88, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 251.99, ["Mega|Fly|Ride"] = 341.23}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 86.17, ["Ride"] = 29.37, ["Fly|Ride"] = 79.69, ["Neon"] = 11.81, ["Neon|Ride"] = 35.81, ["Neon|Fly|Ride"] = 144.29, ["Mega"] = 83.21, ["Mega|Ride"] = 359.62, ["Mega|Fly|Ride"] = 290.07}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 17.75, ["Ride"] = 39.74, ["Fly|Ride"] = 124.83, ["Neon"] = 69.54, ["Neon|Ride"] = 98.43, ["Neon|Fly|Ride"] = 179.44, ["Mega"] = 446.25, ["Mega|Ride"] = 427.49, ["Mega|Fly|Ride"] = 471.34}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 3.05, ["Fly"] = 27.68, ["Ride"] = 20.99, ["Fly|Ride"] = 50.3, ["Neon"] = 19.47, ["Neon|Fly"] = 58.66, ["Neon|Ride"] = 34.57, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 192.27, ["Mega|Ride"] = 169.31, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 3.52, ["Fly"] = 32.75, ["Ride"] = 32.24, ["Fly|Ride"] = 131.25, ["Neon"] = 13.12, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 50.16, ["Neon|Fly|Ride"] = 107.55, ["Mega"] = 152.23, ["Mega|Ride"] = 227.07, ["Mega|Fly|Ride"] = 275.61}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 244.55, ["Ride"] = 574.72, ["Fly|Ride"] = 430.52, ["Neon"] = 1183.26, ["Neon|Fly|Ride"] = 1183.01, ["Mega|Fly|Ride"] = 3427.2}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 21.36, ["Fly|Ride"] = 144.29, ["Neon"] = 7.17, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 287.48, ["Mega"] = 85.57, ["Mega|Ride"] = 161.44, ["Mega|Fly|Ride"] = 344.54}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 2.84, ["Ride"] = 19.69, ["Fly|Ride"] = 88.87, ["Neon"] = 19.21, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27, ["Mega"] = 193.81, ["Mega|Ride"] = 351.01}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.91, ["Fly"] = 94.76, ["Ride"] = 40.79, ["Fly|Ride"] = 70.14, ["Neon"] = 10.48, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 105.52, ["Mega"] = 110.96, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 574.95}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 81.8, ["Ride"] = 137.45, ["Fly|Ride"] = 260.4, ["Neon"] = 380.63, ["Neon|Ride"] = 534.02, ["Neon|Fly|Ride"] = 548.63, ["Mega"] = 2583.96, ["Mega|Ride"] = 1506.25, ["Mega|Fly|Ride"] = 2153.31}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 23.45, ["Fly"] = 90.79, ["Ride"] = 58.15, ["Fly|Ride"] = 287.48, ["Neon"] = 103.94, ["Neon|Ride"] = 213.21, ["Neon|Fly|Ride"] = 341.93, ["Mega"] = 682.5, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 689.69}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 19.08, ["Fly"] = 263.44, ["Ride"] = 61.69, ["Fly|Ride"] = 73.5, ["Neon"] = 97.92, ["Neon|Ride"] = 114.84, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 414.36, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 529.23}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.63, ["Neon"] = 52.76, ["Neon|Ride"] = 245.44}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 51.85, ["Fly"] = 132.37, ["Ride"] = 86.4, ["Fly|Ride"] = 141.65, ["Neon"] = 183.74, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 215.27, ["Neon|Fly|Ride"] = 262.48, ["Mega|Fly|Ride"] = 1150.51}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 45.15, ["Fly|Ride"] = 105, ["Neon"] = 6.36, ["Neon|Fly|Ride"] = 128.09, ["Mega"] = 91.88, ["Mega|Ride"] = 287.48, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 17.07, ["Fly"] = 53.82, ["Ride"] = 25.95, ["Fly|Ride"] = 86.17, ["Neon"] = 64.56, ["Neon|Fly"] = 84, ["Neon|Ride"] = 81.81, ["Neon|Fly|Ride"] = 164.01, ["Mega"] = 364.34, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 386.53, ["Mega|Fly|Ride"] = 574.88}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 56.06, ["Fly"] = 203.43, ["Ride"] = 91.88, ["Fly|Ride"] = 275.62, ["Neon"] = 310.86, ["Neon|Fly"] = 315, ["Neon|Ride"] = 282.17, ["Neon|Fly|Ride"] = 359.61, ["Mega|Ride"] = 1472.87, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 16.05, ["Ride"] = 16.14, ["Fly|Ride"] = 50.61, ["Neon"] = 2.1, ["Neon|Fly"] = 22.32, ["Neon|Ride"] = 20.46, ["Neon|Fly|Ride"] = 42.88, ["Mega"] = 20.09, ["Mega|Ride"] = 42.82, ["Mega|Fly|Ride"] = 106.32}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.1, ["Ride"] = 51.66, ["Fly|Ride"] = 128.64, ["Neon"] = 21.46, ["Neon|Ride"] = 72.16, ["Neon|Fly|Ride"] = 159.75, ["Mega"] = 145.56, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 221.03, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 15.58, ["Fly"] = 78.75, ["Ride"] = 56.43, ["Fly|Ride"] = 123.83, ["Neon"] = 119.44, ["Neon|Ride"] = 152.02, ["Neon|Fly|Ride"] = 275.38, ["Mega"] = 536.82, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 695.27}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 19.25, ["Neon"] = 2.15, ["Neon|Ride"] = 58.15, ["Neon|Fly|Ride"] = 101.73, ["Mega"] = 19.68, ["Mega|Ride"] = 58.15, ["Mega|Fly|Ride"] = 120.75}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 49.88, ["Fly"] = 209.99, ["Ride"] = 104.99, ["Fly|Ride"] = 288.75, ["Neon"] = 170.62, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 416.69, ["Mega"] = 718.13, ["Mega|Fly"] = 918.75, ["Mega|Ride"] = 712.85, ["Mega|Fly|Ride"] = 959.21}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 15.18, ["Fly"] = 25.97, ["Ride"] = 19.36, ["Fly|Ride"] = 101.07, ["Neon"] = 234.66, ["Neon|Ride"] = 136.64, ["Neon|Fly|Ride"] = 165.82, ["Mega"] = 495.29, ["Mega|Ride"] = 458.07, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 5.65, ["Ride"] = 65.87, ["Neon"] = 75.51, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 89.94, ["Neon|Fly|Ride"] = 321.93, ["Mega"] = 313.69, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 512.5}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 6.88, ["Fly"] = 2152.53, ["Ride"] = 41.58, ["Fly|Ride"] = 252.14, ["Neon"] = 42, ["Neon|Ride"] = 93.69, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 284.26, ["Mega|Fly"] = 301.47, ["Mega|Ride"] = 280.88, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 36.62, ["Fly|Ride"] = 196.88, ["Neon"] = 8.66, ["Neon|Fly"] = 210, ["Neon|Ride"] = 39.38, ["Mega"] = 81.38, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 284.26}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 36.71, ["Fly|Ride"] = 91.23, ["Neon"] = 3.72, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 164.01, ["Mega"] = 32.82, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 18.98}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 62.01, ["Fly"] = 78.75, ["Ride"] = 58.5, ["Fly|Ride"] = 94.77, ["Neon"] = 180.43, ["Neon|Ride"] = 215.34, ["Neon|Fly|Ride"] = 312.38, ["Mega"] = 1854.36, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 888.56}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 65.63, ["Fly|Ride"] = 39.38, ["Neon"] = 2.3, ["Neon|Ride"] = 27.19, ["Mega"] = 20.39, ["Mega|Ride"] = 164.03, ["Mega|Fly|Ride"] = 323.01}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 457.31, ["Ride"] = 525, ["Fly|Ride"] = 572.25, ["Neon"] = 3875.01, ["Mega"] = 12916.65, ["Mega|Fly|Ride"] = 7083.3}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 3.05, ["Fly"] = 49.38, ["Ride"] = 33.74, ["Fly|Ride"] = 58.27, ["Neon"] = 72.99, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 73.22, ["Mega"] = 424.7, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 632}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.1, ["Fly"] = 29.12, ["Ride"] = 19.6, ["Fly|Ride"] = 45.94, ["Neon"] = 24.75, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 101.22, ["Mega"] = 164.01, ["Mega|Fly"] = 215.34, ["Mega|Ride"] = 163.67, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 13.8, ["Fly"] = 54.93, ["Ride"] = 52.5, ["Fly|Ride"] = 87.05, ["Neon"] = 114.45, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 460.82, ["Mega|Ride"] = 388.5, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.46, ["Fly"] = 43.07, ["Ride"] = 38.57, ["Fly|Ride"] = 72.16, ["Neon"] = 48.09, ["Neon|Fly"] = 72.16, ["Neon|Ride"] = 65.63, ["Mega"] = 288.88, ["Mega|Ride"] = 286.4, ["Mega|Fly|Ride"] = 532.83}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 7.86, ["Ride"] = 88.6, ["Fly|Ride"] = 202.13, ["Neon"] = 66.94, ["Neon|Ride"] = 118.12, ["Neon|Fly|Ride"] = 187.81, ["Mega"] = 537.26, ["Mega|Ride"] = 420.42, ["Mega|Fly|Ride"] = 531.57}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 5.43, ["Ride"] = 54.93, ["Fly|Ride"] = 144.63, ["Neon"] = 36.66, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 104.81, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 212.17, ["Mega|Ride"] = 357.47, ["Mega|Fly|Ride"] = 350.44}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 48.98, ["Ride"] = 13.64, ["Fly|Ride"] = 34.13, ["Neon"] = 2.1, ["Neon|Fly"] = 42, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 45.47, ["Mega"] = 15.61, ["Mega|Fly"] = 82.01, ["Mega|Ride"] = 37.67, ["Mega|Fly|Ride"] = 76.13}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 8.68, ["Fly"] = 42, ["Ride"] = 56.44, ["Fly|Ride"] = 107.68, ["Neon"] = 106.3, ["Neon|Fly"] = 122.4, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 151.16, ["Mega"] = 196.69, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 316.98}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 262.5, ["Ride"] = 283.5, ["Fly|Ride"] = 363.57, ["Neon"] = 1272.83, ["Neon|Ride"] = 1043.44, ["Neon|Fly|Ride"] = 1039.5, ["Mega|Ride"] = 9498.26, ["Mega|Fly|Ride"] = 4437.95}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 76.13, ["Ride"] = 104.99, ["Fly|Ride"] = 256.26, ["Neon"] = 393.75, ["Neon|Fly"] = 921.4, ["Neon|Ride"] = 479.07, ["Neon|Fly|Ride"] = 522.38, ["Mega"] = 2297.58, ["Mega|Ride"] = 1869, ["Mega|Fly|Ride"] = 1543.5}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 16.05, ["Ride"] = 16.22, ["Fly|Ride"] = 43.09, ["Neon"] = 11.82, ["Neon|Fly"] = 101.19, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 62.5, ["Mega"] = 144.24, ["Mega|Fly"] = 214.19, ["Mega|Ride"] = 128.13, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 21.55, ["Ride"] = 15.73, ["Fly|Ride"] = 38.59, ["Neon"] = 9.18, ["Neon|Fly"] = 31.96, ["Neon|Ride"] = 28.5, ["Neon|Fly|Ride"] = 52.41, ["Mega"] = 84, ["Mega|Fly"] = 287.48, ["Mega|Ride"] = 95.81, ["Mega|Fly|Ride"] = 153.6}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.92, ["Fly"] = 101.22, ["Ride"] = 28.01, ["Fly|Ride"] = 98.44, ["Neon"] = 40.94, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 326.71, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 216.57, ["Ride"] = 241.5, ["Fly|Ride"] = 319.05, ["Neon|Ride"] = 1048.69, ["Neon|Fly|Ride"] = 1290.12, ["Mega|Ride"] = 8611.11, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 50.61, ["Ride"] = 15.75, ["Fly|Ride"] = 54.84, ["Neon"] = 22.41, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 105, ["Mega"] = 286.12, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 286.4}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.78, ["Fly"] = 31.5, ["Ride"] = 78.75, ["Fly|Ride"] = 126.58, ["Neon"] = 29.09, ["Neon|Ride"] = 109.83, ["Mega"] = 299.25, ["Mega|Ride"] = 305.16, ["Mega|Fly|Ride"] = 430.67}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.52, ["Ride"] = 131.25, ["Neon"] = 19.69, ["Neon|Ride"] = 137.82, ["Mega"] = 136.24, ["Mega|Ride"] = 330.56}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 13.26, ["Fly"] = 58.13, ["Ride"] = 25.9, ["Fly|Ride"] = 65.63, ["Neon"] = 215.34, ["Neon|Ride"] = 62.99, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 459.38, ["Mega|Ride"] = 555.43, ["Mega|Fly|Ride"] = 532.95}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 41.79, ["Ride"] = 84.45, ["Fly|Ride"] = 574.95, ["Neon"] = 115.05, ["Neon|Fly"] = 288.75, ["Neon|Ride"] = 168.91, ["Neon|Fly|Ride"] = 333.38, ["Mega"] = 474.34, ["Mega|Fly"] = 2260.16, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 519}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 30.19, ["Fly"] = 101.22, ["Ride"] = 36.73, ["Fly|Ride"] = 103.95, ["Neon"] = 157.5, ["Neon|Fly"] = 286.43, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 861.13, ["Mega|Ride"] = 702.19, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 21.55, ["Ride"] = 13.89, ["Fly|Ride"] = 45.92, ["Neon"] = 2.1, ["Neon|Fly"] = 32.65, ["Neon|Ride"] = 16.95, ["Neon|Fly|Ride"] = 45.92, ["Mega"] = 17.68, ["Mega|Fly"] = 42, ["Mega|Ride"] = 35.33, ["Mega|Fly|Ride"] = 89.65}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 253.56, ["Ride"] = 282.19, ["Fly|Ride"] = 420.86, ["Neon"] = 3426.75, ["Neon|Ride"] = 1393.2, ["Neon|Fly|Ride"] = 1398.57, ["Mega|Fly|Ride"] = 4977.19}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 10.28, ["Fly"] = 101.19, ["Ride"] = 28.73, ["Fly|Ride"] = 111.57, ["Neon"] = 79.66, ["Neon|Ride"] = 144.29, ["Neon|Fly|Ride"] = 446.82, ["Mega"] = 380.63, ["Mega|Ride"] = 488.63, ["Mega|Fly|Ride"] = 441.18}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 36.62, ["Ride"] = 19.14, ["Fly|Ride"] = 47.39, ["Neon"] = 6.15, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 29.09, ["Neon|Fly|Ride"] = 107.68, ["Mega"] = 45.94, ["Mega|Fly"] = 230.42, ["Mega|Ride"] = 116.55, ["Mega|Fly|Ride"] = 324.84}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 23.79, ["Fly|Ride"] = 86.12, ["Neon"] = 3.19, ["Neon|Fly"] = 82, ["Neon|Ride"] = 24.62, ["Neon|Fly|Ride"] = 110.17, ["Mega"] = 28.17, ["Mega|Fly"] = 144.21, ["Mega|Ride"] = 40.58, ["Mega|Fly|Ride"] = 166.91}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.59, ["Ride"] = 37.69, ["Fly|Ride"] = 91.87, ["Neon"] = 10.49, ["Neon|Fly"] = 734.28, ["Neon|Ride"] = 63.14, ["Mega"] = 152.92, ["Mega|Ride"] = 195.21, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 11.16, ["Fly"] = 47.24, ["Ride"] = 28.87, ["Fly|Ride"] = 69.57, ["Neon"] = 47.16, ["Neon|Fly"] = 258.41, ["Neon|Ride"] = 51.18, ["Neon|Fly|Ride"] = 105, ["Mega"] = 288.15, ["Mega|Ride"] = 344.54, ["Mega|Fly|Ride"] = 384.74}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 5.76, ["Ride"] = 32.82, ["Neon"] = 43.07, ["Neon|Ride"] = 148.59, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 275.63, ["Mega|Ride"] = 325.57, ["Mega|Fly|Ride"] = 301.87}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Neon"] = 2.61, ["Neon|Ride"] = 58.15, ["Neon|Fly|Ride"] = 115.22, ["Mega"] = 20.88, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 208.61}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 10.05, ["Fly"] = 83.99, ["Ride"] = 28.88, ["Fly|Ride"] = 172.29, ["Neon"] = 32.45, ["Neon|Ride"] = 96.87, ["Neon|Fly|Ride"] = 144.41, ["Mega"] = 229.69, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 359.62}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 31.49, ["Neon"] = 5.08, ["Neon|Fly"] = 115.22, ["Neon|Ride"] = 39.32, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 30.17, ["Mega|Ride"] = 144.29, ["Mega|Fly|Ride"] = 245.44}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 59.04, ["Ride"] = 19.68, ["Fly|Ride"] = 43.32, ["Neon"] = 5.24, ["Neon|Ride"] = 28.86, ["Neon|Fly|Ride"] = 86.16, ["Mega"] = 55.62, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 284.53}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 654.93, ["Ride"] = 708.75, ["Fly|Ride"] = 771.75, ["Neon"] = 2625, ["Neon|Ride"] = 3427.2, ["Neon|Fly|Ride"] = 3150, ["Mega|Fly|Ride"] = 9620.63}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 18.34, ["Ride"] = 15.61, ["Fly|Ride"] = 64.99, ["Neon"] = 33.06, ["Neon|Fly"] = 43.09, ["Neon|Ride"] = 26.99, ["Neon|Fly|Ride"] = 101.22, ["Mega|Fly|Ride"] = 326.8}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 46.82, ["Fly|Ride"] = 43.05, ["Neon"] = 8.8, ["Neon|Fly"] = 753.48, ["Neon|Ride"] = 58.7, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 103.67, ["Mega|Fly"] = 210.9, ["Mega|Ride"] = 131.73, ["Mega|Fly|Ride"] = 273.63}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 6.01, ["Fly"] = 23.69, ["Ride"] = 25.7, ["Fly|Ride"] = 54.38, ["Neon"] = 43.32, ["Neon|Fly"] = 195.83, ["Neon|Ride"] = 71.08, ["Neon|Fly|Ride"] = 115.5, ["Mega"] = 485.63, ["Mega|Ride"] = 290.07, ["Mega|Fly|Ride"] = 376.69}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 58.15, ["Ride"] = 15.59, ["Fly|Ride"] = 45.94, ["Neon"] = 8.9, ["Neon|Fly"] = 52.48, ["Neon|Ride"] = 27.27, ["Neon|Fly|Ride"] = 67.47, ["Mega"] = 69.04, ["Mega|Ride"] = 95.51, ["Mega|Fly|Ride"] = 181.34}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 51.19, ["Ride"] = 78.75, ["Neon"] = 236.25, ["Neon|Ride"] = 330.56, ["Mega"] = 1005.73, ["Mega|Ride"] = 838.72, ["Mega|Fly|Ride"] = 852.41}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 29.09, ["Fly|Ride"] = 74.73, ["Neon"] = 7.55, ["Neon|Fly"] = 139.55, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 127.07, ["Mega"] = 47.16, ["Mega|Ride"] = 131.72, ["Mega|Fly|Ride"] = 271.67}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 26.22, ["Fly|Ride"] = 93.12, ["Neon"] = 11.8, ["Neon|Ride"] = 50.16, ["Mega"] = 115.4, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 325.5}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Ride"] = 43.09, ["Fly|Ride"] = 65.84, ["Neon"] = 12.67, ["Mega"] = 103.69, ["Mega|Ride"] = 161.47, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 2583.35, ["Ride"] = 19.39, ["Fly|Ride"] = 69.45, ["Neon"] = 4.73, ["Neon|Fly"] = 72.16, ["Neon|Ride"] = 22.43, ["Neon|Fly|Ride"] = 107.56, ["Mega"] = 59.06, ["Mega|Fly"] = 229.69, ["Mega|Ride"] = 62.91}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 13.44, ["Fly"] = 21.41, ["Ride"] = 22.02, ["Fly|Ride"] = 43.94, ["Neon"] = 122.4, ["Neon|Fly"] = 123.31, ["Neon|Ride"] = 114.09, ["Neon|Fly|Ride"] = 141.06, ["Mega"] = 393.75, ["Mega|Ride"] = 861.33, ["Mega|Fly|Ride"] = 488.95}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 725.82, ["Ride"] = 735, ["Fly|Ride"] = 905.63, ["Neon"] = 1585.49, ["Neon|Ride"] = 1569.75, ["Neon|Fly|Ride"] = 1837.5, ["Mega"] = 8611.11, ["Mega|Ride"] = 5763.52, ["Mega|Fly|Ride"] = 4463.82}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 68.25, ["Ride"] = 19.23, ["Fly|Ride"] = 46.59, ["Neon"] = 3.9, ["Neon|Fly"] = 36.62, ["Neon|Ride"] = 28.59, ["Neon|Fly|Ride"] = 53.85, ["Mega"] = 31.49, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 121.61}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 3.77, ["Ride"] = 36.75, ["Fly|Ride"] = 244.78, ["Neon"] = 42, ["Neon|Ride"] = 205.22, ["Neon|Fly|Ride"] = 581.44, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 553.81}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 59.6, ["Fly"] = 156.19, ["Ride"] = 78.85, ["Fly|Ride"] = 110.83, ["Neon"] = 489.62, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 367.49, ["Mega"] = 2447.55, ["Mega|Fly|Ride"] = 1808.79}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 28.48, ["Fly"] = 144.24, ["Ride"] = 58.26, ["Fly|Ride"] = 102.3, ["Neon"] = 145.28, ["Neon|Ride"] = 129.22, ["Mega"] = 1468.64, ["Mega|Ride"] = 946.63, ["Mega|Fly|Ride"] = 789.12}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 7.25, ["Ride"] = 36.62, ["Fly|Ride"] = 105, ["Neon"] = 68.25, ["Neon|Ride"] = 98.27, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 308.74, ["Mega|Ride"] = 340.88, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 22.23, ["Ride"] = 71, ["Fly|Ride"] = 159.37, ["Neon"] = 107.68, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 309, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 397.69}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 24.55, ["Ride"] = 165.76, ["Neon"] = 258.41, ["Neon|Ride"] = 177.19, ["Neon|Fly|Ride"] = 373.61, ["Mega"] = 574.95, ["Mega|Ride"] = 476.44, ["Mega|Fly|Ride"] = 717.07}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 15.19}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 3.19, ["Ride"] = 21.54, ["Fly|Ride"] = 101.16, ["Neon"] = 26.23, ["Neon|Ride"] = 66.77, ["Neon|Fly|Ride"] = 213.98, ["Mega"] = 155.93, ["Mega|Fly"] = 462.9, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 311.17}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.71, ["Neon"] = 23.62, ["Mega"] = 139.32, ["Mega|Fly|Ride"] = 385.88}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 32.03, ["Fly"] = 63, ["Ride"] = 48.56, ["Fly|Ride"] = 85.32, ["Neon"] = 147, ["Neon|Fly"] = 215.34, ["Neon|Ride"] = 190.15, ["Neon|Fly|Ride"] = 290.61, ["Mega"] = 1260.57, ["Mega|Ride"] = 782.74, ["Mega|Fly|Ride"] = 719.99}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 2.1, ["Fly"] = 19.86, ["Ride"] = 17.05, ["Fly|Ride"] = 36.75, ["Neon"] = 34.72, ["Neon|Fly"] = 42.94, ["Neon|Ride"] = 28.74, ["Neon|Fly|Ride"] = 78.63, ["Mega"] = 191.63, ["Mega|Fly"] = 430.67, ["Mega|Ride"] = 183.74, ["Mega|Fly|Ride"] = 210.5}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 5.29, ["Fly"] = 107.29, ["Ride"] = 29.28, ["Fly|Ride"] = 63.74, ["Neon"] = 24.49, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 291.3, ["Mega|Ride"] = 188.99, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 8.64, ["Mega"] = 96.71, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 30.44, ["Ride"] = 44.63, ["Fly|Ride"] = 164.01, ["Neon"] = 273.49, ["Neon|Ride"] = 235.82, ["Neon|Fly|Ride"] = 359.66, ["Mega|Ride"] = 1722.03, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 36.93, ["Fly|Ride"] = 58.15, ["Neon"] = 6.27, ["Neon|Fly"] = 203.44, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 105, ["Mega"] = 78.75, ["Mega|Ride"] = 142.79}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 11.59, ["Ride"] = 91.88, ["Fly|Ride"] = 210, ["Neon"] = 73.5, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 406.88, ["Mega|Fly"] = 574.95, ["Mega|Ride"] = 425.15, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.93, ["Ride"] = 16.42, ["Fly|Ride"] = 43.07, ["Neon"] = 14.53, ["Neon|Ride"] = 21.55, ["Neon|Fly|Ride"] = 100.36, ["Mega"] = 157.2, ["Mega|Ride"] = 157.88, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 3.86, ["Fly"] = 52.49, ["Ride"] = 21.87, ["Fly|Ride"] = 57.47, ["Neon"] = 90.57, ["Neon|Fly"] = 71.08, ["Neon|Ride"] = 144.25, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 273.49, ["Mega|Ride"] = 387.48, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 14.57, ["Neon"] = 89.38, ["Mega"] = 422.29, ["Mega|Ride"] = 380.77, ["Mega|Fly|Ride"] = 645.74}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 83.24, ["Ride"] = 131.25, ["Neon"] = 275.63, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 669.38, ["Mega"] = 1102.5, ["Mega|Ride"] = 1274.77, ["Mega|Fly|Ride"] = 1286.25}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 17.69, ["Fly"] = 129.21, ["Ride"] = 78.75, ["Fly|Ride"] = 161.28, ["Neon"] = 107.63, ["Mega"] = 422.63, ["Mega|Ride"] = 418.69, ["Mega|Fly|Ride"] = 685.37}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 4.94, ["Ride"] = 115.26, ["Neon"] = 149.62, ["Neon|Fly"] = 215.34, ["Neon|Ride"] = 170.63, ["Mega|Ride"] = 459.38}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 27.19, ["Ride"] = 128.14, ["Fly|Ride"] = 367.49, ["Neon"] = 164.72, ["Neon|Fly"] = 262.71, ["Neon|Ride"] = 215.28, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 861.33, ["Mega|Fly"] = 2152.53, ["Mega|Ride"] = 644.93, ["Mega|Fly|Ride"] = 851.44}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.45, ["Neon"] = 23.59, ["Neon|Fly|Ride"] = 144.29, ["Mega"] = 198.19, ["Mega|Ride"] = 254.61, ["Mega|Fly|Ride"] = 326.82}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 15.98, ["Fly|Ride"] = 54.93, ["Neon"] = 5.24, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 27.01, ["Neon|Fly|Ride"] = 57.66, ["Mega"] = 48.28, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 3.62, ["Fly"] = 45.94, ["Ride"] = 31.84, ["Fly|Ride"] = 83.99, ["Neon"] = 15.74, ["Neon|Ride"] = 36.68, ["Neon|Fly|Ride"] = 164.04, ["Mega"] = 90.96, ["Mega|Ride"] = 103.98, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 144.24, ["Ride"] = 21, ["Fly|Ride"] = 72, ["Neon"] = 5.16, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 101.18, ["Mega"] = 56.69, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 326.8}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 65.62, ["Ride"] = 23.7, ["Fly|Ride"] = 84, ["Neon"] = 23.91, ["Neon|Ride"] = 144.29, ["Neon|Fly|Ride"] = 215.34, ["Mega"] = 127.21, ["Mega|Ride"] = 313.95, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.74, ["Fly"] = 65.44, ["Ride"] = 32.82, ["Fly|Ride"] = 86.17, ["Neon"] = 30.82, ["Neon|Fly"] = 315, ["Neon|Ride"] = 58.15, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 306.99, ["Mega|Ride"] = 287.47, ["Mega|Fly|Ride"] = 1076.4}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 5.11, ["Fly"] = 131.24, ["Ride"] = 23.9, ["Fly|Ride"] = 62.89, ["Neon"] = 54.91, ["Neon|Fly"] = 135.68, ["Neon|Ride"] = 49.3, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 216.57, ["Mega|Fly"] = 270.19, ["Mega|Ride"] = 430.67, ["Mega|Fly|Ride"] = 646}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.49, ["Ride"] = 22.2, ["Fly|Ride"] = 52.41, ["Neon"] = 36.39, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 150.74, ["Mega"] = 273.38, ["Mega|Ride"] = 315.67, ["Mega|Fly|Ride"] = 191.89}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 4.81, ["Fly"] = 144.24, ["Ride"] = 47.23, ["Neon"] = 15.33, ["Neon|Fly"] = 437.06, ["Neon|Ride"] = 74.24, ["Neon|Fly|Ride"] = 140.47, ["Mega"] = 105, ["Mega|Fly"] = 216.81, ["Mega|Ride"] = 154.2, ["Mega|Fly|Ride"] = 280.35}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 15.51, ["Ride"] = 83.98, ["Fly|Ride"] = 192.95, ["Neon"] = 106.32, ["Neon|Ride"] = 206.07, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 635.31, ["Mega|Ride"] = 774.82, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 48.56, ["Fly"] = 164.07, ["Ride"] = 91.88, ["Fly|Ride"] = 129.94, ["Neon"] = 240.91, ["Neon|Ride"] = 266.44, ["Neon|Fly|Ride"] = 314.97, ["Mega"] = 1578.39, ["Mega|Ride"] = 1048.69, ["Mega|Fly|Ride"] = 997.5}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Ride"] = 23.69, ["Fly|Ride"] = 51.79, ["Neon"] = 3.7, ["Neon|Ride"] = 28.01, ["Neon|Fly|Ride"] = 144.24, ["Mega"] = 53.72, ["Mega|Ride"] = 71.08, ["Mega|Fly|Ride"] = 145.69}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 10.75, ["Ride"] = 105, ["Neon"] = 105.94, ["Mega"] = 704.13, ["Mega|Fly|Ride"] = 1131.57}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 63.2, ["Ride"] = 65.54, ["Fly|Ride"] = 171.21, ["Neon"] = 249.38, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 418.99, ["Mega"] = 1774.34, ["Mega|Ride"] = 1291.99, ["Mega|Fly|Ride"] = 3228.78}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 7.25, ["Fly"] = 190.32, ["Ride"] = 40.94, ["Fly|Ride"] = 133.88, ["Neon"] = 39.35, ["Neon|Fly"] = 130.96, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 165.24, ["Mega"] = 270.17, ["Mega|Fly"] = 739.2, ["Mega|Ride"] = 239.5, ["Mega|Fly|Ride"] = 285.87}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 6.45, ["Neon"] = 14.32, ["Neon|Ride"] = 55.83, ["Neon|Fly|Ride"] = 210, ["Mega"] = 104.35, ["Mega|Fly"] = 282.17, ["Mega|Ride"] = 424.47, ["Mega|Fly|Ride"] = 287.48}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 67.82, ["Ride"] = 19.28, ["Fly|Ride"] = 58.3, ["Neon"] = 14.42, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 97.44, ["Mega"] = 115.5, ["Mega|Fly"] = 196.87, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 212.98}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 21.45, ["Ride"] = 15.47, ["Fly|Ride"] = 52.49, ["Neon"] = 2.55, ["Neon|Fly"] = 129.17, ["Neon|Ride"] = 23.39, ["Neon|Fly|Ride"] = 58.16, ["Mega"] = 28.88, ["Mega|Ride"] = 73.45, ["Mega|Fly|Ride"] = 142.79}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 16.16, ["Fly|Ride"] = 93.08, ["Neon"] = 3.72, ["Neon|Ride"] = 24.49, ["Neon|Fly|Ride"] = 97.44, ["Mega"] = 41.99, ["Mega|Ride"] = 51.19, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Neon"] = 3.59, ["Neon|Ride"] = 43.09, ["Mega"] = 22.31, ["Mega|Fly|Ride"] = 444.94}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 6.14, ["Ride"] = 40.95, ["Neon"] = 53.33, ["Neon|Ride"] = 82.6, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 287.48, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 7.18, ["Ride"] = 30.19, ["Fly|Ride"] = 215.34, ["Neon"] = 72.19, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 140.07, ["Mega"] = 287.44, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 464.63}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 6.03, ["Fly"] = 23.62, ["Ride"] = 19.65, ["Fly|Ride"] = 48.86, ["Neon"] = 52.89, ["Neon|Ride"] = 42.39, ["Neon|Fly|Ride"] = 100.94, ["Mega|Ride"] = 317.71, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 72.06, ["Ride"] = 98.44, ["Fly|Ride"] = 124.69, ["Neon"] = 393.75, ["Neon|Ride"] = 538.35, ["Mega"] = 2447.72, ["Mega|Ride"] = 1627.9, ["Mega|Fly|Ride"] = 1544.82}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 21.63, ["Fly"] = 57.75, ["Ride"] = 28.88, ["Fly|Ride"] = 129.21, ["Neon|Fly|Ride"] = 630, ["Mega"] = 464.63, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 1050.67}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 18.75, ["Fly|Ride"] = 41.99, ["Neon"] = 2.6, ["Neon|Fly"] = 43.09, ["Neon|Ride"] = 23.51, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 31.84, ["Mega|Ride"] = 93.45, ["Mega|Fly|Ride"] = 262.48}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 19.51, ["Ride"] = 15.44, ["Fly|Ride"] = 39.29, ["Neon"] = 6.45, ["Neon|Fly"] = 19.69, ["Neon|Ride"] = 21.2, ["Neon|Fly|Ride"] = 53.72, ["Mega"] = 48.98, ["Mega|Ride"] = 49.79, ["Mega|Fly|Ride"] = 115.64}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 419.99, ["Fly"] = 575.24, ["Ride"] = 492.55, ["Fly|Ride"] = 530.15, ["Neon"] = 2440.76, ["Neon|Fly|Ride"] = 2098.69, ["Mega|Fly|Ride"] = 9465.31}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 5.44, ["Ride"] = 33.06, ["Fly|Ride"] = 71.31, ["Neon"] = 45.94, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 416.69, ["Mega|Ride"] = 368.89, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 17.17, ["Fly|Ride"] = 34.13, ["Neon"] = 3.94, ["Neon|Fly"] = 22.66, ["Neon|Ride"] = 18.32, ["Neon|Fly|Ride"] = 56.42, ["Mega"] = 43.05, ["Mega|Ride"] = 71.08, ["Mega|Fly|Ride"] = 115.22}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 49.35, ["Ride"] = 122.73, ["Fly|Ride"] = 717.96, ["Neon"] = 208.69, ["Neon|Ride"] = 282.19, ["Neon|Fly|Ride"] = 564.19, ["Mega"] = 796.11, ["Mega|Ride"] = 761.25, ["Mega|Fly|Ride"] = 852.86}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 44.62, ["Ride"] = 28.23, ["Fly|Ride"] = 63.7, ["Neon"] = 17.32, ["Neon|Fly"] = 101.36, ["Neon|Ride"] = 32.13, ["Neon|Fly|Ride"] = 90.55, ["Mega"] = 110.25, ["Mega|Ride"] = 127.3, ["Mega|Fly|Ride"] = 245}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Ride"] = 20.51, ["Fly|Ride"] = 196.88, ["Neon"] = 3.32, ["Neon|Fly"] = 101.22, ["Neon|Ride"] = 144.23, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 24.23, ["Mega|Ride"] = 52.48, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 43.18, ["Fly"] = 129.94, ["Ride"] = 78.75, ["Fly|Ride"] = 214.27, ["Neon"] = 150.94, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 797.5, ["Mega|Ride"] = 653.59, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Fly|Ride"] = 146.99, ["Neon"] = 7.87, ["Neon|Ride"] = 23.64, ["Neon|Fly|Ride"] = 344.54, ["Mega"] = 57.75, ["Mega|Ride"] = 86.63, ["Mega|Fly|Ride"] = 244.59}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 40.57, ["Ride"] = 72.41, ["Fly|Ride"] = 129.94, ["Neon"] = 283.23, ["Neon|Fly"] = 287.48, ["Neon|Ride"] = 212.98, ["Neon|Fly|Ride"] = 321.93, ["Mega"] = 1181.25, ["Mega|Ride"] = 1291.99, ["Mega|Fly|Ride"] = 1330.74}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.2, ["Ride"] = 36.74, ["Fly|Ride"] = 430.67, ["Neon"] = 33.09, ["Neon|Ride"] = 231, ["Neon|Fly|Ride"] = 502.63, ["Mega"] = 157.5, ["Mega|Ride"] = 164.01}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 33.06, ["Ride"] = 81.36, ["Fly|Ride"] = 58.15, ["Neon"] = 9.19, ["Neon|Ride"] = 43.35, ["Neon|Fly|Ride"] = 107.68, ["Mega"] = 117.6, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 190.97}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 57.66, ["Fly"] = 187.36, ["Ride"] = 178.75, ["Fly|Ride"] = 195.57, ["Neon"] = 359.63, ["Mega|Ride"] = 2756.25}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 593.43, ["Ride"] = 34.54, ["Neon"] = 7.16, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 146.88, ["Mega"] = 45.82, ["Mega|Fly"] = 215.34, ["Mega|Ride"] = 110.76, ["Mega|Fly|Ride"] = 263.1}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 28.01, ["Ride"] = 20.98, ["Fly|Ride"] = 43.09, ["Neon"] = 8.64, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 86.89, ["Mega"] = 58.15, ["Mega|Fly"] = 150.57, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 220.31}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 7.68, ["Fly"] = 30.19, ["Ride"] = 39.35, ["Fly|Ride"] = 195.85, ["Neon"] = 83.99, ["Neon|Fly"] = 130.99, ["Neon|Ride"] = 83.16, ["Neon|Fly|Ride"] = 213.1, ["Mega"] = 328.13, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 409.21}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 8.78, ["Fly"] = 38.06, ["Ride"] = 34.14, ["Fly|Ride"] = 65.63, ["Neon"] = 53.24, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 111.54, ["Mega"] = 354.38, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 434.88}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 18.35, ["Fly"] = 28.88, ["Ride"] = 22.3, ["Fly|Ride"] = 50.61, ["Neon"] = 103.69, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 172.29, ["Mega"] = 777.07, ["Mega|Ride"] = 331.34, ["Mega|Fly|Ride"] = 340.48}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 69.44, ["Ride"] = 99.73, ["Fly|Ride"] = 262.5, ["Neon"] = 315, ["Neon|Ride"] = 324.84, ["Neon|Fly|Ride"] = 532.98, ["Mega|Ride"] = 1752.79, ["Mega|Fly|Ride"] = 2122.43}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 11.9, ["Ride"] = 115.12, ["Fly|Ride"] = 422.24, ["Neon"] = 65.54, ["Neon|Ride"] = 168.92, ["Neon|Fly|Ride"] = 351.01, ["Mega"] = 309.25, ["Mega|Ride"] = 462}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 4.99, ["Ride"] = 25.57, ["Fly|Ride"] = 78.75, ["Neon"] = 22.32, ["Neon|Ride"] = 47.25, ["Mega"] = 120.25, ["Mega|Ride"] = 243.33, ["Mega|Fly|Ride"] = 267.02}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 10.9, ["Fly"] = 135.19, ["Ride"] = 41.63, ["Fly|Ride"] = 89.25, ["Neon"] = 72.16, ["Neon|Fly"] = 105, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 172.29, ["Mega"] = 317.63, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 497.44}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.6, ["Ride"] = 14.01, ["Fly|Ride"] = 45.94, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 15.6, ["Neon|Fly|Ride"] = 43.24, ["Mega"] = 15.09, ["Mega|Fly"] = 41.99, ["Mega|Ride"] = 28.86, ["Mega|Fly|Ride"] = 115.49}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 56.6, ["Fly"] = 164.07, ["Ride"] = 115.22, ["Neon"] = 233.89, ["Neon|Fly"] = 2440.18, ["Neon|Ride"] = 192.94, ["Mega"] = 1076.66, ["Mega|Ride"] = 890.39, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 24.78, ["Fly|Ride"] = 144.09, ["Neon"] = 3.13, ["Neon|Fly"] = 131.25, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 33.06, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 18.44, ["Fly|Ride"] = 45.93, ["Neon"] = 26.31, ["Neon|Ride"] = 27.58, ["Neon|Fly|Ride"] = 90.03, ["Mega"] = 252, ["Mega|Ride"] = 198.26}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 56.35, ["Ride"] = 96.45, ["Fly|Ride"] = 131.25, ["Neon"] = 247.96, ["Neon|Ride"] = 344.84, ["Neon|Fly|Ride"] = 409.5, ["Mega"] = 949.85, ["Mega|Ride"] = 800.63, ["Mega|Fly|Ride"] = 983.21}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 72.19, ["Neon"] = 6.2, ["Neon|Ride"] = 34.59, ["Neon|Fly|Ride"] = 144.29, ["Mega"] = 58.96, ["Mega|Ride"] = 144.63, ["Mega|Fly|Ride"] = 243.62}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 5.25}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 141.01, ["Neon"] = 5.08, ["Neon|Ride"] = 116.93, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 41.63, ["Mega|Ride"] = 110.71, ["Mega|Fly|Ride"] = 194.53}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 124.94, ["Ride"] = 210, ["Fly|Ride"] = 210.95, ["Neon"] = 646.08, ["Neon|Ride"] = 629.99, ["Neon|Fly|Ride"] = 678.57, ["Mega"] = 6457.55, ["Mega|Ride"] = 3264.42, ["Mega|Fly|Ride"] = 2506.41}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2.1, ["Ride"] = 142.78, ["Fly|Ride"] = 215.34, ["Neon"] = 33.04, ["Neon|Fly"] = 144.29, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 219.43, ["Mega"] = 165.54, ["Mega|Ride"] = 248.24, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 24.92, ["Neon"] = 3.72, ["Neon|Ride"] = 22.23, ["Mega"] = 45.92, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 48.57, ["Mega|Fly|Ride"] = 307.13}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 5.12, ["Ride"] = 36.73, ["Fly|Ride"] = 101.22, ["Neon"] = 60.29, ["Neon|Ride"] = 106.61, ["Neon|Fly|Ride"] = 159.37, ["Mega"] = 318.27, ["Mega|Ride"] = 579.12, ["Mega|Fly|Ride"] = 684.6}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 11.27, ["Fly"] = 60.92, ["Ride"] = 20.19, ["Fly|Ride"] = 62.46, ["Neon"] = 101.04, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 215.34, ["Mega"] = 640.5, ["Mega|Ride"] = 283.5, ["Mega|Fly|Ride"] = 492.19}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 24.93, ["Ride"] = 62.35, ["Fly|Ride"] = 205.57, ["Neon"] = 150.26, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 344.54, ["Mega"] = 552.57, ["Mega|Ride"] = 551.25, ["Mega|Fly|Ride"] = 565.79}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 126, ["Fly"] = 168, ["Ride"] = 164.07, ["Fly|Ride"] = 241.69, ["Neon"] = 689.07, ["Neon|Ride"] = 510.57, ["Neon|Fly|Ride"] = 656.25, ["Mega|Fly|Ride"] = 2512.92}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 6.19, ["Fly"] = 20.98, ["Ride"] = 19.53, ["Fly|Ride"] = 43.38, ["Neon"] = 58.15, ["Neon|Fly"] = 160.34, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 81.35, ["Mega|Ride"] = 326.8, ["Mega|Fly|Ride"] = 416.07}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.61, ["Fly"] = 72.16, ["Ride"] = 46.51, ["Fly|Ride"] = 131.25, ["Neon"] = 19.09, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 115.06, ["Mega"] = 157.5, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 5.09, ["Fly"] = 43.2, ["Ride"] = 40.69, ["Fly|Ride"] = 76.13, ["Neon"] = 38.58, ["Neon|Fly"] = 80.77, ["Neon|Ride"] = 51.96, ["Neon|Fly|Ride"] = 159.37, ["Mega"] = 534.89, ["Mega|Ride"] = 407.54, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 50.1, ["Fly"] = 82.62, ["Ride"] = 77.44, ["Fly|Ride"] = 118.13, ["Neon"] = 219.19, ["Neon|Ride"] = 242.29, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 826.27, ["Mega|Ride"] = 786.19, ["Mega|Fly|Ride"] = 1060.54}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 16.99, ["Ride"] = 164.07, ["Neon"] = 196.87, ["Neon|Ride"] = 257.33, ["Mega"] = 732.82, ["Mega|Ride"] = 714.65}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 236.12, ["Ride"] = 350.44, ["Neon"] = 1312.5, ["Neon|Ride"] = 1632.64, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4198.69}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 28.48, ["Ride"] = 33.3, ["Fly|Ride"] = 69.46, ["Neon"] = 428.52, ["Neon|Ride"] = 277.8, ["Neon|Fly|Ride"] = 347.76, ["Mega"] = 761.25, ["Mega|Ride"] = 761.25, ["Mega|Fly|Ride"] = 1720.49}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 41.56, ["Ride"] = 14.43, ["Fly|Ride"] = 124.88, ["Neon"] = 2.21, ["Neon|Ride"] = 16.93, ["Neon|Fly|Ride"] = 45.47, ["Mega"] = 19.4, ["Mega|Fly"] = 114.14, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 107.63}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Ride"] = 43.09, ["Neon"] = 19.59, ["Neon|Ride"] = 524.89, ["Neon|Fly|Ride"] = 164.04, ["Mega"] = 196.88, ["Mega|Ride"] = 140.43, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 2.1, ["Ride"] = 32.7, ["Fly|Ride"] = 58.15, ["Neon"] = 18.44, ["Neon|Ride"] = 64.61, ["Neon|Fly|Ride"] = 144.38, ["Mega|Fly"] = 574.95, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 327.48}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 393.65, ["Fly"] = 393.75, ["Ride"] = 419.99, ["Fly|Ride"] = 518.43, ["Neon"] = 1888.69, ["Neon|Ride"] = 1923.52, ["Neon|Fly|Ride"] = 1929.38, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 17.05, ["Fly|Ride"] = 48.55, ["Neon"] = 26.83, ["Neon|Ride"] = 36.62, ["Neon|Fly|Ride"] = 118.42, ["Mega"] = 248.07, ["Mega|Ride"] = 154.63, ["Mega|Fly|Ride"] = 233.63}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 3.48, ["Fly"] = 28.01, ["Ride"] = 16.7, ["Fly|Ride"] = 44.62, ["Neon"] = 50.91, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 63.54, ["Neon|Fly|Ride"] = 139.13, ["Mega"] = 368.23, ["Mega|Ride"] = 296.08, ["Mega|Fly|Ride"] = 328.02}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.61, ["Fly"] = 39.38, ["Ride"] = 26.25, ["Fly|Ride"] = 69.18, ["Neon"] = 18.24, ["Neon|Fly"] = 94.48, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 127.32, ["Mega"] = 94.5, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 34.2, ["Fly"] = 73.45, ["Ride"] = 34.13, ["Fly|Ride"] = 86.91, ["Neon"] = 220.5, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 321.93, ["Mega"] = 1291.68, ["Mega|Ride"] = 860.26, ["Mega|Fly|Ride"] = 773.05}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 52.5, ["Fly|Ride"] = 52.38, ["Neon"] = 13.83, ["Neon|Ride"] = 106.5, ["Neon|Fly|Ride"] = 210, ["Mega"] = 167.08, ["Mega|Ride"] = 205.23, ["Mega|Fly|Ride"] = 748.79}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 57.18, ["Fly"] = 118.13, ["Ride"] = 29.09, ["Neon"] = 213.7, ["Neon|Fly|Ride"] = 259.23, ["Mega|Ride"] = 918.75}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 44.3, ["Neon"] = 7.53, ["Neon|Ride"] = 144.27, ["Neon|Fly|Ride"] = 84, ["Mega"] = 84, ["Mega|Fly"] = 86304.75, ["Mega|Ride"] = 144.24, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 11.59, ["Neon"] = 65.54, ["Mega"] = 137.4, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 814.42}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 11.82, ["Ride"] = 78.75, ["Fly|Ride"] = 86.17, ["Neon"] = 47, ["Neon|Ride"] = 287.48, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 318.15, ["Mega|Ride"] = 489.62, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 9.35, ["Fly"] = 34.04, ["Ride"] = 29.25, ["Fly|Ride"] = 48.48, ["Neon"] = 57.75, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 56.98, ["Neon|Fly|Ride"] = 109.32, ["Mega"] = 537.26, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 476.43, ["Fly"] = 679.25, ["Ride"] = 442.3, ["Fly|Ride"] = 544.68, ["Neon"] = 1659.67, ["Neon|Fly"] = 2072.89, ["Neon|Ride"] = 3570, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 7422.4}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 19, ["Fly|Ride"] = 36.75, ["Neon"] = 14.81, ["Neon|Fly"] = 82.02, ["Neon|Ride"] = 32.29, ["Neon|Fly|Ride"] = 105, ["Mega"] = 266.93, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 307.19}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 20.86, ["Fly"] = 85.99, ["Ride"] = 72.16, ["Fly|Ride"] = 287.48, ["Neon"] = 111.57, ["Neon|Ride"] = 178.69, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 433.13, ["Mega|Fly"] = 718.13, ["Mega|Ride"] = 568.2, ["Mega|Fly|Ride"] = 393.74}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 26.14, ["Ride"] = 104.99, ["Fly|Ride"] = 200.27, ["Neon"] = 69.93, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 361.05, ["Mega"] = 294.55, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 459.37}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 59.74, ["Fly"] = 169.21, ["Ride"] = 86.34, ["Fly|Ride"] = 144.38, ["Neon"] = 430.67, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 380.62, ["Mega"] = 2542.7, ["Mega|Ride"] = 1938.44, ["Mega|Fly|Ride"] = 2642.11}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 12.21, ["Ride"] = 58.47, ["Fly|Ride"] = 131.25, ["Neon"] = 44.4, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 198.19, ["Mega"] = 200.71, ["Mega|Fly"] = 366.16, ["Mega|Ride"] = 239.16, ["Mega|Fly|Ride"] = 429.43}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 19.69, ["Fly|Ride"] = 59.07, ["Neon"] = 18.35, ["Neon|Ride"] = 43.29, ["Neon|Fly|Ride"] = 79.54, ["Mega"] = 102.38, ["Mega|Ride"] = 146.24, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 7.69, ["Ride"] = 69.06, ["Neon"] = 26.24, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 147, ["Mega|Fly"] = 416.69, ["Mega|Ride"] = 187.36, ["Mega|Fly|Ride"] = 251.9}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 55.76, ["Fly"] = 183.75, ["Ride"] = 81.98, ["Fly|Ride"] = 197.98, ["Neon"] = 133.42, ["Neon|Ride"] = 190.31, ["Neon|Fly|Ride"] = 273.78, ["Mega"] = 421.21, ["Mega|Ride"] = 426.57, ["Mega|Fly|Ride"] = 482.01}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Fly"] = 115.22, ["Ride"] = 85.3, ["Neon"] = 8.6, ["Neon|Ride"] = 97.92, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 78.63, ["Mega|Ride"] = 123.38}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 25.85, ["Ride"] = 157.5, ["Neon"] = 320.25, ["Mega"] = 719.7, ["Mega|Fly|Ride"] = 854.97}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 958.01, ["Fly"] = 1194.38, ["Ride"] = 1040.58, ["Fly|Ride"] = 997.5, ["Neon"] = 4305.56, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2887.49, ["Mega"] = 9901.58, ["Mega|Fly|Ride"] = 7875}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 14.28, ["Ride"] = 68.23, ["Fly|Ride"] = 196.77, ["Neon"] = 149.78, ["Neon|Fly"] = 717.07, ["Neon|Ride"] = 215.34, ["Mega"] = 466.74, ["Mega|Ride"] = 433.13, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 52.46, ["Ride"] = 27.65, ["Fly|Ride"] = 86.17, ["Neon"] = 10.67, ["Neon|Fly"] = 72.16, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 94.77, ["Mega"] = 67.69, ["Mega|Ride"] = 102.57, ["Mega|Fly|Ride"] = 326.82}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 9.19, ["Ride"] = 131.25, ["Fly|Ride"] = 144.29, ["Neon"] = 74.82, ["Neon|Ride"] = 129.21, ["Neon|Fly|Ride"] = 393.73, ["Mega"] = 288.74, ["Mega|Ride"] = 430.67, ["Mega|Fly|Ride"] = 489.51}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Fly|Ride"] = 187.31, ["Neon"] = 2.1, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 17.07, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 53.8, ["Fly"] = 144.29, ["Ride"] = 90.96, ["Fly|Ride"] = 275.93, ["Neon"] = 223.13, ["Neon|Fly"] = 354.38, ["Neon|Ride"] = 263.7, ["Neon|Fly|Ride"] = 303.51, ["Mega"] = 993.24, ["Mega|Ride"] = 826.87, ["Mega|Fly|Ride"] = 907.49}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 21.74, ["Ride"] = 106.32, ["Fly|Ride"] = 287.48, ["Neon"] = 169.32, ["Neon|Ride"] = 309.02, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 577.49, ["Mega|Ride"] = 1005.6, ["Mega|Fly|Ride"] = 1148.8}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 9.7, ["Neon|Ride"] = 49.27, ["Neon|Fly|Ride"] = 215.34, ["Mega"] = 83.25, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 17.64, ["Fly"] = 159.37, ["Ride"] = 35.43, ["Fly|Ride"] = 107.86, ["Neon"] = 90.3, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 115.22, ["Neon|Fly|Ride"] = 574.95, ["Mega"] = 393.75, ["Mega|Ride"] = 551.25, ["Mega|Fly|Ride"] = 859.39}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 8.64, ["Ride"] = 34.13, ["Fly|Ride"] = 72.19, ["Neon"] = 27.12, ["Neon|Fly"] = 130.96, ["Neon|Ride"] = 58.16, ["Neon|Fly|Ride"] = 156.68, ["Mega"] = 262.4, ["Mega|Ride"] = 538.35, ["Mega|Fly|Ride"] = 400.53}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 41.62, ["Ride"] = 119.53, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 669.38, ["Mega"] = 2512.92, ["Mega|Ride"] = 1830.31, ["Mega|Fly|Ride"] = 1958.19}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 4.15, ["Fly|Ride"] = 540.48, ["Neon"] = 17.7, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 653.52, ["Mega"] = 86.41, ["Mega|Ride"] = 115.05, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 3.94, ["Fly"] = 36.62, ["Ride"] = 22.3, ["Fly|Ride"] = 58.15, ["Neon"] = 84.11, ["Neon|Fly"] = 187.36, ["Neon|Ride"] = 70.87, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 337.32, ["Mega|Ride"] = 287.44, ["Mega|Fly|Ride"] = 354.27}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 133.88, ["Fly"] = 208.07, ["Ride"] = 174.83, ["Fly|Ride"] = 198.8, ["Neon"] = 499.96, ["Neon|Ride"] = 632, ["Neon|Fly|Ride"] = 602.44, ["Mega"] = 2937.27, ["Mega|Ride"] = 2728.23, ["Mega|Fly|Ride"] = 2003.64}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 29.07, ["Ride"] = 19.27, ["Fly|Ride"] = 41.16, ["Neon"] = 28.12, ["Neon|Fly"] = 57.66, ["Neon|Ride"] = 24.68, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 111.56, ["Mega|Ride"] = 161.52, ["Mega|Fly|Ride"] = 185.22}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 46.34, ["Fly"] = 267.04, ["Ride"] = 77.35, ["Fly|Ride"] = 129.94, ["Neon"] = 151.07, ["Neon|Ride"] = 227.07, ["Neon|Fly|Ride"] = 340.7, ["Mega"] = 872.31, ["Mega|Ride"] = 892.5, ["Mega|Fly|Ride"] = 698.25}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.89, ["Ride"] = 13.13, ["Fly|Ride"] = 64.3, ["Neon"] = 2.1, ["Neon|Fly"] = 30.9, ["Neon|Ride"] = 17, ["Neon|Fly|Ride"] = 47.22, ["Mega"] = 16.23, ["Mega|Ride"] = 27.42, ["Mega|Fly|Ride"] = 76.13}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 5.15, ["Neon|Fly|Ride"] = 133.5, ["Mega"] = 19.85, ["Mega|Fly"] = 131.24, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 159.42}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 36.62, ["Ride"] = 31.23, ["Fly|Ride"] = 173.37, ["Neon"] = 47.25, ["Neon|Ride"] = 58.15, ["Neon|Fly|Ride"] = 142.79, ["Mega"] = 105, ["Mega|Ride"] = 286.4, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 41.91, ["Neon"] = 212.99, ["Neon|Ride"] = 326.82, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 531.04, ["Mega|Ride"] = 718.13}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 19.17, ["Ride"] = 16.7, ["Fly|Ride"] = 34.55, ["Neon"] = 13.71, ["Neon|Fly"] = 28.77, ["Neon|Ride"] = 25.59, ["Neon|Fly|Ride"] = 66.39, ["Mega"] = 104.99, ["Mega|Fly"] = 267.23, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 165.08}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 10.37, ["Fly"] = 76.46, ["Ride"] = 57.17, ["Fly|Ride"] = 120.65, ["Neon"] = 65.86, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 57.53, ["Neon|Fly|Ride"] = 164, ["Mega"] = 419.37, ["Mega|Fly"] = 440.61, ["Mega|Ride"] = 299.24, ["Mega|Fly|Ride"] = 403.37}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 26.17, ["Ride"] = 18.26, ["Fly|Ride"] = 71.45, ["Neon"] = 8.99, ["Neon|Fly"] = 98.42, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 61.74, ["Mega"] = 56.01, ["Mega|Fly"] = 106.98, ["Mega|Ride"] = 63.67, ["Mega|Fly|Ride"] = 144.24}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 11.6, ["Fly"] = 162.59, ["Ride"] = 24.94, ["Fly|Ride"] = 217.3, ["Neon"] = 44.63, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 861.33, ["Mega"] = 416.69, ["Mega|Ride"] = 425.29, ["Mega|Fly|Ride"] = 473.71}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 6.48, ["Ride"] = 190, ["Fly|Ride"] = 209.99, ["Neon"] = 63.93, ["Neon|Ride"] = 262.4, ["Mega"] = 305.82, ["Mega|Ride"] = 317.63, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 55.68, ["Ride"] = 18.19, ["Fly|Ride"] = 58.26, ["Neon"] = 72.07, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 41.9, ["Neon|Fly|Ride"] = 122.8, ["Mega"] = 253.03, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 237.79}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 25.94, ["Ride"] = 19.06, ["Fly|Ride"] = 39.38, ["Neon"] = 18.2, ["Neon|Fly"] = 63.54, ["Neon|Ride"] = 27.82, ["Neon|Fly|Ride"] = 63.67, ["Mega"] = 135.68, ["Mega|Ride"] = 118.12, ["Mega|Fly|Ride"] = 282.11}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 220.47, ["Fly"] = 393.75, ["Ride"] = 249.38, ["Fly|Ride"] = 366.09, ["Neon"] = 1290.92, ["Neon|Ride"] = 1420.85, ["Neon|Fly|Ride"] = 1174.69, ["Mega"] = 4243.62, ["Mega|Fly|Ride"] = 3732.74}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 6.28, ["Ride"] = 114.17, ["Neon"] = 43.66, ["Mega"] = 123.38, ["Mega|Ride"] = 408.78}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.1, ["Fly"] = 107.68, ["Ride"] = 23.02, ["Fly|Ride"] = 58.15, ["Neon"] = 32.72, ["Neon|Fly"] = 244.42, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 146.87, ["Mega"] = 252.94, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 200.82}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 7.61, ["Fly|Ride"] = 717.88, ["Neon"] = 38.07, ["Neon|Ride"] = 287.48, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 488.35, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 430.67}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 16.14, ["Ride"] = 14.34, ["Fly|Ride"] = 32.43, ["Neon"] = 2.1, ["Neon|Fly"] = 29.09, ["Neon|Ride"] = 18.2, ["Neon|Fly|Ride"] = 38.07, ["Mega"] = 17.37, ["Mega|Fly"] = 52.5, ["Mega|Ride"] = 36.63, ["Mega|Fly|Ride"] = 78.74}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 3.88, ["Fly"] = 58.37, ["Ride"] = 22.88, ["Fly|Ride"] = 90.57, ["Neon"] = 23.25, ["Neon|Fly"] = 86.17, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 131.25, ["Mega|Ride"] = 159.83, ["Mega|Fly|Ride"] = 259.82}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.1, ["Ride"] = 123.54, ["Neon"] = 11.82, ["Neon|Ride"] = 287.48, ["Neon|Fly|Ride"] = 485.63, ["Mega"] = 71.47, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 359.62}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 75.31, ["Fly"] = 105, ["Ride"] = 99.75, ["Fly|Ride"] = 176.58, ["Neon|Ride"] = 360.69, ["Neon|Fly|Ride"] = 387.19, ["Mega"] = 2870.74, ["Mega|Ride"] = 3589.77, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 4.39, ["Fly"] = 101.22, ["Ride"] = 23.62, ["Fly|Ride"] = 141.74, ["Neon"] = 26.25, ["Neon|Ride"] = 69.57, ["Mega"] = 169.32, ["Mega|Ride"] = 381.84, ["Mega|Fly|Ride"] = 717.96}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Ride"] = 43.07, ["Neon"] = 5.2, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 549.52, ["Mega"] = 65.6, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 128.14, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 47.06, ["Fly"] = 162.1, ["Ride"] = 97.55, ["Fly|Ride"] = 192.74, ["Neon"] = 137.81, ["Neon|Ride"] = 167.15, ["Neon|Fly|Ride"] = 272.87, ["Mega"] = 521.07, ["Mega|Ride"] = 636.57, ["Mega|Fly|Ride"] = 576.19}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 23.7, ["Ride"] = 14.33, ["Fly|Ride"] = 36.62, ["Neon"] = 2.2, ["Neon|Fly"] = 23.45, ["Neon|Ride"] = 16.7, ["Neon|Fly|Ride"] = 58.13, ["Mega"] = 17.35, ["Mega|Fly"] = 50.6, ["Mega|Ride"] = 43.09, ["Mega|Fly|Ride"] = 91.5}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Fly|Ride"] = 101.22, ["Neon"] = 3.48, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 32.66, ["Neon|Fly|Ride"] = 101.39, ["Mega"] = 24.49, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 162.65}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.59, ["Ride"] = 104.99, ["Neon"] = 8.61, ["Neon|Ride"] = 58.15, ["Neon|Fly|Ride"] = 287.48, ["Mega"] = 97.91, ["Mega|Fly"] = 187.36, ["Mega|Ride"] = 111.57, ["Mega|Fly|Ride"] = 216.87}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 4.06, ["Ride"] = 86.17, ["Fly|Ride"] = 111.57, ["Neon"] = 20.41, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 75.77, ["Neon|Fly|Ride"] = 154.42, ["Mega"] = 144.09, ["Mega|Fly"] = 199.63, ["Mega|Ride"] = 159.12, ["Mega|Fly|Ride"] = 258.54}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 20.01, ["Ride"] = 13.13, ["Fly|Ride"] = 45.23, ["Neon"] = 2.1, ["Neon|Fly"] = 21.55, ["Neon|Ride"] = 22.84, ["Neon|Fly|Ride"] = 58.15, ["Mega"] = 18.38, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 20.9, ["Fly"] = 127.07, ["Ride"] = 69.71, ["Neon"] = 188.82, ["Neon|Ride"] = 193.81, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 582.54, ["Mega|Fly|Ride"] = 818.26}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2467.49, ["Fly"] = 3150, ["Ride"] = 2417.63, ["Fly|Ride"] = 2284.38, ["Neon|Fly|Ride"] = 7415.63, ["Mega|Fly|Ride"] = 44664.67}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 31.45, ["Ride"] = 16.95, ["Fly|Ride"] = 51.69, ["Neon"] = 7.86, ["Neon|Fly"] = 49.87, ["Neon|Ride"] = 26.8, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 58.05, ["Mega|Fly"] = 288.17, ["Mega|Ride"] = 93.19, ["Mega|Fly|Ride"] = 155.91}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Neon"] = 10.5, ["Mega"] = 132.46, ["Mega|Fly"] = 441, ["Mega|Ride"] = 124.58, ["Mega|Fly|Ride"] = 506.76}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 13.99, ["Fly"] = 105, ["Ride"] = 32.82, ["Fly|Ride"] = 157.49, ["Neon"] = 83.34, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 291.38, ["Mega"] = 431.81, ["Mega|Ride"] = 555.64, ["Mega|Fly|Ride"] = 762.9}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 27.15, ["Fly"] = 144.29, ["Ride"] = 70.6, ["Neon"] = 144.15, ["Neon|Ride"] = 236.25, ["Mega"] = 752.51, ["Mega|Ride"] = 688, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 142.95, ["Fly"] = 1435.92, ["Ride"] = 190.32, ["Fly|Ride"] = 274.53, ["Neon"] = 647.07, ["Neon|Ride"] = 767.38, ["Neon|Fly|Ride"] = 616.88, ["Mega"] = 6458.33, ["Mega|Fly|Ride"] = 3042.61}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 4.33, ["Ride"] = 31.5, ["Fly|Ride"] = 675.94, ["Neon"] = 26.23, ["Neon|Ride"] = 72.16, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 144.29, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 237.57}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 41.64, ["Neon"] = 42, ["Neon|Ride"] = 115.65, ["Mega"] = 179.81, ["Mega|Fly|Ride"] = 267.09}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 101.22, ["Ride"] = 29.12, ["Fly|Ride"] = 86.17, ["Neon"] = 8.12, ["Neon|Fly"] = 127.07, ["Neon|Ride"] = 44.54, ["Neon|Fly|Ride"] = 144.29, ["Mega"] = 80.97, ["Mega|Ride"] = 144.29, ["Mega|Fly|Ride"] = 267.73}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 17.27, ["Ride"] = 48.98, ["Fly|Ride"] = 131.25, ["Neon"] = 144.93, ["Neon|Ride"] = 1227.44, ["Neon|Fly|Ride"] = 364.88, ["Mega"] = 574.95, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 429.85}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 43.09, ["Mega"] = 20.86, ["Mega|Ride"] = 574.95, ["Mega|Fly|Ride"] = 129.21}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 104.9, ["Fly"] = 253.03, ["Ride"] = 100.17, ["Fly|Ride"] = 170.63, ["Neon"] = 328.13, ["Neon|Fly"] = 460.82, ["Neon|Ride"] = 411.5, ["Neon|Fly|Ride"] = 502.81, ["Mega"] = 3229.17, ["Mega|Fly|Ride"] = 1893.54}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Fly"] = 41.64, ["Ride"] = 36.62, ["Neon"] = 16.26, ["Neon|Ride"] = 159.37, ["Neon|Fly|Ride"] = 102.92, ["Mega"] = 70.88, ["Mega|Ride"] = 287.48, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 43.22, ["Fly"] = 228.9, ["Ride"] = 106.61, ["Fly|Ride"] = 152.25, ["Neon"] = 229.17, ["Neon|Ride"] = 376.85, ["Neon|Fly|Ride"] = 509.25, ["Mega"] = 2625, ["Mega|Ride"] = 1436.26, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 63.52, ["Ride"] = 18.47, ["Fly|Ride"] = 44.57, ["Neon"] = 6.54, ["Neon|Fly"] = 85.7, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 83.97, ["Mega"] = 85.07, ["Mega|Fly"] = 489.51, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 326.78}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Ride"] = 21.11, ["Neon"] = 3.94, ["Neon|Ride"] = 87.94, ["Mega"] = 38.06, ["Mega|Ride"] = 139.05, ["Mega|Fly|Ride"] = 402.68}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 4.04, ["Fly"] = 72.13, ["Ride"] = 24.53, ["Fly|Ride"] = 90.57, ["Neon"] = 25.46, ["Neon|Fly"] = 107.68, ["Neon|Ride"] = 72.48, ["Mega"] = 141.75, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 574.95}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 362.25, ["Fly"] = 734.32, ["Ride"] = 401.21, ["Fly|Ride"] = 492.47, ["Neon"] = 880.95, ["Neon|Ride"] = 924, ["Neon|Fly|Ride"] = 1065.75, ["Mega"] = 3316.48, ["Mega|Ride"] = 2632.65, ["Mega|Fly|Ride"] = 3543.75}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 41.62, ["Fly"] = 65.63, ["Ride"] = 57.75, ["Fly|Ride"] = 91.85, ["Neon"] = 236.25, ["Neon|Ride"] = 175.41, ["Neon|Fly|Ride"] = 229.67, ["Mega"] = 1005.6, ["Mega|Fly"] = 2758.53, ["Mega|Ride"] = 922.81, ["Mega|Fly|Ride"] = 1061.59}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 36.62, ["Fly|Ride"] = 111.57, ["Neon"] = 28.58, ["Neon|Fly"] = 101.07, ["Neon|Ride"] = 57.58, ["Neon|Fly|Ride"] = 131.06, ["Mega"] = 169.32, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 288.51}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 24.44, ["Fly"] = 230.42, ["Ride"] = 70.58, ["Fly|Ride"] = 144.38, ["Neon"] = 86.51, ["Neon|Fly"] = 419.21, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 259.87, ["Mega"] = 298.86, ["Mega|Fly"] = 1007.36, ["Mega|Ride"] = 329.25, ["Mega|Fly|Ride"] = 484.32}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 7.08, ["Ride"] = 20.78, ["Neon"] = 164.04, ["Neon|Ride"] = 122.42, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 653.57, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 311.18}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 2.1, ["Neon"] = 14.42, ["Neon|Ride"] = 157.49, ["Mega"] = 43.08, ["Mega|Ride"] = 236.24, ["Mega|Fly|Ride"] = 330.56}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 72.16, ["Ride"] = 19.56, ["Fly|Ride"] = 62.99, ["Neon"] = 64.61, ["Neon|Ride"] = 144.29, ["Neon|Fly|Ride"] = 212.98, ["Mega"] = 571.51, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 108.74, ["Fly"] = 244.83, ["Ride"] = 128.63, ["Fly|Ride"] = 194.88, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 524.99, ["Mega"] = 2583.96, ["Mega|Ride"] = 2625, ["Mega|Fly|Ride"] = 2178.75}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 19.94, ["Ride"] = 32.82, ["Fly|Ride"] = 85.32, ["Neon"] = 129.04, ["Neon|Ride"] = 189, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 551.25, ["Mega|Ride"] = 633.29}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2034.37, ["Fly"] = 2448.01, ["Ride"] = 1911, ["Fly|Ride"] = 1962.19, ["Neon"] = 11484.58, ["Neon|Ride"] = 7832.08, ["Neon|Fly|Ride"] = 6562.5, ["Mega|Fly|Ride"] = 25200}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 4.92, ["Fly"] = 131250, ["Ride"] = 47.39, ["Fly|Ride"] = 196.87, ["Neon"] = 32.81, ["Neon|Ride"] = 98.44, ["Mega"] = 222.97, ["Mega|Ride"] = 191.63, ["Mega|Fly|Ride"] = 493.77}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 4.87, ["Ride"] = 63, ["Fly|Ride"] = 111.06, ["Neon"] = 26.24, ["Neon|Ride"] = 40.69, ["Mega"] = 139.13, ["Mega|Ride"] = 215.34, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 853.13, ["Fly"] = 1110, ["Ride"] = 900.38, ["Fly|Ride"] = 918.75, ["Neon"] = 2778.57, ["Neon|Ride"] = 2572.76, ["Neon|Fly|Ride"] = 2887.5, ["Mega|Ride"] = 13872.83, ["Mega|Fly|Ride"] = 11052.85}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 34.13, ["Ride"] = 57.53, ["Fly|Ride"] = 105, ["Neon"] = 238.88, ["Neon|Ride"] = 321.93, ["Mega"] = 718.1, ["Mega|Ride"] = 833.34, ["Mega|Fly|Ride"] = 854.44}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.1, ["Ride"] = 22.3, ["Fly|Ride"] = 128.15, ["Neon"] = 15.41, ["Neon|Fly"] = 164.04, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 164.03, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Ride"] = 144.29, ["Neon"] = 2.6, ["Neon|Ride"] = 51.36, ["Neon|Fly|Ride"] = 111.98, ["Mega"] = 30.13, ["Mega|Ride"] = 60.32, ["Mega|Fly|Ride"] = 127.07}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 98.43, ["Fly"] = 430.67, ["Ride"] = 144.37, ["Fly|Ride"] = 215.34, ["Neon"] = 459.38, ["Neon|Ride"] = 605.9, ["Neon|Fly|Ride"] = 646.98, ["Mega"] = 2447.55, ["Mega|Fly|Ride"] = 2432.36}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Fly|Ride"] = 75.39, ["Neon"] = 12.46, ["Neon|Ride"] = 64.32, ["Mega"] = 87.93, ["Mega|Ride"] = 129.68, ["Mega|Fly|Ride"] = 259.44}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 72.18, ["Ride"] = 106.32, ["Neon"] = 611.94, ["Neon|Ride"] = 588.74, ["Neon|Fly|Ride"] = 516.8, ["Mega"] = 2153.31, ["Mega|Fly|Ride"] = 1648.36}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 5.15, ["Fly"] = 105, ["Fly|Ride"] = 129.21, ["Neon"] = 29.09, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 269.06, ["Mega"] = 360.77, ["Mega|Ride"] = 317.63, ["Mega|Fly|Ride"] = 400.53}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 282.19, ["Fly"] = 416.69, ["Ride"] = 295.83, ["Fly|Ride"] = 359.83, ["Neon"] = 1148.82, ["Neon|Ride"] = 7321.21, ["Neon|Fly|Ride"] = 870.58, ["Mega|Fly|Ride"] = 3870.12}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.86, ["Fly"] = 33.39, ["Ride"] = 19.48, ["Fly|Ride"] = 64.04, ["Neon"] = 51.69, ["Neon|Ride"] = 54.05, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 178.5, ["Mega|Ride"] = 591.29, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 13.13, ["Fly|Ride"] = 48.86, ["Neon"] = 5.04, ["Neon|Fly"] = 36.62, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 48.56, ["Mega|Ride"] = 59.06, ["Mega|Fly|Ride"] = 125.42}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1436.26, ["Ride"] = 1050, ["Fly|Ride"] = 1157.63, ["Neon|Ride"] = 7893.29, ["Neon|Fly|Ride"] = 7536.53, ["Mega"] = 24480, ["Mega|Fly|Ride"] = 26988.26}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 18.37, ["Ride"] = 94.49, ["Neon"] = 215.25, ["Neon|Ride"] = 314.98, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 408.76, ["Mega|Ride"] = 498.6, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 6.11, ["Fly"] = 54.89, ["Ride"] = 34.53, ["Fly|Ride"] = 101.56, ["Neon"] = 21.46, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 118.08, ["Mega"] = 180.46, ["Mega|Ride"] = 258.09, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 46.19, ["Fly"] = 39.05, ["Ride"] = 37.2, ["Fly|Ride"] = 74.81, ["Neon|Ride"] = 185.26, ["Neon|Fly|Ride"] = 191.01, ["Mega"] = 2583.35, ["Mega|Ride"] = 861.33, ["Mega|Fly|Ride"] = 800.42}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 13.53, ["Fly"] = 62.91, ["Ride"] = 31.4, ["Fly|Ride"] = 72.19, ["Neon"] = 65.63, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 189.5, ["Mega"] = 367.5, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 574.95}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 115.5, ["Fly|Ride"] = 643.85, ["Neon"] = 446.82, ["Neon|Fly"] = 574.95, ["Neon|Ride"] = 537.71, ["Neon|Fly|Ride"] = 818.26, ["Mega"] = 3875.94, ["Mega|Fly|Ride"] = 1143.1}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Neon"] = 2.1, ["Neon|Fly"] = 56.98, ["Neon|Ride"] = 115.06, ["Neon|Fly|Ride"] = 101.22, ["Mega"] = 17.47, ["Mega|Fly"] = 54.93, ["Mega|Ride"] = 144.47, ["Mega|Fly|Ride"] = 217.81}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 147.5, ["Fly"] = 242.26, ["Ride"] = 170.52, ["Fly|Ride"] = 257.04, ["Neon"] = 845.9, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 3445.28, ["Mega|Fly|Ride"] = 2139.38}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.63, ["Fly"] = 748.35, ["Ride"] = 19.28, ["Fly|Ride"] = 70.14, ["Neon"] = 229.67, ["Neon|Ride"] = 83.99, ["Mega"] = 773.71, ["Mega|Ride"] = 440.35, ["Mega|Fly|Ride"] = 490.88}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 18.38, ["Fly|Ride"] = 39.35, ["Neon"] = 13.13, ["Neon|Fly"] = 82.02, ["Neon|Ride"] = 86.17, ["Neon|Fly|Ride"] = 70.69, ["Mega|Ride"] = 280.24}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 6.13, ["Ride"] = 124.74, ["Neon"] = 15.65, ["Neon|Fly"] = 142.14, ["Neon|Fly|Ride"] = 214.22}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 123.16, ["Ride"] = 222.2, ["Fly|Ride"] = 646, ["Neon"] = 653.4, ["Neon|Ride"] = 668.26, ["Neon|Fly|Ride"] = 707.51, ["Mega"] = 1968.75, ["Mega|Ride"] = 1847.58, ["Mega|Fly|Ride"] = 1786.99}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 4.96, ["Ride"] = 85.32, ["Fly|Ride"] = 718.13, ["Neon"] = 20.9, ["Neon|Ride"] = 59.07, ["Mega"] = 125.09, ["Mega|Ride"] = 157.2, ["Mega|Fly|Ride"] = 326.8}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 24.78, ["Mega"] = 16.72, ["Mega|Ride"] = 215.34, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.94, ["Ride"] = 26.21, ["Fly|Ride"] = 144.29, ["Neon"] = 2.1, ["Neon|Fly"] = 86.2, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 18.23, ["Mega|Fly"] = 58.15, ["Mega|Ride"] = 47.16, ["Mega|Fly|Ride"] = 120.75}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 36.74, ["Ride"] = 21.54, ["Fly|Ride"] = 52.49, ["Neon"] = 10.77, ["Neon|Ride"] = 24.49, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 63, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 156.19}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.5, ["Fly"] = 29.09, ["Ride"] = 19.68, ["Fly|Ride"] = 91.87, ["Neon"] = 10.39, ["Mega"] = 137.82, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 22.32, ["Ride"] = 15.65, ["Fly|Ride"] = 42.8, ["Neon"] = 19.39, ["Neon|Fly"] = 86.13, ["Neon|Ride"] = 40.95, ["Neon|Fly|Ride"] = 77.67, ["Mega"] = 324.19, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 228.26}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 61.69, ["Fly|Ride"] = 287.48, ["Neon"] = 229.66, ["Neon|Ride"] = 323.01, ["Neon|Fly|Ride"] = 618.01, ["Mega"] = 786.19, ["Mega|Ride"] = 772.35, ["Mega|Fly|Ride"] = 885.94}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 17.07, ["Fly|Ride"] = 49.52, ["Neon"] = 2.59, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 17.99, ["Neon|Fly|Ride"] = 47.24, ["Mega"] = 17.07, ["Mega|Fly"] = 43.09, ["Mega|Ride"] = 37.68, ["Mega|Fly|Ride"] = 96.93}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 7.88, ["Fly"] = 58.59, ["Ride"] = 52.5, ["Fly|Ride"] = 72.51, ["Neon"] = 39.35, ["Neon|Fly"] = 57.28, ["Neon|Ride"] = 66.09, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 242.82, ["Mega|Fly"] = 574.73, ["Mega|Ride"] = 278.17, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 27.56, ["Fly"] = 66.51, ["Ride"] = 51.43, ["Fly|Ride"] = 126.06, ["Neon"] = 195.81, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 164.01, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 1291.99, ["Mega|Fly|Ride"] = 735}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 9.18, ["Fly"] = 209.98, ["Ride"] = 62.46, ["Neon"] = 103.95, ["Mega"] = 511.39, ["Mega|Ride"] = 1039.5, ["Mega|Fly|Ride"] = 854.88}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 18.63, ["Ride"] = 16.09, ["Fly|Ride"] = 36.75, ["Neon"] = 4.93, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 21.82, ["Neon|Fly|Ride"] = 76.46, ["Mega"] = 40.95, ["Mega|Ride"] = 58.65, ["Mega|Fly|Ride"] = 121.8}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 12.39, ["Ride"] = 93.36, ["Neon"] = 91.87, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 387.6, ["Mega"] = 552.25, ["Mega|Fly"] = 571.71, ["Mega|Ride"] = 571.71, ["Mega|Fly|Ride"] = 790.27}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 945, ["Ride"] = 1036.87, ["Fly|Ride"] = 1049.96, ["Neon"] = 2491.13, ["Neon|Ride"] = 2744.44, ["Neon|Fly|Ride"] = 2453.07, ["Mega|Fly|Ride"] = 6168.75}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 230.96, ["Ride"] = 313.69, ["Fly|Ride"] = 590.63, ["Neon"] = 840, ["Neon|Ride"] = 960.4, ["Neon|Fly|Ride"] = 1305.76, ["Mega"] = 3590.13, ["Mega|Ride"] = 3732.74, ["Mega|Fly|Ride"] = 3431.28}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Neon"] = 13.13, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 258.41, ["Mega"] = 61.76, ["Mega|Fly|Ride"] = 1148.8}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 169.28, ["Ride"] = 245.6, ["Fly|Ride"] = 437.07, ["Neon"] = 639.19, ["Neon|Ride"] = 695.63, ["Neon|Fly|Ride"] = 984.38, ["Mega"] = 2465.94, ["Mega|Ride"] = 2383.58, ["Mega|Fly|Ride"] = 2182.95}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.1, ["Ride"] = 24.02, ["Fly|Ride"] = 93.69, ["Neon"] = 17.06, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 38.88, ["Neon|Fly|Ride"] = 144.29, ["Mega"] = 115.96, ["Mega|Ride"] = 489.56, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 261.19, ["Fly"] = 430.67, ["Ride"] = 273.51, ["Fly|Ride"] = 334.43, ["Neon|Ride"] = 1579.46, ["Neon|Fly|Ride"] = 1536.39, ["Mega|Fly|Ride"] = 4106.6}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 77.97, ["Ride"] = 23.63, ["Fly|Ride"] = 118.13, ["Neon"] = 67.32, ["Neon|Ride"] = 58.08, ["Mega"] = 393.75, ["Mega|Fly"] = 360.69}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.51, ["Ride"] = 26.25, ["Mega"] = 249.38, ["Mega|Ride"] = 243.33}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 21.6, ["Fly"] = 52.5, ["Ride"] = 58.13, ["Fly|Ride"] = 144.24, ["Neon"] = 131.25, ["Neon|Fly"] = 430.67, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 525, ["Mega"] = 847.75, ["Mega|Ride"] = 593.92, ["Mega|Fly|Ride"] = 796.83}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.76, ["Neon"] = 133.52, ["Neon|Ride"] = 196.88, ["Mega"] = 244.75, ["Mega|Ride"] = 241.87, ["Mega|Fly|Ride"] = 393.65}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 16.69, ["Ride"] = 13.55, ["Fly|Ride"] = 39.38, ["Neon"] = 3.67, ["Neon|Fly"] = 21.41, ["Neon|Ride"] = 19.28, ["Neon|Fly|Ride"] = 40.69, ["Mega"] = 31.5, ["Mega|Fly"] = 55.13, ["Mega|Ride"] = 36.79, ["Mega|Fly|Ride"] = 107.63}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4200, ["Ride"] = 4592.44, ["Fly|Ride"] = 4723.69, ["Neon"] = 32291.59, ["Neon|Fly|Ride"] = 21511.38, ["Mega|Fly|Ride"] = 52500}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 23.7, ["Ride"] = 42.37, ["Neon"] = 86.17, ["Neon|Fly"] = 383.21, ["Neon|Ride"] = 101.64, ["Neon|Fly|Ride"] = 164.01, ["Mega"] = 210, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 429.6}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 28.3, ["Ride"] = 18.38, ["Fly|Ride"] = 50.61, ["Neon"] = 15.08, ["Neon|Fly"] = 45.93, ["Neon|Ride"] = 32.45, ["Neon|Fly|Ride"] = 81.32, ["Mega"] = 144.38, ["Mega|Ride"] = 130.96, ["Mega|Fly|Ride"] = 220.89}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 423.94, ["Fly"] = 547.78, ["Ride"] = 499, ["Fly|Ride"] = 537.67, ["Neon"] = 1550.66, ["Neon|Ride"] = 1292.81, ["Neon|Fly|Ride"] = 1246.86, ["Mega|Fly|Ride"] = 5114.82}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 2.1, ["Ride"] = 48.97, ["Neon"] = 52.5, ["Neon|Ride"] = 291.38, ["Mega"] = 164.01, ["Mega|Ride"] = 171.21, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 2.1, ["Fly"] = 29.09, ["Ride"] = 19.69, ["Neon"] = 66.09, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 875.61, ["Mega|Ride"] = 401.62, ["Mega|Fly|Ride"] = 582.75}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 72.16, ["Ride"] = 20.78, ["Fly|Ride"] = 65.63, ["Neon"] = 7.76, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 25.47, ["Neon|Fly|Ride"] = 91.75, ["Mega"] = 44.56, ["Mega|Ride"] = 70.86, ["Mega|Fly|Ride"] = 287.48}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 603.75, ["Fly"] = 876.4, ["Ride"] = 656.24, ["Fly|Ride"] = 711.38, ["Neon|Ride"] = 2126.25, ["Neon|Fly|Ride"] = 2099.99, ["Mega|Fly|Ride"] = 8182.51}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 12.6, ["Ride"] = 86.17, ["Fly|Ride"] = 210, ["Neon"] = 51.59, ["Neon|Fly"] = 328.12, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 269.06, ["Mega|Fly"] = 431.29, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 419.88}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 3.94, ["Fly"] = 42.24, ["Ride"] = 49.88, ["Neon"] = 24.25, ["Neon|Ride"] = 66.1, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 150.94, ["Mega|Fly"] = 816.32, ["Mega|Ride"] = 194.54, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.52, ["Fly"] = 39.26, ["Ride"] = 21, ["Fly|Ride"] = 64.61, ["Neon"] = 18.36, ["Neon|Fly"] = 58.15, ["Neon|Ride"] = 24.5, ["Neon|Fly|Ride"] = 86.41, ["Mega"] = 164.04, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 20.9, ["Fly"] = 39.38, ["Ride"] = 39.81, ["Fly|Ride"] = 65.63, ["Neon"] = 111.39, ["Neon|Ride"] = 114.18, ["Mega"] = 605.82, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 1680}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Fly"] = 58.15, ["Ride"] = 43.31, ["Fly|Ride"] = 287.48, ["Neon"] = 5.24, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 29.07, ["Mega|Ride"] = 101.35, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 590.63, ["Ride"] = 630, ["Fly|Ride"] = 649.43, ["Neon"] = 2611.72, ["Neon|Ride"] = 2297.58, ["Neon|Fly|Ride"] = 2415.78, ["Mega|Ride"] = 9547.2, ["Mega|Fly|Ride"] = 7874.99}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 59.07, ["Fly|Ride"] = 259.86, ["Neon"] = 13.55, ["Neon|Ride"] = 104.98, ["Neon|Fly|Ride"] = 200.73, ["Mega"] = 76.13, ["Mega|Ride"] = 159.37, ["Mega|Fly|Ride"] = 216.2}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 51.87, ["Fly|Ride"] = 131.25, ["Neon"] = 7.85, ["Neon|Fly"] = 287.48, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 50.61, ["Mega|Fly|Ride"] = 430.67}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Neon"] = 2.52, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 7178, ["Mega"] = 29.98, ["Mega|Fly"] = 149.33, ["Mega|Ride"] = 116.29, ["Mega|Fly|Ride"] = 216.5}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.5, ["Ride"] = 26.25, ["Neon"] = 38.07, ["Mega"] = 246.47, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 23.15, ["Fly"] = 98.44, ["Ride"] = 63.84, ["Fly|Ride"] = 214.19, ["Neon"] = 155.93, ["Neon|Ride"] = 197.64, ["Neon|Fly|Ride"] = 393.74, ["Mega"] = 675.07, ["Mega|Ride"] = 565.23, ["Mega|Fly|Ride"] = 599.82}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 19.57, ["Ride"] = 52.49, ["Fly|Ride"] = 124.69, ["Neon"] = 87.44, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 294, ["Mega"] = 551.25, ["Mega|Ride"] = 779.63, ["Mega|Fly|Ride"] = 755.47}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 23.61, ["Ride"] = 17.38, ["Fly|Ride"] = 34.61, ["Neon"] = 51.24, ["Neon|Ride"] = 36.62, ["Neon|Fly|Ride"] = 107.68, ["Mega"] = 293.35, ["Mega|Ride"] = 273.67, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 11.81, ["Ride"] = 29.08, ["Fly|Ride"] = 146.88, ["Neon"] = 118.13}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 111.56, ["Neon"] = 15.65, ["Neon|Ride"] = 58.15, ["Neon|Fly|Ride"] = 127.34, ["Mega"] = 98.34, ["Mega|Fly"] = 122.4, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 254.58}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 20.99, ["Fly"] = 34.13, ["Ride"] = 31.18, ["Fly|Ride"] = 45.94, ["Neon"] = 116.93, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 167.35, ["Mega"] = 904.38, ["Mega|Fly|Ride"] = 719.25}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 35.35, ["Fly"] = 97.13, ["Neon"] = 164.01, ["Mega"] = 281.71, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 584.73}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 48.76, ["Fly"] = 115.06, ["Ride"] = 91.87, ["Fly|Ride"] = 259.88, ["Neon"] = 271.69, ["Neon|Ride"] = 367.18, ["Neon|Fly|Ride"] = 374.07, ["Mega|Fly|Ride"] = 1351.88}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 34.27, ["Fly"] = 144.29, ["Ride"] = 55.13, ["Fly|Ride"] = 228.38, ["Neon"] = 131.15, ["Neon|Ride"] = 192.85, ["Neon|Fly|Ride"] = 324.84, ["Mega"] = 502.86, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 19.57, ["Ride"] = 51.48, ["Neon"] = 321.93, ["Neon|Ride"] = 223.13, ["Mega"] = 502.69, ["Mega|Ride"] = 445.08, ["Mega|Fly|Ride"] = 837.64}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 53.26, ["Fly"] = 176.26, ["Ride"] = 98.44, ["Fly|Ride"] = 208.95, ["Neon"] = 236.15, ["Neon|Ride"] = 267.02, ["Neon|Fly|Ride"] = 714.91, ["Mega"] = 826.88, ["Mega|Ride"] = 852.71, ["Mega|Fly|Ride"] = 958.97}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 24.94, ["Ride"] = 15.73, ["Fly|Ride"] = 32.17, ["Neon"] = 5.09, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 58.15, ["Mega"] = 40.15, ["Mega|Fly"] = 215.34, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 146.99}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1312.5}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 152.25, ["Ride"] = 282.19, ["Fly|Ride"] = 378, ["Neon"] = 513.24, ["Neon|Ride"] = 544.69, ["Neon|Fly|Ride"] = 953.63, ["Mega"] = 1634.36, ["Mega|Ride"] = 1720.49, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 83.91, ["Neon"] = 2.6, ["Neon|Fly"] = 101.22, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 300.57, ["Mega"] = 72.16, ["Mega|Ride"] = 141, ["Mega|Fly|Ride"] = 139.07}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 30.76, ["Ride"] = 65.63, ["Neon"] = 111.46, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 591.93, ["Mega|Ride"] = 485.63, ["Mega|Fly|Ride"] = 618.01}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.71, ["Neon|Fly|Ride"] = 144.29, ["Mega"] = 18.38}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 6.57, ["Mega"] = 40.69, ["Mega|Ride"] = 144.29}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 102.38, ["Fly"] = 1795.86, ["Ride"] = 144.29, ["Fly|Ride"] = 300.41, ["Neon"] = 653.57, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 574.95, ["Mega|Ride"] = 6731.08, ["Mega|Fly|Ride"] = 2077.69}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 21.1, ["Fly|Ride"] = 63.54, ["Neon"] = 8.73, ["Neon|Fly"] = 43.09, ["Neon|Ride"] = 32.3, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 101.77, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 36.92, ["Ride"] = 27.57, ["Fly|Ride"] = 66.94, ["Neon"] = 6.19, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 419.9, ["Mega"] = 36.66, ["Mega|Ride"] = 129.15, ["Mega|Fly|Ride"] = 217.87}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.63, ["Neon"] = 52.76, ["Neon|Ride"] = 245.44}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.52, ["Ride"] = 131.25, ["Neon"] = 19.69, ["Neon|Ride"] = 137.82, ["Mega"] = 136.24, ["Mega|Ride"] = 330.56}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 104.98, ["Ride"] = 287.37, ["Fly|Ride"] = 359.62, ["Neon"] = 545.74, ["Neon|Ride"] = 603.75, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1874.25, ["Mega|Fly|Ride"] = 2572.5}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 14.57, ["Neon"] = 89.38, ["Mega"] = 422.29, ["Mega|Ride"] = 380.77, ["Mega|Fly|Ride"] = 645.74}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 367.5, ["Ride"] = 393.74, ["Fly|Ride"] = 714.91, ["Neon"] = 918.75, ["Neon|Ride"] = 1472.87, ["Neon|Fly|Ride"] = 1266.71, ["Mega|Fly|Ride"] = 3302.09}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 74.8}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 52.5}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 32.42}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 14.42}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 51.19}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 116.82}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 15.86}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 9.05}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 192.93}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 14.2}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 46.12}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 12.87}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 9.66}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 1010.62}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 7.77}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 8.73}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 7.88}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 7.07}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 44.44}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 569.63}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 511.39}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 7.46}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1704.94}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 63.45}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 7.21}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 17.07}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 29.09}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 22.89}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 65.47}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 26.63}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 14.84}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 19.68}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 4.67}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 63.95}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 7.46}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.1}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 15.45}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 11.82}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 7.87}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 4.72}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 3229.17}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 97.26}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 259.55}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 4.99}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 3.51}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 23.94}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 31.49}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 31.5}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 262.49}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 10.47}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 32.8}},
    ["rbxassetid://1265129435"] = {name = "Gold Snowboard", prices = {["default"] = 157.5}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 164.07}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 86}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 6.45}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.5}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 26.24}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 21}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 104.99}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 28.2}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 10.06}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.37}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 35.15}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 10.26}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 4.82}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 43.05}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 94.4}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 398.99}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 8.98}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 11.58}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 27.56}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 108.94}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 24.75}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 23100}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 124.69}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 39.38}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 49.88}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 30.17}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 59.07}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 31.4}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 32.81}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 91.53}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 85.21}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 36.49}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 110.79}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 39.38}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 43.22}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 47.27}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 262.5}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 9.02}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 8.99}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 5.16}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 7.29}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 27.54}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 367.5}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.51}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 5.04}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.63}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 4.87}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 21.84}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 228.38}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 1143.1}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 7.33}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 616.88}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 16.53}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.52}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.5}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 231}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 45.05}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 99.71}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 20.89}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 37.69}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 70.25}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 18.1}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 11.34}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 12}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.52}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 9.17}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 11.08}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 36.74}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 6.12}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.35}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 5.34}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 17.64}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 195.46}},
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
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 216.36}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 26.24}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 28.76}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 8.77}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 36.19}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 78.75}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 6.34}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 9.97}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 5.25}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 6.36}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 21.83}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 28.87}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 7.86}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 2.1}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 8.59}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 7.17}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 3.93}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 5.24}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.37}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 4.66}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 3.84}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 8268.75}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 12.84}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 6.35}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 5.92}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 5.22}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 6.47}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 33.05}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 5.11}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 5.31}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 5.1}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 3.92}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 14.43}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 45.85}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 6.24}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.52}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 6.13}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 6.32}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.89}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 3937.5}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 17.07}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 51.1}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.16}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 6.24}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 82.01}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.43}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 5.15}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 131.15}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 3.72}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.71}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 7.77}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 11.81}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 20.9}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.26}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.93}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 12.5}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 4.97}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 3.24}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.7}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.63}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.25}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.16}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 3.45}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 29.89}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 3.11}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 11.67}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 141.74}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.68}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 61.5}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 53.7}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 3.56}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1459.5}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 86.63}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 5.01}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 76.1}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 35.02}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.91}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 3.08}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 7.59}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 22.3}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 3.19}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 14.15}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 15.56}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 2.5}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 18.26}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 5.7}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 14.44}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 3.73}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 7.67}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 91.77}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 23.62}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 37.7}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 63.02}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 110.15}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 15.21}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 31.22}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 25.18}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 3.84}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 6.97}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 3.92}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 3.18}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 7.58}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 144.24}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.24}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 155.3}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 14.81}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1036.85}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 188.9}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 12.9}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 10.31}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 63}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 3.31}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 4.83}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 5.07}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 91.87}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 9.08}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 6.86}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 6.56}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 3.13}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 10.2}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.19}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 57.95}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 3.47}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 78.35}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 6.23}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 3.84}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 15.31}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 118.12}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 21.53}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.59}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 76.13}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 51.19}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 59.06}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 94.5}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 5.71}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 61.39}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 6.46}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 143.07}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 3.53}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.54}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 296.24}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 64.78}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 11.82}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 43.32}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 4.33}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 5.03}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 8.38}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 21.62}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 61.36}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2.92}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 15.75}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 53.68}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 4.04}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 6.56}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 28.24}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.64}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 150.94}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 89.24}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 48.42}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 26.16}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1942.49}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 19.66}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 10.02}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 26.25}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 263.67}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 23.6}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 10.49}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 35.43}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 15.74}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 23}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 352.48}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 57.75}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 48.57}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 3.7}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.24}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 65.63}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 228.02}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 91.76}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1143.45}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 203.11}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 9.08}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1722.65}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 576.19}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 3.19}},
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