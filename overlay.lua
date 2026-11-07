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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1131.61, ["Ride"] = 1312.5, ["Fly|Ride"] = 2095.55, ["Neon"] = 9187.5, ["Neon|Fly|Ride"] = 3921.75, ["Mega|Fly|Ride"] = 25143.57}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 454.68, ["Fly"] = 622.67, ["Ride"] = 457.68, ["Fly|Ride"] = 524.74, ["Neon"] = 2095.55, ["Neon|Ride"] = 2200.33, ["Neon|Fly|Ride"] = 2072.43, ["Mega|Fly|Ride"] = 9006.62}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4724.99, ["Ride"] = 4365.93, ["Fly|Ride"] = 4461.19, ["Neon|Fly|Ride"] = 15749.99, ["Mega|Fly|Ride"] = 68873.94}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 128.63, ["Ride"] = 177.19, ["Fly|Ride"] = 262.5, ["Neon"] = 831.94, ["Neon|Ride"] = 821.63, ["Neon|Fly|Ride"] = 786.59, ["Mega"] = 4051.72, ["Mega|Fly|Ride"] = 2887.5}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 555.51, ["Fly"] = 656.96, ["Ride"] = 539.43, ["Fly|Ride"] = 538.13, ["Neon|Ride"] = 1837.5, ["Neon|Fly|Ride"] = 1534.32, ["Mega|Fly|Ride"] = 6300}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 11.82, ["Ride"] = 35.64, ["Fly|Ride"] = 140.42, ["Neon"] = 59.07, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 279.78, ["Mega"] = 275.13, ["Mega|Ride"] = 470.38, ["Mega|Fly|Ride"] = 426.46}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.22, ["Fly"] = 34.37, ["Ride"] = 25.15, ["Fly|Ride"] = 59.06, ["Neon"] = 33.78, ["Neon|Fly"] = 110.01, ["Neon|Ride"] = 56.69, ["Neon|Fly|Ride"] = 122.07, ["Mega"] = 338.46, ["Mega|Fly"] = 273.6, ["Mega|Ride"] = 283.03, ["Mega|Fly|Ride"] = 291.09}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 98.15, ["Fly"] = 195.96, ["Ride"] = 160.77, ["Fly|Ride"] = 178.5, ["Neon"] = 523.88, ["Neon|Ride"] = 531.24, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1886.83, ["Mega|Fly|Ride"] = 2305.1}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 37.73, ["Fly"] = 140.33, ["Ride"] = 39.29, ["Fly|Ride"] = 104.79, ["Neon"] = 336.59, ["Neon|Ride"] = 204.75, ["Neon|Fly|Ride"] = 274.65, ["Mega"] = 1397.74, ["Mega|Ride"] = 2730, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 28.3, ["Fly"] = 28.51, ["Ride"] = 36.74, ["Fly|Ride"] = 78.75, ["Neon"] = 140.42, ["Neon|Ride"] = 165.38, ["Neon|Fly|Ride"] = 210, ["Mega|Fly|Ride"] = 626.07}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 39.89, ["Fly"] = 56.59, ["Ride"] = 59.24, ["Fly|Ride"] = 117.95, ["Neon"] = 235.87, ["Neon|Ride"] = 246.24, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1492.96}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 70.76}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 379.21, ["Fly"] = 399, ["Ride"] = 351.75, ["Fly|Ride"] = 402.94, ["Neon"] = 1283.63, ["Neon|Ride"] = 1415.13, ["Neon|Fly|Ride"] = 1173.37, ["Mega|Fly|Ride"] = 4652.82}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 105, ["Fly"] = 131.25, ["Ride"] = 111.57, ["Fly|Ride"] = 144.38, ["Neon|Ride"] = 564.38, ["Neon|Fly|Ride"] = 483, ["Mega|Fly|Ride"] = 2626.77}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.63, ["Fly"] = 115.91, ["Ride"] = 49.97, ["Fly|Ride"] = 209.57, ["Neon"] = 19.72, ["Neon|Ride"] = 63.7, ["Mega"] = 141.7, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 349.97}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 140.4, ["Fly"] = 217, ["Ride"] = 180.06, ["Fly|Ride"] = 194.24, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 591.94, ["Mega|Fly|Ride"] = 1903.13}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.29, ["Fly"] = 27.15, ["Ride"] = 22.23, ["Fly|Ride"] = 52.4, ["Neon"] = 40.88, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 262.5, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 305.82}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 72.17, ["Fly"] = 262.5, ["Ride"] = 86.63, ["Fly|Ride"] = 167.66, ["Neon"] = 249.37, ["Neon|Ride"] = 264.27, ["Neon|Fly|Ride"] = 441.91, ["Mega"] = 1385.95, ["Mega|Ride"] = 941.85, ["Mega|Fly|Ride"] = 1038.45}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 46.11}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 77.44, ["Ride"] = 140.42, ["Fly|Ride"] = 218.12, ["Neon"] = 826.88, ["Neon|Fly|Ride"] = 2362.5}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 11.82, ["Fly"] = 374.07, ["Ride"] = 32.36, ["Fly|Ride"] = 78.75, ["Neon"] = 144.38, ["Neon|Ride"] = 343.98, ["Neon|Fly|Ride"] = 192.8, ["Mega"] = 698.87, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 1676.45}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 35.44, ["Fly"] = 64.31, ["Ride"] = 65.54, ["Fly|Ride"] = 125.97, ["Neon"] = 683.17, ["Neon|Fly"] = 312.24, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 236.15, ["Mega"] = 1650.97, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 37.82, ["Fly"] = 413.88, ["Ride"] = 155.76, ["Fly|Ride"] = 138.32, ["Neon"] = 204.75, ["Neon|Fly"] = 391.53, ["Neon|Ride"] = 186.17, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 823.56, ["Mega|Ride"] = 1253.14, ["Mega|Fly|Ride"] = 1101.44}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 41.92, ["Fly"] = 63.7, ["Ride"] = 56.49, ["Fly|Ride"] = 129.29, ["Neon"] = 141.52, ["Neon|Ride"] = 291.25, ["Neon|Fly|Ride"] = 287.07, ["Mega"] = 1207.92, ["Mega|Ride"] = 2093.45, ["Mega|Fly|Ride"] = 1240.57}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 52.49, ["Fly"] = 593.6, ["Ride"] = 78.6, ["Fly|Ride"] = 158.04, ["Neon"] = 312.24, ["Neon|Ride"] = 309.74, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 974.58, ["Mega|Fly|Ride"] = 943.69}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 6.39, ["Fly"] = 31.49, ["Ride"] = 18.38, ["Fly|Ride"] = 38.64, ["Neon"] = 30.43, ["Neon|Fly"] = 57.74, ["Neon|Ride"] = 44.62, ["Neon|Fly|Ride"] = 94.96, ["Mega"] = 159.5, ["Mega|Fly"] = 211.97, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 341.01, ["Ride"] = 352.87, ["Fly|Ride"] = 306.46, ["Neon"] = 1475.25, ["Neon|Ride"] = 1676.45, ["Neon|Fly|Ride"] = 1627.5, ["Mega"] = 12573.22, ["Mega|Fly|Ride"] = 7332.94}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 14.44, ["Ride"] = 34.32, ["Fly|Ride"] = 105.18, ["Neon"] = 251.48, ["Neon|Ride"] = 406.55, ["Neon|Fly|Ride"] = 427.5, ["Mega|Fly|Ride"] = 895.85}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 6.57, ["Fly"] = 39.47, ["Ride"] = 19.67, ["Fly|Ride"] = 53.43, ["Neon"] = 59.07, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 90.57, ["Mega|Ride"] = 619.5, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 106.24, ["Fly"] = 112.12, ["Ride"] = 98.51, ["Fly|Ride"] = 141.52, ["Neon"] = 379.31, ["Neon|Ride"] = 462.29, ["Neon|Fly|Ride"] = 452.65, ["Mega"] = 6248.92, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 1886.83}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 13.71, ["Fly"] = 32.49, ["Ride"] = 28.28, ["Fly|Ride"] = 115.5, ["Neon"] = 189, ["Neon|Ride"] = 79.03, ["Neon|Fly|Ride"] = 158.82, ["Mega"] = 707.57, ["Mega|Ride"] = 639.15, ["Mega|Fly|Ride"] = 483}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 178.5, ["Fly"] = 354.16, ["Ride"] = 210, ["Fly|Ride"] = 245.17, ["Neon"] = 943.43, ["Neon|Ride"] = 629.74, ["Neon|Fly|Ride"] = 773.07, ["Mega"] = 6286.62, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2858.63}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 26.25}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.94, ["Fly"] = 33.8, ["Ride"] = 24.11, ["Fly|Ride"] = 72.96, ["Neon"] = 23.63, ["Neon|Fly"] = 4725.72, ["Neon|Ride"] = 54.26, ["Neon|Fly|Ride"] = 154.5, ["Mega"] = 131.25, ["Mega|Fly"] = 282.99, ["Mega|Ride"] = 235.96, ["Mega|Fly|Ride"] = 235.87}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 1454.85, ["Fly"] = 4593.75, ["Ride"] = 1650.97, ["Fly|Ride"] = 1620.07, ["Neon"] = 7021.88, ["Neon|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 6562.5, ["Mega|Ride"] = 53066.72, ["Mega|Fly|Ride"] = 26403.75}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 9.19, ["Fly"] = 69.13, ["Ride"] = 34.13, ["Fly|Ride"] = 90.13, ["Neon"] = 104.42, ["Neon|Ride"] = 118.09, ["Neon|Fly|Ride"] = 141.52, ["Mega"] = 511.88, ["Mega|Ride"] = 623.44, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 104.89, ["Ride"] = 145.2, ["Fly|Ride"] = 249.38, ["Neon"] = 656.25, ["Neon|Ride"] = 689.07, ["Neon|Fly|Ride"] = 993.29, ["Mega|Ride"] = 2723.16, ["Mega|Fly|Ride"] = 2752.5}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 44.63}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 18.87, ["Fly"] = 68.85, ["Ride"] = 55.46, ["Fly|Ride"] = 140.42, ["Neon"] = 254.49, ["Neon|Ride"] = 206.07, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 682.5, ["Mega|Fly|Ride"] = 739.41}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 78.75, ["Ride"] = 209.57, ["Fly|Ride"] = 205.65, ["Neon"] = 525, ["Neon|Ride"] = 629.74, ["Neon|Fly|Ride"] = 656.96, ["Mega"] = 2794.4, ["Mega|Fly|Ride"] = 2317.67}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 118.13, ["Ride"] = 160.74, ["Fly|Ride"] = 236.25, ["Neon"] = 434.84, ["Neon|Ride"] = 366.18, ["Neon|Fly|Ride"] = 640.5, ["Mega"] = 1575, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1957.25}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 39.38}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 49.26, ["Fly"] = 43.32, ["Ride"] = 63.6, ["Fly|Ride"] = 65.6, ["Neon|Ride"] = 400.96, ["Neon|Fly|Ride"] = 262.48, ["Mega"] = 4191.09, ["Mega|Fly|Ride"] = 1509.37}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 5.24, ["Ride"] = 37.8, ["Fly|Ride"] = 158.23, ["Neon"] = 33.54, ["Neon|Ride"] = 70.19, ["Neon|Fly|Ride"] = 233.67, ["Mega"] = 224.07, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 187.69, ["Mega|Fly|Ride"] = 398.06}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 328.13, ["Fly"] = 420, ["Ride"] = 406.86, ["Fly|Ride"] = 433.12, ["Neon|Ride"] = 1568.73, ["Neon|Fly|Ride"] = 1232.6, ["Mega|Fly|Ride"] = 6109.69}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 78.75, ["Fly"] = 99.75, ["Ride"] = 106.88, ["Fly|Ride"] = 140.42, ["Neon"] = 413.82, ["Neon|Ride"] = 377.37, ["Neon|Fly|Ride"] = 393.74, ["Mega|Ride"] = 1885.99, ["Mega|Fly|Ride"] = 1952.82}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3184.13, ["Fly"] = 3543.75, ["Ride"] = 3433.5, ["Fly|Ride"] = 3018.74, ["Neon|Fly|Ride"] = 14667.71}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 42, ["Fly"] = 112.12, ["Ride"] = 57.74, ["Fly|Ride"] = 103.74, ["Neon"] = 392.44, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 314.25, ["Mega|Ride"] = 1628.25, ["Mega|Fly|Ride"] = 1443.84}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 74.3, ["Ride"] = 57.75, ["Fly|Ride"] = 199.1, ["Neon"] = 656.25, ["Neon|Ride"] = 326.91, ["Neon|Fly|Ride"] = 559.53, ["Mega"] = 6286.62, ["Mega|Fly|Ride"] = 1662.83}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 35.42, ["Fly"] = 86.63, ["Ride"] = 63, ["Fly|Ride"] = 140.42, ["Neon"] = 203.44, ["Neon|Ride"] = 167.66, ["Neon|Fly|Ride"] = 230.91, ["Mega"] = 2598.75, ["Mega|Ride"] = 667.12, ["Mega|Fly|Ride"] = 831.94}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 9.19}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 36.3, ["Ride"] = 56.39, ["Fly|Ride"] = 72.17, ["Neon"] = 328.13, ["Neon|Ride"] = 480.95, ["Neon|Fly|Ride"] = 502.94, ["Mega|Fly|Ride"] = 1554.91}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 34.13}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 301.88, ["Ride"] = 221.72, ["Fly|Ride"] = 320.63, ["Neon|Ride"] = 1397.45, ["Neon|Fly|Ride"] = 1912.62}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 918.74, ["Ride"] = 955.5, ["Fly|Ride"] = 945, ["Neon|Fly|Ride"] = 3806.24, ["Mega|Fly|Ride"] = 15647.38}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 5.34}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 28.59, ["Fly"] = 52.46, ["Ride"] = 49.88, ["Fly|Ride"] = 64.3, ["Neon"] = 162.75, ["Neon|Fly"] = 209.57, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 199.63, ["Mega|Ride"] = 877.14, ["Mega|Fly|Ride"] = 765.19}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 10.5}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 4961.99, ["Ride"] = 4462.5, ["Fly|Ride"] = 4591.13, ["Neon|Fly|Ride"] = 10500, ["Mega|Fly|Ride"] = 35220.98}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 12.94, ["Fly"] = 74.65, ["Ride"] = 24.08, ["Fly|Ride"] = 52.5, ["Neon"] = 70.22, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 525, ["Mega|Ride"] = 629.74, ["Mega|Fly|Ride"] = 582.75}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 11.73, ["Fly"] = 191.66, ["Ride"] = 32.33, ["Fly|Ride"] = 116.76, ["Neon"] = 131.25, ["Neon|Ride"] = 118.12, ["Neon|Fly|Ride"] = 178.14, ["Mega"] = 1047.78, ["Mega|Ride"] = 626.58, ["Mega|Fly|Ride"] = 698.87}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 110.87, ["Fly"] = 167.03, ["Ride"] = 124.68, ["Fly|Ride"] = 103.69, ["Neon"] = 1397.74, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 4191.09}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 14.14, ["Ride"] = 28.87, ["Fly|Ride"] = 139.65, ["Neon"] = 55.41, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 501.36, ["Mega"] = 364.64, ["Mega|Ride"] = 417.03, ["Mega|Fly|Ride"] = 559.53}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1968.65, ["Fly"] = 2463.33, ["Ride"] = 2191.6, ["Fly|Ride"] = 1901.81, ["Neon|Fly|Ride"] = 5446.88, ["Mega|Fly|Ride"] = 15079.32}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 31433.03, ["Fly"] = 35220.98, ["Ride"] = 34926.28, ["Fly|Ride"] = 23231.25, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 64611.75, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 195583.56}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 14.43, ["Fly"] = 393.75, ["Ride"] = 39.38, ["Fly|Ride"] = 125.73, ["Neon"] = 236.25, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 257.6, ["Mega"] = 838.13, ["Mega|Ride"] = 1102.5, ["Mega|Fly|Ride"] = 1470}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.68, ["Fly"] = 59.84, ["Ride"] = 39.38, ["Fly|Ride"] = 167.47, ["Neon"] = 23.63, ["Neon|Fly"] = 98.51, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 157.48, ["Mega"] = 158.81, ["Mega|Ride"] = 175.77, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 23.54}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 6.49, ["Ride"] = 52.49, ["Fly|Ride"] = 111.57, ["Neon"] = 61.69, ["Neon|Ride"] = 105.25, ["Neon|Fly|Ride"] = 463.21, ["Mega"] = 418.07, ["Mega|Ride"] = 305.81, ["Mega|Fly|Ride"] = 544.04}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 787.5, ["Ride"] = 682.5, ["Fly|Ride"] = 734.99, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 11007.23}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 997.49, ["Fly"] = 900.38, ["Ride"] = 820.32, ["Fly|Ride"] = 961.17, ["Neon"] = 4191.09, ["Neon|Ride"] = 2794.4, ["Neon|Fly|Ride"] = 2774.64, ["Mega|Fly|Ride"] = 11309.61}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 31.45, ["Fly"] = 117.95, ["Ride"] = 56.59, ["Fly|Ride"] = 93.19, ["Neon"] = 140.42, ["Neon|Ride"] = 174.55, ["Neon|Fly|Ride"] = 220.5, ["Mega"] = 835.11, ["Mega|Ride"] = 682.5, ["Mega|Fly|Ride"] = 810.99}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 24.68}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 91.18, ["Fly"] = 111.57, ["Ride"] = 73.5, ["Fly|Ride"] = 132.57, ["Neon|Ride"] = 405.5, ["Neon|Fly|Ride"] = 410.82, ["Mega|Fly|Ride"] = 1788.55}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 47.08, ["Ride"] = 64.31, ["Fly|Ride"] = 188.69, ["Neon"] = 450.19, ["Neon|Ride"] = 424.54, ["Neon|Fly|Ride"] = 553.88, ["Mega"] = 1758.17, ["Mega|Fly|Ride"] = 1695.15}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.68, ["Fly"] = 32.81, ["Ride"] = 21.23, ["Fly|Ride"] = 56.35, ["Neon"] = 28.12, ["Neon|Fly"] = 314.88, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 157.5, ["Mega|Ride"] = 398.18, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 89.25, ["Fly"] = 85.32, ["Ride"] = 105, ["Fly|Ride"] = 159.21, ["Neon"] = 810.99, ["Neon|Ride"] = 284.82, ["Neon|Fly|Ride"] = 314.99, ["Mega|Fly|Ride"] = 1184.26}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.94, ["Ride"] = 45.93, ["Fly|Ride"] = 105, ["Neon"] = 23.63, ["Neon|Ride"] = 112.87, ["Neon|Fly|Ride"] = 183.74, ["Mega"] = 225.75, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 17.07, ["Fly"] = 40.28, ["Ride"] = 32.48, ["Fly|Ride"] = 65.62, ["Neon"] = 78.75, ["Neon|Fly"] = 126.19, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 204.33, ["Mega"] = 740.79, ["Mega|Fly|Ride"] = 698.87}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 25.7, ["Ride"] = 63.7, ["Fly|Ride"] = 156.19, ["Neon"] = 237.57, ["Neon|Ride"] = 349.08, ["Mega"] = 694.25, ["Mega|Ride"] = 550.73, ["Mega|Fly|Ride"] = 871.68}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 17.06, ["Fly"] = 77.33, ["Ride"] = 31.02, ["Fly|Ride"] = 82.69, ["Neon"] = 70.22, ["Neon|Fly"] = 559.53, ["Neon|Ride"] = 123.65, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 1047.78, ["Mega|Ride"] = 934.63, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 5118.75, ["Ride"] = 7075.58, ["Fly|Ride"] = 5512.5, ["Neon"] = 34921.69, ["Neon|Fly|Ride"] = 26193.15}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 229.69, ["Fly"] = 272.9, ["Ride"] = 241.91, ["Fly|Ride"] = 304.5, ["Neon"] = 681.63, ["Neon|Ride"] = 551.25, ["Neon|Fly|Ride"] = 523.1, ["Mega|Fly|Ride"] = 1860.98}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 28.3, ["Fly"] = 125.74, ["Ride"] = 72.18, ["Fly|Ride"] = 127.08, ["Neon"] = 83.84, ["Neon|Fly"] = 194.15, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 330.6, ["Mega|Fly"] = 559.53, ["Mega|Ride"] = 338.1, ["Mega|Fly|Ride"] = 416.07}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.94, ["Ride"] = 24.11, ["Fly|Ride"] = 91.18, ["Neon"] = 28.88, ["Neon|Ride"] = 56.27, ["Neon|Fly|Ride"] = 94.35, ["Mega"] = 173.95, ["Mega|Ride"] = 170.63}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 34.61, ["Fly"] = 5285.81, ["Ride"] = 101.07, ["Fly|Ride"] = 154.49, ["Neon"] = 116.82, ["Neon|Fly"] = 324.82, ["Neon|Ride"] = 126.18, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 435.74, ["Mega|Ride"] = 449.06, ["Mega|Fly|Ride"] = 582.09}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 12810, ["Ride"] = 10084.2, ["Fly|Ride"] = 10762.5, ["Neon|Fly|Ride"] = 23493.75, ["Mega|Fly|Ride"] = 90806.85}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 176.11, ["Ride"] = 217.88, ["Fly|Ride"] = 292.35, ["Neon"] = 1313.91, ["Neon|Ride"] = 1537.09, ["Neon|Fly|Ride"] = 943.69, ["Mega|Fly|Ride"] = 4709.73}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 69.04, ["Fly"] = 158.04, ["Ride"] = 68.98, ["Fly|Ride"] = 85.32, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 372.91, ["Mega|Fly|Ride"] = 2044.85}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 10.13, ["Fly"] = 44.83, ["Ride"] = 22.32, ["Fly|Ride"] = 56.59, ["Neon"] = 85.32, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 2514.65, ["Mega|Ride"] = 349.97, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 391.13, ["Fly"] = 838.23, ["Ride"] = 417.38, ["Fly|Ride"] = 131.25, ["Neon"] = 1639.31, ["Neon|Ride"] = 1311.19, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Ride"] = 4724.98, ["Mega|Fly|Ride"] = 4935}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.2, ["Fly"] = 65.63, ["Ride"] = 31.5, ["Fly|Ride"] = 163.47, ["Neon"] = 28.08, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 315, ["Mega"] = 166.69, ["Mega|Ride"] = 240.58, ["Mega|Fly|Ride"] = 279.78}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 208.99, ["Fly"] = 235.87, ["Ride"] = 208.69, ["Fly|Ride"] = 315, ["Neon"] = 771.75, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 978.63, ["Mega|Fly|Ride"] = 3066.83}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.64, ["Fly"] = 19.92, ["Ride"] = 22.42, ["Fly|Ride"] = 39.37, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 101.6, ["Mega"] = 2514.65, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 9.19}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 52.49, ["Ride"] = 167.66, ["Fly|Ride"] = 158.04, ["Neon"] = 367.5, ["Neon|Fly"] = 1676.45, ["Neon|Ride"] = 418.07, ["Neon|Fly|Ride"] = 786.59, ["Mega|Ride"] = 1257.33, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 14.42, ["Ride"] = 38.58, ["Fly|Ride"] = 86.51, ["Neon"] = 74.41, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 501.89, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 616.1}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 19.38}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 30.19, ["Fly"] = 111.57, ["Ride"] = 76.13, ["Fly|Ride"] = 220.54, ["Neon"] = 194.9, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 313.29, ["Mega"] = 775.36, ["Mega|Ride"] = 907.38, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.94, ["Fly|Ride"] = 131.25, ["Neon"] = 24.42, ["Neon|Ride"] = 106.15, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 131.25, ["Mega|Fly|Ride"] = 635.92}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 12.59, ["Fly"] = 70.22, ["Ride"] = 31.5, ["Fly|Ride"] = 60.38, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 224.24, ["Mega|Ride"] = 489.33, ["Mega|Fly|Ride"] = 817.27}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 350.43, ["Ride"] = 380.38, ["Fly|Ride"] = 522.85, ["Neon|Fly|Ride"] = 2655.06, ["Mega|Fly|Ride"] = 8067.83}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 131.24, ["Fly"] = 104.79, ["Ride"] = 77.3, ["Fly|Ride"] = 87.93, ["Neon"] = 279.78, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 287.76, ["Mega"] = 718.86, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 698.87}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 45.17, ["Fly"] = 91.14, ["Ride"] = 64.87, ["Neon"] = 188.69, ["Neon|Ride"] = 212.28, ["Neon|Fly|Ride"] = 339.94, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1246.86}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 25.15, ["Ride"] = 78.74, ["Fly|Ride"] = 148.6, ["Neon"] = 100.82, ["Neon|Ride"] = 161.37, ["Neon|Fly|Ride"] = 275.96, ["Mega"] = 393.75, ["Mega|Ride"] = 405.57, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 10141.36, ["Fly"] = 9948.75, ["Ride"] = 9995.9, ["Fly|Ride"] = 7861.88, ["Neon|Fly|Ride"] = 14306.25, ["Mega|Fly|Ride"] = 39372.9}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1968.65, ["Ride"] = 1740.38, ["Fly|Ride"] = 1823.07, ["Neon"] = 6132.16, ["Neon|Ride"] = 5309.05, ["Neon|Fly|Ride"] = 5184.38, ["Mega|Fly|Ride"] = 24448.61}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 392.43, ["Ride"] = 464.16, ["Fly|Ride"] = 489.33, ["Neon"] = 2095.46, ["Neon|Fly|Ride"] = 2069.36, ["Mega"] = 11792.61, ["Mega|Fly|Ride"] = 6692.11}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 15.71, ["Fly"] = 29.47, ["Ride"] = 20.99, ["Fly|Ride"] = 45.82, ["Neon"] = 108.78, ["Neon|Ride"] = 91.18, ["Neon|Fly|Ride"] = 131.25, ["Mega|Fly|Ride"] = 419.12}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 6.3, ["Fly"] = 31.5, ["Ride"] = 32.16, ["Fly|Ride"] = 124.67, ["Neon"] = 24.93, ["Neon|Ride"] = 61.83, ["Neon|Fly|Ride"] = 157.47, ["Mega"] = 140.42, ["Mega|Ride"] = 190.14, ["Mega|Fly|Ride"] = 270.9}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 39.29, ["Fly"] = 40.68, ["Ride"] = 39.37, ["Fly|Ride"] = 86.57, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 180.43, ["Mega"] = 628.67, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.54, ["Fly"] = 21, ["Ride"] = 20.89, ["Fly|Ride"] = 41.92, ["Neon"] = 28.3, ["Neon|Fly"] = 63.7, ["Neon|Ride"] = 54.5, ["Neon|Fly|Ride"] = 87.47, ["Mega"] = 439.69, ["Mega|Ride"] = 206.07, ["Mega|Fly|Ride"] = 465.93}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 291.46, ["Fly"] = 320.25, ["Ride"] = 294.07, ["Fly|Ride"] = 372.74, ["Neon"] = 1145.92, ["Neon|Ride"] = 1856.16, ["Neon|Fly|Ride"] = 1320.2, ["Mega|Fly|Ride"] = 6286.62}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 26.25, ["Fly"] = 48.19, ["Ride"] = 37.11, ["Fly|Ride"] = 59.07, ["Neon"] = 125.74, ["Neon|Fly"] = 83.84, ["Neon|Ride"] = 156.96, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 597.91}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 8.39, ["Fly"] = 28.3, ["Ride"] = 25.96, ["Fly|Ride"] = 47.16, ["Neon"] = 41.92, ["Neon|Fly"] = 134.46, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 115.77, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 392.43, ["Fly"] = 787.5, ["Ride"] = 393.75, ["Fly|Ride"] = 712.49, ["Neon|Ride"] = 2724.22, ["Mega|Fly|Ride"] = 8619.19}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1128.65, ["Fly"] = 1397.74, ["Ride"] = 1252.12, ["Fly|Ride"] = 1570.62, ["Neon|Ride"] = 4190.03, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 18846.2}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 84.78, ["Fly"] = 125.74, ["Ride"] = 90.45, ["Fly|Ride"] = 120.75, ["Neon"] = 971.25, ["Neon|Ride"] = 559.25, ["Neon|Fly|Ride"] = 494.57, ["Mega|Fly|Ride"] = 2572.28}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 133.14, ["Fly"] = 176.65, ["Ride"] = 152.24, ["Fly|Ride"] = 209.46, ["Neon"] = 556.5, ["Neon|Ride"] = 668.66, ["Neon|Fly|Ride"] = 561.63, ["Mega"] = 5588.8, ["Mega|Ride"] = 8596.88, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 22.31, ["Fly"] = 131.25, ["Ride"] = 45.38, ["Fly|Ride"] = 279.78, ["Neon"] = 178.73, ["Neon|Fly"] = 419.12, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 363.59, ["Mega|Ride"] = 838.23, ["Mega|Fly|Ride"] = 1045.69}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 105, ["Ride"] = 208.52, ["Fly|Ride"] = 597.19, ["Neon|Fly|Ride"] = 1320.79, ["Mega|Fly|Ride"] = 2978.82}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2052.74, ["Ride"] = 2240.61, ["Fly|Ride"] = 2655.06, ["Neon|Fly|Ride"] = 7122.74, ["Mega|Fly|Ride"] = 48197.3}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 67.08, ["Ride"] = 52.4, ["Fly|Ride"] = 196.87, ["Neon"] = 313.29, ["Neon|Fly"] = 314.34, ["Neon|Ride"] = 559.53, ["Neon|Fly|Ride"] = 237.86, ["Mega"] = 2089.26, ["Mega|Ride"] = 2305.1, ["Mega|Fly|Ride"] = 1886.83}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 549.94, ["Fly"] = 733.09, ["Ride"] = 567, ["Fly|Ride"] = 630, ["Neon|Ride"] = 1517.25, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3094.77}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 36.75, ["Fly"] = 51.89, ["Ride"] = 59.73, ["Fly|Ride"] = 103.37, ["Neon"] = 196.88, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 224.24, ["Mega|Fly|Ride"] = 1082.82}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.94, ["Fly"] = 28.3, ["Ride"] = 23.06, ["Fly|Ride"] = 39.38, ["Neon"] = 31.39, ["Neon|Fly"] = 158.04, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 161.41, ["Mega|Fly"] = 249.38, ["Mega|Ride"] = 180.89, ["Mega|Fly|Ride"] = 234.93}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 42.76, ["Ride"] = 105, ["Fly|Ride"] = 158.04, ["Neon"] = 248.07, ["Neon|Ride"] = 262.71, ["Neon|Fly|Ride"] = 559.53, ["Mega|Ride"] = 1397.74, ["Mega|Fly|Ride"] = 824.2}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 615.55, ["Fly"] = 652.77, ["Ride"] = 577.5, ["Fly|Ride"] = 656.25, ["Neon"] = 2430.83, ["Neon|Ride"] = 1988.67, ["Neon|Fly|Ride"] = 1548.73, ["Mega|Fly|Ride"] = 6636.57}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 511.88, ["Ride"] = 577.5, ["Fly|Ride"] = 674.78, ["Neon"] = 5238.84, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 12579.19}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 17.07, ["Fly"] = 26.17, ["Ride"] = 24.86, ["Fly|Ride"] = 49.26, ["Neon"] = 209.57, ["Neon|Ride"] = 108.41, ["Neon|Fly|Ride"] = 118.13, ["Mega|Fly|Ride"] = 629.74}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 6.24, ["Ride"] = 22.32, ["Fly|Ride"] = 41.92, ["Neon"] = 78.75, ["Neon|Ride"] = 56.59, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 1676.45, ["Mega|Ride"] = 349.97, ["Mega|Fly|Ride"] = 378.67}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.9, ["Ride"] = 28.32, ["Fly|Ride"] = 111.46, ["Neon"] = 20.14, ["Neon|Fly"] = 78.93, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 126.18, ["Mega"] = 209.57, ["Mega|Fly"] = 456.39, ["Mega|Ride"] = 225.73, ["Mega|Fly|Ride"] = 330.75}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 27.83, ["Fly"] = 62.89, ["Ride"] = 56.06, ["Fly|Ride"] = 96.6, ["Neon"] = 224.24, ["Neon|Ride"] = 208.95, ["Neon|Fly|Ride"] = 183.75, ["Mega|Fly|Ride"] = 917.44}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 45.48, ["Ride"] = 116.94, ["Fly|Ride"] = 449.61, ["Neon"] = 276.17, ["Neon|Ride"] = 405.5, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1569.57, ["Mega|Ride"] = 1571.67, ["Mega|Fly|Ride"] = 1258.28}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 14.11, ["Fly"] = 54.26, ["Ride"] = 27.26, ["Fly|Ride"] = 83.99, ["Neon"] = 112.35, ["Neon|Fly"] = 150.96, ["Neon|Ride"] = 94.73, ["Neon|Fly|Ride"] = 183.75, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 28.47, ["Fly"] = 65.05, ["Ride"] = 44.54, ["Fly|Ride"] = 89.7, ["Neon"] = 209.57, ["Neon|Ride"] = 222.12, ["Neon|Fly|Ride"] = 174.19, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1179.28}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.97, ["Fly"] = 23.61, ["Ride"] = 19.42, ["Fly|Ride"] = 39.38, ["Neon"] = 32.52, ["Neon|Ride"] = 36.31, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 525, ["Mega|Ride"] = 266.14, ["Mega|Fly|Ride"] = 419.12}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 6.3, ["Fly"] = 26.25, ["Ride"] = 27.09, ["Fly|Ride"] = 67.24, ["Neon"] = 27.2, ["Neon|Fly"] = 158.04, ["Neon|Ride"] = 54.79, ["Neon|Fly|Ride"] = 188.69, ["Mega"] = 261.95, ["Mega|Fly"] = 475.71, ["Mega|Ride"] = 285.87, ["Mega|Fly|Ride"] = 523.89}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 53.82, ["Fly"] = 60.38, ["Ride"] = 61.68, ["Fly|Ride"] = 73.41, ["Neon"] = 409.22, ["Neon|Ride"] = 279.34, ["Neon|Fly|Ride"] = 273, ["Mega|Fly|Ride"] = 919.09}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1575, ["Fly"] = 2362.5, ["Ride"] = 1828.32, ["Fly|Ride"] = 1639.57, ["Neon|Fly"] = 4952.91, ["Neon|Ride"] = 5029.29, ["Neon|Fly|Ride"] = 3740.63, ["Mega|Fly|Ride"] = 17176.69}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 458.67, ["Fly"] = 559.53, ["Ride"] = 459.37, ["Fly|Ride"] = 503.02, ["Neon"] = 3145.1, ["Neon|Ride"] = 3074.16, ["Neon|Fly|Ride"] = 2235.95, ["Mega|Fly|Ride"] = 9747.4}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 210, ["Ride"] = 254.69, ["Fly|Ride"] = 472.5, ["Neon"] = 1202.53, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1443.75, ["Mega"] = 7334.39, ["Mega|Fly|Ride"] = 6825}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 36.75}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 23.59, ["Ride"] = 49.62, ["Fly|Ride"] = 110.25, ["Neon"] = 266.14, ["Neon|Ride"] = 268.59, ["Neon|Fly|Ride"] = 441.06, ["Mega|Ride"] = 832.99, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 33528.56, ["Fly"] = 23625, ["Ride"] = 34781.25, ["Fly|Ride"] = 16232.6, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 393.75, ["Fly"] = 455.23, ["Ride"] = 419.6, ["Fly|Ride"] = 433.13, ["Neon"] = 1523.46, ["Neon|Fly"] = 1603.61, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 6286.62, ["Mega|Fly|Ride"] = 4269.3}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 5250, ["Fly"] = 140.42, ["Ride"] = 136.49, ["Fly|Ride"] = 149.78, ["Neon|Fly|Ride"] = 559.53, ["Mega|Fly|Ride"] = 4191.09}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 104.98, ["Fly"] = 279.78, ["Ride"] = 125.02, ["Fly|Ride"] = 209.57, ["Neon"] = 705.22, ["Neon|Ride"] = 471.19, ["Neon|Fly|Ride"] = 484.09, ["Mega"] = 13970.94, ["Mega|Fly|Ride"] = 5238.84}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 17.7, ["Fly"] = 69.17, ["Ride"] = 28.31, ["Fly|Ride"] = 126, ["Neon"] = 274.3, ["Neon|Ride"] = 135.19, ["Neon|Fly|Ride"] = 192.8, ["Mega"] = 1968.75, ["Mega|Fly|Ride"] = 626.2}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4646.33, ["Ride"] = 4750.59, ["Fly|Ride"] = 3937.37, ["Neon|Fly|Ride"] = 17463.15}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 30.4, ["Fly"] = 49.79, ["Ride"] = 30.18, ["Fly|Ride"] = 54.01, ["Neon"] = 333.94, ["Neon|Ride"] = 207.47, ["Neon|Fly|Ride"] = 179.82, ["Mega"] = 1047.78, ["Mega|Fly|Ride"] = 761.78}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 36.26, ["Fly"] = 115.26, ["Ride"] = 44.15, ["Fly|Ride"] = 111.57, ["Neon"] = 228.8, ["Neon|Fly"] = 1397.74, ["Neon|Ride"] = 276.63, ["Neon|Fly|Ride"] = 210, ["Mega"] = 1573.16, ["Mega|Fly|Ride"] = 1151.51}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 577.5, ["Fly"] = 908.42, ["Ride"] = 578.79, ["Fly|Ride"] = 630, ["Neon"] = 1706.25, ["Neon|Ride"] = 1706.25, ["Neon|Fly|Ride"] = 1561.88, ["Mega|Ride"] = 5943.48, ["Mega|Fly|Ride"] = 4740.27}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 12.55, ["Fly"] = 32.48, ["Ride"] = 26.25, ["Fly|Ride"] = 41.91, ["Neon"] = 104.99, ["Neon|Fly"] = 158.04, ["Neon|Ride"] = 107.63, ["Neon|Fly|Ride"] = 139.82, ["Mega|Fly|Ride"] = 521.06}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 12.3, ["Fly"] = 74.41, ["Ride"] = 77.56, ["Neon"] = 80.07, ["Neon|Ride"] = 192.23, ["Neon|Fly|Ride"] = 249.38, ["Mega|Ride"] = 566.06}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 102.38, ["Fly"] = 471.72, ["Ride"] = 131.25, ["Fly|Ride"] = 245.44, ["Neon"] = 523.89, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 695.73, ["Mega|Fly|Ride"] = 2824.8}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 20.97, ["Fly"] = 94.32, ["Ride"] = 91.88, ["Fly|Ride"] = 167.95, ["Neon"] = 103.58, ["Neon|Fly"] = 188.61, ["Neon|Ride"] = 141.72, ["Neon|Fly|Ride"] = 220.89, ["Mega"] = 312.24, ["Mega|Fly"] = 806.8, ["Mega|Ride"] = 349.8, ["Mega|Fly|Ride"] = 511.27}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3543.75, ["Ride"] = 3478.13, ["Fly|Ride"] = 3411.18, ["Neon|Ride"] = 17811.01, ["Neon|Fly|Ride"] = 8531.24, ["Mega"] = 43820.78, ["Mega|Fly|Ride"] = 34277.58}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 39.38, ["Ride"] = 59.06, ["Fly|Ride"] = 119.22, ["Neon"] = 131.25, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 419.12, ["Mega|Ride"] = 879.1, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7218.75, ["Fly"] = 7703.19, ["Ride"] = 7644.97, ["Fly|Ride"] = 6037.49, ["Neon|Fly|Ride"] = 17718.75, ["Mega|Fly|Ride"] = 64682.86}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.45, ["Fly"] = 23.51, ["Ride"] = 17.07, ["Fly|Ride"] = 39.35, ["Neon"] = 28.3, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 66.05, ["Mega"] = 419.12, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 20.62, ["Fly"] = 25.16, ["Ride"] = 31.85, ["Fly|Ride"] = 60.75, ["Neon"] = 195.96, ["Neon|Ride"] = 559.53, ["Neon|Fly|Ride"] = 155.09, ["Mega|Ride"] = 1444.42, ["Mega|Fly|Ride"] = 943.43}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.94}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 12.5, ["Ride"] = 41.29, ["Fly|Ride"] = 122.84, ["Neon"] = 158.04, ["Neon|Ride"] = 140.42, ["Neon|Fly|Ride"] = 182.33, ["Mega"] = 837.09, ["Mega|Ride"] = 978.63, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 22.28, ["Fly"] = 262.5, ["Ride"] = 45.94, ["Fly|Ride"] = 140.42, ["Neon"] = 182.43, ["Neon|Ride"] = 143.32, ["Neon|Fly|Ride"] = 120, ["Mega"] = 840, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 12.98, ["Fly"] = 27.5, ["Ride"] = 21.62, ["Fly|Ride"] = 41.95, ["Neon|Ride"] = 97.62, ["Neon|Fly|Ride"] = 195.82, ["Mega"] = 656.25, ["Mega|Ride"] = 588.46, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8340.24}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2625}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 21}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 153.57, ["Fly"] = 174.57, ["Ride"] = 174.57, ["Fly|Ride"] = 210, ["Mega|Fly|Ride"] = 5503.62}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 17.15, ["Fly"] = 132.04, ["Ride"] = 56.59, ["Fly|Ride"] = 314.88, ["Neon"] = 124.69, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 276.63, ["Mega"] = 698.87, ["Mega|Ride"] = 896.25, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 10.39}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.2, ["Ride"] = 26.25, ["Neon"] = 54.5, ["Neon|Ride"] = 63.7, ["Neon|Fly|Ride"] = 125.74, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2546.24}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 157.49, ["Fly"] = 209.57, ["Ride"] = 209.57, ["Fly|Ride"] = 417.03, ["Neon"] = 701.37, ["Neon|Ride"] = 593.66, ["Mega|Ride"] = 3479.65, ["Mega|Fly|Ride"] = 3479.65}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 129.43, ["Ride"] = 237.57, ["Fly|Ride"] = 485.63, ["Neon"] = 628.67, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 2493.75, ["Mega|Ride"] = 2778.57, ["Mega|Fly|Ride"] = 2387.44}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 150.94, ["Fly"] = 279.78, ["Ride"] = 170.39, ["Fly|Ride"] = 247.51, ["Neon"] = 799.32, ["Neon|Ride"] = 840, ["Neon|Fly|Ride"] = 890.49, ["Mega"] = 3018.75, ["Mega|Fly|Ride"] = 3412.5}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1508.06, ["Fly"] = 2514.65, ["Ride"] = 1312.48, ["Fly|Ride"] = 1391.04, ["Neon"] = 5031.92, ["Neon|Ride"] = 6147.26, ["Neon|Fly|Ride"] = 4331.25, ["Mega|Fly|Ride"] = 26822.84}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 17.69, ["Fly"] = 81.3, ["Ride"] = 39.38, ["Fly|Ride"] = 86.62, ["Neon"] = 127.3, ["Neon|Ride"] = 140.42, ["Neon|Fly|Ride"] = 314.88, ["Mega"] = 837.18, ["Mega|Ride"] = 622.39, ["Mega|Fly|Ride"] = 1105.41}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 582.75, ["Fly"] = 2100, ["Ride"] = 759.84, ["Fly|Ride"] = 1050, ["Neon|Fly|Ride"] = 3142.28}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 61.69}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 15.17, ["Ride"] = 41.92, ["Fly|Ride"] = 681.8, ["Neon"] = 73.18, ["Neon|Ride"] = 120.5, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 393.62, ["Mega|Ride"] = 441.79, ["Mega|Fly|Ride"] = 532.88}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 10.5, ["Fly"] = 131.25, ["Ride"] = 28.3, ["Fly|Ride"] = 94.5, ["Neon"] = 39.38, ["Neon|Ride"] = 88.03, ["Neon|Fly|Ride"] = 210, ["Mega"] = 918.75, ["Mega|Ride"] = 488.28, ["Mega|Fly|Ride"] = 619.5}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 77.54}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 17.05, ["Ride"] = 31.23, ["Fly|Ride"] = 76.13, ["Neon"] = 196.88, ["Neon|Ride"] = 209.57, ["Mega"] = 590.63, ["Mega|Fly|Ride"] = 1387.72}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 32.82, ["Fly"] = 56.59, ["Ride"] = 39.37, ["Fly|Ride"] = 63.7, ["Neon|Ride"] = 279.78, ["Neon|Fly|Ride"] = 274.32, ["Mega"] = 951.67, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6146.44, ["Fly"] = 10500, ["Ride"] = 5495.44, ["Fly|Ride"] = 5092.5, ["Neon|Ride"] = 17463.15, ["Neon|Fly|Ride"] = 9954.57, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 9.37, ["Fly"] = 79.65, ["Ride"] = 32.68, ["Fly|Ride"] = 83.84, ["Neon"] = 47.25, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 419.12, ["Mega"] = 528.32, ["Mega|Ride"] = 497.7, ["Mega|Fly|Ride"] = 417.38}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 21}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 108.94, ["Fly"] = 370.93, ["Ride"] = 118.13, ["Fly|Ride"] = 196.88, ["Neon"] = 418.69, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 499.8, ["Mega|Ride"] = 4191.09, ["Mega|Fly|Ride"] = 1850.37}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 94.5, ["Ride"] = 158.04, ["Fly|Ride"] = 157.5, ["Neon"] = 327.6, ["Neon|Ride"] = 437.07, ["Neon|Fly|Ride"] = 299.25, ["Mega"] = 2358.54, ["Mega|Ride"] = 2828.99, ["Mega|Fly|Ride"] = 1391.25}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 19.68, ["Fly"] = 70.44, ["Ride"] = 32.69, ["Fly|Ride"] = 79.03, ["Neon"] = 137.28, ["Neon|Ride"] = 139.13, ["Neon|Fly|Ride"] = 132.57, ["Mega|Ride"] = 685.26, ["Mega|Fly|Ride"] = 656.23}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 5.8, ["Fly"] = 79.22, ["Ride"] = 31.2, ["Fly|Ride"] = 78.74, ["Neon"] = 24.94, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 79.65, ["Neon|Fly|Ride"] = 167.66, ["Mega"] = 135.8, ["Mega|Fly"] = 6982.05, ["Mega|Ride"] = 213.88, ["Mega|Fly|Ride"] = 271.68}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 12.73, ["Ride"] = 32.01, ["Fly|Ride"] = 68.88, ["Neon"] = 92.22, ["Neon|Ride"] = 84.96, ["Neon|Fly|Ride"] = 276.63, ["Mega"] = 437.98, ["Mega|Ride"] = 410.82, ["Mega|Fly|Ride"] = 544.69}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 16.62, ["Fly"] = 28.87, ["Ride"] = 27.57, ["Fly|Ride"] = 44.86, ["Neon"] = 208.71, ["Neon|Ride"] = 140.4, ["Neon|Fly|Ride"] = 104.89, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 210}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 23.06, ["Ride"] = 129.94, ["Neon"] = 177.19, ["Mega"] = 1117.98, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1047.78}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 113.96, ["Ride"] = 140.42, ["Fly|Ride"] = 262.5, ["Neon"] = 559.53, ["Neon|Ride"] = 820.32, ["Neon|Fly|Ride"] = 559.53}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 43.32, ["Fly"] = 212.01, ["Ride"] = 104.99, ["Fly|Ride"] = 209.46, ["Neon"] = 286.31, ["Neon|Ride"] = 385.88, ["Neon|Fly|Ride"] = 420, ["Mega"] = 1050, ["Mega|Ride"] = 2178.11, ["Mega|Fly|Ride"] = 1179.8}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 856.96, ["Fly"] = 990.6, ["Ride"] = 727.08, ["Fly|Ride"] = 741.57, ["Neon|Ride"] = 3281.25, ["Neon|Fly|Ride"] = 2231.24, ["Mega|Fly|Ride"] = 9778.13}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 206.07, ["Fly"] = 417.47, ["Ride"] = 201.71, ["Fly|Ride"] = 275.63, ["Neon"] = 1181.25, ["Neon|Ride"] = 1676.45, ["Neon|Fly|Ride"] = 1220.63, ["Mega"] = 8277.38, ["Mega|Fly|Ride"] = 5025.11}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 83.84}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 3.77}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 8.4, ["Fly"] = 28.48, ["Ride"] = 26.21, ["Fly|Ride"] = 52.5, ["Neon"] = 72.19, ["Neon|Fly"] = 230.99, ["Neon|Ride"] = 104.79, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 437.26, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 502.94}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 283.46, ["Fly"] = 1035.21, ["Ride"] = 341.25, ["Fly|Ride"] = 342.5, ["Neon"] = 1020.54, ["Neon|Ride"] = 866.24, ["Neon|Fly|Ride"] = 1023.75, ["Mega|Fly|Ride"] = 3510.29}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 22.32}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 124.73, ["Fly"] = 228.8, ["Ride"] = 186.38, ["Fly|Ride"] = 262.5, ["Neon"] = 523.69, ["Neon|Fly"] = 1676.45, ["Neon|Ride"] = 559.02, ["Neon|Fly|Ride"] = 668.22, ["Mega"] = 2520, ["Mega|Ride"] = 2235.95, ["Mega|Fly|Ride"] = 2061.15}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 123.65, ["Ride"] = 137.71, ["Fly|Ride"] = 196.88, ["Neon"] = 1117.98, ["Neon|Ride"] = 983.87, ["Neon|Fly|Ride"] = 1046.73}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 4.69, ["Ride"] = 27.2, ["Fly|Ride"] = 209.57, ["Neon"] = 32.82, ["Neon|Ride"] = 73.5, ["Neon|Fly|Ride"] = 233.5, ["Mega"] = 210, ["Mega|Ride"] = 363.59, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 11.39, ["Fly"] = 63, ["Ride"] = 31.45, ["Fly|Ride"] = 69.57, ["Neon"] = 98.98, ["Neon|Ride"] = 157.99, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 577.31}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 23.62, ["Fly"] = 102.32, ["Ride"] = 72.19, ["Fly|Ride"] = 128.82, ["Neon"] = 99.75, ["Neon|Ride"] = 134.13, ["Neon|Fly|Ride"] = 235.87, ["Mega"] = 469.42, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 1033.6}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 6.3, ["Fly"] = 116.31, ["Ride"] = 52.5, ["Fly|Ride"] = 123.38, ["Neon"] = 24.76, ["Neon|Fly"] = 93.18, ["Neon|Ride"] = 55.1, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 118.13, ["Mega|Fly"] = 162.94, ["Mega|Ride"] = 175.88, ["Mega|Fly|Ride"] = 275.62}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 262.48, ["Fly"] = 918.75, ["Ride"] = 324.6, ["Fly|Ride"] = 334.69, ["Neon"] = 1537.09, ["Neon|Ride"] = 1214.07, ["Neon|Fly|Ride"] = 1376.42}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 107.62, ["Fly"] = 1050, ["Ride"] = 172.85, ["Fly|Ride"] = 261.19, ["Neon"] = 460.69, ["Neon|Ride"] = 556.38, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 9429.92, ["Mega|Ride"] = 1990.61, ["Mega|Fly|Ride"] = 1769.25}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 72.18, ["Fly"] = 167.45, ["Ride"] = 88.24, ["Fly|Ride"] = 128.63, ["Neon"] = 360.94, ["Neon|Ride"] = 389.18, ["Neon|Fly|Ride"] = 471.72, ["Mega|Fly|Ride"] = 1886.83}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 23.97, ["Fly"] = 52.5, ["Ride"] = 57.75, ["Fly|Ride"] = 251.48, ["Neon|Ride"] = 599.07, ["Neon|Fly|Ride"] = 486.19, ["Mega|Fly|Ride"] = 1662.83}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 19.68, ["Fly"] = 75.62, ["Ride"] = 38.57, ["Fly|Ride"] = 187.52, ["Neon"] = 68.98, ["Neon|Fly"] = 195.96, ["Neon|Ride"] = 140.42, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 698.24, ["Mega|Fly"] = 525, ["Mega|Ride"] = 496.65, ["Mega|Fly|Ride"] = 443.63}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.94, ["Fly"] = 45.83, ["Ride"] = 24.75, ["Fly|Ride"] = 59.07, ["Neon"] = 15.74, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 39.81, ["Neon|Fly|Ride"] = 108.07, ["Mega"] = 110.87, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 907.33, ["Fly"] = 1084.32, ["Ride"] = 956.13, ["Fly|Ride"] = 1004.07, ["Neon"] = 3007.12, ["Neon|Ride"] = 2598.75, ["Neon|Fly|Ride"] = 2480.63, ["Mega|Fly|Ride"] = 10463.02}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 410.97, ["Ride"] = 393.75, ["Fly|Ride"] = 485.62, ["Neon"] = 1792.49, ["Neon|Ride"] = 1680, ["Neon|Fly|Ride"] = 2086.88, ["Mega"] = 10477.68, ["Mega|Fly|Ride"] = 6412.35}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 65.63, ["Fly"] = 140.42, ["Ride"] = 108.5, ["Fly|Ride"] = 158.04, ["Neon"] = 765.19, ["Neon|Ride"] = 305.82, ["Neon|Fly|Ride"] = 349.8, ["Mega|Ride"] = 1444.89, ["Mega|Fly|Ride"] = 1475.28}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 261.19, ["Ride"] = 296.87, ["Fly|Ride"] = 315, ["Neon|Ride"] = 1415.13, ["Neon|Fly|Ride"] = 1117.98, ["Mega"] = 10477.68, ["Mega|Fly|Ride"] = 4199.99}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 22.41, ["Fly"] = 140.42, ["Ride"] = 28.88, ["Fly|Ride"] = 66.36, ["Neon"] = 138.32, ["Neon|Ride"] = 126.19, ["Neon|Fly|Ride"] = 158.5, ["Mega|Ride"] = 665.34, ["Mega|Fly|Ride"] = 618.87}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 216.12, ["Ride"] = 280.74, ["Fly|Ride"] = 471.72, ["Neon"] = 1419.05, ["Neon|Ride"] = 1730, ["Neon|Fly|Ride"] = 1226.45, ["Mega"] = 4170.42, ["Mega|Fly|Ride"] = 4213.08}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 57.17, ["Fly"] = 126, ["Ride"] = 65.63, ["Fly|Ride"] = 105, ["Neon|Ride"] = 500.84, ["Neon|Fly|Ride"] = 559.53, ["Mega|Fly|Ride"] = 1397.82}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1640.63, ["Ride"] = 1404.57, ["Fly|Ride"] = 1377.72, ["Neon|Fly|Ride"] = 4610.2, ["Mega"] = 50292.83, ["Mega|Fly|Ride"] = 24308.22}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 10.4, ["Fly"] = 79.03, ["Ride"] = 38.18, ["Fly|Ride"] = 92.21, ["Neon"] = 61.53, ["Neon|Fly"] = 91.18, ["Neon|Ride"] = 77.09, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 262.46, ["Mega|Ride"] = 261.19, ["Mega|Fly|Ride"] = 392.43}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 49.12, ["Fly"] = 78.75, ["Ride"] = 59.06, ["Fly|Ride"] = 159.48, ["Neon"] = 237.83, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 543.81, ["Mega|Ride"] = 1084.94, ["Mega|Fly|Ride"] = 1458.19}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 76.13, ["Fly"] = 91.88, ["Ride"] = 62.96, ["Fly|Ride"] = 65.6, ["Neon|Ride"] = 410.82, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1363.58}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3771.97, ["Ride"] = 1181.25, ["Fly|Ride"] = 1113, ["Neon|Fly|Ride"] = 3281.25, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 469.25, ["Fly"] = 836.13, ["Ride"] = 586.77, ["Fly|Ride"] = 698.87, ["Neon|Fly|Ride"] = 2752.41, ["Mega|Fly|Ride"] = 14151.14}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 104.98, ["Fly"] = 314.88, ["Ride"] = 140.42, ["Fly|Ride"] = 211.98, ["Neon"] = 445.6, ["Neon|Fly"] = 559.53, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 545.54, ["Mega"] = 4190.03, ["Mega|Ride"] = 2647.72, ["Mega|Fly|Ride"] = 2202.87}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 8.81, ["Fly"] = 39.37, ["Ride"] = 23.55, ["Fly|Ride"] = 69.17, ["Neon"] = 76.32, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 656.25, ["Mega|Ride"] = 740.06, ["Mega|Fly|Ride"] = 1035.21}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 39.37, ["Fly"] = 83.84, ["Ride"] = 47.12, ["Fly|Ride"] = 103.8, ["Neon"] = 204.75, ["Neon|Fly"] = 418.07, ["Neon|Ride"] = 209.57, ["Neon|Fly|Ride"] = 276.63, ["Mega"] = 1816.84, ["Mega|Ride"] = 1069.6, ["Mega|Fly|Ride"] = 879.38}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 759.42, ["Ride"] = 874.13, ["Fly|Ride"] = 826.88, ["Neon|Ride"] = 2828.44, ["Neon|Fly|Ride"] = 2991.19, ["Mega|Fly|Ride"] = 15716.52}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 721.88}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4921.88, ["Ride"] = 5447.35, ["Fly|Ride"] = 3845.63, ["Neon"] = 42000, ["Neon|Ride"] = 30030.07, ["Neon|Fly|Ride"] = 21927.94, ["Mega|Fly|Ride"] = 89410.17}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 162.51, ["Fly"] = 276.17, ["Ride"] = 272.44, ["Neon"] = 1297.21, ["Neon|Ride"] = 1258.28, ["Neon|Fly|Ride"] = 1397.74, ["Mega"] = 5866.47, ["Mega|Fly|Ride"] = 6007.92}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 81.38, ["Fly"] = 279.78, ["Ride"] = 78.74, ["Fly|Ride"] = 336, ["Neon"] = 345.63, ["Neon|Ride"] = 483.12, ["Neon|Fly|Ride"] = 978.63, ["Mega|Fly|Ride"] = 2099.99}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 12.59, ["Fly"] = 131.24, ["Ride"] = 26.25, ["Fly|Ride"] = 104.99, ["Neon"] = 274.32, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 698.87, ["Mega|Ride"] = 628.67, ["Mega|Fly|Ride"] = 586.77}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 18.73, ["Fly"] = 31.82, ["Ride"] = 30.19, ["Fly|Ride"] = 39.38, ["Neon|Fly"] = 279.78, ["Neon|Ride"] = 279.78, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2221.28}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 19.69, ["Fly"] = 131.25, ["Ride"] = 42, ["Fly|Ride"] = 110.23, ["Neon"] = 154.88, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 137.71, ["Mega"] = 549.94, ["Mega|Ride"] = 859.69, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 5.25, ["Fly"] = 56.59, ["Ride"] = 20.97, ["Fly|Ride"] = 39.38, ["Neon"] = 40.88, ["Neon|Fly"] = 345.78, ["Neon|Ride"] = 40.42, ["Neon|Fly|Ride"] = 126.86, ["Mega"] = 176.72, ["Mega|Ride"] = 194.9, ["Mega|Fly|Ride"] = 314.34}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 31.44, ["Ride"] = 51.91, ["Fly|Ride"] = 183.74, ["Neon"] = 163.47, ["Neon|Fly"] = 838.23, ["Neon|Ride"] = 141.52, ["Neon|Fly|Ride"] = 245.93, ["Mega"] = 691.55, ["Mega|Ride"] = 739.41}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 307.79, ["Fly"] = 365.59, ["Ride"] = 296.62, ["Fly|Ride"] = 353.9, ["Neon"] = 978.63, ["Neon|Ride"] = 973.25, ["Neon|Fly|Ride"] = 892.71, ["Mega"] = 6562.5, ["Mega|Ride"] = 3632.63, ["Mega|Fly|Ride"] = 3281.25}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.52, ["Fly"] = 22.97, ["Ride"] = 16.78, ["Fly|Ride"] = 36.68, ["Neon"] = 18.24, ["Neon|Ride"] = 30.89, ["Neon|Fly|Ride"] = 70.34, ["Mega"] = 836.13, ["Mega|Ride"] = 220.54, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 35.59, ["Fly"] = 91.88, ["Ride"] = 65.59, ["Fly|Ride"] = 129.92, ["Neon"] = 161.44, ["Neon|Fly"] = 393.88, ["Neon|Ride"] = 180.65, ["Neon|Fly|Ride"] = 249.42, ["Mega"] = 614.15, ["Mega|Fly"] = 838.23, ["Mega|Ride"] = 486.63, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 721.84, ["Fly"] = 907.38, ["Ride"] = 712.69, ["Fly|Ride"] = 712.59, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1567.1, ["Mega|Fly|Ride"] = 5106.83}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 26.44, ["Fly"] = 91.88, ["Ride"] = 44.1, ["Fly|Ride"] = 65.63, ["Neon"] = 195.96, ["Neon|Fly"] = 471.72, ["Neon|Ride"] = 177.18, ["Neon|Fly|Ride"] = 209.57, ["Mega"] = 1575, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 741.4}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 308.7, ["Fly"] = 261.19, ["Ride"] = 260.98, ["Fly|Ride"] = 339.12, ["Neon"] = 943.01, ["Neon|Ride"] = 1256.29, ["Neon|Fly|Ride"] = 1021.12, ["Mega"] = 5975.32, ["Mega|Fly|Ride"] = 6217.46}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 131.24, ["Fly"] = 139.02, ["Ride"] = 129.94, ["Fly|Ride"] = 167.56, ["Neon|Ride"] = 559.53, ["Neon|Fly|Ride"] = 562.41, ["Mega|Fly|Ride"] = 2358.23}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 656.25, ["Ride"] = 590.63, ["Fly|Ride"] = 669.38, ["Neon|Ride"] = 2572.5, ["Neon|Fly|Ride"] = 2240.61, ["Mega|Fly|Ride"] = 7611.19}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 21.4, ["Ride"] = 52.4, ["Neon"] = 86.99, ["Neon|Fly"] = 283.03, ["Neon|Ride"] = 103.74, ["Neon|Fly|Ride"] = 188.69, ["Mega"] = 262.48, ["Mega|Ride"] = 376.17, ["Mega|Fly|Ride"] = 375.02}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4002.43, ["Fly"] = 3335.35, ["Ride"] = 3891.58, ["Fly|Ride"] = 2858.63, ["Neon|Fly|Ride"] = 6562.5, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 98.51, ["Fly"] = 123.65, ["Ride"] = 65.62, ["Fly|Ride"] = 162.75, ["Neon"] = 419.12, ["Neon|Ride"] = 459.93, ["Neon|Fly|Ride"] = 477.69, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 3.92, ["Fly"] = 19.92, ["Ride"] = 20.9, ["Fly|Ride"] = 83.84, ["Neon"] = 26.25, ["Neon|Fly"] = 82.88, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 112.12, ["Mega"] = 139.12, ["Mega|Fly"] = 452.82, ["Mega|Ride"] = 233.89, ["Mega|Fly|Ride"] = 235.91}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.94, ["Ride"] = 23.63, ["Neon"] = 19.69, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 266.43, ["Mega"] = 161.43, ["Mega|Ride"] = 199.48, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 54.26, ["Fly"] = 82.86, ["Ride"] = 54.5, ["Fly|Ride"] = 59.07, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 263, ["Mega|Fly|Ride"] = 1029}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 939.75, ["Ride"] = 1173.38, ["Fly|Ride"] = 1295.43, ["Neon"] = 5720.81}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 5184.37, ["Ride"] = 5896.32, ["Fly|Ride"] = 4856.25}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 22.84, ["Fly"] = 31.45, ["Ride"] = 23.63, ["Fly|Ride"] = 56.44, ["Neon"] = 261.86, ["Neon|Ride"] = 155.09, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 2428.13, ["Mega|Fly|Ride"] = 607.65}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 17.07, ["Fly"] = 51.14, ["Ride"] = 32.82, ["Fly|Ride"] = 102.69, ["Neon"] = 88.83, ["Neon|Ride"] = 89.43, ["Neon|Fly|Ride"] = 140.4, ["Mega"] = 933.52, ["Mega|Ride"] = 564.87, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 55.1, ["Fly"] = 157.5, ["Ride"] = 56.06, ["Fly|Ride"] = 72.01, ["Neon"] = 328.12, ["Neon|Ride"] = 279.78, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 1127.42, ["Mega|Ride"] = 1150.47, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 232.31, ["Fly"] = 314.88, ["Ride"] = 216.57, ["Fly|Ride"] = 263.39, ["Neon|Fly"] = 923.09, ["Neon|Ride"] = 976.5, ["Neon|Fly|Ride"] = 853.72, ["Mega"] = 10477.68, ["Mega|Fly|Ride"] = 3365.62}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.94, ["Ride"] = 32.47, ["Fly|Ride"] = 86.63, ["Neon"] = 27.57, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 83.84, ["Neon|Fly|Ride"] = 245.31, ["Mega"] = 131.24, ["Mega|Ride"] = 279.46, ["Mega|Fly|Ride"] = 417.03}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 188.98, ["Fly"] = 255.64, ["Ride"] = 196.88, ["Fly|Ride"] = 236.25, ["Neon"] = 721.72, ["Neon|Ride"] = 943.43, ["Neon|Fly|Ride"] = 928.09, ["Mega|Fly|Ride"] = 3717.49}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.55, ["Fly"] = 20.63, ["Ride"] = 17.7, ["Fly|Ride"] = 41.92, ["Neon"] = 19.45, ["Neon|Fly"] = 123.03, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 82.68, ["Mega"] = 275.96, ["Mega|Ride"] = 177.18, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 225.75, ["Fly"] = 268.82, ["Ride"] = 253.32, ["Fly|Ride"] = 251.48, ["Neon|Ride"] = 1297.21, ["Neon|Fly|Ride"] = 884.45, ["Mega"] = 10476.64, ["Mega|Ride"] = 4191.09, ["Mega|Fly|Ride"] = 3913.42}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 12.16, ["Fly"] = 45.94, ["Ride"] = 27.08, ["Fly|Ride"] = 56.27, ["Neon"] = 91.18, ["Neon|Fly"] = 299.54, ["Neon|Ride"] = 99.56, ["Neon|Fly|Ride"] = 272.36, ["Mega"] = 522.41, ["Mega|Ride"] = 559.53, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.43, ["Ride"] = 22.23, ["Fly|Ride"] = 49.88, ["Neon"] = 9.5, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 59.93, ["Neon|Fly|Ride"] = 135.47, ["Mega"] = 83.06, ["Mega|Ride"] = 108.94, ["Mega|Fly|Ride"] = 262.4}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 4.39, ["Neon|Ride"] = 70.22, ["Mega"] = 15.73, ["Mega|Ride"] = 139.17}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.39, ["Ride"] = 28.88, ["Fly|Ride"] = 139.63, ["Neon"] = 19.58, ["Neon|Ride"] = 56.59, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 251.48, ["Mega|Fly"] = 157235.49, ["Mega|Ride"] = 95.81}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 50.86, ["Fly"] = 136.83, ["Ride"] = 105, ["Fly|Ride"] = 131.25, ["Neon"] = 266.14, ["Neon|Fly"] = 405.06, ["Neon|Ride"] = 261.09, ["Neon|Fly|Ride"] = 348.26, ["Mega|Fly|Ride"] = 1256.56}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 33.71, ["Ride"] = 15.89, ["Neon"] = 15.1, ["Neon|Ride"] = 31.27, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 104.25, ["Mega|Ride"] = 98.51, ["Mega|Fly|Ride"] = 209.57}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 12.11, ["Ride"] = 111.2, ["Fly|Ride"] = 194.9, ["Neon"] = 74.82, ["Neon|Ride"] = 111.57, ["Mega"] = 328.13, ["Mega|Ride"] = 622.29}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.59, ["Neon|Ride"] = 32.82, ["Mega"] = 18.85, ["Mega|Ride"] = 50.3, ["Mega|Fly|Ride"] = 157.4}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.73, ["Fly|Ride"] = 26.17, ["Neon"] = 2.1, ["Neon|Fly"] = 35.39, ["Neon|Ride"] = 15.73, ["Neon|Fly|Ride"] = 32.33, ["Mega"] = 15.75, ["Mega|Fly"] = 30.19, ["Mega|Ride"] = 18.87, ["Mega|Fly|Ride"] = 57.94}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 15.64, ["Fly|Ride"] = 26.17, ["Neon"] = 2.63, ["Neon|Fly"] = 12.83, ["Neon|Ride"] = 13.55, ["Neon|Fly|Ride"] = 46.17, ["Mega"] = 16.53, ["Mega|Fly"] = 63.7, ["Mega|Ride"] = 58.69, ["Mega|Fly|Ride"] = 94.48}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 31.5, ["Neon"] = 2.63, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 58.98, ["Mega"] = 18.37, ["Mega|Ride"] = 147, ["Mega|Fly|Ride"] = 559.13}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 17.07, ["Fly|Ride"] = 107.62, ["Neon"] = 3.45, ["Neon|Fly"] = 135.08, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 64.12, ["Mega"] = 37.73, ["Mega|Fly"] = 83.84, ["Mega|Ride"] = 53.48, ["Mega|Fly|Ride"] = 96.41}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 23.63, ["Mega|Fly"] = 100.61, ["Mega|Ride"] = 90.83}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 3.05, ["Fly"] = 53.38, ["Ride"] = 17.06, ["Fly|Ride"] = 47.42, ["Neon"] = 6.57, ["Neon|Fly"] = 51.26, ["Neon|Ride"] = 23.49, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 57.64, ["Mega|Fly"] = 70.22, ["Mega|Ride"] = 75.02, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 43.29, ["Neon"] = 2.1, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 157.37, ["Mega"] = 18.34, ["Mega|Fly"] = 98.44, ["Mega|Ride"] = 63.7, ["Mega|Fly|Ride"] = 127.32}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly|Ride"] = 524.99, ["Neon"] = 17.7, ["Mega"] = 209.57, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 279.78}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 13.37, ["Mega"] = 103.69, ["Mega|Fly|Ride"] = 377.21}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 5.16, ["Neon|Ride"] = 37.73, ["Neon|Fly|Ride"] = 98.51, ["Mega"] = 30.19, ["Mega|Ride"] = 59.73, ["Mega|Fly|Ride"] = 131.14}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.73, ["Fly|Ride"] = 30.14, ["Neon"] = 2.1, ["Neon|Fly"] = 27.26, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 34.13, ["Mega"] = 18.38, ["Mega|Fly"] = 39.2, ["Mega|Ride"] = 27.91, ["Mega|Fly|Ride"] = 61.63}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 26.25, ["Fly|Ride"] = 104.98, ["Neon"] = 32.82, ["Neon|Ride"] = 39.82, ["Mega"] = 251.48, ["Mega|Ride"] = 274.44}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 17.93, ["Fly|Ride"] = 78.73, ["Neon"] = 4.54, ["Neon|Ride"] = 36.46, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 34.12, ["Mega|Ride"] = 91.77, ["Mega|Fly|Ride"] = 124.37}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 3.84, ["Neon"] = 8.97, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 45.94, ["Mega|Ride"] = 118.13}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.59, ["Fly"] = 131.25, ["Ride"] = 32.81, ["Fly|Ride"] = 34.13, ["Neon"] = 12.5, ["Neon|Ride"] = 70.22, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 103.84, ["Mega|Ride"] = 85.31, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 15.73, ["Ride"] = 12.59, ["Fly|Ride"] = 19.9, ["Neon"] = 2.1, ["Neon|Fly"] = 12.71, ["Neon|Ride"] = 14.05, ["Neon|Fly|Ride"] = 31.39, ["Mega"] = 17.07, ["Mega|Fly"] = 31.45, ["Mega|Ride"] = 23.06, ["Mega|Fly|Ride"] = 68.41}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 23.96, ["Ride"] = 18.86, ["Fly|Ride"] = 80.2, ["Neon"] = 15.65, ["Neon|Ride"] = 113.23, ["Neon|Fly|Ride"] = 83.84, ["Mega"] = 78.75, ["Mega|Ride"] = 152.6, ["Mega|Fly|Ride"] = 196.77}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.1, ["Fly"] = 41.91, ["Ride"] = 24.11, ["Fly|Ride"] = 140.51, ["Neon"] = 23.61, ["Neon|Ride"] = 112.12, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 235.77, ["Mega|Ride"] = 278.07, ["Mega|Fly|Ride"] = 387.85}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 15.1, ["Ride"] = 12.99, ["Fly|Ride"] = 26.17, ["Neon"] = 2.5, ["Neon|Fly"] = 16.47, ["Neon|Ride"] = 15.73, ["Neon|Fly|Ride"] = 44.02, ["Mega"] = 28.3, ["Mega|Fly"] = 156.19, ["Mega|Ride"] = 70.22, ["Mega|Fly|Ride"] = 92.29}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 3.84, ["Fly"] = 174.99, ["Ride"] = 51.81, ["Neon"] = 6.57, ["Neon|Fly"] = 77.49, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 125.74, ["Mega|Fly"] = 167.66, ["Mega|Ride"] = 83.84}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 24.45, ["Neon"] = 7.88, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 156.13, ["Neon|Fly|Ride"] = 137.71, ["Mega"] = 32.82, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 44.02, ["Ride"] = 16.73, ["Neon"] = 2.1, ["Neon|Fly"] = 41.92, ["Neon|Ride"] = 20.87, ["Neon|Fly|Ride"] = 83.74, ["Mega"] = 17.07, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 125.51}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 98.51, ["Ride"] = 16.94, ["Fly|Ride"] = 47.19, ["Neon"] = 11.81, ["Neon|Fly"] = 45.59, ["Neon|Ride"] = 23.61, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 68.07, ["Mega|Ride"] = 138.32, ["Mega|Fly|Ride"] = 263}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 95.45, ["Neon"] = 5.43, ["Neon|Ride"] = 42.41, ["Neon|Fly|Ride"] = 94.35, ["Mega"] = 67.08, ["Mega|Fly|Ride"] = 335.3}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 28.73, ["Ride"] = 13.1, ["Fly|Ride"] = 140.42, ["Neon"] = 4.52, ["Neon|Fly"] = 69.86, ["Neon|Ride"] = 25.09, ["Neon|Fly|Ride"] = 46.01, ["Mega"] = 81.92, ["Mega|Ride"] = 90.46, ["Mega|Fly|Ride"] = 157.39}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 3.55, ["Ride"] = 82.69, ["Neon"] = 56.59, ["Mega"] = 191.62, ["Mega|Fly|Ride"] = 837.81}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly|Ride"] = 5424.61, ["Neon"] = 12.91, ["Neon|Fly"] = 140.42, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 80.2, ["Mega"] = 157.5, ["Mega|Ride"] = 120.5, ["Mega|Fly|Ride"] = 471.72}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.14, ["Fly"] = 20.9, ["Ride"] = 29.64, ["Fly|Ride"] = 196.88, ["Neon"] = 14.2, ["Neon|Fly"] = 39.82, ["Neon|Ride"] = 38.09, ["Neon|Fly|Ride"] = 111.06, ["Mega"] = 203.52, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 85.31, ["Fly|Ride"] = 106.15, ["Neon"] = 19.69, ["Mega"] = 200.16, ["Mega|Ride"] = 406.87}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 13.13, ["Ride"] = 131.24, ["Neon"] = 112.12, ["Neon|Ride"] = 235.87, ["Mega"] = 937.77, ["Mega|Ride"] = 875.96, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 11.54, ["Ride"] = 49.26, ["Neon"] = 4.22, ["Neon|Ride"] = 52.5, ["Mega"] = 157.5, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 512.54}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 5.71, ["Ride"] = 42.84, ["Fly|Ride"] = 140.42, ["Neon"] = 69.07, ["Neon|Ride"] = 62.89, ["Neon|Fly|Ride"] = 82.57, ["Mega"] = 289.2, ["Mega|Ride"] = 255.94, ["Mega|Fly|Ride"] = 417.03}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.9, ["Neon|Ride"] = 64.98, ["Mega"] = 20.97, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 148.31}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 65.62}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 4.24, ["Fly"] = 27.2, ["Ride"] = 20.69, ["Fly|Ride"] = 65.54, ["Neon"] = 36.66, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 47.12, ["Neon|Fly|Ride"] = 96.41, ["Mega"] = 283.5, ["Mega|Fly"] = 293.4, ["Mega|Ride"] = 275.82, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.37, ["Fly|Ride"] = 65.62, ["Neon"] = 6.3, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 26.25, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 20.97, ["Fly|Ride"] = 393.65, ["Neon"] = 6.57, ["Neon|Ride"] = 36.7, ["Neon|Fly|Ride"] = 402.59, ["Mega"] = 56.51, ["Mega|Ride"] = 69.21, ["Mega|Fly|Ride"] = 83.84}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 45.93, ["Ride"] = 17.64, ["Fly|Ride"] = 55.65, ["Neon"] = 18.9, ["Neon|Ride"] = 28.6, ["Neon|Fly|Ride"] = 79.72, ["Mega"] = 140.42, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.59, ["Ride"] = 22.57, ["Neon"] = 47.16, ["Neon|Ride"] = 70.22, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 279.78, ["Mega|Ride"] = 315.73, ["Mega|Fly|Ride"] = 418.07}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 3.92, ["Neon|Ride"] = 49.26, ["Neon|Fly|Ride"] = 79.03, ["Mega"] = 32.71, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 53.45, ["Mega|Fly|Ride"] = 140.42}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 16.78, ["Ride"] = 16.96, ["Fly|Ride"] = 279404.92, ["Neon"] = 4.99, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 20.97, ["Neon|Fly|Ride"] = 69.45, ["Mega"] = 42.47, ["Mega|Fly"] = 200.49, ["Mega|Ride"] = 52.49}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 16, ["Ride"] = 16.94, ["Fly|Ride"] = 32.66, ["Neon"] = 7.65, ["Neon|Fly"] = 70.22, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 81.38, ["Mega"] = 60.06, ["Mega|Ride"] = 51.32, ["Mega|Fly|Ride"] = 139.12}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 35.27, ["Fly|Ride"] = 77.84, ["Neon"] = 3.94, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 106.89, ["Mega"] = 19.69, ["Mega|Fly"] = 104.79, ["Mega|Ride"] = 38.66, ["Mega|Fly|Ride"] = 129.92}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Neon|Ride"] = 162.75, ["Neon|Fly|Ride"] = 138.32, ["Mega"] = 23.57, ["Mega|Fly"] = 104.99, ["Mega|Ride"] = 86.63, ["Mega|Fly|Ride"] = 195.96}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 27.09, ["Ride"] = 18.87, ["Fly|Ride"] = 77.44, ["Neon"] = 5.25, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 62.89, ["Mega"] = 28.25, ["Mega|Ride"] = 61.83, ["Mega|Fly|Ride"] = 131.15}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 49.25, ["Neon"] = 2.1, ["Neon|Ride"] = 59.07, ["Mega"] = 18.27, ["Mega|Ride"] = 126.18, ["Mega|Fly|Ride"] = 205.42}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 5.92, ["Neon|Ride"] = 158.04, ["Mega"] = 31.85, ["Mega|Fly"] = 117.95, ["Mega|Ride"] = 120.5, ["Mega|Fly|Ride"] = 349.97}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 28.3, ["Ride"] = 25.39, ["Fly|Ride"] = 69.57, ["Neon"] = 6.46, ["Neon|Ride"] = 20.55, ["Neon|Fly|Ride"] = 124.64, ["Mega"] = 140.42, ["Mega|Fly|Ride"] = 127.85}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 14.97, ["Ride"] = 91.88, ["Neon"] = 119.45, ["Neon|Ride"] = 235.87, ["Mega"] = 421.6, ["Mega|Ride"] = 511.32, ["Mega|Fly|Ride"] = 622.39}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 5.24, ["Fly"] = 6562.5, ["Ride"] = 68.24, ["Neon"] = 41.2, ["Neon|Ride"] = 207.47, ["Mega"] = 208.52, ["Mega|Ride"] = 344.54}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 3.87, ["Ride"] = 26.24, ["Fly|Ride"] = 419.12, ["Neon"] = 18.01, ["Mega"] = 274.32, ["Mega|Ride"] = 178.14, ["Mega|Fly|Ride"] = 324.75}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 17.7, ["Ride"] = 13.12, ["Fly|Ride"] = 39.83, ["Neon"] = 2.1, ["Neon|Fly"] = 17.64, ["Neon|Ride"] = 11.82, ["Neon|Fly|Ride"] = 27.99, ["Mega"] = 18.87, ["Mega|Fly"] = 27.26, ["Mega|Ride"] = 19.69, ["Mega|Fly|Ride"] = 39.37}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 4.22, ["Fly"] = 118.12, ["Ride"] = 55.12, ["Fly|Ride"] = 70.22, ["Neon"] = 10.39, ["Neon|Fly"] = 83.84, ["Neon|Ride"] = 28.3, ["Neon|Fly|Ride"] = 698.87, ["Mega"] = 70.22, ["Mega|Ride"] = 112.12, ["Mega|Fly|Ride"] = 119.45}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 25.03, ["Neon|Ride"] = 17.93, ["Neon|Fly|Ride"] = 78.54, ["Mega"] = 15.75, ["Mega|Fly"] = 56.59, ["Mega|Ride"] = 52.14, ["Mega|Fly|Ride"] = 99.39}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.82, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 91.88, ["Mega"] = 17.28, ["Mega|Ride"] = 106.88, ["Mega|Fly|Ride"] = 150.93}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 20.75, ["Ride"] = 15.75, ["Fly|Ride"] = 54.5, ["Neon"] = 15.71, ["Neon|Fly"] = 140.42, ["Neon|Ride"] = 30.15, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 137.01, ["Mega|Ride"] = 189.95, ["Mega|Fly|Ride"] = 323.13}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 199.1, ["Ride"] = 163.38, ["Fly|Ride"] = 262.5, ["Neon|Fly|Ride"] = 978.63, ["Mega"] = 8382.14, ["Mega|Fly|Ride"] = 3339.26}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 6.19, ["Neon|Fly"] = 56.59, ["Neon|Ride"] = 68.25, ["Mega"] = 87.93, ["Mega|Ride"] = 195.96, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 94.49, ["Fly"] = 103.68, ["Ride"] = 24.11, ["Fly|Ride"] = 140.42, ["Neon"] = 59.07, ["Neon|Ride"] = 164.29, ["Neon|Fly|Ride"] = 158.23, ["Mega"] = 419.12, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 1047.78}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 12.01, ["Ride"] = 16.7, ["Fly|Ride"] = 36.66, ["Neon"] = 5.25, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 57.75, ["Mega|Fly"] = 94.35, ["Mega|Ride"] = 59.73, ["Mega|Fly|Ride"] = 140.35}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 28.3, ["Ride"] = 17.06, ["Fly|Ride"] = 120.89, ["Neon"] = 20.9, ["Neon|Ride"] = 103.18, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 95.7, ["Mega|Ride"] = 136.5}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.59, ["Fly"] = 26.24, ["Ride"] = 17.07, ["Fly|Ride"] = 35.44, ["Neon"] = 32.45, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 91.88, ["Mega|Ride"] = 278.73, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.67, ["Fly"] = 27.76, ["Ride"] = 41.91, ["Fly|Ride"] = 249.58, ["Neon"] = 44.54, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 622.39, ["Mega"] = 327.48, ["Mega|Ride"] = 352.07, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.63, ["Fly"] = 17.07, ["Ride"] = 17.01, ["Fly|Ride"] = 38.85, ["Neon"] = 43.77, ["Neon|Fly"] = 56.59, ["Neon|Ride"] = 27.26, ["Neon|Fly|Ride"] = 54.71, ["Mega"] = 133.07, ["Mega|Fly"] = 243.1, ["Mega|Ride"] = 698.87, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 54.42, ["Fly"] = 120.5, ["Ride"] = 81.92, ["Fly|Ride"] = 131.21, ["Neon"] = 328.13, ["Neon|Fly"] = 406.88, ["Neon|Ride"] = 387.18, ["Neon|Fly|Ride"] = 479.07, ["Mega|Fly|Ride"] = 1644.57}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 216.57, ["Fly"] = 322.18, ["Ride"] = 233.76, ["Fly|Ride"] = 279.78, ["Neon"] = 908.04, ["Neon|Ride"] = 1466.9, ["Neon|Fly|Ride"] = 1397.45, ["Mega"] = 10477.68, ["Mega|Fly|Ride"] = 10220.66}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 78.74, ["Fly"] = 140.42, ["Ride"] = 77.43, ["Fly|Ride"] = 155.09, ["Neon"] = 379.25, ["Neon|Ride"] = 277.56, ["Neon|Fly|Ride"] = 314.88, ["Mega|Ride"] = 1397.74, ["Mega|Fly|Ride"] = 1246.87}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 4.3, ["Fly"] = 83.84, ["Ride"] = 30.35, ["Neon"] = 27.11, ["Neon|Ride"] = 52.11, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 188.67, ["Mega|Ride"] = 193.6, ["Mega|Fly|Ride"] = 390.48}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 12.66, ["Fly"] = 68.16, ["Ride"] = 35.44, ["Fly|Ride"] = 70.22, ["Neon"] = 120.84, ["Neon|Ride"] = 97.08, ["Mega"] = 351.75, ["Mega|Ride"] = 451.5, ["Mega|Fly|Ride"] = 551.14}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 18.06, ["Ride"] = 20.97, ["Fly|Ride"] = 56.44, ["Neon"] = 4.6, ["Neon|Fly"] = 22.29, ["Neon|Ride"] = 20.73, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 49.58, ["Mega|Fly"] = 209.92, ["Mega|Ride"] = 111.05, ["Mega|Fly|Ride"] = 129.93}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 7.88, ["Fly"] = 72.1, ["Ride"] = 20.14, ["Fly|Ride"] = 139.83, ["Neon"] = 43.03, ["Neon|Ride"] = 157.95, ["Neon|Fly|Ride"] = 134.93, ["Mega"] = 796.32, ["Mega|Ride"] = 628.67, ["Mega|Fly|Ride"] = 864.94}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 30.53, ["Ride"] = 18.36, ["Fly|Ride"] = 51.91, ["Neon"] = 15.67, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 41.92, ["Neon|Fly|Ride"] = 92.68, ["Mega"] = 131.25, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 179.82}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 3.28, ["Ride"] = 26.25, ["Fly|Ride"] = 328.13, ["Neon"] = 41.92, ["Neon|Ride"] = 55.44, ["Neon|Fly|Ride"] = 235.87, ["Mega"] = 207.37, ["Mega|Ride"] = 208.52, ["Mega|Fly|Ride"] = 337.84}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 131.24, ["Neon"] = 2.1, ["Neon|Ride"] = 18.47, ["Neon|Fly|Ride"] = 47.38, ["Mega"] = 17.7, ["Mega|Ride"] = 26.25, ["Mega|Fly|Ride"] = 223.01}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 20.91, ["Fly|Ride"] = 48.21, ["Neon"] = 11.71, ["Neon|Fly"] = 104.79, ["Neon|Ride"] = 24.11, ["Neon|Fly|Ride"] = 63.8, ["Mega"] = 108.94, ["Mega|Ride"] = 98.51, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.63, ["Fly"] = 24.92, ["Ride"] = 18.26, ["Fly|Ride"] = 45.75, ["Neon"] = 63.7, ["Neon|Fly"] = 140.42, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 283.5, ["Mega|Ride"] = 140.42, ["Mega|Fly|Ride"] = 233.67}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 170.49, ["Fly"] = 224.24, ["Ride"] = 217.53, ["Fly|Ride"] = 280.87, ["Neon"] = 700.87, ["Neon|Ride"] = 718.78, ["Neon|Fly|Ride"] = 656.25, ["Mega|Ride"] = 3478.13, ["Mega|Fly|Ride"] = 2623.69}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 8.8, ["Ride"] = 240.91, ["Fly|Ride"] = 204.33, ["Neon"] = 34.34, ["Neon|Ride"] = 104.79, ["Neon|Fly|Ride"] = 156.19, ["Mega"] = 307.47, ["Mega|Ride"] = 371.48, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Ride"] = 16.59, ["Fly|Ride"] = 40.11, ["Neon"] = 20.26, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 64.97, ["Mega"] = 173.19, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 35.63, ["Ride"] = 36.22, ["Fly|Ride"] = 178.5, ["Neon"] = 103.1, ["Neon|Ride"] = 119.75, ["Neon|Fly|Ride"] = 294.54, ["Mega"] = 504.3, ["Mega|Ride"] = 469.88, ["Mega|Fly|Ride"] = 559.53}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 3.89}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 3.87, ["Ride"] = 30.09, ["Neon"] = 28.24, ["Neon|Ride"] = 151.52, ["Neon|Fly|Ride"] = 628.67, ["Mega"] = 236.25, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 98.51}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 22.26, ["Fly"] = 39.38, ["Ride"] = 27.57, ["Fly|Ride"] = 39.38, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 198.98, ["Neon|Fly|Ride"] = 126.41, ["Mega"] = 523.89, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Fly|Ride"] = 78.75, ["Neon"] = 3.94, ["Neon|Ride"] = 53.17, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 26.25, ["Mega|Fly"] = 413.88, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 140.18}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 8.4, ["Fly"] = 26.88, ["Ride"] = 28.3, ["Fly|Ride"] = 62.26, ["Neon"] = 83.84, ["Neon|Ride"] = 235.87, ["Mega"] = 221.17, ["Mega|Fly"] = 393.88, ["Mega|Ride"] = 147, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 45.07, ["Ride"] = 16.72, ["Fly|Ride"] = 41.92, ["Neon"] = 14.21, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 124.69, ["Mega|Ride"] = 140.4, ["Mega|Fly|Ride"] = 224.88}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 22.99, ["Neon"] = 3.85, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 31.42, ["Neon|Fly|Ride"] = 158.04, ["Mega"] = 31.45, ["Mega|Ride"] = 70.22, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 25.97, ["Ride"] = 64.31, ["Fly|Ride"] = 167.66, ["Neon"] = 170.63, ["Neon|Fly|Ride"] = 581.63, ["Mega"] = 919.95, ["Mega|Ride"] = 951.39, ["Mega|Fly|Ride"] = 850.29}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.27, ["Ride"] = 26.25, ["Neon"] = 80.07, ["Neon|Ride"] = 75.46, ["Neon|Fly|Ride"] = 209.57, ["Mega"] = 278.73, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 12.58, ["Fly"] = 139.53, ["Ride"] = 38.06, ["Fly|Ride"] = 140.42, ["Neon"] = 62.99, ["Neon|Fly"] = 314.99, ["Neon|Ride"] = 102.69, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 559.53, ["Mega|Fly|Ride"] = 978.63}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 54.39, ["Fly"] = 98.51, ["Ride"] = 103.69, ["Fly|Ride"] = 262.44, ["Neon"] = 279.78, ["Neon|Ride"] = 349.93, ["Mega|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 1311.19}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 11.16, ["Fly"] = 39.38, ["Ride"] = 27.02, ["Fly|Ride"] = 55.59, ["Neon"] = 62.99, ["Neon|Fly"] = 79.03, ["Neon|Ride"] = 68.6, ["Neon|Fly|Ride"] = 125.74, ["Mega"] = 231.77, ["Mega|Ride"] = 299.54, ["Mega|Fly|Ride"] = 504.74}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 80.56, ["Fly"] = 145.69, ["Ride"] = 109.59, ["Fly|Ride"] = 212.27, ["Neon"] = 203.43, ["Neon|Ride"] = 268.8, ["Neon|Fly|Ride"] = 315, ["Mega"] = 2043.68, ["Mega|Fly"] = 1022.43, ["Mega|Ride"] = 975.49, ["Mega|Fly|Ride"] = 812.44}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 34.13, ["Ride"] = 59.07, ["Fly|Ride"] = 173.25, ["Neon"] = 86.62, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 838.23, ["Mega"] = 405.5, ["Mega|Ride"] = 304.5, ["Mega|Fly|Ride"] = 450.19}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 8.3, ["Fly"] = 69.51, ["Ride"] = 19.69, ["Fly|Ride"] = 56.59, ["Neon"] = 82.47, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 125.74, ["Mega"] = 625.19, ["Mega|Ride"] = 1047.78, ["Mega|Fly|Ride"] = 400.96}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 24.94, ["Ride"] = 94.35, ["Fly|Ride"] = 105.81, ["Neon"] = 78.74, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 267.46, ["Mega"] = 473.6, ["Mega|Ride"] = 346.5, ["Mega|Fly|Ride"] = 475.13}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 9.94, ["Ride"] = 34.13, ["Fly|Ride"] = 135.61, ["Neon"] = 42.35, ["Neon|Ride"] = 89.25, ["Neon|Fly|Ride"] = 125.73, ["Mega"] = 310.15, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 483}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Fly"] = 41.92, ["Neon|Ride"] = 56.25, ["Neon|Fly|Ride"] = 98.51, ["Mega"] = 17.63, ["Mega|Fly"] = 140.42, ["Mega|Fly|Ride"] = 182.44}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.28, ["Ride"] = 21.95, ["Fly|Ride"] = 434.84, ["Neon"] = 19.67, ["Neon|Fly"] = 125.74, ["Neon|Ride"] = 83.84, ["Mega"] = 105, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 471.72}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.52, ["Ride"] = 37.73, ["Neon"] = 22.64, ["Neon|Ride"] = 103.74, ["Mega"] = 383.92, ["Mega|Ride"] = 188.61, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 5.03, ["Ride"] = 31.5, ["Fly|Ride"] = 116.76, ["Neon"] = 15.75, ["Neon|Ride"] = 82.95, ["Neon|Fly|Ride"] = 272.44, ["Mega"] = 123.37, ["Mega|Ride"] = 155.06, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 530.04, ["Ride"] = 508.94, ["Fly|Ride"] = 586.69, ["Neon|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 5840.63}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 6.96, ["Fly"] = 27.75, ["Ride"] = 25.16, ["Fly|Ride"] = 52.31, ["Neon"] = 52.5, ["Neon|Ride"] = 70.12, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 278.25}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 11.53, ["Fly"] = 39.38, ["Ride"] = 18.8, ["Fly|Ride"] = 52.5, ["Neon"] = 46.11, ["Neon|Ride"] = 64.32, ["Mega"] = 471.72, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 310.56}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 6.15, ["Fly"] = 28.3, ["Ride"] = 20.97, ["Fly|Ride"] = 314.34, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 126.19, ["Mega"] = 203.44, ["Mega|Ride"] = 629.74, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 54.12, ["Ride"] = 28.3, ["Fly|Ride"] = 90.57, ["Neon"] = 7.16, ["Neon|Ride"] = 26.9, ["Neon|Fly|Ride"] = 118.41, ["Mega"] = 61.13, ["Mega|Ride"] = 97.81, ["Mega|Fly|Ride"] = 213.76}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 70.22, ["Ride"] = 27.26, ["Neon"] = 3.89, ["Neon|Ride"] = 31.75, ["Mega"] = 25.2, ["Mega|Ride"] = 54.76, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1545.48}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 10.39, ["Ride"] = 28.3, ["Neon"] = 79.03, ["Neon|Fly"] = 140.42, ["Neon|Ride"] = 83.74, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 796.32}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 29.7, ["Neon"] = 5.08, ["Neon|Ride"] = 40.69, ["Mega"] = 55.13, ["Mega|Ride"] = 101.07, ["Mega|Fly|Ride"] = 166.69}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.52, ["Fly"] = 98.51, ["Ride"] = 19.92, ["Fly|Ride"] = 574.38, ["Neon"] = 10.48, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 62.87, ["Neon|Fly|Ride"] = 133.88, ["Mega"] = 125.74, ["Mega|Ride"] = 158.04, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 452.82, ["Ride"] = 418.69, ["Fly|Ride"] = 433.13, ["Neon|Ride"] = 1534.32, ["Neon|Fly|Ride"] = 1536.05, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 7.07, ["Fly"] = 196.88, ["Ride"] = 72.19, ["Neon"] = 82.42, ["Neon|Ride"] = 131.25, ["Mega"] = 313.69, ["Mega|Ride"] = 448.13}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Ride"] = 40.88, ["Fly|Ride"] = 36.69, ["Neon"] = 6.56, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 419.11, ["Mega"] = 49.87, ["Mega|Fly"] = 189, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 209.57}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 21, ["Neon"] = 5.18, ["Neon|Ride"] = 47.19, ["Neon|Fly|Ride"] = 266.14, ["Mega"] = 23.23, ["Mega|Ride"] = 146.71, ["Mega|Fly|Ride"] = 217.88}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 7.79, ["Fly"] = 56.27, ["Ride"] = 66.08, ["Fly|Ride"] = 167.66, ["Neon"] = 62.89, ["Neon|Ride"] = 104.79, ["Neon|Fly|Ride"] = 279.66, ["Mega"] = 301.88, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 372.75}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 6.3, ["Ride"] = 98.51, ["Neon"] = 89.64, ["Neon|Ride"] = 112.12, ["Neon|Fly|Ride"] = 834.75, ["Mega"] = 393.75, ["Mega|Ride"] = 349.79, ["Mega|Fly|Ride"] = 1076.93}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 5.23, ["Ride"] = 31.5, ["Fly|Ride"] = 367.06, ["Neon"] = 105, ["Neon|Ride"] = 200.82, ["Mega"] = 419.12, ["Mega|Ride"] = 557.19, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 25.82, ["Ride"] = 65.63, ["Neon"] = 237.86, ["Neon|Ride"] = 180.06, ["Neon|Fly|Ride"] = 511.87, ["Mega"] = 459.38, ["Mega|Ride"] = 572.1, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 311.07, ["Ride"] = 414.93, ["Fly|Ride"] = 616.88, ["Neon"] = 1786.59, ["Neon|Fly"] = 1195.79, ["Neon|Ride"] = 1439.65, ["Neon|Fly|Ride"] = 1253.44, ["Mega|Ride"] = 3352.88, ["Mega|Fly|Ride"] = 3656.2}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 6.3, ["Fly"] = 28.3, ["Ride"] = 17.71, ["Fly|Ride"] = 140.42, ["Neon"] = 93.59, ["Neon|Ride"] = 140.42, ["Neon|Fly|Ride"] = 137.64, ["Mega"] = 559.53, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 561.75}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 28.04, ["Mega"] = 627.63, ["Mega|Fly|Ride"] = 1676.45}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 12.21, ["Ride"] = 59.91, ["Fly|Ride"] = 217.95, ["Neon"] = 48.16, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 221.96, ["Mega|Fly"] = 279.78, ["Mega|Ride"] = 223.79, ["Mega|Fly|Ride"] = 328.97}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.24, ["Ride"] = 41.99, ["Fly|Ride"] = 116.31, ["Neon"] = 15.69, ["Neon|Ride"] = 49.26, ["Neon|Fly|Ride"] = 208.52, ["Mega"] = 44.61, ["Mega|Fly"] = 78.75, ["Mega|Ride"] = 81.75, ["Mega|Fly|Ride"] = 136.5}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 48.85, ["Ride"] = 131.15, ["Neon"] = 283.97, ["Neon|Ride"] = 235.51, ["Neon|Fly|Ride"] = 471.52, ["Mega"] = 1814.75, ["Mega|Ride"] = 1337.3, ["Mega|Fly|Ride"] = 1243.71}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 585.43, ["Ride"] = 181.21, ["Fly|Ride"] = 56.59, ["Neon"] = 13.13, ["Neon|Fly"] = 156.96, ["Neon|Ride"] = 60.78, ["Neon|Fly|Ride"] = 112.12, ["Mega"] = 86.63, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 228.8}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 41.74, ["Ride"] = 28.3, ["Fly|Ride"] = 65.63, ["Neon"] = 6.24, ["Neon|Fly"] = 67.24, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 83.84, ["Mega"] = 51.18, ["Mega|Fly"] = 55.04, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 169}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 3.83, ["Ride"] = 167.66, ["Fly|Ride"] = 111.51, ["Neon"] = 61.83, ["Neon|Fly|Ride"] = 698.87, ["Mega"] = 362.06, ["Mega|Fly|Ride"] = 636.57}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 52.4, ["Ride"] = 65.63, ["Fly|Ride"] = 314.88, ["Neon"] = 279.78, ["Neon|Ride"] = 509.25, ["Neon|Fly|Ride"] = 627.63, ["Mega|Fly|Ride"] = 1394.58}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 242.82, ["Ride"] = 290.83, ["Fly|Ride"] = 329.44, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 984.38, ["Mega"] = 5867.51, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 10.48, ["Fly|Ride"] = 77.44, ["Neon"] = 25.87, ["Mega"] = 96.65, ["Mega|Fly"] = 264.06, ["Mega|Ride"] = 204.33}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 3.94, ["Ride"] = 126.19, ["Neon"] = 25.16, ["Neon|Ride"] = 51.09, ["Mega"] = 100.85, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.91, ["Fly"] = 155.57, ["Ride"] = 19.69, ["Neon"] = 33.54, ["Mega"] = 519.1, ["Mega|Ride"] = 337.84, ["Mega|Fly|Ride"] = 346.5}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 28.3, ["Ride"] = 28.3, ["Fly|Ride"] = 82.79, ["Neon"] = 7.49, ["Neon|Ride"] = 28.2, ["Neon|Fly|Ride"] = 137.69, ["Mega"] = 59.73, ["Mega|Ride"] = 65.54, ["Mega|Fly|Ride"] = 236.23}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 33.54, ["Fly|Ride"] = 279.78, ["Neon"] = 8.27, ["Mega"] = 52.4, ["Mega|Ride"] = 204.33, ["Mega|Fly|Ride"] = 275.58}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 15.75, ["Fly|Ride"] = 41.95, ["Neon"] = 5.25, ["Neon|Fly"] = 47.19, ["Neon|Ride"] = 32.49, ["Neon|Fly|Ride"] = 41.92, ["Mega"] = 47.25, ["Mega|Ride"] = 95.37, ["Mega|Fly|Ride"] = 108.91}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 90.36, ["Ride"] = 20.97, ["Fly|Ride"] = 62.89, ["Neon"] = 6.75, ["Neon|Fly"] = 70.22, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 91.18, ["Mega"] = 170.63, ["Mega|Ride"] = 209.57, ["Mega|Fly|Ride"] = 279.78}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 94.35, ["Ride"] = 40.45, ["Fly|Ride"] = 83.74, ["Neon|Ride"] = 279.78, ["Mega"] = 420, ["Mega|Fly"] = 525, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 85.99, ["Fly"] = 582.75, ["Ride"] = 102.67, ["Fly|Ride"] = 209.57, ["Neon"] = 363.46, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 703.06, ["Mega"] = 1470, ["Mega|Ride"] = 1676.45, ["Mega|Fly|Ride"] = 1460.6}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 17.7, ["Fly|Ride"] = 131.25, ["Neon"] = 3.92, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.57, ["Mega"] = 63.7, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 140.42}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 16.78, ["Ride"] = 15.72, ["Fly|Ride"] = 35.32, ["Neon"] = 3.93, ["Neon|Fly"] = 28.37, ["Neon|Ride"] = 24.11, ["Neon|Fly|Ride"] = 69.79, ["Mega"] = 45.85, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 66.03, ["Mega|Fly|Ride"] = 102.61}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 3.29, ["Ride"] = 27.26, ["Fly|Ride"] = 140.42, ["Neon"] = 28.3, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 167.66, ["Mega"] = 626.82, ["Mega|Ride"] = 347.88, ["Mega|Fly|Ride"] = 472.38}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 349.97, ["Fly"] = 393.74, ["Ride"] = 349.97, ["Fly|Ride"] = 497.7, ["Neon|Ride"] = 6562.5, ["Neon|Fly|Ride"] = 1570.62, ["Mega"] = 7862.14, ["Mega|Fly|Ride"] = 5588.8}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 35.63, ["Fly"] = 140.42, ["Ride"] = 59.07, ["Fly|Ride"] = 104.79, ["Neon"] = 223.13, ["Neon|Ride"] = 231.57, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 1075.03, ["Mega|Ride"] = 1183.26, ["Mega|Fly|Ride"] = 1040.53}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 36.75, ["Fly|Ride"] = 83.84, ["Neon"] = 11.43, ["Neon|Ride"] = 62.89, ["Neon|Fly|Ride"] = 98.51, ["Mega"] = 78.75, ["Mega|Ride"] = 105.15, ["Mega|Fly|Ride"] = 188.61}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 209.57, ["Ride"] = 28.87, ["Fly|Ride"] = 142.7, ["Neon"] = 23.79, ["Neon|Fly"] = 419.12, ["Neon|Ride"] = 200.15, ["Neon|Fly|Ride"] = 112.12, ["Mega"] = 481.99, ["Mega|Fly|Ride"] = 559.53}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 23.58, ["Fly"] = 255.63, ["Ride"] = 39.38, ["Fly|Ride"] = 65.62, ["Neon|Ride"] = 314.2, ["Neon|Fly|Ride"] = 455.79, ["Mega"] = 2514.65, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1101.44}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 119.43, ["Ride"] = 98.74, ["Fly|Ride"] = 140.21, ["Neon"] = 419.07, ["Neon|Ride"] = 469.42, ["Neon|Fly|Ride"] = 479.07, ["Mega"] = 3074.16, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 183.75, ["Ride"] = 249.38, ["Fly|Ride"] = 349.97, ["Neon"] = 959.94, ["Neon|Ride"] = 872.82, ["Neon|Fly|Ride"] = 834.04, ["Mega|Fly|Ride"] = 3193.6}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 14.27, ["Fly"] = 69.17, ["Ride"] = 32.69, ["Fly|Ride"] = 213.76, ["Neon"] = 97.02, ["Neon|Ride"] = 167.66, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 388.5, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 493.5}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.3, ["Ride"] = 15.75, ["Fly|Ride"] = 40.04, ["Neon"] = 8.02, ["Neon|Ride"] = 22.65, ["Neon|Fly|Ride"] = 88.03, ["Mega"] = 90.57, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 3.94, ["Fly"] = 30.31, ["Ride"] = 20.34, ["Fly|Ride"] = 639.68, ["Neon"] = 39.38, ["Neon|Fly"] = 146.71, ["Neon|Ride"] = 59.73, ["Neon|Fly|Ride"] = 83.84, ["Mega"] = 274.58, ["Mega|Ride"] = 244.39, ["Mega|Fly|Ride"] = 392.7}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 275.63, ["Ride"] = 328.13, ["Fly|Ride"] = 406.88, ["Neon"] = 1464.66, ["Neon|Ride"] = 1029.11, ["Neon|Fly|Ride"] = 1779.12, ["Mega|Fly|Ride"] = 4994.73}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 60.74, ["Neon"] = 7.28, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 49, ["Mega|Ride"] = 178.49, ["Mega|Fly|Ride"] = 417.03}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 6.57, ["Fly"] = 15.73, ["Ride"] = 18.38, ["Fly|Ride"] = 62.65, ["Neon"] = 24.11, ["Neon|Ride"] = 35.63, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 171.94, ["Mega|Fly"] = 204.9, ["Mega|Ride"] = 158.99, ["Mega|Fly|Ride"] = 249.36}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 21.76, ["Ride"] = 98.44, ["Neon"] = 133.29, ["Neon|Ride"] = 170.61, ["Neon|Fly|Ride"] = 279.78, ["Mega"] = 465.93, ["Mega|Ride"] = 496.55, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 141.5, ["Fly"] = 278.73, ["Ride"] = 133.45, ["Fly|Ride"] = 196.88, ["Neon|Ride"] = 740.79, ["Neon|Fly|Ride"] = 616.88, ["Mega|Fly|Ride"] = 2929.58}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 26.98, ["Fly"] = 45.93, ["Ride"] = 26.24, ["Fly|Ride"] = 53.82, ["Neon"] = 76.13, ["Neon|Ride"] = 98.51, ["Neon|Fly|Ride"] = 152.99, ["Mega"] = 418.07, ["Mega|Ride"] = 405.5, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 41.2, ["Neon"] = 3.93, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 698.87, ["Mega"] = 21, ["Mega|Ride"] = 103.74, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 52.5, ["Neon"] = 3.56, ["Neon|Fly"] = 158.04, ["Neon|Ride"] = 23.61, ["Neon|Fly|Ride"] = 69.88, ["Mega"] = 37.43, ["Mega|Fly"] = 140.35, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 92.99}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 8.99, ["Fly"] = 419.12, ["Ride"] = 65.63, ["Fly|Ride"] = 83.84, ["Neon"] = 27.26, ["Neon|Fly"] = 63.7, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 132.04, ["Mega"] = 149.43, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 260.24}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1168.13, ["Ride"] = 1311.19, ["Fly|Ride"] = 1334.73, ["Neon|Ride"] = 6985.49, ["Neon|Fly|Ride"] = 4882.61, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 408.19, ["Ride"] = 418.73, ["Fly|Ride"] = 511.03, ["Neon"] = 1739.43, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1697.39, ["Mega"] = 16764.28, ["Mega|Fly|Ride"] = 7084.87}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 262.48, ["Fly"] = 283.97, ["Ride"] = 324.84, ["Fly|Ride"] = 417.92, ["Neon"] = 735, ["Neon|Fly"] = 1258.28, ["Neon|Ride"] = 623.44, ["Neon|Fly|Ride"] = 734.99, ["Mega|Fly|Ride"] = 3066.09}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 332.69, ["Ride"] = 370.8, ["Fly|Ride"] = 444.94, ["Neon"] = 1104.36, ["Neon|Fly"] = 1117.98, ["Neon|Ride"] = 1115.63, ["Neon|Fly|Ride"] = 1177.32, ["Mega|Fly|Ride"] = 4181.65}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 57.74, ["Ride"] = 18.1, ["Fly|Ride"] = 44.63, ["Neon"] = 4.72, ["Neon|Ride"] = 29.25, ["Neon|Fly|Ride"] = 42, ["Mega"] = 60.02, ["Mega|Ride"] = 86.99, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 400.32, ["Ride"] = 472.5, ["Fly|Ride"] = 647.75, ["Neon"] = 1312.5, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1573.69, ["Mega"] = 13097.1, ["Mega|Fly|Ride"] = 5511.27}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 3.29, ["Fly"] = 183.75, ["Ride"] = 36.66, ["Fly|Ride"] = 63.39, ["Neon"] = 10.5, ["Neon|Ride"] = 56.4, ["Neon|Fly|Ride"] = 209.54, ["Mega"] = 72.28, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 209.32}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.25, ["Fly|Ride"] = 39.38, ["Neon"] = 15.73, ["Neon|Ride"] = 49, ["Neon|Fly|Ride"] = 66.55, ["Mega"] = 90.72, ["Mega|Ride"] = 192.93, ["Mega|Fly|Ride"] = 314.88}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Ride"] = 19.69, ["Neon"] = 3.94, ["Neon|Fly"] = 79.03, ["Neon|Ride"] = 39.37, ["Mega"] = 24.93, ["Mega|Fly"] = 167.66, ["Mega|Ride"] = 59.73, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 34.54, ["Ride"] = 65.63, ["Fly|Ride"] = 459.38, ["Neon"] = 244.13, ["Neon|Ride"] = 161.37, ["Mega"] = 2095.55, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 64.3, ["Ride"] = 16.72, ["Fly|Ride"] = 60.44, ["Neon"] = 5.25, ["Mega"] = 328.13, ["Mega|Ride"] = 233.63}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.12, ["Neon"] = 3.84, ["Neon|Fly"] = 118.02, ["Neon|Ride"] = 52.36, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 35.41, ["Mega|Fly"] = 698.87, ["Mega|Ride"] = 110.51, ["Mega|Fly|Ride"] = 314.88}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.5, ["Fly"] = 32.45, ["Ride"] = 17.07, ["Fly|Ride"] = 41.92, ["Neon"] = 8.4, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 35.39, ["Neon|Fly|Ride"] = 56.18, ["Mega"] = 61.67, ["Mega|Fly"] = 174.99, ["Mega|Ride"] = 83.84, ["Mega|Fly|Ride"] = 167.08}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 6.14, ["Fly"] = 47.19, ["Ride"] = 21.24, ["Fly|Ride"] = 51.45, ["Neon"] = 112.12, ["Neon|Fly"] = 141.52, ["Neon|Ride"] = 140.42, ["Neon|Fly|Ride"] = 128.61, ["Mega"] = 237.57, ["Mega|Ride"] = 300.51, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 18.26, ["Ride"] = 52.5, ["Neon|Ride"] = 279.78, ["Neon|Fly|Ride"] = 311.34, ["Mega"] = 377.21, ["Mega|Ride"] = 448.46, ["Mega|Fly|Ride"] = 349.97}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 4.2, ["Ride"] = 27.2, ["Fly|Ride"] = 70.22, ["Neon"] = 47.19, ["Neon|Ride"] = 98.51, ["Neon|Fly|Ride"] = 279.78, ["Mega"] = 559.53, ["Mega|Ride"] = 525}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 33.04, ["Ride"] = 19.69, ["Fly|Ride"] = 55.44, ["Neon"] = 5.25, ["Neon|Fly"] = 28.3, ["Neon|Ride"] = 28.27, ["Mega"] = 43.32, ["Mega|Ride"] = 83.84, ["Mega|Fly|Ride"] = 314.34}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 230.53, ["Fly"] = 279.78, ["Ride"] = 258.57, ["Fly|Ride"] = 353.64, ["Neon"] = 698.87, ["Neon|Ride"] = 2619.43, ["Neon|Fly|Ride"] = 1101.19, ["Mega"] = 8382.14, ["Mega|Fly|Ride"] = 5188.76}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 19.2, ["Ride"] = 15.75, ["Fly|Ride"] = 37.73, ["Neon"] = 5.22, ["Neon|Fly"] = 25.1, ["Neon|Ride"] = 18.86, ["Neon|Fly|Ride"] = 44.98, ["Mega"] = 46.01, ["Mega|Ride"] = 85.94, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 10.27, ["Ride"] = 94.47, ["Fly|Ride"] = 182.33, ["Neon"] = 52.5, ["Neon|Ride"] = 88.96, ["Mega"] = 393.75, ["Mega|Ride"] = 455.79, ["Mega|Fly|Ride"] = 698.87}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 29.57, ["Fly"] = 210, ["Ride"] = 104.79, ["Fly|Ride"] = 170.63, ["Neon"] = 262.5, ["Neon|Ride"] = 313.69, ["Mega"] = 838.23, ["Mega|Ride"] = 890.61, ["Mega|Fly|Ride"] = 880.91}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 187.94, ["Ride"] = 236.15, ["Fly|Ride"] = 333.38, ["Neon"] = 732.41, ["Neon|Ride"] = 651, ["Neon|Fly|Ride"] = 704.82, ["Mega|Ride"] = 3338.94, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 10.49, ["Fly|Ride"] = 140.35, ["Neon"] = 82.69, ["Neon|Ride"] = 279.78, ["Mega"] = 285.48, ["Mega|Ride"] = 349.97, ["Mega|Fly|Ride"] = 698.87}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 35.64, ["Ride"] = 112.11, ["Fly|Ride"] = 626.68, ["Neon"] = 553.93, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 787.5, ["Mega|Fly|Ride"] = 942.38}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1049.99, ["Ride"] = 1076.25, ["Fly|Ride"] = 1185.19, ["Neon|Ride"] = 5588.8, ["Neon|Fly|Ride"] = 4771.54, ["Mega|Fly|Ride"] = 17031.47}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 6.29, ["Fly"] = 27.26, ["Ride"] = 22.31, ["Fly|Ride"] = 53.45, ["Neon"] = 158.04, ["Neon|Fly"] = 75.06, ["Neon|Ride"] = 58.98, ["Neon|Fly|Ride"] = 200.82, ["Mega"] = 222.14, ["Mega|Ride"] = 237.86, ["Mega|Fly|Ride"] = 316.32}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 3.59, ["Fly"] = 65.63, ["Ride"] = 32.33, ["Neon"] = 37.73, ["Neon|Ride"] = 48.21, ["Mega"] = 346.5, ["Mega|Ride"] = 186.33, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 9.43, ["Ride"] = 78.6, ["Fly|Ride"] = 91.18, ["Neon"] = 89.29, ["Neon|Ride"] = 140.42, ["Mega"] = 542.07, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 627.63}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 14.59, ["Fly"] = 698.87, ["Ride"] = 35.69, ["Fly|Ride"] = 73.5, ["Neon"] = 61.67, ["Neon|Ride"] = 87.47, ["Neon|Fly|Ride"] = 166.95, ["Mega"] = 360.1, ["Mega|Ride"] = 431.82, ["Mega|Fly|Ride"] = 620.29}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 3.94, ["Fly"] = 18.51, ["Ride"] = 17.1, ["Fly|Ride"] = 48.21, ["Neon"] = 22.26, ["Neon|Fly"] = 34.06, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 273.26, ["Mega|Fly|Ride"] = 419.12}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Fly"] = 413.88, ["Ride"] = 47.19, ["Neon"] = 12.27, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 56.9, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 182.33, ["Mega|Ride"] = 136.4, ["Mega|Fly|Ride"] = 355.21}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 287.43, ["Ride"] = 334.69, ["Fly|Ride"] = 349.97, ["Neon"] = 1256.29, ["Neon|Ride"] = 1521.37, ["Neon|Fly|Ride"] = 1465.85, ["Mega|Ride"] = 5250, ["Mega|Fly|Ride"] = 4888.9}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 28, ["Fly|Ride"] = 60.38, ["Neon"] = 13.1, ["Neon|Fly"] = 83.84, ["Neon|Ride"] = 44.54, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 99.74, ["Mega|Ride"] = 111.48, ["Mega|Fly|Ride"] = 419.12}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 11.8, ["Ride"] = 66.95, ["Fly|Ride"] = 119.45, ["Neon"] = 131.24, ["Neon|Ride"] = 188.27, ["Mega"] = 276.63, ["Mega|Ride"] = 283.03}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 15.65, ["Fly"] = 62.75, ["Ride"] = 28.21, ["Neon"] = 15.73, ["Neon|Fly"] = 70.22, ["Neon|Ride"] = 62.53, ["Neon|Fly|Ride"] = 279.78, ["Mega"] = 98.56, ["Mega|Fly"] = 698.87, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 351.65}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 210, ["Fly"] = 354.9, ["Ride"] = 307.13, ["Fly|Ride"] = 511.88, ["Neon"] = 774.38, ["Neon|Ride"] = 840, ["Neon|Fly|Ride"] = 1069.69, ["Mega"] = 3032.26, ["Mega|Ride"] = 3143.32, ["Mega|Fly|Ride"] = 2362.5}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 25.65, ["Fly"] = 52.69, ["Ride"] = 45.93, ["Fly|Ride"] = 63, ["Neon"] = 102.46, ["Neon|Ride"] = 140.42, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 518.65, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 23.17, ["Ride"] = 36.58, ["Fly|Ride"] = 78.75, ["Neon"] = 97.94, ["Neon|Ride"] = 134.13, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 489.14, ["Mega|Ride"] = 427.88, ["Mega|Fly|Ride"] = 472.47}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.14, ["Neon|Ride"] = 35.55, ["Mega"] = 22.32, ["Mega|Ride"] = 140.4, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 66.9, ["Fly"] = 115.5, ["Ride"] = 102.38, ["Fly|Ride"] = 195.56, ["Neon"] = 347.82, ["Neon|Fly"] = 471.72, ["Neon|Ride"] = 362.06, ["Neon|Fly|Ride"] = 393.74, ["Mega|Fly|Ride"] = 1303.19}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 18.06, ["Neon"] = 6.56, ["Neon|Ride"] = 56.59, ["Neon|Fly|Ride"] = 588, ["Mega"] = 39.6, ["Mega|Ride"] = 209.57, ["Mega|Fly|Ride"] = 393.99}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 18.48, ["Fly"] = 126.19, ["Ride"] = 25.16, ["Fly|Ride"] = 71.99, ["Neon"] = 63.74, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 389.82, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 32.82, ["Fly"] = 110.06, ["Ride"] = 102.1, ["Fly|Ride"] = 175.87, ["Neon"] = 220.65, ["Neon|Ride"] = 282.19, ["Neon|Fly|Ride"] = 346.99, ["Mega|Ride"] = 1258.28, ["Mega|Fly|Ride"] = 1134}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 20.97, ["Ride"] = 14.44, ["Fly|Ride"] = 32.82, ["Neon"] = 2.63, ["Neon|Fly"] = 14.44, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 45.07, ["Mega"] = 18.38, ["Mega|Fly"] = 55.13, ["Mega|Ride"] = 37.73, ["Mega|Fly|Ride"] = 82.03}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.69, ["Ride"] = 33.48, ["Fly|Ride"] = 1346.59, ["Neon"] = 14.15, ["Neon|Ride"] = 78.6, ["Neon|Fly|Ride"] = 112.88, ["Mega"] = 220.53, ["Mega|Ride"] = 271.04, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 16.7, ["Fly"] = 42.47, ["Ride"] = 52.03, ["Neon"] = 125.74, ["Neon|Ride"] = 69.17, ["Neon|Fly|Ride"] = 629.74, ["Mega"] = 586.69, ["Mega|Ride"] = 794.75, ["Mega|Fly|Ride"] = 651}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.78, ["Neon"] = 2.63, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 136.23, ["Mega"] = 21, ["Mega|Ride"] = 136.4, ["Mega|Fly|Ride"] = 209.57}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 8.93, ["Ride"] = 55.5, ["Fly|Ride"] = 111.57, ["Neon"] = 79.78, ["Neon|Ride"] = 88.1, ["Neon|Fly|Ride"] = 313.29, ["Mega"] = 301.88, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 283.89, ["Mega|Fly|Ride"] = 559.53}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 16.46, ["Fly"] = 28.22, ["Ride"] = 20.85, ["Fly|Ride"] = 82.79, ["Neon"] = 205.85, ["Neon|Ride"] = 64.56, ["Neon|Fly|Ride"] = 328.13, ["Mega|Fly|Ride"] = 654.51}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.93, ["Ride"] = 41.92, ["Fly|Ride"] = 76.01, ["Neon"] = 25.17, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 162.31, ["Mega"] = 129.94, ["Mega|Ride"] = 199.15, ["Mega|Fly|Ride"] = 314.34}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 24.05, ["Fly"] = 2095.55, ["Ride"] = 96.71, ["Neon"] = 105, ["Neon|Ride"] = 140.42, ["Neon|Fly|Ride"] = 6289.01, ["Mega|Ride"] = 502.04, ["Mega|Fly|Ride"] = 1044.1}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.63, ["Fly"] = 31.5, ["Ride"] = 125.58, ["Fly|Ride"] = 196.88, ["Neon"] = 5.91, ["Neon|Fly"] = 56.59, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 99.08, ["Mega"] = 65.35, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 125.74, ["Mega|Fly|Ride"] = 519.7}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 77.84, ["Neon"] = 5.06, ["Mega"] = 27.26, ["Mega|Fly|Ride"] = 237.57}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 37.66}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 40.68, ["Fly"] = 102.38, ["Ride"] = 79.03, ["Fly|Ride"] = 90.04, ["Neon"] = 1050, ["Neon|Ride"] = 202.49, ["Neon|Fly|Ride"] = 559.53, ["Mega"] = 1243.71, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 774.38}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 84, ["Neon"] = 3.91, ["Mega"] = 22.08, ["Mega|Fly"] = 137.82, ["Mega|Ride"] = 140.42, ["Mega|Fly|Ride"] = 118.46}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 507.71, ["Ride"] = 571.73, ["Fly|Ride"] = 523.89, ["Neon"] = 2035.83, ["Neon|Fly|Ride"] = 2044.92, ["Mega"] = 16764.28, ["Mega|Ride"] = 15702.89, ["Mega|Fly|Ride"] = 15647.38}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 6.3, ["Fly"] = 26.17, ["Ride"] = 22.74, ["Fly|Ride"] = 88.03, ["Neon"] = 12.99, ["Neon|Fly"] = 698.87, ["Neon|Ride"] = 278.73, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 111.07, ["Mega|Ride"] = 112.12, ["Mega|Fly|Ride"] = 559.53}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 3.83, ["Fly"] = 138.15, ["Ride"] = 21, ["Fly|Ride"] = 59.04, ["Neon"] = 19.69, ["Neon|Ride"] = 38.06, ["Neon|Fly|Ride"] = 76.51, ["Mega"] = 393.75, ["Mega|Ride"] = 217.95, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 11.46, ["Ride"] = 76.13, ["Fly|Ride"] = 523.63, ["Neon"] = 65.63, ["Neon|Ride"] = 47.19, ["Mega"] = 514.46, ["Mega|Ride"] = 510.27, ["Mega|Fly|Ride"] = 550.73}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.94, ["Fly"] = 131.25, ["Ride"] = 31.83, ["Fly|Ride"] = 140.42, ["Neon"] = 36.69, ["Mega"] = 223.13}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 77.87, ["Ride"] = 65.62, ["Fly|Ride"] = 142.4, ["Neon"] = 52.5, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 349.97, ["Mega|Ride"] = 523.04, ["Mega|Fly|Ride"] = 893.17}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 7.25, ["Fly"] = 70.22, ["Ride"] = 56.59, ["Neon"] = 28.3, ["Neon|Ride"] = 97.99, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 189, ["Mega|Fly"] = 484.09, ["Mega|Ride"] = 208.69}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.65, ["Fly|Ride"] = 56.57, ["Neon"] = 2.1, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 75.46, ["Mega"] = 22.3, ["Mega|Fly"] = 62.43, ["Mega|Ride"] = 31.49, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 9.19, ["Ride"] = 27.56, ["Fly|Ride"] = 158.04, ["Neon"] = 28.13, ["Neon|Fly"] = 117.95, ["Neon|Ride"] = 70.21, ["Neon|Fly|Ride"] = 622.13, ["Mega"] = 194.25, ["Mega|Ride"] = 167.99, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 246.86, ["Ride"] = 275.63, ["Fly|Ride"] = 349.97, ["Neon"] = 1480.5, ["Neon|Ride"] = 1148.62, ["Neon|Fly|Ride"] = 1313.71, ["Mega|Fly|Ride"] = 3912.21}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 82.69, ["Ride"] = 140.42, ["Fly|Ride"] = 7683.3, ["Neon|Ride"] = 559.53, ["Neon|Fly|Ride"] = 623.44, ["Mega"] = 4191.09, ["Mega|Ride"] = 2095.55, ["Mega|Fly|Ride"] = 1603.88}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 23.06, ["Ride"] = 17.7, ["Fly|Ride"] = 39.38, ["Neon"] = 23.06, ["Neon|Fly"] = 48.21, ["Neon|Ride"] = 19.92, ["Neon|Fly|Ride"] = 62.67, ["Mega|Fly"] = 208.52, ["Mega|Ride"] = 98.51, ["Mega|Fly|Ride"] = 153.08}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 17.39, ["Ride"] = 16.36, ["Fly|Ride"] = 33.24, ["Neon"] = 7.33, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 22.23, ["Neon|Fly|Ride"] = 50.97, ["Mega"] = 60.38, ["Mega|Fly"] = 349.97, ["Mega|Ride"] = 116.31, ["Mega|Fly|Ride"] = 204.75}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.97, ["Ride"] = 22.31, ["Fly|Ride"] = 98.44, ["Neon"] = 38.07, ["Neon|Fly|Ride"] = 419.12, ["Mega"] = 140.42, ["Mega|Fly|Ride"] = 140.42}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 231.87, ["Ride"] = 237.57, ["Fly|Ride"] = 328.13, ["Neon|Ride"] = 944.99, ["Neon|Fly|Ride"] = 1230.09, ["Mega|Ride"] = 8382.14, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 3.94, ["Fly"] = 35.53, ["Ride"] = 18.38, ["Fly|Ride"] = 45.72, ["Neon"] = 24.11, ["Neon|Fly"] = 158.04, ["Neon|Ride"] = 41.91, ["Neon|Fly|Ride"] = 141.52, ["Mega"] = 300.72, ["Mega|Ride"] = 267.71, ["Mega|Fly|Ride"] = 296.33}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.94, ["Fly"] = 158.04, ["Ride"] = 96.48, ["Fly|Ride"] = 209.57, ["Neon"] = 22.32, ["Neon|Ride"] = 139.13, ["Mega"] = 196.88, ["Mega|Ride"] = 236.24, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 6.3, ["Neon|Ride"] = 30.7, ["Mega"] = 47.16, ["Mega|Ride"] = 96.47, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 19.69, ["Fly"] = 69.17, ["Ride"] = 27.15, ["Fly|Ride"] = 67.08, ["Neon"] = 78.23, ["Neon|Ride"] = 106.15, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 728.34, ["Mega|Ride"] = 418.07, ["Mega|Fly|Ride"] = 391.88}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 62.99, ["Ride"] = 98.44, ["Fly|Ride"] = 209.9, ["Neon"] = 157.26, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 196.77, ["Neon|Fly|Ride"] = 314.88, ["Mega"] = 537.97, ["Mega|Fly"] = 2200.33, ["Mega|Ride"] = 579.03, ["Mega|Fly|Ride"] = 609.33}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 24.92, ["Fly"] = 158.04, ["Ride"] = 44.62, ["Fly|Ride"] = 81.36, ["Neon"] = 123.43, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 123.55, ["Neon|Fly|Ride"] = 235.87, ["Mega"] = 796.32, ["Mega|Ride"] = 559.53, ["Mega|Fly|Ride"] = 628.67}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 17.7, ["Ride"] = 11.82, ["Fly|Ride"] = 35.39, ["Neon"] = 2.63, ["Neon|Fly"] = 27.53, ["Neon|Ride"] = 18.11, ["Neon|Fly|Ride"] = 61.83, ["Mega"] = 24.94, ["Mega|Fly"] = 412.51, ["Mega|Ride"] = 23.91, ["Mega|Fly|Ride"] = 114.35}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 227.05, ["Ride"] = 262.5, ["Fly|Ride"] = 349.97, ["Neon"] = 2987.65, ["Neon|Ride"] = 958.13, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 4199.99}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 15.64, ["Fly"] = 61.61, ["Ride"] = 45.94, ["Fly|Ride"] = 125.74, ["Neon"] = 103.84, ["Neon|Ride"] = 92.25, ["Neon|Fly|Ride"] = 321.56, ["Mega|Fly|Ride"] = 589.32}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 24.99, ["Ride"] = 18.37, ["Fly|Ride"] = 39.37, ["Neon"] = 5.25, ["Neon|Fly"] = 26.34, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 111.07, ["Mega"] = 59.14, ["Mega|Fly"] = 179.18, ["Mega|Ride"] = 140.42, ["Mega|Fly|Ride"] = 299.54}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 28.3, ["Ride"] = 17.07, ["Fly|Ride"] = 55.47, ["Neon"] = 3.42, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 20.41, ["Neon|Fly|Ride"] = 98.49, ["Mega"] = 30.07, ["Mega|Fly"] = 141.52, ["Mega|Ride"] = 48.69, ["Mega|Fly|Ride"] = 139.13}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 23.45, ["Fly|Ride"] = 69.27, ["Neon"] = 11.46, ["Neon|Ride"] = 60.16, ["Neon|Fly|Ride"] = 79.03, ["Mega"] = 94.01, ["Mega|Ride"] = 116.08, ["Mega|Fly|Ride"] = 385.64}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 12.72, ["Fly"] = 38.68, ["Ride"] = 24.94, ["Fly|Ride"] = 64.32, ["Neon"] = 32.49, ["Neon|Ride"] = 66.94, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 257.25, ["Mega|Fly"] = 786.59, ["Mega|Ride"] = 285.85, ["Mega|Fly|Ride"] = 336.09}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 6.54, ["Ride"] = 26.22, ["Fly|Ride"] = 72.19, ["Neon"] = 53.91, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 275.63, ["Mega|Ride"] = 321.67, ["Mega|Fly|Ride"] = 343.69}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Neon|Ride"] = 46.01, ["Mega"] = 31.85, ["Mega|Ride"] = 61.07}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 10.5, ["Ride"] = 36.69, ["Fly|Ride"] = 82.79, ["Neon"] = 18.05, ["Neon|Fly"] = 47.16, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 87.54, ["Mega"] = 157.5, ["Mega|Ride"] = 259.83, ["Mega|Fly|Ride"] = 292.48}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 125.74, ["Neon"] = 4.73, ["Neon|Fly"] = 98.51, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 158.04, ["Mega"] = 33.54, ["Mega|Ride"] = 91.34, ["Mega|Fly|Ride"] = 314.88}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 27.08, ["Ride"] = 20.92, ["Fly|Ride"] = 83.93, ["Neon"] = 6.64, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 60.36, ["Mega"] = 125.9, ["Mega|Ride"] = 78.66, ["Mega|Fly|Ride"] = 179.41}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 629.97, ["Ride"] = 727.13, ["Fly|Ride"] = 748.13, ["Neon"] = 4173.27, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 3150, ["Mega|Fly|Ride"] = 12445.4}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 16.96, ["Fly|Ride"] = 31.49, ["Neon"] = 27.64, ["Neon|Fly"] = 50.31, ["Neon|Ride"] = 36.58, ["Neon|Fly|Ride"] = 56.59, ["Mega"] = 187.57, ["Mega|Fly|Ride"] = 209.57}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 3.94, ["Ride"] = 30.58, ["Fly|Ride"] = 164.72, ["Neon"] = 11.82, ["Neon|Fly"] = 838.23, ["Neon|Ride"] = 52.4, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 52.5, ["Mega|Fly"] = 158.04, ["Mega|Ride"] = 103.37, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 7.6, ["Fly"] = 26.17, ["Ride"] = 24.94, ["Fly|Ride"] = 53.82, ["Neon"] = 37.21, ["Neon|Fly"] = 40.11, ["Neon|Ride"] = 51.98, ["Neon|Fly|Ride"] = 104.85, ["Mega"] = 309.1, ["Mega|Ride"] = 307.13, ["Mega|Fly|Ride"] = 336}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.65, ["Fly|Ride"] = 32.74, ["Neon"] = 6.57, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 58.95, ["Mega"] = 103.69, ["Mega|Fly"] = 349.93, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 178.68}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 61.82, ["Ride"] = 78.75, ["Fly|Ride"] = 208.52, ["Neon"] = 222.29, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 887.48, ["Mega|Ride"] = 664.31, ["Mega|Fly|Ride"] = 731.36}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 7.88, ["Neon|Fly"] = 134.46, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 47.25, ["Mega|Ride"] = 277.14, ["Mega|Fly|Ride"] = 278.73}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 3.67, ["Fly"] = 73.49, ["Ride"] = 23.49, ["Fly|Ride"] = 65.63, ["Neon"] = 11.32, ["Neon|Fly"] = 140.42, ["Neon|Ride"] = 41.92, ["Neon|Fly|Ride"] = 448.23, ["Mega"] = 98.44, ["Mega|Ride"] = 155.09, ["Mega|Fly|Ride"] = 156.85}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 65.76, ["Neon"] = 15.73, ["Neon|Fly"] = 31.85, ["Neon|Ride"] = 110.87, ["Mega"] = 116.31, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Ride"] = 20.73, ["Fly|Ride"] = 35.64, ["Neon"] = 3.94, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 25.92, ["Neon|Fly|Ride"] = 65.01, ["Mega"] = 39.71, ["Mega|Fly"] = 181.92, ["Mega|Ride"] = 59.06, ["Mega|Fly|Ride"] = 140.42}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 20.96, ["Fly"] = 19.69, ["Ride"] = 23.06, ["Fly|Ride"] = 41.92, ["Neon"] = 103.69, ["Neon|Ride"] = 82.98, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 838.23, ["Mega|Ride"] = 391.88, ["Mega|Fly|Ride"] = 415.77}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 736.75, ["Ride"] = 783.56, ["Fly|Ride"] = 853.13, ["Neon"] = 1837.5, ["Neon|Fly"] = 2417.49, ["Neon|Ride"] = 1928.28, ["Neon|Fly|Ride"] = 1929.38, ["Mega|Ride"] = 6007.92, ["Mega|Fly|Ride"] = 5250}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 18.9, ["Ride"] = 18.8, ["Fly|Ride"] = 56.58, ["Neon"] = 8.27, ["Neon|Fly"] = 139.19, ["Neon|Ride"] = 19.92, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 52.75, ["Mega|Fly"] = 65.63, ["Mega|Ride"] = 98.51, ["Mega|Fly|Ride"] = 155.09}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 6.54, ["Ride"] = 32.82, ["Fly|Ride"] = 92.22, ["Neon"] = 27.56, ["Neon|Fly"] = 140.42, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 248.11, ["Mega"] = 328.13, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 557.43}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 52.49, ["Fly"] = 126.19, ["Ride"] = 85.31, ["Fly|Ride"] = 116.82, ["Neon|Ride"] = 412.76, ["Neon|Fly|Ride"] = 448.88, ["Mega"] = 3150.32, ["Mega|Fly|Ride"] = 2332.32}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 26.73, ["Fly"] = 140.42, ["Ride"] = 49.88, ["Fly|Ride"] = 102.79, ["Neon"] = 131.25, ["Neon|Ride"] = 117.95, ["Neon|Fly|Ride"] = 347.88, ["Mega"] = 1957.25, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 943.01}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 19.82, ["Ride"] = 43.3, ["Neon"] = 112.21, ["Neon|Ride"] = 122.03, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 377.1, ["Mega|Ride"] = 366.74, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 49.26, ["Ride"] = 83.84, ["Neon"] = 72.19, ["Neon|Ride"] = 362.06, ["Mega"] = 279.78, ["Mega|Fly"] = 511.82, ["Mega|Ride"] = 360.87, ["Mega|Fly|Ride"] = 384.03}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 19.69, ["Ride"] = 52.5, ["Fly|Ride"] = 83.84, ["Neon"] = 140.42, ["Neon|Ride"] = 304.77, ["Neon|Fly|Ride"] = 338.42, ["Mega"] = 733.46, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 628.67}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 41.92}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 5.36, ["Ride"] = 30.34, ["Fly|Ride"] = 78.75, ["Neon"] = 25.2, ["Neon|Ride"] = 125.68, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 204.75, ["Mega|Fly"] = 519.75, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 305.82}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.1, ["Ride"] = 36.69, ["Neon"] = 36.75, ["Neon|Ride"] = 43.32, ["Mega"] = 880.91}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 70.73, ["Fly"] = 417.8, ["Ride"] = 90.14, ["Fly|Ride"] = 103.95, ["Neon"] = 279.78, ["Neon|Ride"] = 203.74, ["Neon|Fly|Ride"] = 943.43, ["Mega|Ride"] = 1004.07, ["Mega|Fly|Ride"] = 1030.32}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 6.24, ["Fly"] = 27.26, ["Ride"] = 15.31, ["Fly|Ride"] = 37.97, ["Neon"] = 26.92, ["Neon|Fly"] = 67.98, ["Neon|Ride"] = 33.35, ["Neon|Fly|Ride"] = 81.36, ["Mega"] = 262.5, ["Mega|Fly"] = 418.07, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 264.06}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 6.53, ["Fly"] = 83.84, ["Ride"] = 23.2, ["Fly|Ride"] = 104.79, ["Neon"] = 27.56, ["Neon|Ride"] = 83.84, ["Neon|Fly|Ride"] = 136.23, ["Mega"] = 128.64, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 267.75}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 5.92, ["Neon|Ride"] = 92.22, ["Mega"] = 72.18, ["Mega|Ride"] = 96.6, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 32.43, ["Fly"] = 65.63, ["Ride"] = 48.38, ["Fly|Ride"] = 99.74, ["Neon"] = 218.68, ["Neon|Ride"] = 140.42, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 1117.98, ["Mega|Ride"] = 13970.94, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Fly"] = 20.97, ["Ride"] = 27.75, ["Neon"] = 12.99, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 85.94, ["Mega"] = 91.17, ["Mega|Ride"] = 114.53, ["Mega|Fly|Ride"] = 309.68}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 7.87, ["Ride"] = 26.25, ["Neon"] = 70.22, ["Neon|Ride"] = 143.83, ["Neon|Fly|Ride"] = 268.59, ["Mega"] = 349.97, ["Mega|Ride"] = 698.87, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 19.81, ["Ride"] = 15.99, ["Fly|Ride"] = 35.64, ["Neon"] = 21.24, ["Neon|Ride"] = 28.3, ["Neon|Fly|Ride"] = 121.05, ["Mega"] = 144.37, ["Mega|Ride"] = 257.92, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 7.62, ["Fly"] = 52.49, ["Ride"] = 21.31, ["Fly|Ride"] = 45.01, ["Neon"] = 157.5, ["Neon|Ride"] = 410.78, ["Mega"] = 209.57, ["Mega|Ride"] = 279.78, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.92, ["Ride"] = 36.53, ["Neon"] = 36.11, ["Neon|Ride"] = 110.87, ["Mega"] = 140.4, ["Mega|Ride"] = 836.73}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 33.1, ["Ride"] = 83.84, ["Neon"] = 157.5, ["Neon|Ride"] = 266.14, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 950.36, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 18.37, ["Ride"] = 28.3, ["Neon"] = 131.25, ["Mega"] = 410.17, ["Mega|Fly|Ride"] = 496.79}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 20.97, ["Ride"] = 104.9, ["Fly|Ride"] = 279.78, ["Neon"] = 140.2, ["Mega|Ride"] = 983.87, ["Mega|Fly|Ride"] = 769.08}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 15.88, ["Ride"] = 56.59, ["Fly|Ride"] = 529.5, ["Neon"] = 82.65, ["Neon|Ride"] = 111.38, ["Mega|Ride"] = 734.93, ["Mega|Fly|Ride"] = 1044.64}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 6.2, ["Neon"] = 89.64, ["Mega"] = 111.57, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 314.88}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 16.21, ["Fly|Ride"] = 41.92, ["Neon"] = 3.83, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 31.85, ["Neon|Fly|Ride"] = 73.37, ["Mega"] = 60.78, ["Mega|Ride"] = 89.24, ["Mega|Fly|Ride"] = 103.74}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 5.81, ["Ride"] = 50.91, ["Fly|Ride"] = 328.13, ["Neon"] = 28.3, ["Neon|Ride"] = 115.26, ["Neon|Fly|Ride"] = 121.21, ["Mega"] = 279.78, ["Mega|Ride"] = 205.38, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 29.69, ["Ride"] = 17.9, ["Fly|Ride"] = 55.95, ["Neon"] = 5.24, ["Neon|Ride"] = 28.3, ["Neon|Fly|Ride"] = 67.94, ["Mega"] = 42.99, ["Mega|Ride"] = 81.27, ["Mega|Fly|Ride"] = 196.35}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.92, ["Fly"] = 131.25, ["Ride"] = 47.14, ["Fly|Ride"] = 110.35, ["Neon"] = 48.21, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 112.12, ["Mega"] = 236.25, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 471.72}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.94, ["Ride"] = 33.44, ["Fly|Ride"] = 70.22, ["Neon"] = 33.36, ["Neon|Fly"] = 471.72, ["Neon|Ride"] = 96.41, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 381.4, ["Mega|Ride"] = 419.12, ["Mega|Fly|Ride"] = 1047.78}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.74, ["Fly"] = 131.25, ["Ride"] = 15.73, ["Fly|Ride"] = 41.99, ["Neon"] = 21, ["Neon|Fly"] = 104.79, ["Neon|Ride"] = 40.32, ["Neon|Fly|Ride"] = 112.12, ["Mega"] = 246.24, ["Mega|Ride"] = 249.48, ["Mega|Fly|Ride"] = 357.67}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 34.41, ["Ride"] = 17.06, ["Fly|Ride"] = 52.4, ["Neon"] = 21.24, ["Neon|Ride"] = 70.22, ["Neon|Fly|Ride"] = 104.79, ["Mega"] = 161.37, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 285.41}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 7.07, ["Fly"] = 301.88, ["Ride"] = 47.25, ["Fly|Ride"] = 179.82, ["Neon"] = 21.75, ["Neon|Fly"] = 123.65, ["Neon|Ride"] = 81.37, ["Neon|Fly|Ride"] = 203.28, ["Mega"] = 151.76, ["Mega|Ride"] = 157.18, ["Mega|Fly|Ride"] = 419.12}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 16.78, ["Fly"] = 139.55, ["Ride"] = 89.14, ["Fly|Ride"] = 261.18, ["Neon"] = 85.32, ["Neon|Ride"] = 182.33, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 384.57, ["Mega|Fly"] = 669.38, ["Mega|Ride"] = 447.23, ["Mega|Fly|Ride"] = 585.65}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 77.85, ["Ride"] = 107.93, ["Fly|Ride"] = 164.07, ["Neon"] = 249.38, ["Neon|Fly"] = 333.21, ["Neon|Ride"] = 263.81, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 1536.05, ["Mega|Ride"] = 996.02, ["Mega|Fly|Ride"] = 1060.45}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 50.91, ["Ride"] = 21.83, ["Fly|Ride"] = 65.54, ["Neon"] = 3.83, ["Neon|Ride"] = 38.45, ["Neon|Fly|Ride"] = 60.78, ["Mega"] = 31.5, ["Mega|Ride"] = 60.29, ["Mega|Fly|Ride"] = 103.69}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 18.27, ["Neon"] = 126.46, ["Neon|Ride"] = 199.31, ["Mega"] = 911.54, ["Mega|Ride"] = 589.64, ["Mega|Fly|Ride"] = 1257.33}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 51.19, ["Ride"] = 79.65, ["Neon"] = 235.87, ["Neon|Ride"] = 299.54, ["Neon|Fly|Ride"] = 522.85, ["Mega"] = 1085.51, ["Mega|Ride"] = 1108.55, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 9.19, ["Fly"] = 190.32, ["Ride"] = 44.61, ["Fly|Ride"] = 125.99, ["Neon"] = 52.4, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 209.57, ["Mega"] = 231.57, ["Mega|Ride"] = 235.87, ["Mega|Fly|Ride"] = 449.54}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Ride"] = 76.65, ["Fly|Ride"] = 136.82, ["Neon"] = 4.44, ["Neon|Ride"] = 35.62, ["Mega"] = 32.82, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 62.21, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 19.09, ["Ride"] = 18.37, ["Fly|Ride"] = 46.11, ["Neon"] = 15.65, ["Neon|Fly"] = 36.69, ["Neon|Ride"] = 28.2, ["Neon|Fly|Ride"] = 82.41, ["Mega"] = 182.33, ["Mega|Fly"] = 349.97, ["Mega|Ride"] = 313.69, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 15.73, ["Ride"] = 18.87, ["Fly|Ride"] = 35.44, ["Neon"] = 2.63, ["Neon|Fly"] = 21, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 49, ["Mega"] = 34.13, ["Mega|Ride"] = 82.79, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Fly"] = 41.92, ["Ride"] = 17.53, ["Fly|Ride"] = 66.4, ["Neon"] = 5.24, ["Neon|Ride"] = 36.58, ["Neon|Fly|Ride"] = 83.84, ["Mega"] = 44.6, ["Mega|Fly"] = 168, ["Mega|Ride"] = 112.12, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.49, ["Fly|Ride"] = 158.04, ["Neon"] = 2.63, ["Neon|Ride"] = 123.24, ["Mega"] = 21, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 7.88, ["Ride"] = 31.42, ["Fly|Ride"] = 262.5, ["Neon"] = 40.69, ["Neon|Fly|Ride"] = 207.47, ["Mega"] = 188.69, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 7.08, ["Ride"] = 32.49, ["Fly|Ride"] = 83.84, ["Neon"] = 52.73, ["Neon|Ride"] = 98.49, ["Neon|Fly|Ride"] = 234.69, ["Mega"] = 360.94, ["Mega|Ride"] = 304.5, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 5.98, ["Fly"] = 28.2, ["Ride"] = 20.87, ["Fly|Ride"] = 48.21, ["Neon"] = 43.1, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 55.48, ["Neon|Fly|Ride"] = 86.61, ["Mega"] = 393.75, ["Mega|Ride"] = 335.74, ["Mega|Fly|Ride"] = 293.76}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 49.87, ["Ride"] = 78.75, ["Fly|Ride"] = 262.5, ["Neon"] = 349.97, ["Neon|Ride"] = 597.19, ["Neon|Fly|Ride"] = 414.93}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 20.66, ["Fly"] = 72.44, ["Ride"] = 65.63, ["Fly|Ride"] = 79.03, ["Neon"] = 91.18, ["Mega"] = 624.1, ["Mega|Ride"] = 559.53, ["Mega|Fly|Ride"] = 1181.93}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 18.87, ["Ride"] = 18.78, ["Fly|Ride"] = 39.23, ["Neon"] = 3.94, ["Neon|Fly"] = 28.3, ["Neon|Ride"] = 23.61, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 36.69, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 17.7, ["Ride"] = 17.69, ["Fly|Ride"] = 32.97, ["Neon"] = 3.94, ["Neon|Fly"] = 26.17, ["Neon|Ride"] = 22.89, ["Neon|Fly|Ride"] = 41.92, ["Mega"] = 69.21, ["Mega|Ride"] = 66.03, ["Mega|Fly|Ride"] = 101.06}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 383.28, ["Ride"] = 438.37, ["Fly|Ride"] = 433.13, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1509.37}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 15.73, ["Ride"] = 59.07, ["Fly|Ride"] = 242.26, ["Neon"] = 157.5, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 1257.33, ["Mega|Fly|Ride"] = 1676.45}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 30.51, ["Ride"] = 16.78, ["Fly|Ride"] = 32.48, ["Neon"] = 6.36, ["Neon|Fly"] = 70.22, ["Neon|Ride"] = 20.85, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 31.17, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 93.5}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 69.15, ["Ride"] = 191.76, ["Fly|Ride"] = 223.12, ["Neon"] = 227.48, ["Neon|Ride"] = 292.48, ["Neon|Fly|Ride"] = 522.85, ["Mega"] = 737.62, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 1257.33}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 16.52, ["Ride"] = 20.97, ["Fly|Ride"] = 28.3, ["Neon"] = 9.19, ["Neon|Fly"] = 36.75, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 61.83, ["Mega"] = 77.57, ["Mega|Fly"] = 133.07, ["Mega|Ride"] = 126.84, ["Mega|Fly|Ride"] = 158.81}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 70.22, ["Ride"] = 34.13, ["Fly|Ride"] = 1312.5, ["Neon"] = 2.71, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 27.55, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 19.49, ["Mega|Fly"] = 195.96, ["Mega|Ride"] = 65.23, ["Mega|Fly|Ride"] = 207.8}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 60.78, ["Fly"] = 126.52, ["Ride"] = 85.72, ["Fly|Ride"] = 124.69, ["Neon"] = 195.96, ["Neon|Ride"] = 320.62, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 656.25, ["Mega|Ride"] = 629.94, ["Mega|Fly|Ride"] = 1397.74}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 20.97, ["Fly|Ride"] = 52.5, ["Neon"] = 6.24, ["Neon|Ride"] = 41.29, ["Mega"] = 121.55, ["Mega|Ride"] = 131.15, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 39.38, ["Ride"] = 77.35, ["Fly|Ride"] = 67.24, ["Neon"] = 153.56, ["Neon|Ride"] = 207.57, ["Neon|Fly|Ride"] = 448.46, ["Mega"] = 1654.44, ["Mega|Ride"] = 1676.45, ["Mega|Fly|Ride"] = 903}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.84, ["Ride"] = 45.02, ["Fly|Ride"] = 209.57, ["Neon"] = 14.15, ["Neon|Ride"] = 299.77, ["Neon|Fly|Ride"] = 419.12, ["Mega"] = 175.88, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 470.54}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 3.94, ["Fly"] = 70.22, ["Ride"] = 18.83, ["Fly|Ride"] = 65.63, ["Neon"] = 12.89, ["Neon|Fly"] = 78.54, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 82.69, ["Mega|Ride"] = 140.42, ["Mega|Fly|Ride"] = 559.53}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 31.85, ["Ride"] = 50.34, ["Fly|Ride"] = 118.12, ["Neon"] = 146.44, ["Neon|Ride"] = 262.49, ["Mega|Ride"] = 2598.75}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.63, ["Fly"] = 144.82, ["Ride"] = 38.78, ["Fly|Ride"] = 908.98, ["Neon"] = 6.45, ["Neon|Ride"] = 62.89, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 46.77, ["Mega|Fly"] = 170.21, ["Mega|Ride"] = 95.73, ["Mega|Fly|Ride"] = 259.86}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 56.59, ["Ride"] = 17.07, ["Fly|Ride"] = 102.86, ["Neon"] = 6.75, ["Neon|Fly"] = 41.1, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 104.79, ["Mega"] = 167.66, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 9.16, ["Fly"] = 35.6, ["Ride"] = 30.26, ["Fly|Ride"] = 73.37, ["Neon"] = 31.29, ["Neon|Ride"] = 141.52, ["Mega"] = 345.19, ["Mega|Ride"] = 272.87, ["Mega|Fly|Ride"] = 388.5}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 45.9, ["Ride"] = 116.8, ["Fly|Ride"] = 279.57, ["Neon"] = 418.02, ["Neon|Ride"] = 350.44, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 940.91, ["Mega|Ride"] = 744.98, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 28.88, ["Fly"] = 50.15, ["Ride"] = 35.44, ["Fly|Ride"] = 82.79, ["Neon"] = 92.22, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 157.18, ["Mega"] = 620.57, ["Mega|Ride"] = 388.5, ["Mega|Fly|Ride"] = 409.22}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 78.75, ["Ride"] = 104.98, ["Fly|Ride"] = 196.85, ["Neon"] = 315, ["Neon|Ride"] = 380.63, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1312.5, ["Mega|Ride"] = 1085.17, ["Mega|Fly|Ride"] = 1312.38}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 2.63, ["Ride"] = 35.44, ["Neon"] = 15.73, ["Neon|Ride"] = 60.78, ["Neon|Fly|Ride"] = 305.81, ["Mega"] = 201.41, ["Mega|Ride"] = 323.13, ["Mega|Fly|Ride"] = 329.02}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 4.57, ["Ride"] = 26.16, ["Fly|Ride"] = 78.74, ["Neon"] = 18.38, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 203.44, ["Mega|Ride"] = 203.28, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 11.81, ["Fly"] = 65.62, ["Ride"] = 44, ["Fly|Ride"] = 157.5, ["Neon"] = 49.58, ["Neon|Ride"] = 137.55, ["Neon|Fly|Ride"] = 301.86, ["Mega"] = 401.31, ["Mega|Ride"] = 370.93, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 13.12, ["Fly|Ride"] = 33.54, ["Neon"] = 2.1, ["Neon|Fly"] = 17.07, ["Neon|Ride"] = 14.53, ["Neon|Fly|Ride"] = 51.8, ["Mega"] = 15.73, ["Mega|Fly"] = 70.22, ["Mega|Ride"] = 23.55, ["Mega|Fly|Ride"] = 83.74}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 62.99, ["Fly"] = 220.5, ["Ride"] = 91.74, ["Fly|Ride"] = 272.29, ["Neon"] = 142.71, ["Neon|Fly"] = 2256.27, ["Neon|Ride"] = 283.03, ["Neon|Fly|Ride"] = 471.72, ["Mega"] = 1117.98, ["Mega|Ride"] = 946.15, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 94.32, ["Fly|Ride"] = 108.98, ["Neon"] = 6.45, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 84.92, ["Mega"] = 55.44, ["Mega|Ride"] = 51.27, ["Mega|Fly|Ride"] = 311.85}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 26.46, ["Ride"] = 15.65, ["Fly|Ride"] = 32.82, ["Neon"] = 11.8, ["Neon|Fly"] = 16.7, ["Neon|Ride"] = 32.49, ["Neon|Fly|Ride"] = 53.42, ["Mega"] = 116.94, ["Mega|Ride"] = 212.28, ["Mega|Fly|Ride"] = 518.55}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 85.22, ["Ride"] = 119.51, ["Fly|Ride"] = 235.87, ["Neon"] = 328.02, ["Neon|Ride"] = 354.38, ["Neon|Fly|Ride"] = 511.88, ["Mega"] = 1022.44, ["Mega|Ride"] = 1351.88, ["Mega|Fly|Ride"] = 1233.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 72.18, ["Neon"] = 5.25, ["Neon|Ride"] = 48.21, ["Mega"] = 69.49, ["Mega|Ride"] = 116.31, ["Mega|Fly|Ride"] = 393.99}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 17.07}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 62.89, ["Fly|Ride"] = 102.66, ["Neon"] = 10.49, ["Neon|Ride"] = 69.17, ["Neon|Fly|Ride"] = 139.78, ["Mega"] = 44.82, ["Mega|Ride"] = 124.65, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 140.42, ["Ride"] = 171.83, ["Fly|Ride"] = 236.25, ["Neon"] = 538.13, ["Neon|Ride"] = 733.46, ["Neon|Fly|Ride"] = 708.75, ["Mega"] = 3616.81, ["Mega|Ride"] = 2191.88, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 8.38, ["Ride"] = 26.17, ["Neon"] = 27.74, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 134.13, ["Mega"] = 139.22, ["Mega|Ride"] = 182.33, ["Mega|Fly|Ride"] = 441.06}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Neon"] = 3.59, ["Neon|Ride"] = 20.4, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 31.85, ["Mega|Ride"] = 133.49, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 6.57, ["Ride"] = 19.81, ["Neon"] = 38.75, ["Neon|Ride"] = 140.42, ["Mega|Ride"] = 548.65, ["Mega|Fly|Ride"] = 454.53}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 12.59, ["Fly"] = 42, ["Ride"] = 26.63, ["Fly|Ride"] = 140.35, ["Neon"] = 74.74, ["Neon|Ride"] = 94.74, ["Neon|Fly|Ride"] = 98.51, ["Mega"] = 250.04, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 342.64}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 48.21, ["Ride"] = 161.37, ["Neon"] = 212.71, ["Neon|Fly|Ride"] = 572.01, ["Mega"] = 941.96, ["Mega|Ride"] = 940.91, ["Mega|Fly|Ride"] = 1047.78}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 131.24, ["Fly"] = 167.42, ["Ride"] = 181.13, ["Fly|Ride"] = 223.54, ["Neon"] = 538.02, ["Neon|Fly"] = 627.63, ["Neon|Ride"] = 473, ["Neon|Fly|Ride"] = 577.5, ["Mega|Fly|Ride"] = 2159.07}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 18.34, ["Fly"] = 23.62, ["Ride"] = 24.83, ["Fly|Ride"] = 49.26, ["Neon"] = 173.91, ["Neon|Fly"] = 1886.83, ["Neon|Ride"] = 104.98, ["Neon|Fly|Ride"] = 110.2, ["Mega|Ride"] = 628.67, ["Mega|Fly|Ride"] = 492.19}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 131.23, ["Ride"] = 31.5, ["Fly|Ride"] = 83.84, ["Neon"] = 14.78, ["Neon|Fly"] = 59.07, ["Neon|Ride"] = 87.84, ["Neon|Fly|Ride"] = 194.91, ["Mega"] = 99.74, ["Mega|Fly"] = 140.42, ["Mega|Ride"] = 181.33, ["Mega|Fly|Ride"] = 349.97}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 12.07, ["Fly"] = 98.51, ["Ride"] = 140.51, ["Neon"] = 117.02, ["Neon|Ride"] = 111.07, ["Mega"] = 1263.52, ["Mega|Ride"] = 417.03, ["Mega|Fly|Ride"] = 622.67}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 41.97, ["Ride"] = 60.45, ["Fly|Ride"] = 137.82, ["Neon"] = 222.14, ["Neon|Ride"] = 245.44, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 851.82, ["Mega|Ride"] = 931.88, ["Mega|Fly|Ride"] = 912.76}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 19.85, ["Ride"] = 82.69, ["Fly|Ride"] = 279.78, ["Neon"] = 158.02, ["Neon|Ride"] = 158.05, ["Mega"] = 577.5, ["Mega|Ride"] = 749.17, ["Mega|Fly|Ride"] = 822.29}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 318.94, ["Ride"] = 360.94, ["Neon"] = 1047.65, ["Neon|Ride"] = 1089.69, ["Neon|Fly|Ride"] = 1047.78, ["Mega"] = 4673.06, ["Mega|Fly|Ride"] = 4673.06}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 32.46, ["Ride"] = 47.17, ["Fly|Ride"] = 94.35, ["Neon"] = 178.5, ["Neon|Ride"] = 289.97, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 992.24, ["Mega|Ride"] = 891.19, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 19.58, ["Ride"] = 15.64, ["Fly|Ride"] = 67.69, ["Neon"] = 2.1, ["Neon|Ride"] = 19.58, ["Neon|Fly|Ride"] = 60.36, ["Mega"] = 30.19, ["Mega|Fly"] = 104.76, ["Mega|Ride"] = 56.59, ["Mega|Fly|Ride"] = 140.42}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 3.94, ["Ride"] = 279.62, ["Neon"] = 15.65, ["Neon|Ride"] = 45.85, ["Neon|Fly|Ride"] = 104.75, ["Mega"] = 157.18, ["Mega|Ride"] = 158.04, ["Mega|Fly|Ride"] = 370.93}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.17, ["Fly|Ride"] = 144.16, ["Neon"] = 13.85, ["Neon|Ride"] = 139.51, ["Neon|Fly|Ride"] = 166.61, ["Mega"] = 105, ["Mega|Fly"] = 544.86, ["Mega|Ride"] = 155.09, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 372.75, ["Fly"] = 629.74, ["Ride"] = 377.98, ["Fly|Ride"] = 437.07, ["Neon"] = 1537.09, ["Neon|Ride"] = 1603.81, ["Neon|Fly|Ride"] = 1556.63, ["Mega|Ride"] = 6150.41, ["Mega|Fly|Ride"] = 5033.44}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 4.2, ["Fly"] = 46.15, ["Ride"] = 18.87, ["Fly|Ride"] = 52.49, ["Neon"] = 19.68, ["Neon|Ride"] = 42.47, ["Neon|Fly|Ride"] = 78.35, ["Mega"] = 126.18, ["Mega|Ride"] = 270.92}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 5.87, ["Fly"] = 22.31, ["Ride"] = 23.05, ["Fly|Ride"] = 39.38, ["Neon"] = 140.42, ["Neon|Fly"] = 157.5, ["Neon|Fly|Ride"] = 139.13, ["Mega|Ride"] = 698.87, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.92, ["Fly"] = 44.71, ["Ride"] = 28.3, ["Fly|Ride"] = 65.63, ["Neon"] = 19.69, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 85.75, ["Mega"] = 112.12, ["Mega|Ride"] = 231.57, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 39.29, ["Fly"] = 140.25, ["Ride"] = 83.84, ["Fly|Ride"] = 61.69, ["Neon"] = 92.99, ["Neon|Fly|Ride"] = 210, ["Mega"] = 940.91, ["Mega|Ride"] = 837.18, ["Mega|Fly|Ride"] = 643.12}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 31.42, ["Ride"] = 39.38, ["Fly|Ride"] = 61.83, ["Neon"] = 17.92, ["Neon|Ride"] = 35.64, ["Mega"] = 140.42, ["Mega|Ride"] = 349.97, ["Mega|Fly|Ride"] = 952.23}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 3.93, ["Fly"] = 104.71, ["Ride"] = 31.44, ["Fly|Ride"] = 70.21, ["Neon"] = 81.13, ["Neon|Ride"] = 140.4, ["Mega|Fly|Ride"] = 732.41}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.04, ["Neon"] = 7.08, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 28.75, ["Mega"] = 37.59, ["Mega|Ride"] = 125.64, ["Mega|Fly|Ride"] = 291.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 15.02, ["Ride"] = 78.75, ["Neon"] = 36.75, ["Neon|Ride"] = 103.18, ["Mega"] = 416.75}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 15.72, ["Ride"] = 28.3, ["Neon"] = 68.61, ["Neon|Ride"] = 102.38, ["Neon|Fly|Ride"] = 176.04, ["Mega"] = 309.1, ["Mega|Ride"] = 559.46, ["Mega|Fly|Ride"] = 492.47}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 11.65, ["Fly"] = 26.17, ["Ride"] = 27.55, ["Fly|Ride"] = 58.69, ["Neon"] = 47.16, ["Neon|Fly"] = 65.54, ["Neon|Ride"] = 43.21, ["Neon|Fly|Ride"] = 121.54, ["Mega"] = 362.24, ["Mega|Ride"] = 375.38, ["Mega|Fly|Ride"] = 393.93}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 193.41, ["Fly"] = 196.88, ["Ride"] = 209.9, ["Fly|Ride"] = 262.5, ["Neon"] = 788.04, ["Neon|Ride"] = 905.63, ["Neon|Fly|Ride"] = 957.68, ["Mega|Fly|Ride"] = 3074.16}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Fly"] = 28.3, ["Ride"] = 18.38, ["Fly|Ride"] = 56.77, ["Neon"] = 14.4, ["Neon|Fly"] = 79.03, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 220.5, ["Mega|Ride"] = 166.61, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 4.46, ["Fly"] = 41.92, ["Ride"] = 17.83, ["Fly|Ride"] = 104.9, ["Neon"] = 26.67, ["Neon|Ride"] = 32.32, ["Neon|Fly|Ride"] = 158.04, ["Mega"] = 277.23, ["Mega|Ride"] = 271.87, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 49.87, ["Ride"] = 140.42, ["Fly|Ride"] = 419.12, ["Neon"] = 140.42, ["Neon|Ride"] = 243.1, ["Neon|Fly|Ride"] = 556.5, ["Mega"] = 616.88, ["Mega|Ride"] = 559.53, ["Mega|Fly|Ride"] = 847.42}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 111.56, ["Fly"] = 279.78, ["Ride"] = 150.94, ["Fly|Ride"] = 262.5, ["Neon"] = 557.43, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 1101.44, ["Mega"] = 2095.55, ["Mega|Ride"] = 1791.57, ["Mega|Fly|Ride"] = 1882.13}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 20.29, ["Ride"] = 92.22, ["Fly|Ride"] = 312.24, ["Neon"] = 94.55, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 627.63, ["Mega"] = 288.75, ["Mega|Ride"] = 377.2, ["Mega|Fly|Ride"] = 458.07}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.26, ["Fly|Ride"] = 47.16, ["Neon"] = 15.65, ["Neon|Fly|Ride"] = 58.97, ["Mega"] = 51.02, ["Mega|Ride"] = 190.71, ["Mega|Fly|Ride"] = 174.57}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 19.92, ["Neon"] = 41.92, ["Neon|Ride"] = 221.72, ["Neon|Fly|Ride"] = 201.94, ["Mega"] = 193.71, ["Mega|Ride"] = 521.73, ["Mega|Fly|Ride"] = 698.87}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 81.17, ["Fly"] = 190.32, ["Ride"] = 118.13, ["Fly|Ride"] = 216.57, ["Neon"] = 209.57, ["Neon|Ride"] = 231.41, ["Neon|Fly|Ride"] = 393.88, ["Mega"] = 732.41, ["Mega|Ride"] = 556.5, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Ride"] = 102.38, ["Neon"] = 7.88, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 141.88, ["Mega"] = 39.38, ["Mega|Fly"] = 161.37, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 15.42, ["Ride"] = 380.91, ["Neon"] = 84, ["Neon|Ride"] = 167.66, ["Mega"] = 378.46, ["Mega|Fly|Ride"] = 797.25}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 977.82, ["Fly"] = 1336.91, ["Ride"] = 958.13, ["Fly|Ride"] = 1060.11, ["Neon"] = 2790.68, ["Neon|Ride"] = 3459.96, ["Neon|Fly|Ride"] = 2559.38, ["Mega|Fly|Ride"] = 10883.17}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 38.55, ["Fly"] = 116.59, ["Ride"] = 629.73, ["Fly|Ride"] = 187.68, ["Neon"] = 196.88, ["Neon|Fly"] = 892.5, ["Neon|Ride"] = 279.78, ["Mega"] = 639.19}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 3.23, ["Fly"] = 49.2, ["Ride"] = 26.46, ["Fly|Ride"] = 80.89, ["Neon"] = 13.85, ["Neon|Ride"] = 37.68, ["Neon|Fly|Ride"] = 113.16, ["Mega"] = 70.21, ["Mega|Ride"] = 104.79, ["Mega|Fly|Ride"] = 224.24}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 87.94, ["Ride"] = 131.22, ["Neon"] = 113.23, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 335.3, ["Mega|Ride"] = 358.24, ["Mega|Fly|Ride"] = 924}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 30.4, ["Fly|Ride"] = 419.12, ["Neon"] = 2.63, ["Neon|Ride"] = 30.61, ["Neon|Fly|Ride"] = 89.14, ["Mega"] = 23.61, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 557.43}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 90.29, ["Ride"] = 397.69, ["Fly|Ride"] = 255.94, ["Neon"] = 321.68, ["Neon|Ride"] = 393.75, ["Mega"] = 1100.15, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1442.44}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 7.34, ["Fly"] = 174.57, ["Ride"] = 52.41, ["Fly|Ride"] = 47.24, ["Neon"] = 39.38, ["Neon|Ride"] = 47.19, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 414.93, ["Mega|Ride"] = 251.48, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.57, ["Ride"] = 26.25, ["Neon"] = 15.42, ["Neon|Ride"] = 91.18, ["Mega"] = 158.04, ["Mega|Ride"] = 258.03, ["Mega|Fly|Ride"] = 335.3}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 65.6, ["Ride"] = 82.68, ["Fly|Ride"] = 196.88, ["Neon"] = 186.38, ["Neon|Fly"] = 278.72, ["Neon|Ride"] = 182.44, ["Neon|Fly|Ride"] = 409.22, ["Mega"] = 489.33, ["Mega|Ride"] = 698.87, ["Mega|Fly|Ride"] = 583.22}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 15.73, ["Ride"] = 91.87, ["Fly|Ride"] = 209.57, ["Neon"] = 131.25, ["Neon|Ride"] = 158.23, ["Mega"] = 976.54, ["Mega|Fly|Ride"] = 698.87}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 54.57, ["Neon"] = 335.3, ["Neon|Ride"] = 629.74, ["Neon|Fly|Ride"] = 1313.18, ["Mega"] = 1230.09, ["Mega|Ride"] = 2358.54, ["Mega|Fly|Ride"] = 1579.03}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 6.18, ["Ride"] = 62.98, ["Neon"] = 27.15, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 126.99, ["Mega|Ride"] = 171.94, ["Mega|Fly|Ride"] = 263.82}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 5.75, ["Fly"] = 32.15, ["Ride"] = 20.13, ["Fly|Ride"] = 52.5, ["Neon"] = 46.1, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 125.34, ["Mega"] = 399, ["Mega|Ride"] = 391.88, ["Mega|Fly|Ride"] = 456.39}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 124.67, ["Ride"] = 210, ["Fly|Ride"] = 246.75, ["Neon"] = 440.5, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 2335.15, ["Mega|Fly|Ride"] = 1989.41}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 31.16, ["Ride"] = 16.36, ["Fly|Ride"] = 43.05, ["Neon"] = 9.18, ["Neon|Fly"] = 64.31, ["Neon|Ride"] = 28.23, ["Neon|Fly|Ride"] = 59.99, ["Mega"] = 116.75, ["Mega|Ride"] = 140.31, ["Mega|Fly|Ride"] = 214.65}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 7.86, ["Fly"] = 35.64, ["Ride"] = 30.05, ["Fly|Ride"] = 65.63, ["Neon"] = 45.82, ["Neon|Fly"] = 158.04, ["Neon|Ride"] = 63.08, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 235.76, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 326.55}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.73, ["Fly|Ride"] = 39.05, ["Neon"] = 2.58, ["Neon|Fly"] = 24.78, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 41.58, ["Mega"] = 19.69, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 80.07}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 54.46, ["Neon"] = 3.93, ["Neon|Ride"] = 39.83, ["Mega"] = 21.17, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 139.64}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.61, ["Fly"] = 131.25, ["Ride"] = 27.26, ["Fly|Ride"] = 45.94, ["Neon"] = 37.29, ["Neon|Ride"] = 37.73, ["Mega"] = 91.88}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 40.65, ["Ride"] = 84, ["Neon"] = 522.38, ["Neon|Ride"] = 371.97, ["Neon|Fly|Ride"] = 630, ["Mega"] = 779.62}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 3.28, ["Fly"] = 17.07, ["Ride"] = 16.7, ["Fly|Ride"] = 36.69, ["Neon"] = 14.15, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 24.91, ["Neon|Fly|Ride"] = 66.92, ["Mega"] = 102.52, ["Mega|Fly"] = 170.6, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 3.45, ["Fly"] = 28.3, ["Ride"] = 27.14, ["Fly|Ride"] = 69.17, ["Neon"] = 11.9, ["Neon|Fly"] = 36.61, ["Neon|Ride"] = 29.93, ["Neon|Fly|Ride"] = 70.21, ["Mega"] = 150.94, ["Mega|Fly"] = 305.96, ["Mega|Ride"] = 134.5, ["Mega|Fly|Ride"] = 191.57}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 18.8, ["Ride"] = 18.06, ["Fly|Ride"] = 115.5, ["Neon"] = 9.07, ["Neon|Fly"] = 98.44, ["Neon|Ride"] = 28.3, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 56.59, ["Mega|Fly"] = 158.04, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 208.69}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 11.44, ["Fly"] = 131.25, ["Ride"] = 26.16, ["Neon"] = 38.48, ["Neon|Ride"] = 59.04, ["Neon|Fly|Ride"] = 268.82, ["Mega"] = 207.81, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 207.4, ["Mega|Fly|Ride"] = 381.4}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 35.44, ["Fly"] = 162.35, ["Ride"] = 66.03, ["Neon"] = 74.84, ["Neon|Ride"] = 131.15, ["Neon|Fly|Ride"] = 279.78, ["Mega"] = 419.12, ["Mega|Ride"] = 419.12, ["Mega|Fly|Ride"] = 1047.78}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 6.55, ["Fly"] = 48.57, ["Ride"] = 20.9, ["Fly|Ride"] = 63, ["Neon"] = 27.46, ["Neon|Fly"] = 196.66, ["Neon|Ride"] = 38.74, ["Neon|Fly|Ride"] = 105, ["Mega"] = 314.88, ["Mega|Ride"] = 188.89, ["Mega|Fly|Ride"] = 403.33}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 20.88, ["Ride"] = 18.36, ["Fly|Ride"] = 52.49, ["Neon"] = 11.54, ["Neon|Fly"] = 66.95, ["Neon|Ride"] = 20.74, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 353.75, ["Mega|Ride"] = 234.69, ["Mega|Fly|Ride"] = 203.41}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 188.2, ["Fly"] = 393.75, ["Ride"] = 224.18, ["Fly|Ride"] = 365.59, ["Neon"] = 978.63, ["Neon|Ride"] = 698.87, ["Neon|Fly|Ride"] = 1179.94, ["Mega"] = 3937.5, ["Mega|Ride"] = 3494.32, ["Mega|Fly|Ride"] = 3773.65}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 6.24, ["Ride"] = 39.12, ["Neon"] = 14.44, ["Neon|Fly|Ride"] = 279.78, ["Mega"] = 116.94, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.23, ["Ride"] = 19.69, ["Fly|Ride"] = 56.31, ["Neon"] = 22.65, ["Neon|Fly"] = 209.57, ["Neon|Ride"] = 36.02, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 187.11, ["Mega|Ride"] = 266.14, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 6.53, ["Ride"] = 24.94, ["Neon"] = 50.31, ["Neon|Ride"] = 213.44, ["Neon|Fly|Ride"] = 628.67, ["Mega"] = 461.77, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 429.85}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 15.73, ["Fly|Ride"] = 30.15, ["Neon"] = 2.62, ["Neon|Fly"] = 20.89, ["Neon|Ride"] = 15.73, ["Neon|Fly|Ride"] = 41.97, ["Mega"] = 18.38, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 59.73, ["Mega|Fly|Ride"] = 78.6}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 5.01, ["Fly"] = 56.37, ["Ride"] = 26.04, ["Fly|Ride"] = 59.06, ["Neon"] = 18.79, ["Neon|Fly"] = 21, ["Neon|Ride"] = 31.06, ["Neon|Fly|Ride"] = 58.69, ["Mega"] = 157.49, ["Mega|Ride"] = 143.06, ["Mega|Fly|Ride"] = 224.44}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.63, ["Ride"] = 56.59, ["Neon"] = 15.48, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 52.41, ["Mega|Ride"] = 187.69, ["Mega|Fly|Ride"] = 287.11}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 70.87, ["Fly"] = 105, ["Ride"] = 95.81, ["Fly|Ride"] = 91.88, ["Neon"] = 520.07, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 414.05, ["Mega|Ride"] = 3494.32, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.93, ["Fly"] = 85.32, ["Ride"] = 33.54, ["Fly|Ride"] = 65.63, ["Neon"] = 26.25, ["Neon|Ride"] = 55.2, ["Neon|Fly|Ride"] = 112.12, ["Mega"] = 209.41, ["Mega|Ride"] = 259.86, ["Mega|Fly|Ride"] = 471.72}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 31.45, ["Ride"] = 45.04, ["Fly|Ride"] = 118.13, ["Neon"] = 11.8, ["Neon|Ride"] = 125.74, ["Neon|Fly|Ride"] = 167.66, ["Mega"] = 45.94, ["Mega|Fly"] = 313.69, ["Mega|Ride"] = 103.74, ["Mega|Fly|Ride"] = 209.57}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 61.97, ["Fly"] = 210, ["Ride"] = 94.5, ["Fly|Ride"] = 190.32, ["Neon"] = 157.5, ["Neon|Ride"] = 189.52, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 559.53, ["Mega|Ride"] = 549.55, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 15.73, ["Ride"] = 15.1, ["Fly|Ride"] = 26.25, ["Neon"] = 2.63, ["Neon|Fly"] = 19.92, ["Neon|Ride"] = 15.73, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 27.26, ["Mega|Fly"] = 41.95, ["Mega|Ride"] = 146.71, ["Mega|Fly|Ride"] = 81.38}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 4.16, ["Neon|Ride"] = 60.38, ["Neon|Fly|Ride"] = 76.37, ["Mega"] = 40.88, ["Mega|Ride"] = 70.22, ["Mega|Fly|Ride"] = 198.35}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.61, ["Ride"] = 107.63, ["Fly|Ride"] = 137.82, ["Neon"] = 11.32, ["Neon|Ride"] = 90.96, ["Neon|Fly|Ride"] = 187.57, ["Mega"] = 77.94}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 7.39, ["Fly"] = 98.51, ["Ride"] = 140.42, ["Fly|Ride"] = 137.63, ["Neon"] = 25.16, ["Neon|Fly"] = 136.5, ["Neon|Ride"] = 93.7, ["Neon|Fly|Ride"] = 196.86, ["Mega"] = 108.94, ["Mega|Fly"] = 183.75, ["Mega|Ride"] = 133.88, ["Mega|Fly|Ride"] = 338.45}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.73, ["Ride"] = 15.65, ["Fly|Ride"] = 28.88, ["Neon"] = 2.1, ["Neon|Fly"] = 22.43, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 41.92, ["Mega"] = 24.86, ["Mega|Ride"] = 31.49, ["Mega|Fly|Ride"] = 134.13}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 12.53, ["Fly"] = 262.5, ["Ride"] = 44.02, ["Neon"] = 114.6, ["Neon|Fly|Ride"] = 219.85, ["Mega"] = 486.19, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 670.5}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2624.99, ["Fly"] = 3150, ["Ride"] = 2738.74, ["Fly|Ride"] = 2622.9, ["Neon|Ride"] = 9779.88, ["Neon|Fly|Ride"] = 9318.75, ["Mega|Fly|Ride"] = 43482.35}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 23.97, ["Ride"] = 17.05, ["Fly|Ride"] = 45.93, ["Neon"] = 9.75, ["Neon|Fly"] = 69.17, ["Neon|Ride"] = 20.97, ["Neon|Fly|Ride"] = 66.92, ["Mega"] = 57.75, ["Mega|Fly"] = 467.33, ["Mega|Ride"] = 108.94, ["Mega|Fly|Ride"] = 180.34}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Neon"] = 19.92, ["Mega"] = 126, ["Mega|Fly"] = 179.82, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 628.67}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 18.48, ["Ride"] = 31.5, ["Fly|Ride"] = 122.27, ["Neon"] = 94.5, ["Neon|Ride"] = 279.78, ["Neon|Fly|Ride"] = 216.09, ["Mega"] = 311.72, ["Mega|Ride"] = 383.24, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 39.35, ["Ride"] = 98.43, ["Neon"] = 155.04, ["Neon|Ride"] = 279.74, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 540.75, ["Mega|Ride"] = 518.65, ["Mega|Fly|Ride"] = 818.42}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 131.25, ["Fly"] = 1397.74, ["Ride"] = 188.99, ["Fly|Ride"] = 272.44, ["Neon"] = 1312.5, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 732.41, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 6286.62, ["Mega|Fly|Ride"] = 2514.75}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 7.61, ["Fly"] = 26.25, ["Ride"] = 52.5, ["Fly|Ride"] = 675.94, ["Neon"] = 52.5, ["Neon|Ride"] = 120.59, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 224.24, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 582.75}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 62.89, ["Neon"] = 14.1, ["Neon|Fly"] = 98.44, ["Neon|Fly|Ride"] = 523.89, ["Mega"] = 136.5, ["Mega|Ride"] = 262.29, ["Mega|Fly|Ride"] = 838.47}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.63, ["Fly"] = 101.97, ["Ride"] = 40.16, ["Fly|Ride"] = 131.25, ["Neon"] = 11.8, ["Neon|Ride"] = 42, ["Mega"] = 97.28, ["Mega|Ride"] = 126.76, ["Mega|Fly|Ride"] = 279.78}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 16.78, ["Ride"] = 98.44, ["Fly|Ride"] = 656.25, ["Neon"] = 162.42, ["Neon|Ride"] = 1165.81, ["Neon|Fly|Ride"] = 293.4, ["Mega"] = 374.06, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 685.79}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 70.22, ["Neon"] = 2.63, ["Neon|Ride"] = 24.92, ["Mega"] = 16.86, ["Mega|Ride"] = 133.88, ["Mega|Fly|Ride"] = 419.12}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 82.69, ["Fly"] = 209.57, ["Ride"] = 78.73, ["Fly|Ride"] = 143.06, ["Neon"] = 559.44, ["Neon|Fly"] = 502.94, ["Neon|Ride"] = 410.74, ["Neon|Fly|Ride"] = 520.07, ["Mega"] = 1365, ["Mega|Fly|Ride"] = 1668.07}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 6.42, ["Neon|Ride"] = 137.67, ["Mega"] = 52.5, ["Mega|Ride"] = 141.1}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 45.93, ["Fly"] = 220.54, ["Ride"] = 69.33, ["Fly|Ride"] = 140.42, ["Neon"] = 283, ["Neon|Ride"] = 275.52, ["Neon|Fly|Ride"] = 437.06, ["Mega"] = 2625, ["Mega|Ride"] = 1571.67, ["Mega|Fly|Ride"] = 1311.19}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 24.05, ["Fly|Ride"] = 69.72, ["Neon"] = 5.22, ["Neon|Fly"] = 120.5, ["Neon|Ride"] = 41.92, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 52.49, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 115.39}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 7.88, ["Neon|Ride"] = 118.13, ["Mega"] = 86.34, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 13.11, ["Fly|Ride"] = 208.52, ["Neon"] = 52.5, ["Neon|Ride"] = 314.88, ["Mega"] = 229.69, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 367.94, ["Fly"] = 559.53, ["Ride"] = 420, ["Fly|Ride"] = 522.38, ["Neon"] = 1279.69, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1311.33, ["Mega"] = 4145.64, ["Mega|Ride"] = 4580.85, ["Mega|Fly|Ride"] = 4289.24}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 36.74, ["Ride"] = 51.19, ["Fly|Ride"] = 87.03, ["Neon"] = 177.19, ["Neon|Fly"] = 314.88, ["Neon|Ride"] = 170.27, ["Neon|Fly|Ride"] = 295.32, ["Mega|Ride"] = 831.94, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 28.2, ["Ride"] = 16.95, ["Fly|Ride"] = 91.88, ["Neon"] = 7.09, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 20.97, ["Neon|Fly|Ride"] = 70.22, ["Mega"] = 59.07, ["Mega|Ride"] = 83.79, ["Mega|Fly|Ride"] = 629.74}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 18.37, ["Fly"] = 364.62, ["Ride"] = 38.97, ["Fly|Ride"] = 140.44, ["Neon"] = 53.49, ["Neon|Fly"] = 188.14, ["Neon|Ride"] = 125.74, ["Neon|Fly|Ride"] = 163.62, ["Mega"] = 216.57, ["Mega|Fly"] = 388.16, ["Mega|Ride"] = 266.14, ["Mega|Fly|Ride"] = 560.43}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 8.63, ["Ride"] = 22.64, ["Fly|Ride"] = 265.13, ["Neon"] = 123.48, ["Neon|Ride"] = 59.07, ["Mega|Ride"] = 446.36, ["Mega|Fly|Ride"] = 471.52}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.94, ["Neon"] = 15.18, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 59.05, ["Mega|Ride"] = 150.22, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 86.62, ["Ride"] = 22.32, ["Fly|Ride"] = 51.91, ["Neon"] = 26.25, ["Neon|Ride"] = 32.79, ["Neon|Fly|Ride"] = 210.08, ["Mega"] = 550.73, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 489.33}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 118.11, ["Ride"] = 129.94, ["Fly|Ride"] = 175.87, ["Neon"] = 628.67, ["Neon|Ride"] = 615.56, ["Neon|Fly|Ride"] = 853.12, ["Mega|Ride"] = 2933.77, ["Mega|Fly|Ride"] = 3490.13}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 26.24, ["Fly"] = 95.82, ["Ride"] = 104.78, ["Fly|Ride"] = 157.97, ["Neon"] = 192.94, ["Neon|Ride"] = 192.13, ["Mega"] = 837.18, ["Mega|Ride"] = 786.19, ["Mega|Fly|Ride"] = 778.59}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2152.49, ["Fly"] = 2349.37, ["Ride"] = 2231.25, ["Fly|Ride"] = 2362.47, ["Neon"] = 12573.22, ["Neon|Fly|Ride"] = 7743.75, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.78, ["Fly"] = 65625, ["Ride"] = 41.92, ["Fly|Ride"] = 170.63, ["Neon"] = 13.21, ["Neon|Ride"] = 109.48, ["Neon|Fly|Ride"] = 167.66, ["Mega"] = 103.74, ["Mega|Ride"] = 167.35, ["Mega|Fly|Ride"] = 419.12}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 39.83, ["Ride"] = 89.25, ["Neon"] = 45.06, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 253.32, ["Mega"] = 275.63, ["Mega|Ride"] = 291.38, ["Mega|Fly|Ride"] = 559.53}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 862.68, ["Fly"] = 1453.27, ["Ride"] = 853.12, ["Fly|Ride"] = 1000.02, ["Neon"] = 2445.65, ["Neon|Ride"] = 3145.1, ["Neon|Fly|Ride"] = 2426.55, ["Mega|Fly|Ride"] = 11315.91}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 36.74, ["Ride"] = 61.81, ["Neon"] = 237.59, ["Neon|Ride"] = 279.72, ["Mega"] = 786.35, ["Mega|Ride"] = 616.88, ["Mega|Fly|Ride"] = 717.94}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.94, ["Ride"] = 22.91, ["Neon"] = 15.73, ["Neon|Ride"] = 140.42, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 182.33, ["Mega|Ride"] = 188.61, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 111.45, ["Ride"] = 19.69, ["Neon"] = 7.08, ["Neon|Ride"] = 23.63, ["Mega"] = 31.45, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 248.07}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 82.68, ["Ride"] = 126, ["Fly|Ride"] = 314.88, ["Neon"] = 459.38, ["Neon|Fly|Ride"] = 545.74, ["Mega"] = 2235.95, ["Mega|Fly|Ride"] = 2673.4}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 6.55, ["Neon"] = 35.64, ["Neon|Ride"] = 81.86, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 157.18, ["Mega|Ride"] = 146.71, ["Mega|Fly|Ride"] = 345.78}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 76.13, ["Ride"] = 97.62, ["Neon"] = 341.25, ["Neon|Ride"] = 315.28, ["Mega|Fly|Ride"] = 1676.24}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 3.94, ["Fly"] = 104.98, ["Neon"] = 33.16, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 136.23}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 249.36, ["Fly"] = 300.72, ["Ride"] = 283.77, ["Fly|Ride"] = 344.08, ["Neon"] = 1101.44, ["Neon|Ride"] = 1035.21, ["Neon|Fly|Ride"] = 766.64, ["Mega|Fly|Ride"] = 4155.46}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 4.73, ["Fly"] = 87.3, ["Ride"] = 27.26, ["Fly|Ride"] = 54.5, ["Neon"] = 31.5, ["Neon|Ride"] = 64.16, ["Neon|Fly|Ride"] = 104.99, ["Mega"] = 306.62, ["Mega|Ride"] = 261.95, ["Mega|Fly|Ride"] = 698.87}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 17.69, ["Ride"] = 17.7, ["Fly|Ride"] = 37.73, ["Neon"] = 6.56, ["Neon|Fly"] = 19.92, ["Neon|Ride"] = 28.3, ["Neon|Fly|Ride"] = 42.37, ["Mega"] = 62.45, ["Mega|Fly"] = 120.5, ["Mega|Ride"] = 60.36, ["Mega|Fly|Ride"] = 139.97}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 840, ["Fly"] = 1047.78, ["Ride"] = 903, ["Neon|Ride"] = 7684.34, ["Neon|Fly|Ride"] = 4743.38, ["Mega"] = 26544.14, ["Mega|Fly|Ride"] = 18859.82}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 4.73, ["Fly"] = 978.63, ["Ride"] = 210, ["Neon"] = 40.25, ["Neon|Ride"] = 69.84, ["Mega"] = 179.54, ["Mega|Ride"] = 267.71, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 10.49, ["Fly"] = 70.22, ["Ride"] = 35.64, ["Fly|Ride"] = 125.74, ["Neon"] = 35.44, ["Neon|Fly"] = 77.68, ["Neon|Ride"] = 59.03, ["Neon|Fly|Ride"] = 132.23, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 35.42, ["Fly"] = 44.61, ["Ride"] = 39.38, ["Fly|Ride"] = 75.45, ["Neon"] = 233.67, ["Neon|Ride"] = 157.49, ["Neon|Fly|Ride"] = 170.61, ["Mega"] = 2095.55, ["Mega|Fly|Ride"] = 861}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 16.2, ["Fly"] = 72.19, ["Ride"] = 28.43, ["Fly|Ride"] = 85.31, ["Neon"] = 58.61, ["Neon|Ride"] = 99.07, ["Neon|Fly|Ride"] = 176.17, ["Mega"] = 364.88, ["Mega|Fly"] = 315, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 448.46}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 23.61, ["Ride"] = 262.5, ["Fly|Ride"] = 70.22, ["Neon"] = 86.63, ["Neon|Ride"] = 183.1, ["Neon|Fly|Ride"] = 456.39, ["Mega"] = 486.19, ["Mega|Ride"] = 531.24, ["Mega|Fly|Ride"] = 685.26}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.59, ["Fly|Ride"] = 235.87, ["Neon"] = 2.62, ["Neon|Ride"] = 28.13, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 19.32, ["Mega|Fly"] = 84.92, ["Mega|Ride"] = 41.62, ["Mega|Fly|Ride"] = 85.53}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 26.25, ["Fly"] = 75.46, ["Ride"] = 48.56, ["Fly|Ride"] = 104.98, ["Neon"] = 258.44, ["Neon|Fly"] = 283.03, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 250.83, ["Mega"] = 3352.88, ["Mega|Fly|Ride"] = 1014.75}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 3.76, ["Fly"] = 27.26, ["Ride"] = 28.3, ["Fly|Ride"] = 70.88, ["Neon"] = 31.4, ["Neon|Ride"] = 140.42, ["Mega"] = 773.07, ["Mega|Ride"] = 279.78, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 28.03, ["Ride"] = 20.86, ["Fly|Ride"] = 50.72, ["Neon"] = 26.25, ["Neon|Ride"] = 49, ["Neon|Fly|Ride"] = 131.24, ["Mega|Ride"] = 263.23, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 7.88, ["Ride"] = 103.69, ["Neon"] = 104.9, ["Neon|Fly"] = 13.13, ["Neon|Ride"] = 838.23, ["Neon|Fly|Ride"] = 184.33, ["Mega"] = 293.4, ["Mega|Fly|Ride"] = 471.72}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 20.98, ["Fly"] = 262.39, ["Ride"] = 71.3, ["Fly|Ride"] = 262.5, ["Neon"] = 124.68, ["Neon|Fly"] = 309.1, ["Neon|Ride"] = 188.69, ["Neon|Fly|Ride"] = 259.86, ["Mega"] = 723.39, ["Mega|Ride"] = 771.25, ["Mega|Fly|Ride"] = 661.5}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 7.12, ["Ride"] = 131.25, ["Neon"] = 25.54, ["Neon|Ride"] = 72.96, ["Neon|Fly|Ride"] = 112.12, ["Mega"] = 81.75, ["Mega|Fly"] = 698.87, ["Mega|Ride"] = 112.12, ["Mega|Fly|Ride"] = 314.88}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 27.85, ["Neon"] = 2.6, ["Neon|Ride"] = 41.92, ["Mega"] = 21, ["Mega|Ride"] = 47.16, ["Mega|Fly|Ride"] = 131.15}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 70.22, ["Ride"] = 15.73, ["Fly|Ride"] = 81.99, ["Neon"] = 2.62, ["Neon|Fly"] = 393.65, ["Neon|Ride"] = 31.45, ["Mega"] = 24.68, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 106.32}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 25.9, ["Ride"] = 24.08, ["Fly|Ride"] = 51.14, ["Neon"] = 9.44, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 52.4, ["Mega"] = 92.19, ["Mega|Ride"] = 419.12, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 27.74, ["Fly|Ride"] = 5306.68, ["Neon"] = 11.36, ["Neon|Ride"] = 1312.5, ["Mega"] = 98.44, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 209.57}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 17.05, ["Fly|Ride"] = 41.85, ["Neon"] = 13.81, ["Neon|Fly"] = 52.4, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 77.17, ["Mega"] = 283.03, ["Mega|Ride"] = 276.29, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 103.95, ["Ride"] = 204.33, ["Fly|Ride"] = 419.12, ["Neon"] = 245.19, ["Neon|Ride"] = 298.91, ["Neon|Fly|Ride"] = 1047.78, ["Mega"] = 838.23, ["Mega|Ride"] = 823.14, ["Mega|Fly|Ride"] = 1110.64}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 18.87, ["Fly|Ride"] = 39.83, ["Neon"] = 2.63, ["Neon|Fly"] = 20.93, ["Neon|Ride"] = 20.97, ["Neon|Fly|Ride"] = 46.16, ["Mega"] = 27.46, ["Mega|Ride"] = 58.69, ["Mega|Fly|Ride"] = 93.52}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 8.4, ["Fly"] = 62.88, ["Ride"] = 22.71, ["Fly|Ride"] = 72.1, ["Neon"] = 46.77, ["Neon|Fly"] = 91.71, ["Neon|Ride"] = 62.69, ["Neon|Fly|Ride"] = 98.49, ["Mega"] = 838.23, ["Mega|Ride"] = 239.09, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 15.7, ["Fly"] = 38.85, ["Ride"] = 25.1, ["Fly|Ride"] = 104.79, ["Neon"] = 82.94, ["Neon|Fly"] = 139.63, ["Neon|Ride"] = 56.57, ["Neon|Fly|Ride"] = 156.84, ["Mega"] = 1257.33, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 440.33}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.67, ["Fly"] = 140.42, ["Ride"] = 47.19, ["Neon"] = 32.82, ["Neon|Ride"] = 70.22, ["Mega"] = 131.25, ["Mega|Ride"] = 183.75}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 17.7, ["Ride"] = 17.7, ["Fly|Ride"] = 39.83, ["Neon"] = 3.75, ["Neon|Fly"] = 40.88, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 46.4, ["Mega|Fly"] = 105, ["Mega|Ride"] = 61.69, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.82, ["Fly"] = 70.17, ["Ride"] = 27.19, ["Neon"] = 14.16, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 96.52, ["Mega"] = 126, ["Mega|Fly"] = 735, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 278.73}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 969.91, ["Fly"] = 1230.09, ["Ride"] = 918.75, ["Fly|Ride"] = 1018.5, ["Neon"] = 2296.88, ["Neon|Ride"] = 2618.39, ["Neon|Fly|Ride"] = 2017.15, ["Mega|Fly|Ride"] = 6561.19}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 68.45, ["Fly"] = 158.04, ["Ride"] = 112.63, ["Fly|Ride"] = 196.88, ["Neon"] = 315, ["Neon|Ride"] = 349.97, ["Neon|Fly|Ride"] = 494.82, ["Mega"] = 1672.26, ["Mega|Ride"] = 1662.83, ["Mega|Fly|Ride"] = 1326.94}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Ride"] = 68.39, ["Neon"] = 7.88, ["Neon|Ride"] = 70.22, ["Neon|Fly|Ride"] = 209.57, ["Mega"] = 65.54, ["Mega|Ride"] = 95.27, ["Mega|Fly|Ride"] = 182.33}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 44.66, ["Ride"] = 78.75, ["Fly|Ride"] = 157.5, ["Neon"] = 203.28, ["Neon|Ride"] = 226.22, ["Neon|Fly|Ride"] = 308.44, ["Mega"] = 1023.75, ["Mega|Ride"] = 923.09, ["Mega|Fly|Ride"] = 836.07}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 5.25, ["Ride"] = 64.61, ["Fly|Ride"] = 65.63, ["Neon"] = 61.83, ["Neon|Ride"] = 279.78, ["Neon|Fly|Ride"] = 278.73, ["Mega"] = 274.32, ["Mega|Ride"] = 314.88, ["Mega|Fly|Ride"] = 473.61}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 249.38, ["Fly"] = 419.12, ["Ride"] = 262.49, ["Fly|Ride"] = 308.99, ["Neon"] = 882.37, ["Neon|Ride"] = 1112.74, ["Neon|Fly|Ride"] = 944.99, ["Mega|Fly|Ride"] = 4568.28}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 88.88, ["Ride"] = 22.32, ["Fly|Ride"] = 131.25, ["Neon"] = 19.69, ["Neon|Ride"] = 54, ["Mega"] = 401.31, ["Mega|Fly"] = 279.78, ["Mega|Ride"] = 86.99}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 19.69, ["Neon|Ride"] = 83.84, ["Mega"] = 335.3, ["Mega|Ride"] = 333.21}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 60.37, ["Ride"] = 102.38, ["Fly|Ride"] = 279.78, ["Neon"] = 354.38, ["Neon|Ride"] = 182.33, ["Mega"] = 590.63, ["Mega|Ride"] = 557.43, ["Mega|Fly|Ride"] = 796.32}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 48.54, ["Fly|Ride"] = 77.56, ["Neon"] = 13.58, ["Neon|Ride"] = 35.64, ["Mega"] = 279.78, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 131.15}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 16.78, ["Ride"] = 15.63, ["Fly|Ride"] = 32.81, ["Neon"] = 2.1, ["Neon|Fly"] = 31.29, ["Neon|Ride"] = 38.05, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 41.92, ["Mega|Fly"] = 70.22, ["Mega|Ride"] = 39.37, ["Mega|Fly|Ride"] = 96.33}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4329.94, ["Ride"] = 4331.25, ["Fly|Ride"] = 4349.63, ["Neon"] = 27940.82, ["Neon|Fly|Ride"] = 22013.27, ["Mega|Fly|Ride"] = 62866.04}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 12.58, ["Ride"] = 56.43, ["Neon"] = 107.63, ["Neon|Ride"] = 106.32, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 17.71, ["Ride"] = 20.79, ["Fly|Ride"] = 60.38, ["Neon"] = 12.98, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 229.53, ["Mega|Ride"] = 127.2, ["Mega|Fly|Ride"] = 251.48}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 393.75, ["Fly"] = 527.63, ["Ride"] = 511.88, ["Fly|Ride"] = 531.57, ["Neon"] = 1365, ["Neon|Ride"] = 1383.06, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 5238.84}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 4.82, ["Ride"] = 28.3, ["Neon"] = 15.73, ["Neon|Ride"] = 145.68, ["Mega"] = 127.34, ["Mega|Fly|Ride"] = 338.46}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 5.25, ["Fly"] = 4106.08, ["Ride"] = 35.44, ["Neon"] = 19.92, ["Neon|Ride"] = 279.78, ["Neon|Fly|Ride"] = 279.78, ["Mega"] = 415.42, ["Mega|Ride"] = 401.63}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.33, ["Ride"] = 18.38, ["Fly|Ride"] = 82.56, ["Neon"] = 5.83, ["Neon|Fly"] = 124.68, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 38.84, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 181.13}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 669.38, ["Fly"] = 824.61, ["Ride"] = 564.38, ["Fly|Ride"] = 630, ["Neon"] = 2100, ["Neon|Fly|Ride"] = 1968.75}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 3.94, ["Ride"] = 63.78, ["Fly|Ride"] = 85.32, ["Neon"] = 22.89, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 140.34, ["Mega"] = 118.02, ["Mega|Ride"] = 170.43, ["Mega|Fly|Ride"] = 349.97}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 13.13, ["Fly"] = 236.04, ["Ride"] = 106.25, ["Neon"] = 79.65, ["Neon|Ride"] = 101.54, ["Neon|Fly|Ride"] = 151.59, ["Mega"] = 362.06}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 14.44, ["Ride"] = 23.61, ["Fly|Ride"] = 47.25, ["Neon"] = 8.3, ["Neon|Fly"] = 46.11, ["Neon|Ride"] = 27.45, ["Neon|Fly|Ride"] = 83.84, ["Mega"] = 182.02, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 208.69}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 20.96, ["Ride"] = 92.4, ["Neon"] = 103.69, ["Neon|Fly"] = 170.63, ["Neon|Fly|Ride"] = 314.88, ["Mega"] = 518.65, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 3.94, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 30.1, ["Mega|Ride"] = 87.28, ["Mega|Fly|Ride"] = 250.4}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 382.04, ["Ride"] = 456.88, ["Fly|Ride"] = 550.73, ["Neon"] = 2589.57, ["Neon|Ride"] = 2417.22, ["Neon|Fly|Ride"] = 1793.39, ["Mega"] = 7705.29, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 53.82, ["Fly|Ride"] = 331.1, ["Neon"] = 13.13, ["Neon|Ride"] = 92, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 72.19, ["Mega|Ride"] = 160.13, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 52.49, ["Neon"] = 5.25, ["Neon|Fly"] = 140.42, ["Neon|Ride"] = 211.98, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 39.38, ["Mega|Fly"] = 98.51, ["Mega|Ride"] = 98.51, ["Mega|Fly|Ride"] = 209.57}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 21.58, ["Neon"] = 4.43, ["Neon|Ride"] = 41.3, ["Neon|Fly|Ride"] = 140.42, ["Mega"] = 47.19, ["Mega|Fly"] = 155.09, ["Mega|Ride"] = 72.19}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 3.83, ["Ride"] = 131.25, ["Neon"] = 18.5, ["Neon|Ride"] = 47.19, ["Mega"] = 229.47, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 98.43, ["Ride"] = 155.09, ["Fly|Ride"] = 498.73, ["Neon"] = 279.78, ["Neon|Ride"] = 363.59, ["Neon|Fly|Ride"] = 2358.54, ["Mega"] = 1595.55, ["Mega|Ride"] = 1529.76, ["Mega|Fly|Ride"] = 1299.38}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 24.11, ["Fly"] = 69.24, ["Ride"] = 72.11, ["Fly|Ride"] = 125.74, ["Neon"] = 100.96, ["Neon|Ride"] = 139.36, ["Neon|Fly|Ride"] = 142.14, ["Mega"] = 463.31, ["Mega|Ride"] = 385.88, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 3.81, ["Fly"] = 31.5, ["Ride"] = 16.77, ["Fly|Ride"] = 41.92, ["Neon"] = 32.62, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 77.43, ["Mega"] = 155.09, ["Mega|Ride"] = 257.76, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 10.44, ["Ride"] = 64.31, ["Fly|Ride"] = 99.56, ["Neon"] = 279.78, ["Neon|Fly|Ride"] = 235.87, ["Mega"] = 331.1, ["Mega|Ride"] = 224.24, ["Mega|Fly|Ride"] = 978.63}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 6.3, ["Fly"] = 179.03, ["Ride"] = 36.69, ["Fly|Ride"] = 78.6, ["Neon"] = 52.5, ["Neon|Ride"] = 188.61, ["Mega"] = 391.53, ["Mega|Ride"] = 419.12, ["Mega|Fly|Ride"] = 501.89}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 19.45, ["Fly"] = 69.17, ["Ride"] = 28.3, ["Fly|Ride"] = 56.24, ["Neon"] = 228.74, ["Neon|Ride"] = 209.92, ["Neon|Fly|Ride"] = 246.24, ["Mega"] = 941.96, ["Mega|Ride"] = 943.43, ["Mega|Fly|Ride"] = 769.08}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["Fly"] = 874.13, ["Neon"] = 141.52, ["Neon|Ride"] = 279.78, ["Mega|Ride"] = 590.63}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 47.16, ["Fly"] = 115.5, ["Ride"] = 91.88, ["Fly|Ride"] = 131.25, ["Neon"] = 262.23, ["Neon|Fly"] = 349.97, ["Neon|Ride"] = 299.25, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 1320.2, ["Mega|Ride"] = 1337.21, ["Mega|Fly|Ride"] = 997.5}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 51.85, ["Fly"] = 92.78, ["Ride"] = 115.5, ["Neon"] = 156.06, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 408.19, ["Mega"] = 559.53, ["Mega|Ride"] = 670.59, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 27.57, ["Ride"] = 68.25, ["Neon"] = 135.19, ["Mega"] = 628.67, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 5.23, ["Fly"] = 32.34, ["Ride"] = 39.31, ["Fly|Ride"] = 102.03, ["Neon"] = 52.5, ["Neon|Ride"] = 91.85, ["Neon|Fly|Ride"] = 116.28, ["Mega"] = 279.78, ["Mega|Ride"] = 287.11, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.73, ["Ride"] = 14.39, ["Fly|Ride"] = 41.92, ["Neon"] = 3.94, ["Neon|Fly"] = 25.14, ["Neon|Ride"] = 21.41, ["Neon|Fly|Ride"] = 62.89, ["Mega"] = 73.37, ["Mega|Fly"] = 209.57, ["Mega|Ride"] = 52.49, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1458.19}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 18.51, ["Ride"] = 56.44, ["Fly|Ride"] = 140.42, ["Neon"] = 129.94, ["Neon|Fly"] = 249.38, ["Neon|Ride"] = 140.4, ["Neon|Fly|Ride"] = 457.89, ["Mega"] = 489.33, ["Mega|Ride"] = 551.25, ["Mega|Fly|Ride"] = 487.13}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 56.59, ["Neon"] = 3.94, ["Neon|Ride"] = 40.87, ["Neon|Fly|Ride"] = 293.4, ["Mega"] = 31.5, ["Mega|Ride"] = 140.42}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 26.25, ["Fly"] = 110.87, ["Ride"] = 62.98, ["Neon"] = 139.11, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 262.85, ["Mega"] = 711.38, ["Mega|Ride"] = 974.09, ["Mega|Fly|Ride"] = 1046.07}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 105, ["Mega"] = 32.39}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 4.73, ["Neon|Ride"] = 47.19, ["Mega"] = 25.97, ["Mega|Ride"] = 134.46, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 110.24, ["Ride"] = 144.38, ["Fly|Ride"] = 196.88, ["Neon"] = 418.06, ["Neon|Ride"] = 446.25, ["Neon|Fly|Ride"] = 491.69, ["Mega|Ride"] = 6485.95, ["Mega|Fly|Ride"] = 1976.63}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.63, ["Fly"] = 26.13, ["Ride"] = 20.97, ["Fly|Ride"] = 70.76, ["Neon"] = 10.23, ["Neon|Fly"] = 56.59, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 68.25, ["Mega"] = 90.15, ["Mega|Ride"] = 197.01, ["Mega|Fly|Ride"] = 199.1}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Ride"] = 131.25, ["Fly|Ride"] = 86.63, ["Neon"] = 4.34, ["Neon|Fly"] = 62.89, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 38.06, ["Mega|Ride"] = 116.76, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.14, ["Neon|Ride"] = 35.55, ["Mega"] = 22.32, ["Mega|Ride"] = 140.4, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 6.3, ["Neon|Ride"] = 30.7, ["Mega"] = 47.16, ["Mega|Ride"] = 96.47, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 45.48, ["Ride"] = 116.94, ["Fly|Ride"] = 449.61, ["Neon"] = 276.17, ["Neon|Ride"] = 405.5, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1569.57, ["Mega|Ride"] = 1571.67, ["Mega|Fly|Ride"] = 1258.28}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.92, ["Ride"] = 36.53, ["Neon"] = 36.11, ["Neon|Ride"] = 110.87, ["Mega"] = 140.4, ["Mega|Ride"] = 836.73}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 311.07, ["Ride"] = 414.93, ["Fly|Ride"] = 616.88, ["Neon"] = 1786.59, ["Neon|Fly"] = 1195.79, ["Neon|Ride"] = 1439.65, ["Neon|Fly|Ride"] = 1253.44, ["Mega|Ride"] = 3352.88, ["Mega|Fly|Ride"] = 3656.2}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 1.84}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 78.75}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 43.32}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 19.92}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 28.31}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 42.98}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 48.25}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 12.88}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 7.26}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 239.78}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 25.43}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 118.13}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 5.52}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 11.8}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 217.95}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 3.94}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 9.52}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 6.3}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 6.24}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 8.8}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 366.76}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 695.03}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 9.1}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1500.19}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 559.53}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.63}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 6.34}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 17.06}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 13.5}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 5171.25}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 43.31}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 18.33}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 10.5}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 13.13}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 5.8}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 19.92}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 4.67}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 61.67}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 34.21}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 3.91}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1771.88}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 45.07}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 299.24}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 8.11}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 3.94}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 10.5}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 7.86}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 32.82}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 104.99}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 9.19}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 14.1}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.63}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 9618}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 15.75}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 3.75}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 19.69}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 7.63}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 8.4}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 155.09}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 22.32}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 8.89}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.63}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 14.96}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 11.34}},
    ["rbxassetid://1265129203"] = {name = "Ice Snowboard", prices = {["default"] = 315.79}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 8.35}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 39.38}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 136.52}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 183.75}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 14.18}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 32.76}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 20.67}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 52.5}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 102.36}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22462.56}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 208.68}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 30.87}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 61.69}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 35.44}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 86.62}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 63}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 99.75}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 76.13}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 98.51}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 32.81}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 41.95}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 47.25}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 81.22}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 10896.79}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 9.19}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 8.69}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 3.53}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 8.24}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 19.48}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 50.64}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 3.89}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.17}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 3.94}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 7.87}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 245.34}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 1967.43}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 5.94}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 705.22}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 24.75}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 48.55}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 78.75}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 28.59}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 50.26}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 57.25}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 20.06}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 6.45}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 15.74}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 3.77}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 4.57}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 9.95}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 26.25}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 5.18}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.58}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 8.38}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 18.38}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 169.32}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 1.84}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.63}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1046.73}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 7.38}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 7.85}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 4.86}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 18.24}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 88.72}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 12.59}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.63}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 9.92}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 13.13}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 33.32}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 87.9}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 34.13}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 3.03}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 7.4}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 41.91}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 70.67}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 3.56}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 7.83}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 3.4}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 5730.24}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 55.13}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3.45}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.73}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 4.79}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 19.58}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 7.23}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 4.9}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 15.64}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 115.5}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 39.38}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.33}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 4.87}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 18.47}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 7.86}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.67}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 2605.81}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 6.08}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 42.38}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 6.05}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 81.37}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 7.48}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 92.3}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.05}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.1}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 6.3}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 3.29}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 11.69}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 27.57}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.62}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.56}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.94}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.62}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.62}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 11.83}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 10.48}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.36}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 7.85}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.58}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 6.54}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.23}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 3.93}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 37.73}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 559.53}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.62}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 9.29}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 100.96}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.46}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 58.62}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 2.63}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 24.9}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 984.38}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 7.88}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 4.71}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 3.55}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 27.44}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 3.94}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 15.65}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 12.76}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 11.8}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 7.87}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 23.39}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 23.61}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.72}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.94}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 15.09}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 14.26}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.63}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 32.82}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.47}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 73.26}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 13.07}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 70.22}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.63}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 11.53}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 3.13}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.19}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 4.88}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 49.88}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 25.74}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 5.25}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 231}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 3.3}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 16.33}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 6.3}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 3.93}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.6}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 13.11}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 18.86}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 6.12}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.97}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 16.66}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 146.71}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.61}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 110.25}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 5.16}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1127.44}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.21}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 190.32}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 17.29}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 18.71}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 52.5}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.63}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 6.2}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 7.86}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 7.08}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 56.59}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 8.49}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 3.21}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.61}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 6.3}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.88}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 16.66}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 3.06}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 51.98}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 6.3}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 43.38}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 3.94}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 8.31}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 29.99}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 90.95}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 3.94}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 66.68}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 3.93}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 15.64}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 90.6}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.63}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 67.47}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 175.11}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 341.25}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 104.68}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.63}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 125.64}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.84}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.52}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 20.99}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 39.38}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 40.64}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.15}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 9.79}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 10.06}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 91.86}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 14.84}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 9.45}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 4.22}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 78.74}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 42.07}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 7.7}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 6.57}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 36.01}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 7.8}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 56.8}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 34.54}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 18.38}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1227.19}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 5.79}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 7.82}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 35.44}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.62}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 275.42}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 13.34}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 10.17}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 9.55}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 7.88}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 3.94}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 196.27}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 39.37}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 68.25}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 10.49}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 64.98}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 102.38}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 64.83}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1155}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 183.38}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 8.71}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1665.97}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 420}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 3.56}},
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