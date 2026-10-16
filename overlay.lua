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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1048.69, ["Ride"] = 1049.99, ["Fly|Ride"] = 1689.19, ["Neon"] = 6716.66, ["Neon|Fly|Ride"] = 5118.75, ["Mega|Fly|Ride"] = 20620.79}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 433.12, ["Fly"] = 640.43, ["Ride"] = 509.12, ["Fly|Ride"] = 544.69, ["Neon"] = 2088.53, ["Neon|Fly|Ride"] = 2114.97, ["Mega|Fly|Ride"] = 7000.5}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 6015.43, ["Ride"] = 4593.75, ["Fly|Ride"] = 4592.44, ["Neon|Fly|Ride"] = 24252.15, ["Mega|Fly|Ride"] = 70498.73}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 157.44, ["Ride"] = 223.13, ["Fly|Ride"] = 311.97, ["Neon"] = 1120.26, ["Neon|Ride"] = 971.83, ["Neon|Fly|Ride"] = 1056.44, ["Mega|Fly|Ride"] = 4371.62}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 548.63, ["Fly"] = 846, ["Ride"] = 505.32, ["Fly|Ride"] = 565.11, ["Neon|Fly|Ride"] = 1745.63, ["Mega|Fly|Ride"] = 6486.57}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 7.94, ["Ride"] = 58.46, ["Fly|Ride"] = 105, ["Neon"] = 71.47, ["Neon|Fly"] = 282.36, ["Neon|Ride"] = 84.62, ["Neon|Fly|Ride"] = 404.25, ["Mega"] = 350.21, ["Mega|Ride"] = 353.21, ["Mega|Fly|Ride"] = 564.71}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.25, ["Fly"] = 36.75, ["Ride"] = 29.72, ["Fly|Ride"] = 66.08, ["Neon"] = 31.38, ["Neon|Fly"] = 69.8, ["Neon|Ride"] = 56.8, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 184.02, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 298.37}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 98.44, ["Ride"] = 185.07, ["Fly|Ride"] = 208.69, ["Neon"] = 528.95, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 353.21, ["Mega"] = 1586.82, ["Mega|Ride"] = 2492.44, ["Mega|Fly|Ride"] = 2756.85}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 35.43, ["Fly"] = 80.37, ["Ride"] = 41.46, ["Fly|Ride"] = 104.7, ["Neon"] = 257.25, ["Neon|Ride"] = 197.76, ["Neon|Fly|Ride"] = 311.07, ["Mega"] = 1410.68, ["Mega|Ride"] = 1120.52, ["Mega|Fly|Ride"] = 918.74}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 23.63, ["Fly"] = 57.12, ["Ride"] = 27.45, ["Fly|Ride"] = 70.75, ["Neon"] = 208.71, ["Neon|Ride"] = 121.63, ["Neon|Fly|Ride"] = 184.02, ["Mega|Ride"] = 482.31, ["Mega|Fly|Ride"] = 705.34}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 58.47, ["Fly"] = 113.16, ["Ride"] = 65.63, ["Fly|Ride"] = 162.75, ["Neon"] = 341.84, ["Neon|Ride"] = 282.36, ["Neon|Fly|Ride"] = 425.25, ["Mega|Ride"] = 1255.24, ["Mega|Fly|Ride"] = 1268.98}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 73.4}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 334.45, ["Fly"] = 399, ["Ride"] = 320.27, ["Fly|Ride"] = 380.63, ["Neon"] = 1260.53, ["Neon|Ride"] = 1048.69, ["Neon|Fly|Ride"] = 1155, ["Mega|Fly|Ride"] = 5074.84}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 114.19, ["Fly"] = 169.21, ["Ride"] = 118.13, ["Fly|Ride"] = 174.2, ["Neon|Fly"] = 634.5, ["Neon|Ride"] = 573.57, ["Neon|Fly|Ride"] = 631.78, ["Mega|Fly|Ride"] = 3079.6}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.46, ["Fly"] = 34.13, ["Ride"] = 57.12, ["Fly|Ride"] = 131.25, ["Neon"] = 23.36, ["Neon|Ride"] = 48.01, ["Neon|Fly|Ride"] = 202.73, ["Mega"] = 150.94, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 239.95}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 142.93, ["Fly"] = 223.13, ["Ride"] = 210, ["Fly|Ride"] = 216.57, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 692.9, ["Mega|Fly|Ride"] = 3149.9}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.94, ["Fly"] = 25.58, ["Ride"] = 15.71, ["Fly|Ride"] = 40.2, ["Neon"] = 30.68, ["Neon|Fly"] = 126.92, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 206.22, ["Mega|Fly"] = 359.91, ["Mega|Ride"] = 320.34, ["Mega|Fly|Ride"] = 407.9}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 83.07, ["Fly"] = 160.72, ["Ride"] = 124.69, ["Fly|Ride"] = 236.79, ["Neon"] = 236.25, ["Neon|Ride"] = 387.05, ["Neon|Fly|Ride"] = 421.95, ["Mega"] = 1691.97, ["Mega|Ride"] = 1434.2, ["Mega|Fly|Ride"] = 1391.25}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 40.19}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 76.13, ["Ride"] = 229.99, ["Fly|Ride"] = 273.91, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 776.21, ["Mega|Fly|Ride"] = 2114.97}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 19.28, ["Fly"] = 55, ["Ride"] = 32.82, ["Fly|Ride"] = 355.69, ["Neon"] = 320.25, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 429.19, ["Mega"] = 2759.29, ["Mega|Ride"] = 705.34, ["Mega|Fly|Ride"] = 705.34}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 38.66, ["Fly"] = 78.75, ["Ride"] = 51.85, ["Fly|Ride"] = 103.59, ["Neon"] = 304.66, ["Neon|Ride"] = 217.88, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 1679.58, ["Mega|Ride"] = 1015.19, ["Mega|Fly|Ride"] = 800.21}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 39.29, ["Ride"] = 111.56, ["Fly|Ride"] = 196.88, ["Neon"] = 141.72, ["Neon|Ride"] = 380.72, ["Neon|Fly|Ride"] = 467.25, ["Mega"] = 1967.44, ["Mega|Ride"] = 1691.97, ["Mega|Fly|Ride"] = 1438.44}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 30.19, ["Ride"] = 33.42, ["Fly|Ride"] = 83.91, ["Neon"] = 120.65, ["Neon|Ride"] = 210.46, ["Neon|Fly|Ride"] = 252.75, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 38.07, ["Fly"] = 135.76, ["Ride"] = 54.86, ["Fly|Ride"] = 177.66, ["Neon"] = 175.13, ["Neon|Fly"] = 233.72, ["Neon|Ride"] = 212.79, ["Neon|Fly|Ride"] = 262.49, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 7.22, ["Fly"] = 26.25, ["Ride"] = 23.62, ["Fly|Ride"] = 52.47, ["Neon"] = 36.74, ["Neon|Fly"] = 109.15, ["Neon|Ride"] = 57.12, ["Neon|Fly|Ride"] = 91.86, ["Mega"] = 170.63, ["Mega|Ride"] = 177.57, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 399, ["Ride"] = 459.38, ["Fly|Ride"] = 421.95, ["Neon"] = 2114.97, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1964.82, ["Mega|Fly|Ride"] = 8459.81}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 6.57, ["Ride"] = 27.46, ["Fly|Ride"] = 65.63, ["Neon"] = 214.81, ["Neon|Ride"] = 129.94, ["Mega|Ride"] = 803.7, ["Mega|Fly|Ride"] = 923.2}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 6.48, ["Fly"] = 37.3, ["Ride"] = 19.21, ["Fly|Ride"] = 47.25, ["Neon"] = 52.49, ["Neon|Ride"] = 70.87, ["Neon|Fly|Ride"] = 125.98, ["Mega"] = 353.21, ["Mega|Ride"] = 315.93, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 84.26, ["Fly"] = 119.34, ["Ride"] = 103.16, ["Fly|Ride"] = 122.35, ["Neon"] = 368.02, ["Neon|Fly"] = 324.65, ["Neon|Ride"] = 363.8, ["Neon|Fly|Ride"] = 395.01, ["Mega"] = 6357.16, ["Mega|Ride"] = 5832.75, ["Mega|Fly|Ride"] = 2060.63}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 15.88, ["Ride"] = 32.24, ["Fly|Ride"] = 75.51, ["Neon"] = 95.45, ["Neon|Ride"] = 112.79, ["Neon|Fly|Ride"] = 184.02, ["Mega|Ride"] = 719.82}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 201.29, ["Fly"] = 262.5, ["Ride"] = 205.64, ["Fly|Ride"] = 291.38, ["Neon"] = 739.19, ["Neon|Ride"] = 705.34, ["Neon|Fly|Ride"] = 730.25, ["Mega"] = 3242.24, ["Mega|Fly|Ride"] = 2905.95}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 23.6}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.54, ["Fly"] = 32.81, ["Ride"] = 24.34, ["Fly|Ride"] = 55.13, ["Neon"] = 26.17, ["Neon|Fly"] = 141.72, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 105, ["Mega"] = 141.41, ["Mega|Ride"] = 168.15, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 786.19, ["Fly"] = 2625, ["Ride"] = 903.83, ["Fly|Ride"] = 918.75, ["Neon"] = 6343.82, ["Neon|Ride"] = 4794.61, ["Neon|Fly|Ride"] = 4723.77, ["Mega|Ride"] = 53985.9, ["Mega|Fly|Ride"] = 16919.62}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 12.5, ["Fly"] = 51.45, ["Ride"] = 38.05, ["Fly|Ride"] = 91.88, ["Neon"] = 156.53, ["Neon|Ride"] = 99.42, ["Neon|Fly|Ride"] = 181.13, ["Mega|Ride"] = 1082.87, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 145.69, ["Fly"] = 359.8, ["Ride"] = 251.51, ["Fly|Ride"] = 278.13, ["Neon"] = 830.82, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1030.31, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 4000.97}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 38.07}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 14.44, ["Fly"] = 126.92, ["Ride"] = 42.32, ["Fly|Ride"] = 141.72, ["Neon"] = 89.97, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 338.41, ["Mega"] = 353.22, ["Mega|Ride"] = 564.77, ["Mega|Fly|Ride"] = 593.85}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 110.11, ["Ride"] = 144.15, ["Fly|Ride"] = 269.67, ["Neon"] = 479.77, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 498.09, ["Mega"] = 2114.97, ["Mega|Fly|Ride"] = 1988.99}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 101.24, ["Fly"] = 157.49, ["Ride"] = 115.5, ["Fly|Ride"] = 262.5, ["Neon"] = 387.19, ["Neon|Fly"] = 564.71, ["Neon|Ride"] = 347.84, ["Neon|Fly|Ride"] = 493.5, ["Mega|Ride"] = 1378.13, ["Mega|Fly|Ride"] = 1240.32}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 44.63}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 52.5, ["Fly"] = 82.55, ["Ride"] = 52.5, ["Fly|Ride"] = 63.95, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 302.27, ["Mega"] = 4229.92, ["Mega|Fly|Ride"] = 1220.63}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 6.29, ["Fly"] = 98.44, ["Ride"] = 42, ["Fly|Ride"] = 205.11, ["Neon"] = 35.97, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 237.95, ["Mega"] = 170.62, ["Mega|Fly"] = 359.91, ["Mega|Ride"] = 272.85, ["Mega|Fly|Ride"] = 649.69}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 551.15, ["Fly"] = 591.14, ["Ride"] = 479.01, ["Fly|Ride"] = 526.56, ["Neon|Fly"] = 3806.93, ["Neon|Ride"] = 3020.16, ["Neon|Fly|Ride"] = 1756.13, ["Mega|Ride"] = 14804.67, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 91.88, ["Fly"] = 156.53, ["Ride"] = 128.35, ["Fly|Ride"] = 169.21, ["Neon"] = 479.07, ["Neon|Ride"] = 556.5, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 2537.96, ["Mega|Fly|Ride"] = 2550.64}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 4229.92, ["Ride"] = 3885, ["Fly|Ride"] = 3806.93, ["Neon|Fly|Ride"] = 14803.61}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 45.94, ["Fly"] = 120.58, ["Ride"] = 45.94, ["Fly|Ride"] = 131.25, ["Neon"] = 438.86, ["Neon|Ride"] = 312.38, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 1901.36, ["Mega|Ride"] = 1805.12, ["Mega|Fly|Ride"] = 1647.19}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 73.5, ["Ride"] = 65.63, ["Fly|Ride"] = 141.72, ["Neon"] = 640.49, ["Neon|Ride"] = 427.88, ["Neon|Fly|Ride"] = 426.05, ["Mega"] = 6204.23, ["Mega|Ride"] = 2388.75, ["Mega|Fly|Ride"] = 1845.36}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 31.66, ["Fly"] = 52.5, ["Ride"] = 41.6, ["Fly|Ride"] = 84, ["Neon"] = 130.23, ["Neon|Fly"] = 287.87, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 199.4, ["Mega"] = 987.7, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 6.36}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 45.72, ["Ride"] = 37.66, ["Fly|Ride"] = 80.38, ["Neon|Ride"] = 211.52, ["Neon|Fly|Ride"] = 423.01, ["Mega|Ride"] = 1280.08, ["Mega|Fly|Ride"] = 1505.86}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 36.75}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 223.13, ["Ride"] = 184.02, ["Fly|Ride"] = 282.19, ["Neon|Ride"] = 1114.59, ["Neon|Fly|Ride"] = 1095.56, ["Mega|Fly|Ride"] = 4559.84}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 635.23, ["Ride"] = 623.7, ["Fly|Ride"] = 783.57, ["Neon"] = 2625, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 10877.56}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 6.56}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 26.14, ["Fly"] = 59.07, ["Ride"] = 34.88, ["Fly|Ride"] = 72.35, ["Neon"] = 219.97, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 220.48, ["Mega"] = 2114.97, ["Mega|Ride"] = 1159.45, ["Mega|Fly|Ride"] = 761.24}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 15.75}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5250, ["Ride"] = 5650.32, ["Fly|Ride"] = 4528.13, ["Neon|Ride"] = 17592.82, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 36790.8}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 9.12, ["Fly"] = 55.11, ["Ride"] = 20.79, ["Fly|Ride"] = 55.86, ["Neon"] = 82.69, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 128.38, ["Mega"] = 561.75, ["Mega|Ride"] = 490.88, ["Mega|Fly|Ride"] = 599.65}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 13.02, ["Fly"] = 138.54, ["Ride"] = 30.19, ["Neon"] = 105.76, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 739.19, ["Mega|Ride"] = 823.71, ["Mega|Fly|Ride"] = 987.7}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 61.41, ["Ride"] = 58.7, ["Fly|Ride"] = 90.96, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 480.96, ["Mega"] = 4229.92, ["Mega|Fly|Ride"] = 1759.95}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 7.76, ["Fly"] = 70.87, ["Ride"] = 26.16, ["Fly|Ride"] = 61.69, ["Neon"] = 56.16, ["Neon|Ride"] = 148.32, ["Neon|Fly|Ride"] = 501.38, ["Mega"] = 1410.68, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1748.17, ["Fly"] = 2045.17, ["Ride"] = 1638, ["Fly|Ride"] = 1575, ["Neon|Fly|Ride"] = 3087, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 27562.5, ["Fly"] = 33839.23, ["Ride"] = 52500, ["Fly|Ride"] = 27300, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 56437.5, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 20.9, ["Fly"] = 393.75, ["Ride"] = 45.94, ["Fly|Ride"] = 126.92, ["Neon"] = 282.36, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 564.71, ["Mega"] = 987.7, ["Mega|Ride"] = 1141.88, ["Mega|Fly|Ride"] = 1377.26}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.29, ["Fly"] = 63, ["Ride"] = 48.2, ["Fly|Ride"] = 147, ["Neon"] = 26.25, ["Neon|Fly"] = 113.16, ["Neon|Ride"] = 58.59, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 124.69, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 378.59}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 24.94}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 6.34, ["Ride"] = 36.75, ["Fly|Ride"] = 105, ["Neon"] = 58.46, ["Neon|Ride"] = 116.8, ["Neon|Fly|Ride"] = 211.52, ["Mega"] = 380.71, ["Mega|Ride"] = 421.45, ["Mega|Fly|Ride"] = 685.26}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 654.94, ["Fly"] = 799.93, ["Ride"] = 681.41, ["Fly|Ride"] = 794.54, ["Neon"] = 2749.45, ["Neon|Ride"] = 2791.74, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 9447.51}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 787.5, ["Fly"] = 1057.49, ["Ride"] = 938.33, ["Fly|Ride"] = 984.38, ["Neon"] = 4089.27, ["Neon|Ride"] = 3270.99, ["Neon|Fly|Ride"] = 3675, ["Mega|Fly|Ride"] = 11562.45}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 14.44, ["Fly"] = 119.94, ["Ride"] = 29.97, ["Fly|Ride"] = 72.19, ["Neon"] = 85.3, ["Neon|Ride"] = 104.7, ["Neon|Fly|Ride"] = 161.21, ["Mega"] = 1209.02, ["Mega|Ride"] = 481.69, ["Mega|Fly|Ride"] = 556.24}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 22.32}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 66.18, ["Fly"] = 119.94, ["Ride"] = 85.29, ["Fly|Ride"] = 113.16, ["Neon"] = 593.72, ["Neon|Ride"] = 486.45, ["Neon|Fly|Ride"] = 374.07, ["Mega"] = 19687.5, ["Mega|Ride"] = 2070.56, ["Mega|Fly|Ride"] = 2088.53}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 78.75, ["Ride"] = 102.89, ["Fly|Ride"] = 183.75, ["Neon"] = 420, ["Neon|Ride"] = 386.78, ["Neon|Fly|Ride"] = 423.01, ["Mega"] = 1402.71, ["Mega|Fly|Ride"] = 1909.89}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.91, ["Fly"] = 28.37, ["Ride"] = 16.75, ["Fly|Ride"] = 42.63, ["Neon"] = 44.63, ["Neon|Fly"] = 524.98, ["Neon|Ride"] = 57.12, ["Neon|Fly|Ride"] = 160.78, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 142.38, ["Fly"] = 167.84, ["Ride"] = 165.08, ["Fly|Ride"] = 229.59, ["Neon"] = 600.64, ["Neon|Ride"] = 576.19, ["Neon|Fly|Ride"] = 590.63, ["Mega"] = 5075.89, ["Mega|Fly|Ride"] = 2493.74}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.6, ["Ride"] = 47.07, ["Fly|Ride"] = 184.02, ["Neon"] = 30.68, ["Neon|Fly"] = 169.21, ["Neon|Ride"] = 112.75, ["Neon|Fly|Ride"] = 211.52, ["Mega"] = 191.02, ["Mega|Fly"] = 336.3, ["Mega|Ride"] = 342.01, ["Mega|Fly|Ride"] = 417.9}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 11.34, ["Fly"] = 63.47, ["Ride"] = 32.4, ["Fly|Ride"] = 77.31, ["Neon"] = 128.63, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 663.05, ["Mega|Ride"] = 818.5, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 36.75, ["Ride"] = 60.29, ["Fly|Ride"] = 156.19, ["Neon"] = 208.71, ["Neon|Ride"] = 223.13, ["Mega"] = 918.75, ["Mega|Ride"] = 1161.57, ["Mega|Fly|Ride"] = 634.5}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 16.52, ["Fly"] = 211.52, ["Ride"] = 35.97, ["Fly|Ride"] = 47.15, ["Neon"] = 91.88, ["Neon|Ride"] = 116.94, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1111.42}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6300, ["Ride"] = 6555.94, ["Fly|Ride"] = 5643.75, ["Neon"] = 35249.9, ["Neon|Ride"] = 24937.5, ["Neon|Fly|Ride"] = 24956.44}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 216.57, ["Fly"] = 242.16, ["Ride"] = 227.64, ["Fly|Ride"] = 262.5, ["Neon"] = 705.34, ["Neon|Fly|Ride"] = 551.25, ["Mega|Fly|Ride"] = 1857.19}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 49.27, ["Fly"] = 148.87, ["Ride"] = 98.63, ["Fly|Ride"] = 211.32, ["Neon"] = 156.19, ["Neon|Fly"] = 320.25, ["Neon|Ride"] = 162.31, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 446.25, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 577.68}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 88.76, ["Ride"] = 18.38, ["Fly|Ride"] = 52.49, ["Neon"] = 24.72, ["Neon|Fly"] = 69.8, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 499.8, ["Mega|Ride"] = 330.75, ["Mega|Fly|Ride"] = 358.73}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 61.65, ["Fly"] = 164.07, ["Ride"] = 80.39, ["Fly|Ride"] = 207.8, ["Neon"] = 183.75, ["Neon|Fly"] = 438.86, ["Neon|Ride"] = 258.58, ["Neon|Fly|Ride"] = 387.18, ["Mega"] = 557.52, ["Mega|Ride"] = 705.34, ["Mega|Fly|Ride"] = 678.82}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 14384.99, ["Ride"] = 13415.07, ["Fly|Ride"] = 12468.75, ["Neon|Fly|Ride"] = 27193.3, ["Mega|Fly|Ride"] = 112797.75}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 271.69, ["Ride"] = 317.2, ["Fly|Ride"] = 459.38, ["Neon"] = 1607.38, ["Neon|Ride"] = 1128.35, ["Neon|Fly|Ride"] = 1607.38, ["Mega|Fly|Ride"] = 7190.86}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 47.39, ["Fly"] = 80.59, ["Ride"] = 39.38, ["Fly|Ride"] = 95.82, ["Neon"] = 401.85, ["Neon|Ride"] = 328.11, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 3066.7}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 9.98, ["Fly"] = 28.56, ["Ride"] = 19.69, ["Fly|Ride"] = 64.78, ["Neon"] = 67.46, ["Neon|Ride"] = 63.47, ["Neon|Fly|Ride"] = 157.48, ["Mega"] = 393.75, ["Mega|Ride"] = 454.7, ["Mega|Fly|Ride"] = 1057.49}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 367.5, ["Fly"] = 846, ["Ride"] = 420, ["Fly|Ride"] = 513.18, ["Neon"] = 1660.67, ["Neon|Ride"] = 1376.75, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 5066.38}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.29, ["Fly"] = 104.7, ["Ride"] = 41.95, ["Fly|Ride"] = 185.27, ["Neon"] = 33.97, ["Neon|Ride"] = 85.41, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 144.38, ["Mega|Ride"] = 197.76, ["Mega|Fly|Ride"] = 311.97}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 103.68, ["Fly"] = 164.07, ["Ride"] = 131.25, ["Fly|Ride"] = 170.63, ["Neon"] = 381.94, ["Neon|Fly"] = 525, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 508.78, ["Mega|Ride"] = 1776.58, ["Mega|Fly|Ride"] = 2114.97}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 12.07, ["Fly"] = 17.16, ["Ride"] = 15.75, ["Fly|Ride"] = 32.81, ["Neon"] = 160.74, ["Neon|Fly"] = 80.64, ["Neon|Ride"] = 196.86, ["Neon|Fly|Ride"] = 78.72, ["Mega"] = 2537.96, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 9.45}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 64.32, ["Ride"] = 58.97, ["Fly|Ride"] = 211.52, ["Neon"] = 423.01, ["Neon|Fly"] = 421.95, ["Neon|Ride"] = 406.87, ["Neon|Fly|Ride"] = 430.5, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 1600.39}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 11.69, ["Fly"] = 78.27, ["Ride"] = 31.2, ["Fly|Ride"] = 65.35, ["Neon"] = 98.44, ["Neon|Ride"] = 115.77, ["Neon|Fly|Ride"] = 183.88, ["Mega"] = 599.86, ["Mega|Ride"] = 564.71, ["Mega|Fly|Ride"] = 423.01}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 36.37}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 51, ["Fly"] = 141.72, ["Ride"] = 101.07, ["Fly|Ride"] = 282.36, ["Neon"] = 297.47, ["Neon|Ride"] = 282.36, ["Neon|Fly|Ride"] = 282.36, ["Mega|Fly|Ride"] = 1656.02}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.14, ["Ride"] = 29.22, ["Fly|Ride"] = 136.57, ["Neon"] = 21.32, ["Neon|Ride"] = 112.75, ["Neon|Fly|Ride"] = 253.81, ["Mega"] = 144.93, ["Mega|Ride"] = 213.42, ["Mega|Fly|Ride"] = 423.01}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 11.57, ["Fly"] = 56.44, ["Ride"] = 31.75, ["Fly|Ride"] = 85.22, ["Neon"] = 160.74, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 189.31, ["Mega|Ride"] = 423.01, ["Mega|Fly|Ride"] = 586.69}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 431.82, ["Fly"] = 565.76, ["Ride"] = 505.32, ["Fly|Ride"] = 541.66, ["Neon|Fly|Ride"] = 2748.43, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 38.05, ["Fly"] = 105.76, ["Ride"] = 57.61, ["Fly|Ride"] = 107.63, ["Neon"] = 129.94, ["Neon|Ride"] = 210.97, ["Neon|Fly|Ride"] = 329.95, ["Mega|Ride"] = 592.2, ["Mega|Fly|Ride"] = 492.77}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 49.13, ["Fly"] = 141.72, ["Ride"] = 52.5, ["Fly|Ride"] = 121.63, ["Neon"] = 317.25, ["Neon|Ride"] = 199.5, ["Neon|Fly|Ride"] = 322.88, ["Mega|Fly|Ride"] = 939.06}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 20.85, ["Ride"] = 71.69, ["Fly|Ride"] = 103.69, ["Neon"] = 72.19, ["Neon|Ride"] = 175.22, ["Neon|Fly|Ride"] = 354.38, ["Mega"] = 423.01, ["Mega|Fly"] = 525, ["Mega|Ride"] = 366.96, ["Mega|Fly|Ride"] = 590.09}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 10500, ["Ride"] = 8862, ["Fly|Ride"] = 7743.75, ["Neon|Fly|Ride"] = 15592.5, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1326.12, ["Fly"] = 1486.7, ["Ride"] = 1273.51, ["Fly|Ride"] = 1378.13, ["Neon|Fly|Ride"] = 4772.25, ["Mega|Fly|Ride"] = 15511.06}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 543.56, ["Ride"] = 625.07, ["Fly|Ride"] = 704.29, ["Neon"] = 3612.66, ["Neon|Fly|Ride"] = 3187.7, ["Mega"] = 21149.51, ["Mega|Fly|Ride"] = 8459.81}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 10.5, ["Fly"] = 22.97, ["Ride"] = 22.75, ["Fly|Ride"] = 35.44, ["Neon"] = 63.47, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 122.68, ["Mega|Fly|Ride"] = 572.25}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 4.59, ["Fly"] = 78.74, ["Ride"] = 32.24, ["Fly|Ride"] = 157.5, ["Neon"] = 24.86, ["Neon|Ride"] = 54.94, ["Mega"] = 160.13, ["Mega|Ride"] = 184.02, ["Mega|Fly|Ride"] = 264.38}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 32.21, ["Fly"] = 52.5, ["Ride"] = 47.25, ["Fly|Ride"] = 98.43, ["Neon"] = 200.93, ["Neon|Ride"] = 150.92, ["Neon|Fly|Ride"] = 182.34, ["Mega|Ride"] = 740.24, ["Mega|Fly|Ride"] = 666.75}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.47, ["Fly"] = 21.16, ["Ride"] = 15.98, ["Fly|Ride"] = 37.22, ["Neon"] = 44.43, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 96.06, ["Mega"] = 288.75, ["Mega|Ride"] = 714.25, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 324.65, ["Fly"] = 369.5, ["Ride"] = 301.14, ["Fly|Ride"] = 354.36, ["Neon"] = 1600.02, ["Neon|Ride"] = 1305.26, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 3653.85}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 15.6, ["Fly"] = 59.97, ["Ride"] = 28.56, ["Fly|Ride"] = 84.62, ["Neon"] = 131.25, ["Neon|Fly"] = 308.44, ["Neon|Ride"] = 141.7, ["Neon|Fly|Ride"] = 242.82, ["Mega"] = 663.05, ["Mega|Ride"] = 423.01, ["Mega|Fly|Ride"] = 695}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 9.05, ["Fly"] = 19.69, ["Ride"] = 18.8, ["Fly|Ride"] = 40.68, ["Neon"] = 82.49, ["Neon|Fly"] = 120.57, ["Neon|Ride"] = 70.83, ["Neon|Fly|Ride"] = 104.21, ["Mega"] = 1575, ["Mega|Ride"] = 604.66, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 564.71, ["Fly"] = 1048.69, ["Ride"] = 540.75, ["Fly|Ride"] = 420, ["Mega|Fly|Ride"] = 12266.72}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1102.4, ["Ride"] = 1148.44, ["Fly|Ride"] = 1256.68, ["Neon"] = 4935.26, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 11985.44}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 137.82, ["Fly"] = 138.54, ["Ride"] = 113.16, ["Fly|Ride"] = 120.75, ["Neon"] = 583.74, ["Neon|Ride"] = 581.63, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 2536.9}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 164.07, ["Fly"] = 212.13, ["Ride"] = 157.31, ["Fly|Ride"] = 236.25, ["Neon"] = 536.19, ["Neon|Ride"] = 764.57, ["Neon|Fly|Ride"] = 648.54, ["Mega|Ride"] = 9187.5, ["Mega|Fly|Ride"] = 2914.42}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 29.04, ["Fly"] = 57.12, ["Ride"] = 32.71, ["Fly|Ride"] = 113.6, ["Neon"] = 236.24, ["Neon|Ride"] = 238.13, ["Mega|Ride"] = 1410.68, ["Mega|Fly|Ride"] = 1070.19}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 240.06, ["Ride"] = 315, ["Fly|Ride"] = 409.25, ["Neon"] = 1220.63, ["Neon|Fly|Ride"] = 1128.35, ["Mega"] = 5640.59, ["Mega|Fly|Ride"] = 5640.59}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2284.16, ["Ride"] = 1670.71, ["Fly|Ride"] = 1837.48, ["Mega|Fly|Ride"] = 31992.05}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 26.25, ["Fly"] = 211.52, ["Ride"] = 52.41, ["Fly|Ride"] = 196.88, ["Neon"] = 288.75, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 266.51, ["Mega"] = 1410.68, ["Mega|Ride"] = 1128.35, ["Mega|Fly|Ride"] = 987.7}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 570.94, ["Fly"] = 846, ["Ride"] = 576.18, ["Fly|Ride"] = 639.33, ["Neon|Ride"] = 1498.88, ["Neon|Fly|Ride"] = 1152.38, ["Mega|Fly|Ride"] = 3451.65}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 45.92, ["Fly"] = 59.07, ["Ride"] = 52.81, ["Fly|Ride"] = 74.81, ["Neon"] = 262.5, ["Neon|Ride"] = 235.1, ["Neon|Fly|Ride"] = 232.59, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.77, ["Fly"] = 42, ["Ride"] = 17.33, ["Fly|Ride"] = 49.69, ["Neon"] = 26.25, ["Neon|Fly"] = 105, ["Neon|Ride"] = 48.92, ["Neon|Fly|Ride"] = 102.21, ["Mega"] = 170.62, ["Mega|Ride"] = 184.99, ["Mega|Fly|Ride"] = 280.89}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 53.67, ["Ride"] = 128.34, ["Fly|Ride"] = 205.16, ["Neon"] = 262.4, ["Neon|Ride"] = 430.17, ["Neon|Fly|Ride"] = 705.34, ["Mega"] = 1546.05, ["Mega|Ride"] = 1543.94}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 774.38, ["Fly"] = 1092, ["Ride"] = 826.88, ["Fly|Ride"] = 909.03, ["Neon|Ride"] = 3254.99, ["Neon|Fly|Ride"] = 2966.64, ["Mega|Fly|Ride"] = 12319.6}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 645.75, ["Ride"] = 589.32, ["Fly|Ride"] = 846, ["Neon|Fly|Ride"] = 4220.41, ["Mega|Fly|Ride"] = 15367.25}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 12.52, ["Fly"] = 21, ["Ride"] = 22.76, ["Fly|Ride"] = 45.48, ["Neon"] = 144.38, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 800.21, ["Mega|Ride"] = 480.11, ["Mega|Fly|Ride"] = 701.12}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 10.83, ["Ride"] = 26.25, ["Fly|Ride"] = 90.96, ["Neon"] = 186.38, ["Neon|Ride"] = 156.53, ["Neon|Fly|Ride"] = 210, ["Mega"] = 846.57, ["Mega|Ride"] = 663.05, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 5.91, ["Fly"] = 64.72, ["Ride"] = 19.69, ["Fly|Ride"] = 111.57, ["Neon"] = 21.94, ["Neon|Fly"] = 321.5, ["Neon|Ride"] = 64.78, ["Neon|Fly|Ride"] = 211.46, ["Mega"] = 176.58, ["Mega|Ride"] = 202.6, ["Mega|Fly|Ride"] = 355.6}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 36.26, ["Fly"] = 51.18, ["Ride"] = 46.86, ["Fly|Ride"] = 93.19, ["Neon"] = 293.02, ["Neon|Ride"] = 220.5, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 945.37, ["Mega|Fly|Ride"] = 959.06}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 77.44, ["Ride"] = 129.94, ["Fly|Ride"] = 353.21, ["Neon"] = 428.35, ["Neon|Ride"] = 564.71, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2256.68, ["Mega|Ride"] = 2114.97, ["Mega|Fly|Ride"] = 1691.97}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 12.65, ["Fly"] = 45.94, ["Ride"] = 37.96, ["Fly|Ride"] = 76.77, ["Neon"] = 105.76, ["Neon|Fly"] = 113.16, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 145.53, ["Mega"] = 425.39, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 447.4}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 28.88, ["Fly"] = 65.63, ["Ride"] = 41.91, ["Fly|Ride"] = 84.11, ["Neon"] = 308.8, ["Neon|Fly"] = 1410.68, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 234.94, ["Mega"] = 2100, ["Mega|Ride"] = 1195.86, ["Mega|Fly|Ride"] = 1241.63}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.68, ["Fly"] = 27.18, ["Ride"] = 17.41, ["Fly|Ride"] = 44.6, ["Neon"] = 23.54, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 70.87, ["Mega"] = 740.24, ["Mega|Ride"] = 479.9, ["Mega|Fly|Ride"] = 527.7}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.64, ["Fly"] = 49.88, ["Ride"] = 19.69, ["Fly|Ride"] = 63.58, ["Neon"] = 37.41, ["Neon|Fly"] = 109.99, ["Neon|Ride"] = 79.97, ["Neon|Fly|Ride"] = 100.47, ["Mega"] = 416.07, ["Mega|Ride"] = 353.21, ["Mega|Fly|Ride"] = 439.69}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 57.12, ["Fly"] = 56.21, ["Ride"] = 53.82, ["Fly|Ride"] = 96.73, ["Neon"] = 525, ["Neon|Fly"] = 211.3, ["Neon|Ride"] = 214.67, ["Neon|Fly|Ride"] = 229.59, ["Mega|Fly|Ride"] = 1074.92}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1378.13, ["Fly"] = 1410.93, ["Ride"] = 1351.88, ["Fly|Ride"] = 1460.82, ["Neon|Fly|Ride"] = 3790.49, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 467.25, ["Fly"] = 713.82, ["Ride"] = 393.75, ["Fly|Ride"] = 478.96, ["Neon|Ride"] = 2820.3, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 14804.67, ["Mega|Fly|Ride"] = 9305.8}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 281.25, ["Ride"] = 320.22, ["Fly|Ride"] = 458.96, ["Neon"] = 1268.98, ["Neon|Ride"] = 1522.5, ["Neon|Fly|Ride"] = 1374.74}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 40.03}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 24.5, ["Ride"] = 32.71, ["Fly|Ride"] = 97.12, ["Neon"] = 325.5, ["Neon|Ride"] = 206.22, ["Neon|Fly|Ride"] = 354.38, ["Mega|Ride"] = 1551.34, ["Mega|Fly|Ride"] = 1036.54}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 73319.02, ["Fly"] = 23264.48, ["Ride"] = 23985.57, ["Fly|Ride"] = 18090.19, ["Neon|Fly|Ride"] = 37800, ["Mega"] = 211495.08, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 223.13, ["Fly"] = 262.5, ["Ride"] = 238.88, ["Fly|Ride"] = 292.15, ["Neon"] = 1039.98, ["Neon|Fly"] = 853.13, ["Neon|Ride"] = 937.1, ["Neon|Fly|Ride"] = 797.7, ["Mega"] = 4229.92, ["Mega|Ride"] = 4228.86, ["Mega|Fly|Ride"] = 3424.84}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 216.46, ["Fly"] = 525, ["Ride"] = 210.46, ["Fly|Ride"] = 257.23, ["Neon|Fly|Ride"] = 1759.95}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 128.63, ["Fly"] = 144.38, ["Ride"] = 150.94, ["Fly|Ride"] = 259.88, ["Neon|Ride"] = 524.99, ["Neon|Fly|Ride"] = 383.91, ["Mega|Ride"] = 2254.55, ["Mega|Fly|Ride"] = 2918.65}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 11.58, ["Fly"] = 65.63, ["Ride"] = 26.25, ["Fly|Ride"] = 84.62, ["Neon"] = 141.72, ["Neon|Ride"] = 99.43, ["Neon|Fly|Ride"] = 705.34, ["Mega"] = 717.44, ["Mega|Ride"] = 705.34, ["Mega|Fly|Ride"] = 925.31}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3871.88, ["Ride"] = 3885, ["Fly|Ride"] = 4003.13, ["Neon"] = 27494.37, ["Neon|Fly|Ride"] = 15750}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 27.14, ["Fly"] = 45.94, ["Ride"] = 27.97, ["Fly|Ride"] = 50.09, ["Neon"] = 131.25, ["Neon|Ride"] = 211.52, ["Neon|Fly|Ride"] = 198.55, ["Mega|Ride"] = 1410.68, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 42, ["Ride"] = 41.91, ["Fly|Ride"] = 102.79, ["Neon"] = 314.26, ["Neon|Fly"] = 1410.68, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 262.48, ["Mega|Fly|Ride"] = 1374.19}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 420, ["Fly"] = 557.43, ["Ride"] = 474.3, ["Fly|Ride"] = 579.83, ["Neon"] = 1256.07, ["Neon|Ride"] = 1154.9, ["Neon|Fly|Ride"] = 1298.06, ["Mega|Ride"] = 6767.85, ["Mega|Fly|Ride"] = 9187.5}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 16.29, ["Fly"] = 22.84, ["Ride"] = 23.28, ["Fly|Ride"] = 45.94, ["Neon"] = 123.38, ["Neon|Fly"] = 159.69, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 141.74, ["Mega|Ride"] = 776.21, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 10.91, ["Ride"] = 26.24, ["Fly|Ride"] = 80.15, ["Neon"] = 84.62, ["Neon|Ride"] = 94.54, ["Neon|Fly|Ride"] = 209.08, ["Mega|Ride"] = 743.81, ["Mega|Fly|Ride"] = 719.82}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 108.94, ["Ride"] = 103.69, ["Fly|Ride"] = 207.27, ["Neon"] = 1010.63, ["Neon|Ride"] = 637.79, ["Neon|Fly|Ride"] = 1128.35, ["Mega|Fly|Ride"] = 2719.71}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 14.96, ["Fly"] = 126.92, ["Ride"] = 65.62, ["Fly|Ride"] = 164.98, ["Neon"] = 43.64, ["Neon|Ride"] = 91.83, ["Neon|Fly|Ride"] = 236.23, ["Mega"] = 231, ["Mega|Ride"] = 294.67, ["Mega|Fly|Ride"] = 425.36}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3911.15, ["Fly"] = 6236.26, ["Ride"] = 3883.68, ["Fly|Ride"] = 4042.5, ["Neon"] = 14804.67, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 10328.07, ["Mega"] = 42297.97, ["Mega|Fly|Ride"] = 37945.69}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 32.8, ["Fly"] = 42, ["Ride"] = 70.22, ["Fly|Ride"] = 157.5, ["Neon"] = 395.52, ["Neon|Ride"] = 258.56, ["Neon|Fly|Ride"] = 395.92, ["Mega"] = 846, ["Mega|Ride"] = 1759.95, ["Mega|Fly|Ride"] = 782.25}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7875, ["Fly"] = 7613.84, ["Ride"] = 6857.82, ["Fly|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 13125, ["Mega|Fly|Ride"] = 46921.88}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.8, ["Fly"] = 17.88, ["Ride"] = 15.65, ["Fly|Ride"] = 32.4, ["Neon"] = 24.68, ["Neon|Fly"] = 57.12, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 241.13, ["Mega|Ride"] = 372.75, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 15.23, ["Fly"] = 21, ["Ride"] = 26.25, ["Fly|Ride"] = 57.12, ["Neon"] = 141.72, ["Neon|Fly"] = 233.72, ["Neon|Ride"] = 141.72, ["Neon|Fly|Ride"] = 164.66, ["Mega|Ride"] = 987.7, ["Mega|Fly|Ride"] = 924.26}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.93}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 10.68, ["Ride"] = 26.59, ["Fly|Ride"] = 57.66, ["Neon"] = 98.44, ["Neon|Ride"] = 92.7, ["Mega"] = 1049.9, ["Mega|Ride"] = 888.29, ["Mega|Fly|Ride"] = 794.18}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 27.5, ["Fly"] = 190.37, ["Ride"] = 46.55, ["Fly|Ride"] = 99.74, ["Neon"] = 156.53, ["Neon|Ride"] = 170.33, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 945, ["Mega|Ride"] = 846, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 12.29, ["Fly"] = 25.64, ["Ride"] = 18.38, ["Fly|Ride"] = 34.73, ["Neon|Fly"] = 1054.31, ["Neon|Ride"] = 117.39, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 2537.96, ["Mega|Fly|Ride"] = 531.57}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8600.48}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.99}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 23.63}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 236.04, ["Ride"] = 388.12, ["Fly|Ride"] = 259.88, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 15, ["Fly"] = 134.32, ["Ride"] = 35.43, ["Fly|Ride"] = 126.92, ["Neon"] = 84.62, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 525, ["Mega|Ride"] = 531.57, ["Mega|Fly|Ride"] = 1179.94}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 11.11}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 8.84, ["Ride"] = 25.99, ["Fly|Ride"] = 84.62, ["Neon|Ride"] = 249.38}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2605.67}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 128.63, ["Fly"] = 336.3, ["Ride"] = 141.72, ["Fly|Ride"] = 423.01, ["Neon"] = 918.75, ["Neon|Ride"] = 844.93, ["Neon|Fly|Ride"] = 1551.34, ["Mega|Ride"] = 4089.27, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 65.63, ["Fly"] = 211.52, ["Ride"] = 91.88, ["Fly|Ride"] = 211.52, ["Neon"] = 658.82, ["Neon|Ride"] = 494.82, ["Neon|Fly|Ride"] = 931.66, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 157.46, ["Fly"] = 315, ["Ride"] = 170.63, ["Fly|Ride"] = 236.99, ["Neon"] = 944.98, ["Neon|Ride"] = 787.49, ["Neon|Fly|Ride"] = 849.79, ["Mega|Ride"] = 3243.3, ["Mega|Fly|Ride"] = 3107.23}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2388.74, ["Fly"] = 3243.3, ["Ride"] = 2231.25, ["Fly|Ride"] = 2270.63, ["Neon"] = 14853.32, ["Neon|Ride"] = 8395.82, ["Neon|Fly|Ride"] = 5906.25, ["Mega|Fly|Ride"] = 25593.75}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 15.75, ["Fly"] = 70.87, ["Ride"] = 57.12, ["Fly|Ride"] = 100.91, ["Neon"] = 127.32, ["Neon|Fly"] = 160.74, ["Neon|Ride"] = 154.62, ["Neon|Fly|Ride"] = 242.82, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 818.5, ["Fly"] = 2100, ["Ride"] = 874.55, ["Fly|Ride"] = 774.38, ["Neon|Fly|Ride"] = 4159.33}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 42}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 14.7, ["Ride"] = 51.58, ["Fly|Ride"] = 338.24, ["Neon"] = 94.5, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 105.76, ["Neon|Fly|Ride"] = 254.63, ["Mega"] = 451.78, ["Mega|Fly"] = 959.77, ["Mega|Ride"] = 493.85, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 5.2, ["Fly"] = 47.98, ["Ride"] = 27.5, ["Fly|Ride"] = 104.7, ["Neon"] = 39.38, ["Neon|Fly"] = 315, ["Neon|Ride"] = 61.35, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 448.69, ["Mega|Ride"] = 393.75}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 60.38}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 19.79, ["Fly"] = 105.68, ["Ride"] = 21.3, ["Fly|Ride"] = 78.74, ["Neon|Ride"] = 191.91, ["Neon|Fly|Ride"] = 254.62, ["Mega|Ride"] = 987.7, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 25.08, ["Fly"] = 39.38, ["Ride"] = 33.54, ["Fly|Ride"] = 52.41, ["Neon|Fly"] = 233.72, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 1439.64, ["Mega|Ride"] = 1799.55, ["Mega|Fly|Ride"] = 989.63}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6037.5, ["Fly"] = 10237.5, ["Ride"] = 6236.26, ["Fly|Ride"] = 5050.5, ["Neon|Fly|Ride"] = 9843.75, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 8.44, ["Fly"] = 65.62, ["Ride"] = 28.43, ["Fly|Ride"] = 81.37, ["Neon"] = 51.98, ["Neon|Ride"] = 62.9, ["Neon|Fly|Ride"] = 168.15, ["Mega"] = 507.61, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 493.85}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 19.66}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 91.88, ["Fly"] = 374.36, ["Ride"] = 111.46, ["Fly|Ride"] = 160.09, ["Neon"] = 531.57, ["Neon|Ride"] = 399.71, ["Neon|Fly|Ride"] = 643.13, ["Mega|Ride"] = 2256.68, ["Mega|Fly|Ride"] = 2096.99}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 45.94, ["Fly"] = 141.72, ["Ride"] = 74.82, ["Fly|Ride"] = 181.91, ["Neon"] = 284.82, ["Neon|Ride"] = 274.96, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2399.38, ["Mega|Ride"] = 2855.21, ["Mega|Fly|Ride"] = 1028.99}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 17.82, ["Fly"] = 48.99, ["Ride"] = 28.56, ["Fly|Ride"] = 64.32, ["Neon"] = 128.77, ["Neon|Fly"] = 228.43, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 203.44, ["Mega|Ride"] = 863.8, ["Mega|Fly|Ride"] = 783.56}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 5.25, ["Fly"] = 68.95, ["Ride"] = 21.82, ["Fly|Ride"] = 63.47, ["Neon"] = 31.5, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 57.54, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 137.82, ["Mega|Ride"] = 197.76, ["Mega|Fly|Ride"] = 287.05}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 10.48, ["Fly"] = 42.32, ["Ride"] = 26.25, ["Fly|Ride"] = 97.95, ["Neon"] = 91.56, ["Neon|Ride"] = 97.17, ["Neon|Fly|Ride"] = 141.72, ["Mega|Ride"] = 423.01, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 27.56, ["Fly"] = 32.4, ["Ride"] = 24.05, ["Fly|Ride"] = 55.9, ["Neon"] = 366.96, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 142.92, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 190.32}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 35.44, ["Ride"] = 131.24, ["Fly|Ride"] = 282.36, ["Neon"] = 169.21, ["Neon|Ride"] = 219.97, ["Neon|Fly|Ride"] = 426.54, ["Mega"] = 691.61, ["Mega|Fly|Ride"] = 678.57}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 262.26, ["Ride"] = 695.63, ["Fly|Ride"] = 634.5, ["Neon|Ride"] = 16919.62, ["Neon|Fly|Ride"] = 28199.71}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 45.85, ["Fly"] = 212.94, ["Ride"] = 86.52, ["Fly|Ride"] = 180.09, ["Neon"] = 252, ["Neon|Ride"] = 321.54, ["Neon|Fly|Ride"] = 458.96, ["Mega"] = 850.5, ["Mega|Ride"] = 1040.13, ["Mega|Fly|Ride"] = 1199.19}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 984.27, ["Fly"] = 1296.48, ["Ride"] = 984.38, ["Fly|Ride"] = 971.25, ["Neon|Ride"] = 4239.89, ["Neon|Fly|Ride"] = 3281.25, ["Mega|Fly|Ride"] = 12337.5}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 354.27, ["Fly"] = 705.34, ["Ride"] = 380.63, ["Fly|Ride"] = 426.45, ["Neon"] = 1968.75, ["Neon|Ride"] = 1909.69, ["Neon|Fly|Ride"] = 1995, ["Mega"] = 11996.87, ["Mega|Fly|Ride"] = 9186.19}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 76.14}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 3.29}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 8.42, ["Fly"] = 23, ["Ride"] = 27.5, ["Fly|Ride"] = 52.52, ["Neon"] = 78.75, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 85.25, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 557.3, ["Mega|Ride"] = 705.34, ["Mega|Fly|Ride"] = 544.62}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 246.75, ["Fly"] = 406.65, ["Ride"] = 280.74, ["Fly|Ride"] = 326.7, ["Neon"] = 1185.02, ["Neon|Ride"] = 905.21, ["Neon|Fly|Ride"] = 931.66, ["Mega|Ride"] = 3102.65, ["Mega|Fly|Ride"] = 2808.75}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 15.09}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 95.18, ["Ride"] = 155.43, ["Fly|Ride"] = 262.5, ["Neon"] = 525, ["Neon|Ride"] = 564.71, ["Neon|Fly|Ride"] = 590.63, ["Mega"] = 2231.43, ["Mega|Ride"] = 2206.97, ["Mega|Fly|Ride"] = 1914.84}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 123.22, ["Fly"] = 211.52, ["Ride"] = 129.45, ["Fly|Ride"] = 156.53, ["Neon"] = 1128.35, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 913.5, ["Mega|Fly|Ride"] = 2537.96}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 3.9, ["Ride"] = 25.62, ["Fly|Ride"] = 52.5, ["Neon"] = 38.58, ["Neon|Ride"] = 42.32, ["Neon|Fly|Ride"] = 239.01, ["Mega"] = 253.81, ["Mega|Ride"] = 189.84, ["Mega|Fly|Ride"] = 479.9}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 9.19, ["Fly"] = 71.54, ["Ride"] = 21.16, ["Fly|Ride"] = 52.5, ["Neon"] = 141.72, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 316.28, ["Mega|Ride"] = 1410.68, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 10.5, ["Fly"] = 102.36, ["Ride"] = 31.5, ["Fly|Ride"] = 104.81, ["Neon"] = 78.75, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 258.04, ["Mega"] = 421.95, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 564.71}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 5.25, ["Fly"] = 98.44, ["Ride"] = 45.94, ["Fly|Ride"] = 137.71, ["Neon"] = 26.16, ["Neon|Ride"] = 70.49, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 150.94, ["Mega|Ride"] = 174.77, ["Mega|Fly|Ride"] = 269.07}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 239.01, ["Ride"] = 261.19, ["Fly|Ride"] = 403.01, ["Neon"] = 1586.23, ["Neon|Ride"] = 1364.93, ["Neon|Fly|Ride"] = 1381.75, ["Mega|Fly|Ride"] = 5610.98}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 84.6, ["Fly"] = 148.07, ["Ride"] = 135.19, ["Fly|Ride"] = 239.01, ["Neon"] = 459.38, ["Neon|Ride"] = 549.84, ["Neon|Fly|Ride"] = 630, ["Mega"] = 2255.43, ["Mega|Ride"] = 1837.5, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 60.38, ["Fly"] = 94.5, ["Ride"] = 70.26, ["Fly|Ride"] = 126, ["Neon"] = 380.63, ["Neon|Ride"] = 257.39, ["Neon|Fly|Ride"] = 407.77, ["Mega|Ride"] = 1635.93, ["Mega|Fly|Ride"] = 1919.51}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 11.96, ["Fly"] = 78.75, ["Ride"] = 28.56, ["Fly|Ride"] = 282.36, ["Neon"] = 115.5, ["Neon|Ride"] = 609.31, ["Neon|Fly|Ride"] = 493.85, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 11.75, ["Fly"] = 35.97, ["Ride"] = 26.25, ["Fly|Ride"] = 79.33, ["Neon"] = 77.43, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 376.47, ["Mega|Fly"] = 525, ["Mega|Ride"] = 366.96, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.46, ["Fly"] = 52.48, ["Ride"] = 19.69, ["Fly|Ride"] = 57.12, ["Neon"] = 19.69, ["Neon|Fly"] = 68.3, ["Neon|Ride"] = 42.21, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 131.25, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 813.75, ["Fly"] = 1082.73, ["Ride"] = 843.93, ["Fly|Ride"] = 909.57, ["Neon"] = 3039.3, ["Neon|Fly"] = 3256.38, ["Neon|Ride"] = 8459.81, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 8098.23}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 318.94, ["Fly"] = 705.34, ["Ride"] = 297.62, ["Fly|Ride"] = 322.88, ["Neon"] = 1199.42, ["Neon|Ride"] = 1487.28, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 6344.87}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 84.3, ["Fly"] = 133.26, ["Ride"] = 116.82, ["Fly|Ride"] = 165.76, ["Neon"] = 393.74, ["Neon|Fly"] = 479.77, ["Neon|Ride"] = 326.32, ["Neon|Fly|Ride"] = 426.57, ["Mega"] = 1312.5, ["Mega|Ride"] = 1579.88, ["Mega|Fly|Ride"] = 1627.46}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 202.58, ["Fly"] = 283.5, ["Ride"] = 219.19, ["Fly|Ride"] = 244.29, ["Neon|Ride"] = 1279.78, ["Neon|Fly|Ride"] = 917.44, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 23.63, ["Fly"] = 32.82, ["Ride"] = 28.58, ["Fly|Ride"] = 48, ["Neon"] = 169.32, ["Neon|Ride"] = 184.02, ["Neon|Fly|Ride"] = 204.75, ["Mega|Ride"] = 570.08, ["Mega|Fly|Ride"] = 800.21}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 190.29, ["Ride"] = 222.01, ["Fly|Ride"] = 358.32, ["Neon"] = 786.19, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 971.25, ["Mega"] = 4180.32, ["Mega|Fly|Ride"] = 3750.88}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 84.62, ["Fly"] = 125.98, ["Ride"] = 79.42, ["Fly|Ride"] = 106.46, ["Neon|Ride"] = 479.77, ["Neon|Fly|Ride"] = 423.01, ["Mega|Fly|Ride"] = 1537.58}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1955.63, ["Ride"] = 2034.38, ["Fly|Ride"] = 1968.65, ["Neon|Ride"] = 11197.88, ["Neon|Fly|Ride"] = 7599.03, ["Mega|Fly|Ride"] = 23993.73}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 13.15, ["Fly"] = 77.44, ["Ride"] = 42.32, ["Fly|Ride"] = 100.09, ["Neon"] = 62.68, ["Neon|Fly"] = 234.77, ["Neon|Ride"] = 126.92, ["Neon|Fly|Ride"] = 213.05, ["Mega"] = 312.38, ["Mega|Fly"] = 564.71, ["Mega|Ride"] = 307.13, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 58.97, ["Fly"] = 93.08, ["Ride"] = 84, ["Fly|Ride"] = 142.7, ["Neon"] = 196.88, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 564.71, ["Mega|Ride"] = 931.88, ["Mega|Fly|Ride"] = 1057.49}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 79.66, ["Fly"] = 91.87, ["Ride"] = 81.38, ["Fly|Ride"] = 91.88, ["Neon"] = 525, ["Neon|Ride"] = 256.69, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1879.82}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3358, ["Fly"] = 1599.85, ["Ride"] = 1069.68, ["Fly|Ride"] = 1046.32, ["Neon|Ride"] = 5117.85, ["Neon|Fly|Ride"] = 4725, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 523.69, ["Fly"] = 525, ["Ride"] = 740.24, ["Fly|Ride"] = 534.19, ["Neon|Fly|Ride"] = 3199.59, ["Mega|Fly|Ride"] = 11280.1}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 69.71, ["Fly"] = 170.63, ["Ride"] = 96.65, ["Fly|Ride"] = 208.69, ["Neon"] = 442.98, ["Neon|Ride"] = 342.54, ["Neon|Fly|Ride"] = 549.84, ["Mega|Ride"] = 1480.47, ["Mega|Fly|Ride"] = 1551.34}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.76, ["Ride"] = 21.57, ["Fly|Ride"] = 48, ["Neon"] = 74.33, ["Neon|Fly"] = 141.72, ["Neon|Ride"] = 94.31, ["Neon|Fly|Ride"] = 130.59, ["Mega"] = 656.25, ["Mega|Ride"] = 765.62}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 25.6, ["Fly"] = 68.25, ["Ride"] = 42, ["Fly|Ride"] = 78.75, ["Neon"] = 281.31, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 2256.68, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 735, ["Fly"] = 1103.36, ["Ride"] = 746.87, ["Fly|Ride"] = 829.5, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2508.42, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 591.41}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 6168.75, ["Ride"] = 6596.05, ["Fly|Ride"] = 5248.69, ["Neon"] = 42000, ["Neon|Ride"] = 30308.32, ["Neon|Fly|Ride"] = 18375, ["Mega|Fly|Ride"] = 105606.9}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 240.06, ["Fly"] = 396.57, ["Ride"] = 328.13, ["Fly|Ride"] = 417.37, ["Neon"] = 1312.5, ["Neon|Ride"] = 1833.68, ["Neon|Fly|Ride"] = 1706.25, ["Mega"] = 6343.82, ["Mega|Fly|Ride"] = 6344.87}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 74.5, ["Fly"] = 282.36, ["Ride"] = 131.14, ["Fly|Ride"] = 336, ["Neon"] = 421.95, ["Neon|Ride"] = 789.94, ["Neon|Fly|Ride"] = 630.28, ["Mega|Fly|Ride"] = 2144.58}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 15.4, ["Fly"] = 65.62, ["Ride"] = 30.19, ["Fly|Ride"] = 64.78, ["Neon"] = 156.92, ["Neon|Fly"] = 1279.78, ["Neon|Ride"] = 117.56, ["Neon|Fly|Ride"] = 214.68, ["Mega|Ride"] = 564.71, ["Mega|Fly|Ride"] = 634.5}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 10.64, ["Fly"] = 26.23, ["Ride"] = 21.41, ["Fly|Ride"] = 48.66, ["Neon"] = 126.92, ["Neon|Ride"] = 67.19, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2114.97}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 16.96, ["Fly"] = 282.36, ["Ride"] = 30.99, ["Fly|Ride"] = 85.32, ["Neon"] = 118.13, ["Neon|Ride"] = 126.67, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 645.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 4.81, ["Fly"] = 62.41, ["Ride"] = 19.69, ["Fly|Ride"] = 48.57, ["Neon"] = 31.38, ["Neon|Ride"] = 56.39, ["Neon|Fly|Ride"] = 126, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 274.96}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 28.51, ["Fly"] = 90.57, ["Ride"] = 39.38, ["Fly|Ride"] = 139.13, ["Neon"] = 203.44, ["Neon|Fly"] = 846, ["Neon|Ride"] = 228.43, ["Neon|Fly|Ride"] = 451.5, ["Mega"] = 628.69, ["Mega|Ride"] = 776.21}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 483, ["Fly"] = 538.12, ["Ride"] = 472.5, ["Fly|Ride"] = 538.13, ["Neon"] = 1439.3, ["Neon|Ride"] = 1551.34, ["Neon|Fly|Ride"] = 1443.75, ["Mega"] = 7875, ["Mega|Fly|Ride"] = 5217.6}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.1, ["Fly"] = 21.2, ["Ride"] = 15.59, ["Fly|Ride"] = 35.97, ["Neon"] = 23.84, ["Neon|Ride"] = 38.59, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 170.63, ["Mega|Ride"] = 224.21, ["Mega|Fly|Ride"] = 211.52}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 45.68, ["Fly"] = 98.44, ["Ride"] = 83.42, ["Fly|Ride"] = 132.61, ["Neon"] = 131.25, ["Neon|Fly"] = 333.15, ["Neon|Ride"] = 221.16, ["Neon|Fly|Ride"] = 300.57, ["Mega"] = 524.48, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 596.97}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 800.63, ["Ride"] = 761.25, ["Fly|Ride"] = 746.03, ["Neon|Ride"] = 1988.23, ["Neon|Fly|Ride"] = 1603.88, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 29.34, ["Fly"] = 90.56, ["Ride"] = 44.63, ["Fly|Ride"] = 65.24, ["Neon"] = 253.81, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 249.35, ["Mega"] = 1199.69, ["Mega|Fly|Ride"] = 851.81}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 315, ["Fly"] = 261.19, ["Ride"] = 259.88, ["Fly|Ride"] = 328.13, ["Neon"] = 1551.34, ["Neon|Ride"] = 1833.68, ["Neon|Fly|Ride"] = 1504.81, ["Mega|Fly|Ride"] = 6399.15}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 196.86, ["Fly"] = 178.5, ["Ride"] = 177.19, ["Fly|Ride"] = 236.14, ["Neon"] = 987.7, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 859.69, ["Mega"] = 4326, ["Mega|Fly|Ride"] = 4017.36}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 837.53, ["Ride"] = 776.21, ["Fly|Ride"] = 914.94, ["Neon|Ride"] = 3949.68, ["Mega|Fly|Ride"] = 9305.8}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 19.29, ["Fly"] = 84.62, ["Ride"] = 44.54, ["Fly|Ride"] = 110.25, ["Neon"] = 78.74, ["Neon|Fly"] = 287.87, ["Neon|Ride"] = 99.42, ["Neon|Fly|Ride"] = 141.72, ["Mega"] = 320.34, ["Mega|Ride"] = 409.25, ["Mega|Fly|Ride"] = 423.01}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4084.49, ["Fly"] = 3438.49, ["Ride"] = 3281.25, ["Fly|Ride"] = 3150, ["Neon|Fly|Ride"] = 7350, ["Mega|Fly|Ride"] = 23993.73}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 102.88, ["Fly"] = 154.42, ["Ride"] = 131.91, ["Fly|Ride"] = 186.04, ["Neon"] = 459.38, ["Neon|Fly"] = 711.38, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 593.25, ["Mega|Ride"] = 2679.66, ["Mega|Fly|Ride"] = 2820.3}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.45, ["Fly"] = 28.56, ["Ride"] = 15.44, ["Fly|Ride"] = 38.07, ["Neon"] = 20.23, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 64.97, ["Mega"] = 160.1, ["Mega|Ride"] = 245.75, ["Mega|Fly|Ride"] = 226.32}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.75, ["Ride"] = 21.16, ["Fly|Ride"] = 57.71, ["Neon"] = 21, ["Neon|Fly"] = 117.56, ["Neon|Ride"] = 64.26, ["Neon|Fly|Ride"] = 160.78, ["Mega"] = 161.44, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 361.59}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 28.45, ["Fly"] = 38.45, ["Ride"] = 30.86, ["Fly|Ride"] = 56.11, ["Neon"] = 287.87, ["Neon|Ride"] = 184.02, ["Neon|Fly|Ride"] = 253.8, ["Mega|Fly|Ride"] = 1084.98}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 887.25, ["Fly"] = 846, ["Ride"] = 987.7, ["Fly|Ride"] = 1056.68, ["Neon"] = 4512.26, ["Neon|Fly|Ride"] = 4229.92}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 8098.13, ["Fly|Ride"] = 6431.25}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 20.9, ["Fly"] = 45.48, ["Ride"] = 23.46, ["Fly|Ride"] = 44.42, ["Neon"] = 452.13, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 135.09, ["Mega"] = 2520, ["Mega|Fly|Ride"] = 712.23}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 12.98, ["Fly"] = 57.65, ["Ride"] = 26.25, ["Fly|Ride"] = 74.82, ["Neon"] = 71.37, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 167.82, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 549.9}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 90.77, ["Fly"] = 157.5, ["Ride"] = 87.94, ["Fly|Ride"] = 141.75, ["Neon|Ride"] = 430.5, ["Neon|Fly|Ride"] = 423.01, ["Mega|Fly|Ride"] = 1833.68}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 216.47, ["Fly"] = 241.5, ["Ride"] = 221.82, ["Fly|Ride"] = 332.3, ["Neon"] = 918.75, ["Neon|Ride"] = 1065.95, ["Neon|Fly|Ride"] = 1018.7, ["Mega"] = 8459.81, ["Mega|Fly|Ride"] = 3526.69}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 4.73, ["Ride"] = 32.71, ["Fly|Ride"] = 57.12, ["Neon"] = 21.67, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 52.88, ["Mega"] = 145.94, ["Mega|Fly"] = 235.83, ["Mega|Ride"] = 191.22, ["Mega|Fly|Ride"] = 236.24}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 182.46, ["Fly"] = 231.7, ["Ride"] = 210, ["Fly|Ride"] = 299.9, ["Neon"] = 776.21, ["Neon|Ride"] = 712.3, ["Neon|Fly|Ride"] = 774.38, ["Mega|Fly|Ride"] = 2576.44}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.08, ["Fly"] = 23.62, ["Ride"] = 15.73, ["Fly|Ride"] = 60.29, ["Neon"] = 28.79, ["Neon|Fly"] = 70.87, ["Neon|Ride"] = 37.4, ["Neon|Fly|Ride"] = 108.94, ["Mega"] = 225.75, ["Mega|Ride"] = 196.71, ["Mega|Fly|Ride"] = 274.67}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 188.41, ["Fly"] = 341.58, ["Ride"] = 211.52, ["Fly|Ride"] = 236.25, ["Neon"] = 1268.98, ["Neon|Ride"] = 1199.42, ["Neon|Fly|Ride"] = 823.29, ["Mega|Fly|Ride"] = 5439.4}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 7.45, ["Fly"] = 77.44, ["Ride"] = 24.01, ["Fly|Ride"] = 68.25, ["Neon"] = 73.5, ["Neon|Fly"] = 304.66, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 493.85, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 3.94, ["Ride"] = 19.59, ["Fly|Ride"] = 72.19, ["Neon"] = 10.73, ["Neon|Fly"] = 170.46, ["Neon|Ride"] = 35.97, ["Neon|Fly|Ride"] = 139.59, ["Mega"] = 82.04, ["Mega|Ride"] = 71.25, ["Mega|Fly|Ride"] = 213.94}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.52, ["Mega"] = 18.25, ["Mega|Ride"] = 151.17, ["Mega|Fly|Ride"] = 167.09}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 35.33, ["Fly|Ride"] = 113.16, ["Neon"] = 6.35, ["Neon|Ride"] = 27.8, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 73.48, ["Mega|Fly"] = 159958.98, ["Mega|Ride"] = 76, ["Mega|Fly|Ride"] = 211.52}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 59.84, ["Fly"] = 105, ["Ride"] = 111.57, ["Fly|Ride"] = 207.38, ["Neon"] = 313.88, ["Neon|Fly"] = 327.97, ["Neon|Ride"] = 287.44, ["Neon|Fly|Ride"] = 368.82, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 34.8, ["Ride"] = 15.75, ["Fly|Ride"] = 78.75, ["Neon"] = 4.81, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 91.88, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 262.47}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 8.54, ["Ride"] = 113.16, ["Neon"] = 64.32, ["Neon|Fly"] = 239.89, ["Neon|Ride"] = 247.09, ["Mega"] = 261.19, ["Mega|Ride"] = 423.01}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Ride"] = 57.12, ["Neon"] = 2.63, ["Neon|Ride"] = 54.57, ["Neon|Fly|Ride"] = 282.36, ["Mega"] = 13.11, ["Mega|Ride"] = 55, ["Mega|Fly|Ride"] = 157.16}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 70.87, ["Ride"] = 15.88, ["Fly|Ride"] = 24.43, ["Neon"] = 2.1, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 14.11, ["Neon|Fly|Ride"] = 28.77, ["Mega"] = 15.43, ["Mega|Ride"] = 20.61, ["Mega|Fly|Ride"] = 57.3}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 15.82, ["Fly|Ride"] = 66.64, ["Neon"] = 2.1, ["Neon|Fly"] = 20.99, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 42.83, ["Mega"] = 20.58, ["Mega|Ride"] = 32.8, ["Mega|Fly|Ride"] = 64.32}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 70.87, ["Neon"] = 2.63, ["Neon|Ride"] = 65.62, ["Mega"] = 19.69, ["Mega|Ride"] = 131.14, ["Mega|Fly|Ride"] = 269.67}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 91.86, ["Ride"] = 31.2, ["Fly|Ride"] = 107.62, ["Neon"] = 2.46, ["Neon|Fly"] = 120.57, ["Neon|Ride"] = 20.67, ["Neon|Fly|Ride"] = 81.55, ["Mega"] = 24.83, ["Mega|Ride"] = 43.32, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 82.08, ["Neon|Fly|Ride"] = 423.01, ["Mega"] = 17.73, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 212.84}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 3.26, ["Fly"] = 36.75, ["Ride"] = 32.82, ["Fly|Ride"] = 156.45, ["Neon"] = 12.38, ["Neon|Fly"] = 24.01, ["Neon|Ride"] = 32.16, ["Neon|Fly|Ride"] = 104.98, ["Mega"] = 172.96, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 261.86}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 2.1, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 320.34, ["Mega"] = 12.5, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 68.98, ["Mega|Fly|Ride"] = 131.24}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.15, ["Ride"] = 142.77, ["Fly|Ride"] = 141.72, ["Neon"] = 18.14, ["Mega"] = 135.19, ["Mega|Fly"] = 315, ["Mega|Ride"] = 274.31, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 28.56, ["Neon"] = 19.05, ["Neon|Ride"] = 70.87, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 564.71}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 4.22, ["Neon|Ride"] = 15.88, ["Neon|Fly|Ride"] = 141.72, ["Mega"] = 20.1, ["Mega|Ride"] = 26.25, ["Mega|Fly|Ride"] = 131.24}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.25, ["Ride"] = 14.17, ["Fly|Ride"] = 26.24, ["Neon"] = 2.1, ["Neon|Fly"] = 15.88, ["Neon|Ride"] = 14.14, ["Neon|Fly|Ride"] = 37.7, ["Mega"] = 13.05, ["Mega|Ride"] = 19.15, ["Mega|Fly|Ride"] = 49.63}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 4.65, ["Fly"] = 72.19, ["Ride"] = 229.68, ["Fly|Ride"] = 118.1, ["Neon"] = 40.5, ["Neon|Ride"] = 140.95, ["Mega"] = 190.36, ["Mega|Ride"] = 240.19}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 30.87, ["Fly|Ride"] = 80.38, ["Neon"] = 6.35, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 35.97, ["Neon|Fly|Ride"] = 105, ["Mega"] = 23, ["Mega|Ride"] = 47.87, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Mega"] = 82.69, ["Mega|Ride"] = 161.44, ["Mega|Fly|Ride"] = 254.61}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.16, ["Fly"] = 78.92, ["Ride"] = 19.69, ["Fly|Ride"] = 39.38, ["Neon"] = 19.21, ["Neon|Ride"] = 42.32, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 124.69, ["Mega|Ride"] = 143.06, ["Mega|Fly|Ride"] = 191.97}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 11.57, ["Fly|Ride"] = 28.56, ["Neon"] = 2.1, ["Neon|Fly"] = 15.63, ["Neon|Ride"] = 12.88, ["Neon|Fly|Ride"] = 28.87, ["Mega"] = 12.97, ["Mega|Ride"] = 19.58, ["Mega|Fly|Ride"] = 48.08}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 21.38, ["Ride"] = 27.4, ["Fly|Ride"] = 141.72, ["Neon"] = 10.37, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 196.47, ["Mega"] = 129.64, ["Mega|Ride"] = 160.78, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 5.12, ["Fly"] = 113.16, ["Ride"] = 39.4, ["Fly|Ride"] = 59.07, ["Neon"] = 47.59, ["Neon|Ride"] = 67.48, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 262.5, ["Mega|Ride"] = 291.38, ["Mega|Fly|Ride"] = 281.54}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 32.45, ["Ride"] = 13.71, ["Fly|Ride"] = 28.76, ["Neon"] = 2.63, ["Neon|Fly"] = 15.65, ["Neon|Ride"] = 15.25, ["Neon|Fly|Ride"] = 32.76, ["Mega"] = 19.81, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 79.17}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 3.84, ["Fly"] = 176.61, ["Ride"] = 31.5, ["Neon"] = 6.57, ["Neon|Ride"] = 35.12, ["Neon|Fly|Ride"] = 168.15, ["Mega"] = 63, ["Mega|Fly"] = 169.21, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Fly|Ride"] = 65.63, ["Neon"] = 3.31, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 42.32, ["Neon|Fly|Ride"] = 283.64, ["Mega"] = 26.25, ["Mega|Ride"] = 74.04, ["Mega|Fly|Ride"] = 311.73}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 30.19, ["Ride"] = 15.75, ["Neon"] = 2.1, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 282.36, ["Mega"] = 11.65, ["Mega|Fly"] = 253.82, ["Mega|Ride"] = 39.4, ["Mega|Fly|Ride"] = 156.18}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 70.87, ["Ride"] = 14.34, ["Fly|Ride"] = 46.56, ["Neon"] = 5.25, ["Neon|Fly"] = 53.95, ["Neon|Ride"] = 17.18, ["Neon|Fly|Ride"] = 60.38, ["Mega"] = 80.39, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 57.12, ["Neon"] = 4.96, ["Neon|Ride"] = 68.25, ["Mega"] = 35.03, ["Mega|Fly"] = 239.95, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 221.81}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.02, ["Fly|Ride"] = 72.19, ["Neon"] = 5.25, ["Neon|Fly"] = 80.38, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 57.12, ["Mega"] = 111.57, ["Mega|Ride"] = 90.56, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 3.94, ["Ride"] = 38.58, ["Neon"] = 31.11, ["Neon|Fly"] = 188.89, ["Neon|Ride"] = 70.87, ["Neon|Fly|Ride"] = 167.97, ["Mega"] = 101.07, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 210}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 25.77, ["Ride"] = 15.59, ["Fly|Ride"] = 32.03, ["Neon"] = 9.19, ["Neon|Fly"] = 28.56, ["Neon|Ride"] = 32.22, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 262.26, ["Mega|Ride"] = 121.44, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 3.68, ["Fly"] = 21.1, ["Ride"] = 17.07, ["Fly|Ride"] = 70.87, ["Neon"] = 13.13, ["Neon|Fly"] = 65.91, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 108.32, ["Mega"] = 169.21, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 141.72}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 112.11, ["Neon"] = 12.02, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 190.72, ["Mega|Ride"] = 236.25}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 5.91, ["Ride"] = 56.44, ["Neon"] = 202, ["Neon|Fly|Ride"] = 794.07, ["Mega"] = 564.71, ["Mega|Ride"] = 705.34, ["Mega|Fly|Ride"] = 981.75}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.16, ["Ride"] = 55, ["Neon"] = 45.84, ["Neon|Ride"] = 106.55, ["Mega"] = 126.92, ["Mega|Ride"] = 364.23, ["Mega|Fly|Ride"] = 319.13}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 3.94, ["Ride"] = 21.38, ["Fly|Ride"] = 120.75, ["Neon"] = 31.39, ["Neon|Ride"] = 57.12, ["Mega"] = 311.07, ["Mega|Ride"] = 282.36, ["Mega|Fly|Ride"] = 385.23}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.13, ["Neon"] = 2.58, ["Neon|Ride"] = 65.01, ["Mega"] = 15.64, ["Mega|Fly"] = 121.63, ["Mega|Ride"] = 126.92, ["Mega|Fly|Ride"] = 189.31}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 47.63}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 2.63, ["Fly"] = 23.63, ["Ride"] = 22.2, ["Fly|Ride"] = 41.72, ["Neon"] = 43.32, ["Neon|Fly"] = 188.48, ["Neon|Ride"] = 56.39, ["Neon|Fly|Ride"] = 78.66, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.79, ["Ride"] = 15.75, ["Fly|Ride"] = 64.32, ["Neon"] = 2.1, ["Neon|Fly"] = 52.8, ["Neon|Ride"] = 15.88, ["Neon|Fly|Ride"] = 32.8, ["Mega"] = 16.42, ["Mega|Fly"] = 141.72, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 98.42}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Neon"] = 4.19, ["Neon|Ride"] = 36, ["Neon|Fly|Ride"] = 74.43, ["Mega"] = 32.2, ["Mega|Ride"] = 63.4, ["Mega|Fly|Ride"] = 99.42}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.24, ["Fly"] = 28.56, ["Ride"] = 15.44, ["Fly|Ride"] = 45.73, ["Neon"] = 6.3, ["Neon|Ride"] = 19.05, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 141.75, ["Mega|Ride"] = 118.01, ["Mega|Fly|Ride"] = 232.29}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 2.63, ["Fly"] = 28.56, ["Ride"] = 84.96, ["Fly|Ride"] = 57.75, ["Neon"] = 41.84, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 162.87, ["Mega|Ride"] = 353.21, ["Mega|Fly|Ride"] = 316.2}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 2.1, ["Mega"] = 17.74, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 120.57}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 16.68, ["Fly|Ride"] = 34.28, ["Neon"] = 3.67, ["Neon|Fly"] = 28.56, ["Neon|Ride"] = 19.67, ["Neon|Fly|Ride"] = 96, ["Mega"] = 26.31, ["Mega|Ride"] = 37.97, ["Mega|Fly|Ride"] = 122.13}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.65, ["Ride"] = 15.63, ["Fly|Ride"] = 31.5, ["Neon"] = 5.16, ["Neon|Fly"] = 57.12, ["Neon|Ride"] = 18.16, ["Neon|Fly|Ride"] = 33.86, ["Mega"] = 47.95, ["Mega|Fly"] = 141.72, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 28.56, ["Ride"] = 26.25, ["Fly|Ride"] = 141.72, ["Neon"] = 3.6, ["Neon|Ride"] = 39.19, ["Neon|Fly|Ride"] = 70.87, ["Mega"] = 55.49, ["Mega|Ride"] = 83.35, ["Mega|Fly|Ride"] = 248.06}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 28.56, ["Neon|Fly|Ride"] = 154518.41, ["Mega"] = 18.09, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 136.48}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 16.99, ["Fly|Ride"] = 43.32, ["Neon"] = 2.3, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 20.36, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 18.17, ["Mega|Ride"] = 36.3, ["Mega|Fly|Ride"] = 90.7}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 42.32, ["Neon"] = 2.63, ["Neon|Ride"] = 40.2, ["Mega"] = 19.05, ["Mega|Ride"] = 133.88}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.61, ["Neon|Fly|Ride"] = 420, ["Mega"] = 28.87, ["Mega|Ride"] = 191.18, ["Mega|Fly|Ride"] = 262.26}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 14.44, ["Fly|Ride"] = 52.49, ["Neon"] = 4.18, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 15.59, ["Neon|Fly|Ride"] = 42, ["Mega"] = 34.13, ["Mega|Ride"] = 53.95, ["Mega|Fly|Ride"] = 107.55}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 7.56, ["Ride"] = 59.06, ["Fly|Ride"] = 211.52, ["Neon"] = 122.68, ["Neon|Ride"] = 174.57, ["Mega"] = 406.88, ["Mega|Ride"] = 497.44, ["Mega|Fly|Ride"] = 640.65}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 38.39, ["Neon"] = 32.16, ["Neon|Ride"] = 157.5, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 31.75, ["Fly|Ride"] = 179.79, ["Neon"] = 17.99, ["Neon|Ride"] = 70.88, ["Mega"] = 250.08, ["Mega|Ride"] = 452.62, ["Mega|Fly|Ride"] = 370.33}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 16.11, ["Ride"] = 11.69, ["Fly|Ride"] = 27.5, ["Neon"] = 2.1, ["Neon|Fly"] = 15.64, ["Neon|Ride"] = 12.7, ["Neon|Fly|Ride"] = 24.65, ["Mega"] = 13.65, ["Mega|Ride"] = 19.15, ["Mega|Fly|Ride"] = 41.6}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 3.94, ["Fly"] = 118.12, ["Ride"] = 59.24, ["Neon"] = 6.35, ["Neon|Fly"] = 67.69, ["Neon|Ride"] = 32.8, ["Neon|Fly|Ride"] = 705.34, ["Mega"] = 77.41, ["Mega|Ride"] = 52.5}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Fly"] = 70.87, ["Ride"] = 31.49, ["Neon"] = 2.1, ["Neon|Fly"] = 31.75, ["Neon|Ride"] = 23.55, ["Neon|Fly|Ride"] = 84.62, ["Mega"] = 10.5, ["Mega|Fly"] = 63.47, ["Mega|Ride"] = 70.87, ["Mega|Fly|Ride"] = 126.92}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 127.32, ["Mega"] = 11.82, ["Mega|Ride"] = 57.12, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 42.32, ["Ride"] = 15.75, ["Fly|Ride"] = 43.22, ["Neon"] = 9.19, ["Neon|Fly"] = 71.17, ["Neon|Ride"] = 28.56, ["Neon|Fly|Ride"] = 75.91, ["Mega"] = 169.31, ["Mega|Fly"] = 191.97, ["Mega|Ride"] = 401.85, ["Mega|Fly|Ride"] = 292.04}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 155.3, ["Ride"] = 224, ["Fly|Ride"] = 378.59, ["Neon"] = 931.66, ["Neon|Fly|Ride"] = 972.89, ["Mega"] = 8459.81, ["Mega|Ride"] = 3314.14, ["Mega|Fly|Ride"] = 3320.49}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 24.01, ["Neon"] = 6.57, ["Neon|Ride"] = 64.31, ["Mega"] = 65.54, ["Mega|Ride"] = 184.02, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 5.25, ["Fly"] = 65.63, ["Ride"] = 26.25, ["Fly|Ride"] = 62.19, ["Neon"] = 32.34, ["Neon|Ride"] = 169.21, ["Neon|Fly|Ride"] = 141.72, ["Mega"] = 381.82, ["Mega|Ride"] = 527.7, ["Mega|Fly|Ride"] = 643.22}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 28.65, ["Ride"] = 15.49, ["Fly|Ride"] = 32.8, ["Neon"] = 7.88, ["Neon|Fly"] = 34.13, ["Neon|Ride"] = 29.78, ["Neon|Fly|Ride"] = 47.41, ["Mega"] = 46.78, ["Mega|Ride"] = 83.91, ["Mega|Fly|Ride"] = 141.72}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 70.87, ["Ride"] = 17.76, ["Fly|Ride"] = 92.6, ["Neon"] = 8.03, ["Neon|Ride"] = 62.77, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 70.87, ["Mega|Ride"] = 191.97, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 2.63, ["Fly"] = 25.98, ["Ride"] = 15.67, ["Fly|Ride"] = 31.49, ["Neon"] = 20.83, ["Neon|Fly"] = 99.42, ["Neon|Ride"] = 31.14, ["Neon|Fly|Ride"] = 77.97, ["Mega|Ride"] = 278.13, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 2.24, ["Ride"] = 28.56, ["Fly|Ride"] = 118.13, ["Neon"] = 47.1, ["Neon|Ride"] = 141.72, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 262.49, ["Mega|Ride"] = 332.3, ["Mega|Fly|Ride"] = 324.65}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.63, ["Fly"] = 18.79, ["Ride"] = 16.1, ["Fly|Ride"] = 37.72, ["Neon"] = 24.87, ["Neon|Fly"] = 67.28, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 62.36, ["Mega"] = 262.5, ["Mega|Ride"] = 282.36, ["Mega|Fly|Ride"] = 229.69}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 55.12, ["Fly"] = 98.63, ["Ride"] = 86.8, ["Fly|Ride"] = 141.72, ["Neon"] = 341.24, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 397.69, ["Neon|Fly|Ride"] = 436.62, ["Mega|Fly|Ride"] = 1410.68}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 194.71, ["Fly"] = 423.01, ["Ride"] = 245.44, ["Fly|Ride"] = 240.06, ["Neon"] = 1199.42, ["Neon|Ride"] = 1128.35, ["Neon|Fly|Ride"] = 985.61, ["Mega"] = 10574.76, ["Mega|Fly|Ride"] = 4935.26}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 61.52, ["Fly"] = 141.72, ["Ride"] = 70.87, ["Fly|Ride"] = 113.16, ["Neon"] = 478.42, ["Neon|Ride"] = 290.34, ["Neon|Fly|Ride"] = 286.8, ["Mega|Ride"] = 987.7, ["Mega|Fly|Ride"] = 1372.63}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 8.48, ["Fly"] = 42.32, ["Ride"] = 23.28, ["Fly|Ride"] = 65.54, ["Neon"] = 24.94, ["Neon|Ride"] = 122.68, ["Neon|Fly|Ride"] = 283.4, ["Mega"] = 262.5, ["Mega|Ride"] = 282.36, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 8.76, ["Fly"] = 70.87, ["Ride"] = 20.57, ["Fly|Ride"] = 92.36, ["Neon"] = 48.57, ["Neon|Ride"] = 55.19, ["Neon|Fly|Ride"] = 211.52, ["Mega"] = 355.69, ["Mega|Ride"] = 289.76, ["Mega|Fly|Ride"] = 389.03}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 15.33, ["Fly|Ride"] = 44.68, ["Neon"] = 2.1, ["Neon|Fly"] = 21, ["Neon|Ride"] = 21.76, ["Neon|Fly|Ride"] = 39.37, ["Mega"] = 119.99, ["Mega|Fly"] = 146.39, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 370.32}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.82, ["Fly"] = 72.12, ["Ride"] = 23.27, ["Fly|Ride"] = 66.25, ["Neon"] = 400.61, ["Neon|Fly"] = 353.21, ["Neon|Ride"] = 113.04, ["Neon|Fly|Ride"] = 211.44, ["Mega"] = 423.01, ["Mega|Ride"] = 479.9, ["Mega|Fly|Ride"] = 732.38}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.91, ["Ride"] = 14.77, ["Fly|Ride"] = 36.05, ["Neon"] = 9.71, ["Neon|Fly"] = 80.38, ["Neon|Ride"] = 28.56, ["Neon|Fly|Ride"] = 70.88, ["Mega|Ride"] = 174.57, ["Mega|Fly|Ride"] = 198.36}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.63, ["Ride"] = 30.68, ["Fly|Ride"] = 328.13, ["Neon"] = 22.32, ["Neon|Ride"] = 35.97, ["Mega"] = 207.37, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 27.67, ["Ride"] = 19.36, ["Neon"] = 2.1, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 57.73, ["Mega"] = 15.58, ["Mega|Ride"] = 42, ["Mega|Fly|Ride"] = 78.74}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 24.34, ["Ride"] = 18.38, ["Fly|Ride"] = 42.32, ["Neon"] = 15.61, ["Neon|Fly"] = 105.76, ["Neon|Ride"] = 28.56, ["Neon|Fly|Ride"] = 147, ["Mega"] = 78.72, ["Mega|Ride"] = 104.39, ["Mega|Fly|Ride"] = 200.17}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 25.72, ["Ride"] = 17.38, ["Fly|Ride"] = 62.41, ["Neon"] = 15.78, ["Neon|Ride"] = 47.25, ["Mega"] = 131.18, ["Mega|Ride"] = 240.06, ["Mega|Fly|Ride"] = 230.99}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 98.44, ["Fly"] = 143.07, ["Ride"] = 136.49, ["Fly|Ride"] = 181.91, ["Neon"] = 489.57, ["Neon|Ride"] = 432.95, ["Neon|Fly|Ride"] = 524.94, ["Mega"] = 4229.92, ["Mega|Ride"] = 2719.71, ["Mega|Fly|Ride"] = 2255.96}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.86, ["Ride"] = 71.97, ["Fly|Ride"] = 128.36, ["Neon"] = 46.55, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 326.82, ["Mega|Ride"] = 430.87, ["Mega|Fly|Ride"] = 480.11}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 28.56, ["Ride"] = 15.65, ["Fly|Ride"] = 36.74, ["Neon"] = 13.13, ["Neon|Ride"] = 23.15, ["Neon|Fly|Ride"] = 120.64, ["Mega"] = 239.95, ["Mega|Ride"] = 186.38, ["Mega|Fly|Ride"] = 311.97}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 23.55, ["Ride"] = 58.02, ["Fly|Ride"] = 170.63, ["Neon"] = 130.29, ["Neon|Ride"] = 161.34, ["Neon|Fly|Ride"] = 611.64, ["Mega"] = 564.71, ["Mega|Fly"] = 846, ["Mega|Ride"] = 687.75, ["Mega|Fly|Ride"] = 634.5}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 6.57}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.63, ["Ride"] = 28.84, ["Fly|Ride"] = 125.86, ["Neon"] = 36.74, ["Neon|Fly"] = 69.57, ["Neon|Ride"] = 85.17, ["Neon|Fly|Ride"] = 423.01, ["Mega"] = 423.01, ["Mega|Ride"] = 479.9, ["Mega|Fly|Ride"] = 884.14}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 23.39, ["Fly"] = 36.88, ["Ride"] = 26.18, ["Fly|Ride"] = 49.79, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 162.65, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 1365.23, ["Mega|Fly|Ride"] = 564.71}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 19.28, ["Fly|Ride"] = 70.87, ["Neon"] = 3.78, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 21.17, ["Neon|Fly|Ride"] = 107.62, ["Mega"] = 24.02, ["Mega|Fly"] = 188.99, ["Mega|Ride"] = 58.95, ["Mega|Fly|Ride"] = 229.01}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 9.02, ["Fly"] = 28.56, ["Ride"] = 19.81, ["Fly|Ride"] = 65.54, ["Neon"] = 57.48, ["Neon|Ride"] = 63.47, ["Mega"] = 282.36, ["Mega|Fly"] = 400.71, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 480.11}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 13.55, ["Fly|Ride"] = 47.49, ["Neon"] = 19.22, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 29.3, ["Neon|Fly|Ride"] = 76.79, ["Mega"] = 138.9, ["Mega|Ride"] = 187.59, ["Mega|Fly|Ride"] = 360.89}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 28.64, ["Fly|Ride"] = 211.52, ["Neon"] = 3.25, ["Neon|Fly"] = 37.03, ["Neon|Ride"] = 32.7, ["Mega"] = 22.81, ["Mega|Ride"] = 62.41, ["Mega|Fly|Ride"] = 121.78}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 22.31, ["Ride"] = 42, ["Fly|Ride"] = 94.48, ["Neon"] = 131.25, ["Neon|Ride"] = 205.37, ["Neon|Fly|Ride"] = 564.71, ["Mega"] = 727.65, ["Mega|Ride"] = 987.7, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.6, ["Fly"] = 28.56, ["Ride"] = 42, ["Fly|Ride"] = 210, ["Neon"] = 95.81, ["Mega|Ride"] = 525}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 2.63, ["Fly"] = 28.8, ["Ride"] = 19.7, ["Fly|Ride"] = 48.2, ["Neon"] = 16.57, ["Neon|Fly"] = 84.62, ["Neon|Ride"] = 25.7, ["Neon|Fly|Ride"] = 74.06, ["Mega"] = 152.85, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 273.67}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 39.38, ["Fly"] = 433.12, ["Ride"] = 393.75, ["Fly|Ride"] = 262.5, ["Neon"] = 367.5, ["Neon|Ride"] = 656.25, ["Mega"] = 4480.85, ["Mega|Ride"] = 2165.63, ["Mega|Fly|Ride"] = 2580.25}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 5.59, ["Fly"] = 44.94, ["Ride"] = 20.9, ["Fly|Ride"] = 57.66, ["Neon"] = 37.71, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 48.37, ["Neon|Fly|Ride"] = 85.05, ["Mega"] = 250.69, ["Mega|Ride"] = 225.43, ["Mega|Fly|Ride"] = 319.79}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 70.86, ["Fly"] = 143.06, ["Ride"] = 108.75, ["Fly|Ride"] = 140.44, ["Neon"] = 262.4, ["Neon|Fly"] = 321.48, ["Neon|Ride"] = 250.41, ["Neon|Fly|Ride"] = 314.74, ["Mega"] = 840.71, ["Mega|Ride"] = 938.97, ["Mega|Fly|Ride"] = 968.63}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 19.39, ["Ride"] = 42.62, ["Fly|Ride"] = 208.71, ["Neon"] = 80.55, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 196.85, ["Mega"] = 315, ["Mega|Ride"] = 333.54, ["Mega|Fly|Ride"] = 355.69}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 5.01, ["Fly"] = 41.36, ["Ride"] = 28.56, ["Fly|Ride"] = 70.13, ["Neon"] = 98.44, ["Neon|Ride"] = 143.94, ["Neon|Fly|Ride"] = 381.52, ["Mega"] = 211.52, ["Mega|Ride"] = 211.52, ["Mega|Fly|Ride"] = 536.16}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 12.9, ["Fly"] = 69.8, ["Ride"] = 49.88, ["Fly|Ride"] = 131.25, ["Neon"] = 56.44, ["Neon|Ride"] = 74.41, ["Neon|Fly|Ride"] = 438.38, ["Mega"] = 236.91, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 6.06, ["Ride"] = 29.98, ["Fly|Ride"] = 70.74, ["Neon"] = 28.56, ["Neon|Ride"] = 57.18, ["Neon|Fly|Ride"] = 126.92, ["Mega"] = 211.52, ["Mega|Ride"] = 250.34, ["Mega|Fly|Ride"] = 347.83}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Ride"] = 70.1, ["Neon"] = 2.1, ["Neon|Fly"] = 93.78, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 15.75, ["Mega|Ride"] = 141.72, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.89, ["Ride"] = 32.82, ["Neon"] = 31.75, ["Neon|Ride"] = 184.7, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 228.27, ["Mega|Ride"] = 282.36, ["Mega|Fly|Ride"] = 423.01}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 124.8, ["Ride"] = 28.04, ["Neon"] = 28.88, ["Neon|Fly"] = 78.27, ["Neon|Ride"] = 70.87, ["Mega"] = 184.02, ["Mega|Ride"] = 282.57, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 3.62, ["Ride"] = 32.8, ["Fly|Ride"] = 119.95, ["Neon"] = 30.68, ["Neon|Ride"] = 82.49, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 124.69, ["Mega|Ride"] = 282.36, ["Mega|Fly|Ride"] = 519.74}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 459.27, ["Ride"] = 536.82, ["Fly|Ride"] = 559.13, ["Neon"] = 1797.72, ["Neon|Fly"] = 1799.84, ["Neon|Ride"] = 1837.91, ["Neon|Fly|Ride"] = 1548.75, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 9.18, ["Fly"] = 45.47, ["Ride"] = 20.01, ["Fly|Ride"] = 56.35, ["Neon"] = 41.26, ["Neon|Ride"] = 57.72, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 156.53, ["Mega|Ride"] = 368.03, ["Mega|Fly|Ride"] = 350.04}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 6.01, ["Fly"] = 66.94, ["Ride"] = 16.95, ["Fly|Ride"] = 51.55, ["Neon"] = 39.38, ["Neon|Fly"] = 315, ["Neon|Ride"] = 71.65, ["Neon|Fly|Ride"] = 162.87, ["Mega"] = 331.87, ["Mega|Ride"] = 502.31, ["Mega|Fly|Ride"] = 376.47}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 3.42, ["Fly"] = 24.93, ["Ride"] = 20.24, ["Fly|Ride"] = 50.79, ["Neon"] = 11.82, ["Neon|Ride"] = 49.72, ["Neon|Fly|Ride"] = 131.25}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.59, ["Ride"] = 24.36, ["Fly|Ride"] = 52.41, ["Neon"] = 8.24, ["Neon|Ride"] = 30.06, ["Neon|Fly|Ride"] = 99.42, ["Mega"] = 61.32, ["Mega|Ride"] = 94.38, ["Mega|Fly|Ride"] = 217.34}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 70.87, ["Ride"] = 16.95, ["Neon"] = 2.1, ["Neon|Ride"] = 23.6, ["Neon|Fly|Ride"] = 114.09, ["Mega"] = 22.32, ["Mega|Ride"] = 77.44, ["Mega|Fly|Ride"] = 224.21}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1115.52}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 7.14, ["Ride"] = 30.19, ["Fly|Ride"] = 329.99, ["Neon"] = 63.41, ["Neon|Ride"] = 91.88, ["Mega"] = 395.52, ["Mega|Ride"] = 846, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 27.69, ["Neon"] = 5.02, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 987.81, ["Mega"] = 36.95, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 250.04}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 3.38, ["Fly"] = 28.56, ["Ride"] = 63.47, ["Neon"] = 20.18, ["Neon|Fly"] = 70.87, ["Neon|Ride"] = 70.87, ["Neon|Fly|Ride"] = 243.48, ["Mega"] = 208.69, ["Mega|Ride"] = 320.34, ["Mega|Fly|Ride"] = 1057.49}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 409.49, ["Ride"] = 429.5, ["Fly|Ride"] = 498.75, ["Neon|Ride"] = 1246.51, ["Neon|Fly|Ride"] = 1246.88, ["Mega"] = 8798.52, ["Mega|Fly|Ride"] = 6298.69}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 3.35, ["Fly"] = 196.88, ["Ride"] = 57.12, ["Fly|Ride"] = 423.01, ["Neon"] = 19.69, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 191.97, ["Mega"] = 389.17, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 736.62}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 28.23, ["Fly|Ride"] = 118.11, ["Neon"] = 3.94, ["Neon|Ride"] = 37.03, ["Neon|Fly|Ride"] = 103.68, ["Mega"] = 26.4, ["Mega|Ride"] = 75.95, ["Mega|Fly|Ride"] = 154.25}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 4.09, ["Neon|Ride"] = 141.72, ["Neon|Fly|Ride"] = 282.36, ["Mega"] = 32.79, ["Mega|Ride"] = 141.72, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 21.5, ["Fly"] = 107.88, ["Ride"] = 39.38, ["Fly|Ride"] = 141.72, ["Neon"] = 195.51, ["Neon|Ride"] = 179.82, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 544.68, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 544.69}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 10.29, ["Ride"] = 71.31, ["Neon"] = 82.49, ["Neon|Ride"] = 179.47, ["Neon|Fly|Ride"] = 479.9, ["Mega"] = 400.71, ["Mega|Ride"] = 479.73, ["Mega|Fly|Ride"] = 634.5}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 2.63, ["Ride"] = 32.82, ["Neon"] = 96.94, ["Neon|Ride"] = 183.38, ["Mega"] = 656.25, ["Mega|Ride"] = 776.21, ["Mega|Fly|Ride"] = 801.94}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 11.04, ["Ride"] = 23.86, ["Fly|Ride"] = 262.5, ["Neon"] = 167.28, ["Neon|Ride"] = 177.5, ["Neon|Fly|Ride"] = 244.29, ["Mega"] = 629.9, ["Mega|Ride"] = 564.71, ["Mega|Fly|Ride"] = 509.25}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 393.65, ["Ride"] = 417.78, ["Fly|Ride"] = 513.35, ["Neon"] = 1706.25, ["Neon|Ride"] = 705.34, ["Neon|Fly|Ride"] = 1102.5, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 3.89, ["Fly"] = 78.75, ["Ride"] = 28.87, ["Fly|Ride"] = 82.18, ["Neon"] = 113.16, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 141.72, ["Mega|Ride"] = 561.1, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.82, ["Ride"] = 30.68, ["Fly|Ride"] = 127.32, ["Neon"] = 62.34, ["Neon|Ride"] = 221.82, ["Mega"] = 167.09, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 27.26, ["Ride"] = 84, ["Neon"] = 91.77, ["Neon|Ride"] = 160.23, ["Neon|Fly|Ride"] = 260.78, ["Mega"] = 262.5, ["Mega|Fly"] = 705.34, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 465.92}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Ride"] = 42.32, ["Fly|Ride"] = 211.52, ["Neon"] = 7.4, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 273.91, ["Mega"] = 38.36, ["Mega|Ride"] = 128.29, ["Mega|Fly|Ride"] = 245.35}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 36.66, ["Ride"] = 90.96, ["Neon"] = 315, ["Neon|Ride"] = 241.73, ["Neon|Fly|Ride"] = 503.36, ["Mega"] = 1619.6, ["Mega|Ride"] = 2080.26, ["Mega|Fly|Ride"] = 1326.59}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 76.15, ["Ride"] = 26.25, ["Fly|Ride"] = 196.88, ["Neon"] = 7.28, ["Neon|Fly"] = 184.02, ["Neon|Ride"] = 37.2, ["Neon|Fly|Ride"] = 108.53, ["Mega"] = 59.07, ["Mega|Ride"] = 92.01, ["Mega|Fly|Ride"] = 225.75}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 28.56, ["Fly|Ride"] = 98.21, ["Neon"] = 3.73, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 48.97, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 27.5, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 93.08}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 37.96, ["Fly|Ride"] = 127.62, ["Neon"] = 6.3, ["Neon|Ride"] = 56.67, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 84, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 311.97}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 44.54, ["Fly"] = 65.61, ["Ride"] = 61.57, ["Fly|Ride"] = 185.07, ["Neon"] = 248.98, ["Neon|Ride"] = 320.46, ["Neon|Fly|Ride"] = 479.9, ["Mega|Ride"] = 1128.35, ["Mega|Fly|Ride"] = 1106.14}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 240.06, ["Ride"] = 244.29, ["Fly|Ride"] = 420.9, ["Neon"] = 1469.91, ["Neon|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 1470, ["Mega"] = 9597.51, ["Mega|Fly|Ride"] = 4794.61}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 7.3, ["Neon"] = 19.21, ["Neon|Fly"] = 350.44, ["Neon|Ride"] = 109.15, ["Mega"] = 121.63, ["Mega|Ride"] = 187.69, ["Mega|Fly|Ride"] = 342.03}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 19.05, ["Fly|Ride"] = 160.74, ["Neon"] = 6.49, ["Neon|Ride"] = 41.91, ["Neon|Fly|Ride"] = 141.72, ["Mega"] = 38.74, ["Mega|Fly"] = 164.07, ["Mega|Ride"] = 91.54, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.1, ["Fly"] = 106.45, ["Ride"] = 28.56, ["Fly|Ride"] = 91.88, ["Neon"] = 32.81, ["Mega|Ride"] = 348.04, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 64.97, ["Ride"] = 30.19, ["Fly|Ride"] = 116.16, ["Neon"] = 17.79, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 139, ["Mega"] = 124.69, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 347.82}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 59.07, ["Neon"] = 8.91, ["Neon|Fly|Ride"] = 141.72, ["Mega"] = 26.25, ["Mega|Ride"] = 141.72, ["Mega|Fly|Ride"] = 391.28}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 37.03, ["Ride"] = 19.04, ["Fly|Ride"] = 52.48, ["Neon"] = 4.28, ["Neon|Fly"] = 28.56, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 100.47, ["Mega"] = 39.41, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 249.37}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.63, ["Fly"] = 26.24, ["Ride"] = 17.8, ["Fly|Ride"] = 46.79, ["Neon"] = 14.86, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 38.9, ["Neon|Fly|Ride"] = 113.16, ["Mega"] = 156.15, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 29.79, ["Ride"] = 32.44, ["Fly|Ride"] = 78.75, ["Neon"] = 105, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 322.3, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 527.68}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 66.14, ["Ride"] = 84.35, ["Fly|Ride"] = 139.13, ["Neon"] = 390.73, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 367.49, ["Neon|Fly|Ride"] = 455.44, ["Mega"] = 1975.38, ["Mega|Ride"] = 1551.34, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 17.99, ["Fly|Ride"] = 144.38, ["Neon"] = 3.71, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 26.2, ["Neon|Fly|Ride"] = 141.72, ["Mega"] = 32.69, ["Mega|Fly"] = 672, ["Mega|Ride"] = 87.78, ["Mega|Fly|Ride"] = 247.53}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 14.34, ["Ride"] = 15.65, ["Fly|Ride"] = 39.37, ["Neon"] = 3.72, ["Neon|Fly"] = 28.56, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 61.68, ["Mega"] = 38.9, ["Mega|Ride"] = 68.13, ["Mega|Fly|Ride"] = 96.25}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 3.18, ["Fly"] = 42.32, ["Ride"] = 28.56, ["Neon"] = 48.37, ["Neon|Ride"] = 135.19, ["Mega"] = 527.7, ["Mega|Ride"] = 273, ["Mega|Fly|Ride"] = 366.96}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.65, ["Ride"] = 472.5, ["Fly|Ride"] = 577.5, ["Neon"] = 4229.92, ["Neon|Ride"] = 6562.5, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 5701.5}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 21.45, ["Fly"] = 99.42, ["Ride"] = 54, ["Fly|Ride"] = 84.36, ["Neon"] = 215, ["Neon|Ride"] = 177.9, ["Neon|Fly|Ride"] = 196.87, ["Mega|Ride"] = 698.38, ["Mega|Fly|Ride"] = 1758.75}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 22.2, ["Fly|Ride"] = 281.33, ["Neon"] = 7.8, ["Neon|Ride"] = 48.56, ["Neon|Fly|Ride"] = 141.63, ["Mega"] = 78.66, ["Mega|Ride"] = 144.33, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 65.63, ["Fly|Ride"] = 65.63, ["Neon"] = 43.55, ["Neon|Ride"] = 72.34, ["Mega|Fly|Ride"] = 316.2}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 25.82, ["Fly"] = 169.3, ["Ride"] = 37.69, ["Fly|Ride"] = 105.3, ["Neon"] = 194.25, ["Neon|Ride"] = 272.35, ["Neon|Fly|Ride"] = 210, ["Mega"] = 2537.96, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1002.75}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 95.82, ["Fly"] = 119.34, ["Ride"] = 113.43, ["Fly|Ride"] = 206.22, ["Neon"] = 320.25, ["Neon|Ride"] = 479.77, ["Neon|Fly|Ride"] = 610.32, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 236.69, ["Ride"] = 264.22, ["Fly|Ride"] = 493.85, ["Neon"] = 708.75, ["Neon|Ride"] = 604.08, ["Neon|Fly|Ride"] = 1035.57, ["Mega|Fly|Ride"] = 3377.59}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 11.71, ["Ride"] = 28.56, ["Fly|Ride"] = 141.72, ["Neon"] = 49.72, ["Neon|Fly"] = 119.95, ["Neon|Ride"] = 89.15, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 389.8, ["Mega|Ride"] = 404.8, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 25.09, ["Ride"] = 15.3, ["Fly|Ride"] = 43.32, ["Neon"] = 7.26, ["Neon|Ride"] = 23.28, ["Neon|Fly|Ride"] = 92.02, ["Mega"] = 93.18, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 170.52}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.1, ["Fly"] = 45.11, ["Ride"] = 15.43, ["Fly|Ride"] = 55.98, ["Neon"] = 31.48, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 87.04, ["Mega"] = 282.02, ["Mega|Ride"] = 411.51, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 314.5, ["Ride"] = 393.75, ["Fly|Ride"] = 640.49, ["Neon"] = 1549.42, ["Neon|Ride"] = 1818.88, ["Neon|Fly|Ride"] = 1899.23, ["Mega|Fly|Ride"] = 5118.75}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 32.8, ["Neon"] = 3.9, ["Neon|Ride"] = 139.41, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 28.58, ["Mega|Ride"] = 169.28}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.07, ["Ride"] = 16.02, ["Fly|Ride"] = 39.37, ["Neon"] = 22.32, ["Neon|Ride"] = 38.01, ["Neon|Fly|Ride"] = 96, ["Mega"] = 234.77, ["Mega|Ride"] = 211.52, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 14.12, ["Ride"] = 47.98, ["Neon"] = 78.85, ["Neon|Fly"] = 423.01, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 141.72, ["Mega"] = 459.38, ["Mega|Ride"] = 573.2, ["Mega|Fly|Ride"] = 637.33}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 98.05, ["Fly"] = 141.72, ["Ride"] = 108.94, ["Fly|Ride"] = 127.03, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 568.32, ["Mega|Fly|Ride"] = 2379.57}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 17.66, ["Fly"] = 24.57, ["Ride"] = 25.41, ["Fly|Ride"] = 53.82, ["Neon"] = 126.92, ["Neon|Ride"] = 89.29, ["Neon|Fly|Ride"] = 139.79, ["Mega"] = 705.34, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 533.23}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 21.16, ["Neon"] = 3.15, ["Neon|Ride"] = 77.44, ["Mega"] = 25.99, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 15.56, ["Fly|Ride"] = 72.19, ["Neon"] = 2.1, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 24.34, ["Neon|Fly|Ride"] = 82.25, ["Mega"] = 26.25, ["Mega|Ride"] = 42, ["Mega|Fly|Ride"] = 109.99}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 17.06, ["Ride"] = 50.77, ["Fly|Ride"] = 209.39, ["Neon"] = 36.26, ["Neon|Ride"] = 89.25, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 159.93, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 300.66}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1179.93, ["Ride"] = 1283.98, ["Fly|Ride"] = 1358.44, ["Neon"] = 4719.66, ["Neon|Ride"] = 7050.21, ["Neon|Fly|Ride"] = 4371.62, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 430.5, ["Ride"] = 420, ["Fly|Ride"] = 556.88, ["Neon"] = 1663.2, ["Neon|Ride"] = 1640.63, ["Neon|Fly|Ride"] = 1734.27, ["Mega"] = 16919.62, ["Mega|Fly|Ride"] = 7176.05}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 294, ["Fly"] = 351.75, ["Ride"] = 341.25, ["Fly|Ride"] = 413.44, ["Neon"] = 787.5, ["Neon|Fly"] = 1120.26, ["Neon|Ride"] = 672.81, ["Neon|Fly|Ride"] = 734.79, ["Mega|Fly|Ride"] = 2916.23}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 240.33, ["Fly"] = 359.8, ["Ride"] = 296.63, ["Fly|Ride"] = 367.5, ["Neon"] = 708.75, ["Neon|Ride"] = 603.74, ["Neon|Fly|Ride"] = 643.12, ["Mega|Fly|Ride"] = 2996.9}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 15.1, ["Ride"] = 14.21, ["Fly|Ride"] = 39.37, ["Neon"] = 3.94, ["Neon|Ride"] = 30.06, ["Neon|Fly|Ride"] = 105, ["Mega"] = 69.54, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 229.85, ["Fly"] = 395.52, ["Ride"] = 301.88, ["Fly|Ride"] = 433.13, ["Neon"] = 1318.69, ["Neon|Ride"] = 1255.24, ["Neon|Fly|Ride"] = 1115.63, ["Mega|Ride"] = 5075.89, ["Mega|Fly|Ride"] = 3877.77}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 6.17, ["Fly"] = 157.5, ["Ride"] = 70.26, ["Fly|Ride"] = 91.88, ["Neon"] = 24.86, ["Neon|Fly"] = 37.2, ["Neon|Ride"] = 110.52, ["Neon|Fly|Ride"] = 254.63, ["Mega"] = 168.5, ["Mega|Ride"] = 283.64, ["Mega|Fly|Ride"] = 370.77}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 15.88, ["Ride"] = 15.39, ["Fly|Ride"] = 38.98, ["Neon"] = 6.57, ["Neon|Ride"] = 42.32, ["Neon|Fly|Ride"] = 65.63, ["Mega|Ride"] = 192.94, ["Mega|Fly|Ride"] = 96}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 56.6, ["Neon"] = 2.1, ["Neon|Ride"] = 45.94, ["Mega"] = 26.25, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 177.62}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 28.56, ["Ride"] = 52.88, ["Fly|Ride"] = 459.38, ["Neon"] = 239.89, ["Neon|Ride"] = 353.21, ["Mega"] = 1050, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 8038.15, ["Ride"] = 26.25, ["Fly|Ride"] = 68.25, ["Neon"] = 6.57, ["Mega"] = 354.26, ["Mega|Ride"] = 297.51, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 2.1, ["Neon|Ride"] = 50.19, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 19.69, ["Mega|Ride"] = 69.8, ["Mega|Fly|Ride"] = 160.78}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 3.29, ["Fly"] = 41.26, ["Ride"] = 27.6, ["Fly|Ride"] = 78.64, ["Neon"] = 14.97, ["Neon|Fly"] = 113.16, ["Neon|Ride"] = 41.16, ["Neon|Fly|Ride"] = 80.33, ["Mega"] = 136.49, ["Mega|Ride"] = 113.89, ["Mega|Fly|Ride"] = 238.23}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 5.25, ["Fly"] = 57.12, ["Ride"] = 19.05, ["Fly|Ride"] = 50.33, ["Neon"] = 35.97, ["Neon|Fly"] = 143.94, ["Neon|Ride"] = 141.72, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 300.53, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 21, ["Ride"] = 63.47, ["Neon"] = 92.9, ["Neon|Ride"] = 184.02, ["Neon|Fly|Ride"] = 310.73, ["Mega"] = 395.92, ["Mega|Ride"] = 792.07}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 6329.86, ["Ride"] = 19.69, ["Neon"] = 48.67, ["Neon|Fly"] = 48.57, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 282.36, ["Mega|Ride"] = 417.72, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 65.01, ["Ride"] = 15.75, ["Fly|Ride"] = 45.83, ["Neon"] = 3.71, ["Neon|Fly"] = 31.75, ["Neon|Ride"] = 28.25, ["Neon|Fly|Ride"] = 99.42, ["Mega"] = 45.94, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 163.96, ["Fly"] = 258.04, ["Ride"] = 131.25, ["Fly|Ride"] = 229.69, ["Neon"] = 951.75, ["Neon|Ride"] = 900.77, ["Neon|Fly|Ride"] = 839.88, ["Mega"] = 8459.81, ["Mega|Fly|Ride"] = 3483.35}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 19.06, ["Ride"] = 14.26, ["Fly|Ride"] = 35.44, ["Neon"] = 3.84, ["Neon|Fly"] = 40.2, ["Neon|Ride"] = 21.31, ["Neon|Fly|Ride"] = 47.23, ["Mega"] = 25.2, ["Mega|Ride"] = 53.29, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 5.6, ["Ride"] = 40.14, ["Fly|Ride"] = 196.88, ["Neon"] = 55.59, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 767.81, ["Mega"] = 313.69, ["Mega|Fly"] = 800.21, ["Mega|Ride"] = 309.75, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 26.11, ["Ride"] = 160.72, ["Fly|Ride"] = 170.63, ["Neon"] = 154.34, ["Neon|Ride"] = 355.69, ["Neon|Fly|Ride"] = 253.81, ["Mega"] = 786.19, ["Mega|Ride"] = 617.21, ["Mega|Fly|Ride"] = 846}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 192.3, ["Ride"] = 244.96, ["Fly|Ride"] = 297.93, ["Neon"] = 796.23, ["Neon|Ride"] = 682.5, ["Neon|Fly|Ride"] = 756, ["Mega|Fly|Ride"] = 3501.75}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 14.44, ["Ride"] = 159.91, ["Fly|Ride"] = 143.93, ["Neon"] = 91.88, ["Neon|Ride"] = 211.52, ["Mega"] = 287.44, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 317.25}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 7.02, ["Ride"] = 57.75, ["Fly|Ride"] = 634.5, ["Neon"] = 105.76, ["Neon|Fly"] = 160.74, ["Neon|Ride"] = 207.21, ["Neon|Fly|Ride"] = 158.34, ["Mega|Ride"] = 846, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 866.15, ["Ride"] = 963.29, ["Fly|Ride"] = 1036.88, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 4610.61, ["Mega|Fly|Ride"] = 16918.57}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 7.65, ["Fly"] = 21.31, ["Ride"] = 20.79, ["Fly|Ride"] = 93.57, ["Neon"] = 21.16, ["Neon|Fly"] = 57.56, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 211.52, ["Mega"] = 227.96, ["Mega|Fly|Ride"] = 336.3}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 6.07, ["Fly"] = 78.75, ["Ride"] = 35.97, ["Fly|Ride"] = 53.95, ["Neon"] = 38.75, ["Neon|Ride"] = 83.55, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 524.52, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 210}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 84.62, ["Ride"] = 23.88, ["Fly|Ride"] = 95.19, ["Neon"] = 6.24, ["Neon|Ride"] = 46.38, ["Neon|Fly|Ride"] = 170.62, ["Mega"] = 69.56, ["Mega|Ride"] = 350.87, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 11.82, ["Fly"] = 55, ["Ride"] = 39.29, ["Fly|Ride"] = 92.59, ["Neon"] = 65.98, ["Neon|Ride"] = 91.54, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 435.75, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.1, ["Fly"] = 20.48, ["Ride"] = 15.63, ["Fly|Ride"] = 51.8, ["Neon"] = 17.07, ["Neon|Fly"] = 42.74, ["Neon|Ride"] = 29.47, ["Neon|Fly|Ride"] = 64.8, ["Mega"] = 115.5, ["Mega|Fly"] = 280.98, ["Mega|Ride"] = 120.57, ["Mega|Fly|Ride"] = 186.27}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 3.94, ["Fly"] = 32.75, ["Ride"] = 19.68, ["Fly|Ride"] = 88.85, ["Neon"] = 11.57, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 124.48, ["Mega|Ride"] = 200.36, ["Mega|Fly|Ride"] = 479.9}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 157.5, ["Fly"] = 235.83, ["Ride"] = 141.72, ["Fly|Ride"] = 423.01, ["Neon"] = 915.79, ["Neon|Fly|Ride"] = 1410.94}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.81, ["Ride"] = 28.56, ["Fly|Ride"] = 108.94, ["Neon"] = 6.2, ["Neon|Fly"] = 34.17, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 61.69, ["Mega|Fly"] = 423.01, ["Mega|Ride"] = 123.38, ["Mega|Fly|Ride"] = 282.36}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.03, ["Ride"] = 82.49, ["Fly|Ride"] = 88.86, ["Neon"] = 27.86, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.15, ["Mega"] = 175.88, ["Mega|Ride"] = 321.57, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.19, ["Fly"] = 94.73, ["Ride"] = 19.59, ["Neon"] = 9.19, ["Neon|Ride"] = 84.62, ["Mega"] = 94.37, ["Mega|Ride"] = 120.52, ["Mega|Fly|Ride"] = 459.17}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 69.57, ["Ride"] = 128, ["Fly|Ride"] = 315, ["Neon"] = 489.63, ["Neon|Ride"] = 392.44, ["Neon|Fly|Ride"] = 637.05, ["Mega|Ride"] = 1600.39, ["Mega|Fly|Ride"] = 1833.68}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 19.68, ["Fly"] = 90.76, ["Ride"] = 42.52, ["Fly|Ride"] = 253.81, ["Neon"] = 105, ["Neon|Ride"] = 162.87, ["Neon|Fly|Ride"] = 341.93, ["Mega"] = 634.5, ["Mega|Ride"] = 607.01, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 19.59, ["Fly"] = 57.49, ["Ride"] = 32.82, ["Fly|Ride"] = 97.13, ["Neon"] = 81.38, ["Neon|Fly"] = 64.78, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 241.4, ["Mega"] = 478, ["Mega|Ride"] = 392.77, ["Mega|Fly|Ride"] = 458.54}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 5.79, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 231.55, ["Mega"] = 103.69, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 480.11}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 40.2, ["Fly"] = 74.78, ["Ride"] = 87.06, ["Fly|Ride"] = 164.46, ["Neon"] = 262.5, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 261.49, ["Neon|Fly|Ride"] = 309.23, ["Mega|Fly|Ride"] = 991.47}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.67, ["Fly|Ride"] = 52.5, ["Neon"] = 5.77, ["Neon|Ride"] = 57.12, ["Neon|Fly|Ride"] = 125.86, ["Mega"] = 57.12, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 19.55, ["Fly"] = 109.15, ["Ride"] = 33.44, ["Fly|Ride"] = 96.25, ["Neon"] = 69.3, ["Neon|Ride"] = 79.17, ["Neon|Fly|Ride"] = 210, ["Mega"] = 357.09, ["Mega|Ride"] = 311.97, ["Mega|Fly|Ride"] = 423.01}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 36.51, ["Fly"] = 203.34, ["Ride"] = 76.13, ["Fly|Ride"] = 157.17, ["Neon"] = 253.39, ["Neon|Fly"] = 282.36, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 1373.68, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 14.49, ["Ride"] = 15.18, ["Fly|Ride"] = 28.84, ["Neon"] = 2.63, ["Neon|Fly"] = 12.71, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 39.37, ["Mega"] = 16.96, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 123.38}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 131.25, ["Neon"] = 20.37, ["Neon|Fly"] = 63.47, ["Neon|Ride"] = 65.6, ["Neon|Fly|Ride"] = 423.01, ["Mega"] = 226.32, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 392.43}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 14.19, ["Fly"] = 141.72, ["Ride"] = 40.79, ["Fly|Ride"] = 85.32, ["Neon"] = 110.13, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 210, ["Mega"] = 470.54, ["Mega|Ride"] = 444.94, ["Mega|Fly|Ride"] = 634.5}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 22, ["Neon"] = 2.1, ["Neon|Ride"] = 28.86, ["Neon|Fly|Ride"] = 95.81, ["Mega"] = 19.23, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 209.39}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 24.76, ["Fly"] = 201.52, ["Ride"] = 68.92, ["Fly|Ride"] = 131.15, ["Neon"] = 118.22, ["Neon|Ride"] = 232.32, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 649.3, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 535.42, ["Mega|Fly|Ride"] = 652.32}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 18.38, ["Fly"] = 42.41, ["Ride"] = 18.43, ["Fly|Ride"] = 98.44, ["Neon"] = 357.86, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 162.87, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 6.28, ["Ride"] = 47.25, ["Neon"] = 39.14, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 705.34, ["Mega"] = 231, ["Mega|Ride"] = 264.3, ["Mega|Fly|Ride"] = 423.01}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 7.66, ["Fly"] = 72.19, ["Ride"] = 42, ["Fly|Ride"] = 196.88, ["Neon"] = 48.72, ["Neon|Ride"] = 87.78, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 213.69, ["Mega|Ride"] = 211.52, ["Mega|Fly|Ride"] = 374.36}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 42.32, ["Ride"] = 19.48, ["Fly|Ride"] = 196.88, ["Neon"] = 5.61, ["Neon|Ride"] = 32.71, ["Mega"] = 53.82, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 110.39, ["Mega|Fly|Ride"] = 282.36}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 57.59, ["Neon"] = 2.5, ["Neon|Ride"] = 48, ["Mega"] = 22.07, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 11.82}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 36.54, ["Fly"] = 99.42, ["Ride"] = 66.27, ["Fly|Ride"] = 79.33, ["Neon"] = 184.57, ["Neon|Ride"] = 211.52, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 1833.68, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 888.57}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 27.45, ["Mega"] = 19.05, ["Mega|Ride"] = 121.05, ["Mega|Fly|Ride"] = 317.25}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 479.73, ["Fly"] = 498.75, ["Ride"] = 561.75, ["Fly|Ride"] = 599.65, ["Neon"] = 2820.3, ["Neon|Ride"] = 2009.22, ["Neon|Fly|Ride"] = 2111.03, ["Mega"] = 16919.62, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 3.84, ["Fly"] = 26.25, ["Ride"] = 33.72, ["Fly|Ride"] = 66.64, ["Neon"] = 35.39, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 113.16, ["Mega"] = 95.86, ["Mega|Ride"] = 141.72, ["Mega|Fly|Ride"] = 282.36}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 3.94, ["Fly"] = 28.56, ["Ride"] = 20.02, ["Fly|Ride"] = 91.88, ["Neon"] = 19.46, ["Neon|Ride"] = 62.41, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 131.25, ["Mega|Ride"] = 152.32, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 7.21, ["Fly"] = 70.87, ["Ride"] = 42.17, ["Fly|Ride"] = 70.82, ["Neon"] = 70.87, ["Neon|Ride"] = 141.72, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 670.45, ["Mega|Ride"] = 561.75, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 4.13, ["Fly"] = 57.12, ["Ride"] = 38.57, ["Fly|Ride"] = 705.34, ["Neon"] = 17.64, ["Neon|Fly"] = 35.97, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 275.63, ["Mega|Ride"] = 239.95, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 9.1, ["Ride"] = 95.19, ["Fly|Ride"] = 141.72, ["Neon"] = 71.09, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 105, ["Mega"] = 292.81, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 626.53}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 4.88, ["Fly"] = 105, ["Ride"] = 25.6, ["Fly|Ride"] = 91.88, ["Neon"] = 26.17, ["Neon|Ride"] = 79.19, ["Neon|Fly|Ride"] = 139.59, ["Mega"] = 221.82, ["Mega|Ride"] = 282.36, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 41.99, ["Ride"] = 13.8, ["Fly|Ride"] = 76.15, ["Neon"] = 2.1, ["Neon|Fly"] = 23.28, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 76.15, ["Mega"] = 15.33, ["Mega|Ride"] = 35.41, ["Mega|Fly|Ride"] = 91.38}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 7.77, ["Fly"] = 53.95, ["Ride"] = 39.38, ["Fly|Ride"] = 105.76, ["Neon"] = 28.77, ["Neon|Fly"] = 119.95, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 193.1, ["Mega"] = 196.87, ["Mega|Ride"] = 209.9, ["Mega|Fly|Ride"] = 276.94}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 320.16, ["Ride"] = 318.5, ["Fly|Ride"] = 353.72, ["Neon"] = 1312.5, ["Neon|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 1253.44, ["Mega|Ride"] = 9309.58, ["Mega|Fly|Ride"] = 4639.17}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 80.07, ["Ride"] = 111.57, ["Fly|Ride"] = 282.36, ["Neon"] = 356.57, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 582.69, ["Mega|Ride"] = 1820.99, ["Mega|Fly|Ride"] = 1442.63}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 16.59, ["Ride"] = 15.44, ["Fly|Ride"] = 34.61, ["Neon"] = 4.81, ["Neon|Fly"] = 29.05, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 57.12, ["Mega"] = 87.78, ["Mega|Ride"] = 78.91, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 13.93, ["Fly|Ride"] = 34.83, ["Neon"] = 6.56, ["Neon|Fly"] = 46.55, ["Neon|Ride"] = 25.11, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 65.63, ["Mega|Ride"] = 76.13, ["Mega|Fly|Ride"] = 171.94}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.63, ["Fly"] = 99.42, ["Ride"] = 22.31, ["Fly|Ride"] = 98.44, ["Neon"] = 99.42, ["Neon|Fly|Ride"] = 157.5, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 268.62, ["Fly"] = 320.22, ["Ride"] = 211.52, ["Fly|Ride"] = 288.75, ["Neon"] = 1181.25, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1038.45, ["Mega|Ride"] = 8459.81, ["Mega|Fly|Ride"] = 3434.82}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 3.94, ["Fly"] = 24.01, ["Ride"] = 14.44, ["Fly|Ride"] = 40.68, ["Neon"] = 13.02, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 29.94, ["Neon|Fly|Ride"] = 75.7, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 304.74}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.35, ["Ride"] = 78.75, ["Fly|Ride"] = 211.52, ["Neon"] = 26.42, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 282.36, ["Mega"] = 157.5, ["Mega|Ride"] = 300.2, ["Mega|Fly|Ride"] = 452.62}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 87.94, ["Neon"] = 6.15, ["Neon|Ride"] = 156.09, ["Mega"] = 68.16, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 17.07, ["Fly"] = 47.98, ["Ride"] = 17.64, ["Fly|Ride"] = 103.65, ["Neon"] = 118.13, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 142.31, ["Mega"] = 460.69, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 587.9}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 50.02, ["Fly"] = 97.13, ["Ride"] = 78.66, ["Fly|Ride"] = 295.05, ["Neon"] = 103.58, ["Neon|Fly"] = 211.52, ["Neon|Ride"] = 160.76, ["Neon|Fly|Ride"] = 452.62, ["Mega"] = 456.62, ["Mega|Ride"] = 486.85, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 22.66, ["Fly"] = 62.41, ["Ride"] = 48.47, ["Fly|Ride"] = 98.44, ["Neon"] = 155.06, ["Neon|Fly"] = 286.43, ["Neon|Ride"] = 211.52, ["Neon|Fly|Ride"] = 307.74, ["Mega"] = 846, ["Mega|Ride"] = 700.88, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 19.58, ["Ride"] = 14.95, ["Fly|Ride"] = 29.77, ["Neon"] = 2.1, ["Neon|Fly"] = 31.39, ["Neon|Ride"] = 14.97, ["Neon|Fly|Ride"] = 35.97, ["Mega"] = 17.73, ["Mega|Ride"] = 33.38, ["Mega|Fly|Ride"] = 94.23}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 184.95, ["Fly"] = 259.05, ["Ride"] = 231, ["Fly|Ride"] = 272.97, ["Neon"] = 2546.42, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1073.36, ["Mega|Fly|Ride"] = 3946.51}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 42.41, ["Fly"] = 65.63, ["Ride"] = 49.86, ["Fly|Ride"] = 104.99, ["Neon"] = 78.75, ["Neon|Ride"] = 133.92, ["Neon|Fly|Ride"] = 423.01, ["Mega"] = 430.5, ["Mega|Ride"] = 449.54, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 34.11, ["Ride"] = 18.74, ["Fly|Ride"] = 42.32, ["Neon"] = 5.24, ["Neon|Fly"] = 39.98, ["Neon|Ride"] = 27.5, ["Neon|Fly|Ride"] = 70.87, ["Mega"] = 59.21, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 197.76}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 19.43, ["Ride"] = 16.14, ["Fly|Ride"] = 45.48, ["Neon"] = 2.63, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 126.92, ["Mega"] = 19.69, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 74.82}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 3.94, ["Ride"] = 21, ["Fly|Ride"] = 72.19, ["Neon"] = 4.81, ["Neon|Fly"] = 719.65, ["Neon|Ride"] = 49.87, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 103.69, ["Mega|Ride"] = 131.78, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 8.44, ["Fly"] = 38.74, ["Ride"] = 20.99, ["Fly|Ride"] = 70.88, ["Neon"] = 48.27, ["Neon|Fly"] = 268.62, ["Neon|Ride"] = 56.43, ["Neon|Fly|Ride"] = 119.12, ["Mega"] = 355.69, ["Mega|Ride"] = 370.13, ["Mega|Fly|Ride"] = 354.89}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 6.5, ["Ride"] = 64.32, ["Neon"] = 54.57, ["Neon|Fly|Ride"] = 315, ["Mega"] = 234.94, ["Mega|Ride"] = 311.97, ["Mega|Fly|Ride"] = 400.71}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 42.41, ["Neon"] = 2.1, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 100.36, ["Mega"] = 61.69, ["Mega|Ride"] = 85.31, ["Mega|Fly|Ride"] = 179.79}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 6.39, ["Ride"] = 27.2, ["Fly|Ride"] = 131.25, ["Neon"] = 31.5, ["Neon|Fly"] = 102.8, ["Neon|Ride"] = 46.87, ["Neon|Fly|Ride"] = 282.36, ["Mega"] = 249.58, ["Mega|Ride"] = 211.98, ["Mega|Fly|Ride"] = 301.13}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Fly"] = 70.87, ["Ride"] = 83.77, ["Neon"] = 3.5, ["Neon|Fly"] = 113.16, ["Neon|Ride"] = 45.8, ["Neon|Fly|Ride"] = 102.35, ["Mega"] = 24.41, ["Mega|Ride"] = 104.71, ["Mega|Fly|Ride"] = 141.72}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 45, ["Ride"] = 18.14, ["Fly|Ride"] = 40.27, ["Neon"] = 3.94, ["Neon|Ride"] = 21.63, ["Neon|Fly|Ride"] = 107.63, ["Mega"] = 54.74, ["Mega|Ride"] = 78.46, ["Mega|Fly|Ride"] = 137.71}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 656.13, ["Ride"] = 685.12, ["Fly|Ride"] = 735, ["Neon"] = 2624.99, ["Neon|Ride"] = 4917.28, ["Neon|Fly|Ride"] = 3674.97, ["Mega|Fly|Ride"] = 12637.51}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 15.33, ["Fly|Ride"] = 36.33, ["Neon"] = 11.81, ["Neon|Fly"] = 42.32, ["Neon|Ride"] = 35.97, ["Neon|Fly|Ride"] = 98.44, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 3.94, ["Ride"] = 45.94, ["Neon"] = 6.46, ["Neon|Fly"] = 740.24, ["Neon|Ride"] = 114.45, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 55.13, ["Mega|Ride"] = 244.28, ["Mega|Fly|Ride"] = 257.15}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 8.79, ["Fly"] = 44.63, ["Ride"] = 23.12, ["Fly|Ride"] = 52.41, ["Neon"] = 50.77, ["Neon|Fly"] = 191.91, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 105.3, ["Mega"] = 485.63, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 347.8}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 16.92, ["Ride"] = 14.22, ["Fly|Ride"] = 41.99, ["Neon"] = 3.87, ["Neon|Fly"] = 148.07, ["Neon|Ride"] = 23.56, ["Neon|Fly|Ride"] = 55.77, ["Mega"] = 59.04, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 197.76}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 30.08, ["Fly"] = 105, ["Ride"] = 57.12, ["Fly|Ride"] = 282.36, ["Neon"] = 169.2, ["Neon|Ride"] = 223.12, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 687.39, ["Mega|Ride"] = 613.35, ["Mega|Fly|Ride"] = 733.9}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 16.89, ["Fly|Ride"] = 76.12, ["Neon"] = 4.72, ["Neon|Fly"] = 136.75, ["Neon|Ride"] = 26.87, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 43.22, ["Mega|Ride"] = 129.47, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 73.41, ["Ride"] = 23.33, ["Fly|Ride"] = 54.02, ["Neon"] = 9.98, ["Neon|Ride"] = 41.9, ["Neon|Fly|Ride"] = 141.72, ["Mega"] = 89.1, ["Mega|Ride"] = 198.59, ["Mega|Fly|Ride"] = 351.75}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly|Ride"] = 78.75, ["Neon"] = 21.3, ["Mega"] = 97.12, ["Mega|Ride"] = 158.64, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 14.64, ["Fly|Ride"] = 49.72, ["Neon"] = 3.71, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 112.14, ["Mega"] = 38.62, ["Mega|Fly"] = 227.39, ["Mega|Ride"] = 76.15, ["Mega|Fly|Ride"] = 144.36}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 13.13, ["Fly"] = 21.17, ["Ride"] = 16.72, ["Fly|Ride"] = 39.38, ["Neon"] = 104.99, ["Neon|Ride"] = 80.85, ["Neon|Fly|Ride"] = 140.21, ["Mega|Ride"] = 311.97, ["Mega|Fly|Ride"] = 391.56}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 731.53, ["Fly"] = 895.7, ["Ride"] = 733.69, ["Fly|Ride"] = 859.69, ["Neon"] = 1895.25, ["Neon|Ride"] = 1612.27, ["Neon|Fly|Ride"] = 2002.95, ["Mega"] = 4654.13, ["Mega|Ride"] = 5640.59, ["Mega|Fly|Ride"] = 6204.23}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 17.75, ["Ride"] = 14.44, ["Fly|Ride"] = 37.68, ["Neon"] = 3.42, ["Neon|Fly"] = 35.97, ["Neon|Ride"] = 17.17, ["Neon|Fly|Ride"] = 42.29, ["Mega"] = 55, ["Mega|Ride"] = 57.88, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 11.81, ["Ride"] = 32.81, ["Fly|Ride"] = 239.89, ["Neon"] = 48.47, ["Neon|Ride"] = 112.52, ["Neon|Fly|Ride"] = 208.68, ["Mega"] = 400.71, ["Mega|Ride"] = 353.21, ["Mega|Fly|Ride"] = 393.73}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 52.41, ["Fly"] = 105, ["Ride"] = 70.87, ["Fly|Ride"] = 105, ["Neon"] = 315, ["Neon|Ride"] = 401.85, ["Neon|Fly|Ride"] = 421.32, ["Mega"] = 1691.97, ["Mega|Fly|Ride"] = 1404.35}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 30.18, ["Ride"] = 61.69, ["Fly|Ride"] = 104.9, ["Neon"] = 160.74, ["Neon|Ride"] = 222.08, ["Mega"] = 1280.08, ["Mega|Ride"] = 888.29, ["Mega|Fly|Ride"] = 816.38}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 9.74, ["Ride"] = 26.23, ["Fly|Ride"] = 141.72, ["Neon"] = 57.12, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 265.55, ["Mega"] = 302.3, ["Mega|Fly|Ride"] = 460.68}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 25.66, ["Ride"] = 52.88, ["Neon"] = 85.32, ["Neon|Ride"] = 328.46, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 282.57, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 320.34}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 16.65, ["Fly"] = 126.92, ["Ride"] = 77.44, ["Neon"] = 120.75, ["Neon|Ride"] = 320.25, ["Neon|Fly|Ride"] = 525, ["Mega"] = 525, ["Mega|Fly"] = 567, ["Mega|Ride"] = 476.44, ["Mega|Fly|Ride"] = 738.23}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 9.19}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 4.99, ["Fly"] = 131248.69, ["Ride"] = 24.92, ["Fly|Ride"] = 71.93, ["Neon"] = 37.59, ["Neon|Ride"] = 41.89, ["Neon|Fly|Ride"] = 213.62, ["Mega"] = 196.88, ["Mega|Fly"] = 453.68, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 279.42}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.1, ["Ride"] = 46.85, ["Neon"] = 10.27, ["Neon|Fly|Ride"] = 211.52, ["Mega"] = 134.32, ["Mega|Fly|Ride"] = 479.9}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 34.04, ["Fly"] = 63, ["Ride"] = 31.18, ["Fly|Ride"] = 79.33, ["Neon"] = 202.02, ["Neon|Ride"] = 168.15, ["Neon|Fly|Ride"] = 198.19, ["Mega"] = 848.19, ["Mega|Ride"] = 681.75, ["Mega|Fly|Ride"] = 733.69}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 4.81, ["Fly"] = 17.9, ["Ride"] = 15.9, ["Fly|Ride"] = 40.2, ["Neon"] = 18.68, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 28.69, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 198.19, ["Mega|Ride"] = 150.86, ["Mega|Fly|Ride"] = 233.63}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 5.25, ["Fly"] = 37.03, ["Ride"] = 27.74, ["Fly|Ride"] = 56.27, ["Neon"] = 14.44, ["Neon|Ride"] = 44.01, ["Neon|Fly|Ride"] = 125.45, ["Mega"] = 141.58, ["Mega|Ride"] = 140.2, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Ride"] = 141.72, ["Neon"] = 3.8, ["Mega"] = 42.32, ["Mega|Ride"] = 203.43, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 27.76, ["Fly"] = 78.74, ["Ride"] = 49.03, ["Fly|Ride"] = 105, ["Neon"] = 215.74, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 501.48, ["Mega"] = 524.99, ["Mega|Ride"] = 905.21, ["Mega|Fly|Ride"] = 801.94}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 15.88, ["Fly|Ride"] = 65.63, ["Neon"] = 3.7, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 49.72, ["Mega"] = 78.66, ["Mega|Ride"] = 139.94}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 7.77, ["Ride"] = 80.37, ["Fly|Ride"] = 63, ["Neon"] = 65.1, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 399, ["Mega|Fly|Ride"] = 684.21}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 14.6, ["Fly|Ride"] = 41.91, ["Neon"] = 16.96, ["Neon|Ride"] = 30.09, ["Neon|Fly|Ride"] = 48.01, ["Mega"] = 194.25, ["Mega|Ride"] = 208.04, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 23.94, ["Fly|Ride"] = 65.17, ["Neon"] = 40.69, ["Neon|Ride"] = 36.75, ["Mega"] = 291.38, ["Mega|Ride"] = 421.95, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.92, ["Ride"] = 73.7, ["Neon"] = 88.45, ["Neon|Ride"] = 77.43, ["Mega"] = 413.86, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 40.85, ["Ride"] = 84.62, ["Neon"] = 281.31, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 630, ["Mega"] = 1746.96}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 13.55, ["Ride"] = 113.16, ["Neon"] = 99.42, ["Neon|Ride"] = 183.75, ["Mega"] = 328.02, ["Mega|Ride"] = 380.71, ["Mega|Fly|Ride"] = 607.01}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 15.6, ["Ride"] = 125.99, ["Neon"] = 57.75, ["Neon|Fly"] = 211.52, ["Neon|Ride"] = 170.63, ["Mega|Ride"] = 844.93, ["Mega|Fly|Ride"] = 564.71}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 20.83, ["Ride"] = 69.57, ["Fly|Ride"] = 367.46, ["Neon"] = 107.63, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 643.13, ["Mega|Fly"] = 2114.97, ["Mega|Ride"] = 719.82, ["Mega|Fly|Ride"] = 733.9}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.05, ["Neon"] = 13.57, ["Neon|Ride"] = 80.39, ["Mega"] = 181.91, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 320.34}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 27.5, ["Ride"] = 14.34, ["Fly|Ride"] = 42.32, ["Neon"] = 5.88, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 25.39, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 70.87, ["Mega|Ride"] = 71.31, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 2.1, ["Fly"] = 50.77, ["Ride"] = 28.56, ["Fly|Ride"] = 69.56, ["Neon"] = 10.96, ["Neon|Ride"] = 88.77, ["Neon|Fly|Ride"] = 113.16, ["Mega"] = 74.82, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 28.56, ["Ride"] = 15.75, ["Fly|Ride"] = 57.3, ["Neon"] = 5.98, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 107.62, ["Mega"] = 42.75, ["Mega|Ride"] = 83.99, ["Mega|Fly|Ride"] = 204.08}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 23.28, ["Fly|Ride"] = 84, ["Neon"] = 16.94, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 84.62, ["Mega"] = 253.81, ["Mega|Ride"] = 324.19, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 6.35, ["Fly"] = 65.63, ["Ride"] = 24.39, ["Fly|Ride"] = 423.01, ["Neon"] = 28.69, ["Neon|Fly"] = 315, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 300.34, ["Mega|Ride"] = 287.46, ["Mega|Fly|Ride"] = 1057.49}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.93, ["Fly"] = 131.25, ["Ride"] = 21.74, ["Fly|Ride"] = 70.87, ["Neon"] = 19.39, ["Neon|Fly"] = 113.16, ["Neon|Ride"] = 29.75, ["Neon|Fly|Ride"] = 101.07, ["Mega"] = 292.69, ["Mega|Ride"] = 225.69, ["Mega|Fly|Ride"] = 283.74}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.49, ["Ride"] = 19.59, ["Fly|Ride"] = 49.88, ["Neon"] = 22.22, ["Neon|Ride"] = 41.86, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 253.81, ["Mega|Ride"] = 150.94, ["Mega|Fly|Ride"] = 186.18}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 5.1, ["Fly"] = 65.63, ["Ride"] = 44.18, ["Fly|Ride"] = 91.86, ["Neon"] = 9.37, ["Neon|Fly"] = 437.05, ["Neon|Ride"] = 58.31, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 113.6, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 128.51, ["Mega|Fly|Ride"] = 237.51}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 18.37, ["Fly"] = 211.52, ["Ride"] = 106.26, ["Fly|Ride"] = 375.16, ["Neon"] = 137.82, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 472.5, ["Mega|Ride"] = 577.71, ["Mega|Fly|Ride"] = 623.44}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 42.32, ["Fly"] = 164.07, ["Ride"] = 82.69, ["Fly|Ride"] = 181.91, ["Neon"] = 200.49, ["Neon|Ride"] = 185.07, ["Neon|Fly|Ride"] = 283.75, ["Mega"] = 1332.36, ["Mega|Ride"] = 923.49, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 51.08, ["Ride"] = 18.37, ["Fly|Ride"] = 118.12, ["Neon"] = 2.1, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 24.02, ["Mega|Ride"] = 47.86, ["Mega|Fly|Ride"] = 145.47}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 6.08, ["Ride"] = 52.5, ["Neon"] = 117.7, ["Mega"] = 686.56, ["Mega|Ride"] = 676.8, ["Mega|Fly|Ride"] = 1116.7}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 46.99, ["Ride"] = 72.19, ["Neon"] = 326.96, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 844.93, ["Mega"] = 1741.68, ["Mega|Ride"] = 1128.35, ["Mega|Fly|Ride"] = 1374.74}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 5.07, ["Fly"] = 190.32, ["Ride"] = 27.46, ["Fly|Ride"] = 133.88, ["Neon"] = 40.26, ["Neon|Fly"] = 128.36, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 126, ["Mega"] = 161.44, ["Mega|Ride"] = 232.61, ["Mega|Fly|Ride"] = 248.07}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 6.07, ["Ride"] = 68.82, ["Neon"] = 11.44, ["Neon|Ride"] = 70.74, ["Neon|Fly|Ride"] = 141.72, ["Mega"] = 104.9, ["Mega|Ride"] = 211.52, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 25.76, ["Ride"] = 15.65, ["Fly|Ride"] = 57.12, ["Neon"] = 11.43, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 101.42, ["Mega"] = 160.78, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.75, ["Ride"] = 12.7, ["Fly|Ride"] = 42.15, ["Neon"] = 2.1, ["Neon|Fly"] = 30.84, ["Neon|Ride"] = 26.16, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 28.56, ["Mega|Ride"] = 69.56, ["Mega|Fly|Ride"] = 150.73}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 15.12, ["Fly|Ride"] = 52.5, ["Neon"] = 3.94, ["Neon|Ride"] = 21.44, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 39.05, ["Mega|Ride"] = 61.35, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 2.63, ["Neon|Ride"] = 145.07, ["Mega"] = 28.23, ["Mega|Fly|Ride"] = 328.02}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 4.23, ["Ride"] = 105, ["Neon"] = 38.99, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 184.02, ["Mega|Fly|Ride"] = 320.34}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 5.57, ["Ride"] = 34.13, ["Fly|Ride"] = 208.71, ["Neon"] = 53.72, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 70.87, ["Mega"] = 223.13, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 6.18, ["Fly"] = 20.58, ["Ride"] = 16.7, ["Fly|Ride"] = 37.86, ["Neon"] = 28.49, ["Neon|Fly"] = 57.59, ["Neon|Ride"] = 29.8, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 355.13, ["Mega|Ride"] = 225.11, ["Mega|Fly|Ride"] = 348.78}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 60.29, ["Ride"] = 160.72, ["Fly|Ride"] = 262.5, ["Neon"] = 393.75, ["Neon|Ride"] = 564.71, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 15.75, ["Fly"] = 82.69, ["Ride"] = 43.22, ["Fly|Ride"] = 84.62, ["Neon"] = 133.26, ["Neon|Fly|Ride"] = 630, ["Mega"] = 640.65, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 705.34}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 15.65, ["Fly|Ride"] = 38, ["Neon"] = 2.1, ["Neon|Fly"] = 42.32, ["Neon|Ride"] = 19.95, ["Neon|Fly|Ride"] = 57.12, ["Mega"] = 30.34, ["Mega|Ride"] = 91.58, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 21.16, ["Ride"] = 14.31, ["Fly|Ride"] = 35.15, ["Neon"] = 3.94, ["Neon|Fly"] = 28.56, ["Neon|Ride"] = 19.05, ["Neon|Fly|Ride"] = 43.31, ["Mega"] = 39.38, ["Mega|Ride"] = 70.03, ["Mega|Fly|Ride"] = 91.77}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 509.61, ["Ride"] = 439.69, ["Fly|Ride"] = 426.57, ["Neon|Fly|Ride"] = 1881.26}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 5.25, ["Fly"] = 105.76, ["Ride"] = 57.12, ["Fly|Ride"] = 113.16, ["Neon"] = 39.15, ["Neon|Ride"] = 113.16, ["Mega"] = 403.5, ["Mega|Ride"] = 400.32, ["Mega|Fly|Ride"] = 917.44}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 15.43, ["Ride"] = 13.95, ["Fly|Ride"] = 32.4, ["Neon"] = 5.15, ["Neon|Fly"] = 18.02, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 31.07, ["Mega|Ride"] = 78.27, ["Mega|Fly|Ride"] = 106.42}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 51.86, ["Ride"] = 97.95, ["Fly|Ride"] = 261.19, ["Neon"] = 227.07, ["Neon|Ride"] = 338.41, ["Neon|Fly|Ride"] = 367.26, ["Mega"] = 735, ["Mega|Ride"] = 761.25, ["Mega|Fly|Ride"] = 878.37}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.02, ["Fly|Ride"] = 39.38, ["Neon"] = 12.16, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 25.12, ["Neon|Fly|Ride"] = 70.66, ["Mega"] = 118.13, ["Mega|Ride"] = 141.72, ["Mega|Fly|Ride"] = 184.21}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 32.82, ["Fly|Ride"] = 196.88, ["Neon"] = 2.21, ["Neon|Fly"] = 99.42, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 74.96, ["Mega"] = 18.19, ["Mega|Ride"] = 75.09, ["Mega|Fly|Ride"] = 208.95}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 35.44, ["Fly"] = 128, ["Ride"] = 78.66, ["Fly|Ride"] = 213.56, ["Neon"] = 160.74, ["Neon|Ride"] = 157.31, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 800.21, ["Mega|Ride"] = 634.5, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 18.27, ["Ride"] = 18.17, ["Fly|Ride"] = 146.99, ["Neon"] = 6.28, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 78.27, ["Mega"] = 25.99, ["Mega|Ride"] = 150.64, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 26.24, ["Ride"] = 69.46, ["Fly|Ride"] = 120.57, ["Neon"] = 423.01, ["Neon|Ride"] = 246.78, ["Neon|Fly|Ride"] = 288.46, ["Mega"] = 1670.83, ["Mega|Ride"] = 761.4}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.6, ["Fly"] = 70.87, ["Ride"] = 131.24, ["Fly|Ride"] = 423.01, ["Neon"] = 17.06, ["Neon|Ride"] = 231, ["Neon|Fly|Ride"] = 493.85, ["Mega"] = 232.76, ["Mega|Ride"] = 190.36, ["Mega|Fly|Ride"] = 317.25}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 70.87, ["Ride"] = 71.3, ["Fly|Ride"] = 70.87, ["Neon"] = 7.7, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 432.36, ["Mega"] = 103.65, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 36.75, ["Fly"] = 141.72, ["Ride"] = 59.19, ["Fly|Ride"] = 131.25, ["Mega|Ride"] = 1691.97, ["Mega|Fly|Ride"] = 1965.87}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 443.2, ["Ride"] = 38.07, ["Neon"] = 6.24, ["Neon|Ride"] = 28.56, ["Neon|Fly|Ride"] = 157.18, ["Mega"] = 42, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 227.43}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 20.06, ["Ride"] = 19.49, ["Fly|Ride"] = 102.88, ["Neon"] = 10.28, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 26.22, ["Neon|Fly|Ride"] = 72, ["Mega"] = 160.78, ["Mega|Fly|Ride"] = 219.19}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 7.49, ["Fly"] = 57.91, ["Ride"] = 32.4, ["Fly|Ride"] = 112.11, ["Neon"] = 79.94, ["Neon|Ride"] = 88.77, ["Neon|Fly|Ride"] = 144.27, ["Mega"] = 328.12, ["Mega|Ride"] = 300.57, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 10.58, ["Fly"] = 57.12, ["Ride"] = 23.78, ["Fly|Ride"] = 78.75, ["Neon"] = 63.59, ["Neon|Ride"] = 76.15, ["Neon|Fly|Ride"] = 144.37, ["Mega"] = 480.11, ["Mega|Ride"] = 291.38, ["Mega|Fly|Ride"] = 556.24}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 20.68, ["Fly"] = 28.56, ["Ride"] = 28.08, ["Fly|Ride"] = 53.34, ["Neon"] = 72.19, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 122.04, ["Mega"] = 393.4, ["Mega|Ride"] = 311.97, ["Mega|Fly|Ride"] = 389.28}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 60.23, ["Ride"] = 114.02, ["Fly|Ride"] = 252.75, ["Neon"] = 346.5, ["Neon|Ride"] = 354.38, ["Neon|Fly|Ride"] = 560.26, ["Mega|Ride"] = 1495.28, ["Mega|Fly|Ride"] = 1312.49}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 6.48, ["Ride"] = 70.17, ["Neon"] = 28.91, ["Neon|Ride"] = 113.16, ["Neon|Fly|Ride"] = 296.09, ["Mega"] = 234.31, ["Mega|Ride"] = 296.15, ["Mega|Fly|Ride"] = 423.01}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 4.9, ["Ride"] = 27.09, ["Fly|Ride"] = 70.87, ["Neon"] = 19.01, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 262.5, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 246.62}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 6.57, ["Fly"] = 287.55, ["Ride"] = 28.75, ["Fly|Ride"] = 155.36, ["Neon"] = 41.26, ["Neon|Ride"] = 84.62, ["Mega"] = 448.69, ["Mega|Ride"] = 592.2, ["Mega|Fly|Ride"] = 761.25}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.44, ["Ride"] = 15.65, ["Fly|Ride"] = 37.21, ["Neon"] = 2.1, ["Neon|Fly"] = 21.69, ["Neon|Ride"] = 15.43, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 13.75, ["Mega|Ride"] = 26.76, ["Mega|Fly|Ride"] = 57.75}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 51.17, ["Ride"] = 112.56, ["Fly|Ride"] = 282.36, ["Neon"] = 236.24, ["Neon|Fly"] = 2397.31, ["Neon|Ride"] = 279.57, ["Neon|Fly|Ride"] = 423.01, ["Mega|Ride"] = 944.99, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 21.69, ["Fly|Ride"] = 141.72, ["Neon"] = 2.63, ["Neon|Ride"] = 28.59, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 31.49, ["Mega|Ride"] = 141.72, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.56, ["Ride"] = 18.42, ["Fly|Ride"] = 59.06, ["Neon"] = 19.49, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 90.03, ["Mega|Ride"] = 192.94, ["Mega|Fly|Ride"] = 281.31}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 57.75, ["Ride"] = 101.07, ["Fly|Ride"] = 229.87, ["Neon"] = 229.69, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 735, ["Mega"] = 940.75, ["Mega|Ride"] = 1362.85, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 27.5, ["Fly|Ride"] = 57.12, ["Neon"] = 4.61, ["Neon|Ride"] = 1410.68, ["Mega"] = 69.57, ["Mega|Ride"] = 108.34, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 5.03}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 495.07, ["Neon"] = 4.8, ["Neon|Ride"] = 52.41, ["Neon|Fly|Ride"] = 113.9, ["Mega"] = 42.4, ["Mega|Ride"] = 97.12, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 112.86, ["Ride"] = 162.93, ["Fly|Ride"] = 236.25, ["Neon"] = 705.34, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 665.05, ["Mega|Fly|Ride"] = 2643.69}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.35, ["Ride"] = 36.47, ["Fly|Ride"] = 211.52, ["Neon"] = 19.84, ["Neon|Fly"] = 141.72, ["Neon|Ride"] = 101.5, ["Neon|Fly|Ride"] = 219.43, ["Mega"] = 178.39, ["Mega|Ride"] = 210.67, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 35.97, ["Neon"] = 2.1, ["Neon|Ride"] = 20.87, ["Mega"] = 31.4, ["Mega|Ride"] = 57.12, ["Mega|Fly|Ride"] = 282.36}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 3.61, ["Fly"] = 39.38, ["Ride"] = 21.76, ["Fly|Ride"] = 49.88, ["Neon"] = 53.37, ["Neon|Ride"] = 89.63, ["Neon|Fly|Ride"] = 153.55, ["Mega"] = 409.25, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 635.2}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 12.7, ["Fly"] = 44.02, ["Ride"] = 21.16, ["Fly|Ride"] = 56.58, ["Neon"] = 72.17, ["Neon|Ride"] = 157.4, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 619.8, ["Mega|Ride"] = 592.2, ["Mega|Fly|Ride"] = 400.71}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 17.82, ["Ride"] = 58.69, ["Fly|Ride"] = 65.63, ["Neon"] = 132.96, ["Neon|Ride"] = 176.76, ["Neon|Fly|Ride"] = 479.9, ["Mega"] = 561.75, ["Mega|Ride"] = 536.72, ["Mega|Fly|Ride"] = 599.82}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 104.98, ["Fly"] = 196.77, ["Ride"] = 161.44, ["Fly|Ride"] = 225.64, ["Neon"] = 565.13, ["Neon|Fly"] = 846, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 656.15, ["Mega|Ride"] = 2537.96, ["Mega|Fly|Ride"] = 2791.74}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 5.24, ["Fly"] = 17.46, ["Ride"] = 16.71, ["Fly|Ride"] = 43.78, ["Neon"] = 38.56, ["Neon|Fly"] = 59.99, ["Neon|Ride"] = 32.41, ["Neon|Fly|Ride"] = 78.56, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 353.21}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.52, ["Fly"] = 131.23, ["Ride"] = 16.93, ["Fly|Ride"] = 131.24, ["Neon"] = 16.78, ["Neon|Ride"] = 32.79, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 141.72, ["Mega|Ride"] = 134.32, ["Mega|Fly|Ride"] = 400.71}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 3.87, ["Fly"] = 98.44, ["Ride"] = 28.03, ["Fly|Ride"] = 169.21, ["Neon"] = 48.54, ["Neon|Ride"] = 71.64, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 393.75, ["Mega|Ride"] = 479.9, ["Mega|Fly|Ride"] = 483}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 44.63, ["Fly"] = 99.42, ["Ride"] = 70.88, ["Fly|Ride"] = 156.53, ["Neon"] = 203.44, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 212.63, ["Mega"] = 954.19, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1037.12}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 18.18, ["Fly"] = 57.75, ["Ride"] = 63.67, ["Neon"] = 111.57, ["Neon|Ride"] = 185.77, ["Neon|Fly|Ride"] = 466.36, ["Mega"] = 708.65, ["Mega|Ride"] = 846, ["Mega|Fly|Ride"] = 1127.28}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 301.88, ["Ride"] = 479.73, ["Neon|Ride"] = 3199.59}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 24.93, ["Fly"] = 36.53, ["Ride"] = 29.97, ["Fly|Ride"] = 69.57, ["Neon"] = 421.95, ["Neon|Ride"] = 158.03, ["Neon|Fly|Ride"] = 265.14, ["Mega|Ride"] = 730.96, ["Mega|Fly|Ride"] = 1057.49}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 39.11, ["Ride"] = 13.55, ["Fly|Ride"] = 42.47, ["Neon"] = 2.1, ["Neon|Ride"] = 15.18, ["Neon|Fly|Ride"] = 72, ["Mega"] = 20.76, ["Mega|Ride"] = 38.75, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.63, ["Neon"] = 6.18, ["Neon|Ride"] = 41.43, ["Neon|Fly|Ride"] = 139.59, ["Mega"] = 94.96, ["Mega|Ride"] = 111.43, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.93, ["Ride"] = 25.99, ["Fly|Ride"] = 144.21, ["Neon"] = 18.38, ["Neon|Fly"] = 87.94, ["Neon|Ride"] = 48.2, ["Neon|Fly|Ride"] = 991.1, ["Mega"] = 121.7, ["Mega|Fly"] = 493.85, ["Mega|Ride"] = 129.93, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 423.94, ["Fly"] = 493.85, ["Ride"] = 419.48, ["Fly|Ride"] = 466.36, ["Neon"] = 1533.35, ["Neon|Ride"] = 3172.44, ["Neon|Fly|Ride"] = 1246.88, ["Mega|Fly|Ride"] = 5273.64}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.63, ["Fly"] = 37.97, ["Ride"] = 15.39, ["Fly|Ride"] = 61.35, ["Neon"] = 19.69, ["Neon|Ride"] = 29.86, ["Neon|Fly|Ride"] = 97.46, ["Mega"] = 183.54, ["Mega|Ride"] = 213.93, ["Mega|Fly|Ride"] = 253.81}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 4.25, ["Fly"] = 20.1, ["Ride"] = 15.54, ["Fly|Ride"] = 39.38, ["Neon"] = 15.88, ["Neon|Fly"] = 32.8, ["Neon|Ride"] = 59.24, ["Neon|Fly|Ride"] = 92.72, ["Mega|Ride"] = 279.18, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.29, ["Fly"] = 41.91, ["Ride"] = 21.17, ["Fly|Ride"] = 78.75, ["Neon"] = 11.58, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 84.62, ["Mega"] = 102.64, ["Mega|Ride"] = 282.36, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 26.16, ["Fly"] = 47.98, ["Ride"] = 26.25, ["Fly|Ride"] = 65.63, ["Neon"] = 220.4, ["Neon|Ride"] = 196.85, ["Neon|Fly|Ride"] = 316.2, ["Mega"] = 564.71, ["Mega|Ride"] = 844.93, ["Mega|Fly|Ride"] = 586.69}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 52.88, ["Ride"] = 34.12, ["Fly|Ride"] = 51.85, ["Neon"] = 9.19, ["Neon|Ride"] = 32.4, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 457.8, ["Mega|Fly|Ride"] = 1015.19}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 7, ["Fly"] = 65.6, ["Ride"] = 27.12, ["Fly|Ride"] = 91.77, ["Neon"] = 168.9, ["Neon|Ride"] = 108.94, ["Neon|Fly|Ride"] = 353.21, ["Mega|Ride"] = 776.21}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.76, ["Neon"] = 3.68, ["Neon|Ride"] = 141.72, ["Mega"] = 51.1, ["Mega|Ride"] = 120.3, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 8.48, ["Ride"] = 141.72, ["Neon"] = 50.8, ["Mega|Ride"] = 320.34, ["Mega|Fly|Ride"] = 705.48}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 6.47, ["Ride"] = 86.73, ["Neon"] = 90.97, ["Neon|Ride"] = 282.36, ["Mega"] = 311.97, ["Mega|Ride"] = 586.57, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 7.76, ["Fly"] = 26, ["Ride"] = 24.46, ["Fly|Ride"] = 48.37, ["Neon"] = 34.13, ["Neon|Fly"] = 119.95, ["Neon|Ride"] = 54.91, ["Neon|Fly|Ride"] = 80.57, ["Mega"] = 324.65, ["Mega|Ride"] = 239.95, ["Mega|Fly|Ride"] = 305.64}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 341.25, ["Fly"] = 597.8, ["Ride"] = 411.31, ["Fly|Ride"] = 425.15, ["Neon"] = 1640.63, ["Neon|Ride"] = 1573.51, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 7473.19}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.65, ["Fly|Ride"] = 40.68, ["Neon"] = 15.65, ["Neon|Fly"] = 80.38, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 49.72, ["Mega"] = 247.46, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 301.13}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 7.87, ["Fly"] = 113.16, ["Ride"] = 43.2, ["Fly|Ride"] = 131.25, ["Neon"] = 57.74, ["Neon|Ride"] = 122.03, ["Neon|Fly|Ride"] = 210, ["Mega"] = 378.29, ["Mega|Fly"] = 705.34, ["Mega|Ride"] = 415.8, ["Mega|Fly|Ride"] = 497.88}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 20.96, ["Fly"] = 118.13, ["Ride"] = 71.51, ["Fly|Ride"] = 276.52, ["Neon"] = 105, ["Neon|Ride"] = 159.21, ["Neon|Fly|Ride"] = 353.21, ["Mega"] = 479.9, ["Mega|Ride"] = 356.03, ["Mega|Fly|Ride"] = 513.24}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 45.93, ["Fly"] = 146.86, ["Ride"] = 56.11, ["Fly|Ride"] = 157.5, ["Neon"] = 320.25, ["Neon|Ride"] = 282.36, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 2492.09, ["Mega|Ride"] = 1903.48, ["Mega|Fly|Ride"] = 1678.23}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 4.81, ["Fly"] = 105.76, ["Ride"] = 52.5, ["Fly|Ride"] = 128.63, ["Neon"] = 32.82, ["Neon|Fly"] = 95.97, ["Neon|Ride"] = 104.9, ["Neon|Fly|Ride"] = 245.44, ["Mega"] = 141.72, ["Mega|Ride"] = 224.42, ["Mega|Fly|Ride"] = 342.23}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 16.94, ["Ride"] = 17.07, ["Fly|Ride"] = 58.47, ["Neon"] = 13.02, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 126.93, ["Mega"] = 65.62, ["Mega|Ride"] = 160.78, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 4.72, ["Ride"] = 28.56, ["Neon"] = 19.69, ["Neon|Ride"] = 105.73, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 101.07, ["Mega|Fly|Ride"] = 294.58}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 40.69, ["Fly"] = 137.8, ["Ride"] = 65.54, ["Fly|Ride"] = 216.57, ["Neon"] = 110.43, ["Neon|Ride"] = 141.37, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 420, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.24, ["Ride"] = 85.32, ["Neon"] = 6.36, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 49.14, ["Mega|Ride"] = 185.07, ["Mega|Fly|Ride"] = 423.01}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 18.24, ["Ride"] = 211.52, ["Neon"] = 131.25, ["Neon|Ride"] = 401.03, ["Neon|Fly|Ride"] = 846, ["Mega"] = 492.19, ["Mega|Fly|Ride"] = 685.74}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 892.5, ["Fly"] = 1004.07, ["Ride"] = 1018.5, ["Fly|Ride"] = 1152.38, ["Neon"] = 3488.62, ["Neon|Ride"] = 3526.69, ["Neon|Fly|Ride"] = 3281.23, ["Mega|Fly|Ride"] = 10293.48}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 13.13, ["Fly"] = 120.65, ["Ride"] = 57.3, ["Fly|Ride"] = 173.25, ["Neon"] = 59.85, ["Neon|Fly"] = 704.29, ["Neon|Ride"] = 141.72, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 326.49, ["Mega|Ride"] = 328.27, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.37, ["Ride"] = 22.75, ["Fly|Ride"] = 90.55, ["Neon"] = 6.65, ["Neon|Fly"] = 42.32, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 57.54, ["Mega|Ride"] = 78.73, ["Mega|Fly|Ride"] = 169.21}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 9.08, ["Ride"] = 57.12, ["Fly|Ride"] = 141.72, ["Neon"] = 57.68, ["Neon|Fly"] = 83.55, ["Neon|Fly|Ride"] = 393.73, ["Mega"] = 266.13, ["Mega|Ride"] = 551.39, ["Mega|Fly|Ride"] = 924}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Fly|Ride"] = 184.03, ["Neon"] = 2.63, ["Neon|Fly"] = 141.72, ["Neon|Ride"] = 17.06, ["Neon|Fly|Ride"] = 93.17, ["Mega"] = 15.94, ["Mega|Ride"] = 38.19, ["Mega|Fly|Ride"] = 169.21}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 53.17, ["Ride"] = 102.38, ["Fly|Ride"] = 236.24, ["Neon"] = 230.26, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 361.81, ["Mega"] = 918.75, ["Mega|Ride"] = 1038.98, ["Mega|Fly|Ride"] = 913.24}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 7.75, ["Ride"] = 62.91, ["Fly|Ride"] = 282.36, ["Neon"] = 83.91, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 480.11, ["Mega|Ride"] = 592.2, ["Mega|Fly|Ride"] = 634.5}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 19.46, ["Neon"] = 6.39, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 211.52, ["Mega"] = 89.02, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 466.36}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 15.74, ["Fly"] = 52.5, ["Ride"] = 32.82, ["Fly|Ride"] = 112.11, ["Neon"] = 50.96, ["Neon|Ride"] = 86.05, ["Neon|Fly|Ride"] = 141.72, ["Mega"] = 1039.5, ["Mega|Ride"] = 344.75, ["Mega|Fly|Ride"] = 391.13}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 8.38, ["Fly"] = 32.8, ["Ride"] = 30.86, ["Fly|Ride"] = 80.37, ["Neon"] = 119.44, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 131.67, ["Mega"] = 322.38, ["Mega|Ride"] = 226.32, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 33.28, ["Ride"] = 208.69, ["Neon"] = 163.93, ["Neon|Ride"] = 549.94, ["Neon|Fly|Ride"] = 721.88, ["Mega"] = 2114.97, ["Mega|Ride"] = 2397.31, ["Mega|Fly|Ride"] = 1689.85}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 4.8, ["Ride"] = 48.27, ["Fly|Ride"] = 184.11, ["Neon"] = 13.79, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 161.21, ["Mega"] = 118.12, ["Mega|Ride"] = 218.92, ["Mega|Fly|Ride"] = 227.05}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 14.39, ["Fly"] = 27.5, ["Ride"] = 20.01, ["Fly|Ride"] = 89.25, ["Neon"] = 44.02, ["Neon|Fly"] = 184.02, ["Neon|Ride"] = 58.47, ["Neon|Fly|Ride"] = 87, ["Mega"] = 283.64, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 676.8}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 105.48, ["Fly"] = 393.75, ["Ride"] = 154.76, ["Fly|Ride"] = 236.25, ["Neon"] = 441, ["Neon|Fly"] = 426.57, ["Neon|Ride"] = 409.19, ["Neon|Fly|Ride"] = 649.74, ["Mega|Ride"] = 2773.77, ["Mega|Fly|Ride"] = 2176}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 24.92, ["Ride"] = 18.38, ["Fly|Ride"] = 55.04, ["Neon"] = 11.12, ["Neon|Fly"] = 57.32, ["Neon|Ride"] = 28.56, ["Neon|Fly|Ride"] = 71.74, ["Mega"] = 145.69, ["Mega|Ride"] = 239.49, ["Mega|Fly|Ride"] = 206.28}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 15.38, ["Fly"] = 201.42, ["Ride"] = 38.26, ["Fly|Ride"] = 116.81, ["Neon"] = 94.85, ["Neon|Ride"] = 106.08, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 452.81, ["Mega|Ride"] = 498.74, ["Mega|Fly|Ride"] = 537.22}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.27, ["Ride"] = 13.13, ["Fly|Ride"] = 52.5, ["Neon"] = 2.1, ["Neon|Fly"] = 27.62, ["Neon|Ride"] = 15.16, ["Neon|Fly|Ride"] = 39.64, ["Mega"] = 15.75, ["Mega|Ride"] = 34.93, ["Mega|Fly|Ride"] = 80.06}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 57.12, ["Fly|Ride"] = 39.38, ["Neon"] = 3.51, ["Neon|Ride"] = 42.32, ["Neon|Fly|Ride"] = 131.14, ["Mega"] = 18.38, ["Mega|Fly"] = 105, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 168.15}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 35.97, ["Ride"] = 24.01, ["Fly|Ride"] = 133.88, ["Neon"] = 11.57, ["Neon|Ride"] = 55.54, ["Neon|Fly|Ride"] = 84.62, ["Mega"] = 85.32, ["Mega|Ride"] = 268.62, ["Mega|Fly|Ride"] = 246.1}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 32.82, ["Ride"] = 55, ["Fly|Ride"] = 131.25, ["Neon"] = 181.73, ["Neon|Ride"] = 338.41, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 506.76, ["Mega|Ride"] = 719.1}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 15.88, ["Ride"] = 15.88, ["Fly|Ride"] = 37.03, ["Neon"] = 9.19, ["Neon|Fly"] = 21.16, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 55.2, ["Mega"] = 111.57, ["Mega|Fly"] = 170.63, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 156.19}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 6.45, ["Fly"] = 29.8, ["Ride"] = 24.69, ["Fly|Ride"] = 96.02, ["Neon"] = 30.19, ["Neon|Fly"] = 55.88, ["Neon|Ride"] = 38.84, ["Neon|Fly|Ride"] = 113.16, ["Mega"] = 231, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 305.34}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 27.5, ["Ride"] = 18.09, ["Fly|Ride"] = 71.93, ["Neon"] = 8.87, ["Neon|Fly"] = 70.87, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 78.27, ["Mega|Fly"] = 80.39, ["Mega|Ride"] = 58.47, ["Mega|Fly|Ride"] = 125.9}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 5.96, ["Fly"] = 159.69, ["Ride"] = 23.15, ["Fly|Ride"] = 217.19, ["Neon"] = 37.29, ["Neon|Ride"] = 79.8, ["Neon|Fly|Ride"] = 282.36, ["Mega"] = 234.38, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 379.64, ["Mega|Fly|Ride"] = 320.25}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 3.94, ["Fly"] = 42.32, ["Ride"] = 36.02, ["Neon"] = 50.05, ["Neon|Ride"] = 144.38, ["Mega"] = 682.5, ["Mega|Fly|Ride"] = 987.7}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 6.57, ["Fly"] = 21.59, ["Ride"] = 15.74, ["Fly|Ride"] = 49.1, ["Neon"] = 21.95, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 38.64, ["Neon|Fly|Ride"] = 104.7, ["Mega"] = 239.95, ["Mega|Ride"] = 305.82, ["Mega|Fly|Ride"] = 564.71}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 16.7, ["Ride"] = 14.6, ["Fly|Ride"] = 52.45, ["Neon"] = 11.46, ["Neon|Fly"] = 70.51, ["Neon|Ride"] = 25.39, ["Neon|Fly|Ride"] = 70.87, ["Mega"] = 185.07, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 156.53}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 191.44, ["Fly"] = 393.75, ["Ride"] = 273, ["Fly|Ride"] = 392.44, ["Neon"] = 1228.21, ["Neon|Ride"] = 1128.35, ["Neon|Fly|Ride"] = 1174.69, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.82, ["Ride"] = 65.63, ["Neon"] = 21, ["Neon|Ride"] = 141.72, ["Neon|Fly|Ride"] = 423.01, ["Mega"] = 122.07, ["Mega|Ride"] = 638.67, ["Mega|Fly|Ride"] = 353.21}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.63, ["Fly"] = 106.16, ["Ride"] = 22.46, ["Fly|Ride"] = 84.62, ["Neon"] = 23.39, ["Neon|Fly"] = 240.06, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 207.8, ["Mega|Ride"] = 194.9, ["Mega|Fly|Ride"] = 493.85}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 2.45, ["Fly|Ride"] = 212.89, ["Neon"] = 36.66, ["Neon|Ride"] = 224.21, ["Neon|Fly|Ride"] = 603.74, ["Mega"] = 596.54, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.08, ["Fly|Ride"] = 32.34, ["Neon"] = 2.1, ["Neon|Fly"] = 35.44, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 35.44, ["Mega"] = 18.21, ["Mega|Ride"] = 42, ["Mega|Fly|Ride"] = 65.63}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 4.25, ["Fly"] = 42, ["Ride"] = 16.52, ["Fly|Ride"] = 56.97, ["Neon"] = 14.04, ["Neon|Ride"] = 28.56, ["Neon|Fly|Ride"] = 107.63, ["Mega"] = 116.94, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 183.65}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.1, ["Ride"] = 141.72, ["Neon"] = 8.34, ["Neon|Ride"] = 141.72, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 43.31, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 253.81}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 70.86, ["Fly"] = 104.99, ["Ride"] = 105.28, ["Fly|Ride"] = 141.72, ["Neon"] = 385.88, ["Neon|Ride"] = 409.49, ["Neon|Fly|Ride"] = 421.95, ["Mega|Ride"] = 3526.69, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 4.8, ["Fly"] = 94.5, ["Ride"] = 26.24, ["Fly|Ride"] = 99.42, ["Neon"] = 23.37, ["Neon|Ride"] = 66.94, ["Mega"] = 167.99, ["Mega|Ride"] = 140.33, ["Mega|Fly|Ride"] = 344.75}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.31, ["Fly"] = 48.66, ["Ride"] = 34.12, ["Neon"] = 5.55, ["Neon|Ride"] = 80.94, ["Neon|Fly|Ride"] = 542.29, ["Mega"] = 60, ["Mega|Fly"] = 315, ["Mega|Ride"] = 125.9, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 44.57, ["Fly"] = 131.25, ["Ride"] = 91.88, ["Fly|Ride"] = 207.27, ["Neon"] = 144.38, ["Neon|Ride"] = 162.56, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 496.13, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 634.5}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 17.05, ["Ride"] = 14.44, ["Fly|Ride"] = 32.04, ["Neon"] = 2.1, ["Neon|Fly"] = 16.7, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 19.57, ["Mega|Ride"] = 32.99, ["Mega|Fly|Ride"] = 118.12}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 26.17, ["Fly|Ride"] = 105.76, ["Neon"] = 3.56, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 285.32, ["Mega"] = 23.99, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 176.06}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 3.52, ["Ride"] = 47.16, ["Neon"] = 9.81, ["Neon|Ride"] = 108.94, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 53.95, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 210.78}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 12.32, ["Fly"] = 80.07, ["Ride"] = 52.88, ["Fly|Ride"] = 128.33, ["Neon"] = 18.38, ["Neon|Fly"] = 91.55, ["Neon|Ride"] = 84.62, ["Neon|Fly|Ride"] = 141.72, ["Mega"] = 104.81, ["Mega|Ride"] = 171.71, ["Mega|Fly|Ride"] = 275.52}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 20.79, ["Ride"] = 14.22, ["Fly|Ride"] = 32.4, ["Neon"] = 2.1, ["Neon|Fly"] = 24.5, ["Neon|Ride"] = 11.82, ["Neon|Fly|Ride"] = 44.35, ["Mega"] = 18.38, ["Mega|Ride"] = 62.41, ["Mega|Fly|Ride"] = 78.4}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 18.78, ["Fly"] = 131.25, ["Ride"] = 53.27, ["Neon"] = 129.94, ["Neon|Fly"] = 423.01, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 502.31, ["Mega|Ride"] = 590.62, ["Mega|Fly|Ride"] = 640.65}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2231.25, ["Fly"] = 3150, ["Ride"] = 2208.93, ["Fly|Ride"] = 2245.93, ["Neon"] = 10574.76, ["Neon|Fly|Ride"] = 9728.79, ["Mega|Fly|Ride"] = 42297.97}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 16.94, ["Ride"] = 14.15, ["Fly|Ride"] = 32.8, ["Neon"] = 9.01, ["Neon|Fly"] = 58.52, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 57.12, ["Mega"] = 78.75, ["Mega|Ride"] = 79.71, ["Mega|Fly|Ride"] = 158.5}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Neon"] = 8.3, ["Mega"] = 107.01, ["Mega|Fly"] = 441, ["Mega|Ride"] = 161.44, ["Mega|Fly|Ride"] = 282.36}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 16.38, ["Fly"] = 42.32, ["Ride"] = 24.49, ["Fly|Ride"] = 119.94, ["Neon"] = 73.48, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 211.52, ["Mega"] = 459.38, ["Mega|Ride"] = 394.02, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 23.84, ["Fly"] = 90.96, ["Ride"] = 63.2, ["Neon"] = 187.69, ["Neon|Ride"] = 190.32, ["Mega"] = 425.66, ["Mega|Ride"] = 423.01, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 128.52, ["Fly"] = 211.52, ["Ride"] = 156.18, ["Fly|Ride"] = 251.5, ["Neon"] = 1312.5, ["Neon|Ride"] = 714.66, ["Neon|Fly|Ride"] = 701.01, ["Mega"] = 6344.87, ["Mega|Fly|Ride"] = 3750.88}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 6.46, ["Ride"] = 32.8, ["Fly|Ride"] = 675.94, ["Neon"] = 19.68, ["Neon|Ride"] = 83.77, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 144.45, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 224.35, ["Mega|Fly|Ride"] = 359.56}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.25, ["Ride"] = 35.44, ["Neon"] = 19.05, ["Neon|Ride"] = 114.85, ["Mega"] = 245.44, ["Mega|Ride"] = 333.27, ["Mega|Fly|Ride"] = 267.09}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 102, ["Ride"] = 26.25, ["Fly|Ride"] = 131.25, ["Neon"] = 6.4, ["Neon|Fly"] = 92.02, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 73.5, ["Mega|Ride"] = 105.14, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 13.13, ["Ride"] = 50.32, ["Fly|Ride"] = 131.25, ["Neon"] = 98.44, ["Neon|Ride"] = 173.44, ["Neon|Fly|Ride"] = 498.09, ["Mega"] = 383.91, ["Mega|Ride"] = 466.36, ["Mega|Fly|Ride"] = 597.85}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 42.32, ["Neon"] = 2.1, ["Neon|Ride"] = 33.86, ["Mega"] = 15.75, ["Mega|Fly"] = 119.99, ["Mega|Ride"] = 79.97, ["Mega|Fly|Ride"] = 134.54}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 89.12, ["Fly"] = 104.9, ["Ride"] = 104.98, ["Fly|Ride"] = 141.72, ["Neon"] = 301.46, ["Neon|Fly"] = 452.62, ["Neon|Ride"] = 403.31, ["Neon|Fly|Ride"] = 308.38, ["Mega"] = 3172.44, ["Mega|Fly|Ride"] = 1685.63}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Fly"] = 28.56, ["Ride"] = 91.83, ["Neon"] = 2.96, ["Neon|Ride"] = 141.72, ["Neon|Fly|Ride"] = 211.52, ["Mega"] = 70.88, ["Mega|Ride"] = 281.54, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 35.22, ["Fly"] = 101.54, ["Ride"] = 65.62, ["Fly|Ride"] = 188.4, ["Neon"] = 255.94, ["Neon|Ride"] = 338.41, ["Neon|Fly|Ride"] = 453.91, ["Mega"] = 2625, ["Mega|Fly|Ride"] = 2519.97}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 18.37, ["Ride"] = 21.17, ["Fly|Ride"] = 51.85, ["Neon"] = 3.68, ["Neon|Fly"] = 87.45, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 42, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 142.8}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.63, ["Fly|Ride"] = 108.94, ["Neon"] = 9.38, ["Neon|Ride"] = 98.44, ["Mega"] = 131.25, ["Mega|Ride"] = 143.08, ["Mega|Fly|Ride"] = 531.2}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 5.92, ["Fly"] = 77.43, ["Ride"] = 32.8, ["Neon"] = 23.63, ["Neon|Ride"] = 79.97, ["Neon|Fly|Ride"] = 141.72, ["Mega"] = 367.5, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 562.59}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 337.31, ["Ride"] = 402.94, ["Fly|Ride"] = 459.38, ["Neon"] = 947.65, ["Neon|Ride"] = 980.4, ["Neon|Fly|Ride"] = 1076.25, ["Mega"] = 3242.24, ["Mega|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 2733.54}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 26.17, ["Fly"] = 57.12, ["Ride"] = 45.45, ["Fly|Ride"] = 126.93, ["Neon"] = 161.44, ["Neon|Ride"] = 211.52, ["Neon|Fly|Ride"] = 317.63, ["Mega"] = 1408.57, ["Mega|Ride"] = 1120.94, ["Mega|Fly|Ride"] = 1691.97}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 49.88, ["Ride"] = 19.59, ["Fly|Ride"] = 111.57, ["Neon"] = 12.58, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 24.07, ["Neon|Fly|Ride"] = 98.34, ["Mega"] = 124.59, ["Mega|Ride"] = 197.76, ["Mega|Fly|Ride"] = 314.88}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 22.31, ["Fly"] = 38.89, ["Ride"] = 49.87, ["Fly|Ride"] = 163.93, ["Neon"] = 71.31, ["Neon|Fly"] = 160.74, ["Neon|Ride"] = 142.31, ["Neon|Fly|Ride"] = 183.65, ["Mega"] = 255.94, ["Mega|Fly"] = 423.01, ["Mega|Ride"] = 389.17, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 8.58, ["Ride"] = 25.86, ["Neon"] = 101.36, ["Neon|Ride"] = 122.06, ["Neon|Fly|Ride"] = 253.81, ["Mega"] = 423.01, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 425.81}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.84, ["Neon"] = 19.59, ["Mega"] = 91.77, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 372.25}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 6.01, ["Fly"] = 70.87, ["Ride"] = 20.96, ["Fly|Ride"] = 59.41, ["Neon"] = 32.05, ["Neon|Ride"] = 50.16, ["Mega|Ride"] = 486.93, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 98.33, ["Fly"] = 208.69, ["Ride"] = 129.94, ["Fly|Ride"] = 176.61, ["Neon"] = 789.94, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 568.52, ["Mega"] = 2887.5, ["Mega|Ride"] = 3519.9, ["Mega|Fly|Ride"] = 3172.44}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 24.52, ["Ride"] = 38.58, ["Fly|Ride"] = 91.88, ["Neon"] = 131.25, ["Neon|Ride"] = 233.72, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 572.9, ["Mega|Ride"] = 705.34, ["Mega|Fly|Ride"] = 731.07}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 1763.87, ["Fly"] = 2058.97, ["Ride"] = 2034.38, ["Fly|Ride"] = 1837.5, ["Neon"] = 11280.1, ["Neon|Fly|Ride"] = 6300, ["Mega|Fly|Ride"] = 23622.92}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.52, ["Fly"] = 65625, ["Ride"] = 57.3, ["Fly|Ride"] = 196.87, ["Neon"] = 12.65, ["Neon|Fly|Ride"] = 634.5, ["Mega"] = 116.84, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 172.57, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 5.91, ["Ride"] = 48.66, ["Fly|Ride"] = 176.61, ["Neon"] = 27.57, ["Neon|Ride"] = 90.56, ["Mega"] = 138.36, ["Mega|Ride"] = 320.34, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 813.65, ["Fly"] = 1107.73, ["Ride"] = 822.93, ["Fly|Ride"] = 866.25, ["Neon"] = 2778.57, ["Neon|Ride"] = 2582.57, ["Neon|Fly|Ride"] = 2494.8, ["Mega"] = 13953.41, ["Mega|Fly|Ride"] = 11526.51}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 27.01, ["Ride"] = 49.79, ["Fly|Ride"] = 173.35, ["Neon"] = 212.91, ["Neon|Ride"] = 141.72, ["Neon|Fly|Ride"] = 353.21, ["Mega"] = 849.97, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 668.07}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.46, ["Ride"] = 23.44, ["Fly|Ride"] = 124.8, ["Neon"] = 6.54, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 157.5, ["Mega|Ride"] = 316.2, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 26.17, ["Ride"] = 141.72, ["Neon"] = 4.07, ["Neon|Ride"] = 49.14, ["Neon|Fly|Ride"] = 103.65, ["Mega"] = 19.48, ["Mega|Ride"] = 78.27, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 98.44, ["Ride"] = 129.94, ["Fly|Ride"] = 170.63, ["Neon"] = 444.15, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 630.28, ["Mega"] = 2399.38, ["Mega|Fly|Ride"] = 2114.97}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.1, ["Ride"] = 34.01, ["Fly|Ride"] = 74.03, ["Neon"] = 11.46, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 107.62, ["Mega|Ride"] = 122.04, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 72.02, ["Fly"] = 99.42, ["Ride"] = 114.7, ["Fly|Ride"] = 240.06, ["Neon"] = 459.38, ["Neon|Ride"] = 421.95, ["Mega|Fly|Ride"] = 1691.97}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 6.6, ["Fly"] = 105, ["Fly|Ride"] = 102.89, ["Neon"] = 26.25, ["Neon|Ride"] = 211.52, ["Neon|Fly|Ride"] = 269.06, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 234.82, ["Fly"] = 380.71, ["Ride"] = 287.13, ["Fly|Ride"] = 320.25, ["Neon"] = 1137.32, ["Neon|Ride"] = 1064.63, ["Neon|Fly|Ride"] = 879.04, ["Mega|Fly|Ride"] = 4648.68}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.94, ["Fly"] = 91.88, ["Ride"] = 16.49, ["Fly|Ride"] = 49.88, ["Neon"] = 28.77, ["Neon|Ride"] = 57.66, ["Neon|Fly|Ride"] = 112.77, ["Mega"] = 321.47, ["Mega|Ride"] = 168, ["Mega|Fly|Ride"] = 257.27}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 15.1, ["Ride"] = 16.92, ["Fly|Ride"] = 31.6, ["Neon"] = 4.23, ["Neon|Fly"] = 37.97, ["Neon|Ride"] = 21.19, ["Neon|Fly|Ride"] = 42.32, ["Mega"] = 41.99, ["Mega|Ride"] = 45.93, ["Mega|Fly|Ride"] = 125.99}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1266.87, ["Ride"] = 1050, ["Fly|Ride"] = 1254.19, ["Neon|Ride"] = 7755.54, ["Neon|Fly|Ride"] = 6627.22, ["Mega|Fly|Ride"] = 28199.71}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 13.21, ["Fly"] = 169.21, ["Ride"] = 72.19, ["Neon"] = 70.96, ["Neon|Ride"] = 126.92, ["Mega"] = 244.13, ["Mega|Ride"] = 284.82, ["Mega|Fly|Ride"] = 564.27}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 7.49, ["Fly"] = 39.38, ["Ride"] = 47.98, ["Fly|Ride"] = 100.17, ["Neon"] = 19.67, ["Neon|Fly"] = 57.12, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 141.72, ["Mega"] = 140.6, ["Mega|Ride"] = 254, ["Mega|Fly|Ride"] = 311.97}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 26.17, ["Fly"] = 33.95, ["Ride"] = 32.41, ["Fly|Ride"] = 68.25, ["Neon"] = 423.01, ["Neon|Ride"] = 209.9, ["Neon|Fly|Ride"] = 212.63, ["Mega"] = 2537.96, ["Mega|Ride"] = 1120.52, ["Mega|Fly|Ride"] = 799.32}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 14.54, ["Fly"] = 90.96, ["Ride"] = 28.27, ["Fly|Ride"] = 76.15, ["Neon"] = 57.26, ["Neon|Ride"] = 98.34, ["Neon|Fly|Ride"] = 227.31, ["Mega"] = 367.4, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 429.26}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 47.92, ["Ride"] = 100.47, ["Fly|Ride"] = 412.43, ["Neon"] = 204.65, ["Neon|Ride"] = 311.97, ["Neon|Fly|Ride"] = 536.16, ["Mega"] = 846, ["Mega|Ride"] = 839.66, ["Mega|Fly|Ride"] = 815.33}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Fly|Ride"] = 282.36, ["Neon"] = 2.58, ["Neon|Fly"] = 57.12, ["Neon|Ride"] = 113.3, ["Neon|Fly|Ride"] = 105.76, ["Mega"] = 16.96, ["Mega|Fly"] = 72.14, ["Mega|Ride"] = 141.72, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 78.61, ["Fly"] = 126.92, ["Ride"] = 90.57, ["Fly|Ride"] = 181.13, ["Neon"] = 446.24, ["Neon|Fly"] = 667.29, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 498.75, ["Mega"] = 3383.93, ["Mega|Fly|Ride"] = 1666.77}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.63, ["Fly"] = 107.62, ["Ride"] = 24.94, ["Fly|Ride"] = 67.37, ["Neon"] = 198.19, ["Neon|Ride"] = 95.95, ["Neon|Fly|Ride"] = 169.21, ["Mega"] = 773.07, ["Mega|Ride"] = 432.48, ["Mega|Fly|Ride"] = 423.01}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 28.56, ["Ride"] = 17.07, ["Fly|Ride"] = 39.35, ["Neon"] = 19.59, ["Neon|Fly"] = 80.38, ["Neon|Ride"] = 70.87, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 275.07, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.1, ["Ride"] = 126, ["Neon"] = 16.03, ["Neon|Fly"] = 139.59, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 200.93, ["Mega|Fly|Ride"] = 479.9}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 54.5, ["Ride"] = 160.72, ["Fly|Ride"] = 357, ["Neon"] = 328.13, ["Neon|Ride"] = 364.64, ["Neon|Fly|Ride"] = 423.01, ["Mega"] = 2205, ["Mega|Ride"] = 1452.98, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 3.41, ["Fly|Ride"] = 423.01, ["Neon"] = 10.5, ["Neon|Ride"] = 59.07, ["Mega"] = 126.88, ["Mega|Ride"] = 211.52, ["Mega|Fly|Ride"] = 280.26}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Fly"] = 21.16, ["Ride"] = 36.66, ["Neon"] = 2.63, ["Neon|Ride"] = 117.56, ["Neon|Fly|Ride"] = 70.87, ["Mega"] = 16.75, ["Mega|Ride"] = 192.32, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.92, ["Ride"] = 35.97, ["Fly|Ride"] = 141.72, ["Neon"] = 2.1, ["Neon|Fly"] = 86.2, ["Neon|Ride"] = 23.28, ["Neon|Fly|Ride"] = 141.72, ["Mega"] = 18.38, ["Mega|Ride"] = 61.68, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 24.57, ["Ride"] = 16.04, ["Fly|Ride"] = 49.72, ["Neon"] = 5.13, ["Neon|Ride"] = 30.37, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 61.69, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 113.16, ["Neon"] = 24.35, ["Neon|Ride"] = 65.63, ["Mega"] = 118.1, ["Mega|Ride"] = 106.29, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Ride"] = 15.75, ["Fly|Ride"] = 30.19, ["Neon"] = 10.07, ["Neon|Fly"] = 212.42, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 75.64, ["Mega"] = 170.63, ["Mega|Ride"] = 121.58, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 60.47, ["Ride"] = 101.73, ["Fly|Ride"] = 278.13, ["Neon"] = 211.52, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 1057.49, ["Mega"] = 695.63, ["Mega|Ride"] = 756.97, ["Mega|Fly|Ride"] = 1128.1}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 16.68, ["Ride"] = 15.74, ["Fly|Ride"] = 42.63, ["Neon"] = 2.52, ["Neon|Fly"] = 28.6, ["Neon|Ride"] = 17.05, ["Neon|Fly|Ride"] = 42.2, ["Mega"] = 40.68, ["Mega|Ride"] = 118.28, ["Mega|Fly|Ride"] = 104.39}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 7.69, ["Fly"] = 79.33, ["Ride"] = 23.83, ["Fly|Ride"] = 71.34, ["Neon"] = 31.5, ["Neon|Fly"] = 91.76, ["Neon|Ride"] = 49.86, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 300.57, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 18.16, ["Fly"] = 52.5, ["Ride"] = 40.43, ["Fly|Ride"] = 83.55, ["Neon"] = 141.95, ["Neon|Fly"] = 141.72, ["Neon|Ride"] = 96.46, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 620.75, ["Mega|Ride"] = 670.45, ["Mega|Fly|Ride"] = 557.82}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 7.09, ["Fly"] = 196.88, ["Neon"] = 73.5, ["Neon|Ride"] = 103.69, ["Mega"] = 393.75, ["Mega|Ride"] = 448.28, ["Mega|Fly|Ride"] = 357}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.28, ["Ride"] = 15.65, ["Fly|Ride"] = 32.82, ["Neon"] = 3.94, ["Neon|Fly"] = 28.1, ["Neon|Ride"] = 15.88, ["Neon|Fly|Ride"] = 63, ["Mega"] = 35.44, ["Mega|Ride"] = 38.66, ["Mega|Fly|Ride"] = 108.06}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.94, ["Fly"] = 78.27, ["Ride"] = 37.97, ["Fly|Ride"] = 51.64, ["Neon"] = 27.5, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 113.16, ["Mega"] = 170.63, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 265.44}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 980.43, ["Fly"] = 1360, ["Ride"] = 945, ["Fly|Ride"] = 1056.57, ["Neon|Ride"] = 2744.44, ["Neon|Fly|Ride"] = 2415, ["Mega|Fly|Ride"] = 7199.06}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 128.35, ["Ride"] = 239.01, ["Fly|Ride"] = 634.5, ["Neon"] = 676.8, ["Neon|Ride"] = 776.21, ["Neon|Fly|Ride"] = 945, ["Mega|Ride"] = 3526.69, ["Mega|Fly|Ride"] = 2520}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly|Ride"] = 392.44, ["Neon"] = 3.9, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 205.16, ["Mega"] = 78.49, ["Mega|Fly|Ride"] = 1128.35}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 82.68, ["Ride"] = 164.07, ["Fly|Ride"] = 262.49, ["Neon"] = 392.44, ["Neon|Fly"] = 446.25, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 682.17, ["Mega"] = 1967.44, ["Mega|Ride"] = 1855.92, ["Mega|Fly|Ride"] = 1817.18}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 4.76, ["Ride"] = 24.94, ["Neon"] = 15.21, ["Neon|Fly"] = 56.39, ["Neon|Ride"] = 52.67, ["Neon|Fly|Ride"] = 282.36, ["Mega"] = 118.12, ["Mega|Ride"] = 353.47, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 242.62, ["Fly"] = 332.06, ["Ride"] = 248.07, ["Fly|Ride"] = 353.07, ["Neon|Ride"] = 1184.38, ["Neon|Fly|Ride"] = 1365, ["Mega|Fly|Ride"] = 4892.95}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.62, ["Fly"] = 77.18, ["Ride"] = 41.26, ["Fly|Ride"] = 213.99, ["Neon"] = 31.5, ["Neon|Fly"] = 49.72, ["Neon|Ride"] = 54.37, ["Mega"] = 241.35, ["Mega|Ride"] = 564.71}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Fly"] = 28.56, ["Ride"] = 19.05, ["Fly|Ride"] = 26.25, ["Neon"] = 43.65, ["Mega"] = 131.25, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 25.39, ["Ride"] = 61.07, ["Fly|Ride"] = 152.34, ["Neon"] = 115.4, ["Neon|Fly"] = 423.01, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 211.52, ["Mega"] = 466.36, ["Mega|Ride"] = 587.97, ["Mega|Fly|Ride"] = 896.18}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.63, ["Ride"] = 49.74, ["Neon"] = 25.39, ["Neon|Ride"] = 196.87, ["Mega|Ride"] = 253.32, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 16.15, ["Ride"] = 13.96, ["Fly|Ride"] = 28.41, ["Neon"] = 2.5, ["Neon|Fly"] = 28.56, ["Neon|Ride"] = 18, ["Neon|Fly|Ride"] = 35.12, ["Mega"] = 21.8, ["Mega|Ride"] = 35.97, ["Mega|Fly|Ride"] = 65.01}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4593.65, ["Ride"] = 5118.75, ["Fly|Ride"] = 4725, ["Neon"] = 31724.27, ["Neon|Fly|Ride"] = 19293.75, ["Mega|Fly|Ride"] = 159958.98}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 6.57, ["Fly"] = 84.62, ["Ride"] = 56.44, ["Neon"] = 53.45, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 178.5, ["Mega|Ride"] = 215.04, ["Mega|Fly|Ride"] = 423.01}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.95, ["Ride"] = 16.93, ["Fly|Ride"] = 42, ["Neon"] = 13.83, ["Neon|Fly"] = 28.56, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 100.5, ["Mega"] = 131.25, ["Mega|Ride"] = 141.72, ["Mega|Fly|Ride"] = 184.02}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 437.07, ["Fly"] = 547.77, ["Ride"] = 451.5, ["Fly|Ride"] = 531.57, ["Neon"] = 1593.63, ["Neon|Ride"] = 1292.82, ["Neon|Fly|Ride"] = 1259.3, ["Mega|Fly|Ride"] = 4873.32}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 3.08, ["Ride"] = 33.78, ["Neon"] = 11.82, ["Neon|Ride"] = 291.38, ["Mega"] = 141.74, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 6.57, ["Fly"] = 4228.86, ["Ride"] = 36.7, ["Neon"] = 21.16, ["Neon|Fly"] = 117.39, ["Neon|Ride"] = 51.59, ["Neon|Fly|Ride"] = 303.52, ["Mega"] = 421.95, ["Mega|Ride"] = 284.67, ["Mega|Fly|Ride"] = 493.85}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 50.95, ["Ride"] = 19.05, ["Fly|Ride"] = 41.99, ["Neon"] = 3.76, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 26.76, ["Neon|Fly|Ride"] = 85.25, ["Mega"] = 40.8, ["Mega|Ride"] = 67.33, ["Mega|Fly|Ride"] = 275.62}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 656.24, ["Fly"] = 748.71, ["Ride"] = 612.9, ["Fly|Ride"] = 677.25, ["Neon|Ride"] = 2126.27, ["Neon|Fly|Ride"] = 2397.31, ["Mega|Fly|Ride"] = 9165.15}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 9.19, ["Fly"] = 131.25, ["Ride"] = 65.01, ["Fly|Ride"] = 412.98, ["Neon"] = 36.66, ["Neon|Ride"] = 104.81, ["Neon|Fly|Ride"] = 143.98, ["Mega"] = 131.15, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 416.07}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 4.12, ["Fly"] = 236.15, ["Ride"] = 42.41, ["Fly|Ride"] = 76.56, ["Neon"] = 22.95, ["Neon|Ride"] = 55.14, ["Neon|Fly|Ride"] = 144.37, ["Mega"] = 173.29, ["Mega|Ride"] = 248.53, ["Mega|Fly|Ride"] = 264.97}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.51, ["Fly"] = 34.13, ["Ride"] = 15.91, ["Fly|Ride"] = 43.3, ["Neon"] = 15.43, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 32.16, ["Neon|Fly|Ride"] = 82.57, ["Mega"] = 184.02, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 232.2}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 26.25, ["Ride"] = 34.12, ["Fly|Ride"] = 55.6, ["Neon"] = 117.59, ["Mega"] = 844.93, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 545.68}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 42.87, ["Fly|Ride"] = 423.01, ["Neon"] = 4.81, ["Neon|Ride"] = 45.48, ["Neon|Fly|Ride"] = 105.76, ["Mega"] = 32.45, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 185.07}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 551.25, ["Fly"] = 628.15, ["Ride"] = 538.12, ["Fly|Ride"] = 630, ["Neon"] = 2589.57, ["Neon|Fly|Ride"] = 2367.46, ["Mega|Ride"] = 9357.56, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Fly"] = 105.76, ["Ride"] = 80.16, ["Fly|Ride"] = 338.41, ["Neon"] = 4.81, ["Neon|Ride"] = 86.42, ["Neon|Fly|Ride"] = 282.19, ["Mega"] = 84.62, ["Mega|Ride"] = 156.19, ["Mega|Fly|Ride"] = 311.97}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 33.86, ["Neon"] = 3.94, ["Neon|Fly"] = 141.72, ["Neon|Ride"] = 76.15, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 42.32, ["Mega|Fly|Ride"] = 283.49}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 49.72, ["Neon"] = 2.63, ["Neon|Ride"] = 56.12, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 46.55, ["Mega|Fly"] = 156.53, ["Mega|Ride"] = 117.41, ["Mega|Fly|Ride"] = 145.69}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 38.08, ["Neon|Ride"] = 48.18, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 27.57, ["Fly"] = 64.32, ["Ride"] = 42, ["Fly|Ride"] = 210.33, ["Neon"] = 103.69, ["Neon|Fly"] = 211.52, ["Neon|Ride"] = 99.42, ["Neon|Fly|Ride"] = 239.95, ["Mega"] = 511.88, ["Mega|Ride"] = 437.06, ["Mega|Fly|Ride"] = 547.46}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 20.1, ["Ride"] = 73.96, ["Fly|Ride"] = 105.76, ["Neon"] = 78.74, ["Neon|Ride"] = 139.59, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 382.34, ["Mega|Ride"] = 441, ["Mega|Fly|Ride"] = 560.81}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 32.7, ["Ride"] = 15.64, ["Fly|Ride"] = 32.45, ["Neon"] = 28.49, ["Neon|Fly"] = 141.72, ["Neon|Ride"] = 32.15, ["Neon|Fly|Ride"] = 87.78, ["Mega"] = 244.75, ["Mega|Ride"] = 282.36, ["Mega|Fly|Ride"] = 141.72}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 11.82, ["Ride"] = 104.31, ["Fly|Ride"] = 133.26, ["Neon"] = 38.05, ["Neon|Ride"] = 141.72, ["Mega|Ride"] = 734.96}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 26.16, ["Fly|Ride"] = 100.12, ["Neon"] = 5.92, ["Neon|Ride"] = 38.39, ["Neon|Fly|Ride"] = 113.16, ["Mega"] = 65.63, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 20.22, ["Fly"] = 112.74, ["Ride"] = 30.18, ["Fly|Ride"] = 43.19, ["Neon"] = 109.15, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 192.29, ["Mega"] = 787.5, ["Mega|Fly|Ride"] = 837.53}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 57.12, ["Fly"] = 874.13, ["Neon"] = 133.88, ["Mega"] = 328.13, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 492.85}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 48.78, ["Fly"] = 153.58, ["Ride"] = 81.9, ["Fly|Ride"] = 91.88, ["Neon"] = 324.83, ["Neon|Ride"] = 353.21, ["Neon|Fly|Ride"] = 415.79, ["Mega|Ride"] = 1696.37, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 38.75, ["Fly"] = 85.44, ["Ride"] = 76.74, ["Fly|Ride"] = 128.63, ["Neon"] = 140.44, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 199.5, ["Mega"] = 551.25, ["Mega|Ride"] = 697.94, ["Mega|Fly|Ride"] = 632}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 19.59, ["Ride"] = 57.12, ["Neon"] = 103.69, ["Neon|Ride"] = 141.72, ["Mega"] = 1050, ["Mega|Ride"] = 800.21, ["Mega|Fly|Ride"] = 807.19}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 23.55, ["Fly"] = 81.73, ["Ride"] = 69.6, ["Fly|Ride"] = 193.54, ["Neon"] = 137.82, ["Neon|Fly"] = 420, ["Neon|Ride"] = 212.14, ["Neon|Fly|Ride"] = 320.34, ["Mega"] = 498.25, ["Mega|Ride"] = 565.55, ["Mega|Fly|Ride"] = 662.75}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.95, ["Ride"] = 14.27, ["Fly|Ride"] = 26.25, ["Neon"] = 3.89, ["Neon|Fly"] = 27.07, ["Neon|Ride"] = 34.07, ["Neon|Fly|Ride"] = 53.95, ["Mega"] = 38.41, ["Mega|Ride"] = 57.7, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 866.24}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 64.3, ["Fly"] = 479.73, ["Ride"] = 91.88, ["Fly|Ride"] = 262.39, ["Neon"] = 377.9, ["Neon|Ride"] = 458.07, ["Neon|Fly|Ride"] = 556.24, ["Mega"] = 1262.64, ["Mega|Ride"] = 1499.52, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 79.75, ["Neon"] = 2.1, ["Neon|Fly"] = 99.42, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 296.12, ["Mega"] = 27.57, ["Mega|Ride"] = 80.38, ["Mega|Fly|Ride"] = 152.37}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 19.69, ["Ride"] = 113.16, ["Fly|Ride"] = 142.65, ["Neon"] = 124.69, ["Neon|Ride"] = 126.92, ["Neon|Fly|Ride"] = 347.82, ["Mega"] = 591.94, ["Mega|Ride"] = 493.5, ["Mega|Fly|Ride"] = 721.87}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 2.6, ["Neon|Fly|Ride"] = 105.76, ["Mega"] = 26.16}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.19, ["Mega"] = 21.16, ["Mega|Ride"] = 141.72, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 89.99, ["Fly"] = 223.13, ["Ride"] = 144.38, ["Fly|Ride"] = 196.88, ["Neon"] = 433.13, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 668.32, ["Mega|Ride"] = 2256.68, ["Mega|Fly|Ride"] = 2098.52}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 21.53, ["Fly|Ride"] = 95.95, ["Neon"] = 3.94, ["Neon|Fly"] = 42.32, ["Neon|Ride"] = 32.24, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 90.19, ["Mega|Ride"] = 116.81, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 53.82, ["Neon"] = 4.98, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 141.72, ["Mega"] = 31.17, ["Mega|Ride"] = 126.92, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 5.79, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 231.55, ["Mega"] = 103.69, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 480.11}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 87.94, ["Neon"] = 6.15, ["Neon|Ride"] = 156.09, ["Mega"] = 68.16, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 77.44, ["Ride"] = 129.94, ["Fly|Ride"] = 353.21, ["Neon"] = 428.35, ["Neon|Ride"] = 564.71, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2256.68, ["Mega|Ride"] = 2114.97, ["Mega|Fly|Ride"] = 1691.97}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.92, ["Ride"] = 73.7, ["Neon"] = 88.45, ["Neon|Ride"] = 77.43, ["Mega"] = 413.86, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 393.65, ["Ride"] = 417.78, ["Fly|Ride"] = 513.35, ["Neon"] = 1706.25, ["Neon|Ride"] = 705.34, ["Neon|Fly|Ride"] = 1102.5, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 95.82}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 52.49}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 15.33}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 15.74}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 141.7}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 41.99}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 18.06}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 8.48}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 157.5}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 12.5}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 32.83}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 8.85}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 3.94}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 839.99}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 5.25}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 6.57}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 4.41}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 5.25}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 14.01}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 577.5}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 574.62}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 11.69}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1299.38}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.63}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 99.41}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 9.17}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 34.04}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 15.38}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 34.13}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 45.94}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 16.95}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 12.87}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 19.38}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.64}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 13.12}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.96}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 3.93}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 20.9}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 14.13}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.12}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 4.81}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 2960.58}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 39.8}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 311.05}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 3.93}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 3.86}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 6.36}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 9.08}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 45.94}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 212.63}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 6.57}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 9.06}},
    ["rbxassetid://1265129435"] = {name = "Gold Snowboard", prices = {["default"] = 105}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 141.49}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 23.63}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 7.88}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 23.69}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 45.94}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 6.39}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 106.32}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 42.31}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 12.48}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 15.88}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.19}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 6.39}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 7.79}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 28.59}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.63}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 93.18}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 233.63}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 4.92}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 7.07}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 17.64}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.85}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 61.67}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 19.49}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.16}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22842.56}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 124.69}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 41.91}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 36.75}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 26.73}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 32.82}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 28.88}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 40.58}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 86.55}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 81.38}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 31.5}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 78.75}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 208.69}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 55.13}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 37.33}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 213.94}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 9.19}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 7.11}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 8.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 3.94}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 52.5}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 108.84}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.63}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 7.88}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 4.53}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 20.1}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 11.82}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 270.13}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 1128.23}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 7.88}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 583.86}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 14.44}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.63}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 231}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 26.15}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 91.88}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 15.94}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 27.19}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 44.5}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 13.92}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 4.25}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 8.93}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 3.83}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.57}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 4.75}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 31.5}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.94}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.1}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.5}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 15.75}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 183.75}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 51.54}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.62}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 197.74}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 11.46}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 9.19}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 7.12}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 34.39}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 7.76}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 3.94}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.63}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 9.19}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 95.95}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 6.15}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 23.39}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 16.95}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 5.53}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 2.97}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 4.01}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 5.92}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 8.13}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 2.41}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 8.48}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 3.61}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 8.48}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 4.97}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.15}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 8740.05}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 11.67}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3.63}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 8.48}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.24}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.43}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 38.38}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 11.75}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 6.25}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.88}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 5.07}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 40.69}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 6.53}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.89}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 7.32}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.93}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 6.57}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.68}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4437.08}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 8.48}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 31.4}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.63}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.61}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 45.94}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.52}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 7.87}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 98.44}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 15.75}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.8}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 3.84}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 3.72}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 7.67}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 30.19}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.93}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 5.51}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 5.25}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 3.93}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.94}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 6.24}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.15}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 28.88}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 4.41}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 10.5}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 105}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.68}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 78.58}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 6.18}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.29}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1213.54}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 55.13}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 5.25}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 26.25}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 24.86}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 15.65}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 5.25}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 13.54}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 16.37}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 14.27}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.92}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.35}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 13.12}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 4.81}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 20.89}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.94}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 6.36}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 9.19}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 60.8}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 3.92}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 16.69}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 90.57}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 8.73}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.63}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 3.94}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 27.57}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 6.49}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 199.57}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 3.94}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 5.24}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 3.71}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 75.51}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 4.8}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 157.5}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 10.16}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1151.18}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.51}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 196.88}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 13.13}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 3.94}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 57.66}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 14.34}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.59}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 106.31}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 17.07}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 17.07}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 4.25}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.84}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 8.55}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 8.48}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 61.32}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 9.09}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 62.92}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.35}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 5.25}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 11.65}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 31.5}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 137.2}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.63}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 3.52}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 81.29}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 3.29}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 8.68}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 54.6}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.15}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 66.3}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 47.46}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 161.44}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 57.11}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 5.71}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 127.32}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 3.29}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 31.47}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 57.43}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 2.5}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 61.69}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 7.24}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 9.19}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 9.19}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 12.9}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 75.25}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 35.44}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 84.96}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 27.5}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 36.75}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.61}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 5.25}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 26.93}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 10.4}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 78.73}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 42.68}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 40.69}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1994.99}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 9.4}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 6.57}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 19.66}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 351.05}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 14.99}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 7.88}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 6.36}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 7.55}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 6.57}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 301.77}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 64.22}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 47.25}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 4.25}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 55.04}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 228.38}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 73.5}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 918.75}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 155.91}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 8.48}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2362.5}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 551.23}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 3.42}},
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