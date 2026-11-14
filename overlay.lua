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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 921.16, ["Fly"] = 1130.41, ["Ride"] = 1050, ["Fly|Ride"] = 1076.25, ["Neon"] = 6604.75, ["Neon|Ride"] = 4944.3, ["Neon|Fly|Ride"] = 3921.75, ["Mega|Fly|Ride"] = 19915.94}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 380.63, ["Fly"] = 540.31, ["Ride"] = 424.6, ["Fly|Ride"] = 409.29, ["Neon|Fly|Ride"] = 1942.99, ["Mega"] = 9888.59, ["Mega|Fly|Ride"] = 8233.78}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4856.25, ["Ride"] = 5250, ["Fly|Ride"] = 4508.44, ["Neon"] = 26132.59, ["Neon|Fly|Ride"] = 20444.01, ["Mega|Fly|Ride"] = 63564.88}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 115.5, ["Ride"] = 184.09, ["Fly|Ride"] = 211.91, ["Neon"] = 706.65, ["Neon|Ride"] = 821.63, ["Neon|Fly|Ride"] = 1968.75, ["Mega"] = 3813.91, ["Mega|Fly|Ride"] = 2656.41}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 632.63, ["Ride"] = 534.03, ["Fly|Ride"] = 551.29, ["Neon|Fly|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 6962.49}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 10.61, ["Ride"] = 32.82, ["Fly|Ride"] = 141.98, ["Neon"] = 47.18, ["Neon|Ride"] = 84.62, ["Neon|Fly|Ride"] = 282.87, ["Mega"] = 280.88, ["Mega|Ride"] = 471.78, ["Mega|Fly|Ride"] = 409.5}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.25, ["Fly"] = 31.75, ["Ride"] = 27.54, ["Fly|Ride"] = 64.19, ["Neon"] = 24.38, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 106.45, ["Mega"] = 127.15, ["Mega|Ride"] = 141.98, ["Mega|Fly|Ride"] = 236.24}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 94.65, ["Fly"] = 183.75, ["Ride"] = 156.8, ["Fly|Ride"] = 231, ["Neon"] = 418.69, ["Neon|Ride"] = 524.42, ["Neon|Fly|Ride"] = 706.65, ["Mega"] = 1887.08, ["Mega|Fly|Ride"] = 1834.92}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 34.85, ["Fly"] = 143.04, ["Ride"] = 42.39, ["Fly|Ride"] = 97.75, ["Neon"] = 239.45, ["Neon|Ride"] = 194.19, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 2100, ["Mega|Ride"] = 1273.79, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 17.71, ["Fly"] = 35.4, ["Ride"] = 31.8, ["Fly|Ride"] = 69.57, ["Neon"] = 211.91, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 205.24, ["Mega|Ride"] = 635.66, ["Mega|Fly|Ride"] = 740.55}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 63.58, ["Fly"] = 288.18, ["Ride"] = 60.29, ["Fly|Ride"] = 141.75, ["Neon"] = 203.44, ["Neon|Ride"] = 210.83, ["Neon|Fly|Ride"] = 279.7, ["Mega|Ride"] = 1376.2, ["Mega|Fly|Ride"] = 1368.14}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 76.13}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 381.41, ["Fly"] = 441.12, ["Ride"] = 390.21, ["Fly|Ride"] = 447.58, ["Neon"] = 1409.04, ["Neon|Ride"] = 1413.28, ["Neon|Fly|Ride"] = 1340.07, ["Mega"] = 5650.93, ["Mega|Fly|Ride"] = 5796.07}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 105, ["Fly"] = 111.57, ["Ride"] = 105.98, ["Fly|Ride"] = 144.26, ["Neon|Ride"] = 564.38, ["Neon|Fly|Ride"] = 565.74, ["Mega|Fly|Ride"] = 3037.35}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.1, ["Ride"] = 33.79, ["Fly|Ride"] = 78.75, ["Neon"] = 15.91, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 80.53, ["Mega"] = 82.69, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 383.25}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 129.86, ["Fly"] = 198.09, ["Ride"] = 144.38, ["Fly|Ride"] = 158.82, ["Neon"] = 706.65, ["Neon|Ride"] = 1346.9, ["Neon|Fly|Ride"] = 511.88, ["Mega|Fly|Ride"] = 1837.38}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.33, ["Fly"] = 24.38, ["Ride"] = 19.08, ["Fly|Ride"] = 44.63, ["Neon"] = 24.94, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 196.88, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 305.82}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 45.54, ["Fly"] = 153.34, ["Ride"] = 91.88, ["Fly|Ride"] = 222.05, ["Neon"] = 189, ["Neon|Ride"] = 223.97, ["Neon|Fly|Ride"] = 396.82, ["Mega"] = 826.37, ["Mega|Ride"] = 761.55, ["Mega|Fly|Ride"] = 597.19}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 57.22}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 65.5, ["Ride"] = 176.93, ["Fly|Ride"] = 246.1, ["Neon"] = 280.88, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 2362.5}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 15.74, ["Fly"] = 393.75, ["Ride"] = 28.88, ["Fly|Ride"] = 78.75, ["Neon"] = 148.62, ["Neon|Ride"] = 360.94, ["Neon|Fly|Ride"] = 269.1, ["Mega"] = 2712.67, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 1695.07}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 32.96, ["Fly"] = 71, ["Ride"] = 43.32, ["Fly|Ride"] = 102.89, ["Neon"] = 226.73, ["Neon|Fly"] = 315.72, ["Neon|Ride"] = 158.06, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 1681.32, ["Mega|Ride"] = 847.54, ["Mega|Fly|Ride"] = 807.57}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 57.75, ["Fly"] = 105, ["Ride"] = 189, ["Fly|Ride"] = 139.86, ["Neon"] = 207.37, ["Neon|Ride"] = 223.12, ["Neon|Fly|Ride"] = 316.79, ["Mega"] = 1695.07, ["Mega|Ride"] = 1267.07, ["Mega|Fly|Ride"] = 1130.41}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 45.94, ["Fly"] = 63.71, ["Ride"] = 49.88, ["Fly|Ride"] = 127.15, ["Neon|Ride"] = 198.13, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 1207.92, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1101.59}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 45.94, ["Fly"] = 650.5, ["Ride"] = 78.41, ["Fly|Ride"] = 105, ["Neon"] = 313.42, ["Neon|Ride"] = 309.68, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 847.54}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 4.57, ["Fly"] = 26.24, ["Ride"] = 22.16, ["Fly|Ride"] = 49.88, ["Neon"] = 30.68, ["Neon|Fly"] = 70.88, ["Neon|Ride"] = 42.39, ["Neon|Fly|Ride"] = 90.57, ["Mega"] = 129.94, ["Mega|Fly"] = 275.63, ["Mega|Ride"] = 138.76, ["Mega|Fly|Ride"] = 225.75}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 293.98, ["Fly"] = 370.81, ["Ride"] = 339.03, ["Fly|Ride"] = 362.25, ["Neon"] = 1443.75, ["Neon|Ride"] = 1979, ["Neon|Fly|Ride"] = 1483.19, ["Mega"] = 10594.16, ["Mega|Fly|Ride"] = 5976.12}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 14.34, ["Ride"] = 24.87, ["Fly|Ride"] = 135.64, ["Neon"] = 494.75, ["Neon|Ride"] = 304.5, ["Mega"] = 833.78, ["Mega|Fly|Ride"] = 798.82}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 8.48, ["Fly"] = 38.07, ["Ride"] = 22.79, ["Fly|Ride"] = 52.5, ["Neon"] = 50.87, ["Neon|Ride"] = 56.63, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 312.55, ["Mega|Ride"] = 317.84, ["Mega|Fly|Ride"] = 393.94}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 97.48, ["Fly"] = 141.98, ["Ride"] = 111.03, ["Fly|Ride"] = 98.44, ["Neon"] = 393.94, ["Neon|Ride"] = 462.98, ["Neon|Fly|Ride"] = 446.25, ["Mega"] = 6249.74, ["Mega|Ride"] = 1473.67, ["Mega|Fly|Ride"] = 1767.11}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 11.82, ["Fly"] = 36.04, ["Ride"] = 26.25, ["Fly|Ride"] = 70.93, ["Neon"] = 97.48, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 707.66, ["Mega|Ride"] = 635.66, ["Mega|Fly|Ride"] = 635.66}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 157.5, ["Fly"] = 353.85, ["Ride"] = 196.88, ["Fly|Ride"] = 339.03, ["Neon"] = 773.07, ["Neon|Ride"] = 1059.43, ["Neon|Fly|Ride"] = 773.07, ["Mega"] = 6356.51, ["Mega|Fly|Ride"] = 2982.27}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 44.5}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 4.24, ["Fly"] = 36.58, ["Ride"] = 27.57, ["Fly|Ride"] = 93.19, ["Neon"] = 21, ["Neon|Fly"] = 105.96, ["Neon|Ride"] = 40.27, ["Neon|Fly|Ride"] = 149.8, ["Mega"] = 131.25, ["Mega|Fly"] = 235.9, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 735, ["Fly"] = 841.19, ["Ride"] = 845.43, ["Fly|Ride"] = 989.5, ["Neon"] = 4520.54, ["Neon|Ride"] = 5248.69, ["Neon|Fly|Ride"] = 3918.79, ["Mega"] = 12713, ["Mega|Ride"] = 53073.72, ["Mega|Fly|Ride"] = 13209.48}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 10.45, ["Fly"] = 28.49, ["Ride"] = 22.32, ["Fly|Ride"] = 72.19, ["Neon"] = 108.07, ["Neon|Ride"] = 139.86, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 421.66, ["Mega|Ride"] = 600.71, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 93.53, ["Ride"] = 124.69, ["Fly|Ride"] = 196.88, ["Neon"] = 485.63, ["Neon|Ride"] = 629.31, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 2665.5}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 40.4}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 18.38, ["Fly"] = 68.85, ["Ride"] = 52.99, ["Fly|Ride"] = 141.54, ["Neon"] = 176.93, ["Neon|Ride"] = 198.13, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 529.73, ["Mega|Ride"] = 723.19, ["Mega|Fly|Ride"] = 706.65}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 131.24, ["Ride"] = 131.25, ["Neon"] = 452.82, ["Neon|Ride"] = 495.37, ["Neon|Fly|Ride"] = 590.63, ["Mega|Fly|Ride"] = 2352}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 132.41, ["Ride"] = 161.33, ["Fly|Ride"] = 216.57, ["Neon"] = 480.99, ["Neon|Ride"] = 366.18, ["Neon|Fly|Ride"] = 565.53, ["Mega"] = 1312.5, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1547.58}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 52.49}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 60.38, ["Fly"] = 65.63, ["Ride"] = 49.88, ["Fly|Ride"] = 78.75, ["Neon"] = 608.12, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 282.19, ["Mega"] = 4236.62, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 6.57, ["Ride"] = 26.25, ["Fly|Ride"] = 159.99, ["Neon"] = 35.69, ["Neon|Ride"] = 42.39, ["Neon|Fly|Ride"] = 236.27, ["Mega"] = 198.13, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 230.01, ["Mega|Fly|Ride"] = 350.68}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 346.49, ["Fly"] = 420, ["Ride"] = 348.83, ["Fly|Ride"] = 402.83, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 4661.44}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 84.14, ["Fly"] = 99.75, ["Ride"] = 94.5, ["Fly|Ride"] = 113.37, ["Neon"] = 360.22, ["Neon|Ride"] = 362.09, ["Neon|Fly|Ride"] = 367.49, ["Mega|Ride"] = 1904.84, ["Mega|Fly|Ride"] = 1815.84}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3956.93, ["Ride"] = 3961.13, ["Fly|Ride"] = 3017.43, ["Neon|Fly|Ride"] = 14124.13}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 38.58, ["Fly"] = 113.37, ["Ride"] = 45.55, ["Fly|Ride"] = 95.82, ["Neon"] = 240.51, ["Neon|Ride"] = 229.69, ["Neon|Fly|Ride"] = 294.87, ["Mega|Ride"] = 2118.84, ["Mega|Fly|Ride"] = 1610.44}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 42.39, ["Ride"] = 117.6, ["Fly|Ride"] = 141.54, ["Neon"] = 480.99, ["Neon|Ride"] = 795.16, ["Neon|Fly|Ride"] = 494.75, ["Mega"] = 6356.51, ["Mega|Fly|Ride"] = 1677.08}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 35.95, ["Fly"] = 70.79, ["Ride"] = 61.46, ["Fly|Ride"] = 120.51, ["Neon"] = 177.98, ["Neon|Fly"] = 281.81, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 199.34, ["Mega"] = 2625, ["Mega|Fly|Ride"] = 625}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 8.4}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 57.75, ["Ride"] = 76.13, ["Fly|Ride"] = 117.6, ["Neon"] = 354.92, ["Neon|Ride"] = 471.78, ["Neon|Fly|Ride"] = 501.38, ["Mega|Fly|Ride"] = 1730.23}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 34.92}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 200.97, ["Ride"] = 198.13, ["Fly|Ride"] = 282.87, ["Neon|Fly|Ride"] = 1481.08}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 702.19, ["Ride"] = 735, ["Fly|Ride"] = 794.58, ["Neon|Ride"] = 3248.18, ["Neon|Fly|Ride"] = 2861.25, ["Mega|Fly|Ride"] = 11812.5}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 13.11}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 26.12, ["Fly"] = 52.42, ["Ride"] = 38.07, ["Fly|Ride"] = 70.88, ["Neon"] = 162.75, ["Neon|Ride"] = 134.65, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 707.44}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 11.58}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5670, ["Fly|Ride"] = 4723.69, ["Neon|Fly|Ride"] = 9495.94, ["Mega|Fly|Ride"] = 40823.5}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 11.61, ["Fly"] = 74.64, ["Ride"] = 28.62, ["Fly|Ride"] = 52.5, ["Neon"] = 65.63, ["Neon|Ride"] = 99.08, ["Neon|Fly|Ride"] = 175.88, ["Mega"] = 420, ["Mega|Ride"] = 333.73, ["Mega|Fly|Ride"] = 565.53}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 15.74, ["Fly"] = 94.37, ["Ride"] = 31.49, ["Fly|Ride"] = 116.78, ["Neon"] = 78.75, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 231, ["Mega"] = 453.45, ["Mega|Ride"] = 517.01, ["Mega|Fly|Ride"] = 673.81}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 127.14, ["Fly"] = 139.21, ["Ride"] = 94.5, ["Fly|Ride"] = 140.44, ["Neon"] = 1413.28, ["Neon|Fly|Ride"] = 420, ["Mega"] = 4237.67}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 12.99, ["Fly"] = 150.94, ["Ride"] = 31.08, ["Fly|Ride"] = 139.13, ["Neon"] = 53.82, ["Neon|Ride"] = 86.89, ["Neon|Fly|Ride"] = 462.53, ["Mega"] = 1413.28, ["Mega|Ride"] = 572.1, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 2100, ["Fly"] = 2493.59, ["Ride"] = 2315.25, ["Fly|Ride"] = 2047.75, ["Neon|Fly|Ride"] = 3937.5, ["Mega|Fly|Ride"] = 13367.51}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 27827.66, ["Fly"] = 35225.64, ["Ride"] = 35314.54, ["Fly|Ride"] = 23887.5, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 61687.5, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 197752.47}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 18.84, ["Fly"] = 393.75, ["Ride"] = 48.75, ["Fly|Ride"] = 84.76, ["Neon"] = 134.47, ["Neon|Fly"] = 141.98, ["Neon|Ride"] = 204.63, ["Neon|Fly|Ride"] = 282.87, ["Mega"] = 565.74, ["Mega|Ride"] = 656.85, ["Mega|Fly|Ride"] = 706.65}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.63, ["Ride"] = 31.86, ["Fly|Ride"] = 125.02, ["Neon"] = 14.44, ["Neon|Fly"] = 134.38, ["Neon|Ride"] = 31.8, ["Neon|Fly|Ride"] = 120.79, ["Mega"] = 90.56, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 23.63}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 8.49, ["Ride"] = 40.69, ["Fly|Ride"] = 71, ["Neon"] = 42.39, ["Neon|Ride"] = 99.61, ["Neon|Fly|Ride"] = 463.32, ["Mega"] = 443.47, ["Mega|Ride"] = 468.9, ["Mega|Fly|Ride"] = 471.78}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 761.74, ["Ride"] = 762.8, ["Fly|Ride"] = 741.57, ["Neon"] = 2988.66, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2491.13, ["Mega|Fly|Ride"] = 11008.68}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 997.49, ["Fly"] = 962.07, ["Ride"] = 984.38, ["Fly|Ride"] = 1104.49, ["Neon|Fly|Ride"] = 4223.9, ["Mega|Fly|Ride"] = 21187.25}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 28.61, ["Fly"] = 117.96, ["Ride"] = 53.82, ["Fly|Ride"] = 113.37, ["Neon"] = 230.95, ["Neon|Ride"] = 181.64, ["Neon|Fly|Ride"] = 211.91, ["Mega"] = 1256.31, ["Mega|Fly|Ride"] = 1413.28}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 28.62}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 82.65, ["Fly"] = 105.96, ["Ride"] = 96.79, ["Fly|Ride"] = 134.54, ["Neon|Ride"] = 565.74, ["Neon|Fly|Ride"] = 410.82, ["Mega|Ride"] = 1694.02, ["Mega|Fly|Ride"] = 1598.63}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 67.7, ["Ride"] = 84, ["Fly|Ride"] = 195.39, ["Neon"] = 396.24, ["Neon|Ride"] = 423.78, ["Neon|Fly|Ride"] = 508.54, ["Mega"] = 2134.97, ["Mega|Fly|Ride"] = 1695.15}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.94, ["Fly"] = 32.78, ["Ride"] = 21.2, ["Fly|Ride"] = 52.05, ["Neon"] = 24.38, ["Neon|Fly"] = 314.92, ["Neon|Ride"] = 68.75, ["Neon|Fly|Ride"] = 141.98, ["Mega"] = 234.14, ["Mega|Ride"] = 410.01, ["Mega|Fly|Ride"] = 314.92}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 77.3, ["Fly"] = 83.75, ["Ride"] = 90.85, ["Fly|Ride"] = 154.66, ["Neon"] = 423.78, ["Neon|Ride"] = 342.56, ["Neon|Fly|Ride"] = 300.3, ["Mega|Fly|Ride"] = 976.42}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 4.25, ["Ride"] = 39.38, ["Fly|Ride"] = 138.8, ["Neon"] = 28.62, ["Neon|Fly"] = 269.1, ["Neon|Ride"] = 113.58, ["Neon|Fly|Ride"] = 141.98, ["Mega"] = 85.32, ["Mega|Fly"] = 989.5, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 368.78}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 15.16, ["Fly"] = 65.63, ["Ride"] = 26.25, ["Fly|Ride"] = 94.37, ["Neon"] = 141.98, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 186.36, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 32.28, ["Ride"] = 54.28, ["Fly|Ride"] = 156.19, ["Neon"] = 157.5, ["Neon|Ride"] = 349.12, ["Mega"] = 706.65, ["Mega|Ride"] = 1161.57}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 18.38, ["Fly"] = 47.19, ["Ride"] = 30.74, ["Fly|Ride"] = 82.69, ["Neon"] = 103.69, ["Neon|Fly"] = 423.78, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 211.91, ["Mega|Fly|Ride"] = 945}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 5040, ["Ride"] = 5906.25, ["Fly|Ride"] = 4593.75, ["Neon"] = 31077.95, ["Neon|Fly|Ride"] = 23611.88}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 257.24, ["Fly"] = 264.87, ["Ride"] = 230.94, ["Fly|Ride"] = 281.81, ["Neon|Ride"] = 707.66, ["Neon|Fly|Ride"] = 617.73, ["Mega|Fly|Ride"] = 2934.91}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 35.13, ["Fly"] = 99.61, ["Ride"] = 65.63, ["Fly|Ride"] = 113.37, ["Neon"] = 73.02, ["Neon|Fly"] = 241.5, ["Neon|Ride"] = 96.75, ["Neon|Fly|Ride"] = 187.69, ["Mega"] = 285.79, ["Mega|Fly"] = 374.07, ["Mega|Ride"] = 313.84, ["Mega|Fly|Ride"] = 438.41}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.59, ["Fly"] = 41.29, ["Ride"] = 20.9, ["Fly|Ride"] = 99.61, ["Neon"] = 19.69, ["Neon|Ride"] = 52.5, ["Mega"] = 179.82}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 32.81, ["Fly"] = 50.72, ["Ride"] = 75.51, ["Fly|Ride"] = 149.46, ["Neon"] = 112.88, ["Neon|Fly"] = 265.93, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 291.38, ["Mega"] = 491.58, ["Mega|Ride"] = 448.02, ["Mega|Fly|Ride"] = 531.25}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 18363.91, ["Ride"] = 14153.01, ["Fly|Ride"] = 10645.69, ["Neon|Fly|Ride"] = 23625, ["Mega|Fly|Ride"] = 91811.01}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 152.25, ["Fly"] = 198.13, ["Ride"] = 186.92, ["Fly|Ride"] = 266.44, ["Neon"] = 845.43, ["Neon|Ride"] = 794.58, ["Neon|Fly|Ride"] = 847.54, ["Mega|Fly|Ride"] = 7076.51}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 47.01, ["Fly"] = 459.38, ["Ride"] = 65.63, ["Fly|Ride"] = 91.88, ["Neon|Fly"] = 471.78, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 288.75, ["Mega|Fly|Ride"] = 1979}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 9.18, ["Fly"] = 31.86, ["Ride"] = 26.25, ["Fly|Ride"] = 65.54, ["Neon"] = 65.63, ["Neon|Fly"] = 71, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 480.99, ["Mega|Ride"] = 492.19, ["Mega|Fly|Ride"] = 528.67}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 366.17, ["Fly"] = 847.54, ["Ride"] = 399, ["Fly|Ride"] = 472.5, ["Neon"] = 1639.32, ["Neon|Ride"] = 1311.19, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4935}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.56, ["Ride"] = 36.04, ["Fly|Ride"] = 141.54, ["Neon"] = 29.54, ["Neon|Ride"] = 83.91, ["Neon|Fly|Ride"] = 239.45, ["Mega"] = 113.37, ["Mega|Ride"] = 167.58, ["Mega|Fly|Ride"] = 292.51}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 144.38, ["Fly"] = 211.91, ["Ride"] = 196.88, ["Fly|Ride"] = 273, ["Neon"] = 678.04, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 648.38, ["Mega|Ride"] = 3461.13, ["Mega|Fly|Ride"] = 2401.7}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 12.99, ["Fly"] = 21, ["Ride"] = 19.69, ["Fly|Ride"] = 34.21, ["Neon|Ride"] = 93.09, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 786.19, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 9.08}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 57.75, ["Ride"] = 72.19, ["Fly|Ride"] = 525, ["Neon"] = 209.77, ["Neon|Fly"] = 1695.07, ["Neon|Ride"] = 370.81, ["Neon|Fly|Ride"] = 471.45, ["Mega"] = 1269.19, ["Mega|Ride"] = 1415.32, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 13.13, ["Fly"] = 104.89, ["Ride"] = 33.9, ["Fly|Ride"] = 84, ["Neon"] = 94.84, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 181.13, ["Mega"] = 467.21, ["Mega|Ride"] = 501.48, ["Mega|Fly|Ride"] = 968.31}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 14.41}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 24.57, ["Fly"] = 111.57, ["Ride"] = 57.75, ["Fly|Ride"] = 236.25, ["Neon"] = 165.38, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 240.48, ["Mega"] = 1130.41, ["Mega|Ride"] = 678.04, ["Mega|Fly|Ride"] = 746.82}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.94, ["Ride"] = 37.09, ["Fly|Ride"] = 131.25, ["Neon"] = 23.39, ["Neon|Ride"] = 138.8, ["Neon|Fly|Ride"] = 122.91, ["Mega"] = 85.31, ["Mega|Fly|Ride"] = 616.23}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 13.12, ["Fly"] = 42, ["Ride"] = 32.85, ["Fly|Ride"] = 99.45, ["Neon"] = 148.34, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 226.73, ["Mega|Ride"] = 579.51, ["Mega|Fly|Ride"] = 759.94}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 409.5, ["Fly"] = 437.75, ["Ride"] = 328.12, ["Fly|Ride"] = 406.88, ["Neon|Fly|Ride"] = 1979, ["Mega|Fly|Ride"] = 8899.1}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 57.22, ["Ride"] = 53.64, ["Fly|Ride"] = 131.25, ["Neon"] = 156.77, ["Neon|Ride"] = 205.54, ["Neon|Fly|Ride"] = 165.14, ["Mega"] = 704.96, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 735.25}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 45.85, ["Fly"] = 83.91, ["Ride"] = 72.07, ["Fly|Ride"] = 138.55, ["Neon"] = 203.1, ["Neon|Ride"] = 149.63, ["Neon|Fly|Ride"] = 339.03, ["Mega"] = 1352.8, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 948.19}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 26.23, ["Fly"] = 68.25, ["Ride"] = 45.94, ["Fly|Ride"] = 131.25, ["Neon"] = 100.82, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 283.07, ["Mega"] = 360.22, ["Mega|Ride"] = 405.57, ["Mega|Fly|Ride"] = 522.38}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 9843.75, ["Ride"] = 11322.41, ["Fly|Ride"] = 7481.25, ["Neon|Fly|Ride"] = 19068.41, ["Mega|Fly|Ride"] = 39372.9}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1780.27, ["Ride"] = 1732.5, ["Fly|Ride"] = 1640.63, ["Neon|Fly|Ride"] = 4731.57, ["Mega|Fly|Ride"] = 22312.5}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 388.5, ["Ride"] = 466.15, ["Fly|Ride"] = 393.75, ["Neon"] = 2118.84, ["Neon|Ride"] = 1733.22, ["Neon|Fly|Ride"] = 1377.26, ["Mega"] = 16950.65, ["Mega|Fly|Ride"] = 6498.47}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 12.92, ["Fly"] = 29.51, ["Ride"] = 23.61, ["Fly|Ride"] = 39.38, ["Neon"] = 109.13, ["Neon|Ride"] = 113.37, ["Neon|Fly|Ride"] = 105, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 6.38, ["Ride"] = 37.09, ["Fly|Ride"] = 124.69, ["Neon"] = 23.61, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 141.98, ["Mega|Ride"] = 148.34, ["Mega|Fly|Ride"] = 220.57}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 44.5, ["Fly"] = 28.88, ["Ride"] = 45.93, ["Fly|Ride"] = 93, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 176.65, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.66, ["Fly"] = 27.57, ["Ride"] = 18.38, ["Fly|Ride"] = 39.38, ["Neon"] = 22.32, ["Neon|Fly"] = 282.87, ["Neon|Ride"] = 38.06, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 360.94, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 317.84}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 328.13, ["Fly"] = 315, ["Ride"] = 342.57, ["Fly|Ride"] = 367.5, ["Neon"] = 1887.08, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1285.73, ["Mega|Fly|Ride"] = 5661.22}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 30.85, ["Fly"] = 48.19, ["Ride"] = 36.16, ["Fly|Ride"] = 71, ["Neon"] = 127.61, ["Neon|Fly"] = 282.87, ["Neon|Ride"] = 156.95, ["Neon|Fly|Ride"] = 178.1, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 11.58, ["Fly"] = 28.29, ["Ride"] = 23.33, ["Fly|Ride"] = 42, ["Neon"] = 141.98, ["Neon|Fly"] = 127.15, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 529.73, ["Mega|Ride"] = 583.75, ["Mega|Fly|Ride"] = 1128.75}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 564.82, ["Fly"] = 787.5, ["Ride"] = 459.38, ["Fly|Ride"] = 795.63, ["Neon|Ride"] = 2754.5, ["Mega|Fly|Ride"] = 8619.19}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1123.49, ["Fly"] = 1415.32, ["Ride"] = 1170.75, ["Fly|Ride"] = 1181.25, ["Neon"] = 4958.07, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 16525.82}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 81.36, ["Fly"] = 126.21, ["Ride"] = 93.19, ["Fly|Ride"] = 112.88, ["Neon"] = 423.78, ["Neon|Ride"] = 414.75, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 1640.63}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 181.69, ["Fly"] = 226.73, ["Ride"] = 157.5, ["Fly|Ride"] = 224.44, ["Neon"] = 651.06, ["Neon|Fly"] = 889.92, ["Neon|Ride"] = 629.5, ["Neon|Fly|Ride"] = 611.08, ["Mega|Ride"] = 2966.38, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 24.93, ["Fly"] = 131.25, ["Ride"] = 44.5, ["Neon"] = 183.75, ["Neon|Fly"] = 423.78, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 325.26, ["Mega|Ride"] = 943.55, ["Mega|Fly|Ride"] = 865.7}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 137.73, ["Ride"] = 275.46, ["Fly|Ride"] = 597.19, ["Neon"] = 1059.43, ["Mega|Fly|Ride"] = 2830.62}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2118.83, ["Fly"] = 2534.13, ["Ride"] = 2303.17, ["Fly|Ride"] = 2161.22, ["Neon|Fly|Ride"] = 7204.04, ["Mega|Fly|Ride"] = 48733.09}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 46.59, ["Ride"] = 49.88, ["Fly|Ride"] = 156.79, ["Neon"] = 291.36, ["Neon|Fly"] = 211.91, ["Neon|Ride"] = 282.87, ["Neon|Fly|Ride"] = 296.66, ["Mega"] = 2112.48, ["Mega|Ride"] = 2330.72, ["Mega|Fly|Ride"] = 1809.24}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 603.75, ["Fly"] = 675.94, ["Ride"] = 590.63, ["Fly|Ride"] = 634.58, ["Neon|Ride"] = 1499.04, ["Neon|Fly|Ride"] = 1275.43, ["Mega|Fly|Ride"] = 2945.25}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 28.88, ["Fly"] = 60.38, ["Ride"] = 52.5, ["Fly|Ride"] = 68.25, ["Neon|Ride"] = 513.45, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 1456.88}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.93, ["Fly"] = 31.49, ["Ride"] = 19.08, ["Fly|Ride"] = 48.75, ["Neon"] = 24.69, ["Neon|Fly"] = 150.15, ["Neon|Ride"] = 49.81, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 134.25, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 40.69, ["Ride"] = 52.41, ["Fly|Ride"] = 78.75, ["Neon"] = 1413.28, ["Neon|Ride"] = 777.62, ["Neon|Fly|Ride"] = 312.55, ["Mega|Ride"] = 1413.28, ["Mega|Fly|Ride"] = 943.55}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 556.12, ["Fly"] = 899.07, ["Ride"] = 563.16, ["Fly|Ride"] = 594.69, ["Neon"] = 2430.83, ["Neon|Ride"] = 1771.88, ["Neon|Fly|Ride"] = 1788.63, ["Mega|Fly|Ride"] = 5250}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 551.25, ["Ride"] = 498.75, ["Fly|Ride"] = 672.76, ["Neon"] = 35310.31, ["Neon|Ride"] = 4068.75, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 9461.65}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 15.68, ["Fly"] = 26.25, ["Ride"] = 24.94, ["Fly|Ride"] = 41.33, ["Neon"] = 211.91, ["Neon|Ride"] = 99.61, ["Neon|Fly|Ride"] = 105, ["Mega"] = 787.5, ["Mega|Fly|Ride"] = 580.06}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 6.55, ["Ride"] = 22.32, ["Fly|Ride"] = 59.07, ["Neon"] = 125.81, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 1692.96, ["Mega|Ride"] = 448.14, ["Mega|Fly|Ride"] = 1207.5}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 5.25, ["Ride"] = 35.4, ["Fly|Ride"] = 87.93, ["Neon"] = 19.69, ["Neon|Fly"] = 113.3, ["Neon|Ride"] = 47.19, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 134.56, ["Mega|Fly"] = 405.72, ["Mega|Ride"] = 186.38, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 44.72, ["Fly"] = 56.8, ["Ride"] = 45.94, ["Fly|Ride"] = 98.63, ["Neon"] = 235.9, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 243.22, ["Mega|Fly|Ride"] = 829.14}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 45.94, ["Ride"] = 91.88, ["Fly|Ride"] = 449.61, ["Neon"] = 343.25, ["Neon|Ride"] = 253.87, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1363.48, ["Mega|Ride"] = 1482.13, ["Mega|Fly|Ride"] = 1554.18}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 18.79, ["Fly"] = 57.14, ["Ride"] = 36.58, ["Fly|Ride"] = 76.3, ["Neon"] = 118.13, ["Neon|Ride"] = 93.18, ["Neon|Fly|Ride"] = 160.02, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 489.47}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 31.49, ["Fly"] = 99.61, ["Ride"] = 32.82, ["Fly|Ride"] = 70.93, ["Neon"] = 351.74, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 174.56, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1130.41}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.82, ["Fly"] = 31.49, ["Ride"] = 18.38, ["Fly|Ride"] = 46.64, ["Neon"] = 31.5, ["Neon|Ride"] = 40.3, ["Neon|Fly|Ride"] = 88.36, ["Mega"] = 183.75, ["Mega|Ride"] = 211.91, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.28, ["Fly"] = 71, ["Ride"] = 31.5, ["Fly|Ride"] = 71, ["Neon"] = 27.28, ["Neon|Fly"] = 158.06, ["Neon|Ride"] = 44.5, ["Neon|Fly|Ride"] = 114.19, ["Mega"] = 236.27, ["Mega|Fly"] = 480.99, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 423.78}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 47.25, ["Fly"] = 60.38, ["Ride"] = 55.13, ["Fly|Ride"] = 52.5, ["Neon"] = 583.75, ["Neon|Ride"] = 211.91, ["Neon|Fly|Ride"] = 221.53, ["Mega|Fly|Ride"] = 918.64}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1903.13, ["Fly"] = 2169.2, ["Ride"] = 1764, ["Fly|Ride"] = 1674.62, ["Neon|Ride"] = 5296.04, ["Neon|Fly|Ride"] = 3916.5, ["Mega|Fly|Ride"] = 15051.75}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 444.94, ["Fly"] = 636.9, ["Ride"] = 535.5, ["Fly|Ride"] = 471.78, ["Neon"] = 3145.52, ["Neon|Ride"] = 3108.34, ["Neon|Fly|Ride"] = 1837.04, ["Mega|Fly|Ride"] = 9746.64}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 220.16, ["Fly"] = 339.03, ["Ride"] = 272.99, ["Fly|Ride"] = 328.13, ["Neon"] = 1413.28, ["Neon|Ride"] = 1438.69, ["Neon|Fly|Ride"] = 1413.28, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 50.23}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 28.58, ["Fly"] = 65.63, ["Ride"] = 47.18, ["Fly|Ride"] = 103.69, ["Neon"] = 206.07, ["Neon|Ride"] = 254.26, ["Neon|Fly|Ride"] = 381.41, ["Mega|Ride"] = 1554.18, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 33901.28, ["Fly"] = 23625, ["Ride"] = 34781.25, ["Fly|Ride"] = 17576.83, ["Neon|Fly|Ride"] = 36169.17, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 288.75, ["Fly"] = 363.44, ["Ride"] = 328.13, ["Fly|Ride"] = 395.69, ["Neon"] = 1139.95, ["Neon|Fly"] = 1604.02, ["Neon|Ride"] = 989.5, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 6356.51, ["Mega|Ride"] = 6604.75, ["Mega|Fly|Ride"] = 2624.99}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 105, ["Fly"] = 525, ["Ride"] = 188.6, ["Fly|Ride"] = 154.88, ["Neon|Fly|Ride"] = 1059.43}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 118.13, ["Ride"] = 132.56, ["Fly|Ride"] = 185.07, ["Neon|Ride"] = 741.5, ["Neon|Fly|Ride"] = 525, ["Mega"] = 14126.25, ["Mega|Fly|Ride"] = 1801.02}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 19.08, ["Fly"] = 94.5, ["Ride"] = 32.86, ["Fly|Ride"] = 98.44, ["Neon"] = 126.21, ["Neon|Ride"] = 135.19, ["Neon|Fly|Ride"] = 268.12, ["Mega"] = 1968.75, ["Mega|Fly|Ride"] = 614.48}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 5087.6, ["Ride"] = 5032.58, ["Fly|Ride"] = 4003.13, ["Neon|Ride"] = 16950.65, ["Neon|Fly|Ride"] = 17657.28, ["Mega|Fly|Ride"] = 70628.01}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 28.77, ["Fly"] = 45.93, ["Ride"] = 30.19, ["Fly|Ride"] = 60.38, ["Neon"] = 333.94, ["Neon|Ride"] = 220.57, ["Neon|Fly|Ride"] = 157.5, ["Mega|Fly|Ride"] = 685.13}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 44.6, ["Fly"] = 141.98, ["Ride"] = 47.25, ["Fly|Ride"] = 110.88, ["Neon"] = 240.51, ["Neon|Fly"] = 1413.28, ["Neon|Ride"] = 282.87, ["Neon|Fly|Ride"] = 277.57, ["Mega"] = 1101.59, ["Mega|Fly|Ride"] = 1006.69}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 602.05, ["Ride"] = 619.5, ["Fly|Ride"] = 715.78, ["Neon"] = 1680, ["Neon|Ride"] = 1573.92, ["Neon|Fly|Ride"] = 1542.19, ["Mega"] = 5401.97, ["Mega|Fly|Ride"] = 4725}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 14.43, ["Fly"] = 28.88, ["Ride"] = 24.36, ["Fly|Ride"] = 42, ["Neon"] = 98.44, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 129.21, ["Mega"] = 777.62, ["Mega|Fly|Ride"] = 523.68}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 17.05, ["Ride"] = 71, ["Fly|Ride"] = 471.78, ["Neon"] = 45.94, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 249.38, ["Mega|Ride"] = 566.13}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 102.38, ["Ride"] = 154.88, ["Fly|Ride"] = 126.21, ["Neon"] = 750.12, ["Neon|Ride"] = 706.65, ["Neon|Fly|Ride"] = 740.55, ["Mega|Fly|Ride"] = 2193.18}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 24.93, ["Ride"] = 99.61, ["Fly|Ride"] = 126.21, ["Neon"] = 99.6, ["Neon|Fly"] = 141.98, ["Neon|Ride"] = 133.45, ["Neon|Fly|Ride"] = 275.46, ["Mega"] = 273, ["Mega|Fly"] = 708.75, ["Mega|Ride"] = 306.49, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3189.38, ["Ride"] = 3215.63, ["Fly|Ride"] = 3255, ["Neon"] = 13125, ["Neon|Ride"] = 18010.07, ["Neon|Fly|Ride"] = 8505, ["Mega"] = 63564.88, ["Mega|Fly|Ride"] = 34468.88}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 30.18, ["Fly"] = 39.38, ["Ride"] = 84.76, ["Fly|Ride"] = 146.22, ["Neon"] = 168, ["Neon|Ride"] = 198.13, ["Neon|Fly|Ride"] = 345.39, ["Mega|Fly|Ride"] = 847.54}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 6956.25, ["Ride"] = 8491.82, ["Fly|Ride"] = 6267.19, ["Neon|Fly|Ride"] = 16329.07, ["Mega|Fly|Ride"] = 60740.5}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.63, ["Fly"] = 23.5, ["Ride"] = 16.96, ["Fly|Ride"] = 35.4, ["Neon"] = 25.44, ["Neon|Fly"] = 91.8, ["Neon|Ride"] = 40.11, ["Neon|Fly|Ride"] = 76.13, ["Mega"] = 281.81, ["Mega|Ride"] = 282.87, ["Mega|Fly|Ride"] = 343.27}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 20.62, ["Fly"] = 32.85, ["Ride"] = 26.25, ["Fly|Ride"] = 57.22, ["Neon"] = 202.36, ["Neon|Fly"] = 141.98, ["Neon|Ride"] = 559.37, ["Neon|Fly|Ride"] = 210.83, ["Mega|Ride"] = 1542.85, ["Mega|Fly|Ride"] = 927.94}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.94}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 16.72, ["Ride"] = 36.63, ["Fly|Ride"] = 127.15, ["Neon"] = 158.06, ["Neon|Ride"] = 127.24, ["Neon|Fly|Ride"] = 133.5, ["Mega"] = 706.65, ["Mega|Ride"] = 989.5, ["Mega|Fly|Ride"] = 865.7}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 34.13, ["Fly"] = 262.5, ["Ride"] = 62.77, ["Fly|Ride"] = 141.98, ["Neon"] = 110.88, ["Neon|Ride"] = 154.09, ["Neon|Fly|Ride"] = 282.86, ["Mega"] = 840, ["Mega|Ride"] = 943.55, ["Mega|Fly|Ride"] = 931.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 8.49, ["Fly"] = 23.94, ["Ride"] = 22.32, ["Fly|Ride"] = 39.38, ["Neon"] = 141.61, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 168.47, ["Mega"] = 820.32, ["Mega|Ride"] = 588.54, ["Mega|Fly|Ride"] = 678.18}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8376.81}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 3123.18}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 23.63}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 141.75, ["Fly"] = 174.57, ["Ride"] = 189, ["Fly|Ride"] = 353.85}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 28.32, ["Fly"] = 133.5, ["Ride"] = 52.99, ["Fly|Ride"] = 105, ["Neon"] = 224.6, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 456.44, ["Mega|Ride"] = 943.55, ["Mega|Fly|Ride"] = 706.65}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 9.08}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 9.19, ["Neon|Ride"] = 84.76, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2572.5}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 197.38, ["Ride"] = 159.99, ["Fly|Ride"] = 10498.95, ["Neon"] = 918.75, ["Neon|Ride"] = 706.65, ["Mega|Fly|Ride"] = 2627.36}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 120.75, ["Ride"] = 178.5, ["Fly|Ride"] = 314.92, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1052.05, ["Mega"] = 3443.11, ["Mega|Ride"] = 2260.81, ["Mega|Fly|Ride"] = 1875.19}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 177.12, ["Ride"] = 169.32, ["Fly|Ride"] = 218.92, ["Neon"] = 799.32, ["Neon|Ride"] = 840, ["Neon|Fly|Ride"] = 842.03, ["Mega"] = 4661.44, ["Mega|Fly|Ride"] = 2269.32}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1181.24, ["Fly"] = 2542.61, ["Ride"] = 1311.19, ["Fly|Ride"] = 1292.69, ["Neon"] = 5368.07, ["Neon|Ride"] = 5354.29, ["Neon|Fly|Ride"] = 4593.75, ["Mega|Fly|Ride"] = 21187.25}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 19.69, ["Fly"] = 102.62, ["Ride"] = 39.38, ["Fly|Ride"] = 84.76, ["Neon"] = 141.98, ["Neon|Ride"] = 297.23, ["Neon|Fly|Ride"] = 422.63, ["Mega"] = 846.49, ["Mega|Fly|Ride"] = 918.53}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 656.25, ["Fly"] = 2100, ["Ride"] = 688.51, ["Fly|Ride"] = 847.54}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 93.19}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 15.75, ["Fly"] = 393.75, ["Ride"] = 36.75, ["Fly|Ride"] = 98.44, ["Neon"] = 90.57, ["Neon|Ride"] = 141.98, ["Neon|Fly|Ride"] = 494.75, ["Mega"] = 363.57, ["Mega|Ride"] = 441.79, ["Mega|Fly|Ride"] = 847.54}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 9.19, ["Fly"] = 131.25, ["Ride"] = 27.57, ["Fly|Ride"] = 94.5, ["Neon"] = 60.4, ["Neon|Ride"] = 83.61, ["Neon|Fly|Ride"] = 167.78, ["Mega"] = 423.78, ["Mega|Ride"] = 471.78, ["Mega|Fly|Ride"] = 619.5}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 73.5}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 26.25, ["Fly"] = 108.92, ["Ride"] = 36.03, ["Fly|Ride"] = 65.54, ["Neon"] = 116.82, ["Neon|Ride"] = 158.93, ["Neon|Fly|Ride"] = 597.98, ["Mega"] = 821.06, ["Mega|Ride"] = 847.54, ["Mega|Fly|Ride"] = 1228.94}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 27.56, ["Fly"] = 117.96, ["Ride"] = 30.19, ["Fly|Ride"] = 63.58, ["Neon|Ride"] = 141.98, ["Neon|Fly|Ride"] = 274.32, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 5250, ["Fly"] = 11300.8, ["Ride"] = 6460.33, ["Fly|Ride"] = 4697.44, ["Neon|Ride"] = 15539.51, ["Neon|Fly|Ride"] = 10500, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 11.46, ["Fly"] = 34.13, ["Ride"] = 32.82, ["Fly|Ride"] = 99.49, ["Neon"] = 65.63, ["Neon|Ride"] = 100.66, ["Neon|Fly|Ride"] = 353.85, ["Mega"] = 528.4, ["Mega|Ride"] = 451.33, ["Mega|Fly|Ride"] = 417.38}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 26.25}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 115.5, ["Fly"] = 375.04, ["Ride"] = 163.16, ["Fly|Ride"] = 234.14, ["Neon"] = 418.69, ["Neon|Ride"] = 481.69, ["Neon|Fly|Ride"] = 596.72, ["Mega|Ride"] = 4237.67, ["Mega|Fly|Ride"] = 1858.23}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 75.55, ["Ride"] = 101.07, ["Fly|Ride"] = 165.57, ["Neon"] = 327.6, ["Neon|Ride"] = 346.44, ["Neon|Fly|Ride"] = 511.88, ["Mega|Ride"] = 2859.39, ["Mega|Fly|Ride"] = 1689.78}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 21, ["Fly"] = 72.17, ["Ride"] = 31.8, ["Fly|Ride"] = 63.58, ["Neon"] = 169.52, ["Neon|Ride"] = 110.25, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 692.87, ["Mega|Ride"] = 635.66, ["Mega|Fly|Ride"] = 656.22}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6.29, ["Fly"] = 49.26, ["Ride"] = 36.04, ["Fly|Ride"] = 91.12, ["Neon"] = 27.39, ["Neon|Fly"] = 184.36, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 169.52, ["Mega"] = 118.13, ["Mega|Fly"] = 7034.11, ["Mega|Ride"] = 167.02, ["Mega|Fly|Ride"] = 246.58}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 13.64, ["Fly"] = 64.22, ["Ride"] = 42, ["Fly|Ride"] = 91.88, ["Neon"] = 80.51, ["Neon|Ride"] = 110.88, ["Neon|Fly|Ride"] = 279.25, ["Mega"] = 328.13, ["Mega|Ride"] = 410.82, ["Mega|Fly|Ride"] = 471.78}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 23.57, ["Fly"] = 36.04, ["Ride"] = 27.57, ["Fly|Ride"] = 55.9, ["Neon"] = 254.24, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 126.36, ["Mega|Fly|Ride"] = 653.79}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 213.94}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 19.08, ["Ride"] = 95.82, ["Neon"] = 136.5, ["Neon|Ride"] = 423.78, ["Mega"] = 1367.72, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1553.12}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 170.62, ["Ride"] = 443.63, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 820.32}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 41.33, ["Fly"] = 211.99, ["Ride"] = 91.88, ["Fly|Ride"] = 269.1, ["Neon"] = 196.88, ["Neon|Fly"] = 353.85, ["Neon|Ride"] = 290.29, ["Neon|Fly|Ride"] = 420, ["Mega"] = 1138.89, ["Mega|Ride"] = 1093.33, ["Mega|Fly|Ride"] = 1063.13}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 708.74, ["Fly"] = 780.94, ["Ride"] = 712.69, ["Fly|Ride"] = 748.32, ["Neon|Ride"] = 2231.25, ["Neon|Fly|Ride"] = 2272.07, ["Mega|Fly|Ride"] = 6956.25}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 262.5, ["Ride"] = 330.75, ["Fly|Ride"] = 421.61, ["Neon"] = 1554.18, ["Neon|Ride"] = 2045.13, ["Neon|Fly|Ride"] = 1342.29, ["Mega"] = 6132.97, ["Mega|Fly|Ride"] = 4068.75}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 78.75}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 3.62}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 11.58, ["Fly"] = 31.48, ["Ride"] = 23.61, ["Fly|Ride"] = 47.19, ["Neon"] = 77.95, ["Neon|Ride"] = 97.5, ["Neon|Fly|Ride"] = 127.15, ["Mega"] = 405.77, ["Mega|Fly|Ride"] = 452.82}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 262.5, ["Fly"] = 989.5, ["Ride"] = 327.37, ["Fly|Ride"] = 395.59, ["Neon"] = 1086.75, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1003.97, ["Mega|Fly|Ride"] = 3658.18}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 15.74}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 98.44, ["Fly"] = 590.63, ["Ride"] = 141.95, ["Fly|Ride"] = 254.77, ["Neon"] = 525, ["Neon|Fly"] = 1413.28, ["Neon|Ride"] = 626.54, ["Neon|Fly|Ride"] = 635.66, ["Mega"] = 2006.54, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 129.94, ["Ride"] = 170.63, ["Fly|Ride"] = 211.91, ["Neon"] = 989.5, ["Neon|Ride"] = 889.92}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 5.97, ["Ride"] = 31.75, ["Fly|Ride"] = 205.54, ["Neon"] = 53.81, ["Neon|Ride"] = 59.07, ["Mega"] = 216.14, ["Mega|Ride"] = 312.55, ["Mega|Fly|Ride"] = 394.11}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 15.91, ["Fly"] = 62.99, ["Ride"] = 27.57, ["Fly|Ride"] = 65.63, ["Neon"] = 122.19, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 247.92, ["Mega|Ride"] = 706.65, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 23.63, ["Fly"] = 127.15, ["Ride"] = 62.52, ["Fly|Ride"] = 141.39, ["Neon"] = 169.32, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 271.23, ["Mega"] = 498.74, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 707.66}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 5.25, ["Fly"] = 93.24, ["Ride"] = 49.81, ["Fly|Ride"] = 111.18, ["Neon"] = 22.32, ["Neon|Ride"] = 56.8, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 124.69, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 255.94}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 262.5, ["Fly"] = 918.75, ["Ride"] = 321.64, ["Fly|Ride"] = 368.82, ["Neon"] = 1554.18, ["Neon|Ride"] = 1214.07, ["Neon|Fly|Ride"] = 918.75, ["Mega|Fly|Ride"] = 6142.5}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 83.71, ["Fly"] = 1050, ["Ride"] = 124.69, ["Fly|Ride"] = 223.13, ["Neon"] = 393.75, ["Neon|Ride"] = 459.37, ["Neon|Fly|Ride"] = 584.07, ["Mega"] = 1792.88, ["Mega|Ride"] = 1929.38, ["Mega|Fly|Ride"] = 1653.32}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 78.41, ["Fly"] = 167.45, ["Ride"] = 89.67, ["Fly|Ride"] = 128.63, ["Neon|Ride"] = 321.57, ["Neon|Fly|Ride"] = 460.69, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 21.2, ["Ride"] = 33.92, ["Fly|Ride"] = 282.87, ["Neon|Ride"] = 599.16, ["Neon|Fly|Ride"] = 493.7, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 18.04, ["Ride"] = 34.47, ["Fly|Ride"] = 102.38, ["Neon"] = 87.95, ["Neon|Ride"] = 95.82, ["Neon|Fly|Ride"] = 168, ["Mega"] = 578.82, ["Mega|Fly"] = 525, ["Mega|Ride"] = 393.06, ["Mega|Fly|Ride"] = 444.36}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.63, ["Fly"] = 23.63, ["Ride"] = 24.94, ["Fly|Ride"] = 79.04, ["Neon"] = 18.36, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 101.07, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 229.69}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 958.13, ["Fly"] = 1271.31, ["Ride"] = 997.5, ["Fly|Ride"] = 995.82, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2493.73, ["Mega|Fly|Ride"] = 8400}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 353.85, ["Fly"] = 485.23, ["Ride"] = 393.75, ["Fly|Ride"] = 466.87, ["Neon"] = 1413.28, ["Neon|Ride"] = 1680, ["Neon|Fly|Ride"] = 1342.29, ["Mega"] = 10594.16, ["Mega|Fly|Ride"] = 5367.01}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 93.18, ["Ride"] = 140.44, ["Fly|Ride"] = 182.23, ["Neon"] = 377.43, ["Neon|Ride"] = 299.59, ["Neon|Fly|Ride"] = 433.13, ["Mega|Fly|Ride"] = 1887.08}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 262.5, ["Fly"] = 339.03, ["Ride"] = 262.85, ["Fly|Ride"] = 304.6, ["Neon|Ride"] = 1017.06, ["Neon|Fly|Ride"] = 847.54, ["Mega"] = 10594.16, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 26.55, ["Fly"] = 52.5, ["Ride"] = 35.44, ["Fly|Ride"] = 85.32, ["Neon"] = 157.49, ["Neon|Ride"] = 84.76, ["Neon|Fly|Ride"] = 141.96, ["Mega|Ride"] = 706.65, ["Mega|Fly|Ride"] = 618.87}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 422.77, ["Ride"] = 423.78, ["Fly|Ride"] = 453.3, ["Neon"] = 1584.98, ["Neon|Fly|Ride"] = 2401.7, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 6886.21}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 97.13, ["Fly"] = 141.98, ["Ride"] = 95.71, ["Fly|Ride"] = 105.96, ["Neon"] = 423.78, ["Neon|Ride"] = 504.8, ["Neon|Fly|Ride"] = 590.63, ["Mega|Fly|Ride"] = 1397.82}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1246.88, ["Ride"] = 1312.5, ["Fly|Ride"] = 1365, ["Neon|Fly|Ride"] = 4481.79, ["Mega"] = 50851.91, ["Mega|Fly|Ride"] = 24720.4}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 14.17, ["Fly"] = 75.92, ["Ride"] = 26.25, ["Fly|Ride"] = 87.95, ["Neon"] = 41.58, ["Neon|Fly"] = 158.06, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 154.88, ["Mega"] = 244.12, ["Mega|Ride"] = 263.02, ["Mega|Fly|Ride"] = 368.1}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 65.69, ["Ride"] = 84, ["Fly|Ride"] = 161.44, ["Neon"] = 315, ["Neon|Ride"] = 238.26, ["Neon|Fly|Ride"] = 549.86, ["Mega"] = 2118.84, ["Mega|Ride"] = 1356.07, ["Mega|Fly|Ride"] = 1403.17}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 47.25, ["Fly"] = 91.88, ["Ride"] = 61.66, ["Fly|Ride"] = 78.73, ["Neon|Ride"] = 410.82, ["Neon|Fly|Ride"] = 325.26, ["Mega|Fly|Ride"] = 1384.35}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 1575, ["Ride"] = 1049.99, ["Fly|Ride"] = 976.91, ["Neon|Fly|Ride"] = 4199.99, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 525, ["Fly"] = 845.43, ["Ride"] = 559.38, ["Fly|Ride"] = 525, ["Neon|Ride"] = 1906.96, ["Neon|Fly|Ride"] = 1989.6, ["Mega|Fly|Ride"] = 14153.01}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 103.4, ["Fly"] = 314.92, ["Ride"] = 131.25, ["Fly|Ride"] = 210.67, ["Neon"] = 629.31, ["Neon|Ride"] = 462.11, ["Neon|Fly|Ride"] = 532.48, ["Mega"] = 4237.67, ["Mega|Ride"] = 2684.57, ["Mega|Fly|Ride"] = 4237.67}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 13.13, ["Fly"] = 39.38, ["Ride"] = 23.61, ["Fly|Ride"] = 71, ["Neon"] = 74.18, ["Neon|Ride"] = 89, ["Neon|Fly|Ride"] = 233.63, ["Mega"] = 761.25, ["Mega|Ride"] = 508.54, ["Mega|Fly|Ride"] = 989.5}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 32.81, ["Fly"] = 69.93, ["Ride"] = 48.57, ["Fly|Ride"] = 94.4, ["Neon"] = 204.75, ["Neon|Fly"] = 422.72, ["Neon|Ride"] = 210.82, ["Neon|Fly|Ride"] = 209.99, ["Mega"] = 1837.04, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 721.88, ["Ride"] = 872.82, ["Fly|Ride"] = 845.81, ["Neon|Ride"] = 2828.44, ["Neon|Fly|Ride"] = 3032.59, ["Mega|Fly|Ride"] = 21187.25}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 829.5}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4462.5, ["Ride"] = 4396.88, ["Fly|Ride"] = 4200, ["Neon|Ride"] = 30363.9, ["Neon|Fly|Ride"] = 21716.96, ["Mega|Fly|Ride"] = 90404.1}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 156.8, ["Fly"] = 423.72, ["Ride"] = 220.57, ["Fly|Ride"] = 423.78, ["Neon"] = 1695.07, ["Neon|Ride"] = 847.54, ["Neon|Fly|Ride"] = 1695.07, ["Mega"] = 5932.74, ["Mega|Fly|Ride"] = 6291.03}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 78.28, ["Fly"] = 282.87, ["Ride"] = 77.44, ["Fly|Ride"] = 336, ["Neon"] = 989.5, ["Neon|Ride"] = 471.45, ["Neon|Fly|Ride"] = 989.5, ["Mega|Fly|Ride"] = 2812.76}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 10.48, ["Fly"] = 57.22, ["Ride"] = 25.44, ["Fly|Ride"] = 105, ["Neon"] = 68.25, ["Neon|Ride"] = 84.76, ["Neon|Fly|Ride"] = 177.86, ["Mega"] = 697.11, ["Mega|Ride"] = 529.73, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 18.64, ["Fly"] = 28.3, ["Ride"] = 26.25, ["Fly|Ride"] = 40.1, ["Neon"] = 91.88, ["Neon|Ride"] = 84.76, ["Neon|Fly|Ride"] = 242.82, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 815.76}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 19.67, ["Fly"] = 52.5, ["Ride"] = 44.79, ["Fly|Ride"] = 91.11, ["Neon"] = 135.64, ["Neon|Ride"] = 119.95, ["Neon|Fly|Ride"] = 190.32, ["Mega|Ride"] = 565.74, ["Mega|Fly|Ride"] = 777.62}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.94, ["Fly"] = 57.22, ["Ride"] = 16.96, ["Fly|Ride"] = 61.46, ["Neon"] = 42.39, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 158.03, ["Mega|Ride"] = 239.45, ["Mega|Fly|Ride"] = 314.92}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 31.5, ["Ride"] = 57.22, ["Fly|Ride"] = 169.52, ["Neon"] = 148.1, ["Neon|Fly"] = 847.54, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 251.06, ["Mega"] = 694.99, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 847.54}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 297.21, ["Fly"] = 332.68, ["Ride"] = 269.07, ["Fly|Ride"] = 315, ["Neon"] = 868.73, ["Neon|Fly"] = 953.49, ["Neon|Ride"] = 943.53, ["Neon|Fly|Ride"] = 744.72, ["Mega"] = 6562.5, ["Mega|Fly|Ride"] = 2988.66}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.1, ["Fly"] = 22.97, ["Ride"] = 17.07, ["Fly|Ride"] = 36.75, ["Neon"] = 14.44, ["Neon|Ride"] = 37.09, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 141.54, ["Mega|Ride"] = 141.98, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 39.38, ["Fly"] = 130.93, ["Ride"] = 52.5, ["Fly|Ride"] = 110.25, ["Neon"] = 144.27, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 176.76, ["Neon|Fly|Ride"] = 233.25, ["Mega"] = 564.27, ["Mega|Ride"] = 547.3, ["Mega|Fly|Ride"] = 529.12}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 721.86, ["Fly"] = 1413.28, ["Ride"] = 761.25, ["Fly|Ride"] = 795.48, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1549.53, ["Mega|Fly|Ride"] = 3932.12}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 26.25, ["Fly"] = 107.63, ["Ride"] = 42.37, ["Fly|Ride"] = 91.88, ["Neon"] = 235.9, ["Neon|Fly"] = 471.78, ["Neon|Ride"] = 158.06, ["Neon|Fly|Ride"] = 210, ["Mega"] = 1575, ["Mega|Ride"] = 1130.41, ["Mega|Fly|Ride"] = 654.93}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 301.88, ["Fly"] = 341.25, ["Ride"] = 231, ["Fly|Ride"] = 288.75, ["Neon|Ride"] = 918.53, ["Neon|Fly|Ride"] = 1128.49, ["Mega|Fly|Ride"] = 4604.23}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 131.24, ["Fly"] = 179.82, ["Ride"] = 131.22, ["Fly|Ride"] = 141.75, ["Neon"] = 644.14, ["Neon|Fly"] = 644.14, ["Neon|Ride"] = 629.83, ["Neon|Fly|Ride"] = 566.49, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 599.2, ["Ride"] = 577.44, ["Fly|Ride"] = 678.57, ["Neon|Fly|Ride"] = 1939.51, ["Mega|Fly|Ride"] = 7217.44}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 21.63, ["Ride"] = 42.39, ["Fly|Ride"] = 156.8, ["Neon"] = 91.35, ["Neon|Fly"] = 283.07, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 158.06, ["Mega"] = 354.29, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4002.96, ["Fly"] = 3018.75, ["Ride"] = 3853.17, ["Fly|Ride"] = 3150, ["Neon|Fly|Ride"] = 6132.55, ["Mega|Fly|Ride"] = 23745.75}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 84.76, ["Fly"] = 170.63, ["Ride"] = 91.88, ["Fly|Ride"] = 137.73, ["Neon"] = 314.92, ["Neon|Ride"] = 446.25, ["Neon|Fly|Ride"] = 393.88, ["Mega|Fly|Ride"] = 1730.23}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.61, ["Fly"] = 28.62, ["Ride"] = 19.08, ["Fly|Ride"] = 39.38, ["Neon"] = 19.67, ["Neon|Fly"] = 42.24, ["Neon|Ride"] = 41.33, ["Neon|Fly|Ride"] = 80.53, ["Mega"] = 129.92, ["Mega|Fly"] = 452.82, ["Mega|Ride"] = 233.89, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.65, ["Ride"] = 27.54, ["Fly|Ride"] = 158.06, ["Neon"] = 24.69, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 175.88, ["Mega|Ride"] = 175.88, ["Mega|Fly|Ride"] = 278.2}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 45.34, ["Fly"] = 57.22, ["Ride"] = 41.94, ["Fly|Ride"] = 52.5, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 282.87, ["Mega|Fly|Ride"] = 1370.9}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 927.06, ["Ride"] = 1042.48, ["Fly|Ride"] = 1201.38, ["Neon"] = 5067.2, ["Neon|Fly|Ride"] = 3937.5}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 4803.4, ["Ride"] = 5897.09, ["Fly|Ride"] = 4803.4}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 20.97, ["Fly"] = 32.85, ["Ride"] = 28.32, ["Fly|Ride"] = 52.2, ["Neon"] = 261.86, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 131.34, ["Mega"] = 2428.13, ["Mega|Fly|Ride"] = 565.74}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 23.61, ["Fly"] = 70.79, ["Ride"] = 38.92, ["Fly|Ride"] = 80.07, ["Neon"] = 94.5, ["Neon|Fly"] = 141.98, ["Neon|Ride"] = 84.76, ["Neon|Fly|Ride"] = 169.52, ["Mega"] = 933.52, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 517.15}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 47.25, ["Fly"] = 157.49, ["Ride"] = 54.79, ["Fly|Ride"] = 85.32, ["Neon"] = 196.43, ["Neon|Ride"] = 267.75, ["Neon|Fly|Ride"] = 275.31, ["Mega"] = 945, ["Mega|Fly|Ride"] = 917.24}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 217.88, ["Fly"] = 314.92, ["Ride"] = 224.84, ["Fly|Ride"] = 266.64, ["Neon"] = 1215.17, ["Neon|Ride"] = 976.5, ["Neon|Fly|Ride"] = 945, ["Mega"] = 11165.55, ["Mega|Fly|Ride"] = 3506.46}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 5.25, ["Ride"] = 28.62, ["Fly|Ride"] = 105, ["Neon"] = 18.38, ["Neon|Fly"] = 70.95, ["Neon|Ride"] = 92.42, ["Neon|Fly|Ride"] = 211.91, ["Mega"] = 141.75, ["Mega|Ride"] = 198.13, ["Mega|Fly|Ride"] = 368}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 189, ["Fly"] = 211.91, ["Ride"] = 210, ["Fly|Ride"] = 300.89, ["Neon"] = 808.5, ["Neon|Ride"] = 744.19, ["Neon|Fly|Ride"] = 829.5, ["Mega|Fly|Ride"] = 3305.38}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.94, ["Fly"] = 18.38, ["Ride"] = 16.95, ["Fly|Ride"] = 39.11, ["Neon"] = 26.25, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 99.61, ["Mega"] = 196.88, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 300.81}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 196.88, ["Fly"] = 223.13, ["Ride"] = 234.14, ["Fly|Ride"] = 261.19, ["Neon|Ride"] = 1054.13, ["Neon|Fly|Ride"] = 847.54, ["Mega"] = 10594.16, ["Mega|Ride"] = 6356.51, ["Mega|Fly|Ride"] = 7666.22}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 12.64, ["Fly"] = 30.19, ["Ride"] = 31.4, ["Fly|Ride"] = 84.76, ["Neon"] = 78.41, ["Neon|Fly"] = 299.59, ["Neon|Ride"] = 138.8, ["Neon|Fly|Ride"] = 198.13, ["Mega"] = 522.41, ["Mega|Ride"] = 565.74, ["Mega|Fly|Ride"] = 467.21}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 4.76, ["Ride"] = 21.67, ["Neon"] = 13.12, ["Neon|Fly"] = 66.94, ["Neon|Ride"] = 48.41, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 76.13, ["Mega|Ride"] = 107, ["Mega|Fly|Ride"] = 226.31}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.05, ["Mega"] = 15.64, ["Mega|Ride"] = 135.64}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.93, ["Ride"] = 297.23, ["Fly|Ride"] = 220.38, ["Neon"] = 13.55, ["Neon|Ride"] = 65.58, ["Neon|Fly|Ride"] = 216.14, ["Mega"] = 68.16, ["Mega|Fly"] = 157256.26, ["Mega|Ride"] = 97.13}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 75.81, ["Fly"] = 102.38, ["Ride"] = 104.9, ["Fly|Ride"] = 154.77, ["Neon"] = 294.53, ["Neon|Ride"] = 309.36, ["Neon|Fly|Ride"] = 355.69, ["Mega|Fly|Ride"] = 1241.13}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 28.62, ["Ride"] = 18.27, ["Fly|Ride"] = 43.22, ["Neon"] = 10.4, ["Neon|Ride"] = 21.2, ["Neon|Fly|Ride"] = 105, ["Mega"] = 113.19, ["Mega|Ride"] = 98.34, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 13.13, ["Ride"] = 91.77, ["Fly|Ride"] = 195.76, ["Neon"] = 39.38, ["Neon|Ride"] = 103.69, ["Mega"] = 459.38, ["Mega|Ride"] = 635.66, ["Mega|Fly|Ride"] = 777.62}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.5, ["Neon|Ride"] = 31.4, ["Neon|Fly|Ride"] = 278.25, ["Mega"] = 11.69, ["Mega|Ride"] = 45.8, ["Mega|Fly|Ride"] = 116.62}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 21.11, ["Ride"] = 19.08, ["Fly|Ride"] = 31.75, ["Neon"] = 2.1, ["Neon|Fly"] = 16.96, ["Neon|Ride"] = 15.9, ["Neon|Fly|Ride"] = 42.39, ["Mega"] = 17.07, ["Mega|Fly"] = 27.57, ["Mega|Ride"] = 25.41, ["Mega|Fly|Ride"] = 95.37}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 15.61, ["Fly|Ride"] = 34.55, ["Neon"] = 3.94, ["Neon|Fly"] = 21.2, ["Neon|Ride"] = 15.33, ["Neon|Fly|Ride"] = 42.39, ["Mega"] = 50.87, ["Mega|Fly"] = 58.98, ["Mega|Ride"] = 39.19, ["Mega|Fly|Ride"] = 77.35}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Fly|Ride"] = 125.73, ["Neon"] = 2.52, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 58.98, ["Mega"] = 30.07, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 307.25}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 118.02, ["Ride"] = 31.85, ["Fly|Ride"] = 104.41, ["Neon"] = 9.19, ["Neon|Fly"] = 135.03, ["Neon|Ride"] = 93.22, ["Neon|Fly|Ride"] = 86, ["Mega"] = 38.14, ["Mega|Fly"] = 72.19, ["Mega|Ride"] = 92.01, ["Mega|Fly|Ride"] = 164.22}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 6.04, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 22.32, ["Mega|Ride"] = 76.13}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 47.16, ["Ride"] = 25.96, ["Fly|Ride"] = 47.42, ["Neon"] = 6.45, ["Neon|Fly"] = 37.97, ["Neon|Ride"] = 30.38, ["Neon|Fly|Ride"] = 75.24, ["Mega"] = 73.31, ["Mega|Fly"] = 207.66, ["Mega|Ride"] = 64.13, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 48.75, ["Neon"] = 2.5, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 313.84, ["Mega"] = 18.38, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 3.29, ["Ride"] = 52.5, ["Fly|Ride"] = 525, ["Neon"] = 22.23, ["Mega"] = 203.42, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 282.87}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.63, ["Neon"] = 13.13, ["Mega"] = 139.13, ["Mega|Fly|Ride"] = 405.72}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 71, ["Neon"] = 3.84, ["Neon|Ride"] = 37.71, ["Neon|Fly|Ride"] = 76.3, ["Mega"] = 23.33, ["Mega|Fly"] = 79.48, ["Mega|Ride"] = 70.88, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 12.5, ["Ride"] = 18.8, ["Fly|Ride"] = 30.19, ["Neon"] = 2.1, ["Neon|Fly"] = 25.47, ["Neon|Ride"] = 15.33, ["Neon|Fly|Ride"] = 41.88, ["Mega"] = 14.6, ["Mega|Fly"] = 53.95, ["Mega|Ride"] = 22.32, ["Mega|Fly|Ride"] = 57.75}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 42, ["Neon"] = 31.75, ["Neon|Ride"] = 39.38, ["Mega"] = 254.27, ["Mega|Fly"] = 282.87, ["Mega|Ride"] = 353.75, ["Mega|Fly|Ride"] = 690.76}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 41.91, ["Fly|Ride"] = 78.74, ["Neon"] = 3.94, ["Neon|Ride"] = 25.3, ["Neon|Fly|Ride"] = 158.06, ["Mega"] = 28.35, ["Mega|Ride"] = 42, ["Mega|Fly|Ride"] = 198.13}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 6.57, ["Neon"] = 13.13, ["Neon|Fly|Ride"] = 141.98, ["Mega"] = 74.82, ["Mega|Ride"] = 165.29, ["Mega|Fly|Ride"] = 221.81}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 3.94, ["Fly"] = 21.21, ["Ride"] = 32.81, ["Fly|Ride"] = 192.83, ["Neon"] = 116.78, ["Neon|Ride"] = 71, ["Neon|Fly|Ride"] = 127.15, ["Mega"] = 70.98, ["Mega|Ride"] = 85.3, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 10.5, ["Ride"] = 13.13, ["Fly|Ride"] = 35.81, ["Neon"] = 2.1, ["Neon|Fly"] = 15.74, ["Neon|Ride"] = 14.97, ["Neon|Fly|Ride"] = 25.44, ["Mega"] = 15.43, ["Mega|Fly"] = 40.27, ["Mega|Ride"] = 23.61, ["Mega|Fly|Ride"] = 52.36}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.63, ["Fly"] = 23.94, ["Ride"] = 19.65, ["Fly|Ride"] = 48.57, ["Neon"] = 22.36, ["Neon|Ride"] = 113.24, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 78.75, ["Mega|Fly|Ride"] = 196.77}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 4.15, ["Fly"] = 41.91, ["Ride"] = 30.68, ["Fly|Ride"] = 141.39, ["Neon"] = 74.75, ["Neon|Ride"] = 99.61, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 310.7, ["Mega|Ride"] = 276.94, ["Mega|Fly|Ride"] = 387.85}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 13.02, ["Ride"] = 15.81, ["Fly|Ride"] = 26.25, ["Neon"] = 6.38, ["Neon|Fly"] = 20.24, ["Neon|Ride"] = 16.96, ["Neon|Fly|Ride"] = 60.4, ["Mega"] = 36.04, ["Mega|Fly"] = 156.19, ["Mega|Ride"] = 49.8, ["Mega|Fly|Ride"] = 111.45}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.63, ["Fly"] = 176.93, ["Ride"] = 31.5, ["Neon"] = 9.03, ["Neon|Fly"] = 77.53, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 53.95, ["Mega|Fly"] = 565.74, ["Mega|Ride"] = 118.13}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.63, ["Ride"] = 26.25, ["Neon"] = 9.19, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 28.62, ["Neon|Fly|Ride"] = 141.42, ["Mega"] = 35.44, ["Mega|Ride"] = 148.62, ["Mega|Fly|Ride"] = 205.24}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 42.39, ["Neon|Ride"] = 21.2, ["Neon|Fly|Ride"] = 101.07, ["Mega"] = 14.34, ["Mega|Ride"] = 52.08, ["Mega|Fly|Ride"] = 135.85}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 17.71, ["Ride"] = 21.25, ["Fly|Ride"] = 59.07, ["Neon"] = 11.7, ["Neon|Fly"] = 46.64, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 101.72, ["Mega"] = 221.74, ["Mega|Ride"] = 71, ["Mega|Fly|Ride"] = 270.16}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 31.39, ["Neon"] = 11.67, ["Neon|Ride"] = 52.5, ["Mega"] = 94.24, ["Mega|Ride"] = 141.98, ["Mega|Fly|Ride"] = 235.9}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 26.17, ["Ride"] = 17.07, ["Fly|Ride"] = 125.9, ["Neon"] = 9.32, ["Neon|Fly"] = 107.35, ["Neon|Ride"] = 19.59, ["Neon|Fly|Ride"] = 48.47, ["Mega"] = 62.98, ["Mega|Fly"] = 127.15, ["Mega|Ride"] = 90.46, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 3.91, ["Fly"] = 26.25, ["Ride"] = 82.6, ["Neon"] = 87.84, ["Mega"] = 282.87, ["Mega|Fly|Ride"] = 844.06}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 21.27, ["Fly|Ride"] = 5425.33, ["Neon"] = 15.27, ["Neon|Fly"] = 59.35, ["Neon|Ride"] = 21.21, ["Neon|Fly|Ride"] = 113.3, ["Mega"] = 150.94, ["Mega|Fly|Ride"] = 283.07}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 5.16, ["Fly"] = 17.99, ["Ride"] = 28.5, ["Fly|Ride"] = 141.98, ["Neon"] = 18.06, ["Neon|Fly"] = 42.37, ["Neon|Ride"] = 42.39, ["Neon|Fly|Ride"] = 84.62, ["Mega"] = 157.5, ["Mega|Ride"] = 124.38, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 3.82, ["Fly"] = 79.47, ["Fly|Ride"] = 106.14, ["Neon"] = 23, ["Neon|Ride"] = 157.95, ["Mega"] = 202.06, ["Mega|Ride"] = 367.63, ["Mega|Fly|Ride"] = 207.66}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 157.4, ["Mega"] = 577.5, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 11.67, ["Ride"] = 35.32, ["Neon"] = 87.26, ["Neon|Ride"] = 105, ["Mega"] = 212.62, ["Mega|Ride"] = 367.5}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 11.82, ["Ride"] = 39.8, ["Fly|Ride"] = 55.44, ["Neon"] = 49.88, ["Neon|Ride"] = 117.6, ["Neon|Fly|Ride"] = 184.36, ["Mega"] = 194.95, ["Mega|Ride"] = 253.19, ["Mega|Fly|Ride"] = 394.42}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.1, ["Neon|Ride"] = 92.3, ["Mega"] = 16.96, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 148.29}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 49.87}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 5.16, ["Fly"] = 20.94, ["Ride"] = 21.11, ["Fly|Ride"] = 65.63, ["Neon"] = 39.38, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 80.07, ["Mega"] = 249.38, ["Mega|Ride"] = 353.07, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.36, ["Fly|Ride"] = 71, ["Neon"] = 4.17, ["Neon|Ride"] = 22.09, ["Mega"] = 48.75, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.56, ["Ride"] = 27.46, ["Fly|Ride"] = 140.17, ["Neon"] = 6.46, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 158.06, ["Mega"] = 37.97, ["Mega|Ride"] = 78.66, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.63, ["Fly"] = 45.94, ["Ride"] = 19.69, ["Fly|Ride"] = 78.41, ["Neon"] = 16.33, ["Neon|Ride"] = 25.41, ["Neon|Fly|Ride"] = 90, ["Mega"] = 133.76, ["Mega|Ride"] = 163.16, ["Mega|Fly|Ride"] = 282.87}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.62, ["Fly|Ride"] = 52.5, ["Neon"] = 36.66, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 154.16, ["Mega"] = 328.12, ["Mega|Ride"] = 282.87}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 51.91, ["Mega"] = 18.38, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 58.97, ["Mega|Fly|Ride"] = 113.35}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 19.69, ["Fly|Ride"] = 57.22, ["Neon"] = 5.25, ["Neon|Fly"] = 30.19, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 99.61, ["Mega"] = 26.25, ["Mega|Fly"] = 181.17, ["Mega|Ride"] = 57.2, ["Mega|Fly|Ride"] = 141.75}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.62, ["Ride"] = 20.14, ["Fly|Ride"] = 39.38, ["Neon"] = 7.65, ["Neon|Fly"] = 71, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 51.19, ["Mega"] = 65.63, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 158.82}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 26.24, ["Fly|Ride"] = 45.94, ["Neon"] = 3.82, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 83.69, ["Mega"] = 26.67, ["Mega|Fly"] = 99.61, ["Mega|Ride"] = 38.07, ["Mega|Fly|Ride"] = 108.19}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 6.18, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 173.76, ["Mega"] = 19.69, ["Mega|Fly"] = 146.25, ["Mega|Ride"] = 89, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 26.17, ["Ride"] = 27.93, ["Fly|Ride"] = 77.37, ["Neon"] = 5.25, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 24.28, ["Mega|Ride"] = 57.22, ["Mega|Fly|Ride"] = 126.95}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Mega"] = 32.82, ["Mega|Ride"] = 235.9}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.63, ["Neon"] = 3.68, ["Neon|Ride"] = 158.06, ["Neon|Fly|Ride"] = 282.87, ["Mega"] = 21.73, ["Mega|Fly"] = 117.96, ["Mega|Ride"] = 113.37}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 19.69, ["Fly|Ride"] = 28.62, ["Neon"] = 6.57, ["Neon|Fly"] = 71.8, ["Neon|Ride"] = 21.2, ["Neon|Fly|Ride"] = 99.61, ["Mega"] = 61.69, ["Mega|Fly"] = 84.76, ["Mega|Ride"] = 60.3, ["Mega|Fly|Ride"] = 131.19}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 13.12, ["Ride"] = 65.63, ["Fly|Ride"] = 117.6, ["Neon"] = 95.82, ["Neon|Ride"] = 235.9, ["Mega"] = 407.08, ["Mega|Ride"] = 471.78, ["Mega|Fly|Ride"] = 847.54}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 5.25, ["Fly"] = 6562.49, ["Ride"] = 68.16, ["Fly|Ride"] = 131.15, ["Neon"] = 144.38, ["Mega"] = 210.83, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 423.78}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 7.87, ["Ride"] = 28.3, ["Fly|Ride"] = 423.78, ["Neon"] = 30.74, ["Neon|Ride"] = 84.73, ["Mega"] = 224.62, ["Mega|Fly|Ride"] = 338.63}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 15.61, ["Ride"] = 12.71, ["Fly|Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 17.22, ["Neon|Ride"] = 14.25, ["Neon|Fly|Ride"] = 30.19, ["Mega"] = 21, ["Mega|Fly"] = 22.79, ["Mega|Ride"] = 23.63, ["Mega|Fly|Ride"] = 86.63}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.63, ["Ride"] = 55.13, ["Neon"] = 9.19, ["Neon|Fly"] = 84.76, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 105, ["Mega"] = 70.76, ["Mega|Ride"] = 141.98}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Neon"] = 2.1, ["Neon|Fly"] = 21.15, ["Neon|Ride"] = 15.91, ["Neon|Fly|Ride"] = 70.48, ["Mega"] = 15.75, ["Mega|Fly"] = 78.41, ["Mega|Ride"] = 101.07, ["Mega|Fly|Ride"] = 103.58}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Fly"] = 60.9, ["Mega"] = 19.05, ["Mega|Ride"] = 99.61, ["Mega|Fly|Ride"] = 210.83}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 19.69, ["Fly|Ride"] = 63.48, ["Neon"] = 31.86, ["Neon|Fly"] = 50.72, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 99.6, ["Mega"] = 143.21, ["Mega|Ride"] = 201.28, ["Mega|Fly|Ride"] = 243.16}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 183.75, ["Ride"] = 196.88, ["Fly|Ride"] = 317.84, ["Neon"] = 1541.07, ["Neon|Ride"] = 937.79, ["Mega"] = 8475.33, ["Mega|Fly|Ride"] = 3543.75}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.52, ["Fly|Ride"] = 52.5, ["Neon"] = 6.57, ["Neon|Fly"] = 57.11, ["Neon|Ride"] = 68.25, ["Mega"] = 65.42, ["Mega|Ride"] = 177.99, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.93, ["Fly"] = 103.68, ["Ride"] = 24.34, ["Fly|Ride"] = 141.98, ["Neon"] = 23.63, ["Neon|Ride"] = 169.52, ["Neon|Fly|Ride"] = 148.34, ["Mega"] = 464.4, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 629.83}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 15.91, ["Fly|Ride"] = 34.81, ["Neon"] = 5.91, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 65.63, ["Mega|Fly"] = 94.37, ["Mega|Ride"] = 59.7, ["Mega|Fly|Ride"] = 105.96}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 22.32, ["Ride"] = 24.38, ["Fly|Ride"] = 52.5, ["Neon"] = 11.74, ["Neon|Fly"] = 84.76, ["Neon|Ride"] = 82.65, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 117.6, ["Mega|Ride"] = 123.38, ["Mega|Fly|Ride"] = 210.83}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 6.57, ["Fly"] = 18.38, ["Ride"] = 19.69, ["Fly|Ride"] = 34.13, ["Neon"] = 28.49, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 160.12, ["Mega|Ride"] = 281.81, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 4.34, ["Fly"] = 28.62, ["Ride"] = 42.39, ["Fly|Ride"] = 246.75, ["Neon"] = 57.22, ["Neon|Ride"] = 137.45, ["Neon|Fly|Ride"] = 84.76, ["Mega"] = 328.13, ["Mega|Fly|Ride"] = 398.35}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 19.05, ["Ride"] = 14.44, ["Fly|Ride"] = 34.13, ["Neon"] = 26.21, ["Neon|Fly"] = 83.58, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 68.16, ["Mega"] = 196.88, ["Mega|Fly"] = 384.57, ["Mega|Ride"] = 281.51, ["Mega|Fly|Ride"] = 190.6}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 72.19, ["Fly"] = 141.75, ["Ride"] = 92.45, ["Fly|Ride"] = 151.83, ["Neon"] = 325.26, ["Neon|Fly"] = 404.92, ["Neon|Ride"] = 378, ["Neon|Fly|Ride"] = 457.36, ["Mega"] = 1101.59, ["Mega|Fly|Ride"] = 1443.24}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 196.87, ["Fly"] = 322.17, ["Ride"] = 227.75, ["Fly|Ride"] = 251.61, ["Neon"] = 901.09, ["Neon|Ride"] = 2648.56, ["Neon|Fly|Ride"] = 1096.11, ["Mega"] = 10594.16, ["Mega|Fly|Ride"] = 4096.77}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 68.25, ["Fly"] = 148.39, ["Ride"] = 86.37, ["Fly|Ride"] = 112.06, ["Neon"] = 379.25, ["Neon|Ride"] = 314.98, ["Neon|Fly|Ride"] = 351.93, ["Mega|Fly|Ride"] = 1204.13}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 4.82, ["Ride"] = 36.58, ["Fly|Ride"] = 57.22, ["Neon"] = 17.07, ["Neon|Ride"] = 84.74, ["Neon|Fly|Ride"] = 168.47, ["Mega"] = 592.23, ["Mega|Ride"] = 235.9, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 10.4, ["Fly"] = 68.14, ["Ride"] = 34.21, ["Fly|Ride"] = 78.75, ["Neon"] = 64.97, ["Neon|Fly"] = 105, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 211.91, ["Mega"] = 261.19, ["Mega|Ride"] = 358.1, ["Mega|Fly|Ride"] = 403.28}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 19.08, ["Ride"] = 20.83, ["Fly|Ride"] = 55.32, ["Neon"] = 6.57, ["Neon|Fly"] = 115.5, ["Neon|Ride"] = 21.21, ["Neon|Fly|Ride"] = 78.41, ["Mega"] = 66.76, ["Mega|Fly"] = 209.96, ["Mega|Ride"] = 100.66, ["Mega|Fly|Ride"] = 193.58}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.55, ["Fly"] = 68.49, ["Ride"] = 28.62, ["Fly|Ride"] = 131.25, ["Neon"] = 35.7, ["Neon|Ride"] = 141.98, ["Neon|Fly|Ride"] = 82.65, ["Mega"] = 791.39, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 565.74}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.63, ["Fly"] = 18.17, ["Ride"] = 18.38, ["Fly|Ride"] = 47.19, ["Neon"] = 18.38, ["Neon|Fly"] = 131.14, ["Neon|Ride"] = 28.62, ["Neon|Fly|Ride"] = 99.49, ["Mega"] = 131.25, ["Mega|Ride"] = 141.98, ["Mega|Fly|Ride"] = 175.88}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 3.66, ["Ride"] = 27.15, ["Fly|Ride"] = 328.13, ["Neon"] = 23.63, ["Neon|Ride"] = 71, ["Neon|Fly|Ride"] = 235.9, ["Mega"] = 282.87, ["Mega|Ride"] = 141.52, ["Mega|Fly|Ride"] = 240.51}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 28.62, ["Neon"] = 2.1, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 15.75, ["Mega|Ride"] = 50.87, ["Mega|Fly|Ride"] = 198.13}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.63, ["Fly"] = 45.93, ["Ride"] = 20.88, ["Fly|Ride"] = 39.38, ["Neon"] = 13.13, ["Neon|Fly"] = 105.96, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 108.88, ["Mega|Ride"] = 96.49, ["Mega|Fly|Ride"] = 193.44}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 3.75, ["Ride"] = 18.02, ["Fly|Ride"] = 39.29, ["Neon"] = 27.15, ["Neon|Fly"] = 141.98, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 63, ["Mega"] = 269.1, ["Mega|Ride"] = 205.24, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 124.69, ["Fly"] = 232.03, ["Ride"] = 185.07, ["Fly|Ride"] = 245.54, ["Neon"] = 594.51, ["Neon|Ride"] = 551.3, ["Neon|Fly|Ride"] = 595.87, ["Mega|Ride"] = 3478.13, ["Mega|Fly|Ride"] = 2058.84}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 5.2, ["Ride"] = 30.19, ["Fly|Ride"] = 206.07, ["Neon"] = 51.19, ["Neon|Ride"] = 81.29, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 307.47, ["Mega|Ride"] = 347.94, ["Mega|Fly|Ride"] = 550.91}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 31.86, ["Ride"] = 27.57, ["Fly|Ride"] = 71, ["Neon"] = 25.44, ["Neon|Ride"] = 42.39, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 141.75, ["Mega|Ride"] = 269.1, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 19.66, ["Fly"] = 59.07, ["Ride"] = 85.32, ["Fly|Ride"] = 178.5, ["Neon"] = 106.2, ["Neon|Ride"] = 146.22, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 440.73, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 537.14}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 3.93}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 6.23, ["Ride"] = 23.63, ["Neon"] = 68.25, ["Neon|Ride"] = 163.16, ["Neon|Fly|Ride"] = 635.66, ["Mega"] = 423.78, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 550.91}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 24.94, ["Fly"] = 26.25, ["Ride"] = 28.48, ["Fly|Ride"] = 49.55, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 175.83, ["Neon|Fly|Ride"] = 156.19, ["Mega"] = 2118.84, ["Mega|Ride"] = 574.4, ["Mega|Fly|Ride"] = 546.29}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Fly"] = 31.8, ["Ride"] = 24.94, ["Fly|Ride"] = 78.75, ["Neon"] = 6.3, ["Neon|Ride"] = 28.62, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 36.04, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 163.75}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 5.65, ["Fly"] = 26.25, ["Ride"] = 20.9, ["Fly|Ride"] = 78.41, ["Neon"] = 49.81, ["Neon|Ride"] = 99.61, ["Mega"] = 265.13, ["Mega|Fly"] = 393.94, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 15.9, ["Fly|Ride"] = 56.63, ["Neon"] = 14.44, ["Neon|Ride"] = 27.22, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 131.25, ["Mega|Ride"] = 124.06, ["Mega|Fly|Ride"] = 247.92}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Neon"] = 6.17, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 27.57, ["Mega"] = 33.92, ["Mega|Ride"] = 71, ["Mega|Fly|Ride"] = 205.06}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 36.75, ["Ride"] = 76.13, ["Fly|Ride"] = 525, ["Neon"] = 157.49, ["Neon|Ride"] = 313.74, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 823.92, ["Mega|Ride"] = 792.31, ["Mega|Fly|Ride"] = 857.79}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.67, ["Ride"] = 70.88, ["Fly|Ride"] = 65.63, ["Neon"] = 48.72, ["Neon|Ride"] = 78.41, ["Neon|Fly|Ride"] = 211.91, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 9.19, ["Fly"] = 131.06, ["Ride"] = 48.75, ["Fly|Ride"] = 117.48, ["Neon"] = 75.9, ["Neon|Fly"] = 211.91, ["Neon|Ride"] = 84.68, ["Neon|Fly|Ride"] = 193.89, ["Mega"] = 374.07, ["Mega|Ride"] = 529.66, ["Mega|Fly|Ride"] = 471.85}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 52.5, ["Fly"] = 137.73, ["Ride"] = 52.5, ["Fly|Ride"] = 262.5, ["Neon"] = 208.69, ["Neon|Ride"] = 393.75, ["Mega|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 2266.1}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 35.4, ["Fly"] = 131.25, ["Ride"] = 131.25, ["Fly|Ride"] = 198.13, ["Neon"] = 117.95, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 524.43, ["Mega|Ride"] = 462.66, ["Mega|Fly|Ride"] = 562.56}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 74.76, ["Fly"] = 145.69, ["Ride"] = 98.44, ["Fly|Ride"] = 186.47, ["Neon"] = 202.92, ["Neon|Ride"] = 228.38, ["Neon|Fly|Ride"] = 314.92, ["Mega"] = 938.44, ["Mega|Ride"] = 823.2, ["Mega|Fly|Ride"] = 856.23}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 47.25, ["Ride"] = 141.98, ["Fly|Ride"] = 162.75, ["Neon"] = 94.5, ["Neon|Ride"] = 116.72, ["Neon|Fly|Ride"] = 190.71, ["Mega"] = 465.89, ["Mega|Ride"] = 296.05, ["Mega|Fly|Ride"] = 427.67}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 13.13, ["Fly"] = 69.5, ["Ride"] = 23.33, ["Neon"] = 81.54, ["Neon|Ride"] = 194.24, ["Neon|Fly|Ride"] = 99.61, ["Mega"] = 334.97, ["Mega|Ride"] = 1059.43, ["Mega|Fly|Ride"] = 286.06}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 103.69, ["Ride"] = 73.5, ["Neon"] = 77.44, ["Neon|Ride"] = 282.87, ["Neon|Fly|Ride"] = 423.78, ["Mega"] = 415.3, ["Mega|Ride"] = 412.13, ["Mega|Fly|Ride"] = 574.4}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 7.87, ["Ride"] = 27.57, ["Fly|Ride"] = 139.86, ["Neon"] = 44.63, ["Neon|Ride"] = 109.73, ["Mega"] = 312.55, ["Mega|Ride"] = 295.59, ["Mega|Fly|Ride"] = 374.81}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 52.99, ["Neon|Ride"] = 56.35, ["Neon|Fly|Ride"] = 92.19, ["Mega"] = 18.98, ["Mega|Fly"] = 141.98, ["Mega|Ride"] = 70.81, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 2.61, ["Ride"] = 209.9, ["Neon"] = 12.15, ["Neon|Ride"] = 83.83, ["Mega"] = 121.47, ["Mega|Ride"] = 209.77, ["Mega|Fly|Ride"] = 448.2}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.63, ["Ride"] = 57.22, ["Neon"] = 22.32, ["Neon|Ride"] = 105.96, ["Mega"] = 181.79, ["Mega|Ride"] = 141.98}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 4.12, ["Ride"] = 31.44, ["Fly|Ride"] = 116.78, ["Neon"] = 28.88, ["Neon|Ride"] = 82.95, ["Neon|Fly|Ride"] = 281.81, ["Mega"] = 123.38, ["Mega|Ride"] = 152.97, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 492.09, ["Ride"] = 520.89, ["Fly|Ride"] = 612.03, ["Neon|Ride"] = 1767.11, ["Neon|Fly|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 5099.98}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 7.88, ["Fly"] = 57.22, ["Ride"] = 25.18, ["Fly|Ride"] = 57.26, ["Neon"] = 41.33, ["Neon|Ride"] = 77.84, ["Neon|Fly|Ride"] = 126.21, ["Mega"] = 240.51, ["Mega|Ride"] = 275.46, ["Mega|Fly|Ride"] = 367.63}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 13.13, ["Fly"] = 39.38, ["Ride"] = 28.62, ["Fly|Ride"] = 84.76, ["Neon"] = 78.41, ["Neon|Fly"] = 315, ["Neon|Ride"] = 59.07, ["Mega"] = 269.1, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 394.11}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 3.94, ["Fly"] = 28.62, ["Ride"] = 21.67, ["Fly|Ride"] = 141.98, ["Neon"] = 37.09, ["Neon|Ride"] = 196.76, ["Mega"] = 223.13, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.63, ["Fly"] = 65.63, ["Ride"] = 31.77, ["Fly|Ride"] = 941.48, ["Neon"] = 10.5, ["Neon|Fly"] = 71, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 121.85, ["Mega"] = 71, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 190.74}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 71, ["Ride"] = 70.88, ["Neon"] = 3.83, ["Neon|Ride"] = 75.24, ["Neon|Fly|Ride"] = 158.06, ["Mega"] = 26.25, ["Mega|Ride"] = 141.98, ["Mega|Fly|Ride"] = 209.35}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1270.25}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 15.74, ["Fly"] = 57.22, ["Ride"] = 51.61, ["Neon"] = 59.07, ["Neon|Fly"] = 141.98, ["Neon|Ride"] = 74.18, ["Mega"] = 650.5, ["Mega|Ride"] = 608.5, ["Mega|Fly|Ride"] = 673.45}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.63, ["Ride"] = 38.07, ["Neon"] = 8.33, ["Neon|Ride"] = 42.39, ["Mega"] = 102.62, ["Mega|Ride"] = 137.71, ["Mega|Fly|Ride"] = 235.9}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.63, ["Fly"] = 42.39, ["Ride"] = 42, ["Fly|Ride"] = 525, ["Neon"] = 10.58, ["Neon|Ride"] = 63.58, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 183.74, ["Mega|Ride"] = 152.25, ["Mega|Fly|Ride"] = 388.82}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 397.08, ["Ride"] = 430.5, ["Fly|Ride"] = 459.38, ["Neon"] = 1376.2, ["Neon|Ride"] = 1299.38, ["Neon|Fly|Ride"] = 1887.08, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 7.85, ["Fly"] = 196.88, ["Ride"] = 72.19, ["Neon"] = 63.58, ["Neon|Ride"] = 131.25, ["Mega"] = 422.72, ["Mega|Ride"] = 448.2}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Neon"] = 6.57, ["Neon|Ride"] = 44.5, ["Neon|Fly|Ride"] = 101.54, ["Mega"] = 36.04, ["Mega|Fly"] = 189, ["Mega|Ride"] = 80.53, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.89, ["Neon|Ride"] = 98.28, ["Neon|Fly|Ride"] = 269.1, ["Mega"] = 20.98, ["Mega|Ride"] = 80.53, ["Mega|Fly|Ride"] = 190.71}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 13.02, ["Fly"] = 42.39, ["Ride"] = 22.32, ["Fly|Ride"] = 148.26, ["Neon"] = 82.69, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 141.98, ["Mega"] = 328.13, ["Mega|Ride"] = 423.78, ["Mega|Fly|Ride"] = 372.75}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 17.67, ["Ride"] = 110.19, ["Neon"] = 104.87, ["Neon|Ride"] = 141.98, ["Neon|Fly|Ride"] = 126.21, ["Mega"] = 629.83, ["Mega|Ride"] = 561.29, ["Mega|Fly|Ride"] = 1082.18}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 3.52, ["Ride"] = 26.25, ["Fly|Ride"] = 99.61, ["Neon"] = 141.94, ["Neon|Ride"] = 200.82, ["Mega"] = 582.75, ["Mega|Ride"] = 328.02, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 13.13, ["Ride"] = 43.32, ["Fly|Ride"] = 141.54, ["Neon"] = 127.13, ["Neon|Ride"] = 156.13, ["Neon|Fly|Ride"] = 786.69, ["Mega"] = 524.43, ["Mega|Ride"] = 537.14, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 360.59, ["Ride"] = 357, ["Fly|Ride"] = 524.43, ["Neon"] = 1786.83, ["Neon|Ride"] = 1269.19, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 3643.34, ["Mega|Fly|Ride"] = 3197.3}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 4.66, ["Fly"] = 25.44, ["Ride"] = 30.68, ["Fly|Ride"] = 83.75, ["Neon"] = 38.07, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 137.64, ["Mega"] = 393.75, ["Mega|Ride"] = 528.67, ["Mega|Fly|Ride"] = 542.43}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 13.12, ["Ride"] = 94.37, ["Fly|Ride"] = 282.87, ["Neon"] = 42.39, ["Neon|Fly|Ride"] = 184.36, ["Mega"] = 1271.31, ["Mega|Fly|Ride"] = 1695.07}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 18.34, ["Ride"] = 46.64, ["Fly|Ride"] = 163.16, ["Neon"] = 40.69, ["Neon|Ride"] = 105.34, ["Neon|Fly|Ride"] = 314.92, ["Mega"] = 191.57, ["Mega|Ride"] = 201.91, ["Mega|Fly|Ride"] = 320.25}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.49, ["Ride"] = 60.4, ["Fly|Ride"] = 110.88, ["Neon"] = 14.43, ["Neon|Ride"] = 45.56, ["Mega"] = 40.65, ["Mega|Fly"] = 110.88, ["Mega|Ride"] = 134.56, ["Mega|Fly|Ride"] = 235.9}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 32.8, ["Fly"] = 63.71, ["Ride"] = 76.3, ["Neon"] = 270.44, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 315.72, ["Mega"] = 2542.61, ["Mega|Ride"] = 1127.23, ["Mega|Fly|Ride"] = 1088.37}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.9, ["Fly"] = 589.73, ["Ride"] = 30.68, ["Fly|Ride"] = 63.95, ["Neon"] = 11.67, ["Neon|Fly"] = 156.96, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 113.37, ["Mega"] = 70.71, ["Mega|Ride"] = 100.61, ["Mega|Fly|Ride"] = 197.06}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 28.62, ["Ride"] = 28.62, ["Fly|Ride"] = 148.25, ["Neon"] = 6.38, ["Neon|Fly"] = 71, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 140.11, ["Mega"] = 32.81, ["Mega|Ride"] = 70.98, ["Mega|Fly|Ride"] = 166.37}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 3.7, ["Ride"] = 57.75, ["Fly|Ride"] = 262.5, ["Neon"] = 21, ["Neon|Ride"] = 158.06, ["Mega"] = 116.82, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 550.91}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 70.86, ["Ride"] = 82.69, ["Fly|Ride"] = 110.88, ["Neon"] = 339.03, ["Neon|Ride"] = 582.75, ["Neon|Fly|Ride"] = 627.38, ["Mega|Fly|Ride"] = 1355.82}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 255.94, ["Ride"] = 309.75, ["Fly|Ride"] = 341.25, ["Neon"] = 989.5, ["Neon|Ride"] = 1099.87, ["Neon|Fly|Ride"] = 1260, ["Mega"] = 7063.13, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 4.24, ["Ride"] = 35.44, ["Neon"] = 36.75, ["Mega"] = 93.9, ["Mega|Ride"] = 166.69, ["Mega|Fly|Ride"] = 377.43}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 6.35, ["Fly|Ride"] = 210.83, ["Neon"] = 25.96, ["Mega"] = 92.04, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.82, ["Fly"] = 155.56, ["Ride"] = 27.57, ["Neon"] = 39.38, ["Mega"] = 508.6, ["Mega|Ride"] = 337.84}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 53.23, ["Ride"] = 28.48, ["Fly|Ride"] = 49.87, ["Neon"] = 6.3, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 90.2, ["Mega"] = 32.81, ["Mega|Ride"] = 73.5, ["Mega|Fly|Ride"] = 206.07}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 58.97, ["Fly|Ride"] = 282.87, ["Neon"] = 9.19, ["Mega"] = 46.64, ["Mega|Fly"] = 141.98, ["Mega|Ride"] = 206.6}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 18.38, ["Fly|Ride"] = 41.94, ["Neon"] = 6.38, ["Neon|Fly"] = 47.19, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 39.38, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 141.54}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 24.94, ["Fly|Ride"] = 56.44, ["Neon"] = 16.86, ["Neon|Fly"] = 47.19, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 69.93, ["Mega"] = 170.63, ["Mega|Ride"] = 201.3, ["Mega|Fly|Ride"] = 435.75}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 40.69, ["Fly"] = 65.63, ["Ride"] = 40.69, ["Fly|Ride"] = 83.65, ["Neon"] = 179.82, ["Neon|Ride"] = 211.91, ["Mega"] = 380.63, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 418.48, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 65.62, ["Ride"] = 101.07, ["Fly|Ride"] = 131.25, ["Neon"] = 366.19, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 471.19, ["Mega|Ride"] = 3241.88, ["Mega|Fly|Ride"] = 1429.96}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 23.23, ["Fly|Ride"] = 131.25, ["Neon"] = 6.3, ["Neon|Fly|Ride"] = 141.98, ["Mega"] = 56.35, ["Mega|Ride"] = 91.35}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 16.77, ["Ride"] = 18.95, ["Fly|Ride"] = 30.15, ["Neon"] = 4.19, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 24.92, ["Neon|Fly|Ride"] = 63.06, ["Mega"] = 32.73, ["Mega|Fly"] = 131.21, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 11.81, ["Ride"] = 54.28, ["Neon"] = 122.91, ["Neon|Ride"] = 423.78, ["Neon|Fly|Ride"] = 156.8, ["Mega"] = 627.38, ["Mega|Ride"] = 312.55, ["Mega|Fly|Ride"] = 472.38}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 252.16, ["Fly"] = 261.19, ["Ride"] = 422.63, ["Fly|Ride"] = 301.88, ["Neon|Ride"] = 1271.31, ["Neon|Fly|Ride"] = 1588.08, ["Mega|Fly|Ride"] = 5297.09}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 28.88, ["Fly"] = 141.98, ["Ride"] = 67.82, ["Fly|Ride"] = 112.88, ["Neon"] = 269.1, ["Neon|Ride"] = 260.66, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 1083.7, ["Mega|Ride"] = 963.69, ["Mega|Fly|Ride"] = 897.85}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Fly|Ride"] = 78.28, ["Neon"] = 9.85, ["Neon|Ride"] = 31.86, ["Neon|Fly|Ride"] = 141.98, ["Mega"] = 84, ["Mega|Ride"] = 115.78, ["Mega|Fly|Ride"] = 222.49}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 211.91, ["Ride"] = 28.88, ["Fly|Ride"] = 142.7, ["Neon"] = 30.64, ["Neon|Ride"] = 202.36, ["Mega"] = 211.13}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 28.55, ["Fly"] = 78.41, ["Ride"] = 30.19, ["Fly|Ride"] = 80.07, ["Neon|Ride"] = 198.13, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 2542.61, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1101.59}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 105, ["Ride"] = 141.18, ["Fly|Ride"] = 141.72, ["Neon"] = 426.57, ["Neon|Ride"] = 469.88, ["Neon|Fly|Ride"] = 410.01, ["Mega"] = 3108.34, ["Mega|Fly|Ride"] = 1695.07}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 211.31, ["Ride"] = 246.75, ["Fly|Ride"] = 337.55, ["Neon"] = 1059.43, ["Neon|Ride"] = 1121.93, ["Neon|Fly|Ride"] = 1159.02, ["Mega|Fly|Ride"] = 2964.25}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 11.82, ["Ride"] = 70.79, ["Fly|Ride"] = 217.03, ["Neon"] = 95.82, ["Neon|Ride"] = 143.93, ["Mega"] = 367.64, ["Mega|Ride"] = 358.58}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.62, ["Ride"] = 16.96, ["Fly|Ride"] = 42.39, ["Neon"] = 7.35, ["Neon|Ride"] = 23.3, ["Neon|Fly|Ride"] = 70.79, ["Mega"] = 90.57, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 234.14}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 6.56, ["Ride"] = 23.63, ["Fly|Ride"] = 52.5, ["Neon"] = 37.7, ["Neon|Fly"] = 148.34, ["Neon|Ride"] = 42.39, ["Neon|Fly|Ride"] = 71, ["Mega"] = 216.57, ["Mega|Ride"] = 216.55, ["Mega|Fly|Ride"] = 282.98}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 285.85, ["Fly"] = 494.75, ["Ride"] = 278.24, ["Fly|Ride"] = 406.88, ["Neon"] = 1356.07, ["Neon|Ride"] = 1377.26, ["Neon|Fly|Ride"] = 1837.04, ["Mega|Fly|Ride"] = 6710.36}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 46.64, ["Neon"] = 7.88, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 36.74, ["Mega|Ride"] = 146.22, ["Mega|Fly|Ride"] = 314.92}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 6.39, ["Ride"] = 21.2, ["Fly|Ride"] = 47.18, ["Neon"] = 22.31, ["Neon|Ride"] = 36.04, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 170.22, ["Mega|Ride"] = 314.92, ["Mega|Fly|Ride"] = 262.75}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 32.85, ["Ride"] = 141, ["Neon"] = 104.87, ["Neon|Fly"] = 282.87, ["Neon|Fly|Ride"] = 565.74, ["Mega"] = 466.48, ["Mega|Ride"] = 467.77, ["Mega|Fly|Ride"] = 631.96}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 149.63, ["Fly"] = 172.71, ["Ride"] = 129.94, ["Fly|Ride"] = 141.75, ["Neon"] = 422.72, ["Neon|Ride"] = 537.14, ["Neon|Fly|Ride"] = 374.07, ["Mega|Fly|Ride"] = 2481.17}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 21, ["Fly"] = 45.05, ["Ride"] = 27.57, ["Fly|Ride"] = 53.82, ["Neon"] = 100.66, ["Neon|Ride"] = 82.37, ["Neon|Fly|Ride"] = 138.35, ["Mega"] = 706.65, ["Mega|Ride"] = 466.15, ["Mega|Fly|Ride"] = 414.75}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Neon"] = 2.37, ["Neon|Ride"] = 28.62, ["Neon|Fly|Ride"] = 706.65, ["Mega"] = 20.1, ["Mega|Ride"] = 105.96, ["Mega|Fly|Ride"] = 253.21}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 24.38, ["Fly|Ride"] = 52.5, ["Neon"] = 3.9, ["Neon|Fly"] = 158.06, ["Neon|Ride"] = 27.44, ["Neon|Fly|Ride"] = 54.28, ["Mega"] = 20.97, ["Mega|Fly"] = 140.37, ["Mega|Ride"] = 40.11, ["Mega|Fly|Ride"] = 103.36}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 9.19, ["Fly"] = 91.88, ["Ride"] = 52.49, ["Fly|Ride"] = 62.52, ["Neon"] = 28.53, ["Neon|Fly"] = 99.61, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 153.57, ["Mega"] = 132.97, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 314.56}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1183.88, ["Ride"] = 1312.5, ["Fly|Ride"] = 1309.88, ["Neon|Ride"] = 7063.13, ["Neon|Fly|Ride"] = 3896.06, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 706.65, ["Ride"] = 599.82, ["Fly|Ride"] = 618.19, ["Neon"] = 2825.47, ["Neon|Fly|Ride"] = 2818.06, ["Mega"] = 14153.01, ["Mega|Fly|Ride"] = 7084.87}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 280.54, ["Fly"] = 396.24, ["Ride"] = 342.56, ["Fly|Ride"] = 393.75, ["Neon"] = 735, ["Neon|Fly"] = 943.55, ["Neon|Ride"] = 802.88, ["Neon|Fly|Ride"] = 781.88, ["Mega"] = 5367.01, ["Mega|Fly|Ride"] = 2655.97}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 315, ["Fly"] = 444.97, ["Ride"] = 356.4, ["Fly|Ride"] = 459.26, ["Neon"] = 1023.75, ["Neon|Fly"] = 3145.52, ["Neon|Ride"] = 939.75, ["Neon|Fly|Ride"] = 934.5, ["Mega|Ride"] = 3675, ["Mega|Fly|Ride"] = 3533.17}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 20.25, ["Ride"] = 17.04, ["Fly|Ride"] = 44.62, ["Neon"] = 5.92, ["Neon|Ride"] = 29.24, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 83.71, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 341.25, ["Fly"] = 590.62, ["Ride"] = 423.78, ["Fly|Ride"] = 556.35, ["Neon"] = 934.5, ["Neon|Ride"] = 1076.25, ["Neon|Fly|Ride"] = 1235.3, ["Mega"] = 6356.51, ["Mega|Fly|Ride"] = 3145.52}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.1, ["Fly"] = 183.75, ["Ride"] = 25.33, ["Fly|Ride"] = 39.38, ["Neon"] = 9.19, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 113.19, ["Mega"] = 49.81, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 218.09}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 20.98, ["Ride"] = 16.96, ["Fly|Ride"] = 49.88, ["Neon"] = 14.1, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 63, ["Mega"] = 91.77, ["Mega|Ride"] = 140.94, ["Mega|Fly|Ride"] = 314.62}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 4.03, ["Neon|Fly"] = 78.66, ["Neon|Ride"] = 24.38, ["Mega"] = 20.88, ["Mega|Fly"] = 71, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 49.8, ["Ride"] = 65.63, ["Fly|Ride"] = 459.38, ["Neon"] = 244.13, ["Neon|Ride"] = 211.91, ["Mega"] = 1695.07, ["Mega|Fly|Ride"] = 943.55}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 65.61, ["Ride"] = 23.6, ["Fly|Ride"] = 43.32, ["Neon"] = 32.82, ["Mega"] = 328.13, ["Mega|Ride"] = 233.89}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.12, ["Neon"] = 3.92, ["Neon|Fly"] = 105.96, ["Neon|Ride"] = 36.28, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 26.25, ["Mega|Fly"] = 706.65, ["Mega|Ride"] = 50.54, ["Mega|Fly|Ride"] = 393.94}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.77, ["Fly"] = 26.25, ["Ride"] = 19.69, ["Fly|Ride"] = 38.9, ["Neon"] = 7.88, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 31.8, ["Neon|Fly|Ride"] = 92.19, ["Mega"] = 60.38, ["Mega|Fly"] = 175.14, ["Mega|Ride"] = 70.88, ["Mega|Fly|Ride"] = 161.33}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 5.76, ["Fly"] = 47.18, ["Ride"] = 31.86, ["Fly|Ride"] = 51.45, ["Neon"] = 42.39, ["Neon|Fly"] = 42.39, ["Neon|Ride"] = 71, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 237.57, ["Mega|Ride"] = 169.52, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 14.69, ["Ride"] = 52.41, ["Fly|Ride"] = 111.57, ["Neon"] = 71, ["Neon|Fly|Ride"] = 304.29, ["Mega"] = 353.85, ["Mega|Ride"] = 336.92, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 4.19, ["Ride"] = 26.17, ["Fly|Ride"] = 87.94, ["Neon"] = 141.75, ["Neon|Ride"] = 63.61, ["Neon|Fly|Ride"] = 282.87, ["Mega"] = 453.45, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 16.75, ["Ride"] = 19.08, ["Fly|Ride"] = 55.44, ["Neon"] = 3.94, ["Neon|Ride"] = 47.16, ["Mega"] = 43.32, ["Mega|Ride"] = 141.98, ["Mega|Fly|Ride"] = 317.84}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 164.06, ["Fly"] = 296.66, ["Ride"] = 258.57, ["Fly|Ride"] = 339.03, ["Neon|Ride"] = 1375.14, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 10594.16, ["Mega|Fly|Ride"] = 4434.94}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 34.16, ["Ride"] = 18.38, ["Fly|Ride"] = 41.29, ["Neon"] = 4.02, ["Neon|Fly"] = 21.2, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 49.88, ["Mega"] = 38.15, ["Mega|Ride"] = 71.17, ["Mega|Fly|Ride"] = 115.64}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 11.81, ["Ride"] = 98.44, ["Fly|Ride"] = 180.02, ["Neon"] = 65.69, ["Neon|Ride"] = 104.41, ["Mega"] = 220.57, ["Mega|Ride"] = 353.3, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 39.38, ["Fly"] = 131.25, ["Ride"] = 51.01, ["Fly|Ride"] = 141.98, ["Neon"] = 209.77, ["Neon|Ride"] = 232.03, ["Neon|Fly|Ride"] = 367.63, ["Mega"] = 767.04, ["Mega|Ride"] = 777.62, ["Mega|Fly|Ride"] = 786.69}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 156.19, ["Fly"] = 308.44, ["Ride"] = 209.77, ["Fly|Ride"] = 312.12, ["Neon"] = 841.32, ["Neon|Ride"] = 651, ["Neon|Fly|Ride"] = 835.48, ["Mega|Ride"] = 3390.14, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 19.43, ["Neon"] = 82.67, ["Neon|Ride"] = 282.87, ["Mega"] = 281.54, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 706.65}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 39.38, ["Ride"] = 279.25, ["Fly|Ride"] = 154.88, ["Neon"] = 184.36, ["Neon|Ride"] = 635.66, ["Neon|Fly|Ride"] = 847.54, ["Mega"] = 1415.32, ["Mega|Fly|Ride"] = 1271.31}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1095.92, ["Fly"] = 1441.13, ["Ride"] = 984.38, ["Fly|Ride"] = 1180.2, ["Neon|Ride"] = 4661.44, ["Neon|Fly|Ride"] = 4258.53, ["Mega|Fly|Ride"] = 17162.54}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 8.93, ["Fly"] = 25.46, ["Ride"] = 21, ["Fly|Ride"] = 63, ["Neon"] = 54.05, ["Neon|Fly"] = 111.57, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 200.82, ["Mega"] = 220.33, ["Mega|Ride"] = 238.39, ["Mega|Fly|Ride"] = 353.85}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 6.57, ["Fly"] = 13965.68, ["Ride"] = 35.43, ["Neon"] = 36.58, ["Neon|Ride"] = 140.39, ["Neon|Fly|Ride"] = 144.74, ["Mega"] = 212.63, ["Mega|Ride"] = 200.82, ["Mega|Fly|Ride"] = 469.62}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 3.67, ["Ride"] = 54.91, ["Fly|Ride"] = 525, ["Neon"] = 26.1, ["Neon|Ride"] = 117.96, ["Mega"] = 148.49, ["Mega|Ride"] = 338.63, ["Mega|Fly|Ride"] = 565.74}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 23.61, ["Fly"] = 706.65, ["Ride"] = 27.57, ["Fly|Ride"] = 98.44, ["Neon"] = 78.11, ["Neon|Ride"] = 98.98, ["Neon|Fly|Ride"] = 142.37, ["Mega"] = 382.39, ["Mega|Ride"] = 371.58, ["Mega|Fly|Ride"] = 441}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 3.6, ["Fly"] = 21.2, ["Ride"] = 21.2, ["Fly|Ride"] = 40.95, ["Neon"] = 21.98, ["Neon|Fly"] = 57.22, ["Neon|Ride"] = 36.12, ["Neon|Fly|Ride"] = 87.95, ["Mega|Ride"] = 157.49, ["Mega|Fly|Ride"] = 131.24}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 14.23, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 56.9, ["Neon|Fly|Ride"] = 110.88, ["Mega"] = 233.24, ["Mega|Ride"] = 131.15, ["Mega|Fly|Ride"] = 388.82}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 211.91, ["Ride"] = 333.38, ["Fly|Ride"] = 597.98, ["Neon|Ride"] = 1693.13, ["Neon|Fly|Ride"] = 1456.71, ["Mega|Ride"] = 5250, ["Mega|Fly|Ride"] = 4626.47}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.13, ["Ride"] = 26.24, ["Fly|Ride"] = 47.19, ["Neon"] = 10.77, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 41.91, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 112.87, ["Mega|Ride"] = 103.43, ["Mega|Fly|Ride"] = 312.55}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 2.1, ["Neon"] = 42, ["Neon|Ride"] = 313.69, ["Mega"] = 278.64, ["Mega|Ride"] = 267.25}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.92, ["Fly"] = 58.26, ["Ride"] = 34.13, ["Neon"] = 19.69, ["Neon|Ride"] = 119.74, ["Neon|Fly|Ride"] = 207.18, ["Mega"] = 104.24, ["Mega|Fly"] = 423.78, ["Mega|Ride"] = 188.35, ["Mega|Fly|Ride"] = 349.79}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 186.38, ["Fly"] = 339.03, ["Ride"] = 275.63, ["Fly|Ride"] = 616.88, ["Neon"] = 660.19, ["Neon|Ride"] = 565.73, ["Neon|Fly|Ride"] = 945, ["Mega|Ride"] = 5085.21, ["Mega|Fly|Ride"] = 1897.43}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 52.5, ["Fly"] = 61.62, ["Ride"] = 149.63, ["Fly|Ride"] = 110.19, ["Neon"] = 99.08, ["Neon|Fly|Ride"] = 324.19, ["Mega"] = 593.29, ["Mega|Ride"] = 740.55, ["Mega|Fly|Ride"] = 752.47}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 19.67, ["Ride"] = 45.94, ["Fly|Ride"] = 1271.31, ["Neon"] = 91.88, ["Neon|Ride"] = 110.88, ["Neon|Fly|Ride"] = 257.25, ["Mega"] = 467.79, ["Mega|Ride"] = 446.07, ["Mega|Fly|Ride"] = 547.32}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 3.91, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.17, ["Mega"] = 34.13, ["Mega|Ride"] = 48.75, ["Mega|Fly|Ride"] = 114.19}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 94.37, ["Fly"] = 94.86, ["Ride"] = 115.5, ["Fly|Ride"] = 191.71, ["Neon"] = 410.01, ["Neon|Fly"] = 381.41, ["Neon|Ride"] = 381.41, ["Neon|Fly|Ride"] = 383.24, ["Mega|Fly|Ride"] = 1209.91}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 18.8, ["Neon"] = 6.57, ["Neon|Fly"] = 47.19, ["Neon|Ride"] = 57.22, ["Neon|Fly|Ride"] = 588, ["Mega"] = 40.68, ["Mega|Ride"] = 141.98}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 20.87, ["Fly"] = 32.82, ["Ride"] = 31.4, ["Fly|Ride"] = 125.02, ["Neon"] = 57.22, ["Neon|Ride"] = 101.43, ["Neon|Fly|Ride"] = 99.61, ["Mega"] = 380.63, ["Mega|Ride"] = 387.76, ["Mega|Fly|Ride"] = 362.6}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 46.19, ["Fly"] = 80.01, ["Ride"] = 85.32, ["Fly|Ride"] = 122.91, ["Neon"] = 238.39, ["Neon|Ride"] = 239.44, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 1235.3, ["Mega|Fly|Ride"] = 1134}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 12.72, ["Ride"] = 15.83, ["Fly|Ride"] = 36.58, ["Neon"] = 2.1, ["Neon|Fly"] = 16.96, ["Neon|Ride"] = 16.96, ["Neon|Fly|Ride"] = 42.48, ["Mega"] = 18.38, ["Mega|Fly"] = 117.96, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 83.73}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.91, ["Ride"] = 32.18, ["Fly|Ride"] = 78.75, ["Neon"] = 30.74, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 177.19, ["Mega|Ride"] = 282.87, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 13.12, ["Ride"] = 105, ["Neon"] = 26.25, ["Neon|Ride"] = 209.77, ["Neon|Fly|Ride"] = 358.05, ["Mega"] = 749.02, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 651}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 2.5, ["Neon|Ride"] = 28.62, ["Neon|Fly|Ride"] = 137.73, ["Mega"] = 23.59, ["Mega|Ride"] = 78.65, ["Mega|Fly|Ride"] = 311.73}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 3.93, ["Fly"] = 210, ["Ride"] = 28.76, ["Fly|Ride"] = 105, ["Neon"] = 63.09, ["Neon|Ride"] = 91.77, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 220.38, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 190.71, ["Mega|Fly|Ride"] = 423.78}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 15.72, ["Fly"] = 42.11, ["Ride"] = 28.62, ["Fly|Ride"] = 63.7, ["Neon"] = 117.03, ["Neon|Ride"] = 64.56, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 360.94, ["Mega|Fly|Ride"] = 706.65}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 2.1, ["Ride"] = 58.97, ["Neon"] = 25.68, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 200.51, ["Mega"] = 169.32, ["Mega|Ride"] = 183.26, ["Mega|Fly|Ride"] = 282.87}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 65.54, ["Fly"] = 2118.84, ["Ride"] = 79.02, ["Neon"] = 121.85, ["Neon|Ride"] = 282.87, ["Neon|Fly|Ride"] = 565.74, ["Mega"] = 652.98, ["Mega|Ride"] = 1024.42, ["Mega|Fly|Ride"] = 989.5}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 125.58, ["Fly|Ride"] = 196.87, ["Neon"] = 7.88, ["Neon|Fly"] = 50.87, ["Neon|Ride"] = 71, ["Neon|Fly|Ride"] = 99.08, ["Mega"] = 69.93, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 169.85}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Mega"] = 23.63, ["Mega|Ride"] = 138.8, ["Mega|Fly|Ride"] = 423.78}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 35.43}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 65.61, ["Fly"] = 102.38, ["Ride"] = 64.32, ["Fly|Ride"] = 206.6, ["Neon"] = 1050, ["Neon|Ride"] = 224.62, ["Neon|Fly|Ride"] = 1059.43, ["Mega"] = 1116.64, ["Mega|Ride"] = 786.69, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 81.38, ["Fly|Ride"] = 141.98, ["Neon"] = 3.26, ["Mega"] = 19.69, ["Mega|Fly"] = 137.82, ["Mega|Ride"] = 99.6, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 551.25, ["Ride"] = 712.38, ["Fly|Ride"] = 525, ["Neon"] = 2397.48, ["Neon|Ride"] = 2398.53, ["Neon|Fly|Ride"] = 2401.7, ["Mega"] = 16950.65, ["Mega|Fly|Ride"] = 14119.9}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 10.39, ["Fly"] = 26.17, ["Ride"] = 42.33, ["Fly|Ride"] = 79.48, ["Neon"] = 279.7, ["Neon|Ride"] = 279.7, ["Mega"] = 82.65, ["Mega|Ride"] = 141.98, ["Mega|Fly|Ride"] = 565.74}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 6.56, ["Fly"] = 158.06, ["Ride"] = 23.25, ["Fly|Ride"] = 39.38, ["Neon"] = 23.63, ["Neon|Ride"] = 35.38, ["Neon|Fly|Ride"] = 63.58, ["Mega"] = 282.87, ["Mega|Ride"] = 156.8, ["Mega|Fly|Ride"] = 187.69}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 12.6, ["Ride"] = 39.38, ["Fly|Ride"] = 106.31, ["Neon"] = 105.71, ["Neon|Ride"] = 55.39, ["Mega"] = 502.18, ["Mega|Ride"] = 383.25, ["Mega|Fly|Ride"] = 528.67}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.91, ["Fly"] = 39.38, ["Ride"] = 31.5, ["Fly|Ride"] = 141.98, ["Neon"] = 41.33, ["Mega"] = 255.94}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 15.74, ["Ride"] = 59.35, ["Fly|Ride"] = 157.49, ["Neon"] = 100.66, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 350.44, ["Mega"] = 363.57, ["Mega|Ride"] = 407.54, ["Mega|Fly|Ride"] = 492.19}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 5.25, ["Fly"] = 98.44, ["Ride"] = 39.38, ["Fly|Ride"] = 847.54, ["Neon"] = 31.86, ["Neon|Ride"] = 93.24, ["Neon|Fly|Ride"] = 141.98, ["Mega"] = 217.88, ["Mega|Fly"] = 489.47, ["Mega|Ride"] = 239.45, ["Mega|Fly|Ride"] = 339.03}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 15.91, ["Fly|Ride"] = 28.77, ["Neon"] = 2.1, ["Neon|Fly"] = 28.62, ["Neon|Ride"] = 15.89, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 16.42, ["Mega|Fly"] = 79.04, ["Mega|Ride"] = 26.25, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 9.19, ["Ride"] = 39.38, ["Neon"] = 27.57, ["Neon|Fly"] = 117.96, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 317.84, ["Mega"] = 167.88, ["Mega|Ride"] = 216.14, ["Mega|Fly|Ride"] = 282.87}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 293.22, ["Ride"] = 275.63, ["Fly|Ride"] = 342.2, ["Neon"] = 1480.5, ["Neon|Ride"] = 1107.75, ["Neon|Fly|Ride"] = 2118.84, ["Mega|Fly|Ride"] = 3897.01}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 85.45, ["Fly"] = 156.8, ["Ride"] = 148.1, ["Fly|Ride"] = 7768.7, ["Neon"] = 524.43, ["Neon|Ride"] = 502.88, ["Neon|Fly|Ride"] = 623.44, ["Mega"] = 4237.67, ["Mega|Ride"] = 2118.84, ["Mega|Fly|Ride"] = 1626.95}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 21.2, ["Ride"] = 15.91, ["Fly|Ride"] = 39.34, ["Neon"] = 12.71, ["Neon|Fly"] = 18.38, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 62.67, ["Mega"] = 91.12, ["Mega|Fly"] = 210.83, ["Mega|Ride"] = 92.19, ["Mega|Fly|Ride"] = 141.98}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 15.75, ["Fly|Ride"] = 21.2, ["Neon"] = 6.57, ["Neon|Fly"] = 41.33, ["Neon|Ride"] = 22.97, ["Neon|Fly|Ride"] = 57.21, ["Mega"] = 69.93, ["Mega|Fly"] = 353.85, ["Mega|Ride"] = 93.19, ["Mega|Fly|Ride"] = 126}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.63, ["Ride"] = 18.38, ["Fly|Ride"] = 98.44, ["Neon"] = 39.38, ["Mega"] = 1130.41}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 210, ["Ride"] = 271.69, ["Fly|Ride"] = 328.13, ["Neon|Ride"] = 1290.3, ["Neon|Fly|Ride"] = 1415.32, ["Mega|Ride"] = 8475.33, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 3.94, ["Fly"] = 20.9, ["Ride"] = 16.94, ["Fly|Ride"] = 35.44, ["Neon"] = 23.62, ["Neon|Fly"] = 158.06, ["Neon|Ride"] = 28.61, ["Neon|Fly|Ride"] = 75.49, ["Mega"] = 291.36, ["Mega|Ride"] = 252.16, ["Mega|Fly|Ride"] = 259.85}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 4.25, ["Fly"] = 141.54, ["Ride"] = 40.11, ["Fly|Ride"] = 211.91, ["Neon"] = 27.57, ["Neon|Ride"] = 38.04, ["Mega"] = 230.99, ["Mega|Ride"] = 236.24, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 4.93, ["Neon|Ride"] = 21.2, ["Neon|Fly|Ride"] = 141.98, ["Mega"] = 40.69, ["Mega|Ride"] = 95.7, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 13.69, ["Fly"] = 71, ["Ride"] = 22.32, ["Fly|Ride"] = 59.07, ["Neon"] = 87.95, ["Neon|Ride"] = 99.08, ["Neon|Fly|Ride"] = 180.12, ["Mega"] = 728.34, ["Mega|Ride"] = 333.38, ["Mega|Fly|Ride"] = 395.53}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 60.38, ["Fly"] = 116.82, ["Ride"] = 102.5, ["Fly|Ride"] = 249.38, ["Neon"] = 131.24, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 175.21, ["Neon|Fly|Ride"] = 349.13, ["Mega"] = 455.44, ["Mega|Fly"] = 2224.8, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 598.55}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 23.63, ["Fly"] = 63.71, ["Ride"] = 41.83, ["Fly|Ride"] = 94.9, ["Neon"] = 118.13, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 139.07, ["Neon|Fly|Ride"] = 219.19, ["Mega|Ride"] = 783.12, ["Mega|Fly|Ride"] = 654.73}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.03, ["Fly"] = 15.91, ["Ride"] = 15.91, ["Fly|Ride"] = 32.82, ["Neon"] = 2.63, ["Neon|Fly"] = 23.55, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 62.52, ["Mega"] = 15.75, ["Mega|Fly"] = 28.88, ["Mega|Ride"] = 45.56, ["Mega|Fly|Ride"] = 114.35}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 204.73, ["Fly"] = 278.24, ["Ride"] = 250.51, ["Fly|Ride"] = 325.5, ["Neon"] = 892.5, ["Neon|Ride"] = 958.13, ["Neon|Fly|Ride"] = 883.32, ["Mega|Fly|Ride"] = 4168.81}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 12.99, ["Fly"] = 140.39, ["Ride"] = 42, ["Neon"] = 93.19, ["Neon|Ride"] = 201.3, ["Neon|Fly|Ride"] = 210, ["Mega"] = 635.66, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 494.82}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Ride"] = 18.38, ["Fly|Ride"] = 39.3, ["Neon"] = 6.57, ["Neon|Ride"] = 57.22, ["Neon|Fly|Ride"] = 101.43, ["Mega"] = 61.46, ["Mega|Fly"] = 79.48, ["Mega|Ride"] = 71, ["Mega|Fly|Ride"] = 299.59}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 17.07, ["Fly|Ride"] = 56.9, ["Neon"] = 3.84, ["Neon|Fly"] = 47.19, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 97.23, ["Mega"] = 24.69, ["Mega|Fly"] = 141.54, ["Mega|Ride"] = 52.98, ["Mega|Fly|Ride"] = 140.07}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 3.68, ["Fly"] = 131.25, ["Ride"] = 21.15, ["Fly|Ride"] = 141.72, ["Neon"] = 7.77, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 7063.13, ["Mega"] = 92.93, ["Mega|Fly|Ride"] = 353.85}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 13.12, ["Fly"] = 65.63, ["Ride"] = 28.46, ["Fly|Ride"] = 57.22, ["Neon"] = 57.75, ["Neon|Ride"] = 60.25, ["Neon|Fly|Ride"] = 123.12, ["Mega"] = 347.94, ["Mega|Ride"] = 293.98, ["Mega|Fly|Ride"] = 343.59}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 9.19, ["Ride"] = 26.25, ["Fly|Ride"] = 72.19, ["Neon"] = 39.38, ["Neon|Ride"] = 84.76, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 223.13, ["Mega|Ride"] = 308.31, ["Mega|Fly|Ride"] = 478.87}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 44.76, ["Neon"] = 3.92, ["Neon|Ride"] = 36.58, ["Neon|Fly|Ride"] = 94.37, ["Mega"] = 26.25, ["Mega|Ride"] = 73.07, ["Mega|Fly|Ride"] = 282.87}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 7.88, ["Fly"] = 28.62, ["Ride"] = 36.04, ["Fly|Ride"] = 84.76, ["Neon"] = 24.94, ["Neon|Fly"] = 102.92, ["Neon|Ride"] = 52.99, ["Neon|Fly|Ride"] = 141.74, ["Mega"] = 157.5, ["Mega|Fly"] = 269.1, ["Mega|Ride"] = 169.52, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 127.15, ["Fly|Ride"] = 99.61, ["Neon"] = 6.38, ["Neon|Fly"] = 84.76, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 158.06, ["Mega"] = 34.12, ["Mega|Ride"] = 91.34, ["Mega|Fly|Ride"] = 629.83}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 24.62, ["Ride"] = 20.89, ["Fly|Ride"] = 58.97, ["Neon"] = 6.3, ["Neon|Ride"] = 22.31, ["Neon|Fly|Ride"] = 117.6, ["Mega"] = 103.84, ["Mega|Ride"] = 85.22, ["Mega|Fly|Ride"] = 166.77}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 761.25, ["Ride"] = 721.88, ["Fly|Ride"] = 913.5, ["Neon|Ride"] = 3018.75, ["Neon|Fly|Ride"] = 4188.59, ["Mega|Fly|Ride"] = 12462.19}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.63, ["Fly"] = 24.94, ["Ride"] = 16.93, ["Fly|Ride"] = 35.43, ["Neon"] = 23.15, ["Neon|Fly"] = 44.62, ["Neon|Ride"] = 57.21, ["Neon|Fly|Ride"] = 69.93, ["Mega"] = 189.65, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.63, ["Ride"] = 69.57, ["Fly|Ride"] = 132.57, ["Neon"] = 10.45, ["Neon|Fly"] = 847.54, ["Neon|Ride"] = 82.69, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 45.94, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 282.82}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 10.5, ["Fly"] = 42.39, ["Ride"] = 23.6, ["Fly|Ride"] = 52.99, ["Neon"] = 44.63, ["Neon|Fly"] = 112.74, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 312.55, ["Mega|Ride"] = 298.19, ["Mega|Fly|Ride"] = 336}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 15.91, ["Ride"] = 16.94, ["Fly|Ride"] = 38.15, ["Neon"] = 10.61, ["Neon|Fly"] = 130.96, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 60.4, ["Mega"] = 61.69, ["Mega|Fly"] = 349.84, ["Mega|Ride"] = 96.8, ["Mega|Fly|Ride"] = 174.03}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 41.99, ["Ride"] = 62.52, ["Neon"] = 314.92, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 360.94, ["Mega"] = 887.48, ["Mega|Fly"] = 989.5, ["Mega|Ride"] = 933.36}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 129.94, ["Ride"] = 25.44, ["Fly|Ride"] = 92.19, ["Neon"] = 6.23, ["Neon|Ride"] = 27.46, ["Neon|Fly|Ride"] = 206.07, ["Mega"] = 63.66, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 297.94}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 3.65, ["Fly"] = 73.5, ["Ride"] = 24.38, ["Fly|Ride"] = 61.46, ["Neon"] = 15.75, ["Neon|Fly"] = 141.54, ["Neon|Ride"] = 31.8, ["Neon|Fly|Ride"] = 453.45, ["Mega"] = 93.19, ["Mega|Ride"] = 294.47, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.61, ["Fly"] = 26.25, ["Fly|Ride"] = 65.76, ["Neon"] = 15.75, ["Mega"] = 112.23}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 2593.49, ["Ride"] = 20.08, ["Fly|Ride"] = 98.44, ["Neon"] = 4.47, ["Neon|Ride"] = 29.89, ["Neon|Fly|Ride"] = 94.4, ["Mega"] = 42, ["Mega|Fly"] = 156.8, ["Mega|Ride"] = 63.57, ["Mega|Fly|Ride"] = 127.15}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 17.07, ["Fly"] = 21.05, ["Ride"] = 22.79, ["Fly|Ride"] = 41.94, ["Neon"] = 78.75, ["Neon|Ride"] = 113.37, ["Neon|Fly|Ride"] = 114.19, ["Mega"] = 847.54, ["Mega|Fly|Ride"] = 489.47}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 728.44, ["Ride"] = 733.69, ["Fly|Ride"] = 912.83, ["Neon"] = 1938.56, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 1998.94, ["Mega|Ride"] = 5643.75, ["Mega|Fly|Ride"] = 5440.82}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 19.08, ["Ride"] = 18.38, ["Fly|Ride"] = 41.88, ["Neon"] = 5.25, ["Neon|Fly"] = 31.49, ["Neon|Ride"] = 21.17, ["Neon|Fly|Ride"] = 60.38, ["Mega"] = 45.85, ["Mega|Ride"] = 77.82, ["Mega|Fly|Ride"] = 134.56}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 18.38, ["Ride"] = 27.46, ["Fly|Ride"] = 92.18, ["Neon"] = 56.44, ["Neon|Ride"] = 113.37, ["Neon|Fly|Ride"] = 248.11, ["Mega"] = 254.27, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 454.13}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 52.5, ["Fly"] = 105.96, ["Ride"] = 86.63, ["Fly|Ride"] = 126.21, ["Neon|Ride"] = 565.74, ["Neon|Fly|Ride"] = 1240.32, ["Mega"] = 1890.02, ["Mega|Ride"] = 1554.18, ["Mega|Fly|Ride"] = 1413.28}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 55.11, ["Ride"] = 49.88, ["Fly|Ride"] = 301.88, ["Neon"] = 320.25, ["Neon|Ride"] = 177.19, ["Neon|Fly|Ride"] = 198.13, ["Mega"] = 921.71, ["Mega|Ride"] = 894.02, ["Mega|Fly|Ride"] = 994.81}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 13.12, ["Ride"] = 30.19, ["Neon"] = 52.5, ["Neon|Ride"] = 169.52, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 419.54, ["Mega|Ride"] = 367.63, ["Mega|Fly|Ride"] = 360.94}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 36.04, ["Ride"] = 99.61, ["Neon"] = 72.19, ["Neon|Fly"] = 299.59, ["Neon|Ride"] = 362.09, ["Mega"] = 319.96, ["Mega|Ride"] = 312.55, ["Mega|Fly|Ride"] = 409.26}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 26.06, ["Fly"] = 34.13, ["Ride"] = 94.37, ["Neon"] = 131.25, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 525, ["Mega"] = 654.29, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 843.29}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 13.52}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 5.34, ["Fly"] = 39.38, ["Ride"] = 29.89, ["Fly|Ride"] = 104.89, ["Neon"] = 32.82, ["Neon|Ride"] = 71, ["Neon|Fly|Ride"] = 169.52, ["Mega"] = 200.23, ["Mega|Fly"] = 519.75, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 276.94}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 6.3, ["Ride"] = 47.19, ["Neon"] = 11.82, ["Mega"] = 350.66, ["Mega|Fly|Ride"] = 953.49}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 57.73, ["Fly"] = 393.72, ["Ride"] = 84.68, ["Fly|Ride"] = 116.82, ["Neon"] = 232.32, ["Neon|Ride"] = 261.19, ["Neon|Fly|Ride"] = 315, ["Mega|Ride"] = 878.07, ["Mega|Fly|Ride"] = 799.64}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 6.46, ["Fly"] = 17.07, ["Ride"] = 20.89, ["Fly|Ride"] = 43.31, ["Neon"] = 31.69, ["Neon|Fly"] = 70.88, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 77.12, ["Mega"] = 262.5, ["Mega|Fly"] = 423.78, ["Mega|Ride"] = 267.37, ["Mega|Fly|Ride"] = 244.13}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 5.25, ["Fly"] = 84.76, ["Ride"] = 26.25, ["Fly|Ride"] = 71, ["Neon"] = 18.38, ["Neon|Ride"] = 60.17, ["Neon|Fly|Ride"] = 123.11, ["Mega"] = 133.81, ["Mega|Fly"] = 301.45, ["Mega|Ride"] = 170.87, ["Mega|Fly|Ride"] = 252.45}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Neon|Ride"] = 201.7, ["Mega"] = 34.12, ["Mega|Ride"] = 79.19, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 57.22, ["Fly"] = 84.76, ["Ride"] = 45.94, ["Fly|Ride"] = 78.74, ["Neon"] = 181.16, ["Neon|Ride"] = 185.41, ["Neon|Fly|Ride"] = 282.87, ["Mega"] = 1130.41, ["Mega|Ride"] = 795.63, ["Mega|Fly|Ride"] = 850.5}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 28.32, ["Fly|Ride"] = 141.98, ["Neon"] = 7.35, ["Neon|Fly"] = 174.57, ["Neon|Ride"] = 71, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 141.98, ["Mega|Fly|Ride"] = 314.92}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 14.44, ["Ride"] = 145.69, ["Neon"] = 82.69, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 351.74, ["Mega"] = 288.75, ["Mega|Ride"] = 496.13, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Ride"] = 16.95, ["Fly|Ride"] = 47.24, ["Neon"] = 19.94, ["Neon|Ride"] = 40.27, ["Neon|Fly|Ride"] = 99.43, ["Mega"] = 198.13, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 420.66}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 3.94, ["Fly"] = 52.5, ["Ride"] = 24.38, ["Fly|Ride"] = 65.63, ["Neon"] = 61.35, ["Neon|Ride"] = 141.98, ["Mega"] = 277.58, ["Mega|Ride"] = 247.92, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.83, ["Ride"] = 139.79, ["Neon"] = 28.29, ["Neon|Ride"] = 110.88, ["Mega"] = 141.98, ["Mega|Ride"] = 771.1}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 51.19, ["Ride"] = 91.88, ["Neon"] = 195.57, ["Neon|Ride"] = 294.53, ["Neon|Fly|Ride"] = 325.26, ["Mega"] = 1058.37, ["Mega|Ride"] = 1413.28, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 15.75, ["Ride"] = 281.61, ["Neon"] = 210, ["Neon|Ride"] = 184.36, ["Mega"] = 385.88, ["Mega|Fly|Ride"] = 570.29}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 18.38, ["Ride"] = 63.61, ["Neon"] = 141.98, ["Neon|Ride"] = 393.75, ["Mega"] = 593.29, ["Mega|Ride"] = 558.32, ["Mega|Fly|Ride"] = 1695.07}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 21, ["Ride"] = 26.25, ["Fly|Ride"] = 422.03, ["Neon"] = 141.98, ["Neon|Ride"] = 635.66, ["Mega"] = 945, ["Mega|Ride"] = 847.54, ["Mega|Fly|Ride"] = 989.5}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 4.12, ["Neon"] = 42.48, ["Neon|Ride"] = 423.78, ["Mega"] = 240.51, ["Mega|Fly|Ride"] = 314.92}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 21.13, ["Ride"] = 17.71, ["Fly|Ride"] = 41.91, ["Neon"] = 4.25, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 23.3, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 57.22, ["Mega|Ride"] = 79.04, ["Mega|Fly|Ride"] = 276.29}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 15.74, ["Ride"] = 48.76, ["Fly|Ride"] = 92.19, ["Neon"] = 27.57, ["Neon|Fly"] = 71, ["Neon|Ride"] = 61.45, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 167.41, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 16.9, ["Fly|Ride"] = 55.13, ["Neon"] = 6.57, ["Neon|Ride"] = 21.2, ["Neon|Fly|Ride"] = 84.76, ["Mega"] = 47.18, ["Mega|Ride"] = 97.13, ["Mega|Fly|Ride"] = 127.15}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.68, ["Fly"] = 131.25, ["Ride"] = 63.71, ["Fly|Ride"] = 99.61, ["Neon"] = 39.25, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 198.13, ["Mega"] = 175.88, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 471.78}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.93, ["Ride"] = 30.19, ["Fly|Ride"] = 103.69, ["Neon"] = 32.82, ["Neon|Ride"] = 97.76, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 416.8, ["Mega|Fly|Ride"] = 393.94}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.89, ["Fly"] = 21.2, ["Ride"] = 26.25, ["Fly|Ride"] = 59.35, ["Neon"] = 30.66, ["Neon|Fly"] = 104.77, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 101.07, ["Mega|Ride"] = 252, ["Mega|Fly|Ride"] = 359.08}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 3.93, ["Fly"] = 34.07, ["Ride"] = 20.11, ["Fly|Ride"] = 63.58, ["Neon"] = 19.93, ["Neon|Fly"] = 84.76, ["Neon|Ride"] = 91.12, ["Neon|Fly|Ride"] = 79.04, ["Mega"] = 138.79, ["Mega|Ride"] = 173.76, ["Mega|Fly|Ride"] = 347.5}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 11.67, ["Fly"] = 301.88, ["Ride"] = 61.46, ["Fly|Ride"] = 108.94, ["Neon"] = 24.93, ["Neon|Fly"] = 169.52, ["Neon|Ride"] = 111.98, ["Neon|Fly|Ride"] = 246.28, ["Mega"] = 102.42, ["Mega|Fly"] = 312.55, ["Mega|Ride"] = 149.8, ["Mega|Fly|Ride"] = 311.16}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 15.74, ["Fly"] = 105, ["Ride"] = 106.29, ["Fly|Ride"] = 170.63, ["Neon"] = 98.69, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 487.34, ["Mega"] = 367.5, ["Mega|Fly"] = 1968.75, ["Mega|Ride"] = 440.9, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 71, ["Ride"] = 84.76, ["Fly|Ride"] = 158.06, ["Neon"] = 234.53, ["Neon|Ride"] = 269.07, ["Neon|Fly|Ride"] = 369.73, ["Mega"] = 1050, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 964.62}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Ride"] = 25.51, ["Fly|Ride"] = 65.54, ["Neon"] = 3.94, ["Neon|Ride"] = 37.95, ["Neon|Fly|Ride"] = 58.35, ["Mega"] = 26.57, ["Mega|Ride"] = 71.14, ["Mega|Fly|Ride"] = 114.38}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 11.8, ["Ride"] = 353.85, ["Neon"] = 281.59, ["Mega"] = 423.78, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 1271.31}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 53.82, ["Fly"] = 105, ["Ride"] = 127.15, ["Neon"] = 304.5, ["Neon|Ride"] = 341.25, ["Mega|Ride"] = 1110.29, ["Mega|Fly|Ride"] = 1269.19}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 11.81, ["Fly"] = 190.32, ["Ride"] = 21, ["Fly|Ride"] = 126, ["Neon"] = 40.69, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 211.91, ["Mega"] = 198.33, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 394.42}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Fly"] = 23.33, ["Ride"] = 52.47, ["Fly|Ride"] = 82.65, ["Neon"] = 4.25, ["Neon|Ride"] = 31.5, ["Mega"] = 32.49, ["Mega|Ride"] = 47.99, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 14.44, ["Ride"] = 20.03, ["Fly|Ride"] = 58.98, ["Neon"] = 11.61, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 141.98, ["Mega|Fly"] = 353.85, ["Mega|Ride"] = 198.65, ["Mega|Fly|Ride"] = 239.54}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 19.08, ["Ride"] = 15.7, ["Fly|Ride"] = 35.44, ["Neon"] = 3.94, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 105, ["Mega"] = 34.13, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 23, ["Fly|Ride"] = 65.7, ["Neon"] = 3.94, ["Neon|Ride"] = 28.62, ["Neon|Fly|Ride"] = 84.76, ["Mega"] = 34.1, ["Mega|Fly"] = 235.9, ["Mega|Ride"] = 57.22, ["Mega|Fly|Ride"] = 180.32}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 2.63, ["Neon|Ride"] = 126.27, ["Mega"] = 17.48, ["Mega|Ride"] = 104.89, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 9.19, ["Ride"] = 31.4, ["Fly|Ride"] = 262.5, ["Neon"] = 42.37, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 209.77, ["Mega"] = 202.36, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 331.42}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 28.62, ["Ride"] = 34.13, ["Fly|Ride"] = 156.8, ["Neon"] = 71, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 234.72, ["Mega"] = 402.59, ["Mega|Fly|Ride"] = 593.29}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 13.13, ["Fly"] = 24.05, ["Ride"] = 25.4, ["Fly|Ride"] = 47.19, ["Neon"] = 52.85, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 54.28, ["Neon|Fly|Ride"] = 74.8, ["Mega|Ride"] = 334.69, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 80.01, ["Ride"] = 144.38, ["Fly|Ride"] = 262.5, ["Neon"] = 538.13, ["Neon|Ride"] = 997.5, ["Mega"] = 3145.52, ["Mega|Fly|Ride"] = 1554.18}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 25.71, ["Fly"] = 72.43, ["Ride"] = 42.21, ["Fly|Ride"] = 79.04, ["Neon"] = 93.19, ["Mega"] = 565.74, ["Mega|Ride"] = 617.54, ["Mega|Fly|Ride"] = 1033.6}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 17.91, ["Ride"] = 18.99, ["Fly|Ride"] = 36.74, ["Neon"] = 3.29, ["Neon|Fly"] = 32.85, ["Neon|Ride"] = 21.19, ["Neon|Fly|Ride"] = 47.19, ["Mega"] = 60.4, ["Mega|Ride"] = 109.13, ["Mega|Fly|Ride"] = 144.1}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 17.71, ["Ride"] = 15.91, ["Fly|Ride"] = 31.8, ["Neon"] = 3.94, ["Neon|Fly"] = 23.39, ["Neon|Ride"] = 21.2, ["Neon|Fly|Ride"] = 40.11, ["Mega"] = 47.25, ["Mega|Ride"] = 38.66, ["Mega|Fly|Ride"] = 91.87}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 393.68, ["Ride"] = 423.3, ["Fly|Ride"] = 460.83, ["Neon|Fly|Ride"] = 1509.38}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 27.57, ["Ride"] = 197.06, ["Fly|Ride"] = 94.5, ["Neon"] = 93.24, ["Mega"] = 436.42, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1101.59}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 34.13, ["Ride"] = 15.91, ["Fly|Ride"] = 32.82, ["Neon"] = 5.91, ["Neon|Fly"] = 28.5, ["Neon|Ride"] = 20.74, ["Neon|Fly|Ride"] = 39.11, ["Mega"] = 43.32, ["Mega|Ride"] = 57.11, ["Mega|Fly|Ride"] = 100.93}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 65.63, ["Ride"] = 137.16, ["Fly|Ride"] = 315, ["Neon"] = 211.89, ["Neon|Ride"] = 302.7, ["Neon|Fly|Ride"] = 366.19, ["Mega"] = 713.13, ["Mega|Ride"] = 731.56, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 31.8, ["Ride"] = 19.08, ["Fly|Ride"] = 46.64, ["Neon"] = 13.13, ["Neon|Fly"] = 92.19, ["Neon|Ride"] = 27.23, ["Neon|Fly|Ride"] = 78.3, ["Mega"] = 106.16, ["Mega|Fly"] = 160.13, ["Mega|Ride"] = 108.57, ["Mega|Fly|Ride"] = 206.25}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 71, ["Ride"] = 57.22, ["Fly|Ride"] = 1312.5, ["Neon"] = 2.63, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 283.19, ["Mega"] = 24, ["Mega|Fly"] = 96.42, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 224.62}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 53.81, ["Fly"] = 141.42, ["Ride"] = 99.65, ["Fly|Ride"] = 282.87, ["Neon"] = 174.56, ["Neon|Ride"] = 353.85, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1271.31, ["Mega|Ride"] = 684.58, ["Mega|Fly|Ride"] = 768.6}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 21.86, ["Fly|Ride"] = 39.38, ["Neon"] = 5.24, ["Neon|Ride"] = 55.11, ["Mega"] = 101.72, ["Mega|Ride"] = 121.73, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 34.48, ["Fly"] = 79.04, ["Ride"] = 49.68, ["Neon"] = 197.06, ["Neon|Ride"] = 198.13, ["Neon|Fly|Ride"] = 317.84, ["Mega|Ride"] = 1582.77, ["Mega|Fly|Ride"] = 987.95}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.91, ["Neon"] = 42.39, ["Neon|Ride"] = 203.44, ["Mega"] = 173.92, ["Mega|Ride"] = 603.75, ["Mega|Fly|Ride"] = 551.92}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 3.62, ["Fly"] = 71, ["Ride"] = 70.98, ["Fly|Ride"] = 65.63, ["Neon"] = 12.76, ["Neon|Fly"] = 71, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 108.53, ["Mega"] = 78.75, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 565.74}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 31.18, ["Fly"] = 43.32, ["Ride"] = 70.66, ["Fly|Ride"] = 104.81, ["Neon|Ride"] = 226.73, ["Mega"] = 2118.84, ["Mega|Ride"] = 2040.94, ["Mega|Fly|Ride"] = 1101.8}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.63, ["Fly"] = 144.82, ["Ride"] = 36.04, ["Fly|Ride"] = 908.98, ["Neon"] = 7.88, ["Neon|Fly"] = 78.66, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 168, ["Mega"] = 39.38, ["Mega|Fly"] = 158.61, ["Mega|Ride"] = 121.85, ["Mega|Fly|Ride"] = 262.75}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 57.22, ["Ride"] = 28.51, ["Fly|Ride"] = 102.84, ["Neon"] = 2.63, ["Neon|Fly"] = 41.88, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 71, ["Mega"] = 105.77, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 280.23}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 15.91, ["Ride"] = 40.69, ["Fly|Ride"] = 188.72, ["Neon"] = 78.75, ["Neon|Ride"] = 120.75, ["Mega"] = 311.07, ["Mega|Ride"] = 471.78, ["Mega|Fly|Ride"] = 377.99}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 45.94, ["Ride"] = 91.88, ["Fly|Ride"] = 112.12, ["Neon"] = 202.13, ["Neon|Ride"] = 252.41, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 656.24, ["Mega|Ride"] = 680.34, ["Mega|Fly|Ride"] = 650.99}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 32.82, ["Fly"] = 131.25, ["Ride"] = 35.38, ["Fly|Ride"] = 77.44, ["Neon"] = 103.69, ["Neon|Ride"] = 71, ["Neon|Fly|Ride"] = 141.98, ["Mega"] = 620.57, ["Mega|Ride"] = 423.78, ["Mega|Fly|Ride"] = 336.87}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 65.63, ["Ride"] = 126, ["Fly|Ride"] = 225.85, ["Neon"] = 262.48, ["Neon|Ride"] = 380.63, ["Neon|Fly|Ride"] = 555.19, ["Mega"] = 1413.28, ["Mega|Ride"] = 1273.13, ["Mega|Fly|Ride"] = 1232.44}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.92, ["Ride"] = 26.25, ["Fly|Ride"] = 288.75, ["Neon"] = 26.25, ["Neon|Ride"] = 58.8, ["Neon|Fly|Ride"] = 305.76, ["Mega"] = 104.97, ["Mega|Ride"] = 156.19, ["Mega|Fly|Ride"] = 330.1}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 6.06, ["Ride"] = 23.15, ["Fly|Ride"] = 103.69, ["Neon"] = 19.69, ["Neon|Ride"] = 49.88, ["Mega"] = 189.65, ["Mega|Ride"] = 282.87}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 11.65, ["Fly"] = 28.88, ["Ride"] = 44.01, ["Fly|Ride"] = 157.5, ["Neon"] = 62.52, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 169.52, ["Mega"] = 254.27, ["Mega|Ride"] = 367.63, ["Mega|Fly|Ride"] = 450.19}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 14.84, ["Fly|Ride"] = 31.4, ["Neon"] = 2.1, ["Neon|Fly"] = 17.05, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 35.35, ["Mega"] = 13.9, ["Mega|Fly"] = 71, ["Mega|Ride"] = 23.98, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 52.42, ["Fly"] = 78.41, ["Ride"] = 65.63, ["Fly|Ride"] = 303.01, ["Neon"] = 232.49, ["Neon|Fly"] = 2401.7, ["Neon|Ride"] = 293.99, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 845.43, ["Mega|Ride"] = 807.19, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 16.96, ["Fly|Ride"] = 110.19, ["Neon"] = 5.98, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 42.95, ["Mega|Fly|Ride"] = 211.91}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.51, ["Ride"] = 16.96, ["Fly|Ride"] = 57.22, ["Neon"] = 13.12, ["Neon|Fly"] = 141.98, ["Neon|Ride"] = 32.43, ["Neon|Fly|Ride"] = 57.21, ["Mega"] = 157.5, ["Mega|Ride"] = 396.24, ["Mega|Fly|Ride"] = 254.27}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 76.13, ["Ride"] = 111.57, ["Fly|Ride"] = 205.22, ["Neon"] = 298.77, ["Neon|Ride"] = 326.82, ["Neon|Fly|Ride"] = 510.57, ["Mega"] = 944.98, ["Mega|Ride"] = 986.33, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 7.88, ["Neon|Ride"] = 42.75, ["Neon|Fly|Ride"] = 84.76, ["Mega"] = 51.19, ["Mega|Ride"] = 110.88, ["Mega|Fly|Ride"] = 275.46}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 14.44}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 28.62, ["Fly|Ride"] = 321.9, ["Neon"] = 9.19, ["Neon|Ride"] = 31.86, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 41.14, ["Mega|Ride"] = 109.73, ["Mega|Fly|Ride"] = 286.06}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 114.44, ["Ride"] = 178.36, ["Fly|Ride"] = 211.91, ["Neon"] = 538.13, ["Neon|Ride"] = 635.66, ["Neon|Fly|Ride"] = 669.57, ["Mega|Fly|Ride"] = 2599.82}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 10.5, ["Ride"] = 26.25, ["Neon"] = 69.92, ["Neon|Ride"] = 61.69, ["Mega"] = 165.32, ["Mega|Ride"] = 314.42, ["Mega|Fly|Ride"] = 420.67}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Neon"] = 4.6, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 36.04, ["Mega|Ride"] = 99.61, ["Mega|Fly|Ride"] = 141.98}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 5.13, ["Ride"] = 28.62, ["Neon"] = 51.1, ["Neon|Ride"] = 113.37, ["Neon|Fly|Ride"] = 156.8, ["Mega"] = 421.66, ["Mega|Ride"] = 565.74, ["Mega|Fly|Ride"] = 629.83}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 15.74, ["Fly"] = 75.24, ["Ride"] = 27.57, ["Fly|Ride"] = 65.63, ["Neon"] = 77.86, ["Neon|Ride"] = 91.12, ["Neon|Fly|Ride"] = 282.87, ["Mega"] = 459.38, ["Mega|Ride"] = 405.57, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 38.06, ["Ride"] = 83.71, ["Fly|Ride"] = 282.87, ["Neon"] = 211.89, ["Neon|Ride"] = 347.5, ["Neon|Fly|Ride"] = 211.89, ["Mega"] = 702.19, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 136.49, ["Fly"] = 189.9, ["Ride"] = 176.82, ["Fly|Ride"] = 203.44, ["Neon"] = 538.12, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 549.93, ["Mega|Fly|Ride"] = 2159.07}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 6.57, ["Fly"] = 19.66, ["Ride"] = 21.2, ["Fly|Ride"] = 47.25, ["Neon"] = 62.52, ["Neon|Fly"] = 423.78, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 91.88, ["Mega|Ride"] = 565.74, ["Mega|Fly|Ride"] = 321.57}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 131.23, ["Ride"] = 31.86, ["Fly|Ride"] = 131.25, ["Neon"] = 39.37, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 192.95, ["Mega"] = 137.81, ["Mega|Ride"] = 127.15, ["Mega|Fly|Ride"] = 423.78}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 23.6, ["Fly"] = 210, ["Ride"] = 42, ["Neon"] = 108.08, ["Neon|Ride"] = 141.98, ["Mega"] = 565.74, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 45.94, ["Fly"] = 113.37, ["Ride"] = 57.75, ["Fly|Ride"] = 211.91, ["Neon"] = 196.88, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 281.81, ["Mega"] = 905.63, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 857.93}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 22.31, ["Ride"] = 81.86, ["Neon"] = 135.62, ["Neon|Ride"] = 126.62, ["Mega"] = 707.7, ["Mega|Ride"] = 707.7, ["Mega|Fly|Ride"] = 985.04}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 301.87, ["Ride"] = 413.44, ["Neon"] = 2401.7, ["Neon|Ride"] = 1115.63, ["Mega|Fly|Ride"] = 4195.3}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 31.86, ["Fly"] = 65.63, ["Ride"] = 34.59, ["Fly|Ride"] = 78.41, ["Neon"] = 282.87, ["Neon|Ride"] = 226.31, ["Neon|Fly|Ride"] = 326.16, ["Mega"] = 984.38, ["Mega|Ride"] = 845.25, ["Mega|Fly|Ride"] = 706.65}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 28.62, ["Ride"] = 16.96, ["Fly|Ride"] = 28.54, ["Neon"] = 2.35, ["Neon|Ride"] = 19.06, ["Neon|Fly|Ride"] = 55.04, ["Mega"] = 22.01, ["Mega|Fly"] = 108.08, ["Mega|Ride"] = 44.35, ["Mega|Fly|Ride"] = 108.94}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.2, ["Ride"] = 211.02, ["Neon"] = 18.88, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 126.97, ["Mega"] = 141.98, ["Mega|Fly"] = 124.69, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 373.42}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 5.15, ["Ride"] = 28.61, ["Fly|Ride"] = 129.94, ["Neon"] = 14.84, ["Neon|Ride"] = 78.26, ["Neon|Fly|Ride"] = 141.98, ["Mega"] = 128.89, ["Mega|Fly"] = 240.51, ["Mega|Ride"] = 282.87, ["Mega|Fly|Ride"] = 250.03}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 360.92, ["Fly"] = 629.83, ["Ride"] = 380.4, ["Fly|Ride"] = 525, ["Neon"] = 2118.84, ["Neon|Fly"] = 2542.61, ["Neon|Ride"] = 1604.02, ["Neon|Fly|Ride"] = 1413.82, ["Mega|Fly|Ride"] = 4873.33}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 4.73, ["Fly"] = 47.59, ["Ride"] = 19.47, ["Fly|Ride"] = 46.64, ["Neon"] = 24.94, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 63.71, ["Mega|Ride"] = 223.12, ["Mega|Fly|Ride"] = 423.78}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 4.85, ["Fly"] = 31.77, ["Ride"] = 21.25, ["Fly|Ride"] = 39.38, ["Neon|Ride"] = 57.22, ["Neon|Fly|Ride"] = 169.52, ["Mega"] = 423.78, ["Mega|Ride"] = 706.65, ["Mega|Fly|Ride"] = 211.91}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.84, ["Fly"] = 36.04, ["Ride"] = 27.56, ["Fly|Ride"] = 65.63, ["Neon"] = 17.07, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 120.74, ["Mega"] = 405.77, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 313.74}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 45.83, ["Fly"] = 210, ["Ride"] = 69.93, ["Fly|Ride"] = 59.07, ["Neon"] = 117.96, ["Neon|Fly|Ride"] = 282.87, ["Mega"] = 656.25, ["Mega|Ride"] = 846.49, ["Mega|Fly|Ride"] = 629.83}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 31.35, ["Ride"] = 28.14, ["Fly|Ride"] = 52.9, ["Neon"] = 18.38, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 210, ["Mega"] = 137.82, ["Mega|Ride"] = 169.52, ["Mega|Fly|Ride"] = 820.98}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 5.81, ["Fly"] = 104.15, ["Ride"] = 26.24, ["Fly|Ride"] = 91.88, ["Neon"] = 153.04, ["Neon|Ride"] = 105.78, ["Mega"] = 706.65, ["Mega|Ride"] = 612.35, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Neon"] = 6.38, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 28.75, ["Mega"] = 36.75, ["Mega|Ride"] = 113.19, ["Mega|Fly|Ride"] = 282.87}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 6.57, ["Ride"] = 57.22, ["Neon"] = 59.07, ["Mega"] = 296.66, ["Mega|Fly|Ride"] = 847.54}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 9.19, ["Ride"] = 47.18, ["Fly|Ride"] = 141.98, ["Neon"] = 79.69, ["Mega"] = 312.55, ["Mega|Ride"] = 559.38, ["Mega|Fly|Ride"] = 1059.43}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 11.21, ["Fly"] = 32.82, ["Ride"] = 32.85, ["Fly|Ride"] = 48.75, ["Neon"] = 31.5, ["Neon|Fly"] = 70.56, ["Neon|Ride"] = 58.42, ["Neon|Fly|Ride"] = 76.13, ["Mega"] = 410.01, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 354.06}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 189.03, ["Fly"] = 205.24, ["Ride"] = 189.62, ["Fly|Ride"] = 203.44, ["Neon"] = 865.7, ["Neon|Ride"] = 871.91, ["Neon|Fly|Ride"] = 850.95, ["Mega|Fly|Ride"] = 4223.9}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Fly"] = 21.19, ["Ride"] = 15.91, ["Fly|Ride"] = 63.71, ["Neon"] = 12.39, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 114.85, ["Mega"] = 220.5, ["Mega|Ride"] = 165.29, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.94, ["Ride"] = 17.07, ["Fly|Ride"] = 117.6, ["Neon"] = 15.75, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 166.69, ["Mega"] = 216.57, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 42.39, ["Ride"] = 105, ["Fly|Ride"] = 529.73, ["Neon"] = 131.25, ["Neon|Ride"] = 204.67, ["Neon|Fly|Ride"] = 469.88, ["Mega"] = 388.5, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 491.54}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 80.01, ["Fly"] = 105.96, ["Ride"] = 135.62, ["Fly|Ride"] = 259.88, ["Neon"] = 494.75, ["Neon|Fly"] = 423.78, ["Neon|Ride"] = 448.19, ["Neon|Fly|Ride"] = 493.7, ["Mega|Ride"] = 1398.44, ["Mega|Fly|Ride"] = 1503.76}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 37.09, ["Ride"] = 124.69, ["Fly|Ride"] = 315, ["Neon"] = 94.9, ["Neon|Ride"] = 150.93, ["Neon|Fly|Ride"] = 280.88, ["Mega"] = 275.36, ["Mega|Ride"] = 321.34, ["Mega|Fly|Ride"] = 437.73}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.22, ["Fly|Ride"] = 47.16, ["Neon"] = 15.91, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 57.46, ["Mega|Ride"] = 184.36, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 10.5, ["Ride"] = 75.24, ["Fly|Ride"] = 9181.96, ["Neon"] = 87.94, ["Neon|Ride"] = 139.86, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 206.87, ["Mega|Ride"] = 263.8, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 77.44, ["Ride"] = 123.37, ["Fly|Ride"] = 216.57, ["Neon"] = 199.5, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 353.85, ["Mega"] = 515.25, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.63, ["Ride"] = 57.75, ["Neon"] = 6.96, ["Neon|Ride"] = 104.76, ["Neon|Fly|Ride"] = 141.98, ["Mega"] = 32.82, ["Mega|Fly"] = 163.16, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 316.79}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 11.82, ["Ride"] = 235.9, ["Neon"] = 72.19, ["Neon|Ride"] = 211.91, ["Mega"] = 360.59, ["Mega|Fly|Ride"] = 587.99}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 971.25, ["Fly"] = 1245.47, ["Ride"] = 1053.76, ["Fly|Ride"] = 1185.07, ["Neon"] = 3284.21, ["Neon|Ride"] = 3390.14, ["Neon|Fly|Ride"] = 2953.13, ["Mega|Fly|Ride"] = 11090.63}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 43.32, ["Ride"] = 98.44, ["Neon"] = 169.52, ["Neon|Ride"] = 531.57, ["Mega"] = 847.54, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 13.13, ["Fly"] = 49.12, ["Ride"] = 36.04, ["Fly|Ride"] = 99.75, ["Neon"] = 28.62, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 48.75, ["Neon|Fly|Ride"] = 99.61, ["Mega"] = 105.92, ["Mega|Ride"] = 141.98, ["Mega|Fly|Ride"] = 289.78}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 14.44, ["Ride"] = 131.22, ["Neon"] = 101.07, ["Mega"] = 367.63, ["Mega|Ride"] = 419.54}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Fly"] = 21.2, ["Ride"] = 35.44, ["Fly|Ride"] = 423.78, ["Neon"] = 2.61, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 100.64, ["Mega"] = 19.69, ["Mega|Fly"] = 126.09, ["Mega|Ride"] = 53.43, ["Mega|Fly|Ride"] = 209.77}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 77.44, ["Ride"] = 130.93, ["Fly|Ride"] = 345.39, ["Neon"] = 297.42, ["Neon|Ride"] = 341.57, ["Neon|Fly|Ride"] = 483.94, ["Mega"] = 1058.77, ["Mega|Ride"] = 958.12, ["Mega|Fly|Ride"] = 1049.9}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 4.76, ["Fly"] = 101.07, ["Ride"] = 52.5, ["Fly|Ride"] = 75.23, ["Neon"] = 35.17, ["Neon|Ride"] = 84.76, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 353.85, ["Mega|Ride"] = 294.79, ["Mega|Fly|Ride"] = 317.63}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.86, ["Ride"] = 25.59, ["Neon"] = 17.07, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 141.98, ["Mega"] = 147, ["Mega|Ride"] = 232.03, ["Mega|Fly|Ride"] = 375.04}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 52.5, ["Ride"] = 97.13, ["Fly|Ride"] = 156.8, ["Neon"] = 157.5, ["Neon|Fly"] = 280.65, ["Neon|Ride"] = 233.54, ["Neon|Fly|Ride"] = 635.66, ["Mega"] = 535.5, ["Mega|Ride"] = 509.78, ["Mega|Fly|Ride"] = 733.14}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 26.25, ["Ride"] = 99.75, ["Fly|Ride"] = 196.88, ["Neon"] = 90.57, ["Neon|Ride"] = 211.91, ["Neon|Fly|Ride"] = 315, ["Mega"] = 624.75, ["Mega|Ride"] = 676.99, ["Mega|Fly|Ride"] = 1090.46}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 49.88, ["Ride"] = 99.61, ["Neon"] = 774.38, ["Neon|Ride"] = 565.74, ["Neon|Fly|Ride"] = 952.23, ["Mega"] = 2472.69, ["Mega|Ride"] = 1822.22, ["Mega|Fly|Ride"] = 2118.84}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 10.49, ["Ride"] = 62.35, ["Neon"] = 30.74, ["Neon|Ride"] = 105.96, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 112.9, ["Mega|Ride"] = 134.67, ["Mega|Fly|Ride"] = 282.87}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 8.38, ["Fly"] = 33.92, ["Ride"] = 28.62, ["Fly|Ride"] = 57.22, ["Neon"] = 63.71, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 134.47, ["Mega"] = 399, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 458.32}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 137.82, ["Ride"] = 171.93, ["Fly|Ride"] = 236.29, ["Neon"] = 541, ["Neon|Fly"] = 511.88, ["Neon|Ride"] = 533.96, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly"] = 2825.47, ["Mega|Ride"] = 2260.81, ["Mega|Fly|Ride"] = 1785}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 18.88, ["Ride"] = 15.9, ["Fly|Ride"] = 37.83, ["Neon"] = 21.2, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 27.2, ["Neon|Fly|Ride"] = 71, ["Mega"] = 131.25, ["Mega|Ride"] = 141.86, ["Mega|Fly|Ride"] = 211.91}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 6.57, ["Fly"] = 87.94, ["Ride"] = 23.62, ["Fly|Ride"] = 67.82, ["Neon"] = 31.5, ["Neon|Fly"] = 281.17, ["Neon|Ride"] = 42.37, ["Neon|Fly|Ride"] = 126.09, ["Mega"] = 144.38, ["Mega|Ride"] = 202.92, ["Mega|Fly|Ride"] = 286.47}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Ride"] = 16.96, ["Fly|Ride"] = 35.86, ["Neon"] = 2.63, ["Neon|Fly"] = 17.75, ["Neon|Ride"] = 20.11, ["Neon|Fly|Ride"] = 48.56, ["Mega"] = 14.18, ["Mega|Ride"] = 31.49, ["Mega|Fly|Ride"] = 89.25}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Fly"] = 21.2, ["Ride"] = 31.8, ["Neon"] = 3.93, ["Neon|Fly"] = 42.39, ["Mega"] = 23.63, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 141.98}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 3.92, ["Fly"] = 131.25, ["Ride"] = 72.07, ["Fly|Ride"] = 45.94, ["Neon"] = 15.1, ["Neon|Ride"] = 92.54, ["Mega"] = 134.56, ["Mega|Ride"] = 152.3}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 57.07, ["Ride"] = 105, ["Neon"] = 226.73, ["Neon|Ride"] = 451.5, ["Neon|Fly|Ride"] = 630, ["Mega"] = 564.8, ["Mega|Ride"] = 565.74, ["Mega|Fly|Ride"] = 664.27}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.63, ["Fly"] = 18.9, ["Ride"] = 19, ["Fly|Ride"] = 42.48, ["Neon"] = 9.97, ["Neon|Fly"] = 28.3, ["Neon|Ride"] = 28.61, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 91.49, ["Mega|Fly"] = 212.31, ["Mega|Ride"] = 112.87, ["Mega|Fly|Ride"] = 176.21}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 3.49, ["Fly"] = 37.09, ["Ride"] = 25.44, ["Fly|Ride"] = 43.32, ["Neon"] = 19.69, ["Neon|Fly"] = 94.37, ["Neon|Ride"] = 35.7, ["Neon|Fly|Ride"] = 78.56, ["Mega"] = 126, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 131.23, ["Mega|Fly|Ride"] = 204}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 3.82, ["Fly"] = 21, ["Ride"] = 19.69, ["Fly|Ride"] = 98.44, ["Neon"] = 8.48, ["Neon|Fly"] = 47.19, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 105.95, ["Mega"] = 40.27, ["Mega|Ride"] = 59.06, ["Mega|Fly|Ride"] = 119.9}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 11.82, ["Fly"] = 281.81, ["Ride"] = 24.83, ["Neon"] = 31.5, ["Neon|Ride"] = 83.69, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 299.59, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 254.27, ["Mega|Fly|Ride"] = 629.83}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 7.82, ["Fly"] = 154.69, ["Ride"] = 49.87, ["Neon"] = 99.75, ["Neon|Ride"] = 78.73, ["Mega"] = 262.5, ["Mega|Ride"] = 565.74, ["Mega|Fly|Ride"] = 311.37}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 5.25, ["Fly"] = 30.74, ["Ride"] = 17.71, ["Fly|Ride"] = 47.25, ["Neon"] = 33.92, ["Neon|Fly"] = 196.65, ["Neon|Ride"] = 47.18, ["Neon|Fly|Ride"] = 126.09, ["Mega"] = 220.38, ["Mega|Ride"] = 211.56, ["Mega|Fly|Ride"] = 342.22}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 33.92, ["Ride"] = 17.83, ["Fly|Ride"] = 52.5, ["Neon"] = 15.75, ["Neon|Fly"] = 37.09, ["Neon|Ride"] = 42.39, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 141.54, ["Mega|Ride"] = 234.72, ["Mega|Fly|Ride"] = 198.13}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 196.88, ["Fly"] = 393.75, ["Ride"] = 221.76, ["Fly|Ride"] = 305.82, ["Neon"] = 984.38, ["Neon|Ride"] = 843.31, ["Neon|Fly|Ride"] = 1179.94, ["Mega|Ride"] = 3533.17, ["Mega|Fly|Ride"] = 3155.25}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 4.64, ["Ride"] = 30.68, ["Neon"] = 30.66, ["Neon|Fly|Ride"] = 282.87, ["Mega"] = 123.38, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 494.75}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.52, ["Ride"] = 21.17, ["Fly|Ride"] = 118.13, ["Neon"] = 28.62, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 35.89, ["Neon|Fly|Ride"] = 139.65, ["Mega"] = 184.36, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 1179.44}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 9.19, ["Fly|Ride"] = 158.06, ["Neon"] = 40.68, ["Neon|Fly|Ride"] = 94.37, ["Mega"] = 470.08, ["Mega|Fly|Ride"] = 1033.6}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.9, ["Fly|Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Fly"] = 21.2, ["Neon|Ride"] = 15.73, ["Neon|Fly|Ride"] = 36.04, ["Mega"] = 28.62, ["Mega|Fly"] = 71, ["Mega|Ride"] = 28.62, ["Mega|Fly|Ride"] = 82.65}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 56.37, ["Ride"] = 21.19, ["Fly|Ride"] = 56.44, ["Neon"] = 23.3, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 83.71, ["Mega"] = 131.6, ["Mega|Ride"] = 142.96, ["Mega|Fly|Ride"] = 292.42}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 4.25, ["Ride"] = 55.11, ["Fly|Ride"] = 77.44, ["Neon"] = 15.73, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 65.63, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 184.36}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 68.25, ["Fly"] = 102.62, ["Ride"] = 105.95, ["Fly|Ride"] = 149.7, ["Neon"] = 423.78, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 455.44, ["Mega|Ride"] = 3533.17, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 5.18, ["Fly"] = 99.61, ["Ride"] = 33.91, ["Fly|Ride"] = 65.63, ["Neon"] = 23.61, ["Neon|Ride"] = 57.22, ["Neon|Fly|Ride"] = 135.64, ["Mega"] = 216.14, ["Mega|Ride"] = 211.91, ["Mega|Fly|Ride"] = 671.68}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.63, ["Fly"] = 31.8, ["Ride"] = 52.5, ["Fly|Ride"] = 165.29, ["Neon"] = 15.23, ["Neon|Ride"] = 57.22, ["Neon|Fly|Ride"] = 169.52, ["Mega"] = 79.04, ["Mega|Fly"] = 413.19, ["Mega|Fly|Ride"] = 240.51}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 57.23, ["Fly"] = 124.69, ["Ride"] = 97.13, ["Fly|Ride"] = 282.87, ["Neon"] = 141.39, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 325.26, ["Mega"] = 593.29, ["Mega|Ride"] = 706.65, ["Mega|Fly|Ride"] = 614.25}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Ride"] = 13.13, ["Fly|Ride"] = 37.09, ["Neon"] = 2.1, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 16.96, ["Neon|Fly|Ride"] = 32.85, ["Mega"] = 23.37, ["Mega|Fly"] = 42.39, ["Mega|Ride"] = 38.27, ["Mega|Fly|Ride"] = 80.07}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 6.57, ["Neon|Ride"] = 36.04, ["Neon|Fly|Ride"] = 71.1, ["Mega"] = 28.61, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 173.32}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 5.25, ["Ride"] = 107.63, ["Neon"] = 15.91, ["Neon|Ride"] = 66.76, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 65.56, ["Mega|Ride"] = 136.66}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 11.67, ["Fly"] = 57.75, ["Ride"] = 57.22, ["Fly|Ride"] = 126.11, ["Neon"] = 25.96, ["Neon|Fly"] = 129.94, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 101.05, ["Mega|Fly"] = 209.48, ["Mega|Ride"] = 117.94, ["Mega|Fly|Ride"] = 252.41}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 15.75, ["Fly|Ride"] = 36.58, ["Neon"] = 2.63, ["Neon|Fly"] = 28.32, ["Neon|Ride"] = 35.4, ["Neon|Fly|Ride"] = 63.58, ["Mega"] = 15.81, ["Mega|Ride"] = 41.33, ["Mega|Fly|Ride"] = 103.69}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 11.54, ["Ride"] = 27.57, ["Fly|Ride"] = 200.48, ["Neon"] = 70.88, ["Neon|Ride"] = 167.41, ["Neon|Fly|Ride"] = 196.23, ["Mega"] = 247.92, ["Mega|Ride"] = 489.47, ["Mega|Fly|Ride"] = 396.24}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2730, ["Fly"] = 3150, ["Ride"] = 2625, ["Fly|Ride"] = 2666.96, ["Neon|Fly"] = 9533.69, ["Neon|Fly|Ride"] = 9318.75, ["Mega|Fly|Ride"] = 43965.72}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 20.9, ["Fly|Ride"] = 62.52, ["Neon"] = 11.67, ["Neon|Fly"] = 68.87, ["Neon|Ride"] = 23.57, ["Neon|Fly|Ride"] = 66.94, ["Mega"] = 73.48, ["Mega|Fly"] = 113.37, ["Mega|Ride"] = 99.05, ["Mega|Fly|Ride"] = 157.31}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.61, ["Fly|Ride"] = 74.82, ["Neon"] = 13.13, ["Mega"] = 126, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 635.66}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 18.38, ["Ride"] = 28.82, ["Fly|Ride"] = 157.5, ["Neon"] = 95.62, ["Neon|Ride"] = 197.06, ["Neon|Fly|Ride"] = 262.75, ["Mega"] = 471.78, ["Mega|Ride"] = 397.69, ["Mega|Fly|Ride"] = 360.94}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 38, ["Ride"] = 193.44, ["Neon"] = 150.94, ["Neon|Ride"] = 389.88, ["Neon|Fly|Ride"] = 423.78, ["Mega"] = 540.75, ["Mega|Ride"] = 730.08, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 144.38, ["Fly"] = 282.87, ["Ride"] = 183.75, ["Fly|Ride"] = 203.44, ["Neon"] = 740.55, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 717.59, ["Mega"] = 6356.51, ["Mega|Ride"] = 3037.35, ["Mega|Fly|Ride"] = 2362.5}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 6.57, ["Ride"] = 52.5, ["Fly|Ride"] = 675.94, ["Neon"] = 19.48, ["Neon|Fly"] = 71, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 99.61, ["Mega"] = 223.13, ["Mega|Fly"] = 174.57, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 188.72}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 10.61, ["Neon|Fly"] = 99.61, ["Neon|Ride"] = 42.39, ["Mega"] = 82.65, ["Mega|Ride"] = 261.03, ["Mega|Fly|Ride"] = 838.31}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.63, ["Ride"] = 31.86, ["Fly|Ride"] = 131.25, ["Neon"] = 10.5, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 158.06, ["Mega"] = 84, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 269.1}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 26.25, ["Fly|Ride"] = 656.25, ["Neon|Ride"] = 1554.18, ["Neon|Fly|Ride"] = 240.51, ["Mega"] = 476.42, ["Mega|Ride"] = 423.78, ["Mega|Fly|Ride"] = 524.43}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 71, ["Neon"] = 2.1, ["Neon|Ride"] = 57.66, ["Mega"] = 18.38, ["Mega|Ride"] = 57.22, ["Mega|Fly|Ride"] = 282.87}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 82.69, ["Ride"] = 127.15, ["Fly|Ride"] = 137.82, ["Neon"] = 324.2, ["Neon|Ride"] = 409.5, ["Neon|Fly|Ride"] = 418.69, ["Mega"] = 1365, ["Mega|Fly|Ride"] = 1361.07}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 32.65, ["Neon"] = 6.36, ["Neon|Ride"] = 104.89, ["Mega"] = 54.05, ["Mega|Ride"] = 126}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 39.38, ["Fly"] = 72.19, ["Ride"] = 72.07, ["Fly|Ride"] = 129.93, ["Neon"] = 295.32, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 620.84, ["Mega"] = 2625, ["Mega|Ride"] = 1353.98, ["Mega|Fly|Ride"] = 1156.32}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 33.92, ["Ride"] = 24.38, ["Fly|Ride"] = 49.88, ["Neon"] = 4.17, ["Neon|Fly"] = 121.85, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 42, ["Mega|Ride"] = 69.93, ["Mega|Fly|Ride"] = 123.98}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 3.94, ["Neon"] = 13.13, ["Neon|Ride"] = 113.37, ["Mega"] = 72.19, ["Mega|Fly|Ride"] = 544.56}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 11.82, ["Ride"] = 28.32, ["Fly|Ride"] = 210.83, ["Neon"] = 63.71, ["Neon|Ride"] = 141.98, ["Mega"] = 198.68, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 565.74}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 388.23, ["Ride"] = 431.74, ["Fly|Ride"] = 498.36, ["Neon"] = 1114.31, ["Neon|Ride"] = 1240.3, ["Neon|Fly|Ride"] = 1332.19, ["Mega"] = 4394.46, ["Mega|Ride"] = 3885, ["Mega|Fly|Ride"] = 3543.75}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 37.8, ["Fly"] = 57.22, ["Ride"] = 52.99, ["Fly|Ride"] = 64.32, ["Neon"] = 141.98, ["Neon|Fly"] = 314.92, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 198.19, ["Mega"] = 702.41, ["Mega|Ride"] = 698.17, ["Mega|Fly|Ride"] = 706.65}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 24.13, ["Ride"] = 21.19, ["Fly|Ride"] = 72.19, ["Neon"] = 6.56, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 24.36, ["Neon|Fly|Ride"] = 92.07, ["Mega"] = 74.18, ["Mega|Ride"] = 70.86, ["Mega|Fly|Ride"] = 449.22}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 15.75, ["Fly"] = 110.18, ["Ride"] = 36.04, ["Fly|Ride"] = 99.61, ["Neon"] = 45.93, ["Neon|Fly"] = 198.13, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 150.15, ["Mega"] = 227.07, ["Mega|Fly"] = 396.24, ["Mega|Ride"] = 258.11, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 8.67, ["Ride"] = 28.62, ["Fly|Ride"] = 71, ["Neon"] = 84, ["Neon|Ride"] = 122.91, ["Mega|Ride"] = 471.32, ["Mega|Fly|Ride"] = 423.78}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.94, ["Ride"] = 23.33, ["Neon"] = 18.98, ["Neon|Fly|Ride"] = 169.52, ["Mega"] = 51.19, ["Mega|Ride"] = 122.68, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 86.63, ["Ride"] = 19.08, ["Fly|Ride"] = 69.93, ["Neon"] = 26.25, ["Neon|Ride"] = 42.39, ["Neon|Fly|Ride"] = 216.14, ["Mega"] = 550.8, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 494.75}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 94.5, ["Fly"] = 131.25, ["Ride"] = 121.96, ["Fly|Ride"] = 183.75, ["Neon"] = 537.14, ["Neon|Ride"] = 615.56, ["Neon|Fly|Ride"] = 592.23, ["Mega"] = 2512.95, ["Mega|Ride"] = 2571.21, ["Mega|Fly|Ride"] = 2994.98}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 31.5, ["Fly"] = 95.82, ["Ride"] = 78.41, ["Fly|Ride"] = 147.27, ["Neon"] = 192.94, ["Neon|Ride"] = 177.99, ["Mega"] = 705.58, ["Mega|Ride"] = 706.65, ["Mega|Fly|Ride"] = 847.54}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2362.5, ["Ride"] = 2165.63, ["Fly|Ride"] = 2312.64, ["Neon"] = 12713, ["Neon|Fly|Ride"] = 7412.56, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.68, ["Fly"] = 65625, ["Ride"] = 41.89, ["Fly|Ride"] = 170.63, ["Neon"] = 16.96, ["Neon|Ride"] = 36.04, ["Neon|Fly|Ride"] = 169.32, ["Mega"] = 114.83, ["Mega|Ride"] = 167.35, ["Mega|Fly|Ride"] = 317.84}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 26.25, ["Ride"] = 65.63, ["Neon"] = 88.45, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 255.94, ["Mega|Ride"] = 495.83, ["Mega|Fly|Ride"] = 565.74}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 971.25, ["Fly"] = 1413.28, ["Ride"] = 904.32, ["Fly|Ride"] = 984.38, ["Neon"] = 2598.75, ["Neon|Ride"] = 2493.75, ["Neon|Fly|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 12156.25}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 52.49, ["Ride"] = 66.09, ["Fly|Ride"] = 262.5, ["Neon"] = 254.26, ["Neon|Ride"] = 291.72, ["Mega"] = 762.8, ["Mega|Ride"] = 804.56, ["Mega|Fly|Ride"] = 741.61}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 6.57, ["Ride"] = 23.63, ["Fly|Ride"] = 64.32, ["Neon"] = 15.75, ["Neon|Ride"] = 471.78, ["Neon|Fly|Ride"] = 141.54, ["Mega"] = 133.5, ["Mega|Fly|Ride"] = 278.25}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Neon"] = 6.38, ["Neon|Ride"] = 57.11, ["Mega"] = 27.57, ["Mega|Ride"] = 67.82, ["Mega|Fly|Ride"] = 134.56}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 99.38, ["Ride"] = 125.99, ["Fly|Ride"] = 141.98, ["Neon"] = 459.38, ["Neon|Ride"] = 441.12, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 2673.76}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 6.45, ["Ride"] = 57.22, ["Neon"] = 28.32, ["Neon|Ride"] = 141.98}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 91.87, ["Ride"] = 131.38, ["Neon"] = 515.95, ["Neon|Ride"] = 449.22, ["Mega|Fly|Ride"] = 1735.12}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 6.57, ["Fly"] = 105, ["Fly|Ride"] = 91.88, ["Neon"] = 33.16, ["Neon|Fly|Ride"] = 315, ["Mega"] = 226.73, ["Mega|Ride"] = 169.52, ["Mega|Fly|Ride"] = 282.87}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 255.5, ["Ride"] = 273.99, ["Fly|Ride"] = 328.13, ["Neon"] = 1006.46, ["Neon|Fly"] = 1101.59, ["Neon|Ride"] = 1003.29, ["Neon|Fly|Ride"] = 1005.82, ["Mega|Fly|Ride"] = 4017.32}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.92, ["Fly"] = 87.57, ["Ride"] = 23.61, ["Fly|Ride"] = 71, ["Neon"] = 37.09, ["Neon|Ride"] = 69.77, ["Neon|Fly|Ride"] = 113.37, ["Mega"] = 250.04, ["Mega|Ride"] = 325.26, ["Mega|Fly|Ride"] = 442.09}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 18.14, ["Ride"] = 16.96, ["Fly|Ride"] = 31.86, ["Neon"] = 3.94, ["Neon|Fly"] = 25.44, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 60.4, ["Mega"] = 57.75, ["Mega|Fly"] = 104.87, ["Mega|Ride"] = 79.02, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 832.12, ["Fly"] = 1179.44, ["Ride"] = 903, ["Fly|Ride"] = 1040.81, ["Neon|Ride"] = 4953.56, ["Neon|Fly|Ride"] = 4237.67, ["Mega"] = 28306}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 6.57, ["Fly"] = 989.5, ["Ride"] = 210, ["Neon"] = 39.38, ["Neon|Ride"] = 57.21, ["Mega"] = 160.57, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 370.79}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 9.45, ["Fly"] = 32.82, ["Ride"] = 63.58, ["Neon"] = 26.25, ["Neon|Fly"] = 105.96, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 138.41, ["Mega"] = 185.05, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 280.35}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 38.06, ["Fly"] = 40.52, ["Ride"] = 32.87, ["Fly|Ride"] = 45.93, ["Neon|Ride"] = 176.64, ["Neon|Fly|Ride"] = 196.86, ["Mega"] = 2118.84, ["Mega|Fly|Ride"] = 696.48}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 30.68, ["Fly"] = 79.48, ["Ride"] = 35.44, ["Fly|Ride"] = 86.63, ["Neon"] = 47.25, ["Neon|Ride"] = 79.04, ["Neon|Fly|Ride"] = 99.61, ["Mega"] = 364.88, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 443.62}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 20.98, ["Ride"] = 190.32, ["Fly|Ride"] = 112.88, ["Neon"] = 91.12, ["Neon|Ride"] = 211.91, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 486.18, ["Mega|Ride"] = 466.15, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Fly"] = 63.58, ["Ride"] = 116.59, ["Fly|Ride"] = 235.9, ["Neon"] = 2.63, ["Neon|Ride"] = 31.8, ["Mega"] = 21, ["Mega|Fly"] = 84.93, ["Mega|Ride"] = 141.98}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 32.42, ["Fly"] = 74.82, ["Ride"] = 49.81, ["Fly|Ride"] = 96.42, ["Neon"] = 180.12, ["Neon|Fly"] = 308.31, ["Neon|Ride"] = 236.2, ["Neon|Fly|Ride"] = 242.82, ["Mega"] = 3390.14, ["Mega|Fly|Ride"] = 997.29}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 3.92, ["Fly"] = 89.65, ["Ride"] = 19.65, ["Fly|Ride"] = 65.63, ["Neon"] = 42.39, ["Neon|Ride"] = 141.07, ["Neon|Fly|Ride"] = 141.98, ["Mega"] = 773.07, ["Mega|Ride"] = 272.35}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 26.16, ["Ride"] = 20.01, ["Fly|Ride"] = 36.75, ["Neon"] = 14.44, ["Neon|Ride"] = 42.39, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 1058.37, ["Mega|Ride"] = 282.87, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 5.17, ["Ride"] = 103.69, ["Neon"] = 28.61, ["Neon|Fly|Ride"] = 105.96, ["Mega"] = 296.66, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 471.78}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 22.3, ["Fly"] = 262.13, ["Ride"] = 32.82, ["Fly|Ride"] = 262.5, ["Neon"] = 116.81, ["Neon|Fly"] = 312.55, ["Neon|Ride"] = 174.57, ["Neon|Fly|Ride"] = 228.85, ["Mega"] = 656.25, ["Mega|Ride"] = 614.48, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 3.93, ["Ride"] = 98.44, ["Neon"] = 23.62, ["Neon|Ride"] = 74.18, ["Neon|Fly|Ride"] = 113.37, ["Mega"] = 104.89, ["Mega|Ride"] = 143.04, ["Mega|Fly|Ride"] = 314.92}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 2.37, ["Neon|Ride"] = 26.25, ["Mega"] = 18.36, ["Mega|Ride"] = 52.38, ["Mega|Fly|Ride"] = 202.79}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Fly|Ride"] = 82.52, ["Neon"] = 2.1, ["Neon|Fly"] = 393.59, ["Neon|Ride"] = 28.51, ["Neon|Fly|Ride"] = 177.99, ["Mega"] = 19.67, ["Mega|Fly"] = 73.86, ["Mega|Ride"] = 40.11, ["Mega|Fly|Ride"] = 107.63}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 25.89, ["Ride"] = 16.96, ["Fly|Ride"] = 47.16, ["Neon"] = 8.49, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 84.93, ["Mega"] = 97.91, ["Mega|Ride"] = 158.06, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.58, ["Fly|Ride"] = 57.22, ["Neon"] = 15.91, ["Neon|Ride"] = 1312.5, ["Mega"] = 105, ["Mega|Ride"] = 144.1, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 17.07, ["Fly|Ride"] = 40.6, ["Neon"] = 13.65, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 57.22, ["Mega"] = 282.85, ["Mega|Ride"] = 236.24, ["Mega|Fly|Ride"] = 364.23}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 76.13, ["Fly|Ride"] = 396.24, ["Neon"] = 197.06, ["Neon|Ride"] = 298.91, ["Neon|Fly|Ride"] = 1059.43, ["Mega"] = 1056.24, ["Mega|Fly"] = 1003.29, ["Mega|Ride"] = 845.4, ["Mega|Fly|Ride"] = 952.43}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 22.32, ["Ride"] = 21.2, ["Fly|Ride"] = 25.44, ["Neon"] = 3.92, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 54.03, ["Mega"] = 41.21, ["Mega|Ride"] = 53.16, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 8.39, ["Fly"] = 62.91, ["Ride"] = 56.49, ["Fly|Ride"] = 71, ["Neon"] = 45.56, ["Neon|Fly"] = 71, ["Neon|Ride"] = 57, ["Neon|Fly|Ride"] = 109.1, ["Mega"] = 471.78, ["Mega|Ride"] = 239.04, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 16.94, ["Fly"] = 42.39, ["Ride"] = 31.33, ["Fly|Ride"] = 70.97, ["Neon"] = 72.02, ["Neon|Fly"] = 127.15, ["Neon|Ride"] = 79.04, ["Neon|Fly|Ride"] = 120.75, ["Mega"] = 410.01, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 390}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.94, ["Fly"] = 140.44, ["Ride"] = 47.18, ["Neon"] = 30.75, ["Neon|Ride"] = 71, ["Mega"] = 196.87, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 353.85}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 18.38, ["Fly|Ride"] = 42.39, ["Neon"] = 3.92, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 45.91, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 120.79}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.94, ["Fly"] = 78.07, ["Ride"] = 28.61, ["Fly|Ride"] = 141.39, ["Neon"] = 18.38, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 100.64, ["Neon|Fly|Ride"] = 158.93, ["Mega"] = 126, ["Mega|Fly"] = 735, ["Mega|Ride"] = 156.66, ["Mega|Fly|Ride"] = 282.87}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 1021.21, ["Fly"] = 1050, ["Ride"] = 1066.9, ["Fly|Ride"] = 1115.63, ["Neon"] = 2428.13, ["Neon|Fly"] = 2896.45, ["Neon|Ride"] = 2879.5, ["Neon|Fly|Ride"] = 2336.25, ["Mega|Fly|Ride"] = 7434}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 65.63, ["Ride"] = 112.63, ["Neon"] = 260.24, ["Neon|Ride"] = 277.58, ["Neon|Fly|Ride"] = 296.66, ["Mega"] = 1367.72, ["Mega|Ride"] = 1356.07, ["Mega|Fly|Ride"] = 1286.25}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly"] = 74.18, ["Ride"] = 68.39, ["Neon"] = 5.16, ["Neon|Ride"] = 75.08, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 69.82, ["Mega|Fly|Ride"] = 184.36}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 32.82, ["Ride"] = 58.62, ["Fly|Ride"] = 141.75, ["Neon"] = 179.03, ["Neon|Ride"] = 196.97, ["Neon|Fly|Ride"] = 279.57, ["Mega"] = 1258.45, ["Mega|Ride"] = 984.38, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 15.75, ["Ride"] = 27.57, ["Fly|Ride"] = 281.81, ["Neon"] = 117.41, ["Neon|Ride"] = 72.07, ["Neon|Fly|Ride"] = 282.87, ["Mega"] = 480.99, ["Mega|Fly|Ride"] = 1059.43}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 258.61, ["Fly"] = 317.84, ["Ride"] = 286.37, ["Fly|Ride"] = 334.38, ["Neon"] = 984.38, ["Neon|Ride"] = 1257.54, ["Neon|Fly|Ride"] = 1110.38, ["Mega|Fly|Ride"] = 4362.68}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.63, ["Fly"] = 102.37, ["Ride"] = 22.32, ["Fly|Ride"] = 129.93, ["Neon"] = 19.69, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 400.47, ["Mega|Fly"] = 282.87}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 26.24, ["Neon|Ride"] = 141.98}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 61.67, ["Ride"] = 118.13, ["Fly|Ride"] = 282.96, ["Neon"] = 131.25, ["Neon|Ride"] = 410.82, ["Neon|Fly|Ride"] = 401.63, ["Mega"] = 1103.55, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 771.1}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 48.54, ["Neon"] = 13.13, ["Neon|Ride"] = 42.39, ["Mega"] = 224.62, ["Mega|Ride"] = 471.78, ["Mega|Fly|Ride"] = 211.91}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 15.73, ["Fly|Ride"] = 27.81, ["Neon"] = 3.68, ["Neon|Fly"] = 31.69, ["Neon|Ride"] = 23.3, ["Neon|Fly|Ride"] = 42.39, ["Mega"] = 26.57, ["Mega|Fly"] = 63.71, ["Mega|Ride"] = 41.33, ["Mega|Fly|Ride"] = 97.91}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4329.94, ["Ride"] = 4331.25, ["Fly|Ride"] = 4199.99, ["Neon"] = 26415.46, ["Neon|Fly|Ride"] = 21359.63, ["Mega|Fly|Ride"] = 52970.74}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 11.65, ["Ride"] = 33.92, ["Neon"] = 78.75, ["Neon|Ride"] = 44.63, ["Mega"] = 465.94, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 3.94, ["Fly"] = 19.08, ["Ride"] = 21.19, ["Fly|Ride"] = 44.63, ["Neon"] = 15.75, ["Neon|Ride"] = 28.62, ["Neon|Fly|Ride"] = 66.76, ["Mega"] = 211.91, ["Mega|Ride"] = 132.83, ["Mega|Fly|Ride"] = 211.61}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 433.13, ["Fly"] = 494.75, ["Ride"] = 454.06, ["Fly|Ride"] = 525.75, ["Neon"] = 1312.5, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1530.9, ["Mega|Fly|Ride"] = 5598.7}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 6.41, ["Ride"] = 28.62, ["Neon"] = 17.07, ["Neon|Ride"] = 158.06, ["Mega"] = 141.98, ["Mega|Fly|Ride"] = 690.38}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 8.49, ["Fly"] = 115.92, ["Ride"] = 158.06, ["Neon"] = 94.35, ["Neon|Ride"] = 141.98, ["Neon|Fly|Ride"] = 14126.23, ["Mega"] = 282.87, ["Mega|Ride"] = 401.63}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.63, ["Ride"] = 24.38, ["Fly|Ride"] = 82.55, ["Neon"] = 8.49, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 39.37, ["Mega|Ride"] = 69.93, ["Mega|Fly|Ride"] = 163.16}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 630, ["Ride"] = 621.68, ["Fly|Ride"] = 676.72, ["Neon"] = 2500.23, ["Neon|Fly|Ride"] = 1966.02, ["Mega|Fly|Ride"] = 8751.75}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 5.25, ["Ride"] = 89.65, ["Neon"] = 23.63, ["Neon|Ride"] = 99.61, ["Neon|Fly|Ride"] = 648.38, ["Mega"] = 126, ["Mega|Ride"] = 212.56, ["Mega|Fly|Ride"] = 294.27}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 15.49, ["Fly"] = 235.94, ["Ride"] = 45.91, ["Fly|Ride"] = 150.94, ["Neon"] = 43.31, ["Neon|Ride"] = 63.58, ["Neon|Fly|Ride"] = 141.98, ["Mega"] = 215.25, ["Mega|Ride"] = 227.67, ["Mega|Fly|Ride"] = 338.76}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 3.94, ["Fly"] = 28.54, ["Ride"] = 21.2, ["Fly|Ride"] = 40.69, ["Neon"] = 11.8, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 63.58, ["Mega"] = 208.69, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 28.88, ["Ride"] = 57.22, ["Neon"] = 78.69, ["Neon|Fly"] = 170.63, ["Neon|Ride"] = 127.15, ["Neon|Fly|Ride"] = 314.92, ["Mega"] = 562.56, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 529.73}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 39.37, ["Neon"] = 3.29, ["Neon|Ride"] = 54.54, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 31.5, ["Mega|Ride"] = 82.58, ["Mega|Fly|Ride"] = 209.43}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 419.99, ["Ride"] = 452.82, ["Fly|Ride"] = 629.83, ["Neon"] = 2330.72, ["Neon|Ride"] = 2326.49, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Ride"] = 9199.45, ["Mega|Fly|Ride"] = 7848.75}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 42.39, ["Neon"] = 7.88, ["Neon|Ride"] = 42.39, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 65.63, ["Mega|Ride"] = 133.5, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 27.36, ["Neon"] = 3.94, ["Neon|Fly"] = 71, ["Neon|Ride"] = 212.31, ["Neon|Fly|Ride"] = 141.98, ["Mega"] = 40.27, ["Mega|Fly"] = 82.65, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 210.83}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 4.6, ["Neon|Ride"] = 45.91, ["Mega"] = 34.13, ["Mega|Fly"] = 156.8, ["Mega|Ride"] = 92.19}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 3.4, ["Ride"] = 131.25, ["Neon"] = 17.07, ["Neon|Ride"] = 71, ["Mega"] = 112.06, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 48.06, ["Ride"] = 78.37, ["Fly|Ride"] = 198.13, ["Neon"] = 233.62, ["Neon|Ride"] = 254.27, ["Neon|Fly|Ride"] = 353.85, ["Mega"] = 525, ["Mega|Ride"] = 465.93, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 26.21, ["Fly"] = 69.47, ["Ride"] = 64.32, ["Neon"] = 104.03, ["Neon|Ride"] = 156.8, ["Mega"] = 381.41, ["Mega|Ride"] = 441.24, ["Mega|Fly|Ride"] = 499.05}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 3.94, ["Fly"] = 34.65, ["Ride"] = 16.92, ["Fly|Ride"] = 40.82, ["Neon"] = 27.56, ["Neon|Fly"] = 63.58, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 75.1, ["Mega"] = 394.42, ["Mega|Ride"] = 238.04, ["Mega|Fly|Ride"] = 246.47}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 62.52, ["Ride"] = 64.32, ["Fly|Ride"] = 113.24, ["Neon"] = 169.52, ["Neon|Ride"] = 158.82, ["Neon|Fly|Ride"] = 234.14, ["Mega|Ride"] = 786.69, ["Mega|Fly|Ride"] = 565.74}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 3.41, ["Ride"] = 27.56, ["Fly|Ride"] = 362.25, ["Neon"] = 18.38, ["Neon|Ride"] = 68.83, ["Mega"] = 131.25, ["Mega|Ride"] = 211.91, ["Mega|Fly|Ride"] = 254.27}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 18.62, ["Fly"] = 67.25, ["Ride"] = 26.25, ["Fly|Ride"] = 45.94, ["Neon"] = 228.74, ["Neon|Ride"] = 156.8, ["Neon|Fly|Ride"] = 141.98, ["Mega"] = 952.43, ["Mega|Ride"] = 943.55, ["Mega|Fly|Ride"] = 706.65}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 52.99, ["Fly"] = 874.13, ["Neon|Ride"] = 471.78, ["Mega"] = 353.07, ["Mega|Ride"] = 590.63}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 51.19, ["Fly"] = 115.5, ["Ride"] = 64.99, ["Fly|Ride"] = 131.25, ["Neon"] = 246.75, ["Neon|Fly"] = 296.66, ["Neon|Ride"] = 276.92, ["Neon|Fly|Ride"] = 370.48, ["Mega"] = 1144.19, ["Mega|Ride"] = 1158.76, ["Mega|Fly|Ride"] = 1186.56}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 52.5, ["Fly"] = 92.79, ["Ride"] = 97.75, ["Fly|Ride"] = 282.87, ["Neon"] = 137.82, ["Neon|Ride"] = 184.36, ["Neon|Fly|Ride"] = 421.66, ["Mega"] = 513.35, ["Mega|Ride"] = 612.73, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 25.35, ["Ride"] = 52.99, ["Neon"] = 125.98, ["Mega"] = 565.74, ["Mega|Ride"] = 635.66, ["Mega|Fly|Ride"] = 718.3}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 7.87, ["Ride"] = 30.68, ["Fly|Ride"] = 91.54, ["Neon"] = 45.94, ["Neon|Fly"] = 169.52, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 116.28, ["Mega"] = 289.98, ["Mega|Ride"] = 325.19, ["Mega|Fly|Ride"] = 361.29}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 15.91, ["Ride"] = 15.89, ["Fly|Ride"] = 38.56, ["Neon"] = 3.94, ["Neon|Fly"] = 24.89, ["Neon|Ride"] = 21.25, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 32.8, ["Mega|Fly"] = 706.65, ["Mega|Ride"] = 62.99, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1269.05}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 25.96, ["Ride"] = 42, ["Fly|Ride"] = 127.15, ["Neon"] = 127.15, ["Neon|Ride"] = 221.74, ["Neon|Fly|Ride"] = 362.09, ["Mega"] = 410.01, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 503.42}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 47.19, ["Neon"] = 5.25, ["Neon|Ride"] = 37.09, ["Neon|Fly|Ride"] = 296.66, ["Mega"] = 28.62, ["Mega|Ride"] = 115.31, ["Mega|Fly|Ride"] = 541.36}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 28.61, ["Ride"] = 44.63, ["Neon"] = 208.31, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 325.26, ["Mega"] = 633.94, ["Mega|Ride"] = 834.84, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 6.38, ["Neon|Ride"] = 105, ["Mega"] = 26.25, ["Mega|Fly|Ride"] = 706.65}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.91, ["Neon|Ride"] = 158.06, ["Mega"] = 22.32, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 379.29}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 108.57, ["Ride"] = 172.71, ["Fly|Ride"] = 249.37, ["Neon"] = 425.25, ["Neon|Ride"] = 518.44, ["Neon|Fly|Ride"] = 668.51, ["Mega|Ride"] = 6486.81, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.63, ["Fly"] = 26.11, ["Ride"] = 28.62, ["Fly|Ride"] = 40.11, ["Neon"] = 11.81, ["Neon|Fly"] = 63.58, ["Neon|Ride"] = 35.43, ["Neon|Fly|Ride"] = 92.17, ["Mega"] = 107.63, ["Mega|Ride"] = 127.15, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 36.16, ["Ride"] = 131.25, ["Fly|Ride"] = 86.63, ["Neon"] = 6.3, ["Neon|Ride"] = 57.22, ["Neon|Fly|Ride"] = 100.66, ["Mega"] = 37.09, ["Mega|Ride"] = 101.72, ["Mega|Fly|Ride"] = 116.82}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 3.91, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.17, ["Mega"] = 34.13, ["Mega|Ride"] = 48.75, ["Mega|Fly|Ride"] = 114.19}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 4.93, ["Neon|Ride"] = 21.2, ["Neon|Fly|Ride"] = 141.98, ["Mega"] = 40.69, ["Mega|Ride"] = 95.7, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 45.94, ["Ride"] = 91.88, ["Fly|Ride"] = 449.61, ["Neon"] = 343.25, ["Neon|Ride"] = 253.87, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1363.48, ["Mega|Ride"] = 1482.13, ["Mega|Fly|Ride"] = 1554.18}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.83, ["Ride"] = 139.79, ["Neon"] = 28.29, ["Neon|Ride"] = 110.88, ["Mega"] = 141.98, ["Mega|Ride"] = 771.1}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 360.59, ["Ride"] = 357, ["Fly|Ride"] = 524.43, ["Neon"] = 1786.83, ["Neon|Ride"] = 1269.19, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 3643.34, ["Mega|Fly|Ride"] = 3197.3}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 75.84}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 44.58}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 15.91}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 15.75}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 28.88}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 32.82}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 10.49}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 5.24}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 234.94}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 22.42}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 55.82}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 7.27}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 4.64}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 393.74}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 5.25}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 5.2}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 5.24}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 4.86}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 23.73}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 475.13}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 661.86}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 9.19}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1312.5}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 59.07}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 5.25}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 15.62}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 3.93}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 19.05}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 24.94}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 34.13}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 15.74}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 13.13}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 13.1}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 7.35}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 15.1}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 3.81}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 22.25}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 21}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.5}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1575}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 161.04}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 308.23}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 10.71}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.63}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 6.35}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 7.87}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 127.3}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 9.92}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 11.78}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.63}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 656.24}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 27.57}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 3.93}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 22.23}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 11.82}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 3.78}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 110.25}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 36.67}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 10.4}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.63}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 29.4}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.63}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 9.44}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 3.93}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 26.25}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.63}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 133.55}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 159.12}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.63}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 9.76}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 23.62}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 77.3}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 57.05}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22408.92}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 183.73}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 37.2}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 64.98}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 48.57}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 38.03}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 48.07}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 45.94}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 82.67}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 91.14}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 49.55}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 52.5}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 39.12}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 44.63}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 74.79}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 354.37}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 9.19}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 6.51}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.63}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 7.09}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 34.12}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 41.71}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.82}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 4.25}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 3.94}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 210}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 1050}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 6.36}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 525}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 33.84}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.63}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.63}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 380.63}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 56.44}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 92.25}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 36.04}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 48.57}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 133.5}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 30.68}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.93}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 14.91}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 2.61}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 3.91}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 30.19}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 5.25}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.09}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.94}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 16.92}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 150.94}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 5.92}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 4.25}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 235.9}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 7.72}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 26.25}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 6.57}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 15.94}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 49.85}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 11.82}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.63}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 7.88}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 26.25}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 21.2}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 105}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 61.35}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 7.87}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 8.44}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 3.46}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 3.94}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 6.99}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 7.45}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 4.25}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 5.91}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 4.19}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 5670}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 52.99}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 8.17}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.41}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 20.47}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 18.87}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 3.94}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.93}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 15.48}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 131.25}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 17.32}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 9.45}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 3.86}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.56}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 3.93}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 5.25}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4237.67}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 4.61}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 40.69}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 23.61}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 78.75}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.61}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 5.28}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 278.24}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.1}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 8.49}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.63}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 8.48}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 8.07}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 27.57}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.93}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.63}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.67}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.61}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 13.06}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.15}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 2.63}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 5.2}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 5.13}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.2}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 6.25}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 31.37}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.6}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 65.19}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 15.88}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 275.62}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.19}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 85.32}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 6.23}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 984.38}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 14.16}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 5.01}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 3.92}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 27.38}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 3.28}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 6.29}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 3.94}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 9.19}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 24.92}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 3.93}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 15.74}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 15.75}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.63}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 13.13}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 2.1}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 4.19}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 17.07}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 5.25}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.52}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 3.93}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 26.25}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 16.95}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 5.24}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 140.44}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 7.85}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 32.75}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.63}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 11.02}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 8.48}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 2.1}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 49.13}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 25.55}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.92}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 11.65}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 102.38}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.6}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 9.19}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 4.34}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 5.25}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 9.19}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 10.54}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 17.88}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 86.63}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.49}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 7.86}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.63}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 108.81}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 5.25}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1245.57}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 187.69}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 6.35}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 7.87}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.63}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 10.45}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 52.41}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.3}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 3.94}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.56}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 78.4}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 9.13}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 2.24}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 3.93}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 3.39}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 5.25}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.85}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 7.66}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 3.54}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 102.62}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 18.9}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 51.18}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.61}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 3.93}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 3.84}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 7.87}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 22.97}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 91.88}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 5.25}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 75.51}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 10.61}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.93}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 11.46}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 65.44}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.63}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 60.36}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 91.88}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 328.13}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 85.24}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 170.63}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.93}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.63}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 15.63}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 51.19}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.77}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 23.63}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.15}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 5.99}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 8.81}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 28.61}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 7.54}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 6.24}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 6.54}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 32.85}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 45.94}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 26.25}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.83}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 6.5}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 127.12}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 65.63}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 27.28}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1561.6}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 42}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 14.17}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 26.33}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 271.63}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 15.74}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 7.88}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 42.45}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 7.87}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 3.91}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 170.61}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 43.08}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 53.2}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 9.85}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 73.56}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 104.48}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 105}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1023.75}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 236.25}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 11.82}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1057.4}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 588.54}},
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