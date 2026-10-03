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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1252.54, ["Ride"] = 1179.94, ["Fly|Ride"] = 1728.85, ["Neon"] = 6878.41, ["Neon|Fly|Ride"] = 5042.81, ["Mega"] = 21610.42, ["Mega|Fly|Ride"] = 21610.42}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 498.75, ["Fly"] = 745.58, ["Ride"] = 504, ["Fly|Ride"] = 656.24, ["Neon|Fly|Ride"] = 2738.06, ["Mega"] = 10805.22, ["Mega|Fly|Ride"] = 8644.17}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 6562.5, ["Ride"] = 5250, ["Fly|Ride"] = 5234.25, ["Neon"] = 18375, ["Neon|Fly|Ride"] = 23747.67, ["Mega|Fly|Ride"] = 79238.92}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 209.99, ["Ride"] = 245.44, ["Fly|Ride"] = 401.98, ["Neon"] = 1147.25, ["Neon|Ride"] = 984.38, ["Neon|Fly|Ride"] = 931.88, ["Mega|Fly|Ride"] = 4913.16}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 485.63, ["Fly"] = 864.32, ["Ride"] = 525, ["Fly|Ride"] = 514.5, ["Neon"] = 1940.64, ["Neon|Fly|Ride"] = 1689.19, ["Mega|Fly|Ride"] = 5250}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 13.26, ["Ride"] = 58.97, ["Fly|Ride"] = 131.25, ["Neon"] = 102.67, ["Neon|Fly"] = 288.51, ["Neon|Ride"] = 102.27, ["Neon|Fly|Ride"] = 216.12, ["Mega"] = 360.94, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 600.8}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.94, ["Fly"] = 39.24, ["Ride"] = 26.17, ["Fly|Ride"] = 72.1, ["Neon"] = 32.82, ["Neon|Fly"] = 99.65, ["Neon|Ride"] = 49.25, ["Neon|Fly|Ride"] = 116.93, ["Mega"] = 157.5, ["Mega|Ride"] = 201.9, ["Mega|Fly|Ride"] = 265.13}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 100.56, ["Fly"] = 294.81, ["Ride"] = 106.98, ["Fly|Ride"] = 262.5, ["Neon"] = 451.5, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 1728.64, ["Mega"] = 1586.82, ["Mega|Fly|Ride"] = 1830.43}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 32.45, ["Fly"] = 91.88, ["Ride"] = 42, ["Fly|Ride"] = 99.75, ["Neon"] = 275.63, ["Neon|Fly"] = 242.82, ["Neon|Ride"] = 253.32, ["Neon|Fly|Ride"] = 308.44, ["Mega"] = 2100, ["Mega|Ride"] = 1217.76, ["Mega|Fly|Ride"] = 879.38}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 26.92, ["Fly"] = 33.38, ["Ride"] = 39.38, ["Fly|Ride"] = 69.55, ["Neon"] = 262.5, ["Neon|Ride"] = 144.8, ["Neon|Fly|Ride"] = 199.68, ["Mega"] = 648.33, ["Mega|Fly|Ride"] = 649.69}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 63, ["Fly"] = 216.12, ["Ride"] = 91.88, ["Fly|Ride"] = 288.51, ["Neon"] = 368.51, ["Neon|Ride"] = 325.5, ["Neon|Fly|Ride"] = 431.15, ["Mega"] = 1575, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1555.97}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 74.33}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 362.83, ["Fly"] = 432.23, ["Ride"] = 350.48, ["Fly|Ride"] = 380.63, ["Neon|Ride"] = 1008, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 3936.19}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 145.09, ["Fly"] = 153.06, ["Ride"] = 124.69, ["Fly|Ride"] = 188.03, ["Neon|Fly|Ride"] = 647.25, ["Mega"] = 4312.63, ["Mega|Fly|Ride"] = 2467.5}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.94, ["Fly"] = 83.15, ["Ride"] = 43.32, ["Neon"] = 25.95, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 244.44, ["Mega"] = 160.13, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 358.75, ["Mega|Fly|Ride"] = 504.62}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 218.68, ["Fly"] = 237.39, ["Ride"] = 216.57, ["Fly|Ride"] = 240.42, ["Neon|Ride"] = 1402.71, ["Neon|Fly|Ride"] = 949.77, ["Mega|Fly|Ride"] = 2751}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.41, ["Fly"] = 23.62, ["Ride"] = 19.45, ["Fly|Ride"] = 39.38, ["Neon"] = 40.69, ["Neon|Fly"] = 129.68, ["Neon|Ride"] = 82.31, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 190.32, ["Mega|Ride"] = 274.46, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 209.61, ["Fly"] = 223.13, ["Ride"] = 236.24, ["Fly|Ride"] = 362.36, ["Neon"] = 540.21, ["Neon|Ride"] = 607.14, ["Neon|Fly|Ride"] = 551.25, ["Mega"] = 1728.64, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 44.63}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 85.32, ["Ride"] = 172.9, ["Fly|Ride"] = 278.83, ["Neon"] = 459.38, ["Neon|Fly|Ride"] = 523.69, ["Mega|Ride"] = 1785.04, ["Mega|Fly|Ride"] = 1873.64}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 34.13, ["Fly"] = 393.75, ["Ride"] = 85.3, ["Fly|Ride"] = 190.21, ["Neon"] = 262.5, ["Neon|Ride"] = 318.94, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 1048.69, ["Mega|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 35.44, ["Fly"] = 77.44, ["Ride"] = 58.47, ["Fly|Ride"] = 105, ["Neon"] = 216.57, ["Neon|Ride"] = 203.23, ["Neon|Fly|Ride"] = 276.12, ["Mega"] = 1719.61, ["Mega|Fly|Ride"] = 935.96}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 44.63, ["Fly"] = 152.81, ["Ride"] = 85.32, ["Fly|Ride"] = 196.88, ["Neon"] = 259.34, ["Neon|Ride"] = 404.14, ["Neon|Fly|Ride"] = 525, ["Mega"] = 1967.44, ["Mega|Ride"] = 1441.42, ["Mega|Fly|Ride"] = 1566.58}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 32.97, ["Ride"] = 52.5, ["Fly|Ride"] = 125.36, ["Neon"] = 210, ["Neon|Ride"] = 162.75, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 1207.92, ["Mega|Fly|Ride"] = 1723.32}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 49.77, ["Ride"] = 72.35, ["Fly|Ride"] = 134.01, ["Neon"] = 276.4, ["Neon|Ride"] = 245.67, ["Neon|Fly|Ride"] = 324.17, ["Mega|Ride"] = 1147.25, ["Mega|Fly|Ride"] = 982.65}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 10.82, ["Fly"] = 39.36, ["Ride"] = 20.39, ["Fly|Ride"] = 67.02, ["Neon"] = 47.16, ["Neon|Fly"] = 73.71, ["Neon|Ride"] = 50.05, ["Neon|Fly|Ride"] = 103.5, ["Mega"] = 150.94, ["Mega|Fly"] = 310.13, ["Mega|Ride"] = 196.66, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 484.32, ["Ride"] = 497.44, ["Fly|Ride"] = 590.63, ["Neon|Ride"] = 1606.38, ["Neon|Fly|Ride"] = 1966.13, ["Mega"] = 10803.94, ["Mega|Fly|Ride"] = 9745.22}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 18.38, ["Ride"] = 31.5, ["Fly|Ride"] = 134.01, ["Neon"] = 219.19, ["Mega|Ride"] = 821.21, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 6.57, ["Fly"] = 43.23, ["Ride"] = 21, ["Fly|Ride"] = 47.16, ["Neon"] = 75.03, ["Neon|Ride"] = 76.13, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 324.19, ["Mega|Ride"] = 288.51, ["Mega|Fly|Ride"] = 361.68}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 69.57, ["Fly"] = 90.57, ["Ride"] = 91.87, ["Fly|Ride"] = 133.49, ["Neon"] = 389.01, ["Neon|Ride"] = 432.23, ["Neon|Fly|Ride"] = 389.01, ["Mega"] = 1573.95, ["Mega|Ride"] = 7875, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 13.13, ["Ride"] = 34.47, ["Fly|Ride"] = 66.94, ["Neon"] = 86.77, ["Neon|Ride"] = 115.08, ["Neon|Fly|Ride"] = 274.46, ["Mega"] = 720.57, ["Mega|Ride"] = 821.21, ["Mega|Fly|Ride"] = 570.53}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 251.98, ["Fly"] = 300.68, ["Ride"] = 236.25, ["Fly|Ride"] = 223.13, ["Neon"] = 525, ["Neon|Ride"] = 623.44, ["Neon|Fly|Ride"] = 796.01, ["Mega"] = 6482.37, ["Mega|Ride"] = 3937.5, ["Mega|Fly|Ride"] = 6483.14}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 31.62}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.71, ["Fly"] = 28.28, ["Ride"] = 22.32, ["Fly|Ride"] = 72.85, ["Neon"] = 21, ["Neon|Fly"] = 144.8, ["Neon|Ride"] = 56.21, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 188.03, ["Mega|Fly"] = 526.22, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 1076.25, ["Fly"] = 3281.25, ["Ride"] = 1174.69, ["Fly|Ride"] = 1507.16, ["Neon"] = 9333.19, ["Neon|Ride"] = 6339.43, ["Neon|Fly|Ride"] = 6482.06, ["Mega|Ride"] = 55266.2, ["Mega|Fly|Ride"] = 24311.73}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 19.69, ["Ride"] = 45.83, ["Fly|Ride"] = 518.61, ["Neon"] = 216.12, ["Neon|Ride"] = 265.83, ["Neon|Fly|Ride"] = 160.79, ["Mega"] = 1043.44, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 240.19, ["Fly"] = 368.51, ["Ride"] = 238.88, ["Fly|Ride"] = 328.13, ["Neon"] = 1067.57, ["Neon|Ride"] = 984.38, ["Neon|Fly|Ride"] = 971.42, ["Mega"] = 4421.84, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 4174.89}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 43.97}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 19.51, ["Fly"] = 86.8, ["Ride"] = 50.79, ["Fly|Ride"] = 144.8, ["Neon"] = 105, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 410.26, ["Mega"] = 598.55, ["Mega|Ride"] = 577.01, ["Mega|Fly|Ride"] = 720.71}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 126, ["Fly"] = 191.02, ["Ride"] = 148.32, ["Fly|Ride"] = 231.25, ["Neon"] = 634.29, ["Neon|Ride"] = 534.87, ["Neon|Fly|Ride"] = 793.12, ["Mega|Ride"] = 2294.45, ["Mega|Fly|Ride"] = 1811.25}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 101.07, ["Fly"] = 249.61, ["Ride"] = 137.81, ["Fly|Ride"] = 266.6, ["Neon"] = 427.8, ["Neon|Fly"] = 819.29, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1378.13}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 47.25}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 50.79, ["Fly"] = 72.18, ["Ride"] = 57.75, ["Fly|Ride"] = 87.84, ["Neon|Ride"] = 432.23, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 4322.1, ["Mega|Fly|Ride"] = 1591.96}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 9.98, ["Fly"] = 43.23, ["Ride"] = 45.47, ["Fly|Ride"] = 209.63, ["Neon"] = 33.18, ["Neon|Ride"] = 140.47, ["Neon|Fly|Ride"] = 244.21, ["Mega"] = 430.01, ["Mega|Ride"] = 277.61, ["Mega|Fly|Ride"] = 348.78}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 551.25, ["Ride"] = 603.75, ["Fly|Ride"] = 597.19, ["Neon|Fly"] = 3889.89, ["Neon|Ride"] = 2247.5, ["Neon|Fly|Ride"] = 1903.13, ["Mega|Fly|Ride"] = 7415.63}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 107.63, ["Fly"] = 144.2, ["Ride"] = 110.25, ["Fly|Ride"] = 181.28, ["Neon"] = 504.62, ["Neon|Ride"] = 432.23, ["Neon|Fly|Ride"] = 406.88, ["Mega|Fly|Ride"] = 2416.31}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 4178.4, ["Ride"] = 3961.13, ["Fly|Ride"] = 3871.88}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 82.69, ["Fly"] = 131.25, ["Ride"] = 91.76, ["Fly|Ride"] = 167.32, ["Neon"] = 377.11, ["Neon|Ride"] = 525, ["Mega|Ride"] = 2003.3, ["Mega|Fly|Ride"] = 1953}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 92.08, ["Fly"] = 328.13, ["Ride"] = 79.97, ["Fly|Ride"] = 103.69, ["Neon"] = 575.75, ["Neon|Ride"] = 432.23, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 6338.68, ["Mega|Ride"] = 2388.75, ["Mega|Fly|Ride"] = 2018.43}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 32.3, ["Fly"] = 64.32, ["Ride"] = 37.71, ["Fly|Ride"] = 91.88, ["Neon"] = 165.35, ["Neon|Fly"] = 197.1, ["Neon|Ride"] = 148.32, ["Neon|Fly|Ride"] = 202.13, ["Mega"] = 2625, ["Mega|Ride"] = 923.86, ["Mega|Fly|Ride"] = 611.63}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 5.65}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 68.09, ["Fly"] = 393.75, ["Ride"] = 66.92, ["Fly|Ride"] = 144.8, ["Neon|Ride"] = 327.97, ["Neon|Fly|Ride"] = 446.25, ["Mega|Fly|Ride"] = 1367.96}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 40.73}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 212.63, ["Ride"] = 236.25, ["Fly|Ride"] = 301.88, ["Neon"] = 1152.93, ["Neon|Ride"] = 1152.93, ["Neon|Fly|Ride"] = 1296.64, ["Mega|Fly|Ride"] = 4851.74}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 708.75, ["Ride"] = 754.69, ["Fly|Ride"] = 709.52, ["Neon|Fly|Ride"] = 2980.09, ["Mega|Fly|Ride"] = 10028.82}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 5.25}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 34.13, ["Fly"] = 45.94, ["Ride"] = 42.47, ["Fly|Ride"] = 66.75, ["Neon"] = 216.12, ["Neon|Fly"] = 288.51, ["Neon|Ride"] = 187.69, ["Neon|Fly|Ride"] = 217, ["Mega|Ride"] = 866.51, ["Mega|Fly|Ride"] = 770.44}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 19.69}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5643.75, ["Fly"] = 6161.14, ["Ride"] = 5942.88, ["Fly|Ride"] = 4882.5, ["Neon|Ride"] = 18016.5, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 32156.25}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 17.07, ["Fly"] = 56.36, ["Ride"] = 24.75, ["Fly|Ride"] = 58.58, ["Neon"] = 144.38, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 553.88, ["Mega|Ride"] = 490.87, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 15.75, ["Fly"] = 72.42, ["Ride"] = 50.88, ["Fly|Ride"] = 132.92, ["Neon"] = 100.35, ["Neon|Ride"] = 143.75, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1069.72, ["Mega|Ride"] = 491.33, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 98.44, ["Ride"] = 78.75, ["Fly|Ride"] = 131.25, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 495.7, ["Mega"] = 4321.58}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 12.7, ["Fly"] = 43.41, ["Ride"] = 42.15, ["Fly|Ride"] = 78.75, ["Neon"] = 97.13, ["Neon|Fly"] = 216.12, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 501.38, ["Mega"] = 553.24, ["Mega|Ride"] = 772.59, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1706.25, ["Fly"] = 2233.45, ["Ride"] = 1509.37, ["Fly|Ride"] = 1575, ["Neon|Fly|Ride"] = 3148.69, ["Mega|Fly|Ride"] = 14412.7}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 26250, ["Fly"] = 30187.5, ["Ride"] = 33280.05, ["Fly|Ride"] = 23537.07, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 63679.41, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 18.37, ["Fly"] = 89.25, ["Ride"] = 55.12, ["Fly|Ride"] = 120.75, ["Neon"] = 113.47, ["Neon|Ride"] = 291.38, ["Neon|Fly|Ride"] = 591.07, ["Mega"] = 1050, ["Mega|Ride"] = 1310.44, ["Mega|Fly|Ride"] = 1568.93}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 5.25, ["Fly"] = 72.17, ["Ride"] = 38.75, ["Fly|Ride"] = 199.5, ["Neon"] = 26.25, ["Neon|Fly"] = 231.24, ["Neon|Ride"] = 72.42, ["Neon|Fly|Ride"] = 129.66, ["Mega"] = 121.22, ["Mega|Fly"] = 385.71, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 292.74}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 27.42}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.88, ["Ride"] = 33.18, ["Fly|Ride"] = 164.59, ["Neon"] = 57.75, ["Neon|Ride"] = 92.61, ["Neon|Fly|Ride"] = 288.48, ["Mega"] = 551.51, ["Mega|Ride"] = 409.54, ["Mega|Fly|Ride"] = 573.63}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 707.73, ["Fly"] = 864.44, ["Ride"] = 654.94, ["Fly|Ride"] = 682.5, ["Neon"] = 3112.11, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2296.88, ["Mega|Fly|Ride"] = 9089.32}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 779.62, ["Fly"] = 1076.15, ["Ride"] = 787.5, ["Fly|Ride"] = 840, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 11382.21}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 16.23, ["Fly"] = 122.84, ["Ride"] = 34.85, ["Fly|Ride"] = 100.04, ["Neon"] = 89.72, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 162.75, ["Mega"] = 503.53, ["Mega|Ride"] = 481.9, ["Mega|Fly|Ride"] = 655.93}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 28.88}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 69.54, ["Fly"] = 101.75, ["Ride"] = 85.32, ["Fly|Ride"] = 144.64, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 451.5, ["Mega"] = 19687.5, ["Mega|Ride"] = 2018.43, ["Mega|Fly|Ride"] = 2118.92}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 87.23, ["Fly"] = 144.8, ["Ride"] = 108.07, ["Fly|Ride"] = 144.8, ["Neon"] = 450.19, ["Neon|Ride"] = 476.53, ["Neon|Fly|Ride"] = 509.15, ["Mega"] = 1406.02}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 6.48, ["Fly"] = 35.81, ["Ride"] = 19.46, ["Fly|Ride"] = 48.55, ["Neon"] = 43.5, ["Neon|Fly"] = 488.69, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 133.87, ["Mega"] = 275.63, ["Mega|Fly|Ride"] = 332.4}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 215.25, ["Fly"] = 226.25, ["Ride"] = 221.19, ["Fly|Ride"] = 301.61, ["Neon|Ride"] = 681.16, ["Neon|Fly|Ride"] = 721.88, ["Mega"] = 5186.51, ["Mega|Fly|Ride"] = 2884.88}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 10.5, ["Ride"] = 39.38, ["Fly|Ride"] = 144.69, ["Neon"] = 49.23, ["Neon|Ride"] = 124.69, ["Mega"] = 262.5, ["Mega|Fly"] = 1137.94, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 17.33, ["Fly"] = 49.14, ["Ride"] = 32.82, ["Fly|Ride"] = 90.65, ["Neon"] = 129.68, ["Neon|Fly"] = 327.97, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 274.98, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 26.24, ["Ride"] = 57.75, ["Fly|Ride"] = 156.19, ["Neon"] = 257.25, ["Neon|Ride"] = 280, ["Neon|Fly|Ride"] = 259.88, ["Mega"] = 997.5, ["Mega|Ride"] = 853.13, ["Mega|Fly|Ride"] = 1009.22}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 17.2, ["Fly"] = 88.61, ["Ride"] = 42, ["Fly|Ride"] = 61.69, ["Neon"] = 151.3, ["Neon|Ride"] = 327.97, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1080.41, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6956.25, ["Ride"] = 5604.38, ["Fly|Ride"] = 5381.25, ["Neon"] = 32415.63, ["Neon|Fly|Ride"] = 29442.05}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 238.88, ["Fly"] = 236.24, ["Ride"] = 229.69, ["Fly|Ride"] = 273, ["Neon|Ride"] = 576.19, ["Neon|Fly|Ride"] = 544.48, ["Mega|Fly|Ride"] = 2098.95}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 72.19, ["Fly"] = 185.94, ["Ride"] = 132.66, ["Fly|Ride"] = 341.25, ["Neon"] = 246.75, ["Neon|Ride"] = 341.16, ["Neon|Fly|Ride"] = 436.54, ["Mega"] = 619.5, ["Mega|Ride"] = 704.51, ["Mega|Fly|Ride"] = 756}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.46, ["Fly"] = 65.63, ["Ride"] = 21.62, ["Fly|Ride"] = 81.38, ["Neon"] = 28.88, ["Neon|Ride"] = 35.28, ["Neon|Fly|Ride"] = 164.6, ["Mega"] = 126, ["Mega|Ride"] = 331.7, ["Mega|Fly|Ride"] = 255.94}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 54.51, ["Fly"] = 215.34, ["Ride"] = 107.61, ["Fly|Ride"] = 224.44, ["Neon"] = 208.69, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 525, ["Mega|Fly"] = 755.3, ["Mega|Ride"] = 563.73, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 11418.75, ["Ride"] = 13415.07, ["Fly|Ride"] = 11549.99, ["Neon|Fly|Ride"] = 24766.88, ["Mega|Fly|Ride"] = 100719.36}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 372.75, ["Ride"] = 393.75, ["Fly|Ride"] = 486.25, ["Neon"] = 3239.42, ["Neon|Ride"] = 1728.85, ["Neon|Fly|Ride"] = 1787.2, ["Mega"] = 8137.5, ["Mega|Fly|Ride"] = 7873.69}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 45.94, ["Fly"] = 91.88, ["Ride"] = 59.07, ["Fly|Ride"] = 94.5, ["Neon"] = 301.88, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 392.44, ["Mega|Fly|Ride"] = 2016.27}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 10.18, ["Ride"] = 24.85, ["Fly|Ride"] = 74.82, ["Neon"] = 69.21, ["Neon|Fly"] = 278.83, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 142.64, ["Mega"] = 336, ["Mega|Fly|Ride"] = 555.41}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 400.32, ["Ride"] = 420, ["Fly|Ride"] = 477.75, ["Neon"] = 1253.44, ["Neon|Ride"] = 1377.69, ["Neon|Fly|Ride"] = 1176, ["Mega|Fly|Ride"] = 4547.82}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.12, ["Fly"] = 71.32, ["Ride"] = 39.26, ["Fly|Ride"] = 164.6, ["Neon"] = 28.88, ["Neon|Ride"] = 144.37, ["Neon|Fly|Ride"] = 196.77, ["Mega"] = 166.69, ["Mega|Fly"] = 236.25, ["Mega|Ride"] = 215.04, ["Mega|Fly|Ride"] = 278.25}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 103.95, ["Fly"] = 216.12, ["Ride"] = 150.94, ["Fly|Ride"] = 209.88, ["Neon"] = 472.5, ["Neon|Fly"] = 525, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 557.82, ["Mega"] = 2593.26, ["Mega|Fly|Ride"] = 2430.18}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.85, ["Fly"] = 21.62, ["Ride"] = 16.78, ["Fly|Ride"] = 42.15, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 88.22, ["Mega"] = 2592.96, ["Mega|Fly|Ride"] = 743.42}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 10.69}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 78.75, ["Fly"] = 598.23, ["Ride"] = 118.13, ["Fly|Ride"] = 172.9, ["Neon"] = 352.43, ["Neon|Fly"] = 1296.49, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 518.66, ["Mega|Ride"] = 1873.64, ["Mega|Fly|Ride"] = 2305.85}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 15.41, ["Fly"] = 78.33, ["Ride"] = 40.05, ["Fly|Ride"] = 83.91, ["Neon"] = 97.28, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 259.34, ["Mega"] = 547.84, ["Mega|Ride"] = 577.5, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 57.75}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 84, ["Fly"] = 144.8, ["Ride"] = 129.83, ["Fly|Ride"] = 321.82, ["Neon"] = 392.44, ["Neon|Ride"] = 485.17, ["Neon|Fly|Ride"] = 374.07, ["Mega|Fly|Ride"] = 1965.28}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.68, ["Ride"] = 29.19, ["Neon"] = 23.55, ["Neon|Ride"] = 141.57, ["Neon|Fly|Ride"] = 252.86, ["Mega"] = 136.5, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 288.1}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 11.68, ["Fly"] = 56.42, ["Ride"] = 33.52, ["Fly|Ride"] = 94.5, ["Neon|Ride"] = 105.91, ["Neon|Fly|Ride"] = 216.12, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 603.74, ["Ride"] = 534.45, ["Fly|Ride"] = 459.37, ["Neon|Fly|Ride"] = 5763.52, ["Mega|Fly|Ride"] = 7087.5}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 37.99, ["Ride"] = 80.75, ["Fly|Ride"] = 107.6, ["Neon"] = 195.57, ["Neon|Ride"] = 142.64, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 776.43, ["Mega|Ride"] = 647.79, ["Mega|Fly|Ride"] = 720.71}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 57.23, ["Fly"] = 101.58, ["Ride"] = 86.1, ["Fly|Ride"] = 157.4, ["Neon"] = 302.56, ["Neon|Ride"] = 254.91, ["Neon|Fly|Ride"] = 288.51, ["Mega|Fly|Ride"] = 864.44}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 19.69, ["Fly"] = 80.04, ["Ride"] = 64.7, ["Fly|Ride"] = 110.24, ["Neon"] = 101.05, ["Neon|Fly"] = 327.97, ["Neon|Ride"] = 161.39, ["Neon|Fly|Ride"] = 249.37, ["Mega"] = 350.83, ["Mega|Ride"] = 580.46, ["Mega|Fly|Ride"] = 577.01}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11136.88, ["Fly"] = 10048.86, ["Ride"] = 8862, ["Fly|Ride"] = 7743.75, ["Neon|Fly|Ride"] = 15750, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1351.88, ["Fly"] = 1563.63, ["Ride"] = 1312.5, ["Fly|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 3996.57, ["Mega|Fly|Ride"] = 15722.05}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 608.98, ["Ride"] = 525, ["Fly|Ride"] = 601.02, ["Neon"] = 2253.58, ["Neon|Fly|Ride"] = 2437.74, ["Mega"] = 21607.84, ["Mega|Fly|Ride"] = 9826.3}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 13.13, ["Fly"] = 25.1, ["Ride"] = 22.43, ["Fly|Ride"] = 42.94, ["Neon"] = 123.2, ["Neon|Ride"] = 86.45, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 491.33, ["Mega|Fly|Ride"] = 539.44}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 3.94, ["Fly"] = 78.74, ["Ride"] = 27.83, ["Fly|Ride"] = 198.83, ["Neon"] = 30.53, ["Neon|Ride"] = 71.56, ["Mega"] = 196.88, ["Mega|Ride"] = 221.2, ["Mega|Fly|Ride"] = 279.51}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 39.38, ["Fly"] = 53.81, ["Ride"] = 43.55, ["Fly|Ride"] = 111.57, ["Neon"] = 551.16, ["Neon|Fly"] = 271.23, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 190.63, ["Mega|Fly|Ride"] = 647.25}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.94, ["Fly"] = 22.89, ["Ride"] = 16.06, ["Fly|Ride"] = 36.61, ["Neon"] = 43.23, ["Neon|Fly"] = 64.71, ["Neon|Ride"] = 43.23, ["Neon|Fly|Ride"] = 104.9, ["Mega"] = 294.9, ["Mega|Ride"] = 360.91, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 313.04, ["Fly"] = 432.17, ["Ride"] = 328.37, ["Fly|Ride"] = 405.57, ["Neon"] = 1636.08, ["Neon|Ride"] = 1456.55, ["Neon|Fly|Ride"] = 1373.61, ["Mega|Fly|Ride"] = 4968.25}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 22.96, ["Fly"] = 91.87, ["Ride"] = 40.68, ["Fly|Ride"] = 91.88, ["Neon"] = 111.57, ["Neon|Fly"] = 415.56, ["Neon|Ride"] = 133.71, ["Neon|Fly|Ride"] = 245.28, ["Mega"] = 864.44, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 9.16, ["Fly"] = 24.06, ["Ride"] = 23.79, ["Fly|Ride"] = 41.6, ["Neon"] = 81.05, ["Neon|Fly"] = 122.11, ["Neon|Ride"] = 133.89, ["Neon|Fly|Ride"] = 142.64, ["Mega"] = 1441.42, ["Mega|Ride"] = 451.5, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 459.38, ["Fly"] = 1048.69, ["Ride"] = 485.63, ["Fly|Ride"] = 637.83, ["Mega|Fly|Ride"] = 9971.07}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1050, ["Fly"] = 1441.42, ["Ride"] = 1050, ["Fly|Ride"] = 1153.72, ["Neon"] = 5270.6, ["Neon|Ride"] = 4899.09, ["Neon|Fly|Ride"] = 3465, ["Mega|Fly|Ride"] = 13782.3}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 128.63, ["Fly"] = 129.68, ["Ride"] = 111.57, ["Fly|Ride"] = 125.75, ["Neon"] = 971.25, ["Neon|Ride"] = 982.65, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 2591.1, ["Mega|Fly|Ride"] = 2869.12}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 177.19, ["Fly"] = 196.86, ["Ride"] = 208.52, ["Fly|Ride"] = 245.7, ["Neon|Ride"] = 663.46, ["Neon|Fly|Ride"] = 616.88, ["Mega|Ride"] = 9493.32, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 32.01, ["Fly"] = 124.27, ["Ride"] = 56.11, ["Fly|Ride"] = 101.06, ["Neon"] = 262.4, ["Neon|Ride"] = 243, ["Neon|Fly|Ride"] = 281.21, ["Mega|Ride"] = 2160.8, ["Mega|Fly|Ride"] = 1138.89}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 203.43, ["Ride"] = 646.14, ["Fly|Ride"] = 577.01, ["Neon"] = 1220.63, ["Mega|Fly|Ride"] = 6483.14}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2372.85, ["Ride"] = 2018.43, ["Fly|Ride"] = 2100, ["Neon"] = 10805.22, ["Neon|Fly|Ride"] = 10805.22, ["Mega|Fly|Ride"] = 49703.97}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 60.19, ["Fly"] = 216.12, ["Ride"] = 73.49, ["Neon"] = 288.75, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 343.3, ["Mega|Ride"] = 2376.88, ["Mega|Fly|Ride"] = 1441.42}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 566.99, ["Fly"] = 864.32, ["Ride"] = 597.19, ["Fly|Ride"] = 630, ["Neon|Ride"] = 1305.92, ["Neon|Fly|Ride"] = 1168.13, ["Mega|Fly|Ride"] = 3543.75}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 38.94, ["Fly"] = 50.79, ["Ride"] = 51.19, ["Fly|Ride"] = 89.25, ["Neon"] = 432.23, ["Neon|Ride"] = 257.96, ["Neon|Fly|Ride"] = 203.44, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 4.94, ["Fly"] = 56.21, ["Ride"] = 19.69, ["Fly|Ride"] = 55.13, ["Neon"] = 30.19, ["Neon|Fly"] = 136.76, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 160.02, ["Mega|Fly"] = 254.05, ["Mega|Ride"] = 216.8, ["Mega|Fly|Ride"] = 259.04}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 73.5, ["Ride"] = 131.24, ["Fly|Ride"] = 157.5, ["Neon"] = 401.5, ["Neon|Ride"] = 491.33, ["Neon|Fly|Ride"] = 717.71, ["Mega"] = 1619.71, ["Mega|Ride"] = 1728.85, ["Mega|Fly|Ride"] = 1873.64}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 1055.54, ["Ride"] = 1073.37, ["Fly|Ride"] = 1115.63, ["Neon|Ride"] = 3694.69, ["Neon|Fly|Ride"] = 3150, ["Mega|Fly|Ride"] = 14807.63}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 719.25, ["Ride"] = 840, ["Fly|Ride"] = 1009.22, ["Neon|Fly|Ride"] = 4322.1, ["Mega|Fly|Ride"] = 20170.08}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 15.54, ["Fly"] = 33.08, ["Ride"] = 25.95, ["Fly|Ride"] = 42, ["Neon"] = 142.93, ["Neon|Ride"] = 128.64, ["Neon|Fly|Ride"] = 117.24, ["Mega|Fly|Ride"] = 777.34}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 57.75, ["Ride"] = 54.05, ["Fly|Ride"] = 141.57, ["Neon"] = 253.32, ["Neon|Ride"] = 331.73, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 1638.55, ["Mega|Ride"] = 2915.85, ["Mega|Fly|Ride"] = 1227.19}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.9, ["Fly"] = 49.14, ["Ride"] = 24.51, ["Fly|Ride"] = 85.32, ["Neon"] = 21, ["Neon|Fly"] = 144.8, ["Neon|Ride"] = 49.19, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 157.5, ["Mega|Fly"] = 573.63, ["Mega|Ride"] = 187.11, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 35.96, ["Fly"] = 58.36, ["Ride"] = 42.73, ["Fly|Ride"] = 110.06, ["Neon"] = 287.43, ["Neon|Ride"] = 220.5, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 105, ["Ride"] = 288.48, ["Fly|Ride"] = 360.91, ["Neon"] = 560.33, ["Neon|Ride"] = 603.75, ["Neon|Fly|Ride"] = 907.72, ["Mega"] = 1837.5, ["Mega|Fly|Ride"] = 2585.63}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 18.16, ["Fly"] = 58.36, ["Ride"] = 43.32, ["Fly|Ride"] = 129.68, ["Neon"] = 91.88, ["Neon|Ride"] = 97.79, ["Neon|Fly|Ride"] = 164.6, ["Mega"] = 506.85, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 534.87}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 42.3, ["Fly"] = 64.32, ["Ride"] = 39.38, ["Fly|Ride"] = 89.55, ["Neon"] = 244.39, ["Neon|Fly"] = 1441.26, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 244.25, ["Mega"] = 2100, ["Mega|Ride"] = 1196.14, ["Mega|Fly|Ride"] = 1053.74}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.94, ["Fly"] = 58.06, ["Ride"] = 16.96, ["Fly|Ride"] = 45.82, ["Neon"] = 35.34, ["Neon|Ride"] = 40.09, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 223.13, ["Mega|Ride"] = 394.75, ["Mega|Fly|Ride"] = 366.32}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 10.33, ["Fly"] = 65.63, ["Ride"] = 35.43, ["Fly|Ride"] = 86.45, ["Neon"] = 61.59, ["Neon|Fly"] = 115.54, ["Neon|Ride"] = 82.31, ["Neon|Fly|Ride"] = 267.75, ["Mega"] = 380.63, ["Mega|Ride"] = 486.25, ["Mega|Fly|Ride"] = 485.52}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 43.22, ["Fly"] = 42, ["Ride"] = 55.1, ["Fly|Ride"] = 84.45, ["Neon"] = 572.87, ["Neon|Ride"] = 213.22, ["Neon|Fly|Ride"] = 236.25, ["Mega|Fly|Ride"] = 1074.94}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1391.25, ["Fly"] = 1443.75, ["Ride"] = 1325.37, ["Fly|Ride"] = 1325.63, ["Neon|Fly|Ride"] = 3215.63, ["Mega|Fly|Ride"] = 13013.69}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 498.75, ["Fly"] = 681.82, ["Ride"] = 525, ["Fly|Ride"] = 572.25, ["Neon|Ride"] = 1740.38, ["Neon|Fly|Ride"] = 2332.32}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 301.88, ["Ride"] = 315, ["Fly|Ride"] = 433.13, ["Neon"] = 1685.63, ["Neon|Ride"] = 1728.85, ["Neon|Fly|Ride"] = 1728.64}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 43.32}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 39.11, ["Ride"] = 49.87, ["Fly|Ride"] = 110.23, ["Neon"] = 302.18, ["Neon|Fly"] = 577.01, ["Neon|Ride"] = 323.09, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 1728.64, ["Mega|Fly|Ride"] = 1036.54}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 70875, ["Fly"] = 25709.84, ["Ride"] = 37667.84, ["Fly|Ride"] = 18262.13, ["Neon|Fly|Ride"] = 32812.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 275.63, ["Fly"] = 328.12, ["Ride"] = 278.25, ["Fly|Ride"] = 367.5, ["Neon"] = 889.88, ["Neon|Ride"] = 1147.15, ["Neon|Fly|Ride"] = 951.56, ["Mega"] = 6482.37, ["Mega|Fly|Ride"] = 3281.33}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 158.81, ["Fly"] = 525, ["Ride"] = 165.83, ["Fly|Ride"] = 323.09}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 111.56, ["Fly"] = 216.12, ["Ride"] = 116.62, ["Fly|Ride"] = 195.57, ["Neon|Ride"] = 719.25, ["Neon|Fly|Ride"] = 643.48, ["Mega|Fly|Ride"] = 2887.5}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 14.43, ["Fly"] = 62.69, ["Ride"] = 29.19, ["Fly|Ride"] = 71.25, ["Neon|Fly"] = 105, ["Neon|Ride"] = 159.93, ["Neon|Fly|Ride"] = 238.81, ["Mega"] = 1968.75, ["Mega|Ride"] = 720.63, ["Mega|Fly|Ride"] = 661.5}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3814.43, ["Ride"] = 4067.44, ["Fly|Ride"] = 3976.88, ["Neon"] = 21607.84, ["Neon|Fly|Ride"] = 15750, ["Mega|Fly|Ride"] = 81876.25}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 31.4, ["Fly"] = 52.5, ["Ride"] = 31.49, ["Fly|Ride"] = 53.82, ["Neon"] = 208.58, ["Neon|Ride"] = 235.58, ["Neon|Fly|Ride"] = 195.57, ["Mega|Ride"] = 1441.42, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 26.25, ["Fly"] = 105, ["Ride"] = 45.94, ["Fly|Ride"] = 103.69, ["Neon"] = 310.13, ["Neon|Fly"] = 1441.42, ["Neon|Ride"] = 202.79, ["Neon|Fly|Ride"] = 345.78, ["Mega|Fly|Ride"] = 1607.82}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 393.75, ["Fly"] = 459.38, ["Ride"] = 420, ["Fly|Ride"] = 498.75, ["Neon"] = 1312.5, ["Neon|Ride"] = 1141.87, ["Neon|Fly|Ride"] = 1232.44, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 15.74, ["Fly"] = 26.11, ["Ride"] = 24.3, ["Fly|Ride"] = 52.5, ["Neon|Ride"] = 118.11, ["Neon|Fly|Ride"] = 157.4, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 14.44, ["Fly"] = 288.51, ["Ride"] = 35.43, ["Fly|Ride"] = 81.09, ["Neon"] = 98.44, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 219.91, ["Mega|Ride"] = 551.25}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 91.47, ["Ride"] = 99.42, ["Fly|Ride"] = 245.44, ["Neon"] = 529.85, ["Neon|Ride"] = 511.88, ["Neon|Fly|Ride"] = 649.69, ["Mega|Ride"] = 4321.58, ["Mega|Fly|Ride"] = 4096.35}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 12.98, ["Fly"] = 102.38, ["Ride"] = 68.86, ["Fly|Ride"] = 144.8, ["Neon"] = 77.44, ["Neon|Ride"] = 110.53, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 243.71, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 360.93}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 5906.25, ["Ride"] = 5498.07, ["Fly|Ride"] = 5117.44, ["Neon"] = 19687.5, ["Neon|Ride"] = 15559.51, ["Neon|Fly|Ride"] = 11811.19, ["Mega"] = 49008.58, ["Mega|Fly|Ride"] = 37945.69}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 36.54, ["Fly"] = 144.8, ["Ride"] = 64.22, ["Fly|Ride"] = 144.8, ["Neon"] = 233.62, ["Neon|Ride"] = 278.83, ["Neon|Fly|Ride"] = 432.23, ["Mega"] = 1225.32, ["Mega|Ride"] = 1801.7, ["Mega|Fly|Ride"] = 784.88}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 6562.5, ["Ride"] = 6857.81, ["Fly|Ride"] = 6300, ["Neon|Fly"] = 18584.97, ["Neon|Fly|Ride"] = 15225, ["Mega|Fly|Ride"] = 46921.88}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.29, ["Fly"] = 21.27, ["Ride"] = 16.2, ["Fly|Ride"] = 35.7, ["Neon"] = 24.94, ["Neon|Fly"] = 51.89, ["Neon|Ride"] = 39.52, ["Neon|Fly|Ride"] = 108.07, ["Mega"] = 183.75, ["Mega|Fly"] = 1441.42, ["Mega|Ride"] = 288.51, ["Mega|Fly|Ride"] = 199.5}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 21.62, ["Fly"] = 38.75, ["Ride"] = 34.12, ["Fly|Ride"] = 63.76, ["Neon"] = 92.14, ["Neon|Fly"] = 238.81, ["Neon|Ride"] = 142.64, ["Neon|Fly|Ride"] = 142.93, ["Mega|Ride"] = 893.17, ["Mega|Fly|Ride"] = 864.44}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 4.33}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 15.52, ["Fly"] = 39.37, ["Ride"] = 33.75, ["Fly|Ride"] = 85.32, ["Neon"] = 170.62, ["Neon|Ride"] = 131.25, ["Mega"] = 1049.9, ["Mega|Ride"] = 1151.71, ["Mega|Fly|Ride"] = 819.29}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 30.97, ["Fly"] = 190.37, ["Ride"] = 58.36, ["Fly|Ride"] = 131.25, ["Neon"] = 244.55, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 323.09, ["Mega"] = 839.99, ["Mega|Fly|Ride"] = 1099.33}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 15.28, ["Fly"] = 24.87, ["Ride"] = 20.77, ["Fly|Ride"] = 42.6, ["Neon|Fly"] = 1077.16, ["Neon|Ride"] = 108.07, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 1133.35, ["Mega|Fly|Ride"] = 663.46}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 6628.13}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 3071.25}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 26.25}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 210, ["Ride"] = 377.11, ["Fly|Ride"] = 341.25, ["Neon|Fly|Ride"] = 1213.56}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 13.99, ["Fly"] = 61.61, ["Ride"] = 39.38, ["Fly|Ride"] = 147, ["Neon"] = 103.76, ["Neon|Ride"] = 115.63, ["Neon|Fly|Ride"] = 265.13, ["Mega|Ride"] = 1470, ["Mega|Fly|Ride"] = 577.01}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 13.13}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 9.18, ["Ride"] = 25.97, ["Fly|Ride"] = 86.45, ["Neon"] = 144.8, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 183.7, ["Mega|Fly|Ride"] = 496.12}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2493.74}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 259.75, ["Ride"] = 345.78, ["Fly|Ride"] = 736.98, ["Neon"] = 1048.69, ["Neon|Fly|Ride"] = 1585.15, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 68.04, ["Fly"] = 216.12, ["Ride"] = 89.25, ["Fly|Ride"] = 525, ["Neon"] = 316.32, ["Neon|Ride"] = 345.96, ["Neon|Fly|Ride"] = 720.71, ["Mega|Ride"] = 2456.58, ["Mega|Fly|Ride"] = 2158.9}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 157.49, ["Fly"] = 275.63, ["Ride"] = 225.75, ["Fly|Ride"] = 262.87, ["Neon"] = 757.32, ["Neon|Ride"] = 879.38, ["Neon|Fly|Ride"] = 748.12, ["Mega|Ride"] = 3673.78, ["Mega|Fly|Ride"] = 3599.88}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2428.13, ["Ride"] = 2492.44, ["Fly|Ride"] = 2703.75, ["Neon"] = 15177.01, ["Neon|Fly|Ride"] = 9797.09, ["Mega|Fly|Ride"] = 31499.99}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 21.62, ["Fly"] = 106.98, ["Ride"] = 45.94, ["Fly|Ride"] = 89.14, ["Neon"] = 216.12, ["Neon|Ride"] = 387.92, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 971.42, ["Mega|Ride"] = 2362.83, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 1296.64, ["Fly"] = 2231.25, ["Ride"] = 1239.38, ["Fly|Ride"] = 1620.81, ["Neon|Fly|Ride"] = 6483.14}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 58.36}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 23.29, ["Fly"] = 98.35, ["Ride"] = 38.14, ["Fly|Ride"] = 245.44, ["Neon"] = 107.63, ["Neon|Ride"] = 136.17, ["Neon|Fly|Ride"] = 263.67, ["Mega"] = 379.32, ["Mega|Ride"] = 526.12, ["Mega|Fly|Ride"] = 506.16}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 9.19, ["Fly"] = 38.4, ["Ride"] = 31.7, ["Fly|Ride"] = 76.18, ["Neon"] = 68.25, ["Neon|Fly"] = 315, ["Neon|Ride"] = 77.34, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 459.39, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 577.01}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 70.65}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 17.07, ["Fly"] = 64.86, ["Ride"] = 33.18, ["Fly|Ride"] = 76.74, ["Neon"] = 144.8, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 259.31, ["Mega|Ride"] = 1296.64, ["Mega|Fly|Ride"] = 863.35}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 28.86, ["Fly"] = 50.79, ["Ride"] = 39.29, ["Fly|Ride"] = 61.74, ["Neon"] = 164.6, ["Neon|Fly"] = 288.51, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 249.36, ["Mega"] = 1441.26, ["Mega|Ride"] = 1842.22, ["Mega|Fly|Ride"] = 871.5}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6628.13, ["Fly"] = 4685.63, ["Ride"] = 6339.43, ["Fly|Ride"] = 4725, ["Neon|Fly|Ride"] = 10484.25, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 11.71, ["Fly"] = 49.72, ["Ride"] = 29.74, ["Fly|Ride"] = 81.84, ["Neon"] = 57.75, ["Neon|Ride"] = 95.69, ["Mega"] = 354.38, ["Mega|Ride"] = 329.44, ["Mega|Fly|Ride"] = 756.37}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 24.86}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 103.42, ["Fly"] = 382.48, ["Ride"] = 115.64, ["Fly|Ride"] = 249.38, ["Neon"] = 531.57, ["Neon|Ride"] = 561.88, ["Neon|Fly|Ride"] = 535.5, ["Mega"] = 2879.59, ["Mega|Ride"] = 1840.43, ["Mega|Fly|Ride"] = 1571.31}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 61.69, ["Fly"] = 200.8, ["Ride"] = 97.13, ["Fly|Ride"] = 170.63, ["Neon"] = 255.94, ["Neon|Fly"] = 368.51, ["Neon|Ride"] = 317.63, ["Neon|Fly|Ride"] = 504.62, ["Mega"] = 1225.32, ["Mega|Ride"] = 1239.38, ["Mega|Fly|Ride"] = 1200.94}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 24.94, ["Fly"] = 50.79, ["Ride"] = 34.13, ["Fly|Ride"] = 62.98, ["Neon"] = 97.13, ["Neon|Fly"] = 233.41, ["Neon|Ride"] = 136.49, ["Neon|Fly|Ride"] = 192.84, ["Mega"] = 1016.21, ["Mega|Ride"] = 901.58, ["Mega|Fly|Ride"] = 713.15}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 7.87, ["Fly"] = 68.25, ["Ride"] = 25.61, ["Fly|Ride"] = 72.42, ["Neon"] = 38.07, ["Neon|Ride"] = 64.86, ["Neon|Fly|Ride"] = 165.63, ["Mega"] = 236.25, ["Mega|Fly"] = 7203.84, ["Mega|Ride"] = 331.73, ["Mega|Fly|Ride"] = 282.19}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 13.79, ["Fly"] = 105, ["Ride"] = 31.5, ["Fly|Ride"] = 92.94, ["Neon"] = 92.93, ["Neon|Ride"] = 115.63, ["Neon|Fly|Ride"] = 231.25, ["Mega"] = 380.63, ["Mega|Ride"] = 476.53, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 27.56, ["Fly"] = 28, ["Ride"] = 26.14, ["Fly|Ride"] = 44.54, ["Neon"] = 183.7, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 157.77, ["Mega|Fly|Ride"] = 488.82}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 196.88}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 42, ["Ride"] = 157.5, ["Fly|Ride"] = 288.51, ["Neon"] = 196.88, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 462.48, ["Mega"] = 866.25, ["Mega|Fly|Ride"] = 791.31}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 261.51, ["Ride"] = 481.92}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 69.57, ["Ride"] = 97.13, ["Fly|Ride"] = 193.64, ["Neon"] = 217, ["Neon|Ride"] = 324.3, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 1208.82, ["Mega|Ride"] = 1403.61, ["Mega|Fly|Ride"] = 1512.57}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 1093.32, ["Fly"] = 1246.67, ["Ride"] = 1050, ["Fly|Ride"] = 1092, ["Neon|Ride"] = 3675, ["Neon|Fly|Ride"] = 3281.25, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 420, ["Ride"] = 484.32, ["Fly|Ride"] = 551.25, ["Neon"] = 2405.82, ["Neon|Ride"] = 7779.76, ["Neon|Fly|Ride"] = 1903.13, ["Mega"] = 12600, ["Mega|Fly|Ride"] = 8201.82}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 77.82}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 11.82, ["Fly"] = 32.82, ["Ride"] = 24.91, ["Fly|Ride"] = 63.76, ["Neon"] = 98.27, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 437.26, ["Mega|Ride"] = 561.88, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 245.12, ["Fly"] = 525, ["Ride"] = 275.63, ["Fly|Ride"] = 339.43, ["Neon"] = 851.82, ["Neon|Ride"] = 759.94, ["Neon|Fly|Ride"] = 874.13, ["Mega|Fly|Ride"] = 3349.64}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 19.69}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 114.19, ["Fly"] = 164.6, ["Ride"] = 170.63, ["Fly|Ride"] = 236.25, ["Neon"] = 485.94, ["Neon|Fly"] = 610.32, ["Neon|Ride"] = 573.54, ["Neon|Fly|Ride"] = 682.5, ["Mega"] = 2809.36, ["Mega|Ride"] = 2738.06, ["Mega|Fly|Ride"] = 2448.18}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 129.83, ["Fly"] = 312, ["Ride"] = 131.25, ["Fly|Ride"] = 288.51, ["Neon"] = 1023.27, ["Neon|Ride"] = 1032.94, ["Neon|Fly|Ride"] = 931.88, ["Mega|Fly|Ride"] = 2018.43}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 7.88, ["Ride"] = 24.59, ["Fly|Ride"] = 729.75, ["Neon"] = 32.48, ["Neon|Ride"] = 73.41, ["Neon|Fly|Ride"] = 211.32, ["Mega"] = 171.28, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 406.58}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 17.07, ["Fly"] = 30.56, ["Ride"] = 26.35, ["Fly|Ride"] = 69.57, ["Neon"] = 110.25, ["Neon|Fly"] = 144.8, ["Neon|Ride"] = 110.44, ["Neon|Fly|Ride"] = 209.9, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 17.16, ["Fly"] = 102.36, ["Ride"] = 26.25, ["Fly|Ride"] = 131.25, ["Neon"] = 110.25, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 215.91, ["Mega"] = 382.52, ["Mega|Ride"] = 429.19, ["Mega|Fly|Ride"] = 393.74}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 4.94, ["Fly"] = 172.9, ["Ride"] = 45.48, ["Fly|Ride"] = 105, ["Neon"] = 21.83, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 155.91, ["Mega"] = 147, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 261.18}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 300.46, ["Ride"] = 309.75, ["Fly|Ride"] = 367.5, ["Neon|Ride"] = 1441.42, ["Neon|Fly|Ride"] = 1424.07}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 85.71, ["Fly"] = 577.01, ["Ride"] = 125.98, ["Fly|Ride"] = 215.25, ["Neon"] = 458.06, ["Neon|Ride"] = 518.66, ["Neon|Fly|Ride"] = 524.9, ["Mega"] = 2022.57, ["Mega|Fly|Ride"] = 2099.47}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 72.65, ["Fly"] = 167.45, ["Ride"] = 89.06, ["Fly|Ride"] = 142.63, ["Neon"] = 393.75, ["Neon|Ride"] = 349.13, ["Neon|Fly|Ride"] = 446.25, ["Mega|Ride"] = 1801.91, ["Mega|Fly|Ride"] = 1374.18}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 20.55, ["Ride"] = 54.05, ["Neon|Ride"] = 623.93, ["Neon|Fly|Ride"] = 491.33, ["Mega|Fly|Ride"] = 1009.22}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 15.65, ["Ride"] = 26.25, ["Fly|Ride"] = 99.42, ["Neon"] = 58.36, ["Neon|Ride"] = 93.35, ["Neon|Fly|Ride"] = 210, ["Mega"] = 348.7, ["Mega|Ride"] = 432.23, ["Mega|Fly|Ride"] = 618.07}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 5.25, ["Fly"] = 38.98, ["Ride"] = 24.59, ["Fly|Ride"] = 86.45, ["Neon"] = 23.63, ["Neon|Fly"] = 105000, ["Neon|Ride"] = 43.22, ["Neon|Fly|Ride"] = 111.71, ["Mega"] = 321.98, ["Mega|Ride"] = 149.63, ["Mega|Fly|Ride"] = 254.63}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 853.13, ["Fly"] = 1048.59, ["Ride"] = 853.13, ["Fly|Ride"] = 906.94, ["Neon"] = 3025.47, ["Neon|Ride"] = 8644.17, ["Neon|Fly|Ride"] = 2467.48, ["Mega|Fly|Ride"] = 8268.75}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 249.25, ["Fly"] = 365.23, ["Ride"] = 288.42, ["Fly|Ride"] = 345.78, ["Neon"] = 1585.15, ["Neon|Ride"] = 1270.5, ["Neon|Fly|Ride"] = 1724.52, ["Mega"] = 10803.94, ["Mega|Ride"] = 5895.79, ["Mega|Fly|Ride"] = 5358.32}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 104.82, ["Fly"] = 128.87, ["Ride"] = 117.84, ["Fly|Ride"] = 157.5, ["Neon"] = 491.33, ["Neon|Ride"] = 473.48, ["Neon|Fly|Ride"] = 525, ["Mega"] = 1575, ["Mega|Ride"] = 1772.07, ["Mega|Fly|Ride"] = 1884.21}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 208.3, ["Fly"] = 255.02, ["Ride"] = 180.74, ["Fly|Ride"] = 216.57, ["Neon|Ride"] = 1147.25, ["Neon|Fly|Ride"] = 978.43, ["Mega"] = 10803.94, ["Mega|Fly|Ride"] = 4096.35}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 20.37, ["Fly"] = 36.75, ["Ride"] = 27.57, ["Fly|Ride"] = 63, ["Neon"] = 170.63, ["Neon|Ride"] = 129.68, ["Neon|Fly|Ride"] = 197.08, ["Mega|Ride"] = 768.27}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 203.76, ["Ride"] = 327.97, ["Neon"] = 1584.98, ["Neon|Ride"] = 942.38, ["Neon|Fly|Ride"] = 892.5, ["Mega"] = 4285.77, ["Mega|Fly|Ride"] = 3588.42}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 97.98, ["Ride"] = 98.51, ["Fly|Ride"] = 131.24, ["Neon|Ride"] = 1638.34, ["Neon|Fly|Ride"] = 498.75, ["Mega|Ride"] = 2305.57, ["Mega|Fly|Ride"] = 1821.75}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 2520, ["Ride"] = 2377.75, ["Fly|Ride"] = 2296.87, ["Neon|Ride"] = 11464.83, ["Neon|Fly|Ride"] = 7852.17, ["Mega"] = 51858.8, ["Mega|Fly|Ride"] = 28814.25}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 14.11, ["Fly"] = 45.94, ["Ride"] = 56.44, ["Fly|Ride"] = 115.63, ["Neon"] = 57.75, ["Neon|Fly"] = 173.03, ["Neon|Ride"] = 87.93, ["Neon|Fly|Ride"] = 164.59, ["Mega"] = 312.38, ["Mega|Ride"] = 410.61, ["Mega|Fly|Ride"] = 458.07}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 53.34, ["Fly"] = 144.8, ["Ride"] = 87.94, ["Fly|Ride"] = 149.63, ["Neon"] = 236.25, ["Neon|Ride"] = 231.25, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 891.19, ["Mega|Ride"] = 931.87, ["Mega|Fly|Ride"] = 1497.57}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 104.34, ["Fly"] = 102.16, ["Ride"] = 91.49, ["Fly|Ride"] = 124.68, ["Neon|Ride"] = 490.56, ["Neon|Fly|Ride"] = 432.23, ["Mega|Fly|Ride"] = 1512.03}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2784.54, ["Fly"] = 1638.34, ["Ride"] = 1073.63, ["Fly|Ride"] = 966, ["Neon|Ride"] = 5732.43, ["Neon|Fly|Ride"] = 3937.49, ["Mega"] = 43220.83, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 436.4, ["Fly"] = 862.28, ["Ride"] = 819.05, ["Fly|Ride"] = 819.29, ["Mega"] = 11345.49}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 72.77, ["Fly"] = 155.6, ["Ride"] = 98.44, ["Fly|Ride"] = 224.44, ["Neon"] = 328.13, ["Neon|Ride"] = 367.49, ["Neon|Fly|Ride"] = 491.33, ["Mega"] = 5763.52, ["Mega|Ride"] = 1657.53, ["Mega|Fly|Ride"] = 1758.03}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 11.82, ["Fly"] = 41.77, ["Ride"] = 26.17, ["Fly|Ride"] = 63.91, ["Neon"] = 67.46, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 148.32, ["Mega"] = 656.25, ["Mega|Ride"] = 832.26}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 45.94, ["Fly"] = 62.69, ["Ride"] = 52.74, ["Fly|Ride"] = 65.24, ["Neon"] = 213.73, ["Neon|Ride"] = 280.94, ["Neon|Fly|Ride"] = 339.94, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 691.69, ["Fly"] = 1129.91, ["Ride"] = 721.86, ["Fly|Ride"] = 808.4, ["Neon"] = 2700.24, ["Neon|Ride"] = 2887.5, ["Neon|Fly|Ride"] = 2231.24, ["Mega|Fly|Ride"] = 8531.25}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 735.79}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 5906.25, ["Ride"] = 5906.25, ["Fly|Ride"] = 5381.25, ["Neon"] = 28875, ["Neon|Ride"] = 30968.81, ["Neon|Fly|Ride"] = 25932.51, ["Mega|Fly|Ride"] = 108052.06}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 257.25, ["Fly"] = 494.82, ["Ride"] = 360.91, ["Fly|Ride"] = 389.01, ["Neon"] = 1728.85, ["Neon|Fly|Ride"] = 2160.8, ["Mega"] = 6483.14, ["Mega|Fly|Ride"] = 6482.37}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 71.37, ["Ride"] = 144.37, ["Fly|Ride"] = 190.32, ["Neon"] = 1009.22, ["Neon|Ride"] = 647.25, ["Neon|Fly|Ride"] = 1050}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 17.99, ["Fly"] = 102.37, ["Ride"] = 43.01, ["Fly|Ride"] = 98.27, ["Neon"] = 243.13, ["Neon|Ride"] = 216.12, ["Neon|Fly|Ride"] = 322.02, ["Mega"] = 720.71, ["Mega|Ride"] = 864.44, ["Mega|Fly|Ride"] = 723.7}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 18.38, ["Fly"] = 32.82, ["Ride"] = 26.25, ["Fly|Ride"] = 49.72, ["Neon"] = 144.8, ["Neon|Ride"] = 327.97, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 1312.5, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 605.11}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 17.07, ["Fly"] = 129.68, ["Ride"] = 40.92, ["Fly|Ride"] = 109.15, ["Neon"] = 105, ["Neon|Ride"] = 124.66, ["Neon|Fly|Ride"] = 206.07, ["Mega"] = 645.91, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 729.75}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 5.16, ["Fly"] = 36.75, ["Ride"] = 19.68, ["Fly|Ride"] = 56.52, ["Neon"] = 26.25, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 142.51, ["Mega"] = 681.82, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 282.31}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 22.32, ["Ride"] = 51.18, ["Fly|Ride"] = 144.8, ["Neon"] = 115.5, ["Neon|Fly"] = 864.44, ["Neon|Ride"] = 164.51, ["Neon|Fly|Ride"] = 323.09, ["Mega"] = 532.91, ["Mega|Ride"] = 763.85, ["Mega|Fly|Ride"] = 864.32}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 514.5, ["Fly"] = 762.57, ["Ride"] = 621.32, ["Fly|Ride"] = 650.9, ["Neon"] = 1700.23, ["Neon|Ride"] = 2579.11, ["Neon|Fly|Ride"] = 1574.69, ["Mega"] = 9187.5, ["Mega|Fly|Ride"] = 5250}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.9, ["Fly"] = 19.69, ["Ride"] = 16.23, ["Fly|Ride"] = 35.63, ["Neon"] = 20.99, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 170.63, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 43.32, ["Fly"] = 112.32, ["Ride"] = 81.8, ["Fly|Ride"] = 131.25, ["Neon"] = 199.5, ["Neon|Fly"] = 430.71, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 254.63, ["Mega"] = 498.75, ["Mega|Fly"] = 864.44, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 590.52}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 748.13, ["Ride"] = 761.25, ["Fly|Ride"] = 839.99, ["Neon|Ride"] = 2737.73, ["Neon|Fly|Ride"] = 1569.74, ["Mega|Fly|Ride"] = 3752.34}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 41.62, ["Fly"] = 70.86, ["Ride"] = 42.83, ["Fly|Ride"] = 89.71, ["Neon"] = 280.88, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 257.15, ["Mega"] = 1228.31, ["Mega|Ride"] = 927.94, ["Mega|Fly|Ride"] = 885.93}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 328.12, ["Ride"] = 328.13, ["Fly|Ride"] = 341.25, ["Neon|Fly|Ride"] = 1531.69, ["Mega|Fly|Ride"] = 5042.81}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 248.07, ["Fly"] = 262.5, ["Ride"] = 249.38, ["Fly|Ride"] = 360.94, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 963.31, ["Mega"] = 5118.75, ["Mega|Fly|Ride"] = 5388.57}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 656.25, ["Ride"] = 737.63, ["Fly|Ride"] = 721.87, ["Neon"] = 3025.47, ["Neon|Ride"] = 3775.35, ["Neon|Fly|Ride"] = 2572.5, ["Mega|Fly|Ride"] = 9842.44}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 18.2, ["Ride"] = 36.44, ["Fly|Ride"] = 107.48, ["Neon"] = 65.63, ["Neon|Fly"] = 294.81, ["Neon|Ride"] = 118.12, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 354.38, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 451.5}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3542.44, ["Fly"] = 3590.9, ["Ride"] = 3411.19, ["Fly|Ride"] = 3136.88, ["Neon|Fly|Ride"] = 8898.75, ["Mega|Fly|Ride"] = 21510.57}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 131.25, ["Fly"] = 145.6, ["Ride"] = 147.41, ["Fly|Ride"] = 183.75, ["Neon"] = 550.97, ["Neon|Ride"] = 655.93, ["Neon|Fly|Ride"] = 590.63, ["Mega|Fly|Ride"] = 3492.25}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 3.6, ["Fly"] = 22.4, ["Ride"] = 19.69, ["Fly|Ride"] = 43.74, ["Neon"] = 22.05, ["Neon|Fly"] = 43.24, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 85.31, ["Mega"] = 252.86, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 294.23, ["Mega|Fly|Ride"] = 345.78}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.84, ["Ride"] = 25.9, ["Fly|Ride"] = 68.09, ["Neon"] = 27.46, ["Neon|Fly"] = 120.39, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 144.8, ["Mega"] = 188.03, ["Mega|Ride"] = 418.18, ["Mega|Fly|Ride"] = 514.56}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 52.5, ["Fly"] = 86.45, ["Ride"] = 48.57, ["Fly|Ride"] = 59.07, ["Neon|Ride"] = 410.61, ["Neon|Fly|Ride"] = 276.94, ["Mega|Fly|Ride"] = 1253.42}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 787.49, ["Fly"] = 1179.17, ["Ride"] = 774.38, ["Fly|Ride"] = 970.9, ["Neon"] = 4300.49, ["Neon|Ride"] = 11464.83, ["Neon|Fly|Ride"] = 4160.02}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 9187.5, ["Fly|Ride"] = 14587.05}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 21, ["Fly"] = 26.2, ["Ride"] = 26.8, ["Fly|Ride"] = 44.13, ["Neon"] = 172.9, ["Neon|Ride"] = 159.93, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 2520, ["Mega|Ride"] = 868.41, ["Mega|Fly|Ride"] = 811.12}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 16.23, ["Fly"] = 40.69, ["Ride"] = 27.41, ["Fly|Ride"] = 72.19, ["Neon"] = 103.58, ["Neon|Fly"] = 105, ["Neon|Ride"] = 92.85, ["Neon|Fly|Ride"] = 136.49, ["Mega"] = 682.45, ["Mega|Ride"] = 528.94, ["Mega|Fly|Ride"] = 501.37}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 110.25, ["Fly"] = 52.5, ["Ride"] = 110.92, ["Fly|Ride"] = 142.61, ["Neon"] = 485.63, ["Neon|Ride"] = 547.84, ["Neon|Fly|Ride"] = 472.4, ["Mega|Fly|Ride"] = 1597.92}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 223.02, ["Fly"] = 432.17, ["Ride"] = 239.55, ["Fly|Ride"] = 321.57, ["Neon"] = 1310.59, ["Neon|Ride"] = 934.76, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 10805.22, ["Mega|Ride"] = 4168.82, ["Mega|Fly|Ride"] = 3127.69}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.94, ["Ride"] = 32.44, ["Fly|Ride"] = 72.19, ["Neon"] = 23.61, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 64.31, ["Mega"] = 179.39, ["Mega|Fly"] = 240.97, ["Mega|Ride"] = 160.98, ["Mega|Fly|Ride"] = 352.26}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 177.19, ["Fly"] = 259.34, ["Ride"] = 233.63, ["Fly|Ride"] = 302.56, ["Neon"] = 590.63, ["Neon|Ride"] = 564.38, ["Neon|Fly|Ride"] = 720.63, ["Mega"] = 3603.55, ["Mega|Fly|Ride"] = 3889.89}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.59, ["Fly"] = 32.81, ["Ride"] = 19.48, ["Fly|Ride"] = 49.88, ["Neon"] = 21.62, ["Neon|Fly"] = 129.68, ["Neon|Ride"] = 43.23, ["Neon|Fly|Ride"] = 81.08, ["Mega"] = 211.79, ["Mega|Fly"] = 288.51, ["Mega|Ride"] = 219.19, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 389.01, ["Ride"] = 396.57, ["Fly|Ride"] = 367.4, ["Neon|Ride"] = 1436.25, ["Neon|Fly|Ride"] = 1246.88, ["Mega"] = 10803.94, ["Mega|Fly|Ride"] = 7982.91}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 14.28, ["Fly"] = 104.99, ["Ride"] = 29.34, ["Fly|Ride"] = 66.33, ["Neon"] = 91.88, ["Neon|Fly"] = 311.97, ["Neon|Ride"] = 144.8, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 576.94, ["Mega|Ride"] = 445.19, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Ride"] = 26.21, ["Neon"] = 11.82, ["Neon|Fly"] = 170.46, ["Neon|Ride"] = 51.17, ["Neon|Fly|Ride"] = 164.6, ["Mega"] = 91.87, ["Mega|Ride"] = 327.92, ["Mega|Fly|Ride"] = 216.12}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.83, ["Mega"] = 19.98, ["Mega|Ride"] = 133.88, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.82, ["Ride"] = 30.19, ["Fly|Ride"] = 86.62, ["Neon"] = 8.27, ["Neon|Ride"] = 43.08, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 74.69, ["Mega|Fly"] = 72.42, ["Mega|Ride"] = 86.45, ["Mega|Fly|Ride"] = 363.56}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 112.4, ["Fly"] = 212.63, ["Ride"] = 109.83, ["Fly|Ride"] = 196.54, ["Neon"] = 339.93, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1236.38}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 42.45, ["Ride"] = 16.41, ["Fly|Ride"] = 67.03, ["Neon"] = 5.25, ["Neon|Ride"] = 33.18, ["Neon|Fly|Ride"] = 70.77, ["Mega"] = 90.57, ["Mega|Ride"] = 165.38, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 13.11, ["Ride"] = 101.77, ["Neon"] = 82.68, ["Neon|Fly"] = 377.11, ["Neon|Ride"] = 288.51, ["Mega"] = 420, ["Mega|Fly|Ride"] = 733.68}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 144.08, ["Mega"] = 16.23, ["Mega|Ride"] = 48.04, ["Mega|Fly|Ride"] = 257.18}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 88.23, ["Ride"] = 16.15, ["Fly|Ride"] = 196.88, ["Neon"] = 2.1, ["Neon|Fly"] = 24.86, ["Neon|Ride"] = 15.35, ["Neon|Fly|Ride"] = 42.62, ["Mega"] = 12.15, ["Mega|Fly"] = 41.08, ["Mega|Ride"] = 22.03, ["Mega|Fly|Ride"] = 63.02}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 25.15, ["Ride"] = 15.73, ["Fly|Ride"] = 37.84, ["Neon"] = 2.49, ["Neon|Fly"] = 29.19, ["Neon|Ride"] = 17.29, ["Neon|Fly|Ride"] = 53.81, ["Mega"] = 19.69, ["Mega|Fly"] = 164.6, ["Mega|Ride"] = 43.23, ["Mega|Fly|Ride"] = 92.52}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Mega"] = 21.27, ["Mega|Fly|Ride"] = 244.21}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 117.94, ["Ride"] = 15.75, ["Fly|Ride"] = 45.4, ["Neon"] = 7.86, ["Neon|Fly"] = 100.92, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 39.16, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 43.32, ["Mega|Fly|Ride"] = 85.31}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Ride"] = 72.42, ["Neon"] = 3.05, ["Neon|Fly"] = 36.74, ["Neon|Ride"] = 84.67, ["Mega"] = 14.06, ["Mega|Ride"] = 105.9, ["Mega|Fly|Ride"] = 145.68}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 13.09, ["Neon"] = 56.44, ["Neon|Ride"] = 92.94, ["Neon|Fly|Ride"] = 184.28, ["Mega"] = 229.69, ["Mega|Ride"] = 242.71, ["Mega|Fly|Ride"] = 352.78}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 82.78, ["Neon"] = 2.1, ["Neon|Ride"] = 24.87, ["Neon|Fly|Ride"] = 205.31, ["Mega"] = 11.58, ["Mega|Fly"] = 149.86, ["Mega|Ride"] = 64.84, ["Mega|Fly|Ride"] = 65.63}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.6, ["Fly|Ride"] = 87.94, ["Neon"] = 22.82, ["Mega"] = 121.87, ["Mega|Fly"] = 315, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 26.24, ["Neon"] = 23.28, ["Neon|Ride"] = 65.63, ["Mega"] = 136.33, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Fly"] = 144.8, ["Ride"] = 32.82, ["Neon"] = 3.63, ["Neon|Ride"] = 27.97, ["Neon|Fly|Ride"] = 144.8, ["Mega"] = 19.04, ["Mega|Ride"] = 43.2, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 29.18, ["Ride"] = 15.41, ["Fly|Ride"] = 31.33, ["Neon"] = 2.1, ["Neon|Fly"] = 20.47, ["Neon|Ride"] = 15.67, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 15.75, ["Mega|Fly"] = 32.97, ["Mega|Ride"] = 21, ["Mega|Fly|Ride"] = 51.89}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 54.28, ["Fly|Ride"] = 118.12, ["Neon"] = 52.48, ["Neon|Ride"] = 144.8, ["Neon|Fly|Ride"] = 720.63, ["Mega"] = 144.38, ["Mega|Ride"] = 241.5, ["Mega|Fly|Ride"] = 432.23}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 44, ["Fly|Ride"] = 58.36, ["Neon"] = 5.25, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 29.19, ["Neon|Fly|Ride"] = 105, ["Mega"] = 22.32, ["Mega|Ride"] = 44.62, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 7.23, ["Neon"] = 20.98, ["Neon|Ride"] = 195.11, ["Mega"] = 78.75, ["Mega|Ride"] = 144.27, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 84.72, ["Ride"] = 34.53, ["Fly|Ride"] = 73.71, ["Neon"] = 66.85, ["Neon|Ride"] = 108.06, ["Neon|Fly|Ride"] = 129.2, ["Mega"] = 131.25, ["Mega|Ride"] = 164.6, ["Mega|Fly|Ride"] = 196.87}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 13.5, ["Ride"] = 15.21, ["Fly|Ride"] = 28.25, ["Neon"] = 2.1, ["Neon|Fly"] = 15.74, ["Neon|Ride"] = 15.36, ["Neon|Fly|Ride"] = 30.19, ["Mega"] = 15.22, ["Mega|Fly"] = 34.13, ["Mega|Ride"] = 23.34, ["Mega|Fly|Ride"] = 53.73}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 45.47, ["Ride"] = 27.44, ["Fly|Ride"] = 144.8, ["Neon"] = 14.44, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 129.72, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Ride"] = 144.79, ["Fly|Ride"] = 93.19, ["Neon"] = 82.31, ["Neon|Ride"] = 98.27, ["Neon|Fly|Ride"] = 172.9, ["Mega"] = 288.75, ["Mega|Ride"] = 303.58, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 58.36, ["Ride"] = 11.82, ["Fly|Ride"] = 43.23, ["Neon"] = 2.1, ["Neon|Fly"] = 21.62, ["Neon|Ride"] = 15.05, ["Neon|Fly|Ride"] = 52.36, ["Mega"] = 24.94, ["Mega|Fly"] = 35.65, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 180.46, ["Ride"] = 72.19, ["Neon"] = 10.26, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 51.98, ["Mega|Fly"] = 164.59, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 216.12}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 131.25, ["Neon"] = 6.87, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 43.23, ["Mega"] = 32.71, ["Mega|Ride"] = 114.55, ["Mega|Fly|Ride"] = 196.23}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Ride"] = 27.19, ["Fly|Ride"] = 48.54, ["Neon"] = 2.1, ["Neon|Ride"] = 35.27, ["Neon|Fly|Ride"] = 129.68, ["Mega"] = 14.1, ["Mega|Fly"] = 253.82, ["Mega|Ride"] = 50.78, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 23.79, ["Ride"] = 19.35, ["Fly|Ride"] = 55.46, ["Neon"] = 4.33, ["Neon|Fly"] = 58.36, ["Neon|Ride"] = 44.65, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 105.66, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 151.92}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 28.77, ["Neon"] = 3.89, ["Neon|Ride"] = 71.09, ["Mega"] = 47.88, ["Mega|Fly"] = 216.12, ["Mega|Ride"] = 117.35, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 28.62, ["Ride"] = 19.26, ["Fly|Ride"] = 37.91, ["Neon"] = 7.65, ["Neon|Fly"] = 76.18, ["Neon|Ride"] = 22.31, ["Neon|Fly|Ride"] = 52.48, ["Mega"] = 82.69, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 274.46}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 5.08, ["Ride"] = 72.42, ["Neon"] = 40.68, ["Neon|Fly"] = 188.88, ["Neon|Fly|Ride"] = 324.17, ["Mega"] = 110.25, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 648.25}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 26.02, ["Ride"] = 21.51, ["Fly|Ride"] = 50.79, ["Neon"] = 8.82, ["Neon|Fly"] = 72.42, ["Neon|Ride"] = 72.33, ["Neon|Fly|Ride"] = 66.33, ["Mega"] = 106.98, ["Mega|Fly"] = 420, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 144.37}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 4.33, ["Fly"] = 20.6, ["Ride"] = 18.25, ["Fly|Ride"] = 72.19, ["Neon"] = 19.24, ["Neon|Fly"] = 29.32, ["Neon|Ride"] = 22.43, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 157.5, ["Mega|Fly"] = 432.23, ["Mega|Ride"] = 123.2, ["Mega|Fly|Ride"] = 288.51}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.51, ["Fly"] = 114.54, ["Fly|Ride"] = 144.8, ["Neon"] = 32.44, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 257.28, ["Mega|Ride"] = 406.88}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 14.43, ["Ride"] = 131.25, ["Neon"] = 180.46, ["Neon|Ride"] = 211.79, ["Neon|Fly|Ride"] = 294.81, ["Mega|Ride"] = 760.37, ["Mega|Fly|Ride"] = 750.75}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.61, ["Neon"] = 57.31, ["Mega"] = 200.43, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 410.26}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 5.21, ["Ride"] = 51.19, ["Fly|Ride"] = 131.25, ["Neon"] = 52.5, ["Neon|Ride"] = 94.39, ["Neon|Fly|Ride"] = 202.08, ["Mega"] = 236.25, ["Mega|Ride"] = 334.14, ["Mega|Fly|Ride"] = 450.84}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 37.97, ["Mega"] = 20.77, ["Mega|Fly"] = 215.04, ["Mega|Ride"] = 50.79, ["Mega|Fly|Ride"] = 257.15}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 51.96}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 3.94, ["Fly"] = 41.76, ["Ride"] = 28.07, ["Fly|Ride"] = 54.22, ["Neon"] = 42, ["Neon|Fly"] = 188.03, ["Neon|Ride"] = 40.85, ["Neon|Fly|Ride"] = 90.55, ["Mega"] = 261.19, ["Mega|Ride"] = 208.69, ["Mega|Fly|Ride"] = 267.53}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 21.62, ["Neon"] = 2.63, ["Neon|Fly"] = 52.81, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 162.16, ["Mega"] = 32.82, ["Mega|Ride"] = 94.02, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 26.24, ["Fly|Ride"] = 86.45, ["Neon"] = 6.57, ["Neon|Ride"] = 32.99, ["Neon|Fly|Ride"] = 74.43, ["Mega"] = 31.47, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 134.01}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 48.03, ["Ride"] = 16.15, ["Fly|Ride"] = 48.11, ["Neon"] = 10.39, ["Neon|Ride"] = 24.08, ["Neon|Fly|Ride"] = 72.42, ["Mega"] = 272.46, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 229.7}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 6.82, ["Ride"] = 39.26, ["Neon"] = 56.44, ["Neon|Ride"] = 208.15, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 108.67, ["Mega|Ride"] = 352.54, ["Mega|Fly|Ride"] = 288.51}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 2.62, ["Neon|Ride"] = 47.24, ["Neon|Fly|Ride"] = 159.93, ["Mega"] = 17.74, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 56.43}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 28.11, ["Ride"] = 17.07, ["Fly|Ride"] = 144.12, ["Neon"] = 6.55, ["Neon|Fly"] = 115.21, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 98.27, ["Mega"] = 32.82, ["Mega|Fly"] = 164.9, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 20.48, ["Ride"] = 19.35, ["Fly|Ride"] = 53.8, ["Neon"] = 6.18, ["Neon|Fly"] = 37.85, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 64.78, ["Mega"] = 137.23, ["Mega|Fly"] = 144.8, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 137.25}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 5.25, ["Fly"] = 91.88, ["Ride"] = 183.75, ["Neon"] = 19.67, ["Neon|Ride"] = 38.92, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 120.75, ["Mega|Ride"] = 183.24, ["Mega|Fly|Ride"] = 302.18}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.04, ["Neon|Ride"] = 172.88, ["Neon|Fly|Ride"] = 202.08, ["Mega"] = 22.77, ["Mega|Fly"] = 74.1, ["Mega|Ride"] = 45.69, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 23.51, ["Neon"] = 3.84, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 25.8, ["Neon|Fly|Ride"] = 67.69, ["Mega"] = 21.44, ["Mega|Fly"] = 72.07, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 144.8}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 76.79, ["Neon"] = 2.63, ["Neon|Fly"] = 82.31, ["Mega"] = 39.38, ["Mega|Ride"] = 181.8}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 5.92, ["Neon|Fly|Ride"] = 420, ["Mega"] = 27.2, ["Mega|Ride"] = 292.69, ["Mega|Fly|Ride"] = 202.08}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.23, ["Ride"] = 19.04, ["Fly|Ride"] = 69.44, ["Neon"] = 6.35, ["Neon|Fly"] = 326.27, ["Neon|Ride"] = 21.94, ["Neon|Fly|Ride"] = 48.91, ["Mega"] = 31.5, ["Mega|Ride"] = 42.4, ["Mega|Fly|Ride"] = 112.87}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 7.85, ["Ride"] = 78.75, ["Neon"] = 115.5, ["Neon|Ride"] = 192.33, ["Mega"] = 391.13, ["Mega|Ride"] = 526.22, ["Mega|Fly|Ride"] = 647.25}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 58.36, ["Neon"] = 13.13, ["Neon|Ride"] = 157.5, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.42, ["Ride"] = 33.18, ["Fly|Ride"] = 183.67, ["Neon"] = 25.78, ["Neon|Ride"] = 144.67, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 313.35, ["Mega|Ride"] = 182.44, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 12.93, ["Fly|Ride"] = 25.58, ["Neon"] = 2.1, ["Neon|Fly"] = 15.75, ["Neon|Ride"] = 14.41, ["Neon|Fly|Ride"] = 26.24, ["Mega"] = 14.2, ["Mega|Fly"] = 23.24, ["Mega|Ride"] = 20.78, ["Mega|Fly|Ride"] = 47.25}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.63, ["Fly"] = 118.13, ["Ride"] = 60.53, ["Neon"] = 12.18, ["Neon|Fly"] = 72.42, ["Neon|Ride"] = 31.82, ["Neon|Fly|Ride"] = 720.71, ["Mega"] = 42, ["Mega|Ride"] = 118.13}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.39, ["Neon"] = 2.1, ["Neon|Fly"] = 32.36, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 89.71, ["Mega"] = 12.78, ["Mega|Fly"] = 144.8, ["Mega|Ride"] = 34.13, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.15, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 129.22, ["Mega"] = 39.38, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 367.49}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 223.13, ["Ride"] = 22.32, ["Fly|Ride"] = 48.9, ["Neon"] = 6.47, ["Neon|Fly"] = 64.83, ["Neon|Ride"] = 28.07, ["Neon|Fly|Ride"] = 81.87, ["Mega"] = 144.8, ["Mega|Ride"] = 130.74, ["Mega|Fly|Ride"] = 275.6}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 215.25, ["Ride"] = 252, ["Fly|Ride"] = 864.32, ["Neon|Ride"] = 813.75, ["Mega"] = 8643.15, ["Mega|Fly|Ride"] = 3541.96}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Neon|Fly"] = 58.17, ["Neon|Ride"] = 64.32, ["Mega"] = 65.63, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 655.93}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 10.5, ["Fly"] = 103.69, ["Ride"] = 39.79, ["Fly|Ride"] = 65.63, ["Neon"] = 22.31, ["Neon|Ride"] = 135.18, ["Neon|Fly|Ride"] = 172.9, ["Mega"] = 400.32, ["Mega|Ride"] = 418.18, ["Mega|Fly|Ride"] = 389.01}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 19.66, ["Ride"] = 14.44, ["Fly|Ride"] = 36.75, ["Neon"] = 8.66, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 48.41, ["Mega|Ride"] = 106.98, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 72.42, ["Ride"] = 18.38, ["Fly|Ride"] = 142.61, ["Neon"] = 8.66, ["Neon|Ride"] = 72.34, ["Neon|Fly|Ride"] = 115.63, ["Mega"] = 101.07, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 4.24, ["Fly"] = 20.45, ["Ride"] = 16.21, ["Fly|Ride"] = 39.36, ["Neon"] = 32.82, ["Neon|Fly"] = 101.25, ["Neon|Ride"] = 34.48, ["Neon|Fly|Ride"] = 86.52, ["Mega"] = 144.38, ["Mega|Ride"] = 960.48, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.94, ["Ride"] = 26.25, ["Fly|Ride"] = 259.91, ["Neon"] = 45.39, ["Neon|Fly|Ride"] = 432.23, ["Mega"] = 169.43, ["Mega|Ride"] = 389.01, ["Mega|Fly|Ride"] = 347.82}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 22.3, ["Ride"] = 19.46, ["Fly|Ride"] = 38.79, ["Neon"] = 43.22, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 77.44, ["Mega|Ride"] = 374.95, ["Mega|Fly|Ride"] = 262.44}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 68.25, ["Fly"] = 164.6, ["Ride"] = 85.2, ["Fly|Ride"] = 142.86, ["Neon"] = 333.38, ["Neon|Fly"] = 450.19, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 365.57, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 215.04, ["Fly"] = 288.51, ["Ride"] = 223.12, ["Fly|Ride"] = 287.44, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1296.64, ["Mega"] = 12964.71, ["Mega|Fly|Ride"] = 3746.18}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 58.35, ["Fly"] = 101.58, ["Ride"] = 69.57, ["Fly|Ride"] = 112.47, ["Neon"] = 352.91, ["Neon|Fly"] = 366.32, ["Neon|Ride"] = 311.07, ["Neon|Fly|Ride"] = 315, ["Mega"] = 2018.43, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 3.64, ["Fly"] = 288.51, ["Ride"] = 26.17, ["Neon"] = 25.93, ["Neon|Fly"] = 47.57, ["Neon|Ride"] = 131.25, ["Mega"] = 287.44, ["Mega|Ride"] = 209.34, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 16.23, ["Fly"] = 79.97, ["Ride"] = 32.81, ["Fly|Ride"] = 105, ["Neon"] = 65.63, ["Neon|Ride"] = 86.45, ["Neon|Fly|Ride"] = 202.19, ["Mega"] = 314.98, ["Mega|Ride"] = 378.41, ["Mega|Fly|Ride"] = 379.2}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 39.31, ["Ride"] = 17.67, ["Fly|Ride"] = 98.27, ["Neon"] = 3.15, ["Neon|Fly"] = 57.46, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 53.48, ["Mega"] = 42.96, ["Mega|Fly"] = 154.88, ["Mega|Ride"] = 86.63, ["Mega|Fly|Ride"] = 558.89}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 11.82, ["Fly"] = 39.38, ["Ride"] = 34.12, ["Fly|Ride"] = 82.14, ["Neon"] = 124.69, ["Neon|Fly"] = 288.51, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 1837.5, ["Mega|Ride"] = 648.33, ["Mega|Fly|Ride"] = 619.07}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 16.1, ["Fly|Ride"] = 43.44, ["Neon"] = 18.38, ["Neon|Fly"] = 52.84, ["Neon|Ride"] = 29.18, ["Neon|Fly|Ride"] = 98.27, ["Mega"] = 144.38, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 229.69}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.63, ["Ride"] = 23.63, ["Fly|Ride"] = 124.27, ["Neon"] = 39.51, ["Neon|Ride"] = 40.73, ["Mega"] = 207.37, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 337.84}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 27.99, ["Ride"] = 19.39, ["Neon"] = 2.1, ["Neon|Ride"] = 17.24, ["Neon|Fly|Ride"] = 58.24, ["Mega"] = 14.44, ["Mega|Ride"] = 30.33, ["Mega|Fly|Ride"] = 72.19}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 18.89, ["Ride"] = 19.14, ["Fly|Ride"] = 44.63, ["Neon"] = 12.99, ["Neon|Fly"] = 108.06, ["Neon|Ride"] = 36.74, ["Neon|Fly|Ride"] = 146.99, ["Mega"] = 78.74, ["Mega|Ride"] = 114.55, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.94, ["Fly"] = 72.42, ["Ride"] = 22.29, ["Fly|Ride"] = 83.83, ["Neon"] = 17.07, ["Neon|Fly"] = 98.27, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 125.36, ["Mega"] = 144.38, ["Mega|Ride"] = 164.6, ["Mega|Fly|Ride"] = 267.99}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 108.11, ["Fly"] = 149.63, ["Ride"] = 154.87, ["Fly|Ride"] = 194.17, ["Neon"] = 421.31, ["Neon|Ride"] = 472.49, ["Neon|Fly|Ride"] = 509.24, ["Mega"] = 2456.3, ["Mega|Fly|Ride"] = 1975.32}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 10.38, ["Fly"] = 115.63, ["Ride"] = 52.5, ["Fly|Ride"] = 131.25, ["Neon"] = 49.88, ["Neon|Ride"] = 89.25, ["Neon|Fly|Ride"] = 215.25, ["Mega"] = 326.82, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 430.06}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 3.68, ["Fly"] = 45.94, ["Ride"] = 16, ["Fly|Ride"] = 51.48, ["Neon"] = 22.09, ["Neon|Ride"] = 62.89, ["Neon|Fly|Ride"] = 90.99, ["Mega"] = 274.46, ["Mega|Fly|Ride"] = 328.12}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 22.89, ["Ride"] = 64.32, ["Fly|Ride"] = 170.63, ["Neon"] = 99.3, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 488.87, ["Mega|Fly"] = 864.32, ["Mega|Ride"] = 531.57, ["Mega|Fly|Ride"] = 690.47}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 6.28}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.59, ["Fly"] = 31.5, ["Ride"] = 32.82, ["Fly|Ride"] = 113.02, ["Neon"] = 72.19, ["Neon|Ride"] = 144.09, ["Neon|Fly|Ride"] = 233.41, ["Mega"] = 648.33, ["Mega|Ride"] = 633.2, ["Mega|Fly|Ride"] = 501.93}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 18.37, ["Fly"] = 25.73, ["Ride"] = 31.5, ["Fly|Ride"] = 49.88, ["Neon"] = 406.31, ["Neon|Fly"] = 21607.84, ["Neon|Ride"] = 131.44, ["Neon|Fly|Ride"] = 156.75, ["Mega"] = 1394.96, ["Mega|Fly|Ride"] = 579.79}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 35.6, ["Neon"] = 3.03, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 137.25, ["Mega"] = 26.25, ["Mega|Fly"] = 188.03, ["Mega|Ride"] = 88.33, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 8.31, ["Fly"] = 26.25, ["Ride"] = 24.59, ["Fly|Ride"] = 91.88, ["Neon"] = 64.86, ["Mega"] = 287.43, ["Mega|Fly"] = 410.26, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 409.54}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 28.97, ["Ride"] = 19.46, ["Fly|Ride"] = 43.29, ["Neon"] = 13.27, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 30.86, ["Neon|Fly|Ride"] = 70.63, ["Mega"] = 153.45, ["Mega|Ride"] = 140.01, ["Mega|Fly|Ride"] = 234.93}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Fly|Ride"] = 118.13, ["Neon"] = 4.07, ["Neon|Ride"] = 41.77, ["Mega"] = 141.2, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 27.56, ["Fly"] = 105, ["Ride"] = 64.32, ["Fly|Ride"] = 144.65, ["Neon"] = 140.43, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 608.34, ["Mega"] = 850.38, ["Mega|Ride"] = 689.07, ["Mega|Fly|Ride"] = 769.02}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 5.44, ["Ride"] = 49.14, ["Fly|Ride"] = 120.39, ["Neon"] = 91.88, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 183.75, ["Mega|Ride"] = 374.95}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 6.55, ["Fly"] = 23.79, ["Ride"] = 22.31, ["Fly|Ride"] = 65.61, ["Neon"] = 13.13, ["Neon|Fly"] = 86.45, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 118.13, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 204.05}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 57.17, ["Fly"] = 145.01, ["Ride"] = 72.19, ["Neon"] = 347.04, ["Neon|Ride"] = 387.92, ["Neon|Fly|Ride"] = 675.29, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 1589.42}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 7.88, ["Fly"] = 48.06, ["Ride"] = 22.19, ["Fly|Ride"] = 52.5, ["Neon"] = 38.07, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 114.19, ["Mega"] = 221.61, ["Mega|Fly"] = 368.45, ["Mega|Ride"] = 228.74, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 81.38, ["Fly"] = 147.41, ["Ride"] = 131.25, ["Neon"] = 236.24, ["Neon|Ride"] = 279.35, ["Neon|Fly|Ride"] = 432.17, ["Mega"] = 1196.14, ["Mega|Ride"] = 980.94, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 19.69, ["Ride"] = 69.17, ["Fly|Ride"] = 142.93, ["Neon"] = 67.54, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 210, ["Mega"] = 354.38, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 4.09, ["Fly"] = 65.63, ["Ride"] = 26.25, ["Fly|Ride"] = 72.42, ["Neon"] = 188.03, ["Neon|Ride"] = 156, ["Neon|Fly|Ride"] = 144.8, ["Mega"] = 648.33, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 539.19}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 15.75, ["Fly"] = 78.75, ["Ride"] = 55.12, ["Fly|Ride"] = 216.12, ["Neon"] = 76.13, ["Neon|Ride"] = 115.63, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 432.23, ["Mega|Ride"] = 387.85, ["Mega|Fly|Ride"] = 432.91}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 8.64, ["Ride"] = 25.78, ["Fly|Ride"] = 106.98, ["Neon"] = 53, ["Neon|Ride"] = 72.49, ["Neon|Fly|Ride"] = 161.68, ["Mega"] = 216.57, ["Mega|Ride"] = 246.75, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 196.88, ["Mega"] = 17.07}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 7.42, ["Ride"] = 136.5, ["Fly|Ride"] = 325.89, ["Neon"] = 48.47, ["Neon|Ride"] = 291.27, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 223.88, ["Mega|Ride"] = 358.32, ["Mega|Fly|Ride"] = 1031.91}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 6.57, ["Fly"] = 128.59, ["Ride"] = 29.19, ["Neon"] = 27.44, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 255.29, ["Mega|Ride"] = 168, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 3.94, ["Ride"] = 32.81, ["Neon"] = 16.46, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 288.51, ["Mega"] = 187.69, ["Mega|Ride"] = 288.51, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 538.13, ["Fly"] = 571.87, ["Ride"] = 551.25, ["Fly|Ride"] = 582.74, ["Neon|Ride"] = 1771.88, ["Neon|Fly|Ride"] = 1522.5, ["Mega|Fly|Ride"] = 4830}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 5.24, ["Fly"] = 45.47, ["Ride"] = 23.68, ["Fly|Ride"] = 65.63, ["Neon"] = 50.79, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 342.66, ["Mega"] = 202.08, ["Mega|Ride"] = 377.11, ["Mega|Fly|Ride"] = 360.91}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 8.73, ["Fly"] = 66.94, ["Ride"] = 20.79, ["Fly|Ride"] = 56.35, ["Neon"] = 101.58, ["Neon|Fly"] = 315, ["Neon|Ride"] = 81.48, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 331.88, ["Mega|Ride"] = 396.57, ["Mega|Fly|Ride"] = 427.9}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 6.25, ["Fly"] = 24.93, ["Ride"] = 28.11, ["Fly|Ride"] = 50.99, ["Neon"] = 29.19, ["Neon|Ride"] = 32.3, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 198.19}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 58.08, ["Ride"] = 23.61, ["Fly|Ride"] = 78.75, ["Neon"] = 9.44, ["Neon|Fly"] = 58.7, ["Neon|Ride"] = 38.97, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 70.27, ["Mega|Ride"] = 99.79, ["Mega|Fly|Ride"] = 182.42}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 26.23, ["Ride"] = 38.98, ["Fly|Ride"] = 52.5, ["Neon"] = 3.02, ["Neon|Ride"] = 32.33, ["Neon|Fly|Ride"] = 104.98, ["Mega"] = 21.39, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1573.69}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 6, ["Ride"] = 58.36, ["Fly|Ride"] = 118.13, ["Neon"] = 76.59, ["Neon|Ride"] = 98.26, ["Neon|Fly|Ride"] = 362.36, ["Mega"] = 315, ["Mega|Ride"] = 864.32, ["Mega|Fly|Ride"] = 550.6}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 19.46, ["Neon"] = 5.19, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 1009.22, ["Mega"] = 72.42, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 183.74}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 24.59, ["Fly"] = 335.14, ["Ride"] = 105.46, ["Fly|Ride"] = 144.8, ["Neon|Ride"] = 93.19, ["Neon|Fly|Ride"] = 236.15, ["Mega"] = 236.25, ["Mega|Ride"] = 389.01, ["Mega|Fly|Ride"] = 485.17}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 349.13, ["Fly"] = 533.1, ["Ride"] = 432.86, ["Fly|Ride"] = 498.75, ["Neon|Ride"] = 1712.24, ["Neon|Fly|Ride"] = 1365, ["Mega"] = 8103.92, ["Mega|Fly|Ride"] = 6357.75}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 7.07, ["Fly"] = 196.88, ["Ride"] = 43.23, ["Neon"] = 31.5, ["Neon|Ride"] = 72.44, ["Neon|Fly|Ride"] = 187.69, ["Mega"] = 353.35, ["Mega|Ride"] = 362.77, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Fly|Ride"] = 118.11, ["Neon"] = 2.88, ["Neon|Ride"] = 21.62, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 35.4, ["Mega|Fly"] = 115.63, ["Mega|Ride"] = 70.66, ["Mega|Fly|Ride"] = 158.12}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 56.26, ["Neon"] = 3.88, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 144.9, ["Mega"] = 29.3, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 172.9}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 43.22, ["Fly"] = 115.64, ["Ride"] = 88.61, ["Fly|Ride"] = 124.69, ["Neon"] = 720.63, ["Neon|Ride"] = 231.25, ["Mega"] = 756.37, ["Mega|Ride"] = 663.46, ["Mega|Fly|Ride"] = 717.48}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 8.39, ["Ride"] = 32.82, ["Neon"] = 39.38, ["Neon|Ride"] = 271.23, ["Neon|Fly|Ride"] = 864.44, ["Mega"] = 1296.64, ["Mega|Ride"] = 485.63, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 7.7, ["Ride"] = 76.11, ["Neon"] = 120.75, ["Neon|Ride"] = 200.82, ["Mega"] = 729.62, ["Mega|Ride"] = 648.33, ["Mega|Fly|Ride"] = 1296.49}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 23.49, ["Ride"] = 56.37, ["Fly|Ride"] = 236.25, ["Neon"] = 131.25, ["Neon|Ride"] = 181.13, ["Neon|Fly|Ride"] = 241.5, ["Mega"] = 1680, ["Mega|Ride"] = 1728.64, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 420, ["Ride"] = 393.75, ["Fly|Ride"] = 681.72, ["Neon"] = 1069.69, ["Neon|Ride"] = 1478.18, ["Neon|Fly|Ride"] = 1224.57, ["Mega|Fly|Ride"] = 2756.25}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 14.32, ["Ride"] = 28.25, ["Fly|Ride"] = 230.11, ["Neon"] = 58.36, ["Neon|Ride"] = 194.52, ["Neon|Fly|Ride"] = 287.55, ["Mega|Ride"] = 547.98, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 5.1, ["Ride"] = 27.72, ["Fly|Ride"] = 127.32, ["Neon"] = 32.82, ["Neon|Ride"] = 105, ["Mega"] = 170.63, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 45.94, ["Ride"] = 186.38, ["Neon"] = 229.08, ["Neon|Ride"] = 221.82, ["Neon|Fly|Ride"] = 623.53, ["Mega"] = 511.49, ["Mega|Ride"] = 472.49, ["Mega|Fly|Ride"] = 717.29}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Ride"] = 72.19, ["Fly|Ride"] = 144.8, ["Neon"] = 7.34, ["Neon|Fly"] = 86.45, ["Neon|Ride"] = 82.31, ["Neon|Fly|Ride"] = 144.8, ["Mega"] = 49.72, ["Mega|Fly"] = 105, ["Mega|Ride"] = 133.88, ["Mega|Fly|Ride"] = 288.48}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 38.92, ["Ride"] = 85.32, ["Fly|Ride"] = 213.73, ["Neon"] = 262.48, ["Neon|Ride"] = 374.95, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1566.76, ["Mega|Ride"] = 1152.41, ["Mega|Fly|Ride"] = 1621.35}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 58.36, ["Ride"] = 28.97, ["Neon"] = 11.82, ["Neon|Fly"] = 188.03, ["Neon|Ride"] = 72.42, ["Neon|Fly|Ride"] = 111.55, ["Mega"] = 103.69, ["Mega|Ride"] = 95.7, ["Mega|Fly|Ride"] = 171.82}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 80.07, ["Ride"] = 17.81, ["Fly|Ride"] = 71.15, ["Neon"] = 5.16, ["Neon|Ride"] = 37.84, ["Neon|Fly|Ride"] = 144.79, ["Mega"] = 56.43, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 76.33, ["Mega|Fly|Ride"] = 129.84}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Fly|Ride"] = 131.44, ["Neon"] = 12.99, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 151.08, ["Mega"] = 95.82, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 271.48}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 72.02, ["Fly"] = 105, ["Ride"] = 78.71, ["Fly|Ride"] = 164.6, ["Neon"] = 367.5, ["Neon|Ride"] = 366.85, ["Neon|Fly|Ride"] = 432.23, ["Mega|Ride"] = 1136.72, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 2.63, ["Neon"] = 26.24, ["Neon|Fly"] = 350.44, ["Mega"] = 54.85, ["Mega|Fly"] = 288.51, ["Mega|Ride"] = 265.83, ["Mega|Fly|Ride"] = 347.82}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 29.19, ["Ride"] = 26.96, ["Fly|Ride"] = 131.25, ["Neon"] = 5.25, ["Neon|Ride"] = 140.34, ["Mega"] = 52.5, ["Mega|Fly"] = 210, ["Mega|Ride"] = 97.13, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.2, ["Fly"] = 86.45, ["Ride"] = 32.82, ["Fly|Ride"] = 98.44, ["Neon"] = 32.82, ["Neon|Fly|Ride"] = 164.6, ["Mega"] = 427.23, ["Mega|Ride"] = 358.75, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 7.49, ["Fly"] = 78.75, ["Ride"] = 48.05, ["Fly|Ride"] = 63, ["Neon"] = 34.13, ["Neon|Ride"] = 68.23, ["Neon|Fly|Ride"] = 105, ["Mega"] = 181.13, ["Mega|Fly|Ride"] = 540.28}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 71.61, ["Neon"] = 4.19, ["Neon|Ride"] = 78.75, ["Mega"] = 72.19, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 294.81}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.47, ["Fly|Ride"] = 62.86, ["Neon"] = 4.87, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 27.98, ["Neon|Fly|Ride"] = 106.67, ["Mega"] = 43.23, ["Mega|Ride"] = 99.42, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.66, ["Fly"] = 27.51, ["Ride"] = 23.56, ["Fly|Ride"] = 57.53, ["Neon"] = 14.43, ["Neon|Fly"] = 102.64, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 94.5, ["Mega|Ride"] = 241.28, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 34.12, ["Fly"] = 72.42, ["Ride"] = 65.63, ["Fly|Ride"] = 60.38, ["Neon"] = 144.38, ["Neon|Ride"] = 244.44, ["Neon|Fly|Ride"] = 280.94, ["Mega"] = 498.75, ["Mega|Fly"] = 720.71, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 626.72}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 61.68, ["Ride"] = 94.02, ["Fly|Ride"] = 131.25, ["Neon"] = 374.07, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 378.19, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 1638.55, ["Mega|Ride"] = 1736.81, ["Mega|Fly|Ride"] = 1557.95}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Fly"] = 29.19, ["Ride"] = 19.56, ["Neon"] = 5.25, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 144.8, ["Mega"] = 32.7, ["Mega|Fly"] = 672, ["Mega|Ride"] = 81.05}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 16.22, ["Ride"] = 13.96, ["Fly|Ride"] = 32.82, ["Neon"] = 4.94, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 22.23, ["Neon|Fly|Ride"] = 81.05, ["Mega"] = 38.72, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 49.87, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 3.3, ["Fly"] = 183.75, ["Ride"] = 38.03, ["Neon"] = 40.69, ["Neon|Ride"] = 160.12, ["Neon|Fly|Ride"] = 144.8, ["Mega"] = 553.24, ["Mega|Ride"] = 275.62, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 354.27, ["Ride"] = 655.93, ["Fly|Ride"] = 584.07, ["Neon"] = 4322.1, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 6163.5}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 43.23, ["Fly"] = 61.69, ["Ride"] = 61.59, ["Fly|Ride"] = 124.77, ["Neon"] = 249.37, ["Neon|Ride"] = 186.38, ["Neon|Fly|Ride"] = 258.05, ["Mega"] = 721.88, ["Mega|Ride"] = 842.72, ["Mega|Fly|Ride"] = 919.53}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 24.93, ["Fly|Ride"] = 288.48, ["Neon"] = 8.4, ["Neon|Ride"] = 55, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 101.58, ["Mega|Ride"] = 142.86, ["Mega|Fly|Ride"] = 263.67}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 105, ["Ride"] = 62.99, ["Fly|Ride"] = 261.98, ["Neon"] = 36.71, ["Mega"] = 189}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 35.44, ["Fly"] = 168.91, ["Ride"] = 46.25, ["Fly|Ride"] = 62.69, ["Neon"] = 194.25, ["Neon|Ride"] = 261.19, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 2592.96, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 720.71}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 104.92, ["Ride"] = 144.15, ["Fly|Ride"] = 190.32, ["Neon"] = 427.53, ["Neon|Fly"] = 1152.93, ["Neon|Ride"] = 540.28, ["Neon|Fly|Ride"] = 446.25, ["Mega"] = 3170.27, ["Mega|Fly|Ride"] = 1781.85}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 225.7, ["Ride"] = 297.94, ["Fly|Ride"] = 367.49, ["Neon"] = 967.09, ["Neon|Ride"] = 800.63, ["Neon|Fly|Ride"] = 1035.57, ["Mega|Fly|Ride"] = 2867.82}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 11.24, ["Ride"] = 56.44, ["Fly|Ride"] = 246.91, ["Neon"] = 85.05, ["Neon|Fly"] = 275.55, ["Neon|Ride"] = 99.49, ["Neon|Fly|Ride"] = 188.69, ["Mega"] = 328.13, ["Mega|Ride"] = 380.61, ["Mega|Fly|Ride"] = 517.65}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 29.09, ["Ride"] = 19.85, ["Fly|Ride"] = 39.37, ["Neon"] = 7.18, ["Neon|Ride"] = 29.19, ["Neon|Fly|Ride"] = 86.52, ["Mega"] = 78.65, ["Mega|Ride"] = 111.57, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 4.15, ["Fly"] = 39.37, ["Ride"] = 20.14, ["Fly|Ride"] = 63, ["Neon"] = 34.8, ["Neon|Fly"] = 137.25, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 95.04, ["Mega"] = 300.41, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 230.99}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 301.88, ["Ride"] = 328.11, ["Fly|Ride"] = 576.03, ["Neon"] = 1562.54, ["Neon|Fly|Ride"] = 1944.72, ["Mega"] = 10805.22, ["Mega|Fly|Ride"] = 6168.75}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 36.75, ["Neon"] = 5.41, ["Neon|Ride"] = 140.83, ["Mega"] = 35.44, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 318.94}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 5.16, ["Ride"] = 19.67, ["Fly|Ride"] = 43.14, ["Neon"] = 27.56, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 82.79, ["Mega"] = 267.99, ["Mega|Fly"] = 263.67, ["Mega|Ride"] = 172.9, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 14.32, ["Fly"] = 6562.5, ["Ride"] = 53.17, ["Fly|Ride"] = 105, ["Neon"] = 98.44, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 196.68, ["Mega"] = 485.63, ["Mega|Ride"] = 716.4, ["Mega|Fly|Ride"] = 635.07}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 137.82, ["Fly"] = 157.5, ["Ride"] = 135.19, ["Fly|Ride"] = 170.63, ["Neon"] = 648.33, ["Neon|Ride"] = 864.44, ["Neon|Fly|Ride"] = 589.53, ["Mega|Fly|Ride"] = 2878.52}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 19.29, ["Fly"] = 39.37, ["Ride"] = 28.32, ["Fly|Ride"] = 52.5, ["Neon"] = 106.3, ["Neon|Ride"] = 102.38, ["Neon|Fly|Ride"] = 138.5, ["Mega"] = 504.62, ["Mega|Ride"] = 435.75, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 62.54, ["Neon"] = 3.71, ["Mega"] = 25.95, ["Mega|Ride"] = 172.29, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 18.38, ["Fly|Ride"] = 86.16, ["Neon"] = 3.15, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 28.11, ["Neon|Fly|Ride"] = 78.73, ["Mega"] = 42.78, ["Mega|Fly"] = 101.58, ["Mega|Ride"] = 43.32, ["Mega|Fly|Ride"] = 157.77}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 16.23, ["Fly"] = 101.58, ["Ride"] = 97.46, ["Fly|Ride"] = 209.02, ["Neon"] = 42, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 288.51, ["Mega"] = 157.5, ["Mega|Ride"] = 235.79, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1238.9, ["Fly"] = 1432.78, ["Ride"] = 1229.62, ["Fly|Ride"] = 1406.76, ["Neon"] = 4466.89, ["Neon|Ride"] = 4322.1, ["Neon|Fly|Ride"] = 4017.24, ["Mega|Fly|Ride"] = 11883.38}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 420, ["Ride"] = 431.82, ["Fly|Ride"] = 549.11, ["Neon"] = 1585.15, ["Neon|Ride"] = 1443.74, ["Neon|Fly|Ride"] = 1573.69, ["Mega"] = 15125.51, ["Mega|Fly|Ride"] = 6396.69}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 311.06, ["Ride"] = 338.63, ["Fly|Ride"] = 380.63, ["Neon"] = 656.25, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 734.98, ["Mega|Ride"] = 3603.55, ["Mega|Fly|Ride"] = 2916.34}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 236.15, ["Fly"] = 324.19, ["Ride"] = 287.34, ["Fly|Ride"] = 364.88, ["Neon"] = 682.5, ["Neon|Ride"] = 860.11, ["Neon|Fly|Ride"] = 707.43, ["Mega|Ride"] = 3084.38, ["Mega|Fly|Ride"] = 3556.01}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 18.37, ["Fly|Ride"] = 52.5, ["Neon"] = 5.24, ["Neon|Ride"] = 34.9, ["Neon|Fly|Ride"] = 107.68, ["Mega"] = 57.17, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 262.5, ["Fly"] = 1441.42, ["Ride"] = 275.63, ["Fly|Ride"] = 577.5, ["Neon"] = 1312.5, ["Neon|Ride"] = 1509.38, ["Neon|Fly|Ride"] = 2018.43, ["Mega"] = 21896.32, ["Mega|Ride"] = 6195.72, ["Mega|Fly|Ride"] = 5618.72}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 8.81, ["Fly"] = 183.74, ["Neon"] = 39.38, ["Neon|Fly|Ride"] = 288.51, ["Mega"] = 234.94, ["Mega|Ride"] = 245.26}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 23.57, ["Ride"] = 16, ["Fly|Ride"] = 37.43, ["Neon"] = 9.18, ["Neon|Ride"] = 54.05, ["Neon|Fly|Ride"] = 115.5, ["Mega"] = 129.68, ["Mega|Ride"] = 192.31, ["Mega|Fly|Ride"] = 162.96}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Mega"] = 21.31, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 177.62}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 79.95, ["Ride"] = 131.25, ["Fly|Ride"] = 144.8, ["Neon"] = 245.44, ["Neon|Ride"] = 359.73, ["Mega"] = 1050, ["Mega|Ride"] = 733.69, ["Mega|Fly|Ride"] = 863.35}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.36, ["Fly"] = 8189, ["Ride"] = 19.04, ["Fly|Ride"] = 68.25, ["Neon"] = 31.91, ["Mega"] = 302.56, ["Mega|Ride"] = 306.65, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Fly"] = 72.42, ["Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Ride"] = 57.73, ["Neon|Fly|Ride"] = 141.93, ["Mega"] = 20.36, ["Mega|Ride"] = 61.51, ["Mega|Fly|Ride"] = 140.03}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 8.91, ["Fly"] = 131.04, ["Ride"] = 66.94, ["Fly|Ride"] = 91.35, ["Neon"] = 42, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 177.17, ["Mega"] = 221.81, ["Mega|Ride"] = 265.84, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 6.45, ["Fly"] = 32.43, ["Ride"] = 18.36, ["Fly|Ride"] = 54.92, ["Neon"] = 38.07, ["Neon|Fly"] = 819.29, ["Neon|Ride"] = 64.86, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 238.85, ["Mega|Ride"] = 216.12, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 10.78, ["Ride"] = 43.23, ["Fly|Ride"] = 42, ["Neon"] = 68.92, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 524.99, ["Mega|Ride"] = 557.66}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 3.68, ["Fly"] = 21, ["Ride"] = 24.45, ["Neon"] = 70.88, ["Neon|Ride"] = 214.55, ["Mega"] = 429.19, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 560.81}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 72.35, ["Ride"] = 16.54, ["Fly|Ride"] = 45.02, ["Neon"] = 5.24, ["Neon|Fly"] = 29.19, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 129.68, ["Mega"] = 41.63, ["Mega|Ride"] = 147.41, ["Mega|Fly|Ride"] = 245.67}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 164.07, ["Fly"] = 199.5, ["Ride"] = 196.86, ["Fly|Ride"] = 215.04, ["Neon"] = 689.07, ["Neon|Ride"] = 2700.99, ["Neon|Fly|Ride"] = 1040.57, ["Mega"] = 8643.15, ["Mega|Fly|Ride"] = 4754.31}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 25.94, ["Ride"] = 15.75, ["Fly|Ride"] = 36.75, ["Neon"] = 3.14, ["Neon|Fly"] = 36.86, ["Neon|Ride"] = 20.78, ["Neon|Fly|Ride"] = 56.35, ["Mega"] = 36.74, ["Mega|Ride"] = 43.36, ["Mega|Fly|Ride"] = 120.75}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 15.49, ["Ride"] = 47.16, ["Fly|Ride"] = 231.25, ["Neon"] = 105.68, ["Neon|Ride"] = 138.33, ["Neon|Fly|Ride"] = 323.09, ["Mega"] = 393.75, ["Mega|Ride"] = 309.75, ["Mega|Fly|Ride"] = 391.12}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 32.79, ["Ride"] = 78.09, ["Neon"] = 249.61, ["Neon|Ride"] = 355.69, ["Neon|Fly|Ride"] = 466.83, ["Mega"] = 780.13, ["Mega|Fly|Ride"] = 944.99}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 182.23, ["Fly"] = 262.49, ["Ride"] = 233.63, ["Fly|Ride"] = 259.87, ["Neon"] = 620.82, ["Neon|Fly"] = 1638.55, ["Neon|Ride"] = 711.37, ["Neon|Fly|Ride"] = 733.69, ["Mega"] = 3603.55, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 19.88, ["Fly"] = 164.6, ["Ride"] = 164.6, ["Neon"] = 144.8, ["Neon|Ride"] = 142.43, ["Mega"] = 287.44, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 410.61}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 72.42, ["Ride"] = 49.14, ["Fly|Ride"] = 72.42, ["Neon"] = 202.08, ["Neon|Fly"] = 164.6, ["Neon|Fly|Ride"] = 288.74, ["Mega"] = 1728.85, ["Mega|Ride"] = 1441.42, ["Mega|Fly|Ride"] = 864.32}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 990.93, ["Ride"] = 1010.63, ["Fly|Ride"] = 1128.74, ["Neon"] = 5118.75, ["Neon|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 4200, ["Mega|Fly|Ride"] = 17828.61}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 10.82, ["Fly"] = 22.32, ["Ride"] = 19.48, ["Fly|Ride"] = 45.94, ["Neon"] = 33.11, ["Neon|Fly"] = 78.83, ["Neon|Ride"] = 86.45, ["Neon|Fly|Ride"] = 202.13, ["Mega"] = 272.3, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 347.31}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 4.95, ["Fly"] = 51.19, ["Ride"] = 41.15, ["Neon"] = 36.75, ["Neon|Ride"] = 72.42, ["Mega"] = 262.5, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 241.5, ["Mega|Fly|Ride"] = 341.23}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 86.45, ["Ride"] = 26.25, ["Fly|Ride"] = 895.18, ["Neon"] = 9.17, ["Neon|Ride"] = 36.11, ["Neon|Fly|Ride"] = 196.68, ["Mega"] = 91.88, ["Mega|Ride"] = 360.91, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 13.13, ["Ride"] = 47.24, ["Fly|Ride"] = 104.35, ["Neon"] = 78.75, ["Neon|Ride"] = 107.63, ["Neon|Fly|Ride"] = 209.43, ["Mega"] = 446.25, ["Mega|Ride"] = 410.8, ["Mega|Fly|Ride"] = 471.34}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 5.07, ["Fly"] = 28.54, ["Ride"] = 19.45, ["Fly|Ride"] = 40.69, ["Neon"] = 19.28, ["Neon|Fly"] = 54.05, ["Neon|Ride"] = 34.59, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 82.31, ["Mega|Fly"] = 280.98, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 5.24, ["Fly"] = 32.75, ["Ride"] = 32.82, ["Fly|Ride"] = 131.25, ["Neon"] = 19.68, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 67.02, ["Neon|Fly|Ride"] = 107.55, ["Mega"] = 152.23, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 275.62}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 183.75, ["Ride"] = 240.72, ["Fly|Ride"] = 287.43, ["Neon"] = 919.53, ["Neon|Fly|Ride"] = 1183.01, ["Mega|Fly|Ride"] = 3439.21}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 30.19, ["Ride"] = 21.38, ["Fly|Ride"] = 105.59, ["Neon"] = 7.61, ["Neon|Ride"] = 43.23, ["Neon|Fly|Ride"] = 301.31, ["Mega"] = 64.75, ["Mega|Ride"] = 354.95, ["Mega|Fly|Ride"] = 345.78}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.49, ["Ride"] = 65.62, ["Fly|Ride"] = 88.87, ["Neon"] = 19.21, ["Neon|Ride"] = 188.27, ["Mega"] = 188.03, ["Mega|Ride"] = 352.26}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.44, ["Fly"] = 94.77, ["Ride"] = 31.4, ["Neon"] = 13.13, ["Neon|Ride"] = 69.33, ["Neon|Fly|Ride"] = 115.63, ["Mega"] = 116.82, ["Mega|Ride"] = 164.06, ["Mega|Fly|Ride"] = 408.44}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 74.82, ["Ride"] = 137.82, ["Fly|Ride"] = 260.4, ["Neon"] = 447.57, ["Neon|Ride"] = 539.19, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 2593.26, ["Mega|Ride"] = 4321.58, ["Mega|Fly|Ride"] = 1728.85}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 35.43, ["Fly"] = 90.79, ["Ride"] = 62.98, ["Fly|Ride"] = 216.12, ["Neon"] = 126, ["Neon|Ride"] = 213.95, ["Neon|Fly|Ride"] = 341.93, ["Mega"] = 656.25, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 557.66}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 16.7, ["Fly"] = 263.44, ["Ride"] = 80.05, ["Fly|Ride"] = 129.68, ["Neon"] = 85.32, ["Neon|Ride"] = 106.38, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 374.95, ["Mega|Ride"] = 446.73, ["Mega|Fly|Ride"] = 493.5}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 79.97, ["Neon"] = 7.87, ["Neon|Ride"] = 210, ["Mega"] = 76.62, ["Mega|Ride"] = 174.56, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 42.72, ["Fly"] = 58.35, ["Ride"] = 69.28, ["Fly|Ride"] = 142.8, ["Neon"] = 178.5, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 229.69, ["Neon|Fly|Ride"] = 288.75, ["Mega|Fly|Ride"] = 1684.54}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Fly"] = 23.79, ["Ride"] = 45.4, ["Fly|Ride"] = 216.09, ["Neon"] = 6.56, ["Neon|Fly|Ride"] = 101.58, ["Mega"] = 101.58, ["Mega|Ride"] = 288.51, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 16.42, ["Fly"] = 39.38, ["Ride"] = 25.95, ["Fly|Ride"] = 73.48, ["Neon"] = 48.65, ["Neon|Fly"] = 84, ["Neon|Ride"] = 82.31, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 368.03, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 387.92, ["Mega|Fly|Ride"] = 577.01}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 60.9, ["Fly"] = 203.43, ["Ride"] = 97.76, ["Fly|Ride"] = 129.66, ["Neon"] = 262.5, ["Neon|Fly"] = 328.13, ["Neon|Ride"] = 282.19, ["Neon|Fly|Ride"] = 359.61, ["Mega|Ride"] = 1478.18, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 13.12, ["Fly|Ride"] = 36.74, ["Neon"] = 2.61, ["Neon|Fly"] = 28.11, ["Neon|Ride"] = 19.38, ["Neon|Fly|Ride"] = 54.08, ["Mega"] = 17.7, ["Mega|Fly"] = 77.44, ["Mega|Ride"] = 42.15, ["Mega|Fly|Ride"] = 100.67}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.61, ["Ride"] = 51.89, ["Fly|Ride"] = 131.25, ["Neon"] = 17.49, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 164.66, ["Mega"] = 144.38, ["Mega|Ride"] = 221.03, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 20.55, ["Ride"] = 56.53, ["Fly|Ride"] = 142.64, ["Neon"] = 119.44, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 327.97, ["Mega"] = 393.75, ["Mega|Ride"] = 426.57, ["Mega|Fly|Ride"] = 531.57}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 17.06, ["Neon"] = 2.1, ["Neon|Ride"] = 58.36, ["Neon|Fly|Ride"] = 105, ["Mega"] = 21, ["Mega|Ride"] = 51.89, ["Mega|Fly|Ride"] = 120.75}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 26.25, ["Fly"] = 144.8, ["Ride"] = 91.87, ["Fly|Ride"] = 216.12, ["Neon"] = 258.57, ["Neon|Ride"] = 308.44, ["Neon|Fly|Ride"] = 485.63, ["Mega"] = 720.71, ["Mega|Fly"] = 1050, ["Mega|Ride"] = 730.65, ["Mega|Fly|Ride"] = 1058.75}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 114.55, ["Fly"] = 25.97, ["Ride"] = 27.57, ["Fly|Ride"] = 101.07, ["Neon"] = 430.5, ["Neon|Ride"] = 136.64, ["Neon|Fly|Ride"] = 176.13, ["Mega|Ride"] = 458.07, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 10.18, ["Ride"] = 67.25, ["Neon"] = 75.65, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 91.77, ["Neon|Fly|Ride"] = 1147.25, ["Mega"] = 341.25, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 534.87}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 9.19, ["Fly"] = 2160.8, ["Ride"] = 65.54, ["Fly|Ride"] = 259.3, ["Neon"] = 44.17, ["Neon|Ride"] = 132.57, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 287.44, ["Mega|Ride"] = 242.99, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 145.68, ["Fly|Ride"] = 196.88, ["Neon"] = 9.14, ["Neon|Fly"] = 210, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 288.51, ["Mega"] = 67.75, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 85.78}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Neon"] = 4.33, ["Neon|Fly|Ride"] = 101.58, ["Mega"] = 30.19, ["Mega|Ride"] = 87.94, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 23.61}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 58.35, ["Fly"] = 101.07, ["Ride"] = 58.5, ["Fly|Ride"] = 112.39, ["Neon"] = 131.25, ["Neon|Ride"] = 216.12, ["Neon|Fly|Ride"] = 312.38, ["Mega"] = 1854.36, ["Mega|Ride"] = 756.37, ["Mega|Fly|Ride"] = 888.57}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 65.63, ["Neon"] = 3.12, ["Neon|Ride"] = 27.19, ["Mega"] = 28.11, ["Mega|Ride"] = 92.94, ["Mega|Fly|Ride"] = 293.93}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 501.38, ["Ride"] = 485.63, ["Fly|Ride"] = 572.25, ["Neon"] = 3889.43, ["Mega"] = 12964.71, ["Mega|Fly|Ride"] = 7108.11}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 5.02, ["Fly"] = 49.38, ["Ride"] = 33.74, ["Fly|Ride"] = 58.27, ["Neon"] = 73, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 69.61, ["Mega"] = 305.82, ["Mega|Ride"] = 288.51, ["Mega|Fly|Ride"] = 634.29}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.63, ["Fly"] = 42.72, ["Ride"] = 18.38, ["Fly|Ride"] = 43.72, ["Neon"] = 22.3, ["Neon|Ride"] = 38.04, ["Neon|Fly|Ride"] = 82.31, ["Mega"] = 142.64, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 330.75}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 15.58, ["Ride"] = 52.5, ["Fly|Ride"] = 86.45, ["Neon"] = 115.63, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 514.56, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.28, ["Fly"] = 43.22, ["Ride"] = 38.57, ["Fly|Ride"] = 72.42, ["Neon"] = 49.25, ["Neon|Ride"] = 65.63, ["Mega"] = 282.19, ["Mega|Ride"] = 287.43, ["Mega|Fly|Ride"] = 534.81}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 10.47, ["Ride"] = 91.87, ["Fly|Ride"] = 431.15, ["Neon"] = 82.8, ["Neon|Ride"] = 113.44, ["Neon|Fly|Ride"] = 248.54, ["Mega"] = 459.38, ["Mega|Ride"] = 655.93, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 6.39, ["Fly"] = 29.19, ["Ride"] = 29.09, ["Fly|Ride"] = 206.38, ["Neon"] = 31.19, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 220.9, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 346.25}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 49.14, ["Ride"] = 13.13, ["Fly|Ride"] = 34.68, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 15.64, ["Neon|Fly|Ride"] = 58.36, ["Mega"] = 14.43, ["Mega|Ride"] = 28.88, ["Mega|Fly|Ride"] = 76.12}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 8.92, ["Fly"] = 42, ["Ride"] = 29.51, ["Fly|Ride"] = 108.07, ["Neon"] = 58.35, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 155.6, ["Mega"] = 196.69, ["Mega|Ride"] = 343.89, ["Mega|Fly|Ride"] = 316.98}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 253.32, ["Ride"] = 280.67, ["Fly|Ride"] = 360.91, ["Neon"] = 1310.59, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1050, ["Mega|Ride"] = 9531.51, ["Mega|Fly|Ride"] = 4455}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 70.02, ["Ride"] = 128.89, ["Fly|Ride"] = 210, ["Neon"] = 458.07, ["Neon|Fly"] = 924.83, ["Neon|Ride"] = 479.07, ["Neon|Fly|Ride"] = 524.99, ["Mega"] = 2305.85, ["Mega|Ride"] = 1875.8, ["Mega|Fly|Ride"] = 1693.19}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 16.06, ["Ride"] = 16.22, ["Fly|Ride"] = 43.09, ["Neon"] = 7.88, ["Neon|Fly"] = 101.57, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 62.51, ["Mega"] = 65.63, ["Mega|Fly"] = 215.01, ["Mega|Ride"] = 128.13, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 26.23, ["Ride"] = 15.49, ["Fly|Ride"] = 40.68, ["Neon"] = 8.39, ["Neon|Fly"] = 33.18, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 48.54, ["Mega"] = 136.15, ["Mega|Fly"] = 288.51, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 153.57}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Fly"] = 101.58, ["Ride"] = 20.96, ["Fly|Ride"] = 98.44, ["Neon"] = 116.82, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 327.97, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 216.5, ["Ride"] = 244.12, ["Fly|Ride"] = 301.87, ["Neon"] = 994.09, ["Neon|Ride"] = 979.13, ["Neon|Fly|Ride"] = 1063.13, ["Mega|Ride"] = 8643.15, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.62, ["Fly"] = 36.75, ["Ride"] = 16.14, ["Fly|Ride"] = 38.74, ["Neon"] = 22.32, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 30.35, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 286.12, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 4.6, ["Ride"] = 78.75, ["Fly|Ride"] = 131.25, ["Neon"] = 32.81, ["Neon|Ride"] = 110.23, ["Mega"] = 194.25, ["Mega|Ride"] = 304.63, ["Mega|Fly|Ride"] = 410.61}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.63, ["Neon"] = 9.85, ["Neon|Ride"] = 105, ["Mega"] = 140.44, ["Mega|Ride"] = 324.17}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 13.96, ["Fly"] = 33.18, ["Ride"] = 31.19, ["Fly|Ride"] = 78.75, ["Neon"] = 82.68, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 525, ["Mega|Ride"] = 557.51, ["Mega|Fly|Ride"] = 555.41}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 39.3, ["Ride"] = 84.46, ["Fly|Ride"] = 713.07, ["Neon"] = 100.57, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 207.38, ["Neon|Fly|Ride"] = 333.38, ["Mega"] = 461.96, ["Mega|Fly"] = 2268.86, ["Mega|Ride"] = 432.17, ["Mega|Fly|Ride"] = 546}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 28.73, ["Fly"] = 45.94, ["Ride"] = 58.36, ["Fly|Ride"] = 93.19, ["Neon"] = 139.55, ["Neon|Fly"] = 286.43, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 183.64, ["Mega"] = 567, ["Mega|Ride"] = 702.19, ["Mega|Fly|Ride"] = 704.43}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 16.68, ["Ride"] = 14.44, ["Fly|Ride"] = 42.15, ["Neon"] = 2.1, ["Neon|Fly"] = 24.94, ["Neon|Ride"] = 17.17, ["Neon|Fly|Ride"] = 45.92, ["Mega"] = 18.38, ["Mega|Fly"] = 42.15, ["Mega|Ride"] = 33.52, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 262.5, ["Ride"] = 308.64, ["Fly|Ride"] = 249.38, ["Neon"] = 3422, ["Neon|Fly|Ride"] = 1463.04, ["Mega|Fly|Ride"] = 5763.52}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 9.19, ["Fly"] = 101.19, ["Ride"] = 28.75, ["Fly|Ride"] = 104.84, ["Neon"] = 108.07, ["Neon|Ride"] = 216.12, ["Mega"] = 397.14, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 426.83}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 36.75, ["Ride"] = 19.26, ["Fly|Ride"] = 40.94, ["Neon"] = 6.37, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 41.37, ["Neon|Fly|Ride"] = 129.68, ["Mega"] = 50.86, ["Mega|Fly"] = 244.21, ["Mega|Ride"] = 116.55, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 37.84, ["Ride"] = 21.5, ["Fly|Ride"] = 86.45, ["Neon"] = 2.15, ["Neon|Fly"] = 82.31, ["Neon|Ride"] = 24.62, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 32.82, ["Mega|Fly"] = 144.21, ["Mega|Ride"] = 39.69, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 37.7, ["Fly|Ride"] = 91.88, ["Neon"] = 12.83, ["Neon|Fly"] = 736.89, ["Neon|Ride"] = 63.24, ["Mega"] = 136.4, ["Mega|Ride"] = 196.81, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 11.03, ["Fly"] = 38.98, ["Ride"] = 21.62, ["Fly|Ride"] = 57.79, ["Neon"] = 47.56, ["Neon|Fly"] = 259.34, ["Neon|Ride"] = 48.86, ["Neon|Fly|Ride"] = 129.68, ["Mega"] = 316.91, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 7.86, ["Ride"] = 27.57, ["Neon"] = 43.09, ["Neon|Ride"] = 62.66, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 275.63, ["Mega|Ride"] = 327.97, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Neon"] = 3.15, ["Neon|Ride"] = 101.58, ["Neon|Fly|Ride"] = 108.5, ["Mega"] = 21.6, ["Mega|Ride"] = 68.02, ["Mega|Fly|Ride"] = 208.6}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 10.16, ["Fly"] = 83.99, ["Ride"] = 27.44, ["Fly|Ride"] = 132.92, ["Neon"] = 30.86, ["Neon|Ride"] = 86.45, ["Neon|Fly|Ride"] = 188.03, ["Mega"] = 216.12, ["Mega|Ride"] = 231.02, ["Mega|Fly|Ride"] = 360.87}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 31.48, ["Neon"] = 5.24, ["Neon|Fly"] = 115.63, ["Neon|Ride"] = 39.32, ["Neon|Fly|Ride"] = 108.07, ["Mega"] = 25.7, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 245.44}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 59.07, ["Ride"] = 21, ["Fly|Ride"] = 43.24, ["Neon"] = 3.78, ["Neon|Ride"] = 24.67, ["Neon|Fly|Ride"] = 85.29, ["Mega"] = 58.08, ["Mega|Ride"] = 91.77, ["Mega|Fly|Ride"] = 287.43}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 654.94, ["Ride"] = 708.75, ["Fly|Ride"] = 855.14, ["Neon"] = 2625, ["Neon|Ride"] = 3291.83, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 9620.63}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 18.34, ["Ride"] = 15.62, ["Fly|Ride"] = 64.99, ["Neon"] = 33.18, ["Neon|Fly"] = 119.62, ["Neon|Ride"] = 27.26, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 143.07, ["Mega|Ride"] = 94.02}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Fly"] = 144.8, ["Ride"] = 44.63, ["Fly|Ride"] = 79.97, ["Neon"] = 8.81, ["Neon|Fly"] = 63.76, ["Neon|Ride"] = 59.27, ["Neon|Fly|Ride"] = 196.54, ["Mega"] = 89.25, ["Mega|Fly"] = 210.9, ["Mega|Ride"] = 109.12, ["Mega|Fly|Ride"] = 259.34}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 11.82, ["Fly"] = 33.18, ["Ride"] = 18.43, ["Fly|Ride"] = 55.51, ["Neon"] = 41.56, ["Neon|Fly"] = 57.74, ["Neon|Ride"] = 45.85, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 485.63, ["Mega|Ride"] = 290.07, ["Mega|Fly|Ride"] = 377.99}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 58.96, ["Ride"] = 15.47, ["Fly|Ride"] = 32.94, ["Neon"] = 11.16, ["Neon|Fly"] = 52.48, ["Neon|Ride"] = 22.58, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 66.97, ["Mega|Ride"] = 96.48, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 40.46, ["Ride"] = 83.99, ["Neon"] = 236.25, ["Neon|Ride"] = 331.73, ["Neon|Fly|Ride"] = 302.56, ["Mega"] = 1262.06, ["Mega|Ride"] = 872, ["Mega|Fly|Ride"] = 819.29}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 78.75, ["Ride"] = 33.78, ["Fly|Ride"] = 76.26, ["Neon"] = 8.48, ["Neon|Fly"] = 129.68, ["Neon|Ride"] = 45.92, ["Neon|Fly|Ride"] = 129.68, ["Mega"] = 46.96, ["Mega|Ride"] = 144.8, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.71, ["Fly"] = 32.82, ["Ride"] = 26.21, ["Fly|Ride"] = 97.16, ["Neon"] = 14.02, ["Neon|Ride"] = 52.4, ["Mega"] = 115.49, ["Mega|Ride"] = 129.68, ["Mega|Fly|Ride"] = 325.5}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Ride"] = 43.23, ["Fly|Ride"] = 65.84, ["Neon"] = 13.17, ["Mega"] = 102.38, ["Mega|Fly"] = 288.51, ["Mega|Ride"] = 162.09, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 2592.96, ["Ride"] = 19.69, ["Fly|Ride"] = 69.45, ["Neon"] = 4.89, ["Neon|Fly"] = 72.42, ["Neon|Ride"] = 23.6, ["Neon|Fly|Ride"] = 108.07, ["Mega"] = 38.07, ["Mega|Fly"] = 229.69, ["Mega|Ride"] = 108.07, ["Mega|Fly|Ride"] = 105.42}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 17.43, ["Fly"] = 22.17, ["Ride"] = 19.11, ["Fly|Ride"] = 36.75, ["Neon"] = 122.84, ["Neon|Fly"] = 123.31, ["Neon|Ride"] = 129.38, ["Neon|Fly|Ride"] = 143.07, ["Mega|Ride"] = 864.44, ["Mega|Fly|Ride"] = 488.95}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 673.32, ["Ride"] = 750.82, ["Fly|Ride"] = 878.07, ["Neon"] = 1584.19, ["Neon|Ride"] = 1722.97, ["Neon|Fly|Ride"] = 1837.5, ["Mega"] = 6551.69, ["Mega|Ride"] = 7346.68, ["Mega|Fly|Ride"] = 4513.69}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 16.23, ["Ride"] = 17.06, ["Fly|Ride"] = 51.87, ["Neon"] = 3.15, ["Neon|Fly"] = 33.52, ["Neon|Ride"] = 18.43, ["Neon|Fly|Ride"] = 49.72, ["Mega"] = 31.5, ["Mega|Ride"] = 52.69, ["Mega|Fly|Ride"] = 135.5}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 6.58, ["Ride"] = 39.36, ["Fly|Ride"] = 245.67, ["Neon"] = 29.14, ["Neon|Ride"] = 98.01, ["Neon|Fly|Ride"] = 272.28, ["Mega|Ride"] = 147.41, ["Mega|Fly|Ride"] = 577.01}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 56.21, ["Fly"] = 156.19, ["Ride"] = 73.5, ["Fly|Ride"] = 127.52, ["Neon"] = 262.5, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 2456.3, ["Mega|Fly|Ride"] = 1836.9}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 34.13, ["Fly"] = 145.16, ["Ride"] = 58.46, ["Fly|Ride"] = 103.74, ["Neon"] = 152.8, ["Neon|Ride"] = 129.22, ["Mega"] = 2018.43, ["Mega|Ride"] = 1009.22, ["Mega|Fly|Ride"] = 972.48}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 12.64, ["Ride"] = 43.23, ["Fly|Ride"] = 105, ["Neon"] = 69.56, ["Neon|Ride"] = 98.27, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 311.85, ["Mega|Ride"] = 347.81, ["Mega|Fly|Ride"] = 404.14}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 22.05, ["Fly"] = 86.45, ["Ride"] = 71.25, ["Fly|Ride"] = 159.93, ["Neon"] = 84.71, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 309.1, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 397.69}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 24.92, ["Neon"] = 183.75, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 374.95, ["Mega"] = 923.99, ["Mega|Ride"] = 476.44, ["Mega|Fly|Ride"] = 555.2}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 15.75}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 6.16, ["Ride"] = 28.88, ["Fly|Ride"] = 101.17, ["Neon"] = 32.82, ["Neon|Fly"] = 94.49, ["Neon|Ride"] = 90.91, ["Neon|Fly|Ride"] = 213.98, ["Mega"] = 157.5, ["Mega|Fly"] = 467.58, ["Mega|Ride"] = 175.88, ["Mega|Fly|Ride"] = 355.23}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.61, ["Neon"] = 19.69, ["Mega"] = 139.32, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 35.22, ["Fly"] = 26.25, ["Ride"] = 43.2, ["Fly|Ride"] = 75.66, ["Neon"] = 147.41, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 327.97, ["Mega"] = 936.83, ["Mega|Ride"] = 791.44, ["Mega|Fly|Ride"] = 766.21}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 6.2, ["Fly"] = 18.09, ["Ride"] = 15.65, ["Fly|Ride"] = 38.07, ["Neon"] = 24.74, ["Neon|Fly"] = 42.94, ["Neon|Ride"] = 37.7, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 252.86, ["Mega|Fly"] = 432.23, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 230.14}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 6.44, ["Fly"] = 107.29, ["Ride"] = 21.59, ["Fly|Ride"] = 64.19, ["Neon"] = 21, ["Neon|Ride"] = 43.23, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 274.44, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 270.05}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Mega"] = 122.84, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 30.19, ["Ride"] = 53.69, ["Fly|Ride"] = 127.52, ["Neon"] = 159.41, ["Neon|Ride"] = 144.8, ["Neon|Fly|Ride"] = 432.23, ["Mega|Ride"] = 819.29, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 37.31, ["Fly|Ride"] = 58.15, ["Neon"] = 6.28, ["Neon|Ride"] = 45.92, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 78.75, ["Mega|Ride"] = 143.21}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 8.24, ["Ride"] = 819.29, ["Fly|Ride"] = 210, ["Neon"] = 78.74, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 324.17, ["Mega"] = 431.15, ["Mega|Ride"] = 427.48, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 16.47, ["Fly|Ride"] = 48.92, ["Neon"] = 14.43, ["Neon|Ride"] = 24.31, ["Neon|Fly|Ride"] = 100.47, ["Mega"] = 157.77, ["Mega|Ride"] = 151.3, ["Mega|Fly|Ride"] = 288.51}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 7.88, ["Fly"] = 52.49, ["Ride"] = 24.08, ["Fly|Ride"] = 61.74, ["Neon"] = 94.5, ["Neon|Ride"] = 72.42, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 274.44, ["Mega|Ride"] = 388.96, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 10.48, ["Neon"] = 63.89, ["Mega"] = 426.57, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 648.33}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 56.32, ["Fly"] = 216.12, ["Ride"] = 157.49, ["Fly|Ride"] = 480.29, ["Neon"] = 288.75, ["Neon|Ride"] = 539.19, ["Neon|Fly|Ride"] = 719.79, ["Mega"] = 1512.74, ["Mega|Ride"] = 1403.61, ["Mega|Fly|Ride"] = 1286.25}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 17.7, ["Fly"] = 129.68, ["Ride"] = 78.75, ["Fly|Ride"] = 161.28, ["Neon"] = 85.31, ["Mega"] = 422.63, ["Mega|Ride"] = 418.69, ["Mega|Fly|Ride"] = 468.96}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 5.23, ["Ride"] = 116.43, ["Neon"] = 149.63, ["Neon|Fly"] = 216.12, ["Neon|Ride"] = 170.63, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 491.33}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 27.56, ["Ride"] = 65.63, ["Fly|Ride"] = 367.49, ["Neon"] = 169.79, ["Neon|Fly"] = 144.8, ["Neon|Ride"] = 216.12, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 915.05, ["Mega|Fly"] = 2160.8, ["Mega|Ride"] = 728.28, ["Mega|Fly|Ride"] = 863.35}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.45, ["Neon"] = 24.54, ["Neon|Fly|Ride"] = 144.8, ["Mega"] = 198.19, ["Mega|Ride"] = 255.5, ["Mega|Fly|Ride"] = 327.97}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 15.65, ["Fly|Ride"] = 47.36, ["Neon"] = 13.13, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 28.08, ["Neon|Fly|Ride"] = 65.1, ["Mega"] = 62.03, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 2.63, ["Fly"] = 45.94, ["Ride"] = 37.84, ["Fly|Ride"] = 84, ["Neon"] = 12.92, ["Neon|Ride"] = 36.66, ["Neon|Fly|Ride"] = 164.05, ["Mega"] = 87.94, ["Mega|Ride"] = 103.99, ["Mega|Fly|Ride"] = 336}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 144.8, ["Ride"] = 25.95, ["Fly|Ride"] = 72, ["Neon"] = 7.86, ["Neon|Ride"] = 31.36, ["Neon|Fly|Ride"] = 84.46, ["Mega"] = 70.88, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 116.82}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.52, ["Fly"] = 65.62, ["Ride"] = 21.62, ["Fly|Ride"] = 85.38, ["Neon"] = 25.02, ["Neon|Ride"] = 86.63, ["Neon|Fly|Ride"] = 216.12, ["Mega"] = 196.88, ["Mega|Ride"] = 313.95, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 4.33, ["Fly"] = 105, ["Ride"] = 34.12, ["Fly|Ride"] = 86.45, ["Neon"] = 26.24, ["Neon|Fly"] = 315, ["Neon|Ride"] = 58.15, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 287.47, ["Mega|Fly|Ride"] = 1080.41}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 7.22, ["Fly"] = 131.24, ["Ride"] = 24.67, ["Fly|Ride"] = 43.23, ["Neon"] = 22.31, ["Neon|Fly"] = 43.23, ["Neon|Ride"] = 49.32, ["Neon|Fly|Ride"] = 111.45, ["Mega"] = 216.12, ["Mega|Fly"] = 216.12, ["Mega|Ride"] = 265.83, ["Mega|Fly|Ride"] = 287.44}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.5, ["Fly"] = 35.49, ["Ride"] = 20.34, ["Fly|Ride"] = 52.49, ["Neon"] = 36.75, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 151.3, ["Mega"] = 274.46, ["Mega|Ride"] = 164.6, ["Mega|Fly|Ride"] = 213.74}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 2.1, ["Fly"] = 186.38, ["Ride"] = 47.28, ["Fly|Ride"] = 131.25, ["Neon"] = 8.42, ["Neon|Fly"] = 437.06, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 144.8, ["Mega"] = 79.62, ["Mega|Fly"] = 216.81, ["Mega|Ride"] = 149.13, ["Mega|Fly|Ride"] = 280.35}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 24.59, ["Ride"] = 81.01, ["Fly|Ride"] = 213.17, ["Neon"] = 120.75, ["Neon|Fly"] = 216.12, ["Neon|Ride"] = 203.32, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 326.82, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 476.53, ["Mega|Fly|Ride"] = 484.32}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 45.45, ["Fly"] = 164.07, ["Ride"] = 83.22, ["Fly|Ride"] = 170.63, ["Neon"] = 242.82, ["Neon|Ride"] = 263.82, ["Neon|Fly|Ride"] = 285.87, ["Mega"] = 994.09, ["Mega|Ride"] = 1009.22, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Ride"] = 23.7, ["Fly|Ride"] = 118.12, ["Neon"] = 2.41, ["Neon|Ride"] = 20.55, ["Neon|Fly|Ride"] = 144.8, ["Mega"] = 32.44, ["Mega|Ride"] = 72.42, ["Mega|Fly|Ride"] = 123.38}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 15.51, ["Ride"] = 105, ["Mega"] = 706.68, ["Mega|Ride"] = 539.19, ["Mega|Fly|Ride"] = 1138.89}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 65.62, ["Ride"] = 93.69, ["Fly|Ride"] = 171.82, ["Neon"] = 339.76, ["Neon|Ride"] = 323.09, ["Neon|Fly|Ride"] = 418.99, ["Mega"] = 1229.64, ["Mega|Ride"] = 1355, ["Mega|Fly|Ride"] = 3241.2}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 7.88, ["Fly"] = 116.82, ["Ride"] = 28.04, ["Fly|Ride"] = 133.88, ["Neon"] = 39.36, ["Neon|Fly"] = 131.42, ["Neon|Ride"] = 105, ["Mega"] = 272.9, ["Mega|Fly"] = 741.81, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 295.31}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 6.56, ["Neon"] = 15.42, ["Neon|Ride"] = 72.42, ["Neon|Fly|Ride"] = 108.07, ["Mega"] = 101.57, ["Mega|Fly"] = 282.17, ["Mega|Ride"] = 119.36, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 3.03, ["Fly"] = 31.19, ["Ride"] = 19.29, ["Fly|Ride"] = 49.37, ["Neon"] = 13.71, ["Neon|Ride"] = 41.64, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 114.19, ["Mega|Fly"] = 196.87, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 188.03}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 21.59, ["Ride"] = 14.43, ["Fly|Ride"] = 52.5, ["Neon"] = 2.63, ["Neon|Fly"] = 129.68, ["Neon|Ride"] = 23.57, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 24.87, ["Mega|Ride"] = 78.78, ["Mega|Fly|Ride"] = 144.8}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 17.46, ["Fly|Ride"] = 93.09, ["Neon"] = 4.9, ["Neon|Ride"] = 26.22, ["Neon|Fly|Ride"] = 97.44, ["Mega"] = 43.08, ["Mega|Fly"] = 168, ["Mega|Ride"] = 56.4, ["Mega|Fly|Ride"] = 147.41}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 16.23, ["Neon"] = 3.93, ["Mega"] = 21.54, ["Mega|Ride"] = 79.7, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 6.4, ["Ride"] = 157.5, ["Neon"] = 42, ["Neon|Ride"] = 82.6, ["Neon|Fly|Ride"] = 123.2, ["Mega"] = 182.83, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 5.15, ["Ride"] = 45.94, ["Fly|Ride"] = 216.12, ["Neon"] = 87.75, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 141.49, ["Mega"] = 262.5, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 6.28, ["Fly"] = 22.16, ["Ride"] = 19.64, ["Fly|Ride"] = 40.03, ["Neon"] = 52.9, ["Neon|Ride"] = 44.17, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 328.13, ["Mega|Fly"] = 261.19, ["Mega|Ride"] = 379.77, ["Mega|Fly|Ride"] = 263.82}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 65.54, ["Ride"] = 98.44, ["Fly|Ride"] = 124.69, ["Neon"] = 148.24, ["Neon|Ride"] = 540.28, ["Neon|Fly|Ride"] = 720.63, ["Mega"] = 1441.42, ["Mega|Ride"] = 1657.53, ["Mega|Fly|Ride"] = 1501.5}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 23.37, ["Fly"] = 51.19, ["Ride"] = 28.88, ["Fly|Ride"] = 102.67, ["Neon"] = 720.71, ["Neon|Fly|Ride"] = 630, ["Mega"] = 466.77, ["Mega|Ride"] = 1023.75, ["Mega|Fly|Ride"] = 1050.67}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 16.17, ["Fly|Ride"] = 42, ["Neon"] = 2.63, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 24.87, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 25.89, ["Mega|Ride"] = 94.02, ["Mega|Fly|Ride"] = 241.5}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 19.67, ["Ride"] = 15.58, ["Fly|Ride"] = 32.22, ["Neon"] = 5.17, ["Neon|Fly"] = 28.07, ["Neon|Ride"] = 19.4, ["Neon|Fly|Ride"] = 45.75, ["Mega"] = 40.72, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 145.69}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 413.34, ["Fly"] = 680.49, ["Ride"] = 524.61, ["Fly|Ride"] = 535.91, ["Neon"] = 2738.06, ["Neon|Ride"] = 2296.88, ["Neon|Fly|Ride"] = 2098.69}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 4.29, ["Ride"] = 56.52, ["Neon"] = 32.82, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 577.01, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 17.18, ["Fly|Ride"] = 30.24, ["Neon"] = 7.22, ["Neon|Fly"] = 22.87, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 56.43, ["Mega"] = 43.05, ["Mega|Ride"] = 38.83, ["Mega|Fly|Ride"] = 89.14}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 49.62, ["Ride"] = 104.57, ["Fly|Ride"] = 720.63, ["Neon"] = 203.44, ["Neon|Ride"] = 280.23, ["Neon|Fly|Ride"] = 327.97, ["Mega"] = 796.1, ["Mega|Ride"] = 630.3, ["Mega|Fly|Ride"] = 821.61}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 3.28, ["Fly"] = 27.56, ["Ride"] = 18.04, ["Fly|Ride"] = 61.98, ["Neon"] = 13.99, ["Neon|Fly"] = 101.36, ["Neon|Ride"] = 26.69, ["Neon|Fly|Ride"] = 91.76, ["Mega"] = 114.19, ["Mega|Ride"] = 135.18, ["Mega|Fly|Ride"] = 190.31}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Ride"] = 15.73, ["Fly|Ride"] = 196.88, ["Neon"] = 2.1, ["Neon|Ride"] = 144.8, ["Neon|Fly|Ride"] = 101.58, ["Mega"] = 18.68, ["Mega|Ride"] = 51.19, ["Mega|Fly|Ride"] = 154.76}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 42, ["Fly"] = 129.94, ["Ride"] = 65.63, ["Fly|Ride"] = 215.04, ["Neon"] = 169.32, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 374.95, ["Mega"] = 819.29, ["Mega|Ride"] = 661.39, ["Mega|Fly|Ride"] = 794.98}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Fly|Ride"] = 146.99, ["Neon"] = 7.88, ["Neon|Ride"] = 23.64, ["Mega"] = 57.75, ["Mega|Ride"] = 86.63, ["Mega|Fly|Ride"] = 255.02}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 45.94, ["Ride"] = 72.42, ["Fly|Ride"] = 131.25, ["Neon"] = 283.23, ["Neon|Ride"] = 216.12, ["Neon|Fly|Ride"] = 216.12, ["Mega"] = 1181.25, ["Mega|Ride"] = 1296.64, ["Mega|Fly|Ride"] = 1334.93}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.07, ["Ride"] = 51.19, ["Fly|Ride"] = 432.23, ["Neon"] = 42, ["Neon|Ride"] = 230.99, ["Neon|Fly|Ride"] = 164.6, ["Mega"] = 170.63, ["Mega|Ride"] = 418.14}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 72.42, ["Ride"] = 81.36, ["Fly|Ride"] = 72.42, ["Neon"] = 8.64, ["Neon|Ride"] = 43.35, ["Neon|Fly|Ride"] = 108.07, ["Mega"] = 117.6, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 105, ["Fly"] = 216.12, ["Ride"] = 122.85, ["Fly|Ride"] = 536.8, ["Neon"] = 359.63, ["Neon|Ride"] = 478.69, ["Mega|Ride"] = 2770.69, ["Mega|Fly|Ride"] = 1260.98}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 593.43, ["Ride"] = 45.94, ["Neon"] = 7.81, ["Neon|Fly"] = 115.63, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 144.8, ["Mega"] = 49.88, ["Mega|Fly"] = 216.12, ["Mega|Ride"] = 114.55, ["Mega|Fly|Ride"] = 287.39}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 28, ["Ride"] = 19.69, ["Fly|Ride"] = 103.95, ["Neon"] = 6.49, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 25.98, ["Neon|Fly|Ride"] = 86.89, ["Mega"] = 72.42, ["Mega|Fly"] = 151.1, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 230.32}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 9.19, ["Fly"] = 58.51, ["Ride"] = 39.38, ["Fly|Ride"] = 196.54, ["Neon"] = 84, ["Neon|Fly"] = 131.44, ["Neon|Ride"] = 102.38, ["Neon|Fly|Ride"] = 213.95, ["Mega"] = 534.87, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 9.19, ["Fly"] = 38.06, ["Ride"] = 19.69, ["Fly|Ride"] = 51.19, ["Neon"] = 52.5, ["Neon|Fly"] = 326.73, ["Neon|Ride"] = 74.81, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 354.38, ["Mega|Ride"] = 362.25, ["Mega|Fly|Ride"] = 1228.31}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 21, ["Fly"] = 28.88, ["Ride"] = 22.32, ["Fly|Ride"] = 61.94, ["Neon"] = 81.38, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 172.9, ["Mega"] = 784.92, ["Mega|Ride"] = 334.69, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 64.22, ["Ride"] = 126.6, ["Fly|Ride"] = 192.95, ["Neon"] = 318.32, ["Neon|Fly"] = 428.59, ["Neon|Ride"] = 366.19, ["Neon|Fly|Ride"] = 573.79, ["Mega"] = 1296.64, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1273.51}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 17.3, ["Ride"] = 108, ["Fly|Ride"] = 423.72, ["Neon"] = 65.41, ["Neon|Ride"] = 182.79, ["Mega"] = 338.63, ["Mega|Ride"] = 437.28}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 6.2, ["Ride"] = 20.69, ["Fly|Ride"] = 78.75, ["Neon"] = 15.75, ["Neon|Ride"] = 47.25, ["Mega"] = 124.16, ["Mega|Ride"] = 252.82, ["Mega|Fly|Ride"] = 287.66}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 11.81, ["Fly"] = 135.19, ["Ride"] = 26.25, ["Fly|Ride"] = 115.5, ["Neon"] = 68.8, ["Neon|Fly"] = 105, ["Neon|Ride"] = 86.45, ["Neon|Fly|Ride"] = 164.6, ["Mega"] = 317.63, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 432.23}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 14.04, ["Fly|Ride"] = 30.16, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 12.99, ["Neon|Fly|Ride"] = 43.24, ["Mega"] = 15.09, ["Mega|Fly"] = 42, ["Mega|Ride"] = 28.56, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 42.45, ["Fly"] = 164.07, ["Ride"] = 101.58, ["Neon"] = 233.89, ["Neon|Fly"] = 2449.27, ["Neon|Ride"] = 294, ["Mega"] = 933.52, ["Mega|Ride"] = 976.5, ["Mega|Fly|Ride"] = 833.02}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Fly"] = 64.32, ["Ride"] = 20.6, ["Fly|Ride"] = 112.4, ["Neon"] = 3.94, ["Neon|Fly"] = 131.25, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 33.02, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 19.03, ["Fly|Ride"] = 45.9, ["Neon"] = 17.07, ["Neon|Ride"] = 27.87, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 252, ["Mega|Ride"] = 212.68, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 55.13, ["Fly"] = 115.63, ["Ride"] = 96.46, ["Fly|Ride"] = 177.19, ["Neon"] = 244.27, ["Neon|Ride"] = 345.78, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 969.33, ["Mega|Ride"] = 825.57, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 63.89, ["Neon"] = 6.57, ["Neon|Ride"] = 39.16, ["Neon|Fly|Ride"] = 184.78, ["Mega"] = 65.83, ["Mega|Ride"] = 129.68, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 4.07}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 32.8, ["Fly|Ride"] = 141.01, ["Neon"] = 6.15, ["Neon|Ride"] = 39.36, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 45.4, ["Mega|Ride"] = 102.24, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 133.68, ["Ride"] = 157.5, ["Fly|Ride"] = 360.91, ["Neon"] = 525, ["Neon|Ride"] = 629.99, ["Neon|Fly|Ride"] = 678.57, ["Mega"] = 6483.14, ["Mega|Ride"] = 3275.85, ["Mega|Fly|Ride"] = 2170.07}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.93, ["Ride"] = 105, ["Fly|Ride"] = 216.12, ["Neon"] = 41.77, ["Neon|Fly"] = 144.8, ["Neon|Ride"] = 67.02, ["Mega"] = 164.6, ["Mega|Ride"] = 253.31, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 15.75, ["Neon"] = 3.94, ["Neon|Ride"] = 22.23, ["Mega"] = 45.92, ["Mega|Ride"] = 48.57, ["Mega|Fly|Ride"] = 307.13}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 6.28, ["Ride"] = 36.74, ["Fly|Ride"] = 101.58, ["Neon"] = 60.29, ["Neon|Ride"] = 106.98, ["Neon|Fly|Ride"] = 164.6, ["Mega"] = 319.38, ["Mega|Ride"] = 579.12, ["Mega|Fly|Ride"] = 687.15}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 8.95, ["Fly"] = 90.95, ["Ride"] = 20.19, ["Fly|Ride"] = 62.69, ["Neon"] = 101.04, ["Neon|Ride"] = 142.64, ["Neon|Fly|Ride"] = 216.12, ["Mega"] = 649.69, ["Mega|Ride"] = 283.5, ["Mega|Fly|Ride"] = 396.57}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 22.91, ["Ride"] = 65.51, ["Fly|Ride"] = 288.51, ["Neon"] = 154.88, ["Neon|Ride"] = 157.48, ["Neon|Fly|Ride"] = 345.78, ["Mega"] = 552.57, ["Mega|Ride"] = 551.25, ["Mega|Fly|Ride"] = 639.85}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 128.49, ["Fly"] = 196.88, ["Ride"] = 164.07, ["Fly|Ride"] = 203.4, ["Neon"] = 525, ["Neon|Fly"] = 459.38, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 584.72, ["Mega|Fly|Ride"] = 2484.13}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 9.69, ["Fly"] = 20.67, ["Ride"] = 19.69, ["Fly|Ride"] = 42.94, ["Neon"] = 49.54, ["Neon|Fly"] = 58.36, ["Neon|Ride"] = 38.17, ["Neon|Fly|Ride"] = 78.75, ["Mega|Ride"] = 327.97, ["Mega|Fly|Ride"] = 418.18}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 3.74, ["Fly"] = 72.42, ["Ride"] = 46.52, ["Fly|Ride"] = 131.25, ["Neon"] = 19.68, ["Neon|Ride"] = 37.43, ["Neon|Fly|Ride"] = 86.45, ["Mega"] = 157.5, ["Mega|Ride"] = 157.49, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 7.88, ["Fly"] = 43.2, ["Ride"] = 32.11, ["Fly|Ride"] = 76.13, ["Neon"] = 48.07, ["Neon|Fly"] = 86.45, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 149.13, ["Mega"] = 461.28, ["Mega|Ride"] = 435.75, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 48.38, ["Fly"] = 82.62, ["Ride"] = 75.89, ["Fly|Ride"] = 116.82, ["Neon"] = 216.35, ["Neon|Ride"] = 284.82, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 787.5, ["Mega|Ride"] = 925.32, ["Mega|Fly|Ride"] = 1207.5}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 17.06, ["Ride"] = 157.58, ["Neon"] = 196.87, ["Neon|Ride"] = 259.34, ["Neon|Fly|Ride"] = 288.51, ["Mega"] = 735.76, ["Mega|Ride"] = 620.23, ["Mega|Fly|Ride"] = 980.05}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 236.12, ["Ride"] = 350.44, ["Fly|Ride"] = 393.75, ["Neon"] = 1312.5, ["Neon|Ride"] = 1638.55, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4198.69}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 24.99, ["Ride"] = 28.87, ["Fly|Ride"] = 69.46, ["Neon"] = 431.15, ["Neon|Ride"] = 194.25, ["Neon|Fly|Ride"] = 347.82, ["Mega"] = 918.75, ["Mega|Ride"] = 770.67, ["Mega|Fly|Ride"] = 1076.25}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 41.98, ["Ride"] = 14.4, ["Fly|Ride"] = 34.13, ["Neon"] = 2.1, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 45.47, ["Mega"] = 18.24, ["Mega|Fly"] = 114.55, ["Mega|Ride"] = 36.11, ["Mega|Fly|Ride"] = 129.42}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.55, ["Ride"] = 24.95, ["Neon"] = 29.19, ["Neon|Ride"] = 86.45, ["Neon|Fly|Ride"] = 164.6, ["Mega"] = 196.88, ["Mega|Ride"] = 140.43, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.41, ["Ride"] = 26.25, ["Fly|Ride"] = 144.79, ["Neon"] = 16.7, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 1181.24, ["Mega|Fly"] = 575.01, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 327.47}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 426.57, ["Fly"] = 393.75, ["Ride"] = 400.2, ["Fly|Ride"] = 523.06, ["Neon"] = 1873.64, ["Neon|Ride"] = 1930.67, ["Neon|Fly|Ride"] = 2018.43, ["Mega|Fly|Ride"] = 5042.81}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 78.75, ["Ride"] = 16.35, ["Fly|Ride"] = 44.63, ["Neon"] = 27.03, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 252, ["Mega|Ride"] = 156.19, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 10.4, ["Fly"] = 28.1, ["Ride"] = 19.45, ["Fly|Ride"] = 44.63, ["Neon"] = 51, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 71.32, ["Neon|Fly|Ride"] = 140.04, ["Mega"] = 369.56, ["Mega|Ride"] = 277.61, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 4.82, ["Fly"] = 45.92, ["Ride"] = 27.57, ["Fly|Ride"] = 69.88, ["Neon"] = 14.24, ["Neon|Fly"] = 94.48, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 127.32, ["Mega"] = 94.5, ["Mega|Ride"] = 128.64, ["Mega|Fly|Ride"] = 216.12}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 35.09, ["Fly"] = 73.71, ["Ride"] = 34.13, ["Fly|Ride"] = 87.23, ["Neon"] = 220.5, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 736.98, ["Mega|Ride"] = 863.35, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 3.94, ["Fly"] = 39.38, ["Ride"] = 52.5, ["Fly|Ride"] = 52.38, ["Neon"] = 16.54, ["Neon|Ride"] = 106.87, ["Neon|Fly|Ride"] = 210, ["Mega"] = 168.77, ["Mega|Ride"] = 205.23, ["Mega|Fly|Ride"] = 755.35}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 47.25, ["Fly"] = 150.94, ["Ride"] = 42.02, ["Fly|Ride"] = 94.61, ["Neon"] = 210, ["Neon|Fly|Ride"] = 259.23}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 144.8, ["Neon"] = 6.57, ["Neon|Ride"] = 144.27, ["Neon|Fly|Ride"] = 101.58, ["Mega"] = 111.57, ["Mega|Ride"] = 288.51, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 12.01, ["Ride"] = 43.23, ["Neon"] = 65.62, ["Mega"] = 137.4, ["Mega|Ride"] = 315.53, ["Mega|Fly|Ride"] = 655.93}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 19.67, ["Ride"] = 78.75, ["Fly|Ride"] = 86.45, ["Neon"] = 48.07, ["Neon|Ride"] = 82.31, ["Neon|Fly|Ride"] = 145.89, ["Mega"] = 215.33, ["Mega|Ride"] = 289.47, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 17.07, ["Fly"] = 35.44, ["Ride"] = 22.97, ["Fly|Ride"] = 52.5, ["Neon"] = 43.23, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 48.76, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 539.19, ["Mega|Ride"] = 334.59, ["Mega|Fly|Ride"] = 384.57}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 422.57, ["Fly"] = 589.6, ["Ride"] = 430.5, ["Fly|Ride"] = 551.25, ["Neon"] = 1903.13, ["Neon|Fly"] = 2072.89, ["Neon|Ride"] = 3570, ["Neon|Fly|Ride"] = 1640.62, ["Mega|Fly|Ride"] = 7476.14}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 18.4, ["Fly|Ride"] = 36.75, ["Neon"] = 14.8, ["Neon|Fly"] = 82.31, ["Neon|Ride"] = 32.44, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 267.99, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 28.88, ["Fly"] = 96.97, ["Ride"] = 85.32, ["Neon"] = 104.99, ["Neon|Ride"] = 164.6, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 433.13, ["Mega|Fly"] = 720.71, ["Mega|Ride"] = 577.01, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 24.29, ["Ride"] = 119.95, ["Fly|Ride"] = 245.67, ["Neon"] = 70.7, ["Neon|Ride"] = 202.08, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 279.69, ["Mega|Ride"] = 301.87, ["Mega|Fly|Ride"] = 452.81}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 59.07, ["Fly"] = 169.2, ["Ride"] = 78.75, ["Fly|Ride"] = 128.6, ["Neon"] = 345.78, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 2620.87, ["Mega|Fly|Ride"] = 3084.9}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 15.75, ["Ride"] = 58.49, ["Fly|Ride"] = 102.92, ["Neon"] = 66.33, ["Neon|Ride"] = 122.11, ["Neon|Fly|Ride"] = 205.14, ["Mega"] = 207.38, ["Mega|Fly"] = 366.16, ["Mega|Ride"] = 216.56, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 19.69, ["Fly|Ride"] = 59.07, ["Neon"] = 18.37, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 123.2, ["Mega"] = 103.69, ["Mega|Ride"] = 146.24, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 5.17, ["Ride"] = 90.2, ["Neon"] = 28.86, ["Neon|Ride"] = 86.44, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 209.99, ["Mega|Fly"] = 490.56, ["Mega|Fly|Ride"] = 251.99}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 52.5, ["Fly"] = 183.75, ["Ride"] = 87.34, ["Fly|Ride"] = 202.08, ["Neon"] = 138.93, ["Neon|Ride"] = 238.7, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 367.49, ["Mega|Ride"] = 410.81, ["Mega|Fly|Ride"] = 462}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 85.32, ["Neon"] = 8.65, ["Neon|Ride"] = 72.15, ["Neon|Fly|Ride"] = 169.59, ["Mega"] = 62.62, ["Mega|Fly"] = 105, ["Mega|Ride"] = 123.36, ["Mega|Fly|Ride"] = 164.06}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 29.08, ["Ride"] = 183.75, ["Neon"] = 210, ["Neon|Ride"] = 389.01, ["Mega"] = 717.48, ["Mega|Fly|Ride"] = 820.03}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 1010.62, ["Fly"] = 1194.38, ["Ride"] = 971.25, ["Fly|Ride"] = 1155, ["Neon"] = 4322.1, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2887.5, ["Mega"] = 9940.81, ["Mega|Fly|Ride"] = 7875}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 14.32, ["Ride"] = 59.07, ["Fly|Ride"] = 196.77, ["Neon"] = 159.93, ["Neon|Fly"] = 719.64, ["Neon|Ride"] = 216.12, ["Mega"] = 466.74, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 519.27}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 52.46, ["Ride"] = 21, ["Fly|Ride"] = 72.19, ["Neon"] = 9.6, ["Neon|Ride"] = 29.75, ["Neon|Fly|Ride"] = 85.31, ["Mega"] = 108.07, ["Mega|Ride"] = 100.03, ["Mega|Fly|Ride"] = 162.74}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 10.28, ["Ride"] = 131.25, ["Fly|Ride"] = 393.75, ["Neon"] = 77.44, ["Neon|Fly|Ride"] = 541.7, ["Mega"] = 288.74, ["Mega|Ride"] = 430.71, ["Mega|Fly|Ride"] = 432.23}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 25.95, ["Fly|Ride"] = 53.86, ["Neon"] = 2.1, ["Neon|Fly"] = 29.19, ["Neon|Ride"] = 27.89, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 18.27, ["Mega|Ride"] = 39.44, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 55.12, ["Ride"] = 97.13, ["Fly|Ride"] = 274.32, ["Neon"] = 227.06, ["Neon|Fly"] = 354.38, ["Neon|Ride"] = 270.74, ["Neon|Fly|Ride"] = 429.4, ["Mega"] = 1023.75, ["Mega|Ride"] = 826.88, ["Mega|Fly|Ride"] = 945}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 18.38, ["Ride"] = 65.63, ["Fly|Ride"] = 288.51, ["Neon"] = 145.01, ["Neon|Ride"] = 275.55, ["Neon|Fly|Ride"] = 525, ["Mega"] = 577.49, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 611.81}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 43.32, ["Neon"] = 12.27, ["Neon|Ride"] = 44.47, ["Neon|Fly|Ride"] = 209.99, ["Mega"] = 98.27, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 18.43, ["Fly"] = 52.49, ["Ride"] = 42.95, ["Fly|Ride"] = 94.5, ["Neon"] = 100.48, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 142.64, ["Neon|Fly|Ride"] = 577.01, ["Mega"] = 476.53, ["Mega|Ride"] = 736.98, ["Mega|Fly|Ride"] = 861}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 13.13, ["Fly"] = 86.44, ["Ride"] = 30.19, ["Fly|Ride"] = 64.32, ["Neon"] = 29.19, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 136.17, ["Mega"] = 360.91, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 430.5}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 42.62, ["Ride"] = 119.95, ["Neon"] = 540.28, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 682.5, ["Mega"] = 2521.95, ["Mega|Ride"] = 1836.9, ["Mega|Fly|Ride"] = 2048.8}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 6.39, ["Ride"] = 48.87, ["Fly|Ride"] = 131.25, ["Neon"] = 15.75, ["Neon|Ride"] = 77.15, ["Neon|Fly|Ride"] = 147, ["Mega"] = 86.63, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 65.63, ["Fly"] = 36.75, ["Ride"] = 22.31, ["Fly|Ride"] = 56.21, ["Neon"] = 85.38, ["Neon|Fly"] = 188.03, ["Neon|Ride"] = 63.89, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 337.32, ["Mega|Ride"] = 287.44, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 115.22, ["Fly"] = 164.07, ["Ride"] = 154.88, ["Fly|Ride"] = 213.94, ["Neon"] = 525, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 557.82, ["Mega|Ride"] = 1853.51, ["Mega|Fly|Ride"] = 1884.09}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 35.06, ["Ride"] = 20.46, ["Fly|Ride"] = 36.45, ["Neon"] = 13.1, ["Neon|Fly"] = 57.72, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 68.25, ["Mega"] = 118.13, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 177.35}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 49.72, ["Fly"] = 267.04, ["Ride"] = 90.95, ["Fly|Ride"] = 1205.76, ["Neon"] = 155.71, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 340.7, ["Mega"] = 1080.41, ["Mega|Ride"] = 605.11, ["Mega|Fly|Ride"] = 620.23}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.89, ["Ride"] = 15.96, ["Fly|Ride"] = 64.31, ["Neon"] = 2.1, ["Neon|Fly"] = 31.2, ["Neon|Ride"] = 15.94, ["Neon|Fly|Ride"] = 47.24, ["Mega"] = 14.95, ["Mega|Fly"] = 47.93, ["Mega|Ride"] = 30.23, ["Mega|Fly|Ride"] = 76.13}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 29.19, ["Neon"] = 5.25, ["Neon|Fly|Ride"] = 108.07, ["Mega"] = 27.57, ["Mega|Fly"] = 131.24, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 147.41}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 3.93, ["Fly"] = 36.75, ["Ride"] = 31.36, ["Fly|Ride"] = 173.37, ["Neon"] = 18.43, ["Neon|Ride"] = 58.36, ["Neon|Fly|Ride"] = 172.9, ["Mega"] = 105, ["Mega|Ride"] = 287.43, ["Mega|Fly|Ride"] = 248.07}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 48.57, ["Fly|Ride"] = 656.25, ["Neon"] = 173.24, ["Neon|Ride"] = 327.97, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 547.32, ["Mega|Ride"] = 704.51}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 3.65, ["Fly"] = 19.58, ["Ride"] = 17.2, ["Fly|Ride"] = 36.75, ["Neon"] = 14.62, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 64.51, ["Mega"] = 105, ["Mega|Fly"] = 267.23, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 170.43}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 14.44, ["Fly"] = 42.78, ["Ride"] = 43.23, ["Fly|Ride"] = 72.35, ["Neon"] = 72.49, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 164.59, ["Mega"] = 432.23, ["Mega|Ride"] = 299.25, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 3.6, ["Fly"] = 27.33, ["Ride"] = 18.26, ["Fly|Ride"] = 86.45, ["Neon"] = 7.47, ["Neon|Fly"] = 98.42, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 61.13, ["Mega"] = 64.31, ["Mega|Fly"] = 105, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 144.36}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 11.11, ["Fly"] = 162.39, ["Ride"] = 32.43, ["Fly|Ride"] = 217.3, ["Neon"] = 45.92, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 864.44, ["Mega"] = 432.23, ["Mega|Ride"] = 426.83, ["Mega|Fly|Ride"] = 370.13}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 5.25, ["Ride"] = 190.11, ["Fly|Ride"] = 210, ["Neon"] = 65.26, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 115.63, ["Mega"] = 157.5, ["Mega|Ride"] = 318.77, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.8, ["Fly"] = 57.4, ["Ride"] = 18.89, ["Fly|Ride"] = 52.49, ["Neon"] = 30.02, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 122.8, ["Mega"] = 253.94, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 240.19, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 25.94, ["Ride"] = 19.02, ["Fly|Ride"] = 39.38, ["Neon"] = 18.39, ["Neon|Fly"] = 70.51, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 99.75, ["Mega|Ride"] = 145.69, ["Mega|Fly|Ride"] = 272.3}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 157.5, ["Fly"] = 393.75, ["Ride"] = 264.55, ["Fly|Ride"] = 388.49, ["Neon"] = 1330.13, ["Neon|Ride"] = 1426.13, ["Neon|Fly|Ride"] = 1174.69, ["Mega"] = 4258.48, ["Mega|Fly|Ride"] = 4421.84}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 5.43, ["Ride"] = 114.17, ["Neon"] = 45.48, ["Neon|Fly|Ride"] = 108.07, ["Mega"] = 123.38, ["Mega|Ride"] = 655.93}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 4.19, ["Fly"] = 108.07, ["Ride"] = 19.69, ["Fly|Ride"] = 62.69, ["Neon"] = 41.56, ["Neon|Fly"] = 245.28, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 147.39, ["Mega"] = 258.19, ["Mega|Ride"] = 283.49, ["Mega|Fly|Ride"] = 207.38}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 7.87, ["Fly|Ride"] = 720.63, ["Neon"] = 38.07, ["Neon|Ride"] = 164.6, ["Neon|Fly|Ride"] = 648.25, ["Mega"] = 603.75, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 432.23}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 16.23, ["Ride"] = 15.62, ["Fly|Ride"] = 32.43, ["Neon"] = 2.63, ["Neon|Fly"] = 29.19, ["Neon|Ride"] = 18.31, ["Neon|Fly|Ride"] = 38.73, ["Mega"] = 17.43, ["Mega|Fly"] = 52.5, ["Mega|Ride"] = 36.75, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 6.57, ["Fly"] = 59.61, ["Ride"] = 26.23, ["Fly|Ride"] = 55.12, ["Neon"] = 23.4, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 107.62, ["Mega"] = 112.6, ["Mega|Ride"] = 162.03, ["Mega|Fly|Ride"] = 262.44}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.13, ["Ride"] = 124.79, ["Neon"] = 10.5, ["Neon|Ride"] = 288.51, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 101.07, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 874.13}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 69.47, ["Fly"] = 78.75, ["Ride"] = 94.02, ["Fly|Ride"] = 137.82, ["Neon"] = 420, ["Neon|Ride"] = 354.38, ["Neon|Fly|Ride"] = 396.38, ["Mega"] = 2881.41, ["Mega|Ride"] = 3603.12, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.76, ["Fly"] = 101.58, ["Ride"] = 23.62, ["Fly|Ride"] = 141.74, ["Neon"] = 16.88, ["Neon|Ride"] = 70.88, ["Mega"] = 169.31, ["Mega|Ride"] = 383.2, ["Mega|Fly|Ride"] = 720.63}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 89.25, ["Ride"] = 43.22, ["Neon"] = 6.49, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 288.51, ["Mega"] = 68.29, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 128.6, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 39.53, ["Fly"] = 160.48, ["Ride"] = 78.75, ["Fly|Ride"] = 172.9, ["Neon"] = 141.91, ["Neon|Ride"] = 176.61, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 414.75, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 574.87}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 12.98, ["Fly|Ride"] = 32.81, ["Neon"] = 2.63, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 17.05, ["Neon|Fly|Ride"] = 41.96, ["Mega"] = 17.8, ["Mega|Fly"] = 52.49, ["Mega|Ride"] = 29.59, ["Mega|Fly|Ride"] = 126}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Fly|Ride"] = 101.58, ["Neon"] = 3.78, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 45.83, ["Neon|Fly|Ride"] = 101.39, ["Mega"] = 26.25, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 61.67, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.61, ["Ride"] = 85.32, ["Neon"] = 9.17, ["Neon|Ride"] = 58.36, ["Neon|Fly|Ride"] = 109.33, ["Mega"] = 97.13, ["Mega|Fly"] = 188.03, ["Mega|Ride"] = 112.27, ["Mega|Fly|Ride"] = 216.8}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 3.94, ["Fly"] = 72.42, ["Ride"] = 42.78, ["Fly|Ride"] = 89.25, ["Neon"] = 21.16, ["Neon|Fly"] = 108.07, ["Neon|Ride"] = 72.16, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 91.88, ["Mega|Fly"] = 199.63, ["Mega|Ride"] = 144.37, ["Mega|Fly|Ride"] = 258.64}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 20.22, ["Ride"] = 13.89, ["Fly|Ride"] = 32.29, ["Neon"] = 2.1, ["Neon|Fly"] = 21.62, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 58.36, ["Mega"] = 19.04, ["Mega|Ride"] = 50.67, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 20.79, ["Fly"] = 127.52, ["Ride"] = 71.87, ["Neon"] = 202.08, ["Neon|Fly"] = 144.8, ["Neon|Ride"] = 194.52, ["Neon|Fly|Ride"] = 864.44, ["Mega"] = 588.44, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 821.21}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2231.25, ["Fly"] = 2722.59, ["Ride"] = 2493.75, ["Fly|Ride"] = 2243.07, ["Neon|Fly|Ride"] = 7415.63, ["Mega|Fly|Ride"] = 44836.26}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 31.44, ["Ride"] = 19.69, ["Fly|Ride"] = 43.32, ["Neon"] = 10.66, ["Neon|Fly"] = 49.88, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 62.31, ["Mega"] = 65.63, ["Mega|Fly"] = 476.46, ["Mega|Ride"] = 98.27, ["Mega|Fly|Ride"] = 163.7}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.38, ["Ride"] = 65.63, ["Neon"] = 11.34, ["Mega"] = 132.92, ["Mega|Fly"] = 441, ["Mega|Ride"] = 124.58, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 18.38, ["Fly"] = 105, ["Ride"] = 29.19, ["Fly|Ride"] = 133.88, ["Neon"] = 115.63, ["Neon|Ride"] = 112.4, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 431.82, ["Mega|Ride"] = 412.13, ["Mega|Fly|Ride"] = 567.82}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 28.08, ["Fly"] = 144.8, ["Ride"] = 70.7, ["Neon"] = 144.8, ["Neon|Ride"] = 236.25, ["Mega"] = 668.2, ["Mega|Ride"] = 859.81, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 139.5, ["Fly"] = 548.42, ["Ride"] = 169.2, ["Fly|Ride"] = 245.28, ["Neon"] = 647.07, ["Neon|Ride"] = 510.57, ["Neon|Fly|Ride"] = 603.75, ["Mega"] = 6482.37, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 4.33, ["Ride"] = 31.5, ["Fly|Ride"] = 677.25, ["Neon"] = 22.32, ["Neon|Ride"] = 72.42, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 144.8, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 379.28}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.55, ["Ride"] = 41.77, ["Neon"] = 22.28, ["Neon|Ride"] = 115.5, ["Mega"] = 179.81, ["Mega|Fly|Ride"] = 267.09}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 101.58, ["Ride"] = 25.99, ["Fly|Ride"] = 64.63, ["Neon"] = 6.54, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 90.57, ["Mega"] = 82.31, ["Mega|Ride"] = 98.34, ["Mega|Fly|Ride"] = 265.09}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 13.13, ["Ride"] = 84, ["Fly|Ride"] = 131.25, ["Neon"] = 144.35, ["Neon|Ride"] = 1231.84, ["Neon|Fly|Ride"] = 364.88, ["Mega"] = 577.01, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 429.85}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 20.57, ["Neon"] = 2.1, ["Neon|Ride"] = 21, ["Mega"] = 21, ["Mega|Ride"] = 576.19, ["Mega|Fly|Ride"] = 144.8}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 99.02, ["Fly"] = 819.29, ["Ride"] = 105, ["Fly|Ride"] = 82.31, ["Neon"] = 346.5, ["Neon|Fly"] = 462.48, ["Neon|Ride"] = 415.66, ["Neon|Fly|Ride"] = 526.22, ["Mega"] = 3241.2, ["Mega|Fly|Ride"] = 1228.31}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Fly"] = 41.77, ["Ride"] = 36.75, ["Neon"] = 16.42, ["Neon|Ride"] = 164.19, ["Neon|Fly|Ride"] = 102.92, ["Mega"] = 67.38, ["Mega|Ride"] = 288.51, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 62.68, ["Fly"] = 83.61, ["Ride"] = 78.75, ["Fly|Ride"] = 152.53, ["Neon"] = 157.5, ["Neon|Ride"] = 280.76, ["Neon|Fly|Ride"] = 231, ["Mega"] = 2018.43, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 58.36, ["Ride"] = 18.66, ["Fly|Ride"] = 50.5, ["Neon"] = 4.9, ["Neon|Fly"] = 82.31, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 86.44, ["Mega|Fly"] = 491.27, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 327.93}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Ride"] = 28.11, ["Neon"] = 6.56, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 216.12, ["Mega"] = 36.75, ["Mega|Ride"] = 137.7}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 4.39, ["Fly"] = 72.4, ["Ride"] = 24.06, ["Fly|Ride"] = 90.91, ["Neon"] = 25.47, ["Neon|Fly"] = 108.07, ["Neon|Ride"] = 72.49, ["Mega"] = 131.25, ["Mega|Ride"] = 216.12, ["Mega|Fly|Ride"] = 972.7}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 314.99, ["Fly"] = 736.98, ["Ride"] = 353.66, ["Fly|Ride"] = 482.62, ["Neon"] = 787.5, ["Neon|Ride"] = 923.99, ["Neon|Fly|Ride"] = 853.13, ["Mega"] = 3819.66, ["Mega|Ride"] = 2676.19, ["Mega|Fly|Ride"] = 3565.73}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 33.48, ["Fly"] = 57.74, ["Ride"] = 48.07, ["Fly|Ride"] = 91.86, ["Neon"] = 161.42, ["Neon|Ride"] = 140.21, ["Neon|Fly|Ride"] = 229.68, ["Mega"] = 1009.22, ["Mega|Fly"] = 2768.25, ["Mega|Fly|Ride"] = 1065.41}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 64.86, ["Ride"] = 29.19, ["Fly|Ride"] = 116.82, ["Neon"] = 32.82, ["Neon|Fly"] = 101.07, ["Neon|Ride"] = 39.35, ["Neon|Fly|Ride"] = 131.06, ["Mega"] = 170.62, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 274.46}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 23.61, ["Fly"] = 231.25, ["Ride"] = 84.45, ["Fly|Ride"] = 227.06, ["Neon"] = 85.22, ["Neon|Fly"] = 432.23, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 210, ["Mega"] = 367.39, ["Mega|Fly"] = 1010.89, ["Mega|Ride"] = 329.25, ["Mega|Fly|Ride"] = 451.5}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 7.34, ["Ride"] = 19.67, ["Neon"] = 164.6, ["Neon|Ride"] = 122.84, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 655.93, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 311.2}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 2.62, ["Fly|Ride"] = 94.02, ["Neon"] = 12.47, ["Neon|Ride"] = 157.49, ["Mega"] = 39.38, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 342}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 3.13, ["Fly"] = 72.42, ["Ride"] = 18.16, ["Fly|Ride"] = 62.99, ["Neon"] = 57.75, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 250.68, ["Mega"] = 573.56, ["Mega|Ride"] = 340.15, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 109.61, ["Fly"] = 245.67, ["Ride"] = 127.32, ["Fly|Ride"] = 183.75, ["Neon"] = 575.09, ["Neon|Ride"] = 571.04, ["Neon|Fly|Ride"] = 524.99, ["Mega"] = 2887.5, ["Mega|Ride"] = 3275.85, ["Mega|Fly|Ride"] = 2178.75}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 23.55, ["Ride"] = 64.47, ["Neon"] = 129.04, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 342.71, ["Mega"] = 605.11, ["Mega|Ride"] = 634.29, ["Mega|Fly|Ride"] = 720.71}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2077.69, ["Fly"] = 1968.75, ["Ride"] = 1912.31, ["Fly|Ride"] = 1988.44, ["Neon"] = 11525.93, ["Neon|Ride"] = 7860.09, ["Neon|Fly|Ride"] = 6877.5, ["Mega|Fly|Ride"] = 25592.44}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 6.57, ["Fly"] = 131250, ["Ride"] = 58.36, ["Fly|Ride"] = 131.25, ["Neon"] = 101.56, ["Neon|Ride"] = 95.1, ["Neon|Fly|Ride"] = 323.09, ["Mega"] = 225.23, ["Mega|Fly"] = 893.61, ["Mega|Ride"] = 550.3, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 6.57, ["Fly"] = 720.71, ["Ride"] = 32.47, ["Fly|Ride"] = 111.07, ["Neon"] = 31.49, ["Neon|Ride"] = 86.45, ["Mega"] = 215.01, ["Mega|Ride"] = 490.56, ["Mega|Fly|Ride"] = 361.59}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 893.82, ["Fly"] = 1123.12, ["Ride"] = 904.3, ["Fly|Ride"] = 944.99, ["Neon"] = 2778.57, ["Neon|Ride"] = 3079.33, ["Neon|Fly|Ride"] = 2369.07, ["Mega|Ride"] = 13921.4, ["Mega|Fly|Ride"] = 15127.3}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 42.95, ["Ride"] = 70.03, ["Fly|Ride"] = 105, ["Neon"] = 229.7, ["Neon|Ride"] = 327.97, ["Neon|Fly|Ride"] = 274.46, ["Mega"] = 653.61, ["Mega|Ride"] = 864.44, ["Mega|Fly|Ride"] = 792.24}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.63, ["Ride"] = 23.61, ["Fly|Ride"] = 128.15, ["Neon"] = 15.5, ["Neon|Fly"] = 164.6, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 236.25, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Ride"] = 144.21, ["Neon"] = 3.19, ["Neon|Ride"] = 52.41, ["Mega"] = 30.44, ["Mega|Ride"] = 70.91, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 90.57, ["Ride"] = 144.37, ["Fly|Ride"] = 216.12, ["Neon"] = 459.38, ["Neon|Ride"] = 614.16, ["Neon|Fly|Ride"] = 655.93, ["Mega"] = 2456.58, ["Mega|Fly|Ride"] = 2442}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 3.93, ["Ride"] = 39.38, ["Fly|Ride"] = 70.03, ["Neon"] = 12.59, ["Neon|Fly"] = 72.19, ["Neon|Ride"] = 39.93, ["Neon|Fly|Ride"] = 144.8, ["Mega"] = 91.88, ["Mega|Ride"] = 164.6, ["Mega|Fly|Ride"] = 267.74}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 72.42, ["Ride"] = 106.32, ["Neon"] = 648.33, ["Neon|Ride"] = 591.07, ["Neon|Fly|Ride"] = 518.66, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 7.44, ["Fly"] = 105, ["Fly|Ride"] = 129.68, ["Neon"] = 32.47, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 269.05, ["Mega"] = 446.25, ["Mega|Ride"] = 317.7, ["Mega|Fly|Ride"] = 401.98}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 236.24, ["Ride"] = 312.38, ["Fly|Ride"] = 367.5, ["Neon"] = 1184.27, ["Neon|Ride"] = 936.83, ["Neon|Fly|Ride"] = 879.38, ["Mega|Fly|Ride"] = 4035.76}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.33, ["Fly"] = 65.63, ["Ride"] = 19.69, ["Fly|Ride"] = 144.8, ["Neon"] = 27.57, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 43.19, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 239.89, ["Mega|Ride"] = 591.29, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 17.56, ["Ride"] = 16.21, ["Fly|Ride"] = 38.73, ["Neon"] = 5.13, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 23.08, ["Neon|Fly|Ride"] = 56.15, ["Mega"] = 45.94, ["Mega|Ride"] = 58.46, ["Mega|Fly|Ride"] = 116.88}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1015.87, ["Ride"] = 1115.63, ["Fly|Ride"] = 1260.52, ["Neon|Ride"] = 7923.6, ["Neon|Fly|Ride"] = 7563.66, ["Mega"] = 24565.7}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 18.44, ["Fly"] = 137.85, ["Ride"] = 94.49, ["Fly|Ride"] = 323.09, ["Neon"] = 85.32, ["Neon|Ride"] = 314.99, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 491.33, ["Mega|Ride"] = 523, ["Mega|Fly|Ride"] = 554.39}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 6.29, ["Fly"] = 54.05, ["Ride"] = 34.13, ["Fly|Ride"] = 77.44, ["Neon"] = 29.19, ["Neon|Ride"] = 60.53, ["Neon|Fly|Ride"] = 117.04, ["Mega"] = 188.03, ["Mega|Ride"] = 161.49, ["Mega|Fly|Ride"] = 253.21}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 30.19, ["Fly"] = 39.69, ["Ride"] = 40.69, ["Fly|Ride"] = 65.63, ["Neon|Ride"] = 187.68, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 2592.96, ["Mega|Ride"] = 864.44, ["Mega|Fly|Ride"] = 808.5}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 11.82, ["Fly"] = 62.91, ["Ride"] = 31.4, ["Fly|Ride"] = 70.74, ["Neon"] = 61.36, ["Neon|Ride"] = 86.45, ["Neon|Fly|Ride"] = 196.54, ["Mega"] = 367.5, ["Mega|Ride"] = 376.68, ["Mega|Fly|Ride"] = 577.01}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 210, ["Ride"] = 157.5, ["Fly|Ride"] = 644.01, ["Neon"] = 602.95, ["Mega|Fly|Ride"] = 1113}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 16.23, ["Neon"] = 2.63, ["Neon|Fly"] = 58.36, ["Neon|Ride"] = 115.31, ["Neon|Fly|Ride"] = 98.35, ["Mega"] = 18.05, ["Mega|Fly"] = 55.12, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 218.66}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 147.39, ["Fly"] = 196.85, ["Ride"] = 173.25, ["Fly|Ride"] = 271.69, ["Neon"] = 551.25, ["Neon|Ride"] = 616.77, ["Neon|Fly|Ride"] = 597.19, ["Mega"] = 3457.69, ["Mega|Fly|Ride"] = 2377.16}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.81, ["Fly"] = 748.35, ["Ride"] = 20.44, ["Fly|Ride"] = 70.86, ["Neon"] = 229.67, ["Neon|Ride"] = 84, ["Mega"] = 773.71, ["Mega|Ride"] = 440.35, ["Mega|Fly|Ride"] = 490.88}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 18.38, ["Fly|Ride"] = 39.35, ["Neon"] = 14.44, ["Neon|Fly"] = 82.31, ["Neon|Ride"] = 65.54, ["Neon|Fly|Ride"] = 105.91, ["Mega"] = 108.07, ["Mega|Ride"] = 280.67}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 6.57, ["Ride"] = 126.06, ["Neon"] = 7.88, ["Neon|Fly"] = 142.64, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 214.86, ["Mega"] = 86.45}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 131.25, ["Fly"] = 203.9, ["Ride"] = 236.25, ["Fly|Ride"] = 328.13, ["Neon"] = 655.89, ["Neon|Ride"] = 972.48, ["Neon|Fly|Ride"] = 761.25, ["Mega"] = 1942.79, ["Mega|Ride"] = 1981.37, ["Mega|Fly|Ride"] = 1787.2}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 4.99, ["Ride"] = 131.25, ["Neon"] = 26.02, ["Neon|Ride"] = 78.75, ["Mega"] = 126.88, ["Mega|Ride"] = 157.77, ["Mega|Fly|Ride"] = 327.97}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 27.54, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 24.87, ["Mega"] = 18.38, ["Mega|Fly|Ride"] = 157.49}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 101.24, ["Ride"] = 16.23, ["Fly|Ride"] = 144.8, ["Neon"] = 2.1, ["Neon|Fly"] = 86.2, ["Neon|Ride"] = 23.68, ["Mega"] = 18.21, ["Mega|Fly"] = 58.36, ["Mega|Ride"] = 58.36, ["Mega|Fly|Ride"] = 128.63}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 36.75, ["Ride"] = 16.04, ["Fly|Ride"] = 50.59, ["Neon"] = 9.85, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 59.07, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 156.19}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Fly"] = 29.19, ["Ride"] = 19.68, ["Fly|Ride"] = 91.88, ["Neon"] = 10.4, ["Mega"] = 144.27, ["Mega|Ride"] = 159.93, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 16.48, ["Fly|Ride"] = 41.88, ["Neon"] = 13.13, ["Neon|Fly"] = 86.44, ["Neon|Ride"] = 40.95, ["Neon|Fly|Ride"] = 77.67, ["Mega"] = 327.97, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 287.43}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 55.13, ["Ride"] = 127.52, ["Fly|Ride"] = 288.51, ["Neon"] = 229.66, ["Neon|Ride"] = 318.77, ["Neon|Fly|Ride"] = 634.29, ["Mega"] = 787.5, ["Mega|Ride"] = 780.17, ["Mega|Fly|Ride"] = 885.94}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 15.47, ["Ride"] = 17.5, ["Fly|Ride"] = 32.82, ["Neon"] = 2.63, ["Neon|Fly"] = 19.69, ["Neon|Ride"] = 19.34, ["Neon|Fly|Ride"] = 46.69, ["Mega"] = 15.75, ["Mega|Ride"] = 38.92, ["Mega|Fly|Ride"] = 96.93}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 11.44, ["Fly"] = 58.7, ["Ride"] = 35.44, ["Fly|Ride"] = 73.22, ["Neon"] = 38.07, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 129.68, ["Mega"] = 242.82, ["Mega|Fly"] = 397.69, ["Mega|Ride"] = 246.75, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 36.66, ["Fly"] = 64.32, ["Ride"] = 57.74, ["Fly|Ride"] = 98.44, ["Neon"] = 207.38, ["Neon|Fly"] = 215.38, ["Neon|Ride"] = 181.8, ["Neon|Fly|Ride"] = 221.82, ["Mega"] = 621.32, ["Mega|Ride"] = 864.44, ["Mega|Fly|Ride"] = 767.82}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 23.63, ["Fly"] = 209.99, ["Neon"] = 162.93, ["Mega"] = 516.51, ["Mega|Ride"] = 490.88, ["Mega|Fly|Ride"] = 819.29}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.23, ["Ride"] = 15.6, ["Fly|Ride"] = 35.93, ["Neon"] = 5.25, ["Neon|Fly"] = 29.19, ["Neon|Ride"] = 16.89, ["Neon|Fly|Ride"] = 55.09, ["Mega"] = 38.37, ["Mega|Ride"] = 62.69, ["Mega|Fly|Ride"] = 103.85}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 23.63, ["Ride"] = 98.19, ["Neon"] = 110.21, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 216.09, ["Mega"] = 531.78, ["Mega|Fly"] = 735, ["Mega|Ride"] = 577.01, ["Mega|Fly|Ride"] = 1561.88}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 904.16, ["Ride"] = 971.25, ["Fly|Ride"] = 1019.82, ["Neon"] = 2491.13, ["Neon|Ride"] = 2738.06, ["Neon|Fly|Ride"] = 2231.25, ["Mega|Fly|Ride"] = 6168.75}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 230.97, ["Ride"] = 314.99, ["Fly|Ride"] = 488.87, ["Neon"] = 721.88, ["Neon|Ride"] = 963.83, ["Neon|Fly|Ride"] = 1043.44, ["Mega"] = 5401.97, ["Mega|Ride"] = 3861.8, ["Mega|Fly|Ride"] = 3506.96}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Ride"] = 52.49, ["Neon"] = 6.57, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 259.34, ["Mega"] = 64.32, ["Mega|Fly|Ride"] = 1152.93}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 177.07, ["Ride"] = 245.63, ["Fly|Ride"] = 475.13, ["Neon"] = 656.25, ["Neon|Ride"] = 774.38, ["Neon|Fly|Ride"] = 984.38, ["Mega|Ride"] = 2435.77, ["Mega|Fly|Ride"] = 2161.06}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.41, ["Ride"] = 24.34, ["Fly|Ride"] = 82.31, ["Neon"] = 17.07, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 38.88, ["Neon|Fly|Ride"] = 144.8, ["Mega"] = 115.96, ["Mega|Ride"] = 488.86, ["Mega|Fly|Ride"] = 282.19}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 241.5, ["Fly"] = 432.23, ["Ride"] = 262.5, ["Fly|Ride"] = 430.5, ["Neon|Ride"] = 1585.15, ["Neon|Fly|Ride"] = 1619.71, ["Mega|Fly|Ride"] = 4027.49}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.23, ["Fly"] = 77.97, ["Ride"] = 24.94, ["Fly|Ride"] = 118.13, ["Neon"] = 26.23, ["Neon|Ride"] = 58.08, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 393.75, ["Mega|Fly"] = 361.99}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.62, ["Neon"] = 41.62, ["Mega"] = 231, ["Mega|Ride"] = 244.21, ["Mega|Fly|Ride"] = 401.98}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 38.07, ["Fly"] = 52.5, ["Ride"] = 68.12, ["Fly|Ride"] = 144.8, ["Neon"] = 135.12, ["Neon|Fly"] = 432.23, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 525, ["Mega"] = 856.32, ["Mega|Ride"] = 722.54, ["Mega|Fly|Ride"] = 972.48}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.62, ["Ride"] = 49.76, ["Neon"] = 22.32, ["Neon|Ride"] = 196.88, ["Mega"] = 245.67, ["Mega|Ride"] = 245.28, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 16.95, ["Ride"] = 13.82, ["Fly|Ride"] = 39.37, ["Neon"] = 3.15, ["Neon|Fly"] = 21.62, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 39.6, ["Mega"] = 31.49, ["Mega|Fly"] = 55.13, ["Mega|Ride"] = 36.03, ["Mega|Fly|Ride"] = 68.25}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4200, ["Ride"] = 4593.73, ["Fly|Ride"] = 4095, ["Neon"] = 32411.75, ["Neon|Fly|Ride"] = 24492.18, ["Mega|Fly|Ride"] = 59062.5}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 8.02, ["Fly"] = 86.45, ["Ride"] = 42.37, ["Neon"] = 99.74, ["Neon|Fly"] = 384.63, ["Neon|Ride"] = 101.64, ["Neon|Fly|Ride"] = 189.1, ["Mega"] = 216.57, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.55, ["Fly"] = 26.25, ["Ride"] = 18.12, ["Fly|Ride"] = 49.54, ["Neon"] = 27.03, ["Neon|Fly"] = 45.93, ["Neon|Ride"] = 28.86, ["Neon|Fly|Ride"] = 81.32, ["Mega"] = 144.38, ["Mega|Ride"] = 209.63, ["Mega|Fly|Ride"] = 242.18}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 393.74, ["Fly"] = 547.84, ["Ride"] = 446.24, ["Fly|Ride"] = 531.57, ["Neon"] = 2018.43, ["Neon|Ride"] = 1292.81, ["Neon|Fly|Ride"] = 1213.96, ["Mega"] = 6027, ["Mega|Fly|Ride"] = 5114.82}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 3.94, ["Ride"] = 49.14, ["Neon"] = 22.32, ["Neon|Ride"] = 164.6, ["Mega"] = 142.63, ["Mega|Ride"] = 171.82, ["Mega|Fly|Ride"] = 720.71}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.75, ["Fly"] = 189, ["Ride"] = 26.24, ["Neon"] = 72.07, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 525, ["Mega|Ride"] = 401.62, ["Mega|Fly|Ride"] = 488.25}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 72.42, ["Ride"] = 20.9, ["Fly|Ride"] = 65.62, ["Neon"] = 5.25, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 91.75, ["Mega"] = 44.63, ["Mega|Ride"] = 70.86, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 582.75, ["Fly"] = 879.57, ["Ride"] = 715.32, ["Fly|Ride"] = 744.19, ["Neon|Ride"] = 2126.25, ["Neon|Fly|Ride"] = 2099.99, ["Mega|Fly|Ride"] = 8860.28}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 15.37, ["Ride"] = 70.41, ["Fly|Ride"] = 345.18, ["Neon"] = 51.97, ["Neon|Fly"] = 129.68, ["Neon|Ride"] = 144.37, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 223.13, ["Mega|Ride"] = 413.44, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 3.94, ["Fly"] = 43.12, ["Ride"] = 86.63, ["Fly|Ride"] = 129.68, ["Neon"] = 24.52, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 157.5, ["Mega|Fly"] = 819.17, ["Mega|Ride"] = 179.03, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 3.54, ["Fly"] = 39.26, ["Ride"] = 20.9, ["Fly|Ride"] = 58.36, ["Neon"] = 14.42, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 86.62, ["Mega"] = 105, ["Mega|Fly|Ride"] = 190.31}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 20.99, ["Fly"] = 39.38, ["Ride"] = 39.82, ["Fly|Ride"] = 65.63, ["Neon"] = 89.25, ["Neon|Ride"] = 114.18, ["Mega"] = 608.02, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 648.33}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 288.51, ["Neon"] = 5.24, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 32.43, ["Mega|Fly"] = 115.63, ["Mega|Ride"] = 101.35, ["Mega|Fly|Ride"] = 221.82}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 643.13, ["Ride"] = 525, ["Fly|Ride"] = 655.99, ["Neon|Ride"] = 2794.23, ["Neon|Fly|Ride"] = 2593.26, ["Mega|Ride"] = 9580.65, ["Mega|Fly|Ride"] = 7875}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.61, ["Ride"] = 55.75, ["Fly|Ride"] = 288.51, ["Neon"] = 13.58, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 203.43, ["Mega"] = 45.4, ["Mega|Fly"] = 213.73, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 224.28}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 52.4, ["Fly|Ride"] = 196.88, ["Neon"] = 7.88, ["Neon|Fly"] = 288.51, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 40.29, ["Mega|Ride"] = 120.21, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Neon"] = 4.99, ["Neon|Ride"] = 57.17, ["Neon|Fly|Ride"] = 288.51, ["Mega"] = 43.31, ["Mega|Fly"] = 149.85, ["Mega|Ride"] = 116.7, ["Mega|Fly|Ride"] = 129.66}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 15.75, ["Mega"] = 172.9, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 28.25, ["Fly"] = 82.69, ["Ride"] = 66.05, ["Fly|Ride"] = 201, ["Neon"] = 161.23, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 426.57, ["Mega"] = 540.75, ["Mega|Ride"] = 559.67, ["Mega|Fly|Ride"] = 606.82}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 14.44, ["Ride"] = 57.75, ["Fly|Ride"] = 124.69, ["Neon"] = 89.24, ["Neon|Ride"] = 145.08, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 443.63, ["Mega|Ride"] = 935.55, ["Mega|Fly|Ride"] = 647.25}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 3.93, ["Fly"] = 22.32, ["Ride"] = 20.99, ["Fly|Ride"] = 37.97, ["Neon"] = 26.25, ["Neon|Ride"] = 41.08, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 293.35, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 12.97, ["Ride"] = 39.38, ["Neon"] = 72.19, ["Neon|Ride"] = 189.1, ["Mega|Ride"] = 410.82}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 38.98, ["Ride"] = 21, ["Fly|Ride"] = 111.56, ["Neon"] = 12.21, ["Neon|Ride"] = 54.06, ["Neon|Fly|Ride"] = 127.34, ["Mega"] = 105, ["Mega|Fly"] = 122.82, ["Mega|Ride"] = 142.64, ["Mega|Fly|Ride"] = 287.43}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 17.74, ["Fly"] = 115.47, ["Ride"] = 32.15, ["Fly|Ride"] = 45.94, ["Neon"] = 98.44, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 168.67, ["Mega"] = 907.61, ["Mega|Fly|Ride"] = 719.25}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 32.42, ["Fly"] = 97.13, ["Neon"] = 183.75, ["Mega"] = 242.82, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 584.73}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 62.92, ["Fly"] = 86.15, ["Ride"] = 78.73, ["Fly|Ride"] = 146.09, ["Neon"] = 271.69, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 387.19, ["Mega"] = 2784.54, ["Mega|Fly|Ride"] = 1351.88}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 34.61, ["Fly"] = 144.8, ["Ride"] = 76.99, ["Fly|Ride"] = 122.84, ["Neon"] = 118.01, ["Neon|Ride"] = 194.8, ["Neon|Fly|Ride"] = 324.84, ["Mega"] = 507.94, ["Mega|Ride"] = 589.85, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 17.07, ["Ride"] = 64.32, ["Neon"] = 141.63, ["Neon|Ride"] = 218.68, ["Mega"] = 502.69, ["Mega|Ride"] = 449.58, ["Mega|Fly|Ride"] = 840.67}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 39.38, ["Fly"] = 131.13, ["Ride"] = 115.63, ["Fly|Ride"] = 259.88, ["Neon"] = 177.18, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 655.93, ["Mega"] = 918.75, ["Mega|Ride"] = 976.82, ["Mega|Fly|Ride"] = 1145.38}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 24.69, ["Ride"] = 15.74, ["Fly|Ride"] = 35.44, ["Neon"] = 5.25, ["Neon|Fly"] = 32.81, ["Neon|Ride"] = 29.51, ["Neon|Fly|Ride"] = 56.21, ["Mega"] = 40.15, ["Mega|Fly"] = 327.97, ["Mega|Ride"] = 58.36, ["Mega|Fly|Ride"] = 146.99}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1246.88}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 131.25, ["Ride"] = 343.93, ["Fly|Ride"] = 378, ["Neon"] = 494.09, ["Mega"] = 1640.24, ["Mega|Ride"] = 1815.3, ["Mega|Fly|Ride"] = 1685.63}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 83.91, ["Neon"] = 2.63, ["Neon|Fly"] = 101.58, ["Neon|Ride"] = 41.08, ["Neon|Fly|Ride"] = 300.57, ["Mega"] = 72.42, ["Mega|Fly"] = 144.8, ["Mega|Ride"] = 69.69, ["Mega|Fly|Ride"] = 136.17}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 35.21, ["Ride"] = 65.63, ["Neon"] = 118.13, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 397.98, ["Mega"] = 591.93, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 601.13}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Fly|Ride"] = 144.8, ["Mega"] = 18.26}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.12, ["Neon|Ride"] = 52.5, ["Mega"] = 43.23, ["Mega|Ride"] = 115.63, ["Mega|Fly|Ride"] = 225.75}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 102.38, ["Fly"] = 1802.32, ["Ride"] = 105, ["Fly|Ride"] = 223.13, ["Neon"] = 412.13, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 645.75, ["Mega|Ride"] = 6754.78, ["Mega|Fly|Ride"] = 2077.7}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 18.38, ["Fly|Ride"] = 39.38, ["Neon"] = 10.5, ["Neon|Ride"] = 32.32, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 101.07, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 217.88}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 36.18, ["Ride"] = 27.57, ["Fly|Ride"] = 66.94, ["Neon"] = 5.86, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 418.69, ["Mega"] = 36.74, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 217.87}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 79.97, ["Neon"] = 7.87, ["Neon|Ride"] = 210, ["Mega"] = 76.62, ["Mega|Ride"] = 174.56, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.63, ["Neon"] = 9.85, ["Neon|Ride"] = 105, ["Mega"] = 140.44, ["Mega|Ride"] = 324.17}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 105, ["Ride"] = 288.48, ["Fly|Ride"] = 360.91, ["Neon"] = 560.33, ["Neon|Ride"] = 603.75, ["Neon|Fly|Ride"] = 907.72, ["Mega"] = 1837.5, ["Mega|Fly|Ride"] = 2585.63}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 10.48, ["Neon"] = 63.89, ["Mega"] = 426.57, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 648.33}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 420, ["Ride"] = 393.75, ["Fly|Ride"] = 681.72, ["Neon"] = 1069.69, ["Neon|Ride"] = 1478.18, ["Neon|Fly|Ride"] = 1224.57, ["Mega|Fly|Ride"] = 2756.25}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 73.5}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 47.25}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 18.43}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 15.73}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 54.74}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 124.69}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 21.62}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 11.9}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 192.95}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 14.22}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 29.89}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 9.19}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 9.19}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 1295.44}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 8.54}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 8.73}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 18.38}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 7.35}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 60.67}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 569.63}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 525}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 11.88}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1443.75}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 63.35}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 7.24}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 18.15}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 29.19}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 23.28}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 72.15}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 19.29}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 15.64}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 17.07}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.29}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 68.16}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.1}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 10.5}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 11.45}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 7.88}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 4.94}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 2018.43}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 104.01}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 256.66}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 5}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 4.33}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 9.69}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 9.72}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 32.48}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 262.5}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 9.19}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 33.18}},
    ["rbxassetid://1265129435"] = {name = "Gold Snowboard", prices = {["default"] = 156.76}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 164.07}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 43.56}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 9.14}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 43.23}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 16.23}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 4.33}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 105}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 26.25}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 15.31}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.63}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 23.67}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 9.69}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 6.21}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 27.57}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 101.88}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 399}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.63}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 8.6}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 11.71}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 27.56}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 111.54}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 24.94}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 17196}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 129.94}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 35.41}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 41.2}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 25.99}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 66.67}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 31.18}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 32.82}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 146.96}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 91.77}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 36.75}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 115.5}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 39.38}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 44.08}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 36.75}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 262.5}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 16.23}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 10.66}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 3.94}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 7.88}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 24.43}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 196.68}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.57}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 4.29}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 9.19}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 31.36}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 157.5}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 830.82}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 7.76}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 720.57}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 15.64}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.58}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 231}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 45.81}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 99.72}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 24.83}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 35.44}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 70.26}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 20.9}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 6.49}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 10.5}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.37}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 11.81}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 11.81}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 25.41}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.94}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.29}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 6.18}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 18.24}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 195.62}},
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
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 10.49}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 10.49}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 8.5}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 28.3}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 90.46}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 6.7}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 10.07}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 6.57}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 6.2}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 23.15}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 16.42}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 11.17}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 2.1}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 5.75}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 10.46}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 10.5}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.07}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 6.45}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 6.49}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 3.82}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 4.33}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 5.25}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 5.25}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7297.5}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 15.05}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3.52}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 6.22}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 5.24}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.62}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 18.59}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 12.98}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 5.08}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 4.99}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 3.92}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 6.54}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 6.57}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 3937.5}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 49.14}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 6.43}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.41}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 8.66}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 4.33}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 3.94}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 5.16}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 30.02}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.37}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.29}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 16.23}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 6.57}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 3.9}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 4.45}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.18}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 31.5}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 4.24}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 11.46}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 141.75}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 68.16}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 5.23}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 3.94}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1296.64}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 71.25}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 9.08}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 82.31}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 35.25}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 6.3}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 10.16}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 20.24}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 5.6}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 15.84}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 16.23}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 2.1}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 18.38}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 5.95}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.5}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 14.73}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 19.69}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 3.64}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 16.23}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 7.97}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 101.54}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 26.25}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 3.82}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 110.22}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 15.64}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.37}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.61}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 23.29}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 3.19}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 24.5}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 3.12}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 5.16}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 7.27}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 6.15}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 5.86}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 69.57}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 3.2}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.57}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 144.58}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 15.65}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1203.95}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.5}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 188.97}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 13.13}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.62}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 12.28}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 56.35}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 4.13}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 3.66}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 4.94}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 6.49}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 91.88}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 9.18}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 7.23}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 3.94}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.63}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 19.69}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 3.83}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 58.75}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 6.17}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 69.57}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.62}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 15.95}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 4.92}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 10.28}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 15.44}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 117.79}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 3.65}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 85.89}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 6.49}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 12.3}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.24}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.55}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 50.4}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.57}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 50.25}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 64.99}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 84.36}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 8.66}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 42.95}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 3.14}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 144.8}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 2.19}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.63}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 32.65}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 65.23}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 22.32}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 36.75}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 4.13}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 2.62}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 10.04}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 22.32}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 78.75}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 20.87}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 3.49}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 17.96}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 35.43}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 3.94}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 3.94}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 28.29}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 2.43}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 101.35}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 77.44}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 45.92}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 31.88}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1994.99}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 8.64}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 12.98}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 25.34}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 263.67}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 19.58}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 11.82}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 12.11}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 10.26}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 28.88}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 382.52}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 69.56}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 47.22}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 6.49}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 62.9}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 228.04}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 83.98}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1181.25}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 205.61}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 11.9}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1727.25}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 576.65}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 3.92}},
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