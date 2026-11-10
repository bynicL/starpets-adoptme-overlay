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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1031.83, ["Ride"] = 938.44, ["Fly|Ride"] = 1540.48, ["Neon"] = 6711.92, ["Neon|Fly|Ride"] = 3921.75, ["Mega|Fly|Ride"] = 25143.57}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 417.38, ["Fly"] = 544.79, ["Ride"] = 396.38, ["Fly|Ride"] = 471.19, ["Neon|Ride"] = 2217.26, ["Neon|Fly|Ride"] = 2072.44, ["Mega|Fly|Ride"] = 8268.06}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4725, ["Ride"] = 4935, ["Fly|Ride"] = 4379.82, ["Neon"] = 26044.19, ["Neon|Fly|Ride"] = 21741.59, ["Mega|Fly|Ride"] = 66894.32}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 118.13, ["Ride"] = 173.74, ["Fly|Ride"] = 257.29, ["Neon"] = 838.35, ["Neon|Ride"] = 802.74, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 3802.39, ["Mega|Fly|Ride"] = 2868.15}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 624.62, ["Fly"] = 662.02, ["Ride"] = 538.13, ["Fly|Ride"] = 523.69, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1527.75, ["Mega|Fly|Ride"] = 6300}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 7.83, ["Ride"] = 32.37, ["Fly|Ride"] = 141.49, ["Neon"] = 64.73, ["Neon|Fly"] = 113, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 282.02, ["Mega"] = 275.13, ["Mega|Ride"] = 471.72, ["Mega|Fly|Ride"] = 417.22}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 6.55, ["Fly"] = 28.86, ["Ride"] = 25.93, ["Fly|Ride"] = 62.95, ["Neon"] = 22.32, ["Neon|Fly"] = 107.47, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 101.38, ["Mega"] = 185.07, ["Mega|Fly"] = 278.24, ["Mega|Ride"] = 141.38, ["Mega|Fly|Ride"] = 239.23}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 124.49, ["Fly"] = 656.25, ["Ride"] = 160.77, ["Fly|Ride"] = 178.5, ["Neon"] = 488.25, ["Neon|Ride"] = 465.81, ["Neon|Fly|Ride"] = 633.74, ["Mega"] = 1918.83, ["Mega|Fly|Ride"] = 2040.63}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 35.44, ["Fly"] = 142.45, ["Ride"] = 56.42, ["Fly|Ride"] = 106.36, ["Neon"] = 238.64, ["Neon|Ride"] = 224.44, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 2100, ["Mega|Ride"] = 2730, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 23.23, ["Fly"] = 26.25, ["Ride"] = 27.56, ["Fly|Ride"] = 64.73, ["Neon"] = 139.39, ["Neon|Ride"] = 146.83, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 799.92}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 52.59, ["Fly"] = 287.2, ["Ride"] = 73.7, ["Fly|Ride"] = 127.32, ["Neon"] = 278.76, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 316.88, ["Mega|Ride"] = 1409.01, ["Mega|Fly|Ride"] = 1439.12}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 80.07}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 376.69, ["Fly"] = 387.19, ["Ride"] = 392.43, ["Fly|Ride"] = 447.3, ["Neon|Ride"] = 1689.96, ["Neon|Fly|Ride"] = 2078.97, ["Mega|Fly|Ride"] = 8449.73}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 112.91, ["Fly"] = 131.25, ["Ride"] = 105, ["Fly|Ride"] = 156.35, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 643.13, ["Mega|Fly|Ride"] = 2613.19}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.5, ["Fly"] = 117.21, ["Ride"] = 24.02, ["Fly|Ride"] = 211.18, ["Neon"] = 24.29, ["Neon|Ride"] = 59.07, ["Mega"] = 118.13, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 383.25}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 141.38, ["Fly"] = 187.95, ["Ride"] = 118.12, ["Fly|Ride"] = 189.61, ["Neon"] = 704.26, ["Neon|Ride"] = 633.51, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 1903}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.63, ["Fly"] = 25.35, ["Ride"] = 19.48, ["Fly|Ride"] = 52.41, ["Neon"] = 26.25, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 196.88, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 305.82}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 65.51, ["Fly"] = 262.5, ["Ride"] = 98.43, ["Fly|Ride"] = 239.69, ["Neon"] = 216.57, ["Neon|Ride"] = 229.68, ["Neon|Fly|Ride"] = 408.19, ["Mega"] = 1405.84, ["Mega|Ride"] = 915.5, ["Mega|Fly|Ride"] = 821.05}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 44.63}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 84, ["Ride"] = 141.49, ["Fly|Ride"] = 246.1, ["Neon"] = 830.82, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 2362.5}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 12.92, ["Fly"] = 393.75, ["Ride"] = 26.17, ["Fly|Ride"] = 105.51, ["Neon"] = 132.93, ["Neon|Ride"] = 333.73, ["Neon|Fly|Ride"] = 183.79, ["Mega"] = 2758.3, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 1689.96}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 21.12, ["Fly"] = 64.3, ["Ride"] = 43.29, ["Fly|Ride"] = 97.44, ["Neon"] = 336, ["Neon|Fly"] = 314.65, ["Neon|Ride"] = 179.37, ["Neon|Fly|Ride"] = 262.29, ["Mega"] = 1681.32, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 56.99, ["Fly"] = 105, ["Ride"] = 155.76, ["Fly|Ride"] = 139.39, ["Neon"] = 236.25, ["Neon|Fly"] = 397.94, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 315.82, ["Mega"] = 1245.29, ["Mega|Ride"] = 1263.25, ["Mega|Fly|Ride"] = 1267.47}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 39.86, ["Fly"] = 64.71, ["Ride"] = 56.99, ["Fly|Ride"] = 65.63, ["Neon"] = 181.61, ["Neon|Ride"] = 211.26, ["Neon|Fly|Ride"] = 261.95, ["Mega"] = 1207.92, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 60.5, ["Fly"] = 587.65, ["Ride"] = 78.75, ["Fly|Ride"] = 118.13, ["Neon"] = 280.01, ["Neon|Ride"] = 309.68, ["Neon|Fly|Ride"] = 217.88, ["Mega|Ride"] = 1116.86, ["Mega|Fly|Ride"] = 844.98}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 5.13, ["Fly"] = 28.52, ["Ride"] = 15.74, ["Fly|Ride"] = 39.29, ["Neon"] = 40.63, ["Neon|Fly"] = 70.86, ["Neon|Ride"] = 36.72, ["Neon|Fly|Ride"] = 100.25, ["Mega"] = 131.25, ["Mega|Fly"] = 210, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 238.87}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 295.43, ["Ride"] = 337.67, ["Fly|Ride"] = 311.49, ["Neon"] = 1475.25, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1509.38, ["Mega"] = 10562.15, ["Mega|Fly|Ride"] = 6478.84}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 16.88, ["Ride"] = 26.23, ["Fly|Ride"] = 136.49, ["Neon"] = 236.25, ["Neon|Ride"] = 160.68, ["Mega"] = 831.25, ["Mega|Ride"] = 719.57, ["Mega|Fly|Ride"] = 831.25}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 3.7, ["Fly"] = 38.53, ["Ride"] = 15.83, ["Fly|Ride"] = 39.36, ["Neon"] = 41.36, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 107, ["Mega"] = 422.5, ["Mega|Ride"] = 619.5, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 93.45, ["Fly"] = 72.19, ["Ride"] = 72.19, ["Fly|Ride"] = 157.5, ["Neon"] = 422.35, ["Neon|Ride"] = 480.38, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 1772.34, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 1831.5}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 12.68, ["Ride"] = 26.25, ["Fly|Ride"] = 115.5, ["Neon"] = 97.15, ["Neon|Ride"] = 113.03, ["Neon|Fly|Ride"] = 158.82, ["Mega"] = 422.5, ["Mega|Fly|Ride"] = 703.98}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 183.1, ["Fly"] = 352.66, ["Ride"] = 223.13, ["Fly|Ride"] = 269.07, ["Neon"] = 781.33, ["Neon|Ride"] = 823.56, ["Neon|Fly|Ride"] = 773.07, ["Mega"] = 6337.31, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2859.15}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 30.15}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.15, ["Fly"] = 35.9, ["Ride"] = 23.99, ["Fly|Ride"] = 52.5, ["Neon"] = 21, ["Neon|Fly"] = 93.51, ["Neon|Ride"] = 43.05, ["Neon|Fly|Ride"] = 150, ["Mega"] = 131.23, ["Mega|Fly"] = 286.95, ["Mega|Ride"] = 111.57, ["Mega|Fly|Ride"] = 351.75}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 1036.88, ["Fly"] = 4593.75, ["Ride"] = 984.38, ["Fly|Ride"] = 1197.33, ["Neon"] = 5114.25, ["Neon|Ride"] = 5381.25, ["Neon|Fly|Ride"] = 3937.5, ["Mega"] = 25349.17, ["Mega|Ride"] = 53966.45, ["Mega|Fly|Ride"] = 15492.58}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 6.56, ["Fly"] = 28.49, ["Ride"] = 23.34, ["Fly|Ride"] = 87.94, ["Neon"] = 107.63, ["Neon|Ride"] = 113.03, ["Neon|Fly|Ride"] = 120.42, ["Mega"] = 362.3, ["Mega|Ride"] = 618.96, ["Mega|Fly|Ride"] = 662.26}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 93.45, ["Ride"] = 139.89, ["Fly|Ride"] = 196.88, ["Neon"] = 656.25, ["Neon|Ride"] = 682.5, ["Neon|Fly|Ride"] = 721.88, ["Mega|Ride"] = 2639.49, ["Mega|Fly|Ride"] = 2465.22}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 40.11}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 20.89, ["Fly"] = 68.85, ["Ride"] = 55.13, ["Fly|Ride"] = 141.37, ["Neon"] = 91.41, ["Neon|Fly"] = 168.95, ["Neon|Ride"] = 206.07, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 682.5, ["Mega|Ride"] = 723.19, ["Mega|Fly|Ride"] = 751.94}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 3.29}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 124.69, ["Ride"] = 199.5, ["Fly|Ride"] = 262.49, ["Neon"] = 525, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 630, ["Mega|Fly|Ride"] = 2362.5}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 126.62, ["Ride"] = 174.83, ["Fly|Ride"] = 239.72, ["Neon"] = 438.38, ["Neon|Ride"] = 366.18, ["Neon|Fly|Ride"] = 496.13, ["Mega"] = 1575, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 45.94}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 63.3, ["Fly"] = 65.63, ["Ride"] = 59.07, ["Fly|Ride"] = 74.79, ["Neon"] = 359, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 304.5, ["Mega"] = 4223.82, ["Mega|Fly|Ride"] = 1267.47}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 5.92, ["Ride"] = 30.19, ["Fly|Ride"] = 159.45, ["Neon"] = 31.85, ["Neon|Ride"] = 126.63, ["Neon|Fly|Ride"] = 235.56, ["Mega"] = 154.22, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 204.75, ["Mega|Fly|Ride"] = 349.61}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 380.61, ["Fly"] = 420, ["Ride"] = 388.5, ["Fly|Ride"] = 393.75, ["Neon|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 1250.9, ["Mega|Fly|Ride"] = 4788.9}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 52.5, ["Fly"] = 99.75, ["Ride"] = 94.5, ["Fly|Ride"] = 132.57, ["Neon"] = 331.54, ["Neon|Ride"] = 338, ["Neon|Fly|Ride"] = 369.02, ["Mega"] = 2816.93, ["Mega|Ride"] = 1887.47, ["Mega|Fly|Ride"] = 1929.72}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 4219.21, ["Ride"] = 3433.5, ["Fly|Ride"] = 3018.74, ["Neon|Fly|Ride"] = 14785.97}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 39.38, ["Fly"] = 113, ["Ride"] = 56.42, ["Fly|Ride"] = 95.82, ["Neon"] = 281.93, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 379.84, ["Mega"] = 1269.59, ["Mega|Ride"] = 1266.41, ["Mega|Fly|Ride"] = 2253.98}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 65.63, ["Ride"] = 90.81, ["Fly|Ride"] = 160.62, ["Neon"] = 656.25, ["Neon|Ride"] = 792.48, ["Neon|Fly|Ride"] = 564.03, ["Mega"] = 6337.31, ["Mega|Fly|Ride"] = 1825.16}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 42.23, ["Fly"] = 69.47, ["Ride"] = 61.53, ["Fly|Ride"] = 126.87, ["Neon"] = 239.55, ["Neon|Ride"] = 193.71, ["Neon|Fly|Ride"] = 221.01, ["Mega"] = 2598.75, ["Mega|Fly|Ride"] = 712.34}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 9.09}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 47.85, ["Ride"] = 56.36, ["Fly|Ride"] = 117.1, ["Neon"] = 328.13, ["Neon|Ride"] = 479.59, ["Neon|Fly|Ride"] = 501.38, ["Mega|Ride"] = 1409.01, ["Mega|Fly|Ride"] = 1903.23}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 35.42}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 225.8, ["Fly"] = 311.49, ["Ride"] = 250.69, ["Fly|Ride"] = 337.88, ["Neon|Ride"] = 3485.52, ["Neon|Fly|Ride"] = 1594.6}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 918.75, ["Ride"] = 943.69, ["Fly|Ride"] = 853.13, ["Neon|Ride"] = 3378.68, ["Neon|Fly|Ride"] = 3648.75, ["Mega|Fly|Ride"] = 11812.5}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 3.82}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 23.63, ["Fly"] = 52.43, ["Ride"] = 42, ["Fly|Ride"] = 62.99, ["Neon"] = 162.75, ["Neon|Fly"] = 211.18, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 215.82, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 765.19}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 11.69}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5250, ["Fly"] = 5856.72, ["Ride"] = 6335, ["Fly|Ride"] = 4442.82, ["Neon|Fly|Ride"] = 10498.69, ["Mega|Fly|Ride"] = 30843.75}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 12.17, ["Fly"] = 74.62, ["Ride"] = 26.25, ["Fly|Ride"] = 69.55, ["Neon"] = 84, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 195.57, ["Mega"] = 422.5, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 584.13}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 13.55, ["Fly"] = 191.66, ["Ride"] = 32.82, ["Fly|Ride"] = 91.88, ["Neon"] = 91.88, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 231, ["Mega"] = 1067.35, ["Mega|Ride"] = 535.52, ["Mega|Fly|Ride"] = 947.44}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 141.4, ["Fly"] = 139.21, ["Ride"] = 94.96, ["Fly|Ride"] = 161.43, ["Neon"] = 1408.5, ["Neon|Fly|Ride"] = 420, ["Mega"] = 4224.87}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 10.5, ["Ride"] = 32.74, ["Fly|Ride"] = 139.65, ["Neon"] = 78.75, ["Neon|Ride"] = 91.1, ["Neon|Fly|Ride"] = 462.53, ["Mega"] = 556.64, ["Mega|Ride"] = 417.03, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 2126.25, ["Fly"] = 3095.57, ["Ride"] = 2268.66, ["Fly|Ride"] = 1968.75, ["Neon|Fly|Ride"] = 4576.48, ["Mega|Fly|Ride"] = 15079.32}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 34168.32, ["Fly"] = 35797.26, ["Ride"] = 35159.62, ["Fly|Ride"] = 22914.94, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 64611.75, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 197160.46}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 16.72, ["Fly"] = 393.75, ["Ride"] = 39.38, ["Fly|Ride"] = 91.88, ["Neon"] = 282.19, ["Neon|Ride"] = 174.57, ["Neon|Fly|Ride"] = 282.02, ["Mega"] = 843.94, ["Mega|Ride"] = 1102.5, ["Mega|Fly|Ride"] = 1397.82}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.63, ["Ride"] = 41.88, ["Fly|Ride"] = 141.49, ["Neon"] = 18.38, ["Neon|Fly"] = 134.39, ["Neon|Ride"] = 57.74, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 127.3, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 18.38}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.87, ["Ride"] = 42, ["Fly|Ride"] = 111.57, ["Neon"] = 52.63, ["Neon|Ride"] = 105.25, ["Neon|Fly|Ride"] = 463.32, ["Mega"] = 370.55, ["Mega|Ride"] = 477.75, ["Mega|Fly|Ride"] = 548.19}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 779.7, ["Ride"] = 525, ["Fly|Ride"] = 708.75, ["Neon"] = 3037.15, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2567.25, ["Mega|Fly|Ride"] = 11193.84}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 945, ["Fly"] = 962.07, ["Ride"] = 906.46, ["Fly|Ride"] = 984.38, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 3071.25}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 19.69, ["Fly"] = 119.86, ["Ride"] = 45.45, ["Fly|Ride"] = 113, ["Neon"] = 160.62, ["Neon|Ride"] = 160.06, ["Neon|Fly|Ride"] = 220.5, ["Mega"] = 982.7, ["Mega|Ride"] = 829.5, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 23.63}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 58.99, ["Fly"] = 133.05, ["Ride"] = 91.8, ["Fly|Ride"] = 86.63, ["Neon|Ride"] = 422.35, ["Neon|Fly|Ride"] = 410.82, ["Mega|Fly|Ride"] = 1598.63}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 63.31, ["Ride"] = 84, ["Fly|Ride"] = 195.39, ["Neon"] = 394.65, ["Neon|Fly"] = 394.9, ["Neon|Ride"] = 638.56, ["Neon|Fly|Ride"] = 507.01, ["Mega"] = 1625.53, ["Mega|Fly|Ride"] = 1668.83}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 2.63, ["Fly"] = 32.78, ["Ride"] = 15.74, ["Fly|Ride"] = 56.97, ["Neon"] = 28.88, ["Neon|Fly"] = 320.03, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 133.1, ["Mega"] = 236.25, ["Mega|Fly"] = 338, ["Mega|Ride"] = 401.38, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 78.72, ["Fly"] = 91.77, ["Ride"] = 85.32, ["Fly|Ride"] = 131.25, ["Neon"] = 815.12, ["Neon|Ride"] = 284.82, ["Neon|Fly|Ride"] = 308.13, ["Mega|Fly|Ride"] = 1005.5}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.68, ["Ride"] = 34.75, ["Fly|Ride"] = 262.5, ["Neon"] = 25.47, ["Neon|Ride"] = 108.77, ["Neon|Fly|Ride"] = 253.52, ["Mega"] = 159.47, ["Mega|Fly"] = 986.52, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 387.19}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 15.84, ["Fly"] = 36.98, ["Ride"] = 32.74, ["Fly|Ride"] = 105.49, ["Neon"] = 72.19, ["Neon|Fly"] = 105.59, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 141.38, ["Mega"] = 746.76, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 30.19, ["Ride"] = 69.64, ["Fly|Ride"] = 156.19, ["Neon"] = 215.25, ["Neon|Ride"] = 184.86, ["Mega|Ride"] = 1161.57, ["Mega|Fly|Ride"] = 704.51}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 15.28, ["Fly"] = 77.33, ["Ride"] = 26.23, ["Fly|Ride"] = 82.67, ["Neon"] = 103.69, ["Neon|Fly"] = 563.82, ["Neon|Ride"] = 104.54, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 930.55, ["Mega|Fly|Ride"] = 945.33}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6994.18, ["Ride"] = 6864.38, ["Fly|Ride"] = 5250, ["Neon"] = 34921.69, ["Neon|Fly|Ride"] = 24286.61}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 237.93, ["Fly"] = 293.64, ["Ride"] = 249.38, ["Fly|Ride"] = 280.88, ["Neon"] = 662.02, ["Neon|Ride"] = 654.07, ["Neon|Fly|Ride"] = 553.56, ["Mega|Fly|Ride"] = 2098.69}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 28.85, ["Fly"] = 84.49, ["Ride"] = 59.07, ["Fly|Ride"] = 99.17, ["Neon"] = 78.52, ["Neon|Fly"] = 160.62, ["Neon|Ride"] = 109.67, ["Neon|Fly|Ride"] = 195.57, ["Mega"] = 310.02, ["Mega|Fly"] = 376.69, ["Mega|Ride"] = 303.18, ["Mega|Fly|Ride"] = 400.62}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.51, ["Fly"] = 42.25, ["Ride"] = 18.38, ["Fly|Ride"] = 90.81, ["Neon"] = 21.11, ["Neon|Ride"] = 57.05, ["Neon|Fly|Ride"] = 95.93, ["Mega"] = 141.56}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 39.38, ["Fly"] = 99.26, ["Ride"] = 72.18, ["Fly|Ride"] = 150.94, ["Neon"] = 105, ["Neon|Fly"] = 295.65, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 269.36, ["Mega"] = 418.69, ["Mega|Ride"] = 449.06, ["Mega|Fly|Ride"] = 560.44}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 12810, ["Ride"] = 12468.75, ["Fly|Ride"] = 11156.24, ["Neon|Fly|Ride"] = 22312.5, ["Mega|Fly|Ride"] = 91538.98}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 140.44, ["Ride"] = 199.34, ["Fly|Ride"] = 251.3, ["Neon"] = 844.68, ["Neon|Ride"] = 1126.99, ["Neon|Fly|Ride"] = 1160.79, ["Mega|Fly|Ride"] = 7195.54}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 47.12, ["Fly"] = 459.38, ["Ride"] = 60.1, ["Fly|Ride"] = 95.9, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 309.41, ["Mega|Fly|Ride"] = 2025.83}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 9.56, ["Fly"] = 32.37, ["Ride"] = 24.24, ["Fly|Ride"] = 65.54, ["Neon"] = 74.82, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 2534.93, ["Mega|Fly|Ride"] = 546.48}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 389.82, ["Fly"] = 844.68, ["Ride"] = 431.82, ["Fly|Ride"] = 514.5, ["Neon"] = 1520.4, ["Neon|Ride"] = 1311.19, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Ride"] = 4724.98, ["Mega|Fly|Ride"] = 4935}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.18, ["Fly"] = 39.38, ["Ride"] = 28.79, ["Neon"] = 19.69, ["Neon|Ride"] = 70.79, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 114.58, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 261.95}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 195.57, ["Fly"] = 393.75, ["Ride"] = 212.06, ["Fly|Ride"] = 301.88, ["Neon"] = 771.74, ["Neon|Ride"] = 771.75, ["Neon|Fly|Ride"] = 721.88, ["Mega"] = 3273.23, ["Mega|Fly|Ride"] = 2362.5}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 7.87, ["Fly"] = 22.31, ["Ride"] = 21.11, ["Fly|Ride"] = 27.55, ["Neon|Fly"] = 141.49, ["Neon|Ride"] = 139.39, ["Neon|Fly|Ride"] = 101.58, ["Mega"] = 2534.93, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 11.61}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 57.75, ["Ride"] = 79.12, ["Fly|Ride"] = 525, ["Neon"] = 237.36, ["Neon|Fly"] = 1689.35, ["Neon|Ride"] = 422.5, ["Neon|Fly|Ride"] = 799.72, ["Mega"] = 1398.44, ["Mega|Ride"] = 1439.12, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 11.96, ["Fly"] = 62.34, ["Ride"] = 34.13, ["Fly|Ride"] = 84, ["Neon"] = 86.69, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 194.15, ["Mega"] = 500.06, ["Mega|Ride"] = 502.78, ["Mega|Fly|Ride"] = 576.71}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 15.1}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 27.43, ["Fly"] = 111.57, ["Ride"] = 78.75, ["Fly|Ride"] = 224.15, ["Neon"] = 173.15, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 273.58, ["Mega"] = 632.69, ["Mega|Ride"] = 775.27, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.76, ["Ride"] = 42.25, ["Fly|Ride"] = 131.25, ["Neon"] = 28.48, ["Neon|Ride"] = 107.89, ["Neon|Fly|Ride"] = 126.76, ["Mega"] = 112.74, ["Mega|Fly|Ride"] = 639.85}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 11.78, ["Fly"] = 70.71, ["Ride"] = 26.25, ["Fly|Ride"] = 74.82, ["Neon|Ride"] = 137.32, ["Neon|Fly|Ride"] = 226.04, ["Mega"] = 703.45, ["Mega|Ride"] = 449.96, ["Mega|Fly|Ride"] = 759.94}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 347.82, ["Fly"] = 506.81, ["Ride"] = 315, ["Fly|Ride"] = 409.5, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 7746.3}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 58.57, ["Ride"] = 56.94, ["Fly|Ride"] = 103.67, ["Neon"] = 182.44, ["Neon|Ride"] = 209.08, ["Mega"] = 703.45, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 759.43}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 45.65, ["Fly"] = 83.91, ["Ride"] = 60.38, ["Fly|Ride"] = 131.25, ["Neon"] = 160.1, ["Neon|Ride"] = 205.9, ["Neon|Fly|Ride"] = 630, ["Mega"] = 1279.62, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1155.52}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 31.2, ["Fly"] = 61.2, ["Ride"] = 74.79, ["Fly|Ride"] = 131.25, ["Neon"] = 94.5, ["Neon|Ride"] = 156.29, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 391.86, ["Mega|Ride"] = 405.57, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 9843.75, ["Ride"] = 13713.38, ["Fly|Ride"] = 7855.32, ["Neon|Fly|Ride"] = 14424.38, ["Mega|Fly|Ride"] = 39372.9}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1706.25, ["Fly"] = 2034.38, ["Ride"] = 1706.25, ["Fly|Ride"] = 1703.63, ["Neon"] = 6232.5, ["Neon|Fly|Ride"] = 4200, ["Mega|Fly|Ride"] = 23625}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 391.13, ["Ride"] = 464.16, ["Fly|Ride"] = 446.25, ["Neon"] = 2111.67, ["Neon|Fly|Ride"] = 1943.46, ["Mega"] = 11992.55, ["Mega|Fly|Ride"] = 6577.07}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 15.59, ["Fly"] = 30.61, ["Ride"] = 18.32, ["Fly|Ride"] = 41.79, ["Neon"] = 126.71, ["Neon|Ride"] = 49.66, ["Neon|Fly|Ride"] = 105, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 5.25, ["Fly"] = 39.38, ["Ride"] = 40.77, ["Fly|Ride"] = 111.56, ["Neon"] = 28.52, ["Neon|Ride"] = 70.6, ["Mega"] = 154.88, ["Mega|Ride"] = 200.82, ["Mega|Fly|Ride"] = 320.21}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 39.38, ["Fly"] = 53.81, ["Ride"] = 53.55, ["Fly|Ride"] = 78.72, ["Neon"] = 187.95, ["Neon|Ride"] = 138.44, ["Neon|Fly|Ride"] = 175.24, ["Mega|Fly|Ride"] = 559.13}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 2.61, ["Fly"] = 26.25, ["Ride"] = 17.22, ["Fly|Ride"] = 34.09, ["Neon"] = 27.57, ["Neon|Fly"] = 63.68, ["Neon|Ride"] = 42.26, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 360.94, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 295.8, ["Fly"] = 320.24, ["Ride"] = 309.51, ["Fly|Ride"] = 341.25, ["Neon|Ride"] = 1798.42, ["Neon|Fly|Ride"] = 1647.72, ["Mega|Fly|Ride"] = 7393.52}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 26.25, ["Fly"] = 48.19, ["Ride"] = 40.69, ["Fly|Ride"] = 70.75, ["Neon"] = 143.6, ["Neon|Fly"] = 168.95, ["Neon|Ride"] = 141.37, ["Neon|Fly|Ride"] = 219.72, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 10.57, ["Fly"] = 25.31, ["Ride"] = 18.36, ["Fly|Ride"] = 34.1, ["Neon"] = 57.03, ["Neon|Fly"] = 136.5, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 115.77, ["Mega"] = 528.12, ["Mega|Ride"] = 581.99, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 392.44, ["Fly"] = 787.5, ["Ride"] = 446.25, ["Fly|Ride"] = 479.43, ["Neon|Ride"] = 2745.18, ["Mega|Fly|Ride"] = 8619.19}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1123.49, ["Fly"] = 1437.61, ["Ride"] = 1173.24, ["Fly|Ride"] = 1076.25, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 17321.94}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 95.86, ["Fly"] = 109.82, ["Ride"] = 98.44, ["Fly|Ride"] = 118.13, ["Neon"] = 971.25, ["Neon|Ride"] = 416.06, ["Neon|Fly|Ride"] = 422.63, ["Mega|Fly|Ride"] = 2099.99}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 153.57, ["Fly"] = 228.51, ["Ride"] = 191.63, ["Fly|Ride"] = 224.44, ["Neon"] = 656.25, ["Neon|Fly"] = 675.75, ["Neon|Ride"] = 704.26, ["Neon|Fly|Ride"] = 683.97, ["Mega"] = 5633.86, ["Mega|Ride"] = 8596.88, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 24.92, ["Fly"] = 131.25, ["Ride"] = 41.99, ["Fly|Ride"] = 281.93, ["Neon"] = 196.88, ["Neon|Fly"] = 422.35, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 366.52, ["Mega|Ride"] = 1831.5, ["Mega|Fly|Ride"] = 895.69}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 112.91, ["Ride"] = 210.74, ["Fly|Ride"] = 597.19, ["Neon|Fly|Ride"] = 1414.76, ["Mega|Fly|Ride"] = 3001.74}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2052.74, ["Ride"] = 2483.25, ["Fly|Ride"] = 2529.78, ["Neon|Fly|Ride"] = 7180.17, ["Mega|Fly|Ride"] = 48585.9}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 56.23, ["Ride"] = 49.71, ["Fly|Ride"] = 156.16, ["Neon"] = 290.36, ["Neon|Fly"] = 295.65, ["Neon|Ride"] = 211.26, ["Neon|Fly|Ride"] = 414.75, ["Mega"] = 2106.11, ["Mega|Ride"] = 2323.69, ["Mega|Fly|Ride"] = 1918.83}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 656.24, ["Fly"] = 675.94, ["Ride"] = 601.13, ["Fly|Ride"] = 630, ["Neon|Ride"] = 1517.25, ["Neon|Fly|Ride"] = 1244.24, ["Mega|Fly|Ride"] = 2951.71}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 40.76, ["Fly"] = 52.48, ["Ride"] = 45.86, ["Fly|Ride"] = 101.07, ["Neon"] = 196.88, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 233.44, ["Mega|Fly|Ride"] = 1179.3}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.89, ["Fly"] = 37.72, ["Ride"] = 19.94, ["Fly|Ride"] = 39.35, ["Neon"] = 26.25, ["Neon|Fly"] = 54.92, ["Neon|Ride"] = 49.86, ["Neon|Fly|Ride"] = 80.01, ["Mega"] = 129.94, ["Mega|Fly"] = 251.4, ["Mega|Ride"] = 168.84, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 44.86, ["Ride"] = 52.5, ["Fly|Ride"] = 131.25, ["Neon"] = 248.07, ["Neon|Ride"] = 268.2, ["Neon|Fly|Ride"] = 535.52, ["Mega|Ride"] = 1409.01, ["Mega|Fly|Ride"] = 955.47}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 517.12, ["Fly"] = 899.07, ["Ride"] = 535.5, ["Fly|Ride"] = 581.44, ["Neon"] = 2111.67, ["Neon|Ride"] = 1771.88, ["Neon|Fly|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 5643.75}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 498.75, ["Ride"] = 525, ["Fly|Ride"] = 690.53, ["Neon"] = 5279.16, ["Neon|Ride"] = 4068.75, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 12792.46}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 18.38, ["Fly"] = 40.08, ["Ride"] = 23.39, ["Fly|Ride"] = 37.97, ["Neon"] = 211.18, ["Neon|Ride"] = 101.38, ["Neon|Fly|Ride"] = 118.13, ["Mega|Fly|Ride"] = 640.42}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 7.25, ["Ride"] = 22.32, ["Fly|Ride"] = 53.17, ["Neon"] = 45.93, ["Neon|Ride"] = 78.33, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 1685.8, ["Mega|Ride"] = 446.8, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.81, ["Ride"] = 38.27, ["Fly|Ride"] = 110.12, ["Neon"] = 19.58, ["Neon|Fly"] = 314.9, ["Neon|Ride"] = 57.74, ["Mega"] = 141.56, ["Mega|Fly"] = 447.57, ["Mega|Ride"] = 197.53, ["Mega|Fly|Ride"] = 324.28}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 48.54, ["Fly"] = 64.57, ["Ride"] = 44.6, ["Fly|Ride"] = 78.73, ["Neon"] = 239.72, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 231, ["Mega|Fly|Ride"] = 901.59}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 39.26, ["Ride"] = 111.57, ["Fly|Ride"] = 1055.84, ["Neon"] = 268.2, ["Neon|Ride"] = 407.69, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1549.49, ["Mega|Ride"] = 1549.49, ["Mega|Fly|Ride"] = 1279.62}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 19.85, ["Fly"] = 65.63, ["Ride"] = 31.42, ["Fly|Ride"] = 81.38, ["Neon"] = 110.92, ["Neon|Fly"] = 152.22, ["Neon|Ride"] = 108.87, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 422.5, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 644.31}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 30.19, ["Fly"] = 65.05, ["Ride"] = 32.74, ["Fly|Ride"] = 87.92, ["Neon"] = 408.62, ["Neon|Ride"] = 195.85, ["Neon|Fly|Ride"] = 231, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1199.27}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.52, ["Fly"] = 31.49, ["Ride"] = 17.64, ["Fly|Ride"] = 39.37, ["Neon"] = 28.6, ["Neon|Ride"] = 41.85, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 211.26, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 405.36}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.25, ["Fly"] = 44.36, ["Ride"] = 25.59, ["Fly|Ride"] = 99.26, ["Neon"] = 26.07, ["Neon|Fly"] = 160.62, ["Neon|Ride"] = 35.86, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 238.72, ["Mega|Fly"] = 479.53, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 422.5}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 47.82, ["Fly"] = 60.37, ["Ride"] = 61.2, ["Fly|Ride"] = 57.74, ["Neon"] = 581.78, ["Neon|Ride"] = 259.75, ["Neon|Fly|Ride"] = 233.44, ["Mega|Fly|Ride"] = 918.64}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1837.5, ["Fly"] = 1706.25, ["Ride"] = 1771.88, ["Fly|Ride"] = 1769.25, ["Neon|Ride"] = 5278.11, ["Neon|Fly|Ride"] = 3916.5, ["Mega|Fly|Ride"] = 13361.13}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 446.25, ["Fly"] = 704.26, ["Ride"] = 446.25, ["Fly|Ride"] = 590.63, ["Neon"] = 3196.56, ["Neon|Ride"] = 2253.98, ["Neon|Fly|Ride"] = 2493.75, ["Mega|Fly|Ride"] = 9702.4}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 242.82, ["Fly"] = 422.04, ["Ride"] = 272.99, ["Fly|Ride"] = 422.35, ["Neon"] = 1202.53, ["Neon|Ride"] = 1179.94, ["Neon|Fly|Ride"] = 1533.65, ["Mega"] = 7393.52, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 42}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 30.61, ["Fly"] = 65.63, ["Ride"] = 74.7, ["Fly|Ride"] = 112.88, ["Neon"] = 206.07, ["Neon|Ride"] = 352.31, ["Neon|Fly|Ride"] = 251.4, ["Mega|Ride"] = 945.33, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 33762.02, ["Fly"] = 23625, ["Ride"] = 34781.25, ["Fly|Ride"] = 16232.6, ["Neon|Fly|Ride"] = 38023.75, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 350.44, ["Fly"] = 420, ["Ride"] = 393.75, ["Fly|Ride"] = 459.38, ["Neon"] = 1264.9, ["Neon|Fly"] = 1115.63, ["Neon|Ride"] = 1179.94, ["Neon|Fly|Ride"] = 1076.25, ["Mega"] = 6337.31, ["Mega|Ride"] = 6715.84, ["Mega|Fly|Ride"] = 3802.39}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 128.2, ["Fly"] = 141.49, ["Ride"] = 136.49, ["Fly|Ride"] = 143.84, ["Neon|Ride"] = 844.98, ["Neon|Fly|Ride"] = 1056.23, ["Mega|Fly|Ride"] = 4224.87}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 103.68, ["Ride"] = 122.07, ["Fly|Ride"] = 205.9, ["Neon"] = 716.76, ["Neon|Ride"] = 844.98, ["Neon|Fly|Ride"] = 799.72, ["Mega"] = 14083.58, ["Mega|Fly|Ride"] = 5281.08}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 17.05, ["Fly"] = 66.53, ["Ride"] = 33.75, ["Fly|Ride"] = 98.44, ["Neon"] = 266.44, ["Neon|Ride"] = 135.19, ["Neon|Fly|Ride"] = 266.18, ["Mega"] = 704.51, ["Mega|Fly|Ride"] = 704.51}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 5260.24, ["Ride"] = 4674.18, ["Fly|Ride"] = 4060.88, ["Neon|Ride"] = 16893.31, ["Neon|Fly|Ride"] = 17603.95, ["Mega|Fly|Ride"] = 70414.68}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 21.12, ["Fly"] = 35.41, ["Ride"] = 32.31, ["Fly|Ride"] = 49.85, ["Neon"] = 333.94, ["Neon|Ride"] = 210.2, ["Neon|Fly|Ride"] = 204.24, ["Mega|Fly|Ride"] = 703.5}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 35.44, ["Fly"] = 141.37, ["Ride"] = 43.97, ["Fly|Ride"] = 102.38, ["Neon"] = 264.9, ["Neon|Fly"] = 1408.5, ["Neon|Ride"] = 141.56, ["Neon|Fly|Ride"] = 219.48, ["Mega"] = 1599.83, ["Mega|Fly|Ride"] = 1080.53}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 557.81, ["Fly"] = 603.75, ["Ride"] = 590.63, ["Fly|Ride"] = 624.75, ["Neon"] = 1706.25, ["Neon|Ride"] = 1658.1, ["Neon|Fly|Ride"] = 1459.5, ["Mega|Fly|Ride"] = 5249.99}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 15.83, ["Fly"] = 28.28, ["Ride"] = 28.49, ["Fly|Ride"] = 52.36, ["Neon"] = 98.44, ["Neon|Fly"] = 160.5, ["Neon|Ride"] = 107.61, ["Neon|Fly|Ride"] = 126.9, ["Mega"] = 775.27, ["Mega|Fly|Ride"] = 523.68}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 16.01, ["Ride"] = 78.15, ["Fly|Ride"] = 479.43, ["Neon"] = 91.88, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 408.77, ["Mega|Ride"] = 575.66}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 91.77, ["Ride"] = 84.49, ["Fly|Ride"] = 245.44, ["Neon"] = 675.75, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 704.51, ["Mega|Fly|Ride"] = 2815.88}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 22.32, ["Fly"] = 48.59, ["Ride"] = 65.63, ["Fly|Ride"] = 153.57, ["Neon"] = 85.1, ["Neon|Fly"] = 239.72, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 310.54, ["Mega"] = 292.68, ["Mega|Fly"] = 807.19, ["Mega|Ride"] = 318.61, ["Mega|Fly|Ride"] = 458.41}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3346.88, ["Ride"] = 3582.07, ["Fly|Ride"] = 3340.32, ["Neon|Ride"] = 11030.27, ["Neon|Fly|Ride"] = 8518.13, ["Mega"] = 63372.89, ["Mega|Fly|Ride"] = 33096.51}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 52.5, ["Fly"] = 115.5, ["Ride"] = 86.6, ["Fly|Ride"] = 220.4, ["Neon"] = 191.79, ["Neon|Ride"] = 282.02, ["Neon|Fly|Ride"] = 419.64, ["Mega|Ride"] = 916.81, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7218.75, ["Ride"] = 7461.58, ["Fly|Ride"] = 5775, ["Neon|Fly|Ride"] = 17519.44, ["Mega|Fly|Ride"] = 63372.89}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.1, ["Fly"] = 19.02, ["Ride"] = 17.95, ["Fly|Ride"] = 26.25, ["Neon"] = 28.88, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 85.93, ["Mega"] = 324.28, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 20.07, ["Fly"] = 26.25, ["Ride"] = 30.19, ["Fly|Ride"] = 48.47, ["Neon"] = 211.18, ["Neon|Ride"] = 559.37, ["Neon|Fly|Ride"] = 99.3, ["Mega|Ride"] = 1247.55, ["Mega|Fly|Ride"] = 927.94}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.35}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 11.81, ["Ride"] = 39.38, ["Fly|Ride"] = 57.03, ["Neon"] = 141.49, ["Neon|Ride"] = 138.37, ["Neon|Fly|Ride"] = 238.72, ["Mega"] = 1050, ["Mega|Ride"] = 984.41, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 26.25, ["Fly"] = 262.5, ["Ride"] = 51.19, ["Fly|Ride"] = 70.75, ["Neon"] = 182.43, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 280.97, ["Mega"] = 840, ["Mega|Ride"] = 959.42, ["Mega|Fly|Ride"] = 931.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 10.56, ["Fly"] = 25.99, ["Ride"] = 20.97, ["Fly|Ride"] = 34.91, ["Neon"] = 141.49, ["Neon|Ride"] = 141.38, ["Neon|Fly|Ride"] = 169.01, ["Mega"] = 2532.81, ["Mega|Ride"] = 598.44, ["Mega|Fly|Ride"] = 689.59}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8398.31}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2716.11}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 20.35}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 160.54, ["Fly"] = 174.57, ["Ride"] = 177.39, ["Fly|Ride"] = 211.18, ["Mega|Fly|Ride"] = 5596.92}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 19.69, ["Fly"] = 133.05, ["Ride"] = 39.38, ["Fly|Ride"] = 196.88, ["Neon"] = 112.88, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 264.07, ["Mega"] = 915.75, ["Mega|Ride"] = 911.45, ["Mega|Fly|Ride"] = 844.98}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 10.5}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 9.6, ["Ride"] = 26.25, ["Neon|Ride"] = 84.51, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2571.19}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 231, ["Ride"] = 172.61, ["Fly|Ride"] = 415.91, ["Neon"] = 567, ["Neon|Ride"] = 918.75, ["Mega|Ride"] = 3507.7, ["Mega|Fly|Ride"] = 3488.69}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 127.32, ["Ride"] = 157.5, ["Fly|Ride"] = 320.03, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 704.51, ["Mega|Ride"] = 2778.57, ["Mega|Fly|Ride"] = 2387.44}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 177.18, ["Fly"] = 211.18, ["Ride"] = 157.49, ["Fly|Ride"] = 210, ["Neon"] = 799.32, ["Neon|Ride"] = 840, ["Neon|Fly|Ride"] = 842.03, ["Mega"] = 4647.37, ["Mega|Fly|Ride"] = 3493.88}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1506.75, ["Fly"] = 2534.01, ["Ride"] = 1089.37, ["Fly|Ride"] = 1288.88, ["Neon"] = 5349.91, ["Neon|Ride"] = 4331.25, ["Neon|Fly|Ride"] = 4462.5, ["Mega|Fly|Ride"] = 28166.1}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 17.57, ["Fly"] = 82.1, ["Ride"] = 32.82, ["Fly|Ride"] = 86.63, ["Neon"] = 127.26, ["Neon|Ride"] = 84.51, ["Neon|Fly|Ride"] = 319.29, ["Mega"] = 843.93, ["Mega|Fly|Ride"] = 958}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 643.13, ["Fly"] = 2100, ["Ride"] = 759.84, ["Fly|Ride"] = 831.8, ["Neon|Fly|Ride"] = 2957.41}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 62.39}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 14.44, ["Ride"] = 43.32, ["Fly|Ride"] = 98.44, ["Neon"] = 99.26, ["Neon|Ride"] = 141.56, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 393.62, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 877.88}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 9.9, ["Fly"] = 131.25, ["Ride"] = 28.52, ["Fly|Ride"] = 94.5, ["Neon"] = 84.49, ["Neon|Ride"] = 83.61, ["Neon|Fly|Ride"] = 223.5, ["Mega"] = 918.75, ["Mega|Ride"] = 485.63, ["Mega|Fly|Ride"] = 606.29}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 78.73}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 21, ["Fly"] = 108.92, ["Ride"] = 35.86, ["Fly|Ride"] = 70.75, ["Neon"] = 196.88, ["Neon|Ride"] = 158.45, ["Neon|Fly|Ride"] = 607.88, ["Mega"] = 818.58, ["Mega|Fly|Ride"] = 1267.47}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 26.25, ["Fly"] = 54.92, ["Ride"] = 32.81, ["Fly|Ride"] = 61.69, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 235.56, ["Neon|Fly|Ride"] = 274.32, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 5757.94, ["Fly"] = 11253, ["Ride"] = 6438.47, ["Fly|Ride"] = 5013.75, ["Neon|Ride"] = 17315.65, ["Neon|Fly|Ride"] = 10078.69, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 9.08, ["Fly"] = 34.13, ["Ride"] = 26.25, ["Fly|Ride"] = 90.81, ["Neon"] = 65.61, ["Neon|Ride"] = 99.3, ["Neon|Fly|Ride"] = 352.33, ["Mega"] = 535.52, ["Mega|Ride"] = 438.35, ["Mega|Fly|Ride"] = 417.38}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 24.94}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 115.49, ["Fly"] = 373.78, ["Ride"] = 151.32, ["Fly|Ride"] = 233.36, ["Neon"] = 418.69, ["Neon|Ride"] = 481.69, ["Neon|Fly|Ride"] = 679.82, ["Mega|Ride"] = 4224.87, ["Mega|Fly|Ride"] = 2086.04}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 68.55, ["Ride"] = 90.57, ["Fly|Ride"] = 153.57, ["Neon"] = 327.6, ["Neon|Ride"] = 421.93, ["Neon|Fly|Ride"] = 511.88, ["Mega|Ride"] = 2850.73, ["Mega|Fly|Ride"] = 1795.59}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 20.11, ["Fly"] = 72.16, ["Ride"] = 28.3, ["Fly|Ride"] = 46.99, ["Neon"] = 196.88, ["Neon|Ride"] = 126.71, ["Neon|Fly|Ride"] = 120.6, ["Mega|Ride"] = 880.26, ["Mega|Fly|Ride"] = 656.23}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6.4, ["Fly"] = 49.76, ["Ride"] = 29.89, ["Fly|Ride"] = 78.75, ["Neon"] = 19.69, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 50.46, ["Neon|Fly|Ride"] = 165.37, ["Mega"] = 131.15, ["Mega|Fly"] = 175.35, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 263.82}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 11.92, ["Fly"] = 65.54, ["Ride"] = 23.24, ["Fly|Ride"] = 63, ["Neon"] = 91.8, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 166.05, ["Mega"] = 379.2, ["Mega|Ride"] = 410.82, ["Mega|Fly|Ride"] = 544.69}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 18.17, ["Fly"] = 28.79, ["Ride"] = 21, ["Fly|Ride"] = 47.25, ["Neon"] = 208.71, ["Neon|Ride"] = 138.96, ["Neon|Fly|Ride"] = 133.88, ["Mega|Fly|Ride"] = 689.07}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 183.75}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 19, ["Ride"] = 105, ["Fly|Ride"] = 128.26, ["Neon"] = 189.67, ["Neon|Ride"] = 422.5, ["Mega"] = 1056.23, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1687.84}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 118.13, ["Ride"] = 140.44, ["Fly|Ride"] = 262.5, ["Neon"] = 563.82, ["Neon|Ride"] = 820.32}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 37.99, ["Fly"] = 212, ["Ride"] = 103.43, ["Fly|Ride"] = 143.51, ["Neon"] = 293.03, ["Neon|Ride"] = 392.79, ["Neon|Fly|Ride"] = 420, ["Mega"] = 1148.13, ["Mega|Ride"] = 2240.22, ["Mega|Fly|Ride"] = 1097.25}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 773.07, ["Fly"] = 787.5, ["Ride"] = 727.13, ["Fly|Ride"] = 773.32, ["Neon|Fly"] = 2876.55, ["Neon|Ride"] = 3281.25, ["Neon|Fly|Ride"] = 2534.93, ["Mega|Ride"] = 8168.78, ["Mega|Fly|Ride"] = 9384.38}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 324.19, ["Ride"] = 350.44, ["Fly|Ride"] = 431.5, ["Neon"] = 1181.25, ["Neon|Ride"] = 2078.31, ["Neon|Fly|Ride"] = 1549.49, ["Mega"] = 8309.25, ["Mega|Fly|Ride"] = 8203.13}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 73.5}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.57}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 10.5, ["Fly"] = 31.5, ["Ride"] = 24.9, ["Fly|Ride"] = 39.38, ["Neon"] = 72.19, ["Neon|Fly"] = 230.99, ["Neon|Ride"] = 97.5, ["Neon|Fly|Ride"] = 126.76, ["Mega"] = 591.49, ["Mega|Ride"] = 564.03, ["Mega|Fly|Ride"] = 452.07}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 322.88, ["Fly"] = 986.16, ["Ride"] = 362.25, ["Fly|Ride"] = 439.69, ["Neon"] = 1086.75, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 844.98, ["Mega|Fly|Ride"] = 4156.22}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 18.27}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 78.75, ["Fly"] = 590.63, ["Ride"] = 177.19, ["Fly|Ride"] = 298.52, ["Neon"] = 607.6, ["Neon|Fly"] = 1689.35, ["Neon|Ride"] = 643.13, ["Neon|Fly|Ride"] = 708.75, ["Mega"] = 1929.72, ["Mega|Ride"] = 2014.22, ["Mega|Fly|Ride"] = 1995.13}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 116.82, ["Ride"] = 170.63, ["Fly|Ride"] = 291.38, ["Neon|Ride"] = 991.8}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 6.3, ["Ride"] = 28.49, ["Fly|Ride"] = 211.18, ["Neon"] = 42.25, ["Neon|Ride"] = 73.5, ["Neon|Fly|Ride"] = 177.47, ["Mega"] = 261.95, ["Mega|Ride"] = 311.28, ["Mega|Fly|Ride"] = 395.05}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 17.93, ["Fly"] = 63, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 98.98, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 252.45, ["Mega|Ride"] = 555.58, ["Mega|Fly|Ride"] = 573.9}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 21, ["Fly"] = 131.25, ["Ride"] = 61.82, ["Fly|Ride"] = 141.39, ["Neon"] = 99.75, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 420.87, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 959.42}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 6.3, ["Fly"] = 262.5, ["Ride"] = 39.37, ["Fly|Ride"] = 111.14, ["Neon"] = 26.17, ["Neon|Fly"] = 70.75, ["Neon|Ride"] = 62.25, ["Neon|Fly|Ride"] = 178.17, ["Mega"] = 123.37, ["Mega|Fly"] = 171.12, ["Mega|Ride"] = 175.88, ["Mega|Fly|Ride"] = 265.13}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 273, ["Fly"] = 918.75, ["Ride"] = 301.88, ["Fly|Ride"] = 371.65, ["Neon"] = 1548.92, ["Neon|Ride"] = 1126.99, ["Neon|Fly|Ride"] = 1424.07, ["Mega|Fly|Ride"] = 5112.1}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 116.81, ["Fly"] = 1050, ["Ride"] = 164.07, ["Fly|Ride"] = 253.2, ["Neon"] = 456.74, ["Neon|Ride"] = 459.37, ["Neon|Fly|Ride"] = 522.2, ["Mega"] = 1795.59, ["Mega|Ride"] = 1823.05, ["Mega|Fly|Ride"] = 1704.94}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 82.69, ["Fly"] = 167.45, ["Ride"] = 84.49, ["Fly|Ride"] = 128.63, ["Neon"] = 328.13, ["Neon|Ride"] = 352.79, ["Neon|Fly|Ride"] = 418.69, ["Mega|Fly|Ride"] = 1813.88}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 19.69, ["Ride"] = 58.24, ["Fly|Ride"] = 281.93, ["Neon|Ride"] = 608.88, ["Neon|Fly|Ride"] = 493.27, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 17.82, ["Fly"] = 75.62, ["Ride"] = 40.69, ["Fly|Ride"] = 102.38, ["Neon"] = 91.88, ["Neon|Ride"] = 114.05, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 450.18, ["Mega|Fly"] = 525, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.28, ["Fly"] = 19.67, ["Ride"] = 20.98, ["Fly|Ride"] = 47.83, ["Neon"] = 19.03, ["Neon|Ride"] = 48.54, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 111.62, ["Mega|Ride"] = 128.34, ["Mega|Fly|Ride"] = 278.24}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 1019.82, ["Fly"] = 1265.03, ["Ride"] = 945, ["Fly|Ride"] = 918.75, ["Neon"] = 3007.12, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2493.73, ["Mega|Fly|Ride"] = 9358.13}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 392.44, ["Ride"] = 427.9, ["Fly|Ride"] = 472.5, ["Neon"] = 1700.95, ["Neon|Ride"] = 1680, ["Neon|Fly|Ride"] = 1627.5, ["Mega"] = 10562.15, ["Mega|Fly|Ride"] = 5773.28}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 84.42, ["Ride"] = 105.52, ["Fly|Ride"] = 161.44, ["Neon"] = 282.19, ["Neon|Ride"] = 305.82, ["Neon|Fly|Ride"] = 345.37, ["Mega|Ride"] = 1423.79, ["Mega|Fly|Ride"] = 1436.47}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 262.5, ["Fly"] = 337.88, ["Ride"] = 295.07, ["Fly|Ride"] = 316.95, ["Neon|Ride"] = 1295.53, ["Neon|Fly|Ride"] = 1311.83, ["Mega"] = 10562.15, ["Mega|Fly|Ride"] = 4199.99}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 15.74, ["Fly"] = 141.49, ["Ride"] = 32.82, ["Fly|Ride"] = 78.75, ["Neon"] = 157.49, ["Neon|Ride"] = 132.57, ["Neon|Fly|Ride"] = 227.91, ["Mega"] = 1409.01, ["Mega|Ride"] = 799.92, ["Mega|Fly|Ride"] = 618.87}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 216.12, ["Ride"] = 210, ["Fly|Ride"] = 315.14, ["Neon"] = 1584.98, ["Neon|Ride"] = 1620.25, ["Neon|Fly|Ride"] = 2394.46, ["Mega"] = 4204.05, ["Mega|Fly|Ride"] = 4413.27}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 76.69, ["Fly"] = 126, ["Ride"] = 45.94, ["Fly|Ride"] = 106.42, ["Neon"] = 422.35, ["Neon|Ride"] = 504.71, ["Neon|Fly|Ride"] = 563.36, ["Mega|Fly|Ride"] = 1397.82}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1312.5, ["Ride"] = 1354.85, ["Fly|Ride"] = 1575, ["Neon"] = 4927.57, ["Neon|Fly|Ride"] = 7033.35, ["Mega"] = 50698.32, ["Mega|Fly|Ride"] = 24504.19}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 9.14, ["Fly"] = 81.81, ["Ride"] = 30.16, ["Fly|Ride"] = 88.05, ["Neon"] = 59.07, ["Neon|Fly"] = 168.95, ["Neon|Ride"] = 84.41, ["Neon|Fly|Ride"] = 141.56, ["Mega"] = 253.32, ["Mega|Ride"] = 261.19, ["Mega|Fly|Ride"] = 417.22}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 61.1, ["Fly"] = 78.75, ["Ride"] = 70.75, ["Fly|Ride"] = 161.44, ["Neon"] = 315, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 548.19, ["Mega|Ride"] = 1144.95, ["Mega|Fly|Ride"] = 1458.19}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 70.88, ["Fly"] = 91.88, ["Ride"] = 65.63, ["Fly|Ride"] = 86.62, ["Neon|Ride"] = 410.82, ["Neon|Fly|Ride"] = 367.5, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2110.14, ["Ride"] = 984.38, ["Fly|Ride"] = 1076.25, ["Neon|Fly|Ride"] = 4199.99, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 322.86, ["Fly"] = 842.57, ["Ride"] = 359, ["Fly|Ride"] = 631.4, ["Neon|Fly|Ride"] = 2112.45, ["Mega|Fly|Ride"] = 14391.06}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 95.82, ["Fly"] = 139.39, ["Ride"] = 131.24, ["Fly|Ride"] = 228.86, ["Neon"] = 591.29, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 499.02, ["Mega"] = 4224.87, ["Mega|Ride"] = 2676.47, ["Mega|Fly|Ride"] = 2079.52}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 6.22, ["Fly"] = 39.38, ["Ride"] = 20.98, ["Fly|Ride"] = 61.69, ["Neon"] = 90.46, ["Neon|Ride"] = 105.65, ["Neon|Fly|Ride"] = 233.63, ["Mega"] = 656.25, ["Mega|Ride"] = 717.36, ["Mega|Fly|Ride"] = 1026.66}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 41.15, ["Fly"] = 52.5, ["Ride"] = 47.12, ["Fly|Ride"] = 94.4, ["Neon"] = 119.86, ["Neon|Fly"] = 421.3, ["Neon|Ride"] = 225.42, ["Neon|Fly|Ride"] = 280.97, ["Mega"] = 1831.5, ["Mega|Ride"] = 1087.74, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 748.13, ["Ride"] = 872.82, ["Fly|Ride"] = 886.1, ["Neon"] = 2815.92, ["Neon|Ride"] = 2828.44, ["Neon|Fly|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 20699.15}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 882.98}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4895.5, ["Ride"] = 4608.19, ["Fly|Ride"] = 3911.25, ["Neon|Ride"] = 30272.19, ["Neon|Fly|Ride"] = 21546.79, ["Mega|Fly|Ride"] = 90131.05}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 144.38, ["Fly"] = 281.93, ["Ride"] = 224.15, ["Neon"] = 1689.35, ["Neon|Ride"] = 1056.23, ["Neon|Fly|Ride"] = 1409.01, ["Mega"] = 5914.81, ["Mega|Fly|Ride"] = 5633.86}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 83.58, ["Fly"] = 281.72, ["Ride"] = 77.44, ["Fly|Ride"] = 336, ["Neon"] = 985.32, ["Neon|Ride"] = 504.71, ["Neon|Fly|Ride"] = 986.52, ["Mega|Fly|Ride"] = 2841.23}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 9.19, ["Fly"] = 57.03, ["Ride"] = 35.01, ["Fly|Ride"] = 105, ["Neon"] = 102.38, ["Neon|Ride"] = 99.26, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 703.45, ["Mega|Ride"] = 620.01, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 18.72, ["Fly"] = 28.71, ["Ride"] = 28.61, ["Fly|Ride"] = 52.64, ["Neon|Ride"] = 141.56, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 839.7}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 19.69, ["Fly"] = 131.25, ["Ride"] = 39.38, ["Fly|Ride"] = 65.63, ["Neon"] = 126, ["Neon|Ride"] = 143.89, ["Neon|Fly|Ride"] = 226.41, ["Mega|Ride"] = 564.03, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.91, ["Fly"] = 57.03, ["Ride"] = 22.32, ["Fly|Ride"] = 38.07, ["Neon"] = 39.04, ["Neon|Ride"] = 40.43, ["Neon|Fly|Ride"] = 126.86, ["Mega"] = 695.67, ["Mega|Ride"] = 223.93, ["Mega|Fly|Ride"] = 316.88}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 31.68, ["Ride"] = 67.59, ["Fly|Ride"] = 160.62, ["Neon"] = 164.58, ["Neon|Fly"] = 844.68, ["Neon|Ride"] = 160.68, ["Neon|Fly|Ride"] = 249.29, ["Mega"] = 695.01, ["Mega|Ride"] = 704.51}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 295.54, ["Fly"] = 355.68, ["Ride"] = 287.59, ["Fly|Ride"] = 341.25, ["Neon"] = 1050, ["Neon|Fly"] = 1438.28, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 894.86, ["Mega"] = 6562.5, ["Mega|Fly|Ride"] = 3518.63}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.51, ["Fly"] = 22.97, ["Ride"] = 8.46, ["Fly|Ride"] = 36.75, ["Neon"] = 23.93, ["Neon|Ride"] = 28.23, ["Neon|Fly|Ride"] = 66.94, ["Mega"] = 157.5, ["Mega|Ride"] = 141.56, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 32.82, ["Fly"] = 101.54, ["Ride"] = 75.96, ["Fly|Ride"] = 114.09, ["Neon"] = 182.44, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 189.39, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 564.27, ["Mega|Fly"] = 844.98, ["Mega|Ride"] = 538.13, ["Mega|Fly|Ride"] = 571.36}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 708.65, ["Fly"] = 958.86, ["Ride"] = 708.75, ["Fly|Ride"] = 761.25, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1526.47, ["Mega|Fly|Ride"] = 4068.75}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 32.28, ["Fly"] = 91.88, ["Ride"] = 44.1, ["Fly|Ride"] = 91.88, ["Neon|Fly"] = 479.43, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 232.57, ["Mega"] = 1575, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 602.43}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 229.69, ["Fly"] = 342.44, ["Ride"] = 241.5, ["Fly|Ride"] = 279.57, ["Neon"] = 1245.89, ["Neon|Ride"] = 950.27, ["Neon|Fly|Ride"] = 945, ["Mega|Fly|Ride"] = 5281.08}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 151.95, ["Fly"] = 202.57, ["Ride"] = 136.17, ["Fly|Ride"] = 174.54, ["Neon"] = 633.51, ["Neon|Fly"] = 641.96, ["Neon|Ride"] = 526.87, ["Neon|Fly|Ride"] = 485.63, ["Mega|Fly|Ride"] = 2321.58}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 590.63, ["Ride"] = 606.17, ["Fly|Ride"] = 669.38, ["Neon|Fly|Ride"] = 2082.88, ["Mega|Fly|Ride"] = 7217.44}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 19, ["Ride"] = 47.18, ["Fly|Ride"] = 156.29, ["Neon"] = 104.2, ["Neon|Fly"] = 287.67, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 278.17, ["Mega"] = 353.79, ["Mega|Ride"] = 422.5, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4039.38, ["Fly"] = 3906.58, ["Ride"] = 3936.19, ["Fly|Ride"] = 3132.94, ["Neon|Fly|Ride"] = 6562.5, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 82.69, ["Fly"] = 131.25, ["Ride"] = 97.26, ["Fly|Ride"] = 131.25, ["Neon"] = 479.43, ["Neon|Ride"] = 421.3, ["Neon|Fly|Ride"] = 441.19, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.33, ["Fly"] = 33.76, ["Ride"] = 15.49, ["Fly|Ride"] = 84, ["Neon"] = 20.79, ["Neon|Fly"] = 45.05, ["Neon|Ride"] = 40.14, ["Neon|Fly|Ride"] = 113.03, ["Mega"] = 137.81, ["Mega|Fly"] = 452.82, ["Mega|Ride"] = 233.89, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 2.63, ["Ride"] = 28.28, ["Fly|Ride"] = 63, ["Neon"] = 25.35, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 161.43, ["Mega|Ride"] = 199.47, ["Mega|Fly|Ride"] = 278.2}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 53.8, ["Fly"] = 82.85, ["Ride"] = 41.94, ["Fly|Ride"] = 45.94, ["Neon|Ride"] = 211.18, ["Neon|Fly|Ride"] = 292.57, ["Mega|Fly|Ride"] = 1394.22}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 984.38, ["Ride"] = 1169.87, ["Fly|Ride"] = 1295.44, ["Neon"] = 5627.6, ["Neon|Fly|Ride"] = 5267.35, ["Mega|Fly|Ride"] = 22533.3}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 5184.37, ["Ride"] = 5992.79, ["Fly|Ride"] = 4200}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 19.85, ["Fly"] = 26.25, ["Ride"] = 24.94, ["Fly|Ride"] = 43.86, ["Neon"] = 104.54, ["Neon|Ride"] = 117.11, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 2428.13, ["Mega|Fly|Ride"] = 506.37}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 14.34, ["Fly"] = 47.75, ["Ride"] = 32.03, ["Fly|Ride"] = 79.2, ["Neon"] = 94.5, ["Neon|Fly"] = 141.49, ["Neon|Ride"] = 84.99, ["Neon|Fly|Ride"] = 175.62, ["Mega"] = 933.52, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 52.5, ["Fly"] = 157.49, ["Ride"] = 52.5, ["Fly|Ride"] = 72.19, ["Neon"] = 271.24, ["Neon|Ride"] = 312.65, ["Neon|Fly|Ride"] = 275.39, ["Mega"] = 1050, ["Mega|Ride"] = 1189.31, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 232.31, ["Fly"] = 319.88, ["Ride"] = 210, ["Fly|Ride"] = 259.28, ["Neon"] = 905.92, ["Neon|Ride"] = 976.5, ["Neon|Fly|Ride"] = 945, ["Mega"] = 10562.15, ["Mega|Fly|Ride"] = 3505.59}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.76, ["Ride"] = 26.25, ["Fly|Ride"] = 86.63, ["Neon"] = 27.23, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 84.51, ["Neon|Fly|Ride"] = 249.39, ["Mega"] = 154.88, ["Mega|Ride"] = 253.52, ["Mega|Fly|Ride"] = 374.18}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 185.72, ["Fly"] = 239.72, ["Ride"] = 223.13, ["Fly|Ride"] = 275.63, ["Neon"] = 799.44, ["Neon|Ride"] = 876.44, ["Neon|Fly|Ride"] = 828.19, ["Mega|Fly|Ride"] = 3944.97}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.14, ["Fly"] = 24.12, ["Ride"] = 17.05, ["Fly|Ride"] = 39.38, ["Neon"] = 19.69, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 28.29, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 210, ["Mega|Ride"] = 196.56, ["Mega|Fly|Ride"] = 275.45}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 196.88, ["Fly"] = 268.82, ["Ride"] = 253.32, ["Fly|Ride"] = 261.19, ["Neon|Ride"] = 1318.43, ["Neon|Fly|Ride"] = 899.22, ["Mega"] = 10562.15, ["Mega|Ride"] = 6337.31, ["Mega|Fly|Ride"] = 7795.17}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 15.64, ["Fly"] = 26.25, ["Ride"] = 21, ["Fly|Ride"] = 65.63, ["Neon"] = 84.49, ["Neon|Fly"] = 304.44, ["Neon|Ride"] = 138.37, ["Neon|Fly|Ride"] = 326.05, ["Mega"] = 522.41, ["Mega|Ride"] = 564.03, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 8.46, ["Neon|Fly"] = 66, ["Neon|Ride"] = 63.39, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 76.13, ["Mega|Ride"] = 108.05, ["Mega|Fly|Ride"] = 244.67}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.05, ["Neon|Ride"] = 28.53, ["Mega"] = 22.23, ["Mega|Ride"] = 141.52}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.83, ["Ride"] = 261.19, ["Fly|Ride"] = 141.38, ["Neon"] = 6.35, ["Neon|Ride"] = 50.7, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 89.45, ["Mega|Fly"] = 159901.35, ["Mega|Ride"] = 101.11, ["Mega|Fly|Ride"] = 184.58}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 65.35, ["Fly"] = 139.26, ["Ride"] = 111.56, ["Fly|Ride"] = 189.14, ["Neon"] = 281.93, ["Neon|Fly"] = 263.17, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 347.82, ["Mega|Fly|Ride"] = 1086.75}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 40.69, ["Ride"] = 15.89, ["Fly|Ride"] = 43.32, ["Neon"] = 3.94, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 95.1, ["Mega|Ride"] = 98.34, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 8.93, ["Ride"] = 111.09, ["Fly|Ride"] = 196.4, ["Neon"] = 74.82, ["Neon|Ride"] = 128.26, ["Neon|Fly|Ride"] = 120.42, ["Mega"] = 485.63, ["Mega|Ride"] = 523.69}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Ride"] = 30.63, ["Neon"] = 2.63, ["Neon|Ride"] = 28.48, ["Neon|Fly|Ride"] = 278.25, ["Mega"] = 15.75, ["Mega|Ride"] = 53.89, ["Mega|Fly|Ride"] = 131.15}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 15.69, ["Ride"] = 17.99, ["Fly|Ride"] = 34.55, ["Neon"] = 2.1, ["Neon|Fly"] = 35.97, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 30.29, ["Mega"] = 17.07, ["Mega|Fly"] = 30.19, ["Mega|Ride"] = 23, ["Mega|Fly|Ride"] = 52.49}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 15.62, ["Fly|Ride"] = 32.82, ["Neon"] = 3.93, ["Neon|Fly"] = 15.44, ["Neon|Ride"] = 15.86, ["Neon|Fly|Ride"] = 46.17, ["Mega"] = 28.03, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 78.73}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 21.39, ["Fly|Ride"] = 125.73, ["Neon"] = 2.1, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 39.38, ["Mega"] = 30.19, ["Mega|Ride"] = 146.95, ["Mega|Fly|Ride"] = 306.32}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 118.1, ["Ride"] = 19.69, ["Fly|Ride"] = 105.31, ["Neon"] = 3.5, ["Neon|Fly"] = 135.05, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 57.05, ["Mega|Fly"] = 85.32, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 166.9}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 6.04, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 21, ["Mega|Ride"] = 82.1}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 47.16, ["Ride"] = 21.59, ["Fly|Ride"] = 47.25, ["Neon"] = 6.02, ["Neon|Fly"] = 49.26, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 52.39, ["Mega|Fly"] = 199.1, ["Mega|Ride"] = 83.16, ["Mega|Fly|Ride"] = 108.36}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 43.25, ["Neon"] = 2.1, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 313.84, ["Mega"] = 15.1, ["Mega|Ride"] = 44.54, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly|Ride"] = 525, ["Neon"] = 47.67, ["Mega"] = 209.14, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 344.97}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Neon"] = 13.16, ["Mega"] = 105, ["Mega|Fly|Ride"] = 379.2}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Neon"] = 7.16, ["Neon|Ride"] = 37.71, ["Neon|Fly|Ride"] = 84.51, ["Mega"] = 22.32, ["Mega|Ride"] = 59.76, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 18.84, ["Fly|Ride"] = 28.6, ["Neon"] = 2.1, ["Neon|Fly"] = 42.21, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 41.88, ["Mega"] = 16.4, ["Mega|Fly"] = 53.89, ["Mega|Ride"] = 26.6, ["Mega|Fly|Ride"] = 60.38}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.84, ["Fly"] = 72.19, ["Ride"] = 42, ["Fly|Ride"] = 104.98, ["Neon"] = 32.82, ["Neon|Ride"] = 39.83, ["Mega"] = 253.52, ["Mega|Fly"] = 282.02, ["Mega|Ride"] = 274.55}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Fly"] = 28.52, ["Ride"] = 42, ["Fly|Ride"] = 78.74, ["Neon"] = 5.25, ["Neon|Ride"] = 28.53, ["Neon|Fly|Ride"] = 158.06, ["Mega"] = 34.13, ["Mega|Ride"] = 51.18, ["Mega|Fly|Ride"] = 142.49}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 4.24, ["Neon"] = 6.35, ["Neon|Fly|Ride"] = 141.56, ["Mega"] = 79.24, ["Mega|Ride"] = 132.57, ["Mega|Fly|Ride"] = 220.5}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 32.81, ["Fly|Ride"] = 192.18, ["Neon"] = 10.56, ["Neon|Ride"] = 70.79, ["Neon|Fly|Ride"] = 141.56, ["Mega"] = 92.96, ["Mega|Ride"] = 85.3, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 12.48, ["Ride"] = 12.73, ["Fly|Ride"] = 28.52, ["Neon"] = 2.1, ["Neon|Fly"] = 12.99, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 23.51, ["Mega"] = 19.69, ["Mega|Fly"] = 24.01, ["Mega|Ride"] = 24.01, ["Mega|Fly|Ride"] = 45.93}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 23.94, ["Ride"] = 18.69, ["Fly|Ride"] = 72.19, ["Neon"] = 15.61, ["Neon|Ride"] = 115.11, ["Neon|Fly|Ride"] = 70.79, ["Mega"] = 78.75, ["Mega|Fly|Ride"] = 196.77}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 6.23, ["Fly"] = 41.91, ["Ride"] = 23.24, ["Fly|Ride"] = 141.49, ["Neon"] = 78.15, ["Neon|Ride"] = 113, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 279.2, ["Mega|Ride"] = 278.07, ["Mega|Fly|Ride"] = 387.85}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 13.86, ["Ride"] = 17.85, ["Fly|Ride"] = 26.17, ["Neon"] = 2.63, ["Neon|Fly"] = 20.24, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 41.64, ["Mega"] = 70.79, ["Mega|Fly"] = 156.19, ["Mega|Fly|Ride"] = 97.9}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 176.34, ["Neon"] = 10.58, ["Neon|Fly"] = 77.53, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 59.61, ["Mega|Fly"] = 169.01, ["Mega|Ride"] = 105}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 5.25, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 28.53, ["Neon|Fly|Ride"] = 143.49, ["Mega"] = 28.53, ["Mega|Ride"] = 156.33, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 46.48, ["Neon"] = 2.1, ["Neon|Fly"] = 42.25, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 101.07, ["Mega"] = 15.23, ["Mega|Ride"] = 70.79, ["Mega|Fly|Ride"] = 124.76}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 99.18, ["Ride"] = 15.7, ["Fly|Ride"] = 41.99, ["Neon"] = 6.33, ["Neon|Fly"] = 45.09, ["Neon|Ride"] = 27.48, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 60.29, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 269.35}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 38.66, ["Neon"] = 7.66, ["Neon|Ride"] = 51.74, ["Mega"] = 62.29, ["Mega|Ride"] = 167.91, ["Mega|Fly|Ride"] = 316.88}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 32.48, ["Ride"] = 15.69, ["Fly|Ride"] = 141.49, ["Neon"] = 8.39, ["Neon|Fly"] = 108.81, ["Neon|Ride"] = 25.09, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 65.63, ["Mega|Ride"] = 90.46, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 3.94, ["Ride"] = 82.6, ["Neon"] = 30.79, ["Mega"] = 282.02, ["Mega|Fly|Ride"] = 844.98}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 16.7, ["Fly|Ride"] = 5513.37, ["Neon"] = 8.38, ["Neon|Fly"] = 141.49, ["Neon|Ride"] = 18, ["Neon|Fly|Ride"] = 141.56, ["Mega"] = 202.81, ["Mega|Ride"] = 133.1, ["Mega|Fly|Ride"] = 287.84}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 20.6, ["Ride"] = 25.51, ["Fly|Ride"] = 141.49, ["Neon"] = 20.05, ["Neon|Fly"] = 40.14, ["Neon|Ride"] = 41.21, ["Neon|Fly|Ride"] = 111.04, ["Mega"] = 115.5, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 209.98}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 79.47, ["Fly|Ride"] = 106.14, ["Neon"] = 21.13, ["Neon|Ride"] = 160.62, ["Mega"] = 200.16, ["Mega|Ride"] = 405.56}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 9.19, ["Ride"] = 78.15, ["Neon"] = 66.53, ["Neon|Ride"] = 105.65, ["Mega"] = 656.25, ["Mega|Ride"] = 883, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 8.46, ["Ride"] = 56.18, ["Neon"] = 42.25, ["Neon|Ride"] = 39.38, ["Mega"] = 224.27, ["Mega|Ride"] = 367.5}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 6.62, ["Ride"] = 42.14, ["Neon"] = 57.03, ["Neon|Ride"] = 117.11, ["Mega"] = 479.72, ["Mega|Ride"] = 255.29, ["Mega|Fly|Ride"] = 390.48}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.12, ["Neon|Ride"] = 92.53, ["Mega"] = 19.03, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 148.31}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 48.18}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 3.92, ["Fly"] = 26.86, ["Ride"] = 20.79, ["Fly|Ride"] = 41.99, ["Neon"] = 32.37, ["Neon|Ride"] = 56.58, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 262.5, ["Mega|Ride"] = 281.75, ["Mega|Fly|Ride"] = 247.17}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.36, ["Fly|Ride"] = 743.12, ["Neon"] = 3.08, ["Neon|Ride"] = 18, ["Mega"] = 1582.22, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 24.3, ["Fly|Ride"] = 140.17, ["Neon"] = 5.16, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 159.33, ["Mega"] = 43.32, ["Mega|Ride"] = 87.84, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 45.92, ["Ride"] = 16.69, ["Fly|Ride"] = 78.15, ["Neon"] = 18.4, ["Neon|Ride"] = 28.52, ["Neon|Fly|Ride"] = 97.6, ["Mega"] = 148.73, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 282.02}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 6.45, ["Neon"] = 40.69, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 156.06, ["Mega"] = 328.13, ["Mega|Ride"] = 276.74, ["Mega|Fly|Ride"] = 422.5}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 49.64, ["Neon|Fly|Ride"] = 80.34, ["Mega"] = 23.63, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 141.56, ["Mega|Fly|Ride"] = 141.56}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 17.07, ["Fly|Ride"] = 281555.24, ["Neon"] = 3.93, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 28.53, ["Neon|Fly|Ride"] = 69.56, ["Mega"] = 30.19, ["Mega|Fly"] = 203.88, ["Mega|Ride"] = 62.46, ["Mega|Fly|Ride"] = 134.15}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 15.43, ["Ride"] = 18.38, ["Fly|Ride"] = 34.04, ["Neon"] = 7.65, ["Neon|Fly"] = 70.75, ["Neon|Ride"] = 23.37, ["Neon|Fly|Ride"] = 64.58, ["Mega"] = 65.63, ["Mega|Ride"] = 48.56, ["Mega|Fly|Ride"] = 158.29}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 31.03, ["Fly|Ride"] = 79.12, ["Neon"] = 3.84, ["Neon|Ride"] = 36.74, ["Neon|Fly|Ride"] = 84.51, ["Mega"] = 18.8, ["Mega|Fly"] = 99.3, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 112.87}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 141.56, ["Mega"] = 16.96, ["Mega|Fly"] = 146.55, ["Mega|Ride"] = 77.44, ["Mega|Fly|Ride"] = 168.92}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 26.17, ["Ride"] = 19.57, ["Fly|Ride"] = 77.44, ["Neon"] = 5.25, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 21.13, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 31.23, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 114.19}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Mega"] = 14.44, ["Mega|Ride"] = 84.51, ["Mega|Fly|Ride"] = 250.04}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 160.23, ["Neon|Fly|Ride"] = 420, ["Mega"] = 23.62, ["Mega|Fly"] = 119.94, ["Mega|Ride"] = 113.03, ["Mega|Fly|Ride"] = 333.78}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 28.52, ["Ride"] = 15.74, ["Fly|Ride"] = 39.38, ["Neon"] = 3.56, ["Neon|Fly"] = 72.01, ["Neon|Ride"] = 15.86, ["Neon|Fly|Ride"] = 104.98, ["Mega"] = 78.75, ["Mega|Fly"] = 51.19, ["Mega|Ride"] = 62.33, ["Mega|Fly|Ride"] = 151.6}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 10.5, ["Ride"] = 78.75, ["Neon"] = 91.88, ["Neon|Ride"] = 239.72, ["Mega"] = 395.27, ["Mega|Ride"] = 479.72, ["Mega|Fly|Ride"] = 945.33}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 4.24, ["Fly"] = 6562.49, ["Ride"] = 38.75, ["Neon"] = 144.38, ["Mega"] = 209.14, ["Mega|Ride"] = 348.48, ["Mega|Fly|Ride"] = 422.5}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 28.41, ["Fly|Ride"] = 422.35, ["Neon"] = 13.13, ["Mega"] = 127.97, ["Mega|Ride"] = 203.88, ["Mega|Fly|Ride"] = 296.87}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 16.93, ["Ride"] = 11.82, ["Fly|Ride"] = 30.28, ["Neon"] = 2.1, ["Neon|Fly"] = 11.82, ["Neon|Ride"] = 13.2, ["Neon|Fly|Ride"] = 33.81, ["Mega"] = 14.1, ["Mega|Fly"] = 27.56, ["Mega|Ride"] = 24.27, ["Mega|Fly|Ride"] = 55.82}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly|Ride"] = 70.75, ["Neon"] = 8.46, ["Neon|Fly"] = 84.29, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 210, ["Mega"] = 66.55, ["Mega|Ride"] = 141.56}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 31.66, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 79.05, ["Mega"] = 15.64, ["Mega|Fly"] = 78.06, ["Mega|Ride"] = 51.34, ["Mega|Fly|Ride"] = 103.56}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.67, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 91.87, ["Mega"] = 15.86, ["Mega|Ride"] = 95.07, ["Mega|Fly|Ride"] = 210.2}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 24.94, ["Ride"] = 16.14, ["Fly|Ride"] = 52.8, ["Neon"] = 15.15, ["Neon|Fly"] = 65.6, ["Neon|Ride"] = 31.65, ["Neon|Fly|Ride"] = 84.4, ["Mega"] = 143.22, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 275.06}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 192.04, ["Ride"] = 181.13, ["Fly|Ride"] = 262.5, ["Neon"] = 704.26, ["Neon|Ride"] = 1119.47, ["Neon|Fly|Ride"] = 1111.15, ["Mega"] = 8449.73, ["Mega|Fly|Ride"] = 3281.25}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Fly|Ride"] = 37.17, ["Neon"] = 3.93, ["Neon|Fly"] = 56.88, ["Neon|Ride"] = 68.25, ["Mega"] = 65.42, ["Mega|Ride"] = 197.53, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.93, ["Fly"] = 103.68, ["Ride"] = 24.28, ["Fly|Ride"] = 196.88, ["Neon"] = 33.8, ["Neon|Ride"] = 168.84, ["Neon|Fly|Ride"] = 159.51, ["Mega"] = 422.5, ["Mega|Ride"] = 564.37, ["Mega|Fly|Ride"] = 631.52}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 15.28, ["Fly|Ride"] = 34.81, ["Neon"] = 5.25, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 27.26, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 65.63, ["Mega|Fly"] = 95.95, ["Mega|Ride"] = 59.7, ["Mega|Fly|Ride"] = 120.42}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Ride"] = 27.44, ["Fly|Ride"] = 120.89, ["Neon"] = 7.23, ["Neon|Fly"] = 84.49, ["Neon|Ride"] = 82.4, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 124.65, ["Mega|Ride"] = 131.25}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.52, ["Fly"] = 28.77, ["Ride"] = 18.38, ["Fly|Ride"] = 34.12, ["Neon"] = 30.19, ["Neon|Ride"] = 45.92, ["Neon|Fly|Ride"] = 91.88, ["Mega|Ride"] = 280.97, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.93, ["Fly"] = 28.52, ["Ride"] = 39.38, ["Fly|Ride"] = 247.07, ["Neon"] = 44.44, ["Neon|Ride"] = 137.45, ["Neon|Fly|Ride"] = 627.4, ["Mega"] = 327.48, ["Mega|Ride"] = 325.34, ["Mega|Fly|Ride"] = 398.35}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 14.44, ["Ride"] = 15.85, ["Fly|Ride"] = 35.9, ["Neon"] = 26.19, ["Neon|Fly"] = 79.04, ["Neon|Ride"] = 49.66, ["Neon|Fly|Ride"] = 64.58, ["Mega"] = 196.88, ["Mega|Fly"] = 384.47, ["Mega|Ride"] = 238.67, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 72.19, ["Fly"] = 91.88, ["Ride"] = 94.35, ["Fly|Ride"] = 167.74, ["Neon"] = 478.54, ["Neon|Fly"] = 405.57, ["Neon|Ride"] = 378, ["Neon|Fly|Ride"] = 420.39, ["Mega|Fly|Ride"] = 1573.69}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 196.88, ["Fly"] = 322.17, ["Ride"] = 223.13, ["Fly|Ride"] = 276.65, ["Neon"] = 915.72, ["Neon|Ride"] = 1598.88, ["Neon|Fly|Ride"] = 1599.41, ["Mega"] = 10562.15, ["Mega|Fly|Ride"] = 6544.32}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 52.5, ["Fly"] = 183.73, ["Ride"] = 59.07, ["Fly|Ride"] = 137.06, ["Neon"] = 379.25, ["Neon|Ride"] = 277.56, ["Neon|Fly|Ride"] = 375.27, ["Mega|Fly|Ride"] = 1359.42}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 2.2, ["Ride"] = 53.82, ["Fly|Ride"] = 90.81, ["Neon"] = 23, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 112.72, ["Mega"] = 157.5, ["Mega|Ride"] = 113.03, ["Mega|Fly|Ride"] = 320.21}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 15.73, ["Fly"] = 68.14, ["Ride"] = 35.44, ["Fly|Ride"] = 57.44, ["Neon"] = 125.72, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 141.56, ["Neon|Fly|Ride"] = 211.26, ["Mega"] = 353.07, ["Mega|Ride"] = 420.39, ["Mega|Fly|Ride"] = 465.81}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 20.83, ["Fly|Ride"] = 52.8, ["Neon"] = 6.04, ["Neon|Fly"] = 129.94, ["Neon|Ride"] = 28.52, ["Neon|Fly|Ride"] = 70.79, ["Mega"] = 96.03, ["Mega|Fly"] = 213.48, ["Mega|Ride"] = 111.97, ["Mega|Fly|Ride"] = 194.36}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 7.48, ["Fly"] = 68.49, ["Ride"] = 26.25, ["Fly|Ride"] = 135.19, ["Neon"] = 40.58, ["Neon|Ride"] = 158.06, ["Neon|Fly|Ride"] = 134.93, ["Mega"] = 797.46, ["Mega|Ride"] = 485, ["Mega|Fly|Ride"] = 564.03}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 30.19, ["Ride"] = 16.77, ["Fly|Ride"] = 45.94, ["Neon"] = 9.06, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 36.99, ["Neon|Fly|Ride"] = 99.49, ["Mega"] = 131.25, ["Mega|Ride"] = 181.1, ["Mega|Fly|Ride"] = 175.88}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 3.93, ["Ride"] = 26.25, ["Fly|Ride"] = 328.13, ["Neon"] = 41.93, ["Neon|Ride"] = 77.99, ["Neon|Fly|Ride"] = 239.8, ["Mega"] = 207.37, ["Mega|Ride"] = 239.87, ["Mega|Fly|Ride"] = 457.47}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 33.78, ["Neon"] = 2.1, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 47.38, ["Mega"] = 17.07, ["Mega|Ride"] = 40.15, ["Mega|Fly|Ride"] = 226.04}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 20.34, ["Ride"] = 20.9, ["Fly|Ride"] = 32.74, ["Neon"] = 13.13, ["Neon|Fly"] = 105.59, ["Neon|Ride"] = 42.26, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 108.94, ["Mega|Ride"] = 96.49, ["Mega|Fly|Ride"] = 189.67}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 24.92, ["Ride"] = 18.06, ["Fly|Ride"] = 39.29, ["Neon"] = 8.46, ["Neon|Fly"] = 141.49, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 283.5, ["Mega|Ride"] = 208.69, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 139.23, ["Fly"] = 200.82, ["Ride"] = 209.36, ["Fly|Ride"] = 268.59, ["Neon"] = 656.25, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 619.49, ["Mega|Ride"] = 3478.13, ["Mega|Fly|Ride"] = 2180.05}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 6.54, ["Ride"] = 32.82, ["Fly|Ride"] = 205.9, ["Neon"] = 45.94, ["Neon|Ride"] = 113.03, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 307.47, ["Mega|Ride"] = 352.79, ["Mega|Fly|Ride"] = 325.5}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Ride"] = 11.82, ["Fly|Ride"] = 70.21, ["Neon"] = 28.23, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 137.82, ["Mega|Ride"] = 262.65, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 25.31, ["Ride"] = 54.92, ["Fly|Ride"] = 178.5, ["Neon"] = 78.75, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 294.53, ["Mega"] = 419.88, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 2.1}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.1, ["Ride"] = 27.03, ["Neon"] = 32.71, ["Neon|Ride"] = 149.99, ["Neon|Fly|Ride"] = 633.74, ["Mega"] = 283.5, ["Mega|Ride"] = 313.69, ["Mega|Fly|Ride"] = 545.31}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 22.32, ["Fly"] = 35.88, ["Ride"] = 26.25, ["Fly|Ride"] = 49.88, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 176.18, ["Neon|Fly|Ride"] = 193.01, ["Mega"] = 2112.45, ["Mega|Ride"] = 705.17, ["Mega|Fly|Ride"] = 629.52}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 34.13, ["Fly|Ride"] = 78.75, ["Neon"] = 3.93, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 21.14, ["Mega|Ride"] = 80.43, ["Mega|Fly|Ride"] = 140.18}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 8.39, ["Fly"] = 26.25, ["Ride"] = 28.25, ["Fly|Ride"] = 62.26, ["Neon|Ride"] = 113, ["Mega"] = 265.79, ["Mega|Fly"] = 400.56, ["Mega|Ride"] = 147, ["Mega|Fly|Ride"] = 251.4}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 45.41, ["Ride"] = 16.1, ["Fly|Ride"] = 57.03, ["Neon"] = 14.97, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 72.1, ["Mega"] = 136.43, ["Mega|Ride"] = 140.33, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Neon"] = 9.61, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 31.66, ["Neon|Fly|Ride"] = 422.5, ["Mega"] = 32.4, ["Mega|Ride"] = 71.85, ["Mega|Fly|Ride"] = 104.57}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 31.49, ["Fly"] = 126.71, ["Ride"] = 52.5, ["Neon"] = 232.32, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 318.93, ["Neon|Fly|Ride"] = 221.82, ["Mega"] = 840, ["Mega|Ride"] = 774.38, ["Mega|Fly|Ride"] = 823.52}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.94, ["Ride"] = 39.38, ["Fly|Ride"] = 210, ["Neon"] = 45.55, ["Neon|Fly|Ride"] = 211.26, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 11.54, ["Fly"] = 56.9, ["Ride"] = 57.03, ["Fly|Ride"] = 134.79, ["Neon"] = 72.82, ["Neon|Fly"] = 211.18, ["Neon|Ride"] = 89.94, ["Neon|Fly|Ride"] = 160.68, ["Mega"] = 403.96, ["Mega|Ride"] = 472.61, ["Mega|Fly|Ride"] = 563.35}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 63, ["Fly"] = 141.49, ["Ride"] = 103.69, ["Fly|Ride"] = 262.44, ["Neon"] = 281.93, ["Neon|Ride"] = 316.88, ["Neon|Fly|Ride"] = 338, ["Mega|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 1436.47}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 13.12, ["Fly"] = 39.38, ["Ride"] = 35.88, ["Fly|Ride"] = 76.04, ["Neon"] = 64.32, ["Neon|Ride"] = 79.2, ["Neon|Fly|Ride"] = 211.26, ["Mega"] = 422.5, ["Mega|Ride"] = 528.12, ["Mega|Fly|Ride"] = 431.75}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 92.13, ["Fly"] = 145.69, ["Ride"] = 116.82, ["Fly|Ride"] = 168.42, ["Neon"] = 203.43, ["Neon|Ride"] = 248.07, ["Neon|Fly|Ride"] = 368.4, ["Mega"] = 986.52, ["Mega|Ride"] = 964.93, ["Mega|Fly|Ride"] = 974.88}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 26.12, ["Ride"] = 72.76, ["Fly|Ride"] = 173.25, ["Neon"] = 94.49, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 285.71, ["Mega"] = 359.14, ["Mega|Ride"] = 281.69, ["Mega|Fly|Ride"] = 435.18}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 3.83, ["Fly"] = 69.5, ["Ride"] = 18.38, ["Fly|Ride"] = 303.05, ["Neon"] = 80.76, ["Neon|Ride"] = 84.92, ["Neon|Fly|Ride"] = 126.76, ["Mega"] = 105, ["Mega|Ride"] = 1056.23, ["Mega|Fly|Ride"] = 407.76}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 13.12, ["Ride"] = 78.75, ["Fly|Ride"] = 141.38, ["Neon"] = 78.75, ["Neon|Ride"] = 160.49, ["Neon|Fly|Ride"] = 138.37, ["Mega"] = 333.31, ["Mega|Ride"] = 352.94, ["Mega|Fly|Ride"] = 532.23}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 6.89, ["Ride"] = 32.82, ["Fly|Ride"] = 139.26, ["Neon"] = 64.32, ["Neon|Ride"] = 94.7, ["Mega"] = 316.88, ["Mega|Ride"] = 422.5, ["Mega|Fly|Ride"] = 473.21}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Fly"] = 42.25, ["Neon|Ride"] = 55.95, ["Mega"] = 18.38, ["Mega|Fly"] = 141.56, ["Mega|Ride"] = 70.79, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 12.9, ["Neon|Fly"] = 126.71, ["Neon|Ride"] = 83.83, ["Mega"] = 105.42, ["Mega|Ride"] = 233.44, ["Mega|Fly|Ride"] = 455.74}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.63, ["Neon"] = 22.32, ["Neon|Ride"] = 104.57, ["Mega"] = 173.23, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 9.19, ["Ride"] = 31.44, ["Fly|Ride"] = 118.68, ["Neon"] = 17.77, ["Neon|Ride"] = 82.95, ["Neon|Fly|Ride"] = 274.63, ["Mega"] = 123.38, ["Mega|Ride"] = 152.97, ["Mega|Fly|Ride"] = 160.72}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 459.36, ["Ride"] = 524.88, ["Fly|Ride"] = 550.99, ["Neon|Ride"] = 1378.13, ["Neon|Fly|Ride"] = 1430.63, ["Mega|Fly|Ride"] = 5840.63}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 6.3, ["Fly"] = 28.49, ["Ride"] = 20.35, ["Fly|Ride"] = 42.21, ["Neon"] = 52.5, ["Neon|Ride"] = 77.6, ["Neon|Fly|Ride"] = 210, ["Mega"] = 282.02, ["Mega|Ride"] = 282.02}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 11.81, ["Fly"] = 39.38, ["Ride"] = 27.47, ["Fly|Ride"] = 84.49, ["Neon"] = 66.53, ["Neon|Fly"] = 315, ["Neon|Ride"] = 59.06, ["Mega"] = 215.25, ["Mega|Ride"] = 246.75, ["Mega|Fly|Ride"] = 291.17}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 3.92, ["Fly"] = 28.52, ["Ride"] = 22.98, ["Fly|Ride"] = 316.76, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 223.13, ["Mega|Ride"] = 640.42, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 27.07, ["Fly|Ride"] = 941.48, ["Neon"] = 10.58, ["Neon|Ride"] = 33.76, ["Neon|Fly|Ride"] = 126.76, ["Mega"] = 52.5, ["Mega|Ride"] = 91.17, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 70.75, ["Ride"] = 70.6, ["Neon"] = 3.86, ["Neon|Ride"] = 31.13, ["Mega"] = 19, ["Mega|Ride"] = 64.78}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1555.17}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 6.46, ["Ride"] = 27.46, ["Neon"] = 72.19, ["Neon|Fly"] = 141.49, ["Neon|Ride"] = 67.61, ["Mega"] = 648.54, ["Mega|Ride"] = 549.25, ["Mega|Fly|Ride"] = 564.03}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 29.7, ["Neon"] = 5.25, ["Neon|Ride"] = 39.38, ["Mega"] = 61.5, ["Mega|Ride"] = 140.27, ["Mega|Fly|Ride"] = 229.04}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.61, ["Fly"] = 98.33, ["Ride"] = 24.3, ["Fly|Ride"] = 574.38, ["Neon"] = 12.18, ["Neon|Ride"] = 63.39, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 183.73, ["Mega|Ride"] = 112.74, ["Mega|Fly|Ride"] = 282.02}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 393.75, ["Ride"] = 418.69, ["Fly|Ride"] = 458.07, ["Neon|Ride"] = 1458.19, ["Neon|Fly|Ride"] = 1806.81, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 6.45, ["Fly"] = 196.88, ["Ride"] = 72.19, ["Neon"] = 86.63, ["Neon|Ride"] = 131.25, ["Mega"] = 383.78, ["Mega|Ride"] = 278.85, ["Mega|Fly|Ride"] = 396.97}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Ride"] = 32.17, ["Neon"] = 6.57, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 110.71, ["Mega"] = 47.59, ["Mega|Fly"] = 189, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 222.76}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 844.68, ["Neon"] = 2.63, ["Neon|Ride"] = 98.28, ["Neon|Fly|Ride"] = 268.29, ["Mega"] = 22.31, ["Mega|Ride"] = 141.56, ["Mega|Fly|Ride"] = 194.36}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 11.01, ["Fly"] = 56.27, ["Ride"] = 28.52, ["Fly|Ride"] = 156.29, ["Neon"] = 91.88, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 316.53, ["Mega"] = 280.97, ["Mega|Ride"] = 339.41, ["Mega|Fly|Ride"] = 372.75}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 15.69, ["Ride"] = 109.82, ["Fly|Ride"] = 105.59, ["Neon"] = 84.49, ["Neon|Ride"] = 112.12, ["Neon|Fly|Ride"] = 838.69, ["Mega"] = 564.03, ["Mega|Ride"] = 561.92, ["Mega|Fly|Ride"] = 1086.11}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 6.02, ["Ride"] = 26.25, ["Fly|Ride"] = 99.26, ["Neon"] = 141.37, ["Neon|Ride"] = 200.82, ["Mega"] = 626.07, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 13.13, ["Ride"] = 37.17, ["Fly|Ride"] = 262.5, ["Neon"] = 160.62, ["Neon|Ride"] = 99.26, ["Neon|Fly|Ride"] = 511.87, ["Mega"] = 525, ["Mega|Ride"] = 421.45, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 384.62, ["Ride"] = 400.14, ["Fly|Ride"] = 616.88, ["Neon"] = 1408.5, ["Neon|Ride"] = 799.44, ["Neon|Fly|Ride"] = 1055.17, ["Mega|Ride"] = 3802.39, ["Mega|Fly|Ride"] = 3432.22}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 3.71, ["Fly"] = 28.3, ["Ride"] = 28.52, ["Fly|Ride"] = 84.94, ["Neon"] = 98.44, ["Neon|Ride"] = 138.44, ["Neon|Fly|Ride"] = 137.64, ["Mega"] = 525, ["Mega|Ride"] = 538.59, ["Mega|Fly|Ride"] = 718.25}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 13.06, ["Ride"] = 118.11, ["Neon"] = 28.37, ["Neon|Fly|Ride"] = 160.68, ["Mega"] = 1267.47, ["Mega|Fly|Ride"] = 1689.96}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 18.38, ["Ride"] = 60.37, ["Fly|Ride"] = 163.68, ["Neon"] = 45.93, ["Neon|Ride"] = 103.69, ["Mega"] = 217.88, ["Mega|Ride"] = 220.22, ["Mega|Fly|Ride"] = 328.28}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.51, ["Ride"] = 42, ["Fly|Ride"] = 117.21, ["Neon"] = 14.43, ["Neon|Ride"] = 45.14, ["Mega"] = 44.38, ["Mega|Ride"] = 78.74, ["Mega|Fly|Ride"] = 239.87}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 45.93, ["Ride"] = 80.12, ["Neon"] = 280.48, ["Neon|Ride"] = 295.75, ["Neon|Fly|Ride"] = 422.5, ["Mega"] = 2534.93, ["Mega|Ride"] = 1359.96, ["Mega|Fly|Ride"] = 1261.14}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.63, ["Fly"] = 599.29, ["Ride"] = 31.4, ["Neon"] = 10.18, ["Neon|Fly"] = 156.96, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 157.05, ["Mega"] = 77.44, ["Mega|Ride"] = 98.05, ["Mega|Fly|Ride"] = 221.82}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 41.74, ["Ride"] = 28.52, ["Fly|Ride"] = 99.26, ["Neon"] = 6.3, ["Neon|Fly"] = 422.35, ["Neon|Ride"] = 31.7, ["Neon|Fly|Ride"] = 91.8, ["Mega"] = 43.32, ["Mega|Ride"] = 86.62, ["Mega|Fly|Ride"] = 193.94}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 3.93, ["Ride"] = 38.06, ["Fly|Ride"] = 111.51, ["Neon"] = 28.46, ["Neon|Ride"] = 66.55, ["Neon|Fly|Ride"] = 704.51, ["Mega"] = 160.13, ["Mega|Fly"] = 633.74, ["Mega|Ride"] = 239.77, ["Mega|Fly|Ride"] = 494.82}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 70.2, ["Fly"] = 99.26, ["Ride"] = 110.25, ["Fly|Ride"] = 191.79, ["Neon"] = 485.63, ["Neon|Ride"] = 509.25, ["Mega|Ride"] = 1126.99, ["Mega|Fly|Ride"] = 1355.82}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 262.5, ["Ride"] = 288.49, ["Fly|Ride"] = 341.25, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 12674.6, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 5.16, ["Ride"] = 33.63, ["Neon"] = 40.01, ["Neon|Ride"] = 138.33, ["Mega"] = 97.13, ["Mega|Fly"] = 253.52, ["Mega|Ride"] = 185.07, ["Mega|Fly|Ride"] = 438.35}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 4.99, ["Ride"] = 36.98, ["Fly|Ride"] = 210.13, ["Neon"] = 30.63, ["Neon|Fly|Ride"] = 211.26, ["Mega"] = 91.82, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.93, ["Fly"] = 155.57, ["Ride"] = 27.57, ["Neon"] = 154.35, ["Mega"] = 517.79, ["Mega|Ride"] = 337.84}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 28.46, ["Ride"] = 28.48, ["Fly|Ride"] = 78.15, ["Neon"] = 6.17, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 90.09, ["Mega"] = 51.19, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 251.4}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 36.8, ["Fly|Ride"] = 210.68, ["Neon"] = 6.57, ["Neon|Ride"] = 52.5, ["Mega"] = 30.09, ["Mega|Fly"] = 141.56, ["Mega|Ride"] = 205.97}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 18.38, ["Fly|Ride"] = 41.93, ["Neon"] = 4.81, ["Neon|Fly"] = 47.96, ["Neon|Ride"] = 28.49, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 38.04, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 128.63}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 21.13, ["Fly|Ride"] = 63.37, ["Neon"] = 8.97, ["Neon|Fly"] = 47.96, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 91.9, ["Mega"] = 170.63, ["Mega|Ride"] = 201.75, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 28.88, ["Ride"] = 52.49, ["Fly|Ride"] = 83.65, ["Neon"] = 197.46, ["Neon|Ride"] = 160.68, ["Mega"] = 380.63, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 69.57, ["Fly"] = 582.75, ["Ride"] = 102.37, ["Fly|Ride"] = 422.35, ["Neon"] = 363.57, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 701.34, ["Mega|Ride"] = 2250.82, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 20.08, ["Fly|Ride"] = 131.25, ["Neon"] = 6.3, ["Neon|Fly"] = 78.75, ["Mega"] = 56.44, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 105.65}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 16.77, ["Ride"] = 19.02, ["Fly|Ride"] = 30.15, ["Neon"] = 3.94, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 68.16, ["Mega"] = 44.21, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 5.92, ["Ride"] = 23.99, ["Fly|Ride"] = 141.49, ["Neon"] = 35.9, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 105, ["Mega"] = 627.38, ["Mega|Ride"] = 316.88, ["Mega|Fly|Ride"] = 472.38}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 363.82, ["Fly"] = 393.75, ["Ride"] = 465.64, ["Fly|Ride"] = 314.65, ["Neon|Ride"] = 1478.18, ["Neon|Fly|Ride"] = 1583.28, ["Mega"] = 7995.45, ["Mega|Fly|Ride"] = 5281.08}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 28.23, ["Fly"] = 141.49, ["Ride"] = 65.09, ["Fly|Ride"] = 114.44, ["Neon"] = 183.75, ["Neon|Ride"] = 215.76, ["Neon|Fly|Ride"] = 217.88, ["Mega"] = 1083.69, ["Mega|Ride"] = 1161.85, ["Mega|Fly|Ride"] = 983.04}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Fly|Ride"] = 78.07, ["Neon"] = 10.5, ["Neon|Ride"] = 34.78, ["Neon|Fly|Ride"] = 141.56, ["Mega"] = 82.69, ["Mega|Ride"] = 118.53, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 211.18, ["Ride"] = 28.87, ["Fly|Ride"] = 142.7, ["Neon"] = 26.17, ["Neon|Ride"] = 168.95, ["Mega"] = 485.87}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 29.27, ["Fly"] = 78.07, ["Ride"] = 43.32, ["Fly|Ride"] = 77.44, ["Neon|Ride"] = 119.86, ["Neon|Fly|Ride"] = 422.5, ["Mega"] = 2534.93, ["Mega|Ride"] = 950.61, ["Mega|Fly|Ride"] = 1279.62}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 70.7, ["Ride"] = 98.74, ["Fly|Ride"] = 144.38, ["Neon"] = 414.86, ["Neon|Ride"] = 469.88, ["Neon|Fly|Ride"] = 479.07, ["Mega"] = 3098.95, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 211, ["Fly"] = 281.67, ["Ride"] = 246.75, ["Fly|Ride"] = 380.12, ["Neon"] = 986.16, ["Neon|Ride"] = 872.82, ["Neon|Fly|Ride"] = 915.75, ["Mega|Fly|Ride"] = 2957.41}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 17.97, ["Fly"] = 28.52, ["Ride"] = 78.15, ["Fly|Ride"] = 160.62, ["Neon"] = 112.88, ["Neon|Ride"] = 136.33, ["Neon|Fly|Ride"] = 324.28, ["Mega"] = 386.01, ["Mega|Ride"] = 408.95, ["Mega|Fly|Ride"] = 534.92}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.52, ["Ride"] = 17.38, ["Fly|Ride"] = 40.69, ["Neon"] = 7.65, ["Neon|Ride"] = 31.7, ["Neon|Fly|Ride"] = 57.05, ["Mega"] = 90.57, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.1, ["Fly"] = 33.64, ["Ride"] = 25.87, ["Fly|Ride"] = 648.3, ["Neon"] = 65.63, ["Neon|Fly"] = 21.08, ["Neon|Ride"] = 56.16, ["Neon|Fly|Ride"] = 112.56, ["Mega"] = 250.79, ["Mega|Ride"] = 232.32, ["Mega|Fly|Ride"] = 359.12}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 255.94, ["Ride"] = 315, ["Fly|Ride"] = 406.88, ["Neon"] = 2058.89, ["Neon|Ride"] = 1689.35, ["Neon|Fly|Ride"] = 1831.5, ["Mega|Fly|Ride"] = 4785.73}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 46.48, ["Neon"] = 8.39, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 41.97, ["Mega|Ride"] = 152.11, ["Mega|Fly|Ride"] = 280.97}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.82, ["Fly"] = 32.82, ["Ride"] = 20.06, ["Fly|Ride"] = 67.09, ["Neon"] = 30.87, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 170.22, ["Mega|Fly"] = 204.9, ["Mega|Ride"] = 234.49, ["Mega|Fly|Ride"] = 314.89}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 18.9, ["Ride"] = 112.68, ["Neon"] = 104.9, ["Neon|Fly"] = 422.35, ["Neon|Ride"] = 152.25, ["Mega"] = 466.48, ["Mega|Ride"] = 496.55, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 124.69, ["Fly"] = 280.66, ["Ride"] = 139.86, ["Fly|Ride"] = 196.88, ["Neon|Ride"] = 727.13, ["Neon|Fly|Ride"] = 543.24, ["Mega|Fly|Ride"] = 2929.96}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 22.09, ["Fly"] = 45.05, ["Ride"] = 28.52, ["Fly|Ride"] = 49.48, ["Neon"] = 76.13, ["Neon|Ride"] = 98.38, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 443.62, ["Mega|Ride"] = 424.55, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 26.24, ["Neon"] = 3.73, ["Neon|Ride"] = 205.03, ["Neon|Fly|Ride"] = 704.51, ["Mega"] = 20.98, ["Mega|Ride"] = 69.74, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 17.99, ["Fly|Ride"] = 52.5, ["Neon"] = 3.56, ["Neon|Fly"] = 160.62, ["Neon|Ride"] = 20.05, ["Neon|Fly|Ride"] = 69.18, ["Mega"] = 30.19, ["Mega|Fly"] = 141.96, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 103.36}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 10.5, ["Fly"] = 91.88, ["Ride"] = 61.69, ["Fly|Ride"] = 156.29, ["Neon"] = 42.25, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 153.57, ["Mega"] = 138.37, ["Mega|Fly"] = 282.02, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 279.72}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1407, ["Ride"] = 1311.19, ["Fly|Ride"] = 1299.38, ["Neon|Ride"] = 7041.8, ["Neon|Fly|Ride"] = 4218.53, ["Mega"] = 18166.91, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 408.18, ["Ride"] = 446.25, ["Fly|Ride"] = 618.19, ["Neon"] = 1903.11, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 2239.63, ["Mega"] = 14391.06, ["Mega|Fly|Ride"] = 7084.87}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 281.72, ["Fly"] = 371.44, ["Ride"] = 328.13, ["Fly|Ride"] = 419.88, ["Neon"] = 734.99, ["Neon|Fly"] = 1278.87, ["Neon|Ride"] = 577.5, ["Neon|Fly|Ride"] = 704.51, ["Mega|Fly|Ride"] = 2813.77}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 321.56, ["Ride"] = 367.5, ["Fly|Ride"] = 497.44, ["Neon"] = 1023.75, ["Neon|Fly"] = 3196.56, ["Neon|Ride"] = 1102.31, ["Neon|Fly|Ride"] = 1022.44, ["Mega|Ride"] = 3675, ["Mega|Fly|Ride"] = 3944.97}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Ride"] = 15.84, ["Fly|Ride"] = 44.63, ["Neon"] = 6.3, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 29.24, ["Neon|Fly|Ride"] = 79.24, ["Mega"] = 70.79, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 393.75, ["Fly"] = 799.44, ["Ride"] = 478.68, ["Fly|Ride"] = 570.17, ["Neon"] = 1102.5, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 6337.31, ["Mega|Fly|Ride"] = 4845.75}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.1, ["Fly"] = 183.75, ["Ride"] = 25.33, ["Neon"] = 7.87, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 112.22, ["Mega"] = 57.59, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 207.8}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 21.13, ["Ride"] = 21.13, ["Fly|Ride"] = 39.38, ["Neon"] = 14.36, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 105.51, ["Mega"] = 91.77, ["Mega|Ride"] = 192.93, ["Mega|Fly|Ride"] = 314.74}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 3.82, ["Neon|Fly"] = 80.32, ["Neon|Ride"] = 39.37, ["Mega"] = 32.81, ["Mega|Fly"] = 70.79, ["Mega|Ride"] = 52.78, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 39.29, ["Ride"] = 65.63, ["Fly|Ride"] = 459.38, ["Neon"] = 244.13, ["Neon|Ride"] = 349.44, ["Neon|Fly|Ride"] = 315.82, ["Mega"] = 1689.96, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 4.08, ["Fly"] = 65.62, ["Ride"] = 19.69, ["Fly|Ride"] = 60.43, ["Neon"] = 34.77, ["Mega"] = 328.13, ["Mega|Ride"] = 233.63}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.12, ["Neon"] = 3.93, ["Neon|Fly"] = 91.77, ["Neon|Ride"] = 36.57, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 27.48, ["Mega|Fly"] = 704.51, ["Mega|Ride"] = 91.24, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 32.44, ["Ride"] = 23.99, ["Fly|Ride"] = 57.03, ["Neon"] = 8.3, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 33.54, ["Neon|Fly|Ride"] = 70.24, ["Mega"] = 60.37, ["Mega|Fly"] = 175.14, ["Mega|Ride"] = 82.5, ["Mega|Fly|Ride"] = 168}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 6.93, ["Fly"] = 20.08, ["Ride"] = 42.14, ["Fly|Ride"] = 51.45, ["Neon"] = 104.54, ["Neon|Fly"] = 143.84, ["Neon|Ride"] = 70.75, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 237.57, ["Mega|Ride"] = 300.57, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 11.82, ["Ride"] = 40.77, ["Neon"] = 59.14, ["Neon|Ride"] = 70.75, ["Neon|Fly|Ride"] = 314.14, ["Mega"] = 352.79, ["Mega|Ride"] = 338, ["Mega|Fly|Ride"] = 345.4}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 3.92, ["Ride"] = 27.44, ["Fly|Ride"] = 70.75, ["Neon"] = 141.49, ["Neon|Ride"] = 80.01, ["Neon|Fly|Ride"] = 282.02, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 19.85, ["Ride"] = 19.69, ["Fly|Ride"] = 56.35, ["Neon"] = 3.94, ["Neon|Fly"] = 31.69, ["Neon|Ride"] = 26.25, ["Mega"] = 43.32, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 316.88}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 170.63, ["Fly"] = 366.39, ["Ride"] = 258.57, ["Fly|Ride"] = 196.88, ["Neon|Ride"] = 1146.71, ["Neon|Fly|Ride"] = 1102.5, ["Mega"] = 10562.15, ["Mega|Fly|Ride"] = 4506.88}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 23.24, ["Ride"] = 16.9, ["Fly|Ride"] = 41.97, ["Neon"] = 3.15, ["Neon|Fly"] = 19.02, ["Neon|Ride"] = 25.14, ["Neon|Fly|Ride"] = 42, ["Mega"] = 46.44, ["Mega|Ride"] = 77.59, ["Mega|Fly|Ride"] = 79.25}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 12.6, ["Ride"] = 26.25, ["Fly|Ride"] = 179.5, ["Neon"] = 49.64, ["Neon|Ride"] = 105, ["Mega"] = 328.13, ["Mega|Ride"] = 433.07, ["Mega|Fly|Ride"] = 633.74}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 38.41, ["Fly"] = 131.25, ["Ride"] = 88.51, ["Fly|Ride"] = 170.63, ["Neon"] = 253.22, ["Neon|Ride"] = 295.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 840.77, ["Mega|Ride"] = 808.54, ["Mega|Fly|Ride"] = 959.42}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 157.5, ["Ride"] = 224.44, ["Fly|Ride"] = 306.41, ["Neon"] = 799.44, ["Neon|Ride"] = 651, ["Neon|Fly|Ride"] = 656.25, ["Mega|Ride"] = 3379.9, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 19.69, ["Fly"] = 168.88, ["Neon"] = 82.69, ["Neon|Ride"] = 282.02, ["Mega"] = 285.48, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 704.51}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 32.79, ["Ride"] = 422.35, ["Fly|Ride"] = 158.81, ["Neon"] = 209.08, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 844.98, ["Mega|Fly|Ride"] = 935.82}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1287.19, ["Fly"] = 1441.13, ["Ride"] = 1115.63, ["Fly|Ride"] = 1076.25, ["Neon"] = 4082.92, ["Neon|Ride"] = 4927.57, ["Neon|Fly|Ride"] = 3871.88, ["Mega|Fly|Ride"] = 16618.49}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 5.23, ["Fly"] = 25.35, ["Ride"] = 22.05, ["Fly|Ride"] = 53.82, ["Neon"] = 64.61, ["Neon|Fly"] = 75.06, ["Neon|Ride"] = 78.17, ["Neon|Fly|Ride"] = 200.82, ["Mega"] = 223.93, ["Mega|Ride"] = 249.45, ["Mega|Fly|Ride"] = 388.5}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 7.87, ["Fly"] = 13769.7, ["Ride"] = 35.43, ["Neon"] = 40.77, ["Neon|Ride"] = 140.39, ["Mega"] = 212.63, ["Mega|Ride"] = 174.48, ["Mega|Fly|Ride"] = 422.5}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 5.24, ["Ride"] = 41.78, ["Fly|Ride"] = 91.33, ["Neon"] = 36.71, ["Neon|Ride"] = 95.93, ["Mega"] = 225.12, ["Mega|Ride"] = 380.25, ["Mega|Fly|Ride"] = 631.63}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 14.44, ["Fly"] = 704.26, ["Ride"] = 39.38, ["Fly|Ride"] = 104.04, ["Neon"] = 87.93, ["Neon|Ride"] = 98.98, ["Neon|Fly|Ride"] = 211.32, ["Mega"] = 442.75, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.1, ["Fly"] = 28.52, ["Ride"] = 24.28, ["Fly|Ride"] = 67.13, ["Neon"] = 21.77, ["Neon|Fly"] = 57.03, ["Neon|Ride"] = 45.44, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 129.94, ["Mega|Ride"] = 273.26, ["Mega|Fly|Ride"] = 263.95}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Fly"] = 416.77, ["Neon"] = 15.15, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 56.9, ["Neon|Fly|Ride"] = 141.56, ["Mega"] = 233.36, ["Mega|Ride"] = 131.14, ["Mega|Fly|Ride"] = 387.64}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 251.12, ["Ride"] = 334.69, ["Fly|Ride"] = 607.68, ["Neon|Ride"] = 986.16, ["Neon|Fly|Ride"] = 1266.41, ["Mega|Ride"] = 5250, ["Mega|Fly|Ride"] = 4900.86}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 70.75, ["Ride"] = 28.27, ["Fly|Ride"] = 59.07, ["Neon"] = 9.16, ["Neon|Fly"] = 84.49, ["Neon|Ride"] = 45.85, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 112.88, ["Mega|Ride"] = 89.25, ["Mega|Fly|Ride"] = 564.03}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 6.55, ["Ride"] = 412.84, ["Neon"] = 46.48, ["Neon|Ride"] = 313.85, ["Mega"] = 278.85, ["Mega|Ride"] = 268.29}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.93, ["Fly"] = 58.38, ["Ride"] = 40.68, ["Neon"] = 19.69, ["Neon|Fly"] = 70.75, ["Neon|Ride"] = 126.76, ["Neon|Fly|Ride"] = 280.93, ["Mega"] = 141.56, ["Mega|Fly"] = 422.5, ["Mega|Ride"] = 125.99, ["Mega|Fly|Ride"] = 275.52}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 183.72, ["Fly"] = 337.88, ["Ride"] = 295.32, ["Fly|Ride"] = 493.1, ["Neon"] = 745.43, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 948.5, ["Mega|Ride"] = 2774.69, ["Mega|Fly|Ride"] = 2165.63}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 27.54, ["Fly"] = 61.88, ["Ride"] = 41.2, ["Fly|Ride"] = 113, ["Neon"] = 153.21, ["Neon|Ride"] = 162.61, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 535.52, ["Mega|Ride"] = 633.74, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 20.96, ["Ride"] = 38.96, ["Fly|Ride"] = 1267.02, ["Neon"] = 78.75, ["Neon|Ride"] = 133.88, ["Neon|Fly|Ride"] = 257.25, ["Mega"] = 459.38, ["Mega|Ride"] = 510.28, ["Mega|Fly|Ride"] = 581.8}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.15, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.35, ["Mega"] = 30.83, ["Mega|Ride"] = 223.65, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 77.42, ["Fly"] = 117.28, ["Ride"] = 98.47, ["Fly|Ride"] = 177.16, ["Neon"] = 402.94, ["Neon|Fly"] = 471.77, ["Neon|Fly|Ride"] = 380.57, ["Mega|Fly|Ride"] = 1280.91}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 18.83, ["Neon"] = 6.57, ["Neon|Ride"] = 57.03, ["Neon|Fly|Ride"] = 588, ["Mega"] = 36.99, ["Mega|Ride"] = 169.01}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 26.23, ["Fly"] = 128.2, ["Ride"] = 31.4, ["Fly|Ride"] = 89.91, ["Neon"] = 86.6, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 141.56, ["Mega"] = 389.82, ["Mega|Ride"] = 408.19, ["Mega|Fly|Ride"] = 394.25}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 38.06, ["Fly"] = 79.92, ["Ride"] = 70.75, ["Fly|Ride"] = 179.82, ["Neon"] = 278.76, ["Neon|Ride"] = 278.67, ["Neon|Fly|Ride"] = 318.72, ["Mega|Ride"] = 1831.5, ["Mega|Fly|Ride"] = 1134}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 13.12, ["Ride"] = 16.78, ["Fly|Ride"] = 32.48, ["Neon"] = 2.1, ["Neon|Fly"] = 15.84, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 23.63, ["Mega|Fly"] = 55.13, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 66.94}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.67, ["Ride"] = 28.72, ["Fly|Ride"] = 1346.59, ["Neon"] = 23.07, ["Neon|Ride"] = 95.53, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 177.19, ["Mega|Ride"] = 211.26, ["Mega|Fly|Ride"] = 537.29}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 15.75, ["Fly"] = 141.49, ["Ride"] = 56.44, ["Neon"] = 131.25, ["Neon|Ride"] = 349.13, ["Neon|Fly|Ride"] = 479.59, ["Mega"] = 586.69, ["Mega|Ride"] = 522.84, ["Mega|Fly|Ride"] = 651}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.76, ["Neon"] = 2.63, ["Neon|Ride"] = 18, ["Neon|Fly|Ride"] = 137.32, ["Mega"] = 15.86, ["Mega|Ride"] = 65.54}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 3.62, ["Fly"] = 210, ["Ride"] = 41.89, ["Fly|Ride"] = 111.57, ["Neon"] = 71.55, ["Neon|Ride"] = 84.51, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 408.77, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 268.64, ["Mega|Fly|Ride"] = 422.5}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 23.63, ["Fly"] = 42.21, ["Ride"] = 26.17, ["Fly|Ride"] = 46.6, ["Neon"] = 129.68, ["Neon|Ride"] = 64.56, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 564.03, ["Mega|Fly|Ride"] = 1115.77}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 2.63, ["Ride"] = 59.8, ["Fly|Ride"] = 76.01, ["Neon"] = 25.68, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.44, ["Mega"] = 222.48, ["Mega|Ride"] = 192.94, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 15.73, ["Fly"] = 2111.67, ["Ride"] = 85.56, ["Neon"] = 95.9, ["Neon|Ride"] = 388.5, ["Neon|Fly|Ride"] = 6393.96, ["Mega|Ride"] = 1149.11, ["Mega|Fly|Ride"] = 1149.11}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 125.58, ["Fly|Ride"] = 196.88, ["Neon"] = 6.57, ["Neon|Fly"] = 50.7, ["Neon|Ride"] = 24.3, ["Mega"] = 74.82, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 122.54}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 28.52, ["Neon"] = 3.81, ["Neon|Ride"] = 28.52, ["Mega"] = 24.83, ["Mega|Ride"] = 154.22, ["Mega|Fly|Ride"] = 422.5}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 43.49}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 46.44, ["Fly"] = 102.38, ["Ride"] = 78.75, ["Fly|Ride"] = 117.21, ["Neon"] = 1050, ["Neon|Ride"] = 247.08, ["Neon|Fly|Ride"] = 1056.23, ["Mega"] = 986.52, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 780.93}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 84, ["Fly|Ride"] = 141.49, ["Neon"] = 3.26, ["Mega"] = 23.23, ["Mega|Fly"] = 137.82, ["Mega|Ride"] = 105.65, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 506.63, ["Ride"] = 472.49, ["Fly|Ride"] = 470.4, ["Neon"] = 2625, ["Neon|Fly|Ride"] = 2394.46, ["Mega"] = 16899.45, ["Mega|Fly|Ride"] = 14083.58}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 2.86, ["Fly"] = 25.71, ["Ride"] = 19.69, ["Fly|Ride"] = 79.2, ["Neon"] = 19.02, ["Neon|Ride"] = 278.76, ["Mega"] = 78.59, ["Mega|Ride"] = 141.56, ["Mega|Fly|Ride"] = 564.03}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.63, ["Fly"] = 160.62, ["Ride"] = 16.89, ["Fly|Ride"] = 55.13, ["Neon"] = 15.75, ["Neon|Ride"] = 35.6, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 268.29, ["Mega|Ride"] = 138.37, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 12.6, ["Ride"] = 76.13, ["Fly|Ride"] = 106.31, ["Neon"] = 111.83, ["Neon|Ride"] = 181.13, ["Mega"] = 504.89, ["Mega|Ride"] = 383.78, ["Mega|Fly|Ride"] = 528.12}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.94, ["Fly"] = 39.38, ["Ride"] = 31.5, ["Fly|Ride"] = 141.49, ["Neon"] = 42.25, ["Mega"] = 255.94}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 12.58, ["Ride"] = 42, ["Fly|Ride"] = 157.45, ["Neon"] = 77.44, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 95.93, ["Mega"] = 452.07, ["Mega|Ride"] = 464.76, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 11.63, ["Fly"] = 104.98, ["Ride"] = 48.59, ["Fly|Ride"] = 190.07, ["Neon"] = 51.19, ["Neon|Ride"] = 137.17, ["Neon|Fly|Ride"] = 141.56, ["Mega"] = 168, ["Mega|Fly"] = 490.1, ["Mega|Ride"] = 393.75}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 38.37, ["Ride"] = 15.75, ["Fly|Ride"] = 30.09, ["Neon"] = 2.1, ["Neon|Ride"] = 21.11, ["Neon|Fly|Ride"] = 64.76, ["Mega"] = 19.41, ["Mega|Fly"] = 60.78, ["Mega|Ride"] = 25.36, ["Mega|Fly|Ride"] = 145.04}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 3.94, ["Ride"] = 27.57, ["Fly|Ride"] = 160.62, ["Neon"] = 27.57, ["Neon|Fly"] = 119.86, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 316.5, ["Mega"] = 170.63, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 211.26}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 280.66, ["Ride"] = 316.5, ["Fly|Ride"] = 380.63, ["Neon"] = 1480.5, ["Neon|Ride"] = 1106.53, ["Neon|Fly|Ride"] = 986.52, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 91.88, ["Fly"] = 156.29, ["Ride"] = 149.63, ["Fly|Ride"] = 7717.5, ["Neon|Ride"] = 502.88, ["Neon|Fly|Ride"] = 623.44, ["Mega"] = 4224.87, ["Mega|Ride"] = 1732.2, ["Mega|Fly|Ride"] = 1603.88}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 23.24, ["Ride"] = 18.94, ["Fly|Ride"] = 39.38, ["Neon"] = 19.69, ["Neon|Fly"] = 28.48, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 62.67, ["Mega"] = 90.85, ["Mega|Fly"] = 210.2, ["Mega|Ride"] = 91.9, ["Mega|Fly|Ride"] = 153.08}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 18.06, ["Ride"] = 15.54, ["Fly|Ride"] = 26.25, ["Neon"] = 6.56, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 70.66, ["Mega"] = 82.22, ["Mega|Fly"] = 352.79, ["Mega|Ride"] = 104.07, ["Mega|Fly|Ride"] = 159.51}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.63, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 38.07, ["Neon|Fly|Ride"] = 422.5, ["Mega"] = 141.56, ["Mega|Ride"] = 210.2, ["Mega|Fly|Ride"] = 268.82}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 223.13, ["Ride"] = 249.38, ["Fly|Ride"] = 281.69, ["Neon|Ride"] = 944.99, ["Neon|Fly|Ride"] = 1311.83, ["Mega|Ride"] = 8449.73, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 18, ["Fly|Ride"] = 44.71, ["Neon"] = 28.88, ["Neon|Fly"] = 160.62, ["Neon|Ride"] = 43.18, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 352.79, ["Mega|Ride"] = 253.52, ["Mega|Fly|Ride"] = 262.48}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.92, ["Fly"] = 160.55, ["Ride"] = 42.25, ["Fly|Ride"] = 211.18, ["Neon"] = 34.13, ["Neon|Ride"] = 74.84, ["Mega"] = 196.88, ["Mega|Ride"] = 236.24, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.94, ["Neon|Ride"] = 29.89, ["Mega"] = 38.66, ["Mega|Ride"] = 95.7, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 11.82, ["Fly"] = 563.82, ["Ride"] = 19.69, ["Fly|Ride"] = 70.86, ["Neon"] = 141.49, ["Neon|Ride"] = 103.49, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 728.34, ["Mega|Ride"] = 190.32, ["Mega|Fly|Ride"] = 415.96}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 61.95, ["Fly"] = 114.19, ["Ride"] = 99.23, ["Fly|Ride"] = 191.79, ["Neon"] = 141.49, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 194.1, ["Neon|Fly|Ride"] = 312.38, ["Mega"] = 459.38, ["Mega|Fly"] = 2218.07, ["Mega|Ride"] = 497.44, ["Mega|Fly|Ride"] = 622.12}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 23.23, ["Fly"] = 47.96, ["Ride"] = 53.8, ["Fly|Ride"] = 84.97, ["Neon"] = 111.93, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 179.82, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 799.92, ["Mega|Fly|Ride"] = 799.92}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 17.05, ["Ride"] = 15.72, ["Fly|Ride"] = 32.45, ["Neon"] = 2.63, ["Neon|Fly"] = 15.85, ["Neon|Ride"] = 21.13, ["Neon|Fly|Ride"] = 62.33, ["Mega"] = 21.14, ["Mega|Fly"] = 36.75, ["Mega|Ride"] = 45.44, ["Mega|Fly|Ride"] = 113.03}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 204.74, ["Fly"] = 278.24, ["Ride"] = 253.25, ["Fly|Ride"] = 352.01, ["Neon"] = 1257.48, ["Neon|Ride"] = 958.13, ["Neon|Fly|Ride"] = 1267.47, ["Mega|Fly|Ride"] = 4199.99}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 11.81, ["Fly"] = 140.39, ["Ride"] = 42.2, ["Neon"] = 105, ["Neon|Ride"] = 160.62, ["Neon|Fly|Ride"] = 321.56, ["Mega"] = 564.03, ["Mega|Ride"] = 535.52, ["Mega|Fly|Ride"] = 589.32}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 16.37, ["Ride"] = 18.38, ["Fly|Ride"] = 39.3, ["Neon"] = 6.35, ["Neon|Fly"] = 27.57, ["Neon|Ride"] = 32.39, ["Neon|Fly|Ride"] = 111.97, ["Mega"] = 49.24, ["Mega|Fly"] = 180.63, ["Mega|Ride"] = 141.56, ["Mega|Fly|Ride"] = 304.63}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 28.52, ["Ride"] = 17.07, ["Fly|Ride"] = 56.9, ["Neon"] = 2.76, ["Neon|Fly"] = 47.92, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 19.03, ["Mega|Fly"] = 141.56, ["Mega|Ride"] = 52.83, ["Mega|Fly|Ride"] = 137.71}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 18.27, ["Fly|Ride"] = 91.82, ["Neon"] = 9.01, ["Neon|Ride"] = 42.26, ["Neon|Fly|Ride"] = 7041.8, ["Mega"] = 93.03, ["Mega|Fly|Ride"] = 395.05}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 12.89, ["Fly"] = 53.44, ["Ride"] = 23.89, ["Fly|Ride"] = 50.76, ["Neon"] = 42.25, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 358.59, ["Mega|Fly"] = 799.92, ["Mega|Ride"] = 315.15, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 13.02, ["Fly|Ride"] = 72.19, ["Neon"] = 39.38, ["Neon|Ride"] = 42.84, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 236.25, ["Mega|Ride"] = 323.23, ["Mega|Fly|Ride"] = 439.41}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 44.63, ["Neon"] = 2.63, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 84, ["Mega"] = 31.48, ["Mega|Ride"] = 81.37, ["Mega|Fly|Ride"] = 156.1}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 7.87, ["Ride"] = 36.98, ["Fly|Ride"] = 84.49, ["Neon"] = 24.94, ["Neon|Fly"] = 102.92, ["Neon|Ride"] = 56.88, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 157.5, ["Mega|Fly"] = 268.29, ["Mega|Ride"] = 219.72, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 126.71, ["Fly|Ride"] = 99.26, ["Neon"] = 4.47, ["Neon|Fly"] = 84.49, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 160.68, ["Mega"] = 35.02, ["Mega|Ride"] = 91.34, ["Mega|Fly|Ride"] = 640.42}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 24.6, ["Ride"] = 17.05, ["Fly|Ride"] = 65.54, ["Neon"] = 7.87, ["Neon|Ride"] = 30.24, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 39.38, ["Mega|Ride"] = 71.29, ["Mega|Fly|Ride"] = 179.41}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 665.44, ["Ride"] = 756, ["Fly|Ride"] = 695.62, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 3357.48, ["Mega|Fly|Ride"] = 12462.19}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 15.84, ["Ride"] = 19.46, ["Fly|Ride"] = 49.64, ["Neon"] = 25.33, ["Neon|Fly"] = 50.7, ["Neon|Ride"] = 28.44, ["Neon|Fly|Ride"] = 99.12, ["Mega"] = 189.08, ["Mega|Fly|Ride"] = 197.53}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 3.93, ["Ride"] = 69.57, ["Fly|Ride"] = 105.51, ["Neon"] = 10.5, ["Neon|Fly"] = 844.68, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 49.88, ["Mega|Fly"] = 141.56, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 160.72}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 6.18, ["Fly"] = 32.82, ["Ride"] = 28.2, ["Fly|Ride"] = 47.86, ["Neon"] = 53.42, ["Neon|Fly"] = 112.74, ["Neon|Ride"] = 42.25, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 311.6, ["Mega|Ride"] = 306.6, ["Mega|Fly|Ride"] = 335.99}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 16.83, ["Fly|Ride"] = 32.82, ["Neon"] = 6.19, ["Neon|Fly"] = 129.94, ["Neon|Ride"] = 24.68, ["Neon|Fly|Ride"] = 56.58, ["Mega"] = 63.31, ["Mega|Fly"] = 349.84, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 82.31, ["Ride"] = 164.73, ["Fly|Ride"] = 210.13, ["Neon"] = 291.38, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 801.68, ["Mega|Ride"] = 704.51}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 27.47, ["Fly|Ride"] = 88.7, ["Neon"] = 7.7, ["Neon|Fly"] = 136.65, ["Neon|Ride"] = 36.64, ["Neon|Fly|Ride"] = 206.07, ["Mega"] = 63.67, ["Mega|Ride"] = 137.32, ["Mega|Fly|Ride"] = 351.75}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 3.42, ["Fly"] = 73.5, ["Ride"] = 23.29, ["Fly|Ride"] = 61.25, ["Neon"] = 15.75, ["Neon|Fly"] = 143.84, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 452.07, ["Mega"] = 91.88, ["Mega|Ride"] = 269.35, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 65.76, ["Neon"] = 15.75, ["Neon|Fly"] = 64.73, ["Neon|Ride"] = 28.53, ["Mega"] = 114.09, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 2593.49, ["Ride"] = 20.96, ["Fly|Ride"] = 84.49, ["Neon"] = 4.04, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 29.89, ["Neon|Fly|Ride"] = 94.4, ["Mega"] = 50.67, ["Mega|Fly"] = 164.78, ["Mega|Ride"] = 69.74, ["Mega|Fly|Ride"] = 171.94}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 17.32, ["Fly"] = 21.11, ["Ride"] = 22.32, ["Fly|Ride"] = 43.32, ["Neon"] = 99.26, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 109.87, ["Mega"] = 844.98, ["Mega|Fly|Ride"] = 403.72}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 733.69, ["Ride"] = 735, ["Fly|Ride"] = 838.69, ["Neon"] = 1938.57, ["Neon|Ride"] = 2464.32, ["Neon|Fly|Ride"] = 1998.94, ["Mega"] = 8327.63, ["Mega|Ride"] = 7464.28, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 18.88, ["Ride"] = 17.05, ["Fly|Ride"] = 42.94, ["Neon"] = 3.92, ["Neon|Fly"] = 139.19, ["Neon|Ride"] = 17.99, ["Neon|Fly|Ride"] = 60.38, ["Mega"] = 55.13, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 126.6}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 15.73, ["Ride"] = 38.67, ["Fly|Ride"] = 92.18, ["Neon"] = 46.65, ["Neon|Fly"] = 104.54, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 248.11, ["Mega"] = 328.13, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 535.52}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 56.97, ["Ride"] = 85.32, ["Fly|Ride"] = 139.39, ["Neon"] = 378, ["Neon|Ride"] = 320.13, ["Neon|Fly|Ride"] = 1240.32, ["Mega"] = 1548.42, ["Mega|Ride"] = 1549.49, ["Mega|Fly|Ride"] = 1583.28}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 43.32, ["Ride"] = 56.31, ["Fly|Ride"] = 320.03, ["Neon"] = 197.46, ["Neon|Ride"] = 177.4, ["Neon|Fly|Ride"] = 282.02, ["Mega"] = 1958.23, ["Mega|Ride"] = 802.74, ["Mega|Fly|Ride"] = 1028.76}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 14.34, ["Ride"] = 26.25, ["Fly|Ride"] = 141.49, ["Neon"] = 83.91, ["Neon|Ride"] = 160.62, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 320.21, ["Mega|Ride"] = 366.52, ["Mega|Fly|Ride"] = 417.22}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 31.2, ["Ride"] = 95.04, ["Neon"] = 72.19, ["Neon|Fly"] = 316.43, ["Neon|Ride"] = 367.97, ["Mega"] = 456.1, ["Mega|Ride"] = 408.77, ["Mega|Fly|Ride"] = 526.98}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 18.98, ["Fly"] = 63, ["Ride"] = 76.13, ["Neon"] = 131.25, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 525, ["Mega"] = 924, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 1055.17}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 19.69}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 5.86, ["Fly"] = 131248.69, ["Ride"] = 31.42, ["Fly|Ride"] = 78.75, ["Neon"] = 36.9, ["Neon|Ride"] = 99.3, ["Neon|Fly|Ride"] = 196.47, ["Mega"] = 189, ["Mega|Fly"] = 239.87, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 276.25}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.94, ["Ride"] = 47.96, ["Neon"] = 39.38, ["Mega"] = 348.92, ["Mega|Fly|Ride"] = 950.61}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 83.57, ["Fly"] = 393.75, ["Ride"] = 84.11, ["Fly|Ride"] = 111.57, ["Neon"] = 342.35, ["Neon|Ride"] = 280.97, ["Neon|Fly|Ride"] = 353.7, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 959.05}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.63, ["Fly"] = 15.84, ["Ride"] = 16.9, ["Fly|Ride"] = 36.75, ["Neon"] = 18.9, ["Neon|Fly"] = 42.21, ["Neon|Ride"] = 23.6, ["Neon|Fly|Ride"] = 77.15, ["Mega"] = 262.5, ["Mega|Fly"] = 421.45, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 408.77}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 8.92, ["Fly"] = 84.42, ["Ride"] = 31.49, ["Fly|Ride"] = 45.94, ["Neon"] = 26.99, ["Neon|Ride"] = 54.92, ["Neon|Fly|Ride"] = 141.56, ["Mega"] = 157.05, ["Mega|Ride"] = 186.27, ["Mega|Fly|Ride"] = 252.45}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Neon|Ride"] = 90.81, ["Mega"] = 44.31, ["Mega|Ride"] = 140.38, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 26.25, ["Fly"] = 65.63, ["Ride"] = 48.57, ["Fly|Ride"] = 78.74, ["Neon"] = 190.07, ["Neon|Ride"] = 234.41, ["Neon|Fly|Ride"] = 282.02, ["Mega"] = 1126.99, ["Mega|Ride"] = 838.03, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 23.78, ["Fly|Ride"] = 84.49, ["Neon"] = 13.13, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 70.79, ["Mega"] = 112.74, ["Mega|Fly|Ride"] = 309.68}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 9.19, ["Ride"] = 53.82, ["Neon"] = 73.92, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 350.68, ["Mega"] = 288.75, ["Mega|Ride"] = 493.27, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 18.87, ["Ride"] = 16.94, ["Fly|Ride"] = 28.88, ["Neon"] = 21, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 78.07, ["Mega|Ride"] = 234.29, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 7.56, ["Fly"] = 52.5, ["Ride"] = 24.28, ["Fly|Ride"] = 52.5, ["Neon"] = 82.38, ["Neon|Ride"] = 177.19, ["Mega"] = 274.63, ["Mega|Ride"] = 247.17, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 6.57, ["Ride"] = 36.53, ["Neon"] = 28.48, ["Neon|Ride"] = 262.5, ["Mega"] = 126.6, ["Mega|Ride"] = 830.17}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 37.69, ["Ride"] = 105, ["Neon"] = 239.72, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 868.1, ["Mega|Ride"] = 1409.01, ["Mega|Fly|Ride"] = 1640.63}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 15.75, ["Ride"] = 141.49, ["Neon"] = 210, ["Mega"] = 389.82, ["Mega|Ride"] = 652.76, ["Mega|Fly|Ride"] = 498.1}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 9.19, ["Ride"] = 63.61, ["Fly|Ride"] = 281.93, ["Neon"] = 91.88, ["Mega"] = 591.49, ["Mega|Ride"] = 556.64, ["Mega|Fly|Ride"] = 1689.96}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 26.25, ["Ride"] = 70, ["Fly|Ride"] = 422.03, ["Neon"] = 94.5, ["Neon|Ride"] = 633.51, ["Neon|Fly|Ride"] = 456.3, ["Mega"] = 945, ["Mega|Ride"] = 1110.81, ["Mega|Fly|Ride"] = 1042.79}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.15, ["Neon"] = 40.69, ["Neon|Ride"] = 282.02, ["Mega"] = 309.42, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 320.21}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 17.71, ["Fly|Ride"] = 41.91, ["Neon"] = 6.04, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 25.33, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 60.38, ["Mega|Ride"] = 89.25, ["Mega|Fly|Ride"] = 184.86}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 9.19, ["Ride"] = 42, ["Fly|Ride"] = 393.75, ["Neon"] = 32.82, ["Neon|Fly"] = 70.75, ["Neon|Ride"] = 116.2, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 154.21, ["Mega|Ride"] = 233.44, ["Mega|Fly|Ride"] = 397.69}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 20.74, ["Ride"] = 17.85, ["Fly|Ride"] = 55.13, ["Neon"] = 7.88, ["Neon|Ride"] = 25.36, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 44.51, ["Mega|Ride"] = 81.29, ["Mega|Fly|Ride"] = 154.21}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Fly|Ride"] = 99.26, ["Neon"] = 39.38, ["Neon|Ride"] = 92.96, ["Neon|Fly|Ride"] = 113.03, ["Mega"] = 223.93, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 479.72}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.67, ["Ride"] = 32.74, ["Fly|Ride"] = 99.75, ["Neon"] = 39.38, ["Neon|Fly"] = 479.43, ["Neon|Ride"] = 98.59, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 416.8, ["Mega|Fly|Ride"] = 959.42}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.68, ["Fly"] = 131.25, ["Ride"] = 15.84, ["Fly|Ride"] = 141.49, ["Neon"] = 40.69, ["Neon|Fly"] = 104.77, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 105.45, ["Mega"] = 223.92, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 394.42}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 34.07, ["Ride"] = 16.53, ["Fly|Ride"] = 63.37, ["Neon"] = 20.9, ["Neon|Fly"] = 84.49, ["Neon|Ride"] = 42.26, ["Neon|Fly|Ride"] = 192.94, ["Mega"] = 141.56, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 350.68}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 6.57, ["Fly"] = 26.25, ["Ride"] = 41.2, ["Fly|Ride"] = 179.82, ["Neon"] = 25.45, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 131.25, ["Mega"] = 118.13, ["Mega|Ride"] = 152.09, ["Mega|Fly|Ride"] = 295.75}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 8.46, ["Fly"] = 105, ["Ride"] = 98.44, ["Fly|Ride"] = 191.79, ["Neon"] = 85.32, ["Neon|Ride"] = 179.21, ["Neon|Fly|Ride"] = 578.82, ["Mega"] = 385.88, ["Mega|Fly"] = 669.38, ["Mega|Ride"] = 440.9, ["Mega|Fly|Ride"] = 570.81}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 62.99, ["Fly"] = 239.72, ["Ride"] = 97.13, ["Fly|Ride"] = 211.32, ["Neon"] = 307.39, ["Neon|Ride"] = 269.07, ["Neon|Fly|Ride"] = 392.61, ["Mega"] = 1050, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1024.8}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 51.01, ["Ride"] = 25.18, ["Fly|Ride"] = 65.54, ["Neon"] = 2.63, ["Neon|Ride"] = 37.95, ["Mega"] = 29.77, ["Mega|Ride"] = 71.14, ["Mega|Fly|Ride"] = 131.15}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 16.96, ["Neon"] = 281.59, ["Neon|Ride"] = 199.31, ["Mega"] = 859.04, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 1267.47}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 40.68, ["Fly"] = 105, ["Ride"] = 116.82, ["Neon"] = 223.85, ["Neon|Ride"] = 304.54, ["Neon|Fly|Ride"] = 507.01, ["Mega"] = 1723.75, ["Mega|Ride"] = 1113.27, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 30.16, ["Fly"] = 190.32, ["Ride"] = 43.17, ["Fly|Ride"] = 126, ["Neon"] = 40.58, ["Neon|Ride"] = 52.48, ["Neon|Fly|Ride"] = 211.26, ["Mega"] = 282.02, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 465.81}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Fly"] = 157.5, ["Ride"] = 19.69, ["Fly|Ride"] = 104.54, ["Neon"] = 3.93, ["Neon|Ride"] = 32.39, ["Mega"] = 24.94, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 60.38, ["Mega|Fly|Ride"] = 126}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 20.69, ["Fly|Ride"] = 52.97, ["Neon"] = 15.81, ["Neon|Ride"] = 32.37, ["Neon|Fly|Ride"] = 105, ["Mega"] = 297.43, ["Mega|Fly"] = 352.79, ["Mega|Ride"] = 233.44, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 19.02, ["Ride"] = 18.38, ["Fly|Ride"] = 35.44, ["Neon"] = 2.5, ["Neon|Fly"] = 21, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 34.13, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Fly"] = 42.25, ["Ride"] = 26.25, ["Fly|Ride"] = 65.7, ["Neon"] = 3.91, ["Neon|Ride"] = 36.98, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 43.98, ["Mega|Fly"] = 168, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 241.84}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.48, ["Fly|Ride"] = 160.62, ["Neon"] = 2.63, ["Neon|Ride"] = 126.27, ["Mega"] = 27.45, ["Mega|Ride"] = 104.87, ["Mega|Fly|Ride"] = 264.07}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 3.92, ["Ride"] = 31.66, ["Fly|Ride"] = 262.5, ["Neon"] = 57.03, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 209.14, ["Mega"] = 201.75, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 10.5, ["Ride"] = 30.19, ["Fly|Ride"] = 84.49, ["Neon"] = 124.69, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 238.6, ["Mega"] = 360.94, ["Mega|Fly|Ride"] = 642.81}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 5.2, ["Fly"] = 33.76, ["Ride"] = 15.8, ["Fly|Ride"] = 42, ["Neon"] = 42.25, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 57.7, ["Neon|Fly|Ride"] = 86.6, ["Mega|Ride"] = 334.69, ["Mega|Fly|Ride"] = 325.5}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 74.64, ["Ride"] = 144.37, ["Fly|Ride"] = 262.5, ["Neon"] = 538.13, ["Neon|Ride"] = 597.19, ["Mega"] = 3198.42, ["Mega|Fly|Ride"] = 1633.97}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 25.87, ["Fly"] = 72.44, ["Ride"] = 65.63, ["Fly|Ride"] = 72.19, ["Neon"] = 103.69, ["Mega"] = 633.29, ["Mega|Ride"] = 282.02, ["Mega|Fly|Ride"] = 1280.36}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 17.93, ["Ride"] = 17.84, ["Fly|Ride"] = 36.74, ["Neon"] = 3.56, ["Neon|Fly"] = 28.52, ["Neon|Ride"] = 19, ["Neon|Fly|Ride"] = 55.17, ["Mega"] = 36.11, ["Mega|Ride"] = 113.03, ["Mega|Fly|Ride"] = 108.94}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 15.84, ["Ride"] = 18.93, ["Fly|Ride"] = 28.52, ["Neon"] = 4.15, ["Neon|Fly"] = 23.5, ["Neon|Ride"] = 20.01, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 51.1, ["Mega|Ride"] = 61.28, ["Mega|Fly|Ride"] = 104.41}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 393.74, ["Ride"] = 434.44, ["Fly|Ride"] = 449.13, ["Neon|Ride"] = 1878.15, ["Neon|Fly|Ride"] = 1509.38}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 14.44, ["Fly|Ride"] = 241.78, ["Neon"] = 91.88, ["Mega"] = 380.25, ["Mega|Ride"] = 606.29, ["Mega|Fly|Ride"] = 1267.47}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 19.02, ["Ride"] = 18.38, ["Fly|Ride"] = 39.38, ["Neon"] = 6.14, ["Neon|Fly"] = 70.75, ["Neon|Ride"] = 20.74, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 54.94, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 118.27}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 84.12, ["Ride"] = 98.44, ["Fly|Ride"] = 511.88, ["Neon"] = 261.19, ["Neon|Ride"] = 304.48, ["Neon|Fly|Ride"] = 422.09, ["Mega"] = 737.63, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 934.5}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 23.24, ["Ride"] = 17.03, ["Fly|Ride"] = 39.38, ["Neon"] = 13.13, ["Neon|Fly"] = 47.76, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 59.06, ["Mega"] = 111.97, ["Mega|Fly"] = 160.72, ["Mega|Ride"] = 101.42, ["Mega|Fly|Ride"] = 183.09}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 70.75, ["Ride"] = 19, ["Fly|Ride"] = 1312.5, ["Neon"] = 3.93, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 19.03, ["Mega|Fly"] = 141.56, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 182.44}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 58.61, ["Fly"] = 141.27, ["Ride"] = 91.88, ["Fly|Ride"] = 244.52, ["Neon"] = 245.2, ["Neon|Ride"] = 253.45, ["Neon|Fly|Ride"] = 383.25, ["Mega"] = 790.97, ["Mega|Ride"] = 629.94, ["Mega|Fly|Ride"] = 835.34}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Neon"] = 6.34, ["Neon|Ride"] = 54.92, ["Neon|Fly|Ride"] = 126.76, ["Mega"] = 98.54, ["Mega|Ride"] = 121.64, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 35.69, ["Ride"] = 56.6, ["Neon"] = 147, ["Neon|Ride"] = 158.45, ["Neon|Fly|Ride"] = 316.88, ["Mega"] = 1034.06, ["Mega|Ride"] = 1689.96, ["Mega|Fly|Ride"] = 1056.23}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.82, ["Ride"] = 45.02, ["Fly|Ride"] = 211.18, ["Neon"] = 23.63, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 422.5, ["Mega"] = 175.88, ["Mega|Ride"] = 603.75, ["Mega|Fly|Ride"] = 460.04}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 3.93, ["Fly"] = 70.75, ["Ride"] = 70.71, ["Neon"] = 10.49, ["Neon|Fly"] = 78.54, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 79.24, ["Mega|Ride"] = 728.43, ["Mega|Fly|Ride"] = 564.03}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 31.18, ["Fly"] = 70.75, ["Ride"] = 54.76, ["Fly|Ride"] = 104.81, ["Neon"] = 146.44, ["Neon|Ride"] = 131.25, ["Mega|Ride"] = 1126.99, ["Mega|Fly|Ride"] = 1123.83}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 144.82, ["Ride"] = 53.82, ["Fly|Ride"] = 908.98, ["Neon"] = 4.98, ["Neon|Ride"] = 28.53, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 47.25, ["Mega|Fly"] = 158.61, ["Mega|Ride"] = 88.99, ["Mega|Fly|Ride"] = 228.9}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 57.03, ["Ride"] = 19.69, ["Fly|Ride"] = 102.85, ["Neon"] = 6.3, ["Neon|Fly"] = 41.88, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 105.65, ["Mega"] = 167.95, ["Mega|Ride"] = 180.63, ["Mega|Fly|Ride"] = 289.43}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 6.57, ["Fly"] = 35.6, ["Ride"] = 40.77, ["Fly|Ride"] = 191.79, ["Neon"] = 42.25, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 160.68, ["Mega"] = 262.5, ["Mega|Ride"] = 343.59, ["Mega|Fly|Ride"] = 378}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 32.82, ["Ride"] = 66.62, ["Fly|Ride"] = 160.62, ["Neon"] = 241.37, ["Neon|Ride"] = 196.46, ["Neon|Fly|Ride"] = 618.21, ["Mega"] = 815, ["Mega|Ride"] = 1050.95, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 31.65, ["Fly"] = 30.19, ["Ride"] = 35.43, ["Fly|Ride"] = 77.44, ["Neon"] = 105.49, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 141.56, ["Mega"] = 620.57, ["Mega|Ride"] = 388.7, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 54.86, ["Ride"] = 120.39, ["Fly|Ride"] = 196.85, ["Neon"] = 355.69, ["Neon|Ride"] = 354.38, ["Neon|Fly|Ride"] = 591.49, ["Mega"] = 1126.99, ["Mega|Ride"] = 1302, ["Mega|Fly|Ride"] = 1250.82}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.94, ["Ride"] = 35.44, ["Neon"] = 18.26, ["Neon|Ride"] = 54.92, ["Neon|Fly|Ride"] = 305.8, ["Mega"] = 196.21, ["Mega|Ride"] = 226.04, ["Mega|Fly|Ride"] = 327.48}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 6.18, ["Ride"] = 24.76, ["Fly|Ride"] = 78.75, ["Neon"] = 19.2, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 141.56, ["Mega"] = 203.44, ["Mega|Ride"] = 181.1, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 12.86, ["Fly"] = 28.33, ["Ride"] = 44.01, ["Fly|Ride"] = 98.95, ["Neon"] = 56.13, ["Neon|Ride"] = 131.25, ["Mega"] = 316.88, ["Mega|Ride"] = 346.45, ["Mega|Fly|Ride"] = 452.82}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 11.8, ["Fly|Ride"] = 31.4, ["Neon"] = 2.1, ["Neon|Fly"] = 17.05, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 45.85, ["Mega"] = 16.96, ["Mega|Fly"] = 70.79, ["Mega|Ride"] = 21, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 63.32, ["Fly"] = 91.88, ["Ride"] = 91.88, ["Fly|Ride"] = 303.01, ["Neon"] = 239.69, ["Neon|Fly"] = 2393.58, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 984.41, ["Mega|Ride"] = 807.19, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 95.04, ["Fly|Ride"] = 109.82, ["Neon"] = 3.7, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 43.19, ["Mega|Ride"] = 50.75, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 22.32, ["Ride"] = 19.69, ["Fly|Ride"] = 61.2, ["Neon"] = 15.85, ["Neon|Fly"] = 141.49, ["Neon|Ride"] = 32.44, ["Neon|Fly|Ride"] = 55.01, ["Mega"] = 118.13, ["Mega|Ride"] = 414.24, ["Mega|Fly|Ride"] = 316.88}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 78.75, ["Ride"] = 115.5, ["Fly|Ride"] = 262.5, ["Neon"] = 295.65, ["Neon|Ride"] = 252, ["Neon|Fly|Ride"] = 359.14, ["Mega"] = 1019.82, ["Mega|Ride"] = 1048.69, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 72.19, ["Neon"] = 7.88, ["Neon|Ride"] = 42.95, ["Mega"] = 65.63, ["Mega|Ride"] = 135.3, ["Mega|Fly|Ride"] = 274.63}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 6.57}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 15.85, ["Fly|Ride"] = 321.9, ["Neon"] = 8.45, ["Neon|Ride"] = 63.37, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 44.63, ["Mega|Ride"] = 116.18, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 151.47, ["Ride"] = 185.22, ["Fly|Ride"] = 236.25, ["Neon"] = 538.13, ["Neon|Ride"] = 696.87, ["Neon|Fly|Ride"] = 708.75, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.94, ["Ride"] = 25.5, ["Neon"] = 15.85, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 117.26, ["Mega"] = 145.84, ["Mega|Ride"] = 211.26, ["Mega|Fly|Ride"] = 467.92}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Neon"] = 2.1, ["Neon|Ride"] = 20.19, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 45.42, ["Mega|Ride"] = 128.21, ["Mega|Fly|Ride"] = 141.56}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 7.88, ["Ride"] = 28.52, ["Neon"] = 51.1, ["Neon|Ride"] = 141.56, ["Neon|Fly|Ride"] = 169.01, ["Mega|Ride"] = 633.74, ["Mega|Fly|Ride"] = 637.77}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 10.31, ["Fly"] = 28.88, ["Ride"] = 26.59, ["Fly|Ride"] = 157.5, ["Neon"] = 79.75, ["Neon|Ride"] = 90.77, ["Neon|Fly|Ride"] = 282.02, ["Mega"] = 587.35, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 49.87, ["Ride"] = 80.39, ["Fly|Ride"] = 211.18, ["Neon"] = 187.69, ["Neon|Ride"] = 315.47, ["Neon|Fly|Ride"] = 478.94, ["Mega"] = 640.42, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 150.67, ["Fly"] = 189.9, ["Ride"] = 181.61, ["Fly|Ride"] = 221.82, ["Neon"] = 478.59, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 522.27, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 8.93, ["Fly"] = 22.3, ["Ride"] = 19.67, ["Fly|Ride"] = 39.38, ["Neon"] = 91.88, ["Neon|Ride"] = 63.37, ["Neon|Fly|Ride"] = 91.88, ["Mega|Ride"] = 564.03, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 3.93, ["Fly"] = 131.23, ["Ride"] = 32.37, ["Fly|Ride"] = 131.25, ["Neon"] = 14.04, ["Neon|Ride"] = 35.69, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 137.82, ["Mega|Fly|Ride"] = 287.84}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 6.57, ["Fly"] = 236.25, ["Ride"] = 52.92, ["Neon"] = 99.26, ["Neon|Ride"] = 141.56, ["Mega"] = 1273.81, ["Mega|Fly|Ride"] = 627.4}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 42.23, ["Fly"] = 54.92, ["Ride"] = 65.63, ["Fly|Ride"] = 105.68, ["Neon"] = 191.79, ["Neon|Ride"] = 211, ["Neon|Fly|Ride"] = 363.27, ["Mega"] = 986.52, ["Mega|Ride"] = 931.88, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 15.63, ["Ride"] = 81.86, ["Neon"] = 80.32, ["Neon|Ride"] = 126.6, ["Mega"] = 704.51, ["Mega|Ride"] = 746.76, ["Mega|Fly|Ride"] = 1125.49}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 309.75, ["Ride"] = 413.44, ["Neon"] = 774.43, ["Neon|Ride"] = 1055.84, ["Neon|Fly|Ride"] = 1084.74, ["Mega|Fly|Ride"] = 4633.63}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 30.19, ["Ride"] = 48.24, ["Fly|Ride"] = 168.41, ["Neon"] = 141.49, ["Neon|Ride"] = 281.64, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 984.38, ["Mega|Ride"] = 844.98, ["Mega|Fly|Ride"] = 871.16}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 16.14, ["Ride"] = 14.69, ["Fly|Ride"] = 67.67, ["Neon"] = 2.1, ["Neon|Fly"] = 19.2, ["Neon|Ride"] = 18.77, ["Neon|Fly|Ride"] = 56.88, ["Mega"] = 22.3, ["Mega|Fly"] = 107.76, ["Mega|Ride"] = 47.25, ["Mega|Fly|Ride"] = 119.36}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 3.83, ["Ride"] = 211.18, ["Neon"] = 21, ["Neon|Ride"] = 45.85, ["Neon|Fly|Ride"] = 126.76, ["Mega"] = 156.33, ["Mega|Fly"] = 124.69, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 373.42}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 4.87, ["Ride"] = 33.8, ["Fly|Ride"] = 144.16, ["Neon"] = 17.64, ["Neon|Ride"] = 78.07, ["Neon|Fly|Ride"] = 223.93, ["Mega"] = 120.62, ["Mega|Fly"] = 549.25, ["Mega|Ride"] = 282.02, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 288.75, ["Fly"] = 640.04, ["Ride"] = 393.75, ["Fly|Ride"] = 422.35, ["Neon"] = 2111.67, ["Neon|Ride"] = 1630.57, ["Neon|Fly|Ride"] = 1625.53, ["Mega|Fly|Ride"] = 5033.44}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.63, ["Fly"] = 47.59, ["Ride"] = 16.85, ["Fly|Ride"] = 42.21, ["Neon"] = 24.94, ["Neon|Ride"] = 34.12, ["Neon|Fly|Ride"] = 78.35, ["Mega"] = 168, ["Mega|Ride"] = 270.4, ["Mega|Fly|Ride"] = 422.5}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 6.3, ["Fly"] = 31.66, ["Ride"] = 19.69, ["Fly|Ride"] = 39.38, ["Neon"] = 27.47, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 70.79, ["Neon|Fly|Ride"] = 95.07, ["Mega|Ride"] = 704.51, ["Mega|Fly|Ride"] = 274.63}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 5.25, ["Fly"] = 84.42, ["Ride"] = 26.25, ["Fly|Ride"] = 65.63, ["Neon"] = 19.02, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 65.61, ["Neon|Fly|Ride"] = 120.42, ["Mega"] = 111.57, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 528.12}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 49.88, ["Fly"] = 210, ["Ride"] = 70.75, ["Fly|Ride"] = 61.69, ["Neon"] = 118.27, ["Neon|Ride"] = 183.79, ["Neon|Fly|Ride"] = 210, ["Mega"] = 950.61, ["Mega|Ride"] = 843.93, ["Mega|Fly|Ride"] = 585.16}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 31.38, ["Ride"] = 30.6, ["Fly|Ride"] = 62.3, ["Neon"] = 15.72, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 210, ["Mega"] = 157.24, ["Mega|Ride"] = 183.79, ["Mega|Fly|Ride"] = 952.23}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 8.45, ["Fly"] = 104.15, ["Ride"] = 28.49, ["Fly|Ride"] = 68.25, ["Neon"] = 81.15, ["Neon|Ride"] = 141.38, ["Mega|Ride"] = 611.56, ["Mega|Fly|Ride"] = 729.86}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 40.92, ["Neon"] = 6.33, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 28.72, ["Mega"] = 36.75, ["Mega|Ride"] = 128.62, ["Mega|Fly|Ride"] = 282.02}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 12.39, ["Ride"] = 56.44, ["Neon"] = 59.07, ["Mega"] = 357.96, ["Mega|Fly|Ride"] = 844.98}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 42.23, ["Ride"] = 56.99, ["Neon"] = 85.58, ["Neon|Fly|Ride"] = 177.47, ["Mega"] = 328.13, ["Mega|Ride"] = 557.69, ["Mega|Fly|Ride"] = 479.53}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 7.85, ["Fly"] = 26.25, ["Ride"] = 23.63, ["Fly|Ride"] = 53.44, ["Neon"] = 74.33, ["Neon|Fly"] = 65.54, ["Neon|Ride"] = 63.32, ["Neon|Fly|Ride"] = 112.01, ["Mega"] = 591.49, ["Mega|Ride"] = 375.38, ["Mega|Fly|Ride"] = 358.34}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 189, ["Fly"] = 216.56, ["Ride"] = 209.89, ["Fly|Ride"] = 267.75, ["Neon"] = 863.68, ["Neon|Ride"] = 873.18, ["Neon|Fly|Ride"] = 914.7, ["Mega|Fly|Ride"] = 4210.1}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Fly"] = 27.44, ["Ride"] = 17.07, ["Fly|Ride"] = 48.51, ["Neon"] = 12.74, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 141.56, ["Mega"] = 220.5, ["Mega|Ride"] = 164.78, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.93, ["Fly"] = 42.23, ["Ride"] = 17.07, ["Fly|Ride"] = 103.82, ["Neon"] = 13.13, ["Neon|Ride"] = 27.59, ["Neon|Fly|Ride"] = 160.68, ["Mega"] = 252, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 48.57, ["Ride"] = 153.43, ["Fly|Ride"] = 196.88, ["Neon"] = 152.81, ["Neon|Ride"] = 204.67, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 458.83, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 564.25}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 52.5, ["Fly"] = 168.83, ["Ride"] = 156.05, ["Fly|Ride"] = 261.18, ["Neon"] = 525, ["Neon|Ride"] = 414.05, ["Neon|Fly|Ride"] = 696.28, ["Mega"] = 1901.21, ["Mega|Ride"] = 1791.57, ["Mega|Fly|Ride"] = 1648.5}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 26.14, ["Ride"] = 88.91, ["Fly|Ride"] = 225.96, ["Neon"] = 91.77, ["Neon|Ride"] = 117.26, ["Neon|Fly|Ride"] = 282.02, ["Mega"] = 261.19, ["Mega|Ride"] = 338.63, ["Mega|Fly|Ride"] = 448.88}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.22, ["Fly|Ride"] = 46.5, ["Neon"] = 10.4, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 62.25, ["Mega|Ride"] = 183.79, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 20.79, ["Ride"] = 61.69, ["Fly|Ride"] = 9150.9, ["Neon"] = 70.66, ["Neon|Ride"] = 65.63, ["Mega"] = 223.28, ["Mega|Ride"] = 391.79, ["Mega|Fly|Ride"] = 436.54}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 82.69, ["Ride"] = 130.52, ["Fly|Ride"] = 216.57, ["Neon"] = 194.25, ["Neon|Ride"] = 256.29, ["Neon|Fly|Ride"] = 388.82, ["Mega"] = 562.89, ["Mega|Ride"] = 584.64, ["Mega|Fly|Ride"] = 669.33}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 87.94, ["Fly|Ride"] = 56.44, ["Neon"] = 7.23, ["Neon|Ride"] = 104.74, ["Neon|Fly|Ride"] = 141.88, ["Mega"] = 62.46, ["Mega|Fly"] = 162.67, ["Mega|Ride"] = 108.85, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 11.36, ["Ride"] = 238.07, ["Neon"] = 72.19, ["Neon|Ride"] = 637.88, ["Mega"] = 363.86, ["Mega|Ride"] = 675.99, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 977.81, ["Fly"] = 1337.75, ["Ride"] = 952.88, ["Fly|Ride"] = 1069.69, ["Neon"] = 2362.5, ["Neon|Ride"] = 3521.21, ["Neon|Fly|Ride"] = 3281.25, ["Mega|Fly|Ride"] = 12534.38}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 32.81, ["Ride"] = 111.56, ["Fly|Ride"] = 201.68, ["Neon"] = 131.25, ["Neon|Fly"] = 892.5, ["Neon|Ride"] = 522.84, ["Mega"] = 560.87, ["Mega|Ride"] = 583.05, ["Mega|Fly|Ride"] = 742.88}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 3.29, ["Fly"] = 49.18, ["Ride"] = 19.69, ["Fly|Ride"] = 80.88, ["Neon"] = 15.84, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 36.63, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 82.4, ["Mega|Ride"] = 108.09, ["Mega|Fly|Ride"] = 195.42}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 7.87, ["Ride"] = 131.22, ["Neon"] = 106.32, ["Mega"] = 316.88, ["Mega|Ride"] = 555.09, ["Mega|Fly|Ride"] = 479.53}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 22.78, ["Fly|Ride"] = 422.35, ["Neon"] = 2.1, ["Neon|Ride"] = 27.36, ["Neon|Fly|Ride"] = 105.46, ["Mega"] = 14.34, ["Mega|Ride"] = 44.63, ["Mega|Fly|Ride"] = 549.25}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 78.75, ["Ride"] = 140.44, ["Fly|Ride"] = 183.75, ["Neon"] = 344.14, ["Neon|Ride"] = 367.5, ["Mega"] = 1210.64, ["Mega|Ride"] = 1132.71, ["Mega|Fly|Ride"] = 1155}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 4.87, ["Fly"] = 174.57, ["Ride"] = 37.7, ["Fly|Ride"] = 87.14, ["Neon"] = 35.7, ["Neon|Ride"] = 47.96, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 350.44, ["Mega|Ride"] = 295.75, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 5.25, ["Ride"] = 26.25, ["Neon"] = 12.99, ["Neon|Ride"] = 78.75, ["Mega"] = 141.56, ["Mega|Ride"] = 239.77, ["Mega|Fly|Ride"] = 373.91}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 52.49, ["Ride"] = 59.59, ["Fly|Ride"] = 167.63, ["Neon"] = 126.71, ["Neon|Fly"] = 280.65, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 633.74, ["Mega"] = 1048.69, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 1056.23}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 18.12, ["Ride"] = 70.68, ["Fly|Ride"] = 196.88, ["Neon"] = 117.21, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 315, ["Mega"] = 490.88, ["Mega|Fly|Ride"] = 667.54}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 49.88, ["Neon"] = 779.63, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 1083.49, ["Mega"] = 1126.99, ["Mega|Ride"] = 1831.5, ["Mega|Fly|Ride"] = 1994.22}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 5.25, ["Ride"] = 74.99, ["Neon"] = 24.09, ["Neon|Ride"] = 105.65, ["Neon|Fly|Ride"] = 282.02, ["Mega"] = 111.57, ["Mega|Ride"] = 152.25, ["Mega|Fly|Ride"] = 352.43}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 9.19, ["Fly"] = 32.15, ["Ride"] = 27.57, ["Fly|Ride"] = 57.03, ["Neon"] = 62.44, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 133.98, ["Mega"] = 399, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 124.69, ["Ride"] = 185.56, ["Fly|Ride"] = 233.42, ["Neon"] = 582.75, ["Neon|Ride"] = 591.05, ["Neon|Fly|Ride"] = 633.74, ["Mega|Ride"] = 1689.96, ["Mega|Fly|Ride"] = 1903.13}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 14.44, ["Ride"] = 18.27, ["Fly|Ride"] = 56.96, ["Neon"] = 7.88, ["Neon|Fly"] = 64.31, ["Neon|Ride"] = 21.14, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 145.69, ["Mega|Ride"] = 155.3, ["Mega|Fly|Ride"] = 559.99}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 6.56, ["Fly"] = 87.94, ["Ride"] = 22.32, ["Fly|Ride"] = 78.59, ["Neon"] = 18.36, ["Neon|Fly"] = 281.17, ["Neon|Ride"] = 51.17, ["Neon|Fly|Ride"] = 126.76, ["Mega"] = 201.75, ["Mega|Ride"] = 198.22, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Ride"] = 15.75, ["Fly|Ride"] = 36.66, ["Neon"] = 2.1, ["Neon|Fly"] = 16.69, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 21.1, ["Mega|Ride"] = 40.15, ["Mega|Fly|Ride"] = 85.32}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 42.25, ["Neon"] = 3.93, ["Neon|Ride"] = 40.15, ["Mega"] = 23.23, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 139.44}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 3.94, ["Fly"] = 131.25, ["Ride"] = 27.44, ["Fly|Ride"] = 45.94, ["Neon"] = 22.74, ["Neon|Ride"] = 23.63, ["Mega"] = 111.97, ["Mega|Ride"] = 152.3}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 82.69, ["Ride"] = 84, ["Neon"] = 522.38, ["Neon|Ride"] = 422.35, ["Neon|Fly|Ride"] = 630, ["Mega"] = 779.63, ["Mega|Fly|Ride"] = 649.59}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.63, ["Fly"] = 17.93, ["Ride"] = 15.36, ["Fly|Ride"] = 26.23, ["Neon"] = 12.5, ["Neon|Fly"] = 28.52, ["Neon|Ride"] = 25.02, ["Neon|Fly|Ride"] = 57.72, ["Mega"] = 91.68, ["Mega|Fly"] = 164.04, ["Mega|Ride"] = 113.03, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 2.63, ["Fly"] = 28.33, ["Ride"] = 22.32, ["Fly|Ride"] = 68.22, ["Neon"] = 16.31, ["Neon|Fly"] = 36.75, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 82.85, ["Mega"] = 147, ["Mega|Fly"] = 308.43, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 189.58}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 3.82, ["Fly"] = 19.59, ["Ride"] = 18.21, ["Fly|Ride"] = 99.2, ["Neon"] = 9.19, ["Neon|Fly"] = 47.96, ["Neon|Ride"] = 23.99, ["Neon|Fly|Ride"] = 105.65, ["Mega"] = 103.39, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 15.74, ["Fly"] = 280.66, ["Ride"] = 24.86, ["Neon"] = 42.25, ["Neon|Ride"] = 59.04, ["Neon|Fly|Ride"] = 268.82, ["Mega"] = 250.04, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 345.4, ["Mega|Fly|Ride"] = 640.42}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 8.17, ["Fly"] = 160.6, ["Ride"] = 66, ["Neon"] = 103.85, ["Neon|Ride"] = 65.63, ["Mega"] = 328.13, ["Mega|Fly|Ride"] = 1056.23}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 6.3, ["Fly"] = 35.44, ["Ride"] = 20.78, ["Fly|Ride"] = 52.5, ["Neon"] = 26.25, ["Neon|Fly"] = 196.65, ["Neon|Ride"] = 60.38, ["Neon|Fly|Ride"] = 109.4, ["Mega"] = 239.87, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 20.65, ["Ride"] = 13.13, ["Fly|Ride"] = 39.38, ["Neon"] = 13.13, ["Neon|Fly"] = 33.8, ["Neon|Ride"] = 32.39, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 422.5, ["Mega|Ride"] = 238.67, ["Mega|Fly|Ride"] = 209.14}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 170.63, ["Fly"] = 393.75, ["Ride"] = 236.25, ["Fly|Ride"] = 366.39, ["Neon"] = 979.82, ["Neon|Ride"] = 1043.44, ["Neon|Fly|Ride"] = 1179.94, ["Mega|Ride"] = 3522.49, ["Mega|Fly|Ride"] = 3518.63}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.7, ["Ride"] = 38.72, ["Neon"] = 35.97, ["Neon|Fly|Ride"] = 282.02, ["Mega"] = 123.38, ["Mega|Ride"] = 280.62}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.63, ["Ride"] = 30.61, ["Fly|Ride"] = 118.13, ["Neon"] = 21.13, ["Neon|Fly"] = 211.18, ["Neon|Ride"] = 36.54, ["Neon|Fly|Ride"] = 105.65, ["Mega"] = 196.88, ["Mega|Ride"] = 278.85, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 3.63, ["Neon"] = 42.25, ["Neon|Ride"] = 213.44, ["Neon|Fly|Ride"] = 633.74, ["Mega"] = 476.55, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 428.54}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 16.89, ["Fly|Ride"] = 26.17, ["Neon"] = 2.1, ["Neon|Fly"] = 21.11, ["Neon|Ride"] = 17.85, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 22.32, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 60.21, ["Mega|Fly|Ride"] = 84.51}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 5.94, ["Fly"] = 56.37, ["Ride"] = 26.25, ["Fly|Ride"] = 56.44, ["Neon"] = 15.84, ["Neon|Ride"] = 27.34, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 128.31, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 4.8, ["Ride"] = 57.03, ["Fly|Ride"] = 77.43, ["Neon"] = 8.46, ["Neon|Ride"] = 70.79, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 55.11, ["Mega|Ride"] = 160.72, ["Mega|Fly|Ride"] = 235.56}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 65.63, ["Fly"] = 133.98, ["Ride"] = 91.88, ["Fly|Ride"] = 151.29, ["Neon"] = 422.35, ["Neon|Ride"] = 422.35, ["Neon|Fly|Ride"] = 352.33, ["Mega|Ride"] = 3522.49, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 2.99, ["Fly"] = 85.32, ["Ride"] = 33.8, ["Fly|Ride"] = 65.63, ["Neon"] = 26.25, ["Neon|Ride"] = 56.37, ["Neon|Fly|Ride"] = 137.89, ["Mega"] = 209.41, ["Mega|Ride"] = 259.86}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 31.69, ["Ride"] = 52.5, ["Fly|Ride"] = 118.13, ["Neon"] = 10.56, ["Neon|Ride"] = 57.05, ["Neon|Fly|Ride"] = 169.01, ["Mega"] = 52.5, ["Mega|Fly"] = 313.69, ["Mega|Ride"] = 103.52, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 65.63, ["Fly"] = 210, ["Ride"] = 89.25, ["Fly|Ride"] = 295.32, ["Neon"] = 174.97, ["Neon|Ride"] = 187.03, ["Neon|Fly|Ride"] = 303.19, ["Mega"] = 633.74, ["Mega|Ride"] = 564.03, ["Mega|Fly|Ride"] = 619.5}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 16.88, ["Ride"] = 14.36, ["Fly|Ride"] = 30.19, ["Neon"] = 2.63, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 41.99, ["Mega|Fly"] = 43.24, ["Mega|Ride"] = 36.99, ["Mega|Fly|Ride"] = 81.38}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 5.25, ["Neon|Ride"] = 60.29, ["Neon|Fly|Ride"] = 71.09, ["Mega"] = 26.23, ["Mega|Ride"] = 77.44, ["Mega|Fly|Ride"] = 179.58}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.63, ["Ride"] = 46.35, ["Fly|Ride"] = 137.82, ["Neon"] = 9.19, ["Neon|Ride"] = 124.6, ["Neon|Fly|Ride"] = 190.13, ["Mega"] = 73.5, ["Mega|Ride"] = 115.48, ["Mega|Fly|Ride"] = 295.75}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 6.57, ["Fly"] = 141.49, ["Ride"] = 69.54, ["Fly|Ride"] = 111.56, ["Neon"] = 29.5, ["Neon|Fly"] = 135.19, ["Neon|Ride"] = 107.91, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 105.65, ["Mega|Fly"] = 211.26, ["Mega|Ride"] = 182.58, ["Mega|Fly|Ride"] = 312.22}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 13.12, ["Ride"] = 14.44, ["Fly|Ride"] = 40.69, ["Neon"] = 2.1, ["Neon|Fly"] = 28.79, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 70.75, ["Mega"] = 21.48, ["Mega|Ride"] = 44.38, ["Mega|Fly|Ride"] = 129.92}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 12.68, ["Ride"] = 43.98, ["Fly|Ride"] = 235.46, ["Neon"] = 70.88, ["Neon|Ride"] = 166.84, ["Neon|Fly|Ride"] = 208.04, ["Mega"] = 421.45, ["Mega|Fly|Ride"] = 631.92}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2756.25, ["Fly"] = 3150, ["Ride"] = 2779.88, ["Fly|Ride"] = 2752.32, ["Neon|Ride"] = 9858.73, ["Neon|Fly|Ride"] = 9318.75, ["Mega|Fly|Ride"] = 43832.93}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 40.11, ["Ride"] = 17.07, ["Fly|Ride"] = 62.26, ["Neon"] = 8.39, ["Neon|Fly"] = 62.29, ["Neon|Ride"] = 29.89, ["Neon|Fly|Ride"] = 66.94, ["Mega"] = 74.82, ["Mega|Fly"] = 141.56, ["Mega|Ride"] = 99.3, ["Mega|Fly|Ride"] = 173.44}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Neon"] = 19.69, ["Mega"] = 126, ["Mega|Fly"] = 179.82, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 633.74}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 15.7, ["Ride"] = 32.37, ["Fly|Ride"] = 147.83, ["Neon"] = 85.97, ["Neon|Ride"] = 279.57, ["Neon|Fly|Ride"] = 216.09, ["Mega"] = 552.42, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 417.22}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 52.5, ["Ride"] = 98.44, ["Neon"] = 187.69, ["Neon|Ride"] = 279.74, ["Neon|Fly|Ride"] = 422.5, ["Mega"] = 540.75, ["Mega|Ride"] = 742.35, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 173.25, ["Fly"] = 268.2, ["Ride"] = 189, ["Fly|Ride"] = 253.41, ["Neon"] = 1312.5, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 760.14, ["Neon|Fly|Ride"] = 764.19, ["Mega"] = 6337.31, ["Mega|Ride"] = 3566.6, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 9.86, ["Ride"] = 52.5, ["Fly|Ride"] = 675.94, ["Neon"] = 16.7, ["Neon|Fly"] = 70.75, ["Neon|Ride"] = 104.9, ["Neon|Fly|Ride"] = 141.56, ["Mega"] = 224.44, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 287.84}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 63.32, ["Neon"] = 15.74, ["Neon|Fly"] = 99.26, ["Neon|Ride"] = 42.25, ["Neon|Fly|Ride"] = 528.12, ["Mega"] = 134.15, ["Mega|Ride"] = 261.03, ["Mega|Fly|Ride"] = 838.43}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 101.97, ["Ride"] = 26.17, ["Fly|Ride"] = 131.25, ["Neon"] = 13.13, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 99.3, ["Mega"] = 96.51, ["Mega|Ride"] = 118.81, ["Mega|Fly|Ride"] = 280.97}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 18.9, ["Ride"] = 98.44, ["Fly|Ride"] = 656.25, ["Neon|Ride"] = 141.49, ["Neon|Fly|Ride"] = 295.75, ["Mega"] = 374.06, ["Mega|Ride"] = 501.27, ["Mega|Fly|Ride"] = 643.79}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 70.75, ["Neon"] = 2.1, ["Neon|Ride"] = 38.38, ["Mega"] = 19.69, ["Mega|Ride"] = 62.37, ["Mega|Fly|Ride"] = 338}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 82.69, ["Ride"] = 91.88, ["Fly|Ride"] = 160.62, ["Neon"] = 352.66, ["Neon|Ride"] = 409.5, ["Neon|Fly|Ride"] = 493.27, ["Mega"] = 1365, ["Mega|Fly|Ride"] = 1662.49}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 6.41, ["Neon|Ride"] = 113, ["Mega"] = 47.98, ["Mega|Ride"] = 141.75}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 54.97, ["Fly"] = 99.26, ["Ride"] = 73.5, ["Fly|Ride"] = 178.5, ["Neon"] = 281.93, ["Neon|Fly"] = 352.66, ["Neon|Ride"] = 211, ["Neon|Fly|Ride"] = 563.35, ["Mega"] = 2625, ["Mega|Ride"] = 1712.54, ["Mega|Fly|Ride"] = 1253.75}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 33.8, ["Ride"] = 24.3, ["Fly|Ride"] = 49.88, ["Neon"] = 5.2, ["Neon|Fly"] = 121.44, ["Neon|Ride"] = 42.21, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 42.28, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 107.46}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 3.54, ["Neon"] = 11.82, ["Neon|Ride"] = 113, ["Mega"] = 80.07, ["Mega|Ride"] = 167.46, ["Mega|Fly|Ride"] = 422.5}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 14.18, ["Fly|Ride"] = 141.49, ["Neon"] = 78.75, ["Neon|Ride"] = 141.56, ["Neon|Fly|Ride"] = 160.68, ["Mega"] = 217.32, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 950.61}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 412.13, ["Ride"] = 459.38, ["Fly|Ride"] = 536.82, ["Neon"] = 1232.44, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1443.75, ["Mega|Ride"] = 4317.33, ["Mega|Fly|Ride"] = 3871.88}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 35.44, ["Fly"] = 56.99, ["Ride"] = 51.19, ["Fly|Ride"] = 87.57, ["Neon"] = 225.96, ["Neon|Fly"] = 320.03, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 157.5, ["Mega|Fly|Ride"] = 844.98}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 26.84, ["Ride"] = 17.05, ["Fly|Ride"] = 91.88, ["Neon"] = 7.09, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 47.78, ["Neon|Fly|Ride"] = 97.02, ["Mega"] = 55.13, ["Mega|Ride"] = 67.52, ["Mega|Fly|Ride"] = 395.05}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 11.64, ["Fly"] = 72.1, ["Ride"] = 42.21, ["Fly|Ride"] = 119.44, ["Neon"] = 45.85, ["Neon|Fly"] = 281.93, ["Neon|Ride"] = 77.47, ["Neon|Fly|Ride"] = 181.31, ["Mega"] = 229.69, ["Mega|Fly"] = 395.05, ["Mega|Ride"] = 243.27, ["Mega|Fly|Ride"] = 400.41}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 21, ["Ride"] = 19.69, ["Fly|Ride"] = 105.59, ["Neon"] = 84.49, ["Neon|Ride"] = 124.51, ["Neon|Fly|Ride"] = 119.91, ["Mega|Ride"] = 389.69, ["Mega|Fly|Ride"] = 408.77}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.15, ["Neon"] = 15.49, ["Neon|Ride"] = 52.5, ["Mega"] = 49.88, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 86.63, ["Ride"] = 18.98, ["Fly|Ride"] = 52.76, ["Neon"] = 26.25, ["Neon|Ride"] = 46.49, ["Neon|Fly|Ride"] = 215.49, ["Mega"] = 560.07, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 479.72}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 104.97, ["Fly"] = 131.25, ["Ride"] = 147.86, ["Fly|Ride"] = 167.64, ["Neon|Ride"] = 534.87, ["Neon|Fly|Ride"] = 842.88, ["Mega"] = 2674.35, ["Mega|Ride"] = 2816.93, ["Mega|Fly|Ride"] = 3095.78}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 23.23, ["Fly"] = 95.82, ["Ride"] = 84.41, ["Fly|Ride"] = 159.33, ["Neon"] = 192.94, ["Neon|Ride"] = 196.47, ["Mega"] = 844.98, ["Mega|Ride"] = 689.07, ["Mega|Fly|Ride"] = 698.2}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2429.12, ["Fly"] = 2349.33, ["Ride"] = 2310, ["Fly|Ride"] = 2296.88, ["Neon"] = 12669.98, ["Neon|Fly|Ride"] = 7743.75, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 41.89, ["Fly|Ride"] = 170.63, ["Neon"] = 16.21, ["Neon|Ride"] = 95.62, ["Neon|Fly|Ride"] = 169.01, ["Mega"] = 125.97, ["Mega|Ride"] = 168.67, ["Mega|Fly|Ride"] = 276.94}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 14.44, ["Ride"] = 87.65, ["Fly|Ride"] = 156.29, ["Neon"] = 56.97, ["Neon|Ride"] = 111.93, ["Neon|Fly|Ride"] = 253.32, ["Mega"] = 255.94, ["Mega|Ride"] = 704.51, ["Mega|Fly|Ride"] = 690.79}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 971.25, ["Fly"] = 1408.5, ["Ride"] = 945, ["Fly|Ride"] = 997.5, ["Neon"] = 2445.65, ["Neon|Ride"] = 3150, ["Neon|Fly|Ride"] = 2390.06, ["Mega|Fly|Ride"] = 9186.19}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 47.25, ["Ride"] = 47.96, ["Fly|Ride"] = 210, ["Neon"] = 272.08, ["Neon|Ride"] = 289.42, ["Mega"] = 840, ["Mega|Ride"] = 704.8, ["Mega|Fly|Ride"] = 843.93}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Neon"] = 14, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 135.21, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 111.19, ["Ride"] = 23.24, ["Neon"] = 3.91, ["Neon|Ride"] = 56.49, ["Mega"] = 27.83, ["Mega|Ride"] = 70.79, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 83.99, ["Ride"] = 125.99, ["Neon"] = 459.38, ["Neon|Fly|Ride"] = 479.59, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 2676.47}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 3.93, ["Neon"] = 15.73, ["Neon|Ride"] = 141.56, ["Mega"] = 146.65, ["Mega|Ride"] = 162.73, ["Mega|Fly|Ride"] = 368.19}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 76, ["Ride"] = 97.63, ["Fly|Ride"] = 219.63, ["Neon"] = 614.25, ["Neon|Ride"] = 525, ["Mega"] = 1831.5, ["Mega|Fly|Ride"] = 1684.68}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 4.25, ["Fly"] = 105, ["Fly|Ride"] = 113, ["Neon"] = 33.15, ["Neon|Fly"] = 42.25, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 143.93, ["Mega|Fly|Ride"] = 282.02}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 257.45, ["Fly"] = 422.35, ["Ride"] = 291.26, ["Fly|Ride"] = 350.44, ["Neon"] = 986.16, ["Neon|Ride"] = 1043.18, ["Neon|Fly|Ride"] = 812.44, ["Mega|Fly|Ride"] = 4084.4}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 6.57, ["Fly"] = 87.62, ["Ride"] = 26.25, ["Fly|Ride"] = 54.38, ["Neon"] = 28.49, ["Neon|Ride"] = 59.11, ["Neon|Fly|Ride"] = 104.95, ["Mega"] = 229.57, ["Mega|Ride"] = 391.86}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 18.15, ["Ride"] = 16.51, ["Fly|Ride"] = 26.25, ["Neon"] = 3.93, ["Neon|Fly"] = 8.46, ["Neon|Ride"] = 20.96, ["Neon|Fly|Ride"] = 56.98, ["Mega"] = 59.07, ["Mega|Fly"] = 103.52, ["Mega|Ride"] = 141.56, ["Mega|Fly|Ride"] = 152.33}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 836.66, ["Fly"] = 1198.57, ["Ride"] = 903, ["Fly|Ride"] = 1050.57, ["Neon|Ride"] = 5033.95, ["Neon|Fly|Ride"] = 4752.99, ["Mega|Fly|Ride"] = 28166.1}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 10.56, ["Fly"] = 986.16, ["Ride"] = 56.99, ["Neon"] = 27.43, ["Neon|Ride"] = 70.2, ["Mega"] = 179.54, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 372.1}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 6.57, ["Fly"] = 32.82, ["Ride"] = 31.49, ["Fly|Ride"] = 112.68, ["Neon"] = 32.82, ["Neon|Fly"] = 77.68, ["Neon|Ride"] = 83.83, ["Neon|Fly|Ride"] = 94.96, ["Mega"] = 197.53, ["Mega|Ride"] = 223.28, ["Mega|Fly|Ride"] = 290.07}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 39.38, ["Fly"] = 35.44, ["Ride"] = 42.25, ["Fly|Ride"] = 66.93, ["Neon|Ride"] = 211.3, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 2112.45, ["Mega|Fly|Ride"] = 787.48}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 13.13, ["Fly"] = 79.15, ["Ride"] = 30.19, ["Fly|Ride"] = 86.63, ["Neon"] = 60.14, ["Neon|Ride"] = 131.15, ["Neon|Fly|Ride"] = 205.97, ["Mega"] = 288.75, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 443.63}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 23.09, ["Ride"] = 210, ["Fly|Ride"] = 341.04, ["Neon"] = 86.63, ["Neon|Ride"] = 183.1, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 486.18, ["Mega|Ride"] = 518.62, ["Mega|Fly|Ride"] = 611.56}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.59, ["Fly|Ride"] = 238.6, ["Neon"] = 2.1, ["Neon|Ride"] = 28.13, ["Mega"] = 15.86, ["Mega|Fly"] = 86.36, ["Mega|Ride"] = 41.62}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 32.8, ["Fly"] = 74.76, ["Ride"] = 47.2, ["Fly|Ride"] = 70.7, ["Neon"] = 300.98, ["Neon|Fly"] = 307.26, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 3379.9, ["Mega|Fly|Ride"] = 1144.79}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 3.93, ["Fly"] = 91.07, ["Ride"] = 20.96, ["Fly|Ride"] = 70.87, ["Neon"] = 42.35, ["Neon|Ride"] = 141.37, ["Mega"] = 773.07, ["Mega|Ride"] = 239.87, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 26.16, ["Ride"] = 20.34, ["Fly|Ride"] = 36.75, ["Neon"] = 19, ["Neon|Ride"] = 49.61, ["Neon|Fly|Ride"] = 131.24, ["Mega|Ride"] = 282.02, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 3.93, ["Ride"] = 103.69, ["Neon"] = 105, ["Neon|Ride"] = 844.98, ["Neon|Fly|Ride"] = 126.76, ["Mega"] = 295.75, ["Mega|Fly|Ride"] = 479.72}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 25.59, ["Fly"] = 262.36, ["Ride"] = 91.88, ["Fly|Ride"] = 144.38, ["Neon"] = 118.13, ["Neon|Fly"] = 311.49, ["Neon|Ride"] = 196.4, ["Neon|Fly|Ride"] = 234.49, ["Mega"] = 656.25, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 5.16, ["Ride"] = 19.69, ["Neon"] = 24.86, ["Neon|Ride"] = 73.95, ["Neon|Fly|Ride"] = 128.87, ["Mega"] = 104.89, ["Mega|Ride"] = 70.88, ["Mega|Fly|Ride"] = 320.21}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 27.44, ["Neon"] = 2.63, ["Neon|Ride"] = 28.53, ["Mega"] = 19.67, ["Mega|Ride"] = 52.37, ["Mega|Fly|Ride"] = 204.75}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Ride"] = 20.98, ["Neon"] = 3.94, ["Neon|Fly"] = 393.59, ["Neon|Ride"] = 21.11, ["Neon|Fly|Ride"] = 177.47, ["Mega"] = 18.38, ["Mega|Fly"] = 73.95, ["Mega|Ride"] = 56.97, ["Mega|Fly|Ride"] = 106.32}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 25.89, ["Ride"] = 24.04, ["Fly|Ride"] = 26.2, ["Neon"] = 6.35, ["Neon|Fly"] = 57.03, ["Neon|Ride"] = 23.51, ["Neon|Fly|Ride"] = 76.06, ["Mega"] = 83.89, ["Mega|Ride"] = 160.72, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 5306.87, ["Neon"] = 14.4, ["Neon|Ride"] = 1312.5, ["Mega"] = 105, ["Mega|Ride"] = 148.79, ["Mega|Fly|Ride"] = 183.79}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 26.23, ["Ride"] = 15.74, ["Fly|Ride"] = 40.6, ["Neon"] = 16.89, ["Neon|Fly"] = 52.8, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 77.17, ["Mega"] = 287.84, ["Mega|Ride"] = 276.29, ["Mega|Fly|Ride"] = 367.49}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 77.44, ["Ride"] = 131.25, ["Fly|Ride"] = 422.35, ["Neon"] = 241.5, ["Neon|Ride"] = 298.91, ["Neon|Fly|Ride"] = 1056.23, ["Mega|Ride"] = 845.4}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 26.19, ["Ride"] = 18.38, ["Fly|Ride"] = 39.38, ["Neon"] = 3.84, ["Neon|Fly"] = 28.5, ["Neon|Ride"] = 23.23, ["Neon|Fly|Ride"] = 52.99, ["Mega"] = 64.32, ["Mega|Ride"] = 67.61, ["Mega|Fly|Ride"] = 110.71}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 10.49, ["Fly"] = 62.91, ["Ride"] = 44.46, ["Fly|Ride"] = 99.26, ["Neon"] = 46.76, ["Neon|Fly"] = 84.32, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 115.39, ["Mega"] = 844.98, ["Mega|Ride"] = 262.05, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 14.11, ["Fly"] = 36.74, ["Ride"] = 27.57, ["Fly|Ride"] = 95.51, ["Neon"] = 72.14, ["Neon|Fly"] = 140.41, ["Neon|Ride"] = 82.69, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 1056.23, ["Mega|Ride"] = 420.39, ["Mega|Fly|Ride"] = 317.63}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.94, ["Fly"] = 140.38, ["Ride"] = 47.96, ["Neon"] = 15.65, ["Neon|Ride"] = 70.75, ["Mega"] = 279.57, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 379.2}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 18, ["Fly|Ride"] = 26.17, ["Neon"] = 2.63, ["Neon|Fly"] = 41.2, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 51.1, ["Mega|Fly"] = 105, ["Mega|Ride"] = 61.69, ["Mega|Fly|Ride"] = 106.24}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.77, ["Fly"] = 78.07, ["Ride"] = 28.44, ["Fly|Ride"] = 141.39, ["Neon"] = 15.84, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 69.65, ["Neon|Fly|Ride"] = 158.45, ["Mega"] = 126, ["Mega|Fly"] = 735, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 426.95}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 905.63, ["Fly"] = 1308.19, ["Ride"] = 968.63, ["Fly|Ride"] = 984.38, ["Neon"] = 2625, ["Neon|Ride"] = 2744.06, ["Neon|Fly|Ride"] = 2296.88, ["Mega|Fly|Ride"] = 7612.48}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 80.07, ["Ride"] = 94.5, ["Neon"] = 259.75, ["Neon|Ride"] = 321.96, ["Neon|Fly|Ride"] = 418.27, ["Mega"] = 1477.66, ["Mega|Ride"] = 1470.26, ["Mega|Fly|Ride"] = 1322.35}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Ride"] = 68.39, ["Neon"] = 12, ["Neon|Ride"] = 70.79, ["Neon|Fly|Ride"] = 99.3, ["Mega"] = 56.9}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 35.44, ["Ride"] = 63.67, ["Fly|Ride"] = 160.62, ["Neon"] = 173.32, ["Neon|Ride"] = 190.66, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1023.75, ["Mega|Ride"] = 1515.94, ["Mega|Fly|Ride"] = 786.19}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 4.11, ["Ride"] = 118.44, ["Fly|Ride"] = 156.19, ["Neon"] = 39.8, ["Neon|Ride"] = 71.8, ["Neon|Fly|Ride"] = 280.97, ["Mega"] = 474.26, ["Mega|Fly|Ride"] = 1056.23}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 261.09, ["Fly"] = 422.35, ["Ride"] = 288.75, ["Fly|Ride"] = 315, ["Neon|Ride"] = 1113.27, ["Neon|Fly|Ride"] = 1115.63, ["Mega|Fly|Ride"] = 4223.82}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 102.37, ["Ride"] = 22.32, ["Fly|Ride"] = 129.93, ["Neon"] = 15.75, ["Neon|Ride"] = 53.9, ["Mega"] = 401.21, ["Mega|Fly"] = 282.02}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 104.9, ["Neon|Ride"] = 38.04, ["Mega"] = 198.58}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 70.89, ["Ride"] = 141.49, ["Fly|Ride"] = 279.7, ["Neon"] = 345.19, ["Neon|Ride"] = 327.45, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 590.63, ["Mega|Ride"] = 551.25, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 48.44, ["Fly|Ride"] = 160.62, ["Neon"] = 13.86, ["Neon|Ride"] = 45.93, ["Mega"] = 226.04, ["Mega|Ride"] = 295.75, ["Mega|Fly|Ride"] = 211.26}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 16.89, ["Ride"] = 15.74, ["Fly|Ride"] = 32.48, ["Neon"] = 3.63, ["Neon|Fly"] = 32.29, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 28.53, ["Mega|Fly"] = 70.79, ["Mega|Ride"] = 40.15, ["Mega|Fly|Ride"] = 90.57}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4200, ["Ride"] = 4331.25, ["Fly|Ride"] = 4332.56, ["Neon"] = 26326.1, ["Neon|Fly|Ride"] = 22533.3, ["Mega|Fly|Ride"] = 63372.89}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 17.95, ["Ride"] = 48.59, ["Neon"] = 84.49, ["Mega"] = 408.77, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 23.45, ["Ride"] = 21, ["Fly|Ride"] = 60.36, ["Neon"] = 12.86, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 229.53, ["Mega|Ride"] = 166, ["Mega|Fly|Ride"] = 234.49}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 420, ["Fly"] = 519.49, ["Ride"] = 477.75, ["Fly|Ride"] = 522.38, ["Neon"] = 1312.5, ["Neon|Ride"] = 1264.9, ["Neon|Fly|Ride"] = 1169.44, ["Mega|Fly|Ride"] = 4958.94}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 3.4, ["Ride"] = 28.52, ["Neon"] = 17.07, ["Neon|Ride"] = 145.68, ["Mega"] = 124.59, ["Mega|Fly|Ride"] = 344.21}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.77, ["Fly"] = 211.18, ["Ride"] = 367.5, ["Neon"] = 15.85, ["Neon|Ride"] = 281.93, ["Neon|Fly|Ride"] = 14083.58, ["Mega"] = 415.42, ["Mega|Ride"] = 401.63}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.33, ["Ride"] = 17.54, ["Fly|Ride"] = 82.55, ["Neon"] = 7.87, ["Neon|Fly"] = 124.67, ["Neon|Ride"] = 33.81, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 62.99, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 637.88, ["Ride"] = 607.69, ["Fly|Ride"] = 645.6, ["Neon"] = 2100, ["Neon|Fly|Ride"] = 1967.34, ["Mega|Fly|Ride"] = 9154.22}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.14, ["Ride"] = 59.07, ["Neon"] = 23.63, ["Neon|Ride"] = 99.3, ["Neon|Fly|Ride"] = 139.13, ["Mega"] = 156.19, ["Mega|Ride"] = 201.71, ["Mega|Fly|Ride"] = 316.88}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 5.25, ["Fly"] = 235.94, ["Ride"] = 84.49, ["Fly|Ride"] = 150.94, ["Neon"] = 51.98, ["Neon|Ride"] = 100.26, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 243.64, ["Mega|Ride"] = 244.48, ["Mega|Fly|Ride"] = 430.96}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 3.15, ["Fly"] = 28.52, ["Ride"] = 17.97, ["Fly|Ride"] = 50.28, ["Neon"] = 15.73, ["Neon|Fly"] = 73.92, ["Neon|Ride"] = 28.5, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 173.25, ["Mega|Fly"] = 282.02, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 208.69}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["Ride"] = 48.57, ["Neon"] = 91.87, ["Neon|Fly"] = 170.63, ["Neon|Fly|Ride"] = 320.13, ["Mega"] = 522.84, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 527.07}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 39.37, ["Neon"] = 6.3, ["Neon|Ride"] = 54.54, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 34.13, ["Mega|Ride"] = 87.56, ["Mega|Fly|Ride"] = 218.67}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 393.75, ["Ride"] = 449.16, ["Fly|Ride"] = 506.81, ["Neon"] = 1837.5, ["Neon|Ride"] = 2428.42, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Ride"] = 9354.2, ["Mega|Fly|Ride"] = 7848.75}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 53.76, ["Fly|Ride"] = 333.65, ["Neon"] = 11.69, ["Neon|Ride"] = 82.44, ["Neon|Fly|Ride"] = 152.11, ["Mega"] = 55.13, ["Mega|Ride"] = 186.37, ["Mega|Fly|Ride"] = 340.57}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 52.48, ["Neon"] = 3.94, ["Neon|Fly"] = 70.75, ["Neon|Ride"] = 215.14, ["Neon|Fly|Ride"] = 111.46, ["Mega"] = 40.15, ["Mega|Fly"] = 92.96, ["Mega|Ride"] = 84.51, ["Mega|Fly|Ride"] = 210.2}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 60.37, ["Neon"] = 6.3, ["Neon|Ride"] = 45.91, ["Neon|Fly|Ride"] = 141.56, ["Mega"] = 45.44, ["Mega|Fly"] = 156.33, ["Mega|Ride"] = 88.74}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 3.82, ["Ride"] = 131.25, ["Neon"] = 25.35, ["Neon|Ride"] = 70.79, ["Mega"] = 231.33, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 70.81, ["Ride"] = 105.59, ["Fly|Ride"] = 232.32, ["Neon"] = 276.94, ["Neon|Ride"] = 336, ["Neon|Fly|Ride"] = 1599.41, ["Mega"] = 872.23, ["Mega|Ride"] = 943.68, ["Mega|Fly|Ride"] = 838.65}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 31.2, ["Fly"] = 69.47, ["Ride"] = 65.5, ["Fly|Ride"] = 112.11, ["Neon"] = 111.57, ["Neon|Ride"] = 156.29, ["Mega"] = 463.21, ["Mega|Ride"] = 439.83, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 40.14, ["Ride"] = 17.99, ["Fly|Ride"] = 44.46, ["Neon"] = 30.38, ["Neon|Fly"] = 70.75, ["Neon|Ride"] = 35, ["Neon|Fly|Ride"] = 76.65, ["Mega"] = 394.42, ["Mega|Ride"] = 183.79, ["Mega|Fly|Ride"] = 253.52}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 8.34, ["Ride"] = 64.32, ["Fly|Ride"] = 115.07, ["Neon"] = 141.49, ["Neon|Ride"] = 159.51, ["Mega"] = 333.78, ["Mega|Ride"] = 799.92, ["Mega|Fly|Ride"] = 984.41}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 262.5, ["Ride"] = 28.5, ["Fly|Ride"] = 84.49, ["Neon"] = 27.57, ["Neon|Ride"] = 32.75, ["Neon|Fly|Ride"] = 282.02, ["Mega"] = 168, ["Mega|Ride"] = 369.69, ["Mega|Fly|Ride"] = 502.78}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 23.6, ["Fly"] = 70.73, ["Ride"] = 30.17, ["Fly|Ride"] = 56.23, ["Neon"] = 228.74, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 322.88, ["Mega"] = 949.55, ["Mega|Ride"] = 959.42, ["Mega|Fly|Ride"] = 729.86}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 47.83, ["Fly"] = 874.13, ["Ride"] = 84.49, ["Neon|Ride"] = 479.59, ["Mega|Ride"] = 590.63}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 49.88, ["Fly"] = 115.5, ["Ride"] = 81.38, ["Fly|Ride"] = 139.12, ["Neon"] = 236.25, ["Neon|Fly"] = 324.15, ["Neon|Ride"] = 276.92, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 1161.85, ["Mega|Ride"] = 1146.51, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 54.87, ["Fly"] = 92.79, ["Ride"] = 81.38, ["Neon"] = 156.03, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 408.19, ["Mega"] = 513.6, ["Mega|Ride"] = 704.51, ["Mega|Fly|Ride"] = 585.01}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 26.12, ["Ride"] = 57.03, ["Neon"] = 125.98, ["Mega"] = 422.5, ["Mega|Ride"] = 775.27, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 11.82, ["Fly"] = 29.96, ["Ride"] = 30.6, ["Fly|Ride"] = 78.75, ["Neon"] = 45.94, ["Neon|Fly"] = 168.95, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 116.28, ["Mega"] = 349.49, ["Mega|Ride"] = 366.52, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 8.46, ["Ride"] = 16.89, ["Fly|Ride"] = 41.78, ["Neon"] = 4.99, ["Neon|Fly"] = 24.89, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 62.99, ["Mega"] = 51.98, ["Mega|Fly"] = 211.26, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1458.18}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 27.78, ["Ride"] = 69.37, ["Fly|Ride"] = 131.25, ["Neon"] = 139.13, ["Neon|Ride"] = 157.97, ["Neon|Fly|Ride"] = 299.98, ["Mega"] = 492.21, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 522.38}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 56.44, ["Neon"] = 3.93, ["Neon|Ride"] = 41.92, ["Neon|Fly|Ride"] = 295.75, ["Mega"] = 37.85, ["Mega|Ride"] = 92.86, ["Mega|Fly|Ride"] = 550.48}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 23.91, ["Fly"] = 112.68, ["Ride"] = 47.22, ["Neon"] = 208.31, ["Neon|Fly"] = 197.46, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 708.75, ["Mega|Ride"] = 947.44, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 6.46, ["Neon|Ride"] = 105, ["Mega"] = 23.25, ["Mega|Fly|Ride"] = 704.51}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 4.8, ["Neon|Ride"] = 160.68, ["Mega"] = 28.4, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 127.95, ["Ride"] = 131.25, ["Fly|Ride"] = 184.58, ["Neon"] = 426.57, ["Neon|Fly"] = 630.46, ["Neon|Ride"] = 518.44, ["Neon|Fly|Ride"] = 522.43, ["Mega|Ride"] = 6595.92, ["Mega|Fly|Ride"] = 1865.34}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 26.11, ["Ride"] = 21.13, ["Fly|Ride"] = 71.46, ["Neon"] = 14.4, ["Neon|Fly"] = 63.37, ["Neon|Ride"] = 35.43, ["Neon|Fly|Ride"] = 156.33, ["Mega"] = 91.88, ["Mega|Ride"] = 138.37, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Ride"] = 131.24, ["Fly|Ride"] = 86.63, ["Neon"] = 3.93, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 47.25, ["Mega|Ride"] = 103.52, ["Mega|Fly|Ride"] = 116.82}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.15, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.35, ["Mega"] = 30.83, ["Mega|Ride"] = 223.65, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.94, ["Neon|Ride"] = 29.89, ["Mega"] = 38.66, ["Mega|Ride"] = 95.7, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 39.26, ["Ride"] = 111.57, ["Fly|Ride"] = 1055.84, ["Neon"] = 268.2, ["Neon|Ride"] = 407.69, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1549.49, ["Mega|Ride"] = 1549.49, ["Mega|Fly|Ride"] = 1279.62}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 6.57, ["Ride"] = 36.53, ["Neon"] = 28.48, ["Neon|Ride"] = 262.5, ["Mega"] = 126.6, ["Mega|Ride"] = 830.17}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 1.94}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 384.62, ["Ride"] = 400.14, ["Fly|Ride"] = 616.88, ["Neon"] = 1408.5, ["Neon|Ride"] = 799.44, ["Neon|Fly|Ride"] = 1055.17, ["Mega|Ride"] = 3802.39, ["Mega|Fly|Ride"] = 3432.22}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 1.94}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 77.05}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 44.01}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 19.88}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 18.36}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 31.41}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 41.99}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 6.97}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 4.83}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 210}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 20.98}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 45.93}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 9.06}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 9.14}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 257.41}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 5.24}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 4.93}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 6.04}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 4.59}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 23.72}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 406.88}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 652.61}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 8.53}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1441.13}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 70.71}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 6.3}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 13.12}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 20.04}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 86.52}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 43.32}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 14.42}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 14.7}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 18.34}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 2.49}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 19.36}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 3.31}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 39.35}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 17.99}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.51}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1640.63}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 64.22}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 308.23}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 9.6}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 10.56}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 157.45}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 9.9}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 9.19}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 1001.32}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 19.59}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 3.93}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 19.68}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 6.02}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 137.76}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 17.05}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 9.19}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 22.32}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 11.28}},
    ["rbxassetid://1265129203"] = {name = "Ice Snowboard", prices = {["default"] = 262.5}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 2.1}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 32.43}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 114.19}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 143.77}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 6.56}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 19.67}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 39.09}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 72.19}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 64.92}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22761.98}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 170.6}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 30.18}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 78.62}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 26.25}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 59.06}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 52.49}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 45.94}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 196.88}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 115.31}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 30.17}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 45.93}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 41.82}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 44.86}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 262.48}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 354.36}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 9.19}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 8.32}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 7.19}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 20.98}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 37.35}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.23}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 2.1}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 5.25}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 1071}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 5.92}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 631.92}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 23.61}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 40.68}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 65.63}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 27.15}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 36.75}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 223.69}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 15.74}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.92}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 15.02}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.91}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 4.87}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 34.13}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.93}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.59}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 2.1}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 17.72}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 164.07}},
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
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1012.88}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 15.74}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 7.84}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 7.49}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 10.48}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 85.32}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 10.48}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 7.86}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 8.07}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 13.47}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 104.98}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 25.87}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 7.87}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 2.25}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 3.93}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 6.56}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 14.39}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 2.49}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 6.28}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 5.2}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 5670}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 23.63}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.21}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 7.86}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.59}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.61}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 20.41}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 7.23}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.92}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 15.57}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 105}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 32.24}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 3.91}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 5.15}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 3.93}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.62}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4474.54}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 4.61}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 45.87}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 2.1}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 81.36}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 3.82}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 278.25}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.23}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.45}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 4.8}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 9.53}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 14.7}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.5}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.67}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.49}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 13.13}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 6.51}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.35}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 6.17}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 3.94}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.2}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 4.78}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.61}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 36.93}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 152.15}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.52}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 8.44}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 76.94}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.31}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 89.73}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 19.26}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 984.38}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 18.34}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 5.25}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 3.93}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 27.54}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 7.6}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 11.82}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 11.82}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 15.7}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 15.75}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 3.94}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.66}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 6.35}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 17.07}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 8.9}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.5}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 47.82}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.94}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 3.91}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 141.4}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 10.5}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 63.4}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.63}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 11.48}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 4.78}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 2.1}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 49.88}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 25.54}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.93}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 104.94}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 11.82}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 6.57}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.49}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 5.25}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 5.8}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 17.07}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 86.61}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 112.74}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 5.25}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1199.63}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 4.78}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 154.77}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 4.96}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 10.5}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 52.49}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.63}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 5.13}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.59}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 124.68}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 11.58}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 2.52}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 11.82}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 39.34}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 4.41}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 57.72}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 3.94}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 3.92}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 27.18}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 94.49}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.63}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.6}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 69.55}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 4.82}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 68.22}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 64.32}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 111.57}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 353.04}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 91.88}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 252.17}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.93}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 15.58}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 49.88}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.83}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 36.72}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.15}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 7.66}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 7.88}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 43.32}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 13.13}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 7.29}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 7.56}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 23.61}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 45.92}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 5.1}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 3.28}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 32.28}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 7.69}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 52.37}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 32.8}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 26.23}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1637.48}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 4.6}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 6.57}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 65.49}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 271.67}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 11.82}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 9.59}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 7.83}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 8.97}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 4.13}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 156.19}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 45.94}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 41.93}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 11.37}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 73.48}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 105}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 78.75}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1650.86}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 167.2}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 7.88}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1312.5}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 354.38}},
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