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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 991.95, ["Ride"] = 1130.95, ["Fly|Ride"] = 1131.1, ["Neon"] = 6651.29, ["Neon|Fly|Ride"] = 3921.75, ["Mega|Fly|Ride"] = 21169.33}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 446.25, ["Fly"] = 515.46, ["Ride"] = 396.38, ["Fly|Ride"] = 525.67, ["Neon|Ride"] = 2117.05, ["Neon|Fly|Ride"] = 1977.32, ["Mega"] = 9880.23, ["Mega|Fly|Ride"] = 8242.69}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4725, ["Ride"] = 5250, ["Fly|Ride"] = 4751.25, ["Neon"] = 26148.39, ["Neon|Fly|Ride"] = 21350.45, ["Mega|Fly|Ride"] = 67040.24}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 158.55, ["Ride"] = 174.3, ["Fly|Ride"] = 237.57, ["Neon"] = 1425.3, ["Neon|Ride"] = 776.96, ["Neon|Fly|Ride"] = 1129.46, ["Mega"] = 3810.69, ["Mega|Fly|Ride"] = 2854.69}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 632.63, ["Fly"] = 664.59, ["Ride"] = 538.13, ["Fly|Ride"] = 525, ["Neon|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 6717.8}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 9.16, ["Ride"] = 36.75, ["Fly|Ride"] = 142.06, ["Neon"] = 59.28, ["Neon|Ride"] = 84.69, ["Neon|Fly|Ride"] = 282.63, ["Mega"] = 280.88, ["Mega|Ride"] = 474.42, ["Mega|Fly|Ride"] = 409.5}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 5.92, ["Fly"] = 28.64, ["Ride"] = 26.25, ["Fly|Ride"] = 62.55, ["Neon"] = 26.25, ["Neon|Fly"] = 47.53, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 117.89, ["Mega"] = 169.32, ["Mega|Fly"] = 349.89, ["Mega|Ride"] = 141.1, ["Mega|Fly|Ride"] = 236.14}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 91.88, ["Ride"] = 156.9, ["Fly|Ride"] = 178.5, ["Neon"] = 421.93, ["Neon|Ride"] = 515.51, ["Neon|Fly|Ride"] = 634.07, ["Mega"] = 1897.59, ["Mega|Fly|Ride"] = 1975.21}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 34.47, ["Fly"] = 143.11, ["Ride"] = 48.57, ["Fly|Ride"] = 89.1, ["Neon"] = 223.13, ["Neon|Ride"] = 201.99, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 2100, ["Mega|Ride"] = 1183.45, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 17.83, ["Fly"] = 45.6, ["Ride"] = 32.08, ["Fly|Ride"] = 60.38, ["Neon"] = 198.24, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 145.69, ["Mega|Ride"] = 740.98, ["Mega|Fly|Ride"] = 735}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 52.38, ["Fly"] = 288.31, ["Ride"] = 69.57, ["Fly|Ride"] = 119.37, ["Neon"] = 316.97, ["Neon|Ride"] = 217.88, ["Neon|Fly|Ride"] = 284.65, ["Mega|Ride"] = 2000.77, ["Mega|Fly|Ride"] = 1265.45}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 81.38}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 376.69, ["Fly"] = 387.19, ["Ride"] = 406.38, ["Fly|Ride"] = 433.13, ["Neon|Fly|Ride"] = 1515.94, ["Mega"] = 5646.16, ["Mega|Fly|Ride"] = 6916.38}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 105, ["Fly"] = 105, ["Ride"] = 105, ["Fly|Ride"] = 148.12, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 459.38, ["Mega|Fly|Ride"] = 2613.19}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.57, ["Fly"] = 36.05, ["Ride"] = 24.05, ["Fly|Ride"] = 142.06, ["Neon"] = 19.69, ["Neon|Ride"] = 78.35, ["Neon|Fly|Ride"] = 80.47, ["Mega"] = 114.31, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 383.25}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 131.24, ["Fly"] = 175.41, ["Ride"] = 135.19, ["Fly|Ride"] = 157.5, ["Neon"] = 707.07, ["Neon|Ride"] = 634.07, ["Neon|Fly|Ride"] = 564.37, ["Mega|Fly|Ride"] = 1837.38}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.67, ["Fly"] = 27.2, ["Ride"] = 19.69, ["Fly|Ride"] = 52.38, ["Neon"] = 37.11, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 196.88, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 305.82}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 60.38, ["Fly"] = 262.5, ["Ride"] = 98.44, ["Fly|Ride"] = 234.94, ["Neon"] = 196.88, ["Neon|Ride"] = 229.67, ["Neon|Fly|Ride"] = 409.85, ["Mega"] = 819.31, ["Mega|Ride"] = 918.81, ["Mega|Fly|Ride"] = 772.36}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 39.32}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 72.07, ["Ride"] = 212, ["Fly|Ride"] = 246.1, ["Neon"] = 420, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 2362.5}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 9.19, ["Fly"] = 393.75, ["Ride"] = 26.17, ["Fly|Ride"] = 105.88, ["Neon"] = 128.92, ["Neon|Ride"] = 57.38, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 2727.78, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 1693.64}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 36.93, ["Fly"] = 79.58, ["Ride"] = 47.25, ["Fly|Ride"] = 104, ["Neon"] = 226.87, ["Neon|Fly"] = 315.92, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 233.63, ["Mega"] = 1681.32, ["Mega|Ride"] = 846.83, ["Mega|Fly|Ride"] = 809.66}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 57.75, ["Fly"] = 105, ["Ride"] = 155.76, ["Fly|Ride"] = 139.95, ["Neon"] = 236.25, ["Neon|Fly"] = 394.34, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 316.51, ["Mega"] = 1693.64, ["Mega|Ride"] = 1266, ["Mega|Fly|Ride"] = 1256.48}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 39.46, ["Fly"] = 64.15, ["Ride"] = 36.05, ["Fly|Ride"] = 171.29, ["Neon"] = 184.47, ["Neon|Ride"] = 197.95, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 1207.92, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1242.72}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 57.26, ["Fly"] = 49.88, ["Ride"] = 78.75, ["Fly|Ride"] = 131.25, ["Neon"] = 283.04, ["Neon|Ride"] = 309.68, ["Neon|Fly|Ride"] = 453.06, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 846.83}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 3.94, ["Fly"] = 28.88, ["Ride"] = 22.32, ["Fly|Ride"] = 39.38, ["Neon"] = 24.94, ["Neon|Fly"] = 70.88, ["Neon|Ride"] = 42.36, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 131.25, ["Mega|Fly"] = 28262.47, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 238.77}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 262.5, ["Fly"] = 370.99, ["Ride"] = 330.75, ["Fly|Ride"] = 362.25, ["Neon"] = 1475.25, ["Neon|Ride"] = 1412.09, ["Neon|Fly|Ride"] = 1412.09, ["Mega"] = 10585.19, ["Mega|Fly|Ride"] = 7332.94}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 14.34, ["Ride"] = 24.86, ["Fly|Ride"] = 137.55, ["Neon"] = 563.96, ["Neon|Ride"] = 158.95, ["Neon|Fly|Ride"] = 418.14, ["Mega"] = 833.06, ["Mega|Ride"] = 711.6, ["Mega|Fly|Ride"] = 800.25}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 7.88, ["Fly"] = 38.41, ["Ride"] = 19.69, ["Fly|Ride"] = 36.75, ["Neon"] = 49.88, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 113.27, ["Mega"] = 388.48, ["Mega|Ride"] = 372.62, ["Mega|Fly|Ride"] = 706.05}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 97.13, ["Fly"] = 127.1, ["Ride"] = 128.28, ["Fly|Ride"] = 131.25, ["Neon"] = 418.73, ["Neon|Ride"] = 444.6, ["Neon|Fly|Ride"] = 480.58, ["Mega"] = 6284.54, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 1778.33}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 13.13, ["Fly"] = 36.05, ["Ride"] = 28.64, ["Fly|Ride"] = 71.04, ["Neon"] = 95.43, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 711.6, ["Mega|Fly|Ride"] = 696.19}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 156.19, ["Fly"] = 354.03, ["Ride"] = 144.18, ["Fly|Ride"] = 353.43, ["Neon"] = 784.46, ["Neon|Ride"] = 804.49, ["Neon|Fly|Ride"] = 773.07, ["Mega"] = 6351.12, ["Mega|Fly|Ride"] = 2978.69}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 32.48}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.94, ["Fly"] = 36.84, ["Ride"] = 27.58, ["Fly|Ride"] = 53.02, ["Neon"] = 20.97, ["Neon|Fly"] = 92.53, ["Neon|Ride"] = 54.52, ["Neon|Fly|Ride"] = 147.15, ["Mega"] = 131.25, ["Mega|Fly"] = 237.21, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 301.26}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 866.25, ["Fly"] = 1088.56, ["Ride"] = 826.86, ["Fly|Ride"] = 1039.5, ["Neon"] = 4976.97, ["Neon|Ride"] = 5248.69, ["Neon|Fly|Ride"] = 4593.75, ["Mega"] = 16936.31, ["Mega|Ride"] = 53369.22, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 7.88, ["Fly"] = 28.49, ["Ride"] = 23.34, ["Fly|Ride"] = 87.94, ["Neon"] = 108.14, ["Neon|Ride"] = 113.27, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 363.09, ["Mega|Ride"] = 611.84, ["Mega|Fly|Ride"] = 601.33}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 94.5, ["Ride"] = 123.38, ["Fly|Ride"] = 183.75, ["Neon"] = 656.25, ["Neon|Ride"] = 635.13, ["Neon|Fly|Ride"] = 685.13, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 2394.38}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 28.35}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 17.84, ["Fly"] = 68.85, ["Ride"] = 55.13, ["Fly|Ride"] = 144.38, ["Neon"] = 85.71, ["Neon|Ride"] = 206.07, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 565.26, ["Mega|Ride"] = 723.19, ["Mega|Fly|Ride"] = 743.63}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 131.25, ["Ride"] = 183.75, ["Fly|Ride"] = 263.73, ["Neon"] = 367.5, ["Neon|Ride"] = 375.38, ["Neon|Fly|Ride"] = 590.63, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 124.69, ["Fly"] = 222.1, ["Ride"] = 162.14, ["Fly|Ride"] = 198.24, ["Neon"] = 438.38, ["Neon|Ride"] = 366.18, ["Neon|Fly|Ride"] = 613.41, ["Mega"] = 1378.13, ["Mega|Ride"] = 1391.25, ["Mega|Fly|Ride"] = 1623.79}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 43.32}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 59.07, ["Fly"] = 65.63, ["Ride"] = 59.07, ["Fly|Ride"] = 65.63, ["Neon"] = 608.49, ["Neon|Ride"] = 332.38, ["Neon|Fly|Ride"] = 308.44, ["Mega"] = 4233.04, ["Mega|Fly|Ride"] = 1286.25}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 6.57, ["Ride"] = 30.19, ["Fly|Ride"] = 85.32, ["Neon"] = 45.14, ["Neon|Ride"] = 70.94, ["Neon|Fly|Ride"] = 236.07, ["Mega"] = 196.89, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 156.19, ["Mega|Fly|Ride"] = 350.23}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 326.82, ["Fly"] = 420, ["Ride"] = 315, ["Fly|Ride"] = 406.88, ["Neon|Ride"] = 1155, ["Neon|Fly|Ride"] = 917.97, ["Mega|Fly|Ride"] = 4783.46}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 84, ["Fly"] = 99.75, ["Ride"] = 91.88, ["Fly|Ride"] = 134.65, ["Neon"] = 360.44, ["Neon|Ride"] = 364.16, ["Neon|Fly|Ride"] = 354.38, ["Mega"] = 1412.09, ["Mega|Ride"] = 1903.23, ["Mega|Fly|Ride"] = 1888.42}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 4027.16, ["Ride"] = 3961.13, ["Fly|Ride"] = 3017.43, ["Neon|Fly|Ride"] = 14818.22}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 42, ["Fly"] = 113.43, ["Ride"] = 51.19, ["Fly|Ride"] = 95.82, ["Neon"] = 392.44, ["Neon|Ride"] = 276.94, ["Neon|Fly|Ride"] = 376.85, ["Mega|Ride"] = 1644.96, ["Mega|Fly|Ride"] = 1722.14}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 74.82, ["Ride"] = 91.07, ["Fly|Ride"] = 142.54, ["Neon"] = 524.74, ["Neon|Ride"] = 794.49, ["Neon|Fly|Ride"] = 494.34, ["Mega"] = 6351.12, ["Mega|Ride"] = 1897.59, ["Mega|Fly|Ride"] = 1803.74}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 35.69, ["Fly"] = 78.45, ["Ride"] = 56.44, ["Fly|Ride"] = 104.99, ["Neon"] = 275.63, ["Neon|Fly"] = 280.88, ["Neon|Ride"] = 164.03, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 706.05, ["Mega|Fly|Ride"] = 671.08}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 8.4}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 52.5, ["Ride"] = 65.63, ["Fly|Ride"] = 116.52, ["Neon"] = 328.13, ["Neon|Ride"] = 474.47, ["Neon|Fly|Ride"] = 501.38, ["Mega|Ride"] = 1412.09, ["Mega|Fly|Ride"] = 1819.32}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 36.86}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 234.29, ["Ride"] = 953.95, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 3493.12, ["Neon|Fly|Ride"] = 1517.94}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 761.25, ["Ride"] = 774.38, ["Fly|Ride"] = 853.13, ["Neon|Ride"] = 3245.43, ["Neon|Fly|Ride"] = 3150, ["Mega|Fly|Ride"] = 11812.5}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 13.12}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 32.7, ["Fly"] = 52.42, ["Ride"] = 39.38, ["Fly|Ride"] = 71.04, ["Neon"] = 162.75, ["Neon|Ride"] = 168.32, ["Neon|Fly|Ride"] = 198.71, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 734.77}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 10.5}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5118.75, ["Fly"] = 5511.63, ["Ride"] = 6360.35, ["Fly|Ride"] = 4198.69, ["Neon|Fly|Ride"] = 10498.69, ["Mega|Fly|Ride"] = 35284.68}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 10.48, ["Fly"] = 74.52, ["Ride"] = 24.94, ["Fly|Ride"] = 44.62, ["Neon"] = 97.02, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 185.26, ["Mega"] = 420, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 566.02}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 12.95, ["Fly"] = 32.08, ["Ride"] = 32.82, ["Fly|Ride"] = 117.59, ["Neon"] = 85.32, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 231, ["Mega"] = 453.06, ["Mega|Ride"] = 520.8, ["Mega|Fly|Ride"] = 692.28}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 99.36, ["Fly"] = 139.21, ["Ride"] = 94.96, ["Fly|Ride"] = 140.44, ["Neon"] = 1414.12, ["Neon|Fly|Ride"] = 420, ["Mega"] = 4234.09}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 13.12, ["Ride"] = 35.44, ["Fly|Ride"] = 139.13, ["Neon"] = 53.82, ["Neon|Ride"] = 122.8, ["Neon|Fly|Ride"] = 111.9, ["Mega"] = 1412.09, ["Mega|Ride"] = 417.03, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 2098.69, ["Fly"] = 2445.27, ["Ride"] = 1837.5, ["Fly|Ride"] = 2008.13, ["Neon|Fly"] = 4735.28, ["Neon|Fly|Ride"] = 4265.63, ["Mega|Fly|Ride"] = 15079.32}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 34168.32, ["Fly"] = 35471.23, ["Ride"] = 35335.88, ["Fly|Ride"] = 22914.94, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 63261.38, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 197590.52}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 16.67, ["Fly"] = 393.75, ["Ride"] = 42, ["Fly|Ride"] = 63.74, ["Neon"] = 135.42, ["Neon|Ride"] = 174.57, ["Neon|Fly|Ride"] = 282.54, ["Mega"] = 692.28, ["Mega|Ride"] = 1102.5, ["Mega|Fly|Ride"] = 1270.24}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.63, ["Fly"] = 32.82, ["Ride"] = 34.13, ["Fly|Ride"] = 91.88, ["Neon"] = 17.07, ["Neon|Fly"] = 134.39, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 141.86, ["Mega"] = 124.69, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 253.32}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 23.51}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 6.57, ["Ride"] = 42, ["Fly|Ride"] = 111.57, ["Neon"] = 52.5, ["Neon|Ride"] = 105.25, ["Neon|Fly|Ride"] = 463.32, ["Mega"] = 393.75, ["Mega|Ride"] = 474.42, ["Mega|Fly|Ride"] = 494.34}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 695.33, ["Ride"] = 656.25, ["Fly|Ride"] = 783.49, ["Neon"] = 3009.71, ["Neon|Ride"] = 2540.46, ["Neon|Fly|Ride"] = 2513.44, ["Mega|Fly|Ride"] = 11069.98}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 997.5, ["Fly"] = 962.07, ["Ride"] = 909.33, ["Fly|Ride"] = 1097.57, ["Neon|Ride"] = 3669.9, ["Neon|Fly|Ride"] = 3530.17, ["Mega|Fly|Ride"] = 10585.19}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 23.63, ["Fly"] = 118.78, ["Ride"] = 64.15, ["Fly|Ride"] = 103.21, ["Neon"] = 120.86, ["Neon|Ride"] = 175.72, ["Neon|Fly|Ride"] = 220.5, ["Mega"] = 1023.61, ["Mega|Ride"] = 885.94}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 24.55}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 63.57, ["Fly"] = 106, ["Ride"] = 87.9, ["Fly|Ride"] = 108.14, ["Neon|Ride"] = 439.29, ["Neon|Fly|Ride"] = 389.82, ["Mega|Fly|Ride"] = 1598.63}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 65.63, ["Ride"] = 84, ["Fly|Ride"] = 111.67, ["Neon"] = 396.48, ["Neon|Ride"] = 324.98, ["Neon|Fly|Ride"] = 508.1, ["Mega"] = 2133.16, ["Mega|Fly|Ride"] = 1510.52}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.77, ["Fly"] = 32.78, ["Ride"] = 20.9, ["Fly|Ride"] = 53.69, ["Neon"] = 24.4, ["Neon|Fly"] = 317.14, ["Neon|Ride"] = 77.42, ["Neon|Fly|Ride"] = 124.92, ["Mega"] = 315, ["Mega|Fly"] = 338.73, ["Mega|Ride"] = 706.05, ["Mega|Fly|Ride"] = 371.44}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 78.75, ["Fly"] = 85.32, ["Ride"] = 91.88, ["Fly|Ride"] = 142.77, ["Neon"] = 368.91, ["Neon|Ride"] = 284.82, ["Neon|Fly|Ride"] = 301.26, ["Mega|Fly|Ride"] = 966.1}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.93, ["Ride"] = 37.11, ["Fly|Ride"] = 105, ["Neon"] = 36.05, ["Neon|Ride"] = 114.3, ["Neon|Fly|Ride"] = 141.86, ["Mega"] = 127.03, ["Mega|Fly"] = 988.67, ["Mega|Ride"] = 309.75, ["Mega|Fly|Ride"] = 387.19}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 11.82, ["Fly"] = 65.63, ["Ride"] = 28.64, ["Fly|Ride"] = 99.66, ["Neon"] = 65.63, ["Neon|Fly"] = 106.01, ["Neon|Ride"] = 126.93, ["Neon|Fly|Ride"] = 135.51, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 28.88, ["Ride"] = 44.62, ["Fly|Ride"] = 156.19, ["Neon"] = 210.97, ["Neon|Ride"] = 351.11, ["Mega"] = 706.05, ["Mega|Ride"] = 1161.57, ["Mega|Fly|Ride"] = 882.82}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 14.44, ["Fly"] = 85.53, ["Ride"] = 24.94, ["Fly|Ride"] = 82.69, ["Neon"] = 79.52, ["Neon|Fly"] = 424.04, ["Neon|Ride"] = 74.6, ["Neon|Fly|Ride"] = 182.07, ["Mega|Ride"] = 942.1, ["Mega|Fly|Ride"] = 945}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 7066.54, ["Ride"] = 5906.25, ["Fly|Ride"] = 5118.75, ["Neon"] = 31096.72, ["Neon|Fly|Ride"] = 23880.2}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 219.19, ["Fly"] = 283.01, ["Ride"] = 254.43, ["Fly|Ride"] = 287.27, ["Neon"] = 664.67, ["Neon|Ride"] = 656.3, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2149.88}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 20.15, ["Fly"] = 84.81, ["Ride"] = 71.04, ["Fly|Ride"] = 115.8, ["Neon"] = 59.07, ["Neon|Fly"] = 158.01, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 181.13, ["Mega"] = 286.12, ["Mega|Fly"] = 374.07, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 401.45}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.61, ["Fly"] = 42.41, ["Ride"] = 20.9, ["Fly|Ride"] = 47.53, ["Neon"] = 21, ["Neon|Ride"] = 79.41, ["Neon|Fly|Ride"] = 192.67, ["Mega"] = 179.82}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 40.69, ["Fly"] = 99.65, ["Ride"] = 84.82, ["Fly|Ride"] = 154.49, ["Neon"] = 113.45, ["Neon|Fly"] = 296.83, ["Neon|Ride"] = 141.86, ["Neon|Fly|Ride"] = 264.35, ["Mega"] = 418.69, ["Mega|Ride"] = 449.06, ["Mega|Fly|Ride"] = 531.25}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 18372.79, ["Ride"] = 15837.19, ["Fly|Ride"] = 11287.5, ["Neon|Fly|Ride"] = 23625, ["Mega|Fly|Ride"] = 91738.65}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 157.49, ["Ride"] = 191.63, ["Fly|Ride"] = 249.13, ["Neon"] = 845.94, ["Neon|Ride"] = 844.72, ["Neon|Fly|Ride"] = 988.67, ["Mega|Fly|Ride"] = 7057.16}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 78.4, ["Fly"] = 459.38, ["Ride"] = 52.49, ["Fly|Ride"] = 103.69, ["Neon|Fly"] = 475.11, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 295.32, ["Mega|Fly|Ride"] = 2032.37}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 7.87, ["Fly"] = 32.08, ["Ride"] = 21.25, ["Fly|Ride"] = 65.54, ["Neon"] = 65.63, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 101.07, ["Mega"] = 2540.46, ["Mega|Ride"] = 494.34, ["Mega|Fly|Ride"] = 484.47}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 379.31, ["Fly"] = 847.95, ["Ride"] = 420, ["Fly|Ride"] = 472.5, ["Neon"] = 1639.32, ["Neon|Ride"] = 1311.19, ["Neon|Fly|Ride"] = 1242.72, ["Mega|Ride"] = 4724.98, ["Mega|Fly|Ride"] = 4935}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 4.26, ["Fly"] = 87.9, ["Ride"] = 36.05, ["Neon"] = 23.67, ["Neon|Ride"] = 83.91, ["Neon|Fly|Ride"] = 240.3, ["Mega"] = 116.82, ["Mega|Ride"] = 168.77, ["Mega|Fly|Ride"] = 211.72}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 173.25, ["Fly"] = 393.75, ["Ride"] = 199.5, ["Fly|Ride"] = 282.19, ["Neon"] = 766.43, ["Neon|Ride"] = 681.19, ["Neon|Fly|Ride"] = 721.88, ["Mega|Ride"] = 2709.82, ["Mega|Fly|Ride"] = 2624.99}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.67, ["Fly"] = 22.8, ["Ride"] = 18.38, ["Fly|Ride"] = 34.04, ["Neon|Fly"] = 95.43, ["Neon|Ride"] = 93.17, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 786.19, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 10.5}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 57.75, ["Ride"] = 95.04, ["Fly|Ride"] = 525, ["Neon"] = 209.91, ["Neon|Fly"] = 1696.1, ["Neon|Ride"] = 421.31, ["Neon|Fly|Ride"] = 734.63, ["Mega"] = 1397.26, ["Mega|Ride"] = 1423.2, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 11.81, ["Fly"] = 61.78, ["Ride"] = 26.25, ["Fly|Ride"] = 84, ["Neon"] = 95.82, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 157.31, ["Mega"] = 480.41, ["Mega|Ride"] = 501.48, ["Mega|Fly|Ride"] = 557.82}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 14.33}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 22.32, ["Fly"] = 109.33, ["Ride"] = 63.5, ["Fly|Ride"] = 99.75, ["Neon"] = 170.62, ["Neon|Ride"] = 197.95, ["Neon|Fly|Ride"] = 240.3, ["Mega"] = 671.11, ["Mega|Ride"] = 776.96, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.93, ["Ride"] = 37.11, ["Fly|Ride"] = 131.25, ["Neon"] = 23.49, ["Neon|Ride"] = 138.68, ["Neon|Fly|Ride"] = 125.97, ["Mega"] = 109.72, ["Mega|Fly|Ride"] = 621.36}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 14.44, ["Fly"] = 42.41, ["Ride"] = 30.19, ["Fly|Ride"] = 97.13, ["Neon"] = 181.28, ["Neon|Ride"] = 147, ["Neon|Fly|Ride"] = 224.42, ["Mega"] = 704.99, ["Mega|Ride"] = 474.42, ["Mega|Fly|Ride"] = 759.94}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 431.4, ["Fly"] = 436.7, ["Ride"] = 328.13, ["Fly|Ride"] = 409.5, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 7763.2}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 31.5, ["Ride"] = 78.31, ["Fly|Ride"] = 142.35, ["Neon"] = 253.31, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 211.72, ["Mega"] = 704.99, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 45.83, ["Fly"] = 84.37, ["Ride"] = 62.99, ["Fly|Ride"] = 146.23, ["Neon"] = 197.65, ["Neon|Ride"] = 141.86, ["Neon|Fly|Ride"] = 409.66, ["Mega"] = 1270.24, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1100.88}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 23.63, ["Fly"] = 61.17, ["Ride"] = 74.79, ["Fly|Ride"] = 131.25, ["Neon"] = 100.82, ["Neon|Ride"] = 153.57, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 422.37, ["Mega|Ride"] = 405.57, ["Mega|Fly|Ride"] = 522.38}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 9843.75, ["Ride"] = 11402.21, ["Fly|Ride"] = 8386.88, ["Neon|Fly|Ride"] = 15828.9, ["Mega|Fly|Ride"] = 39372.9}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1884.67, ["Fly"] = 1837.5, ["Ride"] = 1706.25, ["Fly|Ride"] = 1745.63, ["Neon|Fly|Ride"] = 4987.5, ["Mega|Fly|Ride"] = 23100}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 282.54, ["Ride"] = 466.38, ["Fly|Ride"] = 446.25, ["Neon"] = 2120.12, ["Neon|Ride"] = 1731.76, ["Neon|Fly|Ride"] = 1623.79, ["Mega"] = 11859.83, ["Mega|Fly|Ride"] = 6630.58}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 10.5, ["Fly"] = 30.75, ["Ride"] = 23.62, ["Fly|Ride"] = 41.79, ["Neon"] = 113.45, ["Neon|Ride"] = 105.27, ["Neon|Fly|Ride"] = 105, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 4.25, ["Fly"] = 39.38, ["Ride"] = 26.25, ["Fly|Ride"] = 124.69, ["Neon"] = 28.88, ["Neon|Ride"] = 47.46, ["Mega"] = 143.73, ["Mega|Ride"] = 174.57, ["Mega|Fly|Ride"] = 239.24}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 38.07, ["Fly"] = 33.71, ["Ride"] = 48.69, ["Fly|Ride"] = 85.32, ["Neon"] = 188.71, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 164.07, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.72, ["Fly"] = 17.8, ["Ride"] = 18.11, ["Fly|Ride"] = 38.75, ["Neon"] = 26.25, ["Neon|Fly"] = 55.69, ["Neon|Ride"] = 42.34, ["Neon|Fly|Ride"] = 94.59, ["Mega"] = 360.94, ["Mega|Ride"] = 296.4, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 295.8, ["Fly"] = 320.24, ["Ride"] = 322.17, ["Fly|Ride"] = 341.25, ["Neon|Ride"] = 1779.23, ["Neon|Fly|Ride"] = 1366.17, ["Mega|Fly|Ride"] = 7409.64}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 30.19, ["Fly"] = 48.19, ["Ride"] = 31.82, ["Fly|Ride"] = 93.3, ["Neon"] = 142.54, ["Neon|Fly"] = 283.04, ["Neon|Ride"] = 141.8, ["Neon|Fly|Ride"] = 182.65, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 11.8, ["Fly"] = 24.39, ["Ride"] = 24.39, ["Fly|Ride"] = 43.32, ["Neon"] = 142.06, ["Neon|Fly"] = 136.5, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 529.27, ["Mega|Ride"] = 583.26, ["Mega|Fly|Ride"] = 1128.75}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 566.08, ["Fly"] = 787.5, ["Ride"] = 459.38, ["Fly|Ride"] = 479.16, ["Neon|Ride"] = 2752.17, ["Mega|Fly|Ride"] = 8619.19}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1023.75, ["Fly"] = 1250.72, ["Ride"] = 1173.24, ["Fly|Ride"] = 1177.31, ["Neon"] = 4961.08, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 16922.55}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 98.44, ["Fly"] = 103.34, ["Ride"] = 87.9, ["Fly|Ride"] = 126.16, ["Neon"] = 504.6, ["Neon|Ride"] = 416.06, ["Neon|Fly|Ride"] = 422.63, ["Mega|Fly|Ride"] = 1836.19}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 142.06, ["Fly"] = 206.67, ["Ride"] = 168, ["Fly|Ride"] = 224.44, ["Neon"] = 656.25, ["Neon|Fly"] = 890.46, ["Neon|Ride"] = 704.55, ["Neon|Fly|Ride"] = 607.6, ["Mega|Ride"] = 8596.88, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 21.25, ["Fly"] = 131.25, ["Ride"] = 41.99, ["Fly|Ride"] = 283.04, ["Neon"] = 183.75, ["Neon|Fly"] = 423.42, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 338.73, ["Mega|Ride"] = 1412.09, ["Mega|Fly|Ride"] = 870.53}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 142.05, ["Ride"] = 210.74, ["Fly|Ride"] = 597.19, ["Neon"] = 1060.07, ["Mega|Fly|Ride"] = 2957.85}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2220.75, ["Fly"] = 2535.37, ["Ride"] = 2415, ["Fly|Ride"] = 2537.79, ["Neon|Fly|Ride"] = 7197.94, ["Mega|Fly|Ride"] = 48691.86}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 57.14, ["Ride"] = 49.56, ["Fly|Ride"] = 156.9, ["Neon"] = 291.54, ["Neon|Fly|Ride"] = 312.29, ["Mega"] = 2110.7, ["Mega|Ride"] = 2328.76, ["Mega|Fly|Ride"] = 1750.8}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 652.36, ["Fly"] = 675.94, ["Ride"] = 557.82, ["Fly|Ride"] = 610.32, ["Neon|Ride"] = 1266.57, ["Neon|Fly|Ride"] = 1284.94, ["Mega|Fly|Ride"] = 2947.77}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 42, ["Fly"] = 60.38, ["Ride"] = 52.5, ["Fly|Ride"] = 102.38, ["Neon"] = 236.25, ["Neon|Ride"] = 367.71, ["Neon|Fly|Ride"] = 221.8, ["Mega|Fly|Ride"] = 1456.88}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.71, ["Fly"] = 19.69, ["Ride"] = 20.88, ["Fly|Ride"] = 40.69, ["Neon"] = 21, ["Neon|Fly"] = 57.26, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 123.38, ["Mega|Fly"] = 251.94, ["Mega|Ride"] = 141.86, ["Mega|Fly|Ride"] = 222.74}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 20.9, ["Ride"] = 52.47, ["Fly|Ride"] = 131.25, ["Neon"] = 245.96, ["Neon|Ride"] = 266.76, ["Neon|Fly|Ride"] = 312.29, ["Mega|Ride"] = 1412.09, ["Mega|Fly|Ride"] = 948.81}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 615.55, ["Fly"] = 899.07, ["Ride"] = 574.88, ["Fly|Ride"] = 580.96, ["Neon"] = 1980.2, ["Neon|Ride"] = 1771.88, ["Neon|Fly|Ride"] = 1548.75, ["Mega|Fly|Ride"] = 5250}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 551.25, ["Ride"] = 525, ["Fly|Ride"] = 672.28, ["Neon"] = 5300.28, ["Neon|Ride"] = 4068.75, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 12650.89}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 23.78, ["Fly"] = 44.54, ["Ride"] = 24.39, ["Fly|Ride"] = 44.09, ["Neon"] = 99.66, ["Neon|Ride"] = 99.52, ["Neon|Fly|Ride"] = 87.8, ["Mega"] = 787.5, ["Mega|Fly|Ride"] = 580.08}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 6.17, ["Ride"] = 22.32, ["Fly|Ride"] = 63.41, ["Neon"] = 45.93, ["Neon|Ride"] = 78.35, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 1691.52, ["Mega|Ride"] = 447.78, ["Mega|Fly|Ride"] = 387.29}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.56, ["Ride"] = 36.05, ["Fly|Ride"] = 91.88, ["Neon"] = 19.69, ["Neon|Fly"] = 317.01, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 137.63, ["Mega|Fly"] = 407.99, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 330.74}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 39.38, ["Fly"] = 59.06, ["Ride"] = 44.62, ["Fly|Ride"] = 91.88, ["Neon"] = 237.56, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 226.53, ["Mega|Fly|Ride"] = 708.65}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 58.88, ["Ride"] = 91.88, ["Fly|Ride"] = 449.61, ["Neon"] = 267.15, ["Neon|Ride"] = 407.69, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1409.96, ["Mega|Ride"] = 1551.8, ["Mega|Fly|Ride"] = 1552.87}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 14.43, ["Fly"] = 65.63, ["Ride"] = 37.7, ["Fly|Ride"] = 89.27, ["Neon"] = 110.92, ["Neon|Fly"] = 150.86, ["Neon|Ride"] = 103.68, ["Neon|Fly|Ride"] = 170.52, ["Mega"] = 400.14, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 635.13}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 28.3, ["Fly"] = 65.05, ["Ride"] = 36.75, ["Fly|Ride"] = 78.64, ["Neon"] = 410.26, ["Neon|Ride"] = 188.43, ["Neon|Fly|Ride"] = 224.42, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1185.99}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.84, ["Fly"] = 31.49, ["Ride"] = 15.91, ["Fly|Ride"] = 39.37, ["Neon"] = 31.82, ["Neon|Ride"] = 37.7, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 184.21, ["Mega|Ride"] = 254.05, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 3.93, ["Fly"] = 36.05, ["Ride"] = 28.64, ["Fly|Ride"] = 79.59, ["Neon"] = 26.17, ["Neon|Fly"] = 158.95, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 239.24, ["Mega|Fly"] = 480.58, ["Mega|Ride"] = 285.87, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 47.78, ["Fly"] = 60.3, ["Ride"] = 55.13, ["Fly|Ride"] = 80.57, ["Neon"] = 228.99, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 221.83, ["Neon|Fly|Ride"] = 223.13, ["Mega|Fly|Ride"] = 918.64}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1903.13, ["Fly"] = 2224.81, ["Ride"] = 1769.25, ["Fly|Ride"] = 1798.13, ["Neon|Ride"] = 5291.55, ["Neon|Fly|Ride"] = 3916.5, ["Mega|Fly|Ride"] = 16231.35}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 446.25, ["Fly"] = 499.38, ["Ride"] = 492.72, ["Fly|Ride"] = 551.25, ["Neon"] = 3167.7, ["Neon|Ride"] = 3105.72, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 9708.75}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 259.93, ["Fly"] = 283.01, ["Ride"] = 262.5, ["Fly|Ride"] = 367.5, ["Neon"] = 1202.53, ["Neon|Ride"] = 1179.94, ["Neon|Fly|Ride"] = 1518.99, ["Mega"] = 7409.64, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 39.37}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 24.94, ["Fly"] = 65.63, ["Ride"] = 70.91, ["Fly|Ride"] = 103.69, ["Neon"] = 206.07, ["Neon|Ride"] = 253.95, ["Neon|Fly|Ride"] = 423.42, ["Mega|Ride"] = 1693.64, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 33917.67, ["Fly"] = 23625, ["Ride"] = 34781.25, ["Fly|Ride"] = 18373.69, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 309.56, ["Fly"] = 317.12, ["Ride"] = 312.15, ["Fly|Ride"] = 370.59, ["Neon"] = 1060.07, ["Neon|Fly"] = 1615.34, ["Neon|Ride"] = 1023.23, ["Neon|Fly|Ride"] = 996.19, ["Mega"] = 6351.12, ["Mega|Ride"] = 6641.52, ["Mega|Fly|Ride"] = 3257.63}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 127.1, ["Fly"] = 142.05, ["Ride"] = 136.5, ["Fly|Ride"] = 154.88, ["Neon|Ride"] = 1038.42, ["Neon|Fly|Ride"] = 1058.53, ["Mega|Fly|Ride"] = 4220.33}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 125.97, ["Fly"] = 257.25, ["Ride"] = 137.82, ["Fly|Ride"] = 146.3, ["Neon|Ride"] = 740.98, ["Neon|Fly|Ride"] = 643.13, ["Mega"] = 14114.3, ["Mega|Fly|Ride"] = 2569.04}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 18.38, ["Fly"] = 65.73, ["Ride"] = 32.86, ["Fly|Ride"] = 98.44, ["Neon"] = 127.22, ["Neon|Ride"] = 135.19, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 706.05, ["Mega|Fly|Ride"] = 649.94}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 5055.39, ["Ride"] = 4346.24, ["Fly|Ride"] = 4588.66, ["Neon|Ride"] = 16936.31, ["Neon|Fly|Ride"] = 17629.64, ["Mega|Fly|Ride"] = 70568.28}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 26.25, ["Fly"] = 48.57, ["Ride"] = 26.24, ["Fly|Ride"] = 52.5, ["Neon"] = 333.94, ["Neon|Ride"] = 221.83, ["Neon|Fly|Ride"] = 157.5, ["Mega|Fly|Ride"] = 685.13}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 32.08, ["Fly"] = 142.05, ["Ride"] = 47.25, ["Fly|Ride"] = 107.63, ["Neon"] = 262.5, ["Neon|Fly"] = 1414.12, ["Neon|Ride"] = 278.41, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1050.07}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 616.88, ["Fly"] = 805.55, ["Ride"] = 616.88, ["Fly|Ride"] = 656.25, ["Neon"] = 1701, ["Neon|Ride"] = 1605.1, ["Neon|Fly|Ride"] = 1483.13, ["Mega|Fly|Ride"] = 5249.99}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 12.73, ["Fly"] = 28.88, ["Ride"] = 26.14, ["Fly|Ride"] = 39.38, ["Neon"] = 98.44, ["Neon|Fly"] = 158.95, ["Neon|Ride"] = 97.39, ["Neon|Fly|Ride"] = 99.52, ["Mega"] = 776.96, ["Mega|Fly|Ride"] = 523.68}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 13.54, ["Fly"] = 28.64, ["Ride"] = 78.46, ["Fly|Ride"] = 91.88, ["Neon"] = 91.88, ["Neon|Ride"] = 74.82, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 379.53}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 102.38, ["Fly"] = 317.12, ["Ride"] = 154.88, ["Fly|Ride"] = 283.04, ["Neon"] = 678.45, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 706.05, ["Mega|Fly|Ride"] = 2193.19}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 25.66, ["Fly"] = 142.05, ["Ride"] = 45.94, ["Fly|Ride"] = 158.57, ["Neon"] = 99.1, ["Neon|Ride"] = 189, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 281.81, ["Mega|Fly"] = 800.63, ["Mega|Ride"] = 296.68, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3150, ["Ride"] = 3543.75, ["Fly|Ride"] = 3281.25, ["Neon"] = 13125, ["Neon|Ride"] = 9851.65, ["Neon|Fly|Ride"] = 8515.5, ["Mega"] = 63511.12, ["Mega|Fly|Ride"] = 33207.51}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 45.94, ["Fly"] = 115.5, ["Ride"] = 63, ["Fly|Ride"] = 142.06, ["Neon"] = 190.05, ["Neon|Ride"] = 206.4, ["Neon|Fly|Ride"] = 396.19, ["Mega|Ride"] = 952.68, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7218.75, ["Ride"] = 7400.6, ["Fly|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 14306.25, ["Mega|Fly|Ride"] = 63441.28}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.63, ["Fly"] = 23.34, ["Ride"] = 16.3, ["Fly|Ride"] = 31.49, ["Neon"] = 22.32, ["Neon|Fly"] = 91.8, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 67.76, ["Mega"] = 281.58, ["Mega|Fly|Ride"] = 342.98}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 20.62, ["Fly"] = 32.08, ["Ride"] = 27.46, ["Fly|Ride"] = 48.57, ["Neon"] = 71.28, ["Neon|Ride"] = 559.37, ["Neon|Fly|Ride"] = 167.26, ["Mega|Ride"] = 1247.55, ["Mega|Fly|Ride"] = 927.94}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.89}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 15.91, ["Ride"] = 27.56, ["Fly|Ride"] = 127.22, ["Neon"] = 158.76, ["Neon|Ride"] = 127.5, ["Neon|Fly|Ride"] = 142.92, ["Mega"] = 704.99, ["Mega|Ride"] = 986.55, ["Mega|Fly|Ride"] = 870.53}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 19.09, ["Fly"] = 262.5, ["Ride"] = 131.25, ["Fly|Ride"] = 142.06, ["Neon"] = 106.01, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 281.48, ["Mega"] = 840, ["Mega|Ride"] = 948.81, ["Mega|Fly|Ride"] = 791.06}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 9.19, ["Fly"] = 24.94, ["Ride"] = 19.69, ["Fly|Ride"] = 34.9, ["Neon"] = 141.61, ["Neon|Ride"] = 111.49, ["Neon|Fly|Ride"] = 117.95, ["Mega"] = 820.32, ["Mega|Ride"] = 591.82, ["Mega|Fly|Ride"] = 635.13}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8394.59}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 3148.69}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 23.24}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 156.9, ["Fly"] = 174.57, ["Ride"] = 189, ["Fly|Ride"] = 243.83, ["Neon|Ride"] = 706.05}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 22.32, ["Fly"] = 133.58, ["Ride"] = 45.94, ["Fly|Ride"] = 105, ["Neon"] = 125.92, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 458.99, ["Mega|Ride"] = 813.75, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 10.39}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 10.5, ["Neon"] = 82.7, ["Neon|Ride"] = 84.69, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2572.5}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 226.87, ["Ride"] = 236.25, ["Fly|Ride"] = 10498.95, ["Neon"] = 918.75, ["Neon|Ride"] = 706.05, ["Neon|Fly|Ride"] = 1079.71, ["Mega|Ride"] = 3515.35, ["Mega|Fly|Ride"] = 3001.98}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 105, ["Ride"] = 179.82, ["Fly|Ride"] = 283.04, ["Neon"] = 707.07, ["Neon|Ride"] = 635.13, ["Neon|Fly|Ride"] = 603.75, ["Mega"] = 3440.2, ["Mega|Ride"] = 2398.62, ["Mega|Fly|Ride"] = 2331.93}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 170.63, ["Ride"] = 164.07, ["Fly|Ride"] = 221.82, ["Neon"] = 799.32, ["Neon|Ride"] = 840, ["Neon|Fly|Ride"] = 842.03, ["Mega"] = 4657.49, ["Mega|Fly|Ride"] = 3169.23}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1425.12, ["Fly"] = 2543.84, ["Ride"] = 1216.71, ["Fly|Ride"] = 1292.69, ["Neon"] = 5371.31, ["Neon|Ride"] = 4200, ["Neon|Fly|Ride"] = 4462.5, ["Mega|Fly|Ride"] = 28463.58}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 18.38, ["Fly"] = 82.69, ["Ride"] = 39.38, ["Fly|Ride"] = 86.63, ["Neon"] = 142.06, ["Neon|Ride"] = 298.93, ["Neon|Fly|Ride"] = 317.81, ["Mega"] = 845.77, ["Mega|Fly|Ride"] = 917.75}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 614.77, ["Fly"] = 2100, ["Ride"] = 756.76, ["Fly|Ride"] = 791.04, ["Neon|Ride"] = 1552.87, ["Neon|Fly|Ride"] = 1595.21}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 65.63}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 14.44, ["Fly"] = 393.75, ["Ride"] = 43.32, ["Fly|Ride"] = 98.44, ["Neon"] = 90.57, ["Neon|Ride"] = 141.86, ["Neon|Fly|Ride"] = 494.34, ["Mega"] = 362.96, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 846.83}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 7.88, ["Fly"] = 131.25, ["Ride"] = 27.57, ["Fly|Ride"] = 52.5, ["Neon"] = 61.38, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 226.53, ["Mega"] = 423.42, ["Mega|Ride"] = 485.63, ["Mega|Fly|Ride"] = 466.81}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 59.07}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 21, ["Fly"] = 108.92, ["Ride"] = 32.81, ["Fly|Ride"] = 65.63, ["Neon"] = 177.19, ["Neon|Ride"] = 158.8, ["Neon|Fly|Ride"] = 601.38, ["Mega"] = 820.37, ["Mega|Ride"] = 846.83, ["Mega|Fly|Ride"] = 1270.24}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 27.57, ["Fly"] = 48.77, ["Ride"] = 30.19, ["Fly|Ride"] = 63.62, ["Neon|Ride"] = 141.86, ["Neon|Fly|Ride"] = 336, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 5563.69, ["Fly"] = 11287.14, ["Ride"] = 5495.44, ["Fly|Ride"] = 4921.88, ["Neon|Ride"] = 15526.38, ["Neon|Fly|Ride"] = 10066.88, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 8.49, ["Fly"] = 34.13, ["Ride"] = 31.5, ["Fly|Ride"] = 99.66, ["Neon"] = 65.6, ["Neon|Ride"] = 73.5, ["Neon|Fly|Ride"] = 353.56, ["Mega"] = 531.34, ["Mega|Ride"] = 282.63, ["Mega|Fly|Ride"] = 417.38}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 26.25}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 115.5, ["Fly"] = 375.23, ["Ride"] = 144.38, ["Fly|Ride"] = 234.29, ["Neon"] = 418.69, ["Neon|Ride"] = 481.69, ["Neon|Fly|Ride"] = 459.38, ["Mega|Ride"] = 4234.09, ["Mega|Fly|Ride"] = 1903.13}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 65.63, ["Ride"] = 105, ["Fly|Ride"] = 153.57, ["Neon"] = 315, ["Neon|Ride"] = 354.38, ["Neon|Fly|Ride"] = 511.88, ["Mega|Ride"] = 1623.79, ["Mega|Fly|Ride"] = 1799.49}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 20.74, ["Fly"] = 72.16, ["Ride"] = 30.19, ["Fly|Ride"] = 63.62, ["Neon"] = 122.98, ["Neon|Ride"] = 110.25, ["Neon|Fly|Ride"] = 164.06, ["Mega"] = 692.28, ["Mega|Ride"] = 889.18, ["Mega|Fly|Ride"] = 656.22}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 4.26, ["Fly"] = 49.76, ["Ride"] = 22.32, ["Fly|Ride"] = 71.28, ["Neon"] = 19.59, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 113.27, ["Mega"] = 129.94, ["Mega|Fly"] = 7034.11, ["Mega|Ride"] = 156.68, ["Mega|Fly|Ride"] = 263.8}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 12.74, ["Fly"] = 31.5, ["Ride"] = 28.64, ["Fly|Ride"] = 74.82, ["Neon"] = 78.46, ["Neon|Ride"] = 82.69, ["Neon|Fly|Ride"] = 127.03, ["Mega"] = 371.56, ["Mega|Ride"] = 474.42, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 23.62, ["Fly"] = 28.44, ["Ride"] = 24.81, ["Fly|Ride"] = 42, ["Neon"] = 208.71, ["Neon|Ride"] = 138.96, ["Neon|Fly|Ride"] = 109.05, ["Mega|Fly|Ride"] = 632.38}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 210}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 31.5, ["Ride"] = 96.47, ["Fly|Ride"] = 196.88, ["Neon"] = 142.06, ["Neon|Ride"] = 328.13, ["Mega"] = 1192.97, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1528.51}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 196.87, ["Ride"] = 317.14, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 820.32, ["Neon|Fly|Ride"] = 744.16}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 51.19, ["Fly"] = 211.99, ["Ride"] = 100.79, ["Fly|Ride"] = 206.69, ["Neon"] = 210.97, ["Neon|Fly"] = 353.56, ["Neon|Ride"] = 211.72, ["Neon|Fly|Ride"] = 420, ["Mega"] = 1014.03, ["Mega|Ride"] = 1975.21, ["Mega|Fly|Ride"] = 1156.02}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 708.75, ["Fly"] = 780.94, ["Ride"] = 727.01, ["Fly|Ride"] = 721.88, ["Neon|Ride"] = 3281.25, ["Neon|Fly|Ride"] = 2512.17, ["Mega|Fly|Ride"] = 7875}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 328.13, ["Ride"] = 424.04, ["Fly|Ride"] = 410.26, ["Neon"] = 1555.12, ["Neon|Ride"] = 1582.31, ["Neon|Fly|Ride"] = 1352.21, ["Mega"] = 8327.38, ["Mega|Fly|Ride"] = 7087.5}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 70.88}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 3.56}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 9.19, ["Fly"] = 31.48, ["Ride"] = 24.81, ["Fly|Ride"] = 47.53, ["Neon"] = 77.95, ["Neon|Fly"] = 230.99, ["Neon|Ride"] = 97.5, ["Neon|Fly|Ride"] = 135.23, ["Mega"] = 418.14, ["Mega|Ride"] = 453.06, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 319.94, ["Fly"] = 989.99, ["Ride"] = 350.36, ["Fly|Ride"] = 431.06, ["Neon"] = 954.07, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 990.74, ["Mega|Fly|Ride"] = 3691.07}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 14.44}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 106.01, ["Fly"] = 590.63, ["Ride"] = 193.35, ["Fly|Ride"] = 273, ["Neon"] = 525, ["Neon|Fly"] = 1696.1, ["Neon|Ride"] = 630.03, ["Neon|Fly|Ride"] = 551.25, ["Mega"] = 2822.03, ["Mega|Ride"] = 1977.32, ["Mega|Fly|Ride"] = 1926.79}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 149.63, ["Ride"] = 150.94, ["Fly|Ride"] = 283.04, ["Neon|Fly"] = 995.42, ["Neon|Ride"] = 889.18}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 6.56, ["Ride"] = 28.58, ["Fly|Ride"] = 205.67, ["Neon"] = 39.38, ["Neon|Ride"] = 74.08, ["Mega"] = 226.53, ["Mega|Ride"] = 474.42, ["Mega|Fly|Ride"] = 393.79}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 15.74, ["Fly"] = 62.99, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 98.98, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 142.34, ["Mega|Ride"] = 536.68, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 19.69, ["Fly"] = 131.25, ["Ride"] = 62.54, ["Fly|Ride"] = 141.39, ["Neon"] = 169.63, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 413.74, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 494.34}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 6.29, ["Fly"] = 262.5, ["Ride"] = 40.4, ["Fly|Ride"] = 111.18, ["Neon"] = 25.4, ["Neon|Ride"] = 62.25, ["Neon|Fly|Ride"] = 179.82, ["Mega"] = 130.6, ["Mega|Ride"] = 150.33, ["Mega|Fly|Ride"] = 226.12}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 273, ["Fly"] = 918.75, ["Ride"] = 301.88, ["Fly|Ride"] = 424.04, ["Neon"] = 1484.09, ["Neon|Ride"] = 1214.07, ["Neon|Fly|Ride"] = 1424.07}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 103.69, ["Fly"] = 1050, ["Ride"] = 177.56, ["Fly|Ride"] = 223.11, ["Neon"] = 456.74, ["Neon|Ride"] = 459.37, ["Neon|Fly|Ride"] = 539.27, ["Mega"] = 1792.88, ["Mega|Ride"] = 1945.02, ["Mega|Fly|Ride"] = 1693.26}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 65.63, ["Fly"] = 167.45, ["Ride"] = 84, ["Fly|Ride"] = 128.63, ["Neon"] = 296.83, ["Neon|Ride"] = 308.44, ["Neon|Fly|Ride"] = 353.56, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 19.69, ["Ride"] = 58.24, ["Fly|Ride"] = 283.04, ["Neon|Ride"] = 602.58, ["Neon|Fly|Ride"] = 493.28, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 14.44, ["Fly"] = 75.62, ["Ride"] = 40.69, ["Fly|Ride"] = 97.54, ["Neon"] = 91.88, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 413.44, ["Mega|Fly"] = 525, ["Mega|Ride"] = 422.63, ["Mega|Fly|Ride"] = 444.36}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.93, ["Fly"] = 32.88, ["Ride"] = 28.52, ["Fly|Ride"] = 65.63, ["Neon"] = 18.62, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 117.51, ["Mega"] = 102.37, ["Mega|Ride"] = 158.94, ["Mega|Fly|Ride"] = 229.69}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 951.57, ["Fly"] = 1144.74, ["Ride"] = 984.38, ["Fly|Ride"] = 1036.88, ["Neon"] = 3007.12, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 8925}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 360.94, ["Fly"] = 422.92, ["Ride"] = 413.1, ["Fly|Ride"] = 393.75, ["Neon"] = 1707.77, ["Neon|Ride"] = 1680, ["Neon|Fly|Ride"] = 1376.09, ["Mega"] = 10585.19, ["Mega|Fly|Ride"] = 5766.83}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 95.82, ["Ride"] = 126.16, ["Fly|Ride"] = 181.36, ["Neon"] = 282.19, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 353.56, ["Mega"] = 1443.75, ["Mega|Ride"] = 1637.55, ["Mega|Fly|Ride"] = 1651.3}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 288.35, ["Fly"] = 339.2, ["Ride"] = 275.63, ["Fly|Ride"] = 308.44, ["Neon|Ride"] = 1016.19, ["Neon|Fly|Ride"] = 1050.07, ["Mega"] = 10585.19, ["Mega|Fly|Ride"] = 4199.99}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 24.94, ["Fly"] = 142.05, ["Ride"] = 31.5, ["Fly|Ride"] = 78.75, ["Neon"] = 157.49, ["Neon|Ride"] = 132.57, ["Neon|Fly|Ride"] = 156.68, ["Mega"] = 1412.09, ["Mega|Ride"] = 762.15, ["Mega|Fly|Ride"] = 618.87}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 217.88, ["Ride"] = 258.93, ["Fly|Ride"] = 301.77, ["Neon"] = 1584.98, ["Neon|Ride"] = 1692.58, ["Neon|Fly|Ride"] = 1269.18, ["Mega"] = 5250}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 110.25, ["Fly"] = 126, ["Ride"] = 65.63, ["Neon"] = 424.04, ["Neon|Ride"] = 505.99, ["Neon|Fly|Ride"] = 565.06, ["Mega|Fly|Ride"] = 1397.82}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1312.5, ["Ride"] = 1378.13, ["Fly|Ride"] = 1351.88, ["Neon|Fly|Ride"] = 6179.64, ["Mega"] = 50808.91, ["Mega|Fly|Ride"] = 24557.65}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 10.5, ["Fly"] = 45.6, ["Ride"] = 42.41, ["Fly|Ride"] = 87.24, ["Neon"] = 39.37, ["Neon|Fly"] = 165.11, ["Neon|Ride"] = 84.69, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 253.32, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 388.36}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 49.88, ["Ride"] = 84, ["Fly|Ride"] = 161.44, ["Neon"] = 315, ["Neon|Ride"] = 254.05, ["Neon|Fly|Ride"] = 549.39, ["Mega"] = 2625, ["Mega|Ride"] = 1150.63, ["Mega|Fly|Ride"] = 1456.88}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 80.07, ["Fly"] = 91.88, ["Ride"] = 78.75, ["Fly|Ride"] = 85.32, ["Neon|Ride"] = 423.42, ["Neon|Fly|Ride"] = 367.5, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 1575, ["Ride"] = 918.75, ["Fly|Ride"] = 1049.99, ["Neon|Fly|Ride"] = 4199.99, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 441, ["Fly"] = 845.84, ["Ride"] = 566.02, ["Fly|Ride"] = 525, ["Neon|Fly|Ride"] = 1987.92, ["Mega|Fly|Ride"] = 14231.8}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 118.13, ["Fly"] = 317.12, ["Ride"] = 145.27, ["Fly|Ride"] = 219.34, ["Neon"] = 475.11, ["Neon|Ride"] = 433.13, ["Neon|Fly|Ride"] = 507.05, ["Mega"] = 4234.09, ["Mega|Ride"] = 1806.91, ["Mega|Fly|Ride"] = 2117.05}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 10.48, ["Fly"] = 21.21, ["Ride"] = 23.63, ["Fly|Ride"] = 61.49, ["Neon"] = 76.34, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 761.25, ["Mega|Ride"] = 634.9, ["Mega|Fly|Ride"] = 1015.13}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 39.38, ["Fly"] = 71.04, ["Ride"] = 48.57, ["Fly|Ride"] = 94.4, ["Neon"] = 204.75, ["Neon|Fly"] = 422.98, ["Neon|Ride"] = 223.01, ["Neon|Fly|Ride"] = 210, ["Mega"] = 1835.48, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 850, ["Ride"] = 867.81, ["Fly|Ride"] = 896.38, ["Neon"] = 2869.58, ["Neon|Ride"] = 2828.44, ["Neon|Fly|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 24699.49}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 887.24}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4921.88, ["Ride"] = 4608.19, ["Fly|Ride"] = 4458.56, ["Neon|Ride"] = 30338.22, ["Neon|Fly|Ride"] = 21170.38, ["Mega|Fly|Ride"] = 90327.65}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 157.5, ["Fly"] = 283.01, ["Ride"] = 159.17, ["Fly|Ride"] = 424.04, ["Neon"] = 1696.1, ["Neon|Ride"] = 846.83, ["Neon|Fly|Ride"] = 1412.09, ["Mega"] = 5927.73, ["Mega|Fly|Ride"] = 5646.16}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 72.19, ["Fly"] = 283.01, ["Ride"] = 77.44, ["Fly|Ride"] = 336, ["Neon"] = 423.26, ["Neon|Ride"] = 505.99, ["Neon|Fly|Ride"] = 988.67, ["Mega|Fly|Ride"] = 2838.13}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 10.61, ["Fly"] = 56.85, ["Ride"] = 32.88, ["Fly|Ride"] = 105, ["Neon"] = 98.44, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 704.99, ["Mega|Ride"] = 562.09, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 18.63, ["Fly"] = 28.46, ["Ride"] = 26.25, ["Fly|Ride"] = 45.94, ["Neon"] = 91.88, ["Neon|Ride"] = 113.27, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 840.48}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 19.69, ["Fly"] = 70.93, ["Ride"] = 30.18, ["Fly|Ride"] = 65.63, ["Neon"] = 125.9, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 203.44, ["Mega|Ride"] = 565.26, ["Mega|Fly|Ride"] = 698.25}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.89, ["Fly"] = 57.26, ["Ride"] = 22.32, ["Fly|Ride"] = 38.07, ["Neon"] = 50.9, ["Neon|Ride"] = 40.24, ["Neon|Fly|Ride"] = 141.86, ["Mega"] = 695.67, ["Mega|Ride"] = 239.24, ["Mega|Fly|Ride"] = 316.67}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 27.56, ["Ride"] = 57.26, ["Fly|Ride"] = 169.32, ["Neon"] = 154.79, ["Neon|Fly"] = 848.06, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 251.06, ["Mega"] = 698.63, ["Mega|Ride"] = 635.13, ["Mega|Fly|Ride"] = 857.42}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 275.52, ["Fly"] = 340.87, ["Ride"] = 301.88, ["Fly|Ride"] = 329.15, ["Neon"] = 1050, ["Neon|Fly"] = 954.07, ["Neon|Ride"] = 708.75, ["Neon|Fly|Ride"] = 735, ["Mega"] = 6562.5, ["Mega|Fly|Ride"] = 2961.75}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.63, ["Fly"] = 20.68, ["Ride"] = 13.13, ["Fly|Ride"] = 36.75, ["Neon"] = 21, ["Neon|Ride"] = 28.25, ["Neon|Fly|Ride"] = 63.41, ["Mega"] = 223.13, ["Mega|Ride"] = 193.73, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 39.37, ["Fly"] = 98.44, ["Ride"] = 65.62, ["Fly|Ride"] = 111.35, ["Neon"] = 137.82, ["Neon|Fly"] = 315, ["Neon|Ride"] = 177.19, ["Neon|Fly|Ride"] = 249.37, ["Mega"] = 564.27, ["Mega|Ride"] = 547.31, ["Mega|Fly|Ride"] = 528.94}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 812.03, ["Fly"] = 1413.96, ["Ride"] = 782.96, ["Fly|Ride"] = 817.57, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1526.44, ["Mega|Fly|Ride"] = 3923.07}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 31.49, ["Fly"] = 107.63, ["Ride"] = 42, ["Fly|Ride"] = 87.94, ["Neon|Fly"] = 475.11, ["Neon|Ride"] = 177.18, ["Neon|Fly|Ride"] = 210, ["Mega"] = 1575, ["Mega|Ride"] = 1129.46, ["Mega|Fly|Ride"] = 654.93}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 249.38, ["Fly"] = 341.25, ["Ride"] = 236.25, ["Fly|Ride"] = 315.88, ["Neon"] = 805.65, ["Neon|Ride"] = 930.45, ["Neon|Fly|Ride"] = 945, ["Mega|Fly|Ride"] = 5218.52}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 148.42, ["Fly"] = 180.21, ["Ride"] = 137.44, ["Fly|Ride"] = 159.17, ["Neon"] = 636.05, ["Neon|Fly"] = 644.53, ["Neon|Ride"] = 556.8, ["Neon|Fly|Ride"] = 485.63, ["Mega|Fly|Ride"] = 2255.72}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 564.38, ["Ride"] = 577.49, ["Fly|Ride"] = 678.57, ["Neon|Fly|Ride"] = 1947.69, ["Mega|Fly|Ride"] = 7217.44}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 19.69, ["Ride"] = 45.76, ["Fly|Ride"] = 130.4, ["Neon"] = 87.94, ["Neon|Fly"] = 285.08, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 184.21, ["Mega"] = 354.38, ["Mega|Ride"] = 314.77, ["Mega|Fly|Ride"] = 501.75}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4030.67, ["Fly"] = 4030.86, ["Ride"] = 3603.14, ["Fly|Ride"] = 3071.25, ["Neon|Fly|Ride"] = 6562.5, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 84.82, ["Fly"] = 134.93, ["Ride"] = 103.69, ["Fly|Ride"] = 131.25, ["Neon"] = 475.11, ["Neon|Ride"] = 370.5, ["Neon|Fly|Ride"] = 414.91, ["Mega|Fly|Ride"] = 1897.59}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.5, ["Fly"] = 31.82, ["Ride"] = 19.69, ["Fly|Ride"] = 61.38, ["Neon"] = 19.67, ["Neon|Fly"] = 42.24, ["Neon|Ride"] = 28.6, ["Neon|Fly|Ride"] = 79.14, ["Mega"] = 139.12, ["Mega|Fly"] = 452.82, ["Mega|Ride"] = 233.89, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.52, ["Ride"] = 27.5, ["Fly|Ride"] = 62.99, ["Neon"] = 24.7, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 161.19, ["Mega|Ride"] = 188.43, ["Mega|Fly|Ride"] = 278.2}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 45.91, ["Fly"] = 82.86, ["Ride"] = 42.33, ["Fly|Ride"] = 59.07, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 282.63, ["Mega|Fly|Ride"] = 1341.16}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 984.38, ["Ride"] = 1102.47, ["Fly|Ride"] = 1206.19, ["Neon"] = 5512.29, ["Neon|Fly|Ride"] = 5177.23}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 5184.37, ["Ride"] = 5938.21, ["Fly|Ride"] = 5299.23}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 21, ["Fly"] = 36.05, ["Ride"] = 26.24, ["Fly|Ride"] = 43.32, ["Neon"] = 261.86, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 2428.13, ["Mega|Fly|Ride"] = 505.21}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 21, ["Ride"] = 32.08, ["Fly|Ride"] = 80.07, ["Neon"] = 94.5, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 88.52, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 933.52, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 48.57, ["Fly"] = 85.31, ["Ride"] = 54.48, ["Fly|Ride"] = 84.79, ["Neon"] = 254.29, ["Neon|Ride"] = 315.46, ["Neon|Fly|Ride"] = 275.39, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 953.51}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 227.95, ["Fly"] = 283.01, ["Ride"] = 225.54, ["Fly|Ride"] = 284.55, ["Neon|Ride"] = 976.5, ["Neon|Fly|Ride"] = 1198.02, ["Mega"] = 11227.71, ["Mega|Fly|Ride"] = 3731.12}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.94, ["Ride"] = 32.65, ["Fly|Ride"] = 131.25, ["Neon"] = 21.21, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 84.69, ["Neon|Fly|Ride"] = 246.72, ["Mega"] = 154.88, ["Mega|Ride"] = 240.3, ["Mega|Fly|Ride"] = 370.05}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 183.75, ["Fly"] = 235.32, ["Ride"] = 216.57, ["Fly|Ride"] = 313.69, ["Neon"] = 707.07, ["Neon|Ride"] = 833.06, ["Neon|Fly|Ride"] = 786.19, ["Mega|Fly|Ride"] = 3695.31}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.56, ["Fly"] = 23.62, ["Ride"] = 16.93, ["Fly|Ride"] = 39, ["Neon"] = 16.97, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 27.15, ["Neon|Fly|Ride"] = 99.52, ["Mega"] = 210, ["Mega|Ride"] = 196.27, ["Mega|Fly|Ride"] = 254.26}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 196.88, ["Fly"] = 325.42, ["Ride"] = 234.94, ["Fly|Ride"] = 261.19, ["Neon|Ride"] = 1129.46, ["Neon|Fly|Ride"] = 1100.88, ["Mega"] = 10585.19, ["Mega|Ride"] = 6351.12, ["Mega|Fly|Ride"] = 7708.89}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 9.19, ["Fly"] = 26.25, ["Ride"] = 26.25, ["Fly|Ride"] = 65.63, ["Neon"] = 84.82, ["Neon|Fly"] = 301.7, ["Neon|Ride"] = 135.51, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 522.41, ["Mega|Ride"] = 565.26, ["Mega|Fly|Ride"] = 466.81}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Neon"] = 8.5, ["Neon|Fly"] = 66.94, ["Neon|Ride"] = 49.31, ["Neon|Fly|Ride"] = 84.45, ["Mega"] = 76.11, ["Mega|Ride"] = 115.39, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.02, ["Mega"] = 20.98, ["Mega|Ride"] = 139.96}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.6, ["Ride"] = 28.6, ["Fly|Ride"] = 141.62, ["Neon"] = 10.01, ["Neon|Ride"] = 50.91, ["Neon|Fly|Ride"] = 102.38, ["Mega"] = 64.22, ["Mega|Fly"] = 158131.78, ["Mega|Ride"] = 97.13, ["Mega|Fly|Ride"] = 171.46}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 61.69, ["Fly"] = 78.75, ["Ride"] = 79.69, ["Fly|Ride"] = 157.5, ["Neon"] = 285.08, ["Neon|Fly"] = 263.17, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 1270.24, ["Mega|Fly|Ride"] = 1068.44}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 40.69, ["Ride"] = 15.89, ["Fly|Ride"] = 39.09, ["Neon"] = 10.63, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 105, ["Mega"] = 95.1, ["Mega|Ride"] = 98.34, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 7.87, ["Ride"] = 67.86, ["Fly|Ride"] = 197.18, ["Neon"] = 74.82, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 120.69, ["Mega"] = 525, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 776.96}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Ride"] = 30.75, ["Neon"] = 2.5, ["Neon|Ride"] = 23.3, ["Neon|Fly|Ride"] = 55.76, ["Mega"] = 16.99, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 131.15}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 21.17, ["Ride"] = 17.77, ["Fly|Ride"] = 34.39, ["Neon"] = 2.1, ["Neon|Fly"] = 35.64, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 28.6, ["Mega"] = 15.74, ["Mega|Fly"] = 30.19, ["Mega|Ride"] = 21.36, ["Mega|Fly|Ride"] = 52.5}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 15.59, ["Fly|Ride"] = 34.55, ["Neon"] = 3.92, ["Neon|Fly"] = 15.23, ["Neon|Ride"] = 17.64, ["Neon|Fly|Ride"] = 46.59, ["Mega"] = 27.46, ["Mega|Fly"] = 59.31, ["Mega|Ride"] = 50.91, ["Mega|Fly|Ride"] = 78.66}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 22.36, ["Fly|Ride"] = 125.73, ["Neon"] = 2.1, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 39.38, ["Mega"] = 30.18, ["Mega|Ride"] = 92.11, ["Mega|Fly|Ride"] = 306.98}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Ride"] = 19.69, ["Fly|Ride"] = 104.81, ["Neon"] = 4.26, ["Neon|Fly"] = 135.03, ["Neon|Ride"] = 70.93, ["Neon|Fly|Ride"] = 86.01, ["Mega"] = 42.71, ["Mega|Fly"] = 85.32, ["Mega|Ride"] = 75.13, ["Mega|Fly|Ride"] = 164.09}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.52, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 15.54, ["Mega|Ride"] = 81.38}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 47.16, ["Ride"] = 26.14, ["Fly|Ride"] = 47.25, ["Neon"] = 4.87, ["Neon|Fly"] = 37.49, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 99.52, ["Mega"] = 42, ["Mega|Fly"] = 196.89, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 106.21}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 48.77, ["Neon"] = 2.1, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 313.84, ["Mega"] = 14.9, ["Mega|Ride"] = 64.05, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly"] = 36.05, ["Ride"] = 52.5, ["Fly|Ride"] = 525, ["Neon"] = 41.97, ["Mega"] = 203.25, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 344.97}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 42.41, ["Neon"] = 13.13, ["Mega"] = 139.13, ["Mega|Fly|Ride"] = 378.96}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 71.04, ["Neon"] = 6.57, ["Neon|Ride"] = 37.7, ["Neon|Fly|Ride"] = 84.69, ["Mega"] = 24.36, ["Mega|Ride"] = 42.36, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 30.8, ["Ride"] = 18.8, ["Fly|Ride"] = 30.19, ["Neon"] = 2.1, ["Neon|Fly"] = 26.09, ["Neon|Ride"] = 17.08, ["Neon|Fly|Ride"] = 41.88, ["Mega"] = 15.63, ["Mega|Fly"] = 52.95, ["Mega|Ride"] = 24.34, ["Mega|Fly|Ride"] = 57.75}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 42, ["Fly|Ride"] = 104.98, ["Neon"] = 32.71, ["Neon|Ride"] = 39.83, ["Mega"] = 254.05, ["Mega|Fly"] = 282.63, ["Mega|Ride"] = 353.56, ["Mega|Fly|Ride"] = 690.17}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 41.91, ["Fly|Ride"] = 78.74, ["Neon"] = 6.2, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 158.06, ["Mega"] = 30.19, ["Mega|Ride"] = 51.18, ["Mega|Fly|Ride"] = 156.68}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.1, ["Neon"] = 13.13, ["Neon|Fly|Ride"] = 141.86, ["Mega"] = 82.51, ["Mega|Ride"] = 165.15, ["Mega|Fly|Ride"] = 221.81}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 21.15, ["Ride"] = 32.81, ["Fly|Ride"] = 192.94, ["Neon"] = 10.58, ["Neon|Ride"] = 70.94, ["Neon|Fly|Ride"] = 127.03, ["Mega"] = 91.04, ["Mega|Ride"] = 85.3, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 12.73, ["Fly|Ride"] = 28.67, ["Neon"] = 2.1, ["Neon|Fly"] = 15.74, ["Neon|Ride"] = 15.89, ["Neon|Fly|Ride"] = 30.19, ["Mega"] = 16.73, ["Mega|Fly"] = 84, ["Mega|Ride"] = 25.4, ["Mega|Fly|Ride"] = 52.43}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 23.94, ["Ride"] = 20.15, ["Fly|Ride"] = 48.57, ["Neon"] = 15.61, ["Neon|Ride"] = 113.89, ["Neon|Fly|Ride"] = 75.17, ["Mega"] = 78.75, ["Mega|Fly|Ride"] = 196.77}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.1, ["Fly"] = 41.91, ["Ride"] = 21, ["Fly|Ride"] = 141.39, ["Neon"] = 22.32, ["Neon|Ride"] = 112.22, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 279.2, ["Mega|Ride"] = 278.07, ["Mega|Fly|Ride"] = 387.85}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 13.02, ["Ride"] = 16.15, ["Fly|Ride"] = 26.17, ["Neon"] = 3.94, ["Neon|Fly"] = 20.24, ["Neon|Ride"] = 15.89, ["Neon|Fly|Ride"] = 59.3, ["Mega"] = 60.35, ["Mega|Fly"] = 156.19, ["Mega|Ride"] = 66.44, ["Mega|Fly|Ride"] = 124.09}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 177.02, ["Neon"] = 4.26, ["Neon|Fly"] = 77.53, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 28.6, ["Mega|Fly"] = 565.26, ["Mega|Ride"] = 92.46}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 6.39, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 157.74, ["Neon|Fly|Ride"] = 142.35, ["Mega"] = 32.82, ["Mega|Ride"] = 149.45, ["Mega|Fly|Ride"] = 206.37}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 44.54, ["Ride"] = 21.21, ["Neon"] = 2.1, ["Neon|Fly"] = 41.35, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 101.07, ["Mega"] = 18.17, ["Mega|Ride"] = 70.88, ["Mega|Fly|Ride"] = 124.76}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 88.89, ["Ride"] = 19.03, ["Fly|Ride"] = 59.07, ["Neon"] = 6.57, ["Neon|Fly"] = 45.09, ["Neon|Ride"] = 27.54, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 74.08, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 269.94}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 31.39, ["Neon"] = 5.85, ["Neon|Ride"] = 64.07, ["Mega"] = 103.74, ["Mega|Ride"] = 115.67, ["Mega|Fly|Ride"] = 312.29}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 17.07, ["Fly|Ride"] = 141.75, ["Neon"] = 4.26, ["Neon|Fly"] = 21.15, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 48.57, ["Mega"] = 65.63, ["Mega|Ride"] = 90.46, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.86, ["Ride"] = 82.6, ["Neon"] = 32.82, ["Mega"] = 282.63, ["Mega|Fly|Ride"] = 844.06}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 15.65, ["Fly|Ride"] = 35.64, ["Neon"] = 12.71, ["Neon|Fly"] = 141.86, ["Neon|Ride"] = 28.59, ["Neon|Fly|Ride"] = 57.18, ["Mega"] = 191.58, ["Mega|Fly|Ride"] = 282.63}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 20.6, ["Ride"] = 28.49, ["Fly|Ride"] = 142.06, ["Neon"] = 19.65, ["Neon|Fly"] = 62.55, ["Neon|Ride"] = 38.12, ["Neon|Fly|Ride"] = 63.52, ["Mega"] = 115.5, ["Mega|Fly"] = 141.86, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 79.47, ["Fly|Ride"] = 106.14, ["Neon"] = 21.21, ["Neon|Ride"] = 158.95, ["Mega"] = 202.06, ["Mega|Ride"] = 405.56, ["Mega|Fly|Ride"] = 281.58}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 10.39, ["Ride"] = 78.46, ["Mega"] = 577.5, ["Mega|Ride"] = 672.17, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 3.93, ["Ride"] = 47.41, ["Fly|Ride"] = 59.07, ["Neon"] = 87.26, ["Neon|Ride"] = 105, ["Mega"] = 212.63, ["Mega|Ride"] = 367.5}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 15.1, ["Ride"] = 42, ["Neon"] = 72.19, ["Neon|Ride"] = 76.2, ["Mega"] = 474.42, ["Mega|Ride"] = 253.31, ["Mega|Fly|Ride"] = 381.08}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.1, ["Neon|Ride"] = 92.28, ["Mega"] = 22.32, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 148.29}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 45.07}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 6.56, ["Fly"] = 26.84, ["Ride"] = 21.8, ["Fly|Ride"] = 69.99, ["Neon"] = 49.85, ["Neon|Ride"] = 57.18, ["Neon|Fly|Ride"] = 80.07, ["Mega"] = 249.38, ["Mega|Ride"] = 526.59, ["Mega|Fly|Ride"] = 245.44}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 10.5, ["Ride"] = 18.36, ["Fly|Ride"] = 736.4, ["Neon"] = 2.86, ["Neon|Ride"] = 28.24, ["Mega"] = 80.47, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 24.4, ["Fly|Ride"] = 140.17, ["Neon"] = 6.57, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 158.94, ["Mega"] = 39.38, ["Mega|Ride"] = 82.49, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 16.69, ["Fly|Ride"] = 78.46, ["Neon"] = 16.54, ["Neon|Ride"] = 28.6, ["Neon|Fly|Ride"] = 93.74, ["Mega"] = 148.73, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 282.63}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 2.84, ["Neon"] = 38.66, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 156.26, ["Mega"] = 328.13, ["Mega|Ride"] = 279.57}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly|Ride"] = 79.49, ["Mega"] = 16.95, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 141.86}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 13.13, ["Fly|Ride"] = 57.26, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 100.57, ["Mega"] = 25.41, ["Mega|Fly"] = 201.64, ["Mega|Ride"] = 52.41, ["Mega|Fly|Ride"] = 145.69}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 15.53, ["Ride"] = 15.64, ["Fly|Ride"] = 34.13, ["Neon"] = 7.65, ["Neon|Fly"] = 71.04, ["Neon|Ride"] = 23.37, ["Neon|Fly|Ride"] = 51.19, ["Mega"] = 52.45, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 158.29}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 26.24, ["Fly|Ride"] = 53.82, ["Neon"] = 3.68, ["Neon|Ride"] = 36.72, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 23.43, ["Mega|Fly"] = 99.52, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 112.87}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 6.18, ["Neon|Ride"] = 38.06, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 19.74, ["Mega|Fly"] = 146.35, ["Mega|Ride"] = 84.69, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 26.17, ["Ride"] = 52.5, ["Fly|Ride"] = 77.37, ["Neon"] = 2.63, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 31.77, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 26.17, ["Mega|Ride"] = 42.36, ["Mega|Fly|Ride"] = 103.59}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Mega"] = 19.57, ["Mega|Ride"] = 230.77}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 158.95, ["Neon|Fly|Ride"] = 282.63, ["Mega"] = 27.53, ["Mega|Fly"] = 118.61, ["Mega|Ride"] = 113.27}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 19.69, ["Fly|Ride"] = 36.05, ["Neon"] = 4.04, ["Neon|Fly"] = 72.01, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 70.93, ["Mega"] = 78.75, ["Mega|Fly"] = 105.88, ["Mega|Fly|Ride"] = 131.22}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 12.52, ["Ride"] = 65.63, ["Neon"] = 91.88, ["Neon|Ride"] = 237.25, ["Mega"] = 389.62, ["Mega|Ride"] = 472.03, ["Mega|Fly|Ride"] = 706.05}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.49, ["Ride"] = 38.66, ["Fly|Ride"] = 131.15, ["Neon"] = 78.46, ["Mega"] = 210.66, ["Mega|Ride"] = 348.48, ["Mega|Fly|Ride"] = 423.42}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 5.25, ["Ride"] = 28.3, ["Fly|Ride"] = 424.04, ["Neon"] = 32.87, ["Neon|Ride"] = 84.69, ["Mega"] = 236.07, ["Mega|Ride"] = 197.98, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 15.91, ["Ride"] = 10.5, ["Fly|Ride"] = 32.88, ["Neon"] = 2.1, ["Neon|Fly"] = 10.5, ["Neon|Ride"] = 11.79, ["Neon|Fly|Ride"] = 28.06, ["Mega"] = 19.65, ["Mega|Fly"] = 25.61, ["Mega|Ride"] = 21.17, ["Mega|Fly|Ride"] = 45.94}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 10.61, ["Neon|Fly"] = 84.29, ["Neon|Ride"] = 32.04, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 158.8, ["Mega|Ride"] = 141.86}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 21.21, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 79.05, ["Mega"] = 15.64, ["Mega|Fly"] = 78.3, ["Mega|Ride"] = 28.6, ["Mega|Fly|Ride"] = 103.58}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.66, ["Neon|Fly"] = 60.9, ["Mega"] = 19.69, ["Mega|Ride"] = 134.46, ["Mega|Fly|Ride"] = 210.66}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 18.85, ["Fly|Ride"] = 53.02, ["Neon"] = 12.7, ["Neon|Fly"] = 71.04, ["Neon|Ride"] = 30.82, ["Neon|Fly|Ride"] = 78.73, ["Mega"] = 143.22, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 267.15}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 205.5, ["Ride"] = 236.25, ["Fly|Ride"] = 262.5, ["Neon"] = 1555.12, ["Neon|Ride"] = 1005.6, ["Neon|Fly|Ride"] = 988.67, ["Mega"] = 8468.16, ["Mega|Fly|Ride"] = 3281.25}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 4.26, ["Neon|Fly"] = 57.26, ["Neon|Ride"] = 68.25, ["Mega"] = 65.42, ["Mega|Ride"] = 197.95, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 5.76, ["Fly"] = 103.68, ["Ride"] = 31.82, ["Fly|Ride"] = 142.06, ["Neon"] = 59.07, ["Neon|Ride"] = 169.37, ["Neon|Fly|Ride"] = 159.85, ["Mega"] = 423.42, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 633.33}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 13.13, ["Fly|Ride"] = 34.81, ["Neon"] = 6.57, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 21.19, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 65.63, ["Mega|Fly"] = 94.89, ["Mega|Ride"] = 59.7, ["Mega|Fly|Ride"] = 104.81}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 24.94, ["Fly|Ride"] = 120.89, ["Neon"] = 4.26, ["Neon|Fly"] = 84.82, ["Neon|Ride"] = 81.21, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 120.69, ["Mega|Ride"] = 131.25}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.94, ["Fly"] = 28.67, ["Ride"] = 15.39, ["Fly|Ride"] = 34.13, ["Neon"] = 27.58, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 57.18, ["Mega"] = 209.18, ["Mega|Ride"] = 281.58, ["Mega|Fly|Ride"] = 254.99}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 5.8, ["Fly"] = 28.64, ["Ride"] = 23.34, ["Fly|Ride"] = 247.07, ["Neon"] = 39.38, ["Neon|Ride"] = 137.45, ["Neon|Fly|Ride"] = 628.78, ["Mega"] = 328.13, ["Mega|Ride"] = 312.29, ["Mega|Fly|Ride"] = 398.35}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 15.91, ["Fly|Ride"] = 36.75, ["Neon"] = 17.83, ["Neon|Fly"] = 83.76, ["Neon|Ride"] = 33.89, ["Neon|Fly|Ride"] = 67.8, ["Mega|Fly"] = 384.57, ["Mega|Ride"] = 355.81, ["Mega|Fly|Ride"] = 188.75}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 65.62, ["Fly"] = 105, ["Ride"] = 92.45, ["Fly|Ride"] = 131.24, ["Neon"] = 398.01, ["Neon|Fly"] = 405.57, ["Neon|Ride"] = 378, ["Neon|Fly|Ride"] = 466.81, ["Mega|Fly|Ride"] = 1547.25}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 216.56, ["Fly"] = 322.17, ["Ride"] = 223.13, ["Fly|Ride"] = 269.32, ["Neon"] = 907.45, ["Neon|Ride"] = 1341.16, ["Neon|Fly|Ride"] = 1100.88, ["Mega"] = 10585.19, ["Mega|Fly|Ride"] = 4300.77}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 61.69, ["Fly"] = 149.65, ["Ride"] = 84.62, ["Fly|Ride"] = 113.45, ["Neon"] = 379.25, ["Neon|Ride"] = 314.99, ["Neon|Fly|Ride"] = 351.65, ["Mega|Fly|Ride"] = 1279.9}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 7.87, ["Ride"] = 26.25, ["Fly|Ride"] = 84.82, ["Neon"] = 22.88, ["Neon|Fly"] = 47.64, ["Neon|Ride"] = 79.49, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 198.08, ["Mega|Ride"] = 187.04, ["Mega|Fly|Ride"] = 316.67}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 12.77, ["Fly"] = 68.14, ["Ride"] = 42, ["Fly|Ride"] = 78.26, ["Neon"] = 91.39, ["Neon|Ride"] = 91.04, ["Neon|Fly|Ride"] = 206.43, ["Mega"] = 353.07, ["Mega|Ride"] = 393.79, ["Mega|Fly|Ride"] = 453.06}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 20.83, ["Fly|Ride"] = 42.41, ["Neon"] = 4.92, ["Neon|Fly"] = 115.5, ["Neon|Ride"] = 19.06, ["Neon|Fly|Ride"] = 78.35, ["Mega"] = 67.61, ["Mega|Fly"] = 211.12, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 562.09}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.57, ["Fly"] = 68.49, ["Ride"] = 28.6, ["Fly|Ride"] = 131.25, ["Neon"] = 23.93, ["Neon|Ride"] = 141.86, ["Neon|Fly|Ride"] = 134.93, ["Mega"] = 790.73, ["Mega|Ride"] = 497.44, ["Mega|Fly|Ride"] = 536.68}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 15.91, ["Ride"] = 11.89, ["Fly|Ride"] = 42, ["Neon"] = 15.67, ["Neon|Fly"] = 104.99, ["Neon|Ride"] = 36.01, ["Neon|Fly|Ride"] = 99.49, ["Mega"] = 131.25, ["Mega|Ride"] = 141.86, ["Mega|Fly|Ride"] = 175.88}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 3.91, ["Ride"] = 21.21, ["Fly|Ride"] = 157.5, ["Neon"] = 27.58, ["Neon|Ride"] = 70.94, ["Neon|Fly|Ride"] = 237.25, ["Mega"] = 207.37, ["Mega|Ride"] = 233.96, ["Mega|Fly|Ride"] = 457.47}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 33.93, ["Neon"] = 2.1, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 15.72, ["Mega|Ride"] = 50.82, ["Mega|Fly|Ride"] = 226.44}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 3.82, ["Fly"] = 45.93, ["Ride"] = 20.88, ["Fly|Ride"] = 39.38, ["Neon"] = 13.13, ["Neon|Fly"] = 106.01, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 108.94, ["Mega|Ride"] = 96.49, ["Mega|Fly|Ride"] = 189.67}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 3.76, ["Fly"] = 36.75, ["Ride"] = 18.02, ["Fly|Ride"] = 39.29, ["Neon"] = 64.15, ["Neon|Fly"] = 142.06, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 63, ["Mega"] = 279.46, ["Mega|Ride"] = 206.07, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 140.25, ["Fly"] = 183.75, ["Ride"] = 198.22, ["Fly|Ride"] = 257.88, ["Neon"] = 593.88, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 524.95, ["Mega|Ride"] = 3478.13, ["Mega|Fly|Ride"] = 2180.05}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.67, ["Ride"] = 31.48, ["Fly|Ride"] = 206.07, ["Neon"] = 44.63, ["Neon|Ride"] = 94.4, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 304.4, ["Mega|Ride"] = 347.22, ["Mega|Fly|Ride"] = 421.31}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Fly|Ride"] = 71.04, ["Neon"] = 28.64, ["Neon|Ride"] = 42.36, ["Neon|Fly|Ride"] = 126.92, ["Mega"] = 137.82, ["Mega|Ride"] = 268.89, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 24.94, ["Ride"] = 85.31, ["Fly|Ride"] = 178.5, ["Neon"] = 106.32, ["Neon|Ride"] = 146.09, ["Neon|Fly|Ride"] = 294.53, ["Mega"] = 419.88, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 9.19}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 6.3, ["Ride"] = 37.11, ["Neon"] = 68.25, ["Neon|Fly"] = 71.04, ["Neon|Ride"] = 163.02, ["Neon|Fly|Ride"] = 635.13, ["Mega"] = 283.5, ["Mega|Ride"] = 313.69, ["Mega|Fly|Ride"] = 550.45}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 24.81, ["Fly"] = 26.25, ["Ride"] = 31.49, ["Fly|Ride"] = 39.38, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 158.76, ["Neon|Fly|Ride"] = 175.41, ["Mega"] = 2117.05, ["Mega|Ride"] = 697.37, ["Mega|Fly|Ride"] = 592.78}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Fly"] = 31.82, ["Ride"] = 32.82, ["Fly|Ride"] = 78.75, ["Neon"] = 3.94, ["Neon|Ride"] = 28.6, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 41.99, ["Mega|Ride"] = 73.97}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 5.25, ["Fly"] = 26.25, ["Ride"] = 20.9, ["Fly|Ride"] = 62.26, ["Neon"] = 30.6, ["Neon|Ride"] = 113.27, ["Mega"] = 265.79, ["Mega|Fly"] = 396.13, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 45.76, ["Ride"] = 15.73, ["Fly|Ride"] = 57.03, ["Neon"] = 19.02, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 31.48, ["Neon|Fly|Ride"] = 65.44, ["Mega"] = 136.43, ["Mega|Ride"] = 128.34, ["Mega|Fly|Ride"] = 240.3}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Neon"] = 4.14, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 29.23, ["Mega"] = 30.19, ["Mega|Ride"] = 63.75, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 35.44, ["Fly"] = 71.04, ["Ride"] = 76.13, ["Fly|Ride"] = 525, ["Neon"] = 223.89, ["Neon|Ride"] = 315.53, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 807.47, ["Mega|Ride"] = 774.38, ["Mega|Fly|Ride"] = 888.36}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.93, ["Ride"] = 71.04, ["Fly|Ride"] = 210, ["Neon"] = 47.53, ["Neon|Ride"] = 84.69, ["Neon|Fly|Ride"] = 211.72, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 20.9, ["Fly"] = 57.26, ["Ride"] = 43.32, ["Fly|Ride"] = 196.88, ["Neon"] = 75.9, ["Neon|Fly"] = 212.02, ["Neon|Ride"] = 84.69, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 505.99, ["Mega|Ride"] = 350.55, ["Mega|Fly|Ride"] = 473.2}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 47.25, ["Fly"] = 142.05, ["Ride"] = 52.5, ["Fly|Ride"] = 262.44, ["Neon"] = 285.08, ["Neon|Ride"] = 353.56, ["Neon|Fly|Ride"] = 312.29, ["Mega|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 1448.07}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 29.48, ["Fly"] = 47.25, ["Ride"] = 36.86, ["Fly|Ride"] = 142.06, ["Neon"] = 142.06, ["Neon|Ride"] = 158.95, ["Neon|Fly|Ride"] = 846.83, ["Mega"] = 300.57, ["Mega|Ride"] = 466.81, ["Mega|Fly|Ride"] = 507.94}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 74.82, ["Fly"] = 145.69, ["Ride"] = 103.68, ["Neon"] = 203.44, ["Neon|Ride"] = 228.38, ["Neon|Fly|Ride"] = 367.86, ["Mega"] = 973.86, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 913.5}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 19.58, ["Ride"] = 69.33, ["Fly|Ride"] = 104.9, ["Neon"] = 91.88, ["Neon|Ride"] = 99.52, ["Neon|Fly|Ride"] = 254.05, ["Mega"] = 474.42, ["Mega|Ride"] = 322.05, ["Mega|Fly|Ride"] = 419.06}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 6.69, ["Fly"] = 69.5, ["Ride"] = 22.32, ["Neon"] = 81.54, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 127.03, ["Mega"] = 336.83, ["Mega|Ride"] = 1058.53, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 26.25, ["Ride"] = 78.75, ["Fly|Ride"] = 142.54, ["Neon"] = 90.57, ["Neon|Ride"] = 154.54, ["Neon|Fly|Ride"] = 237.25, ["Mega"] = 423.42, ["Mega|Ride"] = 384.57, ["Mega|Fly|Ride"] = 563.15}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 17.07, ["Ride"] = 34.13, ["Fly|Ride"] = 139.95, ["Neon"] = 64.15, ["Neon|Ride"] = 94.9, ["Mega"] = 312.29, ["Mega|Ride"] = 423.42, ["Mega|Fly|Ride"] = 392.52}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 42.41, ["Neon|Ride"] = 55.95, ["Mega"] = 18.38, ["Mega|Fly"] = 141.86, ["Mega|Ride"] = 70.81, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.94, ["Ride"] = 210, ["Fly|Ride"] = 439.93, ["Neon"] = 12.16, ["Neon|Ride"] = 83.83, ["Mega"] = 126.05, ["Mega|Ride"] = 233.96, ["Mega|Fly|Ride"] = 158.94}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.6, ["Ride"] = 57.26, ["Neon"] = 22.32, ["Neon|Ride"] = 105.88, ["Mega"] = 181.79, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 6.25, ["Ride"] = 31.44, ["Fly|Ride"] = 117.59, ["Neon"] = 26.14, ["Neon|Ride"] = 82.95, ["Neon|Fly|Ride"] = 281.58, ["Mega"] = 123.38, ["Mega|Ride"] = 152.97, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 472.4, ["Ride"] = 541.38, ["Fly|Ride"] = 627.38, ["Neon|Ride"] = 1378.13, ["Neon|Fly|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 5878.95}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 6.57, ["Fly"] = 28.49, ["Ride"] = 25.15, ["Fly|Ride"] = 57.26, ["Neon"] = 42.41, ["Neon|Ride"] = 77.6, ["Neon|Fly|Ride"] = 210, ["Mega"] = 282.63, ["Mega|Ride"] = 275.23}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 11.54, ["Fly"] = 39.38, ["Ride"] = 28.64, ["Fly|Ride"] = 84.82, ["Neon"] = 55.13, ["Neon|Fly"] = 315, ["Neon|Ride"] = 64.32, ["Mega"] = 332.38, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 395.75}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 7.86, ["Fly"] = 28.64, ["Ride"] = 22.58, ["Fly|Ride"] = 142.06, ["Neon"] = 65.63, ["Neon|Ride"] = 196.87, ["Mega"] = 223.13, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 27.12, ["Fly|Ride"] = 65.13, ["Neon"] = 11.82, ["Neon|Fly"] = 71.04, ["Neon|Ride"] = 30.85, ["Neon|Fly|Ride"] = 120.75, ["Mega"] = 71.18, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 192.28}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 71.04, ["Ride"] = 71.04, ["Neon"] = 3.87, ["Neon|Ride"] = 40.05, ["Mega"] = 26.64, ["Mega|Fly|Ride"] = 218.07}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1504.68}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 12.74, ["Ride"] = 57.26, ["Neon"] = 53.02, ["Neon|Fly"] = 142.06, ["Neon|Ride"] = 88.93, ["Mega"] = 649.94, ["Mega|Ride"] = 550.45, ["Mega|Fly|Ride"] = 677.21}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 38.07, ["Neon"] = 8.43, ["Neon|Ride"] = 42.34, ["Mega"] = 57.75, ["Mega|Ride"] = 137.63, ["Mega|Fly|Ride"] = 236.92}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 99.48, ["Ride"] = 23.34, ["Fly|Ride"] = 525, ["Neon"] = 10.48, ["Neon|Ride"] = 63.52, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 183.75, ["Mega|Ride"] = 152.44, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 368.82, ["Ride"] = 446.25, ["Fly|Ride"] = 459.38, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1711.61, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 6.57, ["Fly"] = 196.88, ["Ride"] = 72.19, ["Neon"] = 79.59, ["Neon|Ride"] = 79.49, ["Mega"] = 379.53, ["Mega|Ride"] = 279.46, ["Mega|Fly|Ride"] = 395.9}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Neon"] = 6.15, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 104.3, ["Mega"] = 39.38, ["Mega|Fly"] = 189, ["Mega|Ride"] = 74.73, ["Mega|Fly|Ride"] = 190.2}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 847.95, ["Neon"] = 2.1, ["Neon|Ride"] = 98.28, ["Neon|Fly|Ride"] = 268.89, ["Mega"] = 18.93, ["Mega|Ride"] = 141.86, ["Mega|Fly|Ride"] = 192.94}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 11.82, ["Fly"] = 56.27, ["Ride"] = 45.14, ["Fly|Ride"] = 148.42, ["Neon"] = 83.76, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 328.13, ["Mega|Ride"] = 395.9, ["Mega|Fly|Ride"] = 372.75}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 8.25, ["Ride"] = 110.27, ["Neon"] = 79.59, ["Neon|Ride"] = 141.86, ["Neon|Fly|Ride"] = 838.69, ["Mega"] = 633.33, ["Mega|Ride"] = 561.29, ["Mega|Fly|Ride"] = 1086.11}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 5.97, ["Fly"] = 65.63, ["Ride"] = 26.25, ["Fly|Ride"] = 99.66, ["Neon"] = 141.36, ["Neon|Ride"] = 200.82, ["Mega"] = 582.75, ["Mega|Ride"] = 328.02, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 15.94, ["Ride"] = 43.32, ["Fly|Ride"] = 142.54, ["Neon"] = 111.37, ["Neon|Ride"] = 156.13, ["Neon|Fly|Ride"] = 790.8, ["Mega"] = 565.26, ["Mega|Ride"] = 565.26, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 367.74, ["Ride"] = 380.63, ["Fly|Ride"] = 528.98, ["Neon"] = 1272.09, ["Neon|Ride"] = 1270.24, ["Neon|Fly|Ride"] = 1270.24, ["Mega|Ride"] = 3796.92, ["Mega|Fly|Ride"] = 3242.6}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 4.2, ["Fly"] = 28.3, ["Ride"] = 30.72, ["Fly|Ride"] = 84.21, ["Neon"] = 39.38, ["Neon|Ride"] = 135.23, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 525, ["Mega|Ride"] = 536.82, ["Mega|Fly|Ride"] = 702.87}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 11.6, ["Ride"] = 117.59, ["Mega"] = 1270.24, ["Mega|Fly|Ride"] = 1693.64}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 18.36, ["Ride"] = 52.5, ["Fly|Ride"] = 163.26, ["Neon"] = 41.91, ["Neon|Ride"] = 103.69, ["Mega"] = 200.94, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 319.61}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Ride"] = 42, ["Fly|Ride"] = 113.45, ["Neon"] = 14.43, ["Neon|Ride"] = 45.53, ["Mega"] = 40.69, ["Mega|Ride"] = 78.74, ["Mega|Fly|Ride"] = 237.21}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 43.08, ["Ride"] = 78.75, ["Neon"] = 266.44, ["Neon|Ride"] = 244.39, ["Neon|Fly|Ride"] = 409.66, ["Mega"] = 1056.42, ["Mega|Ride"] = 1129.46, ["Mega|Fly|Ride"] = 1179.21}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 3.68, ["Fly"] = 593.83, ["Ride"] = 38.94, ["Fly|Ride"] = 64.15, ["Neon"] = 13.08, ["Neon|Fly"] = 156.96, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 70.88, ["Mega|Ride"] = 94.07, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 25.46, ["Fly|Ride"] = 71.04, ["Neon"] = 3.94, ["Neon|Fly"] = 71.04, ["Neon|Ride"] = 35.6, ["Neon|Fly|Ride"] = 140.31, ["Mega"] = 33.89, ["Mega|Fly"] = 92.11, ["Mega|Ride"] = 76.2, ["Mega|Fly|Ride"] = 174.17}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 3.81, ["Ride"] = 42.41, ["Fly|Ride"] = 111.2, ["Neon"] = 15.75, ["Neon|Ride"] = 158.95, ["Neon|Fly|Ride"] = 706.05, ["Mega"] = 131.25, ["Mega|Fly"] = 635.13, ["Mega|Ride"] = 209.61, ["Mega|Fly|Ride"] = 588.56}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 70.2, ["Ride"] = 110.25, ["Fly|Ride"] = 202.49, ["Neon"] = 485.63, ["Neon|Ride"] = 626.07, ["Neon|Fly|Ride"] = 627.38, ["Mega|Fly|Ride"] = 1027.07}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 258.9, ["Ride"] = 273.51, ["Fly|Ride"] = 341.25, ["Neon"] = 1060.07, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1100.88, ["Mega"] = 7057.16, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 4.87, ["Neon"] = 21, ["Neon|Ride"] = 88.93, ["Mega"] = 91.88, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 639.21}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 5.16, ["Ride"] = 36.66, ["Fly|Ride"] = 210.97, ["Neon"] = 26.23, ["Mega"] = 105, ["Mega|Ride"] = 127.03, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.93, ["Fly"] = 155.57, ["Ride"] = 27.57, ["Neon"] = 34.13, ["Mega"] = 517.79, ["Mega|Ride"] = 337.84}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 28.46, ["Ride"] = 21, ["Fly|Ride"] = 72.19, ["Neon"] = 6.17, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 45.93, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 36.71, ["Fly|Ride"] = 210.68, ["Neon"] = 9.19, ["Mega"] = 31.5, ["Mega|Fly"] = 565.26, ["Mega|Ride"] = 206.43, ["Mega|Fly|Ride"] = 282.63}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 23.78, ["Ride"] = 18.36, ["Fly|Ride"] = 41.94, ["Neon"] = 3.93, ["Neon|Fly"] = 47.46, ["Neon|Ride"] = 28.6, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 39.38, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 142.34}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 24.94, ["Fly|Ride"] = 63.62, ["Neon"] = 8.5, ["Neon|Fly"] = 47.53, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 69.87, ["Mega"] = 170.63, ["Mega|Ride"] = 201.13, ["Mega|Fly|Ride"] = 435.75}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 42, ["Ride"] = 45.94, ["Fly|Ride"] = 83.65, ["Neon"] = 198.24, ["Neon|Ride"] = 282.63, ["Mega"] = 380.63, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 84.96, ["Fly"] = 582.75, ["Ride"] = 97.28, ["Fly|Ride"] = 424.04, ["Neon"] = 439.69, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 466.81, ["Mega|Ride"] = 2251.49, ["Mega|Fly|Ride"] = 1564.33}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 17.07, ["Fly|Ride"] = 131.25, ["Neon"] = 4.23, ["Neon|Fly"] = 78.75, ["Neon|Fly|Ride"] = 141.86, ["Mega"] = 56.35, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 105.88}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 16.77, ["Ride"] = 19.1, ["Fly|Ride"] = 30.15, ["Neon"] = 4.2, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 24.92, ["Neon|Fly|Ride"] = 68.85, ["Mega"] = 36.01, ["Mega|Fly"] = 131.21, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 3.92, ["Ride"] = 23.78, ["Neon"] = 26.25, ["Neon|Ride"] = 47.46, ["Neon|Fly|Ride"] = 156.68, ["Mega"] = 633.01, ["Mega|Ride"] = 352.4, ["Mega|Fly|Ride"] = 472.38}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 315, ["Fly"] = 413.44, ["Ride"] = 422.63, ["Fly|Ride"] = 301.88, ["Neon|Ride"] = 1200.38, ["Neon|Fly|Ride"] = 1586.73, ["Mega"] = 7906.96, ["Mega|Fly|Ride"] = 5646.16}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 28.88, ["Fly"] = 142.05, ["Ride"] = 60.38, ["Fly|Ride"] = 131.25, ["Neon"] = 196.88, ["Neon|Ride"] = 233.96, ["Neon|Fly|Ride"] = 264.37, ["Mega"] = 1082.92, ["Mega|Ride"] = 917.75, ["Mega|Fly|Ride"] = 923.96}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Fly|Ride"] = 57.16, ["Neon"] = 6.57, ["Neon|Ride"] = 70.94, ["Neon|Fly|Ride"] = 141.86, ["Mega"] = 82.69, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 190.55}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 28.87, ["Fly|Ride"] = 142.7, ["Neon"] = 26.17, ["Neon|Ride"] = 202.19, ["Mega"] = 486.93}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 29.54, ["Fly"] = 78.45, ["Ride"] = 47.53, ["Fly|Ride"] = 92.24, ["Neon|Ride"] = 105.88, ["Neon|Fly|Ride"] = 157.69, ["Mega"] = 2540.46, ["Mega|Ride"] = 952.68, ["Mega|Fly|Ride"] = 1265.45}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 105, ["Ride"] = 142.12, ["Fly|Ride"] = 142.06, ["Neon"] = 414.86, ["Neon|Ride"] = 471.19, ["Neon|Fly|Ride"] = 439.29, ["Mega"] = 3105.72, ["Mega|Fly|Ride"] = 2134.78}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 210.91, ["Ride"] = 245.44, ["Fly|Ride"] = 339.23, ["Neon"] = 1060.07, ["Neon|Ride"] = 945, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 2963.87}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 18.38, ["Ride"] = 60.38, ["Fly|Ride"] = 216.26, ["Neon"] = 97.21, ["Neon|Fly|Ride"] = 282.63, ["Mega"] = 388.5, ["Mega|Ride"] = 381.14, ["Mega|Fly|Ride"] = 536.95}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 27.58, ["Ride"] = 17.38, ["Fly|Ride"] = 35.95, ["Neon"] = 6.36, ["Neon|Ride"] = 28.58, ["Neon|Fly|Ride"] = 47.45, ["Mega"] = 90.57, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.1, ["Fly"] = 33.64, ["Ride"] = 20.98, ["Fly|Ride"] = 52.5, ["Neon"] = 35.85, ["Neon|Fly"] = 148.42, ["Neon|Ride"] = 46.59, ["Neon|Fly|Ride"] = 105.69, ["Mega"] = 236.25, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 294.29}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 301.88, ["Fly"] = 495, ["Ride"] = 278.25, ["Fly|Ride"] = 406.88, ["Neon"] = 2067.12, ["Neon|Ride"] = 1693.64, ["Neon|Fly|Ride"] = 1418.44, ["Mega|Fly|Ride"] = 5775}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 28.64, ["Neon"] = 5.25, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 39.38, ["Mega|Ride"] = 156.68, ["Mega|Fly|Ride"] = 268.89}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 6.39, ["Fly"] = 14.44, ["Ride"] = 15.18, ["Fly|Ride"] = 54.65, ["Neon"] = 22.32, ["Neon|Ride"] = 31.77, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 171.94, ["Mega|Ride"] = 222.31, ["Mega|Fly|Ride"] = 302.82}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 18.36, ["Ride"] = 117.59, ["Neon"] = 104.89, ["Neon|Fly"] = 282.63, ["Neon|Ride"] = 127.03, ["Neon|Fly|Ride"] = 565.26, ["Mega"] = 466.48, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 158.82, ["Fly"] = 172.78, ["Ride"] = 146.68, ["Fly|Ride"] = 169.32, ["Neon|Ride"] = 727.13, ["Neon|Fly|Ride"] = 485.63, ["Mega|Fly|Ride"] = 2098.69}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 21, ["Fly"] = 45.05, ["Ride"] = 30.08, ["Fly|Ride"] = 52.48, ["Neon"] = 94.5, ["Neon|Ride"] = 98.31, ["Neon|Fly|Ride"] = 139.16, ["Mega"] = 704.99, ["Mega|Ride"] = 419.86, ["Mega|Fly|Ride"] = 414.75}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 26.24, ["Neon"] = 2.1, ["Neon|Fly|Ride"] = 706.05, ["Mega"] = 23.63, ["Mega|Ride"] = 69.87, ["Mega|Fly|Ride"] = 253}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 52.5, ["Neon"] = 2.1, ["Neon|Fly"] = 159.17, ["Neon|Ride"] = 20.12, ["Neon|Fly|Ride"] = 69.18, ["Mega"] = 27.54, ["Mega|Fly"] = 141.15, ["Mega|Ride"] = 57.18, ["Mega|Fly|Ride"] = 103.36}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 11.69, ["Fly"] = 91.88, ["Ride"] = 49.85, ["Fly|Ride"] = 165.39, ["Neon"] = 32.79, ["Neon|Fly"] = 342.08, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 141.86, ["Mega"] = 144.38, ["Mega|Fly"] = 282.63, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 297.94}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1299.38, ["Ride"] = 1312.5, ["Fly|Ride"] = 1308.57, ["Neon|Ride"] = 4093.3, ["Neon|Fly|Ride"] = 4064.73, ["Mega"] = 18206.54, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 459.38, ["Ride"] = 481.69, ["Fly|Ride"] = 618.19, ["Neon"] = 2827.18, ["Mega"] = 14231.8, ["Mega|Fly|Ride"] = 7084.87}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 296.83, ["Fly"] = 364.63, ["Ride"] = 341.25, ["Fly|Ride"] = 409.5, ["Neon"] = 735, ["Neon|Fly"] = 1267.31, ["Neon|Ride"] = 623.44, ["Neon|Fly|Ride"] = 759.87, ["Mega|Fly|Ride"] = 2760.63}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 315, ["Fly"] = 335.99, ["Ride"] = 341.24, ["Fly|Ride"] = 473.82, ["Neon"] = 1023.75, ["Neon|Fly"] = 3167.7, ["Neon|Ride"] = 1031.01, ["Neon|Fly|Ride"] = 918.75, ["Mega|Ride"] = 3674.99, ["Mega|Fly|Ride"] = 3656.14}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Ride"] = 17, ["Fly|Ride"] = 28.6, ["Neon"] = 5.36, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 79.41, ["Mega"] = 71.23, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 367.5, ["Fly"] = 446.25, ["Ride"] = 446.25, ["Fly|Ride"] = 472.5, ["Neon"] = 943.95, ["Neon|Ride"] = 1141.88, ["Neon|Fly|Ride"] = 1260, ["Mega"] = 6351.12, ["Mega|Ride"] = 4501.88, ["Mega|Fly|Ride"] = 4357.5}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.1, ["Fly"] = 183.75, ["Ride"] = 25.31, ["Neon"] = 6.57, ["Neon|Fly"] = 71.04, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 112.22, ["Mega"] = 67.96, ["Mega|Ride"] = 99.52, ["Mega|Fly|Ride"] = 218.09}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 21.21, ["Ride"] = 21.21, ["Fly|Ride"] = 39.38, ["Neon"] = 14.27, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 62.99, ["Mega"] = 91.77, ["Mega|Ride"] = 190.55, ["Mega|Fly|Ride"] = 314.62}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 3.82, ["Neon|Fly"] = 79.59, ["Neon|Ride"] = 24.36, ["Mega"] = 20.97, ["Mega|Fly"] = 70.94, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 39.29, ["Ride"] = 65.63, ["Fly|Ride"] = 459.38, ["Neon"] = 244.13, ["Neon|Ride"] = 316.72, ["Mega"] = 1693.64, ["Mega|Ride"] = 1079.71, ["Mega|Fly|Ride"] = 948.81}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 65.61, ["Ride"] = 23.78, ["Fly|Ride"] = 43.32, ["Neon"] = 32.82, ["Mega"] = 328.13, ["Mega|Ride"] = 233.89}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.12, ["Neon"] = 3.94, ["Neon|Fly"] = 106.01, ["Neon|Ride"] = 36.45, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 26.25, ["Mega|Fly"] = 706.05, ["Mega|Ride"] = 64.56, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 19.95, ["Fly|Ride"] = 49.85, ["Neon"] = 6.57, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 30.72, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 61.67, ["Mega|Fly"] = 175.14, ["Mega|Ride"] = 81.35, ["Mega|Fly|Ride"] = 158.94}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 6.33, ["Fly"] = 20.15, ["Ride"] = 32.08, ["Fly|Ride"] = 51.45, ["Neon"] = 71.04, ["Neon|Ride"] = 70.94, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 237.57, ["Mega|Ride"] = 275.23, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 15.75, ["Ride"] = 52.5, ["Neon"] = 84.82, ["Neon|Ride"] = 282.63, ["Mega"] = 353.56, ["Mega|Ride"] = 336.62, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.63, ["Ride"] = 26.17, ["Fly|Ride"] = 71.04, ["Neon"] = 141.75, ["Neon|Ride"] = 79.49, ["Neon|Fly|Ride"] = 282.63, ["Mega"] = 565.26, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 19.67, ["Fly|Ride"] = 55.84, ["Neon"] = 3.93, ["Neon|Ride"] = 47.46, ["Mega"] = 43.32, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 317.57}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 182.44, ["Fly"] = 296.8, ["Ride"] = 258.57, ["Fly|Ride"] = 262.9, ["Neon|Ride"] = 1140.67, ["Neon|Fly|Ride"] = 1102.5, ["Mega"] = 10585.19, ["Mega|Fly|Ride"] = 4488.14}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 20.19, ["Ride"] = 15.74, ["Fly|Ride"] = 41.58, ["Neon"] = 6.38, ["Neon|Fly"] = 53.02, ["Neon|Ride"] = 25.26, ["Neon|Fly|Ride"] = 55.13, ["Mega"] = 54, ["Mega|Ride"] = 74.91, ["Mega|Fly|Ride"] = 106.32}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 6.97, ["Ride"] = 94.5, ["Fly|Ride"] = 180.23, ["Neon"] = 48.78, ["Neon|Ride"] = 105, ["Mega"] = 367.55, ["Mega|Ride"] = 378.96, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 38.06, ["Fly"] = 131.25, ["Ride"] = 50.81, ["Fly|Ride"] = 142.06, ["Neon"] = 220.5, ["Neon|Ride"] = 297.88, ["Mega"] = 842.59, ["Mega|Ride"] = 830.2, ["Mega|Fly|Ride"] = 774.85}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 189, ["Fly"] = 308.44, ["Ride"] = 223.13, ["Fly|Ride"] = 312.73, ["Neon"] = 841.32, ["Neon|Ride"] = 651, ["Neon|Fly|Ride"] = 656.25, ["Mega|Ride"] = 3387.27, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 17.84, ["Fly"] = 168.88, ["Neon"] = 80.57, ["Neon|Ride"] = 282.63, ["Mega"] = 281.58, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 706.05}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 36.91, ["Ride"] = 424.04, ["Fly|Ride"] = 158.82, ["Neon"] = 283.04, ["Neon|Fly|Ride"] = 846.83, ["Mega"] = 1129.46, ["Mega|Fly|Ride"] = 1270.24}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1207.5, ["Fly"] = 1441.13, ["Ride"] = 1150.98, ["Fly|Ride"] = 1200.94, ["Neon|Ride"] = 4657.49, ["Neon|Fly|Ride"] = 4497.64, ["Mega|Fly|Ride"] = 17219.99}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 7.88, ["Fly"] = 25.38, ["Ride"] = 20.57, ["Fly|Ride"] = 35.64, ["Neon"] = 54.08, ["Neon|Fly"] = 75.06, ["Neon|Ride"] = 70.94, ["Neon|Fly|Ride"] = 84.69, ["Mega"] = 224.42, ["Mega|Ride"] = 258.56, ["Mega|Fly|Ride"] = 387.19}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 7.72, ["Fly"] = 13965.68, ["Ride"] = 35.43, ["Neon"] = 36.84, ["Neon|Ride"] = 127.03, ["Neon|Fly|Ride"] = 113.27, ["Mega"] = 212.63, ["Mega|Ride"] = 226.53, ["Mega|Fly|Ride"] = 423.42}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 4.02, ["Ride"] = 59.38, ["Fly|Ride"] = 525, ["Neon"] = 36.74, ["Neon|Ride"] = 118.63, ["Mega"] = 127.32, ["Mega|Ride"] = 268.89, ["Mega|Fly|Ride"] = 621.36}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 19.66, ["Fly"] = 706.99, ["Ride"] = 45.94, ["Fly|Ride"] = 98.76, ["Neon"] = 79.33, ["Neon|Ride"] = 98.98, ["Neon|Fly|Ride"] = 142.37, ["Mega"] = 393.75, ["Mega|Ride"] = 400.58, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 3.93, ["Fly"] = 15.91, ["Ride"] = 20.15, ["Fly|Ride"] = 40.95, ["Neon"] = 22.19, ["Neon|Fly"] = 57.18, ["Neon|Ride"] = 36.01, ["Neon|Fly|Ride"] = 87.87, ["Mega|Ride"] = 273.26, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Neon"] = 11.82, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 56.9, ["Neon|Fly|Ride"] = 111.51, ["Mega"] = 128.88, ["Mega|Ride"] = 131.14, ["Mega|Fly|Ride"] = 388.48}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 157.4, ["Ride"] = 333.38, ["Fly|Ride"] = 283.04, ["Neon|Ride"] = 1693.13, ["Neon|Fly|Ride"] = 1455.48, ["Mega|Ride"] = 5250, ["Mega|Fly|Ride"] = 4940.12}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Ride"] = 28.06, ["Fly|Ride"] = 54.65, ["Neon"] = 11.4, ["Neon|Ride"] = 42.36, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 103.36, ["Mega|Ride"] = 108.68, ["Mega|Fly|Ride"] = 426.97}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 6.39, ["Ride"] = 414.45, ["Neon"] = 42.41, ["Neon|Ride"] = 313.85, ["Mega"] = 279.46, ["Mega|Ride"] = 267.25}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 7.87, ["Fly"] = 58.28, ["Ride"] = 34.13, ["Neon"] = 20.22, ["Neon|Fly"] = 71.04, ["Neon|Ride"] = 127.03, ["Neon|Fly|Ride"] = 280.93, ["Mega"] = 107.63, ["Mega|Fly"] = 423.42, ["Mega|Ride"] = 169.37, ["Mega|Fly|Ride"] = 351.1}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 190.32, ["Fly"] = 339.2, ["Ride"] = 293.81, ["Fly|Ride"] = 636.05, ["Neon"] = 702.83, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 945, ["Mega|Ride"] = 5080.9, ["Mega|Fly|Ride"] = 2098.69}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 25.86, ["Fly"] = 61.49, ["Ride"] = 149.63, ["Fly|Ride"] = 110.27, ["Neon"] = 141.75, ["Neon|Ride"] = 141.86, ["Neon|Fly|Ride"] = 321.81, ["Mega"] = 706.05, ["Mega|Fly|Ride"] = 813.45}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 21, ["Ride"] = 164.07, ["Fly|Ride"] = 1272.09, ["Neon"] = 102.38, ["Neon|Ride"] = 133.88, ["Neon|Fly|Ride"] = 257.25, ["Mega"] = 489.14, ["Mega|Ride"] = 482.57, ["Mega|Fly|Ride"] = 548}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 6.38, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.35, ["Mega"] = 34.73, ["Mega|Ride"] = 277.98, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 71.54, ["Fly"] = 99.65, ["Ride"] = 109.19, ["Fly|Ride"] = 190.05, ["Neon"] = 317.14, ["Neon|Fly"] = 396.48, ["Neon|Ride"] = 396.19, ["Neon|Fly|Ride"] = 391.13, ["Mega|Fly|Ride"] = 1251.9}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 18.8, ["Neon"] = 6.57, ["Neon|Ride"] = 57.18, ["Neon|Fly|Ride"] = 588, ["Mega"] = 38.12, ["Mega|Ride"] = 169.37}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 25.6, ["Fly"] = 36.11, ["Ride"] = 27.57, ["Fly|Ride"] = 61.69, ["Neon"] = 95.04, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 141.86, ["Mega"] = 389.82, ["Mega|Ride"] = 408.19, ["Mega|Fly|Ride"] = 357.54}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 33.34, ["Fly"] = 80.01, ["Ride"] = 70.88, ["Fly|Ride"] = 106.01, ["Neon"] = 230.44, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 318.73, ["Mega|Ride"] = 1833.37, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 15.72, ["Ride"] = 11.82, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 16.97, ["Neon|Ride"] = 16.95, ["Neon|Fly|Ride"] = 42.67, ["Mega"] = 18.38, ["Mega|Fly"] = 55.13, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 74.82}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.1, ["Ride"] = 28.6, ["Fly|Ride"] = 124.69, ["Neon"] = 15.43, ["Neon|Ride"] = 70.94, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 177.19, ["Mega|Ride"] = 268.89, ["Mega|Fly|Ride"] = 206.37}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 17.26, ["Fly"] = 142.05, ["Ride"] = 56.44, ["Neon"] = 150.94, ["Neon|Ride"] = 209.61, ["Neon|Fly|Ride"] = 358.85, ["Mega"] = 586.69, ["Mega|Ride"] = 523.79, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 2.1, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 137.63, ["Mega"] = 19.69, ["Mega|Ride"] = 78.56}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 5.96, ["Fly"] = 210, ["Ride"] = 31.39, ["Fly|Ride"] = 105, ["Neon"] = 64.58, ["Neon|Ride"] = 91.77, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 294.29, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 233.96, ["Mega|Fly|Ride"] = 353.56}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 15.74, ["Fly"] = 42.31, ["Ride"] = 26.17, ["Fly|Ride"] = 46.6, ["Neon"] = 91.18, ["Neon|Ride"] = 64.56, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 676.03}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.89, ["Ride"] = 59.22, ["Fly|Ride"] = 76.01, ["Neon"] = 25.29, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 200.82, ["Mega"] = 170.63, ["Mega|Ride"] = 189.77, ["Mega|Fly|Ride"] = 294.29}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 26.25, ["Fly"] = 2119.87, ["Ride"] = 85.56, ["Neon"] = 131.25, ["Neon|Ride"] = 282.63, ["Neon|Fly|Ride"] = 6324.86, ["Mega"] = 706.05, ["Mega|Ride"] = 438.01, ["Mega|Fly|Ride"] = 1125.49}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 125.58, ["Fly|Ride"] = 196.87, ["Neon"] = 8.99, ["Neon|Fly"] = 50.9, ["Neon|Ride"] = 70.94, ["Neon|Fly|Ride"] = 99.08, ["Mega"] = 74.82, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 137.6}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Mega"] = 20.89, ["Mega|Ride"] = 141.86, ["Mega|Fly|Ride"] = 423.42}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 35.44}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 70.91, ["Fly"] = 102.38, ["Ride"] = 65.63, ["Fly|Ride"] = 207.79, ["Neon"] = 1050, ["Neon|Ride"] = 228.65, ["Neon|Fly|Ride"] = 1058.53, ["Mega"] = 988.67, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 706.05}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 81.38, ["Fly|Ride"] = 142.06, ["Neon"] = 3.03, ["Mega"] = 19.69, ["Mega|Fly"] = 137.82, ["Mega|Ride"] = 105.88, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 539.44, ["Ride"] = 715.6, ["Fly|Ride"] = 656.25, ["Neon"] = 2625, ["Neon|Fly|Ride"] = 2399.67, ["Mega"] = 16936.31, ["Mega|Fly|Ride"] = 14107.95}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 4.56, ["Fly"] = 25.71, ["Ride"] = 42.29, ["Fly|Ride"] = 79.52, ["Neon"] = 79.52, ["Neon|Ride"] = 279.46, ["Mega|Ride"] = 141.86, ["Mega|Fly|Ride"] = 565.26}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 3.93, ["Fly"] = 159.15, ["Ride"] = 23.25, ["Fly|Ride"] = 52.5, ["Neon"] = 16.97, ["Neon|Ride"] = 35.59, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 282.63, ["Mega|Ride"] = 158.05, ["Mega|Fly|Ride"] = 224.42}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 9.19, ["Ride"] = 76.13, ["Fly|Ride"] = 106.31, ["Neon"] = 84.82, ["Neon|Ride"] = 35.97, ["Mega"] = 393.75, ["Mega|Ride"] = 383.25, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.93, ["Fly"] = 39.38, ["Ride"] = 31.5, ["Fly|Ride"] = 142.06, ["Neon"] = 41.35, ["Mega"] = 294.29}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 12.8, ["Ride"] = 44.63, ["Fly|Ride"] = 157.45, ["Neon"] = 74.08, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 350.44, ["Mega"] = 364.07, ["Mega|Ride"] = 388.48, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 7.77, ["Fly"] = 104.98, ["Ride"] = 39.38, ["Fly|Ride"] = 848.06, ["Neon"] = 26.14, ["Neon|Ride"] = 93.17, ["Neon|Fly|Ride"] = 141.86, ["Mega"] = 168, ["Mega|Fly"] = 489.04, ["Mega|Ride"] = 303.19}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 28.64, ["Ride"] = 15.91, ["Fly|Ride"] = 29.09, ["Neon"] = 2.1, ["Neon|Ride"] = 15.89, ["Neon|Fly|Ride"] = 69.66, ["Mega"] = 16.42, ["Mega|Fly"] = 60.38, ["Mega|Ride"] = 62.47, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 8.39, ["Ride"] = 27.57, ["Fly|Ride"] = 159.17, ["Neon"] = 36.75, ["Neon|Fly"] = 118.63, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 317.57, ["Mega"] = 170.63, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 248.07, ["Ride"] = 292.49, ["Fly|Ride"] = 342.41, ["Neon"] = 2120.12, ["Neon|Ride"] = 1107.87, ["Neon|Fly|Ride"] = 1058.53, ["Mega|Fly|Ride"] = 4131.67}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 87.92, ["Fly"] = 156.89, ["Ride"] = 149.63, ["Fly|Ride"] = 7773.4, ["Neon"] = 421.57, ["Neon|Ride"] = 354.38, ["Neon|Fly|Ride"] = 623.44, ["Mega"] = 4234.09, ["Mega|Ride"] = 2117.05, ["Mega|Fly|Ride"] = 1603.88}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 21.21, ["Ride"] = 20.15, ["Fly|Ride"] = 39.35, ["Neon"] = 15.85, ["Neon|Fly"] = 18.38, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 62.67, ["Mega"] = 91.04, ["Mega|Fly"] = 210.66, ["Mega|Ride"] = 92.11, ["Mega|Fly|Ride"] = 141.86}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 16.97, ["Ride"] = 15.91, ["Fly|Ride"] = 28.68, ["Neon"] = 6.39, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 50.82, ["Mega"] = 77.01, ["Mega|Fly"] = 353.56, ["Mega|Ride"] = 93.19, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 3.32, ["Ride"] = 19, ["Fly|Ride"] = 98.44, ["Neon"] = 38.07, ["Neon|Fly|Ride"] = 423.42, ["Mega"] = 1129.46}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 210, ["Ride"] = 249.13, ["Fly|Ride"] = 328.13, ["Neon|Ride"] = 1297.65, ["Neon|Fly|Ride"] = 1248.01, ["Mega|Ride"] = 8468.16, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 23.55, ["Ride"] = 14.44, ["Fly|Ride"] = 35.44, ["Neon"] = 23.63, ["Neon|Fly"] = 159.17, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 75.02, ["Mega"] = 291.12, ["Mega|Ride"] = 251.94, ["Mega|Fly|Ride"] = 262.48}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 5.25, ["Fly"] = 142.53, ["Ride"] = 42.41, ["Fly|Ride"] = 212.02, ["Neon"] = 34.13, ["Neon|Ride"] = 74.79, ["Mega"] = 196.88, ["Mega|Ride"] = 236.24, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 19.1, ["Neon"] = 5.2, ["Neon|Ride"] = 28.77, ["Mega"] = 36.01, ["Mega|Ride"] = 95.7, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 16.22, ["Fly"] = 71.04, ["Ride"] = 26.82, ["Fly|Ride"] = 42.41, ["Neon"] = 139.95, ["Neon|Ride"] = 91.04, ["Neon|Fly|Ride"] = 181.02, ["Mega"] = 728.34, ["Mega|Ride"] = 422.37, ["Mega|Fly|Ride"] = 386.93}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 56.44, ["Fly"] = 116.82, ["Ride"] = 95.91, ["Fly|Ride"] = 249.38, ["Neon"] = 136.5, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 459.38, ["Mega|Fly"] = 2222.91, ["Mega|Ride"] = 458.99, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 28.43, ["Fly"] = 64.15, ["Ride"] = 52.36, ["Fly|Ride"] = 99.53, ["Neon"] = 118.13, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 139.74, ["Neon|Fly|Ride"] = 345.13, ["Mega"] = 706.05, ["Mega|Ride"] = 663.71, ["Mega|Fly|Ride"] = 695.89}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.04, ["Fly"] = 17.07, ["Ride"] = 13.13, ["Fly|Ride"] = 42.41, ["Neon"] = 2.1, ["Neon|Fly"] = 23.55, ["Neon|Ride"] = 21.19, ["Neon|Fly|Ride"] = 62.47, ["Mega"] = 20.98, ["Mega|Fly"] = 28.88, ["Mega|Ride"] = 45.53, ["Mega|Fly|Ride"] = 114.35}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 204.75, ["Fly"] = 278.24, ["Ride"] = 269.22, ["Fly|Ride"] = 317.14, ["Neon"] = 892.5, ["Neon|Ride"] = 958.13, ["Neon|Fly|Ride"] = 1075.47, ["Mega|Fly|Ride"] = 4199.99}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 13.13, ["Fly"] = 140.39, ["Ride"] = 42.2, ["Fly|Ride"] = 131.51, ["Neon"] = 134.65, ["Neon|Ride"] = 226.53, ["Neon|Fly|Ride"] = 210, ["Mega"] = 485.63, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 25.46, ["Ride"] = 18.38, ["Fly|Ride"] = 39.3, ["Neon"] = 6.57, ["Neon|Fly"] = 28.59, ["Neon|Ride"] = 32.04, ["Mega"] = 49.24, ["Mega|Fly"] = 79.41, ["Mega|Ride"] = 99.52, ["Mega|Fly|Ride"] = 221.8}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 17.83, ["Fly|Ride"] = 56.9, ["Neon"] = 2.63, ["Neon|Fly"] = 47.53, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 97.23, ["Mega"] = 26.56, ["Mega|Fly"] = 141.86, ["Mega|Ride"] = 54, ["Mega|Fly|Ride"] = 136.5}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 21.21, ["Fly|Ride"] = 141.75, ["Neon"] = 7.88, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 7057.16, ["Mega"] = 92.93, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 388.48}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 9.19, ["Fly"] = 65.63, ["Ride"] = 28.52, ["Fly|Ride"] = 51.19, ["Neon"] = 56.6, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 354.63, ["Mega|Ride"] = 315.15, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 13.13, ["Ride"] = 26.25, ["Fly|Ride"] = 72.19, ["Neon"] = 39.38, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 236.25, ["Mega|Ride"] = 303.8, ["Mega|Fly|Ride"] = 436.12}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Fly"] = 21.12, ["Ride"] = 65.63, ["Neon"] = 3.94, ["Neon|Ride"] = 35.97, ["Neon|Fly|Ride"] = 94.9, ["Mega"] = 26.1, ["Mega|Ride"] = 77.76, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 7.8, ["Ride"] = 36.05, ["Fly|Ride"] = 84.82, ["Neon"] = 24.94, ["Neon|Fly"] = 102.92, ["Neon|Ride"] = 46.59, ["Neon|Fly|Ride"] = 141.86, ["Mega"] = 157.5, ["Mega|Fly"] = 268.89, ["Mega|Ride"] = 205.37, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 127.21, ["Fly|Ride"] = 99.66, ["Neon"] = 4.77, ["Neon|Fly"] = 84.69, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 158.95, ["Mega"] = 34.13, ["Mega|Fly"] = 282.63, ["Mega|Ride"] = 91.34, ["Mega|Fly|Ride"] = 633.33}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 24.5, ["Ride"] = 17.07, ["Fly|Ride"] = 65.54, ["Neon"] = 6.57, ["Neon|Ride"] = 29.4, ["Neon|Fly|Ride"] = 84.99, ["Mega"] = 103.74, ["Mega|Ride"] = 85.22, ["Mega|Fly|Ride"] = 158.94}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 721.88, ["Ride"] = 702.37, ["Fly|Ride"] = 741.53, ["Neon"] = 3349.79, ["Neon|Ride"] = 3239.08, ["Neon|Fly|Ride"] = 4609.87, ["Mega"] = 11069.98, ["Mega|Fly|Ride"] = 12462.19}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 19.3, ["Fly|Ride"] = 42.41, ["Neon"] = 24.35, ["Neon|Fly"] = 50.9, ["Neon|Ride"] = 57.15, ["Neon|Fly|Ride"] = 99.12, ["Mega"] = 189.49, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.63, ["Ride"] = 54.07, ["Fly|Ride"] = 105.51, ["Neon"] = 8.5, ["Neon|Fly"] = 848.06, ["Neon|Ride"] = 23.3, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 47.45, ["Mega|Fly"] = 141.86, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 181.13}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 10.39, ["Fly"] = 36.12, ["Ride"] = 22.31, ["Fly|Ride"] = 48.78, ["Neon"] = 46.56, ["Neon|Fly"] = 112.74, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 122.07, ["Mega"] = 312.29, ["Mega|Ride"] = 300.83, ["Mega|Fly|Ride"] = 335.99}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 13.02, ["Ride"] = 16.97, ["Fly|Ride"] = 33.94, ["Neon"] = 9.16, ["Neon|Fly"] = 131.17, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 47.16, ["Mega"] = 63.31, ["Mega|Fly"] = 349.84, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 175.14}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 53.82, ["Ride"] = 49.85, ["Neon"] = 285.08, ["Neon|Ride"] = 275.2, ["Neon|Fly|Ride"] = 360.94, ["Mega"] = 887.48, ["Mega|Ride"] = 1412.09}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 25.46, ["Fly|Ride"] = 89.07, ["Neon"] = 5.25, ["Neon|Fly"] = 135.42, ["Neon|Ride"] = 31.77, ["Neon|Fly|Ride"] = 206.07, ["Mega"] = 63.67, ["Mega|Fly"] = 141.86, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 351.75}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 3.65, ["Fly"] = 73.5, ["Ride"] = 23.29, ["Fly|Ride"] = 61.49, ["Neon"] = 15.74, ["Neon|Fly"] = 142.54, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 453.06, ["Mega"] = 91.88, ["Mega|Ride"] = 296.4, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 65.76, ["Neon"] = 15.75, ["Neon|Fly"] = 64.15, ["Mega"] = 113.27, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Ride"] = 20.08, ["Fly|Ride"] = 98.44, ["Neon"] = 4.19, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 29.89, ["Neon|Fly|Ride"] = 68.16, ["Mega"] = 34.13, ["Mega|Fly"] = 156.68, ["Mega|Ride"] = 77.43, ["Mega|Fly|Ride"] = 171.94}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 13.13, ["Fly"] = 21.1, ["Ride"] = 19.1, ["Fly|Ride"] = 35.64, ["Neon"] = 84.82, ["Neon|Ride"] = 73.5, ["Neon|Fly|Ride"] = 115.5, ["Mega"] = 846.83, ["Mega|Ride"] = 387.43, ["Mega|Fly|Ride"] = 434.44}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 761.25, ["Fly"] = 906.25, ["Ride"] = 734.93, ["Fly|Ride"] = 813.75, ["Neon"] = 1938.57, ["Neon|Ride"] = 2201.73, ["Neon|Fly|Ride"] = 1998.94, ["Mega"] = 8235.47, ["Mega|Ride"] = 5397, ["Mega|Fly|Ride"] = 4725}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 19.1, ["Ride"] = 18, ["Fly|Ride"] = 41.88, ["Neon"] = 3.81, ["Neon|Fly"] = 71.04, ["Neon|Ride"] = 21.19, ["Neon|Fly|Ride"] = 60.38, ["Mega"] = 42, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 120.69}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 7.77, ["Ride"] = 38.17, ["Fly|Ride"] = 92.18, ["Neon"] = 56.44, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 248.11, ["Mega"] = 328.13, ["Mega|Ride"] = 351.75}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 69.57, ["Ride"] = 82.69, ["Fly|Ride"] = 144.38, ["Neon|Ride"] = 555.12, ["Neon|Fly|Ride"] = 1240.32, ["Mega"] = 1409.96, ["Mega|Ride"] = 1552.87, ["Mega|Fly|Ride"] = 1612.95}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 39.26, ["Ride"] = 90.57, ["Fly|Ride"] = 317.14, ["Neon"] = 320.25, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 275.23, ["Mega"] = 919.36, ["Mega|Ride"] = 719.81, ["Mega|Fly|Ride"] = 1043.72}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 14.41, ["Ride"] = 64.04, ["Fly|Ride"] = 142.06, ["Neon"] = 78.75, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 402.25, ["Mega"] = 296.4, ["Mega|Ride"] = 367.32, ["Mega|Fly|Ride"] = 360.94}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 32.82, ["Ride"] = 99.75, ["Neon"] = 72.19, ["Neon|Fly"] = 350.39, ["Neon|Ride"] = 364.16, ["Mega"] = 278.75, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 423.42}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 26.06, ["Fly"] = 113.43, ["Ride"] = 106, ["Neon"] = 131.25, ["Neon|Ride"] = 158.82, ["Neon|Fly|Ride"] = 525, ["Mega"] = 924, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 776.96}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 15.75}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 7.86, ["Fly"] = 79.58, ["Ride"] = 32.82, ["Fly|Ride"] = 40.4, ["Neon"] = 32.82, ["Neon|Ride"] = 84.69, ["Neon|Fly|Ride"] = 184.21, ["Mega"] = 189, ["Mega|Fly"] = 237.21, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 270.38}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.1, ["Ride"] = 47.53, ["Neon"] = 31.5, ["Mega"] = 349.89, ["Mega|Fly|Ride"] = 952.68}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 65.63, ["Fly"] = 393.75, ["Ride"] = 86.61, ["Fly|Ride"] = 117.47, ["Neon"] = 303.83, ["Neon|Ride"] = 291.38, ["Neon|Fly|Ride"] = 344.25, ["Mega|Ride"] = 986.55, ["Mega|Fly|Ride"] = 804.49}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 5.92, ["Fly"] = 20.15, ["Ride"] = 16.95, ["Fly|Ride"] = 43.32, ["Neon"] = 28.52, ["Neon|Fly"] = 70.88, ["Neon|Ride"] = 30.79, ["Neon|Fly|Ride"] = 77.12, ["Mega"] = 262.5, ["Mega|Fly"] = 423.42, ["Mega|Ride"] = 274.18, ["Mega|Fly|Ride"] = 255.18}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 6.22, ["Fly"] = 84.81, ["Ride"] = 31.49, ["Fly|Ride"] = 72.19, ["Neon"] = 24.66, ["Neon|Ride"] = 36.14, ["Neon|Fly|Ride"] = 131.8, ["Mega"] = 143.98, ["Mega|Ride"] = 171.94, ["Mega|Fly|Ride"] = 252.45}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 4.26, ["Neon|Ride"] = 201.66, ["Mega"] = 34.13, ["Mega|Ride"] = 140.38, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 32.82, ["Fly"] = 84.81, ["Ride"] = 61.6, ["Fly|Ride"] = 78.74, ["Neon"] = 131.25, ["Neon|Ride"] = 240.3, ["Neon|Fly|Ride"] = 282.63, ["Mega"] = 1129.46, ["Mega|Ride"] = 838.03}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 23.78, ["Fly|Ride"] = 84.82, ["Neon"] = 10.5, ["Neon|Ride"] = 70.94, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 141.86, ["Mega|Fly|Ride"] = 309.68}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 11.82, ["Ride"] = 37.11, ["Neon"] = 82.69, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 350.39, ["Mega"] = 288.75, ["Mega|Ride"] = 494.34, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 18.87, ["Ride"] = 15.75, ["Fly|Ride"] = 28.88, ["Neon"] = 21, ["Neon|Ride"] = 23.26, ["Neon|Fly|Ride"] = 78.21, ["Mega"] = 197.95, ["Mega|Ride"] = 232.98, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 5.65, ["Fly"] = 52.5, ["Ride"] = 24.4, ["Fly|Ride"] = 52.5, ["Neon"] = 67.86, ["Neon|Ride"] = 177.19, ["Mega"] = 277.35, ["Mega|Ride"] = 247.7, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.93, ["Ride"] = 36.53, ["Neon"] = 28.41, ["Neon|Ride"] = 262.5, ["Mega"] = 91.88, ["Mega|Ride"] = 771.1}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 38.84, ["Fly"] = 57.26, ["Ride"] = 91.88, ["Neon"] = 210.58, ["Neon|Fly"] = 240.65, ["Neon|Ride"] = 240.3, ["Mega"] = 1057.48, ["Mega|Ride"] = 1412.09, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 23.63, ["Ride"] = 281.6, ["Neon"] = 210, ["Mega"] = 515.32, ["Mega|Fly|Ride"] = 570.29}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 7.87, ["Fly"] = 38.18, ["Ride"] = 89.15, ["Fly|Ride"] = 283.04, ["Neon"] = 99.66, ["Neon|Ride"] = 393.75, ["Mega"] = 592.78, ["Mega|Ride"] = 557.85, ["Mega|Fly|Ride"] = 1693.64}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 24.87, ["Ride"] = 76.34, ["Fly|Ride"] = 142.06, ["Neon"] = 142.06, ["Neon|Ride"] = 635.13, ["Mega"] = 813.75, ["Mega|Ride"] = 988.67, ["Mega|Fly|Ride"] = 965.41}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 5.8, ["Neon"] = 42.78, ["Neon|Ride"] = 423.42, ["Mega"] = 281.58, ["Mega|Fly|Ride"] = 316.67}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 21.21, ["Ride"] = 17.71, ["Fly|Ride"] = 41.91, ["Neon"] = 4.26, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 28.6, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 52.5, ["Mega|Ride"] = 89.25, ["Mega|Fly|Ride"] = 186.8}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 14.44, ["Ride"] = 42.41, ["Neon"] = 23.63, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 61.41, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 184.21, ["Mega|Ride"] = 195.32, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 17.05, ["Fly|Ride"] = 55.13, ["Neon"] = 5.18, ["Neon|Ride"] = 25.41, ["Neon|Fly|Ride"] = 91.04, ["Mega"] = 53.11, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 144.12}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.93, ["Fly"] = 131.25, ["Ride"] = 64.15, ["Fly|Ride"] = 99.66, ["Neon"] = 39.37, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 113.27, ["Mega"] = 222.31, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 474.42}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 6.57, ["Ride"] = 32.82, ["Fly|Ride"] = 99.75, ["Neon"] = 44.55, ["Neon|Fly"] = 475.11, ["Neon|Ride"] = 97.39, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 383.2, ["Mega|Ride"] = 416.8, ["Mega|Fly|Ride"] = 948.81}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 6.34, ["Fly"] = 24.39, ["Ride"] = 28.64, ["Fly|Ride"] = 57.26, ["Neon"] = 21.21, ["Neon|Fly"] = 104.77, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 100.51, ["Mega"] = 222.87, ["Mega|Ride"] = 251.99, ["Mega|Fly|Ride"] = 388.73}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.63, ["Fly"] = 34.07, ["Ride"] = 18.38, ["Fly|Ride"] = 63.62, ["Neon"] = 28.64, ["Neon|Fly"] = 84.82, ["Neon|Ride"] = 42.36, ["Neon|Fly|Ride"] = 105.88, ["Mega"] = 141.8, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 347.22}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 9.19, ["Fly"] = 301.88, ["Ride"] = 36.05, ["Fly|Ride"] = 179.82, ["Neon"] = 23.34, ["Neon|Fly"] = 436.96, ["Neon|Ride"] = 99.52, ["Neon|Fly|Ride"] = 141.86, ["Mega"] = 99.96, ["Mega|Ride"] = 152.09, ["Mega|Fly|Ride"] = 310.03}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 13.13, ["Fly"] = 105, ["Ride"] = 94.5, ["Fly|Ride"] = 272.4, ["Neon"] = 95.82, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 486.93, ["Mega"] = 367.5, ["Mega|Ride"] = 440.9, ["Mega|Fly|Ride"] = 555.36}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 63.72, ["Fly"] = 222.1, ["Ride"] = 95.96, ["Fly|Ride"] = 212.02, ["Neon"] = 240.65, ["Neon|Ride"] = 269.07, ["Neon|Fly|Ride"] = 388.84, ["Mega"] = 1050, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1001.56}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 51.01, ["Ride"] = 25.46, ["Fly|Ride"] = 65.54, ["Neon"] = 3.35, ["Neon|Ride"] = 37.95, ["Neon|Fly|Ride"] = 58.35, ["Mega"] = 27.28, ["Mega|Ride"] = 71.14, ["Mega|Fly|Ride"] = 115.55}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 15.69, ["Neon"] = 281.59, ["Mega"] = 423.42, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 1266}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 55.13, ["Fly"] = 105, ["Ride"] = 116.82, ["Neon"] = 189.62, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 423.42, ["Mega|Ride"] = 1115.69, ["Mega|Fly|Ride"] = 1270.24}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 7.88, ["Fly"] = 190.32, ["Ride"] = 38.18, ["Fly|Ride"] = 126, ["Neon"] = 40.58, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 211.72, ["Mega"] = 215.22, ["Mega|Ride"] = 229.69, ["Mega|Fly|Ride"] = 394.42}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Fly"] = 23.34, ["Ride"] = 19.69, ["Fly|Ride"] = 82.7, ["Neon"] = 5.24, ["Neon|Ride"] = 31.49, ["Mega"] = 32.51, ["Mega|Ride"] = 55.76, ["Mega|Fly|Ride"] = 153.61}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 47.53, ["Ride"] = 21.21, ["Fly|Ride"] = 50.33, ["Neon"] = 15.74, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 112.88, ["Mega"] = 156.68, ["Mega|Fly"] = 423.42, ["Mega|Ride"] = 141.86, ["Mega|Fly|Ride"] = 245.59}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 19.1, ["Ride"] = 15.91, ["Fly|Ride"] = 32.88, ["Neon"] = 2.63, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 59.3, ["Mega"] = 34.13, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Fly"] = 42.41, ["Ride"] = 26.25, ["Fly|Ride"] = 28.64, ["Neon"] = 3.94, ["Neon|Ride"] = 28.6, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 39.38, ["Mega|Fly"] = 168, ["Mega|Ride"] = 63.52, ["Mega|Fly|Ride"] = 202.61}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 159.17, ["Neon"] = 2.5, ["Neon|Ride"] = 126.27, ["Mega"] = 23.37, ["Mega|Ride"] = 105.88, ["Mega|Fly|Ride"] = 260.4}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 15.89, ["Ride"] = 31.4, ["Fly|Ride"] = 262.5, ["Neon"] = 42.35, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 209.61, ["Mega"] = 202.19, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 334.51}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 51.18, ["Ride"] = 32.88, ["Fly|Ride"] = 267.25, ["Neon"] = 124.69, ["Neon|Ride"] = 103.22, ["Neon|Fly|Ride"] = 236.06, ["Mega"] = 315, ["Mega|Fly|Ride"] = 635.7}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 6.13, ["Fly"] = 24.33, ["Ride"] = 22.32, ["Fly|Ride"] = 48.19, ["Neon"] = 54.08, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 54, ["Neon|Fly|Ride"] = 86.37, ["Mega|Ride"] = 334.69, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 74.59, ["Ride"] = 144.37, ["Fly|Ride"] = 262.5, ["Neon"] = 538.13, ["Mega"] = 3163.04, ["Mega|Fly|Ride"] = 1574.04}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 25.86, ["Fly"] = 72.43, ["Ride"] = 42.41, ["Fly|Ride"] = 59.07, ["Neon"] = 57.75, ["Mega"] = 633.33, ["Mega|Ride"] = 211.72, ["Mega|Fly|Ride"] = 1033.6}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 17.93, ["Ride"] = 15.74, ["Fly|Ride"] = 28.88, ["Neon"] = 2.76, ["Neon|Fly"] = 28.64, ["Neon|Ride"] = 21.19, ["Neon|Fly|Ride"] = 69.57, ["Mega|Ride"] = 94.65, ["Mega|Fly|Ride"] = 108.94}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 15.88, ["Ride"] = 16.97, ["Fly|Ride"] = 31.5, ["Neon"] = 4.13, ["Neon|Fly"] = 15.75, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 40.21, ["Mega"] = 41.52, ["Mega|Ride"] = 57.18, ["Mega|Fly|Ride"] = 98.85}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 393.75, ["Ride"] = 433.13, ["Fly|Ride"] = 477.58, ["Neon|Ride"] = 1772.1, ["Neon|Fly|Ride"] = 1509.38}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 16.97, ["Fly|Ride"] = 170.63, ["Neon"] = 103.68, ["Mega"] = 317.57, ["Mega|Ride"] = 607.6, ["Mega|Fly|Ride"] = 1269.18}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 16.97, ["Ride"] = 15.91, ["Fly|Ride"] = 28.64, ["Neon"] = 4.26, ["Neon|Fly"] = 28.64, ["Neon|Ride"] = 20.74, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 43.32, ["Mega|Ride"] = 66.7, ["Mega|Fly|Ride"] = 105.46}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 78.75, ["Ride"] = 137.68, ["Fly|Ride"] = 315, ["Neon"] = 242.82, ["Neon|Ride"] = 303.17, ["Neon|Fly|Ride"] = 425.52, ["Mega"] = 737.63, ["Mega|Ride"] = 748.13, ["Mega|Fly|Ride"] = 910.34}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 21.21, ["Ride"] = 19.1, ["Fly|Ride"] = 55.12, ["Neon"] = 15.75, ["Neon|Fly"] = 99.66, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 72.16, ["Mega"] = 106.75, ["Mega|Fly"] = 160.13, ["Mega|Ride"] = 111.65, ["Mega|Fly|Ride"] = 196.87}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 71.04, ["Ride"] = 47.25, ["Fly|Ride"] = 1312.5, ["Neon"] = 2.1, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 283.19, ["Mega"] = 19.69, ["Mega|Fly"] = 141.86, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 51.17, ["Fly"] = 142.05, ["Ride"] = 90.57, ["Neon"] = 185.07, ["Neon|Ride"] = 206.4, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1270.24, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 805.87}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 21.86, ["Fly|Ride"] = 39.38, ["Neon"] = 6.56, ["Neon|Ride"] = 55.06, ["Mega"] = 103.69, ["Mega|Ride"] = 121.73, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 36.75, ["Ride"] = 63, ["Neon"] = 268.88, ["Neon|Ride"] = 199.02, ["Neon|Fly|Ride"] = 421.31, ["Mega|Ride"] = 1693.64, ["Mega|Fly|Ride"] = 1056.42}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 10.59, ["Fly|Ride"] = 212.02, ["Neon"] = 26.14, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 423.42, ["Mega"] = 175.88, ["Mega|Ride"] = 603.75, ["Mega|Fly|Ride"] = 551.92}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 3.68, ["Fly"] = 71.04, ["Ride"] = 71.04, ["Fly|Ride"] = 65.63, ["Neon"] = 10.5, ["Neon|Fly"] = 78.46, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 109.14, ["Mega"] = 64.05, ["Mega|Ride"] = 728.43, ["Mega|Fly|Ride"] = 565.26}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 30.96, ["Ride"] = 56.35, ["Fly|Ride"] = 104.9, ["Neon"] = 159.17, ["Neon|Ride"] = 131.25, ["Mega|Ride"] = 2040.94, ["Mega|Fly|Ride"] = 1110.38}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 144.82, ["Ride"] = 45.6, ["Fly|Ride"] = 908.98, ["Neon"] = 6.56, ["Neon|Ride"] = 54, ["Neon|Fly|Ride"] = 163.02, ["Mega"] = 45.29, ["Mega|Fly"] = 158.61, ["Mega|Ride"] = 90.36, ["Mega|Fly|Ride"] = 159.29}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 57.26, ["Ride"] = 28.64, ["Fly|Ride"] = 102.82, ["Neon"] = 6.2, ["Neon|Fly"] = 41.88, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 99.52, ["Mega"] = 168, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 290.05}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 10.54, ["Ride"] = 50.9, ["Fly|Ride"] = 190.05, ["Neon"] = 77.18, ["Neon|Ride"] = 120.75, ["Mega"] = 311.07, ["Mega|Ride"] = 393.79, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 41.85, ["Ride"] = 87.36, ["Fly|Ride"] = 142.44, ["Neon"] = 156.19, ["Neon|Ride"] = 189.49, ["Neon|Fly|Ride"] = 377.55, ["Mega"] = 656.24, ["Mega|Ride"] = 718.65, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 35.63, ["Fly"] = 131.25, ["Ride"] = 35.38, ["Fly|Ride"] = 77.44, ["Neon"] = 103.69, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 141.86, ["Mega"] = 620.57, ["Mega|Ride"] = 388.5, ["Mega|Fly|Ride"] = 282.63}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 74.84, ["Ride"] = 127.21, ["Fly|Ride"] = 196.85, ["Neon"] = 283.5, ["Neon|Ride"] = 320.62, ["Neon|Fly|Ride"] = 423.42, ["Mega|Ride"] = 1273.13, ["Mega|Fly|Ride"] = 1242.93}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 4.59, ["Ride"] = 35.44, ["Fly|Ride"] = 288.75, ["Neon"] = 18.26, ["Neon|Ride"] = 48.7, ["Neon|Fly|Ride"] = 305.76, ["Mega"] = 141.86, ["Mega|Ride"] = 211.72, ["Mega|Fly|Ride"] = 330.1}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 5.98, ["Ride"] = 24.91, ["Fly|Ride"] = 106.01, ["Neon"] = 25.46, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 134.46, ["Mega"] = 203.44, ["Mega|Ride"] = 184.21}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 12.75, ["Fly"] = 28.88, ["Ride"] = 40.69, ["Fly|Ride"] = 98.95, ["Neon"] = 133.59, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 169.37, ["Mega"] = 317.57, ["Mega|Ride"] = 321.81, ["Mega|Fly|Ride"] = 452.82}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 10.5, ["Fly|Ride"] = 31.4, ["Neon"] = 2.1, ["Neon|Fly"] = 17.05, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 45.85, ["Mega"] = 15.72, ["Mega|Fly"] = 70.94, ["Mega|Ride"] = 22.16, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 59.07, ["Fly"] = 91.88, ["Ride"] = 170.63, ["Fly|Ride"] = 303.01, ["Neon"] = 238.33, ["Neon|Fly"] = 2403.16, ["Neon|Ride"] = 275.23, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 942.1, ["Mega|Ride"] = 807.19, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 17.07, ["Fly|Ride"] = 110.27, ["Neon"] = 4.26, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 42.71, ["Mega|Ride"] = 67.76, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 19.69, ["Fly|Ride"] = 61.49, ["Neon"] = 15.65, ["Neon|Fly"] = 142.06, ["Neon|Ride"] = 32.44, ["Neon|Fly|Ride"] = 71.09, ["Mega"] = 118.13, ["Mega|Ride"] = 418.14, ["Mega|Fly|Ride"] = 282.63}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 84.82, ["Ride"] = 105, ["Fly|Ride"] = 320.31, ["Neon"] = 275.63, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 511.88, ["Mega"] = 1019.82, ["Mega|Ride"] = 1048.69, ["Mega|Fly|Ride"] = 1009.32}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 42.41, ["Neon"] = 5.17, ["Neon|Ride"] = 42.84, ["Mega"] = 51.18, ["Mega|Ride"] = 129.9, ["Mega|Fly|Ride"] = 268.89}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 15.75}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 28.64, ["Fly|Ride"] = 321.9, ["Neon"] = 6.57, ["Neon|Ride"] = 65.65, ["Neon|Fly|Ride"] = 142.35, ["Mega"] = 44.58, ["Mega|Ride"] = 116.18, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 127.31, ["Ride"] = 157.5, ["Fly|Ride"] = 236.25, ["Neon"] = 538.13, ["Neon|Ride"] = 663.71, ["Neon|Fly|Ride"] = 577.5, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.94, ["Ride"] = 25.5, ["Neon"] = 40.29, ["Neon|Ride"] = 45.53, ["Neon|Fly|Ride"] = 110.1, ["Mega"] = 165.37, ["Mega|Fly|Ride"] = 453.06}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Neon"] = 4.6, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 45.42, ["Mega|Ride"] = 128.21, ["Mega|Fly|Ride"] = 141.86}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 6.57, ["Ride"] = 30.9, ["Neon"] = 51.1, ["Neon|Ride"] = 113.27, ["Neon|Fly|Ride"] = 156.68, ["Mega"] = 853.13, ["Mega|Ride"] = 635.13, ["Mega|Fly|Ride"] = 633.33}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 15.65, ["Fly"] = 26.25, ["Ride"] = 26.22, ["Fly|Ride"] = 38.11, ["Neon"] = 79.75, ["Neon|Ride"] = 91.04, ["Neon|Fly|Ride"] = 147.08, ["Mega"] = 460.04, ["Mega|Ride"] = 238.18, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 26.25, ["Ride"] = 89.1, ["Neon"] = 196.88, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 480.41, ["Mega"] = 656.25, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 141.8, ["Fly"] = 170.63, ["Ride"] = 169.99, ["Fly|Ride"] = 221.82, ["Neon"] = 537.91, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 10.48, ["Fly"] = 19.66, ["Ride"] = 19.69, ["Fly|Ride"] = 39.38, ["Neon"] = 71.04, ["Neon|Fly"] = 423.42, ["Neon|Ride"] = 52.14, ["Neon|Fly|Ride"] = 94.49, ["Mega|Ride"] = 298.52, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 3.93, ["Fly"] = 131.23, ["Ride"] = 23.78, ["Fly|Ride"] = 131.25, ["Neon"] = 8.5, ["Neon|Ride"] = 35.69, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 137.82, ["Mega|Fly|Ride"] = 353.56}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 10.5, ["Fly"] = 210, ["Ride"] = 42.5, ["Neon"] = 106.01, ["Neon|Ride"] = 141.86, ["Mega"] = 380.63, ["Mega|Fly|Ride"] = 562.09}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 42, ["Fly"] = 57.26, ["Ride"] = 74.82, ["Fly|Ride"] = 159.17, ["Neon"] = 230.72, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 281.58, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 15.62, ["Ride"] = 81.86, ["Neon"] = 91.88, ["Neon|Ride"] = 126.62, ["Mega"] = 643.13, ["Mega|Ride"] = 740.98, ["Mega|Fly|Ride"] = 1041.59}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 309.75, ["Ride"] = 392.19, ["Neon"] = 2403.16, ["Neon|Ride"] = 1115.63, ["Neon|Fly|Ride"] = 1045.84, ["Mega|Fly|Ride"] = 4375.93}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 32.54, ["Fly"] = 65.63, ["Ride"] = 41.97, ["Fly|Ride"] = 79.74, ["Neon"] = 198.24, ["Neon|Ride"] = 226.44, ["Neon|Fly|Ride"] = 324.98, ["Mega"] = 984.38, ["Mega|Ride"] = 843.94, ["Mega|Fly|Ride"] = 856.24}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 28.64, ["Ride"] = 14.44, ["Fly|Ride"] = 28.59, ["Neon"] = 2.47, ["Neon|Ride"] = 16.99, ["Neon|Fly|Ride"] = 55.65, ["Mega"] = 22.2, ["Mega|Fly"] = 107.99, ["Mega|Ride"] = 44.55, ["Mega|Fly|Ride"] = 108.82}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 3.94, ["Ride"] = 211.02, ["Neon"] = 21.1, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 126.97, ["Mega"] = 139.74, ["Mega|Fly"] = 124.69, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 373.42}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 6.38, ["Ride"] = 33.94, ["Fly|Ride"] = 129.94, ["Neon"] = 14.6, ["Neon|Ride"] = 78.26, ["Neon|Fly|Ride"] = 168.32, ["Mega"] = 130.85, ["Mega|Fly"] = 494.34, ["Mega|Ride"] = 282.63, ["Mega|Fly|Ride"] = 301.26}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 354.38, ["Fly"] = 632.63, ["Ride"] = 393.65, ["Fly|Ride"] = 513.65, ["Neon"] = 1555.12, ["Neon|Ride"] = 1349.63, ["Neon|Fly|Ride"] = 1408.91, ["Mega|Fly|Ride"] = 4822.63}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 3.56, ["Fly"] = 47.59, ["Ride"] = 19.47, ["Fly|Ride"] = 42.21, ["Neon"] = 24.94, ["Neon|Ride"] = 28.6, ["Neon|Fly|Ride"] = 71.18, ["Mega|Ride"] = 270.83, ["Mega|Fly|Ride"] = 423.42}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 6.17, ["Fly"] = 31.82, ["Ride"] = 23.78, ["Fly|Ride"] = 39.38, ["Neon"] = 27.58, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 57.18, ["Neon|Fly|Ride"] = 84.69, ["Mega"] = 423.42, ["Mega|Ride"] = 706.05, ["Mega|Fly|Ride"] = 249.83}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 4.17, ["Fly"] = 36.05, ["Ride"] = 27.58, ["Fly|Ride"] = 65.63, ["Neon"] = 19, ["Neon|Fly"] = 159.17, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 120.74, ["Mega"] = 121.36, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 57.15, ["Fly"] = 210, ["Ride"] = 71.04, ["Fly|Ride"] = 59.07, ["Neon"] = 118.13, ["Neon|Fly"] = 146.3, ["Neon|Ride"] = 184.21, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 952.68, ["Mega|Ride"] = 844.72, ["Mega|Fly|Ride"] = 507.62}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 31.35, ["Ride"] = 20.9, ["Fly|Ride"] = 52.9, ["Neon"] = 19.04, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 210, ["Mega"] = 137.82, ["Mega|Ride"] = 184.21, ["Mega|Fly|Ride"] = 952.23}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 5.25, ["Fly"] = 104.15, ["Ride"] = 28.86, ["Fly|Ride"] = 71.04, ["Neon"] = 113.24, ["Neon|Ride"] = 105.83, ["Mega|Ride"] = 602.81, ["Mega|Fly|Ride"] = 731.46}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 40.69, ["Neon"] = 3.92, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 28.59, ["Mega"] = 36.75, ["Mega|Ride"] = 121.75, ["Mega|Fly|Ride"] = 282.63}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 9.6, ["Ride"] = 57.26, ["Neon"] = 42.41, ["Neon|Ride"] = 70.94, ["Mega"] = 317.57, ["Mega|Fly|Ride"] = 846.83}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 15.74, ["Ride"] = 57.39, ["Fly|Ride"] = 205.67, ["Neon"] = 83.01, ["Neon|Ride"] = 94.9, ["Mega"] = 453.06, ["Mega|Ride"] = 558.91, ["Mega|Fly|Ride"] = 497.53}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 11.8, ["Fly"] = 36.05, ["Ride"] = 23.63, ["Fly|Ride"] = 53.28, ["Neon"] = 55.13, ["Neon|Fly"] = 59.07, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 106.26, ["Mega"] = 412.84, ["Mega|Ride"] = 375.38, ["Mega|Fly|Ride"] = 379.4}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 150.94, ["Fly"] = 205.24, ["Ride"] = 194.23, ["Fly|Ride"] = 237.56, ["Neon"] = 856.54, ["Neon|Ride"] = 876.47, ["Neon|Fly|Ride"] = 842.59, ["Mega|Fly|Ride"] = 4206.57}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Fly"] = 27.58, ["Ride"] = 16.97, ["Fly|Ride"] = 64.15, ["Neon"] = 12.5, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 42, ["Mega"] = 220.5, ["Mega|Ride"] = 165.15, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.82, ["Fly"] = 42.41, ["Ride"] = 17.07, ["Fly|Ride"] = 103.79, ["Neon"] = 9.52, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 166.69, ["Mega"] = 244.61, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 419.2}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 47.25, ["Fly"] = 126, ["Ride"] = 105, ["Fly|Ride"] = 401.78, ["Neon"] = 141.75, ["Neon|Ride"] = 204.67, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 399, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 435.75}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 91.86, ["Fly"] = 141.62, ["Ride"] = 126.16, ["Fly|Ride"] = 261.18, ["Neon"] = 530.04, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 550.45, ["Mega"] = 1693.64, ["Mega|Ride"] = 1539.11, ["Mega|Fly|Ride"] = 1648.5}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 52.5, ["Ride"] = 100.71, ["Fly|Ride"] = 197.18, ["Neon"] = 89.25, ["Neon|Ride"] = 137.81, ["Neon|Fly|Ride"] = 277.56, ["Mega"] = 253.32, ["Mega|Ride"] = 321.41, ["Mega|Fly|Ride"] = 450.19}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.22, ["Fly|Ride"] = 46.5, ["Neon"] = 15.65, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 57.46, ["Mega|Ride"] = 184.21, ["Mega|Fly|Ride"] = 353.56}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 16.1, ["Ride"] = 42.41, ["Fly|Ride"] = 9187.5, ["Neon"] = 84.82, ["Neon|Ride"] = 127.03, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 217.88, ["Mega|Ride"] = 285.48, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 76.13, ["Ride"] = 119.64, ["Fly|Ride"] = 188.71, ["Neon"] = 196.88, ["Neon|Ride"] = 289.44, ["Neon|Fly|Ride"] = 472.12, ["Mega"] = 557.82, ["Mega|Ride"] = 550.45, ["Mega|Fly|Ride"] = 582.74}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 120.86, ["Neon"] = 5.25, ["Neon|Fly"] = 71.04, ["Neon|Ride"] = 104.74, ["Neon|Fly|Ride"] = 150.56, ["Mega"] = 52.41, ["Mega|Fly"] = 163.02, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 422.37}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 11.54, ["Ride"] = 236.38, ["Neon"] = 59.07, ["Mega"] = 368.16, ["Mega|Fly|Ride"] = 624.24}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 977.81, ["Fly"] = 1342.94, ["Ride"] = 1125.1, ["Fly|Ride"] = 1181.25, ["Neon|Ride"] = 3937.5, ["Neon|Fly|Ride"] = 3171.37, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 37.98, ["Fly"] = 79.58, ["Ride"] = 111.56, ["Fly|Ride"] = 237.56, ["Neon"] = 213.81, ["Neon|Ride"] = 402.25, ["Neon|Fly|Ride"] = 381.08, ["Mega"] = 673.24, ["Mega|Ride"] = 840, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 6.3, ["Fly"] = 49.12, ["Ride"] = 31.82, ["Fly|Ride"] = 99.75, ["Neon"] = 17, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 45.52, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 87.94, ["Mega|Ride"] = 108.94, ["Mega|Fly|Ride"] = 240.3}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 9.19, ["Ride"] = 131.22, ["Neon"] = 106.32, ["Neon|Ride"] = 156.68, ["Mega"] = 338.73, ["Mega|Ride"] = 536.68, ["Mega|Fly|Ride"] = 924}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 15.91, ["Fly|Ride"] = 424.04, ["Neon"] = 2.1, ["Neon|Ride"] = 21.19, ["Neon|Fly|Ride"] = 99.48, ["Mega"] = 19.69, ["Mega|Fly"] = 125.97, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 550.45}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 52.5, ["Ride"] = 123.38, ["Fly|Ride"] = 304.25, ["Neon"] = 322.05, ["Neon|Ride"] = 361.23, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 1141.96, ["Mega|Ride"] = 988.67, ["Mega|Fly|Ride"] = 1049.9}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 4.15, ["Fly"] = 101.07, ["Ride"] = 52.5, ["Fly|Ride"] = 84.67, ["Neon"] = 35.35, ["Neon|Ride"] = 47.38, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 350.44, ["Mega|Ride"] = 306.08, ["Mega|Fly|Ride"] = 304.87}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.81, ["Fly"] = 65.63, ["Ride"] = 27.3, ["Neon"] = 11.82, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 141.86, ["Mega"] = 141.86, ["Mega|Ride"] = 231.82, ["Mega|Fly|Ride"] = 374.73}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 55.13, ["Ride"] = 113.45, ["Fly|Ride"] = 167.63, ["Neon"] = 118.02, ["Neon|Fly"] = 280.65, ["Neon|Ride"] = 141.86, ["Neon|Fly|Ride"] = 635.13, ["Mega"] = 535.5, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 731.46}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 31.82, ["Ride"] = 84.81, ["Fly|Ride"] = 196.88, ["Neon"] = 124.69, ["Neon|Ride"] = 179.96, ["Neon|Fly|Ride"] = 315, ["Mega"] = 565.26, ["Mega|Fly|Ride"] = 1090.46}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 49.23, ["Ride"] = 99.65, ["Neon"] = 774.38, ["Neon|Ride"] = 565.26, ["Neon|Fly|Ride"] = 1083.49, ["Mega"] = 2470.6, ["Mega|Ride"] = 1977.32, ["Mega|Fly|Ride"] = 2117.05}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 10.42, ["Neon"] = 20.15, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 118.52, ["Mega|Fly"] = 141.86, ["Mega|Ride"] = 135.19, ["Mega|Fly|Ride"] = 279.46}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 9.19, ["Fly"] = 38.18, ["Ride"] = 26.25, ["Fly|Ride"] = 63.62, ["Neon"] = 64.04, ["Neon|Ride"] = 79.49, ["Neon|Fly|Ride"] = 142.35, ["Mega"] = 399, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 523.98}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 137.55, ["Ride"] = 179.82, ["Fly|Ride"] = 236.25, ["Neon"] = 551.25, ["Neon|Fly"] = 664.67, ["Neon|Ride"] = 567, ["Neon|Fly|Ride"] = 602.43, ["Mega|Ride"] = 2258.89, ["Mega|Fly|Ride"] = 1903.13}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 19.02, ["Ride"] = 18.27, ["Fly|Ride"] = 45.18, ["Neon"] = 8.47, ["Neon|Fly"] = 64.31, ["Neon|Ride"] = 27.19, ["Neon|Fly|Ride"] = 77.35, ["Mega"] = 140.44, ["Mega|Ride"] = 136.4, ["Mega|Fly|Ride"] = 253}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 5.46, ["Fly"] = 87.94, ["Ride"] = 22.31, ["Fly|Ride"] = 67.86, ["Neon"] = 36.84, ["Neon|Fly"] = 281.17, ["Neon|Ride"] = 49.76, ["Neon|Fly|Ride"] = 125.97, ["Mega"] = 210, ["Mega|Ride"] = 207.48, ["Mega|Fly|Ride"] = 291.4}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Ride"] = 18.38, ["Fly|Ride"] = 36.04, ["Neon"] = 2.1, ["Neon|Fly"] = 16.7, ["Neon|Ride"] = 18.96, ["Neon|Fly|Ride"] = 49.88, ["Mega"] = 15.63, ["Mega|Fly"] = 32.03, ["Mega|Ride"] = 30.72, ["Mega|Fly|Ride"] = 99.52}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Fly"] = 21.21, ["Ride"] = 31.82, ["Neon"] = 2.63, ["Neon|Fly"] = 42.41, ["Neon|Ride"] = 40.24, ["Mega"] = 22.77, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 141.86}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 3.92, ["Fly"] = 131.25, ["Ride"] = 27.58, ["Fly|Ride"] = 45.94, ["Neon"] = 22.58, ["Neon|Ride"] = 47.46, ["Mega"] = 134.46, ["Mega|Ride"] = 152.3}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 55.14, ["Ride"] = 84, ["Neon"] = 262.9, ["Neon|Ride"] = 451.5, ["Neon|Fly|Ride"] = 630, ["Mega"] = 634.9, ["Mega|Fly|Ride"] = 663.71}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.83, ["Fly"] = 20.19, ["Ride"] = 17.05, ["Fly|Ride"] = 38.07, ["Neon"] = 9.16, ["Neon|Fly"] = 35.97, ["Neon|Ride"] = 28.6, ["Neon|Fly|Ride"] = 53.81, ["Mega"] = 91.68, ["Mega|Fly"] = 164.06, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 6.14, ["Fly"] = 28.22, ["Ride"] = 22.32, ["Fly|Ride"] = 39.38, ["Neon"] = 15.65, ["Neon|Fly"] = 36.05, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 78.62, ["Mega"] = 131.34, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 213.26}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 3.82, ["Fly"] = 19.59, ["Ride"] = 18.21, ["Fly|Ride"] = 99.66, ["Neon"] = 8.5, ["Neon|Fly"] = 47.53, ["Neon|Ride"] = 23.73, ["Neon|Fly|Ride"] = 79.48, ["Mega"] = 48.7, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 77.44, ["Mega|Fly|Ride"] = 119.47}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 11.46, ["Fly"] = 281.96, ["Ride"] = 24.85, ["Neon"] = 26.25, ["Neon|Ride"] = 84.69, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 296.4, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 317.46, ["Mega|Fly|Ride"] = 633.33}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 7.86, ["Fly"] = 154.76, ["Ride"] = 65.98, ["Neon"] = 99.48, ["Neon|Ride"] = 92.11, ["Mega"] = 411.55, ["Mega|Fly|Ride"] = 1058.53}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.91, ["Fly"] = 35.44, ["Ride"] = 19.69, ["Fly|Ride"] = 47.25, ["Neon"] = 23.78, ["Neon|Fly"] = 196.65, ["Neon|Ride"] = 63.99, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 184.21, ["Mega|Ride"] = 240.3, ["Mega|Fly|Ride"] = 395.9}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 20.62, ["Ride"] = 17.83, ["Fly|Ride"] = 52.5, ["Neon"] = 13.47, ["Neon|Fly"] = 37.11, ["Neon|Ride"] = 36.84, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 423.42, ["Mega|Ride"] = 236.02, ["Mega|Fly|Ride"] = 197.95}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 190.2, ["Fly"] = 393.75, ["Ride"] = 229.69, ["Fly|Ride"] = 256.54, ["Neon"] = 984.38, ["Neon|Ride"] = 947.39, ["Neon|Fly|Ride"] = 1179.94, ["Mega|Ride"] = 3530.17, ["Mega|Fly|Ride"] = 3580.99}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 4.77, ["Ride"] = 22.62, ["Neon"] = 30.85, ["Neon|Fly|Ride"] = 282.63, ["Mega"] = 123.38, ["Mega|Ride"] = 240.3}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.56, ["Ride"] = 21.17, ["Fly|Ride"] = 118.13, ["Neon"] = 27.58, ["Neon|Fly"] = 212.02, ["Neon|Ride"] = 36.22, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 196.88, ["Mega|Ride"] = 273.11, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 3.4, ["Fly|Ride"] = 159.17, ["Neon"] = 44.64, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 635.13, ["Mega"] = 473.22, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 1033.6}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 16.89, ["Fly|Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 21.19, ["Neon|Ride"] = 15.89, ["Neon|Fly|Ride"] = 39.26, ["Mega"] = 22.32, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 37.07, ["Mega|Fly|Ride"] = 57.18}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 56.37, ["Ride"] = 19.1, ["Fly|Ride"] = 56.44, ["Neon"] = 16.69, ["Neon|Fly"] = 42.41, ["Neon|Ride"] = 27.54, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 123.38, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 5.66, ["Ride"] = 55.13, ["Fly|Ride"] = 77.43, ["Neon"] = 13.08, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 68.25, ["Mega|Ride"] = 158.94, ["Mega|Fly|Ride"] = 240.3}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 71.35, ["Fly"] = 106.89, ["Ride"] = 106.01, ["Fly|Ride"] = 148.93, ["Neon"] = 301.7, ["Neon|Ride"] = 418.14, ["Neon|Fly|Ride"] = 429.87, ["Mega|Ride"] = 3530.17, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 7.07, ["Fly"] = 99.65, ["Ride"] = 33.87, ["Fly|Ride"] = 65.63, ["Neon"] = 26.25, ["Neon|Ride"] = 57.18, ["Neon|Fly|Ride"] = 136.42, ["Mega"] = 220.19, ["Mega|Ride"] = 254.05, ["Mega|Fly|Ride"] = 671.11}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 31.82, ["Ride"] = 52.5, ["Fly|Ride"] = 118.13, ["Neon"] = 10.5, ["Neon|Ride"] = 57.18, ["Neon|Fly|Ride"] = 169.37, ["Mega"] = 75.83, ["Mega|Fly"] = 313.69, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 52.5, ["Fly"] = 127.1, ["Ride"] = 90.57, ["Fly|Ride"] = 236.25, ["Neon"] = 153.57, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 622.63, ["Mega|Ride"] = 557.82, ["Mega|Fly|Ride"] = 576.19}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 16.94, ["Ride"] = 12.71, ["Fly|Ride"] = 33.94, ["Neon"] = 2.1, ["Neon|Fly"] = 38.06, ["Neon|Ride"] = 15.91, ["Neon|Fly|Ride"] = 42, ["Mega"] = 32.82, ["Mega|Fly"] = 43.24, ["Mega|Ride"] = 38.12, ["Mega|Fly|Ride"] = 70.88}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.94, ["Neon|Ride"] = 69.87, ["Neon|Fly|Ride"] = 71.1, ["Mega"] = 27.39, ["Mega|Ride"] = 69.57, ["Mega|Fly|Ride"] = 187.38}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.63, ["Ride"] = 47.53, ["Neon"] = 8.5, ["Neon|Ride"] = 70.94, ["Neon|Fly|Ride"] = 194.78, ["Mega"] = 70.88, ["Mega|Ride"] = 145.07}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 4.87, ["Fly"] = 57.26, ["Ride"] = 60.78, ["Fly|Ride"] = 80.78, ["Neon"] = 38.06, ["Neon|Fly"] = 129.94, ["Neon|Ride"] = 100.51, ["Neon|Fly|Ride"] = 158.94, ["Mega"] = 113.37, ["Mega|Fly"] = 141.86, ["Mega|Ride"] = 168.32, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 11.1, ["Fly|Ride"] = 36.84, ["Neon"] = 2.63, ["Neon|Fly"] = 28.52, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 42.36, ["Mega"] = 21.19, ["Mega|Ride"] = 44.47, ["Mega|Fly|Ride"] = 130.22}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 13.13, ["Ride"] = 43.98, ["Fly|Ride"] = 204.3, ["Neon"] = 70.88, ["Neon|Ride"] = 167.26, ["Neon|Fly|Ride"] = 196.23, ["Mega"] = 387.43, ["Mega|Ride"] = 493.28, ["Mega|Fly|Ride"] = 550.45}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2625, ["Fly"] = 3150, ["Ride"] = 2731.56, ["Fly|Ride"] = 2727.38, ["Neon|Fly|Ride"] = 9318.75, ["Mega|Fly|Ride"] = 42340.75}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 28.64, ["Ride"] = 15.72, ["Fly|Ride"] = 45.94, ["Neon"] = 10.5, ["Neon|Fly"] = 69.13, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 66.94, ["Mega"] = 73.5, ["Mega|Fly"] = 141.86, ["Mega|Ride"] = 97.06, ["Mega|Fly|Ride"] = 156.18}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.63, ["Ride"] = 65.63, ["Fly|Ride"] = 74.82, ["Neon"] = 13.13, ["Mega"] = 113.27, ["Mega|Fly"] = 179.82, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 635.13}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 36.83, ["Ride"] = 35.44, ["Fly|Ride"] = 157.5, ["Neon"] = 68.25, ["Neon|Ride"] = 197.95, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 565.26, ["Mega|Ride"] = 397.69, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 41.97, ["Ride"] = 194.31, ["Neon"] = 187.69, ["Neon|Ride"] = 279.74, ["Neon|Fly|Ride"] = 423.42, ["Mega"] = 540.75, ["Mega|Ride"] = 734.13, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 150.94, ["Fly"] = 269.24, ["Ride"] = 207.94, ["Fly|Ride"] = 236.19, ["Neon"] = 591.53, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 735, ["Neon|Fly|Ride"] = 768.2, ["Mega"] = 6351.12, ["Mega|Ride"] = 3527.13, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 6.51, ["Ride"] = 52.5, ["Fly|Ride"] = 675.94, ["Neon"] = 19.69, ["Neon|Fly"] = 71.04, ["Neon|Ride"] = 104.9, ["Neon|Fly|Ride"] = 105.88, ["Mega"] = 224.44, ["Mega|Fly"] = 182.65, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 237.21}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 17.07, ["Neon|Fly"] = 99.66, ["Neon|Ride"] = 42.36, ["Neon|Fly|Ride"] = 528.22, ["Mega"] = 105.88, ["Mega|Ride"] = 261.03, ["Mega|Fly|Ride"] = 838.31}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.63, ["Fly"] = 101.99, ["Ride"] = 17.83, ["Fly|Ride"] = 131.25, ["Neon"] = 12.69, ["Neon|Ride"] = 44.63, ["Mega"] = 93.08, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 282.63}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 9.85, ["Fly|Ride"] = 656.25, ["Neon|Ride"] = 141.86, ["Neon|Fly|Ride"] = 296.4, ["Mega"] = 504.69, ["Mega|Ride"] = 419.2, ["Mega|Fly|Ride"] = 641.17}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 71.04, ["Neon"] = 2.1, ["Neon|Ride"] = 37.97, ["Mega"] = 17.07, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 338.73}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 78.75, ["Ride"] = 91.88, ["Fly|Ride"] = 105, ["Neon"] = 324.39, ["Neon|Ride"] = 409.5, ["Neon|Fly|Ride"] = 422.37, ["Mega"] = 1365, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1443.75}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Fly|Ride"] = 65.63, ["Neon"] = 6.36, ["Neon|Ride"] = 104.81, ["Mega"] = 47.45, ["Mega|Ride"] = 141.75}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 45.93, ["Fly"] = 99.65, ["Ride"] = 70.88, ["Fly|Ride"] = 106.01, ["Neon"] = 295.32, ["Neon|Fly"] = 354.08, ["Neon|Ride"] = 324.86, ["Neon|Fly|Ride"] = 618.19, ["Mega"] = 2625, ["Mega|Ride"] = 1270.24, ["Mega|Fly|Ride"] = 1129.46}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 33.93, ["Ride"] = 24.4, ["Fly|Ride"] = 49.88, ["Neon"] = 5.24, ["Neon|Fly"] = 121.92, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 42.28, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 123.98}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 118.13, ["Mega"] = 72.19, ["Mega|Ride"] = 169.37, ["Mega|Fly|Ride"] = 421.31}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 13.16, ["Ride"] = 52.5, ["Fly|Ride"] = 210.97, ["Neon"] = 68.25, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 141.86, ["Mega"] = 210.76, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 952.68}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 399, ["Ride"] = 444.94, ["Fly|Ride"] = 525, ["Neon"] = 1190.84, ["Neon|Ride"] = 1341.37, ["Neon|Fly|Ride"] = 1439.18, ["Mega"] = 4234.09, ["Mega|Ride"] = 4410, ["Mega|Fly|Ride"] = 3690.84}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 37.99, ["Fly"] = 57.26, ["Ride"] = 47.53, ["Fly|Ride"] = 69.75, ["Neon"] = 237.56, ["Neon|Fly"] = 317.14, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 205.37, ["Mega"] = 808.73, ["Mega|Fly|Ride"] = 906.1}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 27.26, ["Ride"] = 19.1, ["Fly|Ride"] = 40.29, ["Neon"] = 7.09, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 97.02, ["Mega"] = 74.11, ["Mega|Ride"] = 70.94, ["Mega|Fly|Ride"] = 411.55}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 15.91, ["Fly"] = 110.06, ["Ride"] = 36.12, ["Fly|Ride"] = 122.07, ["Neon"] = 49.24, ["Neon|Fly"] = 198.24, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 158.94, ["Mega"] = 227.07, ["Mega|Fly"] = 395.9, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 316.67}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 9.06, ["Ride"] = 21.15, ["Fly|Ride"] = 51.19, ["Neon"] = 84, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 118.61, ["Mega|Ride"] = 474.42, ["Mega|Fly|Ride"] = 353.56}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 4.09, ["Neon"] = 15.49, ["Mega"] = 49.77, ["Mega|Ride"] = 129.93, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.63, ["Fly"] = 86.63, ["Ride"] = 19.1, ["Fly|Ride"] = 69.99, ["Neon"] = 23.63, ["Neon|Ride"] = 42.36, ["Neon|Fly|Ride"] = 215.96, ["Mega"] = 553.87, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 474.42}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 104.97, ["Fly"] = 131.25, ["Ride"] = 121.96, ["Fly|Ride"] = 184.47, ["Neon"] = 537.47, ["Neon|Ride"] = 536.49, ["Neon|Fly|Ride"] = 600.68, ["Mega"] = 2538.35, ["Mega|Ride"] = 2569.04, ["Mega|Fly|Ride"] = 3042.2}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 34.19, ["Fly"] = 95.82, ["Ride"] = 79.38, ["Fly|Ride"] = 159.17, ["Neon"] = 192.94, ["Neon|Ride"] = 196.9, ["Mega"] = 704.99, ["Mega|Ride"] = 630, ["Mega|Fly|Ride"] = 703.53}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2205, ["Fly"] = 2349.27, ["Ride"] = 2231.24, ["Fly|Ride"] = 2290.32, ["Neon"] = 12720.67, ["Neon|Ride"] = 8699.13, ["Neon|Fly|Ride"] = 7621.36, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 41.89, ["Fly|Ride"] = 170.63, ["Neon"] = 14.34, ["Neon|Ride"] = 55.97, ["Neon|Fly|Ride"] = 169.32, ["Mega"] = 117.03, ["Mega|Ride"] = 167.35, ["Mega|Fly|Ride"] = 423.42}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 14.39, ["Ride"] = 99.66, ["Fly|Ride"] = 127.22, ["Neon"] = 65.63, ["Neon|Ride"] = 86.63, ["Neon|Fly|Ride"] = 169.37, ["Mega"] = 255.94, ["Mega|Ride"] = 367.32, ["Mega|Fly|Ride"] = 688.42}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 838.69, ["Fly"] = 1413.96, ["Ride"] = 918.75, ["Fly|Ride"] = 997.5, ["Neon"] = 2598.75, ["Neon|Ride"] = 2953.13, ["Neon|Fly|Ride"] = 2950.4, ["Mega|Fly|Ride"] = 12223.93}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 35.44, ["Ride"] = 37.41, ["Fly|Ride"] = 210, ["Neon"] = 270.21, ["Neon|Ride"] = 226.53, ["Mega"] = 656.25, ["Mega|Ride"] = 712.18, ["Mega|Fly|Ride"] = 823.55}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.93, ["Ride"] = 23.63, ["Fly|Ride"] = 91.88, ["Neon"] = 15.44, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 134.46, ["Mega|Fly|Ride"] = 306.48}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 111.19, ["Ride"] = 23.34, ["Neon"] = 3.91, ["Neon|Ride"] = 52.41, ["Mega"] = 28.88, ["Mega|Ride"] = 69.87, ["Mega|Fly|Ride"] = 141.86}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 99.66, ["Ride"] = 99.65, ["Fly|Ride"] = 142.06, ["Neon"] = 459.38, ["Neon|Fly|Ride"] = 474.42, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 2682.3}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 6.02, ["Neon"] = 29.53, ["Neon|Ride"] = 141.86, ["Mega"] = 87.87}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 99.74, ["Ride"] = 147, ["Neon"] = 614.25, ["Neon|Ride"] = 525, ["Mega"] = 1835.48, ["Mega|Fly|Ride"] = 1814.31}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 8.49, ["Fly"] = 105, ["Fly|Ride"] = 91.88, ["Neon"] = 33.15, ["Neon|Fly"] = 42.41, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 226.53, ["Mega|Fly|Ride"] = 282.63}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 244.86, ["Fly"] = 423.98, ["Ride"] = 285.24, ["Fly|Ride"] = 282.19, ["Neon"] = 1109.35, ["Neon|Ride"] = 988.67, ["Neon|Fly|Ride"] = 813.75, ["Mega|Fly|Ride"] = 4064.73}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 6.07, ["Fly"] = 87.72, ["Ride"] = 21.21, ["Fly|Ride"] = 99.65, ["Neon"] = 38.18, ["Neon|Ride"] = 69.77, ["Neon|Fly|Ride"] = 104.96, ["Mega"] = 229.68, ["Mega|Ride"] = 317.57, ["Mega|Fly|Ride"] = 425.79}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 18.15, ["Ride"] = 14.96, ["Fly|Ride"] = 32.82, ["Neon"] = 6.38, ["Neon|Fly"] = 19.1, ["Neon|Ride"] = 25.39, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 56.88, ["Mega|Fly"] = 104.87, ["Mega|Ride"] = 246.96, ["Mega|Fly|Ride"] = 150.76}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 840, ["Fly"] = 1187.66, ["Ride"] = 903, ["Fly|Ride"] = 1040.81, ["Neon|Ride"] = 4981.78, ["Neon|Fly|Ride"] = 4339.95, ["Mega"] = 28463.58, ["Mega|Fly|Ride"] = 28227.53}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 6.71, ["Fly"] = 989.99, ["Ride"] = 210, ["Neon"] = 28.59, ["Neon|Ride"] = 70.2, ["Mega"] = 154.19, ["Mega|Ride"] = 224.42, ["Mega|Fly|Ride"] = 372.1}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 6.51, ["Fly"] = 32.82, ["Ride"] = 26.25, ["Fly|Ride"] = 99.66, ["Neon"] = 23.62, ["Neon|Fly"] = 106.01, ["Neon|Ride"] = 74.11, ["Neon|Fly|Ride"] = 101.04, ["Mega"] = 183.75, ["Mega|Ride"] = 206.1, ["Mega|Fly|Ride"] = 307.19}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 37.94, ["Fly"] = 40.51, ["Ride"] = 40.24, ["Fly|Ride"] = 49.88, ["Neon|Ride"] = 199.02, ["Neon|Fly|Ride"] = 192.94, ["Mega"] = 2117.05, ["Mega|Fly|Ride"] = 756.86}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 19.59, ["Fly"] = 79.51, ["Ride"] = 30.19, ["Fly|Ride"] = 86.63, ["Neon"] = 65.63, ["Neon|Ride"] = 94.9, ["Neon|Fly|Ride"] = 156.65, ["Mega"] = 367.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 448.88}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 27.57, ["Ride"] = 210, ["Fly|Ride"] = 342.41, ["Neon"] = 86.63, ["Neon|Ride"] = 183.1, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 486.18, ["Mega|Ride"] = 480.58, ["Mega|Fly|Ride"] = 605.49}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Fly"] = 63.61, ["Ride"] = 116.59, ["Fly|Ride"] = 237.56, ["Neon"] = 2.1, ["Neon|Ride"] = 27.92, ["Mega"] = 20.87, ["Mega|Fly"] = 85.4, ["Mega|Ride"] = 141.86}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 31.49, ["Fly"] = 57.16, ["Ride"] = 44.84, ["Fly|Ride"] = 91.88, ["Neon"] = 270.26, ["Neon|Fly"] = 308.49, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 250.69, ["Mega"] = 3387.27, ["Mega|Fly|Ride"] = 1037.33}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 3.93, ["Fly"] = 90.27, ["Ride"] = 19.67, ["Fly|Ride"] = 70.87, ["Neon"] = 42.35, ["Neon|Ride"] = 141.86, ["Neon|Fly|Ride"] = 141.86, ["Mega"] = 773.07, ["Mega|Ride"] = 272.35, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 26.16, ["Ride"] = 20.19, ["Fly|Ride"] = 36.75, ["Neon"] = 19, ["Neon|Ride"] = 49.74, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 1057.48, ["Mega|Ride"] = 282.63, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 5.2, ["Ride"] = 103.69, ["Neon"] = 105, ["Neon|Ride"] = 846.83, ["Mega"] = 296.4, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 22.32, ["Fly"] = 262.23, ["Ride"] = 79.48, ["Fly|Ride"] = 196.88, ["Neon"] = 116.82, ["Neon|Fly"] = 312.73, ["Neon|Ride"] = 211.32, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 656.25, ["Mega|Ride"] = 485.63, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 5.55, ["Ride"] = 98.44, ["Neon"] = 17.78, ["Neon|Ride"] = 74.11, ["Neon|Fly|Ride"] = 423.42, ["Mega"] = 104.89, ["Mega|Fly|Ride"] = 316.67}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 21, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Mega"] = 19.69, ["Mega|Ride"] = 52.37, ["Mega|Fly|Ride"] = 204.75}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Ride"] = 20.98, ["Fly|Ride"] = 84.82, ["Neon"] = 3.92, ["Neon|Fly"] = 393.59, ["Neon|Ride"] = 21.11, ["Neon|Fly|Ride"] = 177.85, ["Mega"] = 18.26, ["Mega|Fly"] = 73.86, ["Mega|Ride"] = 47.25, ["Mega|Fly|Ride"] = 106.32}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 25.89, ["Ride"] = 21.21, ["Fly|Ride"] = 49.26, ["Neon"] = 7.09, ["Neon|Fly"] = 57.26, ["Neon|Ride"] = 23.3, ["Neon|Fly|Ride"] = 78.35, ["Mega"] = 83.89, ["Mega|Ride"] = 158.81, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.54, ["Fly|Ride"] = 5344.79, ["Neon"] = 15.91, ["Neon|Ride"] = 1312.5, ["Mega"] = 105, ["Mega|Ride"] = 150.33, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 26.23, ["Ride"] = 17.07, ["Fly|Ride"] = 45.6, ["Neon"] = 16.89, ["Neon|Fly"] = 53.02, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 284.65, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 366.18}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 86.63, ["Ride"] = 206.72, ["Fly|Ride"] = 396.48, ["Neon"] = 207.79, ["Neon|Ride"] = 298.91, ["Neon|Fly|Ride"] = 1058.53, ["Mega"] = 787.5, ["Mega|Fly"] = 1016.19, ["Mega|Ride"] = 845.4, ["Mega|Fly|Ride"] = 915.03}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 24.94, ["Ride"] = 21.15, ["Fly|Ride"] = 36.05, ["Neon"] = 3.84, ["Neon|Fly"] = 28.5, ["Neon|Ride"] = 20.84, ["Neon|Fly|Ride"] = 40.27, ["Mega"] = 63, ["Mega|Ride"] = 56.89, ["Mega|Fly|Ride"] = 101.1}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 9.85, ["Fly"] = 62.91, ["Ride"] = 44.63, ["Fly|Ride"] = 63.62, ["Neon"] = 57.26, ["Neon|Fly"] = 76.34, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 111.55, ["Mega"] = 523.04, ["Mega|Ride"] = 256.33, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 18.5, ["Fly"] = 39.38, ["Ride"] = 28.7, ["Fly|Ride"] = 57.26, ["Neon"] = 72.13, ["Neon|Ride"] = 79.49, ["Neon|Fly|Ride"] = 113.27, ["Mega"] = 423.42, ["Mega|Ride"] = 418.14, ["Mega|Fly|Ride"] = 433.28}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.93, ["Fly"] = 140.38, ["Ride"] = 47.5, ["Neon"] = 22.58, ["Neon|Ride"] = 70.94, ["Mega"] = 279.57, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 18.38, ["Neon"] = 5.13, ["Neon|Fly"] = 41.35, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 47.25, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 61.64, ["Mega|Fly|Ride"] = 134.92}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 5.25, ["Fly"] = 78.07, ["Ride"] = 21.15, ["Fly|Ride"] = 71.04, ["Neon"] = 15.74, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 62.47, ["Neon|Fly|Ride"] = 211.72, ["Mega"] = 120.69, ["Mega|Fly"] = 735, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 419.2}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 944.99, ["Ride"] = 1099.22, ["Fly|Ride"] = 1111.69, ["Neon"] = 2625, ["Neon|Fly"] = 2898.2, ["Neon|Ride"] = 2851.67, ["Neon|Fly|Ride"] = 2296.88, ["Mega|Fly|Ride"] = 7193.93}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 72.19, ["Ride"] = 94.5, ["Neon"] = 260.24, ["Neon|Ride"] = 281.58, ["Neon|Fly|Ride"] = 309.1, ["Mega"] = 1480.88, ["Mega|Ride"] = 1468.19, ["Mega|Fly|Ride"] = 1295.44}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Ride"] = 65.63, ["Neon"] = 5.71, ["Neon|Ride"] = 75.17, ["Neon|Fly|Ride"] = 99.52, ["Mega"] = 55.76}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 31.49, ["Fly"] = 47.53, ["Ride"] = 66.29, ["Fly|Ride"] = 126.16, ["Neon"] = 167.14, ["Neon|Ride"] = 190.56, ["Neon|Fly|Ride"] = 226.53, ["Mega"] = 1023.75, ["Mega|Ride"] = 1515.94, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 6.56, ["Ride"] = 33.93, ["Fly|Ride"] = 156.19, ["Neon"] = 52.5, ["Neon|Ride"] = 71.96, ["Neon|Fly|Ride"] = 281.58, ["Mega"] = 475.3, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 1058.53}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 274.32, ["Fly"] = 318, ["Ride"] = 262.5, ["Fly|Ride"] = 566.08, ["Neon"] = 984.38, ["Neon|Ride"] = 1256.48, ["Neon|Fly|Ride"] = 1115.63, ["Mega|Fly|Ride"] = 4089.07}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 102.37, ["Ride"] = 22.32, ["Fly|Ride"] = 129.93, ["Neon"] = 19.69, ["Neon|Ride"] = 53.9, ["Mega"] = 404.37, ["Mega|Fly"] = 282.63}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 26.25}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 62.74, ["Ride"] = 126.14, ["Neon"] = 127.22, ["Neon|Ride"] = 410.82, ["Neon|Fly|Ride"] = 402.94, ["Mega"] = 459.38, ["Mega|Ride"] = 635.13, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 48.54, ["Neon"] = 13.13, ["Mega"] = 226.53, ["Mega|Ride"] = 296.4, ["Mega|Fly|Ride"] = 211.72}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 15.72, ["Fly|Ride"] = 28.64, ["Neon"] = 3.82, ["Neon|Fly"] = 32.01, ["Neon|Ride"] = 28.6, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 28.45, ["Mega|Fly"] = 64.05, ["Mega|Ride"] = 40.43, ["Mega|Fly|Ride"] = 89.24}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4200, ["Ride"] = 4331.25, ["Fly|Ride"] = 3937.5, ["Neon"] = 26431.41, ["Neon|Fly|Ride"] = 21359.63, ["Mega|Fly|Ride"] = 54871.86}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 12.74, ["Fly"] = 16.97, ["Ride"] = 46.66, ["Neon"] = 95.71, ["Neon|Ride"] = 70.94, ["Mega"] = 418.69, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 23.63, ["Ride"] = 21.21, ["Fly|Ride"] = 44.62, ["Neon"] = 12.39, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 28.6, ["Neon|Fly|Ride"] = 70.14, ["Mega"] = 229.53, ["Mega|Ride"] = 142.34, ["Mega|Fly|Ride"] = 202.82}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 402.94, ["Fly"] = 511.96, ["Ride"] = 459.38, ["Fly|Ride"] = 511.75, ["Neon"] = 1312.5, ["Neon|Ride"] = 1358.44, ["Neon|Fly|Ride"] = 1232.85, ["Mega|Fly|Ride"] = 4550.58}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 3.91, ["Ride"] = 28.64, ["Neon"] = 16.97, ["Neon|Ride"] = 145.68, ["Mega"] = 124.69, ["Mega|Fly|Ride"] = 317.57}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 5.25, ["Fly"] = 135.23, ["Ride"] = 952.88, ["Neon"] = 95.04, ["Neon|Ride"] = 141.86, ["Neon|Fly|Ride"] = 14114.3, ["Mega"] = 387.85, ["Mega|Ride"] = 401.63}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.33, ["Ride"] = 17.75, ["Fly|Ride"] = 82.55, ["Neon"] = 3.94, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 47.2, ["Mega|Ride"] = 84.69, ["Mega|Fly|Ride"] = 156.19}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 629.99, ["Ride"] = 639.19, ["Fly|Ride"] = 695.63, ["Neon"] = 2501.75, ["Neon|Fly|Ride"] = 1967.34, ["Mega|Fly|Ride"] = 8751.75}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.56, ["Ride"] = 39.38, ["Fly|Ride"] = 114.91, ["Neon"] = 28.44, ["Neon|Ride"] = 99.52, ["Neon|Fly|Ride"] = 205.37, ["Mega"] = 144.38, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 314.77}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 10.5, ["Fly"] = 235.94, ["Ride"] = 52.5, ["Neon"] = 43.32, ["Neon|Ride"] = 105.88, ["Neon|Fly|Ride"] = 126.93, ["Mega"] = 236.73, ["Mega|Ride"] = 233.93, ["Mega|Fly|Ride"] = 370.5}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 28.54, ["Ride"] = 19.94, ["Fly|Ride"] = 55.84, ["Neon"] = 15.59, ["Neon|Ride"] = 28.54, ["Neon|Fly|Ride"] = 61.41, ["Mega"] = 170.63, ["Mega|Fly"] = 282.63, ["Mega|Ride"] = 158.94, ["Mega|Fly|Ride"] = 208.69}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 15.91, ["Ride"] = 48.57, ["Neon"] = 78.72, ["Neon|Fly"] = 170.63, ["Neon|Ride"] = 127.03, ["Neon|Fly|Ride"] = 316.72, ["Mega"] = 474.42, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 528.22}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 39.37, ["Neon"] = 4.26, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 54.54, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 28.88, ["Mega|Fly"] = 105.88, ["Mega|Ride"] = 87.84, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 420, ["Ride"] = 467.51, ["Fly|Ride"] = 530.04, ["Neon"] = 1837.5, ["Neon|Ride"] = 2381.68, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Ride"] = 9250.68, ["Mega|Fly|Ride"] = 8250.11}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 51.19, ["Neon"] = 7.87, ["Neon|Ride"] = 36.93, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 33.89, ["Mega|Ride"] = 133.34, ["Mega|Fly|Ride"] = 309.08}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 28.6, ["Neon"] = 3.93, ["Neon|Fly"] = 71.04, ["Neon|Ride"] = 213.28, ["Mega"] = 31.77, ["Mega|Fly"] = 93.17, ["Mega|Ride"] = 158.94, ["Mega|Fly|Ride"] = 210.66}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 21, ["Neon"] = 3.93, ["Neon|Ride"] = 45.91, ["Mega"] = 34.13, ["Mega|Fly"] = 156.68, ["Mega|Ride"] = 92.11}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 3.82, ["Ride"] = 131.25, ["Neon"] = 25.46, ["Neon|Ride"] = 70.94, ["Mega"] = 231.82, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 62.89, ["Fly"] = 131.25, ["Ride"] = 98.43, ["Fly|Ride"] = 232.32, ["Neon"] = 233.63, ["Neon|Ride"] = 282.63, ["Neon|Fly|Ride"] = 358.85, ["Mega"] = 677.77, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 25.75, ["Fly"] = 69.47, ["Ride"] = 60.24, ["Fly|Ride"] = 112.11, ["Neon"] = 97.76, ["Neon|Ride"] = 137.63, ["Neon|Fly|Ride"] = 282.63, ["Mega"] = 463.1, ["Mega|Ride"] = 468.57, ["Mega|Fly|Ride"] = 522.21}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 3.57, ["Fly"] = 40.69, ["Ride"] = 16.92, ["Fly|Ride"] = 41.92, ["Neon"] = 27.57, ["Neon|Fly"] = 71.04, ["Neon|Ride"] = 35.05, ["Neon|Fly|Ride"] = 77.43, ["Mega"] = 394.42, ["Mega|Ride"] = 238.18, ["Mega|Fly|Ride"] = 245.59}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 7.76, ["Ride"] = 64.32, ["Fly|Ride"] = 114.03, ["Neon"] = 169.63, ["Neon|Ride"] = 158.82, ["Neon|Fly|Ride"] = 233.96, ["Mega"] = 334.51, ["Mega|Ride"] = 791.06, ["Mega|Fly|Ride"] = 988.67}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 3.93, ["Fly"] = 301.04, ["Ride"] = 21.21, ["Fly|Ride"] = 362.25, ["Neon"] = 19.69, ["Neon|Ride"] = 70.94, ["Mega"] = 168, ["Mega|Ride"] = 179.96, ["Mega|Fly|Ride"] = 503.88}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 19.99, ["Ride"] = 30.16, ["Fly|Ride"] = 45.94, ["Neon"] = 228.74, ["Neon|Ride"] = 169.37, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 951.63, ["Mega|Ride"] = 948.81, ["Mega|Fly|Ride"] = 704.99}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 39.38, ["Fly"] = 874.13, ["Ride"] = 84.81, ["Neon|Ride"] = 474.47, ["Mega"] = 353.56, ["Mega|Ride"] = 590.63}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 45.92, ["Fly"] = 115.5, ["Ride"] = 81.38, ["Fly|Ride"] = 111.67, ["Neon"] = 283.04, ["Neon|Fly"] = 325.45, ["Neon|Ride"] = 276.92, ["Neon|Fly|Ride"] = 392.52, ["Mega"] = 1164.39, ["Mega|Ride"] = 1158.04, ["Mega|Fly|Ride"] = 918.65}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 45.94, ["Fly"] = 92.79, ["Ride"] = 78.91, ["Neon"] = 157.5, ["Neon|Ride"] = 154.55, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 513.35, ["Mega|Ride"] = 612.46, ["Mega|Fly|Ride"] = 612.01}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 23.82, ["Ride"] = 59.07, ["Neon"] = 108.94, ["Mega"] = 846.83, ["Mega|Ride"] = 776.96, ["Mega|Fly|Ride"] = 717.69}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 9.44, ["Fly"] = 27.18, ["Ride"] = 32.22, ["Fly|Ride"] = 42.41, ["Neon"] = 45.94, ["Neon|Fly"] = 169.63, ["Neon|Ride"] = 87.71, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 349.13, ["Mega|Ride"] = 338.73, ["Mega|Fly|Ride"] = 398.43}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 20.15, ["Ride"] = 15.65, ["Fly|Ride"] = 42.41, ["Neon"] = 3.93, ["Neon|Fly"] = 24.89, ["Neon|Ride"] = 20.12, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 45.92, ["Mega|Fly"] = 706.05, ["Mega|Ride"] = 62.99, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1458.19}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 23.82, ["Ride"] = 33.93, ["Fly|Ride"] = 131.25, ["Neon"] = 133.59, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 300.64, ["Mega"] = 409.66, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 518.44}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 55.83, ["Neon"] = 4.25, ["Neon|Ride"] = 37.07, ["Neon|Fly|Ride"] = 296.4, ["Mega"] = 27.29, ["Mega|Ride"] = 115.4, ["Mega|Fly|Ride"] = 544.39}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 35.44, ["Neon"] = 208.31, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 690.17, ["Mega|Ride"] = 947.39, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Ride"] = 65.63, ["Neon"] = 2.1, ["Neon|Ride"] = 105, ["Mega"] = 27.54, ["Mega|Fly|Ride"] = 706.05}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 4.26, ["Neon|Ride"] = 158.95, ["Mega"] = 23.63, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 130.07, ["Ride"] = 131.25, ["Fly|Ride"] = 252, ["Neon"] = 426.57, ["Neon|Fly"] = 513.11, ["Neon|Ride"] = 509.95, ["Neon|Fly|Ride"] = 522.43, ["Mega|Ride"] = 6522.91, ["Mega|Fly|Ride"] = 2098.69}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 26.11, ["Ride"] = 21.21, ["Fly|Ride"] = 71.28, ["Neon"] = 13.08, ["Neon|Fly"] = 63.62, ["Neon|Ride"] = 35.43, ["Neon|Fly|Ride"] = 92.11, ["Mega"] = 107.63, ["Mega|Ride"] = 134.46, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 36.16, ["Ride"] = 131.24, ["Fly|Ride"] = 86.63, ["Neon"] = 3.52, ["Neon|Fly"] = 63.62, ["Neon|Ride"] = 33.89, ["Neon|Fly|Ride"] = 100.57, ["Mega"] = 28.88, ["Mega|Ride"] = 103.73, ["Mega|Fly|Ride"] = 116.82}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 6.38, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.35, ["Mega"] = 34.73, ["Mega|Ride"] = 277.98, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 19.1, ["Neon"] = 5.2, ["Neon|Ride"] = 28.77, ["Mega"] = 36.01, ["Mega|Ride"] = 95.7, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 58.88, ["Ride"] = 91.88, ["Fly|Ride"] = 449.61, ["Neon"] = 267.15, ["Neon|Ride"] = 407.69, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1409.96, ["Mega|Ride"] = 1551.8, ["Mega|Fly|Ride"] = 1552.87}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.93, ["Ride"] = 36.53, ["Neon"] = 28.41, ["Neon|Ride"] = 262.5, ["Mega"] = 91.88, ["Mega|Ride"] = 771.1}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 367.74, ["Ride"] = 380.63, ["Fly|Ride"] = 528.98, ["Neon"] = 1272.09, ["Neon|Ride"] = 1270.24, ["Neon|Fly|Ride"] = 1270.24, ["Mega|Ride"] = 3796.92, ["Mega|Fly|Ride"] = 3242.6}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 76.08}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 43.31}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 11.21}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 11.81}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 36.75}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 39.38}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 10.49}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 4.92}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 240.19}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 14.43}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 41.97}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 6.54}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 4.96}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 853.13}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 5.12}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 3.93}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 3.93}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 5.71}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 23.6}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 475.13}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 660.42}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 14.44}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1378.13}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 64.32}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 6.18}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 7.88}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 14.44}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 72.11}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 57.75}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 11.82}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 13.1}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 15.7}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 7.46}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 17.04}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.63}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 31.42}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 15.74}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.51}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.63}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1640.63}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 163.26}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 308.23}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 10.71}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.63}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 6.57}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 9.19}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 26.25}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 157.49}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 7.22}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 39.38}},
    ["rbxassetid://1265129435"] = {name = "Gold Snowboard", prices = {["default"] = 157.5}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 957.92}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 19.69}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 2.63}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 26.25}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 7.61}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 3.94}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 131.14}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 18.38}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 15.73}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 23.34}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 3.94}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 10.49}},
    ["rbxassetid://1265129203"] = {name = "Ice Snowboard", prices = {["default"] = 246.1}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 6.3}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 30.85}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 136.5}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 159.07}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 6.57}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 16.33}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 30.19}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 70.9}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 64.53}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 21908.16}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 183.74}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 26.25}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 65.6}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 48.57}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 45.86}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 58.32}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 45.94}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 183.65}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 96.49}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 24.62}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 36.75}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 41.75}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 42}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 101.94}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 354.37}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 65.63}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 5.24}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 3.94}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 10.61}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 28.64}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 32.81}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.24}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 9.6}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 3.94}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 234.97}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 1050}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 7.88}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 627.4}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 34.13}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 381.64}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 40.53}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 92.25}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 27.15}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 31.47}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 91.88}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 28.64}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.86}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 14.91}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.29}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 3.92}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 32.82}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.94}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.86}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 7.88}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 16.84}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 153.5}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 45.94}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 166.11}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 9.52}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 30.45}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 7.45}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 32.08}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 72.16}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 10.44}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 7.88}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 24.94}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 11.79}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 102.38}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 35.44}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 7.87}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 42}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 3.78}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 4.9}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 4.6}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 9.93}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 2.46}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 6.08}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 4.24}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 5670}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 12.99}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 6.57}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.56}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 3.93}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 20.19}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 7.24}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.92}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 15.48}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 31.49}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 3.87}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 4.98}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.67}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 3.93}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.56}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 2635.31}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 4.33}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 34.47}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.51}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.14}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 81.38}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.61}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 7.18}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 281.98}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.1}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.26}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 6.83}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 8.97}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 44.55}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.72}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.67}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 13.1}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 5.23}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 2.52}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 5.2}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.2}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 33.87}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.61}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 65.62}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.37}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 3.92}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 199.53}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.28}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 89.14}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 2.23}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 11.07}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 984.38}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 14.44}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 5.08}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 27.38}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 7.49}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 11.01}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 26.25}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.63}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 15.7}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 24.4}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.63}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 3.91}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 2.61}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 15.85}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 5.92}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 38.72}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.34}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 4.78}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 141.75}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 10.48}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 31.21}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.63}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 11.34}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 4.77}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 2.1}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 49.79}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 25.55}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.93}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.63}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 104.92}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 9.16}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 10.49}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 4.59}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 3.93}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 17.88}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 86.63}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 10.84}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 112.77}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 2.63}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1181.25}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 154.88}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 10.5}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 47.25}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.63}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.61}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.56}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 118.13}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 9.19}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 2.52}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 3.93}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 3.39}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 11.89}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 52.38}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 7.85}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 56.32}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 2.52}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 3.62}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 3.93}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 24.44}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 107.79}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 75.81}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.93}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 3.94}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 68.12}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 39.37}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 111.57}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 341.2}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 91.88}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 238.88}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.81}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 14}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 41.88}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.82}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 23.63}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.14}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 7.27}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 9.19}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 43.32}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 10.81}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 6.51}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 6.57}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 23.63}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 45.94}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 43.32}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 7.88}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 7.59}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 52.5}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 65.63}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 27.57}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1635.67}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 5.91}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 5.96}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 55.38}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 271.63}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 19.02}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 5.96}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 42.77}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 8.76}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 170.61}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 43.08}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 45.94}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 11.79}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.59}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 61.53}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 105}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 94.89}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1575}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 262.5}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 10.61}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1057.4}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 420}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 3.29}},
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