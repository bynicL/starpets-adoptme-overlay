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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1196.37, ["Ride"] = 1050, ["Fly|Ride"] = 1491.18, ["Neon"] = 6741.35, ["Neon|Fly|Ride"] = 12603.94, ["Mega"] = 21366.07, ["Mega|Fly|Ride"] = 21366.07}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 433.13, ["Fly"] = 525, ["Ride"] = 536.82, ["Fly|Ride"] = 567.23, ["Neon|Fly|Ride"] = 1706.25, ["Mega"] = 10683.04, ["Mega|Fly|Ride"] = 7545.43}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 6040.54, ["Ride"] = 5250, ["Fly|Ride"] = 4987.5, ["Neon|Fly|Ride"] = 17850, ["Mega|Fly|Ride"] = 71220.57}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 170.62, ["Ride"] = 284.82, ["Fly|Ride"] = 313.01, ["Neon"] = 1055.38, ["Neon|Ride"] = 1055.38, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 4725}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 513.19, ["Fly"] = 650.09, ["Ride"] = 564.38, ["Fly|Ride"] = 525, ["Neon|Fly|Ride"] = 1884.81, ["Mega|Fly|Ride"] = 8505.94}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 10.18, ["Ride"] = 58.46, ["Fly|Ride"] = 129.94, ["Neon"] = 72.19, ["Neon|Fly"] = 285.22, ["Neon|Ride"] = 95.85, ["Neon|Fly|Ride"] = 320.51, ["Mega"] = 353.75, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 595.81}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 6.48, ["Fly"] = 43.31, ["Ride"] = 27.2, ["Fly|Ride"] = 79.9, ["Neon"] = 40.69, ["Neon|Fly"] = 72.19, ["Neon|Ride"] = 60.37, ["Neon|Fly|Ride"] = 131.43, ["Mega"] = 207.38, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 367.52}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 124.69, ["Ride"] = 141.75, ["Fly|Ride"] = 241.42, ["Neon"] = 568.29, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 698.69, ["Mega"] = 1586.82, ["Mega|Ride"] = 2492.44, ["Mega|Fly|Ride"] = 2849.18}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 38.05, ["Fly"] = 83.62, ["Ride"] = 46.18, ["Fly|Ride"] = 108.94, ["Neon"] = 275.63, ["Neon|Ride"] = 183.73, ["Neon|Fly|Ride"] = 308.15, ["Mega"] = 2100, ["Mega|Ride"] = 1174.08, ["Mega|Fly|Ride"] = 967.29}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 19.57, ["Fly"] = 46.97, ["Ride"] = 35.44, ["Fly|Ride"] = 71.45, ["Neon|Ride"] = 136.5, ["Neon|Fly|Ride"] = 206.07, ["Mega|Ride"] = 741.3, ["Mega|Fly|Ride"] = 854.65}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 64.97, ["Fly"] = 128.2, ["Ride"] = 102, ["Fly|Ride"] = 175.88, ["Neon"] = 384.65, ["Neon|Ride"] = 320.25, ["Neon|Fly|Ride"] = 414.52, ["Mega|Fly|Ride"] = 1268.09}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 65.63}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 347.61, ["Fly"] = 341.25, ["Ride"] = 337.82, ["Fly|Ride"] = 361.16, ["Neon|Ride"] = 1048.69, ["Neon|Fly|Ride"] = 1181.24, ["Mega|Fly|Ride"] = 5068.04}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 129.5, ["Fly"] = 143.15, ["Ride"] = 144.19, ["Fly|Ride"] = 177.09, ["Neon|Fly"] = 625.91, ["Neon|Ride"] = 573.03, ["Neon|Fly|Ride"] = 536.82, ["Mega"] = 4312.63, ["Mega|Fly|Ride"] = 2467.5}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.6, ["Ride"] = 32.82, ["Fly|Ride"] = 131.25, ["Neon"] = 23.93, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 202.73, ["Mega"] = 157.5, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 342.01}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 199.5, ["Fly"] = 287.44, ["Ride"] = 196.86, ["Fly|Ride"] = 262.48, ["Neon|Ride"] = 961.37, ["Neon|Fly|Ride"] = 708.65, ["Mega|Fly|Ride"] = 2749.69}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.63, ["Fly"] = 26.65, ["Ride"] = 17.8, ["Fly|Ride"] = 52.48, ["Neon"] = 28.86, ["Neon|Fly"] = 80.66, ["Neon|Ride"] = 57.69, ["Neon|Fly|Ride"] = 105, ["Mega"] = 178.5, ["Mega|Ride"] = 321.39, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 103.55, ["Fly"] = 285.22, ["Ride"] = 127.32, ["Fly|Ride"] = 286.79, ["Neon"] = 433.13, ["Neon|Ride"] = 288.46, ["Neon|Fly|Ride"] = 553.62, ["Mega"] = 1709.08, ["Mega|Ride"] = 1481.75, ["Mega|Fly|Ride"] = 1501.5}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 39.38}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 77.44, ["Ride"] = 232.32, ["Fly|Ride"] = 244.02, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 2136.62, ["Mega|Fly|Ride"] = 4495.51}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 26.12, ["Fly"] = 55.57, ["Ride"] = 43.31, ["Fly|Ride"] = 433.13, ["Neon"] = 241.5, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 327.98, ["Mega"] = 426.27, ["Mega|Ride"] = 994.61, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 32.44, ["Fly"] = 78.75, ["Ride"] = 62.99, ["Fly|Ride"] = 104.9, ["Neon"] = 321.43, ["Neon|Ride"] = 215.59, ["Neon|Fly|Ride"] = 261.11, ["Mega"] = 1685.08, ["Mega|Ride"] = 1425.14, ["Mega|Fly|Ride"] = 958.56}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 42, ["Fly"] = 244.63, ["Ride"] = 80.67, ["Fly|Ride"] = 196.88, ["Neon"] = 185.88, ["Neon|Ride"] = 392.39, ["Neon|Fly|Ride"] = 519.75, ["Mega"] = 1967.44, ["Mega|Ride"] = 1335.39, ["Mega|Fly|Ride"] = 1536.24}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 19.48, ["Ride"] = 35.18, ["Fly|Ride"] = 100.43, ["Neon"] = 210, ["Neon|Ride"] = 213.65, ["Neon|Fly|Ride"] = 173.25, ["Mega"] = 1207.92, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 40.5, ["Fly"] = 64.11, ["Ride"] = 80.67, ["Fly|Ride"] = 129.94, ["Neon"] = 325.5, ["Neon|Fly"] = 402.02, ["Neon|Ride"] = 372.21, ["Neon|Fly|Ride"] = 322.88, ["Mega|Ride"] = 3204.92, ["Mega|Fly|Ride"] = 1039.5}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 9.19, ["Fly"] = 34.02, ["Ride"] = 24.59, ["Fly|Ride"] = 65.2, ["Neon"] = 39.29, ["Neon|Fly"] = 186.6, ["Neon|Ride"] = 49.87, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 177.74, ["Mega|Fly"] = 274.32, ["Mega|Ride"] = 182.44, ["Mega|Fly|Ride"] = 344.97}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 395.01, ["Ride"] = 416.07, ["Fly|Ride"] = 452.81, ["Neon"] = 2094.71, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1966.13, ["Mega"] = 10683.04, ["Mega|Fly|Ride"] = 9549.47}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 15.7, ["Ride"] = 32.81, ["Fly|Ride"] = 65.63, ["Neon"] = 219.18, ["Mega|Ride"] = 805.52, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 7.88, ["Fly"] = 61.85, ["Ride"] = 21.84, ["Fly|Ride"] = 53.82, ["Neon"] = 59.07, ["Neon|Ride"] = 70.97, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 320.25, ["Mega|Ride"] = 327.93, ["Mega|Fly|Ride"] = 378.38}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 78.92, ["Fly"] = 118.58, ["Ride"] = 89.25, ["Fly|Ride"] = 135.19, ["Neon"] = 323.65, ["Neon|Ride"] = 354.26, ["Neon|Fly|Ride"] = 400.32, ["Mega"] = 6377.96, ["Mega|Ride"] = 5832.75, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 11.82, ["Ride"] = 36.03, ["Fly|Ride"] = 75.86, ["Neon"] = 137.82, ["Neon|Ride"] = 113.15, ["Neon|Fly|Ride"] = 203.34, ["Mega"] = 712.58, ["Mega|Ride"] = 562.1, ["Mega|Fly|Ride"] = 721.11}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 209.4, ["Fly"] = 262.5, ["Ride"] = 228.36, ["Fly|Ride"] = 292.69, ["Neon"] = 570.42, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 722.18, ["Mega"] = 3417.51, ["Mega|Ride"] = 2763.52, ["Mega|Fly|Ride"] = 3262.62}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 20.72}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.11, ["Fly"] = 36.32, ["Ride"] = 28.86, ["Fly|Ride"] = 72.19, ["Neon"] = 24.92, ["Neon|Fly"] = 143.15, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 143.17, ["Mega"] = 210, ["Mega|Fly"] = 341.87, ["Mega|Ride"] = 256.44, ["Mega|Fly|Ride"] = 268.16}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 918.74, ["Fly"] = 2625, ["Ride"] = 904.99, ["Fly|Ride"] = 971.25, ["Neon"] = 6395.19, ["Neon|Ride"] = 4843.12, ["Neon|Fly|Ride"] = 4272.16, ["Mega|Ride"] = 54162.54, ["Mega|Fly|Ride"] = 18517.97}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 13.11, ["Fly"] = 60.41, ["Ride"] = 51.93, ["Fly|Ride"] = 104.7, ["Neon"] = 185.07, ["Neon|Ride"] = 185.88, ["Neon|Fly|Ride"] = 181.13, ["Mega"] = 1036.88, ["Mega|Ride"] = 1097.17, ["Mega|Fly|Ride"] = 820.31}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 245.44, ["Fly"] = 361.16, ["Ride"] = 236.25, ["Fly|Ride"] = 403.13, ["Neon"] = 787.5, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 853.13, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 38.74}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 12.93, ["Fly"] = 128.2, ["Ride"] = 64.97, ["Fly|Ride"] = 143.15, ["Neon"] = 65.62, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 356.83, ["Mega|Ride"] = 568.01, ["Mega|Fly|Ride"] = 595.81}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 106.84, ["Fly"] = 160.61, ["Ride"] = 144.27, ["Fly|Ride"] = 168.78, ["Neon"] = 639.85, ["Neon|Ride"] = 498.85, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 2222.09}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 91.87, ["Fly"] = 157.49, ["Ride"] = 111.56, ["Fly|Ride"] = 217.93, ["Neon"] = 389.34, ["Neon|Fly"] = 570.42, ["Neon|Ride"] = 434.78, ["Neon|Fly|Ride"] = 496.12, ["Mega|Ride"] = 1444.35, ["Mega|Fly|Ride"] = 1401}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 33.75}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 53.69, ["Fly"] = 58.1, ["Ride"] = 42.74, ["Fly|Ride"] = 69.55, ["Neon|Ride"] = 380.28, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 4273.23, ["Mega|Fly|Ride"] = 1350.21}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 5.25, ["Fly"] = 100.43, ["Ride"] = 45.94, ["Fly|Ride"] = 205.87, ["Neon"] = 36.75, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 126.06, ["Neon|Fly|Ride"] = 240.39, ["Mega"] = 170.63, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 276.94, ["Mega|Fly|Ride"] = 417.72}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 465.94, ["Fly"] = 692.2, ["Ride"] = 446.25, ["Fly|Ride"] = 539.42, ["Neon|Fly"] = 3845.45, ["Neon|Ride"] = 1876.88, ["Neon|Fly|Ride"] = 1857.75, ["Mega|Ride"] = 14956.26, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 111.56, ["Fly"] = 185.41, ["Ride"] = 129.94, ["Fly|Ride"] = 144.26, ["Neon"] = 420, ["Neon|Ride"] = 471.08, ["Neon|Fly|Ride"] = 584.38, ["Mega|Ride"] = 2563.95, ["Mega|Fly|Ride"] = 2296.88}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 4059.08, ["Ride"] = 3885, ["Fly|Ride"] = 3937.5, ["Neon|Fly|Ride"] = 14955.19}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 59.72, ["Fly"] = 121.78, ["Ride"] = 80.67, ["Fly|Ride"] = 169.85, ["Neon"] = 443.3, ["Neon|Ride"] = 266.87, ["Neon|Fly|Ride"] = 292.69, ["Mega"] = 2136.62, ["Mega|Ride"] = 1986, ["Mega|Fly|Ride"] = 1749.57}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 48.4, ["Ride"] = 70.88, ["Fly|Ride"] = 143.15, ["Neon"] = 575.75, ["Neon|Ride"] = 427.88, ["Neon|Fly|Ride"] = 399.56, ["Mega"] = 6267.75, ["Mega|Ride"] = 2388.75, ["Mega|Fly|Ride"] = 2213.61}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 31.5, ["Fly"] = 60.89, ["Ride"] = 42.73, ["Fly|Ride"] = 95.82, ["Neon"] = 151.72, ["Neon|Fly"] = 285.22, ["Neon|Ride"] = 136.66, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 997.82, ["Mega|Ride"] = 887.78, ["Mega|Fly|Ride"] = 577.47}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 3.93}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 54.22, ["Fly"] = 393.75, ["Ride"] = 50.64, ["Fly|Ride"] = 96.32, ["Neon|Ride"] = 285.22, ["Neon|Fly|Ride"] = 598.26, ["Mega|Ride"] = 1284.27, ["Mega|Fly|Ride"] = 1444.35}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 31.5}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 186.67, ["Ride"] = 233.89, ["Fly|Ride"] = 282.19, ["Neon"] = 963.06, ["Neon|Ride"] = 997.69, ["Neon|Fly|Ride"] = 1136.69, ["Mega|Fly|Ride"] = 4985.79}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 635.24, ["Ride"] = 643.13, ["Fly|Ride"] = 656.25, ["Neon"] = 2625, ["Neon|Fly|Ride"] = 3610.85, ["Mega|Fly|Ride"] = 11265.36}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 6.57}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 26.54, ["Fly"] = 45.94, ["Ride"] = 35.6, ["Fly|Ride"] = 75.86, ["Neon"] = 228.6, ["Neon|Fly"] = 170.92, ["Neon|Ride"] = 179.65, ["Neon|Fly|Ride"] = 218.29, ["Mega"] = 2136.62, ["Mega|Ride"] = 1155.48, ["Mega|Fly|Ride"] = 767.8}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 20.74}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 4593.75, ["Fly"] = 7121.55, ["Ride"] = 6408, ["Fly|Ride"] = 5055.7, ["Neon|Ride"] = 17654.76, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 43330.04}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 9, ["Fly"] = 55.13, ["Ride"] = 24.94, ["Fly|Ride"] = 60.38, ["Neon"] = 72.19, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 207.26, ["Mega"] = 450.95, ["Mega|Ride"] = 490.88, ["Mega|Fly|Ride"] = 459.37}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 12.5, ["Fly"] = 139.95, ["Ride"] = 28.88, ["Fly|Ride"] = 119.19, ["Neon"] = 126.06, ["Neon|Ride"] = 128.2, ["Neon|Fly|Ride"] = 262.48, ["Mega"] = 712.58, ["Mega|Ride"] = 845.04, ["Mega|Fly|Ride"] = 997.82}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 101.49, ["Ride"] = 59.07, ["Fly|Ride"] = 131.25, ["Neon|Ride"] = 396.31, ["Neon|Fly|Ride"] = 485.82, ["Mega"] = 4273.23, ["Mega|Fly|Ride"] = 1765.72}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 8.45, ["Fly"] = 71.58, ["Ride"] = 35.35, ["Fly|Ride"] = 78.75, ["Neon"] = 86.37, ["Neon|Ride"] = 148.32, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 498.91, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 800.63}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1783.69, ["Fly"] = 1978.28, ["Ride"] = 1851.93, ["Fly|Ride"] = 1653.08, ["Neon|Fly|Ride"] = 3675, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 27300, ["Fly"] = 34181.62, ["Ride"] = 35437.5, ["Fly|Ride"] = 25636.22, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 63000, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 28.7, ["Fly"] = 393.75, ["Ride"] = 57.75, ["Fly|Ride"] = 128.2, ["Neon"] = 285.22, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 570.49, ["Mega"] = 754.69, ["Mega|Ride"] = 1148.44, ["Mega|Fly|Ride"] = 1281.98}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.64, ["Fly"] = 127.79, ["Ride"] = 35.72, ["Fly|Ride"] = 164.52, ["Neon"] = 23.63, ["Neon|Fly"] = 143.15, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 164.06, ["Mega|Fly"] = 285.26, ["Mega|Ride"] = 228.37, ["Mega|Fly|Ride"] = 287.43}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 19.69}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 6.07, ["Ride"] = 49.86, ["Fly|Ride"] = 131.25, ["Neon"] = 68.25, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 277.1, ["Mega"] = 405.97, ["Mega|Ride"] = 427.33, ["Mega|Fly|Ride"] = 746.76}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 748.13, ["Fly"] = 899.26, ["Ride"] = 727.01, ["Fly|Ride"] = 787.5, ["Neon"] = 2891.56, ["Neon|Ride"] = 2819.99, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 11234.53}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 917.34, ["Fly"] = 1076.15, ["Ride"] = 984.38, ["Fly|Ride"] = 1033.92, ["Neon"] = 4130.65, ["Neon|Ride"] = 3076.36, ["Neon|Fly|Ride"] = 3109.32, ["Mega|Fly|Ride"] = 11894.5}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 12.49, ["Fly"] = 120.4, ["Ride"] = 30.32, ["Fly|Ride"] = 91.87, ["Neon"] = 85.28, ["Neon|Ride"] = 108.31, ["Neon|Fly|Ride"] = 149.27, ["Mega"] = 1214.47, ["Mega|Ride"] = 481.9, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 24.55}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 70.31, ["Fly"] = 82.31, ["Ride"] = 85.3, ["Fly|Ride"] = 126, ["Neon"] = 570.42, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 411.76, ["Mega"] = 19687.5, ["Mega|Ride"] = 1995.61, ["Mega|Fly|Ride"] = 2126.25}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 102.35, ["Ride"] = 118.79, ["Fly|Ride"] = 173.37, ["Neon"] = 369.59, ["Neon|Ride"] = 386.78, ["Neon|Fly|Ride"] = 531.93, ["Mega"] = 1417.07, ["Mega|Ride"] = 1709.3, ["Mega|Fly|Ride"] = 1925.79}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 2.63, ["Fly"] = 29.26, ["Ride"] = 23.01, ["Fly|Ride"] = 52.32, ["Neon"] = 48.57, ["Neon|Fly"] = 524.98, ["Neon|Ride"] = 79.44, ["Neon|Fly|Ride"] = 110.92, ["Mega"] = 262.5, ["Mega|Fly|Ride"] = 570.49}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 158.81, ["Fly"] = 169.47, ["Ride"] = 157.5, ["Fly|Ride"] = 250.76, ["Neon"] = 853.49, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 616.88, ["Mega"] = 5127.88, ["Mega|Ride"] = 2888.69, ["Mega|Fly|Ride"] = 2559.38}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 5.16, ["Ride"] = 40.68, ["Fly|Ride"] = 200.83, ["Neon"] = 41.96, ["Neon|Fly"] = 240.77, ["Neon|Ride"] = 124.67, ["Neon|Fly|Ride"] = 285.26, ["Mega"] = 229.48, ["Mega|Fly"] = 1137.94, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 654.93}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 10.5, ["Fly"] = 65.63, ["Ride"] = 32.81, ["Fly|Ride"] = 89.25, ["Neon"] = 120.75, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 642.75, ["Mega|Ride"] = 826.88, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 28.24, ["Ride"] = 68.24, ["Fly|Ride"] = 156.19, ["Neon"] = 199.77, ["Neon|Ride"] = 228.38, ["Mega"] = 997.5, ["Mega|Ride"] = 853.13, ["Mega|Fly|Ride"] = 1011.85}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 16.12, ["Fly"] = 57.69, ["Ride"] = 28.85, ["Fly|Ride"] = 69.81, ["Neon"] = 103.69, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 323.72, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6744.94, ["Ride"] = 5118.75, ["Fly|Ride"] = 5250, ["Neon"] = 35606.57, ["Neon|Ride"] = 28485.05, ["Neon|Fly|Ride"] = 28347.43}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 227.07, ["Fly"] = 262.5, ["Ride"] = 245.63, ["Fly|Ride"] = 282.19, ["Neon|Fly|Ride"] = 624.93, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 52.5, ["Fly"] = 161.33, ["Ride"] = 105, ["Fly|Ride"] = 157.5, ["Neon"] = 168, ["Neon|Fly"] = 164.07, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 314.99, ["Mega"] = 496.13, ["Mega|Ride"] = 581.44, ["Mega|Fly|Ride"] = 623.44}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.63, ["Fly"] = 89.1, ["Ride"] = 19.69, ["Fly|Ride"] = 81.38, ["Neon"] = 31.5, ["Neon|Fly"] = 85.46, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 499.8, ["Mega|Ride"] = 330.75, ["Mega|Fly|Ride"] = 250.69}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 65.51, ["Fly"] = 211.03, ["Ride"] = 129.11, ["Fly|Ride"] = 235.03, ["Neon"] = 210, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 391.12, ["Mega"] = 487.89, ["Mega|Ride"] = 534.18, ["Mega|Fly|Ride"] = 763.98}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 16379.41, ["Ride"] = 13415.07, ["Fly|Ride"] = 11803.31, ["Neon|Fly|Ride"] = 22903.13, ["Mega|Fly|Ride"] = 78342.95}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 282.19, ["Ride"] = 384.57, ["Fly|Ride"] = 459.38, ["Neon|Ride"] = 1563.82, ["Neon|Fly|Ride"] = 2625}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 57.16, ["Fly"] = 91.43, ["Ride"] = 72.18, ["Fly|Ride"] = 112.88, ["Neon"] = 1049.99, ["Neon|Ride"] = 328.11, ["Neon|Fly|Ride"] = 315.07, ["Mega|Fly|Ride"] = 3098.09}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 9.19, ["Ride"] = 23.12, ["Fly|Ride"] = 57.18, ["Neon"] = 61.73, ["Neon|Fly"] = 321.43, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 129.52, ["Mega"] = 393.75, ["Mega|Ride"] = 498.91, ["Mega|Fly|Ride"] = 498.91}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 393.74, ["Fly"] = 854.56, ["Ride"] = 393.75, ["Fly|Ride"] = 551.25, ["Neon"] = 1659.96, ["Neon|Ride"] = 1706.25, ["Neon|Fly|Ride"] = 1681.53, ["Mega|Fly|Ride"] = 5232.94}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 9.43, ["Ride"] = 41.94, ["Fly|Ride"] = 199.49, ["Neon"] = 32.82, ["Neon|Ride"] = 128.51, ["Neon|Fly|Ride"] = 178.42, ["Mega"] = 158.81, ["Mega|Fly"] = 263.92, ["Mega|Ride"] = 228.38, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 94.31, ["Fly"] = 167.91, ["Ride"] = 143.15, ["Fly|Ride"] = 195.55, ["Neon"] = 511.88, ["Neon|Fly"] = 525, ["Neon|Ride"] = 488.25, ["Neon|Fly|Ride"] = 523.69, ["Mega|Fly|Ride"] = 2187.69}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 10.97, ["Fly"] = 21.38, ["Ride"] = 20.14, ["Fly|Ride"] = 36.75, ["Neon"] = 114.31, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 96.84, ["Mega"] = 2563.95, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 6.57}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 66.29, ["Ride"] = 86.62, ["Fly|Ride"] = 285.22, ["Neon"] = 353.07, ["Neon|Fly"] = 426.22, ["Neon|Ride"] = 406.87, ["Neon|Fly|Ride"] = 399.56, ["Mega|Ride"] = 1993.47, ["Mega|Fly|Ride"] = 1638.79}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 11.23, ["Fly"] = 80.07, ["Ride"] = 31.5, ["Fly|Ride"] = 91.88, ["Neon"] = 98.44, ["Neon|Ride"] = 133.84, ["Neon|Fly|Ride"] = 220.07, ["Mega"] = 575.84, ["Mega|Ride"] = 577.5, ["Mega|Fly|Ride"] = 610.24}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 32.82}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 72.17, ["Fly"] = 143.15, ["Ride"] = 91.88, ["Fly|Ride"] = 131.25, ["Neon"] = 320.46, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 511.87, ["Mega|Fly|Ride"] = 1698.61}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.59, ["Ride"] = 29.23, ["Fly|Ride"] = 137.25, ["Neon"] = 25.66, ["Neon|Ride"] = 135.68, ["Neon|Fly|Ride"] = 256.41, ["Mega"] = 178.42, ["Mega|Fly|Ride"] = 449.54}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 13.13, ["Fly"] = 56.44, ["Ride"] = 37.41, ["Fly|Ride"] = 99.65, ["Neon"] = 80.67, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 199.79, ["Mega|Ride"] = 639.93, ["Mega|Fly|Ride"] = 512.8}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 431.82, ["Fly"] = 435.75, ["Ride"] = 533.01, ["Fly|Ride"] = 541.66, ["Neon|Fly|Ride"] = 2776.53, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 31.69, ["Fly"] = 106.84, ["Ride"] = 59.07, ["Fly|Ride"] = 97.71, ["Neon"] = 129.94, ["Neon|Ride"] = 143.15, ["Neon|Fly|Ride"] = 339.74, ["Mega"] = 776.43, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 712.48}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 44.93, ["Fly"] = 142.99, ["Ride"] = 71.47, ["Fly|Ride"] = 143.15, ["Neon"] = 236.25, ["Neon|Ride"] = 163.94, ["Neon|Fly|Ride"] = 315, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 19.41, ["Fly"] = 86.25, ["Ride"] = 67.57, ["Fly|Ride"] = 108.05, ["Neon"] = 85.31, ["Neon|Ride"] = 141.65, ["Neon|Fly|Ride"] = 242.44, ["Mega"] = 433.13, ["Mega|Fly"] = 525, ["Mega|Ride"] = 465.94, ["Mega|Fly|Ride"] = 610.24}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 10500, ["Ride"] = 8862, ["Fly|Ride"] = 8107.32, ["Neon|Fly|Ride"] = 14311.5, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1344, ["Fly"] = 1501.85, ["Ride"] = 1455.3, ["Fly|Ride"] = 1442.43, ["Neon|Fly|Ride"] = 4313.46}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 598.19, ["Ride"] = 631.31, ["Fly|Ride"] = 712.15, ["Neon"] = 2253.58, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 21366.07, ["Mega|Fly|Ride"] = 9828.4}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 11.46, ["Fly"] = 23.86, ["Ride"] = 21.9, ["Fly|Ride"] = 39.37, ["Neon"] = 135.19, ["Neon|Ride"] = 90.27, ["Neon|Fly|Ride"] = 118.14, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 577.49}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 5.2, ["Fly"] = 78.74, ["Ride"] = 29.92, ["Fly|Ride"] = 131.25, ["Neon"] = 22.32, ["Neon|Ride"] = 56.11, ["Mega"] = 185.96, ["Mega|Ride"] = 200.42, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 33.44, ["Fly"] = 59.79, ["Ride"] = 53.68, ["Fly|Ride"] = 103.67, ["Neon"] = 541.73, ["Neon|Ride"] = 150.94, ["Neon|Fly|Ride"] = 181.13, ["Mega|Fly|Ride"] = 666.75}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.61, ["Fly"] = 23.39, ["Ride"] = 17.07, ["Fly|Ride"] = 40.24, ["Neon"] = 23.62, ["Neon|Fly"] = 86.63, ["Neon|Ride"] = 44.88, ["Neon|Fly|Ride"] = 98.43, ["Mega"] = 318.36, ["Mega|Ride"] = 245.74, ["Mega|Fly|Ride"] = 269.07}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 285.22, ["Fly"] = 369.5, ["Ride"] = 271.34, ["Fly|Ride"] = 375.35, ["Neon"] = 1107.51, ["Neon|Ride"] = 1439.92, ["Neon|Fly|Ride"] = 1190.39, ["Mega|Fly|Ride"] = 4436.11}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 20.87, ["Fly"] = 60.59, ["Ride"] = 41.99, ["Fly|Ride"] = 85.32, ["Neon"] = 131.25, ["Neon|Fly"] = 407.29, ["Neon|Ride"] = 143.15, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 854.65, ["Mega|Fly"] = 899.11, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 643}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 9.1, ["Fly"] = 18.38, ["Ride"] = 21.4, ["Fly|Ride"] = 40.68, ["Neon"] = 83.34, ["Neon|Fly"] = 120.72, ["Neon|Ride"] = 80.66, ["Neon|Fly|Ride"] = 104.21, ["Mega"] = 1575, ["Mega|Ride"] = 606.63, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 630.83, ["Fly"] = 1048.69, ["Ride"] = 567, ["Fly|Ride"] = 481.53, ["Neon|Fly|Ride"] = 3562.81, ["Mega|Fly|Ride"] = 9971.07}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 918.75, ["Fly"] = 1424.96, ["Ride"] = 1214.04, ["Fly|Ride"] = 1293.5, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13245.91}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 87.94, ["Fly"] = 143.15, ["Ride"] = 110.99, ["Fly|Ride"] = 125.15, ["Neon"] = 512.74, ["Neon|Ride"] = 587.51, ["Neon|Fly|Ride"] = 480.64, ["Mega|Fly|Ride"] = 2800.82}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 182.44, ["Fly"] = 177.19, ["Ride"] = 209.9, ["Fly|Ride"] = 207.89, ["Neon|Ride"] = 557.82, ["Neon|Fly|Ride"] = 721.66, ["Mega|Ride"] = 9187.5, ["Mega|Fly|Ride"] = 2598.75}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 29.7, ["Fly"] = 57.69, ["Ride"] = 35.9, ["Fly|Ride"] = 100.43, ["Neon"] = 236.25, ["Neon|Ride"] = 240.55, ["Mega|Ride"] = 2136.62, ["Mega|Fly|Ride"] = 1077.24}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 328.13, ["Ride"] = 315, ["Fly|Ride"] = 427.28, ["Neon"] = 1220.63, ["Neon|Fly"] = 963.06, ["Neon|Fly|Ride"] = 1281.98, ["Mega|Fly|Ride"] = 5698.34}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1968.75, ["Fly"] = 2136.37, ["Ride"] = 1962.19, ["Fly|Ride"] = 2029.07, ["Neon|Fly|Ride"] = 10683.04, ["Mega|Fly|Ride"] = 35307.98}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 57.63, ["Fly"] = 213.65, ["Ride"] = 51.19, ["Fly|Ride"] = 196.88, ["Neon"] = 288.75, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 343.88, ["Mega"] = 1425.14, ["Mega|Ride"] = 1139.88, ["Mega|Fly|Ride"] = 1254.21}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 623.42, ["Fly"] = 854.56, ["Ride"] = 636.46, ["Fly|Ride"] = 603.75, ["Neon|Ride"] = 1498.88, ["Neon|Fly|Ride"] = 1290.16, ["Mega|Fly|Ride"] = 3451.88}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 45.85, ["Fly"] = 70.88, ["Ride"] = 55.13, ["Fly|Ride"] = 87.23, ["Neon"] = 262.5, ["Neon|Ride"] = 242.11, ["Neon|Fly|Ride"] = 246.88, ["Mega|Ride"] = 1068.32, ["Mega|Fly|Ride"] = 1120.59}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.56, ["Fly"] = 32.71, ["Ride"] = 19.49, ["Fly|Ride"] = 51.96, ["Neon"] = 30.19, ["Neon|Fly"] = 74.82, ["Neon|Ride"] = 52.37, ["Neon|Fly|Ride"] = 96.47, ["Mega"] = 179.82, ["Mega|Ride"] = 186.27, ["Mega|Fly|Ride"] = 296.6}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 58.59, ["Ride"] = 128.83, ["Fly|Ride"] = 157.5, ["Neon"] = 275.52, ["Neon|Ride"] = 457.4, ["Neon|Fly|Ride"] = 712.58, ["Mega"] = 1564.01, ["Mega|Ride"] = 1709.3}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 880.69, ["Fly"] = 656.25, ["Ride"] = 879.38, ["Fly|Ride"] = 918.15, ["Neon|Ride"] = 3249.81, ["Neon|Fly|Ride"] = 3064.69, ["Mega|Fly|Ride"] = 12819.65}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 643.13, ["Ride"] = 855.92, ["Fly|Ride"] = 913.31, ["Neon|Fly|Ride"] = 3276.5, ["Mega|Fly|Ride"] = 15524.59}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 15.75, ["Fly"] = 24.19, ["Ride"] = 23.55, ["Fly|Ride"] = 48.17, ["Neon"] = 144.38, ["Neon|Ride"] = 121.04, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 784.14, ["Mega|Fly|Ride"] = 722.52}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 14.13, ["Ride"] = 33.46, ["Fly|Ride"] = 118.58, ["Neon"] = 137.45, ["Neon|Ride"] = 137.1, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 997.82, ["Mega|Ride"] = 854.65, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.89, ["Ride"] = 41.99, ["Fly|Ride"] = 141.72, ["Neon"] = 20.99, ["Neon|Fly"] = 321.39, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 228.54, ["Mega"] = 186.38, ["Mega|Fly"] = 562.1, ["Mega|Ride"] = 204.65, ["Mega|Fly|Ride"] = 467.93}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 41.41, ["Fly"] = 50.94, ["Ride"] = 49.88, ["Fly|Ride"] = 111.18, ["Neon"] = 114.31, ["Neon|Fly"] = 208.31, ["Neon|Ride"] = 162.58, ["Neon|Fly|Ride"] = 242.82, ["Mega|Ride"] = 890.97, ["Mega|Fly|Ride"] = 1035.57}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 84.45, ["Ride"] = 185.88, ["Fly|Ride"] = 114.31, ["Neon"] = 437.07, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2421.86, ["Mega|Ride"] = 2286.88, ["Mega|Fly|Ride"] = 2263.74}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 11.69, ["Fly"] = 52.41, ["Ride"] = 39.38, ["Fly|Ride"] = 63.67, ["Neon"] = 78.66, ["Neon|Ride"] = 98.43, ["Neon|Fly|Ride"] = 258.55, ["Mega"] = 429.7, ["Mega|Ride"] = 340.74, ["Mega|Fly|Ride"] = 513.63}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 34.13, ["Fly"] = 52.5, ["Ride"] = 42, ["Fly|Ride"] = 94, ["Neon"] = 240.38, ["Neon|Ride"] = 192.46, ["Neon|Fly|Ride"] = 234.93, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1241.62}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 2.63, ["Fly"] = 37.36, ["Ride"] = 17.82, ["Fly|Ride"] = 44.6, ["Neon"] = 27.57, ["Neon|Fly"] = 37.33, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 102.38, ["Mega"] = 434.74, ["Mega|Ride"] = 481.46, ["Mega|Fly|Ride"] = 369.71}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 6.57, ["Fly"] = 64.1, ["Ride"] = 47.01, ["Fly|Ride"] = 86.63, ["Neon"] = 52.39, ["Neon|Fly"] = 114.19, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 236.11, ["Mega"] = 416.06, ["Mega|Ride"] = 417.67, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 46.34, ["Fly"] = 70.73, ["Ride"] = 53.81, ["Fly|Ride"] = 102.01, ["Neon"] = 578.43, ["Neon|Fly"] = 211.3, ["Neon|Ride"] = 201.03, ["Neon|Fly|Ride"] = 267.65, ["Mega|Fly|Ride"] = 1074.92}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1437.19, ["Fly"] = 1410.94, ["Ride"] = 1380.75, ["Fly|Ride"] = 1494.9, ["Neon"] = 4454.12, ["Neon|Ride"] = 4814.51, ["Neon|Fly|Ride"] = 3632.97, ["Mega|Fly|Ride"] = 12576.37}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 472.48, ["Fly"] = 524.99, ["Ride"] = 465.94, ["Fly|Ride"] = 479.07, ["Neon|Ride"] = 3134.04, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 14956.26}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 275.63, ["Fly"] = 378.23, ["Ride"] = 245.59, ["Fly|Ride"] = 354.38, ["Neon"] = 1575, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 7689.66}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 39.38}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 32.44, ["Ride"] = 49.88, ["Fly|Ride"] = 99.73, ["Neon"] = 325.5, ["Neon|Fly"] = 427.28, ["Neon|Ride"] = 192.29, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 1709.3, ["Mega|Fly|Ride"] = 1036.54}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 70875, ["Fly"] = 23499.87, ["Ride"] = 36114.3, ["Fly|Ride"] = 18375, ["Neon|Fly|Ride"] = 38061.19, ["Mega"] = 213660.61, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 232.31, ["Fly"] = 284.44, ["Ride"] = 244.35, ["Fly|Ride"] = 334.68, ["Neon"] = 1039.98, ["Neon|Ride"] = 982.73, ["Neon|Fly|Ride"] = 887.52, ["Mega"] = 6409.83, ["Mega|Fly|Ride"] = 3951.67}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 216.46, ["Fly"] = 525, ["Ride"] = 249.38, ["Fly|Ride"] = 257.27}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 128.2, ["Fly"] = 157.5, ["Ride"] = 150.94, ["Fly|Ride"] = 143.07, ["Neon"] = 549.29, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 630, ["Mega|Ride"] = 3562.81, ["Mega|Fly|Ride"] = 2989.12}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 11.81, ["Fly"] = 64.11, ["Ride"] = 28.4, ["Fly|Ride"] = 84.4, ["Neon"] = 158.1, ["Neon|Ride"] = 113.24, ["Neon|Fly|Ride"] = 228.64, ["Mega"] = 719.78, ["Mega|Ride"] = 481.46, ["Mega|Fly|Ride"] = 961.49}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4976.65, ["Ride"] = 3937.5, ["Fly|Ride"] = 4068.75, ["Neon"] = 21363.51, ["Neon|Fly|Ride"] = 15750}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 27.96, ["Fly"] = 41.9, ["Ride"] = 32.82, ["Fly|Ride"] = 60.99, ["Neon"] = 131.25, ["Neon|Ride"] = 195.9, ["Neon|Fly|Ride"] = 199.4, ["Mega|Ride"] = 1425.14, ["Mega|Fly|Ride"] = 722.18}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 37.28, ["Ride"] = 52.41, ["Fly|Ride"] = 102.85, ["Neon"] = 311.32, ["Neon|Fly"] = 1424.96, ["Neon|Ride"] = 202.79, ["Neon|Fly|Ride"] = 262.49, ["Mega|Fly|Ride"] = 1388.63}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 479.07, ["Fly"] = 563.06, ["Ride"] = 492.19, ["Fly|Ride"] = 569.63, ["Neon"] = 1312.5, ["Neon|Ride"] = 1226.91, ["Neon|Fly|Ride"] = 1378.13, ["Mega|Fly|Ride"] = 5271.03}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 19.69, ["Fly"] = 28.75, ["Ride"] = 23.13, ["Fly|Ride"] = 38.06, ["Neon"] = 131.24, ["Neon|Fly"] = 161.31, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 143.04, ["Mega|Ride"] = 610.24, ["Mega|Fly|Ride"] = 554.7}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 13.55, ["Ride"] = 34.54, ["Fly|Ride"] = 80.64, ["Neon"] = 98.44, ["Neon|Ride"] = 131.92, ["Neon|Fly|Ride"] = 211.21, ["Mega"] = 562.1, ["Mega|Ride"] = 746.26, ["Mega|Fly|Ride"] = 528.83}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 97.13, ["Ride"] = 103.69, ["Fly|Ride"] = 242.49, ["Neon"] = 1010.63, ["Neon|Ride"] = 588.58, ["Neon|Fly|Ride"] = 1553.32, ["Mega|Fly|Ride"] = 2407.23}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 19.69, ["Fly"] = 71.58, ["Ride"] = 65.62, ["Fly|Ride"] = 471.07, ["Neon"] = 79.07, ["Neon|Ride"] = 149.62, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 350.47, ["Mega|Fly"] = 487.1, ["Mega|Ride"] = 316.32, ["Mega|Fly|Ride"] = 478.17}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 4068.75, ["Fly"] = 6196.21, ["Ride"] = 4245.94, ["Fly|Ride"] = 4160.63, ["Neon"] = 19687.5, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 9842.44, ["Mega"] = 48430.47, ["Mega|Fly|Ride"] = 37945.69}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 39.25, ["Fly"] = 143.15, ["Ride"] = 65.54, ["Fly|Ride"] = 131.25, ["Neon"] = 215.25, ["Neon|Ride"] = 258.57, ["Neon|Fly|Ride"] = 320.51, ["Mega"] = 854.65, ["Mega|Ride"] = 1765.72, ["Mega|Fly|Ride"] = 784.88}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 6300, ["Fly"] = 7584.06, ["Ride"] = 6857.82, ["Fly|Ride"] = 6456.19, ["Neon|Fly|Ride"] = 15225, ["Mega|Fly|Ride"] = 46921.88}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.65, ["Fly"] = 18.89, ["Ride"] = 16.41, ["Fly|Ride"] = 38.46, ["Neon"] = 24.92, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 45.98, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 243.58, ["Mega|Ride"] = 372.75, ["Mega|Fly|Ride"] = 257.59}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 18.24, ["Fly"] = 31.5, ["Ride"] = 32.51, ["Fly|Ride"] = 63.04, ["Neon"] = 185.88, ["Neon|Fly"] = 236.09, ["Neon|Ride"] = 498.85, ["Neon|Fly|Ride"] = 167.99, ["Mega|Ride"] = 991.6, ["Mega|Fly|Ride"] = 997.82}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.94}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 11.06, ["Fly"] = 45.76, ["Ride"] = 23.62, ["Fly|Ride"] = 87.02, ["Neon"] = 73.11, ["Neon|Ride"] = 118.13, ["Mega"] = 1050, ["Mega|Ride"] = 1066.19, ["Mega|Fly|Ride"] = 802.31}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 22.04, ["Fly"] = 190.37, ["Ride"] = 71.58, ["Fly|Ride"] = 170.92, ["Neon"] = 203.44, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 945, ["Mega|Ride"] = 854.65, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 13.29, ["Fly"] = 28.56, ["Ride"] = 19.13, ["Fly|Ride"] = 38.09, ["Neon|Fly"] = 1064.99, ["Neon|Ride"] = 117.97, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 2563.95, ["Mega|Fly|Ride"] = 570.49}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8688.56}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.99}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 19.62}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 161.44, ["Ride"] = 392.03, ["Fly|Ride"] = 315, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 15.14, ["Fly"] = 143.15, ["Ride"] = 31.5, ["Fly|Ride"] = 143.15, ["Neon"] = 128.83, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 265.13, ["Mega"] = 438.02, ["Mega|Ride"] = 530.8, ["Mega|Fly|Ride"] = 493.58}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 10.5}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.19, ["Ride"] = 26.24, ["Fly|Ride"] = 85.46, ["Neon|Ride"] = 155.97, ["Mega"] = 1567.21}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2357.24}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 158.82, ["Fly"] = 356.79, ["Ride"] = 261.84, ["Fly|Ride"] = 367.5, ["Neon"] = 997.69, ["Neon|Ride"] = 962.92, ["Neon|Fly|Ride"] = 777.74, ["Mega|Ride"] = 4131.15, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 62.36, ["Fly"] = 196.88, ["Ride"] = 84.62, ["Fly|Ride"] = 240.77, ["Neon"] = 315, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 712.58, ["Mega|Ride"] = 1852.45, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 157.48, ["Fly"] = 236.09, ["Ride"] = 170.61, ["Fly|Ride"] = 240.77, ["Neon"] = 944.99, ["Neon|Ride"] = 787.49, ["Neon|Fly|Ride"] = 822.22, ["Mega"] = 4045.68, ["Mega|Fly|Ride"] = 3417.07}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2395.32, ["Fly"] = 3067.41, ["Ride"] = 2595.57, ["Fly|Ride"] = 2651.24, ["Neon"] = 15003.61, ["Neon|Ride"] = 9629, ["Neon|Fly|Ride"] = 7875, ["Mega|Fly|Ride"] = 27064.41}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 18.38, ["Fly"] = 182.67, ["Ride"] = 42.15, ["Fly|Ride"] = 106.84, ["Neon"] = 120.4, ["Neon|Fly"] = 161.3, ["Neon|Ride"] = 154.07, ["Neon|Fly|Ride"] = 228.64, ["Mega"] = 960.42, ["Mega|Ride"] = 997.82, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 840, ["Fly"] = 2100, ["Ride"] = 997.69, ["Fly|Ride"] = 867.18, ["Neon|Fly|Ride"] = 4172.94}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 38.07}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 21.67, ["Ride"] = 51.3, ["Fly|Ride"] = 131.25, ["Neon"] = 78.75, ["Neon|Ride"] = 137.06, ["Neon|Fly|Ride"] = 315.16, ["Mega"] = 480.38, ["Mega|Fly"] = 962.91, ["Mega|Ride"] = 514.5, ["Mega|Fly|Ride"] = 650.99}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 7.24, ["Fly"] = 48.17, ["Ride"] = 27.96, ["Fly|Ride"] = 128.14, ["Neon"] = 65.62, ["Neon|Fly"] = 315, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 209.94, ["Mega"] = 450.16, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 405.97}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 62.98}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 20.89, ["Fly"] = 55.13, ["Ride"] = 30.07, ["Fly|Ride"] = 100.43, ["Neon|Ride"] = 192.6, ["Neon|Fly|Ride"] = 254.63, ["Mega|Fly|Ride"] = 2136.62}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 27.57, ["Fly"] = 45.94, ["Ride"] = 39.38, ["Fly|Ride"] = 52.5, ["Neon|Fly"] = 236.09, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 170.94, ["Mega"] = 1425.14, ["Mega|Ride"] = 1805.43, ["Mega|Fly|Ride"] = 989.63}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6473.15, ["Fly"] = 10237.5, ["Ride"] = 6408, ["Fly|Ride"] = 4974.37, ["Neon|Fly|Ride"] = 9975, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 7.66, ["Fly"] = 61.69, ["Ride"] = 26.17, ["Fly|Ride"] = 81.38, ["Neon"] = 55.11, ["Neon|Ride"] = 85.22, ["Neon|Fly|Ride"] = 199.79, ["Mega"] = 512.8, ["Mega|Ride"] = 314.99, ["Mega|Fly|Ride"] = 399.56}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 18.37}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 90.56, ["Fly"] = 378.15, ["Ride"] = 131.15, ["Fly|Ride"] = 157.5, ["Neon"] = 374.07, ["Neon|Ride"] = 511, ["Neon|Fly|Ride"] = 481.42, ["Mega"] = 2879.59, ["Mega|Ride"] = 1764.77, ["Mega|Fly|Ride"] = 2452.84}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 49.68, ["Fly"] = 189.02, ["Ride"] = 75.49, ["Fly|Ride"] = 190.32, ["Neon"] = 144.38, ["Neon|Fly"] = 361.16, ["Neon|Ride"] = 285.22, ["Neon|Fly|Ride"] = 446.25, ["Mega"] = 2407.23, ["Mega|Ride"] = 2884.44, ["Mega|Fly|Ride"] = 1046.07}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 22.98, ["Fly"] = 72.18, ["Ride"] = 28.88, ["Fly|Ride"] = 66.81, ["Neon"] = 128.78, ["Neon|Fly"] = 230.74, ["Neon|Ride"] = 144.05, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 1016.21, ["Mega|Ride"] = 866.62, ["Mega|Fly|Ride"] = 800.62}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 5.25, ["Fly"] = 74.02, ["Ride"] = 26.25, ["Fly|Ride"] = 112.59, ["Neon"] = 28.59, ["Neon|Ride"] = 80.07, ["Neon|Fly|Ride"] = 129.84, ["Mega"] = 162.73, ["Mega|Fly"] = 285.26, ["Mega|Ride"] = 221.79, ["Mega|Fly|Ride"] = 326.54}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 13.13, ["Ride"] = 31.46, ["Fly|Ride"] = 98.06, ["Neon"] = 100.42, ["Neon|Ride"] = 120.74, ["Neon|Fly|Ride"] = 218.29, ["Mega"] = 570.49, ["Mega|Ride"] = 641, ["Mega|Fly|Ride"] = 587.36}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 18.38, ["Fly"] = 28.09, ["Ride"] = 30.08, ["Fly|Ride"] = 45.93, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 144.38, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 200.79}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 34.46, ["Fly"] = 143.15, ["Ride"] = 131.23, ["Fly|Ride"] = 285.22, ["Neon"] = 209.99, ["Neon|Ride"] = 285.22, ["Neon|Fly|Ride"] = 355.08, ["Mega"] = 866.25, ["Mega|Fly|Ride"] = 678.57}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 308.82, ["Ride"] = 1424.96, ["Fly|Ride"] = 433.38, ["Neon|Fly|Ride"] = 28488.45}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 62.9, ["Fly"] = 213.65, ["Ride"] = 87.41, ["Fly|Ride"] = 187.68, ["Neon"] = 275.63, ["Neon|Ride"] = 342.25, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 996.19, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1279.84}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 1050, ["Fly"] = 1382.24, ["Ride"] = 1023.75, ["Fly|Ride"] = 1000.13, ["Neon|Fly"] = 4366.23, ["Neon|Ride"] = 4059.08, ["Neon|Fly|Ride"] = 3281.25, ["Mega"] = 21665.02, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 341.25, ["Fly"] = 712.48, ["Ride"] = 393.75, ["Fly|Ride"] = 481.04, ["Neon"] = 2388.75, ["Neon|Ride"] = 3134.04, ["Neon|Fly|Ride"] = 1925.79, ["Mega"] = 12197.41, ["Mega|Fly|Ride"] = 9448.69}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 54.8}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.52}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 10.5, ["Fly"] = 31.4, ["Ride"] = 23.62, ["Fly|Ride"] = 42.74, ["Neon"] = 78.75, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 75.05, ["Neon|Fly|Ride"] = 137.75, ["Mega"] = 437.26, ["Mega|Ride"] = 712.58, ["Mega|Fly|Ride"] = 563}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 249.32, ["Fly"] = 409.16, ["Ride"] = 280.75, ["Fly|Ride"] = 367.5, ["Neon"] = 2407.63, ["Neon|Ride"] = 950.59, ["Neon|Fly|Ride"] = 1588.13, ["Mega|Fly|Ride"] = 2991.77}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 14.44}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 120.75, ["Ride"] = 143.15, ["Fly|Ride"] = 306.6, ["Neon"] = 635.62, ["Neon|Fly"] = 610.32, ["Neon|Ride"] = 577.4, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 2350.28, ["Mega|Ride"] = 2231.25, ["Mega|Fly|Ride"] = 2235.43}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 112.2, ["Fly"] = 213.65, ["Ride"] = 137.22, ["Fly|Ride"] = 143.15, ["Neon"] = 498.85, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 854.65, ["Mega|Fly|Ride"] = 3084.38}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 4.73, ["Fly"] = 42.74, ["Ride"] = 23, ["Fly|Ride"] = 52.5, ["Neon"] = 36.63, ["Neon|Ride"] = 69.62, ["Neon|Fly|Ride"] = 252.13, ["Mega"] = 189.32, ["Mega|Ride"] = 189.95, ["Mega|Fly|Ride"] = 371.79}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 14.44, ["Fly"] = 71.58, ["Ride"] = 30.18, ["Fly|Ride"] = 69.57, ["Neon"] = 131.25, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 321.39, ["Mega|Ride"] = 1425.14, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 11.82, ["Fly"] = 102.36, ["Ride"] = 34.05, ["Fly|Ride"] = 114.31, ["Neon"] = 72.19, ["Neon|Ride"] = 101.06, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 426.27, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 570.49}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 3.93, ["Fly"] = 131.23, ["Ride"] = 51.41, ["Fly|Ride"] = 150.63, ["Neon"] = 30.19, ["Neon|Ride"] = 74.82, ["Neon|Fly|Ride"] = 172.11, ["Mega"] = 160.09, ["Mega|Fly"] = 256.41, ["Mega|Ride"] = 176.55, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 260.7, ["Ride"] = 262.49, ["Fly|Ride"] = 331.53, ["Neon"] = 1424.96, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1395.72, ["Mega|Fly|Ride"] = 5695.13}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 73.95, ["Fly"] = 570.42, ["Ride"] = 127.12, ["Fly|Ride"] = 209.99, ["Neon"] = 420.65, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 630, ["Mega"] = 2562.88, ["Mega|Fly|Ride"] = 2007.64}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 63, ["Fly"] = 39.38, ["Ride"] = 78.75, ["Fly|Ride"] = 114.31, ["Neon"] = 315, ["Neon|Ride"] = 341.22, ["Neon|Fly|Ride"] = 415.8, ["Mega"] = 1425.14, ["Mega|Ride"] = 1765.72, ["Mega|Fly|Ride"] = 1372.88}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 19.69, ["Fly"] = 126, ["Ride"] = 36.33, ["Fly|Ride"] = 285.22, ["Neon"] = 170.92, ["Neon|Ride"] = 611.45, ["Neon|Fly|Ride"] = 498.91, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 12.01, ["Fly"] = 77.18, ["Ride"] = 30.17, ["Fly|Ride"] = 93.17, ["Neon"] = 71.42, ["Neon|Fly"] = 143.15, ["Neon|Ride"] = 106.84, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 413.44, ["Mega|Fly"] = 525, ["Mega|Ride"] = 481.46, ["Mega|Fly|Ride"] = 590.61}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.83, ["Fly"] = 38.07, ["Ride"] = 21, ["Fly|Ride"] = 69.57, ["Neon"] = 23.63, ["Neon|Fly"] = 76.93, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 105, ["Mega"] = 166.67, ["Mega|Ride"] = 170.52, ["Mega|Fly|Ride"] = 269.13}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 879.38, ["Fly"] = 918.75, ["Ride"] = 918.75, ["Fly|Ride"] = 976.49, ["Neon"] = 4272.72, ["Neon|Fly"] = 3268.36, ["Neon|Ride"] = 3370.16, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 8085}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 262.49, ["Fly"] = 399.51, ["Ride"] = 288.65, ["Fly|Ride"] = 481.53, ["Neon"] = 1281.83, ["Neon|Ride"] = 1270.5, ["Neon|Fly|Ride"] = 1124.19, ["Mega"] = 10683.04, ["Mega|Fly|Ride"] = 5135.84}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 91.87, ["Fly"] = 170.92, ["Ride"] = 99.27, ["Fly|Ride"] = 131.25, ["Neon"] = 420, ["Neon|Fly"] = 481.53, ["Neon|Ride"] = 400.19, ["Neon|Fly|Ride"] = 302.64, ["Mega"] = 1495.65, ["Mega|Ride"] = 1724.26, ["Mega|Fly|Ride"] = 1695.41}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 168, ["Fly"] = 283.5, ["Ride"] = 184.94, ["Fly|Ride"] = 212.63, ["Neon|Ride"] = 971.25, ["Neon|Fly|Ride"] = 917.44, ["Mega"] = 10683.04, ["Mega|Fly|Ride"] = 3990.13}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 24.94, ["Fly"] = 42.74, ["Ride"] = 28.88, ["Fly|Ride"] = 86.63, ["Neon"] = 169.31, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 204.75, ["Mega|Ride"] = 712.48, ["Mega|Fly|Ride"] = 939.06}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 236.24, ["Ride"] = 269.06, ["Fly|Ride"] = 358.32, ["Neon"] = 897.28, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 4252.16, ["Mega|Fly|Ride"] = 3559.6}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 76.13, ["Fly"] = 125.99, ["Ride"] = 80.07, ["Fly|Ride"] = 127.32, ["Neon|Ride"] = 570.42, ["Mega|Fly|Ride"] = 1425.14}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 2716.88, ["Ride"] = 2453.24, ["Fly|Ride"] = 2472.75, ["Neon|Ride"] = 8545.42, ["Neon|Fly|Ride"] = 7061.6, ["Mega"] = 51278.56, ["Mega|Fly|Ride"] = 18375}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 11.21, ["Fly"] = 78.04, ["Ride"] = 30.19, ["Fly|Ride"] = 91.85, ["Neon"] = 55.13, ["Neon|Fly"] = 105, ["Neon|Ride"] = 74.64, ["Neon|Fly|Ride"] = 164.06, ["Mega"] = 231, ["Mega|Fly"] = 570.49, ["Mega|Ride"] = 320.09, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 57.69, ["Ride"] = 64.67, ["Fly|Ride"] = 161.33, ["Neon"] = 196.88, ["Neon|Ride"] = 242.82, ["Neon|Fly|Ride"] = 485.03, ["Mega|Ride"] = 931.88, ["Mega|Fly|Ride"] = 1203.62}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 75.95, ["Fly"] = 91.87, ["Ride"] = 82.42, ["Fly|Ride"] = 93.18, ["Neon"] = 525, ["Neon|Ride"] = 640.92, ["Neon|Fly|Ride"] = 410.79, ["Mega|Fly|Ride"] = 1879.84}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2203.69, ["Fly"] = 1605.95, ["Ride"] = 1069.69, ["Fly|Ride"] = 1109.07, ["Neon|Ride"] = 5135.87, ["Neon|Fly|Ride"] = 4558.46, ["Mega"] = 34898.27, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 525, ["Fly"] = 852.42, ["Ride"] = 565.81, ["Fly|Ride"] = 534.19, ["Mega|Fly|Ride"] = 11395.61}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 70.46, ["Fly"] = 321.44, ["Ride"] = 85.35, ["Fly|Ride"] = 209.72, ["Neon"] = 341.25, ["Neon|Ride"] = 342.55, ["Neon|Fly|Ride"] = 601.81, ["Mega"] = 1995.61, ["Mega|Ride"] = 1709.3, ["Mega|Fly|Ride"] = 1615.87}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 6.35, ["Fly"] = 32.82, ["Ride"] = 25.65, ["Fly|Ride"] = 72.19, ["Neon"] = 79.78, ["Neon|Ride"] = 86.85, ["Neon|Fly|Ride"] = 161.27, ["Mega"] = 553.88, ["Mega|Ride"] = 815.69}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 39.36, ["Fly"] = 68.25, ["Ride"] = 43.35, ["Fly|Ride"] = 87.94, ["Neon"] = 284.82, ["Neon|Fly"] = 356.79, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 341.79, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 883.51}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 745.5, ["Fly"] = 1107.56, ["Ride"] = 745.63, ["Fly|Ride"] = 866.24, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2508.42, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 591.72}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 6958.24, ["Ride"] = 6195.42, ["Fly|Ride"] = 5775, ["Neon"] = 42000, ["Neon|Ride"] = 30614.98, ["Neon|Fly|Ride"] = 19687.5, ["Mega|Fly|Ride"] = 106688.24}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 262.48, ["Fly"] = 400.59, ["Ride"] = 285.22, ["Fly|Ride"] = 413.4, ["Neon"] = 1312.5, ["Neon|Ride"] = 1852.23, ["Neon|Fly|Ride"] = 1706.25, ["Mega"] = 6408.76, ["Mega|Ride"] = 6125.67, ["Mega|Fly|Ride"] = 6125.67}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 71.34, ["Fly"] = 285.22, ["Ride"] = 144.26, ["Fly|Ride"] = 336, ["Neon"] = 712.48, ["Neon|Ride"] = 997.69, ["Neon|Fly|Ride"] = 641}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 15.75, ["Fly"] = 100.43, ["Ride"] = 32.7, ["Fly|Ride"] = 91.75, ["Neon"] = 131.92, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 712.58, ["Mega|Ride"] = 854.65, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 11.82, ["Fly"] = 26.24, ["Ride"] = 27.2, ["Fly|Ride"] = 43.32, ["Neon"] = 213.65, ["Neon|Ride"] = 128.2, ["Neon|Fly|Ride"] = 163.42, ["Mega"] = 1312.5, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 2136.62}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 15.75, ["Fly"] = 163.47, ["Ride"] = 31.5, ["Fly|Ride"] = 103.3, ["Neon"] = 124.67, ["Neon|Ride"] = 110.93, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 645.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 627.12}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.04, ["Fly"] = 63.04, ["Ride"] = 22.32, ["Fly|Ride"] = 48.57, ["Neon"] = 31.39, ["Neon|Ride"] = 56.58, ["Neon|Fly|Ride"] = 126.07, ["Mega"] = 668.25, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 204.23}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 27.68, ["Fly"] = 90.57, ["Ride"] = 47.25, ["Fly|Ride"] = 143.15, ["Neon"] = 156.58, ["Neon|Fly"] = 854.56, ["Neon|Ride"] = 230.74, ["Neon|Fly|Ride"] = 339.74, ["Mega"] = 630, ["Mega|Ride"] = 1260}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 498.96, ["Fly"] = 538.13, ["Ride"] = 551.13, ["Fly|Ride"] = 603.75, ["Neon|Ride"] = 1567.04, ["Neon|Fly|Ride"] = 1548.75, ["Mega"] = 7875, ["Mega|Fly|Ride"] = 5826.54}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.1, ["Fly"] = 19.58, ["Ride"] = 15.59, ["Fly|Ride"] = 38.04, ["Neon"] = 20.99, ["Neon|Ride"] = 32.1, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 170.63, ["Mega|Ride"] = 226.5, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 47.24, ["Fly"] = 115.48, ["Ride"] = 77.44, ["Fly|Ride"] = 137.71, ["Neon"] = 228.59, ["Neon|Fly"] = 356.79, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 564.38, ["Mega|Fly"] = 854.65, ["Mega|Ride"] = 557.81, ["Mega|Fly|Ride"] = 615.55}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 761.25, ["Ride"] = 734.99, ["Fly|Ride"] = 807.18, ["Neon|Ride"] = 2136.37, ["Neon|Fly|Ride"] = 1573.69, ["Mega|Fly|Ride"] = 4287.82}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 31.16, ["Fly"] = 69.05, ["Ride"] = 51.19, ["Fly|Ride"] = 76.89, ["Neon"] = 262.5, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 176.47, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 315, ["Fly"] = 481.55, ["Ride"] = 276.08, ["Fly|Ride"] = 337.31, ["Neon|Fly|Ride"] = 997.82, ["Mega|Fly|Ride"] = 3703.83}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 243.6, ["Fly"] = 320.5, ["Ride"] = 258.57, ["Fly|Ride"] = 261.01, ["Neon|Ride"] = 997.69, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 4268.96, ["Mega|Fly|Ride"] = 3776.47}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 840.67, ["Ride"] = 787.5, ["Fly|Ride"] = 1025.47, ["Neon|Ride"] = 3786.61, ["Neon|Fly|Ride"] = 2296.88, ["Mega|Fly|Ride"] = 9711.19}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 16.15, ["Fly"] = 61.97, ["Ride"] = 46.35, ["Fly|Ride"] = 119.19, ["Neon"] = 64.11, ["Neon|Fly"] = 288.88, ["Neon|Ride"] = 91.77, ["Neon|Fly|Ride"] = 161.3, ["Mega"] = 354.38, ["Mega|Ride"] = 356.79, ["Mega|Fly|Ride"] = 642.75}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4084.49, ["Fly"] = 3438.49, ["Ride"] = 3281.25, ["Fly|Ride"] = 3346.87, ["Neon|Fly|Ride"] = 7350, ["Mega|Fly|Ride"] = 18892.13}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 124.68, ["Fly"] = 170.92, ["Ride"] = 131.25, ["Fly|Ride"] = 209.56, ["Neon"] = 525, ["Neon|Fly"] = 712.48, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 570.49, ["Mega|Ride"] = 2991.27, ["Mega|Fly|Ride"] = 3147.5}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.6, ["Fly"] = 28.24, ["Ride"] = 18.5, ["Fly|Ride"] = 51.49, ["Neon"] = 24.94, ["Neon|Fly"] = 65.62, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 102.92, ["Mega"] = 160.1, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 248.24, ["Mega|Fly|Ride"] = 228.64}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.34, ["Ride"] = 27.56, ["Fly|Ride"] = 59.07, ["Neon"] = 21, ["Neon|Fly"] = 117.97, ["Neon|Ride"] = 64.3, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 175.97, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 37.33, ["Fly"] = 57.69, ["Ride"] = 42.88, ["Fly|Ride"] = 56.43, ["Neon"] = 288.93, ["Neon|Ride"] = 312.96, ["Neon|Fly|Ride"] = 256.41, ["Mega|Fly|Ride"] = 1126}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 777, ["Fly"] = 1252.01, ["Ride"] = 774.38, ["Fly|Ride"] = 1038.18, ["Neon|Ride"] = 3210.08, ["Neon|Fly|Ride"] = 4736.22}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6956.25, ["Fly|Ride"] = 7087.5}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 19.28, ["Fly"] = 31.48, ["Ride"] = 24.94, ["Fly|Ride"] = 47.25, ["Neon"] = 452.13, ["Neon|Ride"] = 128.31, ["Neon|Fly|Ride"] = 143.17, ["Mega"] = 2520, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 12.18, ["Fly"] = 43.32, ["Ride"] = 28.85, ["Fly|Ride"] = 65.63, ["Neon"] = 91.87, ["Neon|Ride"] = 89.14, ["Neon|Fly|Ride"] = 121.05, ["Mega"] = 668.87, ["Mega|Ride"] = 479.07, ["Mega|Fly|Ride"] = 501.38}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 92.65, ["Fly"] = 157.5, ["Ride"] = 112.47, ["Fly|Ride"] = 152.25, ["Neon|Ride"] = 452.81, ["Neon|Fly|Ride"] = 498.81, ["Mega|Fly|Ride"] = 1993.47}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 218.67, ["Fly"] = 241.5, ["Ride"] = 221.82, ["Fly|Ride"] = 314.99, ["Neon"] = 1286.25, ["Neon|Ride"] = 1182.93, ["Neon|Fly|Ride"] = 1029, ["Mega"] = 10683.04, ["Mega|Fly"] = 4014.07, ["Mega|Fly|Ride"] = 4495.51}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.89, ["Ride"] = 38.07, ["Fly|Ride"] = 93.19, ["Neon"] = 20.37, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 66.24, ["Mega"] = 160.13, ["Mega|Fly"] = 238.25, ["Mega|Ride"] = 191.63, ["Mega|Fly|Ride"] = 229.69}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 181.13, ["Fly"] = 231.71, ["Ride"] = 206.07, ["Fly|Ride"] = 262.49, ["Neon"] = 656.25, ["Neon|Ride"] = 715.32, ["Neon|Fly|Ride"] = 787.5, ["Mega|Fly|Ride"] = 2779.88}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.1, ["Fly"] = 19.94, ["Ride"] = 15.75, ["Fly|Ride"] = 38.49, ["Neon"] = 24.94, ["Neon|Fly"] = 118.58, ["Neon|Ride"] = 45.88, ["Neon|Fly|Ride"] = 108.94, ["Mega"] = 431.61, ["Mega|Ride"] = 219.19, ["Mega|Fly|Ride"] = 282.05}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 179.1, ["Fly"] = 348.24, ["Ride"] = 210, ["Fly|Ride"] = 265.13, ["Neon|Ride"] = 1324, ["Neon|Fly|Ride"] = 1115.63, ["Mega"] = 10683.04, ["Mega|Fly|Ride"] = 4131.15}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 9.91, ["Fly"] = 77.44, ["Ride"] = 28.77, ["Fly|Ride"] = 68.25, ["Neon"] = 73.5, ["Neon|Fly"] = 305.79, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 570.49, ["Mega|Ride"] = 555.53, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Ride"] = 26.17, ["Fly|Ride"] = 51.19, ["Neon"] = 8.45, ["Neon|Fly"] = 170.46, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 195.56, ["Mega"] = 80.66, ["Mega|Ride"] = 134.97, ["Mega|Fly|Ride"] = 322.64}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Mega"] = 22.95, ["Mega|Ride"] = 143.17, ["Mega|Fly|Ride"] = 161.3}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 5.23, ["Ride"] = 30.9, ["Fly|Ride"] = 85.53, ["Neon"] = 6.18, ["Neon|Ride"] = 39.21, ["Neon|Fly|Ride"] = 126, ["Mega"] = 93.85, ["Mega|Fly"] = 160482.4, ["Mega|Ride"] = 87.05, ["Mega|Fly|Ride"] = 256.1}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 64.97, ["Fly"] = 101.62, ["Ride"] = 101.06, ["Fly|Ride"] = 213.93, ["Neon"] = 339.94, ["Neon|Fly"] = 288.75, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 389.82, ["Mega|Fly|Ride"] = 1551.19}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 37.33, ["Ride"] = 17.05, ["Fly|Ride"] = 83.34, ["Neon"] = 6.46, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 52.4, ["Mega"] = 91.77, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 262.47}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 10.5, ["Neon"] = 82.26, ["Neon|Fly"] = 305.79, ["Neon|Ride"] = 212.52, ["Mega"] = 261.19, ["Mega|Ride"] = 551.25, ["Mega|Fly|Ride"] = 604.68}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Ride"] = 17.84, ["Neon"] = 2.1, ["Neon|Ride"] = 55.25, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 17.07, ["Mega|Ride"] = 90.04, ["Mega|Fly|Ride"] = 196.77}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 71.3, ["Ride"] = 15.75, ["Fly|Ride"] = 49.03, ["Neon"] = 2.1, ["Neon|Fly"] = 37.09, ["Neon|Ride"] = 11.82, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 12.55, ["Mega|Fly"] = 35.8, ["Mega|Ride"] = 24.94, ["Mega|Fly|Ride"] = 63.95}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 14.51, ["Fly|Ride"] = 80.13, ["Neon"] = 3.93, ["Neon|Fly"] = 21, ["Neon|Ride"] = 15.6, ["Neon|Fly|Ride"] = 52.41, ["Mega"] = 24.59, ["Mega|Fly"] = 161.3, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 86.63}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 59.96, ["Mega"] = 19.69, ["Mega|Ride"] = 105}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 24.59, ["Fly|Ride"] = 107.62, ["Neon"] = 6.19, ["Neon|Fly"] = 121.72, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 89.13, ["Mega"] = 35.56, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 37.33, ["Mega|Fly|Ride"] = 101.07}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.62, ["Neon|Ride"] = 82.09, ["Neon|Fly|Ride"] = 427.33, ["Mega"] = 19.48, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 69.57, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 3.73, ["Fly"] = 77.43, ["Ride"] = 36.75, ["Fly|Ride"] = 170.85, ["Neon"] = 22.32, ["Neon|Fly"] = 118.54, ["Neon|Ride"] = 58.69, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 129.94, ["Mega|Fly"] = 282.86, ["Mega|Ride"] = 166.69, ["Mega|Fly|Ride"] = 272.27}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 51.98, ["Neon"] = 2.1, ["Neon|Ride"] = 42.74, ["Neon|Fly|Ride"] = 321.39, ["Mega"] = 15.49, ["Mega|Fly"] = 144.27, ["Mega|Ride"] = 85.47, ["Mega|Fly|Ride"] = 196.77}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 144.22, ["Fly|Ride"] = 143.15, ["Neon"] = 18.26, ["Mega"] = 120.63, ["Mega|Fly"] = 315, ["Mega|Ride"] = 274.31, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 26.24, ["Neon"] = 13.13, ["Mega"] = 119.79, ["Mega|Ride"] = 158.12, ["Mega|Fly|Ride"] = 570.49}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 32.8, ["Neon"] = 3.93, ["Neon|Ride"] = 27.8, ["Neon|Fly|Ride"] = 143.17, ["Mega"] = 21.06, ["Mega|Ride"] = 44.63, ["Mega|Fly|Ride"] = 98.01}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.28, ["Ride"] = 14.34, ["Fly|Ride"] = 21.38, ["Neon"] = 2.1, ["Neon|Fly"] = 28.9, ["Neon|Ride"] = 11.82, ["Neon|Fly|Ride"] = 34.65, ["Mega"] = 13.18, ["Mega|Fly"] = 32.81, ["Mega|Ride"] = 20.6, ["Mega|Fly|Ride"] = 48.17}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 54.28, ["Fly|Ride"] = 118.1, ["Neon"] = 36.75, ["Neon|Ride"] = 71.58, ["Mega"] = 176.17, ["Mega|Ride"] = 192.31}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 32.45, ["Neon"] = 3.81, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 32.06, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 25.81, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 115.49}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 4.48, ["Ride"] = 17.11, ["Neon"] = 18.24, ["Mega"] = 84, ["Mega|Ride"] = 161.22, ["Mega|Fly|Ride"] = 213.68}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 78.92, ["Ride"] = 19.69, ["Neon"] = 15.09, ["Neon|Ride"] = 42.74, ["Neon|Fly|Ride"] = 105, ["Mega"] = 124.69, ["Mega|Ride"] = 163.41, ["Mega|Fly|Ride"] = 196.87}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 14.44, ["Ride"] = 15.65, ["Fly|Ride"] = 31.49, ["Neon"] = 2.1, ["Neon|Fly"] = 15.75, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 32.47, ["Mega"] = 15.39, ["Mega|Fly"] = 28.18, ["Mega|Ride"] = 19.17, ["Mega|Fly|Ride"] = 52.4}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 28.86, ["Ride"] = 27.42, ["Fly|Ride"] = 143.15, ["Neon"] = 12.96, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 196.27, ["Mega"] = 129.65, ["Mega|Ride"] = 161.3, ["Mega|Fly|Ride"] = 161.3}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.6, ["Fly"] = 114.31, ["Ride"] = 114.26, ["Fly|Ride"] = 59.07, ["Neon"] = 52.5, ["Neon|Ride"] = 70.73, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 203.44, ["Mega|Ride"] = 297.51, ["Mega|Fly|Ride"] = 327.48}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 14.41, ["Fly|Ride"] = 42.57, ["Neon"] = 2.1, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 14.43, ["Neon|Fly|Ride"] = 32.19, ["Mega"] = 20.34, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 98.3}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 178.41, ["Ride"] = 45.9, ["Neon"] = 6.57, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 128.8, ["Mega"] = 55.38, ["Mega|Fly"] = 170.94, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 213.68}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Neon"] = 3.83, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 285.26, ["Mega"] = 27.57, ["Mega|Fly"] = 114.58, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 341.87}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 32.51, ["Ride"] = 21, ["Neon"] = 2.1, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 285.26, ["Mega"] = 14.2, ["Mega|Fly"] = 253.82, ["Mega|Ride"] = 42.67, ["Mega|Fly|Ride"] = 156.18}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 71.58, ["Ride"] = 18.38, ["Fly|Ride"] = 46.57, ["Neon"] = 8.33, ["Neon|Fly"] = 54.49, ["Neon|Ride"] = 35.43, ["Neon|Fly|Ride"] = 71.59, ["Mega"] = 71.31, ["Mega|Ride"] = 73.5, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 22.59, ["Neon"] = 5.45, ["Neon|Ride"] = 56.58, ["Mega"] = 45.72, ["Mega|Fly"] = 321.39, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 249.37}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 19.28, ["Ride"] = 15.74, ["Fly|Ride"] = 57.69, ["Neon"] = 6.57, ["Neon|Fly"] = 80.66, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 64.97, ["Mega"] = 111.57, ["Mega|Fly"] = 114.6, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.1, ["Ride"] = 37.03, ["Neon"] = 31.95, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 320.51, ["Mega"] = 104.74, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 210}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 25.77, ["Ride"] = 18.08, ["Fly|Ride"] = 47.01, ["Neon"] = 11.26, ["Neon|Fly"] = 48.17, ["Neon|Ride"] = 31.81, ["Neon|Fly|Ride"] = 89.09, ["Mega"] = 236.25, ["Mega|Fly"] = 420, ["Mega|Ride"] = 118.6, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 16.91, ["Fly|Ride"] = 100.43, ["Neon"] = 13.11, ["Neon|Fly"] = 67.32, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 74.7, ["Mega"] = 213.68, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 131.06, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 113.24, ["Neon"] = 98.67, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 255.29, ["Mega|Ride"] = 315.16}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 7.93, ["Ride"] = 56.44, ["Neon"] = 202.11, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 794.07, ["Mega"] = 638.87, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 642.75}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.1, ["Ride"] = 42.74, ["Neon"] = 43.28, ["Neon|Ride"] = 106.84, ["Mega"] = 238.88, ["Mega|Ride"] = 361.6}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 3.61, ["Ride"] = 37.58, ["Fly|Ride"] = 120.75, ["Neon"] = 47.78, ["Neon|Ride"] = 32.51, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 378.19, ["Mega|Ride"] = 413.44, ["Mega|Fly|Ride"] = 444.29}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Ride"] = 28.86, ["Neon"] = 3.55, ["Neon|Ride"] = 65.02, ["Mega"] = 17.07, ["Mega|Fly"] = 122.88, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 231.95}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 44.63}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 5.83, ["Fly"] = 23.63, ["Ride"] = 20.99, ["Fly|Ride"] = 47.59, ["Neon"] = 42, ["Neon|Fly"] = 189, ["Neon|Ride"] = 51.03, ["Neon|Fly|Ride"] = 96.07, ["Mega"] = 272.44, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.79, ["Ride"] = 19.24, ["Fly|Ride"] = 85.46, ["Neon"] = 2.1, ["Neon|Fly"] = 52.8, ["Neon|Ride"] = 20.99, ["Neon|Fly|Ride"] = 104.9, ["Mega"] = 24.93, ["Mega|Fly"] = 143.17, ["Mega|Ride"] = 57.7, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 4.29, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 72.18, ["Mega"] = 32.51, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 115.96}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 44.71, ["Ride"] = 16.04, ["Fly|Ride"] = 27.8, ["Neon"] = 9.19, ["Neon|Ride"] = 29.89, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 106.78, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 169.24}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 2.4, ["Fly"] = 42.72, ["Ride"] = 85.46, ["Fly|Ride"] = 69.57, ["Neon"] = 47.72, ["Neon|Ride"] = 208.13, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 328.02, ["Mega|Ride"] = 365.37, ["Mega|Fly|Ride"] = 320.51}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 34.12, ["Neon"] = 2.1, ["Neon|Ride"] = 39.9, ["Mega"] = 19.68, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 52.41, ["Mega|Fly|Ride"] = 145.69}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 27.46, ["Ride"] = 17.07, ["Fly|Ride"] = 36.33, ["Neon"] = 3.94, ["Neon|Fly"] = 113.13, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 96.31, ["Mega"] = 30.19, ["Mega|Fly"] = 143.16, ["Mega|Ride"] = 38.07, ["Mega|Fly|Ride"] = 122.13}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 18.27, ["Fly|Ride"] = 42.74, ["Neon"] = 3.94, ["Neon|Fly"] = 52.58, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 61.11, ["Mega"] = 83.27, ["Mega|Fly"] = 143.17, ["Mega|Ride"] = 85.45, ["Mega|Fly|Ride"] = 85.45}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.61, ["Fly"] = 91.88, ["Ride"] = 19.69, ["Fly|Ride"] = 143.15, ["Neon"] = 6.45, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 106.81, ["Mega"] = 72.64, ["Mega|Ride"] = 116.87, ["Mega|Fly|Ride"] = 274.32}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Ride"] = 17.11, ["Neon"] = 2.1, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 155024.02, ["Mega"] = 15.75, ["Mega|Fly"] = 96.31, ["Mega|Ride"] = 86.99, ["Mega|Fly|Ride"] = 136.49}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.9, ["Ride"] = 19.68, ["Fly|Ride"] = 32.82, ["Neon"] = 2.63, ["Neon|Fly"] = 27.69, ["Neon|Ride"] = 25.66, ["Neon|Fly|Ride"] = 89.33, ["Mega"] = 20.39, ["Mega|Fly"] = 64.12, ["Mega|Ride"] = 39.16, ["Mega|Fly|Ride"] = 78.74}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 2.1, ["Neon|Fly|Ride"] = 114.33, ["Mega"] = 19.69, ["Mega|Ride"] = 150.94}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 6.17, ["Neon|Fly|Ride"] = 420, ["Mega"] = 51.18, ["Mega|Ride"] = 196.58, ["Mega|Fly|Ride"] = 153.86}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.65, ["Fly|Ride"] = 42, ["Neon"] = 2.1, ["Neon|Fly"] = 39.37, ["Neon|Ride"] = 17.35, ["Neon|Fly|Ride"] = 35.43, ["Mega"] = 36.75, ["Mega|Ride"] = 48.17, ["Mega|Fly|Ride"] = 107.57}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 19.68, ["Ride"] = 78.74, ["Fly|Ride"] = 213.65, ["Neon"] = 118.58, ["Neon|Ride"] = 90.27, ["Mega"] = 389.81, ["Mega|Ride"] = 669.38, ["Mega|Fly|Ride"] = 712.58}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 26.23, ["Neon"] = 39.38, ["Neon|Ride"] = 39.38, ["Mega"] = 183.75, ["Mega|Fly|Ride"] = 570.49}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 32.06, ["Fly|Ride"] = 175.2, ["Neon"] = 22.31, ["Neon|Ride"] = 28.86, ["Mega"] = 313.69, ["Mega|Ride"] = 271.36, ["Mega|Fly|Ride"] = 383.15}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 12.84, ["Fly|Ride"] = 28.71, ["Neon"] = 2.1, ["Neon|Fly"] = 18.38, ["Neon|Ride"] = 12.98, ["Neon|Fly|Ride"] = 28.88, ["Mega"] = 14.44, ["Mega|Fly"] = 104.98, ["Mega|Ride"] = 19.67, ["Mega|Fly|Ride"] = 58.65}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 59.8, ["Neon"] = 6.46, ["Neon|Fly"] = 68.38, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 712.58, ["Mega"] = 85.32, ["Mega|Ride"] = 143.17}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Fly"] = 71.58, ["Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 32.04, ["Neon|Ride"] = 22.91, ["Neon|Fly|Ride"] = 86.67, ["Mega"] = 13.11, ["Mega|Fly"] = 71.59, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.29, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 72.63, ["Mega"] = 22.31, ["Mega|Fly"] = 213.68, ["Mega|Fly|Ride"] = 367.49}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 126.29, ["Ride"] = 18.38, ["Fly|Ride"] = 56.67, ["Neon"] = 8.69, ["Neon|Fly"] = 71.04, ["Neon|Ride"] = 42.74, ["Neon|Fly|Ride"] = 85.47, ["Mega"] = 170.62, ["Mega|Ride"] = 160.13, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 164.07, ["Ride"] = 224.32, ["Fly|Ride"] = 852.42, ["Neon|Fly|Ride"] = 982.86, ["Mega"] = 8546.44, ["Mega|Fly|Ride"] = 4014.07}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 24.59, ["Neon"] = 6.91, ["Neon|Ride"] = 64.31, ["Mega"] = 68.25, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 2.85, ["Fly"] = 103.68, ["Ride"] = 24.69, ["Fly|Ride"] = 64.32, ["Neon"] = 32.49, ["Neon|Ride"] = 170.92, ["Neon|Fly|Ride"] = 143.17, ["Mega"] = 385.75, ["Mega|Ride"] = 221.48, ["Mega|Fly|Ride"] = 213.68}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 28.86, ["Ride"] = 15.73, ["Fly|Ride"] = 32.82, ["Neon"] = 4.14, ["Neon|Fly"] = 33.13, ["Neon|Ride"] = 30.08, ["Neon|Fly|Ride"] = 49.91, ["Mega"] = 49.67, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 127.15}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 71.58, ["Ride"] = 19.68, ["Fly|Ride"] = 92.6, ["Neon"] = 10.69, ["Neon|Ride"] = 73.83, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 77.35, ["Mega|Ride"] = 192.6, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 16.33, ["Fly|Ride"] = 37.9, ["Neon"] = 28.59, ["Neon|Fly"] = 100.37, ["Neon|Ride"] = 43.31, ["Neon|Fly|Ride"] = 65.63, ["Mega|Ride"] = 285.26, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 4.19, ["Ride"] = 34.32, ["Fly|Ride"] = 65.02, ["Neon"] = 49.07, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 164.53, ["Mega|Ride"] = 440.54, ["Mega|Fly|Ride"] = 387.18}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 15.56, ["Fly|Ride"] = 36.74, ["Neon"] = 22.32, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 41.58, ["Neon|Fly|Ride"] = 79.71, ["Mega"] = 262.5, ["Mega|Fly"] = 212.6, ["Mega|Ride"] = 370.71, ["Mega|Fly|Ride"] = 253.47}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 55.37, ["Ride"] = 84, ["Fly|Ride"] = 128.63, ["Neon"] = 341.24, ["Neon|Fly"] = 450.19, ["Neon|Ride"] = 418.59, ["Neon|Fly|Ride"] = 389.82, ["Mega|Fly|Ride"] = 1468.59}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 239.71, ["Fly"] = 427.28, ["Ride"] = 249.24, ["Fly|Ride"] = 265.13, ["Neon|Ride"] = 1124.21, ["Neon|Fly|Ride"] = 1115.63, ["Mega"] = 10683.04, ["Mega|Fly|Ride"] = 4558.46}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 59.07, ["Fly"] = 85.2, ["Ride"] = 76.13, ["Fly|Ride"] = 114.31, ["Neon"] = 481.53, ["Neon|Ride"] = 293.28, ["Neon|Fly|Ride"] = 347.82, ["Mega|Fly|Ride"] = 1489.14}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 3.32, ["Fly"] = 288, ["Ride"] = 23.63, ["Fly|Ride"] = 73.5, ["Neon"] = 41.68, ["Neon|Fly"] = 101.2, ["Neon|Ride"] = 99.75, ["Mega"] = 252.77, ["Mega|Ride"] = 190.31, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 11.82, ["Fly"] = 71.58, ["Ride"] = 28.87, ["Fly|Ride"] = 64.22, ["Neon"] = 61.06, ["Neon|Ride"] = 71.88, ["Neon|Fly|Ride"] = 143.17, ["Mega"] = 480.75, ["Mega|Ride"] = 390.67, ["Mega|Fly|Ride"] = 444.73}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 33.25, ["Ride"] = 15.74, ["Fly|Ride"] = 50.9, ["Neon"] = 3.04, ["Neon|Fly"] = 32.06, ["Neon|Ride"] = 20.89, ["Neon|Fly|Ride"] = 52.02, ["Mega"] = 32.51, ["Mega|Fly"] = 146.86, ["Mega|Ride"] = 213.68, ["Mega|Fly|Ride"] = 381.98}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.08, ["Fly"] = 39.38, ["Ride"] = 28.86, ["Fly|Ride"] = 66.25, ["Neon"] = 95.81, ["Neon|Fly"] = 285.22, ["Neon|Ride"] = 107.63, ["Neon|Fly|Ride"] = 252.13, ["Mega"] = 301.88, ["Mega|Ride"] = 481.46, ["Mega|Fly|Ride"] = 498.91}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.91, ["Ride"] = 15.74, ["Fly|Ride"] = 39.29, ["Neon"] = 13.99, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 27.8, ["Neon|Fly|Ride"] = 61.72, ["Mega"] = 131.25, ["Mega|Ride"] = 268.16, ["Mega|Fly|Ride"] = 271.36}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.34, ["Ride"] = 24.09, ["Fly|Ride"] = 328.13, ["Neon"] = 43.32, ["Neon|Ride"] = 36.33, ["Mega"] = 207.37, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 27.68, ["Ride"] = 19.37, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 57.74, ["Mega"] = 13.02, ["Mega|Fly"] = 31.5, ["Mega|Ride"] = 42.74, ["Mega|Fly|Ride"] = 78.73}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 19.07, ["Fly|Ride"] = 42.74, ["Neon"] = 10.08, ["Neon|Fly"] = 106.84, ["Neon|Ride"] = 35.26, ["Neon|Fly|Ride"] = 147, ["Mega"] = 78.72, ["Mega|Fly|Ride"] = 226.42}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 17.94, ["Fly|Ride"] = 63.03, ["Neon"] = 19.69, ["Neon|Ride"] = 47.25, ["Mega"] = 131.23, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 264.96}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 115.49, ["Fly"] = 179.29, ["Ride"] = 161.59, ["Fly|Ride"] = 199.5, ["Neon"] = 489.57, ["Neon|Fly"] = 642.85, ["Neon|Ride"] = 463.08, ["Neon|Fly|Ride"] = 534.19, ["Mega"] = 4273.23, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 8.56, ["Ride"] = 128.2, ["Fly|Ride"] = 128.83, ["Neon"] = 40.69, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 280.88, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 42.95, ["Ride"] = 19.25, ["Fly|Ride"] = 56.45, ["Neon"] = 13.44, ["Neon|Ride"] = 32.51, ["Neon|Fly|Ride"] = 120.65, ["Mega"] = 246.75, ["Mega|Ride"] = 187.69, ["Mega|Fly|Ride"] = 199.79}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 19.69, ["Ride"] = 45.94, ["Fly|Ride"] = 154.27, ["Neon"] = 90.75, ["Neon|Ride"] = 157.4, ["Neon|Fly|Ride"] = 711.51, ["Mega"] = 712.58, ["Mega|Fly"] = 854.65, ["Mega|Ride"] = 669.84, ["Mega|Fly|Ride"] = 818.48}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 2.1}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 3.82, ["Ride"] = 45.94, ["Fly|Ride"] = 127.13, ["Neon"] = 33.13, ["Neon|Fly"] = 89.25, ["Neon|Ride"] = 160.25, ["Neon|Fly|Ride"] = 327.98, ["Mega"] = 840.77, ["Mega|Ride"] = 584.38, ["Mega|Fly|Ride"] = 865.56}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 25.82, ["Fly"] = 41.99, ["Ride"] = 27.39, ["Fly|Ride"] = 65.14, ["Neon"] = 401.65, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 159.41, ["Neon|Fly|Ride"] = 177.08, ["Mega"] = 1379.19, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 27.8, ["Fly|Ride"] = 70.51, ["Neon"] = 3.65, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 27.88, ["Neon|Fly|Ride"] = 107.63, ["Mega"] = 31.17, ["Mega|Fly"] = 188.99, ["Mega|Ride"] = 79.73, ["Mega|Fly|Ride"] = 231.06}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 2.6, ["Fly"] = 32.55, ["Ride"] = 21.15, ["Fly|Ride"] = 65.54, ["Neon"] = 57.69, ["Neon|Ride"] = 64.11, ["Mega"] = 271.36, ["Mega|Fly"] = 402.02, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 471.14}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 28.95, ["Ride"] = 19.28, ["Fly|Ride"] = 44.01, ["Neon"] = 13.12, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 34.49, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 144.38, ["Mega|Ride"] = 213.65, ["Mega|Fly|Ride"] = 313.68}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 28.86, ["Neon"] = 3.38, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 40.85, ["Mega"] = 31.28, ["Mega|Ride"] = 70.52, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 25.99, ["Fly"] = 141.73, ["Ride"] = 85.46, ["Fly|Ride"] = 136.5, ["Neon"] = 180.55, ["Neon|Ride"] = 249.98, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 735, ["Mega|Ride"] = 689.06, ["Mega|Fly|Ride"] = 852.52}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 2.21, ["Ride"] = 47.25, ["Fly|Ride"] = 210, ["Neon"] = 96.32, ["Mega|Ride"] = 370.71, ["Mega|Fly|Ride"] = 321.39}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 2.1, ["Fly"] = 22.3, ["Ride"] = 18.38, ["Fly|Ride"] = 61.97, ["Neon"] = 22.43, ["Neon|Fly"] = 85.46, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 104.61, ["Mega"] = 196.23, ["Mega|Ride"] = 170.94, ["Mega|Fly|Ride"] = 290.07}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 42.74, ["Fly"] = 433.12, ["Ride"] = 128.2, ["Fly|Ride"] = 262.5, ["Neon"] = 18316.2, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 565.04, ["Mega"] = 4495.51, ["Mega|Ride"] = 2165.63, ["Mega|Fly|Ride"] = 2887.49}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 6.27, ["Fly"] = 45.65, ["Ride"] = 23.59, ["Fly|Ride"] = 67.43, ["Neon"] = 32.54, ["Neon|Ride"] = 57.69, ["Neon|Fly|Ride"] = 104.99, ["Mega"] = 278.45, ["Mega|Ride"] = 256.41, ["Mega|Fly|Ride"] = 398.99}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 72.17, ["Fly"] = 131.24, ["Ride"] = 108.35, ["Fly|Ride"] = 188.98, ["Neon"] = 223.13, ["Neon|Fly"] = 324.74, ["Neon|Ride"] = 231.2, ["Neon|Fly|Ride"] = 351.54, ["Mega"] = 1077.24, ["Mega|Ride"] = 1025.59, ["Mega|Fly|Ride"] = 1035.57}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 20.79, ["Fly"] = 170.92, ["Ride"] = 53.7, ["Fly|Ride"] = 149.56, ["Neon"] = 65.62, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 277.77, ["Mega"] = 463.65, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 712.58}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 7.33, ["Fly"] = 14.46, ["Ride"] = 25.66, ["Fly|Ride"] = 70.13, ["Neon"] = 145.68, ["Neon|Ride"] = 192.6, ["Neon|Fly|Ride"] = 382.76, ["Mega"] = 562.1, ["Mega|Ride"] = 568.36, ["Mega|Fly|Ride"] = 570.49}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 15.75, ["Fly"] = 75.86, ["Ride"] = 65.62, ["Fly|Ride"] = 102.37, ["Neon"] = 47.13, ["Neon|Fly"] = 120.38, ["Neon|Ride"] = 77.01, ["Neon|Fly|Ride"] = 438.38, ["Mega"] = 330.65, ["Mega|Ride"] = 347.82, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 5.78, ["Ride"] = 36.75, ["Neon"] = 42, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 145.69, ["Mega"] = 276.82, ["Mega|Ride"] = 278.27, ["Mega|Fly|Ride"] = 397.09}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Ride"] = 71.58, ["Neon"] = 2.1, ["Neon|Fly"] = 96.68, ["Neon|Ride"] = 23.52, ["Neon|Fly|Ride"] = 210, ["Mega"] = 19.66, ["Mega|Fly"] = 71.6, ["Mega|Ride"] = 143.17, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 2.6, ["Ride"] = 123.38, ["Neon"] = 32.82, ["Neon|Ride"] = 71.58, ["Mega"] = 236.24, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 524.54}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 127.13, ["Ride"] = 28.86, ["Neon"] = 6.57, ["Neon|Fly"] = 116.94, ["Neon|Ride"] = 100.43, ["Neon|Fly|Ride"] = 185.91, ["Mega"] = 210.67, ["Mega|Ride"] = 284.08, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 3.51, ["Ride"] = 32.8, ["Fly|Ride"] = 120.4, ["Neon"] = 18.04, ["Neon|Ride"] = 85.22, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 126.07, ["Mega|Ride"] = 285.26, ["Mega|Fly|Ride"] = 519.74}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 535.12, ["Ride"] = 524.99, ["Fly|Ride"] = 570.84, ["Neon"] = 1815.91, ["Neon|Fly"] = 1818.05, ["Neon|Ride"] = 1765.73, ["Neon|Fly|Ride"] = 1574.9, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 5.04, ["Fly"] = 45.47, ["Ride"] = 20.43, ["Fly|Ride"] = 56.94, ["Neon"] = 71.58, ["Neon|Ride"] = 57.69, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 213.68, ["Mega|Ride"] = 369.53, ["Mega|Fly|Ride"] = 353.62}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 5.13, ["Fly"] = 66.94, ["Ride"] = 20.93, ["Fly|Ride"] = 52.07, ["Neon"] = 85.31, ["Neon|Fly"] = 315, ["Neon|Ride"] = 77.68, ["Neon|Fly|Ride"] = 168.8, ["Mega"] = 331.87, ["Mega|Ride"] = 481.46, ["Mega|Fly|Ride"] = 681.45}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.1, ["Fly"] = 24.93, ["Ride"] = 21.38, ["Fly|Ride"] = 50.3, ["Neon|Ride"] = 42.09, ["Neon|Fly|Ride"] = 131.25}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 24.59, ["Fly|Ride"] = 89.15, ["Neon"] = 7.34, ["Neon|Fly"] = 19.69, ["Neon|Ride"] = 30.16, ["Neon|Fly|Ride"] = 141.03, ["Mega"] = 64.11, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 217.22}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 71.58, ["Ride"] = 17.07, ["Neon"] = 2.1, ["Neon|Ride"] = 24.45, ["Neon|Fly|Ride"] = 114.26, ["Mega"] = 28.86, ["Mega|Fly"] = 199.79, ["Mega|Ride"] = 86.52, ["Mega|Fly|Ride"] = 226.5}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1181.25}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 6.36, ["Ride"] = 32.45, ["Fly|Ride"] = 170.92, ["Neon"] = 68.16, ["Neon|Ride"] = 112.88, ["Mega"] = 400.63, ["Mega|Ride"] = 369.53, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 28.56, ["Neon"] = 3.94, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 997.21, ["Mega"] = 39.29, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 182.44}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.63, ["Fly"] = 318.7, ["Ride"] = 50.22, ["Fly|Ride"] = 65.63, ["Neon"] = 45.85, ["Neon|Ride"] = 170.52, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 258.57, ["Mega|Ride"] = 377.94, ["Mega|Fly|Ride"] = 1068.32}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 393.74, ["Ride"] = 446.23, ["Fly|Ride"] = 536.82, ["Neon|Ride"] = 1578.78, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 8012.29, ["Mega|Fly|Ride"] = 6164.82}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 5.79, ["Fly"] = 196.88, ["Ride"] = 26.25, ["Fly|Ride"] = 128.2, ["Neon"] = 71.54, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 192.6, ["Mega"] = 306.56, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 759.57}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 93.92, ["Ride"] = 28.88, ["Fly|Ride"] = 118.11, ["Neon"] = 3.32, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 40.3, ["Neon|Fly|Ride"] = 103.68, ["Mega"] = 36.38, ["Mega|Fly"] = 143.17, ["Mega|Ride"] = 76.13, ["Mega|Fly|Ride"] = 191.02}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 3.87, ["Neon|Ride"] = 143.15, ["Neon|Fly|Ride"] = 198.72, ["Mega"] = 35.44, ["Mega|Ride"] = 178.27, ["Mega|Fly|Ride"] = 209.98}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 18.38, ["Fly"] = 107.89, ["Ride"] = 42.67, ["Fly|Ride"] = 213.65, ["Neon"] = 153.57, ["Neon|Ride"] = 202.13, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 452.82, ["Mega|Ride"] = 627.12, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 11.82, ["Ride"] = 71.51, ["Neon"] = 93.92, ["Neon|Ride"] = 133.88, ["Neon|Fly|Ride"] = 854.65, ["Mega"] = 562.1, ["Mega|Ride"] = 482.35, ["Mega|Fly|Ride"] = 838.69}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 3.14, ["Ride"] = 28.86, ["Neon"] = 95.11, ["Neon|Ride"] = 198.8, ["Mega"] = 627.12, ["Mega|Ride"] = 641, ["Mega|Fly|Ride"] = 427.33}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 12.88, ["Ride"] = 25.91, ["Fly|Ride"] = 236.25, ["Neon"] = 167.28, ["Neon|Ride"] = 177.51, ["Neon|Fly|Ride"] = 241.5, ["Mega"] = 643.02, ["Mega|Ride"] = 528.83, ["Mega|Fly|Ride"] = 553.4}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 393.74, ["Ride"] = 423.05, ["Fly|Ride"] = 709.28, ["Neon"] = 1050, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1113, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 6.28, ["Fly"] = 91.88, ["Ride"] = 33.5, ["Fly|Ride"] = 71.57, ["Neon"] = 97.22, ["Neon|Ride"] = 131.25, ["Mega|Fly"] = 590.63, ["Mega|Ride"] = 561.1, ["Mega|Fly|Ride"] = 776.67}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 2.1, ["Ride"] = 42.68, ["Fly|Ride"] = 143.15, ["Neon"] = 51.45, ["Neon|Ride"] = 221.82, ["Mega"] = 168, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 25.99, ["Fly"] = 341.83, ["Ride"] = 101.07, ["Fly|Ride"] = 143.15, ["Neon"] = 135.09, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 288.53, ["Mega"] = 390.74, ["Mega|Ride"] = 396.37, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Fly|Ride"] = 75.86, ["Neon"] = 7.88, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 276.71, ["Mega"] = 43.31, ["Mega|Fly"] = 189, ["Mega|Ride"] = 380.34, ["Mega|Fly|Ride"] = 280.88}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 42.75, ["Ride"] = 79.06, ["Neon"] = 248.07, ["Neon|Ride"] = 320.46, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1624.89, ["Mega|Ride"] = 2828.88, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 56.44, ["Ride"] = 28.52, ["Fly|Ride"] = 262.5, ["Neon"] = 9.08, ["Neon|Fly"] = 185.88, ["Neon|Ride"] = 37.41, ["Neon|Fly|Ride"] = 99.51, ["Mega"] = 65.62, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 207.26}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 28.86, ["Ride"] = 28.88, ["Fly|Ride"] = 98.73, ["Neon"] = 3.31, ["Neon|Fly"] = 49.16, ["Neon|Ride"] = 51.18, ["Neon|Fly|Ride"] = 105, ["Mega"] = 30.34, ["Mega|Fly"] = 112.88, ["Mega|Ride"] = 143.17, ["Mega|Fly|Ride"] = 284.71}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 37.96, ["Fly|Ride"] = 131.07, ["Neon"] = 11.82, ["Neon|Ride"] = 53.43, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 79.1, ["Mega|Ride"] = 125.9, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 49.89, ["Fly"] = 65.61, ["Ride"] = 61.57, ["Fly|Ride"] = 236.25, ["Neon"] = 190.32, ["Neon|Ride"] = 347.33, ["Neon|Fly|Ride"] = 481.46, ["Mega|Ride"] = 1139.88, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 196.88, ["Ride"] = 328.11, ["Fly|Ride"] = 1068.19, ["Neon"] = 1709.09, ["Neon|Ride"] = 1567.04, ["Neon|Fly|Ride"] = 1781.73, ["Mega"] = 12819.65, ["Mega|Fly|Ride"] = 9971.56}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 3.94, ["Neon"] = 21, ["Neon|Fly"] = 350.44, ["Mega"] = 137.82, ["Mega|Ride"] = 213.3, ["Mega|Fly|Ride"] = 280.88}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 21, ["Neon"] = 8.54, ["Neon|Ride"] = 45.55, ["Neon|Fly|Ride"] = 170.94, ["Mega"] = 38.74, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 241.4}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.1, ["Fly"] = 106.84, ["Ride"] = 28.86, ["Fly|Ride"] = 98.44, ["Neon"] = 32.81, ["Mega"] = 299.14, ["Mega|Ride"] = 351.56, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 7.41, ["Fly"] = 98.44, ["Ride"] = 35.26, ["Fly|Ride"] = 128.2, ["Neon"] = 22.32, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 139.02, ["Mega"] = 150.84, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 187.3, ["Mega|Fly|Ride"] = 347.82}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 94.01, ["Neon"] = 8.59, ["Neon|Ride"] = 143.15, ["Neon|Fly|Ride"] = 143.17, ["Mega"] = 35.28, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 399.56}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.18, ["Fly|Ride"] = 52.5, ["Neon"] = 3.9, ["Neon|Fly"] = 80.66, ["Neon|Ride"] = 28.25, ["Neon|Fly|Ride"] = 106.85, ["Mega"] = 39.81, ["Mega|Ride"] = 99.68, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 28.86, ["Ride"] = 21.99, ["Fly|Ride"] = 57.69, ["Neon"] = 15.43, ["Neon|Fly"] = 101.49, ["Neon|Ride"] = 40.37, ["Neon|Fly|Ride"] = 106.85, ["Mega"] = 156.15, ["Mega|Ride"] = 141.74, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 25.97, ["Ride"] = 38.07, ["Fly|Ride"] = 78.75, ["Neon"] = 144.34, ["Neon|Ride"] = 240.74, ["Mega"] = 459.38, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 651}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 74.82, ["Ride"] = 80.67, ["Fly|Ride"] = 139.13, ["Neon"] = 427.28, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 367.49, ["Neon|Fly|Ride"] = 464.63, ["Mega"] = 1995.61, ["Mega|Ride"] = 1600.33, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 19.38, ["Fly|Ride"] = 131.25, ["Neon"] = 3.14, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 28.86, ["Neon|Fly|Ride"] = 143.06, ["Mega"] = 32.85, ["Mega|Fly"] = 672, ["Mega|Ride"] = 92.42, ["Mega|Fly|Ride"] = 250}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 16.99, ["Ride"] = 15.75, ["Fly|Ride"] = 42.74, ["Neon"] = 3.56, ["Neon|Fly"] = 28.86, ["Neon|Ride"] = 20.89, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 45.94, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 68.39, ["Mega|Fly|Ride"] = 91.87}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 3.94, ["Fly"] = 50.22, ["Ride"] = 38.03, ["Fly|Ride"] = 52.5, ["Neon"] = 51.78, ["Neon|Ride"] = 144.45, ["Mega"] = 541.65, ["Mega|Ride"] = 275.62, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.75, ["Ride"] = 496.49, ["Fly|Ride"] = 446.25, ["Neon"] = 4272.72, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 18.38, ["Fly"] = 100.43, ["Ride"] = 36.75, ["Fly|Ride"] = 78.75, ["Neon"] = 198.7, ["Neon|Ride"] = 192.93, ["Neon|Fly|Ride"] = 213.68, ["Mega|Ride"] = 995.68, ["Mega|Fly|Ride"] = 1764.51}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 25.86, ["Fly|Ride"] = 284, ["Neon"] = 9.18, ["Neon|Ride"] = 49.25, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 134.63, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 238.25}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 83.85, ["Ride"] = 51.28, ["Fly|Ride"] = 103.69, ["Neon"] = 65.4, ["Neon|Ride"] = 72.34, ["Mega"] = 118.13, ["Mega|Fly|Ride"] = 319.45}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 78.66, ["Fly"] = 169.31, ["Ride"] = 35.06, ["Fly|Ride"] = 143.15, ["Neon"] = 194.25, ["Neon|Ride"] = 211.32, ["Neon|Fly|Ride"] = 315.16, ["Mega"] = 2563.95, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1002.75}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 110.22, ["Fly"] = 142.96, ["Ride"] = 116.94, ["Fly|Ride"] = 190.32, ["Neon"] = 388.85, ["Neon|Fly"] = 811.82, ["Neon|Ride"] = 497.79, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 8546.44, ["Mega|Fly|Ride"] = 2572.5}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 239.09, ["Ride"] = 274.32, ["Fly|Ride"] = 533.04, ["Neon"] = 938.44, ["Neon|Ride"] = 800.63, ["Neon|Fly|Ride"] = 918.75, ["Mega|Fly|Ride"] = 3691.49}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 10.5, ["Ride"] = 55.13, ["Fly|Ride"] = 51.19, ["Neon"] = 65.54, ["Neon|Ride"] = 119.18, ["Neon|Fly|Ride"] = 199.79, ["Mega"] = 459.38, ["Mega|Ride"] = 404.25, ["Mega|Fly|Ride"] = 1068.32}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.85, ["Ride"] = 14.44, ["Fly|Ride"] = 43.32, ["Neon"] = 7.88, ["Neon|Ride"] = 27.46, ["Neon|Fly|Ride"] = 84, ["Mega"] = 93.09, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 187.94}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 20.21, ["Fly|Ride"] = 47.25, ["Neon"] = 24.45, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 40.61, ["Neon|Fly|Ride"] = 109.82, ["Mega"] = 288.7, ["Mega|Ride"] = 244.34, ["Mega|Fly|Ride"] = 333.33}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 347.01, ["Ride"] = 336.6, ["Fly|Ride"] = 746.67, ["Neon"] = 1569.1, ["Neon|Fly|Ride"] = 2136.62, ["Mega"] = 10255.73, ["Mega|Fly|Ride"] = 5730.82}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Neon"] = 8.71, ["Neon|Ride"] = 139.41, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 32.82, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 465.73}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.94, ["Ride"] = 17.05, ["Fly|Ride"] = 39.37, ["Neon"] = 19.68, ["Neon|Ride"] = 38.03, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 205.13, ["Mega|Ride"] = 216.67, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 14.97, ["Ride"] = 85.46, ["Fly|Ride"] = 128.2, ["Neon"] = 92.96, ["Neon|Fly"] = 427.28, ["Neon|Ride"] = 108.43, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 544.59, ["Mega|Ride"] = 595.81, ["Mega|Fly|Ride"] = 692.51}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 114.19, ["Fly"] = 157.5, ["Ride"] = 123.31, ["Fly|Ride"] = 136.5, ["Neon|Ride"] = 794.41, ["Neon|Fly|Ride"] = 639.93, ["Mega|Fly|Ride"] = 3248.44}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 19.69, ["Fly"] = 24.47, ["Ride"] = 28.14, ["Fly|Ride"] = 50.92, ["Neon"] = 134.29, ["Neon|Ride"] = 104.98, ["Neon|Fly|Ride"] = 122.59, ["Mega"] = 875.44, ["Mega|Ride"] = 422.63, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 51.3, ["Neon"] = 3.46, ["Neon|Ride"] = 74.59, ["Mega"] = 34.12, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 16.04, ["Fly|Ride"] = 26.25, ["Neon"] = 2.62, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 24.59, ["Neon|Fly|Ride"] = 85.19, ["Mega"] = 18.08, ["Mega|Fly"] = 97.13, ["Mega|Ride"] = 47.58, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 11.68, ["Ride"] = 74.55, ["Fly|Ride"] = 131.25, ["Neon"] = 31.15, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 231, ["Mega"] = 179.82, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 324.07}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1291.5, ["Ride"] = 1286.25, ["Fly|Ride"] = 1431.94, ["Neon|Ride"] = 7121.55, ["Neon|Fly|Ride"] = 4753.96, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 443.63, ["Ride"] = 452.34, ["Fly|Ride"] = 576.19, ["Neon"] = 1680, ["Neon|Ride"] = 2563.64, ["Neon|Fly|Ride"] = 1753.5, ["Mega"] = 17092.86, ["Mega|Fly|Ride"] = 7549.71}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 308.44, ["Fly"] = 393.75, ["Ride"] = 341.24, ["Fly|Ride"] = 418.69, ["Neon"] = 746.67, ["Neon|Fly"] = 850.97, ["Neon|Ride"] = 673.2, ["Neon|Fly|Ride"] = 786.18, ["Mega|Fly|Ride"] = 2916.23}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 230.96, ["Fly"] = 498.85, ["Ride"] = 259.88, ["Fly|Ride"] = 354.27, ["Neon"] = 647.09, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 735, ["Mega|Fly|Ride"] = 2977.37}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 34.55, ["Ride"] = 16.04, ["Fly|Ride"] = 42, ["Neon"] = 7.4, ["Neon|Ride"] = 29.23, ["Neon|Fly|Ride"] = 102.58, ["Mega"] = 69.57, ["Mega|Ride"] = 113.26, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 246.75, ["Fly"] = 288.75, ["Ride"] = 342.57, ["Fly|Ride"] = 570.42, ["Neon"] = 1495.47, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1223.3, ["Mega"] = 21651.32, ["Mega|Ride"] = 5127.88, ["Mega|Fly|Ride"] = 4593.75}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 3.3, ["Fly"] = 157.5, ["Ride"] = 70.51, ["Fly|Ride"] = 161.33, ["Neon"] = 29.69, ["Neon|Ride"] = 115.9, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 175.86, ["Mega|Ride"] = 341.16, ["Mega|Fly|Ride"] = 315.06}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 19.67, ["Ride"] = 17.11, ["Fly|Ride"] = 38.58, ["Neon"] = 7.88, ["Neon|Ride"] = 50.22, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 117.08, ["Mega|Ride"] = 192.31}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 56.6, ["Neon"] = 2.63, ["Neon|Ride"] = 46.73, ["Mega"] = 34.04, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 177.62}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 26.24, ["Ride"] = 57.73, ["Fly|Ride"] = 459.38, ["Neon"] = 199.5, ["Neon|Ride"] = 356.79, ["Mega"] = 1050, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 8026.06, ["Ride"] = 26.51, ["Fly|Ride"] = 68.25, ["Neon"] = 16.28, ["Neon|Ride"] = 61.13, ["Mega"] = 354.68, ["Mega|Ride"] = 300.53, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 2.1, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 141.93, ["Mega"] = 23.52, ["Mega|Ride"] = 70.49, ["Mega|Fly|Ride"] = 158.12}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 3.34, ["Fly"] = 85.35, ["Ride"] = 34.13, ["Fly|Ride"] = 72.19, ["Neon"] = 24.05, ["Neon|Fly"] = 114.28, ["Neon|Ride"] = 52.73, ["Neon|Fly|Ride"] = 161.3, ["Mega"] = 144.45, ["Mega|Ride"] = 153.46, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 2.63, ["Fly"] = 44.88, ["Ride"] = 19.23, ["Fly|Ride"] = 50.85, ["Neon"] = 37.41, ["Neon|Fly"] = 144.47, ["Neon|Ride"] = 143.15, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 238.83, ["Mega|Ride"] = 251.07, ["Mega|Fly|Ride"] = 1321.69}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 19.95, ["Ride"] = 38.05, ["Fly|Ride"] = 105, ["Neon"] = 92.95, ["Neon|Ride"] = 185.88, ["Neon|Fly|Ride"] = 321.39, ["Mega"] = 427.33, ["Mega|Ride"] = 800.17}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 6421.13, ["Ride"] = 17.07, ["Fly|Ride"] = 126, ["Neon"] = 51.44, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 285.26, ["Mega"] = 334.69, ["Mega|Ride"] = 481.46, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 66.69, ["Ride"] = 16.34, ["Fly|Ride"] = 45.94, ["Neon"] = 2.61, ["Neon|Fly"] = 82.48, ["Neon|Ride"] = 27.66, ["Neon|Fly|Ride"] = 114.33, ["Mega"] = 49.88, ["Mega|Fly|Ride"] = 225.08}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 163.59, ["Fly"] = 228.6, ["Ride"] = 164.05, ["Fly|Ride"] = 256.37, ["Neon"] = 968.85, ["Neon|Ride"] = 997.69, ["Neon|Fly|Ride"] = 840, ["Mega"] = 8546.44, ["Mega|Ride"] = 3845.91, ["Mega|Fly|Ride"] = 3990.13}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 15.74, ["Fly|Ride"] = 36.75, ["Neon"] = 3.29, ["Neon|Fly"] = 36.12, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 49.53, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 75.87}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 6.48, ["Ride"] = 40.46, ["Fly|Ride"] = 228.6, ["Neon"] = 64.58, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 770.33, ["Mega"] = 313.69, ["Mega|Ride"] = 352.06, ["Mega|Fly|Ride"] = 379.32}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 22.52, ["Ride"] = 86.63, ["Fly|Ride"] = 183.75, ["Neon"] = 157.5, ["Neon|Ride"] = 285.22, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 786.19, ["Mega|Ride"] = 901.95, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 196.76, ["Fly"] = 305.79, ["Ride"] = 256.37, ["Fly|Ride"] = 312.38, ["Neon"] = 812.4, ["Neon|Ride"] = 702.18, ["Neon|Fly|Ride"] = 780.95, ["Mega|Fly|Ride"] = 3490.16}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 30.19, ["Ride"] = 161.33, ["Fly|Ride"] = 144.47, ["Neon"] = 124.68, ["Neon|Ride"] = 145.34, ["Neon|Fly|Ride"] = 427.33, ["Mega"] = 242.52, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 356.83}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 5.78, ["Fly"] = 96.32, ["Ride"] = 43.37, ["Fly|Ride"] = 71.58, ["Neon"] = 131.25, ["Neon|Fly"] = 161.33, ["Neon|Ride"] = 321.39, ["Neon|Fly|Ride"] = 210, ["Mega"] = 1139.88, ["Mega|Ride"] = 854.65, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 930.56, ["Fly"] = 1264.73, ["Ride"] = 1007.88, ["Fly|Ride"] = 969.94, ["Neon|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 5127.88, ["Mega|Fly|Ride"] = 16381.38}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 6.11, ["Fly"] = 23.73, ["Ride"] = 21.56, ["Fly|Ride"] = 61.97, ["Neon"] = 47.23, ["Neon|Fly"] = 76.43, ["Neon|Ride"] = 49.13, ["Neon|Fly|Ride"] = 202.13, ["Mega"] = 240.74, ["Mega|Ride"] = 285.26, ["Mega|Fly|Ride"] = 346.49}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 2.59, ["Fly"] = 78.75, ["Ride"] = 49.88, ["Fly|Ride"] = 135.19, ["Neon"] = 27.57, ["Neon|Ride"] = 96.22, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 211.32, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 309.82, ["Mega|Fly|Ride"] = 422}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 85.46, ["Ride"] = 24.32, ["Fly|Ride"] = 143.15, ["Neon"] = 10.85, ["Neon|Ride"] = 46.95, ["Mega"] = 90.91, ["Mega|Ride"] = 360.34, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 15.75, ["Fly"] = 57.69, ["Ride"] = 41.58, ["Fly|Ride"] = 95.92, ["Neon"] = 72.18, ["Neon|Fly"] = 188.36, ["Neon|Ride"] = 96.36, ["Neon|Fly|Ride"] = 180.36, ["Mega"] = 446.22, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 461.75}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.34, ["Fly"] = 18.08, ["Ride"] = 20.31, ["Fly|Ride"] = 45.85, ["Neon"] = 13.02, ["Neon|Fly"] = 42.74, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 131.25, ["Mega|Fly"] = 280.98, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 166.79}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Neon"] = 10.5, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 48.17, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 124.38, ["Mega|Ride"] = 166.67}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 240.64, ["Ride"] = 267.06, ["Fly|Ride"] = 427.28, ["Neon"] = 925.05, ["Neon|Fly|Ride"] = 1183.01, ["Mega|Fly|Ride"] = 3880.09}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.81, ["Ride"] = 26.17, ["Fly|Ride"] = 110.25, ["Neon"] = 3.93, ["Neon|Fly"] = 42.74, ["Neon|Ride"] = 39.29, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 61.69, ["Mega|Ride"] = 127.37, ["Mega|Fly|Ride"] = 341.87}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.43, ["Ride"] = 33.13, ["Fly|Ride"] = 88.86, ["Neon"] = 21.38, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27, ["Mega"] = 170.94, ["Mega|Ride"] = 321.39, ["Mega|Fly|Ride"] = 192.6}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.94, ["Fly"] = 94.74, ["Ride"] = 25.73, ["Neon"] = 14.15, ["Neon|Ride"] = 71.58, ["Mega"] = 94.31, ["Mega|Ride"] = 120.53, ["Mega|Fly|Ride"] = 504.2}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 78.66, ["Ride"] = 128.63, ["Fly|Ride"] = 249.38, ["Neon"] = 315, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 545.35, ["Mega"] = 2563.95, ["Mega|Ride"] = 1567.21, ["Mega|Fly|Ride"] = 1794.77}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 28.58, ["Fly"] = 88.08, ["Ride"] = 47.91, ["Fly|Ride"] = 264.92, ["Neon"] = 181.13, ["Neon|Ride"] = 158.1, ["Neon|Fly|Ride"] = 341.93, ["Mega"] = 642.75, ["Mega|Ride"] = 621.76, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 18.38, ["Fly"] = 57.69, ["Ride"] = 39.37, ["Fly|Ride"] = 97.13, ["Neon"] = 81.38, ["Neon|Ride"] = 127.94, ["Neon|Fly|Ride"] = 252.14, ["Mega"] = 457.25, ["Mega|Ride"] = 435.75, ["Mega|Fly|Ride"] = 497.44}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 72.36, ["Neon"] = 3.78, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 236.15, ["Mega"] = 131.24, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 554.47}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 35.44, ["Fly"] = 87.25, ["Ride"] = 83.46, ["Fly|Ride"] = 104.99, ["Neon"] = 262.5, ["Neon|Fly"] = 245.44, ["Neon|Ride"] = 285.22, ["Neon|Fly|Ride"] = 312.38, ["Mega|Fly|Ride"] = 962.91}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 52.5, ["Neon"] = 3.82, ["Neon|Ride"] = 57.69, ["Neon|Fly|Ride"] = 127.15, ["Mega"] = 60.9, ["Mega|Ride"] = 284.19, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 17.07, ["Fly"] = 128.83, ["Ride"] = 32.15, ["Fly|Ride"] = 86.68, ["Neon"] = 83.55, ["Neon|Ride"] = 99.92, ["Neon|Fly|Ride"] = 220.08, ["Mega"] = 360.7, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 426.27, ["Mega|Fly|Ride"] = 428.74}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 49.87, ["Fly"] = 203.41, ["Ride"] = 70.88, ["Fly|Ride"] = 136.36, ["Neon"] = 249.38, ["Neon|Fly"] = 427.28, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 427.33, ["Mega|Ride"] = 1461.46, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 15.94, ["Ride"] = 15.94, ["Fly|Ride"] = 35.42, ["Neon"] = 2.1, ["Neon|Fly"] = 24.49, ["Neon|Ride"] = 16.06, ["Neon|Fly|Ride"] = 42.76, ["Mega"] = 17, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 40.58, ["Mega|Fly|Ride"] = 88.89}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 26.25, ["Neon|Ride"] = 65.61, ["Neon|Fly|Ride"] = 167.99, ["Mega"] = 228.38, ["Mega|Ride"] = 150.94, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 11.65, ["Fly"] = 143.15, ["Ride"] = 41.56, ["Fly|Ride"] = 71.58, ["Neon"] = 110.25, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 272.76, ["Mega"] = 635.66, ["Mega|Ride"] = 454.77, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Neon"] = 2.1, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 95.81, ["Mega"] = 17.07, ["Mega|Ride"] = 52.58, ["Mega|Fly|Ride"] = 213.68}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 19.69, ["Fly"] = 207.9, ["Ride"] = 78.66, ["Fly|Ride"] = 187.13, ["Neon"] = 131.14, ["Neon|Ride"] = 173.36, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 617.72, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 590.03, ["Mega|Fly|Ride"] = 784.14}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 9.08, ["Fly"] = 42.74, ["Ride"] = 21.38, ["Fly|Ride"] = 88.68, ["Neon"] = 376.69, ["Neon|Ride"] = 120.59, ["Neon|Fly|Ride"] = 164.53, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 485.03}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 4.6, ["Ride"] = 49.88, ["Neon"] = 56.43, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 76.67, ["Neon|Fly|Ride"] = 712.58, ["Mega"] = 232.98, ["Mega|Ride"] = 312.96, ["Mega|Fly|Ride"] = 426.27}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 7.88, ["Fly"] = 65.63, ["Ride"] = 70.55, ["Fly|Ride"] = 234.94, ["Neon"] = 54.9, ["Neon|Ride"] = 88.91, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 213.7, ["Mega|Ride"] = 442.32, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 42.74, ["Ride"] = 15.75, ["Fly|Ride"] = 196.88, ["Neon"] = 3.83, ["Neon|Ride"] = 34.92, ["Mega"] = 53.82, ["Mega|Fly"] = 213.68, ["Mega|Ride"] = 96.31, ["Mega|Fly|Ride"] = 285.26}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 57.8, ["Neon"] = 6.57, ["Neon|Fly|Ride"] = 145.29, ["Mega"] = 44.63, ["Mega|Ride"] = 99.65, ["Mega|Fly|Ride"] = 195.33}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 16.96}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 38.05, ["Fly"] = 100.43, ["Ride"] = 66.94, ["Fly|Ride"] = 80.13, ["Neon"] = 196.88, ["Neon|Ride"] = 213.65, ["Neon|Fly|Ride"] = 315, ["Mega"] = 1852.45, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 853.58}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.29, ["Neon|Ride"] = 27.57, ["Mega"] = 23.51, ["Mega|Ride"] = 121.79, ["Mega|Fly|Ride"] = 320.51}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 525, ["Fly"] = 570.42, ["Ride"] = 561.75, ["Fly|Ride"] = 578.97, ["Neon"] = 2848.84, ["Neon|Ride"] = 2670.46, ["Neon|Fly|Ride"] = 2132.34, ["Mega"] = 17092.86, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 3.94, ["Fly"] = 48.37, ["Ride"] = 33.72, ["Fly|Ride"] = 40.94, ["Neon"] = 9.81, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 114.31, ["Mega"] = 240.64, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 627.12}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.1, ["Fly"] = 28.86, ["Ride"] = 17.89, ["Fly|Ride"] = 57.75, ["Neon"] = 24.94, ["Neon|Ride"] = 64.11, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 128.8, ["Mega|Fly"] = 285.26, ["Mega|Ride"] = 164.53, ["Mega|Fly|Ride"] = 216.56}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 11.34, ["Ride"] = 28.86, ["Fly|Ride"] = 534.1, ["Neon"] = 112.87, ["Neon|Ride"] = 143.15, ["Mega"] = 642.75, ["Mega|Ride"] = 539.23, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.1, ["Fly"] = 427.28, ["Ride"] = 38.57, ["Fly|Ride"] = 712.48, ["Neon"] = 30.35, ["Neon|Fly"] = 50.22, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 280.23, ["Mega|Fly|Ride"] = 497.85}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 8.99, ["Ride"] = 73.49, ["Fly|Ride"] = 71.58, ["Neon"] = 53.45, ["Neon|Ride"] = 137.57, ["Neon|Fly|Ride"] = 273.02, ["Mega"] = 552.57, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 586.18}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 5.25, ["Ride"] = 28.44, ["Fly|Ride"] = 91.88, ["Neon"] = 28.07, ["Neon|Ride"] = 81.2, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 222.9, ["Mega|Ride"] = 324.7, ["Mega|Fly|Ride"] = 349.13}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 45.76, ["Ride"] = 13.55, ["Fly|Ride"] = 85.46, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 16.04, ["Neon|Fly|Ride"] = 48.17, ["Mega"] = 13.23, ["Mega|Fly"] = 65.01, ["Mega|Ride"] = 49.16, ["Mega|Fly|Ride"] = 100.12}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 6.56, ["Fly"] = 26.25, ["Ride"] = 38.47, ["Fly|Ride"] = 106.84, ["Neon"] = 25.03, ["Neon|Fly"] = 120.38, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 165.8, ["Mega"] = 196.88, ["Mega|Ride"] = 213.57, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 259.87, ["Ride"] = 345.96, ["Fly|Ride"] = 366.19, ["Neon"] = 1312.5, ["Neon|Ride"] = 1094.63, ["Neon|Fly|Ride"] = 1050, ["Mega|Ride"] = 9340.05, ["Mega|Fly|Ride"] = 3425.63}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 80.07, ["Ride"] = 122.07, ["Fly|Ride"] = 255.31, ["Neon"] = 458.07, ["Neon|Fly"] = 914.38, ["Neon|Ride"] = 446.25, ["Neon|Fly|Ride"] = 641, ["Mega"] = 2279.76, ["Mega|Ride"] = 1702.88, ["Mega|Fly|Ride"] = 1827}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 16.22, ["Fly|Ride"] = 35.44, ["Neon"] = 6.12, ["Neon|Fly"] = 42.35, ["Neon|Ride"] = 34.19, ["Neon|Fly|Ride"] = 64.12, ["Mega"] = 143.17, ["Mega|Fly"] = 212.6, ["Mega|Ride"] = 100.37, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 22.58, ["Ride"] = 11.82, ["Fly|Ride"] = 28.55, ["Neon"] = 10.28, ["Neon|Fly"] = 38.47, ["Neon|Ride"] = 26.9, ["Neon|Fly|Ride"] = 59.37, ["Mega"] = 76.94, ["Mega|Fly"] = 285.26, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 143.16}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Fly"] = 100.43, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 100.29, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 332.05, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 209.98, ["Fly"] = 321.44, ["Ride"] = 238.25, ["Fly|Ride"] = 288.75, ["Neon"] = 1175.01, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1175.14, ["Mega|Ride"] = 8546.44, ["Mega|Fly|Ride"] = 3806.25}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 14.44, ["Fly|Ride"] = 47.25, ["Neon"] = 18.27, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 76.04, ["Mega"] = 255.94, ["Mega|Ride"] = 221.82, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 2.46, ["Ride"] = 77.09, ["Fly|Ride"] = 213.65, ["Neon"] = 25.98, ["Neon|Ride"] = 106.84, ["Neon|Fly|Ride"] = 285.26, ["Mega"] = 118.13, ["Mega|Ride"] = 300.56, ["Mega|Fly|Ride"] = 421.29}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 91.49, ["Neon"] = 7.6, ["Neon|Ride"] = 137.82, ["Mega"] = 98.44, ["Mega|Ride"] = 337.02, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 12.97, ["Fly"] = 48.15, ["Ride"] = 25.64, ["Fly|Ride"] = 65.63, ["Neon"] = 149.49, ["Neon|Ride"] = 113.15, ["Neon|Fly|Ride"] = 236.11, ["Mega"] = 460.69, ["Mega|Ride"] = 456.75, ["Mega|Fly|Ride"] = 590.52}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 32.82, ["Ride"] = 86.63, ["Fly|Ride"] = 392.03, ["Neon"] = 136.63, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 136.49, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 509.77, ["Mega|Fly"] = 2243.45, ["Mega|Ride"] = 524.65, ["Mega|Fly|Ride"] = 621.1}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 23.63, ["Ride"] = 40.35, ["Fly|Ride"] = 91.77, ["Neon"] = 161.33, ["Neon|Fly"] = 286.43, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 854.65, ["Mega|Ride"] = 700.88, ["Mega|Fly|Ride"] = 801.25}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 17.05, ["Ride"] = 14.44, ["Fly|Ride"] = 28.88, ["Neon"] = 2.1, ["Neon|Fly"] = 31.47, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 48.57, ["Mega"] = 20.99, ["Mega|Fly"] = 427.33, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 94.23}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 203.44, ["Ride"] = 206.06, ["Fly|Ride"] = 272.62, ["Neon"] = 3370.68, ["Neon|Fly|Ride"] = 941.19, ["Mega|Fly|Ride"] = 4273.23}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 9.19, ["Fly"] = 77.44, ["Ride"] = 20.33, ["Fly|Ride"] = 92.94, ["Neon"] = 161.16, ["Neon|Ride"] = 112.35, ["Neon|Fly|Ride"] = 427.33, ["Mega"] = 422.63, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 35.98, ["Ride"] = 18.76, ["Fly|Ride"] = 43.35, ["Neon"] = 5.34, ["Neon|Fly"] = 41.93, ["Neon|Ride"] = 28.86, ["Neon|Fly|Ride"] = 102.38, ["Mega"] = 61.4, ["Mega|Fly"] = 222.23, ["Mega|Ride"] = 85.47, ["Mega|Fly|Ride"] = 232.91}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.14, ["Fly|Ride"] = 76.9, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 128.8, ["Mega"] = 24.54, ["Mega|Fly"] = 143.17, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 28.58, ["Fly|Ride"] = 72.19, ["Neon"] = 10.18, ["Neon|Fly"] = 722.3, ["Neon|Ride"] = 49.88, ["Mega"] = 129.94, ["Mega|Ride"] = 131.78, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 8.65, ["Fly"] = 47.16, ["Ride"] = 24.91, ["Fly|Ride"] = 70.87, ["Neon"] = 46.46, ["Neon|Fly"] = 271.34, ["Neon|Ride"] = 60.19, ["Neon|Fly|Ride"] = 107.63, ["Mega"] = 601.81, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 4.73, ["Ride"] = 44.88, ["Neon"] = 65.63, ["Neon|Ride"] = 149.56, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 275.63, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 481.46}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 34.13, ["Neon"] = 3.93, ["Neon|Ride"] = 26.16, ["Neon|Fly|Ride"] = 100.37, ["Mega"] = 23.62, ["Mega|Ride"] = 122.88, ["Mega|Fly|Ride"] = 121.38}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 6.33, ["Ride"] = 28.46, ["Fly|Ride"] = 143.15, ["Neon"] = 34.41, ["Neon|Fly"] = 96.32, ["Neon|Ride"] = 47.13, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 156.19, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 43.35, ["Neon"] = 3.66, ["Neon|Fly"] = 114.31, ["Neon|Ride"] = 54.49, ["Neon|Fly|Ride"] = 105, ["Mega"] = 23.55, ["Mega|Ride"] = 98.04, ["Mega|Fly|Ride"] = 321.26}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 48.38, ["Ride"] = 18.08, ["Fly|Ride"] = 40.94, ["Neon"] = 5.04, ["Neon|Ride"] = 26.65, ["Neon|Fly|Ride"] = 128.21, ["Mega"] = 63.04, ["Mega|Ride"] = 77.9, ["Mega|Fly|Ride"] = 240.74}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 629.9, ["Ride"] = 721.88, ["Fly|Ride"] = 761.25, ["Neon|Ride"] = 2913.75, ["Neon|Fly|Ride"] = 3675, ["Mega|Fly|Ride"] = 9620.63}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 18.05, ["Fly|Ride"] = 42.67, ["Neon"] = 17.07, ["Neon|Fly"] = 42.74, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 191.24, ["Mega|Fly|Ride"] = 393.6}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 51.19, ["Neon"] = 14.44, ["Neon|Fly"] = 747.74, ["Neon|Ride"] = 84.89, ["Neon|Fly|Ride"] = 185.91, ["Mega"] = 61.2, ["Mega|Fly"] = 190.18, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 257.27}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 5.24, ["Fly"] = 26.25, ["Ride"] = 21, ["Fly|Ride"] = 57.6, ["Neon"] = 41.46, ["Neon|Fly"] = 192.6, ["Neon|Ride"] = 40.6, ["Neon|Fly|Ride"] = 110.24, ["Mega"] = 485.63, ["Mega|Ride"] = 308.43, ["Mega|Fly|Ride"] = 376.69}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 42.74, ["Ride"] = 14.44, ["Fly|Ride"] = 57.69, ["Neon"] = 5.38, ["Neon|Fly"] = 149.56, ["Neon|Ride"] = 24.81, ["Neon|Fly|Ride"] = 58.65, ["Mega"] = 61.69, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 262.4}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 36.74, ["Ride"] = 57.69, ["Fly|Ride"] = 315.13, ["Neon"] = 196.88, ["Neon|Ride"] = 257.59, ["Mega"] = 694.41, ["Mega|Ride"] = 694.41, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 32.7, ["Ride"] = 20.37, ["Fly|Ride"] = 76.13, ["Neon"] = 6.41, ["Neon|Fly"] = 137.25, ["Neon|Ride"] = 32.51, ["Neon|Fly|Ride"] = 119.44, ["Mega"] = 45.93, ["Mega|Ride"] = 132.9, ["Mega|Fly|Ride"] = 272.98}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 26.24, ["Fly|Ride"] = 63.02, ["Neon"] = 11.8, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 161.3, ["Mega"] = 105.27, ["Mega|Ride"] = 198.59, ["Mega|Fly|Ride"] = 170.94}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly|Ride"] = 65.83, ["Neon"] = 11.22, ["Neon|Fly|Ride"] = 114.33, ["Mega"] = 97.12, ["Mega|Ride"] = 143.17, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 42.74, ["Ride"] = 16.04, ["Fly|Ride"] = 68.86, ["Neon"] = 3.4, ["Neon|Fly"] = 71.58, ["Neon|Ride"] = 21.86, ["Neon|Fly|Ride"] = 108.15, ["Mega"] = 40.68, ["Mega|Fly"] = 229.69, ["Mega|Ride"] = 81.51}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 11.82, ["Fly"] = 20.83, ["Ride"] = 17.1, ["Fly|Ride"] = 43.32, ["Neon"] = 118.13, ["Neon|Ride"] = 80.88, ["Neon|Fly|Ride"] = 143.08, ["Mega|Ride"] = 558.74, ["Mega|Fly|Ride"] = 396.36}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 698.25, ["Fly"] = 926.13, ["Ride"] = 720.37, ["Fly|Ride"] = 700.88, ["Neon"] = 1935.94, ["Neon|Ride"] = 2136.37, ["Neon|Fly|Ride"] = 2163, ["Mega"] = 4654.5, ["Mega|Fly|Ride"] = 5777.36}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 14.97, ["Fly|Ride"] = 41.47, ["Neon"] = 3.46, ["Neon|Fly"] = 49.23, ["Neon|Ride"] = 19.49, ["Neon|Fly|Ride"] = 50.43, ["Mega"] = 38.07, ["Mega|Ride"] = 90.46, ["Mega|Fly|Ride"] = 170.68}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 5.03, ["Ride"] = 32.81, ["Fly|Ride"] = 202.04, ["Neon"] = 52.74, ["Neon|Ride"] = 212.49, ["Neon|Fly|Ride"] = 210, ["Mega"] = 481.46, ["Mega|Ride"] = 393.1, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 43.32, ["Fly"] = 104.9, ["Ride"] = 74.82, ["Fly|Ride"] = 111.57, ["Neon"] = 315, ["Neon|Ride"] = 313.69, ["Neon|Fly|Ride"] = 434.44, ["Mega"] = 2439.83, ["Mega|Fly|Ride"] = 2611.88}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 27.57, ["Fly"] = 146.86, ["Ride"] = 60.38, ["Fly|Ride"] = 104.9, ["Neon"] = 228.6, ["Neon|Ride"] = 161.3, ["Neon|Fly|Ride"] = 427.33, ["Mega"] = 1284.27, ["Mega|Ride"] = 854.65, ["Mega|Fly|Ride"] = 1124.19}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 9.19, ["Fly"] = 90.3, ["Ride"] = 26.49, ["Fly|Ride"] = 143.15, ["Neon"] = 50.82, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 273, ["Mega"] = 305.36, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 443.37}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 22.32, ["Ride"] = 61.41, ["Fly|Ride"] = 141.01, ["Neon"] = 109.68, ["Neon|Ride"] = 356, ["Neon|Fly|Ride"] = 150.73, ["Mega"] = 321.46, ["Mega|Fly"] = 522.39, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 433.32}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 19.69, ["Ride"] = 78.75, ["Fly|Ride"] = 160.25, ["Neon"] = 144.48, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 525, ["Mega"] = 524.99, ["Mega|Fly"] = 567, ["Mega|Ride"] = 476.44, ["Mega|Fly|Ride"] = 744.19}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 3.94}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 5.25, ["Ride"] = 24.86, ["Fly|Ride"] = 78.75, ["Neon"] = 49.16, ["Neon|Ride"] = 65.01, ["Neon|Fly|Ride"] = 213.63, ["Mega"] = 210, ["Mega|Fly"] = 458.27, ["Mega|Ride"] = 233.62, ["Mega|Fly|Ride"] = 306.54}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.63, ["Ride"] = 46.98, ["Neon"] = 11.81, ["Neon|Fly|Ride"] = 213.68, ["Mega"] = 141.03}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 34.48, ["Fly"] = 62.99, ["Ride"] = 30.55, ["Fly|Ride"] = 81.37, ["Neon"] = 162.56, ["Neon|Ride"] = 213.05, ["Neon|Fly|Ride"] = 294.87, ["Mega|Ride"] = 775.68, ["Mega|Fly|Ride"] = 616.81}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.94, ["Fly"] = 20.3, ["Ride"] = 16.7, ["Fly|Ride"] = 32.06, ["Neon"] = 26.17, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 35.88, ["Neon|Fly|Ride"] = 74.96, ["Mega"] = 198.19, ["Mega|Fly"] = 426.27, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 234.8}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 3.52, ["Fly"] = 108.22, ["Ride"] = 25.19, ["Fly|Ride"] = 64.2, ["Neon"] = 24.74, ["Neon|Ride"] = 48.17, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 170.35, ["Mega|Fly"] = 197.4, ["Mega|Ride"] = 167.35, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Ride"] = 71.58, ["Neon"] = 7.88, ["Mega"] = 40.61, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 31.08, ["Ride"] = 52.49, ["Fly|Ride"] = 143.15, ["Neon"] = 282.01, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 427.33, ["Mega|Ride"] = 1709.3, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 22.31, ["Fly|Ride"] = 57.67, ["Neon"] = 7.88, ["Neon|Fly"] = 203.44, ["Neon|Ride"] = 85.46, ["Neon|Fly|Ride"] = 105, ["Mega"] = 71.87, ["Mega|Ride"] = 141.36}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 7.26, ["Ride"] = 57.69, ["Fly|Ride"] = 284.15, ["Neon"] = 72.19, ["Neon|Ride"] = 156.19, ["Neon|Fly|Ride"] = 320.51, ["Mega"] = 367.5, ["Mega|Fly"] = 570.49, ["Mega|Fly|Ride"] = 570.49}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 15.75, ["Fly|Ride"] = 60.9, ["Neon"] = 14.3, ["Neon|Ride"] = 21.38, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 185.91, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 24.09, ["Fly|Ride"] = 87.61, ["Neon"] = 44.84, ["Neon|Fly"] = 128.2, ["Neon|Ride"] = 143.15, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 399.56, ["Mega|Ride"] = 426.27, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.27, ["Ride"] = 94.01, ["Neon"] = 90.9, ["Mega"] = 418.05, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 645.74}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 46.78, ["Ride"] = 131.25, ["Fly|Ride"] = 145.26, ["Neon"] = 230.74, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 427.33, ["Mega"] = 1175.14, ["Mega|Ride"] = 1239.25, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 10.5, ["Ride"] = 78.66, ["Fly|Ride"] = 161.28, ["Neon"] = 107.62, ["Neon|Ride"] = 183.75, ["Mega"] = 367.4, ["Mega|Ride"] = 562.1, ["Mega|Fly|Ride"] = 712.58}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 10.61, ["Ride"] = 126.03, ["Neon"] = 50.22, ["Neon|Fly"] = 213.65, ["Neon|Ride"] = 170.63, ["Mega"] = 802.82, ["Mega|Ride"] = 433.32, ["Mega|Fly|Ride"] = 570.49}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 23.63, ["Ride"] = 68, ["Fly|Ride"] = 367.48, ["Neon"] = 106.72, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 665.57, ["Mega|Fly"] = 2136.62, ["Mega|Ride"] = 722.18, ["Mega|Fly|Ride"] = 746.76}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.1, ["Neon"] = 18.35, ["Neon|Fly|Ride"] = 143.17, ["Mega"] = 185.91, ["Mega|Fly|Ride"] = 321.39}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 27.8, ["Ride"] = 17.11, ["Fly|Ride"] = 38.47, ["Neon"] = 5.25, ["Neon|Fly"] = 42.74, ["Neon|Ride"] = 33.03, ["Neon|Fly|Ride"] = 96.31, ["Mega"] = 96.31, ["Mega|Ride"] = 96.31, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 3.56, ["Fly"] = 45.94, ["Ride"] = 29.13, ["Fly|Ride"] = 69.57, ["Neon"] = 15.3, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 121.79, ["Mega"] = 89.14, ["Mega|Ride"] = 108.94, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 143.09, ["Ride"] = 19.69, ["Fly|Ride"] = 71.91, ["Neon"] = 5.23, ["Neon|Ride"] = 27.36, ["Neon|Fly|Ride"] = 121.79, ["Mega"] = 52.27, ["Mega|Ride"] = 83.99, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 65.62, ["Ride"] = 21.03, ["Fly|Ride"] = 71.58, ["Neon"] = 18.69, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 213.68, ["Mega"] = 285.16, ["Mega|Ride"] = 325.5, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 2.63, ["Fly"] = 49.61, ["Ride"] = 30.19, ["Fly|Ride"] = 427.28, ["Neon"] = 29.28, ["Neon|Fly"] = 315, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 285.26, ["Mega|Ride"] = 287.47, ["Mega|Fly|Ride"] = 1068.32}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.94, ["Fly"] = 131.25, ["Ride"] = 22.52, ["Fly|Ride"] = 53.82, ["Neon"] = 26.25, ["Neon|Fly"] = 114.31, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 211.54, ["Mega|Ride"] = 300.57, ["Mega|Fly|Ride"] = 397.04}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.48, ["Ride"] = 18.38, ["Fly|Ride"] = 51.79, ["Neon"] = 22.23, ["Neon|Ride"] = 69.08, ["Neon|Fly|Ride"] = 106.85, ["Mega"] = 256.41, ["Mega|Ride"] = 213.68, ["Mega|Fly|Ride"] = 188.07}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 2.63, ["Fly"] = 131.25, ["Ride"] = 45.71, ["Fly|Ride"] = 131.24, ["Neon"] = 10.49, ["Neon|Fly"] = 437.06, ["Neon|Ride"] = 66.91, ["Neon|Fly|Ride"] = 170.62, ["Mega"] = 91.88, ["Mega|Fly"] = 210, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 248.79}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 10.5, ["Ride"] = 114.37, ["Fly|Ride"] = 315, ["Neon"] = 105, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1124.19, ["Mega|Ride"] = 658.45, ["Mega|Fly|Ride"] = 701.04}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 48.18, ["Fly"] = 164.07, ["Ride"] = 77.44, ["Fly|Ride"] = 165.38, ["Neon"] = 235.65, ["Neon|Ride"] = 192.29, ["Neon|Fly|Ride"] = 366.03, ["Mega"] = 1339.67, ["Mega|Ride"] = 1063.13, ["Mega|Fly|Ride"] = 1102.5}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 51.09, ["Ride"] = 21.56, ["Fly|Ride"] = 118.12, ["Neon"] = 2.1, ["Neon|Ride"] = 32.8, ["Neon|Fly|Ride"] = 143.17, ["Mega"] = 25.55, ["Mega|Ride"] = 70.49, ["Mega|Fly|Ride"] = 138.43}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 8.25, ["Ride"] = 52.5, ["Mega"] = 686.56, ["Mega|Fly|Ride"] = 1126}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 45.94, ["Ride"] = 91.91, ["Neon"] = 476.42, ["Neon|Ride"] = 357, ["Neon|Fly|Ride"] = 853.59, ["Mega"] = 1255.27, ["Mega|Fly|Ride"] = 1425.14}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 6.57, ["Fly"] = 190.32, ["Ride"] = 29.45, ["Fly|Ride"] = 133.88, ["Neon"] = 46.87, ["Neon|Fly"] = 128.8, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 126.07, ["Mega"] = 253.32, ["Mega|Ride"] = 242.71, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Fly|Ride"] = 131.25, ["Neon"] = 18.05, ["Neon|Ride"] = 68.15, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 95.82, ["Mega|Fly"] = 282.18, ["Mega|Ride"] = 142.96, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 21.38, ["Ride"] = 18.38, ["Fly|Ride"] = 39.38, ["Neon"] = 11.81, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 236.25, ["Mega|Ride"] = 104.81, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 17.64, ["Ride"] = 16, ["Fly|Ride"] = 31.46, ["Neon"] = 2.63, ["Neon|Fly"] = 31.46, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 45.85, ["Mega"] = 26.25, ["Mega|Ride"] = 69.56, ["Mega|Fly|Ride"] = 152.25}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 18.71, ["Fly|Ride"] = 85.39, ["Neon"] = 3.12, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 40.68, ["Mega|Fly"] = 140.02, ["Mega|Ride"] = 58.66, ["Mega|Fly|Ride"] = 185.91}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 2.1, ["Neon|Ride"] = 145.08, ["Mega"] = 32.82, ["Mega|Ride"] = 108.98, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 4.64, ["Ride"] = 104.99, ["Neon"] = 38.98, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 402.02, ["Mega|Ride"] = 346.2, ["Mega|Fly|Ride"] = 423.07}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 5.25, ["Ride"] = 30.19, ["Fly|Ride"] = 211.89, ["Neon"] = 57.87, ["Neon|Ride"] = 101.49, ["Neon|Fly|Ride"] = 143.17, ["Mega"] = 225.08, ["Mega|Ride"] = 315.16, ["Mega|Fly|Ride"] = 481.46}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 7.29, ["Fly"] = 10.69, ["Ride"] = 18.71, ["Fly|Ride"] = 36.75, ["Neon"] = 28.88, ["Neon|Ride"] = 38.56, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 337.6, ["Mega|Ride"] = 305.73, ["Mega|Fly|Ride"] = 346.5}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 57.6, ["Ride"] = 98.44, ["Fly|Ride"] = 124.69, ["Neon"] = 393.75, ["Neon|Ride"] = 426.22, ["Neon|Fly|Ride"] = 712.58, ["Mega"] = 2407.23, ["Mega|Fly|Ride"] = 1472.63}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 17.72, ["Fly"] = 82.69, ["Ride"] = 58.97, ["Fly|Ride"] = 78.75, ["Neon"] = 143.07, ["Neon|Fly|Ride"] = 630, ["Mega"] = 464.63, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 1037.54}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 21.38, ["Ride"] = 16.04, ["Fly|Ride"] = 41.66, ["Neon"] = 2.26, ["Neon|Fly"] = 42.74, ["Neon|Ride"] = 19.1, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 36.12, ["Mega|Fly"] = 114.33, ["Mega|Ride"] = 93.44, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 21.38, ["Ride"] = 15.74, ["Fly|Ride"] = 32.81, ["Neon"] = 3.56, ["Neon|Fly"] = 28.85, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 39.93, ["Mega"] = 44.63, ["Mega|Ride"] = 57.15, ["Mega|Fly|Ride"] = 98.43}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 380.63, ["Fly"] = 562.2, ["Ride"] = 441.83, ["Fly|Ride"] = 502.69, ["Neon|Fly|Ride"] = 1965.7, ["Mega|Fly|Ride"] = 6766.65}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 3.94, ["Fly"] = 114.31, ["Ride"] = 53.43, ["Neon"] = 45.75, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 403.5, ["Mega|Ride"] = 641, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 15.93, ["Ride"] = 18.17, ["Fly|Ride"] = 34.02, ["Neon"] = 3.49, ["Neon|Fly"] = 19.84, ["Neon|Ride"] = 18.37, ["Neon|Fly|Ride"] = 43.32, ["Mega"] = 44.99, ["Mega|Ride"] = 80.13, ["Mega|Fly|Ride"] = 113.82}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 55.13, ["Ride"] = 98.24, ["Fly|Ride"] = 282.01, ["Neon"] = 223.13, ["Neon|Ride"] = 261.09, ["Neon|Fly|Ride"] = 412.13, ["Mega"] = 737.62, ["Mega|Ride"] = 761.25, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 27.27, ["Ride"] = 17.06, ["Fly|Ride"] = 45.76, ["Neon"] = 12.62, ["Neon|Fly"] = 79.07, ["Neon|Ride"] = 28.56, ["Neon|Fly|Ride"] = 79.94, ["Mega"] = 125.89, ["Mega|Ride"] = 143.17, ["Mega|Fly|Ride"] = 215.25}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 71.58, ["Ride"] = 57.69, ["Fly|Ride"] = 196.88, ["Neon"] = 3.93, ["Neon|Fly"] = 98.38, ["Neon|Ride"] = 42.74, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 19.69, ["Mega|Ride"] = 75.77, ["Mega|Fly|Ride"] = 209.9}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 32.09, ["Fly"] = 129.94, ["Ride"] = 78.74, ["Fly|Ride"] = 215.73, ["Neon"] = 190.16, ["Neon|Ride"] = 207.38, ["Neon|Fly|Ride"] = 287.44, ["Mega"] = 802.82, ["Mega|Ride"] = 647.05, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 22.32, ["Ride"] = 19.68, ["Fly|Ride"] = 146.99, ["Neon"] = 3.66, ["Neon|Ride"] = 40.61, ["Mega"] = 39.12, ["Mega|Ride"] = 155.68, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 22.32, ["Ride"] = 62.79, ["Fly|Ride"] = 105, ["Neon"] = 148.44, ["Neon|Ride"] = 249.27, ["Neon|Fly|Ride"] = 288.46, ["Mega"] = 1181.25, ["Mega|Ride"] = 1709.3, ["Mega|Fly|Ride"] = 1333.83}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.12, ["Fly"] = 71.58, ["Ride"] = 39.38, ["Fly|Ride"] = 143.15, ["Neon"] = 26.8, ["Neon|Ride"] = 230.9, ["Neon|Fly|Ride"] = 161.3, ["Mega"] = 169.32, ["Mega|Ride"] = 183.75}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 71.58, ["Ride"] = 73.5, ["Fly|Ride"] = 71.58, ["Neon"] = 9.55, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 433.32, ["Mega"] = 104.71, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 301.28}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 41.69, ["Fly"] = 85.46, ["Ride"] = 65.62, ["Fly|Ride"] = 534.1, ["Mega|Ride"] = 1709.3, ["Mega|Fly|Ride"] = 1995.61}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 587.46, ["Ride"] = 39.38, ["Fly|Ride"] = 71.58, ["Neon"] = 3.5, ["Neon|Ride"] = 40.61, ["Neon|Fly|Ride"] = 114.31, ["Mega"] = 45.48, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 143.17, ["Mega|Fly|Ride"] = 237.18}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 24.66, ["Ride"] = 19.09, ["Fly|Ride"] = 102.88, ["Neon"] = 8.25, ["Neon|Fly"] = 32.51, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 60.9, ["Mega"] = 59.13, ["Mega|Fly"] = 148.07, ["Mega|Ride"] = 120.26, ["Mega|Fly|Ride"] = 219.19}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 7.88, ["Fly"] = 57.91, ["Ride"] = 35.64, ["Fly|Ride"] = 169.85, ["Neon"] = 71.58, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 149.59, ["Mega"] = 328.01, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 405.12}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 6.57, ["Fly"] = 80.67, ["Ride"] = 24.91, ["Fly|Ride"] = 65.58, ["Neon"] = 57.75, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 143.17, ["Mega"] = 747.83, ["Mega|Ride"] = 457.38, ["Mega|Fly|Ride"] = 568.36}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 21, ["Fly"] = 48.57, ["Ride"] = 28.68, ["Fly|Ride"] = 55.01, ["Neon"] = 80.56, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 141.72, ["Mega"] = 408.98, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 379.32}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 61.45, ["Ride"] = 123.38, ["Fly|Ride"] = 257.63, ["Neon"] = 301.88, ["Neon|Ride"] = 289.43, ["Neon|Fly|Ride"] = 581.17, ["Mega"] = 1575, ["Mega|Ride"] = 1643.07, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 6.34, ["Ride"] = 114.31, ["Fly|Ride"] = 203.44, ["Neon"] = 55.43, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 241.5, ["Mega|Fly"] = 567.28, ["Mega|Ride"] = 367.52, ["Mega|Fly|Ride"] = 541.65}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.57, ["Ride"] = 27.29, ["Fly|Ride"] = 78.74, ["Neon"] = 20.31, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 285.26, ["Mega|Ride"] = 244.13, ["Mega|Fly|Ride"] = 335.99}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 8.37, ["Fly"] = 135.19, ["Ride"] = 36.36, ["Fly|Ride"] = 115.5, ["Neon"] = 57.63, ["Neon|Ride"] = 104.9, ["Mega"] = 450.16, ["Mega|Ride"] = 641, ["Mega|Fly|Ride"] = 854.65}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 13.13, ["Fly|Ride"] = 39.74, ["Neon"] = 2.1, ["Neon|Fly"] = 21.69, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 15.63, ["Mega|Ride"] = 26.23, ["Mega|Fly|Ride"] = 96.1}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 48.57, ["Fly"] = 226.47, ["Ride"] = 121.78, ["Fly|Ride"] = 131.25, ["Neon"] = 234.94, ["Neon|Fly"] = 2421.57, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 1284.27, ["Mega"] = 1065.11, ["Mega|Ride"] = 956.15, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 21.38, ["Fly|Ride"] = 112.22, ["Neon"] = 5.25, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 31.4, ["Mega|Ride"] = 143.17, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.86, ["Ride"] = 17.59, ["Fly|Ride"] = 45.94, ["Neon"] = 13.13, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 90.03, ["Mega"] = 257.25, ["Mega|Ride"] = 194.9, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 64.31, ["Ride"] = 87.94, ["Fly|Ride"] = 258.57, ["Neon"] = 209.99, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 361.1, ["Mega"] = 950.25, ["Mega|Ride"] = 1111.05, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Fly"] = 30.19, ["Ride"] = 43.32, ["Fly|Ride"] = 43.32, ["Neon"] = 9.19, ["Neon|Ride"] = 32.81, ["Mega"] = 60.38, ["Mega|Fly"] = 106.85, ["Mega|Ride"] = 112.59, ["Mega|Fly|Ride"] = 249.37}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 6.42}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 24.59, ["Fly|Ride"] = 123.93, ["Neon"] = 6.49, ["Neon|Ride"] = 84.54, ["Neon|Fly|Ride"] = 114.33, ["Mega"] = 76.13, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 219.23}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 131.08, ["Ride"] = 180.55, ["Fly|Ride"] = 335.42, ["Neon"] = 837.46, ["Neon|Ride"] = 630, ["Neon|Fly|Ride"] = 665.05, ["Mega"] = 6409.83, ["Mega|Ride"] = 3210.05, ["Mega|Fly|Ride"] = 2563.95}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2.1, ["Ride"] = 36.33, ["Fly|Ride"] = 120.4, ["Neon"] = 21.84, ["Neon|Fly"] = 143.15, ["Neon|Ride"] = 63.04, ["Neon|Fly|Ride"] = 219.43, ["Mega"] = 178.39, ["Mega|Ride"] = 211.32, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 26.24, ["Neon"] = 3.92, ["Neon|Ride"] = 24.43, ["Mega"] = 32.45, ["Mega|Fly"] = 65.63, ["Mega|Ride"] = 71.59, ["Mega|Fly|Ride"] = 315.06}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 3.76, ["Fly"] = 39.38, ["Ride"] = 31.5, ["Fly|Ride"] = 72.19, ["Neon"] = 55.95, ["Neon|Ride"] = 88.68, ["Neon|Fly|Ride"] = 153.86, ["Mega"] = 427.33, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 639.93}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 8.57, ["Fly"] = 57.31, ["Ride"] = 21.37, ["Fly|Ride"] = 56.59, ["Neon"] = 72.19, ["Neon|Ride"] = 158.04, ["Neon|Fly|Ride"] = 309.1, ["Mega"] = 626.07, ["Mega|Ride"] = 598.26, ["Mega|Fly|Ride"] = 356.83}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 18.38, ["Ride"] = 59.07, ["Neon"] = 170.92, ["Neon|Ride"] = 191.62, ["Neon|Fly|Ride"] = 1575, ["Mega"] = 561.75, ["Mega|Ride"] = 570.4, ["Mega|Fly|Ride"] = 599.82}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 144.35, ["Fly"] = 183.75, ["Ride"] = 183.75, ["Fly|Ride"] = 249.26, ["Neon"] = 565.81, ["Neon|Fly"] = 642.85, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 643.02, ["Mega|Ride"] = 2563.95, ["Mega|Fly|Ride"] = 3210.05}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 3.68, ["Fly"] = 21, ["Ride"] = 17.85, ["Fly|Ride"] = 39.38, ["Neon"] = 42.74, ["Neon|Fly"] = 157.68, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 82.69, ["Mega|Ride"] = 341.87, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.3, ["Fly"] = 131.23, ["Ride"] = 24.59, ["Fly|Ride"] = 131.25, ["Neon"] = 17.97, ["Neon|Fly"] = 42.74, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 121.53, ["Mega|Ride"] = 161.3, ["Mega|Fly|Ride"] = 213.68}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 3.21, ["Fly"] = 42.35, ["Ride"] = 24.09, ["Fly|Ride"] = 128.2, ["Neon"] = 47.25, ["Neon|Fly"] = 128.63, ["Neon|Ride"] = 48.17, ["Neon|Fly|Ride"] = 161.3, ["Mega"] = 427.33, ["Mega|Ride"] = 387.85, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 47.25, ["Fly"] = 113.24, ["Ride"] = 68.63, ["Fly|Ride"] = 134.37, ["Neon"] = 202.13, ["Neon|Ride"] = 247.1, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 956.15, ["Mega|Ride"] = 925.32, ["Mega|Fly|Ride"] = 958.1}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 18.38, ["Fly"] = 57.75, ["Ride"] = 131.25, ["Neon"] = 184.05, ["Neon|Ride"] = 221.58, ["Neon|Fly|Ride"] = 471.14, ["Mega"] = 1049.9, ["Mega|Ride"] = 1932, ["Mega|Fly|Ride"] = 722.18}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.54, ["Ride"] = 570.42, ["Neon|Ride"] = 3210.08}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 17.07, ["Fly"] = 42.35, ["Ride"] = 33.55, ["Fly|Ride"] = 69.57, ["Neon"] = 228.6, ["Neon|Ride"] = 212.58, ["Neon|Fly|Ride"] = 321.39, ["Mega"] = 761.25, ["Mega|Ride"] = 753.27, ["Mega|Fly|Ride"] = 997.82}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 42.7, ["Ride"] = 14.44, ["Fly|Ride"] = 71.58, ["Neon"] = 2.1, ["Neon|Fly"] = 13.13, ["Neon|Ride"] = 18.18, ["Neon|Fly|Ride"] = 53.82, ["Mega"] = 19.85, ["Mega|Fly"] = 113.26, ["Mega|Ride"] = 47.16, ["Mega|Fly|Ride"] = 114.03}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Ride"] = 41.1, ["Neon"] = 8.9, ["Neon|Ride"] = 42.74, ["Neon|Fly|Ride"] = 143.17, ["Mega"] = 113.06, ["Mega|Ride"] = 164.18, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 2.54, ["Fly"] = 32.03, ["Ride"] = 24.94, ["Fly|Ride"] = 126.06, ["Neon"] = 20.31, ["Neon|Fly"] = 87.94, ["Neon|Ride"] = 48.55, ["Neon|Fly|Ride"] = 1181.23, ["Mega"] = 130.56, ["Mega|Fly"] = 498.91, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 341.92}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 393.74, ["Fly"] = 505.32, ["Ride"] = 418.69, ["Fly|Ride"] = 518.41, ["Neon"] = 1898.49, ["Neon|Ride"] = 997.69, ["Neon|Fly|Ride"] = 1246.88, ["Mega|Fly|Ride"] = 5512.46}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Ride"] = 16.34, ["Fly|Ride"] = 45.94, ["Neon"] = 16.05, ["Neon|Ride"] = 57.12, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 196.77, ["Mega|Ride"] = 161.3, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 3.94, ["Fly"] = 21.37, ["Ride"] = 18.18, ["Fly|Ride"] = 42.92, ["Neon"] = 27.71, ["Neon|Fly"] = 33.13, ["Neon|Ride"] = 59.83, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 144.45, ["Mega|Ride"] = 289.52, ["Mega|Fly|Ride"] = 276.94}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 2.6, ["Fly"] = 45.71, ["Ride"] = 23.62, ["Fly|Ride"] = 52.92, ["Neon"] = 11.95, ["Neon|Fly"] = 94.48, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 108.5, ["Mega"] = 131.25, ["Mega|Ride"] = 175.88, ["Mega|Fly|Ride"] = 236.24}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 28.35, ["Fly"] = 48.17, ["Ride"] = 32.82, ["Fly|Ride"] = 65.63, ["Neon"] = 220.4, ["Neon|Ride"] = 196.86, ["Neon|Fly|Ride"] = 319.45, ["Mega"] = 712.58, ["Mega|Ride"] = 854.65, ["Mega|Fly|Ride"] = 630.31}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 53.43, ["Ride"] = 34.13, ["Fly|Ride"] = 51.75, ["Neon"] = 11.46, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 165.4, ["Mega|Ride"] = 457.79, ["Mega|Fly|Ride"] = 1011.29}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 6.57, ["Fly"] = 65.61, ["Ride"] = 28.86, ["Fly|Ride"] = 91.88, ["Neon"] = 168.9, ["Neon|Ride"] = 183.74, ["Mega|Fly|Ride"] = 774.38}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 21.29, ["Neon"] = 3.93, ["Neon|Ride"] = 25.74, ["Mega"] = 54.74, ["Mega|Ride"] = 122.83, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 3.94, ["Fly"] = 72.19, ["Ride"] = 143.15, ["Neon"] = 18.08, ["Mega"] = 136.02, ["Mega|Ride"] = 321.39, ["Mega|Fly|Ride"] = 761.92}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 5.24, ["Ride"] = 64.11, ["Neon"] = 61.97, ["Neon|Ride"] = 285.22, ["Mega"] = 315.16, ["Mega|Ride"] = 554.47, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 6.46, ["Fly"] = 34.41, ["Ride"] = 22.31, ["Fly|Ride"] = 54.25, ["Neon"] = 49.87, ["Neon|Fly"] = 114.31, ["Neon|Ride"] = 54.92, ["Neon|Fly|Ride"] = 111.57, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 484.81}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 393.65, ["Fly"] = 516.97, ["Ride"] = 458.68, ["Fly|Ride"] = 445.39, ["Neon"] = 1659, ["Neon|Ride"] = 1850.09, ["Neon|Fly|Ride"] = 1640.63}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.75, ["Fly|Ride"] = 32.58, ["Neon"] = 35.44, ["Neon|Fly"] = 80.66, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 158.17, ["Mega"] = 228.64, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 302.12}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.94, ["Fly"] = 64.11, ["Ride"] = 64.11, ["Fly|Ride"] = 185.88, ["Neon"] = 68.25, ["Neon|Ride"] = 123.26, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 308.44, ["Mega|Fly"] = 712.58, ["Mega|Ride"] = 420}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 15.75, ["Fly"] = 87.67, ["Ride"] = 84.62, ["Fly|Ride"] = 320.46, ["Neon"] = 86.37, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 366.09, ["Mega"] = 273.24, ["Mega|Ride"] = 362.25, ["Mega|Fly|Ride"] = 518.43}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 57.66, ["Fly"] = 146.87, ["Ride"] = 90.81, ["Fly|Ride"] = 131.25, ["Neon"] = 321.57, ["Neon|Ride"] = 334.68, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 2568.51, ["Mega|Ride"] = 1794.77, ["Mega|Fly|Ride"] = 1813.86}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 5.81, ["Ride"] = 41.99, ["Fly|Ride"] = 144.37, ["Neon"] = 31.11, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 228.64, ["Mega"] = 170.51, ["Mega|Ride"] = 183.64, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 21.38, ["Ride"] = 19.59, ["Fly|Ride"] = 59.07, ["Neon"] = 18, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 65.62, ["Mega|Ride"] = 192.6, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 5.19, ["Ride"] = 34.19, ["Neon"] = 19.48, ["Neon|Ride"] = 106.84, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 114.18, ["Mega|Fly"] = 242.52, ["Mega|Ride"] = 145.07, ["Mega|Fly|Ride"] = 278.15}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 44.6, ["Fly"] = 137.81, ["Ride"] = 91.76, ["Fly|Ride"] = 183.73, ["Neon"] = 129.54, ["Neon|Ride"] = 162.65, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 439.69, ["Mega|Ride"] = 453.5, ["Mega|Fly|Ride"] = 562.1}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Fly"] = 71.58, ["Ride"] = 82.72, ["Neon"] = 6.42, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 200.82, ["Mega"] = 36.74, ["Mega|Ride"] = 164.06, ["Mega|Fly|Ride"] = 284.19}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 25.39, ["Ride"] = 213.65, ["Neon"] = 168.78, ["Neon|Ride"] = 374.07, ["Mega"] = 598.5, ["Mega|Fly|Ride"] = 789.5}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 1023.75, ["Fly"] = 1194.38, ["Ride"] = 1006.69, ["Fly|Ride"] = 1115.52, ["Neon|Ride"] = 2756.25, ["Neon|Fly|Ride"] = 3252.27, ["Mega|Fly|Ride"] = 10826.2}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 15.75, ["Fly"] = 111.04, ["Ride"] = 42.32, ["Fly|Ride"] = 173.25, ["Neon"] = 64.31, ["Neon|Fly"] = 711.42, ["Neon|Ride"] = 172.27, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 361.1, ["Mega|Ride"] = 328.27, ["Mega|Fly|Ride"] = 584.38}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.37, ["Ride"] = 19.68, ["Fly|Ride"] = 90.57, ["Neon"] = 8.96, ["Neon|Fly"] = 79.83, ["Neon|Ride"] = 32.38, ["Neon|Fly|Ride"] = 91.47, ["Mega"] = 82.69, ["Mega|Ride"] = 80.76, ["Mega|Fly|Ride"] = 183.72}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 8.9, ["Ride"] = 131.25, ["Fly|Ride"] = 143.15, ["Neon"] = 72.23, ["Neon|Fly|Ride"] = 393.73, ["Mega"] = 288.73, ["Mega|Ride"] = 426.27, ["Mega|Fly|Ride"] = 479.05}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 23.15, ["Fly|Ride"] = 185.79, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 18.37, ["Mega|Ride"] = 49.26, ["Mega|Fly|Ride"] = 140.44}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 50.93, ["Ride"] = 100.7, ["Fly|Ride"] = 236.25, ["Neon"] = 208.58, ["Neon|Ride"] = 258.32, ["Mega"] = 1123.5, ["Mega|Ride"] = 853.12, ["Mega|Fly|Ride"] = 956.82}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 6.46, ["Ride"] = 52.5, ["Fly|Ride"] = 283.87, ["Neon"] = 114.31, ["Neon|Ride"] = 151.67, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 418.69, ["Mega|Ride"] = 712.58, ["Mega|Fly|Ride"] = 722.18}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 9.1, ["Neon|Ride"] = 30.26, ["Neon|Fly|Ride"] = 96.31, ["Mega"] = 96.3, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 370.71}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 14.44, ["Fly"] = 52.5, ["Ride"] = 35.63, ["Fly|Ride"] = 65.63, ["Neon"] = 73.41, ["Neon|Fly"] = 72.19, ["Neon|Ride"] = 94.4, ["Neon|Fly|Ride"] = 266.01, ["Mega"] = 409.17, ["Mega|Ride"] = 419.99, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 2.73, ["Fly"] = 96.15, ["Ride"] = 31.49, ["Fly|Ride"] = 80.67, ["Neon"] = 143.15, ["Neon|Fly"] = 128.83, ["Neon|Ride"] = 80.66, ["Neon|Fly|Ride"] = 144.18, ["Mega"] = 427.33, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 515.17}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 38.07, ["Ride"] = 91.88, ["Neon"] = 213.65, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 682.5, ["Mega"] = 2087.08, ["Mega|Ride"] = 2407.23, ["Mega|Fly|Ride"] = 2134.49}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 3.62, ["Ride"] = 57.69, ["Fly|Ride"] = 183.65, ["Neon"] = 14.44, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 63.95, ["Mega|Ride"] = 111.57, ["Mega|Fly|Ride"] = 228.27}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 3.71, ["Ride"] = 21.84, ["Fly|Ride"] = 90.57, ["Neon"] = 45.48, ["Neon|Fly"] = 185.88, ["Neon|Ride"] = 67.83, ["Neon|Fly|Ride"] = 118.02, ["Mega"] = 295.32, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 712.58}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 115.38, ["Fly"] = 393.75, ["Ride"] = 131.24, ["Fly|Ride"] = 534.1, ["Neon"] = 433.12, ["Neon|Ride"] = 524.58, ["Neon|Fly|Ride"] = 669.38, ["Mega|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 2072.44}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 19.5, ["Ride"] = 16.43, ["Fly|Ride"] = 40.6, ["Neon"] = 11.69, ["Neon|Fly"] = 57.32, ["Neon|Ride"] = 33.78, ["Neon|Fly|Ride"] = 77.53, ["Mega"] = 143.17, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 14.44, ["Fly"] = 200.82, ["Ride"] = 59.77, ["Fly|Ride"] = 118.13, ["Neon"] = 95.8, ["Neon|Ride"] = 119.44, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 459.38, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.27, ["Ride"] = 15.1, ["Fly|Ride"] = 62.99, ["Neon"] = 2.1, ["Neon|Fly"] = 28.14, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 15.24, ["Mega|Ride"] = 32.51, ["Mega|Fly|Ride"] = 104.71}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 57.69, ["Neon"] = 3.84, ["Neon|Ride"] = 42.74, ["Neon|Fly|Ride"] = 128.21, ["Mega"] = 19.47, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 170.94}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 36.33, ["Ride"] = 19.08, ["Fly|Ride"] = 173.25, ["Neon"] = 14.55, ["Neon|Ride"] = 55.55, ["Neon|Fly|Ride"] = 100.44, ["Mega"] = 105, ["Mega|Ride"] = 285.09, ["Mega|Fly|Ride"] = 246.1}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 28.88, ["Ride"] = 59.07, ["Fly|Ride"] = 131.25, ["Neon"] = 128.63, ["Neon|Ride"] = 341.83, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 511.88, ["Mega|Ride"] = 639.93}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 15.7, ["Ride"] = 15.74, ["Fly|Ride"] = 34.09, ["Neon"] = 10.18, ["Neon|Fly"] = 31.31, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 64.28, ["Mega"] = 118.02, ["Mega|Fly"] = 267.22, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 143.17}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 7.87, ["Fly"] = 32.5, ["Ride"] = 28.88, ["Fly|Ride"] = 128.2, ["Neon"] = 31.4, ["Neon|Fly"] = 79.89, ["Neon|Ride"] = 52.41, ["Neon|Fly|Ride"] = 102.38, ["Mega"] = 236.15, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 259.67, ["Mega|Fly|Ride"] = 332.21}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 21.38, ["Ride"] = 18.08, ["Fly|Ride"] = 67.92, ["Neon"] = 11.33, ["Neon|Fly"] = 98.44, ["Neon|Ride"] = 24.86, ["Neon|Fly|Ride"] = 89.24, ["Mega"] = 47.23, ["Mega|Fly"] = 80.66, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 128.63}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 9.87, ["Fly"] = 161.31, ["Ride"] = 24.68, ["Fly|Ride"] = 217.2, ["Neon"] = 29.97, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 285.26, ["Mega"] = 292.68, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 393.15, ["Mega|Fly|Ride"] = 413.44}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 5.1, ["Ride"] = 32.71, ["Fly|Ride"] = 142.38, ["Neon"] = 49.13, ["Neon|Ride"] = 143.15, ["Neon|Fly|Ride"] = 257.28, ["Mega"] = 216.57, ["Mega|Ride"] = 303.19, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 39.8, ["Ride"] = 16.32, ["Fly|Ride"] = 50.82, ["Neon"] = 30.7, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 39.45, ["Neon|Fly|Ride"] = 145.3, ["Mega"] = 262.5, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 305.82, ["Mega|Fly|Ride"] = 570.49}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 24.86, ["Ride"] = 19.22, ["Fly|Ride"] = 30.19, ["Neon"] = 15.65, ["Neon|Fly"] = 70.51, ["Neon|Ride"] = 26.73, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 186.97, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 144.27}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 228.38, ["Fly"] = 393.75, ["Ride"] = 255.94, ["Fly|Ride"] = 392.43, ["Neon"] = 1251.98, ["Neon|Ride"] = 1227.71, ["Neon|Fly|Ride"] = 1174.69, ["Mega"] = 4172.94, ["Mega|Fly|Ride"] = 4495.51}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.44, ["Ride"] = 65.63, ["Neon"] = 21.29, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 570.49, ["Mega"] = 123.38, ["Mega|Ride"] = 642.75, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.1, ["Fly"] = 106.84, ["Ride"] = 24.69, ["Fly|Ride"] = 85.46, ["Neon"] = 29.88, ["Neon|Fly"] = 242.49, ["Neon|Ride"] = 57.69, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 229.01, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 3.93, ["Fly|Ride"] = 213.59, ["Neon"] = 36.66, ["Neon|Ride"] = 42.74, ["Neon|Fly|Ride"] = 603.74, ["Mega"] = 479.73, ["Mega|Ride"] = 401.94, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 16.17, ["Ride"] = 13.02, ["Fly|Ride"] = 32.71, ["Neon"] = 2.1, ["Neon|Fly"] = 42.74, ["Neon|Ride"] = 17.54, ["Neon|Fly|Ride"] = 44.62, ["Mega"] = 18.38, ["Mega|Fly"] = 79.07, ["Mega|Ride"] = 41.91, ["Mega|Fly|Ride"] = 72.17}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 21.95, ["Fly|Ride"] = 57.75, ["Neon"] = 15.94, ["Neon|Ride"] = 30.17, ["Neon|Fly|Ride"] = 105, ["Mega"] = 132.57, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 209.44}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.1, ["Ride"] = 119.85, ["Neon"] = 9.19, ["Neon|Ride"] = 284.15, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 39.38, ["Mega|Ride"] = 167.99, ["Mega|Fly|Ride"] = 276.94}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 72.19, ["Fly"] = 104.99, ["Ride"] = 95.82, ["Fly|Ride"] = 144.47, ["Neon"] = 409.5, ["Neon|Fly"] = 481.53, ["Neon|Ride"] = 368.82, ["Neon|Fly|Ride"] = 426.57, ["Mega|Ride"] = 3562.81, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 2.1, ["Fly"] = 71.58, ["Ride"] = 26.24, ["Fly|Ride"] = 141.73, ["Neon"] = 34.19, ["Neon|Ride"] = 68.15, ["Mega"] = 168, ["Mega|Ride"] = 273.78, ["Mega|Fly|Ride"] = 427.33}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 49.16, ["Ride"] = 34.12, ["Neon"] = 6.57, ["Neon|Ride"] = 80.66, ["Neon|Fly|Ride"] = 143.17, ["Mega"] = 58.68, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 46.74, ["Fly"] = 131.25, ["Ride"] = 78.75, ["Fly|Ride"] = 199.49, ["Neon"] = 126, ["Neon|Ride"] = 201.26, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 492.19, ["Mega|Ride"] = 584.38, ["Mega|Fly|Ride"] = 668.07}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Ride"] = 13.13, ["Fly|Ride"] = 19.69, ["Neon"] = 2.1, ["Neon|Fly"] = 21.84, ["Neon|Ride"] = 16.04, ["Neon|Fly|Ride"] = 43.14, ["Mega"] = 32.51, ["Mega|Fly"] = 45.49, ["Mega|Ride"] = 34.13, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 39.37, ["Neon"] = 3.94, ["Neon|Ride"] = 29.96, ["Neon|Fly|Ride"] = 285.34, ["Mega"] = 23.63, ["Mega|Ride"] = 78.65, ["Mega|Fly|Ride"] = 220.19}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 61.97, ["Neon"] = 7.88, ["Neon|Ride"] = 91.77, ["Neon|Fly|Ride"] = 281.91, ["Mega"] = 45.89, ["Mega|Fly"] = 185.91, ["Mega|Ride"] = 117.29}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 5.34, ["Fly"] = 100.43, ["Ride"] = 53.43, ["Fly|Ride"] = 127.32, ["Neon"] = 22.32, ["Neon|Ride"] = 82.9, ["Neon|Fly|Ride"] = 212.6, ["Mega"] = 127.32, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 321.39, ["Mega|Fly|Ride"] = 314.21}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 21.29, ["Ride"] = 13.49, ["Fly|Ride"] = 37.67, ["Neon"] = 2.1, ["Neon|Fly"] = 24.59, ["Neon|Ride"] = 23.55, ["Neon|Fly|Ride"] = 48.92, ["Mega"] = 17.63, ["Mega|Ride"] = 42, ["Mega|Fly|Ride"] = 117.48}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 19.17, ["Fly"] = 131.25, ["Ride"] = 52.5, ["Neon"] = 128.62, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 570.49, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 770.33}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2511.3, ["Fly"] = 3150, ["Ride"] = 2464.88, ["Fly|Ride"] = 2506.88, ["Neon|Fly|Ride"] = 7415.63, ["Mega|Fly|Ride"] = 44334.6}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 21.38, ["Ride"] = 15.75, ["Fly|Ride"] = 42.74, ["Neon"] = 5.2, ["Neon|Fly"] = 58.46, ["Neon|Ride"] = 23.02, ["Neon|Fly|Ride"] = 55.38, ["Mega"] = 65.63, ["Mega|Fly"] = 427.33, ["Mega|Ride"] = 97.02, ["Mega|Fly|Ride"] = 167.99}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Ride"] = 27.8, ["Neon"] = 8.81, ["Mega"] = 107.01, ["Mega|Fly"] = 441, ["Mega|Ride"] = 161.3, ["Mega|Fly|Ride"] = 450.16}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 14.44, ["Fly"] = 143.15, ["Ride"] = 31.48, ["Fly|Ride"] = 131.25, ["Neon"] = 79.26, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 570.49, ["Mega|Ride"] = 431.82, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 27.2, ["Fly"] = 106.84, ["Ride"] = 65.99, ["Neon"] = 140.44, ["Neon|Ride"] = 196.88, ["Mega"] = 565.62, ["Mega|Ride"] = 611.09, ["Mega|Fly|Ride"] = 677.32}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 143.32, ["Fly"] = 1424.96, ["Ride"] = 157.49, ["Fly|Ride"] = 264.55, ["Neon"] = 746.67, ["Neon|Fly"] = 712.48, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 652.32, ["Mega"] = 6409.83, ["Mega|Fly|Ride"] = 4074.53}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 3.73, ["Ride"] = 65.54, ["Fly|Ride"] = 675.94, ["Neon"] = 24.19, ["Neon|Ride"] = 143.15, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 143.17, ["Mega|Fly|Ride"] = 427.33}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 36.33, ["Neon"] = 14, ["Neon|Ride"] = 114.85, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 179.82, ["Mega|Ride"] = 330.65, ["Mega|Fly|Ride"] = 267.09}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 100.43, ["Ride"] = 28.87, ["Fly|Ride"] = 74.79, ["Neon"] = 10.48, ["Neon|Fly"] = 114.31, ["Neon|Ride"] = 31.18, ["Mega"] = 63, ["Mega|Ride"] = 113.8, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 10.6, ["Ride"] = 50.74, ["Fly|Ride"] = 131.25, ["Neon"] = 96.32, ["Neon|Ride"] = 175.75, ["Neon|Fly|Ride"] = 503.19, ["Mega"] = 420, ["Mega|Ride"] = 325.17, ["Mega|Fly|Ride"] = 584.73}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 48.17, ["Mega"] = 23.63, ["Mega|Fly"] = 120.38, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 135.19}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 90.95, ["Fly"] = 199.77, ["Ride"] = 105, ["Fly|Ride"] = 137.45, ["Neon"] = 304.5, ["Neon|Fly"] = 457.2, ["Neon|Ride"] = 407.38, ["Neon|Fly|Ride"] = 425.57, ["Mega"] = 3204.92, ["Mega|Fly|Ride"] = 1410.18}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Fly"] = 28.86, ["Ride"] = 91.84, ["Fly|Ride"] = 78.75, ["Neon"] = 6.62, ["Neon|Ride"] = 143.09, ["Neon|Fly|Ride"] = 213.68, ["Mega"] = 62.37, ["Mega|Ride"] = 276.29, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 41.9, ["Fly"] = 143.09, ["Ride"] = 85.24, ["Fly|Ride"] = 170.62, ["Neon"] = 255.94, ["Neon|Ride"] = 229.69, ["Neon|Fly|Ride"] = 530.8, ["Mega"] = 2625, ["Mega|Ride"] = 1709.3, ["Mega|Fly|Ride"] = 1852.45}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 21.29, ["Fly|Ride"] = 51.78, ["Neon"] = 3.4, ["Neon|Fly"] = 84.28, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 84, ["Mega"] = 55.13, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 144.27}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 10.39, ["Neon|Ride"] = 111.57, ["Mega"] = 49.88, ["Mega|Ride"] = 161.3, ["Mega|Fly|Ride"] = 465.82}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 3.82, ["Fly"] = 77.43, ["Ride"] = 33.13, ["Neon"] = 22.32, ["Neon|Ride"] = 72.45, ["Mega"] = 427.33, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 534.17}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 346.5, ["Fly"] = 498.85, ["Ride"] = 416.07, ["Fly|Ride"] = 493.4, ["Neon"] = 918.75, ["Neon|Ride"] = 939.75, ["Neon|Fly|Ride"] = 1102.5, ["Mega"] = 2756.25, ["Mega|Ride"] = 3130.32, ["Mega|Fly|Ride"] = 2907.82}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 31.4, ["Fly"] = 85.46, ["Ride"] = 45.85, ["Fly|Ride"] = 105.76, ["Neon"] = 154.52, ["Neon|Ride"] = 213.65, ["Neon|Fly|Ride"] = 269.24, ["Mega|Ride"] = 1139.88, ["Mega|Fly|Ride"] = 1049.08}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 16.04, ["Fly|Ride"] = 111.57, ["Neon"] = 14.99, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 35.75, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 129.94, ["Mega|Ride"] = 262.47, ["Mega|Fly|Ride"] = 314.9}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 19.64, ["Fly"] = 109.01, ["Ride"] = 62.99, ["Fly|Ride"] = 175.2, ["Neon"] = 71.09, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 143.15, ["Neon|Fly|Ride"] = 240.19, ["Mega"] = 313.69, ["Mega|Fly"] = 990.59, ["Mega|Ride"] = 456.18, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 4.77, ["Ride"] = 28.86, ["Neon"] = 101.36, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 481.46, ["Mega"] = 393.75, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 2.63, ["Neon"] = 23.55, ["Mega"] = 94.5, ["Mega|Ride"] = 332.68, ["Mega|Fly|Ride"] = 423.07}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 71.58, ["Ride"] = 20.97, ["Fly|Ride"] = 65.62, ["Neon"] = 18.08, ["Neon|Fly"] = 85.46, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 212.14, ["Mega"] = 210, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 84.34, ["Ride"] = 119.34, ["Fly|Ride"] = 225.12, ["Neon"] = 801.15, ["Neon|Ride"] = 523.68, ["Neon|Fly|Ride"] = 524.99, ["Mega"] = 2887.5, ["Mega|Ride"] = 2625, ["Mega|Fly|Ride"] = 2969.32}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 18.52, ["Ride"] = 41.58, ["Fly|Ride"] = 131.25, ["Neon"] = 157.38, ["Neon|Ride"] = 170.92, ["Neon|Fly|Ride"] = 315.16, ["Mega"] = 1139.88, ["Mega|Ride"] = 698.12, ["Mega|Fly|Ride"] = 802.82}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2034.38, ["Fly"] = 2268.06, ["Ride"] = 1968.75, ["Fly|Ride"] = 2033.07, ["Neon"] = 11394.24, ["Neon|Fly|Ride"] = 7019.25, ["Mega|Fly|Ride"] = 23622.92}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.84, ["Fly"] = 65625, ["Ride"] = 48.67, ["Fly|Ride"] = 196.87, ["Neon"] = 26.17, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 118.02, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 205.73, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 6.48, ["Ride"] = 21, ["Fly|Ride"] = 178.41, ["Neon"] = 21.4, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 144.04, ["Mega|Fly"] = 285.26, ["Mega|Ride"] = 226.5, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 826.88, ["Fly"] = 1481.58, ["Ride"] = 903.96, ["Fly|Ride"] = 989.63, ["Neon"] = 2778.57, ["Neon|Ride"] = 3067.09, ["Neon|Fly|Ride"] = 2891.38, ["Mega|Ride"] = 13641.75, ["Mega|Fly|Ride"] = 14806.71}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 22.32, ["Ride"] = 52.4, ["Fly|Ride"] = 173.35, ["Neon"] = 199.77, ["Neon|Ride"] = 185.88, ["Mega"] = 841.34, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 835.42}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.1, ["Ride"] = 22.44, ["Fly|Ride"] = 128.15, ["Neon"] = 11.81, ["Neon|Ride"] = 64.84, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 157.48, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Ride"] = 143.15, ["Neon"] = 3.5, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 111.13, ["Mega"] = 23.22, ["Mega|Ride"] = 79.07, ["Mega|Fly|Ride"] = 158.22}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 78.73, ["Ride"] = 130.7, ["Fly|Ride"] = 170.63, ["Neon"] = 459.38, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 640.5, ["Mega"] = 2407.23, ["Mega|Fly|Ride"] = 2264.82}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.52, ["Ride"] = 34.19, ["Fly|Ride"] = 74.69, ["Neon"] = 11.58, ["Neon|Ride"] = 36.37, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 90.56, ["Mega|Ride"] = 121.96, ["Mega|Fly|Ride"] = 249.57}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 73.5, ["Fly"] = 143.15, ["Ride"] = 102.08, ["Fly|Ride"] = 242.49, ["Neon"] = 427.28, ["Neon|Ride"] = 721.88, ["Mega|Fly|Ride"] = 1735.62}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 9.19, ["Fly"] = 105, ["Fly|Ride"] = 128.2, ["Neon"] = 58.95, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 269.06, ["Mega"] = 328.02, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 234.94, ["Ride"] = 279.56, ["Fly|Ride"] = 321.57, ["Neon"] = 1148.82, ["Neon|Fly"] = 1043.73, ["Neon|Ride"] = 1062.85, ["Neon|Fly|Ride"] = 879.16, ["Mega|Fly|Ride"] = 3844.83}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 2.63, ["Fly"] = 91.88, ["Ride"] = 23.63, ["Fly|Ride"] = 103.94, ["Neon"] = 38.88, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 114.18, ["Mega"] = 262.5, ["Mega|Ride"] = 257.59, ["Mega|Fly|Ride"] = 281}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 18.27, ["Ride"] = 15.94, ["Fly|Ride"] = 36, ["Neon"] = 3.35, ["Neon|Fly"] = 20.79, ["Neon|Ride"] = 24.92, ["Neon|Fly|Ride"] = 59.74, ["Mega"] = 44.61, ["Mega|Fly"] = 74.81, ["Mega|Ride"] = 71.39, ["Mega|Fly|Ride"] = 124.73}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1225.21, ["Ride"] = 1050, ["Fly|Ride"] = 1254.2, ["Neon|Ride"] = 7834.01, ["Neon|Fly|Ride"] = 6623.5, ["Mega"] = 24072.24, ["Mega|Fly|Ride"] = 28487.82}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 10.5, ["Fly"] = 997.69, ["Ride"] = 42.74, ["Neon"] = 97.13, ["Neon|Ride"] = 314.98, ["Mega"] = 320.25, ["Mega|Ride"] = 408.7, ["Mega|Fly|Ride"] = 564.27}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 5.25, ["Fly"] = 28.85, ["Ride"] = 38.98, ["Fly|Ride"] = 81.23, ["Neon"] = 19.29, ["Neon|Fly"] = 101.49, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 105, ["Mega"] = 141.16, ["Mega|Ride"] = 641, ["Mega|Fly|Ride"] = 282.19}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 23.62, ["Fly"] = 44.22, ["Ride"] = 40.69, ["Fly|Ride"] = 76.48, ["Neon"] = 238.22, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 216.56, ["Mega"] = 2563.95, ["Mega|Ride"] = 1124.19, ["Mega|Fly|Ride"] = 779.57}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 11.69, ["Fly"] = 70.51, ["Ride"] = 30.35, ["Fly|Ride"] = 78.75, ["Neon"] = 58.46, ["Neon|Ride"] = 114.31, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 367.5, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 431.71}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 57.77, ["Ride"] = 212.58, ["Fly|Ride"] = 498.85, ["Neon"] = 196.88, ["Neon|Fly"] = 370.68, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 413.44, ["Mega"] = 1055.5, ["Mega|Ride"] = 1011.7, ["Mega|Fly|Ride"] = 1040.54}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Fly|Ride"] = 285.22, ["Neon"] = 2.62, ["Neon|Fly"] = 57.69, ["Neon|Ride"] = 113.15, ["Neon|Fly|Ride"] = 106.85, ["Mega"] = 16.68, ["Mega|Ride"] = 143.17, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 80.07, ["Fly"] = 137.82, ["Ride"] = 90.81, ["Fly|Ride"] = 169.32, ["Neon"] = 356.79, ["Neon|Fly"] = 490.88, ["Neon|Ride"] = 427.81, ["Neon|Fly|Ride"] = 525, ["Mega"] = 3418.58, ["Mega|Fly|Ride"] = 1763.74}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 107.63, ["Ride"] = 19.67, ["Fly|Ride"] = 66.68, ["Neon"] = 198.19, ["Neon|Ride"] = 113.26, ["Mega"] = 773.71, ["Mega|Ride"] = 433.32, ["Mega|Fly|Ride"] = 490.88}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 28.56, ["Ride"] = 18.38, ["Fly|Ride"] = 38.16, ["Neon"] = 20.31, ["Neon|Fly"] = 80.67, ["Neon|Ride"] = 83.34, ["Neon|Fly|Ride"] = 122.85, ["Mega"] = 104.72, ["Mega|Ride"] = 277.86, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 3.94, ["Ride"] = 126, ["Neon"] = 16.04, ["Neon|Fly"] = 141.01, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 212.6}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 64.95, ["Fly"] = 247.55, ["Ride"] = 196.88, ["Fly|Ride"] = 223.13, ["Neon"] = 392.44, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 427.28, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 1837.49, ["Mega|Ride"] = 1596.06, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 3.94, ["Fly|Ride"] = 427.28, ["Neon"] = 19.09, ["Neon|Ride"] = 59.07, ["Mega"] = 126.88, ["Mega|Ride"] = 161.3, ["Mega|Fly|Ride"] = 321.39}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 37.79, ["Neon"] = 2.1, ["Neon|Ride"] = 117.97, ["Mega"] = 16.94, ["Mega|Ride"] = 208.46, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.93, ["Ride"] = 32.81, ["Fly|Ride"] = 143.16, ["Neon"] = 2.1, ["Neon|Fly"] = 86.2, ["Neon|Ride"] = 31.31, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 20.61, ["Mega|Ride"] = 41.91}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 17.81, ["Fly|Ride"] = 26.25, ["Neon"] = 5.25, ["Neon|Ride"] = 26.4, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 61.07, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 104.99}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 114.26, ["Neon"] = 24.36, ["Mega"] = 118.11, ["Mega|Ride"] = 114.33, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 39.34, ["Ride"] = 15.74, ["Fly|Ride"] = 40.94, ["Neon"] = 10.08, ["Neon|Fly"] = 85.46, ["Neon|Ride"] = 38.03, ["Neon|Fly|Ride"] = 100.44, ["Mega"] = 170.63, ["Mega|Ride"] = 161.3, ["Mega|Fly|Ride"] = 161.33}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 56.44, ["Ride"] = 102.38, ["Fly|Ride"] = 373.88, ["Neon"] = 229.66, ["Neon|Ride"] = 324.07, ["Neon|Fly|Ride"] = 1068.32, ["Mega"] = 525, ["Mega|Ride"] = 764.63, ["Mega|Fly|Ride"] = 1124.19}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 17.06, ["Ride"] = 14.44, ["Fly|Ride"] = 38.75, ["Neon"] = 2.1, ["Neon|Fly"] = 21.38, ["Neon|Ride"] = 20.31, ["Neon|Fly|Ride"] = 41.68, ["Mega"] = 143.17, ["Mega|Ride"] = 131.09, ["Mega|Fly|Ride"] = 95.08}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 6.36, ["Fly"] = 40.61, ["Ride"] = 32.43, ["Fly|Ride"] = 71.31, ["Neon"] = 36.94, ["Neon|Fly"] = 91.77, ["Neon|Ride"] = 63.74, ["Neon|Fly|Ride"] = 114.33, ["Mega"] = 301.88, ["Mega|Fly"] = 570.49, ["Mega|Ride"] = 328.02, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 22.32, ["Fly"] = 72.19, ["Ride"] = 42.73, ["Fly|Ride"] = 114.18, ["Neon"] = 143.39, ["Neon|Fly"] = 147, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 263.69, ["Mega"] = 613.23, ["Mega|Ride"] = 784.14, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.86, ["Fly"] = 196.88, ["Neon"] = 74.72, ["Neon|Ride"] = 103.69, ["Mega"] = 471.02, ["Mega|Ride"] = 412.13, ["Mega|Fly|Ride"] = 553.4}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.67, ["Ride"] = 15.74, ["Fly|Ride"] = 35.43, ["Neon"] = 2.47, ["Neon|Fly"] = 28.11, ["Neon|Ride"] = 21.37, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 44.26, ["Mega|Ride"] = 57.7, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 5.25, ["Fly"] = 38.07, ["Ride"] = 38.07, ["Neon"] = 72.56, ["Neon|Ride"] = 128.19, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 177.19, ["Mega|Fly"] = 366.43, ["Mega|Ride"] = 370.71, ["Mega|Fly|Ride"] = 536.31}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 892.5, ["Fly"] = 1285.69, ["Ride"] = 955.49, ["Fly|Ride"] = 1039.5, ["Neon|Ride"] = 2744.44, ["Neon|Fly|Ride"] = 2231.25, ["Mega|Fly|Ride"] = 7122.39}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 180.6, ["Ride"] = 262.5, ["Fly|Ride"] = 392.44, ["Neon"] = 840, ["Neon|Ride"] = 807.19, ["Neon|Fly|Ride"] = 977.82, ["Mega"] = 3203.86, ["Mega|Ride"] = 3562.81, ["Mega|Fly|Ride"] = 3091.68}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly|Ride"] = 392.44, ["Neon"] = 7.08, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 255.33, ["Mega"] = 78.4, ["Mega|Fly|Ride"] = 212.6}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 78.75, ["Ride"] = 189.52, ["Fly|Ride"] = 315, ["Neon"] = 571.58, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 752.21, ["Mega"] = 1980.65, ["Mega|Ride"] = 1909.08, ["Mega|Fly|Ride"] = 1903.13}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.1, ["Ride"] = 20.66, ["Fly|Ride"] = 98.44, ["Neon"] = 15.98, ["Neon|Fly"] = 56.58, ["Neon|Ride"] = 57.12, ["Neon|Fly|Ride"] = 285.26, ["Mega"] = 118.13, ["Mega|Ride"] = 481.46, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 244.28, ["Fly"] = 427.28, ["Ride"] = 282.17, ["Fly|Ride"] = 376.69, ["Neon"] = 1143.63, ["Neon|Ride"] = 1410.01, ["Neon|Fly|Ride"] = 1396.21, ["Mega|Fly|Ride"] = 5048.82}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 77.18, ["Ride"] = 41.68, ["Fly|Ride"] = 220.56, ["Neon"] = 23.9, ["Neon|Ride"] = 56.54, ["Mega"] = 321.39, ["Mega|Fly"] = 357.9, ["Mega|Ride"] = 427.33}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Fly"] = 28.86, ["Ride"] = 26.25, ["Neon"] = 39.83, ["Mega"] = 249.38, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 15.86, ["Ride"] = 56.59, ["Fly|Ride"] = 143.15, ["Neon"] = 122.07, ["Neon|Fly"] = 427.28, ["Neon|Ride"] = 98.44, ["Mega"] = 772.4, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 854.65}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.76, ["Neon"] = 21.38, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 48.17, ["Mega"] = 240.74, ["Mega|Ride"] = 256.41, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.61, ["Fly|Ride"] = 32.71, ["Neon"] = 2.1, ["Neon|Fly"] = 20.79, ["Neon|Ride"] = 19.23, ["Neon|Fly|Ride"] = 40.73, ["Mega"] = 23.73, ["Mega|Ride"] = 38.88, ["Mega|Fly|Ride"] = 96.22}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 5473.91, ["Ride"] = 4461.19, ["Fly|Ride"] = 4987.5, ["Neon"] = 32045.26, ["Neon|Fly|Ride"] = 21366.07, ["Mega|Fly|Ride"] = 52500}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 6.49, ["Fly"] = 85.46, ["Ride"] = 41.91, ["Neon"] = 78.75, ["Neon|Ride"] = 101.49, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 210, ["Mega|Fly"] = 327.98, ["Mega|Ride"] = 215.04, ["Mega|Fly|Ride"] = 327.98}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.7, ["Ride"] = 20.7, ["Fly|Ride"] = 49.88, ["Neon"] = 14.34, ["Neon|Fly"] = 45.92, ["Neon|Ride"] = 36.09, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 131.25, ["Mega|Ride"] = 143.17, ["Mega|Fly|Ride"] = 206.2}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 387.19, ["Fly"] = 547.77, ["Ride"] = 446.25, ["Fly|Ride"] = 550.12, ["Neon"] = 2100, ["Neon|Ride"] = 1292.82, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 4873.32}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 2.38, ["Ride"] = 43.85, ["Neon"] = 13.85, ["Neon|Ride"] = 291.38, ["Mega"] = 187.94, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.82, ["Fly"] = 145.69, ["Ride"] = 36.33, ["Neon"] = 131.25, ["Neon|Fly"] = 118.58, ["Neon|Ride"] = 119.18, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 426.27, ["Mega|Ride"] = 285.26, ["Mega|Fly|Ride"] = 741.41}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 51.07, ["Ride"] = 21, ["Fly|Ride"] = 65.62, ["Neon"] = 9.07, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 35.41, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 52.49, ["Mega|Ride"] = 76.04, ["Mega|Fly|Ride"] = 275.62}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 656.24, ["Fly"] = 869.51, ["Ride"] = 656.25, ["Fly|Ride"] = 672, ["Neon|Ride"] = 2126.27, ["Neon|Fly|Ride"] = 2940}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 9.19, ["Ride"] = 91.87, ["Neon"] = 32.54, ["Neon|Fly"] = 114.31, ["Neon|Ride"] = 94.4, ["Neon|Fly|Ride"] = 143.17, ["Mega"] = 196.88, ["Mega|Fly"] = 427.33, ["Mega|Ride"] = 231.67, ["Mega|Fly|Ride"] = 425.04}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 6.29, ["Fly"] = 236.25, ["Ride"] = 45.94, ["Fly|Ride"] = 104.99, ["Neon"] = 23.62, ["Neon|Ride"] = 62.37, ["Neon|Fly|Ride"] = 200.74, ["Mega"] = 162.64, ["Mega|Fly"] = 802.82, ["Mega|Ride"] = 185.16, ["Mega|Fly|Ride"] = 287.44}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.13, ["Ride"] = 20.29, ["Fly|Ride"] = 54.55, ["Neon"] = 18.08, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 32.5, ["Neon|Fly|Ride"] = 82.93, ["Mega"] = 285.26, ["Mega|Fly"] = 285.26, ["Mega|Ride"] = 158.12, ["Mega|Fly|Ride"] = 192.31}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 21, ["Ride"] = 51.3, ["Fly|Ride"] = 58.59, ["Neon"] = 117.59, ["Mega"] = 854.65, ["Mega|Ride"] = 622.13, ["Mega|Fly|Ride"] = 852.52}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 43.31, ["Fly|Ride"] = 80.67, ["Neon"] = 4.2, ["Neon|Ride"] = 49.16, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 31.12, ["Mega|Ride"] = 78.66, ["Mega|Fly|Ride"] = 222.23}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 608.89, ["Ride"] = 630, ["Fly|Ride"] = 630, ["Neon"] = 2589.57, ["Neon|Ride"] = 2194.05, ["Neon|Fly|Ride"] = 2391.38, ["Mega|Ride"] = 9388.19, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Neon"] = 15.68, ["Neon|Ride"] = 93.64, ["Neon|Fly|Ride"] = 427.33, ["Mega"] = 81.2, ["Mega|Ride"] = 161.27, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 5.41, ["Neon|Fly"] = 242.49, ["Neon|Ride"] = 76.93, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 47.01, ["Mega|Ride"] = 137.23, ["Mega|Fly|Ride"] = 285.26}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 60.44, ["Neon"] = 3.63, ["Neon|Ride"] = 55.57, ["Neon|Fly|Ride"] = 143.17, ["Mega"] = 64.12, ["Mega|Fly"] = 158.12, ["Mega|Ride"] = 125.14, ["Mega|Fly|Ride"] = 199.79}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 13.13, ["Neon|Ride"] = 48.18, ["Mega"] = 213.68, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 27.57, ["Fly"] = 72.19, ["Ride"] = 49.49, ["Fly|Ride"] = 144.37, ["Neon"] = 142.91, ["Neon|Fly"] = 213.65, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 213.68, ["Mega"] = 511.88, ["Mega|Ride"] = 480.75, ["Mega|Fly|Ride"] = 556.36}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 14.44, ["Fly"] = 96.32, ["Ride"] = 55.64, ["Fly|Ride"] = 149.52, ["Neon"] = 84.07, ["Neon|Ride"] = 162.39, ["Neon|Fly|Ride"] = 282.01, ["Mega"] = 520, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 575.72}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 16.7, ["Fly|Ride"] = 34.93, ["Neon"] = 22.32, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 88.69, ["Mega"] = 298.6, ["Mega|Ride"] = 285.26, ["Mega|Fly|Ride"] = 239.56}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 7.88, ["Ride"] = 57.03, ["Fly|Ride"] = 142.06, ["Neon"] = 38.05, ["Neon|Ride"] = 91.88}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 26.17, ["Fly|Ride"] = 106.84, ["Neon"] = 10.38, ["Neon|Ride"] = 49.16, ["Neon|Fly|Ride"] = 128.21, ["Mega"] = 76.12, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 284.19}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 18.38, ["Fly"] = 113.17, ["Ride"] = 28.98, ["Fly|Ride"] = 63.34, ["Neon"] = 110.25, ["Neon|Ride"] = 80.66, ["Neon|Fly|Ride"] = 289.42, ["Mega"] = 787.5, ["Mega|Fly|Ride"] = 749.97}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 29.94, ["Fly"] = 874.13, ["Neon"] = 98.44, ["Mega"] = 332.06, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 498.91}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 46.69, ["Fly"] = 115.58, ["Ride"] = 81.87, ["Fly|Ride"] = 128.2, ["Neon"] = 328.13, ["Neon|Ride"] = 277.71, ["Neon|Fly|Ride"] = 419.9, ["Mega"] = 1925.79, ["Mega|Ride"] = 1765.72, ["Mega|Fly|Ride"] = 1273.13}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 31.5, ["Fly"] = 128.83, ["Ride"] = 65.63, ["Fly|Ride"] = 131.25, ["Neon"] = 104.9, ["Neon|Ride"] = 144.37, ["Neon|Fly|Ride"] = 309.74, ["Mega"] = 722.18, ["Mega|Ride"] = 826.88, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 15.75, ["Ride"] = 40.61, ["Neon"] = 131.25, ["Neon|Ride"] = 223.12, ["Mega"] = 658.39, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 798.04}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 18.18, ["Fly"] = 81.74, ["Ride"] = 70.88, ["Fly|Ride"] = 247.79, ["Neon"] = 144.27, ["Neon|Fly"] = 256.37, ["Neon|Ride"] = 232.59, ["Neon|Fly|Ride"] = 210, ["Mega"] = 687.42, ["Mega|Ride"] = 606.63, ["Mega|Fly|Ride"] = 701.09}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 18.08, ["Ride"] = 15.67, ["Fly|Ride"] = 32.78, ["Neon"] = 2.4, ["Neon|Fly"] = 27.8, ["Neon|Ride"] = 21.38, ["Neon|Fly|Ride"] = 57.7, ["Mega"] = 46.9, ["Mega|Fly"] = 321.39, ["Mega|Ride"] = 57.7, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 866.25}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 77.35, ["Fly"] = 481.53, ["Ride"] = 129.94, ["Fly|Ride"] = 330.74, ["Neon"] = 420, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 563, ["Mega"] = 1417.5, ["Mega|Ride"] = 1561.88, ["Mega|Fly|Ride"] = 1472.07}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 79.76, ["Neon"] = 2.63, ["Neon|Fly"] = 100.43, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 299, ["Mega"] = 27.28, ["Mega|Ride"] = 85.46, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 26.17, ["Ride"] = 66.98, ["Neon"] = 148.82, ["Neon|Ride"] = 135.33, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 591.93, ["Mega|Ride"] = 511.77, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.62, ["Neon|Fly|Ride"] = 114.33, ["Mega"] = 25.73, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Ride"] = 74.82, ["Neon"] = 3.91, ["Mega"] = 23.63, ["Mega|Ride"] = 151.67, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 93.09, ["Fly"] = 223.13, ["Ride"] = 143.47, ["Fly|Ride"] = 351.38, ["Neon"] = 433.13, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 645.75, ["Mega|Ride"] = 2690.01, ["Mega|Fly|Ride"] = 2093.44}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 19.28, ["Fly|Ride"] = 88.47, ["Neon"] = 5.1, ["Neon|Fly"] = 42.74, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 91.68, ["Mega|Ride"] = 118.12, ["Mega|Fly|Ride"] = 213.68}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 57.69, ["Neon"] = 5.25, ["Neon|Fly"] = 42.74, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 419.9, ["Mega"] = 32.8, ["Mega|Ride"] = 128.21, ["Mega|Fly|Ride"] = 217.87}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 72.36, ["Neon"] = 3.78, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 236.15, ["Mega"] = 131.24, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 554.47}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 91.49, ["Neon"] = 7.6, ["Neon|Ride"] = 137.82, ["Mega"] = 98.44, ["Mega|Ride"] = 337.02, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 84.45, ["Ride"] = 185.88, ["Fly|Ride"] = 114.31, ["Neon"] = 437.07, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2421.86, ["Mega|Ride"] = 2286.88, ["Mega|Fly|Ride"] = 2263.74}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.27, ["Ride"] = 94.01, ["Neon"] = 90.9, ["Mega"] = 418.05, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 645.74}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 393.74, ["Ride"] = 423.05, ["Fly|Ride"] = 709.28, ["Neon"] = 1050, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1113, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 90.57}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 47.25}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 32.15}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 23.51}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 52.5}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 46.69}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 10.4}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 6.57}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 190.25}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 17.52}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 22.32}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 10.48}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 9.08}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 839.99}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 7.63}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 6.51}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 11.79}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 4.92}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 17.54}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 639.85}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 471.19}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 9.08}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1412.25}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 52.39}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 4.85}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 34.31}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 24.66}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 45.76}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 57.7}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 16.64}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 9.19}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 16.7}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 4.87}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 24.94}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 3.28}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 21}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 15.04}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.19}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 3062.47}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 53.82}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 315}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 3.61}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 13.89}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 8.9}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 32.82}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 213.88}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 10.13}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 9.19}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 144.38}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 38.07}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 28.83}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 14.43}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 105}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 27.28}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 10.5}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 19.69}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 9.18}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 2.82}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 15.75}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 91.87}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 254.63}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 7.88}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 288.67}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.86}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 76.67}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 20.55}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 23956.55}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 124.69}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 57.74}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 37.71}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 26.9}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 55.13}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 23.29}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 31.97}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 87.44}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 81.81}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 26.25}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 103.69}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 422.71}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 48.57}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 48.38}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 214.27}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 6.45}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 6.56}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 5.95}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 17.07}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 143.05}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 2.63}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 2.5}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 13.13}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 183.75}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 830.75}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 9.19}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 590.27}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 7.88}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 231}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 28.76}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 99.63}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 17.06}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 30.18}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 61.34}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 15.14}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 2.63}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 7.49}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.36}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 2.43}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 5.81}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 32.69}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 5.2}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.96}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.84}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 16.58}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 162.75}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 51.54}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 216.56}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 13.13}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 10.5}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 5.25}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 21}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 7.7}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 3.82}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 7.76}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 3.77}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 6.28}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 31.5}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 13.08}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 5.92}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 2.1}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 7.8}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 14.8}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 2.92}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 5.2}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.2}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 8.56}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 6.41}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 9399.95}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 14.34}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 4.07}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 2.57}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 3.29}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 63}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 5.19}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 3.94}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 2.38}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.52}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 6.56}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 19.69}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 5.03}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.51}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.15}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4400.9}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 6.25}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.45}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 38.07}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.51}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 5.25}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 71.96}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 3.94}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 85.32}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 8.54}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 2.59}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 11.69}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 18.38}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 8.99}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.84}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 4.81}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 3.9}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.77}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 19.35}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 3.34}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 10.5}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 70.88}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 79.76}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 9.68}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.27}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1214.07}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 63.52}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.26}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 3.9}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 31.19}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 27.53}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.25}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 9.19}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 15.28}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 12.86}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 13.01}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 2.57}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.42}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 9.19}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.18}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 23.28}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 3.62}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 6.69}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 59.27}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 6.56}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 173.88}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 91.88}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 11.44}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.63}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 27.57}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 33.13}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 5.25}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 17.06}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 3.48}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 80.05}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 143.15}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 5.36}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1275.1}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.52}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 196.88}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 7.35}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 46.78}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 6.18}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.59}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 64.97}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 22.32}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 15.75}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 5.65}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 52.96}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 63}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.63}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 37.49}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 112.88}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 85.32}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 8}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 63.02}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.62}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 89.42}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 53.61}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 262.5}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.86}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 65.58}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 140.2}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 5.25}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 44.34}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 56.44}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 63}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 3.8}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 8.97}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 21.72}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 78.75}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 39.1}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 14.44}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 41.28}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 3.94}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 28.88}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 18.18}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 82.49}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 49.14}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 26.25}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1994.98}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 10.24}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 7.24}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 20.89}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 263.34}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 15.75}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 7.88}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 16.68}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 10.49}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 7.88}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 286.92}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 62.34}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 49.88}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 55.88}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 225.74}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 77.84}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 918.75}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 179.82}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 7.88}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1727.25}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 570.41}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 4.29}},
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