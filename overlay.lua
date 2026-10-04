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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1259.25, ["Ride"] = 1179.94, ["Fly|Ride"] = 1584.95, ["Neon"] = 6878.26, ["Neon|Fly|Ride"] = 5028.16, ["Mega"] = 21610.42, ["Mega|Fly|Ride"] = 21610.42}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 472.5, ["Fly"] = 446.25, ["Ride"] = 504, ["Fly|Ride"] = 656.15, ["Neon|Fly|Ride"] = 2160.8, ["Mega"] = 10805.22, ["Mega|Fly|Ride"] = 8643.15}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 5975.66, ["Ride"] = 5250, ["Fly|Ride"] = 5211.84, ["Neon|Fly|Ride"] = 23744.32, ["Mega|Fly|Ride"] = 79229.43}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 196.27, ["Ride"] = 247.24, ["Fly|Ride"] = 401.92, ["Neon"] = 1147.2, ["Neon|Ride"] = 984.38, ["Neon|Fly|Ride"] = 931.88, ["Mega|Fly|Ride"] = 4912.47}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 485.63, ["Fly"] = 864.44, ["Ride"] = 542.7, ["Fly|Ride"] = 577.5, ["Neon|Fly|Ride"] = 1693.13, ["Mega|Fly|Ride"] = 5250}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 13.79, ["Ride"] = 58.97, ["Fly|Ride"] = 129.94, ["Neon"] = 101.61, ["Neon|Fly"] = 288.51, ["Neon|Ride"] = 101.35, ["Neon|Fly|Ride"] = 216.09, ["Mega"] = 357.33, ["Mega|Ride"] = 544.69, ["Mega|Fly|Ride"] = 599.82}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.94, ["Fly"] = 38.37, ["Ride"] = 26.16, ["Fly|Ride"] = 68.51, ["Neon"] = 32.82, ["Neon|Fly"] = 164.58, ["Neon|Ride"] = 59.93, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 155.93, ["Mega|Fly"] = 238.27, ["Mega|Ride"] = 197.75, ["Mega|Fly|Ride"] = 267.75}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 99.75, ["Fly"] = 216.09, ["Ride"] = 118.13, ["Fly|Ride"] = 262.5, ["Neon"] = 425.25, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 1728.85, ["Mega"] = 1586.82, ["Mega|Fly|Ride"] = 1830.43}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 37.2, ["Fly"] = 91.88, ["Ride"] = 43.22, ["Fly|Ride"] = 99.74, ["Neon"] = 275.63, ["Neon|Fly"] = 242.82, ["Neon|Ride"] = 246.88, ["Neon|Fly|Ride"] = 308.44, ["Mega"] = 2100, ["Mega|Ride"] = 1152.81, ["Mega|Fly|Ride"] = 879.38}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 26.17, ["Fly"] = 28.88, ["Ride"] = 35.43, ["Fly|Ride"] = 71.31, ["Neon"] = 262.5, ["Neon|Ride"] = 72.42, ["Neon|Fly|Ride"] = 199.68, ["Mega"] = 648.25, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 80.07, ["Fly"] = 216.09, ["Ride"] = 88.07, ["Fly|Ride"] = 288.48, ["Neon"] = 406.88, ["Neon|Ride"] = 321.57, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1575, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1386}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 65.63}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 347.82, ["Fly"] = 490.56, ["Ride"] = 350.83, ["Fly|Ride"] = 418.69, ["Neon"] = 1296.49, ["Neon|Ride"] = 1638.32, ["Neon|Fly|Ride"] = 1312.49, ["Mega|Fly|Ride"] = 3936.19}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 145.09, ["Fly"] = 144.8, ["Ride"] = 128.59, ["Fly|Ride"] = 183.75, ["Neon|Fly|Ride"] = 577.5, ["Mega"] = 4312.63, ["Mega|Fly|Ride"] = 2467.5}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 4.33, ["Fly"] = 83.15, ["Ride"] = 65.63, ["Fly|Ride"] = 223.13, ["Neon"] = 36.75, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 244.44, ["Mega"] = 160.02, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 345.74, ["Mega|Fly|Ride"] = 476.46}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 253, ["Fly"] = 237.39, ["Ride"] = 209.99, ["Fly|Ride"] = 263, ["Neon|Ride"] = 1402.69, ["Neon|Fly|Ride"] = 840, ["Mega|Fly|Ride"] = 2750.9}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.56, ["Fly"] = 23.62, ["Ride"] = 19.44, ["Fly|Ride"] = 54.05, ["Neon"] = 43.23, ["Neon|Fly"] = 129.68, ["Neon|Ride"] = 82.31, ["Neon|Fly|Ride"] = 101.06, ["Mega"] = 170.63, ["Mega|Ride"] = 231.23, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 178.12, ["Ride"] = 236.24, ["Fly|Ride"] = 358.94, ["Neon"] = 510.57, ["Neon|Ride"] = 617.68, ["Neon|Fly|Ride"] = 798.29, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 1559.25}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 47.24}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 80.12, ["Ride"] = 183.74, ["Fly|Ride"] = 245.64, ["Neon"] = 459.38, ["Neon|Fly|Ride"] = 523.69, ["Mega|Fly|Ride"] = 1871.25}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 39.38, ["Fly"] = 393.75, ["Ride"] = 83.58, ["Fly|Ride"] = 190.21, ["Neon"] = 262.5, ["Neon|Ride"] = 308.44, ["Neon|Fly|Ride"] = 431.15, ["Mega"] = 2825.01, ["Mega|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 1009.11}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 43.98, ["Fly"] = 75.89, ["Ride"] = 57.87, ["Fly|Ride"] = 104.89, ["Neon"] = 194.49, ["Neon|Ride"] = 194.15, ["Neon|Fly|Ride"] = 280.65, ["Mega"] = 1719.58, ["Mega|Fly|Ride"] = 899.13}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 40.55, ["Fly"] = 259.88, ["Ride"] = 85.32, ["Fly|Ride"] = 196.88, ["Neon"] = 259.34, ["Neon|Ride"] = 404.14, ["Neon|Fly|Ride"] = 519.75, ["Mega"] = 1967.44, ["Mega|Ride"] = 1441.26, ["Mega|Fly|Ride"] = 1667.99}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 32.64, ["Ride"] = 49.88, ["Fly|Ride"] = 125.36, ["Neon"] = 129.84, ["Neon|Ride"] = 162.75, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 1207.92, ["Mega|Fly|Ride"] = 1723.32}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 42.88, ["Ride"] = 80.76, ["Fly|Ride"] = 133.98, ["Neon"] = 259.31, ["Neon|Ride"] = 265.21, ["Neon|Fly|Ride"] = 322.88, ["Mega|Ride"] = 3241.58, ["Mega|Fly|Ride"] = 1147.08}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 11.81, ["Fly"] = 32.81, ["Ride"] = 24.48, ["Fly|Ride"] = 76.72, ["Neon"] = 40.8, ["Neon|Fly"] = 432.23, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 95.7, ["Mega"] = 209.61, ["Mega|Fly"] = 310.09, ["Mega|Ride"] = 196.55, ["Mega|Fly|Ride"] = 248.31}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 525, ["Ride"] = 489.86, ["Fly|Ride"] = 616.52, ["Neon|Ride"] = 1494.28, ["Neon|Fly|Ride"] = 1966.13, ["Mega"] = 10805.22, ["Mega|Fly|Ride"] = 9745.01}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 14.44, ["Ride"] = 31.5, ["Fly|Ride"] = 134.01, ["Neon"] = 219.19, ["Mega|Ride"] = 749.89, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 5.9, ["Fly"] = 34.55, ["Ride"] = 21.5, ["Fly|Ride"] = 47.15, ["Neon"] = 74.89, ["Neon|Ride"] = 76.13, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 324.19, ["Mega|Ride"] = 288.48, ["Mega|Fly|Ride"] = 360.1}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 72.03, ["Fly"] = 89.25, ["Ride"] = 91.23, ["Fly|Ride"] = 133.49, ["Neon"] = 427.85, ["Neon|Ride"] = 314.98, ["Neon|Fly|Ride"] = 389.82, ["Mega"] = 1311.45, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 13.13, ["Ride"] = 34.47, ["Fly|Ride"] = 66.94, ["Neon"] = 82.68, ["Neon|Ride"] = 115.08, ["Neon|Fly|Ride"] = 274.44, ["Mega"] = 720.57, ["Mega|Ride"] = 736.88, ["Mega|Fly|Ride"] = 568.37}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 224.18, ["Fly"] = 300.68, ["Ride"] = 236.28, ["Fly|Ride"] = 388.96, ["Neon"] = 822.86, ["Neon|Ride"] = 616.88, ["Neon|Fly|Ride"] = 767.82, ["Mega"] = 6483.14, ["Mega|Ride"] = 3937.5, ["Mega|Fly|Ride"] = 5401.97}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 27.55}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.73, ["Fly"] = 27.92, ["Ride"] = 22.32, ["Fly|Ride"] = 72.85, ["Neon"] = 28.11, ["Neon|Fly"] = 144.8, ["Neon|Ride"] = 57.74, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 288.48, ["Mega|Fly"] = 491.32, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 1048.69, ["Fly"] = 3281.25, ["Ride"] = 1050, ["Fly|Ride"] = 1441.26, ["Neon"] = 10083.43, ["Neon|Ride"] = 6339.43, ["Neon|Fly|Ride"] = 6481.28, ["Mega|Ride"] = 55271.57, ["Mega|Fly|Ride"] = 24308.82}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 23.89, ["Ride"] = 45.94, ["Fly|Ride"] = 105.99, ["Neon"] = 213.93, ["Neon|Ride"] = 265.8, ["Neon|Fly|Ride"] = 224.76, ["Mega"] = 1043.44, ["Mega|Fly|Ride"] = 820.31}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 234.72, ["Fly"] = 368.5, ["Ride"] = 263.82, ["Fly|Ride"] = 328.13, ["Neon"] = 1067.42, ["Neon|Ride"] = 982.5, ["Neon|Fly|Ride"] = 954.81, ["Mega"] = 4321.58, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 4035.28}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 37.93}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 15.65, ["Fly"] = 86.8, ["Ride"] = 50.79, ["Fly|Ride"] = 144.8, ["Neon"] = 105, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 410.26, ["Mega"] = 592.55, ["Mega|Ride"] = 577.01, ["Mega|Fly|Ride"] = 720.63}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 134.27, ["Fly"] = 189.11, ["Ride"] = 131.24, ["Fly|Ride"] = 236.65, ["Neon"] = 634.29, ["Neon|Ride"] = 539.14, ["Neon|Fly|Ride"] = 755.21, ["Mega|Ride"] = 2294.4, ["Mega|Fly|Ride"] = 1811.24}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 103.69, ["Fly"] = 249.61, ["Ride"] = 137.7, ["Fly|Ride"] = 239.53, ["Neon"] = 448.38, ["Neon|Fly"] = 819.27, ["Neon|Ride"] = 458.58, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1378.13}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 47.33}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 49.88, ["Fly"] = 72.1, ["Ride"] = 51.48, ["Fly|Ride"] = 85.19, ["Neon|Ride"] = 577.01, ["Neon|Fly|Ride"] = 387.21, ["Mega"] = 4322.1, ["Mega|Fly|Ride"] = 1574.9}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 7.69, ["Fly"] = 72.4, ["Ride"] = 37.84, ["Fly|Ride"] = 209.61, ["Neon"] = 33.51, ["Neon|Fly"] = 301.88, ["Neon|Ride"] = 140.45, ["Neon|Fly|Ride"] = 243.1, ["Mega"] = 413.95, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 270.12, ["Mega|Fly|Ride"] = 655.82}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 617.4, ["Fly"] = 692.67, ["Ride"] = 632.63, ["Fly|Ride"] = 712.48, ["Neon|Fly"] = 3889.89, ["Neon|Ride"] = 3888.14, ["Neon|Fly|Ride"] = 1890, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 102.38, ["Fly"] = 155.59, ["Ride"] = 111.57, ["Fly|Ride"] = 183.75, ["Neon"] = 525, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 551.25, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 4178.4, ["Ride"] = 3961.13, ["Fly|Ride"] = 3871.88}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 84.89, ["Fly"] = 131.25, ["Ride"] = 89.15, ["Fly|Ride"] = 166.69, ["Neon"] = 655.82, ["Neon|Ride"] = 484.63, ["Mega|Ride"] = 2018.43, ["Mega|Fly|Ride"] = 1953}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 91.91, ["Fly"] = 328.13, ["Ride"] = 81.21, ["Fly|Ride"] = 105, ["Neon"] = 575.75, ["Neon|Ride"] = 430.01, ["Neon|Fly|Ride"] = 539.14, ["Mega"] = 6339.43, ["Mega|Ride"] = 2388.75, ["Mega|Fly|Ride"] = 2515.46}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 31.64, ["Fly"] = 64.78, ["Ride"] = 45.39, ["Fly|Ride"] = 92.98, ["Neon"] = 165.37, ["Neon|Fly"] = 144.8, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 2625, ["Mega|Ride"] = 923.86, ["Mega|Fly|Ride"] = 611.63}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 6.49}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 58.34, ["Fly"] = 52.5, ["Ride"] = 66.92, ["Fly|Ride"] = 144.8, ["Neon|Ride"] = 327.92, ["Neon|Fly|Ride"] = 446.25, ["Mega|Fly|Ride"] = 1554.89}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 36.28}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 212.63, ["Ride"] = 236.25, ["Fly|Ride"] = 301.88, ["Neon"] = 1152.93, ["Neon|Ride"] = 1152.81, ["Neon|Fly|Ride"] = 1296.64, ["Mega|Fly|Ride"] = 4851.65}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 656.25, ["Ride"] = 754.69, ["Fly|Ride"] = 708.75, ["Neon|Fly|Ride"] = 2878.18, ["Mega|Fly|Ride"] = 10028.82}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 8.54}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 35.83, ["Fly"] = 38.07, ["Ride"] = 42.47, ["Fly|Ride"] = 64.84, ["Neon"] = 216.12, ["Neon|Fly"] = 274.44, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 220.5, ["Mega|Ride"] = 1178.89, ["Mega|Fly|Ride"] = 767.81}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 23.59}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5559.71, ["Fly"] = 6161.14, ["Fly|Ride"] = 4462.5, ["Neon|Ride"] = 18016.09, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 32156.25}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 13.13, ["Fly"] = 52.5, ["Ride"] = 23.5, ["Fly|Ride"] = 58.48, ["Neon"] = 144.8, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 563.07, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 691.32}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 15.15, ["Fly"] = 72.42, ["Ride"] = 49.13, ["Fly|Ride"] = 131.82, ["Neon"] = 119.44, ["Neon|Ride"] = 143.75, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1059.02, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 98.44, ["Ride"] = 113.06, ["Fly|Ride"] = 129.94, ["Neon|Ride"] = 503.48, ["Neon|Fly|Ride"] = 495.7, ["Mega"] = 4322.1}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 12.69, ["Fly"] = 49.72, ["Ride"] = 43.23, ["Fly|Ride"] = 78.75, ["Neon"] = 78.66, ["Neon|Fly"] = 216.09, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 501.38, ["Mega"] = 553.24, ["Mega|Ride"] = 772.59, ["Mega|Fly|Ride"] = 800.63}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1706.25, ["Fly"] = 2087.8, ["Ride"] = 1857.19, ["Fly|Ride"] = 1575, ["Neon|Fly|Ride"] = 3148.69, ["Mega|Fly|Ride"] = 11025}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 24937.5, ["Fly"] = 24360, ["Ride"] = 33280.05, ["Fly|Ride"] = 24936.19, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 67697.44, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 15.54, ["Fly"] = 89.25, ["Ride"] = 55.12, ["Fly|Ride"] = 119.55, ["Neon"] = 157.25, ["Neon|Ride"] = 291.38, ["Neon|Fly|Ride"] = 331.73, ["Mega"] = 1050, ["Mega|Ride"] = 1310.57, ["Mega|Fly|Ride"] = 1568.93}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.61, ["Fly"] = 86.43, ["Ride"] = 39.29, ["Fly|Ride"] = 199.5, ["Neon"] = 24.81, ["Neon|Fly"] = 231.21, ["Neon|Ride"] = 84.29, ["Neon|Fly|Ride"] = 132.36, ["Mega"] = 147, ["Mega|Fly"] = 275.63, ["Mega|Ride"] = 200.7, ["Mega|Fly|Ride"] = 393.65}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 28.85}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 8.24, ["Ride"] = 31.5, ["Fly|Ride"] = 164.59, ["Neon"] = 58.08, ["Neon|Ride"] = 92.61, ["Neon|Fly|Ride"] = 285.59, ["Mega"] = 393.75, ["Mega|Ride"] = 408.4, ["Mega|Fly|Ride"] = 573.61}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 609.69, ["Fly"] = 864.44, ["Ride"] = 656.25, ["Fly|Ride"] = 681.18, ["Neon"] = 3112.41, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2296.88, ["Mega|Fly|Ride"] = 9089.12}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 787.5, ["Fly"] = 1076.15, ["Ride"] = 813.74, ["Fly|Ride"] = 838.69, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 13756.49}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 15.64, ["Fly"] = 33.51, ["Ride"] = 36.73, ["Fly|Ride"] = 99.02, ["Neon"] = 78.75, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 162.75, ["Mega"] = 503.53, ["Mega|Ride"] = 481.9, ["Mega|Fly|Ride"] = 655.82}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 29.18}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 105.91, ["Fly"] = 128.34, ["Ride"] = 85.65, ["Fly|Ride"] = 137.71, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 19687.5, ["Mega|Ride"] = 2018.43, ["Mega|Fly|Ride"] = 2118.92}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 91.88, ["Fly"] = 105, ["Ride"] = 106.98, ["Fly|Ride"] = 228.38, ["Neon"] = 450.19, ["Neon|Ride"] = 486.05, ["Neon|Fly|Ride"] = 509.15, ["Mega"] = 1406.19}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 4.94, ["Fly"] = 35.81, ["Ride"] = 19.68, ["Fly|Ride"] = 59.07, ["Neon"] = 45.94, ["Neon|Fly"] = 488.69, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 168, ["Mega"] = 272.87, ["Mega|Fly|Ride"] = 354.58}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 223.13, ["Fly"] = 262.5, ["Ride"] = 190.31, ["Fly|Ride"] = 301.87, ["Neon|Ride"] = 681.17, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 5186.51, ["Mega|Fly|Ride"] = 3204.46}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 10.46, ["Ride"] = 51.82, ["Fly|Ride"] = 144.38, ["Neon"] = 47.55, ["Neon|Ride"] = 144.94, ["Mega"] = 223.13, ["Mega|Fly"] = 1137.94, ["Mega|Ride"] = 272.55, ["Mega|Fly|Ride"] = 341.62}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 19.69, ["Fly"] = 65.63, ["Ride"] = 32.82, ["Fly|Ride"] = 90.45, ["Neon"] = 129.68, ["Neon|Fly"] = 327.95, ["Neon|Ride"] = 145.28, ["Neon|Fly|Ride"] = 215.25, ["Mega|Fly|Ride"] = 832.01}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 24.94, ["Ride"] = 57.75, ["Fly|Ride"] = 156.19, ["Neon"] = 257.25, ["Neon|Ride"] = 280, ["Neon|Fly|Ride"] = 259.88, ["Mega"] = 997.5, ["Mega|Ride"] = 853.13, ["Mega|Fly|Ride"] = 1011.85}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 15.72, ["Fly"] = 215.33, ["Ride"] = 42, ["Fly|Ride"] = 85.37, ["Neon"] = 151.3, ["Neon|Ride"] = 327.92, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1080.54, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6956.25, ["Ride"] = 5604.38, ["Fly|Ride"] = 5840.63, ["Neon"] = 36018.08, ["Neon|Fly|Ride"] = 30254.59}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 231, ["Fly"] = 229.69, ["Ride"] = 217.88, ["Fly|Ride"] = 288.75, ["Neon|Fly|Ride"] = 577.4, ["Mega|Fly|Ride"] = 2210.61}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 84.46, ["Fly"] = 314.9, ["Ride"] = 124.69, ["Fly|Ride"] = 327.92, ["Neon"] = 209.9, ["Neon|Fly"] = 302.52, ["Neon|Ride"] = 236.15, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 628.69, ["Mega|Ride"] = 643.13, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.62, ["Fly"] = 65.63, ["Ride"] = 27.57, ["Fly|Ride"] = 81.38, ["Neon"] = 31.35, ["Neon|Ride"] = 35.28, ["Neon|Fly|Ride"] = 164.58, ["Mega"] = 499.8, ["Mega|Ride"] = 330.75, ["Mega|Fly|Ride"] = 255.94}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 58.98, ["Fly"] = 144.8, ["Ride"] = 105, ["Fly|Ride"] = 224.44, ["Neon"] = 177.19, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 543.55, ["Mega|Fly"] = 734.68, ["Mega|Ride"] = 534.28, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 11418.75, ["Ride"] = 13415.07, ["Fly|Ride"] = 11549.85, ["Neon|Fly|Ride"] = 24766.88, ["Mega|Fly|Ride"] = 100717.08}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 377.81, ["Ride"] = 393.75, ["Fly|Ride"] = 496.99, ["Neon|Ride"] = 1728.64, ["Neon|Fly|Ride"] = 1779.42, ["Mega"] = 8749.13, ["Mega|Fly|Ride"] = 8749.13}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 45.83, ["Fly"] = 65.63, ["Ride"] = 55.13, ["Fly|Ride"] = 115.5, ["Neon"] = 432.23, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 360.87, ["Mega|Fly|Ride"] = 2016.03}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 10.38, ["Ride"] = 26.24, ["Fly|Ride"] = 74.81, ["Neon"] = 69.21, ["Neon|Fly"] = 278.83, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 142.63, ["Mega"] = 458.16, ["Mega|Fly|Ride"] = 648.33}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 400.32, ["Ride"] = 420, ["Fly|Ride"] = 477.74, ["Neon"] = 1512.74, ["Neon|Ride"] = 1438.02, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4593.75}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.28, ["Ride"] = 39.27, ["Fly|Ride"] = 144.8, ["Neon"] = 46.38, ["Neon|Ride"] = 144.36, ["Neon|Fly|Ride"] = 188.99, ["Mega"] = 159.93, ["Mega|Ride"] = 263.82, ["Mega|Fly|Ride"] = 288.48}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 103.39, ["Fly"] = 216.09, ["Ride"] = 141.05, ["Fly|Ride"] = 217.75, ["Neon"] = 467.78, ["Neon|Fly"] = 525, ["Neon|Ride"] = 493.77, ["Neon|Fly|Ride"] = 551.25, ["Mega"] = 2592.96, ["Mega|Fly|Ride"] = 2430.18}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 13.12, ["Fly"] = 19.2, ["Ride"] = 19.44, ["Fly|Ride"] = 42.59, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 87.84, ["Mega"] = 2593.26, ["Mega|Fly|Ride"] = 743.32}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 8.39}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 85.31, ["Fly"] = 598.23, ["Ride"] = 105, ["Fly|Ride"] = 172.88, ["Neon"] = 352.43, ["Neon|Fly"] = 1296.64, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 504.56, ["Mega|Ride"] = 1873.41, ["Mega|Fly|Ride"] = 2305.57}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 15.18, ["Fly"] = 91.9, ["Ride"] = 40.13, ["Fly|Ride"] = 84, ["Neon"] = 107.63, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 254.99, ["Mega"] = 720.63, ["Mega|Ride"] = 577.5, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 58.93}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 82.95, ["Fly"] = 144.8, ["Ride"] = 128.72, ["Fly|Ride"] = 301.45, ["Neon"] = 392.44, ["Neon|Ride"] = 431.08, ["Neon|Fly|Ride"] = 456.75, ["Mega|Fly|Ride"] = 1965}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 6.39, ["Ride"] = 29.18, ["Fly|Ride"] = 85.32, ["Neon"] = 19.95, ["Neon|Ride"] = 141.57, ["Neon|Fly|Ride"] = 288.51, ["Mega"] = 144.8, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 288.1}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 13.75, ["Fly"] = 56.42, ["Ride"] = 34.59, ["Fly|Ride"] = 102.67, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 215.01, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 586.69}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 603.75, ["Ride"] = 534.45, ["Fly|Ride"] = 492.19, ["Neon|Fly|Ride"] = 5763.52, ["Mega|Fly|Ride"] = 7087.5}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 39.19, ["Ride"] = 72.4, ["Fly|Ride"] = 107.6, ["Neon"] = 195.57, ["Neon|Ride"] = 142.64, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 776.43, ["Mega|Ride"] = 634.29, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 51.19, ["Fly"] = 101.58, ["Ride"] = 84.67, ["Fly|Ride"] = 155.64, ["Neon"] = 491.32, ["Neon|Ride"] = 241.94, ["Neon|Fly|Ride"] = 288.48, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 19.47, ["Fly"] = 20.53, ["Ride"] = 63, ["Fly|Ride"] = 110.24, ["Neon"] = 99.75, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 215.04, ["Mega"] = 285.87, ["Mega|Ride"] = 580.46, ["Mega|Fly|Ride"] = 576.94}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11025, ["Fly"] = 10500, ["Ride"] = 8862, ["Fly|Ride"] = 7875, ["Neon|Fly|Ride"] = 15750, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1351.88, ["Fly"] = 1532.35, ["Ride"] = 1694.81, ["Fly|Ride"] = 1413.57, ["Neon|Fly|Ride"] = 3804.94, ["Mega|Fly|Ride"] = 15721.71}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 608.98, ["Ride"] = 525, ["Fly|Ride"] = 601.02, ["Neon"] = 2253.58, ["Neon|Fly|Ride"] = 3084.38, ["Mega"] = 21610.42, ["Mega|Fly|Ride"] = 10082.22}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 12.99, ["Fly"] = 19.69, ["Ride"] = 24.86, ["Fly|Ride"] = 43.32, ["Neon"] = 91.35, ["Neon|Ride"] = 86.44, ["Neon|Fly|Ride"] = 129.66, ["Mega|Fly|Ride"] = 539.44}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 6.57, ["Fly"] = 78.74, ["Ride"] = 28.9, ["Fly|Ride"] = 198.83, ["Neon"] = 23.73, ["Neon|Ride"] = 73.78, ["Mega"] = 170.63, ["Mega|Ride"] = 218.98, ["Mega|Fly|Ride"] = 343.58}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 35.09, ["Fly"] = 52.41, ["Ride"] = 45.94, ["Fly|Ride"] = 104.9, ["Neon"] = 144.8, ["Neon|Ride"] = 157.49, ["Neon|Fly|Ride"] = 198.09, ["Mega|Fly|Ride"] = 647.07}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 5.65, ["Fly"] = 23.14, ["Ride"] = 17.03, ["Fly|Ride"] = 49.71, ["Neon"] = 43.22, ["Neon|Fly"] = 85.57, ["Neon|Ride"] = 46.67, ["Neon|Fly|Ride"] = 105.95, ["Mega"] = 327.92, ["Mega|Ride"] = 345.74, ["Mega|Fly|Ride"] = 266.19}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 306.79, ["Fly"] = 406.88, ["Ride"] = 326.13, ["Fly|Ride"] = 410.21, ["Neon"] = 1636.05, ["Neon|Ride"] = 1456.55, ["Neon|Fly|Ride"] = 1373.61, ["Mega|Fly|Ride"] = 4967.65}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 30.18, ["Fly"] = 91.87, ["Ride"] = 40.68, ["Fly|Ride"] = 78.75, ["Neon"] = 111.57, ["Neon|Fly"] = 411.41, ["Neon|Ride"] = 172.88, ["Neon|Fly|Ride"] = 233.39, ["Mega"] = 1060, ["Mega|Fly"] = 917.42, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 10.38, ["Fly"] = 24.06, ["Ride"] = 21, ["Fly|Ride"] = 49.22, ["Neon"] = 81.05, ["Neon|Fly"] = 122.11, ["Neon|Ride"] = 133.9, ["Neon|Fly|Ride"] = 131.42, ["Mega"] = 1575, ["Mega|Ride"] = 451.5, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 450.19, ["Fly"] = 1048.69, ["Ride"] = 485.63, ["Fly|Ride"] = 637.82, ["Mega|Fly|Ride"] = 9971.07}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1039.5, ["Fly"] = 1441.42, ["Ride"] = 1050, ["Fly|Ride"] = 1290.18, ["Neon"] = 5270.48, ["Neon|Ride"] = 3313.57, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13782.3}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 127.35, ["Fly"] = 129.68, ["Ride"] = 102.38, ["Fly|Ride"] = 123.34, ["Neon"] = 971.25, ["Neon|Ride"] = 982.63, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 2591.1, ["Mega|Fly|Ride"] = 2880.68}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 175.3, ["Fly"] = 196.85, ["Ride"] = 216.57, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 642.85, ["Neon|Fly|Ride"] = 561.83, ["Mega|Fly|Ride"] = 3020.79}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 31.91, ["Fly"] = 124.27, ["Ride"] = 54.97, ["Fly|Ride"] = 101.47, ["Neon"] = 262.4, ["Neon|Ride"] = 243, ["Mega|Ride"] = 2161.06, ["Mega|Fly|Ride"] = 1138.74}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 183.75, ["Ride"] = 646.14, ["Fly|Ride"] = 577.01, ["Neon"] = 1220.63, ["Mega|Fly|Ride"] = 5763.52}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2348.79, ["Ride"] = 2333.67, ["Fly|Ride"] = 2099.99, ["Neon"] = 10805.22, ["Neon|Fly|Ride"] = 10805.22, ["Mega|Fly|Ride"] = 49703.97}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 58.98, ["Fly"] = 216.12, ["Ride"] = 73.5, ["Neon"] = 288.75, ["Neon|Ride"] = 190.32, ["Neon|Fly|Ride"] = 343.3, ["Mega|Ride"] = 1802.32, ["Mega|Fly|Ride"] = 1441.26}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 590.63, ["Fly"] = 864.44, ["Ride"] = 603.72, ["Fly|Ride"] = 656.25, ["Neon|Ride"] = 1498.88, ["Neon|Fly|Ride"] = 1233.75, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 37.97, ["Fly"] = 72.18, ["Ride"] = 48.47, ["Fly|Ride"] = 72.4, ["Neon"] = 432.23, ["Neon|Ride"] = 259.34, ["Neon|Fly|Ride"] = 203.44, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 4.94, ["Fly"] = 55.09, ["Ride"] = 20.14, ["Fly|Ride"] = 45.94, ["Neon"] = 30.08, ["Neon|Fly"] = 136.76, ["Neon|Ride"] = 43.93, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 160.02, ["Mega|Fly"] = 254.05, ["Mega|Ride"] = 179.02, ["Mega|Fly|Ride"] = 258.92}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 72.19, ["Ride"] = 131.12, ["Fly|Ride"] = 157.5, ["Neon"] = 397.48, ["Neon|Ride"] = 486.34, ["Neon|Fly|Ride"] = 720.71, ["Mega"] = 1473.75, ["Mega|Ride"] = 1728.85, ["Mega|Fly|Ride"] = 1638.32}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 1044.98, ["Ride"] = 1066.41, ["Fly|Ride"] = 1115.63, ["Neon|Ride"] = 3694.69, ["Neon|Fly|Ride"] = 3150, ["Mega|Fly|Ride"] = 14807.63}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 719.25, ["Ride"] = 721.88, ["Fly|Ride"] = 1009.22, ["Neon|Fly|Ride"] = 3675, ["Mega|Fly|Ride"] = 20167.67}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 14.44, ["Fly"] = 32.41, ["Ride"] = 25.95, ["Fly|Ride"] = 41.66, ["Neon"] = 140.07, ["Neon|Ride"] = 120.96, ["Neon|Fly|Ride"] = 103.95, ["Mega|Fly|Ride"] = 777.34}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 31.95, ["Ride"] = 50.79, ["Fly|Ride"] = 105, ["Neon"] = 253.32, ["Neon|Ride"] = 285.24, ["Neon|Fly|Ride"] = 404.09, ["Mega"] = 1638.52, ["Mega|Ride"] = 1439.09, ["Mega|Fly|Ride"] = 1207.5}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 5.65, ["Fly"] = 49.14, ["Ride"] = 32.44, ["Fly|Ride"] = 85.32, ["Neon"] = 24.59, ["Neon|Fly"] = 326.27, ["Neon|Ride"] = 64.29, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 194.91, ["Mega|Fly"] = 573.61, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 36.68, ["Fly"] = 60.38, ["Ride"] = 50.66, ["Fly|Ride"] = 106.74, ["Neon"] = 318.77, ["Neon|Ride"] = 220.49, ["Neon|Fly|Ride"] = 192.94, ["Mega|Fly|Ride"] = 786.19}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 93.19, ["Ride"] = 171.94, ["Fly|Ride"] = 360.91, ["Neon"] = 545.74, ["Neon|Ride"] = 603.75, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1874.25, ["Mega|Fly|Ride"] = 2585.63}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 17.05, ["Fly"] = 59.07, ["Ride"] = 43.32, ["Fly|Ride"] = 81.38, ["Neon"] = 94.5, ["Neon|Ride"] = 97.86, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 481.99, ["Mega|Ride"] = 367.4, ["Mega|Fly|Ride"] = 525.65}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 40.95, ["Fly"] = 63.02, ["Ride"] = 39.37, ["Fly|Ride"] = 85.98, ["Neon"] = 244.39, ["Neon|Fly"] = 1441.42, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 237.98, ["Mega"] = 2100, ["Mega|Ride"] = 1123.62, ["Mega|Fly|Ride"] = 1025.04}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 5.24, ["Fly"] = 57.18, ["Ride"] = 16.95, ["Fly|Ride"] = 45.71, ["Neon"] = 35.34, ["Neon|Ride"] = 40.09, ["Neon|Fly|Ride"] = 116.69, ["Mega"] = 223.13, ["Mega|Ride"] = 394.75, ["Mega|Fly|Ride"] = 366.19}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 10.71, ["Fly"] = 65.63, ["Ride"] = 35.43, ["Fly|Ride"] = 85.37, ["Neon"] = 101.47, ["Neon|Fly"] = 115.54, ["Neon|Ride"] = 82.31, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 380.63, ["Mega|Ride"] = 481.32, ["Mega|Fly|Ride"] = 524.9}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 42, ["Fly"] = 72.19, ["Ride"] = 55.1, ["Fly|Ride"] = 83.6, ["Neon"] = 572.87, ["Neon|Ride"] = 211.08, ["Neon|Fly|Ride"] = 318.73, ["Mega|Fly|Ride"] = 1074.94}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1358.34, ["Fly"] = 1443.75, ["Ride"] = 1365.68, ["Fly|Ride"] = 1443.65, ["Neon|Ride"] = 4466.36, ["Neon|Fly|Ride"] = 3497.82, ["Mega|Fly|Ride"] = 13013.69}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 498.74, ["Fly"] = 589.51, ["Ride"] = 525, ["Fly|Ride"] = 572.25, ["Neon|Ride"] = 2389.05, ["Neon|Fly|Ride"] = 2332.32}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 298.86, ["Ride"] = 368.45, ["Fly|Ride"] = 453.77, ["Neon"] = 1620.61, ["Neon|Ride"] = 1728.85, ["Neon|Fly|Ride"] = 1771.86}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 42}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 34.13, ["Ride"] = 49.76, ["Fly|Ride"] = 131.25, ["Neon"] = 302.16, ["Neon|Fly"] = 577.01, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 518.44, ["Mega|Ride"] = 1728.85, ["Mega|Fly|Ride"] = 1036.54}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 70875, ["Fly"] = 25712.34, ["Ride"] = 37666.97, ["Fly|Ride"] = 17718.75, ["Neon|Fly|Ride"] = 33468.75, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 288.15, ["Fly"] = 288.48, ["Ride"] = 270.14, ["Fly|Ride"] = 367.23, ["Neon"] = 1065.41, ["Neon|Ride"] = 1054.49, ["Neon|Fly|Ride"] = 951.56, ["Mega"] = 6483.14, ["Mega|Fly|Ride"] = 3215.63}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 158.81, ["Fly"] = 525, ["Ride"] = 165.83, ["Fly|Ride"] = 323.09}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 101.07, ["Fly"] = 216.09, ["Ride"] = 114.28, ["Fly|Ride"] = 196.88, ["Neon|Ride"] = 719.24, ["Neon|Fly|Ride"] = 627.86, ["Mega|Fly|Ride"] = 2887.5}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 13.98, ["Fly"] = 62.68, ["Ride"] = 33.51, ["Fly|Ride"] = 78.75, ["Neon|Fly"] = 105, ["Neon|Ride"] = 155.59, ["Neon|Fly|Ride"] = 238.81, ["Mega"] = 1968.75, ["Mega|Ride"] = 717.4, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3814.43, ["Ride"] = 3806.25, ["Fly|Ride"] = 3970.32, ["Neon"] = 21610.42, ["Neon|Fly|Ride"] = 15750, ["Mega|Fly|Ride"] = 81884.22}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 31.14, ["Fly"] = 52.41, ["Ride"] = 30.19, ["Fly|Ride"] = 49.13, ["Neon"] = 201.44, ["Neon|Ride"] = 167.19, ["Neon|Fly|Ride"] = 184.43, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 30.45, ["Fly"] = 105, ["Ride"] = 49.87, ["Fly|Ride"] = 91.64, ["Neon"] = 310.13, ["Neon|Fly"] = 1441.42, ["Neon|Ride"] = 202.79, ["Neon|Fly|Ride"] = 302.52, ["Mega|Fly|Ride"] = 1601.25}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 406.77, ["Fly"] = 446.25, ["Ride"] = 455.81, ["Fly|Ride"] = 532.88, ["Neon"] = 1312.5, ["Neon|Ride"] = 1141.87, ["Neon|Fly|Ride"] = 1186.56, ["Mega|Fly|Ride"] = 5020.59}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 15.58, ["Fly"] = 25.07, ["Ride"] = 28.07, ["Fly|Ride"] = 43.22, ["Neon"] = 131.25, ["Neon|Ride"] = 118.11, ["Neon|Fly|Ride"] = 155.93, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 639.77}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 14.44, ["Fly"] = 288.51, ["Ride"] = 26.17, ["Fly|Ride"] = 81.06, ["Neon"] = 98.44, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 219.91, ["Mega|Ride"] = 545.74}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 90.54, ["Ride"] = 98.42, ["Fly|Ride"] = 245.44, ["Neon"] = 682.5, ["Neon|Ride"] = 511.88, ["Neon|Fly|Ride"] = 690.47, ["Mega|Ride"] = 4322.1, ["Mega|Fly|Ride"] = 2211.59}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 16.36, ["Fly"] = 124.59, ["Ride"] = 58.35, ["Fly|Ride"] = 172.88, ["Neon"] = 86.62, ["Neon|Ride"] = 129.66, ["Neon|Fly|Ride"] = 288.48, ["Mega"] = 432.23, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 288.74, ["Mega|Fly|Ride"] = 431.6}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 6168.75, ["Ride"] = 5498.07, ["Fly|Ride"] = 5420.63, ["Neon"] = 19687.5, ["Neon|Ride"] = 15556.5, ["Neon|Fly|Ride"] = 11811.19, ["Mega"] = 49007.47, ["Mega|Fly|Ride"] = 37945.69}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 31.29, ["Fly"] = 144.8, ["Ride"] = 63.57, ["Fly|Ride"] = 147.41, ["Neon"] = 233.62, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 499.42, ["Mega"] = 1225.32, ["Mega|Ride"] = 1801.87, ["Mega|Fly|Ride"] = 784.88}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 6562.5, ["Ride"] = 6857.82, ["Fly|Ride"] = 6273.65, ["Neon|Fly"] = 18584.97, ["Neon|Fly|Ride"] = 15211.88, ["Mega|Fly|Ride"] = 46921.88}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.94, ["Fly"] = 20.53, ["Ride"] = 17.07, ["Fly|Ride"] = 39.29, ["Neon"] = 32.82, ["Neon|Fly"] = 62.74, ["Neon|Ride"] = 39.52, ["Neon|Fly|Ride"] = 103.95, ["Mega"] = 243.1, ["Mega|Fly"] = 1441.26, ["Mega|Ride"] = 216.09, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 23.79, ["Fly"] = 36.86, ["Ride"] = 26.25, ["Fly|Ride"] = 62.68, ["Neon"] = 91.94, ["Neon|Fly"] = 238.81, ["Neon|Ride"] = 141.56, ["Neon|Fly|Ride"] = 142.93, ["Mega|Ride"] = 893.17, ["Mega|Fly|Ride"] = 935.82}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 4.94}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 11.81, ["Fly"] = 39.37, ["Ride"] = 29.18, ["Fly|Ride"] = 115.49, ["Neon"] = 170.62, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 1049.9, ["Mega|Ride"] = 1151.85, ["Mega|Fly|Ride"] = 819.16}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 29.78, ["Fly"] = 190.37, ["Ride"] = 53.82, ["Fly|Ride"] = 144.8, ["Neon"] = 241.5, ["Neon|Ride"] = 202.08, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1009.22}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 11.43, ["Fly"] = 26.24, ["Ride"] = 20.1, ["Fly|Ride"] = 41.99, ["Neon"] = 94, ["Neon|Fly"] = 1077.29, ["Neon|Ride"] = 108.07, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 1133.48, ["Mega|Fly|Ride"] = 673.1}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 6628.13}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 3071.25}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 24.69}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 271.19, ["Ride"] = 377.09, ["Fly|Ride"] = 341.25, ["Neon|Fly|Ride"] = 1239.38}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 13.09, ["Fly"] = 61.61, ["Ride"] = 38.06, ["Fly|Ride"] = 103.69, ["Neon"] = 104.9, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 265.13, ["Mega|Ride"] = 1470, ["Mega|Fly|Ride"] = 574.85}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 12.48}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 8.9, ["Ride"] = 25.97, ["Fly|Ride"] = 86.45, ["Neon"] = 144.8, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 183.7, ["Mega|Fly|Ride"] = 496.12}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2623.69}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 259.75, ["Ride"] = 288.48, ["Fly|Ride"] = 736.97, ["Neon"] = 1009.11, ["Neon|Fly|Ride"] = 1152.81, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 66.94, ["Fly"] = 216.12, ["Ride"] = 108.07, ["Fly|Ride"] = 525, ["Neon"] = 316.32, ["Neon|Ride"] = 342.49, ["Neon|Fly|Ride"] = 345.19, ["Mega|Ride"] = 2456.52, ["Mega|Fly|Ride"] = 2158.64}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 171.92, ["Fly"] = 262.83, ["Ride"] = 187.11, ["Fly|Ride"] = 297.25, ["Neon"] = 975.8, ["Neon|Ride"] = 741.57, ["Neon|Fly|Ride"] = 748.12, ["Mega|Ride"] = 3673.78, ["Mega|Fly|Ride"] = 3528.58}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2447.81, ["Ride"] = 2362.5, ["Fly|Ride"] = 2644.69, ["Neon"] = 15177.01, ["Neon|Ride"] = 8643.15, ["Neon|Fly|Ride"] = 9363.76, ["Mega|Fly|Ride"] = 31499.99}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 18.8, ["Fly"] = 106.97, ["Ride"] = 44.94, ["Fly|Ride"] = 87.35, ["Neon"] = 127.32, ["Neon|Ride"] = 387.87, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 971.29, ["Mega|Ride"] = 1179, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 1115.63, ["Fly"] = 2231.25, ["Ride"] = 893.5, ["Fly|Ride"] = 1225.18, ["Neon|Fly|Ride"] = 6483.14}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 65.54}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 22.62, ["Fly"] = 98.35, ["Ride"] = 40.6, ["Fly|Ride"] = 245.44, ["Neon"] = 115.5, ["Neon|Ride"] = 133.98, ["Neon|Fly|Ride"] = 263.67, ["Mega"] = 376.99, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 506.15}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 8.97, ["Fly"] = 51.6, ["Ride"] = 31.13, ["Fly|Ride"] = 76.18, ["Neon"] = 72.19, ["Neon|Fly"] = 315, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 577.01}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 60.71}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 16.7, ["Fly"] = 64.86, ["Ride"] = 36.66, ["Fly|Ride"] = 73.7, ["Neon"] = 144.8, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 254.63, ["Mega|Ride"] = 1296.64, ["Mega|Fly|Ride"] = 850.28}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 27.44, ["Fly"] = 50.79, ["Ride"] = 32.06, ["Fly|Ride"] = 63, ["Neon"] = 164.58, ["Neon|Fly"] = 288.51, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 287.39, ["Mega"] = 1441.42, ["Mega|Ride"] = 1842.4, ["Mega|Fly|Ride"] = 871.5}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6872.25, ["Fly"] = 5775, ["Ride"] = 6613.95, ["Fly|Ride"] = 5016.38, ["Neon|Fly|Ride"] = 10479, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 10.28, ["Fly"] = 49.72, ["Ride"] = 31.5, ["Fly|Ride"] = 81.84, ["Neon"] = 57.66, ["Neon|Ride"] = 95.69, ["Neon|Fly|Ride"] = 234.6, ["Mega"] = 354.38, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 699.57}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 25.67}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 103.42, ["Fly"] = 382.52, ["Ride"] = 116.9, ["Fly|Ride"] = 327.95, ["Neon"] = 531.57, ["Neon|Ride"] = 536.82, ["Neon|Fly|Ride"] = 531.57, ["Mega"] = 2879.59, ["Mega|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 1794.55}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 57.66, ["Fly"] = 200.8, ["Ride"] = 95.82, ["Fly|Ride"] = 181.92, ["Neon"] = 255.94, ["Neon|Fly"] = 393.02, ["Neon|Ride"] = 302.52, ["Neon|Fly|Ride"] = 547.84, ["Mega"] = 1225.32, ["Mega|Ride"] = 1240.45, ["Mega|Fly|Ride"] = 1200.94}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 31.35, ["Fly"] = 82.11, ["Ride"] = 34.02, ["Fly|Ride"] = 57.75, ["Neon"] = 141.75, ["Neon|Fly"] = 233.39, ["Neon|Ride"] = 136.49, ["Neon|Fly|Ride"] = 188.97, ["Mega"] = 1016.21, ["Mega|Ride"] = 901.56, ["Mega|Fly|Ride"] = 982.63}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6.67, ["Fly"] = 78.75, ["Ride"] = 26.25, ["Fly|Ride"] = 85.32, ["Neon"] = 37.68, ["Neon|Ride"] = 64.84, ["Neon|Fly|Ride"] = 174.57, ["Mega"] = 261.19, ["Mega|Fly"] = 7203.84, ["Mega|Ride"] = 318.73, ["Mega|Fly|Ride"] = 376.69}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 12.49, ["Fly"] = 64.32, ["Ride"] = 33.52, ["Fly|Ride"] = 89.7, ["Neon"] = 81.37, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 229.08, ["Mega"] = 380.63, ["Mega|Ride"] = 485.17, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 25.94, ["Fly"] = 32.44, ["Ride"] = 23.63, ["Fly|Ride"] = 44.35, ["Neon"] = 164.58, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 174.46, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 198.19}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 39.32, ["Ride"] = 288.48, ["Fly|Ride"] = 288.51, ["Neon"] = 181.13, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 462.42, ["Mega"] = 866.25, ["Mega|Fly|Ride"] = 791.31}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["Ride"] = 1441.42}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 63.05, ["Fly"] = 108.06, ["Ride"] = 92.6, ["Fly|Ride"] = 202.05, ["Neon"] = 214.39, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1208.82, ["Mega|Ride"] = 1296.49, ["Mega|Fly|Ride"] = 1498.51}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 1113, ["Fly"] = 1246.67, ["Ride"] = 1378.02, ["Fly|Ride"] = 1155, ["Neon"] = 4728.24, ["Neon|Fly"] = 4728.24, ["Neon|Ride"] = 3675, ["Neon|Fly|Ride"] = 3675, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 467.77, ["Ride"] = 459.38, ["Fly|Ride"] = 525, ["Neon"] = 2884.88, ["Neon|Ride"] = 7779.76, ["Neon|Fly|Ride"] = 1706.25, ["Mega"] = 12600, ["Mega|Fly|Ride"] = 9973.69}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 63.7}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 3.66}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 9.07, ["Fly"] = 36.75, ["Ride"] = 24.05, ["Fly|Ride"] = 53.84, ["Neon"] = 118.13, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 85.37, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 437.26, ["Mega|Ride"] = 432.17, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 234.93, ["Fly"] = 334.93, ["Ride"] = 288.48, ["Fly|Ride"] = 370.56, ["Neon"] = 851.82, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 874.13, ["Mega|Fly|Ride"] = 3315.92}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 18.25}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 105, ["Ride"] = 164.58, ["Fly|Ride"] = 400.32, ["Neon"] = 1009.11, ["Neon|Fly"] = 610.32, ["Neon|Ride"] = 720.57, ["Neon|Fly|Ride"] = 685.13, ["Mega"] = 2809.03, ["Mega|Ride"] = 12246.63, ["Mega|Fly|Ride"] = 2129.55}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 124.64, ["Fly"] = 311.99, ["Ride"] = 131.15, ["Fly|Ride"] = 274.44, ["Neon"] = 1023.15, ["Neon|Ride"] = 1032.94, ["Neon|Fly|Ride"] = 931.88, ["Mega|Fly|Ride"] = 4068.75}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 7.79, ["Ride"] = 24.59, ["Fly|Ride"] = 729.75, ["Neon"] = 31.5, ["Neon|Ride"] = 72.3, ["Neon|Fly|Ride"] = 212.62, ["Mega"] = 168.92, ["Mega|Ride"] = 230.9, ["Mega|Fly|Ride"] = 406.51}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 16.59, ["Fly"] = 51.44, ["Ride"] = 31.95, ["Fly|Ride"] = 64.84, ["Neon"] = 110.25, ["Neon|Fly"] = 144.8, ["Neon|Ride"] = 101.48, ["Neon|Fly|Ride"] = 249.38, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 16.23, ["Fly"] = 102.36, ["Ride"] = 39.38, ["Fly|Ride"] = 131.25, ["Neon"] = 93.35, ["Neon|Ride"] = 101.58, ["Neon|Fly|Ride"] = 287.43, ["Mega"] = 384.63, ["Mega|Ride"] = 462.48, ["Mega|Fly|Ride"] = 496.13}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 6.39, ["Fly"] = 172.88, ["Ride"] = 51.19, ["Fly|Ride"] = 170.63, ["Neon"] = 25.1, ["Neon|Ride"] = 69.62, ["Neon|Fly|Ride"] = 209.61, ["Mega"] = 154.87, ["Mega|Ride"] = 172.36, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 297.34, ["Ride"] = 320.25, ["Fly|Ride"] = 367.49, ["Neon"] = 1433.7, ["Neon|Ride"] = 1412.35, ["Neon|Fly|Ride"] = 1424.07}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 92.93, ["Fly"] = 577.01, ["Ride"] = 131.24, ["Fly|Ride"] = 235.86, ["Neon"] = 435.29, ["Neon|Ride"] = 534.81, ["Neon|Fly|Ride"] = 521.07, ["Mega"] = 2022.57, ["Mega|Fly|Ride"] = 2093.44}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 70.87, ["Fly"] = 167.45, ["Ride"] = 86.35, ["Fly|Ride"] = 138.36, ["Neon"] = 393.75, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 432.17, ["Mega|Ride"] = 1801.87, ["Mega|Fly|Ride"] = 1374.18}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 18.38, ["Ride"] = 54.05, ["Neon|Ride"] = 623.98, ["Neon|Fly|Ride"] = 491.32, ["Mega|Fly|Ride"] = 1009.22}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 14.95, ["Ride"] = 32.82, ["Fly|Ride"] = 71.47, ["Neon"] = 82.31, ["Neon|Ride"] = 83.16, ["Neon|Fly|Ride"] = 210, ["Mega"] = 807.19, ["Mega|Ride"] = 823.2, ["Mega|Fly|Ride"] = 615.83}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.93, ["Fly"] = 38.19, ["Ride"] = 24.33, ["Fly|Ride"] = 85.37, ["Neon"] = 26.16, ["Neon|Fly"] = 86.44, ["Neon|Ride"] = 41.91, ["Neon|Fly|Ride"] = 111.71, ["Mega"] = 321.98, ["Mega|Ride"] = 149.63, ["Mega|Fly|Ride"] = 254.63}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 1050, ["Fly"] = 918.75, ["Ride"] = 871.5, ["Fly|Ride"] = 928.06, ["Neon"] = 4322.1, ["Neon|Ride"] = 8644.17, ["Neon|Fly|Ride"] = 2467.48, ["Mega|Fly|Ride"] = 8263.5}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 247.96, ["Fly"] = 365.23, ["Ride"] = 309.1, ["Fly|Ride"] = 337.02, ["Neon|Ride"] = 1270.5, ["Neon|Fly|Ride"] = 1512.57, ["Mega"] = 10805.22, ["Mega|Ride"] = 5895.65, ["Mega|Fly|Ride"] = 5357.67}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 101.42, ["Fly"] = 128.87, ["Ride"] = 115.62, ["Fly|Ride"] = 190.32, ["Neon"] = 426.57, ["Neon|Ride"] = 428.79, ["Neon|Fly|Ride"] = 525, ["Mega"] = 1575, ["Mega|Ride"] = 1765.37, ["Mega|Fly|Ride"] = 1884.16}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 164.07, ["Fly"] = 255.02, ["Ride"] = 207.75, ["Fly|Ride"] = 196.88, ["Neon|Ride"] = 1147.2, ["Neon|Fly|Ride"] = 978.43, ["Mega"] = 10805.22, ["Mega|Fly|Ride"] = 4095.76}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 15.65, ["Fly"] = 34.59, ["Ride"] = 31.6, ["Fly|Ride"] = 63, ["Neon"] = 170.63, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 199.07, ["Mega|Ride"] = 768.27}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 197.68, ["Ride"] = 328.38, ["Fly|Ride"] = 393.02, ["Neon"] = 1584.98, ["Neon|Ride"] = 942.27, ["Neon|Fly|Ride"] = 1165.5, ["Mega"] = 4300.16}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 78.75, ["Ride"] = 98.51, ["Fly|Ride"] = 131.24, ["Neon|Ride"] = 1638.52, ["Neon|Fly|Ride"] = 498.75, ["Mega|Ride"] = 2305.85, ["Mega|Fly|Ride"] = 1821.75}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 2439.94, ["Ride"] = 2377.75, ["Fly|Ride"] = 2296.87, ["Neon|Ride"] = 11464.57, ["Neon|Fly|Ride"] = 7203.84, ["Mega"] = 51865, ["Mega|Fly|Ride"] = 28814.25}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 12.87, ["Fly"] = 98.27, ["Ride"] = 41.09, ["Fly|Ride"] = 123.01, ["Neon"] = 64.97, ["Neon|Fly"] = 150.94, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 164.58, ["Mega"] = 312.38, ["Mega|Ride"] = 393.02, ["Mega|Fly|Ride"] = 458.07}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 52.41, ["Ride"] = 74.81, ["Fly|Ride"] = 148.32, ["Neon"] = 236.25, ["Neon|Ride"] = 226.63, ["Neon|Fly|Ride"] = 196.77, ["Mega|Ride"] = 931.87, ["Mega|Fly|Ride"] = 1497.57}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 98.26, ["Fly"] = 102.16, ["Ride"] = 87.36, ["Fly|Ride"] = 113.34, ["Neon|Ride"] = 491.26, ["Neon|Fly|Ride"] = 410.82, ["Mega|Fly|Ride"] = 1480.68}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2784.47, ["Fly"] = 1638.52, ["Ride"] = 1073.63, ["Fly|Ride"] = 960.75, ["Neon|Ride"] = 5732.29, ["Neon|Fly|Ride"] = 3937.49, ["Mega"] = 43220.83, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 435.75, ["Fly"] = 862.28, ["Ride"] = 816.88, ["Fly|Ride"] = 821.21, ["Mega"] = 11345.49}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 70.97, ["Fly"] = 155.6, ["Ride"] = 131.15, ["Fly|Ride"] = 224.44, ["Neon"] = 475.39, ["Neon|Ride"] = 360.18, ["Neon|Fly|Ride"] = 491.26, ["Mega"] = 5763.52, ["Mega|Ride"] = 1768.71, ["Mega|Fly|Ride"] = 1770.78}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 8.37, ["Fly"] = 41.06, ["Ride"] = 23.79, ["Fly|Ride"] = 65.63, ["Neon"] = 65.63, ["Neon|Ride"] = 72.4, ["Neon|Fly|Ride"] = 148.21, ["Mega"] = 656.25, ["Mega|Ride"] = 823.93}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 32.82, ["Fly"] = 62.68, ["Ride"] = 40.28, ["Fly|Ride"] = 86.35, ["Neon"] = 213.73, ["Neon|Ride"] = 144.8, ["Neon|Fly|Ride"] = 339.94, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 684.77, ["Fly"] = 1130.01, ["Ride"] = 720.57, ["Fly|Ride"] = 808.48, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2230.99, ["Mega|Fly|Ride"] = 8531.25}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 721.88}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 5906.25, ["Ride"] = 5440.32, ["Fly|Ride"] = 5381.25, ["Neon"] = 28875, ["Neon|Ride"] = 30968.81, ["Neon|Fly|Ride"] = 23049.08, ["Mega|Fly|Ride"] = 108052.06}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 245.58, ["Fly"] = 494.81, ["Ride"] = 360.91, ["Neon"] = 1728.85, ["Neon|Fly|Ride"] = 2161.06, ["Mega"] = 6481.28, ["Mega|Fly|Ride"] = 6482.37}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 71.36, ["Ride"] = 144.37, ["Fly|Ride"] = 190.32, ["Neon"] = 1009.22, ["Neon|Ride"] = 647.25, ["Neon|Fly|Ride"] = 1152.93}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 24.86, ["Fly"] = 102.36, ["Ride"] = 41.62, ["Fly|Ride"] = 98.27, ["Neon"] = 243.13, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 287.39, ["Mega|Ride"] = 864.44, ["Mega|Fly|Ride"] = 723.7}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 17.07, ["Fly"] = 32.82, ["Ride"] = 28.26, ["Fly|Ride"] = 57.75, ["Neon"] = 144.8, ["Neon|Ride"] = 327.95, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 1312.5, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 598.56}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 16.69, ["Fly"] = 163.16, ["Ride"] = 39.38, ["Fly|Ride"] = 109.15, ["Neon"] = 105, ["Neon|Ride"] = 124.66, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 645.91, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 862.16}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 5.41, ["Fly"] = 29.19, ["Ride"] = 21.62, ["Fly|Ride"] = 57.46, ["Neon"] = 36.75, ["Neon|Ride"] = 56.52, ["Neon|Fly|Ride"] = 137.23, ["Mega"] = 675, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 279.48}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 24.94, ["Ride"] = 42, ["Fly|Ride"] = 99.75, ["Neon"] = 115.5, ["Neon|Fly"] = 864.44, ["Neon|Ride"] = 188.28, ["Neon|Fly|Ride"] = 323.05, ["Mega"] = 630, ["Mega|Ride"] = 763.94}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 648.33, ["Fly"] = 762.57, ["Ride"] = 695.14, ["Fly|Ride"] = 901.44, ["Neon"] = 1700.23, ["Neon|Ride"] = 2579.35, ["Neon|Fly|Ride"] = 2025.99, ["Mega"] = 9187.5, ["Mega|Fly|Ride"] = 10805.22}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.63, ["Fly"] = 19.69, ["Ride"] = 17.01, ["Fly|Ride"] = 35.63, ["Neon"] = 20.5, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 74.81, ["Mega"] = 170.63, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 42.57, ["Fly"] = 112.2, ["Ride"] = 80.03, ["Fly|Ride"] = 133.87, ["Neon"] = 189, ["Neon|Fly"] = 430.71, ["Neon|Ride"] = 216.88, ["Neon|Fly|Ride"] = 274.32, ["Mega"] = 505.32, ["Mega|Fly"] = 864.44, ["Mega|Ride"] = 576.48, ["Mega|Fly|Ride"] = 578.71}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 771.75, ["Ride"] = 774.27, ["Fly|Ride"] = 820.32, ["Neon|Ride"] = 2738.06, ["Neon|Fly|Ride"] = 1666.88, ["Mega|Fly|Ride"] = 3752.34}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 41.71, ["Fly"] = 58.35, ["Ride"] = 45.94, ["Fly|Ride"] = 72.4, ["Neon"] = 280.88, ["Neon|Fly"] = 255.47, ["Neon|Ride"] = 223.02, ["Neon|Fly|Ride"] = 257.15, ["Mega"] = 1228.26, ["Mega|Fly|Ride"] = 885.93}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 321.58, ["Fly"] = 318.13, ["Ride"] = 310.28, ["Fly|Ride"] = 337.81, ["Neon|Fly|Ride"] = 1296.49, ["Mega|Fly|Ride"] = 4321.58}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 245.58, ["Fly"] = 302.97, ["Ride"] = 275.62, ["Fly|Ride"] = 348.58, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 944.99, ["Mega"] = 5118.75, ["Mega|Fly|Ride"] = 5475.01}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 749.89, ["Ride"] = 737.63, ["Fly|Ride"] = 721.87, ["Neon|Ride"] = 3746.18, ["Neon|Fly|Ride"] = 2572.5, ["Mega|Fly|Ride"] = 9842.44}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 18.26, ["Fly"] = 86.45, ["Ride"] = 69.17, ["Fly|Ride"] = 107.47, ["Neon"] = 64.32, ["Neon|Fly"] = 294.79, ["Neon|Ride"] = 118.12, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 354.38, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 288.48}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3622.49, ["Fly"] = 3590.9, ["Ride"] = 3411.19, ["Fly|Ride"] = 3412.5, ["Neon|Fly|Ride"] = 8211, ["Mega|Fly|Ride"] = 21504}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 128.64, ["Fly"] = 147.38, ["Ride"] = 129.66, ["Fly|Ride"] = 192.24, ["Neon"] = 550.97, ["Neon|Ride"] = 534.81, ["Neon|Fly|Ride"] = 584.72, ["Mega|Fly|Ride"] = 3457.27}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.63, ["Fly"] = 22.39, ["Ride"] = 17.03, ["Fly|Ride"] = 56.43, ["Neon"] = 24.86, ["Neon|Fly"] = 43.24, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 85.31, ["Mega"] = 243.1, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 291.27, ["Mega|Fly|Ride"] = 331.7}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.94, ["Ride"] = 25.89, ["Fly|Ride"] = 69.17, ["Neon"] = 21.87, ["Neon|Fly"] = 120.39, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 216.12, ["Mega|Ride"] = 418.14, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 58.69, ["Fly"] = 86.44, ["Ride"] = 56.38, ["Fly|Ride"] = 57.87, ["Neon|Ride"] = 410.55, ["Neon|Fly|Ride"] = 276.94, ["Mega|Fly|Ride"] = 1252.34}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 853.13, ["Fly"] = 1179.14, ["Ride"] = 921.11, ["Fly|Ride"] = 1013.52, ["Neon|Ride"] = 11464.57, ["Neon|Fly|Ride"] = 4463.64}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["Ride"] = 18013.94, ["Fly|Ride"] = 14585.29}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 36.75, ["Fly"] = 26.17, ["Ride"] = 26.8, ["Fly|Ride"] = 44.13, ["Neon"] = 172.88, ["Neon|Ride"] = 158.32, ["Neon|Fly|Ride"] = 143.35, ["Mega"] = 2520, ["Mega|Ride"] = 868.4, ["Mega|Fly|Ride"] = 793.03}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 18.19, ["Fly"] = 81.05, ["Ride"] = 27.3, ["Fly|Ride"] = 72.19, ["Neon"] = 103.47, ["Neon|Fly"] = 111.57, ["Neon|Ride"] = 92.65, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 675.63, ["Mega|Ride"] = 528.94, ["Mega|Fly|Ride"] = 501.37}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 110.15, ["Ride"] = 91.88, ["Fly|Ride"] = 106.12, ["Neon"] = 485.63, ["Neon|Ride"] = 634.98, ["Neon|Fly|Ride"] = 507.94, ["Mega|Fly|Ride"] = 1590.65}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 223.02, ["Fly"] = 432.23, ["Ride"] = 250.82, ["Fly|Ride"] = 321.57, ["Neon"] = 1310.57, ["Neon|Ride"] = 934.76, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 10805.22, ["Mega|Ride"] = 4168.73, ["Mega|Fly|Ride"] = 3127.69}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 4.29, ["Ride"] = 31.38, ["Fly|Ride"] = 93.19, ["Neon"] = 28.11, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 64.31, ["Mega"] = 154.63, ["Mega|Fly"] = 240.94, ["Mega|Ride"] = 159.36, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 175.4, ["Fly"] = 259.31, ["Ride"] = 223.13, ["Fly|Ride"] = 313.69, ["Neon"] = 643.13, ["Neon|Ride"] = 630, ["Neon|Fly|Ride"] = 719.25, ["Mega|Fly|Ride"] = 3603.12}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 6.57, ["Fly"] = 32.81, ["Ride"] = 19.28, ["Fly|Ride"] = 52.29, ["Neon"] = 22.32, ["Neon|Fly"] = 129.68, ["Neon|Ride"] = 38.91, ["Neon|Fly|Ride"] = 80.26, ["Mega"] = 240.97, ["Mega|Fly"] = 288.51, ["Mega|Ride"] = 219.19, ["Mega|Fly|Ride"] = 248.75}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 384.61, ["Fly"] = 288.51, ["Ride"] = 308.27, ["Fly|Ride"] = 360.87, ["Neon|Ride"] = 1436.25, ["Neon|Fly|Ride"] = 1149.54, ["Mega"] = 10805.22, ["Mega|Fly|Ride"] = 7983.69}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 11.81, ["Fly"] = 105, ["Ride"] = 27.56, ["Fly|Ride"] = 66.33, ["Neon"] = 91.87, ["Neon|Fly"] = 311.99, ["Neon|Ride"] = 144.8, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 577.01, ["Mega|Ride"] = 445.14, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 4.86, ["Ride"] = 26.18, ["Fly|Ride"] = 70.88, ["Neon"] = 11.69, ["Neon|Fly"] = 170.46, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 103.95, ["Mega"] = 91.66, ["Mega|Ride"] = 135.96, ["Mega|Fly|Ride"] = 288.48}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.82, ["Mega"] = 27.83, ["Mega|Ride"] = 155.6, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.61, ["Ride"] = 33.17, ["Fly|Ride"] = 86.61, ["Neon"] = 8.28, ["Neon|Ride"] = 43.07, ["Neon|Fly|Ride"] = 114.19, ["Mega"] = 64.32, ["Mega|Fly"] = 191720.66, ["Mega|Ride"] = 84.29, ["Mega|Fly|Ride"] = 284.16}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 79.97, ["Fly"] = 212.63, ["Ride"] = 118, ["Fly|Ride"] = 190.54, ["Neon"] = 288.75, ["Neon|Ride"] = 309.23, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 1233.75, ["Mega|Fly|Ride"] = 1236.38}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 43.23, ["Ride"] = 16.41, ["Fly|Ride"] = 24.94, ["Neon"] = 5.91, ["Neon|Ride"] = 33.18, ["Neon|Fly|Ride"] = 70.77, ["Mega"] = 78.75, ["Mega|Ride"] = 165.38, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 9.03, ["Ride"] = 85.32, ["Neon"] = 84, ["Neon|Fly"] = 362.31, ["Neon|Ride"] = 288.51, ["Mega"] = 420, ["Mega|Fly|Ride"] = 655.9}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 59.07, ["Mega"] = 16.23, ["Mega|Ride"] = 62.68}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 88.22, ["Ride"] = 16.15, ["Fly|Ride"] = 196.88, ["Neon"] = 2.1, ["Neon|Fly"] = 24.87, ["Neon|Ride"] = 15.5, ["Neon|Fly|Ride"] = 42.61, ["Mega"] = 15.31, ["Mega|Fly"] = 38.07, ["Mega|Ride"] = 19.26, ["Mega|Fly|Ride"] = 61.64}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 25.15, ["Ride"] = 15.73, ["Fly|Ride"] = 59.07, ["Neon"] = 2.49, ["Neon|Fly"] = 29.19, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 53.27, ["Mega"] = 19.68, ["Mega|Fly"] = 164.6, ["Mega|Ride"] = 42.99, ["Mega|Fly|Ride"] = 94.5}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 3.11, ["Neon|Ride"] = 65.63, ["Mega"] = 20.9, ["Mega|Fly|Ride"] = 244.18}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 117.94, ["Ride"] = 15.75, ["Fly|Ride"] = 52.5, ["Neon"] = 6.36, ["Neon|Fly"] = 100.92, ["Neon|Ride"] = 24.69, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 39.05, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 43.26, ["Mega|Fly|Ride"] = 105.63}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Ride"] = 72.42, ["Neon"] = 3.05, ["Neon|Fly"] = 31.49, ["Neon|Ride"] = 83.82, ["Mega"] = 14.44, ["Mega|Ride"] = 101.57, ["Mega|Fly|Ride"] = 145.68}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 52.5, ["Fly"] = 52.5, ["Fly|Ride"] = 163.99, ["Neon"] = 100.95, ["Neon|Ride"] = 116.83, ["Neon|Fly|Ride"] = 315, ["Mega"] = 242.87, ["Mega|Fly"] = 431.08, ["Mega|Ride"] = 349.76, ["Mega|Fly|Ride"] = 393.74}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 82.78, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 205.31, ["Mega"] = 18.27, ["Mega|Fly"] = 149.86, ["Mega|Fly|Ride"] = 157.4}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.63, ["Fly|Ride"] = 65.63, ["Neon"] = 22.81, ["Mega"] = 120.64, ["Mega|Fly"] = 315, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.6, ["Ride"] = 26.24, ["Fly|Ride"] = 43.22, ["Neon"] = 23.28, ["Neon|Ride"] = 65.63, ["Mega"] = 134.96, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Fly"] = 144.8, ["Ride"] = 32.82, ["Neon"] = 2.46, ["Neon|Ride"] = 27.97, ["Neon|Fly|Ride"] = 144.8, ["Mega"] = 21.51, ["Mega|Ride"] = 42.77, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.72, ["Ride"] = 12.89, ["Fly|Ride"] = 26.17, ["Neon"] = 2.1, ["Neon|Fly"] = 20.47, ["Neon|Ride"] = 14.43, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 16.51, ["Mega|Fly"] = 29.18, ["Mega|Ride"] = 19.36, ["Mega|Fly|Ride"] = 57.74}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 3.84, ["Fly"] = 72.19, ["Ride"] = 54.28, ["Fly|Ride"] = 118.12, ["Neon"] = 46.48, ["Neon|Ride"] = 103.95, ["Neon|Fly|Ride"] = 720.71, ["Mega"] = 144.8, ["Mega|Ride"] = 241.5}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 43.99, ["Fly|Ride"] = 58.36, ["Neon"] = 5.04, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 28.87, ["Neon|Fly|Ride"] = 105, ["Mega"] = 32.85, ["Mega|Ride"] = 43.28, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 6.35, ["Neon"] = 20.6, ["Neon|Ride"] = 195.11, ["Mega"] = 97.05, ["Mega|Ride"] = 144.27, ["Mega|Fly|Ride"] = 287.43}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.63, ["Fly"] = 83.87, ["Ride"] = 34.53, ["Fly|Ride"] = 65.63, ["Neon"] = 18.34, ["Neon|Ride"] = 105.91, ["Neon|Fly|Ride"] = 129.2, ["Mega"] = 131.25, ["Mega|Ride"] = 164.58, ["Mega|Fly|Ride"] = 196.87}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 13.5, ["Ride"] = 15.11, ["Fly|Ride"] = 25.29, ["Neon"] = 2.1, ["Neon|Fly"] = 19.45, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 31.5, ["Mega"] = 15.37, ["Mega|Fly"] = 34.13, ["Mega|Ride"] = 21.61, ["Mega|Fly|Ride"] = 58.34}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 44.57, ["Ride"] = 27.2, ["Fly|Ride"] = 144.38, ["Neon"] = 14.34, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 129.72, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 6.12, ["Fly"] = 118.13, ["Ride"] = 72.4, ["Fly|Ride"] = 93.19, ["Neon"] = 82.31, ["Neon|Ride"] = 86.45, ["Neon|Fly|Ride"] = 172.9, ["Mega"] = 288.75, ["Mega|Ride"] = 300.54, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 58.36, ["Ride"] = 13.02, ["Fly|Ride"] = 43.21, ["Neon"] = 2.63, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 51.19, ["Mega"] = 25.95, ["Mega|Fly"] = 35.65, ["Mega|Ride"] = 43.22, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.6, ["Fly"] = 180.46, ["Ride"] = 72.19, ["Neon"] = 7.88, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 51.19, ["Mega|Fly"] = 164.6, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 216.09}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 131.25, ["Neon"] = 6.24, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 43.23, ["Mega"] = 32.47, ["Mega|Ride"] = 114.54, ["Mega|Fly|Ride"] = 196.23}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Ride"] = 27.19, ["Fly|Ride"] = 48.51, ["Neon"] = 2.1, ["Neon|Ride"] = 35.26, ["Neon|Fly|Ride"] = 129.68, ["Mega"] = 15.59, ["Mega|Fly"] = 253.82, ["Mega|Ride"] = 42.6, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 23.79, ["Ride"] = 19.35, ["Fly|Ride"] = 55.44, ["Neon"] = 7.86, ["Neon|Fly"] = 58.36, ["Neon|Ride"] = 44.65, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 105.65, ["Mega|Fly"] = 97.04, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 151.92}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 3.83, ["Neon|Ride"] = 71.09, ["Mega"] = 47.4, ["Mega|Fly"] = 216.09, ["Mega|Ride"] = 144.8, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 28.61, ["Ride"] = 19.44, ["Fly|Ride"] = 49.7, ["Neon"] = 7.65, ["Neon|Fly"] = 76.18, ["Neon|Ride"] = 22.2, ["Neon|Fly|Ride"] = 84, ["Mega"] = 94.01, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 274.44}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 3.73, ["Ride"] = 52.5, ["Neon"] = 13.13, ["Neon|Fly"] = 188.88, ["Neon|Fly|Ride"] = 324.17, ["Mega"] = 105, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 648.33}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 26.02, ["Ride"] = 21.51, ["Fly|Ride"] = 51.19, ["Neon"] = 8.7, ["Neon|Fly"] = 72.42, ["Neon|Ride"] = 46.47, ["Neon|Fly|Ride"] = 61.95, ["Mega"] = 106.32, ["Mega|Fly"] = 420, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 144.37}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 6.49, ["Fly"] = 20.6, ["Ride"] = 18.24, ["Fly|Ride"] = 65.63, ["Neon"] = 18.66, ["Neon|Fly"] = 29.32, ["Neon|Ride"] = 24.86, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 98.44, ["Mega|Fly"] = 432.23, ["Mega|Ride"] = 127.2, ["Mega|Fly|Ride"] = 259.31}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 114.55, ["Neon"] = 107.66, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 259.88, ["Mega|Ride"] = 406.88}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 14.3, ["Ride"] = 131.25, ["Neon"] = 180.46, ["Neon|Ride"] = 86.44, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 750.75}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 6.17, ["Ride"] = 43.32, ["Neon"] = 57.2, ["Neon|Ride"] = 64.98, ["Mega"] = 223.48, ["Mega|Ride"] = 208.95}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 4.97, ["Ride"] = 51.19, ["Fly|Ride"] = 131.25, ["Neon"] = 69.57, ["Neon|Ride"] = 101.57, ["Neon|Fly|Ride"] = 202.08, ["Mega"] = 236.25, ["Mega|Ride"] = 288.48, ["Mega|Fly|Ride"] = 450.84}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 37.97, ["Mega"] = 20.94, ["Mega|Fly"] = 215.04, ["Mega|Ride"] = 82.31, ["Mega|Fly|Ride"] = 257.15}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 50.93}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 5.71, ["Fly"] = 24.05, ["Ride"] = 28.06, ["Fly|Ride"] = 65.63, ["Neon"] = 45.94, ["Neon|Fly"] = 188.03, ["Neon|Ride"] = 42.11, ["Neon|Fly|Ride"] = 84, ["Mega"] = 261.19, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 267.53}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 21.62, ["Neon"] = 2.98, ["Neon|Fly"] = 52.81, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 144.8, ["Mega"] = 29.18, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 26.24, ["Neon"] = 7.87, ["Neon|Ride"] = 32.99, ["Neon|Fly|Ride"] = 74.46, ["Mega"] = 29.89, ["Mega|Ride"] = 73.5, ["Mega|Fly|Ride"] = 174.45}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 47.55, ["Ride"] = 16.15, ["Fly|Ride"] = 47.62, ["Neon"] = 10.39, ["Neon|Ride"] = 24.08, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 272.46, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 229.7}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 6.82, ["Ride"] = 39.26, ["Fly|Ride"] = 261.19, ["Neon"] = 52.41, ["Neon|Ride"] = 208.15, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 106.25, ["Mega|Ride"] = 348.95, ["Mega|Fly|Ride"] = 285.24}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 4.94, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 159.93, ["Mega"] = 22.99, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 56.32, ["Mega|Fly|Ride"] = 345.74}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 28.02, ["Ride"] = 17.19, ["Fly|Ride"] = 65.63, ["Neon"] = 5.07, ["Neon|Fly"] = 115.21, ["Neon|Ride"] = 20.86, ["Neon|Fly|Ride"] = 84, ["Mega"] = 19.95, ["Mega|Fly"] = 164.9, ["Mega|Ride"] = 55.16, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 18.38, ["Fly|Ride"] = 53.8, ["Neon"] = 6.02, ["Neon|Fly"] = 37.85, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 64.74, ["Mega"] = 129.66, ["Mega|Fly"] = 144.8, ["Mega|Ride"] = 70.87, ["Mega|Fly|Ride"] = 137.25}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 7.95, ["Fly"] = 91.88, ["Ride"] = 181.92, ["Neon"] = 31.5, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 115.64, ["Mega|Ride"] = 163.67, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.04, ["Neon|Ride"] = 108.07, ["Neon|Fly|Ride"] = 202.08, ["Mega"] = 23.24, ["Mega|Fly"] = 103.74, ["Mega|Ride"] = 44.97, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 23.27, ["Fly|Ride"] = 58.35, ["Neon"] = 3.94, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 25.28, ["Neon|Fly|Ride"] = 67.69, ["Mega"] = 24.86, ["Mega|Fly"] = 72.07, ["Mega|Ride"] = 46.57, ["Mega|Fly|Ride"] = 144.8}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 3.61, ["Neon|Fly"] = 73.7, ["Neon|Ride"] = 98.27, ["Mega"] = 36.28, ["Mega|Ride"] = 181.77}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.63, ["Neon"] = 5.25, ["Neon|Fly|Ride"] = 420, ["Mega"] = 32.44, ["Mega|Ride"] = 292.69, ["Mega|Fly|Ride"] = 181.77}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.23, ["Ride"] = 17.07, ["Fly|Ride"] = 69.44, ["Neon"] = 5.99, ["Neon|Fly"] = 326.27, ["Neon|Ride"] = 21.94, ["Neon|Fly|Ride"] = 48.9, ["Mega"] = 34.13, ["Mega|Ride"] = 39.73, ["Mega|Fly|Ride"] = 111.74}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 7.86, ["Ride"] = 78.75, ["Neon"] = 126, ["Neon|Ride"] = 115.5, ["Mega"] = 389.82, ["Mega|Ride"] = 526.17, ["Mega|Fly|Ride"] = 639.62}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 54.03, ["Neon"] = 39.38, ["Neon|Ride"] = 157.5, ["Mega"] = 245.64, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 33.18, ["Fly|Ride"] = 183.67, ["Neon"] = 25.77, ["Neon|Ride"] = 144.8, ["Neon|Fly|Ride"] = 147.41, ["Mega"] = 313.37, ["Mega|Ride"] = 156.19, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 13.02, ["Ride"] = 12.85, ["Fly|Ride"] = 26.17, ["Neon"] = 2.63, ["Neon|Fly"] = 14.22, ["Neon|Ride"] = 14.21, ["Neon|Fly|Ride"] = 25.46, ["Mega"] = 16.12, ["Mega|Fly"] = 23.24, ["Mega|Ride"] = 20.64, ["Mega|Fly|Ride"] = 45.93}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 3.93, ["Fly"] = 118.13, ["Ride"] = 60.53, ["Neon"] = 12.07, ["Neon|Fly"] = 72.4, ["Neon|Ride"] = 31.82, ["Neon|Fly|Ride"] = 720.71, ["Mega"] = 42, ["Mega|Ride"] = 118.13}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.39, ["Neon"] = 2.1, ["Neon|Fly"] = 32.36, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 89.71, ["Mega"] = 15.07, ["Mega|Fly"] = 144.8, ["Mega|Ride"] = 34.13, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 9.19, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 129.22, ["Mega"] = 31.95, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 367.49}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 223.13, ["Ride"] = 19.14, ["Fly|Ride"] = 48.7, ["Neon"] = 12.11, ["Neon|Fly"] = 64.85, ["Neon|Ride"] = 28.06, ["Neon|Fly|Ride"] = 75.87, ["Mega"] = 149.13, ["Mega|Ride"] = 188.03, ["Mega|Fly|Ride"] = 275.6}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 217.33, ["Ride"] = 236.25, ["Fly|Ride"] = 864.34, ["Mega"] = 8644.17, ["Mega|Fly|Ride"] = 3538.29}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 6.2, ["Neon|Fly"] = 58.16, ["Neon|Ride"] = 64.32, ["Mega"] = 68.25, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 655.9}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.84, ["Fly"] = 103.69, ["Ride"] = 39.79, ["Fly|Ride"] = 65.63, ["Neon"] = 23.7, ["Neon|Ride"] = 135.18, ["Neon|Fly|Ride"] = 172.9, ["Mega"] = 396.31, ["Mega|Ride"] = 418.18, ["Mega|Fly|Ride"] = 387.87}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 19.66, ["Ride"] = 16.23, ["Fly|Ride"] = 36.75, ["Neon"] = 8.91, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 27, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 47.16, ["Mega|Ride"] = 106.98, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 72.42, ["Ride"] = 18.38, ["Fly|Ride"] = 142.62, ["Neon"] = 10.82, ["Neon|Ride"] = 72.34, ["Neon|Fly|Ride"] = 115.63, ["Mega"] = 100.96, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 4.72, ["Fly"] = 27.97, ["Ride"] = 15.17, ["Fly|Ride"] = 39.36, ["Neon"] = 32.82, ["Neon|Fly"] = 101.25, ["Neon|Ride"] = 33.44, ["Neon|Fly|Ride"] = 86.52, ["Mega"] = 144.38, ["Mega|Ride"] = 960.6, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.5, ["Ride"] = 26.25, ["Fly|Ride"] = 259.91, ["Neon"] = 42.98, ["Neon|Fly|Ride"] = 432.17, ["Mega"] = 259.87, ["Mega|Ride"] = 389.01, ["Mega|Fly|Ride"] = 347.82}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 3.68, ["Fly"] = 22.3, ["Ride"] = 18.38, ["Fly|Ride"] = 37.37, ["Neon"] = 42.78, ["Neon|Fly"] = 129.57, ["Neon|Ride"] = 41.98, ["Neon|Fly|Ride"] = 77.44, ["Mega|Ride"] = 374.95, ["Mega|Fly|Ride"] = 261.98}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 66.94, ["Fly"] = 164.58, ["Ride"] = 90.04, ["Fly|Ride"] = 161.13, ["Neon"] = 334.57, ["Neon|Fly"] = 450.19, ["Neon|Ride"] = 332.07, ["Neon|Fly|Ride"] = 366.19, ["Mega|Ride"] = 1873.41, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 225.75, ["Fly"] = 288.51, ["Ride"] = 227.07, ["Fly|Ride"] = 281.69, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1268.39, ["Mega"] = 12966.27, ["Mega|Fly|Ride"] = 3745.73}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 71.32, ["Fly"] = 101.58, ["Ride"] = 70.28, ["Fly|Ride"] = 103.94, ["Neon"] = 729.51, ["Neon|Fly"] = 366.32, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 321.34, ["Mega"] = 1441.26, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 4.97, ["Fly"] = 288.42, ["Ride"] = 25.64, ["Fly|Ride"] = 72.4, ["Neon"] = 25.92, ["Neon|Fly"] = 101.57, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 149.63, ["Mega"] = 287.44, ["Mega|Ride"] = 209.34, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 16.42, ["Fly"] = 63, ["Ride"] = 32.81, ["Fly|Ride"] = 65.63, ["Neon"] = 65.63, ["Neon|Ride"] = 129.68, ["Neon|Fly|Ride"] = 144.79, ["Mega"] = 314.98, ["Mega|Ride"] = 368.73, ["Mega|Fly|Ride"] = 379.2}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 39.31, ["Ride"] = 16.23, ["Fly|Ride"] = 86.44, ["Neon"] = 2.3, ["Neon|Fly"] = 57.44, ["Neon|Ride"] = 24.69, ["Neon|Fly|Ride"] = 52.95, ["Mega"] = 86.45, ["Mega|Fly"] = 154.88, ["Mega|Ride"] = 86.63, ["Mega|Fly|Ride"] = 558.8}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 13.54, ["Fly"] = 69.17, ["Ride"] = 32.82, ["Fly|Ride"] = 82.14, ["Neon"] = 124.69, ["Neon|Fly"] = 288.51, ["Neon|Ride"] = 172.88, ["Neon|Fly|Ride"] = 331.73, ["Mega"] = 720.63, ["Mega|Ride"] = 648.33, ["Mega|Fly|Ride"] = 509.69}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 16.01, ["Fly|Ride"] = 43.44, ["Neon"] = 18.38, ["Neon|Fly"] = 82.31, ["Neon|Ride"] = 29.09, ["Neon|Fly|Ride"] = 98.27, ["Mega"] = 144.38, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 300.37}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 3.82, ["Ride"] = 21.62, ["Fly|Ride"] = 328.13, ["Neon"] = 39.51, ["Neon|Ride"] = 115.62, ["Mega"] = 207.37, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 27.99, ["Ride"] = 19.39, ["Neon"] = 2.1, ["Neon|Ride"] = 17.25, ["Neon|Fly|Ride"] = 58.24, ["Mega"] = 15.65, ["Mega|Ride"] = 38.92, ["Mega|Fly|Ride"] = 72.19}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.09, ["Ride"] = 19.04, ["Fly|Ride"] = 56.44, ["Neon"] = 12.39, ["Neon|Fly"] = 108.07, ["Neon|Ride"] = 36.74, ["Neon|Fly|Ride"] = 146.99, ["Mega"] = 78.73, ["Mega|Ride"] = 144.8, ["Mega|Fly|Ride"] = 216.12}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 22.29, ["Fly|Ride"] = 83.83, ["Neon"] = 22.93, ["Neon|Fly"] = 98.27, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 125.36, ["Mega"] = 144.38, ["Mega|Ride"] = 164.6, ["Mega|Fly|Ride"] = 267.99}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 108.94, ["Fly"] = 149.63, ["Ride"] = 144.8, ["Fly|Ride"] = 190.32, ["Neon"] = 430.39, ["Neon|Ride"] = 472.49, ["Neon|Fly|Ride"] = 509.24, ["Mega"] = 2456.52, ["Mega|Fly|Ride"] = 1975.32}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.7, ["Fly"] = 115.62, ["Ride"] = 240.93, ["Fly|Ride"] = 131.25, ["Neon"] = 49.88, ["Neon|Ride"] = 89.25, ["Neon|Fly|Ride"] = 215.25, ["Mega"] = 326.82, ["Mega|Ride"] = 285.87, ["Mega|Fly|Ride"] = 421.37}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.62, ["Fly"] = 45.85, ["Ride"] = 16.23, ["Fly|Ride"] = 51.48, ["Neon"] = 24.83, ["Neon|Ride"] = 62.91, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 274.44, ["Mega|Ride"] = 192.94, ["Mega|Fly|Ride"] = 328.12}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 22.22, ["Ride"] = 39.38, ["Fly|Ride"] = 170.63, ["Neon"] = 96.33, ["Neon|Ride"] = 200.23, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 525.65, ["Mega|Fly"] = 864.44, ["Mega|Ride"] = 515.82, ["Mega|Fly|Ride"] = 1080.54}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 5.25}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 6.45, ["Fly"] = 22.32, ["Ride"] = 72.39, ["Fly|Ride"] = 128.6, ["Neon"] = 72.19, ["Neon|Ride"] = 115.62, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 864.32, ["Mega|Ride"] = 633.12, ["Mega|Fly|Ride"] = 501.93}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 17.07, ["Fly"] = 25.99, ["Ride"] = 30.33, ["Fly|Ride"] = 52.32, ["Neon"] = 406.31, ["Neon|Fly"] = 21610.42, ["Neon|Ride"] = 136.33, ["Neon|Fly|Ride"] = 150.93, ["Mega"] = 1394.96, ["Mega|Fly|Ride"] = 562.16}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 43.32, ["Neon"] = 3.9, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 72.4, ["Mega"] = 25.88, ["Mega|Fly"] = 188.03, ["Mega|Ride"] = 87.22}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 7.35, ["Fly"] = 26.25, ["Ride"] = 24.59, ["Fly|Ride"] = 91.88, ["Neon"] = 64.86, ["Mega"] = 287.39, ["Mega|Fly"] = 410.26, ["Mega|Ride"] = 275.63}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 28.97, ["Ride"] = 19.46, ["Fly|Ride"] = 42.75, ["Neon"] = 21, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 30.87, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 193.43, ["Mega|Ride"] = 245.26, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Fly|Ride"] = 118.13, ["Neon"] = 3.87, ["Neon|Ride"] = 41.77, ["Mega"] = 144.8, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 164.07, ["Fly"] = 105, ["Ride"] = 63.57, ["Fly|Ride"] = 140.46, ["Neon"] = 189.09, ["Neon|Ride"] = 267.99, ["Neon|Fly|Ride"] = 609, ["Mega"] = 985.37, ["Mega|Ride"] = 682.17, ["Mega|Fly|Ride"] = 766.74}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 4.11, ["Ride"] = 48.57, ["Fly|Ride"] = 87.59, ["Neon"] = 95.82, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 183.75, ["Mega|Ride"] = 360.87}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 2.24, ["Fly"] = 33.18, ["Ride"] = 23.35, ["Fly|Ride"] = 57.74, ["Neon"] = 13.11, ["Neon|Fly"] = 86.44, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 105, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 57.17, ["Fly"] = 145.01, ["Ride"] = 84, ["Neon"] = 347.04, ["Neon|Ride"] = 382.52, ["Neon|Fly|Ride"] = 552.67, ["Mega"] = 4587.01, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 7.07, ["Fly"] = 48.06, ["Ride"] = 22.95, ["Fly|Ride"] = 52.5, ["Neon"] = 37.2, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 114.18, ["Mega"] = 221.61, ["Mega|Fly"] = 368.5, ["Mega|Ride"] = 240.91, ["Mega|Fly|Ride"] = 400.84}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 85.16, ["Fly"] = 186.38, ["Ride"] = 124.69, ["Fly|Ride"] = 204.64, ["Neon"] = 262.4, ["Neon|Ride"] = 272.87, ["Neon|Fly|Ride"] = 405.29, ["Mega"] = 2091.91, ["Mega|Fly|Ride"] = 1122.49}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 20.88, ["Ride"] = 43.22, ["Fly|Ride"] = 157.5, ["Neon"] = 68.25, ["Neon|Ride"] = 118.32, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 354.38, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 453.48}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 6.83, ["Fly"] = 65.63, ["Ride"] = 32.82, ["Fly|Ride"] = 72.42, ["Neon"] = 188.03, ["Neon|Ride"] = 156, ["Neon|Fly|Ride"] = 143.35, ["Mega"] = 655.82, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 20.93, ["Fly"] = 78.75, ["Ride"] = 54.91, ["Fly|Ride"] = 213.93, ["Neon"] = 76.13, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 282.19, ["Mega"] = 473.59, ["Mega|Ride"] = 387.85, ["Mega|Fly|Ride"] = 432.91}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 7.49, ["Ride"] = 25.89, ["Fly|Ride"] = 85.32, ["Neon"] = 49.14, ["Neon|Ride"] = 57.62, ["Neon|Fly|Ride"] = 161.68, ["Mega"] = 249.38, ["Mega|Ride"] = 246.75, ["Mega|Fly|Ride"] = 483}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 196.88, ["Mega"] = 19.69, ["Mega|Ride"] = 86.44, ["Mega|Fly|Ride"] = 288.36}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 8.98, ["Ride"] = 136.49, ["Fly|Ride"] = 325.89, ["Neon"] = 58.36, ["Neon|Ride"] = 239.76, ["Mega"] = 223.88, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 1031.81}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 128.6, ["Ride"] = 29.19, ["Neon"] = 9.85, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 255.29, ["Mega|Ride"] = 168, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 3.78, ["Ride"] = 38.07, ["Neon"] = 15.75, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 187.69, ["Mega|Ride"] = 288.51, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 485.63, ["Ride"] = 551.25, ["Fly|Ride"] = 610.32, ["Neon|Ride"] = 1771.88, ["Neon|Fly|Ride"] = 1653.64, ["Mega|Fly|Ride"] = 4830}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 5.02, ["Fly"] = 45.4, ["Ride"] = 23.3, ["Fly|Ride"] = 65.63, ["Neon"] = 46.48, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 342.69, ["Mega"] = 202.08, ["Mega|Ride"] = 377.09, ["Mega|Fly|Ride"] = 360.91}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 8.32, ["Fly"] = 66.94, ["Ride"] = 20.69, ["Fly|Ride"] = 55.78, ["Neon"] = 101.58, ["Neon|Fly"] = 315, ["Neon|Ride"] = 96.14, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 331.88, ["Mega|Ride"] = 265.8, ["Mega|Fly|Ride"] = 331.7}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 5.81, ["Fly"] = 24.93, ["Ride"] = 24.59, ["Fly|Ride"] = 50.9, ["Neon|Ride"] = 32.3, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 198.19}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 58.08, ["Ride"] = 29.19, ["Fly|Ride"] = 90.57, ["Neon"] = 14.34, ["Neon|Fly"] = 70.02, ["Neon|Ride"] = 35.43, ["Neon|Fly|Ride"] = 114.35, ["Mega"] = 144.8, ["Mega|Ride"] = 102.36, ["Mega|Fly|Ride"] = 215.01}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 26.23, ["Ride"] = 38.98, ["Fly|Ride"] = 52.5, ["Neon"] = 3.35, ["Neon|Ride"] = 32.33, ["Neon|Fly|Ride"] = 104.98, ["Mega"] = 20.6, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 145.04}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1376.82}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 5.65, ["Ride"] = 41.06, ["Fly|Ride"] = 118.13, ["Neon"] = 74.95, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 362.31, ["Mega"] = 315, ["Mega|Ride"] = 864.32, ["Mega|Fly|Ride"] = 490.88}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 19.46, ["Neon"] = 5.25, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 1009.22, ["Mega"] = 72.3, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 183.74}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 24.93, ["Fly"] = 335.14, ["Ride"] = 101.28, ["Fly|Ride"] = 202.08, ["Neon"] = 54.06, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 236.15, ["Mega"] = 288.48, ["Mega|Ride"] = 389.01, ["Mega|Fly|Ride"] = 485.17}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 388.19, ["Fly"] = 533.1, ["Ride"] = 431.82, ["Fly|Ride"] = 472.5, ["Neon|Ride"] = 1712.21, ["Neon|Fly|Ride"] = 1365, ["Mega"] = 8103.92, ["Mega|Fly|Ride"] = 6357.75}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 6.71, ["Fly"] = 196.88, ["Ride"] = 43.23, ["Neon"] = 31.5, ["Neon|Ride"] = 62.99, ["Neon|Fly|Ride"] = 196.54, ["Mega"] = 353.3, ["Mega|Ride"] = 362.77, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Ride"] = 32.81, ["Fly|Ride"] = 118.11, ["Neon"] = 6.56, ["Neon|Ride"] = 30.96, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 105, ["Mega|Fly"] = 115.63, ["Mega|Ride"] = 67.56, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Fly|Ride"] = 101.73, ["Neon"] = 6.57, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 144.9, ["Mega"] = 31.47, ["Mega|Ride"] = 129.66, ["Mega|Fly|Ride"] = 216.12}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 28.25, ["Fly"] = 115.64, ["Ride"] = 109.01, ["Neon"] = 720.71, ["Neon|Ride"] = 432.23, ["Mega"] = 622.91, ["Mega|Ride"] = 620.16, ["Mega|Fly|Ride"] = 830.82}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 7.6, ["Neon"] = 86.62, ["Neon|Ride"] = 271.23, ["Neon|Fly|Ride"] = 864.44, ["Mega"] = 1152.81, ["Mega|Ride"] = 485.63, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 7.22, ["Ride"] = 76, ["Neon"] = 101.07, ["Neon|Ride"] = 200.82, ["Mega"] = 729.61, ["Mega|Ride"] = 638.61, ["Mega|Fly|Ride"] = 1237.49}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 25.98, ["Ride"] = 56.36, ["Fly|Ride"] = 236.25, ["Neon"] = 167.37, ["Neon|Ride"] = 181.13, ["Neon|Fly|Ride"] = 241.5, ["Mega"] = 1680, ["Mega|Ride"] = 1728.85, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 367.5, ["Ride"] = 393.74, ["Fly|Ride"] = 681.71, ["Neon"] = 1069.69, ["Neon|Ride"] = 1478.18, ["Neon|Fly|Ride"] = 1403.43, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 21.52, ["Ride"] = 33.11, ["Fly|Ride"] = 230.11, ["Neon"] = 172.88, ["Neon|Ride"] = 194.49, ["Neon|Fly|Ride"] = 287.55, ["Mega|Ride"] = 547.98, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 5.02, ["Ride"] = 27.72, ["Fly|Ride"] = 127.32, ["Neon"] = 36.75, ["Neon|Ride"] = 105, ["Mega"] = 170.63, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 58.36, ["Ride"] = 144.8, ["Neon"] = 216.57, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 623.6, ["Mega"] = 481.7, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 705.23}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.56, ["Ride"] = 72.19, ["Fly|Ride"] = 216.12, ["Neon"] = 16.23, ["Neon|Fly"] = 86.45, ["Neon|Ride"] = 82.31, ["Neon|Fly|Ride"] = 144.8, ["Mega"] = 47.55, ["Mega|Fly"] = 245.66, ["Mega|Ride"] = 180.46, ["Mega|Fly|Ride"] = 288.48}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 51.19, ["Ride"] = 98.44, ["Fly|Ride"] = 213.71, ["Neon"] = 262.48, ["Neon|Ride"] = 360.91, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1350.93, ["Mega|Ride"] = 1152.41, ["Mega|Fly|Ride"] = 1728.64}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 58.36, ["Ride"] = 28.75, ["Neon"] = 11.82, ["Neon|Fly"] = 188.03, ["Neon|Ride"] = 70.97, ["Neon|Fly|Ride"] = 111.55, ["Mega"] = 120.65, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 212.9}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 71.15, ["Neon"] = 3.81, ["Neon|Ride"] = 37.84, ["Neon|Fly|Ride"] = 144.79, ["Mega"] = 36.75, ["Mega|Fly"] = 118.02, ["Mega|Ride"] = 75.55, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 26.23, ["Fly|Ride"] = 131.43, ["Neon"] = 12.91, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 95.82, ["Mega|Ride"] = 216.09, ["Mega|Fly|Ride"] = 262.86}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 80.76, ["Fly"] = 105, ["Ride"] = 78.71, ["Fly|Ride"] = 164.58, ["Neon"] = 367.5, ["Neon|Ride"] = 366.85, ["Neon|Fly|Ride"] = 491.26, ["Mega|Ride"] = 1131.18, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 4.32, ["Neon"] = 7.88, ["Neon|Fly"] = 350.44, ["Mega"] = 57.21, ["Mega|Fly"] = 288.48, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 347.82}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 26.16, ["Fly|Ride"] = 72.45, ["Neon"] = 6.35, ["Neon|Ride"] = 140.34, ["Mega"] = 57.75, ["Mega|Fly"] = 210, ["Mega|Ride"] = 97.13, ["Mega|Fly|Ride"] = 244.4}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.59, ["Fly"] = 86.45, ["Ride"] = 32.82, ["Fly|Ride"] = 98.44, ["Neon"] = 32.82, ["Neon|Fly|Ride"] = 164.6, ["Mega"] = 327.92, ["Mega|Ride"] = 355.11, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 9.08, ["Fly"] = 66.94, ["Ride"] = 52.49, ["Fly|Ride"] = 114.19, ["Neon"] = 38.07, ["Neon|Ride"] = 68.24, ["Mega"] = 182.44, ["Mega|Ride"] = 321.98, ["Mega|Fly|Ride"] = 518.61}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 71.61, ["Neon"] = 6.3, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 215.01, ["Mega"] = 97.25, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 294.79}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.47, ["Fly|Ride"] = 62.86, ["Neon"] = 5.25, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 27.55, ["Neon|Fly|Ride"] = 104.54, ["Mega"] = 39.38, ["Mega|Ride"] = 99.41, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 23.56, ["Fly|Ride"] = 57.53, ["Neon"] = 14.22, ["Neon|Fly"] = 102.67, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 95.09, ["Mega"] = 238.8, ["Mega|Ride"] = 243.73, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 25.39, ["Fly"] = 72.42, ["Ride"] = 64.97, ["Fly|Ride"] = 129.68, ["Neon"] = 144.38, ["Neon|Ride"] = 108.06, ["Neon|Fly|Ride"] = 280.94, ["Mega"] = 485.63, ["Mega|Fly"] = 432.17, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 668.85}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 57.37, ["Ride"] = 97.44, ["Fly|Ride"] = 131.25, ["Neon"] = 374.07, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 374.92, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 2881.41, ["Mega|Ride"] = 1801.87, ["Mega|Fly|Ride"] = 1573.69}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 19.55, ["Neon"] = 5.25, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 144.8, ["Mega"] = 48.47, ["Mega|Fly"] = 672, ["Mega|Ride"] = 81.05, ["Mega|Fly|Ride"] = 267.95}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 18.13, ["Ride"] = 14.4, ["Fly|Ride"] = 43.23, ["Neon"] = 3.94, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 38.72, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 11.15, ["Fly"] = 183.75, ["Ride"] = 38.03, ["Neon"] = 40.69, ["Neon|Ride"] = 160.12, ["Neon|Fly|Ride"] = 144.8, ["Mega"] = 553.24, ["Mega|Ride"] = 275.62, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 389.82, ["Ride"] = 624.48, ["Fly|Ride"] = 584.07, ["Neon"] = 4322.1, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 6163.5}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 21.62, ["Fly"] = 61.69, ["Ride"] = 59.31, ["Fly|Ride"] = 124.77, ["Neon"] = 249.37, ["Neon|Ride"] = 229.67, ["Neon|Fly|Ride"] = 258.05, ["Mega"] = 721.88, ["Mega|Ride"] = 842.72, ["Mega|Fly|Ride"] = 918.35}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 24.93, ["Fly|Ride"] = 288.51, ["Neon"] = 10.43, ["Neon|Ride"] = 55, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 72.4, ["Mega|Ride"] = 141.42, ["Mega|Fly|Ride"] = 318.73}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.63, ["Fly"] = 105, ["Ride"] = 65.62, ["Fly|Ride"] = 261.98, ["Neon"] = 36.71, ["Mega"] = 159.93}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 77.97, ["Fly"] = 168.91, ["Ride"] = 46.25, ["Fly|Ride"] = 97.25, ["Neon"] = 194.25, ["Neon|Ride"] = 261.19, ["Neon|Fly|Ride"] = 288.51, ["Mega"] = 2593.26, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 864.44}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 103.95, ["Fly"] = 163.16, ["Ride"] = 144.15, ["Fly|Ride"] = 190.32, ["Neon"] = 525.71, ["Neon|Fly"] = 1152.93, ["Neon|Ride"] = 539.14, ["Neon|Fly|Ride"] = 446.25, ["Mega"] = 3170.27, ["Mega|Fly|Ride"] = 1982.43}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 225.75, ["Ride"] = 275.63, ["Fly|Ride"] = 367.5, ["Neon"] = 1050, ["Neon|Ride"] = 800.63, ["Neon|Fly|Ride"] = 1035.57, ["Mega|Fly|Ride"] = 2867.82}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 13.12, ["Ride"] = 61.09, ["Fly|Ride"] = 246.91, ["Neon"] = 72.1, ["Neon|Fly"] = 275.55, ["Neon|Ride"] = 99.74, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 324.84, ["Mega|Ride"] = 380.62, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 19.25, ["Fly|Ride"] = 39.37, ["Neon"] = 8.65, ["Neon|Ride"] = 29.17, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 78.65, ["Mega|Ride"] = 111.57, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 19.84, ["Fly|Ride"] = 62.99, ["Neon"] = 20.99, ["Neon|Fly"] = 151.3, ["Neon|Ride"] = 42.87, ["Neon|Fly|Ride"] = 95.04, ["Mega"] = 293.08, ["Mega|Ride"] = 240.19, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 275.63, ["Ride"] = 368.45, ["Fly|Ride"] = 576.03, ["Neon"] = 1562.54, ["Neon|Fly|Ride"] = 1655.18, ["Mega"] = 10805.22, ["Mega|Fly|Ride"] = 6913.18}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 33.51, ["Neon"] = 8.44, ["Neon|Ride"] = 140.83, ["Mega"] = 24.21, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 318.94}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.73, ["Fly"] = 19.48, ["Ride"] = 18.05, ["Fly|Ride"] = 43.14, ["Neon"] = 28.88, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 81.96, ["Mega"] = 131.25, ["Mega|Ride"] = 171.81, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 18.96, ["Fly"] = 6562.5, ["Ride"] = 59.07, ["Fly|Ride"] = 144.8, ["Neon"] = 106.31, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 136.15, ["Neon|Fly|Ride"] = 328.12, ["Mega"] = 577.5, ["Mega|Ride"] = 716.31, ["Mega|Fly|Ride"] = 624.71}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 142.63, ["Fly"] = 157.5, ["Ride"] = 216.09, ["Fly|Ride"] = 164.06, ["Neon|Ride"] = 819.16, ["Neon|Fly|Ride"] = 630, ["Mega|Fly|Ride"] = 2665.34}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 18.79, ["Fly"] = 39.26, ["Ride"] = 28.32, ["Fly|Ride"] = 52.5, ["Neon"] = 105.23, ["Neon|Ride"] = 102.38, ["Neon|Fly|Ride"] = 138.5, ["Mega"] = 504.62, ["Mega|Ride"] = 422.68, ["Mega|Fly|Ride"] = 576.94}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 62.54, ["Neon"] = 3.73, ["Neon|Ride"] = 79.97, ["Neon|Fly|Ride"] = 63, ["Mega"] = 24.93, ["Mega|Ride"] = 172.29, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 32.7, ["Ride"] = 18.38, ["Fly|Ride"] = 59.07, ["Neon"] = 2.63, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 28.14, ["Neon|Fly|Ride"] = 78.73, ["Mega"] = 24.82, ["Mega|Fly"] = 101.58, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 140.02}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 13.9, ["Ride"] = 92.93, ["Fly|Ride"] = 209.02, ["Neon"] = 39.38, ["Neon|Ride"] = 115.62, ["Neon|Fly|Ride"] = 294.76, ["Mega"] = 162.41, ["Mega|Ride"] = 288.48, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1243.14, ["Ride"] = 1302, ["Fly|Ride"] = 1397.82, ["Neon"] = 4466.89, ["Neon|Ride"] = 4321.58, ["Neon|Fly|Ride"] = 4017.24, ["Mega|Fly|Ride"] = 11883.38}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 420, ["Fly"] = 561.83, ["Ride"] = 498.75, ["Fly|Ride"] = 543.5, ["Neon"] = 1680, ["Neon|Ride"] = 1443.74, ["Neon|Fly|Ride"] = 1573.69, ["Mega"] = 15127.3, ["Mega|Fly|Ride"] = 6547.85}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 284.82, ["Fly"] = 417.58, ["Ride"] = 347.82, ["Fly|Ride"] = 415.78, ["Neon"] = 734.68, ["Neon|Ride"] = 720.63, ["Neon|Fly|Ride"] = 727.63, ["Mega"] = 4035.28, ["Mega|Ride"] = 3603.55, ["Mega|Fly|Ride"] = 2916.24}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 236.23, ["Fly"] = 357.62, ["Ride"] = 307.16, ["Fly|Ride"] = 355.16, ["Neon"] = 1441.42, ["Neon|Ride"] = 828.69, ["Neon|Fly|Ride"] = 703.5, ["Mega|Fly|Ride"] = 3555.58}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 18.37, ["Fly|Ride"] = 52.5, ["Neon"] = 9.92, ["Neon|Ride"] = 33.5, ["Neon|Fly|Ride"] = 115.46, ["Mega"] = 56.59, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 323.44, ["Fly"] = 1441.42, ["Ride"] = 354.38, ["Fly|Ride"] = 576.94, ["Neon"] = 1312.5, ["Neon|Ride"] = 1295.4, ["Neon|Fly|Ride"] = 1426.13, ["Mega"] = 21898.93, ["Mega|Ride"] = 6194.98, ["Mega|Fly|Ride"] = 4912.47}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 10.5, ["Fly"] = 183.74, ["Ride"] = 150.19, ["Neon"] = 73.5, ["Neon|Ride"] = 216.09, ["Mega"] = 229.69, ["Mega|Ride"] = 360.87, ["Mega|Fly|Ride"] = 821.1}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 23.57, ["Ride"] = 15.65, ["Fly|Ride"] = 37.05, ["Neon"] = 8.91, ["Neon|Ride"] = 54.05, ["Neon|Fly|Ride"] = 105, ["Mega"] = 129.66, ["Mega|Ride"] = 192.31}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Mega"] = 19.59, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 177.62}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 49.71, ["Ride"] = 131.25, ["Fly|Ride"] = 459.38, ["Neon"] = 245.44, ["Neon|Ride"] = 359.73, ["Mega"] = 1049.9, ["Mega|Ride"] = 733.69, ["Mega|Fly|Ride"] = 820.13}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 8188.81, ["Ride"] = 19.04, ["Fly|Ride"] = 68.25, ["Neon"] = 31.91, ["Mega"] = 345.78, ["Mega|Ride"] = 303.57, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Fly"] = 72.42, ["Ride"] = 32.82, ["Neon"] = 3.94, ["Neon|Ride"] = 57.73, ["Neon|Fly|Ride"] = 141.93, ["Mega"] = 23.45, ["Mega|Fly"] = 166.94, ["Mega|Ride"] = 61.3, ["Mega|Fly|Ride"] = 135.82}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 16.23, ["Fly"] = 131.06, ["Ride"] = 81.05, ["Fly|Ride"] = 91.46, ["Neon"] = 42, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 144.35, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 213.52, ["Mega|Ride"] = 277.2, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 5.55, ["Fly"] = 32.43, ["Ride"] = 18.37, ["Fly|Ride"] = 56.7, ["Neon"] = 27.57, ["Neon|Fly"] = 819.27, ["Neon|Ride"] = 58.36, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 238.86, ["Mega|Ride"] = 271, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 16.14, ["Ride"] = 42.15, ["Fly|Ride"] = 164.6, ["Neon"] = 68.25, ["Neon|Ride"] = 386.85, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 524.99, ["Mega|Ride"] = 557.65}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 3.8, ["Fly"] = 6551.54, ["Ride"] = 24.61, ["Neon"] = 69.57, ["Neon|Ride"] = 214.92, ["Neon|Fly|Ride"] = 736.88, ["Mega"] = 420, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 557.51}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 72.24, ["Ride"] = 16.54, ["Fly|Ride"] = 44.57, ["Neon"] = 4.24, ["Neon|Fly"] = 81.65, ["Neon|Ride"] = 28.77, ["Neon|Fly|Ride"] = 129.68, ["Mega"] = 66.33, ["Mega|Fly|Ride"] = 245.66}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 163.96, ["Fly"] = 199.5, ["Ride"] = 196.86, ["Fly|Ride"] = 280.88, ["Neon"] = 1009.11, ["Neon|Ride"] = 2701.33, ["Neon|Fly|Ride"] = 982.63, ["Mega"] = 8644.17, ["Mega|Fly|Ride"] = 4753.73}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 25.94, ["Ride"] = 16.23, ["Fly|Ride"] = 36.75, ["Neon"] = 3.9, ["Neon|Fly"] = 36.86, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 39.38, ["Mega|Ride"] = 43.36, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 8.88, ["Fly"] = 65.63, ["Ride"] = 47.16, ["Fly|Ride"] = 231.14, ["Neon"] = 98.27, ["Neon|Ride"] = 145.89, ["Neon|Fly|Ride"] = 319.81, ["Mega"] = 511.35, ["Mega|Ride"] = 309.74, ["Mega|Fly|Ride"] = 391.12}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 30.29, ["Ride"] = 72.19, ["Fly|Ride"] = 183.75, ["Neon"] = 249.38, ["Neon|Ride"] = 355.69, ["Neon|Fly|Ride"] = 466.83, ["Mega"] = 780.13, ["Mega|Ride"] = 1014.5, ["Mega|Fly|Ride"] = 944.99}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 196.88, ["Ride"] = 258.83, ["Fly|Ride"] = 275.87, ["Neon"] = 620.82, ["Neon|Fly"] = 1638.52, ["Neon|Ride"] = 711.37, ["Neon|Fly|Ride"] = 732.27, ["Mega"] = 3603.55, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 13.13, ["Fly"] = 164.6, ["Ride"] = 164.6, ["Neon"] = 144.8, ["Neon|Ride"] = 144.8, ["Mega"] = 287.34, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 410.55}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 13.11, ["Ride"] = 58.35, ["Fly|Ride"] = 72.4, ["Neon"] = 91.88, ["Neon|Fly"] = 164.6, ["Mega"] = 1728.85, ["Mega|Ride"] = 1441.42, ["Mega|Fly|Ride"] = 864.32}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 938.44, ["Ride"] = 990.84, ["Fly|Ride"] = 1050, ["Neon|Ride"] = 4383.75, ["Neon|Fly|Ride"] = 4173.57, ["Mega|Fly|Ride"] = 17826.47}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 5.81, ["Fly"] = 22.32, ["Ride"] = 21, ["Fly|Ride"] = 45.93, ["Neon"] = 51.19, ["Neon|Fly"] = 76.46, ["Neon|Ride"] = 86.45, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 245.66, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 302.3}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 6.02, ["Fly"] = 51.19, ["Ride"] = 41.15, ["Neon"] = 32.48, ["Neon|Ride"] = 86.45, ["Mega"] = 229.69, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 287.39, ["Mega|Fly|Ride"] = 341.23}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.62, ["Fly"] = 86.45, ["Ride"] = 22.09, ["Fly|Ride"] = 895.18, ["Neon"] = 9.1, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 245.26, ["Mega"] = 83.22, ["Mega|Ride"] = 360.91, ["Mega|Fly|Ride"] = 290.07}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 19.46, ["Ride"] = 30.98, ["Fly|Ride"] = 105.66, ["Neon"] = 69.37, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 198.95, ["Mega"] = 393.75, ["Mega|Ride"] = 427.49, ["Mega|Fly|Ride"] = 471.34}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 4.54, ["Fly"] = 27.97, ["Ride"] = 19.69, ["Fly|Ride"] = 42.68, ["Neon"] = 19.28, ["Neon|Fly"] = 41.06, ["Neon|Ride"] = 34.58, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 194.21, ["Mega|Fly"] = 280.98, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 194.24}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 8.18, ["Fly"] = 32.75, ["Ride"] = 32.24, ["Fly|Ride"] = 131.25, ["Neon"] = 15.74, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 107.55, ["Mega"] = 152.23, ["Mega|Ride"] = 227.07, ["Mega|Fly|Ride"] = 275.62}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 255.5, ["Ride"] = 240.73, ["Fly|Ride"] = 432.23, ["Neon|Fly|Ride"] = 1183.01, ["Mega|Fly|Ride"] = 3439.14}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 21.41, ["Fly|Ride"] = 105.59, ["Neon"] = 7.39, ["Neon|Ride"] = 83.53, ["Neon|Fly|Ride"] = 301.31, ["Mega"] = 80.07, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 345.74}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.3, ["Ride"] = 65.62, ["Fly|Ride"] = 88.87, ["Neon"] = 19.11, ["Neon|Fly"] = 196.88, ["Mega"] = 180.46, ["Mega|Ride"] = 352.26}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 10.39, ["Fly"] = 94.76, ["Ride"] = 42.95, ["Neon"] = 12.81, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 105.9, ["Mega"] = 116.82, ["Mega|Ride"] = 164.06, ["Mega|Fly|Ride"] = 577.01}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 90.79, ["Ride"] = 137.45, ["Fly|Ride"] = 261.19, ["Neon"] = 447.57, ["Neon|Ride"] = 535.88, ["Neon|Fly|Ride"] = 548.63, ["Mega"] = 2592.96, ["Mega|Ride"] = 1511.49, ["Mega|Fly|Ride"] = 1450.53}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 32.44, ["Fly"] = 90.79, ["Ride"] = 58.35, ["Fly|Ride"] = 288.51, ["Neon"] = 126, ["Neon|Ride"] = 213.95, ["Neon|Fly|Ride"] = 341.93, ["Mega"] = 687.15, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 754.21}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 16.23, ["Fly"] = 263.44, ["Ride"] = 72.19, ["Fly|Ride"] = 115.62, ["Neon"] = 101.61, ["Neon|Ride"] = 106.37, ["Neon|Fly|Ride"] = 205.71, ["Mega"] = 414.36, ["Mega|Ride"] = 437.52, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.63, ["Neon"] = 129.57, ["Neon|Ride"] = 210}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 54.04, ["Fly"] = 58.35, ["Ride"] = 70.17, ["Fly|Ride"] = 141.65, ["Neon"] = 183.75, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 229.68, ["Neon|Fly|Ride"] = 284.82, ["Mega|Fly|Ride"] = 1179.94}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Fly"] = 23.79, ["Ride"] = 45.4, ["Fly|Ride"] = 216.09, ["Neon"] = 6.41, ["Neon|Fly|Ride"] = 101.58, ["Mega"] = 101.57, ["Mega|Ride"] = 288.51, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 16.96, ["Fly"] = 53.82, ["Ride"] = 25.95, ["Fly|Ride"] = 73.48, ["Neon"] = 64.56, ["Neon|Fly"] = 84, ["Neon|Ride"] = 82.22, ["Neon|Fly|Ride"] = 164.6, ["Mega"] = 364.34, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 386.79, ["Mega|Fly|Ride"] = 655.82}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 58.06, ["Fly"] = 203.44, ["Ride"] = 97.28, ["Fly|Ride"] = 132.57, ["Neon"] = 270.38, ["Neon|Fly"] = 328.13, ["Neon|Ride"] = 282.19, ["Neon|Fly|Ride"] = 359.61, ["Mega|Ride"] = 1478.18, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 16.22, ["Fly|Ride"] = 32.44, ["Neon"] = 2.6, ["Neon|Fly"] = 28.11, ["Neon|Ride"] = 19.38, ["Neon|Fly|Ride"] = 43.31, ["Mega"] = 16.89, ["Mega|Fly"] = 77.44, ["Mega|Ride"] = 42.99, ["Mega|Fly|Ride"] = 94.85}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.3, ["Ride"] = 51.89, ["Fly|Ride"] = 131.25, ["Neon"] = 17.38, ["Neon|Ride"] = 86.44, ["Neon|Fly|Ride"] = 161.37, ["Mega"] = 145.56, ["Mega|Ride"] = 221.03, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 15.75, ["Fly"] = 87.94, ["Ride"] = 56.53, ["Fly|Ride"] = 124.26, ["Neon"] = 118.13, ["Neon|Ride"] = 158.32, ["Neon|Fly|Ride"] = 327.92, ["Mega"] = 536.82, ["Mega|Ride"] = 531.34, ["Mega|Fly|Ride"] = 531.57}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 17.07, ["Neon"] = 2.3, ["Neon|Ride"] = 58.36, ["Neon|Fly|Ride"] = 103.04, ["Mega"] = 28.11, ["Mega|Ride"] = 50.79, ["Mega|Fly|Ride"] = 120.75}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 44.63, ["Fly"] = 210, ["Ride"] = 108.94, ["Fly|Ride"] = 288.75, ["Neon"] = 168.91, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 418.14, ["Mega"] = 720.63, ["Mega|Fly"] = 918.75, ["Mega|Ride"] = 727.33, ["Mega|Fly|Ride"] = 984.12}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 23.51, ["Fly"] = 25.97, ["Ride"] = 24.69, ["Fly|Ride"] = 101.07, ["Neon"] = 430.5, ["Neon|Ride"] = 136.64, ["Neon|Fly|Ride"] = 176.13, ["Mega|Ride"] = 458.07, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 7.23, ["Ride"] = 66.55, ["Neon"] = 75.51, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 89.94, ["Neon|Fly|Ride"] = 720.63, ["Mega"] = 339.94, ["Mega|Ride"] = 410.82, ["Mega|Fly|Ride"] = 527.25}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 8.7, ["Fly"] = 2161.06, ["Ride"] = 65.54, ["Fly|Ride"] = 257.28, ["Neon"] = 45.92, ["Neon|Ride"] = 144.8, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 287.44, ["Mega|Fly"] = 302.52, ["Mega|Ride"] = 240.55, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 145.68, ["Fly|Ride"] = 196.88, ["Neon"] = 8.65, ["Neon|Fly"] = 210, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 259.31, ["Mega"] = 67.75, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 82.31}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Fly|Ride"] = 91.88, ["Neon"] = 5.25, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 164.58, ["Mega"] = 34.59, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 282.19}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 23.41}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 62.56, ["Fly"] = 101.07, ["Ride"] = 58.5, ["Fly|Ride"] = 144.8, ["Neon"] = 131.25, ["Neon|Ride"] = 216.12, ["Neon|Fly|Ride"] = 312.38, ["Mega"] = 1854.36, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 888.57}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 65.63, ["Neon"] = 2.61, ["Neon|Ride"] = 27.19, ["Mega"] = 20.99, ["Mega|Ride"] = 92.94, ["Mega|Fly|Ride"] = 293.93}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 457.31, ["Ride"] = 459.38, ["Fly|Ride"] = 572.25, ["Neon"] = 3889.89, ["Neon|Fly|Ride"] = 4035.28, ["Mega"] = 12966.27, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 4.7, ["Fly"] = 49.88, ["Ride"] = 33.74, ["Fly|Ride"] = 58.27, ["Neon"] = 73, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 65.66, ["Mega"] = 305.82, ["Mega|Ride"] = 288.48, ["Mega|Fly|Ride"] = 634.29}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 5.2, ["Fly"] = 41.86, ["Ride"] = 20.99, ["Fly|Ride"] = 43.22, ["Neon"] = 21, ["Neon|Ride"] = 38.04, ["Neon|Fly|Ride"] = 101.58, ["Mega"] = 144.8, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 13.75, ["Ride"] = 57.47, ["Fly|Ride"] = 86.45, ["Neon"] = 114.45, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 475.39, ["Mega|Ride"] = 388.5, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.24, ["Fly"] = 43.23, ["Ride"] = 38.57, ["Fly|Ride"] = 72.42, ["Neon"] = 48.09, ["Neon|Ride"] = 65.63, ["Mega"] = 282.19, ["Mega|Ride"] = 287.43, ["Mega|Fly|Ride"] = 534.87}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 14.97, ["Ride"] = 89.11, ["Fly|Ride"] = 202.13, ["Neon"] = 81.55, ["Neon|Ride"] = 118.12, ["Neon|Fly|Ride"] = 272.3, ["Mega"] = 539.14, ["Mega|Ride"] = 420.42, ["Mega|Fly|Ride"] = 538.12}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 6.19, ["Ride"] = 72.42, ["Fly|Ride"] = 206.36, ["Neon"] = 33.5, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 278.76, ["Mega"] = 216.49, ["Mega|Ride"] = 208.95, ["Mega|Fly|Ride"] = 363.83}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 49.14, ["Ride"] = 12.86, ["Fly|Ride"] = 34.68, ["Neon"] = 2.1, ["Neon|Fly"] = 42, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 54.66, ["Mega"] = 15.36, ["Mega|Fly"] = 82.31, ["Mega|Ride"] = 41.08, ["Mega|Fly|Ride"] = 76.12}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 7.33, ["Fly"] = 42, ["Ride"] = 56.44, ["Fly|Ride"] = 108.07, ["Neon"] = 101.57, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 152.7, ["Mega"] = 210.02, ["Mega|Ride"] = 343.93, ["Mega|Fly|Ride"] = 316.98}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 262.4, ["Ride"] = 280.67, ["Fly|Ride"] = 360.77, ["Neon"] = 1310.57, ["Neon|Ride"] = 1043.44, ["Neon|Fly|Ride"] = 1050, ["Mega|Ride"] = 9531.29, ["Mega|Fly|Ride"] = 4610.6}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 73.49, ["Ride"] = 138.3, ["Fly|Ride"] = 257.18, ["Neon"] = 393.75, ["Neon|Fly"] = 924.94, ["Neon|Ride"] = 479.07, ["Neon|Fly|Ride"] = 522.38, ["Mega"] = 2305.85, ["Mega|Ride"] = 1875.8, ["Mega|Fly|Ride"] = 1711.34}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 16.22, ["Fly|Ride"] = 43.09, ["Neon"] = 7.77, ["Neon|Fly"] = 101.58, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 62.51, ["Mega"] = 69.17, ["Mega|Fly"] = 215.04, ["Mega|Ride"] = 128.13, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 25.94, ["Ride"] = 14.48, ["Fly|Ride"] = 34.56, ["Neon"] = 8.4, ["Neon|Fly"] = 43.22, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 129.66, ["Mega|Fly"] = 288.51, ["Mega|Ride"] = 87.94, ["Mega|Fly|Ride"] = 153.57}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Fly"] = 101.58, ["Ride"] = 20.96, ["Fly|Ride"] = 98.44, ["Neon"] = 43.22, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 327.81, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 216.5, ["Ride"] = 244.12, ["Fly|Ride"] = 301.87, ["Neon|Ride"] = 1048.69, ["Neon|Fly|Ride"] = 1063.08, ["Mega|Ride"] = 8644.17, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 38.92, ["Ride"] = 16.27, ["Fly|Ride"] = 42.73, ["Neon"] = 34.13, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 30.34, ["Neon|Fly|Ride"] = 105, ["Mega"] = 286.12, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.94, ["Fly"] = 39.38, ["Ride"] = 78.75, ["Fly|Ride"] = 129.66, ["Neon"] = 32.44, ["Neon|Ride"] = 110.23, ["Neon|Fly|Ride"] = 101.57, ["Mega"] = 288.51, ["Mega|Ride"] = 304.63, ["Mega|Fly|Ride"] = 410.61}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.5, ["Neon"] = 15.75, ["Neon|Ride"] = 137.82, ["Mega"] = 139.02, ["Mega|Ride"] = 331.73}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 14.44, ["Fly"] = 58.14, ["Ride"] = 28.11, ["Fly|Ride"] = 78.66, ["Neon"] = 95.95, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 525, ["Mega|Ride"] = 501.38, ["Mega|Fly|Ride"] = 555.34}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 39.18, ["Ride"] = 85.31, ["Fly|Ride"] = 713.15, ["Neon"] = 122.04, ["Neon|Fly"] = 315, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 333.38, ["Mega"] = 458.69, ["Mega|Fly"] = 2269.12, ["Mega|Ride"] = 435.75, ["Mega|Fly|Ride"] = 546}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 29.12, ["Fly"] = 45.94, ["Ride"] = 41.99, ["Fly|Ride"] = 110.22, ["Neon"] = 98.34, ["Neon|Fly"] = 286.43, ["Neon|Ride"] = 141.63, ["Neon|Fly|Ride"] = 245.44, ["Mega"] = 567, ["Mega|Ride"] = 702.19, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 16.51, ["Ride"] = 14.44, ["Fly|Ride"] = 45.94, ["Neon"] = 2.27, ["Neon|Fly"] = 24.94, ["Neon|Ride"] = 16.96, ["Neon|Fly|Ride"] = 45.92, ["Mega"] = 21.62, ["Mega|Fly"] = 37.84, ["Mega|Ride"] = 35.43, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 282.71, ["Ride"] = 262.5, ["Fly|Ride"] = 328.12, ["Neon"] = 3422, ["Neon|Ride"] = 1441.26, ["Neon|Fly|Ride"] = 1438.19, ["Mega|Fly|Ride"] = 5331.31}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 10.82, ["Fly"] = 101.2, ["Ride"] = 28.75, ["Fly|Ride"] = 111.57, ["Neon"] = 64.84, ["Neon|Fly|Ride"] = 216.09, ["Mega"] = 393.16, ["Mega|Ride"] = 410.21, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 36.62, ["Ride"] = 19.26, ["Fly|Ride"] = 43.22, ["Neon"] = 5.16, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 41.37, ["Neon|Fly|Ride"] = 129.68, ["Mega"] = 50.93, ["Mega|Fly"] = 244.21, ["Mega|Ride"] = 82.31, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 37.84, ["Ride"] = 20.42, ["Fly|Ride"] = 86.44, ["Neon"] = 2.63, ["Neon|Fly"] = 82.31, ["Neon|Ride"] = 24.62, ["Neon|Fly|Ride"] = 110.56, ["Mega"] = 23.31, ["Mega|Fly"] = 144.21, ["Mega|Ride"] = 39.6, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 37.69, ["Fly|Ride"] = 91.88, ["Neon"] = 12.96, ["Neon|Fly"] = 736.97, ["Neon|Ride"] = 63.24, ["Mega"] = 135.03, ["Mega|Ride"] = 196.81, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 9.58, ["Fly"] = 37.96, ["Ride"] = 28.75, ["Fly|Ride"] = 59.76, ["Neon"] = 40.55, ["Neon|Fly"] = 259.34, ["Neon|Ride"] = 48.86, ["Neon|Fly|Ride"] = 210.7, ["Mega"] = 614.15, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 398.52}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 12.81, ["Ride"] = 32.82, ["Neon"] = 43.09, ["Neon|Ride"] = 56.52, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 275.63, ["Mega|Ride"] = 327.95, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 29.18, ["Neon"] = 3.72, ["Neon|Ride"] = 101.57, ["Neon|Fly|Ride"] = 108.5, ["Mega"] = 20.57, ["Mega|Ride"] = 68.02, ["Mega|Fly|Ride"] = 208.61}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 10.13, ["Ride"] = 27.16, ["Fly|Ride"] = 118.13, ["Neon"] = 32.45, ["Neon|Ride"] = 97.28, ["Neon|Fly|Ride"] = 188.03, ["Mega"] = 274.46, ["Mega|Ride"] = 288.48, ["Mega|Fly|Ride"] = 360.87}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 31.48, ["Neon"] = 5.13, ["Neon|Fly"] = 115.63, ["Neon|Ride"] = 39.32, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 26.14, ["Mega|Ride"] = 101.57, ["Mega|Fly|Ride"] = 164.58}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 59.06, ["Ride"] = 21, ["Fly|Ride"] = 43.24, ["Neon"] = 3.51, ["Neon|Ride"] = 28.77, ["Neon|Fly|Ride"] = 58.35, ["Mega"] = 55.63, ["Mega|Ride"] = 91.77, ["Mega|Fly|Ride"] = 287.43}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 654.94, ["Ride"] = 708.75, ["Fly|Ride"] = 779.62, ["Neon"] = 2625, ["Neon|Ride"] = 3439.14, ["Neon|Fly|Ride"] = 3150, ["Mega|Fly|Ride"] = 9620.63}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 18.25, ["Ride"] = 15.61, ["Fly|Ride"] = 64.99, ["Neon"] = 33.18, ["Neon|Fly"] = 43.23, ["Neon|Ride"] = 27.26, ["Neon|Fly|Ride"] = 65.63, ["Mega|Ride"] = 94.01}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 46.66, ["Fly|Ride"] = 84, ["Neon"] = 8.8, ["Neon|Fly"] = 756.37, ["Neon|Ride"] = 58.67, ["Neon|Fly|Ride"] = 196.65, ["Mega"] = 43.22, ["Mega|Fly"] = 210.9, ["Mega|Ride"] = 109.11, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 13.13, ["Fly"] = 26.25, ["Ride"] = 23.51, ["Fly|Ride"] = 56.09, ["Neon"] = 43.98, ["Neon|Fly"] = 196.54, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 485.63, ["Mega|Ride"] = 290.07, ["Mega|Fly|Ride"] = 376.69}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 58.86, ["Ride"] = 15.48, ["Fly|Ride"] = 32.93, ["Neon"] = 11.46, ["Neon|Fly"] = 52.48, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 67.01, ["Mega|Ride"] = 95.51, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 44.54, ["Ride"] = 83.99, ["Neon"] = 274.46, ["Neon|Ride"] = 271.19, ["Neon|Fly|Ride"] = 302.56, ["Mega"] = 1095.66, ["Mega|Ride"] = 853.52, ["Mega|Fly|Ride"] = 855.68}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 32.74, ["Fly|Ride"] = 76.26, ["Neon"] = 8.55, ["Neon|Fly"] = 140.03, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 129.68, ["Mega"] = 47.22, ["Mega|Ride"] = 109.86, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 21, ["Fly|Ride"] = 95.11, ["Neon"] = 12.73, ["Neon|Ride"] = 51.19, ["Mega"] = 115.49, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 325.5}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.63, ["Ride"] = 43.23, ["Fly|Ride"] = 65.84, ["Neon"] = 12.81, ["Mega"] = 103.94, ["Mega|Fly"] = 288.51, ["Mega|Ride"] = 162.09, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 2593.26, ["Ride"] = 18.86, ["Fly|Ride"] = 69.45, ["Neon"] = 4.6, ["Neon|Fly"] = 72.42, ["Neon|Ride"] = 23, ["Neon|Fly|Ride"] = 107.84, ["Mega"] = 38.98, ["Mega|Fly"] = 229.69, ["Mega|Ride"] = 101.47, ["Mega|Fly|Ride"] = 119.28}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 13.52, ["Fly"] = 21.31, ["Ride"] = 19.4, ["Fly|Ride"] = 36.75, ["Neon"] = 122.83, ["Neon|Fly"] = 123.31, ["Neon|Ride"] = 129.38, ["Neon|Fly|Ride"] = 94.01, ["Mega|Ride"] = 864.44, ["Mega|Fly|Ride"] = 488.95}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 702.17, ["Ride"] = 734.9, ["Fly|Ride"] = 853.13, ["Neon"] = 1584.19, ["Neon|Ride"] = 1785, ["Neon|Fly|Ride"] = 1850.63, ["Mega"] = 6550.76, ["Mega|Ride"] = 7346.68, ["Mega|Fly|Ride"] = 4465.13}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 21.62, ["Ride"] = 19.26, ["Fly|Ride"] = 47.55, ["Neon"] = 3.05, ["Neon|Fly"] = 36.75, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 68.25, ["Mega"] = 31.5, ["Mega|Ride"] = 59.06, ["Mega|Fly|Ride"] = 122.83}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 6.29, ["Ride"] = 38.07, ["Fly|Ride"] = 245.64, ["Neon"] = 50.7, ["Neon|Ride"] = 209.5, ["Neon|Fly|Ride"] = 250.69, ["Mega|Ride"] = 469.16, ["Mega|Fly|Ride"] = 577.01}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 52.41, ["Fly"] = 156.19, ["Ride"] = 79.97, ["Fly|Ride"] = 118.13, ["Neon"] = 328.13, ["Neon|Ride"] = 313.69, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2456.52, ["Mega|Fly|Ride"] = 1834.74}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 29.74, ["Fly"] = 145.16, ["Ride"] = 58.36, ["Fly|Ride"] = 102.64, ["Neon"] = 152.8, ["Neon|Ride"] = 129.22, ["Mega"] = 1638.32, ["Mega|Ride"] = 1007.06, ["Mega|Fly|Ride"] = 933.38}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 11.81, ["Ride"] = 36.75, ["Fly|Ride"] = 105, ["Neon"] = 69.57, ["Neon|Ride"] = 98.27, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 308.74, ["Mega|Ride"] = 344.32, ["Mega|Fly|Ride"] = 484.09}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 21.02, ["Fly"] = 86.45, ["Ride"] = 71.14, ["Fly|Ride"] = 159.93, ["Neon"] = 82.17, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 309, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 397.69}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 19.46, ["Ride"] = 40.95, ["Neon"] = 183.75, ["Neon|Ride"] = 194.91, ["Neon|Fly|Ride"] = 374.95, ["Mega"] = 576.94, ["Mega|Ride"] = 476.44, ["Mega|Fly|Ride"] = 555.18}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 15.44}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 3.72, ["Ride"] = 28.88, ["Fly|Ride"] = 101.17, ["Neon"] = 31.49, ["Neon|Fly"] = 94.49, ["Neon|Ride"] = 90.91, ["Neon|Fly|Ride"] = 213.98, ["Mega"] = 155.93, ["Mega|Fly"] = 462.9, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 318.77}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.63, ["Neon"] = 18.43, ["Mega"] = 139.32, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 37.8, ["Fly"] = 63, ["Ride"] = 51.89, ["Fly|Ride"] = 72.4, ["Neon"] = 147, ["Neon|Fly"] = 288.51, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 290.61, ["Mega"] = 936.72, ["Mega|Ride"] = 783.53, ["Mega|Fly|Ride"] = 742.11}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 5.92, ["Fly"] = 22.32, ["Ride"] = 16.87, ["Fly|Ride"] = 37.27, ["Neon"] = 24.94, ["Neon|Fly"] = 42.94, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 78.65, ["Mega"] = 262.5, ["Mega|Fly"] = 432.23, ["Mega|Ride"] = 183.74, ["Mega|Fly|Ride"] = 207.38}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 6.34, ["Fly"] = 107.29, ["Ride"] = 27.95, ["Fly|Ride"] = 63.95, ["Neon"] = 28.11, ["Neon|Ride"] = 47.16, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 315, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 255.96}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 6.46, ["Mega"] = 34.85, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 31.19, ["Ride"] = 45.85, ["Fly|Ride"] = 127.52, ["Neon"] = 270.15, ["Neon|Ride"] = 235.82, ["Neon|Fly|Ride"] = 378.16, ["Mega|Ride"] = 736.88, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 36.92, ["Fly|Ride"] = 58.15, ["Neon"] = 6.28, ["Neon|Ride"] = 42.15, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 78.75, ["Mega|Ride"] = 144.8}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 7.35, ["Ride"] = 819.27, ["Fly|Ride"] = 210, ["Neon"] = 73.5, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 324.17, ["Mega"] = 406.88, ["Mega|Ride"] = 431.08, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 43.22, ["Ride"] = 17.3, ["Fly|Ride"] = 43.22, ["Neon"] = 14.43, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 100.47, ["Mega"] = 157.77, ["Mega|Ride"] = 159.48, ["Mega|Fly|Ride"] = 288.51}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.63, ["Fly"] = 52.49, ["Ride"] = 21.89, ["Fly|Ride"] = 58.07, ["Neon"] = 90.57, ["Neon|Fly"] = 71.32, ["Neon|Ride"] = 72.42, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 274.46, ["Mega|Ride"] = 388.96, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 16.23, ["Neon"] = 85.32, ["Mega"] = 422.29, ["Mega|Ride"] = 388.52}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 61.43, ["Fly"] = 216.12, ["Ride"] = 115.16, ["Fly|Ride"] = 468.9, ["Neon"] = 285.87, ["Neon|Ride"] = 497.05, ["Neon|Fly|Ride"] = 590.63, ["Mega"] = 1363.69, ["Mega|Fly|Ride"] = 1286.25}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 16.11, ["Fly"] = 129.68, ["Ride"] = 78.75, ["Fly|Ride"] = 161.28, ["Neon"] = 85.31, ["Mega"] = 422.63, ["Mega|Ride"] = 418.69, ["Mega|Fly|Ride"] = 687.75}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 5.03, ["Ride"] = 116.43, ["Neon"] = 149.63, ["Neon|Fly"] = 216.12, ["Neon|Ride"] = 170.63, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 491.32}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 26.25, ["Ride"] = 128.6, ["Fly|Ride"] = 367.49, ["Neon"] = 171.51, ["Neon|Fly"] = 188.03, ["Neon|Ride"] = 216.09, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 896.83, ["Mega|Fly"] = 2161.06, ["Mega|Ride"] = 728.28, ["Mega|Fly|Ride"] = 863.35}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.46, ["Neon"] = 23.94, ["Neon|Fly|Ride"] = 144.8, ["Mega"] = 198.19, ["Mega|Ride"] = 255.5, ["Mega|Fly|Ride"] = 327.95}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 15.65, ["Fly|Ride"] = 50.79, ["Neon"] = 6.35, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 28.07, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 49.27, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 5.07, ["Fly"] = 45.94, ["Ride"] = 37.84, ["Fly|Ride"] = 84, ["Neon"] = 12.5, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 164.06, ["Mega"] = 91.88, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 336}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 144.8, ["Ride"] = 24.4, ["Fly|Ride"] = 72, ["Neon"] = 6.43, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 106.98, ["Mega"] = 57.29, ["Mega|Fly"] = 58.35, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.09, ["Fly"] = 65.62, ["Ride"] = 23.79, ["Fly|Ride"] = 85.38, ["Neon"] = 24.41, ["Neon|Ride"] = 144.8, ["Neon|Fly|Ride"] = 216.12, ["Mega"] = 127.32, ["Mega|Ride"] = 313.95, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 6.43, ["Fly"] = 65.44, ["Ride"] = 34.12, ["Fly|Ride"] = 86.45, ["Neon"] = 30.2, ["Neon|Fly"] = 315, ["Neon|Ride"] = 58.15, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 287.47, ["Mega|Fly|Ride"] = 1080.54}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.93, ["Fly"] = 131.24, ["Ride"] = 23.35, ["Fly|Ride"] = 50.24, ["Neon"] = 79.16, ["Neon|Fly"] = 135.69, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 216.57, ["Mega|Fly"] = 271.23, ["Mega|Ride"] = 267.95, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.49, ["Ride"] = 19.79, ["Fly|Ride"] = 52.41, ["Neon"] = 22.08, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 151.28, ["Mega"] = 213.93, ["Mega|Ride"] = 164.6, ["Mega|Fly|Ride"] = 215.04}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 5.12, ["Fly"] = 186.38, ["Ride"] = 47.28, ["Neon"] = 11.61, ["Neon|Fly"] = 437.06, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 141.9, ["Mega"] = 78.81, ["Mega|Fly"] = 216.81, ["Mega|Ride"] = 149.12, ["Mega|Fly|Ride"] = 280.35}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 20.53, ["Ride"] = 82.69, ["Fly|Ride"] = 194.91, ["Neon"] = 118.02, ["Neon|Fly"] = 271.19, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 348.48, ["Mega"] = 864.32, ["Mega|Ride"] = 777.99, ["Mega|Fly|Ride"] = 714}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 50.96, ["Fly"] = 164.07, ["Ride"] = 93.7, ["Fly|Ride"] = 187.69, ["Neon"] = 216.09, ["Neon|Ride"] = 266.44, ["Neon|Fly|Ride"] = 314.97, ["Mega"] = 993.98, ["Mega|Ride"] = 1063.13, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Ride"] = 23.71, ["Fly|Ride"] = 118.12, ["Neon"] = 3.8, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 144.8, ["Mega"] = 50.07, ["Mega|Ride"] = 72.42, ["Mega|Fly|Ride"] = 146.99}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 11.46, ["Ride"] = 105, ["Neon"] = 105.94, ["Mega"] = 706.68, ["Mega|Fly|Ride"] = 1138.89}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 63.95, ["Ride"] = 65.63, ["Fly|Ride"] = 171.82, ["Neon"] = 249.38, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 418.99, ["Mega"] = 1229.64, ["Mega|Ride"] = 1310.42, ["Mega|Fly|Ride"] = 1441.26}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 8.38, ["Fly"] = 116.82, ["Ride"] = 26.25, ["Fly|Ride"] = 133.88, ["Neon"] = 39.36, ["Neon|Fly"] = 131.43, ["Neon|Ride"] = 86.44, ["Neon|Fly|Ride"] = 164.58, ["Mega"] = 270.17, ["Mega|Fly"] = 741.88, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 295.31}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 13.02, ["Neon"] = 14.34, ["Neon|Ride"] = 61.7, ["Mega"] = 99.1, ["Mega|Fly"] = 282.18, ["Mega|Ride"] = 437.06, ["Mega|Fly|Ride"] = 259.77}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 3.82, ["Fly"] = 31.5, ["Ride"] = 19.28, ["Fly|Ride"] = 59.07, ["Neon"] = 10.71, ["Neon|Ride"] = 42.35, ["Neon|Fly|Ride"] = 105, ["Mega"] = 110.25, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 188.01}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 21.59, ["Ride"] = 15.63, ["Fly|Ride"] = 58.36, ["Neon"] = 2.58, ["Neon|Fly"] = 129.68, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 32.44, ["Mega|Ride"] = 78.78, ["Mega|Fly|Ride"] = 144.8}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 18.85, ["Fly|Ride"] = 93.09, ["Neon"] = 4.82, ["Neon|Ride"] = 23.55, ["Neon|Fly|Ride"] = 97.44, ["Mega"] = 37.3, ["Mega|Fly"] = 168, ["Mega|Ride"] = 57.1, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 64.84, ["Mega"] = 22.02, ["Mega|Ride"] = 79.7, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 6.07, ["Ride"] = 40.95, ["Neon"] = 41.58, ["Neon|Ride"] = 82.6, ["Neon|Fly|Ride"] = 58.36, ["Mega"] = 288.51, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 7.88, ["Ride"] = 30.19, ["Fly|Ride"] = 216.12, ["Neon"] = 72.19, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 140.07, ["Mega"] = 287.44, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 9.02, ["Fly"] = 21.51, ["Ride"] = 19.59, ["Fly|Ride"] = 38.66, ["Neon"] = 52.89, ["Neon|Ride"] = 43.28, ["Neon|Fly|Ride"] = 98.27, ["Mega|Ride"] = 353.81, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 98.27, ["Ride"] = 98.44, ["Fly|Ride"] = 124.69, ["Neon"] = 393.75, ["Neon|Ride"] = 540.28, ["Neon|Fly|Ride"] = 720.71, ["Mega"] = 2456.52, ["Mega|Ride"] = 1655.37, ["Mega|Fly|Ride"] = 1667.06}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 23.12, ["Fly"] = 57.75, ["Ride"] = 28.88, ["Fly|Ride"] = 102.67, ["Neon"] = 1012.1, ["Neon|Fly|Ride"] = 630, ["Mega"] = 466.76, ["Mega|Fly|Ride"] = 1050.67}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 14.44, ["Ride"] = 18.75, ["Fly|Ride"] = 42, ["Neon"] = 2.57, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 24.76, ["Neon|Fly|Ride"] = 56.44, ["Mega|Ride"] = 94.01, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 19.61, ["Ride"] = 15.65, ["Fly|Ride"] = 35.44, ["Neon"] = 5.18, ["Neon|Fly"] = 27.57, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 45.75, ["Mega"] = 55.12, ["Mega|Ride"] = 44.19, ["Mega|Fly|Ride"] = 145.69}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 413.34, ["Fly"] = 577.23, ["Ride"] = 508.07, ["Fly|Ride"] = 541.51, ["Neon"] = 2738.06, ["Neon|Ride"] = 2296.88, ["Neon|Fly|Ride"] = 2098.69, ["Mega|Fly|Ride"] = 9498.23}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 4.76, ["Ride"] = 43.22, ["Neon"] = 35.44, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 576.94, ["Mega|Ride"] = 432.17, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 17.18, ["Fly|Ride"] = 30.23, ["Neon"] = 7.22, ["Neon|Fly"] = 22.66, ["Neon|Ride"] = 18.32, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 30.19, ["Mega|Ride"] = 71.32, ["Mega|Fly|Ride"] = 94.01}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 49.88, ["Ride"] = 115.62, ["Fly|Ride"] = 720.63, ["Neon"] = 203.44, ["Neon|Ride"] = 282.19, ["Neon|Fly|Ride"] = 570.46, ["Mega"] = 796.1, ["Mega|Ride"] = 761.25, ["Mega|Fly|Ride"] = 872.24}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 3.93, ["Fly"] = 27.56, ["Ride"] = 28.14, ["Fly|Ride"] = 75.66, ["Neon"] = 15.25, ["Neon|Fly"] = 101.36, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 90.46, ["Mega"] = 111.57, ["Mega|Ride"] = 135.18, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Ride"] = 43.32, ["Fly|Ride"] = 196.88, ["Neon"] = 2.63, ["Neon|Fly"] = 101.57, ["Neon|Ride"] = 144.59, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 18.79, ["Mega|Ride"] = 52.47, ["Mega|Fly|Ride"] = 215.01}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 38.98, ["Fly"] = 129.94, ["Ride"] = 78.75, ["Fly|Ride"] = 215.04, ["Neon"] = 168, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 367.35, ["Mega"] = 818.95, ["Mega|Ride"] = 653.59, ["Mega|Fly|Ride"] = 628.69}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Fly|Ride"] = 146.99, ["Neon"] = 7.88, ["Neon|Ride"] = 23.64, ["Mega"] = 57.75, ["Mega|Ride"] = 129.68, ["Mega|Fly|Ride"] = 255.02}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 45, ["Ride"] = 72.41, ["Fly|Ride"] = 129.94, ["Neon"] = 283.23, ["Neon|Ride"] = 213.71, ["Neon|Fly|Ride"] = 327.95, ["Mega"] = 1181.25, ["Mega|Ride"] = 1296.64, ["Mega|Fly|Ride"] = 1334.93}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.94, ["Ride"] = 131.24, ["Fly|Ride"] = 432.17, ["Neon"] = 40.69, ["Neon|Ride"] = 230.99, ["Neon|Fly|Ride"] = 504.62, ["Mega"] = 170.63, ["Mega|Ride"] = 410.21}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.63, ["Fly"] = 72.42, ["Ride"] = 81.36, ["Fly|Ride"] = 58.35, ["Neon"] = 8.65, ["Neon|Ride"] = 43.35, ["Neon|Fly|Ride"] = 108.07, ["Mega"] = 117.6, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 72.19, ["Fly"] = 216.09, ["Ride"] = 122.85, ["Fly|Ride"] = 196.88, ["Neon"] = 359.63, ["Neon|Ride"] = 478.69, ["Mega|Ride"] = 2881.77, ["Mega|Fly|Ride"] = 1260.98}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 587.49, ["Ride"] = 39.38, ["Neon"] = 7.63, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 147.38, ["Mega"] = 45.4, ["Mega|Fly"] = 216.12, ["Mega|Ride"] = 91.9, ["Mega|Fly|Ride"] = 279.57}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 28, ["Ride"] = 19.29, ["Fly|Ride"] = 43.22, ["Neon"] = 8.66, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 25.98, ["Neon|Fly|Ride"] = 86.89, ["Mega"] = 42, ["Mega|Fly"] = 151.1, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 230.32}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 8.97, ["Fly"] = 34.13, ["Ride"] = 39.36, ["Fly|Ride"] = 196.54, ["Neon"] = 72.19, ["Neon|Fly"] = 131.43, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 215.25, ["Mega"] = 374.95, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 7.16, ["Fly"] = 38.06, ["Ride"] = 33.51, ["Fly|Ride"] = 52.5, ["Neon"] = 71.47, ["Neon|Fly"] = 326.73, ["Neon|Ride"] = 62.04, ["Neon|Fly|Ride"] = 116.94, ["Mega"] = 354.38, ["Mega|Ride"] = 362.25, ["Mega|Fly|Ride"] = 1228.26}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 22.56, ["Fly"] = 28.88, ["Ride"] = 22.31, ["Fly|Ride"] = 62.69, ["Neon"] = 81.38, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 172.9, ["Mega"] = 777.07, ["Mega|Ride"] = 331.34, ["Mega|Fly|Ride"] = 340.39}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 68.15, ["Ride"] = 125.43, ["Fly|Ride"] = 224.11, ["Neon"] = 315, ["Neon|Ride"] = 362.53, ["Neon|Fly|Ride"] = 569.86, ["Mega|Ride"] = 1577.39, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 16.23, ["Ride"] = 115.4, ["Fly|Ride"] = 423.77, ["Neon"] = 91.88, ["Neon|Ride"] = 168.92, ["Neon|Fly|Ride"] = 352.23, ["Mega"] = 312.38, ["Mega|Ride"] = 462.42}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 6.07, ["Ride"] = 21.61, ["Fly|Ride"] = 78.75, ["Neon"] = 22.09, ["Neon|Ride"] = 47.25, ["Mega"] = 120.25, ["Mega|Ride"] = 252.82, ["Mega|Fly|Ride"] = 337.14}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 11.12, ["Fly"] = 135.19, ["Ride"] = 26.25, ["Fly|Ride"] = 91.88, ["Neon"] = 76.13, ["Neon|Fly"] = 105, ["Neon|Ride"] = 118.12, ["Neon|Fly|Ride"] = 172.9, ["Mega"] = 317.63, ["Mega|Ride"] = 341.13, ["Mega|Fly|Ride"] = 432.17}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 14.03, ["Fly|Ride"] = 30.15, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 43.24, ["Mega"] = 14.44, ["Mega|Fly"] = 41.99, ["Mega|Ride"] = 28.86, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 53.81, ["Fly"] = 164.07, ["Ride"] = 89.25, ["Neon"] = 236.25, ["Neon|Fly"] = 2449.56, ["Neon|Ride"] = 192.94, ["Mega"] = 1080.54, ["Mega|Ride"] = 945, ["Mega|Fly|Ride"] = 846.93}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 20.6, ["Fly|Ride"] = 144.09, ["Neon"] = 3.42, ["Neon|Fly"] = 131.25, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 33.02, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 18.63, ["Fly|Ride"] = 45.9, ["Neon"] = 29.17, ["Neon|Ride"] = 27.59, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 252, ["Mega|Ride"] = 204.75, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 52.5, ["Ride"] = 105.63, ["Fly|Ride"] = 131.25, ["Neon"] = 244.02, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 959.63, ["Mega|Ride"] = 800.8, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 63.89, ["Neon"] = 7.53, ["Neon|Ride"] = 34.59, ["Neon|Fly|Ride"] = 159.93, ["Mega"] = 69.57, ["Mega|Ride"] = 175.04, ["Mega|Fly|Ride"] = 248.18}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 8.45}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 47.56, ["Fly|Ride"] = 141.01, ["Neon"] = 4.74, ["Neon|Ride"] = 92.94, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 41.91, ["Mega|Ride"] = 144.8, ["Mega|Fly|Ride"] = 199.1}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 123.71, ["Ride"] = 170.63, ["Fly|Ride"] = 215.25, ["Neon"] = 525, ["Neon|Ride"] = 629.99, ["Neon|Fly|Ride"] = 678.57, ["Mega"] = 6483.14, ["Mega|Ride"] = 3275.77, ["Mega|Fly|Ride"] = 2555.17}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.81, ["Fly|Ride"] = 72.19, ["Neon"] = 41.67, ["Neon|Fly"] = 144.8, ["Neon|Ride"] = 103.69, ["Mega"] = 171.64, ["Mega|Ride"] = 245.26, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 15.75, ["Neon"] = 3.94, ["Neon|Ride"] = 22.23, ["Mega"] = 45.92, ["Mega|Ride"] = 48.57, ["Mega|Fly|Ride"] = 307.13}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 5.25, ["Ride"] = 36.74, ["Fly|Ride"] = 101.58, ["Neon"] = 60.29, ["Neon|Ride"] = 106.97, ["Neon|Fly|Ride"] = 159.93, ["Mega"] = 319.37, ["Mega|Ride"] = 579.12, ["Mega|Fly|Ride"] = 687.22}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 15.24, ["Fly"] = 89.13, ["Ride"] = 20.19, ["Fly|Ride"] = 62.68, ["Neon"] = 101.04, ["Neon|Ride"] = 142.64, ["Neon|Fly|Ride"] = 216.12, ["Mega"] = 643.19, ["Mega|Ride"] = 283.5, ["Mega|Fly|Ride"] = 396.57}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 24.94, ["Ride"] = 63.95, ["Fly|Ride"] = 206.38, ["Neon"] = 151.78, ["Neon|Ride"] = 157.47, ["Neon|Fly|Ride"] = 345.74, ["Mega"] = 552.57, ["Mega|Ride"] = 551.25, ["Mega|Fly|Ride"] = 622.67}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 159.93, ["Fly"] = 196.88, ["Ride"] = 164.07, ["Fly|Ride"] = 249.38, ["Neon"] = 525, ["Neon|Fly"] = 1441.42, ["Neon|Ride"] = 510.57, ["Neon|Fly|Ride"] = 656.25, ["Mega|Fly|Ride"] = 2462.22}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 6.08, ["Fly"] = 21.2, ["Ride"] = 18.34, ["Fly|Ride"] = 41.82, ["Neon"] = 49.54, ["Neon|Fly"] = 209.99, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 76.67, ["Mega|Ride"] = 327.95, ["Mega|Fly|Ride"] = 393.02}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 3.83, ["Fly"] = 72.42, ["Ride"] = 46.51, ["Fly|Ride"] = 131.25, ["Neon"] = 18.8, ["Neon|Ride"] = 37.05, ["Neon|Fly|Ride"] = 85.37, ["Mega"] = 157.5, ["Mega|Fly|Ride"] = 415.8}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 2.63, ["Fly"] = 43.2, ["Ride"] = 32.44, ["Fly|Ride"] = 76.13, ["Neon"] = 39.38, ["Neon|Fly"] = 81.05, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 159.93, ["Mega"] = 465.94, ["Mega|Ride"] = 435.75, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 52.33, ["Fly"] = 82.62, ["Ride"] = 65.63, ["Fly|Ride"] = 116.82, ["Neon"] = 196.76, ["Neon|Ride"] = 259.88, ["Neon|Fly|Ride"] = 367.49, ["Mega"] = 826.28, ["Mega|Ride"] = 786.19, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 17.98, ["Ride"] = 155.99, ["Neon"] = 196.87, ["Neon|Ride"] = 259.34, ["Neon|Fly|Ride"] = 288.51, ["Mega"] = 655.82, ["Mega|Ride"] = 717.4, ["Mega|Fly|Ride"] = 980.05}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 236.12, ["Ride"] = 350.44, ["Fly|Ride"] = 328.13, ["Neon"] = 1312.5, ["Neon|Ride"] = 1638.52, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4198.69}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 25.1, ["Ride"] = 31.5, ["Fly|Ride"] = 69.47, ["Neon"] = 202.05, ["Neon|Ride"] = 239.87, ["Neon|Fly|Ride"] = 347.82, ["Mega"] = 763.85, ["Mega|Ride"] = 762.97, ["Mega|Fly|Ride"] = 2016.27}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 41.98, ["Ride"] = 15.75, ["Fly|Ride"] = 43.23, ["Neon"] = 2.31, ["Neon|Ride"] = 16.96, ["Neon|Fly|Ride"] = 45.47, ["Mega"] = 19.4, ["Mega|Fly"] = 114.55, ["Mega|Ride"] = 36.75, ["Mega|Fly|Ride"] = 115.46}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 6.39, ["Ride"] = 42.78, ["Neon"] = 26.25, ["Neon|Ride"] = 86.45, ["Neon|Fly|Ride"] = 164.6, ["Mega"] = 196.88, ["Mega|Ride"] = 140.43, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.62, ["Ride"] = 32.61, ["Fly|Ride"] = 144.79, ["Neon"] = 16.69, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 1181.24, ["Mega|Fly"] = 575.01, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 327.47}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 426.57, ["Fly"] = 393.75, ["Ride"] = 439.69, ["Fly|Ride"] = 521.09, ["Neon"] = 1728.85, ["Neon|Ride"] = 1837.5, ["Neon|Fly|Ride"] = 1914.94, ["Mega|Fly|Ride"] = 5042.2}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 3.93, ["Fly"] = 78.75, ["Ride"] = 18.26, ["Fly|Ride"] = 48.55, ["Neon"] = 26.93, ["Neon|Ride"] = 28.77, ["Neon|Fly|Ride"] = 122.07, ["Mega"] = 251.9, ["Mega|Ride"] = 154.63, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 3.94, ["Fly"] = 28.11, ["Ride"] = 19.45, ["Fly|Ride"] = 44.63, ["Neon"] = 50.91, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 63.75, ["Neon|Fly|Ride"] = 140.03, ["Mega"] = 369.5, ["Mega|Ride"] = 297.17, ["Mega|Fly|Ride"] = 328.02}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 4.11, ["Fly"] = 45.92, ["Ride"] = 27.03, ["Fly|Ride"] = 69.18, ["Neon"] = 15.6, ["Neon|Fly"] = 94.48, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 127.32, ["Mega"] = 94.5, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 34.86, ["Fly"] = 73.71, ["Ride"] = 34.13, ["Fly|Ride"] = 87.22, ["Neon"] = 220.5, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 736.97, ["Mega|Ride"] = 863.35, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 52.5, ["Fly|Ride"] = 52.38, ["Neon"] = 14.14, ["Neon|Ride"] = 106.87, ["Neon|Fly|Ride"] = 210, ["Mega"] = 167.08, ["Mega|Ride"] = 205.23, ["Mega|Fly|Ride"] = 755.35}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 18.38, ["Fly"] = 150.94, ["Ride"] = 39.29, ["Neon"] = 210, ["Neon|Fly|Ride"] = 259.23, ["Mega|Ride"] = 918.75}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 18.43, ["Fly|Ride"] = 144.8, ["Neon"] = 9.09, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 84, ["Mega"] = 85.32, ["Mega|Ride"] = 144.8, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 7.29, ["Ride"] = 43.22, ["Neon"] = 65.63, ["Mega"] = 137.4, ["Mega|Ride"] = 315.53, ["Mega|Fly|Ride"] = 655.9}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 13.12, ["Ride"] = 78.75, ["Fly|Ride"] = 86.44, ["Neon"] = 47.59, ["Neon|Ride"] = 82.31, ["Neon|Fly|Ride"] = 145.89, ["Mega"] = 215.33, ["Mega|Ride"] = 327.95, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 9.19, ["Fly"] = 31.17, ["Ride"] = 23.6, ["Fly|Ride"] = 58.35, ["Neon"] = 62.91, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 539.19, ["Mega|Ride"] = 331.24, ["Mega|Fly|Ride"] = 380.42}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 454.78, ["Fly"] = 635.36, ["Ride"] = 434.86, ["Fly|Ride"] = 557.82, ["Neon"] = 1676.43, ["Neon|Fly"] = 2072.89, ["Neon|Ride"] = 3570, ["Neon|Fly|Ride"] = 1640.62, ["Mega|Fly|Ride"] = 7455.61}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.63, ["Ride"] = 18.21, ["Fly|Ride"] = 36.66, ["Neon"] = 14.81, ["Neon|Fly"] = 82.31, ["Neon|Ride"] = 32.44, ["Neon|Fly|Ride"] = 105, ["Mega"] = 267.99, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 26.25, ["Ride"] = 86.44, ["Fly|Ride"] = 144.8, ["Neon"] = 104.99, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 420, ["Mega|Fly"] = 720.71, ["Mega|Ride"] = 570.46, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 21.56, ["Ride"] = 101.57, ["Fly|Ride"] = 224.75, ["Neon"] = 69.97, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 393.75, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 454.65}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 62.91, ["Ride"] = 85.31, ["Fly|Ride"] = 126.98, ["Neon"] = 431.08, ["Neon|Ride"] = 288.48, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 2568.39, ["Mega|Fly|Ride"] = 3018.63}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 12.85, ["Ride"] = 57.66, ["Fly|Ride"] = 101.88, ["Neon"] = 44.63, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 267.95, ["Mega"] = 200.82, ["Mega|Fly"] = 366.16, ["Mega|Ride"] = 246.77, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 19.69, ["Fly|Ride"] = 59.07, ["Neon"] = 18.37, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 123.2, ["Mega"] = 102.38, ["Mega|Ride"] = 146.24, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 7.87, ["Ride"] = 41.06, ["Neon"] = 26.25, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 203.74, ["Mega|Fly"] = 432.17, ["Mega|Ride"] = 216.09, ["Mega|Fly|Ride"] = 251.99}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 50.58, ["Fly"] = 183.75, ["Ride"] = 82.1, ["Fly|Ride"] = 221.82, ["Neon"] = 134.78, ["Neon|Ride"] = 213.71, ["Neon|Fly|Ride"] = 340.44, ["Mega"] = 421.31, ["Mega|Ride"] = 410.8, ["Mega|Fly|Ride"] = 486.88}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 85.31, ["Neon"] = 8.66, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 169.59, ["Mega"] = 62.62, ["Mega|Fly"] = 105, ["Mega|Ride"] = 123.36, ["Mega|Fly|Ride"] = 318.94}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 38.92, ["Ride"] = 234.94, ["Neon"] = 250.67, ["Mega"] = 1075.02, ["Mega|Fly|Ride"] = 862.16}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 958.12, ["Fly"] = 1194.38, ["Ride"] = 958.13, ["Fly|Ride"] = 1139.24, ["Neon"] = 4322.1, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2887.49, ["Mega"] = 9940.81, ["Mega|Fly|Ride"] = 7875}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 23.79, ["Ride"] = 72.19, ["Fly|Ride"] = 196.77, ["Neon"] = 151.28, ["Neon|Fly"] = 719.64, ["Neon|Ride"] = 215.37, ["Mega"] = 471.45, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 526.32}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.37, ["Fly"] = 52.46, ["Ride"] = 27.65, ["Fly|Ride"] = 86.45, ["Neon"] = 11.82, ["Neon|Ride"] = 34.59, ["Neon|Fly|Ride"] = 85.31, ["Mega"] = 85.26, ["Mega|Ride"] = 164.6, ["Mega|Fly|Ride"] = 175.84}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 19.46, ["Ride"] = 131.25, ["Fly|Ride"] = 393.75, ["Neon"] = 77.44, ["Neon|Ride"] = 129.66, ["Neon|Fly|Ride"] = 541.68, ["Mega"] = 288.74, ["Mega|Ride"] = 430.71, ["Mega|Fly|Ride"] = 491.32}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 18.43, ["Fly|Ride"] = 53.86, ["Neon"] = 2.63, ["Neon|Ride"] = 27.71, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 17.75, ["Mega|Ride"] = 55.63, ["Mega|Fly|Ride"] = 124.59}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 43.22, ["Fly"] = 144.8, ["Ride"] = 95.71, ["Fly|Ride"] = 275.94, ["Neon"] = 207.38, ["Neon|Fly"] = 354.38, ["Neon|Ride"] = 269.07, ["Neon|Fly|Ride"] = 398.9, ["Mega"] = 1003.28, ["Mega|Ride"] = 826.88, ["Mega|Fly|Ride"] = 945}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 183.65, ["Ride"] = 65.63, ["Fly|Ride"] = 288.51, ["Neon"] = 145.01, ["Neon|Fly"] = 139.13, ["Neon|Ride"] = 310.13, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 577.49, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 1080.41}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.93, ["Ride"] = 33.17, ["Neon"] = 11.7, ["Neon|Ride"] = 50.28, ["Neon|Fly|Ride"] = 105, ["Mega"] = 98.27, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 18.05, ["Fly"] = 52.49, ["Ride"] = 35.44, ["Fly|Ride"] = 94.5, ["Neon"] = 92.14, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 127.5, ["Neon|Fly|Ride"] = 576.94, ["Mega"] = 476.46, ["Mega|Ride"] = 663.37, ["Mega|Fly|Ride"] = 861}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 10.82, ["Fly"] = 86.45, ["Ride"] = 30.19, ["Fly|Ride"] = 66.71, ["Neon"] = 36.74, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 115.62, ["Mega"] = 262.5, ["Mega|Ride"] = 577.01, ["Mega|Fly|Ride"] = 430.5}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 41.91, ["Ride"] = 119.95, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 682.5, ["Mega"] = 2521.95, ["Mega|Ride"] = 1836.9, ["Mega|Fly|Ride"] = 2048.51}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 5.58, ["Ride"] = 52.5, ["Fly|Ride"] = 542.45, ["Neon"] = 21, ["Neon|Ride"] = 75.59, ["Neon|Fly|Ride"] = 147, ["Mega"] = 84.79, ["Mega|Ride"] = 101.07, ["Mega|Fly|Ride"] = 245.52}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 7.14, ["Ride"] = 19.69, ["Fly|Ride"] = 56.21, ["Neon"] = 85.26, ["Neon|Fly"] = 188.03, ["Neon|Ride"] = 70.86, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 337.32, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 126, ["Fly"] = 208.8, ["Ride"] = 180.99, ["Fly|Ride"] = 210, ["Neon"] = 500.57, ["Neon|Ride"] = 582.41, ["Neon|Fly|Ride"] = 602.44, ["Mega|Ride"] = 1834.96, ["Mega|Fly|Ride"] = 1862.44}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 29.18, ["Ride"] = 17.06, ["Fly|Ride"] = 47.55, ["Neon"] = 13.1, ["Neon|Fly"] = 57.72, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 68.25, ["Mega"] = 111.46, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 185.22}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 45.51, ["Fly"] = 267.04, ["Ride"] = 91.88, ["Fly|Ride"] = 166.39, ["Neon"] = 154.14, ["Neon|Ride"] = 229.21, ["Neon|Fly|Ride"] = 340.7, ["Mega"] = 884.25, ["Mega|Ride"] = 866.25, ["Mega|Fly|Ride"] = 939.95}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.89, ["Ride"] = 15.96, ["Fly|Ride"] = 64.31, ["Neon"] = 2.24, ["Neon|Fly"] = 28.26, ["Neon|Ride"] = 17.06, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 14.42, ["Mega|Fly"] = 47.93, ["Mega|Ride"] = 28.28, ["Mega|Fly|Ride"] = 72.1}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Neon"] = 5.16, ["Neon|Fly|Ride"] = 134.01, ["Mega"] = 26.17, ["Mega|Fly"] = 131.24, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 156}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 36.75, ["Ride"] = 31.34, ["Fly|Ride"] = 173.37, ["Neon"] = 14.6, ["Neon|Ride"] = 58.36, ["Neon|Fly|Ride"] = 171.14, ["Mega"] = 105, ["Mega|Ride"] = 231.25, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 43.13, ["Neon"] = 173.24, ["Neon|Ride"] = 327.95, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 536.41, ["Mega|Ride"] = 720.63}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 3.93, ["Fly"] = 19.59, ["Ride"] = 18.27, ["Fly|Ride"] = 41.63, ["Neon"] = 14, ["Neon|Fly"] = 32.69, ["Neon|Ride"] = 23.85, ["Neon|Fly|Ride"] = 63.56, ["Mega"] = 105, ["Mega|Fly"] = 267.23, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 108.07, ["Fly"] = 42, ["Ride"] = 36.74, ["Fly|Ride"] = 105.79, ["Neon"] = 105, ["Neon|Fly"] = 144.8, ["Neon|Ride"] = 113.29, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 423.62, ["Mega|Ride"] = 299.24, ["Mega|Fly|Ride"] = 415.78}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 3.14, ["Fly"] = 26.17, ["Ride"] = 18.26, ["Fly|Ride"] = 82.6, ["Neon"] = 9.19, ["Neon|Fly"] = 98.42, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 60.38, ["Mega"] = 57.16, ["Mega|Fly"] = 106.98, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 144.36}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 19.02, ["Fly"] = 162.39, ["Ride"] = 24.93, ["Fly|Ride"] = 217.3, ["Neon"] = 44.78, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 864.44, ["Mega"] = 432.23, ["Mega|Ride"] = 426.77, ["Mega|Fly|Ride"] = 366.19}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 8.55, ["Ride"] = 57.63, ["Fly|Ride"] = 210, ["Neon"] = 65.26, ["Neon|Ride"] = 262.49, ["Mega"] = 288.51, ["Mega|Ride"] = 318.73, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 4.93, ["Fly"] = 56.24, ["Ride"] = 18.8, ["Fly|Ride"] = 52.49, ["Neon"] = 30.19, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 41.49, ["Neon|Fly|Ride"] = 122.8, ["Mega"] = 253.93, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 240.19, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 25.94, ["Ride"] = 18.8, ["Fly|Ride"] = 39.38, ["Neon"] = 18.2, ["Neon|Fly"] = 47.55, ["Neon|Ride"] = 28.1, ["Neon|Fly|Ride"] = 64.97, ["Mega"] = 144.8, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 284.2}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 210, ["Fly"] = 393.75, ["Ride"] = 273.96, ["Fly|Ride"] = 368.45, ["Neon"] = 1330.13, ["Neon|Ride"] = 1426.3, ["Neon|Fly|Ride"] = 1174.69, ["Mega"] = 4258.37, ["Mega|Fly|Ride"] = 4421.74}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 5.6, ["Ride"] = 114.17, ["Neon"] = 44.57, ["Mega"] = 123.38, ["Mega|Ride"] = 655.9}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 6.3, ["Fly"] = 108.07, ["Ride"] = 19.69, ["Fly|Ride"] = 63.75, ["Neon"] = 38.92, ["Neon|Fly"] = 245.28, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 147.41, ["Mega"] = 255.5, ["Mega|Ride"] = 280.66, ["Mega|Fly|Ride"] = 200.82}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 5.12, ["Fly|Ride"] = 720.71, ["Neon"] = 32.82, ["Neon|Ride"] = 288.51, ["Neon|Fly|Ride"] = 648.33, ["Mega"] = 490.04, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 432.23}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 16.23, ["Ride"] = 14.34, ["Fly|Ride"] = 32.43, ["Neon"] = 2.62, ["Neon|Fly"] = 29.19, ["Neon|Ride"] = 18.2, ["Neon|Fly|Ride"] = 42, ["Mega"] = 17.07, ["Mega|Fly"] = 52.5, ["Mega|Ride"] = 36.63, ["Mega|Fly|Ride"] = 94.5}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 6.03, ["Fly"] = 59.59, ["Ride"] = 26.22, ["Fly|Ride"] = 55.12, ["Neon"] = 23, ["Neon|Fly"] = 86.44, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 111.57, ["Mega|Ride"] = 150.94, ["Mega|Fly|Ride"] = 259.82}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.1, ["Ride"] = 124.79, ["Neon"] = 10.82, ["Neon|Ride"] = 288.51, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 119.94, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 360.87}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 77.05, ["Fly"] = 78.75, ["Ride"] = 90.03, ["Fly|Ride"] = 164.57, ["Neon"] = 420, ["Neon|Ride"] = 350.44, ["Neon|Fly|Ride"] = 400.32, ["Mega"] = 2881.77, ["Mega|Ride"] = 3603.55, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 5.81, ["Fly"] = 101.58, ["Ride"] = 23.62, ["Fly|Ride"] = 141.74, ["Neon"] = 17.07, ["Neon|Ride"] = 69.57, ["Mega"] = 169.32, ["Mega|Ride"] = 383.23, ["Mega|Fly|Ride"] = 720.71}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Ride"] = 43.23, ["Neon"] = 6.41, ["Neon|Ride"] = 154.88, ["Neon|Fly|Ride"] = 288.51, ["Mega"] = 66.27, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 128.6, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 48.09, ["Fly"] = 160.48, ["Ride"] = 87.94, ["Fly|Ride"] = 164.58, ["Neon"] = 144.8, ["Neon|Ride"] = 170.96, ["Neon|Fly|Ride"] = 275.62, ["Mega"] = 414.75, ["Mega|Ride"] = 454.55, ["Mega|Fly|Ride"] = 576.19}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 16.12, ["Ride"] = 13.54, ["Fly|Ride"] = 32.79, ["Neon"] = 2.61, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 16.69, ["Neon|Fly|Ride"] = 38.04, ["Mega"] = 15.65, ["Mega|Fly"] = 50.79, ["Mega|Ride"] = 29.86, ["Mega|Fly|Ride"] = 125.99}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Fly|Ride"] = 101.57, ["Neon"] = 3.63, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 44.18, ["Neon|Fly|Ride"] = 114.55, ["Mega"] = 26.25, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 114.19, ["Mega|Fly|Ride"] = 162.74}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.63, ["Ride"] = 52.59, ["Neon"] = 9.15, ["Neon|Ride"] = 72.4, ["Neon|Fly|Ride"] = 109.33, ["Mega"] = 70.87, ["Mega|Fly"] = 188.03, ["Mega|Ride"] = 111.57, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 3.94, ["Fly"] = 105, ["Ride"] = 42.35, ["Fly|Ride"] = 103.69, ["Neon"] = 23.63, ["Neon|Fly"] = 108.06, ["Neon|Ride"] = 72.16, ["Neon|Fly|Ride"] = 159.68, ["Mega"] = 108.39, ["Mega|Fly"] = 199.63, ["Mega|Ride"] = 144.37, ["Mega|Fly|Ride"] = 258.63}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 20, ["Ride"] = 14.18, ["Fly|Ride"] = 45.39, ["Neon"] = 2.21, ["Neon|Fly"] = 21.62, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 58.35, ["Mega"] = 25.95, ["Mega|Ride"] = 50.67, ["Mega|Fly|Ride"] = 118.12}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 20.89, ["Fly"] = 127.52, ["Ride"] = 70.43, ["Neon"] = 202.08, ["Neon|Ride"] = 194.52, ["Neon|Fly|Ride"] = 864.32, ["Mega"] = 582.54, ["Mega|Fly|Ride"] = 819.16}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2166.94, ["Fly"] = 3150, ["Ride"] = 2491.04, ["Fly|Ride"] = 2231.25, ["Neon|Fly|Ride"] = 7415.63, ["Mega|Fly|Ride"] = 44841.62}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 31.45, ["Ride"] = 19.67, ["Fly|Ride"] = 33.1, ["Neon"] = 8.81, ["Neon|Fly"] = 49.88, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 62.16, ["Mega"] = 72.4, ["Mega|Fly"] = 476.53, ["Mega|Ride"] = 95.9, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.37, ["Ride"] = 65.63, ["Neon"] = 10.5, ["Mega"] = 132.92, ["Mega|Fly"] = 441, ["Mega|Ride"] = 124.58, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 39.38, ["Fly"] = 105, ["Ride"] = 33.51, ["Fly|Ride"] = 133.88, ["Neon"] = 85.05, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 431.82, ["Mega|Ride"] = 412.13}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 27.17, ["Fly"] = 144.8, ["Ride"] = 70.6, ["Neon"] = 144.8, ["Neon|Ride"] = 236.25, ["Mega"] = 755.3, ["Mega|Ride"] = 690.39, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 135.19, ["Fly"] = 548.42, ["Ride"] = 187.69, ["Fly|Ride"] = 245.64, ["Neon"] = 647.07, ["Neon|Ride"] = 734.77, ["Neon|Fly|Ride"] = 603.75, ["Mega"] = 6483.14, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 3.93, ["Ride"] = 31.5, ["Fly|Ride"] = 675.94, ["Neon"] = 22.32, ["Neon|Ride"] = 72.42, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 144.8, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 379.23}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 41.77, ["Neon"] = 22.28, ["Neon|Ride"] = 114.85, ["Mega"] = 179.81, ["Mega|Fly|Ride"] = 267.09}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 101.58, ["Ride"] = 29.43, ["Fly|Ride"] = 64.63, ["Neon"] = 7.41, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 144.8, ["Mega"] = 104.99, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 273.9}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 13.2, ["Ride"] = 84, ["Fly|Ride"] = 131.25, ["Neon"] = 144.94, ["Neon|Ride"] = 1231.96, ["Neon|Fly|Ride"] = 364.88, ["Mega"] = 576.94, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 429.85}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.5, ["Neon|Ride"] = 49.14, ["Mega"] = 21, ["Mega|Ride"] = 577.01, ["Mega|Fly|Ride"] = 129.68}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 99.02, ["Fly"] = 819.27, ["Ride"] = 115.62, ["Fly|Ride"] = 170.63, ["Neon"] = 343.04, ["Neon|Fly"] = 462.48, ["Neon|Ride"] = 411.5, ["Neon|Fly|Ride"] = 504.56, ["Mega"] = 3241.58, ["Mega|Fly|Ride"] = 1900.13}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Fly"] = 41.77, ["Ride"] = 36.75, ["Neon"] = 15.75, ["Neon|Ride"] = 159.93, ["Neon|Fly|Ride"] = 102.92, ["Mega"] = 66.7, ["Mega|Ride"] = 288.51, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 43.22, ["Fly"] = 229.7, ["Ride"] = 94.01, ["Fly|Ride"] = 128.63, ["Neon"] = 236.25, ["Neon|Ride"] = 280.88, ["Neon|Fly|Ride"] = 534.81, ["Mega"] = 2018.43, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 63.76, ["Ride"] = 18.46, ["Fly|Ride"] = 45.48, ["Neon"] = 4.39, ["Neon|Fly"] = 86, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 83.97, ["Mega"] = 72.4, ["Mega|Fly"] = 196.53, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 327.95}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Ride"] = 21, ["Neon"] = 6.35, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 216.09, ["Mega"] = 37.7, ["Mega|Ride"] = 137.7, ["Mega|Fly|Ride"] = 312.38}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 6.38, ["Fly"] = 72.42, ["Ride"] = 23.55, ["Fly|Ride"] = 90.46, ["Neon"] = 25.47, ["Neon|Fly"] = 108.07, ["Neon|Ride"] = 72.48, ["Mega"] = 141.75, ["Mega|Ride"] = 215.01, ["Mega|Fly|Ride"] = 576.94}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 345.19, ["Fly"] = 736.97, ["Ride"] = 399, ["Fly|Ride"] = 507.94, ["Neon"] = 787.5, ["Neon|Ride"] = 924, ["Neon|Fly|Ride"] = 1065.75, ["Mega"] = 3745.73, ["Mega|Ride"] = 2676.18, ["Mega|Fly|Ride"] = 3049.1}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 36.75, ["Fly"] = 65.63, ["Ride"] = 60.97, ["Fly|Ride"] = 91.85, ["Neon"] = 161.42, ["Neon|Ride"] = 175.41, ["Neon|Fly|Ride"] = 229.68, ["Mega"] = 1009.22, ["Mega|Fly"] = 2768.51, ["Mega|Ride"] = 2160.8, ["Mega|Fly|Ride"] = 1065.28}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.63, ["Fly"] = 67.58, ["Ride"] = 33.52, ["Fly|Ride"] = 111.57, ["Neon"] = 30.19, ["Neon|Fly"] = 101.07, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 131.06, ["Mega"] = 169.32, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 21.95, ["Fly"] = 231.23, ["Ride"] = 74.52, ["Fly|Ride"] = 144.37, ["Neon"] = 76.13, ["Neon|Ride"] = 127.09, ["Neon|Fly|Ride"] = 259.87, ["Mega"] = 308.44, ["Mega|Fly"] = 1010.87, ["Mega|Ride"] = 329.25, ["Mega|Fly|Ride"] = 474.46}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 7.88, ["Ride"] = 19.67, ["Neon"] = 95.09, ["Neon|Ride"] = 122.83, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 655.82, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 2.63, ["Fly|Ride"] = 94.02, ["Neon"] = 14.44, ["Neon|Ride"] = 157.49, ["Mega"] = 53.82, ["Mega|Ride"] = 236.24, ["Mega|Fly|Ride"] = 340.34}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.63, ["Fly"] = 72.42, ["Ride"] = 17.42, ["Fly|Ride"] = 62.99, ["Neon"] = 82.11, ["Neon|Ride"] = 144.8, ["Neon|Fly|Ride"] = 213.71, ["Mega"] = 573.61, ["Mega|Ride"] = 343.6, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 110.98, ["Fly"] = 245.66, ["Ride"] = 91.88, ["Fly|Ride"] = 196.88, ["Neon"] = 433.13, ["Neon|Ride"] = 565.32, ["Neon|Fly|Ride"] = 524.99, ["Mega"] = 2887.5, ["Mega|Ride"] = 3275.77, ["Mega|Fly|Ride"] = 2178.75}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 19.95, ["Ride"] = 31.5, ["Fly|Ride"] = 85.32, ["Neon"] = 128.52, ["Neon|Ride"] = 209.61, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 590.99, ["Mega|Ride"] = 634.2, ["Mega|Fly|Ride"] = 761.44}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2034.38, ["Fly"] = 1968.75, ["Ride"] = 2029.12, ["Fly|Ride"] = 1963.5, ["Neon"] = 11525.93, ["Neon|Ride"] = 7860.87, ["Neon|Fly|Ride"] = 6877.5, ["Mega|Fly|Ride"] = 25592.44}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 6.36, ["Fly"] = 131250, ["Ride"] = 68.25, ["Fly|Ride"] = 196.67, ["Neon"] = 45.94, ["Neon|Fly|Ride"] = 323.05, ["Mega"] = 222.97, ["Mega|Fly"] = 236.62, ["Mega|Ride"] = 191.63, ["Mega|Fly|Ride"] = 518.61}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 6.06, ["Fly"] = 144.8, ["Ride"] = 47.93, ["Fly|Ride"] = 111.07, ["Neon"] = 30.18, ["Neon|Ride"] = 79.36, ["Mega"] = 140.33, ["Mega|Ride"] = 164.58, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 893.82, ["Ride"] = 904.3, ["Fly|Ride"] = 943.68, ["Neon"] = 2778.57, ["Neon|Ride"] = 2572.76, ["Neon|Fly|Ride"] = 2887.5, ["Mega|Ride"] = 13921.08, ["Mega|Fly|Ride"] = 11092.39}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 45.94, ["Ride"] = 58.35, ["Fly|Ride"] = 105, ["Neon"] = 229.7, ["Neon|Ride"] = 323.05, ["Mega"] = 857.14, ["Mega|Ride"] = 836.24, ["Mega|Fly|Ride"] = 1005.98}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 123.17, ["Neon"] = 15.28, ["Neon|Fly"] = 164.6, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 236.25, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Ride"] = 144.69, ["Neon"] = 2.52, ["Neon|Ride"] = 52.41, ["Neon|Fly|Ride"] = 112.39, ["Mega"] = 29.18, ["Mega|Ride"] = 70.91, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 78.66, ["Fly"] = 432.23, ["Ride"] = 144.37, ["Fly|Ride"] = 216.12, ["Neon"] = 459.38, ["Neon|Ride"] = 614.15, ["Neon|Fly|Ride"] = 655.9, ["Mega"] = 2456.52, ["Mega|Fly|Ride"] = 2441.7}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Fly|Ride"] = 70.02, ["Neon"] = 12.22, ["Neon|Fly"] = 72.19, ["Neon|Ride"] = 64.32, ["Mega"] = 87.94, ["Mega|Ride"] = 124.31, ["Mega|Fly|Ride"] = 267.74}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 77.86, ["Ride"] = 106.32, ["Neon"] = 614.09, ["Neon|Ride"] = 591.07, ["Neon|Fly|Ride"] = 518.61, ["Mega"] = 2160.8, ["Mega|Fly|Ride"] = 1614.13}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 7.44, ["Fly"] = 105, ["Fly|Ride"] = 129.68, ["Neon"] = 29.18, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 315, ["Mega"] = 360.77, ["Mega|Ride"] = 317.7, ["Mega|Fly|Ride"] = 401.98}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 282.19, ["Fly"] = 418.14, ["Ride"] = 307.13, ["Fly|Ride"] = 369.11, ["Neon"] = 1160.43, ["Neon|Ride"] = 8644.17, ["Neon|Fly|Ride"] = 879.38, ["Mega|Fly|Ride"] = 3889.89}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.56, ["Fly"] = 65.63, ["Ride"] = 20.89, ["Fly|Ride"] = 115.5, ["Neon"] = 21, ["Neon|Ride"] = 84.29, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 319.32, ["Mega|Ride"] = 245.26, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 16.7, ["Ride"] = 16.48, ["Fly|Ride"] = 32.82, ["Neon"] = 4.8, ["Neon|Fly"] = 29.22, ["Neon|Ride"] = 22.5, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 48.57, ["Mega|Ride"] = 57.89, ["Mega|Fly|Ride"] = 164.6}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1375.49, ["Ride"] = 1050, ["Fly|Ride"] = 1260.52, ["Neon|Ride"] = 7924.55, ["Neon|Fly|Ride"] = 7562.77, ["Mega"] = 24565.14}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 17.94, ["Fly"] = 138.33, ["Ride"] = 77.44, ["Fly|Ride"] = 323.09, ["Neon"] = 105, ["Neon|Ride"] = 314.98, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 504.56, ["Mega|Ride"] = 523, ["Mega|Fly|Ride"] = 554.39}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 5.92, ["Fly"] = 54.03, ["Ride"] = 39.19, ["Fly|Ride"] = 101.57, ["Neon"] = 26.25, ["Neon|Ride"] = 60.24, ["Neon|Fly|Ride"] = 122.81, ["Mega"] = 180.46, ["Mega|Ride"] = 172.47, ["Mega|Fly|Ride"] = 253.21}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 35.43, ["Fly"] = 39.45, ["Ride"] = 38.66, ["Fly|Ride"] = 64.32, ["Neon"] = 240.94, ["Neon|Ride"] = 213.95, ["Neon|Fly|Ride"] = 190.91, ["Mega"] = 2593.26, ["Mega|Ride"] = 864.32, ["Mega|Fly|Ride"] = 808.5}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 14.06, ["Fly"] = 62.91, ["Ride"] = 29.18, ["Fly|Ride"] = 72.19, ["Neon"] = 61.36, ["Neon|Ride"] = 101.25, ["Neon|Fly|Ride"] = 181.8, ["Mega"] = 363.83, ["Mega|Ride"] = 376.68, ["Mega|Fly|Ride"] = 576.94}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 208.69, ["Ride"] = 245.26, ["Fly|Ride"] = 644.01, ["Neon"] = 576.94, ["Neon|Fly"] = 576.94, ["Neon|Ride"] = 547.78, ["Neon|Fly|Ride"] = 821.1, ["Mega|Fly|Ride"] = 1325.63}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Neon"] = 2.63, ["Neon|Fly"] = 58.36, ["Neon|Ride"] = 115.31, ["Neon|Fly|Ride"] = 98.35, ["Mega"] = 14.44, ["Mega|Fly"] = 55.12, ["Mega|Ride"] = 144.47, ["Mega|Fly|Ride"] = 218.61}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 168.8, ["Fly"] = 2002.88, ["Ride"] = 244.18, ["Fly|Ride"] = 261.19, ["Neon"] = 716.63, ["Neon|Ride"] = 833.44, ["Neon|Fly|Ride"] = 853.13, ["Mega"] = 3457.69, ["Mega|Fly|Ride"] = 2699.82}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.46, ["Fly"] = 748.35, ["Ride"] = 21, ["Fly|Ride"] = 70.86, ["Neon"] = 229.67, ["Neon|Ride"] = 83.99, ["Mega"] = 773.71, ["Mega|Ride"] = 440.35, ["Mega|Fly|Ride"] = 490.88}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 19.69, ["Fly|Ride"] = 36.75, ["Neon"] = 14.44, ["Neon|Fly"] = 82.31, ["Neon|Ride"] = 72.42, ["Neon|Fly|Ride"] = 72.4, ["Mega"] = 108.06, ["Mega|Ride"] = 283.5}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 6.57, ["Ride"] = 126.06, ["Neon"] = 18.43, ["Neon|Fly"] = 142.64, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 214.86, ["Mega"] = 86.44}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 127.32, ["Fly"] = 248.5, ["Ride"] = 288.48, ["Fly|Ride"] = 540.28, ["Neon"] = 655.6, ["Neon|Ride"] = 784.77, ["Neon|Fly|Ride"] = 735, ["Mega"] = 2205, ["Mega|Ride"] = 1923.12, ["Mega|Fly|Ride"] = 1786.99}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 4.98, ["Ride"] = 85.32, ["Neon"] = 21, ["Neon|Ride"] = 78.75, ["Mega"] = 126.88, ["Mega|Ride"] = 157.76, ["Mega|Fly|Ride"] = 327.95}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 2.34, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 24.87, ["Mega"] = 18.37, ["Mega|Fly|Ride"] = 157.49}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 101.24, ["Ride"] = 26.21, ["Fly|Ride"] = 144.8, ["Neon"] = 2.51, ["Neon|Fly"] = 125.74, ["Neon|Ride"] = 29.19, ["Neon|Fly|Ride"] = 200.97, ["Mega"] = 17.99, ["Mega|Fly"] = 58.35, ["Mega|Ride"] = 50.79, ["Mega|Fly|Ride"] = 125.66}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 36.75, ["Ride"] = 20.99, ["Fly|Ride"] = 52.49, ["Neon"] = 5.15, ["Neon|Fly"] = 21, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 80.07, ["Mega"] = 59.07, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 156.19}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Fly"] = 29.18, ["Ride"] = 19.68, ["Fly|Ride"] = 115.54, ["Neon"] = 10.28, ["Mega"] = 144.27, ["Mega|Ride"] = 159.93, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 22.32, ["Ride"] = 17.3, ["Fly|Ride"] = 32.48, ["Neon"] = 23.79, ["Neon|Fly"] = 86.45, ["Neon|Ride"] = 40.95, ["Neon|Fly|Ride"] = 76.12, ["Mega"] = 327.95, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 229.08}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 46.92, ["Fly|Ride"] = 288.48, ["Neon"] = 229.66, ["Neon|Ride"] = 362.36, ["Neon|Fly|Ride"] = 634.29, ["Mega"] = 786.19, ["Mega|Ride"] = 772.35, ["Mega|Fly|Ride"] = 790.86}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 17.5, ["Fly|Ride"] = 35.9, ["Neon"] = 2.63, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 18.83, ["Neon|Fly|Ride"] = 46.05, ["Mega"] = 15.75, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 96.93}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 7.61, ["Fly"] = 58.59, ["Ride"] = 27.72, ["Fly|Ride"] = 71.66, ["Neon"] = 37.96, ["Neon|Fly"] = 59.07, ["Neon|Ride"] = 69.14, ["Neon|Fly|Ride"] = 102.26, ["Mega"] = 242.82, ["Mega|Fly"] = 397.69, ["Mega|Ride"] = 294, ["Mega|Fly|Ride"] = 308.72}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 28.44, ["Fly"] = 86.44, ["Ride"] = 50.44, ["Fly|Ride"] = 123.83, ["Neon"] = 188.01, ["Neon|Fly"] = 215.38, ["Neon|Ride"] = 285.49, ["Neon|Fly|Ride"] = 229.69, ["Mega|Ride"] = 936.72, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 78.75, ["Fly"] = 209.99, ["Ride"] = 62.68, ["Neon"] = 114.24, ["Mega"] = 655.82, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 857.95}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 18.83, ["Ride"] = 15.17, ["Fly|Ride"] = 32.44, ["Neon"] = 4.75, ["Neon|Fly"] = 29.08, ["Neon|Ride"] = 21.62, ["Neon|Fly|Ride"] = 55.09, ["Mega"] = 39.12, ["Mega|Ride"] = 62.47, ["Mega|Fly|Ride"] = 118.82}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 17.84, ["Ride"] = 94.31, ["Neon"] = 90.96, ["Neon|Ride"] = 110.25, ["Neon|Fly|Ride"] = 389.01, ["Mega"] = 531.78, ["Mega|Fly"] = 573.7, ["Mega|Ride"] = 573.7, ["Mega|Fly|Ride"] = 1561.88}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 969.94, ["Ride"] = 984.36, ["Fly|Ride"] = 1048.69, ["Neon"] = 2491.13, ["Neon|Ride"] = 2744.44, ["Neon|Fly|Ride"] = 2205, ["Mega|Fly|Ride"] = 6168.75}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 230.9, ["Ride"] = 275.63, ["Fly|Ride"] = 590.63, ["Neon"] = 721.88, ["Neon|Ride"] = 963.83, ["Neon|Fly|Ride"] = 1043.44, ["Mega"] = 5402.63, ["Mega|Ride"] = 3745.73, ["Mega|Fly|Ride"] = 3457.27}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.61, ["Neon"] = 13.13, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 259.34, ["Mega"] = 63.03, ["Mega|Fly|Ride"] = 1152.93}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 183.65, ["Ride"] = 251.89, ["Fly|Ride"] = 403.77, ["Neon"] = 643.13, ["Neon|Ride"] = 767.82, ["Neon|Fly|Ride"] = 984.38, ["Mega|Ride"] = 2393.39, ["Mega|Fly|Ride"] = 2198.28}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.4, ["Ride"] = 24.04, ["Fly|Ride"] = 94.02, ["Neon"] = 17.07, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 39.27, ["Neon|Fly|Ride"] = 144.8, ["Mega"] = 115.96, ["Mega|Ride"] = 488.86, ["Mega|Fly|Ride"] = 282.19}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 245.26, ["Fly"] = 432.23, ["Ride"] = 278.24, ["Fly|Ride"] = 373.32, ["Neon|Ride"] = 1585.15, ["Neon|Fly|Ride"] = 1563.35, ["Mega|Fly|Ride"] = 4118.49}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.24, ["Fly"] = 77.97, ["Ride"] = 23.63, ["Fly|Ride"] = 118.13, ["Neon"] = 26.23, ["Neon|Ride"] = 58.08, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 393.75, ["Mega|Fly"] = 361.99}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 41.05, ["Mega"] = 231, ["Mega|Ride"] = 244.21, ["Mega|Fly|Ride"] = 401.98}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 28.26, ["Fly"] = 52.5, ["Ride"] = 66.75, ["Fly|Ride"] = 144.8, ["Neon"] = 135.12, ["Neon|Fly"] = 432.23, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 525, ["Mega"] = 491.26, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 864.32}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.76, ["Neon"] = 22.32, ["Neon|Ride"] = 196.88, ["Mega"] = 250.71, ["Mega|Ride"] = 245.26, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 16.7, ["Ride"] = 14, ["Fly|Ride"] = 39.37, ["Neon"] = 2.49, ["Neon|Fly"] = 21.51, ["Neon|Ride"] = 21.62, ["Neon|Fly|Ride"] = 38.07, ["Mega"] = 24.59, ["Mega|Fly"] = 55.13, ["Mega|Ride"] = 35.44, ["Mega|Fly|Ride"] = 107.63}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4200, ["Ride"] = 4592.44, ["Fly|Ride"] = 4095, ["Neon"] = 32415.63, ["Neon|Fly|Ride"] = 21588.81, ["Mega|Fly|Ride"] = 59062.5}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 11.82, ["Fly"] = 86.45, ["Ride"] = 42, ["Neon"] = 99.74, ["Neon|Fly"] = 384.68, ["Neon|Ride"] = 101.64, ["Neon|Fly|Ride"] = 189.1, ["Mega"] = 210, ["Mega|Ride"] = 259.31, ["Mega|Fly|Ride"] = 396.57}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.57, ["Fly"] = 28.6, ["Ride"] = 19.46, ["Fly|Ride"] = 49.26, ["Neon"] = 14.1, ["Neon|Fly"] = 45.93, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 81.32, ["Mega"] = 144.38, ["Mega|Ride"] = 164.58, ["Mega|Fly|Ride"] = 220.89}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 445.53, ["Fly"] = 547.78, ["Ride"] = 459.38, ["Fly|Ride"] = 557.82, ["Neon"] = 1728.64, ["Neon|Ride"] = 1292.81, ["Neon|Fly|Ride"] = 1233.75, ["Mega"] = 6027, ["Mega|Fly|Ride"] = 5114.82}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 3.71, ["Ride"] = 49.14, ["Neon"] = 22.32, ["Neon|Ride"] = 164.6, ["Mega"] = 164.6, ["Mega|Ride"] = 171.82, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.66, ["Fly"] = 4304.47, ["Ride"] = 26.25, ["Neon"] = 72.07, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 819.27, ["Mega|Ride"] = 401.62, ["Mega|Fly|Ride"] = 488.25}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 72.42, ["Ride"] = 20.78, ["Fly|Ride"] = 65.62, ["Neon"] = 7.77, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 91.75, ["Mega"] = 44.56, ["Mega|Ride"] = 70.86, ["Mega|Fly|Ride"] = 288.51}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 582.75, ["Fly"] = 879.57, ["Ride"] = 767.81, ["Fly|Ride"] = 711.38, ["Neon|Ride"] = 2126.25, ["Neon|Fly|Ride"] = 2099.99, ["Mega|Fly|Ride"] = 8284.37}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 11.17, ["Ride"] = 65.51, ["Fly|Ride"] = 321.98, ["Neon"] = 51.43, ["Neon|Fly"] = 328.12, ["Neon|Ride"] = 163.16, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 236.24, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 4.19, ["Fly"] = 43.12, ["Ride"] = 86.62, ["Fly|Ride"] = 129.66, ["Neon"] = 24.51, ["Neon|Ride"] = 66.94, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 157.5, ["Mega|Fly"] = 819.27, ["Mega|Ride"] = 213.71, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.42, ["Fly"] = 39.26, ["Ride"] = 20.65, ["Fly|Ride"] = 58.36, ["Neon"] = 17.27, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 86.41, ["Mega"] = 164.6, ["Mega|Fly|Ride"] = 190.31}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 23.63, ["Fly"] = 39.38, ["Ride"] = 39.81, ["Fly|Ride"] = 65.63, ["Neon"] = 119.95, ["Neon|Ride"] = 114.18, ["Mega"] = 607.92, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 1680}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 288.48, ["Neon"] = 5.25, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 30.24, ["Mega|Fly"] = 115.63, ["Mega|Ride"] = 101.35, ["Mega|Fly|Ride"] = 221.82}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 590.63, ["Ride"] = 551.25, ["Fly|Ride"] = 649.43, ["Neon|Ride"] = 2375.8, ["Neon|Fly|Ride"] = 2449.56, ["Mega|Ride"] = 9580.43, ["Mega|Fly|Ride"] = 7874.99}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 55.47, ["Fly|Ride"] = 288.51, ["Neon"] = 14.34, ["Neon|Ride"] = 103.18, ["Neon|Fly|Ride"] = 201.43, ["Mega"] = 43.22, ["Mega|Ride"] = 159.93, ["Mega|Fly|Ride"] = 215.44}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 52.4, ["Fly|Ride"] = 131.25, ["Neon"] = 6.46, ["Neon|Fly"] = 288.48, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 41.06, ["Mega|Ride"] = 120.21, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Neon"] = 5.13, ["Neon|Ride"] = 41.57, ["Neon|Fly|Ride"] = 288.51, ["Mega"] = 43.32, ["Mega|Fly"] = 149.86, ["Mega|Ride"] = 116.45, ["Mega|Fly|Ride"] = 216.5}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 3.67, ["Ride"] = 26.25, ["Neon"] = 15.65, ["Mega"] = 247.45, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 28.25, ["Fly"] = 98.44, ["Ride"] = 64.62, ["Fly|Ride"] = 214.93, ["Neon"] = 161.23, ["Neon|Ride"] = 203.7, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 677.41, ["Mega|Ride"] = 570.94, ["Mega|Fly|Ride"] = 627.05}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 16.38, ["Ride"] = 57.66, ["Fly|Ride"] = 124.69, ["Neon"] = 84.82, ["Neon|Ride"] = 131.25, ["Mega"] = 418.95, ["Mega|Ride"] = 945, ["Mega|Fly|Ride"] = 755.52}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 3.93, ["Fly"] = 23.61, ["Ride"] = 20.99, ["Fly|Ride"] = 38.49, ["Neon"] = 39.11, ["Neon|Ride"] = 37.84, ["Neon|Fly|Ride"] = 101.58, ["Mega"] = 293.35, ["Mega|Ride"] = 274.98, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 12.7, ["Ride"] = 39.38, ["Neon"] = 72.18, ["Neon|Ride"] = 189.1, ["Mega|Ride"] = 420}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 38.58, ["Ride"] = 21, ["Fly|Ride"] = 111.56, ["Neon"] = 16.06, ["Neon|Ride"] = 54.06, ["Neon|Fly|Ride"] = 127.34, ["Mega"] = 104.9, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 278.25}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 20.9, ["Fly"] = 34.13, ["Ride"] = 31.19, ["Fly|Ride"] = 45.94, ["Neon"] = 116.93, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 168.67, ["Mega"] = 907.7, ["Mega|Fly|Ride"] = 719.25}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 32.82, ["Fly"] = 97.13, ["Neon"] = 164.58, ["Mega"] = 281.71, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 584.73}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 52.5, ["Fly"] = 86.16, ["Ride"] = 78.75, ["Fly|Ride"] = 262.5, ["Neon"] = 271.69, ["Neon|Ride"] = 272.87, ["Neon|Fly|Ride"] = 387.19, ["Mega"] = 2620.8, ["Mega|Fly|Ride"] = 1351.88}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 33.91, ["Fly"] = 164.58, ["Ride"] = 78.75, ["Fly|Ride"] = 122.83, ["Neon"] = 114.19, ["Neon|Ride"] = 192.85, ["Neon|Fly|Ride"] = 324.84, ["Mega"] = 507.94, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 19.94, ["Ride"] = 51.48, ["Fly|Ride"] = 131.25, ["Neon"] = 141.63, ["Neon|Ride"] = 214.3, ["Mega"] = 502.69, ["Mega|Ride"] = 445.08, ["Mega|Fly|Ride"] = 840.56}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 78.66, ["Fly"] = 131.25, ["Ride"] = 117.91, ["Fly|Ride"] = 275.55, ["Neon"] = 240.38, ["Neon|Ride"] = 255.94, ["Neon|Fly|Ride"] = 655.82, ["Mega"] = 918.75, ["Mega|Ride"] = 735, ["Mega|Fly|Ride"] = 993.96}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 24.44, ["Ride"] = 15.74, ["Fly|Ride"] = 32.17, ["Neon"] = 6.51, ["Neon|Fly"] = 32.81, ["Neon|Ride"] = 29.51, ["Neon|Fly|Ride"] = 56.2, ["Mega"] = 40.15, ["Mega|Fly"] = 216.12, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 146.99}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1246.88}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 124.16, ["Ride"] = 282.19, ["Fly|Ride"] = 378, ["Neon"] = 518.44, ["Neon|Ride"] = 803.83, ["Neon|Fly|Ride"] = 966.96, ["Mega"] = 1640.24, ["Mega|Ride"] = 1802.11, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 83.91, ["Neon"] = 3.21, ["Neon|Fly"] = 101.58, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 300.57, ["Mega"] = 71.32, ["Mega|Ride"] = 144.8, ["Mega|Fly|Ride"] = 139.07}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 32.71, ["Ride"] = 64.32, ["Neon"] = 118.13, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 396.75, ["Mega"] = 591.93, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 601.13}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 2.62, ["Neon|Fly|Ride"] = 144.8, ["Mega"] = 18.27}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Mega"] = 95.81, ["Mega|Ride"] = 115.62}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 102.27, ["Fly"] = 1802.32, ["Ride"] = 138.97, ["Fly|Ride"] = 296.04, ["Neon"] = 412.13, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 645.75, ["Mega|Ride"] = 2233.19, ["Mega|Fly|Ride"] = 2098.69}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 33.18, ["Fly|Ride"] = 47.24, ["Neon"] = 10.5, ["Neon|Ride"] = 32.31, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 101.77, ["Mega|Ride"] = 118.44, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 37.68, ["Ride"] = 27.57, ["Fly|Ride"] = 66.94, ["Neon"] = 3.61, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 419.9, ["Mega"] = 36.74, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 217.87}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.63, ["Neon"] = 129.57, ["Neon|Ride"] = 210}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.5, ["Neon"] = 15.75, ["Neon|Ride"] = 137.82, ["Mega"] = 139.02, ["Mega|Ride"] = 331.73}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 93.19, ["Ride"] = 171.94, ["Fly|Ride"] = 360.91, ["Neon"] = 545.74, ["Neon|Ride"] = 603.75, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1874.25, ["Mega|Fly|Ride"] = 2585.63}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 16.23, ["Neon"] = 85.32, ["Mega"] = 422.29, ["Mega|Ride"] = 388.52}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 367.5, ["Ride"] = 393.74, ["Fly|Ride"] = 681.71, ["Neon"] = 1069.69, ["Neon|Ride"] = 1478.18, ["Neon|Fly|Ride"] = 1403.43, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 81.38}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 49.88}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 18.43}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 15.73}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 53.34}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 124.69}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 17.43}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 35.44}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 192.94}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 14.21}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 27.36}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 13.13}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 8.72}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 1291.49}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 72.42}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 6.46}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 6.57}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 9.19}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 60.29}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 633.69}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 525}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 15.75}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1443.75}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 62.62}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 7.24}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 17.07}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 22.26}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 23.28}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 65.62}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 19.69}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 19.46}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 17.06}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 4.7}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 64.97}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 6.49}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.1}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 13.12}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 11.45}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 7.86}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 4.94}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 3241.58}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 98.34}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 259.55}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 4.91}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 6.3}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 28.58}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 9.19}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 32.16}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 262.5}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 10.5}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 32.82}},
    ["rbxassetid://1265129435"] = {name = "Gold Snowboard", prices = {["default"] = 156.76}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 164.07}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 190.31}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 7.77}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 85.32}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 32.82}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 6.57}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 105}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 28.87}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 11.46}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.63}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 36.64}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 10.27}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 4.33}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 38.07}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 97.67}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 399}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.24}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 8.85}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 11.59}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 27.56}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 111.54}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 24.86}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.24}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 17195.6}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 123.44}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 35.42}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 39.38}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 25.99}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 65.01}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 31.5}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 32.82}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 91.54}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 85.22}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 31.5}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 113.05}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 39.38}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 43.46}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 36.75}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 262.5}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 10.56}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 9.37}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 5.91}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 7.49}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 23.94}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 472.5}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.55}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.94}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 49.14}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 25.08}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 155.93}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 830.82}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 7.55}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 616.88}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 17.25}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.59}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 231}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 44}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 99.72}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 24.05}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 37.32}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 70.26}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 20.35}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 7.87}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 12.85}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.63}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 9.18}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 11.19}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 28.62}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 6.45}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.56}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 5.97}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 17.99}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 190.21}},
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
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 212.02}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 15.75}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 10.07}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 6.9}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 28.88}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 86.4}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 3.94}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 10.07}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 8.68}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 4.99}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 23.63}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 16.08}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 7.88}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 2.1}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 5.75}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 12.3}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 10.4}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 6.45}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 5.24}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 3.82}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 4.27}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 5.15}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 5.2}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.24}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7297.5}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 14.51}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3.47}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 6.13}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 5.24}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 4.33}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 18.27}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 6.35}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 4.81}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 4.68}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 3.93}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 14.43}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 45.85}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.6}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 6.24}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.52}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 6.25}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.5}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 6.49}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.81}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 3937.5}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 17.07}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 111.46}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 6.26}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 83.69}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.49}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 3.93}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 131.25}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.36}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 3.82}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 4.28}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 3.56}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 4.76}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 26.04}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.34}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.42}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 12.89}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 5.16}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 3.66}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 4.2}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.63}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.5}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 7.77}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.19}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.37}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 31.19}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 3.93}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 11.46}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 141.75}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 68.16}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 41.08}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 3.85}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 2160.38}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 193.6}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 8.56}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 73.49}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 35.35}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 3.93}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 6.12}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 7.88}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 20.23}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 3.62}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 15.65}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 19.67}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 2.3}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 13.53}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 5.82}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.37}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 14.44}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 8.44}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 3.61}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 16.02}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 7.97}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 101.33}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 23.63}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 42.75}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 110.22}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 15.63}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.3}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.63}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 23.55}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.49}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 23.62}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 16.12}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 7.25}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 7.12}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 5.77}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 69.57}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 3.92}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.5}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 155.8}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 15.23}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1036.86}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 188.9}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 13.1}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 11.75}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 60.29}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 3.76}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 3.7}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 4.83}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 6.18}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 91.88}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 8.97}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 6.86}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 3.9}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.62}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 36.66}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 4.34}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 52.39}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 6.57}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 55.12}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.63}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 10.71}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.78}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 5.16}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 17.39}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 118.13}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.37}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 3.94}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 72.1}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 3.61}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.24}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 50.61}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.57}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 65.63}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 78.66}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 65.63}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 43.22}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 6.49}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 143.07}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.46}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 41.98}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 65.01}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 22.31}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 42}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 4.33}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 3.94}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 8.88}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 21.83}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 26.25}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2.43}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 15.75}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 53.69}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 6.39}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 6.57}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 25.89}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.85}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 161.13}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 110.55}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.57}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 47.98}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 28.25}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1942.49}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 11.82}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 10.15}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 22.91}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 263.67}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 25.32}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 15.74}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 35.33}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 16.22}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 18.38}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 381.94}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 62.91}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 47.13}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 5.19}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 62.91}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 228.03}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 82.69}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1169.44}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 223.02}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 13.13}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1727.25}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 576.65}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 2.41}},
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