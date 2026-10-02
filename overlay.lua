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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1296.96, ["Ride"] = 1179.94, ["Fly|Ride"] = 1732.16, ["Neon"] = 6891.55, ["Neon|Fly|Ride"] = 5053.06, ["Mega"] = 21654.34, ["Mega|Fly|Ride"] = 21649.18}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 498.75, ["Fly"] = 722.11, ["Ride"] = 504, ["Fly|Ride"] = 656.25, ["Neon|Ride"] = 2663.18, ["Neon|Fly|Ride"] = 2743.3, ["Mega"] = 10825.88, ["Mega|Fly|Ride"] = 8660.72}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 5053.13, ["Ride"] = 5250, ["Fly|Ride"] = 5248.68, ["Neon"] = 18375, ["Neon|Fly|Ride"] = 23783.48, ["Mega|Fly|Ride"] = 79390.5}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 203.44, ["Ride"] = 245.44, ["Fly|Ride"] = 404.91, ["Neon"] = 1148.96, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1089.38, ["Mega|Fly|Ride"] = 4920.56}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 485.63, ["Fly"] = 722.11, ["Ride"] = 485.63, ["Fly|Ride"] = 519.75, ["Neon"] = 1944.34, ["Neon|Fly|Ride"] = 1613.07, ["Mega|Fly|Ride"] = 5250}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 14.44, ["Ride"] = 58.97, ["Fly|Ride"] = 131.25, ["Neon"] = 102.86, ["Neon|Fly"] = 289.1, ["Neon|Ride"] = 103.59, ["Neon|Fly|Ride"] = 216.54, ["Mega"] = 360.94, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 605.18}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.66, ["Fly"] = 39.25, ["Ride"] = 26.25, ["Fly|Ride"] = 66.93, ["Neon"] = 28.88, ["Neon|Fly"] = 99.03, ["Neon|Ride"] = 49.25, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 157.5, ["Mega|Ride"] = 201.9, ["Mega|Fly|Ride"] = 267.52}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 104.98, ["Fly"] = 295.24, ["Ride"] = 118.13, ["Fly|Ride"] = 288.75, ["Neon"] = 437.72, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 1732.16, ["Mega"] = 1586.82, ["Mega|Fly|Ride"] = 1838.25}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 32.8, ["Fly"] = 91.88, ["Ride"] = 39.38, ["Fly|Ride"] = 99.75, ["Neon"] = 275.63, ["Neon|Fly"] = 242.82, ["Neon|Ride"] = 197.66, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 2100, ["Mega|Ride"] = 1220.09, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 27.92, ["Fly"] = 33.38, ["Ride"] = 36.75, ["Fly|Ride"] = 68.25, ["Neon"] = 262.5, ["Neon|Ride"] = 164.85, ["Neon|Fly|Ride"] = 199.68, ["Mega|Fly|Ride"] = 649.69}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 63, ["Fly"] = 216.54, ["Ride"] = 90.56, ["Fly|Ride"] = 180.72, ["Neon"] = 406.88, ["Neon|Ride"] = 283.5, ["Neon|Fly|Ride"] = 431.82, ["Mega"] = 1575, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1558.94}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 72.4}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 376.7, ["Fly"] = 432.99, ["Ride"] = 354.38, ["Fly|Ride"] = 380.63, ["Neon|Ride"] = 1008, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 3936.19}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 145.09, ["Fly"] = 153.05, ["Ride"] = 124.69, ["Fly|Ride"] = 180.03, ["Neon|Fly|Ride"] = 676.03, ["Mega"] = 4312.63, ["Mega|Fly|Ride"] = 2467.5}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.1, ["Fly"] = 83.15, ["Ride"] = 43.32, ["Neon"] = 23.13, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 244.83, ["Mega"] = 160.13, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 361.56, ["Mega|Fly|Ride"] = 505.59}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 223.13, ["Fly"] = 183.75, ["Ride"] = 216.57, ["Fly|Ride"] = 242.61, ["Neon|Ride"] = 853.13, ["Neon|Fly|Ride"] = 832.13, ["Mega|Fly|Ride"] = 2751}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.15, ["Fly"] = 23.63, ["Ride"] = 19.44, ["Fly|Ride"] = 39.38, ["Neon"] = 40.69, ["Neon|Fly"] = 129.93, ["Neon|Ride"] = 82.42, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 190.32, ["Mega|Ride"] = 274.96, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 172.06, ["Fly"] = 223.13, ["Ride"] = 210.21, ["Fly|Ride"] = 315, ["Neon"] = 546, ["Neon|Ride"] = 521.73, ["Neon|Fly|Ride"] = 602.44, ["Mega"] = 1967.44, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 46.75}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 85.32, ["Ride"] = 164.07, ["Fly|Ride"] = 279.25, ["Neon"] = 525, ["Neon|Fly|Ride"] = 523.69, ["Mega|Ride"] = 1840.43, ["Mega|Fly|Ride"] = 1942.18}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 37.88, ["Fly"] = 393.75, ["Ride"] = 86.17, ["Fly|Ride"] = 86.62, ["Neon"] = 262.5, ["Neon|Ride"] = 318.94, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 1048.69, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 36.74, ["Fly"] = 86.62, ["Ride"] = 59.07, ["Fly|Ride"] = 110.16, ["Neon"] = 216.57, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 210, ["Mega"] = 1722.9, ["Mega|Fly|Ride"] = 937.86}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 47.94, ["Fly"] = 155.93, ["Ride"] = 85.32, ["Fly|Ride"] = 196.88, ["Neon"] = 281.5, ["Neon|Ride"] = 404.91, ["Neon|Fly|Ride"] = 525, ["Mega"] = 1968.75, ["Mega|Ride"] = 1444.2, ["Mega|Fly|Ride"] = 1571.93}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 32.99, ["Ride"] = 52.5, ["Fly|Ride"] = 133.18, ["Neon"] = 210, ["Neon|Ride"] = 162.75, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 1207.92, ["Mega|Fly|Ride"] = 1723.32}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 51.44, ["Ride"] = 79.8, ["Fly|Ride"] = 123.38, ["Neon"] = 276.8, ["Neon|Ride"] = 273.42, ["Neon|Fly|Ride"] = 319.38, ["Mega|Ride"] = 1148.93, ["Mega|Fly|Ride"] = 984.12}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 7.81, ["Fly"] = 39.36, ["Ride"] = 20.39, ["Fly|Ride"] = 53.25, ["Neon"] = 41.85, ["Neon|Fly"] = 59.06, ["Neon|Ride"] = 49.12, ["Neon|Fly|Ride"] = 102.38, ["Mega"] = 142.93, ["Mega|Fly"] = 310.72, ["Mega|Ride"] = 196.67, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 484.32, ["Ride"] = 497.44, ["Fly|Ride"] = 590.63, ["Neon|Ride"] = 1639, ["Neon|Fly|Ride"] = 1967.44, ["Mega"] = 10825.88, ["Mega|Fly|Ride"] = 9759.54}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 12.99, ["Ride"] = 32.82, ["Fly|Ride"] = 140.01, ["Neon"] = 219.19, ["Mega|Ride"] = 822.68, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 6.37, ["Fly"] = 43.33, ["Ride"] = 21.68, ["Fly|Ride"] = 42.51, ["Neon"] = 75.03, ["Neon|Ride"] = 76.13, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 324.19, ["Mega|Ride"] = 316.15, ["Mega|Fly|Ride"] = 360.96}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 72.39, ["Fly"] = 90.57, ["Ride"] = 91.76, ["Fly|Ride"] = 133.49, ["Neon"] = 301.88, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 389.74, ["Mega"] = 1573.95, ["Mega|Ride"] = 7875, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 12.97, ["Ride"] = 34.47, ["Fly|Ride"] = 59.07, ["Neon"] = 82.68, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 274.96, ["Mega"] = 720.57, ["Mega|Ride"] = 822.78, ["Mega|Fly|Ride"] = 571.61}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 263.27, ["Fly"] = 300.68, ["Ride"] = 238.77, ["Fly|Ride"] = 223.13, ["Neon"] = 525, ["Neon|Ride"] = 623.44, ["Neon|Fly|Ride"] = 796.01, ["Mega"] = 6495.54, ["Mega|Ride"] = 3937.5}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 34.47}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.15, ["Fly"] = 28.28, ["Ride"] = 23.62, ["Fly|Ride"] = 72.85, ["Neon"] = 21, ["Neon|Fly"] = 145.09, ["Neon|Ride"] = 58.08, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 127.32, ["Mega|Fly"] = 492.29, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 1089.38, ["Fly"] = 3281.25, ["Ride"] = 1174.69, ["Fly|Ride"] = 1444.2, ["Neon"] = 9333.19, ["Neon|Ride"] = 6351.56, ["Neon|Fly|Ride"] = 6494.48, ["Mega|Ride"] = 55378.4, ["Mega|Fly|Ride"] = 24539.03}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 21.53, ["Ride"] = 45.83, ["Fly|Ride"] = 105.99, ["Neon"] = 217.76, ["Neon|Ride"] = 361.59, ["Neon|Fly|Ride"] = 162.42, ["Mega"] = 1043.44, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 242.01, ["Fly"] = 369.06, ["Ride"] = 238.88, ["Fly|Ride"] = 328.13, ["Neon"] = 1069.61, ["Neon|Ride"] = 984.38, ["Neon|Fly|Ride"] = 1000.09, ["Mega"] = 4428.51, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 3610.46}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 44.62}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 18.5, ["Fly"] = 86.8, ["Ride"] = 50.9, ["Fly|Ride"] = 145.09, ["Neon"] = 105, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 411.04, ["Mega"] = 598.55, ["Mega|Ride"] = 578.05, ["Mega|Fly|Ride"] = 722.11}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 125.99, ["Fly"] = 194.91, ["Ride"] = 131.24, ["Fly|Ride"] = 237.11, ["Neon"] = 635.5, ["Neon|Ride"] = 562.96, ["Neon|Fly|Ride"] = 527.24, ["Mega|Ride"] = 2297.82, ["Mega|Fly|Ride"] = 1811.25}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 104.74, ["Fly"] = 250.09, ["Ride"] = 137.81, ["Fly|Ride"] = 261.98, ["Neon"] = 427.8, ["Neon|Fly"] = 820.84, ["Neon|Ride"] = 397.87, ["Neon|Fly|Ride"] = 459.38, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1378.13}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 44.61}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 53.22, ["Fly"] = 72.18, ["Ride"] = 57.75, ["Fly|Ride"] = 87.84, ["Neon|Ride"] = 433.06, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 4330.88, ["Mega|Fly|Ride"] = 1591.96}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 8.17, ["Fly"] = 72.55, ["Ride"] = 45.47, ["Neon"] = 196.88, ["Neon|Ride"] = 142.51, ["Neon|Fly|Ride"] = 244.69, ["Mega"] = 258.57, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 278.03, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 525, ["Ride"] = 544.58, ["Fly|Ride"] = 616.88, ["Neon|Fly"] = 3897.79, ["Neon|Ride"] = 2251.8, ["Neon|Fly|Ride"] = 1903.13, ["Mega|Fly|Ride"] = 7415.63}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 115.64, ["Fly"] = 144.2, ["Ride"] = 111.57, ["Fly|Ride"] = 177.19, ["Neon"] = 505.59, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 400.32, ["Mega|Fly|Ride"] = 2416.31}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 4186.39, ["Ride"] = 3961.13, ["Fly|Ride"] = 3871.88}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 77.44, ["Fly"] = 231.7, ["Ride"] = 91.86, ["Fly|Ride"] = 167.32, ["Neon"] = 415.73, ["Neon|Ride"] = 525, ["Mega|Ride"] = 2007.13, ["Mega|Fly|Ride"] = 1953}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 90.66, ["Fly"] = 328.13, ["Ride"] = 90.96, ["Fly|Ride"] = 105, ["Neon"] = 575.75, ["Neon|Ride"] = 540.22, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 6351.56, ["Mega|Ride"] = 2388.75, ["Mega|Fly|Ride"] = 2022.29}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 32.33, ["Fly"] = 58.06, ["Ride"] = 43.29, ["Fly|Ride"] = 83.45, ["Neon"] = 165.34, ["Neon|Fly"] = 197.1, ["Neon|Ride"] = 148.32, ["Neon|Fly|Ride"] = 172.86, ["Mega"] = 2625, ["Mega|Ride"] = 925.63, ["Mega|Fly|Ride"] = 611.63}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 5.83}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 42, ["Fly"] = 393.75, ["Ride"] = 59.07, ["Fly|Ride"] = 115.86, ["Neon|Ride"] = 328.47, ["Neon|Fly|Ride"] = 446.25, ["Mega|Fly|Ride"] = 1370.57}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 36.75}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 212.63, ["Ride"] = 210, ["Fly|Ride"] = 301.88, ["Neon"] = 1155.15, ["Neon|Ride"] = 1155.15, ["Neon|Fly|Ride"] = 1299.13, ["Mega|Fly|Ride"] = 4858.87}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 708.75, ["Ride"] = 754.69, ["Fly|Ride"] = 721.88, ["Neon|Fly|Ride"] = 2998.78, ["Mega|Fly|Ride"] = 10028.82}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 8.54}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 31.45, ["Fly"] = 65.54, ["Ride"] = 40.8, ["Fly|Ride"] = 70.05, ["Neon"] = 256.19, ["Neon|Fly"] = 289.06, ["Neon|Ride"] = 187.69, ["Neon|Fly|Ride"] = 217, ["Mega|Ride"] = 866.51, ["Mega|Fly|Ride"] = 771.75}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 27.28}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 4449.38, ["Fly"] = 7216.77, ["Ride"] = 5954.25, ["Fly|Ride"] = 4423.13, ["Neon|Ride"] = 18042.95, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 32156.25}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 17.07, ["Fly"] = 56.36, ["Ride"] = 24.75, ["Fly|Ride"] = 58.58, ["Neon"] = 144.38, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 553.88, ["Mega|Ride"] = 490.88, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 18.36, ["Fly"] = 72.55, ["Ride"] = 50.88, ["Fly|Ride"] = 133.17, ["Neon"] = 100.35, ["Neon|Ride"] = 143.75, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 584.07, ["Mega|Ride"] = 492.07, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 78.75, ["Ride"] = 78.75, ["Fly|Ride"] = 131.25, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 495.7, ["Mega"] = 4330.37}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 12.71, ["Fly"] = 43.41, ["Ride"] = 42.24, ["Fly|Ride"] = 81.21, ["Neon"] = 98.36, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 501.38, ["Mega"] = 554.3, ["Mega|Ride"] = 774.06, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1706.25, ["Fly"] = 1970.32, ["Ride"] = 1509.38, ["Fly|Ride"] = 1575, ["Neon|Fly|Ride"] = 3149.88, ["Mega|Fly|Ride"] = 11025}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 26250, ["Fly"] = 30187.5, ["Ride"] = 33339.74, ["Fly|Ride"] = 22968.75, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 63793.63, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 18.38, ["Fly"] = 89.25, ["Ride"] = 55.12, ["Fly|Ride"] = 120.75, ["Neon"] = 115.86, ["Neon|Ride"] = 291.38, ["Neon|Fly|Ride"] = 592.19, ["Mega"] = 905.63, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1571.93}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 4.2, ["Fly"] = 43.33, ["Ride"] = 38.75, ["Fly|Ride"] = 128.63, ["Neon"] = 24.61, ["Neon|Fly"] = 231.05, ["Neon|Ride"] = 80.13, ["Neon|Fly|Ride"] = 132.37, ["Mega"] = 121.12, ["Mega|Fly"] = 386.28, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 26.9}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 8.4, ["Ride"] = 31.5, ["Fly|Ride"] = 164.85, ["Neon"] = 57.75, ["Neon|Ride"] = 92.61, ["Neon|Fly|Ride"] = 377.84, ["Mega"] = 552.35, ["Mega|Ride"] = 410.31, ["Mega|Fly|Ride"] = 574.49}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 751.33, ["Fly"] = 866.18, ["Ride"] = 654.93, ["Fly|Ride"] = 729.68, ["Neon"] = 3118.44, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2296.88, ["Mega|Fly|Ride"] = 9102.68}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 779.62, ["Fly"] = 1007.92, ["Ride"] = 813.75, ["Fly|Ride"] = 833.44, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 11403.99}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 16.73, ["Fly"] = 123.03, ["Ride"] = 36.74, ["Fly|Ride"] = 100.05, ["Neon"] = 95.82, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 162.75, ["Mega"] = 501.85, ["Mega|Ride"] = 481.9, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 27.57}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 80.13, ["Fly"] = 85.32, ["Ride"] = 85.32, ["Fly|Ride"] = 118.01, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 451.5, ["Mega"] = 19687.5, ["Mega|Ride"] = 2022.29, ["Mega|Fly|Ride"] = 2122.73}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 91.22, ["Fly"] = 145.09, ["Ride"] = 108.29, ["Fly|Ride"] = 145.09, ["Neon"] = 450.19, ["Neon|Ride"] = 502.41, ["Neon|Fly|Ride"] = 509.15, ["Mega"] = 1408.88}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.84, ["Fly"] = 35.81, ["Ride"] = 19.67, ["Fly|Ride"] = 46.1, ["Neon"] = 44.1, ["Neon|Fly"] = 488.69, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 187.69, ["Mega|Fly|Ride"] = 358.07}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 190.3, ["Fly"] = 210, ["Ride"] = 215.25, ["Fly|Ride"] = 280.67, ["Neon|Ride"] = 681.16, ["Neon|Fly|Ride"] = 707.44, ["Mega"] = 5197.06, ["Mega|Fly|Ride"] = 2334.84}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 9.06, ["Ride"] = 52.49, ["Fly|Ride"] = 144.8, ["Neon"] = 48.57, ["Neon|Ride"] = 124.68, ["Neon|Fly|Ride"] = 404.91, ["Mega"] = 210, ["Mega|Fly"] = 1137.94, ["Mega|Ride"] = 229.69, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 15.75, ["Fly"] = 49.22, ["Ride"] = 32.82, ["Fly|Ride"] = 90.85, ["Neon"] = 129.92, ["Neon|Fly"] = 328.59, ["Neon|Ride"] = 145.28, ["Neon|Fly|Ride"] = 274.98, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 26.24, ["Ride"] = 57.75, ["Fly|Ride"] = 156.19, ["Neon"] = 257.25, ["Neon|Ride"] = 280, ["Neon|Fly|Ride"] = 259.88, ["Mega"] = 997.5, ["Mega|Ride"] = 853.13, ["Mega|Fly|Ride"] = 1011.85}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 17.06, ["Fly"] = 88.77, ["Ride"] = 29.25, ["Fly|Ride"] = 61.6, ["Neon"] = 151.57, ["Neon|Ride"] = 328.47, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1082.61, ["Mega|Ride"] = 1088.98, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6956.25, ["Ride"] = 5604.38, ["Fly|Ride"] = 5381.25, ["Neon"] = 32477.64, ["Neon|Fly|Ride"] = 29498.37}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 238.87, ["Fly"] = 236.24, ["Ride"] = 236.25, ["Fly|Ride"] = 273.51, ["Neon"] = 820.52, ["Neon|Ride"] = 576.19, ["Neon|Fly|Ride"] = 544.59, ["Mega|Fly|Ride"] = 2034.38}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 62.99, ["Fly"] = 157.5, ["Ride"] = 188.4, ["Fly|Ride"] = 374.07, ["Neon"] = 220.5, ["Neon|Ride"] = 289.06, ["Neon|Fly|Ride"] = 469.86, ["Mega"] = 563.07, ["Mega|Ride"] = 711.38, ["Mega|Fly|Ride"] = 754.42}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.15, ["Fly"] = 65.63, ["Ride"] = 23.83, ["Fly|Ride"] = 81.38, ["Neon"] = 23.61, ["Neon|Ride"] = 35.28, ["Neon|Fly|Ride"] = 164.85, ["Mega"] = 131.25, ["Mega|Ride"] = 332.41, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 55.11, ["Fly"] = 215.34, ["Ride"] = 109.1, ["Fly|Ride"] = 213.94, ["Neon"] = 208.69, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 542.59, ["Mega|Ride"] = 455.44, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 11648.44, ["Ride"] = 13415.07, ["Fly|Ride"] = 11550, ["Neon|Fly|Ride"] = 24766.88, ["Mega|Fly|Ride"] = 100871.25}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 347.82, ["Ride"] = 393.75, ["Fly|Ride"] = 578.11, ["Neon"] = 3245.62, ["Neon|Ride"] = 1732.16, ["Neon|Fly|Ride"] = 1787.2, ["Mega"] = 8137.5, ["Mega|Fly|Ride"] = 7873.69}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 51.18, ["Fly"] = 72.55, ["Ride"] = 59.07, ["Fly|Ride"] = 115.5, ["Neon"] = 301.88, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 392.44, ["Mega|Fly|Ride"] = 2022.05}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 11.81, ["Ride"] = 20.58, ["Fly|Ride"] = 59.07, ["Neon"] = 69.21, ["Neon|Fly"] = 279.37, ["Neon|Ride"] = 78.73, ["Neon|Fly|Ride"] = 142.92, ["Mega"] = 336, ["Mega|Fly|Ride"] = 556.46}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 404.25, ["Ride"] = 406.88, ["Fly|Ride"] = 477.75, ["Neon"] = 1253.44, ["Neon|Ride"] = 1380.31, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 4547.82}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 5.25, ["Fly"] = 71.47, ["Ride"] = 39.26, ["Fly|Ride"] = 164.85, ["Neon"] = 28.77, ["Neon|Ride"] = 144.37, ["Neon|Fly|Ride"] = 196.77, ["Mega"] = 167.62, ["Mega|Ride"] = 215.25, ["Mega|Fly|Ride"] = 278.25}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 104.99, ["Fly"] = 216.54, ["Ride"] = 136.48, ["Fly|Ride"] = 209.88, ["Neon"] = 524.99, ["Neon|Fly"] = 525, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 557.82, ["Mega"] = 2598.22, ["Mega|Fly"] = 2524.61, ["Mega|Fly|Ride"] = 2430.18}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 12.1, ["Fly"] = 21.68, ["Ride"] = 16.78, ["Fly|Ride"] = 36.63, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 88.22, ["Mega"] = 2598.22, ["Mega|Fly|Ride"] = 747.48}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 9.98}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 82.6, ["Fly"] = 598.23, ["Ride"] = 118.13, ["Fly|Ride"] = 173.22, ["Neon"] = 352.43, ["Neon|Fly"] = 1299.13, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 3247.77, ["Mega|Ride"] = 1877.24, ["Mega|Fly|Ride"] = 2310.26}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 15.31, ["Fly"] = 78.33, ["Ride"] = 32.82, ["Fly|Ride"] = 83.91, ["Neon"] = 105, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 548.89, ["Mega|Ride"] = 577.5, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 68.25}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 90.56, ["Fly"] = 145.09, ["Ride"] = 131.25, ["Fly|Ride"] = 300.98, ["Neon"] = 392.44, ["Neon|Ride"] = 458.07, ["Neon|Fly|Ride"] = 420, ["Mega|Fly|Ride"] = 1968.23}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.85, ["Ride"] = 29.25, ["Fly|Ride"] = 139.13, ["Neon"] = 21, ["Neon|Ride"] = 141.82, ["Neon|Fly|Ride"] = 253.34, ["Mega"] = 136.5, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 288.1}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 13.76, ["Fly"] = 56.42, ["Ride"] = 32.82, ["Fly|Ride"] = 86.62, ["Neon|Ride"] = 106.12, ["Neon|Fly|Ride"] = 216.54, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 603.74, ["Ride"] = 534.45, ["Fly|Ride"] = 459.38, ["Neon|Fly|Ride"] = 5773.85, ["Mega|Fly|Ride"] = 7087.5}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 37.99, ["Ride"] = 84.47, ["Fly|Ride"] = 107.6, ["Neon"] = 195.57, ["Neon|Ride"] = 145.09, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 776.43, ["Mega|Ride"] = 647.79, ["Mega|Fly|Ride"] = 722.11}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 44.63, ["Fly"] = 101.78, ["Ride"] = 86.21, ["Fly|Ride"] = 157.67, ["Neon"] = 322.63, ["Neon|Ride"] = 254.91, ["Neon|Fly|Ride"] = 324.8, ["Mega|Fly|Ride"] = 866.09}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 20.99, ["Fly"] = 80.04, ["Ride"] = 64.6, ["Fly|Ride"] = 110.25, ["Neon"] = 101.06, ["Neon|Fly"] = 328.44, ["Neon|Ride"] = 161.39, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 350.83, ["Mega|Ride"] = 580.46, ["Mega|Fly|Ride"] = 562.96}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11158.12, ["Fly"] = 10068.1, ["Ride"] = 8862, ["Fly|Ride"] = 7350, ["Neon|Fly|Ride"] = 14437.49, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1351.88, ["Fly"] = 1563.63, ["Ride"] = 1260, ["Fly|Ride"] = 1353.19, ["Neon|Fly|Ride"] = 4055.63, ["Mega|Fly|Ride"] = 15745.14}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 608.98, ["Ride"] = 525, ["Fly|Ride"] = 590.63, ["Neon"] = 2253.58, ["Neon|Fly|Ride"] = 2437.74, ["Mega"] = 21651.76, ["Mega|Fly|Ride"] = 9841.11}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 11.15, ["Fly"] = 25.11, ["Ride"] = 21.68, ["Fly|Ride"] = 42.95, ["Neon"] = 123.41, ["Neon|Ride"] = 82.43, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 492.07, ["Mega|Fly|Ride"] = 539.44}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 3.15, ["Fly"] = 78.74, ["Ride"] = 29.25, ["Fly|Ride"] = 199.21, ["Neon"] = 32.08, ["Neon|Ride"] = 71.56, ["Mega"] = 259.88, ["Mega|Ride"] = 225.69, ["Mega|Fly|Ride"] = 283.59}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 36.92, ["Fly"] = 53.72, ["Ride"] = 43.53, ["Fly|Ride"] = 100.5, ["Neon"] = 551.16, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 190.19, ["Mega|Fly|Ride"] = 665.81}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.15, ["Fly"] = 23.14, ["Ride"] = 17.67, ["Fly|Ride"] = 36.62, ["Neon"] = 29.25, ["Neon|Fly"] = 65.37, ["Neon|Ride"] = 50.9, ["Neon|Fly|Ride"] = 104.98, ["Mega"] = 294.9, ["Mega|Ride"] = 361.59, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 306.79, ["Fly"] = 448.88, ["Ride"] = 328.13, ["Fly|Ride"] = 393.75, ["Neon"] = 1638.49, ["Neon|Ride"] = 1459.35, ["Neon|Fly|Ride"] = 1373.61, ["Mega|Fly|Ride"] = 4977.76}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 22.96, ["Fly"] = 91.87, ["Ride"] = 40.68, ["Fly|Ride"] = 91.88, ["Neon"] = 144.38, ["Neon|Fly"] = 415.56, ["Neon|Ride"] = 133.71, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 865.98, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 8.96, ["Fly"] = 24.31, ["Ride"] = 18.16, ["Fly|Ride"] = 42.46, ["Neon"] = 82.29, ["Neon|Fly"] = 122.36, ["Neon|Ride"] = 134.15, ["Neon|Fly|Ride"] = 142.92, ["Mega"] = 1444.01, ["Mega|Fly"] = 541.31, ["Mega|Ride"] = 451.5, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 459.38, ["Fly"] = 1048.69, ["Ride"] = 485.63, ["Fly|Ride"] = 368.05, ["Mega|Fly|Ride"] = 9971.07}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1050, ["Fly"] = 1444.37, ["Ride"] = 1063.13, ["Fly|Ride"] = 1050, ["Neon"] = 5280.63, ["Neon|Ride"] = 4043.48, ["Neon|Fly|Ride"] = 3465, ["Mega|Fly|Ride"] = 13782.3}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 128.63, ["Fly"] = 129.94, ["Ride"] = 100.76, ["Fly|Ride"] = 115.5, ["Neon"] = 971.25, ["Neon|Ride"] = 984.12, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 2596.07, ["Mega|Fly|Ride"] = 2869.12}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 177.19, ["Fly"] = 196.86, ["Ride"] = 183.75, ["Fly|Ride"] = 245.68, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 616.66, ["Mega|Ride"] = 9493.32, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 32, ["Fly"] = 73.82, ["Ride"] = 56.1, ["Fly|Ride"] = 101.06, ["Neon"] = 262.4, ["Neon|Ride"] = 239.89, ["Neon|Fly|Ride"] = 281.21, ["Mega|Ride"] = 2164.94, ["Mega|Fly|Ride"] = 1141.06}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 203.44, ["Ride"] = 649.59, ["Fly|Ride"] = 578.11, ["Neon"] = 1220.63, ["Mega|Fly|Ride"] = 6495.54}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2377.38, ["Ride"] = 2266.95, ["Fly|Ride"] = 2100, ["Neon"] = 10825.88, ["Neon|Fly|Ride"] = 10825.88, ["Mega|Fly|Ride"] = 49804.99}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 60.29, ["Fly"] = 216.54, ["Ride"] = 73.49, ["Neon"] = 288.75, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 343.3, ["Mega|Ride"] = 1877.24, ["Mega|Fly|Ride"] = 1585.15}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 551.25, ["Fly"] = 863.71, ["Ride"] = 603.73, ["Fly|Ride"] = 628.69, ["Neon|Ride"] = 1305.92, ["Neon|Fly|Ride"] = 1168.02, ["Mega|Fly|Ride"] = 3688.39}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 38.94, ["Fly"] = 72.19, ["Ride"] = 52.5, ["Fly|Ride"] = 98.33, ["Neon"] = 432.99, ["Neon|Ride"] = 258.35, ["Neon|Fly|Ride"] = 203.44, ["Mega|Fly|Ride"] = 1011.15}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.5, ["Fly"] = 55.22, ["Ride"] = 19.69, ["Fly|Ride"] = 44.78, ["Neon"] = 32.48, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 42.89, ["Neon|Fly|Ride"] = 103.53, ["Mega"] = 160.13, ["Mega|Fly"] = 254.05, ["Mega|Ride"] = 180.8, ["Mega|Fly|Ride"] = 259.14}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 73.5, ["Ride"] = 131.12, ["Fly|Ride"] = 157.5, ["Neon"] = 401.5, ["Neon|Ride"] = 492.06, ["Neon|Fly|Ride"] = 722.11, ["Mega"] = 1622.82, ["Mega|Ride"] = 1732.16, ["Mega|Fly|Ride"] = 1877.24}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 1027.82, ["Ride"] = 1036.88, ["Fly|Ride"] = 1073.63, ["Neon|Ride"] = 3694.69, ["Neon|Fly|Ride"] = 3150, ["Mega|Fly|Ride"] = 14807.63}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 669.38, ["Ride"] = 840, ["Fly|Ride"] = 1011.15, ["Neon|Fly|Ride"] = 4330.37, ["Mega|Fly|Ride"] = 20208.68}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 15.4, ["Fly"] = 33.23, ["Ride"] = 21.68, ["Fly|Ride"] = 41.37, ["Neon"] = 144.38, ["Neon|Ride"] = 119.76, ["Neon|Fly|Ride"] = 145.69, ["Mega|Fly|Ride"] = 777.34}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 21, ["Ride"] = 46.69, ["Fly|Ride"] = 141.83, ["Neon"] = 253.32, ["Neon|Ride"] = 268.85, ["Neon|Fly|Ride"] = 418.99, ["Mega"] = 1641.02, ["Mega|Ride"] = 2915.85, ["Mega|Fly|Ride"] = 1227.19}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.05, ["Fly"] = 67.37, ["Ride"] = 24.5, ["Fly|Ride"] = 72.19, ["Neon"] = 28.16, ["Neon|Fly"] = 145.09, ["Neon|Ride"] = 49.19, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 196.88, ["Mega|Fly"] = 574.49, ["Mega|Ride"] = 187.11, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 36.69, ["Fly"] = 60.38, ["Ride"] = 42.73, ["Fly|Ride"] = 104.98, ["Neon"] = 418.99, ["Neon|Ride"] = 220.5, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 984.12, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 91.88, ["Ride"] = 289.06, ["Fly|Ride"] = 262.5, ["Neon"] = 560.33, ["Neon|Ride"] = 603.75, ["Neon|Fly|Ride"] = 909.08, ["Mega"] = 1837.5, ["Mega|Fly|Ride"] = 2575.13}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 18.26, ["Fly"] = 58.48, ["Ride"] = 40.73, ["Fly|Ride"] = 93.7, ["Neon"] = 91.88, ["Neon|Ride"] = 97.79, ["Neon|Fly|Ride"] = 192.09, ["Mega"] = 506.85, ["Mega|Ride"] = 394.96, ["Mega|Fly|Ride"] = 535.89}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 36.29, ["Fly"] = 64.31, ["Ride"] = 39.38, ["Fly|Ride"] = 90.45, ["Neon"] = 244.39, ["Neon|Fly"] = 1444.37, ["Neon|Ride"] = 196.21, ["Neon|Fly|Ride"] = 249.21, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1066.65}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.15, ["Fly"] = 58.65, ["Ride"] = 18.25, ["Fly|Ride"] = 45.82, ["Neon"] = 33.41, ["Neon|Ride"] = 40.1, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 223.13, ["Mega|Ride"] = 394.75, ["Mega|Fly|Ride"] = 368.82}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 7.33, ["Fly"] = 58.48, ["Ride"] = 35.42, ["Fly|Ride"] = 87.93, ["Neon"] = 66.45, ["Neon|Fly"] = 115.54, ["Neon|Ride"] = 84.73, ["Neon|Fly|Ride"] = 267.75, ["Mega"] = 380.63, ["Mega|Ride"] = 484.62, ["Mega|Fly|Ride"] = 498.65}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 39.37, ["Fly"] = 42, ["Ride"] = 55.11, ["Fly|Ride"] = 72.19, ["Neon"] = 572.87, ["Neon|Ride"] = 215.38, ["Neon|Fly|Ride"] = 239.27, ["Mega|Fly|Ride"] = 1074.94}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1391.25, ["Fly"] = 1732.16, ["Ride"] = 1338.75, ["Fly|Ride"] = 1338.74, ["Neon|Fly|Ride"] = 3378.38, ["Mega|Fly|Ride"] = 13013.69}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 498.75, ["Fly"] = 683.12, ["Ride"] = 525, ["Fly|Ride"] = 584.07, ["Neon"] = 2670.76, ["Neon|Ride"] = 1740.38, ["Neon|Fly|Ride"] = 2332.32}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 301.88, ["Fly"] = 420, ["Ride"] = 269.33, ["Fly|Ride"] = 492.07, ["Neon"] = 1661.79, ["Neon|Ride"] = 1755.43, ["Neon|Fly|Ride"] = 1847.99, ["Mega|Fly|Ride"] = 5331.42}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 42}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 31.5, ["Fly"] = 64.97, ["Ride"] = 49.87, ["Fly|Ride"] = 105, ["Neon"] = 302.65, ["Neon|Fly"] = 578.11, ["Neon|Ride"] = 324.8, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 1732.16, ["Mega|Fly|Ride"] = 1036.54}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 70875, ["Fly"] = 25761.99, ["Ride"] = 37724.63, ["Fly|Ride"] = 18899.88, ["Neon|Fly|Ride"] = 32812.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 295.84, ["Fly"] = 328.12, ["Ride"] = 275.63, ["Fly|Ride"] = 377.2, ["Neon"] = 889.88, ["Neon|Ride"] = 1011.15, ["Neon|Fly|Ride"] = 951.56, ["Mega"] = 6495.54, ["Mega|Fly|Ride"] = 3281.33}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 158.81, ["Fly"] = 525, ["Ride"] = 180.3, ["Fly|Ride"] = 323.71}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 111.56, ["Fly"] = 216.54, ["Ride"] = 116.71, ["Fly|Ride"] = 195.57, ["Neon|Ride"] = 719.24, ["Neon|Fly|Ride"] = 666.75, ["Mega|Fly|Ride"] = 2887.5}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 14.41, ["Fly"] = 62.82, ["Ride"] = 23.63, ["Fly|Ride"] = 71.37, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 160.26, ["Neon|Fly|Ride"] = 239.27, ["Mega"] = 1968.75, ["Mega|Ride"] = 718.86, ["Mega|Fly|Ride"] = 661.5}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3814.43, ["Ride"] = 4058.25, ["Fly|Ride"] = 4003.13, ["Neon"] = 21651.76, ["Neon|Fly|Ride"] = 15750, ["Mega|Fly|Ride"] = 82042.49}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 32.11, ["Fly"] = 52.5, ["Ride"] = 32.47, ["Fly|Ride"] = 53.46, ["Neon"] = 208.58, ["Neon|Ride"] = 201.37, ["Neon|Fly|Ride"] = 195.57, ["Mega|Ride"] = 1444.2, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 36.37, ["Fly"] = 105, ["Ride"] = 45.93, ["Fly|Ride"] = 98.44, ["Neon"] = 310.72, ["Neon|Fly"] = 1444.01, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 346.44, ["Mega|Fly|Ride"] = 1607.82}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 392.43, ["Fly"] = 459.38, ["Ride"] = 433.13, ["Fly|Ride"] = 505.45, ["Neon"] = 1312.5, ["Neon|Ride"] = 1141.87, ["Neon|Fly|Ride"] = 1078.88, ["Mega|Fly|Ride"] = 3593.63}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 15.73, ["Fly"] = 25.58, ["Ride"] = 23.61, ["Fly|Ride"] = 49.76, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 145.59, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 509.25}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 15.61, ["Fly"] = 289.1, ["Ride"] = 35.43, ["Fly|Ride"] = 71.39, ["Neon"] = 98.44, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 219.91, ["Mega|Ride"] = 551.25}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 90.56, ["Ride"] = 111.56, ["Fly|Ride"] = 245.44, ["Neon"] = 529.85, ["Neon|Ride"] = 511.88, ["Neon|Fly|Ride"] = 649.69, ["Mega|Ride"] = 4330.88, ["Mega|Fly|Ride"] = 2138.07}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 15.74, ["Fly"] = 102.38, ["Ride"] = 72.19, ["Fly|Ride"] = 144.38, ["Neon"] = 64.77, ["Neon|Ride"] = 111.65, ["Neon|Fly|Ride"] = 258.76, ["Mega"] = 263.27, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 279.22, ["Mega|Fly|Ride"] = 355.69}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 5906.25, ["Ride"] = 5499.38, ["Fly|Ride"] = 5151.57, ["Neon|Ride"] = 15587.42, ["Neon|Fly|Ride"] = 11811.19, ["Mega"] = 49102.09, ["Mega|Fly|Ride"] = 37945.69}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 36.66, ["Fly"] = 145.1, ["Ride"] = 66.27, ["Fly|Ride"] = 145.1, ["Neon"] = 233.62, ["Neon|Ride"] = 263.27, ["Neon|Fly|Ride"] = 499.42, ["Mega"] = 1227.83, ["Mega|Ride"] = 1414.95, ["Mega|Fly|Ride"] = 784.88}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 6562.5, ["Ride"] = 6857.81, ["Fly|Ride"] = 6380.07, ["Neon|Fly"] = 18620.53, ["Neon|Fly|Ride"] = 15225, ["Mega|Fly|Ride"] = 46921.88}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.15, ["Fly"] = 21.27, ["Ride"] = 16.21, ["Fly|Ride"] = 37.7, ["Neon"] = 24.94, ["Neon|Fly"] = 62.74, ["Neon|Ride"] = 39.52, ["Neon|Fly|Ride"] = 108.27, ["Mega"] = 161.44, ["Mega|Fly"] = 1444.2, ["Mega|Ride"] = 289.06, ["Mega|Fly|Ride"] = 208.95}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 17.77, ["Fly"] = 29.58, ["Ride"] = 34.12, ["Fly|Ride"] = 52.5, ["Neon"] = 92.28, ["Neon|Ride"] = 144.68, ["Neon|Fly|Ride"] = 142.93, ["Mega|Ride"] = 893.17, ["Mega|Fly|Ride"] = 865.98}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 5.25}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 12.65, ["Fly"] = 39.37, ["Ride"] = 31.42, ["Fly|Ride"] = 85.32, ["Neon"] = 170.62, ["Neon|Ride"] = 131.25, ["Mega"] = 1049.9, ["Mega|Ride"] = 1154.06, ["Mega|Fly|Ride"] = 820.52}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 30.97, ["Fly"] = 190.37, ["Ride"] = 45.94, ["Fly|Ride"] = 114.34, ["Neon"] = 315, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 209.62, ["Mega"] = 839.99, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 11.82, ["Fly"] = 24.92, ["Ride"] = 19.49, ["Fly|Ride"] = 43.32, ["Neon"] = 94, ["Neon|Fly"] = 1079.36, ["Neon|Ride"] = 108.27, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 1135.65, ["Mega|Fly|Ride"] = 664.74}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 6628.13}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 3071.25}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 24.94}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 210, ["Ride"] = 377.67, ["Fly|Ride"] = 341.25, ["Neon|Fly|Ride"] = 1215.35}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 14.2, ["Fly"] = 43.32, ["Ride"] = 40.62, ["Fly|Ride"] = 147, ["Neon"] = 104.9, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 265.13, ["Mega|Ride"] = 1470, ["Mega|Fly|Ride"] = 578.11}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 13.13}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.15, ["Ride"] = 25.97, ["Fly|Ride"] = 86.61, ["Neon"] = 145.09, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 184.03}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2100}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 259.86, ["Ride"] = 535.89, ["Fly|Ride"] = 306.38, ["Neon"] = 1048.69, ["Neon|Fly|Ride"] = 1588.17, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 57.66, ["Fly"] = 216.54, ["Ride"] = 73.82, ["Fly|Ride"] = 525, ["Neon"] = 316.32, ["Neon|Ride"] = 345.96, ["Neon|Fly|Ride"] = 722.01, ["Mega|Ride"] = 2460.29, ["Mega|Fly|Ride"] = 2165.19}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 144.38, ["Fly"] = 275.63, ["Ride"] = 199.01, ["Fly|Ride"] = 230.05, ["Neon"] = 757.32, ["Neon|Ride"] = 774.38, ["Neon|Fly|Ride"] = 748.12, ["Mega|Ride"] = 3680.82, ["Mega|Fly|Ride"] = 3610.36}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2428.13, ["Ride"] = 2492.44, ["Fly|Ride"] = 2619.75, ["Neon"] = 15204.24, ["Neon|Fly|Ride"] = 10104.9, ["Mega|Fly|Ride"] = 31499.99}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 23.41, ["Fly"] = 157.5, ["Ride"] = 45.94, ["Fly|Ride"] = 90.04, ["Neon"] = 216.5, ["Neon|Ride"] = 387.92, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 973.27, ["Mega|Ride"] = 2367.64, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 1155.15, ["Ride"] = 1299.13, ["Fly|Ride"] = 1623.89, ["Neon|Fly|Ride"] = 4330.37, ["Mega|Fly|Ride"] = 18862.94}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 65.63}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 23.39, ["Fly"] = 99.61, ["Ride"] = 43.33, ["Fly|Ride"] = 245.44, ["Neon"] = 107.63, ["Neon|Ride"] = 137.51, ["Neon|Fly|Ride"] = 264.16, ["Mega"] = 379.32, ["Mega|Ride"] = 526.12, ["Mega|Fly|Ride"] = 523.79}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 10.21, ["Fly"] = 38.4, ["Ride"] = 31.91, ["Fly|Ride"] = 76.28, ["Neon"] = 68.25, ["Neon|Fly"] = 315, ["Neon|Ride"] = 77.35, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 460.06, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 578.11}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 75.6}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 17.06, ["Fly"] = 64.97, ["Ride"] = 33.23, ["Fly|Ride"] = 57.75, ["Neon"] = 145.09, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 259.86, ["Mega|Ride"] = 1299.13, ["Mega|Fly|Ride"] = 866.09}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 28.86, ["Fly"] = 36.73, ["Ride"] = 41.56, ["Fly|Ride"] = 61.13, ["Neon"] = 202.44, ["Neon|Fly"] = 289.1, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 249.36, ["Mega"] = 1444.37, ["Mega|Ride"] = 1845.97, ["Mega|Fly|Ride"] = 871.5}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 5931.19, ["Fly"] = 4685.63, ["Ride"] = 6613.95, ["Fly|Ride"] = 4756.5, ["Neon|Fly|Ride"] = 10489.5, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 9.49, ["Fly"] = 49.81, ["Ride"] = 31.32, ["Fly|Ride"] = 81.84, ["Neon"] = 57.75, ["Neon|Ride"] = 95.69, ["Mega"] = 354.38, ["Mega|Ride"] = 329.44, ["Mega|Fly|Ride"] = 757.74}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 26.16}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 85.19, ["Fly"] = 383.24, ["Ride"] = 116.82, ["Fly|Ride"] = 246.75, ["Neon"] = 531.57, ["Neon|Ride"] = 566.21, ["Neon|Fly|Ride"] = 535.5, ["Mega"] = 2879.59, ["Mega|Ride"] = 1840.43, ["Mega|Fly|Ride"] = 1592.82}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 56.24, ["Fly"] = 200.8, ["Ride"] = 97.13, ["Fly|Ride"] = 181.92, ["Neon"] = 255.94, ["Neon|Fly"] = 369.06, ["Neon|Ride"] = 317.63, ["Neon|Fly|Ride"] = 505.59, ["Mega"] = 1227.68, ["Mega|Ride"] = 1244.99, ["Mega|Fly|Ride"] = 1200.94}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 26.25, ["Fly"] = 72.55, ["Ride"] = 32.82, ["Fly|Ride"] = 62.98, ["Neon"] = 96.48, ["Neon|Fly"] = 233.85, ["Neon|Ride"] = 136.5, ["Neon|Fly|Ride"] = 192.84, ["Mega"] = 1016.21, ["Mega|Ride"] = 947.28, ["Mega|Fly|Ride"] = 714.52}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 5.91, ["Fly"] = 68.25, ["Ride"] = 25.5, ["Fly|Ride"] = 108.27, ["Neon"] = 36.66, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 170.71, ["Mega"] = 119.04, ["Mega|Fly"] = 183.75, ["Mega|Ride"] = 289.04, ["Mega|Fly|Ride"] = 301.56}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 14.33, ["Fly"] = 105, ["Ride"] = 33.79, ["Fly|Ride"] = 93.12, ["Neon"] = 86.62, ["Neon|Ride"] = 115.86, ["Neon|Fly|Ride"] = 231.7, ["Mega"] = 380.63, ["Mega|Ride"] = 486.1, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 29.25, ["Fly"] = 28.58, ["Ride"] = 26.15, ["Fly|Ride"] = 44.54, ["Neon"] = 184.03, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 131.25, ["Mega|Fly|Ride"] = 511.87}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 196.88}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 35.43, ["Ride"] = 157.5, ["Fly|Ride"] = 289.06, ["Neon"] = 196.88, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 463.36, ["Mega"] = 866.25, ["Mega|Fly|Ride"] = 791.31}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 262, ["Ride"] = 482.86}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 62.99, ["Ride"] = 98.97, ["Fly|Ride"] = 199.44, ["Neon"] = 216.57, ["Neon|Ride"] = 324.77, ["Neon|Fly|Ride"] = 471.19, ["Mega"] = 1212.51, ["Mega|Ride"] = 1406.31, ["Mega|Fly|Ride"] = 1444.2}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 1093.32, ["Fly"] = 1246.67, ["Ride"] = 1050, ["Fly|Ride"] = 1049.74, ["Neon|Ride"] = 3675, ["Neon|Fly|Ride"] = 3412.5, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 472.49, ["Ride"] = 485.5, ["Fly|Ride"] = 551.25, ["Neon"] = 2405.82, ["Neon|Ride"] = 7795.58, ["Neon|Fly|Ride"] = 1903.13, ["Mega"] = 12600, ["Mega|Fly|Ride"] = 8267.44}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 63.62}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 11.71, ["Fly"] = 28.88, ["Ride"] = 24.91, ["Fly|Ride"] = 53.84, ["Neon"] = 98.42, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 437.26, ["Mega|Ride"] = 562.96, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 236.15, ["Fly"] = 459.38, ["Ride"] = 275.63, ["Fly|Ride"] = 357, ["Neon"] = 2442.49, ["Neon|Ride"] = 759.94, ["Neon|Fly|Ride"] = 954.18, ["Mega|Fly|Ride"] = 3601.79}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 19.28}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 115.86, ["Fly"] = 216.57, ["Ride"] = 157.56, ["Fly|Ride"] = 246.11, ["Neon"] = 630, ["Neon|Fly"] = 610.32, ["Neon|Ride"] = 561, ["Neon|Fly|Ride"] = 714, ["Mega"] = 2879.35, ["Mega|Ride"] = 12270.07, ["Mega|Fly|Ride"] = 2788.73}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 129.83, ["Fly"] = 312.47, ["Ride"] = 157.5, ["Fly|Ride"] = 289.06, ["Neon"] = 1025.22, ["Neon|Ride"] = 1032.94, ["Neon|Fly|Ride"] = 931.88, ["Mega|Fly|Ride"] = 2022.05}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 8.54, ["Ride"] = 24.93, ["Fly|Ride"] = 729.75, ["Neon"] = 32.82, ["Neon|Ride"] = 73.41, ["Neon|Fly|Ride"] = 211.32, ["Mega"] = 171.28, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 407.19}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 18.36, ["Fly"] = 30.87, ["Ride"] = 29.28, ["Fly|Ride"] = 69.65, ["Neon"] = 110.25, ["Neon|Fly"] = 145.09, ["Neon|Ride"] = 101.48, ["Neon|Fly|Ride"] = 209.9, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 14.78, ["Fly"] = 64.98, ["Ride"] = 36.75, ["Fly|Ride"] = 131.25, ["Neon"] = 110.25, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 215.91, ["Mega"] = 385.42, ["Mega|Ride"] = 429.19, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 4.2, ["Fly"] = 715.31, ["Ride"] = 52.89, ["Fly|Ride"] = 115.86, ["Neon"] = 23.63, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 155.91, ["Mega"] = 131.25, ["Mega|Ride"] = 170.52, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 301.67, ["Ride"] = 309.75, ["Fly|Ride"] = 367.5, ["Neon|Ride"] = 1444.2, ["Neon|Fly|Ride"] = 1424.07}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 86.59, ["Fly"] = 578.19, ["Ride"] = 125.98, ["Fly|Ride"] = 216.15, ["Neon"] = 459.37, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 510.57, ["Mega"] = 2022.57, ["Mega|Fly|Ride"] = 2117.55}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 72.63, ["Fly"] = 105, ["Ride"] = 86.63, ["Fly|Ride"] = 142.92, ["Neon"] = 393.75, ["Neon|Ride"] = 349.13, ["Neon|Fly|Ride"] = 446.25, ["Mega|Ride"] = 1804.63, ["Mega|Fly|Ride"] = 1374.18}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 20.58, ["Ride"] = 54.14, ["Neon|Ride"] = 625.19, ["Neon|Fly|Ride"] = 492.07, ["Mega|Fly|Ride"] = 1011.15}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 16.32, ["Ride"] = 26.25, ["Fly|Ride"] = 97.3, ["Neon"] = 70.92, ["Neon|Ride"] = 94.31, ["Neon|Fly|Ride"] = 164.85, ["Mega"] = 807.19, ["Mega|Ride"] = 823.2, ["Mega|Fly|Ride"] = 451.49}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 2.63, ["Fly"] = 52.5, ["Ride"] = 24.62, ["Fly|Ride"] = 97.44, ["Neon"] = 21, ["Neon|Fly"] = 105000, ["Neon|Ride"] = 42.95, ["Neon|Fly|Ride"] = 111.71, ["Mega"] = 246.04, ["Mega|Ride"] = 149.63, ["Mega|Fly|Ride"] = 253.98}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 853.13, ["Fly"] = 918.75, ["Ride"] = 879.37, ["Fly|Ride"] = 870.32, ["Neon"] = 3031.26, ["Neon|Ride"] = 8659.68, ["Neon|Fly|Ride"] = 2467.4, ["Mega|Fly|Ride"] = 8268.75}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 249.25, ["Fly"] = 365.93, ["Ride"] = 288.75, ["Fly|Ride"] = 349.4, ["Neon"] = 1588.17, ["Neon|Ride"] = 1731.07, ["Neon|Fly|Ride"] = 1730, ["Mega"] = 10825.88, ["Mega|Ride"] = 5904.67, ["Mega|Fly|Ride"] = 5369.65}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 104.9, ["Fly"] = 128.87, ["Ride"] = 118.02, ["Fly|Ride"] = 157.44, ["Neon"] = 539.81, ["Neon|Ride"] = 473.48, ["Neon|Fly|Ride"] = 525, ["Mega"] = 1575, ["Mega|Ride"] = 1775.46, ["Mega|Fly|Ride"] = 1875.05}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 208.3, ["Fly"] = 255.5, ["Ride"] = 218.03, ["Fly|Ride"] = 216.57, ["Neon|Ride"] = 1148.93, ["Neon|Fly|Ride"] = 978.43, ["Mega"] = 10825.88, ["Mega|Fly|Ride"] = 4102.35}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 20.57, ["Fly"] = 36.83, ["Ride"] = 31.61, ["Fly|Ride"] = 52.5, ["Neon"] = 170.63, ["Neon|Ride"] = 129.92, ["Neon|Fly|Ride"] = 203.13, ["Mega|Ride"] = 769.73}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 210, ["Ride"] = 323.67, ["Fly|Ride"] = 428.72, ["Neon"] = 1584.98, ["Neon|Ride"] = 942.38, ["Neon|Fly|Ride"] = 892.5, ["Mega"] = 4285.77, ["Mega|Fly|Ride"] = 3536.82}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 97.98, ["Ride"] = 98.51, ["Fly|Ride"] = 131.24, ["Neon|Ride"] = 1641.68, ["Neon|Fly|Ride"] = 518.57, ["Mega|Ride"] = 2310.55, ["Mega|Fly|Ride"] = 1821.75}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 2520, ["Ride"] = 2377.75, ["Fly|Ride"] = 2296.87, ["Neon|Ride"] = 11482.11, ["Neon|Fly|Ride"] = 7867.18, ["Mega"] = 51964.24, ["Mega|Fly|Ride"] = 28869.38}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 13.12, ["Fly"] = 57.36, ["Ride"] = 36.74, ["Fly|Ride"] = 103.29, ["Neon"] = 63.89, ["Neon|Fly"] = 173.04, ["Neon|Ride"] = 87.93, ["Neon|Fly|Ride"] = 210.05, ["Mega"] = 312.38, ["Mega|Ride"] = 425.64, ["Mega|Fly|Ride"] = 458.06}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 33.57, ["Fly"] = 145.1, ["Ride"] = 72.19, ["Fly|Ride"] = 149.63, ["Neon"] = 163.87, ["Neon|Ride"] = 231.7, ["Neon|Fly|Ride"] = 420, ["Mega|Ride"] = 931.87, ["Mega|Fly|Ride"] = 945}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 105.82, ["Fly"] = 102.26, ["Ride"] = 91.23, ["Fly|Ride"] = 118.02, ["Neon|Ride"] = 500.17, ["Neon|Fly|Ride"] = 441.79, ["Mega|Fly|Ride"] = 1541.18}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 1311.19, ["Fly"] = 1641.68, ["Ride"] = 1073.63, ["Fly|Ride"] = 971.25, ["Neon|Ride"] = 5740.84, ["Neon|Fly|Ride"] = 3937.49, ["Mega"] = 43303.52, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 436.4, ["Fly"] = 863.91, ["Ride"] = 821.7, ["Fly|Ride"] = 820.5, ["Mega"] = 11367.19}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 77.43, ["Fly"] = 155.92, ["Ride"] = 77.97, ["Fly|Ride"] = 224.44, ["Neon"] = 477.43, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 512.91, ["Mega"] = 5774.54, ["Mega|Ride"] = 1886.97, ["Mega|Fly|Ride"] = 1774.38}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.25, ["Fly"] = 32.82, ["Ride"] = 24.95, ["Fly|Ride"] = 63.91, ["Neon"] = 68.03, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 148.32, ["Mega"] = 656.25, ["Mega|Ride"] = 832.26}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 39.36, ["Fly"] = 62.82, ["Ride"] = 53.82, ["Fly|Ride"] = 90.95, ["Neon"] = 214.07, ["Neon|Ride"] = 285.79, ["Neon|Fly|Ride"] = 339.94, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 698.96, ["Fly"] = 1132.2, ["Ride"] = 721.87, ["Fly|Ride"] = 820.98, ["Neon"] = 2705.4, ["Neon|Ride"] = 2887.5, ["Neon|Fly|Ride"] = 2231.24, ["Mega|Fly|Ride"] = 8531.25}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 750.74}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 5446.88, ["Ride"] = 5906.25, ["Fly|Ride"] = 5381.25, ["Neon"] = 28875, ["Neon|Ride"] = 31024.35, ["Neon|Fly|Ride"] = 27565.13, ["Mega|Fly|Ride"] = 108271.7}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 242.82, ["Fly"] = 494.81, ["Ride"] = 361.59, ["Fly|Ride"] = 428.1, ["Neon"] = 1732.36, ["Neon|Fly|Ride"] = 2165.44, ["Mega"] = 6496.31, ["Mega|Fly|Ride"] = 6496.31}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 72.12, ["Ride"] = 144.38, ["Fly|Ride"] = 190.32, ["Neon"] = 1011.15, ["Neon|Ride"] = 649.49, ["Neon|Fly|Ride"] = 1050}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 15.74, ["Fly"] = 102.37, ["Ride"] = 32.32, ["Fly|Ride"] = 98.44, ["Neon"] = 218.71, ["Neon|Ride"] = 216.57, ["Neon|Fly|Ride"] = 245.44, ["Mega"] = 722.11, ["Mega|Ride"] = 865.98, ["Mega|Fly|Ride"] = 723.7}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 17.07, ["Fly"] = 32.82, ["Ride"] = 24.3, ["Fly|Ride"] = 49.82, ["Neon"] = 145.09, ["Neon|Ride"] = 328.59, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 1312.5, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 606.26}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 17.57, ["Fly"] = 116.81, ["Ride"] = 40.91, ["Fly|Ride"] = 109.15, ["Neon"] = 72.55, ["Neon|Ride"] = 124.66, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 645.91, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 729.75}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.15, ["Fly"] = 36.83, ["Ride"] = 19.69, ["Fly|Ride"] = 57.84, ["Neon"] = 26.25, ["Neon|Ride"] = 56.61, ["Neon|Fly|Ride"] = 142.51, ["Mega"] = 681.82, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 316.84}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 23.63, ["Ride"] = 51.18, ["Fly|Ride"] = 145.06, ["Neon"] = 115.5, ["Neon|Fly"] = 865.98, ["Neon|Ride"] = 164.7, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 533.29, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 866.09}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 542.18, ["Fly"] = 525, ["Ride"] = 538.13, ["Fly|Ride"] = 646.67, ["Neon"] = 1645.55, ["Neon|Ride"] = 1641.02, ["Neon|Fly|Ride"] = 1574.69, ["Mega"] = 9187.5, ["Mega|Fly|Ride"] = 5250}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.15, ["Fly"] = 19.69, ["Ride"] = 14.44, ["Fly|Ride"] = 36.11, ["Neon"] = 20.78, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 170.63, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 36.61, ["Fly"] = 112.32, ["Ride"] = 65.63, ["Fly|Ride"] = 119.44, ["Neon"] = 199.5, ["Neon|Fly"] = 430.71, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 498.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 551.24}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 748.13, ["Ride"] = 748.13, ["Fly|Ride"] = 824.25, ["Neon|Ride"] = 2743.62, ["Neon|Fly|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 3752.34}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 30.16, ["Fly"] = 70.86, ["Ride"] = 42.84, ["Fly|Ride"] = 89.71, ["Neon"] = 280.88, ["Neon|Ride"] = 177.19, ["Neon|Fly|Ride"] = 257.15, ["Mega"] = 1230.65, ["Mega|Ride"] = 927.94, ["Mega|Fly|Ride"] = 885.93}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 328.13, ["Ride"] = 328.13, ["Fly|Ride"] = 341.25, ["Neon|Fly|Ride"] = 1531.69, ["Mega|Fly|Ride"] = 5042.81}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 249.38, ["Fly"] = 302.97, ["Ride"] = 249.38, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 988.83, ["Mega"] = 5118.75, ["Mega|Fly|Ride"] = 5477.91}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 656.25, ["Ride"] = 737.63, ["Fly|Ride"] = 721.87, ["Neon"] = 3030.9, ["Neon|Ride"] = 3782.58, ["Neon|Fly|Ride"] = 2572.5, ["Mega|Fly|Ride"] = 9842.44}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 18.19, ["Ride"] = 36.44, ["Fly|Ride"] = 107.47, ["Neon"] = 65.63, ["Neon|Fly"] = 295.36, ["Neon|Ride"] = 118.12, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 354.38, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 451.5}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3622.49, ["Fly"] = 3590.9, ["Ride"] = 3411.19, ["Fly|Ride"] = 3149.99, ["Neon|Fly|Ride"] = 8227.69, ["Mega|Fly|Ride"] = 21510.57}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 131.25, ["Fly"] = 145.09, ["Ride"] = 145.09, ["Fly|Ride"] = 183.75, ["Neon"] = 550.97, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 626.07, ["Mega|Fly|Ride"] = 2559.37}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.63, ["Fly"] = 22.4, ["Ride"] = 19.69, ["Fly|Ride"] = 53.72, ["Neon"] = 23, ["Neon|Fly"] = 43.25, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 85.31, ["Mega"] = 160.23, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 294.23, ["Mega|Fly|Ride"] = 346.44}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.15, ["Ride"] = 26.17, ["Fly|Ride"] = 68.22, ["Neon"] = 20.61, ["Neon|Fly"] = 120.62, ["Neon|Ride"] = 52.48, ["Neon|Fly|Ride"] = 144.32, ["Mega"] = 188.4, ["Mega|Ride"] = 418.99, ["Mega|Fly|Ride"] = 404.45}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 52.5, ["Fly"] = 86.38, ["Ride"] = 56.39, ["Fly|Ride"] = 59.07, ["Neon|Fly|Ride"] = 276.94, ["Mega|Fly|Ride"] = 1255.83}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 787.49, ["Fly"] = 1180.91, ["Ride"] = 774.38, ["Fly|Ride"] = 970.9, ["Neon|Ride"] = 11481.67, ["Neon|Fly|Ride"] = 4167.97}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["Fly|Ride"] = 14106}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 21.63, ["Fly"] = 26.21, ["Ride"] = 26.8, ["Fly|Ride"] = 44.13, ["Neon"] = 287.99, ["Neon|Ride"] = 160.23, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 2520, ["Mega|Ride"] = 869.69, ["Mega|Fly|Ride"] = 811.12}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 17.18, ["Fly"] = 40.69, ["Ride"] = 31.5, ["Fly|Ride"] = 72.19, ["Neon"] = 104.63, ["Neon|Fly"] = 105, ["Neon|Ride"] = 108.27, ["Neon|Fly|Ride"] = 136.49, ["Mega"] = 682.45, ["Mega|Ride"] = 528.94, ["Mega|Fly|Ride"] = 501.38}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 106.03, ["Ride"] = 105, ["Fly|Ride"] = 137.82, ["Neon"] = 485.63, ["Neon|Ride"] = 477.87, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1607.81}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 223.02, ["Fly"] = 433.11, ["Ride"] = 237.15, ["Fly|Ride"] = 289.06, ["Neon"] = 1125.91, ["Neon|Ride"] = 934.76, ["Neon|Fly|Ride"] = 1064.34, ["Mega"] = 10824.59, ["Mega|Ride"] = 4176.78, ["Mega|Fly|Ride"] = 3127.69}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.81, ["Ride"] = 31.38, ["Fly|Ride"] = 72.19, ["Neon"] = 23.61, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 64.31, ["Mega"] = 179.73, ["Mega|Fly"] = 241.44, ["Mega|Ride"] = 164.26, ["Mega|Fly|Ride"] = 354.02}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 181.79, ["Fly"] = 286.55, ["Ride"] = 234.94, ["Fly|Ride"] = 319.38, ["Neon"] = 590.63, ["Neon|Ride"] = 589.32, ["Neon|Fly|Ride"] = 813.75, ["Mega"] = 3610.46, ["Mega|Fly|Ride"] = 3996.93}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.63, ["Fly"] = 33.12, ["Ride"] = 19.48, ["Fly|Ride"] = 49.88, ["Neon"] = 21.95, ["Neon|Fly"] = 43.33, ["Neon|Ride"] = 33.92, ["Neon|Fly|Ride"] = 82.72, ["Mega"] = 212.2, ["Mega|Fly"] = 289.04, ["Mega|Ride"] = 219.19, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 389.74, ["Ride"] = 397.32, ["Fly|Ride"] = 367.4, ["Neon|Ride"] = 1436.25, ["Neon|Fly|Ride"] = 1246.88, ["Mega"] = 10827.17, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 11.33, ["Fly"] = 104.99, ["Ride"] = 29.34, ["Fly|Ride"] = 68.25, ["Neon"] = 91.88, ["Neon|Fly"] = 312.61, ["Neon|Ride"] = 72.55, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 578.19, ["Mega|Ride"] = 445.99, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Ride"] = 26.22, ["Neon"] = 12.68, ["Neon|Fly"] = 170.46, ["Neon|Ride"] = 51.18, ["Neon|Fly|Ride"] = 170.08, ["Mega"] = 91.86, ["Mega|Ride"] = 328.44, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.82, ["Mega"] = 19.99, ["Mega|Ride"] = 133.88, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 6.57, ["Ride"] = 30.19, ["Fly|Ride"] = 86.62, ["Neon"] = 8.31, ["Neon|Ride"] = 43.08, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 60.38, ["Mega|Fly"] = 72.55, ["Mega|Ride"] = 69.67, ["Mega|Fly|Ride"] = 363.57}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 77.25, ["Fly"] = 212.63, ["Ride"] = 104.61, ["Fly|Ride"] = 231.69, ["Neon"] = 339.93, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1236.38}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 42.45, ["Ride"] = 16.41, ["Fly|Ride"] = 67.71, ["Neon"] = 5.25, ["Neon|Ride"] = 33.23, ["Neon|Fly|Ride"] = 70.77, ["Mega"] = 90.57, ["Mega|Ride"] = 165.38, ["Mega|Fly|Ride"] = 263.26}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 15.72, ["Ride"] = 101.74, ["Neon"] = 82.86, ["Neon|Fly"] = 377.67, ["Neon|Ride"] = 289.06, ["Mega"] = 420, ["Mega|Fly|Ride"] = 735.09}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.6, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 144.08, ["Mega"] = 16.24, ["Mega|Fly"] = 62.82, ["Mega|Ride"] = 48.57, ["Mega|Fly|Ride"] = 257.66}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 88.23, ["Ride"] = 16.14, ["Fly|Ride"] = 196.88, ["Neon"] = 2.1, ["Neon|Fly"] = 24.92, ["Neon|Ride"] = 15.66, ["Neon|Fly|Ride"] = 42.63, ["Mega"] = 11.81, ["Mega|Fly"] = 41.15, ["Mega|Ride"] = 23.82, ["Mega|Fly|Ride"] = 63.02}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 21.55, ["Ride"] = 15.73, ["Fly|Ride"] = 37.9, ["Neon"] = 2.47, ["Neon|Fly"] = 29.25, ["Neon|Ride"] = 17.34, ["Neon|Fly|Ride"] = 53.82, ["Mega"] = 19.69, ["Mega|Fly"] = 164.84, ["Mega|Ride"] = 41.85, ["Mega|Fly|Ride"] = 83}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 3.76, ["Mega"] = 24.92, ["Mega|Fly|Ride"] = 244.69}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 117.95, ["Ride"] = 15.75, ["Fly|Ride"] = 45.48, ["Neon"] = 7.88, ["Neon|Fly"] = 100.92, ["Neon|Ride"] = 27.89, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 39.16, ["Mega|Fly"] = 71.76, ["Mega|Ride"] = 43.32, ["Mega|Fly|Ride"] = 85.31}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Ride"] = 72.55, ["Neon"] = 3.84, ["Neon|Fly"] = 36.74, ["Neon|Ride"] = 86.4, ["Mega"] = 14.09, ["Mega|Ride"] = 107.2, ["Mega|Fly|Ride"] = 145.68}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 13.11, ["Fly"] = 54.53, ["Fly|Ride"] = 163.99, ["Neon"] = 57.66, ["Neon|Ride"] = 93.12, ["Neon|Fly|Ride"] = 184.28, ["Mega"] = 247.95, ["Mega|Ride"] = 242.71, ["Mega|Fly|Ride"] = 362.97}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 82.78, ["Neon"] = 2.1, ["Neon|Ride"] = 24.92, ["Neon|Fly|Ride"] = 205.73, ["Mega"] = 11.75, ["Mega|Fly"] = 150.09, ["Mega|Ride"] = 63.89, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.6, ["Fly|Ride"] = 87.94, ["Neon"] = 26.25, ["Mega"] = 121.87, ["Mega|Fly"] = 315, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 26.24, ["Neon"] = 23.28, ["Neon|Ride"] = 65.63, ["Mega"] = 136.33, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Fly"] = 145.09, ["Ride"] = 32.82, ["Neon"] = 3.45, ["Neon|Ride"] = 27.97, ["Neon|Fly|Ride"] = 145.06, ["Mega"] = 16.89, ["Mega|Ride"] = 43.2, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.72, ["Ride"] = 15.41, ["Fly|Ride"] = 31.65, ["Neon"] = 2.1, ["Neon|Fly"] = 20.47, ["Neon|Ride"] = 15.69, ["Neon|Fly|Ride"] = 35.44, ["Mega"] = 11.68, ["Mega|Fly"] = 32.97, ["Mega|Ride"] = 21.28, ["Mega|Fly|Ride"] = 51.98}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 54.28, ["Fly|Ride"] = 118.12, ["Neon"] = 52.48, ["Neon|Ride"] = 145.1, ["Neon|Fly|Ride"] = 722.19, ["Mega"] = 144.38, ["Mega|Ride"] = 241.5, ["Mega|Fly|Ride"] = 432.99}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 44, ["Fly|Ride"] = 58.48, ["Neon"] = 7.32, ["Neon|Ride"] = 29.25, ["Neon|Fly|Ride"] = 105, ["Mega"] = 23, ["Mega|Ride"] = 44.62, ["Mega|Fly|Ride"] = 94.5}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 7.34, ["Neon"] = 20.9, ["Neon|Ride"] = 195.11, ["Mega"] = 105, ["Mega|Ride"] = 144.27, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 85.58, ["Ride"] = 34.53, ["Fly|Ride"] = 73.82, ["Neon"] = 23.63, ["Neon|Ride"] = 108.27, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 131.25, ["Mega|Ride"] = 111.57, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 13.51, ["Ride"] = 15.21, ["Fly|Ride"] = 28.25, ["Neon"] = 2.1, ["Neon|Fly"] = 15.74, ["Neon|Ride"] = 11.82, ["Neon|Fly|Ride"] = 30.24, ["Mega"] = 15.2, ["Mega|Fly"] = 34.13, ["Mega|Ride"] = 22.09, ["Mega|Fly|Ride"] = 108.26}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 45.47, ["Ride"] = 27.44, ["Fly|Ride"] = 144.38, ["Neon"] = 14.44, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 129.72, ["Mega|Ride"] = 164.92, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 10.49, ["Fly"] = 118.13, ["Ride"] = 144.67, ["Fly|Ride"] = 58.48, ["Neon"] = 104.99, ["Neon|Ride"] = 86.62, ["Neon|Fly|Ride"] = 188.4, ["Mega"] = 288.75, ["Mega|Ride"] = 303.58, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 58.17, ["Ride"] = 13.13, ["Fly|Ride"] = 43.28, ["Neon"] = 2.63, ["Neon|Fly"] = 21.68, ["Neon|Ride"] = 15.06, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 21.68, ["Mega|Fly"] = 37.9, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 180.78, ["Ride"] = 72.19, ["Neon"] = 10.27, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 52.5, ["Mega|Fly"] = 164.92, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 216.53}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 131.25, ["Neon"] = 7.25, ["Neon|Fly"] = 115.86, ["Neon|Ride"] = 43.33, ["Mega"] = 32.82, ["Mega|Ride"] = 114.76, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Ride"] = 27.2, ["Fly|Ride"] = 48.56, ["Neon"] = 2.1, ["Neon|Ride"] = 35.27, ["Neon|Fly|Ride"] = 129.92, ["Mega"] = 12.31, ["Mega|Fly"] = 253.82, ["Mega|Ride"] = 50.89, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 23.83, ["Ride"] = 19.35, ["Fly|Ride"] = 55.46, ["Neon"] = 7.21, ["Neon|Fly"] = 58.48, ["Neon|Ride"] = 44.65, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 105.8, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 199.21}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 28.79, ["Neon"] = 3.92, ["Neon|Ride"] = 71.09, ["Neon|Fly|Ride"] = 289.06, ["Mega"] = 47.87, ["Mega|Fly"] = 216.54, ["Mega|Ride"] = 117.35, ["Mega|Fly|Ride"] = 274.32}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 28.62, ["Ride"] = 19.5, ["Fly|Ride"] = 39.9, ["Neon"] = 7.76, ["Neon|Fly"] = 76.3, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 82.69, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 274.99}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 5.21, ["Ride"] = 35.43, ["Neon"] = 40.68, ["Neon|Fly"] = 188.88, ["Neon|Fly|Ride"] = 324.83, ["Mega"] = 110.25, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 649.59}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 26.03, ["Ride"] = 21.51, ["Fly|Ride"] = 33.38, ["Neon"] = 8.87, ["Neon|Fly"] = 72.56, ["Neon|Ride"] = 72.33, ["Neon|Fly|Ride"] = 66.45, ["Mega"] = 107.63, ["Mega|Fly"] = 420, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 144.37}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 6.5, ["Fly"] = 20.79, ["Ride"] = 18.25, ["Fly|Ride"] = 72.19, ["Neon"] = 19.45, ["Neon|Fly"] = 29.32, ["Neon|Ride"] = 22.89, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 157.5, ["Mega|Fly"] = 432.99, ["Mega|Ride"] = 115.86, ["Mega|Fly|Ride"] = 289.06}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.52, ["Fly"] = 114.78, ["Fly|Ride"] = 145.06, ["Neon"] = 43.33, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 257.28, ["Mega|Ride"] = 406.88}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 15.15, ["Ride"] = 131.25, ["Neon"] = 202.11, ["Neon|Ride"] = 212.2, ["Neon|Fly|Ride"] = 295.23, ["Mega|Ride"] = 760.37, ["Mega|Fly|Ride"] = 750.75}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.1, ["Neon"] = 57.31, ["Mega"] = 200.43, ["Mega|Ride"] = 289.06, ["Mega|Fly|Ride"] = 410.89}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 5.23, ["Ride"] = 51.19, ["Fly|Ride"] = 131.25, ["Neon"] = 69.57, ["Neon|Ride"] = 64.97, ["Neon|Fly|Ride"] = 202.43, ["Mega"] = 236.25, ["Mega|Ride"] = 334.14, ["Mega|Fly|Ride"] = 450.84}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Mega"] = 17.06, ["Mega|Fly"] = 215.45, ["Mega|Ride"] = 58.48, ["Mega|Fly|Ride"] = 257.64}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 52.48}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 5.51, ["Fly"] = 43.66, ["Ride"] = 28.07, ["Fly|Ride"] = 43.08, ["Neon"] = 31.5, ["Neon|Fly"] = 64.97, ["Neon|Ride"] = 41.27, ["Neon|Fly|Ride"] = 90.55, ["Mega"] = 261.19, ["Mega|Ride"] = 208.94, ["Mega|Fly|Ride"] = 271.41}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 16.25, ["Neon"] = 3.03, ["Neon|Fly"] = 52.81, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 145.1, ["Mega"] = 32.49, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.41, ["Neon|Ride"] = 32.99, ["Neon|Fly|Ride"] = 74.43, ["Mega"] = 31.47, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 134.27}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 49.03, ["Ride"] = 16.15, ["Fly|Ride"] = 49.09, ["Neon"] = 10.5, ["Neon|Ride"] = 24.09, ["Neon|Fly|Ride"] = 72.55, ["Mega"] = 272.46, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 230.04}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 6.95, ["Ride"] = 39.26, ["Neon"] = 57.65, ["Neon|Ride"] = 205.46, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 111.57, ["Mega|Ride"] = 353.07, ["Mega|Fly|Ride"] = 349.69}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 47.24, ["Neon|Fly|Ride"] = 159.79, ["Mega"] = 17.75, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 56.43}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 28.17, ["Ride"] = 17.2, ["Fly|Ride"] = 90.96, ["Neon"] = 6.55, ["Neon|Fly"] = 115.21, ["Neon|Ride"] = 20.87, ["Neon|Fly|Ride"] = 98.42, ["Mega"] = 32.82, ["Mega|Fly"] = 164.84, ["Mega|Ride"] = 57.22, ["Mega|Fly|Ride"] = 132.57}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 20.48, ["Ride"] = 19.35, ["Fly|Ride"] = 53.8, ["Neon"] = 6.18, ["Neon|Fly"] = 37.85, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 64.68, ["Mega"] = 137.51, ["Mega|Fly"] = 145.06, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 138.59}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 5.1, ["Fly"] = 91.88, ["Ride"] = 196.88, ["Neon"] = 31.49, ["Neon|Ride"] = 60.64, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 133.18, ["Mega|Ride"] = 181.9}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.56, ["Neon|Ride"] = 108.27, ["Neon|Fly|Ride"] = 202.46, ["Mega"] = 24.62, ["Mega|Fly"] = 74.1, ["Mega|Ride"] = 46.1, ["Mega|Fly|Ride"] = 159.13}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.92, ["Ride"] = 24, ["Neon"] = 3.67, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 25.81, ["Neon|Fly|Ride"] = 67.69, ["Mega"] = 16.88, ["Mega|Fly"] = 72.07, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 89.25}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 77.44, ["Neon"] = 2.61, ["Neon|Fly"] = 82.43, ["Mega"] = 39.37, ["Mega|Ride"] = 182.07, ["Mega|Fly|Ride"] = 216.54}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.82, ["Neon|Fly|Ride"] = 420, ["Mega"] = 27.2, ["Mega|Ride"] = 292.69, ["Mega|Fly|Ride"] = 202.46}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.23, ["Ride"] = 19.24, ["Fly|Ride"] = 69.56, ["Neon"] = 6.35, ["Neon|Fly"] = 326.27, ["Neon|Ride"] = 21.94, ["Neon|Fly|Ride"] = 48.91, ["Mega"] = 28.67, ["Mega|Ride"] = 42.4, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 7.88, ["Ride"] = 78.75, ["Neon"] = 73.5, ["Neon|Ride"] = 192.74, ["Mega"] = 391.13, ["Mega|Ride"] = 527.24, ["Mega|Fly|Ride"] = 648.48}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 58.47, ["Neon"] = 39.37, ["Neon|Ride"] = 157.5, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.43, ["Ride"] = 23.63, ["Fly|Ride"] = 131.25, ["Neon"] = 25.8, ["Neon|Ride"] = 144.67, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 170.63, ["Mega|Ride"] = 182.44, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 13.78, ["Ride"] = 12.96, ["Fly|Ride"] = 19.69, ["Neon"] = 2.1, ["Neon|Fly"] = 15.75, ["Neon|Ride"] = 14.43, ["Neon|Fly|Ride"] = 26.8, ["Mega"] = 12.87, ["Mega|Fly"] = 23.28, ["Mega|Ride"] = 21, ["Mega|Fly|Ride"] = 46.86}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Ride"] = 60.64, ["Neon"] = 12.45, ["Neon|Ride"] = 31.82, ["Neon|Fly|Ride"] = 722.19, ["Mega"] = 42, ["Mega|Ride"] = 118.13}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 31.39, ["Neon"] = 2.1, ["Neon|Fly"] = 32.36, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 73.82, ["Mega"] = 15.71, ["Mega|Fly"] = 145.06, ["Mega|Ride"] = 34.13, ["Mega|Fly|Ride"] = 289.06}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 5.24, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 129.22, ["Mega"] = 32, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 433.06}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 223.13, ["Ride"] = 18.38, ["Fly|Ride"] = 48.9, ["Neon"] = 6.48, ["Neon|Fly"] = 64.75, ["Neon|Ride"] = 28.07, ["Neon|Fly|Ride"] = 93.12, ["Mega"] = 149.41, ["Mega|Ride"] = 130.74, ["Mega|Fly|Ride"] = 275.6}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 196.88, ["Ride"] = 252, ["Fly|Ride"] = 289.06, ["Neon|Ride"] = 813.75, ["Mega"] = 8660.72, ["Mega|Fly|Ride"] = 3550.91}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 8.65, ["Neon|Fly"] = 58.17, ["Neon|Ride"] = 64.32, ["Mega"] = 65.63, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 657.17}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.94, ["Fly"] = 103.69, ["Ride"] = 40.2, ["Fly|Ride"] = 65.62, ["Neon"] = 22.31, ["Neon|Ride"] = 135.18, ["Neon|Fly|Ride"] = 173.21, ["Mega"] = 400.32, ["Mega|Ride"] = 418.99, ["Mega|Fly|Ride"] = 402.73}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 19.66, ["Ride"] = 15.75, ["Fly|Ride"] = 36.75, ["Neon"] = 5.52, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 49.88, ["Mega|Ride"] = 107.2, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 72.56, ["Ride"] = 18.38, ["Fly|Ride"] = 142.61, ["Neon"] = 8.68, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 115.86, ["Mega"] = 101.07, ["Mega|Ride"] = 178.5}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 4.11, ["Fly"] = 20.87, ["Ride"] = 16.23, ["Fly|Ride"] = 39.37, ["Neon"] = 32.71, ["Neon|Fly"] = 101.25, ["Neon|Ride"] = 34.48, ["Neon|Fly|Ride"] = 86.52, ["Mega|Ride"] = 962.43, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 4.08, ["Ride"] = 26.25, ["Fly|Ride"] = 86.63, ["Neon"] = 50.09, ["Neon|Fly|Ride"] = 433.06, ["Mega"] = 168.94, ["Mega|Ride"] = 389.74, ["Mega|Fly|Ride"] = 347.82}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 22.3, ["Ride"] = 16.25, ["Fly|Ride"] = 38.97, ["Neon"] = 54.14, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 77.65, ["Mega"] = 258.76, ["Mega|Ride"] = 375.67, ["Mega|Fly|Ride"] = 262.44}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 64.32, ["Fly"] = 182.07, ["Ride"] = 89.25, ["Fly|Ride"] = 142.86, ["Neon"] = 328.13, ["Neon|Fly"] = 450.19, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 361.91, ["Mega|Ride"] = 1877.24, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 221.82, ["Fly"] = 289.06, ["Ride"] = 223.12, ["Fly|Ride"] = 287.44, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1299.12, ["Mega"] = 12991.07, ["Mega|Fly|Ride"] = 3753.35}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 66.13, ["Fly"] = 101.78, ["Ride"] = 68.95, ["Fly|Ride"] = 99.03, ["Neon"] = 352.91, ["Neon|Fly"] = 367.02, ["Neon|Ride"] = 309.74, ["Neon|Fly|Ride"] = 332.38, ["Mega"] = 2018.43, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 3.82, ["Fly"] = 289.06, ["Ride"] = 28.17, ["Fly|Ride"] = 65.62, ["Neon"] = 25.98, ["Neon|Fly"] = 72.55, ["Neon|Ride"] = 131.25, ["Mega"] = 287.44, ["Mega|Ride"] = 209.34, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 13.41, ["Fly"] = 78.75, ["Ride"] = 26.25, ["Fly|Ride"] = 105, ["Neon"] = 85.32, ["Neon|Ride"] = 145.09, ["Neon|Fly|Ride"] = 202.19, ["Mega"] = 314.98, ["Mega|Ride"] = 397.56, ["Mega|Fly|Ride"] = 379.2}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 39.32, ["Ride"] = 17.84, ["Fly|Ride"] = 99.74, ["Neon"] = 3.94, ["Neon|Fly"] = 57.44, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 54.57, ["Mega"] = 42.96, ["Mega|Fly"] = 150.15, ["Mega|Ride"] = 86.62, ["Mega|Fly|Ride"] = 559.86}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 11.82, ["Fly"] = 39.38, ["Ride"] = 34.13, ["Fly|Ride"] = 82.29, ["Neon"] = 124.69, ["Neon|Fly"] = 289.06, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 1837.5, ["Mega|Ride"] = 649.49, ["Mega|Fly|Ride"] = 619.98}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.75, ["Fly|Ride"] = 43.44, ["Neon"] = 21, ["Neon|Fly"] = 52.91, ["Neon|Ride"] = 29.52, ["Neon|Fly|Ride"] = 98.42, ["Mega"] = 144.68, ["Mega|Ride"] = 91.77, ["Mega|Fly|Ride"] = 319.38}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 5.24, ["Ride"] = 23.63, ["Fly|Ride"] = 124.51, ["Neon"] = 39.5, ["Neon|Ride"] = 40.73, ["Mega"] = 207.37, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 337.84}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 27.99, ["Ride"] = 19.39, ["Neon"] = 2.1, ["Neon|Ride"] = 17.25, ["Neon|Fly|Ride"] = 58.24, ["Mega"] = 14.44, ["Mega|Ride"] = 30.33, ["Mega|Fly|Ride"] = 72.19}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.09, ["Ride"] = 19.14, ["Fly|Ride"] = 44.63, ["Neon"] = 12.5, ["Neon|Fly"] = 108.27, ["Neon|Ride"] = 34.65, ["Neon|Fly|Ride"] = 147, ["Mega"] = 78.74, ["Mega|Ride"] = 114.78, ["Mega|Fly|Ride"] = 153.75}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 3, ["Fly"] = 72.55, ["Ride"] = 22.29, ["Fly|Ride"] = 83.83, ["Neon"] = 17.07, ["Neon|Fly"] = 98.47, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 144.38, ["Mega|Ride"] = 164.85, ["Mega|Fly|Ride"] = 268.5}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 109.19, ["Fly"] = 149.63, ["Ride"] = 154.87, ["Fly|Ride"] = 179.82, ["Neon"] = 430.39, ["Neon|Ride"] = 472.49, ["Neon|Fly|Ride"] = 509.24, ["Mega"] = 2461.27, ["Mega|Fly|Ride"] = 2485.64}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 12.97, ["Fly"] = 115.86, ["Ride"] = 52.5, ["Fly|Ride"] = 183.75, ["Neon"] = 41.99, ["Neon|Ride"] = 96.48, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 289.06, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 430.88}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 16, ["Fly|Ride"] = 51.48, ["Neon"] = 22.08, ["Neon|Ride"] = 62.91, ["Neon|Fly|Ride"] = 90.99, ["Mega"] = 274.99, ["Mega|Fly|Ride"] = 328.12}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 24.17, ["Ride"] = 39.38, ["Fly|Ride"] = 170.63, ["Neon"] = 99.3, ["Neon|Ride"] = 150.94, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 489.35, ["Mega|Fly"] = 866.09, ["Mega|Ride"] = 540.75, ["Mega|Fly|Ride"] = 578.11}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 6.29}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.62, ["Fly"] = 31.5, ["Ride"] = 32.82, ["Fly|Ride"] = 113.18, ["Neon"] = 72.19, ["Neon|Ride"] = 145.06, ["Neon|Fly|Ride"] = 233.85, ["Mega"] = 649.59, ["Mega|Ride"] = 635.58, ["Mega|Fly|Ride"] = 501.93}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 18.37, ["Fly"] = 25.99, ["Ride"] = 31.5, ["Fly|Ride"] = 49.14, ["Neon"] = 407.12, ["Neon|Fly"] = 21651.76, ["Neon|Ride"] = 136.4, ["Neon|Fly|Ride"] = 156.85, ["Mega"] = 1397.8, ["Mega|Fly|Ride"] = 580.64}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 35.59, ["Neon"] = 3.76, ["Neon|Ride"] = 49.55, ["Neon|Fly|Ride"] = 137.51, ["Mega"] = 21.84, ["Mega|Fly"] = 188.36, ["Mega|Ride"] = 88.33, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 5.13, ["Fly"] = 26.25, ["Ride"] = 24.62, ["Fly|Ride"] = 91.88, ["Neon"] = 64.96, ["Mega"] = 287.99, ["Mega|Fly"] = 411.04, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 410.31}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 28.97, ["Ride"] = 18.38, ["Fly|Ride"] = 38.98, ["Neon"] = 13.83, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 30.86, ["Neon|Fly|Ride"] = 70.63, ["Mega"] = 95.45, ["Mega|Ride"] = 140.01, ["Mega|Fly|Ride"] = 234.93}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Fly|Ride"] = 118.13, ["Neon"] = 5.2, ["Neon|Ride"] = 41.85, ["Mega"] = 145.09, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 229.69}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 24.93, ["Fly"] = 105, ["Ride"] = 64.32, ["Fly|Ride"] = 144.65, ["Neon"] = 140.44, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 609.51, ["Mega"] = 787.5, ["Mega|Ride"] = 689.07, ["Mega|Fly|Ride"] = 764.98}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 5.41, ["Ride"] = 60.37, ["Fly|Ride"] = 87.59, ["Neon"] = 95.82, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 183.75, ["Mega|Ride"] = 375.67}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 6.56, ["Fly"] = 23.83, ["Ride"] = 19.66, ["Fly|Ride"] = 46.29, ["Neon"] = 15.38, ["Neon|Fly"] = 86.62, ["Neon|Ride"] = 26.44, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 144.33, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 204.05}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 64.32, ["Fly"] = 145.01, ["Ride"] = 72.19, ["Neon"] = 347.04, ["Neon|Ride"] = 388.67, ["Neon|Fly|Ride"] = 675.29, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 1591.8}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 7.88, ["Fly"] = 48.06, ["Ride"] = 22.36, ["Fly|Ride"] = 58.47, ["Neon"] = 37.43, ["Neon|Ride"] = 51.4, ["Neon|Fly|Ride"] = 114.19, ["Mega"] = 204.75, ["Mega|Fly"] = 369.21, ["Mega|Ride"] = 228.74, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 81.38, ["Fly"] = 147.62, ["Ride"] = 122.07, ["Fly|Ride"] = 195.62, ["Neon"] = 236.24, ["Neon|Ride"] = 279.36, ["Neon|Fly|Ride"] = 439.69, ["Mega"] = 1198.44, ["Mega|Ride"] = 980.94, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 17.37, ["Ride"] = 69.21, ["Fly|Ride"] = 142.93, ["Neon"] = 67.55, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 210, ["Mega"] = 354.38, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 4.09, ["Fly"] = 65.63, ["Ride"] = 26.25, ["Fly|Ride"] = 72.43, ["Neon"] = 188.41, ["Neon|Ride"] = 156.24, ["Neon|Fly|Ride"] = 210, ["Mega"] = 649.49, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 18.11, ["Fly"] = 78.75, ["Ride"] = 55.12, ["Fly|Ride"] = 216.54, ["Neon"] = 79.96, ["Neon|Ride"] = 92.98, ["Neon|Fly|Ride"] = 282.19, ["Mega"] = 473.6, ["Mega|Ride"] = 388.24, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 6.09, ["Ride"] = 25.89, ["Fly|Ride"] = 128.63, ["Neon"] = 52.46, ["Neon|Ride"] = 57.62, ["Neon|Fly|Ride"] = 161.68, ["Mega"] = 249.38, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 196.88, ["Mega"] = 18.38}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 7.88, ["Ride"] = 143.07, ["Fly|Ride"] = 325.89, ["Neon"] = 49.87, ["Neon|Ride"] = 291.27, ["Mega"] = 223.88, ["Mega|Ride"] = 358.32, ["Mega|Fly|Ride"] = 1039.31}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 128.86, ["Ride"] = 29.25, ["Neon"] = 28.01, ["Neon|Fly"] = 116.94, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 255.29, ["Mega|Ride"] = 168, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 3.81, ["Ride"] = 32.81, ["Neon"] = 16.47, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 289.04, ["Mega"] = 187.69, ["Mega|Ride"] = 289.06, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 511.87, ["Fly"] = 687.73, ["Ride"] = 563.01, ["Fly|Ride"] = 582.74, ["Neon|Ride"] = 1771.88, ["Neon|Fly|Ride"] = 1522.5, ["Mega|Fly|Ride"] = 4830}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 5.81, ["Fly"] = 45.47, ["Ride"] = 23.68, ["Fly|Ride"] = 65.63, ["Neon"] = 50.9, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 202.46, ["Mega|Ride"] = 145.09, ["Mega|Fly|Ride"] = 361.59}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 8.61, ["Fly"] = 66.94, ["Ride"] = 20.79, ["Fly|Ride"] = 54.1, ["Neon"] = 101.78, ["Neon|Fly"] = 315, ["Neon|Ride"] = 97.12, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 331.88, ["Mega|Ride"] = 404.91, ["Mega|Fly|Ride"] = 446.03}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 7.33, ["Fly"] = 24.93, ["Ride"] = 28.17, ["Fly|Ride"] = 50.99, ["Neon"] = 29.25, ["Neon|Ride"] = 32.3, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 198.19, ["Mega|Ride"] = 163.48, ["Mega|Fly|Ride"] = 145.09}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 58.08, ["Ride"] = 23.61, ["Fly|Ride"] = 78.75, ["Neon"] = 7.34, ["Neon|Fly"] = 58.7, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 65.62, ["Mega|Ride"] = 102.36, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 29.25, ["Ride"] = 38.98, ["Fly|Ride"] = 52.5, ["Neon"] = 3.74, ["Neon|Ride"] = 32.33, ["Neon|Fly|Ride"] = 104.98, ["Mega"] = 21.83, ["Mega|Ride"] = 68.22, ["Mega|Fly|Ride"] = 269.27}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1573.69}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 5.92, ["Ride"] = 31.5, ["Fly|Ride"] = 118.13, ["Neon"] = 78.37, ["Neon|Ride"] = 98.26, ["Neon|Fly|Ride"] = 362.92, ["Mega"] = 315, ["Mega|Ride"] = 866.18, ["Mega|Fly|Ride"] = 597.19}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 19.66, ["Neon"] = 5.25, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 1011.15, ["Mega"] = 80.13, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 183.74}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 6.27, ["Fly"] = 335.14, ["Ride"] = 108.27, ["Fly|Ride"] = 145.06, ["Neon"] = 54.14, ["Neon|Ride"] = 93.19, ["Neon|Fly|Ride"] = 236.15, ["Mega"] = 236.25, ["Mega|Ride"] = 389.74, ["Mega|Fly|Ride"] = 433.06}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 349.13, ["Fly"] = 533.87, ["Ride"] = 400.32, ["Fly|Ride"] = 446.25, ["Neon|Ride"] = 1714.61, ["Neon|Fly|Ride"] = 1364.99, ["Mega"] = 8119.42, ["Mega|Fly|Ride"] = 6357.75}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 7.28, ["Fly"] = 196.88, ["Neon"] = 31.39, ["Neon|Ride"] = 72.44, ["Neon|Fly|Ride"] = 184.62, ["Mega"] = 359.43, ["Mega|Ride"] = 362.77, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Ride"] = 32.8, ["Fly|Ride"] = 118.12, ["Neon"] = 3.15, ["Neon|Ride"] = 31.45, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 29.24, ["Mega|Fly"] = 115.86, ["Mega|Ride"] = 72.05, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 56.26, ["Neon"] = 2.5, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 144.9, ["Mega"] = 29.23, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 216.54}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 26.23, ["Fly"] = 115.64, ["Ride"] = 111.57, ["Fly|Ride"] = 85.32, ["Neon"] = 162.42, ["Neon|Ride"] = 433.06, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 757.82, ["Mega|Ride"] = 755.66, ["Mega|Fly|Ride"] = 718.86}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 8.3, ["Ride"] = 78.73, ["Neon"] = 86.62, ["Neon|Ride"] = 271.71, ["Neon|Fly|Ride"] = 865.98, ["Mega"] = 1299.13, ["Mega|Ride"] = 485.63, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 7.34, ["Ride"] = 76.12, ["Neon"] = 105, ["Neon|Ride"] = 200.82, ["Mega"] = 730.72, ["Mega|Ride"] = 578.11, ["Mega|Fly|Ride"] = 1299.13}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 23.75, ["Ride"] = 56.37, ["Fly|Ride"] = 236.25, ["Neon"] = 97.44, ["Neon|Ride"] = 181.13, ["Neon|Fly|Ride"] = 241.5, ["Mega"] = 1680, ["Mega|Ride"] = 1732.36, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 419.99, ["Ride"] = 393.65, ["Fly|Ride"] = 682.5, ["Neon"] = 1069.69, ["Neon|Ride"] = 1065.23, ["Neon|Fly|Ride"] = 1224.57, ["Mega|Fly|Ride"] = 2756.25}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 14.42, ["Ride"] = 28.24, ["Fly|Ride"] = 230.11, ["Neon"] = 199.15, ["Neon|Ride"] = 274.99, ["Neon|Fly|Ride"] = 287.55, ["Mega|Ride"] = 547.98, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 5.34, ["Ride"] = 27.72, ["Fly|Ride"] = 127.32, ["Neon"] = 36.75, ["Neon|Ride"] = 105, ["Mega"] = 170.63, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1082.72}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 38.39, ["Ride"] = 145.09, ["Fly|Ride"] = 259.84, ["Neon"] = 180.8, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 623.53, ["Mega"] = 511.49, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 717.29}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.62, ["Ride"] = 72.19, ["Fly|Ride"] = 145.06, ["Neon"] = 10.39, ["Neon|Fly"] = 86.18, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 145.09, ["Mega"] = 35.44, ["Mega|Fly"] = 105, ["Mega|Ride"] = 133.88, ["Mega|Fly|Ride"] = 289.06}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 34.81, ["Ride"] = 85.32, ["Fly|Ride"] = 214.07, ["Neon"] = 262.5, ["Neon|Ride"] = 389.74, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1569.78, ["Mega|Ride"] = 1152.41, ["Mega|Fly|Ride"] = 1623.8}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 29.25, ["Neon"] = 11.64, ["Neon|Fly"] = 188.36, ["Neon|Ride"] = 72.55, ["Neon|Fly|Ride"] = 111.55, ["Mega"] = 78.75, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 197.68}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Ride"] = 18.19, ["Fly|Ride"] = 71.15, ["Neon"] = 4.2, ["Neon|Ride"] = 37.9, ["Neon|Fly|Ride"] = 145.09, ["Mega"] = 36.81, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 77.1, ["Mega|Fly|Ride"] = 129.84}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 26.23, ["Fly|Ride"] = 131.69, ["Neon"] = 14.16, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 151.38, ["Mega"] = 97.13, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 271.88}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 69.55, ["Fly"] = 105, ["Ride"] = 78.71, ["Fly|Ride"] = 164.85, ["Neon"] = 367.5, ["Neon|Ride"] = 366.85, ["Neon|Fly|Ride"] = 492.07, ["Mega|Ride"] = 1133.49, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 2.63, ["Neon"] = 18.36, ["Neon|Fly"] = 350.44, ["Neon|Ride"] = 43.33, ["Mega"] = 68.25, ["Mega|Fly"] = 289.04, ["Mega|Ride"] = 267.78, ["Mega|Fly|Ride"] = 347.65}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 29.25, ["Ride"] = 26.97, ["Fly|Ride"] = 131.25, ["Neon"] = 6.46, ["Neon|Ride"] = 82.48, ["Mega"] = 55.13, ["Mega|Fly"] = 210, ["Mega|Ride"] = 97.13, ["Mega|Fly|Ride"] = 255.88}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.36, ["Fly"] = 86.62, ["Ride"] = 32.82, ["Fly|Ride"] = 98.44, ["Neon"] = 32.82, ["Neon|Fly|Ride"] = 164.84, ["Mega"] = 427.23, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 7.69, ["Fly"] = 78.75, ["Ride"] = 48.05, ["Fly|Ride"] = 114.19, ["Neon"] = 34.67, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 202.49, ["Mega"] = 161.43, ["Mega|Ride"] = 229.69, ["Mega|Fly|Ride"] = 334.06}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 71.63, ["Neon"] = 5.2, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 105, ["Mega"] = 107.96, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.48, ["Fly|Ride"] = 62.86, ["Neon"] = 4.92, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 28.87, ["Neon|Fly|Ride"] = 108.26, ["Mega"] = 41.99, ["Mega|Ride"] = 101.78, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 4.2, ["Fly"] = 27.51, ["Ride"] = 23.56, ["Fly|Ride"] = 57.54, ["Neon"] = 14.43, ["Neon|Fly"] = 102.87, ["Neon|Ride"] = 43.33, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 105, ["Mega|Ride"] = 241.28, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 32.45, ["Fly"] = 72.55, ["Ride"] = 65.63, ["Fly|Ride"] = 60.38, ["Neon"] = 144.38, ["Neon|Ride"] = 244.83, ["Neon|Fly|Ride"] = 289.06, ["Mega"] = 498.75, ["Mega|Fly"] = 722.19, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 627.93}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 61.5, ["Ride"] = 101.88, ["Fly|Ride"] = 131.25, ["Neon"] = 374.07, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 431.96, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 1640.96, ["Mega|Ride"] = 1739.42, ["Mega|Fly|Ride"] = 1557.95}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Fly"] = 29.25, ["Ride"] = 19.55, ["Neon"] = 6.5, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 145.1, ["Mega"] = 31.71, ["Mega|Fly"] = 672, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 259.84}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 16.24, ["Ride"] = 14.11, ["Fly|Ride"] = 32.82, ["Neon"] = 4.96, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 22.7, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 38.72, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 49.87, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 3.09, ["Fly"] = 183.75, ["Ride"] = 38.03, ["Neon"] = 41.98, ["Neon|Ride"] = 160.12, ["Neon|Fly|Ride"] = 145.09, ["Mega"] = 554.3, ["Mega|Ride"] = 275.62, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 354.38, ["Ride"] = 656.92, ["Fly|Ride"] = 578.11, ["Neon"] = 4330.88, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 6163.5}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 23.52, ["Fly"] = 110.34, ["Ride"] = 57.73, ["Fly|Ride"] = 124.77, ["Neon"] = 249.38, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 258.05, ["Mega"] = 721.88, ["Mega|Fly|Ride"] = 1069.61}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Fly"] = 44.63, ["Ride"] = 24.94, ["Fly|Ride"] = 289.1, ["Neon"] = 8.47, ["Neon|Ride"] = 47.64, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 67.25, ["Mega|Ride"] = 142.86, ["Mega|Fly|Ride"] = 319.38}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 105, ["Ride"] = 62.99, ["Fly|Ride"] = 261.98, ["Neon"] = 43.43, ["Mega"] = 189}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 32.82, ["Fly"] = 168.91, ["Ride"] = 46.25, ["Fly|Ride"] = 51.68, ["Neon"] = 194.25, ["Neon|Ride"] = 261.19, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 2598.22, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 974.34}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 104.92, ["Ride"] = 144.15, ["Fly|Ride"] = 190.32, ["Neon"] = 427.53, ["Neon|Fly"] = 1155.28, ["Neon|Ride"] = 535.89, ["Neon|Fly|Ride"] = 446.25, ["Mega"] = 3176.72, ["Mega|Fly|Ride"] = 1781.85}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 225.7, ["Ride"] = 294, ["Fly|Ride"] = 367.49, ["Neon"] = 968.93, ["Neon|Ride"] = 792.75, ["Neon|Fly|Ride"] = 1035.57, ["Mega|Fly|Ride"] = 2867.82}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 11.23, ["Ride"] = 28.88, ["Fly|Ride"] = 246.91, ["Neon"] = 85.32, ["Neon|Fly"] = 275.55, ["Neon|Ride"] = 99.73, ["Neon|Fly|Ride"] = 188.68, ["Mega"] = 328.13, ["Mega|Ride"] = 380.61, ["Mega|Fly|Ride"] = 528.75}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 29.09, ["Ride"] = 19.94, ["Fly|Ride"] = 39.37, ["Neon"] = 7.2, ["Neon|Ride"] = 24.62, ["Neon|Fly|Ride"] = 86.52, ["Mega"] = 78.65, ["Mega|Ride"] = 111.57, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.52, ["Fly"] = 39.37, ["Ride"] = 20.13, ["Fly|Ride"] = 63, ["Neon"] = 34.89, ["Neon|Fly"] = 137.48, ["Neon|Ride"] = 43.31, ["Neon|Fly|Ride"] = 95.04, ["Mega"] = 300.98, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 272.99}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 328.12, ["Ride"] = 328.11, ["Fly|Ride"] = 576.03, ["Neon"] = 1562.54, ["Neon|Fly|Ride"] = 2018.19, ["Mega"] = 10824.59, ["Mega|Fly|Ride"] = 6168.75}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 36.83, ["Neon"] = 8.54, ["Neon|Ride"] = 142.26, ["Mega"] = 37.47, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 318.94}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 5.22, ["Ride"] = 19.69, ["Fly|Ride"] = 43.14, ["Neon"] = 27.56, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 82.79, ["Mega"] = 268.5, ["Mega|Fly"] = 264.16, ["Mega|Ride"] = 173.22, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 14.96, ["Fly"] = 6562.5, ["Ride"] = 100.54, ["Fly|Ride"] = 105, ["Neon"] = 88.34, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 197.03, ["Mega"] = 508.73, ["Mega|Ride"] = 722.11, ["Mega|Fly|Ride"] = 625.53}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 167.82, ["Fly"] = 157.5, ["Ride"] = 288.26, ["Fly|Ride"] = 164.06, ["Neon"] = 649.59, ["Neon|Ride"] = 866.09, ["Neon|Fly|Ride"] = 630, ["Mega|Fly|Ride"] = 2884.03}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 19.31, ["Fly"] = 39.38, ["Ride"] = 28.33, ["Fly|Ride"] = 52.5, ["Neon"] = 95.28, ["Neon|Ride"] = 102.38, ["Neon|Fly|Ride"] = 138.5, ["Mega"] = 505.59, ["Mega|Ride"] = 435.75, ["Mega|Fly|Ride"] = 435.65}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 62.55, ["Neon"] = 3.15, ["Neon|Ride"] = 80.13, ["Mega"] = 25.98, ["Mega|Ride"] = 172.29, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 18.38, ["Fly|Ride"] = 86.16, ["Neon"] = 3.66, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 27.98, ["Neon|Fly|Ride"] = 78.73, ["Mega"] = 46.57, ["Mega|Fly"] = 101.78, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 160.23}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 10.39, ["Fly"] = 101.78, ["Ride"] = 88.18, ["Fly|Ride"] = 209.02, ["Neon"] = 36.37, ["Neon|Ride"] = 102.34, ["Neon|Fly|Ride"] = 301.76, ["Mega"] = 164.05, ["Mega|Ride"] = 224.44, ["Mega|Fly|Ride"] = 280.87}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1238.9, ["Ride"] = 1202.25, ["Fly|Ride"] = 1312.5, ["Neon"] = 4474.89, ["Neon|Ride"] = 4330.37, ["Neon|Fly|Ride"] = 4017.24, ["Mega|Fly|Ride"] = 11883.38}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 433.12, ["Ride"] = 433.12, ["Fly|Ride"] = 549.15, ["Neon"] = 1660.71, ["Neon|Ride"] = 1442.44, ["Neon|Fly|Ride"] = 1573.69, ["Mega"] = 15156.25, ["Mega|Fly|Ride"] = 6207.57}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 321.55, ["Ride"] = 339.93, ["Fly|Ride"] = 383.24, ["Neon"] = 656.25, ["Neon|Fly"] = 1148.93, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 734.98, ["Mega|Ride"] = 3610.46, ["Mega|Fly|Ride"] = 3280.78}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 232.29, ["Fly"] = 324.19, ["Ride"] = 287.34, ["Fly|Ride"] = 371.82, ["Neon"] = 682.5, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 714, ["Mega|Ride"] = 3084.38, ["Mega|Fly|Ride"] = 3562.81}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 18.38, ["Fly|Ride"] = 52.5, ["Neon"] = 6.57, ["Neon|Ride"] = 35, ["Neon|Fly|Ride"] = 107.68, ["Mega"] = 57.17, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 261.08, ["Fly"] = 1444.01, ["Ride"] = 366.56, ["Fly|Ride"] = 577.5, ["Neon"] = 1312.5, ["Neon|Ride"] = 1509.38, ["Neon|Fly|Ride"] = 1732.16, ["Mega"] = 21943.45, ["Mega|Fly|Ride"] = 6621.57}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 7.79, ["Fly"] = 183.74, ["Neon"] = 62.44, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 289.06, ["Mega"] = 234.94}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 23.58, ["Ride"] = 15.99, ["Fly|Ride"] = 38.19, ["Neon"] = 11.34, ["Neon|Ride"] = 54.14, ["Neon|Fly|Ride"] = 115.5, ["Mega"] = 128.63, ["Mega|Ride"] = 192.31, ["Mega|Fly|Ride"] = 162.96}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.64, ["Neon"] = 2.63, ["Mega"] = 22.19, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 177.62}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 79.95, ["Ride"] = 131.25, ["Fly|Ride"] = 145.09, ["Neon"] = 236.25, ["Neon|Ride"] = 359.73, ["Mega"] = 1050, ["Mega|Ride"] = 733.69, ["Mega|Fly|Ride"] = 865.01}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.4, ["Fly"] = 8201.01, ["Ride"] = 19.04, ["Fly|Ride"] = 68.25, ["Neon"] = 32, ["Mega"] = 303.14, ["Mega|Ride"] = 306.65, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Fly"] = 72.55, ["Ride"] = 26.24, ["Neon"] = 3.4, ["Neon|Ride"] = 57.73, ["Neon|Fly|Ride"] = 141.93, ["Mega"] = 20.36, ["Mega|Ride"] = 54.96, ["Mega|Fly|Ride"] = 140.03}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 6.2, ["Fly"] = 131.04, ["Ride"] = 72.55, ["Fly|Ride"] = 91.47, ["Neon"] = 45.62, ["Neon|Fly"] = 108.04, ["Neon|Ride"] = 144.35, ["Neon|Fly|Ride"] = 173.25, ["Mega"] = 221.82, ["Mega|Ride"] = 265.84, ["Mega|Fly|Ride"] = 364.55}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 6.5, ["Fly"] = 32.43, ["Ride"] = 18.37, ["Fly|Ride"] = 54.92, ["Neon"] = 38.07, ["Neon|Fly"] = 820.5, ["Neon|Ride"] = 64.96, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 238.85, ["Mega|Ride"] = 216.54, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 10.78, ["Ride"] = 26.25, ["Fly|Ride"] = 164.85, ["Neon"] = 85.32, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 524.99, ["Mega|Ride"] = 558.5}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 3.62, ["Fly"] = 6564.18, ["Ride"] = 24.7, ["Neon"] = 72.55, ["Neon|Ride"] = 214.55, ["Mega"] = 429.19, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 561.88}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 72.35, ["Ride"] = 16.71, ["Fly|Ride"] = 41.08, ["Neon"] = 5.24, ["Neon|Fly"] = 29.25, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 129.92, ["Mega"] = 43.31, ["Mega|Ride"] = 147.62, ["Mega|Fly|Ride"] = 246.04}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 162.69, ["Fly"] = 199.5, ["Ride"] = 196.86, ["Fly|Ride"] = 259.84, ["Neon"] = 689.07, ["Neon|Ride"] = 2706.48, ["Neon|Fly|Ride"] = 984.12, ["Mega"] = 8660.72, ["Mega|Fly|Ride"] = 4850.01}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 25.98, ["Ride"] = 16.25, ["Fly|Ride"] = 32.82, ["Neon"] = 3.41, ["Neon|Fly"] = 36.92, ["Neon|Ride"] = 20.81, ["Neon|Fly|Ride"] = 45.84, ["Mega"] = 36.75, ["Mega|Fly"] = 111.51, ["Mega|Ride"] = 43.36, ["Mega|Fly|Ride"] = 120.75}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 9.49, ["Ride"] = 47.16, ["Fly|Ride"] = 231.66, ["Neon"] = 106.75, ["Neon|Ride"] = 138.59, ["Neon|Fly|Ride"] = 323.71, ["Mega"] = 393.75, ["Mega|Ride"] = 309.75, ["Mega|Fly|Ride"] = 391.12}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 32.8, ["Ride"] = 78.1, ["Fly|Ride"] = 183.75, ["Neon"] = 253.31, ["Neon|Ride"] = 355.69, ["Neon|Fly|Ride"] = 466.83, ["Mega"] = 786.11, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 984.12}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 182.23, ["Fly"] = 262.49, ["Ride"] = 361.65, ["Fly|Ride"] = 259.87, ["Neon"] = 777, ["Neon|Fly"] = 1641.02, ["Neon|Ride"] = 711.37, ["Neon|Fly|Ride"] = 786.79, ["Mega"] = 3610.46, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 11.79, ["Fly"] = 164.84, ["Ride"] = 164.92, ["Neon"] = 157.5, ["Neon|Ride"] = 145.34, ["Mega"] = 287.44, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 428.72}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 29.25, ["Ride"] = 105, ["Fly|Ride"] = 147.9, ["Neon"] = 131.25, ["Neon|Fly"] = 164.85, ["Neon|Fly|Ride"] = 288.74, ["Mega"] = 1588.17, ["Mega|Ride"] = 1444.01, ["Mega|Fly|Ride"] = 971.25}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 990.93, ["Ride"] = 1048.69, ["Fly|Ride"] = 1128.74, ["Neon"] = 5118.75, ["Neon|Ride"] = 4331.25, ["Neon|Fly|Ride"] = 4331.25, ["Mega|Fly|Ride"] = 18043.67}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 6.54, ["Fly"] = 22.32, ["Ride"] = 19.68, ["Fly|Ride"] = 45.94, ["Neon"] = 33.12, ["Neon|Fly"] = 78.83, ["Neon|Ride"] = 86.62, ["Neon|Fly|Ride"] = 202.13, ["Mega"] = 272.84, ["Mega|Ride"] = 188.4, ["Mega|Fly|Ride"] = 302.3}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 5.08, ["Fly"] = 52.5, ["Ride"] = 41.15, ["Neon"] = 32.82, ["Neon|Ride"] = 72.55, ["Mega"] = 262.5, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 215.25, ["Mega|Fly|Ride"] = 341.23}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 86.61, ["Ride"] = 26.25, ["Fly|Ride"] = 895.18, ["Neon"] = 9.18, ["Neon|Ride"] = 36.31, ["Neon|Fly|Ride"] = 197.05, ["Mega"] = 95.53, ["Mega|Ride"] = 361.59, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 17.96, ["Fly"] = 59.08, ["Ride"] = 43.33, ["Fly|Ride"] = 105, ["Neon"] = 69.44, ["Neon|Ride"] = 101.78, ["Neon|Fly|Ride"] = 220.44, ["Mega"] = 459.38, ["Mega|Ride"] = 418.24, ["Mega|Fly|Ride"] = 471.34}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 5.13, ["Fly"] = 28.54, ["Ride"] = 16.12, ["Fly|Ride"] = 42.77, ["Neon"] = 19.28, ["Neon|Fly"] = 54.14, ["Neon|Ride"] = 34.65, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 82.43, ["Mega|Fly"] = 280.98, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 4.64, ["Fly"] = 32.75, ["Ride"] = 32.81, ["Fly|Ride"] = 131.25, ["Neon"] = 19.69, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 107.55, ["Mega"] = 152.23, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 275.62}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 131.15, ["Ride"] = 240.72, ["Fly|Ride"] = 287.95, ["Neon"] = 921.3, ["Neon|Fly|Ride"] = 1183.01, ["Mega|Fly|Ride"] = 3445.78}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 5.18, ["Fly"] = 30.19, ["Ride"] = 21.38, ["Fly|Ride"] = 105.59, ["Neon"] = 8.81, ["Neon|Ride"] = 86.62, ["Neon|Fly|Ride"] = 301.31, ["Mega"] = 78.75, ["Mega|Ride"] = 355.59, ["Mega|Fly|Ride"] = 346.44}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.5, ["Ride"] = 65.62, ["Fly|Ride"] = 88.87, ["Neon"] = 19.21, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27, ["Mega"] = 188.4, ["Mega|Ride"] = 352.9}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.89, ["Fly"] = 94.77, ["Ride"] = 31.08, ["Neon"] = 17.93, ["Neon|Ride"] = 43.33, ["Mega"] = 118.13, ["Mega|Ride"] = 164.06, ["Mega|Fly|Ride"] = 409.23}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 71.38, ["Fly"] = 145.09, ["Ride"] = 137.82, ["Fly|Ride"] = 260.4, ["Neon"] = 447, ["Neon|Ride"] = 433.06, ["Neon|Fly|Ride"] = 472.5, ["Mega|Ride"] = 1587.98, ["Mega|Fly|Ride"] = 1732.16}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 19.89, ["Fly"] = 90.79, ["Ride"] = 62.99, ["Fly|Ride"] = 216.54, ["Neon"] = 128.58, ["Neon|Ride"] = 214.34, ["Neon|Fly|Ride"] = 341.93, ["Mega"] = 525, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 775.16}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 17.82, ["Fly"] = 263.44, ["Ride"] = 80.05, ["Fly|Ride"] = 131.25, ["Neon"] = 85.32, ["Neon|Ride"] = 106.37, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 354.38, ["Mega|Ride"] = 448.88, ["Mega|Fly|Ride"] = 491.29}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 73.82, ["Neon"] = 8.6, ["Neon|Ride"] = 210, ["Mega"] = 98.42, ["Mega|Ride"] = 127.32}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 40.04, ["Fly"] = 34.13, ["Ride"] = 70.7, ["Fly|Ride"] = 146.85, ["Neon"] = 289.05, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 229.69, ["Neon|Fly|Ride"] = 288.75, ["Mega|Fly|Ride"] = 1687.76}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Fly"] = 23.83, ["Ride"] = 45.48, ["Fly|Ride"] = 216.54, ["Neon"] = 4.91, ["Neon|Fly|Ride"] = 101.78, ["Mega"] = 101.78, ["Mega|Ride"] = 289.1, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 20.36, ["Fly"] = 39.38, ["Ride"] = 25.99, ["Fly|Ride"] = 73.63, ["Neon"] = 63.91, ["Neon|Fly"] = 84, ["Neon|Ride"] = 82.43, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 368.03, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 388.62, ["Mega|Fly|Ride"] = 419.98}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 51.18, ["Fly"] = 203.44, ["Ride"] = 93.1, ["Fly|Ride"] = 137.13, ["Neon"] = 262.5, ["Neon|Fly"] = 328.13, ["Neon|Ride"] = 317.63, ["Neon|Fly|Ride"] = 359.61, ["Mega|Ride"] = 1481, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 13.5, ["Fly|Ride"] = 35.44, ["Neon"] = 2.1, ["Neon|Fly"] = 28.17, ["Neon|Ride"] = 19.38, ["Neon|Fly|Ride"] = 43.33, ["Mega"] = 18.08, ["Mega|Fly"] = 77.44, ["Mega|Ride"] = 43.08, ["Mega|Fly|Ride"] = 103.35}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.84, ["Ride"] = 51.98, ["Fly|Ride"] = 131.25, ["Neon"] = 17.49, ["Neon|Ride"] = 86.52, ["Neon|Fly|Ride"] = 168, ["Mega"] = 147.3, ["Mega|Ride"] = 221.03, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 12.63, ["Ride"] = 56.61, ["Fly|Ride"] = 142.92, ["Neon"] = 128.63, ["Neon|Ride"] = 154.07, ["Neon|Fly|Ride"] = 328.47, ["Mega"] = 393.75, ["Mega|Ride"] = 426.57, ["Mega|Fly|Ride"] = 531.57}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 17.06, ["Neon"] = 2.1, ["Neon|Ride"] = 58.48, ["Neon|Fly|Ride"] = 105, ["Mega"] = 21.63, ["Mega|Ride"] = 54.14, ["Mega|Fly|Ride"] = 120.75}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 29.07, ["Fly"] = 145.09, ["Ride"] = 91.87, ["Fly|Ride"] = 215.94, ["Neon"] = 259.74, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 485.63, ["Mega"] = 734.02, ["Mega|Fly"] = 1076.25, ["Mega|Ride"] = 747.01, ["Mega|Fly|Ride"] = 1141.27}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 14.25, ["Fly"] = 25.97, ["Ride"] = 27.57, ["Fly|Ride"] = 101.07, ["Neon"] = 430.5, ["Neon|Ride"] = 136.64, ["Neon|Fly|Ride"] = 176.5, ["Mega|Ride"] = 458.07, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 10.28, ["Ride"] = 67.25, ["Neon"] = 62.39, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 91.77, ["Neon|Fly|Ride"] = 1149.42, ["Mega"] = 341.25, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 535.89}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 8.21, ["Fly"] = 2165.19, ["Ride"] = 51.86, ["Fly|Ride"] = 227.32, ["Neon"] = 44.62, ["Neon|Ride"] = 132.57, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 287.44, ["Mega|Ride"] = 242.99, ["Mega|Fly|Ride"] = 472.38}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 145.68, ["Fly|Ride"] = 196.88, ["Neon"] = 9.15, ["Neon|Fly"] = 210, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 289.04, ["Mega"] = 70.8, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 289.06}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Fly|Ride"] = 101.78, ["Mega"] = 30.18, ["Mega|Ride"] = 87.94, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 24.13}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 58.48, ["Fly"] = 101.07, ["Ride"] = 39.38, ["Fly|Ride"] = 86.62, ["Neon"] = 131.25, ["Neon|Ride"] = 216.54, ["Neon|Fly|Ride"] = 312.38, ["Mega"] = 1854.36, ["Mega|Ride"] = 757.82, ["Mega|Fly|Ride"] = 738.09}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 65.63, ["Neon"] = 3.41, ["Neon|Ride"] = 27.19, ["Mega"] = 19.11, ["Mega|Ride"] = 93.11, ["Mega|Fly|Ride"] = 293.93}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 501.38, ["Ride"] = 485.63, ["Fly|Ride"] = 572.25, ["Neon"] = 3897.33, ["Mega"] = 12991.07, ["Mega|Fly|Ride"] = 7118.53}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 5.13, ["Fly"] = 49.88, ["Ride"] = 33.74, ["Fly|Ride"] = 58.27, ["Neon"] = 73, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 71.03, ["Mega"] = 305.82, ["Mega|Ride"] = 314.35, ["Mega|Fly|Ride"] = 635.43}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.63, ["Fly"] = 42.72, ["Ride"] = 18.38, ["Fly|Ride"] = 42.83, ["Neon"] = 22.3, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 145.09, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 332.38}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 16.24, ["Ride"] = 57.47, ["Fly|Ride"] = 86.61, ["Neon"] = 123.43, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 525, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.24, ["Fly"] = 43.33, ["Ride"] = 38.57, ["Fly|Ride"] = 72.55, ["Neon"] = 49.25, ["Neon|Ride"] = 65.63, ["Mega"] = 282.19, ["Mega|Ride"] = 287.99, ["Mega|Fly|Ride"] = 535.96}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 10.49, ["Ride"] = 91.87, ["Fly|Ride"] = 431.92, ["Neon"] = 83.39, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 248.98, ["Mega"] = 393.75, ["Mega|Ride"] = 411.41, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 7.51, ["Fly"] = 29.25, ["Ride"] = 33.5, ["Fly|Ride"] = 206.76, ["Neon"] = 33.2, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 101.78, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 220.89, ["Mega|Ride"] = 255.94, ["Mega|Fly|Ride"] = 267.43}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 49.22, ["Ride"] = 13.52, ["Fly|Ride"] = 34.68, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 15.58, ["Neon|Fly|Ride"] = 55.78, ["Mega"] = 14.44, ["Mega|Ride"] = 28.88, ["Mega|Fly|Ride"] = 76.13}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 10.5, ["Ride"] = 29.25, ["Fly|Ride"] = 108.26, ["Neon"] = 42, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 155.81, ["Mega"] = 196.69, ["Mega|Ride"] = 344.59, ["Mega|Fly|Ride"] = 316.98}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 253.32, ["Ride"] = 280.67, ["Fly|Ride"] = 382.71, ["Neon"] = 1312.5, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1050, ["Mega|Ride"] = 9545.51, ["Mega|Fly|Ride"] = 4102.53}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 79.98, ["Ride"] = 87.94, ["Fly|Ride"] = 210, ["Neon"] = 458.07, ["Neon|Fly"] = 926.7, ["Neon|Ride"] = 505.59, ["Neon|Fly|Ride"] = 524.99, ["Mega"] = 2310.55, ["Mega|Ride"] = 1879.39, ["Mega|Fly|Ride"] = 1544.82}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 16.06, ["Ride"] = 16.22, ["Fly|Ride"] = 43.09, ["Neon"] = 8.88, ["Neon|Fly"] = 101.78, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 62.51, ["Mega"] = 65.63, ["Mega|Fly"] = 215.45, ["Mega|Ride"] = 128.13, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 26.23, ["Ride"] = 14.41, ["Fly|Ride"] = 34.56, ["Neon"] = 9.43, ["Neon|Fly"] = 32.49, ["Neon|Ride"] = 25.86, ["Neon|Fly|Ride"] = 48.49, ["Mega"] = 118.13, ["Mega|Fly"] = 289.06, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 153.56}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.44, ["Fly"] = 101.8, ["Ride"] = 20.96, ["Fly|Ride"] = 98.44, ["Neon"] = 33.08, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 328.44, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 216.5, ["Ride"] = 244.12, ["Fly|Ride"] = 389.74, ["Neon|Ride"] = 979.13, ["Neon|Fly|Ride"] = 1063.13, ["Mega|Ride"] = 8661.75, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 28.02, ["Ride"] = 17.07, ["Fly|Ride"] = 38.75, ["Neon"] = 32, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 30.35, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 286.12, ["Mega|Ride"] = 259.84, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 6.56, ["Ride"] = 78.75, ["Fly|Ride"] = 129.94, ["Neon"] = 32.81, ["Neon|Ride"] = 110.44, ["Mega"] = 131.25, ["Mega|Ride"] = 305.07, ["Mega|Fly|Ride"] = 411.34}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.63, ["Neon"] = 11.8, ["Neon|Ride"] = 105, ["Mega"] = 118.13, ["Mega|Ride"] = 324.8}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 13.93, ["Fly"] = 58.14, ["Ride"] = 31.19, ["Fly|Ride"] = 78.75, ["Neon"] = 82.68, ["Neon|Ride"] = 86.62, ["Neon|Fly|Ride"] = 194.38, ["Mega"] = 525, ["Mega|Ride"] = 501.38, ["Mega|Fly|Ride"] = 556.46}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 32.75, ["Ride"] = 85.32, ["Fly|Ride"] = 160.23, ["Neon"] = 100.57, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 184.02, ["Neon|Fly|Ride"] = 333.38, ["Mega"] = 462.26, ["Mega|Fly"] = 524, ["Mega|Ride"] = 435.75, ["Mega|Fly|Ride"] = 487.27}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 28.73, ["Fly"] = 57.75, ["Ride"] = 61.53, ["Fly|Ride"] = 93.82, ["Neon"] = 139.55, ["Neon|Fly"] = 286.43, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 183.64, ["Mega"] = 567, ["Mega|Ride"] = 702.19, ["Mega|Fly|Ride"] = 708.03}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 16.68, ["Ride"] = 15.72, ["Fly|Ride"] = 31.5, ["Neon"] = 2.23, ["Neon|Fly"] = 32.65, ["Neon|Ride"] = 17.17, ["Neon|Fly|Ride"] = 45.92, ["Mega"] = 18.4, ["Mega|Fly"] = 43.32, ["Mega|Ride"] = 35.43, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 309.75, ["Ride"] = 202.46, ["Fly|Ride"] = 328.12, ["Neon"] = 3445.78, ["Neon|Fly|Ride"] = 1466.92, ["Mega|Fly|Ride"] = 5774.54}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 8.82, ["Fly"] = 101.19, ["Ride"] = 28.77, ["Fly|Ride"] = 106.97, ["Neon"] = 80.47, ["Neon|Ride"] = 216.54, ["Mega"] = 397.14, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 36.62, ["Ride"] = 19.26, ["Fly|Ride"] = 41.78, ["Neon"] = 6.56, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 41.37, ["Neon|Fly|Ride"] = 129.92, ["Mega"] = 52.59, ["Mega|Fly"] = 245.76, ["Mega|Ride"] = 116.55, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 43.33, ["Ride"] = 22.63, ["Fly|Ride"] = 86.64, ["Neon"] = 3.15, ["Neon|Fly"] = 82.31, ["Neon|Ride"] = 24.62, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 27.08, ["Mega|Fly"] = 144.21, ["Mega|Ride"] = 41.71, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 37.7, ["Fly|Ride"] = 91.88, ["Neon"] = 12.97, ["Neon|Fly"] = 738.4, ["Neon|Ride"] = 62.6, ["Mega"] = 136.4, ["Mega|Ride"] = 196.81, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 8.39, ["Fly"] = 39.38, ["Ride"] = 21.95, ["Fly|Ride"] = 58.97, ["Neon"] = 48.54, ["Neon|Fly"] = 267.07, ["Neon|Ride"] = 48.87, ["Neon|Fly|Ride"] = 225.22, ["Mega"] = 327.34, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 3.73, ["Ride"] = 27.57, ["Neon"] = 43.09, ["Neon|Ride"] = 62.75, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 275.63, ["Mega|Ride"] = 328.59, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Neon"] = 3.42, ["Neon|Ride"] = 104.61, ["Neon|Fly|Ride"] = 108.5, ["Mega"] = 21.83, ["Mega|Ride"] = 68.02, ["Mega|Fly|Ride"] = 202.46}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 9.01, ["Fly"] = 83.99, ["Ride"] = 28.01, ["Fly|Ride"] = 133.19, ["Neon"] = 31.49, ["Neon|Fly"] = 216.54, ["Neon|Ride"] = 76.86, ["Neon|Fly|Ride"] = 164.84, ["Mega"] = 287.44, ["Mega|Ride"] = 231.02, ["Mega|Fly|Ride"] = 361.59}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 31.49, ["Neon"] = 4.03, ["Neon|Fly"] = 115.86, ["Neon|Ride"] = 39.32, ["Neon|Fly|Ride"] = 108.26, ["Mega"] = 21, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 245.44}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 60.48, ["Ride"] = 17.04, ["Fly|Ride"] = 43.24, ["Neon"] = 3.83, ["Neon|Ride"] = 24.67, ["Neon|Fly|Ride"] = 85.29, ["Mega"] = 49.22, ["Mega|Ride"] = 91.77, ["Mega|Fly|Ride"] = 287.99}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 656.24, ["Ride"] = 708.75, ["Fly|Ride"] = 779.63, ["Neon"] = 2625, ["Neon|Ride"] = 3296.78, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 9620.63}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 18.34, ["Ride"] = 15.62, ["Fly|Ride"] = 64.99, ["Neon"] = 33.23, ["Neon|Fly"] = 43.33, ["Neon|Ride"] = 27.26, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 143.07, ["Mega|Ride"] = 94.21}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Fly"] = 145.09, ["Ride"] = 44.63, ["Neon"] = 8.9, ["Neon|Fly"] = 757.82, ["Neon|Ride"] = 60.48, ["Neon|Fly|Ride"] = 172.51, ["Mega"] = 105, ["Mega|Fly"] = 212.2, ["Mega|Ride"] = 109.13, ["Mega|Fly|Ride"] = 271.74}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 7.23, ["Fly"] = 33.1, ["Ride"] = 21.86, ["Fly|Ride"] = 56.11, ["Neon"] = 25.99, ["Neon|Fly"] = 57.84, ["Neon|Ride"] = 45.85, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 485.63, ["Mega|Ride"] = 290.07, ["Mega|Fly|Ride"] = 377.99}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 58.96, ["Ride"] = 15.23, ["Fly|Ride"] = 32.93, ["Neon"] = 10.47, ["Neon|Fly"] = 52.48, ["Neon|Ride"] = 22.92, ["Neon|Fly|Ride"] = 57.74, ["Mega"] = 68.25, ["Mega|Ride"] = 96.48, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 39.64, ["Ride"] = 83.99, ["Neon"] = 157.5, ["Neon|Ride"] = 341.04, ["Neon|Fly|Ride"] = 303.14, ["Mega"] = 1270.98, ["Mega|Ride"] = 873.66, ["Mega|Fly|Ride"] = 820.52}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 78.75, ["Ride"] = 33.76, ["Fly|Ride"] = 77.97, ["Neon"] = 8.74, ["Neon|Fly"] = 129.92, ["Neon|Ride"] = 45.92, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 47.25, ["Mega|Ride"] = 93.19, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 3.1, ["Fly"] = 76.28, ["Ride"] = 26.22, ["Fly|Ride"] = 98.25, ["Neon"] = 14.33, ["Neon|Ride"] = 52.4, ["Mega"] = 115.49, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 325.5}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Ride"] = 43.33, ["Fly|Ride"] = 65.84, ["Neon"] = 13.31, ["Mega"] = 93.12, ["Mega|Fly"] = 289.04, ["Mega|Ride"] = 162.42, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 2598.22, ["Ride"] = 19.67, ["Fly|Ride"] = 69.57, ["Neon"] = 4.81, ["Neon|Fly"] = 72.55, ["Neon|Ride"] = 20.98, ["Neon|Fly|Ride"] = 108.26, ["Mega"] = 38.06, ["Mega|Fly"] = 229.69, ["Mega|Ride"] = 108.27, ["Mega|Fly|Ride"] = 106.31}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 13.78, ["Fly"] = 21.95, ["Ride"] = 19.21, ["Fly|Ride"] = 36.26, ["Neon"] = 123.03, ["Neon|Fly"] = 123.31, ["Neon|Ride"] = 129.39, ["Neon|Fly|Ride"] = 143.07, ["Mega|Ride"] = 477.43, ["Mega|Fly|Ride"] = 488.95}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 616.88, ["Ride"] = 735, ["Fly|Ride"] = 833.44, ["Neon"] = 1585.5, ["Neon|Ride"] = 1569.75, ["Neon|Fly|Ride"] = 1837.5, ["Mega"] = 6561.56, ["Mega|Ride"] = 7361.62, ["Mega|Fly|Ride"] = 4504.5}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 16.25, ["Ride"] = 14.44, ["Fly|Ride"] = 51.77, ["Neon"] = 3.94, ["Neon|Fly"] = 17.34, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 47.1, ["Mega"] = 29.25, ["Mega|Ride"] = 52.02, ["Mega|Fly|Ride"] = 135.76}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 5.18, ["Ride"] = 39.35, ["Neon"] = 29.25, ["Neon|Ride"] = 98.53, ["Neon|Fly|Ride"] = 250.69, ["Mega"] = 244.47, ["Mega|Ride"] = 578.11, ["Mega|Fly|Ride"] = 578.11}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 56.1, ["Fly"] = 156.19, ["Ride"] = 59.07, ["Fly|Ride"] = 127.76, ["Neon"] = 262.5, ["Neon|Ride"] = 314.46, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 2461.28, ["Mega|Fly|Ride"] = 1847.99}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 30.19, ["Fly"] = 145.16, ["Ride"] = 58.45, ["Fly|Ride"] = 103.94, ["Neon"] = 249.38, ["Neon|Ride"] = 129.22, ["Mega"] = 2019.82, ["Mega|Ride"] = 1011.15, ["Mega|Fly|Ride"] = 820.52}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 12.78, ["Ride"] = 43.33, ["Fly|Ride"] = 105, ["Neon"] = 69.56, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 311.85, ["Mega|Ride"] = 351.32, ["Mega|Fly|Ride"] = 404.91}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 22.32, ["Fly"] = 86.62, ["Ride"] = 71.39, ["Fly|Ride"] = 173.21, ["Neon"] = 86.62, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 309.1, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 397.69}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 25.86, ["Fly|Ride"] = 157.5, ["Neon"] = 259.84, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 375.67, ["Mega"] = 923.99, ["Mega|Ride"] = 477.43, ["Mega|Fly|Ride"] = 469.86}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 21.61}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 3.93, ["Ride"] = 29.25, ["Fly|Ride"] = 101.17, ["Neon"] = 45.94, ["Neon|Fly"] = 94.49, ["Neon|Ride"] = 91.04, ["Neon|Fly|Ride"] = 213.98, ["Mega"] = 157.5, ["Mega|Fly"] = 467.58, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 355.23}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.37, ["Neon"] = 10.5, ["Mega"] = 139.32, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 30.79, ["Fly"] = 63, ["Ride"] = 32.79, ["Fly|Ride"] = 75.79, ["Neon"] = 182.07, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 153.37, ["Neon|Fly|Ride"] = 296.64, ["Mega"] = 938.62, ["Mega|Ride"] = 1155.15, ["Mega|Fly|Ride"] = 789.05}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.11, ["Fly"] = 18.1, ["Ride"] = 17.3, ["Fly|Ride"] = 32.82, ["Neon"] = 24.76, ["Neon|Fly"] = 42.94, ["Neon|Ride"] = 36.43, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 253.34, ["Mega|Fly"] = 432.99, ["Mega|Ride"] = 173.22, ["Mega|Fly|Ride"] = 230.67}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 5.24, ["Fly"] = 107.29, ["Ride"] = 21.59, ["Fly|Ride"] = 64.19, ["Neon"] = 23.22, ["Neon|Ride"] = 85.55, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 177.19, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 324.8}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 6.5, ["Mega|Ride"] = 108.27, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 32.7, ["Ride"] = 53.69, ["Fly|Ride"] = 86.81, ["Neon"] = 157.5, ["Neon|Ride"] = 210.67, ["Neon|Fly|Ride"] = 433.06, ["Mega|Ride"] = 820.52, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 38.08, ["Fly|Ride"] = 58.15, ["Neon"] = 6.29, ["Neon|Ride"] = 45.92, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 78.75, ["Mega|Ride"] = 143.21}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 8.54, ["Ride"] = 820.5, ["Fly|Ride"] = 210, ["Neon"] = 78.74, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 324.8, ["Mega"] = 433.06, ["Mega|Ride"] = 427.48, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 16.5, ["Fly|Ride"] = 48.92, ["Neon"] = 14.44, ["Neon|Ride"] = 24.55, ["Neon|Fly|Ride"] = 100.46, ["Mega"] = 105.79, ["Mega|Ride"] = 151.57, ["Mega|Fly|Ride"] = 289.06}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 3.7, ["Fly"] = 52.49, ["Ride"] = 27.14, ["Fly|Ride"] = 65.66, ["Neon"] = 94.5, ["Neon|Fly"] = 145.09, ["Neon|Ride"] = 72.55, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 275.03, ["Mega|Ride"] = 389.79, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 8.58, ["Neon"] = 72.15, ["Mega"] = 426.57, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 649.59}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 53.82, ["Fly"] = 216.54, ["Ride"] = 136.5, ["Fly|Ride"] = 216.54, ["Neon"] = 315, ["Neon|Ride"] = 540.22, ["Neon|Fly|Ride"] = 720.87, ["Mega"] = 1732.16, ["Mega|Ride"] = 1406.31, ["Mega|Fly|Ride"] = 1286.25}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 18.45, ["Fly"] = 129.91, ["Ride"] = 78.75, ["Fly|Ride"] = 161.28, ["Neon"] = 85.32, ["Mega"] = 422.63, ["Mega|Ride"] = 418.69, ["Mega|Fly|Ride"] = 696.29}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 5.24, ["Ride"] = 116.43, ["Neon"] = 149.63, ["Neon|Fly"] = 216.5, ["Neon|Ride"] = 170.63, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 492.07}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 27.56, ["Ride"] = 128.84, ["Fly|Ride"] = 367.49, ["Neon"] = 157.02, ["Neon|Fly"] = 145.09, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 929.96, ["Mega|Fly"] = 2165.19, ["Mega|Ride"] = 729.68, ["Mega|Fly|Ride"] = 865.01}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.47, ["Neon"] = 24.54, ["Neon|Fly|Ride"] = 145.09, ["Mega"] = 198.19, ["Mega|Ride"] = 255.88, ["Mega|Fly|Ride"] = 328.44}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 157.5, ["Ride"] = 15.83, ["Fly|Ride"] = 47.36, ["Neon"] = 3.72, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 18.47, ["Neon|Fly|Ride"] = 67.24, ["Mega"] = 62.03, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 3.15, ["Fly"] = 45.94, ["Ride"] = 37.9, ["Fly|Ride"] = 65.63, ["Neon"] = 13.19, ["Neon|Ride"] = 36.66, ["Neon|Fly|Ride"] = 164.05, ["Mega"] = 98.44, ["Mega|Ride"] = 103.99, ["Mega|Fly|Ride"] = 336}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 144.32, ["Ride"] = 25.99, ["Fly|Ride"] = 72, ["Neon"] = 6.28, ["Neon|Ride"] = 31.42, ["Neon|Fly|Ride"] = 84.46, ["Mega"] = 53.82, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 116.82}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.23, ["Fly"] = 65.62, ["Ride"] = 23.82, ["Fly|Ride"] = 85.54, ["Neon"] = 25.03, ["Neon|Ride"] = 86.63, ["Neon|Fly|Ride"] = 216.54, ["Mega"] = 218.71, ["Mega|Ride"] = 313.95, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 6.2, ["Fly"] = 104.99, ["Ride"] = 34.12, ["Fly|Ride"] = 86.61, ["Neon"] = 31.48, ["Neon|Fly"] = 315, ["Neon|Ride"] = 58.15, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 287.47, ["Mega|Fly|Ride"] = 542.51}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 2.37, ["Fly"] = 131.24, ["Ride"] = 20.35, ["Fly|Ride"] = 43.33, ["Neon"] = 24.92, ["Neon|Fly"] = 135.69, ["Neon|Ride"] = 49.33, ["Neon|Fly|Ride"] = 111.45, ["Mega|Fly"] = 271.79, ["Mega|Ride"] = 187.69, ["Mega|Fly|Ride"] = 287.44}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 3.24, ["Fly"] = 35.49, ["Ride"] = 19.19, ["Fly|Ride"] = 52.49, ["Neon"] = 22.31, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 151.57, ["Mega"] = 274.99, ["Mega|Ride"] = 164.84, ["Mega|Fly|Ride"] = 213.74}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 2.41, ["Fly"] = 186.38, ["Ride"] = 47.29, ["Neon"] = 7.65, ["Neon|Fly"] = 437.06, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 236.01, ["Mega"] = 81.24, ["Mega|Fly"] = 216.81, ["Mega|Ride"] = 159.16, ["Mega|Fly|Ride"] = 280.35}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 15.58, ["Ride"] = 82.69, ["Fly|Ride"] = 246.04, ["Neon"] = 98.43, ["Neon|Fly"] = 270.66, ["Neon|Ride"] = 203.32, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 339.1, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 482.05, ["Mega|Fly|Ride"] = 483.18}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 45.46, ["Fly"] = 164.07, ["Ride"] = 83.15, ["Fly|Ride"] = 170.63, ["Neon"] = 242.81, ["Neon|Ride"] = 263.82, ["Neon|Fly|Ride"] = 318.17, ["Mega"] = 995.99, ["Mega|Ride"] = 1009.22, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Ride"] = 23.7, ["Fly|Ride"] = 118.12, ["Neon"] = 2.1, ["Neon|Ride"] = 20.58, ["Neon|Fly|Ride"] = 145.09, ["Mega"] = 54.14, ["Mega|Ride"] = 72.55, ["Mega|Fly|Ride"] = 123.38}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 15.52, ["Ride"] = 105, ["Neon"] = 105.94, ["Mega"] = 721.02, ["Mega|Fly|Ride"] = 1141.06}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 60.11, ["Ride"] = 93.69, ["Fly|Ride"] = 172.15, ["Neon"] = 344.45, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 418.99, ["Mega"] = 1232, ["Mega|Ride"] = 1357.58, ["Mega|Fly|Ride"] = 1444.2}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 9.14, ["Fly"] = 116.82, ["Ride"] = 28.04, ["Fly|Ride"] = 133.88, ["Neon"] = 52.5, ["Neon|Fly"] = 131.69, ["Neon|Ride"] = 105, ["Mega"] = 272.9, ["Mega|Fly"] = 743.32, ["Mega|Ride"] = 241.5, ["Mega|Fly|Ride"] = 295.31}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 5.02, ["Neon"] = 14.79, ["Neon|Ride"] = 52.41, ["Mega"] = 69.21, ["Mega|Fly"] = 282.17, ["Mega|Ride"] = 437.06, ["Mega|Fly|Ride"] = 282.19}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.59, ["Fly"] = 31.49, ["Ride"] = 19.28, ["Fly|Ride"] = 51.4, ["Neon"] = 12.47, ["Neon|Ride"] = 41.65, ["Neon|Fly|Ride"] = 111.56, ["Mega"] = 114.19, ["Mega|Fly"] = 196.87, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 211.12}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 21.59, ["Ride"] = 14.44, ["Fly|Ride"] = 52.5, ["Neon"] = 2.1, ["Neon|Fly"] = 129.92, ["Neon|Ride"] = 23.57, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 24.92, ["Mega|Ride"] = 78.78, ["Mega|Fly|Ride"] = 162.38}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 17.46, ["Fly|Ride"] = 93.09, ["Neon"] = 4.19, ["Neon|Ride"] = 26.22, ["Neon|Fly|Ride"] = 97.44, ["Mega"] = 43.07, ["Mega|Fly"] = 168, ["Mega|Ride"] = 56.11, ["Mega|Fly|Ride"] = 164.85}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Neon"] = 2.59, ["Neon|Ride"] = 145.09, ["Mega"] = 21.96, ["Mega|Ride"] = 79.7, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 6.27, ["Ride"] = 157.5, ["Neon"] = 19.69, ["Neon|Ride"] = 82.6, ["Neon|Fly|Ride"] = 123.41, ["Mega"] = 182.83, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 6.29, ["Ride"] = 45.94, ["Fly|Ride"] = 216.5, ["Neon"] = 88.65, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 141.49, ["Mega"] = 262.5, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 5.9, ["Fly"] = 22.17, ["Ride"] = 19.65, ["Fly|Ride"] = 40.13, ["Neon"] = 52.9, ["Neon|Ride"] = 44.17, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 328.13, ["Mega|Fly"] = 366.19, ["Mega|Ride"] = 384.34, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 65.63, ["Ride"] = 98.44, ["Fly|Ride"] = 124.69, ["Neon"] = 393.75, ["Neon|Ride"] = 541.31, ["Neon|Fly|Ride"] = 722.19, ["Mega"] = 1501.56, ["Mega|Ride"] = 1718.08, ["Mega|Fly|Ride"] = 1501.5}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 23.63, ["Fly"] = 51.19, ["Ride"] = 28.88, ["Fly|Ride"] = 102.86, ["Neon"] = 722.11, ["Neon|Fly|Ride"] = 630, ["Mega"] = 467.24, ["Mega|Ride"] = 1023.75, ["Mega|Fly|Ride"] = 1050.67}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 16.17, ["Fly|Ride"] = 42, ["Neon"] = 2.63, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 24.92, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 26.01, ["Mega|Ride"] = 101.06, ["Mega|Fly|Ride"] = 241.5}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 19.61, ["Ride"] = 15.72, ["Fly|Ride"] = 32.22, ["Neon"] = 5.09, ["Neon|Fly"] = 28.07, ["Neon|Ride"] = 19.39, ["Neon|Fly|Ride"] = 43.31, ["Mega"] = 55.22, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 116.88}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 413.34, ["Fly"] = 681.51, ["Ride"] = 531.57, ["Fly|Ride"] = 552.57, ["Neon"] = 2743.3, ["Neon|Ride"] = 2296.88, ["Neon|Fly|Ride"] = 2098.69}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 4.71, ["Ride"] = 56.61, ["Fly|Ride"] = 86.62, ["Neon"] = 35.44, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 578.19, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 17.18, ["Fly|Ride"] = 30.24, ["Neon"] = 7.22, ["Neon|Fly"] = 22.87, ["Neon|Ride"] = 18.33, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 43.05, ["Mega|Ride"] = 38.83, ["Mega|Fly|Ride"] = 89.14}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 49.88, ["Ride"] = 105.37, ["Fly|Ride"] = 722.11, ["Neon"] = 203.44, ["Neon|Ride"] = 280.23, ["Neon|Fly|Ride"] = 571.61, ["Mega"] = 796.11, ["Mega|Ride"] = 630.3, ["Mega|Fly|Ride"] = 821.61}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.41, ["Fly"] = 27.56, ["Ride"] = 18.15, ["Fly|Ride"] = 63.25, ["Neon"] = 14.44, ["Neon|Fly"] = 101.36, ["Neon|Ride"] = 26.7, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 114.19, ["Mega|Ride"] = 132.08, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Ride"] = 15.74, ["Fly|Ride"] = 196.88, ["Neon"] = 2.62, ["Neon|Ride"] = 145.09, ["Neon|Fly|Ride"] = 101.78, ["Mega"] = 19.97, ["Mega|Ride"] = 52.9, ["Mega|Fly|Ride"] = 154.75}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 32.43, ["Fly"] = 129.94, ["Ride"] = 78.75, ["Fly|Ride"] = 215.45, ["Neon"] = 169.32, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 424.38, ["Mega"] = 820.5, ["Mega|Ride"] = 661.39, ["Mega|Fly|Ride"] = 812.44}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Fly|Ride"] = 146.99, ["Neon"] = 7.77, ["Neon|Ride"] = 23.64, ["Mega"] = 58.47, ["Mega|Ride"] = 86.63, ["Mega|Fly|Ride"] = 255.5}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 47.23, ["Ride"] = 53.82, ["Fly|Ride"] = 131.25, ["Neon"] = 283.23, ["Neon|Ride"] = 216.54, ["Neon|Fly|Ride"] = 216.5, ["Mega"] = 1181.25, ["Mega|Ride"] = 1299.13, ["Mega|Fly|Ride"] = 1334.93}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 2.98, ["Ride"] = 51.19, ["Neon"] = 42, ["Neon|Ride"] = 231, ["Neon|Fly|Ride"] = 505.53, ["Mega"] = 170.63, ["Mega|Ride"] = 418.99}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 72.55, ["Ride"] = 81.36, ["Fly|Ride"] = 58.48, ["Neon"] = 8.64, ["Neon|Ride"] = 43.35, ["Neon|Fly|Ride"] = 108.26, ["Mega"] = 117.6, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 62.81, ["Fly"] = 216.54, ["Ride"] = 122.85, ["Fly|Ride"] = 536.8, ["Neon"] = 334.59, ["Neon|Ride"] = 479.54, ["Mega|Ride"] = 2770.69, ["Mega|Fly|Ride"] = 1215.35}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.42, ["Fly"] = 599.43, ["Ride"] = 44.63, ["Neon"] = 7.81, ["Neon|Fly"] = 115.86, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 145.06, ["Mega"] = 43.8, ["Mega|Fly"] = 216.54, ["Mega|Ride"] = 89.24, ["Mega|Fly|Ride"] = 328.47}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 28, ["Ride"] = 19.69, ["Fly|Ride"] = 39.38, ["Neon"] = 3.94, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 25.98, ["Neon|Fly|Ride"] = 86.89, ["Mega"] = 81.21, ["Mega|Fly"] = 151.38, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 230.32}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 9.41, ["Fly"] = 58.51, ["Ride"] = 39.38, ["Fly|Ride"] = 196.92, ["Neon"] = 84, ["Neon|Fly"] = 131.64, ["Neon|Ride"] = 102.38, ["Neon|Fly|Ride"] = 214.36, ["Mega"] = 393.75, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 7.84, ["Fly"] = 38.06, ["Ride"] = 26.22, ["Fly|Ride"] = 51.19, ["Neon"] = 42, ["Neon|Fly"] = 327.22, ["Neon|Ride"] = 84.47, ["Neon|Fly|Ride"] = 126.04, ["Mega"] = 354.38, ["Mega|Ride"] = 362.25, ["Mega|Fly|Ride"] = 1230.15}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 23.14, ["Fly"] = 28.87, ["Ride"] = 22.32, ["Fly|Ride"] = 61.94, ["Neon"] = 81.38, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 173.21, ["Mega"] = 784.92, ["Mega|Ride"] = 334.69, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 65.61, ["Ride"] = 111.57, ["Fly|Ride"] = 192.95, ["Neon"] = 346.5, ["Neon|Fly"] = 428.59, ["Neon|Ride"] = 367.49, ["Neon|Fly|Ride"] = 417.68, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1299.38}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 13.01, ["Ride"] = 108.15, ["Fly|Ride"] = 423.94, ["Neon"] = 65.42, ["Neon|Ride"] = 186.51, ["Neon|Fly|Ride"] = 171.29, ["Mega"] = 339.13, ["Mega|Ride"] = 377.67}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 6.51, ["Ride"] = 21.36, ["Fly|Ride"] = 78.75, ["Neon"] = 15.75, ["Neon|Ride"] = 47.25, ["Mega"] = 128.17, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 287.66}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 11.82, ["Fly"] = 135.19, ["Ride"] = 42.24, ["Fly|Ride"] = 115.5, ["Neon"] = 68.9, ["Neon|Fly"] = 105, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 164.85, ["Mega"] = 317.63, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 418.99}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 14.96, ["Ride"] = 12.96, ["Fly|Ride"] = 30.15, ["Neon"] = 2.23, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 15.73, ["Neon|Fly|Ride"] = 43.24, ["Mega"] = 14.99, ["Mega|Fly"] = 42, ["Mega|Ride"] = 28.56, ["Mega|Fly|Ride"] = 101.78}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 43.31, ["Fly"] = 164.07, ["Ride"] = 88.85, ["Fly|Ride"] = 255.5, ["Neon"] = 233.89, ["Neon|Fly"] = 2454.24, ["Neon|Ride"] = 289.06, ["Mega"] = 935.29, ["Mega|Ride"] = 976.5, ["Mega|Fly|Ride"] = 855.49}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Fly"] = 64.32, ["Ride"] = 20.6, ["Fly|Ride"] = 112.22, ["Neon"] = 4.86, ["Neon|Fly"] = 131.25, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 33.02, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 19.04, ["Fly|Ride"] = 45.9, ["Neon"] = 17.07, ["Neon|Ride"] = 28.45, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 252, ["Mega|Ride"] = 212.68, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 51.43, ["Fly"] = 115.86, ["Ride"] = 96.46, ["Fly|Ride"] = 115.86, ["Neon"] = 244.27, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 969.33, ["Mega|Ride"] = 825.57, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 63.57, ["Neon"] = 8.82, ["Neon|Ride"] = 39.26, ["Neon|Fly|Ride"] = 173.25, ["Mega"] = 65.83, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 4.08}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Fly|Ride"] = 141.01, ["Neon"] = 3.15, ["Neon|Ride"] = 39.36, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 45.48, ["Mega|Ride"] = 95.81, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 135.14, ["Ride"] = 182.44, ["Fly|Ride"] = 362.69, ["Neon"] = 525, ["Neon|Ride"] = 629.99, ["Neon|Fly|Ride"] = 678.57, ["Mega"] = 6495.54, ["Mega|Ride"] = 3280.67, ["Mega|Fly|Ride"] = 2166.68}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.41, ["Ride"] = 105, ["Fly|Ride"] = 216.57, ["Neon"] = 43.88, ["Neon|Fly"] = 145.09, ["Neon|Ride"] = 67.02, ["Mega"] = 164.85, ["Mega|Ride"] = 253.31, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 15.75, ["Neon"] = 3.89, ["Neon|Ride"] = 22.23, ["Mega"] = 45.92, ["Mega|Ride"] = 48.57, ["Mega|Fly|Ride"] = 307.13}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 6.56, ["Ride"] = 36.75, ["Fly|Ride"] = 101.8, ["Neon"] = 60.29, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 164.85, ["Mega"] = 319.85, ["Mega|Ride"] = 579.12, ["Mega|Fly|Ride"] = 688.63}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 8.95, ["Fly"] = 90.95, ["Ride"] = 29.25, ["Fly|Ride"] = 62.82, ["Neon"] = 101.04, ["Neon|Ride"] = 142.92, ["Neon|Fly|Ride"] = 216.5, ["Mega"] = 649.69, ["Mega|Ride"] = 283.5, ["Mega|Fly|Ride"] = 397.32}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 21, ["Ride"] = 64.2, ["Fly|Ride"] = 289.06, ["Neon"] = 176.56, ["Neon|Ride"] = 157.48, ["Neon|Fly|Ride"] = 328.47, ["Mega"] = 552.57, ["Mega|Ride"] = 551.25, ["Mega|Fly|Ride"] = 639.85}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 126, ["Fly"] = 196.88, ["Ride"] = 157, ["Fly|Ride"] = 203.4, ["Neon"] = 525, ["Neon|Fly"] = 459.38, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 570.94, ["Mega|Fly|Ride"] = 2362.5}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 6.57, ["Fly"] = 20.98, ["Ride"] = 17.07, ["Fly|Ride"] = 40.85, ["Neon"] = 49.54, ["Neon|Fly"] = 72.55, ["Neon|Ride"] = 37.78, ["Neon|Fly|Ride"] = 72.16, ["Mega|Ride"] = 328.47, ["Mega|Fly|Ride"] = 409.23}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 3.99, ["Fly"] = 72.55, ["Ride"] = 46.52, ["Fly|Ride"] = 131.25, ["Neon"] = 19.69, ["Neon|Ride"] = 38.19, ["Neon|Fly|Ride"] = 86.16, ["Mega"] = 128.25, ["Mega|Ride"] = 157.49, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 6.49, ["Fly"] = 43.2, ["Ride"] = 41.14, ["Fly|Ride"] = 76.13, ["Neon"] = 48.57, ["Neon|Fly"] = 86.62, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 149.41, ["Mega"] = 461.28, ["Mega|Ride"] = 410.86, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 52.33, ["Fly"] = 82.43, ["Ride"] = 76.67, ["Fly|Ride"] = 118.13, ["Neon"] = 220.32, ["Neon|Ride"] = 283.65, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 787.5, ["Mega|Ride"] = 925.32, ["Mega|Fly|Ride"] = 1207.5}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 18.36, ["Ride"] = 160.79, ["Neon"] = 196.88, ["Neon|Ride"] = 259.84, ["Neon|Fly|Ride"] = 289.06, ["Mega"] = 736.86, ["Mega|Ride"] = 621.44, ["Mega|Fly|Ride"] = 634.43}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 236.12, ["Ride"] = 350.44, ["Fly|Ride"] = 393.75, ["Neon"] = 1312.5, ["Neon|Ride"] = 1641.02, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4198.69}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 24.06, ["Ride"] = 28.88, ["Fly|Ride"] = 69.46, ["Neon"] = 431.96, ["Neon|Ride"] = 194.25, ["Neon|Fly|Ride"] = 328.44, ["Mega"] = 918.75, ["Mega|Ride"] = 722.11, ["Mega|Fly|Ride"] = 866.09}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 41.98, ["Ride"] = 14.4, ["Fly|Ride"] = 34.13, ["Neon"] = 2.24, ["Neon|Ride"] = 16.09, ["Neon|Fly|Ride"] = 45.48, ["Mega"] = 18.24, ["Mega|Fly"] = 114.76, ["Mega|Ride"] = 29.25, ["Mega|Fly|Ride"] = 129.92}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Ride"] = 25.47, ["Neon"] = 43.31, ["Neon|Ride"] = 86.62, ["Neon|Fly|Ride"] = 164.85, ["Mega"] = 196.88, ["Mega|Ride"] = 140.43, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.61, ["Ride"] = 32.82, ["Fly|Ride"] = 145.09, ["Neon"] = 19.68, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 1181.25, ["Mega"] = 157.5, ["Mega|Fly"] = 575.01, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 327.47}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 426.57, ["Fly"] = 393.75, ["Ride"] = 400.2, ["Fly|Ride"] = 533.38, ["Neon"] = 1877.24, ["Neon|Ride"] = 1732.36, ["Mega|Ride"] = 6561.56, ["Mega|Fly|Ride"] = 5052.47}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 78.75, ["Ride"] = 14.96, ["Fly|Ride"] = 48.55, ["Neon"] = 17.63, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 252, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 6.25, ["Fly"] = 28.16, ["Ride"] = 19.5, ["Fly|Ride"] = 44.63, ["Neon"] = 51, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 71.47, ["Neon|Fly|Ride"] = 140.31, ["Mega"] = 370.27, ["Mega|Ride"] = 278.13, ["Mega|Fly|Ride"] = 328.02}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 4.99, ["Fly"] = 45.92, ["Ride"] = 27.56, ["Fly|Ride"] = 71.31, ["Neon"] = 14.24, ["Neon|Fly"] = 94.48, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 127.32, ["Mega"] = 94.5, ["Mega|Ride"] = 128.64, ["Mega|Fly|Ride"] = 229.52}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 40.69, ["Fly"] = 73.82, ["Ride"] = 36.75, ["Fly|Ride"] = 86.63, ["Neon"] = 220.5, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 738.07, ["Mega|Ride"] = 865.12, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 34.65, ["Fly|Ride"] = 52.91, ["Neon"] = 17.07, ["Neon|Ride"] = 107.03, ["Neon|Fly|Ride"] = 210, ["Mega"] = 168.77, ["Mega|Ride"] = 205.23, ["Mega|Fly|Ride"] = 755.35}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 14.39, ["Fly"] = 262.5, ["Ride"] = 39.38, ["Neon"] = 209.99, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 259.23}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Fly|Ride"] = 145.09, ["Neon"] = 9.19, ["Neon|Ride"] = 144.27, ["Neon|Fly|Ride"] = 101.78, ["Mega"] = 79.93, ["Mega|Ride"] = 126.04, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 7.66, ["Neon"] = 65.62, ["Mega"] = 137.4, ["Mega|Ride"] = 316.1, ["Mega|Fly|Ride"] = 656.92}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 14.8, ["Ride"] = 78.75, ["Fly|Ride"] = 86.62, ["Neon"] = 48.57, ["Neon|Ride"] = 82.43, ["Neon|Fly|Ride"] = 146.18, ["Mega"] = 215.33, ["Mega|Ride"] = 289.47, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 11.54, ["Fly"] = 35.44, ["Ride"] = 23.31, ["Fly|Ride"] = 45.93, ["Neon"] = 72.54, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 48.76, ["Neon|Fly|Ride"] = 94.49, ["Mega"] = 540.22, ["Mega|Ride"] = 341.16, ["Mega|Fly|Ride"] = 384.57}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 393.75, ["Fly"] = 590.47, ["Ride"] = 439.69, ["Fly|Ride"] = 535.78, ["Neon"] = 1903.13, ["Neon|Fly"] = 2072.89, ["Neon|Ride"] = 3570, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 7479.94}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 18.78, ["Fly|Ride"] = 36.75, ["Neon"] = 14.8, ["Neon|Fly"] = 82.48, ["Neon|Ride"] = 32.49, ["Neon|Fly|Ride"] = 197.54, ["Mega"] = 271.79, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 21.67, ["Fly"] = 96.97, ["Ride"] = 65.63, ["Fly|Ride"] = 236.23, ["Neon"] = 103.94, ["Neon|Ride"] = 154.88, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 433.13, ["Mega|Fly"] = 722.11, ["Mega|Ride"] = 578.11, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 19.67, ["Ride"] = 105, ["Fly|Ride"] = 246.04, ["Neon"] = 70.7, ["Neon|Ride"] = 202.46, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 356.75, ["Mega|Ride"] = 301.87, ["Mega|Fly|Ride"] = 459.37}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 46.75, ["Fly"] = 169.2, ["Ride"] = 76.02, ["Fly|Ride"] = 127.76, ["Neon"] = 355.1, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 315, ["Mega"] = 2626.18, ["Mega|Fly|Ride"] = 3176.33}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 11.33, ["Ride"] = 58.49, ["Fly|Ride"] = 105, ["Neon"] = 49.82, ["Neon|Ride"] = 122.35, ["Neon|Fly|Ride"] = 205.46, ["Mega"] = 207.38, ["Mega|Fly"] = 366.16, ["Mega|Ride"] = 216.56, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 17.34, ["Fly|Ride"] = 59.07, ["Neon"] = 18.37, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 105, ["Mega"] = 102.38, ["Mega|Ride"] = 146.24, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 5.29, ["Ride"] = 93.12, ["Neon"] = 21.66, ["Neon|Ride"] = 86.64, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 103.37, ["Mega|Fly"] = 491.51, ["Mega|Ride"] = 217.29, ["Mega|Fly|Ride"] = 296.63}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 40.57, ["Fly"] = 183.75, ["Ride"] = 87.45, ["Fly|Ride"] = 221.81, ["Neon"] = 116.81, ["Neon|Ride"] = 194.14, ["Neon|Fly|Ride"] = 343.88, ["Mega"] = 409.49, ["Mega|Ride"] = 410.81, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 85.32, ["Neon"] = 8.67, ["Neon|Ride"] = 72.14, ["Neon|Fly|Ride"] = 169.59, ["Mega"] = 62.62, ["Mega|Fly"] = 105, ["Mega|Ride"] = 123.36, ["Mega|Fly|Ride"] = 157.49}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 28.17, ["Ride"] = 183.75, ["Neon"] = 202.46, ["Neon|Fly"] = 492.07, ["Neon|Ride"] = 389.74, ["Neon|Fly|Ride"] = 360.94, ["Mega"] = 753.51, ["Mega|Fly|Ride"] = 837.96}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 1010.63, ["Fly"] = 1194.38, ["Ride"] = 1034.25, ["Fly|Ride"] = 1164.19, ["Neon"] = 4330.88, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2887.5, ["Mega"] = 9959.83, ["Mega|Fly|Ride"] = 7875}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 14.32, ["Ride"] = 59.07, ["Fly|Ride"] = 196.77, ["Neon"] = 160.23, ["Neon|Fly"] = 720.57, ["Neon|Ride"] = 216.54, ["Mega"] = 466.74, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 518.26}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 52.46, ["Ride"] = 21.46, ["Fly|Ride"] = 72.19, ["Neon"] = 9.19, ["Neon|Fly"] = 101.42, ["Neon|Ride"] = 29.75, ["Neon|Fly|Ride"] = 68.25, ["Mega"] = 52.49, ["Mega|Ride"] = 100.03, ["Mega|Fly|Ride"] = 162.74}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 10.5, ["Ride"] = 131.25, ["Fly|Ride"] = 393.75, ["Neon"] = 77.44, ["Neon|Fly|Ride"] = 542.51, ["Mega"] = 288.74, ["Mega|Ride"] = 430.71, ["Mega|Fly|Ride"] = 393.64}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Fly|Ride"] = 53.86, ["Neon"] = 2.1, ["Neon|Fly"] = 29.25, ["Neon|Ride"] = 27.89, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 15.42, ["Mega|Ride"] = 39.45, ["Mega|Fly|Ride"] = 123.71}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 52.12, ["Ride"] = 95.01, ["Fly|Ride"] = 274.32, ["Neon"] = 228.37, ["Neon|Fly"] = 354.38, ["Neon|Ride"] = 270.74, ["Neon|Fly|Ride"] = 436.7, ["Mega"] = 946.46, ["Mega|Ride"] = 818.61, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 16.25, ["Ride"] = 72.55, ["Fly|Ride"] = 861.46, ["Neon"] = 145.01, ["Neon|Ride"] = 276.08, ["Neon|Fly|Ride"] = 525, ["Mega"] = 577.49, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 605.98}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 43.32, ["Neon"] = 16.69, ["Neon|Ride"] = 45.48, ["Neon|Fly|Ride"] = 209.99, ["Mega"] = 98.47, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 14.43, ["Fly"] = 52.49, ["Ride"] = 39.38, ["Fly|Ride"] = 94.5, ["Neon"] = 78.75, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 578.19, ["Mega"] = 393.75, ["Mega|Ride"] = 1082.61, ["Mega|Fly|Ride"] = 861}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 4.26, ["Fly"] = 86.62, ["Ride"] = 28.87, ["Fly|Ride"] = 64.32, ["Neon"] = 25.53, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 48.87, ["Neon|Fly|Ride"] = 145.09, ["Mega"] = 434.81, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 430.5}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 35.19, ["Ride"] = 120.18, ["Neon"] = 541.31, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 682.5, ["Mega"] = 2526.78, ["Mega|Ride"] = 1840.19, ["Mega|Fly|Ride"] = 2051.88}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 6.29, ["Ride"] = 49.38, ["Fly|Ride"] = 131.25, ["Neon"] = 19.02, ["Neon|Ride"] = 77.14, ["Neon|Fly|Ride"] = 147, ["Mega"] = 86.62, ["Mega|Ride"] = 103.95, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 6.33, ["Fly"] = 36.83, ["Ride"] = 22.32, ["Fly|Ride"] = 58.48, ["Neon"] = 85.55, ["Neon|Fly"] = 188.41, ["Neon|Ride"] = 63.98, ["Neon|Fly|Ride"] = 109.15, ["Mega"] = 337.32, ["Mega|Ride"] = 287.44, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 114.16, ["Fly"] = 164.07, ["Ride"] = 154.88, ["Fly|Ride"] = 211.32, ["Neon"] = 601.02, ["Neon|Ride"] = 524.99, ["Neon|Fly|Ride"] = 557.82, ["Mega|Ride"] = 1853.51, ["Mega|Fly|Ride"] = 1884.09}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 35.28, ["Ride"] = 19.3, ["Fly|Ride"] = 36.45, ["Neon"] = 13.1, ["Neon|Fly"] = 57.72, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 68.25, ["Mega"] = 130.94, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 33.34, ["Fly"] = 99.75, ["Ride"] = 90.95, ["Fly|Ride"] = 1205.76, ["Neon"] = 155.71, ["Neon|Ride"] = 279.33, ["Neon|Fly|Ride"] = 346.44, ["Mega"] = 656.25, ["Mega|Ride"] = 606.26, ["Mega|Fly|Ride"] = 635.5}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.89, ["Ride"] = 15.98, ["Fly|Ride"] = 64.31, ["Neon"] = 2.1, ["Neon|Fly"] = 28.31, ["Neon|Ride"] = 16.05, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 15.06, ["Mega|Fly"] = 48, ["Mega|Ride"] = 30.77, ["Mega|Fly|Ride"] = 74.1}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 29.25, ["Neon"] = 7.76, ["Neon|Fly|Ride"] = 134.27, ["Mega"] = 33.57, ["Mega|Fly"] = 131.24, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 147.62}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 3.93, ["Fly"] = 36.82, ["Ride"] = 31.42, ["Fly|Ride"] = 173.37, ["Neon"] = 18.43, ["Neon|Ride"] = 58.48, ["Neon|Fly|Ride"] = 173.22, ["Mega"] = 105, ["Mega|Ride"] = 287.56, ["Mega|Fly|Ride"] = 246.75}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 52.46, ["Fly|Ride"] = 656.25, ["Neon"] = 173.24, ["Neon|Ride"] = 328.44, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 548.56, ["Mega|Ride"] = 705.87}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 17.34, ["Fly|Ride"] = 39.38, ["Neon"] = 14.78, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 25.6, ["Neon|Fly|Ride"] = 63.84, ["Mega"] = 105, ["Mega|Fly"] = 267.23, ["Mega|Ride"] = 129.55, ["Mega|Fly|Ride"] = 170.52}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 10.22, ["Fly"] = 43.33, ["Ride"] = 28.75, ["Fly|Ride"] = 101.78, ["Neon"] = 57.58, ["Neon|Fly"] = 128.84, ["Neon|Ride"] = 73.49, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 497.95, ["Mega|Ride"] = 299.25, ["Mega|Fly|Ride"] = 416.07}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 3.76, ["Fly"] = 27.33, ["Ride"] = 18.26, ["Fly|Ride"] = 84.47, ["Neon"] = 7.48, ["Neon|Fly"] = 98.43, ["Neon|Ride"] = 27.28, ["Neon|Fly|Ride"] = 62.37, ["Mega"] = 65.62, ["Mega|Fly"] = 105, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 144.36}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 10.46, ["Fly"] = 162.39, ["Ride"] = 32.48, ["Fly|Ride"] = 217.3, ["Neon"] = 45.92, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 215.45, ["Mega"] = 346.44, ["Mega|Ride"] = 361.59, ["Mega|Fly|Ride"] = 370.48}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 6.29, ["Ride"] = 190.21, ["Fly|Ride"] = 210, ["Neon"] = 65.26, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 110.43, ["Mega"] = 157.5, ["Mega|Ride"] = 319.38, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 4.5, ["Fly"] = 58.48, ["Ride"] = 17.05, ["Fly|Ride"] = 52.49, ["Neon"] = 30.08, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 41.58, ["Neon|Fly|Ride"] = 122.8, ["Mega"] = 194.25, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 240.38, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 25.94, ["Ride"] = 19.02, ["Fly|Ride"] = 36.75, ["Neon"] = 18.39, ["Neon|Fly"] = 70.51, ["Neon|Ride"] = 29.27, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 99.75, ["Mega|Ride"] = 145.69, ["Mega|Fly|Ride"] = 272.84}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 190.32, ["Fly"] = 393.75, ["Ride"] = 262.5, ["Fly|Ride"] = 388.5, ["Neon"] = 1332.52, ["Neon|Ride"] = 1429.2, ["Neon|Fly|Ride"] = 1174.69, ["Mega"] = 4264.74, ["Mega|Fly|Ride"] = 4428.51}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 5.44, ["Ride"] = 114.17, ["Neon"] = 40.69, ["Mega"] = 123.38, ["Mega|Ride"] = 657.17}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.72, ["Fly"] = 108.27, ["Ride"] = 24.78, ["Fly|Ride"] = 61.72, ["Neon"] = 41.55, ["Neon|Fly"] = 259.84, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 147.69, ["Mega"] = 258.19, ["Mega|Ride"] = 283.49, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 7.31, ["Fly|Ride"] = 722.11, ["Neon"] = 49.88, ["Neon|Ride"] = 246.04, ["Neon|Fly|Ride"] = 649.65, ["Mega"] = 603.75, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 433.06}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 16.25, ["Ride"] = 15.62, ["Fly|Ride"] = 32.43, ["Neon"] = 2.63, ["Neon|Fly"] = 29.25, ["Neon|Ride"] = 18.33, ["Neon|Fly|Ride"] = 38.07, ["Mega"] = 17.47, ["Mega|Fly"] = 59.07, ["Mega|Ride"] = 37.9, ["Mega|Fly|Ride"] = 78.74}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 3.3, ["Fly"] = 59.62, ["Ride"] = 15.74, ["Fly|Ride"] = 55.22, ["Neon"] = 23.42, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 107.61, ["Mega"] = 112.6, ["Mega|Fly"] = 173.22, ["Mega|Ride"] = 165.33, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.37, ["Ride"] = 126.06, ["Neon"] = 10.49, ["Neon|Ride"] = 289.1, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 102.38, ["Mega|Ride"] = 207.9, ["Mega|Fly|Ride"] = 357.28}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 74.81, ["Fly"] = 105, ["Ride"] = 84.93, ["Fly|Ride"] = 129.94, ["Neon"] = 420, ["Neon|Ride"] = 345.19, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 2887.62, ["Mega|Ride"] = 3610.01, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.77, ["Fly"] = 105, ["Ride"] = 23.63, ["Fly|Ride"] = 141.74, ["Neon"] = 12.99, ["Neon|Ride"] = 73.82, ["Neon|Fly|Ride"] = 142.92, ["Mega"] = 166.69, ["Mega|Ride"] = 383.97, ["Mega|Fly|Ride"] = 722.11}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 43.33, ["Neon"] = 7.59, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 289.06, ["Mega"] = 69.68, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 128.84, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 40.42, ["Fly"] = 163.74, ["Ride"] = 78.75, ["Fly|Ride"] = 194.87, ["Neon"] = 144.99, ["Neon|Ride"] = 162.75, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 413.44, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 13, ["Fly|Ride"] = 32.81, ["Neon"] = 2.63, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 19.37, ["Neon|Fly|Ride"] = 41.99, ["Mega"] = 18.47, ["Mega|Fly"] = 52.49, ["Mega|Ride"] = 30.72, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 3.56, ["Neon|Ride"] = 46.3, ["Neon|Fly|Ride"] = 101.39, ["Mega"] = 24.59, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 61.66, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.56, ["Ride"] = 45.94, ["Neon"] = 10.48, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 109.33, ["Mega"] = 97.13, ["Mega|Fly"] = 188.36, ["Mega|Ride"] = 114.43, ["Mega|Fly|Ride"] = 216.89}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 3.85, ["Fly"] = 72.55, ["Ride"] = 43.32, ["Fly|Ride"] = 114.34, ["Neon"] = 23.63, ["Neon|Fly"] = 85.31, ["Neon|Ride"] = 75.79, ["Neon|Fly|Ride"] = 160.23, ["Mega"] = 85.32, ["Mega|Fly"] = 199.63, ["Mega|Ride"] = 144.37, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 20.65, ["Ride"] = 14.18, ["Fly|Ride"] = 32.3, ["Neon"] = 2.22, ["Neon|Fly"] = 21.68, ["Neon|Ride"] = 18.26, ["Neon|Fly|Ride"] = 41.99, ["Mega"] = 19.04, ["Mega|Ride"] = 50.67, ["Mega|Fly|Ride"] = 177.22}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 20.9, ["Fly"] = 127.76, ["Ride"] = 71.96, ["Neon"] = 202.43, ["Neon|Fly"] = 145.09, ["Neon|Ride"] = 194.87, ["Neon|Fly|Ride"] = 866.09, ["Mega"] = 588.44, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 866.09}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2099.98, ["Fly"] = 2814.74, ["Ride"] = 2100, ["Fly|Ride"] = 2243.07, ["Neon|Fly|Ride"] = 7415.63, ["Mega|Fly|Ride"] = 44927.4}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 31.44, ["Ride"] = 19.69, ["Fly|Ride"] = 32.82, ["Neon"] = 8.29, ["Neon|Fly"] = 49.87, ["Neon|Ride"] = 21.87, ["Neon|Fly|Ride"] = 62.3, ["Mega"] = 65.63, ["Mega|Fly"] = 477.43, ["Mega|Ride"] = 115.65, ["Mega|Fly|Ride"] = 163.7}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.39, ["Ride"] = 65.63, ["Neon"] = 11.34, ["Mega"] = 82.43, ["Mega|Fly"] = 441, ["Mega|Ride"] = 124.58, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 19.58, ["Fly"] = 105, ["Ride"] = 29.25, ["Fly|Ride"] = 133.88, ["Neon"] = 128.63, ["Neon|Ride"] = 76.1, ["Neon|Fly|Ride"] = 291.38, ["Mega"] = 431.82, ["Mega|Ride"] = 412.13, ["Mega|Fly|Ride"] = 567.82}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 28.59, ["Fly"] = 137.51, ["Ride"] = 70.79, ["Neon"] = 187.94, ["Neon|Ride"] = 138.13, ["Neon|Fly|Ride"] = 289.06, ["Mega"] = 669.18, ["Mega|Ride"] = 861.08, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 141.14, ["Fly"] = 548.42, ["Ride"] = 169.2, ["Fly|Ride"] = 253.34, ["Neon"] = 713.44, ["Neon|Ride"] = 510.57, ["Neon|Fly|Ride"] = 576.19, ["Mega"] = 6495.54, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 4.33, ["Ride"] = 31.5, ["Fly|Ride"] = 677.25, ["Neon"] = 22.32, ["Neon|Ride"] = 72.55, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 145.09, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 380.01}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.52, ["Ride"] = 88.78, ["Neon"] = 22.28, ["Neon|Ride"] = 115.5, ["Mega"] = 179.81, ["Mega|Fly|Ride"] = 526.72}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 101.77, ["Ride"] = 25.99, ["Fly|Ride"] = 50.9, ["Neon"] = 7.65, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 68.39, ["Mega|Ride"] = 104.9, ["Mega|Fly|Ride"] = 265.09}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 19.02, ["Ride"] = 84, ["Fly|Ride"] = 131.25, ["Neon"] = 164.84, ["Neon|Ride"] = 1234.34, ["Neon|Fly|Ride"] = 364.88, ["Mega"] = 578.11, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 429.85}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.62, ["Neon|Ride"] = 49.22, ["Mega"] = 20.68, ["Mega|Ride"] = 576.19, ["Mega|Fly|Ride"] = 145.09}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 99.02, ["Fly"] = 820.52, ["Ride"] = 98.44, ["Fly|Ride"] = 170.63, ["Neon"] = 346.5, ["Neon|Fly"] = 463.36, ["Neon|Ride"] = 415.66, ["Neon|Fly|Ride"] = 542.51, ["Mega"] = 3247.77, ["Mega|Ride"] = 1155.15, ["Mega|Fly|Ride"] = 1515.64}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Fly"] = 41.86, ["Ride"] = 36.83, ["Neon"] = 16.42, ["Neon|Ride"] = 164.19, ["Neon|Fly|Ride"] = 102.92, ["Mega"] = 68.76, ["Mega|Ride"] = 289.06}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 39.38, ["Fly"] = 83.61, ["Ride"] = 90.19, ["Fly|Ride"] = 152.54, ["Neon"] = 234.94, ["Neon|Ride"] = 265.13, ["Neon|Fly|Ride"] = 511.88, ["Mega"] = 2022.05, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 58.48, ["Ride"] = 19.06, ["Fly|Ride"] = 50.5, ["Neon"] = 5.01, ["Neon|Fly"] = 82.43, ["Neon|Ride"] = 36.83, ["Neon|Fly|Ride"] = 83.97, ["Mega"] = 86.62, ["Mega|Fly"] = 492.29, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Ride"] = 28.17, ["Neon"] = 7.88, ["Neon|Ride"] = 87.94, ["Mega"] = 36.74, ["Mega|Ride"] = 137.71, ["Mega|Fly|Ride"] = 428.72}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 3.65, ["Fly"] = 72.55, ["Ride"] = 24.06, ["Fly|Ride"] = 90.99, ["Neon"] = 26.24, ["Neon|Fly"] = 108.27, ["Neon|Ride"] = 82.43, ["Mega"] = 131.25, ["Mega|Ride"] = 216.54, ["Mega|Fly|Ride"] = 433.06}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 310.55, ["Fly"] = 738.09, ["Ride"] = 367.48, ["Fly|Ride"] = 489.67, ["Neon"] = 853.12, ["Neon|Ride"] = 923.99, ["Neon|Fly|Ride"] = 853.13, ["Mega"] = 2302.12, ["Mega|Ride"] = 2676.18, ["Mega|Fly|Ride"] = 3772.84}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 32.47, ["Fly"] = 57.84, ["Ride"] = 44.63, ["Fly|Ride"] = 91.86, ["Neon"] = 161.42, ["Neon|Ride"] = 143.07, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 1011.15, ["Mega|Fly"] = 2773.85, ["Mega|Fly|Ride"] = 1067.32}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 64.97, ["Ride"] = 30.19, ["Fly|Ride"] = 116.82, ["Neon"] = 17.06, ["Neon|Fly"] = 101.07, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 131.06, ["Mega"] = 170.63, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 314.79}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 20.98, ["Fly"] = 273.45, ["Ride"] = 72.19, ["Fly|Ride"] = 227.06, ["Neon"] = 65.63, ["Neon|Fly"] = 433.06, ["Neon|Ride"] = 119.01, ["Neon|Fly|Ride"] = 245.44, ["Mega"] = 511.88, ["Mega|Fly"] = 1012.41, ["Mega|Ride"] = 337.49, ["Mega|Fly|Ride"] = 451.5}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 7.65, ["Ride"] = 15.75, ["Neon"] = 164.84, ["Neon|Ride"] = 123.08, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 656.92, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 314.98}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 2.58, ["Ride"] = 21.68, ["Fly|Ride"] = 94.21, ["Neon"] = 12.48, ["Neon|Ride"] = 157.49, ["Mega"] = 43.2, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 342}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 3.39, ["Fly"] = 19.69, ["Ride"] = 18.16, ["Fly|Ride"] = 63, ["Neon"] = 59.03, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 250.68, ["Mega"] = 574.72, ["Mega|Ride"] = 340.15, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 97.13, ["Fly"] = 246.15, ["Ride"] = 128.63, ["Fly|Ride"] = 183.75, ["Neon"] = 575.09, ["Neon|Ride"] = 571.05, ["Neon|Fly|Ride"] = 524.99, ["Mega"] = 2887.5, ["Mega|Ride"] = 3280.67, ["Mega|Fly|Ride"] = 2178.75}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 19.56, ["Ride"] = 65.8, ["Fly|Ride"] = 85.32, ["Neon"] = 129.04, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 322.63, ["Mega"] = 635.5, ["Mega|Ride"] = 649.59, ["Mega|Fly|Ride"] = 722.11}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2077.69, ["Fly"] = 1968.75, ["Ride"] = 1837.5, ["Fly|Ride"] = 1995, ["Neon"] = 11546.59, ["Neon|Ride"] = 7876.05, ["Neon|Fly|Ride"] = 6928.58, ["Mega|Fly|Ride"] = 25592.44}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 8.39, ["Fly"] = 131250, ["Ride"] = 39.38, ["Fly|Ride"] = 196.67, ["Neon"] = 101.78, ["Neon|Ride"] = 93.12, ["Neon|Fly|Ride"] = 323.71, ["Mega"] = 223.17, ["Mega|Fly"] = 895.31, ["Mega|Ride"] = 587.9, ["Mega|Fly|Ride"] = 545.74}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 6.09, ["Fly"] = 722.11, ["Ride"] = 34.12, ["Fly|Ride"] = 111.07, ["Neon"] = 31.18, ["Neon|Ride"] = 72.45, ["Mega"] = 236.25, ["Mega|Ride"] = 505.59, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 902.89, ["Fly"] = 1123.12, ["Ride"] = 904.3, ["Fly|Ride"] = 944.99, ["Neon"] = 2778.57, ["Neon|Ride"] = 2231.25, ["Neon|Fly|Ride"] = 2756.25, ["Mega|Ride"] = 13941.84, ["Mega|Fly|Ride"] = 11114.94}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 31.61, ["Ride"] = 61.39, ["Fly|Ride"] = 105, ["Neon"] = 225.2, ["Neon|Ride"] = 328.47, ["Neon|Fly|Ride"] = 259.84, ["Mega"] = 653.61, ["Mega|Ride"] = 865.98, ["Mega|Fly|Ride"] = 792.11}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.1, ["Ride"] = 23.62, ["Fly|Ride"] = 128.15, ["Neon"] = 15.51, ["Neon|Fly"] = 164.92, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 236.25, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Ride"] = 144.21, ["Neon"] = 3.6, ["Neon|Ride"] = 52.41, ["Mega"] = 30.44, ["Mega|Ride"] = 70.91, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 90.57, ["Ride"] = 144.37, ["Fly|Ride"] = 216.54, ["Neon"] = 459.38, ["Neon|Ride"] = 615.06, ["Neon|Fly|Ride"] = 656.87, ["Mega"] = 2461.27, ["Mega|Fly|Ride"] = 2446.66}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Fly|Ride"] = 70.14, ["Neon"] = 12.6, ["Neon|Fly"] = 72.19, ["Neon|Ride"] = 40.74, ["Mega"] = 91.88, ["Mega|Ride"] = 164.85}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 68.58, ["Ride"] = 106.32, ["Neon"] = 649.65, ["Neon|Ride"] = 592.19, ["Neon|Fly|Ride"] = 519.66, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 7.4, ["Fly"] = 105, ["Ride"] = 120.17, ["Fly|Ride"] = 129.93, ["Neon"] = 32.47, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 269.05, ["Mega"] = 446.25, ["Mega|Ride"] = 317.7, ["Mega|Fly|Ride"] = 402.73}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 275.62, ["Ride"] = 314.35, ["Fly|Ride"] = 384.57, ["Neon"] = 1186.54, ["Neon|Ride"] = 8660.72, ["Neon|Fly|Ride"] = 929.25, ["Mega|Fly|Ride"] = 4183.14}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.52, ["Fly"] = 65.63, ["Ride"] = 20.32, ["Fly|Ride"] = 115.5, ["Neon"] = 36.82, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 43.19, ["Neon|Fly|Ride"] = 145.06, ["Mega|Ride"] = 591.29, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 18.13, ["Ride"] = 16.21, ["Fly|Ride"] = 39.36, ["Neon"] = 5.19, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 23.47, ["Neon|Fly|Ride"] = 51.97, ["Mega"] = 48.57, ["Mega|Ride"] = 58.46, ["Mega|Fly|Ride"] = 116.88}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1015.87, ["Ride"] = 1260, ["Fly|Ride"] = 1260.52, ["Neon|Ride"] = 7939.71, ["Neon|Fly|Ride"] = 7712.36, ["Mega"] = 24612.59}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 24.55, ["Fly"] = 137.85, ["Ride"] = 94.5, ["Fly|Ride"] = 323.71, ["Neon"] = 85.32, ["Neon|Ride"] = 314.98, ["Neon|Fly|Ride"] = 540.22, ["Mega"] = 578.11, ["Mega|Ride"] = 533.07, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 6.36, ["Fly"] = 54.14, ["Ride"] = 38.07, ["Fly|Ride"] = 59.05, ["Neon"] = 26.48, ["Neon|Ride"] = 58.48, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 189.5, ["Mega|Ride"] = 164.78, ["Mega|Fly|Ride"] = 253.21}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 35.43, ["Fly"] = 32.81, ["Ride"] = 35.44, ["Fly|Ride"] = 59.06, ["Neon"] = 149.63, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 2598.22, ["Mega|Ride"] = 909.39, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 13.99, ["Fly"] = 62.91, ["Ride"] = 31.4, ["Fly|Ride"] = 70.74, ["Neon"] = 59.09, ["Neon|Ride"] = 86.62, ["Neon|Fly|Ride"] = 196.83, ["Mega"] = 367.5, ["Mega|Ride"] = 333.06, ["Mega|Fly|Ride"] = 821.63}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 90.56, ["Ride"] = 157.5, ["Fly|Ride"] = 644.01, ["Neon"] = 439.69, ["Neon|Ride"] = 524.99, ["Mega|Ride"] = 995.99, ["Mega|Fly|Ride"] = 1113}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Neon"] = 2.63, ["Neon|Fly"] = 58.48, ["Neon|Ride"] = 115.31, ["Neon|Fly|Ride"] = 98.53, ["Mega"] = 17.73, ["Mega|Fly"] = 77.97, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 218.98}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 129.85, ["Fly"] = 183.75, ["Ride"] = 173.25, ["Fly|Ride"] = 268.5, ["Neon"] = 588, ["Neon|Ride"] = 616.77, ["Neon|Fly|Ride"] = 630, ["Mega"] = 3463.88, ["Mega|Fly|Ride"] = 2073.91}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 3.14, ["Fly"] = 748.35, ["Ride"] = 20.44, ["Fly|Ride"] = 70.86, ["Neon"] = 229.67, ["Neon|Ride"] = 83.99, ["Mega"] = 773.71, ["Mega|Ride"] = 440.35, ["Mega|Fly|Ride"] = 490.88}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 18.38, ["Fly|Ride"] = 39.35, ["Neon"] = 14.44, ["Neon|Fly"] = 82.48, ["Neon|Ride"] = 65.54, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 280.67}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.1, ["Ride"] = 129.94, ["Neon"] = 7.88, ["Neon|Fly"] = 142.93, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 214.86, ["Mega"] = 86.62}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 144.37, ["Fly"] = 205.46, ["Ride"] = 196.87, ["Fly|Ride"] = 328.13, ["Neon"] = 568.54, ["Neon|Ride"] = 902.94, ["Neon|Fly|Ride"] = 771.74, ["Mega"] = 1731.07, ["Mega|Ride"] = 1981.37, ["Mega|Fly|Ride"] = 1826.34}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 5.07, ["Ride"] = 131.25, ["Neon"] = 26.02, ["Neon|Ride"] = 78.75, ["Mega"] = 126.88, ["Mega|Ride"] = 158.08, ["Mega|Fly|Ride"] = 432.99}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 27.54, ["Neon"] = 2.34, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 24.92, ["Mega"] = 17.07, ["Mega|Fly|Ride"] = 157.49}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 101.24, ["Ride"] = 26.21, ["Fly|Ride"] = 145.1, ["Neon"] = 2.63, ["Neon|Fly"] = 86.2, ["Neon|Ride"] = 22.31, ["Mega"] = 18.61, ["Mega|Fly"] = 58.48, ["Mega|Ride"] = 58.48, ["Mega|Fly|Ride"] = 128.63}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 36.75, ["Ride"] = 16.04, ["Fly|Ride"] = 50.59, ["Neon"] = 6.56, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 59.07, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 156.19}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 19.68, ["Fly|Ride"] = 91.88, ["Neon"] = 10.4, ["Mega"] = 144.27, ["Mega|Ride"] = 160.23, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 14.44, ["Fly|Ride"] = 41.88, ["Neon"] = 12.9, ["Neon|Fly"] = 86.62, ["Neon|Ride"] = 40.95, ["Neon|Fly|Ride"] = 77.67, ["Mega"] = 328.44, ["Mega|Ride"] = 94.21, ["Mega|Fly|Ride"] = 164.85}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 58.67, ["Ride"] = 129.92, ["Fly|Ride"] = 289.06, ["Neon"] = 229.66, ["Neon|Ride"] = 362.88, ["Neon|Fly|Ride"] = 635.43, ["Mega"] = 787.5, ["Mega|Ride"] = 780.17, ["Mega|Fly|Ride"] = 885.94}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 16.25, ["Ride"] = 17.5, ["Fly|Ride"] = 32.82, ["Neon"] = 3.71, ["Neon|Fly"] = 19.52, ["Neon|Ride"] = 19.35, ["Neon|Fly|Ride"] = 46.69, ["Mega"] = 15.59, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 97.02}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 11.8, ["Fly"] = 58.97, ["Ride"] = 23.62, ["Fly|Ride"] = 76.12, ["Neon"] = 36.38, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 123.43, ["Mega"] = 242.82, ["Mega|Fly"] = 397.69, ["Mega|Ride"] = 246.75, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 21.63, ["Fly"] = 64.32, ["Ride"] = 51.19, ["Fly|Ride"] = 98.44, ["Neon"] = 207.37, ["Neon|Fly"] = 215.38, ["Neon|Ride"] = 149.63, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 454.13, ["Mega|Ride"] = 866.09, ["Mega|Fly|Ride"] = 767.82}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 10.49, ["Fly"] = 209.99, ["Neon"] = 105, ["Mega"] = 517.5, ["Mega|Ride"] = 490.88, ["Mega|Fly|Ride"] = 820.52}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.43, ["Ride"] = 15.75, ["Fly|Ride"] = 36.83, ["Neon"] = 5.24, ["Neon|Fly"] = 29.25, ["Neon|Ride"] = 19.08, ["Neon|Fly|Ride"] = 55.11, ["Mega"] = 38.57, ["Mega|Ride"] = 62.81, ["Mega|Fly|Ride"] = 103.85}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 14.23, ["Ride"] = 98.19, ["Neon"] = 110.24, ["Neon|Ride"] = 204.75, ["Neon|Fly|Ride"] = 1168.13, ["Mega"] = 531.78, ["Mega|Fly"] = 735, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 878.07, ["Ride"] = 943.69, ["Fly|Ride"] = 1036.88, ["Neon"] = 2491.13, ["Neon|Ride"] = 2743.3, ["Neon|Fly|Ride"] = 2231.25, ["Mega|Fly|Ride"] = 6168.75}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 216.36, ["Ride"] = 314.99, ["Fly|Ride"] = 492.07, ["Neon"] = 840, ["Neon|Ride"] = 965.68, ["Neon|Fly|Ride"] = 1043.44, ["Mega"] = 5412.96, ["Mega|Ride"] = 3869.19, ["Mega|Fly|Ride"] = 3522.75}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.63, ["Ride"] = 52.49, ["Neon"] = 6.46, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 287.99, ["Mega"] = 65.63, ["Mega|Fly|Ride"] = 1154.99}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 170.62, ["Ride"] = 249.38, ["Fly|Ride"] = 350.44, ["Neon"] = 857.42, ["Neon|Ride"] = 786.19, ["Neon|Fly|Ride"] = 813.75, ["Mega|Ride"] = 2421.58, ["Mega|Fly|Ride"] = 2235.73}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.88, ["Ride"] = 24.36, ["Fly|Ride"] = 82.48, ["Neon"] = 18.12, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 38.88, ["Neon|Fly|Ride"] = 145.06, ["Mega"] = 115.96, ["Mega|Ride"] = 492.07, ["Mega|Fly|Ride"] = 282.19}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 241.5, ["Fly"] = 432.99, ["Ride"] = 262.5, ["Fly|Ride"] = 428.72, ["Neon|Ride"] = 1588.17, ["Neon|Fly|Ride"] = 1279.36, ["Mega|Fly|Ride"] = 4116.65}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 78.75, ["Ride"] = 24.94, ["Fly|Ride"] = 118.13, ["Neon"] = 26.23, ["Neon|Ride"] = 58.08, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 152.91, ["Mega|Fly"] = 362.63}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 41.62, ["Mega"] = 231, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 402.69}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 14.44, ["Fly"] = 52.5, ["Ride"] = 68.13, ["Fly|Ride"] = 145.09, ["Neon"] = 135.12, ["Neon|Fly"] = 433.11, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 525, ["Mega"] = 856.32, ["Mega|Ride"] = 722.54, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 58.48, ["Neon"] = 23.62, ["Neon|Ride"] = 196.88, ["Mega"] = 246.04, ["Mega|Ride"] = 245.76, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 17.06, ["Ride"] = 13.97, ["Fly|Ride"] = 28.75, ["Neon"] = 3.81, ["Neon|Fly"] = 21.6, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 39.6, ["Mega"] = 31.49, ["Mega|Fly"] = 55.13, ["Mega|Ride"] = 36.95, ["Mega|Fly|Ride"] = 108.26}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4200, ["Ride"] = 4593.74, ["Fly|Ride"] = 4095, ["Neon"] = 32477.64, ["Neon|Fly|Ride"] = 24536.11, ["Mega|Fly|Ride"] = 59062.5}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 8.13, ["Fly"] = 86.62, ["Ride"] = 42.37, ["Neon"] = 99.74, ["Neon|Fly"] = 385.42, ["Neon|Ride"] = 101.66, ["Neon|Fly|Ride"] = 189.47, ["Mega"] = 216.57, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.62, ["Fly"] = 26.25, ["Ride"] = 18.33, ["Fly|Ride"] = 49.54, ["Neon"] = 14.44, ["Neon|Fly"] = 45.93, ["Neon|Ride"] = 32.45, ["Neon|Fly|Ride"] = 84, ["Mega"] = 144.37, ["Mega|Ride"] = 210.05, ["Mega|Fly|Ride"] = 242.18}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 367.5, ["Fly"] = 548.88, ["Ride"] = 427.88, ["Fly|Ride"] = 506.63, ["Neon"] = 2022.29, ["Neon|Ride"] = 1292.81, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 6027, ["Mega|Fly|Ride"] = 5114.82}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 6.29, ["Ride"] = 30.19, ["Neon"] = 21.68, ["Neon|Ride"] = 164.85, ["Mega"] = 140.74, ["Mega|Ride"] = 172.15, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.9, ["Fly"] = 189, ["Ride"] = 26.24, ["Neon"] = 72.07, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 590.63, ["Mega|Ride"] = 401.62, ["Mega|Fly|Ride"] = 488.25}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 72.55, ["Ride"] = 20.9, ["Fly|Ride"] = 65.62, ["Neon"] = 7.88, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 91.75, ["Mega"] = 45.02, ["Mega|Ride"] = 70.86, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 582.75, ["Fly"] = 881.13, ["Ride"] = 657.57, ["Fly|Ride"] = 722.11, ["Neon|Ride"] = 2126.25, ["Neon|Fly|Ride"] = 2099.99, ["Mega|Fly|Ride"] = 8877.24}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 11.7, ["Ride"] = 70.51, ["Fly|Ride"] = 345.18, ["Neon"] = 51.84, ["Neon|Fly"] = 160.23, ["Neon|Fly|Ride"] = 648.38, ["Mega"] = 233.89, ["Mega|Ride"] = 413.44, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 4.77, ["Fly"] = 43.13, ["Ride"] = 86, ["Fly|Ride"] = 115.86, ["Neon"] = 22.04, ["Neon|Ride"] = 80.13, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 168, ["Mega|Fly"] = 820.84, ["Mega|Ride"] = 179.03, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 3.61, ["Fly"] = 39.26, ["Ride"] = 20.89, ["Fly|Ride"] = 58.48, ["Neon"] = 14.43, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 86.62, ["Mega"] = 105, ["Mega|Fly|Ride"] = 190.31}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 21, ["Fly"] = 39.38, ["Ride"] = 39.81, ["Fly|Ride"] = 65.63, ["Neon"] = 89.25, ["Neon|Ride"] = 114.18, ["Mega"] = 608.93, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 1680}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 43.31, ["Neon"] = 5.25, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 101.78, ["Mega"] = 31.97, ["Mega|Fly"] = 115.86, ["Mega|Ride"] = 101.35, ["Mega|Fly|Ride"] = 221.82}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 645.65, ["Fly"] = 925.63, ["Ride"] = 551.25, ["Fly|Ride"] = 655.99, ["Neon|Ride"] = 2799.59, ["Neon|Fly|Ride"] = 2597.93, ["Mega|Ride"] = 9595.08, ["Mega|Fly|Ride"] = 7875}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.56, ["Ride"] = 55.75, ["Fly|Ride"] = 289.06, ["Neon"] = 12.86, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 203.43, ["Mega"] = 41.15, ["Mega|Fly"] = 246.04, ["Mega|Ride"] = 128.31, ["Mega|Fly|Ride"] = 216.71}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 52.4, ["Fly|Ride"] = 196.88, ["Neon"] = 7.87, ["Neon|Fly"] = 289.06, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 36.83, ["Mega|Ride"] = 120.21, ["Mega|Fly|Ride"] = 145.09}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Neon"] = 5.13, ["Neon|Ride"] = 57.74, ["Neon|Fly|Ride"] = 289.06, ["Mega"] = 40.67, ["Mega|Fly"] = 150.15, ["Mega|Ride"] = 93.12, ["Mega|Fly|Ride"] = 160.23}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 26.25, ["Neon"] = 15.75, ["Mega"] = 173.22, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 28.58, ["Fly"] = 82.69, ["Ride"] = 52.5, ["Fly|Ride"] = 179.62, ["Neon"] = 161.23, ["Neon|Ride"] = 255.46, ["Neon|Fly|Ride"] = 426.57, ["Mega"] = 1155, ["Mega|Ride"] = 560.81, ["Mega|Fly|Ride"] = 636.57}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 16.4, ["Ride"] = 66.94, ["Fly|Ride"] = 124.69, ["Neon"] = 89.24, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 443.63, ["Mega|Ride"] = 935.55, ["Mega|Fly|Ride"] = 755.52}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.55, ["Fly"] = 23.61, ["Ride"] = 15.75, ["Fly|Ride"] = 37.97, ["Neon"] = 18.37, ["Neon|Ride"] = 41.15, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 250.98, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 11.82, ["Ride"] = 39.38, ["Neon"] = 72.18, ["Neon|Ride"] = 189.45, ["Mega|Ride"] = 410.82}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 25.71, ["Fly|Ride"] = 111.56, ["Neon"] = 13, ["Neon|Ride"] = 54.16, ["Neon|Fly|Ride"] = 127.34, ["Mega"] = 91.88, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 287.86}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 17.72, ["Fly"] = 115.7, ["Ride"] = 32.81, ["Fly|Ride"] = 45.94, ["Neon"] = 98.44, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 168.67, ["Mega"] = 909.45, ["Mega|Fly|Ride"] = 719.25}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 32.42, ["Fly"] = 97.13, ["Neon"] = 183.75, ["Mega"] = 242.82, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 584.73}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 66.85, ["Fly"] = 86.16, ["Ride"] = 78.74, ["Fly|Ride"] = 188.4, ["Neon"] = 216.78, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 426.87, ["Mega"] = 2886.94, ["Mega|Fly|Ride"] = 1351.88}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 34.27, ["Fly"] = 145.06, ["Ride"] = 64.97, ["Fly|Ride"] = 123.03, ["Neon"] = 105, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 324.84, ["Mega"] = 507.94, ["Mega|Ride"] = 586.1, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 19.27, ["Ride"] = 64.32, ["Neon"] = 141.63, ["Neon|Ride"] = 218.68, ["Mega"] = 498.75, ["Mega|Ride"] = 449.58, ["Mega|Fly|Ride"] = 842.26}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 38.73, ["Fly"] = 131.12, ["Ride"] = 90.57, ["Fly|Ride"] = 266.48, ["Neon"] = 178.5, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 429.19, ["Mega"] = 945, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 1152.81}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 25.44, ["Ride"] = 15.75, ["Fly|Ride"] = 35.44, ["Neon"] = 5.24, ["Neon|Fly"] = 32.81, ["Neon|Ride"] = 19.59, ["Neon|Fly|Ride"] = 58.48, ["Mega"] = 40.25, ["Mega|Fly"] = 328.44, ["Mega|Ride"] = 60.09, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1246.88}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 157.49, ["Ride"] = 283.5, ["Fly|Ride"] = 378, ["Neon"] = 493.5, ["Neon|Ride"] = 483, ["Mega"] = 1643.38, ["Mega|Ride"] = 1818.76, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 83.91, ["Fly|Ride"] = 31.49, ["Neon"] = 3.94, ["Neon|Fly"] = 101.77, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 300.57, ["Mega"] = 36.39, ["Mega|Fly"] = 145.06, ["Mega|Ride"] = 70.8, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 30.44, ["Ride"] = 65.63, ["Neon"] = 122.78, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 398.58, ["Mega"] = 591.93, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 601.13}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.68, ["Neon|Fly|Ride"] = 145.09, ["Mega"] = 18.25}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.15, ["Neon|Ride"] = 52.5, ["Mega"] = 97.13, ["Mega|Ride"] = 115.86}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 105, ["Fly"] = 1805.77, ["Ride"] = 139.3, ["Fly|Ride"] = 223.13, ["Neon"] = 412.13, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 645.75, ["Mega|Ride"] = 6768.48, ["Mega|Fly|Ride"] = 2077.7}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 18.38, ["Fly|Ride"] = 47.24, ["Neon"] = 10.5, ["Neon|Ride"] = 32.31, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 101.77, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 217.88}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 36.18, ["Ride"] = 27.57, ["Fly|Ride"] = 66.94, ["Neon"] = 5.97, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 418.69, ["Mega"] = 36.74, ["Mega|Fly"] = 115.87, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 73.82, ["Neon"] = 8.6, ["Neon|Ride"] = 210, ["Mega"] = 98.42, ["Mega|Ride"] = 127.32}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.63, ["Neon"] = 11.8, ["Neon|Ride"] = 105, ["Mega"] = 118.13, ["Mega|Ride"] = 324.8}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 91.88, ["Ride"] = 289.06, ["Fly|Ride"] = 262.5, ["Neon"] = 560.33, ["Neon|Ride"] = 603.75, ["Neon|Fly|Ride"] = 909.08, ["Mega"] = 1837.5, ["Mega|Fly|Ride"] = 2575.13}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 8.58, ["Neon"] = 72.15, ["Mega"] = 426.57, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 649.59}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 419.99, ["Ride"] = 393.65, ["Fly|Ride"] = 682.5, ["Neon"] = 1069.69, ["Neon|Ride"] = 1065.23, ["Neon|Fly|Ride"] = 1224.57, ["Mega|Fly|Ride"] = 2756.25}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 70.88}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 45.94}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 18.47}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 15.73}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 54.94}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 124.69}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 11.54}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 6.57}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 194.91}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 14.22}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 32.48}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 9.93}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 8.74}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 1295.44}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 8.54}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 9.54}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 18.38}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 6.54}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 72.13}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 569.63}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 525}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 9.19}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1407.37}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 64.29}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 7.27}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 18.15}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 52.49}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 23.29}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 72.17}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 19.3}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 13.13}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 17.06}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 70.26}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.5}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 10.6}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 11.45}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 7.19}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.63}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 2022.29}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 105.63}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 262.18}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 5}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.63}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 9.71}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 9.72}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 32.48}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 301.88}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 9.19}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 8.69}},
    ["rbxassetid://1265129435"] = {name = "Gold Snowboard", prices = {["default"] = 156.76}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 165.46}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 36.74}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 9.43}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 26.16}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 7.58}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 105}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 28.88}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 9.19}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.63}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 23.89}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 9.71}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 6.38}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 26.85}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 104.99}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 344.32}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.63}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 8.6}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 11.71}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 27.56}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 111.55}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 25.99}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 17228.81}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 140.43}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 35.42}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 41.2}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 26.17}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 66.67}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 32.86}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 32.82}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 91.54}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 91.88}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 32.23}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 115.5}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 39.38}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 44.54}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 36.75}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 262.5}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 9.19}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 9.71}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 5.24}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 21}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 117.04}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.6}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 4.36}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 7.4}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 21.69}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 183.75}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 830.19}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 7.66}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 720.57}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 15.16}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.62}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 231}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 38.59}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 99.72}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 24.94}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 35.35}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 70.7}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 20.94}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.94}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 12.85}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.37}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 11.82}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 11.81}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 25.41}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.73}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.94}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 6.34}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 15.65}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 205.86}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 31.49}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.63}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 217.14}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 7.61}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 10.39}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 13.13}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 28.3}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 94.39}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 6.5}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 10.29}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 5.8}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 6.57}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 23}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 13.48}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 7.8}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 2.1}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 5.75}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 10.46}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 10.5}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.02}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 6.46}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 5.25}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 3.82}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 5.38}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 10.49}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 9187.5}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.44}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 11.74}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3.94}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 6.22}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 6.55}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.62}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 18.79}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 7.88}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 5.55}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 5.2}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 14.43}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 59.06}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 6.54}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 7.18}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 6.5}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.93}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 3937.5}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 17.07}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 58.08}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 6.43}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 84.84}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.41}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 5.2}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 144.38}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.36}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.1}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 4.34}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 4.25}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 6.22}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 21.67}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.26}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 3.92}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 24.94}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 6.56}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 3.94}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 4.46}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 3.89}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.37}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 32.82}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 4.66}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 11.68}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 141.75}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 68.25}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 5.25}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 3.94}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1368.41}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 52.4}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 9.08}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 186.36}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 35.44}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 6.46}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 7.88}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 20.24}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 6.14}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 16.01}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 15.74}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.19}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 12.78}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 6.01}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.49}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 13.13}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.28}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 3.21}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 16.25}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 7.97}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 129.92}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 26.25}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 3.81}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 110.22}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 15.65}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.41}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 23.63}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 22.03}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 3.46}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 6.21}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 7.42}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 6.27}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 6.12}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 68.72}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 3.51}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.63}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 157.4}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 15.93}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1195.98}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 3.66}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 188.97}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 4.86}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.83}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 12.28}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 55.13}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 4.55}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 3.14}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 4.94}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 4.35}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 69.3}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 9.18}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 104.99}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 8.89}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 57.52}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 5.66}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 56.43}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.57}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 15.75}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 3.94}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 10.4}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 15.44}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 118.01}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.63}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 86.28}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 3.75}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 5.14}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.24}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.6}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 51.27}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.6}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 50.25}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 64.96}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 74.82}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 6.57}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 45.93}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 3.14}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 143.07}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 2.52}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 9.86}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.52}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 27.3}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 65.43}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 22.32}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 43.31}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 4.24}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 2.58}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 10.04}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 22.32}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 83.72}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 20.87}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 3.68}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 11.82}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 35.43}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 3.36}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 3.14}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 28.88}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 2.37}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 101.35}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 77.44}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.37}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 45.46}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 32.53}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 2240.98}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 8.64}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 9.19}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 26.12}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.62}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 263.67}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 19.58}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 9.19}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 11.88}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 9.18}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 17.07}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 432.99}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 69.56}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 45.94}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 5.18}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 62.89}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 228.04}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 83.99}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1181.25}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 207.01}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 11.93}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1727.25}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 576.65}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 3.39}},
}
=====END_PRICES=====

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