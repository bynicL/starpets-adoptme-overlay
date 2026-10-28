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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 803.25, ["Ride"] = 913.5, ["Fly|Ride"] = 1050, ["Neon"] = 4118.38, ["Neon|Fly|Ride"] = 3927, ["Mega|Fly|Ride"] = 32951.04}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 426.57, ["Fly"] = 607.48, ["Ride"] = 494.78, ["Fly|Ride"] = 556.49, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 2165.63, ["Mega"] = 10295.93, ["Mega|Fly|Ride"] = 7734.42}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4593.75, ["Ride"] = 4265.63, ["Fly|Ride"] = 4461.19, ["Neon|Fly|Ride"] = 20876.52, ["Mega|Fly|Ride"] = 68648.34}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 131.25, ["Ride"] = 192.74, ["Fly|Ride"] = 398.47, ["Neon"] = 773.91, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 1098.59, ["Mega"] = 4118.38, ["Mega|Fly|Ride"] = 3396.75}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 590.63, ["Fly"] = 823.7, ["Ride"] = 590.28, ["Fly|Ride"] = 599.82, ["Neon|Fly|Ride"] = 1662.54, ["Mega|Fly|Ride"] = 6300}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 7.54, ["Ride"] = 27.68, ["Fly|Ride"] = 155.49, ["Neon"] = 56.44, ["Neon|Fly"] = 274.93, ["Neon|Ride"] = 109.04, ["Neon|Fly|Ride"] = 274.93, ["Mega"] = 285.27, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 464.05}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 5.92, ["Fly"] = 42.24, ["Ride"] = 26.25, ["Fly|Ride"] = 60.75, ["Neon"] = 26.25, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 46.06, ["Neon|Fly|Ride"] = 114.07, ["Mega"] = 131.25, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 102.92, ["Ride"] = 147.72, ["Fly|Ride"] = 233.73, ["Neon"] = 521.07, ["Neon|Ride"] = 617.76, ["Neon|Fly|Ride"] = 669.38, ["Mega|Ride"] = 2334.39, ["Mega|Fly|Ride"] = 2656.5}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 32.96, ["Fly"] = 81.24, ["Ride"] = 52.49, ["Fly|Ride"] = 98.44, ["Neon"] = 252, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 317.14, ["Mega"] = 2100, ["Mega|Ride"] = 1392.14, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 24.92, ["Fly"] = 55, ["Ride"] = 35.6, ["Fly|Ride"] = 64.72, ["Neon"] = 274.93, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 1337.62, ["Mega|Fly|Ride"] = 961.77}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 58.48, ["Fly"] = 206.07, ["Ride"] = 76.35, ["Fly|Ride"] = 166.46, ["Neon"] = 491.97, ["Neon|Fly"] = 398.47, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 288.75, ["Mega|Fly|Ride"] = 1544.6}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 63.63}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 295.32, ["Fly"] = 395.01, ["Ride"] = 351, ["Fly|Ride"] = 379.02, ["Neon"] = 1304.5, ["Neon|Ride"] = 1237.52, ["Neon|Fly|Ride"] = 1098.59, ["Mega|Fly|Ride"] = 4839.7}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 116.94, ["Fly"] = 155.52, ["Ride"] = 122.14, ["Fly|Ride"] = 161.09, ["Neon|Fly"] = 672.71, ["Neon|Fly|Ride"] = 617.76, ["Mega|Fly|Ride"] = 2628.81}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.61, ["Fly"] = 114.3, ["Ride"] = 51.85, ["Fly|Ride"] = 131.23, ["Neon"] = 21, ["Neon|Fly"] = 96.41, ["Neon|Fly|Ride"] = 189, ["Mega"] = 131.25, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 205.96, ["Mega|Fly|Ride"] = 384.01}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 179.17, ["Fly"] = 202.71, ["Ride"] = 150.94, ["Fly|Ride"] = 210, ["Neon"] = 928.23, ["Neon|Ride"] = 686.75, ["Neon|Fly|Ride"] = 632.19, ["Mega|Fly|Ride"] = 2229.94}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.63, ["Fly"] = 21.6, ["Ride"] = 18.55, ["Fly|Ride"] = 41.08, ["Neon"] = 23.63, ["Neon|Ride"] = 92.8, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 207.38, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 91.88, ["Fly"] = 262.5, ["Ride"] = 150.69, ["Fly|Ride"] = 258.28, ["Neon"] = 288.75, ["Neon|Fly"] = 463.95, ["Neon|Ride"] = 373.75, ["Neon|Fly|Ride"] = 430.39, ["Mega"] = 1510.42, ["Mega|Ride"] = 1301.9, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 37.57}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 65.63, ["Ride"] = 205.94, ["Fly|Ride"] = 294.67, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 1098.59, ["Mega|Fly|Ride"] = 1840.12}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 18, ["Fly"] = 393.75, ["Ride"] = 28.88, ["Fly|Ride"] = 110.18, ["Neon"] = 205.86, ["Neon|Ride"] = 179.17, ["Neon|Fly|Ride"] = 205.94, ["Mega|Ride"] = 579.74, ["Mega|Fly|Ride"] = 1647.57}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 44.99, ["Fly"] = 82.39, ["Ride"] = 55.13, ["Fly|Ride"] = 127.28, ["Neon"] = 241.34, ["Neon|Ride"] = 233.63, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 1623.75, ["Mega|Fly|Ride"] = 807}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 55.86, ["Ride"] = 189, ["Fly|Ride"] = 137.97, ["Neon"] = 191.02, ["Neon|Fly"] = 385.07, ["Neon|Ride"] = 186.17, ["Neon|Fly|Ride"] = 353.17, ["Mega"] = 1161.4, ["Mega|Ride"] = 1231.56, ["Mega|Fly|Ride"] = 1214.07}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 19.69, ["Ride"] = 41.1, ["Fly|Ride"] = 137.17, ["Neon"] = 343.89, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 292.28, ["Mega"] = 821.63, ["Mega|Ride"] = 2057.4, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 41.42, ["Fly"] = 116.06, ["Ride"] = 59.63, ["Fly|Ride"] = 196.88, ["Neon"] = 210, ["Neon|Fly"] = 550.85, ["Neon|Ride"] = 180.09, ["Neon|Fly|Ride"] = 309.68, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 885.44}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 5.84, ["Fly"] = 31.35, ["Ride"] = 22.31, ["Fly|Ride"] = 52.53, ["Neon"] = 30.96, ["Neon|Fly"] = 105, ["Neon|Ride"] = 45.82, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 131.25, ["Mega|Fly"] = 24849.92, ["Mega|Ride"] = 181.13, ["Mega|Fly|Ride"] = 249.55}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 339.9, ["Ride"] = 411.86, ["Fly|Ride"] = 454.88, ["Neon"] = 1853.28, ["Neon|Ride"] = 1956.25, ["Neon|Fly|Ride"] = 1680, ["Mega|Fly|Ride"] = 7116.09}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 14.11, ["Ride"] = 32.45, ["Fly|Ride"] = 107.34, ["Neon"] = 219.18, ["Neon|Ride"] = 177.1, ["Neon|Fly|Ride"] = 420.09, ["Mega"] = 513.78, ["Mega|Ride"] = 782.6, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 5.87, ["Fly"] = 34.54, ["Ride"] = 22.15, ["Fly|Ride"] = 44.54, ["Neon"] = 52.5, ["Neon|Ride"] = 72.09, ["Neon|Fly|Ride"] = 119.43, ["Mega|Ride"] = 267.47, ["Mega|Fly|Ride"] = 420.57}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 59.07, ["Fly"] = 117.12, ["Ride"] = 85.62, ["Fly|Ride"] = 152.39, ["Neon"] = 364.49, ["Neon|Fly"] = 376.72, ["Neon|Ride"] = 385.75, ["Neon|Fly|Ride"] = 404.25, ["Mega"] = 3020.83, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 2064.57}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 13.55, ["Ride"] = 23.15, ["Fly|Ride"] = 75.22, ["Neon"] = 137.97, ["Neon|Ride"] = 137.97, ["Neon|Fly|Ride"] = 160.79, ["Mega"] = 479.16, ["Mega|Ride"] = 785.7}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 193.26, ["Fly"] = 348.03, ["Ride"] = 263.6, ["Fly|Ride"] = 284.19, ["Neon"] = 702.19, ["Neon|Ride"] = 735, ["Neon|Fly|Ride"] = 1250.29, ["Mega"] = 6177.56, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2932.65}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 27.45}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 4.2, ["Fly"] = 26.91, ["Ride"] = 23.63, ["Fly|Ride"] = 49.39, ["Neon"] = 25.54, ["Neon|Fly"] = 132.23, ["Neon|Ride"] = 46.41, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 131.55, ["Mega|Fly"] = 501.42, ["Mega|Ride"] = 274.37, ["Mega|Fly|Ride"] = 288.33}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 879.38, ["Fly"] = 2625, ["Ride"] = 874.13, ["Fly|Ride"] = 1133.63, ["Neon"] = 7158.38, ["Neon|Ride"] = 6040.62, ["Neon|Fly|Ride"] = 4003.13, ["Mega|Ride"] = 52204.65, ["Mega|Fly|Ride"] = 20109.25}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 7.46, ["Fly"] = 68.99, ["Ride"] = 32.8, ["Fly|Ride"] = 85.32, ["Neon"] = 91.55, ["Neon|Ride"] = 118.09, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 480.83, ["Mega|Ride"] = 695.07, ["Mega|Fly|Ride"] = 820.31}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 155.52, ["Ride"] = 213.72, ["Fly|Ride"] = 278.49, ["Neon"] = 872.08, ["Neon|Ride"] = 541.65, ["Neon|Fly|Ride"] = 787.5, ["Mega|Ride"] = 2475.67, ["Mega|Fly|Ride"] = 3021.21}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 45.94}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 21.92, ["Fly"] = 68.84, ["Ride"] = 52.29, ["Fly|Ride"] = 137.97, ["Neon"] = 82.41, ["Neon|Ride"] = 201.81, ["Neon|Fly|Ride"] = 164.75, ["Mega"] = 670.9, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 727.39}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 114.3, ["Ride"] = 127.32, ["Neon"] = 584.07, ["Neon|Ride"] = 463.95, ["Neon|Fly|Ride"] = 586.88, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 148.32, ["Ride"] = 143.07, ["Fly|Ride"] = 272.85, ["Neon"] = 525, ["Neon|Ride"] = 364.88, ["Neon|Fly|Ride"] = 590.62, ["Mega"] = 1544.4, ["Mega|Ride"] = 1246.88, ["Mega|Fly|Ride"] = 2059.45}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 40.69}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 52.41, ["Fly"] = 61.35, ["Ride"] = 55.05, ["Fly|Ride"] = 82.98, ["Neon|Ride"] = 477.85, ["Neon|Fly|Ride"] = 326.82, ["Mega"] = 4118.38, ["Mega|Fly|Ride"] = 1486.9}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 7.76, ["Fly"] = 55.61, ["Ride"] = 81.24, ["Fly|Ride"] = 131.25, ["Neon"] = 32.82, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 231.67, ["Mega"] = 166.07, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 274.95, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 446.25, ["Fly"] = 596.15, ["Ride"] = 465.51, ["Fly|Ride"] = 472.5, ["Neon|Ride"] = 3697.79, ["Neon|Fly|Ride"] = 1506.75, ["Mega|Fly|Ride"] = 6298.95}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 82.69, ["Fly"] = 162.48, ["Ride"] = 109.08, ["Fly|Ride"] = 137.82, ["Neon"] = 446.25, ["Neon|Fly"] = 823.7, ["Neon|Ride"] = 549.82, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 2470.31, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3515.04, ["Ride"] = 3706.55, ["Fly|Ride"] = 3674.99, ["Neon|Fly|Ride"] = 14413.27}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 42.68, ["Fly"] = 110.18, ["Ride"] = 52.4, ["Fly|Ride"] = 118.13, ["Neon"] = 393.75, ["Neon|Ride"] = 329.32, ["Neon|Fly|Ride"] = 343.89, ["Mega|Ride"] = 1182.13, ["Mega|Fly|Ride"] = 1222.29}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 78.75, ["Ride"] = 69.63, ["Fly|Ride"] = 195.57, ["Neon"] = 410.42, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 683.76, ["Mega"] = 2745.93, ["Mega|Fly|Ride"] = 2784.26}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 34.55, ["Fly"] = 77.23, ["Ride"] = 59.73, ["Fly|Ride"] = 105.87, ["Neon"] = 216.99, ["Neon|Ride"] = 148.28, ["Neon|Fly|Ride"] = 194.22, ["Mega"] = 961.65, ["Mega|Ride"] = 686.83, ["Mega|Fly|Ride"] = 596.73}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 6.57}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 46.35, ["Fly"] = 393.75, ["Ride"] = 41.2, ["Fly|Ride"] = 63.63, ["Neon"] = 360.38, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1392.14}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 37.68}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 192.54, ["Ride"] = 245.06, ["Fly|Ride"] = 315.07, ["Neon|Ride"] = 1391.79, ["Neon|Fly|Ride"] = 1373.49, ["Mega|Fly|Ride"] = 4950.18}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 1017.26, ["Ride"] = 1023.75, ["Fly|Ride"] = 1043.44, ["Neon"] = 2625, ["Neon|Ride"] = 3557.13, ["Neon|Fly|Ride"] = 3018.74}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 5.25}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 26.17, ["Fly"] = 62.68, ["Ride"] = 39.72, ["Fly|Ride"] = 60.32, ["Neon"] = 229.71, ["Neon|Ride"] = 141.04, ["Neon|Fly|Ride"] = 190.31, ["Mega|Ride"] = 656.15, ["Mega|Fly|Ride"] = 923.68}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 14.31}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 6301.12, ["Fly"] = 5628.79, ["Fly|Ride"] = 4725, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 40217.31}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 14.95, ["Fly"] = 52.41, ["Ride"] = 26.23, ["Fly|Ride"] = 58.75, ["Neon"] = 115.28, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 219.19, ["Mega"] = 658.95, ["Mega|Ride"] = 588.18, ["Mega|Fly|Ride"] = 616.87}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 13.01, ["Fly"] = 41.2, ["Ride"] = 39.38, ["Fly|Ride"] = 114.87, ["Neon"] = 65.63, ["Neon|Ride"] = 132.49, ["Neon|Fly|Ride"] = 246.08, ["Mega"] = 1032.24, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 1026.65}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 94.74, ["Fly"] = 271.07, ["Ride"] = 72.18, ["Fly|Ride"] = 97.83, ["Neon|Ride"] = 381.99, ["Neon|Fly|Ride"] = 471.37, ["Mega"] = 4118.38}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 10.18, ["Fly"] = 150.93, ["Ride"] = 26.25, ["Fly|Ride"] = 139, ["Neon"] = 74.87, ["Neon|Ride"] = 70.87, ["Neon|Fly|Ride"] = 501.37, ["Mega"] = 1373.49, ["Mega|Ride"] = 501.48, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1776.7, ["Fly"] = 2122.32, ["Ride"] = 1949.07, ["Fly|Ride"] = 1785, ["Neon|Fly|Ride"] = 3430.35, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 29400, ["Ride"] = 28828.58, ["Fly|Ride"] = 25265.63, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 68639.82, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183750}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 17.07, ["Fly"] = 393.74, ["Ride"] = 52.53, ["Fly|Ride"] = 89.59, ["Neon"] = 205.94, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 308.88, ["Mega"] = 961.65, ["Mega|Ride"] = 755.84, ["Mega|Fly|Ride"] = 819.68}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.03, ["Fly"] = 76.56, ["Ride"] = 39.38, ["Fly|Ride"] = 199.5, ["Neon"] = 19.58, ["Neon|Fly"] = 133.86, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 118.02, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 288.54}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 21}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 6.48, ["Ride"] = 44.29, ["Fly|Ride"] = 125.24, ["Neon"] = 64.87, ["Neon|Ride"] = 125.32, ["Neon|Fly|Ride"] = 463.33, ["Mega"] = 523.08, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 545.57}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 643.13, ["Ride"] = 735, ["Fly|Ride"] = 786.19, ["Neon|Fly|Ride"] = 2808.75, ["Mega|Fly|Ride"] = 8469.57}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 951.81, ["Fly"] = 1076.25, ["Ride"] = 1015.19, ["Fly|Ride"] = 1016.54, ["Neon|Fly|Ride"] = 3109.31, ["Mega|Fly|Ride"] = 11326.93}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 15.26, ["Fly"] = 116.04, ["Ride"] = 28.88, ["Fly|Ride"] = 90.57, ["Neon"] = 105, ["Neon|Ride"] = 119.9, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1132.58, ["Mega|Ride"] = 685.13, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 26.17}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 62.79, ["Fly"] = 92.85, ["Ride"] = 65.63, ["Fly|Ride"] = 122.54, ["Neon"] = 411.86, ["Neon|Ride"] = 316.1, ["Neon|Fly|Ride"] = 390.23, ["Mega|Ride"] = 2016.2, ["Mega|Fly|Ride"] = 1664.25}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 57.88, ["Ride"] = 77.23, ["Fly|Ride"] = 228.38, ["Neon"] = 343.89, ["Neon|Ride"] = 287.28, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 2074.87, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.93, ["Fly"] = 44.63, ["Ride"] = 20.01, ["Fly|Ride"] = 51.33, ["Neon"] = 38.07, ["Neon|Fly"] = 524.98, ["Neon|Ride"] = 68.44, ["Neon|Fly|Ride"] = 132.54, ["Mega"] = 322.88, ["Mega|Ride"] = 287.44, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 108.94, ["Fly"] = 91.88, ["Ride"] = 124.04, ["Fly|Ride"] = 192.93, ["Neon|Ride"] = 450.21, ["Neon|Fly|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1476.57}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 4.66, ["Ride"] = 46.43, ["Fly|Ride"] = 110.12, ["Neon"] = 43.26, ["Neon|Ride"] = 120.94, ["Neon|Fly|Ride"] = 479.81, ["Mega"] = 229.63, ["Mega|Ride"] = 240.97, ["Mega|Fly|Ride"] = 511.54}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 17.07, ["Fly"] = 41.11, ["Ride"] = 28.88, ["Fly|Ride"] = 90.62, ["Neon"] = 84, ["Neon|Ride"] = 109.19, ["Neon|Fly|Ride"] = 162.69, ["Mega|Fly|Ride"] = 755.84}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 25.62, ["Ride"] = 74.72, ["Fly|Ride"] = 156.19, ["Neon"] = 262.56, ["Neon|Ride"] = 329.48, ["Neon|Fly|Ride"] = 274.93, ["Mega"] = 695.9, ["Mega|Ride"] = 773.8, ["Mega|Fly|Ride"] = 823.79}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 16.7, ["Fly"] = 138.29, ["Ride"] = 28.88, ["Fly|Ride"] = 49.88, ["Neon"] = 91.88, ["Neon|Ride"] = 109.04, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 823.7, ["Mega|Ride"] = 926.77, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 7195.06, ["Ride"] = 7141.32, ["Fly|Ride"] = 6685.88, ["Neon"] = 30887.76, ["Neon|Fly|Ride"] = 27320.23}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 262.48, ["Fly"] = 271.83, ["Ride"] = 255.36, ["Fly|Ride"] = 295.32, ["Neon|Fly|Ride"] = 529.92, ["Mega|Fly|Ride"] = 2098.69}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 41.55, ["Fly"] = 150.94, ["Ride"] = 73.5, ["Fly|Ride"] = 131.25, ["Neon"] = 90.56, ["Neon|Fly"] = 179.17, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 380.63, ["Mega|Ride"] = 357, ["Mega|Fly|Ride"] = 504}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.62, ["Fly"] = 85.87, ["Ride"] = 23.63, ["Fly|Ride"] = 96.8, ["Neon"] = 23.06, ["Neon|Ride"] = 55.61, ["Neon|Fly|Ride"] = 187.4, ["Mega"] = 129.94, ["Mega|Ride"] = 187.69}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 47.25, ["Fly"] = 5244.57, ["Ride"] = 84, ["Fly|Ride"] = 191.91, ["Neon"] = 196.88, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 327.53, ["Mega"] = 435.75, ["Mega|Ride"] = 417.65, ["Mega|Fly|Ride"] = 584.73}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 14385, ["Ride"] = 13415.07, ["Fly|Ride"] = 12075, ["Neon|Fly|Ride"] = 27562.5}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 164.07, ["Ride"] = 164.07, ["Fly|Ride"] = 164.07, ["Neon"] = 1497.04, ["Neon|Ride"] = 1441.43, ["Neon|Fly|Ride"] = 1441.43, ["Mega|Fly|Ride"] = 5107.43}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 61.69, ["Fly"] = 112.89, ["Ride"] = 74.73, ["Fly|Ride"] = 96.37, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 407.84, ["Mega|Fly|Ride"] = 2572.25}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 10.13, ["Fly"] = 44.1, ["Ride"] = 24.94, ["Fly|Ride"] = 55.55, ["Neon"] = 85.32, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 112.22, ["Mega"] = 316.1, ["Mega|Ride"] = 343.94, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 328.02, ["Ride"] = 412.12, ["Fly|Ride"] = 549.82, ["Neon"] = 1647.37, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1717.37, ["Mega|Fly|Ride"] = 5011.13}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 3.94, ["Fly"] = 101.53, ["Ride"] = 37.82, ["Fly|Ride"] = 85.32, ["Neon"] = 25.91, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 273.89, ["Mega"] = 129.93, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 131.25, ["Fly"] = 205.94, ["Ride"] = 161.44, ["Fly|Ride"] = 233.73, ["Neon"] = 761.92, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2565.86}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 9.19, ["Fly"] = 15.47, ["Ride"] = 18.38, ["Fly|Ride"] = 31.98, ["Neon|Ride"] = 96.37, ["Neon|Fly|Ride"] = 103.68, ["Mega"] = 786.19, ["Mega|Fly|Ride"] = 1005.82}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 10.5}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 74.72, ["Ride"] = 86.63, ["Fly|Ride"] = 279.57, ["Neon"] = 421.32, ["Neon|Fly"] = 549.82, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1459.5}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 13.81, ["Fly"] = 101.95, ["Ride"] = 35.65, ["Fly|Ride"] = 86.52, ["Neon"] = 102.98, ["Neon|Ride"] = 82.29, ["Neon|Fly|Ride"] = 204.91, ["Mega"] = 1027.55, ["Mega|Ride"] = 669.38, ["Mega|Fly|Ride"] = 669.38}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 23.12}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 36.73, ["Fly"] = 131.25, ["Ride"] = 65.62, ["Fly|Ride"] = 249.38, ["Neon"] = 237.85, ["Neon|Ride"] = 258.54, ["Neon|Fly|Ride"] = 344.03, ["Mega"] = 1098.59, ["Mega|Ride"] = 959.72, ["Mega|Fly|Ride"] = 945}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 4.14, ["Ride"] = 29.23, ["Fly|Ride"] = 132.29, ["Neon"] = 22.66, ["Neon|Ride"] = 104.4, ["Neon|Fly|Ride"] = 267.71, ["Mega"] = 120.75, ["Mega|Fly|Ride"] = 412.79}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 14.12, ["Fly"] = 47.25, ["Ride"] = 36.05, ["Fly|Ride"] = 90.57, ["Neon|Ride"] = 137.97, ["Neon|Fly|Ride"] = 171.86, ["Mega|Ride"] = 574.6, ["Mega|Fly|Ride"] = 590.28}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 537.32, ["Ride"] = 452.61, ["Fly|Ride"] = 523.69, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 10984.03}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 36.74, ["Fly"] = 102.98, ["Ride"] = 55.11, ["Fly|Ride"] = 103.69, ["Neon"] = 233.73, ["Neon|Ride"] = 176.47, ["Neon|Fly|Ride"] = 303.75, ["Mega"] = 1011.9, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 891.75}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 50.55, ["Fly"] = 117.49, ["Ride"] = 83.55, ["Fly|Ride"] = 123.56, ["Neon|Ride"] = 317.14, ["Neon|Fly|Ride"] = 328.12, ["Mega|Ride"] = 720.82, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 24.98, ["Fly"] = 87.94, ["Ride"] = 68.25, ["Fly|Ride"] = 146.22, ["Neon"] = 144.16, ["Neon|Ride"] = 124.11, ["Neon|Fly|Ride"] = 237.87, ["Mega"] = 414.74, ["Mega|Ride"] = 409.5, ["Mega|Fly|Ride"] = 605.51}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 8400, ["Ride"] = 13274, ["Fly|Ride"] = 7599.38, ["Neon|Fly|Ride"] = 14168.41, ["Mega|Fly|Ride"] = 39373.95}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1509.27, ["Fly"] = 1706.25, ["Ride"] = 1575, ["Fly|Ride"] = 1508.96, ["Neon|Fly|Ride"] = 4501.88, ["Mega|Fly|Ride"] = 15356.25}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 518.44, ["Ride"] = 505.32, ["Fly|Ride"] = 525, ["Neon"] = 2260.55, ["Neon|Fly|Ride"] = 2368.07, ["Mega|Fly|Ride"] = 6725.12}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 10.4, ["Fly"] = 23.63, ["Ride"] = 20.3, ["Fly|Ride"] = 41.2, ["Neon"] = 110.18, ["Neon|Ride"] = 94.74, ["Neon|Fly|Ride"] = 124.55, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 4.66, ["Fly"] = 78.74, ["Ride"] = 32.18, ["Neon"] = 15.75, ["Neon|Ride"] = 83.52, ["Neon|Fly|Ride"] = 227.07, ["Mega"] = 133.14, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 432.5}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 43.88, ["Fly"] = 78.75, ["Ride"] = 52.5, ["Fly|Ride"] = 91.88, ["Neon"] = 203.87, ["Neon|Ride"] = 195.57, ["Neon|Fly|Ride"] = 162.07, ["Mega|Fly|Ride"] = 511.67}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.94, ["Fly"] = 30.19, ["Ride"] = 18.46, ["Fly|Ride"] = 37.91, ["Neon"] = 27.81, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 203.81, ["Mega|Ride"] = 206.07, ["Mega|Fly|Ride"] = 288.33}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 315, ["Fly"] = 320.25, ["Ride"] = 248.07, ["Fly|Ride"] = 274.32, ["Neon"] = 1112.93, ["Neon|Ride"] = 1273.13, ["Neon|Fly|Ride"] = 1169.44}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 18.38, ["Fly"] = 82.39, ["Ride"] = 32.82, ["Fly|Ride"] = 76.48, ["Neon"] = 188.43, ["Neon|Fly"] = 407.52, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 823.7, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 10.95, ["Fly"] = 18.37, ["Ride"] = 20.4, ["Fly|Ride"] = 43.83, ["Neon"] = 72.18, ["Neon|Fly"] = 132.23, ["Neon|Ride"] = 80.56, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 291.38}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 576.59, ["Fly"] = 787.5, ["Ride"] = 435.75, ["Fly|Ride"] = 658.95, ["Neon|Ride"] = 2882.86, ["Mega|Fly|Ride"] = 8619.21}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1050, ["Fly"] = 1392.61, ["Ride"] = 1154.99, ["Fly|Ride"] = 1181.25, ["Neon"] = 4805.12, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13782.3}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 91.88, ["Fly"] = 128.63, ["Ride"] = 99.52, ["Fly|Ride"] = 123.38, ["Neon"] = 971.25, ["Neon|Ride"] = 585.46, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 146.64, ["Fly"] = 157.5, ["Ride"] = 199.76, ["Fly|Ride"] = 245.44, ["Neon"] = 577.5, ["Neon|Ride"] = 695.9, ["Neon|Fly|Ride"] = 603.75, ["Mega|Ride"] = 8603.44, ["Mega|Fly|Ride"] = 2320.22}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 69.21, ["Ride"] = 61.64, ["Fly|Ride"] = 274.93, ["Neon"] = 235.09, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 385.08, ["Mega|Ride"] = 2059.45, ["Mega|Fly|Ride"] = 823.79}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 129.94, ["Ride"] = 205.94, ["Fly|Ride"] = 128.63, ["Neon|Fly|Ride"] = 1299, ["Mega|Fly|Ride"] = 3295.13}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2099.99, ["Fly"] = 2334.09, ["Ride"] = 2238.35, ["Fly|Ride"] = 2059.19, ["Neon|Fly|Ride"] = 10295.93, ["Mega|Fly|Ride"] = 24749.65}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 65.86, ["Ride"] = 68.99, ["Fly|Ride"] = 196.88, ["Neon"] = 350.07, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 343.87, ["Mega|Ride"] = 2265.4, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 560.44, ["Fly"] = 616.88, ["Ride"] = 602.43, ["Fly|Ride"] = 624.75, ["Neon|Ride"] = 1468.21, ["Neon|Fly|Ride"] = 1107.75, ["Mega|Fly|Ride"] = 3109.32}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 45.31, ["Fly"] = 60.38, ["Ride"] = 52.5, ["Fly|Ride"] = 100.11, ["Neon|Ride"] = 359.56, ["Neon|Fly|Ride"] = 267.75, ["Mega|Fly|Ride"] = 1098.72}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.24, ["Fly"] = 39.37, ["Ride"] = 20.56, ["Fly|Ride"] = 51.19, ["Neon"] = 19.59, ["Neon|Fly"] = 90.57, ["Neon|Ride"] = 44.4, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 144.31, ["Mega|Fly"] = 249.26, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 50.17, ["Ride"] = 123.05, ["Fly|Ride"] = 252, ["Neon"] = 259.88, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 686.75, ["Mega"] = 1505.27, ["Mega|Ride"] = 1373.66, ["Mega|Fly|Ride"] = 1235.68}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 826.77, ["Fly"] = 1015.45, ["Ride"] = 818.49, ["Fly|Ride"] = 826.88, ["Neon|Ride"] = 1968.75, ["Neon|Fly|Ride"] = 2249.88, ["Mega|Fly|Ride"] = 9443.58}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 623.7, ["Ride"] = 643.13, ["Fly|Ride"] = 872.82, ["Neon"] = 5147.97, ["Neon|Fly|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 16475.52}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 15, ["Fly"] = 26.25, ["Ride"] = 24.43, ["Fly|Ride"] = 52.5, ["Neon"] = 185.34, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 786.19, ["Mega|Ride"] = 686.83, ["Mega|Fly|Ride"] = 681.29}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 10.15, ["Ride"] = 23.55, ["Fly|Ride"] = 45.94, ["Neon"] = 72.02, ["Neon|Ride"] = 77.73, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 506.58, ["Mega|Ride"] = 506.64, ["Mega|Fly|Ride"] = 407.78}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 4.82, ["Ride"] = 24.92, ["Fly|Ride"] = 111.46, ["Neon"] = 21, ["Neon|Fly"] = 309.68, ["Neon|Ride"] = 53.37, ["Neon|Fly|Ride"] = 152.39, ["Mega"] = 140.38, ["Mega|Fly"] = 526.57, ["Mega|Ride"] = 220.49, ["Mega|Fly|Ride"] = 303.78}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 46.44, ["Fly"] = 85.32, ["Ride"] = 52.49, ["Fly|Ride"] = 110.24, ["Neon"] = 210, ["Neon|Ride"] = 216.56, ["Neon|Fly|Ride"] = 236.25, ["Mega|Fly|Ride"] = 953.01}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 63, ["Ride"] = 103.69, ["Fly|Ride"] = 449.61, ["Neon"] = 415.63, ["Neon|Ride"] = 497.31, ["Neon|Fly|Ride"] = 686.75, ["Mega"] = 1544.4, ["Mega|Ride"] = 1544.6, ["Mega|Fly|Ride"] = 1367.48}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 10.5, ["Fly"] = 55.48, ["Ride"] = 34.13, ["Fly|Ride"] = 78.66, ["Neon"] = 72.19, ["Neon|Ride"] = 108.94, ["Neon|Fly|Ride"] = 173.25, ["Mega"] = 340.28, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 32.8, ["Fly"] = 136.5, ["Ride"] = 46.4, ["Fly|Ride"] = 83.16, ["Neon"] = 549.82, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 269.07, ["Mega"] = 2100, ["Mega|Ride"] = 961.77, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 4.14, ["Fly"] = 27.82, ["Ride"] = 18.72, ["Fly|Ride"] = 40.58, ["Neon"] = 28.25, ["Neon|Ride"] = 41.43, ["Neon|Fly|Ride"] = 91.72, ["Mega"] = 525, ["Mega|Ride"] = 274.95, ["Mega|Fly|Ride"] = 315.11}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 6.02, ["Fly"] = 32.73, ["Ride"] = 28.58, ["Fly|Ride"] = 85.14, ["Neon"] = 25.97, ["Neon|Fly"] = 139, ["Neon|Ride"] = 73.41, ["Neon|Fly|Ride"] = 162.69, ["Mega"] = 293.25, ["Mega|Ride"] = 302.3, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 46.44, ["Fly"] = 65.62, ["Ride"] = 51.19, ["Fly|Ride"] = 89.45, ["Neon"] = 402.63, ["Neon|Ride"] = 190.32, ["Neon|Fly|Ride"] = 273, ["Mega|Fly|Ride"] = 1019.08}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1600.9, ["Fly"] = 2619.29, ["Ride"] = 1391.25, ["Fly|Ride"] = 1438.5, ["Neon|Fly"] = 4697.23, ["Neon|Fly|Ride"] = 3739.32, ["Mega|Fly|Ride"] = 13148.62}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 485.63, ["Fly"] = 479.75, ["Ride"] = 456.75, ["Fly|Ride"] = 479.07, ["Neon|Ride"] = 3020.83, ["Neon|Fly|Ride"] = 2992.5, ["Mega|Fly|Ride"] = 9609.35}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 263.7, ["Fly"] = 289.97, ["Ride"] = 280.67, ["Fly|Ride"] = 411.86, ["Neon|Fly|Ride"] = 1373.49, ["Mega|Fly|Ride"] = 6825}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 38.85}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 29.93, ["Ride"] = 41.9, ["Fly|Ride"] = 96.33, ["Neon"] = 329.54, ["Neon|Fly"] = 411.86, ["Neon|Ride"] = 352.14, ["Neon|Fly|Ride"] = 316.1, ["Mega"] = 1237.52, ["Mega|Ride"] = 961.77, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 41183.68, ["Fly"] = 65625, ["Ride"] = 34808, ["Fly|Ride"] = 17965.5, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 394.35, ["Fly"] = 611.63, ["Ride"] = 315, ["Fly|Ride"] = 387.19, ["Neon"] = 1371.43, ["Neon|Ride"] = 1141.88, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 6177.56, ["Mega|Fly|Ride"] = 3858.74}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 168, ["Fly"] = 525, ["Ride"] = 137.67, ["Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 4118.89}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 124.59, ["Fly"] = 262.5, ["Ride"] = 122.8, ["Fly|Ride"] = 178.5, ["Neon"] = 696.17, ["Neon|Ride"] = 509.66, ["Neon|Fly|Ride"] = 549.82, ["Mega"] = 7551.04, ["Mega|Fly|Ride"] = 1661.99}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 14.44, ["Fly"] = 94.5, ["Ride"] = 33.33, ["Fly|Ride"] = 105.7, ["Neon"] = 392.44, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 205.94, ["Mega"] = 686.75, ["Mega|Ride"] = 603.26, ["Mega|Fly|Ride"] = 576.66}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4393.28, ["Ride"] = 4641.09, ["Fly|Ride"] = 4067.44, ["Neon"] = 20454.92, ["Neon|Fly|Ride"] = 27456.14, ["Mega|Fly|Ride"] = 61872.97}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 27.62, ["Fly"] = 48.57, ["Ride"] = 37.08, ["Fly|Ride"] = 53.81, ["Neon"] = 228.59, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 1373.66, ["Mega|Fly|Ride"] = 823.79}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 35.32, ["Fly"] = 137.97, ["Ride"] = 44.62, ["Fly|Ride"] = 116.82, ["Neon"] = 343.89, ["Neon|Ride"] = 267.71, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1547.19, ["Mega|Fly|Ride"] = 1372.88}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 749.44, ["Fly"] = 918.75, ["Ride"] = 784.87, ["Fly|Ride"] = 824.25, ["Neon"] = 2126.25, ["Neon|Ride"] = 2185.53, ["Neon|Fly|Ride"] = 2231.24, ["Mega"] = 9047.04, ["Mega|Fly|Ride"] = 7218.75}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 12.92, ["Fly"] = 26.14, ["Ride"] = 20.06, ["Fly|Ride"] = 41.31, ["Neon"] = 131.25, ["Neon|Fly"] = 155.43, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 156, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 12.84, ["Fly"] = 96.8, ["Ride"] = 30.9, ["Fly|Ride"] = 464.13, ["Neon"] = 80.07, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 128.64, ["Mega|Ride"] = 522.09}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 86.73, ["Ride"] = 128.63, ["Fly|Ride"] = 294.73, ["Neon"] = 534.38, ["Neon|Ride"] = 525.34, ["Neon|Fly|Ride"] = 751.62, ["Mega|Fly|Ride"] = 2475.67}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 24.29, ["Fly"] = 105.04, ["Ride"] = 76.2, ["Fly|Ride"] = 167.84, ["Neon"] = 82.69, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 274.78, ["Mega"] = 275.63, ["Mega|Fly"] = 736.49, ["Mega|Ride"] = 297.47, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 4034.7, ["Ride"] = 4171.75, ["Fly|Ride"] = 3279.94, ["Neon"] = 12355.11, ["Neon|Ride"] = 13917.69, ["Neon|Fly|Ride"] = 9016.86, ["Mega"] = 61773.47, ["Mega|Fly|Ride"] = 32678.17}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 39.38, ["Ride"] = 64.32, ["Fly|Ride"] = 109.08, ["Neon"] = 220.43, ["Neon|Ride"] = 177.19, ["Neon|Fly|Ride"] = 411.86, ["Mega|Ride"] = 1028.7, ["Mega|Fly|Ride"] = 1235.68}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 5891.82, ["Ride"] = 7824.91, ["Fly|Ride"] = 6496.88, ["Neon|Fly|Ride"] = 17023.29, ["Mega|Fly|Ride"] = 68059.8}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.63, ["Fly"] = 20.89, ["Ride"] = 16.62, ["Fly|Ride"] = 41.51, ["Neon"] = 22.32, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 86.52, ["Mega"] = 448.86, ["Mega|Ride"] = 192.57, ["Mega|Fly|Ride"] = 274.95}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 20.65, ["Fly"] = 26.16, ["Ride"] = 26.25, ["Fly|Ride"] = 47.38, ["Neon"] = 137.97, ["Neon|Ride"] = 191.51, ["Neon|Fly|Ride"] = 168, ["Mega|Ride"] = 961.77, ["Mega|Fly|Ride"] = 935.82}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.59}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 11.71, ["Fly"] = 39.38, ["Ride"] = 39.25, ["Fly|Ride"] = 115.5, ["Neon"] = 137.97, ["Neon|Ride"] = 157.68, ["Mega"] = 770.6, ["Mega|Ride"] = 961.77, ["Mega|Fly|Ride"] = 748.13}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 30.11, ["Fly"] = 190.37, ["Ride"] = 44.63, ["Fly|Ride"] = 150.33, ["Neon"] = 189.47, ["Neon|Ride"] = 118.31, ["Neon|Fly|Ride"] = 279.67, ["Mega"] = 840, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 13.13, ["Fly"] = 23.55, ["Ride"] = 19.69, ["Fly|Ride"] = 36.75, ["Neon"] = 82.39, ["Neon|Ride"] = 114.3, ["Neon|Fly|Ride"] = 155.43, ["Mega"] = 786.19, ["Mega|Ride"] = 578.91, ["Mega|Fly|Ride"] = 502.69}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8339.7}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2724.85}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 20.1}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 131.24, ["Ride"] = 157.5, ["Fly|Ride"] = 183.75, ["Neon|Fly|Ride"] = 1029.61}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 20.61, ["Fly"] = 123.56, ["Ride"] = 48.57, ["Fly|Ride"] = 105, ["Neon"] = 137.97, ["Neon|Ride"] = 154.45, ["Neon|Fly|Ride"] = 204.91, ["Mega"] = 406.71, ["Mega|Ride"] = 928.09, ["Mega|Fly|Ride"] = 953.54}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 11.82}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.57, ["Ride"] = 29.22, ["Fly|Ride"] = 62.67, ["Neon"] = 52.5, ["Neon|Ride"] = 96.8, ["Mega|Fly|Ride"] = 823.79}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 3045}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 150.84, ["Fly"] = 411.86, ["Ride"] = 203.87, ["Fly|Ride"] = 183.75, ["Neon"] = 701.37, ["Neon|Ride"] = 846.83, ["Neon|Fly|Ride"] = 947.24, ["Mega|Ride"] = 3158.16, ["Mega|Fly|Ride"] = 3021.21}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 106.07, ["Ride"] = 109.15, ["Fly|Ride"] = 211.32, ["Neon"] = 549.82, ["Neon|Ride"] = 684.87, ["Neon|Fly|Ride"] = 463.95, ["Mega|Ride"] = 3295.13, ["Mega|Fly|Ride"] = 2475.67}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 163.87, ["Fly"] = 186.62, ["Ride"] = 207.38, ["Fly|Ride"] = 236.76, ["Neon"] = 897.75, ["Neon|Ride"] = 842.63, ["Neon|Fly|Ride"] = 959.89, ["Mega|Fly|Ride"] = 3178.26}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1548.11, ["Fly"] = 2471.03, ["Ride"] = 1707.79, ["Fly|Ride"] = 1813.31, ["Neon"] = 6188.87, ["Neon|Ride"] = 6451.44, ["Neon|Fly|Ride"] = 5248.69, ["Mega|Fly|Ride"] = 34031.65}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 18.01, ["Fly"] = 80.32, ["Ride"] = 39.47, ["Fly|Ride"] = 93.71, ["Neon"] = 155.49, ["Neon|Fly"] = 116, ["Neon|Ride"] = 203.87, ["Neon|Fly|Ride"] = 220.36, ["Mega"] = 925.62, ["Mega|Ride"] = 895.86, ["Mega|Fly|Ride"] = 1089.46}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 796.73, ["Fly"] = 2100, ["Ride"] = 678.43, ["Fly|Ride"] = 885.47, ["Neon|Ride"] = 2629.29, ["Neon|Fly|Ride"] = 4021.07}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 36.11}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 16.49, ["Ride"] = 48.41, ["Fly|Ride"] = 137.97, ["Neon"] = 91.88, ["Neon|Ride"] = 123.56, ["Neon|Fly|Ride"] = 273.89, ["Mega"] = 443.63, ["Mega|Ride"] = 457.95, ["Mega|Fly|Ride"] = 617.86}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 7.65, ["Fly"] = 48.41, ["Ride"] = 26.19, ["Fly|Ride"] = 44.18, ["Neon"] = 52.5, ["Neon|Ride"] = 78.62, ["Neon|Fly|Ride"] = 274.93, ["Mega"] = 918.75, ["Mega|Ride"] = 344.97, ["Mega|Fly|Ride"] = 356.16}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 49.86}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 30.6, ["Fly"] = 108.92, ["Ride"] = 34.13, ["Fly|Ride"] = 55.61, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 918.75, ["Mega|Ride"] = 823.79, ["Mega|Fly|Ride"] = 1392.14}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 26.25, ["Fly"] = 39.38, ["Ride"] = 32.82, ["Fly|Ride"] = 54.71, ["Neon|Ride"] = 401.56, ["Neon|Fly|Ride"] = 227.07, ["Mega"] = 823.7, ["Mega|Ride"] = 1740.17, ["Mega|Fly|Ride"] = 823.79}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6300, ["Fly"] = 10982.67, ["Ride"] = 4987.5, ["Fly|Ride"] = 5049.18, ["Neon|Fly|Ride"] = 10500, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 9.5, ["Fly"] = 47.38, ["Ride"] = 35.35, ["Fly|Ride"] = 92.85, ["Neon"] = 77.75, ["Neon|Ride"] = 78.6, ["Neon|Fly|Ride"] = 155.43, ["Mega"] = 519.61, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 24.76}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 128.58, ["Fly"] = 364.49, ["Ride"] = 183.64, ["Fly|Ride"] = 170.63, ["Neon"] = 485.63, ["Neon|Ride"] = 509.66, ["Neon|Fly|Ride"] = 496.41, ["Mega"] = 2879.59, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 51.19, ["Fly"] = 92.85, ["Ride"] = 92.68, ["Fly|Ride"] = 137.97, ["Neon"] = 232.07, ["Neon|Ride"] = 273, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 2319.63, ["Mega|Ride"] = 2780.26, ["Mega|Fly|Ride"] = 1634.18}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 24.94, ["Fly"] = 70.46, ["Ride"] = 33.23, ["Fly|Ride"] = 69.65, ["Neon"] = 161.44, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 133.88, ["Mega"] = 1016.21, ["Mega|Ride"] = 820.2, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6.07, ["Fly"] = 58.71, ["Ride"] = 27.57, ["Fly|Ride"] = 82.4, ["Neon"] = 32.82, ["Neon|Ride"] = 72.49, ["Neon|Fly|Ride"] = 179.22, ["Mega"] = 157.5, ["Mega|Fly"] = 918.75, ["Mega|Ride"] = 216.76, ["Mega|Fly|Ride"] = 316.36}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 11.82, ["Fly"] = 137.97, ["Ride"] = 27.84, ["Fly|Ride"] = 64.32, ["Neon"] = 82.39, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 160.13, ["Mega"] = 719.1, ["Mega|Ride"] = 492.19, ["Mega|Fly|Ride"] = 535.47}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 19.4, ["Fly"] = 28.88, ["Ride"] = 27.57, ["Fly|Ride"] = 50.73, ["Neon"] = 203.87, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 141.69, ["Mega|Fly|Ride"] = 539.44}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 210}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 23.7, ["Ride"] = 128.63, ["Neon"] = 147.37, ["Neon|Ride"] = 823.7, ["Mega"] = 525, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 782.25}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 244.96, ["Fly"] = 464.13, ["Ride"] = 443.63, ["Fly|Ride"] = 1547.81, ["Neon"] = 1235.52}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 37.47, ["Fly"] = 212.01, ["Ride"] = 91.88, ["Fly|Ride"] = 179.17, ["Neon"] = 219.17, ["Neon|Ride"] = 411.86, ["Neon|Fly|Ride"] = 420, ["Mega"] = 905.62, ["Mega|Ride"] = 2150.85, ["Mega|Fly|Ride"] = 1182.83}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 984.38, ["Fly"] = 1152.97, ["Ride"] = 935.82, ["Fly|Ride"] = 997.5, ["Neon|Fly"] = 4012.95, ["Neon|Ride"] = 3129.97, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 11733.75}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 315, ["Fly"] = 464.21, ["Ride"] = 341.25, ["Fly|Ride"] = 393.75, ["Neon"] = 2834.27, ["Neon|Ride"] = 2059.19, ["Neon|Fly|Ride"] = 1923.29, ["Mega"] = 8133.79, ["Mega|Fly|Ride"] = 6298.69}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 59.61}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 3.67}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 9.49, ["Fly"] = 35.44, ["Ride"] = 23.7, ["Fly|Ride"] = 52.5, ["Neon"] = 77.75, ["Neon|Fly"] = 116, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 166.69, ["Mega"] = 437.26, ["Mega|Ride"] = 686.83, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 275.63, ["Fly"] = 411.86, ["Ride"] = 328.13, ["Fly|Ride"] = 421.98, ["Neon"] = 1085.2, ["Neon|Ride"] = 883.58, ["Neon|Fly|Ride"] = 1050, ["Mega|Ride"] = 3295.13, ["Mega|Fly|Ride"] = 2756.25}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 19.51}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 147.56, ["Ride"] = 219.19, ["Fly|Ride"] = 342.3, ["Neon"] = 674.14, ["Neon|Fly"] = 1717.37, ["Neon|Ride"] = 819.57, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 9884.1, ["Mega|Ride"] = 11714.11, ["Mega|Fly|Ride"] = 2610.97}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 126.66, ["Ride"] = 128.63, ["Fly|Ride"] = 174.06, ["Neon"] = 673.37, ["Neon|Ride"] = 1005.38, ["Neon|Fly|Ride"] = 926.64, ["Mega|Fly|Ride"] = 2417.8}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 6.24, ["Ride"] = 26, ["Fly|Ride"] = 167.84, ["Neon"] = 45.31, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 191.62, ["Mega"] = 264.75, ["Mega|Ride"] = 220.5, ["Mega|Fly|Ride"] = 806.28}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 17.07, ["Fly"] = 63, ["Ride"] = 29.3, ["Fly|Ride"] = 69.63, ["Neon"] = 177.19, ["Neon|Ride"] = 110.18, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 801.13, ["Mega|Fly|Ride"] = 583.87}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 13.13, ["Fly"] = 102.31, ["Ride"] = 44.6, ["Fly|Ride"] = 128.84, ["Neon"] = 68.99, ["Neon|Ride"] = 130.77, ["Neon|Fly|Ride"] = 255.94, ["Mega"] = 462.31, ["Mega|Ride"] = 493.5, ["Mega|Fly|Ride"] = 685.81}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 5.25, ["Fly"] = 78.75, ["Ride"] = 70.86, ["Fly|Ride"] = 137.97, ["Neon"] = 19.4, ["Neon|Fly"] = 199.76, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 155.29, ["Mega"] = 151.1, ["Mega|Fly"] = 307.86, ["Mega|Ride"] = 178.49, ["Mega|Fly|Ride"] = 251.9}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 268.95, ["Ride"] = 262.5, ["Fly|Ride"] = 367.5, ["Neon"] = 1616.48, ["Neon|Ride"] = 1442.82, ["Neon|Fly|Ride"] = 1286.38, ["Mega|Fly|Ride"] = 5217.6}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 146.64, ["Fly"] = 549.82, ["Ride"] = 180.76, ["Fly|Ride"] = 293.84, ["Neon"] = 643.13, ["Neon|Ride"] = 542.07, ["Neon|Fly|Ride"] = 782.25, ["Mega"] = 9884.1, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2821.88}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 68.25, ["Fly"] = 167.45, ["Ride"] = 101.73, ["Fly|Ride"] = 185.67, ["Neon|Ride"] = 472.05, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 1447.8}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 11.82, ["Ride"] = 68.99, ["Fly|Ride"] = 274.93, ["Neon|Ride"] = 589.2, ["Neon|Fly|Ride"] = 480.83, ["Mega|Ride"] = 408.5, ["Mega|Fly|Ride"] = 1647.57}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 13.71, ["Fly"] = 75.63, ["Ride"] = 30.7, ["Fly|Ride"] = 105, ["Neon"] = 77.44, ["Neon|Fly"] = 205.94, ["Neon|Ride"] = 102.55, ["Neon|Fly|Ride"] = 192.57, ["Mega"] = 320.12, ["Mega|Fly"] = 525, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 450.21}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.83, ["Fly"] = 47.38, ["Ride"] = 19.69, ["Fly|Ride"] = 82.39, ["Neon"] = 19.38, ["Neon|Fly"] = 82.39, ["Neon|Ride"] = 41.01, ["Neon|Fly|Ride"] = 130.77, ["Mega"] = 131.24, ["Mega|Ride"] = 147, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 935.01, ["Fly"] = 1082.72, ["Ride"] = 990.42, ["Fly|Ride"] = 1023.75, ["Neon"] = 3039.91, ["Neon|Fly"] = 3402.89, ["Neon|Ride"] = 2852.62, ["Neon|Fly|Ride"] = 2412.38, ["Mega|Fly|Ride"] = 7724.41}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 364.41, ["Ride"] = 522.02, ["Fly|Ride"] = 523.69, ["Neon|Ride"] = 1290.48, ["Neon|Fly|Ride"] = 1922.33, ["Mega"] = 10295.93, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 82.43, ["Fly"] = 105, ["Ride"] = 103.69, ["Fly|Ride"] = 192.54, ["Neon"] = 282.19, ["Neon|Ride"] = 301.46, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 1577.36, ["Mega|Ride"] = 1647.57, ["Mega|Fly|Ride"] = 1576.31}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 262.5, ["Fly"] = 357.29, ["Ride"] = 295.51, ["Fly|Ride"] = 274.32, ["Neon|Ride"] = 1391.79, ["Neon|Fly|Ride"] = 1057.41, ["Mega"] = 10295.93, ["Mega|Fly|Ride"] = 5118.75}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 17.92, ["Fly"] = 137.97, ["Ride"] = 34.82, ["Fly|Ride"] = 70.1, ["Neon"] = 131.25, ["Neon|Ride"] = 102.98, ["Neon|Fly|Ride"] = 229.69, ["Mega|Fly|Ride"] = 619.5}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 220.89, ["Ride"] = 280.74, ["Fly|Ride"] = 546.56, ["Neon"] = 1419.05, ["Neon|Ride"] = 942.38, ["Neon|Fly|Ride"] = 1010.63, ["Mega"] = 4102.55, ["Mega|Ride"] = 4256.88, ["Mega|Fly|Ride"] = 3818.31}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 61.79, ["Fly"] = 76.13, ["Ride"] = 39.38, ["Fly|Ride"] = 130.6, ["Neon|Ride"] = 514.82, ["Neon|Fly|Ride"] = 549.82, ["Mega|Fly|Ride"] = 1207.5}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1717.37, ["Ride"] = 1686.68, ["Fly|Ride"] = 1760.41, ["Neon|Ride"] = 10825.64, ["Neon|Fly|Ride"] = 5216.95, ["Mega"] = 49420.43, ["Mega|Fly|Ride"] = 23340.68}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 13.53, ["Fly"] = 102.98, ["Ride"] = 41.19, ["Fly|Ride"] = 105.15, ["Neon"] = 61.56, ["Neon|Fly"] = 185.22, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 261.53, ["Mega"] = 305.64, ["Mega|Fly"] = 371.16, ["Mega|Ride"] = 321.22, ["Mega|Fly|Ride"] = 351.8}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 48.57, ["Fly"] = 119.1, ["Ride"] = 74.15, ["Fly|Ride"] = 157.5, ["Neon"] = 274.82, ["Neon|Ride"] = 292.53, ["Neon|Fly|Ride"] = 304.5, ["Mega"] = 884.43, ["Mega|Ride"] = 1008.12, ["Mega|Fly|Ride"] = 961.77}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 68.25, ["Fly"] = 91.76, ["Ride"] = 77.44, ["Fly|Ride"] = 109.15, ["Neon|Fly|Ride"] = 392.44, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3430.62, ["Ride"] = 1053.88, ["Fly|Ride"] = 1168.13, ["Neon|Fly|Ride"] = 7413.08, ["Mega|Fly|Ride"] = 20727.58}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 541.96, ["Fly"] = 821.63, ["Ride"] = 673.37, ["Fly|Ride"] = 670.65, ["Neon"] = 2476.02, ["Neon|Fly|Ride"] = 2707.01, ["Mega|Fly|Ride"] = 17016.41}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 84, ["Ride"] = 115.5, ["Fly|Ride"] = 203.44, ["Neon"] = 444.29, ["Neon|Fly"] = 617.76, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 576.59, ["Mega"] = 4118.38, ["Mega|Ride"] = 2602.11, ["Mega|Fly|Ride"] = 2141.84}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.5, ["Ride"] = 19.69, ["Fly|Ride"] = 60.76, ["Neon"] = 72.09, ["Neon|Fly"] = 137.97, ["Neon|Ride"] = 100.01, ["Neon|Fly|Ride"] = 181.22, ["Mega|Ride"] = 747.53, ["Mega|Fly|Ride"] = 1373.66}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 32.82, ["Fly"] = 102.14, ["Ride"] = 48.43, ["Fly|Ride"] = 106.77, ["Neon"] = 199.5, ["Neon|Fly"] = 411.86, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 310.95, ["Mega|Ride"] = 1194.5, ["Mega|Fly|Ride"] = 961.77}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 721.88, ["Ride"] = 711.38, ["Fly|Ride"] = 910.18, ["Neon"] = 3018.79, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2629.29, ["Mega|Fly|Ride"] = 15103.95}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 869.22}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 5903.69, ["Ride"] = 5966.49, ["Fly|Ride"] = 5508.04, ["Neon"] = 42000, ["Neon|Ride"] = 29509.15, ["Neon|Fly|Ride"] = 24024.52, ["Mega|Fly|Ride"] = 87870.13}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 245.34, ["Fly"] = 406.82, ["Ride"] = 294.73, ["Fly|Ride"] = 367.5, ["Neon"] = 1647.37, ["Neon|Fly|Ride"] = 2059.19, ["Mega"] = 6176.55, ["Mega|Fly|Ride"] = 6188}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 72.51, ["Fly"] = 274.93, ["Ride"] = 100.92, ["Fly|Ride"] = 336, ["Neon"] = 409.8, ["Neon|Ride"] = 514.82, ["Neon|Fly|Ride"] = 1647.37, ["Mega|Fly|Ride"] = 2868.81}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 17.07, ["Fly"] = 96.8, ["Ride"] = 26.24, ["Fly|Ride"] = 72.09, ["Neon"] = 120.69, ["Neon|Fly"] = 1237.52, ["Neon|Ride"] = 104.9, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 657.92, ["Mega|Ride"] = 718.76, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 11.82, ["Fly"] = 39.38, ["Ride"] = 26.98, ["Fly|Ride"] = 44.34, ["Neon"] = 205.94, ["Neon|Fly"] = 274.93, ["Neon|Ride"] = 309.68, ["Neon|Fly|Ride"] = 137.97, ["Mega"] = 1312.5, ["Mega|Ride"] = 1587.85, ["Mega|Fly|Ride"] = 2183.03}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 15.45, ["Fly"] = 274.93, ["Ride"] = 34.89, ["Fly|Ride"] = 140.44, ["Neon"] = 154.88, ["Neon|Ride"] = 143.07, ["Neon|Fly|Ride"] = 144.16, ["Mega"] = 549.82, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.94, ["Fly"] = 21, ["Ride"] = 21, ["Fly|Ride"] = 52.5, ["Neon"] = 19.59, ["Neon|Fly"] = 339.77, ["Neon|Ride"] = 49.43, ["Neon|Fly|Ride"] = 185.59, ["Mega"] = 274.93, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 18.38, ["Ride"] = 43.32, ["Fly|Ride"] = 96.8, ["Neon"] = 164.75, ["Neon|Fly"] = 823.7, ["Neon|Ride"] = 222.41, ["Neon|Fly|Ride"] = 329.48, ["Mega"] = 768.09, ["Mega|Ride"] = 659.04, ["Mega|Fly|Ride"] = 961.77}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 360.51, ["Fly"] = 461.81, ["Ride"] = 294, ["Fly|Ride"] = 427.29, ["Neon"] = 1207.5, ["Neon|Fly"] = 1457.92, ["Neon|Ride"] = 1222.14, ["Neon|Fly|Ride"] = 1239, ["Mega"] = 7875, ["Mega|Fly"] = 4529.19, ["Mega|Ride"] = 4530.78, ["Mega|Fly|Ride"] = 4611.1}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.6, ["Fly"] = 15.64, ["Ride"] = 15.52, ["Fly|Ride"] = 45.31, ["Neon"] = 19.69, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 69.36, ["Mega"] = 463.33, ["Mega|Ride"] = 541.78, ["Mega|Fly|Ride"] = 243.77}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 39.75, ["Fly"] = 94.5, ["Ride"] = 84.3, ["Fly|Ride"] = 115.5, ["Neon"] = 190.32, ["Neon|Fly"] = 289.27, ["Neon|Ride"] = 208.59, ["Neon|Fly|Ride"] = 270.5, ["Mega"] = 577.5, ["Mega|Fly"] = 823.7, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 618.42}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 778.29, ["Fly"] = 974.82, ["Ride"] = 768.96, ["Fly|Ride"] = 808.5, ["Neon|Ride"] = 1603.88, ["Neon|Fly|Ride"] = 1443.74, ["Mega|Fly|Ride"] = 3084.38}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 31.5, ["Fly"] = 91.88, ["Ride"] = 44.63, ["Fly|Ride"] = 73.49, ["Neon"] = 205.94, ["Neon|Ride"] = 216.57, ["Neon|Fly|Ride"] = 228.38, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 748.13}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 315, ["Fly"] = 324.84, ["Ride"] = 288.65, ["Fly|Ride"] = 349.13, ["Neon|Fly|Ride"] = 1232.86, ["Mega|Fly|Ride"] = 13921.25}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 150.94, ["Fly"] = 241.4, ["Ride"] = 196.88, ["Fly|Ride"] = 198.38, ["Neon"] = 627.29, ["Neon|Ride"] = 807.19, ["Neon|Fly|Ride"] = 669.25, ["Mega|Fly|Ride"] = 3295.13}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 713.1, ["Ride"] = 682.5, ["Fly|Ride"] = 851.34, ["Neon|Ride"] = 2598.75, ["Neon|Fly|Ride"] = 2882.86, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 22.04, ["Ride"] = 31.94, ["Fly|Ride"] = 109.08, ["Neon"] = 78.08, ["Neon|Fly"] = 278.37, ["Neon|Ride"] = 99.77, ["Neon|Fly|Ride"] = 137.97, ["Mega"] = 350.07, ["Mega|Ride"] = 355, ["Mega|Fly|Ride"] = 513.85}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3176.25, ["Fly"] = 3590.9, ["Ride"] = 3936.19, ["Fly|Ride"] = 3022.98, ["Neon"] = 13728.6, ["Neon|Fly|Ride"] = 5946.91, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 96.8, ["Fly"] = 131.25, ["Ride"] = 137.97, ["Fly|Ride"] = 155.49, ["Neon"] = 547.76, ["Neon|Ride"] = 549.82, ["Neon|Fly|Ride"] = 514.5, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 3.12, ["Fly"] = 20.61, ["Ride"] = 17.07, ["Fly|Ride"] = 45.48, ["Neon"] = 23.63, ["Neon|Fly"] = 63.51, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 144.79, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 159.62, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.41, ["Ride"] = 27.82, ["Fly|Ride"] = 58.03, ["Neon"] = 24.93, ["Neon|Ride"] = 53.55, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 159.99, ["Mega|Ride"] = 199.48, ["Mega|Fly|Ride"] = 264.34}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 41.19, ["Fly"] = 152.39, ["Ride"] = 49.43, ["Fly|Ride"] = 51.97, ["Neon|Ride"] = 377.87, ["Neon|Fly|Ride"] = 303.75, ["Mega|Fly|Ride"] = 1098.72}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 984.38, ["Ride"] = 1385.37, ["Fly|Ride"] = 1233.75, ["Neon"] = 5765.72, ["Neon|Fly|Ride"] = 3937.5}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 5775, ["Ride"] = 7039.35, ["Fly|Ride"] = 6299.99}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 25.83, ["Fly"] = 45.94, ["Ride"] = 24.94, ["Fly|Ride"] = 43.32, ["Neon"] = 549.82, ["Neon|Ride"] = 144.8, ["Neon|Fly|Ride"] = 171.67, ["Mega"] = 2428.13, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 14.43, ["Fly"] = 31.5, ["Ride"] = 32.96, ["Fly|Ride"] = 85.87, ["Neon"] = 65.63, ["Neon|Ride"] = 87.59, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 642.48, ["Mega|Ride"] = 616.03, ["Mega|Fly|Ride"] = 500}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 69.56, ["Fly"] = 157.49, ["Ride"] = 62.92, ["Fly|Ride"] = 116.71, ["Neon"] = 459.38, ["Neon|Ride"] = 433.78, ["Neon|Fly|Ride"] = 305.82, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 210, ["Ride"] = 236.25, ["Fly|Ride"] = 324.61, ["Neon|Ride"] = 977.79, ["Neon|Fly|Ride"] = 1082.82, ["Mega"] = 10295.93, ["Mega|Fly|Ride"] = 3712.34}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 4.92, ["Ride"] = 28.88, ["Fly|Ride"] = 60.35, ["Neon"] = 14.3, ["Neon|Fly"] = 656.24, ["Neon|Ride"] = 68.25, ["Mega"] = 133.77, ["Mega|Ride"] = 164.77, ["Mega|Fly|Ride"] = 298.64}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 182.44, ["Fly"] = 261.53, ["Ride"] = 232.07, ["Fly|Ride"] = 259.88, ["Neon"] = 721.88, ["Neon|Ride"] = 912.78, ["Neon|Fly|Ride"] = 961.65, ["Mega|Fly|Ride"] = 3403.76}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.84, ["Fly"] = 45.31, ["Ride"] = 15.35, ["Fly|Ride"] = 40.6, ["Neon"] = 26.92, ["Neon|Ride"] = 31.96, ["Neon|Fly|Ride"] = 107.09, ["Mega"] = 463.95, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 257.28}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 210, ["Fly"] = 268.82, ["Ride"] = 262.5, ["Fly|Ride"] = 262.5, ["Neon|Fly|Ride"] = 1113.44, ["Mega"] = 10295.93, ["Mega|Ride"] = 4118.89, ["Mega|Fly|Ride"] = 4092.12}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 11.82, ["Fly"] = 36.05, ["Ride"] = 26.78, ["Fly|Ride"] = 52.5, ["Neon"] = 61.42, ["Neon|Fly"] = 294.6, ["Neon|Ride"] = 97.83, ["Neon|Fly|Ride"] = 194.91, ["Mega|Ride"] = 617.86, ["Mega|Fly|Ride"] = 449.5}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Fly"] = 68.99, ["Ride"] = 22.46, ["Fly|Ride"] = 59.07, ["Neon"] = 10.31, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 44.29, ["Neon|Fly|Ride"] = 176.78, ["Mega"] = 75.12, ["Mega|Ride"] = 99.74, ["Mega|Fly|Ride"] = 187.69}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.63, ["Neon"] = 3.84, ["Neon|Ride"] = 41.2, ["Mega"] = 22.98, ["Mega|Ride"] = 137.45}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.84, ["Fly"] = 52.48, ["Ride"] = 26.25, ["Fly|Ride"] = 214.17, ["Neon"] = 6.14, ["Neon|Ride"] = 40.16, ["Neon|Fly|Ride"] = 131.22, ["Mega"] = 68.16, ["Mega|Fly"] = 154641.61, ["Mega|Ride"] = 89.38, ["Mega|Fly|Ride"] = 158.45}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 65.01, ["Fly"] = 139.25, ["Ride"] = 115.5, ["Fly|Ride"] = 186.48, ["Neon"] = 293.18, ["Neon|Ride"] = 374.78, ["Neon|Fly|Ride"] = 340.07, ["Mega|Ride"] = 1318.06, ["Mega|Fly|Ride"] = 1084.13}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 33.67, ["Ride"] = 15.65, ["Fly|Ride"] = 98.3, ["Neon"] = 5.25, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 73.08, ["Mega"] = 129.94, ["Mega|Ride"] = 123.45, ["Mega|Fly|Ride"] = 257.24}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 59.07, ["Ride"] = 31.94, ["Neon"] = 71.92, ["Neon|Ride"] = 210, ["Mega|Ride"] = 541.65}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 45.18, ["Mega"] = 18.38, ["Mega|Ride"] = 55.58, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 41.2, ["Ride"] = 14.6, ["Fly|Ride"] = 33.44, ["Neon"] = 2.1, ["Neon|Fly"] = 14.43, ["Neon|Ride"] = 14.12, ["Neon|Fly|Ride"] = 30.77, ["Mega"] = 13.13, ["Mega|Fly"] = 36.75, ["Mega|Ride"] = 19.38, ["Mega|Fly|Ride"] = 48.18}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 52.53, ["Ride"] = 12.46, ["Fly|Ride"] = 37.3, ["Neon"] = 2.16, ["Neon|Fly"] = 23.22, ["Neon|Ride"] = 15.61, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 28.88, ["Mega|Fly"] = 155.43, ["Mega|Ride"] = 33.49, ["Mega|Fly|Ride"] = 137.45}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 33.67, ["Neon"] = 2.1, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 82.39, ["Mega"] = 16.54, ["Mega|Ride"] = 118.21}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Ride"] = 19.69, ["Fly|Ride"] = 107.63, ["Neon"] = 2.43, ["Neon|Fly"] = 168, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 24.76, ["Mega|Fly"] = 89.59, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.43, ["Neon|Fly|Ride"] = 205.94, ["Mega"] = 19.69, ["Mega|Ride"] = 99.79}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.63, ["Fly"] = 65.63, ["Ride"] = 20.96, ["Fly|Ride"] = 64.32, ["Neon"] = 7.54, ["Neon|Fly"] = 59.07, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 70.21, ["Mega"] = 98.24, ["Mega|Fly"] = 155.3, ["Mega|Ride"] = 87.94, ["Mega|Fly|Ride"] = 165.38}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 47.38, ["Neon"] = 2.1, ["Neon|Ride"] = 78.66, ["Neon|Fly|Ride"] = 157.38, ["Mega"] = 14.33, ["Mega|Ride"] = 28.88, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly|Ride"] = 524.99, ["Neon"] = 15.74, ["Mega"] = 137.97, ["Mega|Fly"] = 315, ["Mega|Ride"] = 343.94, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Neon"] = 11.63, ["Neon|Ride"] = 30.8, ["Mega"] = 105, ["Mega|Ride"] = 102.99, ["Mega|Fly|Ride"] = 537.62}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Neon"] = 3.94, ["Neon|Ride"] = 26.78, ["Neon|Fly|Ride"] = 137.97, ["Mega"] = 20.9, ["Mega|Ride"] = 49.49, ["Mega|Fly|Ride"] = 144.94}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 15.45, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 27.82, ["Neon|Ride"] = 12.92, ["Neon|Fly|Ride"] = 30.82, ["Mega"] = 15.17, ["Mega|Fly"] = 39.25, ["Mega|Ride"] = 17.07, ["Mega|Fly|Ride"] = 51.19}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 218.19, ["Fly|Ride"] = 104.98, ["Neon"] = 33.15, ["Neon|Ride"] = 41.2, ["Mega"] = 261.53, ["Mega|Ride"] = 236.25}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 18.38, ["Neon"] = 4.87, ["Neon|Ride"] = 25.76, ["Neon|Fly|Ride"] = 105, ["Mega"] = 25.86, ["Mega|Fly"] = 78.75, ["Mega|Ride"] = 69.62, ["Mega|Fly|Ride"] = 152.41}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.1, ["Neon"] = 9.9, ["Neon|Fly|Ride"] = 137.97, ["Mega"] = 82.51, ["Mega|Ride"] = 150.5, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.5, ["Fly"] = 262.49, ["Ride"] = 15.75, ["Fly|Ride"] = 43.32, ["Neon"] = 12.9, ["Neon|Fly"] = 102.98, ["Neon|Fly|Ride"] = 105, ["Mega"] = 210, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 166.69}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 15.45, ["Ride"] = 15.45, ["Fly|Ride"] = 26.17, ["Neon"] = 2.1, ["Neon|Fly"] = 13.12, ["Neon|Ride"] = 12.92, ["Neon|Fly|Ride"] = 27.67, ["Mega"] = 15.75, ["Mega|Fly"] = 31.34, ["Mega|Ride"] = 22.15, ["Mega|Fly|Ride"] = 45.36}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 27.46, ["Ride"] = 20.51, ["Fly|Ride"] = 137.97, ["Neon"] = 14.43, ["Neon|Ride"] = 111.36, ["Neon|Fly|Ride"] = 109.1, ["Mega"] = 78.75, ["Mega|Ride"] = 154.04, ["Mega|Fly|Ride"] = 274.95}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 3.74, ["Fly"] = 65.63, ["Ride"] = 21.33, ["Fly|Ride"] = 59.06, ["Neon"] = 54.52, ["Neon|Ride"] = 67.1, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 236.25, ["Mega|Ride"] = 282.72, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 15.45, ["Ride"] = 12.99, ["Fly|Ride"] = 26.25, ["Neon"] = 3.94, ["Neon|Fly"] = 23.62, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 45.04, ["Mega|Ride"] = 37.42, ["Mega|Fly|Ride"] = 98.14}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 5.16, ["Fly"] = 171.95, ["Ride"] = 28.73, ["Neon"] = 5.16, ["Neon|Ride"] = 43.31, ["Neon|Fly|Ride"] = 97.06, ["Mega"] = 68.25, ["Mega|Fly"] = 164.75, ["Mega|Ride"] = 87.94, ["Mega|Fly|Ride"] = 360.42}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 26.78, ["Fly|Ride"] = 52.5, ["Neon"] = 4.66, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 137.97, ["Mega"] = 31.5, ["Mega|Ride"] = 138.01, ["Mega|Fly|Ride"] = 303.78}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.72, ["Neon"] = 2.1, ["Neon|Fly"] = 41.03, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 101.07, ["Mega"] = 18.13, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 135.35}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 96.8, ["Ride"] = 22.57, ["Fly|Ride"] = 41.91, ["Neon"] = 2.63, ["Neon|Fly"] = 55.61, ["Neon|Ride"] = 20.61, ["Neon|Fly|Ride"] = 75.48, ["Mega"] = 77.35, ["Mega|Ride"] = 78.28, ["Mega|Fly|Ride"] = 199.78}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 55.61, ["Fly|Ride"] = 43.32, ["Neon"] = 3.82, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 96.8, ["Mega"] = 38.16, ["Mega|Ride"] = 123.59, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 24.94, ["Ride"] = 17.55, ["Fly|Ride"] = 44.88, ["Neon"] = 3.84, ["Neon|Fly"] = 79.97, ["Neon|Ride"] = 19.84, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 91.88, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 7.88, ["Ride"] = 67.97, ["Neon"] = 36.66, ["Mega"] = 127.28, ["Mega|Fly"] = 380.63, ["Mega|Ride"] = 205.96, ["Mega|Fly|Ride"] = 823.79}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 16.7, ["Fly|Ride"] = 137.97, ["Neon"] = 30.9, ["Neon|Fly"] = 104.25, ["Neon|Ride"] = 25.73, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 236.25, ["Mega|Fly"] = 420, ["Mega|Ride"] = 145.48, ["Mega|Fly|Ride"] = 208.95}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 8.23, ["Fly"] = 22.66, ["Ride"] = 19.59, ["Fly|Ride"] = 39, ["Neon"] = 23.62, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 28.32, ["Neon|Fly|Ride"] = 77.35, ["Mega"] = 270.8, ["Mega|Fly"] = 410.83, ["Mega|Ride"] = 410.82, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 3.3, ["Fly"] = 110.93, ["Fly|Ride"] = 137.7, ["Neon"] = 55.13, ["Mega"] = 177.28, ["Mega|Ride"] = 236.24}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 15.54, ["Ride"] = 131.25, ["Neon"] = 110.15, ["Neon|Ride"] = 231.98, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 3.94, ["Ride"] = 64.89, ["Neon"] = 38.75, ["Neon|Ride"] = 125.71, ["Mega"] = 253.32, ["Mega|Ride"] = 214.19}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 4.76, ["Ride"] = 31.07, ["Fly|Ride"] = 120.75, ["Neon"] = 47.16, ["Neon|Ride"] = 157.5, ["Mega"] = 246.08, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.81, ["Neon|Ride"] = 64.98, ["Mega"] = 21.36, ["Mega|Ride"] = 138.01, ["Mega|Fly|Ride"] = 148.29}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 34.04}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 5.16, ["Fly"] = 22.91, ["Ride"] = 21.95, ["Fly|Ride"] = 40.69, ["Neon"] = 34.04, ["Neon|Ride"] = 46.4, ["Neon|Fly|Ride"] = 100.92, ["Mega"] = 274.93, ["Mega|Fly"] = 329.48, ["Mega|Ride"] = 278.52, ["Mega|Fly|Ride"] = 253.62}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.55, ["Fly|Ride"] = 36.75, ["Neon"] = 2.97, ["Neon|Ride"] = 26.6, ["Neon|Fly|Ride"] = 68.99, ["Mega"] = 24.94, ["Mega|Fly"] = 137.97, ["Mega|Ride"] = 55.61, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 23.7, ["Fly|Ride"] = 274.93, ["Neon"] = 3.84, ["Neon|Ride"] = 35.32, ["Neon|Fly|Ride"] = 404.88, ["Mega"] = 39.15, ["Mega|Ride"] = 71.31, ["Mega|Fly|Ride"] = 133.88}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 48.44, ["Ride"] = 15.67, ["Fly|Ride"] = 55.13, ["Neon"] = 6.43, ["Neon|Ride"] = 50.17, ["Neon|Fly|Ride"] = 117.06, ["Mega"] = 141.75, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.94, ["Ride"] = 39.15, ["Fly|Ride"] = 58.71, ["Neon"] = 35.03, ["Neon|Ride"] = 82.27, ["Neon|Fly|Ride"] = 212.24, ["Mega"] = 328.13, ["Mega|Ride"] = 269.96, ["Mega|Fly|Ride"] = 411.9}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 32.81, ["Neon"] = 3.47, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 14.44, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 16.05, ["Fly|Ride"] = 274558.17, ["Neon"] = 4.73, ["Neon|Fly"] = 68.99, ["Neon|Ride"] = 27.71, ["Neon|Fly|Ride"] = 69.61, ["Mega"] = 35.44, ["Mega|Ride"] = 47.94, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 27.46, ["Ride"] = 14.77, ["Fly|Ride"] = 34.13, ["Neon"] = 8.11, ["Neon|Fly"] = 68.99, ["Neon|Ride"] = 15.64, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 36.75, ["Mega|Fly"] = 137.97, ["Mega|Ride"] = 51.34, ["Mega|Fly|Ride"] = 201.88}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 210, ["Ride"] = 32.16, ["Fly|Ride"] = 147.37, ["Neon"] = 5.22, ["Neon|Ride"] = 33.12, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 23.06, ["Mega|Fly"] = 118.41, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.84, ["Neon|Ride"] = 164.38, ["Neon|Fly|Ride"] = 122.54, ["Mega"] = 18.17, ["Mega|Fly"] = 106.32, ["Mega|Ride"] = 86.63, ["Mega|Fly|Ride"] = 144.75}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 32.44, ["Ride"] = 18.27, ["Fly|Ride"] = 77.23, ["Neon"] = 2.43, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 21.63, ["Neon|Fly|Ride"] = 65, ["Mega"] = 18.38, ["Mega|Fly"] = 61.79, ["Mega|Ride"] = 38.07, ["Mega|Fly|Ride"] = 118.02}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 48.41, ["Neon"] = 2.1, ["Neon|Ride"] = 68.99, ["Mega"] = 39.38, ["Mega|Ride"] = 212.15}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.43, ["Neon|Ride"] = 155.43, ["Neon|Fly|Ride"] = 420, ["Mega"] = 21, ["Mega|Ride"] = 152.41, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 27.82, ["Ride"] = 16.03, ["Fly|Ride"] = 57.67, ["Neon"] = 5.25, ["Neon|Fly"] = 55.61, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 40.61, ["Mega"] = 26.25, ["Mega|Ride"] = 55.12, ["Mega|Fly|Ride"] = 92.34}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 10.5, ["Ride"] = 139.25, ["Neon"] = 91.88, ["Mega"] = 262.5, ["Mega|Ride"] = 426.57, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.63, ["Fly"] = 6562.5, ["Ride"] = 26.25, ["Neon"] = 52.02, ["Neon|Ride"] = 203.87, ["Mega"] = 1568.09, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 410.92, ["Neon"] = 30.8, ["Mega"] = 295.25, ["Mega|Ride"] = 308.94, ["Mega|Fly|Ride"] = 367.4}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 12.55, ["Ride"] = 15.45, ["Fly|Ride"] = 24.24, ["Neon"] = 2.1, ["Neon|Fly"] = 14.59, ["Neon|Ride"] = 12.92, ["Neon|Fly|Ride"] = 28.88, ["Mega"] = 15.18, ["Mega|Fly"] = 22.32, ["Mega|Ride"] = 22.32, ["Mega|Fly|Ride"] = 51.23}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 57.67, ["Fly|Ride"] = 110.18, ["Neon"] = 3.94, ["Neon|Fly"] = 89.87, ["Neon|Ride"] = 31.94, ["Neon|Fly|Ride"] = 686.75, ["Mega"] = 51.19, ["Mega|Ride"] = 117.93}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Fly"] = 68.99, ["Ride"] = 31.49, ["Neon"] = 2.1, ["Neon|Fly"] = 30.78, ["Neon|Ride"] = 20.69, ["Neon|Fly|Ride"] = 54.51, ["Mega"] = 12.92, ["Mega|Fly"] = 83.16, ["Mega|Fly|Ride"] = 103.59}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Ride"] = 91.67, ["Neon"] = 3.68, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 102.98, ["Mega"] = 19.11, ["Mega|Ride"] = 101.96, ["Mega|Fly|Ride"] = 152.41}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 34.42, ["Ride"] = 20.9, ["Fly|Ride"] = 45.93, ["Neon"] = 11.82, ["Neon|Fly"] = 65.6, ["Neon|Ride"] = 35.88, ["Neon|Fly|Ride"] = 92.68, ["Mega"] = 208.85, ["Mega|Ride"] = 204.93, ["Mega|Fly|Ride"] = 343.94}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 157.5, ["Ride"] = 171.95, ["Fly|Ride"] = 823.7, ["Neon"] = 1017.26, ["Neon|Ride"] = 822.94, ["Mega"] = 8236.75, ["Mega|Fly|Ride"] = 3419.71}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 15.45, ["Neon|Ride"] = 82.11, ["Mega"] = 68.94, ["Mega|Ride"] = 109.07, ["Mega|Fly|Ride"] = 823.79}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 6.56, ["Fly"] = 63.03, ["Ride"] = 25.57, ["Neon"] = 30.01, ["Neon|Ride"] = 92.8, ["Neon|Fly|Ride"] = 164.75, ["Mega"] = 350.83, ["Mega|Ride"] = 513.85, ["Mega|Fly|Ride"] = 402.56}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 27.82, ["Ride"] = 15.45, ["Fly|Ride"] = 32.13, ["Neon"] = 4.6, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 29.76, ["Neon|Fly|Ride"] = 55.61, ["Mega"] = 49.67, ["Mega|Ride"] = 79.75, ["Mega|Fly|Ride"] = 138.01}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 19.68, ["Fly|Ride"] = 92.56, ["Neon"] = 6.02, ["Neon|Fly"] = 549.82, ["Neon|Ride"] = 93.71, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 96.8, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.84, ["Fly"] = 17.99, ["Ride"] = 17.42, ["Fly|Ride"] = 35.44, ["Neon"] = 24.86, ["Neon|Fly"] = 98.85, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 73.29, ["Mega|Ride"] = 261.57, ["Mega|Fly|Ride"] = 411.9}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 7.77, ["Fly"] = 41.2, ["Ride"] = 34.12, ["Fly|Ride"] = 249.58, ["Neon"] = 49.88, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 611.6, ["Mega"] = 337.03, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 19.64, ["Ride"] = 14.75, ["Fly|Ride"] = 43.26, ["Neon"] = 15.54, ["Neon|Fly"] = 68.76, ["Neon|Ride"] = 53.55, ["Neon|Fly|Ride"] = 66.94, ["Mega|Ride"] = 233.76, ["Mega|Fly|Ride"] = 218.22}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 68.86, ["Fly"] = 168.87, ["Ride"] = 101.95, ["Fly|Ride"] = 152.38, ["Neon"] = 346.32, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 405.57, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1647.57}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 205.7, ["Fly"] = 329.48, ["Ride"] = 203.87, ["Fly|Ride"] = 276.82, ["Neon|Ride"] = 961.65, ["Neon|Fly|Ride"] = 1232.97, ["Mega"] = 10295.93, ["Mega|Fly|Ride"] = 3981.95}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 52.41, ["Fly"] = 100.98, ["Ride"] = 77.44, ["Fly|Ride"] = 119.55, ["Neon"] = 685.13, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 360.29, ["Mega|Ride"] = 1234.66, ["Mega|Fly|Ride"] = 1053.25}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 7.62, ["Fly"] = 96.8, ["Ride"] = 27.82, ["Fly|Ride"] = 96.8, ["Neon"] = 22.09, ["Neon|Ride"] = 69.18, ["Neon|Fly|Ride"] = 196.77, ["Mega"] = 157.5, ["Mega|Ride"] = 375.38, ["Mega|Fly|Ride"] = 262.65}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 10.29, ["Fly"] = 68.99, ["Ride"] = 36.75, ["Fly|Ride"] = 89.25, ["Neon"] = 72.09, ["Neon|Ride"] = 151.66, ["Neon|Fly|Ride"] = 274.93, ["Mega"] = 351.75, ["Mega|Ride"] = 364.53, ["Mega|Fly|Ride"] = 549.88}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 18.38, ["Fly|Ride"] = 44.51, ["Neon"] = 5.24, ["Neon|Fly"] = 74.59, ["Neon|Ride"] = 21.95, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 114.6, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 107.1, ["Mega|Fly|Ride"] = 455.64}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.56, ["Fly"] = 27.82, ["Ride"] = 27.82, ["Fly|Ride"] = 293.86, ["Neon"] = 89.31, ["Neon|Fly"] = 343.89, ["Neon|Ride"] = 158.82, ["Neon|Fly|Ride"] = 134.92, ["Mega"] = 1837.5, ["Mega|Ride"] = 616.88, ["Mega|Fly|Ride"] = 864.94}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.2, ["Ride"] = 17.3, ["Fly|Ride"] = 53.4, ["Neon"] = 15.63, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 31.44, ["Neon|Fly|Ride"] = 96.57, ["Mega"] = 187.69, ["Mega|Fly"] = 87, ["Mega|Ride"] = 200.79, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 6.57, ["Ride"] = 26.6, ["Fly|Ride"] = 328.13, ["Neon"] = 27.57, ["Neon|Ride"] = 55.61, ["Mega|Ride"] = 232.03, ["Mega|Fly|Ride"] = 421.87}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 15.45, ["Ride"] = 36.05, ["Neon"] = 2.1, ["Neon|Ride"] = 19.65, ["Neon|Fly|Ride"] = 47.38, ["Mega"] = 14.44, ["Mega|Fly"] = 41.2, ["Mega|Ride"] = 41.21, ["Mega|Fly|Ride"] = 208818.59}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 17.57, ["Ride"] = 18.05, ["Fly|Ride"] = 39.38, ["Neon"] = 12.18, ["Neon|Fly"] = 102.98, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 97.83, ["Mega"] = 84, ["Mega|Ride"] = 96.84, ["Mega|Fly|Ride"] = 206.73}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 3.84, ["Fly"] = 24.93, ["Ride"] = 18.52, ["Fly|Ride"] = 45.94, ["Neon"] = 27.82, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 119.44, ["Mega"] = 283.5, ["Mega|Ride"] = 192.57, ["Mega|Fly|Ride"] = 221.6}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 156.19, ["Fly"] = 247.11, ["Ride"] = 190.32, ["Fly|Ride"] = 266.67, ["Neon"] = 823.7, ["Neon|Ride"] = 594.8, ["Neon|Fly|Ride"] = 723.13, ["Mega|Fly|Ride"] = 3295.13}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 12.46, ["Ride"] = 30.9, ["Fly|Ride"] = 205.94, ["Neon"] = 43.32, ["Neon|Ride"] = 160.13, ["Neon|Fly|Ride"] = 376.56, ["Mega"] = 340.81, ["Mega|Ride"] = 353.07, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 24.73, ["Fly|Ride"] = 43.32, ["Neon"] = 22.05, ["Neon|Ride"] = 54.51, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 308.44, ["Mega|Ride"] = 244.83, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 19.59, ["Ride"] = 41.32, ["Fly|Ride"] = 170.63, ["Neon"] = 89.59, ["Neon|Ride"] = 80.07, ["Neon|Fly|Ride"] = 464.03, ["Mega"] = 457.72, ["Mega|Fly"] = 823.7, ["Mega|Ride"] = 469.88, ["Mega|Fly|Ride"] = 685.81}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 5.1}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 4.66, ["Ride"] = 28.49, ["Neon"] = 24.61, ["Neon|Ride"] = 274.93, ["Neon|Fly|Ride"] = 617.76, ["Mega"] = 386.11, ["Mega|Ride"] = 304.5, ["Mega|Fly|Ride"] = 821.73}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 25.45, ["Fly"] = 53.55, ["Ride"] = 35.44, ["Fly|Ride"] = 55.61, ["Neon"] = 179.17, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 159.38, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 1785.32, ["Mega|Fly|Ride"] = 1785.55}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 20.56, ["Fly|Ride"] = 78.75, ["Neon"] = 6.09, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 106.25, ["Mega"] = 33.9, ["Mega|Fly"] = 274.93, ["Mega|Ride"] = 81.36, ["Mega|Fly|Ride"] = 225.16}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 4.66, ["Fly"] = 27.81, ["Ride"] = 23.7, ["Fly|Ride"] = 61.79, ["Neon"] = 45.45, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 231.98, ["Mega"] = 231.48, ["Mega|Fly"] = 387.39, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 303.78}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 15.75, ["Fly|Ride"] = 45.65, ["Neon"] = 11.82, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 31.41, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 144.38, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 32.63, ["Fly|Ride"] = 205.94, ["Neon"] = 4.34, ["Neon|Ride"] = 22.43, ["Neon|Fly|Ride"] = 411.86, ["Mega"] = 22.05, ["Mega|Ride"] = 81.36, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 31.5, ["Ride"] = 82.39, ["Neon"] = 253.3, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 581.63, ["Mega"] = 791.99, ["Mega|Ride"] = 961.77, ["Mega|Fly|Ride"] = 833.44}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.03, ["Ride"] = 53.4, ["Fly|Ride"] = 210, ["Neon"] = 80.29, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 464.05}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 6.19, ["Fly"] = 96.8, ["Ride"] = 24.73, ["Fly|Ride"] = 82.39, ["Neon"] = 55.13, ["Neon|Fly"] = 315, ["Neon|Ride"] = 68.99, ["Neon|Fly|Ride"] = 100.87, ["Mega"] = 174.83, ["Mega|Fly|Ride"] = 335.35}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 72.19, ["Fly"] = 433.12, ["Ride"] = 179.17, ["Fly|Ride"] = 262.44, ["Neon"] = 549.82, ["Neon|Ride"] = 411.86, ["Mega|Ride"] = 2034.38, ["Mega|Fly|Ride"] = 1836.19}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 6.57, ["Fly"] = 45.94, ["Ride"] = 29.65, ["Fly|Ride"] = 55.61, ["Neon"] = 48.56, ["Neon|Ride"] = 70.03, ["Neon|Fly|Ride"] = 129.74, ["Mega"] = 263.75, ["Mega|Ride"] = 261.19, ["Mega|Fly|Ride"] = 274.95}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 51.19, ["Fly"] = 145.69, ["Ride"] = 94.85, ["Fly|Ride"] = 185.34, ["Neon"] = 190.32, ["Neon|Fly"] = 525, ["Neon|Ride"] = 223.12, ["Neon|Fly|Ride"] = 409.5, ["Mega"] = 1069.76, ["Mega|Ride"] = 1081.22, ["Mega|Fly|Ride"] = 914.51}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 24.94, ["Ride"] = 56.03, ["Fly|Ride"] = 131.25, ["Neon"] = 94.07, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 239.63, ["Mega"] = 471.57, ["Mega|Ride"] = 305.69, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 3.92, ["Ride"] = 27.57, ["Fly|Ride"] = 48.29, ["Neon"] = 123.2, ["Neon|Ride"] = 77.56, ["Neon|Fly|Ride"] = 248.21, ["Mega"] = 416.96, ["Mega|Ride"] = 1029.73, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 14.44, ["Ride"] = 109.15, ["Fly|Ride"] = 156.33, ["Neon"] = 84.86, ["Neon|Ride"] = 110.69, ["Neon|Fly|Ride"] = 195.57, ["Mega"] = 255.21, ["Mega|Ride"] = 307.2, ["Mega|Fly|Ride"] = 491.54}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 8.69, ["Ride"] = 31.35, ["Neon"] = 41.2, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 155.43, ["Mega"] = 303.89, ["Mega|Ride"] = 314.85, ["Mega|Fly|Ride"] = 332.07}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 55.61, ["Neon|Ride"] = 57.1, ["Neon|Fly|Ride"] = 89.59, ["Mega"] = 18.38, ["Mega|Ride"] = 102.99, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 4.14, ["Ride"] = 27.65, ["Neon"] = 19.38, ["Neon|Fly"] = 123.56, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 95.71, ["Mega|Ride"] = 164.77, ["Mega|Fly|Ride"] = 398.52}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.62, ["Neon"] = 22.44, ["Mega"] = 196.23, ["Mega|Ride"] = 138.01, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 5.94, ["Ride"] = 32.79, ["Fly|Ride"] = 116.04, ["Neon"] = 18.55, ["Neon|Ride"] = 81.36, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 199.76, ["Mega|Ride"] = 199.78, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 564.37, ["Ride"] = 494.71, ["Fly|Ride"] = 614.25, ["Neon"] = 1785.32, ["Neon|Ride"] = 1614.38, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 5.82, ["Fly"] = 27.82, ["Ride"] = 23.7, ["Fly|Ride"] = 62.67, ["Neon"] = 32.96, ["Neon|Ride"] = 94.74, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 155.43, ["Mega|Ride"] = 356.16, ["Mega|Fly|Ride"] = 482.63}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 6.57, ["Fly"] = 77.75, ["Ride"] = 23.7, ["Fly|Ride"] = 51.35, ["Neon"] = 55.61, ["Neon|Fly"] = 315, ["Neon|Ride"] = 39.15, ["Neon|Fly|Ride"] = 137.97, ["Mega"] = 303.75, ["Mega|Ride"] = 343.94, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 3.7, ["Fly"] = 96.8, ["Ride"] = 16.44, ["Fly|Ride"] = 61.69, ["Neon"] = 15.45, ["Neon|Ride"] = 196.88, ["Mega"] = 249.38, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 24.35, ["Fly|Ride"] = 78.75, ["Neon"] = 7.88, ["Neon|Ride"] = 31.29, ["Neon|Fly|Ride"] = 115.4, ["Mega"] = 59.07, ["Mega|Fly"] = 170.63, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 152.15}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 68.99, ["Ride"] = 19.69, ["Neon"] = 3.56, ["Neon|Ride"] = 24.05, ["Neon|Fly|Ride"] = 64.97, ["Mega"] = 27.82, ["Mega|Fly"] = 192.54, ["Mega|Ride"] = 138.01, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1107.75}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 11.5, ["Ride"] = 33.67, ["Fly|Ride"] = 323.64, ["Neon"] = 52.5, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 192.54, ["Mega"] = 398.47, ["Mega|Ride"] = 366.6, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 23.76, ["Neon"] = 6.57, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 982.1, ["Mega"] = 40.74, ["Mega|Ride"] = 154.47, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 58.95, ["Fly|Ride"] = 99.75, ["Neon"] = 11.24, ["Neon|Fly"] = 123.56, ["Neon|Ride"] = 137.97, ["Neon|Fly|Ride"] = 686.75, ["Mega"] = 183.73, ["Mega|Ride"] = 270.38, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 465.94, ["Ride"] = 431.44, ["Fly|Ride"] = 556.07, ["Neon|Ride"] = 1441.43, ["Neon|Fly|Ride"] = 1347.76, ["Mega|Fly|Ride"] = 8006.25}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 9.09, ["Fly"] = 196.88, ["Ride"] = 59.07, ["Fly|Ride"] = 411.86, ["Neon"] = 45.27, ["Neon|Ride"] = 70.65, ["Neon|Fly|Ride"] = 186.63, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 549.88}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 74.84, ["Fly|Ride"] = 160.63, ["Neon"] = 7.28, ["Neon|Ride"] = 30.97, ["Neon|Fly|Ride"] = 145.69, ["Mega"] = 43.32, ["Mega|Fly"] = 189, ["Mega|Ride"] = 88.55, ["Mega|Fly|Ride"] = 255.39}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 111.06, ["Neon|Fly|Ride"] = 274.93, ["Mega"] = 27.46, ["Mega|Ride"] = 114.82, ["Mega|Fly|Ride"] = 162.09}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 14.05, ["Fly"] = 107.63, ["Ride"] = 68.83, ["Fly|Ride"] = 85.87, ["Neon"] = 102.77, ["Neon|Ride"] = 56.72, ["Neon|Fly|Ride"] = 343.89, ["Mega"] = 448.86, ["Mega|Ride"] = 401.61, ["Mega|Fly|Ride"] = 584.01}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 19.69, ["Neon"] = 92.85, ["Neon|Ride"] = 123.56, ["Neon|Fly|Ride"] = 141.65, ["Mega"] = 422.15, ["Mega|Ride"] = 479.73, ["Mega|Fly|Ride"] = 1260}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 4.54, ["Ride"] = 39.47, ["Fly|Ride"] = 410.83, ["Neon"] = 309.81, ["Neon|Ride"] = 155.43, ["Mega"] = 634.43, ["Mega|Ride"] = 686.83, ["Mega|Fly|Ride"] = 1237.84}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 13.55, ["Ride"] = 22.67, ["Neon"] = 274.93, ["Neon|Ride"] = 177.51, ["Neon|Fly|Ride"] = 274.93, ["Mega"] = 549.82, ["Mega|Ride"] = 617.86, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 321.57, ["Fly"] = 464.13, ["Ride"] = 432.44, ["Fly|Ride"] = 617.48, ["Neon"] = 2882.86, ["Neon|Ride"] = 1128.75, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3871.76}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 3.68, ["Fly"] = 69.65, ["Ride"] = 27.65, ["Fly|Ride"] = 131.25, ["Neon"] = 107.08, ["Neon|Fly"] = 185.07, ["Neon|Ride"] = 164.06, ["Neon|Fly|Ride"] = 172.94, ["Mega|Ride"] = 343.94, ["Mega|Fly|Ride"] = 850.56}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.93, ["Ride"] = 69.98, ["Neon"] = 27.82, ["Neon|Ride"] = 221.82, ["Mega"] = 131.25, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 787.49}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 18.96, ["Ride"] = 69.57, ["Fly|Ride"] = 256.44, ["Neon"] = 69.46, ["Neon|Ride"] = 129.93, ["Neon|Fly|Ride"] = 288.3, ["Mega"] = 236.15, ["Mega|Fly"] = 686.75, ["Mega|Ride"] = 275.62, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.5, ["Ride"] = 42, ["Fly|Ride"] = 137.97, ["Neon"] = 6.45, ["Neon|Ride"] = 41.2, ["Neon|Fly|Ride"] = 204.91, ["Mega"] = 44.62, ["Mega|Fly"] = 105, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 38.75, ["Ride"] = 91.88, ["Neon"] = 205.94, ["Neon|Ride"] = 261.53, ["Neon|Fly|Ride"] = 657.63, ["Mega"] = 1373.49, ["Mega|Ride"] = 1345.86, ["Mega|Fly|Ride"] = 984.37}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 56.44, ["Ride"] = 27.43, ["Neon"] = 8.17, ["Neon|Fly"] = 179.17, ["Neon|Ride"] = 63.66, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 62.82, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 35.84, ["Ride"] = 30.19, ["Fly|Ride"] = 149.76, ["Neon"] = 6.33, ["Neon|Fly"] = 49.39, ["Neon|Ride"] = 38.05, ["Neon|Fly|Ride"] = 77.73, ["Mega"] = 39.19, ["Mega|Fly"] = 112.88, ["Mega|Ride"] = 72.87, ["Mega|Fly|Ride"] = 170.36}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 31.35, ["Fly|Ride"] = 123, ["Neon"] = 12.5, ["Neon|Ride"] = 55.42, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 77.42, ["Mega|Fly"] = 459.38, ["Mega|Ride"] = 108.94, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 50.23, ["Fly"] = 92.85, ["Ride"] = 78.74, ["Fly|Ride"] = 193.78, ["Neon"] = 291.38, ["Neon|Ride"] = 282.76, ["Neon|Fly|Ride"] = 412.56, ["Mega|Ride"] = 1029.73, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 271.69, ["Ride"] = 284.82, ["Fly|Ride"] = 413.44, ["Neon"] = 1431.15, ["Neon|Ride"] = 1127.75, ["Neon|Fly|Ride"] = 1039.5, ["Mega"] = 6177.56, ["Mega|Fly|Ride"] = 4950.18}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 6.25, ["Ride"] = 68.99, ["Neon"] = 28.84, ["Mega"] = 96.72, ["Mega|Ride"] = 181.28, ["Mega|Fly|Ride"] = 580.78}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.63, ["Fly"] = 68.99, ["Ride"] = 28.56, ["Fly|Ride"] = 155.49, ["Neon"] = 14.7, ["Neon|Ride"] = 43.12, ["Neon|Fly|Ride"] = 137.97, ["Mega"] = 60.38, ["Mega|Fly"] = 210, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 343.94}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 6.21, ["Fly"] = 30.18, ["Ride"] = 27.56, ["Neon"] = 36.75, ["Mega"] = 373.42, ["Mega|Ride"] = 341.29, ["Mega|Fly|Ride"] = 343.94}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 59.52, ["Ride"] = 35.06, ["Neon"] = 7.77, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 137.45, ["Mega"] = 85.22, ["Mega|Fly"] = 146.22, ["Mega|Ride"] = 111.22, ["Mega|Fly|Ride"] = 236.24}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.24, ["Ride"] = 67.93, ["Neon"] = 9.31, ["Mega"] = 37.46, ["Mega|Ride"] = 205.96, ["Mega|Fly|Ride"] = 171.98}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 16.71, ["Fly|Ride"] = 42, ["Neon"] = 5.25, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 97.83, ["Mega"] = 44.63, ["Mega|Ride"] = 99.79, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 137.97, ["Ride"] = 24.73, ["Fly|Ride"] = 55.61, ["Neon"] = 10.02, ["Neon|Fly"] = 63.03, ["Neon|Ride"] = 39.44, ["Neon|Fly|Ride"] = 85.31, ["Mega"] = 92.8, ["Mega|Ride"] = 232.73, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 43.32, ["Ride"] = 42.62, ["Fly|Ride"] = 77.16, ["Neon"] = 192.13, ["Neon|Ride"] = 212.1, ["Mega"] = 575.55, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 62.99, ["Fly"] = 582.75, ["Ride"] = 83.93, ["Fly|Ride"] = 110.57, ["Neon"] = 411.86, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 452.82, ["Mega"] = 1470, ["Mega|Ride"] = 3254.99, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 17.85, ["Fly|Ride"] = 131.25, ["Neon"] = 5.66, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 137.97, ["Mega"] = 39.44, ["Mega|Fly"] = 672, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 15.45, ["Ride"] = 15.74, ["Fly|Ride"] = 39.37, ["Neon"] = 4.66, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 20.61, ["Neon|Fly|Ride"] = 55.61, ["Mega"] = 61.01, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 89.6, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 5.55, ["Fly"] = 35.02, ["Ride"] = 73.48, ["Fly|Ride"] = 131.25, ["Neon|Ride"] = 62.65, ["Neon|Fly|Ride"] = 273.89, ["Mega"] = 527.63, ["Mega|Ride"] = 425.77, ["Mega|Fly|Ride"] = 636.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.75, ["Fly"] = 413.44, ["Ride"] = 576.59, ["Fly|Ride"] = 492.19, ["Neon"] = 4118.38, ["Neon|Ride"] = 1785.32, ["Mega|Fly|Ride"] = 7208.04}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 30.19, ["Fly"] = 95.81, ["Ride"] = 43.32, ["Fly|Ride"] = 109.15, ["Neon"] = 152.39, ["Neon|Ride"] = 137.97, ["Neon|Fly|Ride"] = 305.79, ["Mega|Ride"] = 926.77, ["Mega|Fly|Ride"] = 984.37}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 36.05, ["Fly|Ride"] = 281.29, ["Neon"] = 7.73, ["Neon|Ride"] = 42.58, ["Neon|Fly|Ride"] = 158.58, ["Mega"] = 80.32, ["Mega|Ride"] = 133.88, ["Mega|Fly|Ride"] = 272.99}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.26, ["Fly"] = 205.82, ["Ride"] = 65.61, ["Fly|Ride"] = 142.7, ["Neon"] = 17.2, ["Mega|Ride"] = 274.95}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 19.69, ["Fly"] = 76.2, ["Ride"] = 43.29, ["Fly|Ride"] = 82.69, ["Neon|Ride"] = 297.94, ["Neon|Fly|Ride"] = 364.49, ["Mega"] = 2471.03, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1291.28}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 75.74, ["Fly"] = 117.39, ["Ride"] = 98.44, ["Fly|Ride"] = 152.39, ["Neon"] = 430.1, ["Neon|Ride"] = 471.57, ["Neon|Fly|Ride"] = 475.7, ["Mega"] = 8236.75, ["Mega|Fly|Ride"] = 1876.17}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 265.64, ["Ride"] = 284.62, ["Fly|Ride"] = 513.78, ["Neon"] = 712.69, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1256.73, ["Mega"] = 4373.72, ["Mega|Fly|Ride"] = 4254.81}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 13.21, ["Fly"] = 51.19, ["Ride"] = 55.67, ["Fly|Ride"] = 150.94, ["Neon"] = 65.63, ["Neon|Ride"] = 108.55, ["Neon|Fly|Ride"] = 185.59, ["Mega|Ride"] = 349.13, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 17.66, ["Ride"] = 18.27, ["Fly|Ride"] = 41.9, ["Neon"] = 8.97, ["Neon|Ride"] = 19.92, ["Neon|Fly|Ride"] = 91.11, ["Mega"] = 85.84, ["Mega|Ride"] = 81.04, ["Mega|Fly|Ride"] = 165.27}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 3.5, ["Fly"] = 34.13, ["Ride"] = 20.46, ["Fly|Ride"] = 42, ["Neon"] = 31, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 122.96, ["Mega"] = 376.85, ["Mega|Ride"] = 313.05, ["Mega|Fly|Ride"] = 327.47}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 303.75, ["Fly"] = 480.83, ["Ride"] = 367.5, ["Fly|Ride"] = 411.86, ["Neon"] = 2048.91, ["Neon|Ride"] = 2150.35, ["Neon|Fly|Ride"] = 1781.07, ["Mega|Fly|Ride"] = 4503.5}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 60.76, ["Neon"] = 10.5, ["Neon|Ride"] = 59.73, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 47.04, ["Mega|Ride"] = 253.33}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 5.07, ["Ride"] = 18.38, ["Fly|Ride"] = 45.85, ["Neon"] = 27.67, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 155.43, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 192.31, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 15.73, ["Ride"] = 116.22, ["Neon"] = 111.57, ["Neon|Fly"] = 411.86, ["Neon|Ride"] = 236.23, ["Neon|Fly|Ride"] = 433.78, ["Mega"] = 466.62, ["Mega|Ride"] = 549.88, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 110.25, ["Fly"] = 210.06, ["Ride"] = 110.25, ["Fly|Ride"] = 164.75, ["Neon|Ride"] = 561.75, ["Neon|Fly|Ride"] = 549.76, ["Mega|Fly|Ride"] = 2378.25}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 18.09, ["Fly"] = 43.26, ["Ride"] = 27.45, ["Fly|Ride"] = 55.6, ["Neon"] = 85.32, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 205.94, ["Mega"] = 632.19, ["Mega|Ride"] = 507.66, ["Mega|Fly|Ride"] = 526.32}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 25.54, ["Neon"] = 2.63, ["Neon|Fly|Ride"] = 686.75, ["Mega"] = 22.32, ["Mega|Ride"] = 273.92, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.26, ["Ride"] = 17.42, ["Fly|Ride"] = 72.19, ["Neon"] = 2.1, ["Neon|Ride"] = 20.61, ["Neon|Fly|Ride"] = 69.78, ["Mega"] = 27.57, ["Mega|Fly"] = 67.79, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 97.52}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 10.5, ["Fly"] = 411.86, ["Ride"] = 76.13, ["Fly|Ride"] = 152.39, ["Neon"] = 26.25, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 80.22, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 151.55, ["Mega|Ride"] = 188.98, ["Mega|Fly|Ride"] = 350.23}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1314.63, ["Fly"] = 1531.87, ["Ride"] = 1207.5, ["Fly|Ride"] = 1157.63, ["Neon"] = 4200, ["Neon|Ride"] = 3609.38, ["Neon|Fly|Ride"] = 3609.38, ["Mega|Fly|Ride"] = 11517.19}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 486.93, ["Fly"] = 617.76, ["Ride"] = 510.9, ["Fly|Ride"] = 560.59, ["Neon"] = 1785.32, ["Neon|Ride"] = 1916.25, ["Neon|Fly|Ride"] = 2045.81, ["Mega"] = 16473.49, ["Mega|Fly|Ride"] = 6956.25}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 328.13, ["Fly"] = 413.91, ["Ride"] = 367.5, ["Fly|Ride"] = 452.82, ["Neon"] = 654.78, ["Neon|Fly"] = 1237.52, ["Neon|Ride"] = 753.12, ["Neon|Fly|Ride"] = 786.19, ["Mega|Fly|Ride"] = 2915.64}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 287.27, ["Fly"] = 411.86, ["Ride"] = 366.11, ["Fly|Ride"] = 398.47, ["Neon"] = 1000.13, ["Neon|Fly"] = 1083.27, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1638, ["Mega|Fly|Ride"] = 4530.78}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 57.74, ["Ride"] = 18.17, ["Fly|Ride"] = 38.06, ["Neon"] = 4.55, ["Neon|Ride"] = 48.47, ["Neon|Fly|Ride"] = 105, ["Mega"] = 64.44, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 392.22, ["Fly"] = 1373.49, ["Ride"] = 414.66, ["Fly|Ride"] = 547.32, ["Neon"] = 1680, ["Neon|Ride"] = 1509.38, ["Neon|Fly|Ride"] = 1378.13, ["Mega|Ride"] = 6590.21, ["Mega|Fly|Ride"] = 4462.5}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 3.76, ["Fly"] = 157.5, ["Ride"] = 18.38, ["Neon"] = 10.4, ["Neon|Ride"] = 65.91, ["Neon|Fly|Ride"] = 205.94, ["Mega"] = 81.1, ["Mega|Ride"] = 181.55, ["Mega|Fly|Ride"] = 357.33}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 19.03, ["Ride"] = 18.55, ["Fly|Ride"] = 38.98, ["Neon"] = 7.77, ["Neon|Ride"] = 52.53, ["Neon|Fly|Ride"] = 108.21, ["Mega"] = 104.9, ["Mega|Ride"] = 192.93}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Neon"] = 2.52, ["Neon|Ride"] = 39.37, ["Mega"] = 23.63, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 65.37, ["Ride"] = 109.15, ["Fly|Ride"] = 459.38, ["Neon"] = 192.54, ["Neon|Ride"] = 351.29, ["Mega|Ride"] = 928.09, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 7737, ["Ride"] = 21.86, ["Fly|Ride"] = 61.06, ["Neon"] = 26.64, ["Neon|Ride"] = 77.73, ["Mega"] = 411.86, ["Mega|Ride"] = 308.94, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 3.83, ["Neon|Fly"] = 118.1, ["Neon|Ride"] = 37.22, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 19.69, ["Mega|Fly"] = 102.98, ["Mega|Ride"] = 90.19, ["Mega|Fly|Ride"] = 121.52}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 35.44, ["Ride"] = 20.61, ["Fly|Ride"] = 66.89, ["Neon"] = 11.24, ["Neon|Fly"] = 96.8, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 97.83, ["Mega|Fly"] = 171.95, ["Mega|Ride"] = 117.76, ["Mega|Fly|Ride"] = 152.25}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.49, ["Fly"] = 91.88, ["Ride"] = 27.87, ["Fly|Ride"] = 51.45, ["Neon"] = 19.69, ["Neon|Fly"] = 110.18, ["Neon|Ride"] = 82.39, ["Neon|Fly|Ride"] = 246.08, ["Mega"] = 237.57, ["Mega|Ride"] = 300.51, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 10.28, ["Fly"] = 190.32, ["Ride"] = 60.76, ["Neon"] = 49.45, ["Neon|Fly|Ride"] = 263.29, ["Mega"] = 343.89, ["Mega|Ride"] = 413.44, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 4.6, ["Fly"] = 6188.87, ["Ride"] = 26.62, ["Neon"] = 36.02, ["Neon|Ride"] = 137.45, ["Neon|Fly|Ride"] = 274.93, ["Mega|Ride"] = 714, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 88.98, ["Ride"] = 18.16, ["Fly|Ride"] = 45.94, ["Neon"] = 4.66, ["Neon|Fly"] = 82.48, ["Neon|Ride"] = 23.73, ["Mega"] = 41.99, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 142.73, ["Fly"] = 227.55, ["Ride"] = 225.5, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 958.57, ["Neon|Fly|Ride"] = 1083.27, ["Mega"] = 8236.75, ["Mega|Fly|Ride"] = 4109.59}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 15.23, ["Ride"] = 15.45, ["Fly|Ride"] = 34.44, ["Neon"] = 3.84, ["Neon|Fly"] = 27.71, ["Neon|Ride"] = 24.72, ["Neon|Fly|Ride"] = 45.85, ["Mega"] = 39.37, ["Mega|Ride"] = 81.36, ["Mega|Fly|Ride"] = 122.75}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 5.24, ["Fly"] = 137.97, ["Ride"] = 69.46, ["Fly|Ride"] = 183.73, ["Neon"] = 102.8, ["Neon|Ride"] = 123.21, ["Mega"] = 360.94, ["Mega|Ride"] = 287.85, ["Mega|Fly|Ride"] = 549.88}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 33.17, ["Ride"] = 93.19, ["Fly|Ride"] = 168.92, ["Neon"] = 155.56, ["Neon|Ride"] = 274.93, ["Mega"] = 786.19, ["Mega|Ride"] = 812.09, ["Mega|Fly|Ride"] = 1027.68}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 181.11, ["Fly"] = 294.73, ["Ride"] = 216.57, ["Fly|Ride"] = 326.82, ["Neon"] = 708.74, ["Neon|Fly"] = 1159.82, ["Neon|Fly|Ride"] = 842.63, ["Mega|Ride"] = 3293.06, ["Mega|Fly|Ride"] = 3377.5}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 15.53, ["Fly"] = 168.88, ["Ride"] = 37.8, ["Fly|Ride"] = 139.25, ["Neon"] = 124.17, ["Neon|Ride"] = 145.34, ["Mega"] = 287.44, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1235.68}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 12.48, ["Ride"] = 44.63, ["Fly|Ride"] = 525, ["Neon"] = 96.8, ["Neon|Fly"] = 155.43, ["Neon|Ride"] = 199.5, ["Mega"] = 480.83, ["Mega|Ride"] = 617.86, ["Mega|Fly|Ride"] = 905.63}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 984.38, ["Ride"] = 1081.5, ["Fly|Ride"] = 1149.75, ["Neon"] = 4641.09, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 4639.24, ["Mega|Fly|Ride"] = 15468.84}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 6.9, ["Fly"] = 30.18, ["Ride"] = 19.56, ["Fly|Ride"] = 90.51, ["Neon"] = 40.63, ["Neon|Fly"] = 84.06, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 200.79, ["Mega"] = 271.41, ["Mega|Ride"] = 233.76, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 3.52, ["Fly"] = 13590.63, ["Ride"] = 35.96, ["Fly|Ride"] = 135.19, ["Neon"] = 30.56, ["Neon|Ride"] = 91.64, ["Mega"] = 220.36, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 240.19, ["Mega|Fly|Ride"] = 467.51}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 81.36, ["Ride"] = 22.32, ["Fly|Ride"] = 69.57, ["Neon"] = 13.13, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 37.13, ["Mega"] = 106.32, ["Mega|Ride"] = 169.68, ["Mega|Fly|Ride"] = 707.44}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 14.16, ["Ride"] = 40.17, ["Fly|Ride"] = 81.09, ["Neon"] = 76.63, ["Neon|Ride"] = 79.43, ["Neon|Fly|Ride"] = 173.99, ["Mega"] = 342.57, ["Mega|Ride"] = 357, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.35, ["Fly"] = 20.61, ["Ride"] = 18.47, ["Fly|Ride"] = 41.01, ["Neon"] = 19.64, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 92.57, ["Mega"] = 129.15, ["Mega|Ride"] = 158.59, ["Mega|Fly|Ride"] = 271.48}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 36.05, ["Neon"] = 11.22, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 56.25, ["Neon|Fly|Ride"] = 205.94, ["Mega"] = 111.46, ["Mega|Fly"] = 274.93, ["Mega|Ride"] = 198.19, ["Mega|Fly|Ride"] = 327.47}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 205.94, ["Fly"] = 261.53, ["Ride"] = 262.5, ["Fly|Ride"] = 391.27, ["Neon|Fly|Ride"] = 984.38}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.61, ["Fly"] = 26.25, ["Ride"] = 19.59, ["Fly|Ride"] = 72.19, ["Neon"] = 8.47, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 119.84, ["Mega"] = 82.69, ["Mega|Fly"] = 411.86, ["Mega|Ride"] = 114.03, ["Mega|Fly|Ride"] = 242.01}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 4.66, ["Ride"] = 81.79, ["Fly|Ride"] = 88.87, ["Neon"] = 39.15, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 137.97, ["Mega|Ride"] = 411.9, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 4.2, ["Fly"] = 92.17, ["Ride"] = 26.17, ["Neon"] = 15.32, ["Neon|Ride"] = 1373.49, ["Mega"] = 85.32, ["Mega|Fly"] = 137.97, ["Mega|Ride"] = 205.96, ["Mega|Fly|Ride"] = 371.24}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 203.23, ["Ride"] = 315, ["Fly|Ride"] = 1036.23, ["Neon"] = 787.5, ["Neon|Fly"] = 1029.61, ["Neon|Ride"] = 816.38, ["Mega"] = 3088.79, ["Mega|Ride"] = 4942.67, ["Mega|Fly|Ride"] = 2875.69}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 24.93, ["Fly"] = 60.76, ["Ride"] = 67.97, ["Fly|Ride"] = 158.58, ["Neon"] = 124.68, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 708.75, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 19.59, ["Ride"] = 38.75, ["Fly|Ride"] = 89.25, ["Neon"] = 78, ["Neon|Ride"] = 137.97, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 496.04, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 579.2}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 82.39, ["Neon"] = 2.52, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 46.64, ["Mega"] = 36.29, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 224.49}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 64.32, ["Fly"] = 106.07, ["Ride"] = 93.54, ["Fly|Ride"] = 137.97, ["Neon"] = 262.48, ["Neon|Fly"] = 411.86, ["Neon|Ride"] = 291.38, ["Neon|Fly|Ride"] = 328.13, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.03, ["Neon"] = 5.25, ["Neon|Ride"] = 55.61, ["Neon|Fly|Ride"] = 122.54, ["Mega"] = 52.41, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 22.34, ["Fly"] = 97.48, ["Ride"] = 34.13, ["Fly|Ride"] = 75.78, ["Neon"] = 65.63, ["Neon|Ride"] = 122.8, ["Neon|Fly|Ride"] = 247.11, ["Mega"] = 274.93, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 355.08}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 45.38, ["Fly"] = 110.06, ["Ride"] = 79.95, ["Fly|Ride"] = 144.16, ["Neon"] = 244.86, ["Neon|Ride"] = 309.68, ["Neon|Fly|Ride"] = 311.07, ["Mega|Ride"] = 3434.12, ["Mega|Fly|Ride"] = 1157.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 13.13, ["Fly|Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 23.96, ["Neon|Ride"] = 16.49, ["Neon|Fly|Ride"] = 43.26, ["Mega"] = 15.75, ["Mega|Fly"] = 116, ["Mega|Ride"] = 31.26, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.73, ["Fly"] = 32.81, ["Ride"] = 44.1, ["Fly|Ride"] = 131.25, ["Neon"] = 14.44, ["Neon|Ride"] = 59.73, ["Neon|Fly|Ride"] = 179.17, ["Mega"] = 128.63, ["Mega|Ride"] = 257.15, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 16.69, ["Ride"] = 64.87, ["Fly|Ride"] = 109.08, ["Neon"] = 77.75, ["Neon|Ride"] = 140.04, ["Neon|Fly|Ride"] = 274.93, ["Mega"] = 586.69, ["Mega|Ride"] = 492.09, ["Mega|Fly|Ride"] = 813.49}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.78, ["Neon"] = 2.1, ["Neon|Ride"] = 28.87, ["Neon|Fly|Ride"] = 95.8, ["Mega"] = 23.63, ["Mega|Ride"] = 81.36}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 13.55, ["Fly"] = 176.59, ["Ride"] = 57.9, ["Fly|Ride"] = 99.75, ["Neon"] = 89.27, ["Neon|Ride"] = 109.15, ["Neon|Fly|Ride"] = 201.81, ["Mega"] = 556.73, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 367.4, ["Mega|Fly|Ride"] = 511.87}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 15.69, ["Fly"] = 67.97, ["Ride"] = 26.25, ["Fly|Ride"] = 45.85, ["Neon"] = 224.47, ["Neon|Ride"] = 110.18, ["Mega|Fly|Ride"] = 411.9}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 9.19, ["Ride"] = 52.5, ["Neon"] = 26.17, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 68.99, ["Neon|Fly|Ride"] = 686.75, ["Mega"] = 210, ["Mega|Ride"] = 207.37, ["Mega|Fly|Ride"] = 387.49}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 9.29, ["Fly"] = 2059.19, ["Ride"] = 85.32, ["Fly|Ride"] = 196.83, ["Neon"] = 45.94, ["Neon|Ride"] = 137.97, ["Neon|Fly|Ride"] = 6185.26, ["Mega"] = 274.93, ["Mega|Ride"] = 581.44, ["Mega|Fly|Ride"] = 786.19}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.63, ["Fly"] = 41.2, ["Ride"] = 18.56, ["Fly|Ride"] = 196.88, ["Neon"] = 7.53, ["Neon|Fly"] = 55.61, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 102.98, ["Mega"] = 68.06, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 138.01, ["Mega|Fly|Ride"] = 274.95}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 76.59, ["Neon"] = 2.63, ["Neon|Ride"] = 90.07, ["Mega"] = 30.1, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 220.29}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 30.77}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 43.84, ["Fly"] = 78.75, ["Ride"] = 70.88, ["Fly|Ride"] = 205.94, ["Neon"] = 1050, ["Neon|Ride"] = 202.49, ["Neon|Fly|Ride"] = 313.68, ["Mega"] = 1227.29, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.62, ["Mega"] = 23.06, ["Mega|Ride"] = 119.7, ["Mega|Fly|Ride"] = 308.94}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 393.75, ["Fly"] = 562.17, ["Ride"] = 446.25, ["Fly|Ride"] = 641.82, ["Neon"] = 3035.25, ["Neon|Fly|Ride"] = 2251.08, ["Mega"] = 16473.49, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 5.16, ["Fly"] = 25.81, ["Ride"] = 22.74, ["Fly|Ride"] = 66.26, ["Neon"] = 25.37, ["Neon|Ride"] = 274.93, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 79.27, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 549.88}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.1, ["Fly"] = 95.55, ["Ride"] = 19.58, ["Fly|Ride"] = 64.21, ["Neon"] = 16.71, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 161.44, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 411.9}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 10.5, ["Fly"] = 77.23, ["Ride"] = 64.87, ["Fly|Ride"] = 106.32, ["Neon"] = 89.15, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 282.19, ["Mega"] = 794.85, ["Mega|Ride"] = 522.09, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.49, ["Fly"] = 316.1, ["Ride"] = 32.48, ["Fly|Ride"] = 686.75, ["Mega"] = 258.57}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 11.71, ["Fly"] = 139.53, ["Ride"] = 105, ["Fly|Ride"] = 157.5, ["Neon"] = 52.5, ["Neon|Ride"] = 214.17, ["Neon|Fly|Ride"] = 364.49, ["Mega"] = 347.96, ["Mega|Ride"] = 400.98, ["Mega|Fly|Ride"] = 509.73}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 8.21, ["Fly"] = 105, ["Ride"] = 15.45, ["Fly|Ride"] = 133.88, ["Neon"] = 46.6, ["Neon|Ride"] = 101.75, ["Neon|Fly|Ride"] = 137.97, ["Mega"] = 203.44, ["Mega|Fly"] = 549.82, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 317.89}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.32, ["Fly|Ride"] = 66.94, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 15.45, ["Neon|Fly|Ride"] = 124.21, ["Mega"] = 14.11, ["Mega|Ride"] = 24.94, ["Mega|Fly|Ride"] = 109.87}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 8.93, ["Fly"] = 274.93, ["Ride"] = 27.82, ["Fly|Ride"] = 48.41, ["Neon"] = 28.65, ["Neon|Fly"] = 116, ["Neon|Ride"] = 93.71, ["Neon|Fly|Ride"] = 82.39, ["Mega"] = 195.57, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 517.79}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 296.63, ["Fly"] = 406.19, ["Ride"] = 262.5, ["Fly|Ride"] = 421.32, ["Neon"] = 1449.69, ["Neon|Ride"] = 1297.3, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 4254.81}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 81.25, ["Ride"] = 274.93, ["Fly|Ride"] = 215.25, ["Neon"] = 315, ["Neon|Ride"] = 467.44, ["Neon|Fly|Ride"] = 515.06, ["Mega"] = 4118.38, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1701.89}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 17.05, ["Ride"] = 15.75, ["Fly|Ride"] = 27.37, ["Neon"] = 11.44, ["Neon|Fly"] = 30.9, ["Neon|Ride"] = 30.9, ["Neon|Fly|Ride"] = 62.56, ["Mega"] = 152.39, ["Mega|Fly"] = 204.91, ["Mega|Ride"] = 123.59, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 22.08, ["Ride"] = 14.99, ["Fly|Ride"] = 31.49, ["Neon"] = 6.45, ["Neon|Fly"] = 39.15, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 46.41, ["Mega"] = 66.61, ["Mega|Fly"] = 344.02, ["Mega|Ride"] = 103.25, ["Mega|Fly|Ride"] = 171.52}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 3.18, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 39.29, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 137.97, ["Mega|Ride"] = 329.53, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 274.1, ["Fly"] = 420, ["Ride"] = 286.14, ["Fly|Ride"] = 374.07, ["Neon|Ride"] = 1029.61, ["Neon|Fly|Ride"] = 1400.26, ["Mega|Ride"] = 8237.77, ["Mega|Fly|Ride"] = 3419.71}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 48.24, ["Ride"] = 18.55, ["Fly|Ride"] = 39.38, ["Neon"] = 19.59, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 40.32, ["Neon|Fly|Ride"] = 109.04, ["Mega"] = 196.88, ["Mega|Fly"] = 123.56, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.84, ["Fly"] = 155.52, ["Ride"] = 82.11, ["Fly|Ride"] = 205.94, ["Neon"] = 27.82, ["Neon|Ride"] = 127.91, ["Neon|Fly|Ride"] = 273.89, ["Mega"] = 252, ["Mega|Ride"] = 287.31, ["Mega|Fly|Ride"] = 321.59}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 5.09, ["Neon|Ride"] = 137.71, ["Mega"] = 63, ["Mega|Ride"] = 200.61}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 13.54, ["Fly"] = 43.26, ["Ride"] = 17.79, ["Fly|Ride"] = 59.07, ["Neon"] = 79.38, ["Neon|Ride"] = 108.05, ["Neon|Fly|Ride"] = 171.95, ["Mega"] = 728.44, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 36.75, ["Fly"] = 137.97, ["Ride"] = 109.08, ["Fly|Ride"] = 209.9, ["Neon"] = 103.85, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 212.83, ["Neon|Fly|Ride"] = 379.32, ["Mega"] = 452.82, ["Mega|Fly"] = 2162.15, ["Mega|Ride"] = 446.15, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 28.88, ["Ride"] = 46.31, ["Fly|Ride"] = 104.79, ["Neon"] = 205.42, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 188.99, ["Neon|Fly|Ride"] = 201.39, ["Mega"] = 823.7, ["Mega|Ride"] = 823.79, ["Mega|Fly|Ride"] = 2059.19}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 19.38, ["Ride"] = 14.91, ["Fly|Ride"] = 32.96, ["Neon"] = 2.1, ["Neon|Fly"] = 23.63, ["Neon|Ride"] = 18.11, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 20.04, ["Mega|Fly"] = 412.51, ["Mega|Ride"] = 57.68, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 256.48, ["Ride"] = 307.13, ["Fly|Ride"] = 296.63, ["Neon"] = 3248.77, ["Neon|Ride"] = 1194.38, ["Neon|Fly|Ride"] = 1072.77}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 11.15, ["Fly"] = 82.39, ["Ride"] = 68.99, ["Fly|Ride"] = 105, ["Neon"] = 127.86, ["Neon|Ride"] = 154.97, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 850.5}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 30.69, ["Ride"] = 16.1, ["Fly|Ride"] = 44.29, ["Neon"] = 6.46, ["Neon|Fly"] = 33.57, ["Neon|Ride"] = 26.78, ["Neon|Fly|Ride"] = 109.15, ["Mega"] = 59.16, ["Mega|Fly"] = 274.93, ["Mega|Ride"] = 51.95, ["Mega|Fly|Ride"] = 139.22}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 30.9, ["Ride"] = 19.45, ["Fly|Ride"] = 34.73, ["Neon"] = 3.45, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 102.8, ["Mega"] = 25.55, ["Mega|Fly"] = 137.97, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 180.22}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 28.73, ["Fly|Ride"] = 69.29, ["Neon"] = 9.28, ["Neon|Ride"] = 34.44, ["Neon|Fly|Ride"] = 6864.31, ["Mega"] = 129.84, ["Mega|Ride"] = 127.35, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 13.44, ["Fly"] = 38.74, ["Ride"] = 20.61, ["Fly|Ride"] = 70.5, ["Neon"] = 51.5, ["Neon|Fly"] = 261.53, ["Neon|Ride"] = 64.87, ["Neon|Fly|Ride"] = 117.39, ["Mega"] = 342.12, ["Mega|Ride"] = 315.15, ["Mega|Fly|Ride"] = 354.37}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 11.45, ["Ride"] = 55.08, ["Fly|Ride"] = 72.19, ["Neon"] = 59.07, ["Neon|Ride"] = 72.09, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 216.57, ["Mega|Ride"] = 343.94, ["Mega|Fly|Ride"] = 371.24}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 274.93, ["Neon"] = 3.84, ["Neon|Ride"] = 41.2, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 18.05, ["Mega|Ride"] = 66.61, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 9.19, ["Fly"] = 96.8, ["Ride"] = 34.13, ["Fly|Ride"] = 118.13, ["Neon"] = 26.25, ["Neon|Fly"] = 102.8, ["Neon|Ride"] = 64.96, ["Neon|Fly|Ride"] = 135.33, ["Mega"] = 175.05, ["Mega|Ride"] = 212.62, ["Mega|Fly|Ride"] = 300.69}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Fly"] = 68.99, ["Ride"] = 113.12, ["Neon"] = 3.86, ["Neon|Fly"] = 110.18, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 102.3, ["Mega"] = 24.06, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 150.29}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 38.06, ["Ride"] = 22.28, ["Fly|Ride"] = 42, ["Neon"] = 6.57, ["Neon|Ride"] = 22.24, ["Neon|Fly|Ride"] = 88.23, ["Mega"] = 49.88, ["Mega|Ride"] = 82.4, ["Mega|Fly|Ride"] = 202.13}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 675.94, ["Ride"] = 758.63, ["Fly|Ride"] = 817.3, ["Neon|Ride"] = 3150, ["Neon|Fly|Ride"] = 3231.55, ["Mega|Fly|Ride"] = 12741.77}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 15.69, ["Fly|Ride"] = 35.44, ["Neon"] = 33.67, ["Neon|Fly"] = 122.75, ["Neon|Ride"] = 27.88, ["Neon|Fly|Ride"] = 32.47, ["Mega"] = 184.31, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 36.75, ["Fly|Ride"] = 81.26, ["Neon"] = 13.13, ["Neon|Fly"] = 617.76, ["Neon|Ride"] = 87.74, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 65.62, ["Mega|Fly"] = 315, ["Mega|Ride"] = 123.65, ["Mega|Fly|Ride"] = 303.78}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 7.67, ["Fly"] = 40.69, ["Ride"] = 21, ["Fly|Ride"] = 45.94, ["Neon"] = 52.41, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 38.98, ["Neon|Fly|Ride"] = 98.44, ["Mega|Ride"] = 309.74, ["Mega|Fly|Ride"] = 376.69}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 20.11, ["Ride"] = 15.44, ["Fly|Ride"] = 31.62, ["Neon"] = 8.99, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 20.61, ["Neon|Fly|Ride"] = 60.5, ["Mega"] = 65.62, ["Mega|Ride"] = 88.14, ["Mega|Fly|Ride"] = 172.53}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 30.17, ["Ride"] = 83.99, ["Fly|Ride"] = 205.94, ["Neon"] = 255.84, ["Neon|Ride"] = 257.44, ["Mega"] = 893.82, ["Mega|Ride"] = 792.9, ["Mega|Fly|Ride"] = 1153.3}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 137.97, ["Ride"] = 18.57, ["Fly|Ride"] = 63.74, ["Neon"] = 5.25, ["Neon|Fly"] = 132.23, ["Neon|Ride"] = 36.05, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 63.59, ["Mega|Ride"] = 114.74, ["Mega|Fly|Ride"] = 274.95}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.9, ["Fly"] = 68.99, ["Ride"] = 22.97, ["Fly|Ride"] = 60.76, ["Neon"] = 12.24, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 274.93, ["Mega"] = 236.25, ["Mega|Ride"] = 198.59, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 59.07, ["Neon"] = 14.44, ["Mega"] = 93.5, ["Mega|Fly"] = 274.93, ["Mega|Ride"] = 171.71, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 64.32, ["Ride"] = 15.54, ["Fly|Ride"] = 49.83, ["Neon"] = 5.09, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 23.47, ["Neon|Fly|Ride"] = 84.96, ["Mega"] = 44.63, ["Mega|Fly"] = 250.63, ["Mega|Ride"] = 55.61, ["Mega|Fly|Ride"] = 155.48}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 11.81, ["Fly"] = 23.63, ["Ride"] = 20.46, ["Fly|Ride"] = 42, ["Neon"] = 309.81, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 98.43, ["Mega"] = 823.7, ["Mega|Fly|Ride"] = 494.27}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 786.19, ["Ride"] = 780.94, ["Fly|Ride"] = 918.75, ["Neon"] = 1706.25, ["Neon|Ride"] = 1745.63, ["Neon|Fly|Ride"] = 1952.99, ["Mega|Ride"] = 6196.77, ["Mega|Fly|Ride"] = 7743.75}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 16.05, ["Ride"] = 14.44, ["Fly|Ride"] = 49.43, ["Neon"] = 3.71, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 46.41, ["Mega"] = 44.63, ["Mega|Ride"] = 56.97, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 7.4, ["Ride"] = 27.57, ["Fly|Ride"] = 115.73, ["Neon"] = 45.94, ["Neon|Fly"] = 137.97, ["Neon|Ride"] = 112.51, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 295.86, ["Mega|Ride"] = 315}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 49.6, ["Ride"] = 76.67, ["Fly|Ride"] = 113.28, ["Neon|Ride"] = 383.5, ["Neon|Fly|Ride"] = 526.57, ["Mega"] = 3150.32, ["Mega|Fly|Ride"] = 1289.23}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 27.82, ["Fly"] = 124.17, ["Ride"] = 35.96, ["Fly|Ride"] = 102.79, ["Neon"] = 105, ["Neon|Ride"] = 164.75, ["Mega"] = 763.97, ["Mega|Ride"] = 669.38, ["Mega|Fly|Ride"] = 816.38}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 12.92, ["Ride"] = 26.23, ["Fly|Ride"] = 123.59, ["Neon"] = 77.44, ["Neon|Ride"] = 110.07, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 398.47, ["Mega|Ride"] = 486.04, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 20.99, ["Ride"] = 76.2, ["Neon"] = 107.62, ["Neon|Ride"] = 135.93, ["Neon|Fly|Ride"] = 164.75, ["Mega"] = 244.52, ["Mega|Fly"] = 503.36, ["Mega|Ride"] = 340.86, ["Mega|Fly|Ride"] = 480.89}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 20.61, ["Fly"] = 126.89, ["Ride"] = 88.55, ["Neon"] = 263.4, ["Neon|Ride"] = 303.75, ["Neon|Fly|Ride"] = 485.63, ["Mega"] = 525, ["Mega|Ride"] = 619.5, ["Mega|Fly|Ride"] = 557.81}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 6.39}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 6.46, ["Fly"] = 131248.69, ["Ride"] = 26.78, ["Fly|Ride"] = 84, ["Neon"] = 32.82, ["Neon|Ride"] = 214.34, ["Neon|Fly|Ride"] = 205.94, ["Mega"] = 204.75, ["Mega|Fly"] = 454.63, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 398.52}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.52, ["Ride"] = 131.25, ["Neon"] = 42, ["Mega"] = 866.39, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 39.48, ["Fly"] = 412.21, ["Ride"] = 58.47, ["Fly|Ride"] = 96.32, ["Neon"] = 619.6, ["Neon|Ride"] = 236.76, ["Neon|Fly|Ride"] = 233.73, ["Mega|Ride"] = 897.93, ["Mega|Fly|Ride"] = 892.79}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.93, ["Fly"] = 18.37, ["Ride"] = 17.42, ["Fly|Ride"] = 39.38, ["Neon"] = 26.17, ["Neon|Fly"] = 47.38, ["Neon|Ride"] = 35.02, ["Neon|Fly|Ride"] = 69.38, ["Mega"] = 274.93, ["Mega|Ride"] = 195.46, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 3.94, ["Fly"] = 82.39, ["Ride"] = 31.35, ["Fly|Ride"] = 105, ["Neon"] = 26.64, ["Neon|Ride"] = 54.81, ["Neon|Fly|Ride"] = 123.6, ["Mega"] = 113.75, ["Mega|Ride"] = 171.28, ["Mega|Fly|Ride"] = 231.12}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 5.55, ["Mega"] = 42, ["Mega|Ride"] = 96.81, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 31.27, ["Fly"] = 59.3, ["Ride"] = 58.7, ["Fly|Ride"] = 120.75, ["Neon"] = 152.25, ["Neon|Ride"] = 148.05, ["Neon|Fly|Ride"] = 387.39, ["Mega"] = 1098.59, ["Mega|Ride"] = 782.6, ["Mega|Fly|Ride"] = 797.02}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 27.82, ["Fly|Ride"] = 65.63, ["Neon"] = 6.19, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 66.06, ["Mega"] = 105, ["Mega|Ride"] = 137.52, ["Mega|Fly|Ride"] = 309.68}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 15.45, ["Fly"] = 55.61, ["Ride"] = 72.89, ["Fly|Ride"] = 271.83, ["Neon"] = 82.69, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 357.29, ["Mega|Ride"] = 748.13, ["Mega|Fly|Ride"] = 642.55}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.77, ["Ride"] = 15.74, ["Fly|Ride"] = 35.83, ["Neon"] = 26.78, ["Neon|Ride"] = 27.37, ["Neon|Fly|Ride"] = 59.28, ["Mega"] = 170.63, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 3.94, ["Fly"] = 52.49, ["Ride"] = 17.57, ["Fly|Ride"] = 62.25, ["Neon"] = 77.75, ["Neon|Ride"] = 410.93, ["Mega"] = 377.87, ["Mega|Ride"] = 389.25, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 6.56, ["Ride"] = 59.3, ["Fly|Ride"] = 131.25, ["Neon"] = 46.76, ["Neon|Ride"] = 153.25, ["Mega"] = 375.85, ["Mega|Ride"] = 847.23}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 35.86, ["Ride"] = 125.5, ["Neon"] = 269.76, ["Neon|Fly|Ride"] = 436.55, ["Mega"] = 1643.25, ["Mega|Ride"] = 1634.18, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 15.44, ["Ride"] = 119.01, ["Neon"] = 118.41, ["Neon|Ride"] = 179.17, ["Neon|Fly|Ride"] = 144.16, ["Mega"] = 411.86, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 498.1}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 5.15, ["Ride"] = 105, ["Neon"] = 48.95, ["Neon|Ride"] = 91.88, ["Mega"] = 343.89, ["Mega|Ride"] = 975.16, ["Mega|Fly|Ride"] = 1647.57}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 21, ["Ride"] = 105, ["Fly|Ride"] = 367.46, ["Neon"] = 155.49, ["Neon|Ride"] = 617.76, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 823.7, ["Mega|Ride"] = 616.82, ["Mega|Fly|Ride"] = 1167.72}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.56, ["Neon"] = 105, ["Neon|Ride"] = 274.93, ["Mega"] = 118.13, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 17.71, ["Fly|Ride"] = 39.38, ["Neon"] = 3.9, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 61.79, ["Mega|Ride"] = 93.19, ["Mega|Fly|Ride"] = 170.97}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 5.25, ["Fly"] = 50.19, ["Ride"] = 28.88, ["Fly|Ride"] = 77.89, ["Neon"] = 12.89, ["Neon|Ride"] = 41.2, ["Neon|Fly|Ride"] = 96.74, ["Mega"] = 157.5, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 20.94, ["Ride"] = 20.61, ["Fly|Ride"] = 55.95, ["Neon"] = 5.92, ["Neon|Fly"] = 31.34, ["Neon|Ride"] = 29.87, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 47.15, ["Mega|Ride"] = 76.36, ["Mega|Fly|Ride"] = 152.41}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.62, ["Fly"] = 26.25, ["Ride"] = 24.73, ["Fly|Ride"] = 68.99, ["Neon"] = 18.55, ["Neon|Ride"] = 97.83, ["Neon|Fly|Ride"] = 137.97, ["Mega"] = 241.5, ["Mega|Ride"] = 179.82, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.51, ["Fly"] = 65.63, ["Ride"] = 32.82, ["Fly|Ride"] = 103.69, ["Neon"] = 28.87, ["Neon|Fly"] = 463.95, ["Neon|Ride"] = 82.39, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 302.45, ["Mega|Ride"] = 303.78, ["Mega|Fly|Ride"] = 1029.73}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 4.14, ["Fly"] = 131.25, ["Ride"] = 23.63, ["Fly|Ride"] = 55.71, ["Neon"] = 21, ["Neon|Fly"] = 111.54, ["Neon|Ride"] = 44.27, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 144.18, ["Mega|Ride"] = 254.67, ["Mega|Fly|Ride"] = 380.07}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.14, ["Ride"] = 17.97, ["Fly|Ride"] = 51.69, ["Neon"] = 22.32, ["Neon|Fly"] = 82.39, ["Neon|Ride"] = 46.41, ["Neon|Fly|Ride"] = 102.98, ["Mega"] = 168, ["Mega|Ride"] = 227.59}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 3.97, ["Fly"] = 55.13, ["Ride"] = 42.75, ["Neon"] = 14.44, ["Neon|Fly"] = 123.26, ["Neon|Ride"] = 123.44, ["Neon|Fly|Ride"] = 192.54, ["Mega"] = 106.32, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 411.9}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 6.57, ["Fly"] = 137.97, ["Ride"] = 96.8, ["Fly|Ride"] = 242.82, ["Neon"] = 91.88, ["Neon|Fly"] = 205.94, ["Neon|Ride"] = 267.93, ["Neon|Fly|Ride"] = 525, ["Mega"] = 465.4, ["Mega|Fly"] = 686.75, ["Mega|Ride"] = 507.89, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 46.43, ["Ride"] = 109.15, ["Fly|Ride"] = 191.51, ["Neon"] = 283.04, ["Neon|Ride"] = 278.25, ["Neon|Fly|Ride"] = 426.57, ["Mega"] = 918.75, ["Mega|Ride"] = 1085.34, ["Mega|Fly|Ride"] = 1114.14}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 50.96, ["Ride"] = 18.38, ["Fly|Ride"] = 52.53, ["Neon"] = 2.1, ["Neon|Ride"] = 38.45, ["Mega"] = 23.91, ["Mega|Ride"] = 68.61, ["Mega|Fly|Ride"] = 165.38}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 64.32, ["Neon"] = 96.8, ["Mega|Fly|Ride"] = 1235.68}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 47.16, ["Fly"] = 105, ["Ride"] = 68.25, ["Neon"] = 304.49, ["Neon|Ride"] = 274.93, ["Mega|Ride"] = 1098.72, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 5.04, ["Fly"] = 190.32, ["Ride"] = 26.25, ["Fly|Ride"] = 126, ["Neon"] = 46.87, ["Neon|Ride"] = 102.8, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 192.93, ["Mega|Ride"] = 221.82, ["Mega|Fly|Ride"] = 365.57}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 5.15, ["Ride"] = 82.39, ["Fly|Ride"] = 137.7, ["Neon"] = 3.94, ["Neon|Ride"] = 40.69, ["Mega"] = 60.38, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 30.9, ["Ride"] = 18.38, ["Fly|Ride"] = 51.07, ["Neon"] = 11.82, ["Neon|Ride"] = 30.82, ["Neon|Fly|Ride"] = 111.83, ["Mega"] = 164.07, ["Mega|Fly"] = 343.89, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 219.18}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.65, ["Ride"] = 15.45, ["Fly|Ride"] = 27.57, ["Neon"] = 2.62, ["Neon|Fly"] = 26.7, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 46.41, ["Mega"] = 28.88, ["Mega|Ride"] = 69.55, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 17.28, ["Fly|Ride"] = 75.03, ["Neon"] = 4.66, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 41.91, ["Mega|Fly"] = 168, ["Mega|Ride"] = 67.98, ["Mega|Fly|Ride"] = 151.27}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 155.49, ["Neon"] = 2.5, ["Neon|Ride"] = 47.38, ["Mega"] = 21.83, ["Mega|Ride"] = 549.88, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 6.86, ["Ride"] = 44.29, ["Neon"] = 30.09, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 617.76, ["Mega"] = 155.43, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 181.63}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 14.76, ["Ride"] = 26.79, ["Fly|Ride"] = 189.96, ["Neon"] = 52.85, ["Neon|Ride"] = 102.98, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 549.88, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 6.45, ["Fly"] = 21.95, ["Ride"] = 20.61, ["Fly|Ride"] = 32.82, ["Neon"] = 29.3, ["Neon|Fly"] = 68.99, ["Neon|Ride"] = 43.68, ["Neon|Fly|Ride"] = 91.76, ["Mega"] = 450.19, ["Mega|Ride"] = 342.57, ["Mega|Fly|Ride"] = 360.38}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 83.56, ["Ride"] = 262.56, ["Fly|Ride"] = 262.5, ["Neon"] = 274.93, ["Neon|Ride"] = 597.19, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 27.75, ["Fly"] = 81.83, ["Ride"] = 65.63, ["Fly|Ride"] = 137.97, ["Neon"] = 131.25, ["Neon|Fly|Ride"] = 630, ["Mega"] = 879.16, ["Mega|Ride"] = 827.54, ["Mega|Fly|Ride"] = 820.98}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 15.45, ["Fly|Ride"] = 40.17, ["Neon"] = 3.94, ["Neon|Fly"] = 41.11, ["Neon|Ride"] = 20.61, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 32.16, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 15.45, ["Ride"] = 14.43, ["Fly|Ride"] = 30.9, ["Neon"] = 3.94, ["Neon|Fly"] = 22.32, ["Neon|Ride"] = 20.46, ["Neon|Fly|Ride"] = 45.85, ["Mega"] = 44.63, ["Mega|Fly"] = 82.39, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 86.67}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 498.75, ["Ride"] = 530.01, ["Fly|Ride"] = 544.44, ["Neon|Fly|Ride"] = 1531.02}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 6.46, ["Ride"] = 90.19, ["Neon"] = 53.4, ["Neon|Ride"] = 96.8, ["Mega"] = 643.12, ["Mega|Fly|Ride"] = 943.69}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 48.41, ["Ride"] = 13.13, ["Fly|Ride"] = 35.98, ["Neon"] = 3.64, ["Neon|Fly"] = 26.7, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 54.79, ["Mega"] = 26.25, ["Mega|Ride"] = 74.81, ["Mega|Fly|Ride"] = 104.37}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 60.44, ["Ride"] = 137.97, ["Fly|Ride"] = 328.13, ["Neon"] = 255.05, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 510.34, ["Mega"] = 861.31, ["Mega|Ride"] = 892.79, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 24.73, ["Ride"] = 20.51, ["Fly|Ride"] = 42, ["Neon"] = 11.82, ["Neon|Fly"] = 41.91, ["Neon|Ride"] = 27.82, ["Neon|Fly|Ride"] = 64.22, ["Mega"] = 84.96, ["Mega|Fly"] = 205.94, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 190.59}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 68.99, ["Ride"] = 39.47, ["Fly|Ride"] = 1312.5, ["Neon"] = 4.2, ["Neon|Ride"] = 35.42, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 19.69, ["Mega|Fly"] = 274.93, ["Mega|Ride"] = 68.76, ["Mega|Fly|Ride"] = 185.62}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 39.38, ["Fly"] = 158.45, ["Ride"] = 100.91, ["Fly|Ride"] = 111.57, ["Neon"] = 186.38, ["Neon|Ride"] = 191.26, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 721.88, ["Mega|Ride"] = 617.47, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 15.44, ["Fly|Ride"] = 52.5, ["Neon"] = 5.86, ["Neon|Ride"] = 39.99, ["Mega"] = 41.2, ["Mega|Ride"] = 174.2, ["Mega|Fly|Ride"] = 223.12}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 32.81, ["Ride"] = 96.8, ["Fly|Ride"] = 137.97, ["Neon"] = 307.86, ["Neon|Ride"] = 253.91, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 1626.77, ["Mega|Ride"] = 1647.57, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 2.63, ["Ride"] = 47.38, ["Fly|Ride"] = 156.52, ["Neon"] = 21.77, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 480.83, ["Mega"] = 104.98, ["Mega|Ride"] = 464.63, ["Mega|Fly|Ride"] = 517.79}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 3.28, ["Fly"] = 68.99, ["Ride"] = 26.25, ["Fly|Ride"] = 65.91, ["Neon"] = 10.31, ["Neon|Ride"] = 51.5, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 119.44, ["Mega|Ride"] = 138.01, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 39.38, ["Ride"] = 98.85, ["Fly|Ride"] = 514.82, ["Neon"] = 275.63, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 2057.14, ["Mega|Ride"] = 2598.75, ["Mega|Fly|Ride"] = 1222.29}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 242.23, ["Ride"] = 28.88, ["Fly|Ride"] = 908.98, ["Neon"] = 5.16, ["Neon|Ride"] = 37.08, ["Neon|Fly|Ride"] = 151.95, ["Mega"] = 43.32, ["Mega|Fly"] = 249.61, ["Mega|Ride"] = 77.35, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 15.45, ["Ride"] = 17.42, ["Fly|Ride"] = 102.88, ["Neon"] = 40.69, ["Neon|Fly"] = 47.77, ["Neon|Ride"] = 16.49, ["Neon|Fly|Ride"] = 116, ["Mega|Fly|Ride"] = 205.78}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 7.7, ["Fly"] = 48.41, ["Ride"] = 26.25, ["Fly|Ride"] = 77.75, ["Neon"] = 77.49, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 131.81, ["Mega"] = 430.5, ["Mega|Ride"] = 462.54, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 20.61, ["Fly"] = 57.11, ["Ride"] = 32.96, ["Fly|Ride"] = 137.97, ["Neon"] = 89.03, ["Neon|Ride"] = 80.21, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 1029.61, ["Mega|Ride"] = 1853.51, ["Mega|Fly|Ride"] = 617.86}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 18.27, ["Fly"] = 39.38, ["Ride"] = 31.94, ["Fly|Ride"] = 74.15, ["Neon"] = 81.38, ["Neon|Ride"] = 109.04, ["Neon|Fly|Ride"] = 137.97, ["Mega"] = 537.12, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 338.27}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 59.06, ["Ride"] = 94.5, ["Fly|Ride"] = 215.25, ["Neon"] = 294, ["Neon|Ride"] = 492.16, ["Neon|Fly|Ride"] = 1237.52, ["Mega|Ride"] = 1488.99, ["Mega|Fly|Ride"] = 1260}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 7.76, ["Ride"] = 44.6, ["Fly|Ride"] = 387.55, ["Neon"] = 24.94, ["Neon|Ride"] = 105.04, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 214.39, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 306.87}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.84, ["Ride"] = 26.46, ["Fly|Ride"] = 78.74, ["Neon"] = 18.37, ["Neon|Ride"] = 73.12, ["Neon|Fly|Ride"] = 137.45, ["Mega"] = 185.07, ["Mega|Ride"] = 185.62, ["Mega|Fly|Ride"] = 398.52}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 15.45, ["Fly"] = 52.5, ["Ride"] = 40.17, ["Fly|Ride"] = 110.18, ["Neon"] = 46.43, ["Neon|Ride"] = 392.43, ["Neon|Fly|Ride"] = 155.43, ["Mega"] = 430.5, ["Mega|Ride"] = 303.78, ["Mega|Fly|Ride"] = 492.19}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 11.24, ["Fly|Ride"] = 31.94, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 46.41, ["Mega"] = 14.44, ["Mega|Ride"] = 23.29, ["Mega|Fly|Ride"] = 91.94}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 61.69, ["Fly"] = 137.97, ["Ride"] = 91.88, ["Neon"] = 224.95, ["Neon|Fly"] = 2334.09, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 488.15, ["Mega"] = 1083.27, ["Mega|Ride"] = 1495.17, ["Mega|Fly|Ride"] = 975.16}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 19.05, ["Fly|Ride"] = 112.22, ["Neon"] = 4.6, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 46.34, ["Mega|Ride"] = 51.27, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 27.82, ["Ride"] = 15.28, ["Fly|Ride"] = 45.93, ["Neon"] = 18.38, ["Neon|Fly"] = 137.97, ["Neon|Ride"] = 30.9, ["Neon|Fly|Ride"] = 94.74, ["Mega"] = 261.53, ["Mega|Ride"] = 123.34, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 84.19, ["Ride"] = 123.43, ["Fly|Ride"] = 222.6, ["Neon"] = 409.8, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 684.17, ["Mega"] = 1233.75, ["Mega|Ride"] = 1299.33, ["Mega|Fly|Ride"] = 1227.19}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 23.7, ["Neon"] = 7.79, ["Neon|Ride"] = 36.05, ["Mega"] = 64.31, ["Mega|Ride"] = 101.84, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 15.75}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 31.5, ["Fly|Ride"] = 57.72, ["Neon"] = 6.19, ["Neon|Ride"] = 42.82, ["Neon|Fly|Ride"] = 137.97, ["Mega"] = 49.26, ["Mega|Ride"] = 112.52, ["Mega|Fly|Ride"] = 194.81}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 105, ["Ride"] = 203.87, ["Fly|Ride"] = 262.5, ["Neon"] = 645.58, ["Neon|Ride"] = 680.82, ["Neon|Fly|Ride"] = 774.38, ["Mega"] = 3557.13, ["Mega|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 2829.69}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.94, ["Ride"] = 40.85, ["Neon"] = 27.57, ["Neon|Ride"] = 55.79, ["Neon|Fly|Ride"] = 155.43, ["Mega"] = 160.02, ["Mega|Ride"] = 202.85, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 20.9, ["Neon"] = 4.6, ["Neon|Ride"] = 20.4, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 45.42, ["Mega|Ride"] = 100.08, ["Mega|Fly|Ride"] = 125.35}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 6.8, ["Ride"] = 18.59, ["Neon"] = 32.82, ["Neon|Ride"] = 108.8, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 548.65, ["Mega|Fly|Ride"] = 614.75}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 10.71, ["Fly"] = 25.47, ["Ride"] = 20.86, ["Fly|Ride"] = 54.55, ["Neon"] = 81.86, ["Neon|Ride"] = 117.8, ["Neon|Fly|Ride"] = 179.17, ["Mega"] = 597.19, ["Mega|Ride"] = 425.25, ["Mega|Fly|Ride"] = 467.51}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 26.76, ["Ride"] = 70.88, ["Fly|Ride"] = 123, ["Neon"] = 144.83, ["Neon|Ride"] = 152.7, ["Neon|Fly|Ride"] = 619.35, ["Mega"] = 686.75, ["Mega|Ride"] = 559.83, ["Mega|Fly|Ride"] = 773.8}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 147.39, ["Fly"] = 183.74, ["Ride"] = 202.48, ["Fly|Ride"] = 249.38, ["Neon"] = 590.66, ["Neon|Fly"] = 657.63, ["Neon|Ride"] = 577.49, ["Neon|Fly|Ride"] = 610.63, ["Mega|Fly|Ride"] = 2428.13}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 19.68, ["Fly"] = 37.97, ["Ride"] = 27.18, ["Fly|Ride"] = 51.97, ["Neon"] = 91.88, ["Neon|Fly"] = 6177.56, ["Neon|Ride"] = 91.77, ["Neon|Fly|Ride"] = 144.38, ["Mega|Ride"] = 679.63, ["Mega|Fly|Ride"] = 676.96}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 6.41, ["Fly"] = 118.13, ["Ride"] = 18.8, ["Fly|Ride"] = 65.62, ["Neon"] = 13.13, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 130.96, ["Mega|Ride"] = 179.19, ["Mega|Fly|Ride"] = 249.6}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 11.82, ["Fly"] = 232.07, ["Ride"] = 27.57, ["Fly|Ride"] = 117.02, ["Neon"] = 38.07, ["Neon|Fly"] = 137.97, ["Neon|Ride"] = 68.99, ["Neon|Fly|Ride"] = 137.97, ["Mega"] = 376.82, ["Mega|Ride"] = 433.13, ["Mega|Fly|Ride"] = 393.74}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 43.05, ["Fly"] = 137.97, ["Ride"] = 84.44, ["Fly|Ride"] = 179.17, ["Neon"] = 199.5, ["Neon|Ride"] = 245.44, ["Neon|Fly|Ride"] = 250.6, ["Mega"] = 1179.93, ["Mega|Ride"] = 1081.22, ["Mega|Fly|Ride"] = 1062.48}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 21, ["Ride"] = 121.31, ["Neon"] = 155.49, ["Neon|Ride"] = 238.88, ["Neon|Fly|Ride"] = 454.07, ["Mega"] = 656.24, ["Mega|Ride"] = 1932, ["Mega|Fly|Ride"] = 815.55}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.39, ["Ride"] = 411.86, ["Neon|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 6178.33}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 40.69, ["Fly"] = 69.51, ["Ride"] = 35.02, ["Fly|Ride"] = 69.57, ["Neon"] = 228.51, ["Neon|Ride"] = 224.79, ["Neon|Fly|Ride"] = 274.98, ["Mega"] = 1034.25, ["Mega|Ride"] = 900.46, ["Mega|Fly|Ride"] = 880.42}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 36.98, ["Ride"] = 13.13, ["Fly|Ride"] = 102.55, ["Neon"] = 2.63, ["Neon|Ride"] = 15.69, ["Neon|Fly|Ride"] = 64.34, ["Mega"] = 21.83, ["Mega|Fly"] = 102.98, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Ride"] = 17.76, ["Neon"] = 16.96, ["Neon|Ride"] = 69.21, ["Neon|Fly|Ride"] = 259.89, ["Mega|Ride"] = 227.07, ["Mega|Fly|Ride"] = 406.75}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 8.26, ["Fly"] = 26.78, ["Ride"] = 57.75, ["Fly|Ride"] = 144.17, ["Neon"] = 18.38, ["Neon|Ride"] = 81.36, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 123.01, ["Mega|Fly"] = 535.4, ["Mega|Ride"] = 247.11, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 393.74, ["Ride"] = 411.86, ["Fly|Ride"] = 647.07, ["Neon"] = 1392.33, ["Neon|Ride"] = 1235.52, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4856.25}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 3.04, ["Fly"] = 55.3, ["Ride"] = 16.75, ["Fly|Ride"] = 52.5, ["Neon"] = 29.87, ["Neon|Ride"] = 41.76, ["Neon|Fly|Ride"] = 82.3, ["Mega"] = 168, ["Mega|Ride"] = 259.88, ["Mega|Fly|Ride"] = 410.92}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 6.4, ["Fly"] = 17, ["Ride"] = 17.07, ["Fly|Ride"] = 43.26, ["Neon"] = 39.38, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 51.5, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 686.83, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 5.15, ["Fly"] = 27.57, ["Ride"] = 27.56, ["Neon"] = 15.75, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 47.38, ["Neon|Fly|Ride"] = 111.36, ["Mega"] = 78.75, ["Mega|Ride"] = 138.01, ["Mega|Fly|Ride"] = 274.95}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 36.66, ["Fly"] = 45.93, ["Ride"] = 40.2, ["Fly|Ride"] = 82.39, ["Neon"] = 137.97, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 96.8, ["Mega"] = 926.64, ["Mega|Ride"] = 822.76, ["Mega|Fly|Ride"] = 640.5}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 26.99, ["Fly|Ride"] = 68.48, ["Neon"] = 7.88, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 210, ["Mega"] = 158.86, ["Mega|Ride"] = 440.46, ["Mega|Fly|Ride"] = 985.04}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 5.29, ["Fly"] = 787.5, ["Ride"] = 23.63, ["Fly|Ride"] = 85.63, ["Neon"] = 131.25, ["Neon|Ride"] = 164.33, ["Neon|Fly|Ride"] = 274.93, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.17, ["Fly|Ride"] = 41.2, ["Neon"] = 3.82, ["Neon|Ride"] = 20.61, ["Mega"] = 45.94, ["Mega|Ride"] = 138.01, ["Mega|Fly|Ride"] = 233.76}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 6.57, ["Ride"] = 137.97, ["Neon"] = 94.5, ["Mega"] = 165.38, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 20.11, ["Ride"] = 39.38, ["Neon"] = 62.91, ["Neon|Ride"] = 102.98, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 823.7, ["Mega|Ride"] = 342.25, ["Mega|Fly|Ride"] = 546.8}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 8.6, ["Fly"] = 31.5, ["Ride"] = 30.07, ["Fly|Ride"] = 45.48, ["Neon"] = 51.15, ["Neon|Fly"] = 116, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 113.88, ["Mega"] = 576.59, ["Mega|Ride"] = 395.43, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 262.39, ["Fly"] = 411.91, ["Ride"] = 282.19, ["Fly|Ride"] = 389.81, ["Neon"] = 1468.21, ["Neon|Ride"] = 1229.82, ["Neon|Fly|Ride"] = 1227.29, ["Mega|Fly|Ride"] = 5080.65}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.63, ["Fly|Ride"] = 56.8, ["Neon"] = 10.29, ["Neon|Fly"] = 77.73, ["Neon|Ride"] = 58.71, ["Neon|Fly|Ride"] = 158.17, ["Mega"] = 192.54, ["Mega|Ride"] = 155.48, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.5, ["Fly"] = 27.65, ["Ride"] = 17.07, ["Fly|Ride"] = 80.32, ["Neon"] = 36.66, ["Neon|Ride"] = 109.04, ["Neon|Fly|Ride"] = 261.53, ["Mega"] = 282.92, ["Mega|Ride"] = 269.15, ["Mega|Fly|Ride"] = 411.9}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 27.63, ["Ride"] = 91.88, ["Fly|Ride"] = 201.9, ["Neon"] = 157.5, ["Neon|Ride"] = 274.93, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 328.12, ["Mega|Ride"] = 363.57, ["Mega|Fly|Ride"] = 501.22}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 127.32, ["Fly"] = 393.75, ["Ride"] = 195.64, ["Fly|Ride"] = 274.93, ["Neon"] = 617.76, ["Neon|Fly"] = 1044.03, ["Neon|Ride"] = 417.55, ["Neon|Fly|Ride"] = 686.75, ["Mega"] = 3093.21, ["Mega|Ride"] = 1792.88, ["Mega|Fly|Ride"] = 2815.26}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 29.86, ["Fly"] = 102.38, ["Ride"] = 124.17, ["Neon"] = 101.95, ["Neon|Ride"] = 308.88, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 249.38, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Ride"] = 16.59, ["Fly|Ride"] = 51.89, ["Neon"] = 9.19, ["Neon|Fly|Ride"] = 65.54, ["Mega"] = 39.38, ["Mega|Ride"] = 193.75, ["Mega|Fly|Ride"] = 192.94}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 17.97, ["Ride"] = 36.08, ["Neon"] = 27.57, ["Neon|Ride"] = 94.25, ["Neon|Fly|Ride"] = 171.08, ["Mega"] = 160.79, ["Mega|Ride"] = 187.6, ["Mega|Fly|Ride"] = 535.47}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 63.56, ["Fly"] = 196.88, ["Ride"] = 111.56, ["Fly|Ride"] = 216.57, ["Neon"] = 141.26, ["Neon|Ride"] = 186.73, ["Neon|Fly|Ride"] = 334.52, ["Mega"] = 446.25, ["Mega|Ride"] = 452.81, ["Mega|Fly|Ride"] = 588}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 69.63, ["Neon"] = 7.69, ["Neon|Ride"] = 205.94, ["Neon|Fly|Ride"] = 190.3, ["Mega"] = 66.91, ["Mega|Fly"] = 240.94, ["Mega|Ride"] = 163.14, ["Mega|Fly|Ride"] = 153.57}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 11.33, ["Fly|Ride"] = 273.89, ["Neon"] = 110.79, ["Neon|Ride"] = 401.03, ["Mega"] = 393.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 814.53}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 961.54, ["Fly"] = 1257.74, ["Ride"] = 1052.52, ["Fly|Ride"] = 1135.84, ["Neon"] = 3488.93, ["Neon|Ride"] = 3867.97, ["Neon|Fly|Ride"] = 2723.43, ["Mega|Fly|Ride"] = 14278.1}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 20.61, ["Fly"] = 116.06, ["Ride"] = 119.44, ["Fly|Ride"] = 191.63, ["Neon"] = 110.18, ["Neon|Fly"] = 892.5, ["Neon|Ride"] = 192.54, ["Mega"] = 328.13, ["Mega|Ride"] = 549.88, ["Mega|Fly|Ride"] = 649.69}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.62, ["Fly"] = 49.26, ["Ride"] = 26.24, ["Fly|Ride"] = 80.89, ["Neon"] = 13.13, ["Neon|Fly"] = 79.83, ["Neon|Ride"] = 30.82, ["Neon|Fly|Ride"] = 121.11, ["Mega"] = 78.65, ["Mega|Ride"] = 117.41, ["Mega|Fly|Ride"] = 201.07}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 7.77, ["Ride"] = 131.22, ["Fly|Ride"] = 137.97, ["Neon"] = 117.39, ["Mega"] = 236.54, ["Mega|Ride"] = 328.02, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 16.99, ["Fly|Ride"] = 65.63, ["Neon"] = 2.63, ["Neon|Ride"] = 21.86, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 19.69, ["Mega|Fly"] = 123.56, ["Mega|Ride"] = 49.87, ["Mega|Fly|Ride"] = 150.35}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 65.54, ["Ride"] = 111.57, ["Fly|Ride"] = 236.25, ["Neon"] = 243.89, ["Neon|Ride"] = 270.95, ["Neon|Fly|Ride"] = 367.32, ["Mega"] = 1020.22, ["Mega|Ride"] = 1237.84, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 7.77, ["Ride"] = 23.63, ["Fly|Ride"] = 101.07, ["Neon"] = 47.16, ["Neon|Ride"] = 96.8, ["Neon|Fly|Ride"] = 109.04, ["Mega"] = 391.27, ["Mega|Ride"] = 462.36, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Fly"] = 96.8, ["Ride"] = 26.78, ["Fly|Ride"] = 46.43, ["Neon"] = 16.49, ["Neon|Ride"] = 47.22, ["Mega"] = 97.13, ["Mega|Ride"] = 258.03}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 18.25, ["Ride"] = 73.5, ["Fly|Ride"] = 196.88, ["Neon"] = 262.5, ["Neon|Fly|Ride"] = 261.53, ["Mega"] = 680.82, ["Mega|Ride"] = 1029.73, ["Mega|Fly|Ride"] = 773.8}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 8.26, ["Ride"] = 52.48, ["Fly|Ride"] = 86.24, ["Neon"] = 96.8, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 170.93, ["Mega"] = 578.76, ["Mega|Ride"] = 502.52, ["Mega|Fly|Ride"] = 454.13}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 47.82, ["Ride"] = 84, ["Neon"] = 387.55, ["Neon|Ride"] = 623.44, ["Neon|Fly|Ride"] = 917.44, ["Mega"] = 1867.7, ["Mega|Ride"] = 1647.57, ["Mega|Fly|Ride"] = 1585.79}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 10.31, ["Neon"] = 24.22, ["Neon|Ride"] = 85.23, ["Neon|Fly|Ride"] = 169.32, ["Mega"] = 110.25, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 287.34}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 7.28, ["Ride"] = 22.32, ["Fly|Ride"] = 78.74, ["Neon"] = 44.57, ["Neon|Ride"] = 62.46, ["Neon|Fly|Ride"] = 126.34, ["Mega"] = 399, ["Mega|Ride"] = 358.49, ["Mega|Fly|Ride"] = 357.33}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 103.05, ["Fly"] = 514.82, ["Ride"] = 156.19, ["Fly|Ride"] = 257.87, ["Neon"] = 446.25, ["Neon|Ride"] = 523.59, ["Neon|Fly|Ride"] = 574.51, ["Mega"] = 3148.5, ["Mega|Ride"] = 2335.15, ["Mega|Fly|Ride"] = 1824.37}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 24.05, ["Ride"] = 18.38, ["Fly|Ride"] = 41.15, ["Neon"] = 11.46, ["Neon|Fly"] = 64.97, ["Neon|Ride"] = 24.76, ["Neon|Fly|Ride"] = 98.85, ["Mega"] = 124.59, ["Mega|Fly"] = 124.11, ["Mega|Ride"] = 152.15, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 12.37, ["Fly"] = 89.19, ["Ride"] = 24.44, ["Fly|Ride"] = 91.88, ["Neon"] = 68.25, ["Neon|Fly"] = 201.81, ["Neon|Ride"] = 92.79, ["Neon|Fly|Ride"] = 178.5, ["Mega"] = 379.02, ["Mega|Ride"] = 329.53, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 15.45, ["Ride"] = 14.44, ["Fly|Ride"] = 43.31, ["Neon"] = 2.1, ["Neon|Fly"] = 24.35, ["Neon|Ride"] = 15.45, ["Neon|Fly|Ride"] = 55.61, ["Mega"] = 14.44, ["Mega|Fly"] = 48.74, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 77.48}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 55.61, ["Neon"] = 2.63, ["Neon|Ride"] = 39.15, ["Mega"] = 22.32, ["Mega|Fly"] = 118.12, ["Mega|Ride"] = 59.91, ["Mega|Fly|Ride"] = 110.19}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 3.94, ["Fly"] = 35.02, ["Ride"] = 18.38, ["Fly|Ride"] = 85.78, ["Neon"] = 14.97, ["Neon|Ride"] = 59.16, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 110.18, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 39.38, ["Ride"] = 315, ["Neon"] = 117.74, ["Neon|Ride"] = 411.86, ["Neon|Fly|Ride"] = 630, ["Mega"] = 414.21, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 666.25}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 16.83, ["Fly|Ride"] = 32, ["Neon"] = 12.06, ["Neon|Fly"] = 34.44, ["Neon|Ride"] = 28.87, ["Neon|Fly|Ride"] = 59.95, ["Mega"] = 108.55, ["Mega|Fly"] = 170.6, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 140.44}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 5.82, ["Fly"] = 31.5, ["Ride"] = 24.05, ["Fly|Ride"] = 52.18, ["Neon"] = 26.25, ["Neon|Fly"] = 64.32, ["Neon|Ride"] = 31.06, ["Neon|Fly|Ride"] = 62.33, ["Mega"] = 182.43, ["Mega|Fly"] = 411.86, ["Mega|Ride"] = 180, ["Mega|Fly|Ride"] = 218.3}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.26, ["Fly"] = 22.32, ["Ride"] = 18.09, ["Fly|Ride"] = 74.84, ["Neon"] = 10.5, ["Neon|Fly"] = 85.84, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 73.08, ["Mega|Fly"] = 101.95, ["Mega|Ride"] = 102.99, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 11.97, ["Fly"] = 36.05, ["Ride"] = 19.69, ["Neon"] = 35.44, ["Neon|Ride"] = 80.31, ["Neon|Fly|Ride"] = 274.93, ["Mega"] = 220.23, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 411.9}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 6.4, ["Fly"] = 170.93, ["Ride"] = 122.72, ["Fly|Ride"] = 181.22, ["Neon"] = 32.82, ["Neon|Ride"] = 254.59, ["Neon|Fly|Ride"] = 343.89, ["Mega"] = 548.63, ["Mega|Ride"] = 387.49, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 4.98, ["Fly"] = 41.88, ["Ride"] = 20.61, ["Fly|Ride"] = 65.63, ["Neon"] = 24.22, ["Neon|Fly"] = 196.67, ["Neon|Ride"] = 60.77, ["Neon|Fly|Ride"] = 109.35, ["Mega"] = 329.48, ["Mega|Ride"] = 232.03, ["Mega|Fly|Ride"] = 418.28}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 21.18, ["Ride"] = 18.55, ["Fly|Ride"] = 34.94, ["Neon"] = 11.64, ["Neon|Fly"] = 68.33, ["Neon|Ride"] = 27.85, ["Neon|Fly|Ride"] = 62.65, ["Mega"] = 131.15, ["Mega|Ride"] = 138.01, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 181.81, ["Fly"] = 382.05, ["Ride"] = 303.75, ["Fly|Ride"] = 392.43, ["Neon"] = 1126.39, ["Neon|Ride"] = 1235.52, ["Neon|Fly|Ride"] = 1169.1, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 7.77, ["Ride"] = 61.76, ["Neon"] = 31.35, ["Neon|Ride"] = 55.61, ["Neon|Fly|Ride"] = 411.86, ["Mega"] = 119.62, ["Mega|Ride"] = 411.9, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.83, ["Fly"] = 26.25, ["Ride"] = 21.62, ["Fly|Ride"] = 77.23, ["Neon"] = 23.15, ["Neon|Fly"] = 220.36, ["Neon|Ride"] = 46.41, ["Neon|Fly|Ride"] = 201.81, ["Mega"] = 199.5, ["Mega|Ride"] = 278.43, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 14.42, ["Ride"] = 27.82, ["Neon"] = 59.73, ["Neon|Ride"] = 213.44, ["Neon|Fly|Ride"] = 617.76, ["Mega"] = 462.78, ["Mega|Ride"] = 288.33, ["Mega|Fly|Ride"] = 547.98}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 16.06, ["Ride"] = 13.13, ["Fly|Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 23.63, ["Neon|Ride"] = 15.45, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 15.44, ["Mega|Fly"] = 162.75, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 96.46}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 24.92, ["Ride"] = 17.06, ["Fly|Ride"] = 27.82, ["Neon"] = 9.17, ["Neon|Ride"] = 28.98, ["Neon|Fly|Ride"] = 94.81, ["Mega"] = 101.04, ["Mega|Ride"] = 143.59, ["Mega|Fly|Ride"] = 202.12}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.54, ["Ride"] = 68.99, ["Neon"] = 16.49, ["Neon|Ride"] = 205.94, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 63.5, ["Mega|Ride"] = 204.93, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 74.74, ["Fly"] = 123.56, ["Ride"] = 108.63, ["Fly|Ride"] = 139.13, ["Neon"] = 619.6, ["Neon|Ride"] = 461.27, ["Neon|Fly|Ride"] = 415.8, ["Mega"] = 2059.19, ["Mega|Ride"] = 3434.12, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 5.15, ["Fly"] = 91.88, ["Ride"] = 30.18, ["Fly|Ride"] = 262.48, ["Neon"] = 21.63, ["Neon|Ride"] = 41.2, ["Neon|Fly|Ride"] = 92.8, ["Mega"] = 209.42, ["Mega|Ride"] = 350.13, ["Mega|Fly|Ride"] = 410.87}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 20.99, ["Ride"] = 47.39, ["Fly|Ride"] = 118.41, ["Neon"] = 15.75, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 519.43, ["Mega"] = 52.5, ["Mega|Fly"] = 313.69, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 205.96}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 45.94, ["Fly"] = 210, ["Ride"] = 86.59, ["Fly|Ride"] = 274.93, ["Neon"] = 118.13, ["Neon|Ride"] = 196.66, ["Neon|Fly|Ride"] = 309.68, ["Mega"] = 523.69, ["Mega|Ride"] = 593.99, ["Mega|Fly|Ride"] = 618.3}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 17.06, ["Ride"] = 12.74, ["Fly|Ride"] = 24.43, ["Neon"] = 2.1, ["Neon|Fly"] = 18.55, ["Neon|Ride"] = 15.67, ["Neon|Fly|Ride"] = 32.65, ["Mega"] = 17.07, ["Mega|Fly"] = 49.38, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 93.16}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Fly|Ride"] = 65.63, ["Neon"] = 5.25, ["Neon|Ride"] = 27.25, ["Neon|Fly|Ride"] = 124.11, ["Mega"] = 27.57, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 158.82}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 3.8, ["Ride"] = 107.63, ["Neon"] = 10.5, ["Neon|Ride"] = 90.96, ["Neon|Fly|Ride"] = 181.22, ["Mega"] = 57.75, ["Mega|Fly"] = 179.17, ["Mega|Ride"] = 116.05, ["Mega|Fly|Ride"] = 200.16}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 12.01, ["Fly"] = 68.25, ["Ride"] = 38.07, ["Fly|Ride"] = 130.77, ["Neon"] = 21.25, ["Neon|Fly"] = 137.97, ["Neon|Ride"] = 70.03, ["Neon|Fly|Ride"] = 231.98, ["Mega"] = 103.69, ["Mega|Fly"] = 212.1, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.45, ["Ride"] = 14.81, ["Fly|Ride"] = 31.5, ["Neon"] = 2.1, ["Neon|Fly"] = 25.67, ["Neon|Ride"] = 48.41, ["Neon|Fly|Ride"] = 47.38, ["Mega"] = 23.22, ["Mega|Ride"] = 32.71, ["Mega|Fly|Ride"] = 118.12}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 17.69, ["Fly"] = 72.19, ["Ride"] = 39.15, ["Neon"] = 97.69, ["Neon|Fly"] = 411.86, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 961.65, ["Mega"] = 391.27, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 679.63}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2572.5, ["Ride"] = 2613.66, ["Fly|Ride"] = 2552.82, ["Neon"] = 9295.17, ["Neon|Fly|Ride"] = 10982.67, ["Mega|Fly|Ride"] = 34598.61}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 16.4, ["Ride"] = 15.26, ["Fly|Ride"] = 37.42, ["Neon"] = 9.19, ["Neon|Fly"] = 62.65, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 51.5, ["Mega"] = 77.44, ["Mega|Fly"] = 454.07, ["Mega|Ride"] = 113.3, ["Mega|Fly|Ride"] = 172.89}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 3.03, ["Neon"] = 13.95, ["Neon|Ride"] = 96.8, ["Mega"] = 187.04, ["Mega|Fly"] = 441, ["Mega|Ride"] = 138.01, ["Mega|Fly|Ride"] = 412.13}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 15.65, ["Ride"] = 34.13, ["Fly|Ride"] = 105, ["Neon"] = 105, ["Neon|Ride"] = 274.93, ["Neon|Fly|Ride"] = 275.62, ["Mega"] = 393.75, ["Mega|Ride"] = 397.69, ["Mega|Fly|Ride"] = 549.88}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 31.7, ["Ride"] = 58.71, ["Neon"] = 155.49, ["Neon|Ride"] = 205.94, ["Neon|Fly|Ride"] = 205.94, ["Mega"] = 540.75, ["Mega|Ride"] = 769.21, ["Mega|Fly|Ride"] = 812.09}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 141.32, ["Fly"] = 1373.49, ["Ride"] = 197.74, ["Fly|Ride"] = 342.3, ["Neon"] = 686.75, ["Neon|Ride"] = 693.39, ["Neon|Fly|Ride"] = 787.65, ["Mega"] = 6177.56, ["Mega|Fly|Ride"] = 3378.37}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 9.98, ["Ride"] = 28.88, ["Fly|Ride"] = 675.94, ["Neon"] = 16.37, ["Neon|Ride"] = 130.17, ["Mega"] = 106.32, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 163.03, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 55.61, ["Neon"] = 13.13, ["Neon|Fly"] = 102.98, ["Neon|Ride"] = 274.93, ["Neon|Fly|Ride"] = 514.82, ["Mega"] = 115.92, ["Mega|Ride"] = 320.15, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.63, ["Fly"] = 101.99, ["Ride"] = 40.42, ["Fly|Ride"] = 131.25, ["Neon"] = 7.88, ["Neon|Ride"] = 56.44, ["Mega"] = 109.04, ["Mega|Ride"] = 96.29, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 13.52, ["Ride"] = 102.98, ["Neon"] = 135.19, ["Neon|Ride"] = 1165.83, ["Neon|Fly|Ride"] = 484.96, ["Mega|Ride"] = 605.49, ["Mega|Fly|Ride"] = 718.76}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 82.39, ["Mega"] = 17.07, ["Mega|Fly"] = 116, ["Mega|Ride"] = 155.48, ["Mega|Fly|Ride"] = 273.92}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 97.88, ["Fly"] = 137.97, ["Ride"] = 102.98, ["Fly|Ride"] = 168.87, ["Neon"] = 410.83, ["Neon|Ride"] = 451.5, ["Neon|Fly|Ride"] = 467.42, ["Mega|Fly|Ride"] = 1724.79}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 91.82, ["Neon"] = 10.19, ["Neon|Ride"] = 68.99, ["Neon|Fly|Ride"] = 205.94, ["Mega"] = 62.65, ["Mega|Ride"] = 203.89, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 43.32, ["Fly"] = 102.98, ["Ride"] = 81.2, ["Fly|Ride"] = 196.88, ["Neon"] = 262.5, ["Neon|Ride"] = 274.37, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 2625, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.5, ["Fly|Ride"] = 50.81, ["Neon"] = 3.94, ["Neon|Fly"] = 87.44, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 43.32, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 166.82}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 4.47, ["Neon"] = 11.46, ["Neon|Ride"] = 118.13, ["Mega"] = 60.38, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 605.49}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 12.28, ["Ride"] = 36.65, ["Fly|Ride"] = 157.5, ["Neon"] = 51.14, ["Neon|Ride"] = 94.4, ["Neon|Fly|Ride"] = 205.94, ["Mega"] = 230.9, ["Mega|Ride"] = 346.01, ["Mega|Fly|Ride"] = 918.82}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 393.75, ["Ride"] = 455.56, ["Fly|Ride"] = 464.13, ["Neon"] = 1307.25, ["Neon|Ride"] = 1209.93, ["Neon|Fly|Ride"] = 1246.77, ["Mega|Ride"] = 4725, ["Mega|Fly|Ride"] = 4462.5}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 31.35, ["Ride"] = 44.18, ["Fly|Ride"] = 129.74, ["Neon"] = 205.94, ["Neon|Ride"] = 88.55, ["Neon|Fly|Ride"] = 259.48, ["Mega"] = 1373.49, ["Mega|Ride"] = 1215.09, ["Mega|Fly|Ride"] = 1098.72}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 47.38, ["Ride"] = 17.74, ["Fly|Ride"] = 91.88, ["Neon"] = 7.45, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 50.94, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 15.65, ["Fly"] = 82.39, ["Ride"] = 54.55, ["Fly|Ride"] = 131.25, ["Neon"] = 50.61, ["Neon|Fly"] = 105, ["Neon|Ride"] = 111.56, ["Neon|Fly|Ride"] = 174.12, ["Mega"] = 257.25, ["Mega|Fly"] = 954.54, ["Mega|Ride"] = 253.32, ["Mega|Fly|Ride"] = 360.83}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 6.59, ["Ride"] = 20.68, ["Fly|Ride"] = 262.56, ["Neon"] = 137.97, ["Neon|Ride"] = 76.2, ["Neon|Fly|Ride"] = 309.68, ["Mega"] = 1098.59, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 408.71}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.88, ["Ride"] = 27.82, ["Neon"] = 15.75, ["Mega"] = 68.25, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 3.5, ["Fly"] = 86.62, ["Ride"] = 20.16, ["Fly|Ride"] = 57.64, ["Neon"] = 24.94, ["Neon|Ride"] = 32.79, ["Neon|Fly|Ride"] = 210.06, ["Mega"] = 137.97, ["Mega|Ride"] = 482.07, ["Mega|Fly|Ride"] = 1647.57}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 110.44, ["Ride"] = 131.25, ["Fly|Ride"] = 220.89, ["Neon"] = 619.6, ["Neon|Ride"] = 616.88, ["Neon|Fly|Ride"] = 695.9, ["Mega|Fly|Ride"] = 2581.52}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 22.18, ["Ride"] = 102.98, ["Fly|Ride"] = 137.97, ["Neon"] = 191.62, ["Neon|Ride"] = 192.15, ["Neon|Fly|Ride"] = 274.93, ["Mega"] = 682.5, ["Mega|Ride"] = 719.79, ["Mega|Fly|Ride"] = 673.98}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2216.71, ["Fly"] = 2470.01, ["Ride"] = 2229.94, ["Fly|Ride"] = 2244.38, ["Neon"] = 10982.67, ["Neon|Fly|Ride"] = 5848.5, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.03, ["Fly"] = 65625, ["Ride"] = 107.63, ["Fly|Ride"] = 196.87, ["Neon"] = 8.89, ["Neon|Ride"] = 137.97, ["Neon|Fly|Ride"] = 105, ["Mega"] = 104.89, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 184.31, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 7.88, ["Fly|Ride"] = 137.52, ["Neon"] = 31.5, ["Neon|Ride"] = 101.46, ["Neon|Fly|Ride"] = 232.32, ["Mega"] = 185.41, ["Mega|Ride"] = 294.73, ["Mega|Fly|Ride"] = 546.8}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 872.82, ["Fly"] = 1157.97, ["Ride"] = 999.63, ["Fly|Ride"] = 988.32, ["Neon"] = 2623.69, ["Neon|Ride"] = 2938.97, ["Neon|Fly|Ride"] = 2611.88, ["Mega|Fly|Ride"] = 9186.19}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 31.5, ["Ride"] = 52.5, ["Fly|Ride"] = 173.35, ["Neon"] = 155.49, ["Neon|Ride"] = 291.72, ["Mega"] = 839.9, ["Mega|Ride"] = 804.56, ["Mega|Fly|Ride"] = 864.97}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.97, ["Ride"] = 22.91, ["Fly|Ride"] = 128.15, ["Neon"] = 24.92, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 328.12, ["Mega"] = 194.25, ["Mega|Ride"] = 131.82, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.41, ["Ride"] = 137.97, ["Neon"] = 3.94, ["Neon|Fly"] = 41.2, ["Neon|Ride"] = 54.74, ["Neon|Fly|Ride"] = 77.73, ["Mega"] = 39.38, ["Mega|Ride"] = 138.01, ["Mega|Fly|Ride"] = 247.15}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 83.95, ["Fly"] = 393.75, ["Ride"] = 127.32, ["Fly|Ride"] = 205.94, ["Neon"] = 459.38, ["Neon|Fly|Ride"] = 525, ["Mega"] = 4315.03, ["Mega|Fly|Ride"] = 5323.74}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 4.66, ["Neon"] = 22.32, ["Neon|Ride"] = 64.96, ["Neon|Fly|Ride"] = 116, ["Mega"] = 144.79, ["Mega|Ride"] = 165.1, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 72.24, ["Ride"] = 136.49, ["Neon"] = 380.63, ["Neon|Ride"] = 463.95, ["Neon|Fly|Ride"] = 494.32}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 15.45, ["Fly"] = 105, ["Fly|Ride"] = 110.18, ["Neon"] = 39.22, ["Neon|Ride"] = 77.73, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 203.44, ["Mega|Ride"] = 309.02, ["Mega|Fly|Ride"] = 179.19}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 284.82, ["Ride"] = 320.35, ["Fly|Ride"] = 363.57, ["Neon"] = 1410.28, ["Neon|Ride"] = 836.06, ["Neon|Fly|Ride"] = 879.38, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.94, ["Fly"] = 87.83, ["Ride"] = 20.61, ["Fly|Ride"] = 55.61, ["Neon"] = 156.19, ["Neon|Ride"] = 65.4, ["Neon|Fly|Ride"] = 114.17, ["Mega|Ride"] = 272.12, ["Mega|Fly|Ride"] = 349.41}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 17.42, ["Fly|Ride"] = 39.38, ["Neon"] = 4.6, ["Neon|Fly"] = 31.32, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 45.56, ["Mega|Fly"] = 105.33, ["Mega|Ride"] = 78.68, ["Mega|Fly|Ride"] = 107.1}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 915.81, ["Ride"] = 1050, ["Fly|Ride"] = 1114.32, ["Neon|Ride"] = 7551.04, ["Neon|Fly|Ride"] = 5491.85, ["Mega"] = 26083.68}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 8.07, ["Fly"] = 961.65, ["Ride"] = 72.19, ["Neon"] = 43.36, ["Neon|Ride"] = 129.4, ["Mega"] = 245.06, ["Mega|Ride"] = 343.94, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 6.59, ["Fly"] = 54.91, ["Ride"] = 35.25, ["Fly|Ride"] = 97.13, ["Neon"] = 24.94, ["Neon|Fly"] = 124.4, ["Neon|Ride"] = 58.71, ["Neon|Fly|Ride"] = 137.97, ["Mega"] = 181.13, ["Mega|Fly"] = 227.55, ["Mega|Ride"] = 174.18, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 55.13, ["Fly"] = 40.79, ["Ride"] = 55.04, ["Fly|Ride"] = 62.75, ["Neon"] = 155.49, ["Neon|Ride"] = 199.5, ["Neon|Fly|Ride"] = 183.66, ["Mega"] = 2059.19, ["Mega|Ride"] = 1235.68, ["Mega|Fly|Ride"] = 817.61}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 13.53, ["Fly"] = 59.07, ["Ride"] = 27.43, ["Fly|Ride"] = 89.25, ["Neon"] = 68.11, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 76.15, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 367.49, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 31.5, ["Ride"] = 209.99, ["Fly|Ride"] = 401.56, ["Neon"] = 106.16, ["Neon|Ride"] = 274.93, ["Mega"] = 484.96, ["Mega|Ride"] = 574.6, ["Mega|Fly|Ride"] = 823.79}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 65.63, ["Fly|Ride"] = 232.07, ["Neon"] = 2.1, ["Neon|Fly"] = 55.6, ["Neon|Ride"] = 108.71, ["Neon|Fly|Ride"] = 309.68, ["Mega"] = 14.34, ["Mega|Ride"] = 71.07, ["Mega|Fly|Ride"] = 96.81}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 50.67, ["Fly"] = 102.98, ["Ride"] = 75.95, ["Fly|Ride"] = 131.15, ["Neon"] = 337.89, ["Neon|Fly"] = 382.75, ["Neon|Ride"] = 309.68, ["Neon|Fly|Ride"] = 398.89, ["Mega"] = 3294.71, ["Mega|Fly|Ride"] = 1182.64}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 102.27, ["Ride"] = 19.92, ["Fly|Ride"] = 77.49, ["Neon"] = 31.5, ["Neon|Ride"] = 78.72, ["Mega"] = 773.07, ["Mega|Ride"] = 338.12, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 20.61, ["Fly|Ride"] = 38.07, ["Neon"] = 14.11, ["Neon|Ride"] = 52.53, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 268.58, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 41.2, ["Ride"] = 171.95, ["Neon"] = 20.13, ["Neon|Fly|Ride"] = 184.31, ["Mega"] = 261.53, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 31.4, ["Ride"] = 67.97, ["Fly|Ride"] = 137.97, ["Neon"] = 229.62, ["Neon|Ride"] = 247.11, ["Neon|Fly|Ride"] = 274.93, ["Mega"] = 1017.26, ["Mega|Ride"] = 1017.19, ["Mega|Fly|Ride"] = 928.09}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 7.88, ["Fly|Ride"] = 411.86, ["Neon"] = 20.9, ["Neon|Ride"] = 77.23, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 93.64, ["Mega|Ride"] = 110.19, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 33.78, ["Neon"] = 2.1, ["Neon|Ride"] = 20.6, ["Mega"] = 13.56, ["Mega|Ride"] = 55.61, ["Mega|Fly|Ride"] = 341.16}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 68.99, ["Ride"] = 24.72, ["Fly|Ride"] = 82.38, ["Neon"] = 2.57, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 18.38, ["Mega|Fly"] = 26.25, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 110.19}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 22.17, ["Ride"] = 17.42, ["Fly|Ride"] = 38.66, ["Neon"] = 5.21, ["Neon|Fly"] = 123.56, ["Neon|Ride"] = 19.97, ["Neon|Fly|Ride"] = 76.2, ["Mega"] = 98.85, ["Mega|Ride"] = 58.49, ["Mega|Fly|Ride"] = 178.5}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 21.74, ["Mega"] = 118.09, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 39.15, ["Ride"] = 15.4, ["Fly|Ride"] = 43.26, ["Neon"] = 14.34, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 77.73, ["Mega"] = 229.04, ["Mega|Ride"] = 274.95, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 57.07, ["Ride"] = 155.23, ["Fly|Ride"] = 360.38, ["Neon"] = 196.88, ["Neon|Ride"] = 231.27, ["Neon|Fly|Ride"] = 1029.61, ["Mega"] = 1547.19, ["Mega|Ride"] = 883.31, ["Mega|Fly|Ride"] = 1057.53}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 16.14, ["Ride"] = 14.77, ["Fly|Ride"] = 31.5, ["Neon"] = 3.67, ["Neon|Fly"] = 22.66, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 48.41, ["Mega"] = 49.88, ["Mega|Ride"] = 69.01, ["Mega|Fly|Ride"] = 127.05}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 9.24, ["Fly"] = 75.28, ["Ride"] = 36.05, ["Fly|Ride"] = 94.74, ["Neon"] = 39.15, ["Neon|Fly"] = 49.88, ["Neon|Ride"] = 62.65, ["Neon|Fly|Ride"] = 114.09, ["Mega"] = 262.5, ["Mega|Fly"] = 321.78, ["Mega|Ride"] = 238.98, ["Mega|Fly|Ride"] = 296.26}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 15.45, ["Fly"] = 39.29, ["Ride"] = 26.25, ["Fly|Ride"] = 65.62, ["Neon"] = 108.94, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 787.5, ["Mega|Ride"] = 373.96, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 2.63, ["Fly"] = 196.88, ["Fly|Ride"] = 51.5, ["Neon"] = 45.94, ["Neon|Ride"] = 82.39, ["Mega"] = 288.3, ["Mega|Ride"] = 246.75, ["Mega|Fly|Ride"] = 409.85}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 16.47, ["Fly|Ride"] = 38.99, ["Neon"] = 3.68, ["Neon|Fly"] = 40.17, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 41.91, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 121.96}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 2.89, ["Fly"] = 39.38, ["Ride"] = 30.19, ["Neon"] = 10.4, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 96.53, ["Mega"] = 136.5, ["Mega|Fly"] = 735, ["Mega|Ride"] = 155.81, ["Mega|Fly|Ride"] = 398.52}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 1044.74, ["Fly"] = 1235.52, ["Ride"] = 896.44, ["Fly|Ride"] = 1077.83, ["Neon|Ride"] = 2191.86, ["Neon|Fly|Ride"] = 2323.13, ["Mega|Fly|Ride"] = 6891.39}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 81.38, ["Ride"] = 137.97, ["Fly|Ride"] = 201.9, ["Neon"] = 413.44, ["Neon|Ride"] = 458.07, ["Neon|Fly|Ride"] = 566.29, ["Mega"] = 3087.76, ["Mega|Ride"] = 2471.34, ["Mega|Fly|Ride"] = 1643.24}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 5.81, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 205.94, ["Mega"] = 73.9, ["Mega|Fly|Ride"] = 205.96}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 57.44, ["Ride"] = 111.21, ["Fly|Ride"] = 139.25, ["Neon"] = 301.88, ["Neon|Ride"] = 261.19, ["Neon|Fly|Ride"] = 496.13, ["Mega"] = 1050, ["Mega|Ride"] = 1235.68, ["Mega|Fly|Ride"] = 1162.88}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 4.88, ["Ride"] = 26.37, ["Fly|Ride"] = 89.59, ["Neon"] = 62.83, ["Neon|Fly"] = 54.53, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 274.93, ["Mega"] = 268.55, ["Mega|Ride"] = 305.92, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 297.05, ["Fly"] = 411.86, ["Ride"] = 216.57, ["Fly|Ride"] = 445.18, ["Neon|Ride"] = 1522.5, ["Neon|Fly|Ride"] = 1744.15, ["Mega|Fly|Ride"] = 4435.03}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 75.64, ["Ride"] = 40.17, ["Fly|Ride"] = 200.62, ["Neon"] = 24.68, ["Neon|Ride"] = 54.28, ["Mega"] = 137.97, ["Mega|Fly"] = 321.25, ["Mega|Ride"] = 185.62, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 20.61, ["Neon|Ride"] = 137.97, ["Mega"] = 329.48}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 38.07, ["Ride"] = 78.66, ["Fly|Ride"] = 164.75, ["Neon"] = 164.07, ["Neon|Fly"] = 398.47, ["Neon|Ride"] = 191.51, ["Neon|Fly|Ride"] = 274.93, ["Mega"] = 542, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 961.77}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.65, ["Fly|Ride"] = 274.93, ["Neon"] = 20.61, ["Mega"] = 196.88, ["Mega|Ride"] = 250.74, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 15.45, ["Fly|Ride"] = 34.13, ["Neon"] = 3.86, ["Neon|Fly"] = 31.29, ["Neon|Ride"] = 137.97, ["Neon|Fly|Ride"] = 30.19, ["Mega"] = 27.57, ["Mega|Ride"] = 38.74, ["Mega|Fly|Ride"] = 76.13}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4331.24, ["Ride"] = 4396.88, ["Fly|Ride"] = 4436.25, ["Neon"] = 30887.76, ["Neon|Fly|Ride"] = 21827.36, ["Mega|Fly|Ride"] = 85123.86}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 11.4, ["Fly"] = 39.38, ["Ride"] = 45.94, ["Neon"] = 52.39, ["Neon|Ride"] = 106.32, ["Mega"] = 274.93, ["Mega|Ride"] = 224.86, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 22.28, ["Ride"] = 20.66, ["Fly|Ride"] = 40.04, ["Neon"] = 13.26, ["Neon|Fly"] = 45.9, ["Neon|Ride"] = 31.22, ["Neon|Fly|Ride"] = 84, ["Mega"] = 144.37, ["Mega|Ride"] = 155.48, ["Mega|Fly|Ride"] = 194.91}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 494.61, ["Fly"] = 547.77, ["Ride"] = 509.25, ["Fly|Ride"] = 590.63, ["Neon"] = 1372.81, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1647.37, ["Mega|Fly|Ride"] = 5455.47}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 7.88, ["Ride"] = 26.25, ["Neon"] = 17.07, ["Neon|Ride"] = 145.69, ["Mega"] = 139.18, ["Mega|Fly|Ride"] = 686.83}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 7.54, ["Fly"] = 4110.2, ["Ride"] = 46.43, ["Neon"] = 27.82, ["Neon|Ride"] = 274.93, ["Neon|Fly|Ride"] = 274.93, ["Mega"] = 409.8, ["Mega|Ride"] = 401.63, ["Mega|Fly|Ride"] = 491.54}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.45, ["Ride"] = 27.09, ["Neon"] = 5.13, ["Neon|Fly"] = 124.68, ["Neon|Ride"] = 27.82, ["Neon|Fly|Ride"] = 91.75, ["Mega"] = 43.73, ["Mega|Ride"] = 76.13, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 805.4, ["Fly"] = 872.08, ["Ride"] = 630, ["Fly|Ride"] = 813.75, ["Neon"] = 2362.5, ["Neon|Ride"] = 2557.37, ["Neon|Fly|Ride"] = 2208.73}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.46, ["Fly"] = 56.44, ["Ride"] = 74.71, ["Neon"] = 31.35, ["Neon|Ride"] = 74.46, ["Neon|Fly|Ride"] = 179.17, ["Mega"] = 156.19, ["Mega|Ride"] = 199.75, ["Mega|Fly|Ride"] = 369.59}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 114.19, ["Fly"] = 52.5, ["Ride"] = 35.44, ["Fly|Ride"] = 98.44, ["Neon"] = 28.65, ["Neon|Ride"] = 60.38, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 203.43, ["Mega|Ride"] = 191.63, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.11, ["Ride"] = 19.59, ["Fly|Ride"] = 52.5, ["Neon"] = 11.82, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 28.49, ["Neon|Fly|Ride"] = 68.25, ["Mega"] = 274.93, ["Mega|Fly"] = 549.82, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 19.69, ["Fly"] = 19.69, ["Ride"] = 46.43, ["Fly|Ride"] = 155.49, ["Neon"] = 117.59, ["Neon|Fly"] = 170.63, ["Neon|Ride"] = 137.97, ["Mega"] = 549.82, ["Mega|Fly|Ride"] = 741.41}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Fly|Ride"] = 262.5, ["Neon"] = 2.63, ["Neon|Fly"] = 68.99, ["Neon|Ride"] = 39.15, ["Neon|Fly|Ride"] = 184.31, ["Mega"] = 45.93, ["Mega|Ride"] = 114.38, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 529.23, ["Ride"] = 554.24, ["Fly|Ride"] = 686.75, ["Neon"] = 2589.57, ["Neon|Ride"] = 2707.01, ["Neon|Fly|Ride"] = 2343.78, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.23, ["Fly"] = 41.2, ["Ride"] = 61.66, ["Fly|Ride"] = 309.81, ["Neon"] = 14.44, ["Neon|Ride"] = 90.62, ["Neon|Fly|Ride"] = 498.75, ["Mega"] = 80.07, ["Mega|Ride"] = 169.56, ["Mega|Fly|Ride"] = 246.75}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 41.21, ["Neon"] = 5.25, ["Neon|Fly"] = 137.97, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 47.38, ["Mega|Ride"] = 138.01, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 24.7, ["Neon"] = 3.94, ["Neon|Ride"] = 41.31, ["Neon|Fly|Ride"] = 137.97, ["Mega"] = 51.19, ["Mega|Fly"] = 152.39, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.63, ["Ride"] = 21.84, ["Neon"] = 18.5, ["Mega"] = 201.81}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 35.44, ["Fly"] = 98.44, ["Ride"] = 58.03, ["Fly|Ride"] = 263.4, ["Neon"] = 144.27, ["Neon|Ride"] = 185.34, ["Neon|Fly|Ride"] = 271.83, ["Mega"] = 632.19, ["Mega|Ride"] = 548.63, ["Mega|Fly|Ride"] = 712.63}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 21.15, ["Ride"] = 55.31, ["Fly|Ride"] = 137.97, ["Neon"] = 77.64, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 261.53, ["Mega"] = 464.2, ["Mega|Ride"] = 385.9, ["Mega|Fly|Ride"] = 629.18}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 3.73, ["Fly"] = 19.16, ["Ride"] = 15.26, ["Fly|Ride"] = 52.53, ["Neon"] = 19.69, ["Neon|Ride"] = 32.48, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 299.92, ["Mega|Ride"] = 136.54, ["Mega|Fly|Ride"] = 204.93}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 8.19, ["Ride"] = 64.32, ["Fly|Ride"] = 124.17, ["Neon"] = 92.68, ["Mega"] = 309.68, ["Mega|Ride"] = 715.67}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 18.58, ["Fly|Ride"] = 73.12, ["Neon"] = 13.13, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 206.46, ["Mega"] = 86.63, ["Mega|Ride"] = 152.41, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 19.67, ["Fly"] = 23.63, ["Ride"] = 23.62, ["Fly|Ride"] = 131.25, ["Neon"] = 228.74, ["Neon|Ride"] = 185.34, ["Neon|Fly|Ride"] = 198.34, ["Mega"] = 974.26, ["Mega|Ride"] = 928.09, ["Mega|Fly|Ride"] = 880.42}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 39.19, ["Fly"] = 874.13, ["Neon"] = 273.99, ["Mega|Fly|Ride"] = 961.77}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 44.94, ["Fly"] = 115.38, ["Ride"] = 70.59, ["Fly|Ride"] = 155.49, ["Neon"] = 246.88, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 361.23, ["Mega|Ride"] = 1640.4, ["Mega|Fly|Ride"] = 1506.5}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 39.38, ["Fly"] = 92.85, ["Ride"] = 84.44, ["Fly|Ride"] = 101.95, ["Neon"] = 129.94, ["Neon|Ride"] = 191.51, ["Neon|Fly|Ride"] = 274.93, ["Mega"] = 533.02, ["Mega|Ride"] = 618.85, ["Mega|Fly|Ride"] = 620.82}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 18.27, ["Ride"] = 55.61, ["Fly|Ride"] = 137.97, ["Neon"] = 139, ["Neon|Ride"] = 123.38, ["Mega"] = 1050, ["Mega|Ride"] = 773.8, ["Mega|Fly|Ride"] = 1235.68}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 16.7, ["Fly"] = 428.28, ["Ride"] = 44.01, ["Fly|Ride"] = 68.99, ["Neon"] = 86.16, ["Neon|Fly"] = 420, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 231.55, ["Mega"] = 457.47, ["Mega|Ride"] = 356.16, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.74, ["Ride"] = 15.25, ["Fly|Ride"] = 35.02, ["Neon"] = 3.94, ["Neon|Fly"] = 25.14, ["Neon|Ride"] = 27.35, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 44.61, ["Mega|Fly"] = 155.43, ["Mega|Ride"] = 57.74, ["Mega|Fly|Ride"] = 202.79}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1253.91}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 52.41, ["Fly"] = 232.07, ["Ride"] = 126.93, ["Fly|Ride"] = 262.5, ["Neon"] = 288.46, ["Neon|Ride"] = 258.68, ["Neon|Fly|Ride"] = 329.48, ["Mega"] = 789.71, ["Mega|Ride"] = 755.84, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 55.61, ["Neon"] = 3.27, ["Neon|Fly"] = 96.8, ["Neon|Ride"] = 43.18, ["Neon|Fly|Ride"] = 288.3, ["Mega"] = 26.25, ["Mega|Ride"] = 82.4, ["Mega|Fly|Ride"] = 152.41}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 35.98, ["Ride"] = 64.87, ["Neon"] = 128.37, ["Neon|Ride"] = 137.97, ["Neon|Fly|Ride"] = 543.64, ["Mega|Ride"] = 807.32, ["Mega|Fly|Ride"] = 805.12}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 2.15, ["Neon|Ride"] = 105, ["Mega"] = 28.61}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 2.52, ["Neon|Ride"] = 39.38, ["Mega"] = 77.74, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 105, ["Ride"] = 127.7, ["Fly|Ride"] = 205.94, ["Neon"] = 511.88, ["Neon|Ride"] = 514.5, ["Neon|Fly|Ride"] = 686.75, ["Mega|Ride"] = 6380.58, ["Mega|Fly|Ride"] = 3868.96}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 59.07, ["Ride"] = 19.69, ["Fly|Ride"] = 92.69, ["Neon"] = 7.8, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 90.57, ["Mega|Ride"] = 107.62, ["Mega|Fly|Ride"] = 223.12}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 39.47, ["Ride"] = 68.99, ["Fly|Ride"] = 52.49, ["Neon"] = 3.94, ["Neon|Fly"] = 61.79, ["Neon|Ride"] = 35.02, ["Neon|Fly|Ride"] = 102.98, ["Mega"] = 31.94, ["Mega|Ride"] = 123.27, ["Mega|Fly|Ride"] = 220.38}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 82.39, ["Neon"] = 2.52, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 46.64, ["Mega"] = 36.29, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 224.49}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 5.09, ["Neon|Ride"] = 137.71, ["Mega"] = 63, ["Mega|Ride"] = 200.61}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 63, ["Ride"] = 103.69, ["Fly|Ride"] = 449.61, ["Neon"] = 415.63, ["Neon|Ride"] = 497.31, ["Neon|Fly|Ride"] = 686.75, ["Mega"] = 1544.4, ["Mega|Ride"] = 1544.6, ["Mega|Fly|Ride"] = 1367.48}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 6.56, ["Ride"] = 59.3, ["Fly|Ride"] = 131.25, ["Neon"] = 46.76, ["Neon|Ride"] = 153.25, ["Mega"] = 375.85, ["Mega|Ride"] = 847.23}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 321.57, ["Fly"] = 464.13, ["Ride"] = 432.44, ["Fly|Ride"] = 617.48, ["Neon"] = 2882.86, ["Neon|Ride"] = 1128.75, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3871.76}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 84}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 47.23}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 23.02}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 35.6}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 110.15}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 54.51}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 11.82}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 7.76}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 183.75}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 40.69}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 27.14}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 6.45}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 3.94}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 205.09}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 2.63}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 3.94}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 2.63}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 6.2}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 9.09}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 465.94}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 787.5}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 19.69}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1038.98}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 36.2}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 7.1}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 18.48}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.63}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 30.35}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 22.32}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 49.49}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 14.83}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 9.16}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 14.34}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 6.24}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 17.07}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.63}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 14.77}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 7.56}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 4.34}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1865.63}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 44.73}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 325.36}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 2.13}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 7.8}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 6.22}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 37.3}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 195.46}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 6.13}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 7.88}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 1371.43}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 24.94}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 3.5}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 15.28}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 10.39}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 5.24}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 215.71}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 28.56}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 9.19}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 27.57}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 6.86}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 4.17}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 36.05}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 90.44}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 170.63}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 3.54}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 7.88}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 27.43}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 26.17}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 81.38}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 17.06}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22105.05}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 164.07}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 38.07}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 120.72}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 48.57}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 87.94}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 91.88}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 36.66}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 68.14}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 66.75}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 55.61}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 32.81}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 71.57}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 38.07}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 53.81}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 411.86}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 6.12}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 10.31}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 3.08}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 6.46}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 28.59}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 85.22}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.94}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.52}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 11.63}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 10.5}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 636.76}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 7.88}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 577.4}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 13.13}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.43}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 603.47}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 38.98}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 68.61}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 27.82}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 48.57}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 218.29}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 14.87}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.6}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 15.45}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 4.87}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 2.37}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 27.27}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.63}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.1}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 2.52}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 17.06}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 179.45}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 65.63}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1048.69}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 3.94}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 6.29}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 2.52}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 14.34}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 90.56}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 5.17}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 5.72}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 78.66}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 8.29}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 60.38}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 18.51}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 11.05}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 4.13}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 4.7}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 6.51}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 4.76}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 3.81}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.39}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.62}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 6.45}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 6431.25}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.5}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 10.4}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 4.67}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 10.41}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 5.37}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 26.24}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 9.08}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 7.88}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 5.13}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 9.19}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 95.79}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 16.49}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.52}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 3.31}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 3.67}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.67}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 94.65}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 6.22}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.12}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4293.83}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 5.25}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 155.93}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 5.23}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 2.52}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 48.46}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 4.18}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 6.98}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 92.29}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.14}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.94}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 2.52}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 7.25}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 15.65}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.56}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.54}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.26}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 10.4}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.05}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 4.5}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 4.97}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 11.33}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.37}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.62}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 22.57}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.62}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 7.96}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 89.15}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.49}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 42}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 3.84}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 3.84}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1040.82}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 13.13}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 4.73}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 10.19}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 68.75}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.25}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 5.25}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 11.71}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 3.94}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 14.44}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 15.01}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.63}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.52}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.18}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 15.49}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.73}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.5}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 23.22}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 5.52}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 8.72}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 37.26}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.63}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 7.77}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.63}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 16.26}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 46.5}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 18.16}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 4.86}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 3.31}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 51.18}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 28.65}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 6.08}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.12}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 5.98}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 6.19}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 6.8}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 314.9}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 144.26}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1179.04}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.63}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 213.7}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 31.5}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 57.66}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.41}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.63}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 4.29}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 31.5}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 10.5}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 8.79}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 3}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.63}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 7.88}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.33}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 52.5}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 12.35}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 56.44}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 5.16}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 3.61}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.63}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 27.56}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 24.86}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 128.94}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 3.04}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 3.68}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 75}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 33.62}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 135.85}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 47.16}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 87.28}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 229.59}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.63}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 74.66}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 6.91}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 135.19}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.91}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 24.69}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 51.19}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.94}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 42.75}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 6.07}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 7.88}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 24.86}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 28.88}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 36.26}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 5.84}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 36.66}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 16.7}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 62.68}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 5.24}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 3.94}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 31.5}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.83}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 6.04}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 40.58}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 52.5}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 25.24}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1782.38}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 8.71}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 7.88}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 30.18}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 375.27}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 22.32}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 10.5}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 315}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 8.11}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 7.35}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 259.67}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 31.5}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 41.88}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 6.45}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 5.25}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 60.38}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 118.13}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 58.79}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1050}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 118.13}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 6.57}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2059.19}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 524.99}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 3.94}},
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