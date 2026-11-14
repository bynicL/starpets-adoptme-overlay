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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 921.16, ["Fly"] = 1130.28, ["Ride"] = 1133.55, ["Fly|Ride"] = 1312.5, ["Neon"] = 3937.5, ["Neon|Ride"] = 4943.71, ["Neon|Fly|Ride"] = 3921.75, ["Mega|Fly|Ride"] = 21174.57}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 393.75, ["Fly"] = 540.26, ["Ride"] = 409.96, ["Fly|Ride"] = 409.29, ["Neon|Ride"] = 1836.82, ["Neon|Fly|Ride"] = 1942.75, ["Mega"] = 9887.39, ["Mega|Fly|Ride"] = 8232.79}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4331.25, ["Ride"] = 5250, ["Fly|Ride"] = 4515, ["Neon"] = 26132.59, ["Neon|Fly|Ride"] = 20441.55, ["Mega|Fly|Ride"] = 63557.21}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 124.68, ["Ride"] = 157.5, ["Fly|Ride"] = 224.44, ["Neon"] = 1415.32, ["Neon|Ride"] = 821.63, ["Neon|Fly|Ride"] = 847.45, ["Mega"] = 3813.45, ["Mega|Fly|Ride"] = 2743.98}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 632.63, ["Fly"] = 664.18, ["Ride"] = 534.1, ["Fly|Ride"] = 548.3, ["Neon|Fly|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 6956.25}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 11.66, ["Ride"] = 32.82, ["Fly|Ride"] = 141.98, ["Neon"] = 57.22, ["Neon|Ride"] = 84.62, ["Neon|Fly|Ride"] = 282.84, ["Mega"] = 280.88, ["Mega|Ride"] = 466.47, ["Mega|Fly|Ride"] = 409.96}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.94, ["Fly"] = 36.58, ["Ride"] = 27.56, ["Fly|Ride"] = 47.19, ["Neon"] = 26.25, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 105.35, ["Mega"] = 139.83, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 236.13}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 100.99, ["Fly"] = 196.88, ["Ride"] = 141.98, ["Fly|Ride"] = 231, ["Neon"] = 418.69, ["Neon|Ride"] = 480.9, ["Neon|Fly|Ride"] = 631.35, ["Mega"] = 1886.84, ["Mega|Fly|Ride"] = 1834.7}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 34.85, ["Fly"] = 143.01, ["Ride"] = 39.38, ["Fly|Ride"] = 95.19, ["Neon"] = 226.73, ["Neon|Ride"] = 195.02, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 2100, ["Mega|Ride"] = 1273.63, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 24.94, ["Fly"] = 30.68, ["Ride"] = 31.85, ["Fly|Ride"] = 65.63, ["Neon"] = 211.91, ["Neon|Ride"] = 181.16, ["Neon|Fly|Ride"] = 188.69, ["Mega|Ride"] = 635.59, ["Mega|Fly|Ride"] = 740.46}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 45.94, ["Fly"] = 288.15, ["Ride"] = 65.63, ["Fly|Ride"] = 127.32, ["Neon"] = 203.44, ["Neon|Ride"] = 210.83, ["Neon|Fly|Ride"] = 279.66, ["Mega|Ride"] = 1376.03, ["Mega|Fly|Ride"] = 1367.98}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 76.13}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 409.96, ["Fly"] = 441.06, ["Ride"] = 380.63, ["Fly|Ride"] = 367.5, ["Neon"] = 1409.04, ["Neon|Ride"] = 1413.09, ["Neon|Fly|Ride"] = 1340.07, ["Mega"] = 5650.25, ["Mega|Fly|Ride"] = 5795.37}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 98.44, ["Fly"] = 111.57, ["Ride"] = 105.97, ["Fly|Ride"] = 155.69, ["Neon|Ride"] = 564.38, ["Neon|Fly|Ride"] = 584.74, ["Mega|Fly|Ride"] = 3036.99}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.45, ["Ride"] = 33.79, ["Fly|Ride"] = 78.75, ["Neon"] = 15.74, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 80.53, ["Mega"] = 82.64, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 383.25}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 129.87, ["Fly"] = 158.39, ["Ride"] = 147.96, ["Fly|Ride"] = 190.32, ["Neon"] = 706.65, ["Neon|Ride"] = 629.24, ["Neon|Fly|Ride"] = 511.88, ["Mega|Fly|Ride"] = 1837.38}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.2, ["Fly"] = 24.38, ["Ride"] = 15.89, ["Fly|Ride"] = 44.63, ["Neon"] = 24.94, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 196.88, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 305.82}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 47.24, ["Fly"] = 153.33, ["Ride"] = 96.72, ["Fly|Ride"] = 223, ["Neon"] = 207.38, ["Neon|Ride"] = 200.03, ["Neon|Fly|Ride"] = 396.82, ["Mega"] = 826.25, ["Mega|Ride"] = 761.64, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 43.32}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 69.55, ["Ride"] = 105, ["Fly|Ride"] = 246.1, ["Neon"] = 280.88, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 2362.5}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 15.9, ["Fly"] = 393.75, ["Ride"] = 28.88, ["Fly|Ride"] = 78.75, ["Neon"] = 148.6, ["Neon|Ride"] = 63.71, ["Neon|Fly|Ride"] = 269.08, ["Mega"] = 2712.34, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 1694.87}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 31.84, ["Fly"] = 70.98, ["Ride"] = 50.24, ["Fly|Ride"] = 106.29, ["Neon"] = 226.73, ["Neon|Fly"] = 315.72, ["Neon|Ride"] = 141.96, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 1681.32, ["Mega|Ride"] = 847.45, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 57.75, ["Fly"] = 105, ["Fly|Ride"] = 139.86, ["Neon"] = 208.67, ["Neon|Ride"] = 223.12, ["Neon|Fly|Ride"] = 316.74, ["Mega"] = 1088.96, ["Mega|Ride"] = 1266.91, ["Mega|Fly|Ride"] = 1130.28}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 39.45, ["Fly"] = 63.7, ["Ride"] = 49.81, ["Fly|Ride"] = 127.15, ["Neon|Ride"] = 158.04, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 1207.92, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1101.45}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 45.94, ["Fly"] = 587.65, ["Ride"] = 45.94, ["Fly|Ride"] = 131.25, ["Neon"] = 313.42, ["Neon|Ride"] = 295.59, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 847.45}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 4.93, ["Fly"] = 32.82, ["Ride"] = 19.69, ["Fly|Ride"] = 49.88, ["Neon"] = 30.68, ["Neon|Fly"] = 70.88, ["Neon|Ride"] = 42.39, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 129.94, ["Mega|Fly"] = 275.63, ["Mega|Ride"] = 138.76, ["Mega|Fly|Ride"] = 225.75}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 293.99, ["Fly"] = 370.76, ["Ride"] = 338.63, ["Fly|Ride"] = 362.25, ["Neon"] = 1475.25, ["Neon|Ride"] = 1978.76, ["Neon|Fly|Ride"] = 1413.09, ["Mega"] = 10592.88, ["Mega|Fly|Ride"] = 5975.4}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 22.32, ["Ride"] = 24.87, ["Fly|Ride"] = 137.73, ["Neon"] = 494.75, ["Neon|Ride"] = 304.03, ["Neon|Fly|Ride"] = 414.2, ["Mega"] = 833.68, ["Mega|Fly|Ride"] = 798.72}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 6.57, ["Fly"] = 38.07, ["Ride"] = 20.14, ["Fly|Ride"] = 50.87, ["Neon"] = 50.87, ["Neon|Ride"] = 54.1, ["Neon|Fly|Ride"] = 84.76, ["Mega"] = 312.51, ["Mega|Ride"] = 317.8, ["Mega|Fly|Ride"] = 380.31}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 87.29, ["Fly"] = 141.96, ["Ride"] = 109.87, ["Fly|Ride"] = 98.44, ["Neon"] = 409.26, ["Neon|Ride"] = 462.93, ["Neon|Fly|Ride"] = 446.25, ["Mega"] = 6249, ["Mega|Ride"] = 1473.49, ["Mega|Fly|Ride"] = 1766.91}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 11.82, ["Fly"] = 36.03, ["Ride"] = 27.54, ["Fly|Ride"] = 70.95, ["Neon"] = 75.24, ["Neon|Ride"] = 127.14, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 409.96, ["Mega|Ride"] = 635.59, ["Mega|Fly|Ride"] = 692.78}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 157.5, ["Fly"] = 353.82, ["Ride"] = 196.88, ["Fly|Ride"] = 339.03, ["Neon"] = 773.07, ["Neon|Ride"] = 804.01, ["Neon|Fly|Ride"] = 773.07, ["Mega"] = 6355.74, ["Mega|Fly|Ride"] = 2981.91}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 68.25}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 5.09, ["Fly"] = 36.58, ["Ride"] = 27.56, ["Fly|Ride"] = 93.19, ["Neon"] = 20.98, ["Neon|Fly"] = 105.96, ["Neon|Ride"] = 36.03, ["Neon|Fly|Ride"] = 158.04, ["Mega"] = 131.25, ["Mega|Fly"] = 235.87, ["Mega|Ride"] = 240.48, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 735, ["Fly"] = 847.45, ["Ride"] = 845.33, ["Fly|Ride"] = 989.5, ["Neon"] = 4973.97, ["Neon|Ride"] = 5248.69, ["Neon|Fly|Ride"] = 3918.31, ["Mega"] = 12711.46, ["Mega|Ride"] = 53067.32, ["Mega|Fly|Ride"] = 13207.87}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 7.88, ["Fly"] = 28.49, ["Ride"] = 22.32, ["Fly|Ride"] = 72.19, ["Neon"] = 108.08, ["Neon|Ride"] = 126.07, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 422.67, ["Mega|Ride"] = 609.11, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 93.55, ["Ride"] = 124.69, ["Fly|Ride"] = 196.88, ["Neon"] = 511.88, ["Neon|Ride"] = 629.24, ["Neon|Fly|Ride"] = 685.13, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 2665.18}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 40.4}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 18.38, ["Fly"] = 68.85, ["Ride"] = 52.99, ["Fly|Ride"] = 144.38, ["Neon"] = 42.39, ["Neon|Ride"] = 206.07, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 529.66, ["Mega|Ride"] = 723.19, ["Mega|Fly|Ride"] = 706.55}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 131.25, ["Ride"] = 171.94, ["Neon"] = 563.62, ["Neon|Ride"] = 495.37, ["Neon|Fly|Ride"] = 590.63, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 109.73, ["Ride"] = 162.26, ["Fly|Ride"] = 131.25, ["Neon"] = 942.37, ["Neon|Ride"] = 366.18, ["Neon|Fly|Ride"] = 572.02, ["Mega"] = 1378.13, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1537.91}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 52.49}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 60.38, ["Fly"] = 65.63, ["Ride"] = 56.1, ["Fly|Ride"] = 64.32, ["Neon"] = 608.12, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 282.19, ["Mega"] = 4236.1, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 6.56, ["Ride"] = 31.86, ["Fly|Ride"] = 159.99, ["Neon"] = 38.07, ["Neon|Ride"] = 42.39, ["Neon|Fly|Ride"] = 236.23, ["Mega"] = 198.1, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 212.28, ["Mega|Fly|Ride"] = 350.64}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 346.49, ["Fly"] = 420, ["Ride"] = 348.83, ["Fly|Ride"] = 408.36, ["Neon|Ride"] = 1553.99, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 4660.87}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 84.13, ["Fly"] = 99.75, ["Ride"] = 94.5, ["Fly|Ride"] = 91.88, ["Neon"] = 360.22, ["Neon|Ride"] = 362.06, ["Neon|Fly|Ride"] = 367.49, ["Mega|Ride"] = 1904.61, ["Mega|Fly|Ride"] = 1815.63}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 4018.94, ["Ride"] = 3918.31, ["Fly|Ride"] = 3017.43, ["Neon|Fly|Ride"] = 14122.42}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 38.68, ["Fly"] = 113.36, ["Ride"] = 46.81, ["Fly|Ride"] = 95.82, ["Neon"] = 392.44, ["Neon|Ride"] = 229.69, ["Neon|Fly|Ride"] = 294.83, ["Mega|Ride"] = 2118.59, ["Mega|Fly|Ride"] = 1610.44}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 39.38, ["Ride"] = 117.58, ["Fly|Ride"] = 139.18, ["Neon"] = 480.99, ["Neon|Ride"] = 795.08, ["Neon|Fly|Ride"] = 494.7, ["Mega"] = 6355.74, ["Mega|Fly|Ride"] = 1676.87}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 36.05, ["Fly"] = 70.76, ["Ride"] = 57.22, ["Fly|Ride"] = 106.12, ["Neon"] = 177.99, ["Neon|Fly"] = 281.81, ["Neon|Ride"] = 162.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 2625, ["Mega|Fly|Ride"] = 625}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 8.4}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 59.33, ["Ride"] = 76.13, ["Fly|Ride"] = 117.6, ["Neon"] = 354.92, ["Neon|Ride"] = 471.72, ["Neon|Fly|Ride"] = 501.38, ["Mega|Fly|Ride"] = 1730.01}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 34.92}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 200.97, ["Ride"] = 198.1, ["Fly|Ride"] = 262.5, ["Neon|Fly|Ride"] = 1480.9}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 702.19, ["Ride"] = 748.13, ["Fly|Ride"] = 816.59, ["Neon|Ride"] = 3247.79, ["Neon|Fly|Ride"] = 2861.25, ["Mega|Fly|Ride"] = 11812.5}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 13.12}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 26.12, ["Fly"] = 52.42, ["Ride"] = 38.07, ["Fly|Ride"] = 70.26, ["Neon"] = 162.75, ["Neon|Ride"] = 134.65, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 685.96}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 10.5}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 4265.63, ["Fly|Ride"] = 4410, ["Neon|Fly|Ride"] = 9495.94, ["Mega|Fly|Ride"] = 38134.34}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 11.61, ["Fly"] = 74.64, ["Ride"] = 23.63, ["Fly|Ride"] = 44.63, ["Neon"] = 65.63, ["Neon|Ride"] = 102.38, ["Neon|Fly|Ride"] = 175.86, ["Mega"] = 420, ["Mega|Ride"] = 338.99, ["Mega|Fly|Ride"] = 514.6}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 12.53, ["Fly"] = 94.35, ["Ride"] = 31.49, ["Fly|Ride"] = 116.78, ["Neon"] = 85.32, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 231, ["Mega"] = 446.25, ["Mega|Ride"] = 516.95, ["Mega|Fly|Ride"] = 673.73}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 80.51, ["Fly"] = 139.21, ["Ride"] = 94.5, ["Fly|Ride"] = 101.07, ["Neon"] = 1413.28, ["Neon|Fly|Ride"] = 420, ["Mega"] = 4237.16}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 12.96, ["Fly"] = 150.94, ["Ride"] = 31.18, ["Fly|Ride"] = 40.11, ["Neon"] = 60.4, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 119.54, ["Mega"] = 528.61, ["Mega|Ride"] = 417.03, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 2100, ["Fly"] = 2489.96, ["Ride"] = 1968.75, ["Fly|Ride"] = 1890, ["Neon|Fly|Ride"] = 3937.5, ["Mega|Fly|Ride"] = 15009.49}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 28248.01, ["Fly"] = 35221.37, ["Ride"] = 35314.54, ["Fly|Ride"] = 24281.25, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 61687.5, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 197728.57}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 18.83, ["Fly"] = 393.75, ["Ride"] = 42, ["Fly|Ride"] = 63.74, ["Neon"] = 134.47, ["Neon|Fly"] = 141.98, ["Neon|Ride"] = 204.63, ["Neon|Fly|Ride"] = 282.84, ["Mega"] = 565.67, ["Mega|Ride"] = 1271.16, ["Mega|Fly|Ride"] = 846.21}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.5, ["Ride"] = 35.39, ["Fly|Ride"] = 127.15, ["Neon"] = 16.94, ["Neon|Fly"] = 134.38, ["Neon|Ride"] = 42.39, ["Neon|Fly|Ride"] = 120.78, ["Mega"] = 90.56, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 23.63}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.88, ["Ride"] = 40.69, ["Fly|Ride"] = 71, ["Neon"] = 40.27, ["Neon|Ride"] = 105.25, ["Neon|Fly|Ride"] = 463.32, ["Mega"] = 393.75, ["Mega|Ride"] = 468.9, ["Mega|Fly|Ride"] = 471.19}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 761.64, ["Ride"] = 603.75, ["Fly|Ride"] = 782.25, ["Neon"] = 2988.66, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2472.39, ["Mega|Fly|Ride"] = 11007.35}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 997.48, ["Fly"] = 962.07, ["Ride"] = 984.38, ["Fly|Ride"] = 997.5, ["Neon|Fly|Ride"] = 3071.25, ["Mega|Fly|Ride"] = 21184.69}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 28.88, ["Fly"] = 117.95, ["Ride"] = 56.44, ["Fly|Ride"] = 103.44, ["Neon"] = 211.87, ["Neon|Ride"] = 192.94, ["Neon|Fly|Ride"] = 211.87, ["Mega"] = 698.09, ["Mega|Fly|Ride"] = 1413.09}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 24.57}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 112.29, ["Fly"] = 105.94, ["Ride"] = 96.8, ["Fly|Ride"] = 134.54, ["Neon|Ride"] = 565.74, ["Neon|Fly|Ride"] = 410.82, ["Mega|Ride"] = 1693.82, ["Mega|Fly|Ride"] = 1598.63}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 65.62, ["Ride"] = 84, ["Fly|Ride"] = 195.39, ["Neon"] = 395.59, ["Neon|Ride"] = 324.74, ["Neon|Fly|Ride"] = 508.48, ["Mega"] = 1481.96, ["Mega|Fly|Ride"] = 1508.45}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.93, ["Fly"] = 32.78, ["Ride"] = 21.2, ["Fly|Ride"] = 52.05, ["Neon"] = 24.38, ["Neon|Fly"] = 314.92, ["Neon|Ride"] = 68.75, ["Neon|Fly|Ride"] = 141.96, ["Mega"] = 282.84, ["Mega|Ride"] = 346.41, ["Mega|Fly|Ride"] = 314.88}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 77.3, ["Fly"] = 88.46, ["Ride"] = 85.32, ["Fly|Ride"] = 154.66, ["Neon"] = 423.78, ["Neon|Ride"] = 342.02, ["Neon|Fly|Ride"] = 304.14, ["Mega|Fly|Ride"] = 976.42}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 2.1, ["Fly"] = 70.98, ["Ride"] = 39.38, ["Fly|Ride"] = 138.8, ["Neon"] = 28.62, ["Neon|Fly"] = 269.1, ["Neon|Ride"] = 113.58, ["Neon|Fly|Ride"] = 141.96, ["Mega"] = 85.32, ["Mega|Fly"] = 989.39, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 368.78}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 15.18, ["Fly"] = 65.63, ["Ride"] = 31.5, ["Fly|Ride"] = 87.29, ["Neon"] = 141.98, ["Neon|Ride"] = 110.87, ["Neon|Fly|Ride"] = 138.78, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 28.88, ["Ride"] = 57.22, ["Fly|Ride"] = 156.19, ["Neon"] = 198.08, ["Neon|Ride"] = 349.09, ["Mega"] = 706.55, ["Mega|Ride"] = 1161.57, ["Mega|Fly|Ride"] = 883.46}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 18.38, ["Fly"] = 80.21, ["Ride"] = 30.74, ["Fly|Ride"] = 82.69, ["Neon"] = 103.69, ["Neon|Fly"] = 423.78, ["Neon|Ride"] = 100.66, ["Neon|Fly|Ride"] = 92.17, ["Mega|Fly|Ride"] = 945}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 5040, ["Ride"] = 5906.25, ["Fly|Ride"] = 5053.13, ["Neon"] = 31077.95, ["Neon|Fly|Ride"] = 23625}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 248.06, ["Fly"] = 264.79, ["Ride"] = 229.69, ["Fly|Ride"] = 274.3, ["Neon|Ride"] = 707.58, ["Neon|Fly|Ride"] = 563.43, ["Mega|Fly|Ride"] = 2934.91}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 28.62, ["Fly"] = 99.6, ["Ride"] = 67.82, ["Fly|Ride"] = 114.19, ["Neon"] = 72.28, ["Neon|Fly"] = 241.5, ["Neon|Ride"] = 97.21, ["Neon|Fly|Ride"] = 181.13, ["Mega"] = 285.84, ["Mega|Fly"] = 374.07, ["Mega|Ride"] = 313.84, ["Mega|Fly|Ride"] = 438.54}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.6, ["Fly"] = 41.29, ["Ride"] = 20.9, ["Fly|Ride"] = 99.61, ["Neon"] = 19.69, ["Neon|Ride"] = 57.22, ["Mega"] = 179.82}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 37.63, ["Fly"] = 50.72, ["Ride"] = 75.38, ["Fly|Ride"] = 148.34, ["Neon"] = 112.88, ["Neon|Fly"] = 265.93, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 253.19, ["Mega"] = 491.52, ["Mega|Ride"] = 448.02, ["Mega|Fly|Ride"] = 531.25}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 11812.5, ["Ride"] = 10893.75, ["Fly|Ride"] = 10893.75, ["Neon|Fly|Ride"] = 23625, ["Mega|Fly|Ride"] = 91799.91}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 152.25, ["Fly"] = 198.1, ["Ride"] = 189.11, ["Fly|Ride"] = 266.44, ["Neon"] = 845.43, ["Neon|Ride"] = 794.49, ["Neon|Fly|Ride"] = 986.21, ["Mega|Fly|Ride"] = 7075.66}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 47.06, ["Fly"] = 459.38, ["Ride"] = 52.5, ["Fly|Ride"] = 91.88, ["Neon|Fly"] = 471.78, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 288.75, ["Mega|Fly|Ride"] = 2000.25}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 9.18, ["Fly"] = 31.85, ["Ride"] = 24.38, ["Fly|Ride"] = 65.54, ["Neon"] = 72.19, ["Neon|Fly"] = 84.76, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 480.94, ["Mega|Ride"] = 492.19, ["Mega|Fly|Ride"] = 528.61}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 366.18, ["Fly"] = 847.45, ["Ride"] = 399, ["Fly|Ride"] = 492.29, ["Neon"] = 1639.32, ["Neon|Ride"] = 1311.19, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4935}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.56, ["Ride"] = 36.04, ["Fly|Ride"] = 141.54, ["Neon"] = 28.06, ["Neon|Ride"] = 83.91, ["Neon|Fly|Ride"] = 239.4, ["Mega"] = 118.13, ["Mega|Ride"] = 172.04, ["Mega|Fly|Ride"] = 212.28}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 170.56, ["Fly"] = 393.75, ["Ride"] = 203.21, ["Fly|Ride"] = 273, ["Neon"] = 686.53, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 648.38, ["Mega|Ride"] = 3460.7, ["Mega|Fly|Ride"] = 2452.26}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 12.75, ["Fly"] = 21, ["Ride"] = 21.83, ["Fly|Ride"] = 32.85, ["Neon|Ride"] = 93.09, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 786.19, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 9.19}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 60.38, ["Ride"] = 72.19, ["Fly|Ride"] = 525, ["Neon"] = 206.57, ["Neon|Fly"] = 1695.07, ["Neon|Ride"] = 370.76, ["Neon|Fly|Ride"] = 471.39, ["Mega"] = 1269.05, ["Mega|Ride"] = 1415.14, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 14.42, ["Fly"] = 104.88, ["Ride"] = 34.13, ["Fly|Ride"] = 84, ["Neon"] = 94.84, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 181.12, ["Mega"] = 475.63, ["Mega|Ride"] = 501.48, ["Mega|Fly|Ride"] = 968.21}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 14.44}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 24.64, ["Fly"] = 111.57, ["Ride"] = 57.75, ["Fly|Ride"] = 236.25, ["Neon"] = 170.62, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 240.48, ["Mega"] = 565.67, ["Mega|Ride"] = 692.78, ["Mega|Fly|Ride"] = 746.82}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.94, ["Ride"] = 37.09, ["Fly|Ride"] = 131.25, ["Neon"] = 23.39, ["Neon|Ride"] = 138.78, ["Neon|Fly|Ride"] = 125.01, ["Mega"] = 98.43, ["Mega|Fly|Ride"] = 396.19}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 12.91, ["Ride"] = 30.19, ["Fly|Ride"] = 99.45, ["Neon"] = 148.34, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 226.71, ["Mega|Ride"] = 579.44, ["Mega|Fly|Ride"] = 759.94}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 409.5, ["Fly"] = 437.75, ["Ride"] = 328.12, ["Fly|Ride"] = 406.88, ["Neon|Fly|Ride"] = 1978.76, ["Mega|Fly|Ride"] = 7768.82}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 57.22, ["Ride"] = 53.58, ["Fly|Ride"] = 131.25, ["Neon"] = 156.77, ["Neon|Ride"] = 205.22, ["Neon|Fly|Ride"] = 240.48, ["Mega"] = 704.96, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 754.74}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 45.85, ["Fly"] = 83.91, ["Ride"] = 69.28, ["Fly|Ride"] = 138.55, ["Neon"] = 203.1, ["Neon|Ride"] = 188.9, ["Neon|Fly|Ride"] = 381.36, ["Mega"] = 1352.64, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 986.21}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 26.24, ["Fly"] = 68.25, ["Ride"] = 45.94, ["Fly|Ride"] = 131.25, ["Neon"] = 100.82, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 299.56, ["Mega"] = 381.36, ["Mega|Ride"] = 405.57, ["Mega|Fly|Ride"] = 522.38}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 9843.75, ["Ride"] = 11321.04, ["Fly|Ride"] = 7742.44, ["Neon|Fly|Ride"] = 19065.05, ["Mega|Fly|Ride"] = 39372.9}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1785.39, ["Ride"] = 1771.88, ["Fly|Ride"] = 1803.38, ["Neon|Fly|Ride"] = 4845.78, ["Mega|Fly|Ride"] = 22050}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 388.5, ["Ride"] = 466.1, ["Fly|Ride"] = 393.75, ["Neon"] = 2118.84, ["Neon|Ride"] = 1733.01, ["Neon|Fly|Ride"] = 1455.47, ["Mega"] = 16948.6, ["Mega|Fly|Ride"] = 6495.57}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 13.12, ["Fly"] = 29.13, ["Ride"] = 23.61, ["Fly|Ride"] = 39.56, ["Neon"] = 109.13, ["Neon|Ride"] = 113.36, ["Neon|Fly|Ride"] = 105, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 6.43, ["Fly"] = 39.38, ["Ride"] = 37.09, ["Fly|Ride"] = 124.69, ["Neon"] = 25.96, ["Neon|Ride"] = 47.19, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 143.73, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 235.87}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 42.39, ["Fly"] = 53.81, ["Ride"] = 44.63, ["Fly|Ride"] = 91.88, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 141.96, ["Mega|Fly|Ride"] = 552.57}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.35, ["Fly"] = 27.56, ["Ride"] = 18.79, ["Fly|Ride"] = 39.38, ["Neon"] = 22.32, ["Neon|Fly"] = 282.87, ["Neon|Ride"] = 38.06, ["Neon|Fly|Ride"] = 103.67, ["Mega"] = 360.94, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 327.44}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 328.13, ["Fly"] = 314.99, ["Ride"] = 342.02, ["Fly|Ride"] = 356.97, ["Neon"] = 1887.08, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1299.38, ["Mega|Fly|Ride"] = 5660.52}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 30.85, ["Fly"] = 48.19, ["Ride"] = 36.16, ["Fly|Ride"] = 71, ["Neon"] = 127.61, ["Neon|Fly"] = 282.87, ["Neon|Ride"] = 156.95, ["Neon|Fly|Ride"] = 127.13, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 11.8, ["Fly"] = 28.29, ["Ride"] = 21.2, ["Fly|Ride"] = 42, ["Neon"] = 141.98, ["Neon|Fly"] = 127.15, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 529.66, ["Mega|Ride"] = 583.68, ["Mega|Fly|Ride"] = 1128.75}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 564.83, ["Fly"] = 787.5, ["Ride"] = 459.38, ["Fly|Ride"] = 795.63, ["Neon|Ride"] = 2754.17, ["Mega|Fly|Ride"] = 8619.19}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1123.49, ["Fly"] = 1415.14, ["Ride"] = 1170.75, ["Fly|Ride"] = 1181.25, ["Neon"] = 4958.07, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 16523.82}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 85.31, ["Fly"] = 110.18, ["Ride"] = 101.62, ["Fly|Ride"] = 112.88, ["Neon"] = 504.3, ["Neon|Ride"] = 414.75, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 1640.63}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 183.75, ["Fly"] = 226.71, ["Ride"] = 131.25, ["Fly|Ride"] = 224.44, ["Neon"] = 651.06, ["Neon|Fly"] = 889.92, ["Neon|Ride"] = 629.5, ["Neon|Fly|Ride"] = 590.63, ["Mega|Ride"] = 2966.01, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 24.93, ["Fly"] = 131.25, ["Ride"] = 44.5, ["Neon"] = 183.75, ["Neon|Fly"] = 423.78, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 325.21, ["Mega|Ride"] = 943.43, ["Mega|Fly|Ride"] = 865.6}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 131.36, ["Ride"] = 275.46, ["Fly|Ride"] = 597.19, ["Neon"] = 1059.43, ["Mega|Fly|Ride"] = 2830.27}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2118.32, ["Fly"] = 2533.82, ["Ride"] = 2152.49, ["Fly|Ride"] = 2189.82, ["Neon|Fly|Ride"] = 7203.17, ["Mega|Fly|Ride"] = 48727.2}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 46.6, ["Ride"] = 49.88, ["Fly|Ride"] = 156.8, ["Neon"] = 291.36, ["Neon|Fly"] = 211.91, ["Neon|Ride"] = 282.84, ["Neon|Fly|Ride"] = 295.56, ["Mega"] = 2112.23, ["Mega|Ride"] = 2330.45, ["Mega|Fly|Ride"] = 1809.03}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 573.57, ["Fly"] = 675.94, ["Ride"] = 591.24, ["Fly|Ride"] = 616.88, ["Neon|Ride"] = 1266.57, ["Neon|Fly|Ride"] = 1273.13, ["Mega|Fly|Ride"] = 2945.25}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 38.94, ["Fly"] = 60.38, ["Ride"] = 52.5, ["Fly|Ride"] = 79.04, ["Neon|Ride"] = 365.59, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 1456.88}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.67, ["Fly"] = 28.88, ["Ride"] = 20.46, ["Fly|Ride"] = 42, ["Neon"] = 24.69, ["Neon|Fly"] = 62.34, ["Neon|Ride"] = 49.81, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 137.82, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 139.62, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 39.86, ["Ride"] = 52.41, ["Fly|Ride"] = 78.75, ["Neon"] = 94.37, ["Neon|Ride"] = 264.88, ["Neon|Fly|Ride"] = 312.51, ["Mega|Ride"] = 1413.09, ["Mega|Fly|Ride"] = 943.43}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 556.12, ["Fly"] = 899.07, ["Ride"] = 563.84, ["Fly|Ride"] = 577.48, ["Neon"] = 1906.96, ["Neon|Ride"] = 1771.88, ["Neon|Fly|Ride"] = 1784.62, ["Mega|Fly|Ride"] = 5250}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 551.25, ["Ride"] = 603.75, ["Fly|Ride"] = 623.44, ["Neon"] = 35310.31, ["Neon|Ride"] = 4068.75, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 1413.09}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 15.67, ["Fly"] = 26.25, ["Ride"] = 24.94, ["Fly|Ride"] = 41.33, ["Neon"] = 211.91, ["Neon|Ride"] = 99.6, ["Neon|Fly|Ride"] = 105, ["Mega"] = 787.5, ["Mega|Fly|Ride"] = 578.86}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 6.55, ["Ride"] = 22.32, ["Fly|Ride"] = 59.07, ["Neon"] = 125.84, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 1692.75, ["Mega|Ride"] = 448.09, ["Mega|Fly|Ride"] = 1207.5}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 4.87, ["Ride"] = 31.5, ["Fly|Ride"] = 87.93, ["Neon"] = 19.69, ["Neon|Fly"] = 113.37, ["Neon|Ride"] = 48.75, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 134.55, ["Mega|Fly"] = 405.68, ["Mega|Ride"] = 186.38, ["Mega|Fly|Ride"] = 330.75}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 45.94, ["Fly"] = 56.81, ["Ride"] = 44.63, ["Fly|Ride"] = 98.63, ["Neon"] = 235.9, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 239.4, ["Mega|Fly|Ride"] = 833.02}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 45.93, ["Ride"] = 91.88, ["Fly|Ride"] = 449.61, ["Neon"] = 298.73, ["Neon|Ride"] = 253.87, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1363.31, ["Mega|Ride"] = 1481.96, ["Mega|Fly|Ride"] = 1553.99}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 18.79, ["Fly"] = 57.14, ["Ride"] = 36.58, ["Fly|Ride"] = 70.79, ["Neon"] = 118.13, ["Neon|Ride"] = 99.7, ["Neon|Fly|Ride"] = 160.13, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 535.4}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 27.57, ["Fly"] = 99.6, ["Ride"] = 39.38, ["Fly|Ride"] = 74.68, ["Neon"] = 351.74, ["Neon|Ride"] = 141.06, ["Neon|Fly|Ride"] = 210.31, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1179.29}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.12, ["Fly"] = 31.49, ["Ride"] = 17.07, ["Fly|Ride"] = 46.64, ["Neon"] = 31.5, ["Neon|Ride"] = 40.3, ["Neon|Fly|Ride"] = 86.88, ["Mega"] = 183.75, ["Mega|Ride"] = 211.87, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.35, ["Fly"] = 52.5, ["Ride"] = 28.62, ["Fly|Ride"] = 71, ["Neon"] = 27.28, ["Neon|Fly"] = 158.06, ["Neon|Ride"] = 44.5, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 236.23, ["Mega|Fly"] = 480.94, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 44.63, ["Fly"] = 60.38, ["Ride"] = 55.13, ["Fly|Ride"] = 91.88, ["Neon"] = 583.75, ["Neon|Ride"] = 211.91, ["Neon|Fly|Ride"] = 221.53, ["Mega|Fly|Ride"] = 918.64}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1903.13, ["Fly"] = 2169.2, ["Ride"] = 1740.97, ["Fly|Ride"] = 1695.75, ["Neon|Ride"] = 5295.4, ["Neon|Fly|Ride"] = 3871.88, ["Mega|Fly|Ride"] = 15051.75}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 444.94, ["Fly"] = 636.82, ["Ride"] = 535.5, ["Fly|Ride"] = 550.16, ["Neon"] = 3145.52, ["Neon|Ride"] = 3107.96, ["Neon|Fly|Ride"] = 1836.82, ["Mega|Fly|Ride"] = 9745.45}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 220.16, ["Fly"] = 338.99, ["Ride"] = 272.99, ["Fly|Ride"] = 393.75, ["Neon"] = 1554.18, ["Neon|Ride"] = 1495.33, ["Neon|Fly|Ride"] = 1511.62, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 41.14}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 28.61, ["Fly"] = 65.63, ["Ride"] = 47.18, ["Fly|Ride"] = 103.69, ["Neon"] = 206.07, ["Neon|Ride"] = 253.86, ["Neon|Fly|Ride"] = 381.36, ["Mega|Ride"] = 1553.99, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 33897.19, ["Fly"] = 23625, ["Ride"] = 34781.25, ["Fly|Ride"] = 18083.61, ["Neon|Fly|Ride"] = 36164.79, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 287.44, ["Fly"] = 375.97, ["Ride"] = 262.5, ["Fly|Ride"] = 374.07, ["Neon"] = 1059.43, ["Neon|Fly"] = 1604.02, ["Neon|Ride"] = 1006.46, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 6355.74, ["Mega|Ride"] = 6603.95, ["Mega|Fly|Ride"] = 2624.99}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 105, ["Fly"] = 141.96, ["Ride"] = 126.21, ["Fly|Ride"] = 154.88, ["Neon|Fly|Ride"] = 1059.3, ["Mega|Fly|Ride"] = 4096.28}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 112.22, ["Ride"] = 133.87, ["Fly|Ride"] = 185.07, ["Neon|Ride"] = 741.5, ["Neon|Fly|Ride"] = 525, ["Mega"] = 14124.55, ["Mega|Fly|Ride"] = 1800.81}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 21, ["Fly"] = 42.39, ["Ride"] = 32.86, ["Fly|Ride"] = 98.44, ["Neon"] = 126.16, ["Neon|Ride"] = 135.19, ["Neon|Fly|Ride"] = 268.12, ["Mega"] = 1968.75, ["Mega|Fly|Ride"] = 614.4}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 5087.6, ["Ride"] = 5031.97, ["Fly|Ride"] = 4466.34, ["Neon|Ride"] = 16948.6, ["Neon|Fly|Ride"] = 17655.15, ["Mega|Fly|Ride"] = 70619.48}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 22.32, ["Fly"] = 40.69, ["Ride"] = 31.79, ["Fly|Ride"] = 47.19, ["Neon"] = 333.94, ["Neon|Ride"] = 220.54, ["Neon|Fly|Ride"] = 157.5, ["Mega|Fly|Ride"] = 685.13}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 44.61, ["Fly"] = 141.96, ["Ride"] = 47.25, ["Fly|Ride"] = 102.24, ["Neon"] = 260.66, ["Neon|Fly"] = 1413.28, ["Neon|Ride"] = 282.84, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 1101.45, ["Mega|Fly|Ride"] = 1006.69}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 609.26, ["Ride"] = 597.19, ["Fly|Ride"] = 708.75, ["Neon"] = 1680, ["Neon|Ride"] = 1573.92, ["Neon|Fly|Ride"] = 1535.63, ["Mega"] = 5401.31, ["Mega|Fly|Ride"] = 4725}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 12.96, ["Fly"] = 28.88, ["Ride"] = 24.38, ["Fly|Ride"] = 42.39, ["Neon"] = 98.44, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 129.21, ["Mega"] = 777.53, ["Mega|Fly|Ride"] = 523.68}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 17.07, ["Ride"] = 70.98, ["Fly|Ride"] = 471.78, ["Neon"] = 59.07, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 396.19, ["Mega|Ride"] = 566.06}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 91.88, ["Ride"] = 154.88, ["Fly|Ride"] = 157.5, ["Neon"] = 750.12, ["Neon|Ride"] = 735.25, ["Neon|Fly|Ride"] = 740.46, ["Mega|Fly|Ride"] = 2193.18}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 24.94, ["Ride"] = 99.6, ["Fly|Ride"] = 131.25, ["Neon"] = 94.5, ["Neon|Fly"] = 176.93, ["Neon|Ride"] = 138.55, ["Neon|Fly|Ride"] = 370.76, ["Mega"] = 275.43, ["Mega|Fly"] = 708.75, ["Mega|Ride"] = 309.3, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3202.5, ["Ride"] = 3215.63, ["Fly|Ride"] = 3176.24, ["Neon"] = 13125, ["Neon|Ride"] = 18007.89, ["Neon|Fly|Ride"] = 8491.88, ["Mega"] = 63557.21, ["Mega|Fly|Ride"] = 34468.88}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 30.19, ["Fly"] = 39.38, ["Ride"] = 70.98, ["Fly|Ride"] = 146.22, ["Neon"] = 168, ["Neon|Ride"] = 198.1, ["Neon|Fly|Ride"] = 345.34, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7087.5, ["Ride"] = 8490.79, ["Fly|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 16327.1, ["Mega|Fly|Ride"] = 60733.15}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.63, ["Fly"] = 23.5, ["Ride"] = 17.07, ["Fly|Ride"] = 28.62, ["Neon"] = 27.15, ["Neon|Fly"] = 91.8, ["Neon|Ride"] = 40.11, ["Neon|Fly|Ride"] = 76.13, ["Mega"] = 281.79, ["Mega|Ride"] = 312.51, ["Mega|Fly|Ride"] = 343.23}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 20.62, ["Fly"] = 31.85, ["Ride"] = 30.19, ["Fly|Ride"] = 55.11, ["Neon"] = 141.98, ["Neon|Fly"] = 141.98, ["Neon|Ride"] = 559.37, ["Neon|Fly|Ride"] = 210.81, ["Mega|Ride"] = 1542.85, ["Mega|Fly|Ride"] = 927.94}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.42}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 16.74, ["Ride"] = 36.63, ["Fly|Ride"] = 127.15, ["Neon"] = 158.02, ["Neon|Ride"] = 127.24, ["Neon|Fly|Ride"] = 138.78, ["Mega"] = 705.5, ["Mega|Ride"] = 989.39, ["Mega|Fly|Ride"] = 865.6}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 34.13, ["Fly"] = 262.5, ["Ride"] = 51.19, ["Fly|Ride"] = 141.98, ["Neon"] = 182.23, ["Neon|Ride"] = 154.09, ["Neon|Fly|Ride"] = 281.79, ["Mega"] = 840, ["Mega|Ride"] = 943.43, ["Mega|Fly|Ride"] = 931.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 11.81, ["Fly"] = 23.94, ["Ride"] = 22.32, ["Fly|Ride"] = 35.44, ["Neon"] = 141.61, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 168.45, ["Mega"] = 820.32, ["Mega|Ride"] = 588.48, ["Mega|Fly|Ride"] = 678.09}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8375.8}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 3122.8}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 23.63}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 141.75, ["Fly"] = 174.57, ["Ride"] = 189, ["Fly|Ride"] = 353.85}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 28.32, ["Fly"] = 133.49, ["Ride"] = 52.99, ["Fly|Ride"] = 105, ["Neon"] = 141.95, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 169.51, ["Mega|Ride"] = 813.75, ["Mega|Fly|Ride"] = 706.55}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 9.08}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 9.4, ["Neon|Ride"] = 84.76, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2572.5}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 196.41, ["Ride"] = 262.5, ["Fly|Ride"] = 10498.95, ["Neon"] = 918.75, ["Neon|Ride"] = 706.55, ["Neon|Fly|Ride"] = 792.36, ["Mega|Fly|Ride"] = 2627.04}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 120.74, ["Ride"] = 183.75, ["Fly|Ride"] = 141.98, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1051.93, ["Mega"] = 3442.7, ["Mega|Ride"] = 2260.54, ["Mega|Fly|Ride"] = 1876.02}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 177.14, ["Ride"] = 169.32, ["Fly|Ride"] = 219.93, ["Neon"] = 799.32, ["Neon|Ride"] = 840, ["Neon|Fly|Ride"] = 842.03, ["Mega"] = 4660.87, ["Mega|Fly|Ride"] = 3056.89}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1181.24, ["Fly"] = 2542.31, ["Ride"] = 1311.19, ["Fly|Ride"] = 1292.69, ["Neon"] = 5368.07, ["Neon|Ride"] = 5353.65, ["Neon|Fly|Ride"] = 4593.75, ["Mega|Fly|Ride"] = 21184.69}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 18.32, ["Fly"] = 102.61, ["Ride"] = 39.38, ["Fly|Ride"] = 84.76, ["Neon"] = 141.98, ["Neon|Ride"] = 297.19, ["Neon|Fly|Ride"] = 422.63, ["Mega"] = 846.38, ["Mega|Fly|Ride"] = 915.24}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 656.25, ["Fly"] = 2100, ["Ride"] = 688.51, ["Fly|Ride"] = 1050}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 80.07}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 15.74, ["Fly"] = 393.75, ["Ride"] = 36.75, ["Fly|Ride"] = 98.44, ["Neon"] = 90.57, ["Neon|Ride"] = 141.96, ["Neon|Fly|Ride"] = 494.7, ["Mega"] = 363.57, ["Mega|Ride"] = 441.79, ["Mega|Fly|Ride"] = 847.45}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 7.86, ["Fly"] = 131.25, ["Ride"] = 27.57, ["Fly|Ride"] = 94.5, ["Neon"] = 61.37, ["Neon|Ride"] = 83.61, ["Neon|Fly|Ride"] = 167.78, ["Mega"] = 423.73, ["Mega|Ride"] = 471.72, ["Mega|Fly|Ride"] = 619.5}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 73.5}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 26.25, ["Fly"] = 108.92, ["Ride"] = 27.53, ["Fly|Ride"] = 65.54, ["Neon"] = 116.82, ["Neon|Ride"] = 158.9, ["Neon|Fly|Ride"] = 597.91, ["Mega"] = 820.97, ["Mega|Ride"] = 847.45, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 27.56, ["Fly"] = 55.44, ["Ride"] = 30.19, ["Fly|Ride"] = 63.58, ["Neon|Ride"] = 141.96, ["Neon|Fly|Ride"] = 274.32, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 5250, ["Fly"] = 11299.42, ["Ride"] = 6459.54, ["Fly|Ride"] = 4697.44, ["Neon|Ride"] = 15537.63, ["Neon|Fly|Ride"] = 9450, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 11.46, ["Fly"] = 34.13, ["Ride"] = 32.82, ["Fly|Ride"] = 84.76, ["Neon"] = 65.63, ["Neon|Ride"] = 99.6, ["Neon|Fly|Ride"] = 353.82, ["Mega"] = 528.32, ["Mega|Ride"] = 449.15, ["Mega|Fly|Ride"] = 417.38}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 26.25}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 115.5, ["Fly"] = 375, ["Ride"] = 170.63, ["Fly|Ride"] = 234.14, ["Neon"] = 418.69, ["Neon|Ride"] = 481.69, ["Neon|Fly|Ride"] = 596.72, ["Mega|Ride"] = 4237.16, ["Mega|Fly|Ride"] = 1850.59}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 77.95, ["Ride"] = 101.07, ["Fly|Ride"] = 153.57, ["Neon"] = 327.6, ["Neon|Ride"] = 346.41, ["Neon|Fly|Ride"] = 511.88, ["Mega|Ride"] = 1608.02, ["Mega|Fly|Ride"] = 1689.58}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 21, ["Fly"] = 72.17, ["Ride"] = 24.94, ["Fly|Ride"] = 66.06, ["Neon"] = 169.52, ["Neon|Ride"] = 110.25, ["Neon|Fly|Ride"] = 158.04, ["Mega"] = 692.78, ["Mega|Ride"] = 706.55, ["Mega|Fly|Ride"] = 656.22}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6.28, ["Fly"] = 49.26, ["Ride"] = 36.03, ["Fly|Ride"] = 91.88, ["Neon"] = 27.39, ["Neon|Fly"] = 184.36, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 139.1, ["Mega"] = 118.13, ["Mega|Fly"] = 7034.11, ["Mega|Ride"] = 170.62, ["Mega|Fly|Ride"] = 261.38}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 13.13, ["Fly"] = 64.32, ["Ride"] = 33.92, ["Fly|Ride"] = 74.82, ["Neon"] = 74.47, ["Neon|Ride"] = 82.69, ["Neon|Fly|Ride"] = 279.25, ["Mega"] = 328.13, ["Mega|Ride"] = 410.82, ["Mega|Fly|Ride"] = 471.72}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 23.59, ["Fly"] = 26.46, ["Ride"] = 27.57, ["Fly|Ride"] = 55.9, ["Neon"] = 254.24, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 126.36, ["Mega|Fly|Ride"] = 594.02}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 213.94}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 19.08, ["Ride"] = 95.82, ["Neon"] = 136.5, ["Neon|Ride"] = 164.07, ["Mega"] = 1176.89, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1552.92}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 170.61, ["Ride"] = 156.19, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 820.32}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 41.99, ["Fly"] = 211.99, ["Ride"] = 98.44, ["Fly|Ride"] = 269.1, ["Neon"] = 196.88, ["Neon|Fly"] = 353.85, ["Neon|Ride"] = 290.29, ["Neon|Fly|Ride"] = 420, ["Mega"] = 1144.04, ["Mega|Ride"] = 1095.32, ["Mega|Fly|Ride"] = 1063.26}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 708.74, ["Fly"] = 780.94, ["Ride"] = 712.69, ["Fly|Ride"] = 721.88, ["Neon|Ride"] = 2231.25, ["Neon|Fly|Ride"] = 2304.25, ["Mega|Fly|Ride"] = 7035}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 262.5, ["Ride"] = 330.75, ["Fly|Ride"] = 347.46, ["Neon"] = 1554.18, ["Neon|Ride"] = 2045.13, ["Neon|Fly|Ride"] = 1320.8, ["Mega"] = 6132.24, ["Mega|Fly|Ride"] = 4068.75}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 73.5}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 11.58, ["Fly"] = 31.48, ["Ride"] = 24.81, ["Fly|Ride"] = 49.81, ["Neon"] = 77.95, ["Neon|Fly"] = 230.99, ["Neon|Ride"] = 97.5, ["Neon|Fly|Ride"] = 125.01, ["Mega"] = 405.71, ["Mega|Fly|Ride"] = 452.82}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 274.32, ["Fly"] = 989.39, ["Ride"] = 315, ["Fly|Ride"] = 395.59, ["Neon"] = 989.5, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1001.74, ["Mega|Fly|Ride"] = 3658.79}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 14.43}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 97.47, ["Fly"] = 590.63, ["Ride"] = 157.5, ["Fly|Ride"] = 273, ["Neon"] = 525, ["Neon|Fly"] = 1413.28, ["Neon|Ride"] = 593.29, ["Neon|Fly|Ride"] = 635.59, ["Mega"] = 2006.3, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 139.13, ["Ride"] = 170.63, ["Fly|Ride"] = 262.9, ["Neon"] = 989.5, ["Neon|Fly"] = 1058.37, ["Neon|Ride"] = 889.82}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 5.98, ["Ride"] = 31.75, ["Fly|Ride"] = 94.37, ["Neon"] = 53.81, ["Neon|Ride"] = 61.45, ["Mega"] = 222.7, ["Mega|Ride"] = 337.89, ["Mega|Fly|Ride"] = 367.59}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 17.07, ["Fly"] = 62.99, ["Ride"] = 27.57, ["Fly|Ride"] = 65.63, ["Neon"] = 122.19, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 261.19, ["Mega|Ride"] = 634.53, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 22.97, ["Fly"] = 127.14, ["Ride"] = 62.51, ["Fly|Ride"] = 141.39, ["Neon"] = 169.32, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 271.19, ["Mega"] = 411.02, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 707.58}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 5.25, ["Fly"] = 93.22, ["Ride"] = 43.32, ["Fly|Ride"] = 111.18, ["Neon"] = 30.19, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 171.28, ["Mega"] = 128.08, ["Mega|Ride"] = 155.04, ["Mega|Fly|Ride"] = 270.4}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 262.5, ["Fly"] = 918.75, ["Ride"] = 262.5, ["Fly|Ride"] = 392.44, ["Neon"] = 1550.99, ["Neon|Ride"] = 1214.07, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 6244.51}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 89.25, ["Fly"] = 1050, ["Ride"] = 131.25, ["Fly|Ride"] = 232.29, ["Neon"] = 393.75, ["Neon|Ride"] = 459.37, ["Neon|Fly|Ride"] = 584.07, ["Mega"] = 1792.88, ["Mega|Ride"] = 1929.38, ["Mega|Fly|Ride"] = 1673}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 51.18, ["Fly"] = 167.45, ["Ride"] = 89.41, ["Fly|Ride"] = 128.63, ["Neon|Ride"] = 332.62, ["Neon|Fly|Ride"] = 460.69, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 19.08, ["Ride"] = 33.92, ["Fly|Ride"] = 282.87, ["Neon|Ride"] = 599.08, ["Neon|Fly|Ride"] = 493.65, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 18.17, ["Ride"] = 35.28, ["Fly|Ride"] = 97.48, ["Neon"] = 88.87, ["Neon|Ride"] = 109.12, ["Neon|Fly|Ride"] = 168, ["Mega"] = 409.5, ["Mega|Fly"] = 525, ["Mega|Ride"] = 394.07, ["Mega|Fly|Ride"] = 444.36}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.66, ["Fly"] = 23.63, ["Ride"] = 17.7, ["Fly|Ride"] = 94.37, ["Neon"] = 15.91, ["Neon|Ride"] = 36.03, ["Neon|Fly|Ride"] = 127.14, ["Mega"] = 101.07, ["Mega|Ride"] = 139.83, ["Mega|Fly|Ride"] = 227.07}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 958.13, ["Fly"] = 1271.16, ["Ride"] = 995.38, ["Fly|Ride"] = 1017.19, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 8518.13}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 360.15, ["Fly"] = 404.66, ["Ride"] = 315, ["Fly|Ride"] = 433.13, ["Neon"] = 1413.28, ["Neon|Ride"] = 1680, ["Neon|Fly|Ride"] = 1328.36, ["Mega"] = 10592.88, ["Mega|Fly|Ride"] = 5366.36}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 99.75, ["Ride"] = 140.44, ["Fly|Ride"] = 171.76, ["Neon"] = 385.68, ["Neon|Ride"] = 402.59, ["Neon|Fly|Ride"] = 423.11, ["Mega|Fly|Ride"] = 1886.84}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 262.5, ["Fly"] = 338.99, ["Ride"] = 272.34, ["Fly|Ride"] = 304.6, ["Neon|Ride"] = 1016.93, ["Neon|Fly|Ride"] = 974.56, ["Mega"] = 10592.88, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 26.55, ["Fly"] = 52.5, ["Ride"] = 35.44, ["Fly|Ride"] = 65.63, ["Neon"] = 157.49, ["Neon|Ride"] = 113.36, ["Neon|Fly|Ride"] = 139.83, ["Mega|Ride"] = 706.55, ["Mega|Fly|Ride"] = 618.87}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 422.77, ["Ride"] = 422.72, ["Fly|Ride"] = 453.45, ["Neon"] = 1584.98, ["Neon|Ride"] = 1693.82, ["Neon|Fly|Ride"] = 2401.42, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 6885.38}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 99.6, ["Fly"] = 126, ["Ride"] = 65.63, ["Fly|Ride"] = 105.96, ["Neon"] = 423.78, ["Neon|Ride"] = 504.74, ["Neon|Fly|Ride"] = 590.63, ["Mega|Fly|Ride"] = 1397.82}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1246.88, ["Ride"] = 1312.5, ["Fly|Ride"] = 1365, ["Neon|Fly|Ride"] = 4481.26, ["Mega"] = 50845.77, ["Mega|Fly|Ride"] = 24717.41}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 10.5, ["Fly"] = 63, ["Ride"] = 42.39, ["Fly|Ride"] = 89.25, ["Neon"] = 41.58, ["Neon|Fly"] = 156.19, ["Neon|Ride"] = 83.7, ["Neon|Fly|Ride"] = 170.47, ["Mega"] = 253.32, ["Mega|Ride"] = 263.24, ["Mega|Fly|Ride"] = 372.33}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 69.92, ["Ride"] = 75.7, ["Fly|Ride"] = 141.54, ["Neon"] = 305.13, ["Neon|Ride"] = 238.26, ["Neon|Fly|Ride"] = 549.78, ["Mega|Ride"] = 1374.97, ["Mega|Fly|Ride"] = 1403.17}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 59.07, ["Fly"] = 91.88, ["Ride"] = 65.61, ["Fly|Ride"] = 78.73, ["Neon|Ride"] = 410.82, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1387.28}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 1575, ["Ride"] = 1049.99, ["Fly|Ride"] = 987.95, ["Neon|Fly|Ride"] = 4199.99, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 525, ["Fly"] = 845.33, ["Ride"] = 559.32, ["Fly|Ride"] = 525, ["Neon|Fly|Ride"] = 1989.36, ["Mega|Fly|Ride"] = 14151.3}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 103.49, ["Fly"] = 314.88, ["Ride"] = 131.25, ["Fly|Ride"] = 198.13, ["Neon"] = 629.31, ["Neon|Ride"] = 456.75, ["Neon|Fly|Ride"] = 502.69, ["Mega"] = 4237.16, ["Mega|Ride"] = 2684.25, ["Mega|Fly|Ride"] = 2118.59}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 8.95, ["Fly"] = 39.38, ["Ride"] = 27.44, ["Fly|Ride"] = 71, ["Neon"] = 72.07, ["Neon|Ride"] = 88.99, ["Neon|Fly|Ride"] = 147.26, ["Mega"] = 761.25, ["Mega|Ride"] = 570.97, ["Mega|Fly|Ride"] = 989.39}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 35.02, ["Fly"] = 69.92, ["Ride"] = 48.57, ["Fly|Ride"] = 94.4, ["Neon"] = 204.75, ["Neon|Fly"] = 422.72, ["Neon|Ride"] = 210.81, ["Neon|Fly|Ride"] = 209.99, ["Mega"] = 1836.82, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 721.88, ["Ride"] = 872.82, ["Fly|Ride"] = 845.58, ["Neon|Ride"] = 2828.44, ["Neon|Fly|Ride"] = 2520, ["Mega|Fly|Ride"] = 21184.69}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 834.75}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4593.75, ["Ride"] = 4608.19, ["Fly|Ride"] = 4256.91, ["Neon|Ride"] = 30360.23, ["Neon|Fly|Ride"] = 21714.34, ["Mega|Fly|Ride"] = 90393.18}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 156.79, ["Fly"] = 423.73, ["Ride"] = 220.57, ["Fly|Ride"] = 423.78, ["Neon"] = 1695.07, ["Neon|Ride"] = 847.45, ["Neon|Fly|Ride"] = 1694.87, ["Mega"] = 5932.02, ["Mega|Fly|Ride"] = 5650.25}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 78.26, ["Fly"] = 282.84, ["Ride"] = 77.44, ["Fly|Ride"] = 336, ["Neon"] = 986.41, ["Neon|Ride"] = 471.39, ["Neon|Fly|Ride"] = 989.39, ["Mega|Fly|Ride"] = 2812.42}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 12.59, ["Fly"] = 57.22, ["Ride"] = 28.62, ["Fly|Ride"] = 105, ["Neon"] = 70.88, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 177.97, ["Mega"] = 697.03, ["Mega|Ride"] = 529.66, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 13.07, ["Fly"] = 28.3, ["Ride"] = 26.25, ["Fly|Ride"] = 40.11, ["Neon"] = 91.88, ["Neon|Ride"] = 84.76, ["Neon|Fly|Ride"] = 242.82, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 815.67}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 19.67, ["Fly"] = 52.5, ["Ride"] = 44.79, ["Fly|Ride"] = 91.12, ["Neon"] = 141.75, ["Neon|Ride"] = 99.61, ["Neon|Fly|Ride"] = 190.32, ["Mega|Ride"] = 565.67, ["Mega|Fly|Ride"] = 847.45}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.93, ["Fly"] = 57.22, ["Ride"] = 21.2, ["Fly|Ride"] = 63.45, ["Neon"] = 42.39, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 158.03, ["Mega|Ride"] = 239.4, ["Mega|Fly|Ride"] = 314.88}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 23.36, ["Ride"] = 57.22, ["Fly|Ride"] = 169.52, ["Neon"] = 148.1, ["Neon|Fly"] = 847.54, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 251.06, ["Mega"] = 692.78, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 847.45}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 297.01, ["Fly"] = 332.62, ["Ride"] = 291.38, ["Fly|Ride"] = 315, ["Neon"] = 868.73, ["Neon|Fly"] = 953.49, ["Neon|Ride"] = 943.69, ["Neon|Fly|Ride"] = 754.92, ["Mega"] = 6562.5, ["Mega|Fly|Ride"] = 2963.9}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.61, ["Fly"] = 20.56, ["Ride"] = 15.75, ["Fly|Ride"] = 36.75, ["Neon"] = 19.69, ["Neon|Ride"] = 37.09, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 141.52, ["Mega|Ride"] = 141.96, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 39.37, ["Fly"] = 102.47, ["Ride"] = 59.07, ["Fly|Ride"] = 110.25, ["Neon"] = 144.27, ["Neon|Fly"] = 392.44, ["Neon|Ride"] = 176.76, ["Neon|Fly|Ride"] = 245.94, ["Mega"] = 564.27, ["Mega|Ride"] = 547.3, ["Mega|Fly|Ride"] = 574.75}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 721.85, ["Fly"] = 1413.09, ["Ride"] = 752.48, ["Fly|Ride"] = 748.13, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1686.7, ["Mega|Fly|Ride"] = 3927}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 24.92, ["Fly"] = 63.7, ["Ride"] = 42.37, ["Fly|Ride"] = 79.04, ["Neon"] = 235.9, ["Neon|Fly"] = 471.78, ["Neon|Ride"] = 176.13, ["Neon|Fly|Ride"] = 210, ["Mega"] = 1575, ["Mega|Ride"] = 1130.28, ["Mega|Fly|Ride"] = 654.93}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 301.88, ["Fly"] = 341.25, ["Ride"] = 231, ["Fly|Ride"] = 288.75, ["Neon|Ride"] = 918.42, ["Neon|Fly|Ride"] = 1128.49, ["Mega|Fly|Ride"] = 4603.68}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 138.18, ["Fly"] = 179.82, ["Ride"] = 131.23, ["Fly|Ride"] = 141.75, ["Neon"] = 644.14, ["Neon|Fly"] = 644.14, ["Neon|Ride"] = 555.09, ["Neon|Fly|Ride"] = 577.8, ["Mega|Fly|Ride"] = 2099.99}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 595.95, ["Ride"] = 577.44, ["Fly|Ride"] = 678.57, ["Neon|Fly|Ride"] = 1939.51, ["Mega|Fly|Ride"] = 7217.44}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 21.62, ["Ride"] = 42.39, ["Fly|Ride"] = 129.49, ["Neon"] = 91.35, ["Neon|Fly"] = 283.07, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 211.87, ["Mega"] = 354.3, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4002.46, ["Fly"] = 4002.48, ["Ride"] = 3853.17, ["Fly|Ride"] = 3084.38, ["Neon|Fly|Ride"] = 5775, ["Mega|Fly|Ride"] = 23745.75}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 93.18, ["Fly"] = 170.63, ["Ride"] = 91.88, ["Fly|Ride"] = 131.25, ["Neon"] = 471.78, ["Neon|Ride"] = 446.25, ["Neon|Fly|Ride"] = 396.65, ["Mega|Fly|Ride"] = 1730.01}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.35, ["Fly"] = 21.19, ["Ride"] = 19.08, ["Fly|Ride"] = 42.39, ["Neon"] = 19.69, ["Neon|Fly"] = 42.24, ["Neon|Ride"] = 40.11, ["Neon|Fly|Ride"] = 80.53, ["Mega"] = 129.92, ["Mega|Fly"] = 452.82, ["Mega|Ride"] = 233.89, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.65, ["Ride"] = 27.55, ["Fly|Ride"] = 158.06, ["Neon"] = 23.73, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 175.86, ["Mega|Ride"] = 175.86, ["Mega|Fly|Ride"] = 278.2}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 45.36, ["Fly"] = 57.22, ["Ride"] = 41.99, ["Fly|Ride"] = 52.5, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 282.84, ["Mega|Fly|Ride"] = 1370.73}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 943.43, ["Ride"] = 1058.24, ["Fly|Ride"] = 1201.38, ["Neon"] = 5067.2, ["Neon|Fly|Ride"] = 4593.75}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 4817.66, ["Ride"] = 5896.37, ["Fly|Ride"] = 4928.41}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 23.61, ["Fly"] = 26.25, ["Ride"] = 28.88, ["Fly|Ride"] = 45.52, ["Neon"] = 261.86, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 131.34, ["Mega"] = 2428.13, ["Mega|Fly|Ride"] = 565.67}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 21, ["Ride"] = 31.49, ["Fly|Ride"] = 79.04, ["Neon"] = 49.88, ["Neon|Fly"] = 141.98, ["Neon|Ride"] = 84.76, ["Neon|Fly|Ride"] = 169.51, ["Mega"] = 933.52, ["Mega|Ride"] = 354.37, ["Mega|Fly|Ride"] = 518.98}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 48.44, ["Fly"] = 157.49, ["Ride"] = 54.42, ["Fly|Ride"] = 87.57, ["Neon"] = 209.51, ["Neon|Ride"] = 267.75, ["Neon|Fly|Ride"] = 275.31, ["Mega"] = 945, ["Mega|Ride"] = 1058.24, ["Mega|Fly|Ride"] = 933.37}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 217.87, ["Fly"] = 314.88, ["Ride"] = 225.52, ["Fly|Ride"] = 275.3, ["Neon"] = 1215.17, ["Neon|Ride"] = 976.5, ["Neon|Fly|Ride"] = 945, ["Mega"] = 11164.19, ["Mega|Fly|Ride"] = 3506.46}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.92, ["Ride"] = 28.62, ["Fly|Ride"] = 105, ["Neon"] = 19.04, ["Neon|Fly"] = 70.95, ["Neon|Ride"] = 92.42, ["Neon|Fly|Ride"] = 211.87, ["Mega"] = 141.75, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 367.95}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 183.75, ["Fly"] = 247.89, ["Ride"] = 210, ["Fly|Ride"] = 294.53, ["Neon"] = 808.5, ["Neon|Ride"] = 744.19, ["Neon|Fly|Ride"] = 786.19, ["Mega|Fly|Ride"] = 3300.74}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.63, ["Fly"] = 18.38, ["Ride"] = 15.75, ["Fly|Ride"] = 39.11, ["Neon"] = 26.25, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 99.6, ["Mega"] = 196.88, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 316.74}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 196.88, ["Fly"] = 236.25, ["Ride"] = 208.69, ["Fly|Ride"] = 261.19, ["Neon|Ride"] = 1130.28, ["Neon|Fly|Ride"] = 847.45, ["Mega"] = 10592.88, ["Mega|Ride"] = 6355.74, ["Mega|Fly|Ride"] = 7665.29}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 12.68, ["Fly"] = 30.74, ["Ride"] = 31.4, ["Fly|Ride"] = 67.82, ["Neon"] = 78.41, ["Neon|Fly"] = 299.59, ["Neon|Ride"] = 137.72, ["Neon|Fly|Ride"] = 198.1, ["Mega"] = 522.43, ["Mega|Ride"] = 565.67, ["Mega|Fly|Ride"] = 467.16}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 4.76, ["Ride"] = 21.92, ["Neon"] = 13.12, ["Neon|Fly"] = 66.94, ["Neon|Ride"] = 48.41, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 76.13, ["Mega|Ride"] = 114.19, ["Mega|Fly|Ride"] = 225.12}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Mega"] = 15.64, ["Mega|Ride"] = 155.7}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 5.24, ["Ride"] = 314.88, ["Fly|Ride"] = 141.98, ["Neon"] = 14.04, ["Neon|Ride"] = 65.5, ["Neon|Fly|Ride"] = 156.79, ["Mega"] = 68.16, ["Mega|Fly"] = 157237.26, ["Mega|Ride"] = 94.5}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 69.59, ["Fly"] = 102.38, ["Ride"] = 104.53, ["Fly|Ride"] = 154.77, ["Neon"] = 629.83, ["Neon|Ride"] = 321.64, ["Neon|Fly|Ride"] = 347.82, ["Mega|Fly|Ride"] = 2542.31}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 28.62, ["Ride"] = 18.36, ["Fly|Ride"] = 43.32, ["Neon"] = 10.63, ["Neon|Ride"] = 31.26, ["Neon|Fly|Ride"] = 105, ["Mega"] = 86.62, ["Mega|Ride"] = 98.34, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 10.89, ["Ride"] = 91.77, ["Fly|Ride"] = 197.06, ["Neon"] = 78.75, ["Neon|Ride"] = 103.69, ["Mega"] = 459.38, ["Mega|Ride"] = 635.59, ["Mega|Fly|Ride"] = 777.53}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Ride"] = 30.74, ["Neon"] = 2.61, ["Neon|Ride"] = 28.77, ["Neon|Fly|Ride"] = 278.25, ["Mega"] = 15.68, ["Mega|Ride"] = 46.1, ["Mega|Fly|Ride"] = 116.82}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 21.1, ["Ride"] = 9.19, ["Fly|Ride"] = 31.86, ["Neon"] = 2.1, ["Neon|Fly"] = 16.96, ["Neon|Ride"] = 15.9, ["Neon|Fly|Ride"] = 40.11, ["Mega"] = 15.72, ["Mega|Fly"] = 28.62, ["Mega|Ride"] = 23.63, ["Mega|Fly|Ride"] = 58.56}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 15.61, ["Fly|Ride"] = 34.55, ["Neon"] = 3.92, ["Neon|Fly"] = 21.2, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 42.08, ["Mega"] = 50.86, ["Mega|Fly"] = 58.98, ["Mega|Ride"] = 39.29, ["Mega|Fly|Ride"] = 78.66}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Fly|Ride"] = 125.73, ["Neon"] = 2.23, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 58.98, ["Mega"] = 30.07, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 307.21}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 31.85, ["Fly|Ride"] = 104.51, ["Neon"] = 9.19, ["Neon|Fly"] = 135.03, ["Neon|Ride"] = 93.22, ["Neon|Fly|Ride"] = 86, ["Mega"] = 40.27, ["Mega|Fly"] = 72.19, ["Mega|Ride"] = 92, ["Mega|Fly|Ride"] = 164.2}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 6.35, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 22.32, ["Mega|Ride"] = 104.37}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 47.16, ["Ride"] = 25.96, ["Fly|Ride"] = 47.42, ["Neon"] = 6.43, ["Neon|Fly"] = 36.88, ["Neon|Ride"] = 31.33, ["Neon|Fly|Ride"] = 78.4, ["Mega"] = 73.31, ["Mega|Fly"] = 207.64, ["Mega|Ride"] = 64.13, ["Mega|Fly|Ride"] = 106.32}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 48.75, ["Neon"] = 2.1, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 313.28, ["Mega"] = 18.38, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 3.29, ["Ride"] = 52.5, ["Fly|Ride"] = 525, ["Neon"] = 22.23, ["Mega"] = 203.4, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 282.84}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 8.49, ["Mega"] = 139.13, ["Mega|Fly|Ride"] = 405.68}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 71, ["Neon"] = 6.36, ["Neon|Ride"] = 37.71, ["Neon|Fly|Ride"] = 76.29, ["Mega"] = 21, ["Mega|Fly"] = 79.46, ["Mega|Ride"] = 69.72, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 12.72, ["Ride"] = 18.8, ["Fly|Ride"] = 30.19, ["Neon"] = 2.1, ["Neon|Fly"] = 25.68, ["Neon|Ride"] = 15.54, ["Neon|Fly|Ride"] = 41.88, ["Mega"] = 15.1, ["Mega|Fly"] = 53.86, ["Mega|Ride"] = 22.79, ["Mega|Fly|Ride"] = 57.75}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 42, ["Neon"] = 26.17, ["Neon|Ride"] = 39.38, ["Mega"] = 254.2, ["Mega|Fly"] = 282.84, ["Mega|Ride"] = 353.82, ["Mega|Fly|Ride"] = 690.67}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 41.91, ["Fly|Ride"] = 78.73, ["Neon"] = 6.24, ["Neon|Ride"] = 26.99, ["Neon|Fly|Ride"] = 158.06, ["Mega"] = 28.35, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 203.79}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.1, ["Neon"] = 15.89, ["Neon|Fly|Ride"] = 141.96, ["Mega"] = 74.82, ["Mega|Ride"] = 165.26, ["Mega|Fly|Ride"] = 221.81}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 21.21, ["Ride"] = 32.81, ["Fly|Ride"] = 192.83, ["Neon"] = 116.78, ["Neon|Ride"] = 70.98, ["Neon|Fly|Ride"] = 127.14, ["Mega"] = 70.97, ["Mega|Ride"] = 85.3, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 13.12, ["Fly|Ride"] = 35.81, ["Neon"] = 2.2, ["Neon|Fly"] = 15.74, ["Neon|Ride"] = 14.04, ["Neon|Fly|Ride"] = 27.56, ["Mega"] = 15.43, ["Mega|Fly"] = 40.27, ["Mega|Ride"] = 21, ["Mega|Fly|Ride"] = 52.34}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 23.94, ["Ride"] = 19.65, ["Fly|Ride"] = 48.57, ["Neon"] = 22.36, ["Neon|Ride"] = 113.23, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 78.75, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 4.19, ["Fly"] = 41.91, ["Ride"] = 30.68, ["Fly|Ride"] = 141.39, ["Neon"] = 74.75, ["Neon|Ride"] = 99.6, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 310.7, ["Mega|Ride"] = 276.94, ["Mega|Fly|Ride"] = 387.85}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 13.02, ["Ride"] = 15.8, ["Fly|Ride"] = 35.44, ["Neon"] = 5.25, ["Neon|Fly"] = 20.24, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 31.49, ["Mega"] = 36.03, ["Mega|Fly"] = 156.19, ["Mega|Ride"] = 63.68, ["Mega|Fly|Ride"] = 116.53}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 176.92, ["Ride"] = 31.5, ["Neon"] = 9.03, ["Neon|Fly"] = 77.53, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 62.51, ["Mega|Fly"] = 565.67, ["Mega|Ride"] = 118.13}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 9.19, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 28.62, ["Neon|Fly|Ride"] = 141.35, ["Mega"] = 32.81, ["Mega|Ride"] = 148.6, ["Mega|Fly|Ride"] = 205.22}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 42.39, ["Neon|Ride"] = 21.2, ["Neon|Fly|Ride"] = 84, ["Mega"] = 15.1, ["Mega|Ride"] = 52.08}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 17.69, ["Ride"] = 19.08, ["Fly|Ride"] = 59.07, ["Neon"] = 11.7, ["Neon|Fly"] = 46.64, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 117.95, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 270.14}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 31.49, ["Neon"] = 10.61, ["Neon|Ride"] = 21.2, ["Mega"] = 94.35, ["Mega|Ride"] = 126.07, ["Mega|Fly|Ride"] = 235.87}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 32.45, ["Ride"] = 17.07, ["Fly|Ride"] = 126.21, ["Neon"] = 9.45, ["Neon|Fly"] = 107.34, ["Neon|Ride"] = 19.67, ["Neon|Fly|Ride"] = 48.57, ["Mega"] = 65.63, ["Mega|Fly"] = 127.14, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 3.92, ["Ride"] = 82.6, ["Neon"] = 57.04, ["Mega"] = 282.84, ["Mega|Fly|Ride"] = 844.06}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 21.27, ["Fly|Ride"] = 5425.33, ["Neon"] = 15.27, ["Neon|Fly"] = 59.35, ["Neon|Ride"] = 21.25, ["Neon|Fly|Ride"] = 113.3, ["Mega"] = 150.94, ["Mega|Fly|Ride"] = 283.03}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 5.24, ["Fly"] = 19.65, ["Ride"] = 20.89, ["Fly|Ride"] = 141.98, ["Neon"] = 18.38, ["Neon|Fly"] = 62.5, ["Neon|Ride"] = 38.14, ["Neon|Fly|Ride"] = 84.62, ["Mega"] = 157.5, ["Mega|Ride"] = 124.38, ["Mega|Fly|Ride"] = 209.98}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 3.93, ["Fly"] = 79.47, ["Fly|Ride"] = 106.16, ["Neon"] = 23, ["Neon|Ride"] = 157.86, ["Mega"] = 202.06, ["Mega|Ride"] = 367.59, ["Mega|Fly|Ride"] = 207.64}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 157.39, ["Mega"] = 577.5, ["Mega|Ride"] = 672.66, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 3.92, ["Ride"] = 35.38, ["Neon"] = 87.26, ["Neon|Ride"] = 105, ["Mega"] = 212.62, ["Mega|Ride"] = 367.5}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 11.8, ["Ride"] = 36.75, ["Fly|Ride"] = 55.44, ["Neon"] = 78.75, ["Neon|Ride"] = 117.59, ["Neon|Fly|Ride"] = 184.33, ["Mega"] = 190.68, ["Mega|Ride"] = 253.25, ["Mega|Fly|Ride"] = 325.21}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 92.28, ["Mega"] = 18.38, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 148.29}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 49.87}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 6.15, ["Fly"] = 20.98, ["Ride"] = 21.13, ["Fly|Ride"] = 56.44, ["Neon"] = 45.56, ["Neon|Ride"] = 47.19, ["Neon|Fly|Ride"] = 80.07, ["Mega"] = 249.38, ["Mega|Ride"] = 353.07, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.36, ["Fly|Ride"] = 71, ["Neon"] = 4.19, ["Neon|Ride"] = 22.09, ["Mega"] = 70.76, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.57, ["Ride"] = 28.62, ["Fly|Ride"] = 140.27, ["Neon"] = 5.07, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 158.04, ["Mega"] = 37.97, ["Mega|Ride"] = 78.66, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.63, ["Fly"] = 45.94, ["Ride"] = 16.68, ["Fly|Ride"] = 78.41, ["Neon"] = 16.44, ["Neon|Ride"] = 27.55, ["Neon|Fly|Ride"] = 90, ["Mega"] = 133.76, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 282.84}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.61, ["Fly|Ride"] = 52.5, ["Neon"] = 38.75, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 154.49, ["Mega"] = 328.12, ["Mega|Ride"] = 315.73}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 51.91, ["Mega"] = 15.75, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 113.36}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 18.38, ["Fly|Ride"] = 57.22, ["Neon"] = 4.41, ["Neon|Fly"] = 30.19, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 99.6, ["Mega"] = 30.19, ["Mega|Fly"] = 181.16, ["Mega|Ride"] = 56.91, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 27.83, ["Ride"] = 20.14, ["Fly|Ride"] = 39.38, ["Neon"] = 7.65, ["Neon|Fly"] = 71, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 51.18, ["Mega"] = 65.63, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 158.82}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 26.23, ["Fly|Ride"] = 45.94, ["Neon"] = 3.94, ["Neon|Ride"] = 36.57, ["Neon|Fly|Ride"] = 83.7, ["Mega"] = 25.44, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 111.97}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 6.18, ["Neon|Ride"] = 28.62, ["Neon|Fly|Ride"] = 173.74, ["Mega"] = 19.67, ["Mega|Fly"] = 146.25, ["Mega|Ride"] = 88.99, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 26.17, ["Ride"] = 28.14, ["Fly|Ride"] = 77.37, ["Neon"] = 5.24, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 23.94, ["Mega|Ride"] = 63.48, ["Mega|Fly|Ride"] = 126.95}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Mega"] = 32.82, ["Mega|Ride"] = 235.87}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.67, ["Neon|Ride"] = 158.04, ["Neon|Fly|Ride"] = 282.84, ["Mega"] = 23.49, ["Mega|Fly"] = 117.95, ["Mega|Ride"] = 113.36}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 19.69, ["Fly|Ride"] = 69.57, ["Neon"] = 3.72, ["Neon|Fly"] = 71.91, ["Neon|Ride"] = 21.2, ["Neon|Fly|Ride"] = 99.6, ["Mega"] = 63.7, ["Mega|Ride"] = 60.3, ["Mega|Fly|Ride"] = 131.19}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 11.53, ["Ride"] = 65.63, ["Fly|Ride"] = 117.6, ["Neon"] = 91.88, ["Neon|Ride"] = 235.9, ["Mega"] = 387.56, ["Mega|Ride"] = 471.72, ["Mega|Fly|Ride"] = 847.45}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 4.72, ["Fly"] = 6562.49, ["Ride"] = 68.16, ["Fly|Ride"] = 131.25, ["Neon"] = 144.38, ["Mega"] = 210.81, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 423.73}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 7.87, ["Ride"] = 28.3, ["Fly|Ride"] = 423.78, ["Neon"] = 27.2, ["Neon|Ride"] = 84.73, ["Mega"] = 224.58, ["Mega|Ride"] = 271.19, ["Mega|Fly|Ride"] = 338.63}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 15.61, ["Ride"] = 12.99, ["Fly|Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 17.22, ["Neon|Ride"] = 15.2, ["Neon|Fly|Ride"] = 30.19, ["Mega"] = 21, ["Mega|Fly"] = 22.79, ["Mega|Ride"] = 23.63, ["Mega|Fly|Ride"] = 69.92}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 4.25, ["Ride"] = 55.13, ["Neon"] = 11.94, ["Neon|Fly"] = 84.76, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 105, ["Mega"] = 156.75, ["Mega|Ride"] = 141.96}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Neon"] = 2.1, ["Neon|Fly"] = 21.15, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 70.48, ["Mega"] = 15.65, ["Mega|Fly"] = 78.4, ["Mega|Ride"] = 101.07, ["Mega|Fly|Ride"] = 103.56}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Mega"] = 19.06, ["Mega|Ride"] = 99.6, ["Mega|Fly|Ride"] = 210.81}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 15.9, ["Fly|Ride"] = 63.48, ["Neon"] = 31.86, ["Neon|Fly"] = 70.86, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 99.43, ["Mega"] = 143.21, ["Mega|Ride"] = 201.24, ["Mega|Fly|Ride"] = 254.35}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 183.75, ["Ride"] = 196.88, ["Fly|Ride"] = 190.71, ["Neon"] = 1541.07, ["Neon|Ride"] = 937.79, ["Neon|Fly|Ride"] = 1075.19, ["Mega"] = 8474.3, ["Mega|Fly|Ride"] = 3543.75}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.52, ["Neon"] = 6.56, ["Neon|Fly"] = 57.04, ["Neon|Ride"] = 68.25, ["Mega"] = 65.42, ["Mega|Ride"] = 177.97, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 5.02, ["Fly"] = 103.68, ["Ride"] = 23.33, ["Fly|Ride"] = 141.98, ["Neon"] = 28.62, ["Neon|Ride"] = 169.51, ["Neon|Fly|Ride"] = 148.32, ["Mega"] = 464.4, ["Mega|Ride"] = 389.84, ["Mega|Fly|Ride"] = 422.67}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 15.9, ["Fly|Ride"] = 34.81, ["Neon"] = 5.25, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 28.62, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 65.63, ["Mega|Fly"] = 94.35, ["Mega|Ride"] = 59.7, ["Mega|Fly|Ride"] = 104.88}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Fly|Ride"] = 52.5, ["Neon"] = 11.74, ["Neon|Fly"] = 84.76, ["Neon|Ride"] = 82.64, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 117.59, ["Mega|Ride"] = 123.38, ["Mega|Fly|Ride"] = 210.81}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 19.69, ["Fly|Ride"] = 34.13, ["Neon"] = 26.25, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 57.22, ["Mega"] = 158.52, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 4.33, ["Fly"] = 28.62, ["Ride"] = 42.39, ["Fly|Ride"] = 247.07, ["Neon"] = 45.56, ["Neon|Ride"] = 137.45, ["Neon|Fly|Ride"] = 629.24, ["Mega"] = 328.13, ["Mega|Fly|Ride"] = 398.35}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 19.05, ["Ride"] = 16.96, ["Fly|Ride"] = 36.75, ["Neon"] = 15.75, ["Neon|Fly"] = 83.58, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 68.16, ["Mega"] = 196.88, ["Mega|Fly"] = 372.88, ["Mega|Ride"] = 281.51, ["Mega|Fly|Ride"] = 189.08}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 68.25, ["Fly"] = 141.75, ["Ride"] = 91.88, ["Fly|Ride"] = 139.86, ["Neon"] = 325.26, ["Neon|Fly"] = 404.92, ["Neon|Ride"] = 378, ["Neon|Fly|Ride"] = 457.63, ["Mega"] = 1101.45, ["Mega|Fly|Ride"] = 1488.61}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 196.87, ["Fly"] = 322.17, ["Ride"] = 227.75, ["Fly|Ride"] = 203.44, ["Neon|Ride"] = 2648.23, ["Neon|Fly|Ride"] = 1096.37, ["Mega"] = 10592.88, ["Mega|Fly|Ride"] = 4096.28}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 68.23, ["Fly"] = 148.39, ["Ride"] = 75.23, ["Fly|Ride"] = 105, ["Neon"] = 379.25, ["Neon|Ride"] = 314.98, ["Neon|Fly|Ride"] = 351.93, ["Mega|Fly|Ride"] = 1241.92}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 4.6, ["Ride"] = 36.58, ["Fly|Ride"] = 84.76, ["Neon"] = 20.96, ["Neon|Ride"] = 48.72, ["Neon|Fly|Ride"] = 168.45, ["Mega"] = 314.88, ["Mega|Ride"] = 205.51, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 11.81, ["Fly"] = 68.14, ["Ride"] = 35.38, ["Fly|Ride"] = 78.75, ["Neon"] = 64.97, ["Neon|Fly"] = 105, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 211.87, ["Mega"] = 261.19, ["Mega|Ride"] = 381.36, ["Mega|Fly|Ride"] = 415.26}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 19.08, ["Ride"] = 20.83, ["Fly|Ride"] = 55.32, ["Neon"] = 3.94, ["Neon|Fly"] = 115.5, ["Neon|Ride"] = 21.21, ["Neon|Fly|Ride"] = 78.4, ["Mega"] = 72.05, ["Mega|Fly"] = 209.92, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 197.35}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.54, ["Fly"] = 68.49, ["Ride"] = 28.44, ["Fly|Ride"] = 131.25, ["Neon"] = 23.83, ["Neon|Ride"] = 141.96, ["Neon|Fly|Ride"] = 79.03, ["Mega"] = 791.31, ["Mega|Ride"] = 294, ["Mega|Fly|Ride"] = 565.67}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 18.17, ["Ride"] = 16.95, ["Fly|Ride"] = 42, ["Neon"] = 10.5, ["Neon|Fly"] = 131.14, ["Neon|Ride"] = 28.62, ["Neon|Fly|Ride"] = 99.49, ["Mega"] = 131.25, ["Mega|Ride"] = 141.88, ["Mega|Fly|Ride"] = 175.88}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 3.65, ["Ride"] = 27.15, ["Fly|Ride"] = 328.13, ["Neon"] = 23.63, ["Neon|Ride"] = 70.98, ["Neon|Fly|Ride"] = 235.87, ["Mega"] = 282.84, ["Mega|Ride"] = 141.52, ["Mega|Fly|Ride"] = 244.36}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 28.62, ["Neon"] = 2.24, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 15.75, ["Mega|Ride"] = 50.86, ["Mega|Fly|Ride"] = 198.1}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 3.92, ["Fly"] = 45.93, ["Ride"] = 20.89, ["Fly|Ride"] = 39.38, ["Neon"] = 13.13, ["Neon|Fly"] = 105.96, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 49.88, ["Mega"] = 108.89, ["Mega|Ride"] = 96.49, ["Mega|Fly|Ride"] = 193.41}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 3.73, ["Ride"] = 18.02, ["Fly|Ride"] = 39.29, ["Neon"] = 63.71, ["Neon|Fly"] = 141.98, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 63, ["Mega"] = 269.08, ["Mega|Ride"] = 205.22, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 124.69, ["Fly"] = 231.99, ["Ride"] = 185.07, ["Fly|Ride"] = 245, ["Neon"] = 594.51, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 594.56, ["Mega|Ride"] = 3478.13, ["Mega|Fly|Ride"] = 2081.24}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 6.25, ["Ride"] = 30.19, ["Fly|Ride"] = 206.07, ["Neon"] = 43.32, ["Neon|Ride"] = 81.29, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 307.47, ["Mega|Ride"] = 347.9, ["Mega|Fly|Ride"] = 550.85}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 31.85, ["Ride"] = 27.5, ["Fly|Ride"] = 71, ["Neon"] = 26.25, ["Neon|Ride"] = 42.39, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 141.75, ["Mega|Ride"] = 281.33, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 22.03, ["Fly"] = 59.07, ["Ride"] = 85.32, ["Fly|Ride"] = 178.5, ["Neon"] = 106.2, ["Neon|Ride"] = 141.52, ["Neon|Fly|Ride"] = 294.53, ["Mega"] = 419.88, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 537.07}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 3.93}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 6.24, ["Ride"] = 23.63, ["Neon"] = 68.25, ["Neon|Ride"] = 163.14, ["Neon|Fly|Ride"] = 635.59, ["Mega"] = 423.73, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 550.85}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 24.94, ["Fly"] = 26.24, ["Ride"] = 26.25, ["Fly|Ride"] = 59.06, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 175.85, ["Neon|Fly|Ride"] = 156.19, ["Mega"] = 2118.59, ["Mega|Ride"] = 574.32, ["Mega|Fly|Ride"] = 563.56}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Fly"] = 31.79, ["Ride"] = 26.25, ["Fly|Ride"] = 78.75, ["Neon"] = 3.93, ["Neon|Ride"] = 28.61, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 33.92, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 162.68}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 5.65, ["Fly"] = 26.25, ["Ride"] = 20.9, ["Fly|Ride"] = 78.41, ["Neon"] = 49.81, ["Neon|Ride"] = 99.6, ["Mega"] = 265.13, ["Mega|Fly"] = 393.89, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 15.9, ["Fly|Ride"] = 56.63, ["Neon"] = 14.43, ["Neon|Ride"] = 27.26, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 135.19, ["Mega|Ride"] = 124.08, ["Mega|Fly|Ride"] = 251.9}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 22.16, ["Neon"] = 6.18, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 27.57, ["Mega"] = 33.92, ["Mega|Ride"] = 63.69, ["Mega|Fly|Ride"] = 205.06}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 31.14, ["Ride"] = 76.13, ["Fly|Ride"] = 525, ["Neon"] = 157.5, ["Neon|Ride"] = 313.7, ["Mega"] = 840.66, ["Mega|Ride"] = 774.38, ["Mega|Fly|Ride"] = 871.9}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.67, ["Ride"] = 70.88, ["Fly|Ride"] = 65.63, ["Neon"] = 48.72, ["Neon|Ride"] = 78.4, ["Neon|Fly|Ride"] = 211.87, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 10.45, ["Fly"] = 131.06, ["Ride"] = 47.25, ["Fly|Ride"] = 117.96, ["Neon"] = 75.9, ["Neon|Fly"] = 211.91, ["Neon|Ride"] = 84.68, ["Neon|Fly|Ride"] = 193.87, ["Mega"] = 380.63, ["Mega|Ride"] = 349.16, ["Mega|Fly|Ride"] = 471.85}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 52.5, ["Fly"] = 141.96, ["Ride"] = 52.5, ["Fly|Ride"] = 262.44, ["Neon"] = 208.69, ["Neon|Ride"] = 393.75, ["Mega|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 2265.83}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 35.43, ["Fly"] = 131.25, ["Ride"] = 47.14, ["Fly|Ride"] = 198.13, ["Neon"] = 205.24, ["Neon|Ride"] = 113.34, ["Neon|Fly|Ride"] = 847.45, ["Mega"] = 551.25, ["Mega|Ride"] = 462.66, ["Mega|Fly|Ride"] = 565.67}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 74.74, ["Fly"] = 145.69, ["Ride"] = 98.44, ["Fly|Ride"] = 170.63, ["Neon"] = 202.92, ["Neon|Ride"] = 228.38, ["Neon|Fly|Ride"] = 314.88, ["Mega"] = 938.44, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 856.76}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 47.25, ["Ride"] = 73.5, ["Fly|Ride"] = 162.75, ["Neon"] = 97.13, ["Neon|Ride"] = 120.52, ["Neon|Fly|Ride"] = 252.39, ["Mega"] = 465.83, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 417.76}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 13.12, ["Fly"] = 69.5, ["Ride"] = 23.31, ["Neon"] = 81.54, ["Neon|Ride"] = 194.24, ["Neon|Fly|Ride"] = 99.6, ["Mega"] = 334.93, ["Mega|Ride"] = 1059.3, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 103.68, ["Ride"] = 65.63, ["Neon"] = 98.44, ["Neon|Ride"] = 185.38, ["Neon|Fly|Ride"] = 423.73, ["Mega"] = 524.36, ["Mega|Ride"] = 412.13, ["Mega|Fly|Ride"] = 691.83}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 7.87, ["Ride"] = 30.18, ["Fly|Ride"] = 139.86, ["Neon"] = 52.5, ["Neon|Ride"] = 109.73, ["Mega"] = 312.51, ["Mega|Ride"] = 295.56, ["Mega|Fly|Ride"] = 376.67}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 52.99, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 49.81, ["Mega"] = 19.05, ["Mega|Fly"] = 141.96, ["Mega|Ride"] = 70.81, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 2.59, ["Ride"] = 210, ["Fly|Ride"] = 425.25, ["Neon"] = 12.16, ["Neon|Ride"] = 83.83, ["Mega"] = 124.3, ["Mega|Ride"] = 209.75, ["Mega|Fly|Ride"] = 448.13}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Ride"] = 57.22, ["Neon"] = 22.32, ["Neon|Ride"] = 105.94, ["Mega"] = 181.79}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 4.46, ["Ride"] = 31.44, ["Fly|Ride"] = 116.78, ["Neon"] = 28.88, ["Neon|Ride"] = 82.95, ["Neon|Fly|Ride"] = 281.79, ["Mega"] = 123.38, ["Mega|Ride"] = 152.97, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 489.57, ["Ride"] = 526.35, ["Fly|Ride"] = 551.25, ["Neon|Ride"] = 1766.91, ["Neon|Fly|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 5099.98}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 7.88, ["Fly"] = 57.22, ["Ride"] = 25.18, ["Fly|Ride"] = 42, ["Neon"] = 42.39, ["Neon|Ride"] = 77.84, ["Neon|Fly|Ride"] = 174.56, ["Mega"] = 240.48, ["Mega|Ride"] = 275.43, ["Mega|Fly|Ride"] = 367.59}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 9.18, ["Fly"] = 39.38, ["Ride"] = 28.62, ["Fly|Ride"] = 84.76, ["Neon"] = 78.41, ["Neon|Fly"] = 315, ["Neon|Ride"] = 59.07, ["Mega"] = 269.08, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 393.02}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.1, ["Fly"] = 28.62, ["Ride"] = 21.67, ["Fly|Ride"] = 141.98, ["Neon"] = 37.09, ["Neon|Ride"] = 196.87, ["Mega"] = 223.13, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 31.77, ["Fly|Ride"] = 941.48, ["Neon"] = 10.35, ["Neon|Fly"] = 71, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 122.9, ["Mega"] = 65.63, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 175.34}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 70.98, ["Ride"] = 70.98, ["Neon"] = 3.83, ["Neon|Ride"] = 75.23, ["Neon|Fly|Ride"] = 158.04, ["Mega"] = 26.64, ["Mega|Ride"] = 107.34, ["Mega|Fly|Ride"] = 209.35}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1270.1}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 15.72, ["Fly"] = 57.22, ["Ride"] = 51.61, ["Neon"] = 59.07, ["Neon|Fly"] = 141.98, ["Neon|Ride"] = 94.32, ["Mega"] = 650.42, ["Mega|Ride"] = 608.5, ["Mega|Fly|Ride"] = 673.38}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 38.07, ["Neon"] = 8.43, ["Neon|Ride"] = 42.39, ["Mega"] = 102.61, ["Mega|Ride"] = 136.86, ["Mega|Fly|Ride"] = 235.87}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.63, ["Fly"] = 42.39, ["Ride"] = 20.14, ["Fly|Ride"] = 525, ["Neon"] = 10.58, ["Neon|Ride"] = 63.57, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 183.74, ["Mega|Ride"] = 152.25, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 397.08, ["Ride"] = 446.25, ["Fly|Ride"] = 459.38, ["Neon"] = 1376.2, ["Neon|Ride"] = 1299.38, ["Neon|Fly|Ride"] = 1886.84, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 7.85, ["Fly"] = 196.88, ["Ride"] = 72.19, ["Neon"] = 63.58, ["Neon|Ride"] = 131.25, ["Mega"] = 345.17, ["Mega|Ride"] = 448.13, ["Mega|Fly|Ride"] = 494.7}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Ride"] = 28.62, ["Neon"] = 5.24, ["Neon|Ride"] = 39.86, ["Neon|Fly|Ride"] = 103.43, ["Mega"] = 38.72, ["Mega|Fly"] = 189, ["Mega|Ride"] = 79.03, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.93, ["Neon|Ride"] = 98.28, ["Neon|Fly|Ride"] = 269.08, ["Mega"] = 21, ["Mega|Ride"] = 80.53, ["Mega|Fly|Ride"] = 190.68}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 12.96, ["Fly"] = 56.27, ["Ride"] = 30.19, ["Fly|Ride"] = 141.98, ["Neon"] = 82.69, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 354.88, ["Mega"] = 328.13, ["Mega|Ride"] = 423.73, ["Mega|Fly|Ride"] = 372.75}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 20.08, ["Ride"] = 110.19, ["Neon"] = 104.89, ["Neon|Ride"] = 141.96, ["Neon|Fly|Ride"] = 126.19, ["Mega"] = 629.74, ["Mega|Ride"] = 561.29, ["Mega|Fly|Ride"] = 1082.18}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 3.51, ["Fly"] = 26.25, ["Ride"] = 26.25, ["Fly|Ride"] = 99.61, ["Neon"] = 141.74, ["Neon|Ride"] = 200.82, ["Neon|Fly|Ride"] = 79.03, ["Mega"] = 582.75, ["Mega|Ride"] = 328.02, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 15.73, ["Ride"] = 43.32, ["Fly|Ride"] = 141.54, ["Neon"] = 110.86, ["Neon|Ride"] = 156.13, ["Neon|Fly|Ride"] = 786.59, ["Mega"] = 524.36, ["Mega|Ride"] = 565.67, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 368.13, ["Ride"] = 363.51, ["Fly|Ride"] = 524.43, ["Neon"] = 1271.31, ["Neon|Ride"] = 1269.19, ["Neon|Fly|Ride"] = 1271.16, ["Mega"] = 3642.91, ["Mega|Fly|Ride"] = 3243.36}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 4.66, ["Fly"] = 25.44, ["Ride"] = 31.75, ["Fly|Ride"] = 83.75, ["Neon"] = 38.07, ["Neon|Ride"] = 134.46, ["Neon|Fly|Ride"] = 137.64, ["Mega"] = 393.75, ["Mega|Ride"] = 528.61, ["Mega|Fly|Ride"] = 542.37}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 6.57, ["Ride"] = 94.37, ["Fly|Ride"] = 282.87, ["Neon"] = 42.39, ["Neon|Fly|Ride"] = 184.33, ["Mega"] = 1130.28, ["Mega|Fly|Ride"] = 1694.87}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 18.36, ["Ride"] = 54.05, ["Fly|Ride"] = 163.16, ["Neon"] = 40.69, ["Neon|Ride"] = 105.34, ["Neon|Fly|Ride"] = 314.88, ["Mega"] = 193.45, ["Mega|Ride"] = 204.61, ["Mega|Fly|Ride"] = 320.25}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.5, ["Ride"] = 52.5, ["Fly|Ride"] = 110.88, ["Neon"] = 14.43, ["Neon|Ride"] = 45.56, ["Mega"] = 40.66, ["Mega|Fly"] = 110.87, ["Mega|Ride"] = 78.74, ["Mega|Fly|Ride"] = 235.87}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 37.41, ["Fly"] = 63.7, ["Ride"] = 78.4, ["Neon"] = 278.03, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 379.23, ["Mega"] = 1057.19, ["Mega|Ride"] = 1127.11, ["Mega|Fly|Ride"] = 1088.24}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 589.65, ["Ride"] = 30.68, ["Fly|Ride"] = 63.95, ["Neon"] = 11.82, ["Neon|Fly"] = 156.96, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 113.36, ["Mega"] = 57.22, ["Mega|Ride"] = 99.64, ["Mega|Fly|Ride"] = 190.68}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 28.62, ["Ride"] = 27.57, ["Fly|Ride"] = 80.53, ["Neon"] = 6.36, ["Neon|Fly"] = 71, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 140.15, ["Mega"] = 40.11, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 70.98, ["Mega|Fly|Ride"] = 166.38}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 3.68, ["Ride"] = 57.75, ["Fly|Ride"] = 262.5, ["Neon"] = 21, ["Neon|Ride"] = 158.04, ["Mega"] = 116.82, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 549.78}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 78.75, ["Ride"] = 86.63, ["Fly|Ride"] = 110.87, ["Neon"] = 353.85, ["Neon|Ride"] = 582.75, ["Neon|Fly|Ride"] = 627.38, ["Mega|Fly|Ride"] = 1355.82}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 262.49, ["Ride"] = 308.44, ["Fly|Ride"] = 341.25, ["Neon"] = 1059.43, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1260, ["Mega"] = 7062.28, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 6.57, ["Ride"] = 35.44, ["Neon"] = 37.02, ["Mega"] = 94.49, ["Mega|Ride"] = 166.69, ["Mega|Fly|Ride"] = 353.82}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 6.35, ["Ride"] = 36.66, ["Fly|Ride"] = 210.83, ["Neon"] = 26.23, ["Mega"] = 92.05, ["Mega|Fly|Ride"] = 325.21}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.81, ["Fly"] = 155.56, ["Ride"] = 27.57, ["Neon"] = 39.38, ["Mega"] = 508.6, ["Mega|Ride"] = 337.84}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 28.46, ["Fly|Ride"] = 49.87, ["Neon"] = 6.57, ["Neon|Ride"] = 28.62, ["Neon|Fly|Ride"] = 90.2, ["Mega"] = 32.82, ["Mega|Ride"] = 73.5, ["Mega|Fly|Ride"] = 206.07}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 58.97, ["Fly|Ride"] = 282.87, ["Neon"] = 9.19, ["Mega"] = 52.5, ["Mega|Fly"] = 141.96, ["Mega|Ride"] = 206.58}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 18.38, ["Fly|Ride"] = 41.94, ["Neon"] = 4.25, ["Neon|Fly"] = 47.19, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 39.38, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 141.52}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 24.94, ["Fly|Ride"] = 63.58, ["Neon"] = 12.99, ["Neon|Fly"] = 47.19, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 69.92, ["Mega"] = 170.63, ["Mega|Ride"] = 201.28, ["Mega|Fly|Ride"] = 435.75}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 32.6, ["Fly"] = 42.39, ["Ride"] = 41.33, ["Fly|Ride"] = 83.65, ["Neon"] = 179.82, ["Neon|Ride"] = 211.87, ["Neon|Fly|Ride"] = 706.55, ["Mega"] = 380.63, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 418.43, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 74.79, ["Ride"] = 101.07, ["Fly|Ride"] = 131.25, ["Neon"] = 366.19, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 471.19, ["Mega|Ride"] = 3241.88, ["Mega|Fly|Ride"] = 1439.27}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 23.23, ["Fly|Ride"] = 131.25, ["Neon"] = 4.24, ["Neon|Fly|Ride"] = 141.96, ["Mega"] = 56.35, ["Mega|Ride"] = 91.35}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 16.77, ["Ride"] = 18.95, ["Fly|Ride"] = 30.15, ["Neon"] = 4.19, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 24.92, ["Neon|Fly|Ride"] = 63.06, ["Mega"] = 32.73, ["Mega|Fly"] = 131.21, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 11.81, ["Ride"] = 63.71, ["Neon"] = 122.91, ["Neon|Ride"] = 141.52, ["Neon|Fly|Ride"] = 156.79, ["Mega"] = 627.38, ["Mega|Ride"] = 312.51, ["Mega|Fly|Ride"] = 472.38}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 260.6, ["Fly"] = 261.19, ["Ride"] = 422.63, ["Fly|Ride"] = 301.87, ["Neon|Ride"] = 1271.16, ["Neon|Fly|Ride"] = 1587.89, ["Mega|Fly|Ride"] = 5296.45}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 34.13, ["Fly"] = 141.96, ["Ride"] = 56.43, ["Fly|Ride"] = 112.88, ["Neon"] = 196.88, ["Neon|Ride"] = 274.4, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 1083.7, ["Mega|Ride"] = 963.69, ["Mega|Fly|Ride"] = 898.65}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Fly|Ride"] = 78.28, ["Neon"] = 9.85, ["Neon|Ride"] = 33.92, ["Neon|Fly|Ride"] = 141.96, ["Mega"] = 84, ["Mega|Ride"] = 118.6, ["Mega|Fly|Ride"] = 198.1}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 211.87, ["Ride"] = 28.88, ["Fly|Ride"] = 142.7, ["Neon"] = 30.74, ["Neon|Ride"] = 202.34, ["Mega"] = 211.11}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 28.58, ["Fly"] = 78.28, ["Ride"] = 46.6, ["Fly|Ride"] = 91.12, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 2542.31, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1101.45}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 105, ["Ride"] = 141.18, ["Fly|Ride"] = 141.75, ["Neon"] = 426.57, ["Neon|Ride"] = 469.88, ["Neon|Fly|Ride"] = 439.63, ["Mega"] = 3107.96, ["Mega|Fly|Ride"] = 1694.87}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 211.31, ["Fly"] = 504.24, ["Ride"] = 246.75, ["Fly|Ride"] = 330.75, ["Neon"] = 1059.43, ["Neon|Ride"] = 1121.8, ["Neon|Fly|Ride"] = 1158.87, ["Mega|Fly|Ride"] = 2963.9}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 13.13, ["Ride"] = 70.76, ["Fly|Ride"] = 217.03, ["Neon"] = 75.11, ["Neon|Ride"] = 144.38, ["Mega"] = 367.64, ["Mega|Ride"] = 359.09, ["Mega|Fly|Ride"] = 1059.3}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.62, ["Ride"] = 16.95, ["Fly|Ride"] = 42.39, ["Neon"] = 7.88, ["Neon|Ride"] = 21.19, ["Neon|Fly|Ride"] = 42.39, ["Mega"] = 90.57, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 6.55, ["Ride"] = 17.69, ["Fly|Ride"] = 52.5, ["Neon"] = 37.7, ["Neon|Fly"] = 148.34, ["Neon|Ride"] = 48.75, ["Neon|Fly|Ride"] = 101.71, ["Mega"] = 223.13, ["Mega|Ride"] = 216.56, ["Mega|Fly|Ride"] = 281.92}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 285.86, ["Fly"] = 494.7, ["Ride"] = 278.24, ["Fly|Ride"] = 406.88, ["Neon"] = 1356.07, ["Neon|Ride"] = 1377.09, ["Neon|Fly|Ride"] = 1836.82, ["Mega|Fly|Ride"] = 5775}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 46.64, ["Neon"] = 7.8, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 39.35, ["Mega|Ride"] = 146.21, ["Mega|Fly|Ride"] = 269.08}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.94, ["Ride"] = 21.21, ["Fly|Ride"] = 47.19, ["Neon"] = 22.31, ["Neon|Ride"] = 38.1, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 170.22, ["Mega|Ride"] = 314.88, ["Mega|Fly|Ride"] = 254.25}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 30.68, ["Ride"] = 141.98, ["Neon"] = 104.87, ["Neon|Fly"] = 282.87, ["Neon|Ride"] = 211.91, ["Neon|Fly|Ride"] = 565.67, ["Mega"] = 466.48, ["Mega|Ride"] = 465.6, ["Mega|Fly|Ride"] = 611.01}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 149.78, ["Fly"] = 172.68, ["Ride"] = 129.94, ["Fly|Ride"] = 141.75, ["Neon"] = 422.72, ["Neon|Ride"] = 563.07, ["Neon|Fly|Ride"] = 374.07, ["Mega|Fly|Ride"] = 2494.64}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 22.32, ["Fly"] = 45.05, ["Ride"] = 30.18, ["Fly|Ride"] = 53.82, ["Neon"] = 100.66, ["Neon|Ride"] = 82.38, ["Neon|Fly|Ride"] = 139.37, ["Mega"] = 706.55, ["Mega|Ride"] = 466.1, ["Mega|Fly|Ride"] = 414.59}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 24.93, ["Neon"] = 2.1, ["Neon|Ride"] = 28.62, ["Neon|Fly|Ride"] = 706.55, ["Mega"] = 20.11, ["Mega|Ride"] = 105.94, ["Mega|Fly|Ride"] = 253.19}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 52.5, ["Neon"] = 3.66, ["Neon|Fly"] = 158.06, ["Neon|Ride"] = 27.44, ["Neon|Fly|Ride"] = 69.18, ["Mega"] = 20.98, ["Mega|Fly"] = 140.35, ["Mega|Ride"] = 40.11, ["Mega|Fly|Ride"] = 103.36}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 9.18, ["Fly"] = 91.88, ["Ride"] = 52.5, ["Fly|Ride"] = 62.52, ["Neon"] = 28.53, ["Neon|Fly"] = 99.61, ["Neon|Ride"] = 87.31, ["Neon|Fly|Ride"] = 153.57, ["Mega"] = 132.97, ["Mega|Fly"] = 282.84, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 296.62}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1184.53, ["Ride"] = 1312.5, ["Fly|Ride"] = 1309.75, ["Neon|Ride"] = 7062.28, ["Neon|Fly|Ride"] = 3949.67, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 493.48, ["Ride"] = 520, ["Fly|Ride"] = 586.69, ["Neon"] = 2825.47, ["Neon|Fly|Ride"] = 2817.72, ["Mega"] = 14151.3, ["Mega|Fly|Ride"] = 7084.87}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 280.54, ["Fly"] = 396.19, ["Ride"] = 346.5, ["Fly|Ride"] = 393.75, ["Neon"] = 735, ["Neon|Ride"] = 803.06, ["Neon|Fly|Ride"] = 807.4, ["Mega"] = 5366.36, ["Mega|Fly|Ride"] = 2655.65}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 301.87, ["Fly"] = 444.91, ["Ride"] = 354.38, ["Fly|Ride"] = 452.82, ["Neon"] = 1023.75, ["Neon|Fly"] = 3145.52, ["Neon|Ride"] = 939.75, ["Neon|Fly|Ride"] = 934.5, ["Mega|Ride"] = 3675, ["Mega|Fly|Ride"] = 3655.62}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 20.25, ["Ride"] = 17.04, ["Fly|Ride"] = 44.62, ["Neon"] = 5.09, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 71.37, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 127.14}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 361.24, ["Fly"] = 590.62, ["Ride"] = 433.83, ["Fly|Ride"] = 544.69, ["Neon"] = 934.5, ["Neon|Ride"] = 1076.25, ["Neon|Fly|Ride"] = 1140.57, ["Mega"] = 6355.74, ["Mega|Ride"] = 10169.16, ["Mega|Fly|Ride"] = 4187.37}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.1, ["Fly"] = 183.75, ["Ride"] = 25.33, ["Fly|Ride"] = 39.38, ["Neon"] = 9.19, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 113.19, ["Mega"] = 63.56, ["Mega|Ride"] = 99.6, ["Mega|Fly|Ride"] = 218.09}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 20.98, ["Ride"] = 16.96, ["Fly|Ride"] = 49.88, ["Neon"] = 14.1, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 63, ["Mega"] = 91.88, ["Mega|Ride"] = 140.94, ["Mega|Fly|Ride"] = 314.62}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 4.03, ["Neon|Fly"] = 79.04, ["Neon|Ride"] = 24.38, ["Mega"] = 20.88, ["Mega|Fly"] = 70.98, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 70.96, ["Ride"] = 65.63, ["Fly|Ride"] = 459.38, ["Neon"] = 244.13, ["Neon|Ride"] = 314.84, ["Neon|Fly|Ride"] = 422.67, ["Mega"] = 1694.87, ["Mega|Fly|Ride"] = 943.43}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 65.61, ["Ride"] = 23.6, ["Fly|Ride"] = 43.32, ["Neon"] = 32.82, ["Mega"] = 328.13, ["Mega|Ride"] = 233.89}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.12, ["Neon"] = 3.93, ["Neon|Fly"] = 105.68, ["Neon|Ride"] = 36.28, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 26.17, ["Mega|Fly"] = 706.55, ["Mega|Ride"] = 50.54, ["Mega|Fly|Ride"] = 314.88}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 5.24, ["Fly"] = 26.24, ["Ride"] = 19.69, ["Fly|Ride"] = 39.11, ["Neon"] = 10.5, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 31.79, ["Neon|Fly|Ride"] = 92.17, ["Mega"] = 60.38, ["Mega|Fly"] = 175.14, ["Mega|Ride"] = 72.64, ["Mega|Fly|Ride"] = 164.15}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 5.76, ["Fly"] = 47.17, ["Ride"] = 31.85, ["Fly|Ride"] = 51.45, ["Neon"] = 42.39, ["Neon|Fly"] = 42.39, ["Neon|Ride"] = 71, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 237.57, ["Mega|Ride"] = 269.08, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 9.18, ["Ride"] = 52.41, ["Fly|Ride"] = 118.13, ["Neon"] = 78.41, ["Mega"] = 353.82, ["Mega|Ride"] = 336.87, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Ride"] = 26.17, ["Fly|Ride"] = 87.94, ["Neon"] = 141.75, ["Neon|Ride"] = 79.03, ["Neon|Fly|Ride"] = 282.84, ["Mega"] = 453.39, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 16.75, ["Ride"] = 15.75, ["Fly|Ride"] = 55.44, ["Neon"] = 3.93, ["Neon|Ride"] = 47.16, ["Mega"] = 43.32, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 317.8}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 164.06, ["Fly"] = 296.62, ["Ride"] = 258.57, ["Fly|Ride"] = 278.36, ["Neon|Ride"] = 1374.97, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 10592.88, ["Mega|Fly|Ride"] = 4434.94}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 34.16, ["Ride"] = 17.07, ["Fly|Ride"] = 41.29, ["Neon"] = 3.83, ["Neon|Fly"] = 21.2, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 49.88, ["Mega"] = 36.03, ["Mega|Ride"] = 73.05, ["Mega|Fly|Ride"] = 115.64}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 13.13, ["Ride"] = 98.44, ["Fly|Ride"] = 180.02, ["Neon"] = 65.68, ["Neon|Ride"] = 104.41, ["Mega"] = 235.87, ["Mega|Ride"] = 353.3, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 39.38, ["Fly"] = 131.25, ["Ride"] = 51.01, ["Fly|Ride"] = 141.98, ["Neon"] = 209.77, ["Neon|Ride"] = 231.67, ["Neon|Fly|Ride"] = 367.59, ["Mega"] = 766.95, ["Mega|Ride"] = 777.53, ["Mega|Fly|Ride"] = 786.59}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 157.5, ["Fly"] = 308.44, ["Ride"] = 223.13, ["Fly|Ride"] = 304.6, ["Neon"] = 841.32, ["Neon|Ride"] = 651, ["Neon|Fly|Ride"] = 866.25, ["Mega|Ride"] = 3389.73, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 19.47, ["Neon"] = 70.97, ["Neon|Ride"] = 282.84, ["Mega"] = 281.54, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 706.55}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 26.18, ["Ride"] = 279.25, ["Fly|Ride"] = 635.66, ["Neon"] = 184.36, ["Neon|Ride"] = 635.59, ["Neon|Fly|Ride"] = 847.45, ["Mega"] = 1415.14, ["Mega|Fly|Ride"] = 1271.16}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1102.48, ["Fly"] = 1441.13, ["Ride"] = 984.38, ["Fly|Ride"] = 1180.2, ["Neon|Ride"] = 5650.25, ["Neon|Fly|Ride"] = 4328.05, ["Mega|Fly|Ride"] = 17160.46}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 8.93, ["Fly"] = 25.46, ["Ride"] = 21, ["Fly|Ride"] = 63, ["Neon"] = 54.05, ["Neon|Fly"] = 111.57, ["Neon|Ride"] = 59.04, ["Neon|Fly|Ride"] = 200.82, ["Mega"] = 220.35, ["Mega|Ride"] = 226.71, ["Mega|Fly|Ride"] = 387.19}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 6.57, ["Fly"] = 13965.68, ["Ride"] = 35.43, ["Neon"] = 38.15, ["Neon|Ride"] = 140.39, ["Neon|Fly|Ride"] = 144.74, ["Mega"] = 212.63, ["Mega|Ride"] = 200.82, ["Mega|Fly|Ride"] = 469.62}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 3.66, ["Ride"] = 54.91, ["Fly|Ride"] = 28.88, ["Neon"] = 26.18, ["Neon|Ride"] = 117.95, ["Mega"] = 77.44, ["Mega|Ride"] = 271.69, ["Mega|Fly|Ride"] = 565.67}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 19.57, ["Fly"] = 706.55, ["Ride"] = 39.38, ["Fly|Ride"] = 105, ["Neon"] = 82.25, ["Neon|Ride"] = 98.98, ["Neon|Fly|Ride"] = 142.37, ["Mega"] = 391.79, ["Mega|Ride"] = 371.58, ["Mega|Fly|Ride"] = 441.55}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 3.65, ["Fly"] = 21.2, ["Ride"] = 21.2, ["Fly|Ride"] = 40.95, ["Neon"] = 22.01, ["Neon|Fly"] = 57.22, ["Neon|Ride"] = 36.12, ["Neon|Fly|Ride"] = 87.94, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 11.82, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 56.9, ["Neon|Fly|Ride"] = 110.87, ["Mega"] = 233.24, ["Mega|Ride"] = 131.15, ["Mega|Fly|Ride"] = 388.78}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 198.1, ["Ride"] = 333.38, ["Fly|Ride"] = 597.98, ["Neon|Ride"] = 1693.13, ["Neon|Fly|Ride"] = 1456.53, ["Mega|Ride"] = 5250, ["Mega|Fly|Ride"] = 4625.92}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Ride"] = 27.55, ["Fly|Ride"] = 49.55, ["Neon"] = 10.48, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 42.15, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 112.88, ["Mega|Ride"] = 103.43, ["Mega|Fly|Ride"] = 314.88}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 6.33, ["Neon"] = 42, ["Neon|Ride"] = 313.85, ["Mega"] = 279.62, ["Mega|Ride"] = 267.25}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.91, ["Fly"] = 58.27, ["Ride"] = 34.13, ["Neon"] = 19.26, ["Neon|Ride"] = 119.7, ["Neon|Fly|Ride"] = 207.18, ["Mega"] = 104.06, ["Mega|Fly"] = 423.73, ["Mega|Ride"] = 188.35, ["Mega|Fly|Ride"] = 349.79}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 177.19, ["Fly"] = 338.99, ["Ride"] = 278.54, ["Fly|Ride"] = 616.88, ["Neon"] = 660.19, ["Neon|Ride"] = 565.67, ["Neon|Fly|Ride"] = 945, ["Mega|Ride"] = 5084.59, ["Mega|Fly|Ride"] = 1900.37}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 30.19, ["Fly"] = 52.99, ["Ride"] = 149.63, ["Fly|Ride"] = 45.94, ["Neon"] = 141.75, ["Neon|Fly|Ride"] = 325.21, ["Mega"] = 593.22, ["Mega|Ride"] = 740.46, ["Mega|Fly|Ride"] = 767.57}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 22.31, ["Ride"] = 45.94, ["Fly|Ride"] = 1271.31, ["Neon"] = 91.87, ["Neon|Ride"] = 110.83, ["Neon|Fly|Ride"] = 257.25, ["Mega"] = 467.79, ["Mega|Ride"] = 459.88, ["Mega|Fly|Ride"] = 547.32}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 3.91, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.17, ["Mega"] = 34.13, ["Mega|Ride"] = 79.03, ["Mega|Fly|Ride"] = 114.19}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 66.62, ["Fly"] = 94.35, ["Ride"] = 105.51, ["Fly|Ride"] = 188, ["Neon"] = 410.01, ["Neon|Fly"] = 381.41, ["Neon|Ride"] = 381.36, ["Neon|Fly|Ride"] = 383.25, ["Mega|Fly|Ride"] = 1209.91}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 18.8, ["Neon"] = 6.57, ["Neon|Fly"] = 47.19, ["Neon|Ride"] = 57.22, ["Neon|Fly|Ride"] = 588, ["Mega"] = 40.68, ["Mega|Ride"] = 141.96}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 20.93, ["Fly"] = 32.82, ["Ride"] = 27.56, ["Fly|Ride"] = 54.28, ["Neon"] = 55.08, ["Neon|Ride"] = 110.18, ["Neon|Fly|Ride"] = 141.52, ["Mega"] = 380.63, ["Mega|Ride"] = 387.72, ["Mega|Fly|Ride"] = 356.83}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 46.19, ["Fly"] = 80.01, ["Ride"] = 85.32, ["Fly|Ride"] = 124.69, ["Neon"] = 235.9, ["Neon|Ride"] = 249.37, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 1235.15, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 12.72, ["Ride"] = 15.84, ["Fly|Ride"] = 36.58, ["Neon"] = 2.6, ["Neon|Fly"] = 16.96, ["Neon|Ride"] = 16.96, ["Neon|Fly|Ride"] = 42.26, ["Mega"] = 18.38, ["Mega|Fly"] = 117.95, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 83.73}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.91, ["Ride"] = 32.18, ["Fly|Ride"] = 105, ["Neon"] = 28.62, ["Neon|Ride"] = 94.37, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 177.19, ["Mega|Ride"] = 269.08, ["Mega|Fly|Ride"] = 314.88}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 13.12, ["Ride"] = 105, ["Neon"] = 144.38, ["Neon|Ride"] = 209.75, ["Neon|Fly|Ride"] = 358.05, ["Mega"] = 748.93, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 651}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 2.1, ["Neon|Ride"] = 28.62, ["Neon|Fly|Ride"] = 137.72, ["Mega"] = 23.59, ["Mega|Ride"] = 78.56, ["Mega|Fly|Ride"] = 311.73}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 3.93, ["Fly"] = 210, ["Ride"] = 28.76, ["Fly|Ride"] = 105, ["Neon"] = 64.58, ["Neon|Ride"] = 79.02, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 220.35, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 228.82, ["Mega|Fly|Ride"] = 423.73}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 15.72, ["Fly"] = 42.11, ["Ride"] = 23.61, ["Fly|Ride"] = 63.71, ["Neon"] = 117.03, ["Neon|Ride"] = 64.56, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 360.94, ["Mega|Fly|Ride"] = 706.55}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 2.61, ["Ride"] = 58.97, ["Neon"] = 25.7, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 200.49, ["Mega"] = 169.32, ["Mega|Ride"] = 183.26, ["Mega|Fly|Ride"] = 290.26}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 20.89, ["Fly"] = 2118.59, ["Ride"] = 79.03, ["Neon"] = 102.38, ["Neon|Ride"] = 282.84, ["Neon|Fly|Ride"] = 565.67, ["Mega"] = 652.98, ["Mega|Ride"] = 1024.42, ["Mega|Fly|Ride"] = 989.39}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 125.58, ["Fly|Ride"] = 196.87, ["Neon"] = 8.9, ["Neon|Fly"] = 50.87, ["Neon|Ride"] = 70.98, ["Neon|Fly|Ride"] = 99.08, ["Mega"] = 63.7, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 169.83, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Neon"] = 3.92, ["Mega"] = 23.63, ["Mega|Ride"] = 139.83, ["Mega|Fly|Ride"] = 421.32}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 32.82}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 65.62, ["Fly"] = 102.38, ["Ride"] = 65.63, ["Fly|Ride"] = 206.6, ["Neon"] = 1050, ["Neon|Ride"] = 224.58, ["Neon|Fly|Ride"] = 1059.3, ["Mega"] = 1116.5, ["Mega|Ride"] = 702.33, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 81.38, ["Fly|Ride"] = 141.98, ["Neon"] = 3.26, ["Mega"] = 19.69, ["Mega|Fly"] = 137.82, ["Mega|Ride"] = 99.6, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 551.25, ["Ride"] = 589.63, ["Fly|Ride"] = 525, ["Neon"] = 2397.48, ["Neon|Ride"] = 5082.48, ["Neon|Fly|Ride"] = 2401.42, ["Mega"] = 16948.6, ["Mega|Fly|Ride"] = 14118.19}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 3.68, ["Fly"] = 26.17, ["Ride"] = 41.32, ["Fly|Ride"] = 79.48, ["Neon"] = 279.7, ["Neon|Ride"] = 279.66, ["Mega"] = 82.64, ["Mega|Ride"] = 141.96, ["Mega|Fly|Ride"] = 565.67}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.1, ["Fly"] = 158.04, ["Ride"] = 23.25, ["Fly|Ride"] = 39.38, ["Neon"] = 22.32, ["Neon|Ride"] = 35.48, ["Neon|Fly|Ride"] = 63.57, ["Mega"] = 282.84, ["Mega|Ride"] = 141.52, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 12.59, ["Ride"] = 76.13, ["Fly|Ride"] = 106.31, ["Neon"] = 102.36, ["Neon|Ride"] = 54.26, ["Mega"] = 393.75, ["Mega|Ride"] = 383.25, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 31.5, ["Fly|Ride"] = 141.98, ["Neon"] = 41.33, ["Mega"] = 255.94}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 14.42, ["Ride"] = 206.07, ["Fly|Ride"] = 157.49, ["Neon"] = 166.69, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 350.44, ["Mega"] = 363.57, ["Mega|Ride"] = 338.99, ["Mega|Fly|Ride"] = 492.19}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 5.25, ["Fly"] = 98.44, ["Ride"] = 39.38, ["Fly|Ride"] = 787.5, ["Neon"] = 31.86, ["Neon|Ride"] = 93.22, ["Neon|Fly|Ride"] = 141.96, ["Mega"] = 217.88, ["Mega|Fly"] = 489.41, ["Mega|Ride"] = 243.65, ["Mega|Fly|Ride"] = 338.99}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.9, ["Fly|Ride"] = 39.29, ["Neon"] = 2.1, ["Neon|Fly"] = 28.62, ["Neon|Ride"] = 15.9, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 16.42, ["Mega|Fly"] = 79.03, ["Mega|Ride"] = 26.25, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 11.54, ["Ride"] = 39.38, ["Fly|Ride"] = 158.06, ["Neon"] = 32.82, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 317.8, ["Mega"] = 167.88, ["Mega|Ride"] = 216.12, ["Mega|Fly|Ride"] = 282.84}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 248.06, ["Ride"] = 235.87, ["Fly|Ride"] = 339.03, ["Neon"] = 1480.5, ["Neon|Ride"] = 1107.75, ["Neon|Fly|Ride"] = 2118.59, ["Mega|Fly|Ride"] = 3896.54}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 91.88, ["Fly"] = 156.79, ["Ride"] = 148.1, ["Fly|Ride"] = 7768.7, ["Neon"] = 524.43, ["Neon|Ride"] = 502.88, ["Neon|Fly|Ride"] = 623.44, ["Mega"] = 4237.16, ["Mega|Ride"] = 2118.59, ["Mega|Fly|Ride"] = 1626.95}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 21.2, ["Ride"] = 19.08, ["Fly|Ride"] = 39.34, ["Neon"] = 12.71, ["Neon|Fly"] = 18.38, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 62.67, ["Mega"] = 91.11, ["Mega|Fly"] = 210.81, ["Mega|Ride"] = 92.17, ["Mega|Fly|Ride"] = 141.93}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 15.9, ["Fly|Ride"] = 30.74, ["Neon"] = 6.46, ["Neon|Fly"] = 41.33, ["Neon|Ride"] = 22.95, ["Neon|Fly|Ride"] = 48.57, ["Mega"] = 52.5, ["Mega|Fly"] = 353.82, ["Mega|Ride"] = 93.19, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.63, ["Ride"] = 18.38, ["Fly|Ride"] = 98.44, ["Neon"] = 39.38, ["Mega"] = 1130.28}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 210, ["Ride"] = 272.99, ["Fly|Ride"] = 339.94, ["Neon|Ride"] = 1290.14, ["Neon|Fly|Ride"] = 1415.14, ["Mega|Ride"] = 8474.3, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 3.84, ["Fly"] = 20.9, ["Ride"] = 17.05, ["Fly|Ride"] = 35.44, ["Neon"] = 23.63, ["Neon|Fly"] = 158.06, ["Neon|Ride"] = 28.61, ["Neon|Fly|Ride"] = 75.02, ["Mega"] = 291.32, ["Mega|Ride"] = 252.12, ["Mega|Fly|Ride"] = 259.84}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 5.16, ["Fly"] = 141.52, ["Ride"] = 40.11, ["Fly|Ride"] = 211.91, ["Neon"] = 31.8, ["Neon|Ride"] = 38.14, ["Mega"] = 230.99, ["Mega|Ride"] = 236.24, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 4.93, ["Neon|Ride"] = 21.2, ["Neon|Fly|Ride"] = 141.96, ["Mega"] = 40.69, ["Mega|Ride"] = 95.7, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 19.43, ["Fly"] = 28.62, ["Ride"] = 23.31, ["Fly|Ride"] = 39.04, ["Neon"] = 87.95, ["Neon|Ride"] = 99.45, ["Neon|Fly|Ride"] = 180.1, ["Mega"] = 728.34, ["Mega|Ride"] = 422.61, ["Mega|Fly|Ride"] = 386.93}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 60.38, ["Fly"] = 116.82, ["Ride"] = 102.5, ["Fly|Ride"] = 249.38, ["Neon"] = 131.24, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 175.86, ["Neon|Fly|Ride"] = 338.99, ["Mega"] = 455.44, ["Mega|Fly"] = 2224.51, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 588.24}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 23.73, ["Fly"] = 63.7, ["Ride"] = 41.29, ["Fly|Ride"] = 95.82, ["Neon"] = 118.13, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 139.07, ["Neon|Fly|Ride"] = 219.19, ["Mega|Ride"] = 783.12, ["Mega|Fly|Ride"] = 667.93}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 15.9, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 23.55, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 62.51, ["Mega"] = 20.72, ["Mega|Fly"] = 28.88, ["Mega|Ride"] = 45.56, ["Mega|Fly|Ride"] = 114.35}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 204.74, ["Fly"] = 278.24, ["Ride"] = 249.64, ["Fly|Ride"] = 332.07, ["Neon"] = 892.5, ["Neon|Ride"] = 958.13, ["Neon|Fly|Ride"] = 883.46, ["Mega|Fly|Ride"] = 4168.32}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 12.99, ["Fly"] = 140.39, ["Ride"] = 42, ["Neon"] = 116.82, ["Neon|Ride"] = 200.95, ["Neon|Fly|Ride"] = 210, ["Mega"] = 485.63, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 494.82}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 25.44, ["Ride"] = 18.38, ["Fly|Ride"] = 39.3, ["Neon"] = 6.57, ["Neon|Ride"] = 31.85, ["Neon|Fly|Ride"] = 150.44, ["Mega"] = 61.46, ["Mega|Ride"] = 99.58, ["Mega|Fly|Ride"] = 299.56}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 27.56, ["Ride"] = 17.07, ["Fly|Ride"] = 56.9, ["Neon"] = 3.83, ["Neon|Fly"] = 47.19, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 97.23, ["Mega"] = 24.68, ["Mega|Fly"] = 141.52, ["Mega|Ride"] = 52.95, ["Mega|Fly|Ride"] = 140.07}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 21.15, ["Fly|Ride"] = 141.72, ["Neon"] = 7.77, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 7062.28, ["Mega"] = 92.93, ["Mega|Fly|Ride"] = 380.3}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 13.12, ["Fly"] = 65.63, ["Ride"] = 28.62, ["Fly|Ride"] = 57.22, ["Neon"] = 57.75, ["Neon|Ride"] = 60.25, ["Neon|Fly|Ride"] = 123.12, ["Mega"] = 344.36, ["Mega|Ride"] = 293.88, ["Mega|Fly|Ride"] = 343.59}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 11.82, ["Ride"] = 26.25, ["Fly|Ride"] = 72.19, ["Neon"] = 39.38, ["Neon|Ride"] = 84.76, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 223.13, ["Mega|Ride"] = 307.21, ["Mega|Fly|Ride"] = 325.21}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 44.76, ["Neon"] = 3.92, ["Neon|Ride"] = 41.29, ["Neon|Fly|Ride"] = 94.35, ["Mega"] = 26.25, ["Mega|Ride"] = 75.92, ["Mega|Fly|Ride"] = 423.73}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 6.29, ["Fly"] = 36.03, ["Ride"] = 36.04, ["Fly|Ride"] = 84.76, ["Neon"] = 24.94, ["Neon|Ride"] = 52.99, ["Neon|Fly|Ride"] = 141.74, ["Mega"] = 157.5, ["Mega|Fly"] = 269.08, ["Mega|Ride"] = 197.04, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 127.14, ["Fly|Ride"] = 99.61, ["Neon"] = 6.38, ["Neon|Fly"] = 84.76, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 158.04, ["Mega"] = 34.12, ["Mega|Ride"] = 91.34, ["Mega|Fly|Ride"] = 629.74}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 24.62, ["Ride"] = 19.08, ["Fly|Ride"] = 59.07, ["Neon"] = 6.3, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 84.99, ["Mega"] = 52.5, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 156.72}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 695.28, ["Ride"] = 721.88, ["Fly|Ride"] = 842.61, ["Neon|Ride"] = 3018.75, ["Neon|Fly|Ride"] = 3671.5, ["Mega|Fly|Ride"] = 12462.19}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 16.93, ["Fly|Ride"] = 35.43, ["Neon"] = 23.15, ["Neon|Fly"] = 44.62, ["Neon|Ride"] = 57.22, ["Neon|Fly|Ride"] = 69.92, ["Mega"] = 189.62, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.59, ["Ride"] = 69.57, ["Fly|Ride"] = 132.57, ["Neon"] = 5.25, ["Neon|Fly"] = 847.54, ["Neon|Ride"] = 82.69, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 48.47, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 282.84}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 9.97, ["Fly"] = 42.39, ["Ride"] = 23.6, ["Fly|Ride"] = 50.86, ["Neon"] = 47.18, ["Neon|Fly"] = 112.74, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 105, ["Mega"] = 312.51, ["Mega|Ride"] = 298.19, ["Mega|Fly|Ride"] = 335.99}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 15.9, ["Ride"] = 16.94, ["Fly|Ride"] = 38.15, ["Neon"] = 15.75, ["Neon|Fly"] = 130.99, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 60.4, ["Mega"] = 61.69, ["Mega|Fly"] = 349.84, ["Mega|Ride"] = 98.68, ["Mega|Fly|Ride"] = 173.03}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 47.24, ["Ride"] = 62.51, ["Neon"] = 314.92, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 360.94, ["Mega"] = 887.48, ["Mega|Fly"] = 989.39, ["Mega|Ride"] = 1003.16}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 129.94, ["Ride"] = 25.44, ["Fly|Ride"] = 89, ["Neon"] = 6.03, ["Neon|Ride"] = 28.62, ["Neon|Fly|Ride"] = 206.07, ["Mega"] = 63.66, ["Mega|Ride"] = 88.99, ["Mega|Fly|Ride"] = 349.79}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.63, ["Fly"] = 73.5, ["Ride"] = 23.63, ["Fly|Ride"] = 61.46, ["Neon"] = 15.74, ["Neon|Fly"] = 141.54, ["Neon|Ride"] = 31.8, ["Neon|Fly|Ride"] = 453.39, ["Mega"] = 65.63, ["Mega|Ride"] = 294.47, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 65.85, ["Neon"] = 15.75, ["Mega"] = 112.23}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 2593.49, ["Ride"] = 20.08, ["Fly|Ride"] = 98.44, ["Neon"] = 3.93, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 94.4, ["Mega"] = 42, ["Mega|Fly"] = 156.79, ["Mega|Ride"] = 63.57, ["Mega|Fly|Ride"] = 158.04}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 17.07, ["Fly"] = 21.05, ["Ride"] = 18.36, ["Fly|Ride"] = 41.94, ["Neon"] = 78.75, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 114.19, ["Mega"] = 847.45, ["Mega|Ride"] = 495.76, ["Mega|Fly|Ride"] = 434.44}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 784.88, ["Ride"] = 733.69, ["Fly|Ride"] = 907.88, ["Neon"] = 1938.57, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 1998.94, ["Mega|Ride"] = 5643.75, ["Mega|Fly|Ride"] = 5547.26}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 19.08, ["Ride"] = 15.91, ["Fly|Ride"] = 41.88, ["Neon"] = 2.1, ["Neon|Fly"] = 31.49, ["Neon|Ride"] = 21.17, ["Neon|Fly|Ride"] = 60.38, ["Mega"] = 45.85, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 137.72}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 3.93, ["Ride"] = 27.57, ["Fly|Ride"] = 92.18, ["Neon"] = 43.32, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 248.11, ["Mega"] = 262.71, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 454.13}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 49.23, ["Fly"] = 105.94, ["Ride"] = 86.63, ["Fly|Ride"] = 118.13, ["Neon|Ride"] = 565.67, ["Neon|Fly|Ride"] = 1240.32, ["Mega"] = 1889.78, ["Mega|Ride"] = 1553.99, ["Mega|Fly|Ride"] = 1413.09}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 43.32, ["Ride"] = 49.88, ["Fly|Ride"] = 301.88, ["Neon"] = 164.07, ["Neon|Ride"] = 185.38, ["Neon|Fly|Ride"] = 198.1, ["Mega"] = 707.62, ["Mega|Ride"] = 720.34, ["Mega|Fly|Ride"] = 994.69}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 13.11, ["Ride"] = 30.19, ["Neon"] = 58.59, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 402.54, ["Mega"] = 419.49, ["Mega|Ride"] = 393.89, ["Mega|Fly|Ride"] = 360.94}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 45.55, ["Ride"] = 99.61, ["Neon"] = 72.19, ["Neon|Fly"] = 347.94, ["Neon|Ride"] = 362.06, ["Mega"] = 315.69, ["Mega|Ride"] = 332.62, ["Mega|Fly|Ride"] = 406.79}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 26.04, ["Fly"] = 113.36, ["Ride"] = 94.35, ["Neon"] = 131.25, ["Neon|Ride"] = 158.82, ["Neon|Fly|Ride"] = 525, ["Mega"] = 654.29, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 843.29}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 14.43}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 5.36, ["Fly"] = 79.03, ["Ride"] = 31.46, ["Fly|Ride"] = 104.89, ["Neon"] = 41.32, ["Neon|Ride"] = 70.98, ["Neon|Fly|Ride"] = 169.51, ["Mega"] = 200.21, ["Mega|Fly"] = 519.75, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 276.1}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 5.99, ["Ride"] = 47.19, ["Neon"] = 31.37, ["Mega"] = 350.66, ["Mega|Fly|Ride"] = 953.38}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 58.38, ["Fly"] = 393.72, ["Ride"] = 84.68, ["Fly|Ride"] = 116.82, ["Neon"] = 232.32, ["Neon|Ride"] = 261.19, ["Neon|Fly|Ride"] = 333.5, ["Mega"] = 867.58, ["Mega|Ride"] = 878.07, ["Mega|Fly|Ride"] = 799.82}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.49, ["Fly"] = 17.05, ["Ride"] = 15.9, ["Fly|Ride"] = 43.31, ["Neon"] = 33.87, ["Neon|Fly"] = 70.88, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 77.12, ["Mega"] = 262.5, ["Mega|Fly"] = 423.73, ["Mega|Ride"] = 268.42, ["Mega|Fly|Ride"] = 244.13}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 6.22, ["Fly"] = 84.76, ["Ride"] = 26.25, ["Fly|Ride"] = 71, ["Neon"] = 21, ["Neon|Ride"] = 76.13, ["Neon|Fly|Ride"] = 126.72, ["Mega"] = 127.14, ["Mega|Fly"] = 301.45, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 252.45}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Neon|Ride"] = 201.68, ["Mega"] = 28.87, ["Mega|Ride"] = 79.19, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 69.51, ["Fly"] = 84.76, ["Ride"] = 55.44, ["Fly|Ride"] = 78.74, ["Neon"] = 181.12, ["Neon|Ride"] = 185.38, ["Neon|Fly|Ride"] = 282.84, ["Mega"] = 1130.28, ["Mega|Ride"] = 792.36, ["Mega|Fly|Ride"] = 850.5}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 28.32, ["Fly|Ride"] = 141.98, ["Neon"] = 13.13, ["Neon|Fly"] = 174.57, ["Neon|Ride"] = 70.98, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 127.14, ["Mega|Fly|Ride"] = 309.68}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 11.64, ["Neon"] = 82.69, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 353.82, ["Mega"] = 288.75, ["Mega|Ride"] = 496.13, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Ride"] = 16.96, ["Fly|Ride"] = 31.86, ["Neon"] = 19.95, ["Neon|Ride"] = 40.27, ["Neon|Fly|Ride"] = 99.43, ["Mega"] = 198.1, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 4.97, ["Fly"] = 52.5, ["Ride"] = 24.36, ["Fly|Ride"] = 65.63, ["Neon"] = 61.36, ["Neon|Ride"] = 141.96, ["Mega"] = 277.55, ["Mega|Ride"] = 247.89, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.77, ["Ride"] = 139.79, ["Neon"] = 28.28, ["Neon|Ride"] = 110.87, ["Mega"] = 141.96, ["Mega|Ride"] = 771.1}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 44.63, ["Ride"] = 91.88, ["Neon"] = 198.13, ["Neon|Ride"] = 205.24, ["Neon|Fly|Ride"] = 325.21, ["Mega"] = 1058.24, ["Mega|Ride"] = 1413.09, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 18.36, ["Ride"] = 281.61, ["Neon"] = 210, ["Neon|Ride"] = 184.33, ["Mega"] = 385.9, ["Mega|Fly|Ride"] = 570.29}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 13.13, ["Ride"] = 105, ["Neon"] = 84.76, ["Neon|Ride"] = 393.75, ["Mega"] = 593.14, ["Mega|Ride"] = 558.26, ["Mega|Fly|Ride"] = 1694.87}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 24.73, ["Ride"] = 76.27, ["Fly|Ride"] = 422.03, ["Neon"] = 141.98, ["Neon|Ride"] = 635.66, ["Mega"] = 792.36, ["Mega|Ride"] = 707.62, ["Mega|Fly|Ride"] = 740.46}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 4.12, ["Neon"] = 42.48, ["Neon|Ride"] = 423.73, ["Mega"] = 240.48, ["Mega|Fly|Ride"] = 314.88}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 21.13, ["Ride"] = 15.9, ["Fly|Ride"] = 41.91, ["Neon"] = 5.91, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 23.3, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 63.7, ["Mega|Ride"] = 79.03, ["Mega|Fly|Ride"] = 276.29}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 13.12, ["Ride"] = 48.76, ["Fly|Ride"] = 92.19, ["Neon"] = 39.38, ["Neon|Fly"] = 71, ["Neon|Ride"] = 61.45, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 117.95, ["Mega|Ride"] = 181.13, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 15.9, ["Fly|Ride"] = 55.13, ["Neon"] = 6.38, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 84.76, ["Mega"] = 47.18, ["Mega|Ride"] = 81.38, ["Mega|Fly|Ride"] = 141.96}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.67, ["Fly"] = 131.25, ["Ride"] = 63.7, ["Fly|Ride"] = 99.61, ["Neon"] = 17.64, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 113.36, ["Mega"] = 175.86, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 471.72}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.93, ["Ride"] = 30.19, ["Fly|Ride"] = 103.69, ["Neon"] = 32.82, ["Neon|Ride"] = 97.76, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 416.8, ["Mega|Fly|Ride"] = 393.89}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.91, ["Ride"] = 26.25, ["Fly|Ride"] = 39.38, ["Neon"] = 31.5, ["Neon|Fly"] = 104.77, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 100.87, ["Mega|Ride"] = 252, ["Mega|Fly|Ride"] = 359.08}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 34.07, ["Ride"] = 15.75, ["Fly|Ride"] = 63.58, ["Neon"] = 19.93, ["Neon|Fly"] = 84.76, ["Neon|Ride"] = 91.11, ["Neon|Fly|Ride"] = 79.03, ["Mega"] = 138.78, ["Mega|Ride"] = 173.74, ["Mega|Fly|Ride"] = 347.46}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 5.24, ["Fly"] = 301.88, ["Ride"] = 61.46, ["Fly|Ride"] = 108.94, ["Neon"] = 24.93, ["Neon|Fly"] = 436.94, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 190.58, ["Mega"] = 105.79, ["Mega|Fly"] = 312.51, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 311.16}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 15.9, ["Fly"] = 105, ["Ride"] = 84.62, ["Fly|Ride"] = 249.38, ["Neon"] = 103.44, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 367.5, ["Mega|Fly"] = 1968.75, ["Mega|Ride"] = 440.9, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 53.82, ["Ride"] = 84.76, ["Fly|Ride"] = 158.06, ["Neon"] = 246.88, ["Neon|Ride"] = 213.94, ["Neon|Fly|Ride"] = 369.69, ["Mega"] = 1050, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 974.91}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Ride"] = 25.51, ["Fly|Ride"] = 65.54, ["Neon"] = 3.94, ["Neon|Ride"] = 37.95, ["Neon|Fly|Ride"] = 58.35, ["Mega"] = 27.03, ["Mega|Ride"] = 71.14, ["Mega|Fly|Ride"] = 114.38}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 15.52, ["Ride"] = 353.85, ["Neon"] = 281.59, ["Mega"] = 423.73, ["Mega|Fly|Ride"] = 1271.16}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 56.44, ["Fly"] = 105, ["Ride"] = 127.14, ["Neon"] = 220.57, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 409.96, ["Mega|Ride"] = 1110.15, ["Mega|Fly|Ride"] = 1269.05}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 9.19, ["Fly"] = 190.32, ["Ride"] = 39.38, ["Fly|Ride"] = 126, ["Neon"] = 40.69, ["Neon|Ride"] = 77.44, ["Mega"] = 202.1, ["Mega|Ride"] = 195.56, ["Mega|Fly|Ride"] = 394.42}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Fly"] = 23.31, ["Ride"] = 52.47, ["Fly|Ride"] = 82.65, ["Neon"] = 6.55, ["Neon|Fly"] = 40.2, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 70.98, ["Mega"] = 32.51, ["Mega|Ride"] = 51.19, ["Mega|Fly|Ride"] = 152.22}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 20.03, ["Fly|Ride"] = 49.55, ["Neon"] = 15.54, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 156.79, ["Mega|Fly"] = 353.82, ["Mega|Ride"] = 198.65, ["Mega|Fly|Ride"] = 239.54}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 19.08, ["Ride"] = 15.74, ["Fly|Ride"] = 35.44, ["Neon"] = 2.49, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 59.33, ["Mega"] = 34.13, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 155.93}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 23, ["Fly|Ride"] = 65.7, ["Neon"] = 3.93, ["Neon|Ride"] = 28.62, ["Neon|Fly|Ride"] = 84.76, ["Mega"] = 35.96, ["Mega|Fly"] = 168, ["Mega|Ride"] = 57.22, ["Mega|Fly|Ride"] = 180.32}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 2.1, ["Neon|Ride"] = 126.27, ["Mega"] = 17.57, ["Mega|Ride"] = 104.88, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 9.43, ["Ride"] = 31.4, ["Fly|Ride"] = 262.5, ["Neon"] = 42.37, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 209.75, ["Mega"] = 198.1, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 331.42}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 11.47, ["Ride"] = 35.35, ["Fly|Ride"] = 258.51, ["Neon"] = 79.02, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 234.69, ["Mega"] = 409.89, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 9.19, ["Fly"] = 23.63, ["Ride"] = 23.79, ["Fly|Ride"] = 47.19, ["Neon"] = 52.84, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 42.47, ["Neon|Fly|Ride"] = 74.8, ["Mega|Ride"] = 334.69, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 80.04, ["Ride"] = 144.37, ["Fly|Ride"] = 262.5, ["Neon"] = 538.13, ["Neon|Ride"] = 997.5, ["Mega"] = 3145.13, ["Mega|Fly|Ride"] = 1558.23}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 25.75, ["Fly"] = 72.43, ["Ride"] = 42.21, ["Fly|Ride"] = 59.07, ["Neon"] = 93.19, ["Mega"] = 565.66, ["Mega|Ride"] = 617.54, ["Mega|Fly|Ride"] = 1033.6}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 17.93, ["Ride"] = 15.74, ["Fly|Ride"] = 36.74, ["Neon"] = 3.15, ["Neon|Fly"] = 32.85, ["Neon|Ride"] = 21.2, ["Neon|Fly|Ride"] = 47.19, ["Mega"] = 59.33, ["Mega|Ride"] = 94.65, ["Mega|Fly|Ride"] = 144.08}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 17.7, ["Ride"] = 15.9, ["Fly|Ride"] = 30.19, ["Neon"] = 4.08, ["Neon|Fly"] = 23.49, ["Neon|Ride"] = 21.2, ["Neon|Fly|Ride"] = 36.75, ["Mega"] = 47.25, ["Mega|Ride"] = 52.26, ["Mega|Fly|Ride"] = 94.07}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 393.69, ["Ride"] = 424.33, ["Fly|Ride"] = 467.98, ["Neon|Fly|Ride"] = 1509.38}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 18.77, ["Ride"] = 197.04, ["Fly|Ride"] = 98.44, ["Neon"] = 74.82, ["Mega"] = 436.42, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1101.45}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 34.13, ["Ride"] = 15.91, ["Fly|Ride"] = 32.85, ["Neon"] = 5.92, ["Neon|Fly"] = 28.5, ["Neon|Ride"] = 20.74, ["Neon|Fly|Ride"] = 39.11, ["Mega"] = 43.32, ["Mega|Ride"] = 57.11, ["Mega|Fly|Ride"] = 100.21}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 68.25, ["Ride"] = 141.52, ["Fly|Ride"] = 315, ["Neon"] = 211.91, ["Neon|Ride"] = 303.14, ["Neon|Fly|Ride"] = 366.19, ["Mega"] = 733.51, ["Mega|Ride"] = 731.56, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 17.69, ["Ride"] = 19.08, ["Fly|Ride"] = 45.94, ["Neon"] = 13.12, ["Neon|Fly"] = 92.19, ["Neon|Ride"] = 27.27, ["Neon|Fly|Ride"] = 78.17, ["Mega"] = 127.14, ["Mega|Fly"] = 160.13, ["Mega|Ride"] = 108.57, ["Mega|Fly|Ride"] = 205.65}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 70.98, ["Ride"] = 57.22, ["Fly|Ride"] = 1312.5, ["Neon"] = 3.26, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 283.29, ["Mega"] = 24.01, ["Mega|Fly"] = 96.42, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 224.58}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 56.68, ["Fly"] = 141.39, ["Ride"] = 99.65, ["Fly|Ride"] = 282.87, ["Neon"] = 174.56, ["Neon|Ride"] = 282.84, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1269.19, ["Mega|Ride"] = 692.63, ["Mega|Fly|Ride"] = 770.37}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 21.86, ["Fly|Ride"] = 39.38, ["Neon"] = 5.23, ["Neon|Ride"] = 55.1, ["Mega"] = 101.71, ["Mega|Ride"] = 121.73, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 34.48, ["Fly"] = 79.03, ["Ride"] = 50.92, ["Neon"] = 266.99, ["Neon|Ride"] = 194.93, ["Neon|Fly|Ride"] = 353.82, ["Mega|Ride"] = 1582.6, ["Mega|Fly|Ride"] = 987.95}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.94, ["Neon"] = 42.39, ["Neon|Ride"] = 203.44, ["Mega"] = 173.92, ["Mega|Ride"] = 603.75, ["Mega|Fly|Ride"] = 551.92}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 70.98, ["Ride"] = 70.89, ["Fly|Ride"] = 65.63, ["Neon"] = 12.78, ["Neon|Fly"] = 78.54, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 108.5, ["Mega"] = 78.75, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 565.67}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 31.18, ["Ride"] = 83.71, ["Fly|Ride"] = 104.81, ["Neon|Ride"] = 226.73, ["Mega|Ride"] = 1130.28, ["Mega|Fly|Ride"] = 1110.38}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 144.82, ["Ride"] = 40.27, ["Fly|Ride"] = 908.98, ["Neon"] = 6.57, ["Neon|Fly"] = 78.66, ["Neon|Ride"] = 52.99, ["Neon|Fly|Ride"] = 163.14, ["Mega"] = 36.93, ["Mega|Fly"] = 158.61, ["Mega|Ride"] = 121.84, ["Mega|Fly|Ride"] = 262.71}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 57.22, ["Ride"] = 28.53, ["Fly|Ride"] = 102.85, ["Neon"] = 5.92, ["Neon|Fly"] = 41.88, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 84.76, ["Mega"] = 105.77, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 280.23}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 11.82, ["Ride"] = 45.68, ["Fly|Ride"] = 188.72, ["Neon"] = 78.75, ["Neon|Ride"] = 120.75, ["Mega"] = 311.07, ["Mega|Ride"] = 471.72, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 57.17, ["Ride"] = 84.76, ["Fly|Ride"] = 112.12, ["Neon"] = 202.76, ["Neon|Ride"] = 269.1, ["Neon|Fly|Ride"] = 343.1, ["Mega"] = 656.24, ["Mega|Ride"] = 655.68, ["Mega|Fly|Ride"] = 695.62}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 31.85, ["Fly"] = 131.25, ["Ride"] = 35.38, ["Fly|Ride"] = 77.44, ["Neon"] = 103.69, ["Neon|Ride"] = 70.98, ["Neon|Fly|Ride"] = 141.96, ["Mega"] = 620.57, ["Mega|Ride"] = 368.65, ["Mega|Fly|Ride"] = 334.93}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 69.57, ["Ride"] = 126.2, ["Fly|Ride"] = 233.44, ["Neon"] = 262.48, ["Neon|Ride"] = 380.63, ["Neon|Fly|Ride"] = 555.19, ["Mega|Ride"] = 1273.13, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.89, ["Ride"] = 26.25, ["Fly|Ride"] = 288.75, ["Neon"] = 18.88, ["Neon|Ride"] = 58.8, ["Neon|Fly|Ride"] = 305.76, ["Mega"] = 104.99, ["Mega|Ride"] = 156.19, ["Mega|Fly|Ride"] = 314.88}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 6.06, ["Ride"] = 23.15, ["Fly|Ride"] = 103.69, ["Neon"] = 28.88, ["Neon|Ride"] = 49.88, ["Mega"] = 139.63, ["Mega|Ride"] = 282.84}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 11.65, ["Fly"] = 28.88, ["Ride"] = 44.01, ["Fly|Ride"] = 150.94, ["Neon"] = 117.96, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 169.51, ["Mega"] = 269.08, ["Mega|Ride"] = 375, ["Mega|Fly|Ride"] = 450.19}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 14.84, ["Fly|Ride"] = 31.4, ["Neon"] = 2.1, ["Neon|Fly"] = 17.05, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 35.35, ["Mega"] = 14.65, ["Mega|Fly"] = 70.98, ["Mega|Ride"] = 24.02, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 52.47, ["Fly"] = 78.4, ["Ride"] = 65.63, ["Fly|Ride"] = 303.01, ["Neon"] = 241.98, ["Neon|Fly"] = 2401.7, ["Neon|Ride"] = 293.99, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 845.33, ["Mega|Ride"] = 807.19, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 16.96, ["Fly|Ride"] = 110.19, ["Neon"] = 5.96, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 42.95, ["Mega|Fly|Ride"] = 211.87}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.48, ["Ride"] = 19.69, ["Fly|Ride"] = 57.22, ["Neon"] = 13.13, ["Neon|Fly"] = 141.98, ["Neon|Ride"] = 32.43, ["Neon|Fly|Ride"] = 57.21, ["Mega"] = 157.5, ["Mega|Ride"] = 396.19, ["Mega|Fly|Ride"] = 278.92}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 78.73, ["Ride"] = 111.57, ["Fly|Ride"] = 205.24, ["Neon"] = 308.4, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 510.57, ["Mega"] = 944.98, ["Mega|Ride"] = 917.44, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 5.25, ["Neon|Ride"] = 42.75, ["Mega"] = 40.01, ["Mega|Ride"] = 128.09, ["Mega|Fly|Ride"] = 275.43}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 15.23}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 28.62, ["Fly|Ride"] = 321.9, ["Neon"] = 8.28, ["Neon|Ride"] = 31.85, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 43.32, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 286.01}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 115.49, ["Ride"] = 179.18, ["Fly|Ride"] = 211.91, ["Neon"] = 538.13, ["Neon|Ride"] = 635.59, ["Neon|Fly|Ride"] = 671.61, ["Mega|Fly|Ride"] = 2622.81}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 7.86, ["Ride"] = 26.25, ["Neon"] = 69.92, ["Neon|Ride"] = 61.69, ["Mega"] = 165.34, ["Mega|Ride"] = 314.42, ["Mega|Fly|Ride"] = 420.67}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Neon"] = 4.6, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 36.03, ["Mega|Ride"] = 99.6, ["Mega|Fly|Ride"] = 141.96}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 5.13, ["Ride"] = 28.62, ["Neon"] = 51.1, ["Neon|Ride"] = 113.36, ["Neon|Fly|Ride"] = 156.79, ["Mega"] = 421.61, ["Mega|Ride"] = 565.67, ["Mega|Fly|Ride"] = 629.74}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 15.78, ["Fly"] = 75.23, ["Ride"] = 19.99, ["Fly|Ride"] = 157.5, ["Neon"] = 78.75, ["Neon|Ride"] = 91.11, ["Neon|Fly|Ride"] = 146.25, ["Mega"] = 459.38, ["Mega|Ride"] = 405.57, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 41.46, ["Fly|Ride"] = 282.87, ["Neon"] = 215.41, ["Neon|Ride"] = 271.23, ["Neon|Fly|Ride"] = 478.8, ["Mega"] = 702.19, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 139.08, ["Fly"] = 189.9, ["Ride"] = 157.5, ["Fly|Ride"] = 203.44, ["Neon"] = 538.01, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 549.93, ["Mega|Fly|Ride"] = 2159.07}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 10.49, ["Fly"] = 19.66, ["Ride"] = 18.35, ["Fly|Ride"] = 46.64, ["Neon"] = 62.52, ["Neon|Fly"] = 423.78, ["Neon|Ride"] = 52.89, ["Neon|Fly|Ride"] = 91.88, ["Mega|Ride"] = 565.67, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 3.7, ["Fly"] = 131.23, ["Ride"] = 23.02, ["Fly|Ride"] = 131.25, ["Neon"] = 27.36, ["Neon|Ride"] = 35.69, ["Neon|Fly|Ride"] = 192.95, ["Mega"] = 137.81, ["Mega|Ride"] = 169.51, ["Mega|Fly|Ride"] = 423.73}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 26.25, ["Fly"] = 210, ["Ride"] = 42, ["Neon"] = 79.02, ["Neon|Ride"] = 141.96, ["Mega"] = 520.13, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 49.76, ["Fly"] = 113.36, ["Ride"] = 86.89, ["Fly|Ride"] = 211.91, ["Neon"] = 196.88, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 279.57, ["Mega"] = 905.63, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 857.93}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 21.2, ["Ride"] = 81.86, ["Neon"] = 138.8, ["Neon|Ride"] = 126.62, ["Mega"] = 643.13, ["Mega|Ride"] = 707.62, ["Mega|Fly|Ride"] = 985.04}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 301.87, ["Ride"] = 330.21, ["Neon"] = 2401.7, ["Neon|Ride"] = 1115.63, ["Neon|Fly|Ride"] = 1016.93, ["Mega|Fly|Ride"] = 4194.8}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 35.32, ["Fly"] = 65.63, ["Ride"] = 28.87, ["Fly|Ride"] = 78.41, ["Neon"] = 198.13, ["Neon|Ride"] = 226.35, ["Neon|Fly|Ride"] = 326.16, ["Mega"] = 1228.79, ["Mega|Ride"] = 845.33, ["Mega|Fly|Ride"] = 706.55}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 28.62, ["Ride"] = 16.7, ["Fly|Ride"] = 28.54, ["Neon"] = 2.47, ["Neon|Ride"] = 19.08, ["Neon|Fly|Ride"] = 55.04, ["Mega"] = 22.04, ["Mega|Fly"] = 108.07, ["Mega|Ride"] = 44.39, ["Mega|Fly|Ride"] = 112.92}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 3.93, ["Ride"] = 211.02, ["Neon"] = 20.98, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 126.97, ["Mega"] = 141.96, ["Mega|Fly"] = 124.69, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 373.42}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 5.15, ["Ride"] = 28.61, ["Fly|Ride"] = 129.94, ["Neon"] = 15.91, ["Neon|Ride"] = 78.26, ["Neon|Fly|Ride"] = 141.96, ["Mega"] = 118.6, ["Mega|Fly"] = 240.48, ["Mega|Ride"] = 282.84, ["Mega|Fly|Ride"] = 235.87}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 360.94, ["Fly"] = 629.74, ["Ride"] = 380.62, ["Fly|Ride"] = 525, ["Neon"] = 1413.28, ["Neon|Fly"] = 2542.61, ["Neon|Ride"] = 1603.83, ["Neon|Fly|Ride"] = 1410.81, ["Mega|Fly|Ride"] = 4872.73}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 5.25, ["Fly"] = 47.59, ["Ride"] = 19.47, ["Fly|Ride"] = 46.64, ["Neon"] = 24.94, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 63.7, ["Mega|Ride"] = 253.36, ["Mega|Fly|Ride"] = 423.73}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 4.92, ["Fly"] = 31.77, ["Ride"] = 24.38, ["Fly|Ride"] = 39.38, ["Neon"] = 28.62, ["Neon|Ride"] = 57.22, ["Neon|Fly|Ride"] = 169.51, ["Mega"] = 423.73, ["Mega|Ride"] = 706.55, ["Mega|Fly|Ride"] = 220.35}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 6.28, ["Fly"] = 36.03, ["Ride"] = 25.44, ["Fly|Ride"] = 65.63, ["Neon"] = 12.96, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 120.74, ["Mega"] = 405.71, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 313.7}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 45.86, ["Fly"] = 210, ["Ride"] = 69.92, ["Fly|Ride"] = 59.07, ["Neon"] = 118.13, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 656.25, ["Mega|Ride"] = 846.38, ["Mega|Fly|Ride"] = 629.74}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 31.34, ["Ride"] = 28.5, ["Fly|Ride"] = 52.9, ["Neon"] = 18.38, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 210, ["Mega"] = 137.82, ["Mega|Ride"] = 169.51, ["Mega|Fly|Ride"] = 820.98}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 4.25, ["Fly"] = 104.15, ["Ride"] = 28.61, ["Fly|Ride"] = 91.88, ["Neon"] = 153.04, ["Neon|Ride"] = 105.78, ["Mega"] = 706.55, ["Mega|Ride"] = 612.28, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 40.69, ["Neon"] = 6.38, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 28.75, ["Mega"] = 36.75, ["Mega|Ride"] = 113.36, ["Mega|Fly|Ride"] = 314.88}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 6.56, ["Ride"] = 57.22, ["Neon"] = 59.07, ["Mega"] = 315.69, ["Mega|Ride"] = 362.06, ["Mega|Fly|Ride"] = 847.45}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 11.81, ["Ride"] = 54.26, ["Fly|Ride"] = 169.52, ["Neon"] = 79.69, ["Mega"] = 312.51, ["Mega|Ride"] = 557.2, ["Mega|Fly|Ride"] = 1059.3}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 11.21, ["Fly"] = 33.92, ["Ride"] = 27.57, ["Fly|Ride"] = 46.86, ["Neon"] = 31.5, ["Neon|Ride"] = 58.42, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 409.96, ["Mega|Ride"] = 375.38, ["Mega|Fly|Ride"] = 352.16}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 189.03, ["Fly"] = 205.24, ["Ride"] = 191.07, ["Fly|Ride"] = 226.38, ["Neon"] = 866.51, ["Neon|Ride"] = 871.81, ["Neon|Fly|Ride"] = 868.63, ["Mega|Fly|Ride"] = 4223.39}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Fly"] = 21.19, ["Ride"] = 16.96, ["Fly|Ride"] = 63.71, ["Neon"] = 12.39, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 114.85, ["Mega"] = 220.5, ["Mega|Ride"] = 165.26, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.94, ["Ride"] = 31.69, ["Fly|Ride"] = 103.77, ["Neon"] = 18.38, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 166.69, ["Mega"] = 221.82, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 41.99, ["Ride"] = 94.35, ["Fly|Ride"] = 371.54, ["Neon"] = 152.81, ["Neon|Ride"] = 204.67, ["Neon|Fly|Ride"] = 469.88, ["Mega"] = 367.5, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 514.45}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 83.62, ["Fly"] = 142.02, ["Ride"] = 123.36, ["Fly|Ride"] = 260.95, ["Neon"] = 422.72, ["Neon|Fly"] = 423.78, ["Neon|Ride"] = 485.62, ["Neon|Fly|Ride"] = 493.65, ["Mega|Ride"] = 1391.92, ["Mega|Fly|Ride"] = 1406.82}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 55.13, ["Ride"] = 124.69, ["Neon"] = 95.85, ["Neon|Ride"] = 144.37, ["Neon|Fly|Ride"] = 298.88, ["Mega"] = 274.89, ["Mega|Ride"] = 321.38, ["Mega|Fly|Ride"] = 437.73}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.22, ["Fly|Ride"] = 47.19, ["Neon"] = 15.91, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 57.46, ["Mega|Ride"] = 184.33, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 20.11, ["Ride"] = 71, ["Fly|Ride"] = 9181.96, ["Neon"] = 87.94, ["Neon|Ride"] = 152.58, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 206.92, ["Mega|Ride"] = 263.76, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 77.42, ["Ride"] = 119.44, ["Fly|Ride"] = 181.64, ["Neon"] = 199.5, ["Neon|Ride"] = 281.38, ["Neon|Fly|Ride"] = 389.42, ["Mega"] = 514.24, ["Mega|Ride"] = 477.75, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 120.79, ["Neon"] = 5.25, ["Neon|Ride"] = 104.76, ["Neon|Fly|Ride"] = 141.96, ["Mega"] = 49.88, ["Mega|Fly"] = 163.14, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 316.74}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 11.66, ["Ride"] = 235.9, ["Neon"] = 72.07, ["Neon|Ride"] = 664.18, ["Mega"] = 361.49, ["Mega|Fly|Ride"] = 606.98}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 961.53, ["Fly"] = 1245.33, ["Ride"] = 1049.29, ["Fly|Ride"] = 1050, ["Neon"] = 3284.21, ["Neon|Ride"] = 3389.73, ["Neon|Fly|Ride"] = 2953.13, ["Mega|Fly|Ride"] = 11090.63}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 42, ["Ride"] = 98.86, ["Neon"] = 183.16, ["Neon|Ride"] = 531.57, ["Mega"] = 847.45, ["Mega|Ride"] = 548.91, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 5.25, ["Fly"] = 49.12, ["Ride"] = 29.54, ["Fly|Ride"] = 99.75, ["Neon"] = 28.61, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 48.75, ["Neon|Fly|Ride"] = 99.6, ["Mega"] = 105.94, ["Mega|Ride"] = 133.49, ["Mega|Fly|Ride"] = 289.73}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 11.65, ["Ride"] = 131.22, ["Neon"] = 101.07, ["Mega|Ride"] = 419.49}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Fly"] = 21.2, ["Ride"] = 35.44, ["Fly|Ride"] = 423.78, ["Neon"] = 2.1, ["Neon|Ride"] = 36.03, ["Neon|Fly|Ride"] = 100.49, ["Mega"] = 20.93, ["Mega|Fly"] = 126.07, ["Mega|Ride"] = 53.43, ["Mega|Fly|Ride"] = 209.75}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 78.56, ["Ride"] = 130.95, ["Fly|Ride"] = 325.26, ["Neon"] = 297.42, ["Neon|Ride"] = 341.61, ["Neon|Fly|Ride"] = 481.98, ["Mega"] = 1092.89, ["Mega|Fly"] = 1257.39, ["Mega|Ride"] = 958.13, ["Mega|Fly|Ride"] = 1049.9}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 4.75, ["Fly"] = 101.07, ["Ride"] = 52.5, ["Fly|Ride"] = 75.24, ["Neon"] = 35.17, ["Neon|Ride"] = 84.76, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 353.82, ["Mega|Ride"] = 294.79, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.87, ["Ride"] = 26.24, ["Neon"] = 17.07, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 141.96, ["Mega"] = 147, ["Mega|Ride"] = 231.99, ["Mega|Fly|Ride"] = 375}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 52.48, ["Ride"] = 97.13, ["Fly|Ride"] = 131.25, ["Neon"] = 170.63, ["Neon|Fly"] = 280.65, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 635.59, ["Mega"] = 535.5, ["Mega|Ride"] = 502.85, ["Mega|Fly|Ride"] = 733.05}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 23.59, ["Fly"] = 57.22, ["Ride"] = 99.75, ["Fly|Ride"] = 196.88, ["Neon"] = 98.44, ["Neon|Ride"] = 211.87, ["Neon|Fly|Ride"] = 315, ["Mega"] = 624.75, ["Mega|Fly|Ride"] = 1090.46}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 49.23, ["Ride"] = 99.6, ["Neon"] = 774.38, ["Neon|Ride"] = 565.67, ["Neon|Fly|Ride"] = 952.23, ["Mega"] = 2472.39, ["Mega|Ride"] = 1822, ["Mega|Fly|Ride"] = 2118.59}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 13.13, ["Ride"] = 39.38, ["Neon"] = 30.74, ["Neon|Ride"] = 105.96, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 109.78, ["Mega|Ride"] = 139.29, ["Mega|Fly|Ride"] = 253.19}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 8.38, ["Fly"] = 33.92, ["Ride"] = 28.88, ["Fly|Ride"] = 57.22, ["Neon"] = 63.71, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 353.82, ["Mega"] = 399, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 137.39, ["Ride"] = 170.51, ["Fly|Ride"] = 236.25, ["Neon"] = 540.51, ["Neon|Ride"] = 533.96, ["Neon|Fly|Ride"] = 518.44, ["Mega|Fly"] = 2825.13, ["Mega|Ride"] = 2118.59, ["Mega|Fly|Ride"] = 1785}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 18.88, ["Ride"] = 15.9, ["Fly|Ride"] = 37.83, ["Neon"] = 15.75, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 27.19, ["Neon|Fly|Ride"] = 70.98, ["Mega"] = 140.44, ["Mega|Ride"] = 153.2, ["Mega|Fly|Ride"] = 211.87}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 3.94, ["Fly"] = 87.94, ["Ride"] = 23.62, ["Fly|Ride"] = 67.82, ["Neon"] = 35.44, ["Neon|Fly"] = 281.17, ["Neon|Ride"] = 47.18, ["Neon|Fly|Ride"] = 126.07, ["Mega"] = 170.63, ["Mega|Ride"] = 206.91, ["Mega|Fly|Ride"] = 286.47}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Ride"] = 16.96, ["Fly|Ride"] = 35.88, ["Neon"] = 2.1, ["Neon|Fly"] = 17.64, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 48.57, ["Mega"] = 14.44, ["Mega|Ride"] = 31.49, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Fly"] = 21.2, ["Ride"] = 31.8, ["Neon"] = 3.93, ["Neon|Fly"] = 42.39, ["Neon|Ride"] = 42.39, ["Mega"] = 19.69, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 141.96}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 3.92, ["Fly"] = 131.25, ["Ride"] = 72.07, ["Fly|Ride"] = 45.94, ["Neon"] = 15.1, ["Neon|Ride"] = 92.54, ["Mega"] = 134.55, ["Mega|Ride"] = 152.3}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 57.1, ["Ride"] = 105, ["Neon"] = 240.51, ["Neon|Ride"] = 451.5, ["Neon|Fly|Ride"] = 630, ["Mega"] = 564.82, ["Mega|Ride"] = 565.67, ["Mega|Fly|Ride"] = 664.18}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 3.15, ["Fly"] = 17.84, ["Ride"] = 17.07, ["Fly|Ride"] = 39.84, ["Neon"] = 9.96, ["Neon|Fly"] = 31.65, ["Neon|Ride"] = 31.85, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 91.49, ["Mega|Fly"] = 164.06, ["Mega|Ride"] = 112.87, ["Mega|Fly|Ride"] = 176.48}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 3.67, ["Fly"] = 27.57, ["Ride"] = 25.64, ["Fly|Ride"] = 60.4, ["Neon"] = 19.69, ["Neon|Fly"] = 94.37, ["Neon|Ride"] = 28.62, ["Neon|Fly|Ride"] = 78.58, ["Mega"] = 126, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 131.22, ["Mega|Fly|Ride"] = 203.82}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 3.81, ["Fly"] = 21, ["Ride"] = 19.69, ["Fly|Ride"] = 98.44, ["Neon"] = 8.49, ["Neon|Fly"] = 47.19, ["Neon|Ride"] = 23.61, ["Neon|Fly|Ride"] = 105.78, ["Mega"] = 40.27, ["Mega|Ride"] = 59.06, ["Mega|Fly|Ride"] = 119.9}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 11.82, ["Fly"] = 281.79, ["Ride"] = 24.83, ["Neon"] = 36.04, ["Neon|Ride"] = 83.7, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 299.56, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 254.25, ["Mega|Fly|Ride"] = 629.74}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 2.63, ["Fly"] = 154.67, ["Ride"] = 66, ["Fly|Ride"] = 169.52, ["Neon"] = 99.75, ["Neon|Ride"] = 78.75, ["Mega"] = 262.5, ["Mega|Ride"] = 565.67, ["Mega|Fly|Ride"] = 1059.3}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 5.25, ["Fly"] = 35.44, ["Ride"] = 23.37, ["Fly|Ride"] = 47.25, ["Neon"] = 33.92, ["Neon|Fly"] = 196.65, ["Neon|Ride"] = 63.7, ["Neon|Fly|Ride"] = 126.07, ["Mega"] = 220.35, ["Mega|Ride"] = 211.56, ["Mega|Fly|Ride"] = 342.22}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 33.92, ["Ride"] = 17.83, ["Fly|Ride"] = 52.5, ["Neon"] = 15.75, ["Neon|Fly"] = 37.09, ["Neon|Ride"] = 42.39, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 158.04, ["Mega|Ride"] = 234.63, ["Mega|Fly|Ride"] = 224.58}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 186.78, ["Fly"] = 393.75, ["Ride"] = 221.8, ["Fly|Ride"] = 305.82, ["Neon"] = 984.38, ["Neon|Ride"] = 843.21, ["Neon|Fly|Ride"] = 1179.94, ["Mega|Ride"] = 3532.73, ["Mega|Fly|Ride"] = 3155.25}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 4.31, ["Ride"] = 30.68, ["Neon"] = 30.85, ["Neon|Fly|Ride"] = 282.84, ["Mega"] = 123.38, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 494.7}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.54, ["Ride"] = 19.69, ["Fly|Ride"] = 118.13, ["Neon"] = 21.2, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 35.94, ["Neon|Fly|Ride"] = 139.65, ["Mega"] = 194.64, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 1179.29}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 9.19, ["Fly|Ride"] = 158.06, ["Neon"] = 40.69, ["Neon|Fly|Ride"] = 94.35, ["Mega"] = 470.08, ["Mega|Ride"] = 786.59, ["Mega|Fly|Ride"] = 1033.6}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.9, ["Fly|Ride"] = 36.04, ["Neon"] = 2.1, ["Neon|Fly"] = 21.2, ["Neon|Ride"] = 15.73, ["Neon|Fly|Ride"] = 41.33, ["Mega"] = 28.62, ["Mega|Fly"] = 70.98, ["Mega|Ride"] = 34.21, ["Mega|Fly|Ride"] = 82.64}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 5.12, ["Fly"] = 56.37, ["Ride"] = 22.82, ["Fly|Ride"] = 56.44, ["Neon"] = 23.33, ["Neon|Fly"] = 42.39, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 83.69, ["Mega"] = 131.6, ["Mega|Ride"] = 142.96, ["Mega|Fly|Ride"] = 283.03}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 3.94, ["Ride"] = 55.1, ["Fly|Ride"] = 77.44, ["Neon"] = 15.73, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 66.06, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 184.33}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 70.56, ["Fly"] = 102.61, ["Ride"] = 105.94, ["Fly|Ride"] = 149.7, ["Neon"] = 565.74, ["Neon|Ride"] = 402.47, ["Neon|Fly|Ride"] = 455.44, ["Mega|Ride"] = 3532.73, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 5.25, ["Fly"] = 99.6, ["Ride"] = 33.83, ["Fly|Ride"] = 65.63, ["Neon"] = 23.61, ["Neon|Ride"] = 57.22, ["Neon|Fly|Ride"] = 135.63, ["Mega"] = 216.12, ["Mega|Ride"] = 211.87, ["Mega|Fly|Ride"] = 671.61}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 31.79, ["Ride"] = 52.5, ["Fly|Ride"] = 165.29, ["Neon"] = 10.5, ["Neon|Ride"] = 57.22, ["Neon|Fly|Ride"] = 169.51, ["Mega"] = 79.03, ["Mega|Fly"] = 413.13, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 240.48}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 52.48, ["Fly"] = 124.69, ["Ride"] = 97.13, ["Fly|Ride"] = 282.87, ["Neon"] = 133.88, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 564.85, ["Mega|Ride"] = 706.55, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Ride"] = 15.2, ["Fly|Ride"] = 37.09, ["Neon"] = 2.1, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 35.44, ["Mega"] = 23.39, ["Mega|Fly"] = 42.39, ["Mega|Ride"] = 38.26, ["Mega|Fly|Ride"] = 78.4}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.93, ["Neon|Ride"] = 36.03, ["Neon|Fly|Ride"] = 71.1, ["Mega"] = 30.19, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 174.48}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 3.94, ["Ride"] = 32.82, ["Neon"] = 11.44, ["Neon|Ride"] = 69.92, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 70.5, ["Mega|Ride"] = 136.63}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 7.87, ["Fly"] = 57.75, ["Ride"] = 57.22, ["Fly|Ride"] = 126.11, ["Neon"] = 23.33, ["Neon|Fly"] = 129.94, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 110.08, ["Mega|Fly"] = 187.89, ["Mega|Ride"] = 117.94, ["Mega|Fly|Ride"] = 283.03}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 15.11, ["Fly|Ride"] = 36.58, ["Neon"] = 2.1, ["Neon|Fly"] = 28.32, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 42.39, ["Mega"] = 15.89, ["Mega|Ride"] = 41.33, ["Mega|Fly|Ride"] = 103.69}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 11.54, ["Ride"] = 27.57, ["Fly|Ride"] = 200.51, ["Neon"] = 70.85, ["Neon|Ride"] = 167.39, ["Neon|Fly|Ride"] = 196.23, ["Mega"] = 247.89, ["Mega|Ride"] = 489.41, ["Mega|Fly|Ride"] = 314.88}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2730, ["Fly"] = 3150, ["Ride"] = 2737.49, ["Fly|Ride"] = 2362.5, ["Neon|Fly"] = 9533.69, ["Neon|Fly|Ride"] = 9318.75, ["Mega|Fly|Ride"] = 43960.41}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 17.07, ["Fly|Ride"] = 46.64, ["Neon"] = 9.19, ["Neon|Fly"] = 68.98, ["Neon|Ride"] = 22.37, ["Neon|Fly|Ride"] = 66.94, ["Mega"] = 73.47, ["Mega|Fly"] = 113.36, ["Mega|Ride"] = 99.05, ["Mega|Fly|Ride"] = 157.03}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 5.25, ["Fly|Ride"] = 74.82, ["Neon"] = 13.13, ["Mega"] = 126, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 635.59}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 21, ["Ride"] = 28.82, ["Fly|Ride"] = 157.5, ["Neon"] = 71.79, ["Neon|Ride"] = 197.04, ["Neon|Fly|Ride"] = 262.71, ["Mega"] = 471.72, ["Mega|Ride"] = 397.69, ["Mega|Fly|Ride"] = 360.94}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 38.03, ["Ride"] = 193.44, ["Neon"] = 150.93, ["Neon|Ride"] = 389.84, ["Neon|Fly|Ride"] = 423.73, ["Mega"] = 540.75, ["Mega|Ride"] = 730, ["Mega|Fly|Ride"] = 1622.84}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 157.5, ["Fly"] = 282.84, ["Ride"] = 183.75, ["Fly|Ride"] = 203.44, ["Neon"] = 735.25, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 717.59, ["Mega"] = 6355.74, ["Mega|Ride"] = 3036.99, ["Mega|Fly|Ride"] = 2362.5}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 6.57, ["Ride"] = 52.5, ["Fly|Ride"] = 675.94, ["Neon"] = 19.48, ["Neon|Fly"] = 71, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 99.6, ["Mega"] = 223.13, ["Mega|Fly"] = 178.1, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 235.87}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.61, ["Ride"] = 52.5, ["Neon"] = 10.61, ["Neon|Fly"] = 99.61, ["Neon|Ride"] = 42.39, ["Neon|Fly|Ride"] = 528.61, ["Mega"] = 84.76, ["Mega|Ride"] = 261.03, ["Mega|Fly|Ride"] = 838.31}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 3.94, ["Fly"] = 102.38, ["Ride"] = 35.4, ["Fly|Ride"] = 131.25, ["Neon"] = 11.81, ["Neon|Ride"] = 44.63, ["Mega"] = 78.75, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 269.08}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 28.61, ["Fly|Ride"] = 656.25, ["Neon|Ride"] = 1553.99, ["Neon|Fly|Ride"] = 250.01, ["Mega"] = 476.43, ["Mega|Ride"] = 423.73, ["Mega|Fly|Ride"] = 524.36}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 70.98, ["Neon"] = 2.61, ["Neon|Ride"] = 57.66, ["Mega"] = 18.38, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 282.84}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 78.73, ["Ride"] = 91.88, ["Fly|Ride"] = 137.82, ["Neon"] = 324.2, ["Neon|Ride"] = 409.5, ["Neon|Fly|Ride"] = 418.69, ["Mega"] = 1365, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1360.9}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 32.65, ["Neon"] = 6.36, ["Neon|Ride"] = 104.88, ["Mega"] = 54.05, ["Mega|Ride"] = 126}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 43.31, ["Fly"] = 220.54, ["Ride"] = 70.88, ["Fly|Ride"] = 129.94, ["Neon"] = 295.32, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 377.99, ["Mega"] = 2625, ["Mega|Ride"] = 1353.82, ["Mega|Fly|Ride"] = 1156.32}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 33.87, ["Ride"] = 24.38, ["Fly|Ride"] = 49.88, ["Neon"] = 4.17, ["Neon|Fly"] = 121.85, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 41.75, ["Mega|Ride"] = 63.57, ["Mega|Fly|Ride"] = 123.98}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 10.5, ["Neon|Ride"] = 118.13, ["Mega"] = 76.11, ["Mega|Ride"] = 270.14, ["Mega|Fly|Ride"] = 544.48}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 14.31, ["Ride"] = 52.5, ["Fly|Ride"] = 210.83, ["Neon"] = 72.19, ["Neon|Ride"] = 141.96, ["Mega"] = 198.68, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 565.67}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 398.98, ["Ride"] = 393.75, ["Fly|Ride"] = 497.14, ["Neon"] = 1114.32, ["Neon|Ride"] = 1248.18, ["Neon|Fly|Ride"] = 1332.19, ["Mega"] = 4393.93, ["Mega|Ride"] = 3885, ["Mega|Fly|Ride"] = 3543.75}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 37.8, ["Fly"] = 57.22, ["Ride"] = 47.19, ["Fly|Ride"] = 64.32, ["Neon"] = 141.98, ["Neon|Fly"] = 314.92, ["Neon|Ride"] = 182.21, ["Neon|Fly|Ride"] = 198.19, ["Mega"] = 688.55, ["Mega|Ride"] = 698.09, ["Mega|Fly|Ride"] = 692.78}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 24.13, ["Ride"] = 19.14, ["Fly|Ride"] = 72.19, ["Neon"] = 6.57, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 24.38, ["Neon|Fly|Ride"] = 92.17, ["Mega"] = 74.17, ["Mega|Ride"] = 70.86, ["Mega|Fly|Ride"] = 449.15}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 15.74, ["Fly"] = 110.17, ["Ride"] = 42.39, ["Fly|Ride"] = 110.19, ["Neon"] = 46.6, ["Neon|Fly"] = 198.13, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 165.1, ["Mega"] = 227.07, ["Mega|Fly"] = 395.59, ["Mega|Ride"] = 270.41, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 10.49, ["Ride"] = 36.03, ["Fly|Ride"] = 71, ["Neon"] = 84, ["Neon|Ride"] = 122.9, ["Mega|Ride"] = 471.32, ["Mega|Fly|Ride"] = 338.99}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 2.63, ["Ride"] = 23.33, ["Neon"] = 19.9, ["Neon|Fly|Ride"] = 169.51, ["Mega"] = 62.99, ["Mega|Ride"] = 126.19, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 86.63, ["Ride"] = 19.08, ["Fly|Ride"] = 69.93, ["Neon"] = 26.25, ["Neon|Ride"] = 42.39, ["Neon|Fly|Ride"] = 216.12, ["Mega"] = 550.74, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 494.7}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 98.44, ["Fly"] = 131.25, ["Ride"] = 106.32, ["Fly|Ride"] = 183.75, ["Neon"] = 537.14, ["Neon|Ride"] = 563.48, ["Neon|Fly|Ride"] = 592.15, ["Mega"] = 2512.64, ["Mega|Ride"] = 2570.91, ["Mega|Fly|Ride"] = 2999.91}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 22.32, ["Fly"] = 95.82, ["Ride"] = 78.3, ["Fly|Ride"] = 147.26, ["Neon"] = 192.94, ["Neon|Ride"] = 184.33, ["Mega"] = 705.5, ["Mega|Ride"] = 706.55, ["Mega|Fly|Ride"] = 847.45}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2362.5, ["Fly"] = 2349.23, ["Ride"] = 2165.63, ["Fly|Ride"] = 2322.77, ["Neon"] = 12713, ["Neon|Fly|Ride"] = 7490.41, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 41.89, ["Fly|Ride"] = 170.63, ["Neon"] = 14.34, ["Neon|Ride"] = 61.37, ["Neon|Fly|Ride"] = 169.32, ["Mega"] = 113.25, ["Mega|Ride"] = 167.35, ["Mega|Fly|Ride"] = 423.73}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 21.2, ["Ride"] = 65.63, ["Fly|Ride"] = 136.5, ["Neon"] = 104.99, ["Neon|Ride"] = 110.87, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 255.94, ["Mega|Ride"] = 495.76, ["Mega|Fly|Ride"] = 565.67}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 954.19, ["Fly"] = 1413.09, ["Ride"] = 918.75, ["Fly|Ride"] = 945, ["Neon"] = 2598.75, ["Neon|Ride"] = 2493.75, ["Neon|Fly|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 12154.79}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 52.49, ["Ride"] = 66.09, ["Fly|Ride"] = 262.5, ["Neon"] = 251.76, ["Neon|Ride"] = 291.72, ["Mega"] = 656.25, ["Mega|Ride"] = 804.56, ["Mega|Fly|Ride"] = 752.07}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 6.56, ["Ride"] = 23.63, ["Fly|Ride"] = 64.32, ["Neon"] = 15.74, ["Neon|Ride"] = 471.72, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 133.49, ["Mega|Fly|Ride"] = 278.6}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Neon"] = 3.94, ["Neon|Ride"] = 52.5, ["Mega"] = 27.57, ["Mega|Ride"] = 67.81, ["Mega|Fly|Ride"] = 134.55}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 99.39, ["Ride"] = 125.99, ["Fly|Ride"] = 141.98, ["Neon"] = 459.38, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 2673.43}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 6.46, ["Ride"] = 57.22, ["Fly|Ride"] = 78.75, ["Neon"] = 35.44, ["Neon|Ride"] = 141.96, ["Mega|Ride"] = 198.1}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 94.49, ["Ride"] = 131.38, ["Neon"] = 515.95, ["Neon|Ride"] = 449.15, ["Mega|Fly|Ride"] = 1726.33}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 8.33, ["Fly"] = 105, ["Fly|Ride"] = 91.88, ["Neon"] = 33.15, ["Neon|Fly|Ride"] = 315, ["Mega"] = 226.71, ["Mega|Ride"] = 169.51, ["Mega|Fly|Ride"] = 282.84}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 255.71, ["Ride"] = 274.19, ["Fly|Ride"] = 328.13, ["Neon"] = 952.43, ["Neon|Fly"] = 1101.59, ["Neon|Ride"] = 1016.8, ["Neon|Fly|Ride"] = 1034.98, ["Mega|Fly|Ride"] = 4029.55}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.93, ["Fly"] = 87.67, ["Ride"] = 26.25, ["Fly|Ride"] = 99.65, ["Neon"] = 41.33, ["Neon|Ride"] = 69.77, ["Neon|Fly|Ride"] = 113.36, ["Mega"] = 250.04, ["Mega|Ride"] = 325.21, ["Mega|Fly|Ride"] = 443.14}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 19.08, ["Fly|Ride"] = 34.13, ["Neon"] = 3.92, ["Neon|Fly"] = 25.44, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 46.08, ["Mega"] = 57.75, ["Mega|Fly"] = 104.87, ["Mega|Ride"] = 79.03, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 832.12, ["Fly"] = 1179.29, ["Ride"] = 903, ["Fly|Ride"] = 1040.81, ["Neon|Ride"] = 4952.97, ["Neon|Fly|Ride"] = 4237.16, ["Mega"] = 28302.58}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 9.71, ["Fly"] = 989.39, ["Ride"] = 210, ["Neon"] = 39.38, ["Neon|Ride"] = 57.21, ["Mega"] = 160.57, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 370.79}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 7.88, ["Fly"] = 32.82, ["Ride"] = 50.77, ["Neon"] = 26.25, ["Neon|Fly"] = 105.96, ["Neon|Ride"] = 61.46, ["Neon|Fly|Ride"] = 130.95, ["Mega"] = 185.03, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 279.12}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 35.44, ["Fly"] = 40.52, ["Ride"] = 36.91, ["Fly|Ride"] = 45.93, ["Neon|Ride"] = 185.94, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 2118.59, ["Mega|Fly|Ride"] = 721.07}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 22.32, ["Fly"] = 79.46, ["Ride"] = 36.75, ["Fly|Ride"] = 86.63, ["Neon"] = 51.06, ["Neon|Ride"] = 79.03, ["Neon|Fly|Ride"] = 141.96, ["Mega"] = 393.84, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 443.62}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 23.37, ["Ride"] = 210, ["Fly|Ride"] = 112.88, ["Neon"] = 91.12, ["Neon|Ride"] = 211.91, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 449.15, ["Mega|Ride"] = 466.1, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Fly"] = 63.57, ["Ride"] = 116.59, ["Fly|Ride"] = 235.9, ["Neon"] = 2.61, ["Neon|Ride"] = 33.92, ["Mega"] = 21, ["Mega|Fly"] = 84.92, ["Mega|Ride"] = 141.96}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 32.4, ["Fly"] = 66.75, ["Ride"] = 42.39, ["Fly|Ride"] = 89.25, ["Neon"] = 131.25, ["Neon|Fly"] = 308.31, ["Neon|Ride"] = 236.22, ["Neon|Fly|Ride"] = 242.82, ["Mega"] = 3389.73, ["Mega|Fly|Ride"] = 997.29}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 89.64, ["Ride"] = 19.66, ["Fly|Ride"] = 65.63, ["Neon"] = 42.39, ["Neon|Ride"] = 141.07, ["Neon|Fly|Ride"] = 141.96, ["Mega"] = 773.07, ["Mega|Ride"] = 272.35, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 26.16, ["Ride"] = 20.01, ["Fly|Ride"] = 36.75, ["Neon"] = 14.44, ["Neon|Ride"] = 42.39, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 1058.24, ["Mega|Ride"] = 282.84, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 5.18, ["Ride"] = 103.69, ["Neon"] = 28.62, ["Neon|Fly|Ride"] = 105.94, ["Mega"] = 296.57, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 471.72}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 20.9, ["Fly"] = 262.13, ["Ride"] = 53.03, ["Fly|Ride"] = 262.5, ["Neon"] = 116.81, ["Neon|Fly"] = 312.55, ["Neon|Ride"] = 174.57, ["Neon|Fly|Ride"] = 228.82, ["Mega"] = 656.25, ["Mega|Ride"] = 614.4, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 5.24, ["Ride"] = 98.44, ["Neon"] = 23.62, ["Neon|Ride"] = 74.17, ["Neon|Fly|Ride"] = 113.36, ["Mega"] = 104.89, ["Mega|Ride"] = 143.01, ["Mega|Fly|Ride"] = 314.88}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 2.63, ["Neon|Ride"] = 26.25, ["Mega"] = 18.38, ["Mega|Ride"] = 52.38, ["Mega|Fly|Ride"] = 202.79}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Fly|Ride"] = 82.52, ["Neon"] = 3.93, ["Neon|Fly"] = 393.59, ["Neon|Ride"] = 28.62, ["Neon|Fly|Ride"] = 177.97, ["Mega"] = 19.69, ["Mega|Fly"] = 73.86, ["Mega|Ride"] = 40.11, ["Mega|Fly|Ride"] = 106.89}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 25.89, ["Ride"] = 21.25, ["Fly|Ride"] = 48.57, ["Neon"] = 8.49, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 84.92, ["Mega"] = 97.89, ["Mega|Ride"] = 158.04, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.58, ["Fly|Ride"] = 57.22, ["Neon"] = 15.91, ["Neon|Ride"] = 1312.5, ["Mega"] = 105, ["Mega|Ride"] = 145.3, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 16.94, ["Fly|Ride"] = 40.6, ["Neon"] = 13.65, ["Neon|Fly"] = 42.39, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 282.85, ["Mega|Ride"] = 236.24, ["Mega|Fly|Ride"] = 364.22}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 80.04, ["Ride"] = 206.6, ["Fly|Ride"] = 396.24, ["Neon"] = 197.06, ["Neon|Ride"] = 298.91, ["Neon|Fly|Ride"] = 1059.3, ["Mega"] = 787.5, ["Mega|Fly"] = 1003.16, ["Mega|Ride"] = 845.4, ["Mega|Fly|Ride"] = 952.31}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 22.32, ["Ride"] = 21.2, ["Fly|Ride"] = 36.04, ["Neon"] = 3.93, ["Neon|Fly"] = 28.5, ["Neon|Ride"] = 20.89, ["Neon|Fly|Ride"] = 49.34, ["Mega"] = 41.22, ["Mega|Ride"] = 53.15, ["Mega|Fly|Ride"] = 127.32}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 10.49, ["Fly"] = 62.91, ["Ride"] = 56.49, ["Fly|Ride"] = 78.41, ["Neon"] = 57.75, ["Neon|Fly"] = 71, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 79.03, ["Mega"] = 471.72, ["Mega|Ride"] = 242.33, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 13.11, ["Fly"] = 42, ["Ride"] = 28.88, ["Fly|Ride"] = 63.71, ["Neon"] = 72.02, ["Neon|Fly"] = 135.62, ["Neon|Ride"] = 79.03, ["Neon|Fly|Ride"] = 120.75, ["Mega"] = 409.96, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 401.34}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.94, ["Fly"] = 140.44, ["Ride"] = 47.18, ["Neon"] = 30.75, ["Neon|Ride"] = 70.98, ["Mega"] = 196.87, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 353.82}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 15.74, ["Fly|Ride"] = 42.39, ["Neon"] = 3.94, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 47.13, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 127.14}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.89, ["Fly"] = 78.07, ["Ride"] = 28.61, ["Fly|Ride"] = 141.39, ["Neon"] = 17.07, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 28.62, ["Neon|Fly|Ride"] = 158.9, ["Mega"] = 126, ["Mega|Fly"] = 735, ["Mega|Ride"] = 156.66, ["Mega|Fly|Ride"] = 312.51}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 934.5, ["Fly"] = 1050, ["Ride"] = 1065.26, ["Fly|Ride"] = 1092, ["Neon"] = 2625, ["Neon|Fly"] = 2896.45, ["Neon|Ride"] = 2881.62, ["Neon|Fly|Ride"] = 2336.25, ["Mega|Fly|Ride"] = 7434}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 68.23, ["Ride"] = 111.57, ["Neon"] = 260.24, ["Neon|Ride"] = 277.55, ["Neon|Fly|Ride"] = 296.62, ["Mega"] = 1367.56, ["Mega|Ride"] = 1367.56, ["Mega|Fly|Ride"] = 1286.25}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Ride"] = 68.39, ["Neon"] = 9.19, ["Neon|Ride"] = 75.08, ["Neon|Fly|Ride"] = 99.6, ["Mega"] = 69.72, ["Mega|Fly|Ride"] = 184.33}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 31.49, ["Ride"] = 60.17, ["Fly|Ride"] = 141.75, ["Neon"] = 174.46, ["Neon|Ride"] = 186.82, ["Neon|Fly|Ride"] = 279.81, ["Mega"] = 1023.75, ["Mega|Ride"] = 984.38, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 10.5, ["Ride"] = 33.13, ["Fly|Ride"] = 281.81, ["Neon"] = 117.41, ["Neon|Ride"] = 72.05, ["Neon|Fly|Ride"] = 282.84, ["Mega"] = 396.25, ["Mega|Fly|Ride"] = 1059.3}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 210, ["Fly"] = 317.8, ["Ride"] = 284.16, ["Fly|Ride"] = 334.38, ["Neon"] = 984.38, ["Neon|Ride"] = 1257.39, ["Neon|Fly|Ride"] = 1110.38, ["Mega|Fly|Ride"] = 4346.25}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 102.37, ["Ride"] = 22.32, ["Fly|Ride"] = 129.93, ["Neon"] = 19.69, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 400.43, ["Mega|Fly"] = 282.84}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 26.25, ["Neon|Ride"] = 141.96}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 61.67, ["Ride"] = 118.13, ["Fly|Ride"] = 282.96, ["Neon"] = 131.25, ["Neon|Ride"] = 410.82, ["Neon|Fly|Ride"] = 401.63, ["Mega"] = 1103.55, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 771.1}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 48.54, ["Fly|Ride"] = 141.54, ["Neon"] = 13.13, ["Mega"] = 224.58, ["Mega|Ride"] = 282.84, ["Mega|Fly|Ride"] = 211.87}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 15.73, ["Fly|Ride"] = 26.25, ["Neon"] = 3.68, ["Neon|Fly"] = 31.69, ["Neon|Ride"] = 23.3, ["Neon|Fly|Ride"] = 42.39, ["Mega"] = 27.54, ["Mega|Fly"] = 63.7, ["Mega|Ride"] = 41.33, ["Mega|Fly|Ride"] = 69.6}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4329.94, ["Ride"] = 4318.13, ["Fly|Ride"] = 4198.69, ["Neon"] = 21859.31, ["Neon|Fly|Ride"] = 21359.63, ["Mega|Fly|Ride"] = 52964.34}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 15.75, ["Ride"] = 36.04, ["Neon"] = 84, ["Neon|Ride"] = 49.81, ["Mega"] = 465.94, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 19.06, ["Ride"] = 21.19, ["Fly|Ride"] = 42.29, ["Neon"] = 12.69, ["Neon|Ride"] = 28.62, ["Neon|Fly|Ride"] = 66.75, ["Mega"] = 266.96, ["Mega|Ride"] = 132.83, ["Mega|Fly|Ride"] = 217.28}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 403.05, ["Fly"] = 494.7, ["Ride"] = 454.02, ["Fly|Ride"] = 542.75, ["Neon"] = 1312.5, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 5598.03}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 3.94, ["Ride"] = 28.62, ["Neon"] = 12.99, ["Neon|Ride"] = 158.03, ["Mega"] = 141.96, ["Mega|Fly|Ride"] = 317.8}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 5.25, ["Fly"] = 115.92, ["Ride"] = 314.88, ["Neon"] = 94.35, ["Neon|Ride"] = 141.98, ["Neon|Fly|Ride"] = 14124.55, ["Mega"] = 282.84, ["Mega|Ride"] = 401.63}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Ride"] = 20.14, ["Fly|Ride"] = 82.55, ["Neon"] = 7.1, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 33.9, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 41.94, ["Mega|Ride"] = 69.92, ["Mega|Fly|Ride"] = 173.17}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 630, ["Ride"] = 639.19, ["Fly|Ride"] = 676.57, ["Neon"] = 2500.23, ["Neon|Fly|Ride"] = 1966.13, ["Mega|Fly|Ride"] = 8751.75}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 5.85, ["Ride"] = 71, ["Neon"] = 26.24, ["Neon|Ride"] = 99.6, ["Neon|Fly|Ride"] = 648.38, ["Mega"] = 126, ["Mega|Ride"] = 211.58, ["Mega|Fly|Ride"] = 306.34}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 12.71, ["Fly"] = 235.94, ["Ride"] = 45.92, ["Fly|Ride"] = 150.94, ["Neon"] = 43.32, ["Neon|Ride"] = 98.18, ["Neon|Fly|Ride"] = 120.78, ["Mega"] = 221.54, ["Mega|Ride"] = 227.67, ["Mega|Fly|Ride"] = 337.77}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 23.31, ["Ride"] = 17.7, ["Fly|Ride"] = 40.69, ["Neon"] = 11.8, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 63.57, ["Mega"] = 219.19, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 26.24, ["Ride"] = 52.99, ["Neon"] = 78.7, ["Neon|Fly"] = 170.63, ["Neon|Ride"] = 127.14, ["Neon|Fly|Ride"] = 314.88, ["Mega"] = 562.5, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 529.66}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 39.37, ["Neon"] = 2.63, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 31.5, ["Mega|Fly"] = 42.39, ["Mega|Ride"] = 85.4, ["Mega|Fly|Ride"] = 209.42}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 419.99, ["Ride"] = 452.73, ["Fly|Ride"] = 629.83, ["Neon"] = 2330.72, ["Neon|Ride"] = 2326.21, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Ride"] = 9198.35, ["Mega|Fly|Ride"] = 7848.75}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 49.81, ["Neon"] = 4.25, ["Neon|Ride"] = 42.39, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 65.63, ["Mega|Ride"] = 133.49, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 27.36, ["Neon"] = 3.93, ["Neon|Fly"] = 71, ["Neon|Ride"] = 212.28, ["Neon|Fly|Ride"] = 141.96, ["Mega"] = 40.27, ["Mega|Fly"] = 82.64, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 210.81}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 5.25, ["Neon|Ride"] = 45.91, ["Mega"] = 34.13, ["Mega|Fly"] = 156.79, ["Mega|Ride"] = 91.11}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 3.4, ["Ride"] = 131.25, ["Neon"] = 17.07, ["Neon|Ride"] = 70.98, ["Mega"] = 112.04, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 48.04, ["Ride"] = 78.37, ["Fly|Ride"] = 198.13, ["Neon"] = 233.62, ["Neon|Ride"] = 254.25, ["Neon|Fly|Ride"] = 353.82, ["Mega"] = 525, ["Mega|Ride"] = 465.93, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 26.22, ["Fly"] = 69.47, ["Ride"] = 64.32, ["Neon"] = 109.52, ["Neon|Ride"] = 423.73, ["Mega"] = 381.36, ["Mega|Ride"] = 453.51, ["Mega|Fly|Ride"] = 499.06}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.63, ["Fly"] = 34.65, ["Ride"] = 16.92, ["Fly|Ride"] = 36.72, ["Neon"] = 27.56, ["Neon|Fly"] = 71, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 75.1, ["Mega"] = 394.42, ["Mega|Ride"] = 238.04, ["Mega|Fly|Ride"] = 246.47}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 11.82, ["Ride"] = 64.32, ["Neon"] = 169.52, ["Neon|Ride"] = 158.82, ["Neon|Fly|Ride"] = 234.12, ["Mega|Ride"] = 786.59, ["Mega|Fly|Ride"] = 565.67}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 3.41, ["Ride"] = 27.56, ["Fly|Ride"] = 362.25, ["Neon"] = 18.38, ["Neon|Ride"] = 68.83, ["Mega"] = 131.25, ["Mega|Ride"] = 148.32, ["Mega|Fly|Ride"] = 254.25}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 18.61, ["Ride"] = 32.82, ["Fly|Ride"] = 45.94, ["Neon"] = 228.74, ["Neon|Ride"] = 156.79, ["Neon|Fly|Ride"] = 156.79, ["Mega"] = 952.31, ["Mega|Ride"] = 943.43, ["Mega|Fly|Ride"] = 706.55}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 38.94, ["Fly"] = 874.13, ["Neon|Ride"] = 471.72, ["Mega"] = 353.07, ["Mega|Ride"] = 267.71}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 45.93, ["Fly"] = 115.5, ["Ride"] = 87.42, ["Fly|Ride"] = 139.13, ["Neon"] = 246.75, ["Neon|Fly"] = 325.26, ["Neon|Ride"] = 276.92, ["Neon|Fly|Ride"] = 283.03, ["Mega"] = 1144.04, ["Mega|Ride"] = 1157.01, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 42.39, ["Fly"] = 92.79, ["Ride"] = 99.65, ["Fly|Ride"] = 282.87, ["Neon"] = 137.82, ["Neon|Ride"] = 190.68, ["Neon|Fly|Ride"] = 421.61, ["Mega"] = 513.35, ["Mega|Ride"] = 612.73, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 23.6, ["Ride"] = 52.99, ["Neon"] = 108.94, ["Mega"] = 559.13, ["Mega|Ride"] = 635.59, ["Mega|Fly|Ride"] = 718.2}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 7.86, ["Fly"] = 29.39, ["Ride"] = 31.76, ["Fly|Ride"] = 91.54, ["Neon"] = 45.94, ["Neon|Fly"] = 169.52, ["Neon|Ride"] = 57.14, ["Neon|Fly|Ride"] = 116.28, ["Mega"] = 289.98, ["Mega|Ride"] = 324.11, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.89, ["Fly|Ride"] = 38.56, ["Neon"] = 3.94, ["Neon|Fly"] = 24.89, ["Neon|Ride"] = 21.24, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 41.4, ["Mega|Fly"] = 706.55, ["Mega|Ride"] = 62.99, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1268.88}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 25.97, ["Ride"] = 55.44, ["Fly|Ride"] = 127.15, ["Neon"] = 127.15, ["Neon|Fly"] = 234.14, ["Neon|Ride"] = 211.87, ["Neon|Fly|Ride"] = 283.9, ["Mega"] = 409.96, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 47.19, ["Neon"] = 4.73, ["Neon|Ride"] = 37.09, ["Neon|Fly|Ride"] = 296.62, ["Mega"] = 32.82, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 541.31}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 28.3, ["Ride"] = 70.88, ["Neon"] = 208.31, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 325.21, ["Mega"] = 633.94, ["Mega|Ride"] = 834.73, ["Mega|Fly|Ride"] = 845.33}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 105, ["Mega"] = 26.25, ["Mega|Fly|Ride"] = 706.55}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.92, ["Neon|Ride"] = 158.04, ["Mega"] = 22.32, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 108.61, ["Ride"] = 172.68, ["Fly|Ride"] = 249.37, ["Neon"] = 425.25, ["Neon|Fly"] = 538.19, ["Neon|Ride"] = 518.44, ["Neon|Fly|Ride"] = 570.94, ["Mega|Ride"] = 6486.02, ["Mega|Fly|Ride"] = 2098.69}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.63, ["Fly"] = 26.11, ["Ride"] = 28.62, ["Fly|Ride"] = 70.79, ["Neon"] = 11.81, ["Neon|Fly"] = 63.58, ["Neon|Ride"] = 35.43, ["Neon|Fly|Ride"] = 92.17, ["Mega"] = 107.63, ["Mega|Ride"] = 130.31, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 36.16, ["Ride"] = 131.25, ["Fly|Ride"] = 86.63, ["Neon"] = 6.38, ["Neon|Ride"] = 57.22, ["Neon|Fly|Ride"] = 101.71, ["Mega"] = 37.09, ["Mega|Ride"] = 103.83, ["Mega|Fly|Ride"] = 116.82}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 3.91, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.17, ["Mega"] = 34.13, ["Mega|Ride"] = 79.03, ["Mega|Fly|Ride"] = 114.19}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 4.93, ["Neon|Ride"] = 21.2, ["Neon|Fly|Ride"] = 141.96, ["Mega"] = 40.69, ["Mega|Ride"] = 95.7, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 45.93, ["Ride"] = 91.88, ["Fly|Ride"] = 449.61, ["Neon"] = 298.73, ["Neon|Ride"] = 253.87, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1363.31, ["Mega|Ride"] = 1481.96, ["Mega|Fly|Ride"] = 1553.99}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.77, ["Ride"] = 139.79, ["Neon"] = 28.28, ["Neon|Ride"] = 110.87, ["Mega"] = 141.96, ["Mega|Ride"] = 771.1}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 368.13, ["Ride"] = 363.51, ["Fly|Ride"] = 524.43, ["Neon"] = 1271.31, ["Neon|Ride"] = 1269.19, ["Neon|Fly|Ride"] = 1271.16, ["Mega"] = 3642.91, ["Mega|Fly|Ride"] = 3243.36}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 72.19}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 41.88}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 15.9}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 15.75}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 28.88}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 32.82}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 9.19}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 5.24}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 234.94}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 22.42}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 55.82}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 7.33}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 4.64}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 393.75}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 5.24}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 5.23}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 5.23}},
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
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 7.87}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 15.62}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 3.94}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 19.05}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 24.93}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 38.99}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 15.54}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 13.13}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 13.11}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 7.35}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 15.1}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 3.81}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 22.3}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 21}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.5}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.46}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1575}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 161.03}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 308.23}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 10.71}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 6.35}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 7.87}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 24.26}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 127.3}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 9.93}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 11.79}},
    ["rbxassetid://1265129435"] = {name = "Gold Snowboard", prices = {["default"] = 168}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 656.24}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 27.57}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 3.93}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 22.23}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 6.57}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 3.75}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 110.25}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 19.69}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 10.4}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.63}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 26.25}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 9.43}},
    ["rbxassetid://1265129203"] = {name = "Ice Snowboard", prices = {["default"] = 224.58}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 3.93}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 32.61}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 133.55}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 159.12}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.63}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 9.81}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 23.62}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.93}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 76.13}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 57.07}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22406.16}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 183.73}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 32.82}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 64.98}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 48.57}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 38.04}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 51.28}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 45.94}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 82.67}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 91.87}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 31.5}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 36.75}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 39.11}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 44.63}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 74.79}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 354.37}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 9.19}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 6.56}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 7.17}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 34.12}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 41.71}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.82}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 6.17}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 3.94}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 196.88}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 1050}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 6.36}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 598.7}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 33.84}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.63}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 380.63}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 48.57}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 92.25}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 36.03}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 48.57}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 96.79}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 27.15}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 2.1}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 14.91}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 2.61}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 3.91}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 29.87}},
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
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.63}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 4.25}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 141.52}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 7.72}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 11.66}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 6.57}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 15.94}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 49.87}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 11.82}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.63}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 7.88}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 15.9}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 13.6}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 141.75}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 32.54}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 7.87}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 8.44}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.63}},
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
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 5.92}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 4.19}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 5670}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 37.7}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 8.17}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.44}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 20.47}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 18.87}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 3.94}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.92}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 15.48}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 181.95}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 18.47}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 6.57}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 4.66}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.56}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 3.93}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 5.25}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4237.16}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 4.6}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 48.57}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 6.86}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 78.75}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.61}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 5.43}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 281.79}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.1}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.93}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.63}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 3.93}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 8.38}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 26.25}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.93}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.67}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.5}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 13.06}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.15}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.29}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.24}},
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
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 31.42}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.59}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 65.2}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 15.88}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 275.62}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.19}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 85.32}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 2.61}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 6.25}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 984.37}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.63}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 14.21}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 5.01}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 3.93}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 27.39}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 3.28}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 6.29}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 3.94}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 9.19}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 24.93}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 3.93}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 15.74}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 15.74}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.63}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 13.13}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 2.1}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 4.19}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 17.07}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 5.25}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 3.03}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 26.25}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 26.24}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 70.86}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 140.95}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.37}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 7.87}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 32.86}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.63}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 11.08}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 8.48}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 2.1}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 49.17}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 25.55}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.92}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 11.66}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 102.38}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.6}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 9.19}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 4.34}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 5.24}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 9.45}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 10.54}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 17.85}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 86.63}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.45}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 7.87}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.63}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 108.83}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 5.25}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1245.57}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 187.55}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 6.35}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.63}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 10.45}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 38.07}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.33}},
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
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.37}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 4.25}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.84}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 10.5}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 3.52}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 65.63}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 18.9}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 52.49}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.61}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 3.93}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 3.93}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 7.87}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 22.97}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 91.88}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 5.24}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 75.8}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 3.94}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.93}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 11.65}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 66.92}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 60.36}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 91.88}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 328.13}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 85.29}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 184.06}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.93}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.63}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 15.63}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 51.19}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.76}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 23.63}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 2.63}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 5.99}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 8.81}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 28.61}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 7.56}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 6.28}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 6.55}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 32.85}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 45.94}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 3.75}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 33.97}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 2.43}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 6.91}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 127.12}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 65.63}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 27.28}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1565.64}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 42}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 10.61}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 26.33}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 271.63}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 15.74}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 11.66}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 9.19}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 7.85}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 3.91}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 170.61}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 43.08}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 53.31}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 10.5}},
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
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1048.69}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 188.61}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 11.82}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1057.4}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 588.48}},
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