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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 787.5, ["Ride"] = 853.13, ["Fly|Ride"] = 1050, ["Neon"] = 4110.7, ["Neon|Fly|Ride"] = 3921.75}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 420, ["Ride"] = 475.27, ["Fly|Ride"] = 606.58, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 2875.08, ["Mega"] = 10275.45}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 5906.25, ["Ride"] = 5197.5, ["Fly|Ride"] = 4592.44, ["Neon|Fly|Ride"] = 19866.55, ["Mega|Fly|Ride"] = 68503.29}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 154.77, ["Ride"] = 184.41, ["Fly|Ride"] = 252, ["Neon"] = 774.94, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 1096.4, ["Mega"] = 4110.2, ["Mega|Fly|Ride"] = 3134.25}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 525, ["Fly"] = 822.05, ["Ride"] = 577.5, ["Fly|Ride"] = 523.69, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1652.49, ["Mega|Fly|Ride"] = 6300}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 5.92, ["Ride"] = 27.68, ["Fly|Ride"] = 152.11, ["Neon"] = 73.38, ["Neon|Ride"] = 109.24, ["Neon|Fly|Ride"] = 274.37, ["Mega"] = 288.35, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.66, ["Fly"] = 38.96, ["Ride"] = 26.24, ["Fly|Ride"] = 76.06, ["Neon"] = 33.12, ["Neon|Fly"] = 106.89, ["Neon|Ride"] = 53.94, ["Neon|Fly|Ride"] = 105, ["Mega"] = 131.03, ["Mega|Ride"] = 189.59, ["Mega|Fly|Ride"] = 286.19}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 98.76, ["Ride"] = 146.24, ["Fly|Ride"] = 233.63, ["Neon"] = 545.71, ["Neon|Ride"] = 615.5, ["Neon|Fly|Ride"] = 669.37, ["Mega|Ride"] = 2329.46, ["Mega|Fly|Ride"] = 2641.83}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 28.87, ["Fly"] = 137.7, ["Ride"] = 51.19, ["Fly|Ride"] = 115.03, ["Neon"] = 288.75, ["Neon|Ride"] = 301.86, ["Neon|Fly|Ride"] = 233.26, ["Mega"] = 2100, ["Mega|Ride"] = 2730, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 23.5, ["Fly"] = 51.98, ["Ride"] = 30.65, ["Fly|Ride"] = 76.65, ["Neon"] = 274.4, ["Neon|Ride"] = 199.36, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 1334.8, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 63, ["Fly"] = 109.96, ["Ride"] = 101.74, ["Fly|Ride"] = 144.38, ["Neon"] = 262.5, ["Neon|Fly"] = 369.97, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 288.75, ["Mega|Fly|Ride"] = 2055.11}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 65.63}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 354.38, ["Fly"] = 395.01, ["Ride"] = 351.74, ["Fly|Ride"] = 392.22, ["Neon"] = 1302.08, ["Neon|Fly|Ride"] = 1152.57, ["Mega|Fly|Ride"] = 4836.66}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 107.63, ["Fly"] = 130.04, ["Ride"] = 123.38, ["Fly|Ride"] = 183.54, ["Neon|Ride"] = 564.38, ["Neon|Fly|Ride"] = 548.63, ["Mega|Fly|Ride"] = 2632.95}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.63, ["Fly"] = 114.07, ["Ride"] = 51.85, ["Fly|Ride"] = 205.55, ["Neon"] = 19.69, ["Neon|Fly"] = 96.41, ["Neon|Ride"] = 137.7, ["Neon|Fly|Ride"] = 137.7, ["Mega"] = 137.12, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 205.52, ["Mega|Fly|Ride"] = 384.61}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 157.5, ["Fly"] = 241.48, ["Ride"] = 150.93, ["Fly|Ride"] = 227.73, ["Neon"] = 929.45, ["Neon|Ride"] = 603.75, ["Neon|Fly|Ride"] = 630, ["Mega|Fly|Ride"] = 2229.93}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.48, ["Fly"] = 21.38, ["Ride"] = 18.38, ["Fly|Ride"] = 39.37, ["Neon"] = 24.99, ["Neon|Ride"] = 62.75, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 334.69, ["Mega|Fly"] = 348.59, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 332.07}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 90.56, ["Fly"] = 262.5, ["Ride"] = 131.25, ["Fly|Ride"] = 258.28, ["Neon"] = 347.06, ["Neon|Ride"] = 373.74, ["Neon|Fly|Ride"] = 426.57, ["Mega"] = 1494.06, ["Mega|Ride"] = 1168.13, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 34.13}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 45.93, ["Ride"] = 123.38, ["Fly|Ride"] = 164.07, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 2362.5}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 13.13, ["Fly"] = 393.75, ["Ride"] = 30.83, ["Fly|Ride"] = 223.13, ["Neon"] = 204.52, ["Neon|Ride"] = 175.72, ["Neon|Fly|Ride"] = 266.16, ["Mega|Ride"] = 578.52, ["Mega|Fly|Ride"] = 1644.08}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 43.32, ["Fly"] = 124.32, ["Ride"] = 55.11, ["Fly|Ride"] = 91.88, ["Neon"] = 241.34, ["Neon|Ride"] = 220.5, ["Neon|Fly|Ride"] = 288.74, ["Mega"] = 1626.72, ["Mega|Fly|Ride"] = 819.51}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 36.74, ["Ride"] = 155.69, ["Fly|Ride"] = 136.5, ["Neon"] = 152.11, ["Neon|Fly"] = 385.73, ["Neon|Ride"] = 294.92, ["Neon|Fly|Ride"] = 343.22, ["Mega"] = 1067.63, ["Mega|Ride"] = 1228.96, ["Mega|Fly|Ride"] = 1069}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 18.38, ["Ride"] = 41.1, ["Fly|Ride"] = 131.25, ["Neon"] = 343.25, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 315, ["Mega"] = 768.62, ["Mega|Ride"] = 2053.05, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 40.67, ["Fly"] = 136.75, ["Ride"] = 59.06, ["Fly|Ride"] = 137.72, ["Neon"] = 210, ["Neon|Fly"] = 549.82, ["Neon|Ride"] = 310.25, ["Neon|Fly|Ride"] = 411.03, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 867.81}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 8.24, ["Fly"] = 28.88, ["Ride"] = 22.19, ["Fly|Ride"] = 52.5, ["Neon"] = 30.94, ["Neon|Fly"] = 104.99, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 91.85, ["Mega"] = 129.94, ["Mega|Fly"] = 23607.43, ["Mega|Ride"] = 181.12, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 405.9, ["Ride"] = 415.09, ["Fly|Ride"] = 441.23, ["Neon"] = 1858.89, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1680, ["Mega|Fly|Ride"] = 7261.67}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 20.22, ["Ride"] = 19.69, ["Fly|Ride"] = 48.33, ["Neon"] = 219.18, ["Neon|Ride"] = 176.75, ["Neon|Fly|Ride"] = 419.25, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 6.18, ["Fly"] = 34.54, ["Ride"] = 21, ["Fly|Ride"] = 47.79, ["Neon"] = 51.17, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 124.72, ["Mega|Ride"] = 325.36, ["Mega|Fly|Ride"] = 405.87}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 76.13, ["Fly"] = 77.44, ["Ride"] = 82.22, ["Fly|Ride"] = 125.99, ["Neon"] = 210, ["Neon|Ride"] = 385.75, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 3014.84, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 2014.81}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 15.43, ["Ride"] = 35.98, ["Fly|Ride"] = 74.55, ["Neon"] = 155.69, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 160.79, ["Mega"] = 697.17, ["Mega|Ride"] = 780.95, ["Mega|Fly|Ride"] = 483}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 155.72, ["Fly"] = 347.32, ["Ride"] = 210, ["Fly|Ride"] = 294.95, ["Neon"] = 813.27, ["Neon|Ride"] = 673.94, ["Neon|Fly|Ride"] = 1096.4, ["Mega"] = 6165.28, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2870.98}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 34.13}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.94, ["Fly"] = 29.51, ["Ride"] = 24.93, ["Fly|Ride"] = 49.8, ["Neon"] = 27.76, ["Neon|Fly"] = 5138.37, ["Neon|Ride"] = 46.49, ["Neon|Fly|Ride"] = 152.1, ["Mega"] = 159.62, ["Mega|Fly"] = 343.22, ["Mega|Ride"] = 273.34, ["Mega|Fly|Ride"] = 274.37}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 1050, ["Fly"] = 2625, ["Ride"] = 1181.25, ["Fly|Ride"] = 1312.5, ["Neon"] = 7158.38, ["Neon|Ride"] = 6028.61, ["Neon|Fly|Ride"] = 4003.13, ["Mega|Ride"] = 52286.92, ["Mega|Fly|Ride"] = 20140.93}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 10.5, ["Fly"] = 78.75, ["Ride"] = 32.8, ["Fly|Ride"] = 132.46, ["Neon"] = 77.1, ["Neon|Ride"] = 117.16, ["Neon|Fly|Ride"] = 219.91, ["Mega"] = 532.29, ["Mega|Ride"] = 676.14, ["Mega|Fly|Ride"] = 820.31}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 152.25, ["Ride"] = 168, ["Fly|Ride"] = 278.84, ["Neon"] = 808.79, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 656.25, ["Mega|Ride"] = 2014.81, ["Mega|Fly|Ride"] = 2877.14}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 41.11}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 19.68, ["Fly"] = 68.84, ["Ride"] = 52.28, ["Fly|Ride"] = 145.69, ["Neon"] = 82.41, ["Neon|Ride"] = 155.72, ["Neon|Fly|Ride"] = 288.18, ["Mega"] = 685.38, ["Mega|Fly|Ride"] = 760.39}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 111.57, ["Ride"] = 205.52, ["Neon"] = 754.32, ["Neon|Ride"] = 996.96, ["Neon|Fly|Ride"] = 698.74, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 105, ["Ride"] = 152.25, ["Fly|Ride"] = 246.75, ["Neon"] = 315, ["Neon|Ride"] = 364.88, ["Neon|Fly|Ride"] = 576.19, ["Mega"] = 1541.33, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1942.06}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 52.4}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 52.29, ["Fly"] = 59.16, ["Ride"] = 54.93, ["Fly|Ride"] = 81.38, ["Neon|Ride"] = 478.73, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 4110.2, ["Mega|Fly|Ride"] = 1596.51}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 7.45, ["Fly"] = 55.51, ["Ride"] = 73.21, ["Fly|Ride"] = 131.25, ["Neon"] = 41.12, ["Neon|Ride"] = 123.65, ["Neon|Fly|Ride"] = 328.82, ["Mega"] = 157.5, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 274.37, ["Mega|Fly|Ride"] = 409.5}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 420, ["Fly"] = 426.57, ["Ride"] = 409.5, ["Fly|Ride"] = 472.49, ["Neon|Ride"] = 1781.77, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 6298.95}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 96.66, ["Fly"] = 155.17, ["Ride"] = 104.99, ["Fly|Ride"] = 170.63, ["Neon"] = 446.25, ["Neon|Ride"] = 582.63, ["Neon|Fly|Ride"] = 538.13, ["Mega|Ride"] = 2452.77, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3718.14, ["Ride"] = 3433.5, ["Fly|Ride"] = 3673.69, ["Neon|Fly|Ride"] = 14384.61}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 41.99, ["Fly"] = 109.96, ["Ride"] = 46.87, ["Fly|Ride"] = 78.75, ["Neon"] = 393.75, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 343.22, ["Mega|Ride"] = 1179.64, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 68.86, ["Ride"] = 78.75, ["Fly|Ride"] = 195.57, ["Neon"] = 410.42, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 2740.48, ["Mega|Fly|Ride"] = 2656.24}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 36.75, ["Fly"] = 78.75, ["Ride"] = 60, ["Fly|Ride"] = 131.25, ["Neon"] = 130.28, ["Neon|Ride"] = 152.1, ["Neon|Fly|Ride"] = 217.41, ["Mega"] = 2625, ["Mega|Ride"] = 685.38, ["Mega|Fly|Ride"] = 586.69}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 7.53}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 46.35, ["Fly"] = 393.75, ["Ride"] = 47.25, ["Fly|Ride"] = 71.61, ["Neon"] = 328.13, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1493.63}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 38.98}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 221.93, ["Ride"] = 274.4, ["Fly|Ride"] = 314.48, ["Neon|Ride"] = 1370.76, ["Neon|Fly|Ride"] = 929.56, ["Mega|Fly|Ride"] = 4957.98}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 1233.07, ["Ride"] = 938.44, ["Fly|Ride"] = 1301.04, ["Neon|Fly|Ride"] = 3018.75, ["Mega|Fly|Ride"] = 15413.16}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 6.51}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 23.63, ["Fly"] = 51.72, ["Ride"] = 39.1, ["Fly|Ride"] = 68.87, ["Neon"] = 182.95, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 190.31, ["Mega|Ride"] = 656.04, ["Mega|Fly|Ride"] = 817.94}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 13.12}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 6288.58, ["Fly"] = 5843.65, ["Fly|Ride"] = 4723.69, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 40280.69}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 15.43, ["Fly"] = 74.71, ["Ride"] = 26.25, ["Fly|Ride"] = 59.62, ["Neon"] = 98.23, ["Neon|Ride"] = 120.74, ["Neon|Fly|Ride"] = 217.3, ["Mega"] = 649.43, ["Mega|Ride"] = 607.29, ["Mega|Fly|Ride"] = 609}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 13.12, ["Fly"] = 191.15, ["Ride"] = 41.12, ["Fly|Ride"] = 115.03, ["Neon"] = 111.57, ["Neon|Ride"] = 132.7, ["Neon|Fly|Ride"] = 231, ["Mega"] = 1034.14, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 822.05}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 94.55, ["Fly"] = 265.67, ["Ride"] = 72.17, ["Fly|Ride"] = 105, ["Neon|Ride"] = 381.23, ["Neon|Fly|Ride"] = 471.37, ["Mega"] = 4110.2}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 10.19, ["Ride"] = 26.25, ["Fly|Ride"] = 106.89, ["Neon"] = 55.51, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 501.37, ["Mega"] = 1370.76, ["Mega|Ride"] = 500.43, ["Mega|Fly|Ride"] = 775.02}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1968.64, ["Fly"] = 1837.5, ["Ride"] = 1771.88, ["Fly|Ride"] = 1837.5, ["Neon|Fly|Ride"] = 3609.38, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 29400, ["Fly"] = 26250, ["Ride"] = 34256.43, ["Fly|Ride"] = 23625, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 65079.5, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183750}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 15.75, ["Fly"] = 393.74, ["Ride"] = 52.5, ["Fly|Ride"] = 89.93, ["Neon"] = 241.53, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 300.06, ["Mega"] = 959.75, ["Mega|Ride"] = 735, ["Mega|Fly|Ride"] = 817.94}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.63, ["Fly"] = 73.21, ["Ride"] = 46.95, ["Fly|Ride"] = 135.68, ["Neon"] = 19.53, ["Neon|Fly"] = 134.4, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 118.02, ["Mega"] = 127.3, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 338.62}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 22.32}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 11, ["Ride"] = 36.75, ["Fly|Ride"] = 124.67, ["Neon"] = 41.12, ["Neon|Ride"] = 125.32, ["Neon|Fly|Ride"] = 463.21, ["Mega"] = 370.55, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 545.35}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 656.15, ["Ride"] = 588, ["Fly|Ride"] = 787.5, ["Neon|Ride"] = 3035.38, ["Neon|Fly|Ride"] = 2323.88, ["Mega|Fly|Ride"] = 8469.57}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 945, ["Fly"] = 962.07, ["Ride"] = 826.88, ["Fly|Ride"] = 944.99, ["Neon"] = 4110.7, ["Neon|Fly|Ride"] = 3109.31, ["Mega|Fly|Ride"] = 11233.13}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 15.43, ["Fly"] = 116.2, ["Ride"] = 36.75, ["Fly|Ride"] = 65.63, ["Neon"] = 145.69, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 246.63, ["Mega"] = 1085.26, ["Mega|Ride"] = 685.13, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 32.82}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 63, ["Fly"] = 93.19, ["Ride"] = 80.07, ["Fly|Ride"] = 106.77, ["Neon|Ride"] = 411.03, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 2011.94, ["Mega|Fly|Ride"] = 1664.25}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 68.25, ["Ride"] = 77.22, ["Fly|Ride"] = 228.38, ["Neon"] = 356.62, ["Neon|Ride"] = 390.48, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 2070.74, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 4.13, ["Fly"] = 27.76, ["Ride"] = 20, ["Fly|Ride"] = 51.32, ["Neon"] = 23.63, ["Neon|Fly"] = 525, ["Neon|Ride"] = 48.3, ["Neon|Fly|Ride"] = 108.94, ["Mega"] = 315, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 103.59, ["Fly"] = 114.19, ["Ride"] = 105, ["Fly|Ride"] = 137.82, ["Neon"] = 393.75, ["Neon|Ride"] = 441.54, ["Neon|Fly|Ride"] = 339.94, ["Mega|Fly|Ride"] = 1442.41}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 5, ["Ride"] = 61.66, ["Fly|Ride"] = 111.57, ["Neon"] = 29.39, ["Neon|Ride"] = 91.86, ["Neon|Fly|Ride"] = 188.35, ["Mega"] = 229.69, ["Mega|Fly"] = 274.37, ["Mega|Ride"] = 287.74, ["Mega|Fly|Ride"] = 496.33}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 13.13, ["Fly"] = 41.11, ["Ride"] = 28.71, ["Fly|Ride"] = 90.45, ["Neon"] = 109.23, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 175.72, ["Mega"] = 726.49, ["Mega|Ride"] = 667.91, ["Mega|Fly|Ride"] = 752.17}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 26.24, ["Ride"] = 74.72, ["Fly|Ride"] = 156.19, ["Neon"] = 262.07, ["Neon|Ride"] = 685.38, ["Mega"] = 694.25, ["Mega|Ride"] = 775.02, ["Mega|Fly|Ride"] = 863.16}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 13.13, ["Fly"] = 124.8, ["Ride"] = 28.88, ["Fly|Ride"] = 72.19, ["Neon"] = 91.88, ["Neon|Ride"] = 109.24, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 713.13, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6971.51, ["Ride"] = 6365.63, ["Fly|Ride"] = 6483.63, ["Neon"] = 30830.17, ["Neon|Fly|Ride"] = 27265.89}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 241.5, ["Fly"] = 261.19, ["Ride"] = 208.69, ["Fly|Ride"] = 291.37, ["Neon|Fly|Ride"] = 510.57, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 34.96, ["Fly"] = 68.86, ["Ride"] = 78.66, ["Fly|Ride"] = 154.41, ["Neon"] = 93.19, ["Neon|Fly"] = 241.5, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 380.63, ["Mega|Ride"] = 367.49, ["Mega|Fly|Ride"] = 490.88}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 85.98, ["Ride"] = 23.63, ["Fly|Ride"] = 105.74, ["Neon"] = 23.04, ["Neon|Ride"] = 55.51, ["Neon|Fly|Ride"] = 187.03, ["Mega"] = 262.5, ["Mega|Ride"] = 187.69}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 39.38, ["Fly"] = 5266.34, ["Ride"] = 91.88, ["Fly|Ride"] = 193.6, ["Neon"] = 183.75, ["Neon|Fly"] = 332.98, ["Neon|Ride"] = 205.83, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 414.41, ["Mega|Ride"] = 592.65, ["Mega|Fly|Ride"] = 584.73}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 13991.25, ["Ride"] = 13125, ["Fly|Ride"] = 12336.19, ["Neon|Fly|Ride"] = 27562.5}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 129.93, ["Ride"] = 164.06, ["Fly|Ride"] = 262.5, ["Neon"] = 1370.94, ["Neon|Ride"] = 1438.58, ["Neon|Fly|Ride"] = 1438.58, ["Mega|Fly|Ride"] = 4356.8}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 60.38, ["Fly"] = 101.88, ["Ride"] = 59.07, ["Fly|Ride"] = 86.63, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 407.84, ["Mega|Fly|Ride"] = 2515.44}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 13.13, ["Fly"] = 28.53, ["Ride"] = 24.55, ["Fly|Ride"] = 59.62, ["Neon"] = 85.32, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 466.52, ["Mega|Ride"] = 406.69, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 341.24, ["Fly"] = 822.05, ["Ride"] = 380.63, ["Fly|Ride"] = 470.49, ["Neon"] = 1639.32, ["Neon|Ride"] = 1617.37, ["Neon|Fly|Ride"] = 1614.38, ["Mega|Fly|Ride"] = 5011.13}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.57, ["Ride"] = 38.07, ["Fly|Ride"] = 137.72, ["Neon"] = 31.5, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 217.3, ["Mega"] = 129.94, ["Mega|Ride"] = 201.57, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 161.44, ["Fly"] = 271.87, ["Ride"] = 328.88, ["Fly|Ride"] = 217.32, ["Neon"] = 757.51, ["Neon|Ride"] = 687.93, ["Neon|Fly|Ride"] = 730.59, ["Mega|Fly|Ride"] = 3563.65}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 13.01, ["Fly"] = 15.43, ["Ride"] = 18.38, ["Fly|Ride"] = 35.05, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 103.67, ["Mega"] = 786.19, ["Mega|Fly|Ride"] = 686.72}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 10.5}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 65.63, ["Ride"] = 86.63, ["Fly|Ride"] = 279.57, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1233.07, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 15.87, ["Fly"] = 101.74, ["Ride"] = 32.82, ["Fly|Ride"] = 86.52, ["Neon"] = 96.63, ["Neon|Ride"] = 137.7, ["Neon|Fly|Ride"] = 189, ["Mega"] = 512.76, ["Mega|Ride"] = 548.72, ["Mega|Fly|Ride"] = 546}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 23.63}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 39.38, ["Fly"] = 131.25, ["Ride"] = 65.63, ["Fly|Ride"] = 101.09, ["Neon"] = 123.33, ["Neon|Ride"] = 258.54, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 914.53, ["Mega|Ride"] = 943.29, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.93, ["Ride"] = 29.23, ["Fly|Ride"] = 132.46, ["Neon"] = 22.32, ["Neon|Ride"] = 104.6, ["Neon|Fly|Ride"] = 265.12, ["Mega"] = 129.94, ["Mega|Fly|Ride"] = 412.79}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 14.32, ["Fly"] = 47.24, ["Ride"] = 34.96, ["Fly|Ride"] = 77.44, ["Neon"] = 42, ["Neon|Ride"] = 137.7, ["Neon|Fly|Ride"] = 163.26, ["Mega|Ride"] = 561.05, ["Mega|Fly|Ride"] = 590.28}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 367.5, ["Ride"] = 405.95, ["Fly|Ride"] = 354.38, ["Neon|Fly|Ride"] = 2712.73, ["Mega|Fly|Ride"] = 8631.39}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 42, ["Fly"] = 102.77, ["Ride"] = 55.06, ["Fly|Ride"] = 103.68, ["Neon"] = 184.74, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 233.26, ["Mega"] = 711.08, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 756.29}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 45.93, ["Fly"] = 109.23, ["Ride"] = 82.22, ["Fly|Ride"] = 171.95, ["Neon|Ride"] = 316.5, ["Neon|Fly|Ride"] = 315, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 27.57, ["Ride"] = 66.27, ["Fly|Ride"] = 144.47, ["Neon"] = 92.65, ["Neon|Ride"] = 178.81, ["Neon|Fly|Ride"] = 237.87, ["Mega"] = 393.75, ["Mega|Ride"] = 409.5, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 26249.99, ["Ride"] = 13273.32, ["Fly|Ride"] = 7743.75, ["Neon|Fly|Ride"] = 13650, ["Mega|Fly|Ride"] = 39373.95}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1509.38, ["Fly"] = 1706.25, ["Ride"] = 1522.5, ["Fly|Ride"] = 1442.44, ["Neon"] = 5481.61, ["Neon|Fly|Ride"] = 4199.99, ["Mega"] = 20825.24, ["Mega|Fly|Ride"] = 15093.75}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 525, ["Ride"] = 505.32, ["Fly|Ride"] = 485.63, ["Neon"] = 2260.9, ["Neon|Fly|Ride"] = 2342.82, ["Mega|Fly|Ride"] = 6685.21}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 16.46, ["Fly"] = 23.63, ["Ride"] = 23.63, ["Fly|Ride"] = 51.4, ["Neon"] = 109.98, ["Neon|Ride"] = 94.55, ["Neon|Fly|Ride"] = 137.7, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 6.57, ["Fly"] = 78.74, ["Ride"] = 30.76, ["Fly|Ride"] = 123.33, ["Neon"] = 21.05, ["Neon|Ride"] = 74, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 133.56, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 35.98, ["Fly"] = 68.25, ["Ride"] = 54.31, ["Fly|Ride"] = 84, ["Neon"] = 274.4, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 174.59, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.29, ["Fly"] = 20.56, ["Ride"] = 17.5, ["Fly|Ride"] = 31.49, ["Neon"] = 26.81, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 262.5, ["Mega|Ride"] = 205.52, ["Mega|Fly|Ride"] = 303.14}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 315, ["Fly"] = 320.25, ["Ride"] = 262.5, ["Fly|Ride"] = 373.75, ["Neon"] = 1004.41, ["Neon|Ride"] = 1343.02, ["Neon|Fly|Ride"] = 1169.44}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 24.68, ["Fly"] = 60.09, ["Ride"] = 40.47, ["Fly|Ride"] = 76.56, ["Neon"] = 206.07, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 229.69, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 13.13, ["Fly"] = 18.37, ["Ride"] = 19.49, ["Fly|Ride"] = 43.18, ["Neon"] = 68.87, ["Neon|Fly"] = 132.46, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 392.44, ["Fly"] = 787.5, ["Ride"] = 435.74, ["Fly|Ride"] = 644.37, ["Neon|Fly|Ride"] = 2788.65, ["Mega|Fly|Ride"] = 8619.19}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1148.33, ["Fly"] = 1394.31, ["Ride"] = 1154.99, ["Fly|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13770.06}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 123.24, ["Fly"] = 128.63, ["Ride"] = 105, ["Fly|Ride"] = 111.63, ["Neon"] = 513.85, ["Neon|Ride"] = 585.46, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 2329.46, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 136.5, ["Fly"] = 212.13, ["Ride"] = 190.55, ["Fly|Ride"] = 245.43, ["Neon"] = 557.82, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 718.27, ["Mega|Ride"] = 8603.44, ["Mega|Fly|Ride"] = 2466.12}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 21, ["Ride"] = 65.62, ["Fly|Ride"] = 274.4, ["Neon"] = 232.74, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 385.08, ["Mega|Ride"] = 2055.11, ["Mega|Fly|Ride"] = 805.61}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 129.94, ["Ride"] = 205.52, ["Fly|Ride"] = 192.2, ["Neon|Fly|Ride"] = 1301.39, ["Mega|Fly|Ride"] = 3288.15}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2055.11, ["Ride"] = 2483.25, ["Fly|Ride"] = 2466.42, ["Neon|Fly|Ride"] = 10275.45, ["Mega|Fly|Ride"] = 24788.66}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 65.63, ["Ride"] = 68.97, ["Fly|Ride"] = 196.88, ["Neon"] = 349.42, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 343.87, ["Mega"] = 1919.47, ["Mega|Ride"] = 2260.6, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 656.25, ["Fly"] = 795.33, ["Ride"] = 565.69, ["Fly|Ride"] = 658.01, ["Neon|Ride"] = 1540.73, ["Neon|Fly|Ride"] = 1168.12, ["Mega|Fly|Ride"] = 3107.9}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 39.38, ["Fly"] = 53.47, ["Ride"] = 52.5, ["Fly|Ride"] = 97.13, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 360.22, ["Neon|Fly|Ride"] = 225.75, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.14, ["Fly"] = 30.19, ["Ride"] = 21, ["Fly|Ride"] = 48.57, ["Neon"] = 29.82, ["Neon|Fly"] = 92.96, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 105, ["Mega"] = 144.25, ["Mega|Fly"] = 249.26, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 255.94}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 34.13, ["Ride"] = 123.04, ["Fly|Ride"] = 252, ["Neon"] = 259.88, ["Neon|Ride"] = 455.74, ["Neon|Fly|Ride"] = 685.38, ["Mega"] = 1502.28, ["Mega|Ride"] = 1370.76, ["Mega|Fly|Ride"] = 1233.07}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 666.75, ["Fly"] = 1016.69, ["Ride"] = 777, ["Fly|Ride"] = 803.25, ["Neon"] = 2466.42, ["Neon|Ride"] = 2329.46, ["Neon|Fly|Ride"] = 2168.14, ["Mega|Fly|Ride"] = 7947.03}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 608.99, ["Ride"] = 603.75, ["Fly|Ride"] = 859.69, ["Neon"] = 5138.37, ["Neon|Fly|Ride"] = 4007.43, ["Mega|Fly|Ride"] = 15207.66}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 15.75, ["Fly"] = 32.82, ["Ride"] = 20.56, ["Fly|Ride"] = 37.54, ["Neon"] = 205.55, ["Neon|Ride"] = 171.94, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 786.19}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 10.37, ["Ride"] = 19.69, ["Fly|Ride"] = 57.75, ["Neon"] = 72.02, ["Neon|Fly"] = 137.72, ["Neon|Ride"] = 91.81, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 505.57, ["Mega|Ride"] = 504.54, ["Mega|Fly|Ride"] = 380.2}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 4.8, ["Ride"] = 26.95, ["Fly|Ride"] = 111.46, ["Neon"] = 22.08, ["Neon|Fly"] = 310.22, ["Neon|Ride"] = 53.36, ["Neon|Fly|Ride"] = 137.7, ["Mega"] = 178.81, ["Mega|Ride"] = 244.13, ["Mega|Fly|Ride"] = 302.54}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 43.78, ["Fly"] = 77.09, ["Ride"] = 51.19, ["Fly|Ride"] = 109.07, ["Neon"] = 287.77, ["Neon|Ride"] = 216.56, ["Neon|Fly|Ride"] = 231, ["Mega|Ride"] = 1048.1, ["Mega|Fly|Ride"] = 944.9}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 52.5, ["Ride"] = 68.87, ["Fly|Ride"] = 449.61, ["Neon"] = 390.53, ["Neon|Ride"] = 491.18, ["Neon|Fly|Ride"] = 548.72, ["Mega"] = 1541.33, ["Mega|Ride"] = 1541.33, ["Mega|Fly|Ride"] = 1322.46}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 13.13, ["Fly"] = 54.55, ["Ride"] = 34.13, ["Fly|Ride"] = 90.45, ["Neon"] = 72.19, ["Neon|Ride"] = 108.92, ["Neon|Fly|Ride"] = 200.39, ["Mega"] = 343.22, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 41.11, ["Ride"] = 51.19, ["Fly|Ride"] = 78.75, ["Neon"] = 548.8, ["Neon|Ride"] = 274.37, ["Neon|Fly|Ride"] = 269.07, ["Mega"] = 2100, ["Mega|Ride"] = 959.75, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 2.63, ["Fly"] = 27.76, ["Ride"] = 18.71, ["Fly|Ride"] = 39.38, ["Neon"] = 26.25, ["Neon|Ride"] = 39.34, ["Neon|Fly|Ride"] = 91.71, ["Mega"] = 525, ["Mega|Ride"] = 274.37, ["Mega|Fly|Ride"] = 314.44}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 6.18, ["Fly"] = 30.86, ["Ride"] = 31.38, ["Fly|Ride"] = 80.88, ["Neon"] = 28.88, ["Neon|Fly"] = 82.23, ["Neon|Ride"] = 68.86, ["Neon|Fly|Ride"] = 164.42, ["Mega"] = 205.52, ["Mega|Ride"] = 367.87, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 31.5, ["Fly"] = 65.62, ["Ride"] = 51.18, ["Fly|Ride"] = 96.63, ["Neon"] = 403.16, ["Neon|Ride"] = 279.34, ["Neon|Fly|Ride"] = 267.75, ["Mega|Fly|Ride"] = 922.74}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1600.89, ["Fly"] = 1870.33, ["Ride"] = 1522.5, ["Fly|Ride"] = 1527.75, ["Neon|Fly"] = 4937.67, ["Neon|Ride"] = 4631.16, ["Neon|Fly|Ride"] = 3734.07, ["Mega|Fly|Ride"] = 16439.69}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 393.74, ["Fly"] = 479.75, ["Ride"] = 393.75, ["Fly|Ride"] = 612.51, ["Neon|Ride"] = 2973.73, ["Neon|Fly|Ride"] = 2977.84, ["Mega|Fly|Ride"] = 9589.06}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 236.24, ["Fly"] = 369.93, ["Ride"] = 262.5, ["Fly|Ride"] = 328.13, ["Neon"] = 1507.61, ["Neon|Fly|Ride"] = 1619.75, ["Mega|Fly|Ride"] = 6825}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 45.57}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 26.25, ["Ride"] = 41.89, ["Fly|Ride"] = 96.63, ["Neon"] = 329.97, ["Neon|Fly"] = 411.08, ["Neon|Ride"] = 343.22, ["Neon|Fly|Ride"] = 1968.75, ["Mega"] = 924.81, ["Mega|Ride"] = 959.75, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 41101.76, ["Fly"] = 20998.69, ["Ride"] = 34781.25, ["Fly|Ride"] = 17784.38, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 384.33, ["Fly"] = 855.07, ["Ride"] = 262.5, ["Fly|Ride"] = 406.88, ["Neon"] = 984.38, ["Neon|Ride"] = 1207.5, ["Neon|Fly|Ride"] = 1113, ["Mega"] = 6165.28, ["Mega|Fly|Ride"] = 3845.63}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 171.93, ["Fly"] = 525, ["Ride"] = 163.72, ["Fly|Ride"] = 173.7, ["Mega|Fly|Ride"] = 4110.2}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 103.69, ["Fly"] = 262.5, ["Ride"] = 122.79, ["Fly|Ride"] = 183.75, ["Neon"] = 616.62, ["Neon|Ride"] = 509.73, ["Neon|Fly|Ride"] = 548.72, ["Mega|Fly|Ride"] = 2465.1}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 15.75, ["Fly"] = 94.5, ["Ride"] = 33.71, ["Fly|Ride"] = 108.94, ["Neon"] = 39.38, ["Neon|Ride"] = 137.7, ["Neon|Fly|Ride"] = 205.52, ["Mega"] = 464.79, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 616.54}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4795.56, ["Ride"] = 4932.22, ["Fly|Ride"] = 3937.5, ["Neon|Ride"] = 17811.46, ["Neon|Fly|Ride"] = 15483.04}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 27.76, ["Fly"] = 48.56, ["Ride"] = 36.07, ["Fly|Ride"] = 53.82, ["Neon"] = 337.32, ["Neon|Ride"] = 205.52, ["Neon|Fly|Ride"] = 223.13, ["Mega|Fly|Ride"] = 859.69}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 39.34, ["Ride"] = 42, ["Fly|Ride"] = 106.89, ["Neon|Ride"] = 381.94, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1550.03, ["Mega|Fly|Ride"] = 1574.22}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 706.13, ["Fly"] = 912.47, ["Ride"] = 729.75, ["Fly|Ride"] = 807.19, ["Neon"] = 2326.67, ["Neon|Ride"] = 1863.75, ["Neon|Fly|Ride"] = 1837.5, ["Mega|Fly|Ride"] = 6103.13}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 17.07, ["Fly"] = 25.03, ["Ride"] = 26.17, ["Fly|Ride"] = 41.29, ["Neon"] = 124.68, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 136.5, ["Mega|Ride"] = 582.63, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 15.59, ["Ride"] = 34.12, ["Fly|Ride"] = 464.75, ["Neon"] = 80.07, ["Neon|Ride"] = 143.07, ["Neon|Fly|Ride"] = 249.38, ["Mega|Ride"] = 520.98, ["Mega|Fly|Ride"] = 548.72}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 102.38, ["Ride"] = 115.5, ["Fly|Ride"] = 262.5, ["Neon"] = 533.37, ["Neon|Ride"] = 525.35, ["Neon|Fly|Ride"] = 697.17, ["Mega|Fly|Ride"] = 2479.58}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 22.62, ["Ride"] = 84.28, ["Fly|Ride"] = 109.98, ["Neon"] = 68.87, ["Neon|Ride"] = 123.32, ["Neon|Fly|Ride"] = 255.86, ["Mega"] = 249.38, ["Mega|Fly"] = 737.84, ["Mega|Ride"] = 299.92, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3889.85, ["Ride"] = 3937.49, ["Fly|Ride"] = 3772.13, ["Neon"] = 10379.5, ["Neon|Ride"] = 17468.26, ["Neon|Fly|Ride"] = 9016.88, ["Mega"] = 61650.59, ["Mega|Fly|Ride"] = 34225.86}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 38.98, ["Ride"] = 55.51, ["Fly|Ride"] = 108.66, ["Neon"] = 137.72, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 411.03, ["Mega|Ride"] = 1026.53, ["Mega|Fly|Ride"] = 1206.35}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 5891.82, ["Fly"] = 7875, ["Ride"] = 7745.75, ["Fly|Ride"] = 5775, ["Neon|Fly|Ride"] = 16017.29, ["Mega|Fly|Ride"] = 68167.04}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.63, ["Fly"] = 20.89, ["Ride"] = 15.7, ["Fly|Ride"] = 37.19, ["Neon"] = 22.31, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 45.48, ["Neon|Fly|Ride"] = 86.51, ["Mega"] = 344.25, ["Mega|Ride"] = 192.18, ["Mega|Fly|Ride"] = 330.75}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 19.69, ["Fly"] = 26.16, ["Ride"] = 27.43, ["Fly|Ride"] = 55.51, ["Neon"] = 192.2, ["Neon|Ride"] = 163.4, ["Neon|Fly|Ride"] = 178.81, ["Mega|Ride"] = 1181.93, ["Mega|Fly|Ride"] = 929.56}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.68}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 15.04, ["Ride"] = 39.36, ["Fly|Ride"] = 116.03, ["Neon"] = 141.83, ["Neon|Ride"] = 157.68, ["Mega"] = 775.02, ["Mega|Ride"] = 959.75, ["Mega|Fly|Ride"] = 748.13}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 30.11, ["Fly"] = 190.37, ["Ride"] = 40.08, ["Fly|Ride"] = 137.72, ["Neon"] = 180.88, ["Neon|Ride"] = 185.88, ["Neon|Fly|Ride"] = 265.69, ["Mega"] = 840, ["Mega|Fly|Ride"] = 929.56}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 17.35, ["Fly"] = 20.15, ["Ride"] = 23.39, ["Fly|Ride"] = 42.35, ["Neon"] = 96.63, ["Neon|Ride"] = 114.07, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 786.19, ["Mega|Ride"] = 579.81, ["Mega|Fly|Ride"] = 483}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8905.74}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2715.57}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 21}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 170.6, ["Fly"] = 174.57, ["Ride"] = 174.57, ["Fly|Ride"] = 183.74, ["Neon|Fly|Ride"] = 1027.56}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 17.4, ["Fly"] = 123.32, ["Ride"] = 41.12, ["Fly|Ride"] = 139.13, ["Neon"] = 137.72, ["Neon|Ride"] = 162.37, ["Neon|Fly|Ride"] = 204.5, ["Mega|Ride"] = 929.56, ["Mega|Fly|Ride"] = 949.47}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 11.58}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 7.87, ["Ride"] = 29.22, ["Neon"] = 49.34, ["Neon|Ride"] = 55.51, ["Mega|Fly|Ride"] = 822.05}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2969.9}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 148.32, ["Fly"] = 281.56, ["Ride"] = 199.5, ["Fly|Ride"] = 478.92, ["Neon"] = 701.37, ["Neon|Ride"] = 846.83, ["Neon|Fly|Ride"] = 754.24, ["Mega|Fly|Ride"] = 3014.84}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 97.11, ["Ride"] = 196.88, ["Fly|Ride"] = 287.77, ["Neon"] = 607.35, ["Neon|Ride"] = 619.85, ["Neon|Fly|Ride"] = 1435.35, ["Mega|Ride"] = 2740.48, ["Mega|Fly|Ride"] = 3098.89}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 167.99, ["Fly"] = 186.62, ["Ride"] = 196.88, ["Fly|Ride"] = 236.25, ["Neon"] = 897.75, ["Neon|Fly"] = 956.78, ["Neon|Ride"] = 842.63, ["Neon|Fly|Ride"] = 921.5, ["Mega|Fly|Ride"] = 3830.7}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1640.52, ["Fly"] = 2466.12, ["Ride"] = 1574.99, ["Fly|Ride"] = 1700.9, ["Neon|Ride"] = 6438.6, ["Neon|Fly|Ride"] = 4331.25, ["Mega|Fly|Ride"] = 30826.32}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 15.75, ["Fly"] = 80.16, ["Ride"] = 39.41, ["Fly|Ride"] = 93.53, ["Neon"] = 155.19, ["Neon|Ride"] = 203.47, ["Neon|Fly|Ride"] = 322.88, ["Mega"] = 923.78, ["Mega|Ride"] = 890.89, ["Mega|Fly|Ride"] = 1079.96}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 786.19, ["Fly"] = 2100, ["Ride"] = 678.43, ["Fly|Ride"] = 883.81, ["Neon|Fly|Ride"] = 4028.43}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 44.17}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 13.13, ["Ride"] = 48.3, ["Fly|Ride"] = 681.8, ["Neon"] = 99.75, ["Neon|Ride"] = 123.53, ["Neon|Fly|Ride"] = 273.34, ["Mega"] = 465.84, ["Mega|Ride"] = 457.94, ["Mega|Fly|Ride"] = 548.72}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 6.56, ["Fly"] = 262.5, ["Ride"] = 19.69, ["Fly|Ride"] = 94.81, ["Neon"] = 55.51, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 308.28, ["Mega|Fly|Ride"] = 620.48}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 53.69}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 19.69, ["Fly"] = 108.92, ["Ride"] = 31.28, ["Fly|Ride"] = 55.51, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 192.18, ["Mega"] = 918.75, ["Mega|Ride"] = 1239.8, ["Mega|Fly|Ride"] = 822.05}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 26.25, ["Fly"] = 76.06, ["Ride"] = 32.82, ["Fly|Ride"] = 52.07, ["Neon|Ride"] = 303.14, ["Neon|Fly|Ride"] = 411.03, ["Mega"] = 820, ["Mega|Ride"] = 1742.91, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 5577.21, ["Fly"] = 10960.83, ["Ride"] = 4987.5, ["Fly|Ride"] = 4927.13, ["Neon|Fly|Ride"] = 10500, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 9.09, ["Fly"] = 46.41, ["Ride"] = 35.34, ["Fly|Ride"] = 47.25, ["Neon"] = 66.08, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 178.81, ["Mega"] = 520.56, ["Mega|Ride"] = 512.43, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 23.63}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 99.75, ["Fly"] = 363.77, ["Ride"] = 78.75, ["Fly|Ride"] = 131.25, ["Neon"] = 485.63, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 698.74, ["Mega"] = 2879.59, ["Mega|Fly|Ride"] = 1850.37}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 59.04, ["Fly"] = 96.48, ["Ride"] = 77.09, ["Fly|Ride"] = 152.25, ["Neon"] = 328.88, ["Neon|Ride"] = 353.07, ["Neon|Fly|Ride"] = 315.47, ["Mega"] = 2323.88, ["Mega|Ride"] = 2774.39, ["Mega|Fly|Ride"] = 1450.91}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 24.86, ["Fly"] = 70.45, ["Ride"] = 31.87, ["Fly|Ride"] = 59.13, ["Neon"] = 201.45, ["Neon|Ride"] = 121.58, ["Neon|Fly|Ride"] = 204.37, ["Mega"] = 1016.21, ["Mega|Ride"] = 739.85, ["Mega|Fly|Ride"] = 656.23}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 5.24, ["Fly"] = 58.58, ["Ride"] = 27.56, ["Fly|Ride"] = 49.34, ["Neon"] = 31.5, ["Neon|Fly"] = 328.13, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 124.68, ["Mega"] = 157.49, ["Mega|Fly"] = 918.75, ["Mega|Ride"] = 216.98, ["Mega|Fly|Ride"] = 297.94}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 13.12, ["Fly"] = 137.7, ["Ride"] = 27.84, ["Fly|Ride"] = 88.39, ["Neon"] = 93.53, ["Neon|Ride"] = 122.3, ["Neon|Fly|Ride"] = 137.7, ["Mega"] = 512.76, ["Mega|Ride"] = 508.65, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 26.25, ["Fly"] = 30.19, ["Ride"] = 27.44, ["Fly|Ride"] = 49.96, ["Neon"] = 203.49, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 131.25, ["Mega|Fly|Ride"] = 480.38}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 203.44}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 20.56, ["Ride"] = 96.86, ["Neon"] = 177.19, ["Mega"] = 525, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 626.75}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 205.52, ["Fly"] = 263.74, ["Ride"] = 443.63, ["Neon"] = 1096.54}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 31.5, ["Fly"] = 212.01, ["Ride"] = 102.78, ["Fly|Ride"] = 170.62, ["Neon"] = 249.36, ["Neon|Ride"] = 385.88, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 1301.91, ["Mega|Ride"] = 2146.1, ["Mega|Fly|Ride"] = 1249.5}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 917.44, ["Fly"] = 1152.97, ["Ride"] = 913.5, ["Fly|Ride"] = 945, ["Neon|Ride"] = 2671.62, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 11025}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 288.74, ["Fly"] = 685.38, ["Ride"] = 341.25, ["Fly|Ride"] = 393.74, ["Neon"] = 2877.5, ["Neon|Ride"] = 2055.11, ["Neon|Fly|Ride"] = 1919.47, ["Mega"] = 8117.61, ["Mega|Fly|Ride"] = 6040.91}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 59.72}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 3.26}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 14.44, ["Fly"] = 27.76, ["Ride"] = 23.54, ["Fly|Ride"] = 43.32, ["Neon"] = 78.73, ["Neon|Fly"] = 116.2, ["Neon|Ride"] = 68.87, ["Neon|Fly|Ride"] = 137.7, ["Mega"] = 437.26, ["Mega|Ride"] = 684.36, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 288.74, ["Fly"] = 762.36, ["Ride"] = 310.55, ["Fly|Ride"] = 391.13, ["Neon"] = 1027.69, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1014.57, ["Mega|Fly|Ride"] = 2756.25}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 18.51}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 117.16, ["Fly"] = 590.63, ["Ride"] = 213.94, ["Fly|Ride"] = 319.33, ["Neon"] = 808.12, ["Neon|Fly"] = 1644.28, ["Neon|Ride"] = 708.75, ["Neon|Fly|Ride"] = 1339.94, ["Mega"] = 3082.65, ["Mega|Ride"] = 2944.35, ["Mega|Fly|Ride"] = 2579.68}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 105, ["Ride"] = 131.25, ["Fly|Ride"] = 157.5, ["Neon"] = 672.12, ["Neon|Ride"] = 1005.38, ["Neon|Fly|Ride"] = 924.81}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 5.18, ["Ride"] = 29.81, ["Fly|Ride"] = 73.21, ["Neon"] = 30.19, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 264.75, ["Mega|Ride"] = 178.81, ["Mega|Fly|Ride"] = 801.5}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 15.43, ["Fly"] = 63, ["Ride"] = 27.9, ["Fly|Ride"] = 76.27, ["Neon"] = 177.19, ["Neon|Ride"] = 109.96, ["Neon|Fly|Ride"] = 152.1, ["Mega|Ride"] = 799.44, ["Mega|Fly|Ride"] = 577.49}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 15.75, ["Fly"] = 102.31, ["Ride"] = 32.9, ["Fly|Ride"] = 128.84, ["Neon"] = 137.72, ["Neon|Ride"] = 130.87, ["Neon|Fly|Ride"] = 184.97, ["Mega"] = 457.1, ["Mega|Ride"] = 483.68, ["Mega|Fly|Ride"] = 684.36}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 4.66, ["Fly"] = 78.75, ["Ride"] = 49.87, ["Fly|Ride"] = 170.29, ["Neon"] = 23.94, ["Neon|Fly"] = 68.87, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 155.27, ["Mega"] = 153.55, ["Mega|Fly"] = 236.35, ["Mega|Ride"] = 190.32, ["Mega|Fly|Ride"] = 258.14}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 246.75, ["Ride"] = 301.88, ["Fly|Ride"] = 262.5, ["Neon"] = 1603.19, ["Neon|Ride"] = 1500.41, ["Neon|Fly|Ride"] = 1286.38, ["Mega|Fly|Ride"] = 5206.58}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 125.78, ["Fly"] = 1050, ["Ride"] = 203.34, ["Fly|Ride"] = 334.62, ["Neon"] = 821.13, ["Neon|Ride"] = 878.56, ["Neon|Fly|Ride"] = 838.69, ["Mega"] = 2625, ["Mega|Ride"] = 2625, ["Mega|Fly|Ride"] = 2856.59}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 62.99, ["Fly"] = 167.45, ["Ride"] = 94.55, ["Fly|Ride"] = 196.88, ["Neon"] = 359.7, ["Neon|Ride"] = 411.03, ["Neon|Fly|Ride"] = 477.53, ["Mega|Fly|Ride"] = 1509.67}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 13.02, ["Ride"] = 58.24, ["Fly|Ride"] = 246.65, ["Neon|Ride"] = 590.27, ["Neon|Fly|Ride"] = 479.89, ["Mega|Ride"] = 616.54, ["Mega|Fly|Ride"] = 1644.08}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 15.6, ["Fly"] = 75.63, ["Ride"] = 34.88, ["Fly|Ride"] = 105, ["Neon"] = 77.44, ["Neon|Fly"] = 205.55, ["Neon|Ride"] = 99.47, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 343.22, ["Mega|Fly"] = 525, ["Mega|Ride"] = 295.32, ["Mega|Fly|Ride"] = 450.21}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 2.63, ["Fly"] = 47.29, ["Ride"] = 18.38, ["Fly|Ride"] = 81.2, ["Neon"] = 19.37, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 130.52, ["Mega"] = 131.24, ["Mega|Ride"] = 147, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 936.78, ["Fly"] = 1082.72, ["Ride"] = 931.88, ["Fly|Ride"] = 992.25, ["Neon"] = 3043.93, ["Neon|Fly"] = 3408.74, ["Neon|Ride"] = 2852.62, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 7377.36}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 360.94, ["Ride"] = 412.13, ["Fly|Ride"] = 522.38, ["Neon|Ride"] = 2740.48, ["Neon|Fly|Ride"] = 1922.33, ["Mega"] = 10275.45, ["Mega|Fly|Ride"] = 6561.19}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 62.76, ["Ride"] = 103.69, ["Fly|Ride"] = 182.95, ["Neon"] = 343.25, ["Neon|Ride"] = 301.46, ["Neon|Fly|Ride"] = 388.1, ["Mega|Ride"] = 1644.08, ["Mega|Fly|Ride"] = 1733.48}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 178.81, ["Ride"] = 291.62, ["Fly|Ride"] = 275.63, ["Neon|Fly|Ride"] = 1919.47, ["Mega"] = 10275.45, ["Mega|Fly|Ride"] = 4932.22}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 19.69, ["Fly"] = 137.7, ["Ride"] = 28.88, ["Fly|Ride"] = 71.5, ["Neon"] = 124.69, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 236.25, ["Mega|Fly|Ride"] = 766.89}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 220.88, ["Ride"] = 278.64, ["Fly|Ride"] = 393.75, ["Neon"] = 878.68, ["Neon|Ride"] = 878.56, ["Neon|Fly|Ride"] = 914.46, ["Mega"] = 4089.93, ["Mega|Ride"] = 4247.88, ["Mega|Fly|Ride"] = 3818.31}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 59.82, ["Fly"] = 76.13, ["Ride"] = 32.82, ["Fly|Ride"] = 52.5, ["Neon|Ride"] = 575.16, ["Neon|Fly|Ride"] = 548.72, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1674.75, ["Ride"] = 1666.92, ["Fly|Ride"] = 1688.09, ["Neon|Ride"] = 10845.49, ["Neon|Fly|Ride"] = 5029.84, ["Mega"] = 49322.13, ["Mega|Fly|Ride"] = 21783.95}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 15.43, ["Fly"] = 64.76, ["Ride"] = 41.11, ["Fly|Ride"] = 96.63, ["Neon"] = 47.25, ["Neon|Fly"] = 178.83, ["Neon|Ride"] = 100.33, ["Neon|Fly|Ride"] = 217.3, ["Mega"] = 248.69, ["Mega|Fly"] = 561.75, ["Mega|Ride"] = 325.5, ["Mega|Fly|Ride"] = 443.89}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 38.07, ["Fly"] = 119.1, ["Ride"] = 78.96, ["Fly|Ride"] = 160.13, ["Neon"] = 262.5, ["Neon|Ride"] = 278.49, ["Neon|Fly|Ride"] = 304.5, ["Mega"] = 817.94, ["Mega|Ride"] = 1005.98, ["Mega|Fly|Ride"] = 775.02}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 62.99, ["Fly"] = 91.85, ["Ride"] = 91.88, ["Fly|Ride"] = 103.92, ["Neon|Ride"] = 411.03, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3423.79, ["Ride"] = 2316.57, ["Fly|Ride"] = 1312.49, ["Mega|Fly|Ride"] = 23238.64}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 480.77, ["Fly"] = 820, ["Ride"] = 594.97, ["Fly|Ride"] = 548.8, ["Neon|Fly|Ride"] = 2711.96, ["Mega|Fly|Ride"] = 17043.22}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 91.86, ["Ride"] = 142.85, ["Fly|Ride"] = 131.25, ["Neon"] = 444.29, ["Neon|Fly"] = 616.62, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 548.72, ["Mega"] = 4110.2, ["Mega|Ride"] = 4110.2, ["Mega|Fly|Ride"] = 2055.11}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.49, ["Fly"] = 41.11, ["Ride"] = 27.76, ["Fly|Ride"] = 91.68, ["Neon"] = 39.38, ["Neon|Fly"] = 137.72, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 747.53, ["Mega|Fly|Ride"] = 1233.07}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 46.49, ["Ride"] = 48.43, ["Fly|Ride"] = 122.73, ["Neon"] = 204.75, ["Neon|Fly"] = 411.08, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 1334.8, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 721.88, ["Ride"] = 824.25, ["Fly|Ride"] = 785.53, ["Neon"] = 3013.15, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2508.42, ["Mega|Fly|Ride"] = 15072.02}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 787.5}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 5250, ["Ride"] = 5398.73, ["Fly|Ride"] = 4462.5, ["Neon"] = 42000, ["Neon|Ride"] = 29450.45, ["Neon|Fly|Ride"] = 23825.67, ["Mega|Fly|Ride"] = 87684.44}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 189, ["Fly"] = 406.82, ["Ride"] = 294.92, ["Fly|Ride"] = 367.5, ["Neon"] = 1644.28, ["Neon|Fly|Ride"] = 2055.11, ["Mega"] = 5754.27, ["Mega|Fly|Ride"] = 5891.95}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 83.6, ["Ride"] = 82.22, ["Fly|Ride"] = 336, ["Neon"] = 397.72, ["Neon|Ride"] = 589.82, ["Neon|Fly|Ride"] = 1370.76, ["Mega|Fly|Ride"] = 2862.75}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 15.43, ["Fly"] = 96.6, ["Ride"] = 27.57, ["Fly|Ride"] = 71.95, ["Neon"] = 146, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 238.41, ["Mega"] = 656.61, ["Mega|Ride"] = 616.54, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 20.56, ["Fly"] = 39.38, ["Ride"] = 26.97, ["Fly|Ride"] = 49.87, ["Neon"] = 204.71, ["Neon|Fly"] = 274.4, ["Neon|Ride"] = 310.25, ["Neon|Fly|Ride"] = 134.63, ["Mega"] = 1312.5, ["Mega|Ride"] = 1584.49, ["Mega|Fly|Ride"] = 2178.41}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 15.75, ["Fly"] = 274.37, ["Ride"] = 37.19, ["Fly|Ride"] = 131.25, ["Neon"] = 105, ["Neon|Ride"] = 156.18, ["Neon|Fly|Ride"] = 147.98, ["Mega"] = 548.72, ["Mega|Ride"] = 513.19, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.72, ["Fly"] = 76.06, ["Ride"] = 19.69, ["Fly|Ride"] = 57.75, ["Neon"] = 23.04, ["Neon|Fly"] = 339.14, ["Neon|Ride"] = 46.49, ["Neon|Fly|Ride"] = 185.93, ["Mega"] = 217.86, ["Mega|Ride"] = 217.86, ["Mega|Fly|Ride"] = 357}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 26.25, ["Ride"] = 51.19, ["Fly|Ride"] = 183.75, ["Neon"] = 189.1, ["Neon|Fly"] = 822.14, ["Neon|Ride"] = 155.72, ["Neon|Fly|Ride"] = 306.22, ["Mega"] = 656.61, ["Mega|Ride"] = 1239, ["Mega|Fly|Ride"] = 959.75}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 341.16, ["Fly"] = 439.17, ["Ride"] = 295.31, ["Fly|Ride"] = 418.58, ["Neon"] = 1141.88, ["Neon|Fly"] = 1455.2, ["Neon|Ride"] = 1165.24, ["Neon|Fly|Ride"] = 1147.13, ["Mega"] = 7875, ["Mega|Fly"] = 4314.68, ["Mega|Ride"] = 3837.89, ["Mega|Fly|Ride"] = 4384.55}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.14, ["Fly"] = 19.69, ["Ride"] = 15.75, ["Fly|Ride"] = 45.23, ["Neon"] = 19.66, ["Neon|Ride"] = 34.96, ["Neon|Fly|Ride"] = 69.35, ["Mega"] = 822.05, ["Mega|Ride"] = 205.52, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 39.24, ["Fly"] = 88.26, ["Ride"] = 65.62, ["Fly|Ride"] = 135.68, ["Neon"] = 190.32, ["Neon|Fly"] = 287.77, ["Neon|Ride"] = 190.32, ["Neon|Fly|Ride"] = 247.87, ["Mega"] = 510.57, ["Mega|Fly"] = 822.05, ["Mega|Ride"] = 544.69, ["Mega|Fly|Ride"] = 610.19}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 764.1, ["Fly"] = 952.67, ["Ride"] = 761.25, ["Fly|Ride"] = 787.5, ["Neon|Ride"] = 1603.88, ["Neon|Fly|Ride"] = 1438.5, ["Mega|Fly|Ride"] = 4079.27}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 34.12, ["Fly"] = 91.88, ["Ride"] = 44.15, ["Fly|Ride"] = 81.38, ["Neon|Ride"] = 189, ["Neon|Fly|Ride"] = 262.4, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 748.13}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 356.57, ["Fly"] = 324.84, ["Ride"] = 301.77, ["Fly|Ride"] = 301.88, ["Neon|Fly|Ride"] = 1095.39, ["Mega|Fly|Ride"] = 6850.66}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 145.67, ["Fly"] = 204.5, ["Ride"] = 157.5, ["Fly|Ride"] = 170.62, ["Neon"] = 627.29, ["Neon|Ride"] = 713.13, ["Neon|Fly|Ride"] = 630.93, ["Mega|Fly|Ride"] = 3247.05}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 656.25, ["Ride"] = 656.25, ["Fly|Ride"] = 767.96, ["Neon|Ride"] = 2589.42, ["Neon|Fly|Ride"] = 2452.77, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 19.69, ["Ride"] = 40.6, ["Fly|Ride"] = 91.81, ["Neon"] = 78.08, ["Neon|Fly"] = 278.84, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 269.58, ["Mega"] = 326.78, ["Mega|Ride"] = 353.96, ["Mega|Fly|Ride"] = 508.65}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4084.49, ["Ride"] = 3018.75, ["Fly|Ride"] = 2953.13, ["Neon"] = 8520.66, ["Neon|Fly|Ride"] = 6562.5, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 105, ["Fly"] = 131.24, ["Ride"] = 107.63, ["Fly|Ride"] = 188.35, ["Neon"] = 453.22, ["Neon|Ride"] = 517.9, ["Neon|Fly|Ride"] = 419.47, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.63, ["Fly"] = 20.55, ["Ride"] = 18.43, ["Fly|Ride"] = 43.18, ["Neon"] = 23.51, ["Neon|Fly"] = 85.98, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 135.64, ["Mega"] = 196.88, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.94, ["Ride"] = 27.76, ["Fly|Ride"] = 58.1, ["Neon"] = 24.92, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 156.1, ["Mega|Ride"] = 199.48, ["Mega|Fly|Ride"] = 238.56}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 36.89, ["Fly"] = 152.1, ["Ride"] = 39.38, ["Fly|Ride"] = 44.56, ["Neon|Ride"] = 287.74, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1128.75}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 971.25, ["Ride"] = 1430.54, ["Fly|Ride"] = 1295.44}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 5775, ["Ride"] = 6970.66, ["Fly|Ride"] = 6299.99}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 25.11, ["Fly"] = 41.11, ["Ride"] = 26.84, ["Fly|Ride"] = 51.57, ["Neon|Ride"] = 144.8, ["Neon|Fly|Ride"] = 171.62, ["Mega"] = 2428.13, ["Mega|Fly|Ride"] = 761.25}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 15.75, ["Fly"] = 44.63, ["Ride"] = 31.87, ["Fly|Ride"] = 68.87, ["Neon"] = 94.4, ["Neon|Ride"] = 92.21, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 655.54, ["Mega|Ride"] = 612.35, ["Mega|Fly|Ride"] = 500}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 72.12, ["Fly"] = 157.49, ["Ride"] = 62.88, ["Fly|Ride"] = 104.99, ["Neon"] = 459.37, ["Neon|Ride"] = 339.1, ["Neon|Fly|Ride"] = 305.82, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 236.25, ["Fly"] = 310.21, ["Ride"] = 223.13, ["Fly|Ride"] = 310.22, ["Neon|Ride"] = 977.79, ["Neon|Fly|Ride"] = 1068.66, ["Mega"] = 10275.45, ["Mega|Fly|Ride"] = 3409.12}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.94, ["Ride"] = 31.38, ["Fly|Ride"] = 86.63, ["Neon"] = 20.79, ["Neon|Fly"] = 656.24, ["Neon|Ride"] = 52.5, ["Mega"] = 137.82, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 310.25}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 180.73, ["Fly"] = 328.8, ["Ride"] = 240.22, ["Fly|Ride"] = 328.13, ["Neon"] = 923.89, ["Neon|Ride"] = 910.97, ["Neon|Fly|Ride"] = 918.75, ["Mega|Ride"] = 3485.81, ["Mega|Fly|Ride"] = 3549.15}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 4.13, ["Fly"] = 33.71, ["Ride"] = 19.69, ["Fly|Ride"] = 49.97, ["Neon"] = 23.13, ["Neon|Fly"] = 123.03, ["Neon|Ride"] = 34.96, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 256.79, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 249.61}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 203.44, ["Fly"] = 243.98, ["Ride"] = 246.65, ["Fly|Ride"] = 241.5, ["Neon|Ride"] = 1096.4, ["Neon|Fly|Ride"] = 1115.63, ["Mega"] = 10275.45, ["Mega|Ride"] = 4110.2, ["Mega|Fly|Ride"] = 4083.48}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 11.82, ["Fly"] = 70.4, ["Ride"] = 26.79, ["Fly|Ride"] = 61.68, ["Neon"] = 56.56, ["Neon|Fly"] = 295.11, ["Neon|Ride"] = 97.63, ["Neon|Fly|Ride"] = 194.91, ["Mega|Ride"] = 575.45, ["Mega|Fly|Ride"] = 449.5}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.47, ["Ride"] = 20.92, ["Fly|Ride"] = 59.07, ["Neon"] = 10.4, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 44.19, ["Neon|Fly|Ride"] = 176.77, ["Mega"] = 78.75, ["Mega|Ride"] = 99.74, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.84, ["Mega"] = 32.9, ["Mega|Ride"] = 147.98}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.76, ["Fly"] = 52.48, ["Ride"] = 32.9, ["Fly|Ride"] = 205.55, ["Neon"] = 6.13, ["Neon|Ride"] = 38.31, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 68.16, ["Mega|Fly"] = 154924.97, ["Mega|Ride"] = 96.66, ["Mega|Fly|Ride"] = 159.75}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 63, ["Fly"] = 137.11, ["Ride"] = 105.46, ["Fly|Ride"] = 180.38, ["Neon"] = 264.57, ["Neon|Ride"] = 384.46, ["Neon|Fly|Ride"] = 309.74, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 33.54, ["Ride"] = 15.65, ["Fly|Ride"] = 93.37, ["Neon"] = 5.25, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 129.94, ["Mega|Ride"] = 123.16, ["Mega|Fly|Ride"] = 257.24}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 15.43, ["Ride"] = 78.75, ["Neon"] = 135.68, ["Neon|Ride"] = 160.13, ["Mega"] = 443.63, ["Mega|Ride"] = 580.99, ["Mega|Fly|Ride"] = 644.28}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.55, ["Neon|Ride"] = 44.6, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 13.13, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 85.32}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 68.86, ["Ride"] = 14.6, ["Fly|Ride"] = 33.44, ["Neon"] = 2.1, ["Neon|Fly"] = 14.43, ["Neon|Ride"] = 14.12, ["Neon|Fly|Ride"] = 44.2, ["Mega"] = 14.57, ["Mega|Fly"] = 39.38, ["Mega|Ride"] = 27.76, ["Mega|Fly|Ride"] = 48.18}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Ride"] = 15.43, ["Fly|Ride"] = 35.43, ["Neon"] = 2.63, ["Neon|Fly"] = 20.57, ["Neon|Ride"] = 15.43, ["Neon|Fly|Ride"] = 37.2, ["Mega"] = 26.25, ["Mega|Fly"] = 155.32, ["Mega|Ride"] = 38.68, ["Mega|Fly|Ride"] = 78.66}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 33.64, ["Neon"] = 2.1, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 82.22, ["Mega"] = 13.53, ["Mega|Ride"] = 146.42}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Ride"] = 18.38, ["Fly|Ride"] = 107.62, ["Neon"] = 3.94, ["Neon|Fly"] = 137.85, ["Neon|Ride"] = 20.99, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 21, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 180.08}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Fly|Ride"] = 204.5, ["Mega"] = 22.1, ["Mega|Ride"] = 92.97, ["Mega|Fly|Ride"] = 154.71}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 3.85, ["Fly"] = 65.44, ["Ride"] = 19.69, ["Fly|Ride"] = 82.23, ["Neon"] = 10.29, ["Neon|Fly"] = 59.06, ["Neon|Ride"] = 24.44, ["Neon|Fly|Ride"] = 70.21, ["Mega"] = 65.44, ["Mega|Fly"] = 190.95, ["Mega|Ride"] = 81.37, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 47.29, ["Neon"] = 2.1, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 157.37, ["Mega"] = 13.13, ["Mega|Ride"] = 36.83, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly|Ride"] = 524.99, ["Neon"] = 15.74, ["Mega"] = 137.7, ["Mega|Fly"] = 315, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 27.76, ["Neon"] = 9.83, ["Neon|Ride"] = 26.73, ["Mega"] = 139.13, ["Mega|Fly|Ride"] = 537.62}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 3.93, ["Neon|Fly"] = 27.76, ["Neon|Ride"] = 26.73, ["Neon|Fly|Ride"] = 135.64, ["Mega"] = 20.16, ["Mega|Ride"] = 54.51, ["Mega|Fly|Ride"] = 131.14}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 14.44, ["Fly|Ride"] = 30.15, ["Neon"] = 2.1, ["Neon|Fly"] = 35.32, ["Neon|Ride"] = 13.82, ["Neon|Fly|Ride"] = 30.92, ["Mega"] = 14.36, ["Mega|Fly"] = 26.25, ["Mega|Ride"] = 23.64, ["Mega|Fly|Ride"] = 45.94}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.63, ["Fly"] = 72.19, ["Ride"] = 229.68, ["Fly|Ride"] = 104.98, ["Neon"] = 31.49, ["Neon|Ride"] = 140.95, ["Mega|Ride"] = 324.72}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Fly"] = 23.63, ["Ride"] = 18.38, ["Neon"] = 2.63, ["Neon|Ride"] = 31.87, ["Neon|Fly|Ride"] = 105, ["Mega"] = 26.24, ["Mega|Fly"] = 78.75, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 109.96}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 6.57, ["Neon"] = 11.82, ["Neon|Fly|Ride"] = 137.7, ["Mega"] = 78.75, ["Mega|Ride"] = 162.37, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.5, ["Fly"] = 262.49, ["Ride"] = 32.82, ["Fly|Ride"] = 43.32, ["Neon"] = 15.43, ["Neon|Fly|Ride"] = 145.92, ["Mega"] = 45.94, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 188.99}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 15.43, ["Fly|Ride"] = 26.17, ["Neon"] = 2.1, ["Neon|Fly"] = 15.75, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 26.24, ["Mega"] = 20.93, ["Mega|Fly"] = 28.18, ["Mega|Ride"] = 22.32, ["Mega|Fly|Ride"] = 45.94}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 27.46, ["Ride"] = 19.69, ["Fly|Ride"] = 135.68, ["Neon"] = 14.43, ["Neon|Ride"] = 111.56, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 78.75, ["Mega|Ride"] = 154.04, ["Mega|Fly|Ride"] = 274.37}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 3.51, ["Fly"] = 41.11, ["Ride"] = 32.82, ["Fly|Ride"] = 58.46, ["Neon"] = 72.98, ["Neon|Ride"] = 48.09, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 236.25, ["Mega|Ride"] = 288.46, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 15.43, ["Ride"] = 11.82, ["Fly|Ride"] = 26.17, ["Neon"] = 3.93, ["Neon|Fly"] = 23.62, ["Neon|Ride"] = 15.43, ["Neon|Fly|Ride"] = 45.04, ["Mega"] = 23.25, ["Mega|Fly"] = 1312.5, ["Mega|Ride"] = 61.66, ["Mega|Fly|Ride"] = 98.14}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 3.93, ["Fly"] = 171.62, ["Ride"] = 31.5, ["Neon"] = 7.87, ["Neon|Ride"] = 41.11, ["Neon|Fly|Ride"] = 97.06, ["Mega"] = 39.11, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 262.47}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 26.73, ["Fly|Ride"] = 82.23, ["Neon"] = 5.86, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 310.25, ["Mega"] = 40.08, ["Mega|Ride"] = 137.7, ["Mega|Fly|Ride"] = 155.72}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.72, ["Neon"] = 2.1, ["Neon|Fly"] = 41.03, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 96.6, ["Mega"] = 14.44, ["Mega|Ride"] = 34.13, ["Mega|Fly|Ride"] = 121.27}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 18.38, ["Fly|Ride"] = 42, ["Neon"] = 7.87, ["Neon|Fly"] = 52.02, ["Neon|Ride"] = 19.07, ["Neon|Fly|Ride"] = 75.48, ["Mega"] = 78.89, ["Mega|Ride"] = 81.38, ["Mega|Fly|Ride"] = 232.4}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 68.25, ["Neon"] = 3.88, ["Neon|Ride"] = 43.31, ["Mega"] = 39.38, ["Mega|Fly|Ride"] = 249.37}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 28.77, ["Ride"] = 15.75, ["Fly|Ride"] = 47.25, ["Neon"] = 2.63, ["Neon|Fly"] = 79.98, ["Neon|Ride"] = 19.84, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 91.87, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 123.38}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 7.88, ["Ride"] = 39.38, ["Neon"] = 36.31, ["Neon|Fly"] = 188.89, ["Mega"] = 124.26, ["Mega|Ride"] = 205.52, ["Mega|Fly|Ride"] = 822.05}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 16.4, ["Fly|Ride"] = 82.23, ["Neon"] = 17.07, ["Neon|Fly"] = 104.16, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 210, ["Mega|Ride"] = 145.48, ["Mega|Fly|Ride"] = 332.94}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 7.76, ["Fly"] = 22.45, ["Ride"] = 19.55, ["Fly|Ride"] = 39, ["Neon"] = 15.75, ["Neon|Fly"] = 17.07, ["Neon|Ride"] = 28.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 234.02, ["Mega|Fly"] = 410.01, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 110.93, ["Fly|Ride"] = 137.7, ["Neon"] = 31.87, ["Mega"] = 152.1, ["Mega|Ride"] = 175.72}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 19.69, ["Ride"] = 131.25, ["Neon"] = 120.1, ["Mega|Ride"] = 670.22, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 3.93, ["Ride"] = 64.89, ["Neon"] = 39.1, ["Neon|Ride"] = 125.71, ["Mega"] = 221.96, ["Mega|Ride"] = 230.07}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 5.48, ["Ride"] = 34.97, ["Fly|Ride"] = 152.11, ["Neon"] = 47.76, ["Neon|Ride"] = 64.42, ["Mega"] = 245.6, ["Mega|Ride"] = 280.23, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.63, ["Neon|Ride"] = 64.98, ["Mega"] = 18.38, ["Mega|Ride"] = 137.7, ["Mega|Fly|Ride"] = 143.88}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 47.13}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 9.19, ["Fly"] = 21.95, ["Ride"] = 20.56, ["Fly|Ride"] = 40.68, ["Neon"] = 36.75, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 102.75, ["Mega"] = 306.22, ["Mega|Fly"] = 328.82, ["Mega|Ride"] = 276.55, ["Mega|Fly|Ride"] = 252.94}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.54, ["Neon"] = 2.88, ["Neon|Ride"] = 26.61, ["Mega"] = 27.75, ["Mega|Ride"] = 55.12, ["Mega|Fly|Ride"] = 90.96}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 23.65, ["Fly|Ride"] = 274.4, ["Neon"] = 6.57, ["Neon|Ride"] = 35.32, ["Neon|Fly|Ride"] = 404.88, ["Mega"] = 38.07, ["Mega|Ride"] = 66.94, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 4.11, ["Fly"] = 48.3, ["Ride"] = 19.53, ["Fly|Ride"] = 47.29, ["Neon"] = 7.16, ["Neon|Ride"] = 47.66, ["Neon|Fly|Ride"] = 117.06, ["Mega"] = 125.23, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 161.65}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.72, ["Ride"] = 40.44, ["Fly|Ride"] = 58.59, ["Neon"] = 28.87, ["Neon|Ride"] = 82.22, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 328.13, ["Mega|Ride"] = 291.84, ["Mega|Fly|Ride"] = 411.03}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 32.81, ["Neon"] = 3.68, ["Neon|Ride"] = 48.3, ["Neon|Fly|Ride"] = 105, ["Mega"] = 15.1, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 65.54}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 18.51, ["Ride"] = 17.07, ["Fly|Ride"] = 274046.19, ["Neon"] = 6.19, ["Neon|Fly"] = 68.87, ["Neon|Ride"] = 20.56, ["Neon|Fly|Ride"] = 69.35, ["Mega"] = 28.88, ["Mega|Fly"] = 143.16, ["Mega|Ride"] = 47.25, ["Mega|Fly|Ride"] = 104.89}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 27.37, ["Ride"] = 18.38, ["Fly|Ride"] = 34.13, ["Neon"] = 7.86, ["Neon|Fly"] = 102.78, ["Neon|Ride"] = 15.64, ["Neon|Fly|Ride"] = 52.48, ["Mega"] = 31.49, ["Mega|Ride"] = 51.34, ["Mega|Fly|Ride"] = 158.29}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 210, ["Ride"] = 47.25, ["Fly|Ride"] = 138.27, ["Neon"] = 3.91, ["Neon|Ride"] = 33.12, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 24.61, ["Mega|Fly"] = 102.77, ["Mega|Ride"] = 70.17, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 164.38, ["Neon|Fly|Ride"] = 122.3, ["Mega"] = 35.44, ["Mega|Fly"] = 106.32, ["Mega|Ride"] = 86.63, ["Mega|Fly|Ride"] = 199.36}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 32.43, ["Ride"] = 18.17, ["Fly|Ride"] = 77.1, ["Neon"] = 3.94, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 77.87, ["Mega"] = 22.32, ["Mega|Ride"] = 35.44, ["Mega|Fly|Ride"] = 118.02}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 2.1, ["Mega"] = 13.79, ["Mega|Ride"] = 123.32}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.35, ["Neon|Ride"] = 155.6, ["Neon|Fly|Ride"] = 420, ["Mega"] = 20.99, ["Mega|Ride"] = 123.15}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 15.43, ["Fly|Ride"] = 49.87, ["Neon"] = 4.13, ["Neon|Ride"] = 19.53, ["Neon|Fly|Ride"] = 37.01, ["Mega"] = 26.24, ["Mega|Ride"] = 55.12, ["Mega|Fly|Ride"] = 155.72}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 20.56, ["Ride"] = 137.54, ["Neon"] = 180.88, ["Neon|Fly|Ride"] = 411.34, ["Mega"] = 1027.56, ["Mega|Ride"] = 426.57, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 3.94, ["Fly"] = 6562.5, ["Ride"] = 68.25, ["Neon"] = 49.26, ["Neon|Ride"] = 203.47, ["Mega"] = 1564.97, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 7.6, ["Fly"] = 26.25, ["Ride"] = 26.24, ["Fly|Ride"] = 410.92, ["Neon"] = 26.69, ["Neon|Ride"] = 131.25, ["Mega"] = 295.25, ["Mega|Ride"] = 261.01, ["Mega|Fly|Ride"] = 365.3}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 12.55, ["Ride"] = 12.85, ["Fly|Ride"] = 23.63, ["Neon"] = 2.1, ["Neon|Fly"] = 14.58, ["Neon|Ride"] = 12.34, ["Neon|Fly|Ride"] = 31.5, ["Mega"] = 14.44, ["Mega|Fly"] = 32.9, ["Mega|Ride"] = 22.3, ["Mega|Fly|Ride"] = 55.13}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 65.63, ["Neon"] = 15.75, ["Neon|Fly"] = 89.87, ["Neon|Ride"] = 31.87, ["Neon|Fly|Ride"] = 685.38, ["Mega"] = 85.31, ["Mega|Ride"] = 114.07}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 13.13, ["Neon"] = 2.1, ["Neon|Fly"] = 30.85, ["Neon|Ride"] = 15.43, ["Neon|Fly|Ride"] = 77.09, ["Mega"] = 13.13, ["Mega|Fly"] = 114.07, ["Mega|Fly|Ride"] = 103.59}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Ride"] = 91.81, ["Neon"] = 2.1, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 102.77, ["Mega"] = 18.38, ["Mega|Fly|Ride"] = 152.1}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 34.08, ["Ride"] = 15.75, ["Fly|Ride"] = 45.9, ["Neon"] = 11.7, ["Neon|Fly"] = 65.6, ["Neon|Ride"] = 46.5, ["Neon|Fly|Ride"] = 102.77, ["Mega"] = 183.65, ["Mega|Ride"] = 192.18, ["Mega|Fly|Ride"] = 343.22}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 173.44, ["Ride"] = 246.65, ["Fly|Ride"] = 325.33, ["Neon"] = 1050, ["Neon|Ride"] = 822.94, ["Neon|Fly|Ride"] = 1008.03, ["Mega"] = 8220.37, ["Mega|Fly|Ride"] = 3412.49}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 27.76, ["Neon"] = 6.99, ["Neon|Ride"] = 82.22, ["Mega"] = 62.37, ["Mega|Ride"] = 92.97, ["Mega|Fly|Ride"] = 624.88}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 6.23, ["Fly"] = 62.39, ["Ride"] = 24.8, ["Neon"] = 26.73, ["Neon|Ride"] = 164.29, ["Neon|Fly|Ride"] = 155.17, ["Mega"] = 354.38, ["Mega|Fly|Ride"] = 397.67}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 822.05, ["Ride"] = 15.27, ["Fly|Ride"] = 30.19, ["Neon"] = 6.36, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 61.66, ["Mega"] = 49.66, ["Mega|Ride"] = 79.75, ["Mega|Fly|Ride"] = 136.5}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 19.68, ["Fly|Ride"] = 92.54, ["Neon"] = 5.25, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 96.45, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.14, ["Fly"] = 17.75, ["Ride"] = 16.46, ["Fly|Ride"] = 35.42, ["Neon"] = 23.63, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 71.82, ["Mega|Ride"] = 261.01, ["Mega|Fly|Ride"] = 411.03}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.69, ["Ride"] = 34.01, ["Fly|Ride"] = 249.58, ["Neon"] = 45.94, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 610.38, ["Mega"] = 257.25, ["Mega|Ride"] = 306.22, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.58, ["Fly"] = 19.55, ["Ride"] = 15.16, ["Fly|Ride"] = 36.21, ["Neon"] = 18.17, ["Neon|Fly"] = 41.12, ["Neon|Ride"] = 35.98, ["Neon|Fly|Ride"] = 74.82, ["Mega|Ride"] = 205.52, ["Mega|Fly|Ride"] = 203.76}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 68.86, ["Fly"] = 168.53, ["Ride"] = 93.19, ["Fly|Ride"] = 137.72, ["Neon"] = 411.08, ["Neon|Fly"] = 410.82, ["Neon|Ride"] = 380.63, ["Neon|Fly|Ride"] = 383.25, ["Mega|Fly|Ride"] = 1644.57}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 196.88, ["Fly"] = 328.82, ["Ride"] = 183.75, ["Fly|Ride"] = 274.4, ["Neon"] = 1007.29, ["Neon|Ride"] = 1438.58, ["Neon|Fly|Ride"] = 959.75, ["Mega"] = 10275.45, ["Mega|Fly|Ride"] = 3960.17}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 68.86, ["Fly"] = 137.67, ["Ride"] = 78.75, ["Fly|Ride"] = 133.61, ["Neon"] = 411.08, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 352.55, ["Mega|Fly|Ride"] = 1322.46}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 3.94, ["Fly"] = 26.25, ["Ride"] = 26.25, ["Fly|Ride"] = 137.72, ["Neon"] = 24.94, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 233.26, ["Mega|Ride"] = 374.06, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 12.5, ["Fly"] = 68.86, ["Ride"] = 19.53, ["Fly|Ride"] = 89.25, ["Neon"] = 42, ["Neon|Ride"] = 135.64, ["Mega"] = 343.22, ["Mega|Ride"] = 364.53, ["Mega|Fly|Ride"] = 464.46}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 18.74, ["Fly|Ride"] = 40.09, ["Neon"] = 2.63, ["Neon|Fly"] = 70.85, ["Neon|Ride"] = 17.45, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 89.25, ["Mega|Fly"] = 154.88, ["Mega|Fly|Ride"] = 178.81}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 10.5, ["Fly"] = 68.86, ["Ride"] = 27.76, ["Fly|Ride"] = 300.03, ["Neon"] = 88.4, ["Neon|Ride"] = 158.82, ["Neon|Fly|Ride"] = 136.28, ["Mega"] = 913.5, ["Mega|Ride"] = 616.54, ["Mega|Fly|Ride"] = 864.94}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.11, ["Ride"] = 16.46, ["Fly|Ride"] = 55.51, ["Neon"] = 14.44, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 27.76, ["Neon|Fly|Ride"] = 95.6, ["Mega"] = 131.25, ["Mega|Ride"] = 200.79, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.89, ["Ride"] = 23.25, ["Fly|Ride"] = 328.13, ["Neon"] = 29.82, ["Neon|Ride"] = 55.51, ["Mega"] = 207.37, ["Mega|Ride"] = 137.7, ["Mega|Fly|Ride"] = 421.87}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 34.35, ["Ride"] = 35.98, ["Neon"] = 2.1, ["Neon|Ride"] = 19.66, ["Neon|Fly|Ride"] = 47.29, ["Mega"] = 14.44, ["Mega|Fly"] = 41.11, ["Mega|Ride"] = 50.36, ["Mega|Fly|Ride"] = 209147.66}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 3.82, ["Fly"] = 19.59, ["Ride"] = 17.75, ["Fly|Ride"] = 39.38, ["Neon"] = 12.9, ["Neon|Fly"] = 102.78, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 68.86, ["Mega"] = 84, ["Mega|Ride"] = 107.98, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.4, ["Fly"] = 24.93, ["Ride"] = 18.5, ["Fly|Ride"] = 45.94, ["Neon"] = 26.25, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 109.96, ["Mega"] = 283.5, ["Mega|Ride"] = 192.18, ["Mega|Fly|Ride"] = 221.94}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 185.05, ["Fly"] = 232.37, ["Ride"] = 203.43, ["Fly|Ride"] = 250.22, ["Neon"] = 866.72, ["Neon|Ride"] = 749.36, ["Neon|Fly|Ride"] = 720.57, ["Mega|Fly|Ride"] = 2745.6}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.88, ["Ride"] = 30.83, ["Fly|Ride"] = 204.52, ["Neon"] = 49.88, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 376.56, ["Mega"] = 287.74, ["Mega|Ride"] = 369.93, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.46, ["Fly"] = 18.41, ["Ride"] = 15.75, ["Fly|Ride"] = 43.32, ["Neon"] = 23.44, ["Neon|Ride"] = 34.96, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 288.75, ["Mega|Ride"] = 213.94, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 18.38, ["Ride"] = 41.32, ["Fly|Ride"] = 170.62, ["Neon"] = 121.28, ["Neon|Ride"] = 148.32, ["Neon|Fly|Ride"] = 441.27, ["Mega"] = 453.14, ["Mega|Fly"] = 822.05, ["Mega|Ride"] = 469.88, ["Mega|Fly|Ride"] = 1027.56}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 5.97}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 3.29, ["Ride"] = 25.57, ["Neon"] = 24.2, ["Neon|Ride"] = 274.37, ["Neon|Fly|Ride"] = 616.54, ["Mega"] = 385.34, ["Mega|Ride"] = 300.57, ["Mega|Fly|Ride"] = 820}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 25.58, ["Fly"] = 77.09, ["Ride"] = 30.83, ["Fly|Ride"] = 58.44, ["Neon"] = 178.83, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 162.63, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 2055.11, ["Mega|Fly|Ride"] = 1781.77}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 78.75, ["Neon"] = 3.92, ["Neon|Ride"] = 39.36, ["Neon|Fly|Ride"] = 106.24, ["Mega"] = 33.79, ["Mega|Ride"] = 68.86, ["Mega|Fly|Ride"] = 205.52}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 3.94, ["Fly"] = 27.69, ["Ride"] = 18.6, ["Fly|Ride"] = 61.68, ["Neon"] = 45.34, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 232.4, ["Mega"] = 231.48, ["Mega|Fly"] = 388.1, ["Mega|Ride"] = 165.38}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 17.36, ["Fly|Ride"] = 46.11, ["Neon"] = 11.81, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 31.4, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 142.93, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 209.84}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 35.98, ["Fly|Ride"] = 34.9, ["Neon"] = 3.75, ["Neon|Ride"] = 30.83, ["Neon|Fly|Ride"] = 411.03, ["Mega"] = 30.19, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 197.3}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 28.86, ["Ride"] = 100.71, ["Neon"] = 250.78, ["Neon|Fly|Ride"] = 581.63, ["Mega"] = 878.56, ["Mega|Fly|Ride"] = 833.44}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.95, ["Ride"] = 59.07, ["Fly|Ride"] = 210, ["Neon"] = 68.87, ["Mega|Ride"] = 524.99}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 7.61, ["Fly"] = 19.69, ["Ride"] = 32.9, ["Fly|Ride"] = 62.48, ["Neon"] = 73.5, ["Neon|Fly"] = 464.75, ["Neon|Ride"] = 45.23, ["Neon|Fly|Ride"] = 98.66, ["Mega"] = 267.18, ["Mega|Ride"] = 315.47, ["Mega|Fly|Ride"] = 335.35}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 62.9, ["Fly"] = 433.13, ["Ride"] = 178.81, ["Fly|Ride"] = 262.44, ["Neon"] = 548.8, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 685.38, ["Mega"] = 1740.67, ["Mega|Ride"] = 2034.38, ["Mega|Fly|Ride"] = 1781.77}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 9.06, ["Fly"] = 44.17, ["Ride"] = 28.88, ["Fly|Ride"] = 62.75, ["Neon"] = 53.82, ["Neon|Ride"] = 67.59, ["Neon|Fly|Ride"] = 137.7, ["Mega"] = 215.25, ["Mega|Ride"] = 246.75, ["Mega|Fly|Ride"] = 274.37}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 70.86, ["Fly"] = 143.07, ["Ride"] = 104.19, ["Fly|Ride"] = 185.91, ["Neon"] = 205.55, ["Neon|Fly"] = 525, ["Neon|Ride"] = 213.94, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 1021.85, ["Mega|Ride"] = 1022.42, ["Mega|Fly|Ride"] = 966}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 27.57, ["Ride"] = 55.51, ["Fly|Ride"] = 131.24, ["Neon"] = 87.94, ["Neon|Ride"] = 124.07, ["Neon|Fly|Ride"] = 230.77, ["Mega"] = 343.88, ["Mega|Ride"] = 304.5, ["Mega|Fly|Ride"] = 411.03}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 10.02, ["Ride"] = 27.57, ["Fly|Ride"] = 41.12, ["Neon"] = 12.79, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 369.5, ["Mega"] = 416.96, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 19.69, ["Ride"] = 73.5, ["Fly|Ride"] = 154.76, ["Neon"] = 90.56, ["Neon|Ride"] = 110.69, ["Neon|Fly|Ride"] = 274.37, ["Mega"] = 255.2, ["Mega|Ride"] = 314.47, ["Mega|Fly|Ride"] = 527.54}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 7.23, ["Ride"] = 26.25, ["Fly|Ride"] = 135.68, ["Neon"] = 31.5, ["Neon|Ride"] = 69.57, ["Mega"] = 411.89, ["Mega|Ride"] = 308.32, ["Mega|Fly|Ride"] = 332.07}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 55.51, ["Neon|Ride"] = 56.44, ["Mega"] = 14.44, ["Mega|Fly"] = 137.7, ["Mega|Ride"] = 101.74, ["Mega|Fly|Ride"] = 405.9}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.9, ["Ride"] = 27.36, ["Neon"] = 18.76, ["Neon|Fly"] = 123.33, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 95.82, ["Mega|Ride"] = 164.42, ["Mega|Fly|Ride"] = 303.14}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.45, ["Fly"] = 62.75, ["Neon"] = 23.63, ["Mega"] = 131.25, ["Mega|Ride"] = 137.7, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 5.25, ["Ride"] = 32.79, ["Fly|Ride"] = 115.03, ["Neon"] = 17.76, ["Neon|Ride"] = 81.19, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 199.36, ["Mega|Ride"] = 274.32, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 564.36, ["Ride"] = 525, ["Fly|Ride"] = 588, ["Neon"] = 1782, ["Neon|Fly"] = 1800.81, ["Neon|Ride"] = 1507.43, ["Neon|Fly|Ride"] = 1534.19, ["Mega|Fly|Ride"] = 5890.5}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 7.79, ["Fly"] = 27.75, ["Ride"] = 23.65, ["Fly|Ride"] = 62.75, ["Neon"] = 30.19, ["Neon|Ride"] = 96.6, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 411.03, ["Mega|Fly|Ride"] = 483.38}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 9.06, ["Fly"] = 39.38, ["Ride"] = 27.57, ["Fly|Ride"] = 51.35, ["Neon"] = 76.12, ["Neon|Fly"] = 315, ["Neon|Ride"] = 52.41, ["Mega"] = 307.25, ["Mega|Ride"] = 306.2, ["Mega|Fly|Ride"] = 339.94}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.42, ["Ride"] = 18.6, ["Fly|Ride"] = 308.32, ["Neon|Ride"] = 137.7, ["Mega"] = 236.25, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 64.97, ["Ride"] = 24.35, ["Fly|Ride"] = 90.57, ["Neon"] = 8.39, ["Neon|Ride"] = 41.11, ["Neon|Fly|Ride"] = 91.77, ["Mega"] = 63, ["Mega|Fly"] = 170.63, ["Mega|Ride"] = 112.47, ["Mega|Fly|Ride"] = 209.16}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 68.86, ["Ride"] = 19.69, ["Neon"] = 2.5, ["Neon|Ride"] = 24.05, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 23.63, ["Mega|Fly"] = 192.18, ["Mega|Ride"] = 82.22, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1109.05}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 8.3, ["Ride"] = 41.11, ["Fly|Ride"] = 68.87, ["Neon"] = 65.63, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 192.18, ["Mega"] = 397.67, ["Mega|Ride"] = 411.03, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 28.26, ["Neon"] = 5.15, ["Neon|Ride"] = 40.69, ["Mega"] = 38.68, ["Mega|Ride"] = 154.14, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 58.7, ["Fly|Ride"] = 573.45, ["Neon"] = 11.11, ["Neon|Fly"] = 123.33, ["Neon|Ride"] = 205.52, ["Neon|Fly|Ride"] = 685.38, ["Mega"] = 152.1, ["Mega|Ride"] = 250.73, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 459.38, ["Ride"] = 503.49, ["Fly|Ride"] = 543.1, ["Neon|Ride"] = 1311.18, ["Neon|Fly|Ride"] = 1280.37, ["Mega|Fly|Ride"] = 7706.58}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 6.57, ["Fly"] = 196.88, ["Neon"] = 56.44, ["Neon|Ride"] = 81.38, ["Mega|Ride"] = 441.54}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 74.08, ["Ride"] = 30.85, ["Fly|Ride"] = 162.39, ["Neon"] = 6.35, ["Neon|Ride"] = 32.16, ["Neon|Fly|Ride"] = 92.97, ["Mega"] = 40.69, ["Mega|Fly"] = 189, ["Mega|Ride"] = 78.74, ["Mega|Fly|Ride"] = 229.16}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 65.54, ["Neon|Fly|Ride"] = 274.37, ["Mega"] = 27.2, ["Mega|Ride"] = 113.67, ["Mega|Fly|Ride"] = 217.86}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 13.13, ["Fly"] = 107.63, ["Ride"] = 61.68, ["Fly|Ride"] = 178.5, ["Neon"] = 102.68, ["Neon|Ride"] = 123.32, ["Neon|Fly|Ride"] = 328.82, ["Mega"] = 449.68, ["Mega|Ride"] = 397.67, ["Mega|Fly|Ride"] = 595.88}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 12, ["Neon"] = 110.16, ["Neon|Fly|Ride"] = 199.86, ["Mega"] = 421.31, ["Mega|Ride"] = 479.73, ["Mega|Fly|Ride"] = 1260.81}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 7.88, ["Fly|Ride"] = 137.72, ["Neon"] = 45.94, ["Neon|Ride"] = 175.47, ["Mega"] = 635.59, ["Mega|Ride"] = 959.75, ["Mega|Fly|Ride"] = 1233.07}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 13.13, ["Ride"] = 22.44, ["Neon"] = 118.13, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 205.52, ["Mega"] = 524.99, ["Mega|Ride"] = 616.54, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 196.88, ["Fly"] = 464.72, ["Ride"] = 431.59, ["Fly|Ride"] = 616.62, ["Neon"] = 1642.24, ["Neon|Ride"] = 1644.08, ["Neon|Fly|Ride"] = 1155, ["Mega|Ride"] = 3559.43, ["Mega|Fly|Ride"] = 3837.89}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 5.25, ["Fly"] = 69.65, ["Ride"] = 27.76, ["Fly|Ride"] = 96.63, ["Neon"] = 106.01, ["Neon|Ride"] = 137.7, ["Mega"] = 685.38, ["Mega|Ride"] = 408.98, ["Mega|Fly|Ride"] = 846.7}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.66, ["Neon"] = 35.17, ["Neon|Ride"] = 221.82, ["Mega"] = 131.25, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 775.02}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 16.89, ["Ride"] = 61.68, ["Fly|Ride"] = 256.77, ["Neon"] = 63, ["Neon|Ride"] = 122.85, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 272.35, ["Mega|Fly"] = 685.38, ["Mega|Ride"] = 283.5, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.35, ["Fly"] = 40.68, ["Ride"] = 52.5, ["Fly|Ride"] = 137.72, ["Neon"] = 6.35, ["Neon|Ride"] = 41.11, ["Neon|Fly|Ride"] = 137.7, ["Mega"] = 44.62, ["Mega|Fly"] = 105, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 38.05, ["Ride"] = 91.88, ["Fly|Ride"] = 157.5, ["Neon"] = 308.32, ["Neon|Ride"] = 303.18, ["Neon|Fly|Ride"] = 658.84, ["Mega"] = 1781.77, ["Mega|Ride"] = 1325.55, ["Mega|Fly|Ride"] = 812.43}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 56.44, ["Ride"] = 26.24, ["Neon"] = 9.17, ["Neon|Fly"] = 156.97, ["Neon|Ride"] = 41.11, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 137.7, ["Mega|Ride"] = 101.07, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 31.38, ["Ride"] = 29.89, ["Fly|Ride"] = 148.25, ["Neon"] = 4.6, ["Neon|Fly"] = 49.39, ["Neon|Ride"] = 47.24, ["Neon|Fly|Ride"] = 137.7, ["Mega"] = 39.38, ["Mega|Ride"] = 73.5, ["Mega|Fly|Ride"] = 206.84}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Fly"] = 1519.88, ["Ride"] = 31.38, ["Fly|Ride"] = 123.16, ["Neon"] = 13.01, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 78.75, ["Mega|Fly"] = 459.38, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 270.38}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 65.79, ["Ride"] = 78.74, ["Neon"] = 291.38, ["Neon|Ride"] = 509.25, ["Mega|Ride"] = 1027.56, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 288.75, ["Ride"] = 309.74, ["Fly|Ride"] = 413.44, ["Neon"] = 1428.48, ["Neon|Ride"] = 1139.14, ["Neon|Fly|Ride"] = 1036.88, ["Mega"] = 6165.28, ["Mega|Fly|Ride"] = 4957.98}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 5.2, ["Fly|Ride"] = 185.91, ["Neon"] = 26.25, ["Neon|Ride"] = 137.7, ["Mega"] = 94.5, ["Mega|Ride"] = 179.47, ["Mega|Fly|Ride"] = 310.33}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 3.94, ["Ride"] = 28.56, ["Neon"] = 20.57, ["Neon|Ride"] = 42.09, ["Neon|Fly|Ride"] = 137.7, ["Mega"] = 49.88, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 335}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.63, ["Fly"] = 30.22, ["Ride"] = 27.56, ["Fly|Ride"] = 174.72, ["Neon"] = 36.75, ["Mega"] = 373.42, ["Mega|Ride"] = 341.29, ["Mega|Fly|Ride"] = 343.22}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 3.89, ["Fly"] = 58.92, ["Ride"] = 17.07, ["Neon"] = 7.46, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 137.7, ["Mega"] = 84.36, ["Mega|Fly"] = 145.92, ["Mega|Ride"] = 109.78, ["Mega|Fly|Ride"] = 236.24}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 67.85, ["Neon"] = 9.09, ["Mega"] = 37.02, ["Mega|Fly|Ride"] = 271.28}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 16.71, ["Fly|Ride"] = 41.99, ["Neon"] = 3.94, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 97.63, ["Mega"] = 44.63, ["Mega|Ride"] = 77.09, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 137.7, ["Ride"] = 20.57, ["Fly|Ride"] = 54.49, ["Neon"] = 9.19, ["Neon|Fly"] = 62.39, ["Neon|Ride"] = 31.39, ["Neon|Fly|Ride"] = 62.76, ["Mega"] = 123.32, ["Mega|Ride"] = 231.21, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 26.25, ["Ride"] = 52.42, ["Fly|Ride"] = 77.16, ["Neon"] = 178.83, ["Neon|Fly|Ride"] = 288.18, ["Mega"] = 574.42, ["Mega|Ride"] = 478.86, ["Mega|Fly|Ride"] = 489.14}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 74.82, ["Fly"] = 123.32, ["Ride"] = 78.75, ["Fly|Ride"] = 127.45, ["Neon"] = 439.69, ["Neon|Ride"] = 389.82, ["Neon|Fly|Ride"] = 508.65, ["Mega"] = 1470, ["Mega|Ride"] = 1506.39, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Fly"] = 34.88, ["Ride"] = 23.24, ["Fly|Ride"] = 131.25, ["Neon"] = 6.57, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.56, ["Mega"] = 39.16, ["Mega|Fly"] = 672, ["Mega|Ride"] = 65.49, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 16.46, ["Ride"] = 15.73, ["Fly|Ride"] = 36.66, ["Neon"] = 5.16, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 17.45, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 55.11, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 3.1, ["Ride"] = 73.48, ["Fly|Ride"] = 131.25, ["Neon"] = 246.65, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 273.34, ["Mega"] = 274.37, ["Mega|Ride"] = 411.03, ["Mega|Fly|Ride"] = 636.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 387.19, ["Fly"] = 393.75, ["Ride"] = 541.59, ["Fly|Ride"] = 498.75, ["Neon|Ride"] = 1781.77, ["Neon|Fly|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 7192.82}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 27.57, ["Fly"] = 137.7, ["Ride"] = 55.51, ["Neon"] = 150.94, ["Neon|Ride"] = 166.76, ["Neon|Fly|Ride"] = 305.78, ["Mega|Ride"] = 1233.07, ["Mega|Fly|Ride"] = 944.98}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 281.28, ["Neon"] = 8.54, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 169.31, ["Mega"] = 89.24, ["Mega|Ride"] = 133.62, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 205.52, ["Ride"] = 65.63, ["Fly|Ride"] = 142.7, ["Neon"] = 20.57}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 23.12, ["Fly"] = 76.06, ["Ride"] = 43.26, ["Fly|Ride"] = 82.69, ["Neon|Ride"] = 137.7, ["Neon|Fly|Ride"] = 527.63, ["Mega"] = 2466.12, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1239.8}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 96.5, ["Fly"] = 192.18, ["Ride"] = 92.73, ["Fly|Ride"] = 152.11, ["Neon"] = 430.1, ["Neon|Ride"] = 466.52, ["Neon|Fly|Ride"] = 474.74, ["Mega"] = 8220.37, ["Mega|Fly|Ride"] = 1870.15}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 195.57, ["Fly"] = 320.61, ["Ride"] = 196.88, ["Fly|Ride"] = 498.75, ["Neon"] = 822.14, ["Neon|Ride"] = 890.89, ["Neon|Fly|Ride"] = 1096.4, ["Mega"] = 4365.02, ["Mega|Fly|Ride"] = 3426.87}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 10.5, ["Fly"] = 51.19, ["Ride"] = 41.11, ["Fly|Ride"] = 68.87, ["Neon"] = 73.5, ["Neon|Ride"] = 118.91, ["Neon|Fly|Ride"] = 232.4, ["Mega"] = 388.49, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 418.24}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 18.59, ["Ride"] = 13.8, ["Fly|Ride"] = 40.62, ["Neon"] = 7.66, ["Neon|Fly"] = 31.38, ["Neon|Ride"] = 22.08, ["Neon|Fly|Ride"] = 63, ["Mega"] = 86, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 165.38}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 6.45, ["Fly"] = 33.69, ["Ride"] = 19.36, ["Fly|Ride"] = 51.4, ["Neon"] = 39.29, ["Neon|Fly"] = 143.9, ["Neon|Ride"] = 44.01, ["Neon|Fly|Ride"] = 118.54, ["Mega"] = 328.82, ["Mega|Ride"] = 320.61, ["Mega|Fly|Ride"] = 374.05}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 315, ["Fly"] = 479.89, ["Ride"] = 339.54, ["Fly|Ride"] = 411.08, ["Neon"] = 1312.5, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1781.07, ["Mega|Fly|Ride"] = 5732.99}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 60.65, ["Neon"] = 9.19, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 100.71, ["Mega|Ride"] = 233.26}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 6.18, ["Ride"] = 17.45, ["Fly|Ride"] = 45.85, ["Neon"] = 49.86, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 77.87, ["Mega"] = 178.81, ["Mega|Fly"] = 204.9, ["Mega|Ride"] = 185.93, ["Mega|Fly|Ride"] = 246.63}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 17.45, ["Ride"] = 117.17, ["Neon"] = 78.75, ["Neon|Fly"] = 411.08, ["Neon|Ride"] = 157.5, ["Mega"] = 481.94, ["Mega|Ride"] = 545.65, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 78.75, ["Fly"] = 105, ["Ride"] = 110.25, ["Fly|Ride"] = 124.34, ["Neon|Ride"] = 561.75, ["Neon|Fly|Ride"] = 611.02, ["Mega|Fly|Ride"] = 2170.5}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 15.75, ["Fly"] = 47.29, ["Ride"] = 19.69, ["Fly|Ride"] = 59.07, ["Neon"] = 85.32, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 186.84, ["Mega"] = 630.93, ["Mega|Ride"] = 507.66, ["Mega|Fly|Ride"] = 488.38}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 49.33, ["Neon"] = 2.1, ["Neon|Ride"] = 310.25, ["Mega"] = 21, ["Mega|Ride"] = 273.34}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.05, ["Ride"] = 17.45, ["Fly|Ride"] = 52.5, ["Neon"] = 2.63, ["Neon|Ride"] = 20.56, ["Neon|Fly|Ride"] = 69.47, ["Mega"] = 24.94, ["Mega|Fly"] = 87.15, ["Mega|Ride"] = 61.66, ["Mega|Fly|Ride"] = 110.45}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 14.59, ["Fly"] = 411.03, ["Ride"] = 52.5, ["Fly|Ride"] = 142.7, ["Neon"] = 34.13, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 73.5, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 144.37, ["Mega|Ride"] = 188.98, ["Mega|Fly|Ride"] = 324.18}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1446.38, ["Fly"] = 1547.51, ["Ride"] = 1233.75, ["Fly|Ride"] = 1307.25, ["Neon"] = 4200, ["Neon|Ride"] = 3543.75, ["Neon|Fly|Ride"] = 3543.75, ["Mega|Fly|Ride"] = 11418.75}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 446.25, ["Ride"] = 481.45, ["Fly|Ride"] = 479.94, ["Neon"] = 1782, ["Neon|Ride"] = 1771.88, ["Neon|Fly|Ride"] = 2041.75, ["Mega"] = 16440.72, ["Mega|Fly|Ride"] = 6956.25}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 304.5, ["Ride"] = 372.75, ["Fly|Ride"] = 418.69, ["Neon"] = 654.78, ["Neon|Ride"] = 796.85, ["Neon|Fly|Ride"] = 656.25, ["Mega|Fly|Ride"] = 2915.54}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 341.24, ["Fly"] = 410.01, ["Ride"] = 378.55, ["Fly|Ride"] = 442.64, ["Neon"] = 918.75, ["Neon|Fly"] = 1370.94, ["Neon|Ride"] = 968.63, ["Neon|Fly|Ride"] = 1145.3, ["Mega|Fly|Ride"] = 3699.18}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 57.16, ["Ride"] = 15.65, ["Fly|Ride"] = 38.71, ["Neon"] = 5.79, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 82.22, ["Mega"] = 73.5, ["Mega|Ride"] = 108.94, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 392.44, ["Ride"] = 479.94, ["Fly|Ride"] = 527.26, ["Neon"] = 1680, ["Neon|Ride"] = 1509.38, ["Neon|Fly|Ride"] = 1644.08, ["Mega|Ride"] = 6576.29, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.62, ["Fly"] = 183.75, ["Ride"] = 21, ["Neon"] = 10.4, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 205.52, ["Mega"] = 76.06, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 274.37}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 20.56, ["Fly|Ride"] = 39.38, ["Neon"] = 7.88, ["Neon|Ride"] = 52.43, ["Neon|Fly|Ride"] = 106.03, ["Mega"] = 104.9, ["Mega|Ride"] = 192.93}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Neon"] = 3.14, ["Neon|Ride"] = 39.37, ["Mega"] = 21, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 34.89, ["Ride"] = 108.94, ["Fly|Ride"] = 459.38, ["Neon"] = 210, ["Neon|Ride"] = 351.29, ["Mega|Ride"] = 929.56}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 7746.52, ["Ride"] = 21.62, ["Fly|Ride"] = 60.44, ["Neon"] = 26.37, ["Mega"] = 328.13, ["Mega|Ride"] = 307.25, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 3.89, ["Neon|Fly"] = 118.2, ["Neon|Ride"] = 36.2, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 21, ["Mega|Ride"] = 122.52, ["Mega|Fly|Ride"] = 114.07}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.63, ["Fly"] = 35.9, ["Ride"] = 20.99, ["Fly|Ride"] = 62.75, ["Neon"] = 12.79, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 31.31, ["Neon|Fly|Ride"] = 82.67, ["Mega"] = 95.82, ["Mega|Fly"] = 171.62, ["Mega|Ride"] = 117.75, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 6.15, ["Fly"] = 91.77, ["Ride"] = 19.23, ["Fly|Ride"] = 69.9, ["Neon"] = 27.57, ["Neon|Fly"] = 102.78, ["Neon|Ride"] = 137.7, ["Neon|Fly|Ride"] = 245.44, ["Mega"] = 237.57, ["Mega|Ride"] = 300.51, ["Mega|Fly|Ride"] = 310.25}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 10.49, ["Ride"] = 53.82, ["Neon"] = 115.5, ["Neon|Ride"] = 137.7, ["Neon|Fly|Ride"] = 310.25, ["Mega"] = 369.93, ["Mega|Ride"] = 426.45, ["Mega|Fly|Ride"] = 411.03}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 8.58, ["Fly"] = 6196.93, ["Ride"] = 26.73, ["Neon"] = 35.3, ["Neon|Ride"] = 137.7, ["Neon|Fly|Ride"] = 274.37, ["Mega"] = 439.03, ["Mega|Ride"] = 714, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 18.38, ["Fly|Ride"] = 45.94, ["Neon"] = 2.5, ["Neon|Fly"] = 82.48, ["Neon|Ride"] = 24.97, ["Mega"] = 82.22, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 231.73}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 188.98, ["Fly"] = 227.11, ["Ride"] = 227.11, ["Fly|Ride"] = 223.13, ["Neon|Ride"] = 2568.87, ["Neon|Fly|Ride"] = 1085.26, ["Mega"] = 8220.37, ["Mega|Fly|Ride"] = 4198.58}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 15.02, ["Ride"] = 14.44, ["Fly|Ride"] = 35.06, ["Neon"] = 3.94, ["Neon|Fly"] = 27.76, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 45.86, ["Mega"] = 34.96, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 123.38}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 13.13, ["Ride"] = 50.97, ["Fly|Ride"] = 183.73, ["Neon"] = 83.67, ["Neon|Ride"] = 123.15, ["Mega"] = 464.79, ["Mega|Ride"] = 397.67, ["Mega|Fly|Ride"] = 532.29}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 26.19, ["Ride"] = 93.19, ["Fly|Ride"] = 167.23, ["Neon"] = 241.66, ["Neon|Ride"] = 273.37, ["Mega"] = 822.05, ["Mega|Ride"] = 850.83}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 171.92, ["Ride"] = 236.15, ["Fly|Ride"] = 333.63, ["Neon"] = 708.73, ["Neon|Ride"] = 923.78, ["Neon|Fly|Ride"] = 748.13, ["Mega|Fly|Ride"] = 3274.8}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 13.13, ["Ride"] = 37.43, ["Neon"] = 123.33, ["Neon|Ride"] = 274.37, ["Mega"] = 287.44, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1233.07}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 22.1, ["Ride"] = 118.33, ["Fly|Ride"] = 525, ["Neon"] = 96.63, ["Neon|Ride"] = 199.5, ["Mega"] = 463.68, ["Mega|Ride"] = 1644.08, ["Mega|Fly|Ride"] = 928.92}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1181.71, ["Ride"] = 1048.69, ["Fly|Ride"] = 1224.19, ["Neon"] = 4796.16, ["Neon|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 4733.91, ["Mega"] = 18495.81, ["Mega|Fly|Ride"] = 17126.09}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 15.36, ["Fly"] = 29.4, ["Ride"] = 19.56, ["Fly|Ride"] = 43.18, ["Neon"] = 20.56, ["Neon|Fly"] = 79.91, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 205.52, ["Mega"] = 271.9, ["Mega|Ride"] = 231.21, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 8.02, ["Fly"] = 65.63, ["Ride"] = 41.12, ["Fly|Ride"] = 135.19, ["Neon"] = 30.24, ["Neon|Ride"] = 91.81, ["Mega"] = 219.91, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 238.88, ["Mega|Fly|Ride"] = 274.37}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.58, ["Fly"] = 81.19, ["Ride"] = 22.08, ["Fly|Ride"] = 69.57, ["Neon"] = 11.38, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 39.06, ["Mega"] = 91.86, ["Mega|Ride"] = 136.89, ["Mega|Fly|Ride"] = 686.21}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 12.49, ["Ride"] = 37.19, ["Fly|Ride"] = 116.15, ["Neon"] = 66.92, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 174.3, ["Mega"] = 328.13, ["Mega|Ride"] = 357, ["Mega|Fly|Ride"] = 472.55}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 3.36, ["Fly"] = 21, ["Ride"] = 16.46, ["Fly|Ride"] = 41.12, ["Neon"] = 19.64, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 31.29, ["Neon|Fly|Ride"] = 88.7, ["Mega"] = 139.46, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.63, ["Ride"] = 35.98, ["Neon"] = 8.81, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 56.25, ["Mega"] = 111.57, ["Mega|Fly"] = 274.37, ["Mega|Ride"] = 192.18, ["Mega|Fly|Ride"] = 326.78}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 349.37, ["Ride"] = 328.13, ["Fly|Ride"] = 959.86, ["Neon|Fly|Ride"] = 984.38}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.58, ["Fly"] = 25.46, ["Ride"] = 19.22, ["Fly|Ride"] = 72.19, ["Neon"] = 9.37, ["Neon|Ride"] = 32.48, ["Neon|Fly|Ride"] = 119.84, ["Mega"] = 73.5, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 242.01}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 5.22, ["Ride"] = 81.79, ["Fly|Ride"] = 88.87, ["Neon"] = 77.42, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27, ["Mega|Ride"] = 343.22, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.62, ["Fly"] = 91.25, ["Ride"] = 26.17, ["Neon"] = 14.89, ["Neon|Ride"] = 84, ["Mega"] = 85.32, ["Mega|Fly"] = 137.7, ["Mega|Ride"] = 125.99, ["Mega|Fly|Ride"] = 356.73}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 217.54, ["Ride"] = 315, ["Fly|Ride"] = 1036.23, ["Neon"] = 852.78, ["Neon|Fly"] = 959.86, ["Neon|Ride"] = 816.38, ["Neon|Fly|Ride"] = 1130.32, ["Mega"] = 4647.74, ["Mega|Ride"] = 4932.22, ["Mega|Fly|Ride"] = 2789.41}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 21, ["Fly"] = 57.69, ["Ride"] = 147.98, ["Fly|Ride"] = 150.05, ["Neon"] = 124.67, ["Neon|Ride"] = 178.81, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 739.85, ["Mega|Fly|Ride"] = 1219.71}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 18.37, ["Ride"] = 41.12, ["Fly|Ride"] = 89.25, ["Neon"] = 94.39, ["Neon|Ride"] = 123.38, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 548.72, ["Mega|Ride"] = 498.83, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.84, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 44.18, ["Mega"] = 36.19, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 224.02}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 59.07, ["Fly"] = 88.36, ["Ride"] = 98.44, ["Fly|Ride"] = 157.5, ["Neon"] = 262.48, ["Neon|Fly"] = 303.14, ["Neon|Ride"] = 269.06, ["Neon|Fly|Ride"] = 328.1, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 18.83, ["Neon"] = 5.25, ["Neon|Ride"] = 56.98, ["Neon|Fly|Ride"] = 588, ["Mega"] = 48.8, ["Mega|Fly|Ride"] = 410.01}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 27.26, ["Fly"] = 124.35, ["Ride"] = 34.13, ["Fly|Ride"] = 71.99, ["Neon"] = 52.5, ["Neon|Ride"] = 109.24, ["Neon|Fly|Ride"] = 246.63, ["Mega"] = 274.37, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 501.97}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 52.33, ["Fly"] = 110.06, ["Ride"] = 79.94, ["Fly|Ride"] = 87.28, ["Neon"] = 183.75, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 232.4, ["Mega|Ride"] = 3426.87, ["Mega|Fly|Ride"] = 1254.23}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 16.46, ["Ride"] = 13.82, ["Fly|Ride"] = 35.43, ["Neon"] = 2.1, ["Neon|Fly"] = 23.97, ["Neon|Ride"] = 15.43, ["Neon|Fly|Ride"] = 40.51, ["Mega"] = 18.38, ["Mega|Fly"] = 116.21, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 76.8}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.94, ["Fly"] = 32.82, ["Ride"] = 34.96, ["Fly|Ride"] = 131.25, ["Neon"] = 14.3, ["Neon|Ride"] = 46.49, ["Neon|Fly|Ride"] = 168, ["Mega"] = 129.93, ["Mega|Ride"] = 250.69, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 15.74, ["Fly"] = 137.7, ["Ride"] = 41.57, ["Fly|Ride"] = 52.5, ["Neon"] = 140.78, ["Neon|Ride"] = 133.88, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 586.69, ["Mega|Ride"] = 550.77, ["Mega|Fly|Ride"] = 815.89}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.78, ["Neon"] = 2.1, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 95.8, ["Mega"] = 15.74, ["Mega|Ride"] = 136.67}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 15.32, ["Fly"] = 210, ["Ride"] = 59.07, ["Fly|Ride"] = 99.75, ["Neon"] = 78.75, ["Neon|Ride"] = 137.7, ["Neon|Fly|Ride"] = 185.93, ["Mega"] = 548.72, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 343.22}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 17.45, ["Fly"] = 41.11, ["Ride"] = 21.56, ["Fly|Ride"] = 98.44, ["Neon"] = 224.05, ["Neon|Ride"] = 118.78, ["Neon|Fly|Ride"] = 117.16, ["Mega|Ride"] = 345.19, ["Mega|Fly|Ride"] = 434.58}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 7.23, ["Ride"] = 52.5, ["Neon"] = 26.04, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 68.98, ["Mega"] = 199.5, ["Mega|Ride"] = 232.4, ["Mega|Fly|Ride"] = 371.83}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 27.76, ["Fly"] = 2055.11, ["Ride"] = 66.93, ["Fly|Ride"] = 196.83, ["Neon"] = 42, ["Neon|Ride"] = 109.96, ["Neon|Fly|Ride"] = 6196.6, ["Mega"] = 267.18, ["Mega|Ride"] = 544.69, ["Mega|Fly|Ride"] = 566.2}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.62, ["Fly"] = 41.11, ["Ride"] = 137.7, ["Fly|Ride"] = 196.87, ["Neon"] = 5.16, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 102.77, ["Mega"] = 65.63, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 137.7}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 68.86, ["Neon"] = 5.25, ["Neon|Ride"] = 89.17, ["Mega"] = 28.88, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 215.43}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 34.13}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 42.62, ["Fly"] = 78.75, ["Ride"] = 70.88, ["Fly|Ride"] = 192.2, ["Neon"] = 178.83, ["Neon|Ride"] = 204.53, ["Neon|Fly|Ride"] = 548.72, ["Mega"] = 1224.85, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly|Ride"] = 131.32, ["Mega"] = 22.23, ["Mega|Ride"] = 8494.73, ["Mega|Fly|Ride"] = 308.28}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 388.5, ["Fly"] = 561.05, ["Ride"] = 446.25, ["Fly|Ride"] = 641.82, ["Neon"] = 3018.75, ["Neon|Fly|Ride"] = 2251.08, ["Mega"] = 16440.72, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 6.57, ["Fly"] = 25.91, ["Ride"] = 39.37, ["Fly|Ride"] = 66.26, ["Neon"] = 25.1, ["Neon|Ride"] = 274.37, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 68.86, ["Mega|Fly"] = 147.98, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 548.72}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 3.29, ["Fly"] = 96.6, ["Ride"] = 21.66, ["Fly|Ride"] = 64.22, ["Neon"] = 16.21, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 116.82, ["Mega|Ride"] = 163.61, ["Mega|Fly|Ride"] = 411.03}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 18.6, ["Fly"] = 77.09, ["Ride"] = 41.11, ["Fly|Ride"] = 106.32, ["Neon"] = 68.87, ["Neon|Ride"] = 178.95, ["Mega"] = 793.28, ["Mega|Ride"] = 437.07}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.33, ["Fly"] = 315.47, ["Ride"] = 32.48, ["Fly|Ride"] = 721.88, ["Mega"] = 255.94, ["Mega|Ride"] = 232.4}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 11.47, ["Fly"] = 139.53, ["Ride"] = 105, ["Fly|Ride"] = 157.49, ["Neon"] = 52.5, ["Neon|Ride"] = 106.88, ["Neon|Fly|Ride"] = 361.72, ["Mega"] = 342.85, ["Mega|Ride"] = 400.98, ["Mega|Fly|Ride"] = 466.52}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 7.76, ["Fly"] = 104.99, ["Ride"] = 32.82, ["Fly|Ride"] = 133.88, ["Neon"] = 26.17, ["Neon|Ride"] = 100.71, ["Neon|Fly|Ride"] = 135.64, ["Mega"] = 210, ["Mega|Fly"] = 479.89, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 403.2}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.43, ["Fly|Ride"] = 82.23, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 15.26, ["Neon|Fly|Ride"] = 122.85, ["Mega"] = 13.86, ["Mega|Ride"] = 35.39, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 8.76, ["Fly"] = 274.37, ["Ride"] = 27.76, ["Fly|Ride"] = 102.78, ["Neon"] = 28.65, ["Neon|Ride"] = 68.86, ["Neon|Fly|Ride"] = 308.28, ["Mega"] = 194.25, ["Mega|Ride"] = 155.72, ["Mega|Fly|Ride"] = 411.03}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 261.19, ["Fly"] = 298.86, ["Ride"] = 328.12, ["Fly|Ride"] = 421.31, ["Neon"] = 1451.08, ["Neon|Ride"] = 1404.38, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 4192.39}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 87.94, ["Ride"] = 168.55, ["Fly|Ride"] = 215.25, ["Neon"] = 282.19, ["Neon|Ride"] = 380.63, ["Neon|Fly|Ride"] = 486.96, ["Mega"] = 1626.72, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1576.26}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 17.04, ["Ride"] = 15.75, ["Fly|Ride"] = 26.25, ["Neon"] = 15.43, ["Neon|Fly"] = 68.25, ["Neon|Ride"] = 20.56, ["Neon|Fly|Ride"] = 62.56, ["Mega"] = 137.7, ["Mega|Fly"] = 204.5, ["Mega|Ride"] = 123.32, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 18.89, ["Ride"] = 14.44, ["Fly|Ride"] = 31.87, ["Neon"] = 5.16, ["Neon|Fly"] = 39.15, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 55.13, ["Mega"] = 69.66, ["Mega|Fly"] = 343.22, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.63, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 39.38, ["Neon|Fly|Ride"] = 411.03, ["Mega"] = 137.7, ["Mega|Ride"] = 274.37, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 249.38, ["Fly"] = 420, ["Ride"] = 311.85, ["Fly|Ride"] = 375.38, ["Neon|Ride"] = 1781.77, ["Neon|Fly|Ride"] = 1335.81, ["Mega|Ride"] = 8220.37, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 3.78, ["Fly"] = 48.3, ["Ride"] = 16.46, ["Fly|Ride"] = 41.64, ["Neon"] = 19.69, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 40.51, ["Neon|Fly|Ride"] = 101.1, ["Mega"] = 255.94, ["Mega|Ride"] = 310.25, ["Mega|Fly|Ride"] = 411.03}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.83, ["Fly"] = 155.69, ["Ride"] = 82.85, ["Fly|Ride"] = 205.55, ["Neon"] = 13.13, ["Neon|Ride"] = 411.03, ["Mega"] = 246.63, ["Mega|Ride"] = 274.37, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 3.92, ["Neon|Ride"] = 137.71, ["Mega"] = 62.89, ["Mega|Ride"] = 137.7}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 12.55, ["Fly"] = 35.98, ["Ride"] = 27.57, ["Fly|Ride"] = 57.23, ["Neon"] = 79.28, ["Neon|Ride"] = 108.07, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 728.44, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 656.15}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 39.37, ["Fly"] = 155.69, ["Ride"] = 97.6, ["Fly|Ride"] = 196.88, ["Neon"] = 128.63, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 208.68, ["Neon|Fly|Ride"] = 379.32, ["Mega"] = 420, ["Mega|Fly"] = 2157.86, ["Mega|Ride"] = 456.07, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 28.88, ["Ride"] = 48.33, ["Fly|Ride"] = 103.11, ["Neon"] = 157.4, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 188.99, ["Neon|Fly|Ride"] = 201.39, ["Mega|Ride"] = 739.85, ["Mega|Fly|Ride"] = 929.56}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 19.05, ["Ride"] = 14.89, ["Fly|Ride"] = 32.9, ["Neon"] = 2.1, ["Neon|Fly"] = 19.69, ["Neon|Ride"] = 17.05, ["Neon|Fly|Ride"] = 60.64, ["Mega"] = 19.67, ["Mega|Fly"] = 412.51, ["Mega|Ride"] = 41.48, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 233.21, ["Fly"] = 360.68, ["Ride"] = 274.37, ["Fly|Ride"] = 296.63, ["Neon"] = 1369.91, ["Neon|Ride"] = 962.01, ["Neon|Fly|Ride"] = 643.13}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 6.56, ["Fly"] = 82.22, ["Ride"] = 55.51, ["Fly|Ride"] = 130.53, ["Neon"] = 96.63, ["Neon|Ride"] = 116.21, ["Neon|Fly|Ride"] = 328.12, ["Mega"] = 500.43, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 29.14, ["Ride"] = 15.6, ["Fly|Ride"] = 44.2, ["Neon"] = 10.47, ["Neon|Fly"] = 39.4, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 108.94, ["Mega"] = 59.28, ["Mega|Fly"] = 274.37, ["Mega|Ride"] = 54.69, ["Mega|Fly|Ride"] = 139.46}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 30.83, ["Ride"] = 18.51, ["Fly|Ride"] = 43.72, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 102.77, ["Mega"] = 27.57, ["Mega|Fly"] = 137.7, ["Mega|Ride"] = 46.27, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 27.28, ["Fly|Ride"] = 69.28, ["Neon"] = 12.21, ["Neon|Ride"] = 62.76, ["Neon|Fly|Ride"] = 6850.66, ["Mega"] = 115.5, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 11.78, ["Fly"] = 38.74, ["Ride"] = 22.32, ["Fly|Ride"] = 70.5, ["Neon"] = 49.64, ["Neon|Fly"] = 261.05, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 331.27, ["Mega|Ride"] = 321.57, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 9.18, ["Ride"] = 39.38, ["Fly|Ride"] = 72.19, ["Neon"] = 52.5, ["Neon|Ride"] = 141.82, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 267.18, ["Mega|Ride"] = 336.03, ["Mega|Fly|Ride"] = 371.83}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 41.66, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 14.44, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 125.37}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 9.07, ["Ride"] = 34.96, ["Fly|Ride"] = 65.63, ["Neon"] = 34.96, ["Neon|Fly"] = 102.8, ["Neon|Ride"] = 64.31, ["Neon|Fly|Ride"] = 135.33, ["Mega"] = 134.63, ["Mega|Ride"] = 212.62, ["Mega|Fly|Ride"] = 300.06}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 111.99, ["Neon"] = 3.94, ["Neon|Fly"] = 109.98, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 102.3, ["Mega"] = 24.94, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 310.25}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 38.83, ["Ride"] = 20.56, ["Fly|Ride"] = 42, ["Neon"] = 5.16, ["Neon|Ride"] = 25.62, ["Neon|Fly|Ride"] = 87.33, ["Mega"] = 48.57, ["Mega|Ride"] = 80.16, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 682.5, ["Ride"] = 756, ["Fly|Ride"] = 817.69, ["Neon|Ride"] = 3150, ["Neon|Fly|Ride"] = 3192.25, ["Mega|Fly|Ride"] = 12533.99}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 15.43, ["Fly|Ride"] = 34.99, ["Neon"] = 46.49, ["Neon|Fly"] = 55.51, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 61.66, ["Mega"] = 183.94, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 3.83, ["Ride"] = 36.75, ["Fly|Ride"] = 206.78, ["Neon"] = 11.64, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 137.7, ["Mega"] = 57.75, ["Mega|Fly"] = 315, ["Mega|Ride"] = 122.81, ["Mega|Fly|Ride"] = 303.78}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 15.43, ["Fly"] = 40.5, ["Ride"] = 22.31, ["Fly|Ride"] = 53.45, ["Neon"] = 51.19, ["Neon|Fly"] = 123.33, ["Neon|Ride"] = 66.93, ["Neon|Fly|Ride"] = 107.23, ["Mega|Ride"] = 309.74, ["Mega|Fly|Ride"] = 376.69}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 15.43, ["Fly|Ride"] = 31.61, ["Neon"] = 7.76, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 109.96, ["Mega|Ride"] = 88.14, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 105, ["Ride"] = 63, ["Fly|Ride"] = 205.55, ["Neon"] = 255.94, ["Neon|Ride"] = 257.44, ["Mega"] = 1165.24, ["Mega|Fly|Ride"] = 1096.4}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 16.46, ["Fly|Ride"] = 76.13, ["Neon"] = 9.19, ["Neon|Fly"] = 132.46, ["Neon|Ride"] = 30.85, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 57.75, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 356.73}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 3.56, ["Fly"] = 73.5, ["Ride"] = 22.32, ["Fly|Ride"] = 60.65, ["Neon"] = 40.69, ["Neon|Fly"] = 137.72, ["Neon|Ride"] = 42, ["Mega"] = 123.38, ["Mega|Ride"] = 235.89, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 59.07, ["Neon"] = 9.19, ["Neon|Fly"] = 62.75, ["Neon|Ride"] = 78.75, ["Mega"] = 93.5, ["Mega|Fly"] = 411.03, ["Mega|Ride"] = 171.98, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 18.38, ["Fly|Ride"] = 97.64, ["Neon"] = 5.02, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 23.47, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 41.36, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 174.3}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 12.32, ["Fly"] = 23.63, ["Ride"] = 23.35, ["Fly|Ride"] = 41.84, ["Neon"] = 137.82, ["Neon|Ride"] = 68.24, ["Neon|Fly|Ride"] = 98.43, ["Mega"] = 822.05, ["Mega|Fly|Ride"] = 456.37}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 689.07, ["Ride"] = 748.13, ["Fly|Ride"] = 748.13, ["Neon"] = 1951.84, ["Neon|Ride"] = 1745.63, ["Neon|Fly|Ride"] = 1903.13, ["Mega"] = 7947.03, ["Mega|Ride"] = 6300, ["Mega|Fly|Ride"] = 6247.5}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 16.05, ["Ride"] = 17.51, ["Fly|Ride"] = 47.25, ["Neon"] = 3.7, ["Neon|Fly"] = 137.72, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 60.37, ["Mega"] = 56.44, ["Mega|Ride"] = 137.7, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 5.25, ["Ride"] = 27.57, ["Fly|Ride"] = 77.86, ["Neon"] = 21, ["Neon|Fly"] = 137.72, ["Neon|Ride"] = 112.51, ["Neon|Fly|Ride"] = 274.37, ["Mega"] = 287.05, ["Mega|Ride"] = 315}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 46.4, ["Ride"] = 73.98, ["Fly|Ride"] = 105, ["Neon"] = 295.32, ["Neon|Ride"] = 379.65, ["Neon|Fly|Ride"] = 441.54, ["Mega"] = 3151.49, ["Mega|Fly|Ride"] = 2332.32}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 31.87, ["Fly"] = 124.32, ["Ride"] = 56.44, ["Fly|Ride"] = 102.79, ["Neon"] = 104.99, ["Neon|Ride"] = 125.06, ["Mega"] = 760.39, ["Mega|Ride"] = 669.38, ["Mega|Fly|Ride"] = 726.49}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 12.79, ["Ride"] = 26.25, ["Fly|Ride"] = 123.59, ["Neon"] = 77.44, ["Neon|Ride"] = 136.35, ["Neon|Fly|Ride"] = 205.52, ["Mega"] = 411.03, ["Mega|Ride"] = 431.59, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 20.5, ["Ride"] = 92.96, ["Neon"] = 107.6, ["Neon|Ride"] = 356.73, ["Neon|Fly|Ride"] = 164.42, ["Mega"] = 288.23, ["Mega|Fly"] = 504.3, ["Mega|Ride"] = 366.02, ["Mega|Fly|Ride"] = 453.16}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 18.38, ["Ride"] = 315, ["Neon"] = 185.91, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 102.77, ["Neon|Fly|Ride"] = 485.63, ["Mega"] = 924, ["Mega|Ride"] = 630.93, ["Mega|Fly|Ride"] = 557.81}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 6.57}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 5.24, ["Fly"] = 131248.69, ["Ride"] = 26.73, ["Fly|Ride"] = 78.75, ["Neon"] = 22.32, ["Neon|Ride"] = 214.97, ["Neon|Fly|Ride"] = 205.52, ["Mega"] = 204.75, ["Mega|Fly"] = 464.46, ["Mega|Ride"] = 205.52, ["Mega|Fly|Ride"] = 303.14}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.58, ["Neon"] = 42, ["Mega"] = 867.98, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 59.07, ["Fly"] = 411.03, ["Ride"] = 78.75, ["Fly|Ride"] = 101.09, ["Neon"] = 274.4, ["Neon|Ride"] = 236.76, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 1644.08, ["Mega|Fly|Ride"] = 848.17}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 5.71, ["Fly"] = 18.38, ["Ride"] = 16.46, ["Fly|Ride"] = 41.58, ["Neon"] = 23.45, ["Neon|Fly"] = 47.29, ["Neon|Ride"] = 35.13, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 164.42, ["Mega|Ride"] = 195.25, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 7.09, ["Fly"] = 82.22, ["Ride"] = 24.14, ["Fly|Ride"] = 76.7, ["Neon"] = 26.25, ["Neon|Ride"] = 52.47, ["Neon|Fly|Ride"] = 137.67, ["Mega"] = 126.06, ["Mega|Ride"] = 166.56}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 7.76, ["Neon|Ride"] = 45.94, ["Mega"] = 39.52, ["Mega|Ride"] = 91.81, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 38.07, ["Fly"] = 58.7, ["Ride"] = 54.33, ["Fly|Ride"] = 123.33, ["Neon"] = 153.57, ["Neon|Ride"] = 148.04, ["Neon|Fly|Ride"] = 274.37, ["Mega"] = 1096.4, ["Mega|Ride"] = 685.38, ["Mega|Fly|Ride"] = 748.13}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 27.76, ["Neon"] = 5.8, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 84.27, ["Mega"] = 100.71, ["Mega|Ride"] = 92.97, ["Mega|Fly|Ride"] = 309.68}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 13.16, ["Ride"] = 55.51, ["Fly|Ride"] = 271.32, ["Neon"] = 145.69, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 374.07, ["Mega|Ride"] = 874.13, ["Mega|Fly|Ride"] = 630.93}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 23.63, ["Ride"] = 15.43, ["Fly|Ride"] = 36.2, ["Neon"] = 30.85, ["Neon|Ride"] = 27.37, ["Neon|Fly|Ride"] = 59.89, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.63, ["Fly"] = 52.49, ["Ride"] = 19.29, ["Fly|Ride"] = 59.03, ["Neon"] = 95.28, ["Neon|Ride"] = 410.93, ["Mega"] = 377.12, ["Mega|Ride"] = 388.43, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 4.03, ["Ride"] = 56.95, ["Fly|Ride"] = 131.25, ["Neon"] = 46.49, ["Neon|Ride"] = 139.46, ["Mega"] = 364.58, ["Mega|Ride"] = 393.75}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 31.5, ["Ride"] = 105, ["Fly|Ride"] = 192.2, ["Neon"] = 196.88, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1630.73, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 20.56, ["Ride"] = 85.98, ["Neon"] = 109.98, ["Neon|Ride"] = 178.81, ["Neon|Fly|Ride"] = 143.88, ["Mega"] = 411.03, ["Mega|Ride"] = 328.82, ["Mega|Fly|Ride"] = 498.1}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 6.57, ["Ride"] = 105, ["Fly|Ride"] = 41.12, ["Neon"] = 44.63, ["Mega"] = 754.24, ["Mega|Ride"] = 973.1, ["Mega|Fly|Ride"] = 1644.08}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 18.24, ["Ride"] = 68.87, ["Fly|Ride"] = 367.46, ["Neon"] = 103.9, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 883.08, ["Mega|Ride"] = 959.05, ["Mega|Fly|Ride"] = 1370.76}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.46, ["Neon"] = 26.73, ["Neon|Ride"] = 274.37, ["Mega"] = 118.13, ["Mega|Fly|Ride"] = 310.25}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 17.68, ["Fly|Ride"] = 38.18, ["Neon"] = 2.63, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 39.06, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 68.25, ["Mega|Ride"] = 67.83, ["Mega|Fly|Ride"] = 172.11}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 5.2, ["Ride"] = 55.49, ["Fly|Ride"] = 77.88, ["Neon"] = 15.65, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 109.94, ["Mega"] = 91.88, ["Mega|Ride"] = 132.57, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 29.79, ["Ride"] = 18.38, ["Fly|Ride"] = 55.95, ["Neon"] = 6.57, ["Neon|Fly"] = 31.38, ["Neon|Ride"] = 34.96, ["Neon|Fly|Ride"] = 68.81, ["Mega"] = 45.94, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 149.69}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.68, ["Fly"] = 39.38, ["Ride"] = 27.76, ["Fly|Ride"] = 68.87, ["Neon"] = 18.51, ["Neon|Ride"] = 97.63, ["Neon|Fly|Ride"] = 137.7, ["Mega"] = 249.38, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 464.79}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.94, ["Fly"] = 65.63, ["Ride"] = 32.96, ["Fly|Ride"] = 103.69, ["Neon"] = 27.76, ["Neon|Fly"] = 464.75, ["Neon|Ride"] = 68.86, ["Mega"] = 302.45, ["Mega|Fly|Ride"] = 1027.56}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.29, ["Fly"] = 131.25, ["Ride"] = 21, ["Fly|Ride"] = 39.52, ["Neon"] = 27.76, ["Neon|Fly"] = 111.54, ["Neon|Ride"] = 41.11, ["Neon|Fly|Ride"] = 114.9, ["Mega"] = 131.25, ["Mega|Ride"] = 254.67, ["Mega|Fly|Ride"] = 321.57}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.63, ["Fly"] = 35.14, ["Ride"] = 18.38, ["Fly|Ride"] = 51.69, ["Neon"] = 22.32, ["Neon|Fly"] = 82.23, ["Neon|Ride"] = 46.5, ["Neon|Fly|Ride"] = 101.1, ["Mega"] = 168, ["Mega|Ride"] = 227.11, ["Mega|Fly|Ride"] = 479.89}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 5.25, ["Fly"] = 57.75, ["Ride"] = 39.08, ["Neon"] = 18.6, ["Neon|Fly"] = 123.26, ["Neon|Ride"] = 45.34, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 105, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 411.03}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 10.28, ["Fly"] = 137.7, ["Ride"] = 110.07, ["Fly|Ride"] = 525, ["Neon"] = 98.18, ["Neon|Fly"] = 205.55, ["Neon|Ride"] = 337.98, ["Neon|Fly|Ride"] = 155.72, ["Mega"] = 469.88, ["Mega|Fly"] = 685.38, ["Mega|Ride"] = 528.62, ["Mega|Fly|Ride"] = 674.63}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 51.19, ["Ride"] = 97.13, ["Fly|Ride"] = 191.16, ["Neon"] = 274.61, ["Neon|Ride"] = 273, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 1506.39, ["Mega|Ride"] = 1116.94, ["Mega|Fly|Ride"] = 1191.84}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 50.96, ["Ride"] = 22.62, ["Fly|Ride"] = 49.34, ["Neon"] = 3.51, ["Neon|Ride"] = 41.11, ["Mega"] = 29.81, ["Mega|Ride"] = 68.16, ["Mega|Fly|Ride"] = 131.15}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 63.66, ["Mega"] = 959.75, ["Mega|Fly|Ride"] = 1233.07}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 55.42, ["Fly"] = 105, ["Ride"] = 59.07, ["Neon"] = 290.47, ["Neon|Ride"] = 274.37, ["Mega"] = 1676.96, ["Mega|Ride"] = 1210.47, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 5.55, ["Fly"] = 190.32, ["Ride"] = 31.38, ["Fly|Ride"] = 126, ["Neon"] = 49.88, ["Neon|Ride"] = 65.54, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 204.88, ["Mega|Ride"] = 221.8, ["Mega|Fly|Ride"] = 343.22}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.63, ["Ride"] = 82.22, ["Fly|Ride"] = 137.68, ["Neon"] = 8.43, ["Neon|Ride"] = 40.69, ["Mega"] = 57.75, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 89.55, ["Mega|Fly|Ride"] = 155.73}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.92, ["Fly"] = 21, ["Ride"] = 17.07, ["Fly|Ride"] = 52.5, ["Neon"] = 11.9, ["Neon|Ride"] = 34.96, ["Neon|Fly|Ride"] = 112.88, ["Mega"] = 192.18, ["Mega|Ride"] = 137.7, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.65, ["Ride"] = 14.07, ["Neon"] = 2.5, ["Neon|Ride"] = 27.76, ["Neon|Fly|Ride"] = 57.52, ["Mega"] = 27.03, ["Mega|Ride"] = 69.56, ["Mega|Fly|Ride"] = 203.47}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 74.27, ["Neon"] = 5.24, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 89.41, ["Mega"] = 42, ["Mega|Fly"] = 168, ["Mega|Ride"] = 76.71, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 155.69, ["Neon"] = 2.63, ["Neon|Ride"] = 47.29, ["Mega"] = 21.91, ["Mega|Fly|Ride"] = 303.14}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 17.05, ["Ride"] = 44.2, ["Neon"] = 15.43, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 616.54, ["Mega"] = 137.7, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 250.23}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 6.99, ["Ride"] = 26.79, ["Fly|Ride"] = 189.96, ["Neon"] = 51.19, ["Neon|Ride"] = 102.77, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 408.98, ["Mega|Ride"] = 548.72, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 5.44, ["Fly"] = 20.92, ["Ride"] = 22.26, ["Fly|Ride"] = 46.1, ["Neon"] = 41.43, ["Neon|Fly"] = 65.54, ["Neon|Ride"] = 41.39, ["Neon|Fly|Ride"] = 91.67, ["Mega"] = 420, ["Mega|Ride"] = 342.57, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 68.86, ["Ride"] = 262.07, ["Fly|Ride"] = 262.5, ["Neon"] = 274.4, ["Neon|Ride"] = 597.19, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 20.9, ["Fly"] = 72.45, ["Ride"] = 31.5, ["Fly|Ride"] = 137.72, ["Neon"] = 84.58, ["Neon|Fly|Ride"] = 630, ["Mega"] = 880.76, ["Mega|Ride"] = 827.54, ["Mega|Fly|Ride"] = 820.98}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 15.45, ["Fly|Ride"] = 39.05, ["Neon"] = 2.63, ["Neon|Fly"] = 41.12, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 59.28, ["Mega"] = 19.49, ["Mega|Ride"] = 94.65, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 17.45, ["Ride"] = 15.75, ["Fly|Ride"] = 27.57, ["Neon"] = 5.12, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 20.46, ["Neon|Fly|Ride"] = 45.73, ["Mega"] = 44.19, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 94.5}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 479.06, ["Ride"] = 499.73, ["Fly|Ride"] = 503.99, ["Neon|Fly|Ride"] = 1522.5}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 11.32, ["Ride"] = 68.86, ["Neon"] = 131.25, ["Neon|Ride"] = 109.96, ["Mega"] = 357.27, ["Mega|Ride"] = 397.67, ["Mega|Fly|Ride"] = 1233.07}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 48.3, ["Ride"] = 14.44, ["Fly|Ride"] = 36.03, ["Neon"] = 5.24, ["Neon|Fly"] = 68.87, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 43.32, ["Mega|Ride"] = 74.81, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 59.74, ["Ride"] = 115.5, ["Fly|Ride"] = 150.94, ["Neon"] = 260.98, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 511.26, ["Mega"] = 737.62, ["Mega|Ride"] = 813.75, ["Mega|Fly|Ride"] = 935.99}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 17.45, ["Fly|Ride"] = 35.43, ["Neon"] = 13, ["Neon|Fly"] = 41.37, ["Neon|Ride"] = 27.81, ["Neon|Fly|Ride"] = 72.51, ["Mega"] = 84, ["Mega|Fly"] = 178.81, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 196.46}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 68.86, ["Ride"] = 37.01, ["Fly|Ride"] = 1312.5, ["Neon"] = 3.35, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 35.42, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 22.1, ["Mega|Fly"] = 269.24, ["Mega|Ride"] = 85.31, ["Mega|Fly|Ride"] = 208.95}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 39.37, ["Fly"] = 143.13, ["Ride"] = 86.63, ["Fly|Ride"] = 124.69, ["Neon"] = 183.75, ["Neon|Ride"] = 191.26, ["Neon|Fly|Ride"] = 328.82, ["Mega"] = 721.88, ["Mega|Ride"] = 630, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 15.33, ["Fly|Ride"] = 52.5, ["Neon"] = 4.38, ["Neon|Ride"] = 39.99, ["Mega"] = 40.68, ["Mega|Ride"] = 183.65, ["Mega|Fly|Ride"] = 223.12}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 32.8, ["Ride"] = 61.66, ["Fly|Ride"] = 137.72, ["Neon"] = 312.42, ["Neon|Ride"] = 219.91, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 1623.53, ["Mega|Ride"] = 1644.08, ["Mega|Fly|Ride"] = 1168.13}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 2.58, ["Ride"] = 27.57, ["Fly|Ride"] = 156.22, ["Neon"] = 21.56, ["Neon|Ride"] = 274.37, ["Neon|Fly|Ride"] = 479.89, ["Mega"] = 144.38, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 517.79}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.52, ["Ride"] = 26.25, ["Fly|Ride"] = 65.79, ["Neon"] = 5.25, ["Neon|Fly"] = 82.23, ["Neon|Ride"] = 51.39, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 109.96, ["Mega|Ride"] = 137.7, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 34.13, ["Ride"] = 55.51, ["Fly|Ride"] = 393.74, ["Neon"] = 315, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 322.67, ["Mega"] = 2053.05, ["Mega|Ride"] = 2598.75, ["Mega|Fly|Ride"] = 1157.02}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 230.31, ["Ride"] = 31.87, ["Fly|Ride"] = 908.98, ["Neon"] = 5.24, ["Neon|Ride"] = 37.23, ["Neon|Fly|Ride"] = 152.22, ["Mega"] = 48.18, ["Mega|Fly"] = 247.11, ["Mega|Ride"] = 108.94, ["Mega|Fly|Ride"] = 246.63}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 32.9, ["Ride"] = 15.43, ["Fly|Ride"] = 102.88, ["Neon"] = 15.43, ["Neon|Fly"] = 47.77, ["Neon|Ride"] = 20.56, ["Neon|Fly|Ride"] = 116.21, ["Mega|Fly|Ride"] = 205.78}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 10.38, ["Fly"] = 45.23, ["Ride"] = 31.69, ["Fly|Ride"] = 81.2, ["Neon"] = 74.59, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 137.7, ["Mega"] = 430.5, ["Mega|Ride"] = 462.41, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 19.69, ["Ride"] = 32.9, ["Fly|Ride"] = 98.65, ["Neon"] = 124.69, ["Neon|Ride"] = 105.34, ["Neon|Fly|Ride"] = 267.26, ["Mega"] = 1055.31, ["Mega|Ride"] = 445.97, ["Mega|Fly|Ride"] = 644.28}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 18.38, ["Fly"] = 51.18, ["Ride"] = 27.83, ["Fly|Ride"] = 74.01, ["Neon"] = 72.19, ["Neon|Ride"] = 137.7, ["Neon|Fly|Ride"] = 223.11, ["Mega"] = 548.72, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 690.2}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 51.18, ["Fly"] = 262.5, ["Ride"] = 128.63, ["Fly|Ride"] = 306.73, ["Neon"] = 278.25, ["Neon|Ride"] = 405.9, ["Neon|Fly|Ride"] = 548.72, ["Mega|Ride"] = 1305.95, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 6.91, ["Ride"] = 44.01, ["Neon"] = 32.82, ["Neon|Ride"] = 77.87, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 203.44, ["Mega|Ride"] = 300.06, ["Mega|Fly|Ride"] = 335.35}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 5.52, ["Ride"] = 26.46, ["Fly|Ride"] = 78.74, ["Neon"] = 18.37, ["Neon|Ride"] = 77.09, ["Neon|Fly|Ride"] = 122.3, ["Mega"] = 168, ["Mega|Ride"] = 271.28, ["Mega|Fly|Ride"] = 316.38}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 9.86, ["Fly"] = 65.63, ["Ride"] = 40.08, ["Fly|Ride"] = 92.96, ["Neon"] = 46.25, ["Neon|Ride"] = 68.86, ["Mega"] = 430.5, ["Mega|Ride"] = 639.19, ["Mega|Fly|Ride"] = 479.89}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 13.96, ["Fly|Ride"] = 31.87, ["Neon"] = 2.1, ["Neon|Fly"] = 17.45, ["Neon|Ride"] = 16.96, ["Neon|Fly|Ride"] = 53.82, ["Mega"] = 18.36, ["Mega|Ride"] = 30.83, ["Mega|Fly|Ride"] = 93.82}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 53.39, ["Fly"] = 164.07, ["Ride"] = 85.32, ["Fly|Ride"] = 297.44, ["Neon"] = 262.64, ["Neon|Fly"] = 2329.74, ["Neon|Ride"] = 224.44, ["Neon|Fly|Ride"] = 488.14, ["Mega"] = 1394.33, ["Mega|Ride"] = 1343.21, ["Mega|Fly|Ride"] = 890.89}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 18.64, ["Neon"] = 3.94, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 31.39, ["Mega|Fly|Ride"] = 306.66}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 27.76, ["Ride"] = 15.27, ["Fly|Ride"] = 45.93, ["Neon"] = 22.31, ["Neon|Fly"] = 137.72, ["Neon|Ride"] = 23.57, ["Neon|Fly|Ride"] = 94.75, ["Mega"] = 262.5, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 78.74, ["Ride"] = 120.96, ["Fly|Ride"] = 223.13, ["Neon"] = 411.08, ["Neon|Fly"] = 328.13, ["Neon|Ride"] = 385.91, ["Neon|Fly|Ride"] = 603.18, ["Mega"] = 1233.75, ["Mega|Ride"] = 1301.39, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 22.62, ["Neon"] = 6.47, ["Neon|Ride"] = 65.63, ["Mega"] = 65.63, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 10.28}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 35.98, ["Fly|Ride"] = 57.71, ["Neon"] = 6.57, ["Neon|Ride"] = 35.35, ["Neon|Fly|Ride"] = 202.19, ["Mega"] = 47.25, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 94.5, ["Ride"] = 199.38, ["Fly|Ride"] = 295.11, ["Neon"] = 420, ["Neon|Ride"] = 681.99, ["Neon|Fly|Ride"] = 735, ["Mega"] = 3563.65, ["Mega|Ride"] = 2466.12, ["Mega|Fly|Ride"] = 2809.32}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 4.28, ["Ride"] = 40.85, ["Neon"] = 43.18, ["Neon|Ride"] = 63.73, ["Neon|Fly|Ride"] = 193.19, ["Mega"] = 159.94, ["Mega|Ride"] = 202.85, ["Mega|Fly|Ride"] = 405.9}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.75, ["Neon"] = 4.5, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 45.41, ["Mega|Ride"] = 100.08, ["Mega|Fly|Ride"] = 124.09}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 4.86, ["Ride"] = 26.73, ["Neon"] = 51.19, ["Neon|Ride"] = 109.96, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 548.65, ["Mega|Fly|Ride"] = 614.75}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 9.09, ["Fly"] = 24.2, ["Ride"] = 20.86, ["Fly|Ride"] = 54.32, ["Neon"] = 81.86, ["Neon|Ride"] = 117.5, ["Neon|Fly|Ride"] = 164.42, ["Mega"] = 548.72, ["Mega|Ride"] = 405.57, ["Mega|Fly|Ride"] = 466.52}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 18.37, ["Ride"] = 39.38, ["Fly|Ride"] = 97.64, ["Neon"] = 142.68, ["Neon|Ride"] = 197.3, ["Neon|Fly|Ride"] = 1575, ["Mega"] = 748.79, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 771.1}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 131.25, ["Fly"] = 246.63, ["Ride"] = 188.98, ["Fly|Ride"] = 240.5, ["Neon"] = 590.46, ["Neon|Fly"] = 658.76, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 596.3, ["Mega|Fly|Ride"] = 2355.94}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 22.31, ["Fly"] = 36.75, ["Ride"] = 25.98, ["Fly|Ride"] = 32.82, ["Neon"] = 133.47, ["Neon|Fly"] = 6166.05, ["Neon|Ride"] = 96.63, ["Neon|Fly|Ride"] = 105, ["Mega|Ride"] = 713.13, ["Mega|Fly|Ride"] = 609.28}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 3.26, ["Fly"] = 131.23, ["Ride"] = 17.26, ["Fly|Ride"] = 91.88, ["Neon"] = 19.69, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 117.16, ["Mega"] = 127.32, ["Mega|Ride"] = 132.47, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 8.88, ["Fly"] = 232.37, ["Ride"] = 31.91, ["Fly|Ride"] = 116.91, ["Neon"] = 31.5, ["Neon|Fly|Ride"] = 191.15, ["Mega"] = 376.82, ["Mega|Ride"] = 433.13}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 47.25, ["Ride"] = 82.22, ["Fly|Ride"] = 216.12, ["Neon"] = 195.57, ["Neon|Ride"] = 245.44, ["Neon|Fly|Ride"] = 380.52, ["Mega"] = 1541.33, ["Mega|Ride"] = 1165.24, ["Mega|Fly|Ride"] = 945.36}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 15.6, ["Ride"] = 105, ["Neon"] = 123.33, ["Neon|Ride"] = 238.26, ["Neon|Fly|Ride"] = 453.16, ["Mega"] = 682.31, ["Mega|Ride"] = 1932, ["Mega|Fly|Ride"] = 775.02}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 320.61, ["Ride"] = 411.03, ["Neon|Ride"] = 1968.75, ["Neon|Fly|Ride"] = 1509.36, ["Mega|Fly|Ride"] = 6165.28}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 39.52, ["Ride"] = 73.5, ["Fly|Ride"] = 104.57, ["Neon"] = 212.87, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 369.93, ["Mega"] = 1034.25, ["Mega|Ride"] = 909.57, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 36.66, ["Ride"] = 15.31, ["Fly|Ride"] = 102.53, ["Neon"] = 2.5, ["Neon|Ride"] = 17.57, ["Neon|Fly|Ride"] = 64.35, ["Mega"] = 20.98, ["Mega|Fly"] = 102.77, ["Mega|Ride"] = 68.86, ["Mega|Fly|Ride"] = 108.94}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 6.19, ["Neon"] = 16.96, ["Neon|Ride"] = 41.1, ["Neon|Fly|Ride"] = 259.89, ["Mega"] = 164.42, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 405.9}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 6.19, ["Ride"] = 41.11, ["Fly|Ride"] = 144.16, ["Neon"] = 19.69, ["Neon|Fly"] = 87.94, ["Neon|Ride"] = 122.3, ["Neon|Fly|Ride"] = 174.57, ["Mega"] = 122.76, ["Mega|Fly"] = 548.72, ["Mega|Ride"] = 239.69, ["Mega|Fly|Ride"] = 328.12}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 341.25, ["Fly"] = 620.4, ["Ride"] = 321.57, ["Fly|Ride"] = 645.4, ["Neon"] = 1490.13, ["Neon|Ride"] = 1370.76, ["Neon|Fly|Ride"] = 1370.25, ["Mega|Fly|Ride"] = 5033.44}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 3.15, ["Fly"] = 37.68, ["Ride"] = 16.96, ["Fly|Ride"] = 50.92, ["Neon"] = 24.94, ["Neon|Ride"] = 41.77, ["Neon|Fly|Ride"] = 77.09, ["Mega"] = 168, ["Mega|Ride"] = 275.18, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 7.87, ["Fly"] = 22.32, ["Ride"] = 17.07, ["Fly|Ride"] = 44.63, ["Neon"] = 28.07, ["Neon|Fly"] = 156.45, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 685.38, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 5.25, ["Fly"] = 39.52, ["Ride"] = 27.56, ["Neon"] = 13.13, ["Neon|Ride"] = 47.29, ["Neon|Fly|Ride"] = 147.58, ["Mega"] = 100.33, ["Mega|Ride"] = 137.7, ["Mega|Fly|Ride"] = 205.52}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 52.5, ["Fly"] = 137.7, ["Ride"] = 31.38, ["Fly|Ride"] = 65.63, ["Neon"] = 137.72, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 1626.72, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 31.43, ["Ride"] = 41.12, ["Fly|Ride"] = 68.56, ["Neon"] = 15.43, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 210, ["Mega"] = 164.42, ["Mega|Ride"] = 411.03, ["Mega|Fly|Ride"] = 985.04}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 5.25, ["Fly"] = 787.5, ["Ride"] = 23.63, ["Fly|Ride"] = 85.41, ["Neon"] = 124.34, ["Neon|Ride"] = 155.72, ["Mega"] = 678.19, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.17, ["Neon"] = 6.06, ["Neon|Ride"] = 28.76, ["Mega"] = 45.46, ["Mega|Ride"] = 137.7, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 23.63, ["Ride"] = 137.72, ["Neon"] = 65.63, ["Neon|Ride"] = 274.37, ["Mega"] = 411.03, ["Mega|Ride"] = 341.25}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 13.13, ["Ride"] = 78.12, ["Neon"] = 62.09, ["Neon|Ride"] = 102.77, ["Neon|Fly|Ride"] = 411.03, ["Mega"] = 479.89, ["Mega|Ride"] = 342.79, ["Mega|Fly|Ride"] = 545.65}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 12.5, ["Fly"] = 26.25, ["Ride"] = 25.99, ["Fly|Ride"] = 51.14, ["Neon"] = 52.5, ["Neon|Fly"] = 115.95, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 137.7, ["Mega"] = 575.45, ["Mega|Ride"] = 405.9, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 283.62, ["Fly"] = 410.27, ["Ride"] = 282.18, ["Fly|Ride"] = 389.81, ["Neon"] = 1465.48, ["Neon|Ride"] = 1087.15, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 5042.17}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.62, ["Fly|Ride"] = 56.8, ["Neon"] = 10.08, ["Neon|Fly"] = 77.86, ["Neon|Ride"] = 33.71, ["Neon|Fly|Ride"] = 158.17, ["Mega"] = 219.91, ["Mega|Ride"] = 155.72, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.94, ["Fly"] = 27.72, ["Ride"] = 24.94, ["Fly|Ride"] = 114.09, ["Neon"] = 36.66, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 282.92, ["Mega|Ride"] = 271.87, ["Mega|Fly|Ride"] = 411.03}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 41.91, ["Ride"] = 101.07, ["Neon"] = 131.25, ["Neon|Ride"] = 185.93, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 328.12, ["Mega|Ride"] = 360.29, ["Mega|Fly|Ride"] = 480.38}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 103.69, ["Fly"] = 393.75, ["Ride"] = 137.7, ["Fly|Ride"] = 273.37, ["Neon"] = 493.29, ["Neon|Fly"] = 1042.07, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 682.31, ["Mega"] = 3098.89, ["Mega|Ride"] = 1794.19, ["Mega|Fly|Ride"] = 2235.19}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 34.13, ["Fly"] = 109.96, ["Ride"] = 94.5, ["Neon"] = 102.78, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 261.01, ["Mega"] = 261.19, ["Mega|Ride"] = 307.01, ["Mega|Fly|Ride"] = 474.39}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Ride"] = 16.59, ["Fly|Ride"] = 51.89, ["Neon"] = 9.19, ["Neon|Fly|Ride"] = 65.54, ["Mega"] = 53.45, ["Mega|Ride"] = 194.06, ["Mega|Fly|Ride"] = 192.94}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 12.35, ["Ride"] = 26.25, ["Fly|Ride"] = 81.2, ["Neon"] = 41.12, ["Neon|Ride"] = 94.25, ["Neon|Fly|Ride"] = 174.57, ["Mega"] = 165.67, ["Mega|Ride"] = 442.98, ["Mega|Fly|Ride"] = 475.76}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 65.63, ["Fly"] = 196.88, ["Ride"] = 111.56, ["Fly|Ride"] = 84, ["Neon"] = 141.24, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 314.9, ["Mega"] = 433.13, ["Mega|Ride"] = 439.68, ["Mega|Fly|Ride"] = 576.19}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Neon"] = 6.47, ["Neon|Ride"] = 248.67, ["Neon|Fly|Ride"] = 190.3, ["Mega"] = 57.75, ["Mega|Fly"] = 116.82, ["Mega|Ride"] = 137.7, ["Mega|Fly|Ride"] = 153.57}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 10.28, ["Fly|Ride"] = 273.37, ["Neon"] = 91.88, ["Neon|Ride"] = 401.03, ["Mega"] = 372.75, ["Mega|Fly|Ride"] = 764.51}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 962.07, ["Fly"] = 1259.39, ["Ride"] = 1007.99, ["Fly|Ride"] = 1099.01, ["Neon"] = 3493.54, ["Neon|Ride"] = 3253.43, ["Neon|Fly|Ride"] = 2743.11, ["Mega|Fly|Ride"] = 13701.29}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 24.53, ["Ride"] = 108.95, ["Fly|Ride"] = 191.63, ["Neon"] = 123.38, ["Neon|Fly"] = 892.5, ["Neon|Ride"] = 203.47, ["Mega"] = 956.66, ["Mega|Ride"] = 479.89, ["Mega|Fly|Ride"] = 685.38}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 3.5, ["Fly"] = 49.25, ["Ride"] = 27.62, ["Fly|Ride"] = 102.78, ["Neon"] = 13.64, ["Neon|Ride"] = 31.39, ["Neon|Fly|Ride"] = 109.24, ["Mega"] = 82.57, ["Mega|Ride"] = 131.54, ["Mega|Fly|Ride"] = 184.97}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 11.82, ["Ride"] = 131.22, ["Neon"] = 117.17, ["Neon|Fly|Ride"] = 137.7, ["Mega"] = 227.22, ["Mega|Ride"] = 321.46, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 24.68, ["Fly|Ride"] = 52.5, ["Neon"] = 2.63, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 18.38, ["Mega|Fly"] = 123.32, ["Mega|Ride"] = 44.49, ["Mega|Fly|Ride"] = 137.06}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 61.67, ["Fly"] = 114.07, ["Ride"] = 108.86, ["Fly|Ride"] = 185.91, ["Neon"] = 271.82, ["Neon|Ride"] = 354.38, ["Mega"] = 1278.14, ["Mega|Ride"] = 1108.7, ["Mega|Fly|Ride"] = 1233.07}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 7.12, ["Fly"] = 174.57, ["Ride"] = 18.38, ["Fly|Ride"] = 68.87, ["Neon"] = 31.5, ["Neon|Ride"] = 78.75, ["Mega"] = 464.79, ["Mega|Ride"] = 401.78, ["Mega|Fly|Ride"] = 508.65}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.63, ["Fly"] = 97.69, ["Ride"] = 26.73, ["Neon"] = 11.68, ["Neon|Ride"] = 55.51, ["Mega"] = 92.97, ["Mega|Ride"] = 157.49}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 52.5, ["Ride"] = 60.64, ["Fly|Ride"] = 196.88, ["Neon"] = 183.75, ["Neon|Ride"] = 118.5, ["Neon|Fly|Ride"] = 616.54, ["Mega"] = 680.77, ["Mega|Ride"] = 644.28, ["Mega|Fly|Ride"] = 682.06}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 9.55, ["Ride"] = 51.19, ["Fly|Ride"] = 92.96, ["Neon"] = 210, ["Neon|Ride"] = 174.7, ["Neon|Fly|Ride"] = 170.6, ["Mega"] = 341.97, ["Mega|Ride"] = 411.03, ["Mega|Fly|Ride"] = 822.05}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 59.07, ["Ride"] = 84, ["Neon"] = 356.69, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 971.92, ["Mega"] = 1535.17, ["Mega|Ride"] = 2323.88, ["Mega|Fly|Ride"] = 1579.03}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 7.88, ["Neon"] = 19.55, ["Neon|Ride"] = 81.75, ["Neon|Fly|Ride"] = 620.48, ["Mega"] = 110.45, ["Mega|Ride"] = 129.93, ["Mega|Fly|Ride"] = 233.26}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 6.24, ["Fly"] = 27.76, ["Ride"] = 19.69, ["Fly|Ride"] = 52.5, ["Neon"] = 44.63, ["Neon|Ride"] = 58.24, ["Neon|Fly|Ride"] = 126.36, ["Mega"] = 399, ["Mega|Ride"] = 356.97, ["Mega|Fly|Ride"] = 320.61}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 115.48, ["Ride"] = 156.19, ["Fly|Ride"] = 169.64, ["Neon"] = 616.62, ["Neon|Ride"] = 441, ["Neon|Fly|Ride"] = 591.76, ["Mega"] = 3142.26, ["Mega|Ride"] = 2335.15, ["Mega|Fly|Ride"] = 1887.38}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.52, ["Fly"] = 22.91, ["Ride"] = 18.16, ["Fly|Ride"] = 41.15, ["Neon"] = 11.45, ["Neon|Fly"] = 64.96, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 64.65, ["Mega"] = 124.59, ["Mega|Ride"] = 139.16, ["Mega|Fly|Ride"] = 150.93}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 10.1, ["Fly"] = 41.09, ["Ride"] = 26.25, ["Fly|Ride"] = 91.88, ["Neon"] = 65.63, ["Neon|Fly"] = 310.22, ["Neon|Ride"] = 92.49, ["Neon|Fly|Ride"] = 137.7, ["Mega"] = 366.31, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 17.8, ["Ride"] = 14.33, ["Fly|Ride"] = 42.95, ["Neon"] = 2.1, ["Neon|Fly"] = 24.34, ["Neon|Ride"] = 16.63, ["Neon|Fly|Ride"] = 41.48, ["Mega"] = 14.58, ["Mega|Fly"] = 48.82, ["Mega|Ride"] = 27.3, ["Mega|Fly|Ride"] = 68.25}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 55.51, ["Neon"] = 2.58, ["Neon|Ride"] = 39.06, ["Mega"] = 18.38, ["Mega|Fly"] = 118.12, ["Mega|Ride"] = 62.76, ["Mega|Fly|Ride"] = 109.96}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 34.96, ["Ride"] = 19.68, ["Fly|Ride"] = 79.47, ["Neon"] = 17.07, ["Neon|Ride"] = 59.28, ["Mega"] = 157.22, ["Mega|Ride"] = 164.42, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 30.19, ["Ride"] = 315, ["Neon"] = 152.11, ["Neon|Ride"] = 411.03, ["Neon|Fly|Ride"] = 630, ["Mega"] = 548.72, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 616.54}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 3.94, ["Fly"] = 15.75, ["Ride"] = 17.07, ["Fly|Ride"] = 41.12, ["Neon"] = 14.17, ["Neon|Fly"] = 34.44, ["Neon|Ride"] = 28.52, ["Neon|Fly|Ride"] = 81.35, ["Mega"] = 117.16, ["Mega|Fly"] = 170.6, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 172.38}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 5.25, ["Fly"] = 34.77, ["Ride"] = 19.69, ["Fly|Ride"] = 63.54, ["Neon"] = 26.16, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 35.98, ["Neon|Fly|Ride"] = 94.03, ["Mega"] = 182.43, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 173.33, ["Mega|Fly|Ride"] = 213.94}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.37, ["Fly"] = 22.31, ["Ride"] = 18.09, ["Fly|Ride"] = 74.08, ["Neon"] = 10.49, ["Neon|Fly"] = 85.98, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 62.33, ["Mega"] = 62.76, ["Mega|Fly"] = 96.6, ["Mega|Ride"] = 142.85, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 7.88, ["Fly"] = 35.98, ["Ride"] = 45.94, ["Neon"] = 57.58, ["Neon|Ride"] = 92.97, ["Neon|Fly|Ride"] = 192.18, ["Mega"] = 220.23, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 274.37}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 11.64, ["Fly"] = 170.6, ["Ride"] = 122.72, ["Fly|Ride"] = 220.76, ["Neon"] = 63, ["Neon|Ride"] = 252.03, ["Neon|Fly|Ride"] = 343.22, ["Mega"] = 233.26, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 2.63, ["Fly"] = 41.88, ["Ride"] = 20.6, ["Fly|Ride"] = 65.54, ["Neon"] = 24.22, ["Neon|Fly"] = 196.66, ["Neon|Ride"] = 55.51, ["Neon|Fly|Ride"] = 109.35, ["Mega"] = 310.25, ["Mega|Ride"] = 232.4, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 20.89, ["Ride"] = 18.51, ["Fly|Ride"] = 34.95, ["Neon"] = 10.44, ["Neon|Fly"] = 68.33, ["Neon|Ride"] = 34.96, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 131.15, ["Mega|Ride"] = 137.7, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 177.19, ["Fly"] = 370.69, ["Ride"] = 291.38, ["Fly|Ride"] = 274.4, ["Neon"] = 943.42, ["Neon|Ride"] = 1233.07, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 6.45, ["Ride"] = 61.76, ["Neon"] = 27.83, ["Neon|Fly|Ride"] = 411.03, ["Mega"] = 119.62, ["Mega|Ride"] = 411.03, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.25, ["Fly"] = 23.63, ["Ride"] = 20.78, ["Fly|Ride"] = 76.06, ["Neon"] = 23.15, ["Neon|Fly"] = 219.93, ["Neon|Ride"] = 53.45, ["Neon|Fly|Ride"] = 201.8, ["Mega"] = 199.5, ["Mega|Ride"] = 274.37, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 11.71, ["Ride"] = 24.68, ["Neon"] = 60.37, ["Neon|Ride"] = 213.44, ["Neon|Fly|Ride"] = 616.54, ["Mega"] = 461.77, ["Mega|Ride"] = 310.25, ["Mega|Fly|Ride"] = 547.98}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 15.43, ["Ride"] = 15.43, ["Fly|Ride"] = 27.76, ["Neon"] = 2.1, ["Neon|Fly"] = 23.63, ["Neon|Ride"] = 16.46, ["Neon|Fly|Ride"] = 44.62, ["Mega"] = 18.38, ["Mega|Fly"] = 162.75, ["Mega|Ride"] = 31.87, ["Mega|Fly|Ride"] = 95.55}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 3.59, ["Fly"] = 41.11, ["Ride"] = 17.07, ["Fly|Ride"] = 45.94, ["Neon"] = 8.66, ["Neon|Ride"] = 24.04, ["Neon|Fly|Ride"] = 94.81, ["Mega"] = 102.38, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.1, ["Ride"] = 67.83, ["Neon"] = 19.55, ["Neon|Ride"] = 205.52, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 60.22, ["Mega|Ride"] = 195.25, ["Mega|Fly|Ride"] = 308.95}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 65.62, ["Fly"] = 105, ["Ride"] = 103.09, ["Fly|Ride"] = 152.11, ["Neon"] = 620.42, ["Neon|Ride"] = 427.14, ["Neon|Fly|Ride"] = 446.25, ["Mega"] = 2055.11, ["Mega|Ride"] = 3426.87, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 2.88, ["Fly"] = 91.88, ["Ride"] = 20.92, ["Fly|Ride"] = 65.63, ["Neon"] = 22.73, ["Neon|Ride"] = 54.63, ["Neon|Fly|Ride"] = 92.79, ["Mega"] = 209.42, ["Mega|Ride"] = 320.61, ["Mega|Fly|Ride"] = 411.03}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 20.99, ["Ride"] = 47.39, ["Fly|Ride"] = 118.13, ["Neon"] = 15.23, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 519.43, ["Mega"] = 52.49, ["Mega|Fly"] = 313.69, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 53.66, ["Fly"] = 210, ["Ride"] = 102.18, ["Fly|Ride"] = 205.55, ["Neon"] = 129.94, ["Neon|Ride"] = 157.49, ["Neon|Fly|Ride"] = 310.25, ["Mega"] = 433.13, ["Mega|Ride"] = 616.54, ["Mega|Fly|Ride"] = 673.05}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 14.68, ["Ride"] = 15.43, ["Fly|Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 17.45, ["Neon|Ride"] = 15.43, ["Neon|Fly|Ride"] = 35.34, ["Mega"] = 18.38, ["Mega|Fly"] = 48.87, ["Mega|Ride"] = 37.01, ["Mega|Fly|Ride"] = 82.22}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Neon"] = 3.82, ["Neon|Ride"] = 15.43, ["Neon|Fly|Ride"] = 92.97, ["Mega"] = 15.74, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 205.52}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 3.89, ["Ride"] = 107.63, ["Neon"] = 13.13, ["Neon|Ride"] = 90.46, ["Neon|Fly|Ride"] = 180.87, ["Mega"] = 64.32, ["Mega|Fly"] = 178.81, ["Mega|Ride"] = 110.25}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 10.06, ["Ride"] = 20.1, ["Fly|Ride"] = 111.57, ["Neon"] = 27.57, ["Neon|Fly"] = 411.08, ["Neon|Ride"] = 72.89, ["Neon|Fly|Ride"] = 232.4, ["Mega"] = 89.25, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 21.28, ["Ride"] = 13.13, ["Fly|Ride"] = 25.2, ["Neon"] = 2.1, ["Neon|Fly"] = 20.92, ["Neon|Ride"] = 31.39, ["Neon|Fly|Ride"] = 57.56, ["Mega"] = 22.04, ["Mega|Fly"] = 39.38, ["Mega|Ride"] = 32.81, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 16.77, ["Fly"] = 72.19, ["Ride"] = 117.17, ["Neon"] = 118.13, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 959.75, ["Mega"] = 497.32, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 684.36}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2572.5, ["Ride"] = 2740.82, ["Fly|Ride"] = 2513.44, ["Neon|Fly|Ride"] = 9563.36, ["Mega|Fly|Ride"] = 34525.49}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 19.29, ["Ride"] = 17.75, ["Fly|Ride"] = 39.84, ["Neon"] = 10.36, ["Neon|Fly"] = 62.29, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 66.27, ["Mega"] = 78.75, ["Mega|Fly"] = 439.81, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 168.86}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.55, ["Neon"] = 13.96, ["Mega"] = 168.53, ["Mega|Fly"] = 441, ["Mega|Ride"] = 137.7, ["Mega|Fly|Ride"] = 412.13}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 22.36, ["Ride"] = 53.45, ["Fly|Ride"] = 157.5, ["Neon"] = 109.23, ["Neon|Ride"] = 92.5, ["Neon|Fly|Ride"] = 244.58, ["Mega"] = 393.65, ["Mega|Ride"] = 397.68, ["Mega|Fly|Ride"] = 462}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 32.07, ["Ride"] = 58.58, ["Neon"] = 155.07, ["Neon|Ride"] = 217.3, ["Mega"] = 540.75, ["Mega|Ride"] = 813.83, ["Mega|Fly|Ride"] = 806.39}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 157.49, ["Fly"] = 1370.76, ["Ride"] = 186.38, ["Fly|Ride"] = 350.44, ["Neon"] = 1312.5, ["Neon|Ride"] = 805.88, ["Neon|Fly|Ride"] = 748.27, ["Mega"] = 6165.28, ["Mega|Ride"] = 3483.5, ["Mega|Fly|Ride"] = 3359.99}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 7.87, ["Fly"] = 27.76, ["Ride"] = 28.88, ["Fly|Ride"] = 675.94, ["Neon"] = 15.75, ["Neon|Ride"] = 128.8, ["Mega"] = 94.5, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 163.03, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.62, ["Ride"] = 68.86, ["Neon"] = 26.25, ["Neon|Fly"] = 102.78, ["Neon|Fly|Ride"] = 513.79, ["Mega"] = 114.76, ["Mega|Ride"] = 320.15, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 3.82, ["Fly"] = 102, ["Ride"] = 40.68, ["Fly|Ride"] = 196.88, ["Neon"] = 8.24, ["Neon|Ride"] = 46.5, ["Mega"] = 84, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 322.67}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 11.38, ["Ride"] = 98.44, ["Neon"] = 129.94, ["Neon|Ride"] = 1165.82, ["Mega"] = 508.65, ["Mega|Ride"] = 596, ["Mega|Fly|Ride"] = 717.24}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 93.52, ["Mega"] = 17.07, ["Mega|Fly"] = 115.59, ["Mega|Ride"] = 155.72}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 86.5, ["Fly"] = 137.7, ["Ride"] = 97.13, ["Fly|Ride"] = 154.17, ["Neon"] = 411.08, ["Neon|Ride"] = 411.03, ["Neon|Fly|Ride"] = 411.03, ["Mega"] = 1365, ["Mega|Fly|Ride"] = 1724.14}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 91.81, ["Neon"] = 9.98, ["Neon|Ride"] = 154.09, ["Mega"] = 62.76, ["Mega|Ride"] = 178.81, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 42.77, ["Fly"] = 102.77, ["Ride"] = 74.68, ["Fly|Ride"] = 131.25, ["Neon"] = 236.25, ["Neon|Ride"] = 277.34, ["Neon|Fly|Ride"] = 428.35, ["Mega"] = 2625, ["Mega|Ride"] = 1898.91, ["Mega|Fly|Ride"] = 1677.38}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.55, ["Fly|Ride"] = 50.79, ["Neon"] = 6.18, ["Neon|Fly"] = 87.44, ["Neon|Ride"] = 58.47, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 46.15, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 165.14}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.63, ["Neon"] = 10.5, ["Neon|Ride"] = 118.13, ["Mega"] = 64.32, ["Mega|Ride"] = 136.86, ["Mega|Fly|Ride"] = 604.21}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 10.28, ["Ride"] = 31.43, ["Fly|Ride"] = 157.5, ["Neon"] = 54.85, ["Neon|Ride"] = 94.55, ["Neon|Fly|Ride"] = 205.52, ["Mega"] = 155.28, ["Mega|Ride"] = 328.82, ["Mega|Fly|Ride"] = 920.27}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 388.5, ["Fly"] = 548.72, ["Ride"] = 459.38, ["Fly|Ride"] = 571.61, ["Neon"] = 1291.5, ["Neon|Ride"] = 1114.32, ["Neon|Fly|Ride"] = 1245.57, ["Mega"] = 5343.24, ["Mega|Ride"] = 4725, ["Mega|Fly|Ride"] = 4410}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 37.49, ["Ride"] = 45.86, ["Fly|Ride"] = 93.75, ["Neon"] = 205.55, ["Neon|Ride"] = 219.91, ["Neon|Fly|Ride"] = 273.34, ["Mega"] = 1370.76, ["Mega|Ride"] = 1212.52, ["Mega|Fly|Ride"] = 1068.66}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 45.01, ["Ride"] = 19.69, ["Fly|Ride"] = 91.88, ["Neon"] = 3.94, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 52.41, ["Neon|Fly|Ride"] = 68.86, ["Mega"] = 50.43, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 183.74}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 13.02, ["Fly"] = 81.18, ["Ride"] = 46.41, ["Fly|Ride"] = 105, ["Neon"] = 44.89, ["Neon|Fly"] = 105, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 255.94, ["Mega|Fly"] = 956.29, ["Mega|Ride"] = 240.75, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 6.25, ["Ride"] = 20.67, ["Fly|Ride"] = 262.07, ["Neon"] = 137.72, ["Neon|Ride"] = 89.42, ["Mega"] = 411.03, ["Mega|Ride"] = 479.89, ["Mega|Fly|Ride"] = 575.16}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.91, ["Neon"] = 15.74, ["Mega"] = 65.63, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 86.62, ["Ride"] = 19.95, ["Fly|Ride"] = 41.12, ["Neon"] = 24.94, ["Neon|Ride"] = 32.79, ["Neon|Fly|Ride"] = 209.63, ["Mega"] = 542.63, ["Mega|Ride"] = 482.07, ["Mega|Fly|Ride"] = 1644.08}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 108.76, ["Ride"] = 131.25, ["Fly|Ride"] = 220.89, ["Neon|Ride"] = 616.88, ["Neon|Fly|Ride"] = 697.17, ["Mega|Fly|Ride"] = 2588.39}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 26.25, ["Fly"] = 95.82, ["Ride"] = 94.5, ["Fly|Ride"] = 91.87, ["Neon"] = 192.94, ["Neon|Ride"] = 192.14, ["Mega"] = 682.5, ["Mega|Ride"] = 718.27, ["Mega|Fly|Ride"] = 673.98}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2216.81, ["Fly"] = 2362.5, ["Ride"] = 2100, ["Fly|Ride"] = 2055.36, ["Neon"] = 10962.19, ["Neon|Fly|Ride"] = 7875, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.58, ["Fly"] = 65625, ["Ride"] = 107.63, ["Fly|Ride"] = 183.75, ["Neon"] = 13.13, ["Neon|Ride"] = 135.64, ["Neon|Fly|Ride"] = 192.18, ["Mega"] = 118.13, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 184.42, ["Mega|Fly|Ride"] = 575.45}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 27.57, ["Ride"] = 46.49, ["Neon"] = 45.12, ["Neon|Ride"] = 96.66, ["Neon|Fly|Ride"] = 232.32, ["Mega"] = 194.25, ["Mega|Ride"] = 240.48, ["Mega|Fly|Ride"] = 520.98}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 871.5, ["Fly"] = 1189.68, ["Ride"] = 994.88, ["Fly|Ride"] = 1031.63, ["Neon"] = 2598.75, ["Neon|Ride"] = 2939.7, ["Neon|Fly|Ride"] = 2624.99, ["Mega|Ride"] = 10275.45, ["Mega|Fly|Ride"] = 9186.19}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 40.69, ["Ride"] = 56.44, ["Fly|Ride"] = 241.5, ["Neon"] = 299.08, ["Neon|Ride"] = 294.67, ["Neon|Fly|Ride"] = 369.93, ["Mega"] = 775.82, ["Mega|Ride"] = 778.89, ["Mega|Fly|Ride"] = 836.43}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.23, ["Ride"] = 22.91, ["Fly|Ride"] = 128.09, ["Neon"] = 15.43, ["Neon|Ride"] = 41.11, ["Neon|Fly|Ride"] = 328.12, ["Mega"] = 196.88, ["Mega|Ride"] = 123.32, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.41, ["Ride"] = 137.7, ["Neon"] = 2.1, ["Neon|Fly"] = 41.12, ["Neon|Ride"] = 55.51, ["Neon|Fly|Ride"] = 77.87, ["Mega"] = 26.73, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 246.63}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 83.99, ["Ride"] = 127.32, ["Fly|Ride"] = 310.22, ["Neon"] = 459.38, ["Neon|Fly|Ride"] = 420, ["Mega"] = 2323.88, ["Mega|Fly|Ride"] = 2634.11}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 3.94, ["Ride"] = 29.22, ["Neon"] = 22.62, ["Neon|Ride"] = 51.98, ["Mega"] = 145.45, ["Mega|Ride"] = 185.93, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 70, ["Ride"] = 133.61, ["Neon"] = 385.88, ["Neon|Ride"] = 463.38, ["Neon|Fly|Ride"] = 494.32, ["Mega"] = 2466.12, ["Mega|Fly|Ride"] = 2466.12}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 15.43, ["Fly"] = 105, ["Fly|Ride"] = 109.98, ["Neon"] = 39.38, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 136.5, ["Mega|Ride"] = 309.02, ["Mega|Fly|Ride"] = 274.37}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 262.48, ["Ride"] = 273, ["Fly|Ride"] = 354.38, ["Neon"] = 1136.72, ["Neon|Ride"] = 836.06, ["Neon|Fly|Ride"] = 879.01, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 8.16, ["Fly"] = 87.93, ["Ride"] = 26.73, ["Fly|Ride"] = 31.38, ["Neon"] = 39.38, ["Neon|Ride"] = 64.89, ["Neon|Fly|Ride"] = 114.15, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 335.63}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 20.91, ["Ride"] = 17.07, ["Fly|Ride"] = 39.38, ["Neon"] = 4.6, ["Neon|Fly"] = 30.85, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 52.47, ["Mega"] = 50.64, ["Mega|Fly"] = 95.04, ["Mega|Ride"] = 68.86, ["Mega|Fly|Ride"] = 127.8}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 892.5, ["Ride"] = 1050, ["Fly|Ride"] = 1050, ["Neon|Ride"] = 7536.01, ["Neon|Fly|Ride"] = 5206.58, ["Mega"] = 26031.81, ["Mega|Fly|Ride"] = 27401.53}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 10.39, ["Fly"] = 959.75, ["Ride"] = 210, ["Neon"] = 57.1, ["Neon|Ride"] = 311.74, ["Mega"] = 223.13, ["Mega|Ride"] = 339.1, ["Mega|Fly|Ride"] = 439.81}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 12.26, ["Ride"] = 41.11, ["Fly|Ride"] = 97.13, ["Neon"] = 26.25, ["Neon|Fly"] = 92.96, ["Neon|Ride"] = 55.51, ["Neon|Fly|Ride"] = 137.7, ["Mega"] = 173.76, ["Mega|Ride"] = 168, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 31.5, ["Fly"] = 40.69, ["Ride"] = 34.04, ["Fly|Ride"] = 72.19, ["Neon"] = 274.4, ["Neon|Ride"] = 200.17, ["Neon|Fly|Ride"] = 183.66, ["Mega"] = 2055.11, ["Mega|Ride"] = 685.38, ["Mega|Fly|Ride"] = 861}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 14.2, ["Fly"] = 77.09, ["Ride"] = 27.56, ["Fly|Ride"] = 87.94, ["Neon"] = 65.63, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 76.15, ["Neon|Fly|Ride"] = 146.42, ["Mega"] = 367.5, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 431.59}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 29.54, ["Ride"] = 209.99, ["Fly|Ride"] = 137.72, ["Neon"] = 105.09, ["Neon|Ride"] = 274.37, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 483.99, ["Mega|Ride"] = 573.39, ["Mega|Fly|Ride"] = 616.54}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 65.63, ["Fly|Ride"] = 232.38, ["Neon"] = 2.1, ["Neon|Ride"] = 108.71, ["Neon|Fly|Ride"] = 310.25, ["Mega"] = 15.75, ["Mega|Fly"] = 68.25, ["Mega|Ride"] = 67.51, ["Mega|Fly|Ride"] = 97.13}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 45.93, ["Fly"] = 68.86, ["Ride"] = 65.63, ["Fly|Ride"] = 130.97, ["Neon"] = 449.64, ["Neon|Ride"] = 278.88, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 3288.15, ["Mega|Fly|Ride"] = 959.75}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.63, ["Fly"] = 27.76, ["Ride"] = 18.54, ["Fly|Ride"] = 73.61, ["Neon"] = 31.5, ["Neon|Ride"] = 139.25, ["Mega"] = 773.07, ["Mega|Ride"] = 328.06, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 18.89, ["Ride"] = 18.6, ["Fly|Ride"] = 38.07, ["Neon"] = 13.39, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 268.58, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 6.45, ["Ride"] = 171.62, ["Neon"] = 105, ["Neon|Fly|Ride"] = 183.94, ["Mega"] = 246.63, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 30.07, ["Ride"] = 80.17, ["Fly|Ride"] = 137.72, ["Neon"] = 227.13, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 303.14, ["Mega"] = 1008.03, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 8.25, ["Ride"] = 196.88, ["Neon"] = 20.88, ["Neon|Ride"] = 77.09, ["Mega"] = 92.19, ["Mega|Fly"] = 303.14, ["Mega|Ride"] = 109.96, ["Mega|Fly|Ride"] = 310.25}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 33.78, ["Neon"] = 2.1, ["Neon|Ride"] = 20.6, ["Mega"] = 15.75, ["Mega|Ride"] = 55.51, ["Mega|Fly|Ride"] = 256.91}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 68.86, ["Ride"] = 17.45, ["Fly|Ride"] = 82.23, ["Neon"] = 2.1, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 21, ["Mega|Ride"] = 38.07, ["Mega|Fly|Ride"] = 110.25}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 21.06, ["Ride"] = 17.45, ["Fly|Ride"] = 40.05, ["Neon"] = 6.17, ["Neon|Fly"] = 123.33, ["Neon|Ride"] = 31.39, ["Neon|Fly|Ride"] = 76.06, ["Mega"] = 96.6, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 178.5}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 4.97, ["Neon|Ride"] = 1312.5, ["Mega"] = 118.09, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 14.44, ["Fly|Ride"] = 47.24, ["Neon"] = 14.44, ["Neon|Ride"] = 27.76, ["Neon|Fly|Ride"] = 77.58, ["Mega"] = 229.04, ["Mega|Ride"] = 274.37, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 39.38, ["Ride"] = 155.23, ["Fly|Ride"] = 359.7, ["Neon"] = 183.75, ["Neon|Ride"] = 274.37, ["Neon|Fly|Ride"] = 1027.56, ["Mega|Ride"] = 886.78, ["Mega|Fly|Ride"] = 1027.56}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 15.42, ["Ride"] = 15.43, ["Fly|Ride"] = 40.69, ["Neon"] = 2.1, ["Neon|Fly"] = 24.68, ["Neon|Ride"] = 19.61, ["Neon|Fly|Ride"] = 39.06, ["Mega"] = 34.96, ["Mega|Ride"] = 89.41, ["Mega|Fly|Ride"] = 127.05}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 10.28, ["Fly"] = 68.51, ["Ride"] = 28.88, ["Fly|Ride"] = 91.88, ["Neon"] = 43.18, ["Neon|Fly"] = 47.38, ["Neon|Ride"] = 62.51, ["Neon|Fly|Ride"] = 114.19, ["Mega"] = 301.88, ["Mega|Fly"] = 321.78, ["Mega|Ride"] = 241.5, ["Mega|Fly|Ride"] = 299.24}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 17.07, ["Fly"] = 51.89, ["Ride"] = 32.67, ["Fly|Ride"] = 101.92, ["Neon"] = 108.94, ["Neon|Ride"] = 114.07, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 1110.82, ["Mega|Ride"] = 464.79, ["Mega|Fly|Ride"] = 622.79}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.54, ["Fly"] = 196.88, ["Neon"] = 45.94, ["Mega"] = 288.75, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 405.9}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 15.43, ["Fly|Ride"] = 38.75, ["Neon"] = 4.6, ["Neon|Fly"] = 40.09, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 41.34, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 76.12, ["Mega|Fly|Ride"] = 121.96}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.94, ["Fly"] = 39.38, ["Ride"] = 30.19, ["Neon"] = 10.18, ["Neon|Fly"] = 31.38, ["Neon|Ride"] = 96.53, ["Mega"] = 136.5, ["Mega|Fly"] = 735, ["Mega|Ride"] = 184.97, ["Mega|Fly|Ride"] = 394.59}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 977.82, ["Fly"] = 984.38, ["Ride"] = 1047.38, ["Fly|Ride"] = 1006.23, ["Neon"] = 2869.67, ["Neon|Ride"] = 2191.85, ["Neon|Fly|Ride"] = 2231.25, ["Mega|Fly|Ride"] = 6891.29}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 94.5, ["Ride"] = 137.72, ["Fly|Ride"] = 155.69, ["Neon"] = 400.32, ["Neon|Ride"] = 458.07, ["Neon|Fly|Ride"] = 603.18, ["Mega"] = 3081.62, ["Mega|Ride"] = 1919.47, ["Mega|Fly|Ride"] = 1681.08}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 5.25, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 205.52, ["Mega"] = 74, ["Mega|Fly|Ride"] = 205.52}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 57.73, ["Fly"] = 152.1, ["Ride"] = 81.19, ["Fly|Ride"] = 241.17, ["Neon"] = 287.77, ["Neon|Ride"] = 351.44, ["Neon|Fly|Ride"] = 496.13, ["Mega"] = 1050, ["Mega|Ride"] = 1231, ["Mega|Fly|Ride"] = 1155}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 4.66, ["Ride"] = 24.69, ["Fly|Ride"] = 89.42, ["Neon"] = 61.68, ["Neon|Ride"] = 49.45, ["Neon|Fly|Ride"] = 273.34, ["Mega"] = 268.55, ["Mega|Ride"] = 345.27, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 280.87, ["Fly"] = 929.43, ["Ride"] = 340.14, ["Fly|Ride"] = 356.62, ["Neon|Ride"] = 1522.5, ["Neon|Fly|Ride"] = 1397.47, ["Mega|Fly|Ride"] = 3945.78}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 75.64, ["Ride"] = 39.06, ["Fly|Ride"] = 202.64, ["Neon"] = 24.67, ["Neon|Ride"] = 54.28, ["Mega"] = 137.7, ["Mega|Fly"] = 320.61, ["Mega|Ride"] = 185.93}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.63, ["Ride"] = 26.17, ["Neon"] = 74.06, ["Neon|Ride"] = 68.86, ["Mega"] = 328.82}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 30.83, ["Ride"] = 96.6, ["Fly|Ride"] = 525, ["Neon"] = 580.92, ["Neon|Ride"] = 171.98, ["Neon|Fly|Ride"] = 217.3, ["Mega"] = 590.63, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 959.75}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.54, ["Neon"] = 23.47, ["Mega"] = 183.75, ["Mega|Ride"] = 250.74, ["Mega|Fly|Ride"] = 454.18}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 14.94, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 31.29, ["Neon|Ride"] = 41.11, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 27.57, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 76.13}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4331.24, ["Ride"] = 4446.75, ["Fly|Ride"] = 4357.5, ["Neon"] = 30830.17, ["Neon|Fly|Ride"] = 21372.93, ["Mega|Fly|Ride"] = 84943.99}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 8.98, ["Fly"] = 39.38, ["Ride"] = 56.43, ["Neon"] = 52.41, ["Neon|Ride"] = 106.32, ["Mega"] = 274.37, ["Mega|Ride"] = 213.29, ["Mega|Fly|Ride"] = 310.25}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.57, ["Fly"] = 21.15, ["Ride"] = 22.62, ["Fly|Ride"] = 38.68, ["Neon"] = 13.25, ["Neon|Fly"] = 68.87, ["Neon|Ride"] = 36.04, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 144.38, ["Mega|Ride"] = 155.28, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 478.72, ["Fly"] = 774.93, ["Ride"] = 498.75, ["Fly|Ride"] = 525, ["Neon"] = 1372.81, ["Neon|Ride"] = 1589.62, ["Neon|Fly|Ride"] = 1480.81, ["Mega|Fly|Ride"] = 5238.43}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 8.24, ["Ride"] = 25.91, ["Neon"] = 17.07, ["Neon|Ride"] = 145.69, ["Mega"] = 138.97, ["Mega|Fly|Ride"] = 685.38}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.93, ["Fly"] = 137.7, ["Ride"] = 46.49, ["Neon"] = 27.76, ["Neon|Fly"] = 47.29, ["Neon|Ride"] = 274.37, ["Neon|Fly|Ride"] = 274.37, ["Mega"] = 408.98, ["Mega|Ride"] = 401.63, ["Mega|Fly|Ride"] = 491.54}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.45, ["Ride"] = 22.11, ["Neon"] = 4.57, ["Neon|Fly"] = 124.68, ["Neon|Ride"] = 24.68, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 43.32, ["Mega|Ride"] = 76.12, ["Mega|Fly|Ride"] = 255.29}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 836.43, ["Fly"] = 808.69, ["Ride"] = 698.25, ["Fly|Ride"] = 672, ["Neon"] = 2362.5, ["Neon|Ride"] = 2058.21, ["Neon|Fly|Ride"] = 2186.44, ["Mega|Fly|Ride"] = 9591.11}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.57, ["Fly"] = 61.66, ["Ride"] = 72.72, ["Neon"] = 31.34, ["Neon|Ride"] = 76.13, ["Neon|Fly|Ride"] = 178.81, ["Mega"] = 156.07, ["Mega|Ride"] = 193.59, ["Mega|Fly|Ride"] = 332.94}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 18.51, ["Fly"] = 235.34, ["Ride"] = 63.73, ["Neon"] = 137.72, ["Neon|Ride"] = 69.89, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 188.99, ["Mega|Ride"] = 191.71, ["Mega|Fly|Ride"] = 266.64}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.63, ["Fly"] = 34.11, ["Ride"] = 13.13, ["Fly|Ride"] = 61.68, ["Neon"] = 15.75, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 23.25, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 288.18, ["Mega|Fly"] = 137.7, ["Mega|Fly|Ride"] = 208.85}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 30.22, ["Ride"] = 46.49, ["Fly|Ride"] = 155.69, ["Neon"] = 117.59, ["Neon|Fly"] = 170.63, ["Neon|Ride"] = 137.7, ["Mega|Fly|Ride"] = 1680}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Fly|Ride"] = 262.5, ["Neon"] = 4.66, ["Neon|Ride"] = 37.2, ["Neon|Fly|Ride"] = 186.38, ["Mega"] = 30.83, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 482.22}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 459.38, ["Ride"] = 472.5, ["Fly|Ride"] = 697.8, ["Neon"] = 2877.5, ["Neon|Ride"] = 2711.96, ["Neon|Fly|Ride"] = 2343.78, ["Mega|Fly|Ride"] = 6850.66}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.63, ["Ride"] = 61.66, ["Fly|Ride"] = 324.76, ["Neon"] = 10.47, ["Neon|Ride"] = 82.22, ["Neon|Fly|Ride"] = 498.75, ["Mega"] = 51.18, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 279.57}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 41.21, ["Neon"] = 5.24, ["Neon|Fly"] = 137.72, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 45.49, ["Mega|Ride"] = 137.7, ["Mega|Fly|Ride"] = 254.85}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 24.45, ["Neon"] = 5.04, ["Neon|Ride"] = 41.31, ["Neon|Fly|Ride"] = 137.7, ["Mega"] = 41.36, ["Mega|Fly"] = 152.1, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 192.18}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 5.25, ["Ride"] = 21.95, ["Neon"] = 15.43, ["Neon|Ride"] = 39.52, ["Mega"] = 192.18}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 28.88, ["Fly"] = 98.44, ["Ride"] = 68.87, ["Fly|Ride"] = 232.38, ["Neon"] = 124.69, ["Neon|Ride"] = 178.81, ["Neon|Fly|Ride"] = 326.78, ["Mega"] = 632.71, ["Mega|Ride"] = 548.63, ["Mega|Fly|Ride"] = 700.27}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 18.33, ["Ride"] = 60.37, ["Fly|Ride"] = 123.33, ["Neon"] = 97.13, ["Neon|Ride"] = 131.14, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 464.19, ["Mega|Ride"] = 385.9, ["Mega|Fly|Ride"] = 560.79}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 17.51, ["Fly|Ride"] = 36.75, ["Neon"] = 23.25, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 77.87, ["Mega"] = 299.92, ["Mega|Ride"] = 136.54, ["Mega|Fly|Ride"] = 253.32}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 15.43, ["Ride"] = 64.32, ["Neon"] = 92.5, ["Mega"] = 301.88, ["Mega|Ride"] = 206.58, ["Mega|Fly|Ride"] = 959.75}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 24.93, ["Fly|Ride"] = 52.5, ["Neon"] = 15.43, ["Neon|Ride"] = 31.19, ["Neon|Fly|Ride"] = 206.84, ["Mega"] = 85.3, ["Mega|Fly"] = 152.1, ["Mega|Ride"] = 152.25, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 19.59, ["Ride"] = 23.61, ["Fly|Ride"] = 155.69, ["Neon"] = 232.38, ["Neon|Ride"] = 178.81, ["Neon|Fly|Ride"] = 240.45, ["Mega"] = 923.78, ["Mega|Fly|Ride"] = 752.17}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 31.49, ["Fly"] = 874.13, ["Neon"] = 106.32, ["Neon|Ride"] = 137.72, ["Mega"] = 310.25, ["Mega|Ride"] = 274.37, ["Mega|Fly|Ride"] = 822.05}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 55.12, ["Fly"] = 96.6, ["Ride"] = 72.35, ["Fly|Ride"] = 185.58, ["Neon"] = 254.69, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 346.63, ["Mega|Ride"] = 1642.98, ["Mega|Fly|Ride"] = 1394.33}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 47.64, ["Fly"] = 137.7, ["Ride"] = 83.3, ["Fly|Ride"] = 295.11, ["Neon"] = 120.75, ["Neon|Ride"] = 187.03, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 577.05, ["Mega|Ride"] = 706.47, ["Mega|Fly|Ride"] = 620.82}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 16.58, ["Ride"] = 55.68, ["Fly|Ride"] = 137.72, ["Neon"] = 127.32, ["Neon|Ride"] = 123.38, ["Mega"] = 1050, ["Mega|Ride"] = 775.02, ["Mega|Fly|Ride"] = 1233.07}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 15.75, ["Fly"] = 428.26, ["Ride"] = 46.07, ["Fly|Ride"] = 63.38, ["Neon"] = 86.1, ["Neon|Fly"] = 420, ["Neon|Ride"] = 120.74, ["Neon|Fly|Ride"] = 199.31, ["Mega"] = 457.47, ["Mega|Ride"] = 388.17, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.74, ["Ride"] = 15.43, ["Fly|Ride"] = 34.96, ["Neon"] = 5.25, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 20.56, ["Neon|Fly|Ride"] = 59.28, ["Mega"] = 44.61, ["Mega|Ride"] = 57.66, ["Mega|Fly|Ride"] = 202.79}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1890}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 39.29, ["Ride"] = 103.69, ["Fly|Ride"] = 249.38, ["Neon"] = 274.4, ["Neon|Ride"] = 232.4, ["Neon|Fly|Ride"] = 303.14, ["Mega"] = 780.95, ["Mega|Ride"] = 616.54, ["Mega|Fly|Ride"] = 851.07}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 78.91, ["Neon"] = 3.27, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 287.74, ["Mega"] = 29.98, ["Mega|Ride"] = 80.16, ["Mega|Fly|Ride"] = 137.7}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 28.88, ["Ride"] = 52.5, ["Neon"] = 128.37, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 525, ["Mega"] = 464.79, ["Mega|Ride"] = 775.02, ["Mega|Fly|Ride"] = 759.91}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.82, ["Neon|Ride"] = 105, ["Mega"] = 23.63}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 47.25, ["Mega"] = 24.23, ["Mega|Ride"] = 154.04, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 99.74, ["Ride"] = 131.25, ["Neon"] = 498.75, ["Neon|Ride"] = 488.25, ["Neon|Fly|Ride"] = 684.36, ["Mega|Ride"] = 1919.47, ["Mega|Fly|Ride"] = 3426.87}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 26.17, ["Ride"] = 18.38, ["Fly|Ride"] = 92.68, ["Neon"] = 11.64, ["Neon|Ride"] = 26.73, ["Neon|Fly|Ride"] = 84, ["Mega"] = 90.56, ["Mega|Ride"] = 107.61, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Fly|Ride"] = 52.49, ["Neon"] = 3.94, ["Neon|Fly"] = 61.68, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 102.77, ["Mega"] = 34.96, ["Mega|Ride"] = 123.32, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.84, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 44.18, ["Mega"] = 36.19, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 224.02}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 3.92, ["Neon|Ride"] = 137.71, ["Mega"] = 62.89, ["Mega|Ride"] = 137.7}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 52.5, ["Ride"] = 68.87, ["Fly|Ride"] = 449.61, ["Neon"] = 390.53, ["Neon|Ride"] = 491.18, ["Neon|Fly|Ride"] = 548.72, ["Mega"] = 1541.33, ["Mega|Ride"] = 1541.33, ["Mega|Fly|Ride"] = 1322.46}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 4.03, ["Ride"] = 56.95, ["Fly|Ride"] = 131.25, ["Neon"] = 46.49, ["Neon|Ride"] = 139.46, ["Mega"] = 364.58, ["Mega|Ride"] = 393.75}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 196.88, ["Fly"] = 464.72, ["Ride"] = 431.59, ["Fly|Ride"] = 616.62, ["Neon"] = 1642.24, ["Neon|Ride"] = 1644.08, ["Neon|Fly|Ride"] = 1155, ["Mega|Ride"] = 3559.43, ["Mega|Fly|Ride"] = 3837.89}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 84}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 45.39}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 23.37}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 34.88}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 65}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 51.14}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 19.69}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 8.39}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 245.43}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 15.75}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 30.7}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 6.39}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 3.15}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 205.52}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 2.1}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 3.84}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 6.57}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 6.23}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 8.9}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 500.43}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 713.13}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 11.82}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1039.47}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 36.2}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 6.56}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 20.46}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.52}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 40.08}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 40.69}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 49.65}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 15.74}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 8.88}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 14.18}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.94}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 16.77}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.62}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 15.75}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 9.19}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 3.68}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 4.13}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1837.5}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 44.1}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 308.44}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 2.12}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 7.88}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 6.21}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 34.8}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 193.17}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 8.34}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 7.88}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 1368.7}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 23.62}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 3.7}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.63}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 15.75}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 31.5}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 5.25}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 178.5}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 28.87}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 7.88}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.63}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 27.17}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 5.13}},
    ["rbxassetid://1265129203"] = {name = "Ice Snowboard", prices = {["default"] = 1953}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 3.62}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 26.25}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 105}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 190.32}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 3.55}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 10.5}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 27.44}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 26.16}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 77.33}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 17.07}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22132.21}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 141.75}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 37.97}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 134.3}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 82.22}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 137.71}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 420}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 32.82}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 65.63}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 66.45}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 55.08}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 32.82}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 62.39}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 47.75}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 177.38}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 343.14}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 3.84}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 7.88}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 11.67}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 3.94}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 24.94}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 89.25}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.2}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 3.94}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 5.25}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 5.25}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 263.06}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 748.13}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 7.68}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 577.4}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 23.5}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.63}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 604.21}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 57.66}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 115.48}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 54.04}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 68.25}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 203.44}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 14.17}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.56}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 15.75}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 4.6}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 9.31}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 34.88}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.82}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.63}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.94}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 16.8}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 154.88}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 97.63}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.42}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1048.69}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 6.18}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 5.65}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 5.13}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 17.07}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 30.19}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 5.39}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 5.53}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 78.64}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 11.9}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 65.63}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 32.82}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 9.31}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 155.72}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 3.84}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 5.2}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 6.45}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 137.7}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 3.92}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 2.43}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 6303.27}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.5}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 17.63}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3.2}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.86}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 4.13}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 5.13}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 7.76}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.72}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 9.19}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 95.7}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 24.94}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.43}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.72}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 89.71}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 6.21}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4276.13}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 5.25}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 27.57}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 2.5}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 39.38}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 3.7}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 4.73}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 92.29}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.14}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.56}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 7.25}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 5.13}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 7.88}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 18.37}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.54}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.16}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 10.31}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 2.5}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.57}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.6}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.13}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.36}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.63}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 19.47}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 6562.5}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 9.06}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 84.96}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.48}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 45.94}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 3.82}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 3.82}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1040.82}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 27.57}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 4.64}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 13.13}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 26.25}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 4.66}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 77.44}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 5.46}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 11.45}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 3.3}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 15.75}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 15.75}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.52}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.94}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 15.75}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.21}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.52}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 19.45}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.61}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 8.72}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 36.95}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 7.56}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.23}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.52}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 15.65}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 43.46}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 18.14}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 4.79}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.61}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 206.7}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 27.46}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 4.5}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 5.97}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.63}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 6.34}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 315}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 144.37}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1115.63}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 213.7}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 3.82}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.63}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 24.94}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 57.73}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 4.66}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 2.96}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 32.69}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 9.76}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 9.19}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.63}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 6.57}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.63}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 68.16}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 55.92}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 4.19}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 73.5}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 3.5}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.41}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 25.39}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 118.13}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 5.99}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.6}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 72.09}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 6.57}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.63}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 65.62}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 47.16}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 78.27}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 328.13}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.94}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 155.7}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 3.03}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 131.62}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.91}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 6.18}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 27.57}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 51.09}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.94}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 42.75}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 6.03}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 7.88}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 16.96}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 22.32}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 35.15}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 4.94}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 36.64}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 16.49}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 685.38}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 3.68}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 137.7}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.56}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 10.5}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 45.91}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.26}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 69.74}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 137.79}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1782.37}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 7.61}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 5.25}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 40.08}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 361.83}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 24.68}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 6.57}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 314.98}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 105.95}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 6.04}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 275.63}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 32.82}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 31.5}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 11.32}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.49}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 99.94}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 115.5}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 61.69}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1050}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 194.06}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 11.32}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2055.11}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 498.75}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 3.62}},
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