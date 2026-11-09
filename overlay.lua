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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1070.65, ["Ride"] = 1193.07, ["Fly|Ride"] = 1598.59, ["Neon"] = 6607.79, ["Neon|Fly|Ride"] = 3921.75, ["Mega|Fly|Ride"] = 25143.57}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 416.62, ["Fly"] = 544.79, ["Ride"] = 396.38, ["Fly|Ride"] = 471.19, ["Neon|Ride"] = 2198.44, ["Neon|Fly|Ride"] = 2072.44, ["Mega|Fly|Ride"] = 8234.75}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4725, ["Ride"] = 4935, ["Fly|Ride"] = 4987.5, ["Neon"] = 25823.18, ["Neon|Fly|Ride"] = 21394.86, ["Mega|Fly|Ride"] = 66294.44}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 116.82, ["Ride"] = 140.3, ["Fly|Ride"] = 260.96, ["Neon"] = 731.78, ["Neon|Ride"] = 761.1, ["Neon|Fly|Ride"] = 786.95, ["Mega"] = 3768.29, ["Mega|Fly|Ride"] = 2831.58}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 618.64, ["Fly"] = 656.4, ["Ride"] = 538.13, ["Fly|Ride"] = 538.13, ["Neon|Ride"] = 1704.94, ["Neon|Fly|Ride"] = 1530.38, ["Mega|Fly|Ride"] = 6300}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 9.19, ["Ride"] = 31.5, ["Fly|Ride"] = 140.3, ["Neon"] = 73.38, ["Neon|Fly"] = 125.64, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 279.49, ["Mega"] = 275.13, ["Mega|Ride"] = 471.72, ["Mega|Fly|Ride"] = 414.52}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.67, ["Fly"] = 28.67, ["Ride"] = 27.36, ["Fly|Ride"] = 73.27, ["Neon"] = 27.98, ["Neon|Fly"] = 107.48, ["Neon|Ride"] = 58.68, ["Neon|Fly|Ride"] = 119.37, ["Mega"] = 194.23, ["Mega|Fly"] = 273.74, ["Mega|Ride"] = 195.76, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 127.32, ["Fly"] = 195.78, ["Ride"] = 160.77, ["Fly|Ride"] = 178.5, ["Neon"] = 488.25, ["Neon|Ride"] = 140.28, ["Neon|Fly|Ride"] = 627.01, ["Mega"] = 1887.73, ["Mega|Fly|Ride"] = 2093.51}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 31.85, ["Fly"] = 141.32, ["Ride"] = 56.35, ["Fly|Ride"] = 74.82, ["Neon"] = 223.13, ["Neon|Ride"] = 198.19, ["Neon|Fly|Ride"] = 251.23, ["Mega"] = 2100, ["Mega|Ride"] = 2730, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 24.1, ["Fly"] = 45.03, ["Ride"] = 32.79, ["Fly|Ride"] = 76.13, ["Neon"] = 138.21, ["Neon|Ride"] = 192.62, ["Neon|Fly|Ride"] = 209.77, ["Mega|Ride"] = 752.62, ["Mega|Fly|Ride"] = 582.75}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 59.07, ["Ride"] = 71.22, ["Fly|Ride"] = 127.14, ["Neon"] = 342.35, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 315.03, ["Mega|Ride"] = 1396.38, ["Mega|Fly|Ride"] = 1480.12}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 102.36}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 376.85, ["Fly"] = 405.15, ["Ride"] = 393.75, ["Fly|Ride"] = 441, ["Neon"] = 1270.91, ["Neon|Ride"] = 1674.8, ["Neon|Fly|Ride"] = 1498.95, ["Mega|Fly|Ride"] = 8373.96}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 118.13, ["Fly"] = 130.03, ["Ride"] = 112.18, ["Fly|Ride"] = 138.21, ["Neon|Ride"] = 564.38, ["Neon|Fly|Ride"] = 643.13, ["Mega|Fly|Ride"] = 2613.19}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.39, ["Fly"] = 116.22, ["Ride"] = 24.09, ["Fly|Ride"] = 209.39, ["Neon"] = 23.62, ["Neon|Ride"] = 65.63, ["Mega"] = 129.07, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 349.63}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 158.1, ["Fly"] = 186.36, ["Ride"] = 140.28, ["Fly|Ride"] = 189, ["Neon"] = 698.29, ["Neon|Ride"] = 628.14, ["Neon|Fly|Ride"] = 584.07, ["Mega|Fly|Ride"] = 1903}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.26, ["Fly"] = 27.16, ["Ride"] = 19.69, ["Fly|Ride"] = 40.14, ["Neon"] = 27.24, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 334.69, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 305.82}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 65.56, ["Fly"] = 262.5, ["Ride"] = 94.5, ["Fly|Ride"] = 236.61, ["Neon"] = 157.5, ["Neon|Ride"] = 170.61, ["Neon|Fly|Ride"] = 413.02, ["Mega"] = 1393.24, ["Mega|Ride"] = 838.22, ["Mega|Fly|Ride"] = 864.94}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 39.37}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 77.44, ["Ride"] = 196.88, ["Fly|Ride"] = 337.98, ["Neon"] = 787.5, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 1570.13}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 13.09, ["Fly"] = 374.07, ["Ride"] = 26.17, ["Fly|Ride"] = 104.7, ["Neon"] = 140.3, ["Neon|Ride"] = 343.98, ["Neon|Fly|Ride"] = 182.15, ["Mega"] = 698.2, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 1674.8}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 39.38, ["Fly"] = 64.3, ["Ride"] = 43.32, ["Fly|Ride"] = 110.93, ["Neon"] = 336, ["Neon|Fly"] = 311.98, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 262.29, ["Mega"] = 1651.76, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 39.38, ["Fly"] = 105, ["Ride"] = 155.76, ["Fly|Ride"] = 138.21, ["Neon"] = 204.75, ["Neon|Fly"] = 391.75, ["Neon|Ride"] = 279.54, ["Neon|Fly|Ride"] = 312.99, ["Mega"] = 1234.12, ["Mega|Ride"] = 1251.92, ["Mega|Fly|Ride"] = 1256.11}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 40.69, ["Fly"] = 63.73, ["Ride"] = 57.75, ["Fly|Ride"] = 131.25, ["Neon"] = 192.64, ["Neon|Ride"] = 279.49, ["Neon|Fly|Ride"] = 287.07, ["Mega"] = 1207.92, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 65.63, ["Fly"] = 587.65, ["Ride"] = 78.75, ["Fly|Ride"] = 135.19, ["Neon"] = 276.13, ["Neon|Ride"] = 309.69, ["Mega|Ride"] = 979.58, ["Mega|Fly|Ride"] = 943.69}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 3.77, ["Fly"] = 41.92, ["Ride"] = 17.07, ["Fly|Ride"] = 47.18, ["Neon"] = 36.09, ["Neon|Fly"] = 58.65, ["Neon|Ride"] = 42.82, ["Neon|Fly|Ride"] = 102.21, ["Mega"] = 135.19, ["Mega|Fly"] = 188.79, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 263.61}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 341.25, ["Ride"] = 352.87, ["Fly|Ride"] = 362.25, ["Neon"] = 1475.25, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1605.72, ["Mega"] = 10467.44, ["Mega|Fly|Ride"] = 7306.28}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 18.38, ["Ride"] = 31.42, ["Fly|Ride"] = 105.18, ["Neon"] = 217.88, ["Neon|Ride"] = 405.11, ["Neon|Fly|Ride"] = 418.71, ["Mega"] = 823.8, ["Mega|Ride"] = 707.9, ["Mega|Fly|Ride"] = 823.8}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 3.71, ["Fly"] = 38.67, ["Ride"] = 20.94, ["Fly|Ride"] = 53.86, ["Neon"] = 52.5, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 104.68, ["Mega|Ride"] = 619.5, ["Mega|Fly|Ride"] = 394.08}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 100.99, ["Fly"] = 140.3, ["Ride"] = 105.96, ["Fly|Ride"] = 157.5, ["Neon"] = 375.84, ["Neon|Ride"] = 308.84, ["Neon|Fly|Ride"] = 440.91, ["Mega"] = 1932.3, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 1905.08}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 14.05, ["Ride"] = 26.25, ["Fly|Ride"] = 115.5, ["Neon"] = 138.21, ["Neon|Ride"] = 132.97, ["Neon|Fly|Ride"] = 158.81, ["Mega"] = 707.9, ["Mega|Fly|Ride"] = 677.23}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 183.75, ["Fly"] = 362.25, ["Ride"] = 223.79, ["Fly|Ride"] = 319.78, ["Neon"] = 646.97, ["Neon|Ride"] = 836.36, ["Neon|Fly|Ride"] = 773.07, ["Mega"] = 6280.47, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2859.15}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 31.03}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.54, ["Fly"] = 33.52, ["Ride"] = 23.05, ["Fly|Ride"] = 60.75, ["Neon"] = 22.32, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 47.2, ["Neon|Fly|Ride"] = 150.74, ["Mega"] = 131.23, ["Mega|Fly"] = 283.18, ["Mega|Ride"] = 203.11, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 1240.32, ["Fly"] = 4593.75, ["Ride"] = 1050, ["Fly|Ride"] = 1443.75, ["Neon"] = 5862.49, ["Neon|Ride"] = 5643.75, ["Neon|Fly|Ride"] = 4593.75, ["Mega"] = 20212.5, ["Mega|Ride"] = 53091.88, ["Mega|Fly|Ride"] = 15213.37}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 9.06, ["Fly"] = 28.28, ["Ride"] = 27.24, ["Fly|Ride"] = 87.94, ["Neon"] = 107.84, ["Neon|Ride"] = 138.21, ["Neon|Fly|Ride"] = 141.59, ["Mega"] = 341.25, ["Mega|Ride"] = 615.49, ["Mega|Fly|Ride"] = 656.48}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 106.32, ["Ride"] = 143.47, ["Fly|Ride"] = 259.64, ["Neon"] = 656.25, ["Neon|Ride"] = 682.5, ["Neon|Fly|Ride"] = 787.5, ["Mega|Ride"] = 2720.49, ["Mega|Fly|Ride"] = 2719.45}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 43.14}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 36.75, ["Fly"] = 68.85, ["Ride"] = 55.13, ["Fly|Ride"] = 140.3, ["Neon"] = 104, ["Neon|Ride"] = 206.07, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 682.5, ["Mega|Ride"] = 723.19, ["Mega|Fly|Ride"] = 739.76}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.37}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 107.63, ["Ride"] = 162.28, ["Fly|Ride"] = 209.39, ["Neon"] = 525, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 628.06, ["Mega|Fly|Ride"] = 2362.5}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 129.92, ["Ride"] = 140.3, ["Fly|Ride"] = 196.88, ["Neon"] = 328.13, ["Neon|Ride"] = 366.18, ["Neon|Fly|Ride"] = 640.5, ["Mega"] = 1575, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1415.86}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 45.94}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 70.88, ["Fly"] = 93.19, ["Ride"] = 59.07, ["Fly|Ride"] = 77.42, ["Neon"] = 355.95, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 240.82, ["Mega"] = 4187, ["Mega|Fly|Ride"] = 1509.38}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 6.24, ["Ride"] = 30.19, ["Fly|Ride"] = 52.5, ["Neon"] = 52.5, ["Neon|Ride"] = 70.19, ["Neon|Fly|Ride"] = 233.44, ["Mega"] = 209.36, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 244.13, ["Mega|Fly|Ride"] = 349.8}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 380.61, ["Fly"] = 420, ["Ride"] = 393.75, ["Fly|Ride"] = 432.63, ["Neon|Ride"] = 1800.42, ["Neon|Fly|Ride"] = 1274.31, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 78.75, ["Fly"] = 99.75, ["Ride"] = 94.5, ["Fly|Ride"] = 140.3, ["Neon"] = 372.78, ["Neon|Ride"] = 375.8, ["Neon|Fly|Ride"] = 369.02, ["Mega"] = 2791.68, ["Mega|Ride"] = 1870.55, ["Mega|Fly|Ride"] = 1912.41}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3185.44, ["Fly"] = 3543.75, ["Ride"] = 3433.5, ["Fly|Ride"] = 3017.44, ["Neon|Fly|Ride"] = 14653.37}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 39.26, ["Fly"] = 112.03, ["Ride"] = 45.94, ["Fly|Ride"] = 95.82, ["Neon"] = 279.54, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 209.36, ["Mega|Ride"] = 1192.26, ["Mega|Fly|Ride"] = 2233.76}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 67.6, ["Ride"] = 66.09, ["Fly|Ride"] = 189, ["Neon"] = 418.76, ["Neon|Ride"] = 785.75, ["Neon|Fly|Ride"] = 558.97, ["Mega"] = 6280.47, ["Mega|Fly|Ride"] = 1808.79}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 38.06, ["Fly"] = 52.5, ["Ride"] = 70.75, ["Fly|Ride"] = 137.24, ["Neon"] = 235.99, ["Neon|Ride"] = 194.25, ["Neon|Fly|Ride"] = 209.73, ["Mega"] = 2598.75, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 8.93}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 56.44, ["Ride"] = 56.39, ["Fly|Ride"] = 116.22, ["Neon"] = 328.13, ["Neon|Ride"] = 349.63, ["Neon|Fly|Ride"] = 501.38, ["Mega|Ride"] = 1396.38, ["Mega|Fly|Ride"] = 1258.89}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 41.89}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 188.57, ["Fly"] = 308.84, ["Ride"] = 251.27, ["Fly|Ride"] = 313.03, ["Neon|Ride"] = 1396.38, ["Neon|Fly|Ride"] = 1594.6}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 918.75, ["Ride"] = 955.5, ["Fly|Ride"] = 853.13, ["Neon|Ride"] = 3350, ["Neon|Fly|Ride"] = 3675, ["Mega|Fly|Ride"] = 11812.5}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 5.23}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 26.17, ["Fly"] = 52.43, ["Ride"] = 48.19, ["Fly|Ride"] = 62.99, ["Neon"] = 162.75, ["Neon|Fly"] = 209.39, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 208.69, ["Mega|Fly|Ride"] = 765.19}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 11.82}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 4331.25, ["Fly"] = 5974.52, ["Ride"] = 6281.24, ["Fly|Ride"] = 4442.82, ["Neon|Fly|Ride"] = 10500, ["Mega|Fly|Ride"] = 40460.82}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 14.41, ["Fly"] = 74.64, ["Ride"] = 26.25, ["Fly|Ride"] = 65.63, ["Neon"] = 90.57, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 137.43, ["Mega"] = 483, ["Mega|Ride"] = 584.03, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 14.17, ["Fly"] = 191.66, ["Ride"] = 30.08, ["Fly|Ride"] = 116.84, ["Neon"] = 85.32, ["Neon|Ride"] = 118.12, ["Neon|Fly|Ride"] = 231, ["Mega"] = 1046.76, ["Mega|Ride"] = 556.88, ["Mega|Fly|Ride"] = 938.95}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 56.55, ["Fly"] = 139.21, ["Ride"] = 85.93, ["Fly|Ride"] = 125.64, ["Neon"] = 1396.55, ["Neon|Fly|Ride"] = 420, ["Mega"] = 4187}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 12.81, ["Ride"] = 28.88, ["Fly|Ride"] = 139.65, ["Neon"] = 77.88, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 461.63, ["Mega"] = 363.24, ["Mega|Ride"] = 417.03, ["Mega|Fly|Ride"] = 488.84}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 2126.25, ["Fly"] = 3071.16, ["Ride"] = 2510.42, ["Fly|Ride"] = 2073.75, ["Neon|Fly|Ride"] = 4593.75, ["Mega|Fly|Ride"] = 15079.32}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 33495.79, ["Fly"] = 35241.86, ["Ride"] = 34614.12, ["Fly|Ride"] = 22916.25, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 64611.75, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 195392.4}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 16.77, ["Fly"] = 393.75, ["Ride"] = 42, ["Fly|Ride"] = 110.92, ["Neon"] = 282.19, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 279.49, ["Mega"] = 837.41, ["Mega|Ride"] = 1102.5, ["Mega|Fly|Ride"] = 1397.82}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.49, ["Ride"] = 41.89, ["Fly|Ride"] = 104.7, ["Neon"] = 18.38, ["Neon|Fly"] = 134.39, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 152.84, ["Mega"] = 138.26, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 20.88}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.88, ["Ride"] = 41.89, ["Fly|Ride"] = 111.57, ["Neon"] = 61.69, ["Neon|Ride"] = 105.25, ["Neon|Fly|Ride"] = 463.32, ["Mega"] = 370.55, ["Mega|Ride"] = 471.95, ["Mega|Fly|Ride"] = 545.35}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 787.5, ["Ride"] = 741.57, ["Fly|Ride"] = 779.63, ["Neon"] = 2990.04, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2620.02, ["Mega|Fly|Ride"] = 11012.45}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 979.34, ["Fly"] = 900.38, ["Ride"] = 918.75, ["Fly|Ride"] = 984.38, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 3071.25, ["Mega|Fly|Ride"] = 11304.84}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 17.71, ["Fly"] = 72.19, ["Ride"] = 44.86, ["Fly|Ride"] = 78.75, ["Neon"] = 161.23, ["Neon|Ride"] = 192.94, ["Neon|Fly|Ride"] = 220.5, ["Mega"] = 971.04, ["Mega|Ride"] = 682.5, ["Mega|Fly|Ride"] = 698.2}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 19.67}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 70.14, ["Fly"] = 78.75, ["Ride"] = 116.22, ["Fly|Ride"] = 140.3, ["Neon|Ride"] = 418.76, ["Neon|Fly|Ride"] = 412.13, ["Mega|Ride"] = 1704.12, ["Mega|Fly|Ride"] = 1598.63}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 63.31, ["Ride"] = 81.38, ["Fly|Ride"] = 131.25, ["Neon"] = 391.54, ["Neon|Fly"] = 389.45, ["Neon|Ride"] = 630.04, ["Neon|Fly|Ride"] = 502.45, ["Mega"] = 1610.95, ["Mega|Fly|Ride"] = 1661.19}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.24, ["Fly"] = 32.79, ["Ride"] = 20.79, ["Fly|Ride"] = 53.82, ["Neon"] = 28.88, ["Neon|Fly"] = 315.05, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 140.28, ["Mega"] = 236.25, ["Mega|Ride"] = 397.78, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 85.32, ["Fly"] = 96.93, ["Ride"] = 98.43, ["Fly|Ride"] = 131.25, ["Neon"] = 808.2, ["Neon|Ride"] = 284.82, ["Neon|Fly|Ride"] = 328.13, ["Mega|Fly|Ride"] = 1054.49}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.34, ["Ride"] = 44.63, ["Fly|Ride"] = 262.5, ["Neon"] = 23.63, ["Neon|Ride"] = 98.41, ["Mega"] = 171.93, ["Mega|Fly"] = 977.67, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 387.19}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 16.79, ["Fly"] = 40.3, ["Ride"] = 32.82, ["Fly|Ride"] = 99.47, ["Neon"] = 72.19, ["Neon|Fly"] = 126.27, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 209.36, ["Mega"] = 740.07, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 24.64, ["Ride"] = 69.14, ["Fly|Ride"] = 156.19, ["Neon"] = 215.66, ["Neon|Ride"] = 183.2, ["Mega"] = 707.49, ["Mega|Ride"] = 1161.57, ["Mega|Fly|Ride"] = 837.41}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 17.03, ["Fly"] = 77.33, ["Ride"] = 36.75, ["Fly|Ride"] = 82.69, ["Neon"] = 70.16, ["Neon|Fly"] = 559.05, ["Neon|Ride"] = 120.41, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 1046.76, ["Mega|Ride"] = 922.2, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6280.47, ["Ride"] = 6864.38, ["Fly|Ride"] = 5118.74, ["Neon"] = 34921.69, ["Neon|Fly|Ride"] = 24075.11}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 245.58, ["Fly"] = 315.05, ["Ride"] = 244.13, ["Fly|Ride"] = 262.5, ["Neon"] = 656.4, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 573.91, ["Mega|Fly|Ride"] = 2098.69}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 29.32, ["Fly"] = 110.93, ["Ride"] = 71.28, ["Fly|Ride"] = 123.13, ["Neon"] = 77.88, ["Neon|Fly"] = 158.12, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 195.57, ["Mega"] = 302.91, ["Mega|Fly"] = 383.13, ["Mega|Ride"] = 312.45, ["Mega|Fly|Ride"] = 406.86}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.37, ["Fly"] = 41.89, ["Ride"] = 24.1, ["Fly|Ride"] = 90.04, ["Neon"] = 27.24, ["Neon|Ride"] = 56.55, ["Neon|Fly|Ride"] = 94.4, ["Mega"] = 173.78}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 36.63, ["Fly"] = 5285.8, ["Ride"] = 94.35, ["Fly|Ride"] = 118, ["Neon"] = 105, ["Neon|Fly"] = 309.89, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 244.95, ["Mega"] = 418.68, ["Mega|Ride"] = 449.06, ["Mega|Fly|Ride"] = 523.64}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 12810, ["Ride"] = 12468.75, ["Fly|Ride"] = 10303.13, ["Neon|Fly|Ride"] = 23625, ["Mega|Fly|Ride"] = 89722.64}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 157.12, ["Ride"] = 195.78, ["Fly|Ride"] = 278.49, ["Neon"] = 1158.91, ["Neon|Ride"] = 1187.02, ["Neon|Fly|Ride"] = 1158.76, ["Mega|Fly|Ride"] = 4745.94}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 47.16, ["Fly"] = 459.38, ["Ride"] = 60.29, ["Fly|Ride"] = 107.49, ["Neon|Fly"] = 471.99, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 279.49, ["Mega|Fly|Ride"] = 2026.5}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 11.42, ["Fly"] = 44.86, ["Ride"] = 27.24, ["Fly|Ride"] = 65.63, ["Neon"] = 65.63, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 86.61, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 2512.2, ["Mega|Fly|Ride"] = 418.76}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 389.82, ["Fly"] = 837.51, ["Ride"] = 444.94, ["Fly|Ride"] = 525, ["Neon"] = 1639.31, ["Neon|Ride"] = 1311.19, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Ride"] = 4724.98, ["Mega|Fly|Ride"] = 4935}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 8.81, ["Fly"] = 87.33, ["Ride"] = 25.14, ["Neon"] = 27.56, ["Neon|Ride"] = 77.47, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 144.56, ["Mega|Ride"] = 203.46, ["Mega|Fly|Ride"] = 279.49}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 163.31, ["Fly"] = 393.75, ["Ride"] = 210, ["Fly|Ride"] = 301.88, ["Neon"] = 771.74, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 853.13, ["Mega"] = 3243.87, ["Mega|Ride"] = 3461.61, ["Mega|Fly|Ride"] = 2884.88}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.18, ["Fly"] = 20.96, ["Ride"] = 20.84, ["Fly|Ride"] = 34.13, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 101.58, ["Mega"] = 2512.2, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 9.17}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 61.69, ["Ride"] = 70.16, ["Fly|Ride"] = 525, ["Neon"] = 321.41, ["Neon|Fly"] = 1675.01, ["Neon|Ride"] = 434.42, ["Neon|Fly|Ride"] = 484.65, ["Mega"] = 1396.38, ["Mega|Ride"] = 1415.8, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 14.34, ["Ride"] = 36.66, ["Fly|Ride"] = 68.25, ["Neon"] = 70.82, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 235.98, ["Mega"] = 475.23, ["Mega|Ride"] = 488.84, ["Mega|Fly|Ride"] = 600.85}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 15.75}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 28.3, ["Fly"] = 111.57, ["Ride"] = 65.63, ["Fly|Ride"] = 220.67, ["Neon"] = 173.79, ["Neon|Ride"] = 226.11, ["Neon|Fly|Ride"] = 313.17, ["Mega"] = 774.61, ["Mega|Ride"] = 768.33, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.89, ["Ride"] = 41.89, ["Fly|Ride"] = 131.25, ["Neon"] = 30.17, ["Neon|Ride"] = 106.21, ["Neon|Fly|Ride"] = 127.72, ["Mega"] = 126.26, ["Mega|Fly|Ride"] = 639.85}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 13.13, ["Fly"] = 70.16, ["Ride"] = 24.1, ["Fly|Ride"] = 74.82, ["Neon"] = 41.89, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 224.01, ["Mega"] = 697.15, ["Mega|Ride"] = 473.15, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 347.82, ["Fly"] = 502.51, ["Ride"] = 354.38, ["Fly|Ride"] = 409.5, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 7676.83}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 47.21, ["Ride"] = 55.44, ["Fly|Ride"] = 103.67, ["Neon"] = 182.44, ["Neon|Ride"] = 140.28, ["Neon|Fly|Ride"] = 252.5, ["Mega"] = 718.83, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 750.39}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 52.41, ["Fly"] = 83.76, ["Ride"] = 51.19, ["Fly|Ride"] = 167.51, ["Neon"] = 188.68, ["Neon|Ride"] = 198.96, ["Neon|Fly|Ride"] = 630, ["Mega"] = 1258.89, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1147.25}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 32.01, ["Fly"] = 81.38, ["Ride"] = 78.73, ["Fly|Ride"] = 131.25, ["Neon"] = 93.19, ["Neon|Ride"] = 154.95, ["Neon|Fly|Ride"] = 210, ["Mega"] = 393.75, ["Mega|Ride"] = 405.57, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 9843.75, ["Ride"] = 13529.42, ["Fly|Ride"] = 7612.5, ["Neon|Fly|Ride"] = 14424.38, ["Mega|Fly|Ride"] = 39372.9}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1706.25, ["Fly"] = 1575, ["Ride"] = 1750.01, ["Fly|Ride"] = 1745.63, ["Neon"] = 6135.8, ["Neon|Fly|Ride"] = 4200, ["Mega|Fly|Ride"] = 24281.25}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 391.13, ["Ride"] = 464.16, ["Fly|Ride"] = 459.38, ["Neon"] = 2095.7, ["Neon|Fly|Ride"] = 2067.34, ["Mega"] = 11798.2, ["Mega|Fly|Ride"] = 6671.96}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 15.7, ["Fly"] = 30.37, ["Ride"] = 19.69, ["Fly|Ride"] = 41.89, ["Neon"] = 125.64, ["Neon|Ride"] = 104.69, ["Neon|Fly|Ride"] = 105, ["Mega|Fly|Ride"] = 471.95}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 4.5, ["Fly"] = 45.94, ["Ride"] = 41.32, ["Fly|Ride"] = 124.64, ["Neon"] = 34.13, ["Neon|Ride"] = 61.38, ["Neon|Fly|Ride"] = 157.47, ["Mega"] = 154.88, ["Mega|Ride"] = 200.82, ["Mega|Fly|Ride"] = 315.03}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 28.28, ["Fly"] = 34.23, ["Ride"] = 55.13, ["Fly|Ride"] = 100.9, ["Neon"] = 186.36, ["Neon|Ride"] = 138.21, ["Neon|Fly|Ride"] = 182.46, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.03, ["Fly"] = 28.28, ["Ride"] = 18.38, ["Fly|Ride"] = 39.38, ["Neon"] = 23.71, ["Neon|Fly"] = 63.68, ["Neon|Ride"] = 56.55, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 393.75, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 295.8, ["Fly"] = 320.25, ["Ride"] = 313.85, ["Fly|Ride"] = 341.25, ["Neon|Ride"] = 1769.75, ["Neon|Fly|Ride"] = 1689.45, ["Mega|Fly|Ride"] = 7327.22}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 24.94, ["Fly"] = 48.19, ["Ride"] = 35.62, ["Fly|Ride"] = 70.16, ["Neon"] = 83.76, ["Neon|Fly"] = 167.51, ["Neon|Ride"] = 140.34, ["Neon|Fly|Ride"] = 221.92, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 594.64}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 9.19, ["Fly"] = 20.95, ["Ride"] = 20.95, ["Fly|Ride"] = 47.14, ["Neon"] = 140.3, ["Neon|Fly"] = 134.52, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 115.77, ["Mega"] = 523.39, ["Mega|Ride"] = 576.77, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 392.44, ["Fly"] = 787.5, ["Ride"] = 446.25, ["Fly|Ride"] = 472, ["Neon|Ride"] = 2721.89, ["Mega|Fly|Ride"] = 9436.21}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1049.99, ["Fly"] = 1396.38, ["Ride"] = 1173.24, ["Fly|Ride"] = 1099.88, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 17060.89}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 110.92, ["Fly"] = 120.41, ["Ride"] = 98.44, ["Fly|Ride"] = 118.22, ["Neon"] = 971.25, ["Neon|Ride"] = 398.11, ["Neon|Fly|Ride"] = 422.63, ["Mega|Fly|Ride"] = 2099.99}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 140.28, ["Fly"] = 225.39, ["Ride"] = 183.75, ["Fly|Ride"] = 223.13, ["Neon"] = 698.29, ["Neon|Fly"] = 670.02, ["Neon|Ride"] = 737.51, ["Neon|Fly|Ride"] = 525, ["Mega"] = 5583.35, ["Mega|Ride"] = 8596.88, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 24.94, ["Fly"] = 131.25, ["Ride"] = 41.99, ["Fly|Ride"] = 279.54, ["Neon"] = 196.88, ["Neon|Fly"] = 418.76, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 363.24, ["Mega|Ride"] = 1815.07, ["Mega|Fly|Ride"] = 894.98}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 149.86, ["Ride"] = 209.36, ["Fly|Ride"] = 597.19, ["Neon|Fly|Ride"] = 1392.2, ["Mega|Fly|Ride"] = 2953.11}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2052.74, ["Ride"] = 2483.25, ["Fly|Ride"] = 2649.65, ["Neon|Fly|Ride"] = 7115.77, ["Mega|Fly|Ride"] = 48150.19}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 69.09, ["Ride"] = 51.48, ["Fly|Ride"] = 196.88, ["Neon"] = 287.9, ["Neon|Fly"] = 293.14, ["Neon|Fly|Ride"] = 414.75, ["Mega"] = 2087.23, ["Mega|Ride"] = 2302.84, ["Mega|Fly|Ride"] = 1887.73}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 656.24, ["Fly"] = 675.94, ["Ride"] = 601.13, ["Fly|Ride"] = 628.68, ["Neon|Ride"] = 1266.57, ["Neon|Fly|Ride"] = 1244.34, ["Mega|Fly|Ride"] = 3084.27}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 51.19, ["Fly"] = 60.38, ["Ride"] = 61.68, ["Fly|Ride"] = 102.38, ["Neon"] = 196.88, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 195.76, ["Mega|Fly|Ride"] = 1179.3}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 2.63, ["Fly"] = 31.55, ["Ride"] = 20.89, ["Fly|Ride"] = 40.14, ["Neon"] = 26.25, ["Neon|Fly"] = 54.46, ["Neon|Ride"] = 45.05, ["Neon|Fly|Ride"] = 94.47, ["Mega"] = 141.75, ["Mega|Fly"] = 249.14, ["Mega|Ride"] = 180.89, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 44.86, ["Ride"] = 72.19, ["Fly|Ride"] = 137.82, ["Neon"] = 140.3, ["Neon|Ride"] = 262.71, ["Neon|Fly|Ride"] = 522.34, ["Mega|Ride"] = 1396.38, ["Mega|Fly|Ride"] = 824.2}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 523.69, ["Fly"] = 899.07, ["Ride"] = 525, ["Fly|Ride"] = 620.12, ["Neon"] = 2373.28, ["Neon|Ride"] = 1837.5, ["Neon|Fly|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 6861.75}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 498.75, ["Ride"] = 577.5, ["Fly|Ride"] = 627.09, ["Neon"] = 5234.37, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 12585.15}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 13.65, ["Fly"] = 27.2, ["Ride"] = 23.63, ["Fly|Ride"] = 46.87, ["Neon"] = 209.39, ["Neon|Ride"] = 100.51, ["Neon|Fly|Ride"] = 117.99, ["Mega|Fly|Ride"] = 630.04}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 7.3, ["Ride"] = 22.32, ["Fly|Ride"] = 53.17, ["Neon"] = 45.94, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 127.72, ["Mega"] = 1674.8, ["Mega|Ride"] = 443.1, ["Mega|Fly|Ride"] = 627.01}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.76, ["Ride"] = 39.37, ["Fly|Ride"] = 110.25, ["Neon"] = 20.94, ["Neon|Fly"] = 78.91, ["Neon|Ride"] = 64.92, ["Neon|Fly|Ride"] = 98.48, ["Mega"] = 203.44, ["Mega|Fly"] = 456.6, ["Mega|Ride"] = 207.26, ["Mega|Fly|Ride"] = 330.75}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 38.06, ["Fly"] = 70.14, ["Ride"] = 44.94, ["Fly|Ride"] = 90.56, ["Neon"] = 191.59, ["Neon|Ride"] = 207.31, ["Neon|Fly|Ride"] = 178.5, ["Mega|Fly|Ride"] = 917.34}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 39.34, ["Ride"] = 111.57, ["Fly|Ride"] = 1047.52, ["Neon"] = 263.83, ["Neon|Ride"] = 401.44, ["Neon|Fly|Ride"] = 394.08, ["Mega"] = 1535.59, ["Mega|Ride"] = 1535.59, ["Mega|Fly|Ride"] = 1258.89}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 15.72, ["Fly"] = 65.63, ["Ride"] = 41.88, ["Fly|Ride"] = 78.75, ["Neon"] = 110.92, ["Neon|Fly"] = 149.86, ["Neon|Ride"] = 108.91, ["Neon|Fly|Ride"] = 196.77, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 30.15, ["Fly"] = 65.05, ["Ride"] = 45.94, ["Fly|Ride"] = 89.2, ["Neon"] = 405.15, ["Neon|Ride"] = 195.88, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1179.84}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.78, ["Fly"] = 21, ["Ride"] = 18.12, ["Fly|Ride"] = 39.38, ["Neon"] = 28.62, ["Neon|Ride"] = 37.72, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 262.5, ["Mega|Ride"] = 209.36, ["Mega|Fly|Ride"] = 405.36}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 3.78, ["Fly"] = 26.25, ["Ride"] = 26.98, ["Fly|Ride"] = 67.24, ["Neon"] = 26.17, ["Neon|Fly"] = 158.12, ["Neon|Ride"] = 49.22, ["Neon|Fly|Ride"] = 188.79, ["Mega"] = 261.92, ["Mega|Fly"] = 475.23, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 523.95}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 52.5, ["Fly"] = 60.38, ["Ride"] = 55.47, ["Fly|Ride"] = 98.48, ["Neon"] = 576.84, ["Neon|Ride"] = 246.03, ["Neon|Fly|Ride"] = 223.13, ["Mega|Fly|Ride"] = 918.99}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1956.99, ["Fly"] = 2197.13, ["Ride"] = 1820.43, ["Fly|Ride"] = 1824.38, ["Neon"] = 3281.25, ["Neon|Ride"] = 5233.33, ["Neon|Fly|Ride"] = 3916.5, ["Mega|Fly|Ride"] = 14235.73}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 456.75, ["Fly"] = 550.6, ["Ride"] = 507.23, ["Fly|Ride"] = 530.78, ["Neon"] = 3146.84, ["Neon|Ride"] = 3071.16, ["Neon|Fly|Ride"] = 2233.76, ["Mega|Fly|Ride"] = 9615.39}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 209.45, ["Fly"] = 418.71, ["Ride"] = 277.27, ["Fly|Ride"] = 392.44, ["Neon"] = 1155, ["Neon|Ride"] = 1179.94, ["Neon|Fly|Ride"] = 1559.66, ["Mega"] = 7327.22, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 48.57}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 28.02, ["Fly"] = 65.63, ["Ride"] = 74.7, ["Fly|Ride"] = 112.24, ["Neon"] = 208.46, ["Neon|Ride"] = 250.3, ["Neon|Fly|Ride"] = 314.05, ["Mega|Ride"] = 833.22, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 33495.79, ["Fly"] = 23625, ["Ride"] = 34781.25, ["Fly|Ride"] = 14240.63, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 354.38, ["Fly"] = 420, ["Ride"] = 374.07, ["Fly|Ride"] = 439.69, ["Neon"] = 1195.69, ["Neon|Fly"] = 1603.41, ["Neon|Ride"] = 1234.12, ["Neon|Fly|Ride"] = 1076.25, ["Mega"] = 6280.47, ["Mega|Ride"] = 6607, ["Mega|Fly|Ride"] = 4035.11}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 171.93, ["Fly"] = 140.3, ["Ride"] = 136.49, ["Fly|Ride"] = 141.62, ["Neon|Fly|Ride"] = 1046.76, ["Mega|Fly|Ride"] = 4187}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 103.69, ["Fly"] = 279.54, ["Ride"] = 122.07, ["Fly|Ride"] = 140.3, ["Neon"] = 705.64, ["Neon|Ride"] = 837.41, ["Neon|Fly|Ride"] = 795.54, ["Mega"] = 13957.29, ["Mega|Fly|Ride"] = 5233.73}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 17.07, ["Fly"] = 65.97, ["Ride"] = 33.52, ["Fly|Ride"] = 116.22, ["Neon"] = 266.44, ["Neon|Ride"] = 135.19, ["Neon|Fly|Ride"] = 263.8, ["Mega"] = 698.2, ["Mega|Ride"] = 518.15}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 5191.36, ["Ride"] = 4697.33, ["Fly|Ride"] = 4025.95, ["Neon|Ride"] = 16749.95, ["Neon|Fly|Ride"] = 17446.08, ["Mega|Fly|Ride"] = 71178.55}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 28.29, ["Fly"] = 45.04, ["Ride"] = 28.29, ["Fly|Ride"] = 63.73, ["Neon"] = 333.94, ["Neon|Ride"] = 209.36, ["Neon|Fly|Ride"] = 204.24, ["Mega|Fly|Ride"] = 752.62}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 38.04, ["Fly"] = 140.28, ["Ride"] = 43.32, ["Fly|Ride"] = 60.38, ["Neon"] = 228.93, ["Neon|Fly"] = 1396.55, ["Neon|Ride"] = 209.36, ["Neon|Fly|Ride"] = 217.73, ["Mega"] = 1573.89, ["Mega|Fly|Ride"] = 1087.58}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 564.38, ["Fly"] = 603.75, ["Ride"] = 630, ["Fly|Ride"] = 681.19, ["Neon"] = 1706.25, ["Neon|Ride"] = 1683.47, ["Neon|Fly|Ride"] = 1540.88, ["Mega|Fly|Ride"] = 5249.99}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 15.73, ["Fly"] = 28.28, ["Ride"] = 19.69, ["Fly|Ride"] = 52.47, ["Neon"] = 98.44, ["Neon|Fly"] = 158.12, ["Neon|Ride"] = 107.62, ["Neon|Fly|Ride"] = 129.03, ["Mega"] = 768.33, ["Mega|Fly|Ride"] = 523.68}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 18.38, ["Ride"] = 39.38, ["Neon"] = 91.88, ["Neon|Ride"] = 192.33, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 413.48, ["Mega|Ride"] = 558.97}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 91.77, ["Ride"] = 125.64, ["Fly|Ride"] = 245.44, ["Neon"] = 670.02, ["Neon|Ride"] = 418.71, ["Neon|Fly|Ride"] = 707.9, ["Mega|Fly|Ride"] = 4719.29}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 22.36, ["Fly"] = 106.21, ["Ride"] = 77.35, ["Fly|Ride"] = 152.81, ["Neon"] = 102.38, ["Neon|Fly"] = 188.45, ["Neon|Ride"] = 136.9, ["Neon|Fly|Ride"] = 334.97, ["Mega"] = 292.69, ["Mega|Fly"] = 807.19, ["Mega|Ride"] = 346.5, ["Mega|Fly|Ride"] = 501.38}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3399.38, ["Fly"] = 5128.01, ["Ride"] = 3583.12, ["Fly|Ride"] = 3478.13, ["Neon|Ride"] = 11611.91, ["Neon|Fly|Ride"] = 8373.75, ["Mega"] = 62804.6, ["Mega|Fly|Ride"] = 32799.71}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 39.38, ["Fly"] = 115.5, ["Ride"] = 125.64, ["Fly|Ride"] = 140.34, ["Neon"] = 313.89, ["Neon|Ride"] = 209.39, ["Neon|Fly|Ride"] = 412.95, ["Mega|Ride"] = 878.24, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 6234.38, ["Fly"] = 7398.25, ["Ride"] = 7677.76, ["Fly|Ride"] = 6230.44, ["Neon|Fly|Ride"] = 17271.28, ["Mega|Fly|Ride"] = 62804.6}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.35, ["Fly"] = 20.94, ["Ride"] = 19.67, ["Fly|Ride"] = 32.82, ["Neon"] = 18.38, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 85.97, ["Mega"] = 321.36, ["Mega|Fly|Ride"] = 258.56}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 17.07, ["Fly"] = 26.25, ["Ride"] = 31.49, ["Fly|Ride"] = 49.22, ["Neon"] = 209.39, ["Neon|Ride"] = 558.97, ["Neon|Fly|Ride"] = 140.28, ["Mega|Ride"] = 1444.42, ["Mega|Fly|Ride"] = 927.94}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.91}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 11.75, ["Ride"] = 39.38, ["Fly|Ride"] = 83.76, ["Neon"] = 158.13, ["Neon|Ride"] = 138.18, ["Neon|Fly|Ride"] = 235.53, ["Mega"] = 1049.9, ["Mega|Ride"] = 975.58, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 26.25, ["Fly"] = 262.5, ["Ride"] = 52.5, ["Fly|Ride"] = 140.3, ["Neon"] = 154.95, ["Neon|Ride"] = 120.49, ["Neon|Fly|Ride"] = 278.44, ["Mega"] = 840, ["Mega|Ride"] = 943.88, ["Mega|Fly|Ride"] = 931.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 15.72, ["Fly"] = 26.17, ["Ride"] = 22.32, ["Fly|Ride"] = 39.11, ["Neon|Ride"] = 112.02, ["Neon|Fly|Ride"] = 167.49, ["Mega"] = 2512.2, ["Mega|Ride"] = 588.75, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8332.09}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2716.11}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 20.79}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 160.81, ["Fly"] = 174.57, ["Ride"] = 189, ["Fly|Ride"] = 203.11, ["Neon|Fly|Ride"] = 1116.89, ["Mega|Fly|Ride"] = 5506.24}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 20.94, ["Fly"] = 131.92, ["Ride"] = 39.38, ["Fly|Ride"] = 315.07, ["Neon"] = 102.64, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 261.7, ["Mega|Ride"] = 896.67, ["Mega|Fly|Ride"] = 698.25}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 11.01}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.03, ["Ride"] = 26.25, ["Neon|Ride"] = 70.16, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2572.5}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 186.35, ["Ride"] = 199.49, ["Fly|Ride"] = 433.06, ["Neon"] = 748.13, ["Neon|Ride"] = 918.75, ["Mega|Ride"] = 3476.25, ["Mega|Fly|Ride"] = 3468.93}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 127.32, ["Ride"] = 183.75, ["Fly|Ride"] = 393.75, ["Neon"] = 668.92, ["Neon|Ride"] = 418.71, ["Neon|Fly|Ride"] = 768.33, ["Mega"] = 2493.75, ["Mega|Ride"] = 2778.57, ["Mega|Fly|Ride"] = 2387.44}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 140.28, ["Fly"] = 209.39, ["Ride"] = 157.5, ["Fly|Ride"] = 196.88, ["Neon"] = 799.32, ["Neon|Ride"] = 840, ["Neon|Fly|Ride"] = 842.03, ["Mega"] = 4605.68, ["Mega|Fly|Ride"] = 3493.88}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1506.75, ["Fly"] = 2512.51, ["Ride"] = 984.38, ["Fly|Ride"] = 1314.2, ["Neon"] = 5304.51, ["Neon|Ride"] = 5756.05, ["Neon|Fly|Ride"] = 4462.5, ["Mega|Fly|Ride"] = 25121.85}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 16.76, ["Fly"] = 81.67, ["Ride"] = 39.38, ["Fly|Ride"] = 86.63, ["Neon"] = 127.3, ["Neon|Ride"] = 297.33, ["Neon|Fly|Ride"] = 315.03, ["Mega"] = 836.36, ["Mega|Fly|Ride"] = 975.58}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 590.63, ["Fly"] = 2100, ["Ride"] = 759.84, ["Fly|Ride"] = 698.29, ["Neon|Fly|Ride"] = 2930.9}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 60.38}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 11.81, ["Ride"] = 43.32, ["Fly|Ride"] = 131.25, ["Neon"] = 99.75, ["Neon|Ride"] = 140.28, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 393.62, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 863.64}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 9.45, ["Fly"] = 131.25, ["Ride"] = 28.28, ["Fly|Ride"] = 94.5, ["Neon"] = 72.19, ["Neon|Ride"] = 83.61, ["Neon|Fly|Ride"] = 236.58, ["Mega"] = 918.75, ["Mega|Ride"] = 485.63, ["Mega|Fly|Ride"] = 558.97}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 84}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 21, ["Fly"] = 108.92, ["Ride"] = 31.21, ["Fly|Ride"] = 70.16, ["Neon"] = 196.88, ["Neon|Ride"] = 158.07, ["Neon|Fly|Ride"] = 550.99, ["Mega|Fly|Ride"] = 1445.75}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 31.5, ["Fly"] = 55.47, ["Ride"] = 34.13, ["Fly|Ride"] = 61.69, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 278.25, ["Neon|Fly|Ride"] = 336, ["Mega"] = 952.13, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6103.13, ["Fly"] = 10500, ["Ride"] = 5495.44, ["Fly|Ride"] = 4803.75, ["Neon|Ride"] = 17448.21, ["Neon|Fly|Ride"] = 10078.69, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 9.08, ["Fly"] = 34.13, ["Ride"] = 26.25, ["Fly|Ride"] = 82.69, ["Neon"] = 47.2, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 315.03, ["Mega"] = 528.59, ["Mega|Ride"] = 445.93, ["Mega|Fly|Ride"] = 349.63}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 20.98}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 108.94, ["Fly"] = 370.6, ["Ride"] = 131.25, ["Fly|Ride"] = 231.38, ["Neon"] = 418.69, ["Neon|Ride"] = 481.69, ["Neon|Fly|Ride"] = 558.97, ["Mega|Fly|Ride"] = 2094.26}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 81.33, ["Ride"] = 98.42, ["Fly|Ride"] = 153.57, ["Neon"] = 327.6, ["Neon|Ride"] = 418.89, ["Neon|Fly|Ride"] = 511.88, ["Mega"] = 2359.66, ["Mega|Ride"] = 2826.23}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 20.94, ["Fly"] = 72.19, ["Ride"] = 28.3, ["Fly|Ride"] = 75.51, ["Neon"] = 196.88, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 179.33, ["Mega|Ride"] = 866, ["Mega|Fly|Ride"] = 656.22}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 3.59, ["Fly"] = 49.87, ["Ride"] = 29.89, ["Fly|Ride"] = 78.75, ["Neon"] = 23.61, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 57.84, ["Neon|Fly|Ride"] = 165.4, ["Mega"] = 131.14, ["Mega|Fly"] = 6984.62, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 266.44}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 12.58, ["Fly"] = 74.7, ["Ride"] = 26.25, ["Fly|Ride"] = 79.08, ["Neon"] = 92.19, ["Neon|Ride"] = 82.69, ["Neon|Fly|Ride"] = 276.35, ["Mega"] = 395.69, ["Mega|Ride"] = 410.82, ["Mega|Fly|Ride"] = 544.69}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 20.95, ["Fly"] = 28.28, ["Ride"] = 28.34, ["Fly|Ride"] = 42, ["Neon"] = 208.71, ["Neon|Ride"] = 138.96, ["Neon|Fly|Ride"] = 137.82, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 196.87}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 26.25, ["Ride"] = 126.27, ["Neon"] = 189.67, ["Mega"] = 1026.86, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1674.8}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 125.69, ["Ride"] = 139.13, ["Fly|Ride"] = 262.5, ["Neon"] = 559.05, ["Neon|Ride"] = 820.32}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 39.38, ["Fly"] = 212, ["Ride"] = 103.64, ["Fly|Ride"] = 182.17, ["Neon"] = 315.07, ["Neon|Ride"] = 392.55, ["Neon|Fly|Ride"] = 420, ["Mega"] = 1183.88, ["Mega|Ride"] = 2179.13, ["Mega|Fly|Ride"] = 1097.61}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 814.01, ["Fly"] = 748.13, ["Ride"] = 727.13, ["Fly|Ride"] = 786.79, ["Neon|Fly"] = 2831.8, ["Neon|Ride"] = 3281.25, ["Neon|Fly|Ride"] = 2231.24, ["Mega|Ride"] = 8373.96, ["Mega|Fly|Ride"] = 9581.25}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 259.88, ["Fly"] = 417.69, ["Ride"] = 261.91, ["Fly|Ride"] = 275.63, ["Neon"] = 1181.25, ["Neon|Ride"] = 1535.78, ["Neon|Fly|Ride"] = 1326.24, ["Mega"] = 8234.75, ["Mega|Fly|Ride"] = 7875}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 74.82}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 15.21, ["Fly"] = 31.42, ["Ride"] = 26.21, ["Fly|Ride"] = 63.73, ["Neon"] = 72.19, ["Neon|Ride"] = 97.5, ["Neon|Fly|Ride"] = 136.1, ["Mega"] = 437.26, ["Mega|Ride"] = 558.97, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 287.44, ["Fly"] = 397.83, ["Ride"] = 346.5, ["Fly|Ride"] = 431.82, ["Neon"] = 969.42, ["Neon|Ride"] = 866.24, ["Neon|Fly|Ride"] = 918.75, ["Mega|Fly|Ride"] = 4118.94}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 18.27}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 144.38, ["Fly"] = 590.63, ["Ride"] = 193.8, ["Fly|Ride"] = 288.75, ["Neon"] = 620.2, ["Neon|Fly"] = 1675.01, ["Neon|Ride"] = 662.82, ["Neon|Fly|Ride"] = 721.88, ["Mega"] = 2930.9, ["Mega|Ride"] = 2093.51, ["Mega|Fly|Ride"] = 1801.93}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 156.19, ["Ride"] = 170.63, ["Fly|Ride"] = 208.34, ["Neon|Fly"] = 983.03, ["Neon|Ride"] = 982.9}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 4.6, ["Ride"] = 28.28, ["Fly|Ride"] = 209.39, ["Neon"] = 45.03, ["Neon|Ride"] = 73.5, ["Neon|Fly|Ride"] = 174.63, ["Mega"] = 214.39, ["Mega|Ride"] = 323.28, ["Mega|Fly|Ride"] = 455.35}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 19.59, ["Fly"] = 62.99, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 98.98, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 251.23, ["Mega|Ride"] = 627.01, ["Mega|Fly|Ride"] = 570.49}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 20.98, ["Fly"] = 131.25, ["Ride"] = 61.79, ["Fly|Ride"] = 140.3, ["Neon"] = 99.75, ["Neon|Fly"] = 140.3, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 417.67, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 1017.85}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 3.71, ["Fly"] = 262.5, ["Ride"] = 47.2, ["Fly|Ride"] = 111.19, ["Neon"] = 26.13, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 177.74, ["Mega"] = 140.28, ["Mega|Ride"] = 138.18, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 268.04, ["Fly"] = 329.78, ["Ride"] = 301.88, ["Fly|Ride"] = 374.99, ["Neon"] = 1535.78, ["Neon|Ride"] = 1214.07, ["Neon|Fly|Ride"] = 1376.42, ["Mega|Fly|Ride"] = 5066.25}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 128.63, ["Fly"] = 265.93, ["Ride"] = 175.88, ["Fly|Ride"] = 253.3, ["Neon"] = 456.74, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 680.4, ["Mega"] = 1884.16, ["Mega|Ride"] = 1815.07, ["Mega|Fly|Ride"] = 1704.94}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 82.69, ["Fly"] = 167.45, ["Ride"] = 107.63, ["Fly|Ride"] = 128.63, ["Neon|Ride"] = 400.93, ["Neon|Fly|Ride"] = 418.69, ["Mega|Ride"] = 1674.8, ["Mega|Fly|Ride"] = 1658.84}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 17.71, ["Ride"] = 58.24, ["Fly|Ride"] = 251.27, ["Neon|Ride"] = 599.41, ["Neon|Fly|Ride"] = 485.7, ["Mega|Fly|Ride"] = 1644.44}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 18.09, ["Fly"] = 75.62, ["Ride"] = 30.38, ["Fly|Ride"] = 52.5, ["Neon"] = 68.98, ["Neon|Ride"] = 110.93, ["Neon|Fly|Ride"] = 181.13, ["Mega"] = 698.54, ["Mega|Fly"] = 525, ["Mega|Ride"] = 555.83, ["Mega|Fly|Ride"] = 418.95}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.29, ["Fly"] = 45.81, ["Ride"] = 20.86, ["Fly|Ride"] = 56.44, ["Neon"] = 19.25, ["Neon|Ride"] = 41.89, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 111.74, ["Mega|Ride"] = 140.28, ["Mega|Fly|Ride"] = 272.16}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 1023.74, ["Fly"] = 1396.55, ["Ride"] = 971.25, ["Fly|Ride"] = 971.92, ["Neon"] = 3007.12, ["Neon|Ride"] = 2598.75, ["Neon|Fly|Ride"] = 2493.49, ["Mega|Fly|Ride"] = 9450}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 392.44, ["Ride"] = 418.76, ["Fly|Ride"] = 481.69, ["Neon"] = 1686.53, ["Neon|Ride"] = 1680, ["Neon|Fly|Ride"] = 1575, ["Mega"] = 10467.44, ["Mega|Fly|Ride"] = 5303.87}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 120.37, ["Ride"] = 135.71, ["Fly|Ride"] = 161.44, ["Neon"] = 282.19, ["Neon|Ride"] = 390.56, ["Neon|Fly|Ride"] = 349.63, ["Mega|Ride"] = 1411.03, ["Mega|Fly|Ride"] = 1451.85}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 275.63, ["Fly"] = 335.02, ["Ride"] = 300.57, ["Fly|Ride"] = 326.58, ["Neon|Ride"] = 1415.8, ["Neon|Fly|Ride"] = 1228.89, ["Mega"] = 10467.44, ["Mega|Fly|Ride"] = 4199.99}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 26.25, ["Fly"] = 140.3, ["Ride"] = 32.82, ["Fly|Ride"] = 85.32, ["Neon"] = 138.24, ["Neon|Ride"] = 126.25, ["Neon|Fly|Ride"] = 166.69, ["Mega"] = 1396.38, ["Mega|Ride"] = 786.95, ["Mega|Fly|Ride"] = 618.87}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 216.12, ["Ride"] = 251.27, ["Fly|Ride"] = 314.9, ["Neon"] = 1584.98, ["Neon|Ride"] = 1673.97, ["Neon|Fly|Ride"] = 2406.47, ["Mega"] = 4170.84, ["Mega|Fly|Ride"] = 4213.08}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 55.44, ["Fly"] = 126, ["Ride"] = 62.99, ["Fly|Ride"] = 106.42, ["Neon|Ride"] = 500.42, ["Neon|Fly|Ride"] = 558.97, ["Mega|Fly|Ride"] = 1397.82}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1507.32, ["Ride"] = 1354.85, ["Fly|Ride"] = 1640.63, ["Neon"] = 5304.51, ["Neon|Fly|Ride"] = 6842.97, ["Mega"] = 50243.69, ["Mega|Fly|Ride"] = 24284.46}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 11.61, ["Fly"] = 81.67, ["Ride"] = 26.24, ["Fly|Ride"] = 98.41, ["Neon"] = 61.57, ["Neon|Fly"] = 167.51, ["Neon|Ride"] = 82.69, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 254.63, ["Mega|Ride"] = 261.19, ["Mega|Fly|Ride"] = 424.75}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 49.88, ["Fly"] = 78.75, ["Ride"] = 59.05, ["Fly|Ride"] = 159.48, ["Neon"] = 315, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 543.27, ["Mega"] = 936.85, ["Mega|Ride"] = 1137.83, ["Mega|Fly|Ride"] = 1458.19}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 77.44, ["Fly"] = 91.88, ["Ride"] = 68.25, ["Fly|Ride"] = 86.63, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3768.29, ["Ride"] = 1076.25, ["Fly|Ride"] = 1113, ["Neon|Fly|Ride"] = 4199.99, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 525, ["Fly"] = 835.42, ["Ride"] = 559.05, ["Fly|Ride"] = 698.29, ["Neon|Fly|Ride"] = 2753.71, ["Mega|Fly|Ride"] = 14157.85}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 91.86, ["Fly"] = 140.3, ["Ride"] = 131.25, ["Fly|Ride"] = 216.56, ["Neon"] = 446.8, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 4187, ["Mega|Ride"] = 2652.46, ["Mega|Fly|Ride"] = 2045.81}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 6.23, ["Fly"] = 39.38, ["Ride"] = 23.37, ["Fly|Ride"] = 59.07, ["Neon"] = 87.94, ["Neon|Ride"] = 125.64, ["Neon|Fly|Ride"] = 177.96, ["Mega"] = 656.25, ["Mega|Ride"] = 740.06, ["Mega|Fly|Ride"] = 1017.44}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 32.82, ["Fly"] = 83.76, ["Ride"] = 47.12, ["Fly|Ride"] = 94.4, ["Neon"] = 188.45, ["Neon|Fly"] = 417.72, ["Neon|Ride"] = 209.36, ["Neon|Fly|Ride"] = 279.49, ["Mega"] = 1815.07, ["Mega|Ride"] = 1070.11, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 721.88, ["Ride"] = 874.13, ["Fly|Ride"] = 971.12, ["Neon"] = 2931.25, ["Neon|Ride"] = 2828.44, ["Neon|Fly|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 13259.11}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 787.5}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4921.88, ["Ride"] = 5025, ["Fly|Ride"] = 3937.5, ["Neon|Ride"] = 30000.72, ["Neon|Fly|Ride"] = 21353.57, ["Mega|Fly|Ride"] = 89322.79}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 150.94, ["Fly"] = 276.17, ["Ride"] = 220.67, ["Neon"] = 1675.01, ["Neon|Ride"] = 1258.89, ["Neon|Fly|Ride"] = 1396.38, ["Mega"] = 5861.79, ["Mega|Fly|Ride"] = 5583.35}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 81.38, ["Fly"] = 279.49, ["Ride"] = 77.44, ["Fly|Ride"] = 336, ["Neon"] = 349.13, ["Neon|Ride"] = 483.12, ["Neon|Fly|Ride"] = 977.67, ["Mega|Fly|Ride"] = 2099.99}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 10.5, ["Fly"] = 131.25, ["Ride"] = 26.13, ["Fly|Ride"] = 105, ["Neon"] = 102.38, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 698.2, ["Mega|Ride"] = 628.06, ["Mega|Fly|Ride"] = 585.38}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 16.75, ["Fly"] = 31.87, ["Ride"] = 28.62, ["Fly|Ride"] = 52.64, ["Neon|Ride"] = 195.78, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 832.18}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 19.63, ["Fly"] = 130.02, ["Ride"] = 42, ["Fly|Ride"] = 102.6, ["Neon"] = 126, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 226.41, ["Mega|Ride"] = 558.97, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.93, ["Fly"] = 56.55, ["Ride"] = 22.32, ["Fly|Ride"] = 39.38, ["Neon"] = 38.75, ["Neon|Ride"] = 40.43, ["Neon|Fly|Ride"] = 126.86, ["Mega"] = 695.67, ["Mega|Ride"] = 221.92, ["Mega|Fly|Ride"] = 314.05}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 28.75, ["Ride"] = 93.22, ["Fly|Ride"] = 183.75, ["Neon"] = 163.32, ["Neon|Fly"] = 837.51, ["Neon|Ride"] = 212.39, ["Neon|Fly|Ride"] = 247.23, ["Mega"] = 690.87, ["Mega|Ride"] = 698.2, ["Mega|Fly|Ride"] = 845.25}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 275.52, ["Fly"] = 366.19, ["Ride"] = 288.75, ["Fly|Ride"] = 353.17, ["Neon"] = 1415.97, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 908.33, ["Mega"] = 6562.5, ["Mega|Fly|Ride"] = 3461.61}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.51, ["Fly"] = 22.97, ["Ride"] = 14.44, ["Fly|Ride"] = 36.68, ["Neon"] = 20.95, ["Neon|Ride"] = 28.71, ["Neon|Fly|Ride"] = 66.94, ["Mega"] = 208.31, ["Mega|Ride"] = 220.64, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 32.54, ["Fly"] = 130.99, ["Ride"] = 61.68, ["Fly|Ride"] = 114.16, ["Neon"] = 157.5, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 262.37, ["Mega"] = 564.38, ["Mega|Fly"] = 837.41, ["Mega|Ride"] = 551.25, ["Mega|Fly|Ride"] = 571.29}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 708.75, ["Fly"] = 999.45, ["Ride"] = 762.25, ["Fly|Ride"] = 708.75, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1567.12, ["Mega|Fly|Ride"] = 4633.13}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 32.82, ["Fly"] = 78.53, ["Ride"] = 47.2, ["Fly|Ride"] = 96.5, ["Neon|Fly"] = 471.99, ["Neon|Ride"] = 164.04, ["Neon|Fly|Ride"] = 248.37, ["Mega"] = 1575, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 720.57}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 229.69, ["Fly"] = 342.44, ["Ride"] = 242.82, ["Fly|Ride"] = 279.49, ["Neon"] = 1235.32, ["Neon|Ride"] = 977.8, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 5233.73}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 161.21, ["Fly"] = 180.06, ["Ride"] = 140.3, ["Fly|Ride"] = 157.5, ["Neon"] = 636.51, ["Neon|Fly"] = 636.51, ["Neon|Ride"] = 523.39, ["Neon|Fly|Ride"] = 485.63, ["Mega|Fly|Ride"] = 2236.23}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 590.63, ["Ride"] = 615.75, ["Fly|Ride"] = 633.4, ["Neon|Fly|Ride"] = 2129.09, ["Mega|Fly|Ride"] = 7217.44}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 21.61, ["Ride"] = 47.18, ["Neon"] = 75.39, ["Neon|Fly"] = 283.19, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 273.74, ["Mega"] = 262.48, ["Mega|Ride"] = 418.71, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4004.53, ["Fly"] = 3873.44, ["Ride"] = 3936.19, ["Fly|Ride"] = 3281.24, ["Neon|Fly|Ride"] = 6562.5, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 82.69, ["Fly"] = 70.16, ["Ride"] = 102.32, ["Fly|Ride"] = 157.5, ["Neon"] = 418.76, ["Neon|Ride"] = 342.3, ["Neon|Fly|Ride"] = 450.08, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.35, ["Fly"] = 51.93, ["Ride"] = 21, ["Fly|Ride"] = 84, ["Neon"] = 23.45, ["Neon|Fly"] = 45.05, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 139.1, ["Mega|Fly"] = 452.82, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.14, ["Ride"] = 27.98, ["Fly|Ride"] = 63, ["Neon"] = 24.45, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 161.43, ["Mega|Ride"] = 199.47, ["Mega|Fly|Ride"] = 278.24}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 53.82, ["Fly"] = 82.85, ["Ride"] = 41.91, ["Fly|Ride"] = 59.07, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 418.71, ["Mega|Fly|Ride"] = 1381.72}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 1162.45, ["Ride"] = 1174.69, ["Fly|Ride"] = 1295.44, ["Neon"] = 5705.46, ["Neon|Fly|Ride"] = 5228.5, ["Mega|Fly|Ride"] = 22331.24}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 4725, ["Ride"] = 5899.81, ["Fly|Ride"] = 4790.63}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 22.3, ["Fly"] = 32.82, ["Ride"] = 22.14, ["Fly|Ride"] = 45.94, ["Neon"] = 140.3, ["Neon|Ride"] = 116.21, ["Neon|Fly|Ride"] = 140.43, ["Mega"] = 2428.13, ["Mega|Fly|Ride"] = 530.72}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 15.62, ["Ride"] = 34.12, ["Fly|Ride"] = 65.63, ["Neon"] = 94.5, ["Neon|Ride"] = 88.53, ["Neon|Fly|Ride"] = 175.61, ["Mega"] = 933.52, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 55.11, ["Fly"] = 157.5, ["Ride"] = 52.5, ["Fly|Ride"] = 86.15, ["Neon"] = 271.24, ["Neon|Ride"] = 315.05, ["Neon|Fly|Ride"] = 275.5, ["Mega"] = 1050, ["Mega|Ride"] = 1178.65, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 232.32, ["Fly"] = 315.05, ["Ride"] = 236.25, ["Fly|Ride"] = 259.88, ["Neon|Ride"] = 976.5, ["Neon|Fly|Ride"] = 1191.63, ["Mega"] = 10467.44, ["Mega|Fly|Ride"] = 3210.38}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.81, ["Ride"] = 32.49, ["Fly|Ride"] = 86.63, ["Neon"] = 27.16, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 83.76, ["Neon|Fly|Ride"] = 245.42, ["Mega"] = 131.25, ["Mega|Ride"] = 272.27, ["Mega|Fly|Ride"] = 368.11}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 189, ["Fly"] = 255.64, ["Ride"] = 232.21, ["Fly|Ride"] = 309.89, ["Neon"] = 698.29, ["Neon|Ride"] = 820.66, ["Neon|Fly|Ride"] = 828.19, ["Mega|Fly|Ride"] = 3909.61}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.51, ["Fly"] = 23.05, ["Ride"] = 18.38, ["Fly|Ride"] = 39.38, ["Neon"] = 19.69, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 32.71, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 210, ["Mega|Ride"] = 211.65, ["Mega|Fly|Ride"] = 278.65}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 196.88, ["Fly"] = 268.82, ["Ride"] = 253.32, ["Fly|Ride"] = 225.1, ["Neon|Ride"] = 1297.92, ["Neon|Fly|Ride"] = 884.88, ["Mega"] = 10467.44, ["Mega|Ride"] = 4187, ["Mega|Fly|Ride"] = 7668.84}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 15.72, ["Fly"] = 26.25, ["Ride"] = 27.06, ["Fly|Ride"] = 62.83, ["Neon"] = 83.76, ["Neon|Fly"] = 299.71, ["Neon|Ride"] = 99.47, ["Neon|Fly|Ride"] = 190.52, ["Mega"] = 522.41, ["Mega|Ride"] = 586.19, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.63, ["Ride"] = 19.69, ["Neon"] = 12.58, ["Neon|Fly"] = 65.98, ["Neon|Ride"] = 140.3, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 76.39, ["Mega|Ride"] = 111.23, ["Mega|Fly|Ride"] = 235.52}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.49, ["Neon|Ride"] = 70.16, ["Mega"] = 23.51, ["Mega|Ride"] = 139.23}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.61, ["Ride"] = 261.19, ["Fly|Ride"] = 139.63, ["Neon"] = 7.16, ["Neon|Ride"] = 61.37, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 110.91, ["Mega|Fly"] = 157310.04, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 158.1}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 70.6, ["Fly"] = 138.24, ["Ride"] = 111.57, ["Fly|Ride"] = 220.5, ["Neon"] = 265.93, ["Neon|Fly"] = 262.79, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 341.16, ["Mega|Fly|Ride"] = 1135.82}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 40.69, ["Ride"] = 15.74, ["Fly|Ride"] = 43.32, ["Neon"] = 12.39, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 95.1, ["Mega|Ride"] = 56.58, ["Mega|Fly|Ride"] = 257.24}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 10.4, ["Ride"] = 111.09, ["Fly|Ride"] = 194.73, ["Neon"] = 74.82, ["Neon|Ride"] = 129.94, ["Mega"] = 485.63, ["Mega|Ride"] = 523.69}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 28.67, ["Neon|Fly|Ride"] = 278.25, ["Mega"] = 15.73, ["Mega|Ride"] = 56.55, ["Mega|Fly|Ride"] = 157.31}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.05, ["Fly"] = 15.73, ["Ride"] = 17.71, ["Fly|Ride"] = 26.17, ["Neon"] = 2.1, ["Neon|Fly"] = 21.19, ["Neon|Ride"] = 11.54, ["Neon|Fly|Ride"] = 32.01, ["Mega"] = 15.39, ["Mega|Fly"] = 30.19, ["Mega|Ride"] = 26.17, ["Mega|Fly|Ride"] = 31.29}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 15.62, ["Fly|Ride"] = 32.82, ["Neon"] = 3.67, ["Neon|Fly"] = 15.44, ["Neon|Ride"] = 23.05, ["Neon|Fly|Ride"] = 46.17, ["Mega"] = 28.03, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 78.73}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 21.25, ["Neon"] = 2.1, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 39.38, ["Mega"] = 30.19, ["Mega|Ride"] = 146.97, ["Mega|Fly|Ride"] = 308.8}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Ride"] = 19.69, ["Fly|Ride"] = 107.52, ["Neon"] = 3.72, ["Neon|Fly"] = 135.06, ["Neon|Ride"] = 28.28, ["Neon|Fly|Ride"] = 90.56, ["Mega"] = 41.5, ["Mega|Fly"] = 85.32, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 165.4}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Fly|Ride"] = 39.38, ["Neon"] = 3.93, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 27.57, ["Mega|Fly"] = 100.5, ["Mega|Ride"] = 84.94}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 49.26, ["Ride"] = 32.82, ["Fly|Ride"] = 47.41, ["Neon"] = 4.65, ["Neon|Fly"] = 49.26, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 52.39, ["Mega|Fly"] = 195.86, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 114.17}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 15.72, ["Neon"] = 2.1, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 313.84, ["Mega"] = 18.36, ["Mega|Ride"] = 44.62, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.63, ["Fly|Ride"] = 525, ["Neon"] = 47.16, ["Mega"] = 209.36, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 344.97}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Neon"] = 13.37, ["Mega"] = 105, ["Mega|Fly|Ride"] = 376.85}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 1312.5, ["Neon"] = 5.16, ["Neon|Ride"] = 37.7, ["Neon|Fly|Ride"] = 83.75, ["Mega"] = 26.25, ["Mega|Ride"] = 60.8, ["Mega|Fly|Ride"] = 131.15}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.05, ["Fly"] = 17.07, ["Ride"] = 18.85, ["Fly|Ride"] = 28.6, ["Neon"] = 2.1, ["Neon|Fly"] = 41.89, ["Neon|Ride"] = 17.63, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 17.05, ["Mega|Ride"] = 26.6, ["Mega|Fly|Ride"] = 60.38}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.84, ["Fly"] = 72.19, ["Ride"] = 26.25, ["Fly|Ride"] = 104.98, ["Neon"] = 32.82, ["Neon|Ride"] = 39.82, ["Mega"] = 251.23, ["Mega|Ride"] = 274.55}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Fly"] = 28.28, ["Ride"] = 42, ["Fly|Ride"] = 78.73, ["Neon"] = 4.75, ["Neon|Ride"] = 25.15, ["Neon|Fly|Ride"] = 158.06, ["Mega"] = 34.13, ["Mega|Ride"] = 52.49, ["Mega|Fly|Ride"] = 142.49}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 3.49, ["Neon"] = 13.13, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 140.28, ["Mega"] = 89.25, ["Mega|Ride"] = 140.28, ["Mega|Fly|Ride"] = 223.12}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.35, ["Fly"] = 131.25, ["Ride"] = 32.81, ["Fly|Ride"] = 190.54, ["Neon"] = 116.82, ["Neon|Ride"] = 70.16, ["Neon|Fly|Ride"] = 140.28, ["Mega"] = 95.27, ["Mega|Ride"] = 85.31, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 10.31, ["Ride"] = 12.79, ["Fly|Ride"] = 28.88, ["Neon"] = 2.1, ["Neon|Fly"] = 14.75, ["Neon|Ride"] = 15.72, ["Neon|Fly|Ride"] = 34.55, ["Mega"] = 17.71, ["Mega|Fly"] = 27.23, ["Mega|Ride"] = 28.3, ["Mega|Fly|Ride"] = 45.93}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 18.87, ["Fly|Ride"] = 72.19, ["Neon"] = 15.65, ["Neon|Ride"] = 113.27, ["Neon|Fly|Ride"] = 74.33, ["Mega"] = 78.75, ["Mega|Ride"] = 152.6, ["Mega|Fly|Ride"] = 196.77}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.63, ["Fly"] = 41.91, ["Fly|Ride"] = 140.3, ["Neon"] = 7.35, ["Neon|Ride"] = 112.03, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 279.61, ["Mega|Ride"] = 278.07, ["Mega|Fly|Ride"] = 387.85}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 14.6, ["Ride"] = 17.07, ["Fly|Ride"] = 26.17, ["Neon"] = 2.1, ["Neon|Fly"] = 20.24, ["Neon|Ride"] = 15.04, ["Neon|Fly|Ride"] = 34.99, ["Mega|Fly"] = 156.19, ["Mega|Fly|Ride"] = 125.19}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 174.84, ["Ride"] = 26.25, ["Neon"] = 15.75, ["Neon|Fly"] = 77.48, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 125.63, ["Mega|Fly"] = 167.49, ["Mega|Ride"] = 89.67}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 4.82, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 28.28, ["Neon|Fly|Ride"] = 141.49, ["Mega"] = 30.19, ["Mega|Ride"] = 154.93, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.05, ["Fly"] = 46.08, ["Neon"] = 2.1, ["Neon|Fly"] = 41.89, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 15.31, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 124.74}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 98.42, ["Ride"] = 16.27, ["Fly|Ride"] = 47.21, ["Neon"] = 11.7, ["Neon|Fly"] = 45.12, ["Neon|Ride"] = 27.23, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 60.38, ["Mega|Ride"] = 138.28, ["Mega|Fly|Ride"] = 261.7}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 20.95, ["Neon"] = 6.57, ["Neon|Ride"] = 56.55, ["Neon|Fly|Ride"] = 140.28, ["Mega"] = 65.63, ["Mega|Ride"] = 125.63, ["Mega|Fly|Ride"] = 325.65}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.05, ["Fly"] = 28.73, ["Ride"] = 15.7, ["Fly|Ride"] = 140.28, ["Neon"] = 4.6, ["Neon|Fly"] = 98.42, ["Neon|Ride"] = 25.09, ["Neon|Fly|Ride"] = 45.92, ["Mega"] = 65.63, ["Mega|Ride"] = 90.46, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.1, ["Ride"] = 82.69, ["Neon"] = 27.57, ["Mega|Fly|Ride"] = 838.11}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 18.1, ["Fly|Ride"] = 5427.83, ["Neon"] = 6.57, ["Neon|Fly"] = 140.3, ["Neon|Ride"] = 31.46, ["Neon|Fly|Ride"] = 140.28, ["Mega"] = 157.5, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 20.69, ["Ride"] = 29.64, ["Fly|Ride"] = 28.88, ["Neon"] = 35.6, ["Neon|Fly"] = 41.89, ["Neon|Ride"] = 31.87, ["Neon|Fly|Ride"] = 90.23, ["Mega"] = 196.88, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 79.47, ["Fly|Ride"] = 106.14, ["Neon"] = 23.05, ["Neon|Ride"] = 158.12, ["Mega"] = 200.16, ["Mega|Ride"] = 406.87}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 13.12, ["Ride"] = 131.24, ["Neon"] = 140.3, ["Neon|Ride"] = 235.98, ["Mega"] = 656.25, ["Mega|Ride"] = 875.1, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.1, ["Ride"] = 56.55, ["Neon"] = 40.69, ["Neon|Ride"] = 91.88, ["Mega"] = 315.03, ["Mega|Ride"] = 367.5}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 105, ["Ride"] = 42.66, ["Fly|Ride"] = 140.3, ["Neon"] = 93.26, ["Neon|Ride"] = 116.22, ["Mega"] = 471.95, ["Mega|Ride"] = 255.29, ["Mega|Fly|Ride"] = 390.48}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.14, ["Neon|Ride"] = 92.14, ["Mega"] = 21, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 148.31}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 55.95}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 3.92, ["Fly"] = 27.07, ["Ride"] = 20.9, ["Fly|Ride"] = 41.89, ["Neon"] = 52.38, ["Neon|Ride"] = 56.55, ["Neon|Fly|Ride"] = 88.1, ["Mega"] = 275.63, ["Mega|Ride"] = 275.82, ["Mega|Fly|Ride"] = 244.95}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.36, ["Fly|Ride"] = 731.58, ["Neon"] = 4.11, ["Neon|Ride"] = 26.17, ["Mega"] = 18.37, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 24.1, ["Fly|Ride"] = 140.28, ["Neon"] = 5.16, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 40.14, ["Mega"] = 52.39, ["Mega|Ride"] = 69.51, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 45.92, ["Ride"] = 16.69, ["Fly|Ride"] = 77.48, ["Neon"] = 18.5, ["Neon|Ride"] = 47.66, ["Neon|Fly|Ride"] = 78.11, ["Mega"] = 148.67, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.5, ["Ride"] = 98.42, ["Neon"] = 42, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 154.97, ["Mega"] = 328.13, ["Mega|Ride"] = 279.57, ["Mega|Fly|Ride"] = 418.71}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 49.22, ["Neon|Fly|Ride"] = 79.07, ["Mega"] = 26.25, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 53.41, ["Mega|Fly|Ride"] = 140.28}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 27.56, ["Ride"] = 15.48, ["Fly|Ride"] = 279165.99, ["Neon"] = 3.93, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 69.56, ["Mega"] = 30.19, ["Mega|Fly"] = 200.59, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.05, ["Fly"] = 15.65, ["Ride"] = 18.38, ["Fly|Ride"] = 31.29, ["Neon"] = 6.76, ["Neon|Fly"] = 70.16, ["Neon|Ride"] = 23.37, ["Neon|Fly|Ride"] = 140.28, ["Mega"] = 47.25, ["Mega|Ride"] = 51.33, ["Mega|Fly|Ride"] = 158.29}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 31.06, ["Fly|Ride"] = 77.89, ["Neon"] = 3.56, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 94.22, ["Mega"] = 22.25, ["Mega|Fly"] = 98.41, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 118.12}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 38.06, ["Neon|Fly|Ride"] = 165.4, ["Mega"] = 18.36, ["Mega|Fly"] = 104.99, ["Mega|Ride"] = 77.44, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 26.36, ["Ride"] = 19.59, ["Fly|Ride"] = 77.44, ["Neon"] = 2.1, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 49.22, ["Mega|Ride"] = 47.6, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 59.07, ["Mega"] = 15.75, ["Mega|Ride"] = 140.31, ["Mega|Fly|Ride"] = 261.85}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 158.12, ["Neon|Fly|Ride"] = 420, ["Mega"] = 22.32, ["Mega|Fly"] = 117.99, ["Mega|Ride"] = 112.02, ["Mega|Fly|Ride"] = 339.17}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 28.28, ["Ride"] = 24.77, ["Fly|Ride"] = 52.5, ["Neon"] = 5.29, ["Neon|Fly"] = 72.01, ["Neon|Ride"] = 20.94, ["Neon|Fly|Ride"] = 104.99, ["Mega"] = 79.07, ["Mega|Fly|Ride"] = 167.51}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 12.71, ["Ride"] = 82.69, ["Neon"] = 96.32, ["Neon|Ride"] = 236, ["Mega"] = 410.79, ["Mega|Ride"] = 405.11, ["Mega|Fly|Ride"] = 936.85}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.49, ["Ride"] = 39.19, ["Neon"] = 41.18, ["Mega"] = 208.31, ["Mega|Ride"] = 348.48, ["Mega|Fly|Ride"] = 418.71}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 28.28, ["Fly|Ride"] = 418.76, ["Neon"] = 28.28, ["Mega"] = 237.62, ["Mega|Ride"] = 188.43, ["Mega|Fly|Ride"] = 296.87}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 17.14, ["Ride"] = 12.5, ["Fly|Ride"] = 35.61, ["Neon"] = 2.1, ["Neon|Fly"] = 15.75, ["Neon|Ride"] = 14.23, ["Neon|Fly|Ride"] = 26.24, ["Mega"] = 15.96, ["Mega|Fly"] = 23.63, ["Mega|Ride"] = 23.63, ["Mega|Fly|Ride"] = 54.29}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Ride"] = 55.12, ["Fly|Ride"] = 70.16, ["Neon"] = 4.87, ["Neon|Fly"] = 83.76, ["Neon|Ride"] = 28.28, ["Neon|Fly|Ride"] = 698.2, ["Mega"] = 70.2, ["Mega|Ride"] = 140.28}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 20.98, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 78.52, ["Mega"] = 18.26, ["Mega|Fly"] = 77.49, ["Mega|Ride"] = 51.9, ["Mega|Fly|Ride"] = 99.28}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.03, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 91.87, ["Mega"] = 15.74, ["Mega|Ride"] = 102.6, ["Mega|Fly|Ride"] = 208.31}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 31.38, ["Ride"] = 20.97, ["Fly|Ride"] = 56.44, ["Neon"] = 12.37, ["Neon|Fly"] = 65.6, ["Neon|Ride"] = 31.75, ["Neon|Fly|Ride"] = 86.9, ["Mega"] = 141.39, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 288.27}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 170.63, ["Ride"] = 181.46, ["Fly|Ride"] = 262.5, ["Neon"] = 927.54, ["Neon|Ride"] = 1102.04, ["Neon|Fly|Ride"] = 768.33, ["Mega"] = 8373.96, ["Mega|Fly|Ride"] = 3281.25}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Fly|Ride"] = 55.47, ["Neon"] = 6.04, ["Neon|Fly"] = 56.6, ["Neon|Ride"] = 68.25, ["Mega"] = 67.01, ["Mega|Ride"] = 195.76, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 26.23, ["Fly"] = 103.68, ["Ride"] = 28.88, ["Fly|Ride"] = 196.88, ["Neon"] = 33.52, ["Neon|Ride"] = 164.29, ["Neon|Fly|Ride"] = 158.07, ["Mega"] = 464.4, ["Mega|Ride"] = 564.37, ["Mega|Fly|Ride"] = 630.04}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 17.69, ["Fly|Ride"] = 36.66, ["Neon"] = 5.46, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 27.26, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 65.63, ["Mega|Fly"] = 94.4, ["Mega|Ride"] = 59.7, ["Mega|Fly|Ride"] = 125.63}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 28.28, ["Fly|Ride"] = 120.89, ["Neon"] = 11.82, ["Neon|Fly"] = 83.76, ["Neon|Ride"] = 103.73, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 83.75, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 208.31}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.54, ["Fly"] = 32.71, ["Ride"] = 16.95, ["Fly|Ride"] = 35.43, ["Neon"] = 30.19, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 91.88, ["Mega|Ride"] = 278.44, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.83, ["Fly"] = 28.28, ["Ride"] = 39.38, ["Fly|Ride"] = 247.07, ["Neon"] = 28.88, ["Neon|Ride"] = 137.45, ["Neon|Fly|Ride"] = 621.77, ["Mega"] = 327.48, ["Mega|Ride"] = 332.89, ["Mega|Fly|Ride"] = 398.35}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 16.75, ["Ride"] = 17.71, ["Fly|Ride"] = 40.85, ["Neon"] = 26.25, ["Neon|Fly"] = 82.72, ["Neon|Ride"] = 28.29, ["Neon|Fly|Ride"] = 67.9, ["Mega|Ride"] = 353.96, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 76.13, ["Fly"] = 131.25, ["Ride"] = 94.35, ["Fly|Ride"] = 140.39, ["Neon"] = 452.27, ["Neon|Fly"] = 405.57, ["Neon|Ride"] = 378, ["Neon|Fly|Ride"] = 418.71, ["Mega|Fly|Ride"] = 1573.69}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 216.56, ["Fly"] = 322.17, ["Ride"] = 209.39, ["Fly|Ride"] = 279.54, ["Neon"] = 418.76, ["Neon|Ride"] = 2617.19, ["Neon|Fly|Ride"] = 1088.63, ["Mega"] = 10467.44, ["Mega|Fly|Ride"] = 6694.98}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 76.13, ["Fly"] = 124.48, ["Ride"] = 94.5, ["Fly|Ride"] = 131.25, ["Neon"] = 376.89, ["Neon|Ride"] = 277.56, ["Neon|Fly|Ride"] = 409.29, ["Mega|Fly|Ride"] = 1701.32}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 3.29, ["Ride"] = 53.44, ["Fly|Ride"] = 140.3, ["Neon"] = 23.5, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 245.06, ["Mega"] = 157.5, ["Mega|Ride"] = 137.13, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 12.55, ["Fly"] = 68.14, ["Ride"] = 35.38, ["Fly|Ride"] = 66.94, ["Neon"] = 125.72, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 112.02, ["Neon|Fly|Ride"] = 209.36, ["Mega"] = 351.75, ["Mega|Ride"] = 451.5, ["Mega|Fly|Ride"] = 418.71}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 17.69, ["Ride"] = 20.83, ["Fly|Ride"] = 42, ["Neon"] = 3.93, ["Neon|Fly"] = 28.28, ["Neon|Ride"] = 25.15, ["Neon|Fly|Ride"] = 85.85, ["Mega"] = 73.16, ["Mega|Fly"] = 210.02, ["Mega|Ride"] = 78.66, ["Mega|Fly|Ride"] = 195.76}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 7.24, ["Fly"] = 72.1, ["Ride"] = 26.25, ["Fly|Ride"] = 135.19, ["Neon"] = 40.87, ["Neon|Ride"] = 157.9, ["Neon|Fly|Ride"] = 134.93, ["Mega"] = 790.31, ["Mega|Ride"] = 405.11, ["Mega|Fly|Ride"] = 558.97}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 30.19, ["Ride"] = 16.77, ["Fly|Ride"] = 49.22, ["Neon"] = 12.5, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 41.89, ["Neon|Fly|Ride"] = 99.49, ["Mega"] = 131.25, ["Mega|Ride"] = 178.17, ["Mega|Fly|Ride"] = 175.88}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 6.3, ["Ride"] = 26.25, ["Fly|Ride"] = 328.13, ["Neon"] = 41.93, ["Neon|Ride"] = 74.82, ["Neon|Fly|Ride"] = 235.98, ["Mega"] = 207.37, ["Mega|Ride"] = 235.98, ["Mega|Fly|Ride"] = 457.47}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 33.51, ["Neon"] = 2.1, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 47.38, ["Mega"] = 22.42, ["Mega|Ride"] = 39.8, ["Mega|Fly|Ride"] = 224.13}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 20.34, ["Ride"] = 20.9, ["Fly|Ride"] = 48.18, ["Neon"] = 11.82, ["Neon|Fly"] = 104.7, ["Neon|Ride"] = 41.89, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 108.94, ["Mega|Ride"] = 81.36, ["Mega|Fly|Ride"] = 189.67}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 24.92, ["Ride"] = 18.06, ["Fly|Ride"] = 39.38, ["Neon"] = 63.73, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 283.5, ["Mega|Ride"] = 205.31, ["Mega|Fly|Ride"] = 233.44}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 164.07, ["Fly"] = 199.97, ["Ride"] = 212.63, ["Fly|Ride"] = 275.63, ["Neon"] = 700.87, ["Neon|Ride"] = 564.38, ["Neon|Fly|Ride"] = 619.48, ["Mega|Ride"] = 3478.13, ["Mega|Fly|Ride"] = 2181.23}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.54, ["Ride"] = 41.89, ["Fly|Ride"] = 204.15, ["Neon"] = 51.19, ["Neon|Ride"] = 160.13, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 307.47, ["Mega|Ride"] = 362.22, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Fly|Ride"] = 41.92, ["Neon"] = 28.23, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 131.25, ["Mega|Ride"] = 279.49, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 28.71, ["Ride"] = 73.5, ["Fly|Ride"] = 178.5, ["Neon"] = 106.32, ["Neon|Ride"] = 119.75, ["Neon|Fly|Ride"] = 294.53, ["Mega"] = 488.84, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 530.72}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 3.65}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.1, ["Ride"] = 28.48, ["Neon"] = 28.23, ["Neon|Ride"] = 149.99, ["Neon|Fly|Ride"] = 628.06, ["Mega"] = 299.25, ["Mega|Ride"] = 313.69, ["Mega|Fly|Ride"] = 544.32}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 24.86, ["Fly"] = 36.66, ["Ride"] = 31.39, ["Fly|Ride"] = 49.87, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 154.93, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 2093.51, ["Mega|Ride"] = 693.75, ["Mega|Fly|Ride"] = 684.59}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Fly|Ride"] = 78.75, ["Neon"] = 3.93, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 41.91, ["Mega|Fly|Ride"] = 140.18}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 3.82, ["Fly"] = 26.88, ["Ride"] = 28.28, ["Fly|Ride"] = 62.26, ["Neon"] = 45.94, ["Neon|Ride"] = 236, ["Mega"] = 140.42, ["Mega|Fly"] = 394.08, ["Mega|Ride"] = 147, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.05, ["Fly"] = 45.03, ["Ride"] = 15.74, ["Fly|Ride"] = 45.65, ["Neon"] = 13.42, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 72.1, ["Mega"] = 124.68, ["Mega|Ride"] = 140.38, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Neon"] = 3.83, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 31.07, ["Neon|Fly|Ride"] = 418.71, ["Mega"] = 31.49, ["Mega|Ride"] = 78.62, ["Mega|Fly|Ride"] = 145.14}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 31.49, ["Fly"] = 125.64, ["Ride"] = 69.63, ["Fly|Ride"] = 525, ["Neon"] = 232.32, ["Neon|Ride"] = 418.76, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 837.41, ["Mega|Ride"] = 786.19, ["Mega|Fly|Ride"] = 837.93}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 2.25, ["Ride"] = 70.16, ["Fly|Ride"] = 210, ["Neon"] = 69.12, ["Neon|Fly|Ride"] = 209.36, ["Mega"] = 209.51, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 11.7, ["Fly"] = 131.06, ["Ride"] = 41.89, ["Fly|Ride"] = 134.8, ["Neon"] = 95.82, ["Neon|Fly"] = 314.99, ["Neon|Ride"] = 71.6, ["Neon|Fly|Ride"] = 209.36, ["Mega"] = 360.93, ["Mega|Ride"] = 523.39, ["Mega|Fly|Ride"] = 628.06}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 45.94, ["Fly"] = 98.41, ["Ride"] = 103.69, ["Fly|Ride"] = 262.44, ["Neon"] = 279.54, ["Neon|Ride"] = 314.05, ["Neon|Fly|Ride"] = 334.97, ["Mega|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 1309.88}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 15.7, ["Fly"] = 39.38, ["Ride"] = 22.32, ["Fly|Ride"] = 62.83, ["Neon"] = 63, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 209.36, ["Mega"] = 263.82, ["Mega|Ride"] = 312.99, ["Mega|Fly|Ride"] = 504.97}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 78.62, ["Fly"] = 145.69, ["Ride"] = 120.75, ["Fly|Ride"] = 195.78, ["Neon"] = 203.43, ["Neon|Ride"] = 256.79, ["Neon|Fly|Ride"] = 372.21, ["Mega"] = 2044.65, ["Mega|Ride"] = 1088.63, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 28.88, ["Ride"] = 70.82, ["Fly|Ride"] = 173.25, ["Neon"] = 102.61, ["Neon|Ride"] = 125.72, ["Neon|Fly|Ride"] = 292.05, ["Mega"] = 405.11, ["Mega|Ride"] = 355.04, ["Mega|Fly|Ride"] = 448.88}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 5.16, ["Fly"] = 69.5, ["Ride"] = 18.38, ["Fly|Ride"] = 300.47, ["Neon"] = 80.76, ["Neon|Ride"] = 84.92, ["Neon|Fly|Ride"] = 125.63, ["Mega"] = 105, ["Mega|Ride"] = 1046.76, ["Mega|Fly|Ride"] = 401.16}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 19.57, ["Ride"] = 78.75, ["Fly|Ride"] = 103.69, ["Neon"] = 88.2, ["Neon|Ride"] = 134.03, ["Neon|Fly|Ride"] = 397.78, ["Mega"] = 333.31, ["Mega|Fly"] = 389.41, ["Mega|Ride"] = 352.84, ["Mega|Fly|Ride"] = 533.54}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 9.81, ["Ride"] = 34.13, ["Fly|Ride"] = 138.21, ["Neon"] = 63.73, ["Neon|Ride"] = 94.41, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 471.69, ["Mega|Ride"] = 567, ["Mega|Fly|Ride"] = 349.13}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 41.89, ["Neon|Ride"] = 56.05, ["Neon|Fly|Ride"] = 95.27, ["Mega"] = 18.38, ["Mega|Fly"] = 140.28, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 434.46, ["Neon"] = 14.55, ["Neon|Ride"] = 83.75, ["Mega"] = 119.94, ["Mega|Ride"] = 160.23, ["Mega|Fly|Ride"] = 471.95}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Neon"] = 22.32, ["Neon|Ride"] = 103.64, ["Mega"] = 182.15, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 5.15, ["Ride"] = 31.42, ["Fly|Ride"] = 116.84, ["Neon"] = 15.75, ["Neon|Ride"] = 82.95, ["Neon|Fly|Ride"] = 272.16, ["Mega"] = 123.38, ["Mega|Ride"] = 152.97, ["Mega|Fly|Ride"] = 158.1}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 459.38, ["Fly"] = 592.54, ["Ride"] = 538.13, ["Fly|Ride"] = 588, ["Neon|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 787.5, ["Mega|Fly|Ride"] = 5840.63}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 7.85, ["Fly"] = 28.28, ["Ride"] = 25.14, ["Fly|Ride"] = 54.45, ["Neon"] = 52.5, ["Neon|Ride"] = 70.12, ["Neon|Fly|Ride"] = 210, ["Mega"] = 279.49, ["Mega|Ride"] = 278.25}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 9.45, ["Fly"] = 39.38, ["Ride"] = 27.24, ["Fly|Ride"] = 83.76, ["Neon"] = 60.74, ["Neon|Fly"] = 315, ["Neon|Ride"] = 59.06, ["Mega"] = 215.25, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 328.12}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.61, ["Fly"] = 28.28, ["Ride"] = 23.63, ["Fly|Ride"] = 314.08, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 183.75, ["Mega|Ride"] = 630.04, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 27.13, ["Fly|Ride"] = 140.3, ["Neon"] = 11.46, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 125.63, ["Mega"] = 77.47, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 209.51}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 70.16, ["Ride"] = 70.16, ["Neon"] = 2.1, ["Neon|Ride"] = 31.13, ["Mega"] = 31.46, ["Mega|Ride"] = 77.44, ["Mega|Fly|Ride"] = 220.64}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1543.97}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 7.17, ["Ride"] = 28.88, ["Neon"] = 55.13, ["Neon|Fly"] = 140.3, ["Neon|Ride"] = 87.94, ["Mega|Ride"] = 544.32, ["Mega|Fly|Ride"] = 523.39}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 29.7, ["Neon"] = 7.35, ["Neon|Ride"] = 40.68, ["Mega"] = 131.25, ["Mega|Ride"] = 140.37, ["Mega|Fly|Ride"] = 229.04}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 98.42, ["Ride"] = 25.14, ["Fly|Ride"] = 574.38, ["Neon"] = 13.22, ["Neon|Fly"] = 125.64, ["Neon|Ride"] = 62.83, ["Neon|Fly|Ride"] = 133.88, ["Mega"] = 125.63, ["Mega|Ride"] = 158.1, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 393.75, ["Ride"] = 418.69, ["Fly|Ride"] = 458.07, ["Neon|Ride"] = 1534.32, ["Neon|Fly|Ride"] = 1459.18, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 5.92, ["Fly"] = 196.88, ["Ride"] = 72.19, ["Neon"] = 82.43, ["Neon|Ride"] = 131.25, ["Mega"] = 279.8, ["Mega|Ride"] = 328.69, ["Mega|Fly|Ride"] = 390.54}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Neon"] = 4.19, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 113.07, ["Mega"] = 49.88, ["Mega|Fly"] = 189, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 216.58}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 837.51, ["Neon"] = 2.61, ["Neon|Ride"] = 98.28, ["Neon|Fly|Ride"] = 265.89, ["Mega"] = 21, ["Mega|Ride"] = 146.56, ["Mega|Fly|Ride"] = 192.62}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 11.03, ["Fly"] = 56.27, ["Ride"] = 70.16, ["Fly|Ride"] = 161.23, ["Neon"] = 94.41, ["Neon|Ride"] = 104.7, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 328.13, ["Mega|Ride"] = 333.9, ["Mega|Fly|Ride"] = 372.75}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 26.24, ["Ride"] = 118, ["Neon"] = 106.21, ["Neon|Ride"] = 112.12, ["Neon|Fly|Ride"] = 837.41, ["Mega"] = 558.97, ["Mega|Ride"] = 556.88, ["Mega|Fly|Ride"] = 1112.36}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 3.91, ["Ride"] = 26.25, ["Fly|Ride"] = 140.3, ["Neon"] = 140.3, ["Neon|Ride"] = 200.82, ["Mega"] = 626.07, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 19.88, ["Ride"] = 43.32, ["Fly|Ride"] = 262.5, ["Neon"] = 174.65, ["Neon|Ride"] = 154.95, ["Neon|Fly|Ride"] = 511.87, ["Mega"] = 525, ["Mega|Ride"] = 417.67, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 372.66, ["Ride"] = 408.13, ["Fly|Ride"] = 616.88, ["Neon"] = 1396.55, ["Neon|Ride"] = 943.94, ["Neon|Fly|Ride"] = 1297.97, ["Mega|Ride"] = 3768.29, ["Mega|Fly|Ride"] = 3478.86}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 5.03, ["Fly"] = 28.28, ["Ride"] = 28.28, ["Fly|Ride"] = 83.78, ["Neon"] = 98.44, ["Neon|Ride"] = 138.21, ["Neon|Fly|Ride"] = 137.64, ["Mega"] = 525, ["Mega|Ride"] = 538.59, ["Mega|Fly|Ride"] = 734.84}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 6.57, ["Ride"] = 103.69, ["Mega"] = 1256.11, ["Mega|Fly|Ride"] = 1674.8}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 14.18, ["Ride"] = 60.37, ["Fly|Ride"] = 155.76, ["Neon"] = 47.24, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 210, ["Mega"] = 218.44, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 329.44}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 116.22, ["Neon"] = 14.43, ["Neon|Ride"] = 112.61, ["Neon|Fly|Ride"] = 208.31, ["Mega"] = 44.6, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 235.98}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 45.94, ["Ride"] = 127.71, ["Neon"] = 393.75, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 471.06, ["Mega"] = 2512.2, ["Mega|Ride"] = 1337.94, ["Mega|Fly|Ride"] = 1251.92}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 585.43, ["Ride"] = 31.49, ["Neon"] = 10.5, ["Neon|Fly"] = 156.96, ["Neon|Ride"] = 40.84, ["Neon|Fly|Ride"] = 155.75, ["Mega"] = 78.75, ["Mega|Ride"] = 99.68, ["Mega|Fly|Ride"] = 221.82}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 41.74, ["Ride"] = 28.28, ["Fly|Ride"] = 98.42, ["Neon"] = 4.03, ["Neon|Fly"] = 418.76, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 91.86, ["Mega"] = 44.63, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 174.63}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 6.17, ["Ride"] = 61.69, ["Fly|Ride"] = 111.51, ["Neon"] = 40.69, ["Neon|Ride"] = 65.97, ["Neon|Fly|Ride"] = 698.2, ["Mega"] = 236.25, ["Mega|Fly"] = 628.06, ["Mega|Ride"] = 240.76, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 70.2, ["Ride"] = 110.85, ["Fly|Ride"] = 315.07, ["Neon"] = 485.63, ["Neon|Ride"] = 509.25, ["Mega|Fly|Ride"] = 1355.82}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 262.5, ["Ride"] = 262.5, ["Fly|Ride"] = 341.25, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 916.13, ["Mega"] = 12560.93, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 3.02, ["Neon"] = 41.76, ["Neon|Ride"] = 137.16, ["Mega"] = 99.75, ["Mega|Fly"] = 279.49, ["Mega|Ride"] = 185.63}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 10.39, ["Ride"] = 36.66, ["Neon"] = 24.05, ["Neon|Fly|Ride"] = 209.36, ["Mega"] = 91.87, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.31, ["Fly"] = 155.57, ["Ride"] = 27.57, ["Neon"] = 32.82, ["Mega"] = 517.79, ["Mega|Ride"] = 337.84}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 28.28, ["Ride"] = 20.95, ["Fly|Ride"] = 79.58, ["Neon"] = 6.2, ["Neon|Ride"] = 31.42, ["Neon|Fly|Ride"] = 90.37, ["Mega"] = 51.19, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 236.23}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 36.58, ["Fly|Ride"] = 209.39, ["Neon"] = 7.87, ["Neon|Ride"] = 52.5, ["Mega"] = 36.54, ["Mega|Fly"] = 140.28, ["Mega|Ride"] = 204.12}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 18.38, ["Fly|Ride"] = 41.94, ["Neon"] = 5.25, ["Neon|Fly"] = 47.21, ["Neon|Ride"] = 28.28, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 38.07, ["Mega|Ride"] = 95.27, ["Mega|Fly|Ride"] = 112.11}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 20.95, ["Fly|Ride"] = 40.57, ["Neon"] = 6.62, ["Neon|Fly"] = 73.16, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 91.08, ["Mega"] = 170.63, ["Mega|Ride"] = 209.36, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 32.45, ["Ride"] = 52.49, ["Fly|Ride"] = 83.65, ["Neon"] = 207.31, ["Neon|Ride"] = 236, ["Mega"] = 393.75, ["Mega|Fly"] = 498.75, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 724.42}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 84.96, ["Fly"] = 582.75, ["Ride"] = 102.38, ["Fly|Ride"] = 418.76, ["Neon"] = 363.57, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 698.2, ["Mega"] = 3146.6, ["Mega|Ride"] = 2230.62, ["Mega|Fly|Ride"] = 2052.67}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 23.23, ["Fly|Ride"] = 131.25, ["Neon"] = 6.29, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.57, ["Mega"] = 53.44, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 87.94}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 16.77, ["Ride"] = 17.07, ["Fly|Ride"] = 30.16, ["Neon"] = 3.97, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 24.1, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 42, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 4.3, ["Ride"] = 27.26, ["Fly|Ride"] = 140.3, ["Neon"] = 121.45, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 105, ["Mega"] = 626.82, ["Mega|Ride"] = 349.63, ["Mega|Fly|Ride"] = 472.38}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 363.82, ["Fly"] = 393.75, ["Ride"] = 461.69, ["Fly|Ride"] = 459.38, ["Neon|Ride"] = 1465.64, ["Neon|Fly|Ride"] = 1569.08, ["Mega"] = 7865.87, ["Mega|Fly|Ride"] = 5233.73}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 28.88, ["Fly"] = 140.3, ["Ride"] = 67.04, ["Fly|Ride"] = 103.69, ["Neon"] = 223.13, ["Neon|Ride"] = 262.01, ["Neon|Fly|Ride"] = 279.49, ["Mega"] = 1073.98, ["Mega|Ride"] = 1010.63, ["Mega|Fly|Ride"] = 1001.94}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Fly|Ride"] = 77.47, ["Neon"] = 10.5, ["Neon|Ride"] = 62.83, ["Neon|Fly|Ride"] = 98.48, ["Mega"] = 84, ["Mega|Ride"] = 120.38, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 209.39, ["Ride"] = 28.87, ["Fly|Ride"] = 142.7, ["Neon"] = 71.21, ["Neon|Ride"] = 167.51, ["Mega"] = 195.76}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 36.75, ["Fly"] = 77.48, ["Ride"] = 41.89, ["Fly|Ride"] = 62.83, ["Neon|Fly"] = 313.03, ["Neon|Ride"] = 158.1, ["Neon|Fly|Ride"] = 448.02, ["Mega"] = 2512.2, ["Mega|Ride"] = 942.09, ["Mega|Fly|Ride"] = 1258.89}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 104.69, ["Ride"] = 98.74, ["Fly|Ride"] = 144.38, ["Neon"] = 414.87, ["Neon|Ride"] = 468.96, ["Neon|Fly|Ride"] = 479.07, ["Mega"] = 3071.16, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 251.69, ["Fly"] = 277.31, ["Ride"] = 248.07, ["Fly|Ride"] = 392.59, ["Neon|Ride"] = 872.82, ["Neon|Fly|Ride"] = 930.57, ["Mega|Fly|Ride"] = 2999.98}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 11.81, ["Ride"] = 7328.11, ["Fly|Ride"] = 213.59, ["Neon"] = 145.68, ["Neon|Ride"] = 136.48, ["Neon|Fly|Ride"] = 292.61, ["Mega"] = 387.45, ["Mega|Ride"] = 405.11, ["Mega|Fly|Ride"] = 574.59}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.28, ["Ride"] = 17.18, ["Fly|Ride"] = 40.05, ["Neon"] = 15.53, ["Neon|Ride"] = 27.23, ["Neon|Fly|Ride"] = 83.75, ["Mega"] = 90.57, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 6.28, ["Fly"] = 33.51, ["Ride"] = 25.87, ["Fly|Ride"] = 45.94, ["Neon"] = 37.7, ["Neon|Fly"] = 146.57, ["Neon|Ride"] = 47.16, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 249.38, ["Mega|Ride"] = 232.32, ["Mega|Fly|Ride"] = 362.19}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 255.94, ["Ride"] = 315, ["Fly|Ride"] = 406.88, ["Neon"] = 1465.53, ["Neon|Ride"] = 1029.11, ["Neon|Fly|Ride"] = 1049.99, ["Mega|Fly|Ride"] = 4745.94}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 46.08, ["Neon"] = 8.4, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 48.49, ["Mega|Ride"] = 157.03, ["Mega|Fly|Ride"] = 416.62}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 4.41, ["Ride"] = 18.38, ["Fly|Ride"] = 66.07, ["Neon"] = 41.64, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 166.69, ["Mega|Fly"] = 204.9, ["Mega|Fly|Ride"] = 314.89}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 18.85, ["Ride"] = 116.76, ["Neon"] = 104.9, ["Neon|Fly"] = 418.76, ["Neon|Ride"] = 152.25, ["Neon|Fly|Ride"] = 209.36, ["Mega"] = 466.48, ["Mega|Ride"] = 496.55, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 131.14, ["Fly"] = 278.44, ["Ride"] = 141.47, ["Fly|Ride"] = 195.78, ["Neon|Ride"] = 727.13, ["Neon|Fly|Ride"] = 643.19, ["Mega|Fly|Ride"] = 2926.71}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 25.6, ["Fly"] = 45.05, ["Ride"] = 28.88, ["Fly|Ride"] = 49.22, ["Neon"] = 76.13, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 144.46, ["Mega"] = 397.78, ["Mega|Ride"] = 417.67, ["Mega|Fly|Ride"] = 366.19}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 56.55, ["Neon"] = 2.88, ["Neon|Ride"] = 201.76, ["Neon|Fly|Ride"] = 698.2, ["Mega"] = 41.89, ["Mega|Ride"] = 103.64, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 17.71, ["Fly|Ride"] = 72.19, ["Neon"] = 3.87, ["Neon|Fly"] = 158.12, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 69.18, ["Mega"] = 32.82, ["Mega|Fly"] = 140.36, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 102.6}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 7.88, ["Fly"] = 418.69, ["Ride"] = 61.69, ["Fly|Ride"] = 154.95, ["Neon"] = 30.18, ["Neon|Ride"] = 73.41, ["Neon|Fly|Ride"] = 153.57, ["Mega"] = 147, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 279.49}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1434.57, ["Ride"] = 1311.19, ["Fly|Ride"] = 1309.87, ["Neon|Ride"] = 6978.65, ["Neon|Fly|Ride"] = 4462.5, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 405.57, ["Ride"] = 459.38, ["Fly|Ride"] = 618.19, ["Neon"] = 1903.11, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 2203.91, ["Mega"] = 14157.85, ["Mega|Fly|Ride"] = 7084.87}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 308.39, ["Fly"] = 371.44, ["Ride"] = 342.7, ["Fly|Ride"] = 419.88, ["Neon"] = 735, ["Neon|Fly"] = 1258.99, ["Neon|Ride"] = 623.44, ["Neon|Fly|Ride"] = 761.25, ["Mega|Fly|Ride"] = 2903.69}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 330.64, ["Ride"] = 378.89, ["Fly|Ride"] = 501.78, ["Neon"] = 1023.75, ["Neon|Fly"] = 3146.84, ["Neon|Ride"] = 1041.65, ["Neon|Fly|Ride"] = 1090.69, ["Mega|Ride"] = 3674.99, ["Mega|Fly|Ride"] = 4040.45}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 57.74, ["Ride"] = 17.05, ["Fly|Ride"] = 44.63, ["Neon"] = 6.89, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 106.79, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 360.94, ["Ride"] = 472.5, ["Fly|Ride"] = 577.5, ["Neon"] = 1312.5, ["Neon|Ride"] = 1279.69, ["Neon|Fly|Ride"] = 1509.38, ["Mega"] = 13084.3, ["Mega|Fly|Ride"] = 5010.77}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.1, ["Fly"] = 183.75, ["Ride"] = 25.14, ["Neon"] = 10.49, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 112.02, ["Mega"] = 65.63, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 208.04}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.05, ["Fly"] = 20.95, ["Ride"] = 20.94, ["Fly|Ride"] = 39.38, ["Neon"] = 15.72, ["Neon|Ride"] = 49, ["Neon|Fly|Ride"] = 107.31, ["Mega"] = 90.09, ["Mega|Ride"] = 192.93, ["Mega|Fly|Ride"] = 314.74}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Ride"] = 19.69, ["Neon"] = 3.78, ["Neon|Fly"] = 79.07, ["Neon|Ride"] = 39.37, ["Mega"] = 31.49, ["Mega|Fly"] = 70.16, ["Mega|Ride"] = 46.03, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 39.29, ["Ride"] = 65.63, ["Fly|Ride"] = 459.38, ["Neon"] = 244.13, ["Neon|Ride"] = 349.67, ["Neon|Fly|Ride"] = 208.31, ["Mega"] = 1674.8, ["Mega|Fly|Ride"] = 977.67}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 31.87, ["Fly|Ride"] = 60.44, ["Neon"] = 106.21, ["Mega"] = 328.13, ["Mega|Ride"] = 233.63}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.12, ["Neon"] = 3.93, ["Neon|Fly"] = 91.77, ["Neon|Ride"] = 36.58, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 35.41, ["Mega|Fly"] = 698.2, ["Mega|Ride"] = 91.68, ["Mega|Fly|Ride"] = 309.07}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 32.45, ["Ride"] = 24, ["Fly|Ride"] = 41.5, ["Neon"] = 6.46, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 33.54, ["Neon|Fly|Ride"] = 70.24, ["Mega"] = 61.67, ["Mega|Fly"] = 175.14, ["Mega|Ride"] = 82.85, ["Mega|Fly|Ride"] = 140.28}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.81, ["Fly"] = 47.2, ["Ride"] = 21.25, ["Fly|Ride"] = 51.45, ["Neon"] = 104.7, ["Neon|Fly"] = 141.6, ["Neon|Ride"] = 140.3, ["Neon|Fly|Ride"] = 128.61, ["Mega"] = 237.57, ["Mega|Ride"] = 300.51, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 4.73, ["Ride"] = 52.5, ["Neon|Ride"] = 279.49, ["Neon|Fly|Ride"] = 311.49, ["Mega"] = 349.63, ["Mega|Ride"] = 349.63, ["Mega|Fly|Ride"] = 349.63}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 3.93, ["Ride"] = 27.2, ["Fly|Ride"] = 70.16, ["Neon"] = 47.25, ["Neon|Ride"] = 97.96, ["Neon|Fly|Ride"] = 279.49, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 22.53, ["Ride"] = 19.69, ["Fly|Ride"] = 55.47, ["Neon"] = 3.93, ["Neon|Fly"] = 31.42, ["Neon|Ride"] = 26.25, ["Mega"] = 43.32, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 314.05}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 196.87, ["Fly"] = 363.27, ["Ride"] = 258.57, ["Fly|Ride"] = 288.75, ["Neon|Ride"] = 1137.83, ["Neon|Fly|Ride"] = 1103.28, ["Mega"] = 10467.44, ["Mega|Fly|Ride"] = 4869.12}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 35.61, ["Ride"] = 19.59, ["Fly|Ride"] = 35.41, ["Neon"] = 3.35, ["Neon|Fly"] = 20.95, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 55.13, ["Mega"] = 49.56, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 11.82, ["Ride"] = 26.25, ["Fly|Ride"] = 182.28, ["Neon"] = 70.16, ["Neon|Ride"] = 100.64, ["Mega"] = 389.41, ["Mega|Ride"] = 454.31, ["Mega|Fly|Ride"] = 698.2}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 38.62, ["Fly"] = 131.25, ["Ride"] = 104.7, ["Fly|Ride"] = 170.63, ["Neon"] = 262.49, ["Neon|Ride"] = 293.1, ["Neon|Fly|Ride"] = 152.84, ["Mega"] = 837.41, ["Mega|Ride"] = 807.06, ["Mega|Fly|Ride"] = 837.41}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 183.75, ["Ride"] = 225.75, ["Fly|Ride"] = 249.38, ["Neon"] = 787.02, ["Neon|Ride"] = 651, ["Neon|Fly|Ride"] = 695.63, ["Mega|Ride"] = 3352.05, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 17.07, ["Fly"] = 168.88, ["Neon"] = 82.69, ["Neon|Ride"] = 279.49, ["Mega"] = 285.48, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 698.2}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 32.45, ["Ride"] = 418.76, ["Fly|Ride"] = 158.82, ["Neon"] = 291.04, ["Neon|Fly|Ride"] = 837.41, ["Mega"] = 656.25, ["Mega|Fly|Ride"] = 935.82}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1050, ["Fly"] = 1441.13, ["Ride"] = 1181.25, ["Fly|Ride"] = 1155, ["Neon|Ride"] = 5025, ["Neon|Fly|Ride"] = 5053.13, ["Mega|Fly|Ride"] = 17028.43}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 8.44, ["Fly"] = 27.24, ["Ride"] = 21.95, ["Fly|Ride"] = 53.41, ["Neon"] = 79.06, ["Neon|Fly"] = 75.06, ["Neon|Ride"] = 70.81, ["Neon|Fly|Ride"] = 200.82, ["Mega"] = 221.92, ["Mega|Ride"] = 228.2, ["Mega|Fly|Ride"] = 388.5}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 5.75, ["Fly"] = 13769.7, ["Ride"] = 35.43, ["Neon"] = 37.71, ["Neon|Ride"] = 140.3, ["Mega"] = 212.63, ["Mega|Ride"] = 174.48, ["Mega|Fly|Ride"] = 418.71}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 5.24, ["Ride"] = 31.87, ["Fly|Ride"] = 91.09, ["Neon"] = 61.8, ["Neon|Ride"] = 59.07, ["Mega"] = 252.77, ["Mega|Ride"] = 418.69, ["Mega|Fly|Ride"] = 625.96}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 15.75, ["Fly"] = 698.29, ["Ride"] = 39.38, ["Fly|Ride"] = 98.41, ["Neon"] = 87.94, ["Neon|Ride"] = 95.27, ["Neon|Fly|Ride"] = 211.62, ["Mega"] = 523.39, ["Mega|Ride"] = 418.71, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.1, ["Fly"] = 28.28, ["Ride"] = 24.1, ["Fly|Ride"] = 66.09, ["Neon"] = 21.87, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 86.9, ["Mega|Ride"] = 273.26, ["Mega|Fly|Ride"] = 412.95}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Fly"] = 413.48, ["Neon"] = 15.73, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 54.07, ["Neon|Fly|Ride"] = 140.28, ["Mega"] = 232.39, ["Mega|Ride"] = 134.97, ["Mega|Fly|Ride"] = 354.86}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 283.5, ["Ride"] = 314.64, ["Fly|Ride"] = 335.02, ["Neon|Ride"] = 1465.64, ["Neon|Fly|Ride"] = 1396.38, ["Mega|Ride"] = 5250, ["Mega|Fly|Ride"] = 4856.91}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 3.94, ["Fly"] = 39.38, ["Ride"] = 28.28, ["Fly|Ride"] = 59.07, ["Neon"] = 14.3, ["Neon|Fly"] = 83.76, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 97.55, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 870.91}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 6.56, ["Ride"] = 66.95, ["Neon|Ride"] = 188.27, ["Mega"] = 276.35, ["Mega|Ride"] = 265.89}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 4.2, ["Fly"] = 58.43, ["Ride"] = 40.11, ["Neon"] = 21.25, ["Neon|Fly"] = 70.16, ["Neon|Ride"] = 140.28, ["Neon|Fly|Ride"] = 279.78, ["Mega"] = 166.45, ["Mega|Fly"] = 418.71, ["Mega|Ride"] = 125.63, ["Mega|Fly|Ride"] = 288.25}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 209.67, ["Fly"] = 354.9, ["Ride"] = 307.13, ["Fly|Ride"] = 420, ["Neon"] = 774.38, ["Neon|Ride"] = 853.13, ["Neon|Fly|Ride"] = 913.19, ["Mega|Ride"] = 2930.9, ["Mega|Fly|Ride"] = 2165.63}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 17.71, ["Fly"] = 61.78, ["Ride"] = 39.38, ["Fly|Ride"] = 158.82, ["Neon"] = 136.11, ["Neon|Ride"] = 161.23, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 558.97, ["Mega|Ride"] = 628.06, ["Mega|Fly|Ride"] = 715.32}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 23.46, ["Ride"] = 36.66, ["Fly|Ride"] = 1256.26, ["Neon"] = 136.11, ["Neon|Ride"] = 133.88, ["Neon|Fly|Ride"] = 217.93, ["Mega"] = 417.38, ["Mega|Ride"] = 558.97}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.44, ["Mega"] = 30.83, ["Mega|Ride"] = 221.92, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 78.58, ["Fly"] = 125.09, ["Ride"] = 98.47, ["Fly|Ride"] = 251.27, ["Neon"] = 391.54, ["Neon|Fly"] = 471.77, ["Neon|Fly|Ride"] = 391.12, ["Mega|Fly|Ride"] = 1207.29}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 18.83, ["Neon"] = 5.25, ["Neon|Ride"] = 56.55, ["Neon|Fly|Ride"] = 588, ["Mega"] = 37.7, ["Mega|Ride"] = 209.36}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 17.07, ["Fly"] = 126.27, ["Ride"] = 28.88, ["Fly|Ride"] = 88.51, ["Neon"] = 86.9, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 140.28, ["Mega"] = 389.82, ["Mega|Ride"] = 408.19, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 43.3, ["Fly"] = 79.92, ["Ride"] = 90.03, ["Fly|Ride"] = 147, ["Neon"] = 199.29, ["Neon|Ride"] = 278.67, ["Neon|Fly|Ride"] = 346.98, ["Mega"] = 1150.38, ["Mega|Ride"] = 1213.2, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 19.67, ["Ride"] = 16.77, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 27.72, ["Neon|Ride"] = 17.71, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 28.28, ["Mega|Fly"] = 55.13, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 76.13}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.68, ["Ride"] = 31.87, ["Fly|Ride"] = 112.88, ["Neon"] = 23.05, ["Neon|Ride"] = 94.39, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 177.19, ["Mega|Ride"] = 209.36, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 16.2, ["Fly"] = 42.49, ["Ride"] = 56.44, ["Neon"] = 131.25, ["Neon|Ride"] = 349.67, ["Neon|Fly|Ride"] = 630.04, ["Mega"] = 586.69, ["Mega|Ride"] = 530.72, ["Mega|Fly|Ride"] = 651}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.77, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 136.1, ["Mega"] = 23.62, ["Mega|Ride"] = 73.5}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 3.87, ["Fly"] = 210, ["Ride"] = 41.89, ["Fly|Ride"] = 111.57, ["Neon"] = 73.5, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 312.99, ["Mega"] = 301.88, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 272.18, ["Mega|Fly|Ride"] = 551.64}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 140.31, ["Fly"] = 41.93, ["Ride"] = 23.63, ["Fly|Ride"] = 167.51, ["Neon"] = 136.5, ["Neon|Ride"] = 64.56, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 558.97, ["Mega|Fly|Ride"] = 1115.77}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 2.1, ["Ride"] = 58.98, ["Fly|Ride"] = 76.01, ["Neon"] = 25.7, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 162.29, ["Mega"] = 182.15, ["Mega|Ride"] = 197.33, ["Mega|Fly|Ride"] = 283.68}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 15.61, ["Fly"] = 2093.76, ["Ride"] = 79.08, ["Neon"] = 91.88, ["Neon|Ride"] = 388.5, ["Neon|Fly|Ride"] = 6291.99, ["Mega"] = 698.2, ["Mega|Ride"] = 418.71, ["Mega|Fly|Ride"] = 1149.11}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 125.58, ["Fly|Ride"] = 196.88, ["Neon"] = 6.57, ["Neon|Fly"] = 50.27, ["Neon|Ride"] = 70.16, ["Mega"] = 74.82, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 125.63, ["Mega|Fly|Ride"] = 519.2}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 28.28, ["Neon"] = 3.82, ["Mega"] = 26.17, ["Mega|Ride"] = 154.93, ["Mega|Fly|Ride"] = 434.42}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 36.66}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 62.83, ["Fly"] = 102.38, ["Ride"] = 78.75, ["Fly|Ride"] = 209.39, ["Neon"] = 1050, ["Neon|Fly|Ride"] = 558.97, ["Mega"] = 1103.28, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 780.93}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 84, ["Fly|Ride"] = 140.3, ["Neon"] = 3.15, ["Mega"] = 26.24, ["Mega|Fly"] = 137.82, ["Mega|Ride"] = 104.69, ["Mega|Fly|Ride"] = 149.63}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 506.63, ["Fly"] = 795.64, ["Ride"] = 472.49, ["Fly|Ride"] = 470.4, ["Neon"] = 2625, ["Neon|Fly|Ride"] = 2044.92, ["Mega"] = 16747.9, ["Mega|Fly|Ride"] = 13957.29}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 2.86, ["Fly"] = 24.94, ["Ride"] = 19.69, ["Fly|Ride"] = 82.72, ["Neon"] = 12.85, ["Neon|Ride"] = 276.4, ["Mega"] = 74.33, ["Mega|Ride"] = 140.28, ["Mega|Fly|Ride"] = 558.97}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 3.93, ["Fly"] = 158.13, ["Ride"] = 19.91, ["Fly|Ride"] = 55.13, ["Neon"] = 19.67, ["Neon|Ride"] = 37.7, ["Neon|Fly|Ride"] = 97.67, ["Mega"] = 278.44, ["Mega|Ride"] = 140.28, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 14.43, ["Ride"] = 76.13, ["Fly|Ride"] = 106.31, ["Neon"] = 91.88, ["Neon|Ride"] = 181.13, ["Mega"] = 502.45, ["Mega|Ride"] = 468.96, ["Mega|Fly|Ride"] = 540.14}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.91, ["Fly"] = 131.25, ["Ride"] = 31.5, ["Fly|Ride"] = 43.32, ["Mega"] = 255.94, ["Mega|Ride"] = 278.44}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 7.87, ["Ride"] = 65.63, ["Fly|Ride"] = 157.47, ["Neon"] = 78.66, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 279.49, ["Mega"] = 461.63, ["Mega|Ride"] = 463.73, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 5.99, ["Fly"] = 104.98, ["Ride"] = 46.04, ["Fly|Ride"] = 188.45, ["Neon"] = 51.19, ["Neon|Ride"] = 140.3, ["Neon|Fly|Ride"] = 140.28, ["Mega"] = 168, ["Mega|Fly"] = 485.7, ["Mega|Ride"] = 221.82}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.72, ["Fly|Ride"] = 39.11, ["Neon"] = 2.1, ["Neon|Ride"] = 20.94, ["Neon|Fly|Ride"] = 74.72, ["Mega"] = 19.67, ["Mega|Fly"] = 55.13, ["Mega|Ride"] = 28.29, ["Mega|Fly|Ride"] = 145.04}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 10.5, ["Ride"] = 27.57, ["Fly|Ride"] = 158.13, ["Neon"] = 27.57, ["Neon|Fly"] = 118, ["Neon|Ride"] = 70.16, ["Neon|Fly|Ride"] = 314.05, ["Mega"] = 189, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 342.3}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 300.57, ["Ride"] = 328.13, ["Fly|Ride"] = 393.75, ["Neon"] = 1480.5, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1116.89, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 91.88, ["Ride"] = 149.63, ["Fly|Ride"] = 182.17, ["Neon|Ride"] = 502.88, ["Neon|Fly|Ride"] = 623.44, ["Mega"] = 4187, ["Mega|Ride"] = 1716.68, ["Mega|Fly|Ride"] = 1603.88}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.05, ["Fly"] = 23.05, ["Ride"] = 17.71, ["Fly|Ride"] = 39.38, ["Neon"] = 19.69, ["Neon|Fly"] = 41.89, ["Neon|Ride"] = 33.51, ["Neon|Fly|Ride"] = 62.67, ["Mega"] = 98.41, ["Mega|Fly"] = 208.31, ["Mega|Ride"] = 91.08, ["Mega|Fly|Ride"] = 153.08}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 15.72, ["Ride"] = 15.72, ["Fly|Ride"] = 41.89, ["Neon"] = 5.55, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 85.32, ["Mega|Fly"] = 349.63, ["Mega|Ride"] = 116.21, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 38.07, ["Neon|Fly|Ride"] = 418.71, ["Mega"] = 140.28, ["Mega|Ride"] = 208.31, ["Mega|Fly|Ride"] = 268.82}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 231.86, ["Ride"] = 237.57, ["Fly|Ride"] = 231, ["Neon|Ride"] = 944.99, ["Neon|Fly|Ride"] = 1255.06, ["Mega|Ride"] = 8373.96, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 33.52, ["Ride"] = 17.26, ["Fly|Ride"] = 44.71, ["Neon"] = 24.1, ["Neon|Fly"] = 158.12, ["Neon|Ride"] = 41.89, ["Neon|Fly|Ride"] = 122.07, ["Mega"] = 279.49, ["Mega|Ride"] = 255.42, ["Mega|Fly|Ride"] = 262.48}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 5.24, ["Fly"] = 158.12, ["Ride"] = 96.48, ["Fly|Ride"] = 209.39, ["Neon"] = 26.25, ["Neon|Ride"] = 74.85, ["Mega"] = 196.88, ["Mega|Ride"] = 236.24, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.93, ["Neon|Ride"] = 30.32, ["Mega"] = 43.14, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 20.79, ["Ride"] = 27.57, ["Fly|Ride"] = 79.58, ["Neon"] = 112.11, ["Neon|Ride"] = 101.49, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 728.34, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 360.78}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 64.22, ["Ride"] = 89.25, ["Fly|Ride"] = 210, ["Neon"] = 158.12, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 178.5, ["Neon|Fly|Ride"] = 312.38, ["Mega"] = 459.38, ["Mega|Fly"] = 2198.18, ["Mega|Ride"] = 555.18, ["Mega|Fly|Ride"] = 622.12}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 15.74, ["Fly"] = 158.12, ["Ride"] = 41.89, ["Fly|Ride"] = 81.36, ["Neon"] = 118.31, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 182.13, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 785.08, ["Mega|Ride"] = 786.51, ["Mega|Fly|Ride"] = 943.88}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 17.67, ["Ride"] = 15.72, ["Fly|Ride"] = 39.35, ["Neon"] = 2.1, ["Neon|Fly"] = 18.69, ["Neon|Ride"] = 20.95, ["Neon|Fly|Ride"] = 61.78, ["Mega"] = 24.94, ["Mega|Fly"] = 412.5, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 114.35}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 205.31, ["Fly"] = 278.25, ["Ride"] = 279.54, ["Fly|Ride"] = 392.44, ["Neon"] = 1256.26, ["Neon|Ride"] = 958.13, ["Neon|Fly|Ride"] = 1086.68, ["Mega|Fly|Ride"] = 3937.49}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 13.52, ["Fly"] = 140.3, ["Ride"] = 45.94, ["Neon"] = 105, ["Neon|Ride"] = 158.12, ["Neon|Fly|Ride"] = 321.56, ["Mega|Fly|Ride"] = 589.32}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 16.37, ["Ride"] = 18.36, ["Fly|Ride"] = 39.31, ["Neon"] = 10.5, ["Neon|Fly"] = 27.57, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 110.97, ["Mega"] = 49.24, ["Mega|Fly"] = 179.01, ["Mega|Ride"] = 140.42, ["Mega|Fly|Ride"] = 299.69}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.05, ["Fly"] = 28.28, ["Ride"] = 17.07, ["Fly|Ride"] = 56.55, ["Neon"] = 3.14, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 18.87, ["Neon|Fly|Ride"] = 97.67, ["Mega"] = 24.93, ["Mega|Fly"] = 141.59, ["Mega|Ride"] = 53.41, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 19.28, ["Fly|Ride"] = 91.09, ["Neon"] = 9.12, ["Neon|Ride"] = 41.89, ["Neon|Fly|Ride"] = 6978.65, ["Mega"] = 93.08, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 383.13}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 10.9, ["Fly"] = 38.68, ["Ride"] = 28.28, ["Fly|Ride"] = 50.76, ["Neon"] = 56.55, ["Neon|Ride"] = 64.22, ["Neon|Fly|Ride"] = 123.37, ["Mega"] = 352.78, ["Mega|Fly"] = 786.95, ["Mega|Ride"] = 279.57, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 15.73, ["Fly|Ride"] = 72.19, ["Neon"] = 45.94, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 262.5, ["Mega|Ride"] = 320.33, ["Mega|Fly|Ride"] = 308.8}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Fly"] = 20.95, ["Ride"] = 44.63, ["Neon"] = 3.83, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 84, ["Mega"] = 25.2, ["Mega|Ride"] = 78.52}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 9.71, ["Ride"] = 36.66, ["Fly|Ride"] = 56.55, ["Neon"] = 21, ["Neon|Fly"] = 102.8, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 125.63, ["Mega"] = 157.5, ["Mega|Fly"] = 265.89, ["Mega|Ride"] = 265.89, ["Mega|Fly|Ride"] = 283.4}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 125.64, ["Fly|Ride"] = 98.42, ["Neon"] = 3.94, ["Neon|Fly"] = 98.42, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 158.1, ["Mega"] = 47.25, ["Mega|Ride"] = 91.34, ["Mega|Fly|Ride"] = 315.03}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 24.66, ["Ride"] = 17.7, ["Fly|Ride"] = 83.91, ["Neon"] = 3.93, ["Neon|Ride"] = 30.7, ["Neon|Fly|Ride"] = 83.83, ["Mega"] = 63, ["Mega|Ride"] = 76.11, ["Mega|Fly|Ride"] = 179.41}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 665.44, ["Ride"] = 756, ["Fly|Ride"] = 695.62, ["Neon"] = 4169.7, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 3324.92, ["Mega|Ride"] = 15353.64, ["Mega|Fly|Ride"] = 12462.19}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.05, ["Fly"] = 19.38, ["Ride"] = 19.46, ["Fly|Ride"] = 49.22, ["Neon"] = 27.24, ["Neon|Fly"] = 50.27, ["Neon|Ride"] = 31.87, ["Neon|Fly|Ride"] = 99.07, ["Mega"] = 187.38, ["Mega|Fly|Ride"] = 209.36}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 37.78, ["Fly|Ride"] = 104.7, ["Neon"] = 7.48, ["Neon|Fly"] = 837.51, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 51.19, ["Mega|Ride"] = 103.37, ["Mega|Fly|Ride"] = 155.81}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 7.71, ["Fly"] = 32.82, ["Ride"] = 18.73, ["Fly|Ride"] = 53.6, ["Neon"] = 53.42, ["Neon|Fly"] = 112.03, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 328.13, ["Mega|Ride"] = 307.13, ["Mega|Fly|Ride"] = 335.99}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 12.58, ["Fly|Ride"] = 28.88, ["Neon"] = 6.57, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 56.58, ["Mega"] = 85.32, ["Mega|Fly"] = 349.84, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 178.68}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 52.41, ["Ride"] = 163.32, ["Fly|Ride"] = 208.34, ["Neon"] = 291.37, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 678.32, ["Mega|Ride"] = 823.8, ["Mega|Fly|Ride"] = 763.35}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 87.95, ["Neon"] = 7.74, ["Neon|Fly"] = 134.52, ["Neon|Ride"] = 36.64, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 61.69, ["Mega|Ride"] = 138.18, ["Mega|Fly|Ride"] = 351.75}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 73.48, ["Ride"] = 23.5, ["Fly|Ride"] = 60.74, ["Neon"] = 17.69, ["Neon|Fly"] = 141.6, ["Neon|Ride"] = 39.8, ["Neon|Fly|Ride"] = 448.02, ["Mega"] = 140.34, ["Mega|Ride"] = 140.52, ["Mega|Fly|Ride"] = 152.13}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 65.76, ["Neon"] = 15.72, ["Neon|Fly"] = 63.73, ["Neon|Ride"] = 110.92, ["Mega"] = 116.17, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Ride"] = 20.95, ["Fly|Ride"] = 83.76, ["Neon"] = 4.76, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 29.89, ["Neon|Fly|Ride"] = 91.1, ["Mega"] = 54.45, ["Mega|Fly"] = 177.96, ["Mega|Ride"] = 77.43, ["Mega|Fly|Ride"] = 169.91}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 15.61, ["Fly"] = 37.75, ["Ride"] = 18.86, ["Fly|Ride"] = 45.94, ["Neon"] = 137.82, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 122.07, ["Mega"] = 837.41, ["Mega|Ride"] = 462.68, ["Mega|Fly|Ride"] = 399.89}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 736.75, ["Ride"] = 746.82, ["Fly|Ride"] = 838.69, ["Neon"] = 1938.56, ["Neon|Ride"] = 1928.28, ["Neon|Fly|Ride"] = 1998.94, ["Mega"] = 8192.68, ["Mega|Ride"] = 7481.25, ["Mega|Fly|Ride"] = 5904.94}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 18.88, ["Ride"] = 15.72, ["Fly|Ride"] = 15.72, ["Neon"] = 6.14, ["Neon|Fly"] = 139.19, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 60.38, ["Mega|Ride"] = 193.39, ["Mega|Fly|Ride"] = 269.72}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 4.73, ["Ride"] = 38.67, ["Fly|Ride"] = 92.14, ["Neon"] = 56.22, ["Neon|Fly"] = 140.3, ["Neon|Ride"] = 104.7, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 328.13, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 530.72}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 61.69, ["Ride"] = 85.32, ["Fly|Ride"] = 140.3, ["Neon"] = 376.89, ["Neon|Ride"] = 412.95, ["Neon|Fly|Ride"] = 397.78, ["Mega"] = 1535.59, ["Mega|Ride"] = 1535.59, ["Mega|Fly|Ride"] = 1604.64}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 44.51, ["Ride"] = 62.83, ["Fly|Ride"] = 140.3, ["Neon"] = 165.42, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 279.49, ["Mega"] = 1940.68, ["Mega|Ride"] = 837.41, ["Mega|Fly|Ride"] = 1045.72}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 15, ["Ride"] = 24.94, ["Neon"] = 91.88, ["Neon|Ride"] = 158.12, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 334.97, ["Mega|Ride"] = 363.24, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 28.3, ["Ride"] = 94.23, ["Neon"] = 41.89, ["Neon|Fly"] = 362.24, ["Neon|Ride"] = 362.24, ["Mega"] = 456.1, ["Mega|Fly"] = 512.06, ["Mega|Ride"] = 418.71, ["Mega|Fly|Ride"] = 526.98}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 19.67, ["Fly"] = 63, ["Ride"] = 104.7, ["Neon"] = 157.5, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 525, ["Mega"] = 924, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 1045.72}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 19.69}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 5.86, ["Fly"] = 131248.69, ["Ride"] = 31.42, ["Fly|Ride"] = 78.75, ["Neon"] = 36.66, ["Neon|Ride"] = 98.41, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 189, ["Mega|Fly"] = 519.75, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 238.33}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.1, ["Ride"] = 47.21, ["Neon"] = 36.75, ["Mega"] = 348.06, ["Mega|Fly|Ride"] = 942.09}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 69.5, ["Fly"] = 393.75, ["Ride"] = 102.67, ["Fly|Ride"] = 123.66, ["Neon"] = 335.02, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 348.06, ["Mega"] = 977.67, ["Mega|Ride"] = 917.44, ["Mega|Fly|Ride"] = 1046.76}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.84, ["Fly"] = 27.16, ["Ride"] = 18.15, ["Fly|Ride"] = 43.32, ["Neon"] = 26.17, ["Neon|Fly"] = 41.89, ["Neon|Ride"] = 28.86, ["Neon|Fly|Ride"] = 77.22, ["Mega"] = 262.5, ["Mega|Fly"] = 417.67, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 4.73, ["Fly"] = 83.75, ["Ride"] = 37.78, ["Fly|Ride"] = 72.19, ["Neon"] = 27.26, ["Neon|Ride"] = 53.41, ["Neon|Fly|Ride"] = 161.21, ["Mega"] = 153.77, ["Mega|Ride"] = 192.94, ["Mega|Fly|Ride"] = 267.75}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 5.87, ["Neon|Ride"] = 92.14, ["Mega"] = 62.83, ["Mega|Ride"] = 140.38, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 41.31, ["Fly"] = 65.63, ["Ride"] = 48.57, ["Fly|Ride"] = 91.87, ["Neon"] = 221.82, ["Neon|Ride"] = 232.42, ["Neon|Fly|Ride"] = 279.49, ["Mega"] = 1116.89, ["Mega|Ride"] = 836.36, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 23.73, ["Fly|Ride"] = 83.76, ["Neon"] = 12.99, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 85.85, ["Mega"] = 92.05, ["Mega|Ride"] = 47.21, ["Mega|Fly|Ride"] = 309.68}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 11.81, ["Ride"] = 60.74, ["Neon"] = 98.42, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 349.63, ["Mega"] = 288.75, ["Mega|Ride"] = 558.97, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 18.87, ["Ride"] = 17.05, ["Fly|Ride"] = 33.52, ["Neon"] = 10.48, ["Neon|Ride"] = 28.24, ["Neon|Fly|Ride"] = 77.47, ["Mega"] = 205.31, ["Mega|Ride"] = 234.29, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 20.9, ["Fly|Ride"] = 52.5, ["Neon"] = 157.5, ["Neon|Ride"] = 177.19, ["Mega"] = 278.44, ["Mega|Ride"] = 244.95, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.7, ["Ride"] = 36.53, ["Neon"] = 31.4, ["Neon|Ride"] = 110.93, ["Mega"] = 140.28, ["Mega|Ride"] = 830.17}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 36.75, ["Ride"] = 105, ["Neon"] = 208.69, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 868.1, ["Mega|Ride"] = 1396.38, ["Mega|Fly|Ride"] = 1640.63}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 17.71, ["Ride"] = 140.3, ["Neon"] = 210, ["Neon|Fly|Ride"] = 251.23, ["Mega"] = 389.82, ["Mega|Fly|Ride"] = 498.1}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 10.4, ["Ride"] = 104.89, ["Fly|Ride"] = 279.54, ["Neon"] = 167.51, ["Mega|Ride"] = 551.64, ["Mega|Fly|Ride"] = 1674.8}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 23.62, ["Ride"] = 56.62, ["Fly|Ride"] = 418.76, ["Neon"] = 94.5, ["Neon|Ride"] = 111.39, ["Neon|Fly|Ride"] = 452.21, ["Mega"] = 678.32, ["Mega|Ride"] = 726.46, ["Mega|Fly|Ride"] = 1042.79}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 5.16, ["Neon"] = 63, ["Neon|Ride"] = 279.49, ["Mega"] = 105, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 315.03}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 17.71, ["Fly|Ride"] = 39.38, ["Neon"] = 6.17, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 19.59, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 60.38, ["Mega|Fly"] = 140.28, ["Mega|Ride"] = 89.25, ["Mega|Fly|Ride"] = 183.2}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 3.65, ["Ride"] = 44.63, ["Fly|Ride"] = 65.63, ["Neon"] = 28.3, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 144.38, ["Mega|Ride"] = 235.98, ["Mega|Fly|Ride"] = 397.69}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 20.74, ["Ride"] = 17.85, ["Fly|Ride"] = 55.13, ["Neon"] = 5.2, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 60.37, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 156.58}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.92, ["Fly"] = 131.25, ["Ride"] = 27.57, ["Fly|Ride"] = 98.42, ["Neon"] = 39.38, ["Neon|Ride"] = 98.41, ["Neon|Fly|Ride"] = 112.02, ["Mega"] = 232.39, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 471.95}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.87, ["Ride"] = 31.87, ["Fly|Ride"] = 72.19, ["Neon"] = 45.03, ["Neon|Fly"] = 471.99, ["Neon|Ride"] = 96.5, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 416.8, ["Mega|Fly|Ride"] = 1046.76}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 7.86, ["Fly"] = 131.25, ["Ride"] = 32.45, ["Fly|Ride"] = 42, ["Neon"] = 19.67, ["Neon|Fly"] = 104.7, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 112.52, ["Mega"] = 225.07, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 383.92}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 3.93, ["Fly"] = 34.07, ["Ride"] = 19.59, ["Fly|Ride"] = 39.38, ["Neon"] = 17.07, ["Neon|Fly"] = 83.76, ["Neon|Ride"] = 41.89, ["Neon|Fly|Ride"] = 104.69, ["Mega"] = 167.99, ["Mega|Ride"] = 179.01, ["Mega|Fly|Ride"] = 312.99}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 7.87, ["Fly"] = 301.88, ["Ride"] = 47.25, ["Fly|Ride"] = 108.94, ["Neon"] = 25.76, ["Neon|Fly"] = 140.3, ["Neon|Ride"] = 81.38, ["Mega"] = 118.13, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 405.11}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 16.78, ["Fly"] = 118.13, ["Ride"] = 110.25, ["Fly|Ride"] = 272.4, ["Neon"] = 78.75, ["Neon|Ride"] = 185.18, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 389.41, ["Mega|Fly"] = 669.38, ["Mega|Ride"] = 440.9, ["Mega|Fly|Ride"] = 574.77}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 63.73, ["Fly"] = 236, ["Ride"] = 97.13, ["Fly|Ride"] = 187.69, ["Neon"] = 308.44, ["Neon|Ride"] = 269.07, ["Neon|Fly|Ride"] = 363.92, ["Mega"] = 1050, ["Mega|Ride"] = 981.24, ["Mega|Fly|Ride"] = 1031.37}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 51.01, ["Ride"] = 15.75, ["Fly|Ride"] = 38.07, ["Neon"] = 3.68, ["Neon|Ride"] = 38.06, ["Mega"] = 31.39, ["Mega|Ride"] = 59.31, ["Mega|Fly|Ride"] = 124.58}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 17.07, ["Neon"] = 126.46, ["Neon|Ride"] = 199.31, ["Mega"] = 862.98, ["Mega|Ride"] = 589.93, ["Mega|Fly|Ride"] = 1256.11}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 40.84, ["Fly"] = 105, ["Ride"] = 116.82, ["Neon"] = 237.66, ["Neon|Ride"] = 299.69, ["Neon|Fly|Ride"] = 510.83, ["Mega"] = 837.41, ["Mega|Ride"] = 1103.28, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 14.32, ["Fly"] = 190.32, ["Ride"] = 44.62, ["Fly|Ride"] = 126, ["Neon"] = 40.69, ["Neon|Ride"] = 52.48, ["Neon|Fly|Ride"] = 209.36, ["Mega"] = 279.49, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 465.29}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Fly"] = 157.5, ["Ride"] = 52.49, ["Fly|Ride"] = 136.61, ["Neon"] = 3.83, ["Neon|Ride"] = 35.63, ["Mega"] = 24.86, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 61.95, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 27.24, ["Ride"] = 17.07, ["Fly|Ride"] = 41.89, ["Neon"] = 15.72, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 105, ["Mega|Fly"] = 349.63, ["Mega|Ride"] = 231.34, ["Mega|Fly|Ride"] = 220.5}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 18.86, ["Ride"] = 18.38, ["Fly|Ride"] = 20.36, ["Neon"] = 2.61, ["Neon|Fly"] = 21, ["Neon|Ride"] = 19.9, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 34.13, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Fly"] = 41.89, ["Ride"] = 19.69, ["Fly|Ride"] = 65.71, ["Neon"] = 3.93, ["Neon|Ride"] = 36.66, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 39.37, ["Mega|Fly"] = 168, ["Mega|Ride"] = 75.39, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.48, ["Fly|Ride"] = 158.13, ["Neon"] = 2.63, ["Neon|Ride"] = 125.63, ["Mega"] = 26.25, ["Mega|Ride"] = 104.69, ["Mega|Fly|Ride"] = 263.8}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 4.19, ["Ride"] = 31.43, ["Fly|Ride"] = 262.5, ["Neon"] = 72.19, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 207.26, ["Mega"] = 188.79, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 10.5, ["Ride"] = 30.19, ["Fly|Ride"] = 83.76, ["Neon"] = 52.19, ["Neon|Ride"] = 62.92, ["Neon|Fly|Ride"] = 234.8, ["Mega"] = 360.94, ["Mega|Ride"] = 304.5, ["Mega|Fly|Ride"] = 632.4}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 7.83, ["Fly"] = 29.3, ["Ride"] = 22.99, ["Fly|Ride"] = 48.2, ["Neon"] = 39.37, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 49.22, ["Neon|Fly|Ride"] = 84, ["Mega|Ride"] = 334.69, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 81.38, ["Ride"] = 167.51, ["Fly|Ride"] = 262.5, ["Neon"] = 538.13, ["Neon|Ride"] = 597.19, ["Mega"] = 3146.6, ["Mega|Fly|Ride"] = 1674.8}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 26.22, ["Fly"] = 71.72, ["Ride"] = 65.63, ["Fly|Ride"] = 72.19, ["Neon"] = 103.69, ["Mega"] = 628.04, ["Mega|Ride"] = 557.17, ["Mega|Fly|Ride"] = 1280.36}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 17.93, ["Ride"] = 17.94, ["Fly|Ride"] = 37.66, ["Neon"] = 4.2, ["Neon|Fly"] = 28.28, ["Neon|Ride"] = 24.09, ["Neon|Fly|Ride"] = 58.47, ["Mega"] = 36.11, ["Mega|Ride"] = 112.02, ["Mega|Fly|Ride"] = 110.97}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 17.7, ["Ride"] = 15.65, ["Fly|Ride"] = 31.49, ["Neon"] = 4.14, ["Neon|Fly"] = 23.62, ["Neon|Ride"] = 21.95, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 47.2, ["Mega|Ride"] = 55.47, ["Mega|Fly|Ride"] = 106.44}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 393.74, ["Ride"] = 438.38, ["Fly|Ride"] = 446.24, ["Neon|Ride"] = 1779.48, ["Neon|Fly|Ride"] = 1509.38}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 10.49, ["Ride"] = 140.3, ["Fly|Ride"] = 241.77, ["Neon"] = 105, ["Mega"] = 558.97, ["Mega|Fly|Ride"] = 1256.11}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 30.19, ["Ride"] = 18.38, ["Fly|Ride"] = 39.38, ["Neon"] = 3.93, ["Neon|Fly"] = 70.16, ["Neon|Ride"] = 20.74, ["Neon|Fly|Ride"] = 39.37, ["Mega"] = 38.97, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 116.21}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 77.44, ["Ride"] = 156.19, ["Fly|Ride"] = 223.13, ["Neon"] = 261.19, ["Neon|Ride"] = 304.48, ["Neon|Fly|Ride"] = 462, ["Mega"] = 737.63, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 934.49}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 31.42, ["Ride"] = 18.77, ["Fly|Ride"] = 45.94, ["Neon"] = 11.38, ["Neon|Fly"] = 42, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 77.84, ["Mega|Fly"] = 83.75, ["Mega|Ride"] = 115.29, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 70.16, ["Ride"] = 18.88, ["Fly|Ride"] = 1312.5, ["Neon"] = 3.7, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 28.28, ["Neon|Fly|Ride"] = 92.13, ["Mega"] = 21.15, ["Mega|Fly"] = 140.28, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 182.34}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 49.22, ["Fly"] = 140.21, ["Ride"] = 98.42, ["Fly|Ride"] = 240.73, ["Neon"] = 245.19, ["Neon|Ride"] = 334.97, ["Neon|Fly|Ride"] = 441.27, ["Mega"] = 790.97, ["Mega|Ride"] = 629.94, ["Mega|Fly|Ride"] = 837.41}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Fly|Ride"] = 52.5, ["Neon"] = 4.72, ["Neon|Ride"] = 54.46, ["Mega"] = 98.54, ["Mega|Ride"] = 121.56, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 34.13, ["Ride"] = 70.16, ["Fly|Ride"] = 70.16, ["Neon"] = 152.24, ["Neon|Ride"] = 167.49, ["Neon|Fly|Ride"] = 366.38, ["Mega"] = 1652.82, ["Mega|Ride"] = 1674.8, ["Mega|Fly|Ride"] = 1099.89}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 4.72, ["Ride"] = 45.02, ["Fly|Ride"] = 209.39, ["Neon"] = 23.63, ["Neon|Ride"] = 300.57, ["Neon|Fly|Ride"] = 418.71, ["Mega"] = 175.88, ["Mega|Ride"] = 603.75, ["Mega|Fly|Ride"] = 460.04}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 70.16, ["Ride"] = 27.24, ["Neon"] = 12.85, ["Neon|Fly"] = 78.53, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 78.52, ["Mega|Ride"] = 728.43, ["Mega|Fly|Ride"] = 418.71}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 31.46, ["Ride"] = 56.57, ["Fly|Ride"] = 105, ["Neon"] = 146.44, ["Neon|Ride"] = 131.25, ["Mega|Ride"] = 1116.89}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 144.82, ["Ride"] = 42, ["Fly|Ride"] = 908.98, ["Neon"] = 5.24, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 64.92, ["Mega|Fly"] = 158.61, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 235.98}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 56.55, ["Ride"] = 23.05, ["Fly|Ride"] = 102.85, ["Neon"] = 6.51, ["Neon|Fly"] = 41.88, ["Neon|Ride"] = 41.89, ["Neon|Fly|Ride"] = 104.7, ["Mega"] = 166.45, ["Mega|Ride"] = 179.01, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 9.43, ["Fly"] = 35.6, ["Ride"] = 40.14, ["Fly|Ride"] = 92.06, ["Neon"] = 103.69, ["Neon|Ride"] = 120.75, ["Mega"] = 262.5, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 378}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 36.74, ["Ride"] = 70.14, ["Fly|Ride"] = 78.66, ["Neon"] = 241.49, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 418.71, ["Mega"] = 816.37, ["Mega|Ride"] = 1046.76, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 35.63, ["Fly"] = 50.15, ["Ride"] = 35.43, ["Fly|Ride"] = 77.44, ["Neon"] = 98.42, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 154.88, ["Mega"] = 620.57, ["Mega|Ride"] = 388.5, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 64.32, ["Ride"] = 125.64, ["Fly|Ride"] = 196.83, ["Neon"] = 326.82, ["Neon|Ride"] = 354.86, ["Neon|Fly|Ride"] = 510.57, ["Mega"] = 1451.85, ["Mega|Ride"] = 1302, ["Mega|Fly|Ride"] = 1252.13}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.82, ["Ride"] = 35.44, ["Neon"] = 18.8, ["Neon|Ride"] = 58.65, ["Neon|Fly|Ride"] = 305.81, ["Mega"] = 196.22, ["Mega|Ride"] = 279.57, ["Mega|Fly|Ride"] = 327.48}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 6.2, ["Ride"] = 24.94, ["Fly|Ride"] = 78.75, ["Neon"] = 17.07, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 140.28, ["Mega"] = 203.44, ["Mega|Ride"] = 182.15, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 26.25, ["Fly"] = 28.33, ["Ride"] = 39.38, ["Fly|Ride"] = 98.42, ["Neon"] = 49.07, ["Neon|Ride"] = 137.19, ["Mega"] = 400.32, ["Mega|Ride"] = 349.63, ["Mega|Fly|Ride"] = 452.82}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 13.99, ["Fly|Ride"] = 33.52, ["Neon"] = 2.1, ["Neon|Fly"] = 17.05, ["Neon|Ride"] = 15.06, ["Neon|Fly|Ride"] = 45.85, ["Mega"] = 19.67, ["Mega|Fly"] = 70.16, ["Mega|Ride"] = 22.32, ["Mega|Fly|Ride"] = 102.38}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 91.88, ["Fly"] = 91.88, ["Ride"] = 91.88, ["Fly|Ride"] = 265.93, ["Neon"] = 240.8, ["Neon|Fly"] = 2256.27, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 977.67, ["Mega|Ride"] = 807.19, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 94.23, ["Fly|Ride"] = 108.89, ["Neon"] = 3.71, ["Neon|Ride"] = 38.06, ["Neon|Fly|Ride"] = 188.79, ["Mega"] = 55.47, ["Mega|Ride"] = 50.75, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 27.99, ["Ride"] = 15.74, ["Fly|Ride"] = 60.73, ["Neon"] = 20.94, ["Neon|Fly"] = 140.3, ["Neon|Ride"] = 32.42, ["Neon|Fly|Ride"] = 83.78, ["Mega"] = 107.87, ["Mega|Ride"] = 413.48, ["Mega|Fly|Ride"] = 334.97}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 78.75, ["Ride"] = 140.3, ["Fly|Ride"] = 787.5, ["Neon"] = 328.13, ["Neon|Ride"] = 362.78, ["Neon|Fly|Ride"] = 372.66, ["Mega"] = 1019.82, ["Mega|Ride"] = 1208.82, ["Mega|Fly|Ride"] = 1153.69}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 72.19, ["Neon"] = 5.25, ["Neon|Ride"] = 43.32, ["Mega"] = 127.72, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 279.49}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 10.4}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 141.35, ["Fly|Ride"] = 67.02, ["Neon"] = 10.5, ["Neon|Ride"] = 71.21, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 45.93, ["Mega|Ride"] = 116.2, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 140.28, ["Ride"] = 185.22, ["Fly|Ride"] = 236.25, ["Neon"] = 538.13, ["Neon|Ride"] = 722.27, ["Neon|Fly|Ride"] = 708.75, ["Mega"] = 3618.53, ["Mega|Ride"] = 2191.88, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.56, ["Ride"] = 25.5, ["Neon"] = 11.53, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 131.91, ["Mega"] = 145.84, ["Mega|Ride"] = 110.97, ["Mega|Fly|Ride"] = 463.73}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Neon"] = 4.6, ["Neon|Ride"] = 20.19, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 45.42, ["Mega|Ride"] = 128.21, ["Mega|Fly|Ride"] = 140.28}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 3.93, ["Ride"] = 30.69, ["Neon"] = 47.25, ["Neon|Ride"] = 140.28, ["Mega|Ride"] = 628.06, ["Mega|Fly|Ride"] = 454.53}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 10.91, ["Fly"] = 28.88, ["Ride"] = 26.62, ["Fly|Ride"] = 157.5, ["Neon"] = 82.69, ["Neon|Ride"] = 94.74, ["Neon|Fly|Ride"] = 146.31, ["Mega"] = 587.35, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 52.5, ["Fly|Ride"] = 141.62, ["Neon"] = 187.69, ["Neon|Ride"] = 314.04, ["Neon|Fly|Ride"] = 488.96, ["Mega"] = 743.21, ["Mega|Ride"] = 695.63, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 152.2, ["Fly"] = 202.68, ["Ride"] = 200.05, ["Fly|Ride"] = 221.82, ["Neon"] = 526.59, ["Neon|Fly"] = 627.09, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 518.15, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 13.65, ["Fly"] = 22.84, ["Ride"] = 18.27, ["Fly|Ride"] = 39.37, ["Neon"] = 39.38, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 91.87, ["Mega|Ride"] = 558.97, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 131.23, ["Ride"] = 26.25, ["Fly|Ride"] = 91.88, ["Neon"] = 13.02, ["Neon|Ride"] = 56.55, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 99.75, ["Mega|Fly|Ride"] = 283.17}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 20.95, ["Fly"] = 98.42, ["Ride"] = 50.75, ["Neon"] = 129.93, ["Neon|Ride"] = 140.28, ["Mega"] = 1262.39, ["Mega|Ride"] = 417.67, ["Mega|Fly|Ride"] = 646.9}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 41.89, ["Ride"] = 76.13, ["Fly|Ride"] = 118.12, ["Neon"] = 157.38, ["Neon|Ride"] = 257.51, ["Neon|Fly|Ride"] = 387.32, ["Mega"] = 879.27, ["Mega|Ride"] = 931.88, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 15.72, ["Ride"] = 81.86, ["Neon"] = 91.88, ["Neon|Ride"] = 140.3, ["Mega"] = 795.54, ["Mega|Ride"] = 744.26, ["Mega|Fly|Ride"] = 698.2}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 315, ["Ride"] = 397.83, ["Neon"] = 907.66, ["Neon|Ride"] = 1088.76, ["Neon|Fly|Ride"] = 1046.76, ["Mega|Fly|Ride"] = 4668.49}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 28.88, ["Ride"] = 55.13, ["Fly|Ride"] = 209.39, ["Neon"] = 283.2, ["Neon|Ride"] = 275.62, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 984.38, ["Mega|Ride"] = 891.19, ["Mega|Fly|Ride"] = 907.54}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 18.1, ["Ride"] = 15.63, ["Fly|Ride"] = 64.31, ["Neon"] = 2.1, ["Neon|Fly"] = 18.89, ["Neon|Ride"] = 19.22, ["Neon|Fly|Ride"] = 59.74, ["Mega"] = 23.63, ["Mega|Ride"] = 38.06, ["Mega|Fly|Ride"] = 121.46}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Ride"] = 209.53, ["Neon"] = 30.7, ["Neon|Ride"] = 45.85, ["Neon|Fly|Ride"] = 104.75, ["Mega"] = 158.07, ["Mega|Fly"] = 124.69, ["Mega|Ride"] = 139.23, ["Mega|Fly|Ride"] = 373.42}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.62, ["Ride"] = 104.7, ["Fly|Ride"] = 144.16, ["Neon"] = 15.74, ["Neon|Ride"] = 139.12, ["Neon|Fly|Ride"] = 166.45, ["Mega"] = 120.39, ["Mega|Fly"] = 544.32, ["Mega|Ride"] = 209.36, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 378, ["Fly"] = 630.12, ["Ride"] = 393.75, ["Fly|Ride"] = 431.82, ["Neon"] = 2094.01, ["Neon|Ride"] = 1604.57, ["Neon|Fly|Ride"] = 1493.34, ["Mega|Fly|Ride"] = 5033.44}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 46.15, ["Ride"] = 19.43, ["Fly|Ride"] = 41.89, ["Neon"] = 24.94, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 78.33, ["Mega"] = 168, ["Mega|Ride"] = 270.85}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 8.21, ["Fly"] = 31.42, ["Ride"] = 19.69, ["Fly|Ride"] = 39.38, ["Neon"] = 28.28, ["Neon|Fly"] = 157.5, ["Neon|Fly|Ride"] = 208.31, ["Mega|Ride"] = 698.2, ["Mega|Fly|Ride"] = 286.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 6.29, ["Fly"] = 83.75, ["Ride"] = 26.25, ["Fly|Ride"] = 65.63, ["Neon"] = 20.9, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 119.35, ["Mega"] = 111.57, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 131.25, ["Fly"] = 210, ["Fly|Ride"] = 61.69, ["Neon"] = 118.27, ["Neon|Fly|Ride"] = 210, ["Mega"] = 942.09, ["Mega|Ride"] = 836.36, ["Mega|Fly|Ride"] = 597.71}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 31.42, ["Ride"] = 31.2, ["Fly|Ride"] = 61.79, ["Neon"] = 15.72, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 210, ["Mega"] = 157.24, ["Mega|Ride"] = 334.97, ["Mega|Fly|Ride"] = 1313.18}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 12.84, ["Fly"] = 104.16, ["Ride"] = 28.28, ["Fly|Ride"] = 69.21, ["Neon"] = 78.75, ["Neon|Ride"] = 140.48, ["Mega|Ride"] = 628.06, ["Mega|Fly|Ride"] = 731.7}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 40.92, ["Neon"] = 7.87, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 28.25, ["Mega"] = 36.66, ["Mega|Ride"] = 133.01, ["Mega|Fly|Ride"] = 279.49}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 12.6, ["Ride"] = 69.57, ["Neon"] = 59.07, ["Mega"] = 216.57, ["Mega|Fly|Ride"] = 837.41}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 14.44, ["Ride"] = 56.55, ["Neon"] = 87.33, ["Neon|Fly|Ride"] = 175.87, ["Mega"] = 328.13, ["Mega|Ride"] = 555.83, ["Mega|Fly|Ride"] = 461.63}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 8.74, ["Fly"] = 26.25, ["Ride"] = 27.36, ["Fly|Ride"] = 57.02, ["Neon"] = 35.61, ["Neon|Fly"] = 65.54, ["Neon|Ride"] = 62.83, ["Neon|Fly|Ride"] = 112.02, ["Mega"] = 372.66, ["Mega|Ride"] = 375.38, ["Mega|Fly|Ride"] = 374.32}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 170.51, ["Fly"] = 216.56, ["Ride"] = 203.44, ["Fly|Ride"] = 344.15, ["Neon"] = 857.4, ["Neon|Ride"] = 894.98, ["Neon|Fly|Ride"] = 907.54, ["Mega|Fly|Ride"] = 4172.34}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Fly"] = 27.23, ["Ride"] = 15.74, ["Fly|Ride"] = 48.17, ["Neon"] = 12.95, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 140.28, ["Mega"] = 220.5, ["Mega|Ride"] = 166.45, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.78, ["Fly"] = 41.89, ["Ride"] = 36.2, ["Fly|Ride"] = 103.84, ["Neon"] = 16.75, ["Neon|Ride"] = 27.16, ["Neon|Fly|Ride"] = 158.1, ["Mega"] = 269.09, ["Mega|Ride"] = 389.81, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 39.19, ["Ride"] = 140.3, ["Fly|Ride"] = 396.78, ["Neon"] = 144.38, ["Neon|Ride"] = 195.76, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 490.13, ["Mega|Ride"] = 523.51, ["Mega|Fly|Ride"] = 564.25}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 101.07, ["Fly"] = 262.5, ["Ride"] = 183.75, ["Fly|Ride"] = 261.18, ["Neon"] = 559.05, ["Neon|Ride"] = 502.45, ["Neon|Fly|Ride"] = 977.67, ["Mega"] = 2093.51, ["Mega|Ride"] = 1791.57, ["Mega|Fly|Ride"] = 1795.44}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 26.14, ["Ride"] = 90.56, ["Fly|Ride"] = 174.07, ["Neon"] = 91.88, ["Neon|Ride"] = 167.51, ["Neon|Fly|Ride"] = 279.49, ["Mega"] = 288.75, ["Mega|Ride"] = 337.32, ["Mega|Fly|Ride"] = 448.88}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.23, ["Fly|Ride"] = 46.59, ["Neon"] = 10.18, ["Neon|Fly|Ride"] = 58.97, ["Mega"] = 65.63, ["Mega|Ride"] = 188.43, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 8.29, ["Neon"] = 112.03, ["Neon|Ride"] = 209.36, ["Mega"] = 293.1, ["Mega|Ride"] = 391.79, ["Mega|Fly|Ride"] = 414.52}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 81.35, ["Ride"] = 105, ["Fly|Ride"] = 216.57, ["Neon"] = 199.5, ["Neon|Ride"] = 233.88, ["Neon|Fly|Ride"] = 334.97, ["Mega"] = 569.62, ["Mega|Ride"] = 677.25, ["Mega|Fly|Ride"] = 698.37}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 87.94, ["Neon"] = 10.13, ["Neon|Ride"] = 104.72, ["Neon|Fly|Ride"] = 141.88, ["Mega"] = 65.63, ["Mega|Fly"] = 161.21, ["Mega|Ride"] = 109.23, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 15.72, ["Ride"] = 330.37, ["Neon"] = 84, ["Neon|Ride"] = 131.25, ["Mega"] = 421.4, ["Mega|Ride"] = 669.93, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 977.81, ["Fly"] = 1326.4, ["Ride"] = 956.82, ["Fly|Ride"] = 1076.36, ["Neon"] = 2362.5, ["Neon|Ride"] = 3934.71, ["Neon|Fly|Ride"] = 2930.59, ["Mega|Fly|Ride"] = 12534.38}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 32.81, ["Fly"] = 116.59, ["Ride"] = 112.03, ["Fly|Ride"] = 204.15, ["Neon"] = 177.19, ["Neon|Fly"] = 892.5, ["Neon|Ride"] = 530.72, ["Neon|Fly|Ride"] = 315, ["Mega"] = 684.59, ["Mega|Ride"] = 538.13, ["Mega|Fly|Ride"] = 1046.76}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.63, ["Fly"] = 49.19, ["Ride"] = 19.91, ["Fly|Ride"] = 80.88, ["Neon"] = 11.46, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 37.43, ["Neon|Fly|Ride"] = 105, ["Mega"] = 75.34, ["Mega|Ride"] = 108.66, ["Mega|Fly|Ride"] = 206.07}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 23.79, ["Ride"] = 131.22, ["Neon"] = 110.86, ["Mega"] = 308.8, ["Mega|Ride"] = 554.98, ["Mega|Fly|Ride"] = 924}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 30.4, ["Fly|Ride"] = 418.76, ["Neon"] = 3.84, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 104.69, ["Mega"] = 23.41, ["Mega|Fly"] = 54.29, ["Mega|Ride"] = 52.45, ["Mega|Fly|Ride"] = 544.32}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 86.66, ["Ride"] = 139.36, ["Fly|Ride"] = 183.75, ["Neon"] = 351.21, ["Neon|Fly"] = 471.99, ["Neon|Ride"] = 376.47, ["Neon|Fly|Ride"] = 572.58, ["Mega"] = 1238.47, ["Mega|Ride"] = 1194.51, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 4.97, ["Fly"] = 174.57, ["Ride"] = 37.74, ["Fly|Ride"] = 66, ["Neon"] = 38.66, ["Neon|Ride"] = 47.18, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 349.63, ["Mega|Ride"] = 246.75, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 28.28, ["Fly|Ride"] = 45.94, ["Neon"] = 12.99, ["Neon|Ride"] = 91.09, ["Mega"] = 154.88, ["Mega|Ride"] = 237.62, ["Mega|Fly|Ride"] = 384.63}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 41.83, ["Ride"] = 52.5, ["Fly|Ride"] = 167.51, ["Neon"] = 196.88, ["Neon|Fly"] = 278.49, ["Neon|Ride"] = 209.39, ["Neon|Fly|Ride"] = 628.06, ["Mega"] = 1048.69, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 615.57}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 14.44, ["Ride"] = 52.5, ["Neon"] = 111.57, ["Neon|Fly"] = 167.51, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 140.28, ["Mega"] = 837.41, ["Mega|Ride"] = 579.91, ["Mega|Fly|Ride"] = 630.04}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 54.51, ["Neon"] = 779.63, ["Neon|Ride"] = 630.04, ["Neon|Fly|Ride"] = 1013.92, ["Mega"] = 1228.89, ["Mega|Ride"] = 1955.33, ["Mega|Fly|Ride"] = 1994.22}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 6.2, ["Neon"] = 24.09, ["Neon|Ride"] = 120.41, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 120.72, ["Mega|Ride"] = 158.93, ["Mega|Fly|Ride"] = 280.19}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 6.18, ["Fly"] = 23.63, ["Ride"] = 27.57, ["Fly|Ride"] = 63.73, ["Neon"] = 63.73, ["Neon|Ride"] = 80.07, ["Neon|Fly|Ride"] = 132.96, ["Mega"] = 399, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 413.44}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 131.14, ["Ride"] = 179.03, ["Fly|Ride"] = 234.51, ["Neon"] = 507.94, ["Neon|Ride"] = 614.61, ["Neon|Fly|Ride"] = 977.67, ["Mega|Ride"] = 2304.83, ["Mega|Fly|Ride"] = 1903.13}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 30.85, ["Ride"] = 18.06, ["Fly|Ride"] = 104999.99, ["Neon"] = 14.43, ["Neon|Fly"] = 64.31, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 59.99, ["Mega"] = 145.68, ["Mega|Ride"] = 140.33, ["Mega|Fly|Ride"] = 558.97}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 6.09, ["Fly"] = 87.94, ["Ride"] = 28.28, ["Fly|Ride"] = 78.59, ["Neon"] = 42, ["Neon|Fly"] = 281.17, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 117.99, ["Mega"] = 140.28, ["Mega|Ride"] = 205.17, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 16.8, ["Ride"] = 18.38, ["Fly|Ride"] = 36.75, ["Neon"] = 2.1, ["Neon|Fly"] = 16.77, ["Neon|Ride"] = 17.69, ["Neon|Fly|Ride"] = 47.18, ["Mega"] = 23.6, ["Mega|Ride"] = 40.14, ["Mega|Fly|Ride"] = 76.13}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 41.91, ["Neon"] = 3.94, ["Neon|Ride"] = 39.8, ["Mega"] = 23.63, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 138.18}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 27.24, ["Fly|Ride"] = 45.94, ["Neon"] = 22.43, ["Neon|Ride"] = 26.25, ["Mega"] = 91.88, ["Mega|Ride"] = 152.3}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 44.63, ["Ride"] = 84, ["Neon"] = 522.38, ["Neon|Ride"] = 418.76, ["Neon|Fly|Ride"] = 630, ["Mega"] = 779.63, ["Mega|Fly|Ride"] = 668.88}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 3.03, ["Fly"] = 23.05, ["Ride"] = 19.59, ["Fly|Ride"] = 30.19, ["Neon"] = 12.58, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 25.04, ["Neon|Fly|Ride"] = 69.08, ["Mega"] = 78.75, ["Mega|Fly"] = 163.84, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 188.99}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 4.33, ["Fly"] = 31.47, ["Ride"] = 22.32, ["Fly|Ride"] = 68.23, ["Neon"] = 16.31, ["Neon|Fly"] = 36.75, ["Neon|Ride"] = 36.66, ["Neon|Fly|Ride"] = 82.85, ["Mega"] = 147, ["Mega|Fly"] = 174.63, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 189.6}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 3.82, ["Fly"] = 19.59, ["Ride"] = 18.21, ["Fly|Ride"] = 115.5, ["Neon"] = 9.06, ["Neon|Fly"] = 47.21, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 110.85, ["Mega"] = 103.39, ["Mega|Fly"] = 158.1, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 11.81, ["Fly"] = 279.49, ["Ride"] = 24.94, ["Neon"] = 60.19, ["Neon|Ride"] = 59.04, ["Neon|Fly|Ride"] = 268.8, ["Mega"] = 224.21, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 347.54, ["Mega|Fly|Ride"] = 345.44}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 6.04, ["Fly"] = 160.71, ["Ride"] = 65.97, ["Fly|Ride"] = 173.79, ["Neon"] = 98.59, ["Neon|Ride"] = 91.77, ["Neon|Fly|Ride"] = 349.63, ["Mega"] = 328.13, ["Mega|Ride"] = 418.71, ["Mega|Fly|Ride"] = 1046.76}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.93, ["Fly"] = 35.44, ["Ride"] = 20.9, ["Fly|Ride"] = 52.5, ["Neon"] = 28.2, ["Neon|Fly"] = 196.65, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 105, ["Mega"] = 265.89, ["Mega|Ride"] = 244.95}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 20.78, ["Ride"] = 16.77, ["Fly|Ride"] = 52.5, ["Neon"] = 15.73, ["Neon|Fly"] = 46.08, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 418.71, ["Mega|Ride"] = 234.8, ["Mega|Fly|Ride"] = 209.36}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 209.36, ["Fly"] = 393.75, ["Ride"] = 236.25, ["Fly|Ride"] = 365.79, ["Neon"] = 971.52, ["Neon|Ride"] = 1046.89, ["Neon|Fly|Ride"] = 1179.94, ["Mega|Fly|Ride"] = 3775.59}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 6.14, ["Ride"] = 38.72, ["Neon"] = 30.85, ["Neon|Fly|Ride"] = 279.49, ["Mega"] = 116.94, ["Mega|Ride"] = 279.57}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.18, ["Ride"] = 27.24, ["Fly|Ride"] = 118.13, ["Neon"] = 23.63, ["Neon|Fly"] = 209.39, ["Neon|Ride"] = 36.71, ["Neon|Fly|Ride"] = 126.26, ["Mega"] = 185.24, ["Mega|Ride"] = 271.11, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 3.68, ["Ride"] = 24.94, ["Neon"] = 47.25, ["Neon|Ride"] = 213.44, ["Neon|Fly|Ride"] = 628.06, ["Mega"] = 461.77, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 428.54}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 16.77, ["Fly|Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 20.88, ["Neon|Ride"] = 15.72, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 22.32, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 59.69, ["Mega|Fly|Ride"] = 95.55}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 56.37, ["Ride"] = 26.25, ["Fly|Ride"] = 56.44, ["Neon"] = 18.86, ["Neon|Ride"] = 28.3, ["Neon|Fly|Ride"] = 69.54, ["Mega"] = 153.56, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 299.69}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 5.25, ["Ride"] = 56.55, ["Fly|Ride"] = 77.44, ["Neon"] = 10.5, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 55.13, ["Mega|Ride"] = 187.69, ["Mega|Fly|Ride"] = 299.69}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 82.69, ["Fly"] = 140.3, ["Ride"] = 98.42, ["Fly|Ride"] = 131.25, ["Neon"] = 488.91, ["Neon|Ride"] = 418.76, ["Neon|Fly|Ride"] = 429.87, ["Mega|Ride"] = 3490.91, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.03, ["Fly"] = 85.32, ["Ride"] = 25.2, ["Fly|Ride"] = 65.63, ["Neon"] = 20.95, ["Neon|Ride"] = 55.47, ["Neon|Fly|Ride"] = 135.7, ["Mega"] = 209.41, ["Mega|Ride"] = 259.86, ["Mega|Fly|Ride"] = 471.95}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 31.42, ["Ride"] = 44.58, ["Fly|Ride"] = 118.13, ["Neon"] = 10.39, ["Neon|Ride"] = 125.64, ["Neon|Fly|Ride"] = 167.49, ["Mega"] = 52.5, ["Mega|Fly"] = 313.69, ["Mega|Ride"] = 102.6, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 69.57, ["Fly"] = 210, ["Ride"] = 91.88, ["Fly|Ride"] = 288.75, ["Neon"] = 157.5, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 303.19, ["Mega"] = 557.97, ["Mega|Ride"] = 580.13, ["Mega|Fly|Ride"] = 666.75}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 17.04, ["Ride"] = 18.8, ["Fly|Ride"] = 28.88, ["Neon"] = 2.63, ["Neon|Fly"] = 38.06, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 34.2, ["Mega"] = 27.57, ["Mega|Fly"] = 43.24, ["Mega|Ride"] = 41.93, ["Mega|Fly|Ride"] = 81.38}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 60.29, ["Neon|Fly|Ride"] = 71.11, ["Mega"] = 31.38, ["Mega|Ride"] = 77.44, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 107.63, ["Fly|Ride"] = 137.82, ["Neon"] = 10.31, ["Neon|Fly|Ride"] = 188.43, ["Mega"] = 78.66, ["Mega|Ride"] = 115.48}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 8.39, ["Fly"] = 140.3, ["Ride"] = 69.55, ["Fly|Ride"] = 111.56, ["Neon"] = 41.92, ["Neon|Fly"] = 135.19, ["Neon|Ride"] = 107.63, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 126, ["Mega|Fly"] = 216.57, ["Mega|Ride"] = 184.82, ["Mega|Fly|Ride"] = 320.56}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.64, ["Ride"] = 15.65, ["Fly|Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 28.33, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 69.62, ["Mega"] = 24.82, ["Mega|Ride"] = 43.98, ["Mega|Fly|Ride"] = 128.77}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 12.53, ["Ride"] = 43.99, ["Fly|Ride"] = 235.81, ["Neon"] = 70.88, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 208.04, ["Mega"] = 485.7, ["Mega|Ride"] = 522.34, ["Mega|Fly|Ride"] = 657.37}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2887.5, ["Fly"] = 3150, ["Ride"] = 2779.88, ["Fly|Ride"] = 2441.25, ["Neon|Ride"] = 9770.32, ["Neon|Fly|Ride"] = 9187.49, ["Mega|Fly|Ride"] = 43439.86}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 28.29, ["Ride"] = 20.97, ["Fly|Ride"] = 44.63, ["Neon"] = 9.08, ["Neon|Fly"] = 62.29, ["Neon|Ride"] = 28.28, ["Neon|Fly|Ride"] = 66.94, ["Mega"] = 74.82, ["Mega|Fly"] = 466.87, ["Mega|Ride"] = 105.11, ["Mega|Fly|Ride"] = 181.71}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Neon"] = 19.69, ["Mega"] = 126, ["Mega|Fly"] = 179.82, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 628.06}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 17.63, ["Ride"] = 35.44, ["Fly|Ride"] = 146.57, ["Neon"] = 85.97, ["Neon|Ride"] = 279.57, ["Neon|Fly|Ride"] = 216.09, ["Mega"] = 547.46, ["Mega|Ride"] = 383.24, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 68.4, ["Ride"] = 98.44, ["Neon"] = 140.41, ["Neon|Fly|Ride"] = 418.71, ["Mega"] = 540.75, ["Mega|Ride"] = 730.33, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 140.39, ["Fly"] = 1396.55, ["Ride"] = 189, ["Fly|Ride"] = 266.44, ["Neon"] = 628.14, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 774.38, ["Neon|Fly|Ride"] = 769.84, ["Mega"] = 6280.47, ["Mega|Ride"] = 3508.8, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 8.87, ["Fly"] = 28.28, ["Ride"] = 52.5, ["Fly|Ride"] = 675.94, ["Neon"] = 18.85, ["Neon|Ride"] = 104.9, ["Neon|Fly|Ride"] = 140.28, ["Mega"] = 224.01, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 582.75}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 62.83, ["Neon"] = 16.75, ["Neon|Fly"] = 98.42, ["Neon|Fly|Ride"] = 523.39, ["Mega"] = 136.5, ["Mega|Ride"] = 261.24, ["Mega|Fly|Ride"] = 838.43}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 101.97, ["Ride"] = 26.17, ["Fly|Ride"] = 131.25, ["Neon"] = 14.34, ["Neon|Ride"] = 90.04, ["Mega"] = 96.17, ["Mega|Ride"] = 122.82, ["Mega|Fly|Ride"] = 279.49}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 19.69, ["Ride"] = 98.44, ["Fly|Ride"] = 656.25, ["Neon|Ride"] = 1165.81, ["Neon|Fly|Ride"] = 293.1, ["Mega"] = 374.06, ["Mega|Ride"] = 500.36, ["Mega|Fly|Ride"] = 647.73}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 70.16, ["Neon"] = 2.1, ["Neon|Ride"] = 37.77, ["Mega"] = 41.89, ["Mega|Ride"] = 133.88, ["Mega|Fly|Ride"] = 334.97}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 78.75, ["Ride"] = 91.88, ["Fly|Ride"] = 158.13, ["Neon"] = 313.03, ["Neon|Ride"] = 409.5, ["Neon|Fly|Ride"] = 518.15, ["Mega"] = 1365, ["Mega|Fly|Ride"] = 1396.38}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 6.41, ["Neon|Ride"] = 112.03, ["Mega"] = 39.38, ["Mega|Ride"] = 141.59}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 55.78, ["Fly"] = 220.67, ["Ride"] = 79.68, ["Fly|Ride"] = 154.92, ["Neon"] = 250.22, ["Neon|Ride"] = 250.31, ["Neon|Fly|Ride"] = 558.97, ["Mega"] = 2625, ["Mega|Ride"] = 1570.13, ["Mega|Fly|Ride"] = 1256.11}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 24.1, ["Fly|Ride"] = 49.88, ["Neon"] = 5.13, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 41.89, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 50.26, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 107.49}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 3.42, ["Neon"] = 13, ["Neon|Ride"] = 112.03, ["Mega"] = 86.63, ["Mega|Fly|Ride"] = 544.69}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 7.54, ["Ride"] = 68.25, ["Fly|Ride"] = 140.3, ["Neon"] = 36.75, ["Neon|Fly|Ride"] = 158.1, ["Mega"] = 228.51, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 413.44, ["Ride"] = 439.69, ["Fly|Ride"] = 525, ["Neon"] = 1232.44, ["Neon|Ride"] = 1311.19, ["Neon|Fly|Ride"] = 1442.44, ["Mega"] = 4466.46, ["Mega|Ride"] = 4410, ["Mega|Fly|Ride"] = 4048.32}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 38.03, ["Ride"] = 51.19, ["Fly|Ride"] = 78.75, ["Neon"] = 154.95, ["Neon|Fly"] = 315.05, ["Neon|Ride"] = 207.31, ["Neon|Fly|Ride"] = 208.31, ["Mega|Ride"] = 1045.72, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 28.2, ["Ride"] = 17.07, ["Fly|Ride"] = 91.88, ["Neon"] = 4.47, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 97.02, ["Mega"] = 70.16, ["Mega|Ride"] = 81.38, ["Mega|Fly|Ride"] = 424.75}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 11.82, ["Fly"] = 72.19, ["Ride"] = 45.03, ["Fly|Ride"] = 122.07, ["Neon"] = 45.94, ["Neon|Fly"] = 188.14, ["Neon|Ride"] = 77.47, ["Neon|Fly|Ride"] = 146.56, ["Mega"] = 229.71, ["Mega|Fly"] = 391.5, ["Mega|Ride"] = 315.03, ["Mega|Fly|Ride"] = 412.46}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 6.56, ["Ride"] = 23.61, ["Fly|Ride"] = 265.13, ["Neon"] = 125.99, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 188.79, ["Mega|Ride"] = 389.69, ["Mega|Fly|Ride"] = 448.02}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 2.1, ["Neon"] = 15.49, ["Neon|Ride"] = 52.5, ["Mega"] = 59.07, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 20.95, ["Ride"] = 19.67, ["Fly|Ride"] = 51.93, ["Neon"] = 26.25, ["Neon|Ride"] = 46.08, ["Neon|Fly|Ride"] = 210.08, ["Mega"] = 550.99, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 471.95}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 115.16, ["Ride"] = 105, ["Fly|Ride"] = 167.64, ["Neon|Ride"] = 559.79, ["Neon|Fly|Ride"] = 836.36, ["Mega"] = 2652.46, ["Mega|Ride"] = 2791.68, ["Mega|Fly|Ride"] = 3068.02}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 23.24, ["Fly"] = 95.82, ["Ride"] = 98.42, ["Fly|Ride"] = 158.12, ["Neon"] = 192.94, ["Neon|Ride"] = 282.19, ["Mega"] = 836.36, ["Mega|Ride"] = 753.67, ["Mega|Fly|Ride"] = 735.39}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2467.4, ["Fly"] = 2349.37, ["Ride"] = 2310, ["Fly|Ride"] = 2310, ["Neon"] = 12562.47, ["Neon|Fly|Ride"] = 7743.75, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 41.89, ["Fly|Ride"] = 170.63, ["Neon"] = 6.57, ["Neon|Ride"] = 15.73, ["Neon|Fly|Ride"] = 167.49, ["Mega"] = 125.97, ["Mega|Ride"] = 168.67, ["Mega|Fly|Ride"] = 276.94}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 9.09, ["Ride"] = 83.86, ["Fly|Ride"] = 140.3, ["Neon"] = 38.75, ["Neon|Fly|Ride"] = 253.32, ["Mega"] = 255.94, ["Mega|Ride"] = 698.2, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 984.38, ["Fly"] = 1396.55, ["Ride"] = 969.94, ["Fly|Ride"] = 997.49, ["Neon"] = 2445.65, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2399.25, ["Mega|Fly|Ride"] = 9450}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 36.49, ["Ride"] = 78.75, ["Fly|Ride"] = 210, ["Neon"] = 279.54, ["Neon|Ride"] = 289.42, ["Mega"] = 838.03, ["Mega|Ride"] = 804.56, ["Mega|Fly|Ride"] = 986.04}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.1, ["Ride"] = 23, ["Neon"] = 14.15, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 140.28, ["Mega|Ride"] = 154.93, ["Mega|Fly|Ride"] = 304.61}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 111.19, ["Neon"] = 4.64, ["Neon|Ride"] = 20.11, ["Mega"] = 28.04, ["Mega|Ride"] = 103.64, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 83.99, ["Ride"] = 125.99, ["Fly|Ride"] = 315.07, ["Neon"] = 459.38, ["Neon|Fly|Ride"] = 471.95, ["Mega"] = 1955.33, ["Mega|Fly|Ride"] = 2652.46}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 4.86, ["Neon"] = 31.43, ["Neon|Ride"] = 90.57, ["Mega"] = 197.05, ["Mega|Ride"] = 224.18, ["Mega|Fly|Ride"] = 362.22}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 76.11, ["Ride"] = 97.63, ["Neon"] = 614.25, ["Neon|Ride"] = 525, ["Mega"] = 1815.07, ["Mega|Fly|Ride"] = 1669.57}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 4.64, ["Fly"] = 104.99, ["Fly|Ride"] = 112.03, ["Neon"] = 33.16, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 141.59, ["Mega|Fly|Ride"] = 279.49}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 223.13, ["Ride"] = 291.37, ["Fly|Ride"] = 350.44, ["Neon"] = 979.89, ["Neon|Ride"] = 1003.84, ["Neon|Fly|Ride"] = 813.75, ["Mega|Fly|Ride"] = 4047.77}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.7, ["Fly"] = 87.83, ["Ride"] = 28.3, ["Fly|Ride"] = 54.45, ["Neon"] = 18.38, ["Neon|Ride"] = 58.64, ["Neon|Fly|Ride"] = 104.98, ["Mega"] = 277.59, ["Mega|Ride"] = 287.44, ["Mega|Fly|Ride"] = 698.2}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 18.15, ["Ride"] = 16.51, ["Fly|Ride"] = 39.38, ["Neon"] = 3.91, ["Neon|Fly"] = 20.94, ["Neon|Ride"] = 26.19, ["Neon|Fly|Ride"] = 58.74, ["Mega"] = 62.43, ["Mega|Fly"] = 104.69, ["Mega|Ride"] = 62.87, ["Mega|Fly|Ride"] = 154.83}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 836.36, ["Fly"] = 1179.97, ["Ride"] = 903, ["Fly|Ride"] = 1041.65, ["Neon|Ride"] = 4955.64, ["Neon|Fly|Ride"] = 4745.94, ["Mega"] = 28315.68, ["Mega|Fly|Ride"] = 27913.51}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 5.13, ["Fly"] = 977.8, ["Ride"] = 56.55, ["Neon"] = 36.74, ["Neon|Fly"] = 70.16, ["Neon|Ride"] = 70.2, ["Mega"] = 179.54, ["Mega|Ride"] = 235.98, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 7.86, ["Fly"] = 70.16, ["Ride"] = 50.75, ["Fly|Ride"] = 110.93, ["Neon"] = 35.61, ["Neon|Fly"] = 77.68, ["Neon|Ride"] = 70.16, ["Neon|Fly|Ride"] = 125.63, ["Mega|Ride"] = 224.46, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 40.85, ["Fly"] = 40.51, ["Ride"] = 31.87, ["Fly|Ride"] = 68.25, ["Neon"] = 165.38, ["Neon|Ride"] = 209.77, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 2093.51, ["Mega|Fly|Ride"] = 787.49}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 18.17, ["Fly"] = 78.52, ["Ride"] = 32.82, ["Fly|Ride"] = 63, ["Neon"] = 65.93, ["Neon|Ride"] = 126.26, ["Neon|Fly|Ride"] = 154.93, ["Mega"] = 288.75, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 448.02}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 23.12, ["Ride"] = 210, ["Fly|Ride"] = 338.16, ["Neon"] = 86.63, ["Neon|Ride"] = 183.1, ["Neon|Fly|Ride"] = 456.6, ["Mega"] = 486.18, ["Mega|Ride"] = 518.15, ["Mega|Fly|Ride"] = 613.4}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.59, ["Fly|Ride"] = 235.87, ["Neon"] = 2.63, ["Neon|Ride"] = 28.13, ["Mega"] = 20.97, ["Mega|Fly"] = 84.96, ["Mega|Ride"] = 41.62, ["Mega|Fly|Ride"] = 117.99}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 35.41, ["Fly"] = 74.82, ["Ride"] = 44.26, ["Fly|Ride"] = 103.68, ["Neon"] = 300.47, ["Neon|Fly"] = 276.4, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 1256.11, ["Mega|Fly|Ride"] = 956.82}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 27.2, ["Ride"] = 48.07, ["Fly|Ride"] = 70.87, ["Neon"] = 42.35, ["Neon|Ride"] = 140.28, ["Mega"] = 773.07, ["Mega|Ride"] = 274.25, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 20.62, ["Fly|Ride"] = 36.75, ["Neon"] = 18.85, ["Neon|Ride"] = 49.22, ["Neon|Fly|Ride"] = 131.24, ["Mega|Ride"] = 263.23, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 5.25, ["Ride"] = 103.69, ["Neon"] = 105, ["Neon|Ride"] = 837.41, ["Neon|Fly|Ride"] = 184.33, ["Mega"] = 293.1, ["Mega|Fly|Ride"] = 471.95}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 30.19, ["Fly"] = 262.37, ["Ride"] = 71.29, ["Fly|Ride"] = 144.38, ["Neon"] = 104.7, ["Neon|Fly"] = 308.84, ["Neon|Ride"] = 192.64, ["Neon|Fly|Ride"] = 233.44, ["Mega"] = 656.25, ["Mega|Ride"] = 763.53, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 5.16, ["Ride"] = 98.44, ["Neon"] = 24.94, ["Neon|Ride"] = 73.29, ["Neon|Fly|Ride"] = 127.72, ["Mega"] = 86.46, ["Mega|Fly"] = 78.75, ["Mega|Ride"] = 70.88, ["Mega|Fly|Ride"] = 272.36}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 27.85, ["Neon"] = 2.1, ["Neon|Ride"] = 41.89, ["Mega"] = 20.97, ["Mega|Ride"] = 47.16, ["Mega|Fly|Ride"] = 204.75}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 70.16, ["Ride"] = 21, ["Fly|Ride"] = 81.9, ["Neon"] = 3.93, ["Neon|Fly"] = 393.6, ["Neon|Ride"] = 20.95, ["Mega"] = 19.15, ["Mega|Fly"] = 73.29, ["Mega|Ride"] = 140.28, ["Mega|Fly|Ride"] = 106.32}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 25.9, ["Ride"] = 24.07, ["Fly|Ride"] = 49.79, ["Neon"] = 3.93, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 23.54, ["Neon|Fly|Ride"] = 75.38, ["Mega"] = 83.75, ["Mega|Ride"] = 165.4, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 5306.87, ["Neon"] = 15.72, ["Neon|Ride"] = 1312.5, ["Mega"] = 105, ["Mega|Ride"] = 148.65, ["Mega|Fly|Ride"] = 209.36}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 17.04, ["Fly|Ride"] = 41.32, ["Neon"] = 72.19, ["Neon|Fly"] = 52.36, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 77.17, ["Mega"] = 281.54, ["Mega|Ride"] = 278.24, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 81.66, ["Ride"] = 105, ["Fly|Ride"] = 418.76, ["Neon"] = 241.5, ["Neon|Ride"] = 298.91, ["Neon|Fly|Ride"] = 1046.76, ["Mega"] = 1094.86, ["Mega|Ride"] = 810.2, ["Mega|Fly|Ride"] = 1116.89}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 26.19, ["Ride"] = 19.92, ["Fly|Ride"] = 39.38, ["Neon"] = 3.83, ["Neon|Fly"] = 20.94, ["Neon|Ride"] = 23.05, ["Neon|Fly|Ride"] = 117.91, ["Mega"] = 52.36, ["Mega|Ride"] = 67.01, ["Mega|Fly|Ride"] = 79.07}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 8.49, ["Fly"] = 52.5, ["Ride"] = 61.37, ["Fly|Ride"] = 100.51, ["Neon"] = 59.72, ["Neon|Fly"] = 59.07, ["Neon|Ride"] = 58.97, ["Neon|Fly|Ride"] = 115.5, ["Mega"] = 350.68, ["Mega|Ride"] = 278.45, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 14, ["Fly"] = 31.87, ["Ride"] = 31.49, ["Fly|Ride"] = 78.73, ["Neon"] = 79.52, ["Neon|Fly"] = 94.4, ["Neon|Ride"] = 82.69, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 1046.76, ["Mega|Ride"] = 416.62, ["Mega|Fly|Ride"] = 405.11}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 2.1, ["Fly"] = 140.38, ["Ride"] = 20.95, ["Neon"] = 26.25, ["Neon|Ride"] = 70.16, ["Mega"] = 279.57, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 375.8}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 13.13, ["Fly|Ride"] = 43.29, ["Neon"] = 5.87, ["Neon|Fly"] = 40.85, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 45.94, ["Mega|Fly"] = 105, ["Mega|Ride"] = 61.69, ["Mega|Fly|Ride"] = 174.56}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.81, ["Fly"] = 77.48, ["Ride"] = 25.29, ["Neon"] = 23.62, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 70.14, ["Neon|Fly|Ride"] = 157.03, ["Mega"] = 126, ["Mega|Fly"] = 735, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 278.44}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 918.75, ["Fly"] = 1270.91, ["Ride"] = 969.94, ["Fly|Ride"] = 981.75, ["Neon"] = 2942.83, ["Neon|Fly"] = 2846.46, ["Neon|Ride"] = 1995, ["Neon|Fly|Ride"] = 2127.3, ["Mega|Fly|Ride"] = 7379.55}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 70.88, ["Fly"] = 158.13, ["Ride"] = 94.5, ["Neon"] = 263.83, ["Neon|Ride"] = 321.36, ["Neon|Fly|Ride"] = 466.87, ["Mega"] = 1658.05, ["Mega|Ride"] = 1556.52, ["Mega|Fly|Ride"] = 1339.23}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Ride"] = 68.39, ["Neon"] = 12.9, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 209.36, ["Mega"] = 70.16}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 36.64, ["Ride"] = 56.6, ["Fly|Ride"] = 170.63, ["Neon"] = 186.36, ["Neon|Ride"] = 182.2, ["Neon|Fly|Ride"] = 279.49, ["Mega"] = 1023.75, ["Mega|Ride"] = 992.33, ["Mega|Fly|Ride"] = 774.38}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 4.11, ["Ride"] = 39.38, ["Fly|Ride"] = 156.19, ["Neon"] = 55.34, ["Neon|Ride"] = 62.83, ["Neon|Fly|Ride"] = 278.44, ["Mega"] = 274.32, ["Mega|Fly|Ride"] = 1046.76}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 261.19, ["Fly"] = 418.76, ["Ride"] = 262.5, ["Fly|Ride"] = 272.21, ["Neon"] = 787.5, ["Neon|Ride"] = 1046.89, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 5583.35}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 102.37, ["Ride"] = 22.32, ["Fly|Ride"] = 129.93, ["Neon"] = 19.69, ["Neon|Ride"] = 53.9, ["Mega"] = 401.21, ["Mega|Fly"] = 279.49}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 104.9, ["Mega"] = 334.97}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 53.45, ["Ride"] = 102.38, ["Fly|Ride"] = 279.7, ["Neon"] = 341.25, ["Neon|Ride"] = 410.82, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 590.63, ["Mega|Ride"] = 551.25, ["Mega|Fly|Ride"] = 794.73}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 48.54, ["Fly|Ride"] = 158.13, ["Neon"] = 13.55, ["Neon|Ride"] = 45.93, ["Mega"] = 279.49, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 279.49}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 16.77, ["Ride"] = 15.72, ["Fly|Ride"] = 32.82, ["Neon"] = 3.15, ["Neon|Fly"] = 31.87, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 25.14, ["Mega|Fly"] = 70.16, ["Mega|Ride"] = 41.89, ["Mega|Fly|Ride"] = 94.5}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4200, ["Ride"] = 4331.25, ["Fly|Ride"] = 3937.5, ["Neon"] = 27218.66, ["Neon|Fly|Ride"] = 22331.24, ["Mega|Fly|Ride"] = 55827.01}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 11.6, ["Ride"] = 49.22, ["Neon"] = 70.14, ["Mega"] = 405.11, ["Mega|Ride"] = 370.57, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 19.91, ["Ride"] = 22.16, ["Fly|Ride"] = 60.37, ["Neon"] = 12.86, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 32.47, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 229.53, ["Mega|Ride"] = 119.44, ["Mega|Fly|Ride"] = 215.29}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 418.68, ["Fly"] = 515.08, ["Ride"] = 479.07, ["Fly|Ride"] = 523.68, ["Neon"] = 1312.5, ["Neon|Ride"] = 1358.68, ["Neon|Fly|Ride"] = 1169.44, ["Mega|Fly|Ride"] = 5136.38}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 3.71, ["Ride"] = 28.28, ["Neon"] = 17.07, ["Neon|Ride"] = 145.68, ["Mega"] = 124.59, ["Mega|Fly|Ride"] = 338.63}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.82, ["Fly"] = 4106.07, ["Ride"] = 941.15, ["Neon"] = 140.3, ["Neon|Ride"] = 279.54, ["Neon|Fly|Ride"] = 13957.29, ["Mega"] = 415.42, ["Mega|Ride"] = 401.63}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.33, ["Ride"] = 18.26, ["Fly|Ride"] = 82.55, ["Neon"] = 5.7, ["Neon|Fly"] = 124.67, ["Neon|Ride"] = 37.7, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 62.99, ["Mega|Ride"] = 76.12, ["Mega|Fly|Ride"] = 161.21}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 637.88, ["Ride"] = 611.52, ["Fly|Ride"] = 645.6, ["Neon"] = 2100, ["Neon|Fly|Ride"] = 1967.34, ["Mega|Fly|Ride"] = 9072.14}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 5.25, ["Ride"] = 59.07, ["Neon"] = 26.25, ["Neon|Ride"] = 86.9, ["Neon|Fly|Ride"] = 139.13, ["Mega"] = 148.32, ["Mega|Ride"] = 205.33, ["Mega|Fly|Ride"] = 330.44}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 6.22, ["Fly"] = 235.66, ["Ride"] = 65.62, ["Neon"] = 47.25, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 243.64, ["Mega|Ride"] = 246.5}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 41.28, ["Ride"] = 20.95, ["Fly|Ride"] = 63, ["Neon"] = 18.35, ["Neon|Fly"] = 70.16, ["Neon|Ride"] = 28.28, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 207.5, ["Mega|Ride"] = 158.1, ["Mega|Fly|Ride"] = 208.69}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 21, ["Ride"] = 92.4, ["Neon"] = 91.88, ["Neon|Fly"] = 170.63, ["Neon|Fly|Ride"] = 315.03, ["Mega"] = 518.15, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 522.34}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 39.37, ["Neon"] = 4.2, ["Neon|Ride"] = 54.54, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 36.75, ["Mega|Ride"] = 92.19, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 429.19, ["Ride"] = 453.29, ["Fly|Ride"] = 523.45, ["Neon"] = 1837.5, ["Neon|Ride"] = 2407.82, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Ride"] = 9202.6, ["Mega|Fly|Ride"] = 7848.75}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 53.79, ["Fly|Ride"] = 330.83, ["Neon"] = 8.99, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 65.63, ["Mega|Ride"] = 265.89, ["Mega|Fly|Ride"] = 375.8}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 52.49, ["Neon"] = 5.15, ["Neon|Ride"] = 209.85, ["Neon|Fly|Ride"] = 111.46, ["Mega"] = 46.23, ["Mega|Fly"] = 98.41, ["Mega|Ride"] = 98.41, ["Mega|Fly|Ride"] = 209.36}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 21.56, ["Neon"] = 7.88, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 140.28, ["Mega"] = 49.24, ["Mega|Fly"] = 154.93, ["Mega|Ride"] = 90.57}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 28.3, ["Neon|Ride"] = 47.21, ["Mega"] = 229.25, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 70.85, ["Ride"] = 132.57, ["Fly|Ride"] = 308.44, ["Neon"] = 251.37, ["Neon|Ride"] = 326.64, ["Neon|Fly|Ride"] = 1573.89, ["Mega"] = 942.09, ["Mega|Ride"] = 942.54, ["Mega|Fly|Ride"] = 915.48}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 30.66, ["Fly"] = 69.47, ["Ride"] = 65.6, ["Fly|Ride"] = 112.03, ["Neon"] = 99.94, ["Neon|Ride"] = 182.17, ["Mega"] = 463.31, ["Mega|Ride"] = 450.31, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 39.8, ["Ride"] = 18.36, ["Fly|Ride"] = 49.87, ["Neon"] = 30.39, ["Neon|Fly"] = 70.16, ["Neon|Ride"] = 35.07, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 393.6, ["Mega|Ride"] = 235.53, ["Mega|Fly|Ride"] = 261.7}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 8.81, ["Ride"] = 64.32, ["Fly|Ride"] = 78.53, ["Neon"] = 265.93, ["Neon|Ride"] = 158.07, ["Mega"] = 330.8, ["Mega|Ride"] = 786.95, ["Mega|Fly|Ride"] = 975.58}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 3.62, ["Fly"] = 247.08, ["Ride"] = 28.28, ["Fly|Ride"] = 56.55, ["Neon"] = 32.66, ["Neon|Ride"] = 66.94, ["Mega"] = 195.57, ["Mega|Ride"] = 368.47, ["Mega|Fly|Ride"] = 498.26}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 23.62, ["Fly"] = 70.82, ["Ride"] = 28.28, ["Fly|Ride"] = 56.23, ["Neon"] = 228.74, ["Neon|Ride"] = 209.39, ["Neon|Fly|Ride"] = 322.88, ["Mega"] = 941.04, ["Mega|Ride"] = 943.88, ["Mega|Fly|Ride"] = 736.93}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["Fly"] = 874.13, ["Neon|Ride"] = 471.95, ["Mega|Ride"] = 590.63}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 54.9, ["Fly"] = 115.5, ["Ride"] = 81.38, ["Fly|Ride"] = 139.13, ["Neon"] = 236.25, ["Neon|Fly"] = 348.04, ["Neon|Ride"] = 276.92, ["Neon|Fly|Ride"] = 355.91, ["Mega"] = 1151.43, ["Mega|Ride"] = 1143.95, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 57.75, ["Fly"] = 92.79, ["Ride"] = 81.38, ["Neon"] = 156.03, ["Neon|Ride"] = 188.79, ["Neon|Fly|Ride"] = 408.19, ["Mega"] = 512.52, ["Mega|Ride"] = 633.74, ["Mega|Fly|Ride"] = 551.64}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 26.18, ["Ride"] = 56.55, ["Neon"] = 135.19, ["Mega"] = 558.97, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 8.93, ["Fly"] = 31.4, ["Ride"] = 28.28, ["Fly|Ride"] = 78.75, ["Neon"] = 49.88, ["Neon|Fly"] = 167.51, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 116.28, ["Mega"] = 349.49, ["Mega|Ride"] = 416.62, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 20.95, ["Ride"] = 17.07, ["Fly|Ride"] = 41.89, ["Neon"] = 4.99, ["Neon|Fly"] = 24.89, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 62.83, ["Mega"] = 62.83, ["Mega|Fly"] = 209.36, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 156.85}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1458.18}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 23.6, ["Ride"] = 62.87, ["Fly|Ride"] = 131.25, ["Neon"] = 139.13, ["Neon|Fly"] = 278.49, ["Neon|Ride"] = 157.97, ["Neon|Fly|Ride"] = 296.24, ["Mega"] = 488.84, ["Mega|Ride"] = 523.39, ["Mega|Fly|Ride"] = 522.38}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 56.02, ["Neon"] = 3.87, ["Neon|Ride"] = 41.92, ["Neon|Fly|Ride"] = 293.1, ["Mega"] = 81.38, ["Mega|Ride"] = 90.04}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 24.94, ["Fly"] = 110.93, ["Neon"] = 208.34, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 708.75, ["Mega|Ride"] = 975.73, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.05, ["Neon"] = 6.46, ["Neon|Ride"] = 105, ["Mega"] = 78.75}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 5.38, ["Mega"] = 25.92, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 131.25, ["Ride"] = 196.88, ["Neon"] = 426.57, ["Neon|Fly"] = 620.65, ["Neon|Ride"] = 518.44, ["Neon|Fly|Ride"] = 522.43, ["Mega|Ride"] = 6489.02, ["Mega|Fly|Ride"] = 1886.94}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 26.11, ["Ride"] = 20.95, ["Fly|Ride"] = 70.81, ["Neon"] = 11.82, ["Neon|Fly"] = 62.83, ["Neon|Ride"] = 35.43, ["Neon|Fly|Ride"] = 68.25, ["Mega"] = 91.88, ["Mega|Ride"] = 141.32, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 40.14, ["Ride"] = 131.24, ["Fly|Ride"] = 86.63, ["Neon"] = 6.57, ["Neon|Fly"] = 62.83, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 47.25, ["Mega|Ride"] = 104.69, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.44, ["Mega"] = 30.83, ["Mega|Ride"] = 221.92, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.93, ["Neon|Ride"] = 30.32, ["Mega"] = 43.14, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 39.34, ["Ride"] = 111.57, ["Fly|Ride"] = 1047.52, ["Neon"] = 263.83, ["Neon|Ride"] = 401.44, ["Neon|Fly|Ride"] = 394.08, ["Mega"] = 1535.59, ["Mega|Ride"] = 1535.59, ["Mega|Fly|Ride"] = 1258.89}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.7, ["Ride"] = 36.53, ["Neon"] = 31.4, ["Neon|Ride"] = 110.93, ["Mega"] = 140.28, ["Mega|Ride"] = 830.17}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 372.66, ["Ride"] = 408.13, ["Fly|Ride"] = 616.88, ["Neon"] = 1396.55, ["Neon|Ride"] = 943.94, ["Neon|Fly|Ride"] = 1297.97, ["Mega|Ride"] = 3768.29, ["Mega|Fly|Ride"] = 3478.86}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 72.02}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 41.91}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 19.9}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 20.76}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 31.55}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 42}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 8.75}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 3.78}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 216.57}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 24.94}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.05}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 55.94}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 9.18}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 10.5}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 217.8}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 6.96}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 6.56}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 6.28}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 6.09}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 23.61}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 394.65}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 652.61}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 10.4}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1441.13}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 32.81}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 7.87}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 15.65}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 14.44}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 86.62}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 26.24}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 13.12}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 8.99}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 18.38}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.93}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 19.59}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 3.81}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 52.5}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 17.71}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 7.87}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1706.25}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 64.32}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.05}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 308.44}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 4.45}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 10.5}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 6.56}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 171.47}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 10.5}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 13.12}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 1045.72}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 16.84}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 7.65}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 15.74}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 4.86}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 147}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 22.32}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 7.86}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.05}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 23.54}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 11.31}},
    ["rbxassetid://1265129203"] = {name = "Ice Snowboard", prices = {["default"] = 236.25}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 4.87}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 32.61}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 115.42}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 165.19}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 10.28}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 26.25}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.94}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 77.32}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 64.95}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22417.73}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 208.42}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 32.82}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 57.75}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 28.88}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 78.75}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 62.91}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 52.5}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 209.9}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 78.75}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 34.01}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 86.15}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 41.94}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 44.88}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 75.16}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 354.37}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 9.19}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 8.38}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 7.92}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 20.98}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 51.1}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.24}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 2.1}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 3.92}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 1071}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 6.36}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 674.52}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 34.12}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 42.9}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 65.63}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 27.15}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 37.59}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 210}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 15.74}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 2.1}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 15.16}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.92}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 4.87}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 34.13}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.93}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.7}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.83}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 17.84}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 169.31}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.05}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.05}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.05}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1004.89}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 4.87}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 6.55}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 7.51}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 12.92}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 87.94}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 11.81}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 7.87}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 8.07}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 14.34}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 104.81}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 25.97}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 7.87}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 2.35}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 7.86}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 14.43}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.05}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 2.05}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 7.09}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 5.25}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 5670}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 37.7}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3.49}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 7.86}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.72}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 20.48}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 7.24}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.93}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 15.59}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.05}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 131.25}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 38.04}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 3.93}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.92}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 3.93}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.66}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 2602.22}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 4.66}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 56.16}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 2.1}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 81.38}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 5.16}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 279.49}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.05}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.23}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.89}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 2.1}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 3.92}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 18.25}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.56}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.67}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.05}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 13.13}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 6.9}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 8.86}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.2}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 6.27}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.78}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 36.66}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 185.77}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.56}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 8.54}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 76.95}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.35}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 89.86}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 2.62}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 19.56}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 945}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 20.78}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 5.25}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.05}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 74.46}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 7.88}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 12.38}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 26.25}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 15.73}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 15.1}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.66}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.94}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 19.66}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 9.35}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 19.85}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.92}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 2.26}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.63}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 16.76}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 63.51}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.63}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 11.52}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.63}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 4.09}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 49.88}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 16.69}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.93}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 117.96}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 13.84}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 3.78}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.05}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 5.25}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 11.43}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 86.63}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 112.88}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 5.24}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1127.44}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 154.88}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 6.57}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 10.5}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 37.89}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 5.84}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 7.85}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 125.63}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 11.44}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 2.99}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 3.93}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 8.39}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 49.22}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 4.41}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 57.75}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 3.94}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 28.03}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 94.39}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 3.72}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 66.94}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 5.99}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 3.92}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 70.7}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.05}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 70.19}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 177.19}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 360.89}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 91.25}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 182.15}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.73}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 15.64}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 39.19}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 4.2}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 38.07}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.15}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 7.8}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 9.19}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 43.32}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 14.16}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 7.54}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 7.77}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 23.63}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 45.94}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 5.13}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 4.47}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 34.01}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 2.61}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 9.08}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 60.38}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 32.82}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 31.14}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1624.55}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 4.64}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 3.93}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 78.75}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 271.68}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 12.47}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 7.45}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 9.19}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 9.08}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 170.63}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 45.94}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 52.39}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 11.38}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 77.44}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 102.38}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 78.75}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1045.72}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 171.71}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 5.25}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1396.38}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 393.75}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 2.1}},
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