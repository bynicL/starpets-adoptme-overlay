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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1210.13, ["Ride"] = 1049.99, ["Fly|Ride"] = 1420.02, ["Neon"] = 6713.18, ["Neon|Ride"] = 6825, ["Neon|Fly|Ride"] = 12603.94, ["Mega"] = 21289.64, ["Mega|Fly|Ride"] = 21289.64}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 406.88, ["Fly"] = 393.75, ["Ride"] = 500.35, ["Fly|Ride"] = 559.93, ["Neon|Fly|Ride"] = 1706.25, ["Mega"] = 10644.82, ["Mega|Fly|Ride"] = 7381.13}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 6562.5, ["Ride"] = 5250, ["Fly|Ride"] = 4462.5, ["Neon|Fly|Ride"] = 28386.53, ["Mega|Fly|Ride"] = 70965.79}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 156.19, ["Ride"] = 229.69, ["Fly|Ride"] = 309.35, ["Neon"] = 1051.72, ["Neon|Ride"] = 979.34, ["Neon|Fly|Ride"] = 982.53, ["Mega|Fly|Ride"] = 4593.75}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 624.87, ["Fly"] = 851.6, ["Ride"] = 555.19, ["Fly|Ride"] = 525, ["Neon|Fly|Ride"] = 1745.63, ["Mega|Fly|Ride"] = 6671.12}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 9.84, ["Ride"] = 57.69, ["Fly|Ride"] = 129.94, ["Neon"] = 72.19, ["Neon|Fly"] = 284.23, ["Neon|Ride"] = 62.64, ["Neon|Fly|Ride"] = 319.36, ["Mega"] = 354.38, ["Mega|Ride"] = 419.99, ["Mega|Fly|Ride"] = 425.81}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.81, ["Fly"] = 105, ["Ride"] = 26.19, ["Fly|Ride"] = 67.53, ["Neon"] = 32.82, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 56.8, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 188.99, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 100.08, ["Fly"] = 212.91, ["Ride"] = 157.5, ["Fly|Ride"] = 240.59, ["Neon"] = 544.35, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 670.64, ["Mega"] = 1586.82, ["Mega|Ride"] = 2492.44, ["Mega|Fly|Ride"] = 2818.76}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 35.78, ["Fly"] = 78.79, ["Ride"] = 37.41, ["Fly|Ride"] = 102.2, ["Neon"] = 257.62, ["Neon|Ride"] = 182.44, ["Neon|Fly|Ride"] = 255.48, ["Mega"] = 1420.02, ["Mega|Ride"] = 1169.88, ["Mega|Fly|Ride"] = 918.74}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 20.9, ["Fly"] = 37.21, ["Ride"] = 28.86, ["Fly|Ride"] = 63.89, ["Neon"] = 208.63, ["Neon|Ride"] = 136.5, ["Neon|Fly|Ride"] = 198, ["Mega|Ride"] = 568.45, ["Mega|Fly|Ride"] = 781.92}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 55.62, ["Fly"] = 106.46, ["Ride"] = 72.19, ["Fly|Ride"] = 162.75, ["Neon"] = 341.84, ["Neon|Ride"] = 321.57, ["Neon|Fly|Ride"] = 425.25, ["Mega|Fly|Ride"] = 1263.55}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 66.94}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 387.35, ["Fly"] = 399, ["Ride"] = 327.76, ["Fly|Ride"] = 400.23, ["Neon|Ride"] = 1048.69, ["Neon|Fly|Ride"] = 1181.23, ["Mega|Fly|Ride"] = 5039.27}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 84.73, ["Fly"] = 128.06, ["Ride"] = 118.13, ["Fly|Ride"] = 144.37, ["Neon|Fly"] = 623.38, ["Neon|Ride"] = 573.03, ["Neon|Fly|Ride"] = 564.38, ["Mega"] = 4312.63, ["Mega|Fly|Ride"] = 2467.5}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.38, ["Ride"] = 57.5, ["Fly|Ride"] = 131.25, ["Neon"] = 23.92, ["Neon|Ride"] = 56.35, ["Neon|Fly|Ride"] = 202.73, ["Mega"] = 156.19, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 335.82}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 196.88, ["Fly"] = 262.5, ["Ride"] = 225.74, ["Fly|Ride"] = 229.68, ["Neon|Ride"] = 958.06, ["Neon|Fly|Ride"] = 701.32, ["Mega|Fly|Ride"] = 3405.94}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.88, ["Fly"] = 26.11, ["Ride"] = 16.72, ["Fly|Ride"] = 39.38, ["Neon"] = 28.85, ["Neon|Fly"] = 80.33, ["Neon|Ride"] = 57.7, ["Neon|Fly|Ride"] = 110.73, ["Mega"] = 270.39, ["Mega|Ride"] = 320.22, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 90.44, ["Fly"] = 160.68, ["Ride"] = 127.18, ["Fly|Ride"] = 265.13, ["Neon"] = 307.44, ["Neon|Ride"] = 284.23, ["Neon|Fly|Ride"] = 486.94, ["Mega"] = 1703.19, ["Mega|Ride"] = 1420.02, ["Mega|Fly|Ride"] = 1443.75}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 40.06}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 68.25, ["Ride"] = 232.32, ["Fly|Ride"] = 243.95, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 2128.97, ["Mega|Fly|Ride"] = 1916.09}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 18.38, ["Fly"] = 55.37, ["Ride"] = 40.65, ["Fly|Ride"] = 355.56, ["Neon"] = 212.91, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 325.75, ["Mega"] = 2758.39, ["Mega|Ride"] = 956.99, ["Mega|Fly|Ride"] = 952.72}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 39.25, ["Fly"] = 64.76, ["Ride"] = 57.23, ["Fly|Ride"] = 90.02, ["Neon"] = 320.1, ["Neon|Ride"] = 220.49, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1679.03, ["Mega|Ride"] = 1021.92, ["Mega|Fly|Ride"] = 941.99}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 40.95, ["Fly"] = 262.5, ["Ride"] = 47.97, ["Fly|Ride"] = 196.88, ["Neon"] = 236.25, ["Neon|Ride"] = 384.58, ["Neon|Fly|Ride"] = 467.25, ["Mega"] = 1279.66, ["Mega|Ride"] = 1334.88, ["Mega|Fly|Ride"] = 1507.32}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 21.31, ["Ride"] = 35.18, ["Fly|Ride"] = 92.53, ["Neon"] = 142.54, ["Neon|Ride"] = 212.91, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 1207.92, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 39.38, ["Fly"] = 142.65, ["Ride"] = 62.34, ["Fly|Ride"] = 178.85, ["Neon"] = 325.5, ["Neon|Ride"] = 169.32, ["Neon|Fly|Ride"] = 262.49, ["Mega|Ride"] = 3193.46, ["Mega|Fly|Ride"] = 1018.5}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 9.19, ["Fly"] = 28.47, ["Ride"] = 19.68, ["Fly|Ride"] = 62.37, ["Neon"] = 36.21, ["Neon|Fly"] = 98.42, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 95.69, ["Mega"] = 174.57, ["Mega|Fly"] = 274.32, ["Mega|Ride"] = 182.44, ["Mega|Fly|Ride"] = 304.23}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 393.75, ["Ride"] = 498.75, ["Fly|Ride"] = 510.57, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1966.13, ["Mega"] = 10644.82, ["Mega|Fly|Ride"] = 9114.63}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 14.28, ["Ride"] = 32.82, ["Fly|Ride"] = 65.63, ["Neon"] = 219.18, ["Neon|Ride"] = 129.94, ["Mega|Ride"] = 745.16, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 9, ["Fly"] = 38.07, ["Ride"] = 20.6, ["Fly|Ride"] = 46.78, ["Neon"] = 52.5, ["Neon|Ride"] = 69.56, ["Neon|Fly|Ride"] = 128.81, ["Mega"] = 355.56, ["Mega|Ride"] = 314.03, ["Mega|Fly|Ride"] = 366.19}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 78.75, ["Fly"] = 85.17, ["Ride"] = 78.75, ["Fly|Ride"] = 95.8, ["Neon"] = 294.96, ["Neon|Ride"] = 283.5, ["Neon|Fly|Ride"] = 399, ["Mega"] = 6355.06, ["Mega|Ride"] = 2422.59, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 11.81, ["Ride"] = 34.08, ["Fly|Ride"] = 75.55, ["Neon"] = 125.85, ["Neon|Ride"] = 112.72, ["Neon|Fly|Ride"] = 170.52, ["Mega"] = 710.01, ["Mega|Ride"] = 560.09}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 197.98, ["Fly"] = 262.5, ["Ride"] = 224.44, ["Fly|Ride"] = 313.69, ["Neon"] = 633.38, ["Neon|Ride"] = 799.67, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 3405.29, ["Mega|Ride"] = 2763.52, ["Mega|Fly|Ride"] = 2874.12}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 19.69}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.78, ["Fly"] = 32.81, ["Ride"] = 27.09, ["Fly|Ride"] = 76.13, ["Neon"] = 24.93, ["Neon|Fly"] = 142.65, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 105, ["Mega"] = 174.57, ["Mega|Fly"] = 340.65, ["Mega|Ride"] = 183.58, ["Mega|Fly|Ride"] = 212.91}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 891.19, ["Fly"] = 2625, ["Ride"] = 908.25, ["Fly|Ride"] = 927.94, ["Neon"] = 4257.94, ["Neon|Ride"] = 4826.37, ["Neon|Fly|Ride"] = 4755.05, ["Mega|Ride"] = 53968.13, ["Mega|Fly|Ride"] = 17031.71}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 11.71, ["Fly"] = 44.93, ["Ride"] = 42.6, ["Fly|Ride"] = 91.59, ["Neon"] = 170.33, ["Neon|Ride"] = 149.04, ["Neon|Fly|Ride"] = 181.13, ["Mega"] = 1009.32, ["Mega|Ride"] = 1090.04, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 210, ["Fly"] = 359.7, ["Ride"] = 262.5, ["Fly|Ride"] = 367.5, ["Neon"] = 830.82, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 787.5, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 38.07}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 14.4, ["Fly"] = 127.75, ["Ride"] = 38.98, ["Fly|Ride"] = 142.65, ["Neon"] = 65.63, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 340.65, ["Mega"] = 355.56, ["Mega|Ride"] = 566.31, ["Mega|Fly|Ride"] = 593.66}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 98.44, ["Ride"] = 144.26, ["Fly|Ride"] = 271.45, ["Neon"] = 637.64, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 523.73, ["Mega"] = 2128.97, ["Mega|Fly|Ride"] = 2079.59}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 85.17, ["Fly"] = 157.49, ["Ride"] = 115.71, ["Fly|Ride"] = 217.88, ["Neon"] = 388.4, ["Neon|Fly"] = 568.45, ["Neon|Ride"] = 434.77, ["Neon|Fly|Ride"] = 496.12, ["Mega|Ride"] = 1378.13, ["Mega|Fly|Ride"] = 1382.07}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 36.21}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 45.93, ["Fly"] = 75.15, ["Ride"] = 52.38, ["Fly|Ride"] = 57.5, ["Neon|Ride"] = 367.75, ["Neon|Fly|Ride"] = 324.18, ["Mega"] = 4257.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 5.91, ["Fly"] = 98.44, ["Ride"] = 42.6, ["Fly|Ride"] = 205.04, ["Neon"] = 24.94, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 124.79, ["Neon|Fly|Ride"] = 239.53, ["Mega"] = 170.63, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 319.36, ["Mega|Fly|Ride"] = 381.94}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 577.49, ["Fly"] = 525, ["Ride"] = 420, ["Fly|Ride"] = 498.75, ["Neon|Fly"] = 3832.15, ["Neon|Ride"] = 1995, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Ride"] = 14902.76, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 99.75, ["Fly"] = 153.3, ["Ride"] = 105, ["Fly|Ride"] = 177.19, ["Neon"] = 420, ["Neon|Ride"] = 539.7, ["Neon|Fly|Ride"] = 656.25, ["Mega|Ride"] = 2554.77, ["Mega|Fly|Ride"] = 2593.1}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3975.85, ["Ride"] = 3885, ["Fly|Ride"] = 3937.5, ["Neon|Fly|Ride"] = 13483.8}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 55.13, ["Fly"] = 121.36, ["Ride"] = 52.49, ["Fly|Ride"] = 139.79, ["Neon"] = 441.77, ["Neon|Ride"] = 305.45, ["Neon|Fly|Ride"] = 292.69, ["Mega"] = 1913.96, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 73.5, ["Ride"] = 65.63, ["Fly|Ride"] = 142.43, ["Neon"] = 575.75, ["Neon|Ride"] = 427.88, ["Neon|Fly|Ride"] = 420.49, ["Mega"] = 6245.33, ["Mega|Ride"] = 2388.75, ["Mega|Fly|Ride"] = 2145.7}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 31.64, ["Fly"] = 47.23, ["Ride"] = 42, ["Fly|Ride"] = 91.76, ["Neon"] = 151.71, ["Neon|Fly"] = 284.23, ["Neon|Ride"] = 139.88, ["Neon|Fly|Ride"] = 210, ["Mega"] = 994.24, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 577.44}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 3.94}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 53.34, ["Fly"] = 393.75, ["Ride"] = 36.66, ["Fly|Ride"] = 95.93, ["Neon|Ride"] = 284.23, ["Neon|Fly|Ride"] = 568.45, ["Mega|Ride"] = 1279.66, ["Mega|Fly|Ride"] = 1439.17}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 32.42}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 182.96, ["Ride"] = 233.89, ["Fly|Ride"] = 282.19, ["Neon|Ride"] = 1104.94, ["Neon|Fly|Ride"] = 1132.62}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 635.23, ["Ride"] = 641.82, ["Fly|Ride"] = 715.32, ["Neon"] = 2625, ["Neon|Fly|Ride"] = 3596.72, ["Mega|Fly|Ride"] = 10219.04}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 2.5}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 26.23, ["Fly"] = 59.07, ["Ride"] = 38.07, ["Fly|Ride"] = 71.34, ["Neon"] = 227.81, ["Neon|Fly"] = 323.01, ["Neon|Ride"] = 177.84, ["Neon|Fly|Ride"] = 211.3, ["Mega"] = 2128.97, ["Mega|Ride"] = 1151.34, ["Mega|Fly|Ride"] = 761.24}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 19.66}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5250, ["Ride"] = 5650.32, ["Fly|Ride"] = 4987.5, ["Neon|Ride"] = 17585.46, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 43174.51}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 10.5, ["Fly"] = 55.12, ["Ride"] = 23.21, ["Fly|Ride"] = 56.43, ["Neon"] = 64.76, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 197.51, ["Mega"] = 459.34, ["Mega|Ride"] = 490.88, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 11.46, ["Fly"] = 139.47, ["Ride"] = 30.19, ["Neon"] = 100.08, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 105, ["Mega"] = 710.01, ["Mega|Ride"] = 842.02, ["Mega|Fly|Ride"] = 994.24}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 71.34, ["Ride"] = 58.95, ["Fly|Ride"] = 85.17, ["Neon|Ride"] = 394.93, ["Neon|Fly|Ride"] = 480.96, ["Mega"] = 4257.94, ["Mega|Fly|Ride"] = 1759.37}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 9.18, ["Fly"] = 71.34, ["Ride"] = 26.17, ["Fly|Ride"] = 65.63, ["Neon"] = 73.33, ["Neon|Ride"] = 148.32, ["Neon|Fly|Ride"] = 105, ["Mega"] = 1420.02, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1680, ["Fly"] = 1640.63, ["Ride"] = 1640.62, ["Fly|Ride"] = 1662.94, ["Neon|Fly|Ride"] = 3412.49, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 27300, ["Fly"] = 34063.41, ["Ride"] = 35437.5, ["Fly|Ride"] = 25434.94, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 63000, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 19.19, ["Fly"] = 393.75, ["Ride"] = 79.85, ["Fly|Ride"] = 127.75, ["Neon"] = 284.23, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 568.45, ["Mega"] = 721.88, ["Mega|Ride"] = 1148.44, ["Mega|Fly|Ride"] = 1357.61}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.62, ["Fly"] = 63, ["Ride"] = 35.43, ["Fly|Ride"] = 113.3, ["Neon"] = 22.31, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 58.7, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 128.35, ["Mega|Fly"] = 298.07, ["Mega|Ride"] = 160.13, ["Mega|Fly|Ride"] = 324.19}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 19.2}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.76, ["Ride"] = 40.47, ["Fly|Ride"] = 131.25, ["Neon"] = 56.6, ["Neon|Ride"] = 116.81, ["Neon|Fly|Ride"] = 212.91, ["Mega"] = 310.3, ["Mega|Ride"] = 425.81, ["Mega|Fly|Ride"] = 719.59}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 656.25, ["Fly"] = 895.63, ["Ride"] = 689.07, ["Fly|Ride"] = 773.07, ["Neon"] = 2767.67, ["Neon|Ride"] = 2753.83, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 10076.39}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 839.9, ["Fly"] = 853.13, ["Ride"] = 957.53, ["Fly|Ride"] = 1010.18, ["Neon"] = 4116.36, ["Neon|Ride"] = 3270.99, ["Neon|Fly|Ride"] = 3018.75, ["Mega|Fly|Ride"] = 11780.64}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 11.9, ["Fly"] = 119.91, ["Ride"] = 30.01, ["Fly|Ride"] = 87.92, ["Neon"] = 85.3, ["Neon|Ride"] = 100.92, ["Neon|Fly|Ride"] = 161.44, ["Mega"] = 1210.11, ["Mega|Ride"] = 481.69, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 24.93}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 66.85, ["Fly"] = 89.25, ["Ride"] = 65.05, ["Fly|Ride"] = 105, ["Neon"] = 568.45, ["Neon|Ride"] = 489.67, ["Neon|Fly|Ride"] = 420, ["Mega"] = 19687.5, ["Mega|Fly|Ride"] = 2111.95}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 76.77, ["Ride"] = 89.13, ["Fly|Ride"] = 212.91, ["Neon"] = 320.14, ["Neon|Ride"] = 386.78, ["Neon|Fly|Ride"] = 505.84, ["Mega"] = 1412, ["Mega|Ride"] = 1703.19, ["Mega|Fly|Ride"] = 1846.93}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 4.85, ["Fly"] = 28.38, ["Ride"] = 19.69, ["Fly|Ride"] = 45.94, ["Neon"] = 31.95, ["Neon|Fly"] = 524.98, ["Neon|Ride"] = 68.14, ["Neon|Fly|Ride"] = 110.92, ["Mega"] = 281.05, ["Mega|Ride"] = 289.55, ["Mega|Fly|Ride"] = 553.55}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 137.71, ["Fly"] = 162.07, ["Ride"] = 131.24, ["Fly|Ride"] = 210, ["Neon"] = 955.91, ["Neon|Ride"] = 539.49, ["Neon|Fly|Ride"] = 590.63, ["Mega"] = 5109.53, ["Mega|Fly|Ride"] = 2559.37}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 4.27, ["Ride"] = 48.14, ["Fly|Ride"] = 142.65, ["Neon"] = 34.08, ["Neon|Fly"] = 170.33, ["Neon|Ride"] = 173.53, ["Neon|Fly|Ride"] = 424.69, ["Mega"] = 198, ["Mega|Fly"] = 338.52, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 15.99, ["Fly"] = 41.53, ["Ride"] = 26.25, ["Fly|Ride"] = 80.34, ["Neon"] = 131.24, ["Neon|Fly"] = 160.65, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 667.45, ["Mega|Ride"] = 823.92, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 26.17, ["Ride"] = 68.22, ["Fly|Ride"] = 156.19, ["Neon"] = 160.68, ["Neon|Ride"] = 223.13, ["Mega"] = 918.75, ["Mega|Ride"] = 1161.57, ["Mega|Fly|Ride"] = 922.92}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 14.75, ["Fly"] = 212.91, ["Ride"] = 25.47, ["Fly|Ride"] = 63.89, ["Neon"] = 103.69, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 319.36, ["Mega|Fly|Ride"] = 1388.1}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 5094.07, ["Ride"] = 5248.69, ["Fly|Ride"] = 5643.75, ["Neon"] = 35483.43, ["Neon|Ride"] = 28386.53, ["Neon|Fly|Ride"] = 25971.23}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 211.87, ["Fly"] = 234.94, ["Ride"] = 223.12, ["Fly|Ride"] = 295.96, ["Neon"] = 745.16, ["Neon|Fly|Ride"] = 564.37, ["Mega|Fly|Ride"] = 1968.74}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 39.9, ["Fly"] = 139.47, ["Ride"] = 98.44, ["Fly|Ride"] = 214.66, ["Neon"] = 143.39, ["Neon|Fly"] = 320.1, ["Neon|Ride"] = 191.7, ["Neon|Fly|Ride"] = 315, ["Mega"] = 471.19, ["Mega|Fly"] = 511.88, ["Mega|Ride"] = 506.76, ["Mega|Fly|Ride"] = 601.13}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.84, ["Fly"] = 88.74, ["Ride"] = 27.69, ["Fly|Ride"] = 52.49, ["Neon"] = 23.99, ["Neon|Fly"] = 85.17, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 499.8, ["Mega|Fly|Ride"] = 358.6}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 58.42, ["Fly"] = 191.28, ["Ride"] = 121.36, ["Fly|Ride"] = 231, ["Neon"] = 209.9, ["Neon|Ride"] = 262.49, ["Neon|Fly|Ride"] = 391.12, ["Mega"] = 563.07, ["Mega|Ride"] = 563.07, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 13965, ["Ride"] = 13415.07, ["Fly|Ride"] = 11808.57, ["Neon|Fly|Ride"] = 27562.5, ["Mega|Fly|Ride"] = 113545.04}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 236.25, ["Ride"] = 315, ["Fly|Ride"] = 459.38, ["Neon|Ride"] = 1420.02, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 7195.77}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 53.24, ["Fly"] = 80.59, ["Ride"] = 70.88, ["Fly|Ride"] = 93.19, ["Neon"] = 404.52, ["Neon|Ride"] = 328.11, ["Neon|Fly|Ride"] = 293.6, ["Mega|Fly|Ride"] = 3087}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 7.87, ["Fly"] = 43.32, ["Ride"] = 25.75, ["Fly|Ride"] = 53.27, ["Neon"] = 64.79, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 393.75, ["Mega|Ride"] = 425.81, ["Mega|Fly|Ride"] = 1064.49}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 328.13, ["Fly"] = 851.6, ["Ride"] = 433.06, ["Fly|Ride"] = 531.57, ["Neon"] = 1690.41, ["Neon|Ride"] = 1376.76, ["Neon|Fly|Ride"] = 1644.26, ["Mega|Fly|Ride"] = 5232.94}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 9.59, ["Ride"] = 32.82, ["Fly|Ride"] = 194.66, ["Neon"] = 51.19, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 144.37, ["Mega|Fly"] = 263.92, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 347.03}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 104.45, ["Fly"] = 164.07, ["Ride"] = 137.71, ["Fly|Ride"] = 189, ["Neon"] = 406.88, ["Neon|Fly"] = 525, ["Neon|Ride"] = 488.25, ["Neon|Fly|Ride"] = 465.94, ["Mega|Fly|Ride"] = 2419.98}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.82, ["Fly"] = 18.38, ["Ride"] = 16.79, ["Fly|Ride"] = 32.82, ["Neon"] = 160.65, ["Neon|Fly"] = 80.33, ["Neon|Ride"] = 196.86, ["Neon|Fly|Ride"] = 78.73, ["Mega"] = 2554.77, ["Mega|Fly|Ride"] = 423.69}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 9.16}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 65.51, ["Ride"] = 85.63, ["Fly|Ride"] = 176.72, ["Neon"] = 359.63, ["Neon|Fly"] = 424.75, ["Neon|Ride"] = 406.87, ["Neon|Fly|Ride"] = 340.65, ["Mega"] = 1551.9, ["Mega|Ride"] = 1845.83, ["Mega|Fly|Ride"] = 1561.61}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 12.47, ["Fly"] = 80.07, ["Ride"] = 24.93, ["Fly|Ride"] = 85.17, ["Neon"] = 98.44, ["Neon|Ride"] = 102.2, ["Neon|Fly|Ride"] = 196.86, ["Mega"] = 640.43, ["Mega|Ride"] = 568.45, ["Mega|Fly|Ride"] = 576.02}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 26.85}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 51.75, ["Fly"] = 142.65, ["Ride"] = 99.75, ["Fly|Ride"] = 316.32, ["Neon"] = 297.31, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 511.87, ["Mega|Fly|Ride"] = 1675.51}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.6, ["Ride"] = 29.23, ["Fly|Ride"] = 136.57, ["Neon"] = 24.35, ["Neon|Ride"] = 112.72, ["Neon|Fly|Ride"] = 255.49, ["Mega"] = 164.07, ["Mega|Ride"] = 213.42, ["Mega|Fly|Ride"] = 421.55}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 11.46, ["Fly"] = 56.44, ["Ride"] = 31.95, ["Fly|Ride"] = 99.53, ["Neon"] = 64.76, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 191.63, ["Mega|Ride"] = 638.71, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 431.82, ["Fly"] = 532.25, ["Ride"] = 393.75, ["Fly|Ride"] = 541.66, ["Neon|Fly|Ride"] = 5677.96, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 36.33, ["Fly"] = 106.46, ["Ride"] = 57.66, ["Fly|Ride"] = 97.12, ["Neon"] = 129.94, ["Neon|Ride"] = 170.33, ["Neon|Fly|Ride"] = 335.71, ["Mega"] = 776.43, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 717.84}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 42.6, ["Fly"] = 142.54, ["Ride"] = 47.97, ["Fly|Ride"] = 140.33, ["Neon"] = 102.38, ["Neon|Ride"] = 236.14, ["Neon|Fly|Ride"] = 322.88, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 17.74, ["Fly"] = 114.3, ["Ride"] = 68.24, ["Fly|Ride"] = 105, ["Neon"] = 78.75, ["Neon|Fly"] = 137.82, ["Neon|Ride"] = 143.06, ["Neon|Fly|Ride"] = 269.07, ["Mega"] = 411.97, ["Mega|Fly"] = 525, ["Mega|Ride"] = 424.75, ["Mega|Fly|Ride"] = 588.83}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 8203.13, ["Ride"] = 8862, ["Fly|Ride"] = 8347.5, ["Neon|Fly|Ride"] = 14311.5, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1378.13, ["Fly"] = 1486.83, ["Ride"] = 1286.25, ["Fly|Ride"] = 1233.75, ["Neon|Fly|Ride"] = 4875.26, ["Mega|Fly|Ride"] = 17031.71}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 640.43, ["Ride"] = 617.42, ["Fly|Ride"] = 710.01, ["Neon"] = 2253.58, ["Neon|Fly|Ride"] = 1443.75, ["Mega"] = 21289.64, ["Mega|Fly|Ride"] = 9587.8}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 11.24, ["Fly"] = 23.47, ["Ride"] = 18.38, ["Fly|Ride"] = 36.21, ["Neon"] = 71.34, ["Neon|Ride"] = 89.94, ["Neon|Fly|Ride"] = 125.63, ["Mega|Fly|Ride"] = 572.25}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 4.44, ["Fly"] = 78.74, ["Ride"] = 32.39, ["Fly|Ride"] = 182.04, ["Neon"] = 24.94, ["Neon|Ride"] = 55.44, ["Mega"] = 167.77, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 286.13}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 32.64, ["Fly"] = 39.38, ["Ride"] = 41.9, ["Fly|Ride"] = 85.17, ["Neon"] = 119.89, ["Neon|Ride"] = 150.94, ["Neon|Fly|Ride"] = 158.82, ["Mega|Fly|Ride"] = 666.75}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.29, ["Fly"] = 19.2, ["Ride"] = 16.35, ["Fly|Ride"] = 32.39, ["Neon"] = 22.32, ["Neon|Fly"] = 86.63, ["Neon|Ride"] = 44.72, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 393.75, ["Mega|Ride"] = 607.62, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 323.55, ["Fly"] = 369.5, ["Ride"] = 276.94, ["Fly|Ride"] = 369.75, ["Neon"] = 1277.39, ["Neon|Ride"] = 1332.75, ["Neon|Fly|Ride"] = 1279.69, ["Mega|Fly|Ride"] = 4436.25}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 18.26, ["Fly"] = 59.96, ["Ride"] = 36.39, ["Fly|Ride"] = 84, ["Neon"] = 126, ["Neon|Fly"] = 425.81, ["Neon|Ride"] = 141.7, ["Neon|Fly|Ride"] = 189, ["Mega"] = 851.6, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 688.41}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 6.37, ["Fly"] = 18, ["Ride"] = 19.59, ["Fly|Ride"] = 34.13, ["Neon"] = 83.05, ["Neon|Fly"] = 120.3, ["Neon|Ride"] = 76.67, ["Neon|Fly|Ride"] = 104.2, ["Mega"] = 1575, ["Mega|Ride"] = 604.46, ["Mega|Fly|Ride"] = 425.25}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 633.18, ["Fly"] = 1048.69, ["Ride"] = 590.63, ["Fly|Ride"] = 637.81, ["Neon|Fly|Ride"] = 3550.05, ["Mega|Fly|Ride"] = 9971.07}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1115.63, ["Ride"] = 1201.91, ["Fly|Ride"] = 1311.19, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 12490.65}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 127.75, ["Fly"] = 187.69, ["Ride"] = 106.46, ["Fly|Ride"] = 77.44, ["Neon"] = 497.13, ["Neon|Ride"] = 585.47, ["Neon|Fly|Ride"] = 425.81, ["Mega|Fly|Ride"] = 2697.41}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 150.94, ["Fly"] = 242.71, ["Ride"] = 201.48, ["Fly|Ride"] = 250.59, ["Neon"] = 623.51, ["Neon|Ride"] = 541.24, ["Neon|Fly|Ride"] = 716.03, ["Mega|Ride"] = 9187.5, ["Mega|Fly|Ride"] = 2937.99}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 24.01, ["Fly"] = 57.5, ["Ride"] = 34.9, ["Fly|Ride"] = 113.91, ["Neon"] = 236.24, ["Neon|Ride"] = 238.13, ["Mega|Ride"] = 1420.02, ["Mega|Fly|Ride"] = 1073.38}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 196.88, ["Ride"] = 315, ["Fly|Ride"] = 425.81, ["Neon"] = 1220.63, ["Neon|Fly"] = 959.04, ["Neon|Fly|Ride"] = 1277.39, ["Mega"] = 5677.96, ["Mega|Fly|Ride"] = 5677.96}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2398.57, ["Ride"] = 1769.15, ["Fly|Ride"] = 1837.49, ["Neon|Fly|Ride"] = 10644.82, ["Mega|Fly|Ride"] = 35181.23}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 57.59, ["Fly"] = 212.91, ["Ride"] = 51.18, ["Fly|Ride"] = 196.88, ["Neon"] = 288.75, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 268.27, ["Mega"] = 1420.02, ["Mega|Ride"] = 1135.82, ["Mega|Fly|Ride"] = 1249.49}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 570.93, ["Fly"] = 851.6, ["Ride"] = 590.63, ["Fly|Ride"] = 590.62, ["Neon|Ride"] = 1498.88, ["Neon|Fly|Ride"] = 1194.31, ["Mega|Fly|Ride"] = 3451.86}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 38.85, ["Fly"] = 52.5, ["Ride"] = 64.76, ["Fly|Ride"] = 94.31, ["Neon"] = 262.5, ["Neon|Ride"] = 235.01, ["Neon|Fly|Ride"] = 244.4, ["Mega|Fly|Ride"] = 1009.14}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.93, ["Fly"] = 36.31, ["Ride"] = 17.71, ["Fly|Ride"] = 59.77, ["Neon"] = 32.43, ["Neon|Fly"] = 72.6, ["Neon|Ride"] = 47.86, ["Neon|Fly|Ride"] = 98.43, ["Mega"] = 170.62, ["Mega|Fly"] = 249.38, ["Mega|Ride"] = 185.31, ["Mega|Fly|Ride"] = 216.46}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 57.66, ["Ride"] = 128.3, ["Fly|Ride"] = 157.5, ["Neon"] = 262.4, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 710.01, ["Mega"] = 1557.34, ["Mega|Ride"] = 1703.19}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 853.13, ["Fly"] = 1086.27, ["Ride"] = 851.82, ["Fly|Ride"] = 918.23, ["Neon|Ride"] = 3255, ["Neon|Fly|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 12618.37}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 643.13, ["Ride"] = 787.5, ["Fly|Ride"] = 830.31, ["Neon|Fly|Ride"] = 4256.88, ["Mega|Fly|Ride"] = 15469.07}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 14.28, ["Fly"] = 19.49, ["Ride"] = 22.32, ["Fly|Ride"] = 45.21, ["Neon"] = 142.65, ["Neon|Ride"] = 91.14, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 781.35, ["Mega|Ride"] = 568.45, ["Mega|Fly|Ride"] = 722.52}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 11.72, ["Ride"] = 27.57, ["Fly|Ride"] = 100.08, ["Neon"] = 98.73, ["Neon|Ride"] = 103.26, ["Neon|Fly|Ride"] = 237.57, ["Mega"] = 994.24, ["Mega|Ride"] = 821.8, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.93, ["Ride"] = 39.11, ["Fly|Ride"] = 113.7, ["Neon"] = 20.96, ["Neon|Fly"] = 320.1, ["Neon|Ride"] = 68.35, ["Neon|Fly|Ride"] = 223.55, ["Mega"] = 157.05, ["Mega|Fly"] = 268.27, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 355.6}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 38.34, ["Fly"] = 47.97, ["Ride"] = 39.15, ["Fly|Ride"] = 93.19, ["Neon"] = 305.52, ["Neon|Ride"] = 220.5, ["Neon|Fly|Ride"] = 220.87, ["Mega|Ride"] = 945.06, ["Mega|Fly|Ride"] = 1006.69}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 70.88, ["Ride"] = 160.13, ["Fly|Ride"] = 355.56, ["Neon"] = 437.07, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2413.2, ["Mega|Ride"] = 2158.74, ["Mega|Fly|Ride"] = 2171.55}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 15.73, ["Fly"] = 51.19, ["Ride"] = 35.44, ["Fly|Ride"] = 76.35, ["Neon"] = 68.96, ["Neon|Fly"] = 239.77, ["Neon|Ride"] = 98.43, ["Neon|Fly|Ride"] = 171.24, ["Mega"] = 477.96, ["Mega|Ride"] = 362.25, ["Mega|Fly|Ride"] = 488.45}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 32.21, ["Fly"] = 59.07, ["Ride"] = 39.37, ["Fly|Ride"] = 93.07, ["Neon"] = 242.82, ["Neon|Ride"] = 166.64, ["Neon|Fly|Ride"] = 210, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1241.6}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 2.52, ["Fly"] = 27.46, ["Ride"] = 17.53, ["Fly|Ride"] = 36.21, ["Neon"] = 23.63, ["Neon|Ride"] = 54.3, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 434.74, ["Mega|Ride"] = 479.74, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 6.36, ["Fly"] = 49.88, ["Ride"] = 42, ["Fly|Ride"] = 70.88, ["Neon"] = 52.38, ["Neon|Fly"] = 114.19, ["Neon|Ride"] = 84.96, ["Neon|Fly|Ride"] = 127.75, ["Mega"] = 416.06, ["Mega|Ride"] = 355.56, ["Mega|Fly|Ride"] = 469.45}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 38.58, ["Fly"] = 56.8, ["Ride"] = 48.74, ["Fly|Ride"] = 85.17, ["Neon"] = 229.69, ["Neon|Fly"] = 211.3, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 241.49, ["Mega|Fly|Ride"] = 1074.91}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1443.74, ["Fly"] = 1410.93, ["Ride"] = 1351.88, ["Fly|Ride"] = 1442.43, ["Neon|Ride"] = 4895.57, ["Neon|Fly|Ride"] = 3863.97, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 462, ["Fly"] = 524.99, ["Ride"] = 446.25, ["Fly|Ride"] = 479.07, ["Neon|Ride"] = 3051.88, ["Neon|Fly|Ride"] = 1968.75, ["Mega"] = 14902.76, ["Mega|Fly|Ride"] = 8874.77}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 263.82, ["Fly"] = 378.23, ["Ride"] = 351.75, ["Fly|Ride"] = 347.82, ["Neon"] = 1420.02, ["Neon|Ride"] = 1490.29, ["Neon|Fly|Ride"] = 1557.34}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 35.35}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 29.96, ["Ride"] = 42, ["Fly|Ride"] = 98.44, ["Neon"] = 325.5, ["Neon|Fly"] = 425.81, ["Neon|Ride"] = 207.59, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 1703.19, ["Mega|Fly|Ride"] = 1036.54}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 70875, ["Fly"] = 23418.61, ["Ride"] = 35968.93, ["Fly|Ride"] = 18045.57, ["Neon|Fly|Ride"] = 36617.44, ["Mega"] = 212896.26, ["Mega|Fly|Ride"] = 87948.86}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 223.13, ["Fly"] = 262.5, ["Ride"] = 236.24, ["Fly|Ride"] = 285.63, ["Neon"] = 721.88, ["Neon|Fly"] = 853.13, ["Neon|Ride"] = 937.82, ["Neon|Fly|Ride"] = 797.7, ["Mega"] = 3198.53, ["Mega|Fly|Ride"] = 3596.25}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 216.46, ["Fly"] = 525, ["Ride"] = 249.38, ["Fly|Ride"] = 257.27, ["Neon|Fly|Ride"] = 1758.81}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 128.16, ["Fly"] = 144.38, ["Ride"] = 131.25, ["Fly|Ride"] = 210, ["Neon"] = 517.12, ["Neon|Ride"] = 524.99, ["Neon|Fly|Ride"] = 568.45, ["Mega|Ride"] = 3550.05, ["Mega|Fly|Ride"] = 3123.21}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 11.44, ["Fly"] = 63.89, ["Ride"] = 30.19, ["Fly|Ride"] = 91.88, ["Neon"] = 85.13, ["Neon|Ride"] = 113.91, ["Neon|Fly|Ride"] = 228.59, ["Mega"] = 717.2, ["Mega|Ride"] = 710.01, ["Mega|Fly|Ride"] = 958.06}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 5085.94, ["Ride"] = 3937.5, ["Fly|Ride"] = 4042.5, ["Neon"] = 21289.64, ["Neon|Fly|Ride"] = 15750}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 27.44, ["Fly"] = 39.38, ["Ride"] = 28.87, ["Fly|Ride"] = 52.49, ["Neon"] = 131.25, ["Neon|Ride"] = 212.91, ["Neon|Fly|Ride"] = 146.9, ["Mega|Ride"] = 1420.02, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 42.78, ["Ride"] = 41.76, ["Fly|Ride"] = 100.08, ["Neon"] = 311.32, ["Neon|Fly"] = 1420.02, ["Neon|Ride"] = 202.79, ["Neon|Fly|Ride"] = 262.48, ["Mega|Fly|Ride"] = 1374.27}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 393.75, ["Fly"] = 563.07, ["Ride"] = 400.32, ["Fly|Ride"] = 564.38, ["Neon"] = 1312.5, ["Neon|Fly"] = 1561.61, ["Neon|Ride"] = 1181.13, ["Neon|Fly|Ride"] = 1233.1, ["Mega|Ride"] = 5322.41, ["Mega|Fly|Ride"] = 5276.9}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 7.87, ["Fly"] = 23.99, ["Ride"] = 23.73, ["Fly|Ride"] = 47.25, ["Neon"] = 123.38, ["Neon|Fly"] = 160.75, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 781.35, ["Mega|Fly|Ride"] = 563.06}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 9.62, ["Ride"] = 34.53, ["Fly|Ride"] = 80.16, ["Neon"] = 98.43, ["Neon|Ride"] = 82.03, ["Neon|Fly|Ride"] = 209.08, ["Mega"] = 528.91, ["Mega|Ride"] = 568.47, ["Mega|Fly|Ride"] = 526.94}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 85.17, ["Ride"] = 103.68, ["Fly|Ride"] = 233.15, ["Neon"] = 1010.63, ["Neon|Ride"] = 637.79, ["Neon|Fly|Ride"] = 688.73, ["Mega|Fly|Ride"] = 2718.8}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 15.95, ["Fly"] = 98.42, ["Ride"] = 63.04, ["Fly|Ride"] = 311.85, ["Neon"] = 50.58, ["Neon|Ride"] = 118.12, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 212.91, ["Mega|Fly"] = 423.94, ["Mega|Ride"] = 305.17, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3937.5, ["Ride"] = 4034.63, ["Fly|Ride"] = 3937.5, ["Neon"] = 19687.5, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 10171.88, ["Mega"] = 42579.26, ["Mega|Fly|Ride"] = 37945.69}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 31.95, ["Fly"] = 142.65, ["Ride"] = 64.76, ["Fly|Ride"] = 144.38, ["Neon"] = 164.07, ["Neon|Ride"] = 244.13, ["Neon|Fly|Ride"] = 395.64, ["Mega"] = 851.6, ["Mega|Ride"] = 1759.37, ["Mega|Fly|Ride"] = 782.24}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7557.84, ["Fly"] = 7557.84, ["Ride"] = 6857.82, ["Fly|Ride"] = 5904.94, ["Neon|Fly|Ride"] = 14437.5, ["Mega|Fly|Ride"] = 46921.88}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.63, ["Fly"] = 18.06, ["Ride"] = 16.31, ["Fly|Ride"] = 36.29, ["Neon"] = 24.67, ["Neon|Fly"] = 59.62, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 233.15, ["Mega|Ride"] = 190.55, ["Mega|Fly|Ride"] = 248.07}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 20.9, ["Fly"] = 26.25, ["Ride"] = 32.48, ["Fly|Ride"] = 57.5, ["Neon"] = 185.24, ["Neon|Fly"] = 235.27, ["Neon|Ride"] = 196.64, ["Neon|Fly|Ride"] = 168, ["Mega|Ride"] = 991.6, ["Mega|Fly|Ride"] = 959.45}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.94}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 10.94, ["Ride"] = 24.2, ["Fly|Ride"] = 116.03, ["Neon"] = 284.23, ["Neon|Ride"] = 107.86, ["Neon|Fly|Ride"] = 320.12, ["Mega"] = 920.91, ["Mega|Ride"] = 994.24, ["Mega|Fly|Ride"] = 787.74}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 22.31, ["Fly"] = 190.37, ["Ride"] = 47.97, ["Fly|Ride"] = 96.74, ["Neon"] = 203.44, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 945, ["Mega|Ride"] = 851.6, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 12.45, ["Fly"] = 27.36, ["Ride"] = 20.83, ["Fly|Ride"] = 31.5, ["Neon|Fly"] = 1061.3, ["Neon|Ride"] = 118.17, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 2554.77, ["Mega|Fly|Ride"] = 553.55}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8658.5}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.99}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 19.69}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 242.86, ["Ride"] = 317.23, ["Fly|Ride"] = 315, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 12.36, ["Fly"] = 142.65, ["Ride"] = 38.07, ["Fly|Ride"] = 140.53, ["Neon"] = 121.85, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 142.65, ["Mega"] = 525, ["Mega|Ride"] = 528.91, ["Mega|Fly|Ride"] = 1179.94}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 10.34}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 5.97, ["Ride"] = 25.99, ["Fly|Ride"] = 85.17, ["Neon|Ride"] = 249.38, ["Mega"] = 1561.61}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2239.13}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 124.52, ["Fly"] = 338.52, ["Ride"] = 131.25, ["Fly|Ride"] = 425.81, ["Neon"] = 965.5, ["Neon|Ride"] = 887.19, ["Neon|Fly|Ride"] = 1561.61, ["Mega|Ride"] = 4116.36, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 57.45, ["Ride"] = 93.19, ["Fly|Ride"] = 239.8, ["Neon"] = 329.44, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 532.25, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 157.46, ["Fly"] = 196.88, ["Ride"] = 157.49, ["Fly|Ride"] = 229.94, ["Neon"] = 944.98, ["Neon|Ride"] = 787.49, ["Neon|Fly|Ride"] = 840, ["Mega"] = 3946.05, ["Mega|Ride"] = 3670.22, ["Mega|Fly|Ride"] = 3084.38}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2388.75, ["Fly"] = 3264.78, ["Ride"] = 2428.13, ["Fly|Ride"] = 2585.63, ["Neon"] = 14951.72, ["Neon|Ride"] = 9591.21, ["Neon|Fly|Ride"] = 7612.5, ["Mega|Fly|Ride"] = 26967.59}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 15.74, ["Fly"] = 105.4, ["Ride"] = 37.07, ["Fly|Ride"] = 100.08, ["Neon"] = 119.89, ["Neon|Fly"] = 160.65, ["Neon|Ride"] = 153.47, ["Neon|Fly|Ride"] = 142.65, ["Mega"] = 956.99, ["Mega|Ride"] = 994.24, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 761.25, ["Fly"] = 2100, ["Ride"] = 994.24, ["Fly|Ride"] = 787.5, ["Neon|Fly|Ride"] = 4157.96}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 41.99}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 16.55, ["Ride"] = 42, ["Fly|Ride"] = 338.13, ["Neon"] = 94.5, ["Neon|Ride"] = 107.36, ["Neon|Fly|Ride"] = 255.49, ["Mega"] = 468.81, ["Mega|Fly"] = 959.45, ["Mega|Ride"] = 509.25, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 6.45, ["Fly"] = 32.39, ["Ride"] = 27.57, ["Fly|Ride"] = 63, ["Neon"] = 49.88, ["Neon|Fly"] = 315, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 178.5, ["Mega"] = 448.54, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 568.45}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 60.34}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 15.99, ["Fly"] = 106.75, ["Ride"] = 20.98, ["Fly|Ride"] = 89.43, ["Neon|Ride"] = 191.85, ["Neon|Fly|Ride"] = 254.62, ["Mega|Ride"] = 994.24, ["Mega|Fly|Ride"] = 2128.97}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 38.34, ["Fly"] = 39.38, ["Ride"] = 36.75, ["Fly|Ride"] = 52.41, ["Neon|Fly"] = 235.27, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 213.94, ["Mega"] = 1439.17, ["Mega|Ride"] = 1798.96, ["Mega|Fly|Ride"] = 989.63}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6450.77, ["Fly"] = 10237.5, ["Ride"] = 6402.48, ["Fly|Ride"] = 5118.74, ["Neon|Fly|Ride"] = 9843.75, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 7.74, ["Fly"] = 65.63, ["Ride"] = 24.94, ["Fly|Ride"] = 81.37, ["Neon"] = 55.88, ["Neon|Ride"] = 73.22, ["Neon|Fly|Ride"] = 199.07, ["Mega"] = 510.97, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 535.5}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 16.96}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 77.21, ["Fly"] = 376.85, ["Ride"] = 91.88, ["Fly|Ride"] = 183.74, ["Neon"] = 459.38, ["Neon|Ride"] = 460.22, ["Neon|Fly|Ride"] = 481.42, ["Mega"] = 2879.59, ["Mega|Ride"] = 1764.77, ["Mega|Fly|Ride"] = 2206.72}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 45.94, ["Fly"] = 142.65, ["Ride"] = 64.32, ["Fly|Ride"] = 183.1, ["Neon"] = 236.25, ["Neon|Ride"] = 275.62, ["Neon|Fly|Ride"] = 446.25, ["Mega"] = 2398.6, ["Mega|Ride"] = 2874.12, ["Mega|Fly|Ride"] = 1029}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 18.13, ["Fly"] = 71.34, ["Ride"] = 31.39, ["Fly|Ride"] = 52.5, ["Neon"] = 128.77, ["Neon|Fly"] = 229.94, ["Neon|Ride"] = 142.69, ["Neon|Fly|Ride"] = 208.68, ["Mega"] = 1016.21, ["Mega|Ride"] = 863.5, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 5.93, ["Fly"] = 69.65, ["Ride"] = 23.63, ["Fly|Ride"] = 98.12, ["Neon"] = 31.48, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 160.72, ["Mega|Fly"] = 284.23, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 312.01}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 9.76, ["Ride"] = 28.88, ["Fly|Ride"] = 98.05, ["Neon"] = 100.08, ["Neon|Ride"] = 113.91, ["Neon|Fly|Ride"] = 235.27, ["Mega|Ride"] = 483.29, ["Mega|Fly|Ride"] = 424.75}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 21, ["Fly"] = 26.25, ["Ride"] = 25.97, ["Fly|Ride"] = 45.94, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 124.68, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 189.52}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 39.37, ["Ride"] = 131.24, ["Fly|Ride"] = 213.44, ["Neon"] = 183.74, ["Neon|Ride"] = 255.49, ["Neon|Fly|Ride"] = 353.69, ["Mega"] = 738.77, ["Mega|Fly|Ride"] = 678.57}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 232.67, ["Ride"] = 266.19, ["Neon|Ride"] = 17031.71, ["Neon|Fly|Ride"] = 28386.53}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 49.88, ["Fly"] = 212.91, ["Ride"] = 87.28, ["Fly|Ride"] = 170.63, ["Neon"] = 269.07, ["Neon|Ride"] = 342.25, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 984.38, ["Mega|Ride"] = 922.92, ["Mega|Fly|Ride"] = 991.06}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 1154.97, ["Fly"] = 1010.63, ["Ride"] = 1022.42, ["Fly|Ride"] = 958.13, ["Neon|Fly"] = 4347.99, ["Neon|Ride"] = 3975.85, ["Neon|Fly|Ride"] = 3281.25, ["Mega"] = 15991.37, ["Mega|Fly|Ride"] = 12337.5}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 346.5, ["Fly"] = 640.26, ["Ride"] = 346.5, ["Fly|Ride"] = 433.02, ["Neon"] = 2362.5, ["Neon|Ride"] = 1909.69, ["Neon|Fly|Ride"] = 1994.99, ["Mega"] = 12153.63, ["Mega|Fly|Ride"] = 9186.19}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 59.07}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 3.56}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 10.18, ["Fly"] = 27.09, ["Ride"] = 19.2, ["Fly|Ride"] = 49.88, ["Neon"] = 78.75, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 56.48, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 437.26, ["Mega|Ride"] = 710.01, ["Mega|Fly|Ride"] = 551.41}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 236.77, ["Fly"] = 406.65, ["Ride"] = 279.57, ["Fly|Ride"] = 341.25, ["Neon"] = 1169.88, ["Neon|Ride"] = 932.09, ["Neon|Fly|Ride"] = 838.76, ["Mega|Fly|Ride"] = 2801.43}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 13.93}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 95.82, ["Ride"] = 142.68, ["Fly|Ride"] = 242.82, ["Neon"] = 590.63, ["Neon|Fly"] = 610.32, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 656.23, ["Mega"] = 2292.91, ["Mega|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 2090.82}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 109.87, ["Fly"] = 212.91, ["Ride"] = 131.06, ["Fly|Ride"] = 110.25, ["Neon"] = 425.81, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 851.6, ["Mega|Fly|Ride"] = 2550.52}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 4.98, ["Ride"] = 24.94, ["Fly|Ride"] = 52.5, ["Neon"] = 38.06, ["Neon|Ride"] = 79.85, ["Neon|Fly|Ride"] = 241.65, ["Mega"] = 355.56, ["Mega|Ride"] = 189.84, ["Mega|Fly|Ride"] = 326.81}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 11.72, ["Fly"] = 71.34, ["Ride"] = 27.15, ["Fly|Ride"] = 78.65, ["Neon"] = 175.88, ["Neon|Ride"] = 157.49, ["Neon|Fly|Ride"] = 320.22, ["Mega|Ride"] = 1420.02, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 10.5, ["Fly"] = 102.36, ["Ride"] = 31.47, ["Fly|Ride"] = 128.36, ["Neon"] = 95.82, ["Neon|Ride"] = 85.17, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 424.75, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 553.55}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 4.81, ["Fly"] = 98.44, ["Ride"] = 32.39, ["Fly|Ride"] = 137.71, ["Neon"] = 23.63, ["Neon|Ride"] = 65.51, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 149.63, ["Mega|Fly"] = 239.88, ["Mega|Ride"] = 175.88, ["Mega|Fly|Ride"] = 239.88}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 212.89, ["Ride"] = 290.05, ["Fly|Ride"] = 376.49, ["Neon"] = 1332.75, ["Neon|Ride"] = 1366.76, ["Neon|Fly|Ride"] = 1424.07, ["Mega|Fly|Ride"] = 5658.8}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 83.05, ["Fly"] = 160.68, ["Ride"] = 131.24, ["Fly|Ride"] = 235.85, ["Neon"] = 429.18, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 630, ["Mega"] = 1843.69, ["Mega|Ride"] = 1903.13, ["Mega|Fly|Ride"] = 1903.13}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 56.2, ["Fly"] = 75.59, ["Ride"] = 70.88, ["Fly|Ride"] = 118.13, ["Neon"] = 262.5, ["Neon|Ride"] = 299.37, ["Neon|Fly|Ride"] = 416.07, ["Mega|Ride"] = 1604.18, ["Mega|Fly|Ride"] = 1800.05}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 15.99, ["Fly"] = 126, ["Ride"] = 36.21, ["Fly|Ride"] = 284.23, ["Neon"] = 131.25, ["Neon|Ride"] = 609.06, ["Neon|Fly|Ride"] = 497.13, ["Mega"] = 656.25, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 13.96, ["Fly"] = 75.64, ["Ride"] = 27.57, ["Fly|Ride"] = 85.17, ["Neon"] = 77.44, ["Neon|Fly"] = 142.65, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 710.01, ["Mega|Fly"] = 525, ["Mega|Ride"] = 479.74, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.29, ["Fly"] = 52.5, ["Ride"] = 21, ["Fly|Ride"] = 84.11, ["Neon"] = 23.63, ["Neon|Fly"] = 68.3, ["Neon|Ride"] = 37.68, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 164.07, ["Mega|Fly"] = 212.91, ["Mega|Ride"] = 170.39, ["Mega|Fly|Ride"] = 258.79}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 829.5, ["Fly"] = 1082.73, ["Ride"] = 853.11, ["Fly|Ride"] = 916.13, ["Neon"] = 4257.94, ["Neon|Fly"] = 3254.7, ["Neon|Ride"] = 3197.49, ["Neon|Fly|Ride"] = 2624.99, ["Mega|Fly|Ride"] = 8098.23}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 318.94, ["Fly"] = 738.77, ["Ride"] = 282.19, ["Fly|Ride"] = 479.6, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1273.13, ["Mega"] = 10644.82, ["Mega|Fly|Ride"] = 4920.46}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 91.86, ["Fly"] = 134.14, ["Ride"] = 113.93, ["Fly|Ride"] = 175.03, ["Neon"] = 406.88, ["Neon|Fly"] = 479.53, ["Neon|Ride"] = 335.71, ["Neon|Fly|Ride"] = 424.75, ["Mega"] = 1312.5, ["Mega|Ride"] = 1632.92, ["Mega|Fly|Ride"] = 1673.38}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 183.65, ["Fly"] = 283.5, ["Ride"] = 184.69, ["Fly|Ride"] = 246.75, ["Neon|Ride"] = 1279.23, ["Neon|Fly|Ride"] = 917.44, ["Mega"] = 10644.82, ["Mega|Fly|Ride"] = 3975.85}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 23.13, ["Fly"] = 42.6, ["Ride"] = 23.49, ["Fly|Ride"] = 76.13, ["Neon"] = 169.31, ["Neon|Ride"] = 147.48, ["Neon|Fly|Ride"] = 204.75, ["Mega|Ride"] = 638.71, ["Mega|Fly|Ride"] = 904.82}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 190.29, ["Ride"] = 228.87, ["Fly|Ride"] = 358.32, ["Neon"] = 853.64, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 971.25, ["Mega"] = 4236.94, ["Mega|Fly|Ride"] = 3818.31}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 77.42, ["Fly"] = 125.98, ["Ride"] = 80.05, ["Fly|Ride"] = 106.46, ["Neon|Ride"] = 568.45, ["Neon|Fly|Ride"] = 497.13, ["Mega|Fly|Ride"] = 1417.5}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 2310, ["Ride"] = 2362.5, ["Fly|Ride"] = 2100, ["Neon|Ride"] = 8515.87, ["Neon|Fly|Ride"] = 6314.62, ["Mega"] = 51095.12, ["Mega|Fly|Ride"] = 25562.48}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 11.68, ["Fly"] = 78.04, ["Ride"] = 32.82, ["Fly|Ride"] = 104.32, ["Neon"] = 63, ["Neon|Fly"] = 235.27, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 244.84, ["Mega"] = 288.74, ["Mega|Fly"] = 568.45, ["Mega|Ride"] = 315.49, ["Mega|Fly|Ride"] = 385.88}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 51.56, ["Fly"] = 93.69, ["Ride"] = 36.75, ["Fly|Ride"] = 113.91, ["Neon"] = 221.43, ["Neon|Ride"] = 425.81, ["Neon|Fly|Ride"] = 479.04, ["Mega|Ride"] = 931.88, ["Mega|Fly|Ride"] = 1064.49}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 79.68, ["Fly"] = 91.87, ["Ride"] = 81.38, ["Fly|Ride"] = 97.12, ["Neon"] = 525, ["Neon|Ride"] = 455.61, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1879.83}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2203.69, ["Fly"] = 1599.43, ["Ride"] = 1069.69, ["Fly|Ride"] = 1113.81, ["Neon|Ride"] = 5115.72, ["Neon|Fly|Ride"] = 4725, ["Mega"] = 34773.42, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 525, ["Fly"] = 563.53, ["Ride"] = 563.53, ["Fly|Ride"] = 534.19, ["Mega|Fly|Ride"] = 11354.83}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 64.3, ["Fly"] = 320.14, ["Ride"] = 107.23, ["Fly|Ride"] = 208.69, ["Neon"] = 444.29, ["Neon|Ride"] = 342.54, ["Neon|Fly|Ride"] = 555.19, ["Mega"] = 1988.47, ["Mega|Ride"] = 2559.31, ["Mega|Fly|Ride"] = 1561}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 5.53, ["Fly"] = 32.82, ["Ride"] = 19.68, ["Fly|Ride"] = 65.63, ["Neon"] = 45.53, ["Neon|Ride"] = 73.56, ["Neon|Fly|Ride"] = 130.58, ["Mega"] = 553.88, ["Mega|Ride"] = 773.9}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 32.81, ["Fly"] = 68.25, ["Ride"] = 36.21, ["Fly|Ride"] = 123.51, ["Neon"] = 284.82, ["Neon|Fly"] = 355.56, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 334.69, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 959.45}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 708.63, ["Fly"] = 1103.06, ["Ride"] = 786.18, ["Fly|Ride"] = 853.13, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 1837.5, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 591.41}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 6493.35, ["Ride"] = 5447.73, ["Fly|Ride"] = 5512.5, ["Neon"] = 42000, ["Neon|Ride"] = 30509.12, ["Neon|Fly|Ride"] = 18375, ["Mega|Fly|Ride"] = 106306.57}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 262.48, ["Fly"] = 399.19, ["Ride"] = 284.23, ["Fly|Ride"] = 417.25, ["Neon"] = 1312.5, ["Neon|Ride"] = 1845.83, ["Neon|Fly|Ride"] = 1706.25, ["Mega"] = 6385.84, ["Mega|Ride"] = 6101.63, ["Mega|Fly|Ride"] = 6103.75}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 65.62, ["Fly"] = 284.23, ["Ride"] = 131.15, ["Fly|Ride"] = 336, ["Neon"] = 424.75, ["Neon|Ride"] = 851.6, ["Neon|Fly|Ride"] = 634.45, ["Mega|Fly|Ride"] = 2128.97}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 14.78, ["Fly"] = 96.89, ["Ride"] = 28.85, ["Fly|Ride"] = 85.22, ["Neon"] = 156.92, ["Neon|Fly"] = 1279.11, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 214.68, ["Mega|Ride"] = 620.61, ["Mega|Fly|Ride"] = 836.7}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 10.66, ["Fly"] = 26.24, ["Ride"] = 22.86, ["Fly|Ride"] = 54.3, ["Neon"] = 142.65, ["Neon|Ride"] = 85.17, ["Neon|Fly|Ride"] = 123.08, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2128.97}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 15, ["Fly"] = 284.23, ["Ride"] = 26.25, ["Fly|Ride"] = 89.92, ["Neon"] = 124.67, ["Neon|Ride"] = 107.51, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 645.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 595.06}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.66, ["Fly"] = 62.83, ["Ride"] = 19.18, ["Fly|Ride"] = 48.55, ["Neon"] = 31.38, ["Neon|Ride"] = 56.37, ["Neon|Fly|Ride"] = 125.63, ["Mega"] = 695.67, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 320.22}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 28.62, ["Fly"] = 90.57, ["Ride"] = 45.92, ["Fly|Ride"] = 139.13, ["Neon"] = 156.58, ["Neon|Fly"] = 851.6, ["Neon|Ride"] = 229.94, ["Neon|Fly|Ride"] = 451.5, ["Mega"] = 630, ["Mega|Ride"] = 1260}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 425.81, ["Fly"] = 538.13, ["Ride"] = 485.63, ["Fly|Ride"] = 498.75, ["Neon"] = 1916.09, ["Neon|Ride"] = 1874.57, ["Neon|Fly|Ride"] = 1462.62, ["Mega"] = 7875, ["Mega|Fly|Ride"] = 5811.02}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.4, ["Fly"] = 26.25, ["Ride"] = 14.44, ["Fly|Ride"] = 28.76, ["Neon"] = 24.5, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 63.89, ["Mega"] = 170.63, ["Mega|Ride"] = 225.69, ["Mega|Fly|Ride"] = 213.94}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 48.43, ["Fly"] = 110.24, ["Ride"] = 72.09, ["Fly|Ride"] = 131.23, ["Neon"] = 212.91, ["Neon|Fly"] = 479.53, ["Neon|Ride"] = 207.38, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 524.99, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 610.3}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 809.75, ["Ride"] = 748.13, ["Fly|Ride"] = 735, ["Neon|Ride"] = 1988.47, ["Neon|Fly|Ride"] = 1640.62, ["Mega|Fly|Ride"] = 4199.99}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 30.19, ["Fly"] = 71.34, ["Ride"] = 44.51, ["Fly|Ride"] = 71.34, ["Neon"] = 262.49, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 163.95, ["Neon|Fly|Ride"] = 249.35, ["Mega"] = 1199.31, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 424.75, ["Fly"] = 288.75, ["Ride"] = 254.63, ["Fly|Ride"] = 337.32, ["Neon|Ride"] = 1561.61, ["Neon|Fly|Ride"] = 948.34}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 196.88, ["Fly"] = 278.91, ["Ride"] = 187.03, ["Fly|Ride"] = 199.5, ["Neon"] = 994.24, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 4326, ["Mega|Fly|Ride"] = 3762.95}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 903.62, ["Ride"] = 770.44, ["Fly|Ride"] = 948.47, ["Neon|Ride"] = 3771.75, ["Neon|Fly|Ride"] = 3120.01, ["Mega|Fly|Ride"] = 9711.19}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 15.75, ["Fly"] = 61.77, ["Ride"] = 45.87, ["Fly|Ride"] = 111.57, ["Neon"] = 78.75, ["Neon|Fly"] = 287.73, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 142.65, ["Mega"] = 354.38, ["Mega|Ride"] = 327.78, ["Mega|Fly|Ride"] = 624.87}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4084.49, ["Fly"] = 3438.49, ["Ride"] = 3936.19, ["Fly|Ride"] = 3346.88, ["Neon|Fly|Ride"] = 7218.75, ["Mega|Fly|Ride"] = 25759.4}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 110.25, ["Fly"] = 170.33, ["Ride"] = 131.25, ["Fly|Ride"] = 190.7, ["Neon"] = 498.75, ["Neon|Fly"] = 712.69, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 577.5, ["Mega|Ride"] = 2697.41, ["Mega|Fly|Ride"] = 2980.57}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 3.13, ["Fly"] = 19.59, ["Ride"] = 15.54, ["Fly|Ride"] = 39.38, ["Neon"] = 23.1, ["Neon|Fly"] = 65.61, ["Neon|Ride"] = 37.41, ["Neon|Fly|Ride"] = 101.88, ["Mega"] = 160.1, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 369.39, ["Mega|Fly|Ride"] = 233.15}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.93, ["Ride"] = 24.5, ["Fly|Ride"] = 57.71, ["Neon"] = 24.94, ["Neon|Fly"] = 117.51, ["Neon|Ride"] = 64.28, ["Neon|Fly|Ride"] = 284.23, ["Mega"] = 163.45, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 32.74, ["Fly"] = 42.63, ["Ride"] = 39.38, ["Fly|Ride"] = 56.35, ["Neon"] = 287.77, ["Neon|Ride"] = 311.73, ["Neon|Fly|Ride"] = 272.16, ["Mega|Fly|Ride"] = 1097.5}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 794.12, ["Fly"] = 1246.93, ["Ride"] = 1025.2, ["Fly|Ride"] = 984.38, ["Neon"] = 4542.16, ["Neon|Fly|Ride"] = 4826.37}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 8098.13, ["Ride"] = 8019.81, ["Fly|Ride"] = 6431.25}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 18.05, ["Fly"] = 29.61, ["Ride"] = 21, ["Fly|Ride"] = 42, ["Neon"] = 452.13, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 141.29, ["Mega"] = 2520, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 14.44, ["Fly"] = 57.65, ["Ride"] = 28.76, ["Fly|Ride"] = 78.75, ["Neon"] = 85.13, ["Neon|Ride"] = 78.15, ["Neon|Fly|Ride"] = 142.65, ["Mega"] = 662.17, ["Mega|Ride"] = 479.07, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 87.88, ["Fly"] = 157.5, ["Ride"] = 87.9, ["Fly|Ride"] = 144.38, ["Neon|Ride"] = 446.25, ["Neon|Fly|Ride"] = 496.02, ["Mega|Fly|Ride"] = 1685.63}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 256.24, ["Fly"] = 241.5, ["Ride"] = 221.8, ["Fly|Ride"] = 301.88, ["Neon"] = 959.04, ["Neon|Ride"] = 1182.93, ["Neon|Fly|Ride"] = 997.5, ["Mega"] = 8515.87, ["Mega|Fly"] = 3999.64, ["Mega|Fly|Ride"] = 4479.37}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 5.12, ["Ride"] = 32.71, ["Fly|Ride"] = 93.19, ["Neon"] = 23.16, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 51.11, ["Mega"] = 160.12, ["Mega|Fly"] = 237.39, ["Mega|Ride"] = 191.52, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 181.13, ["Fly"] = 231.71, ["Ride"] = 203.44, ["Fly|Ride"] = 262.49, ["Neon"] = 656.25, ["Neon|Ride"] = 688.67, ["Neon|Fly|Ride"] = 781.44, ["Mega|Fly|Ride"] = 2576.44}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.94, ["Fly"] = 25.77, ["Ride"] = 17.07, ["Fly|Ride"] = 50.05, ["Neon"] = 31.5, ["Neon|Fly"] = 71.34, ["Neon|Ride"] = 36.21, ["Neon|Fly|Ride"] = 108.94, ["Mega"] = 225.75, ["Mega|Ride"] = 219.31, ["Mega|Fly|Ride"] = 284.23}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 190.32, ["Fly"] = 344.91, ["Ride"] = 207.9, ["Fly|Ride"] = 249.59, ["Neon"] = 1277.39, ["Neon|Ride"] = 1198.92, ["Neon|Fly|Ride"] = 1003.12, ["Mega"] = 10644.82, ["Mega|Fly|Ride"] = 4797.18}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 8.59, ["Fly"] = 77.44, ["Ride"] = 24.5, ["Fly|Ride"] = 68.25, ["Neon"] = 73.5, ["Neon|Fly"] = 304.5, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 568.45, ["Mega|Ride"] = 526.94, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Ride"] = 20.85, ["Fly|Ride"] = 92.63, ["Neon"] = 8.09, ["Neon|Fly"] = 170.46, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 195.56, ["Mega"] = 84.67, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 170.61}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.88, ["Mega"] = 19.68, ["Mega|Ride"] = 142.65, ["Mega|Fly|Ride"] = 160.72}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Ride"] = 31.95, ["Fly|Ride"] = 85.53, ["Neon"] = 5.04, ["Neon|Ride"] = 27.91, ["Neon|Fly|Ride"] = 63, ["Mega"] = 69.24, ["Mega|Fly"] = 159906.33, ["Mega|Ride"] = 76.02, ["Mega|Fly|Ride"] = 211.3}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 59, ["Fly"] = 124.69, ["Ride"] = 93.19, ["Fly|Ride"] = 201.45, ["Neon"] = 339.93, ["Neon|Fly"] = 327.97, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 389.82, ["Mega|Fly|Ride"] = 1416.84}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 34.78, ["Ride"] = 16.96, ["Fly|Ride"] = 83.05, ["Neon"] = 7.5, ["Neon|Fly"] = 63.89, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 85.16, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 262.47}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 9.72, ["Ride"] = 57.5, ["Neon"] = 82.26, ["Neon|Fly"] = 287.73, ["Neon|Ride"] = 270.39, ["Neon|Fly|Ride"] = 223.12, ["Mega"] = 261.18, ["Mega|Ride"] = 539.7}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.19, ["Neon|Ride"] = 55.25, ["Mega"] = 14.43, ["Mega|Fly"] = 73.5, ["Mega|Ride"] = 47.24, ["Mega|Fly|Ride"] = 160.55}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 71.28, ["Ride"] = 15.65, ["Fly|Ride"] = 24.93, ["Neon"] = 2.1, ["Neon|Fly"] = 37.08, ["Neon|Ride"] = 14.23, ["Neon|Fly|Ride"] = 32.8, ["Mega"] = 11.53, ["Mega|Fly"] = 31.34, ["Mega|Ride"] = 19.69, ["Mega|Fly|Ride"] = 61.21}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 15.73, ["Fly|Ride"] = 52.5, ["Neon"] = 2.1, ["Neon|Fly"] = 20.99, ["Neon|Ride"] = 15.43, ["Neon|Fly|Ride"] = 42.84, ["Mega"] = 18.19, ["Mega|Fly"] = 160.72, ["Mega|Ride"] = 34.08, ["Mega|Fly|Ride"] = 64.08}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.51, ["Neon|Ride"] = 65.62, ["Mega"] = 19.69, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 91.86, ["Ride"] = 21, ["Fly|Ride"] = 107.62, ["Neon"] = 5.6, ["Neon|Fly"] = 121.36, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 83.22, ["Mega"] = 33.47, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 38.07, ["Mega|Fly|Ride"] = 101.07}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.52, ["Neon|Ride"] = 82.09, ["Neon|Fly|Ride"] = 425.81, ["Mega"] = 20.97, ["Mega|Fly"] = 129.54, ["Mega|Ride"] = 69.57, ["Mega|Fly|Ride"] = 212.9}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 3.66, ["Fly"] = 77.43, ["Ride"] = 36.36, ["Fly|Ride"] = 156.47, ["Neon"] = 22.31, ["Neon|Fly"] = 95.92, ["Neon|Ride"] = 47.24, ["Neon|Fly|Ride"] = 104.99, ["Mega"] = 116.82, ["Mega|Fly"] = 281.86, ["Mega|Ride"] = 153.48, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 51.98, ["Neon"] = 2.1, ["Neon|Ride"] = 42.6, ["Neon|Fly|Ride"] = 320.12, ["Mega"] = 14.43, ["Mega|Fly"] = 144.27, ["Mega|Ride"] = 71.63, ["Mega|Fly|Ride"] = 196.77}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Ride"] = 21.31, ["Fly|Ride"] = 142.65, ["Neon"] = 18.15, ["Mega"] = 135.19, ["Mega|Fly"] = 315, ["Mega|Ride"] = 274.31, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 26.24, ["Neon"] = 17.06, ["Mega"] = 131.25, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 568.45}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 3.83, ["Neon|Ride"] = 27.68, ["Neon|Fly|Ride"] = 142.65, ["Mega"] = 20.81, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 98.01}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.2, ["Ride"] = 14.32, ["Fly|Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 15.99, ["Neon|Ride"] = 14.17, ["Neon|Fly|Ride"] = 37.8, ["Mega"] = 11.43, ["Mega|Fly"] = 32.79, ["Mega|Ride"] = 19.69, ["Mega|Fly|Ride"] = 49.88}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 229.68, ["Fly|Ride"] = 118.1, ["Neon"] = 33.16, ["Neon|Ride"] = 140.95, ["Mega"] = 212.91, ["Mega|Ride"] = 191.63}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 31.52, ["Neon"] = 3.81, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 31.18, ["Neon|Fly|Ride"] = 105, ["Mega"] = 23.63, ["Mega|Ride"] = 48.11, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.1, ["Neon"] = 18.13, ["Mega"] = 84, ["Mega|Ride"] = 161.81, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 78.92, ["Ride"] = 19.69, ["Neon"] = 11.54, ["Neon|Ride"] = 42.6, ["Neon|Fly|Ride"] = 142.65, ["Mega"] = 124.69, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 191.9}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 14.23, ["Ride"] = 14.89, ["Fly|Ride"] = 31.47, ["Neon"] = 2.1, ["Neon|Fly"] = 15.38, ["Neon|Ride"] = 12.9, ["Neon|Fly|Ride"] = 25.99, ["Mega"] = 12.74, ["Mega|Fly"] = 28.17, ["Mega|Ride"] = 22.32, ["Mega|Fly|Ride"] = 52.47}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 28.76, ["Ride"] = 27.42, ["Fly|Ride"] = 142.65, ["Neon"] = 12.83, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 196.47, ["Mega"] = 129.65, ["Mega|Ride"] = 160.72, ["Mega|Fly|Ride"] = 160.72}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 6.4, ["Fly"] = 21.31, ["Ride"] = 40.46, ["Fly|Ride"] = 59.07, ["Neon"] = 38.98, ["Neon|Ride"] = 68.86, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 230.28, ["Mega|Ride"] = 297.51, ["Mega|Fly|Ride"] = 320.22}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 32.51, ["Ride"] = 14.44, ["Fly|Ride"] = 28.76, ["Neon"] = 2.1, ["Neon|Fly"] = 17.05, ["Neon|Ride"] = 15.43, ["Neon|Fly|Ride"] = 32.19, ["Mega"] = 19.82, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 79.19}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 177.79, ["Ride"] = 31.5, ["Neon"] = 7.87, ["Neon|Ride"] = 35.85, ["Neon|Fly|Ride"] = 169.26, ["Mega"] = 57.5, ["Mega|Fly"] = 170.33, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 35.43, ["Neon"] = 3.83, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 284.23, ["Mega"] = 25.99, ["Mega|Fly"] = 142.65, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 314.03}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 32.39, ["Ride"] = 20.89, ["Neon"] = 2.1, ["Neon|Ride"] = 25.3, ["Neon|Fly|Ride"] = 284.23, ["Mega"] = 11.57, ["Mega|Fly"] = 253.82, ["Mega|Ride"] = 41.05, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 71.34, ["Ride"] = 15.28, ["Fly|Ride"] = 46.56, ["Neon"] = 7.76, ["Neon|Fly"] = 54.3, ["Neon|Ride"] = 17.18, ["Neon|Fly|Ride"] = 60.69, ["Mega"] = 71.74, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 187.37}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 23.99, ["Neon"] = 5.25, ["Neon|Ride"] = 68.25, ["Mega"] = 40.43, ["Mega|Fly"] = 320.22, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 249.37}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 19.51, ["Ride"] = 15.66, ["Fly|Ride"] = 57.5, ["Neon"] = 11.72, ["Neon|Fly"] = 31.95, ["Neon|Ride"] = 23.57, ["Neon|Fly|Ride"] = 57.5, ["Mega"] = 111.57, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 123.38}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.1, ["Ride"] = 38.57, ["Fly|Ride"] = 50.05, ["Neon"] = 31.07, ["Neon|Fly"] = 188.89, ["Neon|Ride"] = 81.37, ["Neon|Fly|Ride"] = 319.36, ["Mega"] = 102.37, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 210}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 25.77, ["Ride"] = 15.6, ["Fly|Ride"] = 32.8, ["Neon"] = 10.29, ["Neon|Fly"] = 47.97, ["Neon|Ride"] = 32.23, ["Neon|Fly|Ride"] = 85.2, ["Mega"] = 264.01, ["Mega|Fly"] = 420, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 18.19, ["Ride"] = 17.07, ["Fly|Ride"] = 73.5, ["Neon"] = 12.29, ["Neon|Fly"] = 66.29, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 85.17, ["Mega"] = 170.33, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 112.85, ["Neon"] = 7.88, ["Neon|Ride"] = 47.97, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 222.21, ["Mega|Ride"] = 308.72}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 9.19, ["Ride"] = 51.57, ["Neon"] = 202, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 794.07, ["Mega"] = 636.58, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 981.75}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 3.93, ["Ride"] = 28.76, ["Fly|Ride"] = 106.46, ["Neon"] = 44.17, ["Neon|Ride"] = 106.55, ["Mega"] = 160.72, ["Mega|Ride"] = 365.54}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 6.48, ["Ride"] = 31.95, ["Fly|Ride"] = 120.75, ["Neon"] = 47.3, ["Neon|Ride"] = 63, ["Mega"] = 355.56, ["Mega|Ride"] = 411.97, ["Mega|Fly|Ride"] = 441.76}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Ride"] = 28.76, ["Neon"] = 2.54, ["Neon|Ride"] = 65.02, ["Mega"] = 17.07, ["Mega|Fly"] = 122.42, ["Mega|Ride"] = 42.6, ["Mega|Fly|Ride"] = 232.07}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 43.32}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 6.01, ["Fly"] = 23.63, ["Ride"] = 19.37, ["Fly|Ride"] = 43.32, ["Neon"] = 44.61, ["Neon|Fly"] = 188.48, ["Neon|Ride"] = 47.58, ["Neon|Fly|Ride"] = 94.4, ["Mega"] = 271.45, ["Mega|Fly"] = 291.68, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 256.48}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.79, ["Ride"] = 16.96, ["Fly|Ride"] = 64.56, ["Neon"] = 2.1, ["Neon|Fly"] = 52.8, ["Neon|Ride"] = 21.31, ["Neon|Fly|Ride"] = 105, ["Mega"] = 18, ["Mega|Fly"] = 142.65, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 98.43}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 25.56, ["Neon"] = 6.13, ["Neon|Ride"] = 36.74, ["Neon|Fly|Ride"] = 72.18, ["Mega"] = 32.21, ["Mega|Ride"] = 55.11, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 42.6, ["Ride"] = 15.75, ["Fly|Ride"] = 32.78, ["Neon"] = 7.85, ["Neon|Ride"] = 53.23, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 142.65, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 236.33}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.92, ["Fly"] = 42.6, ["Ride"] = 31.5, ["Fly|Ride"] = 65.63, ["Neon"] = 47.5, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 160.72, ["Mega|Ride"] = 355.56, ["Mega|Fly|Ride"] = 319.36}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 34.12, ["Neon"] = 3.82, ["Mega"] = 20.83, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 52.4, ["Mega|Fly|Ride"] = 340.65}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 16.87, ["Fly|Ride"] = 34.28, ["Neon"] = 3.75, ["Neon|Fly"] = 112.7, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 95.93, ["Mega"] = 27.76, ["Mega|Fly"] = 142.65, ["Mega|Ride"] = 39.37, ["Mega|Fly|Ride"] = 112.84}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.65, ["Ride"] = 15.63, ["Fly|Ride"] = 42.6, ["Neon"] = 8.53, ["Neon|Fly"] = 53.24, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 50.11, ["Mega"] = 65.63, ["Mega|Fly"] = 142.65, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 85.44}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 37.27, ["Fly|Ride"] = 142.65, ["Neon"] = 4.6, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 105, ["Mega"] = 65.54, ["Mega|Ride"] = 85.83, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 112.72, ["Neon|Fly|Ride"] = 154467.55, ["Mega"] = 17.99, ["Mega|Fly"] = 106.46, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 136.49}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 19.66, ["Neon"] = 2.1, ["Neon|Fly"] = 27.59, ["Neon|Ride"] = 20.39, ["Neon|Fly|Ride"] = 95.83, ["Mega"] = 16.43, ["Mega|Fly"] = 63.89, ["Mega|Ride"] = 35.86, ["Mega|Fly|Ride"] = 87.84}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly|Ride"] = 113.91, ["Mega"] = 19.69, ["Mega|Ride"] = 127.32}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.63, ["Neon"] = 3.9, ["Neon|Fly|Ride"] = 420, ["Mega"] = 31.28, ["Mega|Ride"] = 191.63, ["Mega|Fly|Ride"] = 217.17}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 15.75, ["Fly|Ride"] = 52.5, ["Neon"] = 6.56, ["Neon|Fly"] = 32.81, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 42.6, ["Mega"] = 34.13, ["Mega|Fly"] = 45.78, ["Mega|Fly|Ride"] = 107.57}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 9.19, ["Ride"] = 78.74, ["Fly|Ride"] = 212.91, ["Neon"] = 66.93, ["Neon|Ride"] = 98.89, ["Mega"] = 406.88, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 710.01}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 36.21, ["Neon"] = 32.82, ["Neon|Ride"] = 157.5, ["Mega"] = 183.75, ["Mega|Fly|Ride"] = 568.45}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 3.93, ["Ride"] = 31.95, ["Fly|Ride"] = 180.98, ["Neon"] = 20.26, ["Neon|Ride"] = 79.13, ["Mega"] = 249.46, ["Mega|Fly|Ride"] = 380.52}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 15.48, ["Ride"] = 9.7, ["Fly|Ride"] = 27.69, ["Neon"] = 2.1, ["Neon|Fly"] = 18.26, ["Neon|Ride"] = 13.12, ["Neon|Fly|Ride"] = 22.32, ["Mega"] = 9.17, ["Mega|Fly"] = 19.14, ["Mega|Ride"] = 19.66, ["Mega|Fly|Ride"] = 42.61}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 3.84, ["Fly"] = 118.12, ["Ride"] = 59.62, ["Neon"] = 5.8, ["Neon|Fly"] = 67.79, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 710.01, ["Mega"] = 85.31, ["Mega|Ride"] = 85.32}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Fly"] = 71.34, ["Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 31.95, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 86.65, ["Mega"] = 12.49, ["Mega|Fly"] = 63.89, ["Mega|Fly|Ride"] = 140.53}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.68, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 127.32, ["Mega"] = 13.01, ["Mega|Fly"] = 212.91, ["Mega|Fly|Ride"] = 160.72}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 126.29, ["Ride"] = 17.05, ["Fly|Ride"] = 43.22, ["Neon"] = 10.4, ["Neon|Ride"] = 40.59, ["Neon|Fly|Ride"] = 76.12, ["Mega"] = 169.32, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 292.04}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 131.1, ["Ride"] = 224.2, ["Fly|Ride"] = 383.23, ["Neon|Fly|Ride"] = 975.08, ["Mega"] = 8515.87, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 24.5, ["Neon"] = 4.94, ["Neon|Ride"] = 64.31, ["Mega"] = 68.06, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 2.83, ["Fly"] = 103.68, ["Ride"] = 26.25, ["Fly|Ride"] = 63.03, ["Neon"] = 32.49, ["Neon|Ride"] = 170.33, ["Neon|Fly|Ride"] = 142.65, ["Mega"] = 381.89, ["Mega|Ride"] = 256.67, ["Mega|Fly|Ride"] = 640.43}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 28.76, ["Ride"] = 15.71, ["Fly|Ride"] = 32.8, ["Neon"] = 3.71, ["Neon|Fly"] = 33.01, ["Neon|Ride"] = 21.2, ["Neon|Fly|Ride"] = 31.95, ["Mega"] = 49.67, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 106.46}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 71.34, ["Ride"] = 19.19, ["Fly|Ride"] = 92.59, ["Neon"] = 8.97, ["Neon|Ride"] = 55.57, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 51.1, ["Mega|Ride"] = 191.9, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 6.18, ["Fly"] = 28.87, ["Ride"] = 15.75, ["Fly|Ride"] = 33.01, ["Neon"] = 26.82, ["Neon|Fly"] = 100.08, ["Neon|Ride"] = 36.39, ["Neon|Fly|Ride"] = 77.97, ["Mega|Ride"] = 284.23, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.61, ["Ride"] = 34.29, ["Fly|Ride"] = 47.97, ["Neon"] = 48.06, ["Neon|Ride"] = 85.17, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 216.56, ["Mega|Ride"] = 386.46, ["Mega|Fly|Ride"] = 387.18}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.62, ["Fly"] = 18.9, ["Ride"] = 14.3, ["Fly|Ride"] = 35.44, ["Neon"] = 18, ["Neon|Fly"] = 70.06, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 63.74, ["Mega"] = 360.87, ["Mega|Ride"] = 284.23, ["Mega|Fly|Ride"] = 249.27}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 44.98, ["Fly"] = 110.73, ["Ride"] = 77.44, ["Fly|Ride"] = 143.34, ["Neon"] = 341.25, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 402.84, ["Neon|Fly|Ride"] = 437.52, ["Mega|Fly|Ride"] = 1468.59}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 213.99, ["Fly"] = 425.81, ["Ride"] = 246.75, ["Fly|Ride"] = 315, ["Neon|Ride"] = 1119.79, ["Neon|Fly|Ride"] = 965.5, ["Mega"] = 10644.82, ["Mega|Fly|Ride"] = 4964.75}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 55.13, ["Fly"] = 85.2, ["Ride"] = 67.77, ["Fly|Ride"] = 85.17, ["Neon"] = 478.41, ["Neon|Ride"] = 290.07, ["Neon|Fly|Ride"] = 286.79, ["Mega|Ride"] = 1277.39, ["Mega|Fly|Ride"] = 1416.84}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 2.38, ["Fly"] = 287.99, ["Ride"] = 23.39, ["Fly|Ride"] = 65.63, ["Neon"] = 35.44, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 284.23, ["Mega"] = 191.9, ["Mega|Ride"] = 196.75, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 9.76, ["Fly"] = 71.34, ["Ride"] = 31.49, ["Fly|Ride"] = 63.57, ["Neon"] = 85.17, ["Neon|Ride"] = 64.76, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 474.77, ["Mega|Ride"] = 337.12, ["Mega|Fly|Ride"] = 407.18}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.18, ["Ride"] = 15.75, ["Fly|Ride"] = 49.88, ["Neon"] = 3.68, ["Neon|Fly"] = 24.5, ["Neon|Ride"] = 24.05, ["Neon|Fly|Ride"] = 39.13, ["Mega"] = 32.81, ["Mega|Fly"] = 146.33, ["Mega|Ride"] = 212.91, ["Mega|Fly|Ride"] = 528.91}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 5.76, ["Fly"] = 39.38, ["Ride"] = 25.56, ["Fly|Ride"] = 66.25, ["Neon"] = 100.44, ["Neon|Fly"] = 284.23, ["Neon|Ride"] = 107.63, ["Neon|Fly|Ride"] = 227.81, ["Mega"] = 398.13, ["Mega|Ride"] = 479.74, ["Mega|Fly|Ride"] = 732.38}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 19.18, ["Ride"] = 15.09, ["Fly|Ride"] = 36.21, ["Neon"] = 10.13, ["Neon|Fly"] = 80.33, ["Neon|Ride"] = 28.49, ["Neon|Fly|Ride"] = 42.6, ["Mega|Ride"] = 267.21, ["Mega|Fly|Ride"] = 232.09}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.1, ["Ride"] = 28.76, ["Fly|Ride"] = 328.13, ["Neon"] = 42.87, ["Neon|Ride"] = 36.21, ["Mega"] = 199.07, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 27.68, ["Ride"] = 19.37, ["Neon"] = 2.1, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 13.13, ["Mega|Fly"] = 30.19, ["Mega|Ride"] = 42.6, ["Mega|Fly|Ride"] = 78.74}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 18.86, ["Fly|Ride"] = 42.6, ["Neon"] = 11.86, ["Neon|Fly"] = 106.46, ["Neon|Ride"] = 35.15, ["Neon|Fly|Ride"] = 147, ["Mega"] = 72.19, ["Mega|Fly|Ride"] = 267.2}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 3.59, ["Fly"] = 26.74, ["Ride"] = 17.38, ["Fly|Ride"] = 62.83, ["Neon"] = 18.38, ["Neon|Ride"] = 47.25, ["Mega"] = 131.18, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 248.07}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 99.65, ["Fly"] = 143.07, ["Ride"] = 98.44, ["Fly|Ride"] = 141.91, ["Neon"] = 489.57, ["Neon|Fly"] = 640.17, ["Neon|Ride"] = 437.07, ["Neon|Fly|Ride"] = 530.25, ["Mega"] = 4257.94, ["Mega|Fly|Ride"] = 2256.72}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.88, ["Ride"] = 118.13, ["Fly|Ride"] = 128.3, ["Neon"] = 38.97, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 415.16, ["Mega|Ride"] = 436.55, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 42.52, ["Ride"] = 17.07, ["Fly|Ride"] = 31.5, ["Neon"] = 22.56, ["Neon|Ride"] = 32.43, ["Neon|Fly|Ride"] = 120.64, ["Mega"] = 246.75, ["Mega|Ride"] = 187.68, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 15.99, ["Ride"] = 53.13, ["Fly|Ride"] = 170.63, ["Neon"] = 137.16, ["Neon|Ride"] = 161.34, ["Neon|Fly|Ride"] = 708.95, ["Mega"] = 479.74, ["Mega|Fly"] = 851.6, ["Mega|Ride"] = 688.41, ["Mega|Fly|Ride"] = 640.43}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 2.1}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 4.81, ["Ride"] = 28.84, ["Fly|Ride"] = 126.69, ["Neon"] = 40.69, ["Neon|Fly"] = 89.25, ["Neon|Ride"] = 142.65, ["Neon|Fly|Ride"] = 326.81, ["Mega"] = 332.13, ["Mega|Ride"] = 582.29, ["Mega|Fly|Ride"] = 880.3}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 25.81, ["Fly"] = 34.07, ["Ride"] = 28.76, ["Fly|Ride"] = 42, ["Neon"] = 400.26, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 127.75, ["Neon|Fly|Ride"] = 113.91, ["Mega"] = 1374.27, ["Mega|Fly|Ride"] = 526.83}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 20.99, ["Fly|Ride"] = 52.49, ["Neon"] = 3.9, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 27.44, ["Neon|Fly|Ride"] = 107.62, ["Mega"] = 27.18, ["Mega|Fly"] = 188.99, ["Mega|Ride"] = 71.9, ["Mega|Fly|Ride"] = 229.98}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 3.77, ["Fly"] = 32.53, ["Ride"] = 19.81, ["Fly|Ride"] = 65.54, ["Neon"] = 57.5, ["Neon|Ride"] = 63.89, ["Mega"] = 270.39, ["Mega|Fly"] = 400.57, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 539.7}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 21.38, ["Ride"] = 15.15, ["Fly|Ride"] = 28.76, ["Neon"] = 17.07, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 31.02, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 182.04, ["Mega|Ride"] = 202.13, ["Mega|Fly|Ride"] = 275.73}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 28.87, ["Neon"] = 3.75, ["Neon|Fly"] = 270.39, ["Neon|Ride"] = 32.71, ["Mega"] = 22.32, ["Mega|Ride"] = 53.24, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 19.69, ["Fly"] = 138.91, ["Ride"] = 67.45, ["Fly|Ride"] = 131.25, ["Neon"] = 121.54, ["Neon|Ride"] = 207.9, ["Neon|Fly|Ride"] = 568.45, ["Mega"] = 892.29, ["Mega|Ride"] = 860.43, ["Mega|Fly|Ride"] = 959.45}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.92, ["Fly"] = 28.76, ["Ride"] = 68.25, ["Fly|Ride"] = 59.07, ["Neon"] = 96.46, ["Mega|Ride"] = 525}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 4.81, ["Fly"] = 28.76, ["Ride"] = 18.8, ["Fly|Ride"] = 61.15, ["Neon"] = 20.99, ["Neon|Fly"] = 85.17, ["Neon|Ride"] = 25.97, ["Neon|Fly|Ride"] = 71.8, ["Mega"] = 185.24, ["Mega|Fly|Ride"] = 272.25}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 73.98, ["Fly"] = 433.12, ["Ride"] = 393.75, ["Fly|Ride"] = 262.5, ["Neon"] = 406.88, ["Neon|Ride"] = 393.75, ["Mega"] = 4479.37, ["Mega|Ride"] = 2165.63, ["Mega|Fly|Ride"] = 2887.49}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 5, ["Fly"] = 45.55, ["Ride"] = 22.91, ["Fly|Ride"] = 57.75, ["Neon"] = 28.88, ["Neon|Ride"] = 57.56, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 184, ["Mega|Ride"] = 212.91, ["Mega|Fly|Ride"] = 319.79}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 72.19, ["Fly"] = 143.06, ["Ride"] = 114.63, ["Fly|Ride"] = 156.19, ["Neon"] = 215.25, ["Neon|Fly"] = 323.61, ["Neon|Ride"] = 194.91, ["Neon|Fly|Ride"] = 314.64, ["Mega"] = 1010.63, ["Mega|Ride"] = 1036.88, ["Mega|Fly|Ride"] = 976.5}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 19.69, ["Ride"] = 52.4, ["Fly|Ride"] = 149.04, ["Neon"] = 95.92, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 393.74, ["Mega|Fly"] = 425.81, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 436.41}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 5.2, ["Fly"] = 42.6, ["Ride"] = 15.99, ["Fly|Ride"] = 70.13, ["Neon"] = 118.17, ["Neon|Ride"] = 191.67, ["Neon|Fly|Ride"] = 381.39, ["Mega"] = 160.72, ["Mega|Ride"] = 212.91, ["Mega|Fly|Ride"] = 549.29}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 15.11, ["Ride"] = 43.2, ["Fly|Ride"] = 142.65, ["Neon"] = 24.93, ["Neon|Fly"] = 119.9, ["Neon|Ride"] = 74.42, ["Neon|Fly|Ride"] = 242.82, ["Mega"] = 269, ["Mega|Ride"] = 340.65, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 3.93, ["Ride"] = 30.54, ["Fly|Ride"] = 103.13, ["Neon"] = 32.45, ["Neon|Ride"] = 39.9, ["Neon|Fly|Ride"] = 128.29, ["Mega"] = 276.63, ["Mega|Ride"] = 276.43, ["Mega|Fly|Ride"] = 381.7}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Ride"] = 70.81, ["Neon"] = 2.1, ["Neon|Fly"] = 94.74, ["Neon|Ride"] = 101.14, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 17.82, ["Mega|Ride"] = 142.65, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 2.5, ["Ride"] = 120.89, ["Fly|Ride"] = 91.88, ["Neon"] = 27.57, ["Neon|Ride"] = 189.39, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 227.07, ["Mega|Ride"] = 504.57, ["Mega|Fly|Ride"] = 513.32}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 126.69, ["Ride"] = 28.53, ["Neon"] = 28.58, ["Neon|Fly"] = 116.94, ["Neon|Ride"] = 71.34, ["Neon|Fly|Ride"] = 185.24, ["Mega"] = 210.67, ["Mega|Ride"] = 283.17, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 3.77, ["Ride"] = 32.8, ["Fly|Ride"] = 119.91, ["Neon"] = 30.89, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 125.63, ["Mega|Ride"] = 284.23, ["Mega|Fly|Ride"] = 519.74}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 512.36, ["Ride"] = 506.63, ["Fly|Ride"] = 577.49, ["Neon"] = 1809.63, ["Neon|Fly"] = 1811.77, ["Neon|Ride"] = 1850.08, ["Neon|Fly|Ride"] = 1666.88, ["Mega|Fly|Ride"] = 5892.62}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 3.57, ["Fly"] = 45.47, ["Ride"] = 20.42, ["Fly|Ride"] = 53.52, ["Neon"] = 71.34, ["Neon|Ride"] = 57.5, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 196.88, ["Mega|Ride"] = 368.2, ["Mega|Fly|Ride"] = 352.35}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 4.81, ["Fly"] = 66.94, ["Ride"] = 19.68, ["Fly|Ride"] = 51.55, ["Neon"] = 75.49, ["Neon|Fly"] = 315, ["Neon|Ride"] = 73.85, ["Neon|Fly|Ride"] = 166.07, ["Mega"] = 331.86, ["Mega|Ride"] = 479.74, ["Mega|Fly|Ride"] = 421.55}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.1, ["Fly"] = 24.93, ["Ride"] = 21.31, ["Fly|Ride"] = 50.79, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 131.25}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.6, ["Ride"] = 24.39, ["Fly|Ride"] = 89.15, ["Neon"] = 9.19, ["Neon|Ride"] = 30.06, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 61.71, ["Mega|Fly"] = 284.23, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 236.23}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 71.34, ["Ride"] = 17.07, ["Neon"] = 2.5, ["Neon|Ride"] = 24.34, ["Neon|Fly|Ride"] = 113.91, ["Mega"] = 19.69, ["Mega|Fly"] = 199.07, ["Mega|Ride"] = 85.22, ["Mega|Fly|Ride"] = 225.69}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1155}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 5.25, ["Fly"] = 26.25, ["Ride"] = 30.43, ["Fly|Ride"] = 332.13, ["Neon"] = 66.15, ["Neon|Ride"] = 100.08, ["Mega"] = 353.8, ["Mega|Ride"] = 368.2, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 28.26, ["Neon"] = 5.25, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 994.24, ["Mega"] = 37.24, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 182.44}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 3.56, ["Fly"] = 312.35, ["Ride"] = 32.39, ["Neon"] = 20.9, ["Neon|Ride"] = 157.57, ["Neon|Fly|Ride"] = 249.8, ["Mega"] = 249.38, ["Mega|Ride"] = 359.81, ["Mega|Fly|Ride"] = 1064.49}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 416.06, ["Ride"] = 393.75, ["Fly|Ride"] = 525, ["Neon|Ride"] = 1449.4, ["Neon|Fly|Ride"] = 1312.49, ["Mega"] = 7983.63, ["Mega|Fly|Ride"] = 6164.82}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 3.88, ["Fly"] = 196.88, ["Ride"] = 42.6, ["Fly|Ride"] = 127.75, ["Neon"] = 41.52, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 191.85, ["Mega"] = 284.27, ["Mega|Ride"] = 311.85, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 93.53, ["Ride"] = 28.88, ["Fly|Ride"] = 118.1, ["Neon"] = 3.49, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 100.08, ["Mega"] = 30.63, ["Mega|Fly"] = 142.65, ["Mega|Ride"] = 76.12, ["Mega|Fly|Ride"] = 154.49}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 142.64, ["Neon|Fly|Ride"] = 198, ["Mega"] = 32.82, ["Mega|Ride"] = 170.33, ["Mega|Fly|Ride"] = 209.97}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 19.21, ["Fly"] = 107.89, ["Ride"] = 42.72, ["Fly|Ride"] = 142.65, ["Neon"] = 157.5, ["Neon|Ride"] = 170.33, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 446.25, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 5.25, ["Ride"] = 71.31, ["Neon"] = 75.55, ["Neon|Ride"] = 184.65, ["Neon|Fly|Ride"] = 479.58, ["Mega"] = 479.74, ["Mega|Ride"] = 482.35, ["Mega|Fly|Ride"] = 702.57}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 7.25, ["Ride"] = 32.39, ["Neon"] = 95.82, ["Neon|Ride"] = 189, ["Mega"] = 619.55, ["Mega|Fly|Ride"] = 801.94}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 12.02, ["Ride"] = 24.35, ["Fly|Ride"] = 236.25, ["Neon"] = 167.28, ["Neon|Ride"] = 177.5, ["Neon|Fly|Ride"] = 241.5, ["Mega"] = 643.02, ["Mega|Ride"] = 568.45, ["Mega|Fly|Ride"] = 547.16}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 393.75, ["Ride"] = 421.19, ["Fly|Ride"] = 710.01, ["Neon"] = 1758.89, ["Neon|Ride"] = 1420.02, ["Neon|Fly|Ride"] = 1102.5, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 3.93, ["Fly"] = 78.75, ["Ride"] = 33.39, ["Fly|Ride"] = 64.4, ["Neon"] = 96.89, ["Neon|Ride"] = 164.05, ["Mega|Fly"] = 590.63, ["Mega|Ride"] = 561.1, ["Mega|Fly|Ride"] = 740.9}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 2.1, ["Ride"] = 42.68, ["Fly|Ride"] = 127.32, ["Neon"] = 38.57, ["Neon|Ride"] = 221.82, ["Mega"] = 170.63, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 26.98, ["Ride"] = 92.53, ["Fly|Ride"] = 170.63, ["Neon"] = 103.69, ["Neon|Fly"] = 186.31, ["Neon|Ride"] = 173.52, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 366.22, ["Mega|Ride"] = 362.25, ["Mega|Fly|Ride"] = 465.93}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Ride"] = 65.63, ["Fly|Ride"] = 212.91, ["Neon"] = 7.4, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 275.71, ["Mega"] = 39.38, ["Mega|Ride"] = 128.35, ["Mega|Fly|Ride"] = 279.57}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 38.07, ["Ride"] = 79.06, ["Neon"] = 328.13, ["Neon|Ride"] = 281.15, ["Neon|Fly|Ride"] = 523.73, ["Mega"] = 1619.06, ["Mega|Ride"] = 2079.59, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 76.67, ["Ride"] = 26.25, ["Fly|Ride"] = 262.5, ["Neon"] = 5.25, ["Neon|Fly"] = 185.24, ["Neon|Ride"] = 28.48, ["Neon|Fly|Ride"] = 127.75, ["Mega"] = 60.38, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 225.75}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 28.58, ["Fly|Ride"] = 98.34, ["Neon"] = 4.16, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 48.97, ["Neon|Fly|Ride"] = 103.95, ["Mega"] = 25.89, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 261.85}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 37.95, ["Fly|Ride"] = 131.07, ["Neon"] = 9.1, ["Neon|Ride"] = 53.55, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 67.89, ["Mega|Ride"] = 81.08, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 46.78, ["Fly"] = 65.61, ["Ride"] = 61.57, ["Fly|Ride"] = 143.9, ["Neon"] = 183.75, ["Neon|Ride"] = 330.29, ["Neon|Fly|Ride"] = 479.58, ["Mega|Ride"] = 1135.82, ["Mega|Fly|Ride"] = 1114.53}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 197.29, ["Ride"] = 254.2, ["Fly|Ride"] = 320.14, ["Neon"] = 1703.19, ["Neon|Ride"] = 1426.7, ["Neon|Fly|Ride"] = 1509.38, ["Mega"] = 12773.79, ["Mega|Fly|Ride"] = 4542.16}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 3.15, ["Ride"] = 100.08, ["Neon"] = 20.99, ["Neon|Fly"] = 350.44, ["Mega"] = 105.29, ["Mega|Ride"] = 197.97, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 20.1, ["Fly|Ride"] = 160.68, ["Neon"] = 8.13, ["Neon|Ride"] = 43.89, ["Neon|Fly|Ride"] = 170.33, ["Mega"] = 36.45, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 196.76}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 4.27, ["Ride"] = 28.76, ["Fly|Ride"] = 31.5, ["Neon"] = 32.81, ["Mega"] = 225.57, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 3.68, ["Fly"] = 94.85, ["Ride"] = 33.85, ["Fly|Ride"] = 320.14, ["Neon"] = 19.59, ["Neon|Ride"] = 51.98, ["Neon|Fly|Ride"] = 139.02, ["Mega"] = 123.44, ["Mega|Fly"] = 118.12, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 347.82}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 93.69, ["Neon"] = 9.01, ["Neon|Ride"] = 142.65, ["Neon|Fly|Ride"] = 142.65, ["Mega"] = 39.38, ["Mega|Ride"] = 90.02, ["Mega|Fly|Ride"] = 398.13}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 40.46, ["Ride"] = 19.04, ["Fly|Ride"] = 52.5, ["Neon"] = 3.94, ["Neon|Fly"] = 80.34, ["Neon|Ride"] = 28.25, ["Neon|Fly|Ride"] = 106.46, ["Mega"] = 39.37, ["Mega|Ride"] = 99.68, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 17.91, ["Fly|Ride"] = 56.44, ["Neon"] = 14.85, ["Neon|Fly"] = 101.14, ["Neon|Ride"] = 39.69, ["Neon|Fly|Ride"] = 106.46, ["Mega"] = 156.15, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 23.24, ["Ride"] = 36.05, ["Fly|Ride"] = 78.75, ["Neon"] = 105, ["Neon|Ride"] = 211.45, ["Neon|Fly|Ride"] = 183.54, ["Mega"] = 393.75, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 565.26}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 56.44, ["Ride"] = 88.75, ["Fly|Ride"] = 139.13, ["Neon"] = 423.69, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 345.92, ["Neon|Fly|Ride"] = 464.62, ["Mega"] = 1988.47, ["Mega|Ride"] = 3254.99, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 19.19, ["Fly|Ride"] = 144.38, ["Neon"] = 3.93, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 28.76, ["Neon|Fly|Ride"] = 142.65, ["Mega"] = 32.8, ["Mega|Fly"] = 672, ["Mega|Ride"] = 92.42, ["Mega|Fly|Ride"] = 249.11}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 14.34, ["Ride"] = 15.74, ["Fly|Ride"] = 42.52, ["Neon"] = 3.49, ["Neon|Fly"] = 28.75, ["Neon|Ride"] = 20.89, ["Neon|Fly|Ride"] = 61.68, ["Mega"] = 40.43, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 68.14, ["Mega|Fly|Ride"] = 126.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 3.94, ["Fly"] = 42.6, ["Ride"] = 28.76, ["Neon"] = 47.97, ["Neon|Ride"] = 143.89, ["Mega"] = 539.7, ["Mega|Ride"] = 275.62, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.74, ["Ride"] = 485.63, ["Fly|Ride"] = 446.25, ["Neon"] = 4257.94, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 18.38, ["Fly"] = 100.08, ["Ride"] = 40.26, ["Fly|Ride"] = 61.77, ["Neon"] = 131.25, ["Neon|Ride"] = 191.63, ["Neon|Fly|Ride"] = 259.88, ["Mega"] = 1050, ["Mega|Ride"] = 871.88, ["Mega|Fly|Ride"] = 910.16}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 15.99, ["Fly|Ride"] = 283.17, ["Neon"] = 9.13, ["Neon|Ride"] = 49.21, ["Neon|Fly|Ride"] = 141.63, ["Mega"] = 84.11, ["Mega|Ride"] = 232.68, ["Mega|Fly|Ride"] = 272.99}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 83.85, ["Ride"] = 57.5, ["Fly|Ride"] = 65.63, ["Neon"] = 50.7, ["Neon|Ride"] = 72.34, ["Mega"] = 169.26, ["Mega|Fly|Ride"] = 318.29}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 28.85, ["Fly"] = 169.31, ["Ride"] = 38.07, ["Fly|Ride"] = 123.51, ["Neon"] = 194.25, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 318.29, ["Mega"] = 2554.77, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1002.75}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 95.95, ["Fly"] = 119.34, ["Ride"] = 114.58, ["Fly|Ride"] = 212.91, ["Neon"] = 353.66, ["Neon|Fly"] = 710.01, ["Neon|Ride"] = 479.58, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 8515.87, ["Mega|Fly|Ride"] = 2572.5}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 234.84, ["Ride"] = 263.48, ["Fly|Ride"] = 531.19, ["Neon"] = 638.71, ["Neon|Ride"] = 702.44, ["Neon|Fly|Ride"] = 984.38, ["Mega|Fly|Ride"] = 3792.76}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 9.87, ["Ride"] = 53.24, ["Fly|Ride"] = 150.94, ["Neon"] = 57.75, ["Neon|Fly"] = 119.89, ["Neon|Ride"] = 96.72, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 389.81, ["Mega|Ride"] = 411.77, ["Mega|Fly|Ride"] = 498.53}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 25.35, ["Ride"] = 16.7, ["Fly|Ride"] = 43.32, ["Neon"] = 7.7, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 92.63, ["Mega"] = 93.09, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 187.84}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.1, ["Ride"] = 15.32, ["Fly|Ride"] = 46.69, ["Neon"] = 30.79, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 96.3, ["Mega"] = 282.02, ["Mega|Ride"] = 243.18, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 341.04, ["Ride"] = 328.13, ["Fly|Ride"] = 735.58, ["Neon"] = 1569.1, ["Neon|Fly|Ride"] = 1911.82, ["Mega"] = 10219.04, ["Mega|Fly|Ride"] = 5118.75}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 33.01, ["Neon"] = 6.61, ["Neon|Ride"] = 139.41, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 28.48, ["Mega|Ride"] = 106.46, ["Mega|Fly|Ride"] = 448.42}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 4.81, ["Ride"] = 17.01, ["Fly|Ride"] = 39.35, ["Neon"] = 22.32, ["Neon|Ride"] = 33.01, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 204.39, ["Mega|Ride"] = 212.91, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 13.13, ["Ride"] = 71.95, ["Neon"] = 89.25, ["Neon|Fly"] = 425.81, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 411.97, ["Mega"] = 539.04, ["Mega|Ride"] = 582.51, ["Mega|Fly|Ride"] = 638.34}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 98.44, ["Fly"] = 142.65, ["Ride"] = 71.6, ["Fly|Ride"] = 139.2, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 568.32, ["Mega|Fly|Ride"] = 2379.57}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 17.07, ["Fly"] = 24.46, ["Ride"] = 26.16, ["Fly|Ride"] = 52.74, ["Neon"] = 131.81, ["Neon|Ride"] = 89.3, ["Neon|Fly|Ride"] = 142.65, ["Mega"] = 710.01, ["Mega|Ride"] = 507.65, ["Mega|Fly|Ride"] = 576.18}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 21.31, ["Neon"] = 2.48, ["Neon|Ride"] = 142.65, ["Mega"] = 30.19, ["Mega|Ride"] = 127.75, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 15.99, ["Fly|Ride"] = 85.17, ["Neon"] = 2.1, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 20.24, ["Neon|Fly|Ride"] = 83.39, ["Mega"] = 21, ["Mega|Fly"] = 97.12, ["Mega|Ride"] = 41.99, ["Mega|Fly|Ride"] = 111.56}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 13.63, ["Ride"] = 56.44, ["Fly|Ride"] = 178.85, ["Neon"] = 30.19, ["Neon|Ride"] = 93.56, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 175.77, ["Mega|Ride"] = 218.75, ["Mega|Fly|Ride"] = 312.22}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1260, ["Ride"] = 1186.83, ["Fly|Ride"] = 1345.82, ["Neon"] = 4376.12, ["Neon|Ride"] = 4683.73, ["Neon|Fly|Ride"] = 4404.84, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 413.34, ["Ride"] = 446.25, ["Fly|Ride"] = 564.38, ["Neon"] = 1680, ["Neon|Ride"] = 1680, ["Neon|Fly|Ride"] = 1753.5, ["Mega"] = 17031.71, ["Mega|Fly|Ride"] = 7423.7}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 280.3, ["Fly"] = 405.46, ["Ride"] = 304.5, ["Fly|Ride"] = 418.69, ["Neon"] = 746.46, ["Neon|Fly"] = 1119.67, ["Neon|Ride"] = 708.65, ["Neon|Fly|Ride"] = 786.18, ["Mega|Fly|Ride"] = 2916.23}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 212.91, ["Fly"] = 424.75, ["Ride"] = 279.56, ["Fly|Ride"] = 354.38, ["Neon"] = 708.75, ["Neon|Ride"] = 654.94, ["Neon|Fly|Ride"] = 643.19, ["Mega|Fly|Ride"] = 3080.62}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 15.62, ["Ride"] = 15.64, ["Fly|Ride"] = 39.38, ["Neon"] = 2.63, ["Neon|Ride"] = 30.45, ["Neon|Fly|Ride"] = 102.2, ["Mega"] = 63.94, ["Mega|Fly"] = 113.91, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 233.59, ["Fly"] = 1420.02, ["Ride"] = 295.32, ["Fly|Ride"] = 656.25, ["Neon"] = 1277.39, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 21573.86, ["Mega|Ride"] = 5109.53, ["Mega|Fly|Ride"] = 4593.75}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 3, ["Fly"] = 157.5, ["Ride"] = 70.27, ["Fly|Ride"] = 91.87, ["Neon"] = 26.99, ["Neon|Ride"] = 115.69, ["Neon|Fly|Ride"] = 255.49, ["Mega"] = 173.54, ["Mega|Ride"] = 288.16, ["Mega|Fly|Ride"] = 411.97}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 18.12, ["Ride"] = 15.99, ["Fly|Ride"] = 38.98, ["Neon"] = 8.75, ["Neon|Ride"] = 44.72, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 105, ["Mega|Ride"] = 192.31, ["Mega|Fly|Ride"] = 105.56}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 56.03, ["Ride"] = 15.75, ["Neon"] = 3.56, ["Neon|Ride"] = 45.94, ["Mega"] = 32.82, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 177.62}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 28.88, ["Ride"] = 57.7, ["Fly|Ride"] = 459.38, ["Neon"] = 245.44, ["Neon|Ride"] = 355.56, ["Mega"] = 1050, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 7993.52, ["Ride"] = 26.39, ["Fly|Ride"] = 68.25, ["Neon"] = 6.36, ["Neon|Ride"] = 61.13, ["Mega"] = 353.42, ["Mega|Ride"] = 411.97, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 22.8, ["Neon"] = 2.1, ["Neon|Ride"] = 55.11, ["Neon|Fly|Ride"] = 118.17, ["Mega"] = 21.96, ["Mega|Ride"] = 70.27, ["Mega|Fly|Ride"] = 160.72}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.63, ["Fly"] = 42.6, ["Ride"] = 31.39, ["Fly|Ride"] = 59.07, ["Neon"] = 20.6, ["Neon|Fly"] = 113.91, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 160.72, ["Mega"] = 105, ["Mega|Ride"] = 127.75, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 6.07, ["Fly"] = 71.34, ["Ride"] = 24.5, ["Fly|Ride"] = 50.3, ["Neon"] = 36.21, ["Neon|Fly"] = 143.88, ["Neon|Ride"] = 142.65, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 238.83, ["Mega|Ride"] = 251.07, ["Mega|Fly|Ride"] = 1321.69}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 10.5, ["Ride"] = 55.37, ["Neon"] = 92.63, ["Neon|Ride"] = 185.24, ["Neon|Fly|Ride"] = 315.44, ["Mega"] = 425.81, ["Mega|Ride"] = 797.31}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 6395.29, ["Ride"] = 16.96, ["Neon"] = 50.42, ["Neon|Fly"] = 49.88, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 284.23, ["Mega"] = 328.13, ["Mega|Ride"] = 355.56, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 65.01, ["Ride"] = 18.36, ["Fly|Ride"] = 45.83, ["Neon"] = 3.93, ["Neon|Fly"] = 31.95, ["Neon|Ride"] = 27.45, ["Neon|Fly|Ride"] = 104.33, ["Mega"] = 45.94, ["Mega|Fly|Ride"] = 239.88}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 144.38, ["Fly"] = 227.81, ["Ride"] = 164.03, ["Fly|Ride"] = 262.5, ["Neon"] = 958.06, ["Neon|Ride"] = 900.39, ["Neon|Fly|Ride"] = 839.88, ["Mega"] = 8515.87, ["Mega|Fly|Ride"] = 3975.85}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 19.18, ["Ride"] = 15.49, ["Fly|Ride"] = 29.89, ["Neon"] = 3.82, ["Neon|Fly"] = 35.98, ["Neon|Ride"] = 23.61, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 36.75, ["Mega|Ride"] = 57.74, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 5.8, ["Ride"] = 40.25, ["Fly|Ride"] = 196.88, ["Neon"] = 55.12, ["Neon|Ride"] = 113.91, ["Neon|Fly|Ride"] = 767.31, ["Mega"] = 313.69, ["Mega|Ride"] = 290.11, ["Mega|Fly|Ride"] = 379.32}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 26.16, ["Ride"] = 309.67, ["Fly|Ride"] = 170.63, ["Neon"] = 157.5, ["Neon|Ride"] = 199.07, ["Neon|Fly|Ride"] = 183.65, ["Mega"] = 786.19, ["Mega|Ride"] = 748.13, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 194.24, ["Fly"] = 304.5, ["Ride"] = 252.65, ["Fly|Ride"] = 288.75, ["Neon"] = 812.4, ["Neon|Fly"] = 799.6, ["Neon|Ride"] = 695.63, ["Neon|Fly|Ride"] = 756, ["Mega|Fly|Ride"] = 3508.55}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 15.99, ["Ride"] = 159.91, ["Fly|Ride"] = 143.9, ["Neon"] = 78.75, ["Neon|Ride"] = 212.91, ["Neon|Fly|Ride"] = 425.81, ["Mega"] = 242.82, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 340.65}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 5.06, ["Fly"] = 95.93, ["Ride"] = 57.75, ["Fly|Ride"] = 638.71, ["Neon"] = 118.57, ["Neon|Fly"] = 160.65, ["Neon|Ride"] = 209.83, ["Neon|Fly|Ride"] = 184.21, ["Mega"] = 1135.82, ["Mega|Ride"] = 851.6, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 908.15, ["Fly"] = 1198.99, ["Ride"] = 931.88, ["Fly|Ride"] = 1035.57, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 4854.05, ["Mega|Ride"] = 14193.81, ["Mega|Fly|Ride"] = 15613.83}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 4.27, ["Fly"] = 23.48, ["Ride"] = 20.79, ["Fly|Ride"] = 61.77, ["Neon"] = 44.63, ["Neon|Fly"] = 67.01, ["Neon|Ride"] = 49.13, ["Neon|Fly|Ride"] = 212.91, ["Mega"] = 208.69, ["Mega|Ride"] = 212.91, ["Mega|Fly|Ride"] = 346.49}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 4.46, ["Fly"] = 78.75, ["Ride"] = 49.87, ["Fly|Ride"] = 135.19, ["Neon"] = 42.59, ["Neon|Ride"] = 95.93, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 528, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 85.17, ["Ride"] = 23.79, ["Fly|Ride"] = 55.13, ["Neon"] = 10.83, ["Neon|Ride"] = 46.48, ["Mega"] = 61.77, ["Mega|Ride"] = 360.34, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 11.19, ["Ride"] = 39.29, ["Fly|Ride"] = 94.5, ["Neon"] = 61.69, ["Neon|Fly"] = 143.83, ["Neon|Ride"] = 95.82, ["Neon|Fly|Ride"] = 142.65, ["Mega"] = 437.07, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.51, ["Fly"] = 20.6, ["Ride"] = 15.98, ["Fly|Ride"] = 51.91, ["Neon"] = 19.48, ["Neon|Fly"] = 42.74, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 113.91, ["Mega"] = 105, ["Mega|Fly"] = 280.98, ["Mega|Ride"] = 126.69, ["Mega|Fly|Ride"] = 192.8}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 65.63, ["Neon"] = 9.85, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 80.34, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 124.48, ["Mega|Ride"] = 185.24}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 131.25, ["Fly"] = 237.39, ["Ride"] = 170.33, ["Fly|Ride"] = 425.81, ["Neon"] = 921.85, ["Neon|Fly|Ride"] = 1183.01}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.81, ["Ride"] = 19.69, ["Fly|Ride"] = 108.06, ["Neon"] = 6.45, ["Neon|Ride"] = 48.05, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 61.68, ["Mega|Ride"] = 127.37, ["Mega|Fly|Ride"] = 270.39}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.91, ["Ride"] = 28.76, ["Fly|Ride"] = 88.86, ["Neon"] = 27.69, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.26, ["Mega"] = 160.72, ["Mega|Ride"] = 320.22, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.52, ["Fly"] = 94.73, ["Ride"] = 19.69, ["Neon"] = 14.15, ["Neon|Ride"] = 19.69, ["Mega"] = 94.38, ["Mega|Ride"] = 120.53, ["Mega|Fly|Ride"] = 459.27}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 65.7, ["Ride"] = 111.64, ["Fly|Ride"] = 284.23, ["Neon"] = 447.57, ["Neon|Ride"] = 392.44, ["Neon|Fly|Ride"] = 755.32, ["Mega"] = 2554.77, ["Mega|Ride"] = 4257.94, ["Mega|Fly|Ride"] = 1271.01}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 20.57, ["Fly"] = 90.77, ["Ride"] = 42.53, ["Fly|Ride"] = 264.01, ["Neon"] = 179.31, ["Neon|Ride"] = 182.89, ["Neon|Fly|Ride"] = 341.93, ["Mega"] = 642.97, ["Mega|Ride"] = 611.03, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 15.02, ["Fly"] = 57.5, ["Ride"] = 39.34, ["Fly|Ride"] = 97.13, ["Neon"] = 81.38, ["Neon|Ride"] = 100.08, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 425.81, ["Mega|Ride"] = 413.44, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 6.28, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 236.15, ["Mega"] = 110.23, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 539.7}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 36.75, ["Fly"] = 74.79, ["Ride"] = 63.89, ["Fly|Ride"] = 103.69, ["Neon"] = 262.49, ["Neon|Fly"] = 233.17, ["Neon|Ride"] = 196.86, ["Neon|Fly|Ride"] = 309.24, ["Mega|Fly|Ride"] = 1011.71}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.47, ["Fly|Ride"] = 52.49, ["Neon"] = 4.6, ["Neon|Ride"] = 57.5, ["Neon|Fly|Ride"] = 126.69, ["Mega"] = 60.68, ["Mega|Ride"] = 283.17, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 17.75, ["Fly"] = 112.72, ["Ride"] = 31.49, ["Fly|Ride"] = 86.35, ["Neon"] = 70.83, ["Neon|Ride"] = 64.66, ["Neon|Fly|Ride"] = 210, ["Mega"] = 393.75, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 320.22, ["Mega|Fly|Ride"] = 427.88}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 41.93, ["Fly"] = 203.34, ["Ride"] = 76.12, ["Fly|Ride"] = 131.25, ["Neon"] = 249.06, ["Neon|Fly"] = 425.81, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 410.93, ["Mega|Ride"] = 1382.78, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 13.64, ["Fly|Ride"] = 28.85, ["Neon"] = 2.1, ["Neon|Fly"] = 24.5, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 16.57, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 38.29, ["Mega|Fly|Ride"] = 92.49}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 131.25, ["Neon"] = 21.3, ["Neon|Ride"] = 65.61, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 170.63, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 392.43}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 10.39, ["Fly"] = 142.65, ["Ride"] = 45.94, ["Fly|Ride"] = 57.5, ["Neon"] = 108.94, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 212.91, ["Mega"] = 557.7, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 651}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 22, ["Neon"] = 2.1, ["Neon|Ride"] = 28.87, ["Neon|Fly|Ride"] = 95.81, ["Mega"] = 20.71, ["Mega|Ride"] = 53.05, ["Mega|Fly|Ride"] = 210.78}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 22.94, ["Fly"] = 203.76, ["Ride"] = 77.95, ["Fly|Ride"] = 177.92, ["Neon"] = 135.2, ["Neon|Ride"] = 173.36, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 653.61, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 553.88, ["Mega|Fly|Ride"] = 687.67}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 10.07, ["Fly"] = 42.6, ["Ride"] = 20.21, ["Fly|Ride"] = 80.91, ["Neon"] = 376.69, ["Neon|Ride"] = 118.18, ["Neon|Fly|Ride"] = 163.94, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 473.71}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 2.12, ["Ride"] = 39.38, ["Neon"] = 40.78, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 59.87, ["Neon|Fly|Ride"] = 710.01, ["Mega"] = 232.98, ["Mega|Ride"] = 269.07, ["Mega|Fly|Ride"] = 473.71}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 5.97, ["Fly"] = 72.19, ["Ride"] = 70.88, ["Fly|Ride"] = 229.69, ["Neon"] = 32.82, ["Neon|Ride"] = 65.54, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 213.7, ["Mega|Ride"] = 442.32, ["Mega|Fly|Ride"] = 385.35}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 42.6, ["Ride"] = 19.59, ["Fly|Ride"] = 196.88, ["Neon"] = 4.54, ["Neon|Ride"] = 34.81, ["Mega"] = 53.81, ["Mega|Fly"] = 212.91, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 142.65}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 57.58, ["Neon"] = 3.56, ["Mega"] = 30.18, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 15.18}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 36.75, ["Fly"] = 100.08, ["Ride"] = 66.27, ["Fly|Ride"] = 79.85, ["Neon"] = 184.57, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 315, ["Mega"] = 1845.83, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 781.35}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 27.57, ["Mega"] = 22.32, ["Mega|Ride"] = 121.26, ["Mega|Fly|Ride"] = 319.36}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 420, ["Fly"] = 498.75, ["Ride"] = 551.25, ["Fly|Ride"] = 599.5, ["Neon"] = 2838.98, ["Neon|Ride"] = 2020.39, ["Neon|Fly|Ride"] = 2697.41, ["Mega"] = 17031.71, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 3.61, ["Fly"] = 48.37, ["Ride"] = 33.72, ["Fly|Ride"] = 68.14, ["Neon"] = 35.6, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 113.91, ["Mega"] = 95.86, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 624.87}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.01, ["Fly|Ride"] = 91.86, ["Neon"] = 19.49, ["Neon|Ride"] = 42.6, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 143.07, ["Mega|Fly"] = 284.23, ["Mega|Ride"] = 157.57, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 8.76, ["Ride"] = 42.17, ["Fly|Ride"] = 532.25, ["Neon"] = 106.32, ["Neon|Ride"] = 142.65, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 674.89, ["Mega|Ride"] = 562.07, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.1, ["Fly"] = 57.5, ["Ride"] = 38.57, ["Fly|Ride"] = 710.01, ["Neon"] = 29.54, ["Neon|Fly"] = 50.05, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 278.25, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 6.04, ["Ride"] = 82.69, ["Fly|Ride"] = 157.49, ["Neon"] = 52.5, ["Neon|Ride"] = 143.89, ["Neon|Fly|Ride"] = 273.02, ["Mega"] = 348.1, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1064.49}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 5.25, ["Ride"] = 27.97, ["Fly|Ride"] = 78.75, ["Neon"] = 30.96, ["Neon|Ride"] = 79.19, ["Neon|Fly|Ride"] = 105, ["Mega"] = 227.81, ["Mega|Ride"] = 314.45, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 41.98, ["Ride"] = 13.8, ["Fly|Ride"] = 76.67, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 15.72, ["Neon|Fly|Ride"] = 76.67, ["Mega"] = 15.51, ["Mega|Fly"] = 64.78, ["Mega|Ride"] = 37.62, ["Mega|Fly|Ride"] = 93.26}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 3.87, ["Fly"] = 54.3, ["Ride"] = 38.43, ["Fly|Ride"] = 106.46, ["Neon"] = 18.69, ["Neon|Fly"] = 119.9, ["Neon|Ride"] = 46.01, ["Neon|Fly|Ride"] = 195.43, ["Mega"] = 196.87, ["Mega|Ride"] = 213.84, ["Mega|Fly|Ride"] = 320.22}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 283.5, ["Ride"] = 325.66, ["Fly|Ride"] = 363.57, ["Neon"] = 1312.5, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1253.44, ["Mega|Ride"] = 9306.51, ["Mega|Fly|Ride"] = 4797.18}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 74.8, ["Ride"] = 112.88, ["Fly|Ride"] = 254.43, ["Neon"] = 458.07, ["Neon|Fly"] = 911.22, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 594.99, ["Mega"] = 2271.62, ["Mega|Ride"] = 1489.22, ["Mega|Fly|Ride"] = 1519.58}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 17.06, ["Ride"] = 15.89, ["Fly|Ride"] = 35.43, ["Neon"] = 5.71, ["Neon|Fly"] = 53.91, ["Neon|Ride"] = 34.08, ["Neon|Fly|Ride"] = 63.89, ["Mega"] = 88.36, ["Mega|Fly"] = 64.78, ["Mega|Ride"] = 78.91, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 14.42, ["Fly|Ride"] = 34.84, ["Neon"] = 6.53, ["Neon|Fly"] = 40.78, ["Neon|Ride"] = 25.96, ["Neon|Fly|Ride"] = 57.7, ["Mega"] = 76.13, ["Mega|Fly"] = 284.23, ["Mega|Ride"] = 76.32, ["Mega|Fly|Ride"] = 168}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.98, ["Fly"] = 100.08, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 100.08, ["Neon|Fly|Ride"] = 157.5, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 212.91, ["Ride"] = 212.91, ["Fly|Ride"] = 288.75, ["Neon"] = 1170.94, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1577.58, ["Mega|Ride"] = 8515.87, ["Mega|Fly|Ride"] = 3615.94}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 16.75, ["Ride"] = 14.74, ["Fly|Ride"] = 42.68, ["Neon"] = 14.42, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 85.17, ["Mega"] = 255.93, ["Mega|Ride"] = 221.82, ["Mega|Fly|Ride"] = 274.65}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 2.1, ["Ride"] = 75.54, ["Fly|Ride"] = 212.91, ["Neon"] = 20.69, ["Neon|Ride"] = 42.6, ["Neon|Fly|Ride"] = 284.23, ["Mega"] = 196.88, ["Mega|Ride"] = 300.43, ["Mega|Fly|Ride"] = 311.09}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 90.3, ["Neon"] = 3.68, ["Neon|Ride"] = 156.19, ["Mega"] = 90.56, ["Mega|Fly"] = 195.88, ["Mega|Ride"] = 335.82, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 11.46, ["Fly"] = 28.54, ["Ride"] = 19.68, ["Fly|Ride"] = 74.52, ["Neon"] = 149.49, ["Neon|Ride"] = 121.36, ["Neon|Fly|Ride"] = 157.57, ["Mega"] = 460.69, ["Mega|Ride"] = 425.81, ["Mega|Fly|Ride"] = 587.89}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 37.57, ["Fly"] = 102.2, ["Ride"] = 78.71, ["Fly|Ride"] = 163.94, ["Neon"] = 125.9, ["Neon|Fly"] = 156.09, ["Neon|Ride"] = 142.65, ["Neon|Fly|Ride"] = 302.75, ["Mega"] = 431.82, ["Mega|Fly"] = 2235.43, ["Mega|Ride"] = 431.82, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 25.96, ["Fly"] = 63.89, ["Ride"] = 43.32, ["Fly|Ride"] = 78.66, ["Neon"] = 157.4, ["Neon|Fly"] = 286.43, ["Neon|Ride"] = 128.4, ["Neon|Fly|Ride"] = 223.12, ["Mega"] = 851.6, ["Mega|Ride"] = 700.88, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 14.84, ["Fly|Ride"] = 51.45, ["Neon"] = 2.1, ["Neon|Fly"] = 31.39, ["Neon|Ride"] = 16.36, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 18.38, ["Mega|Fly"] = 425.81, ["Mega|Ride"] = 35.87, ["Mega|Fly|Ride"] = 94.23}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 198.84, ["Fly"] = 270.39, ["Ride"] = 240.51, ["Fly|Ride"] = 272.98, ["Neon"] = 2960.83, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1044.71, ["Mega|Fly|Ride"] = 3975.85}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 8.97, ["Fly"] = 101.18, ["Ride"] = 24.63, ["Fly|Ride"] = 92.94, ["Neon"] = 107.63, ["Neon|Ride"] = 161.44, ["Neon|Fly|Ride"] = 425.81, ["Mega"] = 430.5, ["Mega|Ride"] = 524.85, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 35.86, ["Ride"] = 18.56, ["Fly|Ride"] = 43.35, ["Neon"] = 3.29, ["Neon|Fly"] = 41.09, ["Neon|Ride"] = 28.76, ["Neon|Fly|Ride"] = 106.46, ["Mega"] = 60.16, ["Mega|Fly"] = 221.43, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 212.91}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 16.14, ["Fly|Ride"] = 72.19, ["Neon"] = 2.63, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 25.56, ["Neon|Fly|Ride"] = 128.29, ["Mega"] = 18.38, ["Mega|Fly"] = 142.65, ["Mega|Ride"] = 45.54, ["Mega|Fly|Ride"] = 108.94}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 42.6, ["Neon"] = 7.77, ["Neon|Fly"] = 719.29, ["Neon|Ride"] = 49.88, ["Mega"] = 105, ["Mega|Ride"] = 131.78, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 11.82, ["Fly"] = 28.88, ["Ride"] = 23.69, ["Fly|Ride"] = 63.89, ["Neon"] = 50.04, ["Neon|Fly"] = 270.39, ["Neon|Ride"] = 56.45, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 355.69, ["Mega|Ride"] = 370.12, ["Mega|Fly|Ride"] = 374.07}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 3.94, ["Ride"] = 65.63, ["Neon"] = 64.98, ["Neon|Ride"] = 149.04, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 235.27, ["Mega|Ride"] = 318.29, ["Mega|Fly|Ride"] = 381.76}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 57.5, ["Neon"] = 3.08, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 100.36, ["Mega"] = 28.7, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 161.81}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 5.43, ["Ride"] = 27.88, ["Fly|Ride"] = 131.25, ["Neon"] = 33.72, ["Neon|Fly"] = 95.85, ["Neon|Ride"] = 45.26, ["Neon|Fly|Ride"] = 284.23, ["Mega"] = 147.98, ["Mega|Ride"] = 224.44, ["Mega|Fly|Ride"] = 257.28}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Fly"] = 71.34, ["Ride"] = 85.17, ["Neon"] = 3.61, ["Neon|Fly"] = 113.91, ["Neon|Ride"] = 45.56, ["Neon|Fly|Ride"] = 102.37, ["Mega"] = 24.94, ["Mega|Ride"] = 72.34, ["Mega|Fly|Ride"] = 319.86}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 45.47, ["Ride"] = 20.1, ["Fly|Ride"] = 40.44, ["Neon"] = 5.24, ["Neon|Ride"] = 23.29, ["Neon|Fly|Ride"] = 107.63, ["Mega"] = 58.29, ["Mega|Fly"] = 142.65, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 208.69}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 656.25, ["Ride"] = 721.88, ["Fly|Ride"] = 761.25, ["Neon|Fly|Ride"] = 3675, ["Mega|Fly|Ride"] = 12775.7}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 15.65, ["Fly|Ride"] = 28.76, ["Neon"] = 11.82, ["Neon|Fly"] = 42.59, ["Neon|Ride"] = 27, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 190.55, ["Mega|Fly|Ride"] = 372.59}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 43.63, ["Neon"] = 11.82, ["Neon|Fly"] = 142.65, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 57.75, ["Mega|Fly"] = 163.94, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 257.23}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 5.72, ["Fly"] = 42.6, ["Ride"] = 21.31, ["Fly|Ride"] = 50.05, ["Neon"] = 41.36, ["Neon|Fly"] = 191.82, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 485.63, ["Mega|Ride"] = 270.58, ["Mega|Fly|Ride"] = 347.82}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 42.6, ["Ride"] = 15.59, ["Fly|Ride"] = 36.22, ["Neon"] = 8.11, ["Neon|Fly"] = 149.04, ["Neon|Ride"] = 23.99, ["Neon|Fly|Ride"] = 57.95, ["Mega"] = 59.06, ["Mega|Ride"] = 95.81, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 35.83, ["Ride"] = 57.5, ["Fly|Ride"] = 314.03, ["Neon"] = 196.88, ["Neon|Ride"] = 284.23, ["Neon|Fly|Ride"] = 424.75, ["Mega"] = 667.45, ["Mega|Ride"] = 646.15}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 32.7, ["Ride"] = 18.95, ["Fly|Ride"] = 76.13, ["Neon"] = 7.31, ["Neon|Fly"] = 136.67, ["Neon|Ride"] = 29.79, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 44.52, ["Mega|Ride"] = 132.9, ["Mega|Fly|Ride"] = 229.68}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 24.5, ["Fly|Ride"] = 59.85, ["Neon"] = 11.55, ["Neon|Ride"] = 42.52, ["Neon|Fly|Ride"] = 160.67, ["Mega"] = 68.77, ["Mega|Ride"] = 198.59, ["Mega|Fly|Ride"] = 352.35}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly|Ride"] = 65.83, ["Neon"] = 12.71, ["Mega"] = 97.12, ["Mega|Ride"] = 159.69, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 14.65, ["Fly|Ride"] = 57.5, ["Neon"] = 3.61, ["Neon|Fly"] = 71.34, ["Neon|Ride"] = 20.24, ["Neon|Fly|Ride"] = 113.09, ["Mega"] = 34.31, ["Mega|Fly"] = 227.38, ["Mega|Ride"] = 81.5, ["Mega|Fly|Ride"] = 212.91}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 10.4, ["Fly"] = 22.17, ["Ride"] = 17.41, ["Fly|Ride"] = 41.53, ["Neon"] = 109.67, ["Neon|Ride"] = 80.85, ["Neon|Fly|Ride"] = 143.07, ["Mega|Ride"] = 398.13, ["Mega|Fly|Ride"] = 347.73}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 665.22, ["Fly"] = 928.01, ["Ride"] = 721.88, ["Fly|Ride"] = 858.72, ["Neon"] = 1935.93, ["Neon|Ride"] = 1874.67, ["Neon|Fly|Ride"] = 2010.03, ["Mega"] = 4654.5, ["Mega|Ride"] = 5947.28, ["Mega|Fly|Ride"] = 5875.96}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 15.99, ["Ride"] = 14.28, ["Fly|Ride"] = 37.29, ["Neon"] = 3.91, ["Neon|Fly"] = 37.05, ["Neon|Ride"] = 18.87, ["Neon|Fly|Ride"] = 42.75, ["Mega"] = 44.63, ["Mega|Ride"] = 76.67, ["Mega|Fly|Ride"] = 142.65}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 4.92, ["Ride"] = 32.81, ["Fly|Ride"] = 239.8, ["Neon"] = 32.39, ["Neon|Ride"] = 118.46, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 376.85, ["Mega|Ride"] = 362.25, ["Mega|Fly|Ride"] = 393.74}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 47.52, ["Fly"] = 104.9, ["Ride"] = 74.8, ["Fly|Ride"] = 105, ["Neon"] = 284.23, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 424.75, ["Mega"] = 2439.83, ["Mega|Fly|Ride"] = 2408.94}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 31.48, ["Fly"] = 146.86, ["Ride"] = 60.38, ["Fly|Ride"] = 104.9, ["Neon"] = 212.91, ["Neon|Ride"] = 161.3, ["Neon|Fly|Ride"] = 425.81, ["Mega"] = 1279.66, ["Mega|Ride"] = 910.16, ["Mega|Fly|Ride"] = 1120.16}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 7.88, ["Fly"] = 88.74, ["Ride"] = 26.49, ["Fly|Ride"] = 142.65, ["Neon"] = 54.57, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 273, ["Mega"] = 255.49, ["Mega|Ride"] = 261.19, ["Mega|Fly|Ride"] = 460.69}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 32.4, ["Ride"] = 57.5, ["Fly|Ride"] = 47.97, ["Neon"] = 103.69, ["Neon|Ride"] = 338.52, ["Neon|Fly|Ride"] = 149.22, ["Mega"] = 262.4, ["Mega|Fly"] = 520.5, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 424.56}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 19.04, ["Ride"] = 31.95, ["Neon"] = 105, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 525, ["Mega"] = 525, ["Mega|Fly"] = 567, ["Mega|Ride"] = 476.44, ["Mega|Fly|Ride"] = 741.57}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 3.94}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 3.9, ["Ride"] = 24.93, ["Fly|Ride"] = 78.75, ["Neon"] = 28.58, ["Neon|Ride"] = 57.04, ["Neon|Fly|Ride"] = 212.91, ["Mega"] = 210, ["Mega|Fly"] = 481.17, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 306.54}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.63, ["Ride"] = 46.85, ["Neon"] = 10.49, ["Neon|Fly|Ride"] = 212.91, ["Mega"] = 140.53}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 27.61, ["Fly"] = 62.99, ["Ride"] = 32.48, ["Fly|Ride"] = 79.24, ["Neon"] = 203.23, ["Neon|Ride"] = 228.69, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 795.18, ["Mega|Ride"] = 681.76, ["Mega|Fly|Ride"] = 731.29}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 4.27, ["Fly"] = 18.38, ["Ride"] = 15.56, ["Fly|Ride"] = 36.21, ["Neon"] = 26.16, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 32.17, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 196.88, ["Mega|Fly"] = 424.75, ["Mega|Ride"] = 175.5, ["Mega|Fly|Ride"] = 233.62}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 4.81, ["Fly"] = 151.17, ["Ride"] = 31.95, ["Fly|Ride"] = 56.27, ["Neon"] = 17.03, ["Neon|Ride"] = 47.67, ["Neon|Fly|Ride"] = 127.1, ["Mega"] = 160.33, ["Mega|Fly"] = 197.4, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Ride"] = 71.34, ["Neon"] = 7.21, ["Mega"] = 40.69, ["Mega|Ride"] = 203.43, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 30.1, ["Ride"] = 50.05, ["Fly|Ride"] = 120.75, ["Neon"] = 284.23, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 425.81, ["Mega"] = 524.99, ["Mega|Ride"] = 14193.81, ["Mega|Fly|Ride"] = 910.16}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 65.62, ["Neon"] = 5.14, ["Neon|Fly"] = 203.44, ["Neon|Ride"] = 85.17, ["Mega"] = 62.5, ["Mega|Ride"] = 139.94}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 11.72, ["Ride"] = 80.34, ["Fly|Ride"] = 283.17, ["Neon"] = 66.94, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 142.65, ["Mega"] = 399, ["Mega|Ride"] = 479.74, ["Mega|Fly|Ride"] = 598.46}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.9, ["Ride"] = 15.36, ["Fly|Ride"] = 42.36, ["Neon"] = 13.13, ["Neon|Ride"] = 30.09, ["Neon|Fly|Ride"] = 97.46, ["Mega"] = 185.24, ["Mega|Ride"] = 208.04, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.15, ["Fly"] = 52.49, ["Ride"] = 23.94, ["Fly|Ride"] = 72.22, ["Neon"] = 40.69, ["Neon|Ride"] = 36.75, ["Mega"] = 398.13, ["Mega|Ride"] = 424.75, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.94, ["Ride"] = 80.79, ["Neon"] = 90.8, ["Neon|Ride"] = 77.43, ["Mega"] = 413.86, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 38.36, ["Ride"] = 157.57, ["Neon"] = 209.98, ["Neon|Ride"] = 421.32, ["Neon|Fly|Ride"] = 630, ["Mega"] = 1114.53, ["Mega|Ride"] = 1383.84, ["Mega|Fly|Ride"] = 1916.09}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 14.26, ["Ride"] = 81.81, ["Neon"] = 107.61, ["Neon|Ride"] = 183.75, ["Mega"] = 349.13, ["Mega|Ride"] = 560.09, ["Mega|Fly|Ride"] = 667.45}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 8.89, ["Ride"] = 126, ["Neon"] = 63.39, ["Neon|Fly"] = 212.91, ["Neon|Ride"] = 170.63, ["Mega"] = 799.95, ["Mega|Ride"] = 431.76, ["Mega|Fly|Ride"] = 568.45}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 19.15, ["Ride"] = 72.19, ["Fly|Ride"] = 367.48, ["Neon"] = 108.94, ["Neon|Ride"] = 262.49, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 653.61, ["Mega|Fly"] = 2128.97, ["Mega|Ride"] = 719.59, ["Mega|Fly|Ride"] = 744.09}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.63, ["Neon"] = 17.22, ["Neon|Fly|Ride"] = 142.65, ["Mega"] = 157.57, ["Mega|Fly|Ride"] = 320.22}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 27.69, ["Ride"] = 14.8, ["Fly|Ride"] = 42.6, ["Neon"] = 6.36, ["Neon|Fly"] = 42.6, ["Neon|Ride"] = 22.67, ["Neon|Fly|Ride"] = 93.69, ["Mega"] = 69.17, ["Mega|Ride"] = 71.34, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 2.1, ["Fly"] = 47.97, ["Ride"] = 23.43, ["Fly|Ride"] = 69.56, ["Neon"] = 11.68, ["Neon|Ride"] = 36.21, ["Neon|Fly|Ride"] = 105, ["Mega"] = 82.69, ["Mega|Ride"] = 104.74, ["Mega|Fly|Ride"] = 301.87}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 32.8, ["Ride"] = 18.38, ["Fly|Ride"] = 57.5, ["Neon"] = 3.56, ["Neon|Ride"] = 19.59, ["Neon|Fly|Ride"] = 107.62, ["Mega"] = 48.56, ["Mega|Fly"] = 122.42, ["Mega|Ride"] = 83.99, ["Mega|Fly|Ride"] = 212.91}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.29, ["Fly"] = 65.63, ["Ride"] = 21.03, ["Fly|Ride"] = 76.67, ["Neon"] = 15.75, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 212.91, ["Mega"] = 284.23, ["Mega|Ride"] = 324.19, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.81, ["Fly"] = 49.6, ["Ride"] = 24.4, ["Fly|Ride"] = 425.81, ["Neon"] = 28.69, ["Neon|Fly"] = 315, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 302.33, ["Mega|Ride"] = 287.46, ["Mega|Fly|Ride"] = 1064.49}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.52, ["Fly"] = 131.25, ["Ride"] = 16.2, ["Fly|Ride"] = 70.16, ["Neon"] = 28.76, ["Neon|Fly"] = 113.91, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 254.26, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 394.93}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.48, ["Ride"] = 23.63, ["Fly|Ride"] = 51.78, ["Neon"] = 21.31, ["Neon|Ride"] = 69.08, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 255.49, ["Mega|Ride"] = 187.44, ["Mega|Fly|Ride"] = 186.18}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 44.63, ["Fly|Ride"] = 91.88, ["Neon"] = 10.39, ["Neon|Fly"] = 437.06, ["Neon|Ride"] = 63.95, ["Neon|Fly|Ride"] = 158.52, ["Mega"] = 91.49, ["Mega|Fly"] = 210, ["Mega|Ride"] = 132.37, ["Mega|Fly|Ride"] = 245.56}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 19.04, ["Fly"] = 212.91, ["Ride"] = 105, ["Fly|Ride"] = 375.26, ["Neon"] = 105, ["Neon|Ride"] = 171.94, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 523.69, ["Mega|Ride"] = 602.41, ["Mega|Fly|Ride"] = 623.44}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 43.78, ["Fly"] = 164.07, ["Ride"] = 83.54, ["Fly|Ride"] = 189, ["Neon"] = 212.91, ["Neon|Ride"] = 184.69, ["Neon|Fly|Ride"] = 366.03, ["Mega"] = 1334.88, ["Mega|Ride"] = 877.62, ["Mega|Fly|Ride"] = 1093.24}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 51.08, ["Ride"] = 21.55, ["Fly|Ride"] = 118.12, ["Neon"] = 2.1, ["Neon|Ride"] = 32.8, ["Neon|Fly|Ride"] = 142.65, ["Mega"] = 24.94, ["Mega|Ride"] = 64.78, ["Mega|Fly|Ride"] = 145.59}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 6.54, ["Ride"] = 52.5, ["Neon"] = 117.7, ["Neon|Ride"] = 112.72, ["Mega"] = 686.56, ["Mega|Ride"] = 710.01, ["Mega|Fly|Ride"] = 1118.78}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 44.87, ["Ride"] = 91.91, ["Neon"] = 409.67, ["Neon|Ride"] = 357, ["Neon|Fly|Ride"] = 850.54, ["Mega"] = 1702.13, ["Mega|Ride"] = 1608.45, ["Mega|Fly|Ride"] = 1170.94}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 6.7, ["Fly"] = 190.32, ["Ride"] = 28.64, ["Fly|Ride"] = 133.88, ["Neon"] = 49.88, ["Neon|Fly"] = 128.28, ["Neon|Ride"] = 70.87, ["Neon|Fly|Ride"] = 125.63, ["Mega"] = 192.94, ["Mega|Ride"] = 242.71, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 5.1, ["Ride"] = 68.85, ["Neon"] = 9.07, ["Neon|Ride"] = 68.23, ["Neon|Fly|Ride"] = 170.33, ["Mega"] = 83.99, ["Mega|Fly"] = 282.18, ["Mega|Ride"] = 140.44, ["Mega|Fly|Ride"] = 369.39}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 25.71, ["Ride"] = 16.98, ["Fly|Ride"] = 45.94, ["Neon"] = 8.81, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 102.2, ["Mega"] = 124.69, ["Mega|Ride"] = 63.53, ["Mega|Fly|Ride"] = 279.57}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 17.47, ["Ride"] = 15.6, ["Fly|Ride"] = 42.6, ["Neon"] = 2.1, ["Neon|Fly"] = 23.41, ["Neon|Ride"] = 27.55, ["Neon|Fly|Ride"] = 45.85, ["Mega"] = 28.88, ["Mega|Ride"] = 69.56, ["Mega|Fly|Ride"] = 87.94}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 15.75, ["Fly|Ride"] = 85.17, ["Neon"] = 3.78, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 35.07, ["Mega|Fly"] = 125.31, ["Mega|Ride"] = 63.89, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Neon"] = 2.24, ["Neon|Ride"] = 145.08, ["Mega"] = 32.82, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 328.02}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 4.35, ["Ride"] = 104.99, ["Neon"] = 37.97, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 400.57, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 411.97}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 7.66, ["Ride"] = 30.19, ["Fly|Ride"] = 211.03, ["Neon"] = 53.72, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 227.81, ["Mega"] = 196.88, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 5.07, ["Fly"] = 21.31, ["Ride"] = 16.41, ["Fly|Ride"] = 35.43, ["Neon"] = 28.56, ["Neon|Fly"] = 57.56, ["Neon|Ride"] = 35.9, ["Neon|Fly|Ride"] = 83.94, ["Mega"] = 326.81, ["Mega|Ride"] = 261.82, ["Mega|Fly|Ride"] = 360.36}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 53.99, ["Ride"] = 88.54, ["Fly|Ride"] = 262.5, ["Neon"] = 393.75, ["Neon|Ride"] = 424.75, ["Neon|Fly|Ride"] = 710.01, ["Mega"] = 2398.6, ["Mega|Ride"] = 1279.66, ["Mega|Fly|Ride"] = 1276.32}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 4.27, ["Fly"] = 82.69, ["Ride"] = 43.22, ["Fly|Ride"] = 51.19, ["Neon"] = 284.23, ["Neon|Fly|Ride"] = 630, ["Mega"] = 479.74, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 1042.79}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 21.11, ["Ride"] = 15.75, ["Fly|Ride"] = 39.58, ["Neon"] = 2.1, ["Neon|Fly"] = 42.6, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 157.5, ["Mega|Fly"] = 71.34, ["Mega|Ride"] = 93.44, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 21.31, ["Ride"] = 15.27, ["Fly|Ride"] = 30.17, ["Neon"] = 3.93, ["Neon|Fly"] = 28.75, ["Neon|Ride"] = 17.05, ["Neon|Fly|Ride"] = 43.32, ["Mega"] = 39.38, ["Mega|Fly"] = 127.75, ["Mega|Ride"] = 56.27, ["Mega|Fly|Ride"] = 90.96}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 406.77, ["Fly"] = 559.93, ["Ride"] = 441.83, ["Fly|Ride"] = 496.13, ["Neon|Fly|Ride"] = 1894.79, ["Mega|Fly|Ride"] = 6742.43}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 5.25, ["Fly"] = 52.5, ["Ride"] = 45.94, ["Fly|Ride"] = 113.91, ["Neon"] = 39.35, ["Neon|Ride"] = 103.11, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 403.5, ["Mega|Ride"] = 400.32, ["Mega|Fly|Ride"] = 497.13}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 15.6, ["Ride"] = 19, ["Fly|Ride"] = 33.39, ["Neon"] = 2.77, ["Neon|Fly"] = 18.11, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 34.01, ["Mega"] = 43.87, ["Mega|Ride"] = 79.85, ["Mega|Fly|Ride"] = 106.42}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 49.79, ["Ride"] = 98.24, ["Fly|Ride"] = 261.19, ["Neon"] = 205.83, ["Neon|Ride"] = 261.19, ["Neon|Fly|Ride"] = 392.43, ["Mega"] = 737.62, ["Mega|Ride"] = 761.25, ["Mega|Fly|Ride"] = 878.37}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 21.31, ["Ride"] = 15.11, ["Fly|Ride"] = 40.69, ["Neon"] = 9.41, ["Neon|Fly"] = 76.67, ["Neon|Ride"] = 28.41, ["Neon|Fly|Ride"] = 75.93, ["Mega"] = 124.69, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 204.36}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Fly|Ride"] = 196.88, ["Neon"] = 3.66, ["Neon|Fly"] = 100.08, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 75.17, ["Mega"] = 19.21, ["Mega|Ride"] = 75.59, ["Mega|Fly|Ride"] = 209.56}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 31.36, ["Fly"] = 126.95, ["Ride"] = 78.72, ["Fly|Ride"] = 213.55, ["Neon"] = 178.85, ["Neon|Ride"] = 181.91, ["Neon|Fly|Ride"] = 425.81, ["Mega"] = 752.61, ["Mega|Ride"] = 640.57, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 19.68, ["Fly|Ride"] = 146.99, ["Neon"] = 5.7, ["Neon|Ride"] = 40.46, ["Neon|Fly|Ride"] = 78.79, ["Mega"] = 32.16, ["Mega|Ride"] = 152.38, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 31.95, ["Ride"] = 85.17, ["Fly|Ride"] = 105, ["Neon"] = 148.32, ["Neon|Ride"] = 249.27, ["Neon|Fly|Ride"] = 288.46, ["Mega"] = 1759.37, ["Mega|Ride"] = 1703.19, ["Mega|Fly|Ride"] = 1333.83}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 2.1, ["Fly"] = 71.34, ["Ride"] = 131.25, ["Fly|Ride"] = 425.81, ["Neon"] = 23.09, ["Neon|Ride"] = 31.19, ["Neon|Fly|Ride"] = 497.12, ["Mega"] = 170.63, ["Mega|Ride"] = 227.81}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 71.34, ["Ride"] = 72.76, ["Neon"] = 8.64, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 431.62, ["Mega"] = 100.08, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 320.22}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 37, ["Fly"] = 142.65, ["Ride"] = 62.32, ["Fly|Ride"] = 532.25, ["Mega|Ride"] = 1703.19, ["Mega|Fly|Ride"] = 1981.01}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 515.41, ["Ride"] = 38.07, ["Neon"] = 4.96, ["Neon|Ride"] = 40.72, ["Neon|Fly|Ride"] = 114.32, ["Mega"] = 45.52, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 127.67, ["Mega|Fly|Ride"] = 227.75}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 22.24, ["Ride"] = 15.49, ["Fly|Ride"] = 102.88, ["Neon"] = 8.22, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 26.23, ["Neon|Fly|Ride"] = 63.89, ["Mega"] = 86.63, ["Mega|Fly"] = 147.53, ["Mega|Ride"] = 120.91, ["Mega|Fly|Ride"] = 219.19}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 10.05, ["Fly"] = 57.91, ["Ride"] = 32.76, ["Fly|Ride"] = 169.26, ["Neon"] = 80.05, ["Neon|Ride"] = 77.43, ["Neon|Fly|Ride"] = 144.27, ["Mega"] = 328.12, ["Mega|Ride"] = 275.62, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 7.88, ["Fly"] = 31.5, ["Ride"] = 22.32, ["Fly|Ride"] = 49.88, ["Neon"] = 72.07, ["Neon|Ride"] = 85.2, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 429.36, ["Mega|Ride"] = 401.79, ["Mega|Fly|Ride"] = 566.31}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 22.32, ["Fly"] = 28.76, ["Ride"] = 28.08, ["Fly|Ride"] = 53.34, ["Neon"] = 76.58, ["Neon|Ride"] = 81.94, ["Neon|Fly|Ride"] = 138.9, ["Mega"] = 553.55, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 447.09}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 60.37, ["Ride"] = 121.93, ["Fly|Ride"] = 259.77, ["Neon"] = 262.49, ["Neon|Ride"] = 275.22, ["Neon|Fly|Ride"] = 411.97, ["Mega"] = 1575, ["Mega|Ride"] = 1554.16, ["Mega|Fly|Ride"] = 1396.5}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 5.25, ["Ride"] = 110.62, ["Neon"] = 25.81, ["Neon|Ride"] = 112.72, ["Neon|Fly|Ride"] = 296.09, ["Mega"] = 239.08, ["Mega|Ride"] = 291.68, ["Mega|Fly|Ride"] = 469.45}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.77, ["Ride"] = 27.27, ["Fly|Ride"] = 78.74, ["Neon"] = 15.68, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 261.89, ["Mega|Ride"] = 244.13, ["Mega|Fly|Ride"] = 251.23}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 7.88, ["Fly"] = 135.19, ["Ride"] = 35.87, ["Fly|Ride"] = 160.13, ["Neon"] = 57.63, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 175.09, ["Mega"] = 314.03, ["Mega|Ride"] = 638.71, ["Mega|Fly|Ride"] = 759.94}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 14.81, ["Ride"] = 15.65, ["Fly|Ride"] = 38.36, ["Neon"] = 2.1, ["Neon|Fly"] = 21.69, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 28.66, ["Mega"] = 14.19, ["Mega|Ride"] = 26.77, ["Mega|Fly|Ride"] = 95.7}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 47.1, ["Fly"] = 225.69, ["Ride"] = 112.56, ["Fly|Ride"] = 284.23, ["Neon"] = 225.69, ["Neon|Fly"] = 2413.2, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 488.25, ["Mega"] = 1063.43, ["Mega|Ride"] = 944.99, ["Mega|Fly|Ride"] = 879.38}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 15.9, ["Fly|Ride"] = 142.65, ["Neon"] = 5.07, ["Neon|Ride"] = 44.18, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 26.25, ["Mega|Ride"] = 142.65, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.76, ["Ride"] = 19.26, ["Fly|Ride"] = 59.07, ["Neon"] = 18.38, ["Neon|Ride"] = 28.66, ["Neon|Fly|Ride"] = 80.34, ["Mega"] = 257.25, ["Mega|Ride"] = 191.9, ["Mega|Fly|Ride"] = 283.17}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 61.6, ["Ride"] = 66.94, ["Fly|Ride"] = 229.87, ["Neon"] = 203.69, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 425.81, ["Mega"] = 940.74, ["Mega|Ride"] = 992.12, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 28.42, ["Neon"] = 6.45, ["Neon|Ride"] = 52.5, ["Mega"] = 64.31, ["Mega|Ride"] = 110.06, ["Mega|Fly|Ride"] = 301.23}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 5.66}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 23, ["Fly|Ride"] = 100.08, ["Neon"] = 7.76, ["Neon|Fly"] = 32.39, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 113.91, ["Mega"] = 47.16, ["Mega|Ride"] = 97.13, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 119.69, ["Ride"] = 171.51, ["Fly|Ride"] = 348.1, ["Neon"] = 710.01, ["Neon|Ride"] = 552.72, ["Neon|Fly|Ride"] = 665.05, ["Mega"] = 6386.9, ["Mega|Ride"] = 3198.53, ["Mega|Fly|Ride"] = 2550.52}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 4.17, ["Ride"] = 36.21, ["Fly|Ride"] = 212.91, ["Neon"] = 20.48, ["Neon|Fly"] = 142.65, ["Neon|Ride"] = 63.89, ["Neon|Fly|Ride"] = 95.93, ["Mega"] = 169.46, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 26.24, ["Neon"] = 3.41, ["Neon|Ride"] = 21.09, ["Mega"] = 31.4, ["Mega|Ride"] = 57.5, ["Mega|Fly|Ride"] = 314.03}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 3.68, ["Fly"] = 39.38, ["Ride"] = 26.74, ["Fly|Ride"] = 49.88, ["Neon"] = 54.55, ["Neon|Ride"] = 89.63, ["Neon|Fly|Ride"] = 153.55, ["Mega"] = 425.81, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 637.64}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 7.84, ["Fly"] = 51.27, ["Ride"] = 21.31, ["Fly|Ride"] = 56.37, ["Neon"] = 72.18, ["Neon|Ride"] = 157.76, ["Neon|Fly|Ride"] = 309.1, ["Mega"] = 626.07, ["Mega|Ride"] = 446.16, ["Mega|Fly|Ride"] = 479.74}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 19.49, ["Ride"] = 59.06, ["Neon"] = 145.69, ["Neon|Ride"] = 182.2, ["Neon|Fly|Ride"] = 1575, ["Mega"] = 539.7, ["Mega|Ride"] = 499.8, ["Mega|Fly|Ride"] = 599.8}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 131.25, ["Fly"] = 196.77, ["Ride"] = 181.78, ["Fly|Ride"] = 224.44, ["Neon"] = 565.13, ["Neon|Fly"] = 679.72, ["Neon|Ride"] = 647.42, ["Neon|Fly|Ride"] = 515.52, ["Mega|Ride"] = 2554.77, ["Mega|Fly|Ride"] = 3238.49}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 5.58, ["Fly"] = 19.24, ["Ride"] = 14.43, ["Fly|Ride"] = 36.21, ["Neon"] = 40.85, ["Neon|Fly"] = 155.74, ["Neon|Ride"] = 39.05, ["Neon|Fly|Ride"] = 64.76, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 3.89, ["Fly"] = 131.23, ["Ride"] = 17.05, ["Fly|Ride"] = 131.24, ["Neon"] = 15.75, ["Neon|Fly"] = 42.6, ["Neon|Ride"] = 32.47, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 143.7, ["Mega|Ride"] = 166.07, ["Mega|Fly|Ride"] = 421.55}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 4.81, ["Fly"] = 41.5, ["Ride"] = 28.25, ["Fly|Ride"] = 127.75, ["Neon"] = 46.3, ["Neon|Fly"] = 128.63, ["Neon|Ride"] = 42.67, ["Neon|Fly|Ride"] = 160.67, ["Mega"] = 420, ["Mega|Ride"] = 429, ["Mega|Fly|Ride"] = 971.25}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 39.5, ["Fly"] = 100.08, ["Ride"] = 70.6, ["Fly|Ride"] = 168.2, ["Neon"] = 209.9, ["Neon|Ride"] = 197.11, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 954.19, ["Mega|Ride"] = 952.72, ["Mega|Fly|Ride"] = 1117.65}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 20.78, ["Fly"] = 57.75, ["Ride"] = 63.84, ["Neon"] = 118.13, ["Neon|Ride"] = 191.76, ["Neon|Fly|Ride"] = 469.45, ["Mega"] = 1049.9, ["Mega|Ride"] = 1695.15, ["Mega|Fly|Ride"] = 836.73}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.47, ["Ride"] = 568.45, ["Neon|Ride"] = 3197.49}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 17.06, ["Fly"] = 53.74, ["Ride"] = 30.18, ["Fly|Ride"] = 69.55, ["Neon"] = 224.18, ["Neon|Ride"] = 157.57, ["Neon|Fly|Ride"] = 264.97, ["Mega"] = 761.25, ["Mega|Ride"] = 735, ["Mega|Fly|Ride"] = 955.91}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 41.2, ["Ride"] = 13.86, ["Fly|Ride"] = 71.34, ["Neon"] = 2.1, ["Neon|Fly"] = 21.6, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 52.82, ["Mega"] = 17.07, ["Mega|Fly"] = 110.73, ["Mega|Ride"] = 39.37, ["Mega|Fly|Ride"] = 112.88}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 4.71, ["Neon"] = 7.23, ["Neon|Ride"] = 42.28, ["Neon|Fly|Ride"] = 142.65, ["Mega"] = 93.16, ["Mega|Ride"] = 164.17, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 25.99, ["Fly|Ride"] = 125.63, ["Neon"] = 13.53, ["Neon|Fly"] = 87.94, ["Neon|Ride"] = 48.55, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 133.61, ["Mega|Fly"] = 497.13, ["Mega|Ride"] = 129.93, ["Mega|Fly|Ride"] = 319.36}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 425.24, ["Fly"] = 497.13, ["Ride"] = 418.69, ["Fly|Ride"] = 510.97, ["Neon"] = 1898.49, ["Neon|Ride"] = 2041.69, ["Neon|Fly|Ride"] = 1246.88, ["Mega|Fly|Ride"] = 5445.9}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 3.93, ["Fly"] = 37.97, ["Ride"] = 15.75, ["Fly|Ride"] = 43.65, ["Neon"] = 17.1, ["Neon|Ride"] = 28.71, ["Neon|Fly|Ride"] = 52.41, ["Mega"] = 183.65, ["Mega|Ride"] = 213.94, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 6.46, ["Fly"] = 21.31, ["Ride"] = 17.73, ["Fly|Ride"] = 39.38, ["Neon"] = 20.24, ["Neon|Fly"] = 33.01, ["Neon|Ride"] = 59.62, ["Neon|Fly|Ride"] = 107.87, ["Mega"] = 128.35, ["Mega|Ride"] = 288.49, ["Mega|Fly|Ride"] = 276.94}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.63, ["Fly"] = 45.71, ["Ride"] = 21.6, ["Fly|Ride"] = 61.24, ["Neon"] = 13.12, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 107.33, ["Mega"] = 111.56, ["Mega|Ride"] = 284.23, ["Mega|Fly|Ride"] = 236.22}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 24.05, ["Fly"] = 47.85, ["Ride"] = 32.81, ["Fly|Ride"] = 65.63, ["Neon"] = 220.4, ["Neon|Ride"] = 196.85, ["Neon|Fly|Ride"] = 318.29, ["Mega"] = 560.09, ["Mega|Ride"] = 851.6, ["Mega|Fly|Ride"] = 603.58}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 53.24, ["Ride"] = 34.12, ["Fly|Ride"] = 51.85, ["Neon"] = 11.46, ["Neon|Ride"] = 32.39, ["Neon|Fly|Ride"] = 210, ["Mega"] = 163.74, ["Mega|Ride"] = 457.79, ["Mega|Fly|Ride"] = 1011.29}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 7.77, ["Fly"] = 65.6, ["Ride"] = 28.26, ["Fly|Ride"] = 72.18, ["Neon"] = 160.19, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 355.56, ["Mega|Fly|Ride"] = 1066.63}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 15.23, ["Neon"] = 5.16, ["Neon|Ride"] = 23.3, ["Mega"] = 51.19, ["Mega|Ride"] = 120.3, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 2.88, ["Ride"] = 142.65, ["Neon"] = 18, ["Mega"] = 186.31, ["Mega|Ride"] = 320.22, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 6.41, ["Ride"] = 76.67, ["Neon"] = 118.01, ["Neon|Ride"] = 284.23, ["Neon|Fly|Ride"] = 178.85, ["Mega"] = 298.07, ["Mega|Ride"] = 553.55, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 6.57, ["Fly"] = 26.01, ["Ride"] = 21.41, ["Fly|Ride"] = 36.21, ["Neon"] = 36.21, ["Neon|Fly"] = 113.91, ["Neon|Ride"] = 52.4, ["Neon|Fly|Ride"] = 104.98, ["Mega"] = 563.69, ["Mega|Ride"] = 314.03, ["Mega|Fly|Ride"] = 370.69}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 345.05, ["Fly"] = 515.23, ["Ride"] = 439.69, ["Fly|Ride"] = 429.19, ["Neon"] = 1642.41, ["Neon|Ride"] = 1743.52, ["Neon|Fly|Ride"] = 1640.63, ["Mega"] = 6798.86, ["Mega|Fly|Ride"] = 7451.38}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.74, ["Fly|Ride"] = 39.38, ["Neon"] = 15.65, ["Neon|Fly"] = 80.33, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 158.17, ["Mega"] = 227.81, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 301.04}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.92, ["Fly"] = 63.89, ["Ride"] = 51.43, ["Fly|Ride"] = 177.19, ["Neon"] = 57.28, ["Neon|Ride"] = 122.03, ["Neon|Fly|Ride"] = 185.24, ["Mega"] = 389.62, ["Mega|Fly"] = 710.01, ["Mega|Ride"] = 415.8, ["Mega|Fly|Ride"] = 531.19}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 16.69, ["Fly"] = 86.79, ["Ride"] = 80.07, ["Fly|Ride"] = 302.99, ["Neon"] = 89.36, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 424.75, ["Mega"] = 302.36, ["Mega|Ride"] = 359.63, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 52.5, ["Fly"] = 146.86, ["Ride"] = 63.89, ["Fly|Ride"] = 131.25, ["Neon"] = 320.25, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 2492.09, ["Mega|Ride"] = 1420.02}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 7.7, ["Fly"] = 106.46, ["Ride"] = 37.27, ["Fly|Ride"] = 131.24, ["Neon"] = 32.82, ["Neon|Ride"] = 122.06, ["Neon|Fly|Ride"] = 227.81, ["Mega"] = 168, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 343.05}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 21.4, ["Ride"] = 19.59, ["Fly|Ride"] = 58.46, ["Neon"] = 17.46, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 65.62, ["Mega|Ride"] = 175.11, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 3.61, ["Ride"] = 32.82, ["Neon"] = 18.38, ["Neon|Ride"] = 105.84, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 113.47, ["Mega|Fly"] = 241.65, ["Mega|Ride"] = 160.72, ["Mega|Fly|Ride"] = 277.52}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 41.49, ["Fly"] = 137.8, ["Ride"] = 83.99, ["Fly|Ride"] = 198, ["Neon"] = 98.44, ["Neon|Ride"] = 162.72, ["Neon|Fly|Ride"] = 236.24, ["Mega"] = 417.69, ["Mega|Ride"] = 432.65, ["Mega|Fly|Ride"] = 539.77}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 6.24, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 48.57, ["Mega|Ride"] = 159.11, ["Mega|Fly|Ride"] = 272.99}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 23.61, ["Ride"] = 212.91, ["Neon"] = 161.81, ["Neon|Ride"] = 401.03, ["Neon|Fly|Ride"] = 851.6, ["Mega"] = 572.31, ["Mega|Fly|Ride"] = 685.54}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 892.5, ["Fly"] = 1004.07, ["Ride"] = 917.44, ["Fly|Ride"] = 1063.13, ["Neon"] = 3511.73, ["Neon|Ride"] = 3402.09, ["Neon|Fly|Ride"] = 3281.25, ["Mega|Fly|Ride"] = 10077.45}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 13.55, ["Fly"] = 108.51, ["Ride"] = 40.15, ["Fly|Ride"] = 173.25, ["Neon"] = 64.24, ["Neon|Fly"] = 708.95, ["Neon|Ride"] = 191.85, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 340.65, ["Mega|Ride"] = 328.27, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.37, ["Ride"] = 19.71, ["Fly|Ride"] = 90.55, ["Neon"] = 9.61, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 89.86, ["Mega"] = 63, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 168.23}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 7.65, ["Ride"] = 58.97, ["Fly|Ride"] = 142.65, ["Neon"] = 57.68, ["Neon|Fly"] = 84.11, ["Neon|Fly|Ride"] = 393.73, ["Mega"] = 266.13, ["Mega|Ride"] = 411.86, ["Mega|Fly|Ride"] = 320.22}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 24.5, ["Fly|Ride"] = 185.24, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 100.08, ["Mega"] = 16.93, ["Mega|Ride"] = 43.07, ["Mega|Fly|Ride"] = 142.42}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 42.44, ["Ride"] = 98.44, ["Fly|Ride"] = 236.25, ["Neon"] = 223.12, ["Neon|Ride"] = 245.44, ["Neon|Fly|Ride"] = 394.72, ["Mega"] = 1052.19, ["Mega|Ride"] = 763.35, ["Mega|Fly|Ride"] = 913.24}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 4.8, ["Ride"] = 52.5, ["Fly|Ride"] = 278.21, ["Neon"] = 84.96, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 418.69, ["Mega|Ride"] = 777.09, ["Mega|Fly|Ride"] = 719.59}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 27.69, ["Neon"] = 7.88, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 212.91, ["Mega"] = 91.55, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 476.9}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 13.13, ["Fly"] = 52.5, ["Ride"] = 35.62, ["Fly|Ride"] = 112.85, ["Neon"] = 51.19, ["Neon|Ride"] = 86.17, ["Neon|Fly|Ride"] = 255.49, ["Mega"] = 409.17, ["Mega|Ride"] = 369.39, ["Mega|Fly|Ride"] = 391.13}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 5.79, ["Fly"] = 95.83, ["Ride"] = 26.25, ["Fly|Ride"] = 79.15, ["Neon"] = 69.5, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 144.18, ["Mega"] = 374.92, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 23.39, ["Ride"] = 91.88, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 735, ["Mega"] = 2128.97, ["Mega|Ride"] = 2398.6, ["Mega|Fly|Ride"] = 1845.83}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 3.56, ["Ride"] = 49.83, ["Fly|Ride"] = 184.11, ["Neon"] = 13.91, ["Neon|Ride"] = 84.96, ["Neon|Fly|Ride"] = 170.33, ["Mega"] = 57.63, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 227.06}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 4.8, ["Ride"] = 20.69, ["Fly|Ride"] = 47.97, ["Neon"] = 44.47, ["Neon|Fly"] = 185.24, ["Neon|Ride"] = 60.05, ["Neon|Fly|Ride"] = 91.77, ["Mega"] = 258.44, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 681.28}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 110.25, ["Fly"] = 393.75, ["Ride"] = 139.46, ["Neon"] = 433.12, ["Neon|Fly"] = 538.13, ["Neon|Ride"] = 458.07, ["Neon|Fly|Ride"] = 645.53, ["Mega|Ride"] = 2122.59, ["Mega|Fly|Ride"] = 1965.46}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 24.93, ["Ride"] = 15.4, ["Fly|Ride"] = 31.4, ["Neon"] = 11.12, ["Neon|Fly"] = 57.32, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 54.01, ["Mega"] = 145.69, ["Mega|Ride"] = 142.65, ["Mega|Fly|Ride"] = 205.19}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 13.13, ["Fly"] = 200.81, ["Ride"] = 38.07, ["Fly|Ride"] = 91.88, ["Neon"] = 65.63, ["Neon|Ride"] = 106.12, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 452.82, ["Mega|Ride"] = 498.74, ["Mega|Fly|Ride"] = 568.45}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 14.94, ["Fly|Ride"] = 52.48, ["Neon"] = 2.1, ["Neon|Fly"] = 27.93, ["Neon|Ride"] = 16.59, ["Neon|Fly|Ride"] = 45.91, ["Mega"] = 13.12, ["Mega|Fly"] = 50.38, ["Mega|Ride"] = 37.57, ["Mega|Fly|Ride"] = 78.78}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 57.5, ["Fly|Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Ride"] = 42.6, ["Neon|Fly|Ride"] = 127.75, ["Mega"] = 17.06, ["Mega|Fly"] = 118.11, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 169.25}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 36.02, ["Ride"] = 18.51, ["Fly|Ride"] = 173.25, ["Neon"] = 9.35, ["Neon|Ride"] = 55.54, ["Neon|Fly|Ride"] = 100.08, ["Mega"] = 88.69, ["Mega|Ride"] = 284.23, ["Mega|Fly|Ride"] = 246.1}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 28.25, ["Ride"] = 59.07, ["Fly|Ride"] = 131.25, ["Neon"] = 128.62, ["Neon|Ride"] = 340.65, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 511.88, ["Mega|Ride"] = 636.58}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 16.95, ["Ride"] = 15.99, ["Fly|Ride"] = 33.01, ["Neon"] = 9.34, ["Neon|Fly"] = 32.96, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 52.45, ["Mega"] = 66.8, ["Mega|Fly"] = 170.63, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 160.32}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 4.81, ["Fly"] = 25.99, ["Ride"] = 31.47, ["Fly|Ride"] = 107.66, ["Neon"] = 23.59, ["Neon|Fly"] = 71.9, ["Neon|Ride"] = 42.6, ["Neon|Fly|Ride"] = 50.05, ["Mega"] = 234.84, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 170.33, ["Mega|Fly|Ride"] = 319.15}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 27.69, ["Ride"] = 18, ["Fly|Ride"] = 67.92, ["Neon"] = 9.58, ["Neon|Fly"] = 98.43, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 89.24, ["Mega"] = 47.23, ["Mega|Fly"] = 80.37, ["Mega|Ride"] = 63.67, ["Mega|Fly|Ride"] = 126.74}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 6.76, ["Fly"] = 160.75, ["Ride"] = 23.39, ["Fly|Ride"] = 217.19, ["Neon"] = 29.87, ["Neon|Ride"] = 50.05, ["Neon|Fly|Ride"] = 284.23, ["Mega"] = 272.6, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 383.23, ["Mega|Fly|Ride"] = 409.5}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 2.6, ["Ride"] = 45.78, ["Fly|Ride"] = 104, ["Neon"] = 50.56, ["Neon|Ride"] = 142.65, ["Mega"] = 356.62, ["Mega|Ride"] = 303.19, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.68, ["Fly"] = 31.81, ["Ride"] = 15.31, ["Fly|Ride"] = 49.82, ["Neon"] = 27.61, ["Neon|Fly"] = 196.87, ["Neon|Ride"] = 39.45, ["Neon|Fly|Ride"] = 160.67, ["Mega"] = 262.5, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 264.44, ["Mega|Fly|Ride"] = 568.45}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 24.75, ["Ride"] = 16.8, ["Fly|Ride"] = 52.54, ["Neon"] = 11.46, ["Neon|Fly"] = 70.51, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 186.31, ["Mega|Ride"] = 102.37, ["Mega|Fly|Ride"] = 131.24}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 210, ["Fly"] = 393.75, ["Ride"] = 262.5, ["Fly|Ride"] = 392.43, ["Neon"] = 1246.74, ["Neon|Ride"] = 1222.9, ["Neon|Fly|Ride"] = 1174.69, ["Mega"] = 4157.96, ["Mega|Fly|Ride"] = 4479.37}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 4.35, ["Ride"] = 65.63, ["Neon"] = 21, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 425.81, ["Mega"] = 106.46, ["Mega|Ride"] = 640.43, ["Mega|Fly|Ride"] = 355.56}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.1, ["Fly"] = 106.46, ["Ride"] = 23.43, ["Fly|Ride"] = 85.17, ["Neon"] = 24.25, ["Neon|Fly"] = 241.65, ["Neon|Ride"] = 59.62, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 227.99, ["Mega|Ride"] = 194.9, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 2.56, ["Fly|Ride"] = 212.91, ["Neon"] = 37.16, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 603.74, ["Mega"] = 479.73, ["Mega|Ride"] = 400.57, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 15.49, ["Ride"] = 15.42, ["Fly|Ride"] = 32.45, ["Neon"] = 2.1, ["Neon|Fly"] = 42.6, ["Neon|Ride"] = 19.18, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 18.21, ["Mega|Fly"] = 78.79, ["Mega|Ride"] = 41.99, ["Mega|Fly|Ride"] = 72.19}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 42.37, ["Ride"] = 17.75, ["Fly|Ride"] = 45.59, ["Neon"] = 14.04, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 81.84, ["Mega"] = 132.57, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 213.94}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.1, ["Ride"] = 119.85, ["Neon"] = 8.67, ["Neon|Ride"] = 283.17, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 44.63, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 276.94}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 65.62, ["Fly"] = 93.19, ["Ride"] = 78.74, ["Fly|Ride"] = 183.1, ["Neon"] = 328.13, ["Neon|Fly"] = 473.53, ["Neon|Ride"] = 409.49, ["Neon|Fly|Ride"] = 426.57, ["Mega|Ride"] = 3550.05, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 2.99, ["Fly"] = 71.34, ["Ride"] = 26.24, ["Fly|Ride"] = 141.73, ["Neon"] = 27.57, ["Neon|Ride"] = 66.94, ["Mega"] = 168, ["Mega|Ride"] = 224.93, ["Mega|Fly|Ride"] = 355.56}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 48.99, ["Ride"] = 34.12, ["Neon"] = 6.39, ["Neon|Ride"] = 80.34, ["Neon|Fly|Ride"] = 537.86, ["Mega"] = 66.94, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 45.05, ["Fly"] = 160.68, ["Ride"] = 77.87, ["Fly|Ride"] = 188.11, ["Neon"] = 144.38, ["Neon|Ride"] = 162.56, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 538.12, ["Mega|Ride"] = 551.25, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 28.74, ["Ride"] = 13.74, ["Fly|Ride"] = 32.85, ["Neon"] = 2.1, ["Neon|Fly"] = 22.3, ["Neon|Ride"] = 15.59, ["Neon|Fly|Ride"] = 26.25, ["Mega"] = 20.22, ["Mega|Fly"] = 45.49, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 92.63}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 33.38, ["Neon"] = 3.67, ["Neon|Ride"] = 31.77, ["Neon|Fly|Ride"] = 285.33, ["Mega"] = 23.52, ["Mega|Ride"] = 77.85, ["Mega|Fly|Ride"] = 181.8}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.62, ["Ride"] = 47.86, ["Neon"] = 6.4, ["Neon|Ride"] = 108.94, ["Neon|Fly|Ride"] = 142.65, ["Mega"] = 59.07, ["Mega|Fly"] = 185.24, ["Mega|Ride"] = 114.85, ["Mega|Fly|Ride"] = 170.33}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 7.63, ["Fly"] = 88.74, ["Ride"] = 54.3, ["Fly|Ride"] = 128.35, ["Neon"] = 19.48, ["Neon|Fly"] = 135.2, ["Neon|Ride"] = 80.34, ["Neon|Fly|Ride"] = 157.57, ["Mega"] = 118.02, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 178.85, ["Mega|Fly|Ride"] = 278.92}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 20.5, ["Ride"] = 13.13, ["Fly|Ride"] = 25.17, ["Neon"] = 2.1, ["Neon|Fly"] = 24.5, ["Neon|Ride"] = 21.31, ["Neon|Fly|Ride"] = 48.61, ["Mega"] = 18.25, ["Mega|Ride"] = 66.01, ["Mega|Fly|Ride"] = 78.66}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 18.58, ["Ride"] = 52.49, ["Neon"] = 71.33, ["Neon|Fly"] = 425.81, ["Neon|Ride"] = 202.57, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 505.65, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 718.54}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2362.5, ["Fly"] = 2626.1, ["Ride"] = 2425.5, ["Fly|Ride"] = 2404.98, ["Neon|Fly|Ride"] = 7415.63, ["Mega|Fly|Ride"] = 44175.98}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 20.09, ["Ride"] = 15.75, ["Fly|Ride"] = 36.21, ["Neon"] = 6.36, ["Neon|Fly"] = 34.13, ["Neon|Ride"] = 21.31, ["Neon|Fly|Ride"] = 50.05, ["Mega"] = 70.86, ["Mega|Fly"] = 425.81, ["Mega|Ride"] = 89.4, ["Mega|Fly|Ride"] = 141.74}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Ride"] = 65.63, ["Neon"] = 8.8, ["Mega"] = 107.01, ["Mega|Fly"] = 441, ["Mega|Ride"] = 160.72, ["Mega|Fly|Ride"] = 425.81}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 11.82, ["Fly"] = 142.65, ["Ride"] = 25.65, ["Fly|Ride"] = 131.25, ["Neon"] = 79.25, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 212.91, ["Mega"] = 472.5, ["Mega|Ride"] = 399, ["Mega|Fly|Ride"] = 459.37}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 25.77, ["Fly"] = 106.46, ["Ride"] = 64.31, ["Neon"] = 142.65, ["Neon|Ride"] = 190.32, ["Mega"] = 495.46, ["Mega|Ride"] = 608.9, ["Mega|Fly|Ride"] = 701.51}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 157.49, ["Fly"] = 1420.02, ["Ride"] = 157.26, ["Fly|Ride"] = 252.8, ["Neon"] = 1197.59, ["Neon|Ride"] = 710.01, ["Neon|Fly|Ride"] = 780.94, ["Mega"] = 6386.9, ["Mega|Fly|Ride"] = 3917.31}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 7.21, ["Ride"] = 65.54, ["Fly|Ride"] = 675.94, ["Neon"] = 18.15, ["Neon|Ride"] = 85.17, ["Mega"] = 144.45, ["Mega|Fly|Ride"] = 383.23}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 36.21, ["Neon"] = 12.91, ["Neon|Ride"] = 114.85, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 245.44}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 100.08, ["Ride"] = 28.86, ["Fly|Ride"] = 131.25, ["Neon"] = 7.33, ["Neon|Fly"] = 113.91, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 210.78, ["Mega"] = 60.37, ["Mega|Ride"] = 112.85, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 8.97, ["Ride"] = 50.84, ["Fly|Ride"] = 131.25, ["Neon"] = 98.44, ["Neon|Ride"] = 175.06, ["Neon|Fly|Ride"] = 501.39, ["Mega|Ride"] = 475.12, ["Mega|Fly|Ride"] = 584.73}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 47.97, ["Mega"] = 20.25, ["Mega|Fly"] = 119.95, ["Mega|Ride"] = 79.97, ["Mega|Fly|Ride"] = 134.53}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 89.12, ["Fly"] = 160.68, ["Ride"] = 104.99, ["Fly|Ride"] = 94.5, ["Neon"] = 346.5, ["Neon|Fly"] = 455.61, ["Neon|Ride"] = 411.97, ["Neon|Fly|Ride"] = 369.64, ["Mega"] = 3193.46, ["Mega|Fly|Ride"] = 1855.32}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Fly"] = 28.76, ["Ride"] = 91.83, ["Fly|Ride"] = 51.19, ["Neon"] = 3.57, ["Neon|Ride"] = 142.65, ["Neon|Fly|Ride"] = 212.91, ["Mega"] = 71.97, ["Mega|Ride"] = 283.17, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 35.53, ["Fly"] = 142.65, ["Ride"] = 74.82, ["Fly|Ride"] = 170.63, ["Neon"] = 255.94, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 528.72, ["Mega"] = 2625, ["Mega|Ride"] = 1703.19, ["Mega|Fly|Ride"] = 1843.68}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 21.31, ["Fly|Ride"] = 51.57, ["Neon"] = 5.16, ["Neon|Fly"] = 83.93, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 47.11, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 143.75}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 9.22, ["Neon|Ride"] = 98.44, ["Mega"] = 55.99, ["Mega|Ride"] = 320.22, ["Mega|Fly|Ride"] = 532.25}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 5.69, ["Fly"] = 77.43, ["Ride"] = 28.71, ["Fly|Ride"] = 142.65, ["Neon"] = 22.32, ["Neon|Ride"] = 47.97, ["Neon|Fly|Ride"] = 142.65, ["Mega"] = 368.2, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 566.31}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 324.61, ["Fly"] = 425.81, ["Ride"] = 414.12, ["Fly|Ride"] = 492.19, ["Neon"] = 1005.86, ["Neon|Ride"] = 980.44, ["Neon|Fly|Ride"] = 1076.25, ["Mega"] = 3264.78, ["Mega|Ride"] = 2746.42, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 19.69, ["Fly"] = 71.34, ["Ride"] = 36.21, ["Fly|Ride"] = 134.51, ["Neon"] = 160.68, ["Neon|Ride"] = 235.27, ["Neon|Fly|Ride"] = 255.84, ["Mega|Ride"] = 1128.37, ["Mega|Fly|Ride"] = 1703.19}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 47.38, ["Ride"] = 16.1, ["Fly|Ride"] = 111.57, ["Neon"] = 13.22, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 28.8, ["Neon|Fly|Ride"] = 98.24, ["Mega"] = 124.69, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 314.9}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 15.25, ["Fly"] = 85.32, ["Ride"] = 57.75, ["Fly|Ride"] = 170.63, ["Neon"] = 74.82, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 288.75, ["Mega|Fly"] = 425.81, ["Mega|Ride"] = 420.49, ["Mega|Fly|Ride"] = 398.13}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 4.81, ["Ride"] = 32.82, ["Neon"] = 101.36, ["Neon|Ride"] = 122.06, ["Neon|Fly|Ride"] = 255.49, ["Mega"] = 236.25, ["Mega|Ride"] = 249.37, ["Mega|Fly|Ride"] = 425.81}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.5, ["Ride"] = 19.69, ["Neon"] = 20.98, ["Mega"] = 90.55, ["Mega|Ride"] = 286.64, ["Mega|Fly|Ride"] = 411.97}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 71.34, ["Ride"] = 15.41, ["Fly|Ride"] = 65.51, ["Neon"] = 38.98, ["Neon|Fly"] = 79.85, ["Neon|Ride"] = 50.16, ["Neon|Fly|Ride"] = 212.14, ["Mega"] = 160.13, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 84.32, ["Ride"] = 105, ["Fly|Ride"] = 160.68, ["Neon"] = 795.18, ["Neon|Ride"] = 523.68, ["Neon|Fly|Ride"] = 568.45, ["Mega"] = 2887.5, ["Mega|Ride"] = 2625, ["Mega|Fly|Ride"] = 3198.53}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 24.93, ["Ride"] = 38.98, ["Fly|Ride"] = 91.88, ["Neon"] = 154.88, ["Neon|Ride"] = 189, ["Neon|Fly|Ride"] = 284.23, ["Mega"] = 1000.12, ["Mega|Ride"] = 731.32, ["Mega|Fly|Ride"] = 731.07}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2034.38, ["Fly"] = 2058.97, ["Ride"] = 2034.38, ["Fly|Ride"] = 2040.94, ["Neon"] = 11354.83, ["Neon|Fly|Ride"] = 7019.25, ["Mega|Fly|Ride"] = 22311.19}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.86, ["Fly"] = 65625, ["Ride"] = 57.5, ["Fly|Ride"] = 196.87, ["Neon"] = 13.94, ["Mega"] = 115.31, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 186.88, ["Mega|Fly|Ride"] = 459.37}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 6.34, ["Ride"] = 42, ["Fly|Ride"] = 131.25, ["Neon"] = 30.36, ["Neon|Ride"] = 83.34, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 146.3, ["Mega|Fly"] = 270.39, ["Mega|Ride"] = 143.09, ["Mega|Fly|Ride"] = 195.69}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 826.87, ["Fly"] = 1476.45, ["Ride"] = 824.15, ["Fly|Ride"] = 866.25, ["Neon"] = 2778.57, ["Neon|Ride"] = 2531.18, ["Neon|Fly|Ride"] = 2469.86, ["Mega|Fly|Ride"] = 11353.71}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 19.21, ["Ride"] = 50.68, ["Fly|Ride"] = 173.35, ["Neon"] = 212.91, ["Neon|Ride"] = 226.31, ["Neon|Fly|Ride"] = 369.39, ["Mega"] = 838.31, ["Mega|Ride"] = 710.01, ["Mega|Fly|Ride"] = 791.99}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.1, ["Ride"] = 23.43, ["Fly|Ride"] = 127.98, ["Neon"] = 7.51, ["Neon|Ride"] = 42.6, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 142.65, ["Mega|Ride"] = 320.22, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 142.65, ["Neon"] = 5.2, ["Neon|Ride"] = 27.26, ["Neon|Fly|Ride"] = 104.33, ["Mega"] = 22.31, ["Mega|Ride"] = 61.31, ["Mega|Fly|Ride"] = 157.4}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 98.43, ["Ride"] = 130.69, ["Fly|Ride"] = 170.63, ["Neon"] = 459.38, ["Neon|Ride"] = 433.13, ["Neon|Fly|Ride"] = 634.45, ["Mega"] = 2398.6, ["Mega|Fly|Ride"] = 2128.97}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.62, ["Ride"] = 33.67, ["Fly|Ride"] = 74.03, ["Neon"] = 10.48, ["Neon|Ride"] = 47.96, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 109.28, ["Mega|Ride"] = 122.05, ["Mega|Fly|Ride"] = 263.82}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 66.94, ["Fly"] = 106.46, ["Ride"] = 126, ["Fly|Ride"] = 241.65, ["Neon"] = 425.81, ["Neon|Ride"] = 568.45, ["Mega|Fly|Ride"] = 1729.39}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 7.21, ["Fly"] = 105, ["Fly|Ride"] = 127.75, ["Neon"] = 35.44, ["Neon|Fly|Ride"] = 269.06, ["Mega"] = 328.02, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 234.81, ["Ride"] = 285.93, ["Fly|Ride"] = 320.25, ["Neon"] = 1137.32, ["Neon|Ride"] = 1064.49, ["Neon|Fly|Ride"] = 879.25, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.94, ["Fly"] = 91.88, ["Ride"] = 17.05, ["Fly|Ride"] = 25.56, ["Neon"] = 20.69, ["Neon|Ride"] = 55.12, ["Neon|Fly|Ride"] = 112.88, ["Mega"] = 320.22, ["Mega|Ride"] = 225.02, ["Mega|Fly|Ride"] = 265.4}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 17.97, ["Ride"] = 15.08, ["Fly|Ride"] = 33.38, ["Neon"] = 3.56, ["Neon|Fly"] = 20.24, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 57.5, ["Mega"] = 38.07, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 124.7}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1273.65, ["Ride"] = 1050, ["Fly|Ride"] = 1254.2, ["Neon|Ride"] = 7806.92, ["Neon|Fly|Ride"] = 6599.79, ["Mega"] = 23985.84, ["Mega|Fly|Ride"] = 28386.53}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 8.54, ["Fly"] = 994.24, ["Ride"] = 72.19, ["Neon"] = 82.6, ["Neon|Ride"] = 128.29, ["Mega"] = 249.57, ["Mega|Ride"] = 313.69, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 7.21, ["Fly"] = 39.38, ["Ride"] = 34.35, ["Fly|Ride"] = 124.77, ["Neon"] = 23.43, ["Neon|Fly"] = 284.23, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 102.38, ["Mega"] = 140.84, ["Mega|Ride"] = 264.01, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 27.33, ["Fly"] = 39.37, ["Ride"] = 33.01, ["Fly|Ride"] = 57.5, ["Neon"] = 212.91, ["Neon|Ride"] = 209.9, ["Neon|Fly|Ride"] = 212.62, ["Mega"] = 2554.77, ["Mega|Ride"] = 1120.16, ["Mega|Fly|Ride"] = 799.32}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 12.87, ["Fly"] = 70.27, ["Ride"] = 23.63, ["Fly|Ride"] = 78.75, ["Neon"] = 58.46, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 168.95, ["Mega"] = 367.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 429.99}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 50.8, ["Ride"] = 155.43, ["Fly|Ride"] = 497.13, ["Neon"] = 209.9, ["Neon|Fly"] = 318.29, ["Neon|Ride"] = 276.78, ["Neon|Fly|Ride"] = 411.97, ["Mega"] = 1021.92, ["Mega|Ride"] = 919.73, ["Mega|Fly|Ride"] = 952.72}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Fly|Ride"] = 284.23, ["Neon"] = 3.63, ["Neon|Fly"] = 57.5, ["Neon|Ride"] = 112.72, ["Neon|Fly|Ride"] = 106.77, ["Mega"] = 15.99, ["Mega|Fly"] = 72.19, ["Mega|Ride"] = 142.65, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 71.73, ["Fly"] = 128.63, ["Ride"] = 88.08, ["Fly|Ride"] = 177.18, ["Neon"] = 421.61, ["Neon|Fly"] = 559.84, ["Neon|Ride"] = 316.08, ["Neon|Fly|Ride"] = 479.55, ["Mega"] = 3406.35, ["Mega|Fly|Ride"] = 1715.15}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 107.62, ["Ride"] = 19.44, ["Fly|Ride"] = 66.68, ["Neon"] = 142.65, ["Neon|Ride"] = 95.93, ["Mega"] = 773.07, ["Mega|Ride"] = 431.76, ["Mega|Fly|Ride"] = 490.88}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 28.76, ["Ride"] = 15.99, ["Fly|Ride"] = 38.16, ["Neon"] = 20.24, ["Neon|Fly"] = 80.33, ["Neon|Ride"] = 83.05, ["Neon|Fly|Ride"] = 122.85, ["Mega"] = 104.35, ["Mega|Ride"] = 275.07, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 3.84, ["Ride"] = 126, ["Neon"] = 15.99, ["Neon|Fly"] = 140.53, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 202.27, ["Mega|Fly|Ride"] = 479.74}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 55.99, ["Ride"] = 194.91, ["Fly|Ride"] = 354.9, ["Neon"] = 366.19, ["Neon|Ride"] = 360.94, ["Neon|Fly|Ride"] = 727.13, ["Mega"] = 1483.91, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1417.5}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 3.47, ["Fly|Ride"] = 425.81, ["Neon"] = 18.69, ["Neon|Ride"] = 59.07, ["Mega"] = 126.88, ["Mega|Ride"] = 160.72, ["Mega|Fly|Ride"] = 279.97}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Fly"] = 21.31, ["Ride"] = 36.66, ["Neon"] = 2.1, ["Neon|Ride"] = 117.51, ["Neon|Fly|Ride"] = 57.5, ["Mega"] = 16.93, ["Mega|Ride"] = 196.24, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.92, ["Ride"] = 32.82, ["Fly|Ride"] = 142.65, ["Neon"] = 3.84, ["Neon|Fly"] = 86.2, ["Neon|Ride"] = 20.13, ["Neon|Fly|Ride"] = 131.23, ["Mega"] = 19.4, ["Mega|Ride"] = 61.77, ["Mega|Fly|Ride"] = 137.17}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 24.5, ["Ride"] = 16.04, ["Fly|Ride"] = 52.41, ["Neon"] = 4.81, ["Neon|Ride"] = 24.69, ["Neon|Fly|Ride"] = 47.97, ["Mega"] = 61.69, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 179.7}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 113.91, ["Neon"] = 24.35, ["Neon|Ride"] = 65.63, ["Mega"] = 118.1, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Ride"] = 14.12, ["Fly|Ride"] = 36.74, ["Neon"] = 9.98, ["Neon|Fly"] = 212.82, ["Neon|Ride"] = 31.95, ["Neon|Fly|Ride"] = 100.08, ["Mega"] = 170.63, ["Mega|Ride"] = 141.46, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 51.11, ["Ride"] = 102.37, ["Fly|Ride"] = 284.23, ["Neon"] = 216.57, ["Neon|Ride"] = 324.07, ["Neon|Fly|Ride"] = 1064.49, ["Mega"] = 743.57, ["Mega|Ride"] = 850.54, ["Mega|Fly|Ride"] = 1064.49}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 16.69, ["Ride"] = 15.89, ["Fly|Ride"] = 40.46, ["Neon"] = 2.1, ["Neon|Fly"] = 20.41, ["Neon|Ride"] = 20.24, ["Neon|Fly|Ride"] = 42.72, ["Mega"] = 51.19, ["Mega|Ride"] = 131.08, ["Mega|Fly|Ride"] = 95.82}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 6.55, ["Fly"] = 27.69, ["Ride"] = 19.7, ["Fly|Ride"] = 74.39, ["Neon"] = 20.55, ["Neon|Fly"] = 91.76, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 98.4, ["Mega"] = 301.88, ["Mega|Fly"] = 332.13, ["Mega|Ride"] = 327.92, ["Mega|Fly|Ride"] = 312.36}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 16.86, ["Fly"] = 63.31, ["Ride"] = 40.53, ["Fly|Ride"] = 42.6, ["Neon"] = 71.46, ["Neon|Fly"] = 147, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 209.99, ["Mega"] = 787.5, ["Mega|Ride"] = 781.35, ["Mega|Fly|Ride"] = 514.56}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.55, ["Fly"] = 196.88, ["Neon"] = 74.8, ["Neon|Ride"] = 103.69, ["Mega"] = 420, ["Mega|Ride"] = 448.28, ["Mega|Fly|Ride"] = 539.7}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.28, ["Ride"] = 15.99, ["Fly|Ride"] = 40.46, ["Neon"] = 6.4, ["Neon|Fly"] = 28.1, ["Neon|Ride"] = 21.2, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 40.46, ["Mega|Ride"] = 58.45, ["Mega|Fly|Ride"] = 114.19}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 6.46, ["Fly"] = 39.37, ["Ride"] = 38.07, ["Fly|Ride"] = 57.23, ["Neon"] = 39.29, ["Neon|Ride"] = 127.75, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 196.88, ["Mega|Fly"] = 735, ["Mega|Ride"] = 301.87, ["Mega|Fly|Ride"] = 526.94}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 992.25, ["Fly"] = 1304.48, ["Ride"] = 979.13, ["Fly|Ride"] = 972.57, ["Neon"] = 3121.07, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2218.12, ["Mega|Fly|Ride"] = 7199.06}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 142.65, ["Ride"] = 223.13, ["Fly|Ride"] = 636.41, ["Neon"] = 656.25, ["Neon|Ride"] = 853.13, ["Neon|Fly|Ride"] = 952.72, ["Mega"] = 3192.39, ["Mega|Ride"] = 3550.05, ["Mega|Fly|Ride"] = 2554.77}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly|Ride"] = 392.44, ["Neon"] = 7.05, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 254.43, ["Mega"] = 78.21, ["Mega|Fly|Ride"] = 1135.82}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 85.2, ["Ride"] = 170.33, ["Fly|Ride"] = 237.39, ["Neon"] = 472.78, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 752.35, ["Mega"] = 1967.44, ["Mega|Ride"] = 1916.09, ["Mega|Fly|Ride"] = 1890}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.1, ["Ride"] = 20.65, ["Fly|Ride"] = 98.44, ["Neon"] = 15.1, ["Neon|Fly"] = 56.37, ["Neon|Ride"] = 54.3, ["Neon|Fly|Ride"] = 284.23, ["Mega"] = 140.53, ["Mega|Ride"] = 170.33, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 225.08, ["Fly"] = 425.81, ["Ride"] = 260.59, ["Fly|Ride"] = 363.42, ["Neon"] = 1170.94, ["Neon|Ride"] = 1378.52, ["Neon|Fly|Ride"] = 1420.02}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.63, ["Fly"] = 77.18, ["Ride"] = 41.53, ["Fly|Ride"] = 216.16, ["Neon"] = 23.9, ["Neon|Ride"] = 54.37, ["Mega"] = 239.88, ["Mega|Fly"] = 356.62, ["Mega|Ride"] = 425.81}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Fly"] = 28.76, ["Ride"] = 19.18, ["Neon"] = 43.64, ["Mega"] = 164.07, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 17.99, ["Ride"] = 28.76, ["Fly|Ride"] = 152.29, ["Neon"] = 105, ["Neon|Fly"] = 425.81, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 239.79, ["Mega"] = 532.25, ["Mega|Ride"] = 590.81, ["Mega|Fly|Ride"] = 895.89}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.75, ["Neon"] = 26.25, ["Neon|Ride"] = 196.87, ["Mega"] = 239.88, ["Mega|Ride"] = 254.61, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 11.72, ["Fly|Ride"] = 32.15, ["Neon"] = 2.1, ["Neon|Fly"] = 28.76, ["Neon|Ride"] = 26.23, ["Neon|Fly|Ride"] = 23.63, ["Mega"] = 23.84, ["Mega|Ride"] = 40.46, ["Mega|Fly|Ride"] = 64.55}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4725, ["Ride"] = 4461.19, ["Fly|Ride"] = 5250, ["Neon"] = 31934.45, ["Neon|Fly|Ride"] = 21148.07, ["Mega|Fly|Ride"] = 52500}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 5.24, ["Fly"] = 85.17, ["Ride"] = 41.91, ["Neon"] = 78.63, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 183.4, ["Mega|Ride"] = 214.55, ["Mega|Fly|Ride"] = 411.97}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.7, ["Ride"] = 20.13, ["Fly|Ride"] = 45.94, ["Neon"] = 11.34, ["Neon|Fly"] = 42.6, ["Neon|Ride"] = 36.31, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 131.25, ["Mega|Ride"] = 125.56, ["Mega|Fly|Ride"] = 212.91}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 406.48, ["Fly"] = 547.77, ["Ride"] = 459.38, ["Fly|Ride"] = 538.13, ["Neon"] = 2099.99, ["Neon|Ride"] = 1292.82, ["Neon|Fly|Ride"] = 1361.88, ["Mega|Fly|Ride"] = 4873.32}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 3.4, ["Ride"] = 41.15, ["Neon"] = 14.4, ["Mega"] = 143.88, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 2.1, ["Fly"] = 4256.88, ["Ride"] = 36.21, ["Neon"] = 31.95, ["Neon|Fly"] = 118.17, ["Neon|Ride"] = 64.76, ["Neon|Fly|Ride"] = 305.52, ["Mega"] = 424.75, ["Mega|Ride"] = 284.67, ["Mega|Fly|Ride"] = 497.13}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 50.96, ["Ride"] = 23.99, ["Fly|Ride"] = 47.97, ["Neon"] = 4.94, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 28.76, ["Neon|Fly|Ride"] = 91.74, ["Mega"] = 39.03, ["Mega|Ride"] = 55.53, ["Mega|Fly|Ride"] = 130.95}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 611.02, ["Ride"] = 612.92, ["Fly|Ride"] = 654.88, ["Neon|Ride"] = 2126.27, ["Neon|Fly|Ride"] = 2135.44, ["Mega|Fly|Ride"] = 9225.88}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 8.31, ["Fly"] = 210, ["Ride"] = 65.44, ["Neon"] = 27.56, ["Neon|Fly"] = 113.91, ["Neon|Ride"] = 85.3, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 191.63, ["Mega|Ride"] = 221.82, ["Mega|Fly|Ride"] = 424.01}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 3.55, ["Fly"] = 236.15, ["Ride"] = 45.21, ["Fly|Ride"] = 76.67, ["Neon"] = 19.69, ["Neon|Ride"] = 60.1, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 157.38, ["Mega|Fly"] = 799.95, ["Mega|Ride"] = 160.13, ["Mega|Fly|Ride"] = 270.39}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.13, ["Ride"] = 15.8, ["Fly|Ride"] = 43.31, ["Neon"] = 17.74, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 28.76, ["Neon|Fly|Ride"] = 82.58, ["Mega"] = 284.23, ["Mega|Ride"] = 153.3, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 19.67, ["Fly"] = 26.25, ["Ride"] = 34.13, ["Fly|Ride"] = 58.53, ["Neon"] = 117.59, ["Mega"] = 526.94, ["Mega|Ride"] = 472.49, ["Mega|Fly|Ride"] = 549.29}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 42.88, ["Neon"] = 3.83, ["Neon|Ride"] = 140.53, ["Neon|Fly|Ride"] = 106.46, ["Mega"] = 27.95, ["Mega|Fly"] = 127.75, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 170.33}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 590.63, ["Fly"] = 683.42, ["Ride"] = 576.06, ["Fly|Ride"] = 630, ["Neon"] = 2589.57, ["Neon|Fly|Ride"] = 2100, ["Mega|Ride"] = 9354.49, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 100.08, ["Neon"] = 17.07, ["Neon|Ride"] = 63.89, ["Neon|Fly|Ride"] = 444.97, ["Mega"] = 85.32, ["Mega|Ride"] = 305.52, ["Mega|Fly|Ride"] = 314.03}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 52.31, ["Neon"] = 3.56, ["Neon|Fly"] = 142.65, ["Neon|Ride"] = 76.67, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 41.96, ["Mega|Ride"] = 136.74, ["Mega|Fly|Ride"] = 284.23}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 59.77, ["Neon"] = 3.74, ["Neon|Ride"] = 56.15, ["Neon|Fly|Ride"] = 142.65, ["Mega"] = 36.75, ["Mega|Fly"] = 157.57, ["Mega|Ride"] = 124.76, ["Mega|Fly|Ride"] = 170.33}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 20.24, ["Neon|Ride"] = 48.18, ["Mega"] = 212.91, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 23.89, ["Fly"] = 65.63, ["Ride"] = 41.26, ["Fly|Ride"] = 210.33, ["Neon"] = 131.25, ["Neon|Fly"] = 212.91, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 511.88, ["Mega|Ride"] = 437.06, ["Mega|Fly|Ride"] = 556.36}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 11.47, ["Ride"] = 39.38, ["Fly|Ride"] = 142.65, ["Neon"] = 77.97, ["Neon|Ride"] = 127.63, ["Neon|Fly|Ride"] = 281.05, ["Mega"] = 476.9, ["Mega|Ride"] = 423.69, ["Mega|Fly|Ride"] = 548.46}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 32.7, ["Ride"] = 14.43, ["Fly|Ride"] = 33.51, ["Neon"] = 28.76, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 42.6, ["Mega"] = 298.6, ["Mega|Ride"] = 284.23, ["Mega|Fly|Ride"] = 319.36}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 7.73, ["Ride"] = 56.03, ["Fly|Ride"] = 134.14, ["Neon"] = 38.05, ["Neon|Ride"] = 142.65}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 26.16, ["Fly|Ride"] = 100.08, ["Neon"] = 8.53, ["Neon|Ride"] = 50.05, ["Neon|Fly|Ride"] = 121.36, ["Mega"] = 69.56, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 255.49}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 21, ["Fly"] = 112.72, ["Ride"] = 28.76, ["Fly|Ride"] = 36.21, ["Neon"] = 109.15, ["Neon|Ride"] = 142.65, ["Neon|Fly|Ride"] = 289.42, ["Mega"] = 787.5, ["Mega|Fly|Ride"] = 749.44}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 29.23, ["Fly"] = 874.13, ["Neon"] = 98.44, ["Mega"] = 332.06, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 497.13}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 36.01, ["Fly"] = 115.12, ["Ride"] = 59.06, ["Fly|Ride"] = 123.38, ["Neon"] = 324.83, ["Neon|Ride"] = 304.5, ["Neon|Fly|Ride"] = 415.8, ["Mega|Ride"] = 1759.37, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 32.36, ["Fly"] = 84.96, ["Ride"] = 52.49, ["Fly|Ride"] = 210, ["Neon"] = 118.13, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 291.38, ["Mega"] = 584.06, ["Mega|Ride"] = 638.71, ["Mega|Fly|Ride"] = 632}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 17.07, ["Ride"] = 57.5, ["Neon"] = 105, ["Neon|Ride"] = 223.12, ["Mega"] = 1050, ["Mega|Ride"] = 799.95, ["Mega|Fly|Ride"] = 803.7}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 17.07, ["Fly"] = 81.73, ["Ride"] = 63, ["Fly|Ride"] = 194.33, ["Neon"] = 137.81, ["Neon|Fly"] = 255.49, ["Neon|Ride"] = 214.3, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 579.44, ["Mega|Ride"] = 599.64, ["Mega|Fly|Ride"] = 659.99}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.95, ["Ride"] = 15.67, ["Fly|Ride"] = 32.74, ["Neon"] = 3.6, ["Neon|Fly"] = 27.36, ["Neon|Ride"] = 21.31, ["Neon|Fly|Ride"] = 54.3, ["Mega"] = 39.38, ["Mega|Fly"] = 320.22, ["Mega|Ride"] = 57.5, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 866.24}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 65.01, ["Fly"] = 479.6, ["Ride"] = 110.4, ["Fly|Ride"] = 314.03, ["Neon"] = 378, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 497.13, ["Mega"] = 1561.61, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1351.88}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 79.76, ["Neon"] = 3.15, ["Neon|Fly"] = 100.08, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 298.07, ["Mega"] = 24.94, ["Mega|Ride"] = 84.96, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 23.63, ["Ride"] = 79.26, ["Fly|Ride"] = 142.65, ["Neon"] = 84, ["Neon|Ride"] = 133.76, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 591.93, ["Mega|Ride"] = 510.46, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 2.51, ["Neon|Fly|Ride"] = 113.91, ["Mega"] = 26.25, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Ride"] = 74.82, ["Neon"] = 3.71, ["Mega"] = 20.24, ["Mega|Ride"] = 151.13, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 87.91, ["Fly"] = 223.13, ["Ride"] = 141.49, ["Fly|Ride"] = 362.11, ["Neon"] = 433.13, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 668.51, ["Mega|Ride"] = 2697.41, ["Mega|Fly|Ride"] = 2098.69}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 21.31, ["Fly|Ride"] = 95.93, ["Neon"] = 7.79, ["Neon|Fly"] = 42.6, ["Neon|Ride"] = 32.25, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 90.56, ["Mega|Ride"] = 116.93, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Fly|Ride"] = 55.13, ["Neon"] = 5.02, ["Neon|Fly"] = 42.6, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 419.9, ["Mega"] = 31.5, ["Mega|Ride"] = 127.75, ["Mega|Fly|Ride"] = 217.87}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 6.28, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 236.15, ["Mega"] = 110.23, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 539.7}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 90.3, ["Neon"] = 3.68, ["Neon|Ride"] = 156.19, ["Mega"] = 90.56, ["Mega|Fly"] = 195.88, ["Mega|Ride"] = 335.82, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 70.88, ["Ride"] = 160.13, ["Fly|Ride"] = 355.56, ["Neon"] = 437.07, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2413.2, ["Mega|Ride"] = 2158.74, ["Mega|Fly|Ride"] = 2171.55}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.94, ["Ride"] = 80.79, ["Neon"] = 90.8, ["Neon|Ride"] = 77.43, ["Mega"] = 413.86, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 393.75, ["Ride"] = 421.19, ["Fly|Ride"] = 710.01, ["Neon"] = 1758.89, ["Neon|Ride"] = 1420.02, ["Neon|Fly|Ride"] = 1102.5, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 97.12}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 52.5}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 15.75}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 10.5}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 142.65}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 116.79}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 14.25}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 7.33}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 110.97}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 14.86}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 35.15}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 18.36}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 6.16}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 839.99}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 5.03}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 6.17}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 7.77}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 3.94}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 15.23}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 590.63}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 605.3}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 9.19}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1403.07}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 52.4}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 9.18}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 34.13}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 17.07}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 45.55}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 52.13}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 17.52}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 14.44}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 19.47}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.94}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 18.64}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 3.93}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.24}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 20.99}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 14.23}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.11}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 3051.88}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 43.95}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 311.84}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 6.36}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 12.79}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 45.94}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 213.86}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 7.63}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 11.8}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 144.38}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 24.94}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 7.23}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 22.32}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 11.21}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 99.75}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 27.56}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 7.33}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 19.68}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 6.46}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 6.4}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 28.88}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 78.75}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 236.24}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 5.24}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 7.54}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 18.38}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.86}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 61.07}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 19.5}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 23865.73}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 72.19}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 45.94}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 37.7}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 26.17}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 39.38}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 24.94}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 31.97}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 85.89}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 81.38}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 18.38}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 85.31}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 262.5}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 65.58}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 41.48}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 214.27}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 8.68}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 6.24}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 5.25}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 25.99}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 117.39}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 2.24}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 3.92}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 11.79}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 270.13}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 1134.76}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 7.8}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 589.11}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 6.55}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 231}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 27.24}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 91.88}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 15.94}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 28.77}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 60.39}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 14.21}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 13.13}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 7.75}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 3.94}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 2.43}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 5.53}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 32.68}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 4.47}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.1}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.5}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 16.17}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 146.98}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 51.54}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.63}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 212.91}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 15.73}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 9.19}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 7.49}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 27.57}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 7.75}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 3.59}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 8.93}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 3.93}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 5.97}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 27.49}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 15.74}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 5.75}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 2.97}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 5.78}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 6.36}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 11.78}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 2.27}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 3.19}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 3.84}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.19}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 6.29}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 9367.45}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 11.46}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 4.6}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 52.5}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 6.47}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 7.55}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 5.16}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 40.17}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 6.45}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.41}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 2.46}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.12}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4116.36}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 6.35}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 34.39}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.3}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.24}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 59.22}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 5.25}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 105}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 15.22}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 5.25}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 10.39}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 24.86}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.15}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 6.36}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.93}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 5.15}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.49}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 3.85}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 3.93}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 19.17}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 4.86}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 11.1}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 120.52}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 79.71}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 9.1}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1213.95}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 49.87}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 5.25}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 25.99}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 24.65}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 4.98}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 7.87}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 13.9}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 26.24}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 12.5}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 2.1}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.38}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 11.43}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.13}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 20.89}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 22.32}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 3.1}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 7.88}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 58.75}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 3.94}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 136.5}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 91.86}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 10.75}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 4.13}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 22.31}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 212.16}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 6.07}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.63}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 4.9}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 72.01}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 157.5}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 10.17}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1199.27}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.52}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 196.88}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 6.09}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 5.2}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 59.31}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 6.23}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.54}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 106.46}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 17.05}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 17.35}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 5.53}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 54.49}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 71.34}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 49.87}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.63}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 3.94}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 36.63}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 129.57}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 82.69}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 8.05}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 57.61}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.43}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 62.89}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 48.56}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 102.18}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.63}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 59.42}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 6.57}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 127.93}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.52}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.63}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 31.49}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 57.41}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 61.69}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 2.63}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 8.66}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 13.01}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 74.5}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 57.65}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 14.18}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 32.29}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 23.12}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 12.71}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 78.73}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 47.14}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 22.32}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1994.99}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 6.41}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 7.63}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 19.68}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 320.22}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 17.31}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 9.19}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 6.25}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 7.55}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 6.56}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 318.93}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 57.21}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 47.25}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 4.81}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 55.13}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 194.91}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 77.41}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 918.75}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 150.94}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 8.49}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1727.25}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 551.24}},
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