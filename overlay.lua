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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1044.8, ["Ride"] = 1050, ["Fly|Ride"] = 1292.82, ["Neon"] = 6648.74, ["Neon|Ride"] = 6562.5, ["Neon|Fly|Ride"] = 4235.63, ["Mega|Fly|Ride"] = 17415.17}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 393.65, ["Ride"] = 515.08, ["Fly|Ride"] = 544.39, ["Neon|Fly|Ride"] = 1967.44, ["Mega"] = 11872.9, ["Mega|Fly|Ride"] = 6909.36}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4954.69, ["Ride"] = 4606.94, ["Fly|Ride"] = 4954.69, ["Neon|Fly|Ride"] = 21077.72, ["Mega|Fly|Ride"] = 69791.77}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 160.12, ["Ride"] = 222.09, ["Fly|Ride"] = 275.36, ["Neon"] = 977.8, ["Neon|Ride"] = 895.1, ["Neon|Fly|Ride"] = 1045.84, ["Mega|Fly|Ride"] = 4186.88}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 590.63, ["Fly"] = 837.51, ["Ride"] = 538.13, ["Fly|Ride"] = 611.63, ["Neon|Fly|Ride"] = 1745.63, ["Mega|Fly|Ride"] = 6648.84}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 7.54, ["Ride"] = 57.68, ["Fly|Ride"] = 129.94, ["Neon"] = 51.19, ["Neon|Fly"] = 279.54, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 404.25, ["Mega"] = 328.13, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 585.21}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.4, ["Fly"] = 32.82, ["Ride"] = 21, ["Fly|Ride"] = 49.88, ["Neon"] = 23.77, ["Neon|Fly"] = 141.35, ["Neon|Ride"] = 56.58, ["Neon|Fly|Ride"] = 137.4, ["Mega"] = 162.62, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 290.78}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 91.88, ["Fly"] = 209.39, ["Ride"] = 146.57, ["Neon"] = 525, ["Neon|Ride"] = 493.5, ["Neon|Fly|Ride"] = 656.4, ["Mega"] = 2064.45, ["Mega|Fly|Ride"] = 2733.4}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 40.57, ["Fly"] = 83.14, ["Ride"] = 48.57, ["Fly|Ride"] = 103.31, ["Neon"] = 275.63, ["Neon|Ride"] = 237.96, ["Neon|Fly|Ride"] = 308.7, ["Mega"] = 1396.55, ["Mega|Ride"] = 1266.86, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 16.86, ["Fly"] = 83.76, ["Ride"] = 28.88, ["Fly|Ride"] = 69.34, ["Neon"] = 145.52, ["Neon|Ride"] = 308.84, ["Neon|Fly|Ride"] = 186.36, ["Mega|Fly|Ride"] = 1102.5}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 48.55, ["Fly"] = 110.98, ["Ride"] = 70.87, ["Fly|Ride"] = 177.5, ["Neon"] = 444.06, ["Neon|Ride"] = 236.31, ["Neon|Fly|Ride"] = 418.76}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 68.25}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 313.5, ["Fly"] = 391.54, ["Ride"] = 326.8, ["Fly|Ride"] = 374.07, ["Neon|Ride"] = 1048.69, ["Neon|Fly|Ride"] = 1122.19, ["Mega|Fly|Ride"] = 4941.24}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 124.69, ["Fly"] = 135.06, ["Ride"] = 78.75, ["Fly|Ride"] = 182.17, ["Neon|Fly"] = 688.64, ["Neon|Ride"] = 573.56, ["Neon|Fly|Ride"] = 634.04, ["Mega|Fly|Ride"] = 3047.79}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.1, ["Ride"] = 54.46, ["Fly|Ride"] = 131.25, ["Neon"] = 17.07, ["Neon|Ride"] = 125.64, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 118.13, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 316.17, ["Mega|Fly|Ride"] = 308.83}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 170.62, ["Fly"] = 237.57, ["Ride"] = 190.2, ["Fly|Ride"] = 196.88, ["Neon"] = 831.11, ["Neon|Ride"] = 865.77, ["Neon|Fly|Ride"] = 831.12, ["Mega"] = 3210.77, ["Mega|Fly|Ride"] = 2730}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.41, ["Fly"] = 19.69, ["Ride"] = 17.83, ["Fly|Ride"] = 37.75, ["Neon"] = 35.61, ["Neon|Fly"] = 125.64, ["Neon|Ride"] = 92.14, ["Neon|Fly|Ride"] = 118.13, ["Mega|Fly|Ride"] = 418.76}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 78.75, ["Fly"] = 284.72, ["Ride"] = 140.02, ["Fly|Ride"] = 190.82, ["Neon"] = 279.54, ["Neon|Ride"] = 354.38, ["Neon|Fly|Ride"] = 374.07, ["Mega"] = 1703.79, ["Mega|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 1422.75}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 40.69}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 52.5, ["Ride"] = 99.47, ["Fly|Ride"] = 177.98, ["Neon"] = 278.49, ["Neon|Fly|Ride"] = 787.5}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 16.69, ["Fly"] = 393.75, ["Ride"] = 31.5, ["Fly|Ride"] = 376.89, ["Neon"] = 206.6, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 2730.78, ["Mega|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 626.05}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 36.83, ["Fly"] = 77.48, ["Ride"] = 54.38, ["Fly|Ride"] = 100.48, ["Neon"] = 279.54, ["Neon|Ride"] = 295.23, ["Neon|Fly|Ride"] = 300.47, ["Mega"] = 1662.22, ["Mega|Ride"] = 1396.55, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 27.55, ["Fly"] = 72.19, ["Ride"] = 59.07, ["Fly|Ride"] = 196.88, ["Neon"] = 210, ["Neon|Fly"] = 394.19, ["Neon|Ride"] = 370.6, ["Neon|Fly|Ride"] = 448.08, ["Mega"] = 1967.44, ["Mega|Fly|Ride"] = 1266.86}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 16.94, ["Ride"] = 35.18, ["Fly|Ride"] = 84, ["Neon"] = 209.39, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 299.21, ["Mega"] = 887.76, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 37.49, ["Fly"] = 49.22, ["Ride"] = 57.74, ["Fly|Ride"] = 127.05, ["Neon"] = 284.45, ["Neon|Fly"] = 232.42, ["Neon|Ride"] = 381.94, ["Neon|Fly|Ride"] = 322.88, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 943.69}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 3.99, ["Fly"] = 27.12, ["Ride"] = 19.27, ["Fly|Ride"] = 62.84, ["Neon"] = 21.95, ["Neon|Fly"] = 77.48, ["Neon|Ride"] = 48.54, ["Neon|Fly|Ride"] = 95.7, ["Mega"] = 156.85, ["Mega|Fly"] = 27100.4, ["Mega|Ride"] = 170.5, ["Mega|Fly|Ride"] = 261.18}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 446.25, ["Ride"] = 426.08, ["Fly|Ride"] = 505.85, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1964.82, ["Mega|Fly|Ride"] = 7662.06}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 13.13, ["Ride"] = 32.33, ["Fly|Ride"] = 108.43, ["Neon"] = 212.67, ["Mega|Ride"] = 795.64, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 6.57, ["Fly"] = 34.71, ["Ride"] = 20.41, ["Fly|Ride"] = 39.86, ["Neon"] = 69.4, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 113.24, ["Mega"] = 418.76, ["Mega|Ride"] = 293.14, ["Mega|Fly|Ride"] = 559.05}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 86.1, ["Fly"] = 102.38, ["Ride"] = 102.66, ["Fly|Ride"] = 129.14, ["Neon"] = 328.13, ["Neon|Fly"] = 357, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 399, ["Mega"] = 4061.87, ["Mega|Ride"] = 5832.75, ["Mega|Fly|Ride"] = 1584.97}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 9.8, ["Ride"] = 26.25, ["Fly|Ride"] = 118.13, ["Neon"] = 131.25, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 209.39, ["Mega"] = 698.29, ["Mega|Ride"] = 791.94, ["Mega|Fly|Ride"] = 837.51}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 206.05, ["Fly"] = 353.85, ["Ride"] = 207.55, ["Fly|Ride"] = 275.62, ["Neon"] = 672.79, ["Neon|Ride"] = 825.57, ["Neon|Fly|Ride"] = 782, ["Mega"] = 6281.24, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 3008.6}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 22.55}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.33, ["Fly"] = 32.08, ["Ride"] = 24.1, ["Fly|Ride"] = 54, ["Neon"] = 20.56, ["Neon|Fly"] = 135.71, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 127.08, ["Mega"] = 140.3, ["Mega|Fly"] = 483.68, ["Mega|Ride"] = 182.44, ["Mega|Fly|Ride"] = 270.11}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 892.48, ["Fly"] = 2625, ["Ride"] = 889.45, ["Fly|Ride"] = 1092.14, ["Neon"] = 10207.32, ["Neon|Ride"] = 6142.01, ["Neon|Fly|Ride"] = 4282.32, ["Mega|Ride"] = 53428.01, ["Mega|Fly|Ride"] = 17083.5}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 7.87, ["Fly"] = 70.16, ["Ride"] = 24.94, ["Fly|Ride"] = 91.49, ["Neon"] = 91.88, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 231.38, ["Mega"] = 764.24, ["Mega|Ride"] = 1066.77, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 136.5, ["Ride"] = 244.29, ["Fly|Ride"] = 236.25, ["Neon"] = 1815.3, ["Neon|Ride"] = 813.65, ["Neon|Fly|Ride"] = 971.52, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 44.63}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 16.07, ["Fly"] = 112.03, ["Ride"] = 65.52, ["Fly|Ride"] = 140.3, ["Neon"] = 98.42, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 140.3, ["Mega"] = 698.29, ["Mega|Ride"] = 1104.46, ["Mega|Fly|Ride"] = 587.72}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 130.44, ["Ride"] = 136.5, ["Fly|Ride"] = 236.25, ["Neon"] = 614.53, ["Neon|Ride"] = 446.92, ["Mega|Fly|Ride"] = 2723.17}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 115.49, ["Fly"] = 157.49, ["Ride"] = 164.07, ["Fly|Ride"] = 274.32, ["Neon"] = 360.94, ["Neon|Fly"] = 559.05, ["Neon|Ride"] = 342.5, ["Neon|Fly|Ride"] = 603.75, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1555.5}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 35.09}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 52.41, ["Fly"] = 64.63, ["Ride"] = 52.26, ["Fly|Ride"] = 73.35, ["Neon|Ride"] = 388.25, ["Neon|Fly|Ride"] = 376.94, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 6.57, ["Fly"] = 70.16, ["Ride"] = 46.33, ["Fly|Ride"] = 157.49, ["Neon"] = 35.35, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 125.64, ["Neon|Fly|Ride"] = 559.05, ["Mega"] = 182.86, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 298.97, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 485.31, ["Fly"] = 479.07, ["Ride"] = 472.5, ["Fly|Ride"] = 524.98, ["Neon|Ride"] = 3768.75, ["Neon|Fly|Ride"] = 1690.81, ["Mega|Ride"] = 14656.21, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 104.97, ["Fly"] = 150.99, ["Ride"] = 118.12, ["Fly|Ride"] = 184.73, ["Neon"] = 420, ["Neon|Fly"] = 837.51, ["Neon|Ride"] = 559.05, ["Neon|Fly|Ride"] = 664.9, ["Mega|Ride"] = 2511.47, ["Mega|Fly|Ride"] = 2234.04}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3281.25, ["Ride"] = 3885, ["Fly|Ride"] = 3674.99, ["Neon|Fly|Ride"] = 14655.16}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 41.85, ["Fly"] = 118.13, ["Ride"] = 56.56, ["Fly|Ride"] = 128.43, ["Neon|Ride"] = 308.7, ["Neon|Fly|Ride"] = 418.76, ["Mega"] = 1569.27, ["Mega|Ride"] = 1787.02, ["Mega|Fly|Ride"] = 1371.42}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 63, ["Ride"] = 85.32, ["Fly|Ride"] = 136.71, ["Neon"] = 575.75, ["Neon|Ride"] = 427.88, ["Neon|Fly|Ride"] = 426.05, ["Mega|Ride"] = 2234.04, ["Mega|Fly|Ride"] = 2059.71}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 23.77, ["Fly"] = 56.25, ["Ride"] = 45.96, ["Fly|Ride"] = 89.25, ["Neon"] = 209.39, ["Neon|Fly"] = 195.78, ["Neon|Ride"] = 140.31, ["Neon|Fly|Ride"] = 192.96, ["Mega"] = 977.8, ["Mega|Ride"] = 684.68, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 6.3}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 39.8, ["Fly"] = 56.55, ["Ride"] = 56.63, ["Fly|Ride"] = 65.63, ["Neon|Ride"] = 295.32, ["Neon|Fly|Ride"] = 418.76, ["Mega|Fly|Ride"] = 1493.63}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 37.71}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 223.13, ["Ride"] = 229.69, ["Fly|Ride"] = 301.88, ["Neon|Ride"] = 1088.76, ["Neon|Fly|Ride"] = 1084.57, ["Mega|Fly|Ride"] = 4514.12}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["Ride"] = 943.69, ["Fly|Ride"] = 977.8, ["Neon"] = 2887.5, ["Neon|Fly|Ride"] = 3361.52, ["Mega|Fly|Ride"] = 10765.16}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 6.33}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 23.63, ["Fly"] = 56.37, ["Ride"] = 39.37, ["Fly|Ride"] = 58.97, ["Neon"] = 244.99, ["Neon|Ride"] = 166.68, ["Neon|Fly|Ride"] = 211.77, ["Mega|Ride"] = 1140.07, ["Mega|Fly|Ride"] = 762.74}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 16.9}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 4725, ["Ride"] = 6176.56, ["Fly|Ride"] = 4725, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 41951.67}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 11.82, ["Fly"] = 55.12, ["Ride"] = 27.37, ["Fly|Ride"] = 54.66, ["Neon"] = 99.59, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 698.29, ["Mega|Ride"] = 1514.63, ["Mega|Fly|Ride"] = 700.88}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 9.52, ["Fly"] = 139.89, ["Ride"] = 26.25, ["Fly|Ride"] = 68.25, ["Neon"] = 95.28, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 918.75, ["Mega|Ride"] = 770.2, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 70.87, ["Fly"] = 279.54, ["Ride"] = 58.95, ["Fly|Ride"] = 78.75, ["Neon|Ride"] = 374.07, ["Neon|Fly|Ride"] = 480.96, ["Mega"] = 4187.5}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 10.2, ["Fly"] = 70.16, ["Ride"] = 25.8, ["Fly|Ride"] = 132.64, ["Neon"] = 70.16, ["Neon|Ride"] = 134.02, ["Neon|Fly|Ride"] = 140.3, ["Mega"] = 1396.55, ["Mega|Ride"] = 744.61, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1666.87, ["Fly"] = 2059.23, ["Ride"] = 1767.15, ["Fly|Ride"] = 1626.19, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 27428.63, ["Fly"] = 33499.89, ["Ride"] = 32548.95, ["Fly|Ride"] = 26250, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 72504.2, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 15.46, ["Fly"] = 393.75, ["Ride"] = 67.7, ["Fly|Ride"] = 90.96, ["Neon"] = 314.08, ["Neon|Ride"] = 209.39, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 837.51, ["Mega|Ride"] = 1005.01, ["Mega|Fly|Ride"] = 1356.75}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.1, ["Fly"] = 75.13, ["Ride"] = 32.44, ["Fly|Ride"] = 155.39, ["Neon"] = 19.65, ["Neon|Fly"] = 150.81, ["Neon|Ride"] = 63.66, ["Neon|Fly|Ride"] = 140.48, ["Mega"] = 137.82, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 15.75}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 5.25, ["Ride"] = 26.25, ["Fly|Ride"] = 124.67, ["Neon"] = 89.09, ["Neon|Ride"] = 139.07, ["Neon|Fly|Ride"] = 471.11, ["Mega"] = 326.62, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 714, ["Ride"] = 682.5, ["Fly|Ride"] = 735, ["Neon"] = 3008.57, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 11082.17}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 918.75, ["Fly"] = 975.19, ["Ride"] = 827.94, ["Fly|Ride"] = 905.63, ["Neon|Ride"] = 3629.51, ["Neon|Fly|Ride"] = 3109.32, ["Mega|Fly|Ride"] = 10609.01}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 15.72, ["Fly"] = 118.77, ["Ride"] = 31.5, ["Fly|Ride"] = 71.38, ["Neon"] = 91.88, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 213.94, ["Mega"] = 1197.99, ["Mega|Ride"] = 480.38, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 22.86}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 73.16, ["Fly"] = 110.98, ["Ride"] = 78.44, ["Fly|Ride"] = 112.26, ["Neon"] = 420, ["Neon|Ride"] = 418.76, ["Neon|Fly|Ride"] = 420, ["Mega"] = 19687.5, ["Mega|Ride"] = 2049.79, ["Mega|Fly|Ride"] = 1664.25}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 72.18, ["Ride"] = 120.41, ["Fly|Ride"] = 213.72, ["Neon"] = 450.19, ["Neon|Fly"] = 396.57, ["Neon|Ride"] = 359.28, ["Neon|Fly|Ride"] = 553.88, ["Mega"] = 1362.4, ["Mega|Ride"] = 1884.39, ["Mega|Fly|Ride"] = 1922.07}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.6, ["Fly"] = 35.44, ["Ride"] = 22.18, ["Fly|Ride"] = 40.69, ["Neon"] = 23.63, ["Neon|Fly"] = 525, ["Neon|Ride"] = 64.93, ["Neon|Fly|Ride"] = 91.88, ["Mega|Fly|Ride"] = 507.94}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 120.84, ["Fly"] = 129.94, ["Ride"] = 150.93, ["Fly|Ride"] = 196.71, ["Neon"] = 725.81, ["Neon|Ride"] = 576.18, ["Neon|Fly|Ride"] = 531.44, ["Mega|Fly|Ride"] = 2028.99}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 4.2, ["Ride"] = 36.49, ["Fly|Ride"] = 167.51, ["Neon"] = 42, ["Neon|Ride"] = 82.69, ["Mega"] = 196.88, ["Mega|Ride"] = 640.5, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 10.35, ["Fly"] = 41.64, ["Ride"] = 32.69, ["Fly|Ride"] = 77.48, ["Neon"] = 98.44, ["Neon|Ride"] = 107.84, ["Neon|Fly|Ride"] = 140.3, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 29.42, ["Ride"] = 60.27, ["Fly|Ride"] = 156.19, ["Neon"] = 183.75, ["Neon|Ride"] = 282.19, ["Mega"] = 918.74, ["Mega|Ride"] = 1161.57, ["Mega|Fly|Ride"] = 1114.31}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 13.01, ["Fly"] = 174.27, ["Ride"] = 35.76, ["Fly|Ride"] = 67.38, ["Neon"] = 91.87, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 140.3, ["Mega"] = 918.75, ["Mega|Fly|Ride"] = 995.59}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6840.27, ["Ride"] = 6555.94, ["Fly|Ride"] = 5502, ["Neon"] = 34896.42, ["Neon|Ride"] = 24281.25, ["Neon|Fly|Ride"] = 27763.04}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 205.09, ["Fly"] = 236.24, ["Ride"] = 232.32, ["Fly|Ride"] = 276.94, ["Neon"] = 525, ["Neon|Fly|Ride"] = 564.38, ["Mega|Fly|Ride"] = 1797.98}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 27.61, ["Fly"] = 95.02, ["Ride"] = 85.32, ["Fly|Ride"] = 144.36, ["Neon"] = 105, ["Neon|Fly"] = 254.09, ["Neon|Ride"] = 164.94, ["Neon|Fly|Ride"] = 229.68, ["Mega"] = 406.88, ["Mega|Fly"] = 572.65, ["Mega|Ride"] = 419.87, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.48, ["Fly"] = 87.89, ["Ride"] = 28.25, ["Fly|Ride"] = 52.5, ["Neon"] = 31.42, ["Neon|Fly"] = 60.74, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 190.54, ["Mega"] = 341.25, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 355.01}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 51.18, ["Fly"] = 5385.94, ["Ride"] = 99.32, ["Fly|Ride"] = 104.7, ["Neon"] = 227.39, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 262.49, ["Neon|Fly|Ride"] = 381.22, ["Mega"] = 518.22, ["Mega|Ride"] = 634.04, ["Mega|Fly|Ride"] = 608.4}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 14384.99, ["Ride"] = 13387.5, ["Fly|Ride"] = 12206.25, ["Neon|Fly|Ride"] = 24937.5, ["Mega|Fly|Ride"] = 111666.61}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 267.75, ["Ride"] = 261.19, ["Fly|Ride"] = 321.41, ["Neon"] = 1256.26, ["Neon|Ride"] = 1396.55, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 5974.52}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 70.21, ["Fly"] = 91.88, ["Ride"] = 57.98, ["Fly|Ride"] = 111.57, ["Neon"] = 397.83, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 524.98, ["Mega|Fly|Ride"] = 3139.58}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 6.57, ["Fly"] = 27.96, ["Ride"] = 27.24, ["Fly|Ride"] = 72.12, ["Neon"] = 67.46, ["Neon|Fly"] = 269.52, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 360.94, ["Mega|Fly|Ride"] = 559.05}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 379.32, ["Fly"] = 837.51, ["Ride"] = 392.44, ["Fly|Ride"] = 498.75, ["Neon"] = 1568.76, ["Neon|Ride"] = 1680, ["Neon|Fly|Ride"] = 1535.78, ["Mega|Fly|Ride"] = 4856.25}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 4.73, ["Fly"] = 103.72, ["Ride"] = 38.05, ["Fly|Ride"] = 111.57, ["Neon"] = 32.07, ["Neon|Ride"] = 99.2, ["Neon|Fly|Ride"] = 191.59, ["Mega"] = 128.52, ["Mega|Fly"] = 263.92, ["Mega|Ride"] = 209.23, ["Mega|Fly|Ride"] = 229.69}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 102.38, ["Fly"] = 194.73, ["Ride"] = 129.84, ["Fly|Ride"] = 189, ["Neon"] = 626.07, ["Neon|Fly"] = 525, ["Neon|Ride"] = 524.9, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2415.14}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 10.4, ["Fly"] = 19.05, ["Ride"] = 18.8, ["Fly|Ride"] = 30.72, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 90.02, ["Mega"] = 2512.51, ["Mega|Fly|Ride"] = 949.85}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 7.29}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 63, ["Ride"] = 58.35, ["Fly|Ride"] = 418.76, ["Neon"] = 421.32, ["Neon|Fly"] = 417.72, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 502.51, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1815.3}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 12.56, ["Fly"] = 103.66, ["Ride"] = 34.13, ["Fly|Ride"] = 97.46, ["Neon"] = 91.88, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 228.56, ["Mega"] = 627.09, ["Mega|Ride"] = 627.09, ["Mega|Fly|Ride"] = 559.05}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 26.17}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 30.32, ["Fly"] = 210, ["Ride"] = 109.79, ["Fly|Ride"] = 85.32, ["Neon"] = 283.71, ["Neon|Ride"] = 279.54, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 1570.33, ["Mega|Ride"] = 2093.76, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 2.62, ["Ride"] = 29.23, ["Fly|Ride"] = 136.57, ["Neon"] = 20.79, ["Neon|Ride"] = 103.31, ["Neon|Fly|Ride"] = 279.54, ["Mega"] = 131.25, ["Mega|Ride"] = 213.42, ["Mega|Fly|Ride"] = 358.98}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 11.33, ["Fly"] = 52.49, ["Ride"] = 28.25, ["Fly|Ride"] = 79.58, ["Neon"] = 159.11, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 209.39, ["Mega|Ride"] = 638.6, ["Mega|Fly|Ride"] = 590.28}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 438.38, ["Ride"] = 495.25, ["Fly|Ride"] = 485.63, ["Neon|Fly|Ride"] = 1955.57, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 26.25, ["Fly"] = 98.42, ["Ride"] = 57.58, ["Fly|Ride"] = 131.25, ["Neon"] = 129.94, ["Neon|Ride"] = 257.28, ["Neon|Fly|Ride"] = 326.21, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 2730}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 54.51, ["Fly"] = 119.36, ["Ride"] = 70.87, ["Fly|Ride"] = 118.13, ["Neon"] = 312.26, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 458.1, ["Mega|Fly|Ride"] = 837.51}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 15.75, ["Fly"] = 83.76, ["Ride"] = 45.94, ["Fly|Ride"] = 119.55, ["Neon"] = 97, ["Neon|Ride"] = 155.65, ["Neon|Fly|Ride"] = 293.14, ["Mega"] = 414.74, ["Mega|Fly"] = 525, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 634.04}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 10538.87, ["Fly"] = 26250, ["Ride"] = 13617.71, ["Fly|Ride"] = 8400, ["Neon|Fly|Ride"] = 16493.93, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1366.66, ["Fly"] = 1487.07, ["Ride"] = 1509.38, ["Fly|Ride"] = 1508.07, ["Neon|Fly|Ride"] = 3896.82, ["Mega|Fly|Ride"] = 14437.5}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 585.21, ["Ride"] = 760.05, ["Fly|Ride"] = 538.12, ["Neon"] = 2543.16, ["Neon|Fly|Ride"] = 2373.28, ["Mega|Fly|Ride"] = 6979.5}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 11.46, ["Fly"] = 20.29, ["Ride"] = 21.61, ["Fly|Ride"] = 35.89, ["Neon"] = 67.69, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 129.93, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 572.25}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 3.28, ["Fly"] = 78.74, ["Ride"] = 28.28, ["Fly|Ride"] = 48.18, ["Neon"] = 20.6, ["Neon|Ride"] = 54.85, ["Mega"] = 159.11, ["Mega|Ride"] = 189.98, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 33.77, ["Fly"] = 53.8, ["Ride"] = 47.71, ["Fly|Ride"] = 80.07, ["Neon"] = 194.73, ["Neon|Ride"] = 157.49, ["Neon|Fly|Ride"] = 204.15, ["Mega|Fly|Ride"] = 586.59}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 2.81, ["Fly"] = 23.05, ["Ride"] = 15.18, ["Fly|Ride"] = 31.08, ["Neon"] = 31.48, ["Neon|Fly"] = 76.92, ["Neon|Ride"] = 46.24, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 261.19, ["Mega|Ride"] = 321.57, ["Mega|Fly|Ride"] = 408.19}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 334.59, ["Fly"] = 369.49, ["Ride"] = 321.41, ["Fly|Ride"] = 360.94, ["Neon"] = 1535.78, ["Neon|Fly|Ride"] = 1672.92, ["Mega|Fly|Ride"] = 3654}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 12.89, ["Fly"] = 59.39, ["Ride"] = 30.94, ["Fly|Ride"] = 105, ["Neon"] = 208.95, ["Neon|Fly"] = 308.84, ["Neon|Ride"] = 142.7, ["Neon|Fly|Ride"] = 257.25, ["Mega"] = 795.64, ["Mega|Ride"] = 787.4, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 11.57, ["Fly"] = 20.98, ["Ride"] = 20.9, ["Fly|Ride"] = 45.03, ["Neon"] = 98.42, ["Neon|Fly"] = 135.37, ["Neon|Ride"] = 129.06, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 425.25}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 577.5, ["Fly"] = 1048.69, ["Ride"] = 519.26, ["Fly|Ride"] = 536.02, ["Neon|Fly|Ride"] = 2093.76, ["Mega|Fly|Ride"] = 9971.07}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1443.75, ["Ride"] = 1214.06, ["Fly|Ride"] = 1384.69, ["Neon"] = 4885.76, ["Neon|Ride"] = 4299.52, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13782.3}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 88.23, ["Fly"] = 136.11, ["Ride"] = 103.69, ["Fly|Ride"] = 108.61, ["Neon"] = 971.25, ["Neon|Ride"] = 585.46, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 2373.28}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 129.74, ["Fly"] = 196.87, ["Ride"] = 183.32, ["Fly|Ride"] = 242.53, ["Neon"] = 849.02, ["Neon|Fly"] = 697.24, ["Neon|Ride"] = 630, ["Neon|Fly|Ride"] = 610.71, ["Mega"] = 2652.79, ["Mega|Ride"] = 3071.54, ["Mega|Fly|Ride"] = 2792.56}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 27.95, ["Fly"] = 120.41, ["Ride"] = 53.7, ["Fly|Ride"] = 121.12, ["Neon"] = 391.54, ["Neon|Ride"] = 272.98, ["Mega|Ride"] = 2093.76, ["Mega|Fly|Ride"] = 1044.8}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 208.69, ["Ride"] = 315, ["Fly|Ride"] = 335.02, ["Neon|Fly"] = 949.82, ["Neon|Fly|Ride"] = 1329.78, ["Mega|Fly|Ride"] = 4116.34}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2059.23, ["Fly"] = 2256.37, ["Ride"] = 2483.25, ["Fly|Ride"] = 2230.62, ["Neon|Fly|Ride"] = 10468.73, ["Mega|Fly|Ride"] = 28494.95}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 53.79, ["Fly"] = 209.39, ["Ride"] = 51.83, ["Fly|Ride"] = 196.88, ["Neon"] = 511.88, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 343.87, ["Mega|Ride"] = 1117.04, ["Mega|Fly|Ride"] = 2512.51}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 643.12, ["Fly"] = 616.88, ["Ride"] = 618.19, ["Fly|Ride"] = 627.27, ["Neon|Ride"] = 1535.78, ["Neon|Fly|Ride"] = 1214.12, ["Mega|Fly|Ride"] = 3359.55}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 39.26, ["Fly"] = 48.64, ["Ride"] = 39.38, ["Fly|Ride"] = 93.19, ["Neon|Ride"] = 265.93, ["Neon|Fly|Ride"] = 242.82, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3, ["Fly"] = 43.18, ["Ride"] = 16.37, ["Fly|Ride"] = 45.94, ["Neon"] = 18.86, ["Neon|Fly"] = 139.13, ["Neon|Ride"] = 45.45, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 138.25, ["Mega|Fly"] = 249.38, ["Mega|Ride"] = 142.53, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 55.63, ["Ride"] = 128.31, ["Fly|Ride"] = 253.32, ["Neon"] = 345.49, ["Neon|Ride"] = 487.86, ["Neon|Fly|Ride"] = 698.29, ["Mega"] = 1530.54, ["Mega|Fly|Ride"] = 1695.2}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 845.24, ["Fly"] = 892.7, ["Ride"] = 839.69, ["Fly|Ride"] = 904.73, ["Neon|Ride"] = 2598.75, ["Neon|Fly|Ride"] = 2690.63, ["Mega|Fly|Ride"] = 10958.07}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 721.88, ["Ride"] = 1027.09, ["Fly|Ride"] = 971.52, ["Neon|Fly|Ride"] = 4178.08, ["Mega|Fly|Ride"] = 15213.15}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 8.76, ["Fly"] = 25.71, ["Ride"] = 23.61, ["Fly|Ride"] = 38.68, ["Neon"] = 91.88, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 137.81, ["Mega|Fly|Ride"] = 700.95}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 6.3, ["Ride"] = 19.69, ["Fly|Ride"] = 70.16, ["Neon"] = 140.3, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 623.44, ["Mega|Ride"] = 730.73, ["Mega|Fly|Ride"] = 611.39}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.02, ["Ride"] = 23.63, ["Fly|Ride"] = 102.38, ["Neon"] = 19.57, ["Neon|Fly"] = 317.01, ["Neon|Ride"] = 54.48, ["Neon|Fly|Ride"] = 170.65, ["Mega"] = 162.46, ["Mega|Fly"] = 157.5, ["Mega|Ride"] = 279.54, ["Mega|Fly|Ride"] = 353.07}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 27.67, ["Fly"] = 57.25, ["Ride"] = 45.92, ["Fly|Ride"] = 99.47, ["Neon"] = 265.93, ["Neon|Ride"] = 216.57, ["Neon|Fly|Ride"] = 233.04, ["Mega|Fly|Ride"] = 1095.04}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 60.39, ["Ride"] = 135.19, ["Fly|Ride"] = 448.08, ["Neon"] = 424.07, ["Neon|Ride"] = 479.34, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2024.66, ["Mega|Ride"] = 1570.33, ["Mega|Fly|Ride"] = 1570.33}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 14.44, ["Fly"] = 43.31, ["Ride"] = 35.06, ["Fly|Ride"] = 63, ["Neon"] = 65.63, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 627.09, ["Mega|Ride"] = 352.97, ["Mega|Fly|Ride"] = 393.74}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 39.26, ["Ride"] = 44.63, ["Fly|Ride"] = 75.27, ["Neon"] = 242.82, ["Neon|Fly"] = 1396.55, ["Neon|Ride"] = 190.21, ["Neon|Fly|Ride"] = 196.86, ["Mega"] = 2100, ["Mega|Ride"] = 1043.75, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 2.14, ["Fly"] = 20.89, ["Ride"] = 16.93, ["Fly|Ride"] = 41.89, ["Neon"] = 29.53, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 732.83, ["Mega|Ride"] = 311.98, ["Mega|Fly|Ride"] = 590.62}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 4.03, ["Fly"] = 46.41, ["Ride"] = 32.82, ["Fly|Ride"] = 32104.42, ["Neon"] = 37.41, ["Neon|Fly"] = 115.54, ["Neon|Ride"] = 73.5, ["Neon|Fly|Ride"] = 142.49, ["Mega"] = 300.47, ["Mega|Ride"] = 315}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 44.54, ["Fly"] = 65.63, ["Ride"] = 53.34, ["Fly|Ride"] = 94.99, ["Neon"] = 411.99, ["Neon|Ride"] = 279.34, ["Neon|Fly|Ride"] = 262.49, ["Mega|Fly|Ride"] = 1074.91}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1574.9, ["Fly"] = 1575, ["Ride"] = 1417.4, ["Fly|Ride"] = 1481.81, ["Neon|Fly|Ride"] = 3858.75, ["Mega|Fly|Ride"] = 14377.67}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 459.38, ["Fly"] = 455.82, ["Ride"] = 393.75, ["Fly|Ride"] = 474.92, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 10468.73}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 288.75, ["Ride"] = 342.57, ["Fly|Ride"] = 544.39, ["Neon"] = 1207.5, ["Neon|Ride"] = 1535.78, ["Neon|Fly|Ride"] = 1675.01, ["Mega|Fly|Ride"] = 7654.5}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 36.29}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 27.55, ["Fly"] = 131.25, ["Ride"] = 47.25, ["Fly|Ride"] = 98.44, ["Neon|Fly"] = 418.76, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 314.08, ["Mega|Ride"] = 1675.01, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 72583.77, ["Fly"] = 65625, ["Ride"] = 35437.5, ["Fly|Ride"] = 17979.94, ["Neon|Fly|Ride"] = 35437.49, ["Mega"] = 209374.23, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 279.05, ["Fly"] = 611.63, ["Ride"] = 292.56, ["Fly|Ride"] = 339.94, ["Neon"] = 945, ["Neon|Fly"] = 1108.93, ["Neon|Ride"] = 873.71, ["Neon|Fly|Ride"] = 891.44, ["Mega"] = 3978.13, ["Mega|Ride"] = 4186.45, ["Mega|Fly|Ride"] = 3973.94}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 195.78, ["Fly"] = 525, ["Ride"] = 209.39, ["Fly|Ride"] = 196.88, ["Neon|Fly|Ride"] = 1741.77}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 123.19, ["Fly"] = 279.54, ["Ride"] = 157.5, ["Fly|Ride"] = 229.48, ["Neon|Ride"] = 644.53, ["Neon|Fly|Ride"] = 654.94, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 11.46, ["Fly"] = 94.5, ["Ride"] = 30.02, ["Fly|Ride"] = 70.16, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 710.01, ["Mega|Ride"] = 698.29, ["Mega|Fly|Ride"] = 748.53}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3936.19, ["Ride"] = 3937.5, ["Fly|Ride"] = 4725, ["Neon"] = 27218.66, ["Neon|Fly|Ride"] = 27916.92}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 26.24, ["Fly"] = 62.83, ["Ride"] = 28.28, ["Fly|Ride"] = 47.98, ["Neon"] = 279.54, ["Neon|Ride"] = 343.88, ["Neon|Fly|Ride"] = 224.05, ["Mega|Ride"] = 1396.55, ["Mega|Fly|Ride"] = 731.38}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 39.38, ["Fly"] = 106.51, ["Ride"] = 56.79, ["Fly|Ride"] = 74.82, ["Neon"] = 406.2, ["Neon|Fly"] = 1396.55, ["Neon|Ride"] = 204.75, ["Neon|Fly|Ride"] = 241.5, ["Mega|Fly|Ride"] = 1372.87}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 616.88, ["Ride"] = 712.69, ["Fly|Ride"] = 682.5, ["Neon"] = 2485.28, ["Neon|Ride"] = 1968.75, ["Neon|Fly|Ride"] = 2034.38, ["Mega"] = 8165.6, ["Mega|Fly"] = 8165.6, ["Mega|Fly|Ride"] = 7614.95}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 14.48, ["Fly"] = 26.16, ["Ride"] = 20.13, ["Fly|Ride"] = 40.1, ["Neon"] = 116.82, ["Neon|Fly"] = 158.09, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 141.96, ["Mega|Fly|Ride"] = 858.44}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 9.19, ["Ride"] = 27.56, ["Fly|Ride"] = 79.56, ["Neon"] = 81.67, ["Neon|Ride"] = 118.74, ["Neon|Fly|Ride"] = 208.69, ["Mega|Ride"] = 730.73}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 103.69, ["Ride"] = 128.62, ["Fly|Ride"] = 137.16, ["Neon"] = 787.18, ["Neon|Ride"] = 698.29, ["Neon|Fly|Ride"] = 811.13, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 16.77, ["Fly"] = 42.14, ["Ride"] = 62.79, ["Fly|Ride"] = 131.06, ["Neon"] = 72.1, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 307.13, ["Mega|Fly"] = 726.54, ["Mega|Ride"] = 276.29, ["Mega|Fly|Ride"] = 409.31}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3930.83, ["Ride"] = 3883.65, ["Fly|Ride"] = 4182.51, ["Neon"] = 18843.7, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 9842.44, ["Mega"] = 36640.5, ["Mega|Fly|Ride"] = 36093.6}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 23.63, ["Fly"] = 140.3, ["Ride"] = 65.34, ["Fly|Ride"] = 154.95, ["Neon"] = 757.31, ["Neon|Ride"] = 190.32, ["Neon|Fly|Ride"] = 571.6, ["Mega"] = 768.42, ["Mega|Ride"] = 1038.51, ["Mega|Fly|Ride"] = 782.23}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7251.57, ["Fly"] = 8654.5, ["Ride"] = 6857.82, ["Fly|Ride"] = 5512.5, ["Neon|Ride"] = 22333.97, ["Neon|Fly|Ride"] = 16572.67, ["Mega|Fly|Ride"] = 64905.53}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.37, ["Fly"] = 22.32, ["Ride"] = 14.4, ["Fly|Ride"] = 31.29, ["Neon"] = 23.63, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 195.78, ["Mega|Ride"] = 209.39, ["Mega|Fly|Ride"] = 346.53}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 24.92, ["Fly"] = 37.68, ["Ride"] = 28.28, ["Fly|Ride"] = 50.65, ["Neon"] = 182.17, ["Neon|Fly"] = 231.38, ["Neon|Ride"] = 102.61, ["Neon|Fly|Ride"] = 158.22, ["Mega|Ride"] = 977.8, ["Mega|Fly|Ride"] = 935.82}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 4.2}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 9.09, ["Ride"] = 31.89, ["Fly|Ride"] = 116.03, ["Neon"] = 89.14, ["Neon|Ride"] = 139.12, ["Mega"] = 1049.9, ["Mega|Ride"] = 878.34, ["Mega|Fly|Ride"] = 634.04}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 26.25, ["Fly"] = 110.98, ["Ride"] = 43.32, ["Fly|Ride"] = 99.75, ["Neon"] = 203.44, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 317.22, ["Mega"] = 945, ["Mega|Ride"] = 949.85, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 12.02, ["Fly"] = 20.15, ["Ride"] = 21.37, ["Fly|Ride"] = 34.99, ["Neon|Ride"] = 140.3, ["Neon|Fly|Ride"] = 179.55, ["Mega"] = 2512.51, ["Mega|Ride"] = 592.47, ["Mega|Fly|Ride"] = 531.57}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8515.26}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.98}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 17.49}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 232.32, ["Ride"] = 251.27, ["Fly|Ride"] = 223.13, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 12.75, ["Fly"] = 128.78, ["Ride"] = 27.34, ["Fly|Ride"] = 125.87, ["Neon"] = 154.95, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 265.13, ["Mega"] = 525, ["Mega|Ride"] = 523.61, ["Mega|Fly|Ride"] = 977.8}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 9.52}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.83, ["Ride"] = 26.25, ["Fly|Ride"] = 83.76, ["Neon|Ride"] = 182.17, ["Neon|Fly|Ride"] = 140.3}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 3051.64}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 194.8, ["Fly"] = 418.76, ["Ride"] = 211.32, ["Fly|Ride"] = 328.13, ["Neon"] = 907.66, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 852.16, ["Mega|Ride"] = 4048.26, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 77.78, ["Ride"] = 106.32, ["Fly|Ride"] = 209.39, ["Neon"] = 559.05, ["Neon|Ride"] = 502.51, ["Neon|Fly|Ride"] = 1435.35, ["Mega|Ride"] = 2093.76, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 131.25, ["Fly"] = 204.73, ["Ride"] = 196.81, ["Fly|Ride"] = 258.57, ["Neon|Ride"] = 787.4, ["Neon|Fly|Ride"] = 840, ["Mega|Fly|Ride"] = 3314.4}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1967.44, ["Fly"] = 2362.5, ["Ride"] = 1967.44, ["Fly|Ride"] = 2208.93, ["Neon|Ride"] = 8708.94, ["Neon|Fly|Ride"] = 7223.43, ["Mega|Fly|Ride"] = 31266.92}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 1.79}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 14.15, ["Fly"] = 98.42, ["Ride"] = 28.88, ["Fly|Ride"] = 99.74, ["Neon"] = 127.32, ["Neon|Ride"] = 154.62, ["Neon|Fly|Ride"] = 195.78, ["Mega"] = 941.15, ["Mega|Ride"] = 1029.39, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 686.44, ["Fly"] = 2100, ["Ride"] = 748.13, ["Fly|Ride"] = 963.14, ["Neon|Ride"] = 3071.54, ["Neon|Fly|Ride"] = 4116.34, ["Mega|Fly|Ride"] = 16622.06}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 40.68}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 12.87, ["Ride"] = 52.36, ["Fly|Ride"] = 279.54, ["Neon"] = 81.38, ["Neon|Ride"] = 106.5, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 418.76, ["Mega|Ride"] = 418.76, ["Mega|Fly|Ride"] = 505.32}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 5.39, ["Fly"] = 167.23, ["Ride"] = 27.56, ["Fly|Ride"] = 100.51, ["Neon"] = 39.38, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 203.7, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 634.15}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 53.82}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 13.19, ["Fly"] = 108.92, ["Ride"] = 30.9, ["Fly|Ride"] = 81.67, ["Neon"] = 94.99, ["Neon|Ride"] = 251.27, ["Neon|Fly|Ride"] = 254.63, ["Mega|Fly|Ride"] = 2217.88}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 31.42, ["Fly"] = 77.48, ["Ride"] = 39.29, ["Fly|Ride"] = 52.41, ["Neon|Ride"] = 418.76, ["Neon|Fly|Ride"] = 317.22, ["Mega|Ride"] = 1780.95, ["Mega|Fly|Ride"] = 975.7}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6561.19, ["Fly"] = 10237.5, ["Ride"] = 6490.61, ["Fly|Ride"] = 5247.9, ["Neon|Fly|Ride"] = 12468.75, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 8.4, ["Fly"] = 65.62, ["Ride"] = 33.52, ["Fly|Ride"] = 81.37, ["Neon"] = 44.56, ["Neon|Fly"] = 77.48, ["Neon|Ride"] = 70.16, ["Neon|Fly|Ride"] = 178.11, ["Mega"] = 532.88, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 478.62}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 15.65}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 95.23, ["Fly"] = 370.6, ["Ride"] = 132.59, ["Fly|Ride"] = 183.75, ["Neon"] = 525, ["Neon|Ride"] = 455.23, ["Neon|Fly|Ride"] = 698.29, ["Mega"] = 2879.59, ["Mega|Fly|Ride"] = 1951.38}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 45.29, ["Fly"] = 142.52, ["Ride"] = 69.69, ["Fly|Ride"] = 164.07, ["Neon"] = 257.24, ["Neon|Ride"] = 272.37, ["Neon|Fly|Ride"] = 317.03, ["Mega"] = 2374.59, ["Mega|Ride"] = 2826.56, ["Mega|Fly|Ride"] = 1535.78}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 20.09, ["Fly"] = 70.47, ["Ride"] = 29.95, ["Fly|Ride"] = 59.73, ["Neon"] = 156.19, ["Neon|Ride"] = 142.87, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 1016.21, ["Mega|Ride"] = 871.48, ["Mega|Fly|Ride"] = 774.37}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 3.86, ["Fly"] = 65.54, ["Ride"] = 22.23, ["Fly|Ride"] = 98.44, ["Neon"] = 26.15, ["Neon|Fly"] = 70.16, ["Neon|Ride"] = 51.41, ["Neon|Fly|Ride"] = 128.62, ["Mega"] = 169.32, ["Mega|Fly"] = 6979.5, ["Mega|Ride"] = 178.29, ["Mega|Fly|Ride"] = 269.07}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 9.18, ["Ride"] = 19.69, ["Fly|Ride"] = 92.14, ["Neon"] = 86.63, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 525, ["Mega|Ride"] = 426.57, ["Mega|Fly|Ride"] = 740.6}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 19.59, ["Fly"] = 24.83, ["Ride"] = 24.93, ["Fly|Ride"] = 47.52, ["Neon"] = 363.27, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 144.35, ["Mega|Fly|Ride"] = 837.51}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 190.31}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 18.8, ["Ride"] = 101.07, ["Fly|Ride"] = 279.54, ["Neon"] = 170.63, ["Neon|Ride"] = 195.78, ["Neon|Fly|Ride"] = 573.7, ["Mega"] = 1179.84, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 209.9, ["Ride"] = 443.63, ["Fly|Ride"] = 1583.84}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 41.89, ["Fly"] = 212.31, ["Ride"] = 102.38, ["Fly|Ride"] = 216.61, ["Neon"] = 256.49, ["Neon|Ride"] = 295.32, ["Neon|Fly|Ride"] = 423.62, ["Mega"] = 1035.57, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1079.16}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 918.74, ["Fly"] = 1354.67, ["Ride"] = 1007.97, ["Fly|Ride"] = 1030.32, ["Neon|Fly"] = 4107.98, ["Neon|Ride"] = 3281.25, ["Neon|Fly|Ride"] = 3439, ["Mega|Fly|Ride"] = 11735.06}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 431.32, ["Fly"] = 698.29, ["Ride"] = 413.43, ["Fly|Ride"] = 393.75, ["Neon"] = 2139.38, ["Neon|Ride"] = 2093.76, ["Neon|Fly|Ride"] = 3559.38, ["Mega"] = 12562.47, ["Mega|Fly|Ride"] = 8990.63}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 71.52}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 7.88, ["Fly"] = 23.27, ["Ride"] = 20.97, ["Fly|Ride"] = 43.32, ["Neon"] = 78.75, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 92.14, ["Neon|Fly|Ride"] = 166.69, ["Mega"] = 437.26, ["Mega|Ride"] = 698.29, ["Mega|Fly|Ride"] = 522.41}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 231.28, ["Fly"] = 392.03, ["Ride"] = 280.75, ["Fly|Ride"] = 320.25, ["Neon"] = 1087.71, ["Neon|Ride"] = 1059.06, ["Neon|Fly|Ride"] = 787.49, ["Mega|Fly|Ride"] = 3266.25}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 14.2}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 139.13, ["Ride"] = 185.38, ["Fly|Ride"] = 259.88, ["Neon"] = 585.38, ["Neon|Ride"] = 557.82, ["Neon|Fly|Ride"] = 728.44, ["Mega"] = 2652.79, ["Mega|Ride"] = 3054.79, ["Mega|Fly|Ride"] = 3245.31}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 110.25, ["Ride"] = 128.65, ["Fly|Ride"] = 136.56, ["Neon"] = 837.51, ["Neon|Fly"] = 590.63, ["Neon|Ride"] = 888.57, ["Neon|Fly|Ride"] = 913.5, ["Mega|Ride"] = 5584.02, ["Mega|Fly|Ride"] = 2512.51}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 3.9, ["Ride"] = 29.08, ["Fly|Ride"] = 170.65, ["Neon"] = 27.57, ["Neon|Ride"] = 86.56, ["Neon|Fly|Ride"] = 168, ["Mega"] = 264.75, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 836.47}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 12.25, ["Fly"] = 62.83, ["Ride"] = 27.13, ["Fly|Ride"] = 76.28, ["Neon"] = 140.3, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 317.03, ["Mega|Ride"] = 815.53, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 9.97, ["Fly"] = 102.35, ["Ride"] = 28.88, ["Fly|Ride"] = 104.69, ["Neon"] = 65.63, ["Neon|Ride"] = 101.06, ["Neon|Fly|Ride"] = 256.57, ["Mega"] = 498.75, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 3.29, ["Fly"] = 98.18, ["Ride"] = 52.49, ["Fly|Ride"] = 167.23, ["Neon"] = 21.15, ["Neon|Ride"] = 69.03, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 136.49, ["Mega|Ride"] = 179.81, ["Mega|Fly|Ride"] = 261.18}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 241.5, ["Ride"] = 261.84, ["Fly|Ride"] = 359.63, ["Neon"] = 1647.79, ["Neon|Ride"] = 1326.4, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 5527.5}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 136.5, ["Fly"] = 323.03, ["Ride"] = 153.87, ["Fly|Ride"] = 241.49, ["Neon"] = 698.29, ["Neon|Ride"] = 549.94, ["Neon|Fly|Ride"] = 788.38, ["Mega"] = 2533.7, ["Mega|Fly|Ride"] = 2387.77}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 69.57, ["Ride"] = 69.34, ["Fly|Ride"] = 125.64, ["Neon"] = 279.54, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 416.07, ["Mega"] = 1815.3, ["Mega|Fly|Ride"] = 1801.13}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 14.63, ["Fly"] = 126, ["Ride"] = 58.24, ["Fly|Ride"] = 279.54, ["Neon|Ride"] = 603.16, ["Neon|Fly|Ride"] = 488.91, ["Mega|Fly|Ride"] = 1955.57}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 11.82, ["Fly"] = 59.07, ["Ride"] = 34.13, ["Fly|Ride"] = 81.59, ["Neon"] = 77.42, ["Neon|Fly"] = 279.54, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 148.67, ["Mega"] = 371.44, ["Mega|Fly"] = 525, ["Mega|Ride"] = 463.07, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.22, ["Fly"] = 43.32, ["Ride"] = 18.67, ["Fly|Ride"] = 44.61, ["Neon"] = 20.95, ["Neon|Fly"] = 66.92, ["Neon|Ride"] = 35.35, ["Neon|Fly|Ride"] = 118.1, ["Mega"] = 136.5, ["Mega|Ride"] = 141.91, ["Mega|Fly|Ride"] = 253.62}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 951.57, ["Fly"] = 911.66, ["Ride"] = 927.3, ["Fly|Ride"] = 958.13, ["Neon"] = 3043.27, ["Neon|Fly"] = 3246.03, ["Neon|Ride"] = 8374.98, ["Neon|Fly|Ride"] = 2624.88, ["Mega|Fly|Ride"] = 10294.95}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 341.16, ["Ride"] = 393.75, ["Fly|Ride"] = 475.3, ["Neon"] = 1277.38, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1583.87, ["Mega"] = 10468.73, ["Mega|Fly|Ride"] = 5862.49}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 81.24, ["Fly"] = 140.3, ["Ride"] = 103.64, ["Fly|Ride"] = 207.31, ["Neon"] = 283.08, ["Neon|Ride"] = 319.81, ["Neon|Fly|Ride"] = 534.3, ["Mega"] = 1312.5, ["Mega|Ride"] = 1675.01, ["Mega|Fly|Ride"] = 1658.26}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 232.32, ["Fly"] = 283.5, ["Ride"] = 219.19, ["Fly|Ride"] = 246.88, ["Neon|Fly|Ride"] = 1094.62, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 18.21, ["Fly"] = 52.5, ["Ride"] = 26.25, ["Fly|Ride"] = 68.62, ["Neon"] = 150.94, ["Neon|Ride"] = 97.46, ["Neon|Fly|Ride"] = 236.25, ["Mega|Fly|Ride"] = 791.94}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 236.25, ["Ride"] = 236.25, ["Fly|Ride"] = 613.48, ["Neon"] = 940.64, ["Neon|Ride"] = 942.27, ["Neon|Fly|Ride"] = 708.75, ["Mega"] = 4171.13, ["Mega|Ride"] = 4606.25, ["Mega|Fly|Ride"] = 3818.31}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 45.94, ["Fly"] = 125.98, ["Ride"] = 76.21, ["Fly|Ride"] = 100.12, ["Neon|Ride"] = 559.05, ["Neon|Fly|Ride"] = 559.05, ["Mega|Fly|Ride"] = 1732.5}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1890, ["Ride"] = 1968.75, ["Fly|Ride"] = 1968.75, ["Neon|Ride"] = 11082.17, ["Neon|Fly|Ride"] = 12562.47, ["Mega"] = 50249.83, ["Mega|Fly|Ride"] = 24427.71}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 10.79, ["Fly"] = 76.36, ["Ride"] = 34.4, ["Fly|Ride"] = 70.75, ["Neon"] = 52.5, ["Neon|Fly"] = 237.57, ["Neon|Ride"] = 103.66, ["Neon|Fly|Ride"] = 192.09, ["Mega"] = 418.76, ["Mega|Fly"] = 761.1, ["Mega|Ride"] = 408.29, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 53.01, ["Ride"] = 92.65, ["Fly|Ride"] = 126.95, ["Neon"] = 223.13, ["Neon|Ride"] = 349.67, ["Mega"] = 1662.22, ["Mega|Fly|Ride"] = 1458.19}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 78.75, ["Fly"] = 74.76, ["Ride"] = 78, ["Fly|Ride"] = 97.13, ["Neon"] = 525, ["Neon|Fly|Ride"] = 393.74, ["Mega|Fly|Ride"] = 1842.38}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2135.97, ["Fly"] = 1584.21, ["Ride"] = 1050, ["Fly|Ride"] = 1127.2, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 480.77, ["Fly"] = 525, ["Ride"] = 589.4, ["Fly|Ride"] = 628.14, ["Neon|Fly|Ride"] = 3166.51}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 67.93, ["Fly"] = 317.08, ["Ride"] = 86.13, ["Fly|Ride"] = 207.37, ["Neon"] = 416.67, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 557.82, ["Mega|Ride"] = 2645.46, ["Mega|Fly|Ride"] = 2792.02}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 6.35, ["Ride"] = 19.59, ["Fly|Ride"] = 41.89, ["Neon"] = 69.16, ["Neon|Fly"] = 140.3, ["Neon|Ride"] = 64.97, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 603.75}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 39.78, ["Fly"] = 68.25, ["Ride"] = 54.57, ["Fly|Ride"] = 104.7, ["Neon"] = 209.39, ["Neon|Fly"] = 328.73, ["Neon|Ride"] = 209.39, ["Neon|Fly|Ride"] = 236.24, ["Mega"] = 1706.25, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 748.13, ["Fly"] = 1092.57, ["Ride"] = 759.94, ["Fly|Ride"] = 826.88, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2162.42, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 760.46}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4921.88, ["Ride"] = 6280.19, ["Fly|Ride"] = 5884.03, ["Neon"] = 42000, ["Neon|Ride"] = 30004.4, ["Neon|Fly|Ride"] = 23429.98, ["Mega|Fly|Ride"] = 89333.71}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 328.13, ["Fly"] = 496.12, ["Ride"] = 393.75, ["Fly|Ride"] = 454.36, ["Neon"] = 1675.01, ["Neon|Fly|Ride"] = 2198.44, ["Mega"] = 6280.19, ["Mega|Fly|Ride"] = 6648.84}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 70.88, ["Fly"] = 279.54, ["Ride"] = 118.13, ["Fly|Ride"] = 336, ["Neon|Ride"] = 559.05, ["Neon|Fly|Ride"] = 623.95, ["Mega|Fly|Ride"] = 2151.35}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 13.2, ["Fly"] = 65.62, ["Ride"] = 27.91, ["Fly|Ride"] = 85.34, ["Neon"] = 112.03, ["Neon|Fly"] = 1266.83, ["Neon|Ride"] = 125.64, ["Neon|Fly|Ride"] = 181.13, ["Mega"] = 975.7, ["Mega|Ride"] = 837.51, ["Mega|Fly|Ride"] = 837.51}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 7.77, ["Fly"] = 33.52, ["Ride"] = 22.66, ["Fly|Ride"] = 44.36, ["Neon"] = 209.39, ["Neon|Ride"] = 317.01, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2219.38}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 12.84, ["Ride"] = 26.24, ["Fly|Ride"] = 116.82, ["Neon"] = 130.73, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 231.38, ["Mega"] = 670.69, ["Mega|Ride"] = 658.88, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 5.79, ["Fly"] = 77.48, ["Ride"] = 19.91, ["Fly|Ride"] = 48.57, ["Neon"] = 35.43, ["Neon|Ride"] = 55.82, ["Neon|Fly|Ride"] = 138.21, ["Mega"] = 316.17, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 279.54}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 22.32, ["Fly"] = 90.57, ["Ride"] = 34.13, ["Fly|Ride"] = 139.13, ["Neon"] = 203.44, ["Neon|Fly"] = 837.51, ["Neon|Ride"] = 247.08, ["Neon|Fly|Ride"] = 418.76, ["Mega"] = 587.81, ["Mega|Ride"] = 1246.88}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 420, ["Fly"] = 538.12, ["Ride"] = 447.75, ["Fly|Ride"] = 494.82, ["Neon"] = 1570.33, ["Neon|Ride"] = 1465.64, ["Neon|Fly|Ride"] = 1168.13, ["Mega"] = 7875, ["Mega|Fly|Ride"] = 5441.66}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.1, ["Fly"] = 19.25, ["Ride"] = 15.31, ["Fly|Ride"] = 31.42, ["Neon"] = 18.38, ["Neon|Ride"] = 21.95, ["Neon|Fly|Ride"] = 70.34, ["Mega"] = 837.51, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 44.1, ["Fly"] = 100.63, ["Ride"] = 69.43, ["Fly|Ride"] = 118.12, ["Neon"] = 192.94, ["Neon|Fly"] = 333.15, ["Neon|Ride"] = 170.61, ["Neon|Fly|Ride"] = 255.8, ["Mega"] = 594.19, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 576.19}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 771.75, ["Ride"] = 800.63, ["Fly|Ride"] = 851.82, ["Neon|Ride"] = 1988.23, ["Neon|Fly|Ride"] = 1658.01, ["Mega|Fly|Ride"] = 3936.18}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 28.74, ["Fly"] = 57.75, ["Ride"] = 45.94, ["Fly|Ride"] = 78.75, ["Neon"] = 282.59, ["Neon|Ride"] = 188.87, ["Neon|Fly|Ride"] = 237.57, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 851.75}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 335.02, ["Fly"] = 384.56, ["Ride"] = 288.75, ["Fly|Ride"] = 345.19, ["Neon|Ride"] = 1815.3, ["Neon|Fly|Ride"] = 1117.04}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 170.63, ["Fly"] = 274.3, ["Ride"] = 131.25, ["Fly|Ride"] = 233.63, ["Neon"] = 977.8, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 819.72, ["Mega|Fly|Ride"] = 3420.15}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 835.42, ["Ride"] = 754.68, ["Fly|Ride"] = 936.97, ["Neon|Fly|Ride"] = 3001.4, ["Mega|Fly|Ride"] = 7611.19}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 17.57, ["Fly"] = 83.76, ["Ride"] = 41.67, ["Fly|Ride"] = 110.25, ["Neon"] = 104.7, ["Neon|Fly"] = 284.95, ["Neon|Ride"] = 106.8, ["Neon|Fly|Ride"] = 150.76, ["Mega"] = 354.38, ["Mega|Ride"] = 335.65, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4084.49, ["Fly"] = 3543.75, ["Ride"] = 3936.19, ["Fly|Ride"] = 3587.01, ["Neon"] = 13959, ["Neon|Fly|Ride"] = 7350, ["Mega|Fly|Ride"] = 24923.92}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 108.94, ["Fly"] = 166.28, ["Ride"] = 135.03, ["Fly|Ride"] = 161.32, ["Neon"] = 472.5, ["Neon|Fly"] = 459.38, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 593.25, ["Mega|Fly|Ride"] = 2673.72}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 27.24, ["Ride"] = 19.7, ["Fly|Ride"] = 43.99, ["Neon"] = 16.78, ["Neon|Fly"] = 65.61, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 140.3, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 363.27, ["Mega|Fly|Ride"] = 227.07}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 2.62, ["Ride"] = 24.56, ["Fly|Ride"] = 57.71, ["Neon"] = 15.74, ["Neon|Fly"] = 116.37, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 151.11, ["Mega|Ride"] = 203.11, ["Mega|Fly|Ride"] = 324.19}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 26.25, ["Fly"] = 83.76, ["Ride"] = 39.37, ["Fly|Ride"] = 56.34, ["Neon|Fly|Ride"] = 301.88, ["Mega|Fly|Ride"] = 1116.07}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 918.75, ["Ride"] = 985.13, ["Fly|Ride"] = 1298.07}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6693.75, ["Ride"] = 7114.55, ["Fly|Ride"] = 6431.25}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 20.46, ["Fly"] = 36.01, ["Ride"] = 25.08, ["Fly|Ride"] = 39.37, ["Neon"] = 452.12, ["Neon|Ride"] = 131.15, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 2520, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 11.81, ["Fly"] = 70.16, ["Ride"] = 25.99, ["Fly|Ride"] = 74.55, ["Neon"] = 85.31, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 107.63, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 662.17, ["Mega|Ride"] = 544.39, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 59.06, ["Fly"] = 157.49, ["Ride"] = 72.18, ["Fly|Ride"] = 115.5, ["Neon|Ride"] = 452.81, ["Neon|Fly|Ride"] = 454.02, ["Mega|Fly|Ride"] = 1735.57}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 258.57, ["Ride"] = 229.69, ["Fly|Ride"] = 335.02, ["Neon|Ride"] = 977.8, ["Neon|Fly|Ride"] = 977.73, ["Mega|Fly|Ride"] = 4591.27}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 2.6, ["Ride"] = 32.78, ["Fly|Ride"] = 93.19, ["Neon"] = 19.83, ["Neon|Fly"] = 70.16, ["Neon|Ride"] = 62.83, ["Mega"] = 149.09, ["Mega|Fly"] = 226.4, ["Mega|Ride"] = 191.02, ["Mega|Fly|Ride"] = 284.76}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 183.75, ["Fly"] = 237.66, ["Ride"] = 208.69, ["Fly|Ride"] = 288.74, ["Neon"] = 909.57, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 838.69, ["Mega"] = 3209.73, ["Mega|Fly|Ride"] = 3473.53}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.94, ["Fly"] = 41.89, ["Ride"] = 14.85, ["Fly|Ride"] = 35.61, ["Neon"] = 18.8, ["Neon|Fly"] = 125.64, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 223.13, ["Mega|Ride"] = 182.17, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 223.13, ["Fly"] = 279.54, ["Ride"] = 210, ["Fly|Ride"] = 231.55, ["Neon|Fly|Ride"] = 870.58, ["Mega"] = 10468.73, ["Mega|Ride"] = 4710.93, ["Mega|Fly|Ride"] = 4882.62}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 10.26, ["Fly"] = 74.37, ["Ride"] = 28.25, ["Fly|Ride"] = 68.25, ["Neon"] = 73.5, ["Neon|Fly"] = 301.59, ["Neon|Ride"] = 154.95, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 487.86, ["Mega|Ride"] = 530.78, ["Mega|Fly|Ride"] = 488.91}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Ride"] = 23.77, ["Neon"] = 28.88, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 27.24, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 70.06, ["Mega|Ride"] = 115.02, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.56, ["Mega"] = 18.19, ["Mega|Ride"] = 140.12, ["Mega|Fly|Ride"] = 314.08}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 31.25, ["Fly|Ride"] = 107.84, ["Neon"] = 10.48, ["Neon|Ride"] = 43.43, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 70.44, ["Mega|Fly"] = 158305.98, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 76.12, ["Fly"] = 149.97, ["Ride"] = 105.44, ["Fly|Ride"] = 128.63, ["Neon"] = 249.27, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 364.88, ["Mega|Fly|Ride"] = 1196.6}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 34.46, ["Ride"] = 15.73, ["Fly|Ride"] = 110.98, ["Neon"] = 9.15, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 95.01, ["Mega|Ride"] = 154.95, ["Mega|Fly|Ride"] = 261.44}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 11.15, ["Neon"] = 78.61, ["Neon|Ride"] = 259.88, ["Mega|Ride"] = 319.45, ["Mega|Fly|Ride"] = 475.3}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 52.24, ["Neon|Fly|Ride"] = 279.54, ["Mega"] = 15.38, ["Mega|Ride"] = 55.84, ["Mega|Fly|Ride"] = 321.57}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 1.92, ["Fly"] = 61.74, ["Ride"] = 15.73, ["Fly|Ride"] = 41.89, ["Neon"] = 2.1, ["Neon|Fly"] = 18.38, ["Neon|Ride"] = 13.89, ["Neon|Fly|Ride"] = 38.01, ["Mega"] = 12.75, ["Mega|Fly"] = 42, ["Mega|Ride"] = 19.05, ["Mega|Fly|Ride"] = 64.32}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 1.79, ["Fly"] = 17.83, ["Ride"] = 12.67, ["Fly|Ride"] = 62.84, ["Neon"] = 3.33, ["Neon|Fly"] = 39.29, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 39.25, ["Mega"] = 140.3, ["Mega|Fly"] = 159.11, ["Mega|Ride"] = 39.8, ["Mega|Fly|Ride"] = 77.87}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 1.79, ["Neon"] = 3.52, ["Neon|Ride"] = 65.55, ["Mega"] = 26.25, ["Mega|Ride"] = 121.45, ["Mega|Fly|Ride"] = 418.76}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 91.85, ["Ride"] = 21, ["Fly|Ride"] = 107.62, ["Neon"] = 3.67, ["Neon|Fly"] = 167.97, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 79.75, ["Mega"] = 24.09, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 42.87, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly|Ride"] = 418.76, ["Mega"] = 14.52, ["Mega|Fly"] = 95.01, ["Mega|Ride"] = 791.94}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.38, ["Fly"] = 77.44, ["Ride"] = 32.78, ["Fly|Ride"] = 70.16, ["Neon"] = 12.37, ["Neon|Fly"] = 69.28, ["Neon|Ride"] = 32.8, ["Neon|Fly|Ride"] = 119.17, ["Mega"] = 110.25, ["Mega|Fly"] = 98.44, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 196.75}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 1.79, ["Ride"] = 50.94, ["Neon"] = 2.1, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 11.82, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 61.13, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Ride"] = 141.35, ["Fly|Ride"] = 525, ["Neon"] = 16.64, ["Mega"] = 141.91, ["Mega|Fly"] = 315, ["Mega|Ride"] = 279.54, ["Mega|Fly|Ride"] = 542.3}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Neon"] = 16.7, ["Mega"] = 78.75, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 559.05}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 32.79, ["Neon"] = 3.77, ["Neon|Ride"] = 27.24, ["Neon|Fly|Ride"] = 140.3, ["Mega"] = 19.24, ["Mega|Ride"] = 59.38, ["Mega|Fly|Ride"] = 131.15}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 12.5, ["Fly|Ride"] = 40.69, ["Neon"] = 2.1, ["Neon|Fly"] = 35.32, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 32.24, ["Mega"] = 14.44, ["Mega|Fly"] = 36.75, ["Mega|Ride"] = 21.29, ["Mega|Fly|Ride"] = 50.06}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 1.79}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 229.69, ["Fly|Ride"] = 118.11, ["Neon"] = 37.4, ["Neon|Ride"] = 140.94, ["Neon|Fly|Ride"] = 209.39, ["Mega"] = 167.51, ["Mega|Ride"] = 240.19}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 26.46, ["Neon"] = 2.63, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 105, ["Mega"] = 22.32, ["Mega|Ride"] = 45.85, ["Mega|Fly|Ride"] = 171.7}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.35, ["Neon"] = 14.18, ["Neon|Fly|Ride"] = 140.3, ["Mega"] = 94.4, ["Mega|Ride"] = 167.51, ["Mega|Fly|Ride"] = 238.88}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 1.81, ["Fly"] = 65.63, ["Ride"] = 34.53, ["Fly|Ride"] = 28.88, ["Neon"] = 21.86, ["Neon|Ride"] = 49.22, ["Neon|Fly|Ride"] = 140.3, ["Mega"] = 124.69, ["Mega|Ride"] = 143.06, ["Mega|Fly|Ride"] = 193.41}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 12.5, ["Ride"] = 11.12, ["Fly|Ride"] = 26.58, ["Neon"] = 2.1, ["Neon|Fly"] = 15.62, ["Neon|Ride"] = 11.71, ["Neon|Fly|Ride"] = 28.28, ["Mega"] = 14.9, ["Mega|Fly"] = 26.04, ["Mega|Ride"] = 15.22, ["Mega|Fly|Ride"] = 51.61}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.23, ["Fly"] = 28.28, ["Ride"] = 27.4, ["Fly|Ride"] = 131.25, ["Neon"] = 11.8, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 129.54, ["Mega|Ride"] = 159.11, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 3.12, ["Fly"] = 112.03, ["Ride"] = 23.41, ["Fly|Ride"] = 59.06, ["Neon"] = 44.07, ["Neon|Ride"] = 28.62, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 234.94, ["Mega|Ride"] = 291.38, ["Mega|Fly|Ride"] = 311.73}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 16.77, ["Ride"] = 13.01, ["Fly|Ride"] = 43.19, ["Neon"] = 2.5, ["Neon|Fly"] = 18.86, ["Neon|Ride"] = 14.79, ["Neon|Fly|Ride"] = 35.56, ["Mega"] = 21, ["Mega|Ride"] = 19.69, ["Mega|Fly|Ride"] = 103.69}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 174.84, ["Ride"] = 29.32, ["Neon"] = 5.29, ["Neon|Ride"] = 28.28, ["Neon|Fly|Ride"] = 140.3, ["Mega"] = 63.92, ["Mega|Fly"] = 167.51, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 35.43, ["Fly|Ride"] = 65.63, ["Neon"] = 4.93, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 32.47, ["Neon|Fly|Ride"] = 140.3, ["Mega"] = 34.71, ["Mega|Fly"] = 140.3, ["Mega|Ride"] = 140.3, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 1.79, ["Fly"] = 35.61, ["Ride"] = 18.38, ["Neon"] = 2.1, ["Neon|Fly"] = 41.89, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 359.4, ["Mega"] = 13.12, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 167.51}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 70.16, ["Ride"] = 23.63, ["Fly|Ride"] = 41.89, ["Neon"] = 5.15, ["Neon|Fly"] = 28.28, ["Neon|Ride"] = 19.07, ["Neon|Fly|Ride"] = 57.66, ["Mega"] = 137.61, ["Mega|Ride"] = 95.01, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 1.79, ["Ride"] = 54.91, ["Fly|Ride"] = 45.94, ["Neon"] = 6.08, ["Neon|Ride"] = 62.07, ["Mega"] = 40.58, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 249.26}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 23.05, ["Ride"] = 15.21, ["Fly|Ride"] = 72.19, ["Neon"] = 3.93, ["Neon|Fly"] = 79.97, ["Neon|Ride"] = 25.14, ["Neon|Fly|Ride"] = 84, ["Mega"] = 98.44, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 142.94}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.1, ["Ride"] = 36.27, ["Fly|Ride"] = 50.05, ["Neon"] = 41.57, ["Neon|Fly"] = 244.99, ["Neon|Ride"] = 75.39, ["Neon|Fly|Ride"] = 327.3, ["Mega"] = 98.44, ["Mega|Ride"] = 168.38}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 25.77, ["Ride"] = 18.29, ["Fly|Ride"] = 35.61, ["Neon"] = 12.77, ["Neon|Fly"] = 56.55, ["Neon|Ride"] = 28.28, ["Neon|Fly|Ride"] = 140.3, ["Mega"] = 279.54, ["Mega|Fly"] = 420, ["Mega|Ride"] = 151.34}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 22.52, ["Ride"] = 19.64, ["Fly|Ride"] = 52.49, ["Neon"] = 13.13, ["Neon|Fly"] = 31.49, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 72.17, ["Mega"] = 167.51, ["Mega|Ride"] = 418.76, ["Mega|Fly|Ride"] = 224.05}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 7.88, ["Fly"] = 110.98, ["Neon"] = 71.31, ["Mega"] = 236.23, ["Mega|Ride"] = 236.24}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 7.92, ["Ride"] = 56.44, ["Neon"] = 209.51, ["Neon|Ride"] = 237.46, ["Mega"] = 559.05, ["Mega|Ride"] = 698.29, ["Mega|Fly|Ride"] = 794.59}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 3.64, ["Ride"] = 28.06, ["Fly|Ride"] = 104.7, ["Neon"] = 41.89, ["Neon|Ride"] = 126, ["Mega"] = 236.15, ["Mega|Ride"] = 365.53}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 12.98, ["Ride"] = 30.96, ["Fly|Ride"] = 120.75, ["Neon"] = 51.35, ["Neon|Ride"] = 66.64, ["Mega"] = 474.93, ["Mega|Ride"] = 314.08, ["Mega|Fly|Ride"] = 361.6}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.11, ["Neon|Ride"] = 64.99, ["Mega"] = 19.85, ["Mega|Fly"] = 62.83, ["Mega|Ride"] = 125.64, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 36.75}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 2.44, ["Fly"] = 23.26, ["Ride"] = 20.61, ["Fly|Ride"] = 41.15, ["Neon"] = 53.46, ["Neon|Fly"] = 188.48, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 78.62, ["Mega"] = 271.44, ["Mega|Ride"] = 208.69, ["Mega|Fly|Ride"] = 286.93}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 13.01, ["Fly|Ride"] = 44.63, ["Neon"] = 3.66, ["Neon|Fly"] = 32.07, ["Neon|Ride"] = 26.41, ["Neon|Fly|Ride"] = 156.74, ["Mega"] = 24.68, ["Mega|Fly"] = 140.3, ["Mega|Ride"] = 70.16, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 48.18, ["Neon"] = 3.94, ["Neon|Ride"] = 33.11, ["Neon|Fly|Ride"] = 95.28, ["Mega"] = 38.3, ["Mega|Ride"] = 73.78, ["Mega|Fly|Ride"] = 133.87}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 49.22, ["Ride"] = 16.28, ["Fly|Ride"] = 55.65, ["Neon"] = 6.56, ["Neon|Ride"] = 19.91, ["Neon|Fly|Ride"] = 127.05, ["Mega"] = 125.64, ["Mega|Ride"] = 159.11, ["Mega|Fly|Ride"] = 171.95}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 15.59, ["Ride"] = 36.66, ["Fly|Ride"] = 57.75, ["Neon"] = 33.65, ["Neon|Ride"] = 131.06, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 124.69, ["Mega|Ride"] = 279.54, ["Mega|Fly|Ride"] = 313.03}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 31.82, ["Neon"] = 2.2, ["Mega"] = 21, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 59.08, ["Mega|Fly|Ride"] = 335.02}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 21.89, ["Ride"] = 16.49, ["Fly|Ride"] = 32.71, ["Neon"] = 2.67, ["Neon|Fly"] = 110.98, ["Neon|Ride"] = 20.99, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 28.5, ["Mega|Fly"] = 143.16, ["Mega|Ride"] = 38.69, ["Mega|Fly|Ride"] = 129.83}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.11, ["Ride"] = 15.75, ["Fly|Ride"] = 41.89, ["Neon"] = 4.86, ["Neon|Fly"] = 91.44, ["Neon|Ride"] = 18.15, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 56.55, ["Mega|Fly"] = 140.3, ["Mega|Ride"] = 70.2, ["Mega|Fly|Ride"] = 99.75}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 28.28, ["Ride"] = 52.9, ["Fly|Ride"] = 131.25, ["Neon"] = 3.6, ["Neon|Ride"] = 28.17, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 32.36, ["Mega|Ride"] = 80.84, ["Mega|Fly|Ride"] = 215.25}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 21, ["Neon|Ride"] = 31.42, ["Neon|Fly|Ride"] = 152921.64, ["Mega"] = 23.77, ["Mega|Fly"] = 106.45, ["Mega|Ride"] = 83.76, ["Mega|Fly|Ride"] = 159.11}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.88, ["Ride"] = 16.97, ["Fly|Ride"] = 79.58, ["Neon"] = 2.1, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 19.2, ["Mega|Fly"] = 62.83, ["Mega|Ride"] = 41.41, ["Mega|Fly|Ride"] = 98.46}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Mega"] = 32.07, ["Mega|Ride"] = 418.76, ["Mega|Fly|Ride"] = 161.24}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 1.99, ["Neon"] = 2.62, ["Neon|Ride"] = 317.03, ["Neon|Fly|Ride"] = 420, ["Mega"] = 24.82, ["Mega|Ride"] = 153.62}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 14.32, ["Fly|Ride"] = 49.87, ["Neon"] = 3.9, ["Neon|Fly"] = 32.81, ["Neon|Ride"] = 17.03, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 125.64, ["Mega|Ride"] = 49.86, ["Mega|Fly|Ride"] = 94.5}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 11.58, ["Ride"] = 77.96, ["Neon"] = 125.98, ["Mega"] = 454.77, ["Mega|Ride"] = 664.77}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 56.44, ["Neon"] = 42, ["Mega"] = 190.7}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 30.35, ["Fly|Ride"] = 177.98, ["Neon"] = 25.99, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 418.76, ["Mega"] = 397.95, ["Mega|Ride"] = 358.04, ["Mega|Fly|Ride"] = 375.27}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 13.12, ["Ride"] = 15.65, ["Fly|Ride"] = 25.3, ["Neon"] = 2.1, ["Neon|Fly"] = 15.64, ["Neon|Ride"] = 10.49, ["Neon|Fly|Ride"] = 26.44, ["Mega"] = 12.98, ["Mega|Fly"] = 22.8, ["Mega|Ride"] = 20.84, ["Mega|Fly|Ride"] = 40.57}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 60.38, ["Neon"] = 5.25, ["Neon|Fly"] = 67.02, ["Neon|Ride"] = 32.47, ["Neon|Fly|Ride"] = 698.29, ["Mega"] = 72.19, ["Mega|Ride"] = 118.02}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.2, ["Neon"] = 2.1, ["Neon|Fly"] = 31.42, ["Neon|Ride"] = 22.83, ["Neon|Fly|Ride"] = 84.16, ["Mega"] = 14.39, ["Mega|Fly"] = 89.25, ["Mega|Ride"] = 69.56, ["Mega|Fly|Ride"] = 125.64}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 60.89, ["Neon|Ride"] = 127.32, ["Mega"] = 18.25, ["Mega|Fly|Ride"] = 167.51}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 41.97, ["Ride"] = 17.31, ["Fly|Ride"] = 32.82, ["Neon"] = 11.18, ["Neon|Ride"] = 32.04, ["Neon|Fly|Ride"] = 76.13, ["Mega"] = 183.75, ["Mega|Ride"] = 197.91, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 164.05, ["Fly"] = 183.75, ["Ride"] = 211.21, ["Fly|Ride"] = 837.51, ["Neon|Fly|Ride"] = 940.11, ["Mega"] = 8374.98, ["Mega|Ride"] = 3210.77, ["Mega|Fly|Ride"] = 3315.45}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 17.83, ["Neon"] = 7.88, ["Neon|Ride"] = 64.32, ["Mega"] = 78.05, ["Mega|Ride"] = 167.51, ["Mega|Fly|Ride"] = 622.9}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.2, ["Fly"] = 64.97, ["Ride"] = 26.14, ["Fly|Ride"] = 59.07, ["Neon"] = 24.94, ["Neon|Ride"] = 95.01, ["Neon|Fly|Ride"] = 167.51, ["Mega"] = 381.82, ["Mega|Ride"] = 418.76, ["Mega|Fly|Ride"] = 417.72}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 15.11, ["Ride"] = 13.81, ["Fly|Ride"] = 37.97, ["Neon"] = 3.94, ["Neon|Fly"] = 23.77, ["Neon|Ride"] = 29.46, ["Neon|Fly|Ride"] = 40.39, ["Mega"] = 49.68, ["Mega|Ride"] = 81.38, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 70.16, ["Ride"] = 17.76, ["Fly|Ride"] = 92.57, ["Neon"] = 6.86, ["Neon|Fly"] = 559.05, ["Neon|Ride"] = 69.47, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 69.57, ["Mega|Ride"] = 189.98}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 2.1, ["Fly"] = 23.73, ["Ride"] = 15.01, ["Fly|Ride"] = 36.06, ["Neon"] = 28.62, ["Neon|Fly"] = 98.42, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 77.95, ["Mega|Ride"] = 279.54, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 5.02, ["Ride"] = 34.32, ["Fly|Ride"] = 251.27, ["Neon"] = 79.24, ["Neon|Ride"] = 140.3, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 262.49, ["Mega|Ride"] = 406.26, ["Mega|Fly|Ride"] = 387.18}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 15.27, ["Fly|Ride"] = 35.25, ["Neon"] = 20.37, ["Neon|Fly"] = 76.13, ["Neon|Ride"] = 28.8, ["Neon|Fly|Ride"] = 70.49, ["Mega"] = 131.25, ["Mega|Ride"] = 209.39, ["Mega|Fly|Ride"] = 216.56}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 66.94, ["Ride"] = 72.19, ["Fly|Ride"] = 131.23, ["Neon"] = 328.13, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1465.63}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 223.12, ["Fly"] = 335.02, ["Ride"] = 236.67, ["Fly|Ride"] = 280.72, ["Neon|Ride"] = 1117.04, ["Neon|Fly|Ride"] = 906.46, ["Mega"] = 10468.73, ["Mega|Fly|Ride"] = 4840.75}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 55.55, ["Fly"] = 140.3, ["Ride"] = 70.75, ["Fly|Ride"] = 99.2, ["Neon"] = 262.5, ["Neon|Ride"] = 290.34, ["Neon|Fly|Ride"] = 354.26, ["Mega|Fly|Ride"] = 1746.2}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 6.44, ["Fly"] = 287.88, ["Ride"] = 23.63, ["Fly|Ride"] = 139.07, ["Neon"] = 28.28, ["Neon|Fly"] = 83.76, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 179.81, ["Mega"] = 263.82, ["Mega|Ride"] = 376.89, ["Mega|Fly|Ride"] = 414.1}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 6.64, ["Fly"] = 70.16, ["Ride"] = 20.35, ["Fly|Ride"] = 62.76, ["Neon"] = 81.38, ["Neon|Ride"] = 126.27, ["Neon|Fly|Ride"] = 195.78, ["Mega"] = 352.8, ["Mega|Ride"] = 390.75, ["Mega|Fly|Ride"] = 1256.26}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 20.97, ["Ride"] = 12.62, ["Fly|Ride"] = 44.5, ["Neon"] = 2.1, ["Neon|Fly"] = 31.42, ["Neon|Ride"] = 19.91, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 49.89, ["Mega|Ride"] = 129.83, ["Mega|Fly|Ride"] = 84.46}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.7, ["Fly"] = 72.12, ["Ride"] = 21.41, ["Fly|Ride"] = 81.38, ["Neon"] = 125.82, ["Neon|Fly"] = 349.67, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 173.38, ["Mega"] = 393.75, ["Mega|Ride"] = 833.33, ["Mega|Fly|Ride"] = 732.38}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 21.12, ["Ride"] = 13.13, ["Fly|Ride"] = 32.81, ["Neon"] = 11.82, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 31.43, ["Neon|Fly|Ride"] = 104.68, ["Mega"] = 149.63, ["Mega|Fly"] = 65.63, ["Mega|Ride"] = 219.86, ["Mega|Fly|Ride"] = 178.37}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.1, ["Ride"] = 21.18, ["Fly|Ride"] = 328.13, ["Neon"] = 22.28, ["Neon|Ride"] = 35.61, ["Mega"] = 207.37, ["Mega|Ride"] = 279.54, ["Mega|Fly|Ride"] = 474.93}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 33.52, ["Ride"] = 19.35, ["Neon"] = 2.1, ["Neon|Ride"] = 19.65, ["Neon|Fly|Ride"] = 57.74, ["Mega"] = 14.44, ["Mega|Ride"] = 41.89, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.09, ["Ride"] = 18.27, ["Fly|Ride"] = 41.89, ["Neon"] = 13.58, ["Neon|Fly"] = 104.7, ["Neon|Ride"] = 31.42, ["Neon|Fly|Ride"] = 147, ["Mega"] = 108.93, ["Mega|Ride"] = 194.73, ["Mega|Fly|Ride"] = 209.37}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.63, ["Fly"] = 25.17, ["Ride"] = 18.41, ["Fly|Ride"] = 61.53, ["Neon"] = 21.42, ["Neon|Ride"] = 47.25, ["Mega"] = 131.17, ["Mega|Ride"] = 203.11, ["Mega|Fly|Ride"] = 224.05}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 118.13, ["Fly"] = 131.25, ["Ride"] = 140.81, ["Fly|Ride"] = 214.04, ["Neon"] = 676.3, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 632.62, ["Mega"] = 4187.5, ["Mega|Ride"] = 2721.89, ["Mega|Fly|Ride"] = 2035.68}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 28.16, ["Ride"] = 32.47, ["Fly|Ride"] = 127.05, ["Neon"] = 45.96, ["Neon|Ride"] = 98.43, ["Neon|Fly|Ride"] = 279.54, ["Mega"] = 328.13, ["Mega|Ride"] = 397.83, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 20.95, ["Ride"] = 15.59, ["Fly|Ride"] = 35.61, ["Neon"] = 19.69, ["Neon|Ride"] = 28.28, ["Neon|Fly|Ride"] = 120.74, ["Mega"] = 237.47, ["Mega|Ride"] = 187.69, ["Mega|Fly|Ride"] = 317.03}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 22.92, ["Ride"] = 41.32, ["Fly|Ride"] = 170.63, ["Neon"] = 118.01, ["Neon|Ride"] = 203.11, ["Neon|Fly|Ride"] = 614.98, ["Mega"] = 660.77, ["Mega|Fly"] = 837.51, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 617.67}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 5.04}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.1, ["Ride"] = 28.5, ["Fly|Ride"] = 117.41, ["Neon"] = 41.89, ["Neon|Ride"] = 102.61, ["Neon|Fly|Ride"] = 349.67, ["Mega"] = 629.9, ["Mega|Ride"] = 572.65, ["Mega|Fly|Ride"] = 871.48}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 25.58, ["Fly"] = 26.25, ["Ride"] = 31.36, ["Fly|Ride"] = 49.23, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 162.63, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 2093.76, ["Mega|Fly|Ride"] = 541.75}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 18.68, ["Fly|Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Fly"] = 65.62, ["Neon|Ride"] = 25.49, ["Neon|Fly|Ride"] = 106.3, ["Mega"] = 28.52, ["Mega|Ride"] = 57.66, ["Mega|Fly|Ride"] = 228.79}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 15.21, ["Fly"] = 28.28, ["Ride"] = 24.1, ["Fly|Ride"] = 62.83, ["Neon"] = 10.54, ["Neon|Ride"] = 237.46, ["Mega"] = 279.55, ["Mega|Fly"] = 396.57, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 381.07}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 13.02, ["Fly|Ride"] = 47.08, ["Neon"] = 17.34, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 35.11, ["Neon|Fly|Ride"] = 77.43, ["Mega"] = 138.89, ["Mega|Ride"] = 182.43, ["Mega|Fly|Ride"] = 271.69}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 26.17, ["Fly|Ride"] = 209.39, ["Neon"] = 3.15, ["Neon|Fly"] = 37.49, ["Neon|Ride"] = 25.97, ["Neon|Fly|Ride"] = 209.39, ["Mega"] = 23.96, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 24.21, ["Ride"] = 74.45, ["Fly|Ride"] = 142.48, ["Neon"] = 236.25, ["Neon|Ride"] = 242.82, ["Neon|Fly|Ride"] = 576.19, ["Mega"] = 808.07, ["Mega|Ride"] = 904.23, ["Mega|Fly|Ride"] = 1115.98}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.35, ["Ride"] = 28.28, ["Fly|Ride"] = 210, ["Neon"] = 92.26, ["Neon|Ride"] = 140.3, ["Mega"] = 140.3, ["Mega|Ride"] = 342.67}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 3.69, ["Fly"] = 29.54, ["Ride"] = 15.82, ["Fly|Ride"] = 52.36, ["Neon"] = 18.72, ["Neon|Fly"] = 315, ["Neon|Ride"] = 32.8, ["Neon|Fly|Ride"] = 159.11, ["Mega"] = 193.55, ["Mega|Ride"] = 303.96, ["Mega|Fly|Ride"] = 418.76}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 61.05, ["Fly"] = 433.13, ["Ride"] = 393.73, ["Fly|Ride"] = 262.47, ["Neon"] = 354.38, ["Neon|Ride"] = 544.39, ["Mega"] = 4434.54, ["Mega|Ride"] = 2165.63, ["Mega|Fly|Ride"] = 1836.19}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 8.1, ["Fly"] = 32.82, ["Ride"] = 23.84, ["Fly|Ride"] = 57.64, ["Neon"] = 56.55, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 114.18, ["Mega"] = 224.42, ["Mega|Ride"] = 284.82, ["Mega|Fly|Ride"] = 695.15}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 59.07, ["Fly"] = 140.3, ["Ride"] = 87.72, ["Fly|Ride"] = 150.93, ["Neon"] = 266.44, ["Neon|Ride"] = 230.15, ["Neon|Fly|Ride"] = 315, ["Mega"] = 1256.26, ["Mega|Ride"] = 901.78, ["Mega|Fly|Ride"] = 1091.27}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 15.49, ["Ride"] = 43.32, ["Fly|Ride"] = 140.3, ["Neon"] = 72.18, ["Neon|Ride"] = 103.95, ["Neon|Fly|Ride"] = 235.1, ["Mega"] = 354.38, ["Mega|Ride"] = 355.49, ["Mega|Fly|Ride"] = 413.44}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 5.25, ["Fly"] = 40.94, ["Ride"] = 28.28, ["Fly|Ride"] = 62.83, ["Neon"] = 49.8, ["Neon|Ride"] = 131.14, ["Neon|Fly|Ride"] = 377.57, ["Mega"] = 209.39, ["Mega|Ride"] = 1570.33, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 14.27, ["Ride"] = 39.35, ["Fly|Ride"] = 162.54, ["Neon"] = 66.99, ["Neon|Ride"] = 140.69, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 299.57, ["Mega|Ride"] = 280.87, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 3.59, ["Ride"] = 24.81, ["Fly|Ride"] = 90.17, ["Neon"] = 31.05, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 141.16, ["Mega"] = 238.88, ["Mega|Ride"] = 265.21, ["Mega|Fly|Ride"] = 402.26}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 56.55, ["Mega"] = 26.25, ["Mega|Ride"] = 125.64, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 2.1, ["Ride"] = 28.42, ["Neon"] = 23.79, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 157.5, ["Mega|Ride"] = 279.54, ["Mega|Fly|Ride"] = 416.67}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 124.59, ["Neon"] = 28.74, ["Neon|Fly"] = 116.94, ["Mega"] = 170.55, ["Mega|Ride"] = 138.21, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 5.14, ["Ride"] = 32.79, ["Fly|Ride"] = 118.74, ["Neon"] = 23.77, ["Neon|Ride"] = 78.53, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 123.38, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 524.98, ["Ride"] = 570.93, ["Fly|Ride"] = 616.77, ["Neon"] = 1815.3, ["Neon|Ride"] = 1845.04, ["Neon|Fly|Ride"] = 1940.91, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 5.25, ["Fly"] = 28.28, ["Ride"] = 20.44, ["Fly|Ride"] = 56.35, ["Neon"] = 40.85, ["Neon|Ride"] = 60.74, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 215.66, ["Mega|Ride"] = 364.52, ["Mega|Fly|Ride"] = 475.3}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 6.22, ["Fly"] = 524.79, ["Ride"] = 31.12, ["Fly|Ride"] = 51.54, ["Neon"] = 48.56, ["Neon|Fly"] = 315, ["Neon|Ride"] = 98.34, ["Neon|Fly|Ride"] = 159.11, ["Mega"] = 331.86, ["Mega|Ride"] = 445.99, ["Mega|Fly|Ride"] = 400.32}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 4.2, ["Fly"] = 91.87, ["Ride"] = 27.09, ["Fly|Ride"] = 314.08, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 70.16}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.59, ["Ride"] = 22.09, ["Fly|Ride"] = 90.57, ["Neon"] = 7.79, ["Neon|Ride"] = 29.8, ["Neon|Fly|Ride"] = 87.8, ["Mega"] = 52.5, ["Mega|Fly"] = 279.54, ["Mega|Ride"] = 88.64, ["Mega|Fly|Ride"] = 203.72}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 70.16, ["Ride"] = 17.07, ["Neon"] = 2.1, ["Neon|Ride"] = 24.05, ["Neon|Fly|Ride"] = 105, ["Mega"] = 20.87, ["Mega|Fly"] = 195.78, ["Mega|Ride"] = 65.54, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1109.06}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 6.57, ["Ride"] = 140.3, ["Fly|Ride"] = 326.64, ["Neon"] = 65.63, ["Neon|Ride"] = 91.75, ["Mega"] = 459.38, ["Mega|Ride"] = 569.91, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 26.38, ["Neon"] = 5.16, ["Neon|Ride"] = 56.44, ["Mega"] = 39.38, ["Mega|Ride"] = 102.61, ["Mega|Fly|Ride"] = 251.34}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 389.71, ["Ride"] = 65.63, ["Neon"] = 22.97, ["Neon|Ride"] = 70.16, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 183.75, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 1046.89}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 419.99, ["Ride"] = 485.63, ["Fly|Ride"] = 542.9, ["Neon|Ride"] = 2092.67, ["Neon|Fly|Ride"] = 2092.01, ["Mega"] = 8707.59, ["Mega|Fly|Ride"] = 6298.69}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 3.55, ["Fly"] = 196.88, ["Ride"] = 56.55, ["Fly|Ride"] = 418.76, ["Neon"] = 23.77, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 189.98, ["Mega"] = 522.41, ["Mega|Ride"] = 474.93, ["Mega|Fly|Ride"] = 696.95}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 90.33, ["Ride"] = 23.21, ["Fly|Ride"] = 118.13, ["Neon"] = 2.6, ["Neon|Ride"] = 36.26, ["Neon|Fly|Ride"] = 99.04, ["Mega"] = 37.07, ["Mega|Fly"] = 125.64, ["Mega|Ride"] = 71.67, ["Mega|Fly|Ride"] = 277.85}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 2.2, ["Neon|Ride"] = 126.04, ["Neon|Fly|Ride"] = 279.54, ["Mega"] = 26.25, ["Mega|Ride"] = 134.78, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 10.48, ["Fly"] = 107.63, ["Ride"] = 80.06, ["Neon"] = 127.74, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 543.34, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 544.69}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 8.18, ["Neon"] = 80.22, ["Neon|Ride"] = 159.11, ["Neon|Fly|Ride"] = 535.48, ["Mega"] = 496.13, ["Mega|Ride"] = 478.42, ["Mega|Fly|Ride"] = 488.91}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 6.3, ["Ride"] = 31.38, ["Neon"] = 96.94, ["Neon|Ride"] = 178.34, ["Mega"] = 649.46, ["Mega|Ride"] = 768.42, ["Mega|Fly|Ride"] = 1256.26}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 19.03, ["Ride"] = 23.15, ["Fly|Ride"] = 262.5, ["Neon"] = 167.37, ["Neon|Ride"] = 182.44, ["Neon|Fly|Ride"] = 209.39, ["Mega"] = 616.88, ["Mega|Ride"] = 477.06, ["Mega|Fly|Ride"] = 698.29}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 347.08, ["Ride"] = 328.13, ["Fly|Ride"] = 508.17, ["Neon"] = 1115.63, ["Neon|Ride"] = 1396.55, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4013.05}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 3.56, ["Fly"] = 78.74, ["Ride"] = 20.11, ["Fly|Ride"] = 70.16, ["Neon"] = 145.69, ["Neon|Ride"] = 159.11, ["Neon|Fly|Ride"] = 195.82, ["Mega"] = 753.77, ["Mega|Ride"] = 731.78, ["Mega|Fly|Ride"] = 723.4}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 2.58, ["Ride"] = 42.68, ["Fly|Ride"] = 127.32, ["Neon"] = 63.67, ["Neon|Ride"] = 210, ["Mega"] = 367.5, ["Mega|Ride"] = 349.67, ["Mega|Fly|Ride"] = 791.94}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 15.72, ["Fly"] = 140.3, ["Ride"] = 96.04, ["Fly|Ride"] = 159.14, ["Neon"] = 79.11, ["Neon|Ride"] = 150.99, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 275.63, ["Mega|Fly"] = 698.29, ["Mega|Ride"] = 313.69, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.6, ["Ride"] = 41.89, ["Fly|Ride"] = 140.3, ["Neon"] = 6.48, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 209.39, ["Mega"] = 45.85, ["Mega|Ride"] = 125.63, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 37.28, ["Ride"] = 77.17, ["Neon"] = 315, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 461.69, ["Mega"] = 1662.22, ["Mega|Ride"] = 2772.13, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 521, ["Ride"] = 26.25, ["Neon"] = 9.18, ["Neon|Fly"] = 182.17, ["Neon|Ride"] = 77.48, ["Neon|Fly|Ride"] = 125.56, ["Mega"] = 70.88, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 320.92}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 26.22, ["Ride"] = 27.34, ["Neon"] = 4.67, ["Neon|Fly"] = 49.38, ["Neon|Ride"] = 46.66, ["Neon|Fly|Ride"] = 140.3, ["Mega"] = 41.99, ["Mega|Fly"] = 59.07, ["Mega|Ride"] = 76, ["Mega|Fly|Ride"] = 170.36}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 37.97, ["Fly|Ride"] = 125.87, ["Neon"] = 9.19, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 87.94, ["Mega|Fly"] = 459.38, ["Mega|Ride"] = 130.81, ["Mega|Fly|Ride"] = 308.84}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 50.9, ["Fly"] = 77.48, ["Ride"] = 60.26, ["Fly|Ride"] = 169.32, ["Neon"] = 271.01, ["Neon|Ride"] = 303.41, ["Neon|Fly|Ride"] = 475.04, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 271.85, ["Ride"] = 301.85, ["Fly|Ride"] = 417.72, ["Neon"] = 1455.17, ["Neon|Ride"] = 1156.42, ["Neon|Fly|Ride"] = 1306.03, ["Mega"] = 6562.5, ["Mega|Fly|Ride"] = 4467.01}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 3.8, ["Neon"] = 27.57, ["Neon|Fly"] = 350.44, ["Mega"] = 108.93, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 212.69}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 25.14, ["Neon"] = 6.33, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 140.3, ["Mega"] = 61.68, ["Mega|Fly"] = 164.07, ["Mega|Ride"] = 90.45, ["Mega|Fly|Ride"] = 188.99}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.1, ["Fly"] = 30.9, ["Ride"] = 27.57, ["Fly|Ride"] = 47.5, ["Neon"] = 32.8, ["Mega"] = 138.21, ["Mega|Ride"] = 351.74, ["Mega|Fly|Ride"] = 391.54}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 3.93, ["Fly"] = 90.96, ["Ride"] = 35.61, ["Fly|Ride"] = 372.7, ["Neon"] = 11.47, ["Neon|Ride"] = 26.82, ["Neon|Fly|Ride"] = 154.95, ["Mega"] = 124.29, ["Mega|Ride"] = 142.49, ["Mega|Fly|Ride"] = 255.94}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 59.06, ["Neon"] = 7.88, ["Neon|Fly|Ride"] = 191.59, ["Mega"] = 52.5, ["Mega|Ride"] = 141.35, ["Mega|Fly|Ride"] = 346.53}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 28.28, ["Ride"] = 17.91, ["Fly|Ride"] = 51.19, ["Neon"] = 4.11, ["Neon|Fly"] = 79.56, ["Neon|Ride"] = 21.38, ["Neon|Fly|Ride"] = 418.76, ["Mega"] = 39.38, ["Mega|Ride"] = 95.72, ["Mega|Fly|Ride"] = 249.36}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 3.77, ["Fly"] = 26.25, ["Ride"] = 15.89, ["Fly|Ride"] = 41.31, ["Neon"] = 15.75, ["Neon|Fly"] = 64.96, ["Neon|Ride"] = 27.09, ["Neon|Fly|Ride"] = 95.01, ["Mega"] = 156.15, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 23.5, ["Fly"] = 52.5, ["Ride"] = 31.69, ["Fly|Ride"] = 78.74, ["Neon|Ride"] = 265.93, ["Neon|Fly|Ride"] = 279.54, ["Mega"] = 388.5, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 559.05}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 64.82, ["Ride"] = 78.66, ["Fly|Ride"] = 137.73, ["Neon"] = 406.88, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 3166.51, ["Mega|Ride"] = 3254.99, ["Mega|Fly|Ride"] = 1502.82}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 17.87, ["Fly|Ride"] = 140.3, ["Neon"] = 2.7, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 26.2, ["Neon|Fly|Ride"] = 128.47, ["Mega"] = 38.4, ["Mega|Fly"] = 672, ["Mega|Ride"] = 92.8, ["Mega|Fly|Ride"] = 246.75}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 14.12, ["Ride"] = 14.17, ["Fly|Ride"] = 28.27, ["Neon"] = 5.25, ["Neon|Fly"] = 28.28, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 61.68, ["Mega"] = 38.73, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 66.94, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 2.78, ["Ride"] = 73.5, ["Fly|Ride"] = 131.25, ["Neon"] = 36.75, ["Neon|Ride"] = 124.68, ["Neon|Fly|Ride"] = 279.54, ["Mega"] = 527.62, ["Mega|Ride"] = 275.62, ["Mega|Fly|Ride"] = 634.04}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.65, ["Fly"] = 518.44, ["Ride"] = 472.5, ["Fly|Ride"] = 577.5, ["Neon|Ride"] = 1899.64, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 7915.67}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 22.78, ["Fly"] = 98.42, ["Ride"] = 40.68, ["Fly|Ride"] = 84.73, ["Neon"] = 236.25, ["Neon|Ride"] = 210.74, ["Neon|Fly|Ride"] = 305.8, ["Mega|Ride"] = 880.69, ["Mega|Fly|Ride"] = 1899.68}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 20.95, ["Fly|Ride"] = 70.16, ["Neon"] = 7.88, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 84.4, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 259.74}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 65.61, ["Fly|Ride"] = 143.05, ["Neon"] = 17.82}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 24.59, ["Fly"] = 169.3, ["Ride"] = 35.89, ["Fly|Ride"] = 52.5, ["Neon"] = 194.25, ["Neon|Ride"] = 355.95, ["Neon|Fly|Ride"] = 185.07, ["Mega"] = 2512.51, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1203.92}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 77.94, ["Fly"] = 125.64, ["Ride"] = 111.16, ["Fly|Ride"] = 188.45, ["Neon"] = 434.44, ["Neon|Ride"] = 556.96, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 8374.98, ["Mega|Fly|Ride"] = 2273.82}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 195.57, ["Ride"] = 276.07, ["Fly|Ride"] = 504.1, ["Neon"] = 1050, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1035.57, ["Mega|Fly|Ride"] = 4147.5}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 10.54, ["Fly"] = 56.55, ["Ride"] = 35.18, ["Fly|Ride"] = 96.17, ["Neon"] = 84.11, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 349.67, ["Mega"] = 388.5, ["Mega|Ride"] = 404.79, ["Mega|Fly|Ride"] = 514.03}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 19.28, ["Ride"] = 13.8, ["Fly|Ride"] = 41.89, ["Neon"] = 11.7, ["Neon|Ride"] = 22.21, ["Neon|Fly|Ride"] = 91.09, ["Mega"] = 63, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 170.35}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.1, ["Fly"] = 39.19, ["Ride"] = 15.32, ["Fly|Ride"] = 55.97, ["Neon"] = 30.77, ["Neon|Fly"] = 105, ["Neon|Ride"] = 36.05, ["Neon|Fly|Ride"] = 74.59, ["Mega"] = 381.09, ["Mega|Ride"] = 279.54, ["Mega|Fly|Ride"] = 366.19}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 295.32, ["Fly"] = 488.91, ["Ride"] = 391.11, ["Fly|Ride"] = 444.06, ["Neon"] = 1575, ["Neon|Ride"] = 2029.3, ["Neon|Fly|Ride"] = 1675.01, ["Mega"] = 10049.99, ["Mega|Fly|Ride"] = 5443.75}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 32.62, ["Neon"] = 6.38, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 31, ["Mega|Ride"] = 170.99}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.29, ["Ride"] = 15.73, ["Fly|Ride"] = 55.13, ["Neon"] = 26.14, ["Neon|Ride"] = 36.41, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 231.38, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 194.36, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 12.74, ["Ride"] = 71.27, ["Neon"] = 129.94, ["Neon|Fly"] = 418.76, ["Neon|Ride"] = 236.25, ["Mega"] = 590.63, ["Mega|Ride"] = 609, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 102.78, ["Fly"] = 157.5, ["Ride"] = 103.58, ["Fly|Ride"] = 127.03, ["Neon"] = 459.38, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 568.32, ["Mega|Fly|Ride"] = 2379.57}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 10.37, ["Fly"] = 24.57, ["Ride"] = 23.12, ["Fly|Ride"] = 48.88, ["Neon"] = 104.7, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 140.3, ["Mega"] = 698.29, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 518.44}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 20.97, ["Neon"] = 2.1, ["Neon|Ride"] = 140.3, ["Mega"] = 24.93, ["Mega|Ride"] = 279.54, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 19.69, ["Fly|Ride"] = 70.16, ["Neon"] = 2.24, ["Neon|Ride"] = 20.95, ["Neon|Fly|Ride"] = 78.38, ["Mega"] = 27.57, ["Mega|Fly"] = 92.26, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 99.75}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 9.1, ["Ride"] = 52.42, ["Fly|Ride"] = 141.93, ["Neon"] = 30.19, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 206.94, ["Mega"] = 159.11, ["Mega|Ride"] = 204.65, ["Mega|Fly|Ride"] = 308.43}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1168.12, ["Ride"] = 1443.73, ["Fly|Ride"] = 1312.5, ["Neon"] = 4200, ["Neon|Ride"] = 4147.5, ["Neon|Fly|Ride"] = 4123.72, ["Mega|Fly|Ride"] = 12598.69}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 446.24, ["Ride"] = 479.07, ["Fly|Ride"] = 630.1, ["Neon"] = 2458.07, ["Neon|Ride"] = 1837.5, ["Neon|Fly|Ride"] = 2512.51, ["Mega"] = 16749.95, ["Mega|Fly|Ride"] = 7049.65}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 284.82, ["Fly"] = 379.44, ["Ride"] = 324.19, ["Fly|Ride"] = 448.26, ["Neon"] = 656.25, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 786.19, ["Mega|Fly|Ride"] = 2916.24}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 242.97, ["Fly"] = 334.69, ["Ride"] = 308.44, ["Fly|Ride"] = 388.49, ["Neon"] = 777, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 1049.99}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 64.31, ["Ride"] = 15.81, ["Fly|Ride"] = 37.68, ["Neon"] = 3.83, ["Neon|Ride"] = 38.06, ["Neon|Fly|Ride"] = 105, ["Mega"] = 69.42, ["Mega|Fly"] = 103.66, ["Mega|Ride"] = 112.03, ["Mega|Fly|Ride"] = 135.07}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 338.81, ["Fly"] = 1396.55, ["Ride"] = 420, ["Fly|Ride"] = 606.15, ["Neon"] = 1575, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1785, ["Mega"] = 21216.96, ["Mega|Ride"] = 6699.99, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.85, ["Fly"] = 183.75, ["Ride"] = 41.89, ["Fly|Ride"] = 159.11, ["Neon"] = 18.33, ["Neon|Ride"] = 209.67, ["Neon|Fly|Ride"] = 252, ["Mega"] = 137.81, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 497.28}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 18.12, ["Ride"] = 15.12, ["Fly|Ride"] = 31.98, ["Neon"] = 11.82, ["Neon|Ride"] = 40.85, ["Neon|Fly|Ride"] = 140.3, ["Mega"] = 104.9, ["Mega|Ride"] = 192.93, ["Mega|Fly|Ride"] = 150.76}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 56.03, ["Neon"] = 2.49, ["Neon|Ride"] = 39.36, ["Mega"] = 29.65, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 30.95, ["Fly|Ride"] = 459.37, ["Neon"] = 244.28, ["Neon|Ride"] = 351.29, ["Mega"] = 1050, ["Mega|Ride"] = 488.25, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 28.28, ["Ride"] = 25.99, ["Fly|Ride"] = 67.56, ["Neon"] = 34.44, ["Neon|Ride"] = 61.13, ["Mega|Ride"] = 405.15, ["Mega|Fly|Ride"] = 418.76}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 2.1, ["Neon|Ride"] = 41.89, ["Neon|Fly|Ride"] = 100.85, ["Mega"] = 20.79, ["Mega|Ride"] = 68.01, ["Mega|Fly|Ride"] = 161.23}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 36.01, ["Ride"] = 18.34, ["Fly|Ride"] = 64.46, ["Neon"] = 12.68, ["Neon|Fly"] = 112.03, ["Neon|Ride"] = 31.19, ["Neon|Fly|Ride"] = 76.56, ["Mega"] = 129.72, ["Mega|Fly"] = 474.93, ["Mega|Ride"] = 129.93, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 4.08, ["Fly"] = 56.55, ["Ride"] = 15.8, ["Fly|Ride"] = 52.5, ["Neon"] = 35.76, ["Neon|Fly"] = 142.48, ["Neon|Ride"] = 140.3, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 238.82, ["Mega|Ride"] = 251.07, ["Mega|Fly|Ride"] = 1034.25}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 10.13, ["Ride"] = 62.83, ["Neon"] = 115.5, ["Neon|Fly|Ride"] = 269.54, ["Mega"] = 515.3, ["Mega|Ride"] = 413.44, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.6, ["Fly"] = 6334.43, ["Ride"] = 19.69, ["Neon"] = 19.69, ["Neon|Fly"] = 47.25, ["Neon|Ride"] = 183.73, ["Neon|Fly|Ride"] = 712.39, ["Mega"] = 301.88, ["Mega|Ride"] = 413.53, ["Mega|Fly|Ride"] = 402.94}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 64.89, ["Ride"] = 18.38, ["Fly|Ride"] = 37.71, ["Neon"] = 3.94, ["Neon|Fly"] = 31.42, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 83.76, ["Mega"] = 39.29, ["Mega|Ride"] = 179.3, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 156.19, ["Ride"] = 164.07, ["Fly|Ride"] = 254.63, ["Neon|Ride"] = 900.32, ["Neon|Fly|Ride"] = 838.68, ["Mega"] = 8374.98, ["Mega|Ride"] = 4187.5, ["Mega|Fly|Ride"] = 3476.68}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 19.04, ["Ride"] = 14.44, ["Fly|Ride"] = 28.61, ["Neon"] = 2.67, ["Neon|Fly"] = 24.1, ["Neon|Ride"] = 20.89, ["Neon|Fly|Ride"] = 56.26, ["Mega"] = 44.63, ["Mega|Ride"] = 52.76, ["Mega|Fly|Ride"] = 131.24}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 6.46, ["Ride"] = 42.36, ["Fly|Ride"] = 183.75, ["Neon"] = 89.1, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 313.69, ["Mega|Fly"] = 791.94, ["Mega|Ride"] = 439.69, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 23.62, ["Ride"] = 104.7, ["Fly|Ride"] = 170.63, ["Neon"] = 137.8, ["Neon|Ride"] = 270.21, ["Mega"] = 786.19, ["Mega|Ride"] = 684.68, ["Mega|Fly|Ride"] = 837.51}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 171.92, ["Ride"] = 183.65, ["Fly|Ride"] = 316, ["Neon"] = 753.64, ["Neon|Ride"] = 720.57, ["Neon|Fly|Ride"] = 917.44, ["Mega|Fly|Ride"] = 3378.26}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 21.52, ["Fly|Ride"] = 140.3, ["Neon"] = 78.75, ["Mega"] = 287.44, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 698.29}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 7.87, ["Ride"] = 57.75, ["Fly|Ride"] = 182.17, ["Neon"] = 103.95, ["Neon|Fly"] = 159.11, ["Neon|Ride"] = 199, ["Neon|Fly|Ride"] = 222.04, ["Mega"] = 771.89, ["Mega|Ride"] = 837.51, ["Mega|Fly|Ride"] = 977.8}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 957.91, ["Fly"] = 1050, ["Ride"] = 1050, ["Fly|Ride"] = 1179.93, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 4467.01, ["Mega|Fly|Ride"] = 19890.56}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 3.43, ["Fly"] = 19.69, ["Ride"] = 19.8, ["Fly|Ride"] = 43.32, ["Neon"] = 25.14, ["Neon|Fly"] = 41.98, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 78.53, ["Mega"] = 225.6, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 3.94, ["Fly"] = 51.19, ["Ride"] = 35.32, ["Fly|Ride"] = 135.19, ["Neon"] = 35.61, ["Neon|Ride"] = 82.72, ["Mega"] = 237.66, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 278.11}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 82.72, ["Ride"] = 27.23, ["Fly|Ride"] = 69.57, ["Neon"] = 11.82, ["Neon|Ride"] = 44.94, ["Mega"] = 199.66, ["Mega|Ride"] = 240.62, ["Mega|Fly|Ride"] = 969.42}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 12.63, ["Fly"] = 57.84, ["Ride"] = 28.88, ["Fly|Ride"] = 83.83, ["Neon"] = 77.43, ["Neon|Fly"] = 143.83, ["Neon|Ride"] = 79.45, ["Neon|Fly|Ride"] = 196.26, ["Mega"] = 437.07, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 3.94, ["Fly"] = 20.45, ["Ride"] = 22.32, ["Fly|Ride"] = 51.19, ["Neon"] = 16.36, ["Neon|Fly"] = 42.73, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 98.57, ["Mega|Fly"] = 251.27, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 16.95, ["Neon"] = 10.11, ["Neon|Fly"] = 13125, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 148.97, ["Mega|Ride"] = 199.38, ["Mega|Fly|Ride"] = 350.44}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 157.5, ["Ride"] = 243.34, ["Fly|Ride"] = 349.67, ["Neon|Fly|Ride"] = 984.38, ["Mega|Fly|Ride"] = 3686.05}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.8, ["Ride"] = 15.81, ["Fly|Ride"] = 98.44, ["Neon"] = 6.49, ["Neon|Ride"] = 32.13, ["Neon|Fly|Ride"] = 124.87, ["Mega"] = 70.16, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.12, ["Ride"] = 42, ["Fly|Ride"] = 88.86, ["Neon"] = 27.2, ["Neon|Ride"] = 188.27, ["Mega"] = 140.3, ["Mega|Ride"] = 237.47}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.14, ["Fly"] = 98.42, ["Ride"] = 20.9, ["Neon"] = 25.86, ["Neon|Ride"] = 52.5, ["Mega"] = 84.95, ["Mega|Ride"] = 174.57, ["Mega|Fly|Ride"] = 559.05}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 89.25, ["Fly|Ride"] = 559.05, ["Neon|Ride"] = 1564.03, ["Neon|Fly|Ride"] = 1256.26, ["Mega|Ride"] = 4187.5, ["Mega|Fly|Ride"] = 2849.51}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 23.36, ["Fly"] = 118.77, ["Ride"] = 47.52, ["Fly|Ride"] = 224.05, ["Neon"] = 149.5, ["Neon|Ride"] = 279.54, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 536.16, ["Mega|Ride"] = 837.51, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 15.54, ["Fly"] = 83.76, ["Ride"] = 31.71, ["Fly|Ride"] = 90.57, ["Neon"] = 97.67, ["Neon|Ride"] = 124.67, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 432.16, ["Mega|Ride"] = 435.2, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 61.74, ["Neon"] = 6.26, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 207.38, ["Mega"] = 76.12, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 245.44}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 44.63, ["Fly"] = 5937.8, ["Ride"] = 73.22, ["Fly|Ride"] = 150.92, ["Neon"] = 293.14, ["Neon|Fly"] = 272.43, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 298.83, ["Mega|Fly|Ride"] = 1011.71}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.67, ["Fly|Ride"] = 39.9, ["Neon"] = 5.04, ["Neon|Ride"] = 56.55, ["Neon|Fly|Ride"] = 124.59, ["Mega"] = 58.9}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 18.31, ["Fly"] = 127.09, ["Ride"] = 20.83, ["Fly|Ride"] = 85.5, ["Neon"] = 66.2, ["Neon|Ride"] = 112.03, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 393.75, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 418.76, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 38.1, ["Fly"] = 112.03, ["Ride"] = 96.98, ["Fly|Ride"] = 149.09, ["Neon"] = 183.75, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 417.72, ["Mega|Ride"] = 1955.57, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 16.7, ["Ride"] = 12.1, ["Fly|Ride"] = 35.44, ["Neon"] = 2.1, ["Neon|Fly"] = 24.1, ["Neon|Ride"] = 16.77, ["Neon|Fly|Ride"] = 32.81, ["Mega"] = 16.95, ["Mega|Fly"] = 118.74, ["Mega|Ride"] = 32.75, ["Mega|Fly|Ride"] = 88.24}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.1, ["Ride"] = 45.14, ["Fly|Ride"] = 131.25, ["Neon"] = 16.98, ["Neon|Ride"] = 56.55, ["Neon|Fly|Ride"] = 209.39, ["Mega"] = 131.25, ["Mega|Ride"] = 277.85, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 13.76, ["Ride"] = 51.59, ["Fly|Ride"] = 85.32, ["Neon"] = 110.25, ["Mega"] = 536.82, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 2.1, ["Neon|Ride"] = 28.86, ["Neon|Fly|Ride"] = 95.81, ["Mega"] = 16.77, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 175.89}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 10.45, ["Fly"] = 193.36, ["Ride"] = 65.55, ["Fly|Ride"] = 171.7, ["Neon"] = 61.13, ["Neon|Ride"] = 171.7, ["Neon|Fly|Ride"] = 443.63, ["Mega"] = 536.02, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 614.53}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 9.1, ["Fly"] = 41.89, ["Ride"] = 21.56, ["Fly|Ride"] = 98.44, ["Neon"] = 408.97, ["Neon|Ride"] = 109.8, ["Neon|Fly|Ride"] = 129.94, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 2.1, ["Ride"] = 18.5, ["Neon"] = 24.04, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 65.61, ["Neon|Fly|Ride"] = 130.19, ["Mega"] = 233.48, ["Mega|Ride"] = 246.68, ["Mega|Fly|Ride"] = 413.53}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 6, ["Fly"] = 1994.97, ["Ride"] = 72.18, ["Fly|Ride"] = 279.54, ["Neon"] = 42.52, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 6331.83, ["Mega|Ride"] = 442.32, ["Mega|Fly|Ride"] = 941.15}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 19.28, ["Fly|Ride"] = 196.88, ["Neon"] = 6.56, ["Neon|Ride"] = 32.43, ["Mega"] = 69.55, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 148.32}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 1.79, ["Ride"] = 55.53, ["Neon"] = 6.29, ["Mega"] = 18.38, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 384.69}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 15.79}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 36.75, ["Fly"] = 98.42, ["Ride"] = 52.48, ["Fly|Ride"] = 82.66, ["Neon"] = 238.71, ["Neon|Ride"] = 282.97, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 1854.57, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 850.54}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 28.28, ["Mega"] = 17.98, ["Mega|Ride"] = 119.7, ["Mega|Fly|Ride"] = 300.57}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 446.25, ["Fly"] = 498.75, ["Ride"] = 523.45, ["Fly|Ride"] = 641.82, ["Neon"] = 2089.58, ["Neon|Fly|Ride"] = 2331.4, ["Mega"] = 16749.95, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 6.01, ["Fly"] = 26.25, ["Ride"] = 25.47, ["Fly|Ride"] = 65.97, ["Neon"] = 34.35, ["Neon|Fly"] = 183.75, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 90.42, ["Mega|Ride"] = 144.37, ["Mega|Fly|Ride"] = 279.54}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.1, ["Fly"] = 28.28, ["Ride"] = 21.84, ["Fly|Ride"] = 69.34, ["Neon"] = 19.03, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 140.3, ["Mega|Ride"] = 142.49, ["Mega|Fly|Ride"] = 245.66}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 12.76, ["Fly"] = 70.16, ["Ride"] = 50.27, ["Fly|Ride"] = 68.86, ["Neon"] = 101.76, ["Neon|Ride"] = 170.65, ["Mega"] = 823.9, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 733.69}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.1, ["Fly"] = 56.55, ["Ride"] = 28.28, ["Fly|Ride"] = 721.88, ["Neon"] = 30.38, ["Neon|Ride"] = 105, ["Mega"] = 275.63}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 10.18, ["Fly"] = 36.66, ["Ride"] = 140.3, ["Fly|Ride"] = 157.49, ["Neon"] = 64.58, ["Neon|Ride"] = 99.75, ["Mega"] = 418.76, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 530.78}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 3.65, ["Ride"] = 35.85, ["Fly|Ride"] = 133.88, ["Neon"] = 32.34, ["Neon|Ride"] = 80.12, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 559.05, ["Mega|Fly"] = 559.05, ["Mega|Ride"] = 350.27, ["Mega|Fly|Ride"] = 386.94}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 40.39, ["Ride"] = 13.54, ["Fly|Ride"] = 68.25, ["Neon"] = 2.1, ["Neon|Fly"] = 59.69, ["Neon|Ride"] = 15.49, ["Neon|Fly|Ride"] = 76.16, ["Mega"] = 15.75, ["Mega|Fly"] = 32.07, ["Mega|Ride"] = 25.51, ["Mega|Fly|Ride"] = 183.1}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 4.97, ["Fly"] = 53.41, ["Ride"] = 19.02, ["Fly|Ride"] = 104.7, ["Neon"] = 28.64, ["Neon|Fly"] = 118.74, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 224.05, ["Mega"] = 167.51, ["Mega|Ride"] = 145.69, ["Mega|Fly|Ride"] = 360.29}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 311.95, ["Ride"] = 301.88, ["Fly|Ride"] = 518.22, ["Neon"] = 1312.5, ["Neon|Ride"] = 1263.94, ["Neon|Fly|Ride"] = 1252.12, ["Mega|Ride"] = 9213.38, ["Mega|Fly|Ride"] = 5086.99}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 85.32, ["Ride"] = 140.3, ["Fly|Ride"] = 279.54, ["Neon"] = 616.88, ["Neon|Ride"] = 364.88, ["Neon|Fly|Ride"] = 585.27, ["Mega"] = 2234.04, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1697.64}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 16.85, ["Ride"] = 15.32, ["Fly|Ride"] = 47.52, ["Neon"] = 8.4, ["Neon|Fly"] = 69.53, ["Neon|Ride"] = 32.07, ["Neon|Fly|Ride"] = 70.16, ["Mega"] = 62.83, ["Mega|Fly"] = 208.34, ["Mega|Ride"] = 103.66, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 18.69, ["Ride"] = 13.37, ["Fly|Ride"] = 34.53, ["Neon"] = 6.57, ["Neon|Fly"] = 52.36, ["Neon|Ride"] = 20.05, ["Neon|Fly|Ride"] = 60.95, ["Mega"] = 65.54, ["Mega|Fly"] = 279.54, ["Mega|Ride"] = 104.7, ["Mega|Fly|Ride"] = 226.14}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.73, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 58.97, ["Mega"] = 272.21, ["Mega|Ride"] = 349.67}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 239, ["Fly"] = 420, ["Ride"] = 245.44, ["Fly|Ride"] = 334.69, ["Neon|Ride"] = 2093.76, ["Neon|Fly|Ride"] = 1549.38, ["Mega|Ride"] = 8374.98, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Ride"] = 15.65, ["Fly|Ride"] = 35.22, ["Neon"] = 17.07, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 39.26, ["Neon|Fly|Ride"] = 110.98, ["Mega"] = 255.94, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 417.72}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 6.34, ["Ride"] = 95.51, ["Fly|Ride"] = 209.39, ["Neon"] = 59.06, ["Neon|Ride"] = 195.78, ["Neon|Fly|Ride"] = 279.54, ["Mega"] = 221.94, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 391.54}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 82.69, ["Neon"] = 6.15, ["Neon|Ride"] = 155.91, ["Mega"] = 59.06, ["Mega|Ride"] = 209.39}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 9.18, ["Fly"] = 26.25, ["Ride"] = 19.95, ["Fly|Ride"] = 57.2, ["Neon"] = 80.76, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 140.3, ["Mega"] = 510.46, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 587.99}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 39.14, ["Ride"] = 105.24, ["Fly|Ride"] = 297.12, ["Neon"] = 137.4, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 203.2, ["Neon|Fly|Ride"] = 337.57, ["Mega"] = 402.94, ["Mega|Fly"] = 2198.44, ["Mega|Ride"] = 404.25, ["Mega|Fly|Ride"] = 577.01}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 23.07, ["Fly"] = 63, ["Ride"] = 41.89, ["Fly|Ride"] = 96.33, ["Neon"] = 140.44, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 210.37, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 837.51, ["Mega|Ride"] = 700.87, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 20.86, ["Ride"] = 14.95, ["Fly|Ride"] = 42.33, ["Neon"] = 2.1, ["Neon|Fly"] = 17.82, ["Neon|Ride"] = 15.33, ["Neon|Fly|Ride"] = 47.15, ["Mega"] = 17.73, ["Mega|Fly"] = 418.76, ["Mega|Ride"] = 35.61, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 207.29, ["Ride"] = 228.38, ["Fly|Ride"] = 318.93, ["Neon"] = 3108.1, ["Neon|Fly|Ride"] = 1254.17, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 6.67, ["Fly"] = 101.18, ["Ride"] = 42.37, ["Fly|Ride"] = 105, ["Neon"] = 112.03, ["Neon|Ride"] = 205.2, ["Neon|Fly|Ride"] = 328.12, ["Mega"] = 544.39, ["Mega|Ride"] = 712.39, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 32.29, ["Ride"] = 17.68, ["Fly|Ride"] = 42.08, ["Neon"] = 5.92, ["Neon|Fly"] = 39, ["Neon|Ride"] = 27.34, ["Neon|Fly|Ride"] = 110.98, ["Mega"] = 61.79, ["Mega|Fly"] = 279.54, ["Mega|Ride"] = 76.81, ["Mega|Fly|Ride"] = 284.96}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 1.79, ["Fly"] = 31.42, ["Ride"] = 19.91, ["Fly|Ride"] = 43.72, ["Neon"] = 2.63, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 112.03, ["Mega"] = 28.88, ["Mega|Fly"] = 140.3, ["Mega|Ride"] = 39.8, ["Mega|Fly|Ride"] = 163.42}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 28.74, ["Fly|Ride"] = 72.19, ["Neon"] = 8.88, ["Neon|Fly"] = 712.38, ["Neon|Ride"] = 48.18, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 103.68, ["Mega|Ride"] = 191.35, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 8.13, ["Fly"] = 38.75, ["Ride"] = 23.3, ["Fly|Ride"] = 41.89, ["Neon"] = 44.8, ["Neon|Fly"] = 300.47, ["Neon|Ride"] = 45.83, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 338.49, ["Mega|Ride"] = 236.23, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 4.59, ["Ride"] = 56.22, ["Fly|Ride"] = 72.19, ["Neon"] = 38.59, ["Neon|Ride"] = 104.7, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 275.63, ["Mega|Ride"] = 317.03, ["Mega|Fly|Ride"] = 388.25}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 43.32, ["Neon"] = 2.1, ["Neon|Ride"] = 28.61, ["Neon|Fly|Ride"] = 100.36, ["Mega"] = 35.6, ["Mega|Ride"] = 73.5, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 9.52, ["Ride"] = 26.27, ["Fly|Ride"] = 131.25, ["Neon"] = 24.55, ["Neon|Fly"] = 102.8, ["Neon|Ride"] = 45, ["Neon|Fly|Ride"] = 106.8, ["Mega"] = 237.47, ["Mega|Ride"] = 200.82, ["Mega|Fly|Ride"] = 270.13}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 79.69, ["Neon"] = 3.65, ["Neon|Fly"] = 112.03, ["Neon|Ride"] = 45.77, ["Neon|Fly|Ride"] = 102.3, ["Mega"] = 41.89, ["Mega|Ride"] = 102.61, ["Mega|Fly|Ride"] = 136.11}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 42.75, ["Ride"] = 17.11, ["Fly|Ride"] = 39.38, ["Neon"] = 4.72, ["Neon|Ride"] = 20.88, ["Neon|Fly|Ride"] = 121.44, ["Mega"] = 53.87, ["Mega|Fly"] = 140.3, ["Mega|Ride"] = 87.21, ["Mega|Fly|Ride"] = 195.78}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 767.82, ["Ride"] = 721.88, ["Fly|Ride"] = 907.66, ["Neon|Fly|Ride"] = 3543.75, ["Mega|Fly|Ride"] = 12571.04}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 19.22, ["Ride"] = 14.23, ["Fly|Ride"] = 31.42, ["Neon"] = 18.35, ["Neon|Fly"] = 140.3, ["Neon|Ride"] = 35.79, ["Neon|Fly|Ride"] = 111.62, ["Mega|Fly|Ride"] = 360.13}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 22.58, ["Fly|Ride"] = 279.54, ["Neon"] = 4.6, ["Neon|Fly"] = 732.83, ["Neon|Ride"] = 83.76, ["Neon|Fly|Ride"] = 354.38, ["Mega"] = 54.48, ["Mega|Fly"] = 195.78, ["Mega|Ride"] = 116.94, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 9.96, ["Fly"] = 47.52, ["Ride"] = 18.01, ["Fly|Ride"] = 36.01, ["Neon"] = 50.6, ["Neon|Fly"] = 189.97, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 95.82, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 281.31}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 1.79, ["Fly"] = 20.95, ["Ride"] = 14.83, ["Fly|Ride"] = 32.08, ["Neon"] = 6.79, ["Neon|Fly"] = 64.32, ["Neon|Ride"] = 23.54, ["Neon|Fly|Ride"] = 69.21, ["Mega"] = 65.51, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 85.22, ["Mega|Fly|Ride"] = 181.42}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 37.67, ["Ride"] = 84, ["Fly|Ride"] = 279.54, ["Neon"] = 281.3, ["Neon|Ride"] = 184.21, ["Mega"] = 974.66, ["Mega|Ride"] = 768.42, ["Mega|Fly|Ride"] = 1187.17}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 19.68, ["Fly|Ride"] = 64.16, ["Neon"] = 5.25, ["Neon|Fly"] = 135.37, ["Neon|Ride"] = 29.77, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 42.29, ["Mega|Ride"] = 124.94, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 69.21, ["Ride"] = 20.58, ["Fly|Ride"] = 65.63, ["Neon"] = 9.07, ["Neon|Ride"] = 41.88, ["Neon|Fly|Ride"] = 112.03, ["Mega"] = 114.19, ["Mega|Ride"] = 198.6, ["Mega|Fly|Ride"] = 351.74}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly|Ride"] = 59.07, ["Neon"] = 26.25, ["Mega"] = 93.81, ["Mega|Ride"] = 157.04, ["Mega|Fly|Ride"] = 376.69}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 15.73, ["Fly|Ride"] = 49.87, ["Neon"] = 4.75, ["Neon|Ride"] = 24.26, ["Neon|Fly|Ride"] = 99.47, ["Mega"] = 38.88, ["Mega|Fly"] = 229.68, ["Mega|Ride"] = 63.84}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 12.02, ["Fly"] = 19.69, ["Ride"] = 17.41, ["Fly|Ride"] = 32.8, ["Neon"] = 317.01, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 101.07, ["Mega|Ride"] = 418.76, ["Mega|Fly|Ride"] = 461.49}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 656.25, ["Ride"] = 708.75, ["Fly|Ride"] = 787.5, ["Neon"] = 1782.92, ["Neon|Ride"] = 1967.44, ["Neon|Fly|Ride"] = 1990.86, ["Mega"] = 4654.5, ["Mega|Ride"] = 6644.51, ["Mega|Fly|Ride"] = 6333.01}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 15.72, ["Ride"] = 15.37, ["Fly|Ride"] = 33.89, ["Neon"] = 3.68, ["Neon|Ride"] = 17.05, ["Neon|Fly|Ride"] = 51.06, ["Mega"] = 42.37, ["Mega|Ride"] = 57.66, ["Mega|Fly|Ride"] = 140.31}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 4.4, ["Ride"] = 36.73, ["Fly|Ride"] = 202, ["Neon"] = 43.31, ["Neon|Fly"] = 71.25, ["Neon|Ride"] = 112.51, ["Neon|Fly|Ride"] = 210, ["Mega"] = 366.18, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 533.92}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 52.5, ["Fly"] = 104.9, ["Ride"] = 53.73, ["Fly|Ride"] = 110.25, ["Neon"] = 514.03, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 382.33, ["Mega"] = 2439.83, ["Mega|Fly|Ride"] = 2040.94}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 26.92, ["Ride"] = 39.8, ["Fly|Ride"] = 104.89, ["Neon"] = 187.69, ["Neon|Ride"] = 219.86, ["Neon|Fly|Ride"] = 308.84, ["Mega"] = 983.89, ["Mega|Ride"] = 896.44, ["Mega|Fly|Ride"] = 1018.62}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 8.47, ["Ride"] = 25.97, ["Fly|Ride"] = 140.3, ["Neon"] = 59.07, ["Neon|Ride"] = 140.3, ["Neon|Fly|Ride"] = 116.22, ["Mega"] = 288.75, ["Mega|Fly|Ride"] = 446.24}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 26.03, ["Ride"] = 56.55, ["Neon"] = 103.68, ["Neon|Ride"] = 139.61, ["Mega"] = 314.35, ["Mega|Fly"] = 515.3, ["Mega|Ride"] = 374, ["Mega|Fly|Ride"] = 784.23}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 14.48, ["Fly"] = 126.9, ["Fly|Ride"] = 152.17, ["Neon"] = 251.27, ["Neon|Ride"] = 317.01, ["Neon|Fly|Ride"] = 525, ["Mega"] = 924, ["Mega|Ride"] = 628.14, ["Mega|Fly|Ride"] = 563.21}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 16.3}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 2.35, ["Fly"] = 131248.69, ["Ride"] = 20.34, ["Fly|Ride"] = 58.65, ["Neon"] = 31.42, ["Neon|Ride"] = 66.51, ["Neon|Fly|Ride"] = 182.17, ["Mega"] = 196.27, ["Mega|Fly"] = 473.21, ["Mega|Ride"] = 206.6, ["Mega|Fly|Ride"] = 287.81}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.49, ["Ride"] = 46.85, ["Neon"] = 11.81, ["Neon|Fly|Ride"] = 209.39, ["Mega"] = 140.3, ["Mega|Fly|Ride"] = 405.57}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 36.75, ["Fly"] = 56.55, ["Ride"] = 56.55, ["Fly|Ride"] = 101.28, ["Neon"] = 262.5, ["Neon|Ride"] = 206.6, ["Neon|Fly|Ride"] = 949.85, ["Mega|Ride"] = 1675.01, ["Mega|Fly|Ride"] = 689.07}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.3, ["Fly"] = 17.58, ["Ride"] = 15.24, ["Fly|Ride"] = 33.36, ["Neon"] = 23.18, ["Neon|Fly"] = 61.79, ["Neon|Ride"] = 31.36, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 196.88, ["Mega|Fly"] = 417.72, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 211.68}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 2.59, ["Fly"] = 36.66, ["Ride"] = 22.22, ["Fly|Ride"] = 55.7, ["Neon"] = 14.43, ["Neon|Ride"] = 41.48, ["Neon|Fly|Ride"] = 118.11, ["Mega"] = 135.83, ["Mega|Ride"] = 169.25, ["Mega|Fly|Ride"] = 260.24}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 7.88, ["Mega"] = 38.75, ["Mega|Ride"] = 195.78}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 24.68, ["Fly"] = 77.17, ["Ride"] = 52.5, ["Fly|Ride"] = 89.25, ["Neon"] = 210, ["Neon|Ride"] = 237.66, ["Neon|Fly|Ride"] = 288.95, ["Mega|Ride"] = 13959}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 20.36, ["Fly|Ride"] = 65.63, ["Neon"] = 6.3, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 28.28, ["Mega"] = 74.81, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 462.31}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 9.15, ["Ride"] = 79.58, ["Fly|Ride"] = 278.49, ["Neon"] = 106.87, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 341.25, ["Mega|Ride"] = 391.75, ["Mega|Fly|Ride"] = 601.97}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 14.59, ["Fly|Ride"] = 50.27, ["Neon"] = 18.77, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 75.88, ["Mega|Ride"] = 208.04, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 19.2, ["Fly|Ride"] = 75.12, ["Neon"] = 35.44, ["Neon|Fly"] = 65.97, ["Neon|Ride"] = 418.76, ["Mega"] = 291.38, ["Mega|Ride"] = 417.72, ["Mega|Fly|Ride"] = 412.79}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 5.25, ["Ride"] = 65.97, ["Neon"] = 39.36, ["Neon|Ride"] = 227.07, ["Mega"] = 474.93, ["Mega|Ride"] = 950.06}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 32.81, ["Ride"] = 263.81, ["Neon"] = 248.07, ["Neon|Ride"] = 652.21, ["Neon|Fly|Ride"] = 418.76, ["Mega"] = 2234.04, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 16.64, ["Ride"] = 279.54, ["Neon"] = 103.66, ["Neon|Ride"] = 183.75, ["Mega"] = 452.92, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 8.09, ["Ride"] = 125.98, ["Neon"] = 171.62, ["Neon|Fly"] = 209.39, ["Neon|Ride"] = 418.76, ["Mega"] = 140.3, ["Mega|Ride"] = 836.47}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 20.89, ["Ride"] = 105, ["Fly|Ride"] = 367.46, ["Neon"] = 103.36, ["Neon|Ride"] = 732.83, ["Neon|Fly|Ride"] = 328.12, ["Mega"] = 604.54, ["Mega|Fly"] = 2093.76, ["Mega|Fly|Ride"] = 1108.94}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.46, ["Neon"] = 13, ["Mega"] = 210, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 317.03}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 128.51, ["Ride"] = 17.83, ["Fly|Ride"] = 40.61, ["Neon"] = 3.73, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 28.25, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 80.76, ["Mega|Ride"] = 80.15, ["Mega|Fly|Ride"] = 321.57}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 2.1, ["Ride"] = 41.89, ["Fly|Ride"] = 65.63, ["Neon"] = 16.89, ["Neon|Ride"] = 69.3, ["Neon|Fly|Ride"] = 118.74, ["Mega"] = 105, ["Mega|Ride"] = 131.81, ["Mega|Fly|Ride"] = 279.54}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 28.44, ["Ride"] = 15.63, ["Fly|Ride"] = 56.44, ["Neon"] = 3.86, ["Neon|Ride"] = 25.88, ["Neon|Fly|Ride"] = 79.56, ["Mega"] = 32.81, ["Mega|Fly"] = 167.51, ["Mega|Ride"] = 76.72, ["Mega|Fly|Ride"] = 191.02}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 65.62, ["Ride"] = 18, ["Fly|Ride"] = 112.03, ["Neon"] = 15.72, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 328.02, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 474.93}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.94, ["Fly"] = 65.63, ["Ride"] = 19.59, ["Neon"] = 25.89, ["Neon|Fly"] = 315, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 302.45, ["Mega|Ride"] = 287.46}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 25.33, ["Fly|Ride"] = 61.65, ["Neon"] = 19.47, ["Neon|Fly"] = 112.03, ["Neon|Ride"] = 32.8, ["Neon|Fly|Ride"] = 105, ["Mega"] = 196.88, ["Mega|Ride"] = 448.08, ["Mega|Fly|Ride"] = 394.42}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 34.07, ["Ride"] = 19.69, ["Fly|Ride"] = 51.78, ["Neon"] = 18.79, ["Neon|Ride"] = 70.16, ["Neon|Fly|Ride"] = 104.7, ["Mega"] = 237.66, ["Mega|Ride"] = 209.39, ["Mega|Fly|Ride"] = 244.99}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 2.1, ["Fly"] = 57.66, ["Ride"] = 43.29, ["Fly|Ride"] = 87.93, ["Neon"] = 17.75, ["Neon|Fly"] = 437.04, ["Neon|Ride"] = 56.03, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 103.57, ["Mega|Fly"] = 176.5, ["Mega|Ride"] = 132.2, ["Mega|Fly|Ride"] = 223.12}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 15.74, ["Fly"] = 106.56, ["Ride"] = 99.53, ["Fly|Ride"] = 231.53, ["Neon"] = 111.56, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 321.41, ["Mega"] = 519.75, ["Mega|Ride"] = 669.37, ["Mega|Fly|Ride"] = 726.2}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 51.17, ["Fly"] = 164.07, ["Ride"] = 79.58, ["Fly|Ride"] = 489.17, ["Neon"] = 221.8, ["Neon|Ride"] = 266.97, ["Neon|Fly|Ride"] = 486.81, ["Mega"] = 1151.58, ["Mega|Ride"] = 1061.82, ["Mega|Fly|Ride"] = 1284.94}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 50.97, ["Ride"] = 18.36, ["Fly|Ride"] = 73.29, ["Neon"] = 2.63, ["Neon|Ride"] = 23.98, ["Mega"] = 31.42, ["Mega|Ride"] = 47.16, ["Mega|Fly|Ride"] = 144.01}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 8.69, ["Mega|Fly|Ride"] = 1030.14}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 55.49, ["Fly"] = 105, ["Ride"] = 78.75, ["Fly|Ride"] = 183.75, ["Neon"] = 299.14, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 836.47, ["Mega"] = 1715.84}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 3.89, ["Fly"] = 190.32, ["Ride"] = 36.66, ["Fly|Ride"] = 133.87, ["Neon"] = 36.63, ["Neon|Ride"] = 83.76, ["Neon|Fly|Ride"] = 210, ["Mega"] = 192.93, ["Mega|Ride"] = 223.12, ["Mega|Fly|Ride"] = 312.38}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 3.9, ["Ride"] = 65.36, ["Fly|Ride"] = 141.75, ["Neon"] = 8.91, ["Neon|Ride"] = 65.62, ["Mega"] = 83.99, ["Mega|Fly"] = 310.84, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 360.99}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 21.84, ["Ride"] = 14.27, ["Fly|Ride"] = 39.37, ["Neon"] = 8.91, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 236.25, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 140.3, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.74, ["Ride"] = 14.44, ["Fly|Ride"] = 41.2, ["Neon"] = 2.62, ["Neon|Fly"] = 17.77, ["Neon|Ride"] = 23.05, ["Neon|Fly|Ride"] = 36.75, ["Mega"] = 28.88, ["Mega|Ride"] = 69.55, ["Mega|Fly|Ride"] = 118.14}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 19.91, ["Fly|Ride"] = 90.95, ["Neon"] = 4.73, ["Neon|Ride"] = 27.44, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 38.74, ["Mega|Ride"] = 140.3, ["Mega|Fly|Ride"] = 177.11}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.49, ["Fly|Ride"] = 118.74, ["Neon"] = 2.59, ["Neon|Ride"] = 145.08, ["Mega"] = 21.39, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 4.77, ["Ride"] = 104.98, ["Neon"] = 30.45, ["Neon|Ride"] = 159.11, ["Neon|Fly|Ride"] = 628.14, ["Mega"] = 317.03, ["Mega|Ride"] = 269.48, ["Mega|Fly|Ride"] = 317.03}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 4.77, ["Ride"] = 31.61, ["Fly|Ride"] = 98.42, ["Neon"] = 52.85, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 140.3, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 3.27, ["Fly"] = 20.98, ["Ride"] = 16.69, ["Fly|Ride"] = 38.75, ["Neon"] = 29.5, ["Neon|Ride"] = 38.17, ["Neon|Fly|Ride"] = 91.88, ["Mega|Ride"] = 349.67, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 56.2, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 448.08, ["Mega"] = 2374.59, ["Mega|Fly|Ride"] = 1472.63}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 26.34, ["Fly"] = 82.68, ["Ride"] = 31.4, ["Fly|Ride"] = 78.75, ["Neon"] = 279.54, ["Neon|Fly|Ride"] = 630, ["Mega"] = 634.04, ["Mega|Ride"] = 689.73, ["Mega|Fly|Ride"] = 694.98}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 25.79, ["Ride"] = 15.75, ["Fly|Ride"] = 28.28, ["Neon"] = 2.1, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 61.79, ["Mega"] = 32.82, ["Mega|Ride"] = 90.65, ["Mega|Fly|Ride"] = 188.98}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 16.37, ["Ride"] = 12.23, ["Fly|Ride"] = 28.25, ["Neon"] = 3.8, ["Neon|Fly"] = 27.2, ["Neon|Ride"] = 16.7, ["Neon|Fly|Ride"] = 42.76, ["Mega"] = 42.82, ["Mega|Fly"] = 91.09, ["Mega|Ride"] = 56.35, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 402.81, ["Fly"] = 598.55, ["Ride"] = 446.24, ["Fly|Ride"] = 551.24, ["Neon|Fly|Ride"] = 1903.12}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 3.45, ["Ride"] = 64.97, ["Fly|Ride"] = 535.42, ["Neon"] = 32.82, ["Neon|Ride"] = 106.81, ["Mega"] = 363.27, ["Mega|Ride"] = 400.32, ["Mega|Fly|Ride"] = 279165.99}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 14.78, ["Ride"] = 15.75, ["Fly|Ride"] = 27.92, ["Neon"] = 3.94, ["Neon|Fly"] = 23.77, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 35.66, ["Mega"] = 140.3, ["Mega|Ride"] = 74.97, ["Mega|Fly|Ride"] = 105.45}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 52.5, ["Ride"] = 112.03, ["Fly|Ride"] = 279.54, ["Neon"] = 262.4, ["Neon|Ride"] = 269.52, ["Neon|Fly|Ride"] = 461.69, ["Mega"] = 719.25, ["Mega|Ride"] = 748.13, ["Mega|Fly|Ride"] = 939.75}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 37.71, ["Ride"] = 16.21, ["Fly|Ride"] = 35.44, ["Neon"] = 11.99, ["Neon|Fly"] = 61.78, ["Neon|Ride"] = 14.99, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 111.37, ["Mega|Ride"] = 124.76, ["Mega|Fly|Ride"] = 215.19}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 70.16, ["Ride"] = 41.89, ["Neon"] = 2.1, ["Neon|Ride"] = 35.43, ["Neon|Fly|Ride"] = 74.82, ["Mega"] = 18.52, ["Mega|Ride"] = 56.14, ["Mega|Fly|Ride"] = 190.88}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 38.94, ["Fly"] = 123.44, ["Ride"] = 66.88, ["Fly|Ride"] = 213.94, ["Neon"] = 220.5, ["Neon|Ride"] = 191.26, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 830.82, ["Mega|Ride"] = 837.51, ["Mega|Fly|Ride"] = 811.13}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 19.67, ["Fly|Ride"] = 52.5, ["Neon"] = 3.88, ["Neon|Ride"] = 39.99, ["Mega"] = 36.75, ["Mega|Ride"] = 197.4, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 23.62, ["Ride"] = 66.94, ["Fly|Ride"] = 159.11, ["Neon"] = 335.02, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 1654.07, ["Mega|Ride"] = 1675.01, ["Mega|Fly|Ride"] = 1507.51}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.15, ["Ride"] = 183.74, ["Neon"] = 21.94, ["Neon|Ride"] = 79.56, ["Neon|Fly|Ride"] = 154.95, ["Mega"] = 157.5, ["Mega|Ride"] = 147}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Ride"] = 71.3, ["Fly|Ride"] = 70.16, ["Neon"] = 7.39, ["Neon|Ride"] = 39.36, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 117.6, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 559.05}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 52.5, ["Ride"] = 104.99, ["Fly|Ride"] = 523.45, ["Mega"] = 2093.76, ["Mega|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 1796.44}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 15.75, ["Fly|Ride"] = 60.2, ["Neon"] = 6.57, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 46.46, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 82.72, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 15.49, ["Ride"] = 15.18, ["Fly|Ride"] = 101.82, ["Neon"] = 10.9, ["Neon|Fly"] = 47.77, ["Neon|Ride"] = 24.1, ["Neon|Fly|Ride"] = 118.74, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 9.11, ["Fly"] = 58.49, ["Ride"] = 23.77, ["Fly|Ride"] = 75.78, ["Neon"] = 81.78, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 140.3, ["Mega"] = 439.69, ["Mega|Ride"] = 627.09, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 7.35, ["Fly"] = 57.11, ["Ride"] = 20.95, ["Fly|Ride"] = 71.52, ["Neon"] = 91.09, ["Neon|Ride"] = 135.94, ["Neon|Fly|Ride"] = 196.83, ["Mega"] = 354.25, ["Mega|Ride"] = 417.26, ["Mega|Fly|Ride"] = 496.91}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 20.89, ["Fly"] = 51.18, ["Ride"] = 26.17, ["Fly|Ride"] = 59.07, ["Neon"] = 56.6, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 138.21, ["Mega"] = 559.05, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 431.32}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 59.07, ["Ride"] = 104.85, ["Fly|Ride"] = 249.38, ["Neon"] = 288.74, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 474.93, ["Mega|Ride"] = 1229.04, ["Mega|Fly|Ride"] = 1299.38}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 6.02, ["Fly"] = 140.3, ["Ride"] = 56.55, ["Neon"] = 24.04, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 121.72, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 223.13, ["Mega|Ride"] = 462, ["Mega|Fly|Ride"] = 397.83}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.67, ["Ride"] = 26.24, ["Fly|Ride"] = 78.74, ["Neon"] = 10.5, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 125.64, ["Mega"] = 262.49, ["Mega|Ride"] = 183.74, ["Mega|Fly|Ride"] = 246.62}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 9.86, ["Ride"] = 24.04, ["Fly|Ride"] = 110.95, ["Neon"] = 47.61, ["Neon|Ride"] = 138.21, ["Neon|Fly|Ride"] = 237.47, ["Mega"] = 461.69, ["Mega|Ride"] = 488.91, ["Mega|Fly|Ride"] = 732.83}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.49, ["Ride"] = 12.58, ["Fly|Ride"] = 31.18, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 13.4, ["Neon|Fly|Ride"] = 39.25, ["Mega"] = 15.75, ["Mega|Ride"] = 29.49, ["Mega|Fly|Ride"] = 93.83}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 43.3, ["Fly"] = 221.94, ["Ride"] = 105, ["Neon"] = 264.43, ["Neon|Fly"] = 2373.28, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 3140.63, ["Mega|Ride"] = 945, ["Mega|Fly|Ride"] = 872.81}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 20.95, ["Fly|Ride"] = 35.61, ["Neon"] = 3.14, ["Neon|Ride"] = 27.44, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 264.88, ["Mega|Ride"] = 138.39, ["Mega|Fly|Ride"] = 405.15}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.28, ["Ride"] = 16.67, ["Fly|Ride"] = 58.47, ["Neon"] = 41.89, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 89.93, ["Mega"] = 257.25, ["Mega|Ride"] = 138.21, ["Mega|Fly|Ride"] = 209.39}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 65.62, ["Fly"] = 157.5, ["Ride"] = 101.88, ["Fly|Ride"] = 258.57, ["Neon"] = 437.07, ["Neon|Ride"] = 341.57, ["Neon|Fly|Ride"] = 1256.26, ["Mega"] = 1748.25, ["Mega|Ride"] = 1396.55, ["Mega|Fly|Ride"] = 1618.32}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 20.9, ["Neon"] = 5.44, ["Neon|Ride"] = 52.41, ["Neon|Fly|Ride"] = 140.3, ["Mega"] = 64.19, ["Mega|Ride"] = 108.04, ["Mega|Fly|Ride"] = 261.18}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 9.17}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Fly|Ride"] = 297.33, ["Neon"] = 6.25, ["Neon|Ride"] = 51.34, ["Neon|Fly|Ride"] = 154.95, ["Mega"] = 46.1, ["Mega|Ride"] = 104.98, ["Mega|Fly|Ride"] = 212.85}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 1.79}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 113.18, ["Ride"] = 151.59, ["Fly|Ride"] = 301.59, ["Neon"] = 836.07, ["Neon|Ride"] = 696.94, ["Neon|Fly|Ride"] = 917.44, ["Mega"] = 3350, ["Mega|Ride"] = 2493.75, ["Mega|Fly|Ride"] = 2816.1}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2.63, ["Ride"] = 41.89, ["Fly|Ride"] = 72.19, ["Neon"] = 19.58, ["Neon|Fly"] = 140.3, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 219.43, ["Mega"] = 178.39, ["Mega|Ride"] = 211.32, ["Mega|Fly|Ride"] = 368.51}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 35.61, ["Neon"] = 6.57, ["Neon|Ride"] = 20.23, ["Mega"] = 32.82, ["Mega|Ride"] = 98.42, ["Mega|Fly|Ride"] = 140.31}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 3.33, ["Ride"] = 19.52, ["Fly|Ride"] = 131.25, ["Neon"] = 50.74, ["Neon|Ride"] = 64.13, ["Neon|Fly|Ride"] = 159.11, ["Mega"] = 488.91, ["Mega|Ride"] = 418.76, ["Mega|Fly|Ride"] = 625.64}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 8.99, ["Fly"] = 56.74, ["Ride"] = 20.99, ["Fly|Ride"] = 55.82, ["Neon"] = 99, ["Neon|Ride"] = 144.8, ["Neon|Fly|Ride"] = 255.29, ["Mega"] = 616.88, ["Mega|Ride"] = 561.75, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 18.26, ["Ride"] = 63.67, ["Fly|Ride"] = 125.9, ["Neon"] = 131.25, ["Neon|Ride"] = 162.28, ["Neon|Fly|Ride"] = 1575, ["Mega"] = 782.02, ["Mega|Ride"] = 576.65, ["Mega|Fly|Ride"] = 570.94}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 131.25, ["Fly"] = 196.76, ["Ride"] = 144.38, ["Fly|Ride"] = 189, ["Neon"] = 593.15, ["Neon|Ride"] = 590, ["Neon|Fly|Ride"] = 654.94, ["Mega|Fly|Ride"] = 2420.14}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 39.78, ["Ride"] = 78.9, ["Fly|Ride"] = 118.13, ["Neon"] = 442.85, ["Neon|Ride"] = 1256.26, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 1050}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.72, ["Fly"] = 131.23, ["Ride"] = 21, ["Fly|Ride"] = 131.25, ["Neon"] = 15.64, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 131.81, ["Mega|Ride"] = 140.32, ["Mega|Fly|Ride"] = 299.25}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 3.56, ["Fly"] = 98.43, ["Ride"] = 35.12, ["Fly|Ride"] = 180.07, ["Neon"] = 52.5, ["Neon|Ride"] = 80.07, ["Neon|Fly|Ride"] = 157.04, ["Mega"] = 379.32, ["Mega|Ride"] = 433.13, ["Mega|Fly|Ride"] = 557.82}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 41.57, ["Fly"] = 142.52, ["Ride"] = 76.65, ["Fly|Ride"] = 159.14, ["Neon"] = 219.19, ["Neon|Ride"] = 275.35, ["Neon|Fly|Ride"] = 335.02, ["Mega"] = 1108.94, ["Mega|Ride"] = 971.25, ["Mega|Fly|Ride"] = 1002.04}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 12.32, ["Ride"] = 70.16, ["Neon"] = 105, ["Neon|Ride"] = 181.86, ["Neon|Fly|Ride"] = 461.69, ["Mega"] = 684.68, ["Mega|Ride"] = 618.72}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.39, ["Ride"] = 448.08, ["Neon|Ride"] = 3166.51, ["Neon|Fly|Ride"] = 1376.82}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 25.89, ["Fly"] = 56.55, ["Ride"] = 32.8, ["Fly|Ride"] = 65.54, ["Neon"] = 224.26, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 317.03, ["Mega"] = 761.25, ["Mega|Ride"] = 734.9, ["Mega|Fly|Ride"] = 1038.51}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 38.63, ["Ride"] = 12.58, ["Fly|Ride"] = 33.52, ["Neon"] = 2.1, ["Neon|Ride"] = 15.59, ["Neon|Fly|Ride"] = 42.78, ["Mega"] = 19.64, ["Mega|Fly"] = 100.51, ["Mega|Ride"] = 35.44, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Neon"] = 7.61, ["Neon|Ride"] = 56.55, ["Neon|Fly|Ride"] = 140.3, ["Mega"] = 146.57, ["Mega|Ride"] = 321.41, ["Mega|Fly|Ride"] = 418.76}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.04, ["Ride"] = 38.57, ["Fly|Ride"] = 144.21, ["Neon"] = 18.27, ["Neon|Ride"] = 82.71, ["Neon|Fly|Ride"] = 977.8, ["Mega"] = 108.84, ["Mega|Fly"] = 498.61, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 393.75, ["Fly"] = 498.6, ["Ride"] = 433.13, ["Fly|Ride"] = 525, ["Neon"] = 1424.39, ["Neon|Ride"] = 1564.03, ["Neon|Fly|Ride"] = 1532.63, ["Mega|Fly|Ride"] = 5304.51}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 3.13, ["Fly"] = 20.62, ["Ride"] = 16.58, ["Fly|Ride"] = 41.89, ["Neon"] = 21, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 86.9, ["Mega"] = 168, ["Mega|Ride"] = 279.54, ["Mega|Fly|Ride"] = 563.07}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 5.69, ["Fly"] = 22.32, ["Ride"] = 17.56, ["Fly|Ride"] = 35.44, ["Neon"] = 39.36, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 58.65, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 266.97, ["Mega|Fly|Ride"] = 286.38}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.74, ["Fly"] = 32.45, ["Ride"] = 28.87, ["Fly|Ride"] = 78.75, ["Neon"] = 10.83, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 55.04, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 140.3, ["Mega|Ride"] = 188.45, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 26.24, ["Fly"] = 41.89, ["Ride"] = 41.89, ["Fly|Ride"] = 65.63, ["Neon"] = 140.3, ["Neon|Ride"] = 173.36, ["Neon|Fly|Ride"] = 313.03, ["Mega"] = 1312.5, ["Mega|Ride"] = 836.47, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 28.28, ["Fly|Ride"] = 50.3, ["Neon"] = 11.46, ["Neon|Ride"] = 37.51, ["Neon|Fly|Ride"] = 210, ["Mega"] = 163.73, ["Mega|Ride"] = 457.79, ["Mega|Fly|Ride"] = 761.92}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 7.14, ["Fly"] = 64.28, ["Ride"] = 25.59, ["Fly|Ride"] = 159.14, ["Neon"] = 175.73, ["Neon|Fly"] = 159.11, ["Neon|Ride"] = 140.3, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 732.83, ["Mega|Ride"] = 753.77, ["Mega|Fly|Ride"] = 846.57}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.57, ["Neon"] = 5.74, ["Neon|Ride"] = 35.11, ["Mega"] = 52.5, ["Mega|Ride"] = 112.03, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 3.96, ["Neon"] = 50.67}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 5.91, ["Ride"] = 77.48, ["Neon"] = 79.71, ["Neon|Ride"] = 474.92, ["Neon|Fly|Ride"] = 418.76, ["Mega"] = 279.54, ["Mega|Ride"] = 543.34, ["Mega|Fly|Ride"] = 509.25}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 7.14, ["Fly"] = 27.92, ["Ride"] = 16.89, ["Fly|Ride"] = 45.94, ["Neon"] = 34.53, ["Neon|Fly"] = 70.16, ["Neon|Ride"] = 45.92, ["Neon|Fly|Ride"] = 72.18, ["Mega"] = 588.35, ["Mega|Ride"] = 314.93, ["Mega|Fly|Ride"] = 312.38}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 336.82, ["Fly"] = 396.66, ["Ride"] = 388.42, ["Fly|Ride"] = 426.57, ["Neon"] = 1659, ["Neon|Ride"] = 977.8, ["Neon|Fly|Ride"] = 1393.89}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.63, ["Fly|Ride"] = 35.61, ["Neon"] = 13.01, ["Neon|Fly"] = 79.56, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 145.04, ["Mega"] = 209.39, ["Mega|Ride"] = 196.77}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 7.31, ["Fly"] = 70.16, ["Ride"] = 44.12, ["Fly|Ride"] = 65.62, ["Neon"] = 45.03, ["Neon|Ride"] = 154.95, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 383.65, ["Mega|Fly"] = 698.29, ["Mega|Ride"] = 393.75}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 24.69, ["Ride"] = 102.22, ["Fly|Ride"] = 314.99, ["Neon"] = 99.75, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 348.2, ["Mega"] = 422.62, ["Mega|Ride"] = 354.27, ["Mega|Fly|Ride"] = 540.09}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 71.27, ["Fly"] = 169.32, ["Ride"] = 140.31, ["Fly|Ride"] = 196.88, ["Neon"] = 418.76, ["Neon|Ride"] = 1465.64, ["Neon|Fly|Ride"] = 942.2, ["Mega"] = 2367.47, ["Mega|Ride"] = 5541.1}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 12.23, ["Ride"] = 85.72, ["Fly|Ride"] = 131.11, ["Neon"] = 98.42, ["Neon|Ride"] = 105.52, ["Neon|Fly|Ride"] = 363.56, ["Mega"] = 275.63, ["Mega|Ride"] = 791.94, ["Mega|Fly|Ride"] = 442.39}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 1.93, ["Fly"] = 28.87, ["Ride"] = 19.58, ["Fly|Ride"] = 58.46, ["Neon"] = 12.47, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 70.16, ["Mega"] = 65.6, ["Mega|Ride"] = 144.86, ["Mega|Fly|Ride"] = 237.47}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 3.88, ["Ride"] = 34.33, ["Neon"] = 23.35, ["Neon|Ride"] = 94.25, ["Neon|Fly|Ride"] = 174.57, ["Mega"] = 159.11, ["Mega|Ride"] = 182.17, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 52.91, ["Fly"] = 183.74, ["Ride"] = 78.75, ["Fly|Ride"] = 206.75, ["Neon"] = 150.94, ["Neon|Ride"] = 157.36, ["Neon|Fly|Ride"] = 279.54, ["Mega"] = 417.82, ["Mega|Ride"] = 690.96, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Fly|Ride"] = 140.3, ["Neon"] = 10.39, ["Neon|Ride"] = 209.39, ["Neon|Fly|Ride"] = 199.31, ["Mega"] = 55.13, ["Mega|Fly"] = 170.63, ["Mega|Ride"] = 172.54, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 15.72, ["Neon"] = 105, ["Neon|Ride"] = 401.03, ["Mega"] = 586.26, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 984.38, ["Fly"] = 2093.76, ["Ride"] = 1040.58, ["Fly|Ride"] = 1087.19, ["Neon"] = 3331.16, ["Neon|Ride"] = 3601.25, ["Neon|Fly|Ride"] = 3281.22, ["Mega|Fly|Ride"] = 11557.09}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 12.96, ["Fly"] = 87.64, ["Ride"] = 57.31, ["Fly|Ride"] = 143.16, ["Neon"] = 202.13, ["Neon|Fly"] = 697.24, ["Neon|Ride"] = 209.39, ["Mega"] = 337.89, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.34, ["Ride"] = 21.42, ["Fly|Ride"] = 80.89, ["Neon"] = 10.28, ["Neon|Fly"] = 56.55, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 91.47, ["Mega"] = 82.86, ["Mega|Ride"] = 97.12, ["Mega|Fly|Ride"] = 249.17}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 9.87, ["Ride"] = 47.79, ["Fly|Ride"] = 140.3, ["Neon"] = 94.99, ["Neon|Fly|Ride"] = 393.73, ["Mega"] = 787.5, ["Mega|Ride"] = 418.76, ["Mega|Fly|Ride"] = 924}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 35.07, ["Fly|Ride"] = 182.17, ["Neon"] = 2.1, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 91.77, ["Mega"] = 15.65, ["Mega|Fly"] = 125.64, ["Mega|Ride"] = 42, ["Mega|Fly|Ride"] = 159.51}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 55.13, ["Ride"] = 103.68, ["Fly|Ride"] = 164.07, ["Neon"] = 260.86, ["Neon|Ride"] = 325.5, ["Mega"] = 1087.67, ["Mega|Ride"] = 930.57, ["Mega|Fly|Ride"] = 958.13}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 10.28, ["Ride"] = 63, ["Fly|Ride"] = 79.56, ["Neon"] = 70.25, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 576.19, ["Mega|Ride"] = 709.79, ["Mega|Fly|Ride"] = 557.82}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.56, ["Ride"] = 27.24, ["Neon"] = 13.13, ["Neon|Ride"] = 65.62, ["Mega"] = 99.75, ["Mega|Ride"] = 157.49, ["Mega|Fly|Ride"] = 418.76}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 19.93, ["Fly"] = 65.97, ["Ride"] = 41.18, ["Fly|Ride"] = 118.77, ["Neon"] = 140.3, ["Neon|Ride"] = 93.19, ["Neon|Fly|Ride"] = 154.95, ["Mega"] = 1039.49, ["Mega|Ride"] = 419.99, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 3.3, ["Fly"] = 32.47, ["Ride"] = 30.23, ["Fly|Ride"] = 94.23, ["Neon"] = 55.39, ["Neon|Ride"] = 209.39, ["Neon|Fly|Ride"] = 118.89, ["Mega"] = 383.17, ["Mega|Ride"] = 518.22, ["Mega|Fly|Ride"] = 418.76}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 30.18, ["Ride"] = 208.68, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 907.66, ["Mega"] = 2093.76, ["Mega|Ride"] = 1675.01, ["Mega|Fly|Ride"] = 1672.92}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 3.89, ["Fly|Ride"] = 255.34, ["Neon"] = 15.72, ["Neon|Ride"] = 94.23, ["Neon|Fly|Ride"] = 168.78, ["Mega"] = 99.93, ["Mega|Ride"] = 184.05, ["Mega|Fly|Ride"] = 226.94}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 3.77, ["Ride"] = 20.95, ["Fly|Ride"] = 81.67, ["Neon"] = 60.74, ["Neon|Ride"] = 58.24, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 301.67, ["Mega|Ride"] = 376.89, ["Mega|Fly|Ride"] = 598.82}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 116.7, ["Fly"] = 174.84, ["Ride"] = 160.78, ["Fly|Ride"] = 207.9, ["Neon"] = 577.6, ["Neon|Ride"] = 693.38, ["Neon|Fly|Ride"] = 689.07, ["Mega"] = 2327.07, ["Mega|Ride"] = 2336.63, ["Mega|Fly|Ride"] = 1847.87}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 36.75, ["Ride"] = 17.72, ["Fly|Ride"] = 39.29, ["Neon"] = 12.21, ["Neon|Fly"] = 57.52, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 74.21, ["Mega"] = 140.3, ["Mega|Ride"] = 237.47, ["Mega|Fly|Ride"] = 269.07}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 7.6, ["Fly"] = 195.43, ["Ride"] = 39.15, ["Fly|Ride"] = 93.8, ["Neon"] = 79.56, ["Neon|Fly"] = 317.01, ["Neon|Ride"] = 82.88, ["Neon|Fly|Ride"] = 140.3, ["Mega"] = 452.81, ["Mega|Ride"] = 463.78, ["Mega|Fly|Ride"] = 411.52}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.37, ["Ride"] = 14.7, ["Fly|Ride"] = 52.41, ["Neon"] = 2.1, ["Neon|Fly"] = 26.57, ["Neon|Ride"] = 15.64, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 15.59, ["Mega|Fly"] = 49.88, ["Mega|Ride"] = 30.18, ["Mega|Fly|Ride"] = 70.87}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 56.55, ["Fly|Ride"] = 39.38, ["Neon"] = 3.71, ["Neon|Ride"] = 41.89, ["Neon|Fly|Ride"] = 129.83, ["Mega"] = 17.07, ["Mega|Fly"] = 104.99, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 125.64}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 28.28, ["Ride"] = 26.32, ["Fly|Ride"] = 110.52, ["Neon"] = 16.99, ["Neon|Ride"] = 52.36, ["Neon|Fly|Ride"] = 206.6, ["Mega"] = 77.44, ["Mega|Ride"] = 265.93, ["Mega|Fly|Ride"] = 246.1}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 30.19, ["Ride"] = 52.47, ["Fly|Ride"] = 131.25, ["Neon"] = 164.07, ["Neon|Ride"] = 335.02, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 427.28, ["Mega|Ride"] = 576.19, ["Mega|Fly|Ride"] = 685.72}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 17.11, ["Ride"] = 13.98, ["Fly|Ride"] = 30.72, ["Neon"] = 12.58, ["Neon|Fly"] = 26.17, ["Neon|Ride"] = 24.01, ["Neon|Fly|Ride"] = 52.41, ["Mega"] = 103.59, ["Mega|Fly"] = 170.62, ["Mega|Ride"] = 120.96, ["Mega|Fly|Ride"] = 157.24}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 3.93, ["Fly"] = 41.27, ["Ride"] = 24.35, ["Fly|Ride"] = 66.94, ["Neon"] = 25.66, ["Neon|Fly"] = 55.86, ["Neon|Ride"] = 37.27, ["Neon|Fly|Ride"] = 112.03, ["Mega"] = 219.19, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 225.09, ["Mega|Fly|Ride"] = 282.18}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 22.23, ["Ride"] = 18.09, ["Fly|Ride"] = 65.63, ["Neon"] = 8.07, ["Neon|Fly"] = 35.61, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 70.16, ["Mega"] = 159.11, ["Mega|Fly"] = 170.63, ["Mega|Ride"] = 74.93, ["Mega|Fly|Ride"] = 127.32}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 6.57, ["Fly"] = 158.09, ["Ride"] = 19.69, ["Fly|Ride"] = 217.19, ["Neon"] = 26.25, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 279.54, ["Mega"] = 261.83, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 375.84, ["Mega|Fly|Ride"] = 418.76}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 6.49, ["Ride"] = 56.55, ["Neon"] = 74.76, ["Neon|Ride"] = 125.64, ["Mega"] = 682.5, ["Mega|Fly|Ride"] = 977.8}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 7.8, ["Fly"] = 41.89, ["Ride"] = 16.77, ["Fly|Ride"] = 44.82, ["Neon"] = 13.13, ["Neon|Fly"] = 196.76, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 111.64, ["Mega"] = 255.94, ["Mega|Ride"] = 324.55, ["Mega|Fly|Ride"] = 413.53}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 24.09, ["Ride"] = 13.6, ["Fly|Ride"] = 71.21, ["Neon"] = 16.23, ["Neon|Fly"] = 47.5, ["Neon|Ride"] = 35.61, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 237.47, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 202.13, ["Fly"] = 314.08, ["Ride"] = 299.28, ["Fly|Ride"] = 392.44, ["Neon"] = 1119.62, ["Neon|Ride"] = 1389.13, ["Neon|Fly|Ride"] = 1174.69, ["Mega|Fly|Ride"] = 4006.38}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.8, ["Ride"] = 109.51, ["Neon"] = 60.74, ["Neon|Ride"] = 140.3, ["Mega"] = 122.07, ["Mega|Ride"] = 420.6}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.1, ["Fly"] = 104.7, ["Ride"] = 21.53, ["Fly|Ride"] = 79.07, ["Neon"] = 22.41, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 204.65, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 6.37, ["Fly|Ride"] = 212.89, ["Neon"] = 36.63, ["Neon|Ride"] = 221.94, ["Neon|Fly|Ride"] = 603.74, ["Mega"] = 596.53, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 414.1}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 16.06, ["Ride"] = 13.86, ["Fly|Ride"] = 29.59, ["Neon"] = 2.1, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 18.86, ["Mega|Fly"] = 83.76, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 1.87, ["Fly"] = 23.68, ["Ride"] = 15.43, ["Fly|Ride"] = 112.03, ["Neon"] = 8.12, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 96.76, ["Mega"] = 104.87, ["Mega|Ride"] = 110.24, ["Mega|Fly|Ride"] = 220.66}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.1, ["Ride"] = 39.8, ["Neon"] = 10.44, ["Neon|Ride"] = 140.3, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 118.21, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 328.12}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 70.86, ["Fly"] = 112.03, ["Ride"] = 111.57, ["Fly|Ride"] = 167.51, ["Neon"] = 556.49, ["Neon|Ride"] = 372.83, ["Neon|Fly|Ride"] = 559.05, ["Mega"] = 2093.76, ["Mega|Ride"] = 3491.33, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 2.1, ["Fly"] = 98.42, ["Ride"] = 28.59, ["Fly|Ride"] = 141.75, ["Neon"] = 23, ["Neon|Ride"] = 62.33, ["Neon|Fly|Ride"] = 418.76, ["Mega"] = 157.49, ["Mega|Ride"] = 184.24, ["Mega|Fly|Ride"] = 564.27}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 48.18, ["Ride"] = 33.09, ["Neon"] = 6.56, ["Neon|Ride"] = 64.13, ["Neon|Fly|Ride"] = 533.11, ["Mega"] = 42, ["Mega|Fly"] = 314.99, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 48.88, ["Fly"] = 210, ["Ride"] = 96.15, ["Fly|Ride"] = 72.19, ["Neon"] = 131.24, ["Neon|Ride"] = 202.13, ["Neon|Fly|Ride"] = 279.54, ["Mega"] = 590.63, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 572.25}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 17.04, ["Ride"] = 12.33, ["Fly|Ride"] = 28.58, ["Neon"] = 2.1, ["Neon|Fly"] = 23.13, ["Neon|Ride"] = 14.79, ["Neon|Fly|Ride"] = 32.7, ["Mega"] = 18.86, ["Mega|Fly"] = 49.86, ["Mega|Ride"] = 34.12, ["Mega|Fly|Ride"] = 86.15}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 33.65, ["Neon"] = 3.84, ["Neon|Fly"] = 32.47, ["Neon|Ride"] = 29.12, ["Neon|Fly|Ride"] = 209.37, ["Mega"] = 20.57, ["Mega|Ride"] = 82.65, ["Mega|Fly|Ride"] = 175.87}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 52.53, ["Neon"] = 9.19, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 98.04, ["Neon|Fly|Ride"] = 159.11, ["Mega"] = 102.44, ["Mega|Fly"] = 182.17, ["Mega|Ride"] = 116.94, ["Mega|Fly|Ride"] = 232.55}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 4.44, ["Fly"] = 56.55, ["Ride"] = 37.69, ["Fly|Ride"] = 132.97, ["Neon"] = 15.74, ["Neon|Fly"] = 90.04, ["Neon|Ride"] = 77.86, ["Neon|Fly|Ride"] = 191.71, ["Mega"] = 103.35, ["Mega|Fly"] = 340.76, ["Mega|Ride"] = 190.35, ["Mega|Fly|Ride"] = 254.63}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 20.79, ["Ride"] = 12.5, ["Fly|Ride"] = 36.66, ["Neon"] = 2.1, ["Neon|Fly"] = 25.14, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 44.01, ["Mega"] = 17.07, ["Mega|Ride"] = 52.49, ["Mega|Fly|Ride"] = 118.12}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 17.07, ["Fly"] = 131.25, ["Ride"] = 70.16, ["Neon"] = 128.63, ["Neon|Fly"] = 418.76, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 530.78, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 642.79}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2610.57, ["Fly"] = 3150, ["Ride"] = 2493.75, ["Fly|Ride"] = 2493.75, ["Neon|Fly|Ride"] = 9631.23, ["Mega|Fly|Ride"] = 36640.5}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 1.79, ["Fly"] = 16.59, ["Ride"] = 14.16, ["Fly|Ride"] = 44.63, ["Neon"] = 8.44, ["Neon|Fly"] = 55.95, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 76.13, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 170.62}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 3.94, ["Neon"] = 4.38, ["Mega"] = 140.3, ["Mega|Fly"] = 441, ["Mega|Ride"] = 159.11, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 13, ["Fly"] = 112.03, ["Ride"] = 28.89, ["Fly|Ride"] = 70.16, ["Neon"] = 70.88, ["Neon|Ride"] = 103.79, ["Neon|Fly|Ride"] = 212.63, ["Mega"] = 367.5, ["Mega|Ride"] = 443.88, ["Mega|Fly|Ride"] = 628.14}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 28.19, ["Ride"] = 50.74, ["Neon"] = 161.44, ["Neon|Fly|Ride"] = 224.05, ["Mega"] = 641.46, ["Mega|Ride"] = 600.92, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 129.92, ["Fly"] = 1396.55, ["Ride"] = 189, ["Fly|Ride"] = 251.98, ["Neon"] = 768.42, ["Neon|Ride"] = 700.41, ["Neon|Fly|Ride"] = 715.32, ["Mega"] = 6281.24, ["Mega|Fly|Ride"] = 3768.19}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 3.7, ["Ride"] = 31.5, ["Fly|Ride"] = 675.94, ["Neon"] = 19.69, ["Neon|Ride"] = 140.3, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 156.19, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 308.84, ["Mega|Fly|Ride"] = 355.95}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 35.61, ["Fly|Ride"] = 70.16, ["Neon"] = 22.84, ["Neon|Ride"] = 114.85, ["Mega"] = 140.44, ["Mega|Ride"] = 333.27, ["Mega|Fly|Ride"] = 844.17}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 131.25, ["Neon"] = 6.46, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 140.3, ["Mega"] = 73.5, ["Mega|Ride"] = 99.1, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 9.18, ["Ride"] = 102.61, ["Neon"] = 180.07, ["Neon|Ride"] = 1190.87, ["Mega"] = 374.07, ["Mega|Ride"] = 463.78, ["Mega|Fly|Ride"] = 809.17}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 41.89, ["Neon"] = 2.1, ["Neon|Ride"] = 47.67, ["Mega"] = 18.86, ["Mega|Fly"] = 118.74, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 279.54}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 89.25, ["Fly"] = 159.14, ["Ride"] = 103.71, ["Fly|Ride"] = 159.11, ["Neon"] = 366.19, ["Neon|Ride"] = 401.06, ["Neon|Fly|Ride"] = 324.28, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 91.84, ["Neon"] = 10.28, ["Neon|Ride"] = 70.16, ["Neon|Fly|Ride"] = 209.39, ["Mega"] = 71.25, ["Mega|Ride"] = 278.49}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 36.74, ["Fly"] = 100.51, ["Ride"] = 74.68, ["Fly|Ride"] = 157.48, ["Neon"] = 278.11, ["Neon|Ride"] = 418.76, ["Neon|Fly|Ride"] = 321.57, ["Mega"] = 2625}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 61.79, ["Ride"] = 20.9, ["Fly|Ride"] = 51.07, ["Neon"] = 3.73, ["Neon|Fly"] = 87.44, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 41.97, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 180.07}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 3.94, ["Neon"] = 7.54, ["Neon|Ride"] = 98.44, ["Mega"] = 89.15, ["Mega|Ride"] = 152.36, ["Mega|Fly|Ride"] = 480.39}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 6.72, ["Fly"] = 77.43, ["Ride"] = 38.57, ["Fly|Ride"] = 209.39, ["Neon"] = 27.75, ["Neon|Ride"] = 120.41, ["Mega"] = 262.5, ["Mega|Ride"] = 288.74, ["Mega|Fly|Ride"] = 559.05}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 349.13, ["Ride"] = 402.93, ["Fly|Ride"] = 525.23, ["Neon"] = 1050, ["Neon|Ride"] = 964.66, ["Neon|Fly|Ride"] = 1144.5, ["Mega|Ride"] = 4187.5, ["Mega|Fly|Ride"] = 4187.5}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 28.28, ["Fly"] = 83.76, ["Ride"] = 52.5, ["Fly|Ride"] = 100.17, ["Neon"] = 187.02, ["Neon|Ride"] = 171.28, ["Neon|Fly|Ride"] = 287.96, ["Mega"] = 1394.45, ["Mega|Fly|Ride"] = 983.07}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 49.88, ["Ride"] = 18.15, ["Fly|Ride"] = 72.19, ["Neon"] = 10.26, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 23.77, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 119.55, ["Mega|Ride"] = 109.44, ["Mega|Fly|Ride"] = 265.93}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 13.11, ["Fly"] = 54.59, ["Ride"] = 43.98, ["Fly|Ride"] = 170.63, ["Neon"] = 68.25, ["Neon|Fly"] = 137.82, ["Neon|Ride"] = 72.16, ["Neon|Fly|Ride"] = 182.39, ["Mega"] = 326.7, ["Mega|Fly"] = 977.16, ["Mega|Ride"] = 379.95, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 6.57, ["Fly"] = 35.61, ["Ride"] = 20.77, ["Fly|Ride"] = 196.88, ["Neon"] = 141.35, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 269.54, ["Mega"] = 308.84, ["Mega|Ride"] = 320.36, ["Mega|Fly|Ride"] = 555.91}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 2.1, ["Neon"] = 14.25, ["Mega"] = 78.74, ["Mega|Fly"] = 157.4, ["Mega|Ride"] = 111.57, ["Mega|Fly|Ride"] = 295.23}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 20.89, ["Fly|Ride"] = 56.55, ["Neon"] = 41.91, ["Neon|Ride"] = 32.8, ["Neon|Fly|Ride"] = 279.54, ["Mega"] = 86.63, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 107.47, ["Ride"] = 118.13, ["Fly|Ride"] = 236.25, ["Neon"] = 775.39, ["Neon|Ride"] = 523.67, ["Neon|Fly|Ride"] = 568.5, ["Mega"] = 2887.5, ["Mega|Fly|Ride"] = 3008.6}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 28.28, ["Ride"] = 46.1, ["Fly|Ride"] = 91.87, ["Neon"] = 142.95, ["Neon|Ride"] = 209.39, ["Neon|Fly|Ride"] = 284.47, ["Mega"] = 1117.04, ["Mega|Ride"] = 837.51, ["Mega|Fly|Ride"] = 690.96}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 1995, ["Fly"] = 2030.44, ["Ride"] = 2060.63, ["Fly|Ride"] = 2085.57, ["Neon"] = 11167, ["Neon|Fly|Ride"] = 6424.69, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.1, ["Fly"] = 65625, ["Ride"] = 32.82, ["Neon"] = 18.18, ["Mega"] = 97.46, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 168.72, ["Mega|Fly|Ride"] = 459.5}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 6.93, ["Ride"] = 47.25, ["Neon"] = 25.9, ["Neon|Ride"] = 76.63, ["Neon|Fly|Ride"] = 232.38, ["Mega"] = 157.5, ["Mega|Ride"] = 335.02, ["Mega|Fly|Ride"] = 1046.89}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 1050, ["Fly"] = 948.54, ["Ride"] = 899.07, ["Fly|Ride"] = 971.25, ["Neon"] = 2778.57, ["Neon|Ride"] = 2611.88, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 12284.01, ["Mega|Fly|Ride"] = 11306.22}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 23.39, ["Ride"] = 52.49, ["Fly|Ride"] = 173.35, ["Neon"] = 176.82, ["Neon|Ride"] = 203.11, ["Neon|Fly|Ride"] = 375.2, ["Mega"] = 839.9, ["Mega|Ride"] = 804.56, ["Mega|Fly|Ride"] = 905.63}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.28, ["Ride"] = 23.61, ["Fly|Ride"] = 128.15, ["Neon"] = 19.69, ["Neon|Ride"] = 70.16, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 157.5, ["Mega|Ride"] = 265.93, ["Mega|Fly|Ride"] = 279.54}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.41, ["Ride"] = 140.3, ["Neon"] = 2.82, ["Neon|Ride"] = 48.92, ["Neon|Fly|Ride"] = 92.14, ["Mega"] = 19.69, ["Mega|Ride"] = 255.46, ["Mega|Fly|Ride"] = 279.54}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 87.86, ["Ride"] = 105, ["Fly|Ride"] = 170.63, ["Neon"] = 418.76, ["Neon|Ride"] = 593.65, ["Neon|Fly|Ride"] = 630, ["Mega"] = 2374.59, ["Mega|Fly|Ride"] = 2093.76}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.1, ["Fly|Ride"] = 73.7, ["Neon"] = 12.06, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 52.01, ["Neon|Fly|Ride"] = 159.11, ["Mega"] = 118.57, ["Mega|Ride"] = 111.57, ["Mega|Fly|Ride"] = 263.82}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 76.5, ["Ride"] = 102.38, ["Fly|Ride"] = 123.55, ["Neon"] = 393.75, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 514.03, ["Mega|Fly|Ride"] = 1777.6}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 3.86, ["Fly"] = 105, ["Fly|Ride"] = 125.64, ["Neon"] = 26.22, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 180.98, ["Mega|Ride"] = 308.84}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 232.16, ["Fly"] = 354.38, ["Ride"] = 280.27, ["Fly|Ride"] = 334.68, ["Neon"] = 1137.32, ["Neon|Ride"] = 1108.65, ["Neon|Fly|Ride"] = 879.03, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 2.1, ["Fly"] = 87.94, ["Ride"] = 19.45, ["Fly|Ride"] = 103.95, ["Neon"] = 30.96, ["Neon|Fly"] = 159.11, ["Neon|Ride"] = 57.2, ["Neon|Fly|Ride"] = 100.7, ["Mega"] = 368.08, ["Mega|Ride"] = 656.23}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 19.38, ["Ride"] = 14.53, ["Fly|Ride"] = 40.32, ["Neon"] = 5.38, ["Neon|Fly"] = 31.29, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 35.15, ["Mega"] = 39.38, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 124.42}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1187.17, ["Ride"] = 1050, ["Fly|Ride"] = 1187.58, ["Neon|Ride"] = 7677.76, ["Neon|Fly|Ride"] = 6281.24, ["Mega"] = 23270.88, ["Mega|Fly|Ride"] = 28487.82}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 10.48, ["Fly"] = 977.8, ["Ride"] = 72.19, ["Neon"] = 45.94, ["Neon|Ride"] = 131.92, ["Mega"] = 320.24, ["Mega|Ride"] = 381.07, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 4.48, ["Fly"] = 50.27, ["Ride"] = 46.48, ["Fly|Ride"] = 79.56, ["Neon"] = 15.54, ["Neon|Fly"] = 175.73, ["Neon|Ride"] = 52.86, ["Neon|Fly|Ride"] = 279.54, ["Mega"] = 170.63, ["Mega|Ride"] = 195.7, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 28.86, ["Fly"] = 39.38, ["Ride"] = 31.65, ["Fly|Ride"] = 40.69, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 190.32, ["Mega|Ride"] = 1108.94, ["Mega|Fly|Ride"] = 798}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 11.82, ["Fly"] = 83.76, ["Ride"] = 24.51, ["Fly|Ride"] = 85.32, ["Neon"] = 69.53, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 179.8, ["Mega"] = 367.5, ["Mega|Fly"] = 477.4, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 429.26}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 31.49, ["Ride"] = 111.64, ["Fly|Ride"] = 408.29, ["Neon"] = 183.26, ["Neon|Ride"] = 378, ["Neon|Fly|Ride"] = 528.94, ["Mega"] = 1050, ["Mega|Ride"] = 654.94, ["Mega|Fly|Ride"] = 586.26}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Fly|Ride"] = 118.77, ["Neon"] = 2.1, ["Neon|Ride"] = 111.62, ["Mega"] = 15.75, ["Mega|Ride"] = 83.54, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 52.5, ["Fly"] = 123.55, ["Ride"] = 72.15, ["Fly|Ride"] = 112.22, ["Neon"] = 446.24, ["Neon|Ride"] = 393.74, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 3350, ["Mega|Ride"] = 1723.16, ["Mega|Fly|Ride"] = 1591.25}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 107.62, ["Ride"] = 18.8, ["Fly|Ride"] = 70.88, ["Neon"] = 65.63, ["Neon|Ride"] = 110.98, ["Neon|Fly|Ride"] = 167.51, ["Mega"] = 773.06, ["Mega|Ride"] = 396.57}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 20.95, ["Ride"] = 15.65, ["Fly|Ride"] = 36.02, ["Neon"] = 17.26, ["Neon|Fly"] = 83.76, ["Neon|Ride"] = 56.55, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 275.07, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 3.93, ["Ride"] = 126, ["Neon"] = 16.03, ["Neon|Fly"] = 138.21, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 195.78, ["Mega"] = 374.79, ["Mega|Fly|Ride"] = 474.93}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 61.79, ["Ride"] = 77.48, ["Fly|Ride"] = 262.5, ["Neon"] = 287.44, ["Neon|Ride"] = 282.19, ["Neon|Fly|Ride"] = 555.91, ["Mega|Ride"] = 1360.95, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 7.7, ["Fly|Ride"] = 418.76, ["Neon"] = 16.67, ["Mega"] = 123.38, ["Mega|Ride"] = 125.64, ["Mega|Fly|Ride"] = 317.03}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 33.52, ["Neon"] = 2.1, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 15.75, ["Mega|Ride"] = 40.28, ["Mega|Fly|Ride"] = 523.45}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.94, ["Ride"] = 35.26, ["Fly|Ride"] = 58.9, ["Neon"] = 3.67, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 125.64, ["Mega"] = 18.26, ["Mega|Ride"] = 52.19, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 31.42, ["Ride"] = 19.69, ["Fly|Ride"] = 52.5, ["Neon"] = 7.27, ["Neon|Ride"] = 28.07, ["Neon|Fly|Ride"] = 84.32, ["Mega"] = 61.69, ["Mega|Ride"] = 78.74, ["Mega|Fly|Ride"] = 182.27}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 112.03, ["Neon"] = 39.38, ["Mega"] = 118.09, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 38.05, ["Ride"] = 15.14, ["Fly|Ride"] = 32.37, ["Neon"] = 15.72, ["Neon|Fly"] = 209.39, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 144.38, ["Mega|Ride"] = 166.46, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 56.38, ["Ride"] = 91.62, ["Fly|Ride"] = 265.93, ["Neon"] = 196.88, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 1046.89, ["Mega"] = 694.32, ["Mega|Ride"] = 1046.89, ["Mega|Fly|Ride"] = 1108.94}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 14.48, ["Fly|Ride"] = 31.17, ["Neon"] = 4.2, ["Neon|Fly"] = 23.05, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 47.86, ["Mega"] = 19.69, ["Mega|Ride"] = 22.74, ["Mega|Fly|Ride"] = 65.63}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 7.39, ["Fly"] = 129.93, ["Ride"] = 25.88, ["Fly|Ride"] = 57.1, ["Neon"] = 35.44, ["Neon|Fly"] = 87.28, ["Neon|Ride"] = 47.57, ["Neon|Fly|Ride"] = 123.57, ["Mega"] = 362.5, ["Mega|Fly"] = 285.06, ["Mega|Ride"] = 202.82, ["Mega|Fly|Ride"] = 308.43}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 15.35, ["Fly"] = 47.52, ["Ride"] = 26.25, ["Fly|Ride"] = 84.69, ["Neon"] = 125.64, ["Neon|Fly"] = 174.49, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 182.43, ["Mega"] = 787.5, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 621.02}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 5.13, ["Fly"] = 196.88, ["Neon"] = 52.31, ["Mega"] = 366.19, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 418.76}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 14.94, ["Fly|Ride"] = 37.71, ["Neon"] = 3.94, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 17.74, ["Neon|Fly|Ride"] = 58.46, ["Mega"] = 44.08, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 117.47}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 2.84, ["Fly"] = 71.44, ["Ride"] = 38.07, ["Neon"] = 22.46, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 206.05, ["Mega"] = 209.39, ["Mega|Fly"] = 735, ["Mega|Ride"] = 224.05, ["Mega|Fly|Ride"] = 391.54}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 1050, ["Fly"] = 1377.58, ["Ride"] = 1050, ["Fly|Ride"] = 1099.88, ["Neon|Ride"] = 2744.43, ["Neon|Fly|Ride"] = 2362.4, ["Mega|Fly|Ride"] = 7087.5}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 104.79, ["Ride"] = 183.22, ["Fly|Ride"] = 411.99, ["Neon"] = 627.09, ["Neon|Ride"] = 628.68, ["Neon|Fly|Ride"] = 820.31, ["Mega"] = 3139.58, ["Mega|Fly|Ride"] = 2353.38}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly"] = 56.55, ["Ride"] = 39.38, ["Neon"] = 5.93, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 204.15, ["Mega"] = 89.25, ["Mega|Fly|Ride"] = 1117.04}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 68.23, ["Ride"] = 129.93, ["Fly|Ride"] = 229.69, ["Neon"] = 392.42, ["Neon|Fly"] = 446.25, ["Neon|Ride"] = 406.86, ["Neon|Fly|Ride"] = 630, ["Mega"] = 1836.19, ["Mega|Ride"] = 1796.82, ["Mega|Fly|Ride"] = 1728.67}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.76, ["Ride"] = 20.95, ["Fly|Ride"] = 91.09, ["Neon"] = 14, ["Neon|Fly"] = 55.82, ["Neon|Ride"] = 49.45, ["Neon|Fly|Ride"] = 279.54, ["Mega"] = 280.32, ["Mega|Ride"] = 349.19, ["Mega|Fly|Ride"] = 405.15}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 223.13, ["Fly"] = 418.76, ["Ride"] = 271.69, ["Fly|Ride"] = 375.84, ["Neon|Ride"] = 1195.55, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 4592.64}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 76.4, ["Ride"] = 40.85, ["Fly|Ride"] = 219.66, ["Neon"] = 31.49, ["Neon|Fly"] = 35.61, ["Neon|Ride"] = 54.37, ["Mega"] = 414.58, ["Mega|Fly"] = 326.64, ["Mega|Ride"] = 634.04}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Fly"] = 28.28, ["Neon"] = 28.6, ["Mega"] = 335.02, ["Mega|Ride"] = 359.09}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 21.56, ["Ride"] = 72.1, ["Fly|Ride"] = 150.81, ["Neon"] = 110.49, ["Neon|Ride"] = 124.69, ["Mega"] = 641.16, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.73, ["Neon"] = 25.24, ["Neon|Ride"] = 140.3, ["Mega"] = 237.47, ["Mega|Ride"] = 253.31, ["Mega|Fly|Ride"] = 464.24}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 16.77, ["Ride"] = 14.44, ["Fly|Ride"] = 39.36, ["Neon"] = 2.63, ["Neon|Fly"] = 23.63, ["Neon|Ride"] = 15.72, ["Neon|Fly|Ride"] = 28.5, ["Mega"] = 27.24, ["Mega|Ride"] = 42.75, ["Mega|Fly|Ride"] = 80.63}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4828.02, ["Ride"] = 5130.57, ["Fly|Ride"] = 4929.75, ["Neon"] = 31406.15, ["Neon|Fly|Ride"] = 19293.75, ["Mega|Fly|Ride"] = 130858.9}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 7.34, ["Fly"] = 83.76, ["Ride"] = 41.57, ["Neon"] = 52.5, ["Neon|Ride"] = 105, ["Mega"] = 278.49, ["Mega|Ride"] = 215.25, ["Mega|Fly|Ride"] = 418.76}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.69, ["Ride"] = 16.52, ["Fly|Ride"] = 33.5, ["Neon"] = 13.36, ["Neon|Fly"] = 45.91, ["Neon|Ride"] = 34.17, ["Neon|Fly|Ride"] = 63, ["Mega"] = 124.69, ["Mega|Ride"] = 176.06, ["Mega|Fly|Ride"] = 236.61}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 432.94, ["Fly"] = 547.77, ["Ride"] = 515.15, ["Fly|Ride"] = 551.25, ["Neon"] = 1612.22, ["Neon|Ride"] = 1519.44, ["Neon|Fly|Ride"] = 1500.65, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 5.38, ["Ride"] = 32.62, ["Neon"] = 19.23, ["Neon|Ride"] = 291.38, ["Mega"] = 140.6, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.83, ["Fly"] = 4187.5, ["Ride"] = 65.62, ["Neon"] = 23.63, ["Neon|Ride"] = 45.13, ["Mega"] = 1137.97, ["Mega|Ride"] = 401.62, ["Mega|Fly|Ride"] = 820.98}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 18.53, ["Neon"] = 3.28, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 23.29, ["Neon|Fly|Ride"] = 91.74, ["Mega"] = 37.97, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 222.04}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 643.09, ["Ride"] = 735, ["Fly|Ride"] = 780.94, ["Neon|Ride"] = 2784.7, ["Neon|Fly|Ride"] = 2480.62, ["Mega|Fly|Ride"] = 9073.25}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 4.86, ["Fly"] = 294.53, ["Ride"] = 51.39, ["Fly|Ride"] = 418.76, ["Neon"] = 26.42, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 284.96, ["Mega"] = 168.92, ["Mega|Ride"] = 229.04, ["Mega|Fly|Ride"] = 388.5}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 5.11, ["Fly"] = 236.15, ["Ride"] = 31.07, ["Fly|Ride"] = 111.62, ["Neon"] = 22.97, ["Neon|Ride"] = 51.36, ["Neon|Fly|Ride"] = 144.35, ["Mega"] = 353.64, ["Mega|Fly"] = 791.94, ["Mega|Ride"] = 214.17, ["Mega|Fly|Ride"] = 265.13}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.12, ["Ride"] = 16.67, ["Fly|Ride"] = 58.43, ["Neon"] = 11.54, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 31.4, ["Neon|Fly|Ride"] = 81.36, ["Mega"] = 279.54, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 202.84}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 17.57, ["Ride"] = 34.12, ["Fly|Ride"] = 55.49, ["Neon"] = 117.58, ["Neon|Ride"] = 70.16, ["Neon|Fly|Ride"] = 314.08, ["Mega|Ride"] = 452.81, ["Mega|Fly|Ride"] = 977.8}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 42.88, ["Fly|Ride"] = 83.76, ["Neon"] = 6.22, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 57.75, ["Mega|Fly"] = 166.23, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 225.99}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 616.87, ["Ride"] = 538.12, ["Fly|Ride"] = 628.14, ["Neon"] = 2589.57, ["Neon|Fly|Ride"] = 2391.38, ["Mega|Ride"] = 9260.87, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 76.2, ["Fly|Ride"] = 131.25, ["Neon"] = 15.74, ["Neon|Ride"] = 85.34, ["Neon|Fly|Ride"] = 474.93, ["Mega"] = 170.63, ["Mega|Ride"] = 164.06, ["Mega|Fly|Ride"] = 509.25}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 27.56, ["Neon"] = 6.3, ["Neon|Fly"] = 104.7, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 209.39, ["Mega"] = 87.88, ["Mega|Fly|Ride"] = 355.95}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 40.82, ["Neon"] = 3.94, ["Neon|Ride"] = 45.48, ["Neon|Fly|Ride"] = 209.39, ["Mega"] = 39.38, ["Mega|Fly"] = 154.95, ["Mega|Ride"] = 103.22, ["Mega|Fly|Ride"] = 145.68}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 28.65, ["Neon"] = 37.8, ["Mega"] = 209.39, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 29.25, ["Fly"] = 98.44, ["Ride"] = 50.3, ["Fly|Ride"] = 498.74, ["Neon"] = 131.25, ["Neon|Fly"] = 140.3, ["Neon|Ride"] = 137.23, ["Neon|Fly|Ride"] = 279.54, ["Mega"] = 918.75, ["Mega|Ride"] = 544.69, ["Mega|Fly|Ride"] = 561.99}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 14.82, ["Ride"] = 48.38, ["Fly|Ride"] = 128.99, ["Neon"] = 81.79, ["Neon|Ride"] = 125.98, ["Neon|Fly|Ride"] = 279.54, ["Mega"] = 492.18, ["Mega|Ride"] = 448.08, ["Mega|Fly|Ride"] = 560.44}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 20.79, ["Ride"] = 16.52, ["Fly|Ride"] = 32.82, ["Neon"] = 28.28, ["Neon|Ride"] = 32.05, ["Neon|Fly|Ride"] = 85.86, ["Mega"] = 255.29, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 249.17}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 10.19, ["Ride"] = 32.47, ["Fly|Ride"] = 121.45, ["Neon"] = 54.46, ["Neon|Ride"] = 138.21, ["Mega|Ride"] = 727.59}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 26.16, ["Fly|Ride"] = 87.18, ["Neon"] = 10.29, ["Neon|Ride"] = 40.74, ["Neon|Fly|Ride"] = 112.03, ["Mega"] = 75.03, ["Mega|Ride"] = 115.49, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 15.42, ["Fly"] = 64.14, ["Ride"] = 19.69, ["Fly|Ride"] = 61.9, ["Neon"] = 418.76, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 189.67, ["Mega"] = 787.5, ["Mega|Fly|Ride"] = 824.95}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 23.65, ["Fly"] = 874.13, ["Neon"] = 133.77, ["Mega"] = 451.22, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 495.48}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 49.44, ["Fly"] = 115.4, ["Ride"] = 81.18, ["Fly|Ride"] = 160.13, ["Neon"] = 297.94, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 397.83, ["Mega|Ride"] = 1678.85, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 35.34, ["Fly"] = 83.76, ["Ride"] = 76.74, ["Fly|Ride"] = 204.15, ["Neon"] = 144.35, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 396.78, ["Mega"] = 584.06, ["Mega|Ride"] = 607.6, ["Mega|Fly|Ride"] = 618.78}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 16.67, ["Ride"] = 64.32, ["Neon"] = 131.14, ["Mega"] = 1049.99, ["Mega|Ride"] = 791.94}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 8.88, ["Fly"] = 418.76, ["Ride"] = 32.21, ["Fly|Ride"] = 192.94, ["Neon"] = 129.34, ["Neon|Fly"] = 420, ["Neon|Ride"] = 139.78, ["Neon|Fly|Ride"] = 159.11, ["Mega"] = 464.37, ["Mega|Ride"] = 474.93, ["Mega|Fly|Ride"] = 634.51}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.91, ["Ride"] = 15.26, ["Fly|Ride"] = 32.73, ["Neon"] = 6.3, ["Neon|Fly"] = 27.36, ["Neon|Ride"] = 29.02, ["Neon|Fly|Ride"] = 45.97, ["Mega"] = 40.48, ["Mega|Fly"] = 329.78, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 145.04}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1890}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 44.12, ["Ride"] = 95.18, ["Fly|Ride"] = 418.76, ["Neon"] = 345.19, ["Neon|Ride"] = 363.27, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1535.78, ["Mega|Ride"] = 1461.45, ["Mega|Fly|Ride"] = 1299.38}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 79.74, ["Neon"] = 2.6, ["Neon|Ride"] = 43.19, ["Neon|Fly|Ride"] = 284.96, ["Mega"] = 30.02, ["Mega|Ride"] = 84.94}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 19.99, ["Ride"] = 52.5, ["Fly|Ride"] = 160.48, ["Neon"] = 156.19, ["Neon|Ride"] = 133.94, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 519.74, ["Mega|Ride"] = 791.94, ["Mega|Fly|Ride"] = 686.82}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 15.75, ["Mega"] = 22.91}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 39.38, ["Mega"] = 21.58, ["Mega|Ride"] = 149.62}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 97.55, ["Fly"] = 223.13, ["Ride"] = 147, ["Fly|Ride"] = 301.59, ["Neon"] = 446.25, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 656.25, ["Mega|Ride"] = 6530.11, ["Mega|Fly|Ride"] = 2098.69}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 21.09, ["Fly|Ride"] = 94.99, ["Neon"] = 4.23, ["Neon|Ride"] = 23.77, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 90.17, ["Mega|Ride"] = 115.63, ["Mega|Fly|Ride"] = 279.54}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 70.16, ["Fly|Ride"] = 51.45, ["Neon"] = 2.68, ["Neon|Ride"] = 25.6, ["Neon|Fly|Ride"] = 140.3, ["Mega"] = 34.12, ["Mega|Ride"] = 125.64, ["Mega|Fly|Ride"] = 277.85}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 61.74, ["Neon"] = 6.26, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 207.38, ["Mega"] = 76.12, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 245.44}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 82.69, ["Neon"] = 6.15, ["Neon|Ride"] = 155.91, ["Mega"] = 59.06, ["Mega|Ride"] = 209.39}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 60.39, ["Ride"] = 135.19, ["Fly|Ride"] = 448.08, ["Neon"] = 424.07, ["Neon|Ride"] = 479.34, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2024.66, ["Mega|Ride"] = 1570.33, ["Mega|Fly|Ride"] = 1570.33}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 5.25, ["Ride"] = 65.97, ["Neon"] = 39.36, ["Neon|Ride"] = 227.07, ["Mega"] = 474.93, ["Mega|Ride"] = 950.06}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 1.79}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 1.79}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 347.08, ["Ride"] = 328.13, ["Fly|Ride"] = 508.17, ["Neon"] = 1115.63, ["Neon|Ride"] = 1396.55, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4013.05}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 1.79}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 86.63}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 47.23}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 26.21}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 15.75}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 65}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 104.32}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 13.12}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 6.19}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 262.48}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 26.16}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 1.79}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 32.71}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 6.99}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 6.3}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 213.59}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 6.4}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 5.32}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 3.94}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 9.83}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 12.17}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 561.75}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 1.79}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 1.79}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 1.79}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 788.55}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 7.92}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1029.11}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 57.75}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 8.78}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 1.79}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 31.94}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.36}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.44}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 4.77}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 24.44}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 34.09}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 46.69}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 17.73}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 10.91}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 17.75}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 4.6}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 18.36}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.1}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 18.05}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 140.07}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 3.6}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 2068.5}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 1.79}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 28.25}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 1.79}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 307.92}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 7.18}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 1.82}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 6.67}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 6.04}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 49.54}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 193.17}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 6.57}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 8.37}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 1181.25}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 23.63}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 2.25}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 21.94}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 8.04}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 3.94}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 219.85}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 30.87}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 8.3}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 21.72}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 10.39}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 9.52}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 26.24}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 87.41}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 222.99}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 6.21}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 131.15}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.92}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 72.22}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 20.9}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 1.79}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.63}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22563.57}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 317.22}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 44.59}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 78.75}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 26.25}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 45.03}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 39.38}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 81.38}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 78.75}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 43.32}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 56.55}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 138.66}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 54.56}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 7014.05}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 1.79}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 233.37}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 7.16}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 6.11}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 3.29}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 32.08}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 118.12}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.15}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 5.14}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 1.87}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 2.1}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 12.78}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 355.95}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 945}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 1.79}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 10.13}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 583.68}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 15.47}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.62}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.62}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 213.59}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 17.07}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 171.7}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 19.09}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 20.79}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 47.57}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 14.11}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.6}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 1.79}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 8.4}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 5.25}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 4.34}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 28.88}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.1}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 1.79}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.94}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.14}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 26.17}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 282.05}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 52.06}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 1.93}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 1.79}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 1.79}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 628.14}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 10.22}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 6.29}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 3.93}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 25.66}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 15.6}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 4.5}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 8.6}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 2.15}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 12.1}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 23.63}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 14.85}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 4.52}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 4.03}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 6.56}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 7.87}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 1.79}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 1.79}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 5.39}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 5.97}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.62}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.45}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.63}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.71}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 1.79}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 8305.89}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 20.31}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.96}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 8.49}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 6.45}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.14}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 18.59}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 2.59}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.43}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 1.79}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 1.79}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 30.19}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 7.14}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.82}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 4.97}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.56}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 1.79}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 1.79}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4187.5}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 8.44}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 1.79}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 26.91}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 6.37}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 2.96}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 64.61}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 3.15}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 2.1}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 97.55}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 1.79}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 14.18}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 3.23}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 2.1}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 7.7}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 25.1}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.62}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.55}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.59}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 15.71}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 1.79}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 1.79}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.72}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.33}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.37}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.81}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.23}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 3.6}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 28.85}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 3.92}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 1.79}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 8.59}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 104.99}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.53}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 62.72}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 3.61}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 10.48}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1097.06}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 1.79}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 31.49}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 2.67}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 1.79}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 18.64}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 27.16}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.75}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 6.57}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 10.87}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 15.54}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 14.81}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 6.13}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.59}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 8.12}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 4.35}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 20.55}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.15}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 7.33}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 3.94}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 19.91}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 51.87}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 3.85}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 3.94}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 32.51}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 85.31}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 6.65}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 5.18}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 48.56}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 6.02}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 33.95}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 4.5}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 4.6}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 3.89}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 1.79}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 6.09}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 74.43}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 144.03}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 6.92}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1422.71}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 4.4}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 183.73}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.35}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 21.52}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 54.73}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 6.28}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 3.94}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.46}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 67.54}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 18.59}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 8.65}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 6.07}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 61.97}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 3.26}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 62.62}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 3.15}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.63}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.63}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 22.32}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 144.34}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 76.04}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 8.54}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 4.34}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 17.83}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 57.74}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 53.43}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 66.94}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 210}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.6}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 54.22}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 120.56}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.15}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 3.55}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 8.81}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 28.75}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 66.68}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.93}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 61.66}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.61}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 2.37}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 65.63}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 20.9}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 62.26}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 33.18}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2.96}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 73.32}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 44.83}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.5}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 26.11}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.93}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 13}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 65.01}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 1.79}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 33.37}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 82.63}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1878.11}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 9.19}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 6.19}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 22.68}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 335.02}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 17.95}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 18.86}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 11.02}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 11.38}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 9.57}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 318.83}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 52.29}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 51.21}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 4.28}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 62.35}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 165.42}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 62.87}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1117.04}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 151.17}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 7.88}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2361.19}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 551.24}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 3.14}},
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