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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1019.18, ["Ride"] = 1133.68, ["Fly|Ride"] = 1275, ["Neon"] = 6666.53, ["Neon|Fly|Ride"] = 3921.75, ["Mega|Fly|Ride"] = 22311.17}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 454.68, ["Fly"] = 544.79, ["Ride"] = 396.38, ["Fly|Ride"] = 563.13, ["Neon|Ride"] = 2231.24, ["Neon|Fly|Ride"] = 1954.99, ["Mega"] = 9917.27, ["Mega|Fly|Ride"] = 8307.59}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4725, ["Ride"] = 5250, ["Fly|Ride"] = 4756.5, ["Neon"] = 26208.37, ["Neon|Fly|Ride"] = 21425.72, ["Mega|Fly|Ride"] = 67291.53}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 131.25, ["Ride"] = 169.32, ["Fly|Ride"] = 250.59, ["Neon"] = 903.13, ["Neon|Ride"] = 821.63, ["Neon|Fly|Ride"] = 1133.68, ["Mega"] = 3824.98, ["Mega|Fly|Ride"] = 2829.28}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 632.63, ["Fly"] = 666.2, ["Ride"] = 538.13, ["Fly|Ride"] = 539.44, ["Neon|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 6717.8}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 10.48, ["Ride"] = 36.14, ["Fly|Ride"] = 142.38, ["Neon"] = 59.52, ["Neon|Ride"] = 91.4, ["Neon|Fly|Ride"] = 283.7, ["Mega"] = 328.13, ["Mega|Fly|Ride"] = 419.7}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 5.25, ["Fly"] = 32.82, ["Ride"] = 24, ["Fly|Ride"] = 63.94, ["Neon"] = 32.82, ["Neon|Fly"] = 52.39, ["Neon|Ride"] = 47.63, ["Neon|Fly|Ride"] = 106.32, ["Mega"] = 177.19, ["Mega|Fly"] = 357.15, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 247.95}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 104.99, ["Ride"] = 157.26, ["Fly|Ride"] = 178.5, ["Neon"] = 488.25, ["Neon|Ride"] = 517.44, ["Neon|Fly|Ride"] = 636.45, ["Mega"] = 1904.74, ["Mega|Fly|Ride"] = 1984.75}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 36.75, ["Fly"] = 143.45, ["Ride"] = 47.63, ["Fly|Ride"] = 104.56, ["Neon"] = 223.13, ["Neon|Ride"] = 210.39, ["Neon|Fly|Ride"] = 221.82, ["Mega"] = 2100, ["Mega|Ride"] = 2730, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 23.21, ["Fly"] = 45.7, ["Ride"] = 34.13, ["Fly|Ride"] = 60.58, ["Neon"] = 198.71, ["Neon|Ride"] = 314.89, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 743.76, ["Mega|Fly|Ride"] = 735}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 52.45, ["Fly"] = 289.02, ["Ride"] = 73.5, ["Fly|Ride"] = 127.32, ["Neon"] = 317.7, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 283.7, ["Mega|Ride"] = 1417.37, ["Mega|Fly|Ride"] = 1380.93}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 81.38}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 377.9, ["Fly"] = 387.19, ["Ride"] = 367.5, ["Fly|Ride"] = 436.8, ["Neon|Fly|Ride"] = 1089.38, ["Mega|Fly|Ride"] = 6942.3}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 84, ["Fly"] = 129.94, ["Ride"] = 105, ["Fly|Ride"] = 146.64, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 589.7, ["Mega|Fly|Ride"] = 2613.19}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.57, ["Fly"] = 36.14, ["Ride"] = 23.97, ["Fly|Ride"] = 142.38, ["Neon"] = 20.14, ["Neon|Ride"] = 65.63, ["Mega"] = 118.65, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 383.25}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 131.25, ["Fly"] = 198.71, ["Ride"] = 135.19, ["Fly|Ride"] = 158.81, ["Neon"] = 708.69, ["Neon|Ride"] = 636.45, ["Neon|Fly|Ride"] = 564.38, ["Mega|Fly|Ride"] = 1837.38}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.66, ["Fly"] = 27.2, ["Ride"] = 19.48, ["Fly|Ride"] = 52.38, ["Neon"] = 27.64, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 196.88, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 305.82}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 47.63, ["Fly"] = 262.5, ["Ride"] = 98.44, ["Fly|Ride"] = 234.82, ["Neon"] = 216.57, ["Neon|Ride"] = 228.37, ["Neon|Fly|Ride"] = 409.66, ["Mega"] = 1414.19, ["Mega|Ride"] = 904.4, ["Mega|Fly|Ride"] = 782.17}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 39.38}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 73.5, ["Ride"] = 142.38, ["Fly|Ride"] = 246.1, ["Neon"] = 525, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 2362.5}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 12.8, ["Fly"] = 393.75, ["Ride"] = 26.17, ["Fly|Ride"] = 106.26, ["Neon"] = 128.93, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 269.89, ["Mega"] = 2738.05, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 1699.99}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 32.32, ["Fly"] = 71.21, ["Ride"] = 43.19, ["Fly|Ride"] = 104, ["Neon"] = 336, ["Neon|Fly"] = 316.64, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 233.63, ["Mega"] = 1681.32, ["Mega|Ride"] = 850, ["Mega|Fly|Ride"] = 807.5}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 57.75, ["Fly"] = 105, ["Ride"] = 155.76, ["Fly|Ride"] = 140.26, ["Neon"] = 236.25, ["Neon|Fly"] = 395.25, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 283.7, ["Mega"] = 1699.99, ["Mega|Ride"] = 1270.75, ["Mega|Fly|Ride"] = 1261.18}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 28.32, ["Fly"] = 64.3, ["Ride"] = 42, ["Fly|Ride"] = 171.29, ["Neon"] = 184.89, ["Neon|Ride"] = 198.71, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 1207.92, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1256.93}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 62.99, ["Fly"] = 570.15, ["Ride"] = 78.75, ["Fly|Ride"] = 131.25, ["Neon"] = 280.01, ["Neon|Ride"] = 309.68, ["Neon|Fly|Ride"] = 293.26, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 848.94}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 6.29, ["Fly"] = 28.88, ["Ride"] = 23.63, ["Fly|Ride"] = 57.75, ["Neon"] = 27.64, ["Neon|Fly"] = 70.86, ["Neon|Ride"] = 40.27, ["Neon|Fly|Ride"] = 71.19, ["Mega"] = 131.25, ["Mega|Fly"] = 28368.41, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 238.77}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 294, ["Fly"] = 371.88, ["Ride"] = 337.89, ["Fly|Ride"] = 362.25, ["Neon"] = 1475.25, ["Neon|Ride"] = 1417.37, ["Neon|Fly|Ride"] = 1571.43, ["Mega"] = 10624.87, ["Mega|Fly|Ride"] = 7332.94}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 16.7, ["Ride"] = 24.9, ["Fly|Ride"] = 138.13, ["Neon"] = 241.2, ["Neon|Ride"] = 159.53, ["Neon|Fly|Ride"] = 420.76, ["Mega"] = 836.19, ["Mega|Ride"] = 714.28, ["Mega|Fly|Ride"] = 827.69}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 6.38, ["Fly"] = 37.69, ["Ride"] = 21.26, ["Fly|Ride"] = 36.75, ["Neon"] = 49.88, ["Neon|Ride"] = 42.51, ["Neon|Fly|Ride"] = 118.58, ["Mega"] = 425.01, ["Mega|Ride"] = 425.01, ["Mega|Fly|Ride"] = 473.88}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 97.13, ["Fly"] = 124.77, ["Ride"] = 111.92, ["Fly|Ride"] = 157.5, ["Neon"] = 419.7, ["Neon|Ride"] = 449.46, ["Neon|Fly|Ride"] = 382.51, ["Mega"] = 6308.21, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 1812.61}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 11.82, ["Ride"] = 26.25, ["Fly|Ride"] = 57.39, ["Neon"] = 96.71, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 714.28, ["Mega|Ride"] = 650.26, ["Mega|Fly|Ride"] = 698.81}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 157.5, ["Fly"] = 354.88, ["Ride"] = 218.57, ["Fly|Ride"] = 293.12, ["Neon"] = 786.27, ["Neon|Ride"] = 828.75, ["Neon|Fly|Ride"] = 773.07, ["Mega"] = 6374.93, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2989.85}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 30.98}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.94, ["Fly"] = 36.14, ["Ride"] = 22.64, ["Fly|Ride"] = 51.01, ["Neon"] = 21, ["Neon|Fly"] = 92.87, ["Neon|Ride"] = 54.78, ["Neon|Fly|Ride"] = 147.7, ["Mega"] = 131.25, ["Mega|Fly"] = 238.1, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 302.39}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 916.13, ["Ride"] = 958.13, ["Fly|Ride"] = 1097.25, ["Neon"] = 4761.81, ["Neon|Ride"] = 5248.69, ["Neon|Fly|Ride"] = 4593.75, ["Mega"] = 20399.75, ["Mega|Ride"] = 53570.22, ["Mega|Fly|Ride"] = 15584.58}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 9.05, ["Fly"] = 28.49, ["Ride"] = 23.34, ["Fly|Ride"] = 87.94, ["Neon"] = 108.4, ["Neon|Ride"] = 113.08, ["Neon|Fly|Ride"] = 141.62, ["Mega"] = 364.45, ["Mega|Ride"] = 616.26, ["Mega|Fly|Ride"] = 635.71}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 94.5, ["Ride"] = 124.69, ["Fly|Ride"] = 183.75, ["Neon"] = 656.25, ["Neon|Ride"] = 637.51, ["Neon|Fly|Ride"] = 685.13, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 2466.11}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 25.99}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 17.85, ["Fly"] = 68.85, ["Ride"] = 55.13, ["Fly|Ride"] = 144.38, ["Neon"] = 91.41, ["Neon|Fly"] = 170.01, ["Neon|Ride"] = 206.07, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 637.51, ["Mega|Ride"] = 723.19, ["Mega|Fly|Ride"] = 746.43}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 94.5, ["Ride"] = 199.5, ["Fly|Ride"] = 260.72, ["Neon"] = 478.13, ["Neon|Ride"] = 478.13, ["Neon|Fly|Ride"] = 590.63, ["Mega|Fly|Ride"] = 2165.63}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 119.05, ["Fly"] = 222.63, ["Ride"] = 119.05, ["Fly|Ride"] = 142.87, ["Neon"] = 438.38, ["Neon|Ride"] = 366.18, ["Neon|Fly|Ride"] = 640.5, ["Mega"] = 1378.13, ["Mega|Ride"] = 1486.43, ["Mega|Fly|Ride"] = 1458.19}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 44.63}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 60.38, ["Fly"] = 65.63, ["Ride"] = 45.94, ["Fly|Ride"] = 65.63, ["Neon"] = 609.89, ["Neon|Ride"] = 333.64, ["Neon|Fly|Ride"] = 354.88, ["Mega"] = 4248.9, ["Mega|Fly|Ride"] = 1286.25}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 7.5, ["Ride"] = 30.19, ["Fly|Ride"] = 85.32, ["Neon"] = 49.95, ["Neon|Ride"] = 99.89, ["Neon|Fly|Ride"] = 236.95, ["Mega"] = 184.89, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 168, ["Mega|Fly|Ride"] = 349.75}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 346.5, ["Fly"] = 420, ["Ride"] = 354.38, ["Fly|Ride"] = 406.23, ["Neon|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 1226.99, ["Mega|Fly|Ride"] = 4802.45}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 85.01, ["Fly"] = 99.75, ["Ride"] = 94.5, ["Fly|Ride"] = 138.13, ["Neon"] = 361.26, ["Neon|Ride"] = 365.49, ["Neon|Fly|Ride"] = 367.49, ["Mega"] = 2833.66, ["Mega|Fly|Ride"] = 1908.24}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 4036.4, ["Ride"] = 3961.13, ["Fly|Ride"] = 3017.43, ["Neon|Fly|Ride"] = 14873.77}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 42, ["Fly"] = 113.7, ["Ride"] = 47.44, ["Fly|Ride"] = 95.82, ["Neon"] = 265.63, ["Neon|Ride"] = 266.69, ["Neon|Fly|Ride"] = 297.51, ["Mega|Ride"] = 1651.12, ["Mega|Fly|Ride"] = 2267.35}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 71.58, ["Ride"] = 91.4, ["Fly|Ride"] = 142.87, ["Neon"] = 525.95, ["Neon|Ride"] = 797.48, ["Neon|Fly|Ride"] = 567.38, ["Mega"] = 6374.93, ["Mega|Fly|Ride"] = 1818.98}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 37.97, ["Fly"] = 79.7, ["Ride"] = 57.21, ["Fly|Ride"] = 124.69, ["Neon"] = 131.25, ["Neon|Fly"] = 282.63, ["Neon|Ride"] = 159.89, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 2625, ["Mega|Fly|Ride"] = 693.35}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 8.67}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 52.49, ["Ride"] = 65.63, ["Fly|Ride"] = 116.52, ["Neon"] = 328.13, ["Neon|Ride"] = 476.2, ["Neon|Fly|Ride"] = 501.38, ["Mega|Ride"] = 1417.37, ["Mega|Fly|Ride"] = 1826.16}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 41.91}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 223.64, ["Ride"] = 234.82, ["Fly|Ride"] = 249.69, ["Neon|Ride"] = 3506.22, ["Neon|Fly|Ride"] = 1530}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 761.25, ["Ride"] = 774.38, ["Fly|Ride"] = 853.13, ["Neon|Ride"] = 3399.97, ["Neon|Fly|Ride"] = 3150, ["Mega|Fly|Ride"] = 11812.5}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 13.12}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 23.39, ["Fly"] = 52.43, ["Ride"] = 47.25, ["Fly|Ride"] = 63, ["Neon"] = 162.75, ["Neon|Ride"] = 151.2, ["Neon|Fly|Ride"] = 212.51, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 758.45}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 11.81}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5250, ["Fly"] = 5779.94, ["Ride"] = 6374.93, ["Fly|Ride"] = 4198.68, ["Neon|Fly|Ride"] = 10498.69, ["Mega|Fly|Ride"] = 35416.94}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 11.81, ["Fly"] = 74.52, ["Ride"] = 24.94, ["Fly|Ride"] = 64, ["Neon"] = 97.02, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 185.95, ["Mega"] = 406.88, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 561.51}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 13.37, ["Fly"] = 191.66, ["Ride"] = 32.82, ["Fly|Ride"] = 117.88, ["Neon"] = 85.32, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 231, ["Mega"] = 476, ["Mega|Ride"] = 522.76, ["Mega|Fly|Ride"] = 694.87}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 99.36, ["Fly"] = 139.21, ["Ride"] = 94.96, ["Fly|Ride"] = 140.44, ["Neon"] = 1417.37, ["Neon|Fly|Ride"] = 420, ["Mega"] = 4249.96}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 9.54, ["Ride"] = 34.01, ["Fly|Ride"] = 32.82, ["Neon"] = 61.64, ["Neon|Ride"] = 90.48, ["Neon|Fly|Ride"] = 462.53, ["Mega"] = 1417.37, ["Mega|Ride"] = 417.03, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 2100, ["Fly"] = 2501.1, ["Ride"] = 2266.77, ["Fly|Ride"] = 2097.9, ["Neon|Fly"] = 4775.89, ["Neon|Fly|Ride"] = 3936.19, ["Mega|Fly|Ride"] = 15079.32}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 34168.32, ["Fly"] = 35555.15, ["Ride"] = 35416.94, ["Fly|Ride"] = 22914.94, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 68253.21, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 198331.19}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 16.65, ["Fly"] = 393.75, ["Ride"] = 42, ["Fly|Ride"] = 63.74, ["Neon"] = 135.73, ["Neon|Ride"] = 174.57, ["Neon|Fly|Ride"] = 283.7, ["Mega"] = 751.2, ["Mega|Ride"] = 1102.5, ["Mega|Fly|Ride"] = 1397.82}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.94, ["Fly"] = 32.82, ["Ride"] = 34.13, ["Fly|Ride"] = 142.38, ["Neon"] = 15.9, ["Neon|Fly"] = 134.39, ["Neon|Ride"] = 52.39, ["Neon|Fly|Ride"] = 142.38, ["Mega"] = 126.93, ["Mega|Fly"] = 191.26, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 23.51}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 9.09, ["Ride"] = 42, ["Fly|Ride"] = 111.57, ["Neon"] = 52.5, ["Neon|Ride"] = 105.25, ["Neon|Fly|Ride"] = 463.32, ["Mega"] = 393.75, ["Mega|Ride"] = 397.39, ["Mega|Fly|Ride"] = 538.7}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 630, ["Ride"] = 675.94, ["Fly|Ride"] = 786.19, ["Neon"] = 3016.61, ["Neon|Ride"] = 2549.98, ["Neon|Fly|Ride"] = 2522.36, ["Mega|Fly|Ride"] = 11111.66}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 918.75, ["Fly"] = 962.07, ["Ride"] = 909.33, ["Fly|Ride"] = 1133.68, ["Neon|Ride"] = 3683.66, ["Neon|Fly|Ride"] = 3071.25}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 19.69, ["Fly"] = 119.05, ["Ride"] = 70.14, ["Fly|Ride"] = 57.39, ["Neon"] = 159.53, ["Neon|Ride"] = 140.26, ["Neon|Fly|Ride"] = 220.5, ["Mega"] = 1033.81, ["Mega|Ride"] = 1522.5, ["Mega|Fly|Ride"] = 713.72}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 30.19}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 57.75, ["Fly"] = 127.51, ["Ride"] = 71.45, ["Fly|Ride"] = 147, ["Neon|Ride"] = 397.39, ["Neon|Fly|Ride"] = 408.34, ["Mega|Fly|Ride"] = 1598.63}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 67.71, ["Ride"] = 84, ["Fly|Ride"] = 195.39, ["Neon"] = 397.38, ["Neon|Ride"] = 326.21, ["Neon|Fly|Ride"] = 510.01, ["Mega"] = 2141.15, ["Mega|Fly|Ride"] = 1558.69}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.77, ["Fly"] = 32.78, ["Ride"] = 20.9, ["Fly|Ride"] = 54.79, ["Neon"] = 27.64, ["Neon|Fly"] = 317.86, ["Neon|Ride"] = 77.42, ["Neon|Fly|Ride"] = 125.39, ["Mega"] = 315, ["Mega|Fly"] = 340.01, ["Mega|Fly|Ride"] = 371.44}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 68.25, ["Fly"] = 91.88, ["Ride"] = 91.88, ["Fly|Ride"] = 145.91, ["Neon"] = 820.25, ["Neon|Ride"] = 284.82, ["Neon|Fly|Ride"] = 315, ["Mega|Fly|Ride"] = 979.18}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.92, ["Ride"] = 40.68, ["Fly|Ride"] = 262.5, ["Neon"] = 26.25, ["Neon|Ride"] = 84.99, ["Mega"] = 157.5, ["Mega|Fly"] = 992.38, ["Mega|Ride"] = 310.24, ["Mega|Fly|Ride"] = 384.13}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 12.46, ["Fly"] = 65.63, ["Ride"] = 28.7, ["Fly|Ride"] = 99.89, ["Neon"] = 142.38, ["Neon|Fly"] = 106.26, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 139.2, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 23.63, ["Ride"] = 44.62, ["Fly|Ride"] = 156.19, ["Neon"] = 198.71, ["Neon|Ride"] = 185.95, ["Mega|Ride"] = 1161.57, ["Mega|Fly|Ride"] = 705.5}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 14.44, ["Fly"] = 77.33, ["Ride"] = 24.94, ["Fly|Ride"] = 82.69, ["Neon"] = 79.7, ["Neon|Ride"] = 90.2, ["Neon|Fly|Ride"] = 134.95, ["Mega|Ride"] = 945.62, ["Mega|Fly|Ride"] = 950.94}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 7083.62, ["Ride"] = 5906.25, ["Fly|Ride"] = 5158.13, ["Neon"] = 31168.06, ["Neon|Fly|Ride"] = 23995.2}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 220.77, ["Fly"] = 255.29, ["Ride"] = 262.5, ["Fly|Ride"] = 282.19, ["Neon"] = 666.2, ["Neon|Ride"] = 658.76, ["Neon|Fly|Ride"] = 600.5, ["Mega|Fly|Ride"] = 2149.88}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 28.88, ["Fly"] = 85.01, ["Ride"] = 57.16, ["Fly|Ride"] = 105, ["Neon"] = 78.52, ["Neon|Fly"] = 159.53, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 195.57, ["Mega"] = 286.13, ["Mega|Fly"] = 374.07, ["Mega|Ride"] = 312.45, ["Mega|Fly|Ride"] = 401.45}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.19, ["Fly"] = 42.51, ["Ride"] = 20.9, ["Fly|Ride"] = 91.4, ["Neon"] = 21, ["Neon|Ride"] = 79.7, ["Neon|Fly|Ride"] = 193.39, ["Mega"] = 141.75, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 23.82, ["Fly"] = 99.49, ["Ride"] = 52.5, ["Fly|Ride"] = 154.49, ["Neon"] = 113.7, ["Neon|Fly"] = 297.51, ["Neon|Ride"] = 142.38, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 418.69, ["Mega|Ride"] = 449.06, ["Mega|Fly|Ride"] = 531.26}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 18417.16, ["Ride"] = 15873.46, ["Fly|Ride"] = 11287.5, ["Neon|Fly|Ride"] = 23625, ["Mega|Fly|Ride"] = 92082.54}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 152.25, ["Ride"] = 187.02, ["Fly|Ride"] = 249.69, ["Neon"] = 847.88, ["Neon|Ride"] = 847.88, ["Neon|Fly|Ride"] = 1129.45, ["Mega|Fly|Ride"] = 7142.71}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 45.94, ["Fly"] = 459.38, ["Ride"] = 52.5, ["Fly|Ride"] = 103.69, ["Neon|Fly"] = 476.2, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 295.32, ["Mega|Fly|Ride"] = 2039.99}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 10.28, ["Fly"] = 32.16, ["Ride"] = 24.18, ["Fly|Ride"] = 65.54, ["Neon"] = 65.63, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 2549.98, ["Mega|Ride"] = 510.01, ["Mega|Fly|Ride"] = 498.67}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 387.19, ["Ride"] = 420, ["Fly|Ride"] = 505.44, ["Neon"] = 1639.32, ["Neon|Ride"] = 1311.19, ["Neon|Fly|Ride"] = 1255.87, ["Mega|Ride"] = 4724.98, ["Mega|Fly|Ride"] = 4374.57}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 5.98, ["Fly"] = 88.11, ["Ride"] = 28.7, ["Fly|Ride"] = 95.26, ["Neon"] = 28.06, ["Neon|Ride"] = 83.91, ["Neon|Fly|Ride"] = 282.63, ["Mega"] = 117.84, ["Mega|Ride"] = 111.57, ["Mega|Fly|Ride"] = 240.13}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 183.75, ["Fly"] = 393.75, ["Ride"] = 199.5, ["Fly|Ride"] = 287.44, ["Neon"] = 771.74, ["Neon|Ride"] = 697.35, ["Neon|Fly|Ride"] = 786.19, ["Mega|Ride"] = 2968.6, ["Mega|Fly|Ride"] = 2624.99}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.7, ["Fly"] = 21.25, ["Ride"] = 18.95, ["Fly|Ride"] = 38.27, ["Neon|Ride"] = 119.05, ["Neon|Fly|Ride"] = 95.64, ["Mega"] = 786.19, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 10.63}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 57.75, ["Ride"] = 95.26, ["Fly|Ride"] = 525, ["Neon"] = 191.26, ["Neon|Fly"] = 1699.99, ["Neon|Ride"] = 423.95, ["Neon|Fly|Ride"] = 737.38, ["Mega"] = 1402.5, ["Mega|Ride"] = 1428.55, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 11.81, ["Fly"] = 61.92, ["Ride"] = 32.01, ["Fly|Ride"] = 84, ["Neon"] = 95.82, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 157.4, ["Mega"] = 479.72, ["Mega|Ride"] = 501.48, ["Mega|Fly|Ride"] = 557.82}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 14.69}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 26.24, ["Fly"] = 109.33, ["Ride"] = 63.5, ["Fly|Ride"] = 99.75, ["Neon"] = 170.62, ["Neon|Ride"] = 198.71, ["Neon|Fly|Ride"] = 241.19, ["Mega"] = 708.69, ["Mega|Ride"] = 779.88, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.93, ["Ride"] = 37.2, ["Fly|Ride"] = 131.25, ["Neon"] = 19.66, ["Neon|Ride"] = 107.15, ["Neon|Fly|Ride"] = 126.45, ["Mega"] = 110.63, ["Mega|Fly|Ride"] = 639.85}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 15.74, ["Fly"] = 71.21, ["Ride"] = 30.19, ["Fly|Ride"] = 76.12, ["Neon|Ride"] = 138.13, ["Neon|Fly|Ride"] = 227.38, ["Mega"] = 707.63, ["Mega|Ride"] = 476.2, ["Mega|Fly|Ride"] = 759.94}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 380.39, ["Fly"] = 437.76, ["Ride"] = 328.13, ["Fly|Ride"] = 409.5, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 7792.3}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 31.49, ["Ride"] = 78.64, ["Fly|Ride"] = 142.38, ["Neon"] = 253.31, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 269.89, ["Mega"] = 705.62, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 45.82, ["Fly"] = 84.48, ["Ride"] = 63, ["Fly|Ride"] = 145.61, ["Neon"] = 197.65, ["Neon|Ride"] = 206.14, ["Neon|Fly|Ride"] = 423.95, ["Mega"] = 1270.23, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1147.5}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 23.82, ["Fly"] = 61.19, ["Ride"] = 74.79, ["Fly|Ride"] = 131.25, ["Neon"] = 100.82, ["Neon|Ride"] = 153.57, ["Neon|Fly|Ride"] = 233.63, ["Mega"] = 395.26, ["Mega|Ride"] = 405.57, ["Mega|Fly|Ride"] = 522.38}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 9843.75, ["Ride"] = 11428.32, ["Fly|Ride"] = 8452.5, ["Neon|Fly|Ride"] = 15908.09, ["Mega|Fly|Ride"] = 39372.9}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1879.89, ["Fly"] = 1837.5, ["Ride"] = 1824.38, ["Fly|Ride"] = 1837.5, ["Neon|Fly|Ride"] = 4987.5, ["Mega|Fly|Ride"] = 23100}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 388.5, ["Ride"] = 467.51, ["Fly|Ride"] = 446.25, ["Neon"] = 2124.99, ["Neon|Ride"] = 1738.24, ["Neon|Fly|Ride"] = 1757.37, ["Mega"] = 11904.5, ["Mega|Fly|Ride"] = 6658.62}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 14.16, ["Fly"] = 30.82, ["Ride"] = 23.61, ["Fly|Ride"] = 41.82, ["Neon"] = 113.7, ["Neon|Ride"] = 105.27, ["Neon|Fly|Ride"] = 105, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 3.94, ["Fly"] = 39.38, ["Ride"] = 41.22, ["Fly|Ride"] = 111.56, ["Neon"] = 31.88, ["Neon|Ride"] = 48.89, ["Mega"] = 143.73, ["Mega|Ride"] = 174.57, ["Mega|Fly|Ride"] = 241.2}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 35.44, ["Fly"] = 52.39, ["Ride"] = 40.58, ["Fly|Ride"] = 85.01, ["Neon"] = 189.14, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 164.07, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.29, ["Fly"] = 27.2, ["Ride"] = 17.07, ["Fly|Ride"] = 39.05, ["Neon"] = 27.64, ["Neon|Fly"] = 55.65, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 97.34, ["Mega"] = 360.94, ["Mega|Ride"] = 295.32, ["Mega|Fly|Ride"] = 344.26}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 295.8, ["Fly"] = 320.24, ["Ride"] = 322.9, ["Fly|Ride"] = 341.25, ["Neon|Ride"] = 1785.69, ["Neon|Fly|Ride"] = 1396.12, ["Mega|Fly|Ride"] = 7437.43}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 26.25, ["Fly"] = 48.19, ["Ride"] = 34.2, ["Fly|Ride"] = 79.77, ["Neon"] = 142.87, ["Neon|Ride"] = 141.6, ["Neon|Fly|Ride"] = 221.02, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 11.8, ["Fly"] = 24.44, ["Ride"] = 24.45, ["Fly|Ride"] = 39.38, ["Neon"] = 142.38, ["Neon|Fly"] = 136.5, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 531.26, ["Mega|Ride"] = 585.44, ["Mega|Fly|Ride"] = 874.13}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 567.38, ["Fly"] = 787.5, ["Ride"] = 262.5, ["Fly|Ride"] = 476.2, ["Neon|Ride"] = 2762.48, ["Mega|Fly|Ride"] = 8619.19}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1059.55, ["Fly"] = 1428.55, ["Ride"] = 1173.24, ["Fly|Ride"] = 1178.62, ["Neon"] = 4972.46, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 17142.18}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 102.37, ["Fly"] = 121.13, ["Ride"] = 101.52, ["Fly|Ride"] = 131.34, ["Neon"] = 505.76, ["Neon|Ride"] = 416.06, ["Neon|Fly|Ride"] = 422.63, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 159.53, ["Fly"] = 207.16, ["Ride"] = 168, ["Fly|Ride"] = 196.88, ["Neon"] = 701.26, ["Neon|Fly"] = 892.5, ["Neon|Ride"] = 694.87, ["Neon|Fly|Ride"] = 649.2, ["Mega"] = 4249.96, ["Mega|Ride"] = 8596.88, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 26.25, ["Fly"] = 131.25, ["Ride"] = 41.99, ["Fly|Ride"] = 283.7, ["Neon"] = 183.75, ["Neon|Fly"] = 425.01, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 368.69, ["Mega|Ride"] = 1417.37, ["Mega|Fly|Ride"] = 873.8}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 142.38, ["Ride"] = 210.74, ["Fly|Ride"] = 597.19, ["Neon"] = 1062.5, ["Mega|Fly|Ride"] = 3159.85}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2220.75, ["Fly"] = 2545.73, ["Ride"] = 2415, ["Fly|Ride"] = 2543.61, ["Neon|Fly|Ride"] = 7224.93, ["Mega|Fly|Ride"] = 48874.4}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 57.14, ["Ride"] = 49.59, ["Fly|Ride"] = 115.5, ["Neon"] = 292.2, ["Neon|Ride"] = 198.71, ["Neon|Fly|Ride"] = 352.75, ["Mega"] = 2118.62, ["Mega|Ride"] = 2337.48, ["Mega|Fly|Ride"] = 1757.37}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 652.38, ["Fly"] = 675.94, ["Ride"] = 619.5, ["Fly|Ride"] = 633.94, ["Neon|Ride"] = 1266.57, ["Neon|Fly|Ride"] = 1284.94, ["Mega|Fly|Ride"] = 2947.77}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 48.57, ["Fly"] = 52.5, ["Ride"] = 55.26, ["Fly|Ride"] = 102.38, ["Neon"] = 236.25, ["Neon|Ride"] = 369.06, ["Neon|Fly|Ride"] = 223.82, ["Mega|Fly|Ride"] = 1162.65}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.73, ["Fly"] = 32.82, ["Ride"] = 20.88, ["Fly|Ride"] = 39.38, ["Neon"] = 21, ["Neon|Fly"] = 159.53, ["Neon|Ride"] = 44.64, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 123.38, ["Mega|Fly"] = 252.89, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 20.9, ["Ride"] = 52.48, ["Fly|Ride"] = 131.25, ["Neon"] = 246.51, ["Neon|Ride"] = 267.77, ["Neon|Fly|Ride"] = 446.27, ["Mega|Ride"] = 1417.37, ["Mega|Fly|Ride"] = 952.38}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 615.55, ["Fly"] = 899.07, ["Ride"] = 574.74, ["Fly|Ride"] = 578.97, ["Neon"] = 1984.75, ["Neon|Ride"] = 1771.88, ["Neon|Fly|Ride"] = 1548.75, ["Mega|Fly|Ride"] = 5250}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 496.19, ["Ride"] = 525, ["Fly|Ride"] = 708.69, ["Neon"] = 5312.44, ["Neon|Ride"] = 4068.75, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 12698.54}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 15.74, ["Fly"] = 28.69, ["Ride"] = 24.94, ["Fly|Ride"] = 42.39, ["Neon"] = 212.51, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 787.5, ["Mega|Fly|Ride"] = 584.38}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 6.57, ["Fly"] = 28.7, ["Ride"] = 22.32, ["Fly|Ride"] = 63.41, ["Neon"] = 62.7, ["Neon|Ride"] = 78.64, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 1697.87, ["Mega|Ride"] = 449.46, ["Mega|Fly|Ride"] = 388.88}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.56, ["Ride"] = 36.14, ["Fly|Ride"] = 93.19, ["Neon"] = 19.69, ["Neon|Fly"] = 314.9, ["Neon|Ride"] = 57.6, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 131.25, ["Mega|Fly"] = 409.54, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 330.75}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 30.19, ["Fly"] = 59.05, ["Ride"] = 36.09, ["Fly|Ride"] = 98.44, ["Neon"] = 238.1, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 220.79, ["Mega|Fly|Ride"] = 708.65}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 39.31, ["Ride"] = 91.88, ["Fly|Ride"] = 1062.5, ["Neon"] = 267.77, ["Neon|Ride"] = 407.69, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1558.69, ["Mega|Ride"] = 1557.63, ["Mega|Fly|Ride"] = 1558.69}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 17.07, ["Fly"] = 65.63, ["Ride"] = 40.48, ["Fly|Ride"] = 91.38, ["Neon"] = 110.92, ["Neon|Fly"] = 151.2, ["Neon|Ride"] = 108.76, ["Neon|Fly|Ride"] = 170.52, ["Mega"] = 425.01, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 30.19, ["Fly"] = 65.04, ["Ride"] = 36.74, ["Fly|Ride"] = 87.31, ["Neon"] = 411.2, ["Neon|Ride"] = 147.94, ["Neon|Fly|Ride"] = 227.06, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1190.46}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.77, ["Fly"] = 31.49, ["Ride"] = 17.05, ["Fly|Ride"] = 39.38, ["Neon"] = 20.97, ["Neon|Ride"] = 37.7, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 196.88, ["Mega|Ride"] = 255.01, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 4.26, ["Fly"] = 65.63, ["Ride"] = 25.51, ["Fly|Ride"] = 79.77, ["Neon"] = 24.47, ["Neon|Fly"] = 159.53, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 240.13, ["Mega|Fly"] = 482.39, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 47.78, ["Fly"] = 60.31, ["Ride"] = 55.13, ["Fly|Ride"] = 79.7, ["Neon"] = 229.5, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 222.63, ["Neon|Fly|Ride"] = 220.05, ["Mega|Fly|Ride"] = 918.64}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1994.02, ["Fly"] = 2230.17, ["Ride"] = 1770.57, ["Fly|Ride"] = 1808.63, ["Neon|Ride"] = 4802.45, ["Neon|Fly|Ride"] = 3916.5, ["Mega|Fly|Ride"] = 16574.81}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 446.25, ["Fly"] = 499.38, ["Ride"] = 492.72, ["Fly|Ride"] = 572.7, ["Neon"] = 3174.94, ["Neon|Ride"] = 3117.35, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 9760.02}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 241.2, ["Fly"] = 340.01, ["Ride"] = 269.07, ["Fly|Ride"] = 367.5, ["Neon"] = 1202.53, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1524.69, ["Mega"] = 7437.43, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 42}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 26.25, ["Fly"] = 65.63, ["Ride"] = 60.58, ["Fly|Ride"] = 103.68, ["Neon"] = 206.07, ["Neon|Ride"] = 272, ["Neon|Fly|Ride"] = 382.51, ["Mega|Ride"] = 954.13, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 33999.58, ["Fly"] = 23625, ["Ride"] = 34781.25, ["Fly|Ride"] = 18375, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 318.76, ["Fly"] = 361.26, ["Ride"] = 326.21, ["Fly|Ride"] = 361.26, ["Neon"] = 1119.88, ["Neon|Fly"] = 1063.13, ["Neon|Ride"] = 1176.18, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 6374.93, ["Mega|Ride"] = 6666.53, ["Mega|Fly|Ride"] = 3543.41}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 127.39, ["Fly"] = 142.38, ["Ride"] = 127.39, ["Fly|Ride"] = 154.88, ["Neon|Ride"] = 1042.31, ["Neon|Fly|Ride"] = 1062.5, ["Mega|Fly|Ride"] = 4249.96}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 103.69, ["Fly"] = 257.25, ["Ride"] = 137.82, ["Fly|Ride"] = 206.07, ["Neon"] = 850, ["Neon|Ride"] = 743.75, ["Neon|Fly|Ride"] = 850, ["Mega"] = 14167.21, ["Mega|Fly|Ride"] = 2578.68}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 13.13, ["Fly"] = 66.95, ["Ride"] = 32.86, ["Fly|Ride"] = 98.44, ["Neon"] = 283.7, ["Neon|Ride"] = 135.19, ["Neon|Fly|Ride"] = 267.77, ["Mega"] = 708.69, ["Mega|Fly|Ride"] = 658.76}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 5087.6, ["Ride"] = 4356.21, ["Fly|Ride"] = 4578, ["Neon|Ride"] = 16999.8, ["Neon|Fly|Ride"] = 17708.48, ["Mega|Fly|Ride"] = 70832.81}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 28.28, ["Fly"] = 35.35, ["Ride"] = 32.33, ["Fly|Ride"] = 56.44, ["Neon"] = 333.94, ["Neon|Ride"] = 226.2, ["Neon|Fly|Ride"] = 157.5, ["Mega|Fly|Ride"] = 685.13}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 35.44, ["Fly"] = 142.34, ["Ride"] = 47.63, ["Fly|Ride"] = 107.63, ["Neon"] = 263.1, ["Neon|Fly"] = 1417.37, ["Neon|Ride"] = 280.51, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1062.5}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 590.63, ["Fly"] = 828.75, ["Ride"] = 590.63, ["Fly|Ride"] = 651, ["Neon"] = 1701, ["Neon|Ride"] = 1627.33, ["Neon|Fly|Ride"] = 1459.5, ["Mega|Fly|Ride"] = 5249.99}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 15.75, ["Fly"] = 28.69, ["Ride"] = 27.64, ["Fly|Ride"] = 39.38, ["Neon"] = 98.44, ["Neon|Fly"] = 159.53, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 779.88, ["Mega|Fly|Ride"] = 523.68}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 13.54, ["Ride"] = 78.64, ["Fly|Ride"] = 91.88, ["Neon"] = 91.88, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 397.63, ["Mega|Ride"] = 571.44}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 91.88, ["Fly"] = 317.86, ["Ride"] = 113.7, ["Fly|Ride"] = 245.44, ["Neon"] = 567.38, ["Neon|Ride"] = 523.68, ["Neon|Fly|Ride"] = 708.69, ["Mega|Fly|Ride"] = 2193.19}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 17.87, ["Fly"] = 121.13, ["Ride"] = 78.75, ["Fly|Ride"] = 154.39, ["Neon"] = 99.6, ["Neon|Fly"] = 238.1, ["Neon|Ride"] = 139.91, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 287.44, ["Mega|Fly"] = 800.63, ["Mega|Ride"] = 313.45, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3150, ["Ride"] = 3543.75, ["Fly|Ride"] = 3281.25, ["Neon"] = 13125, ["Neon|Ride"] = 10342.26, ["Neon|Fly|Ride"] = 8518.13, ["Mega"] = 63749.2, ["Mega|Fly|Ride"] = 33332.59}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 28.7, ["Fly"] = 115.5, ["Ride"] = 63, ["Fly|Ride"] = 166.68, ["Neon"] = 190.5, ["Neon|Ride"] = 241.2, ["Neon|Fly|Ride"] = 318.76, ["Mega|Ride"] = 956.25, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7218.75, ["Ride"] = 7431.05, ["Fly|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 14437.5, ["Mega|Fly|Ride"] = 63679.08}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.63, ["Fly"] = 21, ["Ride"] = 17.95, ["Fly|Ride"] = 31.5, ["Neon"] = 22.32, ["Neon|Fly"] = 91.8, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 70.14, ["Mega"] = 326.21, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 20.61, ["Fly"] = 32.16, ["Ride"] = 28.44, ["Fly|Ride"] = 48.57, ["Neon"] = 117.88, ["Neon|Ride"] = 559.37, ["Neon|Fly|Ride"] = 126.45, ["Mega|Ride"] = 1247.55, ["Mega|Fly|Ride"] = 927.94}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.19}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 11.8, ["Ride"] = 39.38, ["Fly|Ride"] = 127.51, ["Neon"] = 158.49, ["Neon|Ride"] = 138.44, ["Neon|Fly|Ride"] = 143.45, ["Mega"] = 707.63, ["Mega|Ride"] = 990.26, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 19.55, ["Fly"] = 262.5, ["Ride"] = 131.25, ["Fly|Ride"] = 142.38, ["Neon"] = 182.43, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 282.63, ["Mega"] = 840, ["Mega|Ride"] = 952.38, ["Mega|Fly|Ride"] = 794.05}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 14.31, ["Fly"] = 25.1, ["Ride"] = 22.32, ["Fly|Ride"] = 38.27, ["Neon"] = 141.61, ["Neon|Ride"] = 111.92, ["Neon|Fly|Ride"] = 117.95, ["Mega"] = 820.32, ["Mega|Ride"] = 594.05, ["Mega|Fly|Ride"] = 637.51}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8437.23}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 3148.69}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 23.62}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 142.01, ["Fly"] = 174.57, ["Ride"] = 189, ["Fly|Ride"] = 244.38, ["Neon|Ride"] = 850}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 22.32, ["Fly"] = 133.89, ["Ride"] = 39.38, ["Fly|Ride"] = 104.99, ["Neon"] = 112.02, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 142.38, ["Mega"] = 921.19, ["Mega|Ride"] = 892.5, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 10.39}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 9.54, ["Neon"] = 82.89, ["Neon|Ride"] = 85.01, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2572.5}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 231, ["Ride"] = 236.25, ["Fly|Ride"] = 413.11, ["Neon"] = 748.13, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1083.75, ["Mega|Ride"] = 3528.53, ["Mega|Fly|Ride"] = 3117.35}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 118.12, ["Ride"] = 183.75, ["Fly|Ride"] = 283.7, ["Neon"] = 708.69, ["Neon|Ride"] = 708.69, ["Neon|Fly|Ride"] = 603.75, ["Mega|Ride"] = 2407.61, ["Mega|Fly|Ride"] = 2356.61}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 177.18, ["Ride"] = 169.32, ["Fly|Ride"] = 221.82, ["Neon"] = 799.32, ["Neon|Ride"] = 840, ["Neon|Fly|Ride"] = 842.03, ["Mega"] = 4674.95, ["Mega|Ride"] = 3117.35, ["Mega|Fly|Ride"] = 3200.23}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1428.55, ["Fly"] = 2549.98, ["Ride"] = 918.75, ["Fly|Ride"] = 1292.82, ["Neon"] = 5383.64, ["Neon|Ride"] = 4200, ["Neon|Fly|Ride"] = 4462.5, ["Mega|Fly|Ride"] = 28333.34}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 18.38, ["Fly"] = 82.89, ["Ride"] = 39.38, ["Fly|Ride"] = 52.5, ["Neon"] = 142.38, ["Neon|Ride"] = 300.01, ["Neon|Fly|Ride"] = 317.86, ["Mega"] = 848.94, ["Mega|Fly|Ride"] = 921.19}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 616.26, ["Fly"] = 2100, ["Ride"] = 759.84, ["Fly|Ride"] = 794.05, ["Neon|Fly|Ride"] = 2692.36}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 104.99}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 11.82, ["Fly"] = 393.75, ["Ride"] = 43.32, ["Fly|Ride"] = 98.44, ["Neon"] = 91.4, ["Neon|Ride"] = 139.2, ["Neon|Fly|Ride"] = 496.19, ["Mega"] = 364.45, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 871.43}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 7.88, ["Fly"] = 131.25, ["Ride"] = 27.57, ["Fly|Ride"] = 52.5, ["Neon"] = 61.38, ["Neon|Ride"] = 83.61, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 918.75, ["Mega|Ride"] = 485.63, ["Mega|Fly|Ride"] = 468.57}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 65.63}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 21, ["Fly"] = 108.92, ["Ride"] = 36.74, ["Fly|Ride"] = 68.25, ["Neon"] = 196.88, ["Neon|Ride"] = 159.38, ["Neon|Fly|Ride"] = 603.58, ["Mega"] = 823.44, ["Mega|Ride"] = 850, ["Mega|Fly|Ride"] = 1275}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 24.36, ["Fly"] = 48.89, ["Ride"] = 30.19, ["Fly|Ride"] = 68.01, ["Neon"] = 79.77, ["Neon|Ride"] = 142.38, ["Neon|Fly|Ride"] = 274.32, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 5563.69, ["Fly"] = 6032.01, ["Ride"] = 5495.44, ["Fly|Ride"] = 4659.38, ["Neon|Ride"] = 17424.79, ["Neon|Fly|Ride"] = 10077.38, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 8.49, ["Fly"] = 34.13, ["Ride"] = 32.82, ["Fly|Ride"] = 85.01, ["Neon"] = 65.61, ["Neon|Ride"] = 99.89, ["Neon|Fly|Ride"] = 354.88, ["Mega"] = 533.34, ["Mega|Ride"] = 283.7, ["Mega|Fly|Ride"] = 417.38}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 21.83}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 115.5, ["Fly"] = 376.14, ["Ride"] = 142.87, ["Fly|Ride"] = 229.5, ["Neon"] = 418.69, ["Neon|Ride"] = 481.69, ["Neon|Fly|Ride"] = 459.38, ["Mega|Ride"] = 4249.96, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 65.63, ["Ride"] = 105, ["Fly|Ride"] = 153.57, ["Neon"] = 327.6, ["Neon|Ride"] = 357.15, ["Neon|Fly|Ride"] = 511.88, ["Mega|Ride"] = 2867.67, ["Mega|Fly|Ride"] = 1806.25}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 19.69, ["Fly"] = 72.19, ["Ride"] = 32.82, ["Fly|Ride"] = 62.7, ["Neon"] = 123.26, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 694.87, ["Mega|Ride"] = 892.5, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 3.98, ["Fly"] = 49.76, ["Ride"] = 36.95, ["Fly|Ride"] = 71.45, ["Neon"] = 23.55, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 159.53, ["Mega"] = 129.94, ["Mega|Fly"] = 7034.11, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 263.81}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 14.18, ["Fly"] = 31.5, ["Ride"] = 32.95, ["Fly|Ride"] = 74.82, ["Neon"] = 92.13, ["Neon|Ride"] = 82.69, ["Neon|Fly|Ride"] = 123.26, ["Mega"] = 368.69, ["Mega|Ride"] = 410.82, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 19.14, ["Fly"] = 32.95, ["Ride"] = 24.93, ["Fly|Ride"] = 43.31, ["Neon"] = 208.71, ["Neon|Ride"] = 138.96, ["Neon|Fly|Ride"] = 126.45, ["Mega|Fly|Ride"] = 634.74}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 213.94}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 27.64, ["Ride"] = 96.47, ["Fly|Ride"] = 288.75, ["Neon"] = 159.53, ["Neon|Ride"] = 425.01, ["Mega"] = 992.38, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1627.75}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 196.87, ["Ride"] = 397.63, ["Fly|Ride"] = 262.49, ["Neon|Ride"] = 820.32, ["Neon|Fly|Ride"] = 751.2}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 42, ["Fly"] = 211.99, ["Ride"] = 100.8, ["Fly|Ride"] = 255.01, ["Neon"] = 269.73, ["Neon|Fly"] = 425.01, ["Neon|Ride"] = 325.14, ["Neon|Fly|Ride"] = 420, ["Mega"] = 1119.88, ["Mega|Ride"] = 1984.75, ["Mega|Fly|Ride"] = 1161.97}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 708.75, ["Fly"] = 780.94, ["Ride"] = 727.01, ["Fly|Ride"] = 765.85, ["Neon|Ride"] = 3281.25, ["Neon|Fly|Ride"] = 2502.03, ["Mega|Fly|Ride"] = 7875}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 350.44, ["Ride"] = 484.32, ["Fly|Ride"] = 538.13, ["Neon"] = 1558.69, ["Neon|Ride"] = 2064.25, ["Neon|Fly|Ride"] = 1357.13, ["Mega"] = 8358.6, ["Mega|Ride"] = 7778.42, ["Mega|Fly|Ride"] = 7284.38}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 65.63}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 3.29}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 11.22, ["Fly"] = 31.5, ["Ride"] = 24.81, ["Fly|Ride"] = 47.63, ["Neon"] = 77.95, ["Neon|Ride"] = 97.5, ["Neon|Fly|Ride"] = 135.73, ["Mega"] = 595.01, ["Mega|Ride"] = 454.75, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 321.57, ["Fly"] = 992.38, ["Ride"] = 328.13, ["Fly|Ride"] = 431.82, ["Neon"] = 1023.8, ["Neon|Ride"] = 853.13, ["Neon|Fly|Ride"] = 787.5, ["Mega|Fly|Ride"] = 3683.66}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 18.36}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 106.26, ["Fly"] = 590.63, ["Ride"] = 194.25, ["Fly|Ride"] = 273, ["Neon"] = 567.38, ["Neon|Fly"] = 1699.99, ["Neon|Ride"] = 546.14, ["Neon|Fly|Ride"] = 590.63, ["Mega"] = 2974.98, ["Mega|Ride"] = 1997.49, ["Mega|Fly|Ride"] = 1887.08}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 156.19, ["Ride"] = 150.94, ["Fly|Ride"] = 291.38, ["Neon|Fly"] = 997.69, ["Neon|Ride"] = 892.5}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 6.3, ["Ride"] = 28.6, ["Fly|Ride"] = 206.14, ["Neon"] = 44.64, ["Neon|Ride"] = 55.12, ["Mega"] = 241.2, ["Mega|Ride"] = 476.2, ["Mega|Fly|Ride"] = 395.26}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 17.84, ["Fly"] = 62.99, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 98.98, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 142.87, ["Mega|Ride"] = 538.7, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 18.38, ["Fly"] = 131.25, ["Ride"] = 62.26, ["Fly|Ride"] = 141.39, ["Neon"] = 172.14, ["Neon|Ride"] = 142.38, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 418.78, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 945.67}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 4.8, ["Fly"] = 39.38, ["Ride"] = 28.62, ["Fly|Ride"] = 111.18, ["Neon"] = 25.44, ["Neon|Ride"] = 62.25, ["Neon|Fly|Ride"] = 179.82, ["Mega"] = 130.6, ["Mega|Ride"] = 157.16, ["Mega|Fly|Ride"] = 226.12}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 273, ["Fly"] = 918.75, ["Ride"] = 301.88, ["Fly|Ride"] = 467.51, ["Neon"] = 1487.5, ["Neon|Ride"] = 1214.07, ["Neon|Fly|Ride"] = 1424.07, ["Mega|Fly|Ride"] = 5142.45}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 105, ["Fly"] = 1050, ["Ride"] = 179.87, ["Fly|Ride"] = 223.13, ["Neon"] = 456.74, ["Neon|Ride"] = 459.37, ["Neon|Fly|Ride"] = 539.27, ["Mega"] = 9562.4, ["Mega|Ride"] = 2064.25, ["Mega|Fly|Ride"] = 1704.94}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 72.19, ["Fly"] = 167.45, ["Ride"] = 84, ["Fly|Ride"] = 128.63, ["Neon"] = 288.75, ["Neon|Ride"] = 397.39, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 1542.19, ["Mega|Fly|Ride"] = 1732.5}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 19.69, ["Ride"] = 58.24, ["Fly|Ride"] = 283.7, ["Neon|Ride"] = 604.76, ["Neon|Fly|Ride"] = 496.19, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 13.12, ["Fly"] = 75.62, ["Ride"] = 40.69, ["Fly|Ride"] = 102.38, ["Neon"] = 90.04, ["Neon|Ride"] = 112.65, ["Neon|Fly|Ride"] = 181.13, ["Mega"] = 402.55, ["Mega|Fly"] = 525, ["Mega|Ride"] = 425.01, ["Mega|Fly|Ride"] = 444.38}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.42, ["Fly"] = 45.83, ["Ride"] = 21, ["Fly|Ride"] = 65.63, ["Neon"] = 19, ["Neon|Ride"] = 42.5, ["Neon|Fly|Ride"] = 127.51, ["Mega"] = 106.79, ["Mega|Ride"] = 176.21, ["Mega|Fly|Ride"] = 212.51}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 958.13, ["Fly"] = 1417.37, ["Ride"] = 990.94, ["Fly|Ride"] = 1036.88, ["Neon"] = 3007.12, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2415, ["Mega|Fly|Ride"] = 8990.63}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 379.32, ["Fly"] = 423.95, ["Ride"] = 420.93, ["Fly|Ride"] = 393.75, ["Neon"] = 1699.99, ["Neon|Ride"] = 1680, ["Neon|Fly|Ride"] = 1402.5, ["Mega"] = 10624.87, ["Mega|Fly|Ride"] = 5788.43}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 99.89, ["Ride"] = 122.19, ["Fly|Ride"] = 187.49, ["Neon"] = 282.19, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 413.11, ["Mega|Ride"] = 1657.49, ["Mega|Fly|Ride"] = 1904.74}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 293.64, ["Fly"] = 340.01, ["Ride"] = 282.17, ["Fly|Ride"] = 308.44, ["Neon|Ride"] = 1091.2, ["Neon|Fly|Ride"] = 1062.5, ["Mega"] = 10624.87, ["Mega|Fly|Ride"] = 4199.99}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 20.98, ["Fly"] = 142.38, ["Ride"] = 35.79, ["Fly|Ride"] = 78.75, ["Neon"] = 157.49, ["Neon|Ride"] = 132.57, ["Neon|Fly|Ride"] = 157.26, ["Mega"] = 1417.37, ["Mega|Ride"] = 794.05, ["Mega|Fly|Ride"] = 618.87}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 216.12, ["Ride"] = 258.93, ["Fly|Ride"] = 314.69, ["Neon"] = 1584.98, ["Neon|Ride"] = 1698.93, ["Neon|Fly|Ride"] = 1273.94, ["Mega"] = 5250}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 88.2, ["Fly"] = 126, ["Ride"] = 65.62, ["Fly|Ride"] = 142.38, ["Neon"] = 425.01, ["Neon|Ride"] = 507.88, ["Neon|Fly|Ride"] = 567.37, ["Mega|Fly|Ride"] = 1397.82}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1312.5, ["Ride"] = 1378.13, ["Fly|Ride"] = 1378.13, ["Neon|Fly|Ride"] = 6374.93, ["Mega"] = 50999.37, ["Mega|Fly|Ride"] = 24649.7}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 9.12, ["Fly"] = 45.7, ["Ride"] = 36.75, ["Fly|Ride"] = 87.45, ["Neon"] = 52.5, ["Neon|Fly"] = 165.48, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 170.24, ["Mega"] = 253.32, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 401.64}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 63.77, ["Fly"] = 52.5, ["Ride"] = 84, ["Fly|Ride"] = 161.44, ["Neon"] = 315, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 283.7, ["Mega|Ride"] = 1154.93, ["Mega|Fly|Ride"] = 1458.19}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 84, ["Fly"] = 91.88, ["Ride"] = 82.69, ["Fly|Ride"] = 97.17, ["Neon|Ride"] = 410.82, ["Neon|Fly|Ride"] = 367.5, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 1575, ["Ride"] = 918.75, ["Fly|Ride"] = 1093.57, ["Neon|Fly|Ride"] = 4199.99, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 465.94, ["Fly"] = 847.88, ["Ride"] = 354.88, ["Fly|Ride"] = 525, ["Neon|Fly|Ride"] = 1995.37, ["Mega|Fly|Ride"] = 14285.4}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 91.88, ["Fly"] = 130.7, ["Ride"] = 131.25, ["Fly|Ride"] = 232.21, ["Neon"] = 631.14, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 548.19, ["Mega"] = 4249.96, ["Mega|Ride"] = 1812.61, ["Mega|Fly|Ride"] = 2124.99}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 11.82, ["Fly"] = 21.26, ["Ride"] = 23.63, ["Fly|Ride"] = 57.39, ["Neon"] = 97.55, ["Neon|Ride"] = 91.4, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 656.25, ["Mega|Ride"] = 722.51, ["Mega|Fly|Ride"] = 1027.44}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 41.97, ["Fly"] = 79.7, ["Ride"] = 48.57, ["Fly|Ride"] = 94.4, ["Neon"] = 191.26, ["Neon|Fly"] = 423.95, ["Neon|Ride"] = 223.62, ["Neon|Fly|Ride"] = 210, ["Mega"] = 1842.37, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 741.57, ["Ride"] = 872.82, ["Fly|Ride"] = 912.56, ["Neon"] = 2876.16, ["Neon|Ride"] = 2828.44, ["Neon|Fly|Ride"] = 2756.25}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 892.49}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4921.88, ["Ride"] = 4608.19, ["Fly|Ride"] = 4458.57, ["Neon|Ride"] = 30451.94, ["Neon|Fly|Ride"] = 21779.92, ["Mega|Fly|Ride"] = 90666.23}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 157.5, ["Fly"] = 283.69, ["Ride"] = 222.63, ["Fly|Ride"] = 425.01, ["Neon"] = 1699.99, ["Neon|Ride"] = 992.38, ["Neon|Fly|Ride"] = 1417.37, ["Mega"] = 5949.95, ["Mega|Fly|Ride"] = 5667.32}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 83.57, ["Fly"] = 283.7, ["Ride"] = 77.44, ["Fly|Ride"] = 336, ["Neon"] = 425.01, ["Neon|Ride"] = 507.88, ["Neon|Fly|Ride"] = 992.38, ["Mega|Fly|Ride"] = 2847.48}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 13.13, ["Fly"] = 51.01, ["Ride"] = 36.14, ["Fly|Ride"] = 105, ["Neon"] = 98.44, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 707.63, ["Mega|Ride"] = 564.2, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 18.64, ["Fly"] = 28.6, ["Ride"] = 26.23, ["Fly|Ride"] = 45.94, ["Neon"] = 91.88, ["Neon|Ride"] = 142.38, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 844.69}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 19.58, ["Fly"] = 70.9, ["Ride"] = 32.82, ["Fly|Ride"] = 64.3, ["Neon"] = 113.59, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 226.41, ["Mega|Ride"] = 567.38, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.94, ["Fly"] = 57.39, ["Ride"] = 19.06, ["Fly|Ride"] = 38.07, ["Neon"] = 41.45, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 159.53, ["Mega"] = 695.67, ["Mega|Ride"] = 240.13, ["Mega|Fly|Ride"] = 317.86}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 31.46, ["Ride"] = 63.76, ["Fly|Ride"] = 158.76, ["Neon"] = 164.58, ["Neon|Fly"] = 850, ["Neon|Ride"] = 160.13, ["Neon|Fly|Ride"] = 251.06, ["Mega"] = 701.26, ["Mega|Ride"] = 708.69, ["Mega|Fly|Ride"] = 860.63}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 285.65, ["Fly"] = 355.68, ["Ride"] = 277.18, ["Fly|Ride"] = 330.75, ["Neon"] = 1050, ["Neon|Fly"] = 956.25, ["Neon|Ride"] = 708.75, ["Neon|Fly|Ride"] = 735, ["Mega"] = 6562.5, ["Mega|Fly|Ride"] = 3329.85}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.09, ["Fly"] = 21.6, ["Ride"] = 12.76, ["Fly|Ride"] = 32.82, ["Neon"] = 21, ["Neon|Ride"] = 26.13, ["Neon|Fly|Ride"] = 63.41, ["Mega"] = 183.75, ["Mega|Ride"] = 194.45, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 32.81, ["Fly"] = 96.62, ["Ride"] = 70.75, ["Fly|Ride"] = 110.08, ["Neon"] = 144.37, ["Neon|Fly"] = 341.25, ["Neon|Ride"] = 190.32, ["Neon|Fly|Ride"] = 264.51, ["Mega"] = 564.27, ["Mega|Ride"] = 547.31, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 708.75, ["Fly"] = 1417.37, ["Ride"] = 769.49, ["Fly|Ride"] = 787.5, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1526.44, ["Mega|Fly|Ride"] = 3970.32}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 32.29, ["Fly"] = 107.63, ["Ride"] = 44.09, ["Fly|Ride"] = 91.85, ["Neon|Fly"] = 476.2, ["Neon|Ride"] = 177.18, ["Neon|Fly|Ride"] = 210, ["Mega"] = 1575, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 654.93}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 275.63, ["Fly"] = 341.25, ["Ride"] = 236.24, ["Fly|Ride"] = 325.5, ["Neon"] = 1247.37, ["Neon|Ride"] = 954.13, ["Neon|Fly|Ride"] = 945, ["Mega|Fly|Ride"] = 5312.44}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 113.67, ["Fly"] = 180.64, ["Ride"] = 137.44, ["Fly|Ride"] = 157.49, ["Neon"] = 637.51, ["Neon|Fly"] = 646.01, ["Neon|Ride"] = 510.01, ["Neon|Fly|Ride"] = 485.63, ["Mega|Fly|Ride"] = 1749.57}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 557.82, ["Ride"] = 595.75, ["Fly|Ride"] = 599.19, ["Neon|Fly|Ride"] = 1699.99, ["Mega|Fly|Ride"] = 7217.44}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 23.82, ["Ride"] = 45.76, ["Fly|Ride"] = 130.7, ["Neon"] = 98.44, ["Neon|Fly"] = 285.73, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 184.89, ["Mega"] = 304.56, ["Mega|Ride"] = 321.2, ["Mega|Fly|Ride"] = 476.2}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4023.74, ["Fly"] = 4040.4, ["Ride"] = 3706.57, ["Fly|Ride"] = 3110.63, ["Neon|Fly|Ride"] = 6562.5, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 78.64, ["Fly"] = 178.5, ["Ride"] = 99.89, ["Fly|Ride"] = 131.25, ["Neon"] = 476.2, ["Neon|Ride"] = 371.88, ["Neon|Fly|Ride"] = 424.23, ["Mega|Fly|Ride"] = 1904.74}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.63, ["Fly"] = 31.88, ["Ride"] = 19.05, ["Fly|Ride"] = 42.39, ["Neon"] = 19.69, ["Neon|Fly"] = 45.05, ["Neon|Ride"] = 28.7, ["Neon|Fly|Ride"] = 111.06, ["Mega"] = 139.12, ["Mega|Fly"] = 452.82, ["Mega|Ride"] = 233.89, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.78, ["Ride"] = 27.57, ["Fly|Ride"] = 62.99, ["Neon"] = 25.71, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 164.07, ["Mega|Ride"] = 199.47, ["Mega|Fly|Ride"] = 278.2}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 45.92, ["Fly"] = 82.86, ["Ride"] = 53.82, ["Fly|Ride"] = 59.07, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 283.7, ["Mega|Fly|Ride"] = 1346.19}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 1036.88, ["Ride"] = 1133.68, ["Fly|Ride"] = 1206.19, ["Neon"] = 5524.95, ["Neon|Fly|Ride"] = 5242.32}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 4958.64, ["Ride"] = 5952.26, ["Fly|Ride"] = 5249.99}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 23.63, ["Fly"] = 36.14, ["Ride"] = 30.47, ["Fly|Ride"] = 43.32, ["Neon"] = 261.86, ["Neon|Ride"] = 117.95, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 2428.13, ["Mega|Fly|Ride"] = 505.21}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 15.73, ["Fly"] = 71.21, ["Ride"] = 36.11, ["Fly|Ride"] = 80.07, ["Neon"] = 82.89, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 184.89, ["Mega"] = 522.76, ["Mega|Ride"] = 354.37, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 49.88, ["Fly"] = 85.31, ["Ride"] = 54.6, ["Fly|Ride"] = 72.19, ["Neon"] = 271.24, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 275.39, ["Mega"] = 1050, ["Mega|Ride"] = 1196.37, ["Mega|Fly|Ride"] = 971.45}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 183.75, ["Fly"] = 317.86, ["Ride"] = 226.73, ["Fly|Ride"] = 252.84, ["Neon|Ride"] = 976.5, ["Neon|Fly|Ride"] = 945, ["Mega"] = 10624.87, ["Mega|Fly|Ride"] = 3526.41}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 4.8, ["Ride"] = 32.65, ["Fly|Ride"] = 131.25, ["Neon"] = 23.39, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 85.01, ["Neon|Fly|Ride"] = 247.64, ["Mega"] = 154.88, ["Mega|Ride"] = 248.63}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 183.75, ["Fly"] = 253.93, ["Ride"] = 223.02, ["Fly|Ride"] = 304.92, ["Neon"] = 694.87, ["Neon|Ride"] = 836.19, ["Neon|Fly|Ride"] = 786.19, ["Mega|Fly|Ride"] = 3820.72}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.14, ["Fly"] = 23.63, ["Ride"] = 16.94, ["Fly|Ride"] = 39.38, ["Neon"] = 19.69, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 27.15, ["Neon|Fly|Ride"] = 121.13, ["Mega"] = 210, ["Mega|Ride"] = 196.27, ["Mega|Fly|Ride"] = 264.89}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 183.75, ["Fly"] = 157.5, ["Ride"] = 157.5, ["Fly|Ride"] = 249.69, ["Neon|Ride"] = 1133.68, ["Neon|Fly|Ride"] = 1105, ["Mega"] = 10624.87, ["Mega|Ride"] = 6374.93, ["Mega|Fly|Ride"] = 7737.94}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 9.54, ["Fly"] = 26.25, ["Ride"] = 31.87, ["Fly|Ride"] = 65.63, ["Neon"] = 85.01, ["Neon|Fly"] = 302.39, ["Neon|Ride"] = 138.13, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 522.41, ["Mega|Ride"] = 567.38, ["Mega|Fly|Ride"] = 482.39}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Ride"] = 25.71, ["Neon"] = 13.13, ["Neon|Fly"] = 66.94, ["Neon|Ride"] = 52.36, ["Neon|Fly|Ride"] = 86.18, ["Mega"] = 76.11, ["Mega|Ride"] = 116.7, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.02, ["Mega"] = 21.83, ["Mega|Ride"] = 155.7}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.49, ["Ride"] = 28.48, ["Fly|Ride"] = 141.62, ["Neon"] = 10.31, ["Neon|Ride"] = 50.91, ["Neon|Fly|Ride"] = 102.38, ["Mega"] = 64.22, ["Mega|Fly"] = 158727.33, ["Mega|Ride"] = 97.49, ["Mega|Fly|Ride"] = 142.38}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 62.91, ["Fly"] = 78.73, ["Ride"] = 104.14, ["Fly|Ride"] = 131.25, ["Neon"] = 283.7, ["Neon|Fly"] = 263.17, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 328.13, ["Mega|Fly|Ride"] = 1069.85}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 40.69, ["Ride"] = 15.89, ["Fly|Ride"] = 41.14, ["Neon"] = 10.63, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 105, ["Mega"] = 95.1, ["Mega|Ride"] = 98.34, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 7.87, ["Ride"] = 116.25, ["Fly|Ride"] = 197.65, ["Neon"] = 74.82, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 121.13, ["Mega"] = 485.63, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 779.88}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Ride"] = 30.82, ["Neon"] = 2.5, ["Neon|Ride"] = 23.39, ["Neon|Fly|Ride"] = 55.97, ["Mega"] = 17, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 131.06}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 17.77, ["Fly|Ride"] = 34.29, ["Neon"] = 2.1, ["Neon|Fly"] = 35.73, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 40.48, ["Mega"] = 15.74, ["Mega|Fly"] = 30.19, ["Mega|Ride"] = 20.9, ["Mega|Fly|Ride"] = 58.56}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 15.62, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 15.33, ["Neon|Ride"] = 14.68, ["Neon|Fly|Ride"] = 46.76, ["Mega"] = 27.46, ["Mega|Ride"] = 50.91, ["Mega|Fly|Ride"] = 78.66}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 22.36, ["Fly|Ride"] = 125.73, ["Neon"] = 2.52, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 39.38, ["Mega"] = 20.79, ["Mega|Ride"] = 146.95, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Ride"] = 19.69, ["Fly|Ride"] = 104.81, ["Neon"] = 3.61, ["Neon|Fly"] = 135.03, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 37.12, ["Mega|Fly"] = 85.32, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 167.89}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 4.8, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 19.28, ["Mega|Ride"] = 81.38}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 47.16, ["Ride"] = 23.39, ["Fly|Ride"] = 47.25, ["Neon"] = 5.07, ["Neon|Fly"] = 37.59, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 95.26, ["Mega"] = 52.5, ["Mega|Fly"] = 197.63, ["Mega|Ride"] = 63.03, ["Mega|Fly|Ride"] = 106.21}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 48.89, ["Neon"] = 2.1, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 313.84, ["Mega"] = 15.22, ["Mega|Ride"] = 44.63, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 525, ["Neon"] = 45.93, ["Mega"] = 204.02, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 344.97}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 13.13, ["Mega"] = 105, ["Mega|Fly|Ride"] = 380.39}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 71.21, ["Neon"] = 7.07, ["Neon|Ride"] = 37.71, ["Neon|Fly|Ride"] = 85.01, ["Mega"] = 24.45, ["Mega|Ride"] = 42.2, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 30.72, ["Ride"] = 18.75, ["Fly|Ride"] = 30.15, ["Neon"] = 2.1, ["Neon|Fly"] = 41.91, ["Neon|Ride"] = 14.91, ["Neon|Fly|Ride"] = 41.88, ["Mega"] = 15.62, ["Mega|Fly"] = 52.81, ["Mega|Ride"] = 24.05, ["Mega|Fly|Ride"] = 57.75}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.63, ["Fly"] = 72.19, ["Ride"] = 42, ["Fly|Ride"] = 104.98, ["Neon"] = 32.16, ["Neon|Ride"] = 39.83, ["Mega"] = 255.01, ["Mega|Fly"] = 283.7, ["Mega|Ride"] = 353.26, ["Mega|Fly|Ride"] = 692.75}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Fly"] = 15.94, ["Ride"] = 41.91, ["Fly|Ride"] = 78.73, ["Neon"] = 5.25, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 158.06, ["Mega"] = 34.13, ["Mega|Ride"] = 51.18, ["Mega|Fly|Ride"] = 157.26}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 6.36, ["Neon"] = 13.13, ["Neon|Fly|Ride"] = 142.38, ["Mega"] = 78.64, ["Mega|Ride"] = 165.77, ["Mega|Fly|Ride"] = 221.81}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.35, ["Fly"] = 21.15, ["Ride"] = 32.81, ["Fly|Ride"] = 193.39, ["Neon"] = 10.58, ["Neon|Ride"] = 71.21, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 90.99, ["Mega|Ride"] = 85.3, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 12.73, ["Fly|Ride"] = 28.67, ["Neon"] = 2.1, ["Neon|Fly"] = 15.74, ["Neon|Ride"] = 15.94, ["Neon|Fly|Ride"] = 30.35, ["Mega"] = 17.87, ["Mega|Fly"] = 40.39, ["Mega|Ride"] = 25.51, ["Mega|Fly|Ride"] = 52.49}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 23.94, ["Ride"] = 21.26, ["Fly|Ride"] = 48.57, ["Neon"] = 15.61, ["Neon|Ride"] = 114.3, ["Neon|Fly|Ride"] = 66.95, ["Mega"] = 78.75, ["Mega|Fly|Ride"] = 196.77}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 3.94, ["Fly"] = 41.91, ["Ride"] = 30.97, ["Fly|Ride"] = 141.39, ["Neon"] = 82.43, ["Neon|Ride"] = 112.65, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 279.2, ["Mega|Ride"] = 278.07, ["Mega|Fly|Ride"] = 387.85}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 13.02, ["Ride"] = 16.1, ["Fly|Ride"] = 26.17, ["Neon"] = 2.1, ["Neon|Fly"] = 20.24, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 59.19, ["Mega"] = 38.06, ["Mega|Fly"] = 156.19, ["Mega|Ride"] = 66.68, ["Mega|Fly|Ride"] = 124.85}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 177.45, ["Neon"] = 10.5, ["Neon|Fly"] = 77.53, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 59.96, ["Mega|Ride"] = 92.46}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.63, ["Ride"] = 26.25, ["Neon"] = 6.39, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 158.32, ["Neon|Fly|Ride"] = 142.87, ["Mega"] = 32.82, ["Mega|Ride"] = 150.02, ["Mega|Fly|Ride"] = 207.16}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 43.58, ["Ride"] = 21.26, ["Neon"] = 2.1, ["Neon|Fly"] = 41.45, ["Neon|Ride"] = 21.26, ["Neon|Fly|Ride"] = 101.07, ["Mega"] = 18.17, ["Mega|Ride"] = 71.21, ["Mega|Fly|Ride"] = 124.76}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 99.32, ["Ride"] = 19.04, ["Fly|Ride"] = 59.07, ["Neon"] = 6.57, ["Neon|Fly"] = 45.09, ["Neon|Ride"] = 27.64, ["Neon|Fly|Ride"] = 56.32, ["Mega"] = 74.08, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 142.38}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 31.4, ["Neon"] = 6.13, ["Neon|Ride"] = 51.74, ["Mega"] = 62.46, ["Mega|Ride"] = 118.01, ["Mega|Fly|Ride"] = 314.51}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 32.45, ["Ride"] = 17.07, ["Fly|Ride"] = 141.75, ["Neon"] = 7.88, ["Neon|Fly"] = 21.25, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 48.57, ["Mega"] = 65.63, ["Mega|Ride"] = 90.46, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 4.34, ["Ride"] = 82.6, ["Neon"] = 32.82, ["Mega"] = 283.7, ["Mega|Fly|Ride"] = 844.06}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 17.99, ["Fly|Ride"] = 35.73, ["Neon"] = 12.59, ["Neon|Fly"] = 142.38, ["Neon|Ride"] = 28.53, ["Neon|Fly|Ride"] = 57.39, ["Mega"] = 190.78, ["Mega|Fly|Ride"] = 283.7}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.56, ["Fly"] = 20.6, ["Ride"] = 28.53, ["Fly|Ride"] = 142.38, ["Neon"] = 19.85, ["Neon|Fly"] = 40.39, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 62.99, ["Mega"] = 89.25, ["Mega|Fly"] = 142.38, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 79.47, ["Fly|Ride"] = 106.14, ["Neon"] = 23, ["Neon|Ride"] = 159.53, ["Mega"] = 200.16, ["Mega|Ride"] = 405.56}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 11.69, ["Ride"] = 78.64, ["Neon|Ride"] = 159.53, ["Mega"] = 577.5, ["Mega|Ride"] = 674.7, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 11.7, ["Ride"] = 55.65, ["Fly|Ride"] = 59.07, ["Neon"] = 87.26, ["Neon|Ride"] = 105, ["Mega"] = 214.29, ["Mega|Ride"] = 367.5}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 15.1, ["Ride"] = 42, ["Neon"] = 56.44, ["Neon|Ride"] = 117.95, ["Neon|Fly|Ride"] = 117.95, ["Mega"] = 476.2, ["Mega|Ride"] = 253.31, ["Mega|Fly|Ride"] = 394.42}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.1, ["Neon|Ride"] = 92.29, ["Mega"] = 19.69, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 148.29}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 48.57}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 5.65, ["Fly"] = 26.84, ["Ride"] = 23.24, ["Fly|Ride"] = 71.21, ["Neon"] = 49.95, ["Neon|Ride"] = 34.01, ["Neon|Fly|Ride"] = 80.07, ["Mega"] = 259.88, ["Mega|Ride"] = 528.59, ["Mega|Fly|Ride"] = 212.51}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.36, ["Fly|Ride"] = 738.09, ["Neon"] = 2.67, ["Neon|Ride"] = 28.24, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 59.07, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 24.45, ["Fly|Ride"] = 140.17, ["Neon"] = 5.16, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 159.33, ["Mega"] = 39.37, ["Mega|Ride"] = 82.8, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 16.69, ["Fly|Ride"] = 78.64, ["Neon"] = 16.86, ["Neon|Ride"] = 28.6, ["Neon|Fly|Ride"] = 95.66, ["Mega"] = 148.73, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 283.7}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.72, ["Ride"] = 18.38, ["Neon"] = 38.75, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 156.26, ["Mega"] = 328.13, ["Mega|Ride"] = 278.39, ["Mega|Fly|Ride"] = 425.01}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Fly|Ride"] = 79.77, ["Mega"] = 17.85, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 56.85, ["Mega|Fly|Ride"] = 283.7}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 17.07, ["Fly|Ride"] = 283330.1, ["Neon"] = 3.93, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 85.01, ["Mega"] = 30.19, ["Mega|Fly"] = 202.38, ["Mega|Ride"] = 52.41, ["Mega|Fly|Ride"] = 145.69}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 15.53, ["Ride"] = 15.94, ["Fly|Ride"] = 34.13, ["Neon"] = 7.65, ["Neon|Fly"] = 71.21, ["Neon|Ride"] = 23.37, ["Neon|Fly|Ride"] = 51.19, ["Mega"] = 65.63, ["Mega|Ride"] = 51.34, ["Mega|Fly|Ride"] = 142.38}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 26.25, ["Fly|Ride"] = 78.59, ["Neon"] = 3.59, ["Neon|Ride"] = 36.74, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 23.54, ["Mega|Fly"] = 99.89, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 112.87}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 4.04, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 174.26, ["Mega"] = 20.1, ["Mega|Fly"] = 146.35, ["Mega|Ride"] = 89.27, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 52.5, ["Fly|Ride"] = 77.37, ["Neon"] = 5.25, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 31.88, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 27.64, ["Mega|Ride"] = 65.89, ["Mega|Fly|Ride"] = 103.69}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Mega"] = 14.44, ["Mega|Ride"] = 83.95}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 159.53, ["Neon|Fly|Ride"] = 283.7, ["Mega"] = 27.64, ["Mega|Fly"] = 119.05, ["Mega|Ride"] = 113.7}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 19.69, ["Fly|Ride"] = 36.14, ["Neon"] = 4.2, ["Neon|Fly"] = 72.01, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 71.19, ["Mega"] = 57.39, ["Mega|Fly"] = 106.26, ["Mega|Ride"] = 63.76, ["Mega|Fly|Ride"] = 131.24}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 17.14, ["Ride"] = 59.07, ["Neon"] = 95.82, ["Neon|Ride"] = 238.1, ["Mega"] = 382.93, ["Mega|Ride"] = 475, ["Mega|Fly|Ride"] = 867.01}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.49, ["Ride"] = 54.74, ["Fly|Ride"] = 131.15, ["Neon"] = 117.95, ["Mega"] = 211.45, ["Mega|Ride"] = 147.7, ["Mega|Fly|Ride"] = 425.01}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 28.3, ["Fly|Ride"] = 425.01, ["Neon"] = 30.09, ["Neon|Ride"] = 84.92, ["Mega"] = 142.38, ["Mega|Ride"] = 197.43, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 16.69, ["Ride"] = 12.5, ["Fly|Ride"] = 28.7, ["Neon"] = 2.1, ["Neon|Fly"] = 13.13, ["Neon|Ride"] = 14.43, ["Neon|Fly|Ride"] = 33.13, ["Mega"] = 19.67, ["Mega|Fly"] = 25.71, ["Mega|Ride"] = 21.17, ["Mega|Fly|Ride"] = 45.94}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 6.39, ["Neon|Fly"] = 84.29, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 159.38, ["Mega|Ride"] = 142.38}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 31.88, ["Neon|Ride"] = 17.01, ["Neon|Fly|Ride"] = 79.05, ["Mega"] = 15.64, ["Mega|Fly"] = 78.21, ["Mega|Ride"] = 50.97, ["Mega|Fly|Ride"] = 103.58}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.47, ["Neon|Fly"] = 60.9, ["Mega"] = 15.75, ["Mega|Ride"] = 95.64, ["Mega|Fly|Ride"] = 211.45}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 18.85, ["Fly|Ride"] = 59.54, ["Neon"] = 12.71, ["Neon|Fly"] = 142.38, ["Neon|Ride"] = 30.82, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 143.22, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 276.44}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 190.51, ["Ride"] = 181.13, ["Fly|Ride"] = 262.5, ["Neon"] = 1558.69, ["Neon|Ride"] = 1059.19, ["Neon|Fly|Ride"] = 1105, ["Mega"] = 8499.9, ["Mega|Fly|Ride"] = 3327.19}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Fly|Ride"] = 32.16, ["Neon"] = 6.57, ["Neon|Fly"] = 57.04, ["Neon|Ride"] = 68.25, ["Mega"] = 65.42, ["Mega|Ride"] = 198.71, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 5.8, ["Fly"] = 103.68, ["Ride"] = 28.88, ["Fly|Ride"] = 140.2, ["Neon"] = 59.06, ["Neon|Ride"] = 170.01, ["Neon|Fly|Ride"] = 160.46, ["Mega"] = 425.01, ["Mega|Ride"] = 564.37, ["Mega|Fly|Ride"] = 631.52}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 17.14, ["Fly|Ride"] = 34.81, ["Neon"] = 6.57, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 21.26, ["Neon|Fly|Ride"] = 45.93, ["Mega"] = 65.63, ["Mega|Fly"] = 95.26, ["Mega|Ride"] = 59.7, ["Mega|Fly|Ride"] = 94.5}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 24.94, ["Fly|Ride"] = 120.89, ["Neon"] = 11.82, ["Neon|Fly"] = 85.01, ["Neon|Ride"] = 80.88, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 123.26, ["Mega|Ride"] = 131.25}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.35, ["Fly"] = 15.75, ["Ride"] = 16.21, ["Fly|Ride"] = 34.13, ["Neon"] = 28.7, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 209.18, ["Mega|Ride"] = 282.63, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 4.52, ["Fly"] = 28.7, ["Ride"] = 39.38, ["Fly|Ride"] = 247.07, ["Neon"] = 52.34, ["Neon|Ride"] = 137.45, ["Neon|Fly|Ride"] = 631.14, ["Mega"] = 328.13, ["Mega|Ride"] = 318.76, ["Mega|Fly|Ride"] = 398.35}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 15.73, ["Fly|Ride"] = 24.94, ["Neon"] = 23.82, ["Neon|Fly"] = 83.95, ["Neon|Ride"] = 34.01, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 196.88, ["Mega|Fly"] = 386.76, ["Mega|Ride"] = 357.15, ["Mega|Fly|Ride"] = 194.28}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 65.63, ["Fly"] = 105, ["Ride"] = 91.4, ["Fly|Ride"] = 131.24, ["Neon"] = 399.46, ["Neon|Fly"] = 405.57, ["Neon|Ride"] = 378, ["Neon|Fly|Ride"] = 454.75, ["Mega|Fly|Ride"] = 1573.69}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 216.56, ["Fly"] = 322.17, ["Ride"] = 218.34, ["Fly|Ride"] = 267.86, ["Neon"] = 909.53, ["Neon|Ride"] = 1588.08, ["Neon|Fly|Ride"] = 1105, ["Mega"] = 10624.87, ["Mega|Fly|Ride"] = 4325.4}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 76.2, ["Fly"] = 150.02, ["Ride"] = 84.65, ["Fly|Ride"] = 98.44, ["Neon"] = 379.25, ["Neon|Ride"] = 314.99, ["Neon|Fly|Ride"] = 367.5, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 6.39, ["Ride"] = 32.82, ["Fly|Ride"] = 85.01, ["Neon"] = 19.67, ["Neon|Fly"] = 47.64, ["Neon|Ride"] = 59.52, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 185.95, ["Mega|Ride"] = 141.99, ["Mega|Fly|Ride"] = 317.86}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 13.01, ["Fly"] = 68.14, ["Ride"] = 30.82, ["Fly|Ride"] = 78.59, ["Neon"] = 91.4, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 104.14, ["Neon|Fly|Ride"] = 207.2, ["Mega"] = 353.07, ["Mega|Ride"] = 408.01, ["Mega|Fly|Ride"] = 450.52}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 20.83, ["Fly|Ride"] = 51.01, ["Neon"] = 5.24, ["Neon|Fly"] = 115.5, ["Neon|Ride"] = 21.25, ["Neon|Fly|Ride"] = 87.14, ["Mega"] = 69.06, ["Mega|Fly"] = 211.92, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 185.95}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 5.25, ["Fly"] = 68.49, ["Ride"] = 28.7, ["Fly|Ride"] = 131.25, ["Neon"] = 23.94, ["Neon|Ride"] = 158.06, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 802.18, ["Mega|Ride"] = 497.44, ["Mega|Fly|Ride"] = 538.7}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 15.94, ["Ride"] = 16.77, ["Fly|Ride"] = 27.18, ["Neon"] = 15.67, ["Neon|Fly"] = 131.22, ["Neon|Ride"] = 36.14, ["Neon|Fly|Ride"] = 99.49, ["Mega"] = 131.25, ["Mega|Ride"] = 179.78, ["Mega|Fly|Ride"] = 175.88}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 3.6, ["Ride"] = 27.4, ["Fly|Ride"] = 36.14, ["Neon"] = 27.64, ["Neon|Ride"] = 71.21, ["Neon|Fly|Ride"] = 142.38, ["Mega"] = 207.37, ["Mega|Ride"] = 238.1, ["Mega|Fly|Ride"] = 457.47}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 34.01, ["Neon"] = 2.1, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 16.67, ["Mega|Ride"] = 52.07, ["Mega|Fly|Ride"] = 226.12}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.63, ["Fly"] = 45.93, ["Ride"] = 20.88, ["Fly|Ride"] = 39.38, ["Neon"] = 13.13, ["Neon|Fly"] = 106.26, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 108.94, ["Mega|Ride"] = 96.49, ["Mega|Fly|Ride"] = 189.67}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 36.75, ["Ride"] = 18.02, ["Fly|Ride"] = 39.29, ["Neon"] = 25.51, ["Neon|Fly"] = 142.38, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 63, ["Mega"] = 283.7, ["Mega|Ride"] = 207.16, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 140.26, ["Fly"] = 183.75, ["Ride"] = 195.25, ["Fly|Ride"] = 236.25, ["Neon"] = 700.87, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 595.87, ["Mega|Ride"] = 3478.13, ["Mega|Fly|Ride"] = 2180.05}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 8.16, ["Ride"] = 31.49, ["Fly|Ride"] = 206.07, ["Neon"] = 45.94, ["Neon|Ride"] = 104.81, ["Neon|Fly|Ride"] = 79.77, ["Mega"] = 283.7, ["Mega|Ride"] = 348.51, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Ride"] = 21.26, ["Fly|Ride"] = 70.21, ["Neon"] = 15.91, ["Neon|Ride"] = 42.5, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 137.82, ["Mega|Ride"] = 269.89, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 18.38, ["Ride"] = 50.74, ["Fly|Ride"] = 178.5, ["Neon"] = 106.31, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 294.53, ["Mega"] = 419.88, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 530.2}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 6.57}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 6.29, ["Ride"] = 36.92, ["Neon"] = 32.71, ["Neon|Fly"] = 71.21, ["Neon|Ride"] = 163.64, ["Neon|Fly|Ride"] = 637.51, ["Mega"] = 283.5, ["Mega|Ride"] = 313.69, ["Mega|Fly|Ride"] = 545.31}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 24.81, ["Fly"] = 26.25, ["Ride"] = 31.49, ["Fly|Ride"] = 49.88, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 159.53, ["Neon|Fly|Ride"] = 175.11, ["Mega"] = 2124.99, ["Mega|Ride"] = 700, ["Mega|Fly|Ride"] = 609.46}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Fly|Ride"] = 78.75, ["Neon"] = 3.94, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 34.28, ["Mega|Ride"] = 78.05, ["Mega|Fly|Ride"] = 165.77}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 5.72, ["Fly"] = 26.25, ["Ride"] = 24.94, ["Fly|Ride"] = 62.26, ["Neon"] = 30.58, ["Neon|Ride"] = 113.7, ["Mega"] = 142.38, ["Mega|Fly"] = 397.63, ["Mega|Ride"] = 147, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 45.76, ["Ride"] = 13.13, ["Fly|Ride"] = 57.16, ["Neon"] = 21.45, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 27.4, ["Neon|Fly|Ride"] = 65.54, ["Mega"] = 136.43, ["Mega|Ride"] = 127.65, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 24.45, ["Neon"] = 4.26, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 29.82, ["Neon|Fly|Ride"] = 425.01, ["Mega"] = 35.73, ["Mega|Ride"] = 67.71, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 35.44, ["Fly"] = 113.7, ["Ride"] = 45.94, ["Neon"] = 231.27, ["Neon|Ride"] = 316.67, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 807.47, ["Mega|Ride"] = 774.38, ["Mega|Fly|Ride"] = 924.98}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.82, ["Ride"] = 71.21, ["Fly|Ride"] = 210, ["Neon"] = 47.63, ["Neon|Ride"] = 85.01, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 10.5, ["Fly"] = 130.94, ["Ride"] = 38.27, ["Fly|Ride"] = 196.88, ["Neon"] = 57.39, ["Neon|Fly"] = 212.51, ["Neon|Ride"] = 84.69, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 484.53, ["Mega|Ride"] = 328.32, ["Mega|Fly|Ride"] = 473.92}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 47.25, ["Fly"] = 142.38, ["Ride"] = 52.5, ["Fly|Ride"] = 262.44, ["Neon"] = 285.73, ["Neon|Ride"] = 354.88, ["Neon|Fly|Ride"] = 313.45, ["Mega|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 1640.63}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 29.3, ["Fly"] = 39.38, ["Ride"] = 59.7, ["Fly|Ride"] = 142.38, ["Neon"] = 107.79, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 212.51, ["Mega"] = 485.63, ["Mega|Ride"] = 480.25, ["Mega|Fly|Ride"] = 396.65}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 74.8, ["Fly"] = 145.69, ["Ride"] = 103.59, ["Neon"] = 203.44, ["Neon|Ride"] = 228.38, ["Neon|Fly|Ride"] = 373.13, ["Mega"] = 973.27, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 950.91}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 17.87, ["Ride"] = 70.14, ["Fly|Ride"] = 104.9, ["Neon"] = 91.88, ["Neon|Ride"] = 127.51, ["Neon|Fly|Ride"] = 283.7, ["Mega"] = 476.2, ["Mega|Ride"] = 323.54, ["Mega|Fly|Ride"] = 424.94}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 3.83, ["Fly"] = 69.5, ["Ride"] = 22.32, ["Neon"] = 80.76, ["Neon|Ride"] = 79.77, ["Neon|Fly|Ride"] = 127.51, ["Mega"] = 338.09, ["Mega|Ride"] = 1062.5, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 23.55, ["Ride"] = 79.01, ["Fly|Ride"] = 190.2, ["Neon"] = 67.87, ["Neon|Ride"] = 146.64, ["Neon|Fly|Ride"] = 316.13, ["Mega"] = 473.6, ["Mega|Ride"] = 413.11, ["Mega|Fly|Ride"] = 507.22}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 15.75, ["Ride"] = 34.13, ["Fly|Ride"] = 140.26, ["Neon"] = 48.89, ["Neon|Ride"] = 95.26, ["Mega"] = 316.64, ["Mega|Ride"] = 423.95, ["Mega|Fly|Ride"] = 407.3}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 42.51, ["Neon|Ride"] = 55.95, ["Mega"] = 18.38, ["Mega|Fly"] = 142.38, ["Mega|Ride"] = 70.81, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.94, ["Ride"] = 210, ["Fly|Ride"] = 440.95, ["Neon"] = 12.16, ["Neon|Ride"] = 83.83, ["Mega"] = 120.72, ["Mega|Ride"] = 234.82, ["Mega|Fly|Ride"] = 482.39}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.63, ["Neon"] = 22.32, ["Neon|Ride"] = 315, ["Mega"] = 181.79, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 6.55, ["Ride"] = 31.44, ["Fly|Ride"] = 117.88, ["Neon"] = 26.2, ["Neon|Ride"] = 82.95, ["Neon|Fly|Ride"] = 282.63, ["Mega"] = 123.38, ["Mega|Ride"] = 152.97, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 459.38, ["Ride"] = 542.07, ["Fly|Ride"] = 627.38, ["Neon|Ride"] = 1378.13, ["Neon|Fly|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 5840.63}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 4.8, ["Fly"] = 28.49, ["Ride"] = 25.18, ["Fly|Ride"] = 57.39, ["Neon"] = 42.51, ["Neon|Ride"] = 77.6, ["Neon|Fly|Ride"] = 210, ["Mega"] = 283.7, ["Mega|Ride"] = 276.26}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 11.82, ["Fly"] = 39.38, ["Ride"] = 27.64, ["Fly|Ride"] = 85.01, ["Neon"] = 55.21, ["Neon|Fly"] = 315, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 283.7, ["Mega"] = 337.89, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 324.18}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 7.88, ["Fly"] = 28.7, ["Ride"] = 22.64, ["Fly|Ride"] = 318.76, ["Neon"] = 18.27, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 223.13, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 21.15, ["Fly|Ride"] = 65.13, ["Neon"] = 10.5, ["Neon|Fly"] = 71.21, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 120.27, ["Mega"] = 66.68, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 157.26}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 71.21, ["Ride"] = 70.81, ["Neon"] = 2.63, ["Neon|Ride"] = 31.13, ["Neon|Fly|Ride"] = 79.77, ["Mega"] = 26.65, ["Mega|Ride"] = 47.63}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1561.88}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 6.45, ["Ride"] = 142.38, ["Neon"] = 53.13, ["Neon|Fly"] = 142.38, ["Neon|Ride"] = 71.21, ["Mega"] = 652.39, ["Mega|Ride"] = 552.51, ["Mega|Fly|Ride"] = 531.26}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 29.7, ["Neon"] = 8.43, ["Neon|Ride"] = 42.5, ["Mega"] = 57.75, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 229.04}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.63, ["Fly"] = 99.88, ["Ride"] = 23.26, ["Fly|Ride"] = 574.38, ["Neon"] = 10.48, ["Neon|Ride"] = 63.76, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 183.75, ["Mega|Ride"] = 153.01, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 368.82, ["Ride"] = 451.19, ["Fly|Ride"] = 459.38, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1717.84, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 6.29, ["Fly"] = 196.88, ["Ride"] = 72.19, ["Neon"] = 79.77, ["Neon|Ride"] = 57.39, ["Mega"] = 379.19, ["Mega|Ride"] = 280.51, ["Mega|Fly|Ride"] = 397.39}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Ride"] = 42.51, ["Neon"] = 6.39, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 44.64, ["Neon|Fly|Ride"] = 108.49, ["Mega"] = 28.88, ["Mega|Fly"] = 189, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 190.2}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 850, ["Neon"] = 3.87, ["Neon|Ride"] = 98.28, ["Neon|Fly|Ride"] = 269.89, ["Mega"] = 18.93, ["Mega|Ride"] = 142.38, ["Mega|Fly|Ride"] = 192.94}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 10.49, ["Fly"] = 56.27, ["Ride"] = 45, ["Fly|Ride"] = 148.76, ["Neon"] = 85.01, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 255.01, ["Mega|Ride"] = 419.7, ["Mega|Fly|Ride"] = 372.75}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 8.93, ["Ride"] = 110.52, ["Neon"] = 79.77, ["Neon|Ride"] = 142.38, ["Neon|Fly|Ride"] = 838.69, ["Mega"] = 567.38, ["Mega|Ride"] = 561.29, ["Mega|Fly|Ride"] = 1086.11}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 5.97, ["Fly"] = 65.63, ["Ride"] = 26.25, ["Fly|Ride"] = 99.89, ["Neon"] = 141.37, ["Neon|Ride"] = 200.82, ["Mega"] = 582.75, ["Mega|Ride"] = 328.02, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 15.94, ["Ride"] = 43.32, ["Fly|Ride"] = 142.87, ["Neon"] = 111.92, ["Neon|Ride"] = 156.13, ["Neon|Fly|Ride"] = 790.8, ["Mega"] = 525, ["Mega|Ride"] = 522.76, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 371.15, ["Ride"] = 391.37, ["Fly|Ride"] = 616.88, ["Neon"] = 1275, ["Neon|Ride"] = 1275, ["Neon|Fly|Ride"] = 1133.68, ["Mega|Ride"] = 3824.98, ["Mega|Fly|Ride"] = 3356.35}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 3.71, ["Fly"] = 28.3, ["Ride"] = 28.69, ["Fly|Ride"] = 84.53, ["Neon"] = 39.38, ["Neon|Ride"] = 135.73, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 525, ["Mega|Ride"] = 536.82, ["Mega|Fly|Ride"] = 714}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 11.82, ["Ride"] = 117.88, ["Mega"] = 1275, ["Mega|Fly|Ride"] = 1699.99}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 18.38, ["Ride"] = 56.44, ["Fly|Ride"] = 164.7, ["Neon"] = 43.21, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 159.53, ["Mega"] = 208.67, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 319.61}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.49, ["Ride"] = 42, ["Fly|Ride"] = 79.77, ["Neon"] = 14.43, ["Neon|Ride"] = 45.7, ["Mega"] = 40.69, ["Mega|Ride"] = 78.74, ["Mega|Fly|Ride"] = 238.1}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 45.94, ["Ride"] = 78.75, ["Neon"] = 225.27, ["Neon|Ride"] = 227.38, ["Neon|Fly|Ride"] = 425.01, ["Mega"] = 1060.38, ["Mega|Ride"] = 1261.18, ["Mega|Fly|Ride"] = 1201.69}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 595.24, ["Ride"] = 39.38, ["Fly|Ride"] = 64.3, ["Neon"] = 8.51, ["Neon|Fly"] = 156.96, ["Neon|Ride"] = 39.29, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 70.88, ["Mega|Ride"] = 96.22, ["Mega|Fly|Ride"] = 221.82}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 41.74, ["Ride"] = 28.7, ["Fly|Ride"] = 71.21, ["Neon"] = 6.39, ["Neon|Ride"] = 38.11, ["Neon|Fly|Ride"] = 140.33, ["Mega"] = 37.2, ["Mega|Ride"] = 80.77, ["Mega|Fly|Ride"] = 206.73}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 3.93, ["Ride"] = 50.79, ["Fly|Ride"] = 111.19, ["Neon"] = 22.32, ["Neon|Ride"] = 95.26, ["Neon|Fly|Ride"] = 708.69, ["Mega"] = 131.25, ["Mega|Fly"] = 637.51, ["Mega|Ride"] = 218.9, ["Mega|Fly|Ride"] = 605.07}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 70.2, ["Ride"] = 110.85, ["Fly|Ride"] = 202.96, ["Neon"] = 485.63, ["Neon|Ride"] = 509.25, ["Neon|Fly|Ride"] = 627.38, ["Mega|Fly|Ride"] = 1030.95}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 250.76, ["Ride"] = 297.51, ["Fly|Ride"] = 341.25, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1105, ["Mega"] = 7083.62, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 6.57, ["Neon"] = 38.11, ["Mega"] = 91.88, ["Mega|Fly"] = 71.21, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 420.76}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 8.51, ["Ride"] = 33.43, ["Fly|Ride"] = 211.45, ["Neon"] = 26.57, ["Mega"] = 105, ["Mega|Ride"] = 127.51, ["Mega|Fly|Ride"] = 331.52}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.61, ["Fly"] = 155.57, ["Ride"] = 27.57, ["Neon"] = 34.13, ["Mega"] = 517.79, ["Mega|Ride"] = 337.84}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 28.46, ["Ride"] = 21, ["Fly|Ride"] = 36.14, ["Neon"] = 5.25, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 90.09, ["Mega"] = 51.19, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 230.37}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 36.71, ["Fly|Ride"] = 210.68, ["Neon"] = 9.19, ["Mega"] = 36.14, ["Mega|Ride"] = 207.2}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 18.38, ["Fly|Ride"] = 41.94, ["Neon"] = 3.94, ["Neon|Fly"] = 47.63, ["Neon|Ride"] = 28.7, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 39.38, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 142.87}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.63, ["Fly"] = 26.25, ["Ride"] = 24.94, ["Fly|Ride"] = 63.76, ["Neon"] = 8.97, ["Neon|Fly"] = 47.63, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 70.14, ["Mega"] = 170.63, ["Mega|Ride"] = 201.89, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 26.25, ["Ride"] = 52.49, ["Fly|Ride"] = 83.65, ["Neon"] = 142.38, ["Neon|Ride"] = 283.7, ["Mega"] = 380.63, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 84.96, ["Ride"] = 101.07, ["Fly|Ride"] = 182.77, ["Neon"] = 439.69, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 546.25, ["Mega|Ride"] = 2259.93, ["Mega|Fly|Ride"] = 1588.08}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 17.07, ["Fly|Ride"] = 131.25, ["Neon"] = 4.26, ["Neon|Fly"] = 78.75, ["Neon|Fly|Ride"] = 142.38, ["Mega"] = 56.35, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 106.26}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 16.77, ["Ride"] = 19.14, ["Fly|Ride"] = 30.15, ["Neon"] = 4.2, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 24.92, ["Neon|Fly|Ride"] = 68.85, ["Mega"] = 41.89, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 4.59, ["Ride"] = 23.82, ["Neon"] = 36.14, ["Neon|Ride"] = 159.53, ["Neon|Fly|Ride"] = 157.26, ["Mega"] = 627.38, ["Mega|Ride"] = 318.76, ["Mega|Fly|Ride"] = 472.38}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 328.13, ["Fly"] = 413.44, ["Ride"] = 422.63, ["Fly|Ride"] = 297.51, ["Neon|Ride"] = 1346.19, ["Neon|Fly|Ride"] = 1592.68, ["Mega"] = 7936.73, ["Mega|Fly|Ride"] = 5312.44}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 27.54, ["Fly"] = 142.38, ["Ride"] = 62.45, ["Fly|Ride"] = 99.89, ["Neon"] = 131.25, ["Neon|Ride"] = 212.51, ["Neon|Fly|Ride"] = 297.51, ["Mega"] = 1090.13, ["Mega|Ride"] = 992.38, ["Mega|Fly|Ride"] = 951.51}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Fly|Ride"] = 57.39, ["Neon"] = 9.18, ["Neon|Ride"] = 34.54, ["Neon|Fly|Ride"] = 142.38, ["Mega"] = 82.69, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 212.51, ["Ride"] = 28.87, ["Fly|Ride"] = 142.7, ["Neon"] = 26.17, ["Neon|Ride"] = 202.96, ["Mega"] = 488.76}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 29.54, ["Fly"] = 78.64, ["Ride"] = 42.29, ["Fly|Ride"] = 91.4, ["Neon|Ride"] = 99.89, ["Neon|Fly|Ride"] = 159.53, ["Mega"] = 2549.98, ["Mega|Ride"] = 956.25, ["Mega|Fly|Ride"] = 1270.23}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 105.45, ["Ride"] = 142.12, ["Fly|Ride"] = 144.38, ["Neon"] = 414.86, ["Neon|Ride"] = 469.88, ["Neon|Fly|Ride"] = 452.63, ["Mega"] = 3117.35, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 210.91, ["Fly"] = 279.78, ["Ride"] = 245.44, ["Fly|Ride"] = 361.26, ["Neon|Ride"] = 955.19, ["Neon|Fly|Ride"] = 971.13, ["Mega|Fly|Ride"] = 2889.98}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 23.63, ["Ride"] = 23.82, ["Fly|Ride"] = 142.38, ["Neon"] = 112.88, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 227.38, ["Mega"] = 388.5, ["Mega|Ride"] = 398.43, ["Mega|Fly|Ride"] = 514.82}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.7, ["Ride"] = 17.38, ["Fly|Ride"] = 35.95, ["Neon"] = 6.36, ["Neon|Ride"] = 28.58, ["Neon|Fly|Ride"] = 47.63, ["Mega"] = 90.57, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.85, ["Fly"] = 33.64, ["Ride"] = 25.8, ["Fly|Ride"] = 71.21, ["Neon"] = 35.94, ["Neon|Fly"] = 148.76, ["Neon|Ride"] = 45.7, ["Neon|Fly|Ride"] = 105.69, ["Mega"] = 236.25, ["Mega|Ride"] = 232.32, ["Mega|Fly|Ride"] = 299.64}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 301.88, ["Fly"] = 496.19, ["Ride"] = 262.5, ["Fly|Ride"] = 406.88, ["Neon"] = 2071.86, ["Neon|Ride"] = 1699.99, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 5893.62}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 46.76, ["Neon"] = 8.5, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 41.97, ["Mega|Ride"] = 157.26, ["Mega|Fly|Ride"] = 269.89}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 2.63, ["Ride"] = 18.69, ["Fly|Ride"] = 54.78, ["Neon"] = 28.6, ["Neon|Fly"] = 36.14, ["Neon|Ride"] = 38.27, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 170.63, ["Mega|Fly"] = 204.9, ["Mega|Ride"] = 222.06, ["Mega|Fly|Ride"] = 308.7}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 18.38, ["Ride"] = 117.88, ["Neon"] = 104.89, ["Neon|Ride"] = 142.38, ["Neon|Fly|Ride"] = 567.38, ["Mega"] = 466.48, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 131.12, ["Fly"] = 282.63, ["Ride"] = 146.68, ["Fly|Ride"] = 170.63, ["Neon|Ride"] = 727.13, ["Neon|Fly|Ride"] = 485.63, ["Mega|Fly|Ride"] = 2098.69}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 25.4, ["Fly"] = 45.05, ["Ride"] = 30.18, ["Fly|Ride"] = 52.48, ["Neon"] = 94.5, ["Neon|Ride"] = 98.34, ["Neon|Fly|Ride"] = 139.2, ["Mega"] = 707.63, ["Mega|Ride"] = 421.44, ["Mega|Fly|Ride"] = 414.75}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 26.24, ["Neon"] = 2.63, ["Neon|Fly|Ride"] = 708.69, ["Mega"] = 27.61, ["Mega|Ride"] = 70.14, ["Mega|Fly|Ride"] = 253.95}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 52.5, ["Neon"] = 2.52, ["Neon|Fly"] = 159.53, ["Neon|Ride"] = 27.64, ["Neon|Fly|Ride"] = 69.18, ["Mega"] = 28.67, ["Mega|Fly"] = 141.67, ["Mega|Ride"] = 47.62, ["Mega|Fly|Ride"] = 103.36}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 9.54, ["Fly"] = 91.88, ["Ride"] = 61.69, ["Fly|Ride"] = 165.77, ["Neon"] = 39.19, ["Neon|Fly"] = 342.87, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 142.38, ["Mega"] = 142.38, ["Mega|Fly"] = 283.7, ["Mega|Ride"] = 158.63, ["Mega|Fly|Ride"] = 297.94}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1315.13, ["Ride"] = 1220.63, ["Fly|Ride"] = 1307.25, ["Neon|Ride"] = 4108.64, ["Neon|Fly|Ride"] = 4108.64, ["Mega"] = 18274.78, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 471.19, ["Ride"] = 468.66, ["Fly|Ride"] = 584.31, ["Neon"] = 1903.11, ["Neon|Ride"] = 2649.86, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 14285.4, ["Mega|Fly|Ride"] = 7084.87}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 303.65, ["Fly"] = 371.44, ["Ride"] = 343.39, ["Fly|Ride"] = 425.01, ["Neon"] = 590.63, ["Neon|Fly"] = 1270.23, ["Neon|Ride"] = 623.44, ["Neon|Fly|Ride"] = 761.25, ["Mega|Fly|Ride"] = 2783.73}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 320.25, ["Fly"] = 388.49, ["Ride"] = 354.88, ["Fly|Ride"] = 459.38, ["Neon"] = 1023.75, ["Neon|Fly"] = 3174.94, ["Neon|Ride"] = 1133.68, ["Neon|Fly|Ride"] = 945, ["Mega|Ride"] = 3675, ["Mega|Fly|Ride"] = 3879.16}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Ride"] = 17.01, ["Fly|Ride"] = 44.63, ["Neon"] = 5.36, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 79.48, ["Mega"] = 73.82, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 406.88, ["Ride"] = 456.75, ["Fly|Ride"] = 567.38, ["Neon"] = 1013.25, ["Neon|Ride"] = 1141.88, ["Neon|Fly|Ride"] = 1260, ["Mega"] = 6374.93, ["Mega|Ride"] = 4501.88, ["Mega|Fly|Ride"] = 4541.25}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.1, ["Fly"] = 183.75, ["Ride"] = 25.33, ["Neon"] = 11.58, ["Neon|Fly"] = 71.21, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 112.22, ["Mega"] = 52.5, ["Mega|Ride"] = 104.14, ["Mega|Fly|Ride"] = 218.09}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 21.26, ["Ride"] = 21.15, ["Fly|Ride"] = 39.38, ["Neon"] = 14.31, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 62.99, ["Mega"] = 91.77, ["Mega|Ride"] = 192.93, ["Mega|Fly|Ride"] = 314.62}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 3.82, ["Neon|Fly"] = 79.77, ["Mega"] = 24.87, ["Mega|Fly"] = 71.21, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 39.29, ["Ride"] = 65.63, ["Fly|Ride"] = 459.38, ["Neon"] = 244.13, ["Neon|Ride"] = 317.86, ["Mega"] = 1699.99, ["Mega|Ride"] = 1083.75, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 65.61, ["Ride"] = 19.69, ["Fly|Ride"] = 43.32, ["Neon"] = 32.82, ["Mega"] = 328.13, ["Mega|Ride"] = 233.89}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.12, ["Neon"] = 4.47, ["Neon|Fly"] = 91.77, ["Neon|Ride"] = 36.46, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 35.41, ["Mega|Fly"] = 708.69, ["Mega|Ride"] = 64.57, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.63, ["Fly"] = 31.49, ["Ride"] = 21, ["Fly|Ride"] = 49.87, ["Neon"] = 6.57, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 27.64, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 60.38, ["Mega|Fly"] = 175.14, ["Mega|Ride"] = 81.99, ["Mega|Fly|Ride"] = 167.89}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 6.34, ["Fly"] = 47.63, ["Ride"] = 32.16, ["Fly|Ride"] = 51.44, ["Neon"] = 105.2, ["Neon|Ride"] = 71.21, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 237.57, ["Mega|Ride"] = 276.26, ["Mega|Fly|Ride"] = 1296.75}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 11.44, ["Ride"] = 52.5, ["Neon"] = 170.01, ["Neon|Ride"] = 283.7, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 354.88, ["Mega|Ride"] = 337.89, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.2, ["Ride"] = 26.17, ["Fly|Ride"] = 71.21, ["Neon"] = 142.38, ["Neon|Ride"] = 79.77, ["Neon|Fly|Ride"] = 283.7, ["Mega"] = 567.38, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 16.96, ["Ride"] = 19.67, ["Fly|Ride"] = 55.97, ["Neon"] = 4.26, ["Neon|Ride"] = 47.16, ["Mega"] = 43.32, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 318.76}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 187.69, ["Fly"] = 297.51, ["Ride"] = 258.57, ["Fly|Ride"] = 263.51, ["Neon|Ride"] = 1145.38, ["Neon|Fly|Ride"] = 1102.5, ["Mega"] = 10624.87, ["Mega|Fly|Ride"] = 4519.83}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 20.11, ["Ride"] = 15.74, ["Fly|Ride"] = 41.68, ["Neon"] = 4.25, ["Neon|Fly"] = 53.13, ["Neon|Ride"] = 25.26, ["Neon|Fly|Ride"] = 55.13, ["Mega"] = 51.01, ["Mega|Ride"] = 74.24, ["Mega|Fly|Ride"] = 106.32}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 7.74, ["Ride"] = 26.24, ["Fly|Ride"] = 179.66, ["Neon"] = 73.98, ["Neon|Ride"] = 105, ["Mega"] = 374.27, ["Mega|Ride"] = 404.76, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 38.06, ["Fly"] = 131.25, ["Ride"] = 104.71, ["Fly|Ride"] = 142.38, ["Neon"] = 253.22, ["Neon|Ride"] = 297.88, ["Mega"] = 845.76, ["Mega|Ride"] = 808.54, ["Mega|Fly|Ride"] = 803.25}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 189, ["Fly"] = 308.44, ["Ride"] = 223.13, ["Fly|Ride"] = 302.66, ["Neon"] = 841.32, ["Neon|Ride"] = 651, ["Neon|Fly|Ride"] = 656.25, ["Mega|Ride"] = 3399.97, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 17.87, ["Neon"] = 82.69, ["Neon|Ride"] = 283.7, ["Mega"] = 285.48, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 708.69}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 41.89, ["Ride"] = 425.01, ["Fly|Ride"] = 158.82, ["Neon"] = 208.32, ["Neon|Fly|Ride"] = 850, ["Mega"] = 850, ["Mega|Fly|Ride"] = 2124.99}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1228.49, ["Fly"] = 1441.13, ["Ride"] = 1191.25, ["Fly|Ride"] = 1164.19, ["Neon|Ride"] = 5667.32, ["Neon|Fly|Ride"] = 4637.26, ["Mega|Fly|Ride"] = 17284.55}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 5.12, ["Fly"] = 25.38, ["Ride"] = 21.6, ["Fly|Ride"] = 34.01, ["Neon"] = 40.39, ["Neon|Fly"] = 75.06, ["Neon|Ride"] = 78.64, ["Neon|Fly|Ride"] = 200.82, ["Mega"] = 225.27, ["Mega|Ride"] = 259.53, ["Mega|Fly|Ride"] = 388.5}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 8.27, ["Fly"] = 13965.68, ["Ride"] = 32.82, ["Neon"] = 40.48, ["Neon|Ride"] = 42.51, ["Mega"] = 212.63, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 425.01}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 5.25, ["Ride"] = 44.64, ["Fly|Ride"] = 57.39, ["Neon"] = 36.67, ["Neon|Ride"] = 72.19, ["Mega"] = 136.01, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 623.69}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 19.14, ["Ride"] = 39.38, ["Fly|Ride"] = 102.79, ["Neon"] = 79.32, ["Neon|Ride"] = 98.98, ["Neon|Fly|Ride"] = 198.71, ["Mega"] = 420, ["Mega|Ride"] = 398.55, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 3.6, ["Fly"] = 24.45, ["Ride"] = 19.69, ["Fly|Ride"] = 40.95, ["Neon"] = 22.25, ["Neon|Fly"] = 57.38, ["Neon|Ride"] = 31.88, ["Neon|Fly|Ride"] = 86.63, ["Mega|Ride"] = 273.26, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Fly"] = 419.7, ["Neon"] = 11.82, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 56.9, ["Neon|Fly|Ride"] = 142.38, ["Mega"] = 233.25, ["Mega|Ride"] = 131.14, ["Mega|Fly|Ride"] = 389.94}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 157.5, ["Ride"] = 333.38, ["Fly|Ride"] = 603.58, ["Neon|Ride"] = 1105, ["Neon|Fly|Ride"] = 1133.68, ["Mega|Ride"] = 5250}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Ride"] = 28.12, ["Fly|Ride"] = 62.32, ["Neon"] = 11.46, ["Neon|Ride"] = 45.85, ["Neon|Fly|Ride"] = 142.38, ["Mega"] = 103.73, ["Mega|Ride"] = 89.25, ["Mega|Fly|Ride"] = 428.57}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 6.43, ["Ride"] = 415.45, ["Neon"] = 46.76, ["Neon|Ride"] = 313.85, ["Mega"] = 280.51, ["Mega|Ride"] = 267.25}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 8.51, ["Fly"] = 58.33, ["Ride"] = 34.09, ["Neon"] = 23.39, ["Neon|Fly"] = 71.21, ["Neon|Ride"] = 127.51, ["Neon|Fly|Ride"] = 280.93, ["Mega"] = 99.89, ["Mega|Fly"] = 425.01, ["Mega|Ride"] = 170.01, ["Mega|Fly|Ride"] = 288.25}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 157.26, ["Fly"] = 340.01, ["Ride"] = 290.41, ["Fly|Ride"] = 666.2, ["Neon"] = 714.28, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 950.94, ["Mega|Ride"] = 5099.95, ["Mega|Fly|Ride"] = 2098.69}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 26.25, ["Fly"] = 61.64, ["Ride"] = 45.94, ["Fly|Ride"] = 110.52, ["Neon"] = 105.68, ["Neon|Ride"] = 155.14, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 708.69, ["Mega|Ride"] = 637.51, ["Mega|Fly|Ride"] = 834.59}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 21, ["Ride"] = 54.21, ["Fly|Ride"] = 1275, ["Neon"] = 105, ["Neon|Ride"] = 133.88, ["Neon|Fly|Ride"] = 257.25, ["Mega"] = 489.14, ["Mega|Ride"] = 497.65, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 6.39, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.35, ["Mega"] = 35.44, ["Mega|Ride"] = 102.64, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 65.63, ["Fly"] = 105.79, ["Ride"] = 106.26, ["Fly|Ride"] = 131.25, ["Neon"] = 315, ["Neon|Fly"] = 471.77, ["Neon|Ride"] = 324.52, ["Neon|Fly|Ride"] = 354.38, ["Mega|Fly|Ride"] = 1239.02}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 18.8, ["Neon"] = 6.57, ["Neon|Ride"] = 57.39, ["Neon|Fly|Ride"] = 588, ["Mega"] = 37.2, ["Mega|Ride"] = 170.01}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 20.96, ["Fly"] = 43.32, ["Ride"] = 26.92, ["Fly|Ride"] = 61.69, ["Neon"] = 95.26, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 142.38, ["Mega"] = 389.82, ["Mega|Ride"] = 408.19, ["Mega|Fly|Ride"] = 370.34}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 35.57, ["Fly"] = 80.01, ["Ride"] = 70.88, ["Fly|Ride"] = 141.75, ["Neon"] = 270.95, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 239.91, ["Mega|Ride"] = 1842.37, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 15.72, ["Ride"] = 13.13, ["Fly|Ride"] = 28.7, ["Neon"] = 2.61, ["Neon|Fly"] = 27.74, ["Neon|Ride"] = 16.93, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 19.69, ["Mega|Fly"] = 55.13, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 76.18}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.93, ["Ride"] = 21.46, ["Fly|Ride"] = 124.69, ["Neon"] = 15.43, ["Neon|Ride"] = 71.21, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 177.19, ["Mega|Ride"] = 283.7, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 11.79, ["Fly"] = 142.38, ["Ride"] = 56.44, ["Neon"] = 99.89, ["Neon|Ride"] = 210.39, ["Neon|Fly|Ride"] = 360.2, ["Mega"] = 586.69, ["Mega|Ride"] = 485.63, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 2.63, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 138.13, ["Mega"] = 21, ["Mega|Ride"] = 78.56}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 5.25, ["Fly"] = 210, ["Ride"] = 31.75, ["Fly|Ride"] = 105, ["Neon"] = 66.4, ["Neon|Ride"] = 91.77, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 295.39, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 257.78, ["Mega|Fly|Ride"] = 354.88}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 15.75, ["Fly"] = 42.32, ["Ride"] = 26.17, ["Fly|Ride"] = 46.59, ["Neon"] = 129.68, ["Neon|Ride"] = 64.56, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 567.38, ["Mega|Fly|Ride"] = 1115.77}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 2.61, ["Ride"] = 59.21, ["Fly|Ride"] = 76.01, ["Neon"] = 25.3, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 200.82, ["Mega"] = 170.63, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 295.39}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 19.59, ["Fly"] = 2124.99, ["Ride"] = 39.38, ["Neon"] = 85.01, ["Neon|Ride"] = 388.5, ["Neon|Fly|Ride"] = 6348.68, ["Mega"] = 403.76, ["Mega|Ride"] = 1024.42, ["Mega|Fly|Ride"] = 1125.49}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 125.58, ["Fly|Ride"] = 196.87, ["Neon"] = 6.57, ["Neon|Fly"] = 51.01, ["Neon|Ride"] = 71.21, ["Neon|Fly|Ride"] = 99.08, ["Mega"] = 74.82, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 127.51}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Mega"] = 24.82, ["Mega|Ride"] = 142.38, ["Mega|Fly|Ride"] = 425.01}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 36.75}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 70.88, ["Fly"] = 102.38, ["Ride"] = 65.63, ["Fly|Ride"] = 208.27, ["Neon"] = 1050, ["Neon|Ride"] = 248.63, ["Neon|Fly|Ride"] = 1062.5, ["Mega"] = 992.38, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 708.69}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 84, ["Fly|Ride"] = 142.38, ["Neon"] = 3.15, ["Mega"] = 20.98, ["Mega|Fly"] = 137.82, ["Mega|Ride"] = 106.26, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 539.44, ["Ride"] = 472.48, ["Fly|Ride"] = 656.25, ["Neon"] = 2625, ["Neon|Fly|Ride"] = 2380.91, ["Mega"] = 16999.8, ["Mega|Fly|Ride"] = 14167.21}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 8.3, ["Fly"] = 25.71, ["Ride"] = 42.29, ["Fly|Ride"] = 79.7, ["Neon"] = 32.16, ["Neon|Ride"] = 280.51, ["Mega"] = 79.7, ["Mega|Ride"] = 142.38, ["Mega|Fly|Ride"] = 567.38}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 3.65, ["Fly"] = 44.64, ["Ride"] = 19.69, ["Fly|Ride"] = 52.5, ["Neon"] = 23.63, ["Neon|Ride"] = 35.6, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 283.7, ["Mega|Ride"] = 153.23, ["Mega|Fly|Ride"] = 255.94}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 9.18, ["Ride"] = 76.13, ["Fly|Ride"] = 106.31, ["Neon"] = 80.77, ["Neon|Ride"] = 181.13, ["Mega"] = 393.75, ["Mega|Ride"] = 383.25, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.28, ["Fly"] = 39.38, ["Ride"] = 31.5, ["Fly|Ride"] = 142.38, ["Neon"] = 42.51, ["Mega"] = 255.94}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 92.46, ["Ride"] = 44.63, ["Fly|Ride"] = 157.49, ["Neon"] = 166.69, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 169.32, ["Mega"] = 368.82, ["Mega|Ride"] = 407.54, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 4.67, ["Fly"] = 104.98, ["Ride"] = 39.38, ["Neon"] = 26.14, ["Neon|Ride"] = 93.52, ["Neon|Fly|Ride"] = 142.38, ["Mega"] = 276.2, ["Mega|Fly"] = 493.01, ["Mega|Ride"] = 318.76}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 28.7, ["Ride"] = 15.94, ["Fly|Ride"] = 29.19, ["Neon"] = 2.1, ["Neon|Ride"] = 15.94, ["Neon|Fly|Ride"] = 69.86, ["Mega"] = 19.41, ["Mega|Fly"] = 60.38, ["Mega|Ride"] = 63.76, ["Mega|Fly|Ride"] = 94.5}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 8.96, ["Fly"] = 71.21, ["Ride"] = 27.57, ["Fly|Ride"] = 159.53, ["Neon"] = 28.67, ["Neon|Fly"] = 119.05, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 318.71, ["Mega"] = 170.63, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 262.5, ["Ride"] = 302.03, ["Fly|Ride"] = 301.88, ["Neon"] = 1480.5, ["Neon|Ride"] = 1111.9, ["Neon|Fly|Ride"] = 1042.31, ["Mega|Fly|Ride"] = 4158.58}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 87.91, ["Fly"] = 157.26, ["Ride"] = 149.63, ["Fly|Ride"] = 210.39, ["Neon"] = 433.95, ["Neon|Ride"] = 354.38, ["Neon|Fly|Ride"] = 623.44, ["Mega"] = 4249.96, ["Mega|Ride"] = 2124.99, ["Mega|Fly|Ride"] = 1603.88}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 21.26, ["Ride"] = 18.94, ["Fly|Ride"] = 39.35, ["Neon"] = 15.85, ["Neon|Fly"] = 18.38, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 62.67, ["Mega"] = 91.4, ["Mega|Fly"] = 211.45, ["Mega|Ride"] = 92.46, ["Mega|Fly|Ride"] = 142.38}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 17.01, ["Ride"] = 15.94, ["Fly|Ride"] = 34, ["Neon"] = 3.71, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 23.82, ["Neon|Fly|Ride"] = 57.39, ["Mega"] = 78.59, ["Mega|Fly"] = 354.88, ["Mega|Ride"] = 93.19, ["Mega|Fly|Ride"] = 157.26}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 4.25, ["Ride"] = 19.06, ["Fly|Ride"] = 98.44, ["Neon"] = 28.7, ["Neon|Fly|Ride"] = 425.01, ["Mega"] = 142.38}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 210, ["Ride"] = 196.88, ["Fly|Ride"] = 328.13, ["Neon|Ride"] = 1302.37, ["Neon|Fly|Ride"] = 1278.18, ["Mega|Ride"] = 8499.9, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 23.99, ["Ride"] = 17.75, ["Fly|Ride"] = 36.14, ["Neon"] = 23.62, ["Neon|Fly"] = 159.53, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 75.02, ["Mega"] = 292.2, ["Mega|Ride"] = 255.01, ["Mega|Fly|Ride"] = 262.48}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.94, ["Fly"] = 142.87, ["Ride"] = 42.51, ["Fly|Ride"] = 212.51, ["Neon"] = 34.01, ["Neon|Ride"] = 74.84, ["Mega"] = 196.88, ["Mega|Ride"] = 236.24, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 19.14, ["Neon"] = 8.51, ["Neon|Ride"] = 28.98, ["Mega"] = 32.61, ["Mega|Ride"] = 36.91, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 13.13, ["Fly"] = 71.19, ["Ride"] = 26.2, ["Fly|Ride"] = 35.7, ["Neon"] = 140.49, ["Neon|Ride"] = 91.4, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 728.34, ["Mega|Ride"] = 423.95, ["Mega|Fly|Ride"] = 363.38}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 47.63, ["Fly"] = 116.82, ["Ride"] = 95.22, ["Fly|Ride"] = 249.38, ["Neon"] = 137.82, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 178.52, ["Neon|Fly|Ride"] = 318.76, ["Mega"] = 459.38, ["Mega|Fly"] = 2231.24, ["Mega|Ride"] = 485.63, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 26.25, ["Fly"] = 64.3, ["Ride"] = 52.36, ["Fly|Ride"] = 104.69, ["Neon"] = 118.13, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 141.6, ["Neon|Fly|Ride"] = 183.75, ["Mega|Ride"] = 794.05, ["Mega|Fly|Ride"] = 718.48}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.06, ["Fly"] = 17.07, ["Ride"] = 13.13, ["Fly|Ride"] = 42.51, ["Neon"] = 2.1, ["Neon|Fly"] = 23.55, ["Neon|Ride"] = 21.26, ["Neon|Fly|Ride"] = 62.7, ["Mega"] = 21.1, ["Mega|Fly"] = 36.75, ["Mega|Ride"] = 45.7, ["Mega|Fly|Ride"] = 114.35}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 204.74, ["Fly"] = 278.24, ["Ride"] = 278.07, ["Fly|Ride"] = 344.84, ["Neon"] = 1257.48, ["Neon|Ride"] = 958.13, ["Neon|Fly|Ride"] = 1122, ["Mega|Fly|Ride"] = 4199.99}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 10.5, ["Fly"] = 140.39, ["Ride"] = 42.2, ["Fly|Ride"] = 131.51, ["Neon"] = 105, ["Neon|Ride"] = 125.37, ["Neon|Fly|Ride"] = 210, ["Mega"] = 485.63, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 25.51, ["Ride"] = 18.38, ["Fly|Ride"] = 39.3, ["Neon"] = 7.88, ["Neon|Fly"] = 24.94, ["Neon|Ride"] = 32.16, ["Mega"] = 49.24, ["Mega|Fly"] = 181.71, ["Mega|Ride"] = 142.38, ["Mega|Fly|Ride"] = 302.39}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 28.7, ["Ride"] = 17.87, ["Fly|Ride"] = 56.9, ["Neon"] = 3.42, ["Neon|Fly"] = 47.63, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 97.23, ["Mega"] = 23.82, ["Mega|Fly"] = 142.38, ["Mega|Ride"] = 55.97, ["Mega|Fly|Ride"] = 136.5}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 19.69, ["Fly|Ride"] = 141.75, ["Neon"] = 11.46, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 7083.62, ["Mega"] = 92.93, ["Mega|Fly|Ride"] = 389.94}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 10.05, ["Fly"] = 65.63, ["Ride"] = 28.7, ["Fly|Ride"] = 51.19, ["Neon"] = 56.6, ["Neon|Ride"] = 42.29, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 355.95, ["Mega|Ride"] = 315.15, ["Mega|Fly|Ride"] = 285.73}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 13.13, ["Fly|Ride"] = 72.19, ["Neon"] = 39.38, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 236.25, ["Mega|Ride"] = 323.02, ["Mega|Fly|Ride"] = 437.76}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Fly"] = 21.12, ["Ride"] = 65.63, ["Neon"] = 4.25, ["Neon|Ride"] = 41.67, ["Neon|Fly|Ride"] = 95.26, ["Mega"] = 26.14, ["Mega|Ride"] = 78.3, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 7.8, ["Ride"] = 35.95, ["Fly|Ride"] = 85.01, ["Neon"] = 24.94, ["Neon|Fly"] = 102.92, ["Neon|Ride"] = 48.89, ["Neon|Fly|Ride"] = 147.61, ["Mega"] = 157.5, ["Mega|Fly"] = 269.89, ["Mega|Ride"] = 221.02, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 127.51, ["Fly|Ride"] = 99.89, ["Neon"] = 4.47, ["Neon|Fly"] = 85.01, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 159.53, ["Mega"] = 34.13, ["Mega|Fly"] = 283.7, ["Mega|Ride"] = 91.34, ["Mega|Fly|Ride"] = 635.71}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 24.56, ["Ride"] = 17.07, ["Fly|Ride"] = 65.54, ["Neon"] = 6.39, ["Neon|Ride"] = 30.45, ["Neon|Fly|Ride"] = 85.01, ["Mega"] = 65.63, ["Mega|Ride"] = 85.22, ["Mega|Fly|Ride"] = 158.69}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 630, ["Ride"] = 723.81, ["Fly|Ride"] = 742.05, ["Neon"] = 3357.47, ["Neon|Ride"] = 3258.67, ["Neon|Fly|Ride"] = 4640.95, ["Mega"] = 11904.5, ["Mega|Fly|Ride"] = 12462.19}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 19.43, ["Fly|Ride"] = 42.5, ["Neon"] = 24.35, ["Neon|Fly"] = 51.01, ["Neon|Ride"] = 57.06, ["Neon|Fly|Ride"] = 56.59, ["Mega"] = 190.2, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 3.92, ["Ride"] = 69.57, ["Fly|Ride"] = 105.51, ["Neon"] = 6.57, ["Neon|Fly"] = 850, ["Neon|Ride"] = 49.95, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 42, ["Mega|Fly"] = 142.38, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 181.13}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 11.82, ["Fly"] = 32.82, ["Ride"] = 22.32, ["Fly|Ride"] = 53.13, ["Neon"] = 46.51, ["Neon|Fly"] = 112.74, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 94.7, ["Mega"] = 313.45, ["Mega|Ride"] = 301.35, ["Mega|Fly|Ride"] = 335.99}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 28.7, ["Ride"] = 19.14, ["Fly|Ride"] = 32.82, ["Neon"] = 7.87, ["Neon|Fly"] = 131.23, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 63.31, ["Mega|Fly"] = 349.84, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 173.75}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 64.3, ["Ride"] = 165.77, ["Neon"] = 291.38, ["Neon|Ride"] = 276.2, ["Neon|Fly|Ride"] = 360.94, ["Mega"] = 887.48, ["Mega|Ride"] = 1417.37}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Fly|Ride"] = 89.27, ["Neon"] = 5.25, ["Neon|Fly"] = 135.73, ["Neon|Ride"] = 31.8, ["Neon|Fly|Ride"] = 206.07, ["Mega"] = 63.67, ["Mega|Fly"] = 142.38, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 351.75}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 3.56, ["Fly"] = 73.5, ["Ride"] = 23.29, ["Fly|Ride"] = 61.64, ["Neon"] = 15.74, ["Neon|Fly"] = 142.87, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 113.7, ["Mega"] = 91.88, ["Mega|Ride"] = 297.51, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 65.76, ["Neon"] = 15.75, ["Neon|Fly"] = 64.3, ["Mega"] = 113.7, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Ride"] = 20.08, ["Fly|Ride"] = 85.01, ["Neon"] = 5.16, ["Neon|Ride"] = 28.7, ["Neon|Fly|Ride"] = 68.16, ["Mega"] = 42.26, ["Mega|Fly"] = 157.26, ["Mega|Ride"] = 73.29, ["Mega|Fly|Ride"] = 97.49}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 13.06, ["Fly"] = 21.11, ["Ride"] = 17.87, ["Fly|Ride"] = 42, ["Neon"] = 85.01, ["Neon|Ride"] = 73.5, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 850, ["Mega|Ride"] = 388.88, ["Mega|Fly|Ride"] = 397.39}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 736.75, ["Fly"] = 921.19, ["Ride"] = 728.44, ["Fly|Ride"] = 813.75, ["Neon"] = 1938.57, ["Neon|Ride"] = 2209.99, ["Neon|Fly|Ride"] = 1998.94, ["Mega"] = 8266.5, ["Mega|Ride"] = 5643.75, ["Mega|Fly|Ride"] = 5808.63}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 68.25, ["Ride"] = 18.1, ["Fly|Ride"] = 42.15, ["Neon"] = 3.92, ["Neon|Fly"] = 139.19, ["Neon|Ride"] = 21.15, ["Neon|Fly|Ride"] = 59.52, ["Mega"] = 49.87, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 79.77}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 6.28, ["Ride"] = 38.67, ["Fly|Ride"] = 92.18, ["Neon"] = 46.44, ["Neon|Ride"] = 57.39, ["Neon|Fly|Ride"] = 248.11, ["Mega"] = 328.13, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 510.01}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 71.21, ["Ride"] = 85.01, ["Fly|Ride"] = 144.38, ["Neon"] = 380.39, ["Neon|Ride"] = 425.01, ["Neon|Fly|Ride"] = 1240.32, ["Mega"] = 1457.75, ["Mega|Ride"] = 1558.69, ["Mega|Fly|Ride"] = 1458.19}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 39.38, ["Ride"] = 63.76, ["Fly|Ride"] = 106.26, ["Neon"] = 164.7, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 281.09, ["Mega"] = 919.36, ["Mega|Ride"] = 765.01, ["Mega|Fly|Ride"] = 1057.19}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 14.44, ["Ride"] = 64.3, ["Fly|Ride"] = 142.38, ["Neon"] = 83.91, ["Neon|Ride"] = 159.53, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 297.51, ["Mega|Ride"] = 368.69, ["Mega|Fly|Ride"] = 374.07}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 26.25, ["Ride"] = 99.75, ["Neon"] = 72.19, ["Neon|Fly"] = 364.29, ["Neon|Ride"] = 365.49, ["Neon|Fly|Ride"] = 126.13, ["Mega"] = 283.91, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 476.2}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 18.96, ["Ride"] = 106.26, ["Neon"] = 131.25, ["Neon|Ride"] = 158.82, ["Neon|Fly|Ride"] = 525, ["Mega"] = 924, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 843.29}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 22.3}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 9.61, ["Fly"] = 79.77, ["Ride"] = 39.38, ["Fly|Ride"] = 40.48, ["Neon"] = 32.82, ["Neon|Ride"] = 85.01, ["Neon|Fly|Ride"] = 193.39, ["Mega"] = 189, ["Mega|Fly"] = 238.1, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 270.27}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.94, ["Ride"] = 47.63, ["Neon"] = 31.5, ["Mega"] = 348.92, ["Mega|Fly|Ride"] = 956.25}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 78.15, ["Fly"] = 393.75, ["Ride"] = 84.69, ["Fly|Ride"] = 117.47, ["Neon"] = 328.32, ["Neon|Ride"] = 291.38, ["Neon|Fly|Ride"] = 342.35, ["Mega|Ride"] = 891.19, ["Mega|Fly|Ride"] = 807.5}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.5, ["Fly"] = 28.7, ["Ride"] = 16.89, ["Fly|Ride"] = 39.37, ["Neon"] = 42.51, ["Neon|Fly"] = 70.9, ["Neon|Ride"] = 30.8, ["Neon|Fly|Ride"] = 77.12, ["Mega"] = 262.5, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 255.18}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 6.24, ["Fly"] = 85.01, ["Ride"] = 31.49, ["Fly|Ride"] = 60.58, ["Neon"] = 24.94, ["Neon|Ride"] = 42.51, ["Neon|Fly|Ride"] = 140.85, ["Mega"] = 146.56, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 252.45}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 6.39, ["Neon|Ride"] = 202.38, ["Mega"] = 34.13, ["Mega|Ride"] = 140.38, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 36.66, ["Fly"] = 85.01, ["Ride"] = 63.76, ["Fly|Ride"] = 78.72, ["Neon"] = 131.25, ["Neon|Ride"] = 241.2, ["Neon|Fly|Ride"] = 283.7, ["Mega"] = 1133.68, ["Mega|Ride"] = 838.03, ["Mega|Fly|Ride"] = 850}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 23.78, ["Fly|Ride"] = 85.01, ["Neon"] = 13.11, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 71.21, ["Neon|Fly|Ride"] = 358.32, ["Mega"] = 142.38, ["Mega|Fly|Ride"] = 309.68}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 13.13, ["Ride"] = 37.2, ["Neon"] = 82.69, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 351.69, ["Mega"] = 288.75, ["Mega|Ride"] = 496.19, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.63, ["Fly"] = 18.87, ["Ride"] = 16.94, ["Fly|Ride"] = 28.86, ["Neon"] = 21, ["Neon|Ride"] = 23.26, ["Neon|Fly|Ride"] = 78.21, ["Mega"] = 206.14, ["Mega|Ride"] = 232.98, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 5.25, ["Fly"] = 52.5, ["Ride"] = 24.45, ["Fly|Ride"] = 52.5, ["Neon"] = 68.01, ["Neon|Ride"] = 177.19, ["Mega"] = 278.39, ["Mega|Ride"] = 248.63, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.93, ["Ride"] = 36.53, ["Neon"] = 28.43, ["Neon|Ride"] = 262.5, ["Mega"] = 99.89, ["Mega|Ride"] = 771.1}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 38.85, ["Fly"] = 57.39, ["Ride"] = 105, ["Neon"] = 191.26, ["Neon|Fly"] = 241.2, ["Neon|Ride"] = 241.2, ["Mega"] = 1061.44, ["Mega|Ride"] = 1417.37, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 18.38, ["Ride"] = 281.61, ["Neon"] = 210, ["Mega"] = 389.82, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 9.19, ["Ride"] = 88.8, ["Fly|Ride"] = 283.7, ["Neon"] = 92.46, ["Neon|Ride"] = 393.75, ["Mega"] = 595.01, ["Mega|Ride"] = 559.95, ["Mega|Fly|Ride"] = 1699.99}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 24.91, ["Ride"] = 76.52, ["Fly|Ride"] = 269.89, ["Neon"] = 468.57, ["Neon|Ride"] = 637.51, ["Neon|Fly|Ride"] = 459, ["Mega"] = 945, ["Mega|Ride"] = 992.38, ["Mega|Fly|Ride"] = 1053.29}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.15, ["Neon"] = 42.63, ["Mega"] = 307.15, ["Mega|Fly|Ride"] = 317.86}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 26.23, ["Ride"] = 17.71, ["Fly|Ride"] = 41.91, ["Neon"] = 6.04, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 28.7, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 52.5, ["Mega|Ride"] = 89.25, ["Mega|Fly|Ride"] = 187.02}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 12.7, ["Ride"] = 48.76, ["Neon"] = 35.74, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 261.38, ["Mega|Ride"] = 159.53, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 20.74, ["Ride"] = 17.05, ["Fly|Ride"] = 55.13, ["Neon"] = 5.2, ["Neon|Ride"] = 23.39, ["Neon|Fly|Ride"] = 43.31, ["Mega"] = 44.64, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 147.52}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.61, ["Fly"] = 131.25, ["Fly|Ride"] = 99.89, ["Neon"] = 39.38, ["Neon|Ride"] = 93.52, ["Neon|Fly|Ride"] = 113.7, ["Mega"] = 225.27, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 476.2}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.72, ["Ride"] = 32.82, ["Fly|Ride"] = 99.75, ["Neon"] = 39.38, ["Neon|Fly"] = 476.2, ["Neon|Ride"] = 97.77, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 416.8, ["Mega|Fly|Ride"] = 952.38}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 6.38, ["Fly"] = 24.45, ["Ride"] = 28.7, ["Fly|Ride"] = 57.39, ["Neon"] = 21.26, ["Neon|Fly"] = 104.77, ["Neon|Ride"] = 38.27, ["Neon|Fly|Ride"] = 83.95, ["Mega"] = 219.72, ["Mega|Ride"] = 238.1, ["Mega|Fly|Ride"] = 394.31}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 3.09, ["Fly"] = 34.07, ["Ride"] = 17.87, ["Fly|Ride"] = 63.76, ["Neon"] = 20.2, ["Neon|Fly"] = 85.01, ["Neon|Ride"] = 42.51, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 127.51, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 352.75}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 9.19, ["Fly"] = 26.25, ["Ride"] = 36.14, ["Fly|Ride"] = 179.82, ["Neon"] = 24.94, ["Neon|Fly"] = 436.96, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 103.99, ["Mega|Ride"] = 152.09, ["Mega|Fly|Ride"] = 313.45}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 15.63, ["Fly"] = 105, ["Ride"] = 94.5, ["Fly|Ride"] = 272.4, ["Neon"] = 98.44, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 227.38, ["Mega"] = 378.9, ["Mega|Ride"] = 440.9, ["Mega|Fly|Ride"] = 557.89}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 59.06, ["Fly"] = 238.1, ["Ride"] = 96.42, ["Fly|Ride"] = 259.26, ["Neon"] = 255.01, ["Neon|Ride"] = 269.07, ["Neon|Fly|Ride"] = 442.01, ["Mega"] = 1050, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1016.81}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 51.01, ["Ride"] = 24.45, ["Fly|Ride"] = 65.54, ["Neon"] = 5.25, ["Neon|Ride"] = 37.95, ["Neon|Fly|Ride"] = 58.35, ["Mega"] = 27.4, ["Mega|Ride"] = 71.14, ["Mega|Fly|Ride"] = 115.55}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 16.85, ["Neon"] = 281.59, ["Mega"] = 425.01, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 1270.75}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 55.13, ["Fly"] = 105, ["Ride"] = 116.82, ["Neon"] = 190.5, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 496.19, ["Mega|Ride"] = 992.38, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 7.82, ["Fly"] = 190.32, ["Ride"] = 42.88, ["Fly|Ride"] = 126, ["Neon"] = 40.58, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 212.51, ["Mega"] = 226.5, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 394.42}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Fly"] = 157.5, ["Ride"] = 19.55, ["Fly|Ride"] = 84.77, ["Neon"] = 6.39, ["Neon|Ride"] = 31.49, ["Mega"] = 24.94, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 57.39, ["Mega|Fly|Ride"] = 154.18}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 708.69, ["Ride"] = 21.26, ["Fly|Ride"] = 51.4, ["Neon"] = 15.81, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 105, ["Mega"] = 168.95, ["Mega|Fly"] = 212.51, ["Mega|Ride"] = 212.51, ["Mega|Fly|Ride"] = 246.51}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 19.14, ["Ride"] = 18.38, ["Fly|Ride"] = 35.44, ["Neon"] = 2.61, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 59.52, ["Mega"] = 34.13, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Fly"] = 42.51, ["Ride"] = 26.25, ["Fly|Ride"] = 42.33, ["Neon"] = 6.19, ["Neon|Ride"] = 37.2, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 31.5, ["Mega|Fly"] = 168, ["Mega|Ride"] = 63.76, ["Mega|Fly|Ride"] = 202.61}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 159.53, ["Neon"] = 2.5, ["Neon|Ride"] = 126.27, ["Mega"] = 27.64, ["Mega|Ride"] = 106.26, ["Mega|Fly|Ride"] = 261.38}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 6.25, ["Ride"] = 31.4, ["Fly|Ride"] = 262.5, ["Neon"] = 42.51, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 210.39, ["Mega"] = 202.96, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 335.76}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 11.64, ["Ride"] = 32.95, ["Fly|Ride"] = 85.01, ["Neon"] = 124.69, ["Neon|Ride"] = 103.59, ["Neon|Fly|Ride"] = 236.91, ["Mega"] = 315, ["Mega|Ride"] = 343.2, ["Mega|Fly|Ride"] = 638.1}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 6.29, ["Fly"] = 24.34, ["Ride"] = 24.75, ["Fly|Ride"] = 48.19, ["Neon"] = 57.39, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 55.27, ["Neon|Fly|Ride"] = 86.4, ["Mega|Ride"] = 334.69, ["Mega|Fly|Ride"] = 368.69}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 74.59, ["Ride"] = 144.37, ["Fly|Ride"] = 262.5, ["Neon"] = 538.13, ["Neon|Ride"] = 1019.82, ["Mega"] = 3174.94, ["Mega|Fly|Ride"] = 1587.36}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 25.86, ["Fly"] = 72.43, ["Ride"] = 42.24, ["Fly|Ride"] = 59.07, ["Neon"] = 57.75, ["Mega"] = 635.71, ["Mega|Ride"] = 283.7, ["Mega|Fly|Ride"] = 1033.6}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 17.93, ["Ride"] = 19.67, ["Fly|Ride"] = 36.74, ["Neon"] = 3.15, ["Neon|Fly"] = 28.7, ["Neon|Ride"] = 21.17, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 42.51, ["Mega|Ride"] = 94.65, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 15.85, ["Ride"] = 17.87, ["Fly|Ride"] = 28.7, ["Neon"] = 4.13, ["Neon|Fly"] = 17.87, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 42.26, ["Mega"] = 47.63, ["Mega|Ride"] = 60.58, ["Mega|Fly|Ride"] = 98.89}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 393.74, ["Ride"] = 433.13, ["Fly|Ride"] = 495.81, ["Neon|Ride"] = 1788.07, ["Neon|Fly|Ride"] = 1509.38}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 9.19, ["Ride"] = 197.65, ["Fly|Ride"] = 30.97, ["Neon"] = 103.68, ["Neon|Ride"] = 127.51, ["Mega"] = 313.45, ["Mega|Ride"] = 609.89, ["Mega|Fly|Ride"] = 1275}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 17.01, ["Ride"] = 17.01, ["Fly|Ride"] = 24.45, ["Neon"] = 5.92, ["Neon|Ride"] = 20.74, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 42.88, ["Mega|Ride"] = 71.21, ["Mega|Fly|Ride"] = 110.94}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 79.94, ["Ride"] = 131.76, ["Fly|Ride"] = 501.38, ["Neon"] = 242.82, ["Neon|Ride"] = 303.18, ["Neon|Fly|Ride"] = 425.52, ["Mega"] = 737.63, ["Mega|Ride"] = 748.13, ["Mega|Fly|Ride"] = 850}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 19.69, ["Fly|Ride"] = 45.05, ["Neon"] = 13.13, ["Neon|Fly"] = 47.63, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 106.57, ["Mega|Fly"] = 160.13, ["Mega|Ride"] = 100.15, ["Mega|Fly|Ride"] = 188.92}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 71.29, ["Ride"] = 47.62, ["Fly|Ride"] = 1312.5, ["Neon"] = 3.61, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 28.7, ["Neon|Fly|Ride"] = 283.19, ["Mega"] = 19.69, ["Mega|Fly"] = 142.38, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 39.38, ["Fly"] = 141.65, ["Ride"] = 70.03, ["Fly|Ride"] = 212.51, ["Neon"] = 198.19, ["Neon|Ride"] = 238.1, ["Neon|Fly|Ride"] = 335.74, ["Mega"] = 1275, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 833.63}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 21.86, ["Fly|Ride"] = 39.38, ["Neon"] = 6.57, ["Neon|Ride"] = 55.27, ["Mega"] = 105.2, ["Mega|Ride"] = 129.84, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 39.38, ["Ride"] = 63.84, ["Neon"] = 269.84, ["Neon|Ride"] = 199.77, ["Neon|Fly|Ride"] = 382.51, ["Mega|Ride"] = 1699.99, ["Mega|Fly|Ride"] = 1060.38}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 2.63, ["Fly|Ride"] = 212.51, ["Neon"] = 41.91, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 425.01, ["Mega"] = 140.26, ["Mega|Ride"] = 603.75, ["Mega|Fly|Ride"] = 551.92}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 3.7, ["Fly"] = 71.21, ["Ride"] = 71.21, ["Fly|Ride"] = 65.63, ["Neon"] = 6.57, ["Neon|Fly"] = 78.54, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 109.54, ["Mega"] = 79.7, ["Mega|Ride"] = 728.43, ["Mega|Fly|Ride"] = 567.38}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 30.19, ["Ride"] = 56.44, ["Fly|Ride"] = 104.81, ["Neon"] = 159.53, ["Neon|Ride"] = 131.25, ["Mega|Ride"] = 2040.94, ["Mega|Fly|Ride"] = 1110.38}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.63, ["Fly"] = 144.82, ["Ride"] = 45.7, ["Fly|Ride"] = 908.98, ["Neon"] = 6.57, ["Neon|Ride"] = 41.45, ["Neon|Fly|Ride"] = 163.64, ["Mega"] = 53.17, ["Mega|Fly"] = 158.61, ["Mega|Ride"] = 92.01, ["Mega|Fly|Ride"] = 208.95}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 57.39, ["Ride"] = 19.69, ["Fly|Ride"] = 102.83, ["Neon"] = 6.2, ["Neon|Fly"] = 41.88, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 106.26, ["Mega"] = 168, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 291.14}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 11.43, ["Fly"] = 48.89, ["Ride"] = 40.48, ["Fly|Ride"] = 190.5, ["Neon"] = 77.18, ["Neon|Ride"] = 120.75, ["Mega"] = 311.07, ["Mega|Ride"] = 451.19, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 37.43, ["Ride"] = 88.52, ["Fly|Ride"] = 212.51, ["Neon"] = 156.19, ["Neon|Ride"] = 234.82, ["Neon|Fly|Ride"] = 389.23, ["Mega"] = 814.99, ["Mega|Ride"] = 731.8, ["Mega|Fly|Ride"] = 836.15}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 30, ["Fly"] = 30.17, ["Ride"] = 35.41, ["Fly|Ride"] = 77.44, ["Neon"] = 103.69, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 142.38, ["Mega"] = 620.57, ["Mega|Ride"] = 340.01, ["Mega|Fly|Ride"] = 393.14}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 73.5, ["Ride"] = 130.74, ["Fly|Ride"] = 196.85, ["Neon"] = 283.5, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 425.01, ["Mega"] = 1348.46, ["Mega|Ride"] = 1302, ["Mega|Fly|Ride"] = 1242.94}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 4.6, ["Ride"] = 35.44, ["Fly|Ride"] = 288.75, ["Neon"] = 15.74, ["Neon|Ride"] = 48.89, ["Neon|Fly|Ride"] = 305.8, ["Mega"] = 142.38, ["Mega|Ride"] = 225.27, ["Mega|Fly|Ride"] = 330.1}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 6.08, ["Ride"] = 24.92, ["Fly|Ride"] = 109.46, ["Neon"] = 21.45, ["Neon|Ride"] = 49.88, ["Mega"] = 203.44, ["Mega|Ride"] = 191.26}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 12.79, ["Fly"] = 28.88, ["Ride"] = 44.01, ["Fly|Ride"] = 98.95, ["Neon"] = 56.44, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 170.01, ["Mega"] = 318.76, ["Mega|Ride"] = 304.96, ["Mega|Fly|Ride"] = 452.82}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 11.75, ["Fly|Ride"] = 31.4, ["Neon"] = 2.1, ["Neon|Fly"] = 17.05, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 45.85, ["Mega"] = 17.01, ["Mega|Fly"] = 71.21, ["Mega|Ride"] = 23.63, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 59.07, ["Fly"] = 91.88, ["Ride"] = 142.38, ["Fly|Ride"] = 303.01, ["Neon"] = 240.13, ["Neon|Fly"] = 2408.67, ["Neon|Ride"] = 280.51, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 950.94, ["Mega|Ride"] = 807.19, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 95.64, ["Fly|Ride"] = 110.52, ["Neon"] = 5.98, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 42.51, ["Mega|Ride"] = 68.01, ["Mega|Fly|Ride"] = 229.69}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 19.69, ["Fly|Ride"] = 61.64, ["Neon"] = 15.94, ["Neon|Fly"] = 142.38, ["Neon|Ride"] = 32.44, ["Neon|Fly|Ride"] = 70.81, ["Mega"] = 118.13, ["Mega|Ride"] = 414.24, ["Mega|Fly|Ride"] = 283.7}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 78.75, ["Ride"] = 116.81, ["Fly|Ride"] = 317.86, ["Neon"] = 283.5, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 389.29, ["Mega"] = 977.5, ["Mega|Ride"] = 992.38, ["Mega|Fly|Ride"] = 1009.32}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.63, ["Ride"] = 72.19, ["Neon"] = 5.17, ["Neon|Ride"] = 42.84, ["Mega"] = 61.69, ["Mega|Ride"] = 134.19, ["Mega|Fly|Ride"] = 269.89}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 9.61}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 37.2, ["Fly|Ride"] = 321.9, ["Neon"] = 5.77, ["Neon|Ride"] = 60.58, ["Neon|Fly|Ride"] = 142.87, ["Mega"] = 39.29, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 127.5, ["Ride"] = 157.5, ["Fly|Ride"] = 236.25, ["Neon"] = 538.13, ["Neon|Ride"] = 680.01, ["Neon|Fly|Ride"] = 577.5, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2.77, ["Ride"] = 25.5, ["Neon"] = 15.94, ["Neon|Ride"] = 45.7, ["Neon|Fly|Ride"] = 110.52, ["Mega"] = 165.37, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 454.75}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 45.42, ["Mega|Ride"] = 128.21, ["Mega|Fly|Ride"] = 142.38}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 3.93, ["Ride"] = 30.85, ["Neon"] = 51.1, ["Neon|Ride"] = 113.7, ["Neon|Fly|Ride"] = 170.01, ["Mega"] = 853.13, ["Mega|Ride"] = 637.51, ["Mega|Fly|Ride"] = 635.71}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 17.01, ["Fly"] = 26.25, ["Ride"] = 26.23, ["Fly|Ride"] = 38.27, ["Neon"] = 79.75, ["Neon|Ride"] = 91.4, ["Neon|Fly|Ride"] = 147.62, ["Mega"] = 460.04, ["Mega|Ride"] = 239.07, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 47.63, ["Ride"] = 72.19, ["Neon"] = 190.24, ["Neon|Ride"] = 231, ["Neon|Fly|Ride"] = 482.39, ["Mega"] = 656.25, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 141.8, ["Fly"] = 170.63, ["Ride"] = 141.75, ["Fly|Ride"] = 221.82, ["Neon"] = 538.12, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 576.18, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 9.19, ["Fly"] = 19.67, ["Ride"] = 26.15, ["Fly|Ride"] = 39.38, ["Neon"] = 84.79, ["Neon|Fly"] = 425.01, ["Neon|Ride"] = 57.37, ["Neon|Fly|Ride"] = 94.49, ["Mega|Ride"] = 285.73, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 3.94, ["Fly"] = 131.23, ["Ride"] = 23.82, ["Fly|Ride"] = 131.25, ["Neon"] = 27.4, ["Neon|Ride"] = 35.69, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 137.82, ["Mega|Ride"] = 127.51, ["Mega|Fly|Ride"] = 354.88}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 13.13, ["Fly"] = 236.25, ["Ride"] = 42.33, ["Neon"] = 99.89, ["Neon|Ride"] = 113.7, ["Mega"] = 380.63, ["Mega|Fly|Ride"] = 521.7}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 39.38, ["Ride"] = 74.82, ["Fly|Ride"] = 212.51, ["Neon"] = 227.38, ["Neon|Ride"] = 212.51, ["Neon|Fly|Ride"] = 282.63, ["Mega"] = 956.25, ["Mega|Ride"] = 930.75, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 15.62, ["Ride"] = 81.86, ["Neon"] = 91.88, ["Neon|Ride"] = 126.62, ["Mega"] = 643.13, ["Mega|Ride"] = 743.76, ["Mega|Fly|Ride"] = 1046.73}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 309.75, ["Ride"] = 413.44, ["Neon"] = 774.43, ["Neon|Ride"] = 1133.68, ["Neon|Fly|Ride"] = 1162.38, ["Mega|Fly|Ride"] = 4647.33}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 32.71, ["Ride"] = 42.35, ["Fly|Ride"] = 79.77, ["Neon"] = 198.71, ["Neon|Ride"] = 227.38, ["Neon|Fly|Ride"] = 333.64, ["Mega"] = 984.38, ["Mega|Ride"] = 843.94, ["Mega|Fly|Ride"] = 851.8}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 28.7, ["Ride"] = 15.75, ["Fly|Ride"] = 67.6, ["Neon"] = 2.47, ["Neon|Ride"] = 17, ["Neon|Fly|Ride"] = 55.97, ["Mega"] = 22.2, ["Mega|Fly"] = 108.4, ["Mega|Ride"] = 46.36, ["Mega|Fly|Ride"] = 112.59}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 3.93, ["Ride"] = 211.02, ["Neon"] = 21.11, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 126.97, ["Mega"] = 159.38, ["Mega|Fly"] = 124.69, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 373.42}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 10.5, ["Ride"] = 34.01, ["Fly|Ride"] = 129.94, ["Neon"] = 20.2, ["Neon|Ride"] = 78.26, ["Neon|Fly|Ride"] = 168.95, ["Mega"] = 136.1, ["Mega|Fly"] = 496.19, ["Mega|Ride"] = 283.7, ["Mega|Fly|Ride"] = 302.39}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 364.25, ["Fly"] = 632.63, ["Ride"] = 393.65, ["Fly|Ride"] = 541.49, ["Neon"] = 1558.69, ["Neon|Ride"] = 1459.87, ["Neon|Fly|Ride"] = 1504.5, ["Mega|Fly|Ride"] = 4844.96}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 3.54, ["Fly"] = 47.59, ["Ride"] = 16.85, ["Fly|Ride"] = 42.21, ["Neon"] = 24.94, ["Neon|Ride"] = 28.48, ["Neon|Fly|Ride"] = 71.18, ["Mega|Ride"] = 270.83, ["Mega|Fly|Ride"] = 425.01}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 6.3, ["Fly"] = 31.7, ["Ride"] = 23.82, ["Fly|Ride"] = 39.38, ["Neon"] = 27.64, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 57.39, ["Neon|Fly|Ride"] = 85.01, ["Mega"] = 425.01, ["Mega|Ride"] = 708.69, ["Mega|Fly|Ride"] = 255.01}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 4.6, ["Fly"] = 85.01, ["Ride"] = 27.64, ["Fly|Ride"] = 65.63, ["Neon"] = 19, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 120.74, ["Mega"] = 127.51, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 57.22, ["Fly"] = 210, ["Ride"] = 71.21, ["Fly|Ride"] = 61.69, ["Neon"] = 118.13, ["Neon|Fly"] = 146.64, ["Neon|Ride"] = 184.89, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 956.25, ["Mega|Ride"] = 847.88, ["Mega|Fly|Ride"] = 509.53}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 31.35, ["Ride"] = 30.06, ["Fly|Ride"] = 52.9, ["Neon"] = 15.72, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 210, ["Mega"] = 144.38, ["Mega|Ride"] = 184.89, ["Mega|Fly|Ride"] = 952.23}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 5.25, ["Fly"] = 104.15, ["Ride"] = 28.53, ["Fly|Ride"] = 68.25, ["Neon"] = 113.7, ["Neon|Ride"] = 105.79, ["Mega|Ride"] = 600.27, ["Mega|Fly|Ride"] = 734.2}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 40.69, ["Neon"] = 6.18, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 28.65, ["Mega"] = 36.75, ["Mega|Ride"] = 134.19, ["Mega|Fly|Ride"] = 283.7}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 9.6, ["Ride"] = 57.39, ["Neon"] = 42.51, ["Neon|Ride"] = 71.21, ["Mega"] = 361.26, ["Mega|Fly|Ride"] = 850}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 17.07, ["Ride"] = 57.07, ["Fly|Ride"] = 206.14, ["Neon"] = 83.01, ["Mega"] = 328.13, ["Mega|Ride"] = 561.01, ["Mega|Fly|Ride"] = 465.38}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 10.5, ["Fly"] = 36.14, ["Ride"] = 23.63, ["Fly|Ride"] = 53.42, ["Neon"] = 54.21, ["Neon|Fly"] = 65.54, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 106.26, ["Mega"] = 414.39, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 380.41}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 164.07, ["Fly"] = 205.24, ["Ride"] = 183.75, ["Fly|Ride"] = 223.13, ["Neon"] = 864.42, ["Neon|Ride"] = 908.43, ["Neon|Fly|Ride"] = 908.43, ["Mega|Fly|Ride"] = 4235.09}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Fly"] = 27.64, ["Ride"] = 17.01, ["Fly|Ride"] = 23.3, ["Neon"] = 12.5, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 42, ["Mega"] = 220.5, ["Mega|Ride"] = 165.77, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.93, ["Fly"] = 42.51, ["Ride"] = 24.45, ["Fly|Ride"] = 103.8, ["Neon"] = 16.96, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 166.69, ["Mega"] = 248.38, ["Mega|Fly"] = 708.69, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 32.16, ["Fly"] = 126, ["Ride"] = 126, ["Fly|Ride"] = 402.7, ["Neon"] = 141.75, ["Neon|Ride"] = 204.67, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 404.25, ["Mega|Ride"] = 477.85, ["Mega|Fly|Ride"] = 441}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 99.73, ["Fly"] = 141.62, ["Ride"] = 127.51, ["Fly|Ride"] = 261.18, ["Neon"] = 560.62, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 609.89, ["Mega|Ride"] = 1664.94, ["Mega|Fly|Ride"] = 1648.5}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 39.38, ["Ride"] = 72.19, ["Neon"] = 91.88, ["Neon|Ride"] = 150.94, ["Neon|Fly|Ride"] = 285.73, ["Mega"] = 253.31, ["Mega|Ride"] = 334.07, ["Mega|Fly|Ride"] = 450.19}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.22, ["Fly|Ride"] = 46.5, ["Neon"] = 15.65, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 57.39, ["Mega|Ride"] = 184.89, ["Mega|Fly|Ride"] = 354.88}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 13.13, ["Ride"] = 42.51, ["Fly|Ride"] = 9208.59, ["Neon"] = 70.88, ["Neon|Ride"] = 142.38, ["Mega"] = 218.91, ["Mega|Ride"] = 285.48, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 75.6, ["Ride"] = 120.5, ["Fly|Ride"] = 207.16, ["Neon"] = 196.88, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 333.34, ["Mega"] = 538.7, ["Mega|Ride"] = 538.7, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 3.14, ["Ride"] = 87.94, ["Neon"] = 8.51, ["Neon|Fly"] = 142.38, ["Neon|Ride"] = 104.74, ["Neon|Fly|Ride"] = 150.56, ["Mega"] = 57.66, ["Mega|Fly"] = 163.64, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 318.76}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 11.7, ["Ride"] = 57.38, ["Neon"] = 65.62, ["Neon|Ride"] = 635.71, ["Mega"] = 348.2, ["Mega|Fly|Ride"] = 648.65}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 977.81, ["Fly"] = 1346.19, ["Ride"] = 1151.07, ["Fly|Ride"] = 1181.25, ["Neon"] = 3293.72, ["Neon|Ride"] = 3543.41, ["Neon|Fly|Ride"] = 3138.7, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 38.06, ["Fly"] = 79.77, ["Ride"] = 111.56, ["Fly|Ride"] = 238.1, ["Neon"] = 181.78, ["Neon|Ride"] = 285.73, ["Mega"] = 567.38, ["Mega|Ride"] = 840, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 6.4, ["Fly"] = 49.12, ["Ride"] = 32.95, ["Fly|Ride"] = 112.02, ["Neon"] = 18.1, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 78.75, ["Mega|Ride"] = 108.09, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 7.77, ["Ride"] = 131.22, ["Neon"] = 106.32, ["Mega"] = 376.14, ["Mega|Ride"] = 538.7, ["Mega|Fly|Ride"] = 924}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 22.64, ["Fly|Ride"] = 425.01, ["Neon"] = 2.63, ["Neon|Ride"] = 27.26, ["Neon|Fly|Ride"] = 99.89, ["Mega"] = 19.38, ["Mega|Fly"] = 126.45, ["Mega|Ride"] = 44.63, ["Mega|Fly|Ride"] = 552.51}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 85.22, ["Ride"] = 139.12, ["Fly|Ride"] = 262.5, ["Neon"] = 313.45, ["Neon|Ride"] = 361.23, ["Neon|Fly|Ride"] = 525.95, ["Mega"] = 1167.12, ["Mega|Fly"] = 1317.5, ["Mega|Ride"] = 1137.65, ["Mega|Fly|Ride"] = 1049.9}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 4.86, ["Fly"] = 101.07, ["Ride"] = 52.5, ["Fly|Ride"] = 84.99, ["Neon"] = 35.25, ["Neon|Ride"] = 47.38, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 350.44, ["Mega|Ride"] = 308.14, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.82, ["Fly"] = 65.63, ["Ride"] = 27.64, ["Neon"] = 12.99, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 142.38, ["Mega"] = 142.38, ["Mega|Ride"] = 241.2, ["Mega|Fly|Ride"] = 376.14}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 49.86, ["Ride"] = 110.52, ["Fly|Ride"] = 167.63, ["Neon"] = 181.02, ["Neon|Fly"] = 280.65, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 637.51, ["Mega"] = 1048.69, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 722.51}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 32.95, ["Ride"] = 70.88, ["Fly|Ride"] = 196.88, ["Neon"] = 124.69, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 315, ["Mega"] = 565.25, ["Mega|Fly|Ride"] = 1090.46}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 49.23, ["Ride"] = 99.89, ["Neon"] = 199.77, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 1083.49, ["Mega"] = 1133.68, ["Mega|Ride"] = 1699.99, ["Mega|Fly|Ride"] = 2124.99}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 5.71, ["Ride"] = 75.54, ["Neon"] = 22.32, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 118.95, ["Mega|Fly"] = 142.38, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 255.01}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 6.48, ["Fly"] = 32.15, ["Ride"] = 28.54, ["Fly|Ride"] = 63.76, ["Neon"] = 64.3, ["Neon|Ride"] = 79.77, ["Neon|Fly|Ride"] = 142.87, ["Mega"] = 399, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 702.85}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 129.94, ["Ride"] = 179.82, ["Fly|Ride"] = 233.63, ["Neon"] = 569.08, ["Neon|Fly"] = 666.2, ["Neon|Ride"] = 531.26, ["Neon|Fly|Ride"] = 602.44, ["Mega|Ride"] = 2361.19, ["Mega|Fly|Ride"] = 1903.13}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 19.06, ["Ride"] = 18.27, ["Fly|Ride"] = 45.94, ["Neon"] = 8.48, ["Neon|Fly"] = 64.31, ["Neon|Ride"] = 27.2, ["Neon|Fly|Ride"] = 77.35, ["Mega"] = 145.69, ["Mega|Ride"] = 136.4, ["Mega|Fly|Ride"] = 525.95}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 6.23, ["Fly"] = 87.93, ["Ride"] = 22.31, ["Fly|Ride"] = 70.81, ["Neon"] = 39.38, ["Neon|Fly"] = 281.17, ["Neon|Ride"] = 49.79, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 210, ["Mega|Ride"] = 172.49, ["Mega|Fly|Ride"] = 296.85}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Ride"] = 15.96, ["Fly|Ride"] = 36.64, ["Neon"] = 2.1, ["Neon|Fly"] = 16.69, ["Neon|Ride"] = 19.99, ["Neon|Fly|Ride"] = 52.41, ["Mega"] = 15.72, ["Mega|Fly"] = 32.16, ["Mega|Ride"] = 32.95, ["Mega|Fly|Ride"] = 95.26}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 42.28, ["Neon"] = 3.93, ["Neon|Fly"] = 42.51, ["Neon|Ride"] = 40.39, ["Mega"] = 19.69, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 140.26}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 3.92, ["Fly"] = 131.25, ["Ride"] = 27.64, ["Fly|Ride"] = 45.94, ["Neon"] = 22.64, ["Neon|Ride"] = 47.62, ["Mega"] = 112.65, ["Mega|Ride"] = 152.3}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 57.11, ["Ride"] = 84, ["Neon"] = 269.89, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 630, ["Mega"] = 774.38, ["Mega|Fly|Ride"] = 653.45}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 3.04, ["Fly"] = 16.88, ["Ride"] = 17.05, ["Fly|Ride"] = 41.89, ["Neon"] = 12.44, ["Neon|Fly"] = 38.27, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 60.38, ["Mega"] = 91.68, ["Mega|Fly"] = 164.04, ["Mega|Ride"] = 116.11, ["Mega|Fly|Ride"] = 183.87}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 3.92, ["Fly"] = 28.25, ["Ride"] = 19.14, ["Fly|Ride"] = 42.5, ["Neon"] = 19.69, ["Neon|Fly"] = 36.14, ["Neon|Ride"] = 30.82, ["Neon|Fly|Ride"] = 78.73, ["Mega"] = 137, ["Mega|Fly"] = 310.27, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 18.21, ["Fly|Ride"] = 99.89, ["Neon"] = 9.16, ["Neon|Fly"] = 47.63, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 79.77, ["Mega"] = 47.31, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 78.28, ["Mega|Fly|Ride"] = 97.63}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 11.6, ["Fly"] = 282.63, ["Ride"] = 24.35, ["Neon"] = 32.82, ["Neon|Ride"] = 59.04, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 255.01, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 318.76, ["Mega|Fly|Ride"] = 635.71}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 13.02, ["Fly"] = 155.14, ["Ride"] = 65.98, ["Neon"] = 99.89, ["Neon|Ride"] = 99.58, ["Mega"] = 656.25, ["Mega|Fly|Ride"] = 1062.5}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.94, ["Fly"] = 35.44, ["Ride"] = 20.9, ["Fly|Ride"] = 52.5, ["Neon"] = 26.25, ["Neon|Fly"] = 196.65, ["Neon|Ride"] = 70.14, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 190.5, ["Mega|Ride"] = 263.51, ["Mega|Fly|Ride"] = 405.88}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 20.65, ["Ride"] = 18.38, ["Fly|Ride"] = 52.5, ["Neon"] = 14.95, ["Neon|Fly"] = 37.2, ["Neon|Ride"] = 25.51, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 425.01, ["Mega|Ride"] = 236.91, ["Mega|Fly|Ride"] = 198.71}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 184.89, ["Fly"] = 393.75, ["Ride"] = 229.69, ["Fly|Ride"] = 257.14, ["Neon"] = 984.38, ["Neon|Ride"] = 956.25, ["Neon|Fly|Ride"] = 1179.94, ["Mega|Ride"] = 3543.41, ["Mega|Fly|Ride"] = 3611.42}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.61, ["Ride"] = 38.72, ["Neon"] = 30.85, ["Neon|Fly|Ride"] = 283.7, ["Mega"] = 123.38, ["Mega|Ride"] = 261.38}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.91, ["Ride"] = 21.17, ["Fly|Ride"] = 118.13, ["Neon"] = 28.7, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 36.3, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 196.88, ["Mega|Ride"] = 276.26, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 3.67, ["Fly|Ride"] = 159.53, ["Neon"] = 42.51, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 637.51, ["Mega"] = 475, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 427.23}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 16.89, ["Fly|Ride"] = 26.17, ["Neon"] = 2.1, ["Neon|Fly"] = 21.25, ["Neon|Ride"] = 15.94, ["Neon|Fly|Ride"] = 39.26, ["Mega"] = 22.32, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 60.58, ["Mega|Fly|Ride"] = 64.3}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.56, ["Fly"] = 56.37, ["Ride"] = 21.26, ["Fly|Ride"] = 56.44, ["Neon"] = 16.69, ["Neon|Fly"] = 42.51, ["Neon|Ride"] = 34.01, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 125.99, ["Mega|Ride"] = 113.7, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 4.26, ["Ride"] = 55.27, ["Fly|Ride"] = 77.43, ["Neon"] = 10.5, ["Neon|Ride"] = 28.7, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 55.13, ["Mega|Ride"] = 159.53, ["Mega|Fly|Ride"] = 170.01}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 78.75, ["Fly"] = 107.15, ["Ride"] = 99.89, ["Fly|Ride"] = 142.38, ["Neon"] = 317.86, ["Neon|Ride"] = 425.01, ["Neon|Fly|Ride"] = 429.87, ["Mega|Ride"] = 3543.41, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 7.08, ["Fly"] = 99.89, ["Ride"] = 34, ["Fly|Ride"] = 65.63, ["Neon"] = 26.25, ["Neon|Ride"] = 57.39, ["Neon|Fly|Ride"] = 136.91, ["Mega"] = 221.02, ["Mega|Ride"] = 259.86, ["Mega|Fly|Ride"] = 674.7}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.63, ["Fly"] = 31.88, ["Ride"] = 52.5, ["Fly|Ride"] = 118.13, ["Neon"] = 10.5, ["Neon|Ride"] = 57.39, ["Neon|Fly|Ride"] = 169.53, ["Mega"] = 75.83, ["Mega|Fly"] = 313.69, ["Mega|Ride"] = 105.2, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 59.07, ["Fly"] = 127.39, ["Ride"] = 90.57, ["Fly|Ride"] = 209.99, ["Neon"] = 153.54, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 590.63, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 567}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 16.94, ["Ride"] = 12.71, ["Fly|Ride"] = 34.01, ["Neon"] = 2.63, ["Neon|Fly"] = 38.06, ["Neon|Ride"] = 17, ["Neon|Fly|Ride"] = 27.57, ["Mega"] = 24.43, ["Mega|Fly"] = 43.24, ["Mega|Ride"] = 29.51, ["Mega|Fly|Ride"] = 71.21}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 4.2, ["Neon|Ride"] = 60.38, ["Neon|Fly|Ride"] = 71.1, ["Mega"] = 26.25, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 186.17}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 3.94, ["Ride"] = 44.64, ["Neon"] = 14.16, ["Neon|Ride"] = 95.64, ["Neon|Fly|Ride"] = 191.26, ["Mega"] = 70.88, ["Mega|Ride"] = 152.28, ["Mega|Fly|Ride"] = 283.7}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 10.48, ["Fly"] = 70.88, ["Ride"] = 61.69, ["Fly|Ride"] = 118.13, ["Neon"] = 38.07, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 104.81, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 112.61, ["Mega|Fly"] = 212.51, ["Mega|Ride"] = 161.52, ["Mega|Fly|Ride"] = 265.13}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.64, ["Ride"] = 12.34, ["Fly|Ride"] = 36.92, ["Neon"] = 2.1, ["Neon|Fly"] = 28.6, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 21.48, ["Mega|Ride"] = 44.64, ["Mega|Fly|Ride"] = 103.69}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 13.13, ["Ride"] = 43.98, ["Fly|Ride"] = 204.78, ["Neon"] = 70.88, ["Neon|Ride"] = 167.89, ["Neon|Fly|Ride"] = 196.23, ["Mega"] = 389.94, ["Mega|Ride"] = 496.19, ["Mega|Fly|Ride"] = 564.2}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2625, ["Fly"] = 3150, ["Ride"] = 2779.88, ["Fly|Ride"] = 2748.38, ["Neon|Fly|Ride"] = 9318.75, ["Mega|Fly|Ride"] = 44093.2}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 15.72, ["Fly|Ride"] = 45.94, ["Neon"] = 10.5, ["Neon|Fly"] = 62.29, ["Neon|Ride"] = 23.82, ["Neon|Fly|Ride"] = 64.92, ["Mega"] = 73.5, ["Mega|Fly"] = 142.38, ["Mega|Ride"] = 99.05, ["Mega|Fly|Ride"] = 161.44}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.63, ["Ride"] = 65.63, ["Fly|Ride"] = 74.82, ["Neon"] = 13.13, ["Mega"] = 126, ["Mega|Fly"] = 179.82, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 637.51}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 15.68, ["Fly"] = 49.95, ["Ride"] = 35.44, ["Fly|Ride"] = 148.76, ["Neon"] = 68.25, ["Neon|Ride"] = 279.57, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 403.76, ["Mega|Ride"] = 397.69, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 51.14, ["Ride"] = 98.44, ["Neon"] = 187.69, ["Neon|Ride"] = 279.74, ["Neon|Fly|Ride"] = 425.01, ["Mega"] = 540.75, ["Mega|Ride"] = 736.89, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 150.94, ["Fly"] = 269.89, ["Ride"] = 196.88, ["Fly|Ride"] = 221.02, ["Neon"] = 592.88, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 735, ["Neon|Fly|Ride"] = 782.87, ["Mega"] = 6374.93, ["Mega|Ride"] = 3540.42, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 7.88, ["Ride"] = 52.5, ["Fly|Ride"] = 675.94, ["Neon"] = 19.69, ["Neon|Fly"] = 71.21, ["Neon|Ride"] = 104.9, ["Neon|Fly|Ride"] = 141.6, ["Mega"] = 224.44, ["Mega|Fly"] = 183.35, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 238.1}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 17.07, ["Neon|Fly"] = 99.89, ["Neon|Ride"] = 42.51, ["Neon|Fly|Ride"] = 530.2, ["Mega"] = 113.7, ["Mega|Ride"] = 261.03, ["Mega|Fly|Ride"] = 838.31}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 101.99, ["Ride"] = 23.82, ["Fly|Ride"] = 131.25, ["Neon"] = 12.68, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 92.46, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 273.82}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 18.38, ["Fly|Ride"] = 656.25, ["Neon|Ride"] = 142.38, ["Neon|Fly|Ride"] = 283.7, ["Mega"] = 504.7, ["Mega|Ride"] = 501.27, ["Mega|Fly|Ride"] = 641.17}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 71.21, ["Neon"] = 2.1, ["Neon|Ride"] = 38.11, ["Mega"] = 17.07, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 340.01}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 78.73, ["Ride"] = 91.88, ["Fly|Ride"] = 118.13, ["Neon"] = 326.21, ["Neon|Ride"] = 409.5, ["Neon|Fly|Ride"] = 425.01, ["Mega"] = 1365, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1443.75}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Fly|Ride"] = 65.63, ["Neon"] = 6.36, ["Neon|Ride"] = 105.2, ["Mega"] = 47.63, ["Mega|Ride"] = 141.75}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 45.94, ["Fly"] = 99.89, ["Ride"] = 70.88, ["Fly|Ride"] = 106.26, ["Neon"] = 295.32, ["Neon|Fly"] = 354.88, ["Neon|Ride"] = 211.03, ["Neon|Fly|Ride"] = 527.63, ["Mega"] = 2625, ["Mega|Ride"] = 1275, ["Mega|Fly|Ride"] = 1133.68}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 34.01, ["Ride"] = 24.45, ["Fly|Ride"] = 49.88, ["Neon"] = 4.26, ["Neon|Fly"] = 122.19, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 42.28, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 123.98}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 3.54, ["Ride"] = 47.63, ["Neon"] = 9.54, ["Neon|Ride"] = 118.13, ["Mega"] = 78.63, ["Mega|Fly|Ride"] = 425.01}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 14.43, ["Fly|Ride"] = 211.45, ["Neon"] = 75.78, ["Neon|Ride"] = 142.38, ["Mega"] = 216.98, ["Mega|Ride"] = 246.51, ["Mega|Fly|Ride"] = 956.25}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 402.91, ["Ride"] = 444.94, ["Fly|Ride"] = 525, ["Neon"] = 1207.5, ["Neon|Ride"] = 1351.88, ["Neon|Fly|Ride"] = 1443.75, ["Mega"] = 4462.46, ["Mega|Ride"] = 4410, ["Mega|Fly|Ride"] = 3830.82}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 35.95, ["Fly"] = 57.39, ["Ride"] = 51.19, ["Fly|Ride"] = 78.56, ["Neon"] = 198.71, ["Neon|Fly"] = 317.86, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 217.88, ["Mega"] = 989.19, ["Mega|Fly|Ride"] = 936.06}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 27.15, ["Ride"] = 20.01, ["Fly|Ride"] = 40.39, ["Neon"] = 7.09, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 97.02, ["Mega"] = 55.13, ["Mega|Ride"] = 71.21, ["Mega|Fly|Ride"] = 413.11}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 10.49, ["Fly"] = 109.91, ["Ride"] = 36.14, ["Fly|Ride"] = 122.07, ["Neon"] = 42.5, ["Neon|Fly"] = 198.14, ["Neon|Ride"] = 77.47, ["Neon|Fly|Ride"] = 157.26, ["Mega"] = 229.69, ["Mega|Fly"] = 397.39, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 346.5}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 9.74, ["Ride"] = 21.13, ["Fly|Ride"] = 51.19, ["Neon"] = 84, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 119.05, ["Mega|Ride"] = 476.2, ["Mega|Fly|Ride"] = 382.51}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 4.19, ["Neon"] = 15.49, ["Mega"] = 52.5, ["Mega|Ride"] = 129.93, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 3.29, ["Fly"] = 86.63, ["Ride"] = 22.32, ["Fly|Ride"] = 52.39, ["Neon"] = 23.63, ["Neon|Ride"] = 42.51, ["Neon|Fly|Ride"] = 216.77, ["Mega"] = 555.96, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 476.2}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 104.97, ["Fly"] = 127.39, ["Ride"] = 121.96, ["Fly|Ride"] = 191.26, ["Neon|Ride"] = 546.14, ["Neon|Fly|Ride"] = 714.28, ["Mega"] = 2654.11, ["Mega|Ride"] = 2833.66, ["Mega|Fly|Ride"] = 3100.35}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 23.13, ["Fly"] = 95.82, ["Ride"] = 79.33, ["Fly|Ride"] = 159.53, ["Neon"] = 192.94, ["Neon|Ride"] = 197.09, ["Mega"] = 707.63, ["Mega|Ride"] = 630, ["Mega|Fly|Ride"] = 671.45}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2205, ["Fly"] = 2349.3, ["Ride"] = 2231.24, ["Fly|Ride"] = 2323.13, ["Neon"] = 12749.86, ["Neon|Ride"] = 8730.77, ["Neon|Fly|Ride"] = 7743.75, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.63, ["Fly"] = 65625, ["Ride"] = 41.89, ["Fly|Ride"] = 170.63, ["Neon"] = 14.34, ["Neon|Ride"] = 55.97, ["Neon|Fly|Ride"] = 170.01, ["Mega"] = 95.26, ["Mega|Ride"] = 167.35, ["Mega|Fly|Ride"] = 425.01}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 15.65, ["Ride"] = 202.38, ["Fly|Ride"] = 157.26, ["Neon"] = 56.17, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 255.94, ["Mega|Ride"] = 368.69, ["Mega|Fly|Ride"] = 688.42}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 853.13, ["Fly"] = 1417.37, ["Ride"] = 918.75, ["Fly|Ride"] = 997.5, ["Neon"] = 2598.75, ["Neon|Ride"] = 3005.63, ["Neon|Fly|Ride"] = 2960.5, ["Mega|Fly|Ride"] = 12269.97}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 49.88, ["Ride"] = 45.55, ["Fly|Ride"] = 210, ["Neon"] = 270.24, ["Neon|Ride"] = 227.38, ["Mega"] = 656.25, ["Mega|Ride"] = 804.56, ["Mega|Fly|Ride"] = 844.69}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.94, ["Ride"] = 23.63, ["Fly|Ride"] = 91.88, ["Neon"] = 15.65, ["Neon|Ride"] = 142.38, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 133.89, ["Mega|Fly|Ride"] = 306.48}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 111.19, ["Ride"] = 23.39, ["Neon"] = 3.83, ["Neon|Ride"] = 52.41, ["Mega"] = 28.7, ["Mega|Ride"] = 70.14, ["Mega|Fly|Ride"] = 191.26}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 117.95, ["Ride"] = 125.99, ["Fly|Ride"] = 317.86, ["Neon"] = 459.38, ["Neon|Fly|Ride"] = 476.2, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 2692.36}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 7.66, ["Neon"] = 31.48, ["Neon|Ride"] = 142.38, ["Mega"] = 147.52, ["Mega|Ride"] = 184.89, ["Mega|Fly|Ride"] = 357.15}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 99.7, ["Ride"] = 134.95, ["Fly|Ride"] = 142.38, ["Neon"] = 614.25, ["Neon|Ride"] = 525, ["Mega"] = 1842.37, ["Mega|Fly|Ride"] = 1458.19}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 10.06, ["Fly"] = 105, ["Fly|Ride"] = 91.88, ["Neon"] = 33.15, ["Neon|Fly"] = 42.51, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 227.38, ["Mega|Fly|Ride"] = 283.7}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 259.82, ["Fly"] = 425.01, ["Ride"] = 294.09, ["Fly|Ride"] = 328.13, ["Neon"] = 1111.9, ["Neon|Ride"] = 1204.88, ["Neon|Fly|Ride"] = 813.75, ["Mega|Fly|Ride"] = 4108.64}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 5.25, ["Fly"] = 87.92, ["Ride"] = 21.26, ["Fly|Ride"] = 42.39, ["Neon"] = 45.7, ["Neon|Ride"] = 69.45, ["Neon|Fly|Ride"] = 104.96, ["Mega"] = 229.68, ["Mega|Ride"] = 656.25}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 18.15, ["Ride"] = 15.73, ["Fly|Ride"] = 34.12, ["Neon"] = 6.39, ["Neon|Fly"] = 21.26, ["Neon|Ride"] = 25.39, ["Neon|Fly|Ride"] = 46.55, ["Mega"] = 59.01, ["Mega|Fly"] = 104.87, ["Mega|Ride"] = 134.78, ["Mega|Fly|Ride"] = 150.38}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 840, ["Fly"] = 1190.46, ["Ride"] = 903, ["Fly|Ride"] = 1047.38, ["Neon|Ride"] = 4999.91, ["Neon|Fly|Ride"] = 4462.46, ["Mega"] = 28570.79, ["Mega|Fly|Ride"] = 28333.34}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 9.54, ["Fly"] = 992.38, ["Ride"] = 57.39, ["Neon"] = 31.84, ["Neon|Ride"] = 70.2, ["Mega"] = 157.35, ["Mega|Ride"] = 227.38, ["Mega|Fly|Ride"] = 372.1}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 6.55, ["Fly"] = 32.82, ["Ride"] = 54.26, ["Fly|Ride"] = 120.07, ["Neon"] = 22.32, ["Neon|Fly"] = 77.68, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 101.06, ["Mega"] = 183.75, ["Mega|Ride"] = 218.89, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 38.06, ["Fly"] = 32.82, ["Ride"] = 32.82, ["Fly|Ride"] = 63.58, ["Neon"] = 223.14, ["Neon|Ride"] = 206.21, ["Neon|Fly|Ride"] = 192.94, ["Mega"] = 2124.99, ["Mega|Fly|Ride"] = 787.48}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 15.72, ["Fly"] = 79.7, ["Ride"] = 30.19, ["Fly|Ride"] = 86.63, ["Neon"] = 57.38, ["Neon|Ride"] = 95.26, ["Neon|Fly|Ride"] = 169.99, ["Mega"] = 288.75, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 448.88}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 27.57, ["Ride"] = 210, ["Fly|Ride"] = 343.2, ["Neon"] = 86.63, ["Neon|Ride"] = 183.1, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 486.18, ["Mega|Ride"] = 517.44, ["Mega|Fly|Ride"] = 607.76}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Fly"] = 63.76, ["Ride"] = 116.59, ["Fly|Ride"] = 238.1, ["Neon"] = 2.6, ["Neon|Ride"] = 27.92, ["Mega"] = 20.95, ["Mega|Fly"] = 85.73, ["Mega|Ride"] = 59.52}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 32.79, ["Fly"] = 42.5, ["Ride"] = 43.94, ["Fly|Ride"] = 99.89, ["Neon"] = 273.94, ["Neon|Fly"] = 309.2, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 3399.97, ["Mega|Fly|Ride"] = 1069.99}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 3.93, ["Fly"] = 90.48, ["Ride"] = 19.66, ["Fly|Ride"] = 70.87, ["Neon"] = 42.35, ["Neon|Ride"] = 142.38, ["Neon|Fly|Ride"] = 142.38, ["Mega"] = 773.07, ["Mega|Ride"] = 272.35, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 26.14, ["Ride"] = 20.26, ["Fly|Ride"] = 36.75, ["Neon"] = 19, ["Neon|Ride"] = 49.95, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 1061.44, ["Mega|Ride"] = 283.7, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 5.23, ["Ride"] = 103.69, ["Neon"] = 105, ["Neon|Ride"] = 850, ["Neon|Fly|Ride"] = 127.51, ["Mega"] = 297.51, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 19.69, ["Fly"] = 262.36, ["Ride"] = 90.96, ["Fly|Ride"] = 196.88, ["Neon"] = 118.13, ["Neon|Fly"] = 313.45, ["Neon|Ride"] = 211.32, ["Neon|Fly|Ride"] = 229.5, ["Mega"] = 656.25, ["Mega|Ride"] = 485.63, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 6.57, ["Ride"] = 98.44, ["Neon"] = 23.59, ["Neon|Ride"] = 74.39, ["Mega"] = 104.89, ["Mega|Fly|Ride"] = 317.86}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 21, ["Neon"] = 2.63, ["Neon|Ride"] = 26.25, ["Mega"] = 19.69, ["Mega|Ride"] = 52.37, ["Mega|Fly|Ride"] = 204.75}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Ride"] = 20.99, ["Neon"] = 3.92, ["Neon|Fly"] = 393.59, ["Neon|Ride"] = 21.11, ["Neon|Fly|Ride"] = 178.52, ["Mega"] = 18.27, ["Mega|Fly"] = 73.86, ["Mega|Ride"] = 53.28, ["Mega|Fly|Ride"] = 106.32}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 25.89, ["Ride"] = 21.25, ["Fly|Ride"] = 49.26, ["Neon"] = 7.13, ["Neon|Fly"] = 57.39, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 78.64, ["Mega"] = 83.89, ["Mega|Ride"] = 159.53, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.54, ["Fly|Ride"] = 5357.03, ["Neon"] = 15.74, ["Neon|Ride"] = 1312.5, ["Mega"] = 105, ["Mega|Ride"] = 148.79, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 17.01, ["Fly|Ride"] = 40.6, ["Neon"] = 15.94, ["Neon|Fly"] = 53.13, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 285.73, ["Mega|Ride"] = 269.07, ["Mega|Fly|Ride"] = 367.49}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 86.63, ["Ride"] = 207.2, ["Fly|Ride"] = 397.39, ["Neon"] = 227.38, ["Neon|Ride"] = 298.91, ["Neon|Fly|Ride"] = 1062.5, ["Mega"] = 787.5, ["Mega|Ride"] = 845.4, ["Mega|Fly|Ride"] = 915.03}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 14.88, ["Ride"] = 21.15, ["Fly|Ride"] = 36.14, ["Neon"] = 3.84, ["Neon|Fly"] = 28.5, ["Neon|Ride"] = 20.98, ["Neon|Fly|Ride"] = 40.27, ["Mega"] = 63.76, ["Mega|Ride"] = 59.01, ["Mega|Fly|Ride"] = 104.68}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 10.5, ["Fly"] = 62.91, ["Ride"] = 44.63, ["Fly|Ride"] = 63.76, ["Neon"] = 57.07, ["Neon|Fly"] = 76.52, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 850, ["Mega|Ride"] = 249.64, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 18.59, ["Fly"] = 39.38, ["Ride"] = 28.7, ["Fly|Ride"] = 71.29, ["Neon"] = 72.13, ["Neon|Ride"] = 80.77, ["Neon|Fly|Ride"] = 176.75, ["Mega"] = 1062.5, ["Mega|Ride"] = 419.7, ["Mega|Fly|Ride"] = 441.45}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 2.1, ["Fly"] = 140.38, ["Ride"] = 47.5, ["Neon"] = 22.64, ["Neon|Ride"] = 71.21, ["Mega"] = 279.57, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 17.59, ["Fly|Ride"] = 30.19, ["Neon"] = 3.84, ["Neon|Fly"] = 41.45, ["Neon|Ride"] = 23.39, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 49.88, ["Mega|Fly"] = 105, ["Mega|Ride"] = 61.64, ["Mega|Fly|Ride"] = 133.29}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.52, ["Fly"] = 78.07, ["Ride"] = 21.13, ["Fly|Ride"] = 99.89, ["Neon"] = 15.74, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 62.46, ["Neon|Fly|Ride"] = 212.51, ["Mega"] = 120.07, ["Mega|Fly"] = 735, ["Mega|Ride"] = 196.47, ["Mega|Fly|Ride"] = 420.76}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 945, ["Ride"] = 1128.17, ["Fly|Ride"] = 1115.63, ["Neon"] = 2625, ["Neon|Fly"] = 2904.86, ["Neon|Ride"] = 2862.36, ["Neon|Fly|Ride"] = 2296.88, ["Mega|Fly|Ride"] = 7466.42}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 78.72, ["Ride"] = 94.5, ["Neon"] = 260.24, ["Neon|Ride"] = 316.31, ["Neon|Fly|Ride"] = 382.51, ["Mega"] = 1486.43, ["Mega|Ride"] = 1473.68, ["Mega|Fly|Ride"] = 1295.44}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Ride"] = 65.63, ["Neon"] = 5.81, ["Neon|Ride"] = 75.46, ["Neon|Fly|Ride"] = 99.89, ["Mega"] = 69.75}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 31.5, ["Ride"] = 65.94, ["Fly|Ride"] = 127.51, ["Neon"] = 167.14, ["Neon|Ride"] = 190.56, ["Neon|Fly|Ride"] = 284.88, ["Mega"] = 1023.75, ["Mega|Ride"] = 1515.94, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 8.79, ["Ride"] = 105, ["Fly|Ride"] = 156.19, ["Neon"] = 55.34, ["Neon|Ride"] = 72.27, ["Neon|Fly|Ride"] = 282.63, ["Mega"] = 477.07, ["Mega|Ride"] = 313.1, ["Mega|Fly|Ride"] = 1062.5}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 282.19, ["Fly"] = 318.76, ["Ride"] = 292.17, ["Fly|Ride"] = 561.75, ["Neon"] = 984.38, ["Neon|Ride"] = 1133.68, ["Neon|Fly|Ride"] = 1115.63, ["Mega|Fly|Ride"] = 4122.46}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.63, ["Fly"] = 102.37, ["Ride"] = 22.32, ["Fly|Ride"] = 129.93, ["Neon"] = 19.69, ["Neon|Ride"] = 53.9, ["Mega"] = 405.88, ["Mega|Fly"] = 283.7}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 26.25}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 59.07, ["Ride"] = 126.45, ["Neon"] = 318.76, ["Neon|Ride"] = 410.82, ["Neon|Fly|Ride"] = 402.94, ["Mega"] = 590.63, ["Mega|Ride"] = 637.51, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 48.54, ["Neon"] = 13.13, ["Mega"] = 227.38, ["Mega|Ride"] = 297.51, ["Mega|Fly|Ride"] = 212.51}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 15.73, ["Fly|Ride"] = 26.25, ["Neon"] = 3.82, ["Neon|Fly"] = 32.16, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 28.54, ["Mega|Fly"] = 71.21, ["Mega|Ride"] = 40.48, ["Mega|Fly|Ride"] = 90.57}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4200, ["Ride"] = 4331.25, ["Fly|Ride"] = 4200, ["Neon"] = 26492.05, ["Neon|Fly|Ride"] = 21359.63, ["Mega|Fly|Ride"] = 55554.7}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 13.12, ["Ride"] = 46.76, ["Neon"] = 95.71, ["Neon|Ride"] = 71.21, ["Mega"] = 418.69, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 23.63, ["Ride"] = 18.38, ["Fly|Ride"] = 44.63, ["Neon"] = 12.86, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 28.7, ["Neon|Fly|Ride"] = 70.14, ["Mega"] = 229.53, ["Mega|Ride"] = 142.87, ["Mega|Fly|Ride"] = 203.58}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 402.94, ["Fly"] = 513.19, ["Ride"] = 459.38, ["Fly|Ride"] = 523.69, ["Neon"] = 1312.5, ["Neon|Ride"] = 1275, ["Neon|Fly|Ride"] = 1169.44, ["Mega|Fly|Ride"] = 4817.33}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 3.26, ["Ride"] = 28.7, ["Neon"] = 17.07, ["Neon|Ride"] = 145.68, ["Mega"] = 124.69, ["Mega|Fly|Ride"] = 318.76}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.91, ["Fly"] = 191.72, ["Ride"] = 955.19, ["Neon"] = 95.26, ["Neon|Ride"] = 142.38, ["Neon|Fly|Ride"] = 14167.21, ["Mega"] = 387.85, ["Mega|Ride"] = 401.63}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.33, ["Ride"] = 17.75, ["Fly|Ride"] = 82.55, ["Neon"] = 7.77, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 48.55, ["Mega|Ride"] = 85.22, ["Mega|Fly|Ride"] = 156.19}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 629.99, ["Ride"] = 630, ["Fly|Ride"] = 695.42, ["Neon"] = 2507.48, ["Neon|Fly|Ride"] = 1967.34, ["Mega|Fly|Ride"] = 8751.75}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 5.25, ["Ride"] = 76.29, ["Fly|Ride"] = 114.91, ["Neon"] = 26.25, ["Neon|Ride"] = 99.89, ["Neon|Fly|Ride"] = 211.45, ["Mega"] = 144.38, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 320.95}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 15.94, ["Fly"] = 235.94, ["Ride"] = 68.16, ["Fly|Ride"] = 150.94, ["Neon"] = 51.91, ["Neon|Ride"] = 111.92, ["Neon|Fly|Ride"] = 159.53, ["Mega"] = 216.57, ["Mega|Ride"] = 239.02, ["Mega|Fly|Ride"] = 339.74}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 3.54, ["Fly"] = 28.54, ["Ride"] = 17, ["Fly|Ride"] = 42.51, ["Neon"] = 15.61, ["Neon|Ride"] = 28.54, ["Neon|Fly|Ride"] = 61.64, ["Mega"] = 170.63, ["Mega|Fly"] = 283.7, ["Mega|Ride"] = 159.53, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 42.63, ["Ride"] = 48.57, ["Neon"] = 91.82, ["Neon|Fly"] = 170.63, ["Neon|Ride"] = 127.51, ["Neon|Fly|Ride"] = 317.86, ["Mega"] = 476.2, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 530.2}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 39.37, ["Neon"] = 4.26, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 54.54, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 31.2, ["Mega|Fly"] = 106.26, ["Mega|Ride"] = 88.2, ["Mega|Fly|Ride"] = 183.74}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 393.75, ["Ride"] = 471.18, ["Fly|Ride"] = 531.26, ["Neon"] = 1837.5, ["Neon|Ride"] = 2407.61, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Ride"] = 9285.51, ["Mega|Fly|Ride"] = 7848.75}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 35.95, ["Neon"] = 6.57, ["Neon|Ride"] = 47.63, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 36.14, ["Mega|Ride"] = 134.93, ["Mega|Fly|Ride"] = 326.42}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 52.43, ["Neon"] = 4.26, ["Neon|Fly"] = 71.21, ["Neon|Ride"] = 214.29, ["Mega"] = 32.95, ["Mega|Fly"] = 93.52, ["Mega|Ride"] = 85.01, ["Mega|Fly|Ride"] = 211.45}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 21, ["Neon"] = 4.13, ["Neon|Ride"] = 36.14, ["Mega"] = 37.2, ["Mega|Fly"] = 157.26, ["Mega|Ride"] = 92.46}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 3.81, ["Ride"] = 131.25, ["Neon"] = 25.51, ["Neon|Ride"] = 71.21, ["Mega"] = 232.7, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 60.38, ["Fly"] = 159.53, ["Ride"] = 98.44, ["Fly|Ride"] = 232.32, ["Neon"] = 235.6, ["Neon|Ride"] = 283.7, ["Neon|Fly|Ride"] = 442.98, ["Mega"] = 669.38, ["Mega|Ride"] = 608.99, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 17.87, ["Fly"] = 69.47, ["Ride"] = 63.95, ["Fly|Ride"] = 112.11, ["Neon"] = 113.09, ["Neon|Ride"] = 148.76, ["Neon|Fly|Ride"] = 283.7, ["Mega"] = 463.1, ["Mega|Ride"] = 500.91, ["Mega|Fly|Ride"] = 524.95}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 3.31, ["Fly"] = 40.69, ["Ride"] = 16.93, ["Fly|Ride"] = 41.93, ["Neon"] = 27.64, ["Neon|Fly"] = 71.21, ["Neon|Ride"] = 28.7, ["Neon|Fly|Ride"] = 77.43, ["Mega"] = 394.42, ["Mega|Ride"] = 238.04, ["Mega|Fly|Ride"] = 246.51}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 7.76, ["Ride"] = 64.32, ["Fly|Ride"] = 114.3, ["Neon"] = 269.89, ["Neon|Ride"] = 158.82, ["Neon|Fly|Ride"] = 234.82, ["Mega"] = 335.76, ["Mega|Ride"] = 794.05, ["Mega|Fly|Ride"] = 990.26}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.88, ["Fly"] = 275.2, ["Ride"] = 27.64, ["Fly|Ride"] = 362.25, ["Neon"] = 22.32, ["Neon|Ride"] = 71.21, ["Mega"] = 168, ["Mega|Ride"] = 195.51, ["Mega|Fly|Ride"] = 504.7}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 19.67, ["Fly"] = 70.25, ["Ride"] = 30.16, ["Fly|Ride"] = 52.5, ["Neon"] = 228.74, ["Neon|Ride"] = 170.01, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 955.19, ["Mega|Ride"] = 952.38, ["Mega|Fly|Ride"] = 705.5}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 52.5, ["Fly"] = 874.13, ["Ride"] = 85.01, ["Neon"] = 142.38, ["Neon|Ride"] = 476.2, ["Mega|Ride"] = 590.63}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 49.88, ["Fly"] = 115.5, ["Ride"] = 81.38, ["Fly|Ride"] = 111.92, ["Neon"] = 297.94, ["Neon|Fly"] = 326.21, ["Neon|Ride"] = 276.92, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1168.75, ["Mega|Ride"] = 1343.85, ["Mega|Fly|Ride"] = 918.65}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 45.94, ["Fly"] = 92.79, ["Ride"] = 78.11, ["Fly|Ride"] = 71.21, ["Neon"] = 157.5, ["Neon|Ride"] = 170.01, ["Neon|Fly|Ride"] = 408.19, ["Mega"] = 513.35, ["Mega|Ride"] = 637.6, ["Mega|Fly|Ride"] = 612.94}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 25.57, ["Ride"] = 65.63, ["Neon"] = 108.94, ["Mega"] = 850, ["Mega|Ride"] = 779.88, ["Mega|Fly|Ride"] = 720.38}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 10.5, ["Fly"] = 27.2, ["Ride"] = 32.22, ["Fly|Ride"] = 91.88, ["Neon"] = 45.94, ["Neon|Fly"] = 170.01, ["Neon|Ride"] = 91.32, ["Neon|Fly|Ride"] = 116.28, ["Mega"] = 349.49, ["Mega|Ride"] = 345.19, ["Mega|Fly|Ride"] = 396.56}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 20.2, ["Ride"] = 15.94, ["Fly|Ride"] = 35.44, ["Neon"] = 4.26, ["Neon|Fly"] = 24.89, ["Neon|Ride"] = 21.26, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 45.94, ["Mega|Ride"] = 62.99, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1165.5}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 20.97, ["Ride"] = 55.97, ["Fly|Ride"] = 131.25, ["Neon"] = 131.76, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 301.76, ["Mega"] = 486.63, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 518.44}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 56.88, ["Neon"] = 3.93, ["Neon|Ride"] = 37.2, ["Neon|Fly|Ride"] = 297.51, ["Mega"] = 27.64, ["Mega|Ride"] = 117.95, ["Mega|Fly|Ride"] = 142.38}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 35.44, ["Fly"] = 111.92, ["Ride"] = 71.45, ["Neon"] = 208.31, ["Neon|Fly"] = 315, ["Neon|Ride"] = 168.95, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 708.75, ["Mega|Ride"] = 953.07, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Ride"] = 65.63, ["Neon"] = 3.54, ["Neon|Ride"] = 105, ["Mega"] = 34.28, ["Mega|Fly|Ride"] = 708.69}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 4.26, ["Neon|Ride"] = 159.53, ["Mega"] = 27.61, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 118.13, ["Ride"] = 148.76, ["Neon"] = 426.57, ["Neon|Fly"] = 514.28, ["Neon|Ride"] = 512.13, ["Neon|Fly|Ride"] = 522.43, ["Mega|Ride"] = 6547.49, ["Mega|Fly|Ride"] = 2098.69}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 26.11, ["Ride"] = 21.26, ["Fly|Ride"] = 71.45, ["Neon"] = 13.11, ["Neon|Fly"] = 63.76, ["Neon|Ride"] = 35.43, ["Neon|Fly|Ride"] = 157.24, ["Mega"] = 107.63, ["Mega|Ride"] = 134.95, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 36.16, ["Ride"] = 131.24, ["Fly|Ride"] = 86.63, ["Neon"] = 3.84, ["Neon|Fly"] = 63.76, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 99.89, ["Mega"] = 40.69, ["Mega|Ride"] = 104.14, ["Mega|Fly|Ride"] = 116.82}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 6.39, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.35, ["Mega"] = 35.44, ["Mega|Ride"] = 102.64, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 19.14, ["Neon"] = 8.51, ["Neon|Ride"] = 28.98, ["Mega"] = 32.61, ["Mega|Ride"] = 36.91, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 39.31, ["Ride"] = 91.88, ["Fly|Ride"] = 1062.5, ["Neon"] = 267.77, ["Neon|Ride"] = 407.69, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1558.69, ["Mega|Ride"] = 1557.63, ["Mega|Fly|Ride"] = 1558.69}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.93, ["Ride"] = 36.53, ["Neon"] = 28.43, ["Neon|Ride"] = 262.5, ["Mega"] = 99.89, ["Mega|Ride"] = 771.1}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 371.15, ["Ride"] = 391.37, ["Fly|Ride"] = 616.88, ["Neon"] = 1275, ["Neon|Ride"] = 1275, ["Neon|Fly|Ride"] = 1133.68, ["Mega|Ride"] = 3824.98, ["Mega|Fly|Ride"] = 3356.35}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 76.13}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 42}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 13.12}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 11.81}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 26.25}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 39.38}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 19.69}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 9.19}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 240.19}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 14.44}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 41.97}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 7.35}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 7.23}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 853.13}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 4.6}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 3.94}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 5.24}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 5.72}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 23.62}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 445.45}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 652.61}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 13.13}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1378.13}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 64.32}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 6.2}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 10.5}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 14.44}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 72.17}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 52.5}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 10.5}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 14.44}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 15.7}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 2.5}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 17.07}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.63}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 31.46}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 15.74}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 3.93}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.63}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1640.63}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 84.67}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 308.23}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 10.74}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 6.57}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 7.88}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 26.25}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 157.5}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 7.23}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 39.38}},
    ["rbxassetid://1265129435"] = {name = "Gold Snowboard", prices = {["default"] = 157.5}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 1004.48}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 19.59}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 3.93}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 35.44}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 6.02}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 3.94}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 131.14}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 17.07}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 10.5}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 22.32}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.63}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 10.5}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 5.25}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 32.51}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 112.28}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 159.07}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 5.25}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 14.43}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 26.12}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 71.21}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 64.92}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 21958.42}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 183.73}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 26.21}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 65.6}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 24.44}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 45.89}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 62.89}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 45.94}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 183.75}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 96.49}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 26.25}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 39.38}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 41.77}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 42}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 103.09}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 354.37}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 65.63}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 7.72}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 6.33}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 23.63}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 32.82}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 2.1}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.47}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 3.29}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 6.56}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 1071}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 6.57}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 627.4}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 21}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 408.01}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 40.58}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 92.25}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 27.15}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 31.48}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 105}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 30.97}},
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
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 41.45}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.93}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.89}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 5.25}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 16.84}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 157.5}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 52.5}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1020}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 9.49}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 30.45}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 7.46}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 12.81}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 78.73}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 10.49}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 7.88}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 7.77}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 12.8}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 85.32}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 26.25}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 7.87}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 36.74}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 3.92}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 3.94}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 4.6}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 14.3}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 2.46}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 3.93}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 6.15}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 4.25}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 5670}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 12.96}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3.29}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 7.87}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.57}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 20.2}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 7.09}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.91}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 15.48}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 105}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 32.11}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 3.89}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 4.03}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 3.93}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.6}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 3675}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 4.61}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 39.25}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 2.1}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 81.38}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 7.18}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 282.63}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.1}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.75}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 4.26}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 11.67}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 44.64}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.65}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.61}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 13.13}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 6.36}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 4.45}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 5.25}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.2}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 34.01}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.61}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 104.99}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 7.83}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 200.01}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.29}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 89.15}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 2.23}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 12.95}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 984.38}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 15.75}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 5.15}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 3.19}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 27.43}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 7.49}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 11.78}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 26.25}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 15.7}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 19.06}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 6.56}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 2.63}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 110.73}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 16.93}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 5.92}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.6}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 39.38}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.44}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 3.93}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 142.38}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 10.5}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 38.66}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.63}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 11.39}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 4.78}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 2.1}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 49.81}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 25.55}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.63}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 91.88}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.61}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 11.74}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 11.81}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 4.6}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 3.94}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 17.89}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 86.63}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 6.39}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 112.77}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 2.63}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1245.57}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 4.26}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 154.88}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 10.5}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 52.5}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.63}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.63}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.54}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 118.13}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 9.19}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 2.52}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 3.93}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 3.82}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 11.82}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.61}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 55.13}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 7.85}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 57.75}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 3.91}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 2.63}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 3.62}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 3.92}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 25.78}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 95.82}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 3.94}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 75.86}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 3.55}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 4.7}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 68.01}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 68.16}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 39.38}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 111.57}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 360.78}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 91.88}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 252.15}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.78}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 14.34}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 51}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.91}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 36.75}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.15}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 7.34}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 9.18}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 43.31}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 11.42}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 6.57}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 6.57}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 23.62}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 45.94}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.52}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 32.82}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 7.88}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 7.6}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 52.5}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 31.49}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 28.88}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1649}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 46.76}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 6.57}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 59.07}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 271.63}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 19.02}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 7.86}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 20.2}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 8.86}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 3.94}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 170.63}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 45.94}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 39.29}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 11.33}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.61}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 65.63}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 105}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 103.01}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1640.46}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 171.94}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 10.5}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1057.4}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 367.5}},
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